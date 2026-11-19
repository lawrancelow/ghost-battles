# [idle] 資料卡截圖（自己睇：字 ≥14px、唔爆格）
extends RefCounted
func shots(tt) -> void:
	var T = load("res://tools/tests/idle_test.gd").new(); T._setup()
	var S = J.G.get("S"); J.test_clock = -1.0
	var m = tt.main()
	var sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvIdleShot"
	var cl = CanvasLayer.new(); cl.layer = 50; Engine.get_main_loop().root.add_child(cl); cl.add_child(sc)
	sc.size = Engine.get_main_loop().root.get_visible_rect().size
	sc.setup(m)
	var sim = sc.sim; sim.st()
	var CH = load("res://game/outpost/mv_idle.gd").chain(0)
	S.mv.st[CH[0]].lv = 9.0; S.res["coins"] = 5000.0
	sim.assign(CH[0], 0, "t_id1"); sim.assign("fore:" + CH[0], 0, "t_id2")
	sc.on_show()
	await Engine.get_main_loop().create_timer(1.0).timeout
	sc.open_sheet(CH[0]); await Engine.get_main_loop().create_timer(1.0).timeout
	print("[idleshot] sheet y=%.0f h=%.0f" % [sc.sheet.position.y, sc.sheet.size.y])
	Engine.get_main_loop().root.get_texture().get_image().save_png("/tmp/idleshot/a_sheet_gate.png")
	S.mv.st[CH[0]].made_n = 1e4; S.mv.st[CH[0]].lv = 26.0; sc._fill_sheet()
	await Engine.get_main_loop().create_timer(1.0).timeout
	Engine.get_main_loop().root.get_texture().get_image().save_png("/tmp/idleshot/b_sheet_lv26.png")
	sc.close_sheet(); sc.focus_station(CH[1]); await Engine.get_main_loop().create_timer(1.0).timeout
	Engine.get_main_loop().root.get_texture().get_image().save_png("/tmp/idleshot/c_locked.png")
	cl.queue_free()
