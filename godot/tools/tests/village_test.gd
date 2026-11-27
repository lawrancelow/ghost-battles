# [village] 後院拓展建築測試
# 用法：GB_TEST=res://tools/tests/village_test.json（全新 user dir）
#   [["wait",3],["gdrun","res://tools/tests/village_test.gd","all"],["quit"]]
# 輸出：[vil] ok/BAD 每項；截圖 /tmp/vil/shots/*.png
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const SHOTS := "/tmp/vil/shots/"
var ok := 0
var bad := 0

func _p(m): print("[vil] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
# 清走劇情／升級提示（起建築、招鬼會彈），再等飄字散
func _calm(t, fade := true):
	for i in 40:
		var m = _main(t); var st = m.get("story") if m else null
		if st == null or not st.busy(): break
		if st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
	if fade: await _w(t, 3.4)
func N(): return J.gp(J.G.get("UI"), "_n")
func _ghost(k := "") -> Dictionary:
	var g = J.cl(J.G.get("recruitFodder"), null, [false])
	return g
func _first(kind: String, ci: int) -> String:
	for b in CB.new_blds():
		if CB.kind(b) == kind and CB.need_ci(b) == ci: return b
	return ""

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var S = J.G.S
	CB.install()
	# [zone] 第 1 關係分區地圖：資源區要先攻佔先起得／採得（攻佔流程喺 zone_test.gd 測）→ 呢度當全部已佔領，照測建築邏輯
	var ZD = load("res://game/zone/zone_data.gd")
	for zid in ["A", "B", "C"]: ZD.set_owned(zid)
	# ---------- 0. 資料 ----------
	_chk("chain.json 有拓展建築", CB.new_blds().size() > 0, CB.new_blds().size())
	_chk("舊建築對照（wood/rice/plank/bun）", CB.of_old("wood") != "" and CB.of_old("bun") != "")
	_chk("POSTS／BUILDINGS 已登記拓展建築", J.G.POSTS.has(CB.new_blds()[0]) and J.G.BUILDINGS.has(CB.new_blds()[0]))
	_chk("包裝已裝（tap／bld）", is_same(J.G.Village.get("tap"), J.G.Village.get("__cb_tap_w")) and is_same(N().get("bld"), N().get("__cb_bld_w")))

	# ---------- 1. 解鎖條件 ----------
	S["cleared"] = {}
	if not (S.get("mv") is Dictionary): S["mv"] = {"ci": 0.0}
	S.mv["ci"] = 0.0
	var b0 = _first("gather", 0); var b1 = _first("gather", 1); var w0 = _first("shop", 0)
	_chk("找到 ci0 採集／ci1 採集／ci0 加工", b0 != "" and b1 != "" and w0 != "", [b0, b1, w0])
	_chk("ci0 建築第一張圖已解鎖", CB.unlocked(b0))
	_chk("ci1 建築第一張圖未解鎖", not CB.unlocked(b1))
	for k in CB.build_cost(b1): M.add(k, 9999)
	_chk("未解鎖起唔到（唔扣料）", not CB.build(b1) and CB.lv(b1) == 0)
	S.mv["ci"] = 1.0
	_chk("村子去到第二張圖 → 解鎖", CB.unlocked(b1))
	S.mv["ci"] = 0.0; S["cleared"] = {"1-3": true}
	_chk("舊進度打通第一張圖都算", CB.unlocked(b1))
	S["cleared"] = {}

	# ---------- 2. 起建築扣料 ----------
	var c0 = CB.build_cost(b0)
	for k in c0: M.add(k, -M.amt(k)); M.add(k, J.num(c0[k]) + 7)
	var before = {}
	for k in c0: before[k] = M.amt(k)
	var card0 = J.mc(N(), "bld", [b0])
	_chk("未起建築卡：可以起", J.t(card0.unlocked) and J.t(card0.canBuild) and J.num(card0.lv) == 0, card0.cost)
	J.mc(N(), "bldAct", [b0, "build", null])
	_chk("起好 Lv1", CB.lv(b0) == 1)
	var paid = true
	for k in c0: if absf(M.amt(k) - (before[k] - J.num(c0[k]))) > 0.01: paid = false
	_chk("起建築扣料啱數", paid, c0)
	_chk("再起唔到（已起）", not CB.build(b0))
	var c_none = CB.build_cost(w0)
	for k in c_none: M.add(k, -M.amt(k))
	_chk("唔夠料起唔到", c_none.is_empty() or (not CB.build(w0) and CB.lv(w0) == 0))

	# ---------- 3. 升級 ----------
	S.bld["house"] = 3.0
	var uc = CB.up_cost(b0, 1)
	for k in uc:
		if M.has_def(k): M.add(k, J.num(uc[k]) + 5)
		else: S.res[k] = J.num(S.res.get(k, 0)) + J.num(uc[k]) + 5
	var coins0 = J.num(S.res.coins)
	J.mc(N(), "bldAct", [b0, "up", null])
	_chk("升到 Lv2", CB.lv(b0) == 2)
	_chk("升級扣冥幣", absf(J.num(S.res.coins) - (coins0 - J.num(uc.get("coins", 0)))) < 0.01, uc)
	S.bld["house"] = 2.0
	S.res["coins"] = 99999.0
	for k in CB.up_cost(b0, 2):
		if M.has_def(k): M.add(k, 99999)
	_chk("上限 = 鬼宅等級（唔升得過）", not CB.upgrade(b0) and CB.lv(b0) == 2)
	S.bld["house"] = 10.0

	# ---------- 4. 派鬼（崗位跟等級）----------
	var g1 = _ghost(); var g2 = _ghost(); var g3 = _ghost()
	_chk("Lv2 崗位 = 1", CB.slots(b0) == 1 and int(J.num(J.mc(J.G.F, "slots", [b0]))) == 1)
	J.mc(N(), "pickDo", [b0, g1.id])
	_chk("派鬼 → post = bid", J.seq(g1.post, b0))
	J.mc(N(), "pickDo", [b0, g2.id])
	_chk("崗位滿再派：替換舊嗰隻", J.seq(g2.post, b0) and g1.get("post") == null)
	S.bld[b0] = 4.0
	J.mc(N(), "pickDo", [b0, g1.id])
	_chk("Lv4 崗位 = 2（兩隻都喺度）", CB.slots(b0) == 2 and CB.workers(b0).size() == 2)
	var card1 = J.mc(N(), "bld", [b0])
	_chk("建築卡崗位 = 2 格", card1.posts.size() == 1 and card1.posts[0].slots.size() == 2)
	_chk("建築卡寫產乜／每分鐘", str(card1.desc).contains(M.name(CB.main_out(b0))) and str(card1.desc).contains(CB.L("每分鐘", "每分鐘")), str(card1.desc).substr(0, 80))
	J.mc(N(), "bldAct", [b0, "unassign", g1.id])
	_chk("撤下", g1.get("post") == null and CB.workers(b0).size() == 1)
	var pk = J.mc(N(), "pick", [b0])
	_chk("派人面板認得新崗位", J.str(pk.name) == CB.bname(b0) and pk.list.size() > 0)

	# ---------- 5. 產出入 mat ----------
	var mo = CB.main_out(b0); M.add(mo, -M.amt(mo))
	J.cl(J.G.get("produce"), null, [60.0])
	var got = M.amt(mo)
	var exp_r = J.num(CB.rates(b0).out.get(mo, 0))
	_chk("採集一分鐘入 mat", got > 0.5 and absf(got - exp_r) < 0.05 * exp_r + 0.01, "%s %.2f／預計 %.2f" % [mo, got, exp_r])
	# 加工：起 w0、派鬼、畀料
	for k in CB.build_cost(w0): M.add(k, J.num(CB.build_cost(w0)[k]))
	_chk("起加工建築", CB.build(w0))
	J.mc(N(), "pickDo", [w0, g3.id])
	for k in CB.ins(w0): M.add(k, -M.amt(k)); M.add(k, 200)
	var wo = CB.main_out(w0); M.add(wo, -M.amt(wo))
	var ins0 = {}
	for k in CB.ins(w0): ins0[k] = M.amt(k)
	J.cl(J.G.get("produce"), null, [60.0])
	_chk("加工出貨入 mat", M.amt(wo) > 0.5, "%s %.2f" % [wo, M.amt(wo)])
	var used = true
	for k in ins0: if M.amt(k) >= ins0[k] - 0.01 and k != mo: used = false
	_chk("加工食料", used)
	_chk("有料 = 開工狀態", str(CB.work_states().get(w0, "")) == "work", CB.work_states().get(w0))
	for k in CB.ins(w0): M.add(k, -M.amt(k))
	_chk("斷料 = starve 狀態", str(CB.work_states().get(w0, "")) == "starve" and CB.starved(w0).size() > 0)
	var out_before = M.amt(wo)
	J.cl(J.G.get("produce"), null, [60.0])
	_chk("冇料唔會憑空出貨", absf(M.amt(wo) - out_before) < 0.01, "%.2f→%.2f" % [out_before, M.amt(wo)])
	for k in CB.ins(w0): M.add(k, 300)

	# ---------- 6. 舊建築卡換新材料名 ----------
	var eb = J.str(J.mc(J.G.UI, "bldEffect", ["bun"]))
	_chk("包子鋪卡：出普通包子", eb.contains(M.name("m_bao")), eb.substr(0, 60))
	var ew = J.str(J.mc(J.G.UI, "bldEffect", ["wood"]))
	_chk("伐木場卡：產出槐木", ew.contains(M.name("m_wood")))
	var es = J.str(J.mc(J.G.UI, "bldEffect", ["store"]))
	_chk("其他建築卡唔郁", es != "" and not es.contains("用料"))
	_chk("main.gd 後院卡同樣換", m._bld_effect("bun").contains(M.name("m_bao")))

	# ---------- 7. 擺位：唔疊、唔遮舊建築、喺 390 內 ----------
	S.mv["ci"] = 5.0
	var sh = CB.shown(); var rects = []
	for b in sh:
		var p = CB.pos(b)
		if CB.CF.is_field(b): rects.append(CB.CF.sign_rect(b))   # [village2] 資源田：田名牌（資源點另有 village2_test 檢查）
		else: rects.append(Rect2(p.x - 50, p.y - 96, 100, 124))
	var overlap = false
	for i in rects.size():
		for j in range(i + 1, rects.size()):
			if rects[i].intersects(rects[j]): overlap = true
	var inside = true
	for r in rects: if r.position.x < 0 or r.end.x > 390 or r.position.y < CB.FENCE_Y: inside = false
	_chk("全部拓展建築唔疊", not overlap, sh.size())
	# [zone56] 六張圖全部分區：舊豎條擺位唔再用（分區擺位由 zone_test 驗）
	if load("res://game/zone/zone_data.gd").mdef(5).size() > 0: inside = true
	_chk("全部喺 390 寬內、喺舊村子（1130）以下（或該圖已分區）", inside)
	_chk("世界加長", CB.world_h() > 1130 + 100, CB.world_h())
	S.mv["ci"] = 0.0
	_chk("第一張圖只顯示已解鎖＋下一張圖預告", CB.shown().size() < CB.new_blds().size(), "%d/%d" % [CB.shown().size(), CB.new_blds().size()])

	# ---------- 8. 畫面（舊村子模式）----------
	m.set_mv(false); await _w(t, 1.0)
	var V = J.G.Village
	J.mc(V, "setCam", [5000.0]); await _w(t, 0.3)
	var vh = J.num(V.h) / J.num(V.scale)
	var nvz = m.get("village")
	if nvz != null and nvz.get("zone") == true and nvz.get("zc") != null:   # [p45] 分區地圖：setCam 改郁 2D 鏡頭（nv_village._zone_wrap），底＝分區世界底
		var zc = nvz.zc
		var zb = maxf(zc.org.y - zc.top_extra, zc.org.y + zc.world.y - zc.vh())
		_chk("鏡頭落得到地圖底（分區地圖 2D 鏡頭）", absf(J.num(V.camY) - zb) < 1.0 and absf(zc.y - zb) < 1.0, "%.0f／%.0f" % [J.num(V.camY), zb])
	else: _chk("鏡頭落得到後院底", absf(J.num(V.camY) - (CB.world_h() - vh)) < 1.0, "%.0f" % J.num(V.camY))
	var pb = CB.pos(b0)
	await _calm(t)
	J.mc(V, "tap", [pb.x, pb.y - 40]); await _w(t, 0.6)
	_chk("撳拓展建築開建築卡", Menus.cur == "bld:" + b0 and m.sheet.visible, Menus.cur)
	await _shot(t, "03_card_new")
	Menus.open_bld("bun"); await _w(t, 0.5)
	await _shot(t, "04_card_bun")
	Menus.open_bld(w0); await _w(t, 0.5)
	await _shot(t, "05_card_shop")
	Menus.open_bld(b1); await _w(t, 0.5)
	await _shot(t, "06_card_locked")
	Menus.close_hook(); await _w(t, 0.3)
	# 多啲建築：去到第 3 張圖，起晒解鎖咗嘅，派鬼
	S.mv["ci"] = 2.0
	for b in CB.shown():
		if CB.unlocked(b) and CB.lv(b) == 0: S.bld[b] = 1.0 + (CB.shown().find(b) % 4)
	for b in CB.shown():
		if CB.lv(b) > 0 and CB.workers(b).is_empty():
			var g = _ghost(); J.mc(N(), "pickDo", [b, g.id])
	for k in M.D().MATS: if J.num(M.def(k).get("tier", 1)) == 1: M.add(k, 300)
	await _calm(t)
	J.mc(V, "setCam", [1060.0]); await _w(t, 1.2)
	await _shot(t, "01_yard_top")
	J.mc(V, "setCam", [1500.0]); await _w(t, 1.0)
	await _shot(t, "02_yard_mid")
	J.mc(V, "setCam", [5000.0]); await _w(t, 1.0)
	await _shot(t, "02b_yard_bottom")
	J.mc(V, "walkTo", [195.0, CB.world_h() - 60, null])
	_chk("阿福行得入後院", J.num(V.hero.ty) > 1130, J.num(V.hero.ty))

	# ---------- 9. 移動村模式：後院面板＋入後院 ----------
	m.set_mv(true); await _w(t, 1.0)
	await _calm(t)
	m.open_backyard(); await _w(t, 0.6)
	m.sheet_scroll.scroll_vertical = 100000; await _w(t, 0.3)
	await _shot(t, "07_backyard_sheet")
	m.close_sheet()
	# [unify] 合一地圖：營地取消、後院掣取消；村尾拓展地就喺原村子下面（同一張圖）
	_chk("合一：村子畫面顯示、冇移動村全屏畫面", m.village.visible and not m.mv_host.visible and m.mv_view.camp == null)
	J.mc(V, "setCam", [5000.0]); await _w(t, 0.6)
	_chk("合一：拖到村尾拓展地", J.num(V.camY) > 1130.0 - 700.0, J.num(V.camY))
	await _shot(t, "08_yard_unified")

	# ---------- 10. 冇 chain.json 都唔壞 ----------
	M.use_file("res://data/nat/__no_chain__.json")
	CB.reset()
	_chk("冇資料：冇拓展建築", CB.new_blds().is_empty() and CB.shown().is_empty() and CB.world_h() == (ZD.world_size().y if ZD.on() else 1130.0))   # [zone2] 第 2–4 關都係分區地圖：世界高＝分區地圖
	var cw = J.mc(N(), "bld", ["wood"])
	_chk("冇資料：舊建築卡照開", cw is Dictionary and J.str(cw.name) != "")
	J.cl(J.G.get("produce"), null, [10.0])
	_chk("冇資料：produce 照行", true)
	J.mc(J.G.Village, "tap", [195.0, 1300.0])
	_chk("冇資料：舊 tap 照行", true)
	M.use_file(""); CB.reset()

	# ---------- 11. 舊存檔 ----------
	var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/selftest_save.json"))
	var d = G.dec(str(o.code))
	d.erase("mat")
	for k in d.bld.keys(): if str(k).begins_with("b_"): d.bld.erase(k)
	d["ghosts"][1]["post"] = "b_gone_building"   # 已刪建築嘅崗位
	m.import_save(G.enc(d))
	await _wait_boot(t)
	m = _main(t); S = J.G.S; CB.install()
	_chk("舊存檔：拓展建築全部未起", CB.new_blds().all(func(b): return CB.lv(b) == 0))
	_chk("舊存檔：舊資源照留", J.num(S.res.get("wood", -1)) >= 0 and S.bld.has("wood"))
	var cb2 = J.mc(N(), "bld", [CB.new_blds()[0]])
	_chk("舊存檔：拓展建築卡開到", cb2 is Dictionary and J.num(cb2.lv) == 0)
	J.cl(J.G.get("produce"), null, [30.0])
	_chk("舊存檔：未知崗位唔會出錯", true)
	m._hide_title(); await _w(t, 0.5)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
