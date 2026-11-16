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
func gs_eat(t):
	# 等阿福行到宵夜檔（view 轉做 food）先撳
	for i in 40:
		if J.str(J.G.GhostStreet.view.k) == "food": break
		await t.get_tree().create_timer(0.25).timeout
	_p("gs at stall view=%s" % str(J.G.GhostStreet.view))
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

# ---- 樓裡有鬼：實玩（入樓、逐層嚇住戶） ----
func _twG(): return J.cl(J.gp(J.G.window, "TWX").G, null, [])
func tw_open(_t): J.mc(J.G.Tower, "open", []); _p("tower open on=%s scene=%s" % [str(J.gp(J.G.Tower, "on")), J.cl(J.gp(J.G.window, "TWX").scene, null, [])])
func tw_start(_t):
	var X = J.gp(J.G.window, "TWX")
	if J.str(J.cl(X.scene, null, [])) != "play": J.mc(J.gp(J.G.window, "TW"), "press", ["lv_flat"])
	var G = _twG(); _p("tower start scene=%s res=%d guards=%d floors=%s" % [J.cl(X.scene, null, []), (G.res as Array).size(), (G.guards as Array).size(), str(J.gp(J.G.window, "TW").get("FL"))])
func tw_play(t):
	# 每 0.6 秒：揀一戶未嚇走、層數由低至高嘅住戶行過去；到咗就「嚇！」
	var TW = J.gp(J.G.window, "TW"); var scared = {}; var inU = 0
	for it in 60:
		var G = _twG()
		if J.t(G.get("over")): break
		if G.get("choice") is Array: J.mc(TW, "choose", [0.0])
		var ai = int(J.num(G.active)); var g = G.gh[ai]
		var U = J.gp(J.gp(J.G.window, "TWX"), "unit")
		if U != null and J.t(J.mc(U, "on", [])):
			# 入咗屋：逐個作怪點觸發＋嚇，嚇幾下就出屋
			var S = J.mc(U, "_S", []); var nsp = (S.spots as Array).size() if S != null else 0
			if nsp: J.mc(U, "trig", [float(it % nsp)])
			J.mc(U, "scare", [null]); inU += 1
			if inU >= 6: J.mc(U, "exit", ["door"]); inU = 0; _p("tw exit unit fear=%s" % str(G.fear))
			await t.get_tree().create_timer(0.6).timeout
			continue
		if not J.t(g.get("to")) and J.t(g.get("auto")) == false:
			var best = null
			for r in G.res:
				if J.str(r.state) != "home": continue
				var un = r.unit
				if not J.t(un.get("open")) and J.num(un.get("ot")) != 1: continue
				if best == null or J.num(G.nodes[J.str(un.id)].f) < J.num(G.nodes[J.str(best.unit.id)].f) - (1 if it % 3 else 0): best = r
			if best != null:
				if J.str(g.node) == J.str(best.unit.id): J.mc(TW, "press", ["scare"])
				else: J.mc(TW, "goto", [float(ai), best.unit.id])
		for r in G.res:
			if J.num(r.get("fear")) > 0 or J.str(r.state) == "flee": scared[int(J.num(G.nodes[J.str(r.unit.id)].f))] = true
		if it % 10 == 9: _p("tw it=%d t=%.1f fear=%s alert=%s floor=%s scaredFloors=%s" % [it, J.num(G.t), str(G.fear), str(G.alert), str(G.nodes[J.str(g.node)].f), str(scared.keys())])
		await t.get_tree().create_timer(0.6).timeout
	var G2 = _twG(); _p("tw done fear=%s scaredFloors=%s over=%s" % [str(G2.fear), str(scared.keys()), str(G2.get("over"))])
func tw_end(_t):
	J.mc(J.gp(J.G.window, "TW"), "end", ["gate"]); var G = _twG(); _p("tw over=%s" % JSON.stringify(G.over).substr(0, 300))
func tw_close(_t): J.mc(J.G.Tower, "close", []); _p("tower close on=%s" % str(J.gp(J.G.Tower, "on")))
