extends RefCounted
func all(t):
	await t.get_tree().create_timer(6.0).timeout
	var m = t.get_tree().root.get_node_or_null("Main")
	var nv = m.village
	for ch in nv.world.get_children(): print("[dbg] ", ch.name, " ", ch.get_class(), " vis=", ch.visible, " mat=", ch.material, " n=", ch.get_child_count())
	var VS = load("res://game/village_style.gd")
	print("[dbg] dark_on=", VS.dark_on, " lamp_seen=", Art.lamp_seen.size(), " RAD=", PtGfx.RAD)
