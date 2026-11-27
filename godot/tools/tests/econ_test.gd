# [ux] 前期經濟／節奏／庫存可見 專項測試
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/econ_test.gd","logic"],["quit"]]
#   logic：模擬新手前 30 分鐘資源流（後院 T1/T2 ＋ 嘆氣蒸籠 T3），對比舊／新升級成本；節奏階段；倉庫監察
#   view ：倉庫總覽面板（直屏＋闊屏截圖由 shot 做）
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const SW = preload("res://game/econ/stock_watch.gd")
const PACE = preload("res://game/econ/pace.gd")
const NG = preload("res://native/game.gd")
var bad := 0
var rows := 0
var _saved := {}
func _p(s) -> void: print("[econ] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[econ]   %-44s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _S(): return J.G.get("S")

func _setup(lv := 3) -> void:
	var S = _S()
	J.test_clock = 1.9e12
	S["lv"] = float(lv); S.erase("mv"); S["mat"] = {}
	for k in ["wood", "rice", "planks", "buns", "coins"]: S.res[k] = 0.0
	S.res["wood"] = 60.0; S.res["rice"] = 60.0; S.res["coins"] = 100.0
	for b in ["wood", "rice", "plank", "bun", "house", "store", "home"]: S.bld[b] = 1.0
	S.ghosts = S.ghosts.filter(func(g): return not str(g.get("id")).begins_with("t_ec"))
	for g in S.ghosts: if str(g.k) != "afu": g["post"] = null
	var posts = ["wood", "rice", "plank", "bun", null]
	for i in posts.size():
		S.ghosts.append({"id": "t_ec%d" % i, "k": "zhiren", "name": "測試鬼%d" % i, "q": "藍", "lv": 1.0, "st": [30.0, 30.0, 30.0], "post": posts[i], "spent": 0.0})
	SW.reset()

func logic(_t) -> void:
	_saved = _S().duplicate(true)
	flow()
	upgrade()
	pace()
	watch()
	var S = _S()
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	PACE.force = -1; J.test_clock = -1.0
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])

var _hist := []
func flow() -> void:
	_p("===== 1. 新手前 30 分鐘資源流（後院 4 隻鬼＋嘆氣蒸籠 1 員工）=====")
	_setup(3)
	var S = _S()
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	sim.plus.off = true; sim.plus.test_off = true
	if sim.st().st.has("st_shoubao"):
		sim.st().st.st_shoubao.unlocked = true
		sim.assign("st_shoubao", 0, "t_ec4")
	_hist.clear()
	var sold0 = 0.0; var made0 = 0.0
	for sec in 1800:
		NG.produce(1.0)
		for i in 4:
			J.test_clock += 250.0
			sim.step(0.25); sim.ev.clear()
		SW.sample()
		if sec % 60 == 59:
			_hist.append({"t": (sec + 1) / 60, "wood": S.res.wood, "rice": S.res.rice, "plank": S.res.planks, "bao": M.amt("m_bao"), "buns": S.res.buns, "coins": S.res.coins})
	for h in _hist:
		if int(h.t) % 5 == 0: _p("  第 %2d 分鐘：槐木 %d 糯米 %d 棺材板 %d 普通包子 %d 壽包 %d 冥幣 %d" % [h.t, h.wood, h.rice, h.plank, h.bao, h.buns, h.coins])
	var last = _hist[_hist.size() - 1]
	_chk("30 分鐘槐木有增加", last.wood > 60.0, last.wood)
	_chk("30 分鐘普通包子／壽包有產出", last.bao + last.buns > 5.0, [last.bao, last.buns])
	_chk("冥幣有增加（賣貨）", last.coins > 100.0, last.coins)
	_flow_last = last

var _flow_last := {}
func upgrade() -> void:
	_p("===== 2. 升級成本：舊（全壽包）vs 新（Lv10 前冥幣＋普通包子）=====")
	var old_tot = 0.0; var nc = 0.0; var nb = 0.0
	for lv in range(1, 10):
		old_tot += NG.lv_cost(lv)
		var p = NG.lv_pay(lv); nc += J.num(p.get("coins")); nb += J.num(p.get("bao"))
		_p("  Lv%d→%d　舊：壽包 %d　新：%s" % [lv, lv + 1, int(NG.lv_cost(lv)), NG.pay_plain(p)])
	_p("  一隻鬼 Lv1→10 合計　舊：壽包 %d　新：冥幣 %d＋普通包子 %d" % [old_tot, nc, nb])
	var L = _flow_last
	var buns30 = J.num(L.get("buns")); var bao30 = J.num(L.get("bao")); var coin30 = J.num(L.get("coins"))
	var old_n = 0; var acc = 0.0
	for lv in range(1, 20):
		acc += NG.lv_cost(lv)
		if acc <= buns30: old_n += 1
	var new_n = 0; var ac = 0.0; var ab = 0.0
	for lv in range(1, 10):
		var p = NG.lv_pay(lv); ac += J.num(p.get("coins")); ab += J.num(p.get("bao"))
		if ac <= coin30 and ab <= bao30: new_n += 1
	_p("  30 分鐘庫存（壽包 %d、普通包子 %d、冥幣 %d）可升幾級　舊 %d 級　新 %d 級" % [buns30, bao30, coin30, old_n, new_n])
	_chk("新規則前 30 分鐘升到的級數比舊規則多", new_n > old_n, [old_n, new_n])
	_chk("Lv10 起改用壽包", J.num(NG.lv_pay(10).get("buns")) > 0 and NG.lv_pay(10).get("bao") == null, NG.lv_pay(10))
	# 實際升一級：扣冥幣＋普通包子，唔扣壽包
	_setup(3); var S = _S()
	S.res.coins = 999.0; S.res.buns = 50.0; M.add("m_bao", 50.0)
	var g = S.ghosts.filter(func(x): return str(x.id) == "t_ec4")[0]
	NG.n_roster_act("up", "t_ec4")
	_chk("升級：Lv1→2", J.num(g.lv) == 2.0, g.lv)
	_chk("升級：冇扣壽包", J.num(S.res.buns) == 50.0, S.res.buns)
	_chk("升級：扣咗普通包子", M.amt("m_bao") < 50.0, M.amt("m_bao"))
	_chk("升級：扣咗冥幣", J.num(S.res.coins) < 999.0, S.res.coins)

func pace() -> void:
	_p("===== 3. 前期節奏（安頓期／練手期／正常）=====")
	_setup(1); PACE.force = -1
	_chk("主公 Lv1、第 1 圖＝安頓期", PACE.phase() == 0, PACE.phase())
	_chk("安頓期：冇鬼潮、冇告急、冇襲擾", not PACE.wave_on() and not PACE.alarm_on() and not PACE.raid_on())
	_chk("安頓期：襲擾 hold_reason = pace（或新手）", load("res://game/raid/raid.gd").hold_reason() in ["pace", "newbie", "story", "battle"], load("res://game/raid/raid.gd").hold_reason())
	_S()["lv"] = 4.0
	_chk("主公 Lv4＝練手期", PACE.phase() == 1)
	_chk("練手期鬼潮 8 分鐘一波", PACE.wave_gap() == 480.0, PACE.wave_gap())
	_chk("練手期告急倒數 5 分鐘", PACE.alarm_t() == 300.0)
	_chk("練手期襲擾間隔 ×1.8", PACE.raid_mul() == 1.8)
	_S()["lv"] = 6.0
	_chk("主公 Lv6＝正常（原數值 4 分鐘）", PACE.phase() == 2 and PACE.wave_gap() == 240.0)
	_S()["lv"] = 1.0; _S()["pace_lock"] = {"wave": true}; _S()["lv"] = 8.0
	_chk("功能開關：pace_lock.wave 鎖住鬼潮", not PACE.wave_on())
	_S().erase("pace_lock")
	# 鬼潮計時：安頓期唔減
	_setup(1)
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0); sim.plus.off = true; sim.plus.test_off = true
	var w = sim.war.ws()
	if w is Dictionary:
		w.wave_t = 50.0
		for i in 200: sim.war._step_wave(sim, w, 0.5)
		_chk("安頓期鬼潮倒數唔會跌到 0", J.num(w.wave_t) >= PACE.wave_first() - 0.01 and sim.war.wave == null, w.wave_t)
		_chk("安頓期 newbie()（唔告急、唔偷嘢）", sim.war.newbie())
	else: _chk("war 狀態存在", false)

func watch() -> void:
	_p("===== 4. 庫存監察（倉庫總覽數據）=====")
	_setup(3)
	SW.reset()
	for i in 30:
		NG.produce(1.0); SW.sample()
	var r = SW.rate("m_wood")
	_chk("槐木每分鐘產出 > 0", r[0] > 0.0, r)
	_chk("糯米有進出記錄", SW.rate("m_rice")[0] + SW.rate("m_rice")[1] > 0.0, SW.rate("m_rice"))
	_chk("頂欄 +n 有待冒數（槐木）", SW.take_pending("m_wood", 0.1) > 0.0)
	_chk("壽包用途有列（升級／口糧）", load("res://game/econ/store_view.gd").EXTRA_USE.m_shoubao.size() >= 2)
	var srcs = SW.sources("m_shoubao")
	_chk("壽包來源包括嘆氣蒸籠", srcs.has("嘆氣蒸籠"), srcs)

func view(_t) -> void:
	var main = J.G.get("Main") if J.G.get("Main") != null else Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: _chk("Main 存在", false); _p("RESULT ok=%d bad=%d" % [rows - bad, bad]); return
	for i in 5: SW.sample()
	main.open_store("buns", "壽包說明")
	await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	var v = main.get_node_or_null("StoreView")
	_chk("倉庫總覽打開", v != null)
	if v != null:
		_chk("在高層（layer ≥ 100）", v.layer >= 100, v.layer)
		_chk("壽包嗰行存在（三級分頁）", v.find_child("Row_m_shoubao", true, false) != null)
		v.tab = 0; v._render()
		await Engine.get_main_loop().process_frame
		_chk("一級分頁有槐木", v.find_child("Row_m_wood", true, false) != null)
		v.tab = 4; v._render()
		await Engine.get_main_loop().process_frame
		_chk("其他分頁有冥幣", v.find_child("Row_coins", true, false) != null)
		var img = Engine.get_main_loop().root.get_viewport().get_texture().get_image()
		var out = OS.get_environment("GB_SHOT_DIR")
		if out != "": v.tab = 2; v._render(); await Engine.get_main_loop().process_frame; await Engine.get_main_loop().process_frame; Engine.get_main_loop().root.get_viewport().get_texture().get_image().save_png(out + "/store_view.png")
		v.close()
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])
