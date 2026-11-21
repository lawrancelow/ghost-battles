extends RefCounted
func all(t):
	var ZD = load("res://game/zone/zone_data.gd"); ZD.gate_on = true
	var MS = load("res://game/outpost/mv_story.gd"); if "pace_on" in MS: MS.pace_on = true
	var tr = t.get_tree()
	var done_nc = false
	for k in 30:
		if not done_nc:
			var nc = null
			for n in tr.root.find_children("*", "Control", true, false):
				if n.get_script() != null and str(n.get_script().resource_path).ends_with("name_card.gd"): nc = n; break
			if nc != null:
				done_nc = true
				nc.call_deferred("t_next"); await tr.create_timer(0.6).timeout
				if is_instance_valid(nc): nc.call_deferred("t_pick", "m"); await tr.create_timer(0.6).timeout
				if is_instance_valid(nc): nc.call_deferred("t_ok"); await tr.create_timer(1.0).timeout
		var st0 = t.main().story
		if st0 != null and st0.cur != null: st0.skip_scene()
		await tr.create_timer(0.5).timeout
	for k in 40:
		var st = t.main().story
		if st != null and st.cur != null: st.skip_scene()
		await tr.create_timer(0.5).timeout
	await RenderingServer.frame_post_draw
	tr.root.get_viewport().get_texture().get_image().save_png("/tmp/repro/a1.png")
	var S = J.G.S
	print("REPRO mv_on=", S.get("mv_on"), " ci=", ZD.ci(), " on=", ZD.on(), " applied=", ZD.applied(), " gate=", J.G.POS.get("gate"), " tree0=", J.G.TREE_POS[0], " W=", J.G.W, " trees=", S.get("trees"), " paddy=", S.get("paddy"))
	var nv = null
	for n in tr.root.find_children("*", "", true, false):
		if n.get_script() != null and str(n.get_script().resource_path).ends_with("nv_village.gd"): nv = n
	print("REPRO nv zone=", nv.zone if nv else "none")
	for k in 20:
		await tr.create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	tr.root.get_viewport().get_texture().get_image().save_png("/tmp/repro/a2.png")
	print("REPRO2 on=", ZD.on(), " applied=", ZD.applied(), " tree0=", J.G.TREE_POS[0])
