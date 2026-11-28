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
const MKO = preload("res://game/market/mk_ops.gd")   # M1 營運層（已合併：用真接口，冇替身）
const MKUI = preload("res://game/market/mk_fun_ui.gd")
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
func _gh(id: String) -> void:
	var S = _S()
	if not S.ghosts.any(func(g): return str(g.get("id")) == id):
		S.ghosts.append({"id": id, "k": "zhiren", "name": id, "q": "藍", "lv": 3.0, "st": [10.0, 10.0, 10.0], "post": null, "spent": 0.0})
func _ctr(sim, n: int) -> Array:   # 真 M1 調派：食街櫃檯員設為 n 人（回每次結果）
	var r = []
	for i in 4: MKO.unassign(sim, "t_c%d" % i)
	for i in n: r.append(MKO.assign(sim, "ctr", "food", "t_c%d" % i))
	MKO.reg()
	return r
func _incident(sim) -> Dictionary:   # 真 M1 事件：食街出一件插隊，行到有結果；回 {handled, who}
	MKO.st().ev.clear(); MK.evq.clear()
	var e = MKO.spawn_event(sim, "food", "cut_queue", 0)
	if e.is_empty(): return {"handled": false, "why": "no_spawn"}
	for i in 60:
		MKO.tick(sim, 0.5)
		for x in MK.pop_events():
			if str(x.k) == "ev_done" and str(x.get("by", "")) == "patrol": return {"handled": true, "who": str(x.ev.who)}
			if str(x.k) == "ev_lost": return {"handled": false}
	return {"handled": false, "why": "timeout"}
func _cust(sim, wants: Dictionary) -> Dictionary:
	var c = {"cid": "t", "k": "youhun", "wants": wants, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": sim.QLEN, "pos": MD.poly_at(sim.QP, sim.QLEN), "ph": 0.0, "flip": true, "lines": [], "vip": false, "tp": "none"}
	sim.custs.append(c); return c

func logic(_t) -> void:
	_saved = _S().duplicate(true)
	var sim = _setup()
	_chk("市集啟用（S.mk.test）", MK.active() and FUN.on())
	_p("===== 1. 過勞營業：數值 =====")
	var raw = JSON.parse_string(FileAccess.get_file_as_string("res://data/market.json")).overtime
	var core = FUN.D().ot.core; var same = true
	for k in core: if not raw.has(k) or str(raw[k]) != str(core[k]): same = false
	_chk("market.json（M1）同 market_fun.json（M2）嘅過勞核心數值一樣", same, [raw, core])
	_chk("設計數值寫入 overtime：fat_rate 1.2", is_equal_approx(MK.otf("fat_rate", 0), 1.2), MK.otf("fat_rate", 0))
	_chk("設計數值：趴低 60 秒", is_equal_approx(MK.otf("down_s", 0), 60.0), MK.otf("down_s", 0))
	_chk("設計數值：包子 1 個", int(MK.otf("feed_cost", 0)) == 1, MK.otf("feed_cost", 0))
	_chk("設計數值：起身回 40", is_equal_approx(MK.otf("reset_fat", 0), 40.0), MK.otf("reset_fat", 0))
	_chk("設計數值：冒汗線 70（M1 M2 同一個數）", is_equal_approx(MK.otf("warn", 0), 70.0) and is_equal_approx(FUN.cf("ot", "warn", 0), 70.0))
	MK.reload()
	_chk("M1 重新載入 market.json 後，設計數值會自動寫返", (func(): FUN.ensure(); return is_equal_approx(MK.otf("fat_rate", 0), 1.2)).call(), MK.otf("fat_rate", 0))
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
	for i in 4: _gh("t_c%d" % i)
	for i in 6: _gh("t_p%d" % i)
	MKO.reload(); MKO.rng.seed = 20261128
	MK.st().erase("ops"); MKO.st()["tut"] = 1
	for s2 in MK.ids(): MKO.st().evt[s2] = 1e9   # 測試自己出事件
	(MKO.D().patrol as Dictionary)["catch_p"] = 1.0   # 測試：巡邏員一定處理到（機率另由 M1 market_test 驗）
	_chk("真 M1 調派 3 名櫃檯員", _ctr(sim, 3) == ["ok", "ok", "ok"] and MKO.counter_n("food") == 3)
	_chk("3 人結帳 ×2.2、連單 14 秒", is_equal_approx(FUN.serve_mul("food"), 2.2) and is_equal_approx(FUN.chain_win("food"), 14.0), FUN.serve_mul("food"))
	oc.fat = 99.9; FUN._counter_tick(sim, 1.0)
	_chk("櫃台趴低 60 秒＝當冇櫃台員（結帳 ×1）", FUN.counter_down("food") and is_equal_approx(FUN.serve_mul("food"), 1.0))
	_chk("櫃台可以餵包子", FUN.feed(ck) == "ok" and not FUN.counter_down("food"))
	_chk("櫃台員上限 3 人（M1 第 4 個派唔入、M2 讀到 3）", MKO.assign(sim, "ctr", "food", "t_c3") == "full" and FUN.counter_n("food") == 3 and FUN.ctr_max() == MKO.cap("ctr"))
	_ctr(sim, 0)
	_chk("0 人：結帳 ×1、連單 10 秒", is_equal_approx(FUN.serve_mul("food"), 1.0) and is_equal_approx(FUN.chain_win("food"), 10.0) and not FUN.counter_staffed("food"))
	_ctr(sim, 1)
	_chk("1 人 ×1.4、2 人 ×1.8", is_equal_approx(FUN.serve_mul("food"), 1.4) and (func(): _ctr(sim, 2); return is_equal_approx(FUN.serve_mul("food"), 1.8)).call())
	FUN.st().rush["ph"] = "peak"; oc.fat = 0.0; oc.down = 0.0
	for sid in MK.sids_on(0, "food"): MK.ot(sid).on = 0
	FUN._counter_tick(sim, 10.0)
	_chk("子時高峰：櫃台 +1.0/秒（2 人分擔 ×0.9 → 10 秒 +9）", absf(float(oc.fat) - 9.0) < 0.3, oc.fat)
	FUN.st().rush["ph"] = "idle"
	FUN._counter_tick(sim, 2.0)
	_chk("唔忙：櫃台過勞每秒 −2", absf(float(oc.fat) - 5.0) < 0.3, oc.fat)
	oc.rank = 0; oc.downs = 5; FUN.st().rush["ph"] = "peak"; FUN._counter_tick(sim, 0.1); FUN.st().rush["ph"] = "idle"
	_chk("櫃台趴低 5 次 → 老收銀、記入跨章名冊", FUN.vet(ck) and int(FUN.st().vets.get("ctr:food", 0)) == 1)
	oc.fat = 0.0
	_chk("老收銀：結帳再 ×1.2（2 人 1.8 → 2.16）", is_equal_approx(FUN.serve_mul("food"), 2.16), FUN.serve_mul("food"))
	oc.rank = 0; FUN.carry_vets(0)
	_chk("老收銀跨章保留", int(MK.ot(ck).get("rank", 0)) == 1)
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
	_chk("巡邏隊長處理速度 ×0.7、普通 ×1", is_equal_approx(FUN.patrol_speed("t_pat1"), 0.7) and is_equal_approx(FUN.patrol_speed("t_nobody"), 1.0))
	FUN.carry_captains(); MK.ot(FUN.pat_key("t_pat1")).rank = 0; FUN.carry_captains()
	_chk("巡邏隊長跨章保留", FUN.patrol_captain("t_pat1"))
	_chk("每街巡邏位上限 4（老闆 11-28 定；M1 M2 同一個數）", FUN.pat_max() == 4 and MKO.cap("pat") == 4)
	var okn = 0
	for i in 6: if MKO.assign(sim, "pat", "food", "t_p%d" % i) == "ok": okn += 1
	_chk("真 M1 調派：一條街最多派到 4 隻", okn == 4 and MKO.patrol_n("food") == 4, okn)
	var r4 = _incident(sim)
	_chk("4 人隊：每件 +15 ×0.7＝10.5", r4.get("handled", false) and absf(float(MK.ot(FUN.pat_key(str(r4.who))).fat) - 10.5) < 0.01, MK.ot(FUN.pat_key(str(r4.get("who", "")))).get("fat"))
	MK.ot(FUN.pat_key("t_p0")).down = 60.0
	var r5 = _incident(sim)
	_chk("第一隻趴低：輪到下一隻處理", r5.get("handled", false) and str(r5.who) == "t_p1")
	for i in 4: MK.ot(FUN.pat_key("t_p%d" % i)).down = 60.0
	_chk("成隊趴晒：當冇巡邏（事件冇人處理、20 秒後結算）", not _incident(sim).get("handled", true))
	var done0 = int(J.num(MK.st().get("patrol_done", 0)))
	_chk("M1 KPI 指標 patrol_done 只計真處理（2 件）", done0 == 2, done0)
	FUN._patrol_tick(30.0)
	_chk("趴低 30 秒未起", not FUN.patrol_ok("t_p0"))
	FUN._patrol_tick(31.0)
	_chk("起身後過勞值 40", FUN.patrol_ok("t_p0") and is_equal_approx(float(MK.ot(FUN.pat_key("t_p0")).fat), 40.0))
	FUN._patrol_tick(10.0)
	_chk("閒時巡邏員每秒回落 0.1（40 → 39）", absf(float(MK.ot(FUN.pat_key("t_p0")).fat) - 39.0) < 0.05, MK.ot(FUN.pat_key("t_p0")).fat)
	# 真實頻率：一隻巡邏員每 90 秒處理一件 → 淨升 +6／件，約 17 件先趴；每 200 秒一件 → 唔會累積
	var pz = MK.ot(FUN.pat_key("t_solo")); var downs_at = -1
	for i in 40:
		if FUN.patrol_handled("t_solo", 1).get("down", false) and downs_at < 0: downs_at = i + 1
		FUN._patrol_tick(90.0)
	_chk("一人獨撐（90 秒一件）：十幾件後先趴（唔會永遠唔趴、亦唔會成日趴）", downs_at >= 12 and downs_at <= 20, downs_at)
	pz.fat = 0.0; pz.down = 0.0; var never = true
	for i in 40:
		if FUN.patrol_handled("t_solo2", 1).get("down", false): never = false
		FUN._patrol_tick(200.0)
	_chk("事件疏（200 秒一件）：巡邏員唔會趴", never)
	_p("===== 4b. 里程碑、店員位、打卡鐘、同街組合 =====")
	var caps = []
	for L in [1, 9, 10, 24, 25, 50, 99, 100, 199, 200]: caps.append(1 + FUN.extra_slots(A, float(L)))
	_chk("製作店員位 Lv1/10/25/50/100/200 → 1/2/3/3/4/5（讀 M1 權威表）", caps == [1, 1, 2, 2, 3, 3, 3, 4, 4, 5] and FUN.extra_slots(A, 200.0) == MKO.extra_slots(A, 200.0), caps)
	_chk("外觀三段：Lv25／100／200", FUN.look_stage(A, 24.0) == 0 and FUN.look_stage(A, 25.0) == 1 and FUN.look_stage(A, 100.0) == 2 and FUN.look_stage(A, 200.0) == 3)
	FUN.st().mile.clear(); FUN.pop_events()
	sim.st().st[A].lv = 9.0; FUN._miles(sim)
	sim.st().st[A].lv = 10.0; FUN._miles(sim)
	var me = FUN.pop_events().filter(func(e): return e.k == "mile")
	_chk("升到 Lv10 里程碑：出一次演出事件、店員位 +1", me.size() == 1 and int(me[0].slots) == 1 and int(me[0].lv) == 10, me)
	FUN._miles(sim)
	_chk("同一個里程碑唔會重複演出", FUN.pop_events().filter(func(e): return e.k == "mile").is_empty())
	_chk("第 1 章未有打卡鐘", not FUN.punch_ok() and FUN.punch(A) == "locked")
	sim.st().ci = 5
	MK.ot(A).on = 1; MK.ot(A).fat = 88.0
	_chk("第 6 章打卡鐘：整攤下班、過勞清零", FUN.punch_ok() and FUN.punch(A) == "ok" and not MK.ot_on(A) and is_equal_approx(float(MK.ot(A).fat), 0.0))
	_chk("打卡鐘冷卻 10 分鐘", FUN.punch(A) == "cd" and absf(FUN.punch_left(A) - 600.0) < 1.0, FUN.punch_left(A))
	FUN.st().clk = FUN._clock() + 601.0
	_chk("冷卻完可以再打卡", FUN.punch(A) == "ok")
	sim.st().ci = 0
	for sid in ["st_shoubao", "st_douhua", "st_nuomici"]: sim.st().st[sid].unlocked = true; sim.st().st[sid].lv = 24.0
	_chk("宵夜三寶未齊（Lv24）：食街售價冇加成", is_equal_approx(FUN.street_bonus(sim, "food", "price"), 0.0))
	for sid in ["st_shoubao", "st_douhua", "st_nuomici"]: sim.st().st[sid].lv = 25.0
	_chk("宵夜三寶齊（三樣 Lv25）：食街售價 +15%", is_equal_approx(FUN.street_bonus(sim, "food", "price"), 0.15))
	_chk("唔關事嘅街冇加成", is_equal_approx(FUN.street_bonus(sim, "cloth", "price"), 0.0))
	FUN.st().erase("cbseen"); FUN.pop_events(); FUN._combos_tick(sim); FUN._combos_tick(sim)
	_chk("組合達成只演出一次", FUN.pop_events().filter(func(e): return e.k == "street_combo").size() == 1)
	FUN.now_s = 1.9e9; FUN.st().trend.clear(); FUN.st().stars.clear()
	var tl0 = FUN.trend_list(sim)
	var nt = "st_nuomici" if not tl0.has("st_nuomici") else ("st_douhua" if not tl0.has("st_douhua") else "st_shoubao")
	MK.ot(nt).on = 0; MK.ot(nt).down = 0.0
	if not tl0.has(nt): _chk("售價倍數：只有街組合 ＝ ×1.15", is_equal_approx(FUN.item_mul(sim, nt), 1.15), FUN.item_mul(sim, nt))
	MK.ot(nt).on = 1
	if not tl0.has(nt): _chk("加班 ×1.2 再乘街組合 ×1.15 ＝ ×1.38", is_equal_approx(FUN.item_mul(sim, nt), 1.38), FUN.item_mul(sim, nt))
	FUN.st().stars[nt] = 3
	if not tl0.has(nt): _chk("再掛三星牌 +10% ＝ ×1.518", is_equal_approx(FUN.item_mul(sim, nt), 1.518), FUN.item_mul(sim, nt))
	MK.ot(nt).on = 0; FUN.st().stars.clear(); FUN.now_s = -1.0
	for sid in ["st_shoubao", "st_douhua", "st_nuomici"]: sim.st().st[sid].lv = 1.0
	_p("===== 4c. 副貨（M1 雙貨）食寄賣攤倍數 =====")
	sim.st().st[A].lv = 25.0; sim.st().st["st_douhua"].unlocked = false
	var gb = MKO.good_of("st_douhua")
	if MKO.set_sub(0, A, gb) == "ok":
		MKO.tick(sim, 11.0)
		MK.ot(A).on = 0; FUN.st().stars.clear()
		var base = 2.0 * MKO.sub_val(sim, gb) * sim.inc_mul()
		var im = FUN.item_mul(sim, A)
		_chk("副貨：冇加班＝副貨價 × 寄賣攤倍數", is_equal_approx(sim.cust_value({"got": {gb: 2}}), base * im), [sim.cust_value({"got": {gb: 2}}), base, im])
		MK.ot(A).on = 1
		_chk("副貨：寄賣攤加班 → 售價再 ×1.2", is_equal_approx(sim.cust_value({"got": {gb: 2}}), base * im * 1.2), sim.cust_value({"got": {gb: 2}}))
		MK.ot(A).on = 0; MKO.set_sub(0, A, ""); MKO.tick(sim, 11.0)
	else: _chk("副貨可以設定（Lv25）", false, MKO.sub_choices(0, A))
	sim.st().st["st_douhua"].unlocked = true; sim.st().st[A].lv = 1.0
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
	var S = _S(); var S0_pts = [0.0]
	_p("===== 8b. 評論家出場、大客、熟客、名聲入帳 =====")
	FUN.pop_events(); RN.pop_events()
	for sid in MD.stations(0): if sim.st().st.has(sid): sim.st().st[sid].unlocked = (sid == A)
	sim.st().st[A].lv = 60.0; MK.ot(A).on = 0; MK.ot(A).down = 0.0
	FUN.st().critic.clear(); FUN.st().stars.clear(); S0_pts[0] = RN.pts()
	FUN._critic_tick(sim)
	_chk("評論家：開張 15 分鐘後先第一次嚟", absf(float(FUN.st().critic["0"].next) - FUN._clock() - 900.0) < 1.0 and int(FUN.st().critic["0"].n) == 0)
	FUN.st().clk = FUN._clock() + 901.0; FUN._critic_tick(sim)
	_chk("三星：掛星級牌、名聲 +50", int(FUN.st().stars.get(A, 0)) == 3 and is_equal_approx(RN.pts() - S0_pts[0], 50.0), RN.pts() - S0_pts[0])
	_chk("三星牌：該攤永久售價 +10%", absf(FUN.item_mul(sim, A) / (1.5 if FUN.is_trend(sim, A) else 1.0) - 1.1) < 0.001, FUN.item_mul(sim, A))
	var gap = float(FUN.st().critic["0"].next) - FUN._clock()
	_chk("下一次相隔 15–30 分鐘", gap >= 899.0 and gap <= 1801.0, gap)
	sim.st().st[A].lv = 1.0; FUN.st().clk = float(FUN.st().critic["0"].next) + 1.0; FUN._critic_tick(sim)
	_chk("一星：負評掛 10 分鐘、客流 ×0.8", absf(float(FUN.st().critic.get("bad_until", 0.0)) - FUN._clock() - 600.0) < 1.0 and is_equal_approx(FUN.flow_mul(), 0.8), FUN.flow_mul())
	FUN.st().clk = FUN._clock() + 601.0
	_chk("10 分鐘後負評消失", is_equal_approx(FUN.flow_mul(), 1.0))
	FUN.st().clk = FUN._clock() + 99999.0; var n_before = int(FUN.st().critic["0"].n); FUN._critic_tick(sim)
	_chk("每章只嚟 2 次", n_before == 2 and int(FUN.st().critic["0"].n) == 2)
	sim.st().st[A].lv = 5.0; MK.ot(A).down = 30.0
	_chk("趴低 −1 星（最低 1 星）", FUN.critic_score(sim, A) == 1)
	MK.ot(A).down = 0.0
	# 限時大客：真出場
	sim.custs.clear(); FUN.pop_events()
	FUN._spawn_vip(sim)
	var vin = FUN.pop_events().filter(func(e): return e.k == "vip_in")
	var vc = sim.custs[0] if sim.custs.size() else {}
	var vtot = 0
	for g in vc.get("wants", {}): vtot += int(vc.wants[g])
	_chk("大客出場：10–30 件", vin.size() == 1 and vtot >= 10 and vtot <= 30, vtot)
	_chk("畫面講嘅件數＝真正要嘅件數", vin.size() == 1 and int(vin[0].n) == vtot, [vin, vtot])
	_chk("畫面講嘅限時＝真正限時（90 秒）", vin.size() == 1 and is_equal_approx(float(vin[0].s), float(vc.tend) - FUN._clock()) and is_equal_approx(float(vin[0].s), 90.0))
	var coins0 = float(S.res.coins); var rn1 = RN.pts()
	FUN.st().clk = FUN._clock() + 91.0; FUN._vip_tick(sim)
	_chk("大客超時：搖頭走人、唔扣錢、唔扣名聲", vc.st == "out" and float(S.res.coins) >= coins0 and RN.pts() >= rn1 and FUN.pop_events().any(func(e): return e.k == "vip_fail"))
	sim.custs.clear()
	# 熟客
	FUN.D().regular["p"] = 1.0
	var rc = _cust(sim, {"m_shoubao": 1}); FUN.on_spawn(sim, rc)
	_chk("熟客標記：未夠 5 次唔顯示名", rc.has("reg") and str(rc.get("regn", "x")) == "")
	FUN.st().regs.clear(); var rr = FUN.regs(0)
	for i in 4: FUN._reg_visit(0)
	FUN.pop_events(); FUN._reg_visit(0)
	_chk("第 5 次光顧解鎖名字", FUN.pop_events().any(func(e): return e.k == "reg_name") and int(rr[0].v) == 5)
	FUN.D().regular["p"] = 0.0
	var rc2 = _cust(sim, {"m_shoubao": 1}); FUN.on_spawn(sim, rc2)
	_chk("機率 0 唔會變熟客", not rc2.has("reg"))
	FUN.reload(); sim.custs.clear()
	# 名聲入帳：真 sim._pay
	var pc = _cust(sim, {"m_shoubao": 3}); pc.got = {"m_shoubao": 3}
	var rn2 = RN.pts(); sim._pay(pc)
	_chk("每件貨名聲 +1（3 件 +3）", is_equal_approx(RN.pts() - rn2, 3.0), RN.pts() - rn2)
	_p("===== 8c. 過勞：淨回落、離線、人手 =====")
	var oa = MK.ot(A); oa.on = 0; oa.down = 0.0; oa.fat = 50.0; oa.rank = 0; oa["_rk"] = 0; oa.downs = 0
	MK.tick([A], 10.0, func(_x): return true); FUN.ot_tick([A], 10.0, func(_x): return true, sim)
	_chk("收咗加班照開檔：每秒淨回落 1.85（−2 ＋0.15）", absf(float(oa.fat) - 31.5) < 0.2, oa.fat)
	oa.fat = 50.0
	MK.tick([A], 10.0, func(_x): return false); FUN.ot_tick([A], 10.0, func(_x): return false, sim)
	_chk("冇人做嘢：每秒回落 2", absf(float(oa.fat) - 30.0) < 0.2, oa.fat)
	oa.fat = 99.0; oa.on = 0
	FUN.ot_tick([A], 100.0, func(_x): return true, sim)
	_chk("正常營業點都唔會趴低（封頂 99.99）", not MK.is_down(A) and float(oa.fat) < 100.0, oa.fat)
	oa.fat = 50.0; oa.on = 1; var clk0 = FUN._clock()
	FUN.tick(sim, 0.0); MK.tick([A], 0.0, func(_x): return true)
	_chk("離線（dt 0）：唔加班唔累、時鐘唔行", is_equal_approx(float(oa.fat), 50.0) and is_equal_approx(FUN._clock(), clk0))
	oa.fat = 0.0; oa.rank = 1; oa["_rk"] = 1
	MK.tick([A], 10.0, func(_x): return true); FUN.ot_tick([A], 10.0, func(_x): return true, sim)
	_chk("老員工加班：過勞升慢 30%（10 秒 +8.4）", absf(float(oa.fat) - 8.4) < 0.3, oa.fat)
	oa.rank = 0; oa["_rk"] = 0; oa.on = 0; oa.fat = 0.0
	_p("===== 8d. 畫面文字＝實際計算 =====")
	_chk("高峰字「客流 ×N」＝真倍數", FUN.txt_peak_flow() == "3" and (func(): FUN.st().rush["ph"] = "peak"; var m = FUN.flow_mul(); FUN.st().rush["ph"] = "idle"; return FUN.fmt_mul(m) == FUN.txt_peak_flow()).call())
	_chk("大客字「×N」＝真倍數", FUN.txt_vip_mul() == FUN.fmt_mul(FUN.cf("rush", "vip_mul", 0.0)) and FUN.txt_vip_mul() == "3")
	_chk("潮流榜字「×N」＝真倍數", FUN.txt_trend_mul() == "1.5" and is_equal_approx(float(FUN.txt_trend_mul()), FUN.cf("trend", "mul", 0.0)))
	FUN.st().chain = 0; FUN.pop_events()
	var cc = _cust(sim, {"m_shoubao": 1, "m_douhua": 1}); cc.got = cc.wants.duplicate(); cc["t1"] = FUN._clock()
	var pm = FUN.pay_mul(sim, cc)
	var ce = FUN.pop_events().filter(func(e): return e.k == "chain")
	_chk("連單浮字倍數＝真正乘落去嘅倍數", ce.size() == 1 and is_equal_approx(float(ce[0].mul), pm) and FUN.txt_chain_mul(float(ce[0].mul)) == "1.5", [ce, pm])
	FUN.st().chain = 24
	var cc2 = _cust(sim, {"m_shoubao": 1, "m_douhua": 1}); cc2.got = cc2.wants.duplicate(); cc2["t1"] = FUN._clock()
	_chk("連單上限 ×2（第 25 連）", is_equal_approx(FUN.pay_mul(sim, cc2), 2.0))
	FUN.st().chain = 60
	var cc3 = _cust(sim, {"m_shoubao": 1, "m_douhua": 1}); cc3.got = cc3.wants.duplicate(); cc3["t1"] = FUN._clock()
	_chk("再連落去都唔過 ×2", is_equal_approx(FUN.pay_mul(sim, cc3), 2.0))
	var c1 = _cust(sim, {"m_shoubao": 1}); c1.got = {"m_shoubao": 1}; c1["t1"] = FUN._clock()
	_chk("只要一件：唔算連單、亦唔會斷單", is_equal_approx(FUN.pay_mul(sim, c1), 1.0) and int(FUN.st().chain) == 61, FUN.st().chain)
	sim.custs.clear(); FUN.st().chain = 0
	FUN.st().rush.clear(); FUN.pop_events(); FUN._rush_tick(sim); FUN.st().clk = float(FUN.st().rush.next) + 0.1; FUN._rush_tick(sim)
	var rw = FUN.pop_events().filter(func(e): return e.k == "rush_warn")
	_chk("預告倒數＝真正剩餘秒數", rw.size() == 1 and absf(float(rw[0].s) - FUN.rush_left()) < 0.01, [rw, FUN.rush_left()])
	FUN.st().rush.clear()
	var src = FileAccess.get_file_as_string("res://game/market/mk_fun_ui.gd")
	var rx = RegEx.new(); rx.compile("×\\s*[0-9]")
	_chk("mk_fun_ui 冇寫死倍數（全部讀數值表）", rx.search(src) == null, rx.search(src).get_string() if rx.search(src) != null else "")
	_chk("名聲等級名同門檻對得上（5 級 5 個名）", (RN.D().get("lv", []) as Array).size() == 5 and (RN.D().get("names", []) as Array).size() == 5)
	_chk("回陽間鎖字講嘅等級名＝真正要求嘅等級", RN.back_lock_text().contains(RN.level_name(int(RN.cf("back_lv", 2)))))
	_p("===== 9. 名聲 =====")
	S["mkr"] = {"v": 1, "pts": 0.0, "lv_seen": 1}
	_chk("0 分＝1 級無名小檔", RN.level() == 1 and RN.level_name() != "")
	RN.add(250.0)
	_chk("250 分＝2 級＋升級事件", RN.level() == 2 and RN.pop_events().size() == 1)
	_chk("名鬼機率：2 級 6%（等級 2 起提高）", is_equal_approx(RN.named_p(), 0.06), RN.named_p())
	_chk("名鬼機率：3 級 10%、1 級 3%", (func(): RN.add(600.0); return is_equal_approx(RN.named_p(), 0.10)).call() and (func(): var p0 = S.mkr.pts; S.mkr.pts = 0.0; var np = RN.named_p(); S.mkr.pts = p0; return is_equal_approx(np, 0.03)).call())
	_chk("回陽間：第 1、2 章唔使、第 3 章要 2 級", RN.back_ok(0) and RN.back_ok(2) and (func(): S.mkr.pts = 0.0; return not RN.back_ok(2)).call())
	S.mkr.pts = 250.0
	_chk("拔營：第 1 章要 2 級（有）、第 3 章要 3 級（冇）", RN.move_ok(0) and not RN.move_ok(2))
	RN.now_s = 1.9e9; S.mkr.pts = 1000.0; S.res["coins"] = 0.0
	var ex = RN.exchange(0)
	_chk("匯兌：50 名聲 → 100 冥幣", ex.get("ok", false) and is_equal_approx(float(S.res.coins), 100.0) and is_equal_approx(RN.pts(), 950.0))
	_chk("匯兌按章放大：第 3 章 ×25＝2500", is_equal_approx(RN.exch_coins(2), 2500.0))
	RN.exchange(0); RN.exchange(0)
	_chk("每日 3 次", not RN.exchange(0).get("ok", true) and RN.exch_left() == 0, [RN.exch_left(), RN.pts()])
	S.mkr.pts = 210.0; RN.now_s = 1.9e9 + 86400.0
	_chk("換咗會跌級：唔俾換", RN.exchange(0).get("why", "") == "pts")
	RN.now_s = -1.0
	S.mkr.pts = 3500.0
	_chk("4 級：酒館名單必有名鬼（pin）", RN.named_pin())
	J.G.erase("mk_renown_add_fn"); S.mk["renown_pts"] = 7.0; S.mkr.pts = 0.0; RN.reg()
	_chk("M1 接口：未登記前暫存嘅名聲分收返（7 分）", is_equal_approx(RN.pts(), 7.0) and is_equal_approx(float(S.mk.renown_pts), 0.0))
	J.G.mk_renown_add_fn.call(2, "tap")
	_chk("M1 接口：mk_renown_add_fn(2) → 名聲 +2", is_equal_approx(RN.pts(), 9.0))
	S.mkr.pts = 900.0; RN.reg()
	_chk("M1 接口：S.mk.renown_lv 跟住真等級（3 級）", int(S.mk.get("renown_lv", 0)) == 3 and RN.level() == 3)
	_p("===== 10. 舊收益×2／加速×2 =====")
	sim.st().boost.inc_end = J.test_clock + 1e6
	_chk("市集啟用時舊收益×2 唔生效", is_equal_approx(sim.inc_mul(), 1.0))
	_p("===== 11. 整合：真 sim 跑 30 秒冇死 =====")
	sim.st().st[A].lv = 5.0; MK.ot(A).on = 1
	_run(sim, 30.0)
	_chk("sim.step＋FUN.tick 跑 30 秒冇出錯", FUN._clock() > 29.0, FUN._clock())
	for i in 4: MKO.unassign(sim, "t_c%d" % i)
	for i in 6: MKO.unassign(sim, "t_p%d" % i)
	MKO.reload()
	# 還原
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	FUN.reload()
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])
