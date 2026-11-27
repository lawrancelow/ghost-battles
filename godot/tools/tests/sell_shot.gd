# [sell] 錄影：手撳嘆氣蒸籠做壽包 → 自動送櫃台 → 客人攞到付錢（每 0.2 秒截一張，之後 ffmpeg 合成）
extends RefCounted
func shots(tt) -> void:
	var S = J.G.get("S")
	DirAccess.make_dir_recursive_absolute("/tmp/sellshot")
	var m = tt.main()
	var sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvSellShot"
	var cl = CanvasLayer.new(); cl.layer = 50; Engine.get_main_loop().root.add_child(cl); cl.add_child(sc)
	sc.size = Engine.get_main_loop().root.get_visible_rect().size
	sc.setup(m)
	var sim = sc.sim; sim.st()
	S.mat["m_bao"] = 100.0; S.res["buns"] = 0.0
	sim.set_route("st_shoubao", "auto")
	sim.st().counter = {}; sim.st().pile = {}
	sc.on_show()
	await Engine.get_main_loop().create_timer(0.5).timeout
	sim.custs.clear(); sim.spawn_t = 1e9
	var c = {"cid": "t", "k": "youhun", "wants": {"m_shoubao": 2}, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": sim.QLEN, "pos": MD().poly_at(sim.QP, sim.QLEN), "ph": 0.0, "flip": true, "lines": [], "vip": false, "tp": "none"}
	sim.custs.append(c)
	var a = sim.st_pos("st_shoubao"); var b = sim.L.counter
	sc.focus((a.y + b.y) * 0.5, sc.top_pad + sc.view_h() * 0.5)
	print("[sellshot] station=%s counter=%s" % [str(a), str(b)])
	var tap_t = 0.0
	for i in 80:
		sim.spawn_t = 1e9
		tap_t += 0.2
		if tap_t >= 0.6: tap_t = 0.0; sim.tap_station("st_shoubao")
		await Engine.get_main_loop().create_timer(0.2).timeout
		Engine.get_main_loop().root.get_texture().get_image().save_png("/tmp/sellshot/f%03d.png" % i)
	print("[sellshot] got=%s st=%s coins=%.0f" % [str(c.got), str(c.st), J.num(S.res.coins)])
	cl.queue_free()
func MD(): return load("res://game/outpost/mv_data.gd")
