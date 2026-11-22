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
	for id in J.G.get("BLD_ORDER"): S.bld[id] = 1.0
	await _w(t, 1.0)
	var nv = m.village; var c = nv.zone_cam()
	var z0 = nv.size.x / 390.0
	var POS = J.G.POS
	var vp = t.get_viewport()
	var k = float(vp.get_visible_rect().size.x) / 390.0
	for id in POS:
		var p = Vector2(J.num(POS[id][0]), J.num(POS[id][1]))
		c.z = z0 * 2.0; c.center_on(p + Vector2(0, -30)); await _w(t, 0.9)
		for j in 6:
			var st2 = m.get("story")
			if st2 and st2.get("cur") != null: st2.skip_scene()
		await RenderingServer.frame_post_draw
		var im = vp.get_texture().get_image()
		var sp = nv.zone_w2s(p) + nv.global_position
		var px = sp * (float(im.get_width()) / vp.get_visible_rect().size.x)
		var hw = 105.0 * 2.0 * float(im.get_width()) / 390.0
		var r = Rect2i(int(px.x - hw), int(px.y - hw * 1.45), int(hw * 2), int(hw * 1.9)).intersection(Rect2i(0, 0, im.get_width(), im.get_height()))
		im.get_region(r).save_png(out + "/" + id + ".png")
		print("[bs] ", id, " ", sp, " ", r)
	print("[bs] done")
