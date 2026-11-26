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
		if k.begins_with("sub_") and not RFX.SK2.keys.has(k): ms.append(k)
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
