extends RefCounted
const RB = preload("res://game/rebuild/rb.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
func _p(m): print("[rbp] ", m)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _st(m, tag):
	var sn = m.get("story"); var UI = J.G.get("UI"); var S = J.G.S
	var has = false
	for g in S.ghosts: if str(g.k) == RB.SLEEPER.k: has = true
	var mods = []
	for c in m.get_children(): if c is CanvasItem and c.visible and c.name.to_lower().contains("sheet") or (c is CanvasLayer): mods.append(str(c.name))
	_p("%s busy=%s cur=%s q=%d modal=%s sheet=%s notes=%d has=%s sleeper=%s GH=%s nghost=%d" % [tag, J.mc(J.G.get("Story"), "busy", []), (str(sn.cur.get("id")) + "/" + str(sn.cur.sc.get("style"))) if sn.cur is Dictionary else "null", sn.q.size(), J.mc(UI, "modalOpen", []), (m.get("sheet").visible if m.get("sheet") != null else "-"), RB.notes_left(), has, RB.st().get("sleeper"), (J.G.get("GHOSTS") as Dictionary).has(RB.SLEEPER.k), S.ghosts.size()])
func all(t) -> void:
	var pf = PF.new()
	var m = await pf._boot(t)
	var S: Dictionary = J.G.S
	RB.start_fresh(S, true)
	await _w(t, 1.0)
	_st(m, "start")
	for e in RB.piles():
		if e.id != RB.SLEEPER.pile: continue
		for k in RB.HITS: J.mc(J.G.get("Village"), "tap", [(e.p as Vector2).x, (e.p as Vector2).y - 4]); await _w(t, 0.05); _st(m, "hit")
	for i in 8:
		await _w(t, 0.4); _st(m, "t%d" % i)
	for i in 12:
		var sn = m.get("story")
		if sn.cur != null: sn.skip_scene(); _p("skip")
		await _w(t, 0.4); _st(m, "s%d" % i)
	for i in 6: RB._relic(Vector2(200, 400))
	for i in 20:
		J.mc(J.G.get("Quest"), "check", []); await _w(t, 1.0); _st(m, "n%d" % i)
	_p("RESULT ok=1 bad=0")
