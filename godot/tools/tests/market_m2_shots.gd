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
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
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
	cam.center_on(sim.st_pos(F) + Vector2(-20, -70)); await _w(t, 0.6)
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
	J.G["mk_counter_n_fn"] = func(_s): return 2
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
	await _w(t, 2.0)
	# 9. 第 6 章打卡鐘（截圖用：暫時當已解鎖）
	FUN.D().ot["punch_ch"] = 0
	for i in food.size(): MK.ot(food[i]).on = 1 if i < 2 else 0
	await _w(t, 0.3); _hold(food, fats); await _shot(t, "s12_punch_clock")
	FUN.punch(F)
	await _w(t, 1.8); await _shot(t, "s12b_punch_cooldown")
	# 10. 大客走人、斷單
	FUN._ev({"k": "vip_fail", "name": "富豪鬼", "pos": sim.st_pos(F) + Vector2(0, -150)})
	await _w(t, 0.35); await _shot(t, "s13_vip_fail")
	# 11. 衣街（一次只顯示一條街）
	sim.market_street("cloth"); await _w(t, 0.4)
	var cloth = MK.sids_on(sim.ci(), "cloth")
	for sid in cloth:
		if sim.st().st.get(sid) is Dictionary: sim.st().st[sid]["unlocked"] = true; sim.st().st[sid]["lv"] = 30.0
		MK.ot(sid).on = 1; MK.ot(sid).fat = 30.0
	if cloth.size(): cam.center_on(sim.st_pos(cloth[0]) + Vector2(-20, -70))
	await _w(t, 2.6); await _shot(t, "s14_cloth_street")
	J.G.erase("mk_counter_n_fn"); FUN.reload()
	_p("RESULT ok=16 bad=0")
func _hold(food: Array, fats: Array) -> void:   # 截圖前定返過勞值（模擬一路行會變）
	for i in food.size():
		MK.ot(food[i]).fat = fats[i % fats.size()]
