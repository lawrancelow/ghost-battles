# [militia] 遊魂兵（民兵）＋紙紮兵器檔＋客人需求修正＋野外惡勢力重平衡 測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> militia res://tools/tests/militia_test.gd logic|shots|all <秒>
#   logic：客人只要現有物品、高級客比例上限、挑剔客、兵器原料／解鎖、裝備銷售產生遊魂兵、上限換新、遊魂兵不計入防守、
#          出戰戰力組成（戰鬥小隊、嘍囉）、戰死扣人、野外敵人新曲線、攻佔需要／折損、舊存檔升級
#   shots：/home/claude/docs/militia_shots/（六關兵器檔位置、客人、遊魂兵、出擊構成）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/militia_shots/"
static var SHOT_MAPS := []
const ZD = preload("res://game/zone/zone_data.gd")
const ML = preload("res://game/militia/ml_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
const BK = preload("res://game/barracks/bk_data.gd")
const RAID = preload("res://game/raid/raid.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")
const MVS = preload("res://game/outpost/mv_sim.gd")

func _p(m): print("[ml] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
func _boot(t):
	load("res://game/rts/rts.gd").force = 0   # [rts] 呢個測試測舊戰鬥接口／數值（新地圖打法見 rts_test）
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m

func all(t) -> void:
	var m = await _boot(t)
	await _logic(t, m)
	await _shots(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func logic(t) -> void:
	var m = await _boot(t)
	await _logic(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func shots35(t) -> void:
	SHOT_MAPS = [3, 5]
	await shots(t)
func shots(t) -> void:
	var m = await _boot(t)
	await _shots(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------- 工具 ----------
func _sim(m):
	if m.get("mv_view") != null and m.mv_view.sim != null: m.mv_view.sim.paused = true   # 畫面嗰個停咗，唔好同測試搶櫃台
	var sim = MVS.new()
	sim.st(); sim.relayout(102.0, 786.0)
	return sim
func _clear_supply(sim) -> void:
	var mv = sim.st()
	mv.counter = {}; mv.pile = {}; sim.mk.clear(); sim.mk_starve.clear(); sim.custs.clear()
	for sid in mv.st:
		var e = mv.st[sid]
		for i in e.workers.size(): e.workers[i] = null
		if e.get("fore") is Array: for i in e.fore.size(): e.fore[i] = null
	var S = J.G.S
	S["mat"] = {}
	for k in ["wood", "rice", "planks", "buns"]: S.res[k] = 0.0
	var w = sim.war.ws(); if w != null: w.occ = {}
func _spawn_n(sim, n: int, keep_queue := false) -> Array:   # 出 n 個客，回客人字典
	var out = []
	for i in n:
		if not keep_queue: sim.custs.clear()
		if sim.spawn_cust(): out.append(sim.custs[sim.custs.size() - 1])
	return out
func _team3(S) -> void:
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids

func _logic(t, m) -> void:
	var S = J.G.S
	S.lv = 1.0
	var sim = _sim(m)
	var ci = sim.ci()
	_chk("第 1 關、分區地圖", ci == 0 and ZD.on(), ci)
	# ================= 0. 資料 =================
	_chk("兵器檔係隨村台、六關都有位置", M.carry().has(ML.SID) and _all_maps_have_stall(), M.carry())
	_chk("兵器貨、遊魂客資料齊", MD.good_def(ML.GOOD).size() > 0 and MD.cust_def(ML.CID).size() > 0 and MD.st_def(ML.SID).get("good") == ML.GOOD)
	# ================= 1. 客人只要現有物品 =================
	var mv = sim.st()
	for sid in mv.st: mv.st[sid].unlocked = true; mv.st[sid].lv = 1.0
	mv.st[ML.SID].unlocked = false
	_clear_supply(sim)
	_chk("全部台解鎖但冇貨、冇料、冇人做：唔出客（舊版會要冇供應嘅貨）", ML.supplied(sim).is_empty() and not sim.spawn_cust(), ML.supplied(sim))
	mv.counter["m_douhua"] = 30.0
	var cs = _spawn_n(sim, 200)
	var bad_w = []
	for c in cs: for g in c.wants: if g != "m_douhua": bad_w.append(g)
	_chk("櫃台只有豆腐花：200 個客全部只要豆腐花", cs.size() > 50 and bad_w.is_empty(), [cs.size(), bad_w.slice(0, 5)])
	# 斷料（有員工但冇料、冇貨）唔算有供應
	var gh = null
	for g in S.ghosts: if g.get("post") == null or not J.t(g.get("post")): gh = g; break
	if gh != null:
		mv.st["st_nuomici"].workers[0] = gh.id
		_chk("糯米糍有員工但斷料、冇貨：唔算有供應", ML.supply(sim, "st_nuomici") == 0, ML.supply(sim, "st_nuomici"))
		mv.st["st_nuomici"].workers[0] = null
	# 料夠撳一下就做得 → 退路（冇其他有供應嘅貨先用）
	mv.counter = {}
	S.mat["m_bao"] = 50.0
	var sup = ML.supplied(sim)
	_chk("冇任何貨：退返『料夠手做』嘅台（壽包有普通包子）", sup.has("m_shoubao") and not sup.has("m_douhua"), sup)
	# 停工（被孤魂霸檔）唔算
	mv.counter["m_douhua"] = 30.0
	sim.war.ws().occ[str(ci)] = "st_douhua"
	_chk("被孤魂霸咗嘅台：有貨都唔算有供應", ML.supply(sim, "st_douhua") == 0 and not ML.supplied(sim).has("m_douhua"))
	sim.war.ws().occ = {}
	mv.counter = {}
	_chk("委託單：冇料冇貨嘅台唔入單、兵器永遠唔入單", not ML.order_ok(sim, "st_douhua") and not ML.order_ok(sim, ML.SID) and ML.order_ok(sim, "st_shoubao"))
	# ================= 2. 高級客比例上限 =================
	_clear_supply(sim)
	var allg = []
	for sid in MD.stations(ci):
		var g = str(MD.st_def(sid).get("good", ""))
		if g != ML.GOOD: mv.counter[g] = 40.0; allg.append(g)
	var HG = ML.high_goods(ci)
	_chk("第 1 關高級貨＝最貴三樣（棺材板床、鬼火燈籠、夜行豆花擔）", HG.size() == 3 and HG.has("m_tiaodan") and HG.has("m_denglong") and HG.has("m_guancaichuang"), HG)
	for lvv in [1, 10]:
		S.lv = float(lvv)
		var cs2 = []
		for i in 1500:
			sim.custs.clear()
			for g in allg: mv.counter[g] = 40.0
			if sim.spawn_cust(): cs2.append(sim.custs[0])
		var nh = 0; var nvip = 0
		for c in cs2:
			if J.t(c.get("hi")): nh += 1
			if J.t(c.get("vip")): nvip += 1
		var sh = float(nh) / maxf(1.0, cs2.size()); var want = ML.high_share(ci)
		_chk("主公 Lv%d：高級客比例 %.3f ≈ 上限 %.3f（±0.04）" % [lvv, sh, want], absf(sh - want) < 0.04 and cs2.size() > 1400, [nh, cs2.size()])
		if lvv == 1: _chk("主公 Lv1：唔出 VIP", nvip == 0, nvip)
		else: _chk("主公 Lv10：有 VIP（當高級客）", nvip > 0, nvip)
	S.lv = 1.0
	# 排隊中高級客上限
	sim.custs.clear(); var max_q = 0
	for i in 600:
		for g in allg: mv.counter[g] = 40.0
		if sim.custs.size() >= 4: sim.custs.pop_front()
		sim.spawn_cust()
		max_q = maxi(max_q, ML.queue_high(sim))
	_chk("主公 Lv1：排隊入面最多 1 個高級客", max_q == 1, max_q)
	# 新高級貨件數：未賣過 → 1 件
	sim.custs.clear(); var hq = 0
	mv.sold = {}
	for i in 400:
		sim.custs.clear()
		for g in allg: mv.counter[g] = 40.0
		if sim.spawn_cust():
			var c = sim.custs[0]
			for g in c.wants: if HG.has(g): hq = maxi(hq, int(c.wants[g]))
	_chk("新高級貨（未賣過）：每個客最多要 1 件", hq == 1, hq)
	# ================= 3. 挑剔客只要已有星 =================
	var bad_star = 0; var n_picky = 0
	for i in 800:
		sim.custs.clear()
		for g in allg: mv.counter[g] = 40.0
		if sim.spawn_cust():
			var c = sim.custs[0]
			var sn = c.get("star_need")
			if sn is Dictionary:
				n_picky += 1
				for g in sn: if MD.stars(sim.sid_of(g), sim.lv(sim.sid_of(g))) < int(sn[g]): bad_star += 1
	_chk("全部台 ★0：冇挑剔客要唔存在嘅星（舊版：一定要 ★1）", bad_star == 0 and n_picky == 0, [n_picky, bad_star])
	mv.st["st_douhua"].lv = 30.0
	bad_star = 0; n_picky = 0
	for i in 1500:
		sim.custs.clear()
		for g in allg: mv.counter[g] = 40.0
		if sim.spawn_cust():
			var sn2 = sim.custs[0].get("star_need")
			if sn2 is Dictionary:
				n_picky += 1
				for g in sn2: if MD.stars(sim.sid_of(g), sim.lv(sim.sid_of(g))) < int(sn2[g]): bad_star += 1
	_chk("豆腐花 Lv30（★2）：挑剔客出現，但要求 ≤ 而家星", n_picky > 0 and bad_star == 0, [n_picky, bad_star])
	mv.st["st_douhua"].lv = 1.0
	# ================= 4. 兵器檔：解鎖、原料、級數 =================
	mv.st[ML.SID].unlocked = false; mv.st[ML.SID].lv = 1.0
	mv.st["st_zhishan"].lv = 5.0
	S.res.coins = 1e6
	_chk("補丁紙衫檔 Lv5：兵器檔未解鎖得", not sim.unlock(ML.SID) and not IDL.unlock_req(sim, ML.SID)[0])
	mv.st["st_zhishan"].lv = 10.0
	_chk("補丁紙衫檔 Lv10：兵器檔解鎖（300 冥幣）", sim.unlock(ML.SID) and absf(J.num(S.res.coins) - (1e6 - 300)) < 0.5, S.res.coins)
	var r_ok = true; var tn = []
	for i in ML.TIERS.size():
		var lvv2 = [1, 10, 25, 50, 100, 150, 200][i]
		mv.st[ML.SID].lv = float(lvv2)
		tn.append(ML.tier_name(ML.tier_now()))
		if ML.tier_now() != i or M.rin(ML.SID) != ML.TIERS[i].rec: r_ok = false
	_chk("兵器級＝兵器檔★（Lv1/10/25/50/100/150/200 → 0..6），原料跟級數", r_ok, tn)
	mv.st[ML.SID].lv = 10.0   # ★1 柴刀
	S.mat = {"m_strip": 100.0}; S.res.wood = 100.0
	_chk("柴刀原料（槐木＋竹篾）夠：兵器檔有供應（料夠）", ML.supply(sim, ML.SID) >= 1)
	S.res.wood = 0.0
	_chk("冇槐木：兵器檔冇供應（遊魂兵客唔會嚟）", ML.supply(sim, ML.SID) == 0)
	# ================= 5. 裝備銷售產生遊魂兵 =================
	S.erase("militia")
	_clear_supply(sim)
	for g in allg: mv.counter[g] = 40.0
	mv.counter[ML.GOOD] = 40.0
	var recs = []; var others_w = 0
	for i in 1000:
		sim.custs.clear(); mv.counter[ML.GOOD] = 40.0
		if sim.spawn_cust():
			var c = sim.custs[0]
			if J.t(c.get("ml")): recs.append(c)
			elif c.wants.has(ML.GOOD): others_w += 1
	var rr = float(recs.size()) / 1000.0
	_chk("兵器有貨：遊魂兵客約 20%%（%.3f），其他客唔會要兵器" % rr, absf(rr - 0.2) < 0.04 and others_w == 0, [recs.size(), others_w])
	var rc = recs[0] if recs.size() else {}
	_chk("遊魂兵客：東方亡魂造型、買 1 件、冇脾氣", rc.get("k") == "youhun" and rc.wants == {ML.GOOD: 1} and rc.get("tp") == "none", rc.get("wants"))
	# 付錢 → 加入
	sim.custs.clear()
	var c1 = recs[0].duplicate(true); c1.got = {ML.GOOD: 1}; c1.st = "serve"; sim.custs.append(c1)
	var tot0 = ML.total(); var coins0 = J.num(S.res.coins)
	sim._pay(c1)
	_chk("付錢：遊魂兵 +1（柴刀級 1）、收到錢、飄字事件", ML.total() == tot0 + 1 and ML.n_of(1) == 1 and J.num(S.res.coins) > coins0 and _has_ev(sim, "ml_join"), [ML.total(), ML.st().n])
	_chk("第一個遊魂兵：劇情記低播咗（只一次）", J.t(ML.st().get("story")))
	var g_before = ML.st().duplicate(true)
	var c2 = {"cid": "c0_guhan", "k": "x", "wants": {"m_douhua": 1}, "got": {"m_douhua": 1}, "st": "serve", "pos": Vector2(200, 600), "vip": false}
	sim.custs.append(c2); sim._pay(c2)
	_chk("買其他貨嘅客：唔會變遊魂兵", ML.total() == tot0 + 1)
	# 上限、換新
	S.militia.n = {"0": float(ML.cap())}
	mv.st[ML.SID].lv = 1.0
	_chk("滿額（%d）而兵器同最弱一樣：唔再出遊魂兵客" % ML.cap(), not ML.recruit_ok())
	mv.st[ML.SID].lv = 25.0   # ★2
	var cap2 = ML.cap()
	S.militia.n = {"0": float(cap2)}
	_chk("兵器升到 ★2：滿額都會嚟（換走最弱）", ML.recruit_ok())
	ML.join(ML.tier_now())
	_chk("滿額加入：最弱（竹竿）一個退休，總數唔變", ML.total() == cap2 and ML.n_of(2) == 1 and ML.n_of(0) == cap2 - 1, ML.st().n)
	_chk("上限 = 120 + 30×★（★2＝180）", cap2 == 180, cap2)
	# ================= 6. 遊魂兵不計入防守 =================
	S.militia.n = {}
	S.res.troops = 300.0; S.bld["home"] = 2.0; S.bld["barracks"] = 2.0; BK.st(); BK.set_def(100)
	var rd0 = RAID.def_pow(); var bd0 = BK.def_power(); var pw0 = ZD.power()
	S.militia.n = {"6": 150.0}
	_chk("加 150 個加班戰甲遊魂兵：襲擾防衛戰力唔變（%d）" % rd0, RAID.def_pow() == rd0 and BK.def_power() == bd0, [rd0, RAID.def_pow()])
	_chk("……出擊兵力就加咗 150×0.85＝127", ZD.power() == pw0 + 127 and ML.power() == 127, [pw0, ZD.power()])
	_chk("清剿收入唔計遊魂兵（只睇派去嘅陰兵）", BK.sweep_rate("x").coins == 0.0)
	# ================= 7. 出戰戰力組成 =================
	S.militia.n = {"6": 60.0, "2": 40.0, "0": 200.0}
	var fl = ML.field()
	_chk("出戰揀最好嗰批，最多 150 人（60 戰甲＋40 藤牌＋50 竹竿）", fl == [[6, 60], [2, 40], [0, 50]], fl)
	_chk("小隊：每 25 人一隊、最多 6 隊（2 戰甲＋1 藤牌＋2 竹竿；唔夠 25 人嘅唔出）", ML.squads() == [[6, 25], [6, 25], [2, 25], [0, 25], [0, 25]], ML.squads())
	_chk("出擊兵力 = 60×0.85＋40×0.45＋50×0.25 = 81", ML.power() == 81, ML.power())
	# 真戰鬥（主線 3-3，p=11）：我方陰兵＋遊魂兵小隊、敵方嘍囉
	_team3(S)
	BK.set_def(0); S.res.troops = 120.0
	var B = J.G.Battle
	var G = J.G; var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
	G["__nat_battle"] = func(_t, _a): return true
	G["__nat_btSize"] = func(_t, _a): return [390.0, 560.0]
	J.mc(B, "start", [2.0, 2.0])
	var n_y = 0; var n_m = 0; var n_f = 0; var mils = []; var foes = []; var ytop = 0.0; var mtop = 0.0
	for u in B.units:
		if J.t(u.get("minion")) and J.num(u.side) == 0 and u.get("ml") == null: n_y += 1; ytop = maxf(ytop, J.num(u.maxhp))
		if u.get("ml") != null: n_m += 1; mils.append(u); mtop = maxf(mtop, J.num(u.maxhp))
		if J.t(u.get("foe_ml")): n_f += 1; foes.append(u)
	_chk("主線 3-3：陰兵 4 隊（120÷25）＋遊魂兵 5 隊＋敵方嘍囉 5 隊（F=255）", n_y == 4 and n_m == 5 and n_f == 5 and int(J.num(B.ml_foe)) == 255, [n_y, n_m, n_f, B.get("ml_foe")])
	_chk("遊魂兵比陰兵脆（最強一隊血 < 陰兵一隊血）", mtop < ytop, [mtop, ytop])
	_chk("嘍囉造型用嗰關小怪（殭屍）、屬敵方", foes.size() > 0 and str(foes[0].k) == "zombie" and J.num(foes[0].side) == 1, foes[0].k if foes.size() else "")
	# 戰死：殺一隊加班戰甲遊魂兵、一隊陰兵，撤退結算
	var t6 = 0
	for u in mils: if int(J.num(u.ml)) == 6: u.hp = 0.0; t6 += 1; break
	for u in B.units: if J.t(u.get("minion")) and J.num(u.side) == 0 and u.get("ml") == null: u.hp = 0.0; break
	J.mc(B, "finish", [false, true]); _close_result()
	_chk("戰死一隊遊魂兵：加班戰甲 −25（60→35）；陰兵一隊 −25", ML.n_of(6) == 35 and absf(J.num(S.res.troops) - 95.0) < 0.5, [ML.n_of(6), S.res.troops])
	B.active = false
	# 唔係對外（襲擾戰：沒有出征記錄的野外戰）：冇遊魂兵、冇嘍囉
	ZD.st().exp = null
	J.mc(B, "start", [-1.0, -1.0, {"stage": {"name": "襲擾", "en": ["egui", "egui", "egui"], "boss": "egui", "p": 11.0}, "bg": "field", "sid": "raid_test"}])
	var n_m2 = 0; var n_f2 = 0
	for u in B.units:
		if u.get("ml") != null: n_m2 += 1
		if J.t(u.get("foe_ml")): n_f2 += 1
	_chk("村子襲擾戰：遊魂兵唔上陣、冇嘍囉", n_m2 == 0 and n_f2 == 0 and not J.t(B.get("ml_ext")), [n_m2, n_f2])
	J.mc(B, "finish", [false, true]); _close_result(); B.active = false
	# 主線 1-1：新手，冇嘍囉
	J.mc(B, "start", [0.0, 0.0])
	var n_f3 = 0
	for u in B.units: if J.t(u.get("foe_ml")): n_f3 += 1
	_chk("主線 1-1（p1）：冇嘍囉", n_f3 == 0)
	J.mc(B, "finish", [false, true]); _close_result(); B.active = false
	G["__nat_battle"] = ob; G["__nat_btSize"] = osz
	S.cleared.erase("raid_test")
	# ================= 8. 野外敵人新曲線 =================
	var pts = {1.0: 0, 2.0: 0, 3.0: 60, 5.0: 120, 7.0: 180, 11.0: 255, 15.0: 320, 20.0: 360, 23.0: 410, 30.0: 410}
	var cv_ok = true; var got = {}
	for p in pts:
		got[p] = ML.foe_army(p)
		if ML.foe_army(p) != pts[p]: cv_ok = false
	_chk("敵方兵力曲線（p→F）", cv_ok, got)
	var inc = true; var prev = -1
	for i in 30:
		var v = ML.foe_army(float(i))
		if v < prev: inc = false
		prev = v
	_chk("曲線只升唔跌", inc)
	_chk("嘍囉隊數：F60→1、F285→5、F420→7", ML.foe_squads(60) == 1 and ML.foe_squads(285) == 5 and ML.foe_squads(420) == 7)
	var stage_tab = []
	var CH = J.G.CHAPTERS
	for c in CH.size():
		var row = []
		for s in CH[c].stages: row.append(ML.foe_army(J.num(s.p)))
		stage_tab.append(row)
	_p("主線 F 表：%s" % str(stage_tab))
	_chk("主線每關 F 唔跌（關數越後越強）", _mono(stage_tab), stage_tab)
	# 資源區需要兵力
	_chk("第 1 關資源區需要：同舊一樣（A 300）", ZD.need("A") == 300, ZD.need("A"))
	var need_tab = []
	for c in 6:
		var row2 = []
		for zid in ["A", "B", "C"]:
			var z = {}
			for zz in ZD.mdef(c).zones: if str(zz.id) == zid: z = zz
			row2.append(int(round(float(z.get("power", 0)) * ML.res_mul(c))))
		need_tab.append(row2)
	_p("資源區需要表：%s" % str(need_tab))
	_chk("第 2 關 A 需要 1500×1.15＝1725", need_tab[1][0] == 1725 and need_tab[5][2] == 49000, need_tab)
	# 派兵攻佔：陰兵＋遊魂兵，折損分擔
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	BK.set_def(0); S.bld["barracks"] = 0.0
	S.militia.n = {}
	S.res.troops = 250.0
	_chk("陰兵 250 < 300：攻佔唔得", ZD.capture_auto("A") == "weak")
	S.militia.n = {"0": 40.0, "3": 100.0}   # 兵力 100×0.55＋40×0.25＝65 → 總 315
	_chk("加遊魂兵（兵力 +65）：夠 300", ZD.power() == 315, ZD.power())
	var lw = ZD.loss(zid_a()); var lm = ZD.loss_ml(zid_a())
	var r = ZD.capture_auto("A")
	_chk("攻佔成功：陰兵扣 %d、遊魂兵扣 %d（由竹竿開始扣）" % [lw, lm], r == "ok" and absf(J.num(S.res.troops) - (250.0 - lw)) < 0.5 and ML.total() == 140 - lm and lm > 0 and ML.n_of(0) < 40, [r, S.res.troops, ML.st().n])
	var lost_pow = (40.0 - ML.n_of(0)) * ML.pw(0) + (100.0 - ML.n_of(3)) * ML.pw(3)
	_chk("遊魂兵分擔兵力 %.1f > 按兵力比例 %.1f（民兵傷亡較多）、陰兵少扣（%d < 90）" % [lost_pow, 90.0 * 65.0 / 315.0, lw], lost_pow > 90.0 * 65.0 / 315.0 and lw < 90, [lw, lm])
	S.militia.n = {}; S.res.troops = 400.0
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	ZD.capture_auto("A")
	_chk("冇遊魂兵：折損同舊公式一樣（300×0.3＝90 陰兵）", absf(J.num(S.res.troops) - 310.0) < 0.5, S.res.troops)
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	# ================= 9. 舊存檔升級 =================
	S.erase("militia")
	mv.st.erase(ML.SID)
	var sim2 = MVS.new(); sim2.st()
	_chk("舊存檔冇兵器檔：自動補一格（未解鎖、Lv1）", mv.st.has(ML.SID) and not J.t(mv.st[ML.SID].unlocked) and J.num(mv.st[ML.SID].lv) == 1.0)
	_chk("舊存檔冇遊魂兵：建立空表、戰力 = 陰兵（唔變弱）", ML.total() == 0 and ZD.power() == BK.power() and S.militia.get("v") == 1.0, S.militia)
	S.militia = {"n": {"1": 30}}   # 半新舊：冇 v
	_chk("殘缺 militia（冇 v）：補欄唔洗數", ML.n_of(1) == 30 and J.num(ML.st().get("join")) == 0.0)
	S.erase("militia")
	m.mv_view.sim.paused = false

func zid_a() -> String: return "A"
func _close_result() -> void:   # 戰鬥結算框（舊 DOM 卡）：撳「回村子」收埋
	var dl = J.G.get("$")
	var okb = J.cl(dl, null, ["#b-ok"]) if dl != null else null
	if okb != null and okb.get("onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])
func _mono(tab: Array) -> bool:
	var prev = -1
	for row in tab:
		for v in row:
			if v < prev: return false
			prev = v
	return true
func _has_ev(sim, k: String) -> bool:
	for e in sim.ev: if str(e.get("k", "")) == k: return true
	return false
func _all_maps_have_stall() -> bool:
	for ck in ZD.D().maps:
		var mk = ZD.D().maps[ck].market
		if not (mk.st as Dictionary).has(ML.SID) or not (mk.paths as Dictionary).has(ML.SID): return false
		var p = Vector2(float(mk.st[ML.SID][0]), float(mk.st[ML.SID][1]))
		for sid in mk.st:
			if sid == ML.SID: continue
			var q = Vector2(float(mk.st[sid][0]), float(mk.st[sid][1]))
			if absf(q.x - p.x) < 120.0 and absf(q.y - p.y) < 120.0: _p("近 %s %s %s" % [ck, sid, q]); return false
	return true

# ================= 平衡模擬：兵對兵（只計小隊：名鬼無敵唔出手、敵方主將移走），睇三種配置嘅勝負同剩血 =================
func balance(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	if m.get("mv_view") != null and m.mv_view.sim != null: m.mv_view.sim.paused = true
	_team3(S)
	var B = J.G.Battle; var G = J.G
	var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
	G["__nat_battle"] = func(_t, _a): return true
	G["__nat_btSize"] = func(_t, _a): return [390.0, 560.0]
	var TB = [1.0, 1.08, 1.16, 1.32, 1.48, 1.64]
	var TE = [0, 1, 2, 3, 4, 5]      # 預計嗰關兵器級
	var rows = []
	for c in [0, 1, 2, 3, 4, 5]:
		var p = J.num(J.G.CHAPTERS[c].stages[2].p)
		S.lv = float(clampi(int(round(ML.lr(p))), 1, 20))
		S.bld["barracks"] = round((TB[c] - 1.0) / 0.08); S.bld["home"] = maxf(1.0, J.num(S.bld.get("home", 1)))
		BK.st(); BK.st()["def"] = 0.0; BK.st()["sweep"] = {}
		var cfgs = [["只靠陰兵", 200, {}], ["陰兵+遊魂兵（預計兵器）", 200, {str(TE[c]): 150.0}], ["陰兵+遊魂兵（加班戰甲）", 200, {"6": 150.0}], ["陰兵減半+遊魂兵", 100, {str(TE[c]): 150.0}]]
		for cf in cfgs:
			var res = []
			for rep in 3:
				S.res.troops = float(cf[1]); S["militia"] = {"v": 1.0, "n": (cf[2] as Dictionary).duplicate()}
				res.append(_duel(B, c))
			var w = 0; var ours = 0.0; var foes = 0.0; var tt = 0.0
			for r in res:
				if r.win: w += 1
				ours += r.our; foes += r.foe; tt += r.t
			var line = "BAL 第%d關 x-3 p%.0f F=%d　%s：兵力 %d　勝 %d/3　我方剩血 %d%%　敵方剩血 %d%%　%.0f 秒" % [c + 1, p, ML.foe_army(p), cf[0], int(J.num(B.get("ml_my", 0))), w, int(ours / 3.0 * 100), int(foes / 3.0 * 100), tt / 3.0]
			_p(line); rows.append(line)
	G["__nat_battle"] = ob; G["__nat_btSize"] = osz
	S.erase("militia")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func _duel(B, c: int) -> Dictionary:
	J.mc(B, "start", [float(c), 2.0])
	var keep = []
	for u in B.units:
		if J.num(u.side) == 0 and not J.t(u.get("minion")):
			u.hp = 1e9; u.maxhp = 1e9; u.atk = 0.0; u.spd = 0.0; u.sk = null; u.x = 16.0; keep.append(u)
		elif J.num(u.side) == 1 and not J.t(u.get("minion")):
			if not keep.any(func(x): return J.num(x.side) == 1 and not J.t(x.get("minion"))):   # 留一隻敵方主將做木樁（唔郁唔打、打唔死），免戰鬥提早結算
				u.hp = 1e9; u.maxhp = 1e9; u.atk = 0.0; u.spd = 0.0; u.sk = null; u.x = 386.0; u.energy = 0.0; keep.append(u)
		else: keep.append(u)
	B.units = keep
	B.adviser = null
	var tt = 0.0
	for i in 5400:
		J.mc(B, "update", [1.0 / 30.0]); tt += 1.0 / 30.0
		var my = 0; var fo = 0
		for u in B.units:
			if J.num(u.hp) <= 0 or not J.t(u.get("minion")): continue
			if J.num(u.side) == 0: my += 1
			else: fo += 1
		if my == 0 or fo == 0 or B.get("result") != null: break
	var oh = 0.0; var om = 0.0; var fh = 0.0; var fm = 0.0
	for u in B.units:
		if not J.t(u.get("minion")): continue
		if J.num(u.side) == 0: oh += maxf(0.0, J.num(u.hp)); om += J.num(u.maxhp)
		else: fh += maxf(0.0, J.num(u.hp)); fm += J.num(u.maxhp)
	var r = {"win": fh <= 0.0 and oh > 0.0, "our": oh / maxf(1.0, om), "foe": fh / maxf(1.0, fm), "t": tt}
	B.active = false; B.result = null
	return r

# ================= 截圖 =================
func _shots(t, m) -> void:
	var S = J.G.S
	var nv = m.village
	S.lv = 6.0
	S.res.coins = 1e7
	for c in (SHOT_MAPS if SHOT_MAPS.size() else [0, 1, 2, 3, 4, 5]):
		m.mv_view.sim.st().ci = float(c); m.mv_view._after_move(); await _w(t, 1.2)
		ZD.reveal_all(c)
		var sim = m.mv_view.sim
		var mv = sim.st()
		if mv.st.has(ML.SID): mv.st[ML.SID].unlocked = c != 3; mv.st[ML.SID].lv = 30.0
		if c == 5: mv.st["st_tangyi"].unlocked = true
		nv = m.village
		var p = MD.st_xy(c, ML.SID)
		var cam = nv.zone_cam()
		cam.z = clampf(nv.size.x / 560.0, cam.z_min(), cam.z_max())
		cam.center_on(p + Vector2(0, -40)); await _w(t, 1.0)
		await _shot(t, "stall_m%d" % c)
	if SHOT_MAPS.size(): _p("shots done"); return
	await _scene_shots(t, m)
	_p("shots done")

const MB = preload("res://game/zone/zone_battle.gd")
func _scene_shots(t, m) -> void:
	var S = J.G.S
	m.mv_view.sim.st().ci = 0.0; m.mv_view._after_move(); await _w(t, 1.5)
	ZD.reveal_all(0)
	await _skip(t, 4)
	var sc = m.mv_view; var sim = sc.sim; var mv = sim.st()
	sim.paused = false
	for sid in mv.st: mv.st[sid].unlocked = true
	mv.st["st_zhishan"].lv = 12.0; mv.st[ML.SID].lv = 26.0   # ★2 紙紮藤牌
	S.erase("militia")
	for sid in MD.stations(0):
		var g = str(MD.st_def(sid).get("good", ""))
		mv.counter[g] = 20.0
	S.mat = {"m_strip": 200.0, "m_rope": 200.0, "m_bao": 200.0, "m_paper": 200.0, "m_wellwater": 200.0, "m_bamboo": 200.0}
	# 排隊：一個遊魂兵客
	sim.custs.clear()
	var rec = null
	for i in 200:
		if sim.spawn_cust() and J.t(sim.custs[sim.custs.size() - 1].get("ml")): rec = sim.custs[sim.custs.size() - 1]; break
		if sim.custs.size() >= 3: sim.custs.pop_front()
	var nv = m.village; var cam = nv.zone_cam()
	cam.z = clampf(nv.size.x / 420.0, cam.z_min(), cam.z_max())
	var ctr = MD.v2(MD.layout(0).counter)
	cam.center_on(ctr + Vector2(-40, -80)); await _w(t, 4.0)
	await _shot(t, "ml_01_queue_recruit")
	# 付錢 → 加入（飄字＋第一次劇情）
	if rec != null and rec in sim.custs:
		rec.got = rec.wants.duplicate(); sim._pay(rec)
	await _w(t, 0.5)
	await _shot(t, "ml_02_join_float")
	await _w(t, 1.2)
	await _shot(t, "ml_03_story")
	await _skip(t, 8)
	# 兵器檔資料卡
	S.militia.n = {"2": 60.0, "1": 50.0, "0": 40.0}
	sc.open_sheet(ML.SID); await _w(t, 1.2)
	await _shot(t, "ml_04_stall_sheet")
	sc.close_sheet(); await _w(t, 0.5)
	# 兵營面板
	S.bld["home"] = maxf(1.0, J.num(S.bld.get("home", 0))); S.bld["barracks"] = 3.0; S.res.troops = 180.0
	BK.open_panel(); await _w(t, 1.2)
	var sh = m.get("sheet")
	if sh != null and sh.has_method("get_v_scroll_bar"): pass
	await _shot(t, "ml_05_barracks_panel")
	var body = m.get("sheet_body")
	if body != null:
		var sc2 = body.get_parent()
		while sc2 != null and not (sc2 is ScrollContainer): sc2 = sc2.get_parent()
		if sc2 is ScrollContainer:
			for k in body.get_children():
				if k is PanelContainer and str(k.get_child(0).get_child(0).text if k.get_child(0).get_child_count() > 0 and k.get_child(0).get_child(0) is RichTextLabel else "").contains("遊魂兵"):
					sc2.scroll_vertical = int(k.position.y) - 40
			await _w(t, 0.6)
			await _shot(t, "ml_06_barracks_militia")
	if m.has_method("close_sheet"): m.close_sheet()
	await _w(t, 0.5)
	# 出擊構成：親自出征攻佔 B（p2.5 → 嘍囉 1 隊）及主線 2 關級（p6 野外王）
	_team3(S)
	S.zone.own.erase("0:C")
	var r = ZD.start_battle("cap", "C"); await _f(t, 2)
	if MB.cur != null:
		MB.t_skip_march(); await _w(t, 1.5)
		await _shot(t, "ml_07_battle_cap")
		MB.cur.quit(); await _f(t, 3)
	var okb = J.cl(J.G.get("$"), null, ["#b-ok"]) if J.G.get("$") != null else null
	if okb != null and okb.get("onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])
	await _w(t, 1.0); ZD.poll()
	for i in 60:
		if not MB.busy(): break
		await _w(t, 0.3)
	# 攻佔面板
	S.res.troops = 240.0
	load("res://game/zone/zone_view.gd").open_capture(m, "C"); await _w(t, 1.0)
	await _shot(t, "ml_08_capture_sheet")
	if m.has_method("close_sheet"): m.close_sheet()
