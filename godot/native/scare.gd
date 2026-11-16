# 原生改寫自 scare.js（回陽間・夜班嚇人主體）——分段進行（同 L2 game／L3 street 一樣做法）
# 做法：先跑轉譯版（jsgen/scare.gd）建好全部全局（Scare、SCARE_PROPS、SCARE_SITES…），再逐段將 Scare 嘅方法換成原生版本。
#   第一段（呢度）：鏡頭／座標（viewW、clampCam、camRoom、roomOf、sameRoom、onScreen、bgScale、pt、depth、persp、bgAR、hhF、hh、office）、
#                  星星（migrate、starsOf）、班表隨機數（rng、U、rnd）、位置判斷（exitPt、present、sitting、viaElev、inDoor、walkBlocked、busy、freeSpot）、
#                  視線（tagExt、inBeam、groupRoom、inGroup、propOK、gpq、ghostType、headsDown、watching、sees、witnesses、hearers、workOf）
#   之後：移動／班表（moveNpc、planMove…）、出招（useProp、hit、perceive…）、畫（draw…）、開局／收工
# 規矩：方法一律掛返喺 Scare 物件上面（func(this_, a)），轉譯版其他方法經 J.mc(this, …) 叫到原生版
extends RefCounted

const PANO_ZOOM := 0.72
const SEE_DIST := 0.7
static var _trans = null
static var ORIG := {}   # 覆蓋之前嘅轉譯版方法（對照測試用）

static func _g(n: String): return J.G.get(n)
static func n_(v) -> float: return J.num(v)
static func or_(v, d: float) -> float: return J.num(v) if J.t(v) else d
static func gp(o, k): return J.gp(o, k)
static func hyp(a: float, b: float) -> float: return sqrt(a * a + b * b)
static func jround(x: float) -> float: return floor(x + 0.5)
static func OM(): return _g("OFFMAP")
static func room_at(x): return J.cl(J.gp(OM(), "roomAt"), null, [x])
static func npcs(Sc) -> Array: return J.iter(gp(Sc, "npcs"))
static func D(n): return gp(n, "d")
static func site(Sc): return gp(Sc, "site")
static func pano(Sc) -> bool: return J.t(gp(site(Sc), "pano"))

# ---------------- 鏡頭／座標 ----------------
static func bg_scale(Sc) -> Dictionary:
	var W = or_(gp(Sc, "W"), 390.0); var H = or_(gp(Sc, "H"), 580.0)
	if J.t(site(Sc)) and pano(Sc):
		var iw = n_(gp(OM(), "PXU")); var ih = n_(gp(OM(), "SH"))
		var s = maxf(H / ih * PANO_ZOOM, W / (n_(gp(OM(), "WW")) * iw))
		return {"s": s, "iw": iw, "ih": ih, "ox": -or_(gp(Sc, "camX"), 0.0) * iw * s, "oy": H - ih * s}
	var img = J.gp(_g("SPR"), "bg_" + J.str(gp(site(Sc), "bg")))
	var iw2 = or_(gp(img, "naturalWidth"), 768.0) if J.t(img) else 768.0
	var ih2 = or_(gp(img, "naturalHeight"), 1152.0) if J.t(img) else 1152.0
	var s2 = maxf(W / iw2, H / ih2)
	return {"s": s2, "iw": iw2, "ih": ih2, "ox": (W - iw2 * s2) / 2, "oy": H - ih2 * s2}
static func view_w(Sc) -> float: var b = bg_scale(Sc); return or_(gp(Sc, "W"), 390.0) / (b.iw * b.s)
static func clamp_cam(Sc, x: float) -> float: return maxf(0.0, minf(n_(gp(OM(), "WW")) - view_w(Sc), x))
static func cam_room(Sc): return room_at(or_(gp(Sc, "camX"), 0.0) + view_w(Sc) / 2)
static func room_of(Sc, n): return gp(room_at(gp(n, "x")), "k")
static func same_room(Sc, a, b) -> bool: return not pano(Sc) or is_same(room_at(gp(a, "x")), room_at(gp(b, "x")))
static func on_screen(Sc, x: float, m = null) -> bool:
	var mm = 0.25 if m == null else n_(m); var cx = or_(gp(Sc, "camX"), 0.0)
	return x > cx - mm and x < cx + view_w(Sc) + mm
static func pt(Sc, fx: float, fy: float) -> Array:
	var b = bg_scale(Sc); return [fx * b.iw * b.s + b.ox, fy * b.ih * b.s + b.oy]
static func persp(Sc): return gp(site(Sc), "persp") if J.t(site(Sc)) else site(Sc)
static func depth(Sc, y: float) -> float:
	if J.t(site(Sc)) and J.t(gp(site(Sc), "persp")): return hh(Sc, y) / (or_(gp(Sc, "H"), 580.0) * 0.165)
	return 0.72 + 0.5 * maxf(0.0, minf(1.0, (y - 0.55) / 0.42))
static func bg_ar(Sc) -> float: var b = bg_scale(Sc); return b.ih / b.iw
static func hh_f(Sc, y: float) -> float: var p = gp(site(Sc), "persp"); return n_(gp(p, "c")) * (y - n_(gp(p, "hz")))
static func hh(Sc, y: float) -> float:
	if not J.t(persp(Sc)): return or_(gp(Sc, "H"), 580.0) * 0.165 * depth(Sc, y)
	var b = bg_scale(Sc); return b.ih * b.s * hh_f(Sc, y)
static func office(Sc) -> bool:
	return not J.t(gp(Sc, "headless")) and J.t(site(Sc)) and J.str(gp(site(Sc), "layout")) == "office" and _g("OFFICE") != null

# ---------------- 星星 ----------------
static func migrate(_Sc) -> void:
	var S = _g("S")
	if not J.t(S) or not J.t(gp(S, "scare")) or n_(gp(gp(S, "scare"), "fv")) >= 3: return
	var sc = gp(S, "scare"); var best = gp(sc, "best")
	if n_(gp(sc, "fv")) == 2:
		J.sp(sc, "fv", 3.0)
		var a = [0.0, 650.0, 1200.0, 1600.0]; var b = [0.0, 1100.0, 1300.0, 1480.0]
		for k in J.keys(best):
			var v = gp(best, k)
			if not J.t(v) or J.str(k) != "office": continue
			v = n_(v); var i = 0
			while i < 2 and v >= a[i + 1]: i += 1
			J.sp(best, k, jround(b[3] + (v - a[3]) * 0.75) if v >= a[3] else jround(b[i] + (v - a[i]) * (b[i + 1] - b[i]) / (a[i + 1] - a[i])))
		var sv = _g("save"); if sv != null: J.cl(sv, null, [])
		return
	J.sp(sc, "fv", 3.0)
	for k in J.keys(best):
		var st = gp(_g("SCARE_SITES"), k); var v = gp(best, k)
		if not J.t(st) or not J.t(gp(st, "oldStars")) or not J.t(v): continue
		v = n_(v)
		var a = [0.0] + J.iter(gp(st, "oldStars")); var b = [0.0] + J.iter(gp(st, "stars"))
		for i2 in a.size(): a[i2] = n_(a[i2])
		for i2 in b.size(): b[i2] = n_(b[i2])
		var i = 0
		while i < 2 and v >= a[i + 1]: i += 1
		J.sp(best, k, jround(b[3] + (v - a[3]) * (b[3] - b[2]) / (a[3] - a[2])) if v >= a[3] else jround(b[i] + (v - a[i]) * (b[i + 1] - b[i]) / (a[i + 1] - a[i])))
	var sv2 = _g("save"); if sv2 != null: J.cl(sv2, null, [])
static func stars_of(Sc, siteId, v) -> float:
	migrate(Sc); var s = J.iter(gp(gp(_g("SCARE_SITES"), siteId), "stars")); var x = n_(v)
	return 3.0 if x >= n_(s[2]) else (2.0 if x >= n_(s[1]) else (1.0 if x >= n_(s[0]) else 0.0))

# ---------------- 隨機數 ----------------
static func _u(a: int) -> int: return a & 0xFFFFFFFF
static func _imul(a: int, b: int) -> int: return J.i32((a * b) & 0xFFFFFFFF)
static func rng(n) -> float:
	var a: int = J.i32(n_(gp(n, "_seed")) + 0x6D2B79F5); J.sp(n, "_seed", float(a))
	var t: int = _imul(a ^ (_u(a) >> 15), 1 | a)
	t = J.i32(t + _imul(t ^ (_u(t) >> 7), 61 | t)) ^ t
	return float(_u(t ^ (_u(t) >> 14))) / 4294967296.0
static func U(n, a: float, b: float) -> float: return a + (b - a) * rng(n)
static func rnd(n) -> float: return rng(n) if gp(n, "_seed") != null else randf()

# ---------------- 位置 ----------------
static func exit_pt(Sc): var e = gp(site(Sc), "exit"); return e if J.t(e) else [0.905, 0.535]
static func present(Sc, ex) -> float:
	var c = 0
	for m in npcs(Sc):
		if not is_same(m, ex) and not J.t(gp(D(m), "guard")) and not J.t(gp(D(m), "daoshi")) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and not J.t(gp(m, "leaving")): c += 1
	return float(c)
static func sitting(Sc, n) -> bool:
	if J.t(gp(n, "gone")) or J.t(gp(n, "out")) or J.t(gp(n, "fleeing")) or J.str(gp(n, "act")) == "walk": return false
	var act = gp(n, "act")
	if J.t(act) and (J.str(act).begins_with("brk_") or J.str(act) == "notes"): return true
	var MP = _g("MIS_POST")
	return pano(Sc) and J.str(gp(D(n), "k")) == "mis" and hyp(n_(gp(n, "x")) - n_(MP[0]), n_(gp(n, "y")) - n_(MP[1])) < 0.012
static func via_elev(_Sc, _n, x: float, y: float) -> Array:
	var p = []
	var M = gp(OM(), "M"); var MY = gp(OM(), "MY")
	if y < n_(J.cl(MY, null, [0.6])) and x > n_(J.cl(M, null, [0.5])) and x < n_(J.cl(M, null, [0.86])): p.append([J.cl(M, null, [0.80]), J.cl(MY, null, [0.60])])
	return p
static func in_door(Sc, x: float) -> bool:
	if not pano(Sc): return false
	var w = n_(gp(OM(), "WALLW"))
	for v in J.iter(gp(OM(), "WALLS")):
		if x >= (n_(v) - 45) / 1165 and x <= (n_(v) + w + 45) / 1165: return true
	return false
static func walk_blocked(Sc, n, tx: float) -> bool:
	if not pano(Sc): return false
	var a = minf(n_(gp(n, "x")), tx); var b = maxf(n_(gp(n, "x")), tx)
	for r in J.iter(gp(OM(), "ROOMS")):
		if n_(gp(r, "x1")) > a and n_(gp(r, "x0")) < b + 1e-6:
			var c = 0
			for m in npcs(Sc):
				if not is_same(m, n) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and (J.str(gp(m, "act")) == "walk" or (not J.t(gp(D(m), "post")) and not J.t(gp(D(m), "daoshi")) and n_(gp(m, "wait")) < 7)) and is_same(room_at(gp(m, "x")), r): c += 1
			if c >= 2: return true
	return false
static func busy(Sc, n, tx: float) -> bool:
	if not pano(Sc): return false
	for r in [room_at(gp(n, "x")), room_at(tx)]:
		var c = 0
		for m in npcs(Sc):
			if not is_same(m, n) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and J.str(gp(m, "act")) == "walk" and is_same(room_at(gp(m, "x")), r): c += 1
		if c >= 2: return true
	return false
static func free_spot(Sc, n, x: float, y: float) -> Array:
	var occ = []
	for m in npcs(Sc):
		if is_same(m, n) or J.t(gp(m, "gone")) or J.t(gp(m, "out")) or J.t(gp(D(m), "daoshi")): continue
		occ.append([n_(gp(m, "x")), n_(gp(m, "y"))])
		var st = gp(m, "step")
		if J.t(st) and not J.t(gp(st, "arrived")): occ.append([n_(gp(st, "x")), n_(gp(st, "y"))])
		var po = gp(D(m), "post")
		if J.t(po) and not J.t(gp(D(m), "guard")): occ.append([n_(po[0]), n_(po[1])])
	var best = [x, y]
	for dx in [0.0, 0.14, -0.14]:
		var xx = x + dx; var hit = false
		for p in occ: if absf(p[0] - xx) < 0.13 and absf(p[1] - y) < 0.3: hit = true; break
		if not hit: best = [xx, y]; break
	return best

# ---------------- 視線 ----------------
static func tag_ext(Sc, n) -> float:
	return 16.0 if is_same(n, gp(Sc, "sel")) or (n_(gp(n, "mocked")) > 0 and not J.t(gp(D(n), "guard"))) else 0.0
static func in_beam(Sc, g, x: float, y: float) -> bool:
	if J.str(gp(g, "act")) == "doze": return false
	if pano(Sc) and not is_same(room_at(gp(g, "x")), room_at(x)): return false
	var dx = x - n_(gp(g, "x")); var dy = y - (n_(gp(g, "y")) - 0.08)
	if signf(dx) != n_(gp(g, "dir")): return false
	var d = absf(dx); return d < 0.4 and absf(dy) < 0.06 + d * 0.35
static func group_room(Sc):
	if not pano(Sc): return null
	if J.t(gp(Sc, "headless")): return room_of(Sc, gp(Sc, "sel")) if J.t(gp(Sc, "sel")) else "main"
	return gp(cam_room(Sc), "k")
static func in_group(Sc, m, room) -> bool: return not J.t(room) or J.seq(room_of(Sc, m), room)
static func prop_ok(Sc, k, n) -> bool:
	var p = gp(_g("SCARE_PROPS"), k)
	if J.t(gp(p, "group")):
		var rm = group_room(Sc); var pcd = gp(Sc, "pcd")
		if J.t(pcd) and n_(gp(pcd, k)) > 0: return false
		for m in npcs(Sc):
			if not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and not J.t(gp(D(m), "guard")) and in_group(Sc, m, rm): return true
		return false
	if not J.t(n) or J.t(gp(n, "gone")) or J.t(gp(n, "out")) or J.t(gp(n, "fleeing")) or J.t(gp(D(n), "guard")): return false
	var fr = gp(p, "front")
	return n_(gp(p, "r")) == 0 or hyp(n_(gp(n, "x")) - n_(fr[0]), (n_(gp(n, "y")) - n_(fr[1])) * 1.4) < n_(gp(p, "r"))
static func gpq(_Sc, k):
	var GP = _g("GP")
	if GP == null: return 1.0
	if J.str(k) == "afu":
		var S = _g("S"); if not J.t(S): return 1.0
		return J.mc(GP, "grow", [J.mc(gp(S, "ghosts"), "find", [func(_t, a): return J.str(gp(a[0], "k")) == "afu"])])
	return J.mc(GP, "kindGrow", [k])
static func ghost_type(_Sc, k, n):
	var g = gp(_g("SCARE_GHOSTS"), k); var ts = J.iter(gp(g, "types")) if J.t(gp(g, "types")) else [gp(g, "type")]
	if not J.t(n) or ts.size() < 2: return ts[0]
	var wk = J.iter(gp(D(n), "weak")); var im = J.iter(gp(D(n), "immune"))
	for t in ts: if wk.has(t): return t
	for t in ts: if not im.has(t): return t
	return ts[0]
static func heads_down(_Sc, m) -> bool:
	var a = J.str(gp(m, "act"))
	if a in ["work", "mop", "doze", "pack", "read", "notes", "present"]: return true
	var p = gp(D(m), "post")
	return J.t(p) and J.seq(gp(m, "act"), p[2]) and hyp(n_(gp(m, "x")) - n_(p[0]), n_(gp(m, "y")) - n_(p[1])) < 0.015
static func watching(Sc, m) -> bool:
	if J.t(gp(m, "gone")) or J.t(gp(m, "out")) or J.t(gp(m, "fleeing")): return false
	if J.t(gp(D(m), "guard")): return J.str(gp(m, "act")) != "doze"
	if J.t(gp(D(m), "influencer")): return true
	return J.str(gp(m, "act")) == "walk" or or_(gp(m, "lookUp"), 0.0) > 0 or n_(gp(m, "fear")) >= 25 or not heads_down(Sc, m)
static func sees(Sc, m, n) -> bool:
	if is_same(m, n) or not watching(Sc, m) or not same_room(Sc, m, n): return false
	var dx = n_(gp(n, "x")) - n_(gp(m, "x"))
	if hyp(dx, (n_(gp(n, "y")) - n_(gp(m, "y"))) * 1.3) > SEE_DIST: return false
	return dx * n_(gp(m, "dir")) >= -0.03 if (J.str(gp(m, "act")) == "walk" or J.t(gp(D(m), "guard"))) else true
static func witnesses(Sc, n) -> Array:
	var out = []
	for m in npcs(Sc): if sees(Sc, m, n): out.append(m)
	return out
static func hearers(Sc, n) -> Array:
	var out = []
	for m in npcs(Sc):
		if not is_same(m, n) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and same_room(Sc, m, n) and hyp(n_(gp(m, "x")) - n_(gp(n, "x")), n_(gp(m, "y")) - n_(gp(n, "y"))) < 0.75: out.append(m)
	return out
static func work_of(Sc, n):
	return [12.0, 18.0] if J.t(gp(D(n), "guard")) and J.t(gp(Sc, "alert")) else gp(D(n), "work")

static func _a(a: Array, i: int): return a[i] if i < a.size() else null
static func _install() -> void:
	var Sc: Dictionary = J.G["Scare"]
	var M = {
		"viewW": func(t, _a2): return view_w(t),
		"clampCam": func(t, a): return clamp_cam(t, n_(_a(a, 0))),
		"camRoom": func(t, _a2): return cam_room(t),
		"roomOf": func(t, a): return room_of(t, _a(a, 0)),
		"sameRoom": func(t, a): return same_room(t, _a(a, 0), _a(a, 1)),
		"onScreen": func(t, a): return on_screen(t, n_(_a(a, 0)), _a(a, 1)),
		"bgScale": func(t, _a2): return bg_scale(t),
		"pt": func(t, a): return pt(t, n_(_a(a, 0)), n_(_a(a, 1))),
		"depth": func(t, a): return depth(t, n_(_a(a, 0))),
		"persp": func(t, _a2): return persp(t),
		"bgAR": func(t, _a2): return bg_ar(t),
		"hhF": func(t, a): return hh_f(t, n_(_a(a, 0))),
		"hh": func(t, a): return hh(t, n_(_a(a, 0))),
		"office": func(t, _a2): return office(t),
		"migrate": func(t, _a2): migrate(t); return null,
		"starsOf": func(t, a): return stars_of(t, _a(a, 0), _a(a, 1)),
		"rng": func(_t, a): return rng(_a(a, 0)),
		"U": func(_t, a): return U(_a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"rnd": func(_t, a): return rnd(_a(a, 0)),
		"exitPt": func(t, _a2): return exit_pt(t),
		"present": func(t, a): return present(t, _a(a, 0)),
		"sitting": func(t, a): return sitting(t, _a(a, 0)),
		"viaElev": func(t, a): return via_elev(t, _a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"inDoor": func(t, a): return in_door(t, n_(_a(a, 0))),
		"walkBlocked": func(t, a): return walk_blocked(t, _a(a, 0), n_(_a(a, 1))),
		"busy": func(t, a): return busy(t, _a(a, 0), n_(_a(a, 1))),
		"freeSpot": func(t, a): return free_spot(t, _a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"tagExt": func(t, a): return tag_ext(t, _a(a, 0)),
		"inBeam": func(t, a): return in_beam(t, _a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"groupRoom": func(t, _a2): return group_room(t),
		"inGroup": func(t, a): return in_group(t, _a(a, 0), _a(a, 1)),
		"propOK": func(t, a): return prop_ok(t, _a(a, 0), _a(a, 1)),
		"gpq": func(t, a): return gpq(t, _a(a, 0)),
		"ghostType": func(t, a): return ghost_type(t, _a(a, 0), _a(a, 1)),
		"headsDown": func(t, a): return heads_down(t, _a(a, 0)),
		"watching": func(t, a): return watching(t, _a(a, 0)),
		"sees": func(t, a): return sees(t, _a(a, 0), _a(a, 1)),
		"witnesses": func(t, a): return witnesses(t, _a(a, 0)),
		"hearers": func(t, a): return hearers(t, _a(a, 0)),
		"workOf": func(t, a): return work_of(t, _a(a, 0)),
	}
	for k in M: ORIG[k] = Sc.get(k); Sc[k] = M[k]

func run(env) -> void:
	_trans = load("res://jsgen/scare.gd").new()
	_trans.run(env)
	ORIG = {}
	_install()
