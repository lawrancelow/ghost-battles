# [sortie] 野外出擊測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> sortie res://tools/tests/sortie_test.gd logic|shots
#   logic：舊存檔、據點 fallback、消耗扣除、不夠不能出、首勝只一次、重複獎勵、唔推主線、已清空／重生、圈數開放、叫回退消耗、輸咗唔清空、
#          稀有掉落 10000 次模擬、保底
#   shots：logic ＋ 截圖（/home/claude/docs/sortie_shots/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/sortie_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const SOV = preload("res://game/sortie/so_view.gd")

func _p(m): print("[sortie] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	if not shots: return
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
func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)
func _prep(t, m) -> void:
	var S = J.G.S; var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	if S.ghosts.size() < 3:
		var have = []
		for g in S.ghosts: have.append(str(g.k))
		for k in ["xiaozhi", "toyol"]:
			if not k in have: J.cl(J.G.get("joinGhost"), null, [k])
		await _skip(t, 8)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
	S["lv"] = maxf(3.0, J.num(S.lv))
	S.res["troops"] = 100.0
	var Bt = J.G.get("Battle"); Bt["auto"] = true
	await _f(t, 3)
# 快轉：唔等真時間，逐步推模擬（同 RTS.tick 一樣，包括結算）
func _ff(op, until_phases: Array, max_s := 300.0) -> void:
	var n = int(max_s / 0.1)
	for i in n:
		if op.phase in until_phases: return
		RTS._last_f = -1
		RTS.tick(0.1)
func _weak_foes(op) -> void:
	for u in op.units:
		if J.num(u.side) == 1: u["hp"] = 1.0; u["maxhp"] = maxf(1.0, J.num(u.maxhp))
func _rich() -> void:
	J.G.S.res["buns"] = 5000.0; J.G.S.res["coins"] = 100000.0
func _win(e: Dictionary) -> Dictionary:   # 出擊並打贏：回 {r, op}
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	if op == null: return {"r": r, "op": null}
	_weak_foes(op)
	_ff(op, ["back", "done"])
	_ff(op, ["done"])
	return {"r": r, "op": op}

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	await _prep(t, m)
	SO.force_open = true
	SO.test_now = 1000000.0
	await old_save(t, m)
	await camps_check(t, m)
	await cost_flow(t, m)
	await first_and_repeat(t, m)
	await recall_and_loss(t, m)
	rare_sim()
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- 舊存檔：冇 S.sortie 都得 ----
func old_save(t, m) -> void:
	var S = J.G.S
	S.erase("sortie")
	var keys0 = (S as Dictionary).keys()
	var e = SO.camps()[0]
	var s0 = SO.state(e)
	_chk("舊存檔冇 sortie 欄位：自動補、可用", S.get("sortie") is Dictionary and s0 == "open", s0)
	var added = []
	for k in (S as Dictionary).keys(): if not k in keys0: added.append(k)
	_chk("只加 sortie 一個新欄位", added == [] or added == ["sortie"], added)
	# 模擬讀舊存檔：camps 入面欄位唔齊
	S.sortie.camps[SO.key(e)] = {"first": true}
	var c = SO.cst(e)
	_chk("舊／缺欄位據點記錄自動補齊", c.has("pity") and c.has("clr") and J.t(c.first))
	S.erase("sortie")

# ---- 據點：每關 fallback 3～4 個、等級近低遠高 ----
func camps_check(t, m) -> void:
	var okc = true; var info = []
	for c in 6:
		var cs = SO.camps(c)
		var lvs = []
		for e in cs: lvs.append(int(e.lv))
		info.append("%d:%s" % [c + 1, str(lvs)])
		if cs.size() < 3 or cs.size() > 4: okc = false
		for i in range(1, cs.size()):
			if float(cs[i].lv) < float(cs[i - 1].lv): okc = false
			var mk = ZD.zrect("market", c).get_center()
			if cs[i].pos.distance_to(mk) + 1 < cs[i - 1].pos.distance_to(mk): okc = false
		for e in cs:
			var inside = false
			for z in ZD.of_type("wild", c): if ZD.rect(z.rect).has_point(e.pos): inside = true
			if not inside: okc = false
	_chk("六關每關 3～4 個臨時據點、喺野外區內、近村低級遠處高級", okc, " ".join(info))
	var src = ZD.mdef(0).duplicate()
	ZD.mdef(0)["sorties"] = [{"id": "a1", "ring": 2, "lv": 7, "pos": [400, 300]}]
	var cs2 = SO.camps(0)
	_chk("zones.json 有 sorties 陣列就用佢（id／ring／lv／pos）", cs2.size() == 1 and cs2[0].id == "a1" and int(cs2[0].ring) == 2 and int(cs2[0].lv) == 7 and cs2[0].pos == Vector2(400, 300))
	ZD.mdef(0).erase("sorties")
	var st = SO.stage_of(SO.camps(0)[3])
	_chk("第 4 圈敵人 5 隻、唔用主線名角", st.en.size() == 5 and not ("eguiking" in st.en), st.en)
	if shots:
		var e0 = SO.camps(0)[0]
		_cam(m, Vector2(670, 260), m.village.size.x / 520.0)
		await _w(t, 1.2); await _shot(t, "01_camps_plates")

# ---- 消耗：不夠不能出；夠就按陣容扣 ----
func cost_flow(t, m) -> void:
	var S = J.G.S
	var e = SO.camps(0)[0]
	var lu = SO.lineup()
	var cs = SO.cost(e, lu)
	_p("lineup %s cost %s" % [str(lu), str(cs)])
	_chk("陣容有名鬼同陰兵", lu.hero >= 1 and lu.yin >= 1, lu)
	_chk("消耗＝每隊陰兵壽包＋名鬼／遊魂兵冥幣", int(cs.buns) == lu.yin * SO.COST_YIN_BUNS[0] and int(cs.coins) == int(round(lu.ml * SO.COST_ML_COIN * e.lv + lu.hero * SO.COST_HERO_COIN * e.lv)), cs)
	S.res["buns"] = float(cs.buns) - 1.0; S.res["coins"] = 100000.0
	if shots:
		SOV.open_card(e); await _w(t, 0.6); await _shot(t, "02_card_poor"); SOV.close_card()
	var r = SOV.press_go(e)
	_chk("壽包差 1 個：不能出擊", r == "poor" and RTS.ops.is_empty() and int(S.res.buns) == int(cs.buns) - 1, r)
	S.res["buns"] = float(cs.buns) + 10.0; S.res["coins"] = float(cs.coins) - 1.0
	r = SO.dispatch(e)
	_chk("冥幣差 1：不能出擊", r == "poor" and RTS.ops.is_empty(), r)
	_rich()
	var b0 = J.num(S.res.buns); var c0 = J.num(S.res.coins)
	if shots:
		_cam(m, e.pos + Vector2(0, 80), m.village.size.x / 420.0)
		SOV.open_card(e); await _w(t, 0.6); await _shot(t, "03_card_cost"); SOV.close_card()
	r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	_chk("夠就出擊", r == "ok" and op != null, r)
	_chk("出發即扣消耗（壽包、冥幣）", absf(b0 - J.num(S.res.buns) - cs.buns) < 0.01 and absf(c0 - J.num(S.res.coins) - cs.coins) < 0.01, [b0 - J.num(S.res.buns), c0 - J.num(S.res.coins)])
	var cnt = RTS._count(op)
	_chk("出擊陣容同小卡計嘅一樣（名鬼／陰兵／遊魂兵）", cnt.hero == lu.hero and cnt.yin == lu.yin and cnt.ml == lu.ml, [cnt, lu])
	SO.cst(e)["first"] = true
	r = SO.dispatch(SO.camps(0)[1])
	SO.cst(e)["first"] = false
	_chk("同時只出一場（rts MAX_OPS）", r == "busy", r)
	RTS.recall(op); _ff(op, ["done"])
	_chk("行軍中叫回：退回消耗", absf(b0 - J.num(S.res.buns)) < 0.01 and absf(c0 - J.num(S.res.coins)) < 0.01, [J.num(S.res.buns), b0])

# ---- 首勝只一次、重複獎勵、唔推主線、已清空、重生、圈數開放 ----
func first_and_repeat(t, m) -> void:
	var S = J.G.S
	_rich()
	var e = SO.camps(0)[0]; var e2 = SO.camps(0)[1]
	_chk("第 2 圈未開放（第 1 圈未首勝）", SO.state(e2) == "locked" and SO.dispatch(e2) == "locked")
	var ch0 = J.num(S.chests.get("g", 0)); var c0 = J.num(S.res.coins); var pl0 = J.num(S.res.planks)
	var cl0 = (S.cleared as Dictionary).duplicate(); var qi0 = S.get("qi"); var zb0 = str(ZD.st().get("boss"))
	var cs = SO.cost(e)
	var w = {}
	if shots:
		SO.dispatch(e)
		var op0 = RTS.op_for(SO.sid_of(e))
		_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
		_ff(op0, ["fight"]); await _w(t, 0.3)
		for i in 6: RTS._last_f = -1; RTS.tick(0.1)
		await _w(t, 0.4); await _shot(t, "04_fight")
		_weak_foes(op0); _ff(op0, ["back"])
		await _w(t, 0.8); await _shot(t, "05_first_win_report")
		_ff(op0, ["done"])
		w = {"r": "ok", "op": op0}
	else:
		w = _win(e)
	var rep = RTS.last_report
	_p("report %s" % str(rep))
	var lv = float(e.lv)
	_chk("首勝：出擊 ok、打贏", w.r == "ok" and J.t(rep.get("win")) and J.t(rep.get("first")), rep.get("head"))
	_chk("首勝獎：綠箱 +1", J.num(S.chests.get("g", 0)) == ch0 + 1, [ch0, S.chests.get("g")])
	var exp_coin = 20.0 * lv + SO.REW_COIN * lv + SO.FIRST_COIN * lv - cs.coins
	var rare_coin = 0.0
	_chk("首勝冥幣＝再打獎＋出擊獎＋首勝獎−消耗", absf(J.num(S.res.coins) - c0 - exp_coin) < 1.5 + rare_coin, [J.num(S.res.coins) - c0, exp_coin])
	_chk("普通獎：棺材板 +%d" % SO.REW_PLANK[0], absf(J.num(S.res.planks) - pl0 - SO.REW_PLANK[0]) < 0.01)
	var added = []
	for k in S.cleared: if not cl0.has(k): added.append(k)
	_chk("唔推主線：S.cleared 冇新記錄、主線任務唔變、野外王唔變", added.is_empty() and S.get("qi") == qi0 and str(ZD.st().get("boss")) == zb0, added)
	_chk("打下後已清空、要等 %d 分鐘重生" % int(SO.RESPAWN_MIN[0]), SO.state(e) == "cleared" and absf(SO.cleared_left_s(e) - SO.RESPAWN_MIN[0] * 60) < 1.0, SO.cleared_left_s(e))
	_chk("已清空不能出擊", SO.dispatch(e) == "cleared")
	_chk("第 1 圈首勝後：第 2 圈開放", SO.state(e2) == "open")
	if shots:
		_cam(m, e.pos + Vector2(0, 40), m.village.size.x / 420.0)
		await _w(t, 0.8); await _shot(t, "06_cleared")
		SOV.open_card(e); await _w(t, 0.5); await _shot(t, "07_card_cleared"); SOV.close_card()
	SO.test_now += SO.RESPAWN_MIN[0] * 60000.0 - 2000.0
	_chk("重生前 2 秒仍然已清空", SO.state(e) == "cleared")
	SO.test_now += 2500.0
	_chk("夠鐘重生：可再出擊", SO.state(e) == "open")
	if shots:
		await _w(t, 0.8); await _shot(t, "08_respawned")
	ch0 = J.num(S.chests.get("g", 0)); c0 = J.num(S.res.coins); pl0 = J.num(S.res.planks)
	SO.cst(e)["pity"] = 0.0
	var rn0 = J.num(SO.cst(e).get("rare", 0))
	w = _win(e)
	rep = RTS.last_report
	var got_rare = J.num(SO.cst(e).get("rare", 0)) > rn0
	_chk("再打：打贏但唔係首勝", w.r == "ok" and J.t(rep.get("win")) and not J.t(rep.get("first")), rep.get("head"))
	_chk("再打：冇首勝箱（綠箱唔變）", J.num(S.chests.get("g", 0)) == ch0)
	exp_coin = 20.0 * lv + SO.REW_COIN * lv - cs.coins
	_chk("再打：普通冥幣＋棺材板", absf(J.num(S.res.coins) - c0 - exp_coin) < 1.5 and absf(J.num(S.res.planks) - pl0 - SO.REW_PLANK[0]) < 0.01, [J.num(S.res.coins) - c0, exp_coin, got_rare])
	_chk("勝場數、出擊次數有記", J.num(SO.cst(e).wins) == 2 and J.num(SO.cst(e).tries) >= 3, SO.cst(e))
	# 第 2 圈首勝：藍箱
	SO.test_now += 10 * 60000.0
	var b0 = J.num(S.chests.get("b", 0))
	w = _win(e2)
	_chk("第 2 圈首勝：藍箱 +1", w.r == "ok" and J.num(S.chests.get("b", 0)) == b0 + 1, w.r)
	if shots:
		var e4 = SO.camps(0)[3]
		SO.cst(SO.camps(0)[2])["first"] = true
		_cam(m, e4.pos + Vector2(0, 80), m.village.size.x / 420.0)
		SOV.open_card(e4); await _w(t, 0.6); await _shot(t, "09_card_ring4"); SOV.close_card()

# ---- 輸咗：唔清空、唔算首勝；消耗唔退 ----
func recall_and_loss(t, m) -> void:
	var S = J.G.S
	_rich()
	var e3 = SO.camps(0)[2]
	S.sortie.camps.erase(SO.key(e3))
	SO.cst(SO.camps(0)[1])["first"] = true
	var b0 = J.num(S.res.buns)
	var r = SO.dispatch(e3)
	var op = RTS.op_for(SO.sid_of(e3))
	_chk("第 3 圈出擊", r == "ok" and op != null, r)
	if op == null: return
	_ff(op, ["fight"])
	for u in op.units: if J.num(u.side) == 0 and not J.t(u.get("minion")): u["hp"] = 0.0
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 999999.0; u["maxhp"] = 999999.0
	_ff(op, ["back", "done"]); _ff(op, ["done"])
	_chk("名鬼全倒：輸", op.result != null and not J.t(op.result.win), op.result)
	_chk("輸咗：據點唔清空、冇首勝", SO.state(e3) == "open" and not J.t(SO.cst(e3).get("first")))
	_chk("輸咗：消耗唔退", J.num(S.res.buns) < b0)

# ---- 稀有掉落 10000 次模擬、保底 ----
func rare_sim() -> void:
	SO.rng.seed = 12345
	for r in 4:
		var p = SO.RARE_P[r]; var N = SO.RARE_PITY[r]
		var c = {"pity": 0.0, "rare": 0.0}
		var hit = 0
		for i in 10000: if SO.roll_rare(c, r, false): hit += 1
		var f0 = hit / 10000.0
		_chk("第%d圈 冇保底 10000 次：%.2f%%（設定 %.1f%%）" % [r + 1, f0 * 100, p * 100], absf(f0 - p) < 0.006)
		c = {"pity": 0.0, "rare": 0.0}
		hit = 0; var gap = 0; var gmax = 0
		for i in 10000:
			gap += 1
			if SO.roll_rare(c, r, true): hit += 1; gmax = maxi(gmax, gap); gap = 0
		var f1 = hit / 10000.0
		var th = p / (1.0 - pow(1.0 - p, N))
		_chk("第%d圈 有保底 10000 次：%.2f%%（理論 %.2f%%），最長 %d 次（保底 %d）" % [r + 1, f1 * 100, th * 100, gmax, N], absf(f1 - th) < 0.007 and gmax <= N)
	# 保底：第 N 次必掉
	var c2 = {"pity": float(SO.RARE_PITY[0] - 1), "rare": 0.0}
	var okp = true
	for i in 50:
		c2["pity"] = float(SO.RARE_PITY[0] - 1)
		if not SO.roll_rare(c2, 0, true): okp = false
	_chk("保底：連續 %d 次冇掉，第 %d 次必掉、計數歸零" % [SO.RARE_PITY[0] - 1, SO.RARE_PITY[0]], okp and J.num(c2.pity) == 0)
	# 真發獎
	var S = J.G.S
	var JO = load("res://game/joss/joss.gd")
	var t0 = JO.tix("inc"); var p0 = J.num(S.chests.get("p", 0))
	var g0 = (S.get("gear", {}).get("items", []) as Array).size() if S.get("gear") is Dictionary else 0
	SO.give_rare(0); SO.give_rare(3)
	var g1 = (S.get("gear", {}).get("items", []) as Array).size() if S.get("gear") is Dictionary else 0
	_chk("極稀有發獎用現有物品：收益×2卡、紙紮裝備、紫箱", JO.tix("inc") == t0 + 1 and g1 == g0 + 1 and J.num(S.chests.get("p", 0)) == p0 + 2, [JO.tix("inc"), g1, S.chests.get("p")])
