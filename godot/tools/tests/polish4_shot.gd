# [polish4] 打磨線截圖：6 張大排檔圖 × （大單卡／招牌卡／事件名＋收錢飄字／客人要貨氣泡＋對白框）
# GB_TEST：[["wait",3],["gdrun","res://tools/tests/polish4_shot.gd","all"],["quit"]]
# 輸出：環境變數 P4_OUT（預設 /tmp/polish4/shots/after/）
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const MVP = preload("res://game/outpost/mv_plus.gd")
const EV = preload("res://game/outpost/mv_event.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const M = preload("res://game/outpost/mat.gd")
const PT = preload("res://tools/tests/play_test.gd")
var OUT := "/tmp/polish4/shots/after/"
var sc = null

func _p(s) -> void: print("[polish4] ", s)
func _S(): return J.G.get("S")
func _wait(s: float) -> void: await Engine.get_main_loop().create_timer(s).timeout
var em = null
var vh := 700.0
func _cam(y: float) -> void: em.set_vcam(minf(-60.0, -em.eh() - float(sc.top_pad) + y - vh * 0.5))   # 鏡頭中心放喺大排檔世界座標 y（保持 HUD 出現）
func _shot(name: String) -> void:
	var st = Engine.get_main_loop().root.get_node("Main").story
	for i in 10:
		if st.cur == null: break
		st.skip_scene(); await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	await RenderingServer.frame_post_draw
	var img = Engine.get_main_loop().root.get_viewport().get_texture().get_image()
	img.save_png(OUT + name + ".png"); _p("SHOT " + OUT + name + ".png")

func all(tt) -> void:
	var eo = OS.get_environment("P4_OUT")
	if eo != "": OUT = eo
	DirAccess.make_dir_recursive_absolute(OUT)
	var pt = PT.new()
	var m = tt.main()
	if m.has_method("_hide_title"): m._hide_title(); await _wait(1.0)
	for i in 6:
		var st0 = m.get("story")
		if st0 and st0.get("cur") != null: st0.skip_scene()
		await _wait(0.25)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _wait(0.6)
	# 合一地圖（正式玩法）真場景
	sc = m.mv_view; em = m.mv_embed
	vh = m.village.size.y / (m.village.size.x / 390.0)
	for ci in MD.maps_n():
		pt._setup(1000000000.0); var S = _S(); J.test_clock = -1.0
		S.mv = {"ci": float(ci)}
		var sim = sc.sim; sim.st(); MVW.ws().t0 = 9999.0
		sc._after_move(); await _wait(0.5)
		var P = sim.plus
		var ids = MD.stations(ci)
		for sid in ids:
			S.mv.st[sid].unlocked = true; S.mv.st[sid].lv = 12.0; S.mv.counter[str(MD.st_def(sid).good)] = 8.0
		S.res["coins"] = 1234567890.0
		P.ps(sim).ev_t = 9999.0; P.ps(sim).ord_t = 9999.0
		await _wait(0.6)
		var tag = "m%d" % (ci + 1)
		# 1. 左下小卡＋大單卡＋招牌卡（合一地圖真場景）
		P.ps(sim).sign[str(ci)] = {"n": 1234567.0}
		sim.custs.clear(); sim.spawn_t = 999.0
		_cam(sim.L.counter_y)
		EV.make_order(P, sim); await _wait(2.8)   # 等「有大單！」橫幅過咗
		sc._pexp = 8.0; await _wait(0.3)   # 玩法掣展開
		await _shot(tag + "_chips")
		sc._pexp = 0.0
		P.card = {"k": "order", "i": 0}; await _wait(0.5)
		await _shot(tag + "_order_card")
		P.card = {"k": "sign"}; await _wait(0.5)
		await _shot(tag + "_sign_card")
		P.card = null
		# 1b. 鏡頭喺大排檔頂（睇台）：玩法掣收埋
		_cam(float(sim.st_pos(str(ids[0])).y) + 60.0); await _wait(0.6)
		await _shot(tag + "_chips_top")
		P.ps(sim).orders.clear()
		# 2. 事件名＋收錢／紙錢飄字（飄字起點故意放喺事件名度）
		EV.start_ev(P, sim, "special")
		var e = P.live.ev
		if e is Dictionary and e.has("pos"):
			_cam(float(e.pos.y))
			await _wait(2.2)   # 等事件大字飄走
			var p0: Vector2 = e.pos + Vector2(0, -62)
			for i in 3:
				sc._float(p0 + Vector2(-20 + 20 * i, 6 * i), "+" + MD.fmt(12345.0 * (i + 1)), sc.GOLD, 22, 1.6)
				await _wait(0.25)
			await _wait(0.2)
			await _shot(tag + "_ev_float")
		P.live.ev = null
		# 3. 客人要貨氣泡＋對白框（4 個排隊客，頭兩個講嘢）
		_cam(sim.L.counter_y)
		var gs = []
		for sid in ids: gs.append(str(MD.st_def(sid).good))
		var ks = ["n30_guhangui", "n30_dugui", "n30_jiugui", "n30_taozhai"]
		for g in gs: S.mv.counter[g] = 0.0
		for i in 4:
			var w = {gs[i % gs.size()]: 1 + i}
			if i % 2 == 1 and gs.size() > 1: w[gs[(i + 1) % gs.size()]] = 1
			var c = {"cid": "c0_guhan", "k": ks[i], "wants": w, "got": {}, "st": "queue", "slot": i, "take": 0.3,
				"s": sim.queue_s(i), "pos": sim.queue_pos(i), "ph": float(i), "flip": true, "tp": ["reg", "haggle", "none", "picky"][i]}
			if i == 3: c["star_need"] = {gs[3 % gs.size()]: 2.0}
			sim.custs.append(c)
		await _wait(0.6)
		for i in 2:
			var c = sim.custs[i]
			sc._bubble(c.pos + Vector2(-90, -120), "等咗好耐喇，幾時到我呀？", MD.S("cust", "客人", "客人"), 3.0)
		await _wait(0.5)
		await _shot(tag + "_want_bubbles")
		sim.custs.clear(); sc.bubbles.clear()
	_p("P4 SHOTS DONE")
