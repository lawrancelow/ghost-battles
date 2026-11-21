# [fogfix] 中央村稻田／槐樹全部可收割／可砍、冇裝飾物用 paddy／tree 圖、未佔領資源區黑霧、出村門外跟主線逐步解霧
# 用法：/home/claude/setup/edtest.sh <godot目錄> fogfix res://tools/tests/fogfix_test.gd logic|all
#   all：logic ＋ 截圖（/tmp/fogfix/shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/fogfix/shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const MS = preload("res://game/outpost/mv_story.gd")
const BAD_KEYS := ["tree", "tree_bare", "paddy", "paddy_cut", "deco:tree", "deco:paddy"]   # 可砍槐樹實際畫 tree_bare（Art.draw_tree）

func _p(m): print("[fogfix] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
var _shots_on := false
func _shot(t, name: String):
	if not _shots_on: return
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _img(t) -> Image:
	await RenderingServer.frame_post_draw
	return t.get_viewport().get_texture().get_image()
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _V(): return J.G.get("Village")
func _goto(t, m, c: int) -> void:
	var sc = m.mv_view
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2)

func logic(t) -> void: await _run(t, false)
func all(t) -> void: await _run(t, true)

func _run(t, shots: bool) -> void:
	_shots_on = shots
	var m = await _boot(t)
	ZD.gate_on = false
	for c in [0, 1, 2, 3]: await _level(t, m, c)
	await _fog_check(t, m)
	await _reveal_check(t, m)
	await _save_check(t, m)
	ZD.gate_on = false
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 1. 每關：8 棵槐樹＋6 格稻田全部撳得、冇裝飾用 tree／paddy 圖 =================
func _level(t, m, c: int) -> void:
	await _goto(t, m, c)
	var tag = "第 %d 關：" % (c + 1)
	var V = _V(); var S = J.G.S; var nv = m.village; var cam = nv.zone_cam()
	var TP = J.G.TREE_POS; var PP = J.G.PADDY_POS
	_chk(tag + "槐樹 8 棵、稻田 6 格（存檔 8／6 格）", TP.size() == 8 and PP.size() == 6 and S.trees.size() >= 8 and S.paddy.size() >= 6, [TP.size(), PP.size()])
	# 撳中邊棵就係邊棵（撳樹範圍／撳田範圍唔重疊）
	var hit_ok = true; var dbg = []
	for i in TP.size():
		var p = TP[i]
		for dy in [-60.0, -30.0, 0.0]:
			var h = J.mc(V, "hitTest", [J.num(p[0]), J.num(p[1]) + dy])
			if not (h is Dictionary) or str(h.kind) != "tree" or int(J.num(h.i)) != i: hit_ok = false; dbg.append(["t", i, dy, h])
	for i in PP.size():
		var p = PP[i]
		for dx in [-18.0, 0.0, 18.0]:
			var h = J.mc(V, "hitTest", [J.num(p[0]) + dx, J.num(p[1]) - 4])
			if not (h is Dictionary) or str(h.kind) != "paddy" or int(J.num(h.i)) != i: hit_ok = false; dbg.append(["p", i, dx, h])
	_chk(tag + "每棵槐樹／每格稻田撳落去都係佢自己（唔撞）", hit_ok, dbg)
	# 唔重疊：樹／田佔地互相唔疊、唔疊建築
	var rs = []
	for i in TP.size(): rs.append(["t%d" % i, Rect2(J.num(TP[i][0]) - 19, J.num(TP[i][1]) - 26, 38, 34)])
	for i in PP.size(): rs.append(["p%d" % i, Rect2(J.num(PP[i][0]) - 36, J.num(PP[i][1]) - 30, 72, 34)])
	var POS = J.G.POS
	for k in POS:
		if k == "gate": continue
		var w = float(Art.BW.get(k, 100)) * 0.8
		rs.append([k, Rect2(J.num(POS[k][0]) - w / 2.0, J.num(POS[k][1]) - 40, w, 46)])
	var ov = []
	for i in rs.size():
		for j in range(i + 1, rs.size()):
			if rs[i][1].intersects(rs[j][1]): ov.append("%s×%s" % [rs[i][0], rs[j][0]])
	_chk(tag + "槐樹／稻田唔重疊、唔壓建築", ov.is_empty(), ov)
	# 冇裝飾用 tree／paddy 圖；資源區填充／野外擺設唔用資源點（rn_*）／加工廠（vb_*）圖
	var Z = ZD.cur(); var badk = []
	for pr in Z.village.get("props", []): if str(pr[0]) in BAD_KEYS: badk.append(["props", pr])
	for d in J.G.DECOR: if str(d[0]) in BAD_KEYS: badk.append(["DECOR", d])
	for z in ZD.zones():
		for pr in z.get("props", []) + z.get("decor", []):
			var k = str(pr[0])
			if k in BAD_KEYS or k.begins_with("rn_") or k.begins_with("vb_"): badk.append([z.id, pr])
	for b in Z.get("barriers", []):
		if str(b.get("key", "")) in BAD_KEYS or str(b.get("key", "")).begins_with("rn_"): badk.append(["barrier", b.k])
	for kit in ZV.VOID_KIT.values():
		for e in kit: if str(e[0]) in BAD_KEYS: badk.append(["void", e[0]])
	for sc0 in Z.get("scenery", []): if str(sc0[0]) in BAD_KEYS or str(sc0[0]).begins_with("rn_"): badk.append(["scenery", sc0])
	_chk(tag + "冇裝飾物用 tree／paddy 圖、冇擺設用資源點／加工廠圖", badk.is_empty(), badk)
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	cam.center_on(Vector2(J.num(TP[0][0]) + 90, J.num(TP[0][1]) + 30)); await _w(t, 0.6)
	if c == 0:
		var fk = ZV._geo.get("forest", [])
		var fb = []
		for e in fk: if str(e[0]) in ["tree", "rn_bamboo"]: fb.append(e[0])
		_chk(tag + "樹林帶唔用 tree／rn_bamboo 圖", fb.is_empty(), fb)
	await _shot(t, "L%d_01_trees" % (c + 1))
	cam.center_on(Vector2((J.num(PP[0][0]) + J.num(PP[1][0])) / 2.0, J.num(PP[2][1]))); await _w(t, 0.6)
	await _shot(t, "L%d_02_paddy" % (c + 1))
	if c == 0: await _harvest_all(t, m)

# 第 1 關：真係逐格撳（經分區點擊）收割 6 格、砍 8 棵
func _harvest_all(t, m) -> void:
	var V = _V(); var S = J.G.S; var nv = m.village; var cam = nv.zone_cam(); var H = V.hero
	var PP = J.G.PADDY_POS; var TP = J.G.TREE_POS
	for i in PP.size(): S.paddy[i] = 1.0; S.paddyRegrow[i] = 0.0
	for i in TP.size(): S.trees[i] = 3.0; S.treeRegrow[i] = 0.0
	var got = []
	for i in PP.size():
		var p = Vector2(J.num(PP[i][0]), J.num(PP[i][1]))
		H.x = p.x - 30; H.y = p.y + 4; H.tx = H.x; H.ty = H.y; H.act = null; H.target = null; H["zq"] = []
		cam.center_on(p); await _w(t, 0.2)
		await _skip(t, 2)
		nv.zone_tap(nv.zone_w2s(p + Vector2(0, -4)))
		for k in 40:
			await _w(t, 0.2)
			if not J.t(S.paddy[i]): break
		if not J.t(S.paddy[i]): got.append(i)
	_chk("第 1 關：6 格稻田全部撳得收割", got.size() == 6, got)
	await _skip(t, 8)
	await _shot(t, "L1_03_paddy_harvested")
	var cut = []
	for i in TP.size():
		var p = Vector2(J.num(TP[i][0]), J.num(TP[i][1]))
		H.x = p.x + 20; H.y = p.y + 4; H.tx = H.x; H.ty = H.y; H.act = null; H.target = null; H["zq"] = []
		cam.center_on(p); await _w(t, 0.2)
		await _skip(t, 2)
		nv.zone_tap(nv.zone_w2s(p + Vector2(0, -30)))
		for k in 60:
			await _w(t, 0.2)
			if int(J.num(S.trees[i])) <= 0: break
			var st = m.get("story")
			if st and st.get("cur") != null: st.skip_scene()
		if int(J.num(S.trees[i])) <= 0: cut.append(i)
	_chk("第 1 關：8 棵槐樹全部撳得砍", cut.size() == 8, cut)
	await _skip(t, 8)
	await _shot(t, "L1_04_trees_chopped")
	for i in PP.size(): S.paddy[i] = 1.0; S.paddyRegrow[i] = 0.0
	for i in TP.size(): S.trees[i] = 3.0; S.treeRegrow[i] = 0.0

# 平均亮度（畫面座標範圍）
func _lum(im: Image, r: Rect2) -> float:
	var s = 0.0; var n = 0
	var x0 = int(clampf(r.position.x, 0, im.get_width() - 1)); var x1 = int(clampf(r.end.x, 0, im.get_width() - 1))
	var y0 = int(clampf(r.position.y, 0, im.get_height() - 1)); var y1 = int(clampf(r.end.y, 0, im.get_height() - 1))
	for y in range(y0, y1, 3):
		for x in range(x0, x1, 3):
			var cl = im.get_pixel(x, y); s += cl.r * 0.3 + cl.g * 0.59 + cl.b * 0.11; n += 1
	return s / maxf(1, n)

# ================= 2. 未佔領資源區：黑霧 ≥ 0.85、鎖／戰力字喺霧上面、佔領霧散 =================
func _fog_check(t, m) -> void:
	_chk("黑霧核心不透明度 ≥ 0.85", ZV.fog_core_alpha() >= 0.85 and ZV.fog_core_alpha() <= 0.93, "%.3f" % ZV.fog_core_alpha())
	ZD.gate_on = true
	var nv = m.village; var cam = nv.zone_cam(); var S = J.G.S
	for c in [0, 1, 2, 3]:
		await _goto(t, m, c)
		ZD.reveal_all(c)
		var tag = "第 %d 關：" % (c + 1)
		for zid in ["A", "B", "C"]: S.zone.own.erase("%d:%s" % [c, zid])
		var zr = ZD.zrect("A")
		await _skip(t, 4)
		cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO; cam.center_on(zr.get_center()); await _w(t, 0.8)
		var lg = ZV.fog_log.duplicate()
		var fi = lg.find(["fog", "A"]); var li = lg.find(["lock", "A"]); var pi = lg.find(["power", "A"]); var bi = lg.find(["btn", "A"])
		_chk(tag + "A 區：先畫黑霧，再畫鎖、戰力字、攻佔掣（喺霧上面）", fi >= 0 and li > fi and pi > li and bi > pi, lg)
		_chk(tag + "A 區名牌喺霧上面", ZV.plates.has(ZV._name(nv, ZD.zone("A"))))
		var lum = 9.0
		for tr in 3:   # 隨機事件橫額（「有大單！」）會蓋住畫面：量三次攞最暗
			lum = minf(lum, await _fog_lum(t, nv, zr))
			if lum < 0.08: break
			await _w(t, 2.5)
		_chk(tag + "A 區霧下近乎全黑（平均亮度 < 0.08）", lum < 0.08, "%.3f" % lum)
		await _shot(t, "L%d_10_resA_fog" % (c + 1))
		ZD.set_owned("A"); await _w(t, 0.35)
		await _shot(t, "L%d_11_resA_capturing" % (c + 1))
		await _w(t, 1.4)
		_chk(tag + "佔領後 A 區冇霧", not ZV.fog_log.has(["fog", "A"]))
		await _shot(t, "L%d_12_resA_owned" % (c + 1))
		S.zone.own.erase("%d:A" % c)
	await _goto(t, m, 0)
func _fog_lum(t, nv, zr: Rect2) -> float:
		var im = await _img(t)
		var off = nv.get_global_rect().position
		var inner = zr.grow(-36); var cc = zr.get_center(); var sm = 0.0; var sn = 0
		var gy = inner.position.y + 70.0
		while gy < inner.end.y:
			var gx = inner.position.x
			while gx < inner.end.x:
				var q = Vector2(gx, gy)
				if not Rect2(cc.x - 130, cc.y - 110, 260, 200).has_point(q):   # 避開鎖／戰力字／攻佔掣
					var sp = nv.zone_w2s(q) + off
					if sp.x > 2 and sp.y > 180 and sp.x < im.get_width() - 2 and sp.y < im.get_height() - 90:
						sm += _lum(im, Rect2(sp.x - 6, sp.y - 6, 12, 12)); sn += 1
				gx += 24.0
			gy += 24.0
		return sm / maxf(1, sn)

# ================= 3. 出村門外跟主線逐步解霧（第 1 關新遊戲） =================
func _qidx(tp: String, key: String) -> int:
	return ZD._qidx(tp, key)
func _hidden(c := 0) -> Array:
	var o = []
	for z in ZD.zones(c): if str(z.type) != "village" and not ZD.revealed(str(z.id), c): o.append(str(z.id))
	o.sort()
	return o
# 每區對應主線任務（第 1 關）
const STEPS := [["level", "3", ["market"], "R03_gate_open"], ["stage", "1-1", ["w_pit"], "R05_pit_open"], ["stage", "1-2", ["w_graves"], "R07_graves_open"],
	["bLevel", "wood", ["A"], "R08_A_open"], ["stage", "1-3", ["B"], "R09_B_open"], ["build", "home", ["C"], "R10_C_open"]]
func _reveal_check(t, m) -> void:
	ZD.gate_on = true
	var S = J.G.S; var nv = m.village; var cam = nv.zone_cam(); var em = m.mv_embed
	await _goto(t, m, 0)
	var keep = {"qi": S.qi, "lv": S.lv, "bld": S.bld.duplicate(true), "cleared": S.cleared.duplicate(true), "rev": S.zone.get("rev", {}).duplicate(true)}
	S.qi = 0.0; S.lv = 1.0; S.cleared = {}; S.zone["rev"] = {}
	S.bld["wood"] = 1.0; S.bld["home"] = 0.0
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	var sent_keep = S.zone.get("sent", {}).duplicate(true); S.zone["sent"] = {}
	ZD.reveal_poll(true)
	_chk("新遊戲開局：出村門外全部黑霧（大排檔、兩個野外區、三個資源區）", _hidden() == ["A", "B", "C", "market", "w_graves", "w_pit"], _hidden())
	_chk("野外未開：冇鬼潮、冇孤魂", not ZD.wild_open())
	var sim = m.mv_view.sim; var n0 = sim.custs.size(); var f0 = sim.foes.size()
	cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(Vector2(670, 1205)); await _w(t, 1.2)
	_chk("新遊戲開局：大排檔層畫咗黑霧", ZV.fog_log.has(["gfog", "market"]) and ZV.fog_log.has(["gfog", "w_pit"]) and ZV.fog_log.has(["gfog", "w_graves"]))
	ZD.EV_LOG.clear()
	cam.z = nv.size.x / 390.0; cam.center_on(ZD.zrect("A").get_center()); await _w(t, 1.0)
	cam.center_on(ZD.zrect("w_pit").get_center()); await _w(t, 1.0)
	var pan_ev = []
	for e in ZD.EV_LOG: if e[0] == "zone_seen": pan_ev.append(e[1])
	_chk("鏡頭掃過黑霧區：唔發 zone_seen（介紹劇情唔會跟鏡頭播）", pan_ev.is_empty(), pan_ev)
	cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(Vector2(670, 1205)); await _w(t, 0.8)
	_chk("新遊戲開局：A／B／C 未介紹（只有黑霧，冇鎖、冇戰力字）", ZV.fog_log.has(["fog", "A"]) and not ZV.fog_log.has(["lock", "A"]) and not ZV.fog_log.has(["power", "B"]))
	var gaps = []
	for e in ZV.fog_log: if e[0] == "gap": gaps.append(e[1])
	_chk("[hotfix12] 新遊戲開局：區與區之間（山石、邊界）都蓋黑霧", gaps.size() > 0 and int(gaps[0]) > 20, gaps)
	var gp_ok = J.G.POS.gate.duplicate()
	J.G["POS"] = J.G.POS.duplicate(true); J.G.POS["gate"] = [195.0, 118.0]   # 模擬重開局／匯入存檔：遊戲換咗一份舊豎條座標
	J.G["TREE_POS"] = [[38.0, 402.0]]
	ZD.apply()
	_chk("[hotfix12] POS／TREE_POS 俾人換咗（匯入存檔重開）：自動重新套用分區座標", J.G.POS.gate == gp_ok and J.G.TREE_POS.size() == 8, [J.G.POS.gate, gp_ok, J.G.TREE_POS.size()])
	var bad_hit = []; var can_hit = []
	for id in J.G.POS:
		if id == "gate" or not S.bld.has(id) or J.t(S.bld.get(id)): continue
		var bp = J.G.POS[id]; var hh = J.mc(J.G.get("Village"), "hitTest", [float(bp[0]), float(bp[1]) - 20.0])
		var unl = J.t(J.cl(J.G.get("bldUnlocked"), null, [id]))
		if not unl and hh is Dictionary and str(hh.get("kind")) == "bld" and str(hh.get("id")) == id: bad_hit.append(id)
		if unl: can_hit.append([id, hh is Dictionary and str(hh.get("id")) == id])
	_chk("[ruins13] 未解鎖嘅廢墟地盤撳唔到（唔彈建築卡）", bad_hit.is_empty(), bad_hit)
	_p("ruins can_hit=%s" % [can_hit])
	_chk("[ruins13] 已解鎖未起（可重建）撳得", can_hit.all(func(e): return e[1]), can_hit)
	await _skip(t, 6); await _w(t, 0.3)
	await _shot(t, "R01_new_game_whole")
	cam.z = nv.size.x / 390.0 * 1.4; cam.center_on(Vector2(600, 1400)); await _w(t, 1.0)
	await _shot(t, "R01b_village_ruins")
	cam.z = nv.size.x / 390.0; cam.center_on(ZD.zrect("village").get_center()); await _w(t, 3.0)
	await _shot(t, "R01c_souls_1"); await _w(t, 5.0)
	await _shot(t, "R01d_souls_2")
	cam.z = nv.size.x / 390.0; cam.center_on(ZV.gate_pos() + Vector2(0, -60)); await _w(t, 1.0)
	_chk("出村門鎖住：門上面有「出村門未開」牌＋要完成邊個任務", ZV.fog_log.has(["gate_lock", "market"]) and ZD.reveal_hint("market").contains("升到 3 級"), ZD.reveal_hint("market"))
	await _skip(t, 6); await _w(t, 0.5)
	await _shot(t, "R02_gate_locked")
	_chk("大排檔未開：唔出大排檔 HUD", not em.zone_hud_vis())
	cam.center_on(Vector2(670, 900)); await _w(t, 1.0)
	_chk("大排檔未開：唔開檔（冇新客、冇孤魂）", sim.custs.size() <= n0 and sim.foes.size() <= f0, [n0, sim.custs.size(), f0, sim.foes.size()])
	var sh0 = m.sheet.visible if m.get("sheet") is Control else false
	_chk("撳鎖住嘅出村門：出提示（唔開世界地圖／卡）", ZV.tap(m, ZV.gate_pos() + Vector2(0, -40)) and (m.get("sheet") == null or m.sheet.visible == sh0))
	_chk("撳未開放嘅大排檔：食咗（出提示，唔開任何卡）", ZV.tap(m, Vector2(670, 700)) and (m.get("sheet") == null or m.sheet.visible == sh0))
	_chk("撳未開放嘅資源區 A：唔開攻佔卡", ZV.tap(m, ZD.zrect("A").get_center()) and (m.get("sheet") == null or not m.sheet.visible))
	var hints = {}
	for z in ZD.zones(0): if str(z.type) != "village": hints[str(z.id)] = ZD.reveal_hint(str(z.id))
	_p("hints=%s" % hints)
	_chk("每區提示講明要完成邊個主線任務", hints.A.contains("伐木場升到 2 級") and hints.B.contains("擊敗餓鬼王") and hints.C.contains("建造民宅") and hints.w_pit.contains("1-1") and hints.w_graves.contains("1-2"), hints)
	# 逐步：每完成一個對應任務，淨係嗰區散霧
	var opened = ["market", "w_pit", "w_graves", "A", "B", "C"]
	for i in STEPS.size():
		var st = STEPS[i]
		var qi = _qidx(st[0], st[1])
		ZD.REV_NEWS.clear(); ZD.EV_LOG.clear()
		S.qi = float(qi)   # 去到任務但未完成：唔散
		var r0 = ZD.reveal_poll(true)
		S.qi = float(qi + 1)
		if st[0] == "level": S.lv = 3.0
		if st[0] == "stage": S.cleared[st[1]] = true
		if st[0] == "build": S.bld[st[1]] = 1.0
		if st[0] == "bLevel": S.bld[st[1]] = 2.0
		var r1 = ZD.reveal_poll(true)
		var exp_hidden = opened.slice(i + 1); exp_hidden.sort()
		var evr = []; var evs = []
		for e in ZD.EV_LOG:
			if e[0] == "reveal": evr.append(e[1])
			if e[0] == "zone_seen": evs.append(e[1])
		_chk("解 %s：介紹劇情 zone_seen 喺解霧嗰刻發一次（大排檔用開場劇情）" % st[2][0], evs == ([] if st[2][0] == "market" else st[2]), evs)
		_chk("完成「%s」→ 只散 %s 嘅霧（未完成唔散）" % [ZD._quest(st[0], st[1]).get("text", st[1]), st[2]], r0.is_empty() and r1 == st[2] and _hidden() == exp_hidden and evr == st[2] and ZD.REV_NEWS.size() == 1, [r0, r1, _hidden(), evr])
		var zr = ZD.zrect(st[2][0])
		cam.z = nv.size.x / 390.0 if st[2][0] != "market" else cam.z
		cam.center_on(zr.get_center() if st[2][0] != "market" else Vector2(670, 900)); await _w(t, 0.5)
		var stt = m.get("story")
		if stt and stt.get("cur") != null: stt.skip_scene()
		await _shot(t, st[3] + "_anim")
		ZV.eat_news(m)
		await _w(t, 1.6)
		await _shot(t, st[3])
		if st[2][0] == "market": _chk("出村門開咗：唔再畫大排檔黑霧、開檔", not ZV.fog_log.has(["gfog", "market"]) and not ZV.gate_locked_hit(ZV.gate_pos()))
		if st[2][0] == "w_pit": _chk("野外區開咗：有鬼潮", ZD.wild_open())
	cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(Vector2(670, 1205)); await _w(t, 0.8)
	await _shot(t, "R11_all_revealed_whole")
	S.qi = keep.qi; S.lv = keep.lv; S.bld = keep.bld; S.cleared = keep.cleared; S.zone["rev"] = keep.rev; S.zone["sent"] = sent_keep
	ZD.reveal_all(0)

# ================= 4. 舊存檔／大禮包新號／第 2 關中期／存檔補格 =================
func _save_check(t, m) -> void:
	ZD.gate_on = true
	var S = J.G.S
	var keep = {"zone": S.zone.duplicate(true), "qi": S.qi, "lv": S.lv, "cleared": S.cleared.duplicate(true), "ci": S.mv.ci, "bld": S.bld.duplicate(true),
		"trees": S.trees.duplicate(), "paddy": S.paddy.duplicate(), "tr": S.treeRegrow.duplicate(), "pr": S.paddyRegrow.duplicate()}
	var Q = J.G.QUESTS
	# 舊存檔（第 1 關，進度過咗解鎖點）：自動全開、唔播動畫
	S.zone = {"v": 1.0, "own": {}, "boss": {}, "exp": null, "mig": 2.0}
	S.qi = float(_qidx("build", "home") + 1); S.lv = 5.0; S.cleared = {"1-1": true, "1-2": true, "1-3": true}; S.bld["wood"] = 2.0; S.bld["home"] = 1.0; S.mv.ci = 0.0
	ZD.REVEALED.clear()
	ZD.st()
	var hid = []
	for z in ZD.zones(0): if str(z.type) != "village" and not ZD.revealed(str(z.id), 0): hid.append(str(z.id))
	_chk("舊存檔（第 1 關，進度過咗全部解鎖任務）：出村門外自動全開、唔播動畫", hid.is_empty() and ZD.REVEALED.is_empty(), hid)
	# 舊存檔（第 1 關中段：過咗 1-1、未過 1-2）：已過嘅區開、未過嘅照黑霧
	S.zone = {"v": 1.0, "own": {}, "boss": {}, "exp": null, "mig": 2.0}
	S.qi = float(_qidx("stage", "1-2")); S.lv = 4.0; S.cleared = {"1-1": true}; S.bld["wood"] = 1.0; S.bld["home"] = 0.0
	ZD.st()
	_chk("舊存檔（第 1 關中段）：按進度開（大排檔、餓鬼坑開；其他照黑霧）", _hidden(0) == ["A", "B", "C", "w_graves"], _hidden(0))
	# 第 2 關中期（老闆存檔）：第 1、2 關全開
	S.zone = {"v": 1.0, "own": {"1:A": true}, "boss": {}, "exp": null, "mig": 2.0}
	S.qi = float(Q.size() - 20); S.lv = 12.0; S.cleared = {"1-1": true, "1-2": true, "1-3": true, "2-1": true}; S.mv.ci = 1.0
	ZD.st()
	hid = []
	for c in [0, 1]:
		for z in ZD.zones(c): if str(z.type) != "village" and not ZD.revealed(str(z.id), c): hid.append("%d:%s" % [c, z.id])
	_chk("第 2 關中期存檔：第 1、2 關全開（唔受影響）", hid.is_empty(), hid)
	await _goto(t, m, 1)
	_chk("第 2 關中期存檔：有鬼潮、野外王照撳得", ZD.wild_open() and ZD.revealed("w_kgrave"))
	# 大禮包新號：由開局開始（S.gift 唔當進度）→ 全部黑霧、逐步解
	S.zone = {"v": 1.0, "own": {}, "boss": {}, "exp": null}
	S.qi = 0.0; S.lv = 1.0; S.cleared = {}; S.bld["wood"] = 1.0; S.bld["home"] = 0.0; S.mv.ci = 0.0; S["gift"] = {"res": {"coins": 9999.0}}
	await _goto(t, m, 0)
	ZD.st(); ZD.reveal_poll(true)
	hid = []
	for z in ZD.zones(0): if str(z.type) != "village" and not ZD.revealed(str(z.id), 0): hid.append(str(z.id))
	_chk("大禮包新號：由開局開始，出村門外全部黑霧", hid.size() == 6, hid)
	S.erase("gift")
	# 第 2 關新到埗：大排檔即開；野外／資源區等開場劇情（map_enter）播完
	S.zone = {"v": 1.0, "own": {}, "boss": {}, "exp": null, "mig": 3.0, "rev": {}}
	S.mv.ci = 1.0; await _goto(t, m, 1)
	S.zone["rev"] = {}
	var eb = MS.enter_beat(1); var sd = MS.seen_d(); var had = sd.get(str(eb.get("id", "")))
	sd.erase(str(eb.get("id", "")))
	MS.auto_on = true
	ZD.reveal_poll(true)
	var st1 = [ZD.revealed("market"), ZD.revealed("w_kgrave"), ZD.revealed("A")]
	sd[str(eb.id)] = 1.0
	ZD.reveal_poll(true)
	var st2 = [ZD.revealed("w_kgrave"), ZD.revealed("w_rubber"), ZD.revealed("A"), ZD.revealed("B"), ZD.revealed("C")]
	# 資源區跟劇情逐個開：A＝開檔劇情、B＝新檔劇情（unlock）、C＝賣貨劇情（sold）
	var bk = {}; var stp = []
	for kv in [["open", "A"], ["unlock", "B"], ["sold", "C"]]:
		var bb = ZD.beat_of(kv[0], 1); bk[str(bb.get("id", ""))] = sd.get(str(bb.get("id", "")))
		var hint_ok = ZD.reveal_hint(kv[1]).contains(MS.TN(bb.scene.title)) if bb.get("scene") is Dictionary else false
		var before = ZD.revealed(kv[1])
		sd[str(bb.id)] = 1.0; ZD.reveal_poll(true)
		stp.append([kv[1], before, ZD.revealed(kv[1]), hint_ok])
	MS.auto_on = false
	for k in bk:
		if bk[k] == null: sd.erase(k)
		else: sd[k] = bk[k]
	if had == null: sd.erase(str(eb.id))
	else: sd[str(eb.id)] = had
	_chk("第 2 關到埗：大排檔即開、野外／資源區等開場劇情", st1 == [true, false, false], st1)
	_chk("第 2 關開場劇情播完：淨係野外區解霧（資源區未開）", st2 == [true, true, false, false, false], st2)
	_chk("第 2 關資源區 A／B／C：各自劇情（開檔／新檔／賣貨）播完先逐個開，提示寫明劇情名", stp == [["A", false, true, true], ["B", false, true, true], ["C", false, true, true]], stp)
	# 存檔補格：舊得 6 棵／4 格 → 補返 8／6，已砍／已割照舊對應
	S.trees = [3.0, 0.0, 3.0, 2.0, 3.0, 3.0]; S.treeRegrow = [0.0, 12.0, 0.0, 0.0, 0.0, 0.0]
	S.paddy = [1.0, 0.0, 1.0, 1.0]; S.paddyRegrow = [0.0, 9.0, 0.0, 0.0]
	ZD.st()
	_chk("舊存檔 6 棵／4 格：自動補返 8 棵／6 格，已砍／已割索引照舊", S.trees.size() == 8 and S.paddy.size() == 6 and S.treeRegrow.size() == 8 and S.paddyRegrow.size() == 6
		and J.num(S.trees[1]) == 0.0 and J.num(S.trees[3]) == 2.0 and J.num(S.trees[7]) == 3.0 and not J.t(S.paddy[1]) and J.t(S.paddy[5]) and J.num(S.treeRegrow[1]) == 12.0, [S.trees, S.paddy])
	# 還原
	S.zone = keep.zone; S.qi = keep.qi; S.lv = keep.lv; S.cleared = keep.cleared; S.mv.ci = keep.ci; S.bld = keep.bld
	S.trees = keep.trees; S.paddy = keep.paddy; S.treeRegrow = keep.tr; S.paddyRegrow = keep.pr
	await _goto(t, m, 0)

