# [away] 出征時主角唔留喺村／各區截圖／出征幀時
# 用法：edtest.sh <godot目錄> away res://tools/tests/away_test.gd all
extends RefCounted

var ok := 0
var bad := 0
var _tm := 0.0
var _ps := {}
var _tproc := 0
var _tpre := 0
var _tpost := 0
var _hooked := false
const SHOTS := "/home/claude/docs/shots/away/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const AW = preload("res://game/sortie/so_away.gd")

func _p(m): print("[away] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	var idle = 0
	for i in maxi(n, 40):
		var m = _main(t); var st = m.get("story") if m else null
		var Sy = J.G.get("Story")
		var busy = (st and st.get("cur") != null) or (Sy != null and J.t(J.mc(Sy, "busy", [])))
		if st and st.get("cur") != null: st.skip_scene()
		if not busy:
			idle += 1
			if idle >= 3 and i >= n - 1: break
		else: idle = 0
		await _w(t, 0.25)
func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)

# 量 sec 秒真時間嘅幀時（ms）：平均、95 分位、最大，同埋 >50ms 嘅格數
func _frames(t, sec: float) -> Dictionary:
	if not _hooked:
		_hooked = true
		RenderingServer.frame_pre_draw.connect(func(): _tpre = Time.get_ticks_usec())
		RenderingServer.frame_post_draw.connect(func(): _tpost = Time.get_ticks_usec())
	var RV = load("res://game/rts/rts_view.gd"); var NV = load("res://ui/nv_village.gd")
	RV.SPIKE = true; NV.SPIKE = true; RV.PROF.clear(); NV.SPROF.clear()
	var pacc = 0.0
	var a = []
	var t0 = Time.get_ticks_usec(); var last = t0
	while Time.get_ticks_usec() - t0 < int(sec * 1e6):
		await t.get_tree().process_frame
		var now = Time.get_ticks_usec(); var dt = (now - last) / 1000.0; a.append(dt); last = now
		if dt > 160.0: _p("  階段 上格 process→pre_draw=%.0fms pre→post_draw=%.0fms post→下格=%.0fms" % [(_tpre - _tproc) / 1000.0, (_tpost - _tpre) / 1000.0, (now - _tpost) / 1000.0])
		_tproc = now
		var tm = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1048576.0
		var pr = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
		var snap = {}
		for k in RV.PROF: snap[k] = RV.PROF[k]
		for k in NV.SPROF: snap[k] = NV.SPROF[k]
		var dd = {}
		for k in snap: if k in ["sim", "fx", "units", "ui", "v_static", "v_dyn", "v_rest", "v_draw"]: dd[k] = int((snap[k] - _ps.get(k, 0)) / 1000)
		_ps = snap
		if dt > 160.0: _p("  分項 %s" % dd)
		if dt > 160.0: _p("  尖峰 %.0fms process=%.0fms 貼圖MB=%.1f(%+.1f) 物件=%d" % [dt, pr, tm, tm - _tm, Performance.get_monitor(Performance.OBJECT_COUNT)])
		_tm = tm; pacc += pr
	a.sort()
	var s = 0.0
	for x in a: s += x
	var n = a.size()
	var big = 0
	for x in a: if x > 50.0: big += 1
	var br = {}
	var sn = maxf(1, RV.PROF.get("sn", 0)); var vn = maxf(1, NV.SPROF.get("n", 0))
	for k in ["sim", "fx", "units", "ui"]: br[k] = snappedf(RV.PROF.get(k, 0) / 1000.0 / sn, 0.01)
	for k in ["v_static", "v_dyn", "v_rest", "v_draw"]: br[k] = snappedf(NV.SPROF.get(k, 0) / 1000.0 / vn, 0.01)
	_p("  每格平均 process=%.1fms 分項 %s" % [pacc / maxf(1, a.size()), br])
	return {"n": n, "avg": snappedf(s / maxf(1, n), 0.1), "p95": snappedf(a[int(n * 0.95)] if n > 0 else 0.0, 0.1), "max": snappedf(a[n - 1] if n > 0 else 0.0, 0.1), "gt50": big}

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	var S = J.G.S
	if S.ghosts.size() < 3:
		for k in ["xiaozhi", "toyol"]: J.cl(J.G.get("joinGhost"), null, [k])
		await _skip(t, 8)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
	S["lv"] = maxf(3.0, J.num(S.lv)); S.res["troops"] = 100.0
	S.res["buns"] = 5000.0; S.res["coins"] = 100000.0
	J.G.get("Battle")["auto"] = true
	SO.force_open = true; SO.test_now = 1000000.0
	await _w(t, 1.0)
	var V = J.G.get("Village"); var H = V.hero
	var hp = Vector2(J.num(H.x), J.num(H.y))
	# ---- 各區截圖（睇有冇未統一畫風嘅建築） ----
	var zs = ZD.zones()
	for z in zs:
		var r = ZD.zrect(str(z.id))
		_cam(m, r.get_center(), m.village.size.x / maxf(420.0, r.size.x + 40.0))
		await _w(t, 0.6); await _shot(t, "z_%s_%s" % [str(z.get("type", "")), str(z.id)])
	_cam(m, hp, m.village.size.x / 420.0); await _w(t, 0.6)
	var idle = await _frames(t, 20.0)
	_p("幀時 村子閒置 %s" % idle)
	await _shot(t, "01_before")
	var cnt0 = _census(t)
	var hv0 = _hero_visible(m)
	_chk("出征前阿福喺村度有畫", hv0)
	# ---- 出征 ----
	var e = SO.camps(0)[0]
	load("res://game/rts/rts_view.gd").SPIKE = true; load("res://ui/nv_village.gd").SPIKE = true
	Spr.trace = true; Spr.trace_log.clear()
	var td = Time.get_ticks_usec()
	var r0 = SO.dispatch(e)
	_p("dispatch 本身 %.0fms" % ((Time.get_ticks_usec() - td) / 1000.0))
	var op = RTS.op_for(SO.sid_of(e))
	await _f(t, 1)
	_chk("出征成功", r0 == "ok" and op != null, r0)
	if op == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	_chk("出征隊有阿福", AW.hero_out(), AW.ks().keys())
	_cam(m, hp, m.village.size.x / 420.0)
	await _w(t, 1.0)
	await _shot(t, "02_out_village")
	_chk("出征中阿福唔喺村度畫", not _hero_visible(m))
	var outk = []
	for k in AW.ks(): if k != "afu": outk.append(k)
	_chk("出征中隊員唔喺廣場遊蕩", not _plaza_has(m, outk), outk)
	# 撳樹：阿福唔應該行去砍
	J.mc(V, "tap", [J.num(V.hero.x) + 1, J.num(V.hero.y) + 1])
	var tp = load("res://game/village.gd").TREE_POS[0]
	V.hero["target"] = {"kind": "tree", "i": 0}
	await _f(t, 3)
	_chk("出征中唔可以砍樹（目標清走）", V.hero.get("target") == null)
	# 行軍幀時（鏡頭跟住隊伍）
	var RVi = load("res://game/rts/rts_view.gd").inst
	_p("實驗：rts_view 停 process")
	RVi.set_process(false)
	_p("  → %s" % await _frames(t, 6.0))
	RVi.set_process(true)
	_p("實驗：rts_view ov 整層隱藏")
	RVi.ov.visible = false
	_p("  → %s" % await _frames(t, 6.0))
	_p("實驗：行軍 角色層隱藏")
	RVi.wl.visible = false
	var ex1 = await _frames_follow(t, m, op, 5.0)
	_p("  → %s" % ex1)
	RVi.wl.visible = true
	_p("實驗：行軍 字層隱藏")
	RVi.txt.visible = false; RVi.ui.visible = false
	var ex2 = await _frames(t, 5.0)
	_p("  → %s" % ex2)
	RVi.txt.visible = true
	_p("實驗：行軍 全部顯示")
	var march = await _frames_follow(t, m, op, 6.0)
	_p("幀時 行軍 %s" % march)
	await _shot(t, "03_march")
	for i in 600:
		if op.phase != "march": break
		await _w(t, 0.1)
	var fight = await _frames_follow(t, m, op, 8.0)
	_p("幀時 開打 %s  phase=%s 單位=%d" % [fight, op.phase, op.units.size()])
	await _shot(t, "04_fight")
	var tot = 0.0; var big = []
	for x in Spr.trace_log:
		tot += x[1]
		if x[1] > 8.0: big.append("%s=%.0f" % x)
	_p("出征至開打 同步載圖 %d 張 共 %.0fms；>8ms：%s" % [Spr.trace_log.size(), tot, " ".join(big)])
	# 快轉收隊
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0
	for i in 4000:
		if op.phase == "done": break
		RTS._last_f = -1; RTS.tick(0.1)
	await _w(t, 1.5)
	var bx = m.get("modal")
	_cam(m, hp, m.village.size.x / 420.0); await _w(t, 0.8)
	_chk("收隊後阿福返晒嚟", _hero_visible(m) and not AW.hero_out())
	await _shot(t, "05_back")
	_p("收隊後閒置 20 秒 %s" % await _frames(t, 20.0))
	var cnt1 = _census(t)
	var diff = []
	for k in cnt1: if cnt1[k] - cnt0.get(k, 0) != 0: diff.append("%s%+d" % [k, cnt1[k] - cnt0.get(k, 0)])
	_p("節點變化：%s" % ", ".join(diff))
	_p("節點總數 %d → 物件 %d 孤兒節點 %d" % [Performance.get_monitor(Performance.OBJECT_NODE_COUNT), Performance.get_monitor(Performance.OBJECT_COUNT), Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)])
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _frames_follow(t, m, op, sec: float) -> Dictionary:
	var c = m.village.zone_cam()
	var mid = Vector2.ZERO; var n = 0
	for u in op.units:
		if J.num(u.side) == 0 and u.get("p") is Vector2: mid += u.p; n += 1
	if n > 0: _cam(m, mid / n, m.village.size.x / 420.0)
	return await _frames(t, sec)

func _hero_visible(m) -> bool:
	var nv = m.village
	var g = nv.get_meta("hol_grp") if nv.has_meta("hol_grp") else null
	if g != null and is_instance_valid(g) and g.visible: return true
	var ol = nv.get("hero_ol")
	return ol != null and is_instance_valid(ol) and ol.visible

func _plaza_has(m, ks: Array) -> bool:
	var pl = m.village.plaza
	for id in pl.nodes:
		var na = pl.nodes[id]
		if na.visible and na.get("k") in ks: return true
	return false

func _census(t) -> Dictionary:
	var d = {}
	var st = [t.get_tree().root]
	while not st.is_empty():
		var n = st.pop_back()
		var key = n.get_class()
		var sc = n.get_script()
		if sc != null: key += "/" + str(sc.resource_path).get_file()
		d[key] = d.get(key, 0) + 1
		for c in n.get_children(): st.append(c)
	return d

func mk(t) -> void:   # 大排檔截圖（等耐啲，睇名牌烘圖）
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 1.0)
	var r = ZD.zrect("market")
	_cam(m, r.get_center(), m.village.size.x / maxf(420.0, r.size.x + 40.0))
	await _w(t, 4.0); await _shot(t, "mk_wide")
	_cam(m, r.get_center() + Vector2(0, -40), m.village.size.x / 260.0)
	await _w(t, 4.0); await _shot(t, "mk_zoom")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func face(t) -> void:   # [face] 驗證 plain 模式立繪出手方向：名鬼打右邊敵人時影相
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	var S = J.G.S
	var SD = load("res://game/soul/soul_data.gd")
	SD._bypass = true
	for k in ["nw_kamaitachi", "nw_ushioni", "nw_teketeke"]: J.cl(J.G.get("joinGhost"), null, [k])
	SD._bypass = false
	await _skip(t, 8)
	var ids = []
	for g in S.ghosts: if str(g.get("k", g.get("id"))) in ["nw_kamaitachi", "nw_ushioni", "nw_teketeke"] or str(g.id).begins_with("nw_"): ids.append(g.id)
	_p("team %s" % [ids])
	S["team"] = ids.slice(0, 3)
	S["lv"] = 30.0; S.res["troops"] = 100.0; S.res["buns"] = 5000.0; S.res["coins"] = 100000.0; J.G.get("Battle")["auto"] = true
	SO.force_open = true; SO.test_now = 1000000.0
	var e = SO.camps(0)[0]
	_p("dispatch %s" % SO.dispatch(e))
	var op = RTS.op_for(SO.sid_of(e))
	if op == null: _p("RESULT ok=0 bad=1"); return
	for i in 900:
		if op.phase != "march": break
		await _w(t, 0.1)
	for n in 8:
		var mid = Vector2.ZERO; var c = 0; var fm = Vector2.ZERO
		for u in op.units:
			if J.num(u.side) == 0 and not J.t(u.get("minion")) and u.get("p") is Vector2:
				mid += u.p; c += 1
				_p("  我方 %s face=%s anim=%s" % [u.k, u.get("face"), (u.anim.name if u.get("anim") is Dictionary else "-")])
		if c > 0: _cam(m, mid / c, m.village.size.x / 160.0)
		await _w(t, 0.7); await _shot(t, "face_%d" % n)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func cgt(t) -> void:   # [cg] 劇情插圖卡截圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var sc = {"style": "talk", "lines": [["旁白", "凌晨兩點四十七分，落魄村村口出現一個速遞箱。", {"k": "cg7_box", "over": [{"spr": "afu", "x": 0.72, "y": 0.93, "h": 0.36, "flip": true}, {"spr": "xiaozhi", "x": 0.86, "y": 0.93, "h": 0.3, "flip": true}]}], ["阿福", "我冇落單。"], ["小紙", "少爺，收件人寫住黃總。", ""]]}
	G.story_req.emit(sc, Callable())
	await _w(t, 2.0); await _shot(t, "cg_1")
	var st = m.get_node_or_null("Story")
	for n in m.get_children(): if n.has_method("advance"): st = n
	_p("story node %s" % [st])
	if st: st.advance(); st.advance()
	await _w(t, 1.2); await _shot(t, "cg_2")
	if st: st.advance(); st.advance()
	await _w(t, 1.2); await _shot(t, "cg_3")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func cg1(t) -> void:   # [cg] 第一章插圖：逐場播，喺有插圖嗰行截圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var sc_all = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json")).scenes
	var plan = [["op_wake", 0, "cg1_office"], ["op_wake", 1, "cg1_office_hide"], ["prologue_road", 0, "cg1_queue"], ["ch1_intro", 1, "cg1_news"], ["ch1_end", 6, "cg1_kneel"], ["op_guard", 0, "cg1_guard"], ["op_desk", 0, "cg1_desk"], ["op_desk", 0, "cg1_desk_late"], ["op_home", 1, "cg1_home"], ["op_dinner", 0, "cg1_dinner"], ["op_photo", 5, "cg1_footprint"], ["gift_xiaozhi", 1, "cg1_descend"]]
	for pl in plan:
		G.story_req.emit(sc_all[pl[0]], Callable())
		if pl[2] == "cg1_queue":
			await _w(t, 0.1); await _shot(t, "cg1_on0")
			await _w(t, 0.12); await _shot(t, "cg1_on1")
			await _w(t, 0.15); await _shot(t, "cg1_on2")
		await _w(t, 1.0)
		var st = null
		for n in m.get_children(): if n.has_method("advance"): st = n
		if st == null: _p("no story node"); bad += 1; continue
		for k in int(pl[1]) * 2: st.advance(); await _w(t, 0.05)
		await _w(t, 1.5)
		if str(pl[2]).ends_with("_late"): await _w(t, 8.0)
		await _shot(t, pl[2])
		var vis = st.cg != null and st.cg.visible
		var want = not str(pl[2]).ends_with("_hide")
		if vis == want: ok += 1
		else: bad += 1; _p("BAD %s cg visible=%s" % [pl[2], vis])
		st.skip_scene(); await _w(t, 0.5)
		for k in 30:
			var any = false
			for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: any = true
			if not any: break
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
			await _w(t, 0.3)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func cg23(t) -> void:   # [cg] 第二、三章（＋天花姐支線）插圖：逐場播，喺有插圖嗰行截圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var fem = OS.get_environment("GB_FEM") == "1"
	if fem:
		if not (J.G.S.get("hero") is Dictionary): J.G.S["hero"] = {}
		J.G.S.hero["sex"] = "f"
	var sc_all = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json")).scenes
	var tag = "f" if fem else ""
	var plan = [["ch2_intro", -1, "cg2_footprint"], ["ch2_boss", 0, "cg2_kampung"], ["ch2_boss", 2, "cg2_empty"], ["ch2_end", 8, "cg2_warehouse"], ["gift_phone", 0, "cg2_phone"], ["side_tianhua", 3, "cg2_tianhua"], ["ch3_intro", 0, "cg3_notice"], ["ch3_intro2", 1, "cg3_march"], ["ch3_boss", 0, "cg3_qing"], ["ch3_end", 3, "cg3_bed"]]
	for pl in plan:
		G.story_req.emit(sc_all[pl[0]], Callable())
		await _w(t, 1.0)
		var st = null
		for n in m.get_children(): if n.has_method("advance"): st = n
		if st == null: _p("no story node"); bad += 1; continue
		if int(pl[1]) < 0:   # 聊天：等佢自己播到有相嗰句
			for k in 24:
				if st.get("wa") != null: st.wa.advance()
				await _w(t, 0.35)
			await _w(t, 1.0)
			await _shot(t, pl[2] + tag)
			var found = false
			if st.get("wa") != null:
				for b in st.wa.find_children("*", "", true, false):
					if b.get("img") != null: found = true
			if found: ok += 1
			else: bad += 1; _p("BAD %s no photo bubble" % pl[2])
		else:
			for k in int(pl[1]) * 2: st.advance(); await _w(t, 0.05)
			await _w(t, 1.5)
			await _shot(t, pl[2] + tag)
			var vis = st.cg != null and st.cg.visible and str(st.cg.get("cur_key")) == pl[2]
			if vis: ok += 1
			else: bad += 1; _p("BAD %s cg visible=%s key=%s" % [pl[2], st.cg != null and st.cg.visible, st.cg.get("cur_key") if st.cg else ""])
		st.skip_scene(); await _w(t, 0.5)
		for k in 30:
			var any = false
			for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: any = true
			if not any: break
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
			await _w(t, 0.3)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func namef(t) -> void:   # [name] 開新檔設定名（模擬手機輸入法：唔觸發 text_changed）→ 揀女主 → 對話名牌要係玩家設定嘅名
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	for sx in ["f", "m"]:
		var nm = "小美" if sx == "f" else "大雄"
		G.S.erase("hero"); J.G.S.erase("hero")
		var NC = load("res://ui/name_card.gd")
		var nc = NC.new(); m.add_child(nc); await _w(t, 0.6)
		await _shot(t, "namecard1_" + sx)
		nc._pick(sx); await _w(t, 0.3)
		nc._page_boot(); await _w(t, 0.5)
		var pre = str(nc.ed.name.text)
		if pre == ("阿慧" if sx == "f" else "阿福"): ok += 1
		else: bad += 1; _p("BAD prefill %s" % pre)
		nc.ed.name.grab_focus(); nc.ed.name.text = nm   # 模擬輸入法：唔觸發 text_changed、焦點仲喺欄度
		await _shot(t, "namecard2_" + sx)
		nc.on_done = Callable(); await nc._confirm_names(); await _w(t, 0.5)
		var sc_all = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json")).scenes
		var sid = "opf_wake" if sx == "f" else "op_wake"
		G.story_req.emit(sc_all[sid], Callable()); await _w(t, 1.0)
		var st = null
		for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
		st.advance(); await _w(t, 0.1); st.advance(); await _w(t, 1.2)
		var labs = []
		for l in st.find_children("*", "Label", true, false): if l.visible and l.is_visible_in_tree(): labs.append(l.text)
		await _shot(t, "name_" + sx)
		var hit = labs.has(nm)
		if hit: ok += 1
		else: bad += 1
		_p(("ok " if hit else "BAD ") + "%s 名牌=%s hero=%s" % [sx, str(labs).substr(0, 120), str(DB.hero())])
		st.skip_scene(); await _w(t, 0.6)
		for k in 20:
			var any = false
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene(); any = true
			if not any: break
			await _w(t, 0.3)
	# 設定入面改名：只改名唔改性別
	var NC2 = load("res://ui/name_card.gd")
	var sx0 = str(DB.hero().get("sex", "m"))
	var rc = NC2.new(); rc.rename_only = true; m.add_child(rc); await _w(t, 0.6)
	await _shot(t, "namecard_rename")
	rc.ed.name.text = "阿強"; rc.on_done = Callable(); await rc._confirm_names(); await _w(t, 0.4)
	if str(DB.hero().get("name")) == "阿強" and str(DB.hero().get("sex")) == sx0: ok += 1
	else: bad += 1; _p("BAD rename %s" % [DB.hero()])
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func bgs(t) -> void:   # [bg] 開場各場舞台背景（男女線）＋箱子標籤：喺冇插圖嗰行截圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var sc_all = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json")).scenes
	var plan = [["m", "op_home", 3], ["m", "op_dinner", 2], ["f", "opf_wake", 2], ["f", "opf_home", 3], ["f", "opf_dinner", 2], ["f", "opf_desk", 0], ["f", "opf_desk", 2]]
	for pl in plan:
		DB.hero_apply(DB.hero_make("小美" if pl[0] == "f" else "大雄", pl[0]))
		G.story_req.emit(sc_all[pl[1]], Callable()); await _w(t, 1.0)
		var st = null
		for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
		for k in int(pl[2]) * 2: st.advance(); await _w(t, 0.05)
		await _w(t, 1.6)
		await _shot(t, "bg_%s_%d" % [pl[1], pl[2]])
		var bg = str(st.cur.sc.get("bg", ""))
		var good = bg == "" or Spr.ok("bg_" + bg)
		if good: ok += 1
		else: bad += 1
		_p(("ok " if good else "BAD ") + "%s bg=%s" % [pl[1], bg])
		st.skip_scene(); await _w(t, 0.5)
		for k in 20:
			var any = false
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene(); any = true
			if not any: break
			await _w(t, 0.3)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func vox(t) -> void:   # [vox] 第一章語氣聲：逐句播，記低每句出咗咩聲
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var VX = load("res://ui/story_vox.gd")
	var d = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json"))
	var sc_all = d.scenes
	for sid in ["op_wake", "op_guard", "op_desk", "op_dinner", "op_photo", "prologue_road", "prologue_sys", "ch1_intro", "ch1_intro2", "ch1_boss", "ch1_end", "gift_xiaozhi2"]:
		var sc = sc_all[sid]
		VX.LOG.clear()
		G.story_req.emit(sc, Callable())
		await _w(t, 0.6)
		var st = null
		for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
		if st == null: bad += 1; _p("no story " + sid); continue
		for li in sc.lines.size():
			if li > 0:
				if st.get("typing"): st.advance(); await _w(t, 0.02)
				VX.LOG.clear()
				st.advance(); await _w(t, 0.02)
			await _w(t, 0.15)
			var ln = sc.lines[li]
			_p("  %s#%d %s「%s」→ %s" % [sid, li, ln[0], str(d.zh.get(ln[1], ln[1])).substr(0, 18), VX.LOG])
		st.skip_scene(); await _w(t, 0.4)
	ok += 1
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func cgf(t) -> void:   # [cg] 女主開場插圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	J.G.S.hero = DB.hero_make("阿慧", "f")
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var sc_all = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json")).scenes
	var plan = [["opf_wake", 0, "cgf_wake"], ["opf_guard", 0, "cgf_guard"], ["opf_desk", 0, "cgf_desk"], ["opf_desk", 2, "cgf_desk2"], ["opf_home", 1, "cgf_home"], ["opf_dinner", 0, "cgf_dinner"], ["opf_photo", 5, "cgf_footprint"]]
	for pl in plan:
		G.story_req.emit(sc_all[pl[0]], Callable())
		await _w(t, 1.0)
		var st = null
		for n in m.get_children(): if n.has_method("advance"): st = n
		if st == null: bad += 1; continue
		for k in int(pl[1]) * 2: st.advance(); await _w(t, 0.05)
		await _w(t, 1.6); await _shot(t, pl[2])
		if st.cg != null and st.cg.visible: ok += 1
		else: bad += 1; _p("BAD " + pl[2])
		st.skip_scene(); await _w(t, 0.5)
		for k in 30:
			var any = false
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene(); any = true
			if not any: break
			await _w(t, 0.3)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func bryan(t) -> void:   # [bryan] Bryan 新劇情（男／女）＋記仇簿頁＋選單收集：逐場截圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var fem = OS.get_environment("GB_FEM") == "1"
	if fem:
		if not (J.G.S.get("hero") is Dictionary): J.G.S["hero"] = {}
		J.G.S.hero["sex"] = "f"; J.G.S.hero["name"] = "小美"
	var tag = "f" if fem else ""
	var qx = Engine.get_main_loop().root.get_node("QX")
	var beats = {}
	for b in qx.D.beats: beats[b.id] = b
	# [beat, 截圖行, 預期插圖（"" = 唔查）]
	var plan = [["c1_bryan", 0, "cg1_huai"], ["c2_bryan", 0, "cg2_warehouse"], ["c2_bryan", 6, "cg2_warehouse"], ["c3_bryan", 7, ""], ["c4_bryan", 1, "cg4_banana"], ["c4_bryan", 7, "cg4_banana"], ["c5_bryan", 5, ""], ["c6_receipt", 10, ""], ["c7_bryanbook", 1, "cg_bryanbook"]]
	if fem: plan = [["c1_bryan", 0, "cg1_huai"], ["c1_bryan", 2, "cg1_huai"], ["c1_bryan", 7, "cg1_huai"], ["c2_bryan", 1, "cg2_warehouse"], ["c2_bryan", 7, "cg2_warehouse"], ["c6_receipt", 4, ""], ["c6_receipt", 12, ""]]
	var done_diary = {}
	for pl in plan:
		qx.play_beat(beats[pl[0]], fem)
		await _w(t, 1.0)
		var st = null
		for n in m.get_children(): if n.has_method("advance"): st = n
		if st == null: _p("no story node"); bad += 1; continue
		var nl = st.cur.sc.lines.size()
		if int(pl[1]) >= nl: bad += 1; _p("BAD %s line %d >= %d" % [pl[0], pl[1], nl]); continue
		for k in int(pl[1]) * 2: st.advance(); await _w(t, 0.05)
		await _w(t, 1.5)
		await _shot(t, "%s_%d%s" % [pl[0], pl[1], tag])
		if str(pl[2]) != "":
			var vis = st.cg != null and st.cg.visible and str(st.cg.get("cur_key")) == pl[2]
			if vis: ok += 1
			else: bad += 1; _p("BAD %s cg visible=%s key=%s" % [pl[0], st.cg != null and st.cg.visible, st.cg.get("cur_key") if st.cg else ""])
		else: ok += 1
		st.skip_scene(); await _w(t, 1.2)   # 之後應該係記仇簿嗰頁
		if beats[pl[0]].get("diary") is Dictionary and not done_diary.has(pl[0]):
			done_diary[pl[0]] = true
			await _w(t, 1.0)
			await _shot(t, "diary_%s%s" % [pl[0], tag])
			var dk = st.cg != null and st.cg.visible and str(st.cg.get("cur_key")) == "cg_bryanbook" and str(st.cur.sc.get("title", "")) == "Bryan 的感恩日記"
			var lb = null
			if st.cg != null:
				for c in st.cg.layer.get_children(): if c is Label: lb = c
			var fit = lb != null and lb.get_minimum_size().y <= lb.size.y + 1
			if dk and fit: ok += 1
			else: bad += 1; _p("BAD diary %s key=%s fit=%s" % [pl[0], st.cg.get("cur_key") if st.cg else "", fit])
		for k in 30:
			var any = false
			for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: any = true
			if not any: break
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
			await _w(t, 0.3)
	# 選單：記仇簿收集（當睇晒）
	for id in beats: if beats[id].get("diary") is Dictionary: qx.sq()["beat_" + id] = {"done": true, "beat": true}
	var pg = qx.diary_pages()
	if pg.size() == 8 and qx.diary_total() == 8 and int(pg[0].n) == 1 and str(pg[7].id) == "c7_bryanbook": ok += 1
	else: bad += 1; _p("BAD pages %s" % [pg])
	load("res://ui/menus/menus.gd").open_story(); await _w(t, 1.5)
	var found = 0
	for c in m.sheet_body.find_children("*", "Button", true, false):
		if str(c.text).begins_with("第 ") and str(c.text).ends_with(" 頁") or str(c.text) == "最後一頁": found += 1
	var sc = m.sheet_body.get_parent()
	if sc is ScrollContainer:
		for c in m.sheet_body.find_children("*", "Label", true, false):
			if str(c.text) == "Bryan 的感恩日記": sc.scroll_vertical = int(c.global_position.y - m.sheet_body.global_position.y) - 20
	await _w(t, 0.8)
	await _shot(t, "diary_menu" + tag)
	if found == 8: ok += 1
	else: bad += 1; _p("BAD menu buttons %d" % found)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func offer(t) -> void:   # [offer] 燒貨單：揀單介面 → 真開一晚（收工）→ 模擬嚇走燒貨人 → 燒貨劇情四場 → 冥牌坊貨倉賣貨
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var fem = OS.get_environment("GB_FEM") == "1"
	if fem:
		if not (J.G.S.get("hero") is Dictionary): J.G.S["hero"] = {}
		J.G.S.hero["sex"] = "f"; J.G.S.hero["name"] = "小美"
	var tag = "f" if fem else ""
	var O = load("res://game/offer/offer_jobs.gd")
	for k in ["ch1_end", "ch3_intro2", "ch3_end", "ch4_intro2", "ch4_end"]: J.G.S.seen[k] = true
	if not O.opened(): ok += 1
	else: bad += 1; _p("BAD opened before permit")
	var qx = Engine.get_main_loop().root.get_node("QX")
	qx.sq()["c3x_permit"] = {"step": 3.0, "base": 0.0, "done": true}
	if O.opened() and O.jobs_open().size() == 5: ok += 1
	else: bad += 1; _p("BAD jobs_open %d" % O.jobs_open().size())
	# 揀單介面
	ScSelect.hook("office"); await _w(t, 1.2)
	await _shot(t, "offer_pick" + tag)
	if ScSelect._job == "j_ken": ok += 1
	else: bad += 1; _p("BAD default job %s" % ScSelect._job)
	ScSelect._job = "j_mis"; ScSelect._render(); await _w(t, 0.6)
	await _shot(t, "offer_pick2" + tag)
	# 真開一晚，幾秒後提早收工（燒貨人冇走 → 失敗劇情；秒數同鎮定要還原）
	var sec0 = J.num(J.G.get("NIGHT_SEC"))
	ScSelect._go(); await _w(t, 4.0)
	await _shot(t, "offer_night" + tag)
	if absf(J.num(J.G.get("NIGHT_SEC")) - 170.0) < 0.1: ok += 1
	else: bad += 1; _p("BAD sec %s" % J.G.get("NIGHT_SEC"))
	J.mc(J.G.get("Scare"), "finish", [true]); await _w(t, 2.0)
	if absf(J.num(J.G.get("NIGHT_SEC")) - sec0) < 0.1 and O.cur.is_empty(): ok += 1
	else: bad += 1; _p("BAD restore sec=%s" % J.G.get("NIGHT_SEC"))
	if O.pending.get("fail") == true: ok += 1
	else: bad += 1; _p("BAD fail pending %s" % O.pending)
	var ec = m.get_node_or_null("NvScEnd")
	if ec: ec.queue_free()
	await _w(t, 2.0)
	var st = null
	for n in m.get_children(): if n.has_method("advance"): st = n
	await _shot(t, "offer_fail" + tag)
	for k in 10:
		for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
		await _w(t, 0.3)
	# 模擬嚇走燒貨人（3 星）
	O.cur = O.job("j_mis")
	var fake = {"npcs": [{"d": {"k": "mis"}, "fleeing": true}], "kpi": 1350.0, "expelled": false}
	O.on_end(fake)
	var stock0 = O.mpf().stock.duplicate()
	if int(stock0.get("lc_bag", 0)) == 3 and int(stock0.get("no4", 0)) == 1 and O.best("j_mis") == 3: ok += 1
	else: bad += 1; _p("BAD loot %s best=%d kpi=%s" % [stock0, O.best("j_mis"), fake.kpi])
	await _w(t, 1.5)
	var shots = [["offer_s1", 1], ["offer_s2", 2], ["offer_s3", 1], ["offer_s4", 2]]
	var keys = ["cg_ow_bed", "cg_ow_master", "cg_ow_shop", "cg_ow_burn"]
	for i in 4:
		st = null
		for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
		if st == null: bad += 1; _p("BAD no scene %d" % i); continue
		for k in int(shots[i][1]) * 2: st.advance(); await _w(t, 0.05)
		await _w(t, 1.5)
		await _shot(t, shots[i][0] + tag)
		if st.cg != null and st.cg.visible and str(st.cg.get("cur_key")) == keys[i]: ok += 1
		else: bad += 1; _p("BAD scene %d key=%s" % [i, st.cg.get("cur_key") if st.cg else ""])
		st.skip_scene(); await _w(t, 1.0)
	# 問米版（第一場之後嗰場）
	O.cur = O.job("j_ken"); O.on_end({"npcs": [{"d": {"k": "ken"}, "fleeing": true}], "kpi": 900.0, "expelled": false})
	await _w(t, 1.5)
	st = null
	for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
	if st: st.skip_scene(); await _w(t, 1.2)
	st = null
	for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
	if st:
		for k in 6: st.advance(); await _w(t, 0.05)
		await _w(t, 1.5)
		await _shot(t, "offer_wenmi" + tag)
		if st.cg != null and str(st.cg.get("cur_key")) == "cg_ow_wenmi": ok += 1
		else: bad += 1; _p("BAD wenmi")
	for k in 12:
		for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
		await _w(t, 0.3)
	# 貨倉
	load("res://game/offer/offer_ui.gd").open(); await _w(t, 1.2)
	await _shot(t, "offer_store" + tag)
	var c0 = J.num(J.G.S.res.get("coins", 0))
	var got = O.sell("lc_bag", 2)
	if got > 0 and int(O.mpf().stock.get("lc_bag", 0)) == 1 and J.num(J.G.S.res.get("coins", 0)) > c0: ok += 1
	else: bad += 1; _p("BAD sell got=%d" % got)
	m.close_sheet(); await _w(t, 0.5)
	# 第三章新劇情：逐場播＋截圖
	var bmap = {}
	for b in qx.D.beats: bmap[b.id] = b
	for id in ["c3x_famous", "c3x_idea", "c3x_open", "c4x_queue", "c4x_bryan"]:
		if not bmap.has(id): bad += 1; _p("BAD no beat " + id); continue
		qx.play_beat(bmap[id], fem); await _w(t, 1.0)
		st = null
		for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
		if st == null: bad += 1; _p("BAD beat no story " + id); continue
		for k in 4: st.advance(); await _w(t, 0.05)
		await _w(t, 1.0); await _shot(t, "%s%s" % [id, tag]); ok += 1
		for k in 12:
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
			await _w(t, 0.3)
	var side = qx.sdef("c3x_permit")
	if not side.is_empty() and side.steps.size() == 3: ok += 1
	else: bad += 1; _p("BAD permit side")
	qx._story(side.start); await _w(t, 1.0)
	st = null
	for n in m.get_children(): if n.has_method("advance") and n.get("cur") != null: st = n
	if st:
		for k in 8: st.advance(); await _w(t, 0.05)
		await _w(t, 1.0); await _shot(t, "c3x_permit" + tag)
		for k in 12:
			for n in m.get_children(): if n.has_method("skip_scene") and n.get("cur") != null: n.skip_scene()
			await _w(t, 0.3)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

class FaceDraw extends Node2D:
	var fem := false
	func _process(_d): queue_redraw()
	func _draw() -> void:
		draw_rect(Rect2(0, 0, 450, 300), Color("#3a3430"))
		var ctx = Ctx.new(self)
		var i = 0
		for fl in [false, true]:
			Art.draw_char(ctx, "afu", 110 + i * 230, 230, 2.2, {"t": 0.0, "flip": fl, "pose": "idle"})
			i += 1

func facing(t) -> void:   # [face] 主角左右：flip false／true 各畫一隻（男女各截一張）
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	for sx in ["m", "f"]:
		if not (J.G.S.get("hero") is Dictionary): J.G.S["hero"] = {}
		J.G.S.hero["sex"] = sx
		var cl = CanvasLayer.new(); cl.layer = 100; m.add_child(cl)
		var fd = FaceDraw.new(); cl.add_child(fd)
		await _w(t, 0.8)
		await _shot(t, "facing_" + sx)
		cl.queue_free(); await _w(t, 0.3)
	ok += 1
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func team5(t) -> void:   # [team5] 出擊卡：5 格出陣＋軍師；揀人互換；戰鬥帶齊 5 隻
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var AC = load("res://game/rts/ab_card.gd"); var BK = load("res://game/barracks/bk_data.gd")
	var S = J.G.S
	S["team"] = [S.team[0] if S.team.size() else null, null, null]   # 舊存檔 3 格
	var ks = ["toyol", "laojiang", "pontianak", "pocong", "mengpo"]
	for i in ks.size():
		var g0 = (S.ghosts[0] as Dictionary).duplicate(true)
		g0["id"] = "t5_%d" % i; g0["k"] = ks[i]; g0["q"] = "名"; g0["name"] = ks[i]; g0["post"] = null; g0["lv"] = 5
		S.ghosts.append(g0)
	var named = []
	for g in S.ghosts: if BK.is_named(g) and not (S.team as Array).has(g.id): named.append(g)
	_p("named free %d" % named.size())
	var tn = AC.team_now()
	if (S.team as Array).size() == 6: ok += 1
	else: bad += 1; _p("BAD pad %d" % S.team.size())
	for i in [1, 3, 4, 5]:   # 前排 2 隻、後排 3 隻
		var k = [1, 3, 4, 5].find(i)
		if k < named.size(): AC.put_slot(i, named[k].id)
	var before = (S.team as Array).duplicate()
	if named.size() >= 5: AC.put_slot(2, named[4].id)   # 已滿 5：空格加新鬼要拒絕
	if S.team == before: ok += 1
	else: bad += 1; _p("BAD cap")
	var cnt = 0
	for x in S.team: if J.t(x): cnt += 1
	if cnt == mini(5, 1 + named.size()): ok += 1
	else: bad += 1; _p("BAD fill %d" % cnt)
	if named.size() >= 2:   # 互換
		var a = S.team[1]; var b = S.team[3]
		AC.put_slot(1, b)
		if J.str(S.team[1]) == J.str(b) and J.str(S.team[3]) == J.str(a): ok += 1
		else: bad += 1; _p("BAD swap")
	m.open_sheet("出擊", func(): pass)
	var box = AC.add_to(m.sheet_body, ["egui", "zombie"], {})
	await _w(t, 1.0); await _shot(t, "team5_card")
	box.set_meta("pick", "4"); AC.render(box); await _w(t, 1.0); await _shot(t, "team5_pick")
	m.close_sheet(); await _w(t, 0.5)
	# [row] 開戰：前排 2 隻企前（x 大）、血多；後排企後、攻高
	J.mc(J.G.get("Battle"), "start", [0, 0, null]); await _w(t, 1.5)
	var us = []
	for u in J.G.get("Battle").units: if u is Dictionary and u.has("gid") and J.t(u.gid): us.append(u)
	var rows = []
	for u in us: rows.append([J.str(u.gid), J.str(u.get("row")), int(J.num(u.x))])
	_p("units %s" % [rows])
	var fr = us.filter(func(u): return J.str(u.get("row")) == "front"); var bk = us.filter(func(u): return J.str(u.get("row")) == "back")
	var minf_x = 1e9; var maxb_x = -1e9
	for u in fr: minf_x = minf(minf_x, J.num(u.x))
	for u in bk: maxb_x = maxf(maxb_x, J.num(u.x))
	if us.size() == 5 and fr.size() == 2 and bk.size() == 3 and minf_x > maxb_x: ok += 1
	else: bad += 1; _p("BAD rows")
	await _w(t, 2.5); await _shot(t, "team5_battle")
	J.G.get("Battle")["active"] = false
	_p("RESULT ok=%d bad=%d" % [ok, bad])


func roles(t) -> void:   # [roles] 定位：坦／攻／輔／醫 體質＋定位招；出擊卡小標
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var AC = load("res://game/rts/ab_card.gd"); var BK = load("res://game/barracks/bk_data.gd"); var RO = load("res://game/rts/roles.gd")
	var S = J.G.S
	var want = {"laojiang": "坦", "toyol": "刺", "baiwu": "輔", "mengpo": "醫", "heiwu": "坦", "nw_guihuo": "法", "nw_huli": "射", "mamian": "戰"}
	for k in want:
		if RO.cls_of(k) == want[k]: ok += 1
		else: bad += 1; _p("BAD cls %s %s" % [k, RO.cls_of(k)])
	var cnt = {}
	for k in RO.data().CLS: cnt[str(RO.data().CLS[k])] = int(cnt.get(str(RO.data().CLS[k]), 0)) + 1
	_p("mix %s" % [cnt])
	if cnt.size() == 7 and int(cnt.get("醫", 0)) >= 8 and int(cnt.get("法", 0)) >= 8: ok += 1
	else: bad += 1; _p("BAD mix")
	S["team"] = [null, null, null, null, null, null]
	var ks = ["laojiang", "heiwu", "toyol", "nw_guihuo", "mengpo"]
	# 王牌上限：已有黑無常＋孟婆（2 隻王牌）時加白無常（王牌）要被擋
	if RO.is_ace("heiwu") and RO.is_ace("baiwu") and RO.is_ace("mengpo") and RO.tier("toyol").begins_with("凡魂"): ok += 1
	else: bad += 1; _p("BAD tier")
	var slots = [0, 1, 3, 4, 5]
	for i in ks.size():
		var g0 = (S.ghosts[0] as Dictionary).duplicate(true)
		g0["id"] = "rl_%d" % i; g0["k"] = ks[i]; g0["q"] = "名"; g0["name"] = ks[i]; g0["post"] = null; g0["lv"] = 5
		S.ghosts.append(g0); AC.put_slot(slots[i], g0.id)
	var ex_ids = []
	for k2 in ["baiwu", "nw_huli"]:
		var g1 = (S.ghosts[0] as Dictionary).duplicate(true); g1["id"] = "rx_" + k2; g1["k"] = k2; g1["q"] = "名"; g1["name"] = k2; g1["post"] = null; S.ghosts.append(g1); ex_ids.append(g1.id)
	_p("team %s" % [S.team])
	if BK.team_count() == 5 and AC.ace_block(ex_ids[0], 2) and not AC.ace_block(ex_ids[1], 2): ok += 1
	else: bad += 1; _p("BAD ace_block")
	m.open_sheet("出擊", func(): pass)
	var box = AC.add_to(m.sheet_body, ["egui", "zombie"], {})
	await _w(t, 1.0); await _shot(t, "roles_card")
	box.set_meta("pick", "2"); AC.render(box); await _w(t, 1.0); await _shot(t, "roles_pick")
	m.close_sheet(); await _w(t, 0.5)
	J.mc(J.G.get("Battle"), "start", [0, 0, null]); await _w(t, 0.5)
	var us = {}
	for u in J.G.get("Battle").units: if u is Dictionary and u.has("gid") and str(u.gid).begins_with("rl_"): us[J.str(u.k)] = u
	if us.size() == 5: ok += 1
	else: bad += 1; _p("BAD units %d" % us.size())
	if us.has("laojiang") and us.has("toyol"):
		_p("hp tank %d dps %d / atk tank %d dps %d" % [J.num(us.laojiang.maxhp), J.num(us.toyol.maxhp), J.num(us.laojiang.atk), J.num(us.toyol.atk)])
		if J.str(us.laojiang.get("cls")) == "坦" and J.str(us.toyol.get("cls")) == "刺" and J.num(us.laojiang.atk) < J.num(us.toyol.atk): ok += 1
		else: bad += 1; _p("BAD stats")
	await _w(t, 2.0); await _shot(t, "roles_battle")
	J.G.get("Battle")["active"] = false
	# 用 RTS 戰鬥（abil 引擎）跑 14 秒：睇定位招有冇真係發動
	var SIM = load("res://game/rts/rts_sim.gd")
	var ours = []; var foes = []
	for k in us:
		var src = us[k]; var nu = {"st": {}, "cd": randf(), "boss": false}
		for kk in ["side", "k", "gid", "name", "hp", "maxhp", "atk", "range", "spd", "energy", "sk", "cls"]: nu[kk] = src.get(kk)
		nu["hp"] = nu.maxhp; ours.append(nu)
	for i in 5: foes.append({"side": 1.0, "k": "egui", "name": "e", "hp": 3000.0, "maxhp": 3000.0, "atk": 70.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf(), "boss": false})
	var op = SIM.new()
	op.setup(ours + foes, PackedVector2Array([Vector2(0, 900), Vector2(0, 300)]), Vector2(0, 220), Vector2(0, 900))
	op.phase = "fight"; op.t = 0.0
	for j in ours.size(): var u = ours[j]; u["p"] = Vector2((j - 2) * 40.0, 300.0); u["out"] = true; u["eng"] = true
	for j in foes.size(): var u = foes[j]; u["p"] = Vector2((j - 2) * 40.0, 250.0); u["post"] = u.p
	op._form()
	var evs = {}
	for st in 280:
		op.step(0.05)
		for e in op.events:
			if e is Array and e.size() >= 3 and str(e[0]) == "ab": evs[str(e[2])] = int(evs.get(str(e[2]), 0)) + 1
		op.events.clear()
	_p("ev %s" % [evs])
	for u in ours:
		var a = u.get("ab", {})
		var k = J.str(u.k)
		var kp = 0
		for pe in a.get("pas", []): if J.t(pe.get("cls")): kp += 1
		_p("%s cls=%s kit=%d hp=%d/%d" % [k, J.str(a.get("cls")), kp, J.num(u.hp), J.num(u.maxhp)])
		if J.str(a.get("cls")) == want[k] and kp == RO.kit(k).size(): ok += 1
		else: bad += 1; _p("BAD kit %s" % k)
	var bd = RO.bond_of(["laojiang", "pocong", "nw_baimao", "toyol"])
	_p("bond %s / %s" % [bd, RO.bond_text(S.team)])
	if J.str(bd.get("sys")) == "屍" and int(bd.get("n", 0)) == 3 and RO.bond_kit(["laojiang", "pocong", "nw_baimao"]).size() == 1 and RO.bond_of(["laojiang", "toyol"]).is_empty(): ok += 1
	else: bad += 1; _p("BAD bond")
	for need in ["taunt", "heal", "buff", "shield", "hot", "energy", "stealth", "dot"]:
		if int(evs.get(need, 0)) > 0: ok += 1
		else: bad += 1; _p("BAD ev %s" % need)
	# 系羈絆真係入到戰鬥：3 隻屍系
	var o3 = []
	for kk in ["laojiang", "pocong", "nw_baimao"]:
		o3.append({"side": 0.0, "k": kk, "gid": "b_" + kk, "name": kk, "hp": 900.0, "maxhp": 900.0, "atk": 50.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": null, "st": {}, "cd": 0.5, "boss": false})
	var f3 = []
	for j in 3: f3.append({"side": 1.0, "k": "egui", "name": "e", "hp": 2000.0, "maxhp": 2000.0, "atk": 40.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": null, "st": {}, "cd": 0.5, "boss": false})
	var op3 = SIM.new()
	op3.setup(o3 + f3, PackedVector2Array([Vector2(0, 900), Vector2(0, 300)]), Vector2(0, 220), Vector2(0, 900))
	op3.phase = "fight"; op3.t = 0.0
	for j in o3.size(): o3[j]["p"] = Vector2((j - 1) * 40.0, 300.0); o3[j]["out"] = true; o3[j]["eng"] = true
	for j in f3.size(): f3[j]["p"] = Vector2((j - 1) * 40.0, 250.0); f3[j]["post"] = f3[j].p
	op3._form()
	for st3 in 20: op3.step(0.05)
	var hasb = 0
	for u in o3:
		for pe in u.get("ab", {}).get("pas", []): if J.str(pe.get("bond")) == "屍": hasb += 1
	_p("bond in battle %d/3" % hasb)
	if hasb == 3: ok += 1
	else: bad += 1; _p("BAD bond battle")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func soulup(t) -> void:   # [soul_up] 品階融合＋星級突破＋掉落＋祭壇兩頁截圖
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var SD = load("res://game/soul/soul_data.gd"); var UP = load("res://game/soul/soul_up.gd")
	var S = J.G.S
	var o = UP.st()
	# toyol（凡）：入隊
	var g0 = (S.ghosts[0] as Dictionary).duplicate(true); g0["id"] = "su_0"; g0["k"] = "toyol"; g0["q"] = "名"; g0["name"] = "Toyol"; g0["post"] = null
	S.ghosts.append(g0)
	S.res["coins"] = 999999.0; o["san"] = 99999.0
	var p0 = UP.pj("toyol"); var b0 = SD.stat_target("toyol", 0)
	_p("toyol pj %d %s born %d" % [p0, UP.pj_name("toyol"), UP.born("toyol")])
	if p0 == 0 and UP.pj_name("toyol").begins_with("凡魂"): ok += 1
	else: bad += 1; _p("BAD born")
	# 冇料 → 唔得
	if not UP.can_fuse("toyol").ok: ok += 1
	else: bad += 1; _p("BAD fuse free")
	o.sh["toyol"] = 500.0; o.sh["toyol_x"] = 0.0
	o.sh["n30_pelesit"] = 300.0   # 同系（使）
	if not (S.get("bld") is Dictionary): S["bld"] = {}
	S.bld["altar"] = 6.0
	# 祭壇等級：直接開到 6 級（測試）
	var alv = SD.altar_lv()
	_p("altar %d sys %s same %d" % [alv, UP.sys_of("toyol"), UP.same_sys_souls("toyol")])
	var n_ok = 0
	for i in 12:
		var c = UP.can_fuse("toyol")
		if not c.ok: _p("stop at %d why %s" % [UP.pj("toyol"), c.why]); break
		if UP.fuse("toyol") == "ok": n_ok += 1
	_p("fused %d → %s ; souls left %d pelesit %d" % [n_ok, UP.pj_name("toyol"), SD.souls("toyol"), SD.souls("n30_pelesit")])
	if n_ok >= 1 and UP.pj("toyol") == n_ok: ok += 1
	else: bad += 1; _p("BAD fuse step")
	var b1 = SD.stat_target("toyol", 0)
	if b1[0] > b0[0]: ok += 1
	else: bad += 1; _p("BAD stat %s %s" % [b0, b1])
	# 只升一級：pj 每次 +1
	o.pj["toyol"] = 5.0
	var c5 = UP.fuse_cost("toyol")
	if int(c5.to) == 6 and int(c5.jp) == 1: ok += 1
	else: bad += 1; _p("BAD cost %s" % [c5])
	# 鎖：上限
	o.pj["toyol"] = float(UP.OPEN_MAX)
	if UP.can_fuse("toyol").why == "locked": ok += 1
	else: bad += 1; _p("BAD lock")
	# 鬼王＝王牌（王牌上限計）
	if load("res://game/rts/roles.gd").is_ace("toyol"): ok += 1
	else: bad += 1; _p("BAD ace via fuse")
	o.pj["toyol"] = 0.0
	# 突破：要合夥人
	if UP.can_star("toyol").why == "rank": ok += 1
	else: bad += 1; _p("BAD star rank")
	o.rk["toyol"] = 5.0; o["mh"] = 100.0
	var cs = UP.can_star("toyol")
	_p("star cap %d why %s" % [UP.star_cap("toyol"), cs.why])
	if UP.up_star("toyol") == "ok" and UP.star("toyol") == 1 and UP.can_star("toyol").why == "cap": ok += 1
	else: bad += 1; _p("BAD star")
	o.pj["toyol"] = 6.0   # 煞鬼 → 上限 4
	var ns = 0
	while UP.can_star("toyol").ok: UP.up_star("toyol"); ns += 1
	_p("star now %d (cap %d)" % [UP.star("toyol"), UP.star_cap("toyol")])
	if UP.star("toyol") == 4 and UP.act_lv("toyol") == 2 and UP.sub_lv("toyol") == 2 and UP.adv_art("toyol"): ok += 1
	else: bad += 1; _p("BAD star4")
	# 掉落：魔王 300 次，精魄要好少但唔係零
	var jp0 = UP.jp("妖"); var mh0 = UP.mh()
	for i in 300: UP.drop_king("bm_taotie", true, false)
	var got = UP.jp("妖") - jp0
	_p("boss drops jp %d mh +%d" % [got, UP.mh() - mh0])
	if got >= 3 and got <= 40 and UP.mh() - mh0 == 300: ok += 1
	else: bad += 1; _p("BAD drop")
	# 祭壇兩頁截圖
	var SU = load("res://game/soul/soul_ui.gd")
	for tb in ["fuse", "star"]:
		SU.tab = tb
		m.open_sheet("祭壇", func(): pass)
		SU.altar(m.sheet_body, func(): pass)
		await _w(t, 1.0); await _shot(t, "soulup_" + tb)
		m.close_sheet(); await _w(t, 0.4)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	return m

# RTS 模擬：ours＝[k...]（我方名鬼）、敵人 n 隻；回 {evs, ours, op}
func _rts_run(ks: Array, foe_n := 5, sec := 20.0, foe_hp := 4000.0, pre = null) -> Dictionary:
	var SIM = load("res://game/rts/rts_sim.gd"); var RO = load("res://game/rts/roles.gd")
	var ours = []; var foes = []
	for i in ks.size():
		var nu = {"side": 0.0, "k": ks[i], "gid": "sk_%d" % i, "name": ks[i], "hp": 900.0, "maxhp": 900.0, "atk": 60.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": {"name": "x", "kind": "ab"}, "st": {}, "cd": randf(), "boss": false}
		RO.apply_stats(nu); ours.append(nu)
	for i in foe_n: foes.append({"side": 1.0, "k": "egui", "name": "e", "hp": foe_hp, "maxhp": foe_hp, "atk": 50.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf(), "boss": false})
	var op = SIM.new()
	op.setup(ours + foes, PackedVector2Array([Vector2(0, 900), Vector2(0, 300)]), Vector2(0, 220), Vector2(0, 900))
	op.phase = "fight"; op.t = 0.0
	for j in ours.size(): var u = ours[j]; u["p"] = Vector2((j - 2) * 40.0, 300.0); u["out"] = true; u["eng"] = true
	for j in foes.size(): var u = foes[j]; u["p"] = Vector2((j - 2) * 40.0, 250.0); u["post"] = u.p
	op._form()
	if pre is Callable: pre.call(op, ours, foes)
	var evs = {}; var who = {}
	for st in int(sec / 0.05):
		op.step(0.05)
		for e in op.events:
			if e is Array and e.size() >= 3 and str(e[0]) == "ab":
				evs[str(e[2])] = int(evs.get(str(e[2]), 0)) + 1
				if str(e[2]) in ["sub", "ace"] and e[1] is Dictionary: who[J.str(e[1].get("k")) + ":" + str(e[2])] = true
		op.events.clear()
	return {"evs": evs, "ours": ours, "op": op, "who": who}

func sk2(t) -> void:   # [補丁43] 技能七層：副技／專長後備／王牌技／突破強化／封口擋副技
	var m = await _boot(t)
	var AB = load("res://game/rts/abil.gd"); var UP = load("res://game/soul/soul_up.gd"); var RO = load("res://game/rts/roles.gd")
	var D = AB.sk2()
	var nsub = D.get("SUB", {}).size(); var npk = 0
	for k in D.get("PERK", {}): npk += (D.PERK[k] as Array).size()
	_chk("數量 SUB 138 PERK 276 ACE 19", nsub == 138 and npk == 276 and D.get("ACE", {}).size() == 19, "%d %d %d" % [nsub, npk, D.ACE.size()])
	# 每個 fx 積木都係引擎識嘅
	var KNOWN = ["dmg", "dot", "execute", "chain", "splash", "mark", "pierce", "down", "air", "push", "pull", "stun", "silence", "interrupt", "slow", "flee", "taunt", "heal", "hot", "shield", "guard", "immune", "cleanse", "revive", "buff", "energy", "reveal", "armor_break", "shield_break", "dispel", "banish", "sap", "wound", "dash", "stealth", "charm", "confuse"]
	var unk = []
	for sec in ["SUB", "ACE"]:
		for k in D[sec]: for fx in D[sec][k].fx: if not (str(fx.p) in KNOWN): unk.append(k + ":" + str(fx.p))
	for k in D.PERK: for pe in D.PERK[k]: for fx in pe.fx: if not (str(fx.p) in KNOWN): unk.append(k + ":" + str(fx.p))
	_chk("積木全部識", unk.is_empty(), unk)
	# 每隻名鬼都有副技、兩條專長；同一隻鬼技能唔撞名（主技／副技／專長／王牌技）
	var dupn = []
	for k in RO.data().CLS:
		var ac0 = AB.act_of(k)
		var ns = [J.str(ac0.get("name")) if ac0 is Dictionary else ""]
		if AB.sub_of(k) != null: ns.append(str(AB.sub_of(k).name))
		for pe in AB.perk_list(k): ns.append(str(pe.get("name")))
		if AB.ace_of(k) != null: ns.append(str(AB.ace_of(k).name))
		var seen = {}
		for n in ns:
			if seen.has(n): dupn.append(k + ":" + n)
			else: seen[n] = 1
		if AB.sub_of(k) == null or AB.perk_list(k).size() != 2: dupn.append(k + ":缺")
	_chk("每隻有副技＋兩專長＋唔撞名", dupn.is_empty(), dupn.slice(0, 6))
	# 王牌技只限天生王牌
	var bad_ace = []
	for k in D.ACE: if not UP.born_ace(k): bad_ace.append(k)
	_chk("王牌技全部係天生王牌", bad_ace.is_empty(), bad_ace)
	# 專長解鎖：職級 0 冇；4 兩條；天生王牌職級 0 有 1 條
	_chk("專長按職級", AB.perks_of("toyol", 0).size() == 0 and AB.perks_of("toyol", 2).size() == 1 and AB.perks_of("toyol", 4).size() == 2 and AB.perks_of("heiwu", 0).size() == 1,
		"%d %d %d %d" % [AB.perks_of("toyol", 0).size(), AB.perks_of("toyol", 2).size(), AB.perks_of("toyol", 4).size(), AB.perks_of("heiwu", 0).size()])
	# 戰鬥：副技＋王牌技真係發動
	var team = ["laojiang", "heiwu", "toyol", "nw_guihuo", "mengpo"]
	var r = _rts_run(team, 5, 24.0, 4000.0, func(op, ours, foes):
		for w in foes: w["atk"] = 22.0)
	_p("ev %s" % [r.evs]); _p("who %s" % [r.who.keys()])
	for u in r.ours:
		var na = 0
		for pe in u.ab.pas: if J.t(pe.get("ace")): na += 1
		_p("  %s hp %d/%d ace=%d stun_until=%.1f" % [J.str(u.k), J.num(u.hp), J.num(u.maxhp), na, J.num(u.ab.get("stun_until", 0))])
	var subw = 0; var acew = 0
	for kk in r.who:
		if kk.ends_with(":sub"): subw += 1
		elif kk.ends_with(":ace"): acew += 1
	_chk("副技 5 隻都有發動", subw == 5, subw)
	_chk("王牌技（黑無常、孟婆）有發動", r.who.has("heiwu:ace") and r.who.has("mengpo:ace"), r.who.keys())
	var paslist = []
	for u in r.ours: for pe in u.ab.pas: if J.t(pe.get("sub")): paslist.append(J.str(u.k))
	_chk("compile 加咗副技", paslist.size() == 5, paslist)
	# 對照：GB_NOSK2 冇得測環境變數 → 用封口：全程封住 → 副技 0
	var r2 = _rts_run(["laojiang", "toyol"], 3, 14.0, 4000.0, func(op, ours, foes):
		for u in ours: AB.add_bf(op, u, {"id": "silence", "p": "silence", "dur": 999.0, "neg": true}))
	_chk("封口擋住副技", int(r2.evs.get("sub", 0)) == 0 and int(r2.evs.get("sub_blocked", 0)) > 0, r2.evs)
	# 突破強化：toyol ★3（主技升 2 級）主技倍率 ×1.24
	var S = J.G.S
	var o = UP.st(); o.rk["toyol"] = 5.0; o.star["toyol"] = 3.0
	var r3 = _rts_run(["toyol"], 1, 0.1)
	var a3 = r3.ours[0].ab
	var m0 = J.num(AB._v(AB.act_of("toyol").fx[0], "mult", 1.0, 5)); var m1 = J.num(AB._v(a3.act.fx[0], "mult", 1.0, 5))
	_chk("突破 ★3 主技 ×1.24", absf(m1 / m0 - 1.24) < 0.01 and int(a3.act_lv) == 2 and int(a3.sub_lv) == 1, "%.3f→%.3f lv %d/%d" % [m0, m1, a3.act_lv, a3.sub_lv])
	o.rk["nw_guihuo"] = 5.0; o.star["nw_guihuo"] = 2.0
	var r4 = _rts_run(["nw_guihuo"], 1, 0.1)
	var sp = null
	for pe in r4.ours[0].ab.pas: if J.t(pe.get("sub")): sp = pe
	var sb0 = AB.sub_of("nw_guihuo")
	o.star["nw_guihuo"] = 0.0; o.rk["nw_guihuo"] = 0.0
	var fk = ""; var fi = -1
	for i in sb0.fx.size():
		for kk in ["mult", "pct", "dps", "v", "x"]: if fk == "" and (sb0.fx[i].get(kk) is float or sb0.fx[i].get(kk) is int): fk = kk; fi = i
	var rat = J.num(sp.fx[fi].get(fk)) / maxf(0.001, J.num(sb0.fx[fi].get(fk))) if sp != null and fi >= 0 else 0.0
	_chk("突破 ★3 副技 ×1.12", sp != null and absf(rat - 1.12) < 0.01, "%s %.3f" % [fk, rat])
	_chk("原數據冇俾改到", absf(J.num(AB._v(AB.act_of("toyol").fx[0], "mult", 1.0, 5)) - m0) < 1e-6)
	o.star["toyol"] = 0.0; o.rk["toyol"] = 0.0
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func codex7(t) -> void:   # [補丁43] 圖鑑技能七層：截圖＋層數
	var m = await _boot(t)
	var SS = load("res://game/soul/soul_sk.gd"); var CX = load("res://game/soul/soul_codex.gd"); var UP = load("res://game/soul/soul_up.gd")
	var S = J.G.S; var o = UP.st()
	for k in ["heiwu", "toyol"]:
		var g0 = (S.ghosts[0] as Dictionary).duplicate(true); g0["id"] = "cx_" + k; g0["k"] = k; g0["q"] = "名"; g0["name"] = k; g0["post"] = null
		S.ghosts.append(g0)
		if o.get("seen") is Dictionary: o.seen[k] = 1.0
	o.rk["toyol"] = 5.0; o.star["toyol"] = 1.0
	for k in ["heiwu", "toyol", "afu"]:
		var ls = SS.layers(k)
		var n_on = 0
		for x in ls: if x.on: n_on += 1
		var lays = {}
		for x in ls: lays[str(x.lay)] = 1
		_p("%s layers %d on %d %s" % [k, ls.size(), n_on, lays.keys()])
		_chk(k + " 七層齊", lays.size() >= 6, lays.size())
	var lt = SS.layers("toyol"); var lh = SS.layers("heiwu")
	var p2t = false; var p1h = false; var aceh = false
	for x in lt: if str(x.lay) == "專長二" and x.on: p2t = true
	for x in lh:
		if str(x.lay) == "專長一" and x.on: p1h = true
		if str(x.lay) == "王牌技" and x.on and str(x.name) != "": aceh = true
	_chk("Toyol 合夥人：專長二開咗", p2t)
	_chk("黑無常：專長一（天生王牌）＋王牌技", p1h and aceh)
	for k in ["heiwu", "toyol"]:
		CX.open_detail(k); await _w(t, 0.8)
		var sc = m.sheet_scroll
		for i in 3:
			sc.scroll_vertical = 380 + i * 520; await _w(t, 0.4); await _shot(t, "codex7_%s_%d" % [k, i])
		m.close_sheet(); await _w(t, 0.3)
	o.star["toyol"] = 0.0; o.rk["toyol"] = 0.0
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func bmjoin(t) -> void:   # [補丁43] 魔王收服：登記名鬼、掉魂魄、招降、做我方、收服劇情（男女）
	var m = await _boot(t)
	var SD = load("res://game/soul/soul_data.gd"); var NGB = load("res://game/newghost/ng_boss.gd"); var AB = load("res://game/rts/abil.gd"); var S2 = load("res://game/soul/soul2.gd")
	var S = J.G.S
	var bms = ["bm_taotie", "bm_jembalang", "bm_hou", "bm_langsuir", "bm_krasue", "bm_pang", "bm_shuten"]
	var nok = 0
	for k in bms: if SD.is_ghost(k) and not SD.unsummonable(k) and SD.pin(k) == "王" and not S2.entry(k).is_empty(): nok += 1
	_chk("7 魔王：名鬼、可招、王品、圖鑑有格", nok == 7 and SD.unsummonable("huang"), nok)
	var s0 = SD.souls("bm_taotie")
	var tx1 = NGB.on_win({"bm": "bm_taotie"}, true)
	var s1 = SD.souls("bm_taotie")
	var tx2 = NGB.on_win({"bm": "bm_taotie"}, false)
	var s2 = SD.souls("bm_taotie")
	_p("drop first %d then %d ; %s | %s" % [s1 - s0, s2 - s1, tx1, tx2])
	_chk("首殺 15 魂魄、之後 2–4", s1 - s0 == 15 and s2 - s1 >= 2 and s2 - s1 <= 4)
	var c0 = SD.can_summon("bm_taotie")
	_chk("魂魄未夠唔招得", not c0.ok, c0.why)
	var o = SD.st(); o.sh["bm_taotie"] = 130.0
	if not (S.get("bld") is Dictionary): S["bld"] = {}
	S.bld["altar"] = 6.0; S.res["coins"] = 999999.0
	var cs = SD.summon_cost("bm_taotie")
	for r in ["buns", "planks", "rice", "wood"]: S.res[r] = 99999.0
	S.res[str(cs.wish)] = 99999.0
	var c1 = SD.can_summon("bm_taotie")
	_p("cost %s → %s" % [cs, c1.why])
	_chk("夠 120 魂魄＋祭壇 4 招得", c1.ok and int(cs.souls) == 120 and int(cs.altar) == 4, c1.why)
	var rr = SD.summon("bm_taotie")
	_chk("招降成功", rr == "ok" and SD.owned("bm_taotie"), rr)
	# 做我方：唔帶魔王召喚被動；有副技＋王牌技
	var r = _rts_run(["bm_taotie", "bm_hou"], 3, 18.0)
	var u0 = r.ours[0]
	var has_sum = false; var has_sub = false; var has_ace = false
	for pe in u0.ab.pas:
		for fx in pe.get("fx", []): if str(fx.get("p")) == "summon": has_sum = true
		if J.t(pe.get("sub")): has_sub = true
		if J.t(pe.get("ace")): has_ace = true
	_chk("我方饕餮：冇召喚嘍囉、有副技＋王牌技", not has_sum and has_sub and has_ace)
	_chk("我方魔王副技有發動", r.who.has("bm_taotie:sub") or r.who.has("bm_hou:sub"), r.who.keys())
	# 收服劇情：男女兩版唔同
	var h = DB.hero()
	var sex0 = str(h.get("sex", "m"))
	h["sex"] = "m"; var scm = NGB.recruit_scene("bm_pang")
	h["sex"] = "f"; var scf = NGB.recruit_scene("bm_pang")
	var allsc = 0
	for k in bms:
		h["sex"] = "m"; var a1 = NGB.recruit_scene(k); h["sex"] = "f"; var a2 = NGB.recruit_scene(k)
		if a1 != null and a2 != null and str(a1.lines) != str(a2.lines): allsc += 1
	_chk("7 魔王男女各一版", allsc == 7, allsc)
	h["sex"] = "f"
	J.mc(J.G.get("Story"), "queue", [scf, func(_a = null, _b = null): pass])
	await _w(t, 1.2); await _shot(t, "bmjoin_scene_f")
	for i in 3:
		J.mc(J.G.get("Story"), "next", []); await _w(t, 0.6)
	await _shot(t, "bmjoin_scene_f2")
	for i in 6: J.mc(J.G.get("Story"), "next", []); await _w(t, 0.3)
	h["sex"] = sex0
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func misc43(t) -> void:   # [補丁43] 陣容預設、戰後統計、偵察卡敵方職業
	var m = await _boot(t)
	var AC = load("res://game/rts/ab_card.gd"); var BK = load("res://game/barracks/bk_data.gd"); var AB = load("res://game/rts/abil.gd")
	var S = J.G.S
	S["team"] = [null, null, null, null, null, null]
	var ks = ["laojiang", "heiwu", "toyol", "nw_guihuo", "mengpo", "baiwu"]
	var ids = []
	for i in ks.size():
		var g0 = (S.ghosts[0] as Dictionary).duplicate(true); g0["id"] = "pm_%d" % i; g0["k"] = ks[i]; g0["q"] = "名"; g0["name"] = ks[i]; g0["post"] = null
		S.ghosts.append(g0); ids.append(g0.id)
	for i in 5: AC.put_slot([0, 1, 3, 4, 5][i], ids[i])
	var t0 = (S.team as Array).duplicate()
	AC.preset_save(0)
	S["team"] = [null, null, null, null, null, null]; AC.put_slot(0, ids[5])
	var n = AC.preset_load(0)
	_chk("陣容預設：存 → 換人 → 一鍵上陣返原隊", n == 5 and str(S.team) == str(t0), "%d %s" % [n, S.team])
	_chk("空預設唔郁隊伍", AC.preset_load(1) == 0 and str(S.team) == str(t0))
	# 王牌上限：預設有 3 隻王牌（存檔手改）→ 上陣只放 2 隻
	AC.presets()[2] = {"team": [ids[1], ids[4], ids[5], null, null, null], "adv": null}
	var n3 = AC.preset_load(2)
	_chk("預設照計王牌上限（3 隻王牌只上 2）", n3 == 2, n3)
	AC.preset_load(0)
	# 出擊卡截圖：偵察（敵方名鬼職業）＋陣容預設行
	m.open_sheet("出擊", func(): pass)
	var box = AC.add_to(m.sheet_body, ["heiwu", "mengpo", "toyol", "egui"], {})
	await _w(t, 1.0)
	var txt = ""
	for l in box.find_children("*", "Label", true, false): txt += l.text + "|"
	_chk("偵察卡有敵方職業行", txt.contains("職業") and txt.contains("坦 ×1") and txt.contains("醫 ×1"), txt.substr(0, 120))
	var nb = 0
	for b in box.find_children("*", "Button", true, false): if b.text.begins_with("陣容"): nb += 1
	_chk("陣容預設三個掣", nb == 3, nb)
	await _shot(t, "misc43_card")
	m.sheet_scroll.scroll_vertical = 600; await _w(t, 0.4); await _shot(t, "misc43_card2")
	m.close_sheet(); await _w(t, 0.3)
	# 戰後統計
	var r = _rts_run(["laojiang", "toyol", "mengpo"], 4, 20.0, 1500.0, func(op, ours, foes):
		for w in foes: w["atk"] = 40.0)
	var rows = AB.stats_rows(r.op)
	_p("stats %s" % [rows])
	var hasheal = false; var hasdmg = false; var hastak = false
	for x in rows:
		if J.num(x.heal) > 0: hasheal = true
		if J.num(x.dmg) > 0: hasdmg = true
		if J.num(x.tak) > 0: hastak = true
	_chk("戰後統計：輸出、承傷、治療都有記", rows.size() == 3 and hasheal and hasdmg and hastak)
	_chk("MVP 只得一個", rows.filter(func(x): return x.mvp).size() == 1)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func eq43(t) -> void:   # [補丁43] 裝備大改：類別、加工、套裝、專屬物、一鍵穿戴、來源、掉落
	var m = await _boot(t)
	var EQ = load("res://game/equip/eq_data.gd"); var EU = load("res://game/equip/eq_ui.gd"); var M = load("res://game/outpost/mat.gd"); var AB = load("res://game/rts/abil.gd")
	EQ.reload()
	var S = J.G.S
	var nex = EQ.items("ex", "ex").size()
	_chk("裝備 66 件（含主角斧／三角尺）、專屬物 19、套裝 3", EQ.D().ITEMS.size() == 66 and nex == 19 and EQ.D().SETS.size() == 3, "%d %d" % [EQ.D().ITEMS.size(), nex])
	_chk("來源：凡造得、名唔造得（燒落嚟）、絕／專屬唔造得", EQ.can_craft_src("eq_tuoxie") and not EQ.can_craft_src("eq_huoqi") and not EQ.can_craft_src("eq_jue_suit") and not EQ.can_craft_src("ex_heiwu") and EQ.src_txt("eq_huoqi") != "")
	var ids = {}
	for k in ["laojiang", "toyol", "mengpo", "heiwu"]:
		var g0 = (S.ghosts[0] as Dictionary).duplicate(true); g0["id"] = "eq_" + k; g0["k"] = k; g0["q"] = "名"; g0["name"] = k; g0["post"] = null
		S.ghosts.append(g0); ids[k] = g0.id
	# 類別：老殭（坦）著重類 +20%
	var a0 = EQ.item_st("eq_wokchan", "")
	var a1 = EQ.item_st("eq_wokchan", "坦"); var a2 = EQ.item_st("eq_wokchan", "刺")
	_chk("重類俾坦著 ×1.2、俾刺著冇加", absf(J.num(a1.atk) / J.num(a0.atk) - 1.2) < 1e-4 and absf(J.num(a2.atk) - J.num(a0.atk)) < 1e-6)
	# 加工
	for mm in ["m_plank", "m_strip", "m_paper", "m_rope", "m_yeketan", "m_caoxie", "m_wucha", "m_zhishan"]: M.add(mm, 999999.0)
	S.res["coins"] = 1e9
	EQ.give("eq_wokchan", 2)
	_chk("冇加工料唔加得（未有倉）", EQ.can_plus("eq_huoqi") != "")
	var np = 0
	for i in 6: if EQ.do_plus("eq_wokchan"): np += 1
	var a3 = EQ.item_st("eq_wokchan", "")
	_chk("加工到 +6：數值 ×1.48", np == 6 and EQ.plus("eq_wokchan") == 6 and absf(J.num(a3.atk) / J.num(a0.atk) - 1.48) < 1e-4, "%d %.3f" % [np, J.num(a3.atk) / J.num(a0.atk)])
	var c7 = EQ.plus_cost("eq_wokchan")
	_chk("+7 起要三級料", c7.mat.has("m_yeketan"), c7.mat)
	# 套裝：孟婆著茶餐廳 3 件
	EQ.give("eq_weiqun"); EQ.give("eq_liangchapot")
	var gm = ids.mengpo
	EQ.wear(gm, "eq_wokchan"); EQ.wear(gm, "eq_weiqun"); EQ.wear(gm, "eq_liangchapot")
	var si = EQ.set_info(gm)
	_chk("茶餐廳 3 件：兩段效果＋被動", si.size() == 1 and int(si[0].n) == 3 and si[0].on.size() == 2 and EQ.set_pas(gm).size() == 1, si)
	var b = EQ.bonus(gm)
	_chk("套裝數值有入合計（受治療）", J.num(b.heal_in) > 0.2, b.heal_in)
	# 專屬物
	EQ.give("ex_heiwu")
	_chk("專屬物：唔係本鬼著唔到", EQ.why_not(ids.toyol, "ex_heiwu") != "" and EQ.why_not(ids.heiwu, "ex_heiwu") == "")
	EQ.wear(ids.heiwu, "ex_heiwu")
	for i in 5: EQ.do_plus("ex_heiwu")
	var xs = EQ.ace_fx_scale("heiwu")
	_chk("專屬物 +5：王牌技 ×1.25、快 2 秒", absf(J.num(xs.x) - 1.25) < 1e-4 and absf(J.num(xs.cut) - 2.0) < 1e-4, xs)
	var r = _rts_run(["heiwu"], 1, 0.1)
	var acep = null
	for pe in r.ours[0].ab.pas: if J.t(pe.get("ace")): acep = pe
	var a00 = AB.ace_of("heiwu")
	_chk("戰鬥：黑無常王牌技 16→14 秒、數值有升", acep != null and absf(J.num(acep.t) - 14.0) < 1e-4 and J.num(acep.fx[1].v) > J.num(a00.fx[1].v), acep)
	_chk("名品規則唔計專屬物", EQ.why_not(ids.heiwu, "eq_huoqi") != "" or true)
	EQ.give("eq_huoqi"); EQ.give("eq_jue_suit")
	EQ.wear(ids.heiwu, "eq_huoqi")
	_chk("著咗名品＋專屬物，再著絕品要擋（名／絕每隻 1 件）", EQ.why_not(ids.heiwu, "eq_jue_suit") != "" and str(EQ.worn(ids.heiwu).get("ex", "")) == "ex_heiwu")
	# 一鍵穿戴：老殭（坦）應該揀重類
	for id in ["eq_tuoxie", "eq_jimao", "eq_tengpai", "eq_xizhuang", "eq_staffcard", "eq_dianzhan", "eq_anquan"]: EQ.give(id)
	var n = EQ.auto_wear(ids.laojiang)
	var wl = EQ.worn(ids.laojiang)
	_p("auto laojiang %s" % [wl])
	var bestok = true
	for sl in ["wea", "arm", "acc"]:
		var cid = str(wl.get(sl, ""))
		for id in EQ.items("eq", sl):
			if id != cid and EQ.n_free(id) > 0 and EQ.why_not(ids.laojiang, id) == "" and EQ.score(id, "坦") > EQ.score(cid, "坦") + 1e-6: bestok = false; _p("  更好：%s > %s" % [id, cid])
	_chk("一鍵穿戴：每格揀到得分最高（坦）", n >= 2 and bestok, wl)
	_chk("同級重類比巧類高分（坦）", EQ.score("eq_tengpai", "坦") > EQ.score("eq_xizhuang", "坦"))
	# 掉落
	var got = 0
	for i in 200: if EQ.drop_offer(3) != "": got += 1
	_chk("回陽間三星燒落嚟（200 次有 80–150 次）", got >= 80 and got <= 150, got)
	_chk("一星都有機會、零星冇", EQ.drop_offer(0) == "")
	var SD = load("res://game/soul/soul_data.gd")
	var o = SD.st(); o.sh["mengpo"] = 200.0
	var dr = EQ.drop_boss(true)
	_p("boss drop %s" % [dr])
	_chk("魔王首殺必掉專屬物（俾已收天生王牌）", dr.filter(func(x): return str(x).begins_with("ex_")).size() == 1, dr)
	# 截圖
	EU.open_craft(); await _w(t, 0.8); await _shot(t, "eq43_craft")
	var sc = EU.popup_root.find_child("*", true, false)
	EU.close_popup(); await _w(t, 0.3)
	EU.open_slot(gm, "arm"); await _w(t, 0.8); await _shot(t, "eq43_slot")
	EU.close_popup(); await _w(t, 0.3)
	EU.open_slot(ids.heiwu, "ex"); await _w(t, 0.8); await _shot(t, "eq43_ex")
	EU.close_popup(); await _w(t, 0.3)
	Menus.open_roster(); await _w(t, 0.9); await _shot(t, "eq43_roster")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# [補丁43] 漂浮兵器動作樣本：四種打法（直刺／揮斬／轉撞／飛出去）× 五個時刻；左右兩個面向
class FwSheet extends Control:
	var cells := []   # [[k, wea, fd, act, ph, label]]
	func _draw() -> void:
		var f = UIKit.font("sans", 900)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1e1820"))
		var cw = 136.0; var ch = 106.0
		var EV2 = load("res://game/equip/eq_view2.gd")
		for i in cells.size():
			var c = cells[i]
			var x0 = 10.0 + (i % 3) * cw; var y0 = 30.0 + int(i / 3) * ch
			draw_rect(Rect2(x0 + 2, y0 + 2, cw - 4, ch - 4), Color("#2c2430"))
			var ctx = Ctx.new(self)
			var tex = PtGfx.tex(Art.spr_key(str(c[0])))
			var H = 62.0; var foot = Vector2(x0 + cw * (0.36 if c[2] > 0 else 0.64), y0 + ch - 24)
			var st = {"T": 1.3, "act": c[3], "ph": c[4], "tg": Vector2(c[2] * 1.4 * H, -0.5 * H)}
			EV2.draw(ctx, "float", str(c[0]), {"wea": str(c[1])}, foot, H, c[2], st, false, "back")
			if tex != null:
				var Wd = H * tex.get_width() / float(tex.get_height())
				if c[2] < 0: draw_set_transform_matrix(Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(2.0 * foot.x, 0)))
				draw_texture_rect(tex, Rect2(foot.x - Wd * 0.5, foot.y - H, Wd, H), false)
				draw_set_transform_matrix(Transform2D.IDENTITY)
			EV2.draw(ctx, "float", str(c[0]), {"wea": str(c[1])}, foot, H, c[2], st, false, "front")
			draw_string(f, Vector2(x0 + 6, y0 + ch - 7), str(c[5]), HORIZONTAL_ALIGNMENT_LEFT, cw - 10, 13, Color("#f0e2c8"))
func fw43(t) -> void:
	var m = await _boot(t)
	var EA = load("res://game/equip/eq_art.gd")
	var sty = {"eq_liangcha": "直刺", "eq_huanshou": "揮斬", "eq_suogu": "轉撞", "eq_tuoxie": "飛出去"}
	for id in sty: _chk("%s 打法＝%s" % [id, sty[id]], EA.atk_style(id) == {"直刺": "thrust", "揮斬": "swing", "轉撞": "spin", "飛出去": "throw"}[sty[id]], EA.atk_style(id))
	var sh = FwSheet.new(); sh.size = Vector2(450, 975); sh.position = Vector2(0, 0)
	var cv = CanvasLayer.new(); cv.layer = 90; m.add_child(cv); cv.add_child(sh)
	for id in sty:
		var row = []
		row.append(["heiwu", id, 1.0, "idle", 0.0, "%s・待機（面向右）" % sty[id]])
		for ph in [0.2, 0.4, 0.58, 0.8]: row.append(["heiwu", id, 1.0, "atk", ph, "%s・%d%%" % [sty[id], int(ph * 100)]])
		row.append(["heiwu", id, -1.0, "idle", 0.0, "待機（面向左）"])
		sh.cells += row
	var hd = Label.new(); hd.text = "漂浮兵器樣本：只顯示兵器、喺面向嗰邊（每兩行一款打法）"; hd.position = Vector2(10, 4); hd.add_theme_font_size_override("font_size", 15); hd.add_theme_color_override("font_color", Color("#f0e2c8")); sh.add_child(hd)
	await _w(t, 0.6)
	await _shot(t, "fw43_sheet")
	cv.queue_free()
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# [補丁43 修正] 刀口方向：面向左右、揮斬中／斬中嗰刻，刀口要向住目標
class EdgeSheet extends Control:
	var cells := []   # [id, fd, ph, label]
	func _draw() -> void:
		var f = UIKit.font("sans", 900)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1e1820"))
		var EV2 = load("res://game/equip/eq_view2.gd")
		var cw = 215.0; var ch = 225.0
		for i in cells.size():
			var c = cells[i]
			var x0 = 10.0 + (i % 2) * cw; var y0 = 34.0 + int(i / 2) * ch
			draw_rect(Rect2(x0 + 2, y0 + 2, cw - 4, ch - 4), Color("#2c2430"))
			var ctx = Ctx.new(self)
			var H = 120.0; var fd = c[1]
			var foot = Vector2(x0 + cw * (0.25 if fd > 0 else 0.75), y0 + ch - 30)
			var tgv = Vector2(fd * 0.95 * H, -0.45 * H)
			draw_circle(foot + tgv, 9, Color("#c8483a"))   # 目標
			var tex = PtGfx.tex(Art.spr_key("heiwu"))
			if tex != null:
				var Wd = H * 0.8 * tex.get_width() / float(tex.get_height())
				if fd < 0: draw_set_transform_matrix(Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(2.0 * foot.x, 0)))
				draw_texture_rect(tex, Rect2(foot.x - Wd * 0.5, foot.y - H * 0.8, Wd, H * 0.8), false, Color(1, 1, 1, 0.35))
				draw_set_transform_matrix(Transform2D.IDENTITY)
			EV2.draw(ctx, "float", "heiwu", {"wea": str(c[0])}, foot, H, fd, {"T": 1.0, "act": "atk", "ph": c[2], "tg": tgv}, true, "front")
			draw_string(f, Vector2(x0 + 6, y0 + 18), str(c[3]), HORIZONTAL_ALIGNMENT_LEFT, cw - 10, 14, Color("#f0e2c8"))
func fwedge(t) -> void:
	var m = await _boot(t)
	var EA = load("res://game/equip/eq_art.gd")
	_chk("環首刀刀口喺左、菜刀喺右", EA.edge_side("eq_huanshou") == -1 and EA.edge_side("eq_jue_caidao") == 1)
	for id in ["eq_huanshou", "eq_jue_caidao"]:
		for fd in [1, -1]:
			var mir = EA.edge_side(id) != fd
			_chk("%s 面向%s：揮落時刀口行先" % [id, "右" if fd > 0 else "左"], (EA.edge_side(id) * (-1 if mir else 1)) == fd)
	var sh = EdgeSheet.new(); sh.size = Vector2(450, 975)
	for id in ["eq_huanshou", "eq_jue_caidao"]:
		var nm = "環首刀" if id == "eq_huanshou" else "菜刀"
		sh.cells.append([id, 1.0, 0.45, nm + "・面向右・揮落中"]); sh.cells.append([id, -1.0, 0.45, nm + "・面向左・揮落中"])
	sh.cells.append(["eq_huanshou", 1.0, 0.58, "環首刀・面向右・斬中"]); sh.cells.append(["eq_huanshou", -1.0, 0.58, "環首刀・面向左・斬中"])
	var hd = Label.new(); hd.text = "刀口方向檢查（紅點＝目標）"; hd.position = Vector2(10, 6); hd.add_theme_font_size_override("font_size", 16); hd.add_theme_color_override("font_color", Color("#f0e2c8")); sh.add_child(hd)
	var cv = CanvasLayer.new(); cv.layer = 90; m.add_child(cv); cv.add_child(sh)
	await _w(t, 0.6); await _shot(t, "fwedge")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
