# [market M2] 加班平衡短模擬（合併 M1＋M2 後）：輪替＝100%，睇「唔加班」「狂加班唔理」各佔幾多。3 個方案 × 30 分鐘遊戲時間。
# 用 M1 嘅 market_sim_test._run（同一套方案定義），只係少跑幾個方案。
extends RefCounted
const MK = preload("res://game/market/mk_data.gd")
const FUN = preload("res://game/market/mk_fun.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const ZD = preload("res://game/zone/zone_data.gd")
func all(t) -> void:
	var T = load("res://tools/tests/market_sim_test.gd").new()
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sim = m.mv_view.sim; var S = J.G.S
	MK.st()["test"] = 1
	load("res://game/kpi/kpi_data.gd").enable(false)
	for i in 40: T._gh(S, "t_s%d" % i)
	sim.market_street("food")
	var stalls = MK.sids_on(sim.ci(), "food").slice(0, 4)
	sim.paused = false
	var out = {}
	for mode in ["rotate", "none", "always"]:
		S.erase("mkf")
		var r = await T._run(t, sim, stalls, mode, 2, 1, 11)
		out[mode] = r
		print("[m2bal] %s 收入 %.0f 趴低 %.1f%% 加班中 %.0f%% 連單最高記錄/名聲 %.0f" % [mode, r.income, r.down_pct, r.ot_pct, load("res://game/market/mk_renown.gd").pts()])
	var base = float(out.rotate.income)
	print("[m2bal] 輪替＝100%%｜唔加班 %.0f%%｜狂加班唔理 %.0f%%（目標約 60%%／75%%）" % [100.0 * out.none.income / base, 100.0 * out.always.income / base])
	MK.st().erase("ops"); MK.st().erase("test")
	print("[m2bal] RESULT ok=1 bad=0")
