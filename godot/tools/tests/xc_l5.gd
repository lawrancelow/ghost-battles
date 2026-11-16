# L5（動畫與日常）原生改寫對照
extends "res://tools/tests/native_xcheck.gd"

func eqv(name: String, a, b) -> void:
	if JSON.stringify(a) == JSON.stringify(b): ok += 1
	else:
		bad += 1
		var sa = JSON.stringify(a); var sb = JSON.stringify(b); var i = 0
		while i < mini(sa.length(), sb.length()) and sa[i] == sb[i]: i += 1
		print("[xcheck-diff] %s @%d nat=%s tr=%s" % [name, i, sa.substr(maxi(0, i - 40), 120), sb.substr(maxi(0, i - 40), 120)])

static func _cap_rigs(scr_path: String):
	var P = J.G.Puppet; var orig = P.addRigs; var got = [null]
	P["addRigs"] = func(_t, a): got[0] = JSON.parse_string(JSON.stringify(a[0])); return null
	var m = load(scr_path).new(); _keep_alive.append(m); m.run(null)
	P["addRigs"] = orig
	return got[0]

func data(_t) -> void:
	mod = "l5_data"
	var tr = load_trans("limbdata", ["LIMBS_DATA"])
	eqv("LIMBS_DATA", J.G.LIMBS_DATA, tr.LIMBS_DATA)
	eqv("rigs", _cap_rigs("res://native/rigs.gd"), _cap_rigs("res://jsgen/rigs.gd"))
	eqv("DAILY.keys", J.G.DAILY.keys().size() > 50, true)
	eqv("MOVES.keys", J.G.MOVES.keys().size() > 20, true)
	print("[xc] DAILY=%d MOVES=%d" % [J.G.DAILY.size(), J.G.MOVES.size()])
	_report()

# ---- 繪畫對照：兩邊畫入 Recorder，逐條指令比 ----
static func _r(v) -> String:
	match typeof(v):
		TYPE_FLOAT: return str(snappedf(v, 0.01))
		TYPE_INT: return str(v)
		TYPE_VECTOR2: return "(%s,%s)" % [_r(v.x), _r(v.y)]
		TYPE_RECT2: return "[%s %s]" % [_r(v.position), _r(v.size)]
		TYPE_COLOR: return "#%s" % v.to_html()
		TYPE_TRANSFORM2D: return "T(%s %s %s)" % [_r(v.x), _r(v.y), _r(v.origin)]
		TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_ARRAY:
			var o = []
			for x in v: o.append(_r(x))
			return "{" + ",".join(o) + "}"
		TYPE_OBJECT:
			if v == null: return "null"
			if v is Resource and v.resource_path != "": return v.resource_path.get_file()
			if v is Recorder: return "REC" + str(v.cmds.size())
			return v.get_class() + str(v.get_instance_id())
	return str(v)

static func rec_sig(fn: Callable) -> Array:
	var r = Recorder.new(); var c = Ctx.new(r)
	var ret = fn.call(c)
	var out = []
	for cmd in r.cmds: out.append(_r(cmd))
	out.append("RET:" + _r(ret) if not (ret is Dictionary) else "RET:" + JSON.stringify(ret))
	return out

func draw_eq(name: String, fa: Callable, fb: Callable) -> void:
	var a = rec_sig(fa); var b = rec_sig(fb)
	if a == b: ok += 1; return
	bad += 1
	if bad > 25: return
	var i = 0
	while i < mini(a.size(), b.size()) and a[i] == b[i]: i += 1
	print("[xcheck-diff] %s n=%d/%d @%d\n   nat=%s\n   tr =%s" % [name, a.size(), b.size(), i, a[i].substr(0, 260) if i < a.size() else "-", b[i].substr(0, 260) if i < b.size() else "-"])

func limbs(_t) -> void:
	mod = "limbs"
	var tr = load_trans("limbs", ["Limbs"]).Limbs; var nat = J.G.Limbs
	var chars = J.G.LIMBS_DATA.chars.keys()
	for k in chars:
		for f in ["has"]: check("Limbs", nat, tr, f, [k])
		for pose in [null, "windup", "strike", "follow", "recover", "chop", "hammer", "walk"]:
			for p in [0.0, 0.3, 0.5, 0.9]: check("Limbs", nat, tr, "stateOf", [k, pose, p])
		check("Limbs", nat, tr, "weaponOf", [k, null])
		if not J.t(J.mc(nat, "has", [k])): continue
		for pose in ["windup", "strike", "recover", "chop", "walk"]:
			for fr in [false, true]:
				var o = {"pose": pose, "pt": 0.37, "t": 1.7, "walk": pose == "walk"}
				var mp = {"y": -0.01, "head": 0.1}
				draw_eq("Limbs.draw %s %s %s" % [k, pose, fr], func(c): return J.mc(nat, "draw", [c, k, 100.0, 200.0, 60.0, o.duplicate(), fr, mp.duplicate()]),
					func(c): return J.mc(tr, "draw", [c, k, 100.0, 200.0, 60.0, o.duplicate(), fr, mp.duplicate()]))
	check("Limbs", nat, tr, "weaponOf", ["afu", "iron_chain"])
	draw_eq("Limbs.draw chain", func(c): return J.mc(nat, "draw", [c, "afu", 0.0, 0.0, 60.0, {"pose": "strike", "pt": 0.6, "t": 1.0, "weapon": "iron_chain"}, true, {}]),
		func(c): return J.mc(tr, "draw", [c, "afu", 0.0, 0.0, 60.0, {"pose": "strike", "pt": 0.6, "t": 1.0, "weapon": "iron_chain"}, true, {}]))
	_report()

func near(name: String, a, b, tol := 1e-6) -> void:
	var good = true
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size(): good = false
		else:
			for k in b:
				if not a.has(k): good = false; break
				var x = a[k]; var y = b[k]
				if (x is float or x is int) and (y is float or y is int):
					if absf(float(x) - float(y)) > tol * maxf(1.0, absf(float(y))): good = false; break
				elif JSON.stringify(x) != JSON.stringify(y): good = false; break
	else: good = JSON.stringify(a) == JSON.stringify(b)
	if good: ok += 1
	else:
		bad += 1
		if bad <= 25: print("[xcheck-diff] %s\n   nat=%s\n   ref=%s" % [name, JSON.stringify(a).substr(0, 300), JSON.stringify(b).substr(0, 300)])

func meshanim(_t) -> void:
	mod = "meshanim"
	var nat = J.G.MeshAnim
	var ref = JSON.parse_string(FileAccess.get_file_as_string("res://tools/tests/mesh_anim_ref.json"))
	for e in ref.anim: near("ANIM.%s%s" % [e[0], JSON.stringify(e[1])], J.cl(nat.ANIM[e[0]], null, e[1]), e[2])
	for e in ref.mk: near("mk " + JSON.stringify(e[0]), J.mc(nat, "mk", [e[0]]), e[1])
	var tr = load_trans("meshanim", ["MeshAnim"]).MeshAnim
	# RIG：轉譯版載入時嘅 RIG（之後其他模塊加嘅唔計）同原生載入時一樣
	var base = JSON.parse_string(FileAccess.get_file_as_string("res://data/meshanim_rig.json"))
	for k in base.RIG: near("RIG." + k, tr.RIG.get(k), base.RIG[k])
	near("NATIVE_R", tr.NATIVE_R, base.NATIVE_R)
	for id in ["afu", "eguiking", "xiaozhi", "egui", "npc_ken", "laojiang", "pontianak"]:
		check("MeshAnim", nat, tr, "has", [id])
		for fr in [false, true]:
			var pz = nat.ANIM.windup.call(null, [0.4, 1.3, id])
			draw_eq("draw %s %s" % [id, fr], func(c): return J.mc(nat, "draw", [c, id, 50.0, 120.0, 70.0, pz.duplicate(), fr]),
				func(c): return J.mc(tr, "draw", [c, id, 50.0, 120.0, 70.0, pz.duplicate(), fr]))
	draw_eq("drawBody afu", func(c): return J.mc(nat, "drawBody", [c, "afu", "afu__body", 60.0, {"y": -0.02, "head": 0.1}]),
		func(c): return J.mc(tr, "drawBody", [c, "afu", "afu__body", 60.0, {"y": -0.02, "head": 0.1}]))
	_report()

func n30_data(_t) -> void:
	mod = "n30_data"
	var nat = J.G.N30W
	var snap = {"GH": {}, "SK": {}, "EN": {}}
	for k in J.G.N30_G: snap.GH[k] = J.G.GHOSTS[k].duplicate(true); snap.SK[k] = J.G.SKILLS[k].duplicate(true); snap.EN[k] = J.G.ENEMY_T[k].duplicate(true)
	var natd = {"S": J.G.N30_SITES.duplicate(true), "T": J.G.N30_TIER.duplicate(true), "G": J.G.N30_G.duplicate(true)}
	var tr = load_trans("n30_data", ["N30W", "N30_SITES", "N30_TIER", "N30_G", "N30G"])
	eqv("N30_SITES", natd.S, tr.N30_SITES); eqv("N30_TIER", natd.T, tr.N30_TIER); eqv("N30_G", natd.G, tr.N30_G)
	for k in tr.N30_G:
		eqv("GHOSTS." + k, snap.GH[k], J.G.GHOSTS[k]); eqv("SKILLS." + k, snap.SK[k], J.G.SKILLS[k]); eqv("ENEMY_T." + k, snap.EN[k], J.G.ENEMY_T[k])
	var trw = tr.N30W
	check("N30W", nat, trw, "ids", [])
	for k in tr.N30_G:
		for f in ["owned", "open", "where", "stageOf"]: check("N30W", nat, trw, f, [k])
	var S = J.G.S
	var keep = S.duplicate(true)
	# 唔同進度：清關／等級
	for case in [{}, {"1-3": true}, {"1-3": true, "3-3": true, "2-3": true}, {"1-3": true, "3-3": true, "5-3": true, "2-3": true, "4-3": true}]:
		S["cleared"] = case.duplicate(); S.erase("n30")
		var a = J.mc(nat, "selectHtml", []); S.erase("n30")
		var b = J.mc(trw, "selectHtml", [])
		eqv("selectHtml " + str(case.keys()), a, b)
		S.erase("n30"); var r1 = J.mc(nat, "roadToday", []); S.erase("n30"); var r2 = J.mc(trw, "roadToday", [])
		eqv("roadToday " + str(case.keys()), r1, r2)
	for k in S.keys(): S.erase(k)
	for k in keep: S[k] = keep[k]
	_report()

# art：原生 core/art.gd（autoload Art）同轉譯版 ART 逐個繪畫函數比（未有 native/art.gd 時 J.G.ART 就係轉譯版）
func art(_t) -> void:
	mod = "art"
	var A = Engine.get_main_loop().root.get_node("Art"); var tr = J.G.ART
	var types = ["afu", "xiaozhi", "eguiking", "egui", "toyol", "pocong", "penanggal", "npc_ken", "npc_boss", "laojiang", "n30_kappa", "huang", "baiwu", "youhun"]
	for k in types:
		for o in [{"t": 1.3}, {"t": 0.7, "walk": true}, {"t": 2.0, "pose": "windup", "pt": 0.5}, {"t": 2.0, "pose": "strike", "pt": 0.5}, {"t": 1.0, "hurt": true}, {"t": 1.0, "flip": true, "alpha": 0.6}, {"t": 1.0, "pose": "down", "pt": 0.5}, {"t": 0.3, "pose": "chop", "pt": 0.4}]:
			draw_eq("drawChar %s %s" % [k, JSON.stringify(o)], func(c): A.draw_char(c, k, 100.0, 200.0, 0.8, o.duplicate()); return null,
				func(c): J.mc(tr, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null)
	for id in ["house", "wood", "rice", "plank", "bun", "store", "home", "camp", "altar", "furnace"]:
		for lv in [0.0, 1.0, 3.0]:
			draw_eq("drawBuilding %s %s" % [id, lv], func(c): A.draw_building(c, id, 100.0, 200.0, lv, 1.2, null); return null,
				func(c): J.mc(tr, "drawBuilding", [c, id, 100.0, 200.0, lv, 1.2, null]); return null)
	for kind in ["grave", "post", "banana", "scarecrow", "willo", "webTL", "webTR", "offer"]:
		draw_eq("drawDecor " + kind, func(c): A.draw_decor(c, kind, 50.0, 60.0, 1.7); return null, func(c): J.mc(tr, "drawDecor", [c, kind, 50.0, 60.0, 1.7]); return null)
	for args in [[3, 1.2, false, false, 0], [0, 2.0, true, true, 1], [2, 0.5, false, true, 2]]:
		draw_eq("drawTree %s" % str(args), func(c): A.draw_tree(c, 80.0, 90.0, args[0], args[1], args[2], args[3], args[4]); return null,
			func(c): J.mc(tr, "drawTree", [c, 80.0, 90.0, float(args[0]), args[1], args[2], args[3], float(args[4])]); return null)
	for ripe in [0.0, 0.5, 1.0, true, false]:
		draw_eq("drawPaddy %s" % str(ripe), func(c): A.draw_paddy(c, 30.0, 40.0, ripe, 1.0, 0); return null, func(c): J.mc(tr, "drawPaddy", [c, 30.0, 40.0, ripe, 1.0, 0.0]); return null)
	draw_eq("drawGate", func(c): A.draw_gate(c, 10.0, 20.0, 1.0); return null, func(c): J.mc(tr, "drawGate", [c, 10.0, 20.0, 1.0]); return null)
	draw_eq("drawSite", func(c): A.draw_site(c, 10.0, 20.0, "空地"); return null, func(c): J.mc(tr, "drawSite", [c, 10.0, 20.0, "空地"]); return null)
	for args in [[1.0, 0.3, 1.0, false], [0.8, 2.1, -1.0, true]]:
		draw_eq("drawCrow %s" % str(args), func(c): A.draw_crow(c, 5.0, 6.0, args[0], args[1], args[2], args[3]); return null, func(c): J.mc(tr, "drawCrow", [c, 5.0, 6.0, args[0], args[1], args[2], args[3]]); return null)
	draw_eq("el", func(c): A.el(c, 1.0, 2.0, 3.0, 4.0, "#ff0000", "#000000", 2.0); return null, func(c): J.mc(tr, "el", [c, 1.0, 2.0, 3.0, 4.0, "#ff0000", "#000000", 2.0]); return null)
	draw_eq("rr", func(c): A.rr(c, 1.0, 2.0, 30.0, 40.0, 5.0, "#ff0000", "#000000", 2.0); return null, func(c): J.mc(tr, "rr", [c, 1.0, 2.0, 30.0, 40.0, 5.0, "#ff0000", "#000000", 2.0]); return null)
	for k in types: check("ART", {"hasRig": func(_t, a): return A.char_h(J.str(a[0])) > 0 and MeshAnim.has(J.str(a[0]))}, tr, "hasRig", [k])
	near("CHAR_H", A.CHAR_H, tr.CHAR_H); near("SOLID", A.SOLID, tr.SOLID)
	_report()

func n30_rigs(_t) -> void:
	mod = "n30_rigs"
	var ref = JSON.parse_string(FileAccess.get_file_as_string("res://tools/tests/n30_rigs_ref.json"))
	var RIG = J.G.MeshAnim.RIG
	for id in ref.IDS:
		var R = RIG[id].duplicate(); R.erase("tweak")
		near("RIG." + id, R, ref.rig[id])
		near("CHAR_H." + id, J.G.ART.CHAR_H.get(id), ref.CH.get(id))
		near("SOLID." + id, J.G.ART.SOLID.get(id), ref.SO.get(id))
	for k in ref.NR: near("NATIVE_R." + k, J.G.MeshAnim.NATIVE_R.get(k), ref.NR[k])
	near("IDS", J.G.N30.IDS, ref.IDS)
	for e in ref.names: near("name " + e[0], J.mc(J.G.N30, "name", [e[0]]), e[1])
	for e in ref.tw:
		var pz = J.cl(J.G.MeshAnim.ANIM.idle, null, [e[1].t])
		J.cl(RIG[e[0]].tweak, null, [pz, e[1].duplicate()])
		near("tweak %s %s" % [e[0], JSON.stringify(e[1])], pz, e[2])
	_report()
