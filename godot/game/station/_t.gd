# 測試用：tester gdrun
extends RefCounted
func turf(_t) -> void:
	var tf = J.G.get("Street").Turf
	J.mc(tf, "open", ["office"])
func enter(_t) -> void:
	var tf = J.G.get("Street").Turf
	J.mc(tf, "enter", [true])
func info(_t) -> void:
	var tf = J.G.get("Street").Turf
	print("TURF on=", tf.get("on"), " walkers=", (tf.get("walkers") as Array).size() if tf.get("walkers") is Array else -1, " wal=", J.gp(tf.get("sd"), "wal"))
func dbg(_t) -> void:
	var m = Engine.get_main_loop().root.get_node("Main")
	for c in m.get_children(): print("CH ", c.name, " vis=", c.visible if c is CanvasItem else "-", " ", c.get_class())
	if StTurf.cur: print("STAGE ", StTurf.cur.stage.size, " ", StTurf.cur.size, " box=", StTurf.cur.Tf.get("box"))
func pick(_t) -> void:
	var tf = J.G.get("Street").Turf
	J.mc(tf, "pickRole", [0.0])
func buy(_t) -> void:
	var e = J.cl(J.G.get("$"), null, ["#stt-pick [data-r]"])
	print("BUY el=", e != null)
	if e: J.cl(J.gp(e, "onclick"), e, [{}])
func fast(_t) -> void:
	var tf = J.G.get("Street").Turf
	var q = tf.get("q"); q["t"] = 0.1
	for p in tf.sd.posts: if p is Dictionary and J.num(p.get("build", 0)) > 0: p["build"] = 0.05
	print("FAST q=", q.st)
static var acc := {}
func wrap(_t) -> void:
	var tf = J.G.get("Street").Turf
	for m in ["tick", "devTick", "roleTick", "walkerFx", "traitTick", "traceTick", "bossTick", "queueTick", "obsTick", "specialTick", "wp", "alive", "hit", "dist", "sqWalk", "bump", "reroute", "wseg", "fire", "puzzleTick", "los", "rdist", "fgCover", "ambush", "rect", "staffMul", "stats"]:
		var orig = tf.get(m)
		if not (orig is Callable): print("nowrap ", m); continue
		var mm = m
		tf[m] = func(th, a):
			var q0 = Time.get_ticks_usec(); var r = orig.call(th, a)
			var k = acc.get(mm, [0, 0]); k[0] += Time.get_ticks_usec() - q0; k[1] += 1; acc[mm] = k
			return r
	acc.clear()
func report(_t) -> void:
	var ks = acc.keys(); ks.sort_custom(func(a, b): return acc[a][0] > acc[b][0])
	print("[tick] ", ", ".join(ks.map(func(k): return "%s %.0fms(%d)" % [k, acc[k][0] / 1000.0, acc[k][1]])))
	acc.clear()
func close(_t) -> void:
	J.mc(J.G.get("Street").Turf, "close", [])
func sp(_t) -> void:
	J.mc(J.G.get("Street").Turf, "specialPick", [])
func streetback(_t) -> void:
	J.mc(J.G.get("Street"), "close", []); J.mc(J.G.get("World"), "open", [])
func wrapd(_t) -> void:
	var tf = J.G.get("Street").Turf
	var objs = [[tf, ["drawSprite", "drawAcc", "drawSqAcc", "drawDfx", "drawProp", "say", "drawFg", "wOff", "drawTraces", "drawObsFx", "drawProps", "drawLongBg", "drawCaps", "draw"]], [J.G.get("DevFx"), ["frame", "draw", "trigOf"]], [J.G.get("StnFoes"), ["drawBody"]]]
	for ob in objs:
		var o = ob[0]
		if o == null: continue
		for m in ob[1]:
			var orig = o.get(m)
			if not (orig is Callable): print("nowrap ", m); continue
			var mm = m
			o[m] = func(th, a):
				var q0 = Time.get_ticks_usec(); var r = orig.call(th, a)
				var k = acc.get(mm, [0, 0]); k[0] += Time.get_ticks_usec() - q0; k[1] += 1; acc[mm] = k
				return r
	acc.clear()
