extends RefCounted
const ZD = preload("res://game/zone/zone_data.gd")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func all(t):
	var out = OS.get_environment("BS_OUT"); DirAccess.make_dir_recursive_absolute(out)
	var m = null
	for i in 120:
		await _w(t, 0.5)
		m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	m._hide_title(); await _w(t, 1.0)
	for i in 8:
		var st = m.get("story")
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	var S = J.G.S
	if OS.get_environment("BS_MIST") != "": load("res://game/outpost/mv_mist.gd").enabled = false
	var only = OS.get_environment("BS_CH")
	for c in [1, 2, 3, 0, 4, 5]:
		if only != "" and str(c) not in only: continue
		var sc = m.mv_view; sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.5)
		for z in ZD.zones(c):
			if str(z.type) == "res": S.zone.own[ZD._k(str(z.id), c)] = true
		for id in J.G.get("BLD_ORDER"): S.bld[id] = 1.0
		await _w(t, 1.0)
		var nv = m.village; var cam = nv.zone_cam(); var z0 = nv.size.x / 390.0
		var shots = [["all", ZD.rect(ZD.cur().get("cam", {}).get("world", [0, 0, ZD.cur().w, ZD.cur().h])).get_center() if false else Vector2(ZD.cur().w / 2.0, ZD.cur().h / 2.0), 0.26]]
		for z in ZD.zones(c):
			var r = ZD.rect(z.rect)
			shots.append([str(z.id), r.get_center(), 1.0 if str(z.type) == "village" else 0.9])
		for s in shots:
			cam.z = z0 * s[2]; cam.center_on(s[1]); await _w(t, 0.9)
			for j in 6:
				var st2 = m.get("story")
				if st2 and st2.get("cur") != null: st2.skip_scene()
			await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png("%s/c%d_%s.png" % [out, c, s[0]])
		print("[bs] ch ", c, " ok ", shots.size())
	print("[bs] done")
