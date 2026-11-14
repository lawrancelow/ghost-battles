# 臨時效能量度
extends RefCounted
static func run(types: Array) -> void:
	var rec = Recorder.new(); var ctx = Ctx.new(rec)
	var ART = J.G.get("ART")
	for ty in types:
		var o = {"t": 1.0, "walk": true, "pose": "move", "flip": false, "tamed": true, "untied": true, "tdx": 40.0, "tdy": 0.0, "alpha": 1.0}
		var t0 = Time.get_ticks_usec()
		for i in 20: rec.clear(); J.mc(ART, "drawChar", [ctx, ty, 100.0, 200.0, 0.99, o.duplicate()])
		var js_us = (Time.get_ticks_usec() - t0) / 20.0
		var n = rec.cmds.size()
		var t1 = Time.get_ticks_usec(); var nat = -1.0
		if Art.CHAR_H.has(ty):
			for i in 20: rec.clear(); Art.draw_char(ctx, ty, 100.0, 200.0, 0.99, o.duplicate())
			nat = (Time.get_ticks_usec() - t1) / 20.0
		var pup = J.t(J.mc(J.G.get("Puppet"), "has", [ty])) if J.G.get("Puppet") else false
		print("BENCH ", ty, " js_us=", int(js_us), " cmds=", n, " native_us=", int(nat), " puppet=", pup, " mesh=", J.t(J.mc(J.G.get("MeshAnim"), "has", [ty])))

static func village() -> void:
	var V = J.G.get("Village")
	var t0 = Time.get_ticks_usec()
	for i in 20: J.mc(V, "update", [0.033])
	var t1 = Time.get_ticks_usec()
	MeshAnim.prof_us = 0; MeshAnim.prof_n = 0
	for i in 20: J.mc(V, "draw", [])
	var t2 = Time.get_ticks_usec()
	print("VBENCH mesh=%.2fms n=%d" % [MeshAnim.prof_us / 20000.0, MeshAnim.prof_n / 20])
	for i in 20: J.cl(J.G.get("produce"), null, [0.033])
	var t3 = Time.get_ticks_usec()
	for i in 20: J.mc(J.G.get("UI"), "refresh", [])
	var t4 = Time.get_ticks_usec()
	print("VBENCH update=%.2fms draw=%.2fms produce=%.2fms uirefresh=%.2fms" % [(t1 - t0) / 20000.0, (t2 - t1) / 20000.0, (t3 - t2) / 20000.0, (t4 - t3) / 20000.0])

static func vparts() -> void:
	var V = J.G.get("Village"); var ART = J.G.get("ART"); var ctx = J.gp(V, "ctx"); var S = J.G.S; var t = J.num(J.gp(V, "t"))
	var tm = func(label: String, f: Callable):
		var t0 = Time.get_ticks_usec()
		for i in 10: f.call()
		print("VPART %s %.2fms" % [label, (Time.get_ticks_usec() - t0) / 10000.0])
	tm.call("ground", func(): J.mc(ctx, "drawImage", [J.cl(J.G.get("groundLayer"), null, []), 0.0, 0.0, J.num(J.G.get("W")), J.num(J.G.get("WH"))]))
	tm.call("lily", func():
		for i in 9: J.cl(J.G.get("drawLily"), null, [ctx, 20.0 + i * 40, 40.0, t]))
	tm.call("buildings", func():
		for id in J.G.get("BLD_ORDER"):
			var p = J.G.get("POS")[id]
			if J.t(S.bld.get(id)): J.mc(ART, "drawBuilding", [ctx, id, p[0], p[1], S.bld[id], t, null]))
	tm.call("trees", func():
		var i = 0
		for p in J.G.get("TREE_POS"): J.mc(ART, "drawTree", [ctx, p[0], p[1], S.trees[i], t, false, J.num(S.trees[i]) == 3, float(i)]); i += 1)
	tm.call("paddy", func():
		var i = 0
		for p in J.G.get("PADDY_POS"): J.mc(ART, "drawPaddy", [ctx, p[0], p[1], S.paddy[i], t, float(i)]); i += 1)
	tm.call("decor", func():
		for d in J.G.get("DECOR"): J.mc(ART, "drawDecor", [ctx, d[0], d[1], d[2], t]))
	tm.call("workers", func():
		var spots = J.mc(V, "workerSpots", []); var W = J.G.get("WORK")
		for s in spots: J.mc(W, "drawWorker", [ctx, s, t, 0.62, {}]))
	tm.call("plaza_logic", func():
		var idle = []
		for g in S.ghosts: if g.get("post") == null and g.k != "afu": idle.append(g)
		var items = []; var vis = []
		J.mc(J.G.get("PlazaLife"), "frame", [V, idle, items, vis, ctx, t]))
	var idle2 = []
	for g in S.ghosts: if g.get("post") == null and g.k != "afu": idle2.append(g)
	var items2 = []; var vis2 = []
	J.mc(J.G.get("PlazaLife"), "frame", [V, idle2, items2, vis2, ctx, t])
	print("VPART plaza items=", items2.size(), " idle=", idle2.size())
	tm.call("plaza_draw", func():
		for it in items2: J.cl(it.f, null, []))
	tm.call("hero", func(): J.mc(ART, "drawChar", [ctx, "afu", 195.0, 400.0, 0.72, {"t": t, "act": "hero_idle", "at": 1.0}]))
	tm.call("pointer", func(): J.mc(V, "drawPointer", [ctx, t]))
