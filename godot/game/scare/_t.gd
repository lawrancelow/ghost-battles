extends RefCounted
func a0(_t): ScRun.t_act(0)
func a1(_t): ScRun.t_act(1)
func a2(_t): ScRun.t_act(2)
func a3(_t): ScRun.t_act(3)
func a4(_t): ScRun.t_act(4)
func a6(_t): ScRun.t_act(6)
func a7(_t): ScRun.t_act(7)
func a8(_t): ScRun.t_act(8)
func a9(_t): ScRun.t_act(9)
func a10(_t): ScRun.t_act(10)
func s1(_t): ScSelect._toggle("toyol")
func s2(_t): ScSelect._toggle("eguiking")
func s3(_t): ScSelect._go()
class PT extends Node:
	var first := true
	var other: Node
	var acc := 0
	var n := 0
	func _process(_d):
		if first: set_meta("t", Time.get_ticks_usec())
		else:
			var t0 = other.get_meta("t", 0); acc += Time.get_ticks_usec() - t0; n += 1
			if n == 30: print("[pt] process-span=%.1fms frame=%.1fms" % [acc / 30000.0, Performance.get_monitor(Performance.TIME_PROCESS) * 1000]); acc = 0; n = 0
func pm(t):
	var a = PT.new(); a.process_priority = -100000; var b = PT.new(); b.first = false; b.other = a; b.process_priority = 100000
	t.get_tree().root.add_child(a); t.get_tree().root.add_child(b)
	var by_cls = {}
	for nd in t.get_tree().root.find_children("*", "", true, false):
		if nd.is_processing() and nd.can_process(): by_cls[nd.get_class() + ":" + str(nd.get_script().resource_path.get_file() if nd.get_script() else "")] = by_cls.get(nd.get_class() + ":" + str(nd.get_script().resource_path.get_file() if nd.get_script() else ""), 0) + 1
	print("[pt] processing nodes ", by_cls)
func vis(t):
	var m = t.get_tree().root.get_node("Main")
	for c in m.get_children():
		if c is CanvasItem and c.visible: print("[vis] ", c.name, " ", c.get_class(), " kids=", c.find_children("*", "", true, false).size())
	for c in t.get_tree().root.get_children(): print("[root] ", c.name, " ", c.get_class(), " ", c.visible if c is CanvasItem else "")
func rs(t):
	for i in 3:
		await t.get_tree().create_timer(1.0).timeout
		print("[rs] drawcalls=", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), " prims=", Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME), " objs=", Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME), " fps=", Engine.get_frames_per_second())
static func _npc(k: String) -> Variant:
	for n in ScRun.cur.Sc.npcs: if J.str(n.d.k) == k: return n
	return null
func boss(_t):
	var S = ScRun.cur.Sc; var b = _npc("boss")
	if b == null: print("no boss"); return
	b["act"] = "present"; S["follow"] = false; S["userPan"] = 999.0
	S["camX"] = J.mc(S, "clampCam", [J.num(b.x) - J.num(J.mc(S, "viewW", [])) * 0.5])
	print("[boss] x=", b.x, " act=", b.act, " daily=", b.get("daily"))
func guard(_t):
	var S = ScRun.cur.Sc; var b = _npc("guard")
	if b == null: print("no guard"); return
	b["act"] = "doze"; S["follow"] = false; S["userPan"] = 999.0
	S["camX"] = J.mc(S, "clampCam", [J.num(b.x) - J.num(J.mc(S, "viewW", [])) * 0.5])
	print("[guard] x=", b.x, " daily=", b.get("daily"))
func cnt(t):
	var tot = 0; var by = {}
	for nd in t.get_tree().root.find_children("*", "CanvasItem", true, false):
		if nd.is_visible_in_tree():
			tot += 1; var p = str(nd.get_path()).split("/"); var key = "/".join(p.slice(0, mini(5, p.size())))
			by[key] = by.get(key, 0) + 1
	var ks = by.keys(); ks.sort_custom(func(a, b): return by[a] > by[b])
	print("[cnt] visible=", tot, " ", ks.slice(0, 8).map(func(k): return "%s=%d" % [k, by[k]]))
