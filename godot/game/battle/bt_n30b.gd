# 新鬼專屬招式（原生）第二批：討債鬼、膽小鬼、冒失鬼、Hantu Raya、Polong、Pelesit、Jenglot、Hantu Galah、Jerangkung、Genderuwo、Orang Bunian、Mae Nak、Phi Am、Churel
class_name BtN30b
extends BtN30

static func table() -> Dictionary:
	return {"n30_taozhai": taozhai, "n30_danxiao": danxiao, "n30_maoshi": maoshi, "n30_hanturaya": hanturaya, "n30_polong": polong, "n30_pelesit": pelesit, "n30_jenglot": jenglot,
		"n30_hantugalah": hantugalah, "n30_jerangkung": jerangkung, "n30_genderuwo": genderuwo, "n30_bunian": bunian, "n30_maenak": maenak, "n30_phiam": phiam, "n30_churel": churel}

static func V(x: float, y: float) -> Vector2: return Vector2(x, y)

# 討債鬼：紅油潑門＋「還錢！」
static func taozhai(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.80, 0.58]
	var f = kf(t, [[0, {}], [0.16, {"r": -6, "x": -0.03 * H, "armF": 0.3, "paper": 0.4, "head": -0.1}], [0.24, {"r": 8, "x": 0.05 * H, "armF": -0.3, "paper": -0.5, "head": 0.12}, "o"], [0.40, {"r": 5, "x": 0.04 * H, "paper": 0.3}], [0.59, {}]])
	var m = bm(S, f); var w0 = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.6)
	var B = kf(t, [[0, {"x": w0.x, "y": w0.y, "r": 0}], [0.16, {"x": w0.x - 0.12 * H, "y": w0.y + 0.02 * H, "r": 55}], [0.24, {"x": w0.x + 0.14 * H, "y": w0.y - 0.12 * H, "r": -120}, "o"], [0.36, {"x": w0.x + 0.12 * H, "y": w0.y - 0.1 * H, "r": -110}], [0.59, {"x": w0.x, "y": w0.y, "r": 0}]])
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	piece_at(ctx, S, "bucket", B.x, B.y, B.r, PV[0], PV[1])
	var mouth = V(B.x + 0.15 * H, B.y - 0.15 * H); var q = seg(t, 0.2, TC)
	if t > 0.2 and t < TC + 0.02:
		for i in 9:
			var k = cl(q - i * 0.04); var x = lerp_(mouth.x, T.x, k); var y = lerp_(mouth.y, T.y + (rnd(i) - 0.5) * 0.4 * th, k) - 0.15 * H * sin(k * PI)
			ctx.fillStyle = Color("#c8141e"); ctx.strokeStyle = Color("#4a0a0a"); ctx.lineWidth = 0.006 * H; ctx.beginPath(); ctx.ellipse(x, y, (0.035 + rnd(i + 3) * 0.03) * H, 0.025 * H, 0.3, 0, 7); ctx.fill(); ctx.stroke()
	var p = t - TC
	if p >= 0:
		var al = 1 - seg(t, 0.5, 0.59); ctx.save(); ctx.globalAlpha *= al; var C = T
		for i in 7:
			var an = rnd(i + 11) * 6.28; var d = rnd(i + 13) * 0.22 * th; ctx.fillStyle = Color("#c8141e"); ctx.beginPath(); ctx.ellipse(C.x + cos(an) * d, C.y + sin(an) * d * 1.4, 0.07 * th * (0.6 + rnd(i)), 0.05 * th, an, 0, 7); ctx.fill()
		for i in 4:
			var x = C.x + (i - 1.5) * 0.08 * th; var l = cl(p * 4) * (0.15 + rnd(i + 20) * 0.2) * th; crayon(ctx, [V(x, C.y), V(x, C.y + l)], "#b0101a", 0.025 * th, 200 + i)
		ctx.restore()
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.12, "#ffb0a0", 201, 9)
	pop(ctx, S, T.x, T.y - 0.6 * th, "還錢！", 0.3 * th, "#ff3a3a", TC, 0.32)
	end(ctx); return true

# 膽小鬼：閉眼亂揮
static func danxiao(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.42 * th - 0.25 * H); var sh = sin(t * 60) * 0.006 * H
	var flail = t * 55 if t > 0.15 and t < 0.38 else 0.0
	var f = kf(t, [[0, {}], [0.14, {"sy": 0.88, "sx": 1.05, "head": -0.15, "r": -4}], [TC, {"x": D2, "sy": 1.02, "r": 10, "head": 0.1}, "i"], [0.34, {"x": D2, "r": 8}], [0.42, {"x": D2 * 0.3, "y": -0.08 * H, "r": -12, "sy": 0.9}, "o"], [0.59, {}]])
	f["x"] = g(f, "x") + sh
	if flail != 0: f["armF"] = sin(flail) * 1.3; f["armB"] = sin(flail + 3.1) * 1.3
	elif t < 0.15: f["armF"] = 0.0; f["armB"] = 0.0
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.2)
	var m = bm(S, f); var hd = at(S, m, 0.5, 0.2); var T = tgt(S, 0.6)
	if t > 0.1 and t < 0.45: drops(ctx, hd.x, hd.y, 0.3 * H, fmod(t * 4, 1.0), "rgba(150,210,255,.9)", floor(t * 4) * 5, 4)
	pop(ctx, S, hd.x, hd.y - 0.3 * H, "哇啊啊！", 0.13 * H, "#bfe0ff", 0.12, 0.3)
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#e0f0ff", 211, 9)
	pop(ctx, S, T.x, T.y - 0.4 * th, "咦？中咗？", 0.16 * th, "#ffffff", TC + 0.03, 0.3)
	end(ctx); return true

# 冒失鬼：絆倒、一頭撞過去
static func maoshi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = S.tx - 0.12 * th - 0.8 * H * sin(70 * D)
	var f = kf(t, [[0, {}], [0.12, {"x": 0.03 * H, "r": -10, "armF": 0.4, "armB": -0.6, "head": -0.15}], [0.18, {"x": 0.06 * H, "r": 25, "armF": -1.0, "armB": -0.9, "head": 0.1}], [TC, {"x": D2, "r": 70, "px": 0, "py": 0, "y": -0.02 * H, "armF": -1.2, "armB": -1.1, "legF": -0.3, "legB": 0.4, "head": 0.2}, "i"], [0.36, {"x": D2 + 0.02 * H, "r": 74, "px": 0, "py": 0, "armF": -1.1, "armB": -1.0, "head": 0.2}], [0.46, {"x": D2 * 0.4, "y": -0.15 * H, "r": 20, "sy": 1.05}, "o"], [0.59, {}]])
	f["px"] = 0.0; f["py"] = 0.0
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.2)
	var T = tgt(S, 0.5); var p = t - TC
	pop(ctx, S, 0.15 * H, -0.95 * H, "哎！", 0.12 * H, "#ffe066", 0.1, 0.18)
	if t > 0.18 and t < TC:
		for i in 3: puff(ctx, g(f, "x") + 0.2 * H - i * 0.12 * H, -0.03 * H, 0.05 * H, seg(t, 0.18 + i * 0.02, 0.4), "rgba(200,190,170,.55)", 220 + i, 3)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.32 * th, 1 - p / 0.13, "#fff4c0", 221, 10)
	if t > TC and t < 0.5: stars(ctx, T.x - 0.1 * th, -0.35 * H, 0.15 * H, t, 1 - seg(t, 0.44, 0.5))
	pop(ctx, S, T.x, T.y - 0.45 * th, "咚！", 0.24 * th, "#ffe066", TC, 0.3)
	end(ctx); return true

# Hantu Raya：黑影變大、壓落嚟
static func hanturaya(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.4 * th - 0.3 * H)
	var f = kf(t, [[0, {}], [0.18, {"sy": 1.22, "sx": 1.1, "armF": -1.0, "armB": -0.7, "head": -0.15, "hairL": 0.3, "hairR": 0.3, "r": -4}], [TC, {"sy": 1.05, "sx": 1.12, "x": D2, "r": 22, "armF": -0.3, "armB": -0.2, "head": 0.2, "hairL": -0.4, "hairR": -0.4}, "i"], [0.36, {"sy": 1.0, "sx": 1.1, "x": D2, "r": 20, "armF": -0.25, "armB": -0.15}], [0.59, {}]])
	var aura = g(kf(t, [[0, {"v": 0}], [0.18, {"v": 1}], [0.40, {"v": 0.8}], [0.59, {"v": 0}]]), "v")
	begin(ctx, S, g(f, "x"), 1 + aura * 0.6)
	if aura > 0:
		var fx = g(f, "x"); var gr = ctx.createRadialGradient(fx, -0.5 * H, 0, fx, -0.5 * H, 0.75 * H)
		gr.addColorStop(0, Color(40 / 255.0, 20 / 255.0, 60 / 255.0, 0.45 * aura)); gr.addColorStop(1, Color(40 / 255.0, 20 / 255.0, 60 / 255.0, 0))
		ctx.fillStyle = gr; ctx.fillRect(fx - 0.8 * H, -1.3 * H, 1.6 * H, 1.4 * H)
	whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.5); var p = t - TC
	if p >= 0 and p < 0.3:
		var k = p / 0.3
		ring(ctx, T.x, S.ty, (0.2 + k * 0.8) * th, (0.06 + k * 0.2) * th, "rgba(120,70,170,.9)", 0.05 * th * (1 - k), 1 - k)
		ring(ctx, T.x, S.ty, (0.1 + k * 0.5) * th, (0.03 + k * 0.12) * th, "rgba(30,10,40,.9)", 0.04 * th * (1 - k), 1 - k)
	for i in 5: puff(ctx, T.x + (i - 2) * 0.15 * th, S.ty - 0.1 * th, 0.08 * th, seg(t, TC + i * 0.01, 0.5), "rgba(60,30,80,.5)", 230 + i, 3)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y - 0.2 * th, 0.4 * th, 1 - p / 0.13, "#c9a0ff", 231, 12)
	end(ctx); return true

# Polong：由樽仔竄出去咬
static func polong(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.47, 0.565]
	var f = kf(t, [[0, {}], [0.06, {"r": -6}], [0.12, {"r": 6}], [0.18, {"r": -3}], [0.24, {"r": 2}], [0.50, {"r": 0}], [0.54, {"y": -0.06 * H, "sy": 1.05}], [0.59, {}]])
	var m = bm(S, f); var mouth = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.8)
	var ho = V((1.0 if S.nr else -1.0) * (0.33 - PV[0]) * S.W, (0.2 - PV[1]) * S.H)
	var goal = V(T.x - ho.x - 0.03 * th, T.y - ho.y)
	var P = kf(t, [[0, {"x": mouth.x, "y": mouth.y, "r": 0, "s": 1}], [0.16, {"x": mouth.x, "y": mouth.y + 0.04 * H, "r": -8, "s": 0.82}], [TC, {"x": goal.x, "y": goal.y, "r": 25, "s": 1.0}, "i"], [0.36, {"x": goal.x + 0.01 * H, "y": goal.y + 0.02 * H, "r": 30, "s": 1.0}], [0.52, {"x": mouth.x, "y": mouth.y + 0.02 * H, "r": 0, "s": 0.8}, "i"], [0.59, {"x": mouth.x, "y": mouth.y, "r": 0, "s": 1}]])
	begin(ctx, S, g(f, "x"))
	if t > 0.18 and t < 0.52:
		var pts = quad(mouth, V((mouth.x + P.x) / 2, minf(mouth.y, P.y) - 0.25 * H), V(P.x, P.y + 0.02 * H), 10)
		crayon(ctx, pts, "#8a1a24", 0.04 * H, 241)
		var p2 = []
		for q in pts: p2.append(q + V(0, -0.012 * H))
		crayon(ctx, p2, "#d04050", 0.015 * H, 242)
	body(ctx, S, m, pose(S, f, 0.3), key)
	piece_at(ctx, S, "spirit", P.x, P.y, P.r, PV[0], PV[1], P.s, 2 - P.s * 0.9 - 0.1)
	if t > 0.18 and t < TC: speed(ctx, P.x, P.y - 0.25 * H, P.x - mouth.x, P.y - mouth.y, 0.3 * H, 0.15 * H, seg(t, 0.18, 0.22), "rgba(255,200,210,.7)", 243, 4)
	var p = t - TC
	if p >= 0 and p < 0.25:
		for sg in [-1, 1]:
			var gg = 0.05 * th * (1 - minf(1, p * 8)); var pts = []
			for j in 6: pts.append(V(T.x - 0.1 * th + j * 0.04 * th, T.y + sg * (gg + (0.02 * th if j % 2 else 0.0))))
			crayon(ctx, pts, "#fffaf0", 0.02 * th, 245 + sg)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#ffc0c8", 247, 9)
	pop(ctx, S, mouth.x, mouth.y - 0.15 * H, "啵！", 0.12 * H, "#ffd0d8", 0.52, 0.07)
	end(ctx); return true

# Pelesit：跳起身咬
static func pelesit(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.25 * th - 0.4 * S.W)
	var f = kf(t, [[0, {}], [0.14, {"sy": 0.82, "sx": 1.08, "legB": 0.35, "legF": 0.2, "hairL": 0.3, "hairR": 0.3, "r": 4}], [0.20, {"x": D2 * 0.55, "y": -0.75 * H, "sy": 1.1, "r": -25, "legB": -0.4, "legF": -0.3}, "o"], [TC, {"x": D2, "y": -0.45 * th, "r": -30, "legB": -0.3, "legF": -0.4, "head": 0.2}], [0.34, {"x": D2, "y": -0.4 * th, "r": -25, "head": -0.1}], [0.42, {"x": D2 * 0.6, "y": -0.3 * H, "r": -5}, "o"], [0.48, {"x": D2 * 0.35, "y": 0, "sy": 0.9}, "i"], [0.54, {"x": D2 * 0.12, "y": -0.2 * H}, "o"], [0.59, {}, "i"]])
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / H) * 0.6); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.72); var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#f0e0b0", 251, 9)
	pop(ctx, S, T.x, T.y - 0.35 * th, "喀！", 0.22 * th, "#f0e0b0", TC, 0.25)
	pop(ctx, S, 0, -1.1 * H, "唧唧", 0.2 * H, "#d8e8a0", 0.46, 0.13)
	end(ctx); return true

# Jenglot：轉身甩髮
static func jenglot(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.5 * th - 0.35 * H)
	var spin = seg(t, 0.17, 0.255); var sx = cos(spin * PI * 2)
	var f = kf(t, [[0, {}], [0.15, {"sy": 0.9, "r": -8, "hairL": 0.45, "hairR": 0.45, "head": -0.15}], [TC, {"x": D2, "r": 8, "hairL": -0.7, "hairR": -0.7, "head": 0.15}, "i"], [0.36, {"x": D2, "r": 6, "hairL": -0.5, "hairR": -0.5}], [0.50, {"hairL": 0.2, "hairR": 0.2}], [0.59, {}]])
	var sgn = signf(sx) if sx != 0 else 1.0
	f["sx"] = g(f, "sx", 1.0) * (0.15 * sgn if absf(sx) < 0.15 else sx)
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.6); var hd = V(g(f, "x"), -0.75 * H)
	if t > 0.2 and t < 0.36:
		for i in 4:
			var k = seg(t, 0.2, TC); var pts = []
			for j in 9:
				var q = j / 8.0; pts.append(V(lerp_(hd.x, T.x + 0.05 * th, q * k), hd.y + (i - 1.5) * 0.05 * H + sin(q * 6 + t * 30 + i) * 0.04 * H * q + q * (T.y - hd.y)))
			crayon(ctx, pts, "rgba(25,18,15,.85)", 0.018 * H, 261 + i)
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#e8d8c8", 265, 9)
	pop(ctx, S, T.x, T.y - 0.4 * th, "嘶！", 0.22 * th, "#d8c8b8", TC, 0.3)
	end(ctx); return true

# Hantu Galah：一步跨過去、彎腰彈額頭
static func hantugalah(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.35 * th - 0.35 * H)
	var f = kf(t, [[0, {}], [0.16, {"r": -6, "legB": -0.22, "legF": 0.08, "head": -0.1, "armB": 0.3}], [TC, {"x": D2, "r": 22, "py": -0.5 * H, "body": 0.35, "head": 0.35, "legB": -0.08, "legF": 0.12, "armB": -0.6, "armF": 0.3}, "i"], [0.36, {"x": D2, "r": 20, "py": -0.5 * H, "body": 0.33, "head": 0.32, "armB": -0.4}], [0.48, {"x": D2 * 0.5, "legF": -0.12, "legB": 0.1, "r": 5, "py": -0.5 * H}], [0.59, {}]])
	f["px"] = 0.0; f["py"] = -0.5 * H
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.88); var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.25 * th, 1 - p / 0.13, "#fff", 271, 8)
	if p >= 0 and p < 0.3: stars(ctx, T.x, T.y - 0.1 * th, 0.15 * th, t, 1 - p / 0.3)
	pop(ctx, S, T.x, T.y - 0.3 * th, "彈！", 0.22 * th, "#ffffff", TC, 0.28)
	end(ctx); return true

# Jerangkung：拆落前臂當迴旋鏢
static func jerangkung(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.63, 0.47]; var AC = [0.80, 0.44]
	var f = kf(t, [[0, {}], [0.15, {"r": -7, "head": -0.15, "body": -0.05}], [0.20, {"r": 9, "head": 0.15, "body": 0.1, "x": 0.03 * H}, "o"], [0.45, {"r": 2}], [0.55, {"r": -4, "head": -0.1}], [0.59, {}]])
	var m = bm(S, f); var el = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.82)
	var off = V((1.0 if S.nr else -1.0) * (AC[0] - PV[0]) * S.W, (AC[1] - PV[1]) * S.H)
	var x: float; var y: float; var r: float
	if t < 0.16:
		var k = BtMoves.eio(seg(t, 0.02, 0.16)); r = -130 * k; x = el.x; y = el.y
	elif t < TC:
		var q = seg(t, 0.16, TC); x = lerp_(el.x, T.x - off.x, q); y = lerp_(el.y, T.y - off.y, q) - 0.15 * H * sin(q * PI); r = -130 + q * 900
	elif t < 0.55:
		var q = seg(t, TC, 0.55); var bx = T.x - off.x; var by = T.y - off.y; x = lerp_(bx, el.x, q) + sin(q * PI) * 0.1 * H; y = lerp_(by, el.y, q) - sin(q * PI) * 0.4 * H; r = 770 + q * 1060
	else:
		x = el.x; y = el.y; r = 0
	if t >= 0.55: r = 0
	elif t > 0.5: r = fmod(r, 360.0) * (1 - seg(t, 0.5, 0.55))
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	if t > 0.16 and t < 0.55: speed(ctx, x, y, 1, 0, 0.12 * H, 0.08 * H, 0.6, "rgba(255,250,230,.5)", 281, 3)
	if t < 0.16 or t >= 0.55: piece_at(ctx, S, "arm", x, y, r, PV[0], PV[1])
	else: piece_at(ctx, S, "arm", x + off.x, y + off.y, r, AC[0], AC[1])
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#fffbe8", 285, 9)
	pop(ctx, S, T.x, T.y - 0.3 * th, "喀啦！", 0.2 * th, "#f6efd8", TC, 0.28)
	pop(ctx, S, el.x, el.y - 0.12 * H, "喀", 0.1 * H, "#f6efd8", 0.55, 0.04)
	end(ctx); return true

# Genderuwo：跳起身雙拳搥地
static func genderuwo(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.7 * th - 0.3 * H)
	var f = kf(t, [[0, {}], [0.06, {"sy": 0.88, "sx": 1.06}], [0.17, {"y": -0.25 * H, "x": D2 * 0.6, "sy": 1.06, "armF": -0.6, "armB": -0.5, "head": -0.15}, "o"], [TC, {"y": 0, "x": D2, "sy": 0.84, "sx": 1.1, "armF": -0.25, "armB": -0.2, "r": 12, "head": 0.2}, "i"], [0.36, {"x": D2, "sy": 0.9, "sx": 1.06, "r": 10, "armF": -0.2, "armB": -0.15}], [0.50, {"x": D2 * 0.3, "armF": -0.5, "armB": 0.4}], [0.59, {}]])
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / H)); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.4); var p = t - TC; var fx = g(f, "x") + 0.35 * H
	if p >= 0:
		var k = seg(t, TC, TC + 0.06); var al = 1 - seg(t, 0.5, 0.59); var pts = []
		for j in 9:
			var q = j / 8.0 * k; pts.append(V(lerp_(fx, S.tx + S.back, q), S.ty * q + sin(j * 2.3) * 0.02 * H))
		ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, "rgba(40,28,22,.9)", 0.02 * H, 291); ctx.restore(); cracks(ctx, S.tx + S.back, S.ty, 0.4 * th, al * k, 292)
	if p >= 0 and p < 0.35:
		for i in 9:
			var an = -PI * (0.15 + 0.7 * rnd(i)); var sp = (0.4 + rnd(i + 4)) * 1.4 * th
			var px = fx + cos(an) * sp * p * (1.0 if i % 2 else 0.4) + ((S.tx - fx) * cl(p * 6) if i % 2 else 0.0); var py = sin(an) * sp * p + 3 * th * p * p
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = Color("#7a6a5a"); ctx.strokeStyle = Color("#3a2a1a"); ctx.lineWidth = 0.01 * th
			ctx.beginPath(); ctx.moveTo(px, py - 0.03 * th); ctx.lineTo(px + 0.03 * th, py); ctx.lineTo(px, py + 0.025 * th); ctx.lineTo(px - 0.03 * th, py + 0.005 * th); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore()
	for i in 4: puff(ctx, fx + (i - 1.5) * 0.18 * H, -0.03 * H, 0.08 * H, seg(t, TC + i * 0.01, 0.5), "rgba(190,170,150,.6)", 295 + i, 3)
	pop(ctx, S, T.x, T.y - 0.55 * th, "轟！", 0.3 * th, "#ffcf80", TC, 0.32)
	end(ctx); return true

# Orang Bunian：隱身、閃到背後
static func _spark(ctx: Ctx, x: float, y: float, k: float, seed: float, H: float) -> void:
	if k <= 0 or k >= 1: return
	for i in 10:
		var an = rnd(seed + i) * 6.28; var d = (0.1 + k * 0.4) * H * rnd(seed + i + 3)
		ctx.save(); ctx.globalAlpha *= sin(k * PI); ctx.fillStyle = Color("#ffe28a") if i % 2 else Color("#fff6c8"); ctx.beginPath(); ctx.arc(x + cos(an) * d, y + sin(an) * d - k * 0.2 * H, 0.012 * H, 0, 7); ctx.fill(); ctx.restore()
static func bunian(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var BX = S.tx + 0.45 * th + 0.15 * H
	var behind = t >= 0.2 and t < 0.43
	var f: Dictionary
	if behind: f = kf(t, [[0.2, {"x": BX, "sx": -1, "a": 0, "r": 0}], [0.24, {"x": BX, "sx": -1, "a": 1, "r": -4}], [TC, {"x": BX - 0.08 * H, "sx": -1, "a": 1, "r": 10, "armB": -0.9, "armF": 0.3}, "i"], [0.36, {"x": BX - 0.08 * H, "sx": -1, "a": 1, "r": 8, "armB": -0.7}], [0.43, {"x": BX, "sx": -1, "a": 0}]])
	elif t < 0.2: f = kf(t, [[0, {}], [0.05, {"r": -3, "sy": 1.03}], [0.18, {"a": 0, "sy": 1.08, "sx": 0.9, "y": -0.05 * H}]])
	else: f = kf(t, [[0.43, {"a": 0, "sy": 1.08, "sx": 0.9}], [0.59, {}]])
	begin(ctx, S, g(f, "x"), 0.3 + 0.7 * g(f, "a") if f.has("a") else 1.0); whole(ctx, S, f, "", 0.4)
	_spark(ctx, 0, -0.5 * H, seg(t, 0.06, 0.26), 301, H); _spark(ctx, BX, -0.5 * H, seg(t, 0.18, 0.3), 311, H); _spark(ctx, BX, -0.5 * H, seg(t, 0.38, 0.5), 321, H); _spark(ctx, 0, -0.5 * H, seg(t, 0.44, 0.59), 331, H)
	var T = V(S.tx + S.back + 0.12 * th, S.ty - 0.75 * th); var p = t - TC
	if p >= 0 and p < 0.15: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.15, "#ffe28a", 341, 10)
	pop(ctx, S, T.x, T.y - 0.3 * th, "噗～", 0.2 * th, "#ffe28a", TC, 0.28)
	end(ctx); return true

# Mae Nak：手臂伸長捉人
static func maenak(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var WP = [0.205, 0.45]
	var f = kf(t, [[0, {}], [0.16, {"r": -4, "head": -0.1}], [TC, {"r": 5, "head": 0.1, "x": 0.02 * H}, "i"], [0.36, {"r": -2, "head": -0.05}], [0.59, {}]])
	var m = bm(S, f); var SRC = [[0.56, 0.405], [0.45, 0.40], [0.33, 0.40], [0.24, 0.41], [0.19, 0.43]]
	var sh = at(S, m, 0.56, 0.405); var w0 = at(S, m, 0.19, 0.43); var T = tgt(S, 0.82)
	var handLen = 0.15 * S.W; var goal = V(T.x - handLen, T.y + 0.02 * th)
	var W = kf(t, [[0, {"x": w0.x, "y": w0.y}], [0.16, {"x": w0.x - 0.08 * H, "y": w0.y - 0.03 * H}], [TC, {"x": goal.x, "y": goal.y}, "i"], [0.31, {"x": goal.x - 0.02 * H, "y": goal.y + 0.01 * H}], [0.36, {"x": goal.x - 0.08 * H, "y": goal.y}], [0.59, {"x": w0.x, "y": w0.y}, "io"]])
	var b = g(kf(t, [[0, {"v": 0}], [0.05, {"v": 1}], [0.55, {"v": 1}], [0.59, {"v": 0}]]), "v")
	var wr = V(W.x, W.y); var mid = V((sh.x + wr.x) / 2, (sh.y + wr.y) / 2 + 0.03 * H * (1 - seg(t, 0.16, TC)))
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.25), key)
	var ln = line(S, m, SRC, sh, mid, wr, b)
	if t > 0.17 and t < TC: speed(ctx, wr.x, wr.y, 1, 0, 0.3 * H, 0.08 * H, 0.8, "rgba(240,230,255,.6)", 351, 3)
	var stretch = cl(wr.distance_to(w0) / H)
	ribbon(ctx, S, "arm", SRC, 0.034, ln, func(i, n): return 1 - 0.15 * b * stretch * sin(float(i) / n * PI))
	var e = ln[-1]; var prev = ln[-3]; var r24 = at(S, m, 0.24, 0.41); var restA = atan2(w0.y - r24.y, w0.x - r24.x); var curA = atan2(e.y - prev.y, e.x - prev.x)
	var grip = -12.0 if t > TC and t < 0.4 else 0.0
	piece_at(ctx, S, "hand", e.x, e.y, (curA - restA) / D + grip, WP[0], WP[1])
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#efe0ff", 355, 9)
	pop(ctx, S, T.x, T.y - 0.35 * th, "捉到你～", 0.18 * th, "#e8d0ff", TC, 0.32)
	end(ctx); return true

# Phi Am：鬼壓床，一屁股坐扁
static func phiam(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = S.tx + S.back * 0.5 - 0.05 * th; var SY = S.ty - 0.55 * th
	var f = kf(t, [[0, {}], [0.15, {"sy": 0.78, "sx": 1.12, "armF": 0.3, "armB": -0.3}], [0.21, {"x": D2 * 0.5, "y": -0.7 * H, "sy": 1.12, "sx": 0.92, "armF": -0.6, "armB": 0.6, "r": -10}, "o"], [TC, {"x": D2, "y": SY, "sy": 0.8, "sx": 1.15, "armF": -0.3, "armB": 0.3}, "i"], [0.36, {"x": D2, "y": SY, "sy": 0.9, "sx": 1.08, "r": 4}], [0.40, {"x": D2, "y": SY, "sy": 0.88, "sx": 1.1, "r": -4}], [0.48, {"x": D2 * 0.5, "y": -0.45 * H, "sy": 1.05}, "o"], [0.59, {}, "i"]])
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / H) * 0.5); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.55); var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, SY, 0.45 * th, 1 - p / 0.13, "#ffd8f0", 361, 12)
	for i in 3:
		var q = seg(t, TC + i * 0.04, 0.55)
		if q > 0 and q < 1: txt(ctx, S, D2 + 0.2 * H + q * 0.15 * H, SY - 0.9 * H - q * 0.3 * H - i * 0.05 * H, "Z", (0.12 + i * 0.04) * H, "#c8d8ff", sin(q * PI))
	pop(ctx, S, T.x, SY - 1.05 * H, "坐低！", 0.14 * H, "#ffd8f0", TC, 0.3)
	end(ctx); return true

# Churel：轉身倒住跑撞過去
static func churel(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.3 * th - 0.25 * H)
	var turn = cos(seg(t, 0.05, 0.11) * PI) if t < 0.12 else (-cos(seg(t, 0.50, 0.56) * PI) if t > 0.45 else -1.0)
	var f = kf(t, [[0, {}], [0.12, {"r": 3}], [TC, {"x": D2, "r": -10}, "i"], [0.34, {"x": D2, "r": -14}], [0.45, {"x": D2 * 0.6}], [0.59, {}]])
	f["sx"] = 0.15 * (signf(turn) if turn != 0 else 1.0) if absf(turn) < 0.15 else turn
	if t > 0.12 and t < TC:
		f["legF"] = sin(t * 60) * 0.45; f["legB"] = -sin(t * 60) * 0.45; f["armF"] = sin(t * 60) * 0.3; f["armB"] = -sin(t * 60) * 0.3; f["y"] = -absf(sin(t * 60)) * 0.03 * H; f["hairL"] = 0.3; f["hairR"] = 0.3
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	if t > 0.12 and t < TC:
		for i in 3: puff(ctx, g(f, "x") - (i + 1) * 0.1 * H, -0.02 * H, 0.05 * H, cl((t - 0.12) * 7 - i * 0.2), "rgba(200,180,160,.5)", 370 + i, 3)
	var T = tgt(S, 0.5); var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.32 * th, 1 - p / 0.13, "#ffd8c8", 375, 10)
	pop(ctx, S, T.x, T.y - 0.45 * th, "咚！", 0.24 * th, "#ffc0a8", TC, 0.28)
	pop(ctx, S, 0.1 * H, -1.05 * H, "倒住跑！", 0.11 * H, "#ffd8c8", 0.08, 0.2)
	end(ctx); return true
