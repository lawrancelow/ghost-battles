# 回陽間：二十三樓家具同坐喺工位嘅人（office.js drawItem / drawKid / chairSprite / drawKen 等）嘅原生移植
# 狀態（家具晃動、跌嘢、螢幕雪花、阿Ken 坐企）仍然由 office.js 嘅 tick 更新，呢度只負責畫
class_name ScOffice
extends RefCounted

const KEN_H := 64.0 / (64.0 * 1.08)
const SIT_H := 0.876
const CHAIR := {"spr": "of_chair_front", "back": 0.64, "seat": 0.40, "h": 0.60}
const SIT := {"npc_ken_sit": [0.982, 0.99, 598], "npc_ken_sit_stretch": [0.603, 0.99, 606], "npc_ken_sit_coffee": [0.87, 0.992, 621], "npc_ken_sit_jump": [0.822, 0.992, 627],
	"npc_it_sit": [0.80, 0.99, 598], "npc_it_sit_tea": [0.71, 0.99, 606], "npc_it_sit_jump": [0.64, 0.99, 618]}
const TINT := Color(0.735, 0.72, 0.775)   # 夜色：原圖 × 0.7 ＋ rgba(26,18,58,.3)（近似）

static func _b(v) -> bool: return J.t(v)
static func _n(v, d := 0.0) -> float: return J.num(v) if v != null else d
static func cl(v: float, a := 0.0, b := 1.0) -> float: return clampf(v, a, b)
static func ss(t: float) -> float: t = cl(t); return t * t * (3 - 2 * t)
static func bump(t: float, a: float, m: float, b: float) -> float:
	if t <= a or t >= b: return 0.0
	return ss((t - a) / (m - a)) if t < m else 1 - ss((t - m) / (b - m))
static func rnd(s: float) -> float: var x = sin(s * 127.1 + 311.7) * 43758.5453; return x - floor(x)

static func N() -> Dictionary: return J.gp(J.G.get("OFFICE"), "_n")
static func st() -> Dictionary: return J.cl(N().st, null, [])
static func U(Sc, y: float) -> float: return _n(J.mc(Sc, "hh", [y])) * KEN_H
static func P(Sc, x: float, y: float) -> Vector2: var p = J.mc(Sc, "pt", [x, y]); return Vector2(_n(p[0]), _n(p[1]))
static func tex(k: String) -> Texture2D: return Spr.get_tex(k) if k != "" else null

static func _img(ctx: Ctx, t: Texture2D, x: float, y: float, w: float, h: float) -> void:
	var m = ctx._mod() * TINT; m.a = ctx._mod().a
	if m.a <= 0.001: return
	ctx.ci.draw_set_transform_matrix(ctx.T); ctx.ci.draw_texture_rect(t, Rect2(x, y, w, h), false, m); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
static func _img_region(ctx: Ctx, t: Texture2D, src: Rect2, dst: Rect2) -> void:
	var m = ctx._mod() * TINT; m.a = ctx._mod().a
	ctx.ci.draw_set_transform_matrix(ctx.T); ctx.ci.draw_texture_rect_region(t, dst, src, m); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)

static func shadow_at(ctx: Ctx, x: float, y: float, w: float, a = null) -> void:
	ctx.save(); ctx.fillStyle = Color(6 / 255.0, 4 / 255.0, 18 / 255.0, 0.38 if a == null else float(a)); ctx.beginPath(); ctx.ellipse(x, y, w / 2, w * 0.13, 0, 0, TAU); ctx.fill(); ctx.restore()

static func text(ctx: Ctx, x: float, y: float, s: String, sz: float, a: float) -> void:
	if a <= 0.01: return
	ctx.save(); ctx.globalAlpha *= cl(a); ctx.font = "900 %dpx sans-serif" % int(round(sz)); ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = "#1a1020"
	var tt = J.str(DB.L(s)); ctx.strokeText(tt, x, y); ctx.fillStyle = "#fff3d0"; ctx.fillText(tt, x, y); ctx.restore()

static func frame_of(Sc, it: Dictionary) -> Dictionary:
	var im = tex(J.str(it.spr)); var iw = float(im.get_width()) if im else 1.0; var ih = float(im.get_height()) if im else 1.0
	var u = U(Sc, _n(it.get("uy")) if it.get("uy") != null else _n(it.y)); var h = _n(it.h) * u; var w = h * iw / ih; var p = P(Sc, _n(it.x), _n(it.y))
	return {"x": p.x, "y": p.y, "u": u, "w": w, "h": h, "im": im}

# ---------------- 螢幕 ----------------
static func mon_state(c: Dictionary) -> String:
	var sk = c.get("stn")
	if sk == null: return "off"
	var S = N().STATIONS.get(J.str(sk))
	if not (S is Dictionary): return "off"
	var m = S.get("monSt")
	if not (m is Dictionary) or _b(S.get("offline")): return "off"
	var q = _n(m.get("seq"), -1)
	if q < 0: return "on"
	if q < 0.55: return "static"
	if q < 1.4: return "off"
	return "static" if sin(q * 60) > 0 else "on"
static func mon_light(s: String, t: float) -> Variant:
	if s == "on": return [120, 185, 255, 0.5 + 0.08 * sin(t * 5) + (0.15 if sin(t * 0.7) > 0.9 else 0.0)]
	if s == "static": return [235, 240, 255, 0.35 + 0.5 * randf()]
	return null
static func _rgba(c: Array, a: float) -> Color: return Color(c[0] / 255.0, c[1] / 255.0, c[2] / 255.0, a)
static func mon_halo(ctx: Ctx, s: String, L: float, T: float, w: float, h: float, t: float) -> void:
	var c = mon_light(s, t)
	if c == null: return
	var cx = L + w * 0.5; var cy = T + h * 0.36; var R = maxf(w, h * 0.75) * 0.8
	ctx.save(); var g = ctx.createRadialGradient(cx, cy, R * 0.4, cx, cy, R); g.addColorStop(0, _rgba(c, 0.9 * c[3])); g.addColorStop(1, _rgba(c, 0))
	ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(cx, cy, R, R * 0.85, 0, 0, TAU); ctx.fill(); ctx.restore()

# ---------------- 家具 ----------------
static func draw_item(ctx: Ctx, Sc, it: Dictionary, t: float, mode := "") -> void:
	var F = frame_of(Sc, it); var im: Texture2D = F.im
	if im == null: return
	var x: float = F.x; var y: float = F.y; var u: float = F.u; var w: float = F.w; var h: float = F.h
	var S = st(); var ax = _n(it.get("ax"), 0.5); var ay = _n(it.get("ay"), 1.0)
	if it.get("shadow") != null and mode != "kids":
		if it.get("shu") != null: shadow_at(ctx, x + (_n(it.shu) - ax) * w, y + (_n(it.shv) - ay) * h, _n(it.shadow) * u)
		else: shadow_at(ctx, x, y - h * 0.01, _n(it.shadow) * u)
	ctx.save(); ctx.translate(x, y)
	if _b(it.get("water")):
		var g = _n(S.water.glug); it["rot"] = _n(it.get("rot")) + (sin(t * 22) * 0.012 * minf(1, g) if g > 0 else 0.0)
	if _b(it.get("copier")) and _n(S.copier.print) > 0: ctx.translate(sin(t * 60) * u * 0.006, sin(t * 47) * u * 0.004)
	if _n(it.get("rot")) != 0: ctx.rotate(_n(it.rot))
	if _b(it.get("flip")): ctx.scale(-1, 1)
	if _b(it.get("fan")): _fan(ctx, S, it, F, t); ctx.restore(); return
	if _b(it.get("plant")):
		var k = _n(S.rustle) * sin(t * 11) * 0.05 + sin(t * 0.9 + _n(it.get("ph"))) * 0.006 + _n(S.flutter) * sin(t * 7) * 0.02; ctx.transform(1, 0, k, 1, 0, 0)
	var L = -ax * w; var T = -ay * h
	if mode != "kids": _img(ctx, im, L, T, w, h)
	if _b(it.get("back")) and mode != "base": _desk_spill(ctx, it, L, T, w, h, u, t)
	if mode != "base":
		for c in it.kids: _kid(ctx, S, c, L, T, w, h, u, t)
	if mode == "base": ctx.restore(); return
	if _b(it.get("copier")): _copier_fx(ctx, S, L, T, w, h, t)
	if _b(it.get("water")): _water_fx(ctx, S, L, T, w, h, t)
	if it.get("stn") != null: _desk_fx(ctx, it, L, T, w, h, u)
	if _b(it.get("glow")):
		var gx = L + w * 0.47; var gy = T + h * 0.05; var r = w * 0.55
		var g = ctx.createRadialGradient(gx, gy, 0, gx, gy, r); g.addColorStop(0, Color(120 / 255.0, 170 / 255.0, 1, 0.22 + 0.03 * sin(t * 2 + _n(it.get("ph"))))); g.addColorStop(1, Color(120 / 255.0, 170 / 255.0, 1, 0))
		ctx.fillStyle = g; ctx.fillRect(gx - r, gy - r, r * 2, r * 2)
	ctx.restore()

static func _desk_spill(ctx: Ctx, it: Dictionary, L: float, T: float, w: float, h: float, u: float, t: float) -> void:
	var sk = it.get("stn")
	if sk == null: return
	var m = null
	for c in it.kids: if J.str(c.get("id")) == J.str(N().STATIONS[J.str(sk)].mon): m = c
	if m == null: return
	var c = mon_light(mon_state(m), t)
	if c == null: return
	var x = L + _n(m.u) * w; var y = T + _n(m.v) * h
	ctx.save(); var g = ctx.createRadialGradient(x + u * 0.12, y - u * 0.02, 0, x + u * 0.12, y - u * 0.02, u * 0.32)
	g.addColorStop(0, _rgba(c, 0.22 * c[3])); g.addColorStop(1, _rgba(c, 0)); ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(x + u * 0.12, y - u * 0.02, u * 0.32, u * 0.12, -0.3, 0, TAU); ctx.fill(); ctx.restore()

static func _kid(ctx: Ctx, S: Dictionary, c: Dictionary, L: float, T: float, w: float, h: float, u: float, t: float) -> void:
	var fal = c.get("falling")
	if fal is Dictionary and _b(fal.get("off")): return
	var par = c.parent
	if par.get("stn") != null:
		var sK = N().STATIONS[J.str(par.stn)].get("K")
		if _b(c.get("mug")) and sK is Dictionary and J.str(sK.mode) == "sit" and J.str(sK.act) == "drink" and _n(sK.at) > 0.45 and _n(sK.at) < _n(sK.dur) - 0.4: return
	var key = J.str(c.spr); var im = tex(key)
	if im == null: return
	var hide = _n(c.get("hide")); var a = (1 - hide / 0.6 if hide < 0.6 else 0.0) if hide > 0 else 1.0
	if a <= 0: return
	var iw = float(im.get_width()); var ih = float(im.get_height())
	var mon = _b(c.get("mon")) and not _b(c.get("side"))
	var ch = _n(c.h) * u; var cw = 0.47 * u if mon else ch * iw / ih; var chh = cw * ih / iw if mon else ch
	var x = L + _n(c.u) * w; var y = T + _n(c.v) * h
	if c.get("on") != null:
		for m in par.kids:
			if J.str(m.get("id")) == J.str(c.on): x = L + _n(m.u) * w + (_n(c.u) - 0.5) * 0.47 * u; y = T + _n(m.v) * h - (1 - _n(c.v)) * 0.47 * u * 0.98
	ctx.save(); ctx.globalAlpha *= a; ctx.translate(x, y)
	var r = _n(c.get("rot"))
	if _b(c.get("paper")): r += sin(t * 9 + _n(c.get("ph"))) * 0.06 * _n(S.flutter)
	if _b(c.get("lamp")): r += _n(S.lamp.sway)
	ctx.rotate(r)
	if _b(c.get("flip")): ctx.scale(-1, 1)
	if _b(c.get("paper")): ctx.scale(1, 0.62 - 0.12 * _n(S.flutter) * (0.5 + 0.5 * sin(t * 13 + _n(c.get("ph")))))
	var kay = _n(c.get("ay"), 1.0); var kax = _n(c.get("ax"), 0.5)
	if _b(c.get("back")) and _b(c.get("mon")): mon_halo(ctx, mon_state(c), -kax * cw, -kay * chh, cw, chh, t)
	_img(ctx, im, -kax * cw, -kay * chh, cw, chh)
	if _b(c.get("lamp")): _lamp_fx(ctx, S, cw, chh, u, t)
	ctx.restore()
	if _b(c.get("mug")) and _n(c.get("puddle")) > 0:
		c["puddle"] = _n(c.puddle) - 1.0 / 60.0
		ctx.save(); ctx.fillStyle = Color(70 / 255.0, 40 / 255.0, 20 / 255.0, 0.55 * minf(1, _n(c.puddle) / 2)); ctx.beginPath(); ctx.ellipse(x + u * 0.06, y + u * 0.01, u * 0.07, u * 0.016, 0, 0, TAU); ctx.fill(); ctx.restore()

static func _lamp_fx(ctx: Ctx, S: Dictionary, w: float, h: float, u: float, t: float) -> void:
	var Ls = S.lamp; var on = false if _b(N().STATIONS.it.get("offline")) else ((sin(t * 31) + sin(t * 13) > 0.3) if _n(Ls.flick) > 0 else true)
	var bx = (0.88 - 0.78) * w; var by = -h * (1 - 0.40)
	if on:
		ctx.save(); var g = ctx.createRadialGradient(bx, by + h * 0.25, 0, bx, by + h * 0.25, u * 0.55); g.addColorStop(0, Color(1, 200 / 255.0, 110 / 255.0, 0.38)); g.addColorStop(1, Color(1, 200 / 255.0, 110 / 255.0, 0))
		ctx.fillStyle = g; ctx.beginPath(); ctx.arc(bx, by + h * 0.25, u * 0.55, 0, TAU); ctx.fill(); ctx.restore()
	else:
		ctx.save(); ctx.fillStyle = Color(20 / 255.0, 14 / 255.0, 30 / 255.0, 0.75); ctx.beginPath(); ctx.ellipse(bx + w * 0.02, by + h * 0.02, w * 0.12, h * 0.07, -0.5, 0, TAU); ctx.fill(); ctx.restore()

static func _copier_fx(ctx: Ctx, S: Dictionary, L: float, T: float, w: float, h: float, t: float) -> void:
	var k = maxf(_n(S.copier.print), _n(S.copier.get("idle")))
	if k <= 0: return
	var q = fmod(t * 1.6, 1.0); var x = L + w * (0.42 + 0.3 * q); var e = minf(1, k * 3)
	ctx.save(); ctx.fillStyle = Color(150 / 255.0, 1, 190 / 255.0, 0.55 * e); ctx.fillRect(x, T + h * 0.27, w * 0.03, h * 0.06)
	var g = ctx.createRadialGradient(L + w * 0.55, T + h * 0.3, 0, L + w * 0.55, T + h * 0.3, w * 0.5); g.addColorStop(0, Color(150 / 255.0, 1, 190 / 255.0, 0.25 * e)); g.addColorStop(1, Color(150 / 255.0, 1, 190 / 255.0, 0))
	ctx.fillStyle = g; ctx.fillRect(L, T, w, h * 0.7); ctx.restore()

static func _water_fx(ctx: Ctx, S: Dictionary, L: float, T: float, w: float, h: float, t: float) -> void:
	var k = _n(S.water.glug)
	if k <= 0: return
	ctx.save()
	for i in 9:
		var q = fmod(t * (0.7 + rnd(i) * 0.6) + rnd(i + 9), 1.0); var bx = L + w * (0.3 + 0.36 * rnd(i + 3)) + sin(t * 5 + i) * w * 0.03; var by = T + h * (0.37 - q * 0.3); var r = w * (0.03 + 0.05 * rnd(i + 5)) * (0.6 + q * 0.6)
		ctx.strokeStyle = Color(225 / 255.0, 245 / 255.0, 1, 0.85 * minf(1, k)); ctx.lineWidth = 1.4; ctx.beginPath(); ctx.arc(bx, by, r, 0, TAU); ctx.stroke()
	ctx.restore()

static func _desk_fx(ctx: Ctx, it: Dictionary, L: float, T: float, w: float, h: float, u: float) -> void:
	var K = N().STATIONS[J.str(it.stn)].get("K")
	if not (K is Dictionary): return
	for k in K.keys:
		ctx.fillStyle = Color(200 / 255.0, 240 / 255.0, 1, minf(1, _n(k.life) * 3)); ctx.fillRect(L + _n(k.u) * w, T + _n(k.v) * h, w * 0.022, h * 0.014)
	for d in J.cl(N().drops, null, []):
		if d.get("desk") != it: continue
		var x = L + _n(d.u) * w + _n(d.ox) * u; var y = T + _n(d.v) * h - _n(d.z) * u
		ctx.fillStyle = Color(80 / 255.0, 46 / 255.0, 22 / 255.0, 0.85 * minf(1, _n(d.life))); ctx.beginPath(); ctx.ellipse(x, y, u * 0.009, u * 0.005 if _b(d.get("land")) else u * 0.012, 0, 0, TAU); ctx.fill()

static func _fan(ctx: Ctx, S: Dictionary, it: Dictionary, F: Dictionary, t: float) -> void:
	var im: Texture2D = F.im; var w: float = F.w; var h: float = F.h
	var fan = S.fan; var osc = sin(_n(fan.osc)) * (0.7 + _n(fan.boost) * 0.2); var cut = 0.5; var L = -0.5 * w; var T = -h
	var iw = float(im.get_width()); var ih = float(im.get_height())
	_img_region(ctx, im, Rect2(0, ih * cut, iw, ih * (1 - cut)), Rect2(L, T + h * cut, w, h * (1 - cut)))
	var cx = 0.0; var cy = T + h * 0.237; var sx = cos(osc) * 0.85 + 0.15
	ctx.save(); ctx.translate(cx, cy); ctx.scale(sx, 1); ctx.translate(-cx, -cy)
	_img_region(ctx, im, Rect2(0, 0, iw, ih * cut), Rect2(L, T, w, h * cut))
	var r = w * 0.36; var spd = 1 + _n(fan.boost) * 2.5
	for i in 3:
		var a = _n(fan.spin) + i * TAU / 3; ctx.strokeStyle = Color(235 / 255.0, 230 / 255.0, 210 / 255.0, 0.18 + 0.1 * minf(1, spd / 3)); ctx.lineWidth = r * 0.28
		ctx.beginPath(); ctx.arc(cx, cy, r * 0.62, a, a + 0.5 + 0.35 * minf(1, spd / 3)); ctx.stroke()
	ctx.restore()
	if _n(fan.boost) > 0.2:
		ctx.save(); ctx.strokeStyle = Color(230 / 255.0, 240 / 255.0, 1, 0.35 * minf(1, _n(fan.boost))); ctx.lineWidth = 1.5
		for i in 3:
			var q = fmod(t * 2 + i / 3.0, 1.0); var x = -w * 0.6 - q * w * 1.5; var y = cy + (i - 1) * h * 0.08
			ctx.beginPath(); ctx.moveTo(x, y); ctx.quadraticCurveTo(x - w * 0.3, y + sin(t * 8 + i) * 4, x - w * 0.6, y); ctx.stroke()
		ctx.restore()

# ---------------- 椅子 ----------------
static func chair_sprite(ctx: Ctx, x: float, y: float, u: float, sw: float, lean: float, front: String, hU: float, flip_front: bool, anchorU = null) -> void:
	var c = cos(sw); var use_back = c < 0
	var key = ("of_chair_front" if front == "of_chair_back" else "of_chair_back") if use_back else front
	var im = tex(key)
	if im == null: return
	var h = hU * u; var w = h * im.get_width() / im.get_height(); var sx = maxf(0.35, absf(c))
	shadow_at(ctx, x, y, w * 0.85, 0.34)
	ctx.save(); ctx.translate(x, y)
	if lean: ctx.translate(0, -h * 0.4); ctx.rotate(lean); ctx.translate(0, h * 0.4)
	ctx.scale(sx * (-1 if (flip_front and not use_back) or (not flip_front and use_back and front != "of_chair_back") else 1), 1)
	var ax = ((1 - float(anchorU)) if use_back else float(anchorU)) if anchorU != null else 0.5
	_img(ctx, im, -ax * w, -h, w, h); ctx.restore()

static func draw_free_chair(ctx: Ctx, Sc, it: Dictionary) -> void:
	var ox = _n(it.get("ox")); var oz = _n(it.get("oz")); var p = P(Sc, _n(it.x) + ox, _n(it.y) + oz); var u = U(Sc, _n(it.y) + oz)
	chair_sprite(ctx, p.x, p.y, u, _n(it.get("sw")), 0, "of_chair_back", _n(it.h), false)

static func draw_ken_chair(ctx: Ctx, Sc, S: Dictionary) -> void:
	var ch = S.K.ch; var p = P(Sc, _n(S.SEATV.x) + _n(ch.dx), _n(S.seat.y) + _n(ch.dz)); var u = U(Sc, _n(S.seat.y) + _n(ch.dz))
	chair_sprite(ctx, p.x, p.y, u, _n(ch.sw), 0, CHAIR.spr, CHAIR.h, true, 1 - CHAIR.back)

# ---------------- 坐喺工位嘅人（阿Ken、小晴） ----------------
static func draw_ken(ctx: Ctx, Sc, n: Dictionary, t: float) -> Dictionary:
	var STN = N().STATIONS.get(J.str(n.d.k))
	if not (STN is Dictionary) or not (STN.get("K") is Dictionary): return {"x": 0.0, "top": 0.0, "H": 0.0}
	var K: Dictionary = STN.K; var ch = K.ch; var seat = STN.seat; var seatv = STN.SEATV
	var items = J.cl(N().items, null, [])
	var p0 = P(Sc, _n(seatv.x) + _n(ch.dx), _n(seat.y) + _n(ch.dz)); var x = p0.x; var y = p0.y; var u = U(Sc, _n(seat.y)); var sw = _n(ch.sw)
	var rxr = n.get("rx"); var rx = rxr if rxr is Dictionary and _n(rxr.get("t")) >= 0 else null
	var key = J.str(STN.base); var lift = 0.0; var sq = 1.0; var rot = _n(ch.lean); var jx = 0.0; var mesh = true; var pose = {}
	var a = _n(K.at); var scx = maxf(0.35, absf(cos(sw))); var mode = J.str(K.mode); var act = J.str(K.act); var f = _n(n.get("fear")); var dur = _n(K.dur)
	if mode == "sit":
		if act == "stretch" and f < 25:
			if a > 0.3 and a < dur - 0.35: key = J.str(STN.stretch); mesh = false
			sq = 1 + 0.04 * bump(a, 0.3, 0.6, 1.2) - 0.05 * (bump(a, 0.15, 0.3, 0.45) + bump(a, dur - 0.5, dur - 0.35, dur - 0.2)); lift = 0.02 * bump(a, 0.5, 1.3, 2.6)
		elif act == "drink" and f < 25:
			if a > 0.45 and a < dur - 0.4: key = J.str(STN.drink); mesh = false; rot -= 0.06 * bump(a, 1.0, 1.6, 2.8)
			sq = 1 - 0.04 * (bump(a, 0.3, 0.45, 0.6) + bump(a, dur - 0.55, dur - 0.4, dur - 0.25))
		var typing = act == "type" and f < 25
		var tap0 = (rnd(floor(t * 9)) - 0.5) * 2
		pose = {"armF": (0.035 * tap0 + 0.02 * sin(t * 18)) if typing else 0.01 * sin(t * 1.6), "head": (0.012 * sin(t * 3.1) if typing else 0.025 * sin(t * 1.2)) + (sin(_n(K.mt) * 1.6) * 0.06 if f >= 25 else 0.0), "body": 0.012 * sin(t * 1.8), "sy": 1 + 0.01 * sin(t * 1.8)}
		if act == "neck" and f < 25:
			var e = ss(a / 0.4) * ss((dur - a) / 0.4); var q = cl((a - 0.3) / 2.2) * TAU
			pose.head = (sin(q) * 0.16 - 0.04) * e; pose.body = -0.05 * e * sin(q * 0.5); pose.hair = sin(q - 0.6) * 0.12 * e; pose.armF = 0.06 * e; sq *= 1 + 0.02 * e
		if act == "vibe" and f < 25:
			var e = ss(a / 0.4) * ss((dur - a) / 0.4); var beat = absf(sin(a * PI * 2.2))
			pose.head = (-0.05 * beat + 0.02) * e; pose.hair = 0.1 * sin(a * PI * 2.2 - 0.8) * e; pose.armF = 0.03 * (rnd(floor(t * 9)) - 0.5) * 2
		if rx != null:
			var p = _n(rx.t) / maxf(0.0001, _n(rx.get("dur"), 1.0)); var rk = J.str(rx.get("k"))
			if rk == "flinch": sq = 1 - 0.06 * (1 - p); jx = (randf() - 0.5) * 3 * (1 - p); pose.head = -0.08 * (1 - p)
			if rk == "rational": var s = sin(minf(1, _n(rx.t) / 0.55) * PI); sq = 1 + 0.04 * s; lift = 0.02 * s
		if f >= 25 and f < 50: jx += (randf() - 0.5) * 1.2
	elif mode == "jump":
		key = J.str(STN.jump); mesh = false; var p = _n(K.mt) / 0.62
		lift = sin(minf(1, p * 1.3) * PI) * 0.16 + (-0.02 if p < 0.12 else 0.0); sq = 0.92 if p < 0.12 else 1 + 0.08 * sin(minf(1, p * 1.3) * PI)
		jx = (randf() - 0.5) * 2
	elif mode == "rise": var p = _n(K.mt) / 0.34; rot -= 0.18 * sin(p * PI * 0.5); lift = 0.04 * p; sq = 1 - 0.05 * sin(p * PI); mesh = false
	elif mode == "sitdown": var p = _n(K.mt) / 0.32; lift = 0.07 * (1 - ss(p)); sq = 1 - 0.06 * sin((p - 0.6) / 0.4 * PI) if p > 0.6 else 1.0
	if _n(K.get("pop")) > 0: sq *= 1 - 0.05 * sin(_n(K.pop) / 0.18 * PI)
	if mode != "jump": chair_sprite(ctx, x, y, u, sw, _n(ch.lean), CHAIR.spr, CHAIR.h, true, 1 - CHAIR.back)
	var im = tex(key); var base_im = tex("npc_ken_sit")
	if im == null or base_im == null: return {"x": x, "top": y - u, "H": SIT_H * u}
	var Sd: Array = SIT[key]; var Hh = SIT_H * u * im.get_height() / base_im.get_height(); var W = Hh * im.get_width() / im.get_height()
	var bx = x; var by = y - lift * u
	var desk = items.get(J.str(STN.desk)); var mon = items.get(J.str(STN.mon))
	var ml = mon_light(mon_state(mon), t) if mon is Dictionary else null
	var body = func(clip_arms: bool):
		ctx.save(); ctx.translate(bx + jx, by)
		if rot: ctx.translate(0, -u * 0.28); ctx.rotate(rot); ctx.translate(0, u * 0.28)
		ctx.scale(scx, sq)
		if clip_arms:
			var A = STN.arms; ctx.beginPath(); ctx.rect(-Sd[0] * W + _n(A[0]) * W, -Sd[1] * Hh + _n(A[1]) * Hh, _n(A[2]) * W, _n(A[3]) * Hh); ctx.clip()
		if mesh and key == J.str(STN.base):
			# 原生網格（core/meshanim.gd）；冇圖先交返 JS
			if not MeshAnim.RIG.has(key): MeshAnim.RIG[key] = {"bones": _bones(STN.bones)}
			if not MeshAnim.draw(ctx, key, -(Sd[0] - 0.5) * W, (1 - Sd[1]) * Hh, Hh, pose, false):
				var MA = J.G.get("MeshAnim")
				if not J.gp(MA, "RIG").has(key): J.gp(MA, "RIG")[key] = {"bones": STN.bones}
				J.mc(MA, "draw", [ctx, key, -(Sd[0] - 0.5) * W, (1 - Sd[1]) * Hh, Hh, pose, false])
		else: ctx.drawImage(im, -Sd[0] * W, -Sd[1] * Hh, W, Hh)
		if not clip_arms and key == "npc_ken_sit_coffee": _steam(ctx, -Sd[0] * W + W * 0.28, -Sd[1] * Hh + Hh * 0.27, u, t)
		if ml != null and mode != "jump":
			var gx = -Sd[0] * W + W * _n(STN.face[0]); var gy = -Sd[1] * Hh + Hh * _n(STN.face[1]); var R = u * 0.42; var a0 = 0.42 * ml[3]
			var g = ctx.createRadialGradient(gx, gy, 0, gx, gy, R); g.addColorStop(0, _rgba(ml, a0)); g.addColorStop(1, _rgba(ml, 0)); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(gx, gy, R, 0, TAU); ctx.fill()
		ctx.restore()
	body.call(false)
	if desk is Dictionary: draw_item(ctx, Sc, desk, t, "base")
	if key == J.str(STN.base) and mode != "jump": body.call(true)
	if desk is Dictionary: draw_item(ctx, Sc, desk, t, "kids")
	if mode == "sit" and act == "stretch" and STN.get("stretchSay") != null and a > 0.6 and a < 2.4: text(ctx, x - u * 0.78, y - u * 0.72, J.str(STN.stretchSay), u * 0.15, bump(a, 0.7, 0.9, 2.3))
	if mode == "sit" and act == "drink" and STN.get("drinkSay") != null and a > 0.9 and a < 3.0 and f < 25: text(ctx, x - u * 0.62, y - u * 0.86, J.str(STN.drinkSay), u * 0.12, bump(a, 1.0, 1.3, 2.8))
	if mode == "sit" and act == "vibe" and f < 25:
		for i in 2:
			var q = fmod(a * 0.6 + i * 0.5, 1.0); text(ctx, x - u * (0.05 - 0.1 * q) + i * u * 0.08, y - u * (0.9 + 0.2 * q), "♫" if i else "♪", u * 0.12, sin(q * PI) * ss(a / 0.5))
	if mode == "sit" and act == "neck" and f < 25: text(ctx, x - u * 0.7, y - u * 0.8, "喀", u * 0.11, bump(a, 1.2, 1.35, 1.7))
	return {"x": x - u * 0.22, "top": y - lift * u - SIT_H * u * (1.0 if key == J.str(STN.get("stretch")) else 0.98), "H": SIT_H * u}

static func _bones(B) -> Array:
	var out = []
	for b in B:
		var r = []
		for i in b.size(): r.append(b[i] if i < 2 else float(J.num(b[i])))
		out.append(r)
	return out

static func _steam(ctx: Ctx, x: float, y: float, u: float, t: float) -> void:
	ctx.save(); ctx.lineCap = "round"
	for i in 2:
		var q = fmod(t * 0.6 + i * 0.5, 1.0); ctx.strokeStyle = Color(240 / 255.0, 240 / 255.0, 240 / 255.0, 0.5 * (1 - q)); ctx.lineWidth = u * 0.012
		ctx.beginPath(); var sx = x + (i - 0.5) * u * 0.03; ctx.moveTo(sx, y - q * u * 0.05)
		ctx.bezierCurveTo(sx + u * 0.02, y - u * 0.05 - q * u * 0.1, sx - u * 0.02, y - u * 0.09 - q * u * 0.1, sx + sin(t * 2 + i) * u * 0.015, y - u * 0.14 - q * u * 0.1); ctx.stroke()
	ctx.restore()
