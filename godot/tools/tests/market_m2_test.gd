# [market M2] 過勞營業補完（攤／櫃台／巡邏）、爽點（里程碑、街組合、連單、子時高峰＋限時大客、潮流榜、熟客、評論家、章事件）、名聲 專項測試
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/market_m2_test.gd","logic"],["quit"]]
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const MK = preload("res://game/market/mk_data.gd")
const FUN = preload("res://game/market/mk_fun.gd")
const RN = preload("res://game/market/mk_renown.gd")
const TV = preload("res://game/tavern/tavern.gd")
const A := "st_shoubao"
var bad := 0
var rows := 0
var _saved := {}
func _p(s) -> void: print("[m2] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[m2]   %-46s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _S(): return J.G.get("S")

func _setup():
	var S = _S()
	J.test_clock = 1.9e12
	S.erase("mv"); S.erase("mk"); S.erase("mkf"); S.erase("mkr"); S["mat"] = {}
	S.res["coins"] = 0.0; S.mat["m_bao"] = 200.0
	S["mk"] = {"v": 1, "cur": "food", "open": {"food": 1, "cloth": 1}, "ot": {}, "test": 1}
	FUN.reload(); FUN.evq.clear(); RN.evq.clear(); MK.evq.clear()
	if not S.ghosts.any(func(g): return str(g.get("id")) == "t_m2a"):
		S.ghosts.append({"id": "t_m2a", "k": "zhiren", "name": "測試紙人", "q": "藍", "lv": 8.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	sim.plus.off = true; sim.plus.test_off = true
	sim.spawn_t = 1e9
	return sim
func _run(sim, secs: float, dt := 0.1) -> void:
	for i in int(secs / dt):
		J.test_clock += dt * 1000.0
		sim.spawn_t = 1e9
		sim.step(dt); sim.ev.clear()
func _cust(sim, wants: Dictionary) -> Dictionary:
	var c = {"cid": "t", "k": "youhun", "wants": wants, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": sim.QLEN, "pos": MD.poly_at(sim.QP, sim.QLEN), "ph": 0.0, "flip": true, "lines": [], "vip": false, "tp": "none"}
	sim.custs.append(c); return c

func logic(_t) -> void:
	_saved = _S().duplicate(true)
	var sim = _setup()
	_chk("市集啟用（S.mk.test）", MK.active() and FUN.on())
	_p("===== 1. 過勞營業：數值 =====")
	_chk("設計數值寫入 overtime：fat_rate 1.2、down 60、包子 1、回 40", is_equal_approx(MK.otf("fat_rate", 0), 1.2) and is_equal_approx(MK.otf("down_s", 0), 60.0) and int(MK.otf("feed_cost", 0)) == 1 and is_equal_approx(MK.otf("reset_fat", 0), 40.0))
	sim.st().st[A].unlocked = true; sim.st().st[A].lv = 1.0
	var o = MK.ot(A)
	_chk("加班售價 ×1.2", is_equal_approx(FUN.ot_price(A), 1.0) and (func(): MK.toggle_ot(A); return is_equal_approx(FUN.ot_price(A), 1.2)).call())
	# 冇人做：加班唔累
	o.fat = 0.0
	FUN.tick(sim, 0.0)
	MK.tick([A], 10.0, func(_x): return true); FUN.ot_tick([A], 10.0, func(_x): return true, sim)
	_chk("加班 10 秒過勞值約 +12（一人，未有減）", absf(float(o.fat) - 12.0) < 1.5, o.fat)
	o.fat = 69.0; _chk("69 未冒汗", not FUN.warn(A)); o.fat = 71.0
	_chk("70 以上冒汗、產速 ×0.9", FUN.warn(A) and is_equal_approx(FUN.out_mul(A), 0.9))
	o.fat = 99.9
	MK.tick([A], 0.5, func(_x): return true); FUN.ot_tick([A], 0.5, func(_x): return true, sim)
	_chk("滿 100 趴低、自動收加班", MK.is_down(A) and not MK.ot_on(A), [o.get("down"), o.get("on")])
	_chk("趴低時間 60 秒", absf(float(o.down) - 60.0) < 1.0, o.down)
	_chk("趴低次數記低", int(o.get("downs", 0)) == 1)
	_chk("趴低時產速 0", MK.mul(A) == 0.0)
	var bao0 = M.amt("m_bao")
	_chk("餵包子：即起、過勞 40、扣 1 個", FUN.feed(A) == "ok" and not MK.is_down(A) and is_equal_approx(float(o.fat), 40.0) and is_equal_approx(bao0 - M.amt("m_bao"), 1.0))
	_chk("冇趴低唔使餵", FUN.feed(A) == "not_down")
	# 正常營業慢慢累
	o.on = 0; o.fat = 10.0
	FUN.ot_tick([A], 10.0, func(_x): return true, sim)
	_chk("正常營業：+0.15/秒（唔加班 rec 由 M1 負責）", float(o.fat) > 10.0, o.fat)
	_p("===== 2. 人手、升職 =====")
	_chk("1 人 ×1.0、2 人 ×0.9、5 人 ×0.6、9 人 ×0.6（上限 −40%）", is_equal_approx(FUN.staff_fat_mul(1), 1.0) and is_equal_approx(FUN.staff_fat_mul(2), 0.9) and is_equal_approx(FUN.staff_fat_mul(5), 0.6) and is_equal_approx(FUN.staff_fat_mul(9), 0.6))
	o.rank = 0; o["_rk"] = 0; o.downs = 5
	FUN.ot_tick([A], 0.1, func(_x): return true, sim)
	_chk("趴低 5 次 → 老員工（rank 1）", FUN.vet(A), o.rank)
	_chk("老員工記入跨章名冊（食街）", int(FUN.st().vets.get("food", 0)) >= 1, FUN.st().vets)
	_chk("老員工產速由 M1 rank_bonus 0.2 計", is_equal_approx(MK.mul(A), 1.2), MK.mul(A))
	var o2 = MK.ot("st_douhua"); o2.rank = 0
	FUN.carry_vets(0)
	_chk("跨章派返老員工俾同街攤", int(MK.ot(MK.sids_on(0, "food")[0]).get("rank", 0)) >= 1)
	_p("===== 3. 櫃台（每街一個，跟整街加班連動）=====")
	var ck = FUN.ctr_key("food"); var oc = MK.ot(ck); oc.fat = 0.0; oc.down = 0.0
	for sid in MK.sids_on(0, "food"):
		if sim.st().st.has(sid): sim.st().st[sid].unlocked = true; MK.ot(sid).on = 0; MK.ot(sid).down = 0.0
	_chk("冇加班：櫃台唔忙", FUN.counter_busy(sim, "food") == "")
	for sid in MK.sids_on(0, "food"): MK.ot(sid).on = 1
	_chk("一半以上加班：櫃台繁忙", FUN.counter_busy(sim, "food") == "busy")
	FUN._counter_tick(sim, 10.0)
	_chk("繁忙 10 秒 +8（1 人）", absf(float(oc.fat) - 8.0) < 0.5, oc.fat)
	J.G["mk_counter_n_fn"] = func(_s): return 3
	_chk("3 人結帳 ×2.2、連單 14 秒", is_equal_approx(FUN.serve_mul("food"), 2.2) and is_equal_approx(FUN.chain_win("food"), 14.0), FUN.serve_mul("food"))
	oc.fat = 99.9; FUN._counter_tick(sim, 1.0)
	_chk("櫃台趴低 60 秒＝當冇櫃台員（結帳 ×1）", FUN.counter_down("food") and is_equal_approx(FUN.serve_mul("food"), 1.0))
	_chk("櫃台可以餵包子", FUN.feed(ck) == "ok" and not FUN.counter_down("food"))
	J.G.erase("mk_counter_n_fn")
	for sid in MK.sids_on(0, "food"): MK.ot(sid).on = 0
	_p("===== 4. 巡邏員 =====")
	var r = {}
	for i in 6: r = FUN.patrol_handled("t_pat1")
	_chk("處理 6 件 ≈ 90 過勞、未趴", not r.get("down", true) and absf(float(MK.ot(FUN.pat_key("t_pat1")).fat) - 90.0) < 0.1)
	r = FUN.patrol_handled("t_pat1")
	_chk("第 7 件 → 趴低、當冇巡邏", r.get("down", false) and not FUN.patrol_ok("t_pat1"))
	FUN._patrol_tick(61.0)
	_chk("60 秒後起身", FUN.patrol_ok("t_pat1"))
	var po = MK.ot(FUN.pat_key("t_pat1")); po.done = 49; po.fat = 0.0
	r = FUN.patrol_handled("t_pat1")
	_chk("處理滿 50 件 → 巡邏隊長、可兼顧相鄰一條街", r.get("captain", false) and FUN.patrol_captain("t_pat1") and FUN.patrol_reach("t_pat1") == 1)
	_p("===== 5. 連單、限時大客 =====")
	FUN.st().chain = 0
	var c = _cust(sim, {"m_shoubao": 2, "m_douhua": 1}); c.got = {"m_shoubao": 2, "m_douhua": 1}; c["t1"] = FUN._clock() - 3.0
	_chk("兩樣 10 秒內齊：×1.5", is_equal_approx(FUN.pay_mul(sim, c), 1.5))
	for i in 4:
		var c3 = _cust(sim, {"m_shoubao": 1, "m_douhua": 1}); c3.got = c3.wants.duplicate(); c3["t1"] = FUN._clock()
		FUN.pay_mul(sim, c3)
	var c4 = _cust(sim, {"m_shoubao": 1, "m_douhua": 1}); c4.got = c4.wants.duplicate(); c4["t1"] = FUN._clock()
	_chk("連到第 6 單：×1.6（每 5 連 +0.1）", is_equal_approx(FUN.pay_mul(sim, c4), 1.6), FUN.st().chain)
	var c5 = _cust(sim, {"m_shoubao": 1, "m_douhua": 1}); c5.got = c5.wants.duplicate(); c5["t1"] = FUN._clock() - 30.0
	FUN.pay_mul(sim, c5)
	_chk("慢咗：斷單歸零", int(FUN.st().chain) == 0)
	var v = _cust(sim, {"m_shoubao": 12}); v.got = {"m_shoubao": 12}; v["bigv"] = true; v["tend"] = FUN._clock() + 30.0; v["vipn"] = "富豪鬼"
	var rn0 = RN.pts()
	_chk("限時大客收齊：×3、名聲 +20", is_equal_approx(FUN.pay_mul(sim, v), 3.0) and is_equal_approx(RN.pts() - rn0, 20.0))
	sim.custs.clear()
	_p("===== 6. 子時高峰 =====")
	var R = FUN.st().rush; R.clear()
	FUN._rush_tick(sim)
	_chk("首次 5 分鐘後預告", absf(float(R.next) - FUN._clock() - 300.0) < 1.0)
	FUN.st().clk = float(R.next) + 0.1; FUN._rush_tick(sim)
	_chk("預告 30 秒", FUN.rush_phase() == "warn")
	FUN.st().clk = float(R.end) + 0.1; FUN._rush_tick(sim)
	_chk("爆單：客流 ×3（第一次新手版 60 秒、冇大客）", FUN.rush_phase() == "peak" and is_equal_approx(FUN.flow_mul(), 3.0) and absf(FUN.rush_left() - 60.0) < 1.0)
	FUN.st().clk = float(R.end) + 0.1; FUN._rush_tick(sim)
	_chk("喘息：客流 ×0.5", FUN.rush_phase() == "rest" and is_equal_approx(FUN.flow_mul(), 0.5))
	MK.ot(A).fat = 50.0; MK.ot(A).down = 0.0; R["_dt"] = 2.0; FUN._rush_tick(sim)
	_chk("喘息：過勞值 −4/秒", absf(float(MK.ot(A).fat) - 42.0) < 0.5, MK.ot(A).fat)
	FUN.st().clk = float(R.end) + 0.1; FUN._rush_tick(sim)
	_chk("完咗：15 分鐘後下一次", FUN.rush_phase() == "idle" and absf(float(R.next) - FUN._clock() - 900.0) < 1.0)
	_p("===== 7. 潮流榜 =====")
	FUN.now_s = 1.9e9
	var tl = FUN.trend_list(sim)
	_chk("每日 3 樣（或本章有幾多開咗）", tl.size() >= 1 and tl.size() <= 3, tl)
	_chk("同一日穩定", FUN.trend_list(sim) == tl)
	if tl.size(): _chk("潮流貨售價 ×1.5（未加班）", absf(FUN.item_mul(sim, str(tl[0])) - 1.5) < 0.2, FUN.item_mul(sim, str(tl[0])))
	FUN.add_trend_source("offer", A); FUN.now_s = 1.9e9 + 86400.0
	_chk("回陽間供品下一日優先上榜", FUN.trend_list(sim).has(A))
	FUN.now_s = -1.0
	_p("===== 8. 熟客、評論家、章事件 =====")
	var regs = FUN.regs(0)
	_chk("每章 4 位熟客（酒館生成器、同種子同名）", regs.size() == 4 and str(regs[0].name) == str(FUN.regs(0)[0].name))
	var arc = 0
	for i in 10: FUN._reg_visit(0)
	for e in FUN.pop_events(): if e.k == "reg_arc": arc += 1
	_chk("光顧 10 次觸發支線一次", arc == 1)
	sim.st().st[A].lv = 60.0; MK.ot(A).on = 0; MK.ot(A).down = 0.0
	_chk("評論家：Lv60（3 個里程碑）唔加班 = 3 星", FUN.critic_score(sim, A) == 3)
	MK.ot(A).on = 1
	_chk("加班中 −1 星（味道趕急）", FUN.critic_score(sim, A) == 2)
	MK.ot(A).on = 0
	var hit = [0]
	FUN.handlers["t_ev"] = func(_s, _e): hit[0] += 1
	FUN.D().events["0"] = [{"id": "t_ev", "every_s": 5}]
	FUN.st().evt.clear(); FUN._events_tick(sim); FUN.st().clk = FUN._clock() + 6.0; FUN._events_tick(sim)
	_chk("章事件框架：到鐘叫 handler", hit[0] == 1)
	FUN.D().events.erase("0"); FUN.handlers.erase("t_ev")
	_p("===== 9. 名聲 =====")
	var S = _S(); S["mkr"] = {"v": 1, "pts": 0.0, "lv_seen": 1}
	_chk("0 分＝1 級無名小檔", RN.level() == 1 and RN.level_name() != "")
	RN.add(250.0)
	_chk("250 分＝2 級＋升級事件", RN.level() == 2 and RN.pop_events().size() == 1)
	_chk("名鬼機率：1 級 3%／3 級 6%", is_equal_approx(RN.named_p(), 0.03) and (func(): RN.add(600.0); return is_equal_approx(RN.named_p(), 0.06)).call())
	_chk("回陽間：第 1、2 章唔使、第 3 章要 2 級", RN.back_ok(0) and RN.back_ok(2) and (func(): S.mkr.pts = 0.0; return not RN.back_ok(2)).call())
	S.mkr.pts = 250.0
	_chk("拔營：第 1 章要 2 級（有）、第 3 章要 3 級（冇）", RN.move_ok(0) and not RN.move_ok(2))
	RN.now_s = 1.9e9; S.mkr.pts = 900.0; S.res["coins"] = 0.0
	var ex = RN.exchange(0)
	_chk("匯兌：50 名聲 → 100 冥幣", ex.get("ok", false) and is_equal_approx(float(S.res.coins), 100.0) and is_equal_approx(RN.pts(), 850.0))
	RN.exchange(0); RN.exchange(0)
	_chk("每日 3 次", not RN.exchange(0).get("ok", true) and RN.exch_left() == 0)
	S.mkr.pts = 210.0; RN.now_s = 1.9e9 + 86400.0
	_chk("換咗會跌級：唔俾換", RN.exchange(0).get("why", "") == "pts")
	RN.now_s = -1.0
	S.mkr.pts = 3500.0
	_chk("4 級：酒館名單必有名鬼（pin）", RN.named_pin())
	_p("===== 10. 舊收益×2／加速×2 =====")
	sim.st().boost.inc_end = J.test_clock + 1e6
	_chk("市集啟用時舊收益×2 唔生效", is_equal_approx(sim.inc_mul(), 1.0))
	_p("===== 11. 整合：真 sim 跑 30 秒冇死 =====")
	sim.st().st[A].lv = 5.0; MK.ot(A).on = 1
	_run(sim, 30.0)
	_chk("sim.step＋FUN.tick 跑 30 秒冇出錯", FUN._clock() > 29.0, FUN._clock())
	# 還原
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	FUN.reload()
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])
