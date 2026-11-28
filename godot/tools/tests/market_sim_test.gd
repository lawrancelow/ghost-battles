# [market] 過勞鬼市集 M1：30 分鐘遊戲時間模擬（真模擬 mv_sim.step，唔係另寫公式）。
# 輸出每個方案嘅：收入、過勞率（攤位趴低時間佔比）、事件損失（佔收入 %）、事件處理率、佔用村鬼數。
# 方案：A 巡邏 0–4 隻（輪替加班、櫃檯 1 人）；B 加班策略：唔加班／輪替／狂加班唔理（巡邏 2 隻）。
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> mksim res://tools/tests/market_sim_test.gd all 1500
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const MK = preload("res://game/market/mk_data.gd")
const MKO = preload("res://game/market/mk_ops.gd")
const M = preload("res://game/outpost/mat.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const SECS := 1800.0
const DT := 0.1
const LV := 30.0

func _p(m): print("[mksim] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _gh(S, id: String) -> void:
	for g in S.ghosts: if str(J.gp(g, "id")) == id: return
	S.ghosts.append({"id": id, "k": "youhun", "name": id, "lv": 1.0, "post": null})

func _reset(sim, stalls: Array) -> void:
	var m = sim.st()
	MK.st().erase("ops"); MK.st()["ot"] = {}; MK.st()["patrol_done"] = 0
	m.counter = {}; m.pile = {}; m.sold = {}; m.earned = 0.0; m.served = 30.0
	sim.custs.clear(); sim.foes.clear(); sim.ev.clear()
	for sid in MD.stations(sim.ci()):
		var e = sim.sst(sid)
		e["unlocked"] = stalls.has(sid); e.lv = LV if stalls.has(sid) else 1.0
		for i in e.workers.size(): if e.workers[i] != null: sim.assign(sid, i, null)
	for i in 40: MKO.unassign(sim, "t_s%d" % i)
	MKO.tick(sim, 0.01)
	var g = 0
	for sid in stalls:
		sim.set_route(sid, "sell")
		for i in MKO.staff_slots(sid, LV): sim.assign(sid, i, "t_s%d" % g); g += 1
	sim._sync_key = ""

func _feed_mats(sim, stalls: Array) -> void:
	for sid in stalls:
		for mid in sim.need(sid): M.add(str(mid), 99999.0)
	M.add("m_bao", 50.0)

# ot: "none"／"rotate"／"always"
func _run(t, sim, stalls: Array, ot: String, n_pat: int, n_ctr: int, seed: int) -> Dictionary:
	_reset(sim, stalls)
	MKO.rng.seed = seed; sim.rng.seed = seed
	for i in n_ctr: MKO.assign(sim, "ctr", "food", "t_s%d" % (20 + i))
	for i in n_pat: MKO.assign(sim, "pat", "food", "t_s%d" % (30 + i))
	var c0 = sim.coins()
	var down_t = 0.0; var ot_t = 0.0; var steps = int(SECS / DT); var evn = 0
	for i in steps:
		if i % 10 == 0:
			_feed_mats(sim, stalls)
			for sid in stalls:
				var f = MK.fat(sid)
				if ot == "always":
					if not MK.ot_on(sid) and not MK.is_down(sid): MK.toggle_ot(sid)
				elif ot == "rotate":   # 過勞值到 80 就停、回落到 20 再開
					if MK.ot_on(sid) and f >= 80.0: MK.toggle_ot(sid)
					elif not MK.ot_on(sid) and not MK.is_down(sid) and f <= 20.0: MK.toggle_ot(sid)
		sim.step(DT)
		for sid in stalls:
			if MK.is_down(sid): down_t += DT
			if MK.ot_on(sid): ot_t += DT
		for e in MK.pop_events(): if str(e.get("k", "")) == "ev_new": evn += 1
		sim.ev.clear()
		if i % 3000 == 2999: await t.get_tree().process_frame
	var s = MKO.summary()
	for street in MK.ids(): MKO.collect(sim, street)
	var r = {"ot": ot, "pat": n_pat, "ctr": n_ctr, "income": s.income, "banked": sim.coins() - c0, "loss": s.loss, "loss_pct": 100.0 * s.loss / maxf(1.0, s.income),
		"down_pct": 100.0 * down_t / (SECS * stalls.size()), "ot_pct": 100.0 * ot_t / (SECS * stalls.size()), "events": evn, "handled": s.handled, "lost": s.lost,
		"handle_pct": 100.0 * s.handled / maxf(1.0, float(s.handled + s.lost)), "clk": s.clk, "village": s.village_cost}
	_p("方案 加班=%s 巡邏=%d 櫃檯=%d｜收入 %.0f｜過勞率 %.1f%%（加班中 %.0f%%）｜事件 %d 件、處理 %d、漏 %d（處理率 %.0f%%）｜事件損失 %.0f（%.2f%%）｜佔村鬼 %d" % [
		ot, n_pat, n_ctr, r.income, r.down_pct, r.ot_pct, evn, s.handled, s.lost, r.handle_pct, r.loss, r.loss_pct, r.village])
	return r

func all(t) -> void:
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sim = m.mv_view.sim; var S = J.G.S
	MK.st()["test"] = 1
	load("res://game/kpi/kpi_data.gd").enable(false)
	for i in 40: _gh(S, "t_s%d" % i)
	sim.market_street("food")
	var c = sim.ci()
	var stalls = MK.sids_on(c, "food").slice(0, 4)
	_p("第 %d 章食街 %d 攤 Lv%d，每攤店員 %d 名；模擬 %d 秒、步長 %.1f" % [c + 1, stalls.size(), int(LV), MKO.staff_slots(stalls[0], LV), int(SECS), DT])
	sim.paused = false
	# A：巡邏 0–4（每種跑 2 個種子取平均，減少隨機）
	var A = []
	for n in [0, 1, 2, 3, 4]:
		var r1 = await _run(t, sim, stalls, "rotate", n, 1, 11)
		var r2 = await _run(t, sim, stalls, "rotate", n, 1, 23)
		A.append({"pat": n, "income": (r1.income + r2.income) / 2.0, "loss_pct": (r1.loss_pct + r2.loss_pct) / 2.0, "handle_pct": (r1.handle_pct + r2.handle_pct) / 2.0,
			"net": (r1.income - r1.loss + r2.income - r2.loss) / 2.0, "down_pct": (r1.down_pct + r2.down_pct) / 2.0})
	for a in A: _p("巡邏 %d 隻：收入 %.0f｜事件損失 %.2f%%｜處理率 %.0f%%｜淨收入 %.0f｜過勞率 %.1f%%" % [a.pat, a.income, a.loss_pct, a.handle_pct, a.net, a.down_pct])
	_chk("巡邏 0 隻：事件損失 ≤ 15%（唔派巡邏唔係必輸）", A[0].loss_pct <= 15.0 and A[0].loss_pct > 0.0, A[0].loss_pct)
	_chk("巡邏 0 隻：淨收入仍 ≥ 滿編淨收入 80%", A[0].net >= 0.8 * A[4].net, [A[0].net, A[4].net])
	_chk("巡邏 4 隻滿編：事件損失 ＞ 0（壓唔到 0）而且比 0 隻少", A[4].loss_pct > 0.0 and A[4].loss_pct < A[0].loss_pct, A[4].loss_pct)
	_chk("巡邏越多處理率越高（0＜1＜2＜4）", A[0].handle_pct < A[1].handle_pct and A[1].handle_pct < A[2].handle_pct and A[2].handle_pct < A[4].handle_pct, [A[0].handle_pct, A[1].handle_pct, A[2].handle_pct, A[3].handle_pct, A[4].handle_pct])
	_chk("巡邏 4 隻處理率 ＜ 100%", A[4].handle_pct < 100.0, A[4].handle_pct)
	# B：加班策略
	var none = await _run(t, sim, stalls, "none", 2, 1, 11)
	var rot = await _run(t, sim, stalls, "rotate", 2, 1, 11)
	var alw = await _run(t, sim, stalls, "always", 2, 1, 11)
	_p("加班策略對比（輪替＝100%）：唔加班 %.0f%%｜狂加班唔理 %.0f%%｜設計目標 60%%／75%%" % [100.0 * none.income / rot.income, 100.0 * alw.income / rot.income])
	_chk("唔加班：冇人趴低", none.down_pct == 0.0, none.down_pct)
	_chk("狂加班唔理：趴低時間多過輪替", alw.down_pct > rot.down_pct, [alw.down_pct, rot.down_pct])
	_chk("輪替加班收入 ≥ 唔加班", rot.income >= none.income, [rot.income, none.income])
	# 櫃檯：冇櫃檯員 vs 3 人
	var c0 = await _run(t, sim, stalls, "rotate", 2, 0, 11)
	var c3 = await _run(t, sim, stalls, "rotate", 2, 3, 11)
	_p("櫃檯 0 人收入 %.0f｜1 人 %.0f｜3 人 %.0f" % [c0.income, rot.income, c3.income])
	_chk("冇櫃檯員：錢照樣入到帳（店員去收），收入唔高過有櫃檯員", c0.banked > 0.0 and c0.income <= c3.income * 1.02, [c0.income, c3.income])
	MK.st().erase("ops"); MK.st().erase("test")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
