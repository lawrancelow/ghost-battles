# [market M2] 加班平衡短模擬（合併 M1＋M2 後）：輪替＝100%，睇「唔加班」「狂加班唔理」各佔幾多。3 個方案 × 30 分鐘遊戲時間。
# 用 M1 嘅 market_sim_test._run（同一套方案定義），只係少跑幾個方案。
extends RefCounted
const MK = preload("res://game/market/mk_data.gd")
const FUN = preload("res://game/market/mk_fun.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const ZD = preload("res://game/zone/zone_data.gd")
func all(t) -> void: await _go(t, 11, false)
func rep1(t) -> void: await _go(t, 11, false)
func rep2(t) -> void: await _go(t, 23, false)
func rep3(t) -> void: await _go(t, 37, true)   # 第三次順便量櫃檯 1 人對 3 人
func _go(t, seed: int, ctr3: bool) -> void:
	var T = load("res://tools/tests/market_sim_test.gd").new()
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sim = m.mv_view.sim; var S = J.G.S
	MK.st()["test"] = 1
	load("res://game/kpi/kpi_data.gd").enable(false)
	for i in 40: T._gh(S, "t_s%d" % i)
	sim.market_street("food")
	var stalls = MK.sids_on(sim.ci(), "food").slice(0, 3)   # 唔計豆花擔：單價高過頭三攤幾百倍，賣幾件就蓋過晒其他收入，量唔到加班差別
	sim.paused = false
	var MKO = load("res://game/market/mk_ops.gd")
	if MKO.D().get("goods2") is Dictionary: MKO.D().goods2["lv"] = 9999.0   # 呢個模擬唔開副貨
	var out = {}
	for mode in ["rotate", "none", "always"]:
		S.erase("mkf")
		var r = await T._run(t, sim, stalls, mode, 2, 1, seed)
		out[mode] = r
		print("[m2bal] seed %d %s 收入 %.0f 趴低 %.1f%% 加班中 %.0f%%" % [seed, mode, r.income, r.down_pct, r.ot_pct])
	var base = float(out.rotate.income)
	print("[m2bal] seed %d 售價 ×%s 趴低 ×%s｜輪替＝100%%｜唔加班 %.0f%%｜狂加班唔理 %.0f%%（目標約 60%%／75%%）" % [seed, str(FUN.cf("ot", "price_mul", 0.0)), str(FUN.cf("ot", "down_price_mul", 0.0)), 100.0 * out.none.income / base, 100.0 * out.always.income / base])
	if ctr3:
		for nc in [1, 3]:   # 櫃檯人數：同一個種子、唔加班（淨係量結帳快慢）
			S.erase("mkf")
			var r3 = await T._run(t, sim, stalls, "none", 2, nc, seed)
			print("[m2bal] 櫃檯 %d 人（唔加班）收入 %.0f 客人處理率 %.0f%%" % [nc, r3.income, r3.handle_pct])
	MKO.reload(); MK.st().erase("ops"); MK.st().erase("test")
	print("[m2bal] RESULT ok=1 bad=0")
