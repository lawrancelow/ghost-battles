# L3 實玩測試：用 tester 的 gdrun 叫（["gdrun","res://tools/tests/l3_play.gd","bt"]）
extends RefCounted

func _p(m): print("[l3] ", m)

func bt(_t):
	var B = J.G.Battle; B["auto"] = true; B["speed"] = 2.0
	J.mc(B, "start", [0.0, 0.0]); _p("battle start")

func bt_res(_t):
	var B = J.G.Battle
	_p("battle res=%s t=%s" % [str(B.get("res")), str(B.get("t"))])

func wm(_t): J.mc(J.G.World, "open", []); _p("world open")
func wm_close(_t): J.mc(J.G.World, "close", []); _p("world close")

func sp(_t):
	J.mc(J.G.Sports, "open", [])
	J.mc(J.gp(J.G.Sports, "_n"), "go", ["jump"]); _p("sports jump via _n.go")
func sp_close(_t):
	var q = J.cl(J.G.get("$"), null, ["#sp-quit"])
	if q != null: J.cl(J.gp(q, "onclick"), q, [])
	_p("sports closed")
func sp_tap(_t):
	var G = J.G.Sports.get("_g")
	if G is Callable: G = G.call()
	_p("sports state=%s" % str(J.gp(J.G.Sports, "_g")).substr(0, 200))

func gy(_t): J.mc(J.G.Graveyard, "open", []); _p("graveyard open")
func gy_solve(_t):
	var Y = J.G.Graveyard
	for i in Y.souls.size(): J.mc(Y, "place", [float(i), Y.p.souls[i].grave])
	_p("graveyard placed correct=%s" % str(J.mc(Y, "correct", [])))
	J.mc(Y, "submit", [])
func gy_back(_t):
	var Y = J.G.Graveyard
	if Y.get("_endBack") != null: J.cl(Y._endBack, null, [])
	_p("graveyard back active=%s" % str(Y.active))
func gy_state(_t):
	var Y = J.G.Graveyard; _p("graveyard phase=%s night=%s" % [Y.get("phase"), J.G.S.yard.night])

func gs(_t): J.mc(J.G.GhostStreet, "open", []); J.mc(J.G.GhostStreet, "goStall", ["paper"]); _p("ghoststreet open")
func gs_buy(_t):
	var Q = J.G.GhostStreet
	_p("gs view=%s coins=%s" % [str(Q.view), str(J.G.S.res.coins)])
	var p = J.cl(J.G.get("$"), null, ["#gs-panel"])
	for b in J.iter(J.mc(p, "querySelectorAll", [".gs-buy"])):
		if not J.t(J.gp(b, "disabled")): J.cl(J.gp(b, "onclick"), b, []); break
	_p("gs bought fx=%s coins=%s" % [str(J.G.S.street.fx), str(J.G.S.res.coins)])
func gs_food(_t): J.mc(J.G.GhostStreet, "goStall", ["food"])
func gs_eat(_t):
	var p = J.cl(J.G.get("$"), null, ["#gs-panel"])
	for b in J.iter(J.mc(p, "querySelectorAll", [".gs-eat"])):
		if not J.t(J.gp(b, "disabled")): J.cl(J.gp(b, "onclick"), b, []); break
	_p("gs meal=%s" % str(J.G.S.street.meal))
func gs_close(_t): J.mc(J.G.GhostStreet, "close", [])
func sp_dbg(_t):
	var g = J.mc(J.G.Sports, "_g", []) if J.G.Sports.get("_g") is Callable else J.G.Sports.get("_g")
	if g == null: _p("sp_dbg G=null"); return
	_p("sp_dbg phase=%s H=%s k=%s nat=%s ctx=%s t=%s id=%s" % [J.gp(g, "phase"), J.gp(g, "H"), J.gp(g, "k"), J.gp(g, "_nat"), J.gp(g, "_natCtx") != null, J.gp(g, "t"), J.gp(g, "id")])
func sp_dom(_t):
	var d = J.cl(J.G.get("$"), null, ["#sports"])
	_p("sp_dom #sports=%s cls=%s html=%s" % [d != null, str(J.gp(d, "className")) if d != null else "", J.str(J.gp(d, "innerHTML")).substr(0, 300) if d != null else ""])
	var pnl = J.cl(J.G.get("$"), null, ["#sp-panel"]); var cv = J.cl(J.G.get("$"), null, ["#sp-cvs"])
	_p("sp_dom panel=%s cv=%s rect=%s" % [pnl != null, cv != null, str(J.mc(cv, "getBoundingClientRect", [])) if cv != null else ""])
	for n in Engine.get_main_loop().root.find_children("*", "SpPanel", true, false): _p("SpPanel node %s vis=%s size=%s" % [n.name, n.visible, n.size])
