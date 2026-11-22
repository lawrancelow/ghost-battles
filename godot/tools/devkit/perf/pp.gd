# [perf] 效能量度（第一期效能線）：村子（主角）／大排檔／夜潮大排檔，逐層隱藏比較平均每格耗時，並截圖
# 用法：tools/devkit/perf/run.sh <tag> [smooth]；輸出 /tmp/perfw/<tag>/{log,*.png}
extends RefCounted
const ZD = preload("res://game/zone/zone_data.gd")
var out := ""
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
var gpu := 0.0
func _ms(t, secs := 3.0) -> float:
	await _w(t, 0.25)
	var rid = t.get_viewport().get_viewport_rid()
	RenderingServer.viewport_set_measure_render_time(rid, true)
	var n = 0; var t0 = Time.get_ticks_usec(); var g = 0.0
	while Time.get_ticks_usec() - t0 < secs * 1e6:
		await RenderingServer.frame_post_draw; n += 1
		g += RenderingServer.viewport_get_measured_render_time_gpu(rid)
	gpu = g / max(1, n)
	return (Time.get_ticks_usec() - t0) / 1000.0 / max(1, n)
# 開／關交替量三輪，抵銷機器負載漂移：回 [平均省幾多 ms, 開時平均]
func _ab(t, c: CanvasItem) -> Array:
	var d = 0.0; var on_s = 0.0
	for r in 3:
		var a = await _ms(t, 1.3)
		c.visible = false
		var b = await _ms(t, 1.3)
		c.visible = true
		d += a - b; on_s += a
	return [d / 3.0, on_s / 3.0]
func _shot(t, name: String):
	await _w(t, 0.5); await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(out + "/" + name + ".png")
func _dc(t) -> Vector2:
	var a = Vector2.ZERO
	for i in 4:
		await RenderingServer.frame_post_draw
		a += Vector2(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))
	return a / 4.0
# 收埋一組之後 draw call／primitive 少咗幾多（冇噪音）
func _dch(t, arr: Array) -> Vector2:
	var a = await _dc(t)
	for c in arr: c.modulate.a = 0.0   # 用透明度收（nv_village 每格會將 statics／segs 嘅 visible 設返 true）
	var b = await _dc(t)
	for c in arr: c.modulate.a = 1.0
	return a - b
func _find(n: Node, nm: String) -> Node:
	if n.name == nm: return n
	for c in n.get_children():
		var r = _find(c, nm)
		if r: return r
	return null
func all(t):
	out = OS.get_environment("BS_OUT"); DirAccess.make_dir_recursive_absolute(out)
	var m = null
	for i in 120:
		await _w(t, 0.5)
		m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	m._hide_title(); await _w(t, 1.0)
	for i in 8:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.25)
	var S = J.G.S
	while J.num(S.lv) < 5: J.cl(J.G.get("give"), null, [{"exp": 5.0}])
	for i in 80:
		await _w(t, 0.2)
		if m.story.cur != null: m.story.skip_scene()
	if OS.get_environment("PF_SMOOTH") == "1":
		var SM = load("res://ui/perf_mode.gd")
		SM.set_on(true, m)
		await _w(t, 1.0)
	var nv = m.village
	var lay_names = ["ground", "lily", "zunder", "va_mist", "va_mist_f", "mist", "va_dark", "zover", "topfx", "va_night", "topui", "va_fx", "va_fog"]
	var res := {}
	for spot in ["village", "market", "night"]:
		var cam = nv.zone_cam()
		if spot == "village": cam.center_on(Vector2(J.num(J.G.Village.hero.x), J.num(J.G.Village.hero.y)))
		else: cam.center_on(ZD.zrect("market").get_center())
		if spot == "night":
			var sc0 = _find(nv, "MvScene")
			if sc0 and sc0.sim: sc0.sim.plus.ps(sc0.sim)["tide_t"] = sc0.sim.plus.tide_first(sc0.sim) + 1.0
		await _w(t, 0.8)
		for i in 4:
			if m.story.cur != null: m.story.skip_scene()
		await _shot(t, spot)
		var base = 0.0; var nb = 6 if OS.get_environment("PF_BASE") == "1" else 3
		for k in nb: base += await _ms(t)
		base /= float(nb)
		print("[pf] %s base %.1fms (gpu %.2fms)" % [spot, base, gpu])
		res[spot + ":base"] = base
		var tp = 0.0
		for k in 20:
			await RenderingServer.frame_post_draw; tp += Performance.get_monitor(Performance.TIME_PROCESS)
		var NBs = load("res://ui/nv_bake.gd") if ResourceLoader.exists("res://ui/nv_bake.gd") else null
		if NBs != null and NBs.get("stats") != null:
			var b0 = NBs.stats.bake
			await _w(t, 1.0)
			print("[pf] %s 烘圖：累計 %d 次，1 秒內新烘 %d 次，SubViewport %d 個" % [spot, NBs.stats.bake, NBs.stats.bake - b0, nv.get_node("perf_bake").get_child_count() if nv.has_node("perf_bake") else 0])
		print("[pf] %s process(腳本)平均 %.1fms  drawcalls=%d prims=%d objs=%d" % [spot, tp / 20.0 * 1000.0, Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)])
		if OS.get_environment("PF_QUICK") == "1" and spot != "night":
			var rw = await _ab(t, nv.world)
			print("[pf] %s 成個村子世界(world) 佔 %.1fms" % [spot, rw[0]])
			# 按類別分組（ysort 入面）
			var groups := {}
			for c in nv.ysort.get_children():
				if not (c is CanvasItem) or not c.visible: continue
				var tg = str(c.get("tag")) if c.get("tag") != null else c.get_class()
				if tg.begins_with("st_"): tg = tg.substr(0, 5)
				if not groups.has(tg): groups[tg] = []
				groups[tg].append(c)
			var all_l = []
			for c in nv.world.get_children(): all_l.append(c)
			all_l.append(_find(nv, "MvScene"))
			for c in all_l:
				if c == null or not c.visible: continue
				var nm = str(c.get("tag")) if c.get("tag") != null else str(c.name)
				if c == nv.ysort: nm = "ysort"
				var dd = await _dch(t, [c])
				print("[pf] %s 層 %-10s drawcalls %d  prims %d" % [spot, nm, dd.x, dd.y])
			for g in groups:
				var dg = await _dch(t, groups[g])
				print("[pf] %s ysort 組 %-8s ×%d drawcalls %d prims %d" % [spot, g, groups[g].size(), dg.x, dg.y])
			for g in groups:
				if OS.get_environment("PF_GT") != "1": break
				var d = 0.0
				for r in 3:
					var a = await _ms(t, 1.2)
					for c in groups[g]: c.visible = false
					var b = await _ms(t, 1.2)
					for c in groups[g]: c.visible = true
					d += a - b
				print("[pf] %s ysort 組 %-8s ×%d 佔 %.1fms" % [spot, g, groups[g].size(), d / 3.0])
			var ru = await _ab(t, nv.zone_under)
			print("[pf] %s zunder 佔 %.1fms" % [spot, ru[0]])
			var mvs0 = _find(nv, "MvScene")
			if mvs0:
				var rm = await _ab(t, mvs0)
				print("[pf] %s MvScene 佔 %.1fms" % [spot, rm[0]])
				var rs = await _ab(t, mvs0.stage)
				var ds = await _dch(t, [mvs0.stage])
				print("[pf] %s MvScene.stage(畫) 佔 %.1fms drawcalls %d prims %d" % [spot, rs[0], ds.x, ds.y])
				var ro = await _ab(t, mvs0.over)
				print("[pf] %s MvScene.over 佔 %.1fms" % [spot, ro[0]])
		if OS.get_environment("PF_QUICK") == "1" or OS.get_environment("PF_BASE") == "1": continue
		var kids = []
		for c in nv.world.get_children():
			if c is CanvasItem and c.visible and (str(c.get("tag")) in lay_names or str(c.name) in lay_names or c == nv.ysort): kids.append(c)
		var mvs = _find(nv, "MvScene")
		if mvs and mvs.visible: kids.append(mvs)
		if nv.hero_ol != null and nv.hero_ol.visible: kids.append(nv.hero_ol)
		var hg = nv.ysort.get_node_or_null("hero_grp")   # 改之後：主角描邊 CanvasGroup
		if hg != null and hg.visible: kids.append(hg)
		for c in kids:
			var nm = str(c.get("tag")) if c.get("tag") != null else str(c.name)
			if c == nv.ysort: nm = "ysort"
			var r = await _ab(t, c)
			var dd2 = await _dch(t, [c])
			print("[pf] %s 層 %-10s 佔 %.1fms  drawcalls %d prims %d" % [spot, nm, r[0], dd2.x, dd2.y])
			res[spot + ":" + nm] = r[0]
		# 全部全畫面覆蓋層一齊收
		var ov = []
		for c in kids:
			var nm2 = str(c.get("tag")) if c.get("tag") != null else str(c.name)
			if nm2 in ["va_mist", "va_mist_f", "mist", "va_dark", "zover", "topfx", "va_night", "va_fx", "va_fog"]: ov.append(c)
		var d2 = 0.0
		for r in 3:
			var a2 = await _ms(t, 1.3)
			for c in ov: c.visible = false
			var b2 = await _ms(t, 1.3)
			for c in ov: c.visible = true
			d2 += a2 - b2
		print("[pf] %s 全部全畫面覆蓋層(%d) 合共佔 %.1fms" % [spot, ov.size(), d2 / 3.0])
		print("[pf] %s ysort children %d" % [spot, nv.ysort.get_child_count()])
	print("[pf] done")
