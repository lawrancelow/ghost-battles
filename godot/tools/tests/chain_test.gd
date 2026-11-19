# [chain] 生產鏈邏輯測試（引擎線）
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/chain_test.gd","logic"],["quit"]]
# 用固定 fixture（tools/tests/chain_fixture.json），唔受設計線資料改動影響；最後一段用正式 chain.json 做一致性檢查。
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const MVB = preload("res://game/outpost/mv_bridge.gd")
const FIX := "res://tools/tests/chain_fixture.json"
var bad := 0
var rows := 0

func _p(s) -> void: print("[chain] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[chain]   %-46s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _near(a: float, b: float, tol := 1e-6) -> bool: return absf(a - b) <= tol * maxf(1.0, absf(b))
func _S(): return J.G.get("S")

var _saved := {}
func _backup() -> void:
	_saved = _S().duplicate(true)
func _restore() -> void:
	var S = _S()
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	M.use_file(""); MD.reload()

const TG := [["t_ch1", "zhiren", "紙人一", 1.0], ["t_ch2", "youhun", "遊魂二", 11.0], ["t_ch3", "zombie", "殭屍三", 6.0], ["t_ch4", "egui", "餓鬼四", 4.0], ["t_ch5", "xiaogui", "小鬼五", 3.0]]
func _setup() -> void:
	M.use_file(FIX); MD.reload()
	var S = _S()
	J.test_clock = 1.8e12
	S.erase("mv"); S["mat"] = {}
	S["cleared"] = {}
	for k in ["wood", "rice", "planks", "buns", "coins", "troops"]: S.res[k] = 0.0
	var keep = []
	for gh in S.ghosts:
		if not str(gh.get("id")).begins_with("t_ch"): keep.append(gh)
		elif gh.get("post") != null: gh.post = null
	S["ghosts"] = keep
	for gh in S.ghosts: if gh.get("post") != null and str(gh.k) != "afu": gh.post = null
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": "藍", "lv": t[3], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	S.bld["store"] = 5.0; S.bld["house"] = 10.0

func _g(id: String): for gh in _S().ghosts: if str(gh.id) == id: return gh
func _produce(secs: float) -> void:
	var s = 0.0
	while s < secs: J.cl(J.G.get("produce"), null, [minf(1.0, secs - s)]); s += 1.0

func logic(_t) -> void:
	_backup()
	_setup()
	eco()
	_setup(); mv()
	_setup(); offline()
	_setup(); migrate()
	real_data()
	_restore()
	_p("驗算 %d 行，唔對 %d 行 → %s" % [rows, bad, "全部一致" if bad == 0 else "有錯"])
	J.test_clock = -1.0

# ---------------- 後院：包子鋪出 m_bao、拓展建築產量 ----------------
func eco() -> void:
	var S = _S()
	_p("===== 1. 包子鋪改出普通包子 m_bao（唔再出壽包） =====")
	S.bld["bun"] = 1.0; S.res["rice"] = 1000.0; S.res["buns"] = 50.0
	_g("t_ch3").post = "bun"
	var r = J.cl(J.G.get("ratesPerMin"), null, [])
	_chk("ratesPerMin：buns = 0、bao > 0", J.num(r.get("buns")) == 0.0 and J.num(r.get("bao")) > 0.0, "%s/%s" % [r.get("buns"), r.get("bao")])
	var b0 = M.amt("m_bao")
	_produce(60.0)
	var made = M.amt("m_bao") - b0
	_chk("1 分鐘：普通包子 = bao 速率", _near(made, J.num(r.bao), 1e-3), "%.3f vs %.3f" % [made, J.num(r.bao)])
	_chk("糯米扣 = 2 × 包子", _near(1000.0 - J.num(S.res.rice), 2.0 * made, 1e-3), 1000.0 - J.num(S.res.rice))
	_chk("壽包冇變（50）", J.num(S.res.buns) == 50.0, S.res.buns)
	S.res["rice"] = 0.0; b0 = M.amt("m_bao"); _produce(30.0)
	_chk("冇糯米：唔出包子", M.amt("m_bao") == b0)
	_g("t_ch3").post = null

	_p("===== 2. 拓展採集建築（陰竹林，post = bid） =====")
	S.bld["g_bamboo"] = 1.0
	_g("t_ch2").post = "g_bamboo"   # lv 11
	var R = CE.rates()
	var exp_r = 6.0 * CE.worker_f(_g("t_ch2"), "g_bamboo")   # 每隻鬼產能 = 指定能力值 ÷ 30
	_chk("陰竹 每分鐘 = rate×(1+0.15×(建築Lv−1))×能力值÷30", _near(J.num(R.g_bamboo.out.m_bamboo), exp_r), R.g_bamboo.out)
	_produce(60.0)
	_chk("1 分鐘：陰竹入 S.mat", _near(M.amt("m_bamboo"), exp_r, 1e-3), M.amt("m_bamboo"))
	S.bld["g_bamboo"] = 0.0
	_chk("未起（Lv0）：唔計", not CE.rates().has("g_bamboo"))
	S.bld["g_bamboo"] = 3.0
	_chk("建築 Lv3：×1.3", _near(J.num(CE.rates().g_bamboo.out.m_bamboo), exp_r * 1.3))
	S.mat["m_bamboo"] = 495.0; _produce(60.0)
	_chk("上限 MATS.cap = 500", _near(M.amt("m_bamboo"), 500.0), M.amt("m_bamboo"))

	_g("t_ch2").post = null
	_chk("冇派鬼：冇產出（一定要派鬼）", not CE.rates().has("g_bamboo"))
	S.bld["g_bamboo"] = 0.0
	_p("===== 3. 拓展加工建築（紙寮：2 陰竹 → 1 紙；原料唔夠按比例） =====")
	S.bld["w_paper"] = 1.0; _g("t_ch1").post = "w_paper"   # lv 1
	S.mat["m_bamboo"] = 100.0; S.mat["m_paper"] = 0.0
	var wf1 = CE.worker_f(_g("t_ch1"), "w_paper"); var cpm = 60.0 / 20.0 * wf1
	_chk("紙寮 每分鐘 3×能力倍數 次", _near(J.num(CE.rates().w_paper.out.m_paper), cpm) and _near(J.num(CE.rates().w_paper["in"].m_bamboo), 2.0 * cpm))
	S.bld["w_paper"] = 3.0
	_chk("加工 Lv3：每批 time ÷ 1.2 → 每分鐘 3.6 次", _near(J.num(CE.rates().w_paper.out.m_paper), 3.6 * wf1))
	S.bld["w_paper"] = 1.0
	_produce(60.0)
	_chk("1 分鐘：紙 +cpm、竹 −2cpm", _near(M.amt("m_paper"), cpm, 1e-3) and _near(M.amt("m_bamboo"), 100.0 - 2.0 * cpm, 1e-3), "%.2f/%.2f" % [M.amt("m_paper"), M.amt("m_bamboo")])
	S.mat["m_bamboo"] = 2.0; S.mat["m_paper"] = 0.0; _produce(60.0)
	_chk("得 2 竹：只做到 1 紙（按比例）", _near(M.amt("m_paper"), 1.0, 1e-3) and M.amt("m_bamboo") < 1e-3, "%.3f/%.3f" % [M.amt("m_paper"), M.amt("m_bamboo")])
	_chk("斷料：starved = 缺 m_bamboo", CE.starved("w_paper") == ["m_bamboo"], CE.starved("w_paper"))
	S.mat["m_bamboo"] = 100.0
	_chk("有料：唔斷", CE.starved("w_paper").is_empty())
	_chk("建築解鎖跟移動村地圖（g_far 要第 4 張）", CE.unlocked("w_paper") and not CE.unlocked("g_far"))
	_g("t_ch1").post = null
	for k in ["g_bamboo", "w_paper"]: S.bld.erase(k)

# ---------------- 移動村：扣料、斷料停、復工、分流、隨村台 ----------------
func _run(sim, secs: float, dt := 0.05) -> Array:
	var evs = []
	for i in int(secs / dt):
		J.test_clock += dt * 1000.0
		sim.step(dt); evs.append_array(sim.ev); sim.ev.clear()
	return evs
func _cnt(evs: Array, k: String, sid := "") -> int:
	var n = 0
	for e in evs: if e.k == k and (sid == "" or str(e.get("sid", "")) == sid): n += int(e.get("n", 1))
	return n
func _sim():
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	sim.plus.off = true; sim.plus.test_off = true   # [play] 呢度驗原公式（玩法線加成：羈絆、脾氣、事件，另見 tools/tests/play_test.gd）
	return sim

func mv() -> void:
	var S = _S(); var sim = _sim()
	var A = "st_shoubao"
	_p("===== 4. 移動村台按 RECIPES 扣料 =====")
	_chk("隨村台喺第 1 張圖", MD.stations(0).has(A) and MD.is_carry(A))
	_chk("need = in × out ÷ n（嘆氣蒸籠：普通包子 ×2）", sim.need(A) == {"m_bao": 2.0}, sim.need(A))
	S.mat["m_bao"] = 4.0
	sim.set_route(A, "sell")
	sim.assign(A, 0, "t_ch1")
	var ev = _run(sim, MD.tm(A, 1) + 0.3)
	_chk("做好一轉", _cnt(ev, "made", A) == 1, _cnt(ev, "made", A))
	_chk("扣咗料：普通包子 4 → 2（每轉 2）", _near(M.amt("m_bao"), 2.0), M.amt("m_bao"))
	_p("===== 5. 冇料就停（斷料），有料自動復工 =====")
	ev = _run(sim, 30.0)
	var made1 = _cnt(ev, "made", A)
	_chk("30 秒只做完已開工嗰轉（≤1）", made1 <= 1, made1)
	ev = _run(sim, 10.0)
	_chk("之後冇再做", _cnt(ev, "made", A) == 0)
	_chk("斷料：starving、缺 m_bao", sim.starving(A) and sim.missing(A) == ["m_bao"], sim.missing(A))
	_chk("手做都要料：tap = starve", sim.tap_station(A) == "starve")
	S.mat["m_bao"] = 20.0; sim.set_route(A, "stock")   # 入倉唔使搬貨，轉數好數
	ev = _run(sim, MD.tm(A, 1) * 3 + 0.5)
	_chk("加料後自動復工（做咗 ≥ 2 轉）", _cnt(ev, "made", A) >= 2, _cnt(ev, "made", A))
	_chk("唔再斷料", not sim.starving(A))
	_p("===== 6. 分流規則 =====")
	sim.set_route(A, "auto")
	var D_ = "st_douhua"
	sim.st().st[D_].unlocked = false
	_chk("壽包（冇上層台用）：一半入倉 [2,2]", sim.split(A, 4) == [2, 2], sim.split(A, 4))
	var pv_ = load("res://game/outpost/mv_idle.gd").prev_of(sim.ci(), D_)   # [idle] 解鎖鏈：上一個台先到 Lv10（測試資料 CARRY 唔同）
	if pv_ != "": sim.st().st[pv_].lv = maxf(10.0, sim.lv(pv_))
	S.res["coins"] = 1e9; sim.unlock(D_)
	S.res["buns"] = 0.0
	_chk("豆花台解鎖（用壽包）：上層要料優先 → 全入倉 [4,0]", sim.split(A, 4) == [4, 0], sim.split(A, 4))
	_chk("需求線 = 1 × 1 員工(最少1) × 4 轉，最少 5", _near(sim.buffer_of("m_shoubao", A), 5.0), sim.buffer_of("m_shoubao", A))
	S.res["buns"] = 6.0
	_chk("庫存夠需求線：返去一半入倉", sim.split(A, 4) == [2, 2], sim.split(A, 4))
	sim.set_route(A, "sell"); _chk("全部出售 [0,4]", sim.split(A, 4) == [0, 4])
	sim.set_route(A, "stock"); _chk("全部入倉 [4,0]", sim.split(A, 4) == [4, 0])
	_chk("next_route 輪：stock → sell", sim.next_route(A) == "sell")
	sim.set_route(A, "auto")
	_chk("裝備（棺材床 GEAR）：擺櫃台賣", sim.split("st_guancaichuang", 3) == [0, 3])
	S.mat["m_douhua"] = 0.0
	_chk("戰鬥道具（豆花）：未夠 10 件 → 入倉", sim.split(D_, 2) == [2, 0])
	S.mat["m_douhua"] = 10.0
	_chk("戰鬥道具夠 10 件 → 擺櫃台", sim.split(D_, 2) == [0, 2])
	_chk("紙衫：上層棺材床台未解鎖 → 出售", sim.split("st_zhishan", 2) == [0, 2])
	S.mat["m_bao"] = 100.0; S.res["buns"] = 0.0
	sim.st().counter = {}
	var b0 = J.num(S.res.buns); var c0 = sim.counter_n(str(MD.st_def(A).good))
	ev = _run(sim, 20.0)
	var mk = _cnt(ev, "made", A); var stk = _cnt(ev, "stock", A)
	_chk("實跑：入倉事件數 = 壽包增加", _near(J.num(S.res.buns) - b0, float(stk)), "%d / %.0f" % [stk, J.num(S.res.buns) - b0])
	_chk("實跑：有入倉（上層要料）", stk > 0, "made %d stock %d" % [mk, stk])
	_chk("壽包只由蒸籠出：makers(m_shoubao) = [嘆氣蒸籠]", M.makers("m_shoubao").size() == 1 and M.makers("m_shoubao")[0].id == A)
	_chk("任務計數 made.m_shoubao = 產出數", J.num(sim.st().made.get("m_shoubao")) >= float(mk))
	_p("===== 7. 隨村台跟大屋走（每張圖都有、等級保留、版面容得落） =====")
	sim.st().st[A].lv = 7.0
	S.cleared["1-3"] = true
	for i in MD.goals(0).size(): sim.st().goals_done.append(float(i))
	_chk("move_next", sim.move_next())
	_chk("第 2 張圖都有嘆氣蒸籠", MD.stations(1).has(A) and sim.st().st.has(A))
	_chk("等級跟住走（Lv7）、已解鎖", sim.lv(A) == 7.0 and sim.unlocked(A))
	var L1 = MD.layout(1); var raw = MD.map_def(1).get("layout", {})
	_chk("版面有隨村台位", (L1.st as Dictionary).has(A))
	var ok = true
	var pA = MD.st_xy(1, A)
	for sid in MD.stations(1):
		if sid != A and MD.st_xy(1, sid).distance_to(pA) < 200.0: ok = false
	_chk("隨村台唔撳住其他台（距離 ≥ 200）", ok)
	if raw is Dictionary and raw.has("st") and not (raw.st as Dictionary).has(A):
		_chk("版面加高 270", _near(float(L1.h), float(raw.h) + 270.0), "%s→%s" % [raw.h, L1.h])
	_chk("搬貨路線有（≥ 3 點）", MD.st_path(1, A).size() >= 3)

# ---------------- 離線：按生產鏈計、受原料限制、8 小時、唔重複 ----------------
func offline() -> void:
	var S = _S(); var sim = _sim()
	var A = "st_shoubao"
	sim.set_route(A, "sell")
	sim.assign(A, 0, "t_ch1"); sim.assign(A, 1, "t_ch2")
	S.mat["m_bao"] = 10.0; S.res["coins"] = 0.0
	_p("===== 8. 離線（移動村）：受原料限制 =====")
	var r = sim.offline_gain(3600000.0)
	_chk("10 個普通包子 → 最多 5 個壽包", _near(J.num(sim.st().made.get("m_shoubao")), 5.0, 1e-4), sim.st().made)
	_chk("料用晒", M.amt("m_bao") < 1e-6, M.amt("m_bao"))
	_chk("冥幣 = 5 × 單價", _near(r.coins, floor(5.0 * MD.val(A, 1, 0))), "%s vs %s" % [r.coins, 5.0 * MD.val(A, 1, 0)])
	S.mat["m_bao"] = 1e6; S.res["coins"] = 0.0; sim.st().made = {}
	r = sim.offline_gain(10.0 * 3600000.0)
	var rate = 2.0 * MD.out(A, 1) / (MD.tm(A, 1) + MD.carry_s(0, A))
	_chk("料夠：10 小時只計 8 小時", r.capped and _near(J.num(sim.st().made.m_shoubao), rate * 8 * 3600, 1e-4), "%.1f vs %.1f" % [J.num(sim.st().made.m_shoubao), rate * 8 * 3600])
	_chk("料夠：冥幣 = 全速 × 8 小時", _near(r.coins, floor(rate * 8 * 3600 * MD.val(A, 1, 0)), 1e-6))
	_p("===== 9. 離線（後院＋移動村交替；bridge.mv_offline） =====")
	S["mv_on"] = true; S.mat["m_bao"] = 0.0; S.res["rice"] = 0.0; S.res["coins"] = 0.0; sim.st().made = {}
	S.bld["bun"] = 1.0; S.bld["rice"] = 1.0
	_g("t_ch3").post = "rice"; _g("t_ch4").post = "bun"
	S["last"] = J.now() - 2.0 * 3600000.0; sim.st().last = S.last
	var rr = J.cl(J.G.get("ratesPerMin"), null, [])
	var cg = MVB.mv_offline()
	var steamed = J.num(sim.st().made.get("m_shoubao"))
	var bao_made = J.num(rr.bao) * 120.0
	_chk("鏈：冇存貨都蒸到壽包（下層邊做邊送）", steamed > 1.0, steamed)
	_chk("鏈：壽包 ≤ 普通包子產量 ÷ 2（受原料限制）", steamed <= bao_made / 2.0 + 1.0, "%.1f ≤ %.1f" % [steamed, bao_made / 2.0])
	_chk("鏈：有冥幣", cg > 0.0, cg)
	var c1 = J.num(S.res.coins)
	_chk("即刻再叫 = 0（唔重複）", MVB.mv_offline() == 0.0 and J.num(S.res.coins) == c1)
	_chk("S.mv.last 已更新（場景返嚟唔會再計）", sim.check_away().is_empty())
	S["last"] = J.now() - 30.0 * 3600000.0
	S.mat["m_bao"] = 1e6; sim.st().made = {}
	MVB.mv_offline()
	_chk("鏈：離開 30 小時都只計 8 小時", J.num(sim.st().made.get("m_shoubao")) <= rate * 8 * 3600 * 1.0001, J.num(sim.st().made.get("m_shoubao")))
	_g("t_ch3").post = null; _g("t_ch4").post = null
	_p("===== 10. 「停咗錶檔產陰兵」：移動村台唔再有副產出 =====")
	for sid in sim.st().st: sim.st().st[sid].unlocked = true
	var gi = 0
	for sid in sim.st().st:
		if gi < 3: sim.assign(sid, 0, ["t_ch3", "t_ch4", "t_ch5"][gi]); gi += 1
	S.bld["home"] = 0.0
	var r2 = J.cl(J.G.get("ratesPerMin"), null, [])
	_chk("移動村派滿鬼：陰兵 0、壽包 0、棺材板 0（冇民宅／後院崗位）", J.num(r2.troops) == 0.0 and J.num(r2.buns) == 0.0 and J.num(r2.planks) == 0.0, "%s/%s/%s" % [r2.troops, r2.buns, r2.planks])
	S.erase("mv_on")

# ---------------- 舊存檔遷移 ----------------
func migrate() -> void:
	var S = _S()
	_p("===== 11. 舊存檔：壽包、棺材板保留；S.mat 補返 =====")
	S.erase("mat"); S.erase("chain_v"); S.res["buns"] = 123.0; S.res["planks"] = 45.0
	CE.migrate(S); MVB.sync()
	_chk("S.mat 有", S.get("mat") is Dictionary)
	_chk("壽包 123、棺材板 45 照留", J.num(S.res.buns) == 123.0 and J.num(S.res.planks) == 45.0)
	_chk("M.amt 對舊資源（m_shoubao = res.buns）", M.amt("m_shoubao") == 123.0 and M.amt("m_plank") == 45.0)
	_chk("chain_v = 1", int(J.num(S.get("chain_v"))) == 1)

# ---------------- 正式資料（設計線 chain.json）一致性 ----------------
func real_data() -> void:
	M.use_file(""); MD.reload()
	_p("===== 12. 正式 chain.json／outpost.json 一致性 =====")
	if not FileAccess.file_exists("res://data/nat/chain.json"):
		_p("  （未有 data/nat/chain.json，略過）"); return
	var D = M.D(); var probs = []
	for sid in D.RECIPES:
		if not MD.D().STATIONS.has(sid): probs.append("RECIPES %s 唔喺 STATIONS" % sid); continue
		var r = D.RECIPES[sid]; var out = str(r.get("out", ""))
		if str(MD.st_def(sid).get("good", "")) != out: probs.append("%s good≠out" % sid)
		for mid in r.get("in", {}):
			if not M.has_def(str(mid)): probs.append("%s 用咗未定義 %s" % [sid, mid])
			elif M.tier(str(mid)) >= M.tier(out): probs.append("%s 用同層／高層料 %s" % [sid, mid])
	for sid in M.carry(): if not MD.D().STATIONS.has(sid): probs.append("CARRY %s 唔喺 STATIONS" % sid)
	for c in MD.maps_n():
		for sid in MD.stations(c):
			if M.recipe(sid).is_empty(): probs.append("圖%d %s 冇 RECIPES" % [c, sid])
			if not (MD.layout(c).st as Dictionary).has(sid): probs.append("圖%d %s 冇位" % [c, sid])
	_chk("一致性（%d 個問題）" % probs.size(), probs.is_empty(), "；".join(probs.slice(0, 8)))
	_chk("壽包只由隨村台出", M.makers("m_shoubao").all(func(x): return x.k == "st" and M.carry().has(x.id)), M.makers("m_shoubao"))
	_chk("普通包子由包子鋪出（old=bun）", M.makers("m_bao").any(func(x): return x.id == M.bld_of_old("bun")), M.makers("m_bao"))

# ================= 截圖（[["wait",3],["notitle"],["gdrun","res://tools/tests/chain_test.gd","shots"],["quit"]]） =================
const OUT := "/tmp/chain/shots/"
var sc = null
func _shot(name: String) -> void:
	var st = Engine.get_main_loop().root.get_node("Main").story
	for i in 10:
		if st.cur == null: break
		st.skip_scene(); await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	await RenderingServer.frame_post_draw
	Engine.get_main_loop().root.get_viewport().get_texture().get_image().save_png(OUT + name + ".png"); _p("SHOT " + OUT + name + ".png")
func _wait(s: float) -> void: await Engine.get_main_loop().create_timer(s).timeout
func shots(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	M.use_file(""); MD.reload()
	var S = _S()
	J.test_clock = -1.0
	S.erase("mv"); S["mat"] = {}
	for t in TG: if _g(t[0]) == null: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": "藍", "lv": t[3], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	var m = tt.main()
	sc = m.mv_view   # 用主畫面真嘅移動村
	if sc == null: _p("冇 mv_view"); return
	sc.on_hide()
	var sim = sc.sim; sim.st()
	S.res["buns"] = 3.0; S.mat["m_paper"] = 40.0; S.mat["m_wellwater"] = 30.0; S.mat["m_bao"] = 0.0
	sim.assign("st_shoubao", 0, "t_ch1")          # 冇普通包子 → 斷料
	sim.assign("st_zhishan", 0, "t_ch2"); sim.assign("st_douhua", 0, "t_ch3")
	S.res["coins"] = 500.0
	sc.on_show()
	await _wait(5.0)
	sc.focus_station("st_shoubao"); await _wait(1.0)
	await _shot("01_starve_station")
	sc.open_sheet("st_shoubao"); await _wait(1.0)
	await _shot("02_card_steamer_starve")
	sc.close_sheet()
	sc.open_sheet("st_douhua"); await _wait(1.0)
	await _shot("03_card_douhua")
	sc.close_sheet()
	S.mat["m_bao"] = 30.0; await _wait(6.0)
	sc.focus_station("st_shoubao"); await _wait(1.0)
	await _shot("04_resumed_stock")
	sc.open_sheet("st_nuomici"); await _wait(0.2)
	if not sc.sheet.visible:
		S.res["coins"] = 1e7; sim.unlock("st_nuomici"); sc.open_sheet("st_nuomici")
	await _wait(1.0)
	await _shot("05_card_nuomici")
	sc.close_sheet()
	# 第 2 張圖：隨村台位
	for sid in sim.st().st:
		for j in 3: sim.assign(sid, j, null)
	S.mv.ci = 1.0; S.mv.st = {}; S.mv.counter = {}; S.mv.pile = {}
	sim.reset_live(); sim.st(); sc._after_move(true)
	await _wait(1.0)
	sc.focus_station("st_shoubao"); await _wait(1.2)
	await _shot("06_map1_carry")
	sc.open_sheet("st_zhishan"); await _wait(1.0)
	await _shot("07_card_zhishan_map1")
	sc.close_sheet()
