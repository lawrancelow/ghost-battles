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

# ---- L3：陽間街 street 第一段（CrUI）：同一組參數，原生 vs 轉譯各畫入 Recorder，逐條指令比 ----
func street_crui(_t) -> void:
	mod = "street_crui"
	var X5 = load("res://tools/tests/xc_l5.gd")
	var tr = load_trans("street", ["CrUI"]).CrUI
	var nat = load("res://native/street.gd").mk_crui()
	var cases = []
	for o in [null, {}, {"col": "red"}, {"col": "rust", "fill": "rgba(70,36,16,0.95)", "U": 1.5, "seed": 11.0}, {"col": "12,34,56", "seed": 0.0, "U": 0.7}]:
		for r in [[10.0, 20.0, 120.0, 40.0], [0.0, 0.0, 46.0, 9.0], [33.3, 7.7, 300.0, 180.0]]:
			cases.append(["panel", [r[0], r[1], r[2], r[3], o]])
	for k in [-0.2, 0.0, 0.35, 1.0, 1.7]:
		for cc in [["#6d5690", "#c06a2c", 1.0], ["#ff0000", null, null], ["#123456", "", 2.0]]:
			cases.append(["bar", [12.0, 30.0, 200.0, 8.0, k, cc[0], cc[1], cc[2]]])
	for o in [null, {"font": "900 13px sans-serif", "align": "center", "col": "#f3d58a"}, {"lw": 0.0}, {"lw": 5.0, "align": "right"}]:
		for s in ["測試 12/40", 42.0]: cases.append(["text", [s, 50.0, 60.0, o]])
	for r in [[5.0, 5.0, 80.0, 30.0, 3.0, 2.2], [0.0, 0.0, 10.0, 10.0, 0.0, 0.0]]: cases.append(["rough", r])
	for cs in cases:
		var fn = cs[0]; var args = cs[1]
		var a = X5.rec_sig(func(c): return J.mc(tr, fn, [c] + args.duplicate(true)))
		var b = X5.rec_sig(func(c): return J.mc(nat, fn, [c] + args.duplicate(true)))
		if a == b: ok += 1
		else:
			bad += 1
			if bad <= 6:
				var i = 0
				while i < mini(a.size(), b.size()) and a[i] == b[i]: i += 1
				print("[xcheck-diff] CrUI.%s(%s) n=%d/%d @%d\n tr =%s\n nat=%s" % [fn, JSON.stringify(args).substr(0, 100), a.size(), b.size(), i, a[i].substr(0, 200) if i < a.size() else "-", b[i].substr(0, 200) if i < b.size() else "-"])
	if JSON.stringify(J.gp(tr, "COL")) == JSON.stringify(J.gp(nat, "COL")): ok += 1
	else: bad += 1; print("[xcheck-diff] CrUI.COL")
	_report()

# Recorder 指令簽名：物件（漸變等）用 class+instance id，兩邊一定唔同 → 拎走 id 只比類型
static var _rid: RegEx = null
static func _sig(X5, fn: Callable) -> Array:
	if _rid == null: _rid = RegEx.new(); _rid.compile("([A-Za-z]+)-?[0-9]{5,}")
	var out = []
	for s in X5.rec_sig(fn): out.append(_rid.sub(s, "$1", true))
	return out

# ---- L3：street 第二段（DevFx）：每個類型×大細×時間×現身進度，原生 vs 轉譯各畫入 Recorder 比 ----
# 轉譯版 J.G.Math 係空 {}：street.js 嘅 const sn = Math.sin 等別名變 null（網頁版正常）。對照時補返，令轉譯版等同網頁版
static func math_fix() -> Dictionary:
	var keep = J.G.get("Math")
	J.G["Math"] = {"sin": func(_t, a): return sin(J.num(a[0])), "cos": func(_t, a): return cos(J.num(a[0])), "abs": func(_t, a): return absf(J.num(a[0])),
		"sqrt": func(_t, a): return sqrt(J.num(a[0])), "floor": func(_t, a): return floorf(J.num(a[0])), "round": func(_t, a): return floorf(J.num(a[0]) + 0.5),
		"min": func(_t, a): var m = INF; for v in a: m = minf(m, J.num(v)); return m, "max": func(_t, a): var m = -INF; for v in a: m = maxf(m, J.num(v)); return m,
		"atan2": func(_t, a): return atan2(J.num(a[0]), J.num(a[1])), "hypot": func(_t, a): return Vector2(J.num(a[0]), J.num(a[1])).length(),
		"random": func(_t, _a): return randf(), "pow": func(_t, a): return pow(J.num(a[0]), J.num(a[1])), "PI": PI}
	return {"keep": keep}

func street_devfx(_t) -> void:
	mod = "street_devfx"
	var mk = math_fix()
	var X5 = load("res://tools/tests/xc_l5.gd")
	var tr = load_trans("street", ["DevFx"]).DevFx
	var nat = load("res://native/street.gd").mk_devfx()
	for k in ["COL", "HEX", "KEY", "DUR"]:
		if JSON.stringify(J.gp(tr, k)) == JSON.stringify(J.gp(nat, k)): ok += 1
		else: bad += 1; print("[xcheck-diff] DevFx.", k)
	var SPR = J.G.SPR; var nb = 0
	var roles = ["trap", "puzzle", "slow", "scare", "aura", "throw", "nope"]
	for role in roles:
		for sz in [1.0, 2.0]:
			var im = J.gp(SPR, "dv_%s_%d" % [role, int(sz)])
			if im == null: im = J.gp(SPR, "dv_trap_1")
			for t in [0.0, 1.37, 5.5, 12.91, 33.3]:
				for E in [null, {"p": null, "k": null, "sc": 1.0}, {"p": 0.05, "k": null, "sc": 1.2}, {"p": 0.2, "k": null, "sc": 1.0}, {"p": 0.4, "k": null, "sc": 0.8}, {"p": 0.55, "k": null, "sc": 1.0}, {"p": 0.8, "k": null, "sc": 1.0}, {"p": 0.97, "k": null, "sc": 1.0}, {"p": 0.5, "k": "afu", "sc": 1.0}]:
					var args = [im, role, sz, -40.0, -90.0, 80.0, 90.0, t, 3.0, E]
					seed(int(t * 100) + 7); var a = _sig(X5, func(c): return J.mc(tr, "draw", [c] + args))
					seed(int(t * 100) + 7); var b = _sig(X5, func(c): return J.mc(nat, "draw", [c] + args))
					if a == b: ok += 1
					else:
						bad += 1; nb += 1
						if nb <= 8:
							var i = 0
							while i < mini(a.size(), b.size()) and a[i] == b[i]: i += 1
							var sa = a[i] if i < a.size() else "-"; var sb = b[i] if i < b.size() else "-"; var q = 0
							while q < mini(sa.length(), sb.length()) and sa[q] == sb[q]: q += 1
							print("[xcheck-diff] DevFx.draw %s sz%d t=%s E=%s n=%d/%d @%d ch%d\n tr =%s\n nat=%s" % [role, sz, t, JSON.stringify(E), a.size(), b.size(), i, q, sa.substr(maxi(0, q - 60), 200), sb.substr(maxi(0, q - 60), 200)])
			for t in [0.0, 2.2, 7.7]:
				for trig in [0.0, 0.5, 1.0]:
					var args2 = [role, 10.0, 20.0, 60.0, 50.0, t, 2.0, trig, 1.5]
					var a2 = _sig(X5, func(c): return J.mc(tr, "frame", [c] + args2)); var b2 = _sig(X5, func(c): return J.mc(nat, "frame", [c] + args2))
					if a2 == b2: ok += 1
					else: bad += 1; print("[xcheck-diff] DevFx.frame ", role, " ", t, " ", trig)
	# emerge／trigOf：同一串 fx 變化
	var pa = {"fx": null}; var pb = {"fx": null}
	for i in 40:
		var t = i * 0.13
		if i % 9 == 2: pa["fx"] = "f%d" % i; pb["fx"] = "f%d" % i
		if i == 20: pa["win"] = true; pb["win"] = true
		if i == 30: pa["anim"] = 1.0; pb["anim"] = 1.0
		var x1 = [J.mc(tr, "emerge", [pa, t]), J.mc(tr, "trigOf", [pa, t + 0.01])]; var x2 = [J.mc(nat, "emerge", [pb, t]), J.mc(nat, "trigOf", [pb, t + 0.01])]
		if _near(_norm(x1), _norm(x2)): ok += 1
		else: bad += 1; print("[xcheck-diff] emerge/trigOf i=%d tr=%s nat=%s" % [i, str(x1), str(x2)])
	J.G["Math"] = mk.keep
	for o in [{"alpha": 0.7, "t": 1.0}, {"rot": 0.3, "flip": true, "reach": 0.6, "t": 4.0}, {}]:
		for f in ["shade"]:
			var a3 = _sig(X5, func(c): return J.mc(tr, f, [c, 5.0, 100.0, 80.0, o])); var b3 = _sig(X5, func(c): return J.mc(nat, f, [c, 5.0, 100.0, 80.0, o]))
			if a3 == b3: ok += 1
			else:
				bad += 1; var i3 = 0
				while a3[i3] == b3[i3]: i3 += 1
				var q3 = 0
				while a3[i3][q3] == b3[i3][q3]: q3 += 1
				print("[xcheck-diff] DevFx.shade %s @%d ch%d\n tr =%s\n nat=%s" % [o, i3, q3, a3[i3].substr(maxi(0, q3 - 60), 200), b3[i3].substr(maxi(0, q3 - 60), 200)])
	_report()
