# 移動村 headless 驗證＋截圖（場景未掛入主畫面都測得到）
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://game/outpost/mv_test.gd","logic"],["gdrun","res://game/outpost/mv_test.gd","shots"],["quit"]]
# 驗算全部用獨立公式（唔叫 mv_data 嘅公式）同遊戲數值逐項對。
extends RefCounted

const SIM = preload("res://game/outpost/mv_sim.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const OUT := "/tmp/mv/shots/"
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
func _val(sid, lv) -> float: return float(D.GOODS[_sd(sid).good].price) * (1.0 + 0.1 * (lv - 1)) * pow(2, _nm(sid, lv))
func _out(sid, lv) -> int: return int(_sd(sid).base_out) + int((lv - 1) / 10)
func _tm(sid, lv) -> float: return float(_sd(sid).base_time) / (1.0 + 0.02 * (lv - 1))
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

func _run(sim, secs: float, dt := 0.05) -> Array:
	var evs = []
	var n = int(secs / dt)
	for i in n:
		J.test_clock += dt * 1000.0
		sim.step(dt); evs.append_array(sim.ev); sim.ev.clear()
	return evs

func logic(_t) -> void:
	_setup(); var S = _S()
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	_p("===== 1. 公式（獨立計 vs mv_data） =====")
	for sid in ["s_steamer", "s_tailor", "s_coffin"]:
		for lv in [1, 9, 10, 11, 25, 50, 99, 100]:
			_chk("%s Lv%d 單價" % [sid, lv], MD.val(sid, lv, 0), _val(sid, lv))
		_chk("%s Lv1 產量" % sid, MD.out(sid, 1), 1.0); _chk("%s Lv21 產量" % sid, MD.out(sid, 21), _out(sid, 21))
		_chk("%s Lv50 時間" % sid, MD.tm(sid, 50), _tm(sid, 50))
		_chk("%s 升 Lv1→2 費用" % sid, MD.cost1(sid, 1), _c1(sid, 1))
		var s10 = 0.0
		for i in 10: s10 += _c1(sid, 1 + i)
		_chk("%s 升 10 級總費" % sid, MD.cost_n(sid, 1, 10), s10)
	_chk("Lv10 里程碑：單價 = Lv9 × (1.9/1.8) × 2", MD.val("s_steamer", 10, 0), MD.val("s_steamer", 9, 0) * 1.9 / 1.8 * 2.0)
	_p("  縮寫：%s %s %s %s %s %s" % [MD.fmt(999), MD.fmt(12345), MD.fmt(2.5e6), MD.fmt(3.21e9), MD.fmt(7.7e12), MD.fmt(-15000)])
	var fmt_ok = MD.fmt(12345) == "12.3K" and MD.fmt(2.5e6) == "2.5M" and MD.fmt(3.21e9) == "3.2B" and MD.fmt(7.7e12) == "7.7T" and MD.fmt(999) == "999"
	_chk("K/M/B/T 縮寫", 1.0 if fmt_ok else 0.0, 1.0)

	_p("===== 2. 開局：第一台免費解鎖，其他鎖住 =====")
	_chk("s_steamer 已解鎖", 1.0 if sim.unlocked("s_steamer") else 0.0, 1.0)
	_chk("s_tailor 未解鎖", 1.0 if sim.unlocked("s_tailor") else 0.0, 0.0)
	_chk("冇錢解鎖 s_tailor：失敗", 1.0 if sim.unlock("s_tailor") else 0.0, 0.0)

	_p("===== 3. 冇員工：撳台面手動做貨 → 收去櫃台 → 客人付錢 =====")
	_chk("撳台：開始做", 1.0 if sim.tap_station("s_steamer") == "make" else 0.0, 1.0)
	var ev = _run(sim, _tm("s_steamer", 1) + 0.1)
	_chk("做好：台面 1 件", sim.pile_n("s_steamer"), 1.0)
	_chk("撳台：收貨", 1.0 if sim.tap_station("s_steamer") == "collect" else 0.0, 1.0)
	_chk("櫃台壽包 1", sim.counter_n("g_bun"), 1.0)

	_p("===== 4. 派員工：做貨→搬貨→櫃台→客人收齊付錢→冥幣入賬（模擬 120 秒） =====")
	sim.assign("s_steamer", 0, "t_mv1")
	_chk("鬼 post = mv", 1.0 if J.seq(sim.ghost("t_mv1").post, "mv") else 0.0, 1.0)
	sim.st().served = 30.0   # 客人每次要多啲
	var c0 = sim.coins()
	ev = _run(sim, 120.0)
	var made = 0; var deliv = 0; var paid = 0.0; var pays = 0; var took = 0; var pay_bad = 0
	for e in ev:
		match e.k:
			"made": made += int(e.n)
			"deliver": deliv += int(e.n)
			"take": took += 1
			"pay": paid += float(e.amt); pays += 1
	var carry = 0
	for w in sim.workers: carry += int(w.carry)
	_p("  做咗 %d 件、交櫃台 %d、客人攞 %d、付錢 %d 次、搬緊 %d、櫃台剩 %d" % [made, deliv, took, pays, carry, sim.counter_n("g_bun")])
	_chk("員工做貨數 ≈ 120 ÷ (時間＋搬貨)（>0）", 1.0 if made >= 10 else 0.0, 1.0)
	_chk("貨品守恆：做 = 交 + 搬緊", float(made), float(deliv + carry))
	_chk("貨品守恆：交+手做 1 = 攞 + 櫃台剩", float(deliv + 1), float(took + sim.counter_n("g_bun")))
	_chk("冥幣增加 = Σ 客人付錢", sim.coins() - c0, paid, 1e-9)
	_chk("Σ付錢 = 賣出件數 × 單價(Lv1)", paid, J.num(sim.st().sold.get("g_bun")) * _val("s_steamer", 1), 1e-9)
	_chk("賣出件數 = 客人攞嘅件數（收齊先計）", J.num(sim.st().sold.get("g_bun")), float(took - _partial(sim)))
	_chk("付錢次數 > 0", 1.0 if pays > 0 else 0.0, 1.0)

	_p("===== 5. 升級費用＋里程碑 ×2 =====")
	S.res["coins"] = 100000.0
	var cb = sim.coins(); var lv0 = sim.lv("s_steamer")
	sim.upgrade("s_steamer", 1)
	_chk("升 1 級：扣 cost1(Lv%d)" % int(lv0), cb - sim.coins(), _c1("s_steamer", lv0))
	var n = sim.up_n_for("s_steamer", "mile")
	_chk("升到下個里程碑：要升幾級", float(n), 10.0 - sim.lv("s_steamer"))
	var exp_c = 0.0
	for i in n: exp_c += _c1("s_steamer", sim.lv("s_steamer") + i)
	cb = sim.coins(); sim.ev.clear(); sim.upgrade("s_steamer", n)
	_chk("升到 Lv10 費用", cb - sim.coins(), exp_c)
	var mile_ev = 0.0
	for e in sim.ev: if e.k == "mile": mile_ev = e.x
	_chk("Lv10 出里程碑事件 ×2", mile_ev, 2.0)
	_chk("Lv10 單價（×2 收益）", MD.val("s_steamer", 10, 0), _val("s_steamer", 10))
	_chk("升 10 掣：升 10 級", float(sim.up_n_for("s_steamer", "10")), 10.0)
	S.res["coins"] = 1e12
	sim.upgrade("s_steamer", 200)
	_chk("封頂 Lv100", sim.lv("s_steamer"), 100.0)
	_chk("Lv100 里程碑 5 個 → ×32", MD.mile_mul("s_steamer", 100), 32.0)
	_chk("封頂再升：0 級", float(sim.upgrade("s_steamer", 1)), 0.0)
	S.res["coins"] = 0.0
	sim.st().st["s_steamer"].lv = 10.0

	_p("===== 6. 目標 =====")
	_chk("目標 0（hire）完成", 1.0 if sim.goal_done(0) else 0.0, 1.0)
	S.res["coins"] = 0.0
	sim.claim(0)
	_chk("領獎 +50", sim.coins(), 50.0)
	_chk("重複領：唔得", 1.0 if sim.claim(0) else 0.0, 0.0)
	_chk("目前目標 = 1（解鎖裁縫）", float(sim.cur_goal()), 1.0)
	S.res["coins"] = 120.0
	_chk("解鎖裁縫（120）", 1.0 if sim.unlock("s_tailor") else 0.0, 1.0)
	_chk("解鎖後冥幣 0", sim.coins(), 0.0)
	sim.claim(1); sim.claim(2)
	_chk("目標 2（蒸籠 Lv10）已領", 1.0 if sim.goal_claimed(2) else 0.0, 1.0)
	sim.st().sold["g_suit"] = 19.0
	_chk("賣 19 套：目標 3 未完成", 1.0 if sim.goal_done(3) else 0.0, 0.0)
	sim.st().sold["g_suit"] = 20.0
	_chk("賣 20 套：完成", 1.0 if sim.goal_done(3) else 0.0, 1.0)
	sim.claim(3); S.res["coins"] = 900.0; sim.unlock("s_soup"); sim.claim(4)
	_chk("Boss 未打：目標 5 未完成", 1.0 if sim.goal_done(5) else 0.0, 0.0)
	_chk("Boss 未打：can_move = false", 1.0 if sim.can_move() else 0.0, 0.0)
	S.cleared["1-3"] = true
	_chk("打咗 1-3：Boss 目標完成", 1.0 if sim.goal_done(5) else 0.0, 1.0)
	_chk("未領 Boss 獎：can_move = false", 1.0 if sim.can_move() else 0.0, 0.0)
	sim.claim(5)
	_chk("全部領晒＋Boss：can_move = true", 1.0 if sim.can_move() else 0.0, 1.0)

	_p("===== 7. 鬼互斥 =====")
	sim.assign("s_tailor", 0, "t_mv1")
	_chk("同一隻鬼調去裁縫：蒸籠位清空", 1.0 if sim.sst("s_steamer").workers[0] == null else 0.0, 1.0)
	_chk("裁縫位 = t_mv1", 1.0 if J.seq(sim.sst("s_tailor").workers[0], "t_mv1") else 0.0, 1.0)
	sim.ghost("t_mv2").post = "wood"
	sim.assign("guard", 0, "t_mv2")
	_chk("村子崗位(wood) 嘅鬼調嚟守夜：post = mv", 1.0 if J.seq(sim.ghost("t_mv2").post, "mv") else 0.0, 1.0)
	sim.ghost("t_mv5").post = "tower1"
	_chk("樓裡有鬼出更中嘅鬼：唔准調", 1.0 if sim.assign("s_tailor", 1, "t_mv5") else 0.0, 0.0)
	sim.ghost("t_mv5").post = null
	var GR = Engine.get_main_loop().root.get_node_or_null("Garrison")
	if GR != null and GR.st() != null:
		S.cleared["1-3"] = true
		GR.assign(0, "bun", 1, "t_mv6")
		_chk("分村駐守鬼：post = garrison", 1.0 if J.seq(sim.ghost("t_mv6").post, "garrison") else 0.0, 1.0)
		sim.assign("s_tailor", 1, "t_mv6")
		_chk("調嚟移動村：分村位清空", 1.0 if GR.ms(0).posts.bun[1] == null else 0.0, 1.0)
		_chk("post = mv", 1.0 if J.seq(sim.ghost("t_mv6").post, "mv") else 0.0, 1.0)
		GR.validate()
		_chk("Garrison.validate 唔郁 mv 鬼", 1.0 if J.seq(sim.ghost("t_mv6").post, "mv") else 0.0, 1.0)
	sim.ghost("t_mv3").post = "mv"   # 殘留：post=mv 但冇格
	sim.validate()
	_chk("validate：冇格嘅 mv 鬼放返自由", 1.0 if sim.ghost("t_mv3").post == null else 0.0, 1.0)
	_chk("validate：有格嘅照留", 1.0 if J.seq(sim.ghost("t_mv1").post, "mv") else 0.0, 1.0)

	_p("===== 8. 圍欄：守夜打孤魂 → 冥幣 =====")
	sim.foes.clear(); sim.sync()
	sim.spawn_foe(); var f = sim.foes[0]
	f.pos = Vector2(200, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0
	S.res["coins"] = 0.0
	ev = _run(sim, 12.0)
	var kills = 0; var hits = 0
	for e in ev:
		if e.k == "kill" and e.coins == MD.foe_coin(0): kills += 1
		if e.k == "hit": hits += 1
	_chk("守夜打中（>0 下）", 1.0 if hits > 0 else 0.0, 1.0)
	_chk("打走孤魂 ≥ 1", 1.0 if kills >= 1 else 0.0, 1.0)
	var foe_c = 0.0; var pay_c = 0.0
	for e in ev:
		if e.k == "kill": foe_c += float(e.coins)
		if e.k == "pay": pay_c += float(e.amt)
	_chk("冥幣 = 打孤魂 + 客人付錢", sim.coins(), foe_c + pay_c, 1e-9)
	_chk("孤魂血 ci0 = 40", MD.foe_hp(0), 40.0)
	_chk("守夜傷害(鬼 Lv4) = 18/秒", MD.guard_dps(4.0), 18.0)

	_p("===== 9. 拔營 =====")
	var lv_t = sim.lv("s_tailor"); var lv_s = sim.lv("s_steamer")
	_chk("move_next 成功", 1.0 if sim.move_next() else 0.0, 1.0)
	_chk("ci = 1", float(sim.ci()), 1.0)
	_chk("done[0].s_steamer = %d" % int(lv_s), J.num(sim.st().done["0"].s_steamer), lv_s)
	_chk("done[0].s_tailor", J.num(sim.st().done["0"].s_tailor), lv_t)
	_chk("done[0] 冇未解鎖嘅台", 1.0 if sim.st().done["0"].has("s_coffin") else 0.0, 0.0)
	_chk("鬼放返自由（t_mv1）", 1.0 if sim.ghost("t_mv1").post == null else 0.0, 1.0)
	_chk("鬼放返自由（守夜 t_mv2）", 1.0 if sim.ghost("t_mv2").post == null else 0.0, 1.0)
	_chk("新圖由零開始：目標", float(sim.goals_claimed_n()), 0.0)
	_chk("新圖：s_pants Lv1 已解鎖", (sim.lv("s_pants") if sim.unlocked("s_pants") else -1.0), 1.0)
	_chk("新圖：s_phone 未解鎖", 1.0 if sim.unlocked("s_phone") else 0.0, 0.0)
	_chk("新圖：冇舊台", 1.0 if sim.st().st.has("s_steamer") else 0.0, 0.0)
	_chk("最後一張圖之後：can_move = false（未做目標）", 1.0 if sim.can_move() else 0.0, 0.0)

	_p("===== 10. 離線（最多 8 小時，按有員工嘅台） =====")
	sim.assign("s_pants", 0, "t_mv1"); sim.assign("s_pants", 1, "t_mv2")
	sim.st().st["s_pants"].lv = 12.0
	S.res["coins"] = 10000.0; sim.unlock("s_phone"); sim.assign("s_phone", 0, "t_mv3"); sim.st().st["s_phone"].lv = 26.0
	var ve = 2.0 * _out("s_pants", 12) * _val("s_pants", 12) / (_tm("s_pants", 12) + 3.0) + 1.0 * _out("s_phone", 26) * _val("s_phone", 26) / (_tm("s_phone", 26) + 3.0)
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
	_chk("冇員工嘅台唔計（s_garage 未解鎖）", float(r.rows.size()), 2.0)
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
func shots(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_setup(); var S = _S()
	J.test_clock = -1.0
	S.res["coins"] = 2600.0
	var m = tt.main()
	sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvScene"
	var vil = m.get("village")
	m.add_child(sc)
	if vil != null: m.move_child(sc, vil.get_index() + 1)   # 頂欄／底欄蓋喺上面
	sc.setup(m)
	var sim = sc.sim
	sim.st()
	S.mv.st["s_steamer"].lv = 9.0
	S.mv.goals_done = [0.0]
	S.res["coins"] = 2600.0
	sim.unlock("s_tailor"); S.mv.st["s_tailor"].lv = 4.0
	sim.assign("s_steamer", 0, "t_mv1"); sim.assign("s_steamer", 1, "t_mv4")
	sim.assign("guard", 0, "t_mv3"); sim.assign("guard", 1, "t_mv6")
	S.mv.counter["g_bun"] = 4.0; S.mv.served = 40.0
	sc.on_show()
	for i in 3: sim.spawn_cust()
	for i in 3: sim.spawn_foe()
	var t0 = Time.get_ticks_usec()
	await _wait(9.0)
	# 效能：量 60 格
	var t1 = Time.get_ticks_usec(); var fr = Engine.get_frames_drawn()
	await _wait(2.0)
	_p("perf：%.1f fps 相當（每格 %.2f ms）；客 %d、員工 %d、孤魂 %d、粒子 %d" % [(Engine.get_frames_drawn() - fr) / 2.0, 2000.0 / maxf(1, Engine.get_frames_drawn() - fr), sim.custs.size(), sim.workers.size(), sim.foes.size(), sc.parts.size()])
	var ok_carry = false
	for i in 40:
		for w in sim.workers: if w.st == "go" and w.carry > 0 and w.pos.y < sim.st_pos(w.sid).y - 60: ok_carry = true
		if ok_carry: break
		await _wait(0.1)
	await _shot("01_overview_carry")
	# 圍欄打鬼
	sim.foes.clear()
	for i in 3:
		sim.spawn_foe(); var f = sim.foes[-1]
		f.pos = Vector2(150 + i * 80, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0
	await _wait(1.1)
	await _shot("02_fence_fight")
	# 升級條
	sc.open_sheet("s_steamer"); await _wait(0.5)
	await _shot("03_upgrade_sheet")
	# 里程碑
	S.res["coins"] = 5000.0
	sc._do_up("s_steamer", "mile"); await _wait(0.45)
	await _shot("04_milestone")
	sc.close_sheet()
	# 揀鬼
	sc._open_picker("s_tailor", 0); await _wait(0.4)
	await _shot("05_picker")
	sc._close_picker()
	# 目標完成（解鎖裁縫已做 → 目標 1 可領）
	await _wait(0.6)
	await _shot("06_goal_done")
	sim.claim(sim.cur_goal()); await _wait(0.5)
	await _shot("07_goal_claim")
	# 全部目標＋Boss → 拔營
	S.cleared["1-3"] = true; S.res["coins"] = 50000.0
	sim.unlock("s_soup")
	S.mv.sold["g_suit"] = 25.0
	for i in 8: sim.claim(sim.cur_goal())
	await _wait(2.8)
	await _shot("08_can_move")
	sc.move_next()
	await _wait(0.7); await _shot("09_move_fold")
	await _wait(1.6); await _shot("10_move_walk")
	await _wait(2.4); await _shot("11_move_arrive")
	await _wait(3.5); await _shot("12_new_map")
	# 離線收益卡
	sim.assign("s_pants", 0, "t_mv5"); sim.st().st["s_pants"].lv = 15.0
	S.mv.last = J.now() - 3.0 * 3600000.0
	sc.on_hide(); S.mv.last = J.now() - 3.0 * 3600000.0
	sc.on_show(); await _wait(0.8)
	await _shot("13_offline_card")
	sc.tap(Vector2(195, 500)); await _wait(0.4)
	# 收益＋加速掣
	sim.use_boost("inc"); sim.use_boost("spd"); await _wait(1.0)
	await _shot("14_boosts")
	# 冇員工：手動做貨
	sim.assign("s_pants", 0, null); sim.st().pile["s_pants"] = 3.0
	await _wait(0.5)
	await _shot("15_manual_pile")
	sc.on_hide(); sc.queue_free()
	_p("shots done")

# 效能：場景自己嘅成本（模擬每格、畫每格），同村子畫面對比
func perf(tt) -> void:
	_setup(); var S = _S(); J.test_clock = -1.0
	var m = tt.main()
	var t0 = Time.get_ticks_usec(); var f0 = Engine.get_frames_drawn()
	await _wait(3.0)
	var base_ms = 3000.0 / maxf(1, Engine.get_frames_drawn() - f0)
	_p("perf 村子畫面（未開移動村）：每格 %.2f ms" % base_ms)
	sc = load("res://game/outpost/mv_scene.gd").new(); m.add_child(sc); m.move_child(sc, m.get("village").get_index() + 1); sc.setup(m)
	var sim = sc.sim; sim.st()
	S.res["coins"] = 1e6
	for sid in ["s_tailor", "s_soup", "s_coffin"]: sim.unlock(sid)
	var i = 0
	for sid in ["s_steamer", "s_tailor", "s_soup", "s_coffin"]:
		sim.assign(sid, 0, TG[i][0]); i += 1
	sim.assign("guard", 0, "t_mv5"); sim.assign("guard", 1, "t_mv6")
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
