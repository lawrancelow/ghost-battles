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
const MVW = preload("res://game/outpost/mv_war.gd")
const KG = preload("res://game/kpi/kpi_data.gd")
const M = preload("res://game/outpost/mat.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var SHOTS := "/home/claude/meeting/market/shots/"

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
	MK.st().erase("test")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

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
