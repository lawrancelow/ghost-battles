# [market] 過勞鬼市集 M1：改名、按章五條街、切街（名牌列撳／滑）、台位重排、只畫當前街、鎖街、
#   系統／原料台剔走＋目標跳過、市集 KPI ①②③ 開街、過勞營業核心（加班、趴低、餵包子、升職）、防守簡化（只停被霸攤、街冷卻、遊魂兵自動清）、
#   要貨泡排頭 2、閒聊泡 1
# 用法：bash /home/claude/gbslot.sh bash godot/tools/devkit/edtest.sh <godot目錄> market res://tools/tests/market_test.gd all 700
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const MK = preload("res://game/market/mk_data.gd")
const MKU = preload("res://game/market/mk_ui.gd")
const MKO = preload("res://game/market/mk_ops.gd")
const MKOU = preload("res://game/market/mk_ops_ui.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const KG = preload("res://game/kpi/kpi_data.gd")
const M = preload("res://game/outpost/mat.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var SHOTS := (OS.get_environment("MK_SHOTS") if OS.has_environment("MK_SHOTS") else "/home/claude/meeting/market/shots/")   # M2 線跑時另存，唔好冚 M1 嘅圖

func _p(m): print("[market] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sc = m.mv_view; var sim = sc.sim; var nv = m.village; var cam = nv.zone_cam()
	var S = J.G.S
	_rename()
	# ---- 未開市集模式（GB_TEST 預設）：原版行為不變 ----
	_chk("GB_TEST 預設唔開市集模式（其他測試照舊）", not MK.active())
	var raw0 = MD.stations_raw(0)
	_chk("未開：stations＝原版", MD.stations(0) == raw0, MD.stations(0).size())
	# ---- 開市集模式 ----
	MK.st()["test"] = 1
	_chk("S.mk.test＝1：開市集模式", MK.active())
	var c = sim.ci()
	_chk("五條街：食街／衣街／兵器街／飾品街／奢侈品店", MK.ids() == ["food", "cloth", "weapon", "acc", "lux"], MK.ids())
	for ci in 6:
		var L = MK.stall_list(ci)
		var bad_rm = []
		for sid in L: if MK.removed().has(sid): bad_rm.append(sid)
		var sig_ok = L.has("st_shoubao") and L.has("st_zhishan") and L.has("st_bingqi")
		_chk("第 %d 章：攤位按章載入、招牌三樣在、無系統／原料台" % (ci + 1), sig_ok and bad_rm.is_empty() and L.size() >= 5, [L.size(), bad_rm])
	_chk("每章商品唔同（第 1 章 vs 第 6 章特色攤無重疊，招牌除外）", _uniq(0, 5))
	_chk("椰殼炭降原料：第 2 章唔再擺攤", not MK.stall_list(1).has("st_yeketan"))
	_chk("匯兌／表格室／打卡鐘／船票改系統：唔擺攤", not MK.stall_list(3).has("st_duihuan") and not MK.stall_list(3).has("st_chuanpiao") and not MK.stall_list(5).has("st_biaoge") and not MK.stall_list(5).has("st_daka"))
	_chk("磚窯棺材板床移去第 3 章奢侈品", not MK.stall_list(0).has("st_guancaichuang") and MK.street_of(2, "st_guancaichuang") == "lux")
	# 目標跳過
	var gi = -1
	for i in MD.goals(0).size(): if str(MD.goals(0)[i].get("k", "")) == "st_guancaichuang": gi = i
	if c == 0 and gi >= 0: _chk("第 1 章「開磚窯棺材板床」目標當跳過（唔畀獎）", sim.goal_claimed(gi))
	# ---- 開街 ----
	KG.enable(false)
	MK.st().open = {}
	_chk("食街預設開", MK.is_open("food"))
	_chk("衣街預設鎖（KPI 未開時照 market.json）", not MK.is_open("cloth"))
	_chk("第 1 章奢侈品店：裝修中", not MK.is_open("lux") and MK.lock_text("lux", 0).find("裝修") >= 0, MK.lock_text("lux", 0))
	MK.set_open("cloth"); MK.set_open("weapon")
	_chk("set_open 開衣街／兵器街", MK.is_open("cloth") and MK.is_open("weapon"))
	# 市集 KPI ①②③ 喺 kpi.json
	var g1 = KG.gate("mk1", 0); var g3 = KG.gate("mk3", 0)
	_chk("市集 KPI ①②③：考核官甄好賣、開衣／兵器／飾品街", str(g1.get("boss_n")) == "甄好賣" and str(g1.get("opens")) == "flag:mk_cloth" and str(KG.gate("mk2", 0).get("opens")) == "flag:mk_weapon" and str(g3.get("opens")) == "flag:mk_acc")
	var has_patrol = false
	for n in g3.get("need", []): if str(n.get("key")) == "mk_patrol_done": has_patrol = true
	_chk("市集 KPI ③ 含「巡邏處理事件 5 次」", has_patrol)
	_chk("市集 KPI 指標已登記（食街總等級＞0）", KG._metric("mk_food_lv", "fn") > 0.0, KG._metric("mk_food_lv", "fn"))
	# ---- 切街、台位重排 ----
	sim.market_street("food"); await _w(t, 0.2)
	var food = MK.sids_on(c, "food"); var slots = MK.base_slots(c)
	var pos_ok = true
	for i in food.size(): if sim.st_pos(food[i]).distance_to(MD.st_xy(c, slots[i])) > 1.0: pos_ok = false
	_chk("食街：台佔本章頭幾個台位", pos_ok and food.size() > 0, food)
	_chk("只畫當前街：食街台 shown、衣街台唔 shown", MK.shown(c, food[0]) and not MK.shown(c, MK.sids_on(c, "cloth")[0]))
	# 鏡頭去市集，截圖
	sc.hud_k = 1.0
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	cam.center_on(sim.st_pos(food[0]) + Vector2(0, 60)); await _w(t, 0.6); await _shot(t, "m1_food")
	# 撳名牌列：去衣街
	var r = sc._btns.get("mks:cloth")
	_chk("街名牌列有畫（衣街名牌）", r is Rect2, r)
	if r is Rect2:
		MKU.tap(sc, r.get_center()); await _w(t, 0.3)
	_chk("撳衣街名牌：切到衣街", MK.cur() == "cloth", MK.cur())
	var cloth = MK.sids_on(c, "cloth")
	_chk("衣街台搬去頭位", cloth.size() > 0 and sim.st_pos(cloth[0]).distance_to(MD.st_xy(c, slots[0])) < 1.0)
	cam.center_on(sim.st_pos(cloth[0]) + Vector2(0, 60)); await _w(t, 0.5); await _shot(t, "m2_cloth")
	# 滑動：向左拉 → 下一條街
	var sr = MKU.strip_rect(sc)
	var k = float(sc.k)
	var d = InputEventMouseButton.new(); d.button_index = MOUSE_BUTTON_LEFT; d.pressed = true; d.position = (sr.get_center()) * k
	var mm = InputEventMouseMotion.new(); mm.position = (sr.get_center() + Vector2(-60, 0)) * k
	var u = InputEventMouseButton.new(); u.button_index = MOUSE_BUTTON_LEFT; u.pressed = false; u.position = (sr.get_center() + Vector2(-90, 0)) * k
	var a1 = MKU.swipe(sc, d, k); MKU.swipe(sc, mm, k); MKU.swipe(sc, u, k)
	_chk("街名牌列向左滑：去下一條街（兵器街）", a1 and MK.cur() == "weapon", MK.cur())
	# 鎖街
	sim.market_street("acc"); await _w(t, 0.4)
	_chk("飾品街鎖住：台唔畫、出鎖牌", not MK.is_open("acc") and sc._btns.has("mk_lock"))
	await _shot(t, "m3_locked")
	sim.market_street("lux"); await _w(t, 0.4); await _shot(t, "m4_lux_reno")
	sim.market_street("food"); await _w(t, 0.3)
	# ---- 過勞營業核心 ----
	var sid = food[0]
	if sim.st().st.get(sid) is Dictionary: sim.st().st[sid]["unlocked"] = true
	_chk("未加班：倍數 1", is_equal_approx(MK.mul(sid), 1.0 + MK.otf("rank_bonus", 0.1) * MK.rank(sid)))
	MK.toggle_ot(sid)
	_chk("開加班：倍數 ×2、ot_on", MK.ot_on(sid) and MK.mul(sid) >= 2.0, MK.mul(sid))
	MK.tick([sid], 10.0)
	_chk("加班 10 秒：過勞值上升", MK.fat(sid) > 5.0, MK.fat(sid))
	MK.tick([sid], 200.0)
	_chk("過勞值滿：趴低、停工（倍數 0）、加班自動關", MK.is_down(sid) and MK.mul(sid) == 0.0 and not MK.ot_on(sid))
	var evs = MK.pop_events()
	_chk("趴低事件", evs.any(func(e): return e.k == "down"))
	M.add("m_bao", 5)
	_chk("餵普通包子：即刻復工、過勞值回落", MK.feed(sid) == "ok" and not MK.is_down(sid) and MK.fat(sid) <= MK.otf("reset_fat", 40.0) + 0.1)
	MK.ot(sid).xp = 0.0; MK.ot(sid).rank = 0
	MK.toggle_ot(sid)
	for i in 40: MK.tick([sid], 50.0); if MK.is_down(sid): MK.feed(sid); M.add("m_bao", 2); MK.ot(sid).on = 1
	_chk("加班累積：老員工升職（rank≥1）、倍數多 +%d%%" % int(MK.otf("rank_bonus", 0.2) * 100), MK.rank(sid) >= 1, MK.rank(sid))
	MK.ot(sid).on = 0; MK.ot(sid).fat = 0.0; MK.ot(sid).down = 0.0
	# ---- 防守簡化 ----
	var w = MVW.ws()
	w.occ[str(c)] = sid
	_chk("被霸：只停被霸攤（其他攤照開）", sim.war.blocked(sim, sid) and not sim.war.blocked(sim, food[1] if food.size() > 1 else cloth[0]))
	MK.on_occupy(c, sid)
	_chk("呢條街入冷卻：同街其他攤唔會再霸", not MK.can_occupy(c, food[min(1, food.size() - 1)]))
	_chk("其他已開街照可以霸", MK.can_occupy(c, cloth[0]))
	_chk("遊魂兵唔夠：唔自動清", not MK.patrol_clear(30.0, 2))
	_chk("遊魂兵夠（≥12）＋10 秒：自動清", MK.patrol_clear(11.0, 20))
	w.occ.erase(str(c))
	# ---- 氣泡上限 ----
	_chk("要貨泡：排頭 2 位", sc.WANT_MAX == 2)
	for i in 4: sc._bubble(sim.st_pos(sid), "測試%d" % i, "鬼", 2.0)
	_chk("閒聊泡：合一地圖同時最多 1 個", sc.bubbles.size() <= 1, sc.bubbles.size())
	await _ops(t, sim, sc, c, food, cloth)
	MK.st().erase("test")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- M1 營運：店員位、雙貨、櫃檯、巡邏（0–4）、常態事件、15% 上限 ----
func _gh(S, id: String) -> void:
	for g in S.ghosts: if str(J.gp(g, "id")) == id: return
	S.ghosts.append({"id": id, "k": "youhun", "name": id, "lv": 1.0, "post": null})
func _ops(t, sim, sc, c: int, food: Array, cloth: Array) -> void:
	var S = J.G.S
	sim.paused = true   # 測試自己推時間（MKO.tick），唔畀即時模擬插手
	MKO.rng.seed = 20261128
	MK.st().erase("ops"); MK.st()["patrol_done"] = 0
	for i in 12: _gh(S, "t_mk%d" % i)
	var a = food[0]; var b = food[1] if food.size() > 1 else cloth[0]
	for sid in food: sim.sst(sid)["unlocked"] = true
	# 店員位
	var sl = []
	for lv in [1, 9, 10, 25, 50, 100, 200]: sl.append(MKO.staff_slots(a, float(lv)))
	_chk("店員位按等級 1/1/2/3/3/4/5（Lv1/9/10/25/50/100/200）", sl == [1, 1, 2, 3, 3, 4, 5], sl)
	_chk("extra_slots＝店員位−1（Lv200＝4）", MKO.extra_slots(a, 200.0) == 4 and MKO.extra_slots(a, 1.0) == 0)
	_chk("產能倍數 1／1.35／1.70／1.95／2.20（遞減）", is_equal_approx(MKO.staff_mul(1), 1.0) and is_equal_approx(MKO.staff_mul(2), 1.35) and is_equal_approx(MKO.staff_mul(3), 1.7) and is_equal_approx(MKO.staff_mul(4), 1.95) and is_equal_approx(MKO.staff_mul(5), 2.2))
	var lux = MK.sids_on(2, "lux")
	if lux.size():
		var ci0 = sim.st().ci; sim.st().ci = 2.0
		_chk("奢侈品店最多 2 名店員", MKO.staff_slots(lux[0], 200.0) == 2, MKO.staff_slots(lux[0], 200.0))
		sim.st().ci = ci0
	sim.sst(a).lv = 1.0
	for i in 3: sim.assign(a, i, "t_mk%d" % i)
	MKO.tick(sim, 0.1)
	_chk("Lv1 只留 1 名店員，多出嘅放返村（post 清空）", sim.nworkers(a) == 1 and not J.t(J.gp(sim.ghost("t_mk2"), "post")), sim.nworkers(a))
	sim.sst(a).lv = 200.0; MKO.tick(sim, 0.1)
	_chk("Lv200：店員位陣列擴到 5", sim.sst(a).workers.size() >= 5, sim.sst(a).workers.size())
	for i in 5: sim.assign(a, i, "t_mk%d" % i)
	MKO.tick(sim, 0.1)
	_chk("5 名店員：每人速度＝2.2÷5", sim.nworkers(a) == 5 and is_equal_approx(MKO.prod_k(a), 2.2 / 5.0), [sim.nworkers(a), MKO.prod_k(a)])
	for i in 5: sim.assign(a, i, null)
	sim.assign(a, 0, "t_mk0")
	# 雙貨
	sim.sst(a).lv = 24.0
	_chk("Lv24：副貨未開", not MKO.sub_open(a) and MKO.set_sub(c, a, "x") == "locked")
	sim.sst(a).lv = 25.0
	sim.sst(b)["unlocked"] = false   # b 未開攤 → 佢隻貨可以做 a 嘅副貨
	var ch = MKO.sub_choices(c, a); var gb = MKO.good_of(b)
	_chk("Lv25：副貨開、可揀同街未開攤嘅貨", MKO.sub_open(a) and ch.has(gb), ch)
	_chk("唔可以揀其他街嘅貨", MKO.set_sub(c, a, MKO.good_of(cloth[0])) == "bad")
	_chk("揀副貨成功", MKO.set_sub(c, a, gb) == "ok" and MKO.sub_of(a) == gb and MKO.host_of(gb) == a)
	_chk("換貨中 10 秒唔產出", MKO.prod_k(a) == 0.0 and MK.mul(a) == 0.0)
	MKO.tick(sim, 10.5)
	_chk("10 秒後復產", MKO.prod_k(a) > 0.0)
	_chk("副貨上櫃台清單、可以招客", sim.goods_list().has(gb))
	MKO.set_smart(a, false); MKO.set_ratio(a, 0.5)
	var ns = 0
	for i in 20: if MKO.pick_sub(sim, a): ns += 1
	_chk("產能 50／50：20 轉有 10 轉副貨", ns == 10, ns)
	MKO.set_ratio(a, 0.3); ns = 0
	for i in 20: if MKO.pick_sub(sim, a): ns += 1
	_chk("滑桿 30%：20 轉有 6 轉副貨", ns == 6, ns)
	MKO.set_smart(a, true); MKO.set_ratio(a, 0.0)
	sim.st().counter[MKO.good_of(a)] = 10.0; sim.st().counter[gb] = 0.0
	_chk("智能補貨：副貨格缺貨就先做副貨", MKO.pick_sub(sim, a))
	_chk("副貨單價＝副貨底價 × 寄賣攤等級倍數（＞0）", MKO.sub_val(sim, gb) > 0.0, MKO.sub_val(sim, gb))
	var cst = {"got": {gb: 2}, "wants": {gb: 2}}
	_chk("客人買副貨：按副貨價計錢", is_equal_approx(sim.cust_value(cst), 2.0 * MKO.sub_val(sim, gb) * sim.inc_mul() * load("res://game/market/mk_fun.gd").item_mul(sim, a)), sim.cust_value(cst))
	MKO.set_sub(c, a, ""); MKO.tick(sim, 11.0)
	sim.sst(b)["unlocked"] = true
	# 預設副貨配對（goods_final）：副貨攤唔再獨立擺攤，Lv25 自動成為主攤副貨
	_chk("第 1 章配對：豆花擔併入枯井豆花攤（唔再獨立擺攤）", MKO.sub_only(0).get("st_tiaodan", "") == "st_douhua" and not MK.stall_list(0).has("st_tiaodan") and MK.stall_list(0).has("st_douhua"), MK.stall_list(0))
	if c == 0:
		sim.sst("st_douhua")["unlocked"] = true; sim.sst("st_douhua").lv = 24.0
		var g_td = MKO.good_of("st_tiaodan")
		_chk("枯井豆花攤 Lv24：未有副貨、豆花擔未上架", MKO.sub_of("st_douhua") == "" and not sim.goods_list().has(g_td))
		sim.sst("st_douhua").lv = 25.0
		_chk("枯井豆花攤 Lv25：預設副貨＝豆花擔，上架", MKO.sub_of("st_douhua") == g_td and sim.goods_list().has(g_td) and MKO.host_of(g_td) == "st_douhua", MKO.sub_of("st_douhua"))
		_chk("玩家可以揀唔賣副貨", MKO.set_sub(0, "st_douhua", "") == "ok" and MKO.sub_of("st_douhua") == "")
		MKO.st().sub.erase("st_douhua"); MKO.tick(sim, 11.0); sim.sst("st_douhua").lv = 1.0
	var st_n = []
	for ci in 6: st_n.append(MK.stall_list(ci).size())
	_p("各章攤數（配對後、未計新台）：" + str(st_n))
	# 櫃檯
	_chk("mk_counter_n_fn 已登記（M2 接口）", J.G.get("mk_counter_n_fn") is Callable and int(J.G.mk_counter_n_fn.call("food")) == 0)
	var c0 = sim.coins()
	sim.add_coins(500.0); MKO.on_pay(sim, {"got": {MKO.good_of(a): 1}}, 500.0)
	_chk("客人俾錢：先入收銀箱，未入帳", is_equal_approx(sim.coins(), c0) and is_equal_approx(MKO.till("food"), 500.0), [sim.coins() - c0, MKO.till("food")])
	for i in 19: MKO.tick(sim, 1.0)
	_chk("冇櫃檯員：19 秒仲未收", MKO.till("food") > 0.0)
	MKO.tick(sim, 1.5)
	_chk("冇櫃檯員：20 秒店員去收一次，錢入帳", MKO.till("food") == 0.0 and is_equal_approx(sim.coins(), c0 + 500.0))
	_chk("店員去收錢：全街停產 3 秒", MKO.prod_k(a) == 0.0)
	MKO.tick(sim, 3.5)
	_chk("3 秒後復產", MKO.prod_k(a) > 0.0)
	var r = []
	for i in 4: r.append(MKO.assign(sim, "ctr", "food", "t_mk%d" % (5 + i)))
	_chk("櫃檯每街最多 3 人（第 4 個 full）", r == ["ok", "ok", "ok", "full"] and MKO.counter_n("food") == 3 and int(J.G.mk_counter_n_fn.call("food")) == 3, r)
	_chk("櫃檯員由村子調走（post＝mk_ctr）", str(J.gp(sim.ghost("t_mk5"), "post")) == "mk_ctr")
	sim.add_coins(300.0); MKO.on_pay(sim, {"got": {MKO.good_of(a): 1}}, 300.0)
	MKO.tick(sim, 1.0); MKO.tick(sim, 1.2)
	_chk("3 名櫃檯員：約 2 秒自動入帳、唔停產", MKO.till("food") == 0.0 and MKO.prod_k(a) > 0.0)
	sim.add_coins(100.0); MKO.on_pay(sim, {"got": {MKO.good_of(a): 1}}, 100.0)
	_chk("玩家撳收銀箱：即收", is_equal_approx(MKO.collect(sim, "food"), 100.0) and MKO.till("food") == 0.0)
	_chk("未開嘅街唔可以派人", MKO.assign(sim, "ctr", "acc", "t_mk9") == "closed")
	_chk("結帳等候：3 名櫃檯員 0.3 秒、1 名 0.9 秒、冇人 2.5 秒", is_equal_approx(MKO.pay_wait("food"), 0.3) and is_equal_approx(MKO.pay_wait("cloth"), 2.5), [MKO.pay_wait("food"), MKO.pay_wait("cloth")])
	var cw = {"wants": {MKO.good_of(a): 1}, "got": {MKO.good_of(a): 1}}; var holds = 0
	for i in 40: if MKO.hold_pay(sim, cw): holds += 1
	_chk("3 名櫃檯員：客人等 1 拍就結帳", holds == 1, holds)
	# 巡邏隊 0–4
	for i in 3: MKO.unassign(sim, "t_mk%d" % (5 + i))
	sim.assign(b, 0, "t_mk4")
	r = []
	for i in 5: r.append(MKO.assign(sim, "pat", "food", "t_mk%d" % (4 + i)))
	_chk("巡邏每街最多 4 隻鬼（第 5 隻 full）", r == ["ok", "ok", "ok", "ok", "full"] and MKO.patrol_n("food") == 4, r)
	_chk("巡邏員由崗位調走：原本喺攤做嘢嘅鬼離開個攤", sim.nworkers(b) == 0 and str(J.gp(sim.ghost("t_mk4"), "post")) == "mk_pat")
	_chk("市集佔用村鬼數", MKO.village_cost() == 4, MKO.village_cost())
	J.sp(sim.ghost("t_mk7"), "post", null); MKO.tick(sim, 0.1)
	_chk("鬼被調走／冇咗：自動由巡邏名單剔走", MKO.patrol_n("food") == 3)
	for i in 4: MKO.unassign(sim, "t_mk%d" % (4 + i))
	_chk("撤走：post 清空", MKO.patrol_n("food") == 0 and not J.t(J.gp(sim.ghost("t_mk4"), "post")))
	# 常態事件
	MK.st().erase("ops"); MKO.tick(sim, 0.1)
	for i in 170: MKO.tick(sim, 1.0)
	_chk("新手保護：開張頭 3 分鐘冇事件", MKO.events().is_empty(), MKO.events().size())
	for i in 12: MKO.tick(sim, 1.0)
	var ev = MKO.events()
	_chk("第 3 分鐘：固定第一件插隊（教學、通用版）", ev.size() >= 1 and str(ev[0].k) == "cut_queue" and int(ev[0].sp) == 0 and J.t(ev[0].get("tut")), ev)
	_chk("玩家撳事件：即刻處理、名聲 +2", ev.size() >= 1 and MKO.handle_event(sim, int(ev[0].id)) and MKO.events().is_empty() and J.num(MK.st().get("renown_pts", 0)) + load("res://game/market/mk_renown.gd").pts() >= 2.0)   # M2 合併後名聲入 mk_renown
	MKO.st().ev.clear()
	var n_ok = 0
	for i in 8: if not MKO.spawn_event(sim, "food").is_empty(): n_ok += 1
	_chk("同一條街最多 2 件未處理事件", n_ok == 2 and MKO.events("food").size() == 2, n_ok)
	MK.set_open("cloth"); for sid in cloth: sim.sst(sid)["unlocked"] = true
	MK.set_open("weapon"); for sid in MK.sids_on(c, "weapon"): sim.sst(sid)["unlocked"] = true
	for i in 4: MKO.spawn_event(sim, "cloth"); MKO.spawn_event(sim, "weapon")
	_chk("全市集最多 5 件（兩街滿之後第三條街只入到 1 件）", MKO.events().size() <= 5, MKO.events().size())
	MKO.st().ev.clear()
	var cnt = {"steal_cash": 0, "steal_goods": 0, "cut_queue": 0, "brawl": 0}; var spn = 0
	for i in 2000:
		MKO.st().ev.clear()
		var e = MKO.spawn_event(sim, "food"); cnt[str(e.k)] += 1; spn += int(e.sp)
	MKO.st().ev.clear()
	_chk("類型比例 偷錢 30／偷貨 20／插隊 25／吵架 25（±4%）", absf(cnt.steal_cash / 2000.0 - 0.3) < 0.04 and absf(cnt.steal_goods / 2000.0 - 0.2) < 0.04 and absf(cnt.cut_queue / 2000.0 - 0.25) < 0.04 and absf(cnt.brawl / 2000.0 - 0.25) < 0.04, cnt)
	_chk("通用版 60%／該章特色版 40%（±4%）", absf(spn / 2000.0 - 0.4) < 0.04, spn / 2000.0)
	var vr = MKO.variant(1, "steal_cash", true)
	_chk("第 2 章偷錢特色版＝Toyol", str(vr.n[1]).find("Toyol") >= 0 and int(vr.sp) == 1, vr)
	# 冇巡邏：20 秒後結算損失，唔超過 15% 上限
	MKO.st().evt.clear()
	MKO._income("food", 10000.0)
	MKO.st().till["food"] = 4000.0
	MKO.st()["tut"] = 1
	var e1 = MKO.spawn_event(sim, "food", "steal_cash", 0)
	for i in 19: MKO.st().evt["food"] = 9999.0; MKO.tick(sim, 1.0)
	_chk("冇人理：19 秒仲未結算", MKO.events("food").has(e1))
	var t0 = MKO.till("food")
	MKO.st().evt["food"] = 9999.0; MKO.st().ctr_t["food"] = 0.0; MKO.tick(sim, 1.5)
	var lost1 = MKO.win_loss("food")
	_chk("偷錢：20 秒後偷走收銀箱 15%（唔扣已入帳冥幣）", not MKO.events("food").has(e1) and lost1 > 0.0 and lost1 <= 0.15 * 4000.0 + 1.0, [lost1, t0])
	for i in 6:
		MKO.st().till["food"] = 4000.0
		MKO.spawn_event(sim, "food", "steal_cash", 0)
		for j in 22: MKO.st().evt["food"] = 9999.0; MKO.st().ctr_t["food"] = 0.0; MKO.tick(sim, 1.0)
	_chk("每條街 10 分鐘事件損失 ≤ 該街收入 15%（到頂只演出）", MKO.win_loss("food") <= 0.15 * MKO.win_income("food") + 0.01 and MKO.loss_room("food") < 1.0, [MKO.win_loss("food"), MKO.win_income("food")])
	# 吵架：停工 15 秒，唔會更耐
	MK.st().erase("ops"); MKO.tick(sim, 0.1); MKO.st()["tut"] = 1; MKO._income("food", 1e9)
	for i in 2: sim.assign(food[i], 0, "t_mk%d" % i)
	MKO.tick(sim, 0.1)
	var e2 = MKO.spawn_event(sim, "food", "brawl", 0)
	for i in 21: MKO.st().evt["food"] = 9999.0; MKO.tick(sim, 1.0)
	var stopped = MKO.prod_k(str(e2.sid)) == 0.0
	for i in 15: MKO.st().evt["food"] = 9999.0; MKO.tick(sim, 1.0)
	_chk("吵架冇人理：事發攤停工 15 秒，之後復工（永不超過 15 秒）", stopped and MKO.prod_k(str(e2.sid)) > 0.0, stopped)
	# 巡邏處理率：1−(1−p)^n；4 隻滿編都壓唔到 0
	var rates = []; var rates_sp = []
	var FN = load("res://game/market/mk_fun.gd"); FN.ensure(); FN.D().ot["pat_add"] = 0.0; FN.D().ot["cap_n"] = 1e9   # 呢段只量 M1 純處理率：暫停 M2 巡邏員過勞同升隊長（隊長會兼顧隔籬街，令處理數變多；兩樣另由 market_m2_test 驗），完咗 reload
	for n in [0, 1, 2, 3, 4]:
		for sp in [0, 1]:
			MK.st().erase("ops"); MKO.tick(sim, 0.1); MKO.st()["tut"] = 1
			for i in n: MKO.assign(sim, "pat", "food", "t_mk%d" % (6 + i))
			for i in 400:
				MKO.spawn_event(sim, "food", "cut_queue", sp)
				for j in 22: MKO.st().evt["food"] = 9999.0; MKO.tick(sim, 1.0)
			var h = MKO.summary().handled / 400.0
			if sp == 0: rates.append(snappedf(h, 0.01))
			else: rates_sp.append(snappedf(h, 0.01))
			for i in n: MKO.unassign(sim, "t_mk%d" % (6 + i))
	FN.reload()
	_p("巡邏處理率（通用版）0–4 隻：" + str(rates) + "　特色版：" + str(rates_sp))
	_chk("巡邏 0 隻：處理率 0", rates[0] == 0.0)
	_chk("巡邏 1／2／3／4 隻（通用版）≈ 45／70／83／91%（±7%）", absf(rates[1] - 0.45) < 0.07 and absf(rates[2] - 0.70) < 0.07 and absf(rates[3] - 0.83) < 0.07 and absf(rates[4] - 0.91) < 0.07, rates)
	_chk("人越多越好、但遞減；4 隻滿編仍有漏網（＜100%）", rates[1] < rates[2] and rates[2] < rates[3] and rates[3] <= rates[4] and rates[4] < 0.99 and rates_sp[4] < 0.9, [rates, rates_sp])
	_chk("特色版較難捉（4 隻 ≈ 76%）", absf(rates_sp[4] - 0.76) < 0.08 and rates_sp[1] < rates[1], rates_sp)
	_chk("KPI 指標 mk_patrol_done 跟實際處理次數", KG._metric("mk_patrol_done", "fn") == J.num(MK.st().get("patrol_done", 0)) and J.num(MK.st().get("patrol_done", 0)) > 100.0, MK.st().get("patrol_done"))
	MK.st().erase("ops"); MK.st()["patrol_done"] = 0
	for i in 12: MKO.unassign(sim, "t_mk%d" % i)
	for sid in food: for i in sim.sst(sid).workers.size(): sim.assign(sid, i, null)
	# ---- 文案詞庫（story_market_v2_add）----
	MK.st().erase("ops"); MKO.tick(sim, 0.1); MKO.st()["tut"] = 1; MKO._income("food", 50000.0)
	var LN = MKO.LN()
	_chk("詞庫載入：甄好賣 6 章、抱怨 20 句、巡邏人數 0–4", LN.get("zhen", {}).size() == 6 and LN.get("complain", []).size() == 20 and LN.get("pat_n", {}).size() == 5)
	var dup = []
	for ci in 6:
		for col in 2:
			var seen = {}
			var all_l = []
			for nd in LN.zhen[str(ci)]: all_l.append(str(LN.zhen[str(ci)][nd][col]))
			all_l.append(str(LN.praise[str(ci)].t[col]))
			for r5 in LN.complain: all_l.append(str(r5[col]))
			for k5 in LN.pat_n: all_l.append(str(LN.pat_n[k5].t[col]))
			for ty in LN.ev[str(ci)]: for r6 in LN.ev[str(ci)][ty]: all_l.append(str(r6.ev[col])); all_l.append(str(r6.pat[col]))
			for x5 in all_l:
				if seen.has(x5): dup.append([ci, x5])
				seen[x5] = 1
	_chk("同一章內冇兩個角色講同一句（兩個語言欄都查）", dup.is_empty(), dup)
	var fu = []
	for ty in LN.ev["2"]: for r7 in LN.ev["2"][ty]: for x7 in [r7.ev[0], r7.ev[1], r7.pat[0], r7.pat[1]]: if str(x7).find("黃符") >= 0 or str(x7).find("貼符") >= 0 or str(x7).find("符咒") >= 0: fu.append(x7)
	_chk("第 3 章巡邏鬼唔貼符", fu.is_empty(), fu)
	var got = {}
	for i in 5: got[int(MKO.ev_line(c, "steal_cash").i)] = 1
	_chk("特色版事件：5 條抽完先重洗（頭 5 次冇重複）", got.size() == 5, got.keys())
	var cm = {}
	for i in 20: cm[MKO.complain()] = 1
	_chk("過勞抱怨：20 句輪完先重複", cm.size() == 20, cm.size())
	var es = MKO.spawn_event(sim, "food", "steal_goods", 1)
	_chk("特色版事件帶描述＋巡邏鬼台詞", es.get("desc") is Array and es.get("say") is Array and str(es.desc[1]).length() > 6, es.get("desc"))
	MKO.st().ev.clear()
	_chk("甄好賣各章台詞接入考核劇情（開場／達標）", load("res://game/kpi/kpi_ui.gd").scene("kpi_zhen_open").get("lines", []).size() == 1 and load("res://game/kpi/kpi_ui.gd").scene("kpi_zhen_pass").get("lines", []).size() == 1)
	MKO.pop_say()
	MKO.assign(sim, "pat", "food", "t_mk6")
	var sy = MKO.pop_say()
	_chk("派第 1 隻巡邏：冒巡邏人數台詞", sy.size() == 1 and str(sy[0].k) == "pat_n" and str(sy[0].t).length() > 4, sy)
	MKO.unassign(sim, "t_mk6"); MKO.pop_say()
	# ---- 按章價格（各章基價 × 街階倍率）----
	_chk("按章價格重算：預設關（延後），outpost.json 原價生效", not MKO.price_on() and is_equal_approx(float(MD.good_def("m_douhua").price), 100.0))
	MKO.D()["price_rebase"] = 1
	MKO.price_refresh(true)
	if c == 0:
		_chk("第 1 章：枯井豆花 階 2＝20、嘆氣包＝4", is_equal_approx(float(MD.good_def("m_douhua").price), 20.0) and is_equal_approx(float(MD.good_def("m_shoubao").price), 4.0), MD.good_def("m_douhua").price)
		var raw_s = MD.D().STATIONS["st_nuomici"]; var raw_g = MD.D().GOODS[str(raw_s.good)]
		var kk = float(MD.good_def(str(raw_s.good)).price) / float(raw_g.price)
		_chk("升級底價／解鎖價跟同一倍數縮放（每攤回本時間不變）", is_equal_approx(float(MD.st_def("st_nuomici").up_cost0), round(float(raw_s.up_cost0) * kk)) and is_equal_approx(float(MD.st_def("st_nuomici").unlock_cost), round(float(raw_s.unlock_cost) * kk)), [kk, MD.st_def("st_nuomici").unlock_cost])
		_chk("原始資料冇被改（outpost.json 照舊）", is_equal_approx(float(MD.D().GOODS["m_douhua"].price), 100.0))
		var ci0 = sim.st().ci; sim.st().ci = 1.0; MKO.price_refresh()
		_chk("招牌價跟章走：第 2 章嘆氣包＝20", is_equal_approx(float(MD.good_def("m_shoubao").price), 20.0), MD.good_def("m_shoubao").price)
		sim.st().ci = ci0; MKO.price_refresh()
	MKO.D()["price_rebase"] = 0; MKO.price_refresh()
	# ---- 第 1、2 章新商品（已過審美術；只有貨、做副貨）----
	var miss_ic = []
	for gid in ["m_c1_huaihua", "m_c1_mianao", "m_c1_gun", "m_c1_dun", "m_c1_xianghuo", "m_c2_banlan", "m_c2_kudai", "m_c2_xianjing", "m_c2_lingdang", "m_c2_bagua"]:
		var gd9 = MD.good_def(gid)
		if gd9.is_empty() or not Spr.ok(str(gd9.get("icon", ""))) or Spr.get_tex(str(gd9.icon)) == null: miss_ic.append(gid)
	_chk("新商品 10 樣：數據＋圖示齊（冇佔位圖）", miss_ic.is_empty(), miss_ic)
	var c2 = MK.stall_list(1); var c2bad = []
	for sid in ["st_c2_banlan", "st_c2_kudai", "st_c2_xianjing", "st_c2_lingdang", "st_c2_bagua"]:
		if not c2.has(sid): c2bad.append(sid)
		for lvx in [1.0, 25.0, 100.0]: if not Spr.ok(MD.stall_art(sid, lvx)) or Spr.get_tex(MD.stall_art(sid, lvx)) == null: c2bad.append([sid, lvx])
	_chk("第 2 章新攤 5 台上架、三段外觀圖齊", c2bad.is_empty(), c2bad)
	_chk("第 2 章五條街：食／衣／兵器／飾品都有攤（飾品街＝鈴鐺手鏈、八卦鏡）", MK.street_of(1, "st_c2_lingdang") == "acc" and MK.street_of(1, "st_c2_bagua") == "acc" and MK.street_of(1, "st_c2_banlan") == "food" and MK.street_of(1, "st_c2_kudai") == "cloth" and MK.street_of(1, "st_c2_xianjing") == "weapon")
	_chk("第 3–6 章冇新攤（未過審唔開放）", not MK.stall_list(2).any(func(x): return str(x).begins_with("st_c")) and not MK.stall_list(5).any(func(x): return str(x).begins_with("st_c")))
	if c == 0:
		sim.sst("st_shoubao").lv = 25.0; MKO.st().sub.erase("st_shoubao")
		_chk("嘆氣蒸籠 Lv25 預設副貨＝槐花粥；紙紮兵器可揀槐木棍／蒸籠盾", MKO.sub_of("st_shoubao") == "m_c1_huaihua" and MKO.default_sub(0, "st_bingqi") == "m_c1_gun", MKO.sub_of("st_shoubao"))
		var wn = 0
		for cd9 in MD.D().CUSTOMERS: if cd9.wants.has("m_c1_huaihua"): wn += 1
		_chk("有客人會買槐花粥", wn > 0, wn)
		MKO.set_sub(0, "st_shoubao", "")
	var no_art = []
	for ci in 6:
		for sid in MK.stall_list(ci): if not Spr.ok(str(MD.st_def(sid).get("art", ""))): no_art.append(sid)
		for h9 in MKO.pairs(ci): if not Spr.ok(str(MD.good_def(MKO._pair_good(str(MKO.pairs(ci)[h9]))).get("icon", ""))): no_art.append(str(MKO.pairs(ci)[h9]))
	_chk("全 6 章：上架嘅攤同副貨都有過審圖（未過審嘅唔出現）", no_art.is_empty(), no_art)
	# ---- 目標補發：副貨攤／移章嘅目標跳過，但獎勵照發 ----
	var gi = -1
	for i in MD.goals(0).size(): if str(MD.goals(0)[i].get("k", "")) == "st_guancaichuang": gi = i
	if c == 0 and gi >= 0:
		var gd0 = sim.st().goals_done.duplicate(); var comp0 = sim.st().get("goals_comp", []).duplicate()
		sim.st().goals_done = []
		for i in gi: sim.st().goals_done.append(float(i))
		sim.st()["goals_comp"] = []
		var rw = float(MD.goals(0)[gi].reward.coins); var cc1 = sim.coins()
		MKO.tick(sim, 0.1)
		_chk("輪到跳過嘅目標：獎勵自動補發（+%d）" % int(rw), rw > 0.0 and is_equal_approx(sim.coins() - cc1, rw), sim.coins() - cc1)
		MKO.tick(sim, 0.1); MKO.tick(sim, 0.1)
		_chk("只補一次", is_equal_approx(sim.coins() - cc1, rw))
		sim.st().goals_done = []; sim.st()["goals_comp"] = []
		var cc2 = sim.coins(); MKO.tick(sim, 0.1)
		_chk("未輪到（前面仲有正常目標）：唔會提早補", is_equal_approx(sim.coins(), cc2))
		sim.st().goals_done = gd0; sim.st()["goals_comp"] = comp0
	var miss = []
	for ci in 6:
		for g8 in MD.map_def(ci).get("goals", []):
			if MK.goal_skip(ci, g8) and not (g8.get("reward") is Dictionary and float(g8.reward.get("coins", 0)) > 0.0): miss.append([ci, g8.get("k")])
	_chk("全部會跳過嘅目標都有獎可補（冇漏）", miss.is_empty(), miss)
	# ---- 正式畫面：人手列、人手面板、治安卡、貨架卡、唔出格 ----
	sim.market_street("food"); MKO.tick(sim, 0.1); MKO.st()["tut"] = 1
	sc.hud_k = 1.0
	await _w(t, 0.4)
	_chk("人手列有畫（櫃檯／巡邏掣）", sc._btns.get("mko:pat") is Rect2 and sc._btns.get("mko:ctr") is Rect2)
	if sc._btns.get("mko:pat") is Rect2:
		MKOU.tap(sc, sc._btns["mko:pat"].get_center()); await _w(t, 0.4)
		_chk("撳巡邏：開人手面板", sc.sheet.visible and MKOU._panel == "pat")
		var txt = _all_text(sc.sheet_box)
		_chk("面板有「多派一隻救回幾多」同「村子少咗」比較", txt.find("救") >= 0 and txt.find("村子") >= 0, txt.substr(0, 120))
		_chk("面板冇出格（全部控件喺畫面闊度內）", _fits(sc.sheet_box, sc.sheet.size.x), sc.sheet.size)
		for i in 2:
			var ab = _find_btn(sc.sheet_box, "調")
			if ab != null and not ab.disabled: ab.pressed.emit()
			await _w(t, 0.3)
		_chk("面板撳兩次「調過嚟」：巡邏 2 隻", MKO.patrol_n("food") == 2, MKO.patrol_n("food"))
		await _shot(t, "u1_patrol_panel")
		var rb = _find_btn(sc.sheet_box, "村")
		if rb != null: rb.pressed.emit()
		await _w(t, 0.3)
		_chk("撳「回村子」：放返 1 隻", MKO.patrol_n("food") == 1, MKO.patrol_n("food"))
		sc.close_sheet()
		MKOU.tap(sc, sc._btns["mko:ctr"].get_center()); await _w(t, 0.4)
		var ab2 = _find_btn(sc.sheet_box, "調")
		if ab2 != null and not ab2.disabled: ab2.pressed.emit()
		await _w(t, 0.3)
		_chk("櫃檯面板調 1 隻", MKO.counter_n("food") == 1 and _fits(sc.sheet_box, sc.sheet.size.x))
		sc.close_sheet()
	for g9 in MKO.staff_of("pat", "food"): MKO.unassign(sim, g9)
	var e9 = MKO.spawn_event(sim, "food", "steal_goods", 1)
	MKO.st().till["food"] = 12345.0
	await _w(t, 0.4); await _shot(t, "m5_ops")
	var be = sc._btns.get("mkoe:%d" % int(e9.id))
	_chk("治安卡有畫、唔出格", be is Rect2 and be.position.x >= 0.0 and be.end.x <= sc.FW, be)
	if be is Rect2:
		MKOU.tap(sc, be.get_center())
		_chk("撳治安卡：主角親自處理", not MKO.events("food").has(e9))
	var bt = sc._btns.get("mko:till")
	if bt is Rect2:
		var cc0 = sim.coins(); MKOU.tap(sc, bt.get_center())
		_chk("撳收銀箱：即刻入帳", is_equal_approx(sim.coins() - cc0, 12345.0) and MKO.till("food") == 0.0, sim.coins() - cc0)
	else: _chk("收銀箱掣有畫", false)
	# 貨架卡＋店員位
	sim.sst(food[0]).lv = 200.0; sim.sst(food[1])["unlocked"] = false; MKO.tick(sim, 0.1)
	sc.open_sheet(food[0]); await _w(t, 0.5)
	var tx2 = _all_text(sc.sheet_box)
	_chk("攤位資料卡有貨架摘要＋「調整貨架」掣", tx2.find("貨架") >= 0 and _find_btn(sc.sheet_box, "調整貨架") != null)
	_chk("Lv200 五個店員位：資料卡冇出格", _fits(sc.sheet_box, sc.sheet.size.x) and sc.sheet.size.x <= sc.FW + 0.5, sc.sheet.size)
	var sb9 = _find_btn(sc.sheet_box, "調整貨架")
	if sb9 != null: sb9.pressed.emit()
	await _w(t, 0.5)
	_chk("開貨架面板：主貨／副貨、冇出格", MKOU._panel == "shelf" and _all_text(sc.sheet_box).find("主貨") >= 0 and _fits(sc.sheet_box, sc.sheet.size.x))
	var gb2 = MKO.good_of(food[1])
	var cb2 = _find_btn(sc.sheet_box, MD.T(MD.good_def(gb2).get("n", ["", ""])))
	if cb2 != null: cb2.pressed.emit()
	await _w(t, 0.4)
	_chk("貨架卡揀副貨：生效", MKO.sub_of(food[0]) == gb2, MKO.sub_of(food[0]))
	await _shot(t, "u2_shelf")
	sc.close_sheet()
	MKO.set_sub(c, food[0], ""); sim.sst(food[0]).lv = 25.0; sim.sst(food[1])["unlocked"] = true
	MK.st().erase("ops"); MK.st()["patrol_done"] = 0
	for g in S.ghosts: if str(J.gp(g, "post")) in ["mk_ctr", "mk_pat"]: J.sp(g, "post", null)
	sim.paused = false

func _all_text(n: Node) -> String:
	var o = ""
	if n is Label or n is Button: o += str(n.text) + "\n"
	for ch in n.get_children(): o += _all_text(ch)
	return o
func _find_btn(n: Node, part: String) -> Button:
	if n is Button and str(n.text).find(part) >= 0: return n
	for ch in n.get_children():
		var r = _find_btn(ch, part)
		if r != null: return r
	return null
func _fits(n: Node, w: float) -> bool:   # 所有控件都喺面板闊度內（冇出格）
	if n is Control and n.is_visible_in_tree():
		if (n as Control).size.x > w + 1.0: return false
	for ch in n.get_children(): if not _fits(ch, w): return false
	return true

func _uniq(a: int, b: int) -> bool:
	var sig = ["st_shoubao", "st_zhishan", "st_bingqi"]
	for s in MK.stall_list(a): if not sig.has(s) and MK.stall_list(b).has(s): return false
	return true

func _rename() -> void:   # 玩家睇到嘅文字唔再有「大排檔」（真實世界大排檔師傅／鑊鏟除外）
	var keep = ["大排檔鑊鏟", "大排檔鍋鏟", "大排檔夜更師傅", "大排檔夜班師傅", "大排檔師傅", "大排檔炒鍋師傅", "大排檔炒咗三十年", "大排檔炒了三十年"]
	var bad_f = []
	for p in ["res://data/nat/mv_story.json", "res://data/nat/zones.json", "res://data/nat/taunts.json", "res://data/nat/chatter_data.json", "res://data/nat/kpi.json"]:
		var s = FileAccess.get_file_as_string(p)
		for kk in keep: s = s.replace(kk, "")
		if s.find("大排檔") >= 0 or s.find("大排档") >= 0: bad_f.append(p)
	_chk("劇情／區名／叫囂／閒聊／考核：冇「大排檔」", bad_f.is_empty(), bad_f)
	_chk("市集名「過勞鬼市集」", FileAccess.get_file_as_string("res://data/nat/zones.json").find("過勞鬼市集") >= 0)
