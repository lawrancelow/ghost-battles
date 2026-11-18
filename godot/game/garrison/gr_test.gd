# 分村＋補給網 headless 驗證（D 線）。用 tester：["gdrun","res://game/garrison/gr_test.gd","logic"]
# 做法：假時鐘 J.test_clock 推進陰間夜；旁邊用一個「獨立重寫」嘅模擬器（只讀 supply.json，自己計公式）逐晚對數，印驗算表。
extends RefCounted

var C: Dictionary
var GR
var bad := 0
var rows := 0
var T0 := 0.0
const NMS := 20.0 * 60000.0

func _p(s) -> void: print("[gar] ", s)
func _chk(name: String, got: float, exp: float) -> void:
	rows += 1
	var ok = absf(got - exp) <= 1e-6 * maxf(1.0, absf(exp))
	if not ok: bad += 1
	print("[gar]   %-28s 遊戲=%14.4f  驗算=%14.4f  %s" % [name, got, exp, "OK" if ok else "<<< 唔對"])

# ---------------- 測試鬼 ----------------
const TG := [
	# id, k, name, q, lv, st, 崗位, 位, 預期鄉里（守槐林 ci0）
	["t_egk", "eguiking", "餓鬼王", "名", 10.0, [95.0, 20.0, 70.0], "bun", 0, 1.5],
	["t_qg", "n30_qionggui", "窮鬼", "名", 8.0, [30.0, 55.0, 55.0], "bun", 1, 1.3],
	["t_toy", "toyol", "Toyol", "名", 12.0, [30.0, 65.0, 50.0], "rest", 0, 1.0],
	["t_yh1", "youhun", "遊魂阿強", "藍", 5.0, [22.0, 18.0, 20.0], "rest", 1, 1.3],
	["t_dx", "n30_danxiao", "膽小鬼", "名", 9.0, [35.0, 45.0, 60.0], "guard", 0, 1.3],
	["t_yh2", "youhun", "遊魂阿明", "藍", 4.0, [20.0, 20.0, 24.0], "guard", 1, 1.3],
]

func _S(): return J.G.get("S")
func _stat(t, i: int) -> float: return floor(t[5][i] * (1.0 + 0.06 * (t[4] - 1.0)) + 0.5)   # J.round

# ---------------- 獨立模擬器 ----------------
var sim := {}
func _lvmul(lv: float) -> float: return 1.0 + C.LV_MUL * (lv - 1.0)
func _mile(lv: float) -> float:
	var m = 1.0
	for x in C.MILESTONE: if lv >= x[0]: m *= x[1]
	return m
func _sim_init(cap_v: float) -> void:
	var g = _S().gar; var R = _S().res
	sim = {"res": {"buns": R.buns, "planks": R.planks, "coins": R.coins}, "stock": g.maps["0"].stock.duplicate(), "front": {"buns": g.front.buns, "planks": g.front.planks},
		"starve": g.starve, "convoy": (g.convoy.duplicate(true) if g.convoy is Dictionary else null), "home": g.home, "vcap": cap_v, "troops": R.troops, "lv": g.maps["0"].lv.duplicate()}
func _sim_night(n: float) -> void:
	var up = C.MAPS[1].upkeep; var s = sim
	var sm = 1.0 if s.starve == 0 else C.STARVE[int(s.starve) - 1].inc
	# 產量（槐林：棺材板 20）
	var y = 0.0
	for t in TG: y += 20.0 * (1.0 + 0.03 * t[4]) * t[8]
	var cap = C.STORE.base * (1.0 + C.STORE.perLv * (s.lv.store - 1.0)) * _mile(s.lv.store)
	s.stock.planks = minf(maxf(cap, s.stock.planks), s.stock.planks + y)
	# 收入
	var kb = 0.0; var kr = 0.0; var gd = 0.0
	for t in TG:
		var role = 1.5 if t[7] == 0 else 1.0
		if t[6] == "bun": kb += (1.0 + _stat(t, 1) / 100.0) * role * t[8]
		if t[6] == "rest": kr += (1.0 + _stat(t, 0) / 100.0) * role * t[8]
		if t[6] == "guard": gd += _stat(t, 2) * role * t[8]
	var inc = 25.0 * 1.0 * _lvmul(s.lv.bun) * _mile(s.lv.bun) * kb * sm + 20.0 * 1.0 * _lvmul(s.lv.rest) * _mile(s.lv.rest) * kr * sm
	s.res.coins += inc; s["inc"] = inc
	gd *= _lvmul(s.lv.guard) * _mile(s.lv.guard)
	var rate = 0.08 * maxf(0.0, 1.0 - gd / 120.0)
	for it in ["buns", "planks"]: s.stock[it] -= s.stock[it] * rate
	# 車到
	if s.convoy != null and n >= s.convoy.eta:
		for it in ["buns", "planks"]:
			var room = maxf(0.0, up[it] * 5.0 - s.front[it]); var a = minf(room, s.convoy[it]); s.front[it] += a
			var x = s.convoy[it] - a + s.convoy.res[it]; var v = s.res[it]
			s.res[it] = maxf(v, minf(s.vcap, v + x))
		s.convoy = null
		if s.front.buns >= up.buns and s.front.planks >= up.planks: s.starve = 0.0
	# 出車
	if fmod(n, 3.0) == 0.0 and s.convoy == null:
		var ccap = 600.0 + 6.0 * minf(s.troops, 500.0)
		var want = {}; var tot = 0.0
		for it in ["buns", "planks"]: want[it] = maxf(0.0, up[it] * 5.0 - s.front[it] + up[it] * 3.0); tot += want[it]
		var sc = minf(1.0, ccap / tot) if tot > 0 else 0.0
		var load = {"buns": 0.0, "planks": 0.0, "res": {"buns": 0.0, "planks": 0.0}, "eta": n + 3.0}
		for it in ["buns", "planks"]:
			var need = want[it] * sc; var x = minf(need, s.stock[it]); s.stock[it] -= x; load[it] += x; need -= x
			if need > 0 and s.home:
				var x2 = minf(need, s.res[it] * 0.4); s.res[it] -= x2; load[it] += x2
		for it in ["buns", "planks"]:
			var r = s.stock[it] * 0.3; s.stock[it] -= r; load.res[it] += r
		if load.buns + load.planks + load.res.buns + load.res.planks > 0: s.convoy = load
	# 食糧
	var short = false
	for it in ["buns", "planks"]:
		if s.front[it] + 1e-6 < up[it]: short = true
		s.front[it] -= minf(s.front[it], up[it])
	s.starve = minf(3.0, s.starve + 1.0) if short else 0.0

func _cmp(tag: String) -> void:
	var g = _S().gar; var R = _S().res
	_p("— %s：第 %d 夜 —" % [tag, int(g.done)])
	_chk("冥幣（老家）", R.coins, sim.res.coins)
	_chk("壽包（老家）", R.buns, sim.res.buns)
	_chk("棺材板（老家）", R.planks, sim.res.planks)
	_chk("槐林存糧・棺材板", g.maps["0"].stock.planks, sim.stock.planks)
	_chk("槐林存糧・壽包", g.maps["0"].stock.buns, sim.stock.buns)
	_chk("前線・壽包", g.front.buns, sim.front.buns)
	_chk("前線・棺材板", g.front.planks, sim.front.planks)
	_chk("斷糧級數", g.starve, sim.starve)
	_chk("車上・壽包", g.convoy.buns if g.convoy is Dictionary else -1.0, sim.convoy.buns if sim.convoy != null else -1.0)
	_chk("車上・棺材板", g.convoy.planks if g.convoy is Dictionary else -1.0, sim.convoy.planks if sim.convoy != null else -1.0)

func _adv(nights: float) -> Dictionary:
	J.test_clock += nights * NMS
	return GR.tick()

# ---------------- 主測試 ----------------
func logic(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison"); GR.quiet = true
	C = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/supply.json"))
	var S = _S()
	T0 = floor(Time.get_unix_time_from_system() * 1000.0 / NMS) * NMS + 1000.0
	J.test_clock = T0
	S.erase("gar"); S["cleared"] = {"1-1": true, "1-2": true, "1-3": true}
	S["seen"] = S.get("seen", {}); S.seen.erase("gift_car"); S.seen.erase("ch5_pocong")
	S["res"] = {"wood": 0.0, "rice": 0.0, "planks": 3000.0, "buns": 1000.0, "coins": 5000.0, "troops": 100.0}
	var keep = []
	for gh in S.ghosts: if not str(gh.get("id")).begins_with("t_"): keep.append(gh)
	S["ghosts"] = keep
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": t[3], "lv": t[4], "st": t[5].duplicate(), "post": null, "spent": 0.0})
	GR.tick()
	_p("開始：is_open(0)=%s is_open(1)=%s 前線=%d 夜=%d" % [GR.is_open(0), GR.is_open(1), GR.frontline(), int(S.gar.done)])
	if GR.frontline() != 1: bad += 1; _p("前線應該係 1 <<< 唔對")
	# ---- 派鬼（照抄 station assign／validate）----
	for t in TG:
		var ok = GR.assign(0, t[6], t[7], t[0])
		if not ok: bad += 1; _p("派鬼失敗 %s" % t[0])
	_p("雜鬼做管事（應該拒絕）：%s" % str(GR.assign(0, "bun", 0, "t_yh1")))
	if GR.assign(0, "bun", 0, "t_yh1"): bad += 1
	_p("幫工第 2 位（檔口 Lv1 未開，應該拒絕）：%s" % str(GR.assign(0, "bun", 2, "t_yh1")))
	if GR.assign(0, "bun", 2, "t_yh1"): bad += 1
	for t in TG:
		var gh = GR.ghost(t[0]); var hm = GR.home_mul(gh, 0)
		_chk("鄉里 %s" % t[2], hm, t[8])
		if J.str(gh.post) != "garrison": bad += 1; _p("post 唔係 garrison <<<")
	_chk("鄉里 Toyol 守甘榜（Boss 老家）", GR.home_mul(GR.ghost("t_toy"), 1), 1.5)
	_chk("鄉里 窮鬼守甘榜", GR.home_mul(GR.ghost("t_qg"), 1), 1.0)
	# 互斥：村子搶走 → validate 清格；POSTS 已登記
	var PO = J.G.get("POSTS"); _p("POSTS.garrison = %s" % str(PO.get("garrison")))
	if not PO.has("garrison"): bad += 1
	_p("post_label = %s" % J.str(J.cl(J.G.get("postLabel"), null, ["garrison"])))
	var free0 = GR.free_ghosts().map(func(x): return x.id)
	_p("free_ghosts（駐守嘅唔應該喺度）= %s" % str(free0))
	for t in TG: if free0.has(t[0]): bad += 1
	GR.ghost("t_yh2").post = "wood"; GR.validate()
	_chk("村子搶走遊魂阿明 → 守夜檔幫工格清空", 1.0 if GR.ms(0).posts.guard[1] == null else 0.0, 1.0)
	GR.assign(0, "guard", 1, "t_yh2")
	_chk("再派返 → post", 1.0 if J.str(GR.ghost("t_yh2").post) == "garrison" else 0.0, 1.0)
	S.gar.front["buns"] = 120.0 * C.START_NIGHTS; S.gar.front["planks"] = 80.0 * C.START_NIGHTS
	_chk("開荒糧 = START_NIGHTS 晚", S.gar.front.buns, 120.0 * 5.0)

	# ---- A：逐晚推進 1–6 晚（第 3 晚出車、第 6 晚到）----
	_p("===== A：產量、收入、車隊（第 1–6 晚）=====")
	_sim_init(J.num(J.mc(J.G.F, "cap", [])))
	for i in 6:
		var rep = _adv(1.0); _sim_night(J.num(S.gar.done))
		_p("第 %d 夜：產量 棺材板 +%.2f、收入 冥幣 +%.2f（驗算 +%.2f）、車隊 出=%d 到=%d" % [int(S.gar.done), rep.yield.planks, rep.coins, sim.inc, int(rep.convoys), int(rep.arrived)])
		_cmp("A")
	# ---- B：斷糧（關老家幫補、前線清空壽包；槐林只出棺材板）----
	_p("===== B：斷糧逐級 =====")
	S.gar["home"] = false; S.gar.front["buns"] = 0.0; S.gar["convoy"] = null   # 路上嗰班車當俾孤魂截咗（測試用）
	_sim_init(J.num(J.mc(J.G.F, "cap", [])))
	var inc_ok = []
	for i in 3:
		var c0 = S.res.coins
		_adv(1.0); _sim_night(J.num(S.gar.done))
		_p("第 %d 夜：斷糧 %d 級、收入 ×%s → +%.2f" % [int(S.gar.done), int(S.gar.starve), str(GR.starve_mul()), S.res.coins - c0])
		_cmp("B")
	_chk("第 3 晚斷糧 = 3 級", S.gar.starve, 3.0)
	_chk("熄燈：檔口收入 = 0", GR.income(0, "bun"), 0.0)
	_chk("主線冇卡：is_open/region_open(1)", 1.0 if GR.region_open(1) else 0.0, 1.0)
	# ---- C：恢復（開返老家幫補，叫急件車）----
	_p("===== C：急件車恢復 =====")
	S.gar["home"] = true
	var plan = GR.urgent_plan(); var c1 = S.res.coins; var b1 = S.res.buns
	_p("急件計劃：%s" % str(plan))
	var ok_u = GR.urgent()
	_chk("急件車成功", 1.0 if ok_u else 0.0, 1.0)
	_chk("急件扣冥幣 = 2 × 件數", c1 - S.res.coins, ceil((plan.buns + plan.planks) * 2.0))
	_chk("急件壽包 = 老家四成（前線要 600）", plan.buns, minf(600.0, b1 * 0.4))
	_chk("車一到即刻恢復：斷糧 = 0", S.gar.starve, 0.0)
	_chk("同一晚第二次叫（應該拒絕）", 1.0 if GR.urgent() else 0.0, 0.0)
	_sim_init(J.num(J.mc(J.G.F, "cap", [])))
	for i in 3:
		_adv(1.0); _sim_night(J.num(S.gar.done)); _cmp("C")
	# ---- 升級＋招牌 ----
	_p("===== 升級／招牌 =====")
	S.res["planks"] = 99999.0; S.res["coins"] = 999999.0
	var costs = []; var inc1 = GR.income(0, "bun", false)
	for i in 4:
		var c = GR.up_cost(0, "bun"); costs.append(c); GR.upgrade(0, "bun")
	_chk("壽包檔 Lv5", GR.lv_of(0, "bun"), 5.0)
	_chk("Lv1→2 費用 棺材板 15×1^1.6", costs[0].planks, 15.0)
	_chk("Lv4→5 費用 冥幣 round(20×4^1.7)", costs[3].coins, round(20.0 * pow(4.0, 1.7)))
	_chk("招牌 Lv5 ×1.5", GR.mile(5.0), 1.5)
	_chk("招牌 Lv20 ×1.5^4", GR.mile(20.0), pow(1.5, 4))
	_chk("Lv5 收入 = Lv1 × (1+0.3×4) × 1.5", GR.income(0, "bun", false), inc1 * 2.2 * 1.5)
	_chk("Lv5 幫工位 = 1；Lv6 = 2", float(GR.helpers(5.0)) * 10 + GR.helpers(6.0), 12.0)
	S.res["planks"] = 3000.0; S.res["coins"] = 5000.0; S.res["buns"] = 1000.0
	# ---- D：離線 10 個鐘 → 只補 8 個鐘（24 晚）----
	_p("===== D：離線 10 小時（上限 8 小時 = 24 晚）=====")
	_sim_init(J.num(J.mc(J.G.F, "cap", [])))
	var d0 = S.gar.done
	var rep2 = _adv(30.0)
	var nn = d0 + 6.0   # 頭 6 晚跳過（超出 8 小時）
	for i in 24: nn += 1.0; _sim_night(nn)
	_chk("離線處理晚數", rep2.nights, 24.0)
	_chk("跳過晚數", rep2.skip, 6.0)
	_chk("夜數推到", S.gar.done, d0 + 30.0)
	_chk("離線車隊出車班數", rep2.convoys, 8.0)
	_cmp("D")
	_p("交更簿：%s" % JSON.stringify(rep2).substr(0, 600))
	var rep3 = GR.tick()
	_chk("即刻再 tick 唔會重複計", rep3.get("nights", 0.0), 0.0)
	# ---- E：gift_car、Pocong、前線轉移 ----
	_p("===== E：紙紮跑車／Pocong／前線推進 =====")
	var cap0 = GR.convoy_cap(); S.seen["gift_car"] = true
	_chk("紙紮跑車容量 ×2", GR.convoy_cap(), cap0 * 2.0)
	_chk("容量 = 600 + 6×陰兵", cap0, 600.0 + 6.0 * minf(S.res.troops, 500.0))
	S.seen["ch5_pocong"] = true
	var msg = GR._msg_depart({"buns": 1.0, "planks": 2.0}, 0.0, 1)
	_p("Pocong 提示：%s" % msg)
	if not msg.begins_with("Pocong"): bad += 1
	S.seen.erase("ch5_pocong")
	_p("冥通提示：%s" % GR._msg_depart({"buns": 1.0, "planks": 2.0}, 0.0, 1))
	var fb = S.gar.front.buns; var sb = GR.ms(1).stock.buns
	S.cleared["2-3"] = true; GR.tick()
	_chk("通關甘榜 → 前線變 2", float(GR.frontline()), 2.0)
	_chk("舊前線剩糧入甘榜分村", GR.ms(1).stock.buns, sb + fb)
	_chk("新前線開荒糧 壽包 = 280×5", S.gar.front.buns, 280.0 * 5.0)
	_chk("甘榜分村 is_open", 1.0 if GR.is_open(1) else 0.0, 1.0)
	J.test_clock = -1.0
	GR.tick()
	_p("時鐘倒退後 tick：夜=%d（唔應該扣返）" % int(S.gar.done))
	_p("驗算 %d 行，唔對 %d 行 → %s" % [rows, bad, "全部一致" if bad == 0 else "有錯"])
	GR.quiet = false

# ---------------- 截圖用 ----------------
func shot_setup(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var S = _S()
	S["cleared"] = {"1-1": true, "1-2": true, "1-3": true, "2-1": true, "2-2": true, "2-3": true}
	S.res["planks"] = maxf(S.res.planks, 3000.0); S.res["coins"] = maxf(S.res.coins, 20000.0); S.res["troops"] = 150.0
	if GR.ghost("t_egk") == null:
		for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": t[3], "lv": t[4], "st": t[5].duplicate(), "post": null, "spent": 0.0})
	GR.tick()
	for t in TG: GR.assign(0, t[6], t[7], t[0])
	GR.ms(0).lv["bun"] = 5.0
	GR.ms(0).lv["guard"] = 6.0; GR.ms(0).stock["planks"] = 180.0
	GR.open(0)
	_p("panel open ci=0")
func shot_map1(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	GR.open(1); _p("panel open ci=1")
func shot_scroll(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var p = GR.panel; p.scroll.scroll_vertical = 520; _p("scrolled")
func shot_picker(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var p = GR.panel; p.show_map(0); p._open_picker("bun", 1); _p("picker")
func shot_close(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	GR.close()
func shot_report(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	GR.quiet = false
	J.test_clock = J.now() + 9.0 * 3600000.0; GR.tick(); J.test_clock = -1.0
	_p("report queued")
func shot_scroll2(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var p = GR.panel; p.scroll.scroll_vertical = 1400; _p("scrolled2")
