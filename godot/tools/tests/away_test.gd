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
