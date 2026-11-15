# 樓裡有鬼：第二階段原生畫（住客、保安），逐行照 tower.js pplDrawRes／guards 迴圈／PPLFX
#  - 只讀 G，唔改規則數值；畫面外唔畫（保安以前冇裁切）
#  - 少用到嘅部分（對白泡泡、驚嚇條、反應道具）仍叫返 JS
class_name TwDraw2
extends RefCounted

static var _nat := {}
static func natives() -> Dictionary:
	if _nat.is_empty():
		_nat["__nat_twResD"] = func(_t, a): return res_all(a[0], a[1], J.num(a[2]), J.num(a[3]), J.num(a[4]), J.num(a[5]))
		_nat["__nat_twGuardD"] = func(_t, a): return guards_all(a[0], a[1], a[2])
	return _nat

static func n(v) -> float: return 0.0 if v == null else J.num(v)
static func FN(): return J.G.get("TWX").fn
static var CHIBI_K := 1.12
static var _cur_ctx: Ctx = null
static var DBG := 0

# ---- PPLFX ----
static func im(k):
	if k == null: return null
	var I = FN().IMG; var i = I.get(J.str(k))
	if i == null or _w(i) <= 0: return null
	return i
static func has_scared(k: String) -> bool: return k.begins_with("res_") and im(k + "_scared") != null
static func key(k: String, scared: bool) -> String: return k + "_scared" if scared and has_scared(k) else k
static func chibi(k: String) -> bool:
	var i = im(k); return i != null and _w(i) / _h(i) >= 0.42
static func meta(base: String): return FN().META.get(base)
static func hgt(base: String, k2: String, h: float) -> float:
	var m = meta(base)
	return h * (CHIBI_K if chibi(base) else 1.0) * (n(m.s.k) if k2 != base and m != null and m.get("s") != null else 1.0)
static func foot(base: String, k2: String) -> float:
	var m = meta(base)
	if m == null: return 0.0
	if k2 != base: return n(m.s.get("foot")) if m.get("s") != null else 0.0
	return n(m.n.get("foot")) if m.get("n") != null else 0.0

static func _w(i) -> float: return float(i.get_width()) if i is Texture2D else n(J.gp(i, "width"))
static func _h(i) -> float: return float(i.get_height()) if i is Texture2D else n(J.gp(i, "height"))
static func _tex(i) -> Texture2D:
	if i == null: return null
	if i is Texture2D: return i
	if i is Object and i.has_method("js_tex"): return i.js_tex()
	return null

# blit：translate(x,y) rotate scale(flip*sx, sy) drawImage(i,-w/2,-h,w,h)
static func blit(ci: CanvasItem, T: Transform2D, i, x: float, y: float, h: float, flip: bool, rot: float, sx: float, sy: float, alpha: float) -> void:
	var tex = _tex(i)
	if tex == null: return
	var w = h * _w(i) / _h(i)
	var M = T * Transform2D(rot, Vector2(x, y)) * Transform2D(Vector2((-1.0 if flip else 1.0) * sx, 0), Vector2(0, sy), Vector2.ZERO)
	ci.draw_set_transform_matrix(M)
	ci.draw_texture_rect(tex, Rect2(-w / 2, -h, w, h), false, Color(1, 1, 1, alpha))
static func pdraw(ci: CanvasItem, T: Transform2D, base: String, k2: String, x: float, y: float, h: float, flip: bool, rot: float, sx: float, sy: float, tint: float, alpha := 1.0) -> void:
	var i = im(k2)
	if i == null: return
	var fy0 = y + foot(base, k2) * h
	blit(ci, T, i, x, fy0, h, flip, rot, sx, sy, alpha)
	if tint > 0.02:
		var tc = J.cl(FN().PPL.tint, null, [k2])
		if tc == null: return
		var w = h * _w(i) / _h(i)
		ci.draw_set_transform_matrix(Transform2D.IDENTITY)
		var c: Ctx = _cur_ctx
		c.save(); c.globalAlpha = alpha * minf(0.4, tint * 0.45); c.translate(x, fy0)
		if rot != 0.0: c.rotate(rot)
		c.scale((-1.0 if flip else 1.0) * sx, sy); c.drawImage(tc, -w / 2, -h, w, h); c.restore()
static func shock(t: float, amp: float) -> Dictionary:
	var q = 1.0 - t / 0.9; var a = amp
	var o = {"sx": 1.0, "sy": 1.0, "jy": 0.0, "sh": 0.0, "tint": 0.95 * (1.0 - q * 0.55)}
	if q < 0.12:
		var c = q / 0.12; o.sy = 1 - 0.22 * c * a; o.sx = 1 + 0.16 * c * a
	elif q < 0.5:
		var c2 = (q - 0.12) / 0.38; o.jy = -sin(c2 * PI) * 0.3 * a; o.sy = 1 + (0.17 * (1 - c2)) * a; o.sx = 1 - (0.11 * (1 - c2)) * a
	else:
		var c3 = (q - 0.5) / 0.5; o.sy = 1 - 0.07 * sin(c3 * PI) * (1 - c3) * a; o.sx = 1 + 0.05 * sin(c3 * PI) * (1 - c3) * a
		o.sh = sin(Time.get_ticks_msec() / 1000.0 * 62) * 0.032 * (1 - c3)
	return o

static func _ell(ci: CanvasItem, cx: float, cy: float, rx: float, ry: float, col: Color) -> void: TwDraw.ell(ci, cx, cy, rx, ry, col)

# ---------------- 住客 ----------------
static var JSD := OS.has_environment("GB_TWJSDRAW")
static func res_all(ctx: Ctx, G, viewW: float, viewH: float, camx: float, camy: float) -> bool:
	if ctx.ci is Recorder or JSD: return false
	var ci: CanvasItem = ctx.ci; var T: Transform2D = ctx.T; _cur_ctx = ctx
	var t = n(G.t); var f = FN()
	for r in G.res:
		var st = J.str(r.get("state"))
		if st == "gone" or st == "away": continue
		var rx = n(r.x); var ry = n(r.y)
		if rx < camx - 60 or rx > camx + viewW + 60 or ry < camy - 20 or ry > camy + viewH + 120: continue
		if st == "leave" or st == "back":
			if not J.t(r.get("vx")): r["vx"] = 1.0
		var home = st == "home"; var F = n(r.get("fear")); var flee = st == "flee"
		var scared = n(r.get("shockT")) > 0 or flee
		var spr = J.str(r.sprite); var k2 = key(spr, scared)
		var H = hgt(spr, k2, n(r.get("h")) if r.get("h") != null else 58.0); var art = k2 != spr
		ci.draw_set_transform_matrix(T)
		_ell(ci, rx, ry - 1, 20.0 if chibi(spr) else 16.0, 4, Color(0, 0, 0, 0.45))
		var jy = 0.0; var sh = 0.0; var ro = 0.0; var sy = 1.0; var sx = 1.0; var vx = n(r.get("vx")); var flip = vx < 0; var tint = 0.0; var arms = false
		if n(r.get("shockT")) > 0:
			var S0 = shock(n(r.shockT), n(r.get("shockA")) if J.t(r.get("shockA")) else 1.0)
			sx = S0.sx; sy = S0.sy; jy = S0.jy * H; sh = S0.sh * H; tint = S0.tint * (0.18 if art else 0.7)
		elif home and J.t(r.get("awake")) and F >= 55:
			var ph = floori((t + fposmod(rx, 5.0)) * 1.15)
			sh = sin(t * 47 + rx) * 0.018 * H; sy = 0.93; tint = 0.16
			if ph % 3 != 2: flip = ph % 3 == 1
		elif home and F > 60: sh = sin(t * 40) * 1.6
		if flee:
			if n(r.get("tripT")) > 0: ro = (1.0 if vx > 0 else -1.0) * 1.25; jy = -6
			else: jy = -absf(sin(rx * 0.12)) * 7; ro = (1.0 if vx > 0 else -1.0) * 0.18; arms = not art
			tint = maxf(tint, 0.0 if art else 0.15)
		if n(r.get("tangle")) > 0: sh += sin(t * 30) * 2; sy *= 0.96
		if st == "leave" or st == "back": jy = -absf(sin(rx * 0.2)) * 3
		if home and not J.t(r.get("awake")) and not J.t(r.get("react")):
			ro = -1.45; jy = -8
			TwDraw.label(ci, "Z", rx + 18, ry - 30 - fposmod(t * 12, 10.0), 12, Color(200 / 255.0, 220 / 255.0, 1, 0.8), Color(0, 0, 0, 0), 0)
			TwDraw.label(ci, "z", rx + 26, ry - 40 - fposmod(t * 12 + 5, 10.0), 9, Color(200 / 255.0, 220 / 255.0, 1, 0.8), Color(0, 0, 0, 0), 0)
		var P = {"sh": 0.0, "jy": 0.0, "ro": 0.0, "sy": 1.0}
		var react = J.t(r.get("react")) or n(r.get("tidy")) > 0
		if react: J.cl(f.reactPose, null, [r, P])
		sh += n(P.sh); jy += n(P.jy); ro += n(P.ro); sy *= n(P.sy)
		var by = ry + jy + n(r.get("dy"))
		if arms:
			ci.draw_set_transform_matrix(Transform2D.IDENTITY); ctx.save()
			J.cl(f.PPL.arms, null, [ctx, rx + sh, by, H, 1.0 if vx > 0 else -1.0, t]); ctx.restore()
		pdraw(ci, T, spr, k2, rx + sh, by, H, flip, ro, sx, sy, tint)
		ci.draw_set_transform_matrix(Transform2D.IDENTITY)
		if react: J.cl(f.reactProps, null, [r, P])
		var top = by - H * minf(1.0, sy)
		if n(r.get("shockT")) > 0: J.cl(f.PPL.bang, null, [ctx, rx + sh + (0.0 if art else 4.0), top - 8, 1 - n(r.shockT) / 0.9, 0.9])
		elif flee and not J.t(r.get("tripT")): J.cl(f.PPL.bang, null, [ctx, rx, top - 6, 0.5, 0.7])
		if home and F > 0: J.cl(f.crBar, null, [ctx, rx - 20, top - 10, 40.0, 7.0, F / 100.0, "red"])
		if r.get("scream") != null: J.cl(f.PPL.scream, null, [ctx, rx, top - 16, r.scream, 1.0])
		if J.t(r.get("say")): J.cl(f.bubble, null, [rx, top - 12 - (6.0 if home and F > 0 else 0.0), r.say])
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true

# ---------------- 保安／道士／狗（加咗畫面外裁切）----------------
static func _lin(ci: CanvasItem, pts: PackedVector2Array, x0: float, x1: float, c0: Color) -> void:
	# 水平線性漸變（x0 → x1：c0 → 透明）填多邊形
	var cols = PackedColorArray(); cols.resize(pts.size())
	for i in pts.size():
		var u = clampf((pts[i].x - x0) / (x1 - x0), 0, 1) if x1 != x0 else 0.0
		cols[i] = Color(c0, c0.a * (1 - u))
	ci.draw_polygon(pts, cols)
static func guards_all(ctx: Ctx, G, CL) -> bool:
	if ctx.ci is Recorder or JSD: return false
	var ci: CanvasItem = ctx.ci; var T: Transform2D = ctx.T; _cur_ctx = ctx
	var t = n(G.t); var f = FN(); var HUM = f.HUM
	var y0 = n(CL.y0); var y1 = n(CL.y1)
	for s in G.guards:
		var kind = J.str(s.kind); var H = HUM[kind]
		var sxp = n(s.x); var syp = n(s.y)
		var hspr = H.get("spr")
		var HHt = hgt(J.str(hspr), J.str(hspr), n(H.h)) if hspr != null else n(H.h)
		s["alertT"] = maxf(0.0, n(s.get("alertT")))
		if syp < y0 or syp - 140 > y1: continue
		var dir = n(s.get("dir")); var sst = J.str(s.get("state"))
		ci.draw_set_transform_matrix(T)
		if kind == "guard" or kind == "compass":
			var sw = sin(t * 23 + sxp) * 46 + sin(t * 37) * 18 if sst == "scared" else sin(t * 2.4 + sxp * 0.01) * 14
			var al = (0.45 if sst == "chase" or kind == "compass" else 0.3) * ((0.4 + 0.6 * absf(sin(t * 29))) if sst == "scared" else 1.0)
			_lin(ci, PackedVector2Array([Vector2(sxp + dir * 8, syp - 30), Vector2(sxp + dir * 150, syp - 56 + sw), Vector2(sxp + dir * 150, syp - 4 + sw * 0.4)]), sxp, sxp + dir * 150, Color(1, 245 / 255.0, 180 / 255.0, al))
		_ell(ci, sxp, syp - 1, 16, 4, Color(0, 0, 0, 0.45))
		var bob: float; var fl: bool
		if kind == "dog": bob = -absf(sin(t * 18 + sxp)) * 5
		else: bob = n(J.cl(f.pplStep, null, [s]))
		fl = n(s.get("vx")) < 0 if sst == "flee" else dir < 0
		if kind == "dog":
			ci.draw_set_transform_matrix(Transform2D.IDENTITY)
			J.cl(f.dogDraw, null, [s, bob, fl])
		else:
			ci.draw_set_transform_matrix(Transform2D.IDENTITY)
			_guard(ctx, ci, T, s, H, bob, fl, t)
		ci.draw_set_transform_matrix(T)
		if kind == "mirror":
			var mx = sxp + dir * 14; var my = syp - 40
			ci.draw_circle(Vector2(mx, my), 8, TwDraw.C("#d8c070"))
			ci.draw_circle(Vector2(mx, my), 5.5, Color(220 / 255.0, 245 / 255.0, 1, 0.6 + 0.3 * sin(t * 6)))
			_lin(ci, PackedVector2Array([Vector2(mx, my), Vector2(mx + dir * 220, my - 26), Vector2(mx + dir * 220, my + 26)]), mx, mx + dir * 220, Color(220 / 255.0, 245 / 255.0, 1, 0.25))
		if kind == "compass":
			var cx = sxp + dir * 12
			ci.draw_circle(Vector2(cx, syp - 30), 6, TwDraw.C("#c8a050"))
			var na = t * 7
			ci.draw_line(Vector2(cx, syp - 30), Vector2(cx + cos(na) * 5, syp - 30 + sin(na) * 5), TwDraw.C("#660000"), 1.5)
			for q in int(n(s.get("courage"))): ci.draw_rect(Rect2(sxp - 12 + q * 5, syp - HHt - 10, 4, 4), TwDraw.C("#ffd54a"))
		TwDraw.label(ci, J.str(H.n), sxp, syp - HHt - 14, 11, TwDraw.C("#e8e4dc" if kind == "guard" else "#ffe9a0"), Color.BLACK, 3)
		if n(s.alertT) > 0:
			var bb = sin(t * 20) * 2
			TwDraw.label(ci, "！", sxp, syp - HHt - 24 + bb, 26, TwDraw.C("#ffe25a"), Color.BLACK, 3)
		ci.draw_set_transform_matrix(Transform2D.IDENTITY)
		if J.t(s.get("say")): J.cl(f.bubble, null, [sxp, syp - HHt - 30, s.say])
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true

static func _guard(ctx: Ctx, ci: CanvasItem, T: Transform2D, s, H, bob: float, fl: bool, t: float) -> void:
	var f = FN(); var sxp = n(s.x); var syp = n(s.y); var sst = J.str(s.get("state"))
	var hs = J.str(H.spr); var scared = n(s.get("shockT")) > 0 or sst == "scared" or sst == "flee"
	var k2 = key(hs, scared); var HH = hgt(hs, k2, n(H.h)); var art = k2 != hs
	var sx = 1.0; var sy = 1.0; var jy = 0.0; var sh = 0.0; var ro = n(s.get("_sway")); var tint = 0.0
	if n(s.get("shockT")) > 0:
		var S0 = shock(n(s.shockT), 1.0); sx = S0.sx; sy = S0.sy; jy = S0.jy * HH; sh = S0.sh * HH; tint = S0.tint * (0.18 if art else 0.7)
	elif sst == "scared": sh = sin(t * 45 + sxp) * 1.3; sy = 0.95; tint = 0.22
	if sst == "flee":
		ro = 0.2 if n(s.get("vx")) > 0 else -0.2; tint = maxf(tint, 0.0 if art else 0.15)
		if not art:
			ctx.save(); J.cl(f.PPL.arms, null, [ctx, sxp, syp + bob + jy, HH, 1.0 if n(s.get("vx")) > 0 else -1.0, t]); ctx.restore()
	pdraw(ci, T, hs, k2, sxp + sh, syp + bob + jy, HH, fl, ro, sx, sy, tint, 0.88 if J.str(s.kind) == "decoy" else 1.0)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	var top = syp + bob + jy - HH * minf(1.0, sy)
	if n(s.get("shockT")) > 0: J.cl(f.PPL.bang, null, [ctx, sxp + sh, top - 8, 1 - n(s.shockT) / 0.9, 0.9])
	if s.get("scream") != null: J.cl(f.PPL.scream, null, [ctx, sxp, top - 34, s.scream, 1.0])
