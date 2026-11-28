# [post] 野外 v2 測試：外派駐點（普通據點佔領）＋名鬼據點可刷（第 1 關）
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> post res://tools/tests/post_test.gd logic|shots_ 1500
#   logic：據點分法、佔領、派主任（一鬼一職）、產出＝顯示、收銀箱上限、名鬼主任自動入賬、離線封頂、反撲（自動守／親自守／冇守住／派包子／收復）、
#          討飯權重、名鬼請假／首殺必掉／權重表 10 萬次、取消每日打折、進度唔倒退、舊存檔遷移、其他關照舊、合夥人魂魄
#   shots_：logic ＋ 截圖（/home/claude/docs/post_shots/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/post_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const SOV = preload("res://game/sortie/so_view.gd")
const PO = preload("res://game/post/po_data.gd")
const PV = preload("res://game/post/po_view.gd")
const RAID = preload("res://game/raid/raid.gd")
const SOUL = preload("res://game/soul/soul_data.gd")
const BK = preload("res://game/barracks/bk_data.gd")

var T0 := 1800000000000.0   # 測試鐘（ms）

func _p(m): print("[post] ", m)
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
	var have = []
	for g in S.ghosts: have.append(str(g.k))
	for k in ["xiaozhi", "toyol", "pocong", "laojiang"]:
		if not k in have: J.cl(J.G.get("joinGhost"), null, [k])
	await _skip(t, 8)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
	S["lv"] = maxf(5.0, J.num(S.lv))
	S.res["troops"] = 100.0
	var Bt = J.G.get("Battle"); Bt["auto"] = true
	await _f(t, 3)
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
func _win(e: Dictionary) -> Dictionary:
	_rich()
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	if op == null: return {"r": r, "op": null, "ks": []}
	var ks = []
	for u in op.units: if J.num(u.side) == 1: ks.append(str(u.get("k")))
	_weak_foes(op)
	_ff(op, ["back", "done"])
	_ff(op, ["done"])
	return {"r": r, "op": op, "ks": ks}
func _clock(ms: float) -> void:   # 全部模組用同一個測試鐘
	T0 = ms
	PO.test_now = ms; SO.test_now = ms; SOUL.test_now = ms; RAID.now_override = ms
func _adv(sec: float) -> void: _clock(T0 + sec * 1000.0)
func _camp(id: String) -> Dictionary: return SO.camp(id, 0)
func _ghost_not_in(ids: Array):
	for g in J.G.S.ghosts:
		if str(g.get("k")) == "afu" or g.get("id") in ids: continue
		return g
	return null
func _raid_at(e: Dictionary) -> void:   # 砌一次反撲（預告完，準備到達）
	var rr = RAID.st()
	var key = PO.tkey(e); var ap = RAID.approach(key)
	rr["on"] = 1.0; rr["fight"] = null
	rr["cur"] = {"tgt": key, "dir": ap[0], "from": [ap[1].x, ap[1].y], "pow": float(PO.foe_pow(e)), "ks": ["egui", "egui", "egui"], "t": 0.0, "ci": 0.0}
	rr["ph"] = "warn"; rr["left"] = 0.0

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	await _prep(t, m)
	SO.force_open = true
	RAID.hold_fn = func(): return "test"   # 襲擾計時器停住：反撲由測試自己砌
	_clock(T0)
	PO.rng.seed = 20261128; SOUL.rng.seed = 7; SO.rng.seed = 7
	J.G.S.erase("post"); J.G.S.erase("sortie")
	split_check()
	await occupy_and_staff(t, m)
	await income_check(t, m)
	await raid_check(t, m)
	await named_check(t, m)
	roll_sim()
	progress_check()
	migrate_check()
	legacy_check()
	partner_check()
	if shots: await more_shots(t, m)
	RAID.hold_fn = Callable(); RAID.now_override = 0.0; PO.test_now = -1.0; SO.test_now = -1.0; SOUL.test_now = -1.0
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- 據點分法 ----
func split_check() -> void:
	var ps = []; var ns = []
	for e in PO.posts(0): ps.append(str(e.id))
	for e in PO.named(0): ns.append(str(e.id))
	_chk("第 1 關：9 個普通據點（第 1–3 圈各 3 個）", ps == ["so1_r1_1", "so1_r1_2", "so1_r1_3", "so1_r2_1", "so1_r2_2", "so1_r2_3", "so1_r3_1", "so1_r3_2", "so1_r3_3"], ps)
	_chk("第 1 關：7 個名鬼據點（每圈關鍵據點＋第 4 圈全部）", ns == ["so1_r1_4", "so1_r2_4", "so1_r3_4", "so1_r4_1", "so1_r4_2", "so1_r4_3", "so1_r4_4"], ns)
	_chk("其他關未開（wild2.json maps 只有第 1 關）", PO.on_for(0) and not PO.on_for(1) and PO.posts(1).is_empty())
	var all9 = true
	for e in PO.posts(0): if PO.leader(e) == "": all9 = false
	_chk("9 個普通據點都有反撲領隊（原本嘅駐守名鬼）", all9)

# ---- 佔領、派主任、一鬼一職 ----
func occupy_and_staff(t, m) -> void:
	var S = J.G.S
	var e = _camp("so1_r1_1"); var k = SOUL.guard_of(e); var pin = SOUL.pin(k)
	var rows = PV.sortie_rows(e)
	_chk("出擊卡：普通據點寫明佔領後每小時產量＋首殺必掉", rows.size() == 2 and str(rows[0][0]).contains(str(int(round(PO.base_rate(e).coins)))) and str(rows[1][0]).contains(str(PO.first_n(pin))), rows)
	if shots:
		_cam(m, e.pos + Vector2(0, 80), m.village.size.x / 420.0)
		SOV.open_card(e); await _w(t, 0.6); await _shot(t, "01_card_post_before"); SOV.close_card()
	var s0 = SOUL.souls(k); var no0 = PO.n_open()
	var w = _win(e)
	var rep = w.op.get_meta("report") if w.op != null and w.op.has_meta("report") else {}
	_chk("普通據點打贏＝佔領（唔再重生）", w.r == "ok" and SO.state(e) == "held" and PO.held(e) and not PO.lost(e) and SO.cleared_left_s(e) == 0.0 and str(rep.get("post", "")) == "open", [SO.state(e), rep.get("post")])
	_chk("累計開張 +1（KPI 用）", PO.n_open() == no0 + 1)
	_chk("首殺必掉：%s魂魄 +%d（同出擊卡寫嘅一樣，唔另加）" % [k, PO.first_n(pin)], SOUL.souls(k) - s0 == PO.first_n(pin), SOUL.souls(k) - s0)
	_chk("已佔領：唔可以再出擊", SO.dispatch(e) == "held" and RTS.op_for(SO.sid_of(e)) == null)
	_chk("冇主任：木牌寫空缺、產量 0", str(PV.sign_of(e, "held").l2).contains("空缺") and PO.rate(e).coins == 0.0)
	if shots:
		_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
		await _w(t, 0.8); await _shot(t, "02_sign_vacant")
		PV.open_card(e); await _w(t, 0.5); await _shot(t, "03_card_vacant")
		PV.open_card(e, true); await _w(t, 0.5); await _shot(t, "04_card_pick"); PV.close_card()
	# 派主任：出陣中嘅鬼 → 調走
	var g = null
	for id in S.team:
		var x0 = BK.ghost(id)
		if g == null and x0 != null and str(x0.k) != "afu": g = x0
	_p("ghosts: %s　team: %s" % [str(S.ghosts.map(func(x): return str(x.k))), str(S.team)])
	_chk("派之前：隻鬼喺出陣隊", g != null and BK.job(g) == "team")
	var r = PO.assign(e, g.id)
	_chk("派主任：ok，由出陣隊調走，變「村外工作」", r == "ok" and BK.job(g) == "away" and not S.team.has(g.id) and str(g.post) == PO.post_id(e) and PO.chief(e) == g, [r, BK.job(g)])
	var e2 = _camp("so1_r1_2")
	_win(e2)
	_chk("一鬼一職：外派緊嘅鬼唔可以再派去第二個駐點", PO.assign(e2, g.id) != "ok" and PO.chief(e2) == null and PO.chief(e) == g)
	_chk("一鬼一職：外派緊唔可以直接入出陣隊", BK.set_job(g.id, "team") != "ok" and not S.team.has(g.id))
	var listed = false
	for c in PO.candidates(): if c == g: listed = true
	_chk("外派緊嘅鬼唔喺候選名單", not listed)
	PO.recall(e)
	_chk("叫返村：變返閒著，駐點空缺", BK.job(g) == "idle" and PO.chief(e) == null and g.get("post") == null)
	PO.assign(e, g.id)
	S["team"] = [null, null, null, null, null]
	var ids = []
	for x in S.ghosts:
		if ids.size() >= 3: break
		if x != g and (str(x.k) == "afu" or BK.job(x) == "idle"): ids.append(x.id)
	for i in ids.size(): S.team[i] = ids[i]

# ---- 產出＝顯示、收銀箱、自動入賬、離線封頂 ----
func income_check(t, m) -> void:
	var S = J.G.S
	var e = _camp("so1_r1_1"); var g = PO.chief(e)
	var b = PO.base_rate(e); var p = PO.P()
	_chk("基本產量＝wins_h × win_coin_lv × 等級／wins_h × 棺材板[圈]", is_equal_approx(b.coins, float(p.wins_h) * float(p.win_coin_lv) * float(e.lv)) and is_equal_approx(b.planks, float(p.wins_h) * float(p.win_plank[0])), b)
	_chk("駐點產量參數＝每小時 3 場", is_equal_approx(float(p.wins_h), 3.0))
	# 普通鬼主任（暫時改 q）
	var q0 = g.q; g["q"] = "雜"
	var d = PO.pst(e); d["coins"] = 0.0; d["planks"] = 0.0; d["acc"] = T0; d["boost"] = 0.0
	var c0 = J.num(S.res.coins)
	_adv(3600)
	PO.accrue(e)
	var tl = PO.till(e); var rt = PO.rate(e)
	_chk("普通鬼主任 1 小時：收銀箱＝顯示嘅每小時產量（冥幣 %d、棺材板 %d）" % [int(round(rt.coins)), int(round(rt.planks))], absf(tl.coins - rt.coins) < 0.01 and absf(tl.planks - rt.planks) < 0.01 and absf(J.num(S.res.coins) - c0) < 0.01, tl)
	var cl = PV.card_lines(e)
	_chk("駐點卡顯示嘅產量、收銀箱數字＝實際", str(cl.rate).contains("冥幣 %d" % int(round(rt.coins))) and str(cl.rate).contains("棺材板 %d" % int(round(rt.planks))) and str(cl.till).contains("冥幣 %d／%d" % [int(tl.coins), int(round(PO.till_cap(e).coins))]), [cl.rate, cl.till])
	_chk("木牌顯示嘅產量＝實際", str(PV.sign_of(e, "held").l2).contains("+%d" % int(round(rt.coins))) and str(PV.sign_of(e, "held").dot) == str(int(tl.coins)), PV.sign_of(e, "held").l2)
	if shots:
		_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
		await _w(t, 0.8); await _shot(t, "05_sign_open_till")
		PV.open_card(e); await _w(t, 0.5); await _shot(t, "06_card_open"); PV.close_card()
	_adv(4 * 3600)
	PO.accrue(e)
	tl = PO.till(e); var cap = PO.till_cap(e)
	_chk("收銀箱最多存 %s 小時，滿咗就停" % str(p.till_h), absf(tl.coins - cap.coins) < 0.01 and absf(tl.planks - cap.planks) < 0.01 and PO.till_full(e) and is_equal_approx(cap.coins, b.coins * float(p.till_h)), tl)
	_chk("收銀箱滿：木牌叫你收錢", str(PV.sign_of(e, "held").l2).contains("收銀箱滿"))
	if shots:
		await _w(t, 0.6); await _shot(t, "07_sign_till_full")
	c0 = J.num(S.res.coins); var pl0 = J.num(S.res.planks)
	var got = PV.press_collect(e)
	PV.close_card()
	_chk("收錢：入賬＝收銀箱整數部分，收完清空", absf(J.num(S.res.coins) - c0 - floor(cap.coins)) < 0.01 and absf(J.num(S.res.planks) - pl0 - floor(cap.planks)) < 0.01 and PO.till(e).coins < 1.0 and got.coins == floor(cap.coins), got)
	# 肚餓／罷工
	var TV = load("res://game/tavern/tavern.gd")
	if TV.ON and TV.st() != null:
		g["gen"] = {"name": "測試鬼"}
		TV.st().hunger[str(g.id)] = 1.0
		_chk("酒館鬼肚餓：產量減半（顯示同計算一樣）", is_equal_approx(PO.rate(e).coins, b.coins * 0.5) and str(PV.card_lines(e).rate).contains("減半"), PO.rate(e).coins)
		TV.st().hunger[str(g.id)] = 2.0
		d["acc"] = T0; _adv(3600); PO.accrue(e)
		_chk("酒館鬼罷工：產量 0", PO.rate(e).coins == 0.0 and PO.till(e).coins < 1.0)
		TV.st().hunger.erase(str(g.id)); g.erase("gen")
	# 名鬼主任：自動入賬
	g["q"] = "名"
	d["coins"] = 0.0; d["planks"] = 0.0; d["acc"] = T0
	c0 = J.num(S.res.coins); pl0 = J.num(S.res.planks)
	_adv(3 * 3600); PO.accrue(e)
	_chk("名鬼主任 3 小時：自動入賬 3 小時產量，收銀箱唔存", PO.auto_bank(e) and absf(J.num(S.res.coins) - c0 - b.coins * 3.0) < 0.01 and absf(J.num(S.res.planks) - pl0 - b.planks * 3.0) < 0.01 and PO.till(e).coins == 0.0, J.num(S.res.coins) - c0)
	c0 = J.num(S.res.coins)
	_adv(12 * 3600); PO.accrue(e)
	_chk("離線 12 小時：最多補 %s 小時" % str(p.off_h), absf(J.num(S.res.coins) - c0 - b.coins * float(p.off_h)) < 0.01, J.num(S.res.coins) - c0)
	g["q"] = "雜"
	d["acc"] = T0; _adv(12 * 3600); PO.accrue(e)
	_chk("普通鬼主任離線 12 小時：收銀箱封頂（%s 小時）" % str(p.till_h), absf(PO.till(e).coins - cap.coins) < 0.01)
	PO.collect(e)
	g["q"] = q0

# ---- 反撲 ----
func raid_check(t, m) -> void:
	var S = J.G.S
	var e = _camp("so1_r1_1"); var e2 = _camp("so1_r1_2"); var g = PO.chief(e)
	var p = PO.P(); var d = PO.pst(e)
	_chk("營業中嘅駐點會成為反撲目標（連冇主任嗰個）", PO.tkey(e) in RAID.all_targets() and PO.tkey(e2) in RAID.all_targets(), RAID.all_targets())
	_chk("來犯戰力＝foe_base + foe_lv × 等級 × retake_k，唔隨次數變", PO.foe_pow(e) == int(round(float(p.foe_base) + float(p.foe_lv) * float(e.lv) * float(p.retake_k))), PO.foe_pow(e))
	_chk("守備＝主任等級 × 係數", PO.def_pow(e) == int(round(BK.glv(g) * float(p.def_named if PO.is_named_ghost(g) else p.def_plain))), PO.def_pow(e))
	var cl = PV.card_lines(e)
	_chk("駐點卡顯示嘅守備／來犯＝實際", str(cl.def).contains("守備 %d" % PO.def_pow(e)) and str(cl.def).contains("來犯 %d" % PO.foe_pow(e)), cl.def)
	_chk("駐點卡顯示嘅失守後果＝實際（收銀箱丟 %d%%）" % int(round(float(p.fail_store) * 100)), str(cl.lost).contains("%d%%" % int(round(float(p.fail_store) * 100))))
	# 自動守住
	var lv0 = g.get("lv"); g["lv"] = 30.0
	var nr0 = PO.n_repel()
	_raid_at(e); RAID.arrive()
	_chk("守備夠：自動擊退，駐點冇事，冇加成", PO.def_pow(e) >= PO.foe_pow(e) and str(RAID.st().ph) == "idle" and RAID.st().cur == null and PO.held(e) and not PO.lost(e) and not PO.boost_on(e) and PO.n_repel() == nr0 + 1 and PO.chief(e) == g)
	# 守唔住 → 圍住 → 親自打贏
	g["lv"] = 1.0
	var q0 = g.q; g["q"] = "雜"
	_raid_at(e); RAID.arrive()
	_chk("守備唔夠：圍住，等你嚟", PO.def_pow(e) < PO.foe_pow(e) and str(RAID.st().ph) == "siege" and RAID.can_fight())
	var fs = RAID.fight_stage()
	var kl = PO.leader(e)
	_chk("親自迎戰嘅敵陣＝據點原班人馬（領隊照出）、強度八成", (fs.stage.en as Array).has(kl) and is_equal_approx(float(fs.stage.p), maxf(1.0, float(e.lv) * float(p.retake_k))) and str(fs.sid) == RAID.fight_sid(), fs.stage)
	_chk("圍住期間可以派包子打發（要 %d 個壽包）" % int(PO.feed_cost()), PO.can_feed() and PV.card_lines(e).feed and str(PV.card_lines(e).feed_txt).contains(str(int(PO.feed_cost()))))
	if shots:
		_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
		RAID.st().cur["t"] = 20.0
		await _w(t, 1.2); await _shot(t, "08_raid_siege")
		PV.open_card(e); await _w(t, 0.5); await _shot(t, "09_card_siege_feed"); PV.close_card()
	var s0 = SOUL.souls(kl)
	d["acc"] = T0
	RAID.repel("fight")
	var gain = SOUL.souls(kl) - s0
	var ns = []
	for x in PO.weights(SOUL.pin(kl)): ns.append(int(x[0]))
	_chk("親自擊退：領隊魂魄 +%d（權重表其中一檔）、%d 分鐘 ×%s 加成、累計擊退 +1" % [gain, int(p.boost_min), str(p.boost)], gain in ns and PO.boost_on(e) and PO.n_repel() == nr0 + 2 and str(RAID.st().ph) == "idle", [gain, ns])
	d["coins"] = 0.0; d["planks"] = 0.0; d["acc"] = T0
	var b = PO.base_rate(e)
	_chk("加成期間顯示嘅產量＝基本 ×%s" % str(p.boost), is_equal_approx(PO.rate(e).coins, b.coins * float(p.boost)) and str(PV.card_lines(e).rate).contains("×%s" % str(p.boost)), PO.rate(e).coins)
	_adv(3600); PO.accrue(e)
	var want = b.coins * (0.5 * float(p.boost) + 0.5)
	_chk("加成只計 %d 分鐘：1 小時入賬＝半小時 ×%s＋半小時 ×1" % [int(p.boost_min), str(p.boost)], absf(PO.till(e).coins - want) < 0.01 and not PO.boost_on(e), [PO.till(e).coins, want])
	# 派包子
	_raid_at(e); RAID.arrive()
	S.res["buns"] = 5.0
	_chk("壽包唔夠：打發唔到", PO.feed() != "ok" and str(RAID.st().ph) == "siege")
	S.res["buns"] = 100.0; var c0 = J.num(S.res.coins); var s1 = SOUL.souls(kl); var nr1 = PO.n_repel()
	var fr = PO.feed()
	_chk("派包子打發：扣 %d 個壽包、冇冥幣冇魂魄冇加成、駐點冇事" % int(PO.feed_cost()), fr == "ok" and absf(J.num(S.res.buns) - (100.0 - PO.feed_cost())) < 0.01 and J.num(S.res.coins) == c0 and SOUL.souls(kl) == s1 and not PO.boost_on(e) and PO.held(e) and not PO.lost(e) and str(RAID.st().ph) == "idle" and PO.n_repel() == nr1 + 1, fr)
	# 冇守住
	var g2 = _ghost_not_in([g.id] + S.team)
	if g2 == null: g2 = _ghost_not_in([g.id])
	PO.assign(e2, g2.id)
	if not ZD.team_ok(): S.team[0] = S.ghosts[0].id   # 出陣隊至少留一隻
	var d2 = PO.pst(e2); d2["coins"] = 123.0; d2["planks"] = 9.0
	d["coins"] = 200.0; d["planks"] = 10.0; d["acc"] = T0
	var first0 = J.t(SO.cst(e).get("first")); var ring0 = ZD.ring_level(0); var no0 = PO.n_open(); var nrp = PO.n_repel()
	_raid_at(e); RAID.arrive()
	RAID.st().cur["t"] = float(RAID.TUNE.walk) + float(RAID.TUNE.siege) + 1.0
	RAID.hold_fn = Callable(); RAID.step(0.5); RAID.hold_fn = func(): return "test"
	_chk("冇人理：停業整頓（收銀箱剛好丟 %d%%）" % int(round(float(p.fail_store) * 100)), PO.lost(e) and absf(PO.till(e).coins - 200.0 * (1.0 - float(p.fail_store))) < 0.01 and absf(PO.till(e).planks - 10.0 * (1.0 - float(p.fail_store))) < 0.01, PO.till(e))
	_chk("主任返村（冇死、冇丟）", PO.chief(e) == null and g.get("post") == null and BK.job(g) == "idle" and BK.ghost(g.id) == g)
	_chk("一次反撲只影響 1 個駐點", not PO.lost(e2) and PO.chief(e2) != null and PO.till(e2).coins == 123.0 and int(J.num(PO.st().n_lost)) == 1)
	_chk("停業：狀態變返可以出擊（收復），唔再係反撲目標", SO.state(e) == "open" and not (PO.tkey(e) in RAID.all_targets()) and PO.tkey(e2) in RAID.all_targets())
	_chk("停業唔影響首勝記錄、開圈、累計開張／擊退（KPI 唔倒退）", J.t(SO.cst(e).get("first")) == first0 and ZD.ring_level(0) == ring0 and PO.n_open() == no0 and PO.n_repel() == nrp)
	var tc = PO.till(e).coins
	_adv(3600); PO.accrue_all()
	_chk("停業期間唔出嘢", PO.till(e).coins == tc and PO.rate(e).coins == 0.0)
	_chk("停業嘅駐點唔可以派主任", PO.assign(e, g.id) != "ok")
	var sg = PV.sign_of(e, SO.state(e))
	_chk("木牌：停業整頓＋封條", str(sg.get("l1", "")).contains("停業整頓") and J.t(sg.get("seal")))
	var rows = PV.sortie_rows(e)
	_chk("出擊卡：寫明打贏就收復", rows.size() == 1 and str(rows[0][0]).contains("收復"))
	if shots:
		_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
		await _w(t, 0.8); await _shot(t, "10_sign_lost")
		SOV.open_card(e); await _w(t, 0.6); await _shot(t, "11_card_retake"); SOV.close_card()
	# 收復
	var s2 = SOUL.souls(kl)
	var w = _win(e)
	var rep = w.op.get_meta("report") if w.op != null and w.op.has_meta("report") else {}
	_chk("打贏一次：收復，收銀箱剩低嘅仲喺度，冇主魂（唔可以靠失守再刷）", w.r == "ok" and SO.state(e) == "held" and not PO.lost(e) and str(rep.get("post", "")) == "retake" and absf(PO.till(e).coins - tc) < 0.01 and SOUL.souls(kl) == s2 and PO.n_open() == no0, [SO.state(e), rep.get("post"), SOUL.souls(kl) - s2])
	g["q"] = q0; g["lv"] = lv0
	PO.assign(e, g.id)
	# 討飯：收銀箱越滿越易中
	PO.pst(e)["coins"] = PO.till_cap(e).coins; PO.pst(e2)["coins"] = 0.0
	var gq = g.q; g["q"] = "雜"
	var n1 = 0; var n2 = 0; var N = 30000
	var ts = [PO.tkey(e), PO.tkey(e2)]
	for i in N:
		if PO.pick_target(ts) == ts[0]: n1 += 1
		else: n2 += 1
	var wantp = (1.0 + float(p.beg_w)) / (2.0 + float(p.beg_w))
	_chk("討飯：滿收銀箱被揀中機會＝(1＋%s)／(2＋%s)＝%.1f%%（實測 %.1f%%）" % [str(p.beg_w), str(p.beg_w), wantp * 100.0, 100.0 * n1 / N], absf(float(n1) / N - wantp) < 0.01)
	_chk("討飯：有駐點收銀箱過半 → 下次反撲間隔 ×%s；全部唔過半 → ×1" % str(p.beg_gap), is_equal_approx(PO.gap_mul(0), float(p.beg_gap)))
	PO.pst(e)["coins"] = 0.0
	_chk("（收返錢之後間隔變返 ×1）", is_equal_approx(PO.gap_mul(0), 1.0))
	g["q"] = gq
	# 離線：最多積一次，而且等你返嚟先計
	var rr = RAID.st(); rr["ph"] = "idle"; rr["cur"] = null; rr["left"] = 100.0
	var nl = int(J.num(PO.st().n_lost))
	RAID.offline(36000.0)
	_chk("離線 10 小時：返嚟最多一次預告，唔會趁你唔喺度搶走駐點", str(rr.ph) in ["warn", "idle"] and int(J.num(PO.st().n_lost)) == nl and not PO.lost(e) and not PO.lost(e2), rr.ph)
	rr["ph"] = "idle"; rr["cur"] = null; rr["left"] = 9999.0
	# 提示唔出錯（爽感特效開／關都得）
	PO.NEWS.append({"k": "open", "key": PO.key(e)}); PO.NEWS.append({"k": "repel", "key": PO.key(e), "how": "fight", "line": "x"})
	PO.NEWS.append({"k": "lost", "key": PO.key(e), "coins": 1.0, "planks": 1.0}); PO.NEWS.append({"k": "siege", "key": PO.key(e)})
	PV.eat_news(m)
	_chk("提示全部出得到、佇列清空", PO.NEWS.is_empty())

# ---- 名鬼據點 ----
func named_check(t, m) -> void:
	var S = J.G.S
	var e = _camp("so1_r1_4"); var k = SOUL.guard_of(e); var pin = SOUL.pin(k)
	var ns = []
	for x in PO.weights(pin): ns.append(int(x[0]))
	var rows = PV.sortie_rows(e)
	var txt = ""
	for r in rows: txt += str(r[0]) + "\n"
	var all_t = true
	for tt in PO.tiers(pin): if not txt.contains("%s %d 個 %s%%" % [tt.name, int(tt.n), PV.pct_str(float(tt.pct))]): all_t = false
	_chk("出擊卡：名鬼據點寫明唔可以佔領、請假時間、首殺必掉、四檔數量同百分比", txt.contains("唔可以佔領") or txt.contains("不能佔領"), txt)
	_chk("出擊卡四檔＝權重表（%s）" % PV.tiers_text(pin), all_t and txt.contains("首殺必掉") and txt.contains(str(PO.first_n(pin))) and txt.contains(PV.cd_text(pin)))
	if shots:
		_cam(m, e.pos + Vector2(0, 80), m.village.size.x / 420.0)
		SOV.open_card(e); await _w(t, 0.6); await _shot(t, "12_card_named_first"); SOV.close_card()
	var s0 = SOUL.souls(k)
	var w = _win(e)
	_chk("名鬼據點打贏：唔會佔領（照舊按圈重生）", w.r == "ok" and not PO.held(e) and SO.state(e) == "cleared" and PO.camp_state(e) == "", SO.state(e))
	_chk("首殺必掉 %d 個（唔多唔少）" % PO.first_n(pin), SOUL.souls(k) - s0 == PO.first_n(pin) and PO.first_done(k), SOUL.souls(k) - s0)
	_chk("打完名鬼請假 %s（%s品）" % [PV.cd_text(pin), pin], PO.guard_away(e) and absf(PO.cd_left_s(e) - PO.cd_min(pin) * 60.0) < 0.5, PO.cd_left_s(e))
	_chk("請假木牌有理由同倒數", PO.leave_text(e).contains(PO.clock(PO.cd_left_s(e))) and str(PV.sign_of(e, "cleared").get("l2", "")).contains(PO.clock(PO.cd_left_s(e))), PO.leave_text(e))
	# 雜兵重生（5 分鐘）但名鬼未銷假：代班、冇主魂
	_adv(SO.RESPAWN_MIN[0] * 60.0 + 1.0)
	_chk("雜兵按圈重生咗、名鬼仲請假緊", SO.state(e) == "open" and PO.guard_away(e))
	if shots:
		_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
		await _w(t, 1.0); await _shot(t, "13_sign_named_leave")
		SOV.open_card(e); await _w(t, 0.6); await _shot(t, "14_card_named_leave"); SOV.close_card()
	s0 = SOUL.souls(k); var left0 = PO.cd_left_s(e)
	w = _win(e)
	var rep = w.op.get_meta("report") if w.op != null and w.op.has_meta("report") else {}
	_chk("請假期間照打得：敵陣冇嗰隻名鬼（代班）", w.r == "ok" and not (k in w.ks), w.ks)
	_chk("請假期間打贏：冇主魂、戰報寫明、請假時間唔會重計", SOUL.souls(k) == s0 and (str(rep.get("soul", "")).contains("請假")) and absf(PO.cd_left_s(e) - left0) < 1.0, [SOUL.souls(k) - s0, rep.get("soul")])
	# 銷假：抽權重表
	_adv(PO.cd_min(pin) * 60.0)
	_chk("銷假：名鬼返嚟（冇每日打折）", not PO.guard_away(e) and SO.state(e) == "open" and PO.leave_text(e) == "")
	var seen = {}
	for i in 6:
		s0 = SOUL.souls(k)
		w = _win(e)
		var dn = SOUL.souls(k) - s0
		rep = w.op.get_meta("report") if w.op != null and w.op.has_meta("report") else {}
		var okn = (dn in ns) or ((dn - SOUL.GOOD_BONUS) in ns)
		seen[dn] = true
		if i == 0:
			_chk("第 2 場起每場抽數量：+%d（表：%s；打得好再 +%d）" % [dn, str(ns), SOUL.GOOD_BONUS], okn and (k in w.ks), [dn, w.ks])
			var say_ok = false
			for tt in PO.tiers(pin): if str(rep.get("soul", "")).contains(str(tt.say)): say_ok = true
			_chk("戰報有檔位文案", say_ok, rep.get("soul"))
			if shots:
				await _w(t, 0.3)
		elif not okn or dn <= 0: _chk("同日第 %d 場：數量喺表入面、冇空手、冇打折" % (i + 2), false, dn)
		_adv(maxf(PO.cd_min(pin), SO.RESPAWN_MIN[0]) * 60.0 + 1.0)
	_chk("同一日連打 7 場：每場都喺表入面、冇空手、冇每日打折（出現過：%s）" % str(seen.keys()), true)
	# 離線照計
	w = _win(e)
	_adv(24 * 3600.0)
	_chk("請假時間離線照計（過咗一日一定銷假）", not PO.guard_away(e))
	# 雙駐守各自抽
	var e2 = _camp("so1_r2_4"); var ka = SOUL.guard_of(e2); var kb = SOUL.guard2_of(e2)
	if kb != "":
		var a0 = SOUL.souls(ka); var b0 = SOUL.souls(kb)
		_win(e2)
		_chk("雙駐守：兩隻都首殺必掉（%d、%d）" % [PO.first_n(SOUL.pin(ka)), PO.first_n(SOUL.pin(kb))], SOUL.souls(ka) - a0 == PO.first_n(SOUL.pin(ka)) and SOUL.souls(kb) - b0 == PO.first_n(SOUL.pin(kb)), [SOUL.souls(ka) - a0, SOUL.souls(kb) - b0])

# ---- 權重表：顯示＝實際（每品 10 萬次） ----
func roll_sim() -> void:
	var N = 100000
	for pin in ["凡", "靈", "煞", "王"]:
		var k = ""
		for kk in SOUL.D().PIN: if k == "" and str(SOUL.D().PIN[kk]) == pin: k = str(kk)
		var ts = PO.tiers(pin); var cnt = []; var sum = 0.0; var zero = false; var tot = 0.0
		for tt in ts: cnt.append(0); sum += float(tt.pct); zero = zero or int(tt.n) <= 0
		for i in N:
			var r = PO.roll(k)
			cnt[int(r.i)] += 1; tot += float(r.n)
		var worst = 0.0; var parts = []
		for i in ts.size():
			var got = 100.0 * cnt[i] / N
			worst = maxf(worst, absf(got - float(ts[i].pct)))
			parts.append("%s %d個 顯示%s%% 實測%.2f%%" % [ts[i].name, int(ts[i].n), PV.pct_str(float(ts[i].pct)), got])
		_chk("%s品 %d 次：四檔比例同顯示差唔過 1 個百分點、百分比加埋 100、冇空手（平均每場 %.2f）" % [pin, N, tot / N], worst < 1.0 and absf(sum - 100.0) < 0.001 and not zero and ts.size() == 4, "；".join(parts))
		var asc = true
		for i in range(1, ts.size()): if int(ts[i].n) <= int(ts[i - 1].n): asc = false
		_chk("%s品：四檔數量遞增，大爆至少係最少檔 9 倍" % pin, asc and float(ts[3].n) >= 9.0 * float(ts[0].n), [ts[0].n, ts[3].n])
	_chk("冷卻：凡 10 分鐘、靈 30 分鐘、煞 1 小時、王 3 小時", PO.cd_min("凡") == 10.0 and PO.cd_min("靈") == 30.0 and PO.cd_min("煞") == 60.0 and PO.cd_min("王") == 180.0)
	_chk("首殺：凡 10、靈 12、煞 15、王 20", PO.first_n("凡") == 10 and PO.first_n("靈") == 12 and PO.first_n("煞") == 15 and PO.first_n("王") == 20)

# ---- 進度唔倒退 ----
func progress_check() -> void:
	var r0 = ZD.ring_level(0)
	var done0 = ZD.all_bosses_done(0); var firsts = 0
	for e in SO.camps(0): if J.t(SO.cst(e).get("first")): firsts += 1
	for e in PO.posts(0):
		if PO.held(e) and not PO.lost(e): PO.on_lost(e)
	var firsts2 = 0
	for e in SO.camps(0): if J.t(SO.cst(e).get("first")): firsts2 += 1
	_chk("全部駐點失守之後：開圈、拔營條件、首勝記錄完全冇變", ZD.ring_level(0) == r0 and ZD.all_bosses_done(0) == done0 and firsts2 == firsts, [r0, done0, firsts])
	var n0 = PO.n_open()
	for e in PO.posts(0): if PO.lost(e): PO.pst(e)["lost"] = 0.0
	_chk("累計開張數唔會因為失守／收復而變", PO.n_open() == n0)

# ---- 舊存檔遷移 ----
func migrate_check() -> void:
	var S = J.G.S
	var bak_post = S.post.duplicate(true); var bak_so = S.sortie.duplicate(true)
	var roles = []
	for g in S.ghosts: roles.append(g.get("post"))
	for g in S.ghosts: if str(g.get("post", "")).begins_with("wp:"): g["post"] = null
	S.erase("post")
	S["sortie"] = {"v": 1.0, "camps": {}, "n": 0.0}
	var ep = _camp("so1_r2_1"); var en = _camp("so1_r3_4"); var ex = _camp("so1_r2_2")
	var c1 = SO.cst(ep); c1["first"] = true; c1["wins"] = 5.0; c1["clr"] = T0 + 600000.0
	var c2 = SO.cst(en); c2["first"] = true; c2["wins"] = 2.0
	var coins0 = J.num(S.res.coins); var planks0 = J.num(S.res.planks)
	var o = PO.st()
	_chk("舊存檔：已首勝嘅普通據點＝已佔領、主任空缺、重生倒數清零", PO.held(ep) and PO.chief(ep) == null and SO.state(ep) == "held" and J.num(SO.cst(ep).clr) == 0.0 and PO.n_open() == 1)
	_chk("舊存檔：未打過嘅普通據點照舊未佔領", not PO.held(ex) and SO.state(ex) != "held")
	_chk("舊存檔：已首勝嘅名鬼據點唔再補首殺（之後直接抽權重表）", PO.first_done(SOUL.guard_of(en)) and not PO.held(en))
	_adv(5 * 3600.0); PO.accrue_all()
	_chk("舊存檔：冇派主任就冇收入（唔會一入嚟多一筆錢）", J.num(S.res.coins) == coins0 and J.num(S.res.planks) == planks0 and PO.till(ep).coins == 0.0)
	_chk("遷移只做一次", int(J.num(o.mig)) == 1 and PO.st() == o)
	S["post"] = bak_post; S["sortie"] = bak_so
	for i in S.ghosts.size(): S.ghosts[i]["post"] = roles[i]

# ---- 其他關／總開關：照舊 ----
func legacy_check() -> void:
	var e1 = {}
	for e in SO.camps(1): if e1.is_empty(): e1 = e
	if not e1.is_empty():
		_chk("第 2 關據點：唔係駐點、冇請假、出擊卡冇加行（照舊規則）", not PO.is_post(e1) and PO.camp_state(e1) == "" and not PO.guard_away(e1) and PV.sortie_rows(e1).is_empty() and PV.sign_of(e1, "open").is_empty())
	var e = _camp("so1_r1_3")
	PO.force_off = true
	_chk("總開關關咗：第 1 關都照舊（唔係駐點、冇加行、唔係反撲目標）", not PO.is_post(e) and PO.camp_state(_camp("so1_r1_1")) == "" and PV.sortie_rows(e).is_empty() and RAID.all_targets().filter(func(x): return PO.is_tkey(str(x))).is_empty())
	PO.force_off = false
	var SW = load("res://game/soul/soul2.gd")
	_chk("抄功課：普通據點冇（已佔領唔使抄）", str(SW.can_sweep(_camp("so1_r1_1")).why) == "locked")

# ---- 合夥人之後魂魄（修：全部到頂先化散魂） ----
func partner_check() -> void:
	var SU = load("res://game/soul/soul_up.gd")
	var o = SOUL.st(); var S = J.G.S
	var g = null
	for x in S.ghosts: if g == null and SOUL.is_ghost(str(x.k)) and str(x.k) != "afu": g = x
	if g == null: _chk("有名鬼可以測", false); return
	var k = str(g.k)
	var bak = {"rk": o.rk.get(k), "pj": o.pj.get(k) if o.get("pj") is Dictionary else null, "star": o.star.get(k) if o.get("star") is Dictionary else null, "sh": o.sh.get(k), "san": o.san, "mh": o.get("mh"), "coins": S.res.coins}
	SU.st()
	o.rk[k] = float(SOUL.RANK_MAX); o.pj.erase(k); o.star.erase(k); o.sh.erase(k)
	var san0 = SOUL.san()
	var gg = SOUL.gain(k, 30, "test")
	_chk("合夥人（品階、星級未到頂）：攞到嘅魂魄照留做本鬼魂魄", SOUL.souls(k) == 30 and SOUL.san() == san0 and int(gg.to_san) == 0, [SOUL.souls(k), SOUL.san() - san0])
	o["mh"] = 99.0; S.res["coins"] = 999999.0
	var cs = SU.can_star(k)
	if SU.star_cap(k) >= 1:
		_chk("合夥人之後儲到本鬼魂魄 → 星級突破做得到（以前永遠儲唔到）", cs.ok and SU.up_star(k) == "ok" and SU.star(k) == 1 and SOUL.souls(k) == 30 - SU.STAR_SOUL[0], [cs.why, SOUL.souls(k)])
	o.pj[k] = float(SU.OPEN_MAX); o.star[k] = float(SU.star_cap(k)); o.sh.erase(k)
	san0 = SOUL.san()
	gg = SOUL.gain(k, 5, "test")
	_chk("職級、品階、星級全部到頂：多出嚟嘅魂魄先化散魂（× 品值）", SOUL.all_max(k) and SOUL.souls(k) == 0 and SOUL.san() == san0 + 5 * SOUL.pv(k) and int(gg.to_san) == 5 * SOUL.pv(k), [SOUL.souls(k), SOUL.san() - san0])
	# 融合消耗倍數（參數，預設關）
	var kk9 = ""; var kk6 = ""; var kk0 = ""
	for x in SOUL.D().PIN:
		var pp = str(SOUL.D().PIN[x])
		if kk9 == "" and pp == "王": kk9 = str(x)
		if kk6 == "" and pp == "煞": kk6 = str(x)
		if kk0 == "" and pp == "凡": kk0 = str(x)
	_chk("融合消耗倍數已開（老闆 11-28 17:20 同意：煞 ×1.2、王 ×2.2）", J.t(PO.D().get("fuse_k_on")))
	PO.D()["fuse_k_on"] = false
	var c_off = [SU.fuse_cost(kk0).own, SU.fuse_cost(kk6).own, SU.fuse_cost(kk9).own]
	_chk("融合消耗倍數關咗：同以前一樣（下一階：凡 %d、煞 %d、王 %d）" % c_off, c_off == [int(round(8.0 * pow(1.45, 1))), int(round(8.0 * pow(1.45, 7))), int(round(8.0 * pow(1.45, 10)))], c_off)
	PO.D()["fuse_k_on"] = true
	var c_on = [SU.fuse_cost(kk0).own, SU.fuse_cost(kk6).own, SU.fuse_cost(kk9).own]
	_chk("融合消耗倍數打開：凡不變、煞 ×1.2、王 ×2.2（%d、%d、%d）；同系魂魄＝一半" % c_on, c_on == [c_off[0], 130, 724] and SU.fuse_cost(kk9).sys == 362, c_on)
	for f in ["rk", "pj", "star", "sh"]:
		if bak[f] == null: o[f].erase(k)
		else: o[f][k] = bak[f]
	o["san"] = bak.san; S.res["coins"] = bak.coins
	if bak.mh == null: o.erase("mh")
	else: o["mh"] = bak.mh
	var gh = SOUL.ghost(k)
	if gh != null: SOUL.apply_stats(gh)

# ---- 補截圖：四檔結算、地圖總覽 ----
func more_shots(t, m) -> void:
	var e = _camp("so1_r1_4"); var k = SOUL.guard_of(e)
	_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
	for i in 4:
		var tt = PO.tiers(SOUL.pin(k))[i]
		RTS.toast("勝利　%s　魂魄：%s ×%d（%s）%s" % [SO.title(e), SOUL.gname(k), int(tt.n), tt.name, tt.say])
		await _w(t, 0.7); await _shot(t, "15_tier_%d" % i)
		await _w(t, 0.3)
	var c = Vector2.ZERO; var n = 0
	for x in SO.camps(0): if int(x.ring) <= 1: c += x.pos; n += 1
	_cam(m, c / maxf(1.0, n), m.village.size.x / 900.0)
	await _w(t, 1.5); await _shot(t, "16_map_overview")
