# [market M2] 實機截圖（自己睇：字夠大、唔出格、唔重疊；一次只顯示一條街）
extends RefCounted
const MD = preload("res://game/outpost/mv_data.gd")
const MK = preload("res://game/market/mk_data.gd")
const FUN = preload("res://game/market/mk_fun.gd")
const RN = preload("res://game/market/mk_renown.gd")
const MKUI = preload("res://game/market/mk_fun_ui.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var SHOTS := "/home/claude/meeting/market/m2_shots/"
func _p(m): print("[m2shot] ", m)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
var ok := 0
var bad := 0
var _sc = null
const MKU = preload("res://game/market/mk_ui.gd")
func _chk(name: String, cond: bool, info = "") -> void:
	if cond: ok += 1
	else: bad += 1
	if not cond: _p("<<< 唔對 %s %s" % [name, str(info)])
func _scr(sc, r: Rect2) -> Rect2:
	var a: Vector2 = sc.w2s(r.position); var b: Vector2 = sc.w2s(r.end)
	return Rect2(a, b - a)
# 每張截圖都驗版面：頂部牌互不重疊／唔出畫面／字唔闊過框／街名牌字同鎖唔疊／對白泡同場景浮字唔鑽入頂部牌
func _lay(name: String) -> void:
	var sc = _sc; if sc == null: return
	var MKOU = load("res://game/market/mk_ops_ui.gd")
	var b: Array = MKUI.layout_bad(sc) + MKU.lay_bad(sc)
	var top = maxf(float(MKOU.hud_bot), 0.0)
	for d in sc._drects:
		var r = _scr(sc, d)
		if r.position.y < top - 0.5: b.append("對白泡鑽入頂部列 %s" % str(r))
		for q in MKUI.hud_rects: if r.intersects(q): b.append("對白泡撞頂部牌 %s" % str(r))
		for k in MKUI._wbtn: if (d as Rect2).intersects(MKUI._wbtn[k]): b.append("對白泡撞 %s" % str(k))
	for k in sc._wbtns:
		if not str(k).begins_with("ring:"): continue
		for q in MKUI.hud_rects: if (q as Rect2).intersects(_scr(sc, (sc._wbtns[k] as Rect2).grow(-8.0))): b.append("圓掣俾頂部牌遮住一半 %s" % str(k))
	var go = sc._btns.get("sortie") if sc._btns.has("sortie") else null
	for q in MKUI.hud_rects: if (q as Rect2).end.y > float(sc.view_h()) - 110.0: b.append("頂部牌排到太低 %s" % str(q))
	for f in sc.floats:
		var w = float(str(f.text).length()) * float(f.s); var c: Vector2 = sc.w2s(f.p)
		var fr = Rect2(c.x - w / 2.0, c.y - float(f.s) / 2.0, w, float(f.s))
		for q in MKUI.hud_rects: if fr.intersects(q): b.append("浮字撞頂部牌「%s」" % str(f.text))
	b.append_array(load("res://tools/tests/mk_layout_chk.gd").bad(sc))   # [57] 字唔畀頂部牌切開、事件牌／小卡／對白框唔疊唔貼
	_chk("版面 " + name, b.is_empty(), b)
func _has_toast(key: String) -> bool:
	for q in MKUI._toasts: if str(q.t).contains(key): return true
	return false
func _toast_clear_of_rings(sc, key: String) -> bool:   # 通告牌唔壓住「做／收」圓掣同加班牌
	var i = 0
	for q in MKUI._toasts:
		if str(q.t).contains(key):
			for r in MKUI.hud_rects:
				for k in sc._wbtns: if str(k).begins_with("ring:") and (r as Rect2).intersects(_scr(sc, sc._wbtns[k])): return false
		i += 1
	return true
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
	ok += 1; _lay(name)
func _vip(sim, got: int) -> void:
	var c = {"cid": "vip_rich", "k": "youhun", "wants": {"m_shoubao": 12, "m_douhua": 6}, "got": {"m_shoubao": got}, "st": "in", "slot": 99, "take": 9e9,
		"s": sim.QLEN, "pos": MD.poly_at(sim.QP, sim.QLEN), "ph": 0.0, "flip": true, "lines": [], "vip": true, "bigv": true,
		"vipn": MK.T(FUN.D().rush.vips[0].n), "vipart": str(FUN.D().rush.vips[0].art), "tend": FUN._clock() + 73.0}
	sim.custs.push_front(c)
func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sc = m.mv_view; var sim = sc.sim; var nv = m.village; var cam = nv.zone_cam()
	_sc = sc
	sc.mk_log = true   # [57]
	var S = J.G.S
	MK.st()["test"] = 1; MK.st().open = {"food": 1, "cloth": 1}
	FUN.reload(); S.erase("mkf"); S["mkr"] = {"v": 1, "pts": 260.0, "lv_seen": 2}
	S.mat["m_bao"] = 50.0
	sim.plus.off = true; sim.spawn_t = 1e9
	sim.market_street("food"); await _w(t, 0.3)
	var food = MK.sids_on(sim.ci(), "food")
	for sid in food:
		if sim.st().st.get(sid) is Dictionary: sim.st().st[sid]["unlocked"] = true; sim.st().st[sid]["lv"] = 12.0
	sc.hud_k = 1.0
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	var mid = Vector2.ZERO
	for i in mini(3, food.size()): mid += sim.st_pos(food[i])
	mid /= float(mini(3, food.size()))
	_p("stall pos " + str(food.map(func(x): return sim.st_pos(x))))
	var F = food[mini(1, food.size() - 1)]   # 主角攤：放喺畫面中間偏下，掛牌唔會俾 HUD 遮
	cam.center_on(sim.st_pos(F) + Vector2(-20, -70)); await _w(t, 2.6)   # 等 M1 切街標題卡收咗
	FUN.st().rush["next"] = FUN._clock() + 1e9; FUN.st().rush["ph"] = "idle"; FUN.st().rush["n"] = 1
	FUN.st().critic[str(sim.ci())] = {"n": 9, "next": 1e12}
	# 1. 加班牌＋過勞條（綠／黃／紅冒汗／老員工）
	var fats = [20.0, 86.0, 55.0, 40.0]
	for i in food.size():
		var o = MK.ot(food[i]); o.on = 1 if i != 2 else 0; o.fat = fats[i % fats.size()]; o.down = 0.0
		if i == 1: o.rank = 1; o["_rk"] = 1
	await _w(t, 0.3); _hold(food, fats); await _shot(t, "s1_overtime")
	# 2. 趴低＋餵包子；櫃台過勞條
	MK.ot(F).down = 48.0; MK.ot(F).on = 0; MK.ot(F)["_dn"] = 1
	var ck = FUN.ctr_key("food"); MK.ot(ck).fat = 62.0
	var MKO = load("res://game/market/mk_ops.gd")
	for i in 2:
		if not S.ghosts.any(func(g): return str(g.get("id")) == "t_sc%d" % i): S.ghosts.append({"id": "t_sc%d" % i, "k": "youhun", "name": "t_sc%d" % i, "lv": 1.0, "post": null})
		MKO.assign(sim, "ctr", "food", "t_sc%d" % i)
	await _w(t, 0.3); _hold(food, fats); MK.ot(F).down = 48.0; MK.ot(ck).fat = 62.0
	await _shot(t, "s2_down_feed")
	MK.ot(F).down = 0.0; MK.ot(F).fat = 40.0; fats[1] = 40.0
	# 2b. 櫃台：收銀人數、繁忙、過勞條
	if sim.L.has("counter_y"):
		for sid in food: MK.ot(sid).on = 1
		cam.center_on(Vector2(float(sim.L.counter_x1), float(sim.L.counter_y)) + Vector2(0, -60)); await _w(t, 0.5)
		MK.ot(ck).fat = 62.0; await _shot(t, "s2b_counter")
		cam.center_on(sim.st_pos(F) + Vector2(-20, -70)); await _w(t, 0.5)
	# 3. 子時高峰預告
	FUN.st().rush["ph"] = "warn"; FUN.st().rush["end"] = FUN._clock() + 27.0
	await _w(t, 2.4)   # 等上一批浮字散晒
	FUN._ev({"k": "rush_warn", "s": 30.0})
	await _w(t, 0.4); await _shot(t, "s3_rush_warn")
	# 4. 爆單＋限時大客＋連單
	FUN.st().rush["ph"] = "peak"; FUN.st().rush["end"] = FUN._clock() + 85.0
	_vip(sim, 5); FUN.st().chain = 7
	FUN._ev({"k": "chain", "n": 7, "mul": 1.6, "pos": sim.st_pos(F) + Vector2(0, -150)})
	await _w(t, 2.4); await _shot(t, "s4_rush_peak_vip_chain")
	sim.custs.clear(); FUN.st().chain = 0
	# 5. 喘息
	FUN.st().rush["ph"] = "rest"; FUN.st().rush["end"] = FUN._clock() + 52.0
	await _w(t, 2.0); await _shot(t, "s5_rush_rest")
	FUN.st().rush["ph"] = "idle"; FUN.st().rush["next"] = FUN._clock() + 1e9
	# 6. 潮流榜（撳開）＋名聲
	FUN.trend_list(sim); MKUI.trend_open = true
	await _w(t, 0.3); await _shot(t, "s6_trend_renown")
	MKUI.trend_open = false
	# 7. 里程碑／街組合 演出
	FUN._ev({"k": "mile", "sid": F, "lv": 25, "look": 1, "slots": 2})
	await _w(t, 0.35); await _shot(t, "s7_milestone")
	await _w(t, 1.6)
	FUN._ev({"k": "street_combo", "id": "c1_food3", "street": "food", "n": MK.T(FUN.D().combos["0"][0].n)})
	await _w(t, 0.35); await _shot(t, "s8_street_combo")
	await _w(t, 1.8)
	# 8. 評論家三星、熟客、名聲升級
	FUN._ev({"k": "critic", "res": [[F, 3]], "best": [F, 3]})
	await _w(t, 0.35); await _shot(t, "s9_critic")
	await _w(t, 2.0)
	FUN._ev({"k": "reg_name", "i": 0, "name": str(FUN.regs(sim.ci())[0].name), "art": str(FUN.regs(sim.ci())[0].art)})
	await _w(t, 0.35); await _shot(t, "s10_regular")
	await _w(t, 1.8)
	RN.add(600.0, "test")
	await _w(t, 0.35); await _shot(t, "s11_renown_up")
	_chk("名聲升級：出通告牌（有底板、排喺左欄），唔再浮喺場景中間", _has_toast("名聲升級") and not sc.floats.any(func(f): return str(f.text).contains("名聲升級")))
	_chk("名聲升級通告牌唔壓住「做」圓掣", _toast_clear_of_rings(sc, "名聲升級"))
	await _w(t, 2.0)
	# 9. 第 6 章打卡鐘（截圖用：暫時當已解鎖）
	FUN.D().ot["punch_ch"] = 0
	for i in food.size(): MK.ot(food[i]).on = 1 if i < 2 else 0
	sc.bubbles.clear(); sc._bubble(sim.st_pos(F) + Vector2(-100, -250), MKUI.L("你睇唔到我塊面？我自己都睇唔到。", "你看不到我的臉？我自己也看不到。"), MKUI.L("夥計", "店員"), 3.2)   # 特登擺到頂部牌位置：要自動落返嚟
	await _w(t, 0.3); _hold(food, fats); await _shot(t, "s12_punch_clock")
	_p("對白泡今格畫咗 %d 個（放唔落就唔出，唔會疊）" % sc._drects.size())
	_chk("打卡鐘：對白泡（有出嘅話）喺頂部牌下面", sc._drects.all(func(d): return _scr(sc, d).position.y >= maxf(float(load("res://game/market/mk_ops_ui.gd").hud_bot), float(MKUI.hud_bot)) - 0.5), sc._drects.map(func(d): return _scr(sc, d)))
	_chk("打卡鐘掣（世界）有出、冇俾頂部牌遮", MKUI._wbtn.keys().any(func(k): return str(k).begins_with("punch:")))
	FUN.punch(F)
	await _w(t, 1.8); await _shot(t, "s12b_punch_cooldown")
	# 10. 大客走人、斷單
	FUN._ev({"k": "vip_fail", "name": "富豪鬼", "pos": sim.st_pos(F) + Vector2(0, -150)})
	await _w(t, 0.35); await _shot(t, "s13_vip_fail")
	_chk("大客走人：出通告牌，唔再浮喺場景", (_has_toast("唔夠貨") or _has_toast("貨不夠")) and sc.floats.is_empty(), sc.floats.map(func(f): return f.text))
	# 10b. 最迫情況：高峰牌＋大客牌＋人物小卡＋三塊通告牌＋潮流榜打開，全部要排得落、互不重疊
	FUN.st().rush["ph"] = "peak"; FUN.st().rush["end"] = FUN._clock() + 85.0; _vip(sim, 5); FUN.st().chain = 12
	FUN._ev({"k": "reg_name", "i": 0, "name": str(FUN.regs(sim.ci())[0].name), "art": str(FUN.regs(sim.ci())[0].art)})
	FUN._ev({"k": "cashier", "sid": F}); FUN._ev({"k": "vip_in", "name": MK.T(FUN.D().rush.vips[0].n), "n": 18}); FUN._ev({"k": "street_combo", "n": MK.T(FUN.D().combos["0"][0].n)})
	await _w(t, 0.4); await _shot(t, "s13b_stress")
	_chk("最迫情況：三塊通告牌都喺度", MKUI._toasts.size() == 3, MKUI._toasts.size())
	var nrect = MKUI.hud_rects.size()
	MKUI.trend_open = true; await _w(t, 0.3); _lay("最迫情況＋潮流榜打開")
	_chk("潮流榜打開：左欄只剩潮流榜掣、連單牌、彈出框（其他牌暫時收埋）", MKUI.hud_rects.size() == 3 and nrect >= 7, [nrect, MKUI.hud_rects.size()])
	MKUI.trend_open = false; sim.custs.clear(); FUN.st().chain = 0; FUN.st().rush["ph"] = "idle"; FUN.st().rush["next"] = FUN._clock() + 1e9
	# 10c. 街名牌：四條街都鎖（最多鎖圖示）同全部開，字同鎖都唔出格、唔重疊、字號 ≥13
	MK.st().open = {"food": 1}; await _w(t, 0.3); await _shot(t, "s13c_tabs_locked")
	_chk("街名牌：四格有鎖圖示", MKU.lay.filter(func(d): return (d.lock as Rect2).size.x > 0.0).size() == 4, MKU.lay)
	MK.st().open = {"food": 1, "cloth": 1, "weapon": 1, "acc": 1, "lux": 1}; await _w(t, 0.3); _lay("街名牌全開")
	MK.st().open = {"food": 1, "cloth": 1}; await _w(t, 2.4)
	# 11. 衣街（一次只顯示一條街）
	sim.market_street("cloth"); await _w(t, 0.4)
	var cloth = MK.sids_on(sim.ci(), "cloth")
	for sid in cloth:
		if sim.st().st.get(sid) is Dictionary: sim.st().st[sid]["unlocked"] = true; sim.st().st[sid]["lv"] = 30.0
		MK.ot(sid).on = 1; MK.ot(sid).fat = 30.0
	if cloth.size(): cam.center_on(sim.st_pos(cloth[0]) + Vector2(-20, -70))
	await _w(t, 2.6); await _shot(t, "s14_cloth_street")
	for i in 2: MKO.unassign(sim, "t_sc%d" % i)
	FUN.reload()
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func _hold(food: Array, fats: Array) -> void:   # 截圖前定返過勞值（模擬一路行會變）
	for i in food.size():
		MK.ot(food[i]).fat = fats[i % fats.size()]
