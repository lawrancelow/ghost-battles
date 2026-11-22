extends RefCounted
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _cnt(n: Node) -> int:
	var k = 1
	for c in n.get_children(): k += _cnt(c)
	return k
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
	var nv = m.village
	print("[tr] total nodes ", _cnt(t.get_tree().root))
	for c in t.get_tree().root.get_children(): print("[tr] root/", c.name, " ", _cnt(c))
	for c in m.get_children(): if _cnt(c) > 20: print("[tr] main/", c.name, " ", c.get_class(), " ", _cnt(c))
	for c in nv.get_children(): print("[tr] nv/", c.name, " ", c.get_class(), " ", _cnt(c))
	for c in nv.world.get_children(): print("[tr] world/", c.name, " ", c.get("tag"), " ", _cnt(c))
	for c in nv.ysort.get_children(): if _cnt(c) > 1: print("[tr] ysort/", c.name, " ", c.get_class(), " ", _cnt(c))
	print("[tr] done")
