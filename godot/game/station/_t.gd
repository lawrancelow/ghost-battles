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
	for m in ["frame", "hud", "tick", "devTick", "roleTick", "walkerFx", "traitTick", "traceTick", "bossTick", "queueTick", "obsTick", "specialTick", "wp", "alive", "hit", "dist", "sqWalk", "bump", "reroute", "wseg", "fire", "puzzleTick", "los", "rdist", "fgCover", "ambush", "rect", "staffMul", "stats"]:
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
func wdbg(_t) -> void:
	var tf = J.G.get("Street").Turf
	StDraw.N = J.G.get("Street")._n
	for w in tf.walkers:
		var spr = J.str(w.get("spr"))
		print("W spr=", spr, " ok=", StDraw.char_ok(spr), " js=", J.cl(StDraw.N.CHAR_H_OK, null, [spr]), " tex=", Spr.get_tex(spr), " foe=", w.get("foe"), " t=", w.get("t"), " gone=", w.get("gone"))
func post(_t) -> void:
	var tf = J.G.get("Street").Turf
	var sq = {"kind": "influencer", "mem": []}
	var shot = J.mc(tf, "sqShot", [[0.5, 0.6], true, sq])
	print("POST shot=", shot, " cv=", tf.get("_sqShotCv") != null)
	J.mc(tf, "sqPost", [sq, true, false, shot, "舊公司 二十三樓"])
func open_id(_t, id) -> void:
	var tf = J.G.get("Street").Turf
	if J.t(tf.get("on")): J.mc(tf, "close", [])
	J.mc(tf, "open", [id])
func boss(_t) -> void:
	var tf = J.G.get("Street").Turf
	var g = J.G.get("S").ghosts.filter(func(x): return J.str(x.k) == "eguiking")
	if g.size(): tf.sd.bosses = [g[0].id]; print("BOSS on")
func o_office(t) -> void: open_id(t, "office")
func o_cafe(t) -> void: open_id(t, "cafe")
func o_bus(t) -> void: open_id(t, "bus")
func o_market(t) -> void: open_id(t, "market")
func o_flat(t) -> void: open_id(t, "flat")
func ult(_t) -> void:
	var tf = J.G.get("Street").Turf
	var k = "xiaozhi"
	for p in tf.sd.posts: if p is Dictionary and p.get("g") != null:
		var g = J.cl(J.G.get("ghost"), null, [p.g]) if J.G.get("ghost") is Callable else null
		if g is Dictionary: k = J.str(g.get("k", k)); break
	tf["ult"] = {"t": 0.0, "i": -1, "pos": [0.5, 0.5], "k": k, "name": "紙人大軍", "gname": "測試鬼", "pw": 1, "pm": 1, "done": true, "fx": [], "dur": 3.0}
	print("ULT k=", k)
func bwin(_t) -> void:
	J.mc(J.G.get("Battle"), "finish", [true])
func blose(_t) -> void:
	J.mc(J.G.get("Battle"), "finish", [false])
func wild(_t) -> void:
	var N = J.G.get("N30W")
	for k in J.mc(N, "ids", []):
		if not J.t(J.mc(N, "owned", [k])) and J.t(J.mc(N, "open", [k])):
			print("WILD ", k); J.mc(N, "fight", [k]); return
	var ids = J.mc(N, "ids", [])
	print("WILD again ", ids[0]); J.mc(N, "fight", [ids[0]])
func scend(_t) -> void:
	J.mc(J.G.get("Scare"), "finish", [false])
func tipq(_t) -> void:
	var e = JSRun.by_id("pol-tip")
	var r = J.cl(J.G.get("$"), null, ["#st-street"])
	if r: print("STREET cls=", J.gp(r, "className"), " disp=", r.style.get("display"), " cs=", J.gp(J.cl(J.G.get("getComputedStyle"), null, [r]), "display") if J.G.get("getComputedStyle") else "?")
	print("TIPQ el=", e != null, " seen=", J.gp(J.gp(J.G.get("S"), "seen"), "policy_station"), " txt=", J.gp(e, "textContent") if e else "")
func tipn(_t) -> void:
	for n in Engine.get_main_loop().root.find_children("*", "NvPolTip", true, false): print("TIPN ", n.get_path(), " vis=", n.visible, " txt=", n.text.substr(0, 30))
	tipq(_t)
