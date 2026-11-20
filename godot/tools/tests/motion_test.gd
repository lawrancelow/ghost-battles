extends RefCounted
const MD = preload("res://game/outpost/mv_data.gd")
func _p(m): print("[motion] ", m)
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
func probe(t) -> void:
	await _wait_boot(t)
	var ks = {}
	for c in MD.maps_n():
		for cid in MD.map_def(c).get("customers", []): ks[str(MD.cust_def(str(cid)).get("art"))] = "c%d" % c
		for f in MD.map_def(c).get("fence_foes", []): ks[str(f)] = "f%d" % c
	for g in ["egui","eguiking","xiaozhi","zhiren","pocong","zombie","laojiang","toyol","pontianak","penanggal","shuigui","youhun","xiaogui","mengpo","afu","baiwu","heiwu","tianhua","niutou","mamian"]: if not ks.has(g): ks[g] = "g"
	var D = J.G.get("DAILY"); var dk = D.keys() if D is Dictionary else []
	var RIG = J.gp(J.G.get("MeshAnim"), "RIG")
	for k in ks:
		var acts = []
		for a in dk: if str(a).contains(k.replace("n30_", "")): acts.append(a)
		var R = J.gp(RIG, k)
		_p("%s %s ma=%s spr=%s special=%s limbs=%s custom=%s hop=%s H=%s acts=%s" % [k, ks[k], Art._ma_has(k), Art.has_spr(k), Art._special_has(k), J.t(J.mc(J.G.get("Limbs"), "has", [k])), R is Dictionary and J.t(R.get("custom")), R is Dictionary and J.t(R.get("hop")), Art.char_h(k), acts.slice(0, 6)])
	_p("DAILY n=%d sample=%s" % [dk.size(), dk.slice(0, 80)])
func perf0(t) -> void:
	await _wait_boot(t)
	var ctx = Ctx.new(Recorder.new())
	var WK = J.G.get("WORK")
	var modes = {
		"plain_walk": func(k, i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "walk": true}),
		"plain_idle": func(k, i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1}),
		"daily": func(k, i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "act": "n30_taozhai_shake", "_daily": true, "at": i * 0.1}),
		"plaza": func(k, i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "act": "plaza_look", "_daily": true, "at": i * 0.1}),
		"work": func(k, i): J.mc(WK, "drawAct", [ctx, k, 100, 300, 1.0, "knead", i * 0.1, {"flip": false}]),
	}
	var types = {"plain_walk": "n30_taozhai", "plain_idle": "n30_taozhai", "daily": "n30_taozhai", "plaza": "egui", "work": "egui"}
	for m in modes:
		for rep in 2:
			ctx.ci.clear() if ctx.ci.has_method("clear") else null
			var t0 = Time.get_ticks_usec()
			for i in 30: modes[m].call(types[m], i)
			_p("%s %s 30x = %.2f ms" % [m, types[m], (Time.get_ticks_usec() - t0) / 1000.0])
const SHOTS := "/tmp/motion/shots/"
const TG := [["mt1", "egui", "餓鬼", 6.0], ["mt2", "xiaozhi", "小紙", 6.0], ["mt3", "zombie", "殭屍", 6.0], ["mt4", "pocong", "Pocong", 6.0], ["mt5", "toyol", "Toyol", 6.0],
	["mt6", "pontianak", "Pontianak", 6.0], ["mt7", "penanggal", "Penanggal", 6.0], ["mt8", "n30_diaosi", "吊死鬼", 6.0], ["mt9", "n30_wutou", "無頭鬼", 6.0], ["mt10", "shuigui", "水鬼", 6.0],
	["mt11", "laojiang", "老殭", 6.0], ["mt12", "n30_chehuo", "車禍鬼", 6.0], ["mt13", "zhiren", "紙人", 6.0], ["mt14", "eguiking", "餓鬼王", 6.0]]
func _V(): return J.G.get("Village")
func _cam(y: float) -> void: J.mc(_V(), "setCam", [y])
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _fixture(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t); _M = m
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.6)
	var S = J.G.S
	for g in TG: S.ghosts.append({"id": g[0], "k": g[1], "name": g[2], "q": "藍", "lv": g[3], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	S.res.coins = 1e7
	var sc = m.mv_view; var sim = sc.sim
	var M = load("res://game/outpost/mat.gd")
	for k in M.all_ids(): M.add(k, 200)
	return m
func _staff(sc, ws: Array, gs: Array) -> void:
	var sim = sc.sim; var c = sim.ci(); var sids = MD.stations(c)
	for sid in sids: sim.sst(sid).unlocked = true
	var i = 0
	for sid in sids:
		if MD.is_carry(sid): continue
		if i >= ws.size(): break
		sim.assign(sid, 0, ws[i]); i += 1
	for j in gs.size(): sim.assign("guard", j, gs[j])
func shot0(t) -> void:
	var m = await _fixture(t)
	var sc = m.mv_view
	_staff(sc, ["mt1", "mt2", "mt3", "mt4", "mt5"], ["mt6", "mt8"])
	await _w(t, 10.0)
	var E = m.mv_embed.eh()
	for y in [-E - 40.0, -E + 300.0, -E + 600.0]:
		_cam(y); await _w(t, 0.5); await _shot(t, "base_%d" % int(y + E))

# 連續幀拼圖：追住 getp.call() 返嘅世界座標，每 dt 秒截一格（cw×ch），排成 cols 欄
var _M = null
func _scr(sc, wp: Vector2) -> Vector2:
	var m = _M; var k = m.village.size.x / 390.0
	var cy = J.num(_V().get("camY"))
	var vp = m.get_viewport(); var f = float(vp.get_texture().get_width()) / vp.get_visible_rect().size.x
	return (m.village.get_global_rect().position + Vector2(wp.x * k, (wp.y - m.mv_embed.eh() - cy) * k)) * f
func _strip(t, sc, name: String, getp: Callable, n := 8, dt := 0.12, cw := 120, ch := 130, cols := 8) -> void:
	var rows = int(ceil(n / float(cols)))
	var out = Image.create(cw * mini(n, cols), ch * rows, false, Image.FORMAT_RGBA8)
	for i in n:
		await RenderingServer.frame_post_draw
		var img = t.get_viewport().get_texture().get_image()
		var wp = getp.call()
		if wp == null: break
		var sp = _scr(sc, wp)
		var r = Rect2i(int(sp.x - cw / 2.0), int(sp.y - ch * 0.82), cw, ch)
		r.position.x = clampi(r.position.x, 0, img.get_width() - cw); r.position.y = clampi(r.position.y, 0, img.get_height() - ch)
		out.blit_rect(img, r, Vector2i((i % cols) * cw, (i / cols) * ch))
		await _w(t, dt)
	out.save_png(SHOTS + "strip_" + name + ".png"); _p("strip " + name)
func _look(t, m, wy: float) -> void:
	var vh = m.village.size.y / (m.village.size.x / 390.0)
	_cam(wy - m.mv_embed.eh() - vh * 0.5); await _w(t, 0.25)
func shot1(t) -> void:
	var m = await _fixture(t)
	var sc = m.mv_view
	_staff(sc, ["mt1", "mt2", "mt3", "mt4", "mt5"], ["mt6", "mt8"])
	await _w(t, 8.0)
	for w in sc.sim.workers:
		var ww = w
		await _look(t, m, w.pos.y)
		await _strip(t, sc, "w_%s_%s" % [w.k, w.st], func(): return ww.pos, 16, 0.1)
	var done = {}
	for i in 30:
		for c in sc.sim.custs:
			if done.has(c.k) or c.st == "out": continue
			done[c.k] = true
			var cc = c
			await _look(t, m, c.pos.y)
			await _strip(t, sc, "c_%s_%s" % [c.k, c.st], func(): return cc.pos, 16, 0.12)
		await _w(t, 0.5)
		if done.size() >= 8: break
	for f in sc.sim.foes.slice(0, 2):
		var ff = f
		await _look(t, m, f.pos.y)
		await _strip(t, sc, "f_%s_%s" % [f.k, f.st], func(): return ff.pos, 16, 0.1)
func dbgpos(t) -> void:
	var m = await _fixture(t)
	var sc = m.mv_view
	_staff(sc, ["mt1", "mt2", "mt3", "mt4", "mt5"], ["mt6", "mt8"])
	await _w(t, 6.0)
	var c = sc.sim.custs[0]
	await _look(t, m, c.pos.y)
	await RenderingServer.frame_post_draw
	var img = t.get_viewport().get_texture().get_image()
	var sp = _scr(sc, c.pos)
	_p("cpos=%s sp=%s vrect=%s camY=%s E=%s vsize=%s scstage=%s top_pad=%s cam=%s" % [c.pos, sp, m.village.get_global_rect(), J.num(_V().get("camY")), m.mv_embed.eh(), m.village.size, sc.stage.get_global_rect(), sc.top_pad, sc.cam])
	img.fill_rect(Rect2i(int(sp.x) - 3, int(sp.y) - 3, 6, 6), Color.RED)
	img.save_png(SHOTS + "dbg.png")
# ---------- 展示：暫停 sim，逐種鬼擺好狀態，截連續幀（放大 2 倍） ----------
func _strip2(t, sc, name: String, pts: Array, n := 10, dt := 0.1, cw := 96, ch := 110) -> void:
	var cols = n
	var out = Image.create(cw * n * 2, ch * pts.size() * 2, false, Image.FORMAT_RGBA8)
	for i in n:
		await RenderingServer.frame_post_draw
		var img = t.get_viewport().get_texture().get_image()
		for j in pts.size():
			var sp = _scr(sc, pts[j])
			var r = Rect2i(int(sp.x - cw / 2.0), int(sp.y - ch * 0.8), cw, ch)
			r.position.x = clampi(r.position.x, 0, img.get_width() - cw); r.position.y = clampi(r.position.y, 0, img.get_height() - ch)
			var sub = img.get_region(r); sub.resize(cw * 2, ch * 2, Image.INTERPOLATE_BILINEAR)
			out.blit_rect(sub, Rect2i(0, 0, cw * 2, ch * 2), Vector2i(i * cw * 2, j * ch * 2))
		await _w(t, dt)
	out.save_png(SHOTS + "g_" + name + ".png"); _p("gallery " + name)
func _mkc(sc, k: String, p: Vector2, st: String, flip := true) -> Dictionary:
	var c = {"cid": "x", "k": k, "wants": {"m_shoubao": 2}, "got": {}, "st": st, "slot": 1, "take": 9.0, "s": 0.0, "pos": p, "ph": randf() * 10.0, "flip": flip, "lines": [], "vip": false}
	sc.sim.custs.append(c)
	return c
func gallery(t, arg := "0") -> void:
	var m = await _fixture(t)
	var sc = m.mv_view; var sim = sc.sim
	var ci = int(arg)
	sim.st().ci = float(ci); sc._after_move(); await _w(t, 0.5)
	sim.paused = true; sim.custs.clear(); sim.foes.clear()
	var ks = []
	for cid in MD.map_def(ci).get("customers", []): ks.append(str(MD.cust_def(str(cid)).get("art")))
	var base_y = float(sim.L.counter_y) - 260.0
	await _look(t, m, base_y + 90.0)
	var groups = []
	for i0 in range(0, ks.size(), 4): groups.append(ks.slice(i0, i0 + 4))
	var gi = 0
	for grp in groups:
		var pts = []; var cs = []
		for j in grp.size():
			var p = Vector2(60.0 + j * 90.0, base_y + 60.0)
			pts.append(p); cs.append(_mkc(sc, grp[j], p, "queue", j % 2 == 0))
		for c in cs: c["walk"] = true
		await _strip2(t, sc, "c%d_%d_walk" % [ci, gi], pts, 12, 0.08)
		for c in cs: c["walk"] = false; c["_mo"] = {"act": "", "at": 0.0, "gap": 0.0, "re": "", "rt": 0.0, "age": 0.0, "wt": 0.0, "got": 0, "st": "queue", "qt": 0.0, "seed": 1.0}
		await _strip2(t, sc, "c%d_%d_idle" % [ci, gi], pts, 14, 0.2)
		for c in cs: c.st = "serve"; c["wait"] = SIM_P() * 0.9
		await _strip2(t, sc, "c%d_%d_impat" % [ci, gi], pts, 10, 0.1)
		for c in cs: c.wait = 0.0; c.got = {"m_shoubao": 1}
		await _strip2(t, sc, "c%d_%d_got" % [ci, gi], pts, 10, 0.08)
		for c in cs: c.got = {}; c["_mo"]["got"] = 0; c.st = "out"
		await _strip2(t, sc, "c%d_%d_angry" % [ci, gi], pts, 10, 0.12)
		for c in cs: sim.custs.erase(c)
		gi += 1
func SIM_P() -> float: return 15.0
func _mkw(sc, k: String, sid: String, p: Vector2, st := "work") -> Dictionary:
	var w = {"gid": "g_" + k, "k": k, "name": k, "sid": sid, "slot": 0, "st": st, "prog": 0.2, "pos": p, "home": p, "carry": 0, "t": 0.0, "s": 0.0, "ph": randf() * 10.0, "paid": {}}
	sc.sim.workers.append(w)
	return w
func gallery2(t, arg := "0") -> void:
	var m = await _fixture(t)
	var sc = m.mv_view; var sim = sc.sim
	var ci = int(arg)
	sim.st().ci = float(ci); sc._after_move(); await _w(t, 0.5)
	for sid in MD.stations(ci): sim.sst(sid).unlocked = true
	await _w(t, 0.3)
	sim.paused = true; sim.custs.clear(); sim.foes.clear(); sim.workers.clear()
	sim._sync_key = "x"
	# 員工：每個台一隻（唔同鬼）做貨
	var kinds = ["egui", "xiaozhi", "zombie", "pocong", "toyol", "pontianak", "penanggal", "n30_diaosi", "n30_wutou", "shuigui", "laojiang", "zhiren"]
	var sids = []
	for sid in MD.stations(ci): if not MD.is_carry(sid): sids.append(sid)
	var ws = []; var pts = []
	for i in sids.size():
		var p = sim.slot_pos(sids[i], 1)
		ws.append(_mkw(sc, kinds[(i + ci * 3) % kinds.size()], sids[i], p)); pts.append(p)
	for i in range(0, pts.size(), 3):
		await _look(t, m, pts[i].y - 30.0)
		await _strip2(t, sc, "w%d_%d_work" % [ci, i], pts.slice(i, i + 3), 12, 0.15, 120, 120)
	# 頂貨行路＋跌貨
	for w in ws: w.st = "go"; w.carry = 2; w["walk"] = true
	ws[0]["_mo"] = {"act": "", "at": 0.0, "gap": 1.0, "re": "drop", "rt": 0.0, "age": 1.0, "wt": 0.0, "got": 0, "st": "carry", "qt": 0.0, "seed": 1.0, "fz": ws[0].pos}
	await _look(t, m, pts[0].y - 30.0)
	await _strip2(t, sc, "w%d_carry" % ci, pts.slice(0, 3), 14, 0.13, 130, 130)
	# 斷料打瞌睡
	for w in ws: w.st = "work"; w.carry = 0; w["walk"] = false; w["starve"] = true; w.erase("paid")
	await _strip2(t, sc, "w%d_starve" % ci, pts.slice(0, 3), 8, 0.2, 120, 120)
	for w in ws: w.erase("starve")
	sim.workers.clear()
	# 領班：瞓 → 撳醒 → 巡
	var S = J.G.S
	sim.assign("fore:" + sids[0], 0, "mt3")
	await _w(t, 0.3)
	var fp = sc.mot.fore_pos.get(sids[0], sim.st_pos(sids[0]))
	await _look(t, m, fp.y - 30.0)
	await _strip2(t, sc, "fore%d_doze" % ci, [fp], 6, 0.2, 120, 120)
	sc.mot.tap(sc, fp + Vector2(0, -30))
	await _strip2(t, sc, "fore%d_wake" % ci, [fp], 10, 0.1, 120, 120)
	# 村外惡鬼
	sim.paused = false
	var fy = float(sim.L.fence_y)
	await _look(t, m, fy - 40.0)
	sim.foes.clear()
	for i in 3: sim.spawn_foe()
	var fs = sim.foes.duplicate()
	fs[0].pos = Vector2(80, fy - 70); fs[0].st = "roam"; fs[0].tgt = Vector2(300, fy - 70); fs[0].t = -99.0
	fs[1].pos = Vector2(200, fy - 8); fs[1].st = "bang"; fs[1].t = 0.0
	fs[2].pos = Vector2(320, fy - 90); fs[2].st = "roam"; fs[2].tgt = fs[2].pos; fs[2].t = -99.0
	await _strip2(t, sc, "foe%d_roam" % ci, [Vector2(130, fy - 70), fs[1].pos, fs[2].pos], 14, 0.12, 120, 120)
	sim.hit_foe(fs[2], 1.0, "tap")
	await _strip2(t, sc, "foe%d_hurt" % ci, [fs[2].pos], 6, 0.05, 120, 120)
	sim.hit_foe(fs[2], 1e9, "tap")
	await _strip2(t, sc, "foe%d_die" % ci, [fs[2].pos], 8, 0.1, 120, 120)
	# 頭目出場
	sim.foes.clear()
	sim.war.start_wave(sim); sim.war.wave.q = [true]; sim.war._spawn_wave_foe(sim, true)
	var b = sim.war.wave.boss; b.pos = Vector2(195, fy - 60); b.tgt = b.pos; sim.paused = true; sim.ev.clear()
	sc.banner = null
	await _strip2(t, sc, "boss%d_intro" % ci, [b.pos], 14, 0.1, 160, 170)
	sim.foes.clear(); sim.war.wave = null; sim.paused = false
	# 義勇軍：客人買咗裝備變義勇軍
	var gear = ""
	for g in MD.D().GOODS: if sim.war.is_gear(str(g)): gear = str(g); break
	var c = _mkc(sc, str(MD.cust_def(str(MD.map_def(ci).customers[0])).get("art")), Vector2(195, float(sim.L.fence_y) + 62.0), "serve")
	c.got = {gear: 2}
	sim.war.on_paid(sim, c)
	var r = sim.war.vols[sim.war.vols.size() - 1]
	r.st = "post"; r.walk = false; r.pos = Vector2(195, float(sim.L.fence_y) + 62.0); sim.paused = true
	await _w(t, 0.05); sc.banner = null; sc.bubbles.clear()
	await _look(t, m, r.pos.y - 30.0)
	await _strip2(t, sc, "vol%d_join" % ci, [r.pos], 12, 0.1, 120, 120)
	r["_mo"].act = "salute"; r["_mo"].at = 0.0; r["_mo"]["dur"] = 2.6
	await _strip2(t, sc, "vol%d_salute" % ci, [r.pos], 10, 0.2, 120, 120)
	# 守衛換班
	sim.paused = false; sim.foes.clear()
	await _w(t, 0.5)
	if sim.guards.size():
		var g = sim.guards[0]
		var gm = sc.mot._mo(g); gm["shift"] = 0.0
		await _look(t, m, g.pos.y - 30.0)
		await _strip2(t, sc, "guard%d_shift" % ci, [g.pos], 10, 0.2, 120, 120)
func acts(t, arg := "egui") -> void:
	var m = await _fixture(t)
	var sc = m.mv_view; var sim = sc.sim
	sim.paused = true; sim.custs.clear(); sim.foes.clear(); sim.workers.clear()
	var names = ["chop", "haul", "crate", "rest", "reap", "plant", "hammer", "sand", "sight", "knead", "steam", "sneak", "coins", "push", "inspect", "burn", "march", "salute", "drill", "boo", "grimace", "blow"]
	var y0 = float(sim.L.counter_y) - 300.0
	await _look(t, m, y0 + 80.0)
	for gi in range(0, names.size(), 4):
		var ws = []; var pts = []
		for j in 4:
			if gi + j >= names.size(): break
			var p = Vector2(55.0 + j * 93.0, y0 + 60.0); pts.append(p)
			var w = _mkw(sc, arg, MD.stations(0)[0], p); w["_mo"] = {"act": "", "at": 0.0, "gap": 9.0, "re": "", "rt": 0.0, "age": 0.0, "wt": 0.0, "got": 0, "st": "", "qt": 0.0, "seed": 1.0}
			w["force_act"] = names[gi + j]; ws.append(w)
		sc.mot.set_meta("force", true)
		await _strip2(t, sc, "act_%s_%d" % [arg, gi], pts, 8, 0.35, 92, 110)
		for w in ws: sim.workers.erase(w)
# ================= 正式測試 =================
var ok := 0
var bad := 0
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _all_types() -> Dictionary:
	var ks = {}
	for c in MD.maps_n():
		for cid in MD.map_def(c).get("customers", []): ks[str(MD.cust_def(str(cid)).get("art"))] = "客%d" % (c + 1)
		for f in MD.map_def(c).get("fence_foes", []): ks[str(f)] = "惡鬼%d" % (c + 1)
	for g in J.G.GHOSTS: if not ks.has(str(g)): ks[str(g)] = "員工"
	return ks
func logic(t) -> void: await _logic(t, false)
func all(t) -> void: await _logic(t, true)
func _logic(t, shots: bool) -> void:
	var m = await _fixture(t)
	var sc = m.mv_view; var sim = sc.sim; var mot = sc.mot
	_chk("掛鈎：mv_scene 有 mot", mot != null)
	# 1. 每種鬼都有對應動作
	var D = J.G.DAILY; var miss = []; var nospec = []
	var types = _all_types()
	for k in types:
		var p = mot.profile(k)
		if p.idle.is_empty() and not p.mesh: pass
		for a in p.idle:
			var an = str(a[0])
			if not an.begins_with("t_") and not D.has(an): miss.append(k + ":" + an)
		if not p.specific: nospec.append(k)
	_chk("每種鬼嘅待機動作都存在（DAILY／變形）", miss.is_empty(), miss)
	_chk("所有客人／惡鬼／員工種類都有專屬動作（%d 種）" % types.size(), nospec.is_empty(), nospec)
	for k in ["pocong", "zombie", "n30_diaosi", "egui", "toyol", "zhiren", "penanggal", "n30_wutou", "pontianak", "shuigui", "n30_chehuo"]:
		var p2 = mot.profile(k)
		_chk("%s：行路 %s、待機 %s" % [k, p2.gait, p2.idle.map(func(a): return a[0])], p2.gait != "walk" or not p2.idle.is_empty())
	# 1b. 撳醒領班
	var sid0 = ""
	for q in MD.stations(0): if not MD.is_carry(q) and sid0 == "": sid0 = q
	sim.sst(sid0).unlocked = true
	var asg = sim.assign("fore:" + sid0, 0, "mt3")
	_p("assign fore %s → %s fore=%s" % [sid0, asg, IDLx().fore(sim, sid0)])
	await _look(t, m, sim.st_pos(sid0).y); await _w(t, 0.5)
	var fp = mot.fore_pos.get(sid0)
	_chk("領班有畫（企喺台側）", fp != null)
	if fp != null:
		mot.fore_mo[sid0].st = "doze"; mot.fore_mo[sid0].t = 0.0
		var used = mot.tap(sc, fp + Vector2(0, -30))
		_chk("撳瞓緊嘅領班 → 嚇醒", used and mot.fore_mo[sid0].st == "wake")
		var wx = float(sc.sim.ww())   # [zone] 分區地圖世界闊 1340（舊豎條 390）
		_chk("領班唔出地圖邊", fp.x >= 20.0 and fp.x <= wx - 20.0, fp)
	# 2. 狀態切換唔報錯（離屏錄製）：每張圖所有客人 × 所有狀態；員工所有台；惡鬼所有狀態；義勇軍
	var ctx = Ctx.new(Recorder.new())
	var n_draw = 0
	for ci in MD.maps_n():
		sim.st().ci = float(ci); sc._after_move()
		for sid in MD.stations(ci): sim.sst(sid).unlocked = true
		sim.paused = true; sim.custs.clear(); sim.workers.clear(); sim.foes.clear()
		var ks = []
		for cid in MD.map_def(ci).get("customers", []): ks.append(str(MD.cust_def(str(cid)).get("art")))
		for k in ks:
			var c = _mkc(sc, k, Vector2(195, float(sim.L.counter_y) + 20.0), "in")
			var seq = [["in", true, 0.0, {}], ["queue", false, 0.0, {}], ["serve", false, 12.0, {}], ["serve", false, 0.0, {"m_shoubao": 1}], ["out", true, 0.0, {"m_shoubao": 1}], ["out", true, 0.0, {}]]
			for s in seq:
				c.st = s[0]; c["walk"] = s[1]; c["wait"] = s[2]; c.got = s[3]
				if s[0] == "out" and s[3].is_empty(): c["_mo"].got = 0; c["_mo"].st = "serve"
				for f in 25:
					mot.step(sc, 0.1); ctx.ci.clear(); mot.cust(sc, ctx, c); n_draw += 1
			if k == "n30_maoshi":
				c.st = "in"; c.walk = true; c["_mo"].re = "trip"; c["_mo"].rt = 0.0; c["_mo"]["fz"] = c.pos
				for f in 15: mot.step(sc, 0.1); mot.cust(sc, ctx, c)
			sim.custs.erase(c)
		var gi = 0
		for sid in MD.stations(ci):
			if MD.is_carry(sid): continue
			var wk = ["egui", "xiaozhi", "zombie", "pocong", "toyol", "pontianak", "penanggal", "n30_diaosi", "zhiren", "laojiang"][gi % 10]; gi += 1
			var w = _mkw(sc, wk, sid, sim.slot_pos(sid, 0))
			for s in [["work", false, 0, false], ["go", true, 2, false], ["work", false, 0, true], ["back", true, 0, false]]:
				w.st = s[0]; w["walk"] = s[1]; w.carry = s[2]; w["starve"] = s[3]
				if s[0] == "go": w["_mo"]["trip_at"] = 0.2; w["_mo"].st = "carry"; w["_mo"].ct = 0.0
				for f in 25: mot.step(sc, 0.1); mot.worker(sc, ctx, w); n_draw += 1
			sim.workers.erase(w)
		sim.paused = false
		for f0 in MD.map_def(ci).get("fence_foes", []):
			sim.spawn_foe(); var f = sim.foes[sim.foes.size() - 1]; f.k = str(f0)
			for s in ["roam", "charge", "bang"]:
				f.st = s; f["walk"] = s != "bang"
				for i in 15: mot.step(sc, 0.1); mot.foe(sc, ctx, f); n_draw += 1
			f["hurt"] = 0.2
			for i in 3: mot.step(sc, 0.05); mot.foe(sc, ctx, f)
			f.erase("hurt"); f.st = "die"; f.t = 0.0
			for i in 8: f.t += 0.1; mot.step(sc, 0.1); mot.foe(sc, ctx, f)
			f["boss"] = true; f["_mo"] = null; f.erase("_mo"); f.st = "roam"; f.t = 0.0
			for i in 20: mot.step(sc, 0.1); mot.boss(sc, ctx, f, f.pos.x, f.pos.y, 1.6, {"t": 0.0, "flip": false, "alpha": 0.95}); n_draw += 1
			sim.foes.erase(f)
	for pk in ["youhun", "n30_jiugui", "egui"]:
		for i in 10: mot.porter(sc, ctx, {"k": pk, "mid": "m_bao", "ph": 1.0}, Vector2(195, 1000), i % 2 == 0, 1.0, i * 0.1)
	_chk("挑夫鬼步法（幽魂飄、酒鬼醉步、餓鬼弓身）", (mot.seen.get("n30_jiugui", {}) as Dictionary).has("porter") and (mot.seen.get("n30_jiugui", {}) as Dictionary).has("gait_drunk"))
	_chk("狀態切換全部畫過、冇報錯", n_draw > 1000, "畫咗 %d 次" % n_draw)
	var cover = []
	for k in types:
		if not mot.seen.has(k) and types[k].begins_with("客"): cover.append(k)
	_chk("每種客人都行過專屬動作（seen）", cover.is_empty(), cover)
	var need = {"egui": ["drool", "re_chomp", "impatient"], "n30_maoshi": ["trip"], "n30_jiugui": ["gait_drunk"], "zhiren": ["foe_flutter", "foe_die", "foe_peek", "boss_intro"],
		"youhun": ["foe_twist", "foe_hurt"], "pocong": ["w_carry", "w_drop", "w_starve"], "baiwu": ["gait_glide"], "n30_churel": ["gait_moon"], "n30_chehuo": ["gait_glance"], "shuigui": ["foe_crawl"],
		"n30_bunian": ["gait_fade"], "n30_baigujing": ["gait_catwalk"], "n30_zipai": ["gait_selfie"], "n30_dongsi": ["gait_freeze"], "n30_wutou": ["gait_nodwalk"],
		"n30_phiam": ["gait_sleepy"], "n30_diansi": ["gait_zap"], "n30_shanxiao": ["gait_hop1"], "n30_jerangkung": ["foe_rattle"], "n30_aswang": ["foe_flap"], "n30_kuchisake": ["foe_stalk"]}
	for k in need:
		var lack = []
		for a in need[k]: if not (mot.seen.get(k, {}) as Dictionary).has(a): lack.append(a)
		_chk("%s 動作：%s" % [k, need[k]], lack.is_empty(), lack)
	# 3. 效能：30 個角色一幀（有 motion vs 冇）
	sim.st().ci = 0.0; sc._after_move(); sim.paused = true; sim.custs.clear(); sim.workers.clear(); sim.foes.clear()
	var ks0 = []
	for cid in MD.map_def(0).customers: ks0.append(str(MD.cust_def(str(cid)).get("art")))
	var cs = []
	for i in 30:
		var c = _mkc(sc, ks0[i % ks0.size()], Vector2(30 + (i % 10) * 36, float(sim.L.counter_y) - 40.0 * (i / 10)), "serve" if i == 0 else ["queue", "in"][i % 2])
		c["walk"] = i % 2 == 1 and i > 0; c["wait"] = 12.0 if i == 0 else 0.0; cs.append(c)
	for f in 20: mot.step(sc, 0.05)
	var best_m = 1e9; var best_b = 1e9
	for rep in 5:
		ctx.ci.clear()
		var t0 = Time.get_ticks_usec()
		mot.step(sc, 0.016)
		for c in cs: mot.cust(sc, ctx, c)
		best_m = minf(best_m, (Time.get_ticks_usec() - t0) / 1000.0)
		ctx.ci.clear()
		t0 = Time.get_ticks_usec()
		for c in cs: Art.draw_char(ctx, str(c.k), c.pos.x, c.pos.y, sc.CS, {"t": sc.t + c.ph, "walk": c.get("walk", false), "flip": c.get("flip", true), "alpha": 0.95})
		best_b = minf(best_b, (Time.get_ticks_usec() - t0) / 1000.0)
	var t1 = Time.get_ticks_usec(); for i in 10: mot.step(sc, 0.016)
	_p("step x1 = %.2f ms" % ((Time.get_ticks_usec() - t1) / 10000.0))
	for c in cs: c["_mo"].act = ""; c["_mo"].gap = 999.0
	ctx.ci.clear(); t1 = Time.get_ticks_usec(); for c in cs: mot.cust(sc, ctx, c)
	_p("cust 冇待機動作 = %.2f ms" % ((Time.get_ticks_usec() - t1) / 1000.0))
	_p("效能：30 客人一幀 有 motion %.2f ms／原本 %.2f ms（差 %+.2f ms）" % [best_m, best_b, best_m - best_b])
	_chk("效能：30 角色（1 個喺櫃台等、其餘排隊／行路）motion 額外耗時 < 5ms", best_m - best_b < 5.0, "%.2f / %.2f ms" % [best_m, best_b])
	sim.custs.clear(); sim.paused = false
	# 真畫面幀率（大排檔區、客人多）
	for c in cs: sim.custs.append(c)
	sim.paused = true
	await _look(t, m, float(sim.L.counter_y) - 60.0)
	var fr0 = Engine.get_frames_drawn(); var tt = Time.get_ticks_msec()
	await _w(t, 3.0)
	var fps = (Engine.get_frames_drawn() - fr0) * 1000.0 / maxf(1.0, Time.get_ticks_msec() - tt)
	var keep_mot = sc.mot; sc.mot = null
	fr0 = Engine.get_frames_drawn(); tt = Time.get_ticks_msec()
	await _w(t, 3.0)
	var fps0 = (Engine.get_frames_drawn() - fr0) * 1000.0 / maxf(1.0, Time.get_ticks_msec() - tt)
	sc.mot = keep_mot
	_p("真畫面 30 客人：有 motion %.1f fps／冇 motion %.1f fps（無頭 xvfb 軟件渲染，只作比較）" % [fps, fps0])
	_p("（xvfb 軟件渲染幀率波動大，只記錄唔判）")
	if shots: await _shot(t, "logic_30")
	sim.custs.clear(); sim.paused = false
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func bench2(t) -> void:
	var m = await _fixture(t)
	var sc = m.mv_view; var mot = sc.mot
	var ctx = Ctx.new(Recorder.new())
	var k = "n30_taozhai"
	var fns = {
		"direct": func(i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "flip": true, "alpha": 0.95}),
		"direct_walk": func(i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "walk": true, "flip": true, "alpha": 0.95}),
		"body_id": func(i): mot.body(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "flip": true, "alpha": 0.95}, {}),
		"body_tf": func(i): mot.body(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "flip": true, "alpha": 0.95}, {"sy": 1.02, "r": 0.03}),
		"body_gs": func(i): mot.body(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "flip": true, "alpha": 0.95}, {"sy": 1.02, "dy": -3.0, "gs": 1.0}),
		"anger": func(i): mot.draw_fx(sc, ctx, [["anger", Vector2(100, 200), 1.0, 0.3]]),
		"txt": func(i): mot.draw_fx(sc, ctx, [["txt", "哼！", Vector2(100, 200), 1.0, "#ffffff"]]),
		"daily": func(i): Art.draw_char(ctx, k, 100, 300, 1.1, {"t": i * 0.1, "flip": true, "act": "n30_taozhai_shake", "_daily": true, "at": i * 0.1}),
	}
	for rep in 3:
		for n in fns:
			ctx.ci.clear(); var t0 = Time.get_ticks_usec()
			for i in 30: fns[n].call(i)
			_p("%s 30x %.2f ms" % [n, (Time.get_ticks_usec() - t0) / 1000.0])
func bench3(t) -> void:
	var m = await _fixture(t)
	var sc = m.mv_view; var mot = sc.mot; var sim = sc.sim
	sim.paused = true; sim.custs.clear()
	var ctx = Ctx.new(Recorder.new())
	var ks0 = []
	for cid in MD.map_def(0).customers: ks0.append(str(MD.cust_def(str(cid)).get("art")))
	for mode in ["queue", "serve", "walk"]:
		var cs = []
		for i in 30:
			var c = _mkc(sc, ks0[i % ks0.size()], Vector2(30 + (i % 10) * 36, 900.0), "serve" if mode == "serve" else "queue")
			c["walk"] = mode == "walk"; c["wait"] = 9.0 if mode == "serve" else 0.0; cs.append(c)
		for f in 30: mot.step(sc, 0.05)
		for rep in 3:
			ctx.ci.clear(); var t0 = Time.get_ticks_usec()
			for c in cs: mot.cust(sc, ctx, c)
			var a = (Time.get_ticks_usec() - t0) / 1000.0
			ctx.ci.clear(); t0 = Time.get_ticks_usec()
			for c in cs: Art.draw_char(ctx, str(c.k), c.pos.x, c.pos.y, sc.CS, {"t": sc.t + c.ph, "walk": c.get("walk", false), "flip": c.get("flip", true), "alpha": 0.95})
			_p("%s motion %.2f base %.2f" % [mode, a, (Time.get_ticks_usec() - t0) / 1000.0])
		for c in cs: sim.custs.erase(c)

func IDLx(): return load("res://game/outpost/mv_idle.gd")

func gallery_1(t): await gallery(t, "1")
func gallery_2(t): await gallery(t, "2")
func gallery_3(t): await gallery(t, "3")
func gallery_4(t): await gallery(t, "4")
func gallery_5(t): await gallery(t, "5")
func gallery2_1(t): await gallery2(t, "1")
func gallery2_2(t): await gallery2(t, "2")
func gallery2_3(t): await gallery2(t, "3")
func gallery2_4(t): await gallery2(t, "4")
func gallery2_5(t): await gallery2(t, "5")
