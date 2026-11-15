# 線 I 測試輔助（tester：["gdrun","res://game/minis/_t.gd","方法"]）
extends RefCounted
func gy_solve(_t) -> void:
	var G = J.G.Graveyard
	for so in G.souls: J.mc(G, "place", [so.i, J.gp(G.p.souls[int(J.num(so.i))], "grave")])
	J.mc(G, "submit", [])
	print("TGY correct=", J.mc(G, "correct", []), " phase=", G.phase)
func gy_wrong(_t) -> void:
	var G = J.G.Graveyard
	for so in G.souls: J.mc(G, "place", [so.i, (int(J.num(J.gp(G.p.souls[int(J.num(so.i))], "grave"))) + 1) % G.p.graves.size()])
	J.mc(G, "submit", [])
	print("TGY wrong correct=", J.mc(G, "correct", []), " tries=", G.tries)
func gy_sel(_t) -> void: print("TSEL ", J.G.Graveyard.get("sel"))
func st_dbg(_t) -> void:
	for k in MiniStage.all:
		var r = MiniStage.all[k]
		print("TSEL ", k, " vis=", r.visible, " susp=", r._suspended, " stage=", r.stage.position, r.stage.size, " active=", r.obj.get("active"), " disp=", r._el(r.root_sel).style.get("display") if r._el(r.root_sel) else "noel", " W=", r.obj.get("W"), " H=", r.obj.get("H"), " vh=", r.obj.get("vh"))
	print("TSEL stack=", MiniStage.stack.size())
