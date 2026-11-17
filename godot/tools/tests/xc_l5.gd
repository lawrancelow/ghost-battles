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
static var _deep := true   # 離屏畫布要唔要連內容比
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
			if v is Recorder and not _deep: return "REC"
			if v is Recorder:   # 離屏畫布：連埋入面嘅指令一齊比
				var sub = []
				for c in v.cmds: sub.append(_r(c))
				return "REC" + str(v.cmds.size()) + ":" + str(",".join(sub).hash())
			return v.get_class() + str(v.get_instance_id())
	return str(v)

static func rec_sig(fn: Callable) -> Array:
	var r = Recorder.new(); var c = Ctx.new(r)
	var ret = fn.call(c)
	var out = []
	for cmd in r.cmds: out.append(_r(cmd))
	out.append("RET:" + _r(ret) if not (ret is Dictionary) else "RET:" + JSON.stringify(ret))
	return out

# 攤平：指令 11（貼離屏畫布）遞歸展開，全部轉做螢幕座標；cmd 0（變換）吸收落點座標
static func flat(r: Recorder, M := Transform2D.IDENTITY, alpha := 1.0, out: Array = []) -> Array:
	var cur = Transform2D.IDENTITY
	for c in r.cmds:
		var T = M * cur
		match c[0]:
			0: cur = c[1]
			5, 6:
				var rr: Rect2 = c[2]
				out.append([c[0], c[1], T * rr.position, T * (rr.position + Vector2(rr.size.x, 0)), T * (rr.position + rr.size), c[3] if c[0] == 6 else null, (c[-1] as Color) * Color(1, 1, 1, alpha)])
			10:
				var pp = []
				for q in c[2]: pp.append(T * q)
				var cc = []
				for col in c[3]: cc.append(col * Color(1, 1, 1, alpha))
				out.append([10, c[1], pp, cc, c[4], c[5]])
			4:
				var pp2 = []
				for q in c[1]: pp2.append(T * q)
				out.append([4, pp2, (c[2] as Color) * Color(1, 1, 1, alpha)])
			11:
				if c[1] is Recorder: flat(c[1], T * (c[2] if c.size() > 2 and c[2] is Transform2D else Transform2D.IDENTITY), alpha * (float(c[3]) if c.size() > 3 and (c[3] is float or c[3] is int) else 1.0), out)
			_:
				var e = c.duplicate()
				for i in e.size(): if e[i] is Vector2: e[i] = T * e[i]
				out.append(e)
	return out

static func vnear(a, b, tol := 0.06) -> bool:
	if (a is float or a is int) and (b is float or b is int): return absf(float(a) - float(b)) <= tol
	if a is Vector2 and b is Vector2: return a.distance_to(b) <= tol * 1.5
	if a is Color and b is Color: return absf(a.r - b.r) < 0.01 and absf(a.g - b.g) < 0.01 and absf(a.b - b.b) < 0.01 and absf(a.a - b.a) < 0.01
	if (a is Array or a is PackedVector2Array or a is PackedColorArray or a is PackedInt32Array or a is PackedFloat32Array) and (b is Array or b is PackedVector2Array or b is PackedColorArray or b is PackedInt32Array or b is PackedFloat32Array):
		if a.size() != b.size(): return false
		for i in a.size(): if not vnear(a[i], b[i], tol): return false
		return true
	if a is Transform2D and b is Transform2D: return vnear(a.x, b.x, 0.002) and vnear(a.y, b.y, 0.002) and vnear(a.origin, b.origin, tol)
	return a == b or (a is Object and b is Object and a == b) or str(a) == str(b)

static func diff_path(a, b, path := "") -> String:
	var la = a is Array or a is PackedVector2Array or a is PackedColorArray or a is PackedInt32Array or a is PackedFloat32Array
	var lb = b is Array or b is PackedVector2Array or b is PackedColorArray or b is PackedInt32Array or b is PackedFloat32Array
	if la and lb:
		if a.size() != b.size(): return "%s size %d/%d" % [path, a.size(), b.size()]
		for i in a.size():
			if not vnear(a[i], b[i]): return diff_path(a[i], b[i], path + "/" + str(i))
		return path + " ?"
	return "%s nat=%s tr=%s" % [path, _r(a).substr(0, 120), _r(b).substr(0, 120)]

static func _geo(e):
	var o = []
	if e is Array:
		for x in e:
			if x is Color: continue
			if x is Array:
				var keep = true
				for y in x: if not (y is Color): keep = false
				if keep and x.size() > 0: continue
			o.append(x)
	return o

func special_eq(name: String, fa: Callable, fb: Callable) -> void:
	var a: Array = flat_sig(fa)[0]; var b: Array = flat_sig(fb)[0]
	if b.size() == a.size() + 1 and b[-1] is Array and b[-1][0] == 10: b.pop_back()   # 網頁版 destination-out 漸層
	var ga = []; var gb = []
	for e in a: ga.append(_geo(e))
	for e in b: gb.append(_geo(e))
	if vnear(ga, gb): ok += 1; return
	bad += 1
	if bad <= 25: print("[xcheck-flat] %s special n=%d/%d %s" % [name, a.size(), b.size(), diff_path(ga, gb)])

var ret_bool_only := false
var _pk := {}
static func flat_sig(fn: Callable) -> Array:
	var r = Recorder.new(); var c = Ctx.new(r)
	var ret = fn.call(c)
	return [flat(r), ret]


# 原生帶狀（舌頭、鏈、頭髮）用一塊網格畫（指令 10），網頁版切成一連串小圖（5/6）：連續 ≥3 張同圖嘅小圖收埋做外框，同網格外框比
static func _bb(pts: Array) -> Rect2:
	var r = Rect2(pts[0], Vector2.ZERO)
	for q in pts: r = r.expand(q)
	return r
static func _tex_of(e) -> String:
	return e[1].resource_path.get_file() if e[1] is Resource else str(e[1])
static func rib_norm(fl: Array, tr_side: bool) -> Array:
	var out = []; var i = 0
	while i < fl.size():
		var e = fl[i]
		if tr_side and (e[0] == 5 or e[0] == 6):
			var j = i
			while j < fl.size() and (fl[j][0] == 5 or fl[j][0] == 6) and _tex_of(fl[j]) == _tex_of(e): j += 1
			if j - i >= 3:
				var pts = []
				for q in range(i, j):
					var f = fl[q]; pts.append(f[2]); pts.append(f[3]); pts.append(f[4]); pts.append(f[2] + f[4] - f[3])
				out.append(["BB", _bb(pts)]); i = j; continue
		out.append(e); i += 1
	return out
static func rib_eq(A: Array, B: Array) -> bool:
	var a = rib_norm(A, false); var b = rib_norm(B, true)
	var i = 0; var j = 0
	while i < a.size() and j < b.size():
		if b[j][0] is String and b[j][0] == "BB":
			# 網格（可能幾塊）對一串小圖
			var rb: Rect2 = b[j][1]; var pts = []
			while i < a.size() and a[i][0] is int and a[i][0] == 10:
				pts.append_array(a[i][2]); i += 1
				if i < a.size() and j + 1 < b.size() and vnear(a[i], b[j + 1]): break
			if pts.is_empty(): return false
			var ra = _bb(pts); var tol = maxf(3.0, 0.1 * maxf(rb.size.x, rb.size.y))
			# 網頁版係「clip 三角形＋貼成張圖」，Godot 轉譯版 Ctx 嘅 drawImage 唔理 clip（會貼晒成張圖）；原生用網格先啱。
			# 所以只要求：外框大致一樣，或者網格落喺嗰串（未裁）圖入面
			var inside = rb.grow(tol).encloses(ra)
			if not inside and (ra.position.distance_to(rb.position) > tol or ra.end.distance_to(rb.end) > tol):
				print("[xc-rib] bbox nat=%s tr=%s" % [ra, rb]); return false
			j += 1
			continue
		if not vnear(a[i], b[j]): return false
		i += 1; j += 1
	return i == a.size() and j == b.size()

func draw_eq(name: String, fa: Callable, fb: Callable) -> void:
	var a = rec_sig(fa); var b = rec_sig(fb)
	if a == b: ok += 1; return
	# 覆核：攤平到螢幕座標再用容差比（離屏畫布錄法唔同、浮點 0.0x 像素差唔算錯）
	var fa2 = flat_sig(fa); var fb2 = flat_sig(fb)
	var rfa = fa2[1]; var rfb = fb2[1]
	if ret_bool_only: rfa = (rfa is bool and rfa == false); rfb = (rfb is bool and rfb == false)   # 招式：呼叫端只睇係咪 false（網頁版冇回傳＝undefined）
	var req = str(rfa) == str(rfb) or vnear(rfa, rfb)
	if req and (vnear(fa2[0], fb2[0]) or rib_eq(fa2[0], fb2[0])): ok += 1; return
	bad += 1
	var kk = name.split(" ")[0]; _pk[kk] = _pk.get(kk, 0) + 1
	if bad <= 25 or _pk[kk] == 1:
		var fl_a: Array = fa2[0]; var fl_b: Array = fb2[0]; var j = 0
		while j < mini(fl_a.size(), fl_b.size()) and vnear(fl_a[j], fl_b[j]): j += 1
		print("[xcheck-flat] %s flat n=%d/%d @%d %s" % [name, fl_a.size(), fl_b.size(), j, diff_path(fl_a[j], fl_b[j]) if j < mini(fl_a.size(), fl_b.size()) else "-"])
	if bad > 25 and _pk[kk] != 1: return
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
# SPECIAL（Penanggal／Pocong／Toyol 網格）有狀態（彈簧、時鐘）：對照時換做固定樁，只比分派同參數
func _dev_cmds(cmds: Array, M: Transform2D) -> Array:
	var cur = Transform2D.IDENTITY; var out = []
	for c in cmds:
		match c[0]:
			0: cur = c[1]
			5, 6:
				var r: Rect2 = c[2]; var T2 = M * cur
				out.append(_r([c[0], c[1], T2 * r.position, T2 * (r.position + Vector2(r.size.x, 0)), T2 * (r.position + r.size), c[3] if c[0] == 6 else null, c[-1]]))
			10:
				var pp = PackedVector2Array()
				for q in c[2]: pp.append(M * cur * q)
				out.append(_r([10, c[1], pp, c[3], c[4], c[5]]))
			4:
				var pp2 = PackedVector2Array()
				for q in c[1]: pp2.append(M * cur * q)
				out.append(_r([4, pp2, c[2]]))
			_: out.append(_r(c))
	return out

# 飄浮鬼（冇骨架）：網頁版經暫存畫布＋destination-out 擦淡；原生版逐點乘透明度。比：外面嘅指令、畫入暫存畫布嘅內容（換返世界座標）、最後一層透明度
func ghost_eq(name: String, A, nat, tr, k: String, o: Dictionary) -> void:
	var ra = Recorder.new(); var ca = Ctx.new(ra); A.last_fade_raw = null; J.mc(nat, "drawChar", [ca, k, 100.0, 200.0, 0.8, o.duplicate()])
	var rb = Recorder.new(); var cb = Ctx.new(rb); J.mc(tr, "drawChar", [cb, k, 100.0, 200.0, 0.8, o.duplicate()])
	var ia = -1; var ib = -1
	for i in ra.cmds.size(): if ra.cmds[i][0] == 11: ia = i
	for i in rb.cmds.size(): if rb.cmds[i][0] == 11: ib = i
	var pre_a = []; var pre_b = []
	for i in maxi(ia, 0): pre_a.append(_r(ra.cmds[i]))
	for i in maxi(ib, 0): pre_b.append(_r(rb.cmds[i]))
	if ia < 0 or ib < 0 or A.last_fade_raw == null: eqv(name + " 有暫存層", [ia >= 0, A.last_fade_raw != null], [ib >= 0, true]); return
	eqv(name + " 外層", pre_a, pre_b)
	var na = _dev_cmds(A.last_fade_raw.cmds, ra.cmds[ia][2])
	var nb = _dev_cmds(rb.cmds[ib][1].cmds, rb.cmds[ib][2])
	# 網頁版暫存畫布最尾係 destination-out 漸層（一個 tris）；原生版冇
	if nb.size() == na.size() + 1 and String(nb[-1]).begins_with("{10"): nb.pop_back()
	eqv(name + " 內容", na, nb)
	eqv(name + " 透明度", _r(ra.cmds[ia][3]), _r(rb.cmds[ib][3]))

# 要 GB_NAT_EXTRA=art（或已啟用）：nat = 原生 J.G.ART；tr = 新載入嘅轉譯版 ART，補返執行時加嘅 CHAR_H／SOLID，再套 scene.js 蠟筆畫覆蓋
func _fresh_art():
	var nat = J.G.ART
	var tr = load_trans("art", ["ART"]).ART
	for k in nat.CHAR_H: tr.CHAR_H[k] = nat.CHAR_H[k]
	for k in nat.SOLID: tr.SOLID[k] = nat.SOLID[k]
	var keep_sc = J.G.get("SCENE"); J.G["ART"] = tr
	var m = load("res://jsgen/scene.gd").new(); _keep_alive.append(m); m.run(null)
	J.G["ART"] = nat; J.G["SCENE"] = keep_sc
	return tr

func art(_t) -> void:
	mod = "art"
	var A = Engine.get_main_loop().root.get_node("Art"); var nat = J.G.ART; var tr = _fresh_art()
	print("[xc] art native=", nat.get("drawChar") is Callable and str(nat.drawChar.get_object()).contains("art.gd"))
	var SP = J.G.get("SPECIAL"); var sp_orig = SP.draw
	SP["draw"] = func(_t2, a):
		var c = a[0]; c.fillStyle = "#123456"; c.fillRect(J.num(a[2]), J.num(a[3]), J.num(a[4]) * 10, 7.0)
		c.fillStyle = "#654321"; c.fillRect(0.0, 0.0, J.num(J.gp(a[5], "t")), J.num(J.gp(a[5], "pt")) + (1.0 if J.t(J.gp(a[5], "flip")) else 0.0) + (2.0 if J.t(J.gp(a[5], "walk")) else 0.0)); return null
	var types = ["afu", "xiaozhi", "eguiking", "egui", "toyol", "pocong", "penanggal", "npc_ken", "npc_boss", "laojiang", "n30_kappa", "huang", "baiwu", "youhun", "shuigui", "mengpo", "zombie", "npc_auntie"]
	var cases = [{"t": 1.3}, {"t": 0.7, "walk": true}, {"t": 2.0, "pose": "windup", "pt": 0.5}, {"t": 2.0, "pose": "strike", "pt": 0.5}, {"t": 2.0, "pose": "recover", "pt": 0.3, "tdx": 60.0, "tdy": 0.0}, {"t": 1.0, "hurt": true}, {"t": 1.0, "flip": true, "alpha": 0.6}, {"t": 1.0, "pose": "down", "pt": 0.5}, {"t": 1.0, "pose": "air", "pt": 0.5}, {"t": 0.3, "pose": "chop", "pt": 0.4}, {"t": 0.3, "pose": "hammer", "pt": 0.8}, {"t": 0.3, "pose": "reap", "pt": 0.2}, {"t": 0.3, "pose": "knead", "pt": 0.2}, {"t": 0.3, "pose": "proud"}, {"t": 0.3, "pose": "cast", "pt": 0.6}, {"t": 0.3, "pose": "faint", "pt": 0.6}, {"t": 0.3, "pose": "scared"}, {"t": 0.3, "pose": "run"}, {"t": 0.3, "atk": true}, {"t": 0.3, "enemy": true, "walk": true}, {"t": 0.5, "shadow": false, "rot": 0.4}]
	for k in types:
		for o in cases:
			if Art.SPECIAL_T.has(k):   # 特殊鬼（樁）：網頁版經暫存畫布＋destination-out 擦淡，原生逐點乘透明度——只比位置
				special_eq("drawChar %s %s" % [k, JSON.stringify(o)], func(c): J.mc(nat, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null,
					func(c): J.mc(tr, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null)
				continue
			draw_eq("drawChar %s %s" % [k, JSON.stringify(o)], func(c): J.mc(nat, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null,
				func(c): J.mc(tr, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null)
	# 平日動作（DAILY）同 tipOut
	for e in [["afu", {"t": 1.0, "act": "yawn", "at": 0.5}], ["npc_ken", {"t": 1.0, "act": "phone", "at": 1.2}], ["xiaozhi", {"t": 1.0, "act": "sweep", "at": 0.7}], ["afu", {"t": 1.0, "act": "zzzz_none"}]]:
		draw_eq("drawChar act %s %s" % e, func(c): J.mc(nat, "drawChar", [c, e[0], 100.0, 200.0, 0.8, e[1].duplicate()]); return null, func(c): J.mc(tr, "drawChar", [c, e[0], 100.0, 200.0, 0.8, e[1].duplicate()]); return null)
	var ta = {"t": 1.0, "pose": "windup", "pt": 0.4, "tipOut": {}}; var tb = {"t": 1.0, "pose": "windup", "pt": 0.4, "tipOut": {}}
	rec_sig(func(c): J.mc(nat, "drawChar", [c, "afu", 100.0, 200.0, 0.8, ta]); return null); rec_sig(func(c): J.mc(tr, "drawChar", [c, "afu", 100.0, 200.0, 0.8, tb]); return null)
	near("tipOut", ta.tipOut, tb.tipOut)
	var oa = {}; var ob = {}; rec_sig(func(c): J.mc(nat, "drawChar", [c, "afu", 1.0, 2.0, 1.0, oa]); return null); rec_sig(func(c): J.mc(tr, "drawChar", [c, "afu", 1.0, 2.0, 1.0, ob]); return null)
	eqv("o 改動", oa, ob)
	# 冇骨架：飄浮鬼（暫存畫布漸隱）、實體、阿福領帶、冇素材（DRAW.youhun）
	# 註：noMesh 喺全部遊戲原碼都冇設定（遊戲走唔到）；冇素材嘅未知角色（zzz_unknown）亦走唔到——呢度只比有素材嘅鬼
	for k in ["egui", "youhun", "toyol", "shuigui", "baiwu"]:
		for o in [{"t": 1.3, "noMesh": true}, {"t": 0.7, "noMesh": true, "walk": true, "flip": true, "alpha": 0.5}, {"t": 0.2, "noMesh": true, "enemy": true, "rot": 0.3, "atk": true}]:
			ghost_eq("ghost %s %s" % [k, JSON.stringify(o)], A, nat, tr, k, o)
	for k in ["xiaozhi", "pocong", "laojiang", "npc_ken"]:   # afu 有 Puppet（noMesh 遊戲走唔到）
		for o in [{"t": 1.3, "noMesh": true}, {"t": 0.7, "noMesh": true, "walk": true, "flip": true, "work": true}, {"t": 0.2, "noMesh": true, "enemy": true, "rot": 0.3, "atk": true}]:
			draw_eq("drawChar %s %s" % [k, JSON.stringify(o)], func(c): J.mc(nat, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null,
				func(c): J.mc(tr, "drawChar", [c, k, 100.0, 200.0, 0.8, o.duplicate()]); return null)
	SP["draw"] = sp_orig
	for id in ["house", "wood", "rice", "plank", "bun", "store", "home", "camp", "altar", "furnace"]:
		for lv in [0.0, 1.0, 3.0]:
			draw_eq("drawBuilding %s %s" % [id, lv], func(c): J.mc(nat, "drawBuilding", [c, id, 100.0, 200.0, lv, 1.2, null]); return null,
				func(c): J.mc(tr, "drawBuilding", [c, id, 100.0, 200.0, lv, 1.2, null]); return null)
	draw_eq("drawBuilding furnace 火", func(c): J.mc(nat, "drawBuilding", [c, "furnace", 100.0, 200.0, 2.0, 1.2, true]); return null, func(c): J.mc(tr, "drawBuilding", [c, "furnace", 100.0, 200.0, 2.0, 1.2, true]); return null)
	for kind in ["grave", "post", "banana", "scarecrow", "willo", "webTL", "webTR", "offer"]:
		draw_eq("drawDecor " + kind, func(c): J.mc(nat, "drawDecor", [c, kind, 50.0, 60.0, 1.7]); return null, func(c): J.mc(tr, "drawDecor", [c, kind, 50.0, 60.0, 1.7]); return null)
	for args in [[3, 1.2, false, false, 0], [0, 2.0, true, true, 1], [2, 0.5, false, true, 2], [1, 0.5, true, true, 5]]:
		draw_eq("drawTree %s" % str(args), func(c): J.mc(nat, "drawTree", [c, 80.0, 90.0, float(args[0]), args[1], args[2], args[3], float(args[4])]); return null,
			func(c): J.mc(tr, "drawTree", [c, 80.0, 90.0, float(args[0]), args[1], args[2], args[3], float(args[4])]); return null)
	for ripe in [0.0, 0.5, 1.0, true, false]:
		draw_eq("drawPaddy %s" % str(ripe), func(c): J.mc(nat, "drawPaddy", [c, 30.0, 40.0, ripe, 1.0, 0.0]); return null, func(c): J.mc(tr, "drawPaddy", [c, 30.0, 40.0, ripe, 1.0, 0.0]); return null)
	draw_eq("drawGate", func(c): J.mc(nat, "drawGate", [c, 10.0, 20.0, 1.0]); return null, func(c): J.mc(tr, "drawGate", [c, 10.0, 20.0, 1.0]); return null)
	draw_eq("drawSite", func(c): J.mc(nat, "drawSite", [c, 10.0, 20.0, "空地"]); return null, func(c): J.mc(tr, "drawSite", [c, 10.0, 20.0, "空地"]); return null)
	for args in [[1.0, 0.3, 1.0, false], [0.8, 2.1, -1.0, true]]:
		draw_eq("drawCrow %s" % str(args), func(c): J.mc(nat, "drawCrow", [c, 5.0, 6.0, args[0], args[1], args[2], args[3]]); return null, func(c): J.mc(tr, "drawCrow", [c, 5.0, 6.0, args[0], args[1], args[2], args[3]]); return null)
	draw_eq("el", func(c): J.mc(nat, "el", [c, 1.0, 2.0, 3.0, 4.0, "#ff0000", "#000000", 2.0]); return null, func(c): J.mc(tr, "el", [c, 1.0, 2.0, 3.0, 4.0, "#ff0000", "#000000", 2.0]); return null)
	draw_eq("rr", func(c): J.mc(nat, "rr", [c, 1.0, 2.0, 30.0, 40.0, 5.0, "#ff0000", "#000000", 2.0]); return null, func(c): J.mc(tr, "rr", [c, 1.0, 2.0, 30.0, 40.0, 5.0, "#ff0000", "#000000", 2.0]); return null)
	draw_eq("el 冇填色", func(c): J.mc(nat, "el", [c, 1.0, 2.0, 3.0, 4.0, "", "#000000", 0.0]); return null, func(c): J.mc(tr, "el", [c, 1.0, 2.0, 3.0, 4.0, "", "#000000", 0.0]); return null)
	draw_eq("poly", func(c): J.mc(nat, "poly", [c, [1.0, 2.0, 30.0, 4.0, 5.0, 60.0], "#ff0000", "#000000"]); return null, func(c): J.mc(tr, "poly", [c, [1.0, 2.0, 30.0, 4.0, 5.0, 60.0], "#ff0000", "#000000"]); return null)
	for col in [null, "#e8e0c8"]:
		draw_eq("lantern %s" % col, func(c): J.mc(nat, "lantern", [c, 10.0, 20.0, 1.3, col]); return null, func(c): J.mc(tr, "lantern", [c, 10.0, 20.0, 1.3, col]); return null)
	draw_eq("sysIcon", func(c): c.drawImage(J.mc(nat, "sysIcon", [40.0]), 0.0, 0.0); return null, func(c): c.drawImage(J.mc(tr, "sysIcon", [40.0]), 0.0, 0.0); return null)
	for e in [["afu", 64.0, null], ["egui", 48.0, null], ["toyol", 40.0, {"flip": true}], ["n30_kappa", 52.0, null]]:   # 冇素材嘅未知角色遊戲走唔到
		draw_eq("portrait %s" % str(e), func(c): c.drawImage(J.mc(nat, "portrait", e.duplicate()), 0.0, 0.0); return null, func(c): c.drawImage(J.mc(tr, "portrait", e.duplicate()), 0.0, 0.0); return null)
	for k in types + ["zzz_unknown", "pg_ji"]: check("ART", nat, tr, "hasRig", [k])
	near("CHAR_H", nat.CHAR_H, tr.CHAR_H); near("SOLID", nat.SOLID, tr.SOLID); near("OUT", nat.OUT, tr.OUT)
	near("keys", nat.keys().size(), tr.keys().size())
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

# ---- 專屬招式：轉譯版 MOVES（moves_chain/beast/spirit + n30_moves）vs 原生（J.G.MOVES，已啟用嘅原生模塊）----
# 兩邊都用同一個 a（type,x,y,s,H,o,faceRight,solid,shadow），畫入 Recorder 逐條比；o 回寫（vic/hitP）都比
static var _tr_moves = null
func _trans_moves() -> Dictionary:
	if _tr_moves != null: return _tr_moves
	var keep = {}
	for g in ["MOVES", "MoveKit", "N30K", "N30M", "jiangshiMove"]: keep[g] = J.G.get(g)
	J.G["MOVES"] = {}
	for m in ["moves_chain", "moves_beast", "moves_spirit", "n30_moves"]:
		var inst = load("res://jsgen/%s.gd" % m).new(); _keep_alive.append(inst); inst.run(null)
	_tr_moves = J.G.MOVES
	for g in keep: J.G[g] = keep[g]
	return _tr_moves

func _mv_arg(k: String, o: Dictionary, fr: bool, c: Ctx) -> Dictionary:
	var A = Engine.get_main_loop().root.get_node("Art")
	var s = 0.9; var solid = A.is_solid(k); var y = 300.0
	var sh = func(_t, a): A.shadow(c, J.num(J.arg(a, 0)), y + 1 * s, s * (J.num(J.arg(a, 1)) if J.t(J.arg(a, 1)) else (1.0 if solid else 0.8))); return null
	return {"type": k, "x": 200.0, "y": y, "s": s, "H": A.char_h(k) * s, "o": o, "faceRight": fr, "solid": solid, "shadow": sh}

func moves(_t) -> void:
	mod = "moves"
	var tr = _trans_moves(); var nat = J.G.MOVES
	var only = OS.get_environment("GB_MV_ONLY")
	var ks = tr.keys(); ks.sort()
	print("[xc] MOVES tr=%d nat=%d" % [tr.size(), nat.size()])
	ret_bool_only = true
	for k in ks:
		if only != "" and not (k in only.split(",")): continue
		if not nat.has(k): eqv("MOVES has " + k, false, true); continue
		if k.begins_with("n30_"): BtN30.ensure_rig(k)
		_deep = k != "npc_boss"   # 陳總嘅字：網頁版用 source-atop 撒顆粒（Godot 畫唔到），另外比字嘅底層
		for pose in ["windup", "strike", "follow", "recover"]:
			for pt in ([0.0, 0.35, 0.7, 1.0] if pose != "follow" else [0.5]):
				for fr in [true, false]:
					for td in [null, 70.0]:
						var o = {"pose": pose, "pt": pt, "t": 1.37}
						if td != null: o["tdx"] = td * (1 if fr else -1); o["tdy"] = -4.0
						var oa = o.duplicate(true); var ob = o.duplicate(true)
						var ra = []; var rb = []
						draw_eq("MOVES.%s %s %s fr=%s td=%s" % [k, pose, pt, fr, td], func(c): ra.append(J.cl(nat[k], null, [c, _mv_arg(k, oa, fr, c)])); return ra[0],
							func(c): rb.append(J.cl(tr[k], null, [c, _mv_arg(k, ob, fr, c)])); return rb[0])
						near("MOVES.%s %s %s o" % [k, pose, pt], oa, ob)
	_deep = true
	ret_bool_only = false
	for k in _pk: print("[xc-key] %s bad=%d" % [k, _pk[k]])
	# 陳總嘅字：原生 = 網頁版去咗 source-atop 嗰兩層（顆粒、高光）
	if only == "" or "npc_boss" in only.split(","):
		var rb = Recorder.new(); var cb = Ctx.new(rb)
		J.cl(tr.npc_boss, null, [cb, _mv_arg("npc_boss", {"pose": "strike", "pt": 0.6, "t": 1.0}, true, cb)])
		var gt = null
		for c in rb.cmds:
			if c[0] == 11 and c[1].width == 168.0: gt = c[1]; break
		var gn = preload("res://game/battle/bt_moves3.gd").glyph("扣", "#ff5a3a", "#ffcf3a").rec
		if gt == null: eqv("glyph 搵到", false, true)
		else:
			var a1 = []; var b1 = []
			for i in gn.cmds.size(): a1.append(_r(gn.cmds[i]) if gn.cmds[i][0] != 11 else "SUB")
			for i in gt.cmds.size(): b1.append(_r(gt.cmds[i]) if gt.cmds[i][0] != 11 else "SUB")
			eqv("glyph 外層", a1, b1)
			var sn = null; var st = null
			for c in gn.cmds: if c[0] == 11: sn = c[1]
			for c in gt.cmds: if c[0] == 11: st = c[1]
			var a2 = []; var b2 = []
			for c in sn.cmds: a2.append(_r(c))
			for i in mini(sn.cmds.size(), st.cmds.size()): b2.append(_r(st.cmds[i]))
			eqv("glyph 字底（網頁版之後係 source-atop 顆粒 %d 條）" % (st.cmds.size() - sn.cmds.size()), a2, b2)
	_report()

# ---- 新鬼平日小動作（n30_daily）----
func n30_daily(_t) -> void:
	mod = "n30_daily"; _pk = {}
	var keep = {}
	for g in ["DAILY", "MOVES", "MoveKit", "N30K", "N30M", "N30D"]: keep[g] = J.G.get(g)
	J.G["DAILY"] = {}; J.G["MOVES"] = {}
	for m in ["moves_chain", "n30_moves", "n30_daily"]:
		var inst = load("res://jsgen/%s.gd" % m).new(); _keep_alive.append(inst); inst.run(null)
	var tr = J.G.DAILY; var trA = J.G.N30D
	for g in keep: J.G[g] = keep[g]
	var nat = J.G.DAILY
	var ks = []
	for k in tr: if String(k).begins_with("n30_"): ks.append(k)
	print("[xc] n30_daily tr=%d" % ks.size())
	eqv("N30D.ACTS", J.G.N30D.ACTS, J.gp(trA, "ACTS"))
	ret_bool_only = true
	for k in ks:
		if not nat.has(k): eqv("DAILY has " + k, false, true); continue
		BtN30.ensure_rig(String(k).split("_")[0] + "_" + String(k).split("_")[1])
		for at in [0.0, 0.37, 0.95, 1.6, 2.45, 3.3]:
			for fr in [true, false]:
				var tp = "n30_" + String(k).split("_")[1]
				var o = {"act": k, "at": at, "t": 1.37}
				var oa = o.duplicate(true); var ob = o.duplicate(true)
				draw_eq("DAILY.%s at=%s fr=%s" % [k, at, fr], func(c): return J.cl(nat[k], null, [c, _mv_arg(tp, oa, fr, c)]),
					func(c): return J.cl(tr[k], null, [c, _mv_arg(tp, ob, fr, c)]))
	ret_bool_only = false
	for k in _pk: print("[xc-key] %s bad=%d" % [k, _pk[k]])
	_report()

# 除錯：列出兩邊指令種類
func dbg(_t) -> void:
	var tr = _trans_moves(); var nat = J.G.MOVES
	for spec in [["heiwu", "windup", 0.0], ["n30_diaosi", "strike", 0.35], ["tianhua", "strike", 0.35], ["pontianak", "strike", 0.35], ["n30_dugui", "strike", 0.7]]:
		var k = spec[0]
		if k.begins_with("n30_"): BtN30.ensure_rig(k)
		for side in [["nat", nat[k]], ["tr", tr[k]]]:
			var r = Recorder.new(); var c = Ctx.new(r); var o = {"pose": spec[1], "pt": spec[2], "t": 1.37}
			var ret = J.cl(side[1], null, [c, _mv_arg(k, o, true, c)])
			var seq = []
			for cmd in r.cmds:
				var d = str(cmd[0])
				if cmd.size() > 1 and cmd[1] is Resource: d += ":" + cmd[1].resource_path.get_file()
				elif cmd.size() > 1 and cmd[1] is Recorder: d += ":REC" + str(cmd[1].cmds.size())
				elif cmd.size() > 1 and cmd[1] is Texture2D: d += ":TEX%dx%d" % [cmd[1].get_width(), cmd[1].get_height()]
				seq.append(d)
			print("[dbg] %s %s ret=%s n=%d %s" % [k, side[0], ret, r.cmds.size(), " ".join(seq).substr(0, 900)])
	_report()
