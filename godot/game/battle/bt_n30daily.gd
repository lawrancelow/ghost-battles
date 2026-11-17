# 自動生成自 n30_daily.js（tools/jsgd/gen_n30d.js）——新鬼 40 隻平日小動作，原生版（用 BtN30 原生招式工具）
# 改原 JS 再生成：node tools/jsgd/gen_n30d.js <src>/n30_daily.js game/battle/bt_n30daily.gd
extends RefCounted

static func h_or(a, b): return a if a else b
static func h_g(f, n: String): return f.get(n)
static func h_at2(S: Dictionary, m: Transform2D, u: float, v: float) -> Array:
	var p = BtN30.at(S, m, u, v); return [p.x, p.y]
static func h_s(v) -> String: return J.str(v)
static func h_crayon(ctx: Ctx, pts: Array, col, w: float, seed_: float, _al = null) -> void:
	var P = []
	for p in pts: P.append(Vector2(p[0], p[1]))
	BtN30.crayon(ctx, P, col, w, seed_)
static func h_bolt(ctx: Ctx, a: Array, b: Array, w: float, seed_: float, col = null, al = null) -> void: BtN30d.bolt(ctx, Vector2(a[0], a[1]), Vector2(b[0], b[1]), w, seed_, col, al)
static func h_sw(g = null, n = null, ph = null):
	return sin(g * TAU * (h_or(n, 1)) + (h_or(ph, 0)))
static func h_env(g = null, a = null, b = null, c = null, d = null):
	return BtMoves.eio(BtN30.seg(g, a, b)) * (1 - BtMoves.eio(BtN30.seg(g, c, d)))
static func h_bump(g = null, a = null, b = null):
	return sin(BtN30.seg(g, a, b) * PI)
static func h_T(ctx = null, S = null, x = null, y = null, s = null, str_ = null, col = null, al = null):
	BtN30.txt(ctx, S, x, y, str_, s, col, al)
static func h_note(ctx = null, S = null, p = null, g = null, a = null, b = null, H = null, col = null):
	var q = BtN30.seg(g, a, b)
	if q > 0 and q < 1:
		h_T(ctx, S, p[0] + q * 0.12 * H, p[1] - q * 0.2 * H, 0.09 * H, ("♪" if q < 0.5 else "♫"), h_or(col, "#cfe8ff"), sin(q * PI))
static func h_zz(ctx = null, S = null, p = null, g = null, H = null):
	for i in range(0, 3):
		var q = fmod(g * 2 + i / 3.0, 1)
		h_T(ctx, S, p[0] + q * 0.12 * H, p[1] - q * 0.25 * H, (0.06 + i * 0.02) * H, "z", "#c8d8ff", sin(q * PI))
static func h_sweat(ctx = null, S = null, p = null, g = null, H = null):
	BtN30.drops(ctx, p[0], p[1], 0.25 * H, fmod(g * 3, 1), "rgba(150,210,255,.9)", floor(g * 3) * 7, 3)
static func h_flake(ctx = null, x = null, y = null, r = null, rot = null, al = null):
	ctx.save()
	ctx.globalAlpha *= al
	ctx.translate(x, y)
	ctx.rotate(rot)
	ctx.strokeStyle = "#eaf6ff"
	ctx.lineWidth = r * 0.22
	ctx.lineCap = "round"
	ctx.beginPath()
	for k in range(0, 3):
		var an = k * PI / 3.0
		ctx.moveTo(-cos(an) * r, -sin(an) * r)
		ctx.lineTo(cos(an) * r, sin(an) * r)
	ctx.stroke()
	ctx.restore()
static func h_coin(ctx = null, x = null, y = null, r = null, sx = null):
	ctx.save()
	ctx.translate(x, y)
	ctx.scale(sx, 1)
	ctx.fillStyle = "#e8b84a"
	ctx.strokeStyle = "#6a4a10"
	ctx.lineWidth = r * 0.18
	ctx.beginPath()
	ctx.arc(0, 0, r, 0, 7)
	ctx.fill()
	ctx.stroke()
	ctx.strokeRect(-r * 0.3, -r * 0.3, r * 0.6, r * 0.6)
	ctx.restore()
static func h_card(ctx = null, x = null, y = null, w = null, rot = null, red = null):
	ctx.save()
	ctx.translate(x, y)
	ctx.rotate(rot)
	ctx.fillStyle = "#fbf6ea"
	ctx.strokeStyle = "#3a2a2a"
	ctx.lineWidth = w * 0.1
	ctx.beginPath()
	ctx.roundRect(-w / 2.0, -w * 0.7, w, w * 1.4, w * 0.15)
	ctx.fill()
	ctx.stroke()
	ctx.fillStyle = ("#c8202a" if red else "#222")
	ctx.font = ("900 " + h_s(w * 0.8) + "px sans-serif")
	ctx.textAlign = "center"
	ctx.textBaseline = "middle"
	ctx.fillText(("♥" if red else "♠"), 0, 0)
	ctx.restore()
static func h_at(S = null, m = null, u = null, v = null):
	return h_at2(S, m, u, v)
static func fr_diaosi_swing(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g) * 6, "px": 0, "py": -1.2 * H, "rope": h_sw(g, 1, 0.8) * 0.4, "head": h_sw(g, 1, 0.5) * 0.1}
static func fr_diaosi_tongue(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": h_sw(g, 2) * 0.18 * h_env(g, 0, 0.1, 0.8, 1), "body": h_sw(g, 2, 0.5) * 0.05}
static func fx_diaosi_tongue(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.42, 0.58)
	BtN30.drops(ctx, p[0], p[1], 0.25 * H, fmod(g * 2, 1), "rgba(200,235,255,.9)", floor(g * 2) * 3, 4)
static func fr_diaosi_sigh(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"sy": 1 - 0.04 * h_bump(g, 0.2, 0.8), "head": 0.2 * h_bump(g, 0.2, 0.9), "armF": 0.1 * h_bump(g, 0.2, 0.8), "armB": -0.1 * h_bump(g, 0.2, 0.8)}
static func fx_diaosi_sigh(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.1 * H, "唉……", "#e0e0f0", h_bump(g, 0.25, 0.85))
static func fr_wutou_polish(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.6 - h_sw(g, 4) * 0.2, "body": -0.04, "held": h_sw(g, 4) * 0.04}
static func fx_wutou_polish(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	if g > 0.7:
		BtN30.burst(ctx, h_at(S, m, 0.72, 0.38)[0], h_at(S, m, 0.72, 0.38)[1], 0.1 * H, 1 - (g - 0.7) / 0.3, "#fff6c0", 1, 6)
static func fr_wutou_smoke(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"sy": 1 + 0.03 * h_bump(g, 0.1, 0.4), "head": h_sw(g, 2) * 0.1}
static func fx_wutou_smoke(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.34, 0.2)
	for i in range(0, 3):
		BtN30.puff(ctx, p[0], p[1] - 0.05 * H, 0.06 * H, fmod(g + i / 3.0, 1), "rgba(200,200,215,.55)", i * 9, 3)
static func fr_wutou_nod(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": h_sw(g, 2) * 0.12 * h_env(g, 0, 0.1, 0.8, 1), "held": h_sw(g, 2, 0.5) * 0.15 * h_env(g, 0, 0.1, 0.8, 1)}
static func fr_yecha_flex(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.7, 0.9)
	return {"sx": 1 + 0.05 * k, "sy": 1 + 0.02 * k, "armF": -0.25 * k, "armB": 0.3 * k, "hairL": -0.2 * k + h_sw(g, 3) * 0.05, "hairR": -0.2 * k}
static func fx_yecha_flex(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	if g > 0.3 and g < 0.7:
		BtN30.burst(ctx, 0.3 * H, -0.7 * H, 0.12 * H, 1 - (g - 0.3) / 0.4, "#fff0a0", 3, 6)
static func fr_yecha_scratch(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.3 + h_sw(g, 5) * 0.12, "body": h_sw(g, 5, 1) * 0.04, "r": h_sw(g, 2.5) * 2}
static func fx_yecha_scratch(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, -0.1 * H, -1.05 * H, 0.09 * H, "啊～", "#ffe0a0", h_bump(g, 0.4, 0.9))
static func fr_yecha_roar(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.15, 0.6)
	return {"head": -0.3 * k, "body": -0.08 * k, "armF": 0.1 * k, "y": -0.02 * H * k}
static func fx_yecha_roar(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.15 * H, -1.1 * H, 0.14 * H, "吼！", "#ff9a6a", h_bump(g, 0.2, 0.65))
static func fr_hanba_fan(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.8 + h_sw(g, 6) * 0.25, "head": -0.05}
static func fx_hanba_fan(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_sweat(ctx, S, h_at(S, m, 0.5, 0.15), g, H)
	BtN30.puff(ctx, 0.1 * H, -0.03 * H, 0.06 * H, g, "rgba(255,220,180,.4)", 7, 3)
static func fr_hanba_thirst(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": h_sw(g, 1) * 0.15, "body": h_sw(g, 1, 0.3) * 0.04}
static func fx_hanba_thirst(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.3 * H, -1.05 * H, 0.1 * H, "水……", "#ffd0a0", h_bump(g, 0.3, 0.9))
static func fr_changgui_pet(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.25 - h_sw(g, 3) * 0.08, "body": -0.08, "tiger": h_sw(g, 3, 1) * 0.08}
static func fx_changgui_pet(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.8, 0.68)
	h_T(ctx, S, p[0], p[1] - fmod(g, 0.5) * 0.3 * H, 0.08 * H, "♥", "#ff8aa8", sin(fmod(g, 0.5) * 2 * PI))
static func fr_changgui_whistle(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.7, "head": -0.06, "tiger": h_sw(g, 4) * 0.06}
static func fx_changgui_whistle(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.25, 0.33)
	h_note(ctx, S, p, g, 0, 0.5, H)
	h_note(ctx, S, p, g, 0.4, 0.9, H)
static func fr_guixinniang_veil(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.7, 0.9)
	return {"armF": -0.5 * k, "armB": -0.5 * k, "hairL": h_sw(g, 2) * 0.08, "hairR": h_sw(g, 2, 1) * 0.08, "head": -0.05 * k}
static func fr_guixinniang_twirl(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"sx": cos(BtN30.seg(g, 0.2, 0.7) * TAU) * 0.85 + 0.15 * signf(h_or(cos(BtN30.seg(g, 0.2, 0.7) * TAU), 1)), "hairL": -0.2 * h_bump(g, 0.2, 0.7), "hairR": -0.2 * h_bump(g, 0.2, 0.7)}
static func fx_guixinniang_twirl(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	for i in range(0, 5):
		var q = fmod(g + i / 5.0, 1)
		ctx.save()
		ctx.globalAlpha *= sin(q * PI) * 0.8
		ctx.fillStyle = "#e8303a"
		ctx.beginPath()
		ctx.ellipse((i - 2) * 0.12 * H + sin(q * 6) * 0.03 * H, -1 * H + q * 0.9 * H, 0.02 * H, 0.012 * H, q * 6, 0, 7)
		ctx.fill()
		ctx.restore()
static func fr_guixinniang_wait(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"y": -0.02 * H * h_bump(g, 0.1, 0.6), "head": -0.1 * h_bump(g, 0.1, 0.6) + h_sw(g, 1) * 0.05}
static func fx_guixinniang_wait(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.08 * H, 0.09 * H, "老公呢……", "#ffb0b0", h_bump(g, 0.4, 0.95))
static func fr_shanxiao_hop(g: float, H: float, S: Dictionary) -> Dictionary:
	var u = absf(h_sw(g, 2))
	return {"y": -0.1 * H * u, "sy": 1 + 0.03 * u - ((0.06 if u < 0.15 else 0)), "armF": u * 0.3, "armB": -u * 0.3}
static func fr_shanxiao_scratch(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -1 - h_sw(g, 6) * 0.15, "head": 0.1 + h_sw(g, 6) * 0.04}
static func fx_shanxiao_scratch(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.puff(ctx, h_at(S, m, 0.5, 0.05)[0], h_at(S, m, 0.5, 0.05)[1], 0.05 * H, fmod(g * 2, 1), "rgba(160,150,100,.5)", 9, 4)
static func fr_shanxiao_balance(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.6, "armB": 0.6, "r": h_sw(g) * 7, "px": 0, "py": 0}
static func fr_baigujing_hair(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.4 * h_env(g, 0.1, 0.35, 0.6, 0.85), "head": -0.08 * h_bump(g, 0.1, 0.85), "orn": h_sw(g, 2) * 0.2}
static func fr_baigujing_laugh(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.3, "body": h_sw(g, 6) * 0.03 * h_bump(g, 0.1, 0.8), "head": h_sw(g, 6) * 0.04}
static func fx_baigujing_laugh(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "呵呵呵", "#f0e0f0", h_bump(g, 0.1, 0.85))
static func fr_baigujing_pose(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.7, 0.9)
	return {"r": -5 * k, "head": 0.15 * k, "body": -0.06 * k, "armB": 0.2 * k}
static func fx_baigujing_pose(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	if g > 0.3 and g < 0.6:
		BtN30.burst(ctx, h_at(S, m, 0.45, 0.18)[0], h_at(S, m, 0.45, 0.18)[1], 0.12 * H, 1 - (g - 0.3) / 0.3, "#ffe0f0", 11, 6)
static func fr_qionggui_pockets(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": 0.15 + h_sw(g, 4) * 0.08, "armB": -0.15 - h_sw(g, 4) * 0.08, "sy": 1 + h_sw(g, 4) * 0.01}
static func fx_qionggui_pockets(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.puff(ctx, h_at(S, m, 0.13, 0.66)[0], h_at(S, m, 0.13, 0.66)[1], 0.05 * H, fmod(g * 2, 1), "rgba(190,175,150,.5)", 13, 3)
	BtN30.puff(ctx, h_at(S, m, 0.66, 0.66)[0], h_at(S, m, 0.66, 0.66)[1], 0.05 * H, fmod(g * 2 + 0.5, 1), "rgba(190,175,150,.5)", 14, 3)
static func fr_qionggui_coin(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.5 * h_env(g, 0.05, 0.2, 0.8, 0.95), "head": 0.12}
static func fx_qionggui_coin(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var k = h_env(g, 0.05, 0.2, 0.8, 0.95)
	if k > 0.1:
		h_coin(ctx, h_at(S, m, 0.2, 0.45)[0], h_at(S, m, 0.2, 0.45)[1] - 0.05 * H * k, 0.035 * H, cos(g * 20))
	h_T(ctx, S, 0.2 * H, -1 * H, 0.09 * H, "得一個……", "#e8dcc0", h_bump(g, 0.3, 0.9))
static func fr_dugui_shuffle(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.2 + h_sw(g, 4) * 0.05, "armB": 0.15 - h_sw(g, 4) * 0.05}
static func fx_dugui_shuffle(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var A0 = h_at(S, m, 0.18, 0.5)
	var B0 = h_at(S, m, 0.83, 0.43)
	for i in range(0, 3):
		var q = fmod(g * 3 + i / 3.0, 1)
		h_card(ctx, BtN30.lerp_(B0[0], A0[0], q), BtN30.lerp_(B0[1], A0[1], q) - sin(q * PI) * 0.15 * H, 0.05 * H, q * 6, fmod(i, 2))
static func fr_dugui_dice(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": (0.3 if g < 0.2 else -0.3), "head": 0.1 * h_bump(g, 0.3, 0.9), "y": -0.03 * H * h_bump(g, 0.6, 0.8)}
static func fx_dugui_dice(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var q = BtN30.seg(g, 0.2, 0.55)
	if q > 0:
		for i in range(0, 2):
			var x = 0.15 * H + q * 0.3 * H + i * 0.06 * H
			var y = -absf(sin(q * 3 * PI)) * 0.12 * H * (1 - q)
			ctx.save()
			ctx.translate(x, y - 0.02 * H)
			ctx.rotate(q * 12 * (1 - q))
			ctx.fillStyle = "#fbf6ea"
			ctx.strokeStyle = "#3a2a2a"
			ctx.lineWidth = 0.004 * H
			ctx.fillRect(-0.02 * H, -0.02 * H, 0.04 * H, 0.04 * H)
			ctx.strokeRect(-0.02 * H, -0.02 * H, 0.04 * H, 0.04 * H)
			ctx.restore()
	h_T(ctx, S, 0.3 * H, -1.05 * H, 0.12 * H, "六！", "#ffd84a", h_bump(g, 0.6, 0.95))
static func fr_dugui_pray(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.45, "armB": 0.45, "body": 0.08 * absf(h_sw(g, 1.5)), "head": 0.1 * absf(h_sw(g, 1.5))}
static func fx_dugui_pray(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "發發發", "#ffd84a", h_bump(g, 0.1, 0.9))
static func fr_jiugui_drink(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.55, 0.7)
	return {"r": -12 * k, "head": -0.3 * k, "armF": -0.3 * k, "armB": -0.3 * k}
static func fx_jiugui_drink(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1 * H, 0.11 * H, "嗝～", "#ffb0c8", h_bump(g, 0.7, 0.98))
	var p = h_at(S, m, 0.3, 0.3)
	for i in range(0, 3):
		var q = BtN30.seg(g, 0.7 + i * 0.05, 1)
		if q > 0 and q < 1:
			BtN30.ring(ctx, p[0], p[1] - q * 0.3 * H, 0.025 * H, 0.025 * H, "rgba(200,220,255,.8)", 0.007 * H, 1 - q)
static func fr_jiugui_sway(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g) * 10 + h_sw(g, 3) * 3, "px": 0, "py": 0, "head": h_sw(g, 1, 1) * 0.15}
static func fr_jiugui_sing(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": h_sw(g, 4) * 0.1, "body": h_sw(g, 4) * 0.03}
static func fx_jiugui_sing(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.28, 0.28)
	h_note(ctx, S, p, g, 0, 0.5, H, "#ffd0e0")
	h_note(ctx, S, p, g, 0.45, 0.95, H, "#ffd0e0")
static func fr_yangui_puff(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.25 * h_env(g, 0.05, 0.2, 0.35, 0.5), "sy": 1 + 0.03 * h_bump(g, 0.1, 0.4)}
static func fx_yangui_puff(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.56, 0.36)
	for i in range(0, 3):
		var q = BtN30.seg(g, 0.45 + i * 0.08, 1)
		if q > 0 and q < 1:
			BtN30.ring(ctx, p[0] + q * 0.4 * H, p[1] - q * 0.3 * H, 0.04 * H * (1 + q), 0.02 * H * (1 + q), "rgba(210,210,220,.85)", 0.015 * H, 1 - q)
static func fr_yangui_cough(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"body": 0.15 * absf(h_sw(g, 3)), "head": 0.15 * absf(h_sw(g, 3)), "r": 3 * absf(h_sw(g, 3))}
static func fx_yangui_cough(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.3 * H, -0.95 * H, 0.1 * H, "咳咳！", "#d0d0d8", absf(h_sw(g, 1.5)))
static func fr_guhangui_count(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.2 + h_sw(g, 3) * 0.08, "head": -0.05}
static func fx_guhangui_count(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.18, 0.36)
	if h_sw(g, 3) > 0.7:
		BtN30.burst(ctx, p[0], p[1], 0.08 * H, (h_sw(g, 3) - 0.7) / 0.3, "#fff0a0", 17, 6)
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, ["一", "二", "三"][int(floor(g * 3))] + "……", "#ffe08a", 0.9)
static func fr_guhangui_abacus(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": h_sw(g, 8) * 0.05, "head": 0.08}
static func fx_guhangui_abacus(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, h_at(S, m, 0.66, 0.4)[0], h_at(S, m, 0.66, 0.4)[1] - 0.12 * H, 0.07 * H, "啪", "#ffe08a", absf(h_sw(g, 4)))
static func fr_guhangui_bite(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.6, 0.8)
	return {"armF": -0.6 * k, "head": 0.1 * k + 0.1 * h_bump(g, 0.75, 0.95)}
static func fx_guhangui_bite(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, "真㗎！", "#ffe08a", h_bump(g, 0.7, 1))
static func fr_taozhai_shake(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": h_sw(g, 6) * 0.1, "paper": h_sw(g, 6, 1) * 0.2, "head": 0.05}
static func fr_taozhai_knock(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.6 + absf(h_sw(g, 3)) * 0.3 * h_env(g, 0, 0.1, 0.7, 0.9), "r": 2}
static func fx_taozhai_knock(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.35 * H, -1.05 * H, 0.1 * H, "開門！還錢！", "#ff5050", h_bump(g, 0.1, 0.9))
static func fr_taozhai_paint(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.3 - h_sw(g, 3) * 0.2, "body": 0.12, "head": 0.1}
static func fx_taozhai_paint(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.45 * H, -0.04 * H, 0.12 * H, "債", "#c8141e", BtN30.cl(g * 1.5))
static func fr_danxiao_shiver(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"x": h_sw(g, 18) * 0.012 * H, "head": h_sw(g, 15) * 0.03, "sy": 1 - 0.02}
static func fx_danxiao_shiver(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_sweat(ctx, S, h_at(S, m, 0.5, 0.15), g, H)
static func fr_danxiao_peek(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.4, 0.7, 0.9)
	return {"r": 8 * k, "head": 0.2 * k, "x": 0.03 * H * k}
static func fx_danxiao_peek(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.35 * H, -1.05 * H, 0.09 * H, "有、有鬼呀？", "#bfe0ff", h_bump(g, 0.35, 0.85))
static func fr_danxiao_startle(g: float, H: float, S: Dictionary) -> Dictionary:
	var j = h_bump(g, 0.2, 0.45)
	return {"y": -0.18 * H * j, "armF": -0.6 * j, "armB": 0.6 * j, "sy": 1 + 0.06 * j}
static func fx_danxiao_startle(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.15 * H, 0.12 * H, "哇！", "#ffffff", h_bump(g, 0.2, 0.6))
static func fr_maoshi_trip(g: float, H: float, S: Dictionary) -> Dictionary:
	var d = h_env(g, 0.1, 0.3, 0.6, 0.85)
	return {"r": 70 * d, "px": 0, "py": 0, "x": 0.15 * H * d, "armF": -0.8 * d, "armB": -0.6 * d}
static func fx_maoshi_trip(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.puff(ctx, 0.5 * H, -0.03 * H, 0.08 * H, BtN30.seg(g, 0.25, 0.6), "rgba(200,190,170,.55)", 19, 4)
	h_T(ctx, S, 0.3 * H, -1 * H, 0.1 * H, "哎喲！", "#ffe066", h_bump(g, 0.15, 0.45))
static func fr_maoshi_rub(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -1, "head": 0.08 + h_sw(g, 4) * 0.03}
static func fx_maoshi_rub(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.stars(ctx, h_at(S, m, 0.4, 0.05)[0], h_at(S, m, 0.4, 0.05)[1], 0.12 * H, g * 3, 0.9)
static func fr_hanturaya_loom(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.9)
	return {"sy": 1 + 0.1 * k, "sx": 1 + 0.05 * k, "hairL": 0.2 * k, "hairR": 0.2 * k}
static func pre_hanturaya_loom(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var gr = ctx.createRadialGradient(0, -0.5 * H, 0, 0, -0.5 * H, 0.7 * H)
	gr.addColorStop(0, ("rgba(40,20,60," + h_s(0.35 * h_bump(g, 0.1, 0.9)) + ")"))
	gr.addColorStop(1, "rgba(40,20,60,0)")
	ctx.fillStyle = gr
	ctx.fillRect(-0.8 * H, -1.3 * H, 1.6 * H, 1.4 * H)
static func fr_hanturaya_wisp(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"hairL": h_sw(g, 2) * 0.15, "hairR": h_sw(g, 2, 1) * 0.15}
static func fx_hanturaya_wisp(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	for i in range(0, 4):
		BtN30.puff(ctx, (i - 1.5) * 0.25 * H, -0.85 * H, 0.08 * H, fmod(g + i / 4.0, 1), "rgba(50,30,70,.45)", 21 + i, 3)
static func fr_polong_bob(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"tail1": -0.15 * h_bump(g, 0.1, 0.5), "tail2": -0.2 * h_bump(g, 0.1, 0.5), "head": h_sw(g, 1.5) * 0.15}
static func fr_polong_hop(g: float, H: float, S: Dictionary) -> Dictionary:
	var u = absf(h_sw(g, 2))
	return {"y": -0.08 * H * u, "sy": 1 + 0.04 * u - ((0.06 if u < 0.15 else 0)), "tail1": h_sw(g, 2) * 0.1}
static func fr_pelesit_chirp(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"cape": h_sw(g, 20) * 0.08, "hairL": h_sw(g, 3) * 0.15, "hairR": h_sw(g, 3, 1) * 0.15}
static func fx_pelesit_chirp(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.1 * H, -1.1 * H, 0.18 * H, "唧唧", "#d8e8a0", absf(h_sw(g, 1)))
static func fr_pelesit_clean(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.7, 0.9)
	return {"head": 0.2 * k, "hairL": 0.5 * k, "hairR": 0.3 * k, "legF": -0.2 * k + h_sw(g, 4) * 0.05 * k}
static func fr_pelesit_hop(g: float, H: float, S: Dictionary) -> Dictionary:
	var j = h_bump(g, 0.15, 0.6)
	return {"y": -0.35 * H * j, "r": -10 * j, "legB": -0.3 * j, "sy": 1 - 0.12 * h_bump(g, 0, 0.15)}
static func fr_jenglot_hairflip(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.6)
	return {"head": 0.2 * k, "hairL": -0.4 * k, "hairR": -0.4 * k, "r": 4 * k}
static func fr_jenglot_hiss(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"sy": 0.95, "head": -0.1, "armF": -0.3, "armB": 0.3, "x": h_sw(g, 10) * 0.005 * H}
static func fx_jenglot_hiss(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -0.95 * H, 0.1 * H, "嘶——", "#d8c8b8", h_bump(g, 0.1, 0.9))
static func fr_hantugalah_peer(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.9, "head": h_sw(g, 1) * 0.12, "body": 0.05}
static func fr_hantugalah_stretch(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.4, 0.6, 0.9)
	return {"sy": 1 + 0.06 * k, "armF": -0.7 * k, "armB": 0.7 * k, "head": -0.15 * k}
static func fr_jerangkung_rattle(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"x": h_sw(g, 14) * 0.008 * H, "head": h_sw(g, 11) * 0.05, "armF": h_sw(g, 9) * 0.08, "armB": h_sw(g, 10) * 0.08}
static func fx_jerangkung_rattle(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1 * H, 0.09 * H, "喀喀", "#f6efd8", absf(h_sw(g, 1)))
static func fr_jerangkung_dance(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g, 2) * 6, "px": 0, "py": 0, "armF": h_sw(g, 2) * 0.5, "armB": -h_sw(g, 2) * 0.5, "legF": h_sw(g, 2) * 0.2, "legB": -h_sw(g, 2) * 0.2, "y": -absf(h_sw(g, 4)) * 0.03 * H}
static func fx_jerangkung_dance(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_note(ctx, S, [0.2 * H, -0.9 * H], g, 0, 0.9, H, "#f6efd8")
static func fr_genderuwo_chest(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.5 - maxf(0, h_sw(g, 3)) * 0.4, "armB": 0.5 + maxf(0, -h_sw(g, 3)) * 0.4, "head": -0.1}
static func fx_genderuwo_chest(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.3 * H, -1.05 * H, 0.1 * H, "咚咚", "#ffcf80", absf(h_sw(g, 3)))
static func fr_genderuwo_scratch(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.2 + h_sw(g, 6) * 0.1 * ((1 if g < 0.7 else 0)), "body": 0.08, "head": 0.15}
static func fx_genderuwo_scratch(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	if g > 0.7:
		var q = (g - 0.7) / 0.3
		ctx.fillStyle = "#2a1a10"
		ctx.beginPath()
		ctx.arc(0.2 * H + q * 0.3 * H, -0.5 * H - sin(q * PI) * 0.2 * H, 0.008 * H, 0, 7)
		ctx.fill()
static func fr_bunian_flicker(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"a": 0.35 + 0.65 * (0.5 + 0.5 * cos(g * TAU))}
static func fx_bunian_flicker(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	for i in range(0, 6):
		var q = fmod(g + i / 6.0, 1)
		ctx.save()
		ctx.globalAlpha *= sin(q * PI)
		ctx.fillStyle = "#ffe28a"
		ctx.beginPath()
		ctx.arc((BtN30.rnd(i) - 0.5) * 0.6 * H, -0.2 * H - q * 0.8 * H, 0.012 * H, 0, 7)
		ctx.fill()
		ctx.restore()
static func fr_bunian_flower(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.35, 0.65, 0.9)
	return {"head": 0.15 * k, "armB": -0.4 * k, "hairL": 0.1 * k}
static func fx_bunian_flower(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.1 * H, -1.08 * H, 0.08 * H, "～♪", "#ffe28a", h_bump(g, 0.3, 0.8))
static func fr_maenak_reach(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.35, 0.6, 0.85)
	return {"armF": 0.7 * k, "head": -0.1 * k}
static func fr_maenak_hum(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g) * 3, "px": 0, "py": 0, "head": h_sw(g, 1, 0.5) * 0.08, "hairL": h_sw(g, 1) * 0.06}
static func fx_maenak_hum(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.6, 0.27)
	h_note(ctx, S, p, g, 0, 0.5, H, "#e8d0ff")
	h_note(ctx, S, p, g, 0.5, 1, H, "#e8d0ff")
static func fr_maenak_wait(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": -0.08 + h_sw(g, 1) * 0.04}
static func fx_maenak_wait(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.15 * H, -1.05 * H, 0.09 * H, "Mak……", "#e8d0ff", h_bump(g, 0.3, 0.9))
static func fr_phiam_yawn(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.7)
	return {"head": -0.25 * k, "sy": 1 + 0.05 * k, "armF": -0.3 * k, "armB": 0.3 * k, "tie": h_sw(g, 2) * 0.2}
static func fx_phiam_yawn(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.3 * H, -0.95 * H, 0.1 * H, "呵～", "#ffd8f0", h_bump(g, 0.2, 0.7))
static func fr_phiam_doze(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": (0.25 * BtN30.seg(g, 0, 0.7) if g < 0.8 else -0.15 * h_bump(g, 0.8, 1)), "y": (-0.05 * H * h_bump(g, 0.8, 0.95) if g > 0.8 else 0)}
static func fx_phiam_doze(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	if g < 0.8:
		h_zz(ctx, S, [0.15 * H, -0.85 * H], g, H)
static func fr_churel_hair(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.6)
	return {"armF": -0.8 * k, "hairL": -0.3 * k, "hairR": 0.2 * k, "head": -0.1 * k}
static func fx_churel_hair(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1 * H, 0.07 * H, "叮", "#ffd27a", h_bump(g, 0.3, 0.6))
static func fr_churel_dance(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g, 2) * 5, "px": 0, "py": 0, "armF": -0.4 + h_sw(g, 2) * 0.3, "armB": 0.4 + h_sw(g, 2) * 0.3, "y": -absf(h_sw(g, 4)) * 0.02 * H}
static func fx_churel_dance(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_note(ctx, S, [0.2 * H, -0.9 * H], g, 0, 0.9, H, "#ffd27a")
static func fr_vetala_doze(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": 0.15 + absf(h_sw(g, 2)) * 0.1, "body": 0.05}
static func fx_vetala_doze(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_zz(ctx, S, [0.1 * H, -0.9 * H], g, H)
static func fr_vetala_riddle(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.8 * h_env(g, 0.05, 0.2, 0.8, 0.95) + h_sw(g, 4) * 0.08, "head": -0.1}
static func fx_vetala_riddle(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, "估吓先？", "#d8ffc8", h_bump(g, 0.1, 0.9))
static func fr_kappa_refill(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.6, 0.8)
	return {"armB": -1 * k, "head": -0.08 * k}
static func fx_kappa_refill(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.47, 0.04)
	if g > 0.35 and g < 0.75:
		var q = (g - 0.35) / 0.4
		BtN30.ring(ctx, p[0], p[1], 0.05 * H * (0.3 + q), 0.015 * H * (0.3 + q), "rgba(150,210,255,.9)", 0.006 * H, 1 - q)
		BtN30.drops(ctx, p[0], p[1] - 0.05 * H, 0.15 * H, q, "rgba(150,210,255,.9)", 23, 3)
static func fr_kappa_cucumber(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.35 - absf(h_sw(g, 3)) * 0.1, "head": 0.08 + h_sw(g, 6) * 0.03}
static func fx_kappa_cucumber(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1 * H, 0.08 * H, "喀嚓", "#c8f0a0", absf(h_sw(g, 1.5)))
	BtN30.drops(ctx, h_at(S, m, 0.25, 0.32)[0], h_at(S, m, 0.25, 0.32)[1], 0.12 * H, fmod(g * 3, 1), "#9ad070", 25, 3)
static func fr_rokurokubi_stretch(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.35, 0.65, 0.9)
	return {"neck1": -0.2 * k, "neck2": -0.15 * k + h_sw(g, 2) * 0.12 * k, "head": h_sw(g, 2, 1) * 0.12 * k}
static func fr_rokurokubi_yawn(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.7)
	return {"head": -0.3 * k, "neck2": 0.1 * k, "armF": -0.2 * k}
static func fx_rokurokubi_yawn(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, -0.2 * H, -1.05 * H, 0.1 * H, "呵～", "#ffd0e0", h_bump(g, 0.2, 0.7))
static func fr_kuchisake_snip(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.2 + absf(h_sw(g, 2)) * 0.1, "head": 0.05}
static func fx_kuchisake_snip(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, h_at(S, m, 0.05, 0.25)[0], h_at(S, m, 0.05, 0.25)[1] - 0.08 * H, 0.08 * H, "咔嚓", "#ffffff", absf(h_sw(g, 2)))
static func fr_kuchisake_ask(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": -0.2 * h_env(g, 0.1, 0.3, 0.75, 0.95), "r": -3 * h_env(g, 0.1, 0.3, 0.75, 0.95)}
static func fx_kuchisake_ask(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "我靚唔靚？", "#ffe0e0", h_bump(g, 0.2, 0.95))
static func fr_yukionna_snow(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.5 * h_env(g, 0.05, 0.2, 0.75, 0.9), "head": 0.1}
static func fx_yukionna_snow(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.25, 0.45)
	var q = BtN30.seg(g, 0.2, 0.9)
	if q > 0 and q < 1:
		h_flake(ctx, p[0] + q * 0.1 * H, p[1] - 0.06 * H - q * 0.3 * H, 0.05 * H * minf(1, q * 3), q * 6, 1 - BtN30.seg(q, 0.7, 1))
static func fr_yukionna_breath(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": 0.1 * h_bump(g, 0.2, 0.7), "sy": 1 + 0.02 * h_bump(g, 0, 0.2)}
static func fx_yukionna_breath(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.42, 0.255)
	BtN30.puff(ctx, p[0] + 0.1 * H, p[1], 0.06 * H, BtN30.seg(g, 0.2, 0.9), "rgba(220,240,255,.6)", 27, 4)
static func fr_kasaobake_hop(g: float, H: float, S: Dictionary) -> Dictionary:
	var u = absf(h_sw(g, 2))
	return {"y": -0.12 * H * u, "sy": 1 + 0.03 * u - ((0.07 if u < 0.15 else 0)), "tie": u * 0.3, "tongue": u * 0.2}
static func fr_kasaobake_lick(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"tongue": h_sw(g, 2) * 0.35 * h_bump(g, 0, 1), "head": h_sw(g, 2, 1) * 0.04}
static func fr_kasaobake_spin(g: float, H: float, S: Dictionary) -> Dictionary:
	var c = cos(BtN30.seg(g, 0.15, 0.75) * TAU)
	return {"sx": (0.12 * signf(h_or(c, 1)) if absf(c) < 0.12 else c), "tie": 0.3 * h_bump(g, 0.15, 0.75)}
static func fr_nopperabo_watch(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.05, 0.2, 0.75, 0.9)
	return {"armB": -0.9 * k, "head": 0.12 * k, "y": -0.01 * H * absf(h_sw(g, 4)) * k}
static func fx_nopperabo_watch(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "遲到喇！", "#e8e8ff", h_bump(g, 0.3, 0.9))
static func fr_nopperabo_tie(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.7, 0.9)
	return {"armB": -0.6 * k + h_sw(g, 4) * 0.05 * k, "head": -0.08 * k, "sy": 1 + 0.02 * k}
static func fr_chochin_flicker(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"flame": h_sw(g, 3) * 0.2, "sy": 1 + h_sw(g, 2) * 0.02}
static func pre_chochin_flicker(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var k = 0.5 + 0.5 * h_sw(g, 3)
	var gr = ctx.createRadialGradient(0, -0.5 * H, 0, 0, -0.5 * H, 0.5 * H)
	gr.addColorStop(0, ("rgba(255,180,80," + h_s(0.25 + 0.2 * k) + ")"))
	gr.addColorStop(1, "rgba(255,180,80,0)")
	ctx.fillStyle = gr
	ctx.fillRect(-0.5 * H, -1 * H, H, H)
static func fr_chochin_tongue(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"tongue": h_sw(g, 2) * 0.3, "sx": 1 + 0.03 * h_bump(g, 0, 0.5)}
static func fr_gashadokuro_rattle(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"x": h_sw(g, 12) * 0.006 * H, "head": h_sw(g, 9) * 0.05, "armF": h_sw(g, 7) * 0.04}
static func fx_gashadokuro_rattle(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.1 * H, -1.05 * H, 0.1 * H, "喀喀喀", "#f6efd8", absf(h_sw(g, 1)))
static func fr_gashadokuro_hungry(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": h_sw(g, 1) * 0.15, "body": h_sw(g, 1, 0.5) * 0.04}
static func fx_gashadokuro_hungry(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, -0.1 * H, -1.05 * H, 0.1 * H, "餓……", "#f6efd8", h_bump(g, 0.3, 0.9))
static func fr_banshee_comb(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.6 + h_sw(g, 2) * 0.2, "hairL": h_sw(g, 2, 1) * 0.1, "head": 0.08}
static func fr_banshee_weep(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": 0.2, "body": 0.05 + absf(h_sw(g, 3)) * 0.03, "sy": 1 - absf(h_sw(g, 3)) * 0.015}
static func fx_banshee_weep(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.5, 0.22)
	BtN30.drops(ctx, p[0], p[1], 0.15 * H, fmod(g * 2, 1), "rgba(180,210,255,.9)", 29, 2, 0.6)
static func fr_hannya_fume(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"x": h_sw(g, 16) * 0.006 * H, "head": -0.05, "armF": -0.3, "armB": 0.3}
static func fx_hannya_fume(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.42, 0.02)
	BtN30.puff(ctx, p[0], p[1], 0.06 * H, g, "rgba(240,240,240,.55)", 31, 3)
	BtN30.puff(ctx, p[0] + 0.05 * H, p[1], 0.05 * H, fmod(g + 0.5, 1), "rgba(240,240,240,.55)", 32, 3)
static func fr_hannya_sulk(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": -0.25 * h_env(g, 0.1, 0.2, 0.7, 0.9), "r": -3 * h_env(g, 0.1, 0.2, 0.7, 0.9)}
static func fx_hannya_sulk(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, -0.2 * H, -1.05 * H, 0.11 * H, "哼！", "#ff7070", h_bump(g, 0.15, 0.75))
static func fr_aswang_flap(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"cape": h_sw(g, 4) * 0.35, "y": -absf(h_sw(g, 4)) * 0.015 * H}
static func fr_aswang_sniff(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": 0.15 + absf(h_sw(g, 4)) * 0.06, "body": 0.08, "r": 3}
static func fx_aswang_sniff(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.15, 0.25)
	for i in range(0, 3):
		h_crayon(ctx, [[p[0] + 0.05 * H + i * 0.03 * H, p[1] - 0.03 * H], [p[0] + 0.08 * H + i * 0.03 * H, p[1] + 0.03 * H]], "rgba(220,220,230,.7)", 0.01 * H, 33 + i, absf(h_sw(g, 4)))
static func fr_tikbalang_smoke(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": -0.1 * h_bump(g, 0.1, 0.4), "sy": 1 + 0.02 * h_bump(g, 0.1, 0.4)}
static func fx_tikbalang_smoke(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.08, 0.27)
	BtN30.puff(ctx, p[0], p[1], 0.06 * H, BtN30.seg(g, 0.45, 1), "rgba(210,210,220,.6)", 35, 4)
static func fr_tikbalang_stomp(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"legF": -0.25 * maxf(0, h_sw(g, 2)), "head": 0.05}
static func fx_tikbalang_stomp(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.puff(ctx, 0.15 * H, -0.02 * H, 0.05 * H, fmod(g * 2, 1), "rgba(190,170,150,.55)", 37, 3)
static func fr_tikbalang_mane(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.6)
	return {"head": h_sw(g, 2) * 0.15 * k, "hairL": -0.3 * k, "hairR": -0.3 * k, "cape": 0.3 * k}
static func fr_chehuo_mirror(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.35 * h_env(g, 0.05, 0.2, 0.8, 0.95), "head": -0.1 * h_env(g, 0.05, 0.2, 0.8, 0.95) + h_sw(g, 2) * 0.04}
static func fr_chehuo_rev(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.45 + h_sw(g, 6) * 0.05, "armB": -0.35, "r": 3, "px": 0, "py": 0, "x": h_sw(g, 30) * 0.004 * H}
static func fx_chehuo_rev(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.puff(ctx, -0.3 * H, -0.2 * H, 0.06 * H, fmod(g * 2, 1), "rgba(70,64,70,.5)", 41, 3)
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "嗚嗚～", "#ffe066", h_bump(g, 0.2, 0.9))
static func fr_diansi_zap(g: float, H: float, S: Dictionary) -> Dictionary:
	var j = (sin(g * 300) if g > 0.3 and g < 0.45 else 0)
	return {"x": j * 0.01 * H, "hairL": 0.2 * h_bump(g, 0.3, 0.6), "hairR": 0.2 * h_bump(g, 0.3, 0.6), "head": j * 0.08}
static func fx_diansi_zap(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.14, 0.32)
	if g > 0.28 and g < 0.45:
		for i in range(0, 3):
			h_bolt(ctx, p, [p[0] + (BtN30.rnd(i) - 0.5) * 0.2 * H, p[1] - 0.15 * H], 0.008 * H, 43 + i + floor(g * 30), "#ffe14a", 1)
	BtN30.puff(ctx, h_at(S, m, 0.55, 0.05)[0], h_at(S, m, 0.55, 0.05)[1], 0.06 * H, BtN30.seg(g, 0.45, 1), "rgba(110,100,100,.5)", 44, 3)
static func fr_diansi_plug(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.3 + h_sw(g, 2) * 0.1, "head": h_sw(g, 1) * 0.15}
static func fx_diansi_plug(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "插蘇喺邊？", "#ffe14a", h_bump(g, 0.3, 0.9))
static func fr_dongsi_shiver(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"x": h_sw(g, 20) * 0.008 * H, "head": h_sw(g, 16) * 0.03, "sy": 0.98}
static func fx_dongsi_shiver(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	for i in range(0, 2):
		var q = fmod(g + i / 2.0, 1)
		h_flake(ctx, (i - 0.5) * 0.4 * H, -1 * H + q * 0.8 * H, 0.03 * H, q * 5, sin(q * PI))
static func fr_dongsi_sneeze(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.5)
	var s2 = h_bump(g, 0.5, 0.65)
	return {"head": -0.2 * k + 0.25 * s2, "body": 0.1 * s2}
static func fx_dongsi_sneeze(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.1 * H, ("哈……" if g < 0.5 else "哈啾！"), "#cfeaff", h_bump(g, 0.1, 0.9))
	var p = h_at(S, m, 0.4, 0.3)
	if g > 0.5:
		for i in range(0, 4):
			h_flake(ctx, p[0] + (g - 0.5) * 0.6 * H + i * 0.03 * H, p[1] + (i - 1.5) * 0.04 * H, 0.025 * H, g * 8 + i, 1 - BtN30.seg(g, 0.7, 1))
static func fr_yezi_dizzy(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g) * 6, "px": 0, "py": 0, "head": h_sw(g, 1, 1) * 0.1}
static func fx_yezi_dizzy(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.stars(ctx, h_at(S, m, 0.42, 0.05)[0], h_at(S, m, 0.42, 0.05)[1], 0.15 * H, g * 6, 0.9)
static func fr_yezi_lookup(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": -0.2 * h_env(g, 0.1, 0.3, 0.7, 0.9) + h_sw(g, 3) * 0.03, "sy": 1 - 0.03 * h_env(g, 0.1, 0.3, 0.7, 0.9)}
static func fx_yezi_lookup(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.1 * H, 0.1 * H, "……！", "#ffe066", h_bump(g, 0.3, 0.8))
static func fr_liulian_sniff(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.1, 0.3, 0.7, 0.9)
	return {"armF": -0.3 * k, "head": 0.12 * k}
static func fx_liulian_sniff(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "好香～", "#d8e070", h_bump(g, 0.3, 0.85))
	for i in range(0, 2):
		var q = fmod(g + i / 2.0, 1)
		var pts = []
		for j in range(0, 5 + 1):
			pts.append([-0.25 * H + i * 0.08 * H + sin(j + g * 12) * 0.02 * H, -0.6 * H - j * 0.05 * H - q * 0.1 * H])
		h_crayon(ctx, pts, "rgba(150,190,80,.7)", 0.012 * H, 47 + i, sin(q * PI))
static func fr_liulian_rub(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.9 + h_sw(g, 4) * 0.08, "head": 0.1}
static func fx_liulian_rub(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "痛痛痛", "#ffd0d0", absf(h_sw(g, 1.5)))
static func fr_yesi_eat(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_env(g, 0.05, 0.25, 0.4, 0.55)
	return {"armF": -0.6 * k, "head": -0.1 * k + 0.1 * h_bump(g, 0.55, 0.9), "armB": 0.1 * absf(h_sw(g, 4)) * ((1 if g > 0.55 else 0))}
static func fx_yesi_eat(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, "噎……！", "#ffffff", h_bump(g, 0.55, 0.95))
static func fr_yesi_cough(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"body": 0.12 * absf(h_sw(g, 2)), "head": 0.15 * absf(h_sw(g, 2))}
static func fx_yesi_cough(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1 * H, 0.1 * H, "咳！", "#ffffff", absf(h_sw(g, 1)))
static func fr_xiaosi_laugh(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"body": 0.15 + absf(h_sw(g, 5)) * 0.08, "head": 0.15 + absf(h_sw(g, 5)) * 0.1, "y": -absf(h_sw(g, 5)) * 0.02 * H}
static func fx_xiaosi_laugh(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1 * H, 0.1 * H, "哈哈哈", "#ffe066", 0.9)
	BtN30.drops(ctx, h_at(S, m, 0.3, 0.2)[0], h_at(S, m, 0.3, 0.2)[1], 0.2 * H, fmod(g * 2, 1), "rgba(150,210,255,.9)", 49, 3)
static func fr_xiaosi_slap(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": 0.3 * maxf(0, h_sw(g, 3)), "body": 0.1, "head": 0.1}
static func fx_xiaosi_slap(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.3 * H, -0.6 * H, 0.08 * H, "啪", "#ffe066", maxf(0, h_sw(g, 3)))
static func fr_xiasi_jump(g: float, H: float, S: Dictionary) -> Dictionary:
	var j = h_bump(g, 0.2, 0.45)
	return {"y": -0.15 * H * j, "hairL": -0.3 * j, "hairR": -0.3 * j, "armF": -0.4 * j, "armB": 0.4 * j}
static func fx_xiasi_jump(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.15 * H, 0.12 * H, "哇！", "#ff5050", h_bump(g, 0.2, 0.6))
static func fr_xiasi_look(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": h_sw(g, 2) * 0.15, "x": h_sw(g, 25) * 0.003 * H}
static func fr_leipi_smoke(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"head": 0.05 + 0.1 * h_bump(g, 0.6, 0.8)}
static func fx_leipi_smoke(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	for i in range(0, 2):
		BtN30.puff(ctx, h_at(S, m, 0.35, 0.05)[0] + i * 0.05 * H, h_at(S, m, 0.35, 0.05)[1], 0.06 * H, fmod(g + i / 2.0, 1), "rgba(80,70,70,.5)", 51 + i, 3)
static func fr_leipi_umbrella(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.4 * h_env(g, 0.1, 0.3, 0.7, 0.9), "umb": -0.1, "head": -0.15}
static func fx_leipi_umbrella(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.1 * H, 0.08 * H, "唔會再行雷啩…", "#ffe14a", h_bump(g, 0.3, 0.9))
static func fr_zipai_selfie(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.2, "head": -0.08 + 0.06 * h_bump(g, 0.5, 0.6)}
static func fx_zipai_selfie(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	if g > 0.5 and g < 0.62:
		var p = h_at(S, m, 0.8, 0.14)
		BtN30.burst(ctx, p[0], p[1], 0.15 * H, 1 - (g - 0.5) / 0.12, "#ffffff", 53, 8)
	h_T(ctx, S, -0.1 * H, -1.05 * H, 0.09 * H, "茄子～", "#ffe0f0", h_bump(g, 0.1, 0.55))
static func fr_zipai_check(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": 0.3 * h_env(g, 0.1, 0.3, 0.7, 0.9), "stick": 0.2 * h_env(g, 0.1, 0.3, 0.7, 0.9), "head": 0.1}
static func fx_zipai_check(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, "正！", "#ffe0f0", h_bump(g, 0.5, 0.95))
static func fr_zhongshu_wipe(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.6 * h_env(g, 0.1, 0.3, 0.5, 0.7), "head": 0.08}
static func fx_zhongshu_wipe(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	BtN30.drops(ctx, h_at(S, m, 0.45, 0.2)[0], h_at(S, m, 0.45, 0.2)[1], 0.25 * H, BtN30.seg(g, 0.45, 0.9), "rgba(150,210,255,.9)", 55, 5)
static func fr_zhongshu_lick(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armB": -0.3 * h_env(g, 0.1, 0.3, 0.6, 0.8), "head": -0.08}
static func fx_zhongshu_lick(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	var p = h_at(S, m, 0.75, 0.45)
	BtN30.drops(ctx, p[0], p[1], 0.12 * H, fmod(g * 2, 1), "rgba(255,160,110,.9)", 57, 2, 0.5)
static func fr_chengsi_eat(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": -0.3 * absf(h_sw(g, 2)), "head": h_sw(g, 6) * 0.04}
static func fx_chengsi_eat(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.15 * H, -1.05 * H, 0.08 * H, "嚼嚼", "#ffe0b0", 0.8)
static func fr_chengsi_burp(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.3, 0.6)
	return {"sx": 1 + 0.05 * k, "sy": 1 - 0.02 * k, "head": -0.15 * k}
static func fx_chengsi_burp(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.05 * H, 0.11 * H, "嗝～", "#ffe0b0", h_bump(g, 0.3, 0.75))
static func fr_shedu_hop(g: float, H: float, S: Dictionary) -> Dictionary:
	var u = absf(h_sw(g, 2))
	return {"y": -0.08 * H * u, "armF": -0.3 * u, "snake": h_sw(g, 2) * 0.1}
static func fx_shedu_hop(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.15 * H, -1.1 * H, 0.09 * H, "哎喲哎喲", "#ffe066", 0.9)
static func fr_shedu_shake(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"r": h_sw(g, 3) * 5, "px": 0, "py": 0, "snake": h_sw(g, 3, 1) * 0.2}
static func fr_shidu_cramp(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"body": 0.15 + absf(h_sw(g, 2)) * 0.05, "head": 0.15, "sy": 0.97}
static func fx_shidu_cramp(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1 * H, 0.09 * H, "咕嚕嚕", "#b8e070", h_bump(g, 0.1, 0.9))
static func fr_shidu_run(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"legF": h_sw(g, 6) * 0.2, "legB": -h_sw(g, 6) * 0.2, "head": h_sw(g, 1) * 0.15, "y": -absf(h_sw(g, 6)) * 0.015 * H}
static func fx_shidu_run(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, "廁所喺邊！", "#b8e070", 0.9)
static func fr_daji_play(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"armF": h_sw(g, 20) * 0.04, "armB": -h_sw(g, 20) * 0.04, "head": 0.1}
static func fx_daji_play(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.15 * H, -1.05 * H, 0.08 * H, ["↑", "↓", "A", "B"][int(fmod(floor(g * 8), 4))], "#9fe8ff", 0.9)
static func fr_daji_yawn(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.6)
	return {"armF": -0.6 * k, "armB": 0.6 * k, "head": -0.2 * k, "sy": 1 + 0.03 * k}
static func fx_daji_yawn(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.2 * H, -1.05 * H, 0.1 * H, "呵～", "#9fe8ff", h_bump(g, 0.15, 0.6))
static func fr_xiangcai_flap(g: float, H: float, S: Dictionary) -> Dictionary:
	return {"sy": 1 + h_sw(g, 2) * 0.1, "r": h_sw(g, 2, 1) * 6, "px": 0, "py": -0.3 * H, "armF": h_sw(g, 4) * 0.2, "armB": -h_sw(g, 4) * 0.2, "y": -0.03 * H}
static func fr_xiangcai_inflate(g: float, H: float, S: Dictionary) -> Dictionary:
	var k = h_bump(g, 0.1, 0.6)
	return {"sy": 1 + 0.35 * k, "sx": 1 - 0.1 * k}
static func fx_xiangcai_inflate(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:
	h_T(ctx, S, 0.25 * H, -1.2 * H, 0.1 * H, ("呼——" if g < 0.6 else "噗"), "#ffffff", h_bump(g, 0.1, 0.8))

# [鬼 id, key, 中文名, 一輪秒數, 說明, 姿勢, 身後特效, 身前特效, idleK]
static func list() -> Array:
	return [
		["diaosi", "n30_diaosi_swing", "晃來晃去", 3.6, "像還吊著一樣，整個人慢慢鐘擺晃，繩子跟著甩。", fr_diaosi_swing, null, null, null],
		["diaosi", "n30_diaosi_tongue", "甩舌頭", 2.4, "頭左右甩，長舌頭跟著甩，口水亂噴。", fr_diaosi_tongue, null, fx_diaosi_tongue, null],
		["diaosi", "n30_diaosi_sigh", "嘆氣", 3.2, "肩膀一垂、頭低下去「唉……」。", fr_diaosi_sigh, null, fx_diaosi_sigh, null],
		["wutou", "n30_wutou_polish", "擦亮自己的頭", 3.0, "另一隻手在捧著的頭上來回擦，擦到發亮。", fr_wutou_polish, null, fx_wutou_polish, null],
		["wutou", "n30_wutou_smoke", "脖子冒煙", 3.4, "領口一陣一陣冒煙，聳聳肩。", fr_wutou_smoke, null, fx_wutou_smoke, null],
		["wutou", "n30_wutou_nod", "捧著頭點頭", 2.2, "用手把自己的頭上下點兩下，像在跟人打招呼。", fr_wutou_nod, null, null, null],
		["yecha", "n30_yecha_flex", "秀肌肉", 2.8, "雙臂一夾、胸口鼓起，紅毛一抖。", fr_yecha_flex, null, fx_yecha_flex, null],
		["yecha", "n30_yecha_scratch", "用叉搔背", 3.0, "鋼叉舉到背後上下搔，舒服到瞇眼扭身。", fr_yecha_scratch, null, fx_yecha_scratch, null],
		["yecha", "n30_yecha_roar", "仰天吼", 2.4, "頭往後一仰「吼！」，叉子往地上一頓。", fr_yecha_roar, null, fx_yecha_roar, null],
		["hanba", "n30_hanba_fan", "熱到搧風", 2.4, "用手拚命搧臉，滿頭大汗，地上冒熱氣。", fr_hanba_fan, null, fx_hanba_fan, null],
		["hanba", "n30_hanba_thirst", "找水喝", 3.4, "東張西望，舔舔乾裂的嘴「水……」。", fr_hanba_thirst, null, fx_hanba_thirst, null],
		["changgui", "n30_changgui_pet", "摸小老虎", 3.0, "彎腰摸摸小老虎的頭，老虎蹭回去，冒愛心。", fr_changgui_pet, null, fx_changgui_pet, null],
		["changgui", "n30_changgui_whistle", "吹口哨", 2.6, "手指放嘴邊吹口哨，小老虎跟著搖頭。", fr_changgui_whistle, null, fx_changgui_whistle, null],
		["guixinniang", "n30_guixinniang_veil", "整理紅蓋頭", 3.2, "雙手扶一扶蓋頭兩邊，蓋頭輕飄。", fr_guixinniang_veil, null, null, null],
		["guixinniang", "n30_guixinniang_twirl", "轉一圈", 2.6, "捧著繡球原地轉一圈，裙襬飄、花瓣落。", fr_guixinniang_twirl, null, fx_guixinniang_twirl, null],
		["guixinniang", "n30_guixinniang_wait", "等新郎", 3.6, "踮著望遠方，嘆一句「良人呢……」。", fr_guixinniang_wait, null, fx_guixinniang_wait, null],
		["shanxiao", "n30_shanxiao_hop", "原地單腳跳", 1.6, "單腳一蹦一蹦，長手跟著甩。", fr_shanxiao_hop, null, null, null],
		["shanxiao", "n30_shanxiao_scratch", "抓癢", 2.6, "長手伸到頭頂抓抓抓，毛屑飛。", fr_shanxiao_scratch, null, fx_shanxiao_scratch, null],
		["shanxiao", "n30_shanxiao_balance", "金雞獨立", 3.0, "單腳站著兩手張開，晃來晃去保持平衡。", fr_shanxiao_balance, null, null, null],
		["baigujing", "n30_baigujing_hair", "攏頭髮", 3.0, "手指慢慢攏一下鬢髮，髮簪的墜子晃。", fr_baigujing_hair, null, null, null],
		["baigujing", "n30_baigujing_laugh", "掩嘴笑", 2.4, "手掩著嘴「呵呵呵」，肩膀抖。", fr_baigujing_laugh, null, fx_baigujing_laugh, null],
		["baigujing", "n30_baigujing_pose", "擺姿勢", 3.0, "腰一扭、頭一側，自我欣賞。", fr_baigujing_pose, null, fx_baigujing_pose, null],
		["qionggui", "n30_qionggui_pockets", "翻空口袋", 2.8, "把兩個口袋翻出來抖一抖，只抖出灰塵。", fr_qionggui_pockets, null, fx_qionggui_pockets, null],
		["qionggui", "n30_qionggui_coin", "只剩一個銅板", 3.2, "翻出一個銅板，對著它嘆氣「一個……」。", fr_qionggui_coin, null, fx_qionggui_coin, null],
		["dugui", "n30_dugui_shuffle", "洗牌", 2.0, "兩手之間一張張牌飛過去（洗牌），一臉老手。", fr_dugui_shuffle, null, fx_dugui_shuffle, null],
		["dugui", "n30_dugui_dice", "擲骰子", 2.8, "骰子往地上一擲，滾幾下，看點數，「六！」興奮。", fr_dugui_dice, null, fx_dugui_dice, null],
		["dugui", "n30_dugui_pray", "求神拜佛", 2.6, "雙手合十拜三拜「發發發……」。", fr_dugui_pray, null, fx_dugui_pray, null],
		["jiugui", "n30_jiugui_drink", "喝一口", 3.0, "抱著酒埕仰頭灌一口，「嗝～」冒泡泡。", fr_jiugui_drink, null, fx_jiugui_drink, null],
		["jiugui", "n30_jiugui_sway", "醉醺醺晃", 3.4, "東倒西歪，差點跌倒又站穩。", fr_jiugui_sway, null, null, null],
		["jiugui", "n30_jiugui_sing", "唱歌", 2.8, "抱著酒埕打拍子唱歌，頭一點一點。", fr_jiugui_sing, null, fx_jiugui_sing, null],
		["yangui", "n30_yangui_puff", "吐煙圈", 3.2, "煙斗湊到嘴邊吸一口，吐出三個煙圈慢慢飄走。", fr_yangui_puff, null, fx_yangui_puff, null],
		["yangui", "n30_yangui_cough", "咳不停", 2.4, "彎腰咳咳咳，咳到整個人抖。", fr_yangui_cough, null, fx_yangui_cough, null],
		["guhangui", "n30_guhangui_count", "數錢", 3.0, "銅錢舉起來對著光看，一枚一枚數「一、二……」。", fr_guhangui_count, null, fx_guhangui_count, null],
		["guhangui", "n30_guhangui_abacus", "打算盤", 2.4, "算盤搖得嘩啦響，手指撥珠「啪啪啪」。", fr_guhangui_abacus, null, fx_guhangui_abacus, null],
		["guhangui", "n30_guhangui_bite", "咬錢驗真", 2.8, "銅錢放到嘴邊咬一口驗真假，滿意點頭。", fr_guhangui_bite, null, fx_guhangui_bite, null],
		["taozhai", "n30_taozhai_shake", "抖欠單", 2.4, "欠單舉高猛抖，一臉兇。", fr_taozhai_shake, null, null, null],
		["taozhai", "n30_taozhai_knock", "拍門追數", 2.8, "對著空氣拍門「開門！還錢！」。", fr_taozhai_knock, null, fx_taozhai_knock, null],
		["taozhai", "n30_taozhai_paint", "刷紅油", 3.0, "油漆刷沾一沾，在地上刷個「債」字。", fr_taozhai_paint, null, fx_taozhai_paint, null],
		["danxiao", "n30_danxiao_shiver", "抖抖抖", 2.0, "抱著自己猛抖，汗一直流。", fr_danxiao_shiver, null, fx_danxiao_shiver, null],
		["danxiao", "n30_danxiao_peek", "偷看", 3.0, "慢慢探頭往前看……「有、有鬼？」。", fr_danxiao_peek, null, fx_danxiao_peek, null],
		["danxiao", "n30_danxiao_startle", "自己嚇自己", 2.2, "踩到自己影子嚇一跳「哇！」跳起來。", fr_danxiao_startle, null, fx_danxiao_startle, null],
		["maoshi", "n30_maoshi_trip", "跌倒又爬起", 3.0, "腳一絆整個人往前撲，趴一下，拍拍灰爬起來。", fr_maoshi_trip, null, fx_maoshi_trip, null],
		["maoshi", "n30_maoshi_rub", "揉頭上的包", 2.6, "手按著頭上的包揉，眼冒金星。", fr_maoshi_rub, null, fx_maoshi_rub, null],
		["hanturaya", "n30_hanturaya_loom", "漲大又縮回", 3.4, "黑影慢慢膨脹變高，再縮回來，邊緣黑煙翻滾。", fr_hanturaya_loom, pre_hanturaya_loom, null, null],
		["hanturaya", "n30_hanturaya_wisp", "冒黑煙", 2.8, "肩上一縷縷黑煙往上飄。", fr_hanturaya_wisp, null, fx_hanturaya_wisp, null],
		["polong", "n30_polong_bob", "在瓶口探頭", 3.0, "縮回瓶口又探出來，左右張望。", fr_polong_bob, null, null, null],
		["polong", "n30_polong_hop", "瓶子跳一跳", 1.8, "整個瓶子蹦兩下，裡面的血絲晃。", fr_polong_hop, null, null, null],
		["pelesit", "n30_pelesit_chirp", "唧唧叫", 2.2, "翅膀快速磨擦「唧唧」，觸鬚抖。", fr_pelesit_chirp, null, fx_pelesit_chirp, null],
		["pelesit", "n30_pelesit_clean", "洗觸鬚", 2.8, "低頭用前腳把觸鬚拉下來清一清。", fr_pelesit_clean, null, null, null],
		["pelesit", "n30_pelesit_hop", "蹦一下", 1.6, "後腿一彈，原地蹦起來。", fr_pelesit_hop, null, null, null],
		["jenglot", "n30_jenglot_hairflip", "甩頭髮", 2.6, "一甩頭，整頭長髮甩到一邊再落回。", fr_jenglot_hairflip, null, null, null],
		["jenglot", "n30_jenglot_hiss", "嘶嘶叫", 2.4, "縮著身子露出尖牙「嘶——」。", fr_jenglot_hiss, null, fx_jenglot_hiss, null],
		["hantugalah", "n30_hantugalah_peer", "從高處張望", 3.2, "手搭眉毛從很高的地方往遠處看。", fr_hantugalah_peer, null, null, null],
		["hantugalah", "n30_hantugalah_stretch", "伸懶腰", 3.0, "本來就很高，伸個懶腰又更高。", fr_hantugalah_stretch, null, null, null],
		["jerangkung", "n30_jerangkung_rattle", "骨頭喀喀抖", 2.0, "全身骨頭抖一抖、喀喀響。", fr_jerangkung_rattle, null, fx_jerangkung_rattle, null],
		["jerangkung", "n30_jerangkung_dance", "骷髏舞", 2.4, "扭腰甩手跳一段骷髏舞。", fr_jerangkung_dance, null, fx_jerangkung_dance, null],
		["genderuwo", "n30_genderuwo_chest", "搥胸", 2.2, "兩手輪流搥胸口「咚咚咚」。", fr_genderuwo_chest, null, fx_genderuwo_chest, null],
		["genderuwo", "n30_genderuwo_scratch", "抓跳蚤", 2.8, "撓撓肚子，抓到一隻跳蚤彈走。", fr_genderuwo_scratch, null, fx_genderuwo_scratch, null],
		["bunian", "n30_bunian_flicker", "時隱時現", 3.2, "身子一下透明一下現形，周圍金色光點飄。", fr_bunian_flicker, null, fx_bunian_flicker, null],
		["bunian", "n30_bunian_flower", "聞花", 3.0, "低頭聞頭上的花，閉眼一笑。", fr_bunian_flower, null, fx_bunian_flower, null],
		["maenak", "n30_maenak_reach", "伸手摘芒果", 3.2, "長手往上一伸，在空中摘了什麼，收回來聞一聞。", fr_maenak_reach, null, null, null],
		["maenak", "n30_maenak_hum", "哼歌搖擺", 3.0, "輕輕左右搖，哼著歌。", fr_maenak_hum, null, fx_maenak_hum, null],
		["maenak", "n30_maenak_wait", "等老公", 3.6, "望著遠方輕聲叫「Mak……」。", fr_maenak_wait, null, fx_maenak_wait, null],
		["phiam", "n30_phiam_yawn", "打哈欠", 3.0, "大大一個哈欠，睡帽的球甩一下。", fr_phiam_yawn, null, fx_phiam_yawn, null],
		["phiam", "n30_phiam_doze", "打瞌睡", 3.6, "頭慢慢垂下去、Zzz，突然驚醒。", fr_phiam_doze, null, fx_phiam_doze, null],
		["churel", "n30_churel_hair", "撥頭髮", 2.6, "手往後一撥長髮，手環叮噹響。", fr_churel_hair, null, fx_churel_hair, null],
		["churel", "n30_churel_dance", "跳舞", 2.4, "扭腰擺手跳一小段舞，腳鈴叮叮響。", fr_churel_dance, null, fx_churel_dance, null],
		["vetala", "n30_vetala_doze", "拄杖打瞌睡", 3.6, "靠著樹枝杖，頭一點一點打瞌睡。", fr_vetala_doze, null, fx_vetala_doze, null],
		["vetala", "n30_vetala_riddle", "出謎題", 3.0, "舉起手指搖一搖「猜猜看？」（屍鬼最愛出謎題）。", fr_vetala_riddle, null, fx_vetala_riddle, null],
		["kappa", "n30_kappa_refill", "補頭上的水", 3.0, "手捧一點水澆到頭頂的碟子，碟裡漾起水紋。", fr_kappa_refill, null, fx_kappa_refill, null],
		["kappa", "n30_kappa_cucumber", "啃青瓜", 2.6, "青瓜送到嘴邊「喀嚓喀嚓」啃。", fr_kappa_cucumber, null, fx_kappa_cucumber, null],
		["rokurokubi", "n30_rokurokubi_stretch", "伸長脖子張望", 3.4, "脖子往上一伸，頭左右張望，再縮回來。", fr_rokurokubi_stretch, null, null, null],
		["rokurokubi", "n30_rokurokubi_yawn", "打哈欠", 3.0, "頭往後一仰打個哈欠，脖子跟著扭。", fr_rokurokubi_yawn, null, fx_rokurokubi_yawn, null],
		["kuchisake", "n30_kuchisake_snip", "空剪", 2.2, "剪刀在空中咔嚓咔嚓剪兩下。", fr_kuchisake_snip, null, fx_kuchisake_snip, null],
		["kuchisake", "n30_kuchisake_ask", "「我漂亮嗎？」", 3.2, "頭一歪，慢慢問「我漂亮嗎？」。", fr_kuchisake_ask, null, fx_kuchisake_ask, null],
		["yukionna", "n30_yukionna_snow", "變出雪花", 3.2, "手心向上，一朵雪花慢慢長大、轉著飄走。", fr_yukionna_snow, null, fx_yukionna_snow, null],
		["yukionna", "n30_yukionna_breath", "呵一口冷氣", 2.8, "輕輕呵一口白氣，氣裡結出小冰晶。", fr_yukionna_breath, null, fx_yukionna_breath, null],
		["kasaobake", "n30_kasaobake_hop", "單腳跳", 1.6, "木屐一蹦一蹦，傘面跟著掀。", fr_kasaobake_hop, null, null, null],
		["kasaobake", "n30_kasaobake_lick", "舔舔嘴", 2.4, "長舌頭甩上來舔一圈。", fr_kasaobake_lick, null, null, null],
		["kasaobake", "n30_kasaobake_spin", "原地轉傘", 2.2, "整把傘原地轉一圈，破紙條飄。", fr_kasaobake_spin, null, null, null],
		["nopperabo", "n30_nopperabo_watch", "看手錶", 2.8, "舉起手腕看錶，跺腳「遲到了！」。", fr_nopperabo_watch, null, fx_nopperabo_watch, null],
		["nopperabo", "n30_nopperabo_tie", "整理領帶", 2.6, "兩手拉一拉領帶，挺胸。", fr_nopperabo_tie, null, null, null],
		["chochin", "n30_chochin_flicker", "火光忽明忽暗", 2.4, "燈籠裡的火一閃一閃，旁邊的鬼火繞著飄。", fr_chochin_flicker, pre_chochin_flicker, null, null],
		["chochin", "n30_chochin_tongue", "吐舌頭", 2.4, "大舌頭甩出來晃兩下又收回去。", fr_chochin_tongue, null, null, null],
		["gashadokuro", "n30_gashadokuro_rattle", "骨頭喀喀響", 2.4, "整副大骨架抖一抖，喀喀作響。", fr_gashadokuro_rattle, null, fx_gashadokuro_rattle, null],
		["gashadokuro", "n30_gashadokuro_hungry", "肚子餓張望", 3.4, "頭慢慢左右轉，下巴一開一合「餓……」。", fr_gashadokuro_hungry, null, fx_gashadokuro_hungry, null],
		["banshee", "n30_banshee_comb", "梳頭", 3.2, "（傳說她拿著梳子）手一下一下順著長髮往下梳。", fr_banshee_comb, null, null, null],
		["banshee", "n30_banshee_weep", "低頭哭", 3.2, "低頭啜泣，肩膀一抖一抖，眼淚往下掉。", fr_banshee_weep, null, fx_banshee_weep, null],
		["hannya", "n30_hannya_fume", "氣到冒煙", 2.6, "氣得發抖，頭頂冒煙、角尖冒火星。", fr_hannya_fume, null, fx_hannya_fume, null],
		["hannya", "n30_hannya_sulk", "哼！", 2.4, "把頭撇到一邊「哼！」。", fr_hannya_sulk, null, fx_hannya_sulk, null],
		["aswang", "n30_aswang_flap", "拍翅膀", 2.0, "背上的翅膀拍幾下，身子跟著一起一伏。", fr_aswang_flap, null, null, null],
		["aswang", "n30_aswang_sniff", "嗅味道", 3.0, "頭往前伸，一下一下嗅空氣，舌頭甩。", fr_aswang_sniff, null, fx_aswang_sniff, null],
		["tikbalang", "n30_tikbalang_smoke", "抽雪茄", 3.2, "深吸一口雪茄，鼻孔噴出兩道煙。", fr_tikbalang_smoke, null, fx_tikbalang_smoke, null],
		["tikbalang", "n30_tikbalang_stomp", "踏蹄", 2.2, "前蹄在地上刨兩下，塵土飛。", fr_tikbalang_stomp, null, fx_tikbalang_stomp, null],
		["tikbalang", "n30_tikbalang_mane", "甩鬃毛", 2.4, "頭一甩，鬃毛和尾巴一起甩。", fr_tikbalang_mane, null, null, null],
		["chehuo", "n30_chehuo_mirror", "照倒後鏡", 2.8, "舉起手上那塊倒後鏡照一照，整理裂開的安全帽。", fr_chehuo_mirror, null, null, null],
		["chehuo", "n30_chehuo_rev", "催油門", 2.2, "雙手握著空氣車把「嗚嗚～叭叭！」，屁股冒煙。", fr_chehuo_rev, null, fx_chehuo_rev, null],
		["diansi", "n30_diansi_zap", "又被電一下", 2.6, "插頭一閃，全身一抽、頭髮炸更高，冒一縷煙。", fr_diansi_zap, null, fx_diansi_zap, null],
		["diansi", "n30_diansi_plug", "找插座", 3.0, "拿著插頭東張西望，想找地方插。", fr_diansi_plug, null, fx_diansi_plug, null],
		["dongsi", "n30_dongsi_shiver", "冷到發抖", 2.2, "抱緊毯子猛抖，鼻涕冰柱晃。", fr_dongsi_shiver, null, fx_dongsi_shiver, null],
		["dongsi", "n30_dongsi_sneeze", "打噴嚏", 2.4, "「哈……哈啾！」噴出一團雪花。", fr_dongsi_sneeze, null, fx_dongsi_sneeze, null],
		["yezi", "n30_yezi_dizzy", "頭暈轉圈", 2.6, "眼冒金星，整個人晃來晃去。", fr_yezi_dizzy, null, fx_yezi_dizzy, null],
		["yezi", "n30_yezi_lookup", "緊張看天", 3.0, "抱著椰子緊張地抬頭看，怕再掉一顆。", fr_yezi_lookup, null, fx_yezi_lookup, null],
		["liulian", "n30_liulian_sniff", "聞榴槤", 2.8, "把榴槤湊到鼻子前聞一聞，陶醉。", fr_liulian_sniff, null, fx_liulian_sniff, null],
		["liulian", "n30_liulian_rub", "揉頭上的刺孔", 2.6, "手摸摸頭上被刺的地方「痛痛痛」。", fr_liulian_rub, null, fx_liulian_rub, null],
		["yesi", "n30_yesi_eat", "又夾一顆湯圓", 3.0, "筷子夾起碗裡的湯圓送進嘴，卡住，捶胸口。", fr_yesi_eat, null, fx_yesi_eat, null],
		["yesi", "n30_yesi_cough", "咳咳", 2.2, "彎腰用力咳。", fr_yesi_cough, null, fx_yesi_cough, null],
		["xiaosi", "n30_xiaosi_laugh", "笑到停不下", 2.4, "抱著肚子笑到彎腰、眼淚噴。", fr_xiaosi_laugh, null, fx_xiaosi_laugh, null],
		["xiaosi", "n30_xiaosi_slap", "拍大腿", 2.6, "笑到拍大腿。", fr_xiaosi_slap, null, fx_xiaosi_slap, null],
		["xiasi", "n30_xiasi_jump", "自己嚇自己", 2.2, "聽到聲音嚇到彈起來，頭髮再炸一次。", fr_xiasi_jump, null, fx_xiasi_jump, null],
		["xiasi", "n30_xiasi_look", "左顧右盼", 3.0, "緊張地左看右看。", fr_xiasi_look, null, null, null],
		["leipi", "n30_leipi_smoke", "頭頂冒煙", 2.8, "焦黑的頭冒著煙，咳出一團黑煙。", fr_leipi_smoke, null, fx_leipi_smoke, null],
		["leipi", "n30_leipi_umbrella", "撐破傘", 3.0, "把破傘撐高看天「今天不會再打雷吧……」。", fr_leipi_umbrella, null, fx_leipi_umbrella, null],
		["zipai", "n30_zipai_selfie", "自拍", 2.6, "舉高自拍棒擺個 YA，「咔嚓」閃一下。", fr_zipai_selfie, null, fx_zipai_selfie, null],
		["zipai", "n30_zipai_check", "看照片", 3.0, "把手機拉回來看照片，點點頭「讚！」。", fr_zipai_check, null, fx_zipai_check, null],
		["zhongshu", "n30_zhongshu_wipe", "抹汗", 2.6, "毛巾抹一把臉上的汗，汗水甩出去。", fr_zhongshu_wipe, null, fx_zhongshu_wipe, null],
		["zhongshu", "n30_zhongshu_lick", "舔雪條", 2.8, "雪條在融，趕快舔一口，滴得到處都是。", fr_zhongshu_lick, null, fx_zhongshu_lick, null],
		["chengsi", "n30_chengsi_eat", "繼續吃", 2.4, "叉子叉一口塞進嘴，嚼嚼嚼。", fr_chengsi_eat, null, fx_chengsi_eat, null],
		["chengsi", "n30_chengsi_burp", "打飽嗝", 2.6, "肚子一挺「嗝～」，腰帶快爆開。", fr_chengsi_burp, null, fx_chengsi_burp, null],
		["shedu", "n30_shedu_hop", "痛到跳腳", 2.0, "被咬著屁股一跳一跳。", fr_shedu_hop, null, fx_shedu_hop, null],
		["shedu", "n30_shedu_shake", "甩蛇", 2.6, "扭屁股想把蛇甩掉，甩不掉。", fr_shedu_shake, null, null, null],
		["shidu", "n30_shidu_cramp", "肚子痛", 2.6, "抱著肚子彎腰，臉更綠。", fr_shidu_cramp, null, fx_shidu_cramp, null],
		["shidu", "n30_shidu_run", "急著找廁所", 2.0, "抱著廁紙原地小碎步，左右張望。", fr_shidu_run, null, fx_shidu_run, null],
		["daji", "n30_daji_play", "狂按手掣", 2.2, "低頭狂按，嘴巴開著流口水。", fr_daji_play, null, fx_daji_play, null],
		["daji", "n30_daji_yawn", "通宵打呵欠", 3.0, "伸懶腰打個大呵欠，再拿起能量飲料。", fr_daji_yawn, null, fx_daji_yawn, null],
		["xiangcai", "n30_xiangcai_flap", "被風吹", 2.4, "扁扁的身體被風吹得一飄一飄。", fr_xiangcai_flap, null, null, null],
		["xiangcai", "n30_xiangcai_inflate", "吹氣復原", 3.0, "拼命吸氣想鼓回原形，鼓一下又扁回去。", fr_xiangcai_inflate, null, fx_xiangcai_inflate, null],
	]
