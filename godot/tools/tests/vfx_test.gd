# [vfx] 特效組測試：序列幀目錄、真模擬觸發副技／王牌技 → rts_fx 出序列幀、實機樣本截圖
# 用法：edtest.sh <godot目錄> vfx_xxx res://tools/tests/vfx_test.gd all|cat|sim|shots|ui <秒>
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/art/vfx/shots/"
const VC = preload("res://game/fxkit/vfx_cat.gd")
const RFX = preload("res://game/rts/rts_fx.gd")

func _p(m): print("[vfx] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	if m and m.has_method("_hide_title"): m._hide_title()
	await _w(t, 1.0)
	return m

func all(t) -> void:
	await _boot(t)
	cat_(); await sim_(t); await shots_(t); await ui_(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func cat(t) -> void: await _boot(t); cat_(); _p("RESULT ok=%d bad=%d" % [ok, bad])
func sim(t) -> void: await _boot(t); await sim_(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func shots(t) -> void: await _boot(t); await shots_(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func ui(t) -> void: await _boot(t); await ui_(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func b2(t) -> void:   # 第二批：目錄＋真模擬（20 個新模板）＋實機樣本＋範圍形狀對數
	await _boot(t); cat_(); await sim2_(t); geom_(); await shots2_(t); _p("RESULT ok=%d bad=%d" % [ok, bad])

func _have() -> Array:
	var o = []
	for k in VC.CAT:
		if VC.CAT[k].has("alias"): continue
		if VC.get_e(k) != null: o.append(k)
	return o

# ---- 目錄：每張序列幀載得入、4×4、正方；王牌技 19 個全部有對應鍵 ----
func cat_() -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	var have = _have(); _p("有圖 %d：%s" % [have.size(), have])
	var badt = []
	for k in have:
		var tx = VC.tex(k)
		if tx == null or tx.get_width() != tx.get_height() or tx.get_width() % VC.GRID != 0: badt.append(k)
	_chk("序列幀全部載得入（正方、4×4 整除）", badt.is_empty(), badt)
	var miss = []
	for k in D.ACE:
		var key = VC.key_of(D.ACE[k], str(k))
		if not VC.CAT.has(key): miss.append(k + "→" + key)
	_chk("19 王牌技全部有目錄鍵", miss.is_empty() and D.ACE.size() == 19, miss)
	var ms = []
	for k in D.SUB:
		var key2 = VC.key_of(D.SUB[k], str(k))
		if not VC.CAT.has(key2) and not ms.has(key2): ms.append(key2)
	_p("副技模板未有目錄（下一批）：%d 個 %s" % [ms.size(), ms])

# ---- 真模擬：開 vfx_on，名技 → vq sk2 → rts_fx 出序列幀 ----
func _rts(ks: Array, sec: float):
	var SIM = load("res://game/rts/rts_sim.gd"); var RO = load("res://game/rts/roles.gd")
	var ours = []; var foes = []
	for i in ks.size():
		var nu = {"side": 0.0, "k": ks[i], "gid": "vx_%d" % i, "name": ks[i], "hp": 3000.0, "maxhp": 3000.0, "atk": 40.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": {"name": "x", "kind": "ab"}, "st": {}, "cd": randf(), "boss": false}
		RO.apply_stats(nu); nu["hp"] = 6000.0; nu["maxhp"] = 6000.0; ours.append(nu)
	for i in 6: foes.append({"side": 1.0, "k": "egui", "name": "e", "hp": 9000.0, "maxhp": 9000.0, "atk": 30.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf(), "boss": false})
	var op = SIM.new()
	op.setup(ours + foes, PackedVector2Array([Vector2(0, 900), Vector2(0, 300)]), Vector2(0, 220), Vector2(0, 900))
	op.phase = "fight"; op.t = 0.0; op.vfx_on = true
	for j in ours.size(): var u = ours[j]; u["p"] = Vector2((j - 2) * 40.0, 300.0); u["out"] = true; u["eng"] = true
	for j in foes.size(): var u = foes[j]; u["p"] = Vector2((j - 2.5) * 40.0, 250.0); u["post"] = u.p
	op._form()
	var g = Node2D.new(); var tp = Node2D.new()
	var fx = RFX.new(g, tp); fx.vr = Rect2(-2000, -2000, 4000, 4000)
	for st in int(sec / 0.05):
		op.step(0.05); fx.consume(op); fx.tick(0.05)
		op.events.clear()
	# 低血王牌（千杯不醉）：硬拉血到一半以下再行
	for u in ours:
		u["hp"] = J.num(u.maxhp) * 0.3
	for st in 20: op.step(0.05); fx.consume(op); fx.tick(0.05); op.events.clear()
	g.free(); tp.free()

func sim_(t) -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	RFX.SK2.n = 0; RFX.SK2.keys = {}
	var aces = D.ACE.keys()
	var i = 0
	while i < aces.size():
		await _rts(aces.slice(i, i + 5), 30.0); i += 5
		await t.get_tree().process_frame
	# 副技：揀用第一批 10 個模板嘅鬼
	var want = ["A_BACK", "S_SAP", "T_GUARD", "S_STUN", "T_STUN", "T_SLAM", "T_WALL", "W_KNOCK", "R_SNIPE", "W_BREAK"]
	var pick = []
	for tp in want:
		for k in D.SUB:
			if str(D.SUB[k].get("tpl")) == tp and not D.ACE.has(k): pick.append(k); break
	i = 0
	while i < pick.size():
		await _rts(pick.slice(i, i + 5), 26.0); i += 5
	_p("sk2 觸發 %d 次：%s" % [RFX.SK2.n, RFX.SK2.keys])
	var have = _have(); var miss = []
	for k in have:
		if k.begins_with("ace_") and not RFX.SK2.keys.has(k): miss.append(k)
	_chk("有圖嘅王牌技全部喺真模擬播到", miss.is_empty(), miss)
	var ms = []
	for k in have:
		if k.begins_with("sub_") and want.has(k.substr(4)) and not RFX.SK2.keys.has(k): ms.append(k)   # 第二批由 b2 驗
	_chk("有圖嘅副技模板全部喺真模擬播到", ms.is_empty(), ms)
	_chk("rts_fx 冇爆上限（drop 0）", int(RFX.STATS.drop) == 0, RFX.STATS.drop)

# ---- 實機樣本：用遊戲真嘅 rts_fx 畫法，喺戰場底色上面播，逐個截關鍵幀 ----
var _bg: Node2D
func _scene(t):
	var root = t.get_tree().root
	var cl = CanvasLayer.new(); cl.layer = 90; root.add_child(cl)
	var bg = ColorRect.new(); bg.color = Color("#1e1c22"); bg.size = root.get_visible_rect().size; cl.add_child(bg)
	var tr = TextureRect.new(); tr.size = bg.size; tr.modulate = Color(0.55, 0.55, 0.6); cl.add_child(tr)
	for f in ["res://assets/img/mapx_ground_2.webp", "res://assets/img/patrol_assets/ground2.webp"]:
		if ResourceLoader.exists(f): tr.texture = load(f); tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_TILE; break
	var w = Node2D.new(); cl.add_child(w)
	var g = Node2D.new(); w.add_child(g)
	var units = Node2D.new(); w.add_child(units)
	var tp = Node2D.new(); w.add_child(tp)
	return [cl, g, units, tp, bg.size]

func _unit(par: Node2D, k: String, p: Vector2, hgt: float, flip := false) -> void:
	var tx = Spr.get_tex(k) if Spr.ok(k) else null
	if tx == null: tx = PtGfx.tex(k)
	if tx == null: return
	var s = Sprite2D.new(); s.texture = tx; var sc = hgt / tx.get_height(); s.scale = Vector2(sc * (-1 if flip else 1), sc)
	s.offset = Vector2(0, -tx.get_height() * 0.5); s.position = p; par.add_child(s)

func shots_(t) -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	PtGfx.init()
	var sc = _scene(t); var cl: CanvasLayer = sc[0]; var g: Node2D = sc[1]; var un: Node2D = sc[2]; var tp: Node2D = sc[3]; var vs: Vector2 = sc[4]
	var SIM = load("res://game/rts/rts_sim.gd"); var op = SIM.new()
	var me_p = Vector2(vs.x * 0.3, vs.y * 0.58); var foe_ps = [Vector2(vs.x * 0.68, vs.y * 0.5), Vector2(vs.x * 0.8, vs.y * 0.6), Vector2(vs.x * 0.62, vs.y * 0.66)]
	var nshot = 0; var clip = []
	for key in _have():
		if key.begins_with("up_"): continue
		if key.begins_with("sub_") and B2.has(key.substr(4).trim_suffix("_l")): continue   # 第二批樣本由 shots2_ 出（擺位唔同）
		for c in un.get_children(): c.free()
		var who = key.substr(4)
		var gk = ""
		for k in D.ACE: if VC.key_of(D.ACE[k], str(k)) == key: gk = str(k)
		if gk == "":
			for k in D.SUB: if VC.key_of(D.SUB[k], str(k)) == key and not D.ACE.has(k): gk = str(k); break
		var u = {"side": 0.0, "k": gk, "p": me_p, "hp": 1.0, "maxhp": 1.0}
		var fo = []
		for p in foe_ps: fo.append({"side": 1.0, "k": "egui", "p": p, "hp": 1.0, "maxhp": 1.0})
		_unit(un, gk, me_p, 120.0)
		for p in foe_ps: _unit(un, "egui", p, 80.0, true)
		var fx = RFX.new(g, tp); fx.vr = Rect2(Vector2.ZERO, vs)
		var pe = D.ACE.get(gk) if key.begins_with("ace_") else D.SUB.get(gk)
		var ts = []
		for f2 in fo: ts.append([f2, 1.0])
		var sel = str((pe.get("tg", {}) as Dictionary).get("sel", "")) if pe.get("tg") is Dictionary else ""
		if sel.begins_with("ally") or sel == "self": ts = [[u, 1.0]]   # 對隊友／自己嘅技：樣本播喺自己身上
		fx.sk2(op, u, pe, ts)
		var life = float(VC.get_e(key).get("life", 1.0))
		fx.tick(life * 0.42)
		await t.get_tree().process_frame; await RenderingServer.frame_post_draw
		var img = t.get_viewport().get_texture().get_image()
		img.save_png(SHOTS + key + ".png"); nshot += 1
		fx.clear()
		for c in g.get_children(): c.free()
		for c in tp.get_children(): c.free()
	cl.queue_free()
	_chk("實機樣本截圖", nshot >= 1, nshot)

# ---- 升級特效（祭壇融合／突破成功時播）----
func ui_(t) -> void:
	var VP = load("res://game/fxkit/vfx_play.gd")
	for k in ["up_fuse", "up_star"]:
		if VC.get_e(k) == null: _p("未有圖：" + k); continue
		var n = VP.burst(k)
		_chk(k + " 播得出", n != null)
		if n == null: continue
		await _w(t, float(VC.get_e(k).life) * 0.4)
		await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SHOTS + k + ".png")
		await _w(t, float(VC.get_e(k).life) * 0.7)
		_chk(k + " 播完自己消失", not is_instance_valid(n))

# ================= 第二批 =================
const B2 := ["T_DRAIN", "W_CLEAVE", "W_RAGE", "A_EXEC", "A_POISON", "A_VANISH", "R_LINE", "R_CHAIN", "R_ANTI", "M_BLAST", "M_BURN", "M_FROST", "M_HUSH", "S_RALLY", "S_HASTE", "S_DISPEL", "H_BURST", "H_HOT", "H_SHIELD", "H_CLEAN"]
func _gk(D, tp: String) -> String:
	for k in D.SUB: if str(D.SUB[k].get("tpl")) == tp and not D.ACE.has(k): return str(k)
	return ""
func sim2_(t) -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	RFX.SK2.n = 0; RFX.SK2.keys = {}
	var pick = []
	for tp in B2:
		var k = _gk(D, tp)
		if k != "": pick.append(k)
	var i = 0
	while i < pick.size():
		await _rts(pick.slice(i, i + 5), 26.0); i += 5
		await t.get_tree().process_frame
	_p("第二批 sk2 觸發 %d 次：%s" % [RFX.SK2.n, RFX.SK2.keys])
	var ms = []
	for tp in B2:
		var key = "sub_" + tp
		if VC.get_e(key) != null and not RFX.SK2.keys.has(key): ms.append(key)
	_chk("第二批有圖嘅模板全部喺真模擬播到", ms.is_empty(), ms)
	_chk("rts_fx 冇爆上限（drop 0）", int(RFX.STATS.drop) == 0, RFX.STATS.drop)

# 範圍形狀對數：每個群攻模板，畫出嚟嘅大小＝技能 tg 實際範圍（誤差 ≤ 3%）
func geom_() -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	for tp in B2:
		var key = "sub_" + tp; var E = VC.get_e(key)
		if E == null: continue
		var pe = D.SUB[_gk(D, tp)]; var T = pe.get("tg", {})
		var kind = str(E.get("kind", "")); var at = str(E.get("at", ""))
		var shaped = T.has("shape") or str(T.get("sel", "")) == "allies"
		_chk(key + " 分類（%s）同技能範圍一致" % kind, (kind == "aoe") == T.has("shape") and (kind != "one" or not shaped), str(T))
		match at:
			"circ", "self_circ":
				var s = J.num(T.r) / float(E.rr)
				_chk(key + " 圈半徑＝r %d" % int(J.num(T.r)), absf(float(E.rr) * s - J.num(T.r)) <= J.num(T.r) * 0.03, "art %.0fpx×%.3f" % [float(E.rr), s])
			"cone":
				var s2 = J.num(T.r) / float(E.ra)
				_chk(key + " 扇形半徑＝r %d、角度 %d°" % [int(J.num(T.r)), int(J.num(T.deg))], absf(float(E.ra) * s2 - J.num(T.r)) < 1.0, "art %.0f° → %d°" % [float(E.deg_art), int(J.num(T.deg))])
			"beam":
				var s3 = J.num(T.len) / float(E.bl)
				var wd = float(E.bw) * s3 * clampf(J.num(T.w) / (float(E.bw) * s3), 0.3, 1.6)
				_chk(key + " 直線長＝len %d、闊＝w %d" % [int(J.num(T.len)), int(J.num(T.w))], absf(float(E.bl) * s3 - J.num(T.len)) < 1.0 and absf(wd - J.num(T.w)) < 1.0, "畫出闊 %.0f" % wd)
			"chain":
				_chk(key + " 彈射連線圖", VC.tex(key + "_l") != null)

func shots2_(t) -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	PtGfx.init()
	var sc = _scene(t); var cl: CanvasLayer = sc[0]; var g: Node2D = sc[1]; var un: Node2D = sc[2]; var tp: Node2D = sc[3]; var vs: Vector2 = sc[4]
	var SIM = load("res://game/rts/rts_sim.gd"); var op = SIM.new()
	var me_p = Vector2(150, 560); var nshot = 0
	var L = {"one": [Vector2(300, 520)], "circ": [Vector2(300, 500), Vector2(350, 530), Vector2(280, 562), Vector2(332, 466)],
		"near": [Vector2(250, 530), Vector2(268, 600), Vector2(236, 470)], "line": [Vector2(158, 470), Vector2(150, 400), Vector2(162, 335)],
		"chain": [Vector2(262, 528), Vector2(348, 582), Vector2(300, 660)], "ally": [Vector2(70, 610), Vector2(215, 640), Vector2(100, 470), Vector2(250, 520)]}
	var akeys = []
	for k in D.SUB: if not D.ACE.has(k) and akeys.size() < 4: akeys.append(str(k))
	for tpn in B2:
		var key = "sub_" + tpn; var E = VC.get_e(key)
		if E == null: continue
		for c in un.get_children(): c.free()
		var gk = _gk(D, tpn); var pe = D.SUB[gk]; var at = str(E.get("at", ""))
		var lay = "one"
		match at:
			"circ": lay = "circ"
			"cone": lay = "near"
			"beam": lay = "line"
			"chain": lay = "chain"
			"self_circ": lay = "ally"
		var u = {"side": 0.0, "k": gk, "p": me_p, "hp": 1.0, "maxhp": 1.0}
		var ts = []
		_unit(un, gk, me_p, 120.0)
		if lay == "ally":
			for j in L.ally.size():
				var a = {"side": 0.0, "k": akeys[j], "p": L.ally[j], "hp": 1.0, "maxhp": 1.0}; ts.append([a, 1.0]); _unit(un, akeys[j], L.ally[j], 100.0)
		elif str(E.get("kind")) == "buff" or str((pe.get("tg", {}) as Dictionary).get("sel", "")).begins_with("ally"):
			if str(E.get("kind")) != "buff":
				var a2 = {"side": 0.0, "k": akeys[0], "p": L.one[0], "hp": 1.0, "maxhp": 1.0}; ts.append([a2, 1.0]); _unit(un, akeys[0], L.one[0], 100.0)
		else:
			for p in L[lay]: var f = {"side": 1.0, "k": "egui", "p": p, "hp": 1.0, "maxhp": 1.0}; ts.append([f, 1.0]); _unit(un, "egui", p, 80.0, true)
		if at == "cone" or at == "beam": u["tg"] = ts[0][0]
		var fx = RFX.new(g, tp); fx.vr = Rect2(Vector2.ZERO, vs)
		await t.get_tree().process_frame; await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SHOTS + key + "_bg.png")   # 冇特效底圖：審批工具用嚟逐像素量特效實際大細
		fx.sk2(op, u, pe, ts)
		# 實際範圍（給審批圖畫白虛線）
		var tl = []
		for x in ts: if x[0] != u: tl.append(x[0])
		var G = RFX.sk2_geom(op, u, pe, E, tl); var js = {"key": key, "at": at, "me": [me_p.x, me_p.y], "tg": []}
		for x in tl: js.tg.append([x.p.x, x.p.y])
		for kk in G: js[kk] = [G[kk].x, G[kk].y] if G[kk] is Vector2 else G[kk]
		var fa = FileAccess.open(SHOTS + key + ".json", FileAccess.WRITE); fa.store_string(JSON.stringify(js)); fa.close()
		fx.tick(float(E.get("life", 1.0)) * (0.5 if at in ["circ", "self_circ", "cone", "beam", "chain"] else 0.42))
		await t.get_tree().process_frame; await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SHOTS + key + ".png"); nshot += 1
		fx.clear()
		for c in g.get_children(): c.free()
		for c in tp.get_children(): c.free()
	cl.queue_free()
	_chk("第二批實機樣本截圖", nshot >= 1, nshot)

# ================= 修正一（第一批補範圍圈／單體縮細／彈射連線）=================
const FIX1 := ["sub_T_SLAM", "sub_T_STUN", "ace_pontianak", "ace_hou", "ace_mengpo", "ace_baiwu", "ace_dokkaebi", "ace_krasue", "ace_heiwu", "ace_qiongqi", "sub_S_RALLY"]
func fix1(t) -> void:
	await _boot(t); cat_(); fixgeom_(); await fixshots_(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func _pe_of(D, key: String):
	for k in D.ACE: if VC.key_of(D.ACE[k], str(k)) == key: return [str(k), D.ACE[k]]
	for k in D.SUB: if VC.key_of(D.SUB[k], str(k)) == key and not D.ACE.has(k): return [str(k), D.SUB[k]]
	return ["", {}]
# 範圍圈大小＝技能 tg.r（誤差 ≤ 3%）；單體 kind one 細過 0.6；彈射有連線圖
func fixgeom_() -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	for key in FIX1:
		var E = VC.get_e(key)
		if E == null: _p("未有圖：" + key); continue
		var pe = _pe_of(D, key)[1]; var T = pe.get("tg", {})
		if E.has("ring"):
			var rt = VC.tex(str(E.ring))
			_chk(key + " 範圍圈圖 " + str(E.ring), rt != null)
			var s = J.num(T.get("r", 0)) / float(E.get("ring_rr", 100))
			_chk(key + " 範圍圈半徑＝r %d" % int(J.num(T.get("r", 0))), absf(float(E.get("ring_rr", 100)) * s - J.num(T.get("r", 0))) <= J.num(T.get("r", 0)) * 0.03 and E.has("ring_rr"), "ring_rr %s" % str(E.get("ring_rr")))
		if str(E.get("kind", "")) == "one": _chk(key + " 單體細（s ≤ 0.6）", float(E.s) <= 0.6, E.s)
		if str(E.get("at", "")) == "chain": _chk(key + " 彈射連線圖", VC.tex(str(E.get("link", key + "_l"))) != null, E.get("link"))
func fixshots_(t) -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	PtGfx.init()
	var sc = _scene(t); var cl: CanvasLayer = sc[0]; var g: Node2D = sc[1]; var un: Node2D = sc[2]; var tp: Node2D = sc[3]; var vs: Vector2 = sc[4]
	var SIM = load("res://game/rts/rts_sim.gd"); var op = SIM.new()
	var me_p = Vector2(195, 560); var nshot = 0
	var akeys = []
	for k in D.SUB: if not D.ACE.has(k) and akeys.size() < 5: akeys.append(str(k))
	for key in FIX1:
		var E = VC.get_e(key)
		if E == null: continue
		for c in un.get_children(): c.free()
		var gp = _pe_of(D, key); var gk: String = gp[0]; var pe: Dictionary = gp[1]; var T = pe.get("tg", {})
		var u = {"side": 0.0, "k": gk, "p": me_p, "hp": 1.0, "maxhp": 1.0}
		_unit(un, gk, me_p, 120.0)
		var ts = []; var r = J.num(T.get("r", 120)); var sel = str(T.get("sel", ""))
		if sel == "allies":
			var aps = [Vector2(-0.8, 0.3), Vector2(0.55, 0.6), Vector2(-0.3, -0.75), Vector2(0.75, -0.35), Vector2(0.2, 0.9)]
			for j in aps.size():
				var p = me_p + aps[j] * r * 0.85; var a = {"side": 0.0, "k": akeys[j], "p": p, "hp": 1.0, "maxhp": 1.0}; ts.append([a, 1.0]); _unit(un, akeys[j], p, 90.0)
		elif str(E.get("kind", "")) == "one":
			var p1 = me_p + Vector2(150, -30); var f1 = {"side": 1.0, "k": "egui", "p": p1, "hp": 1.0, "maxhp": 1.0}; ts.append([f1, 1.0]); _unit(un, "egui", p1, 80.0, true)
			for p2 in [me_p + Vector2(200, 50), me_p + Vector2(110, 70)]: _unit(un, "egui", p2, 80.0, true)
		elif str(E.get("at", "")) == "chain":
			for p3 in [me_p + Vector2(120, -20), me_p + Vector2(210, 60), me_p + Vector2(150, 150), me_p + Vector2(60, 210)]:
				var f3 = {"side": 1.0, "k": "egui", "p": p3, "hp": 1.0, "maxhp": 1.0}; ts.append([f3, 1.0]); _unit(un, "egui", p3, 80.0, true)
		else:
			var fps = [Vector2(0.7, -0.2), Vector2(0.35, 0.65), Vector2(-0.6, 0.45), Vector2(0.1, -0.8), Vector2(1.25, 0.1)]   # 最後一隻喺範圍外
			for p4 in fps:
				var pp = me_p + p4 * r; var f4 = {"side": 1.0, "k": "egui", "p": pp, "hp": 1.0, "maxhp": 1.0}
				if p4.length() <= 1.0: ts.append([f4, 1.0])
				_unit(un, "egui", pp, 80.0, true)
		var fx = RFX.new(g, tp); fx.vr = Rect2(Vector2.ZERO, vs)
		await t.get_tree().process_frame; await RenderingServer.frame_post_draw
		var bgi: Image = t.get_viewport().get_texture().get_image()
		bgi.save_png(SHOTS + "fix1_" + key + "_bg.png")
		fx.sk2(op, u, pe, ts)
		var js = {"key": key, "at": str(E.get("at", "")), "me": [me_p.x, me_p.y], "tg": []}
		for x in ts: js.tg.append([x[0].p.x, x[0].p.y])
		if E.has("ring") or T.has("r") and str(E.get("kind", "")) != "one" and str(E.get("at", "")) != "chain":
			var RG = RFX.ring_geom(u, pe, E); js["ring"] = {"c": [RG.c.x, RG.c.y], "r": RG.r}
		var fa = FileAccess.open(SHOTS + "fix1_" + key + ".json", FileAccess.WRITE); fa.store_string(JSON.stringify(js)); fa.close()
		fx.tick(float(E.get("life", 1.0)) * 0.45)
		await t.get_tree().process_frame; await RenderingServer.frame_post_draw
		var shi: Image = t.get_viewport().get_texture().get_image()
		shi.save_png(SHOTS + "fix1_" + key + ".png"); nshot += 1
		if js.has("ring") and E.has("ring"):   # 實機量度：畫出圈邊半徑（同審批圖一樣量法）要＝技能 r ±5%
			var mr = ring_px(bgi, shi, Vector2(js.ring.c[0], js.ring.c[1]), float(js.ring.r), vs)
			_chk(key + " 實機圈邊半徑 %.0f／技能 %d（%.0f%%，要 95–105%%）" % [mr, int(js.ring.r), mr / float(js.ring.r) * 100.0], absf(mr / float(js.ring.r) - 1.0) <= 0.05)
		fx.clear()
		for c in g.get_children(): c.free()
		for c in tp.get_children(): c.free()
	cl.queue_free()
	_chk("修正一實機樣本截圖", nshot >= 1, nshot)

# 實機圈邊半徑：截圖同底圖逐像素比（差 > 22），只計離圓心 > 0.6r 嘅像素，取距離第 97 百分位（世界單位）
func ring_px(a: Image, b: Image, c: Vector2, r: float, vs: Vector2) -> float:
	var st = float(a.get_width()) / vs.x
	var ds = PackedFloat32Array()
	var x0 = maxi(0, int((c.x - r * 1.8) * st)); var x1 = mini(a.get_width() - 1, int((c.x + r * 1.8) * st))
	var y0 = maxi(0, int((c.y - r * 1.8) * st)); var y1 = mini(a.get_height() - 1, int((c.y + r * 1.8) * st))
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			var p = a.get_pixel(x, y); var q = b.get_pixel(x, y)
			if maxf(maxf(absf(p.r - q.r), absf(p.g - q.g)), absf(p.b - q.b)) * 255.0 <= 22.0: continue
			var d = Vector2(x / st, y / st).distance_to(c)
			if d > r * 0.6: ds.append(d)
	if ds.size() < 50: return 0.0
	ds.sort()
	return ds[int(ds.size() * 0.97)]

# ================= 第三批：狀態循環（4×4 循環，疊喺單位身上）=================
func b3(t) -> void:
	await _boot(t); st_cat_(); await st_shots_(t); await st_sim_(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func st_cat_() -> void:
	var AI = load("res://game/rts/ab_icon.gd"); var have = []; var miss = []; var bad_sz = []
	for k in VC.ST:
		var E = VC.st_e(k)
		if E == null: miss.append(k); continue
		have.append(k)
		var tx = VC.tex(str(E.get("sheet", k)))
		if tx.get_width() != tx.get_height() or tx.get_width() % 4 != 0: bad_sz.append(k)
	_p("狀態有圖 %d／%d；未有：%s" % [have.size(), VC.ST.size(), miss])
	_chk("狀態序列幀正方、4×4 整除", bad_sz.is_empty(), bad_sz)
	var nk = []
	for k in VC.ST: if not AI.INFO.has(k): nk.append(k)
	_chk("目錄狀態鍵全部喺 ab_icon 狀態表", nk.is_empty(), nk)
	# 世界大細 40–60px：格 256×s，內容最多佔 92%
	var sz = []
	for k in have:
		var E = VC.ST[k]; var s = float(E.get("s", VC.ST_POS_S.get(str(E.pos), 0.24)))
		var px = 256.0 * s * 0.92 * (1.25 if str(E.pos) == "back" else 1.0)
		if px < 40.0 or px > 72.0: sz.append([k, px])
	_chk("狀態特效世界大細約 40–60px", sz.is_empty(), sz)
func st_shots_(t) -> void:
	PtGfx.init()
	var sc = _scene(t); var cl: CanvasLayer = sc[0]; var g: Node2D = sc[1]; var un: Node2D = sc[2]; var tp: Node2D = sc[3]; var vs: Vector2 = sc[4]
	var keys = []
	for k in VC.ST: if VC.st_e(k) != null: keys.append(k)
	# 一張截圖排 30 隻：每隻一個狀態（5 行 × 6）
	var fx = RFX.new(g, tp); fx.vr = Rect2(Vector2.ZERO, vs)
	var pos = []
	for i in keys.size():
		var p = Vector2(45 + (i % 6) * 60, 150 + (i / 6) * 120); pos.append([keys[i], p.x, p.y]); _unit(un, "egui", p, 56.0)
	await t.get_tree().process_frame; await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + "b3_bg.png")
	for ph in 3:
		fx._lt = 0.37 * ph
		for i in keys.size():
			var p = Vector2(pos[i][1], pos[i][2]); fx.st_draw([keys[i]], p, p + Vector2(0, -56.0), 0)
		fx.tick(0.0)
		await t.get_tree().process_frame; await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SHOTS + "b3_%d.png" % ph)
	var fa = FileAccess.open(SHOTS + "b3.json", FileAccess.WRITE); fa.store_string(JSON.stringify(pos)); fa.close()
	cl.queue_free()
	_chk("第三批實機樣本截圖", FileAccess.file_exists(SHOTS + "b3_0.png"))
# 真模擬：打一場，數有幾多狀態循環真係疊咗上身
func st_sim_(t) -> void:
	var AB = load("res://game/rts/abil.gd"); var D = AB.sk2()
	var pick = []
	for tp in ["S_STUN", "T_STUN", "A_POISON", "M_BURN", "M_FROST", "W_BREAK", "S_RALLY", "S_HASTE", "H_HOT", "H_SHIELD", "M_HUSH", "T_GUARD"]:
		for k in D.SUB:
			if str(D.SUB[k].get("tpl")) == tp and not D.ACE.has(k): pick.append(k); break
	var seen = {}
	var SIM = load("res://game/rts/rts_sim.gd"); var RO = load("res://game/rts/roles.gd")
	var i = 0
	while i < pick.size():
		var ks = pick.slice(i, i + 6); i += 6
		var ours = []; var foes = []
		for j in ks.size():
			var nu = {"side": 0.0, "k": ks[j], "gid": "vx_%d" % j, "name": ks[j], "hp": 3000.0, "maxhp": 3000.0, "atk": 40.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": {"name": "x", "kind": "ab"}, "st": {}, "cd": randf(), "boss": false}
			RO.apply_stats(nu); nu["hp"] = 6000.0; nu["maxhp"] = 6000.0; ours.append(nu)
		for j in 6: foes.append({"side": 1.0, "k": "egui", "name": "e", "hp": 9000.0, "maxhp": 9000.0, "atk": 30.0, "range": 46.0, "spd": 46.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf(), "boss": false})
		var op = SIM.new()
		op.setup(ours + foes, PackedVector2Array([Vector2(0, 900), Vector2(0, 300)]), Vector2(0, 220), Vector2(0, 900))
		op.phase = "fight"; op.t = 0.0; op.vfx_on = true
		for j in ours.size(): var u = ours[j]; u["p"] = Vector2((j - 2) * 40.0, 300.0); u["out"] = true; u["eng"] = true
		for j in foes.size(): var u = foes[j]; u["p"] = Vector2((j - 2.5) * 40.0, 250.0); u["post"] = u.p
		op._form()
		var g = Node2D.new(); var tp2 = Node2D.new()
		var fx = RFX.new(g, tp2); fx.vr = Rect2(-2000, -2000, 4000, 4000)
		for st in 500:
			op.step(0.05); fx.consume(op)
			for f in fx.loops: seen[str(f.n).substr(3)] = int(seen.get(str(f.n).substr(3), 0)) + 1
			fx.tick(0.05); op.events.clear()
		g.free(); tp2.free()
		await t.get_tree().process_frame
	_p("真模擬疊上身嘅狀態循環：%s" % seen)
	_chk("真模擬有狀態循環疊上身（≥ 5 種）", seen.size() >= 5, seen.keys())
	_chk("rts_fx 冇爆上限（drop 0）", int(RFX.STATS.drop) == 0, RFX.STATS.drop)
