extends RefCounted
func run(_t):
	var m = load("res://jsgen/moves_chain.gd").new(); m.run(null)
	var K = J.G.MoveKit
	var M0 = J.construct(J.gp(K, "M"), [])
	print("[mk] M0=", M0)
	var m1 = J.mc(M0, "t", [10.0, 20.0])
	print("[mk] t(10,20)=", m1, " pt(1,1)=", J.mc(m1, "pt", [1.0, 1.0]))
	var m2 = J.mc(m1, "r", [0.5])
	print("[mk] r=", m2, " pt(1,0)=", J.mc(m2, "pt", [1.0, 0.0]))
	var m3 = J.mc(m2, "s", [2.0, 3.0]); print("[mk] s=", m3, " pt(1,1)=", J.mc(m3, "pt", [1.0, 1.0]))
