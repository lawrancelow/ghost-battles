# 冥街夜市畫面（原生）：ghoststreet.js draw() 逐段搬過嚟，數值同次序一樣
#  - 狀態（阿福、店主、閒鬼、粒子、霧、飄字）全部讀 JS GhostStreet；JS 只做 step()
#  - 角色：一般動作用原生 Art；有「平日動作」（TOWN act）嘅交返 JS ART.drawChar（動作函數喺 JS）
class_name GsDraw

static var _bg_sz := Vector2.ZERO
static var _font: Font = null

static func _n(v) -> float: return J.num(v)

static func geo(G: Dictionary) -> Vector2:
	if _bg_sz == Vector2.ZERO:
		var tex = Spr.get_tex("bg_street")
		_bg_sz = tex.get_size() if tex else Vector2(1536, 1024)
	var IH = _n(G.get("vh", 0)); if IH <= 0: IH = 500.0
	var IW = IH * _bg_sz.x / _bg_sz.y
	var W = _n(G.get("W", 390))
	if IW < W * 1.15: IW = W * 1.15; IH = IW * _bg_sz.y / _bg_sz.x
	return Vector2(IW, IH)

static func draw(ctx: Ctx, G: Dictionary, t: float) -> void:
	var g = geo(G); var W = _n(G.W); var H = _n(G.H); var cam = _n(G.cam)
	var X = func(fx): return (fx - cam) * g.x
	var Y = func(fy): return fy * g.y
	ctx.fillStyle = "#0c0a12"; ctx.fillRect(0, 0, W, H)
	var img = Spr.get_tex("bg_street")
	if img:
		ctx.ci.draw_set_transform_matrix(ctx.T); ctx.ci.draw_texture_rect(img, Rect2(-cam * g.x, 0, g.x, g.y), false); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	var bot = ctx.createLinearGradient(0, g.y - 30, 0, g.y + 40); bot.addColorStop(0, "rgba(12,10,18,0)"); bot.addColorStop(1, "rgba(12,10,18,1)")
	ctx.fillStyle = bot; ctx.fillRect(0, g.y - 30, W, H - g.y + 30)
	# 月光、燈籠光暈（加亮）
	ctx.save(); ctx.globalCompositeOperation = "lighter"
	_glow(ctx, X.call(0.785), Y.call(0.085), g.y * 0.16, Color(140 / 255.0, 1, 170 / 255.0, 0.10 + 0.04 * sin(t * 0.8)))
	var LS = J.G.get("GS_LANTERNS"); var i = 0
	for l in LS:
		var fl = 0.16 + 0.07 * sin(t * 3.1 + i * 1.7) + 0.04 * sin(t * 7.3 + i)
		_glow(ctx, X.call(_n(l[0])) + sin(t * 1.3 + i) * 2, Y.call(_n(l[1])), g.y * 0.06, Color(1, 120 / 255.0, 60 / 255.0, fl)); i += 1
	_glow(ctx, X.call(0.58), Y.call(0.52), g.y * 0.12, Color(1, 200 / 255.0, 110 / 255.0, 0.08 + 0.03 * sin(t * 2)))
	ctx.restore()
	_fog(ctx, G, g, t, false, X, Y)
	_parts(ctx, G, g, "steam", X, Y, W)
	# 人物（後面嘅先畫）
	var list = []
	var KP: Dictionary = G.keepers
	for k in KP: list.append([_n(KP[k].y), 0, k])
	for w in G.walkers: list.append([_n(w.y), 1, w])
	list.append([_n(G.afu.y), 2, null])
	_parts(ctx, G, g, "dust", X, Y, W)
	list.sort_custom(func(a, b): return a[0] < b[0])
	for o in list:
		match o[1]:
			0: _keeper(ctx, G, g, o[2], t, X, Y, W)
			1: _walker(ctx, G, g, o[2], t, X, Y, W)
			2: _afu(ctx, G, g, t, X, Y)
	_fog(ctx, G, g, t, true, X, Y)
	_parts(ctx, G, g, "mist", X, Y, W); _parts(ctx, G, g, "joss", X, Y, W)
	_lanterns(ctx, G, g, t, W)
	_signs(ctx, G, g, t, X, Y, W)
	for k in KP:
		var kp = KP[k]
		if _n(kp.get("bubT", 0)) > 0: _bubble(ctx, G, g, kp, J.str(kp.bub), _n(kp.bubT), X, Y, W)
	for w in G.walkers:
		if _n(w.get("bubT", 0)) > 0: _bubble(ctx, G, g, w, J.str(w.bub), _n(w.bubT), X, Y, W)
	# 飄字
	ctx.textAlign = "center"; ctx.font = "900 17px sans-serif"
	for f in G.floats:
		var k2 = _n(f.life) / _n(f.max); var x = X.call(_n(f.x)); var y = Y.call(_n(f.y)) - (1 - k2) * 40
		ctx.globalAlpha = minf(1, k2 * 2); ctx.lineWidth = 4; ctx.strokeStyle = "rgba(0,0,0,.8)"; ctx.strokeText(J.str(f.text), x, y)
		ctx.fillStyle = J.str(f.col); ctx.fillText(J.str(f.text), x, y)
	ctx.globalAlpha = 1

static func _glow(ctx: Ctx, x: float, y: float, r: float, c: Color) -> void:
	var gr = ctx.createRadialGradient(x, y, 0, x, y, r); gr.addColorStop(0, c); gr.addColorStop(1, Color(0, 0, 0, 0))
	ctx.fillStyle = gr; ctx.fillRect(x - r, y - r, r * 2, r * 2)

static func _fog(ctx: Ctx, G: Dictionary, g: Vector2, t: float, front: bool, X: Callable, Y: Callable) -> void:
	var cam = _n(G.cam); var i = 0
	for f in G.fog:
		var fy = _n(f.y)
		if (fy > 0.84) != front: i += 1; continue
		var x = X.call(_n(f.x) + cam * (-0.15 if front else 0.0)); var y = Y.call(fy); var r = _n(f.r) * g.x * 0.5
		ctx.save(); ctx.translate(x, y); ctx.scale(1, 0.32)
		var a = _n(f.a) * (0.8 + 0.2 * sin(t * 0.7 + i))
		var gr = ctx.createRadialGradient(0, 0, 0, 0, 0, r); gr.addColorStop(0, Color(200 / 255.0, 190 / 255.0, 230 / 255.0, a)); gr.addColorStop(1, Color(200 / 255.0, 190 / 255.0, 230 / 255.0, 0))
		ctx.fillStyle = gr; ctx.fillRect(-r, -r, r * 2, r * 2); ctx.restore()
		i += 1

static func _parts(ctx: Ctx, G: Dictionary, g: Vector2, kind: String, X: Callable, Y: Callable, W: float) -> void:
	for p in G.parts:
		if J.str(p.kind) != kind: continue
		var x = X.call(_n(p.x)); var y = Y.call(_n(p.y)); var k = _n(p.life) / _n(p.max)
		if x < -60 or x > W + 60: continue
		match kind:
			"joss":
				var sz = g.y * 0.016
				ctx.save(); ctx.globalAlpha = minf(1, _n(p.life) * 0.6) * 0.92; ctx.translate(x, y); ctx.rotate(_n(p.rot)); ctx.scale(1, cos(_n(p.flip)))
				ctx.fillStyle = "#e8c35a"; ctx.strokeStyle = "#6a4a14"; ctx.lineWidth = 0.8; ctx.fillRect(-sz, -sz * 0.7, sz * 2, sz * 1.4); ctx.strokeRect(-sz, -sz * 0.7, sz * 2, sz * 1.4)
				ctx.fillStyle = "#b8322a"; ctx.fillRect(-sz * 0.35, -sz * 0.35, sz * 0.7, sz * 0.7); ctx.restore()
			"steam":
				var r = _n(p.r) * (2 - k) * g.y / 500
				ctx.fillStyle = Color(240 / 255.0, 235 / 255.0, 1, 0.22 * k * (1 - k) * 3); ctx.beginPath(); ctx.arc(x + sin(_n(p.life) * 3 + _n(p.r)) * 4, y, r, 0, 7); ctx.fill()
			"mist":
				var r = _n(p.r) * g.y / 500 * (1.6 - k * 0.6)
				_glow(ctx, x, y, r, Color(210 / 255.0, 220 / 255.0, 240 / 255.0, 0.16 * sin(k * PI)))
			"dust":
				var r = _n(p.r) * (1.6 - k) * g.y / 600
				ctx.fillStyle = Color(190 / 255.0, 170 / 255.0, 200 / 255.0, 0.4 * k); ctx.beginPath(); ctx.ellipse(x, y, r * 1.4, r * 0.8, 0, 0, 7); ctx.fill()

static func _lanterns(ctx: Ctx, G: Dictionary, g: Vector2, t: float, W: float) -> void:
	var par = 1.25; var top = -4.0; var sag = g.y * 0.06; var gap = g.x * 0.16
	var off = -_n(G.cam) * g.x * par; var n0 = int(floor(-off / gap)) - 1
	ctx.save(); ctx.strokeStyle = "rgba(30,18,24,.9)"; ctx.lineWidth = 1.6
	for i in range(n0, n0 + int(ceil(W / gap)) + 3):
		var x0 = off + i * gap; var x1 = x0 + gap
		ctx.beginPath(); ctx.moveTo(x0, top); ctx.quadraticCurveTo((x0 + x1) / 2, top + sag * 2, x1, top); ctx.stroke()
		var mx = (x0 + x1) / 2; var my = top + sag; var sw = sin(t * 1.6 + i * 1.3) * 0.22; var L = g.y * 0.035; var r = g.y * 0.028
		ctx.save(); ctx.translate(mx, my); ctx.rotate(sw)
		ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, L); ctx.stroke()
		ctx.globalCompositeOperation = "lighter"; _glow(ctx, 0, L + r, r * 3, Color(1, 110 / 255.0, 60 / 255.0, 0.22 + 0.06 * sin(t * 4 + i))); ctx.globalCompositeOperation = "source-over"
		ctx.fillStyle = "#f2e6c8" if posmod(i, 3) == 1 else "#c8322a"; ctx.strokeStyle = "#2a1010"; ctx.lineWidth = 1.6
		ctx.beginPath(); ctx.ellipse(0, L + r, r * 0.85, r, 0, 0, 7); ctx.fill(); ctx.stroke()
		ctx.strokeStyle = "rgba(40,10,10,.45)"; ctx.lineWidth = 1; ctx.beginPath(); ctx.ellipse(0, L + r, r * 0.4, r, 0, 0, 7); ctx.stroke()
		ctx.fillStyle = "#e2b04a"; ctx.fillRect(-r * 0.45, L - 2, r * 0.9, 3); ctx.fillRect(-r * 0.45, L + r * 2 - 1, r * 0.9, 3)
		ctx.strokeStyle = "#c8322a"; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.moveTo(0, L + r * 2 + 2); ctx.lineTo(sin(t * 2.4 + i) * 2, L + r * 2 + r * 0.9); ctx.stroke()
		ctx.restore(); ctx.strokeStyle = "rgba(30,18,24,.9)"; ctx.lineWidth = 1.6
	ctx.restore()

static func _near(G: Dictionary) -> String:
	var A = G.afu; var best = ""; var bd = 0.09; var ST = J.G.GS_STALLS
	for k in J.G.GS_ORDER:
		var d = absf(_n(A.x) - _n(ST[k].x))
		if d < bd: bd = d; best = k
	return best

static func _signs(ctx: Ctx, G: Dictionary, g: Vector2, t: float, X: Callable, Y: Callable, W: float) -> void:
	var near = _near(G); var ST = J.G.GS_STALLS
	ctx.save(); ctx.font = "800 14px sans-serif"; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	for k in J.G.GS_ORDER:
		var s = ST[k]; var sx = _n(s.x)
		var x = X.call(0.945 if k == "alley" else sx); var y = Y.call(0.30 if k == "alley" else 0.39) + sin(t * 1.5 + sx * 9) * 1.5
		if x < -60 or x > W + 60: continue
		var nm = J.str(DB.L(J.str(s.name)))
		var w = _n(ctx.measureText(nm).width) + 16; var on = near == k
		Art.rr(ctx, x - w / 2, y - 12, w, 24, 4, "rgba(194,54,43,.94)" if on else "rgba(20,12,22,.72)", "#f3d68a" if on else "rgba(243,214,138,.55)", 1.2)
		ctx.fillStyle = "#fff3e0" if on else "#f3d68a"; ctx.fillText(nm, x, y + 1)
	ctx.restore()

static func _scale(g: Vector2, fy: float) -> float:
	return g.y * 0.25 / 58.0 * (0.84 + 0.36 * clampf((fy - 0.72) / 0.23, 0, 1))

static func _dc(ctx: Ctx, k: String, x: float, y: float, s: float, o: Dictionary) -> void:
	if o.get("act") != null: J.mc(J.G.ART, "drawChar", [ctx, k, x, y, s, o])
	else: Art.draw_char(ctx, k, x, y, s, o)

static func _afu(ctx: Ctx, G: Dictionary, g: Vector2, t: float, X: Callable, Y: Callable) -> void:
	var A = G.afu; var sc = _scale(g, _n(A.y))
	var pose = A.get("pose"); var walking = J.t(A.get("walking"))
	var o = {"t": t, "walk": walking, "flip": _n(A.dir) < 0, "tamed": true, "untied": true, "pt": (1 - maxf(0, _n(A.get("poseT", 0)))) if J.t(pose) else 0.0}
	if not walking and J.t(pose): o["pose"] = pose
	Art.draw_char(ctx, "afu", X.call(_n(A.x)), Y.call(_n(A.y)), sc, o)

static func _keeper(ctx: Ctx, G: Dictionary, g: Vector2, k: String, t: float, X: Callable, Y: Callable, W: float) -> void:
	var kp = G.keepers[k]; var kk = J.str(kp.k)
	var sc = _scale(g, _n(kp.y)) * (1.05 if kk == "xiaogui" else 0.9 if kk == "baiwu" else 1.0)
	var x = X.call(_n(kp.x)); var y = Y.call(_n(kp.y))
	if x < -80 or x > W + 80: return
	var face = _n(G.afu.x) < _n(kp.x)
	var pose = kp.get("pose"); var pt = _n(kp.get("pt", 0))
	match J.str(pose):
		"strike": pt = fmod(t * 1.4, 1.0)
		"windup": pt = 0.35 + sin(t * 3) * 0.1
		"hurt": pt = 0.35 + sin(t * 9) * 0.05
	var o = {"t": t + _n(kp.ph), "flip": face, "pt": pt, "tamed": true, "untied": true}
	if J.t(pose): o["pose"] = pose
	var TOWN = J.G.get("TOWN")
	if TOWN != null and not J.t(pose):
		var da = {}
		if _n(kp.get("greet", 0)) > 0: da = {"act": "town_greet", "at": kp.gt, "adur": _n(kp.gt) + _n(kp.greet)}
		else:
			da = J.mc(TOWN, "opts", [kp.get("st")])
			if da is Dictionary and da.get("act") != null: face = _n(J.G.GS_WORKFACE[k]) < 0
			else: da = {}
		if kk == "eguiking": da["prop"] = {"potDX": X.call(_n(J.G.GS_POT[0])) - x, "potDY": Y.call(_n(J.G.GS_POT[1])) - y}
		o["flip"] = face
		for key in da: o[key] = da[key]
	_dc(ctx, kk, x, y, sc, o)

static func _walker(ctx: Ctx, G: Dictionary, g: Vector2, w: Dictionary, t: float, X: Callable, Y: Callable, W: float) -> void:
	var sc = _scale(g, _n(w.y)) * 0.92; var x = X.call(_n(w.x)); var y = Y.call(_n(w.y))
	if x < -80 or x > W + 80: return
	var o = {"t": t + _n(w.ph), "walk": J.t(w.get("walking")), "flip": _n(w.dir) < 0, "tamed": true, "untied": true, "alpha": 0.9}
	if J.G.get("TOWN") != null:
		var prop = w.get("prop")
		if _n(w.get("bump", 0)) > 0:
			var pr = (prop as Dictionary).duplicate() if prop is Dictionary else {}
			pr["sorry"] = w.get("sorry"); o["act"] = "town_bump"; o["at"] = w.bt; o["prop"] = pr
		elif _n(w.get("look", 0)) > 0: o["act"] = "town_look"; o["at"] = w.lt; o["adur"] = _n(w.lt) + _n(w.look); o["prop"] = prop
		elif prop != null: o["act"] = "town_walk"; o["at"] = 9.0; o["prop"] = prop
	_dc(ctx, J.str(w.k), x, y, sc, o)

static func _bubble(ctx: Ctx, G: Dictionary, g: Vector2, o: Dictionary, text: String, life: float, X: Callable, Y: Callable, W: float) -> void:
	var k = J.str(o.get("k")); var sc = _scale(g, _n(o.y))
	var h = 58 * sc * (1.25 if k == "baiwu" else 0.85 if k == "xiaogui" else 1.0)
	var x = X.call(_n(o.x)); var y = Y.call(_n(o.y)) - h - 10
	if x < -40 or x > W + 40: return
	text = J.str(DB.L(text))
	ctx.save(); ctx.font = "700 14px sans-serif"
	var maxW = 172.0; var lines = []; var cur = ""
	for ch in text:
		if _n(ctx.measureText(cur + ch).width) > maxW and not "。，、！？；：」）…—".contains(ch): lines.append(cur); cur = ch
		else: cur += ch
	if cur != "": lines.append(cur)
	var w = 0.0
	for l in lines: w = maxf(w, _n(ctx.measureText(l).width))
	w += 18; var hh = lines.size() * 19 + 12
	var bx = maxf(6, minf(W - w - 6, x - w / 2)); var by = maxf(6, y - hh)
	ctx.globalAlpha = minf(1, life * 3)
	Art.rr(ctx, bx, by, w, hh, 9, "rgba(244,236,214,.96)", "#3a2a1a", 1.5)
	var tx = maxf(bx + 10, minf(bx + w - 10, x))
	ctx.fillStyle = "rgba(244,236,214,.96)"; ctx.beginPath(); ctx.moveTo(tx - 6, by + hh - 1); ctx.lineTo(x, by + hh + 8); ctx.lineTo(tx + 6, by + hh - 1); ctx.fill()
	ctx.fillStyle = "#2a1a10"; ctx.textAlign = "left"; ctx.textBaseline = "alphabetic"
	for i in lines.size(): ctx.fillText(lines[i], bx + 9, by + 20 + i * 19)
	ctx.restore()
