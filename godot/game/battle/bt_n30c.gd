# 新鬼專屬招式（原生）第三批：Vetala、河童、轆轤首、裂口女、雪女、唐傘妖、無臉鬼、提燈妖、餓者髑髏、Banshee、般若、Aswang、Tikbalang
class_name BtN30c
extends BtN30

static func table() -> Dictionary:
	return {"n30_vetala": vetala, "n30_kappa": kappa, "n30_rokurokubi": rokurokubi, "n30_kuchisake": kuchisake, "n30_yukionna": yukionna, "n30_kasaobake": kasaobake,
		"n30_nopperabo": nopperabo, "n30_chochin": chochin, "n30_gashadokuro": gashadokuro, "n30_banshee": banshee, "n30_hannya": hannya, "n30_aswang": aswang, "n30_tikbalang": tikbalang}

static func V(x: float, y: float) -> Vector2: return Vector2(x, y)
static func sgn1(v: float) -> float: return signf(v) if v != 0 else 1.0

# Vetala：倒吊由天而降
static func vetala(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var HX = S.tx - 0.3 * th; var HY = S.ty - 0.62 * th
	var swing = sin((t - 0.22) * 22) * 10 * (1 - seg(t, 0.3, 0.45)) if t > 0.22 and t < 0.45 else 0.0
	var f = kf(t, [[0, {}], [0.08, {"sy": 0.85, "sx": 1.05}], [0.16, {"y": -1.5 * H, "x": HX * 0.5, "r": 90, "sy": 1.05}, "o"], [0.22, {"y": HY + 0.02 * H, "x": HX, "r": 180}, "i"], [TC, {"y": HY + 0.1 * H, "x": HX, "r": 185, "head": 0.2}], [0.40, {"y": HY + 0.08 * H, "x": HX, "r": 180}], [0.48, {"y": -1.6 * H, "x": HX * 0.5, "r": 250}, "i"], [0.54, {"y": -0.25 * H, "x": 0, "r": 360}, "o"], [0.59, {"r": 360}]])
	f["r"] = g(f, "r") + swing; f["px"] = 0.0; f["py"] = -0.5 * H
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / (1.5 * H)))
	if t > 0.19 and t < 0.47:
		var m = bm(S, f); var ft = m * Vector2.ZERO; var top = V(ft.x - sin(swing * D) * 0.6 * H, ft.y - 1.8 * H)
		crayon(ctx, [ft, V((ft.x + top.x) / 2 + 0.03 * H, (ft.y + top.y) / 2), top], "#6a4a2a", 0.03 * H, 381)
		crayon(ctx, [V(top.x - 0.4 * H, top.y + 0.05 * H), V(top.x + 0.4 * H, top.y - 0.04 * H)], "#5a3a1a", 0.06 * H, 382)
	whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.75); var p = t - TC
	if p >= 0 and p < 0.3:
		for i in 3:
			var k = cl(p / 0.3 - i * 0.15)
			if k > 0 and k < 1: ring(ctx, T.x - 0.2 * th, T.y, (0.1 + k * 0.35) * th, (0.15 + k * 0.5) * th, "rgba(220,255,220,.8)", 0.02 * th, 1 - k)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#e0ffd8", 385, 9)
	pop(ctx, S, T.x, T.y - 0.4 * th, "嘎！", 0.26 * th, "#d8ffc8", TC, 0.3)
	end(ctx); return true

# 河童：鞠躬潑水
static func kappa(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.10, {"r": -5, "head": -0.1}], [0.24, {"r": 28, "body": 0.35, "head": 0.35, "armF": 0.4, "armB": -0.3, "x": 0.04 * H}, "o"], [0.36, {"r": 26, "body": 0.3, "head": 0.3, "x": 0.04 * H}], [0.50, {"r": -3, "head": -0.05, "armF": -0.9}], [0.59, {}]])
	f["px"] = 0.0; f["py"] = 0.0
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var dish = at(S, m, 0.47, 0.05); var T = tgt(S, 0.75); var q = seg(t, 0.2, TC)
	if t > 0.2 and t < TC + 0.02:
		for i in 10:
			var k = cl(q - i * 0.04); var x = lerp_(dish.x, T.x, k); var y = lerp_(dish.y, T.y + (rnd(i) - 0.5) * 0.3 * th, k) - 0.18 * H * sin(k * PI)
			ctx.fillStyle = Color(120 / 255.0, 190 / 255.0, 240 / 255.0, 0.85); ctx.strokeStyle = Color(30 / 255.0, 70 / 255.0, 110 / 255.0, 0.7); ctx.lineWidth = 0.006 * H; ctx.beginPath(); ctx.ellipse(x, y, (0.03 + rnd(i + 3) * 0.025) * H, 0.022 * H, 0.4, 0, 7); ctx.fill(); ctx.stroke()
	var p = t - TC
	drops(ctx, T.x, T.y, 0.6 * th, seg(t, TC, 0.5), "rgba(130,200,250,.95)", 391, 12, 3.2)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.35 * th, 1 - p / 0.13, "#c8ecff", 393, 10)
	pop(ctx, S, T.x, T.y - 0.4 * th, "嘩啦！", 0.22 * th, "#a8dcff", TC, 0.3)
	pop(ctx, S, dish.x, dish.y - 0.12 * H, "我啲水呀！", 0.1 * H, "#a8dcff", 0.47, 0.12)
	end(ctx); return true

# 轆轤首：伸長條頸頭槌
static func rokurokubi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var AP = [0.43, 0.30]; var HC = [0.22, 0.27]
	var SRC = [[0.43, 0.30], [0.52, 0.275], [0.61, 0.265], [0.70, 0.285], [0.735, 0.345], [0.715, 0.41], [0.66, 0.46], [0.615, 0.51], [0.60, 0.585]]
	var f = kf(t, [[0, {}], [0.16, {"r": -4, "armF": 0.2, "armB": -0.2}], [TC, {"r": 6, "x": 0.02 * H}, "i"], [0.59, {}]])
	var m = bm(S, f); var A0 = at(S, m, AP[0], AP[1]); var B = at(S, m, 0.60, 0.585); var T = tgt(S, 0.85)
	var ho = V((1.0 if S.nr else -1.0) * (HC[0] - AP[0]) * S.W, (HC[1] - AP[1]) * S.H)
	var G = V(T.x - ho.x - 0.12 * th, T.y - ho.y)
	var wob = sin((t - TC) * 40) * 0.05 * H * (1 - seg(t, TC, 0.45)) if t > TC and t < 0.45 else 0.0
	var P = kf(t, [[0, {"x": A0.x, "y": A0.y, "r": 0}], [0.16, {"x": A0.x - 0.1 * H, "y": A0.y - 0.22 * H, "r": -15}], [TC, {"x": G.x, "y": G.y, "r": 18}, "i"], [0.33, {"x": G.x - 0.03 * H, "y": G.y - 0.02 * H, "r": 8}], [0.59, {"x": A0.x, "y": A0.y, "r": 0}]])
	var b = g(kf(t, [[0, {"v": 0}], [0.05, {"v": 1}], [0.54, {"v": 1}], [0.59, {"v": 0}]]), "v")
	var Ap = V(P.x, P.y + wob); var ctrl = V((Ap.x + B.x) / 2 + 0.05 * H, minf(Ap.y, B.y) - 0.25 * H * (1 - seg(t, 0.16, TC) * 0.6))
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	ribbon(ctx, S, "neck", SRC, 0.03, line(S, m, SRC, Ap, ctrl, B, b))
	piece_at(ctx, S, "head", Ap.x, Ap.y, P.r, AP[0], AP[1])
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x - 0.1 * th, T.y, 0.3 * th, 1 - p / 0.13, "#ffe8f0", 401, 10)
	if p >= 0 and p < 0.3: stars(ctx, T.x, T.y - 0.2 * th, 0.18 * th, t, 1 - p / 0.3)
	pop(ctx, S, T.x, T.y - 0.45 * th, "咚！", 0.24 * th, "#ffd0e0", TC, 0.28)
	end(ctx); return true

# 裂口女：「我靚唔靚？」較剪咔嚓
static func kuchisake(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.21, 0.53]
	var f = kf(t, [[0, {}], [0.16, {"head": -0.25, "r": -4, "hairL": 0.1, "hairR": 0.1}], [TC, {"head": 0.12, "r": 9, "x": 0.12 * H, "legF": 0.25, "legB": -0.15, "hairL": -0.25, "hairR": -0.3}, "i"], [0.36, {"head": 0.1, "r": 8, "x": 0.12 * H, "legF": 0.22, "legB": -0.12}], [0.59, {}]])
	var m = bm(S, f); var w0 = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.72); var L = 0.32 * H; var ang = 40.0
	var dir = (-60 + ang) * D; var G = V(T.x - L * cos(dir), T.y - L * sin(dir))
	var W = kf(t, [[0, {"x": w0.x, "y": w0.y, "r": 0}], [0.16, {"x": w0.x - 0.05 * H, "y": w0.y - 0.12 * H, "r": -25}], [TC, {"x": G.x, "y": G.y, "r": ang}, "i"], [0.36, {"x": G.x - 0.02 * H, "y": G.y, "r": ang - 5}], [0.59, {"x": w0.x, "y": w0.y, "r": 0}]])
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	piece_at(ctx, S, "scissors", W.x, W.y, W.r, PV[0], PV[1])
	var hd = at(S, m, 0.45, 0.12)
	pop(ctx, S, hd.x - 0.05 * H, hd.y - 0.12 * H, "我靚唔靚？", 0.1 * H, "#ffe0e0", 0.02, 0.24)
	var p = t - TC
	if p >= 0 and p < 0.2:
		var k = minf(1, p / 0.05); var r = 0.2 * th
		for sg in [-1, 1]: crayon(ctx, [V(T.x - r, T.y + sg * r * (1 - k)), V(T.x + r, T.y - sg * r * (1 - k))], "rgba(255,255,255,.95)", 0.03 * th, 411 + sg)
	if p >= 0 and p < 0.35:
		for i in 4: crayon(ctx, [V(T.x + (i - 1.5) * 0.04 * th, T.y + p * 0.6 * th + i * 0.02 * th), V(T.x + (i - 1.5) * 0.04 * th + 0.05 * th, T.y + p * 0.6 * th + 0.06 * th)], "#2a2020", 0.008 * th, 415 + i)
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.28 * th, 1 - p / 0.12, "#ffffff", 419, 8)
	pop(ctx, S, T.x, T.y - 0.38 * th, "咔嚓！", 0.22 * th, "#ffffff", TC, 0.3)
	end(ctx); return true

# 雪女：吐冰霜
static func yukionna(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.17, {"sy": 1.05, "head": -0.18, "r": -4, "hairR": 0.2}], [0.24, {"sy": 0.98, "head": 0.15, "r": 6, "x": 0.02 * H, "hairR": -0.15}, "o"], [0.42, {"head": 0.12, "r": 5}], [0.59, {}]])
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.35)
	var m = bm(S, f); var mo = at(S, m, 0.42, 0.255); var T = tgt(S, 0.65)
	var reach = seg(t, 0.2, TC); var fade = 1 - seg(t, 0.4, 0.55)
	if t > 0.2 and fade > 0:
		var ex = lerp_(mo.x, T.x, BtMoves.eo(reach)); var ey = lerp_(mo.y, T.y, BtMoves.eo(reach))
		for i in 4:
			var pts = []
			for j in 11:
				var q = j / 10.0; var w = (0.02 + q * 0.12) * H; pts.append(V(lerp_(mo.x, ex, q), lerp_(mo.y, ey, q) + sin(q * 8 + t * 30 + i * 1.6) * w * 0.5 + (i - 1.5) * w * 0.4))
			ctx.save(); ctx.globalAlpha *= fade * 0.8; crayon(ctx, pts, "rgba(220,240,255,.85)" if i % 2 else "rgba(170,215,255,.8)", 0.025 * H, 421 + i); ctx.restore()
		for i in 6:
			var q = cl(reach * 1.1 - i * 0.12); var x = lerp_(mo.x, ex, q); var y = lerp_(mo.y, ey, q) + sin(i * 2 + t * 12) * 0.05 * H; var r = 0.03 * H
			ctx.save(); ctx.globalAlpha *= fade; ctx.translate(x, y); ctx.rotate(t * 5 + i); ctx.strokeStyle = Color("#eaf6ff"); ctx.lineWidth = r * 0.25; ctx.beginPath()
			for k in 3:
				var an = k * PI / 3; ctx.moveTo(-cos(an) * r, -sin(an) * r); ctx.lineTo(cos(an) * r, sin(an) * r)
			ctx.stroke(); ctx.restore()
	var p = t - TC
	if p >= 0:
		var al = 1 - seg(t, 0.48, 0.59); var k = cl(p / 0.06); ctx.save(); ctx.globalAlpha *= al
		for i in 7:
			var x = T.x + (rnd(i + 430) - 0.5) * 0.4 * th; var y = T.y + (rnd(i + 440) - 0.5) * 0.7 * th; var h = (0.08 + rnd(i + 450) * 0.1) * th * k; var an = (rnd(i + 460) - 0.5) * 1.2
			ctx.save(); ctx.translate(x, y); ctx.rotate(an); ctx.fillStyle = Color(200 / 255.0, 235 / 255.0, 1, 0.8); ctx.strokeStyle = Color(80 / 255.0, 140 / 255.0, 200 / 255.0, 0.9); ctx.lineWidth = 0.01 * th
			ctx.beginPath(); ctx.moveTo(0, -h); ctx.lineTo(h * 0.35, 0); ctx.lineTo(0, h * 0.4); ctx.lineTo(-h * 0.35, 0); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore()
		ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.33 * th, 1 - p / 0.13, "#e8f6ff", 471, 10)
	pop(ctx, S, T.x, T.y - 0.5 * th, "凍！", 0.24 * th, "#c8e8ff", TC, 0.3)
	end(ctx); return true

# 唐傘妖：單腳跳過去舔一啖
static func kasaobake(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.35 * th - 0.35 * S.W)
	var SRC = [[0.52, 0.475], [0.60, 0.49], [0.68, 0.53], [0.73, 0.60], [0.735, 0.67], [0.73, 0.72]]
	var f = kf(t, [[0, {}], [0.12, {"sy": 0.85, "sx": 1.08, "head": -0.06}], [0.19, {"x": D2 * 0.6, "y": -0.3 * H, "sy": 1.08, "sx": 0.95, "r": -8}, "o"], [0.24, {"x": D2, "y": 0, "sy": 0.9, "sx": 1.06, "r": 6}, "i"], [0.36, {"x": D2, "sy": 1, "r": 4}], [0.46, {"x": D2 * 0.5, "y": -0.22 * H, "sy": 1.05}, "o"], [0.52, {"x": D2 * 0.3, "y": 0, "sy": 0.92}, "i"], [0.56, {"x": D2 * 0.1, "y": -0.1 * H}, "o"], [0.59, {}, "i"]])
	var m = bm(S, f); var root = at(S, m, 0.52, 0.475); var T0 = tgt(S, 0.6); var T1 = tgt(S, 0.95)
	var tipR = at(S, m, 0.73, 0.72)
	var P = kf(t, [[0, {"x": tipR.x, "y": tipR.y}], [0.22, {"x": tipR.x, "y": tipR.y}], [TC, {"x": T0.x, "y": T0.y}, "i"], [0.36, {"x": T1.x + 0.05 * th, "y": T1.y}], [0.44, {"x": tipR.x, "y": tipR.y}]])
	if t > 0.44: P["x"] = tipR.x; P["y"] = tipR.y
	var b = g(kf(t, [[0, {"v": 0}], [0.22, {"v": 0}], [0.25, {"v": 1}], [0.40, {"v": 1}], [0.44, {"v": 0}]]), "v")
	var tip = V(P.x, P.y); var ctrl = V((root.x + tip.x) / 2, maxf(root.y, tip.y) + 0.12 * H)
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / H) * 0.6); body(ctx, S, m, pose(S, f, 0.3), key)
	ribbon(ctx, S, "tongue", SRC, 0.045, line(S, m, SRC, root, ctrl, tip, b))
	var p = t - TC
	drops(ctx, T0.x, T0.y, 0.4 * th, seg(t, TC, 0.5), "rgba(220,240,255,.9)", 481, 7, 1.4)
	if p > 0 and p < 0.3:
		ctx.save(); ctx.globalAlpha *= 1 - p / 0.3; ctx.strokeStyle = Color(230 / 255.0, 245 / 255.0, 1, 0.8); ctx.lineWidth = 0.012 * th
		ctx.beginPath(); ctx.moveTo(T0.x, T0.y); ctx.quadraticCurveTo(T0.x + 0.02 * th, T0.y + 0.25 * th, T0.x + 0.05 * th, T0.y + 0.12 * th); ctx.stroke(); ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T0.x, T0.y, 0.28 * th, 1 - p / 0.13, "#ffd0d0", 485, 8)
	pop(ctx, S, T1.x, T1.y - 0.2 * th, "舔～", 0.24 * th, "#ffb0b8", TC + 0.02, 0.3)
	end(ctx); return true

# 無臉鬼：公事包一記上勾
static func nopperabo(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.24, 0.66]
	var f = kf(t, [[0, {}], [0.16, {"r": -6, "x": -0.03 * H, "armF": 0.35, "head": -0.08}], [TC, {"r": 9, "x": 0.1 * H, "armF": -0.4, "head": 0.1, "legF": 0.25, "legB": -0.15}, "i"], [0.36, {"r": 8, "x": 0.1 * H, "armF": -0.45, "legF": 0.22, "legB": -0.12}], [0.59, {}]])
	var m = bm(S, f); var w0 = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.72); var RT = -120.0; var v = 0.16 * H; var s = sin(RT * D); var c = cos(RT * D)
	var G = V(T.x + v * s - 0.04 * th, T.y - v * c)
	var W = kf(t, [[0, {"x": w0.x, "y": w0.y, "r": 0}], [0.16, {"x": w0.x - 0.12 * H, "y": w0.y - 0.04 * H, "r": 75}], [TC, {"x": G.x, "y": G.y, "r": RT}, "i"], [0.36, {"x": G.x + 0.02 * H, "y": G.y - 0.03 * H, "r": RT - 15}], [0.59, {"x": w0.x, "y": w0.y, "r": 0}]])
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	if t > 0.17 and t < 0.3: speed(ctx, W.x, W.y - 0.1 * H, 0.6, -1, 0.3 * H, 0.15 * H, seg(t, 0.17, 0.21), "rgba(230,230,240,.7)", 491, 4)
	piece_at(ctx, S, "case", W.x, W.y, W.r, PV[0], PV[1])
	var p = t - TC
	if p >= 0 and p < 0.4:
		for i in 6:
			var an = -PI * (0.2 + 0.6 * rnd(i + 500)); var sp = (0.5 + rnd(i + 510)) * 1.0 * th; var x = T.x + cos(an) * sp * p; var y = T.y + sin(an) * sp * p + 1.5 * th * p * p
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.4; ctx.translate(x, y); ctx.rotate(p * 12 + i); ctx.fillStyle = Color("#fbfbf6"); ctx.strokeStyle = Color("#4a4a5a"); ctx.lineWidth = 0.008 * th
			ctx.fillRect(-0.05 * th, -0.065 * th, 0.1 * th, 0.13 * th); ctx.strokeRect(-0.05 * th, -0.065 * th, 0.1 * th, 0.13 * th)
			ctx.beginPath()
			for k in 3: ctx.moveTo(-0.03 * th, -0.03 * th + k * 0.03 * th); ctx.lineTo(0.03 * th, -0.03 * th + k * 0.03 * th)
			ctx.stroke(); ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#f0f0ff", 521, 9)
	pop(ctx, S, T.x, T.y - 0.45 * th, "返工！", 0.22 * th, "#e8e8ff", TC, 0.3)
	end(ctx); return true

# 提燈妖：噴火咬一啖
static func chochin(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.3 * th - 0.4 * S.W)
	var f = kf(t, [[0, {}], [0.17, {"sx": 1.12, "sy": 1.1, "r": -8, "x": -0.03 * H, "tongue": 0.3, "flame": 0.3}], [0.24, {"sx": 1.08, "sy": 1.15, "r": 10, "x": D2 * 0.8, "tongue": -0.3}, "o"], [TC, {"sx": 1.15, "sy": 0.78, "r": 12, "x": D2, "tongue": 0.1}, "i"], [0.36, {"sx": 1.0, "sy": 1.05, "r": 8, "x": D2}], [0.59, {}]])
	f["px"] = 0.0; f["py"] = -0.5 * H
	begin(ctx, S, g(f, "x"))
	var glow = g(kf(t, [[0, {"v": 0}], [0.17, {"v": 1}], [0.36, {"v": 1}], [0.59, {"v": 0}]]), "v")
	if glow > 0:
		var fx = g(f, "x"); var gr = ctx.createRadialGradient(fx, -0.5 * H, 0, fx, -0.5 * H, 0.6 * H)
		gr.addColorStop(0, Color(1, 170 / 255.0, 60 / 255.0, 0.4 * glow)); gr.addColorStop(1, Color(1, 170 / 255.0, 60 / 255.0, 0)); ctx.fillStyle = gr; ctx.fillRect(fx - 0.6 * H, -1.1 * H, 1.2 * H, 1.2 * H)
	whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.6); var p = t - TC
	if p >= 0 and p < 0.35:
		for i in 7:
			var k = p / 0.35; var x = T.x + (rnd(i + 530) - 0.5) * 0.4 * th; var y = T.y - k * 0.4 * th - rnd(i + 540) * 0.2 * th; var r = (0.08 + rnd(i + 550) * 0.06) * th * (1 - k * 0.6)
			ctx.save(); ctx.globalAlpha *= 1 - k; ctx.translate(x, y); ctx.fillStyle = Color("#ffb030") if i % 2 else Color("#ff6a20"); ctx.strokeStyle = Color("#7a2a08"); ctx.lineWidth = r * 0.1
			ctx.beginPath(); ctx.moveTo(0, -r * 1.4); ctx.quadraticCurveTo(r, -r * 0.2, r * 0.6, r * 0.5); ctx.quadraticCurveTo(0, r, -r * 0.6, r * 0.5); ctx.quadraticCurveTo(-r, -r * 0.2, 0, -r * 1.4); ctx.fill(); ctx.stroke()
			ctx.fillStyle = Color("#ffe680"); ctx.beginPath(); ctx.ellipse(0, r * 0.2, r * 0.3, r * 0.4, 0, 0, 7); ctx.fill(); ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.34 * th, 1 - p / 0.13, "#ffd27a", 561, 10)
	pop(ctx, S, T.x, T.y - 0.5 * th, "啊嗚！", 0.24 * th, "#ffb050", TC - 0.02, 0.3)
	puff(ctx, 0.2 * H, -0.7 * H, 0.08 * H, seg(t, 0.44, 0.59), "rgba(120,110,110,.5)", 562, 4)
	end(ctx); return true

# 餓者髑髏：巨手一拍
static func gashadokuro(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.4 * th - 0.45 * S.W)
	var f = kf(t, [[0, {}], [0.17, {"r": -8, "armF": -0.9, "armB": -0.2, "head": -0.15, "x": -0.03 * H}], [TC, {"r": 10, "armF": 0.15, "armB": 0.1, "head": 0.15, "x": D2, "sy": 0.95}, "i"], [0.36, {"r": 9, "armF": 0.2, "head": 0.12, "x": D2, "sy": 0.96}], [0.59, {}]])
	f["px"] = 0.2 * H; f["py"] = 0.0
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.5); var p = t - TC
	if t > 0.18 and t < 0.29: speed(ctx, T.x, T.y - 0.3 * th, 0.5, 1, 0.5 * H, 0.3 * H, seg(t, 0.18, 0.22), "rgba(245,240,225,.6)", 571, 5)
	for i in 5: puff(ctx, T.x + (i - 2) * 0.18 * th, S.ty - 0.05 * th, 0.1 * th, seg(t, TC + i * 0.01, 0.52), "rgba(200,190,170,.6)", 575 + i, 3)
	if p >= 0 and p < 0.14: burst(ctx, T.x, T.y, 0.45 * th, 1 - p / 0.14, "#fff6e0", 581, 12)
	pop(ctx, S, g(f, "x") - 0.1 * H, -1.0 * H, "喀喀喀", 0.12 * H, "#f6efd8", 0.05, 0.2)
	pop(ctx, S, T.x, T.y - 0.6 * th, "啪！", 0.28 * th, "#fff6e0", TC, 0.3)
	end(ctx); return true

# Banshee：報喪尖叫
static func banshee(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var sh = sin(t * 120) * 0.008 * H if t > 0.2 and t < 0.42 else 0.0
	var f = kf(t, [[0, {}], [0.17, {"head": -0.3, "body": -0.1, "sy": 1.06, "hairL": 0.35, "hairR": 0.35, "armF": 0.3, "armB": -0.3, "y": -0.03 * H}], [0.23, {"head": 0.2, "body": 0.1, "r": 6, "hairL": -0.5, "hairR": -0.5, "armF": -0.4, "armB": 0.4}, "o"], [0.42, {"head": 0.15, "r": 5, "hairL": -0.4, "hairR": -0.4}], [0.59, {}]])
	f["x"] = g(f, "x") + sh
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var mo = at(S, m, 0.5, 0.26); var T = tgt(S, 0.7)
	for i in 5:
		var q = seg(t, 0.2 + i * 0.03, TC + i * 0.03 + 0.02)
		if q <= 0 or q >= 1: continue
		var x = lerp_(mo.x + 0.05 * H, T.x + 0.1 * th, q); var r = (0.08 + q * 0.3) * H
		ctx.save(); ctx.globalAlpha *= sin(q * PI); ctx.strokeStyle = Color(200 / 255.0, 220 / 255.0, 1, 0.95) if i % 2 else Color(1, 1, 1, 0.95); ctx.lineWidth = 0.045 * H
		ctx.beginPath(); ctx.arc(x - r, lerp_(mo.y, T.y, q), r, -0.6, 0.6); ctx.stroke(); ctx.restore()
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.35 * th, 1 - p / 0.13, "#dfe8ff", 591, 10)
	pop(ctx, S, mo.x + 0.1 * H, mo.y - 0.3 * H, "啊——！", 0.14 * H, "#dfe8ff", 0.2, 0.3)
	end(ctx); return true

# 般若：妒火暴衝
static func hannya(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.35 * th - 0.35 * H)
	var sh = sin(t * 110) * 0.01 * H * seg(t, 0, 0.1) if t < 0.2 else 0.0
	var keys = [[0, {}], [0.18, {"r": -6, "armF": -0.9, "armB": -0.7, "head": -0.1, "sy": 1.04}], [TC, {"r": 14, "x": D2, "armF": -0.5, "armB": -0.4, "head": 0.15}, "i"], [0.36, {"r": 12, "x": D2, "armF": -0.3, "armB": -0.2, "head": 0.1}], [0.59, {}]]
	var f = kf(t, keys); f["x"] = g(f, "x") + sh
	begin(ctx, S, g(f, "x"))
	if t > 0.2 and t < 0.36:
		for i in [2, 1]:
			var gg = kf(t - i * 0.025, keys); ctx.save(); ctx.globalAlpha *= 0.22 * (3 - i) / 2.0; whole(ctx, S, gg, "", 0.3); ctx.restore()
	var fire = g(kf(t, [[0, {"v": 0}], [0.12, {"v": 1}], [0.40, {"v": 1}], [0.59, {"v": 0}]]), "v")
	var m = bm(S, f)
	whole(ctx, S, f, "", 0.3)
	if fire > 0:
		for u in [0.18, 0.62]:
			var hn = at(S, m, u, 0.04)
			for i in 3:
				var k = fmod(t * 4 + i / 3.0, 1.0); var r = 0.05 * H * (1 - k) * fire
				ctx.save(); ctx.globalAlpha *= (1 - k) * fire; ctx.fillStyle = Color("#ff4020") if i % 2 else Color("#ff9a30"); ctx.beginPath(); ctx.ellipse(hn.x + sin(t * 20 + i) * 0.02 * H, hn.y - k * 0.15 * H, r * 0.6, r, 0, 0, 7); ctx.fill(); ctx.restore()
	var sm = at(S, m, 0.42, 0.02)
	puff(ctx, sm.x, sm.y, 0.06 * H, seg(t, 0.02, 0.3), "rgba(240,240,240,.5)", 601, 3)
	var T = tgt(S, 0.62); var p = t - TC
	if p >= 0 and p < 0.3:
		for sg in [-1, 1]:
			for i in 3:
				var k = minf(1, p / 0.05); var o = (i - 1) * 0.06 * th; var A = V(T.x - 0.2 * th * sg + o, T.y - 0.22 * th); var B = V(T.x + 0.2 * th * sg + o, T.y + 0.22 * th)
				crayon(ctx, [A, A.lerp(B, k)], "rgba(230,40,50,.9)", 0.025 * th, 611 + i + sg * 5)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.32 * th, 1 - p / 0.13, "#ffb0b0", 621, 9)
	pop(ctx, S, T.x, T.y - 0.45 * th, "妒忌！", 0.22 * th, "#ff6060", TC, 0.3)
	end(ctx); return true

# Aswang：長脷吸血
static func aswang(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var SRC = [[0.235, 0.335], [0.20, 0.39], [0.15, 0.45], [0.10, 0.52], [0.095, 0.58], [0.10, 0.62]]
	var flap = sin(t * 30) * 0.25
	var f = kf(t, [[0, {}], [0.16, {"r": -5, "head": -0.12, "cape": -0.5}], [TC, {"r": 8, "head": 0.12, "cape": 0.3, "x": 0.03 * H}, "i"], [0.42, {"r": 6, "head": 0.1, "x": 0.03 * H}], [0.59, {}]])
	f["cape"] = g(f, "cape") + (flap if t > 0.1 and t < 0.5 else 0.0)
	var m = bm(S, f); var root = at(S, m, 0.235, 0.335); var T = tgt(S, 0.7); var tipR = at(S, m, 0.10, 0.62)
	var P = kf(t, [[0, {"x": tipR.x, "y": tipR.y}], [0.16, {"x": root.x + 0.08 * H, "y": root.y + 0.12 * H}], [TC, {"x": T.x, "y": T.y}, "i"], [0.42, {"x": T.x, "y": T.y}], [0.55, {"x": tipR.x, "y": tipR.y}]])
	if t > 0.55: P["x"] = tipR.x; P["y"] = tipR.y
	var b = g(kf(t, [[0, {"v": 0}], [0.08, {"v": 1}], [0.5, {"v": 1}], [0.56, {"v": 0}]]), "v")
	var tip = V(P.x, P.y); var ctrl = V((root.x + tip.x) / 2, (root.y + tip.y) / 2 - 0.06 * H)
	var suck = fmod((t - TC) * 6, 1.0) if t > TC + 0.01 and t < 0.44 else -1.0
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	ribbon(ctx, S, "tongue", SRC, 0.04, line(S, m, SRC, root, ctrl, tip, b), func(i, n): return 1 + (0.9 * exp(-pow(float(i) / n - (1 - suck), 2) / 0.006) if suck >= 0 else 0.0))
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.28 * th, 1 - p / 0.13, "#ffc8c8", 631, 9)
	pop(ctx, S, T.x, T.y - 0.35 * th, "啾啾～", 0.2 * th, "#ff9aa8", TC + 0.02, 0.3)
	end(ctx); return true

# Tikbalang：轉身馬後踢
static func tikbalang(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.25 * th - 0.4 * H)
	var turn = cos(seg(t, 0.06, 0.12) * PI) if t < 0.13 else (-cos(seg(t, 0.49, 0.55) * PI) if t > 0.44 else -1.0)
	var f = kf(t, [[0, {}], [0.13, {"x": D2 * 0.5}], [0.2, {"x": D2 * 0.8, "r": -6, "legF": -0.2, "legB": -0.2, "head": 0.1}], [TC, {"x": D2, "r": -22, "legF": 0.9, "legB": 0.75, "head": 0.25, "body": 0.15, "cape": 0.4}, "i"], [0.36, {"x": D2, "r": -20, "legF": 0.85, "legB": 0.7, "head": 0.2, "body": 0.12}], [0.44, {"x": D2 * 0.6}], [0.59, {}]])
	f["sx"] = 0.15 * sgn1(turn) if absf(turn) < 0.15 else turn; f["px"] = 0.0; f["py"] = -0.5 * H
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var cg = at(S, bm(S, {}), 0.06, 0.29)
	puff(ctx, cg.x, cg.y - 0.05 * H, 0.06 * H, seg(t, 0.0, 0.2), "rgba(200,200,210,.55)", 641, 4)
	var T = tgt(S, 0.45); var p = t - TC
	if t > 0.2 and t < 0.3: speed(ctx, T.x, T.y, 1, -0.2, 0.3 * H, 0.2 * H, seg(t, 0.2, 0.24), "rgba(255,240,220,.7)", 643, 4)
	if p >= 0 and p < 0.14: burst(ctx, T.x, T.y, 0.36 * th, 1 - p / 0.14, "#ffe0b0", 645, 11)
	if p >= 0 and p < 0.3: stars(ctx, T.x, T.y - 0.45 * th, 0.15 * th, t, 1 - p / 0.3)
	pop(ctx, S, T.x, T.y - 0.55 * th, "踢！", 0.26 * th, "#ffd090", TC, 0.28)
	end(ctx); return true
