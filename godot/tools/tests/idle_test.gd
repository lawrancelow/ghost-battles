# [idle] Idle Outpost 式升級驗證：里程碑倍數、品質星、累計產量門檻、解鎖鏈、領班、離線、舊存檔遷移
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/idle_test.gd","logic"],["quit"]]
# 驗算用獨立公式（唔叫 mv_data 嘅里程碑函數）。
extends RefCounted

const SIM = preload("res://game/outpost/mv_sim.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")
var D: Dictionary
var bad := 0
var rows := 0

func _p(s) -> void: print("[idle] ", s)
func _chk(name: String, got: float, exp: float, tol := 1e-6) -> void:
	rows += 1
	var ok = absf(got - exp) <= tol * maxf(1.0, absf(exp))
	if not ok: bad += 1
	print("[idle]   %-44s 遊戲=%16.4f  驗算=%16.4f  %s" % [name, got, exp, "OK" if ok else "<<< 唔對"])
func _ok(name: String, cond: bool) -> void: _chk(name, 1.0 if cond else 0.0, 1.0)
func _S(): return J.G.get("S")
func _sd(sid): return D.STATIONS[sid]

# ---- 獨立公式 ----
const MI := [10, 25, 50, 100, 150, 200]
func _ns(lv) -> int:
	var n = 0
	for i in MI.size(): if lv >= MI[i] and i % 2 == 0: n += 1
	return n
func _nv(lv) -> int:
	var n = 0
	for i in MI.size(): if lv >= MI[i] and i % 2 == 1: n += 1
	return n
func _st(lv) -> int:
	var n = 0
	for x in MI: if lv >= x: n += 1
	return n
func _val(sid, lv) -> float: return float(D.GOODS[_sd(sid).good].price) * (1.0 + 0.1 * (lv - 1)) * pow(2, _nv(lv)) * (1.0 + 0.2 * _st(lv))
func _tm(sid, lv) -> float: return float(_sd(sid).base_time) / (1.0 + 0.02 * (lv - 1)) / pow(2, _ns(lv))
func _gate(sid, i) -> int: return maxi(5, int(round([10, 120, 500, 2000, 6000, 15000][i] * 4.0 / float(_sd(sid).base_time) / 5.0)) * 5)

const TG := [["t_id1", "zhiren", "紙人甲", 5.0], ["t_id2", "youhun", "遊魂乙", 5.0], ["t_id3", "zombie", "殭屍丙", 5.0], ["t_id4", "egui", "餓鬼丁", 5.0]]
var _saved := {}
func _setup() -> void:
	D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/outpost.json"))
	MD.reload()
	var S = _S()
	J.test_clock = 1.8e12
	S.erase("mv"); S["cleared"] = {}; S.res["coins"] = 0.0
	var keep = []
	for gh in S.ghosts: if not str(gh.get("id")).begins_with("t_id"): keep.append(gh)
	S["ghosts"] = keep
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": "藍", "lv": t[3], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
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
	for i in int(secs / dt):
		J.test_clock += dt * 1000.0
		sim.step(dt); evs.append_array(sim.ev); sim.ev.clear()
	return evs
func _cnt(evs: Array, k: String, sid := "") -> int:
	var n = 0
	for e in evs: if e.k == k and (sid == "" or str(e.get("sid", "")) == sid): n += int(e.get("n", 1))
	return n

func logic(_t) -> void:
	_saved = _S().duplicate(true)
	_setup()
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	var CH = IDL.chain(0)
	var A = CH[0]; var B = CH[1]; var C = CH[2]
	_p("第一張圖解鎖鏈：%s；隨村台 %s" % [str(CH), str(load("res://game/outpost/mat.gd").carry())])

	_p("===== 1. 里程碑：10／25／50／100／150／200 輪流 速度 ×2／售價 ×2 =====")
	_chk("miles = 6 個、最高 Lv200", float(MD.max_lv(A)), 200.0)
	var fbad = 0
	for sid in D.STATIONS:
		for lv in [1, 9, 10, 11, 24, 25, 49, 50, 99, 100, 149, 150, 199, 200]:
			if absf(MD.val(sid, lv, 0) - _val(sid, lv)) > 1e-6 * maxf(1.0, _val(sid, lv)): fbad += 1
			if absf(MD.tm(sid, lv) - _tm(sid, lv)) > 1e-9: fbad += 1
			if MD.stars(sid, lv) != _st(lv): fbad += 1
	_chk("全部台 × 14 級：售價／時間／品質星（錯幾項）", float(fbad), 0.0)
	_ok("第 1 個 = 速度、第 2 個 = 售價、第 3 個 = 速度", MD.mile_kind(A, 0) == "spd" and MD.mile_kind(A, 1) == "val" and MD.mile_kind(A, 2) == "spd")
	_chk("Lv10：時間 ÷2（對 Lv9 計埋每級 2%）", MD.tm(A, 10), MD.tm(A, 9) * 1.16 / 1.18 / 2.0)
	_chk("Lv25：售價 ×2 × (1.4／1.2) 星", MD.val(A, 25, 0), MD.val(A, 24, 0) * 3.4 / 3.3 * 2.0 * 1.4 / 1.2)
	_chk("Lv200：售價里程碑 ×8、速度里程碑 ÷8", MD.mile_mul(A, 200) * float(pow(2, MD.ns(A, 200))), 64.0)

	_p("===== 2. 品質星 =====")
	for lv in [1, 10, 25, 50, 100, 150, 200]: _chk("Lv%d ★" % lv, float(MD.stars(A, lv)), float(_st(lv)))
	sim.st().st[A].lv = 25.0
	_chk("sim 品質星（Lv25）", float(IDL.stars(sim, A)), 2.0)
	sim.st().st[A].lv = 1.0

	_p("===== 3. 累計產量門檻（Lv10 前唔卡） =====")
	_S().res["coins"] = 1e12
	_chk("Lv10 門檻 = round5(10 × 4 ÷ 做貨秒數)，最少 5", float(MD.gate(A, 10)), float(_gate(A, 0)))
	_chk("Lv25 門檻", float(MD.gate(A, 25)), float(_gate(A, 1)))
	_chk("made_n = 0：Lv1 → 最多升到 Lv9", float(IDL.cap_lv(sim, A)), 9.0)
	_chk("升 10 掣：只升 8 級（去到 Lv9）", float(sim.up_n_for(A, "10")), 8.0)
	_chk("升 20 級：實際升 8", float(sim.upgrade(A, 20)), 8.0)
	_chk("Lv9 再升：0（產量未夠）", float(sim.upgrade(A, 1)), 0.0)
	var gb = IDL.gate_block(sim, A)
	_chk("卡住喺 Lv10，差 %d 件" % int(gb[2]), float(gb[0]), 10.0)
	_chk("差件數 = 門檻", float(gb[2]), float(MD.gate(A, 10)))
	sim.tap_station(A); _run(sim, _tm(A, 9) + 0.2)
	_chk("手做 1 轉：made_n +out", IDL.made_n(sim, A), float(MD.out(A, 9)))
	sim.st().st[A].made_n = float(MD.gate(A, 10))
	_chk("夠數：升到 Lv10", float(sim.upgrade(A, 1)), 1.0)
	_chk("Lv10 → 再卡喺 Lv24", float(IDL.cap_lv(sim, A)), 24.0)

	_p("===== 4. 解鎖鏈：第 N 台要第 N−1 台 Lv10 =====")
	_ok("第 1 台開局已開：" + A, sim.unlocked(A))
	_ok("第 2、3 台鎖住", not sim.unlocked(B) and not sim.unlocked(C))
	sim.st().st[A].lv = 9.0
	_ok("%s Lv9：有錢都解鎖唔到 %s" % [A, B], not sim.unlock(B))
	sim.st().st[A].lv = 10.0
	var c0 = sim.coins()
	_ok("%s Lv10：解鎖到 %s" % [A, B], sim.unlock(B))
	_chk("扣 unlock_cost", c0 - sim.coins(), float(_sd(B).unlock_cost))
	_ok("%s 要 %s Lv10（而家 Lv1）" % [C, B], not sim.unlock(C) and IDL.unlock_req(sim, C)[1] == B)
	sim.st().st[B].lv = 10.0
	_ok("%s Lv10 → 解鎖到 %s" % [B, C], sim.unlock(C))
	var cnt = [5, 5, 6, 6, 7, 7]; var cbad = 0
	for ci in 6: if IDL.chain(ci).size() < 3: cbad += 1
	_chk("每張圖解鎖鏈 ≥ 3 個台（錯幾張）", float(cbad), 0.0)
	_chk("第 5 張圖 7 個台", float(IDL.chain(4).size()), 7.0)
	_chk("第 6 張圖 7 個台", float(IDL.chain(5).size()), 7.0)
	for ci in 6: _p("  第 %d 張圖：鏈 %d 台（合約 %d）＋隨村 2" % [ci + 1, IDL.chain(ci).size(), cnt[ci]])

	_p("===== 5. 領班鬼 =====")
	_ok("派領班", sim.assign("fore:" + B, 0, "t_id1"))
	_ok("鬼 post = mv", J.seq(sim.ghost("t_id1").post, "mv"))
	_ok("領班唔佔員工位", sim.nworkers(B) == 0 and IDL.has_fore(sim, B))
	_chk("領班：速度 ×1.25", IDL.eff(sim, B), 1.25)
	var gB = str(_sd(B).good)
	var cn0 = sim.counter_n(gB)
	var ev = _run(sim, 4.0 * MD.tm(B, sim.lv(B)) / 1.25 + 2.0)
	_ok("冇員工、冇撳：領班自動開工（做咗 %d 件）" % _cnt(ev, "made", B), _cnt(ev, "made", B) >= 3)
	_ok("自動收錢：貨自己去咗櫃台（%d 件）" % (sim.counter_n(gB) - cn0 + int(J.num(sim.st().sold.get(gB)))), sim.counter_n(gB) - cn0 + int(J.num(sim.st().sold.get(gB))) >= 2)
	ev = _run(sim, 4.0 * MD.tm(C, 1) + 1.0)
	_chk("冇領班冇員工嘅台：唔會自己做", float(_cnt(ev, "made", C)), 0.0)
	sim.assign(C, 0, "t_id2"); sim.sync()
	var w = null
	for x in sim.workers: if x.sid == C: w = x
	w.pos = w.home; w.st = "work"; w.prog = 0.0
	_run(sim, 0.5, 0.05)
	var p1 = float(w.prog)
	sim.assign("fore:" + C, 0, "t_id3"); sim.sync()
	for x in sim.workers: if x.sid == C: w = x
	w.pos = w.home; w.st = "work"; w.prog = 0.0; w.erase("paid")
	_run(sim, 0.5, 0.05)
	_chk("有領班：員工做貨進度快 25%", float(w.prog) / maxf(1e-6, p1), 1.25, 0.06)
	_ok("撤領班", sim.assign("fore:" + C, 0, null) and not IDL.has_fore(sim, C) and not J.t(sim.ghost("t_id3").post))
	sim.assign("fore:" + C, 0, "t_id3")
	sim.assign(C, 0, "t_id3")   # 調去做員工：領班位自動清
	_ok("同一隻鬼調去員工：領班位清空", not IDL.has_fore(sim, C) and sim.nworkers(C) == 1)

	_p("===== 6. 離線（領班 ×1.25；只得領班 = 唔使搬貨） =====")
	var c = sim.ci()
	for sid in sim.st().st:
		for i in sim.sst(sid).workers.size(): sim.assign(sid, i, null)
		sim.assign("fore:" + sid, 0, null)
	sim.assign("fore:" + B, 0, "t_id1")
	var lB = sim.lv(B)
	var e1 = 1.25 * MD.out(B, lB) * MD.val(B, lB, c) / MD.tm(B, lB)
	_chk("只得領班：離線每秒 = 1.25 × out × val ÷ tm", sim.offline_rate(), e1)
	sim.assign(C, 0, "t_id2"); sim.assign(C, 1, "t_id4"); sim.assign("fore:" + C, 0, "t_id3")
	var lC = sim.lv(C)
	var e2 = e1 + 2.0 * 1.25 * MD.out(C, lC) * MD.val(C, lC, c) / (MD.tm(C, lC) + MD.carry_s(c, C))
	_chk("員工 2 + 領班：離線每秒", sim.offline_rate(), e2)
	var mB = IDL.made_n(sim, B)
	_S().res["coins"] = 0.0
	var r = sim.offline_gain(600000.0)
	_chk("離線 10 分鐘冥幣", r.coins, floor(e2 * 600.0), 1e-3)
	_chk("離線都計累計產量", IDL.made_n(sim, B) - mB, 600.0 * 1.25 * MD.out(B, lB) / MD.tm(B, lB), 1e-6)

	_p("===== 7. 拔營：領班放返；隨村台累計產量跟住走 =====")
	var K = str(load("res://game/outpost/mat.gd").carry()[0])
	sim.st().st[K].made_n = 777.0; sim.st().st[K].lv = 12.0
	for i in MD.goals(0).size(): sim.st().goals_done.append(float(i))
	_S().cleared["1-3"] = true
	_ok("拔營", sim.move_next())
	_ok("領班鬼放返（post = null）", not J.t(sim.ghost("t_id1").post))
	_chk("隨村台 made_n 跟住走", IDL.made_n(sim, K), 777.0)
	_chk("新圖第 1 台開局已開", 1.0 if sim.unlocked(IDL.chain(1)[0]) else 0.0, 1.0)
	_chk("新圖第 2 台鎖住", 1.0 if sim.unlocked(IDL.chain(1)[1]) else 0.0, 0.0)

	_p("===== 8. 舊存檔遷移 =====")
	_setup()
	var S = _S()
	S.mv = {"v": 1.0, "ci": 0.0, "st": {A: {"lv": 30.0, "unlocked": true, "workers": []}, C: {"lv": 3.0, "unlocked": true, "workers": []}},
		"made": {str(_sd(C).good): 55.0}, "carry_st": {K: {"lv": 60.0, "unlocked": true}}, "goals_done": [], "guards": []}
	var sim2 = SIM.new(); sim2.st()
	_chk("idle_v = 1", J.num(S.mv.get("idle_v")), 1.0)
	_chk("Lv30 舊台：made_n 補到 Lv25 門檻", IDL.made_n(sim2, A), float(MD.gate(A, 25)))
	_chk("Lv30 → 最多升到 Lv49（唔會跌級）", float(IDL.cap_lv(sim2, A)), 49.0)
	_ok("上一台未到 Lv10 嘅舊解鎖台照開：" + C, sim2.unlocked(C))
	_chk("舊 made 記錄搬入 made_n", IDL.made_n(sim2, C), 55.0)
	_chk("隨村台記錄：Lv60 補到 Lv50 門檻", J.num(S.mv.carry_st[K].made_n), float(MD.gate(K, 50)))
	_ok("領班位補空格", S.mv.st[A].get("fore") is Array and S.mv.st[A].fore.size() == 1)
	_chk("Lv30 售價跟新公式", MD.val(A, 30, 0), _val(A, 30))

	var S2 = _S()
	for k in S2.keys(): if not _saved.has(k): S2.erase(k)
	for k in _saved: S2[k] = _saved[k]
	MD.reload()
	J.test_clock = -1.0
	_p("RESULT idle ok=%d bad=%d（共 %d 行）" % [rows - bad, bad, rows])
