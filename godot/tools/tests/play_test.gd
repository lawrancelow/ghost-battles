# [play] 玩法線驗證：鬼客脾氣、委託單、詭異事件、鬼員工羈絆、夜潮、招牌菜、人物動作、防坑（唔撳都唔蝕大本）
# GB_TEST：[["wait",3],["gdrun","res://tools/tests/play_test.gd","logic"],["quit"]]
# 截圖：["gdrun","res://tools/tests/play_test.gd","shots"]（輸出 /tmp/play/shots/）
extends RefCounted

const SIM = preload("res://game/outpost/mv_sim.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")
const MVP = preload("res://game/outpost/mv_plus.gd")
const CU = preload("res://game/outpost/mv_cust.gd")
const EV = preload("res://game/outpost/mv_event.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const M = preload("res://game/outpost/mat.gd")
const OUT := "/tmp/play/shots/"
var bad := 0
var rows := 0
var _saved := {}

func _p(s) -> void: print("[play] ", s)
func _chk(name: String, got: float, exp: float, tol := 1e-6) -> void:
	rows += 1
	var ok = absf(got - exp) <= tol * maxf(1.0, absf(exp))
	if not ok: bad += 1
	print("[play]   %-46s 遊戲=%14.4f  驗算=%14.4f  %s" % [name, got, exp, "OK" if ok else "<<< 唔對"])
func _ok(name: String, cond: bool) -> void: _chk(name, 1.0 if cond else 0.0, 1.0)
func _S(): return J.G.get("S")

const TG := [["t_p1", "egui", "餓鬼甲", 1.0], ["t_p2", "egui", "餓鬼乙", 1.0], ["t_p3", "laojiang", "老殭丙", 1.0], ["t_p4", "baiwu", "白無常丁", 1.0],
	["t_p5", "heiwu", "黑無常戊", 1.0], ["t_p6", "youhun", "遊魂己", 1.0], ["t_p7", "zhiren", "紙人庚", 1.0], ["t_p8", "shuigui", "水鬼辛", 1.0]]
func _setup(mats := 1e9) -> void:
	MD.reload(); MVP.reload()
	var S = _S()
	J.test_clock = 1.8e12
	S.erase("mv"); S["cleared"] = {}; S.res["coins"] = 0.0
	var keep = []
	for gh in S.ghosts: if not str(gh.get("id")).begins_with("t_p"): keep.append(gh)
	S["ghosts"] = keep
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": "藍", "lv": t[3], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	M.reload()
	S["mat"] = {}
	for mid in M.all_ids():
		var rk = M.res_key(str(mid))
		if rk != "": S.res[rk] = mats
		else: S.mat[str(mid)] = mats
	S["mv"] = {}
func _sim():
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	MVW.ws().t0 = 9999.0   # 唔係新手保護
	return sim
func _run(sim, secs: float, dt := 0.05) -> Array:
	var evs = []
	for i in int(secs / dt):
		J.test_clock += dt * 1000.0
		sim.step(dt); evs.append_array(sim.ev); sim.ev.clear()
	return evs
func _cnt(evs: Array, k: String) -> int:
	var n = 0
	for e in evs: if str(e.k) == k: n += 1
	return n
func _cust(sim, gid: String, n: int, tp: String) -> Dictionary:
	var c = {"cid": "c0_guhan", "k": "n30_guhangui", "wants": {gid: n}, "got": {gid: n}, "st": "serve", "slot": 0, "take": 0.3, "s": 0.0, "pos": Vector2(200, 600), "ph": 1.0, "flip": true, "lines": [], "vip": false, "tp": tp}
	sim.custs.append(c)
	return c
func _base(sim, gid: String, n: int) -> float:
	var sid = sim.sid_of(gid)
	return n * MD.val(sid, sim.lv(sid), sim.ci()) * MVW.mul(MVW.inf())

func _zero_goods() -> void:   # 材料庫入面嘅成品清零（材料仲係 1e9）
	for g in MD.D().GOODS: if M.has_def(str(g)): M.add(str(g), -M.amt(str(g)))
func logic(_t) -> void:
	_saved = _S().duplicate(true)
	_setup()
	var sim = _sim(); var P = sim.plus
	var ids = MD.stations(0); var CH = IDL.chain(0)
	for sid in ids: sim.st().st[sid].unlocked = true
	var G = "m_douhua"; var GS = "st_douhua"

	_p("===== 1. 夜潮 =====")
	var f0 = P.tide_first(sim)
	_chk("第 1 張圖第一次入夜 = 新手保護 600 秒後", f0, 600.0)
	P.ps(sim).tide_t = f0 - 1.0; _ok("入夜前 1 秒：白晝", not P.is_night(sim))
	P.ps(sim).tide_t = f0 + 1.0; _ok("入夜：夜潮", P.is_night(sim))
	_chk("夜潮：客人 ×1.5", P.freq_mul(sim), 1.5)
	_chk("夜潮：孤魂 ×1.8", P.foe_mul(sim), 1.8)
	_chk("夜潮：打孤魂錢 ×1.5", P.kill_mul(sim), 1.5)
	P.ps(sim).tide_t = f0 + MVP.TIDE_NIGHT + 1.0; _ok("夜潮 120 秒後天光", not P.is_night(sim))
	_chk("天光後 299 秒再入夜", float(P.tide(sim)[1]), MVP.TIDE_DAY - 1.0, 1e-3)
	P.ps(sim).tide_t = f0 - 30.0
	var evs = _run(sim, 35.0)
	_chk("預告＋入夜事件", float(_cnt(evs, "p_night_warn") + _cnt(evs, "p_night")), 2.0)
	P.ps(sim).tide_t = 0.0
	var S2 = _S(); S2.mv.erase("plus"); P.reset_live()
	var sim1 = _sim(); sim1.st().ci = 1.0; sim1.st()
	_chk("第 2 張圖第一次入夜 300 秒", sim1.plus.tide_first(sim1), 300.0)
	sim1.st().ci = 0.0; sim1.st()

	_p("===== 2. 鬼客脾氣：付錢倍數＋熟客度 =====")
	P.ps(sim).tide_t = 0.0
	sim.st().counter = {}
	var c0 = sim.coins(); var c = _cust(sim, G, 2, "haggle"); c["dec"] = "cut"; sim._pay(c)
	_chk("講價減兩成：×0.8", sim.coins() - c0, _base(sim, G, 2) * 0.8)
	_chk("講價減價：熟客度 +2", CU.fam(P, sim, "c0_guhan"), 2.0)
	c0 = sim.coins(); c = _cust(sim, G, 2, "haggle"); c["dec"] = "no"; sim._pay(c)
	_chk("講價唔減：×1.0", sim.coins() - c0, _base(sim, G, 2))
	_chk("講價唔減：熟客度 −1", CU.fam(P, sim, "c0_guhan"), 1.0)
	c0 = sim.coins(); c = _cust(sim, G, 1, "cut"); sim._pay(c)
	_chk("插隊冇趕：插隊費 ×1.2", sim.coins() - c0, _base(sim, G, 1) * CU.CUT_FEE)
	c0 = sim.coins(); c = _cust(sim, G, 3, "dash"); sim.ev.clear(); sim._pay(c)
	_chk("走數：收 0", sim.coins() - c0, 0.0)
	_ok("走數：冇「+0」飄字（pay 事件刪咗）", _cnt(sim.ev, "pay") == 0 and _cnt(sim.ev, "p_dash") == 1)
	_ok("走數：衝緊出去", J.t(c.get("dash")) and str(c.act.k) == "run")
	c0 = sim.coins(); CU.catch(P, sim, c, "tap")
	_chk("捉住走數鬼：罰 ×1.5", sim.coins() - c0, _base(sim, G, 3) * 1.5 / MVW.mul(MVW.inf()))
	c0 = sim.coins(); c = _cust(sim, G, 1, "dash"); c["prepaid"] = true; sim._pay(c)
	_chk("排隊時先收錢：×1.0", sim.coins() - c0, _base(sim, G, 1))
	sim.st().st[GS].lv = 10.0   # ★1
	c0 = sim.coins(); c = _cust(sim, G, 1, "picky"); c["star_need"] = {G: 1.0}; sim._pay(c)
	_chk("挑剔夠星（★1）：×1.8", sim.coins() - c0, _base(sim, G, 1) * 1.8)
	c0 = sim.coins(); c = _cust(sim, G, 1, "picky"); c["star_need"] = {G: 2.0}; sim._pay(c)
	_chk("挑剔唔夠星冇試食：×0.6", sim.coins() - c0, _base(sim, G, 1) * 0.6)
	c0 = sim.coins(); c = _cust(sim, G, 1, "picky"); c["star_need"] = {G: 2.0}; c["dec"] = "taste"; sim._pay(c)
	_chk("挑剔唔夠星請試食：×1.0", sim.coins() - c0, _base(sim, G, 1))
	sim.st().counter[G] = 3.0
	c = _cust(sim, G, 1, "picky"); c["star_need"] = {G: 2.0}
	_ok("請試食掣：扣 1 件", CU.tap_btn(P, sim, "c_pt:1", c) and sim.counter_n(G) == 2 and str(c.dec) == "taste")
	sim.st().st[GS].lv = 1.0
	P.ps(sim).fam["c0_guhan"] = float(CU.REG_N)
	c0 = sim.coins(); c = _cust(sim, G, 1, "reg"); sim._pay(c)
	_chk("熟客：貼士 ×1.1", sim.coins() - c0, _base(sim, G, 1) * 1.1)
	_chk("熟客耐性 +5 秒", P.pat_add({"tp": "reg"}), 5.0)
	sim.custs.clear()

	_p("===== 3. 脾氣擲骰、插隊、趕返尾、扮客、講價等決定 =====")
	P.rng.seed = 7
	var tally = {}
	for i in 4000:
		var tp = CU.roll(P, CU.weights(P, sim)); tally[tp] = int(tally.get(tp, 0)) + 1
	_chk("講價比例 ≈ 7%", float(tally.get("haggle", 0)) / 4000.0, 0.07, 0.25)
	_chk("走數比例 ≈ 5%", float(tally.get("dash", 0)) / 4000.0, 0.05, 0.3)
	P.ps(sim).tide_t = f0 + 1.0
	tally = {}
	for i in 4000:
		var tp2 = CU.roll(P, CU.weights(P, sim)); tally[tp2] = int(tally.get(tp2, 0)) + 1
	_chk("夜潮走數 ×2 ≈ 9.5%", float(tally.get("dash", 0)) / 4000.0, 0.095, 0.25)
	P.ps(sim).tide_t = 0.0
	# 插隊：3 個排緊隊 → 插去第 2
	sim.custs.clear(); sim.st().counter = {G: 40.0}
	for i in 3: _cust(sim, G, 1, "none").st = "queue"
	var A0 = sim.custs[0]
	var cc = {"cid": "c0_yesi", "k": "n30_yesi", "wants": {G: 1}, "got": {}, "st": "in", "slot": 99, "take": 0.3, "s": sim.QLEN, "pos": Vector2(300, 900), "ph": 2.0, "flip": true}
	sim.custs.append(cc)
	P.rng.seed = 1
	var w0 = CU.W0.duplicate()
	P.map_d(0)["tempers"] = {"cut": 1}
	CU.on_spawn(P, sim, cc)
	_ok("插隊：飛身去第 2 位", sim.custs[1] == cc and sim.custs[0] == A0 and str(cc.tp) == "cut")
	_ok("插隊：後面 2 位記低被插", J.t(sim.custs[2].get("cut_by")) and J.t(sim.custs[3].get("cut_by")))
	_ok("撳插隊鬼：排返尾", CU.tap_world(P, sim, cc.pos + Vector2(0, -40)) and sim.custs[sim.custs.size() - 1] == cc)
	_chk("被插嘅人：耐性 +4、熟客度 +1（記住）", float(sim.custs[1].get("pat_b", 0.0)) + J.num(sim.custs[1].get("fam_plus")), 5.0)
	c0 = sim.coins(); cc.got = {G: 1}; sim._pay(cc)
	_chk("趕咗返尾嘅插隊鬼：唔收插隊費", sim.coins() - c0, _base(sim, G, 1))
	P.map_d(0)["tempers"] = w0
	MVP.reload()
	# 扮客
	sim.custs.clear(); P.live.fake = true
	var fk = {"cid": "c0_yesi", "k": "n30_yesi", "wants": {G: 2}, "got": {G: 2}, "st": "serve", "slot": 0, "take": 0.3, "s": 0.0, "pos": Vector2(220, 600), "ph": 3.0, "flip": true}
	sim.custs.append(fk); CU.on_spawn(P, sim, fk)
	_ok("孤魂扮客：脾氣 = fake", str(fk.tp) == "fake")
	c0 = sim.coins(); sim.st().counter[G] = 0.0
	_ok("撳佢現形", CU.tap_world(P, sim, fk.pos + Vector2(0, -40)))
	_chk("現形：攞咗嘅貨退返櫃台", float(sim.counter_n(G)), 2.0)
	_chk("現形：賞 3 × 打孤魂錢", sim.coins() - c0, MD.foe_coin(0) * 3.0)
	var fk2 = _cust(sim, G, 2, "fake"); c0 = sim.coins(); sim._pay(fk2)
	_chk("冇撳：扮客拎貨走，收 0", sim.coins() - c0, 0.0)
	# 講價等決定（hold_pay）：5 秒
	sim.custs.clear(); sim.st().counter = {G: 10.0}
	var hc = {"cid": "c0_guhan", "k": "n30_guhangui", "wants": {G: 1}, "got": {}, "st": "serve", "slot": 0, "take": 0.0, "s": 0.0, "pos": sim.queue_pos(0), "ph": 4.0, "flip": true, "tp": "haggle"}
	sim.custs.append(hc); sim.spawn_t = 999.0
	c0 = sim.coins()
	_run(sim, 2.0)
	_ok("講價：收齊貨等緊玩家（未付錢）", hc.st == "serve" and J.t(hc.get("prompt")) and sim.coins() == c0)
	_run(sim, 4.0)
	_ok("5 秒冇決定：當唔減，收足錢", hc.st == "out" and str(hc.get("dec")) == "timeout")
	_chk("冇決定：收足價", sim.coins() - c0, _base(sim, G, 1))

	_p("===== 4. 鬼員工羈絆 =====")
	sim.custs.clear()
	_ok("餓鬼派去嘆氣蒸籠", sim.assign("st_shoubao", 0, "t_p1"))
	var b = P.bond(sim, "st_shoubao")
	var stat_k = clampf(1.0 + (float(J.mc(J.G.get("F"), "stat", [sim.ghost("t_p1"), 1])) - 30.0) / 400.0, 0.9, 1.35)
	_chk("啱手：×1.2 × 能力值", float(b.t_p1.mul), 1.2 * stat_k)
	sim.assign("st_shoubao", 1, "t_p2"); b = P.bond(sim, "st_shoubao")
	_chk("兩隻餓鬼同一個食物台：搶食 ×0.75", float(b.t_p1.mul), 1.2 * 0.75 * stat_k)
	_ok("嗌交記認", "clash" in b.t_p2.tags)
	sim.assign("st_nuomici", 0, "t_p3"); b = P.bond(sim, "st_nuomici")
	_ok("老殭派去自轉石磨：唔啱位（怕糯米）", "bad" in b.t_p3.tags and float(b.t_p3.mul) < 0.75)
	sim.assign("st_tiaodan", 0, "t_p4"); sim.assign("st_tiaodan", 1, "t_p5"); b = P.bond(sim, "st_tiaodan")
	_ok("黑白無常同台：合拍", "pair" in b.t_p4.tags and "pair" in b.t_p5.tags)
	_ok("黑無常啱手豆花擔（押送）", "fit" in b.t_p5.tags)
	sim.sync()
	var wv = null
	for w in sim.workers: if str(w.gid) == "t_p1": wv = w
	_chk("員工速度倍數 = 羈絆", P.wmul(sim, wv), float(P.bond(sim, "st_shoubao").t_p1.mul))
	_chk("離線：台平均羈絆", P.off_mul(sim, "st_shoubao"), (float(P.bond(sim, "st_shoubao").t_p1.mul) + float(P.bond(sim, "st_shoubao").t_p2.mul)) / 2.0)
	wv["doze"] = true; _chk("瞌眼瞓：速度 0", P.wmul(sim, wv), 0.0); wv.erase("doze")
	evs = _run(sim, 0.2)
	_ok("派落台飄羈絆字", _cnt(evs, "p_bond") >= 3)
	evs = _run(sim, 12.0)
	_ok("嗌交：互打＋對白", _cnt(evs, "p_clash") >= 1)
	var acts = 0
	for w in sim.workers: if w.has("act") or float(w.get("act_cd", 99.0)) < 12.5: acts += 1
	_ok("員工招牌動作排緊", acts >= 3)
	sim.assign("st_shoubao", 1, null)

	_p("===== 5. 委託單 =====")
	sim.custs.clear(); sim.st().counter = {}
	_zero_goods()
	var pp = P.ps(sim)
	var o = EV.make_order(P, sim)
	_ok("出到單", not o.is_empty())
	var tot = 0.0; var ok_q = true; var ok_t = true
	for g in o.need:
		tot += J.num(o.need[g])
		var r = EV.prod_rate(P, sim, sim.sid_of(str(g)))
		if J.num(o.need[g]) > maxf(3.0, r * EV.ORD_SECS) + 0.5: ok_q = false
	_ok("數量 ≤ 呢個台 90 秒產量（最少 3）", ok_q)
	_ok("限時 180–600 秒", J.num(o.left) >= 180.0 and J.num(o.left) <= 600.0)
	_ok("限時 ≥ 3 × 預計時間（夾住）", J.num(o.left) >= minf(600.0, 3.0 * tot / 99.0))
	for g in o.need: sim.st().counter[g] = J.num(o.need[g])
	var exp_c = EV.order_coins(P, sim, o)
	var v_need = 0.0
	for g in o.need: v_need += J.num(o.need[g]) * P.gval(sim, str(g))
	_chk("獎勵冥幣 = 1.5 × 件數 × 單價", exp_c, floor(v_need * 1.5))
	c0 = sim.coins(); var r1 = EV.give(P, sim, 0)
	_ok("撥貨：一次交齊", r1 == "done" and pp.orders.is_empty())
	_ok("收到冥幣（≥ 單價 1.5 倍）", sim.coins() - c0 >= exp_c - 1e-6)
	# 每種特別獎
	for rw in ["mat", "gear", "fore", "tix", "inf"]:
		pp.orders.clear()
		var o2 = EV.make_order(P, sim); o2.rw = rw
		for g in o2.need: sim.st().counter[g] = J.num(o2.need[g])
		var inf0 = MVW.inf(); var vol0 = MVW.vol_list().size(); var j = load("res://game/joss/joss.gd").st()
		var tx0 = J.num(j.tix.get("spd")) + J.num(j.tix.get("inc")); var m0 = 0.0
		for mid in M.all_ids(): m0 += M.amt(str(mid))
		EV.give(P, sim, 0)
		var m1 = 0.0
		for mid in M.all_ids(): m1 += M.amt(str(mid))
		match rw:
			"mat": _ok("獎：稀有材料", m1 > m0 - 1.0)
			"gear": _ok("獎：裝備 → 招一個義勇軍（呢張圖有裝備貨就要招到）", EV._gear_goods(sim).is_empty() or MVW.vol_list().size() == vol0 + 1)
			"fore": _ok("獎：借領班 8 分鐘", pp.help is Dictionary and J.num(pp.help.left) == MVP.HELP_S)
			"tix": _ok("獎：陽間包裹券 +1", J.num(j.tix.get("spd")) + J.num(j.tix.get("inc")) == tx0 + 1.0)
			"inf": _chk("獎：影響力 +8", MVW.inf() - inf0, minf(8.0, 100.0 - inf0))
	var hs = str(pp.help.sid)
	_chk("借領班：台速度 ×1.5", P.smul(sim, hs), 1.5)
	pp.orders.clear()
	var o3 = EV.make_order(P, sim); o3.left = 0.5
	var inf1 = MVW.inf()
	_run(sim, 1.0)
	_chk("過咗限時：影響力 −3", inf1 - MVW.inf(), 3.0)
	_ok("過咗限時：單取消", pp.orders.is_empty())
	pp.orders.clear()
	var o4 = EV.make_order(P, sim)
	var g4 = str(o4.need.keys()[0]); sim.st().counter[g4] = 1.0
	_ok("撥一半：part", EV.give(P, sim, 0) == "part" and J.num(o4.got[g4]) >= 1.0)
	EV.drop(P, sim, 0)
	_ok("推咗佢：退返貨、冇罰", pp.orders.is_empty() and sim.counter_n(g4) >= 1)
	# 夜潮唔出單
	pp.ord_t = 1.0; P.ps(sim).tide_t = f0 + 1.0; P.live.ev = null; pp.ev_t = 999.0
	_run(sim, 3.0)
	_ok("夜潮唔出單", pp.orders.is_empty())
	P.ps(sim).tide_t = 0.0
	_run(sim, 2.0)
	_ok("白晝到鐘出單", pp.orders.size() == 1)
	pp.orders.clear()

	_p("===== 6. 詭異事件 =====")
	sim.custs.clear(); pp.ev_t = 9999.0
	for k in ["self", "rate_up", "rate_down", "fake", "rain", "doze", "parcel", "special"]:
		P.live.ev = null; P.live.rate = null; P.live.hold = 0.0; P.live.fake = false
		sim.st().counter = {"m_guancaichuang": 10.0, "m_nuomici": 10.0, "m_douhua": 10.0}
		var st_ok = EV.start_ev(P, sim, k)
		_ok("事件出到：" + k, st_ok and P.live.ev is Dictionary)
		if not st_ok: continue
		var e = P.live.ev
		match k:
			"self":
				var m0s = IDL.made_n(sim, str(e.sid)); EV.resolve(P, sim, e)
				_chk("子時開工：撳咗做 3 轉", IDL.made_n(sim, str(e.sid)) - m0s, 3.0 * MD.out(str(e.sid), sim.lv(str(e.sid))))
			"rate_up":
				_chk("匯率升 ×1.3", P.rate_mul(), 1.3); EV.resolve(P, sim, e)
				_chk("加價：延長 15 秒", float(P.live.rate.left), 60.0)
			"rate_down":
				_run(sim, EV.DECIDE_S + 0.2)
				_chk("匯率跌唔理：×0.75", P.rate_mul(), 0.75)
				P.live.rate = null; EV.start_ev(P, sim, "rate_down"); EV.resolve(P, sim, P.live.ev)
				_ok("囤住先：唔賣嘢", P.hold_take(sim))
				_run(sim, EV.HOLD_S + 0.2)
				_chk("囤完：反彈 ×1.3", P.rate_mul(), 1.3)
			"fake":
				sim.spawn_t = 999.0; _run(sim, EV.FAKE_FORCE + 0.3)
				var found = false
				for x in sim.custs: if str(x.get("tp")) == "fake": found = true
				_ok("12 秒內冇客：自動出一個扮客", found)
			"rain":
				c0 = sim.coins(); var n = EV.rain_tap_n(P, sim, 3)
				_chk("紙錢雨：執 3 張", sim.coins() - c0, 3.0 * float(e.v))
				_ok("每張 ≥ 10", float(e.v) >= 10.0)
			"doze":
				var dw = e.w
				_ok("瞌眼瞓：停工", P.wmul(sim, dw) == 0.0)
				EV.resolve(P, sim, e)
				_ok("拍醒：返工", not J.t(dw.get("doze")) and str(dw.act.k) == "startle")
			"parcel":
				var j2 = load("res://game/joss/joss.gd")
				var q0 = j2.st().q.size(); EV.resolve(P, sim, e)
				_ok("包裹：入化寶爐（有起爐未滿）或者送材料", j2.st().q.size() == q0 + 1 or j2.lv() <= 0 or j2.count() >= j2.CAP)
			"special":
				c0 = sim.coins(); var g5 = str(e.g); var n5 = sim.counter_n(g5)
				EV.resolve(P, sim, e)
				var sp = MVP.map_d(0).special
				_chk("大客掃貨：件數 × 單價 × 倍數", sim.coins() - c0, float(mini(int(sp.qty), n5)) * P.gval(sim, g5) * float(sp.mul))
		_run(sim, 0.1)
	# 預設計時
	P.live.ev = null; pp.ev_t = 0.5
	evs = _run(sim, 1.0)
	_ok("計時到：自動出事件", _cnt(evs, "p_ev") == 1)
	_ok("下一件 100–160 秒", J.num(pp.ev_t) >= 99.0 and J.num(pp.ev_t) <= 160.0)

	_p("===== 7. 招牌菜 =====")
	P.live.ev = null; pp.ev_t = 9999.0; P.live.rate = null; P.live.hold = 0.0
	var sd = P.sign_def(0)
	sim.st().counter = {}
	_ok("冇料：出唔到", not P.sign_ok(sim) and P.make_sign(sim) == 0.0)
	for g in sd.parts: sim.st().counter[g] = float(sd.parts[g]) * 3.0
	var exp_v = 0.0
	for g in sd.parts: exp_v += float(sd.parts[g]) * P.gval(sim, str(g))
	c0 = sim.coins()
	_chk("出一份 = 1.8 × 用料價", P.make_sign(sim), exp_v * 1.8)
	_chk("扣料", float(sim.counter_n("m_shoubao")), float(sd.parts.m_shoubao) * 2.0)
	P.make_sign(sim); P.make_sign(sim)
	_chk("出 3 份：銅牌", float(P.sign_tier(sim, 0)), 1.0)
	_ok("銅牌：Boss 弱點（S.mv.plus.weak）", MVP.boss_weak(0))
	_chk("鬼潮頭目受傷 ×2", P.dmg_mul(sim, {"boss": true}), 2.0)
	_chk("普通孤魂唔加", P.dmg_mul(sim, {}), 1.0)
	_ok("成就記低", "sign0_1" in pp.ach)
	pp.sign["0"].n = 10.0
	c0 = sim.coins(); c = _cust(sim, "m_douhua", 1, "none"); sim._pay(c)
	_chk("銀牌：招牌用料賣 ×1.1", sim.coins() - c0, _base(sim, "m_douhua", 1) * 1.1)
	pp.sign["0"].n = 30.0
	_chk("金牌：大單 2 張", float(EV.ord_max(P, sim)), 2.0)

	_p("===== 8. 拔營：清單、保留成就 =====")
	pp.orders.append({"id": "x", "need": {}, "got": {}, "left": 100.0})
	P.on_move(sim, 0)
	_ok("拔營：委託單清走", P.ps(sim).orders.is_empty())
	_ok("拔營：招牌成就保留", P.sign_tier(sim, 0) == 3 and MVP.boss_weak(0))

	_p("===== 9. 防坑：唔撳都唔蝕大本（同一個種子跑 20 分鐘，關掉 vs 開住唔撳） =====")
	var res = []
	for mode in ["off", "idle"]:
		_setup()
		var s2 = _sim()
		s2.plus.off = mode == "off"
		for sid in MD.stations(0): s2.st().st[sid].unlocked = true
		var gi = 0
		for sid in ["st_shoubao", "st_zhishan", "st_douhua", "st_nuomici"]:
			s2.assign(sid, 0, TG[gi][0]); gi += 1
		s2.assign("guard", 0, "t_p8")
		s2.rng.seed = 99; s2.plus.rng.seed = 99; s2.war._rng.seed = 99
		_S().res["coins"] = 0.0
		var ev2 = _run(s2, 1200.0, 0.1)
		res.append(s2.coins())
		_p("  %s：20 分鐘收入 %s；事件 %d、大單 %d" % [mode, MD.fmt(s2.coins()), _cnt(ev2, "p_ev"), int(J.num(s2.plus.ps(s2).stats.get("ord_new")))])
	_ok("開住唔撳 ≥ 關掉 × 0.92", res[1] >= res[0] * 0.92)

	_p("===== 10. 逐張圖：專屬內容齊、做得到 =====")
	for ci in MD.maps_n(): _map_check(ci)

	for k in _S().keys(): if not _saved.has(k): _S().erase(k)
	for k in _saved: _S()[k] = _saved[k]
	MD.reload(); MVP.reload()
	J.test_clock = -1.0
	_p("RESULT play ok=%d bad=%d（共 %d 行）" % [rows - bad, bad, rows])

func _map_check(ci: int) -> void:
	_setup()
	var sim = _sim(); sim.st().ci = float(ci); sim.st(); sim.relayout(102.0, 786.0)
	var P = sim.plus
	var nm = MD.T(MD.map_def(ci).name)
	var goods = []
	for sid in MD.stations(ci):
		sim.st().st[sid].unlocked = true; sim.st().st[sid].lv = 12.0
		goods.append(str(MD.st_def(sid).good))
	var md = MVP.map_d(ci)
	_ok("%s：play.json 有呢張圖" % nm, not md.is_empty())
	var miss = 0
	for sid in MD.stations(ci): if MVP.st_d(sid).is_empty(): miss += 1
	_chk("%s：每個台都有羈絆資料（缺幾個）" % nm, float(miss), 0.0)
	var sp_ok = true
	for g in md.special.goods: if not (str(g) in goods): sp_ok = false
	_ok("%s：大客要嘅貨全部喺呢張圖" % nm, sp_ok)
	var sg_ok = true
	for g in md.sign.parts: if not (str(g) in goods): sg_ok = false
	_ok("%s：招牌菜用料全部喺呢張圖" % nm, sg_ok)
	_ok("%s：脾氣對白有地圖講法" % nm, md.get("lines") is Dictionary and md.lines.size() >= 3)
	for g in goods: sim.st().counter[g] = 30.0
	_zero_goods()
	EV.start_ev(P, sim, "special")
	var c0 = sim.coins(); EV.resolve(P, sim, P.live.ev)
	_ok("%s：大客「%s」掃到貨" % [nm, MD.T(md.special.n)], sim.coins() > c0)
	_ok("%s：出到招牌菜「%s」" % [nm, MD.T(md.sign.n)], P.make_sign(sim) > 0.0)
	var o = EV.make_order(P, sim); var og = true
	for g in o.get("need", {}): if not (str(g) in goods): og = false
	_ok("%s：大單要呢張圖嘅貨" % nm, not o.is_empty() and og)
	# 派鬼跑 3 分鐘：唔出錯、有事件、有收入
	var gi = 0
	for sid in MD.stations(ci):
		if gi < TG.size(): sim.assign(sid, 0, TG[gi][0]); gi += 1
	P.ps(sim).ev_t = 5.0; P.ps(sim).orders.clear()
	_S().res["coins"] = 0.0
	var evs = _run(sim, 180.0, 0.1)
	_ok("%s：跑 3 分鐘有收入、有事件" % nm, sim.coins() > 0.0 and _cnt(evs, "p_ev") >= 1)
	_p("  %s：3 分鐘收入 %s、事件 %d、脾氣客 %d" % [nm, MD.fmt(sim.coins()), _cnt(evs, "p_ev"), int(J.num(P.ps(sim).stats.get("t_haggle")) + J.num(P.ps(sim).stats.get("t_cut")) + J.num(P.ps(sim).stats.get("t_dash")) + J.num(P.ps(sim).stats.get("t_picky")))])

# ================= 截圖 =================
var sc = null
func _shot(name: String) -> void:
	var st = Engine.get_main_loop().root.get_node("Main").story
	for i in 10:
		if st.cur == null: break
		st.skip_scene(); await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	await RenderingServer.frame_post_draw
	var img = Engine.get_main_loop().root.get_viewport().get_texture().get_image()
	img.save_png(OUT + name + ".png"); _p("SHOT " + OUT + name + ".png")
func _wait(s: float) -> void: await Engine.get_main_loop().create_timer(s).timeout
func _cam(y: float) -> void: sc.cam = y; sc.cam_tgt = null; sc.cam_v = 0.0; sc._clamp_cam(true)
func _camc() -> void: _cam(sc.sim.L.counter_y - sc.view_h() * 0.55)

# 逐張圖：大客＋招牌卡（tt, 參數 "maps"）
func maps(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_saved = _S().duplicate(true)
	var m = tt.main()
	var mh = m.get("mv_host")
	if mh is CanvasItem: mh.visible = false
	for ci in MD.maps_n():
		_setup(); var S = _S(); J.test_clock = -1.0
		S.mv = {"ci": float(ci)}
		sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvScenePlay%d" % ci
		m.add_child(sc); var vil = m.get("village")
		if vil != null: m.move_child(sc, vil.get_index() + 1)
		sc.setup(m)
		var sim = sc.sim; sim.st(); MVW.ws().t0 = 9999.0; sim.relayout()
		var P = sim.plus
		for sid in MD.stations(ci):
			S.mv.st[sid].unlocked = true; S.mv.st[sid].lv = 12.0; S.mv.counter[str(MD.st_def(sid).good)] = 20.0
		P.ps(sim).ev_t = 9999.0; P.ps(sim).ord_t = 9999.0
		sc.on_show(); await _wait(1.0)
		sim.custs.clear(); sim.spawn_t = 999.0
		EV.start_ev(P, sim, "special")
		_cam(float(P.live.ev.pos.y) - sc.view_h() * 0.5)
		await _wait(2.6)
		await _shot("m%d_special" % (ci + 1))
		P.live.ev = null
		P.card = {"k": "sign"}; await _wait(0.4)
		await _shot("m%d_sign" % (ci + 1))
		P.card = null
		sc.on_hide(); sc.queue_free(); await _wait(0.3)
	for k in _S().keys(): if not _saved.has(k): _S().erase(k)
	for k in _saved: _S()[k] = _saved[k]
	_p("MAPS DONE")

func shots(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_saved = _S().duplicate(true)
	_setup(); var S = _S()
	J.test_clock = -1.0
	var m = tt.main()
	sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvScenePlay"
	var vil = m.get("village")
	var mh = m.get("mv_host")
	if mh is CanvasItem: mh.visible = false
	m.add_child(sc)
	if vil != null: m.move_child(sc, vil.get_index() + 1)
	sc.setup(m)
	var sim = sc.sim; sim.st(); MVW.ws().t0 = 9999.0
	var P = sim.plus
	var ids = MD.stations(0)
	for sid in ids: S.mv.st[sid].unlocked = true; S.mv.st[sid].lv = 12.0
	sim.assign("st_shoubao", 0, "t_p1"); sim.assign("st_shoubao", 1, "t_p2")
	sim.assign("st_tiaodan", 0, "t_p4"); sim.assign("st_tiaodan", 1, "t_p5")
	sim.assign("st_nuomici", 0, "t_p3"); sim.assign("st_douhua", 0, "t_p8")
	for sid in ids: S.mv.counter[str(MD.st_def(sid).good)] = 12.0
	P.ps(sim).ev_t = 9999.0; P.ps(sim).ord_t = 9999.0
	sc.on_show()
	await _wait(1.5)
	# 1. 羈絆頭牌：鏡頭對住蒸籠
	sc.cam_tgt = null; _cam(sim.st_pos("st_shoubao").y - sc.view_h() * 0.5)
	await _wait(0.6)
	await _shot("p01_bonds")
	# 2. 講價掣＋脾氣牌
	_camc(); await _wait(0.3)
	sim.custs.clear(); sim.spawn_t = 999.0
	var tps = ["haggle", "dash", "picky", "reg"]
	for i in 4:
		var c = {"cid": "c0_guhan", "k": ["n30_guhangui", "n30_dugui", "n30_jiugui", "n30_taozhai"][i], "wants": {"m_douhua": 2}, "got": {}, "st": "queue", "slot": i, "take": 0.3,
			"s": sim.queue_s(i), "pos": sim.queue_pos(i), "ph": float(i), "flip": true, "tp": tps[i]}
		if tps[i] == "picky": c["star_need"] = {"m_douhua": 2.0}
		sim.custs.append(c)
	S.mv.counter["m_douhua"] = 40.0
	await _wait(1.2)
	await _shot("p02_haggle_tags")
	# 3. 走數鬼衝出去
	sim.custs.clear()
	var d = {"cid": "c0_dugui", "k": "n30_dugui", "wants": {"m_douhua": 2}, "got": {"m_douhua": 2}, "st": "serve", "slot": 0, "take": 0.3, "s": 0.0, "pos": sim.queue_pos(0), "ph": 1.0, "flip": true, "tp": "dash"}
	sim.custs.append(d); sim._pay(d)
	await _wait(0.6)
	await _shot("p03_dash")
	CU.catch(P, sim, d, "tap")
	await _wait(0.5)
	await _shot("p04_caught")
	# 4. 夜潮＋小卡＋大單
	sim.custs.clear(); sim.spawn_t = 0.5
	P.ps(sim).tide_t = P.tide_first(sim) + 20.0
	EV.make_order(P, sim)
	await _wait(2.5)
	await _shot("p05_night_chips")
	P.card = {"k": "order", "i": 0}
	await _wait(0.4)
	await _shot("p06_order_card")
	P.card = {"k": "sign"}
	await _wait(0.4)
	await _shot("p07_sign_card")
	P.card = null
	# 5. 事件：子時開工、大客、紙錢雨、包裹
	P.ps(sim).tide_t = 0.0
	for k in ["self", "special", "rain", "parcel", "doze", "rate_down"]:
		P.live.ev = null; P.live.rate = null
		EV.start_ev(P, sim, k)
		var e = P.live.ev
		if e is Dictionary and e.has("pos"): sc.cam_tgt = null; _cam(float(e.pos.y) - sc.view_h() * 0.5)
		elif e is Dictionary and e.get("w") is Dictionary: _cam(float(e.w.pos.y) - sc.view_h() * 0.5)
		await _wait(2.0 if k != "rain" else 2.5)
		await _shot("p08_ev_" + k)
	P.live.ev = null
	# 6. 中文版
	var lang0 = DB.lang
	DB.lang = "zh" if lang0 == "yue" else "yue"
	EV.make_order(P, sim); P.card = {"k": "order", "i": 0}
	_camc(); await _wait(0.5)
	await _shot("p09_order_other_lang")
	DB.lang = lang0
	P.card = null
	sc.on_hide(); sc.queue_free()
	for k in _S().keys(): if not _saved.has(k): _S().erase(k)
	for k in _saved: _S()[k] = _saved[k]
	_p("SHOTS DONE")
