# 移動村 headless 驗證＋截圖（場景未掛入主畫面都測得到）
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://game/outpost/mv_test.gd","logic"],["gdrun","res://game/outpost/mv_test.gd","shots"],["quit"]]
# 驗算全部用獨立公式（唔叫 mv_data 嘅公式）同遊戲數值逐項對。
extends RefCounted

const SIM = preload("res://game/outpost/mv_sim.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")   # [idle]
const OUT := "/tmp/mv/shots2/"
var D: Dictionary
var bad := 0
var rows := 0

func _p(s) -> void: print("[mv] ", s)
func _chk(name: String, got: float, exp: float, tol := 1e-6) -> void:
	rows += 1
	var ok = absf(got - exp) <= tol * maxf(1.0, absf(exp))
	if not ok: bad += 1
	print("[mv]   %-40s 遊戲=%16.4f  驗算=%16.4f  %s" % [name, got, exp, "OK" if ok else "<<< 唔對"])
func _S(): return J.G.get("S")

# ---- 獨立公式 ----
func _sd(sid): return D.STATIONS[sid]
func _nm(sid, lv) -> int:
	var n = 0
	for m in _sd(sid).miles: if lv >= m: n += 1
	return n
# [idle] 里程碑輪流：第 i 個（按等級排）雙數 = 速度 ×2、單數 = 售價 ×2；每個 +1 品質星（售價 +20%／粒）
func _nk(sid, lv, odd: bool) -> int:
	var a = []
	for m in _sd(sid).miles: a.append(int(m))
	a.sort()
	var n = 0
	for i in a.size(): if lv >= a[i] and (i % 2 == 1) == odd: n += 1
	return n
func _val(sid, lv) -> float: return float(D.GOODS[_sd(sid).good].price) * (1.0 + 0.1 * (lv - 1)) * pow(2, _nk(sid, lv, true)) * (1.0 + 0.2 * _nm(sid, lv))
func _out(sid, lv) -> int: return int(_sd(sid).base_out) + int((lv - 1) / 10)
func _tm(sid, lv) -> float: return float(_sd(sid).base_time) / (1.0 + 0.02 * (lv - 1)) / pow(2, _nk(sid, lv, false))   # [idle]
# 搬貨來回時間（獨立計）：台前 → road[ri] → … → road[j] → 櫃台後，÷ 240 × 2 + 0.6
func _carry(ci: int, sid) -> float:
	var Ly = D.MAPS[ci].layout; var e = Ly.st[sid]; var rd = Ly.road; var j = int(Ly.j); var ri = int(e[2])
	var pts = [Vector2(e[0], e[1] + 30)]
	var i = ri
	while true:
		pts.append(Vector2(rd[i][0], rd[i][1]))
		if i == j: break
		i += -1 if ri >= j else 1
	pts.append(Vector2(Ly.counter[0], Ly.counter[1] - 30))
	var d = 0.0
	for k in range(1, pts.size()): d += pts[k - 1].distance_to(pts[k])
	return 2.0 * d / 240.0 + 0.6
func _c1(sid, lv) -> float: return ceil(float(_sd(sid).up_cost0) * pow(float(_sd(sid).up_mul), lv - 1))

const TG := [["t_mv1", "zhiren", "紙人阿一", "藍", 6.0], ["t_mv2", "youhun", "遊魂阿二", "藍", 4.0], ["t_mv3", "zombie", "殭屍阿三", "藍", 8.0],
	["t_mv4", "egui", "餓鬼阿四", "藍", 5.0], ["t_mv5", "xiaogui", "小鬼阿五", "藍", 3.0], ["t_mv6", "shuigui", "水鬼阿六", "藍", 7.0]]
func _setup() -> void:
	D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/outpost.json"))
	MD.reload()
	var S = _S()
	J.test_clock = 1.8e12
	S.erase("mv"); S["cleared"] = {}
	S.res["coins"] = 0.0
	var keep = []
	for gh in S.ghosts: if not str(gh.get("id")).begins_with("t_mv"): keep.append(gh)
	S["ghosts"] = keep
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": t[3], "lv": t[4], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	# [chain] 呢個測試驗舊公式（賣貨／搬貨／離線）：材料庫塞滿、所有台設「全部出售」，生產鏈唔影響數；生產鏈另見 tools/tests/chain_test.gd
	var CM = load("res://game/outpost/mat.gd"); CM.reload()
	S["mat"] = {}
	for mid in CM.all_ids():
		var rk = CM.res_key(str(mid))
		if rk != "": S.res[rk] = 1e9
		else: S.mat[str(mid)] = 1e9
	var rt = {}
	for sid in D.STATIONS: rt[sid] = "sell"
	S["mv"] = {"route": rt}

func _run(sim, secs: float, dt := 0.05) -> Array:
	var evs = []
	var n = int(secs / dt)
	for i in n:
		J.test_clock += dt * 1000.0
		sim.step(dt); evs.append_array(sim.ev); sim.ev.clear()
	return evs

func _sids(ci: int) -> Array: return D.MAPS[ci].stations.duplicate()
func _free(ci: int) -> Array:
	var o = []
	for sid in _sids(ci): if float(_sd(sid).unlock_cost) <= 0.0: o.append(sid)
	return o
func _locked(ci: int) -> Array:
	var o = []
	for sid in _sids(ci): if float(_sd(sid).unlock_cost) > 0.0: o.append(sid)
	return o

func logic(_t) -> void:
	_setup(); var S = _S()
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	sim.plus.off = true   # [play] 呢度驗原公式（玩法線加成：羈絆、脾氣、事件，另見 tools/tests/play_test.gd）
	var A = _free(0)[0]; var gA = str(_sd(A).good); var B = _locked(0)[0]
	_p("資料：%d 張圖、%d 台；第一張圖免費台 %s，第一個要解鎖 %s" % [D.MAPS.size(), D.STATIONS.size(), str(_free(0)), B])
	_p("===== 1. 公式（獨立計 vs mv_data；全部台） =====")
	var fbad = 0; var fn = 0
	for sid in D.STATIONS:
		for lv in [1, 9, 10, 11, 25, 50, 99, 100]:
			fn += 4
			if absf(MD.val(sid, lv, 0) - _val(sid, lv)) > 1e-6 * maxf(1.0, _val(sid, lv)): fbad += 1
			if MD.out(sid, lv) != _out(sid, lv): fbad += 1
			if absf(MD.tm(sid, lv) - _tm(sid, lv)) > 1e-9: fbad += 1
			if MD.cost1(sid, lv) != _c1(sid, lv): fbad += 1
	_chk("全部台 × 8 個等級：單價／產量／時間／升級費（%d 項錯）" % fbad, float(fbad), 0.0)
	_p("  （%d 項逐一比過）" % fn)
	for lv in [1, 10, 25]: _chk("%s Lv%d 單價" % [A, lv], MD.val(A, lv, 0), _val(A, lv))
	var s10 = 0.0
	for i in 10: s10 += _c1(A, 1 + i)
	_chk("%s 升 10 級總費" % A, MD.cost_n(A, 1, 10), s10)
	_chk("Lv10 里程碑（速度 ×2）：單價 = Lv9 × (1.9/1.8) × 1.2（★1）", MD.val(A, 10, 0), MD.val(A, 9, 0) * 1.9 / 1.8 * 1.2)   # [idle]
	_chk("Lv10 里程碑（速度 ×2）：做貨時間 = Lv9 × (1.16/1.18) ÷ 2", MD.tm(A, 10), MD.tm(A, 9) * 1.16 / 1.18 / 2.0)
	_chk("Lv25 里程碑（售價 ×2）：單價 = Lv24 × (3.4/3.3) × 2 × 1.4/1.2", MD.val(A, 25, 0), MD.val(A, 24, 0) * 3.4 / 3.3 * 2.0 * 1.4 / 1.2)
	_p("  縮寫：%s %s %s %s %s %s" % [MD.fmt(999), MD.fmt(12345), MD.fmt(2.5e6), MD.fmt(3.21e9), MD.fmt(7.7e12), MD.fmt(-15000)])
	var fmt_ok = MD.fmt(12345) == "12.3K" and MD.fmt(2.5e6) == "2.5M" and MD.fmt(3.21e9) == "3.2B" and MD.fmt(7.7e12) == "7.7T" and MD.fmt(999) == "999"
	_chk("K/M/B/T 縮寫", 1.0 if fmt_ok else 0.0, 1.0)
	_chk("唔存在嘅 sid：sst() 唔報錯、lv = 0", sim.lv("no_such_sid"), 0.0)
	_chk("唔存在嘅 sid：未解鎖", 1.0 if sim.unlocked("no_such_sid") else 0.0, 0.0)
	_chk("STRINGS 格式位唔同 → 用預設（unlock）", 1.0 if MD.S("unlock", "解鎖 %s", "解鎖 %s").contains("%s") else 0.0, 1.0)

	_p("===== 2. 開局：免費台已解鎖，其他鎖住 =====")
	for sid in _sids(0):
		_chk("%s 解鎖 = %s" % [sid, str(float(_sd(sid).unlock_cost) <= 0.0)], 1.0 if sim.unlocked(sid) else 0.0, 1.0 if float(_sd(sid).unlock_cost) <= 0.0 else 0.0)
	_chk("冇錢解鎖 %s：失敗" % B, 1.0 if sim.unlock(B) else 0.0, 0.0)

	_p("===== 3. 冇員工：撳台面手動做貨 → 收去櫃台 =====")
	_chk("撳台：開始做", 1.0 if sim.tap_station(A) == "make" else 0.0, 1.0)
	var ev = _run(sim, _tm(A, 1) + 0.1)
	_chk("做好：台面件數 = base_out", sim.pile_n(A), float(_out(A, 1)))
	_chk("撳台：收貨", 1.0 if sim.tap_station(A) == "collect" else 0.0, 1.0)
	var man = sim.counter_n(gA)
	_chk("櫃台有貨", float(man), float(_out(A, 1)))

	_p("===== 4. 派員工：做貨→搬貨→櫃台→客人收齊付錢→冥幣入賬（模擬 120 秒） =====")
	sim.assign(A, 0, "t_mv1")
	_chk("鬼 post = mv", 1.0 if J.seq(sim.ghost("t_mv1").post, "mv") else 0.0, 1.0)
	sim.st().served = 30.0
	var c0 = sim.coins()
	ev = _run(sim, 120.0)
	var made = 0; var deliv = 0; var paid = 0.0; var pays = 0; var took = 0; var leaves = 0
	for e in ev:
		match e.k:
			"made": made += int(e.n)
			"deliver": deliv += int(e.n)
			"take": took += 1
			"pay": paid += float(e.amt); pays += 1
			"leave": leaves += 1
	var carry = 0
	for w in sim.workers: carry += int(w.carry)
	_p("  做咗 %d 件、交櫃台 %d、客人攞 %d、付錢 %d 次、等到嬲走 %d、搬緊 %d、櫃台剩 %d" % [made, deliv, took, pays, leaves, carry, sim.counter_n(gA)])
	var exp_made = 120.0 / (_tm(A, 1) + _carry(0, A))
	_p("  搬貨來回 %.2f 秒（路線長 %.0f px）；預計做 %.1f 件" % [_carry(0, A), (_carry(0, A) - 0.6) * 80.0, exp_made])
	_chk("員工做貨數 ≈ 120 ÷ (做貨時間 + 搬貨來回)（±2）", float(made), exp_made, 2.0 / maxf(1.0, exp_made))
	_chk("MD.carry_s = 獨立計", MD.carry_s(0, A), _carry(0, A))
	_chk("貨品守恆：做 = 交 + 搬緊", float(made), float(deliv + carry))
	_chk("貨品守恆：交 + 手做 = 攞 + 櫃台剩", float(deliv + man), float(took + sim.counter_n(gA)))
	_chk("冥幣增加 = Σ 客人付錢", sim.coins() - c0, paid, 1e-9)
	_chk("Σ付錢 = 賣出件數 × 單價(Lv1)", paid, J.num(sim.st().sold.get(gA)) * _val(A, 1), 1e-9)
	_chk("賣出件數 = 客人攞嘅件數 − 未付錢客人手上", J.num(sim.st().sold.get(gA)), float(took - _partial(sim)))
	_chk("客人只要有人做／有貨嘅貨（冇其他貨賣出）", float(sim.st().sold.size()), 1.0)

	_p("===== 5. 升級費用＋里程碑 ×2 =====")
	S.res["coins"] = 1e9
	sim.st().st[A]["made_n"] = 1e9   # [idle] 累計產量門檻另見 tools/tests/idle_test.gd
	var cb = sim.coins(); var lv0 = sim.lv(A)
	sim.upgrade(A, 1)
	_chk("升 1 級：扣 cost1(Lv%d)" % int(lv0), cb - sim.coins(), _c1(A, lv0))
	var n = sim.up_n_for(A, "mile")
	_chk("升到下個里程碑：要升幾級", float(n), 10.0 - sim.lv(A))
	var exp_c = 0.0
	for i in n: exp_c += _c1(A, sim.lv(A) + i)
	cb = sim.coins(); sim.ev.clear(); sim.upgrade(A, n)
	_chk("升到 Lv10 費用", cb - sim.coins(), exp_c)
	var mile_ev = 0.0
	for e in sim.ev: if e.k == "mile": mile_ev = e.x
	_chk("Lv10 出里程碑事件 ×2", mile_ev, 2.0)
	_chk("升 10 掣：升 10 級", float(sim.up_n_for(A, "10")), 10.0)
	S.res["coins"] = 1e20   # [idle] 最高級 200
	sim.upgrade(A, 200)
	_chk("封頂 Lv%d" % MD.max_lv(A), sim.lv(A), float(MD.max_lv(A)))
	_chk("封頂：售價里程碑倍數 2^%d" % _nk(A, sim.lv(A), true), MD.mile_mul(A, sim.lv(A)), pow(2, _nk(A, sim.lv(A), true)))   # [idle]
	_chk("封頂再升：0 級", float(sim.upgrade(A, 1)), 0.0)
	sim.st().st[A].lv = 1.0

	_p("===== 6. 目標（第一張圖逐個做） =====")
	var G = D.MAPS[0].goals
	for i in G.size():
		var g = G[i]; var k = str(g.k); var gn = float(g.n)
		_chk("目前目標 = %d（%s %s %d）" % [i, g.t, k, int(gn)], float(sim.cur_goal()), float(i))
		if g.t == "boss":
			_chk("Boss 未打：未完成", 1.0 if sim.goal_done(i) else 0.0, 0.0)
			_chk("Boss 未打：can_move = false", 1.0 if sim.can_move() else 0.0, 0.0)
			S.cleared["1-3"] = true
		elif not sim.goal_done(i):
			match str(g.t):
				"unlock":
					var pv = IDL.prev_of(0, k)   # [idle] 解鎖鏈：上一個台先到 Lv10
					if pv != "" and sim.lv(pv) < 10.0: sim.st().st[pv].lv = 10.0
					S.res["coins"] = float(_sd(k).unlock_cost); sim.unlock(k)
					_chk("解鎖 %s 用晒 %s" % [k, str(_sd(k).unlock_cost)], sim.coins(), 0.0)
				"level":
					if not sim.unlocked(k): S.res["coins"] = 1e15; sim.unlock(k)
					sim.st().st[k].lv = gn - 1.0; sim.st().st[k]["made_n"] = 1e9   # [idle]
					_chk("%s 差 1 級：未完成" % k, 1.0 if sim.goal_done(i) else 0.0, 0.0)
					S.res["coins"] = _c1(k, gn - 1.0); sim.upgrade(k, 1)
				"sell":
					sim.st().sold[k] = gn - 1.0
					_chk("賣 %d：未完成" % int(gn - 1), 1.0 if sim.goal_done(i) else 0.0, 0.0)
					sim.st().sold[k] = gn
				"hire":
					if not sim.unlocked(k): S.res["coins"] = 1e15; sim.unlock(k)
					var ids = ["t_mv2", "t_mv3", "t_mv4"]
					for j in int(gn): sim.assign(k, j, ids[j])
		_chk("目標 %d 完成" % i, 1.0 if sim.goal_done(i) else 0.0, 1.0)
		if i == G.size() - 1: _chk("未領最後一個：can_move = false", 1.0 if sim.can_move() else 0.0, 0.0)
		S.res["coins"] = 0.0
		sim.claim(i)
		_chk("領獎 +%s" % str(g.reward.coins), sim.coins(), float(g.reward.coins))
		_chk("重複領：唔得", 1.0 if sim.claim(i) else 0.0, 0.0)
	_chk("全部領晒＋Boss：can_move = true", 1.0 if sim.can_move() else 0.0, 1.0)

	_p("===== 7. 鬼互斥 =====")
	var B2 = _sids(0)[1]
	sim.assign(A, 0, "t_mv1")
	sim.assign(B2, 0, "t_mv1")
	_chk("同一隻鬼調去 %s：%s 位清空" % [B2, A], 1.0 if sim.sst(A).workers[0] == null else 0.0, 1.0)
	_chk("%s 位 = t_mv1" % B2, 1.0 if J.seq(sim.sst(B2).workers[0], "t_mv1") else 0.0, 1.0)
	sim.ghost("t_mv5").post = "wood"
	sim.assign("guard", 0, "t_mv5")
	_chk("村子崗位(wood) 嘅鬼調嚟守夜：post = mv", 1.0 if J.seq(sim.ghost("t_mv5").post, "mv") else 0.0, 1.0)
	sim.ghost("t_mv6").post = "tower1"
	_chk("樓裡有鬼出更中嘅鬼：唔准調", 1.0 if sim.assign(B2, 1, "t_mv6") else 0.0, 0.0)
	sim.ghost("t_mv6").post = null
	var GR = Engine.get_main_loop().root.get_node_or_null("Garrison")
	if GR != null and GR.st() != null:
		GR.assign(0, "bun", 1, "t_mv6")
		_chk("分村駐守鬼：post = garrison", 1.0 if J.seq(sim.ghost("t_mv6").post, "garrison") else 0.0, 1.0)
		sim.assign(B2, 1, "t_mv6")
		_chk("調嚟移動村：分村位清空", 1.0 if GR.ms(0).posts.bun[1] == null else 0.0, 1.0)
		_chk("post = mv", 1.0 if J.seq(sim.ghost("t_mv6").post, "mv") else 0.0, 1.0)
		GR.validate()
		_chk("Garrison.validate 唔郁 mv 鬼", 1.0 if J.seq(sim.ghost("t_mv6").post, "mv") else 0.0, 1.0)
	sim.assign(B2, 2, null)
	var spare = null
	for gh in S.ghosts: if str(gh.id).begins_with("t_mv") and gh.post == null: spare = gh
	if spare != null:
		spare.post = "mv"
		sim.validate()
		_chk("validate：冇格嘅 mv 鬼放返自由", 1.0 if spare.post == null else 0.0, 1.0)
	_chk("validate：有格嘅照留", 1.0 if J.seq(sim.ghost("t_mv1").post, "mv") else 0.0, 1.0)

	_p("===== 8. 圍欄：守夜打孤魂 → 冥幣 =====")
	sim.foes.clear(); sim.custs.clear(); sim.sync()
	sim.spawn_foe(); var f = sim.foes[0]
	f.pos = Vector2(200, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0
	S.res["coins"] = 0.0
	ev = _run(sim, 12.0)
	var kills = 0; var hits = 0; var foe_c = 0.0; var pay_c = 0.0
	for e in ev:
		if e.k == "kill": kills += 1; foe_c += float(e.coins)
		if e.k == "hit": hits += 1
		if e.k == "pay": pay_c += float(e.amt)
	_chk("守夜打中（>0 下）", 1.0 if hits > 0 else 0.0, 1.0)
	_chk("打走孤魂 ≥ 1", 1.0 if kills >= 1 else 0.0, 1.0)
	_chk("每隻孤魂冥幣 = 10 × (ci+1)", foe_c / maxf(1, kills), 10.0)
	_chk("冥幣 = 打孤魂 + 客人付錢", sim.coins(), foe_c + pay_c, 1e-9)

	_p("===== 9. 拔營 =====")
	var rec = {}
	for sid in _sids(0): if sim.unlocked(sid): rec[sid] = sim.lv(sid)
	_chk("move_next 成功", 1.0 if sim.move_next() else 0.0, 1.0)
	_chk("ci = 1", float(sim.ci()), 1.0)
	var dbad = 0
	for sid in _sids(0):
		var has = sim.st().done["0"].has(sid)
		if has != rec.has(sid) or (has and J.num(sim.st().done["0"][sid]) != rec[sid]): dbad += 1
	_chk("done[0] = 每個已解鎖台嘅等級（%d 台）" % rec.size(), float(dbad), 0.0)
	_chk("鬼放返自由（t_mv1）", 1.0 if sim.ghost("t_mv1").post == null else 0.0, 1.0)
	_chk("鬼放返自由（守夜 t_mv5）", 1.0 if sim.ghost("t_mv5").post == null else 0.0, 1.0)
	_chk("新圖由零開始：目標", float(sim.goals_claimed_n()), 0.0)
	var A1 = _free(1)[0]; var B1 = _locked(1)[0]
	_chk("新圖：%s Lv1 已解鎖" % A1, (sim.lv(A1) if sim.unlocked(A1) else -1.0), 1.0)
	_chk("新圖：%s 未解鎖" % B1, 1.0 if sim.unlocked(B1) else 0.0, 0.0)
	var OLD = A   # [chain] 隨村台（CARRY）會跟住走，揀第一個唔係隨村台嘅舊台嚟驗
	for sid in _sids(0): if not MD.is_carry(sid): OLD = sid; break
	_chk("新圖：冇舊台（%s）" % OLD, 1.0 if sim.st().st.has(OLD) else 0.0, 0.0)
	_chk("新圖：隨村台 %s 跟住走" % A, 1.0 if (not MD.is_carry(A)) or sim.st().st.has(A) else 0.0, 1.0)
	_chk("新圖未做目標：can_move = false", 1.0 if sim.can_move() else 0.0, 0.0)

	_p("===== 10. 離線（最多 8 小時，按有員工嘅台） =====")
	sim.assign(A1, 0, "t_mv1"); sim.assign(A1, 1, "t_mv2")
	sim.st().st[A1].lv = 12.0
	var pb1 = IDL.prev_of(1, B1)   # [idle] 解鎖鏈
	if pb1 != "": sim.st().st[pb1].lv = maxf(10.0, sim.lv(pb1))
	S.res["coins"] = float(_sd(B1).unlock_cost); sim.unlock(B1); sim.assign(B1, 0, "t_mv3"); sim.st().st[B1].lv = 26.0
	var ve = 2.0 * _out(A1, 12) * _val(A1, 12) / (_tm(A1, 12) + _carry(1, A1)) + 1.0 * _out(B1, 26) * _val(B1, 26) / (_tm(B1, 26) + _carry(1, B1))
	_chk("離線每秒", sim.offline_rate(), ve)
	S.res["coins"] = 0.0
	var r = sim.offline_gain(3600000.0)
	_chk("離線 1 小時", r.coins, floor(ve * 3600.0))
	S.res["coins"] = 0.0
	r = sim.offline_gain(10.0 * 3600000.0)
	_chk("離線 10 小時 → 只計 8 小時", r.coins, floor(ve * 8.0 * 3600.0))
	_chk("capped = true", 1.0 if r.capped else 0.0, 1.0)
	_chk("冥幣入賬 = 收益卡數", sim.coins(), r.coins)
	sim.st().last = J.now() - 2.0 * 3600000.0; S.res["coins"] = 0.0
	r = sim.check_away()
	_chk("返嚟自動計（2 小時）", r.coins, floor(ve * 7200.0))
	_chk("只計有員工嘅台", float(r.rows.size()), 2.0)
	_p("===== 11. 加速／收益掣（免費、冷卻） =====")
	_chk("收益掣：開", 1.0 if sim.use_boost("inc") else 0.0, 1.0)
	_chk("收益倍數 ×2", sim.inc_mul(), 2.0)
	_chk("冷卻中再撳：唔得", 1.0 if sim.use_boost("inc") else 0.0, 0.0)
	J.test_clock += 301000.0
	_chk("5 分鐘後：收益 ×1", sim.inc_mul(), 1.0)
	J.test_clock += 1200000.0
	_chk("冷卻完：可以再開", 1.0 if sim.use_boost("inc") else 0.0, 1.0)
	sim.use_boost("spd")
	_chk("加速掣：開 → 速度 ×2", sim.spd_mul(), 2.0)
	_p("===== 12. 客人等太耐會走（唔會塞死條隊） =====")
	sim.custs.clear(); S.mv.counter = {}
	for sid in sim.st().st:
		for j in 3: sim.assign(sid, j, null)
	sim.reset_live(); sim.sync()
	sim.spawn_cust(); var cc = sim.custs[0]; cc.pos = sim.queue_pos(0)
	var lv_ = 0
	ev = _run(sim, 20.0)
	for e in ev: if e.k == "leave": lv_ += 1
	_chk("冇貨：15 秒後走（leave ≥ 1）", 1.0 if lv_ >= 1 else 0.0, 1.0)
	_p("驗算 %d 行，唔對 %d 行 → %s" % [rows, bad, "全部一致" if bad == 0 else "有錯"])
	J.test_clock = -1.0

func _partial(sim) -> int:   # 排緊隊／收緊貨但未付錢嘅客人手上件數
	var n = 0
	for c in sim.custs:
		if c.st != "out":
			for g in c.got: n += int(c.got[g])
	return n

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
func _wait(s: float) -> void:
	await Engine.get_main_loop().create_timer(s).timeout
func _goto_map(sim, c: int, nun: int, lvs: Array) -> void:   # 測試用：直接跳去第 c 張圖（頭 nun 個台解鎖）
	var S = _S()
	for sid in sim.st().st:
		for j in 3: sim.assign(sid, j, null)
	for j in 3: sim.assign("guard", j, null)
	S.mv.ci = float(c); S.mv.st = {}; S.mv.goals_done = []; S.mv.sold = {}; S.mv.counter = {}; S.mv.pile = {}
	sim.reset_live(); sim.st()
	var ids = _sids(c)
	for i in ids.size():
		if i < nun: S.mv.st[ids[i]].unlocked = true; S.mv.st[ids[i]].lv = float(lvs[i % lvs.size()])
	var gi = 0
	for i in mini(nun, ids.size()):
		if gi < TG.size() - 1: sim.assign(ids[i], 0, TG[gi][0]); gi += 1
	sim.assign("guard", 0, TG[TG.size() - 1][0])
	sc._after_move(true)

func _cam(y: float) -> void:   # 鏡頭去世界 y（畫面頂）
	sc.cam = y; sc.cam_tgt = null; sc.cam_v = 0.0; sc._clamp_cam(true)
func _cam_bottom() -> void: _cam(sc.cam_max())
func _cam_top() -> void: _cam(sc.cam_min())

func shots(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_setup(); var S = _S()
	J.test_clock = -1.0
	var m = tt.main()
	sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvScene"
	var vil = m.get("village")
	m.add_child(sc)
	if vil != null: m.move_child(sc, vil.get_index() + 1)   # 頂欄／底欄蓋喺上面
	sc.setup(m)
	var sim = sc.sim
	sim.st()
	var ids = _sids(0); var A = ids[0]; var A2 = ids[1]; var A3 = ids[2]
	S.mv.st[A].lv = 9.0; S.mv.st[A2].lv = 4.0
	S.res["coins"] = 2600.0
	sim.assign(A, 0, "t_mv1"); sim.assign(A, 1, "t_mv4"); sim.assign(A2, 0, "t_mv2")
	sim.assign("guard", 0, "t_mv3"); sim.assign("guard", 1, "t_mv6")
	S.mv.counter[str(_sd(A).good)] = 4.0; S.mv.counter[str(_sd(A2).good)] = 3.0; S.mv.served = 40.0
	sc.on_show()
	for i in 3: sim.spawn_cust()
	for i in 3: sim.spawn_foe()
	sim.tap_station(A3)   # 冇員工：手做緊（播動態）
	await _wait(8.0)
	var ok_carry = false
	for i in 50:
		for w in sim.workers: if w.st == "go" and w.carry > 0 and w.s > 60.0: ok_carry = true
		if ok_carry: break
		await _wait(0.1)
	await _shot("01_map0_entrance_carry")
	# 拖動（模擬手指）：由下拖上，有慣性
	var c0 = sc.cam
	_drag(sc, Vector2(200, 300), Vector2(200, 600))
	_chk("手指向下拖 300px：鏡頭向上 300（cam −300）", sc.cam, c0 - 300.0, 0.002)
	var c1 = sc.cam
	await _wait(0.8)
	_chk("放手後有慣性：鏡頭繼續向上滑（再郁 > 20px）", 1.0 if sc.cam < c1 - 20.0 else 0.0, 1.0)
	await _shot("02_map0_drag_mid")
	_cam_top(); sim.foes.clear()
	for i in 3:
		sim.spawn_foe(); var f = sim.foes[-1]
		f.pos = Vector2(110 + i * 90, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0
	sim.tap_station(A3)
	await _wait(1.2)
	await _shot("03_map0_top_fence_fight")
	# 撳台 → 鏡頭移過去，升級條唔遮住
	sc.open_sheet(A); await _wait(0.9)
	var sy = sc.w2s(sim.st_pos(A)).y
	_p("升級條：台底畫面 y = %.0f、升級條頂 = %.0f → %s" % [sy + 56.0, sc.sheet.position.y, "冇遮" if sy + 56.0 <= sc.sheet.position.y + 4.0 else "<<< 遮住"])
	await _shot("04_upgrade_sheet_focus")
	S.res["coins"] = MD.cost_n(A, sim.lv(A), sim.up_n_for(A, "mile")) + 100.0
	sc._do_up(A, "mile"); await _wait(0.45)
	await _shot("05_milestone")
	sc.close_sheet()
	sc._open_picker(A2, 1); await _wait(0.4)
	await _shot("06_picker")
	sc._close_picker()
	var gi = sim.cur_goal(); var g = D.MAPS[0].goals[gi]
	if g.t == "level": S.mv.st[str(g.k)].lv = float(g.n)
	elif g.t == "sell": S.mv.sold[str(g.k)] = float(g.n)
	await _wait(0.6)
	sim.claim(gi); await _wait(0.5)
	await _shot("07_goal_claim")
	# 全圖開晒、全部有人做：兩張全景（下半、上半），睇晒 5 個台嘅動態
	_goto_map(sim, 0, 5, [12, 26, 9, 51, 3])
	for i in 3: sim.spawn_cust()
	await _wait(5.0); _cam_bottom(); await _wait(0.6)
	await _shot("08_map0_all_bottom")
	_cam(sim.st_pos(ids[3]).y - 200.0); await _wait(0.6)
	await _shot("09_map0_all_mid")
	_cam_top(); await _wait(0.6)
	await _shot("10_map0_all_top")
	# 其他 5 張圖：每張兩張全景（全部開晒、有人做）
	for c in range(1, 6):
		var n = D.MAPS[c].stations.size()
		_goto_map(sim, c, n, [5, 14, 26, 11, 40, 2])
		for i in 3: sim.spawn_cust()
		await _wait(4.0); _cam_bottom(); await _wait(0.5)
		await _shot("%02d_map%d_bottom" % [9 + c * 2, c])
		_cam(sim.st_pos(_sids(c)[n - 2]).y - 220.0); await _wait(0.5)
		await _shot("%02d_map%d_top" % [10 + c * 2, c])
	# 拔營（第一張圖做齊）
	_goto_map(sim, 0, 5, [12, 26, 9, 51, 3])
	S.cleared["1-3"] = true; S.res["coins"] = 1e9
	var G = D.MAPS[0].goals
	for i in G.size():
		var gg = G[i]
		if gg.t == "level": S.mv.st[str(gg.k)].lv = maxf(S.mv.st[str(gg.k)].lv, float(gg.n))
		elif gg.t == "sell": S.mv.sold[str(gg.k)] = float(gg.n)
		elif gg.t == "hire":
			for j in int(gg.n): sim.assign(str(gg.k), j, TG[j + 3][0])
	for i in G.size(): sim.claim(sim.cur_goal())
	sc.cam_home(); await _wait(2.5)
	await _shot("22_can_move")
	sc.move_next()
	await _wait(0.7); await _shot("23_move_fold")
	await _wait(1.6); await _shot("24_move_walk")
	await _wait(2.4); await _shot("25_move_arrive")
	await _wait(3.5); await _shot("26_new_map")
	var A1 = _sids(1)[0]
	sim.assign(A1, 0, "t_mv5"); sim.st().st[A1].lv = 15.0
	sc.on_hide(); S.mv.last = J.now() - 3.0 * 3600000.0
	sc.on_show(); await _wait(0.8)
	await _shot("27_offline_card")
	sc.tap(Vector2(195, 500)); await _wait(0.4)
	sim.use_boost("inc"); sim.use_boost("spd"); await _wait(1.0)
	await _shot("28_boosts")
	sim.assign(A1, 0, null); sim.st().pile[A1] = 3.0
	await _wait(0.5)
	await _shot("29_manual_pile")
	await _fx_sheet(sim)
	sc.on_hide(); sc.queue_free()
	_p("shots done")

# 33 個台嘅生產動態：每個台鏡頭對正、強制「做緊」，影兩個時間點，拼成一張對照表
func _fx_sheet(sim) -> void:
	var TW = 190; var TH = 230; var cols = 6
	var all = []
	for c in D.MAPS.size():
		for sid in _sids(c): all.append([c, sid])
	var rows = int(ceil(all.size() / float(cols / 2)))
	var atlas = Image.create(TW * cols, TH * rows, false, Image.FORMAT_RGBA8)
	var cur = -1
	for i in all.size():
		var c = all[i][0]; var sid = all[i][1]
		if c != cur:
			_goto_map(sim, c, 99, [12]); cur = c
			sim.custs.clear(); sim.foes.clear()
			for sd in _sids(c):
				for j in 3: sim.assign(sd, j, null)
			sim.paused = true
		var p = sim.st_pos(sid)
		_cam(p.y - 420.0)
		for sd in _sids(c): sim.mk[sd] = 0.3
		for k in 2:
			await _wait(0.35 + k * 0.4)
			await RenderingServer.frame_post_draw
			var img = Engine.get_main_loop().root.get_viewport().get_texture().get_image()
			img.convert(Image.FORMAT_RGBA8)
			var sp = sc.w2s(p)
			var rx = clampi(int(sp.x - TW / 2.0), 0, img.get_width() - TW); var ry = clampi(int(sp.y - 170), 0, img.get_height() - TH)
			var tile = i * 2 + k
			atlas.blit_rect(img, Rect2i(rx, ry, TW, TH), Vector2i((tile % cols) * TW, (tile / cols) * TH))
	sim.paused = false
	atlas.save_png(OUT + "30_fx_all_stations.png"); _p("SHOT " + OUT + "30_fx_all_stations.png（%d 台 × 2 格）" % all.size())

func _drag(s0, a: Vector2, b: Vector2) -> void:
	var e = InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = true; e.position = a
	s0._stage_input(e)
	for i in 6:
		s0.t += 0.016
		var mm = InputEventMouseMotion.new(); mm.position = a.lerp(b, (i + 1) / 6.0); mm.button_mask = MOUSE_BUTTON_MASK_LEFT
		s0._stage_input(mm)
	var e2 = InputEventMouseButton.new(); e2.button_index = MOUSE_BUTTON_LEFT; e2.pressed = false; e2.position = b
	s0._stage_input(e2)

# 效能：場景自己嘅成本（模擬每格、畫每格），同村子畫面對比
func perf(tt) -> void:
	_setup(); D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/outpost.json")); var S = _S(); J.test_clock = -1.0
	var m = tt.main()
	var t0 = Time.get_ticks_usec(); var f0 = Engine.get_frames_drawn()
	await _wait(3.0)
	var base_ms = 3000.0 / maxf(1, Engine.get_frames_drawn() - f0)
	_p("perf 村子畫面（未開移動村）：每格 %.2f ms" % base_ms)
	sc = load("res://game/outpost/mv_scene.gd").new(); m.add_child(sc); m.move_child(sc, m.get("village").get_index() + 1); sc.setup(m)
	var sim = sc.sim; sim.st()
	S.res["coins"] = 1e6
	var i = 0
	for sid in _sids(0):
		sim.st().st[sid].lv = 10.0   # [idle] 解鎖鏈
		sim.unlock(sid); sim.assign(sid, 0, TG[i][0]); i += 1
	sim.assign("guard", 0, "t_mv6")
	sc.on_show()
	for j in 4: sim.spawn_foe()
	await _wait(4.0)
	f0 = Engine.get_frames_drawn()
	await _wait(3.0)
	var full_ms = 3000.0 / maxf(1, Engine.get_frames_drawn() - f0)
	_p("perf 移動村滿場（客 %d、員工 %d、孤魂 %d、守夜 %d、粒子 %d）：每格 %.2f ms" % [sim.custs.size(), sim.workers.size(), sim.foes.size(), sim.guards.size(), sc.parts.size(), full_ms])
	var a = Time.get_ticks_usec()
	for j in 300: sim.step(0.016); sim.ev.clear()
	_p("perf 模擬 step：每格 %.3f ms" % ((Time.get_ticks_usec() - a) / 300000.0))
	sc.stage.visible = false
	f0 = Engine.get_frames_drawn(); await _wait(2.0)
	_p("perf 唔畫 stage：每格 %.2f ms" % (2000.0 / maxf(1, Engine.get_frames_drawn() - f0)))
	sc.stage.visible = true
	sc.on_hide(); sc.queue_free()
