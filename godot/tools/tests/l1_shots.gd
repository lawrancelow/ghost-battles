# L1 實玩截圖：村入面阿福行路／砍樹／割禾／企定（GB_TEST 用 gdrun 逐個叫，之後 wait + shot）
extends RefCounted

static func _V(): return J.G.get("Village")
static func _S(): return G.S
static func _focus(x: float, y: float) -> void:
	var V = _V(); if V != null: J.mc(V, "focus", [x, y])
static func _hero() -> Array:
	var h = J.gp(_V(), "hero"); return [J.num(J.gp(h, "x")), J.num(J.gp(h, "y"))]

func walk(_t) -> void:
	var p = _hero(); var tx = 80.0 if p[0] > 200 else 320.0
	J.mc(_V(), "walkTo", [tx, p[1] + 10, null]); _focus(p[0], p[1])
	print("[l1shot] walk from ", p, " to ", tx)

func tree(_t) -> void:
	var S = _S(); var TP = J.G.get("TREE_POS")
	if S.trees is Array and S.trees.size(): S.trees[0] = maxf(3.0, J.num(S.trees[0]))
	var tp = TP[0]; J.mc(_V(), "walkTo", [J.num(tp[0]) + 20, J.num(tp[1]) + 4, {"kind": "tree", "i": 0.0}]); _focus(J.num(tp[0]), J.num(tp[1]))
	print("[l1shot] tree ", tp)

func paddy(_t) -> void:
	var S = _S(); var PP = J.G.get("PADDY_POS")
	if S.paddy is Array and S.paddy.size(): S.paddy[0] = true
	var pp = PP[0]; J.mc(_V(), "walkTo", [J.num(pp[0]) - 30, J.num(pp[1]) + 4, {"kind": "paddy", "i": 0.0}]); _focus(J.num(pp[0]), J.num(pp[1]))
	print("[l1shot] paddy ", pp)

func stand(_t) -> void:
	var p = _hero(); _focus(p[0], p[1])
	var h = J.gp(_V(), "hero"); print("[l1shot] stand act=", J.gp(h, "act"), " walking=", J.gp(h, "walking"), " daily=", J.mc(J.G.HeroDaily, "opts", [_V()]))

func state(_t) -> void:
	var h = J.gp(_V(), "hero"); print("[l1shot] cam=", J.gp(_V(), "camY"), " sc=", J.gp(_V(), "scale"), " state act=", J.gp(h, "act"), " walking=", J.gp(h, "walking"), " xy=", _hero(), " daily=", J.mc(J.G.HeroDaily, "opts", [_V()]), " nat=", load("res://native/daily_hero.gd").Q.get("cur"))

func wcheck(_t) -> void:
	var s = load("res://native/daily_work.gd")
	print("[l1shot] daily_work load=", s != null and s.can_instantiate())

func wstate(_t) -> void:
	var W = J.G.get("WORK"); var ST = J.gp(W, "STATE"); var o = []
	if ST is Dictionary:
		for k in ST: o.append("%s:%s/%s" % [k, ST[k].k, ST[k].act])
	print("[l1shot] work native=", load("res://native/daily_work.gd").STATE == ST, " n=", o.size(), " ", o)

func assign(_t) -> void:
	var posts = ["wood", "rice", "plank", "bun", "store", "boss", "camp", "wood", "rice", "plank", "bun", "camp", "rice", "wood"]
	var i = 0; var seen = {}; var o = []
	for g in G.S.ghosts:
		if J.str(g.k) == "afu" or seen.has(J.str(g.k)): continue
		seen[J.str(g.k)] = true
		if i >= posts.size(): break
		g["post"] = posts[i]; o.append("%s→%s" % [g.k, posts[i]]); i += 1
	print("[l1shot] assign ", o)
