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

