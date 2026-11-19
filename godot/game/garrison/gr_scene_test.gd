# 分村第二期（經營場景）headless 驗證＋截圖。tester：["gdrun","res://game/garrison/gr_scene_test.gd","logic"]
# 驗算全部用 supply.json 嘅數＋獨立公式自己計，同遊戲數值逐項對
extends RefCounted

var C: Dictionary
var GR
var bad := 0
var rows := 0
var NM := 0.0
const TGS := "res://game/garrison/gr_test.gd"

func _p(s) -> void: print("[gr2] ", s)
func _chk(name: String, got: float, exp: float, tol := 1e-6) -> void:
	rows += 1
	var ok = absf(got - exp) <= tol * maxf(1.0, absf(exp))
	if not ok: bad += 1
	print("[gr2]   %-34s 遊戲=%14.4f  驗算=%14.4f  %s" % [name, got, exp, "OK" if ok else "<<< 唔對"])
func _S(): return J.G.get("S")
func _lvmul(lv: float) -> float: return 1.0 + C.LV_MUL * (lv - 1.0)
func _mile(lv: float) -> float:
	var m = 1.0
	for x in C.MILESTONE: if lv >= x[0]: m *= x[1]
	return m
func _stat(t, i: int) -> float: return floor(t[5][i] * (1.0 + 0.06 * (t[4] - 1.0)) + 0.5)
# 獨立計：槐林（ci0，incMul 1）某檔收入（唔計斷糧）
func _inc(sid: String, lv: float, members: Array) -> float:
	var base = 25.0 if sid == "bun" else 20.0; var si = 1 if sid == "bun" else 0; var k = 0.0
	for e in members: k += (1.0 + _stat(e[0], si) / 100.0) * (1.5 if e[1] == 0 else 1.0) * e[0][8]
	return base * 1.0 * _lvmul(lv) * _mile(lv) * k

func _setup() -> Array:
	GR = Engine.get_main_loop().root.get_node("Garrison"); GR.quiet = true
	C = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/supply.json"))
	NM = float(C.NIGHT_MIN) * 60000.0
	var TG = load(TGS).TG
	var S = _S()
	J.test_clock = floor(Time.get_unix_time_from_system() * 1000.0 / NM) * NM + 1000.0
	S.erase("gar"); S["cleared"] = {"1-1": true, "1-2": true, "1-3": true}
	S["seen"] = S.get("seen", {}); S.seen.erase("gift_car"); S.seen.erase("ch5_pocong")
	S["res"] = {"wood": 0.0, "rice": 0.0, "planks": 50000.0, "buns": 5000.0, "coins": 100000.0, "troops": 100.0}
	var keep = []
	for gh in S.ghosts: if not str(gh.get("id")).begins_with("t_"): keep.append(gh)
	S["ghosts"] = keep
	for t in TG: S.ghosts.append({"id": t[0], "k": t[1], "name": t[2], "q": t[3], "lv": t[4], "st": t[5].duplicate(), "post": null, "spent": 0.0})
	GR.tick()
	for t in TG: GR.assign(0, t[6], t[7], t[0])
	S.gar.front["buns"] = 1e9; S.gar.front["planks"] = 1e9   # 前線唔斷糧（隔離收入驗算）
	return TG

func _adv_ms(ms: float) -> void: J.test_clock += ms

func logic(_t) -> void:
	var TG = _setup(); var S = _S(); var R = S.res; var g = S.gar
	var bunM = []; var restM = []
	for t in TG:
		if t[6] == "bun": bunM.append([t, t[7]])
		if t[6] == "rest": restM.append([t, t[7]])
	var IB = _inc("bun", 1.0, bunM); var IR = _inc("rest", 1.0, restM)
	_p("===== 1. 實時累積 = income ÷ 一晚毫秒 × 1000 =====")
	_chk("壽包檔 income（獨立計）", GR.income(0, "bun"), IB)
	_chk("歇腳檔 income（獨立計）", GR.income(0, "rest"), IR)
	_chk("壽包檔每秒 rate_ps", GR.rate_ps(0, "bun"), IB / NM * 1000.0)
	_chk("歇腳檔每秒 rate_ps", GR.rate_ps(0, "rest"), IR / NM * 1000.0)
	var c0 = R.coins
	_adv_ms(300000.0); GR.accrue_live()   # 5 分鐘
	_chk("5 分鐘後冥幣增加（有管事＝自動）", R.coins - c0, (IB + IR) / NM * 1000.0 * 300.0)
	_chk("收銀箱冇郁（有管事）", GR.till(0, "bun") + GR.till(0, "rest"), 0.0)
	for i in 20: _adv_ms(1500.0); GR.accrue_live()   # 每 1.5 秒推一次（似畫面）
	_chk("再 30 秒（分 20 次推）", R.coins - c0, (IB + IR) / NM * 1000.0 * 330.0)
	_p("===== 2. night_step 冇重複計 =====")
	var n0 = g.done; var tb = J.num(g.t0) + (n0 + 1.0) * NM   # 今晚完
	var c1 = R.coins; var a1 = J.num(g.acc)
	J.test_clock = tb + NM   # 跨兩個晚界
	var rep = GR.tick()
	_chk("跨咗兩晚", g.done - n0, 2.0)
	_chk("冥幣增加 = 收入 × 經過時間／一晚", R.coins - c1, (IB + IR) * (J.test_clock - a1) / NM)
	_chk("rep.auto = 同一數", rep.auto, (IB + IR) * (J.test_clock - a1) / NM)
	var c2 = R.coins; J.test_clock += NM; GR.tick()
	_chk("剛好一晚（晚界到晚界）= 1 × income", R.coins - c2, IB + IR)
	_p("（舊版每晚結算：一晚 = income；而家實時累積一晚都係 income → 冇雙計）")
	_p("===== 3. 收銀箱（冇管事） =====")
	GR.assign(0, "bun", 0, null); GR.assign(0, "rest", 0, null)
	var bunH = []; var restH = []
	for e in bunM: if e[1] != 0: bunH.append(e)
	for e in restM: if e[1] != 0: restH.append(e)
	var IBh = _inc("bun", 1.0, bunH); var IRh = _inc("rest", 1.0, restH)
	_chk("冇管事：壽包檔 income（淨幫工）", GR.income(0, "bun"), IBh)
	var c3 = R.coins
	_adv_ms(NM * 0.5); GR.tick()
	_chk("半晚：冥幣冇增加（錢留喺收銀箱）", R.coins - c3, 0.0)
	_chk("半晚：壽包檔收銀箱 = 0.5 × income", GR.till(0, "bun"), IBh * 0.5)
	_chk("半晚：歇腳檔收銀箱 = 0.5 × income", GR.till(0, "rest"), IRh * 0.5)
	_chk("收銀箱上限 = 1 晚收入", GR.till_cap(0, "bun"), IBh * float(C.TILL.nights))
	_adv_ms(NM * 2.0); GR.tick()
	_chk("2.5 晚後：收銀箱 = 上限（停收）", GR.till(0, "bun"), IBh)
	_chk("till_full = true", 1.0 if GR.till_full(0, "bun") else 0.0, 1.0)
	_chk("冥幣仍然冇增加", R.coins - c3, 0.0)
	var cc = GR.collect(0, "bun")
	_chk("撳收錢：收到 = 收銀箱", cc, IBh)
	_chk("收錢後冥幣 +上限", R.coins - c3, IBh)
	_chk("收錢後收銀箱 = 0", GR.till(0, "bun"), 0.0)
	_p("===== 4. 有管事自動入賬（經理自動化） =====")
	GR.assign(0, "bun", 0, "t_egk")
	var c4 = R.coins; var tr0 = GR.till(0, "rest")
	_adv_ms(NM * 0.25); GR.tick()
	_chk("壽包檔有管事：¼ 晚自動入賬", R.coins - c4, IB * 0.25)
	_chk("壽包檔收銀箱唔再加", GR.till(0, "bun"), 0.0)
	_chk("歇腳檔冇管事：收銀箱滿咗唔再加", GR.till(0, "rest"), tr0)
	_p("===== 5. 離線 10 小時（有管事照計最多 8 小時；冇管事只填滿收銀箱） =====")
	GR.collect(0, "rest")
	var c5 = R.coins; var nb = g.done
	# 對齊晚界先離線（方便驗算）
	J.test_clock = J.num(g.t0) + (g.done + 1.0) * NM; GR.tick(); c5 = R.coins; GR.collect(0, "rest"); c5 = R.coins; nb = g.done
	_adv_ms(10.0 * 3600000.0)
	GR.quiet = true
	var rep5 = GR.tick()
	var H8 = 8.0 * 3600000.0
	_chk("離線處理晚數（上限 24）", rep5.nights, 24.0)
	_chk("跳過晚數", rep5.skip, 6.0)
	_chk("自動入賬 = income × 8 小時", rep5.auto, IB * H8 / NM)
	_chk("冥幣增加 = 同上", R.coins - c5, IB * H8 / NM)
	_chk("冇管事收銀箱 = 上限（1 晚）", GR.till(0, "rest"), IRh)
	_chk("rep.till = 上限", rep5.till, IRh)
	_p("交更簿 auto=%.2f till=%.2f nights=%d" % [rep5.auto, rep5.till, int(rep5.nights)])
	GR.assign(0, "rest", 0, "t_toy")
	_p("===== 6. 孤魂（子時）：偷／嚇走／派宵夜收編 =====")
	# 守夜：撤走管事，只留遊魂阿明（幫工）→ 部分擋得住
	GR.assign(0, "guard", 0, null)
	var dx = null
	for t in TG: if t[0] == "t_yh2": dx = t
	var gp = _stat(dx, 2) * 1.0 * dx[8] * _lvmul(1.0)
	_chk("守夜防守（獨立計）", GR.guard_pow(0), gp)
	var rate = 0.08 * maxf(0.0, 1.0 - gp / 120.0)
	_chk("每晚失竊率", GR.theft_rate(0), rate)
	var tot = clampi(int(ceil(4.0 * rate / 0.08 - 1e-9)), 1, 4) if rate > 0.0 else 0
	_chk("偷嘢孤魂數", float(GR.thieves_n(0)), float(tot))
	# A 晚：冇郁 → 原公式
	var cap = GR.store_cap(0)
	J.test_clock = J.num(g.t0) + (g.done + 0.9) * NM; GR.tick()
	g.maps["0"].stock["planks"] = 100.0; g.maps["0"].stock["buns"] = 50.0
	var y = GR.yield_of(0).get("planks", 0.0)
	J.test_clock = J.num(g.t0) + (g.done + 1.0) * NM; GR.tick()
	var sp = minf(maxf(cap, 100.0), 100.0 + y)
	_chk("冇郁嘅晚：棺材板 = (存+產) × (1−率)", g.maps["0"].stock.planks, sp * (1.0 - rate))
	_chk("冇郁嘅晚：壽包 = 50 × (1−率)", g.maps["0"].stock.buns, 50.0 * (1.0 - rate))
	# B 晚：子時嚇走 1 隻、派宵夜 1 隻
	J.test_clock = J.num(g.t0) + (g.done + 0.8) * NM; GR.tick()
	_chk("子時 raid_time", 1.0 if GR.raid_time() else 0.0, 1.0)
	g.maps["0"].stock["planks"] = 200.0; g.maps["0"].stock["buns"] = 80.0
	S.bld["home"] = 50.0   # 名冊有位
	var fc0 = J.num(J.cl(J.G.get("fodderCount"), null, []))
	_chk("嚇走一隻（raid_scare）", 1.0 if GR.raid_scare(0) else 0.0, 1.0)
	GR.assign(0, "bun", 1, null)   # 空個幫工位俾收編嘅孤魂
	var b0 = R.buns; var ng0 = S.ghosts.size()
	var fr = GR.feed(0, "zhiren", true)
	_chk("派宵夜成功", 1.0 if fr.ok else 0.0, 1.0)
	_chk("派宵夜扣壽包 = 30 × (1 + 0.5 × 0)", b0 - R.buns, 30.0)
	_chk("收編：名冊 +1", float(S.ghosts.size() - ng0), 1.0)
	_chk("收編：雜鬼數 +1", J.num(J.cl(J.G.get("fodderCount"), null, [])) - fc0, 1.0)
	var gh = fr.gh
	_p("收編咗：%s（%s，%s）→ 派去 %s" % [J.str(gh.name), J.str(gh.k), J.str(gh.q), str(fr.slot)])
	_chk("收編咗嘅鬼用返孤魂個樣（zhiren）", 1.0 if J.str(gh.k) == "zhiren" else 0.0, 1.0)
	_chk("自動做幫工（post = garrison）", 1.0 if J.str(gh.post) == "garrison" else 0.0, 1.0)
	_chk("填咗壽包檔空幫工位", 1.0 if J.seq(GR.ms(0).posts.bun[1], gh.id) else 0.0, 1.0)
	var r = GR.raid(0)
	_chk("今晚走咗 2 隻", r.gone, minf(2.0, float(tot)))
	var share = maxf(0.0, float(tot) - minf(2.0, float(tot))) / float(tot)
	var rate2 = GR.theft_rate(0)   # 新幫工入咗守夜（如有）會改率
	var y2 = GR.yield_of(0).get("planks", 0.0)
	J.test_clock = J.num(g.t0) + (g.done + 1.0) * NM; GR.tick()
	var sp2 = minf(maxf(cap, 200.0), 200.0 + y2)
	_chk("有郁嘅晚：棺材板 = (存+產) × (1−率×剩低比例)", g.maps["0"].stock.planks, sp2 * (1.0 - rate2 * share))
	_chk("有郁嘅晚：壽包", g.maps["0"].stock.buns, 80.0 * (1.0 - rate2 * share))
	_p("偷嘢孤魂 %d 隻，走咗 2 隻 → 失竊 ×%.3f（率 %.4f）" % [tot, share, rate2])
	_chk("過咗晚：raid 清咗", 1.0 if g.maps["0"].raid == null else 0.0, 1.0)
	# 全部走晒之後再嚇：唔再扣
	J.test_clock = J.num(g.t0) + (g.done + 0.8) * NM; GR.tick()
	for i in 6: GR.raid_scare(0)
	_chk("嚇晒之後 raid_scare = false", 1.0 if GR.raid_scare(0) else 0.0, 0.0)
	_chk("剩低偷嘢孤魂 = 0", float(GR.thieves_left(0)), 0.0)
	# 名冊滿：食完就走
	S.bld["home"] = -100.0   # 名冊上限 < 0 → 冇位
	var ng1 = S.ghosts.size()
	var fr2 = GR.feed(0, "egui", false)
	_chk("名冊滿：派宵夜照得（ok）", 1.0 if fr2.ok else 0.0, 1.0)
	_chk("名冊滿：冇收編", float(S.ghosts.size() - ng1), 0.0)
	S.bld["home"] = 50.0
	R["buns"] = 5.0
	_chk("壽包唔夠：拒絕", 1.0 if GR.feed(0, "egui", false).ok else 0.0, 0.0)
	R["buns"] = 5000.0
	_p("===== 7. 升級＋招牌倍數 =====")
	GR.ms(0).lv["bun"] = 4.0
	var i4 = GR.income(0, "bun", false)
	var c10 = GR.up_cost_n(0, "bun", 10); var sum = {"planks": 0.0, "coins": 0.0}
	for lv in range(4, 14):
		var kmap = 1.0
		sum.planks += round(15.0 * pow(lv, 1.6) * kmap); sum.coins += round(20.0 * pow(lv, 1.7) * kmap)
	_chk("升 10 級總費（棺材板）", c10.planks, sum.planks)
	_chk("升 10 級總費（冥幣）", c10.coins, sum.coins)
	GR.upgrade(0, "bun")
	_chk("Lv5：收入 = Lv4 × lvmul(5)/lvmul(4) × 1.5", GR.income(0, "bun", false), i4 * _lvmul(5.0) / _lvmul(4.0) * 1.5)
	_chk("Lv5 招牌名＝熟手", 1.0 if GR.mile_name(5.0) == "熟手" else 0.0, 1.0)
	for i in 5: GR.upgrade(0, "bun")
	_chk("Lv10：倍數 1.5²", GR.mile(GR.lv_of(0, "bun")), 2.25)
	_chk("Lv10 收入 = Lv4 × lvmul(10)/lvmul(4) × 2.25", GR.income(0, "bun", false), i4 * _lvmul(10.0) / _lvmul(4.0) * 2.25)
	for i in 10: GR.upgrade(0, "bun")
	_chk("Lv20（封頂）", GR.lv_of(0, "bun"), 20.0)
	_chk("Lv20：倍數 1.5⁴", GR.mile(20.0), pow(1.5, 4))
	_chk("Lv20 招牌名＝老字號", 1.0 if GR.mile_name(20.0) == "老字號" else 0.0, 1.0)
	_chk("Lv20 再升：up_cost_n.n = 0", float(GR.up_cost_n(0, "bun", 10).n), 0.0)
	_chk("Lv20 每秒收入 = income/一晚×1000", GR.rate_ps(0, "bun"), GR.income(0, "bun") / NM * 1000.0)
	_p("驗算 %d 行，唔對 %d 行 → %s" % [rows, bad, "全部一致" if bad == 0 else "有錯"])
	J.test_clock = -1.0
	GR.quiet = false

# ---------------- 截圖 ----------------
func _scene(): return Engine.get_main_loop().root.get_node("Garrison").scene
func _frac(f: float) -> void:   # 將今晚設去 f（0–1），用假時鐘
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var g = GR.st(); J.test_clock = Time.get_unix_time_from_system() * 1000.0
	g["t0"] = J.test_clock - (J.num(g.done) + f) * GR.night_ms(); g["acc"] = J.test_clock
func shot_setup(_t) -> void:
	var TG = _setup(); var S = _S()
	S.bld["home"] = 50.0
	S.gar.front["buns"] = 600.0; S.gar.front["planks"] = 400.0
	GR.ms(0).lv["bun"] = 7.0; GR.ms(0).lv["rest"] = 3.0; GR.ms(0).lv["guard"] = 6.0
	GR.assign(0, "rest", 0, null)   # 歇腳檔冇管事 → 收銀箱
	GR.ms(0).till["rest"] = GR.till_cap(0, "rest") * 0.62
	GR.ms(0).stock["planks"] = 180.0
	_frac(0.3); GR.quiet = false
	var t0 = Time.get_ticks_usec()
	for i in 60: await Engine.get_main_loop().process_frame
	_p("perf（未開分村，村子畫面）：每格 %.2f ms" % ((Time.get_ticks_usec() - t0) / 1000.0 / 60.0))
	GR.open(0); _p("scene open")
func shot_sheet(_t) -> void: _scene().open_sheet("bun"); _p("sheet")
func shot_close_sheet(_t) -> void: _scene().close_sheet()
func shot_mile(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	_scene().close_sheet(); GR.ms(0).lv["rest"] = 4.0
	_scene().open_sheet("rest"); _scene().do_upgrade("rest", 1); _p("milestone")
func shot_raid(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	_scene().close_sheet()
	GR.assign(0, "guard", 0, null)   # 撤走守夜管事 → 擋唔晒，有孤魂偷嘢
	GR.ms(0).lv["guard"] = 1.0
	_frac(0.845); _p("raid frac=%.2f thieves=%d" % [GR.night_frac(), GR.thieves_n(0)])
func shot_feed(_t) -> void: _scene()._feed_tap(); _p("feed")
func shot_scare(_t) -> void:
	var sc = _scene()
	for l in sc.lone:
		if l.st in ["walk", "steal"]: sc._tap_lone(l); break
	_p("scare")
func shot_convoy(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	_frac(0.4); _scene().lone.clear(); _scene().convoy_anim("depart"); _p("convoy")
func shot_transit(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var g = GR.st(); g["convoy"] = {"buns": 100.0, "planks": 80.0, "res": {"buns": 0.0, "planks": 0.0}, "eta": J.num(g.done) + 2.0, "to": 1.0}
	_scene()._cv_key = "%d" % int(J.num(g.done) + 2.0); _scene().car = null; _scene()._drift = 300.0; _p("transit")
func shot_full(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	GR.ms(0).till["rest"] = GR.till_cap(0, "rest"); _p("till full")
func shot_collect(_t) -> void: _scene()._collect("rest"); _p("collect")
func shot_picker(_t) -> void: _scene()._open_picker("rest", 0); _p("picker")
func shot_close_picker(_t) -> void: _scene()._close_picker()
func shot_map1(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison")
	var S = _S(); S.cleared["2-1"] = true; S.cleared["2-2"] = true; S.cleared["2-3"] = true; GR.tick()
	GR.assign(1, "bun", 0, "t_qg"); GR.assign(1, "bun", 1, "t_yh1"); GR.assign(1, "rest", 0, "t_dx")
	GR.open(1); _p("map1")
func shot_panel(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison"); GR.open_panel(1)
	var pn = GR.panel; var sc = GR.scene
	_p("old panel：panel 父=%s idx=%d visible=%s；scene idx=%d" % [pn.get_parent().name, pn.get_index(), pn.visible, sc.get_index()])
func shot_end(_t) -> void:
	GR = Engine.get_main_loop().root.get_node("Garrison"); GR.close(); J.test_clock = -1.0
# 效能：滿場（4 客×2 檔＋6 孤魂＋粒子）量 60 格平均
func perf(_t) -> void:
	var sc = _scene(); var t0 = Time.get_ticks_usec(); var n = 0
	for i in 60:
		await Engine.get_main_loop().process_frame; n += 1
	var dt = (Time.get_ticks_usec() - t0) / 1000.0 / n
	_p("perf：每格 %.2f ms（客 %d＋%d、孤魂 %d、粒子 %d）" % [dt, sc.cust.bun.size(), sc.cust.rest.size(), sc.lone.size(), sc.parts.size()])
func _pf(tag: String) -> void:
	var t0 = Time.get_ticks_usec()
	for i in 40: await Engine.get_main_loop().process_frame
	_p("perf[%s]：每格 %.2f ms" % [tag, (Time.get_ticks_usec() - t0) / 1000.0 / 40.0])
func perf2(_t) -> void:
	var sc = _scene()
	await _pf("全部")
	sc.stage.visible = false; await _pf("唔畫 stage"); sc.stage.visible = true
	var keep = sc.cust; sc.cust = {"bun": [], "rest": []}; sc.spawn_in = {"bun": 999.0, "rest": 999.0}; await _pf("冇客"); sc.cust = keep
	sc.set_process(false); await _pf("停 _process"); sc.set_process(true)
	sc.visible = false; await _pf("場景收埋"); sc.visible = true
func perf3(_t) -> void:
	var sc = _scene(); var Gr = Engine.get_main_loop().root.get_node("Garrison")
	var t0 = Time.get_ticks_usec()
	for i in 20: sc._recache()
	var t1 = Time.get_ticks_usec()
	for i in 20: Gr.accrue_live()
	var t2 = Time.get_ticks_usec()
	for i in 20: sc._refresh_hud()
	var t3 = Time.get_ticks_usec()
	for i in 200: sc._step_stall("bun", 0.016); sc._step_stall("rest", 0.016); sc._step_lone(0.016); sc._step_misc(0.016)
	var t4 = Time.get_ticks_usec()
	_p("perf3：recache %.2f ms、accrue %.2f ms、hud %.2f ms、step %.3f ms／格；鬼數 %d" % [(t1 - t0) / 20000.0, (t2 - t1) / 20000.0, (t3 - t2) / 20000.0, (t4 - t3) / 200000.0, _S().ghosts.size()])
