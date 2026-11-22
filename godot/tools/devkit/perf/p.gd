extends RefCounted
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _ms(t, secs := 2.5) -> float:
	await _w(t, 0.4)
	var n = 0; var t0 = Time.get_ticks_usec()
	while Time.get_ticks_usec() - t0 < secs * 1e6:
		await RenderingServer.frame_post_draw; n += 1
	return (Time.get_ticks_usec() - t0) / 1000.0 / max(1, n)
func all(t):
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
	while J.num(S.lv) < 5: J.cl(J.G.get("give"), null, [{"exp": 5.0}])
	for i in 80:
		await _w(t, 0.2)
		if m.story.cur != null: m.story.skip_scene()
	var nv = m.village
	for spot in ["hero", "market"]:
		var cam = nv.zone_cam()
		if spot == "hero": cam.center_on(Vector2(J.num(J.G.Village.hero.x), J.num(J.G.Village.hero.y)))
		else: cam.center_on(load("res://game/zone/zone_data.gd").zrect("market").get_center())
		var base = await _ms(t)
		print("[perf] %s base %.1fms" % [spot, base])
		var kids = []
		var root = null
		for c in nv.get_children(): if c is Node2D: root = c
		for c in root.get_children(): if c is CanvasItem and c.visible: kids.append(c)
		for c in nv.ysort.get_children(): if c is CanvasItem and c.visible and kids.size() < 40 and (c.get("tag") != null): kids.append(c)
		for c in kids:
			c.visible = false
			var v = await _ms(t, 1.5)
			c.visible = true
			if base - v > 1.5: print("[perf] %s hide %s(%s tag=%s) -> %.1fms (省 %.1f)" % [spot, c.name, c.get_class(), str(c.get("tag")), v, base - v])
		var ys = nv.ysort
		var n_items = ys.get_child_count()
		print("[perf] ysort children ", n_items)
	print("[perf] done")
