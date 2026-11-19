# 移動村戰鬥線（mv_war.gd）驗證：義勇軍、鬼潮、影響力、離線底線、告急、出征、霸檔、新手保護
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/war_test.gd","logic"],["gdrun","res://tools/tests/war_test.gd","shots"],["quit"]]
# 驗算用獨立公式（唔叫 mv_war 嘅公式）。
extends RefCounted

const SIM = preload("res://game/outpost/mv_sim.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const OUT := "/tmp/war/shots/"
var bad := 0
var rows := 0

func _p(s) -> void: print("[war] ", s)
func _chk(name: String, got: float, exp: float, tol := 1e-6) -> void:
	rows += 1
	var ok = absf(got - exp) <= tol * maxf(1.0, absf(exp))
	if not ok: bad += 1
	print("[war]   %-46s 遊戲=%14.4f  驗算=%14.4f  %s" % [name, got, exp, "OK" if ok else "<<< 唔對"])
func _ok(name: String, cond: bool) -> void: _chk(name, 1.0 if cond else 0.0, 1.0)
func _S(): return J.G.get("S")

# ---- 獨立公式 ----
func _M(v: float) -> float: return (0.6 + 0.4 * v / 60.0) if v <= 60.0 else (1.0 + 0.3 * (v - 60.0) / 40.0)
func _B(v: float) -> float: return 1.5 * maxf(0.0, (60.0 - v) / 60.0)
func _k(ci: int) -> float: return 1.0 + 0.6 * ci
func _stats(g: Dictionary, ci: int, vip := false) -> Dictionary:
	var GT = MVW.gear_tab(); var a = 4.0; var d = 4.0; var h = 50.0
	for gid in g:
		var n = minf(3.0, float(g[gid])); var e = GT[gid]
		a += float(e.atk) * n; d += float(e.def) * n; h += float(e.hp) * n
	var m = _k(ci) * (1.5 if vip else 1.0)
	return {"atk": a * m, "def": d * (1.5 if vip else 1.0), "mx": h * m}

const TG := [["t_w1", "zhiren", "紙人阿一", 6.0], ["t_w2", "youhun", "遊魂阿二", 4.0], ["t_w3", "zombie", "殭屍阿三", 8.0]]
func _setup() -> void:
	MD.reload()
	var S = _S()
	J.test_clock = 1.8e12
	S.erase("mv"); S["cleared"] = {}
	S.res["coins"] = 0.0
	var keep = []
	for gh in S.ghosts: if not str(gh.get("id")).begins_with("t_w"): keep.append(gh)
	S["ghosts"] = keep
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": "藍", "lv": t[3], "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	MVW.NEWS.clear()

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
func _sum(evs: Array, k: String, f: String) -> float:
	var n = 0.0
	for e in evs: if str(e.k) == k: n += float(e.get(f, 0.0))
	return n
func _W(): return _S().mv.war
func _setinf(v: float) -> void: _W().inf[str(MVW.cur_ci())] = v
func _cust(sim, gid: String, n: int, vip := false) -> Dictionary:
	var c = {"cid": "t_c", "k": "youhun", "wants": {gid: n}, "got": {gid: n}, "st": "serve", "slot": 0, "take": 0.0,
		"s": 0.0, "pos": sim.queue_pos(0), "ph": 0.0, "flip": true, "lines": [], "vip": vip}
	sim.custs.append(c)
	return c
func _gear_gid(ci: int) -> String:
	for sid in MD.stations(ci):
		var g = str(MD.st_def(sid).get("good", ""))
		if MVW.is_gear(g): return g
	return ""
func _plain_gid(ci: int) -> String:
	for sid in MD.stations(ci):
		var g = str(MD.st_def(sid).get("good", ""))
		if not MVW.is_gear(g): return g
	return ""
func _clear_live(sim) -> void:
	sim.foes.clear(); sim.custs.clear(); sim.war.wave = null; sim.st().counter = {}
	sim.spawn_t = 1e9; sim.foe_t = 1e9   # 測試入面唔自動出客／出孤魂（要嘅自己整）
	MVW.ws().wave_t = 1e9

func logic(_t) -> void:
	_setup(); var S = _S()
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	var w = MVW.ws()
	_p("GEAR 表：%s（%d 件）" % ["chain.json" if not (MVW.M.D().get("GEAR", {}) as Dictionary).is_empty() else "後備 fixture", MVW.gear_tab().size()])
	_p("===== 1. 影響力公式＋上下限 =====")
	_chk("開局影響力 = 60", MVW.inf(), 60.0)
	for v in [0.0, 30.0, 60.0, 80.0, 100.0]:
		_chk("M(%d)" % int(v), MVW.mul(v), _M(v))
		_chk("回血加成 B(%d)" % int(v), MVW.gear_bonus(v), _B(v))
	_chk("M(0) = 0.6×", MVW.mul(0.0), 0.6)
	_chk("M(100) = 1.3×", MVW.mul(100.0), 1.3)
	w.t0 = 601.0
	MVW.add_inf(500.0); _chk("加爆：上限 100", MVW.inf(), 100.0)
	MVW.add_inf(-500.0); _chk("跌爆（非新手）：下限 0", MVW.inf(), 0.0)
	_setinf(60.0)
	_chk("客人頻率倍數（inf 60）", sim.war.freq_mul(sim), 1.0)
	_setinf(0.0); _chk("客人頻率倍數（inf 0）＝間隔 ÷ 0.6", sim.war.freq_mul(sim), 0.6)
	_setinf(100.0); _chk("客人頻率倍數（inf 100）", sim.war.freq_mul(sim), 1.3)
	_setinf(60.0)

	_p("===== 2. 買裝備變義勇軍（攻防血＝基礎＋GEAR，× 地圖倍數） =====")
	var gg = _gear_gid(0); var pg = _plain_gid(0)
	_ok("第一張圖有裝備貨（%s）" % gg, gg != "")
	_clear_live(sim)
	var c = _cust(sim, gg, 2)
	var c0 = sim.coins()
	sim._pay(c)
	var base = 2.0 * MD.val(sim.sid_of(gg), 1, 0)
	_chk("inf 60：裝備客付錢 = 件數 × 單價 × M(60)", sim.coins() - c0, base * _M(60.0))
	_chk("義勇軍 +1", float(w.vol.size()), 1.0)
	_ok("客人唔走：由隊伍搬去義勇軍", not sim.custs.has(c) and sim.war.vols.size() == 1)
	var ex = _stats({gg: 2.0}, 0)
	var d = w.vol[0]
	_chk("義勇軍 攻", float(d.atk), ex.atk); _chk("義勇軍 防", float(d.def), ex.def); _chk("義勇軍 血", float(d.mx), ex.mx)
	var c2 = _cust(sim, pg, 3); sim._pay(c2)
	_chk("買普通貨：唔變義勇軍", float(w.vol.size()), 1.0)
	_p("  回血：影響力低 → 買裝備嘅鬼出價更高")
	_setinf(30.0)
	var c3 = _cust(sim, gg, 1); c0 = sim.coins(); sim._pay(c3)
	_chk("inf 30：裝備 = 單價 × M(30) × (1 + B(30))", sim.coins() - c0, MD.val(sim.sid_of(gg), 1, 0) * _M(30.0) * (1.0 + _B(30.0)))
	var c4 = {"cid": "t_c", "k": "youhun", "wants": {gg: 1, pg: 1}, "got": {gg: 1, pg: 1}, "st": "serve", "pos": sim.queue_pos(0), "vip": false}
	sim.custs.append(c4); c0 = sim.coins(); sim._pay(c4)
	var vg = MD.val(sim.sid_of(gg), 1, 0); var vp = MD.val(sim.sid_of(pg), 1, 0)
	_chk("inf 30：一件裝備＋一件普通 = (vg+vp) × M × (1 + vg/(vg+vp) × B)", sim.coins() - c0, (vg + vp) * _M(30.0) * (1.0 + vg / (vg + vp) * _B(30.0)))
	var c5 = _cust(sim, gg, 5, true); sim._pay(c5)
	var ev5 = _stats({gg: 5.0}, 0, true)
	_chk("VIP 買 5 件（最多計 3 件）：攻 × 1.5", float(w.vol[w.vol.size() - 1].atk), ev5.atk)
	_setinf(60.0)
	_p("  上限 %d：超出最弱嗰個退休" % MVW.VOL_MAX)
	sim.ev.clear()
	for i in 8: sim._pay(_cust(sim, gg, 3))
	_chk("義勇軍上限 8", float(w.vol.size()), 8.0)
	_chk("原本 4 個＋新 8 個 → 退休 4 個", float(_cnt(sim.ev, "war_retire")), 4.0)
	var weakest_left = 1e18
	for v in w.vol: weakest_left = minf(weakest_left, MVW.vpow(v))
	_ok("剩低嘅全部係最強（最弱 ≥ 買 1 件嗰個）", weakest_left >= MVW.vpow(_stats({gg: 2.0}, 0)) - 1e-6)
	_p("  義勇軍行去圍欄排好")
	sim.ev.clear()
	_run(sim, 40.0)
	var at_fence = 0
	for r in sim.war.vols: if r.st == "post" and absf(r.pos.y - (sim.L.fence_y + 62.0)) < 12.0: at_fence += 1
	_chk("40 秒後全部企喺圍欄前", float(at_fence), 8.0)

	_p("===== 3. 鬼潮：守贏 =====")
	_clear_live(sim); _setinf(60.0)
	var wn0 = MVW.wave_n(0)
	var n_exp = 3 + 0 + mini(3, int(wn0 / 2.0))
	for v in w.vol: v.atk = 400.0; v.hp = v.mx   # 好打得
	w.wave_t = 0.05
	var evw = _run(sim, 0.1 + 0.7 * n_exp + 0.1, 0.05)
	var boss = null
	for f0 in sim.foes: if f0.get("boss", false): boss = f0
	_ok("最尾一隻係頭目", boss != null and sim.war.wave != null and sim.war.wave.q.is_empty())
	if boss != null: _chk("頭目血 = 孤魂血 × 5", boss.mx, MD.foe_hp(0) * minf(2.5, 1.0 + 0.12 * wn0) * 5.0)
	_chk("鬼潮出咗嘅孤魂數", float(sim.war.wave.foes.size()) if sim.war.wave != null else -1.0, float(n_exp))
	evw.append_array(_run(sim, 58.0))
	_chk("鬼潮隻數 = 3 + ci + min(3, wn/2)", _sum(evw, "war_wave", "n"), float(n_exp))
	_chk("守贏事件", float(_cnt(evw, "war_won")), 1.0)
	_chk("守贏冇失：影響力 +10", MVW.inf(), 70.0)
	_chk("已打波數 +1", MVW.wave_n(0), wn0 + 1.0)
	_chk("守贏冥幣 = 打孤魂(kill) + 獎(foe_coin × (3+n))", _sum(evw, "war_won", "coins"), MD.foe_coin(0) * (3 + n_exp))
	_chk("下一波倒數重設 = 240 秒（−守波用咗嘅時間）", 1.0 if J.num(w.wave_t) <= MVW.WAVE_GAP and J.num(w.wave_t) > MVW.WAVE_GAP - 60.0 else 0.0, 1.0)

	_p("===== 4. 鬼潮：守唔住（冇義勇軍、冇守夜）→ 偷貨、影響力跌 =====")
	_clear_live(sim); w.vol.clear(); sim.war.reset_live(); _setinf(60.0)
	sim.st().counter[pg] = 30.0
	w.wave_t = 0.05
	var evl = _run(sim, 80.0)
	_chk("守唔住事件", float(_cnt(evl, "war_lost")), 1.0)
	var steals = _cnt(evl, "war_steal"); var stolen = _sum(evl, "war_steal", "n")
	_ok("孤魂偷咗貨（%d 次、%d 件）" % [steals, int(stolen)], steals > 0)
	_chk("櫃台少咗 = 偷走件數", 30.0 - J.num(sim.st().counter.get(pg)), stolen)
	_chk("影響力 = 60 − 12 − 偷貨次數", MVW.inf(), 60.0 - 12.0 - float(steals))
	var left_alive = 0
	_run(sim, 6.0)
	for f in sim.foes: if f.get("wave", false) and f.st != "die": left_alive += 1
	_chk("衝完走人：圍欄冇鬼潮孤魂留低", float(left_alive), 0.0)

	_p("===== 5. 圍欄孤魂：拍耐咗偷貨／嚇客；義勇軍擋住就打義勇軍 =====")
	_clear_live(sim); _setinf(60.0)
	sim.st().counter[pg] = 5.0
	sim.spawn_foe(); var f = sim.foes[0]; f.pos = Vector2(200, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0; f.hp = 1e9; f.mx = 1e9
	var ev6 = _run(sim, 5.2)
	_chk("冇人擋 5 秒：偷一次", float(_cnt(ev6, "war_steal")), 1.0)
	_chk("影響力 −1", MVW.inf(), 59.0)
	sim.st().counter = {}
	sim.spawn_cust(); sim.spawn_cust()
	for cc in sim.custs: cc.st = "queue"
	f.st = "bang"; f.t = 0.0; f.press = 0.0
	ev6 = _run(sim, 5.2)
	_chk("櫃台冇貨：嚇走排尾客人", float(_cnt(ev6, "war_scare")), 1.0)
	_clear_live(sim); _setinf(60.0)
	sim._pay(_cust(sim, gg, 1)); _run(sim, 40.0)
	var r0 = sim.war.vols[0]; r0.d.hp = 15.0; r0.d.atk = 0.0001
	sim.st().counter[pg] = 5.0
	sim.spawn_foe(); f = sim.foes[0]; f.pos = Vector2(r0.pos.x, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0; f.hp = 1e9; f.mx = 1e9
	ev6 = _run(sim, 6.0)
	_chk("義勇軍擋住：冇偷貨", float(_cnt(ev6, "war_steal")), 0.0)
	_chk("義勇軍捱打散咗（血 15 ÷ (5 × 40/(40+防)) ≈ 3.8 秒）", float(_cnt(ev6, "war_vdie")), 1.0)
	_chk("義勇軍散：影響力 −2", MVW.inf(), 58.0)

	_p("===== 6. 離線：影響力最多跌到 50；唔會告急、唔會霸檔 =====")
	_clear_live(sim); w.vol.clear(); sim.war.reset_live(); w.alarm = null; w.occ = {}
	_setinf(80.0)
	sim.offline_gain(8.0 * 3600000.0)
	_chk("冇防守離線 8 小時：80 → 50（底線）", MVW.inf(), 50.0)
	_setinf(45.0); sim.offline_gain(8.0 * 3600000.0)
	_chk("本身 45：離線唔再跌", MVW.inf(), 45.0)
	_setinf(20.0); sim.offline_gain(8.0 * 3600000.0)
	_ok("離線 inf 20：唔告急、冇檔被霸", not MVW.alarm_on() and MVW.occ_sid() == "")
	w.vol.append({"cid": "x", "k": "youhun", "g": {gg: 3.0}, "atk": 1e6, "def": 10.0, "mx": 100.0, "hp": 100.0})
	_setinf(60.0); sim.offline_gain(1.0 * 3600000.0)
	_chk("防守夠：離線 1 小時（15 波 × +2）→ 90", MVW.inf(), 90.0)
	_chk("離線收益倍數 inf 90 = max(1, M(90))", sim.war.off_mul(sim), _M(90.0))
	_setinf(30.0); _chk("離線收益倍數 inf 30 = 1（離線唔罰錢）", sim.war.off_mul(sim), 1.0)
	w.vol.clear()

	_p("===== 7. 告急 → 親自出征打贏 → 影響力回升＋材料 =====")
	_clear_live(sim); sim.war.reset_live(); w.t0 = 601.0; w.alarm = null; w.occ = {}
	_setinf(25.0)
	var ev7 = _run(sim, 0.5)
	_ok("inf 25 < 30：告急", MVW.alarm_on() and _cnt(ev7, "war_alarm") == 1)
	_ok("要出征", MVW.need_exp())
	var es = MVW.exp_stage(0)
	var ET = J.G.get("ENEMY_T"); var ek = 0
	for e in es.stage.en: if ET.has(str(e)): ek += 1
	_chk("出征敵人：3 隻、全部喺 ENEMY_T（%s）" % str(es.stage.en), float(ek), 3.0)
	var fence = MD.map_def(0).fence_foes; var inmap = 0
	for e in es.stage.en: if fence.has(e): inmap += 1
	_chk("出征敵人係呢張圖嘅圍欄孤魂", float(inmap), 3.0)
	var wood0 = J.num(S.res.get("wood")); var pl0 = J.num(S.res.get("planks"))
	# 模擬戰鬥結算：Battle.sid＋result（同真戰鬥 finish 一樣），由 poll() 收
	var B = J.G.get("Battle"); var bsid = B.get("sid"); var bres = B.get("result")
	w.exp = {"sid": es.sid, "ci": 0.0, "had": false}; S.cleared[es.sid] = true
	B["sid"] = es.sid; B["result"] = {"win": true}
	var pr = MVW.poll()
	B["sid"] = bsid; B["result"] = bres
	_ok("poll 收到勝利", pr.get("win", false))
	_chk("出征贏：inf = max(25 + 35, 65)", MVW.inf(), 65.0)
	_ok("告急解除", not MVW.alarm_on() and not MVW.need_exp())
	_chk("獎材料：槐木 +40", J.num(S.res.get("wood")) - wood0, 40.0)
	_chk("獎材料：棺材板 +12", J.num(S.res.get("planks")) - pl0, 12.0)
	_ok("唔污染主線通關紀錄（cleared 冇出征 sid）", not S.cleared.has(es.sid))
	_chk("再 poll：唔會重複計", float(MVW.poll().size()), 0.0)
	_setinf(70.0)
	w.exp = {"sid": es.sid, "ci": 0.0, "had": false}
	MVW.resolve(true)
	_chk("高影響力出征贏：+35（夾 100）", MVW.inf(), 100.0)
	_setinf(25.0); w.alarm = {"t": 100.0}; w.exp = {"sid": es.sid, "ci": 0.0, "had": false}
	MVW.resolve(false)
	_ok("出征輸：告急照舊", MVW.alarm_on() and MVW.inf() == 25.0)
	w.alarm = null

	_p("===== 8. 唔理告急 180 秒 → 一個檔被霸停工 → 出征贏復工 =====")
	_clear_live(sim); sim.war.reset_live(); w.alarm = null; w.occ = {}
	var ids = MD.stations(0); var A = ids[0]
	sim.assign(A, 0, "t_w1"); sim.st().st[A].lv = 30.0; sim.sync()
	_setinf(20.0)
	var ev8 = _run(sim, 179.0)
	_ok("179 秒：未霸", MVW.occ_sid() == "")
	_setinf(20.0)
	ev8 = _run(sim, 2.0)
	var os = MVW.occ_sid()
	_ok("180 秒：有檔被霸（%s）" % os, os != "" and _cnt(ev8, "war_occ") == 1)
	var best = ""; var bv = -1.0
	for sid in ids:
		if not sim.unlocked(sid): continue
		var l = sim.lv(sid); var v = MD.val(sid, l, 0) * MD.out(sid, l) / MD.tm(sid, l) * (1.0 + sim.nworkers(sid))
		if v > bv: bv = v; best = sid
	_ok("霸咗最好賺嗰個（每秒產值 ×(1+員工)：%s）" % best, os == best and os == A)
	_chk("被霸：撳台唔做得", 1.0 if sim.tap_station(os) == "occ" else 0.0, 1.0)
	var ev9 = _run(sim, 30.0)
	var made = 0
	for e in ev9: if e.k == "made" and str(e.sid) == os: made += 1
	_chk("被霸：員工停工（30 秒做 0 次）", float(made), 0.0)
	var off_rows = sim.offline_gain(3600000.0).rows
	var off_has = false
	for x in off_rows: if str(x[0]) == os: off_has = true
	_ok("被霸：離線都唔計呢個檔", not off_has)
	w.exp = {"sid": es.sid, "ci": 0.0, "had": false}
	MVW.resolve(true)
	_ok("出征贏：復工", MVW.occ_sid() == "" and not MVW.alarm_on())
	sim.st().counter = {}   # 停工前做定嘅貨塞滿櫃台（冇客），清走先睇到再做
	var MM = preload("res://game/outpost/mat.gd")   # [integ] 生產鏈：上面離線結算食晒料，補返原料先睇復工
	for mid in MM.rin(A): MM.add(str(mid), 500.0)
	ev9 = _run(sim, 30.0)
	made = 0
	for e in ev9: if e.k == "made" and str(e.sid) == A: made += 1
	_ok("復工：30 秒有做貨（%d 次）" % made, made > 0)
	sim.assign(A, 0, null)

	_p("===== 9. 新手保護：第一張圖頭 10 分鐘唔告急、唔偷貨、影響力最低 35 =====")
	_clear_live(sim); sim.war.reset_live(); w.alarm = null; w.occ = {}; w.t0 = 0.0
	_setinf(60.0); MVW.add_inf(-100.0)
	_chk("新手：跌極都係 35", MVW.inf(), 35.0)
	_setinf(20.0)
	sim.st().counter[pg] = 5.0
	sim.spawn_foe(); f = sim.foes[0]; f.pos = Vector2(200, sim.L.fence_y - 8); f.st = "bang"; f.t = 0.0; f.hp = 1e9; f.mx = 1e9
	var ev10 = _run(sim, 6.0)
	_ok("新手：inf 20 都唔告急", not MVW.alarm_on())
	_chk("新手：孤魂唔偷貨", float(_cnt(ev10, "war_steal")), 0.0)
	_chk("新手保護計時（在線秒數）", J.num(w.t0), 6.0, 0.01)
	w.t0 = 599.0
	_run(sim, 1.5)
	_ok("過咗 10 分鐘：告急", MVW.alarm_on())
	w.alarm = null

	_p("===== 10. 拔營：義勇軍解散、告急清走 =====")
	_clear_live(sim); _setinf(60.0)
	sim._pay(_cust(sim, gg, 1))
	for i in MD.goals(0).size(): sim.st().goals_done.append(float(i))
	S.cleared["1-3"] = true
	_ok("move_next", sim.move_next())
	_ok("拔營後冇義勇軍", w.vol.is_empty() and sim.war.vols.is_empty())
	_chk("新圖影響力 = 60", MVW.inf(), 60.0)
	_chk("新圖第一波 = 180 秒", J.num(w.wave_t), MVW.WAVE_FIRST)
	_chk("新圖：唔係新手保護", 1.0 if MVW.newbie() else 0.0, 0.0)
	_p("驗算 %d 行，唔對 %d 行 → %s" % [rows, bad, "全部一致" if bad == 0 else "有錯"])
	J.test_clock = -1.0

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
func _cam(y: float) -> void:
	sc.cam = y; sc.cam_tgt = null; sc.cam_v = 0.0; sc._clamp_cam(true)

func shots(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_setup(); var S = _S()
	J.test_clock = -1.0
	var m = tt.main()
	sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvSceneWar"
	var vil = m.get("village")
	var mh = m.get("mv_host")
	if mh is CanvasItem: mh.visible = false   # 主畫面自己嗰個移動村收埋，免得蓋住測試場景
	m.add_child(sc)
	if vil != null: m.move_child(sc, vil.get_index() + 1)
	sc.setup(m)
	var sim = sc.sim; sim.st()
	var w = MVW.ws(); w.t0 = 601.0
	var ids = MD.stations(0)
	for sid in ids: S.mv.st[sid].unlocked = true
	S.mv.st[ids[0]].lv = 9.0
	sim.assign(ids[0], 0, "t_w1"); sim.assign("guard", 0, "t_w3")
	S.mv.counter[str(MD.st_def(ids[0]).good)] = 6.0
	sc.on_show()
	var gg = _gear_gid(0)
	for i in 6: sim._pay(_cust(sim, gg, 1 + i % 3, i == 5))
	await _wait(0.2)
	# 義勇軍行去圍欄：截一張半路
	await _wait(4.0)
	if sim.war.vols.size(): _cam(sim.war.vols[0].pos.y - sc.view_h() * 0.55)
	await _wait(0.3)
	await _shot("w01_vols_walking")
	await _wait(14.0)
	_cam(sc.cam_min())
	await _wait(0.5)
	await _shot("w02_vols_at_fence")
	# 鬼潮＋頭目
	sim.foes.clear()
	w.wave_t = 0.05
	await _wait(5.5)
	await _shot("w03_wave_boss")
	await _wait(3.0)
	await _shot("w04_wave_fight")
	await _wait(20.0)
	await _shot("w05_wave_after")
	# 告急
	sim.war.wave = null; sim.foes.clear()
	for r in sim.war.vols: r.d.hp = r.d.mx
	w.vol.clear(); sim.war.reset_live()
	w.inf["0"] = 22.0
	await _wait(1.0)
	await _wait(1.2)
	await _shot("w06_alarm")
	# 霸檔
	w.alarm = {"t": 0.05}
	await _wait(0.6)
	var os = MVW.occ_sid()
	_p("霸咗：" + os)
	sc.cam_tgt = null; sc.cam = sim.st_pos(os).y - sc.view_h() * 0.5; sc._clamp_cam(true)
	await _wait(3.2)
	await _shot("w07_occupied")
	# 中文版
	var lang0 = DB.lang
	DB.lang = "zh" if lang0 == "yue" else "yue"
	_cam(sc.cam_min()); await _wait(0.6)
	await _shot("w08_alarm_other_lang")
	_cam(sim.st_pos(os).y - sc.view_h() * 0.4); await _wait(0.4)
	await _shot("w08b_occupied_other_lang")
	DB.lang = lang0
	# 真出征：開一場短仗（用呢張圖嘅孤魂），截圖，然後直接結算贏
	var team_ok = false
	for x in J.iter(S.get("team")): if J.t(x): team_ok = true
	if not team_ok and S.ghosts.size(): S["team"] = [S.ghosts[0].id]
	var r = sim.war.start_expedition(sim)
	_p("出征：" + r)
	await _wait(4.0)
	await _shot("w09_expedition_battle")
	var B = J.G.get("Battle")
	if r == "ok" and J.t(B.get("active")):
		J.mc(B, "finish", [true])
		await _wait(1.0)
		await _shot("w10_expedition_result")
		var ok = J.G.get("$")
		var okb = J.cl(ok, null, ["#b-ok"]) if ok != null else null
		if okb != null: J.cl(J.gp(okb, "onclick"), okb, [])
		await _wait(1.5)
	_p("出征後：inf=%d occ=%s alarm=%s" % [int(MVW.inf()), MVW.occ_sid(), str(MVW.alarm_on())])
	_cam(sc.cam_min()); await _wait(1.0)
	await _shot("w11_after_expedition")
	sc.on_hide(); sc.queue_free()
