# L4（嚇人與陽間線）原生對照測試：["gdrun","res://tools/tests/xc_l4.gd","l4_scops"] 等
extends "res://tools/tests/native_xcheck.gd"

# ---- L4：資料模塊指紋（GB_NONAT=1 同原生各跑一次，比 /tmp/L4/fp_*.json）----
func l4_fp(_t) -> void:
	var G = J.G; var fp = {}
	fp["STN_FG"] = G.STN_FG; fp["STN_FG_W"] = G.STN_FG_W; fp["STN_FG_H"] = G.STN_FG_H
	fp["STN_PROPS"] = G.STN_PROPS; fp["STN_AB_SRC"] = G.STN_AB_SRC; fp["STN_AB_NOLEG"] = G.STN_AB_NOLEG; fp["PT_IMG_SRC"] = G.PT_IMG_SRC
	var keys = J.gp(G.PG_GHOSTS, "keys"); fp["PG_keys"] = keys
	for k in keys + ["n30_hantugalah"]:
		fp["GH_" + k] = G.GHOSTS.get(k); fp["SK_" + k] = G.SKILLS.get(k); fp["EN_" + k] = G.ENEMY_T.get(k)
		fp["CH_" + k] = J.gp(J.gp(G.ART, "CHAR_H"), k); fp["SPR_" + k] = J.t(J.gp(G.SPR, k))
		var L = G.get("L"); var g = G.GHOSTS.get(k)
		if g != null: for f in ["name", "title", "lore", "say", "trait"]: fp["L_%s_%s" % [k, f]] = J.str(J.cl(L, null, [g.get(f)]))
	for k in G.STN_AB_SRC: fp["SPRAB_" + k] = J.t(J.gp(G.SPR, k)); fp["SRCAB_" + k] = J.gp(G.get("SPR_SRC"), k)
	# STN_FG 函數
	var sites = G.STN_FG.keys(); var out = []
	for s in sites:
		for i in range(-1, 6):
			out.append(J.cl(G.STN_FG_list, null, [s, float(i)]).size())
			out.append(J.cl(G.STN_FG_list, null, [s, float(i), 700.0]).size())
	fp["fg_list"] = out
	var it = G.STN_FG[sites[0]][0][0]
	var im1 = J.cl(G.STN_FG_img, null, [it]); var im2 = J.cl(G.STN_FG_img, null, [it])
	fp["fg_img_same"] = im1 == im2; fp["fg_img_src"] = J.gp(im1, "src")
	var mode = "nonat" if OS.has_environment("GB_NONAT") else "nat"
	var f = FileAccess.open("/tmp/L4/fp_%s.json" % mode, FileAccess.WRITE); f.store_string(JSON.stringify(fp, " ", true)); f.close()
	print("[xcheck] l4_fp written ", mode, " natives=", JSRun.native_used)

# ---- L4：scare_ops（要喺 GB_NAT_EXTRA 開咗 scare_ops）----
func _sc_reset(Sc, seed: float) -> void:
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"], true, seed])
	J.sp(Sc, "mana", 200.0); J.sp(Sc, "_intel", {}); J.sp(Sc, "known", {}); J.sp(Sc, "_opcd", {})

func _sc_sum(Sc) -> String:
	var ns = []
	for n in J.iter(J.gp(Sc, "npcs")):
		var o = {}
		for k in ["fear", "peak", "combo", "shaken", "fleeing", "gone", "bubT", "_seed", "out"]: o[k] = J.gp(n, k)   # bub 文字有隨機（其他人反應），唔比
		ns.append(o)
	var it = {}
	var I = J.gp(Sc, "_intel")
	if J.t(I): for k in I: it[k] = J.iter(I[k])
	return J.to_json({"mana": J.gp(Sc, "mana"), "kpi": J.gp(Sc, "kpi"), "expo": J.gp(Sc, "expo"), "opcd": J.gp(Sc, "_opcd"), "paused": J.gp(Sc, "paused"), "intel": it, "npcs": ns,
		"phone": J.gp(J.cl(J.G.get("$"), null, ["#sc-phone"]), "innerHTML")})

func _sc_cmp(label: String, a: String, b: String) -> void:
	if a == b: ok += 1
	else:
		bad += 1
		if bad <= 30:
			var i = 0
			while i < min(a.length(), b.length()) and a[i] == b[i]: i += 1
			print("[xcheck-diff] ", label, " @", i, " nat=", a.substr(max(0, i - 60), 200), "\n   tr=", b.substr(max(0, i - 60), 200))

func l4_scops(_t) -> void:
	mod = "scare_ops"
	var Sc = J.G.Scare
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"]])   # 有 DOM（#sc-phone）
	var rt = J.gp(Sc, "renderTarget"); var hd = J.gp(Sc, "hud")
	var tr = load_trans("scare_ops", ["ScareOps"]).ScareOps; var nat = J.G.ScareOps
	J.sp(Sc, "renderTarget", rt); J.sp(Sc, "hud", hd)   # 轉譯版 boot 會再包一層，還原
	var keep_hook = J.G.get("__nat_scOps"); J.G["__nat_scOps"] = null   # 用 HTML 版視窗先比得到
	var M = {"nat": nat, "tr": tr}
	var npcs = J.iter(J.gp(Sc, "npcs"))
	for i in npcs.size():
		var res = {}
		for side in ["nat", "tr"]:
			var X = M[side]; var out = []
			_sc_reset(Sc, 77.0); var n = J.iter(J.gp(Sc, "npcs"))[i]
			out.append(J.to_json(J.cl(X.ctx, null, [Sc, n])))
			for st in ["", "walk", "work", "call"]:
				J.sp(n, "act", st); out.append(J.to_json(J.cl(X.ctx, null, [Sc, n])))
			var O = J.gp(X.OPS, J.gp(J.gp(n, "d"), "k"))
			if J.t(O) and J.t(J.gp(O, "apps")):
				for tab in [null, "msg", "photo", "search", "note"]: J.cl(X.openPhone, null, [Sc, n, tab]); out.append(_sc_sum(Sc))
				J.cl(X.compose, null, [Sc, n]); out.append(_sc_sum(Sc))
			if J.t(O) and J.t(J.gp(O, "pc")): J.cl(X.openPC, null, [Sc, n]); out.append(_sc_sum(Sc))
			J.cl(X.openPantry, null, [Sc, n]); out.append(_sc_sum(Sc))
			J.cl(X.close, null, [Sc]); out.append(_sc_sum(Sc))
			out.append(J.to_json(J.cl(X.cdOf, null, [Sc, n, "k1"])))
			res[side] = out
		for j in res.nat.size(): _sc_cmp("npc%d#%d" % [i, j], res.nat[j], res.tr[j])
	# act：每個人 × 每一招（手機／電腦／茶水間），陰氣夠／唔夠、冷卻
	for i in npcs.size():
		for side_ops in ["msgs", "pc", "pantry"]:
			var cnt = 0
			_sc_reset(Sc, 77.0); var n0 = J.iter(J.gp(Sc, "npcs"))[i]
			var O0 = J.gp(nat.OPS, J.gp(J.gp(n0, "d"), "k"))
			var list = []
			if side_ops == "msgs" and J.t(O0): list = J.iter(J.gp(O0, "msgs"))
			elif side_ops == "pc" and J.t(O0) and J.t(J.gp(O0, "pc")): list = J.iter(J.gp(J.gp(O0, "pc"), "ops"))
			elif side_ops == "pantry": list = J.iter(nat.PANTRY)
			for oi in list.size():
				var res = {}
				for side in ["nat", "tr"]:
					var X = M[side]; var out = []
					_sc_reset(Sc, 77.0); var n = J.iter(J.gp(Sc, "npcs"))[i]; J.sp(n, "_seed", 4242.0)
					var lst = J.iter(J.gp(X.OPS[J.str(J.gp(J.gp(n, "d"), "k"))], "msgs")) if side_ops == "msgs" else (J.iter(J.gp(J.gp(X.OPS[J.str(J.gp(J.gp(n, "d"), "k"))], "pc"), "ops")) if side_ops == "pc" else J.iter(X.PANTRY))
					var o = lst[oi]
					var kind = "msg" if side_ops == "msgs" else side_ops
					J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))
					if J.t(J.gp(o, "say")): out.append(str(J.seq(J.gp(n, "bub"), J.cl(J.G.L, null, [J.gp(o, "say")]))))   # 有指定對白：要蓋返佢
					J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))   # 冷卻中
					J.sp(Sc, "_opcd", {}); J.sp(Sc, "mana", 1.0); J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))   # 陰氣唔夠
					J.sp(Sc, "mana", 200.0); J.sp(n, "gone", true); J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))   # 人唔喺度
					res[side] = out
				for j in res.nat.size(): _sc_cmp("act npc%d %s#%d.%d" % [i, side_ops, oi, j], res.nat[j], res.tr[j])
	J.G["__nat_scOps"] = keep_hook
	_report()

func l4_turf(_t) -> void:
	J.mc(J.G.Street, "open", [])
	J.mc(J.gp(J.G.Street, "Turf"), "open", ["bus"])
	print("[xcheck] turf opened on=", J.gp(J.gp(J.G.Street, "Turf"), "on"))

func l4_scphone(_t) -> void:
	var Sc = J.G.Scare; var n = J.iter(J.gp(Sc, "npcs"))[0]
	J.sp(Sc, "sel", n); J.cl(J.G.ScareOps.openPhone, null, [Sc, n, "msg"])
	print("[xcheck] phone paused=", J.gp(Sc, "paused"), " intel=", J.iter(J.cl(J.G.ScareOps.intel, null, [Sc, J.gp(J.gp(n, "d"), "k")])))

# ---------------- L4：畫布指令序列化（比原生／轉譯畫出嚟嘅嘢）----------------
static func ser_rec(r, depth := 0) -> String:
	if r == null: return "null"
	var out = PackedStringArray()
	for c in r.cmds: out.append(ser_v(c, depth))
	return "[" + ";".join(out) + "]"
static func ser_v(v, depth := 0) -> String:
	if v is Array:
		var a = PackedStringArray(); for x in v: a.append(ser_v(x, depth))
		return "(" + ",".join(a) + ")"
	if v is Recorder: return "R" + (ser_rec(v, depth + 1) if depth < 4 else "…")
	if v is Texture2D: return "T%dx%d%s" % [v.get_width(), v.get_height(), v.resource_path]
	if v is Font: return "F"
	if v is float: return "%.5f" % v
	if v is Vector2: return "V(%.4f,%.4f)" % [v.x, v.y]
	if v is Rect2: return "Q(%.4f,%.4f,%.4f,%.4f)" % [v.position.x, v.position.y, v.size.x, v.size.y]
	if v is Color: return "C(%.4f,%.4f,%.4f,%.4f)" % [v.r, v.g, v.b, v.a]
	if v is PackedVector2Array:
		var a2 = PackedStringArray(); for x in v: a2.append("%.3f,%.3f" % [x.x, x.y])
		return "P[" + " ".join(a2) + "]"
	return str(v)

static func new_ctx() -> Array:
	var cv = J.S_document_("createElement", ["canvas"]); J.sp(cv, "width", 450.0); J.sp(cv, "height", 975.0)
	return [cv, J.mc(cv, "getContext", ["2d"])]

# ---------------- L4：pantry ----------------
const OM_KEYS := ["drawBack", "drawables", "tick", "onProp", "init"]
func _om_get() -> Dictionary:
	var OM = J.G.OFFMAP; var d = {}
	for k in OM_KEYS: d[k] = J.gp(OM, k)
	return d
func _om_set(d: Dictionary) -> void:
	for k in OM_KEYS: J.sp(J.G.OFFMAP, k, d[k])

func _pt_run(W: Dictionary, P) -> Array:
	var Sc = J.G.Scare; var OM = J.G.OFFMAP; _om_set(W)
	seed(555)
	for n in J.iter(J.gp(Sc, "npcs")): J.sp(n, "_pu", null)
	J.cl(OM.init, OM, [Sc])
	J.sp(Sc, "camX", 5.75); J.sp(Sc, "_nat", false)   # 用 JS 畫法（唔經原生 __nat_* 鈎），先錄得到
	var npcs = J.iter(J.gp(Sc, "npcs")); var n0 = npcs[0]; var n1 = npcs[1] if npcs.size() > 1 else npcs[0]
	var SP = J.gp(OM, "SPOT"); var keep = [J.gp(n1, "x"), J.gp(n1, "y"), J.gp(n1, "act")]
	J.sp(n1, "x", J.gp(SP, "coffee")[0]); J.sp(n1, "y", J.gp(SP, "coffee")[1]); J.sp(n1, "act", "idle")
	var plan = {0: ["fx", "micro"], 10: ["fx", "coffee"], 20: ["fx", "fridgeloop"], 32: ["fx", "water"], 45: ["fx", "vend"], 70: ["fx", "snack"], 95: ["fx", "fridge"], 130: ["use", "water"], 150: ["use", "micro"], 170: ["prop", "kettle"], 180: ["prop", "vend"], 200: ["prop", "fridge"]}
	var out = []; var dt = 1.0 / 30
	for f in 420:
		if plan.has(f):
			var a = plan[f]
			if a[0] == "prop": J.cl(OM.onProp, OM, [a[1], n0, "pantry"])
			else: J.cl(J.gp(P, a[0]), null, [a[1], n0])
		J.sp(Sc, "t", f * dt)
		J.cl(OM.tick, OM, [dt])
		if f % 6 == 0:
			var cc = new_ctx(); var ctx = cc[1]
			if f == 0: print("[xcheck] dbg cv=", cc[0], " ctx=", ctx)
			J.cl(OM.drawBack, OM, [ctx, f * dt])
			var ds = J.cl(OM.drawables, OM, [])
			var zs = []
			for d in ds: zs.append(J.str(d[0])); J.cl(d[1], null, [ctx])
			var pu = []
			for n in npcs: pu.append(J.to_json(J.gp(n, "_pu")))
			out.append("f%d st=%s z=%s pu=%s rec=%s" % [f, J.to_json(J.cl(J.gp(P, "state"), null, [])), ",".join(zs), ",".join(pu), ser_rec(cc[0].js_rec() if cc[0] != null else null)])
	J.sp(n1, "x", keep[0]); J.sp(n1, "y", keep[1]); J.sp(n1, "act", keep[2])
	return out

func l4_pantry(_t) -> void:
	mod = "pantry"
	var Sc = J.G.Scare
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"]])
	var W_nat = _om_get(); var Pn = J.G.Pantry
	_om_set(Pn._orig)
	var Pt = load_trans("pantry", ["Pantry"]).Pantry
	var W_tr = _om_get(); _om_set(W_nat)
	var a = _pt_run(W_nat, Pn); var b = _pt_run(W_tr, Pt)
	for i in a.size(): _sc_cmp("pantry " + a[i].substr(0, 5), a[i], b[i])
	_om_set(W_nat)
	print("[xcheck] pantry frames=%d reclen=%d" % [a.size(), a[a.size() / 2].length()])
	_report()

static func _dom_ser(e) -> String:
	if e == null: return "null"
	var kids = PackedStringArray()
	for c in e.children: kids.append(_dom_ser(c))
	return "<%s id=%s cls=%s st=%s txt=%s>%s</>" % [e.tagName, e.id_, ",".join(e.classList.d.keys()), JSON.stringify(e.style), J.str(e.props.get("textContent", "")), "".join(kids)]

# ---------------- L4：rooms（要開 GB_NAT_EXTRA=rooms,pantry）----------------
func _rm_run(O: Dictionary, F: Dictionary) -> Array:
	# O：OFFMAP（資料／小函數）；F：未經 pantry 包嘅 init/tick/onProp/drawBack/drawables + drawOver
	var Sc = J.G.Scare; var out = []
	seed(777)
	J.cl(F.init, O, [Sc]); J.sp(Sc, "_nat", false)
	var npcs = J.iter(J.gp(Sc, "npcs")); var n0 = npcs[0]
	var plan = {0: ["micro", "main"], 5: ["fridge", "pantry"], 12: ["vend", "pantry"], 20: ["kettle", "pantry"], 30: ["tv", "meeting"], 40: ["speaker", "meeting"], 50: ["chairs", "meeting"], 60: ["golf", "boss"], 70: ["bchair", "boss"], 80: ["trophy", "boss"], 90: ["lights", "main"], 150: ["ac", "pantry"], 200: ["chairs", null], 230: ["lights", null]}
	var cams = [0.0, 1.5, 3.0, 4.5, 5.8, 7.5, 9.0]
	var dt = 1.0 / 30
	for f in 480:
		if plan.has(f): J.cl(F.onProp, O, [plan[f][0], (n0 if f != 200 else null), plan[f][1]])
		J.sp(Sc, "t", f * dt)
		J.cl(F.tick, O, [dt])
		if f % 8 == 0:
			J.sp(Sc, "camX", cams[(f / 8) % cams.size()])
			var cc = new_ctx(); var ctx = cc[1]
			J.cl(F.drawBack, O, [ctx, f * dt])
			var zs = []
			for d in J.cl(F.drawables, O, []): zs.append(J.str(d[0])); J.cl(d[1], null, [ctx])
			J.cl(F.drawOver, O, [ctx, f * dt])
			out.append("f%d z=%s rec=%s" % [f, ",".join(zs), ser_rec(cc[0].js_rec())])
	return out

func l4_rooms(_t) -> void:
	mod = "rooms"
	var Sc = J.G.Scare
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"]])
	var On = J.G.OFFMAP; var Po = J.G.Pantry._orig
	var Ot = load_trans("rooms", ["OFFMAP"]).OFFMAP
	# 資料同小函數
	for k in ["PXU", "WW", "SW", "SH", "SEAM", "WALLS", "WALLW", "PILLAR", "ROOMS", "OX", "SPOT", "LANE", "PATROL", "A", "WINMAIN", "ELEV"]:
		_sc_cmp("data " + k, J.to_json(J.gp(On, k)), J.to_json(J.gp(Ot, k)))
	_sc_cmp("RM keys", str(J.keys(J.gp(On, "RM"))), str(J.keys(J.gp(Ot, "RM"))))
	for k in J.keys(J.gp(Ot, "RM")): _sc_cmp("RM " + k, J.to_json(J.gp(J.gp(On, "RM"), k)), J.to_json(J.gp(J.gp(Ot, "RM"), k)))
	for x in [-1.0, 0.0, 0.5, 1.3, 2.2, 3.9, 5.0, 6.1, 7.7, 9.5, 10.3, 12.0]:
		for f in ["M", "MY", "px", "npx", "py", "Ru"]: _sc_cmp("%s(%s)" % [f, x], J.to_json(J.cl(J.gp(On, f), null, [x])), J.to_json(J.cl(J.gp(Ot, f), null, [x])))
		_sc_cmp("roomAt(%s)" % x, J.to_json(J.gp(J.cl(J.gp(On, "roomAt"), null, [x]), "k")), J.to_json(J.gp(J.cl(J.gp(Ot, "roomAt"), null, [x]), "k")))
	for v in [0.0, 100.0, 1506.0, 2000.0, 2600.0, 3000.0, 4458.0, 5000.0, 6000.0, 9000.0]: _sc_cmp("Rp(%s)" % v, J.to_json(J.cl(J.gp(On, "Rp"), null, [v])), J.to_json(J.cl(J.gp(Ot, "Rp"), null, [v])))
	_sc_cmp("R", J.to_json(J.cl(J.gp(On, "R"), null, [[100.0, 200.0, 300.0, 400.0]])), J.to_json(J.cl(J.gp(Ot, "R"), null, [[100.0, 200.0, 300.0, 400.0]])))
	_sc_cmp("mapHTML", J.str(J.cl(J.gp(On, "mapHTML"), null, [])), J.str(J.cl(J.gp(Ot, "mapHTML"), null, [])))
	# 畫＋狀態
	var Fn = {"init": Po.init, "tick": Po.tick, "onProp": Po.onProp, "drawBack": Po.drawBack, "drawables": Po.drawables, "drawOver": J.gp(On, "drawOver")}
	var Ft = {"init": J.gp(Ot, "init"), "tick": J.gp(Ot, "tick"), "onProp": J.gp(Ot, "onProp"), "drawBack": J.gp(Ot, "drawBack"), "drawables": J.gp(Ot, "drawables"), "drawOver": J.gp(Ot, "drawOver")}
	var a = _rm_run(On, Fn); var b = _rm_run(Ot, Ft)
	for i in a.size(): _sc_cmp("rooms " + a[i].substr(0, 5), a[i], b[i])
	# 小地圖：同一個 DOM，各跑一次比 #sc-map
	J.sp(Sc, "_nat", true)
	for side in [["nat", On], ["tr", Ot]]:
		var mp = J.S_document_("getElementById", ["scm-dots"])
		if mp != null: J.sp(mp, "innerHTML", "")
		J.sp(Sc, "_dots", {})
		J.cl(J.gp(side[1], "mapTick"), null, [Sc])
		var html = _dom_ser(J.S_document_("getElementById", ["sc-map"]))
		if side[0] == "nat": a = [html]
		else: _sc_cmp("mapTick", a[0], html)
	print("[xcheck] rooms frames=%d reclen=%d" % [b.size(), b[b.size() / 2].length()])
	_report()

# 實玩截圖用：夜班嚇人，鏡頭去茶水間，觸發幾樣電器
func l4_pantry_show(_t) -> void:
	var Sc = J.G.Scare; var n = J.iter(J.gp(Sc, "npcs"))[0]
	J.sp(Sc, "camX", 5.75); J.sp(Sc, "follow", false); J.sp(Sc, "userPan", 999.0)
	J.cl(J.G.Pantry.fx, null, ["fridgeloop", n]); J.cl(J.G.Pantry.fx, null, ["vend", n]); J.cl(J.G.Pantry.fx, null, ["micro", n]); J.cl(J.G.Pantry.fx, null, ["water", n])
	print("[xcheck] pantry_show state=", J.to_json(J.cl(J.G.Pantry.state, null, [])))
func l4_rooms_show(_t) -> void:
	var Sc = J.G.Scare
	J.sp(Sc, "camX", 1.2); J.sp(Sc, "follow", false); J.sp(Sc, "userPan", 999.0)
	for k in ["tv", "speaker", "chairs"]: J.cl(J.G.OFFMAP.onProp, J.G.OFFMAP, [k, J.iter(J.gp(Sc, "npcs"))[0], "meeting"])
	print("[xcheck] rooms_show")

# ---------------- L4：office（要開 GB_NAT_EXTRA=office；SC._nat=true，即係 Godot 真正行嘅路）----------------
const OF_F := ["id", "x", "y", "z", "uy", "rot", "vr", "hide", "falling", "ox", "oz", "sw", "vs", "vx", "vz", "puddle", "flown"]
func _of_state(X, npcs: Array) -> String:
	var N = J.gp(X, "_n"); var o = {}
	o["st"] = J.cl(J.gp(N, "st"), null, [])
	var its = J.cl(J.gp(N, "items"), null, []); var io = []
	for k in its:
		var it = its[k]; var d = {}
		for f in OF_F: d[f] = J.gp(it, f)
		io.append(d)
	o["items"] = io
	var S = J.gp(N, "STATIONS"); var so = {}
	for k in ["ken", "it"]: var s = S[k]; so[k] = {"K": J.gp(s, "K"), "mon": J.gp(s, "monSt"), "off": J.gp(s, "offline")}
	o["stn"] = so
	var dr = []
	for d in J.iter(J.cl(J.gp(N, "drops"), null, [])): dr.append([J.gp(d, "u"), J.gp(d, "v"), J.gp(d, "ox"), J.gp(d, "z"), J.gp(d, "life"), J.gp(d, "land")])
	o["drops"] = dr
	var nn = []
	for n in npcs:
		nn.append({"mis": J.gp(n, "mis"), "off": J.cl(J.gp(X, "kenOff"), null, [n]), "seat": J.cl(J.gp(X, "seated"), null, [n]), "z": J.cl(J.gp(X, "kenZ"), null, [n])})
	o["npc"] = nn
	var rr = []
	for id in ["cabinet", "binder1", "kmug", "lamp", "copier", "water", "achair", "kmon", "imon", "fan", "ws2", "wsm3"]: rr.append(J.cl(J.gp(X, "rectOf"), null, [id]))
	o["rect"] = rr
	o["K"] = [J.cl(J.gp(X, "K"), null, []), J.cl(J.gp(X, "K"), null, ["it"])]
	return J.to_json(o)

func _of_run(X, tag: String) -> Array:
	var Sc = J.G.Scare; J.G["OFFICE"] = X
	var w = J.G.get("window"); if w != null: J.sp(w, "OFFICE", X)
	var npcs = J.iter(J.gp(Sc, "npcs"))
	var keep = []
	for n in npcs: keep.append([J.gp(n, "x"), J.gp(n, "y"), J.gp(n, "act"), J.gp(n, "fear"), J.gp(n, "rx"), J.gp(n, "mis"), J.gp(n, "fleeing"), J.gp(n, "gone")])
	seed(4321)
	J.cl(J.gp(X, "init"), X, [Sc]); J.sp(Sc, "_nat", true)
	var S = J.gp(J.gp(X, "_n"), "STATIONS")
	var ken = null; var itn = null; var mis = null
	for n in npcs:
		J.sp(n, "mis", null); J.sp(n, "rx", null); J.sp(n, "fear", 0.0); J.sp(n, "fleeing", false); J.sp(n, "gone", false)
		var k = J.str(J.gp(J.gp(n, "d"), "k"))
		if k == "ken": ken = n
		elif k == "it": itn = n
		elif k == "mis": mis = n
	for pr in [[ken, "ken"], [itn, "it"]]:
		if pr[0] != null: var se = J.gp(S[pr[1]], "seat"); J.sp(pr[0], "x", J.gp(se, "x")); J.sp(pr[0], "y", J.gp(se, "y")); J.sp(pr[0], "act", "work")
	if mis != null:
		var SP = J.gp(J.gp(J.G.OFFMAP, "SPOT"), "copier"); J.sp(mis, "x", J.num(SP[0]) + 0.16); J.sp(mis, "y", J.num(SP[1]) + 0.05); J.sp(mis, "act", "idle")
	if tag == "nat": print("[xcheck] office npcs ken=%s it=%s mis=%s n=%d" % [ken != null, itn != null, mis != null, npcs.size()])
	var cx = J.num(J.gp(J.gp(S.ken, "seat"), "x"))
	var plan = {20: ["prop", "lamp"], 45: ["prop", "ac"], 60: ["scare", 0.3], 80: ["prop", "water"], 100: ["prop", "printer"], 140: ["fear", 60.0], 150: ["scare", 0.9], 175: ["prop", "drop"], 210: ["prop", "chair"], 230: ["calm"], 260: ["prop", "lights"],
		300: ["elev"], 320: ["off", true], 340: ["walk"], 380: ["back"], 400: ["rx", "startle"], 430: ["off", false], 450: ["scare", 1.1], 470: ["rxend"], 520: ["prop", "drop"], 560: ["prop", "chair"]}
	var cams = [0.0, 0.6, 1.2, 2.0, 3.5, 5.5, 8.5]
	var out = []; var dt = 1.0 / 30
	for f in 640:
		if plan.has(f):
			var a = plan[f]
			match a[0]:
				"prop": J.cl(J.gp(X, "onProp"), null, [a[1]])
				"scare": J.cl(J.gp(X, "onScare"), null, [cx, J.num(J.gp(J.gp(S.ken, "seat"), "y")), a[1]])
				"fear": for n in [ken, itn, mis]: if n != null: J.sp(n, "fear", a[1])
				"calm": for n in [ken, itn, mis]: if n != null: J.sp(n, "fear", 0.0)
				"elev": J.cl(J.gp(X, "elevator"), null, [])
				"off": J.cl(J.gp(X, "offline"), null, ["ken", a[1]])
				"walk": for n in [ken, mis]: if n != null: J.sp(n, "act", "walk"); J.sp(n, "x", J.num(J.gp(n, "x")) + 0.05)
				"back":
					if ken != null: var se2 = J.gp(S.ken, "seat"); J.sp(ken, "x", J.gp(se2, "x")); J.sp(ken, "y", J.gp(se2, "y")); J.sp(ken, "act", "work")
					if mis != null: J.sp(mis, "act", "idle")
				"rx": for n in [ken, itn, mis]: if n != null: J.sp(n, "rx", {"k": a[1], "t": 0.1, "src": cx + 0.3})
				"rxend": for n in [ken, itn, mis]: if n != null: J.sp(n, "rx", null)
		J.sp(Sc, "t", f * dt)
		for n in npcs: J.cl(J.gp(X, "kenTick"), null, [n, dt])
		J.cl(J.gp(X, "tick"), null, [dt])
		if f % 10 == 0:
			J.sp(Sc, "camX", cams[(f / 10) % cams.size()])
			var cc = new_ctx(); var ctx = cc[1]
			J.cl(J.gp(X, "drawBack"), null, [ctx, f * dt])
			J.cl(J.gp(X, "drawFloor"), null, [ctx, f * dt])
			var zs = []
			for d in J.iter(J.cl(J.gp(X, "drawables"), null, [f * dt])): zs.append("%.5f" % J.num(d[0])); J.cl(d[1], null, [ctx])
			for n in [ken, itn]: if n != null: J.cl(J.gp(X, "drawKen"), null, [ctx, n, f * dt])
			# drawMis：Godot 唔會叫（美美行 __nat_scNpc→ScMis），轉譯版係 JS 畫法，唔比
			J.cl(J.gp(X, "drawDark"), null, [ctx, f * dt])
			ctx.save(); J.cl(J.gp(X, "clipWindow"), null, [ctx]); ctx.restore()
			out.append("f%d S=%s z=%s rec=%s" % [f, _of_state(X, npcs), ",".join(zs), ser_rec(cc[0].js_rec())])
	for i in npcs.size():
		var n = npcs[i]; var kp = keep[i]
		for j in 8: J.sp(n, ["x", "y", "act", "fear", "rx", "mis", "fleeing", "gone"][j], kp[j])
	return out

func l4_office(_t) -> void:
	mod = "office"
	var Sc = J.G.Scare
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"]])
	var On = J.G.OFFICE
	var Ot = load_trans("office", ["OFFICE"]).OFFICE
	for k in ["AC", "WIN", "CLOCK", "SEAT"]: _sc_cmp("data " + k, J.to_json(J.gp(On, k)), J.to_json(J.gp(Ot, k)))
	var a = _of_run(On, "nat"); var b = _of_run(Ot, "tr"); var c = _of_run(On, "nat2")
	var selfd = 0
	for i in a.size(): if a[i] != c[i]: selfd += 1
	print("[xcheck] office nat-vs-nat diffs=", selfd)
	J.G["OFFICE"] = On; var w = J.G.get("window"); if w != null: J.sp(w, "OFFICE", On)
	for i in a.size(): _sc_cmp("office " + a[i].substr(0, 5), a[i], b[i])
	J.cl(J.gp(On, "init"), On, [Sc])
	print("[xcheck] office frames=%d reclen=%d" % [a.size(), a[a.size() / 2].length()])
	_report()

# ---------------- L4：scare_squad（要開 GB_NAT_EXTRA=scare_squad）----------------
func _sq_night(Sc) -> String:
	var N = J.gp(Sc, "night"); var o = {}
	if J.t(N):
		for k in N: o[k] = J.iter(N[k]) if k == "types" or k == "tricks" else N[k]
	var B = J.gp(Sc, "bryan"); var bo = null
	if J.t(B):
		bo = {}
		for k in B: if k != "R" and k != "tgt": bo[k] = B[k]
		bo["tgt"] = J.gp(J.gp(B.get("tgt"), "d"), "k") if J.t(B.get("tgt")) else null
	var ns = []
	for n in J.iter(J.gp(Sc, "npcs")): ns.append([J.gp(J.gp(n, "d"), "k"), J.gp(n, "x"), J.gp(n, "y"), J.gp(n, "fear"), J.gp(n, "peak"), J.gp(n, "shaken"), J.gp(n, "lookUp"), J.gp(n, "fleeing"), J.gp(n, "mocked")])
	return J.to_json({"N": o, "B": bo, "npcs": ns, "kpi": J.gp(Sc, "kpi"), "dao": [J.gp(Sc, "daoAt"), J.gp(Sc, "daoDelay")]})

func _sq_run(X, heat: float, seed_: float, force) -> Array:
	var Sc = J.G.Scare; var S = J.G.S; J.G["ScareX"] = X
	var w = J.G.get("window"); if w != null: J.sp(w, "ScareX", X)
	J.sp(S, "legend", {"office": {"heat": heat, "nights": 2.0}})
	J.sp(Sc, "forceBryan", force)
	seed(int(seed_))
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"], true, seed_])
	var out = ["start " + _sq_night(Sc)]
	var dt = 1.0 / 30; var t0 = J.num(J.gp(Sc, "t"))
	var npcs = J.iter(J.gp(Sc, "npcs"))
	var sigs = ["frost", "copier", "pop", "screen", "spark", "snip", "drip", "laugh", "smoke", "shadow", "coins", "hair", "veil", "tongue", "bones", "thump", "flash", "heat", "phone", "whisper", "scream", "prints", "dark"]
	for f in 2700:
		J.sp(Sc, "t", t0 + f * dt)
		J.cl(J.gp(X, "tick"), null, [Sc, dt])
		if f % 150 == 75 and npcs.size():
			var n = npcs[(f / 150) % npcs.size()]
			J.sp(n, "fear", J.num(J.gp(n, "fear")) + 12)
			J.cl(J.gp(X, "onHit"), null, [Sc, n, {"type": ["light", "sound", "face", "cold"][f % 4], "pts": 12.0 if f % 300 else 0.0, "gain": 5.0, "clean": true, "mk": float(f % 3), "alone": f % 2 == 1, "seen": false, "burst": false, "tier": 1.0, "ghost": ["afu", "toyol", "eguiking"][f % 3]}])
		if f % 30 == 0:
			var B = J.gp(Sc, "bryan")
			if J.t(B): J.sp(Sc, "camX", maxf(0.0, J.num(B.x) - 0.5))
			var cc = new_ctx(); var ctx = cc[1]
			J.cl(J.gp(X, "draw"), null, [Sc, ctx, f * dt])
			if f % 120 == 0 and npcs.size():
				var n2 = npcs[0]; J.sp(Sc, "camX", maxf(0.0, J.num(J.gp(n2, "x")) - 0.5))
				var sg = sigs[(f / 120) % sigs.size()]
				for k in [0.05, 0.3, 0.6, 0.9]:
					seed(f + int(k * 100))
					J.cl(J.gp(X, "sigFx"), null, [Sc, ctx, {"n": n2, "sig": sg, "col": "#80d0ff", "ghost": ["n30_daji", "n30_nopperabo", "n30_pelesit", "toyol"][f % 4], "sigText": "測試"}, f * dt, k])
			out.append("f%d %s rec=%s" % [f, _sq_night(Sc), ser_rec(cc[0].js_rec())])
	var ev = []
	var html = J.cl(J.gp(X, "finish"), null, [Sc, 2.0, false])
	out.append("finish " + J.str(html) + " S=" + J.to_json(J.gp(S, "legend")))
	out.append("finish2 " + J.str(J.cl(J.gp(X, "finish"), null, [Sc, 1.0, true])) + " S=" + J.to_json(J.gp(S, "legend")))
	return out

func l4_squad(_t) -> void:
	mod = "scare_squad"
	var Sc = J.G.Scare; var S = J.G.S
	var Xn = J.G.ScareX; var SGn = J.to_json(J.G.SCARE_GHOSTS)
	var keep_sq = J.gp(Sc, "squad"); var keep_lg = J.gp(Sc, "legend")
	var Xt = load_trans("scare_squad", ["ScareX"]).ScareX
	_sc_cmp("SCARE_GHOSTS", SGn, J.to_json(J.G.SCARE_GHOSTS))
	var Xsq_t = J.gp(Sc, "squad"); J.sp(Sc, "squad", keep_sq); J.sp(Sc, "legend", keep_lg)
	_sc_cmp("SIG", J.to_json(J.gp(Xn, "SIG")), J.to_json(J.gp(Xt, "SIG")))
	var keep_legend = J.gp(S, "legend"); var keep_ssq = J.gp(S, "scareSquad")
	# 傳說、隊伍、KOL
	for heat in [0.0, 39.0, 40.0, 109.0, 150.0, 220.0, 379.0, 380.0, 999.0]:
		J.sp(S, "legend", {"office": {"heat": heat, "nights": 3.0}})
		for loc in ["office", null, "other"]:
			_sc_cmp("legend %s %s" % [heat, loc], J.to_json(J.cl(J.gp(Xn, "legend"), null, [loc])), J.to_json(J.cl(J.gp(Xt, "legend"), null, [loc])))
	for ids in [null, [], ["tianhua"], ["afu", "toyol", "toyol", "eguiking", "pontianak", "xx", "tianhua"], ["eguiking"]]:
		var r = []
		for X2 in [[Xn, keep_sq], [Xt, Xsq_t]]:
			J.sp(S, "scareSquad", keep_ssq)
			var q = J.gp(X2[0], "squad")
			r.append(J.to_json([J.mc(q, "set", [ids]), J.mc(q, "get", []), J.mc(q, "team", []), J.mc(q, "options", []), J.gp(S, "scareSquad"), J.cl(J.gp(J.gp(X2[0], "_n"), "maxSq"), null, []), J.cl(J.gp(J.gp(X2[0], "_n"), "owned"), null, [])]))
		_sc_cmp("squad %s" % [ids], r[0], r[1])
	J.sp(S, "scareSquad", keep_ssq)
	for wk in ["sound", "face"]: _sc_cmp("KOL " + wk, J.to_json(J.cl(J.gp(Xn, "KOL"), null, [wk])), J.to_json(J.cl(J.gp(Xt, "KOL"), null, [wk])))
	# 夜晚：唔同傳說等級、Bryan 有冇
	for cfg in [[0.0, 11.0, true], [150.0, 23.0, true], [250.0, 37.0, null], [400.0, 5.0, true], [60.0, 8.0, false]]:
		var a = _sq_run(Xn, cfg[0], cfg[1], cfg[2]); var b = _sq_run(Xt, cfg[0], cfg[1], cfg[2])
		for i in a.size(): _sc_cmp("night%s %s" % [cfg, a[i].substr(0, 8)], a[i], b[i])
		print("[xcheck] squad cfg=%s lines=%d last=%s" % [cfg, a.size(), a[a.size() - 3].substr(0, 300)])
	J.G["ScareX"] = Xn; var w = J.G.get("window"); if w != null: J.sp(w, "ScareX", Xn)
	J.sp(S, "legend", keep_legend); J.sp(Sc, "forceBryan", null)
	_report()

# 實玩：帶隊出更（揀隊→出發→出招→收工）
func l4_sel(_t) -> void:
	J.mc(J.G.Scare, "open", ["office"]); print("[xcheck] sel opened")
func l4_endnight(_t) -> void:
	var Sc = J.G.Scare; J.sp(Sc, "t", 179.0); J.sp(Sc, "forceBryan", null)
	print("[xcheck] night=", _sq_night(Sc).substr(0, 400))
func l4_after(_t) -> void:
	var Sc = J.G.Scare
	print("[xcheck] after active=", J.gp(Sc, "active"), " legendHTML=", J.str(J.gp(Sc, "_legendHTML")).substr(0, 300), " S.legend=", J.to_json(J.gp(J.G.S, "legend")))

# ---------------- L4：scare 分段（native/scare.gd；GB_NAT_EXTRA=scare）----------------
static func _ks(v) -> String:
	if v is Array:
		var o = []
		for x in v: o.append(J.gp(J.gp(x, "d"), "k") if x is Dictionary and x.has("d") else x)
		return J.to_json(o)
	if v is Dictionary and v.has("k") and v.has("x0"): return "room:" + J.str(v.k)
	return J.to_json(v)
func _sx(Sc, NS, m: String, args: Array, label := "") -> void:
	var f_n = Sc[m]; var f_t = NS.ORIG[m]
	var a = _ks(J.cl(f_n, Sc, args.duplicate())); var b = _ks(J.cl(f_t, Sc, args.duplicate()))
	_sc_cmp(m + label, a, b)
func _sx_rng(Sc, NS, m: String, n, args: Array) -> void:
	var s0 = J.gp(n, "_seed")
	var a = _ks(J.cl(Sc[m], Sc, args)); var s1 = J.gp(n, "_seed"); J.sp(n, "_seed", s0)
	var b = _ks(J.cl(NS.ORIG[m], Sc, args)); var s2 = J.gp(n, "_seed")
	_sc_cmp(m, a + J.str(s1), b + J.str(s2))
func _sc_state(Sc) -> String:
	var ns = []
	for n in J.iter(J.gp(Sc, "npcs")):
		var o = {}
		for k in ["x", "y", "act", "fear", "peak", "dir", "wait", "wi", "gone", "out", "fleeing", "leaving", "shaken", "lookUp", "lookCD", "_seed", "bub", "bubT", "li", "napAt", "ds", "prog", "rT", "tour", "mocked", "combo", "comboT", "hab", "wl", "glance", "look", "outT", "inWait", "left", "viaDone", "uneasy", "spot"]: o[k] = J.gp(n, k)
		var cl = J.gp(n, "call")
		if J.t(cl): o["call"] = [J.gp(cl, "x"), J.gp(cl, "act"), J.gp(cl, "delay"), J.gp(cl, "hold")]
		var ev = J.gp(n, "ev")
		if J.t(ev): o["ev"] = J.to_json(ev)
		var st = J.gp(n, "step")
		if J.t(st): o["step"] = [J.gp(st, "x"), J.gp(st, "y"), J.gp(st, "act"), J.gp(st, "arrived"), J.gp(st, "wait")]
		ns.append(o)
	return J.to_json({"t": J.gp(Sc, "t"), "kpi": J.gp(Sc, "kpi"), "mana": J.gp(Sc, "mana"), "expo": J.gp(Sc, "expo"), "alert": J.gp(Sc, "alert"), "daoCall": J.gp(Sc, "daoCall"), "daoIn": J.gp(Sc, "daoIn"), "expelled": J.gp(Sc, "expelled"), "expoRoom": J.gp(Sc, "expoRoom"), "door": J.gp(Sc, "door"), "meetT": J.gp(Sc, "meetT"), "callT": J.gp(Sc, "callT"), "known": J.to_json(J.gp(Sc, "known")), "cd": J.gp(Sc, "cd"), "pcd": J.gp(Sc, "pcd"), "hab": J.gp(Sc, "_hab"), "karma": J.gp(Sc, "karma"), "night": J.gp(Sc, "night") != null, "npcs": ns})
func _scare_battery(Sc, NS) -> void:
	var npcs = J.iter(J.gp(Sc, "npcs")); var props = J.keys(J.G.SCARE_PROPS)
	for m in ["viewW", "camRoom", "bgScale", "persp", "bgAR", "office", "groupRoom", "exitPt"]: _sx(Sc, NS, m, [])
	for x in [-0.3, 0.0, 0.45, 1.2, 2.5, 3.9, 5.1, 6.6, 8.0, 9.9, 11.5]:
		_sx(Sc, NS, "clampCam", [x]); _sx(Sc, NS, "onScreen", [x, null]); _sx(Sc, NS, "onScreen", [x, 0.1]); _sx(Sc, NS, "inDoor", [x])
		for y in [0.5, 0.62, 0.8, 0.95]: _sx(Sc, NS, "pt", [x, y]); _sx(Sc, NS, "hh", [y]); _sx(Sc, NS, "hhF", [y]); _sx(Sc, NS, "depth", [y])
	for k in J.keys(J.G.SCARE_GHOSTS):
		_sx(Sc, NS, "gpq", [k])
		for n in npcs: _sx(Sc, NS, "ghostType", [k, n])
		_sx(Sc, NS, "ghostType", [k, null])
	for n in npcs:
		for m in ["roomOf", "present", "sitting", "tagExt", "headsDown", "watching", "witnesses", "hearers", "workOf"]: _sx(Sc, NS, m, [n])
		_sx(Sc, NS, "viaElev", [n, J.gp(n, "x"), J.gp(n, "y")])
		for tx in [0.3, 2.0, 4.5, 7.0, 10.0]: _sx(Sc, NS, "walkBlocked", [n, tx]); _sx(Sc, NS, "busy", [n, tx]); _sx(Sc, NS, "freeSpot", [n, tx, 0.75])
		for m2 in npcs: _sx(Sc, NS, "sees", [m2, n]); _sx(Sc, NS, "sameRoom", [m2, n]); _sx(Sc, NS, "inBeam", [m2, J.num(J.gp(n, "x")) + 0.1, J.gp(n, "y")])
		for k in props: _sx(Sc, NS, "propOK", [k, n])
		_sx(Sc, NS, "inGroup", [n, "main"]); _sx(Sc, NS, "inGroup", [n, null])
		if J.gp(n, "_seed") != null: _sx_rng(Sc, NS, "rng", n, [n]); _sx_rng(Sc, NS, "U", n, [n, 2.0, 9.0]); _sx_rng(Sc, NS, "rnd", n, [n])
	for k in props: _sx(Sc, NS, "propOK", [k, null])

func l4_scare1(_t) -> void:
	mod = "scare1"
	var NS = load("res://native/scare.gd")
	var Sc = J.G.Scare; var S = J.G.S
	# 星星
	var keep = J.gp(S, "scare")
	for st in [{"fv": 2.0, "best": {"office": 900.0}}, {"fv": 2.0, "best": {"office": 1700.0}}, {"fv": 1.0, "best": {"office": 300.0}}, {"fv": 1.0, "best": {"office": 900.0}}, {"best": {"office": 100.0}}, {"fv": 3.0, "best": {"office": 1400.0}}]:
		var r = []
		for f in [Sc.starsOf, NS.ORIG.starsOf]:
			J.sp(S, "scare", st.duplicate(true)); var v = J.cl(f, Sc, ["office", 1290.0]); r.append(J.to_json([v, J.gp(S, "scare")]))
		_sc_cmp("starsOf", r[0], r[1])
	J.sp(S, "scare", keep)
	for v in [0.0, 1099.0, 1100.0, 1300.0, 1480.0, 5000.0]: _sx(Sc, NS, "starsOf", ["office", v])
	# 一晚（headless）：逐段比
	for sd in [11.0, 4242.0]:
		J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"], true, sd])
		var dt = 1.0 / 30
		for f in 5400:
			J.mc(Sc, "step", [dt])
			if not J.t(J.gp(Sc, "active")): break
			if f % 300 == 7:
				for hl in [true, false]:
					J.sp(Sc, "headless", hl)
					for cx in [0.0, 3.3, 7.7]: J.sp(Sc, "camX", cx); _scare_battery(Sc, NS)
				J.sp(Sc, "headless", true)
		print("[xcheck] scare1 seed=%s t=%s ok=%d bad=%d" % [sd, J.gp(Sc, "t"), ok, bad])
	# 成晚決定性：原生 vs 轉譯
	for cfg in [[777.0, false], [31.0, true], [5150.0, true]]:
		var runs = []
		for side in ["nat", "tr"]:
			var keepM = {}
			for k in NS.ORIG: keepM[k] = Sc[k]; Sc[k] = NS.ORIG[k] if side == "tr" else NS.NAT[k]
			for k in ["meetT", "callT", "callWho", "expoRoom", "_hab"]: J.sp(Sc, k, null)
			seed(99); J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"], true, cfg[0]])
			var out = []
			for f in 5400:
				if cfg[1]:
					var ns = J.iter(J.gp(Sc, "npcs"))
					if f % 400 == 200: var m = ns[(f / 400) % ns.size()]; J.sp(m, "fear", 62.0); J.sp(m, "peak", 62.0)
					if f == 1500: J.mc(Sc, "expose", [80.0, ns[1]])
					if f == 2600: J.sp(ns[2], "fleeing", true)
					if f == 3000: J.mc(Sc, "jumpy", [null, null]); J.mc(Sc, "wakeGuard", [ns[0]])
					if f % 90 == 45:
						J.sp(Sc, "mana", 100.0)
						var who = ns[(f / 90) % ns.size()]; J.sp(Sc, "sel", who)
						var acts = J.keys(J.G.SCARE_PROPS) + ["@phone", "@breath", "#afu", "#eguiking", "#toyol"]
						var ac = J.str(acts[(f / 90) % acts.size()])
						if ac == "@phone": J.mc(Sc, "usePhone", [who])
						elif ac == "@breath": J.mc(Sc, "useBreath", [who])
						elif ac.begins_with("#"): J.sp(J.gp(Sc, "cd"), ac.substr(1), 0.0); J.mc(Sc, "useGhost", [ac.substr(1), who])
						else: J.sp(J.gp(Sc, "pcd") if J.t(J.gp(Sc, "pcd")) else {}, ac, 0.0); J.mc(Sc, "useProp", [ac, who])
				J.mc(Sc, "step", [1.0 / 30])
				if f % 60 == 0: out.append(_sc_state(Sc))
				if not J.t(J.gp(Sc, "active")): break
			out.append(_sc_state(Sc)); runs.append(out)
			for k in keepM: Sc[k] = keepM[k]
		_sc_cmp("night len", str(runs[0].size()), str(runs[1].size()))
		for i in mini(runs[0].size(), runs[1].size()): _sc_cmp("night%s f%d" % [cfg[0], i * 60], runs[0][i], runs[1][i])
		print("[xcheck] scare night cfg=%s frames=%d last=%s" % [cfg, runs[0].size(), runs[0][runs[0].size() - 1].substr(0, 300)])
	# 第四段：提示字、粒子、人物卡（非 headless）
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"], true, 5.0])
	for st in 300: J.mc(Sc, "step", [1.0 / 30])
	var res = []
	for side in ["nat", "tr"]:
		var FN = NS.NAT if side == "nat" else NS.ORIG
		J.sp(Sc, "headless", false); J.sp(Sc, "fq", []); J.sp(Sc, "floats", []); J.sp(Sc, "parts", []); seed(7)
		var o = []
		for i in 6: J.cl(FN["float"], Sc, [0.1, 0.2, "f%d" % i, "#fff", 0.5 + i * 0.3]); J.cl(FN["floatTick"], Sc, [0.4])
		J.cl(FN["toast"], Sc, ["hi"]); J.cl(FN["floatOld"], Sc, [0.3, 0.4, "old", "#000", null])
		for i in 20: J.cl(FN["floatTick"], Sc, [0.25]); o.append(J.to_json([J.gp(Sc, "fq"), J.gp(Sc, "floats")]))
		var ns = J.iter(J.gp(Sc, "npcs"))
		for n in ns:
			o.append(J.str(J.cl(FN["profile"], Sc, [n]))); J.sp(n, "fleeT", null); J.cl(FN["dust"], Sc, [n])
		for k in ["printer", "ac", "water", "lamp"]:
			J.cl(FN["propParts"], Sc, [k, J.gp(J.G.SCARE_PROPS, k), null]); J.cl(FN["propParts"], Sc, [k, J.gp(J.G.SCARE_PROPS, k), ns[0]])
		o.append(J.to_json(J.gp(Sc, "parts")))
		J.sp(Sc, "headless", true); res.append(o)
	for i in res[0].size(): _sc_cmp("ui%d" % i, res[0][i], res[1][i])
	# 第五段：動畫狀態
	var keepT = J.G.get("TOWN"); var keepO = J.G.get("OFFICE")
	var ns2 = J.iter(J.gp(Sc, "npcs"))
	for idx in ns2.size():
		var base = ns2[idx]
		for fear in [0.0, 30.0, 60.0, 90.0]:
			for rk in [null, "flinch", "startle", "weakjump", "burst", "rational", "numb", "sip", "catch", "chill"]:
				for rt in [-0.2, 0.05, 0.3, 0.6, 1.0, 1.2, 1.7, 2.0, 2.5]:
					var outs = []
					for side in ["nat", "tr"]:
						var FN = NS.NAT if side == "nat" else NS.ORIG
						var n = base.duplicate(); n["fear"] = fear; n["hab"] = {"light": 1.6} if fear == 30.0 else {}
						n["rx"] = {"k": rk, "t": rt, "dur": 2.6 if rk == "burst" else 1.0, "src": 1.5, "big": fear > 50} if rk != null else null
						n["at"] = rt * 3; n["shaken"] = 1.0 if fear >= 60 else 0.0
						if fear == 90.0 and rt > 1: n["fleeing"] = true; n["fleeT"] = J.num(J.gp(Sc, "t")) - rt; n["fleeHold"] = 0.9; n["trail"] = [[J.num(J.gp(Sc, "t")) - 2, 1.0, 0.7], [J.num(J.gp(Sc, "t")) - 1, 1.2, 0.75], [J.num(J.gp(Sc, "t")), 1.5, 0.8]]
						J.sp(Sc, "headless", false); J.sp(Sc, "parts", []); seed(int(fear * 10 + rt * 100) + idx)
						var o = [J.to_json(J.cl(FN["npcPose"], Sc, [n])), J.to_json(J.cl(FN["visPos"], Sc, [n])), J.to_json(J.cl(FN["rigOK"], Sc, [J.gp(J.gp(n, "d"), "spr")]))]
						J.G["TOWN"] = null; J.G["OFFICE"] = null
						J.cl(FN["animNpc"], Sc, [n, 0.1]); J.cl(FN["react"], Sc, [n, "flinch" if rt < 1 else "burst", {"delay": 0.1, "src": 2.0}]); J.cl(FN["animNpc"], Sc, [n, 0.2])
						if J.t(n.get("rx")): J.cl(FN["onReact"], Sc, [n])
						J.G["TOWN"] = keepT; J.G["OFFICE"] = keepO
						var st = {}
						for kk in ["rx", "at", "lv", "markPop", "goose", "hair", "shock", "scream", "barHit", "trail"]: st[kk] = n.get(kk)
						o.append(J.to_json(st)); o.append(J.to_json(J.gp(Sc, "parts")))
						J.sp(Sc, "headless", true); outs.append("|".join(o))
					_sc_cmp("anim %d %s %s %s" % [idx, fear, rk, rt], outs[0], outs[1])
	J.sp(Sc, "active", false)
	_report()

# 第六段：畫面（夜班一晚：headless 跑規則，每 45 格用原生／轉譯各畫一次比錄落嘅指令）
const SC_DRAW_KEYS := ["_bubR", "_tagR", "_bubLast", "_nTag", "_edge", "_bubOK"]
func _sd_snap(Sc) -> Array:
	var s = {}
	for k in SC_DRAW_KEYS: s[k] = J.gp(Sc, k)
	s["parts"] = J.iter(J.gp(Sc, "parts")).duplicate(true)
	var ns = []
	for n in J.iter(J.gp(Sc, "npcs")): ns.append([n.get("vX"), n.get("vY"), n.get("spd")])
	return [s, ns]
func _sd_restore(Sc, sn: Array) -> void:
	for k in sn[0]:
		var v = sn[0][k]
		J.sp(Sc, k, v.duplicate(true) if v is Array else v)
	var ns = J.iter(J.gp(Sc, "npcs"))
	for i in mini(ns.size(), sn[1].size()): ns[i]["vX"] = sn[1][i][0]; ns[i]["vY"] = sn[1][i][1]; ns[i]["spd"] = sn[1][i][2]
func l4_scare_draw(_t) -> void:
	mod = "scare_draw"
	var NS = load("res://native/scare.gd"); var Sc = J.G.Scare
	for cfg in [[false, 21.0], [true, 21.0], [false, 909.0]]:
		J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol", "pontianak", "tianhua", "penanggal", "laojiang"], true, cfg[1]])
		J.sp(Sc, "team", ["afu", "eguiking", "toyol", "pontianak", "tianhua", "penanggal", "laojiang"])
		for k in J.iter(J.gp(Sc, "team")): J.sp(J.gp(Sc, "cd"), k, 0.0)
		J.sp(Sc, "W", 450.0); J.sp(Sc, "H", 780.0); J.sp(Sc, "dpr", 1.0); J.sp(Sc, "camX", 0.0)
		J.sp(Sc, "headless", false); J.cl(J.gp(J.G.OFFMAP, "init"), J.G.OFFMAP, [Sc]); J.mc(J.G.OFFICE, "init", [Sc]); J.sp(Sc, "headless", true)
		var ns = J.iter(J.gp(Sc, "npcs")); var dt = 1.0 / 30
		var ghosts = ["afu", "eguiking", "toyol", "pontianak", "tianhua", "penanggal", "laojiang"]
		for f in 4800:
			if f % 70 == 20:
				J.sp(Sc, "mana", 100.0); var who = ns[(f / 70) % ns.size()]; J.sp(Sc, "sel", who)
				var gk = ghosts[(f / 70) % ghosts.size()]; J.sp(J.gp(Sc, "cd"), gk, 0.0)
				if f % 140 == 20: J.mc(Sc, "useGhost", [gk, who])
				else: J.mc(Sc, "useBreath" if f % 280 == 90 else "usePhone", [who])
			if f == 1500: J.mc(Sc, "expose", [80.0, ns[1]])
			if f % 400 == 200: J.sp(ns[(f / 400) % ns.size()], "fear", 70.0)
			J.mc(Sc, "step", [dt])
			if not J.t(J.gp(Sc, "active")): break
			if f % 45 == 0:
				J.sp(Sc, "camX", fmod(f * 0.003, 9.0)); J.sp(Sc, "_nat", cfg[0])
				var recs = []; var sn = _sd_snap(Sc)
				for side in ["nat", "tr"]:
					var FN = NS.NAT if side == "nat" else NS.ORIG; var keep = {}
					for k in NS.ORIG: keep[k] = Sc[k]; Sc[k] = FN[k]
					_sd_restore(Sc, sn); seed(f + 5)
					var cc = new_ctx(); J.sp(Sc, "_natCtx", cc[1]); J.sp(Sc, "headless", false)
					J.cl(Sc["draw"], Sc, [f * dt])
					J.sp(Sc, "headless", true); J.sp(Sc, "_natCtx", null)
					var st = {}
					for k in ["_bubR", "_tagR", "_bubLast", "_nTag"]: st[k] = J.gp(Sc, k)
					st["edge"] = J.gp(Sc, "_edge") != null; st["parts"] = J.iter(J.gp(Sc, "parts")).size()
					var vv = []
					for n in ns: vv.append([n.get("vX"), n.get("vY"), n.get("spd")])
					recs.append("st=%s v=%s rec=%s" % [J.to_json(st), J.to_json(vv), ser_rec(cc[0].js_rec())])
					for k in keep: Sc[k] = keep[k]
				_sc_cmp("draw nat=%s f%d" % [cfg[0], f], recs[0], recs[1])
		print("[xcheck] scare_draw cfg=%s t=%s ok=%d bad=%d reclen=%d" % [cfg, J.gp(Sc, "t"), ok, bad, 0])
	J.sp(Sc, "active", false); J.sp(Sc, "_nat", false)
	_report()
func l4_fast(_t) -> void:
	J.sp(J.G.Scare, "timeScale", 6.0); print("[xcheck] fast natives=", JSRun.native_used.has("scare"))
