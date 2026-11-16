# L3 原生對照測試（樓裡有鬼主體）：["gdrun","res://tools/tests/xc_l3.gd","tower"]
# 要用 GB_NAT_EXTRA=tower,tower_lift,tower_unit 開機（或已加入 ACTIVE.txt）：原生 Tower 已經行緊，
# 再載一份轉譯版 tower（jsgen/tower.gd）攞佢嘅 window.TW／TWX，兩份同一種子、同一劇本各行一次，逐段比狀態。
extends "res://tools/tests/native_xcheck.gd"

const WPROPS := ["TW", "TWX", "LIFT", "UNIT", "PPLFX", "__twCull", "__twPD", "__twPM", "__twPU", "__twUPD", "__twUPM", "__twUPU", "LiftSys", "UnitSys"]

func _load_tw_trans() -> Dictionary:
	var w = J.G.window; var keepW = {}; var keepG = {}
	for k in WPROPS: keepW[k] = J.gp(w, k)
	for k in ["Tower"]: keepG[k] = J.G.get(k)
	var m = (load("res://jsgen/tower.gd") as GDScript).new(); _keep_alive.append(m); m.run(null)
	var out = {"TW": J.gp(w, "TW"), "TWX": J.gp(w, "TWX"), "Tower": J.G.get("Tower")}
	for k in WPROPS: J.sp(w, k, keepW[k])
	for k in keepG: J.G[k] = keepG[k]
	return out

func _cx(A): return null if A == null else [J.str(J.gp(A, "k")), J.str(J.gp(A, "t"))]
func _sdiff(a, b) -> String:
	var x = JSON.stringify(a); var y = JSON.stringify(b); var i = 0
	while i < mini(x.length(), y.length()) and x[i] == y[i]: i += 1
	return "@%d\n tr =…%s\n nat=…%s" % [i, x.substr(maxi(0, i - 120), 260), y.substr(maxi(0, i - 120), 260)]

func _tw_snap(TW, X, f: int) -> Dictionary:
	var G = J.cl(J.gp(X, "G"), null, [])
	var gh = []
	for g in G.gh: gh.append([g.x, g.y, g.node, g.get("to"), g.get("energy"), g.get("home"), g.get("out"), g.get("inv"), g.get("caught"), g.get("stun"), g.get("still")])
	var gu = []
	for h in G.guards: gu.append([h.kind, h.state, h.x, h.node])
	var ov = G.get("over")
	var o = {"f": f, "hash": J.str(J.cl(X.hash, null, [])), "t": G.t, "fear": G.fear, "alert": G.alert, "phase": G.phase, "wave": G.get("wave"), "bag": G.bag, "dolls": G.dolls, "story": G.story,
		"keys": G.keys, "carry": G.get("carry") != null, "active": G.active, "gh": gh, "gu": gu, "choice": (G.choice as Array).size() if G.get("choice") is Array else 0,
		"toast": G.get("toast"), "gate": G.get("gate"), "tao": G.get("tao") != null, "ult": G.get("ult") != null, "over": ov, "ctx": _cx(J.mc(TW, "ctx", [])), "r": randf()}
	return JSON.parse_string(JSON.stringify(o))

func _tw_run(TW, X, sd: float, lv: String, S0) -> Array:
	J.G["S"] = S0.duplicate(true)
	seed(int(sd) * 3 + 11)
	J.mc(TW, "ng", [sd, lv])
	var out = []; var dt = 0.05
	for f in 3800:
		var G = J.cl(J.gp(X, "G"), null, [])
		if J.t(G.get("over")): out.append({"endf": f}); break
		var ai = int(J.num(G.active)); var g = G.gh[ai]
		if G.get("choice") is Array and f % 7 == 0: J.mc(TW, "choose", [float(f % 3)])
		if f % 45 == 5:
			# 揀一戶仲喺屋企嘅住戶行過去
			var hs = []
			for r in G.res: if J.str(r.state) == "home": hs.append(r)
			if hs.size(): var r = hs[(f / 45) % hs.size()]; out.append({"f": f, "go": J.mc(TW, "goto", [float(ai), r.unit.id])})
		if f % 50 == 30: J.mc(TW, "press", ["scare"])
		if f % 131 == 60: J.mc(TW, "press", ["inv"])
		if f % 77 == 40: out.append({"f": f, "ctx": _cx(J.mc(TW, "ctx", []))}); J.mc(TW, "act", [])
		if f % 210 == 100: J.mc(TW, "press", ["gh" + str((f / 210) % 3)])
		if f % 10 == 3 and J.num(g.energy) >= 100 and not J.t(g.home): out.append({"f": f, "ult": J.mc(TW, "ult", [float(ai)])})
		if f % 97 == 50: J.mc(TW, "tap", [float(60 + (f * 37) % 270), float(140 + (f * 53) % 420)])
		if f % 160 == 80: J.mc(TW, "press", ["zin" if (f / 160) % 2 else "zout"])
		if f == 1200: J.mc(TW, "press", ["story"])
		if f == 1210: J.mc(TW, "press", ["closeStory"])
		if f == 2600:
			# 去陰門（天台或地庫）
			var pid = ""
			for k in G.nodes: if J.str(G.nodes[k].kind) == "portal": pid = k
			out.append({"f": f, "goP": J.mc(TW, "goto", [float(ai), pid])})
		if f > 2600 and f % 20 == 0: J.mc(TW, "gate", [])
		if f == 3500: J.mc(TW, "doll", [])
		J.cl(X.step, null, [1.0, dt])
		if f % 20 == 0: out.append(_tw_snap(TW, X, f))
	var G2 = J.cl(J.gp(X, "G"), null, [])
	if not J.t(G2.get("over")): J.mc(TW, "end", ["gate"])
	out.append(_tw_snap(TW, X, -1))
	return out

func tower(_t) -> void:
	mod = "tower"
	var nat = {"TW": J.gp(J.G.window, "TW"), "TWX": J.gp(J.G.window, "TWX")}
	if not (J.G.Tower is Dictionary and J.G.Tower.has("_self")): print("[xcheck] tower：原生 Tower 未啟用（要 GB_NAT_EXTRA=tower,...）"); bad += 1; _report(); return
	var tr = _load_tw_trans()
	var S0 = J.G.S.duplicate(true)
	var cases = [[12345.0, "flat"], [777.0, "flat"], [2024.0, "flat"], [99.0, "shop"], [4242.0, "shop"]]
	for cs in cases:
		var a = _tw_run(tr.TW, tr.TWX, cs[0], cs[1], S0); var b = _tw_run(nat.TW, nat.TWX, cs[0], cs[1], S0)
		var nb = 0
		for i in mini(a.size(), b.size()):
			if _near(_norm(a[i]), _norm(b[i])): ok += 1
			else:
				bad += 1; nb += 1
				if nb <= 4:
					for k in a[i]:
						if not _near(_norm(a[i][k]), _norm(b[i].get(k))): print("[xcheck-diff] tower %s seed%s #%d %s %s" % [cs[1], cs[0], i, k, _sdiff(_norm(a[i][k]), _norm(b[i].get(k)))])
		if a.size() != b.size(): bad += 1; print("[xcheck-diff] tower size ", a.size(), " ", b.size())
		var L = a[-1]
		print("[xcheck-info] tower %s seed%s snaps=%d fear=%s alert=%s phase=%s story=%s over=%s" % [cs[1], cs[0], a.size(), L.fear, L.alert, L.phase, str(L.story), JSON.stringify(L.over).substr(0, 160)])
	J.G["S"] = S0
	_report()
