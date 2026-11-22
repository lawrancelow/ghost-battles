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
	if OS.get_environment("XF") != "": S.hero["sex"] = "f"; S.hero["name"] = "阿慧"; S.hero["full"] = "陳嘉慧"; S.hero["set"] = true
	print("[x] ghosts0 ", S.ghosts.map(func(g): return g.k), " team ", S.team)
	while J.num(S.lv) < 4: J.cl(J.G.get("give"), null, [{"exp": 5.0}])
	for i in 60:
		await _w(t, 0.3)
		if m.story.cur != null: m.story.advance()
	print("[x] ghosts1 ", S.ghosts.map(func(g): return [g.k, g.post]), " team ", S.team, " seen ", S.seen.get("gift_xiaozhi2"))
	var nv = m.village; var cam = nv.zone_cam()
	var PL = J.G.Village.get("plaza") 
	for p in [["hero", Vector2(J.num(J.G.Village.hero.x), J.num(J.G.Village.hero.y))]]:
		cam.center_on(p[1]); await _w(t, 1.0); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png("%s/%s.png" % [out, p[0]])
	var zp = load("res://game/zone/zone_data.gd").cur().get("village", {}).get("plaza")
	print("[x] plaza ", zp)
	if zp is Array and zp.size() >= 2:
		cam.center_on(Vector2(float(zp[0]), float(zp[1]))); await _w(t, 1.5); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png("%s/plaza.png" % out)
	m.open_roster(); await _w(t, 1.0); await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png("%s/roster.png" % out)
	print("[x] done")
