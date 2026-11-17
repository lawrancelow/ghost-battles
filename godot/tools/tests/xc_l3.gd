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
	var tr = _st_trans().CrUI
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
# 轉譯版 street 一次過設好幾個全局：全部還原，唔好蓋咗原生
static func _st_trans() -> Dictionary: return load_trans("street", ["Street", "CrUI", "DevFx", "__stDC"])
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
	var tr = _st_trans().DevFx
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

# ---- L3：street 第三段（資料、佈局、路網、名氣、佔領度）----
# 參考答案由網頁版 street.js 喺 node 計（tools/tests/ref/street_s3_ref.js → ref/street_s3.json）；轉譯版只係匯出咗嘅先比得
static func _cln(x):
	if x is Callable or x is Object: return null
	if x is Dictionary:
		var o = {}
		for k in x:
			var v = _cln(x[k])
			if v != null: o[k] = v
		return o
	if x is Array:
		var o = []
		for v in x: o.append(_cln(v))
		return o
	return x
static func _nr(a, b) -> bool:
	if (a is float or a is int) and (b is float or b is int):
		if float(a) == float(b): return true
		return absf(float(a) - float(b)) <= 1e-9 * maxf(1.0, absf(float(a)))
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size(): return false
		for k in a:
			if not b.has(k) or not _nr(a[k], b[k]): return false
		return true
	if a is Array and b is Array:
		if a.size() != b.size(): return false
		for i in a.size():
			if not _nr(a[i], b[i]): return false
		return true
	return a == b
func _eq(tag: String, a, b) -> void:
	var x = _norm(_cln(a)); var y = _norm(_cln(b))
	if _nr(x, y): ok += 1
	else:
		bad += 1
		if bad <= 25:
			var p = JSON.stringify(x); var q = JSON.stringify(y); var i = 0
			while i < mini(p.length(), q.length()) and p[i] == q[i]: i += 1
			print("[xcheck-diff] %s @%d\n web=…%s\n nat=…%s" % [tag, i, p.substr(maxi(0, i - 100), 220), q.substr(maxi(0, i - 100), 220)])
func street_s3(_t) -> void:
	mod = "street_s3"
	var N = load("res://native/street.gd"); N.load_data()
	var R = JSON.parse_string(FileAccess.get_file_as_string("res://tools/tests/ref/street_s3.json"))
	for c in R.hpMul: _eq("hpMul %s" % c[0], c[1], N.hpMul(c[0]))
	for c in R.coinOf: _eq("coinOf %s" % str(c), c[2], N.coinOf(c[0], c[1]))
	for c in R.hpP: _eq("hpP %s" % c[0], c[1], N.hpP(c[0]))
	for c in R.coP: _eq("coP %s" % c[0], c[1], N.coP(c[0]))
	var gp0 = J.G.get("GP")
	J.G["GP"] = {"grow": func(_t, a): return a[0].q, "mul": func(_t, a): return a[0].m, "pow": func(_t, a): return a[0].p}
	for c in R.boss:
		if c[0] == null: _eq("boss null", c.slice(1), [N.bossK(null), N.bossDmg(null), N.bossCD(null)]); continue
		var g = {"q": c[0], "m": c[0] * 1.7, "p": c[0] * 100}
		_eq("boss %s" % c[0], c.slice(1), [N.bossK(g), N.bossDmg(g), N.bossCD(g), N.staffOf(g, false), N.staffOf(g, true)])
	J.G["GP"] = gp0
	_eq("grid g1", R.grid.g1, N.gridLay("g1")); _eq("grid g2", R.grid.g2, N.gridLay("g2"))
	var lo = [[{"lay": "bus"}, null], [{"rooms": [{"lay": "cafe"}, {"lay": "g1"}]}, 1.0], [{"rooms": [{"lay": "cafe"}]}, 3.0], [{}, 0.0]]
	for i in lo.size(): _eq("layOf %d" % i, R.layOf[i], N.layOf(lo[i][0], lo[i][1]))
	var ty = J.gp(J.gp(N.gridLay("g1"), "grid"), "ty")
	_eq("grid.ty", [2.0, 1.0, 0.0], [J.cl(ty, null, [3.0, 1.0]), J.cl(ty, null, [0.0, 0.0]), J.cl(ty, null, [-1.0, 2.0])])
	for c in R.long:
		var L = N.longLay(null, c[1], [["A", "a"], ["B", "b"]] if c[1] == 2.0 else null, c[0])
		_eq("longLay %s %s" % [c[0], c[1]], c[2], L)
		# 路線：每步都喺 edges 入面、由 0E 去到 OUT
		var pts = N.route(L); var okr = pts.size() > 1 and pts[0].k == "0E" and pts[pts.size() - 1].k == "OUT"
		for i in range(1, pts.size()): okr = okr and L.edges[pts[i - 1].k].has(pts[i].k)
		if okr: ok += 1
		else: bad += 1; print("[xcheck-diff] route %s %s" % [c[0], c[1]])
	for c in R.proc:
		var sp = N.procSpec({"proc": 1.0, "dL": c[0], "dR": c[1]}); _eq("procSpec %s" % str(c.slice(0, 2)), c[2], sp)
		var blk = sp.S.duplicate()
		for o in sp.props: if o.t == "s": blk.append([o.x0, o.y0, o.x1, o.y1])
		_eq("floorGraph %s" % str(c.slice(0, 2)), c[3], N.floorGraph(sp.F, blk, c[0], c[1], null))
	for h in R.hot:
		var sd = {"lv": 1.0, "maxLv": 1.0, "hot": 0.0, "combo": 0.0}; var i = 0
		for e in h[1]:
			var m = N.addHot(sd, e[0], {"cap": h[0]})
			_eq("addHot cap%s #%d" % [h[0], i], [e[1] != "", e[2], e[3], e[4], e[5]], [m != "", sd.lv, sd.maxLv, sd.hot, sd.combo]); i += 1
	var sd2 = {"posts": [{"role": "trap"}], "maxLv": 3.0}
	for i in R.occ.size() - 1:
		var e = R.occ[i]; N.occPush(sd2, e[0]); _eq("occ #%d" % i, e.slice(1), [N.occOf(sd2), N.devRate(sd2), sd2.occH.size()])
	var eL = R.occ[R.occ.size() - 1]; _eq("devRate 冇崗", eL, [N.devRate({"occH": sd2.occH, "posts": []}), N.devRate({"occH": sd2.occH, "posts": [null, {}]})])
	_eq("bsk", R.bsk, [N.bsk("tianhua"), N.bsk("egui"), N.bsk("zzz")])
	# 匯出物件：原生 vs 轉譯版
	var tr = _st_trans().Street; var nat = J.G.Street
	for k in ["TUNE", "HOT", "SITES", "KIND"]: _eq("Street." + k, J.gp(tr, k), J.gp(nat, k))
	for k in ["RESERVED", "GATE", "DEV", "KIND", "CELL", "PX", "PPL"]: _eq("_n." + k, J.gp(J.gp(tr, "_n"), k), J.gp(J.gp(nat, "_n"), k))
	for lv in [0.0, 1.0, 9.5, 10.0, 23.0, 24.0, 37.0, 50.0, 64.0]: _eq("tr hpMul %s" % lv, J.mc(tr, "hpMul", [lv]), J.mc(nat, "hpMul", [lv]))
	for c in [[1.0, 24.0], [30.0, 24.0], [9.0, 5.0]]: _eq("tr coinOf", J.mc(tr, "coinOf", c), J.mc(nat, "coinOf", c))
	var S = J.G.S; var keep = J.gp(S, "stnPosts")
	J.sp(S, "stnPosts", null); var a1 = J.mc(tr, "st", []); var a1s = JSON.stringify(_norm(a1)).length()
	J.sp(S, "stnPosts", null); var b1 = J.mc(nat, "st", []); _eq("st 新", [a1.keys(), J.gp(a1, "sites")], [b1.keys(), J.gp(b1, "sites")])
	_eq("site", J.mc(tr, "site", ["bus", 2.0]), J.mc(nat, "site", ["bus", 2.0])); _eq("site keys", J.keys(J.gp(J.mc(tr, "st", []), "sites")), J.keys(J.gp(J.mc(nat, "st", []), "sites")))
	var occA = {"occH": [1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0], "posts": [{"role": "aura"}], "maxLv": 7.0}
	for f in ["occOf", "devRate"]: _eq("_n." + f, J.mc(J.gp(tr, "_n"), f, [occA]), J.mc(J.gp(nat, "_n"), f, [occA]))
	for gid in ["dev:trap", "dev:aura"]: _eq("_n.ghost " + gid, J.mc(J.gp(tr, "_n"), "ghost", [gid]), J.mc(J.gp(nat, "_n"), "ghost", [gid]))
	for g in J.iter(J.gp(S, "ghosts")).slice(0, 12):
		_eq("_n.gType " + J.str(J.gp(g, "k")), J.mc(J.gp(tr, "_n"), "gType", [g]), J.mc(J.gp(nat, "_n"), "gType", [g]))
		_eq("_n.ghost id", J.mc(J.gp(tr, "_n"), "ghost", [J.gp(g, "id")]), J.mc(J.gp(nat, "_n"), "ghost", [J.gp(g, "id")]))
	for k in ["tianhua", "afu", "xiaogui", "zzz"]: _eq("_n.CHAR_H_OK " + k, J.mc(J.gp(tr, "_n"), "CHAR_H_OK", [k]), J.mc(J.gp(nat, "_n"), "CHAR_H_OK", [k]))
	J.sp(S, "stnPosts", keep)
	_report()

# ---- L3：street 第四段 4a（Turf 幾何／路線／鏡頭／經濟）：轉譯版 Turf 方法 vs 原生方法，同一狀態、同一種子 ----
func _tf_pair(tr_turf, N, sid: String, unl: float) -> Array:
	var A = tr_turf.duplicate(); var B = tr_turf.duplicate()
	for X in [A, B]:
		var sd = {"lv": 7.0, "maxLv": 9.0, "unlocked": unl, "modCur": 0.97, "posts": [], "bosses": []}
		var L = N.longLay(null, unl, null, sid)
		for i in int(J.len(L.posts)):
			if i % 3 == 0: sd.posts.append({"role": ["trap", "scare", "slow", "aura", "throw", "puzzle"][i % 6], "lv": float(1 + i % 5), "staff": ("dev:aura" if i % 4 == 0 else null), "build": (1.0 if i == 6 else 0.0)})
			elif i % 3 == 1: sd.posts.append(null)
		X["sd"] = sd; X["lay"] = L; X["box"] = {"x": -100.0, "y": -300.0, "w": 1000.0, "h": 1500.0}; X["cam"] = {"z": 1.2, "x": 0.7, "y": 0.4, "tx": 1.3, "ty": 0.5, "user": 0.0, "focus": [1.1, 0.45]}
		X["SPECIAL"] = ["tianhua", "pontianak"]; X["modMax"] = 1.3; X["intro"] = null
	for k in N.TF_4A: B[k] = N.turf_methods(N.TF_4A)[k]
	B["dist"] = func(_this, a): return N.tf_dist(J.arg(a, 0), J.arg(a, 1))
	return [A, B]
func _tfeq(tag: String, A, B, f: String, args: Array, sd: int = 0) -> void:
	seed(sd + 11); var x = J.mc(A, f, args.duplicate(true)); seed(sd + 11); var y = J.mc(B, f, args.duplicate(true))
	_eq(tag + " " + f, x, y)
func street_t4a(_t) -> void:
	mod = "street_t4a"
	var N = load("res://native/street.gd"); N.load_data()
	var tr = _st_trans().Street; var trT = J.gp(tr, "Turf")
	for sid in ["office", "bus", "flat"]:
		for unl in [2.0, 3.0, 4.0]:
			var pr = _tf_pair(trT, N, sid, unl); var A = pr[0]; var B = pr[1]; var tg = "%s/%d" % [sid, unl]
			for f in ["lvCap", "incomeCap", "mod", "unit", "build", "zFit"]: _tfeq(tg, A, B, f, [])
			_tfeq(tg, A, B, "fixPosts", []); _eq(tg + " fixPosts sd", A.sd, B.sd)
			_tfeq(tg, A, B, "buildPath", []); _eq(tg + " buildPath", [A.segs, A.len, A.lay.path], [B.segs, B.len, B.lay.path])
			for t in [0.0, 0.3, 1.7, 3.9, 99.0]: _tfeq(tg + " t=%s" % t, A, B, "at", [t])
			for i in J.len(A.lay.posts):
				var sp = A.lay.posts[i]; var pp = A.sd.posts[i] if i < A.sd.posts.size() else null
				_tfeq(tg + " #%d" % i, A, B, "rect", [sp]); _tfeq(tg + " #%d" % i, A, B, "rdist", [[1.2, 0.5], sp]); _tfeq(tg + " #%d" % i, A, B, "rdist", [[J.num(sp.x) + 0.01, J.num(sp.y)], sp])
				if pp != null:
					for f in ["upCost", "staffMul", "devK"]: _tfeq(tg + " #%d" % i, A, B, f, [pp])
			for sw in [{"s": 2.0}, {"s": 2.0, "d": 1.0}, {"s": 1.0, "d": 1.0}]: var sp2 = {"x": 0.5, "y": 0.5}; sp2.merge(sw); _tfeq(tg, A, B, "rect", [sp2])
			for g in J.iter(J.G.S.ghosts).slice(0, 6):
				for sp in [{"h": 1.0}, {"h": 0.0}]:
					for lv in [1.0, 3.0]: _tfeq(tg + " " + J.str(g.k), A, B, "stats", [g, sp, lv])
			for z in [0.3, 1.0, 2.0]:
				A.cam.z = z; B.cam.z = z; A.cam.x = 3.7; B.cam.x = 3.7; _tfeq(tg + " z=%s" % z, A, B, "camClamp", []); _eq(tg + " cam", A.cam, B.cam)
				for xy in [[0.0, 0.0], [300.0, 700.0]]: _tfeq(tg, A, B, "toScreen", xy); _tfeq(tg, A, B, "toScene", xy)
			A.cam.user = -1e9; B.cam.user = -1e9
			for i in 5: _tfeq(tg, A, B, "camStep", []); _eq(tg + " camStep cam", A.cam, B.cam)
			_tfeq(tg, A, B, "focusOn", [0.4, 0.6]); _eq(tg + " focus", A.cam, B.cam)
			# 路人路線：同一種子 mkRoute，再沿路取位
			for r in 6:
				var wa = {"t": 0.0}; var wb = {"t": 0.0}
				seed(100 + r); J.mc(A, "mkRoute", [wa, null]); seed(100 + r); J.mc(B, "mkRoute", [wb, null]); _eq(tg + " mkRoute %d" % r, wa, wb)
				for t in [-0.1, 0.0, 0.25, 0.9, 2.5, 50.0]:
					wa.t = t; wb.t = t
					for f in ["wp", "wseg", "alive"]: _tfeq(tg + " r%d t%s" % [r, t], A, B, f, [wa])
					_tfeq(tg + " r%d t%s" % [r, t], A, B, "wp", [wa, 0.2])
				wa["gone"] = "run"; wb["gone"] = "run"; var rp = [[0.1, 0.5], [0.3, 0.55], [0.32, 0.9]]; wa["runPath"] = rp; wb["runPath"] = rp.duplicate(true); wa["spd"] = 0.05; wb["spd"] = 0.05
				for rt in [0.0, 0.6, 1.4, 3.0]: wa.runT = rt; wb.runT = rt; _tfeq(tg + " run %s" % rt, A, B, "wp", [wa]); _tfeq(tg + " run", A, B, "runPos", [wa])
			var pts = [{"p": [0.0, 0.5], "k": "0E"}, {"p": [0.2, 0.5], "k": "0a"}, {"p": [0.2, 0.5], "k": "0b"}, {"p": [0.4, 0.6], "k": "0~in", "hide": true}, {"p": [1.0, 0.6], "k": "OUT"}]
			var wa2 = {"t": 0.0, "j": 0.01}; var wb2 = {"t": 0.0, "j": 0.01}; J.mc(A, "mkRoute", [wa2, pts]); J.mc(B, "mkRoute", [wb2, pts]); _eq(tg + " mkRoute pts", wa2, wb2)
	_report()

# ---- L3：street 4b（路人生成／命中／嚇走／漏人）----
static func _wst(w):
	if not (w is Dictionary): return w
	var o = w.duplicate(); o.erase("mate")
	if w.get("sq") is Dictionary: o.erase("sq"); o["sq_"] = [w.sq.kind, w.sq.scared, w.sq.leaked, w.sq.done]
	o.erase("sqRole")
	if w.get("mate") is Dictionary and w.mate.get("sq") != null: pass
	if w.get("mate") is Dictionary: var m = w.mate.duplicate(); m.erase("mate"); o["mate_"] = m
	return o
static func _bst(bs) -> Array:
	var o = []
	for b in J.iter(bs):
		var c = b.duplicate(); c["g"] = J.gp(b.g, "id"); c["tg"] = J.gp(b.get("tg"), "n"); c.erase("hitSet")
		if b.get("sx") is Dictionary:
			var sx = b.sx.duplicate(); var ls = []
			for w in J.iter(sx.get("list", [])): ls.append(J.gp(w, "n"))
			sx["list"] = ls; c["sx"] = sx
		o.append(c)
	return o
static func _qst(q):
	var o = q.duplicate(); var ls = []
	for w in J.iter(q.get("list", [])): ls.append(_wst(w))
	o["list"] = ls; o.erase("sq"); return o
static func _tstate(X) -> Dictionary:
	var df = []
	for e in J.iter(X.get("dfx", [])): df.append([e.k, e.t, e.dur, e.seed, J.gp(e.w, "n")])
	var ws = []
	for w in J.iter(X.walkers): ws.append(_wst(w))
	var trs = []
	for r in J.iter(X.get("traces", [])): var o = r.duplicate(); o.erase("seen"); trs.append(o)
	return {"sd": X.sd, "fx": X.fx, "parts": X.parts, "dfx": df, "ws": ws, "rate": X.get("rateAcc"), "traces": trs, "caps": X.get("caps"), "tint": X.get("tint")}
func street_t4b(_t) -> void:
	mod = "street_t4b"
	var N = load("res://native/street.gd"); N.load_data()
	var tr = _st_trans().Street; var trT = J.gp(tr, "Turf")
	for sid in ["office", "bus", "flat"]:
		var pr = _tf_pair(trT, N, sid, 3.0); var A = pr[0]; var B = pr[1]; var tg = sid
		for k in N.TF_4B: B[k] = N.turf_methods(N.TF_4B)[k]
		var def = null
		for d in N.D.SITES:
			if J.str(d.id) == sid: def = d
		for X in [A, B]:
			X["def"] = def; X["walkers"] = []; X["fx"] = []; X["parts"] = []; X["dfx"] = []; X["rateAcc"] = 0.0; X.sd["wal"] = 600.0; X.sd["scared"] = 0.0; X.sd["leaked"] = 0.0; X.sd["coins"] = 0.0; X.sd["hot"] = 0.0; X.sd["jar"] = 38.0
			J.mc(X, "buildPath", [])
		trT["sd"] = A.sd
		var cpl = 0
		for r in 40:
			seed(500 + r); var wa = J.mc(A, "newWalker", [null]); seed(500 + r); var wb = J.mc(B, "newWalker", [null])
			_eq(tg + " newWalker %d" % r, _wst(wa), _wst(wb))
			if J.str(wa.get("tr")) == "couple": cpl += 1
			if r < 12: wa.t = 0.05 + r * 0.04; wb.t = wa.t; A.walkers.append(wa); B.walkers.append(wb)
		for e in N.D.ELITE.slice(0, 4):
			seed(77); var wa = J.mc(A, "newWalker", [e.id]); seed(77); var wb = J.mc(B, "newWalker", [e.id]); _eq(tg + " elite " + J.str(e.id), _wst(wa), _wst(wb))
			wa.t = 0.3; wb.t = 0.3; A.walkers.append(wa); B.walkers.append(wb)
		var OS = [{}, {"aura": true}, {"force": true}, {"src": "trap", "fright": true}, {"src": "scare", "fear": true, "fright": 1.5}, {"src": "aura", "aura": true}, {"src": "throw"}]
		for i in A.walkers.size():
			for j in OS.size():
				var dm = 9.0 + i * 7 + j * 31
				trT["sd"] = A.sd; seed(900 + i * 10 + j); J.mc(A, "hit", [A.walkers[i], dm, OS[j].duplicate()])
				seed(900 + i * 10 + j); J.mc(B, "hit", [B.walkers[i], dm, OS[j].duplicate()])
				_eq(tg + " hit w%d o%d" % [i, j], _tstate(A), _tstate(B))
		for i in 3:
			trT["sd"] = A.sd; J.mc(A, "leak", [A.walkers[i]]); J.mc(B, "leak", [B.walkers[i]]); _eq(tg + " leak %d" % i, _tstate(A), _tstate(B))
		for i in 3: J.mc(A, "hitFx", [A.walkers[0], "slow"]); J.mc(B, "hitFx", [B.walkers[0], "slow"])
		_eq(tg + " hitFx dup", _tstate(A), _tstate(B))
		print("[xcheck-info] t4b %s couples=%d walkers=%d" % [sid, cpl, A.walkers.size()])
	_report()

# ---- L3：street 4c（特殊路人組）----
static func _sqst(sq) -> Dictionary:
	var ms = []
	for w in J.iter(sq.mem): var o = _wst(w); o.erase("sq"); o.erase("sqRole"); ms.append(o)
	var o2 = sq.duplicate(); o2.erase("mem"); o2["mem_"] = ms; return o2
func street_t4c(_t) -> void:
	mod = "street_t4c"
	var N = load("res://native/street.gd"); N.load_data()
	var tr = _st_trans().Street; var trT = J.gp(tr, "Turf")
	for sid in ["office", "bus", "flat"]:
		var pr = _tf_pair(trT, N, sid, 3.0); var A = pr[0]; var B = pr[1]; var tg = sid
		for grp in [N.TF_4B, N.TF_4C]:
			for k in grp: B[k] = N.turf_methods(grp)[k]
		var def = null
		for d in N.D.SITES:
			if J.str(d.id) == sid: def = d
		for X in [A, B]:
			X["def"] = def; X["walkers"] = []; X["fx"] = []; X["parts"] = []; X["dfx"] = []; X["rateAcc"] = 0.0; X.sd["wal"] = 600.0; X.sd["coins"] = 0.0; X.sd["hot"] = 0.0; X.sd["lv"] = 12.0
			X["sqPlan"] = null; X["waveNo"] = 0.0; X["sqCD"] = 1.0
			J.mc(X, "buildPath", [])
			for p in X.sd.posts:
				if p is Dictionary: p["cd"] = 99.0
		trT["sd"] = A.sd
		for r in 8:
			seed(300 + r); J.mc(A, "sqWaveDone", []); seed(300 + r); J.mc(B, "sqWaveDone", [])
			_eq(tg + " sqWaveDone %d" % r, [A.waveNo, A.sqPlan, A.sqCD], [B.waveNo, B.sqPlan, B.sqCD])
			if r == 4: A.sqPlan = null; B.sqPlan = null; A.sqCD = 0.0; B.sqCD = 0.0
		for kind in N.D.SQUAD:
			seed(41); var qa = J.mc(A, "sqMake", [kind]); seed(41); var qb = J.mc(B, "sqMake", [kind])
			_eq(tg + " sqMake " + kind, _sqst(qa), _sqst(qb))
			A.walkers = qa.mem.duplicate(); B.walkers = qb.mem.duplicate()
			for i in qa.mem.size(): qa.mem[i].t = 0.02 + i * 0.03; qb.mem[i].t = qa.mem[i].t; qa.mem[i].hp = qa.mem[i].max * 0.5; qb.mem[i].hp = qa.mem[i].hp
			for st in 40:
				for i in qa.mem.size():
					seed(st * 10 + i); var ra = J.mc(A, "sqWalk", [qa.mem[i], 0.1]); seed(st * 10 + i); var rb = J.mc(B, "sqWalk", [qb.mem[i], 0.1])
					_eq(tg + " sqWalk %s s%d m%d ret" % [kind, st, i], ra, rb)
					qa.mem[i].t += 0.01; qb.mem[i].t += 0.01
				if st % 8 == 0: _eq(tg + " sqWalk %s s%d" % [kind, st], [_sqst(qa), A.fx], [_sqst(qb), B.fx])
			for i in qa.mem.size():
				var how = "run" if i % 2 == 0 else "out"
				if kind.length() % 2 == 0: how = "out" if i > 0 else "run"
				trT["sd"] = A.sd; seed(9 + i); J.mc(A, "sqMember", [qa.mem[i], how]); seed(9 + i); J.mc(B, "sqMember", [qb.mem[i], how])
			_eq(tg + " sqEnd " + kind, [_sqst(qa), A.sd, A.fx, A.get("slowmo"), A.get("flash")], [_sqst(qb), B.sd, B.fx, B.get("slowmo"), B.get("flash")])
	_report()

# ---- L3：street 4d（tick 每格邏輯，連轉譯版 devTick／queueTick／bossTick 一齊行）----
func street_t4d(_t) -> void: _t4tick("street_t4d", ["TF_4B", "TF_4C", "TF_4D"])
func street_t4e(_t) -> void: _t4tick("street_t4e", ["TF_4B", "TF_4C", "TF_4D", "TF_4E"])
func street_t4f(_t) -> void: _t4tick("street_t4f", ["TF_4B", "TF_4C", "TF_4D", "TF_4E", "TF_4F"])
func street_t4g(_t) -> void: _t4tick("street_t4g", ["TF_4B", "TF_4C", "TF_4D", "TF_4E", "TF_4F", "TF_4G"])
func _t4tick(mn: String, gn: Array) -> void:
	mod = mn
	var N = load("res://native/street.gd"); N.load_data()
	var tr = _st_trans().Street; var trT = J.gp(tr, "Turf")
	for sid in ["office", "bus", "flat"]:
		var pr = _tf_pair(trT, N, sid, 3.0); var A = pr[0]; var B = pr[1]; var tg = sid
		for gk in gn:
			var grp = {"TF_4B": N.TF_4B, "TF_4C": N.TF_4C, "TF_4D": N.TF_4D, "TF_4E": N.TF_4E, "TF_4F": N.TF_4F, "TF_4G": N.TF_4G}[gk]
			for k in grp: B[k] = N.turf_methods(grp)[k]
		var def = null
		for d in N.D.SITES:
			if J.str(d.id) == sid: def = d
		for X in [A, B]:
			X["def"] = def; X["walkers"] = []; X["fx"] = []; X["parts"] = []; X["dfx"] = []; X["shots"] = []; X["eliteT"] = 2.0; X["rateAcc"] = 0.0; X["rateT"] = 55.0; X["bosses"] = []
			X.sd["wal"] = 600.0; X.sd["coins"] = 0.0; X.sd["hot"] = 0.0; X.sd["scared"] = 0.0; X.sd["leaked"] = 0.0; X.sd["panic"] = 3.0
			X["q"] = {"st": "gap", "t": 3.0, "n": 0.0, "made": 0.0, "list": []}; X["sqPlan"] = null; X["waveNo"] = 0.0; X["sqCD"] = 1.0
			var bids = []
			for g in J.iter(J.G.S.ghosts).slice(0, 4): bids.append(g.id)
			X.sd["bosses"] = bids; X.sd["bEn"] = {}
			J.mc(X, "buildPath", [])
			var i = 0
			for p in X.sd.posts:
				if p is Dictionary: p["cd"] = 0.0; p["auraOn"] = (2.0 if i % 2 else 0.0); p["fx"] = {"t": 0.5}
				i += 1
		trT["sd"] = A.sd
		for r in 10:
			seed(700 + r); var wa = J.mc(A, "newWalker", [null]); seed(700 + r); var wb = J.mc(B, "newWalker", [null])
			wa.t = r * 0.05; wb.t = wa.t; A.walkers.append(wa); B.walkers.append(wb)
		for X in [A, B]:
			X.shots.append({"t": 0.0, "dur": 0.4, "to": [0.6, 0.5], "eff": 0.3, "atk": 25.0}); X["traces"] = []; X["caps"] = []
			for tk in [["hair", 0.4], ["ice", 0.45], ["coins", 0.9], ["notes", 0.95], ["shadow", 1.3], ["cloth", 1.6], ["ring", 1.9], ["soup", 2.2], ["debt", 2.3], ["claw", 2.6]]:
				J.mc(X, "addTrace", [tk[0], tk[1], 0.5, 400.0, 30.0, {"by": "t"}])
		for st in 240:
			trT["sd"] = A.sd; seed(5000 + st); J.mc(A, "tick", [0.05]); seed(5000 + st); J.mc(B, "tick", [0.05])
			if st % 10 == 9 or st < 5: _eq(tg + " tick %d" % st, [_tstate(A), A.shots, _qst(A.q), A.shake, _bst(A.bosses), A.get("bg")], [_tstate(B), B.shots, _qst(B.q), B.shake, _bst(B.bosses), B.get("bg")])
		print("[xcheck-info] %s %s walkers=%d scared=%s leaked=%s" % [mn, sid, A.walkers.size(), A.sd.scared, A.sd.leaked])
	_report()
