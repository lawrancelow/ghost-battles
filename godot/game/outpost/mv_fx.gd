# 移動村：生產台動態（資料驅動：STATIONS[].anim = {"fx":[...], "pts":[[u,v]...], "c":"#色"}）
# 全部程序畫（變形＋疊加小物件＋時間公式粒子，唔開粒子陣列），冇生產時靜止或者輕微待機。
# pre()：成個台嘅變形（喺畫台圖之前叫）；post()：疊加效果（畫完台圖之後叫）。
extends RefCounted

const WHOLE := ["bob", "wiggle", "hop", "sway", "bounce", "rock"]

static func _c(an: Dictionary) -> Color: return Color(str(an.get("c", "#ffffff")))
static func _pt(an: Dictionary, i: int, r: Rect2) -> Vector2:
	var P = an.get("pts", [])
	var q = P[mini(i, P.size() - 1)] if P is Array and P.size() else [0.5, 0.4]
	return r.position + Vector2(float(q[0]) * r.size.x, float(q[1]) * r.size.y)
static func _rgba(c: Color, a: float) -> String: return "rgba(%d,%d,%d,%s)" % [int(c.r * 255), int(c.g * 255), int(c.b * 255), str(snappedf(clampf(a, 0, 1), 0.01))]
static func _fr(x: float) -> float: return x - floor(x)

# ---------------- 成個台變形 ----------------
static func pre(ctx: Ctx, an: Dictionary, base: Vector2, t: float, on: bool, ph: float) -> void:
	var fx = an.get("fx", [])
	var a = 1.0 if on else 0.15      # 待機：好輕微
	for f in fx:
		match str(f):
			"bob":    _sq(ctx, base, 1.0 + 0.035 * a * sin(t * 6.0 + ph), 1.0 - 0.035 * a * sin(t * 6.0 + ph))
			"wiggle": _skew(ctx, base, 0.06 * a * sin(t * 5.0 + ph))
			"hop":
				var h = absf(sin(t * 4.0 + ph)) * 7.0 * a
				ctx.translate(0, -h)
			"sway":   _rot(ctx, base + Vector2(0, -90), 0.07 * a * sin(t * 2.2 + ph))
			"bounce":
				var u = absf(sin(t * 5.0 + ph))
				_sq(ctx, base, 1.0 + 0.05 * a * (1.0 - u), 1.0 - 0.05 * a * (1.0 - u)); ctx.translate(0, -u * 5.0 * a)
			"rock":   _rot(ctx, base, 0.05 * a * sin(t * 1.8 + ph))
static func _sq(ctx: Ctx, b: Vector2, sx: float, sy: float) -> void:
	ctx.translate(b.x, b.y); ctx.scale(sx, sy); ctx.translate(-b.x, -b.y)
static func _rot(ctx: Ctx, b: Vector2, a: float) -> void:
	ctx.translate(b.x, b.y); ctx.rotate(a); ctx.translate(-b.x, -b.y)
static func _skew(ctx: Ctx, b: Vector2, k: float) -> void:
	ctx.translate(b.x, b.y); ctx.transform(1, 0, k, 1, 0, 0); ctx.translate(-b.x, -b.y)

# ---------------- 疊加效果 ----------------
static func post(ctx: Ctx, an: Dictionary, r: Rect2, t: float, on: bool, ph: float) -> void:
	var fx = an.get("fx", []); var c = _c(an)
	for i in fx.size():
		var f = str(fx[i])
		if f in WHOLE: continue
		var p = _pt(an, i, r)
		if not on:
			_idle(ctx, f, p, r, t, c, ph); continue
		match f:
			"steam": _steam(ctx, p, t, c, true)
			"puff": _steam(ctx, p, t, c, false)
			"lid": _lid(ctx, p, r, t)
			"snip": _snip(ctx, p, t)
			"scraps": _bits(ctx, p, t, c, 6, 40.0, 2.4, "scrap")
			"bucket": _bucket(ctx, p, t)
			"drip": _drip(ctx, p, t, c)
			"mill": _mill(ctx, p, r, t)
			"flow": _flow(ctx, p, t, c)
			"saw": _saw(ctx, p, t)
			"chips": _bits(ctx, p, t, c, 7, 34.0, 1.6, "chip")
			"flame": _flame(ctx, p, t, c)
			"sparks": _bits(ctx, p, t, Color("#ffcc55"), 6, 46.0, 1.2, "spark")
			"drop_bounce": _durian(ctx, p, r, t)
			"leaves": _bits(ctx, p, t, c, 4, 60.0, 3.2, "leaf")
			"bubbles": _bubbles(ctx, p, t, c)
			"bend": _bend(ctx, p, r, t)
			"straw": _bits(ctx, p, t, c, 5, 30.0, 2.0, "straw")
			"mist": _mist(ctx, p, r, t, c)
			"glow": _glow(ctx, p, t, c, 26.0)
			"heat": _heat(ctx, p, t)
			"stack": _stack(ctx, p, t, c)
			"needle": _needle(ctx, p, t)
			"petals": _bits(ctx, p, t, c, 5, 40.0, 2.6, "petal")
			"sheets": _bits(ctx, p, t, c, 4, 70.0, 3.0, "sheet")
			"slap": _slap(ctx, p, t, c)
			"curl": _curl(ctx, p, t, c)
			"fireflies": _fireflies(ctx, p, t, c)
			"fishswing": _fish(ctx, p, t)
			"salt": _bits(ctx, p, t, Color.WHITE, 8, 26.0, 1.4, "dot")
			"arm": _arm(ctx, p, t)
			"lemons": _lemons(ctx, p, t, c)
			"coins": _bits(ctx, p, t, c, 6, 60.0, 2.2, "coin")
			"ring": _ring(ctx, p, t, c)
			"blow": _blow(ctx, p, t)
			"ripple": _ripple(ctx, p, t, c)
			"quill": _quill(ctx, p, t)
			"wheel": _wheel(ctx, p, t)
			"zap": _zap(ctx, p, t, c)
			"eye": _eye(ctx, p, t)
			"tick": _tick(ctx, p, t)
			"sticks": _bits(ctx, p, t, c, 5, 38.0, 1.8, "stick")
			"exhaust": _exhaust(ctx, p, t, c)
			"beam": _beam(ctx, p, t, c)
			"bulbs": _bulbs(ctx, p, r, t, c)
			"flicker": _flicker(ctx, p, r, t, c)
			"ladle": _ladle(ctx, p, t)
			"chill": _bits(ctx, p, t, c, 6, 36.0, 2.6, "flake")
			"copier": _copier(ctx, p, r, t, c)
			"frost": _frost(ctx, p, r, t, c)
			"stamp": _stamp(ctx, p, t)
			"zzz": _zzz(ctx, p, t, c)

static func _idle(ctx: Ctx, f: String, p: Vector2, r: Rect2, t: float, c: Color, ph: float) -> void:
	# 冇生產：淨係少少待機（發光類微光，其他唔郁）
	match f:
		"glow", "flame", "bulbs", "eye":
			Art.el(ctx, p.x, p.y, 14, 14, _rgba(c, 0.10 + 0.05 * sin(t * 2.0 + ph)))
		"steam", "puff", "mist":
			var u = _fr(t * 0.2 + ph)
			Art.el(ctx, p.x, p.y - 10 - u * 14, 6 + u * 4, 4 + u * 3, _rgba(c, 0.18 * (1.0 - u)))

# --- 各款效果 ---
static func _steam(ctx: Ctx, p: Vector2, t: float, c: Color, face: bool) -> void:
	for i in 4:
		var u = _fr(t * 0.55 + i * 0.25)
		var x = p.x + sin(u * 6.0 + i) * 8.0; var y = p.y - u * 54.0
		var rr = 7.0 + u * 10.0; var a = 0.55 * (1.0 - u)
		Art.el(ctx, x, y, rr, rr * 0.8, _rgba(c, a))
		if face and u > 0.25 and u < 0.8:   # 孤魂嘆氣：蒸氣有對眼同口
			Art.el(ctx, x - rr * 0.3, y - 2, 1.6, 2.2, _rgba(Color("#3a3040"), a * 1.4)); Art.el(ctx, x + rr * 0.3, y - 2, 1.6, 2.2, _rgba(Color("#3a3040"), a * 1.4))
			Art.el(ctx, x, y + rr * 0.35, 2.4, 3.2, _rgba(Color("#3a3040"), a * 1.2))
static func _lid(ctx: Ctx, p: Vector2, r: Rect2, t: float) -> void:
	var h = absf(sin(t * 7.0)) * 6.0
	Art.rr(ctx, p.x - r.size.x * 0.22, p.y - 6 - h, r.size.x * 0.44, 7, 3, "#c89a58", "#5a3a1a", 1.2)
	Art.el(ctx, p.x, p.y - 8 - h, 4, 3, "#8a5a2a")
static func _snip(ctx: Ctx, p: Vector2, t: float) -> void:
	var a = 0.12 + 0.35 * absf(sin(t * 8.0))
	ctx.strokeStyle = "#d8dce8"; ctx.lineWidth = 3
	for s in [-1.0, 1.0]:
		var d = Vector2(cos(-0.6 + s * a), sin(-0.6 + s * a)) * 16.0
		ctx.beginPath(); ctx.moveTo(p.x - d.x * 0.6, p.y - d.y * 0.6); ctx.lineTo(p.x + d.x, p.y + d.y); ctx.stroke()
	Art.el(ctx, p.x - 8, p.y + 6, 3.5, 3.5, null, "#c03030", 2); Art.el(ctx, p.x - 3, p.y + 9, 3.5, 3.5, null, "#c03030", 2)
static func _bits(ctx: Ctx, p: Vector2, t: float, c: Color, n: int, spread: float, period: float, kind: String) -> void:
	for i in n:
		var u = _fr(t / period + float(i) / n)
		var sd = sin(i * 12.9898) * 0.5 + 0.5
		var dx = (sd - 0.5) * 2.0 * spread
		var a = 1.0 - u
		var x: float; var y: float
		match kind:
			"spark", "chip":   # 向上噴再跌
				x = p.x + dx * u; y = p.y - sin(u * PI) * spread * 0.9 + u * 10.0
			"leaf", "sheet", "coin", "petal", "flake", "scrap":   # 由上飄落、左右擺
				x = p.x + dx * 0.6 + sin(u * 8.0 + i) * 10.0; y = p.y - 20.0 + u * spread * 1.2
			_:
				x = p.x + dx * u; y = p.y - u * spread * 0.6
		match kind:
			"spark": Art.el(ctx, x, y, 1.8, 1.8, _rgba(c, a))
			"chip": Art.rr(ctx, x - 2, y - 1, 4, 2.5, 1, _rgba(c, a))
			"leaf": Art.el(ctx, x, y, 4.5, 2.2, _rgba(c, a))
			"sheet": Art.rr(ctx, x - 5, y - 4 + sin(u * 10.0) * 2.0, 10, 8 * absf(cos(u * 6.0 + i)) + 1, 1, _rgba(c, a), _rgba(Color("#6a5a3a"), a), 0.8)
			"coin": Art.rr(ctx, x - 4, y - 3, 8, 6 * absf(cos(u * 7.0 + i)) + 1, 1, _rgba(c, a), _rgba(Color("#8a5a10"), a), 0.8)
			"petal": Art.el(ctx, x, y, 3.0, 2.0, _rgba(c, a))
			"flake": _flake(ctx, x, y, 3.5, _rgba(c, a))
			"scrap": Art.poly(ctx, [x - 3, y - 2, x + 3, y - 3, x + 2, y + 3], _rgba(c, a))
			"straw": ctx.strokeStyle = _rgba(c, a); ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(x - 4, y); ctx.lineTo(x + 4, y - 3); ctx.stroke()
			"stick": Art.rr(ctx, x - 1.2, y - 6, 2.4, 12, 1, _rgba(Color("#d8b880"), a))
			_: Art.el(ctx, x, y, 1.5, 1.5, _rgba(c, a))
static func _flake(ctx: Ctx, x: float, y: float, r: float, col: String) -> void:
	ctx.strokeStyle = col; ctx.lineWidth = 1.2
	for k in 3:
		var a = k * PI / 3.0
		ctx.beginPath(); ctx.moveTo(x - cos(a) * r, y - sin(a) * r); ctx.lineTo(x + cos(a) * r, y + sin(a) * r); ctx.stroke()
static func _bucket(ctx: Ctx, p: Vector2, t: float) -> void:
	var y = p.y + 8.0 - (0.5 + 0.5 * sin(t * 2.4)) * 26.0
	ctx.strokeStyle = "#5a4020"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(p.x, p.y - 26); ctx.lineTo(p.x, y - 8); ctx.stroke()
	Art.poly(ctx, [p.x - 8, y - 8, p.x + 8, y - 8, p.x + 6, y + 4, p.x - 6, y + 4], "#8a6038", "#3a2410", 1.2)
	Art.el(ctx, p.x, y - 8, 7, 2, "#f6f0e0")
static func _drip(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 3:
		var u = _fr(t * 0.9 + i / 3.0)
		Art.el(ctx, p.x + (i - 1) * 6.0, p.y + u * 22.0, 2.0, 2.8, _rgba(c, 1.0 - u * 0.7))
	Art.el(ctx, p.x, p.y + 25, 8 + sin(t * 3.0) * 1.0, 2.2, _rgba(c, 0.5))
static func _mill(ctx: Ctx, p: Vector2, r: Rect2, t: float) -> void:
	var rr = r.size.x * 0.2; var a = t * 2.4
	ctx.strokeStyle = "rgba(60,50,40,.75)"; ctx.lineWidth = 2
	for k in 3:
		var an = a + k * TAU / 3.0
		ctx.beginPath(); ctx.moveTo(p.x + cos(an) * rr * 0.3, p.y + sin(an) * rr * 0.12); ctx.lineTo(p.x + cos(an) * rr, p.y + sin(an) * rr * 0.4); ctx.stroke()
	Art.el(ctx, p.x + cos(a) * rr * 0.8, p.y + sin(a) * rr * 0.32 - 10, 3, 9, "#7a5a3a")   # 磨柄
static func _flow(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	ctx.strokeStyle = _rgba(c, 0.85); ctx.lineWidth = 3.0 + sin(t * 6.0)
	ctx.beginPath(); ctx.moveTo(p.x - 6, p.y - 4); ctx.quadraticCurveTo(p.x + 6, p.y, p.x + 8, p.y + 16); ctx.stroke()
	Art.el(ctx, p.x + 8, p.y + 18, 7, 2.5, _rgba(c, 0.7))
static func _saw(ctx: Ctx, p: Vector2, t: float) -> void:
	var dx = sin(t * 9.0) * 12.0
	Art.poly(ctx, [p.x - 18 + dx, p.y - 4, p.x + 14 + dx, p.y - 4, p.x + 14 + dx, p.y + 4, p.x - 18 + dx, p.y + 6], "#cfd4dc", "#4a4a50", 1.2)
	for i in 6: Art.poly(ctx, [p.x - 16 + dx + i * 5, p.y + 4, p.x - 13 + dx + i * 5, p.y + 8, p.x - 11 + dx + i * 5, p.y + 4], "#9aa0a8")
	Art.rr(ctx, p.x + 13 + dx, p.y - 7, 10, 12, 3, "#8a5a2a", "#3a2410", 1)
static func _flame(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	var fl = 0.75 + 0.25 * sin(t * 13.0) * sin(t * 7.3)
	Art.el(ctx, p.x, p.y, 30 * fl, 22 * fl, _rgba(c, 0.22)); Art.el(ctx, p.x, p.y, 16 * fl, 12 * fl, _rgba(c, 0.3))
	for i in 3:
		var h = 10.0 + 6.0 * sin(t * 11.0 + i * 2.0)
		Art.poly(ctx, [p.x - 8 + i * 6, p.y + 4, p.x - 5 + i * 6, p.y - h, p.x - 2 + i * 6, p.y + 4], _rgba(Color("#ffd060"), 0.85))
static func _durian(ctx: Ctx, p: Vector2, r: Rect2, t: float) -> void:
	var u = _fr(t * 0.45)
	var floor_y = r.position.y + r.size.y - 6.0
	var y: float
	if u < 0.5: y = lerpf(p.y, floor_y, (u / 0.5) * (u / 0.5))
	else: y = floor_y - absf(sin((u - 0.5) / 0.5 * PI * 2.0)) * 12.0 * (1.0 - u)
	var x = p.x + u * 18.0
	Art.el(ctx, x, y - 6, 7, 6, "#a8a838", "#4a5010", 1.2)
	for k in 6:
		var an = k * TAU / 6.0
		Art.el(ctx, x + cos(an) * 6.5, y - 6 + sin(an) * 5.5, 1.5, 1.5, "#4a5010")
static func _bubbles(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 5:
		var u = _fr(t * 0.7 + i * 0.2)
		var x = p.x + sin(i * 3.1 + u * 4.0) * 10.0
		Art.el(ctx, x, p.y - u * 30.0, 2.5 + u * 2.5, 2.5 + u * 2.5, null, _rgba(c, 1.0 - u), 1.4)
static func _bend(ctx: Ctx, p: Vector2, r: Rect2, t: float) -> void:
	var b = sin(t * 2.0) * 0.5 + 0.5
	ctx.strokeStyle = "#c8b048"; ctx.lineWidth = 2
	for i in 5:
		var x = p.x + i * 8.0 - 8.0; var y = p.y + 14
		ctx.beginPath(); ctx.moveTo(x, y); ctx.quadraticCurveTo(x + 2, y - 12, x + 4 + b * 8, y - 18 + b * 6); ctx.stroke()
		Art.el(ctx, x + 4 + b * 8, y - 18 + b * 6, 2.2, 3.5, "#e8c860")
static func _mist(ctx: Ctx, p: Vector2, r: Rect2, t: float, c: Color) -> void:
	for i in 4:
		var an = t * 0.8 + i * TAU / 4.0
		Art.el(ctx, p.x + cos(an) * r.size.x * 0.35, p.y + sin(an) * 10.0, 18, 7, _rgba(c, 0.28))
static func _glow(ctx: Ctx, p: Vector2, t: float, c: Color, rad: float) -> void:
	var fl = 0.8 + 0.2 * sin(t * 9.0) * sin(t * 4.1)
	Art.el(ctx, p.x, p.y, rad * 1.6 * fl, rad * 1.6 * fl, _rgba(c, 0.16)); Art.el(ctx, p.x, p.y, rad * fl, rad * fl, _rgba(c, 0.28)); Art.el(ctx, p.x, p.y, rad * 0.35, rad * 0.35, _rgba(c, 0.6))
static func _heat(ctx: Ctx, p: Vector2, t: float) -> void:
	ctx.strokeStyle = "rgba(255,230,190,.45)"; ctx.lineWidth = 1.6
	for i in 3:
		var x = p.x + (i - 1) * 10.0; var o = t * 3.0 + i
		ctx.beginPath(); ctx.moveTo(x, p.y)
		for k in 5: ctx.lineTo(x + sin(o + k) * 3.0, p.y - k * 6.0)
		ctx.stroke()
static func _stack(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	var n = int(_fr(t * 0.25) * 6.0) + 1
	for i in n: Art.rr(ctx, p.x - 9 + sin(i * 2.3) * 1.5, p.y - i * 4.0, 18, 4, 1, _rgba(c, 1.0), "#6a5a3a", 0.8)
static func _needle(ctx: Ctx, p: Vector2, t: float) -> void:
	var u = _fr(t * 1.2)
	var q = Vector2(p.x + sin(u * TAU) * 10.0, p.y - absf(sin(u * PI)) * 16.0)
	ctx.strokeStyle = "#d02a2a"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(p.x - 10, p.y + 4); ctx.quadraticCurveTo(p.x, p.y + 8, q.x, q.y); ctx.stroke()
	ctx.strokeStyle = "#e8e8f0"; ctx.lineWidth = 2; ctx.beginPath(); ctx.moveTo(q.x, q.y); ctx.lineTo(q.x + 5, q.y - 7); ctx.stroke()
static func _slap(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	var u = _fr(t * 0.6)
	var s = 1.0 if u > 0.3 else 1.6 - u * 2.0
	var a = 1.0 if u < 0.85 else (1.0 - u) / 0.15
	Art.rr(ctx, p.x - 9 * s, p.y - 11 * s, 18 * s, 22 * s, 1, _rgba(c, a), _rgba(Color("#5a4a2a"), a), 1)
	ctx.strokeStyle = _rgba(Color("#5a3a2a"), a); ctx.lineWidth = 1
	for k in 3: ctx.beginPath(); ctx.moveTo(p.x - 6 * s, p.y - 4 * s + k * 5 * s); ctx.lineTo(p.x + 6 * s, p.y - 4 * s + k * 5 * s); ctx.stroke()
	Art.el(ctx, p.x, p.y - 8 * s, 2, 2, _rgba(Color("#c03030"), a))
static func _curl(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	var k = 0.5 + 0.5 * sin(t * 1.6)
	ctx.strokeStyle = _rgba(c, 0.9); ctx.lineWidth = 3
	for i in 2:
		var s = 1.0 if i == 0 else -1.0
		ctx.beginPath(); ctx.moveTo(p.x, p.y + 10)
		ctx.bezierCurveTo(p.x + s * 18, p.y, p.x + s * 22 * (1.0 - k), p.y - 18, p.x + s * 8 * (1.0 - k), p.y - 22 + k * 10); ctx.stroke()
static func _fireflies(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 5:
		var a = t * (0.6 + i * 0.13) + i * 1.7
		var x = p.x + cos(a) * (22 + i * 3); var y = p.y + sin(a * 1.3) * 14
		var bl = 0.5 + 0.5 * sin(t * 5.0 + i * 2.0)
		Art.el(ctx, x, y, 4, 4, _rgba(c, 0.25 * bl)); Art.el(ctx, x, y, 1.6, 1.6, _rgba(c, 0.9 * bl))
static func _fish(ctx: Ctx, p: Vector2, t: float) -> void:
	for i in 2:
		var a = sin(t * 3.0 + i * 1.4) * 0.5
		var q = p + Vector2((i - 0.5) * 22.0, 0)
		ctx.strokeStyle = "#5a4a3a"; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(q.x, q.y - 8); ctx.lineTo(q.x + sin(a) * 12, q.y + 4); ctx.stroke()
		var f = q + Vector2(sin(a) * 14.0, 8)
		ctx.save(); ctx.translate(f.x, f.y); ctx.rotate(a + PI / 2)
		Art.el(ctx, 0, 0, 9, 3.5, "#c8b898", "#5a4a3a", 1); Art.poly(ctx, [8, 0, 13, -4, 13, 4], "#a89878")
		ctx.restore()
static func _arm(ctx: Ctx, p: Vector2, t: float) -> void:
	var u = absf(sin(t * 1.4))
	var e = p + Vector2(-10.0 - u * 46.0, 8.0 + u * 10.0)
	ctx.strokeStyle = "#e8e0d8"; ctx.lineWidth = 4
	ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.quadraticCurveTo((p.x + e.x) / 2.0, p.y - 10, e.x, e.y); ctx.stroke()
	ctx.strokeStyle = "#a89890"; ctx.lineWidth = 1; ctx.stroke()
	Art.el(ctx, e.x, e.y, 4, 3.5, "#efe6e0", "#8a7a70", 1)
	if u > 0.6: Art.el(ctx, e.x - 2, e.y + 4, 4, 4, "#f0d830", "#8a7a10", 1)
static func _lemons(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 3:
		var u = _fr(t * 0.8 + i / 3.0)
		Art.el(ctx, p.x - 8 + i * 8, p.y + 4 - absf(sin(u * PI)) * 10.0, 3.5, 3.5, _rgba(c, 1.0), "#7a6a10", 0.8)
	Art.rr(ctx, p.x + 12, p.y - 2, 6, 6, 1, "rgba(220,240,255,.8)")   # 冰
static func _ring(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	var sx = cos(t * 3.0)
	ctx.save(); ctx.translate(p.x, p.y); ctx.scale(maxf(0.15, absf(sx)), 1.0)
	Art.el(ctx, 0, 0, 14, 14, null, _rgba(c, 1.0), 6)
	for k in 4:
		var an = k * PI / 2.0
		Art.el(ctx, cos(an) * 14, sin(an) * 14, 3, 3, "#ffffff")
	ctx.restore()
static func _blow(ctx: Ctx, p: Vector2, t: float) -> void:
	for i in 3:
		var u = _fr(t * 0.9 + i / 3.0)
		ctx.strokeStyle = "rgba(200,230,255,%s)" % str(snappedf(0.7 * (1.0 - u), 0.01)); ctx.lineWidth = 1.5
		ctx.beginPath(); ctx.arc(p.x + u * 24.0, p.y - u * 8.0, 4 + u * 6, -0.9, 0.9); ctx.stroke()
static func _ripple(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 3:
		var u = _fr(t * 0.45 + i / 3.0)
		Art.el(ctx, p.x, p.y, 10 + u * 36, 3 + u * 9, null, _rgba(c, 0.7 * (1.0 - u)), 1.5)
static func _quill(ctx: Ctx, p: Vector2, t: float) -> void:
	var x = p.x - 10 + _fr(t * 0.5) * 20.0; var y = p.y + sin(t * 14.0) * 1.5
	ctx.strokeStyle = "#f0f0f0"; ctx.lineWidth = 2; ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x + 10, y - 16); ctx.stroke()
	ctx.strokeStyle = "rgba(30,30,60,.8)"; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(p.x - 10, p.y + 1); ctx.lineTo(x, y + 1); ctx.stroke()
static func _wheel(ctx: Ctx, p: Vector2, t: float) -> void:
	var a = t * 10.0
	Art.el(ctx, p.x, p.y, 9, 9, null, "#2a2a30", 2.5)
	ctx.strokeStyle = "#d8d8e0"; ctx.lineWidth = 1.5
	for k in 3:
		var an = a + k * PI / 3.0
		ctx.beginPath(); ctx.moveTo(p.x - cos(an) * 8, p.y - sin(an) * 8); ctx.lineTo(p.x + cos(an) * 8, p.y + sin(an) * 8); ctx.stroke()
static func _zap(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	if fmod(t, 0.7) > 0.35: return
	ctx.strokeStyle = _rgba(c, 0.95); ctx.lineWidth = 2
	for b in 2:
		var x = p.x + (b - 0.5) * 24.0; var y = p.y - 10
		ctx.beginPath(); ctx.moveTo(x, y)
		for k in 4: ctx.lineTo(x + (6 if k % 2 == 0 else -6) + sin(t * 40.0 + k) * 2.0, y - 6 - k * 6)
		ctx.stroke()
	Art.el(ctx, p.x, p.y, 20, 14, _rgba(c, 0.18))
static func _eye(ctx: Ctx, p: Vector2, t: float) -> void:
	var bl = 1.0 if fmod(t, 3.0) > 0.15 else 0.1
	Art.el(ctx, p.x, p.y, 8, 5 * bl, "#f8f8ff", "#202030", 1.2)
	var lx = sin(t * 0.9) * 3.0
	if bl > 0.5: Art.el(ctx, p.x + lx, p.y, 2.6, 2.6, "#c02020")
static func _tick(ctx: Ctx, p: Vector2, t: float) -> void:
	Art.el(ctx, p.x, p.y, 10, 10, "#f8f0dc", "#4a3a20", 1.5)
	var a = -PI / 2.0 + PI * 0.5 + sin(t * 20.0) * 0.08   # 卡死喺三點，指針震
	ctx.strokeStyle = "#2a2020"; ctx.lineWidth = 2
	ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.lineTo(p.x + cos(a) * 7, p.y + sin(a) * 7); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.lineTo(p.x, p.y - 5); ctx.stroke()
static func _exhaust(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 4:
		var u = _fr(t * 0.9 + i * 0.25)
		Art.el(ctx, p.x - u * 30.0, p.y - u * 10.0 + sin(u * 9.0) * 2.0, 4 + u * 9, 3 + u * 7, _rgba(c, 0.55 * (1.0 - u)))
static func _beam(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	var fl = 0.7 + 0.3 * sin(t * 6.0)
	Art.poly(ctx, [p.x, p.y - 3, p.x + 40, p.y - 12, p.x + 40, p.y + 10, p.x, p.y + 3], "rgba(255,240,180,%s)" % str(snappedf(0.25 * fl, 0.01)))
	Art.el(ctx, p.x, p.y, 4, 4, "#fff6c0")
static func _bulbs(ctx: Ctx, p: Vector2, r: Rect2, t: float, c: Color) -> void:
	var n = 7; var w = r.size.x * 0.7
	for i in n:
		var on = int(t * 6.0 + i) % 3 != 0
		var x = p.x - w / 2.0 + w * i / (n - 1)
		if on: Art.el(ctx, x, p.y, 5, 5, _rgba(c, 0.3))
		Art.el(ctx, x, p.y, 2.4, 2.4, _rgba(c, 1.0) if on else "rgba(80,70,50,.9)")
static func _flicker(ctx: Ctx, p: Vector2, r: Rect2, t: float, c: Color) -> void:
	var a = 0.12 + 0.18 * absf(sin(t * 17.0) * sin(t * 3.0))
	Art.rr(ctx, p.x - r.size.x * 0.25, p.y - 12, r.size.x * 0.5, 24, 2, "rgba(200,220,255,%s)" % str(snappedf(a, 0.01)))
static func _ladle(ctx: Ctx, p: Vector2, t: float) -> void:
	var a = t * 2.6
	var q = p + Vector2(cos(a) * 12.0, sin(a) * 4.0)
	ctx.strokeStyle = "#5a4030"; ctx.lineWidth = 2.5; ctx.beginPath(); ctx.moveTo(q.x, q.y); ctx.lineTo(q.x + 6, q.y - 22); ctx.stroke()
	Art.el(ctx, p.x, p.y + 2, 14, 3.5, "rgba(230,240,255,.35)")
static func _copier(ctx: Ctx, p: Vector2, r: Rect2, t: float, c: Color) -> void:
	var u = _fr(t * 0.8)
	var x = p.x - r.size.x * 0.3 + u * r.size.x * 0.6
	Art.rr(ctx, x - 3, p.y - 14, 6, 28, 2, "rgba(190,255,190,.55)")
	Art.el(ctx, x, p.y, 10, 16, "rgba(190,255,190,.15)")
static func _frost(ctx: Ctx, p: Vector2, r: Rect2, t: float, c: Color) -> void:
	for i in 6:
		var s = sin(i * 7.7) * 0.5 + 0.5; var s2 = cos(i * 3.3) * 0.5 + 0.5
		var tw = 0.5 + 0.5 * sin(t * 4.0 + i * 1.9)
		_flake(ctx, p.x + (s - 0.5) * r.size.x * 0.7, p.y + (s2 - 0.5) * 30.0, 3.0 + 2.0 * tw, _rgba(c, 0.4 + 0.6 * tw))
static func _stamp(ctx: Ctx, p: Vector2, t: float) -> void:
	var u = _fr(t * 0.9)
	var h = 18.0 * (1.0 - absf(sin(u * PI))) if u < 0.5 else 18.0 * (u - 0.5) * 2.0
	Art.rr(ctx, p.x - 6, p.y - 16 - h, 12, 10, 2, "#8a2a20", "#3a1008", 1)
	Art.rr(ctx, p.x - 3, p.y - 26 - h, 6, 10, 2, "#6a4a30")
	if u > 0.22 and u < 0.6:
		Art.el(ctx, p.x, p.y - 2, 8, 3, "rgba(200,40,40,.8)")
		for k in 4:
			var an = k * PI / 2.0 + 0.4
			Art.el(ctx, p.x + cos(an) * 14, p.y - 2 + sin(an) * 5, 1.5, 1.5, "#ffffff")
static func _zzz(ctx: Ctx, p: Vector2, t: float, c: Color) -> void:
	for i in 3:
		var u = _fr(t * 0.4 + i / 3.0)
		var a = 1.0 - u
		ctx.font = "900 %dpx sans-serif" % int(14 + u * 6); ctx.textAlign = "center"; ctx.textBaseline = "middle"
		ctx.lineWidth = 3; ctx.strokeStyle = "rgba(10,6,4,%s)" % str(snappedf(a, 0.01)); ctx.strokeText("z", p.x + u * 16, p.y - u * 26)
		ctx.fillStyle = _rgba(c, a); ctx.fillText("z", p.x + u * 16, p.y - u * 26)
