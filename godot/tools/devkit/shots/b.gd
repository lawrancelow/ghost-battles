extends RefCounted
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func all(t):
	var out = OS.get_environment("BS_OUT")
	DirAccess.make_dir_recursive_absolute(out)
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
	var half = OS.get_environment("BS_HALF") == "1"
	var n = 0
	if OS.get_environment("BS_DARK") == "0": load("res://game/village_style.gd").dark_on = false
	for id in J.G.get("BLD_ORDER"):
		n += 1
		if half and n % 2 == 0: continue
		S.bld[id] = 1.0
	await _w(t, 1.0)
	var nv = m.village; var c = nv.zone_cam()
	var z0 = nv.size.x / 390.0
	var pts = [["graves", 445, 215, 0.95], ["pit", 895, 215, 0.95], ["market", 670, 760, 0.62], ["A", 150, 1572, 0.95], ["B", 1190, 1572, 0.95], ["C", 670, 2204, 0.95], ["all", 670, 1200, 0.30], ["v1", 670, 1300, 1.0], ["v2", 670, 1600, 1.0]]
	for p in pts:
		c.z = z0 * p[3]; c.center_on(Vector2(p[1], p[2])); await _w(t, 0.8)
		await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(out + "/" + p[0] + ".png")
	print("[bs] done z0=", z0, " size=", nv.size, " POS=", J.G.POS)
