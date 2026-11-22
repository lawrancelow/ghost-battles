extends RefCounted
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
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.25)
	var S = J.G.S
	for sex in ["m", "f"]:
		S.hero["sex"] = sex
		await _w(t, 0.5)
		var nv = m.village; var cam = nv.zone_cam(); var H = J.G.Village.hero
		for z in [1.0, 1.8]:
			cam.z = nv.size.x / 390.0 * z; cam.center_on(Vector2(J.num(H.x), J.num(H.y) - 30)); await _w(t, 1.0)
			await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png("%s/%s_%s.png" % [out, sex, str(z)])
	print("[hero] done")
