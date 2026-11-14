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
