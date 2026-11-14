# 新鬼專屬招式（原生）第一批：吊死鬼、無頭鬼、夜叉、旱魃、倀鬼、鬼新娘、山魈、白骨精、窮鬼、賭鬼、酒鬼、煙鬼、孤寒鬼
# 逐句照 n30_moves.js（數值、時序一樣）
class_name BtN30a
extends BtN30

static func table() -> Dictionary:
	return {"n30_diaosi": diaosi, "n30_wutou": wutou, "n30_yecha": yecha, "n30_hanba": hanba, "n30_changgui": changgui, "n30_guixinniang": guixinniang,
		"n30_shanxiao": shanxiao, "n30_baigujing": baigujing, "n30_qionggui": qionggui, "n30_dugui": dugui, "n30_jiugui": jiugui, "n30_yangui": yangui, "n30_guhangui": guhangui}

static func V(x: float, y: float) -> Vector2: return Vector2(x, y)

# 吊死鬼：長舌鞭
static func diaosi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.16, {"r": -9, "head": -0.22, "body": -0.08, "armF": 0.35, "armB": -0.35, "rope": 0.35, "hairL": 0.2, "hairR": 0.2}], [0.25, {"r": 9, "head": 0.18, "body": 0.1, "x": 0.05 * H, "rope": -0.45, "hairL": -0.25, "hairR": -0.25}, "o"], [0.36, {"r": 6, "head": 0.12, "body": 0.08, "x": 0.05 * H, "rope": -0.2}], [0.59, {}]])
	var m = bm(S, f); begin(ctx, S, g(f, "x"))
	body(ctx, S, m, pose(S, f, 0.3), key)
	var SRC = [[0.415, 0.36], [0.418, 0.45], [0.415, 0.52], [0.42, 0.59]]; var root = at(S, m, 0.415, 0.36); var hd = tgt(S, 0.78)
	var e0 = at(S, m, 0.42, 0.59)
	var T = kf(t, [[0, {"x": e0.x, "y": e0.y}], [0.17, {"x": root.x - 0.30 * H, "y": root.y - 0.42 * H}], [TC, {"x": hd.x, "y": hd.y}, "i"], [0.30, {"x": hd.x - 0.04 * H, "y": hd.y + 0.06 * H}], [0.36, {"x": hd.x + 0.02 * H, "y": hd.y + 0.02 * H}], [0.52, {"x": root.x + 0.12 * H, "y": root.y + 0.25 * H}], [0.59, {"x": e0.x, "y": e0.y}]])
	var b = g(kf(t, [[0, {"v": 0}], [0.06, {"v": 1}], [0.53, {"v": 1}], [0.59, {"v": 0}]]), "v")
	var bend = g(kf(t, [[0, {"v": 0}], [0.17, {"v": -0.55}], [TC, {"v": -0.25}], [0.36, {"v": 0.1}], [0.59, {"v": 0}]]), "v")
	var tip = V(T.x, T.y); var mid = (root + tip) / 2; var L = tip.distance_to(root)
	var wob = sin(t * 90) * 0.06 * H if t > TC and t < 0.36 else 0.0
	var ctrl = V(mid.x + bend * L * 0.2, mid.y + bend * L * 0.9 + wob)
	if t > 0.12 and t < TC: speed(ctx, tip.x, tip.y, tip.x - root.x, tip.y - root.y + 0.3 * H, 0.18 * H, 0.1 * H, seg(t, 0.12, 0.2), "rgba(255,220,220,.7)", 3, 3)
	ribbon(ctx, S, "tongue", SRC, 0.05, line(S, m, SRC, root, ctrl, tip, b), func(i, n): return 1 - 0.18 * b * i / n)
	var p = t - TC
	if p >= 0 and p < 0.14: burst(ctx, hd.x, hd.y, 0.35 * th, 1 - p / 0.14, "#ffe4e4", 11, 10)
	drops(ctx, hd.x, hd.y, 0.5 * th, seg(t, TC, 0.5), "rgba(200,235,255,.9)", 3, 8)
	pop(ctx, S, hd.x, hd.y - 0.32 * th, "啪！", 0.26 * th, "#ffd0d0", TC, 0.3)
	end(ctx); return true

# 無頭鬼：自己個頭當保齡球
static func wutou(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.15, {"r": -6, "body": -0.12, "armB": 0.55, "armF": -0.25, "x": -0.03 * H}], [0.21, {"r": 12, "body": 0.18, "armB": -0.65, "armF": 0.2, "x": 0.05 * H, "sy": 0.97}, "o"], [0.34, {"r": 10, "body": 0.15, "armB": -0.6, "x": 0.05 * H}], [0.50, {"r": 2, "body": 0.03, "armB": -0.2}], [0.59, {}]])
	var m = bm(S, f); begin(ctx, S, g(f, "x"))
	var HC = [0.775, 0.50]; var R = 0.165 * H; var rest = at(S, m, HC[0], HC[1])
	var gy = -R + S.fl; var hitX = S.tx - 0.12 * th + S.back
	var P = kf(t, [[0, {"x": rest.x, "y": rest.y, "r": 0}], [0.15, {"x": rest.x - 0.12 * H, "y": rest.y + 0.10 * H, "r": -35}], [0.20, {"x": rest.x + 0.12 * H, "y": gy, "r": 30}, "i"], [TC, {"x": hitX, "y": gy, "r": 30 + (hitX - rest.x) / R / D}, "lin"], [0.33, {"x": hitX - 0.14 * H, "y": gy - 0.12 * H, "r": -60}, "o"], [0.36, {"x": hitX - 0.2 * H, "y": gy, "r": -90}], [0.50, {"x": 0.12 * H, "y": gy, "r": -90 - (hitX - 0.32 * H) / R / D}, "lin"], [0.59, {"x": rest.x, "y": rest.y, "r": 0}, "back"]])
	var inHand = t < 0.15 or t > 0.585
	body(ctx, S, m, pose(S, f, 0.3), key)
	if t > 0.19 and t < TC + 0.02:
		for i in 4: puff(ctx, P.x - (i + 1) * 0.09 * H, -0.02 * H, 0.06 * H, cl((t - 0.19) * 6 - i * 0.12), "rgba(200,190,170,.5)", i * 7, 3)
		speed(ctx, P.x - R, P.y, 1, 0, 0.25 * H, 0.18 * H, 1, "rgba(240,240,255,.7)", 5, 3)
	piece_at(ctx, S, "head", P.x, P.y, 0.0 if inHand else P.r, HC[0], HC[1])
	var p = t - TC
	if p >= 0 and p < 0.15: burst(ctx, hitX + 0.05 * th, gy, 0.4 * th, 1 - p / 0.15, "#fff2c0", 21, 11)
	pop(ctx, S, hitX, S.ty - 0.95 * th, "全倒！", 0.24 * th, "#ffe066", TC, 0.32)
	if t > TC and t < 0.5: stars(ctx, P.x, P.y - R * 1.1, R * 0.9, t, 1 - seg(t, 0.42, 0.5))
	end(ctx); return true

# 夜叉：鋼叉突刺
static func yecha(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.31, 0.50]
	var f = kf(t, [[0, {}], [0.17, {"r": -5, "x": -0.06 * H, "sy": 0.96, "sx": 1.03, "body": -0.06, "armF": 0.3, "legF": -0.15, "legB": 0.1, "hairL": 0.15, "hairR": 0.15}], [TC, {"r": 8, "x": 0.10 * H, "sy": 1.02, "body": 0.12, "armF": -0.5, "legF": 0.3, "legB": -0.2, "hairL": -0.3, "hairR": -0.35}, "i"], [0.36, {"r": 7, "x": 0.10 * H, "body": 0.1, "armF": -0.45, "legF": 0.28, "legB": -0.18, "hairL": -0.25, "hairR": -0.3}], [0.59, {}]])
	var m = bm(S, f); var w0 = at(S, m, PV[0], PV[1]); var tip = tgt(S, 0.55)
	var reach = 0.47 * S.H
	var W = kf(t, [[0, {"x": w0.x, "y": w0.y, "r": 0}], [0.17, {"x": w0.x - 0.14 * H, "y": w0.y - 0.02 * H, "r": 84}], [TC, {"x": tip.x - reach + 0.05 * th, "y": tip.y, "r": 90}, "i"], [0.33, {"x": tip.x - reach + 0.05 * th, "y": tip.y, "r": 90 + sin(t * 80) * 5}], [0.40, {"x": w0.x + 0.02 * H, "y": w0.y, "r": 70}], [0.59, {"x": w0.x, "y": w0.y, "r": 0}]])
	begin(ctx, S, g(f, "x"))
	body(ctx, S, m, pose(S, f, 0.3), key)
	if t > 0.2 and t < 0.3: speed(ctx, W.x + reach * 0.7, W.y, 1, 0, 0.5 * H, 0.12 * H, seg(t, 0.2, 0.24) * (1 - seg(t, 0.28, 0.3)), "rgba(255,240,200,.75)", 9, 5)
	piece_at(ctx, S, "trident", W.x, W.y, W.r, PV[0], PV[1])
	var p = t - TC
	if p >= 0 and p < 0.14: burst(ctx, tip.x, tip.y, 0.36 * th, 1 - p / 0.14, "#fff6c8", 31, 12)
	if p > 0 and p < 0.3:
		for i in range(-1, 2): crayon(ctx, [V(tip.x - 0.02 * th, tip.y + i * 0.07 * th), V(tip.x + 0.04 * th, tip.y + i * 0.07 * th)], "rgba(150,30,30,.8)", 0.02 * th, 40 + i)
	pop(ctx, S, tip.x, tip.y - 0.5 * th, "叉！", 0.24 * th, "#ffd27a", TC, 0.3)
	end(ctx); return true

# 旱魃：熱浪
static func hanba(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.18, {"r": -6, "y": -0.04 * H, "sy": 1.05, "armF": -0.9, "armB": 0.9, "head": -0.18, "hairL": 0.3, "hairR": 0.3}], [0.25, {"r": 7, "x": 0.04 * H, "armF": -0.7, "armB": -0.5, "head": 0.12, "hairL": -0.3, "hairR": -0.3}, "o"], [0.40, {"r": 6, "x": 0.04 * H, "armF": -0.65, "armB": -0.45, "head": 0.1}], [0.59, {}]])
	begin(ctx, S, g(f, "x")); var m = bm(S, f)
	whole(ctx, S, f, "", 0.3)
	var glow = g(kf(t, [[0, {"v": 0}], [0.15, {"v": 1}], [0.42, {"v": 1}], [0.59, {"v": 0}]]), "v")
	if glow > 0:
		for u in [0.41, 0.56]:
			var e = at(S, m, u, 0.205); var gr = ctx.createRadialGradient(e.x, e.y, 0, e.x, e.y, 0.08 * H)
			gr.addColorStop(0, Color(1, 60 / 255.0, 40 / 255.0, 0.7 * glow)); gr.addColorStop(1, Color(1, 60 / 255.0, 40 / 255.0, 0))
			ctx.fillStyle = gr; ctx.fillRect(e.x - 0.08 * H, e.y - 0.08 * H, 0.16 * H, 0.16 * H)
	var o = at(S, m, 0.5, 0.45); var T = tgt(S, 0.5)
	for i in 4:
		var q = seg(t, 0.2 + i * 0.03, TC + 0.06 + i * 0.03)
		if q <= 0 or q >= 1: continue
		var x = lerp_(o.x + 0.1 * H, T.x, q); var hh = (0.25 + 0.35 * q) * H; var pts = []
		for j in 11:
			var v = j / 10.0 - 0.5; pts.append(V(x + sin(v * 9 + t * 40 + i) * 0.03 * H + absf(v) * -0.12 * H, T.y + v * hh))
		ctx.save(); ctx.globalAlpha *= sin(q * PI); crayon(ctx, pts, "rgba(255,150,60,.85)" if i % 2 else "rgba(255,90,40,.8)", 0.03 * H, 50 + i); ctx.restore()
	for i in 3: puff(ctx, (i - 1) * 0.15 * H, -0.02 * H, 0.06 * H, seg(t, 0.05 + i * 0.04, 0.5), "rgba(230,200,170,.45)", 60 + i, 3)
	var p = t - TC
	cracks(ctx, S.tx + S.back, S.ty, 0.5 * th, seg(t, TC, TC + 0.05) * (1 - seg(t, 0.5, 0.59)), 70)
	for i in 3: puff(ctx, S.tx + S.back + (i - 1) * 0.15 * th, S.ty - (0.5 + i * 0.15) * th, 0.1 * th, seg(t, TC + i * 0.03, 0.55), "rgba(255,255,255,.55)", 80 + i, 3)
	if p >= 0 and p < 0.14: burst(ctx, T.x, T.y, 0.35 * th, 1 - p / 0.14, "#ffb070", 81, 10)
	pop(ctx, S, T.x, T.y - 0.5 * th, "好熱呀！", 0.22 * th, "#ff9a50", TC, 0.32)
	end(ctx); return true

# 倀鬼：吹口哨，細老虎撲過去
static func changgui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var TP = [0.80, 0.99]
	var f = kf(t, [[0, {}], [0.12, {"armF": -0.8, "head": -0.12, "r": -3}], [0.22, {"armF": -0.85, "head": -0.15, "r": -3}], [0.30, {"armF": 0.3, "head": 0.1, "r": 4}], [0.59, {}]])
	var m = bm(S, f); var home = at(S, bm(S, {}), TP[0], TP[1]); var land = V(S.tx - 0.28 * th + S.back, S.ty)
	var x: float; var y: float; var r = 0.0; var sx = 1.0; var sy = 1.0
	if t < 0.14:
		var k = BtMoves.eo(seg(t, 0.04, 0.14)); x = home.x; y = home.y; sy = 1 - 0.18 * k; sx = 1 + 0.1 * k
	elif t < TC:
		var q = seg(t, 0.14, TC); x = lerp_(home.x, land.x, q); y = lerp_(home.y, land.y, q) - 0.55 * H * 4 * q * (1 - q); r = lerp_(-25, 30, q); sy = 1 + 0.12 * sin(q * PI)
	elif t < 0.36:
		x = land.x; y = land.y; r = 30 - 30 * seg(t, TC, 0.31); sy = 1 - 0.12 * sin(seg(t, TC, 0.31) * PI)
	else:
		var q = seg(t, 0.36, 0.59); var hop = absf(sin(q * PI * 2)); x = lerp_(land.x, home.x, q); y = home.y - hop * 0.18 * H; r = -10 * hop
	begin(ctx, S, g(f, "x"))
	body(ctx, S, m, pose(S, f, 0.3), key)
	piece_at(ctx, S, "tiger", x, y, r, TP[0], TP[1], sx, sy)
	var mo = at(S, m, 0.25, 0.33)
	for i in 3:
		var q = seg(t, 0.04 + i * 0.05, 0.22 + i * 0.05)
		if q > 0 and q < 1: txt(ctx, S, mo.x + q * 0.25 * H, mo.y - q * 0.25 * H - i * 0.03 * H, "♫" if i % 2 else "♪", 0.1 * H, "#bfe8ff", sin(q * PI))
	var T = tgt(S, 0.6); var p = t - TC
	if p >= 0 and p < 0.25:
		for i in 3: crayon(ctx, [V(T.x - 0.12 * th + i * 0.07 * th, T.y - 0.15 * th), V(T.x - 0.18 * th + i * 0.07 * th, T.y + 0.12 * th)], "rgba(255,240,230,.9)", 0.025 * th, 90 + i)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#ffd27a", 95, 9)
	pop(ctx, S, T.x, T.y - 0.45 * th, "嗷！", 0.24 * th, "#ffb347", TC, 0.3)
	end(ctx); return true

# 鬼新娘：拋繡球
static func guixinniang(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var BC = [0.39, 0.63]
	var f = kf(t, [[0, {}], [0.15, {"r": -7, "armF": -1.0, "armB": -0.9, "head": -0.12, "hairL": 0.25, "hairR": 0.25, "y": -0.03 * H}], [0.22, {"r": 8, "armF": -0.6, "armB": -0.5, "head": 0.1, "hairL": -0.3, "hairR": -0.3}, "o"], [0.45, {"r": 2, "armF": -0.2, "armB": -0.2}], [0.59, {}]])
	var m = bm(S, f); var rest = at(S, m, BC[0], BC[1]); var up = at(S, m, 0.42, 0.05); var T = tgt(S, 0.82)
	var P = kf(t, [[0, {"x": rest.x, "y": rest.y, "r": 0}], [0.15, {"x": up.x - 0.05 * H, "y": up.y, "r": -20}], [0.17, {"x": up.x, "y": up.y, "r": -10}]])
	var bx = g(P, "x"); var by = g(P, "y"); var br = g(P, "r"); var bs = 1.0
	if t >= 0.17 and t < TC:
		var q = seg(t, 0.17, TC); bx = lerp_(up.x, T.x, q); by = lerp_(up.y, T.y, q) - 0.3 * H * 4 * q * (1 - q); br = q * 300
	elif t >= TC and t < 0.40:
		var q = seg(t, TC, 0.40); bx = T.x - q * 0.15 * th; by = T.y - 0.45 * th * sin(q * PI); br = 300 + q * 200; bs = 1 - 0.25 * sin(q / 0.12 * PI) if q < 0.12 else 1.0
	elif t >= 0.40:
		var q = BtMoves.eio(seg(t, 0.40, 0.56)); bx = lerp_(T.x - 0.15 * th, rest.x, q); by = lerp_(T.y, rest.y, q) - 0.35 * H * 4 * q * (1 - q); br = 500 + q * 220
		if t > 0.56: bx = rest.x; by = rest.y; br = 0
	begin(ctx, S, g(f, "x"))
	body(ctx, S, m, pose(S, f, 0.3), key)
	if t > 0.17 and t < 0.56:
		var pts = []; var pts2 = []
		for i in 8:
			var k = i / 7.0; var pp = V(bx - (bx - up.x) * 0.35 * k + sin(t * 30 + k * 5) * 0.03 * H, by - (by - up.y) * 0.35 * k + k * 0.08 * H)
			pts.append(pp); pts2.append(pp + V(0, 0.02 * H))
		ctx.save(); ctx.globalAlpha *= 0.85; crayon(ctx, pts, "#d8252e", 0.035 * H, 7); crayon(ctx, pts2, "#ff6a5a", 0.015 * H, 8); ctx.restore()
	piece_at(ctx, S, "ball", bx, by, br, BC[0], BC[1], bs, 2 - bs)
	var p = t - TC
	if p >= 0 and p < 0.3:
		for i in 9:
			var an = rnd(i) * 6.28; var d = (0.1 + p * 1.3) * th * (0.5 + rnd(i + 3))
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.3; ctx.fillStyle = Color("#e8303a") if i % 2 else Color("#ff8a80"); ctx.beginPath(); ctx.ellipse(T.x + cos(an) * d, T.y + sin(an) * d + p * p * 2 * th, 0.03 * th, 0.018 * th, an + t * 9, 0, 7); ctx.fill(); ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#ffd0d0", 99, 9)
	pop(ctx, S, T.x, T.y - 0.35 * th, "嫁畀我！", 0.2 * th, "#ff8a8a", TC, 0.32)
	end(ctx); return true

# 山魈：單腳跳過去，長臂一掃
static func shanxiao(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.45 * th - 0.25 * H)
	var f = kf(t, [[0, {}], [0.14, {"sy": 0.88, "sx": 1.06, "armF": 0.9, "armB": 0.5, "body": -0.1, "head": -0.1, "hairL": 0.2, "hairR": 0.2}], [0.20, {"y": -0.16 * H, "x": D2 * 0.6, "sy": 1.05, "armF": 0.8, "armB": 0.4, "r": -6}, "o"], [TC, {"x": D2, "y": 0, "sy": 0.94, "armF": -0.9, "armB": -0.3, "body": 0.15, "head": 0.1, "r": 10, "hairL": -0.3, "hairR": -0.3}, "i"], [0.36, {"x": D2, "sy": 0.96, "armF": -1.0, "armB": -0.4, "body": 0.15, "r": 8}], [0.46, {"x": D2 * 0.5, "y": -0.12 * H, "armF": -0.2}], [0.52, {"x": D2 * 0.3, "y": 0}], [0.56, {"x": D2 * 0.1, "y": -0.06 * H}], [0.59, {}]])
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / H)); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.55); var p = t - TC
	if t > 0.2 and t < 0.3: speed(ctx, T.x - 0.1 * th, T.y - 0.1 * th, 0.3, 1, 0.4 * H, 0.2 * H, seg(t, 0.2, 0.24), "rgba(220,240,200,.7)", 12, 4)
	if p >= 0 and p < 0.28:
		for i in 3: crayon(ctx, [V(T.x - 0.15 * th + i * 0.08 * th, T.y - 0.25 * th), V(T.x - 0.05 * th + i * 0.08 * th, T.y + 0.2 * th)], "rgba(255,245,235,.95)", 0.03 * th, 110 + i)
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.32 * th, 1 - p / 0.13, "#e9ffd0", 113, 9)
	end(ctx); return true

# 白骨精：飛吻變骷髏
static func baigujing(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.15, {"r": -5, "armF": -0.25, "head": -0.15, "body": -0.08, "orn": 0.3}], [0.22, {"r": 6, "armF": -0.9, "head": 0.12, "body": 0.08, "orn": -0.3}, "o"], [0.40, {"r": 3, "armF": -0.5, "head": 0.05}], [0.59, {}]])
	var m = bm(S, f); begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var lip = at(S, m, 0.33, 0.235); var T = tgt(S, 0.8)
	var q = seg(t, 0.19, TC); var x = lerp_(lip.x, T.x, q); var y = lerp_(lip.y, T.y, q) + sin(q * 9) * 0.03 * H
	if t > 0.19 and t < TC + 0.01:
		var r = (0.04 + 0.04 * q) * H; ctx.save(); ctx.translate(x, y); ctx.rotate(sin(t * 20) * 0.2); ctx.fillStyle = Color("#ff7aa8"); ctx.strokeStyle = Color("#5a1a30"); ctx.lineWidth = r * 0.15
		ctx.beginPath(); ctx.moveTo(0, r * 0.9); ctx.bezierCurveTo(-r * 1.4, -r * 0.1, -r * 0.6, -r * 1.1, 0, -r * 0.35); ctx.bezierCurveTo(r * 0.6, -r * 1.1, r * 1.4, -r * 0.1, 0, r * 0.9); ctx.fill(); ctx.stroke(); ctx.restore()
		for i in 3: txt(ctx, S, x - (i + 1) * 0.06 * H, y + sin(i * 2 + t * 10) * 0.03 * H, "♥", 0.05 * H, "#ffb3cc", 0.6 - i * 0.18)
	var p = t - TC
	if p >= 0 and p < 0.26:
		var k = p / 0.26; var r = 0.16 * th * (p / 0.04 if p < 0.04 else 1.0); var bite = absf(sin(p * 40)) * r * 0.25
		ctx.save(); ctx.globalAlpha *= (1 - k) / 0.25 if k > 0.75 else 1.0; ctx.translate(T.x, T.y); ctx.lineWidth = r * 0.12; ctx.strokeStyle = Color("#3a2a2a"); ctx.fillStyle = Color("#f4efe2")
		ctx.beginPath(); ctx.arc(0, -bite * 0.5, r, PI * 0.95, PI * 2.05); ctx.lineTo(r * 0.6, r * 0.25 - bite * 0.5); ctx.lineTo(-r * 0.6, r * 0.25 - bite * 0.5); ctx.closePath(); ctx.fill(); ctx.stroke()
		ctx.fillStyle = Color("#2a1a1a"); ctx.beginPath(); ctx.ellipse(-r * 0.38, -r * 0.2 - bite * 0.5, r * 0.22, r * 0.26, 0, 0, 7); ctx.ellipse(r * 0.38, -r * 0.2 - bite * 0.5, r * 0.22, r * 0.26, 0, 0, 7); ctx.fill()
		ctx.fillStyle = Color("#f4efe2"); ctx.beginPath(); ctx.rect(-r * 0.5, r * 0.3 + bite * 0.5, r, r * 0.35); ctx.fill(); ctx.stroke()
		for i in range(-1, 2): ctx.beginPath(); ctx.moveTo(i * r * 0.25, r * 0.3 + bite * 0.5); ctx.lineTo(i * r * 0.25, r * 0.65 + bite * 0.5); ctx.stroke()
		ctx.restore()
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.12, "#ffd6e6", 121, 9)
	pop(ctx, S, T.x, T.y - 0.35 * th, "啵！", 0.22 * th, "#ffb3cc", TC - 0.01, 0.3)
	end(ctx); return true

# 窮鬼：空口袋飛出一群飛蛾
static func _moth(ctx: Ctx, x: float, y: float, s: float, ph: float, t: float) -> void:
	var fl = absf(sin(t * 45 + ph)); ctx.save(); ctx.translate(x, y); ctx.fillStyle = Color("#c9b08a"); ctx.strokeStyle = Color("#4a3a28"); ctx.lineWidth = s * 0.12
	for sg in [-1, 1]: ctx.beginPath(); ctx.ellipse(sg * s * 0.45, -s * 0.1, s * 0.5, s * 0.35 * (0.3 + fl), sg * 0.5, 0, 7); ctx.fill(); ctx.stroke()
	ctx.fillStyle = Color("#5a4630"); ctx.beginPath(); ctx.ellipse(0, 0, s * 0.12, s * 0.3, 0, 0, 7); ctx.fill(); ctx.restore()
static func qionggui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var MC = [0.84, 0.455]
	var f = kf(t, [[0, {}], [0.15, {"armF": 0.4, "armB": -0.4, "y": -0.04 * H, "sy": 1.04, "head": -0.1}], [0.24, {"armF": 0.55, "armB": -0.55, "y": -0.02 * H, "r": 5, "head": 0.1}], [0.45, {"armF": 0.3, "armB": -0.3}], [0.59, {}]])
	var m = bm(S, f); var home = at(S, m, MC[0], MC[1]); var T = tgt(S, 0.78)
	var pk = [at(S, m, 0.13, 0.62), at(S, m, 0.66, 0.62)]
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	for i in 2: puff(ctx, pk[i].x, pk[i].y, 0.06 * H, seg(t, 0.15, 0.4), "rgba(190,175,150,.55)", 130 + i, 4)
	for i in 9:
		var o = pk[i % 2]; var st = 0.17 + rnd(i) * 0.04; var q = seg(t, st, TC); var an = t * 9 + i * 0.7; var rad = (0.12 + rnd(i + 9) * 0.12) * th
		if t < st: continue
		var x = lerp_(o.x, T.x + cos(an) * rad, BtMoves.eo(q)); var y = lerp_(o.y, T.y + sin(an) * rad * 0.6, BtMoves.eo(q)) - sin(q * PI) * 0.15 * H
		var sc_ = seg(t, 0.42, 0.59); x += sc_ * (rnd(i + 2) - 0.3) * 0.8 * H; y -= sc_ * (0.3 + rnd(i + 4) * 0.4) * H
		ctx.save(); ctx.globalAlpha *= 1 - sc_; _moth(ctx, x, y, 0.045 * H, i, t); ctx.restore()
	var L = kf(t, [[0, {"x": home.x, "y": home.y}], [0.15, {"x": home.x, "y": home.y - 0.06 * H}], [TC, {"x": T.x, "y": T.y - 0.08 * th}, "i"], [0.40, {"x": T.x + 0.1 * th, "y": T.y - 0.2 * th}], [0.59, {"x": home.x, "y": home.y}]])
	piece_at(ctx, S, "moth", L.x + sin(t * 25) * 0.01 * H, L.y, sin(t * 30) * 12, MC[0], MC[1])
	var p = t - TC
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.28 * th, 1 - p / 0.12, "#e8dcc0", 141, 8)
	pop(ctx, S, T.x, T.y - 0.4 * th, "一毫都冇！", 0.17 * th, "#e8dcc0", TC, 0.32)
	end(ctx); return true

# 賭鬼：擲骰仔＋飛牌
static func dugui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var DC = [0.125, 0.49]
	var shake = sin(t * 90) * 0.12 if t < 0.15 else 0.0
	var f = kf(t, [[0, {}], [0.15, {"armF": 0.5, "armB": -0.4, "r": -5, "head": -0.1}], [0.22, {"armF": -0.9, "armB": -0.6, "r": 7, "x": 0.03 * H, "head": 0.1}, "o"], [0.40, {"armF": -0.5, "armB": -0.4, "r": 4}], [0.59, {}]])
	f["armF"] = g(f, "armF") + shake
	var m = bm(S, f); var hand = at(S, m, DC[0], DC[1]); var T = tgt(S, 0.8); var C = tgt(S, 0.5)
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	var dx = hand.x; var dy = hand.y; var dr = shake * 60; var ds = 1.0
	if t >= 0.18 and t < TC:
		var q = seg(t, 0.18, TC); dx = lerp_(hand.x, T.x, q); dy = lerp_(hand.y, T.y, q) - 0.2 * H * 4 * q * (1 - q); dr = q * 720
	elif t >= TC and t < 0.45:
		var q = seg(t, TC, 0.45); dx = T.x + q * 0.3 * th; dy = T.y - 0.4 * th * sin(q * PI) + q * q * 0.8 * th; dr = 720 + q * 500; ds = 1 - q
	elif t >= 0.45: ds = BtMoves.eback(seg(t, 0.47, 0.57))
	if ds > 0.02: piece_at(ctx, S, "dice", dx, dy, dr, DC[0], DC[1], ds)
	var cardO = at(S, m, 0.83, 0.42)
	for i in 3:
		var st = 0.2 + i * 0.015; var q = seg(t, st, TC + 0.01)
		if q <= 0: continue
		var stick = t > TC + 0.01; var tx2 = C.x - 0.05 * th; var ty2 = C.y + (i - 1) * 0.15 * th
		var x = tx2 if stick else lerp_(cardO.x, tx2, q); var y = ty2 if stick else lerp_(cardO.y, ty2, q) - 0.1 * H * sin(q * PI); var al = 1 - seg(t, 0.45, 0.55)
		if al <= 0: continue
		ctx.save(); ctx.globalAlpha *= al; ctx.translate(x, y); ctx.rotate(0.5 + i * 0.3 if stick else q * 20 + i); var w = 0.07 * H; var h = 0.1 * H
		ctx.fillStyle = Color("#fbf6ea"); ctx.strokeStyle = Color("#3a2a2a"); ctx.lineWidth = w * 0.1; ctx.beginPath(); ctx.roundRect(-w / 2, -h / 2, w, h, w * 0.15); ctx.fill(); ctx.stroke()
		ctx.fillStyle = Color("#222222") if i == 1 else Color("#c8202a"); ctx.font = "900 %dpx sans-serif" % maxi(1, int(h * 0.55)); ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText("♠" if i == 1 else "♥", 0, 0); ctx.restore()
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#fff0b0", 151, 9)
	pop(ctx, S, T.x, T.y - 0.35 * th, "梭哈！", 0.22 * th, "#ffd84a", TC, 0.32)
	end(ctx); return true

# 酒鬼：攬住酒埕醉醺醺砸過去
static func jiugui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.55 * th - 0.25 * H)
	var f = kf(t, [[0, {}], [0.16, {"r": -16, "x": -0.04 * H, "y": -0.03 * H, "armF": -0.4, "armB": -0.4, "head": -0.15}], [TC, {"r": 28, "x": D2, "y": -0.02 * H, "armF": -0.6, "armB": -0.6, "head": 0.15, "sy": 0.95}, "i"], [0.33, {"r": 22, "x": D2, "armF": -0.5, "armB": -0.5}], [0.40, {"r": -8, "x": D2 * 0.7}], [0.47, {"r": 10, "x": D2 * 0.4}], [0.53, {"r": -6, "x": D2 * 0.15}], [0.59, {}]])
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.82); var p = t - TC
	if p >= 0 and p < 0.35:
		for i in 14:
			var an = -PI * (0.1 + 0.8 * rnd(i)); var sp = (0.5 + rnd(i + 4)) * 1.4 * th; var px = T.x + cos(an) * sp * p; var py = T.y + sin(an) * sp * p + 3 * th * p * p
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = Color(170 / 255.0, 60 / 255.0, 90 / 255.0, 0.85) if i % 3 else Color(240 / 255.0, 220 / 255.0, 160 / 255.0, 0.9); ctx.beginPath(); ctx.ellipse(px, py, 0.025 * th, 0.035 * th, an, 0, 7); ctx.fill(); ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.34 * th, 1 - p / 0.13, "#ffe0f0", 161, 10)
	pop(ctx, S, T.x - 0.2 * th, T.y - 0.35 * th, "嗝～", 0.24 * th, "#ffb0c8", TC + 0.02, 0.36)
	var m = bm(S, f); var mo = at(S, m, 0.3, 0.3)
	for i in 3:
		var q = seg(t, 0.3 + i * 0.06, 0.59)
		if q > 0 and q < 1: ring(ctx, mo.x + i * 0.03 * H, mo.y - q * 0.3 * H, 0.025 * H * (1 + i * 0.3), 0.025 * H * (1 + i * 0.3), "rgba(200,220,255,.8)", 0.008 * H, 1 - q)
	end(ctx); return true

# 煙鬼：吐煙圈套頭
static func yangui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.16, {"armB": -0.35, "armF": -0.2, "sy": 1.05, "sx": 1.04, "head": -0.12, "r": -4}], [0.22, {"armB": 0.1, "sy": 0.97, "head": 0.15, "r": 6, "x": 0.02 * H}, "o"], [0.40, {"r": 3}], [0.46, {"r": 9, "head": 0.25, "sy": 0.95}], [0.52, {"r": 2}], [0.56, {"r": 8, "head": 0.2}], [0.59, {}]])
	var m = bm(S, f); var mo = at(S, m, 0.56, 0.36); var T = tgt(S, 0.84)
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var q = seg(t, 0.2, TC)
	if t > 0.2:
		var x = lerp_(mo.x, T.x, BtMoves.eo(q)) if t < TC else T.x; var y = lerp_(mo.y, T.y, BtMoves.eo(q)) if t < TC else T.y
		var shrink = 0.0 if t < TC else seg(t, TC, 0.36); var rr = (0.06 + 0.12 * q - 0.07 * shrink) * H; var al = 1 - seg(t, 0.42, 0.59)
		ring(ctx, x, y, rr, rr * 0.45, "rgba(210,210,220,.85)", 0.035 * H, al); ring(ctx, x, y, rr * 0.92, rr * 0.4, "rgba(255,255,255,.5)", 0.012 * H, al)
		if t < TC: puff(ctx, x - 0.12 * H, y, 0.05 * H, q, "rgba(220,220,230,.6)", 171, 3)
	if t < 0.18: puff(ctx, mo.x + 0.12 * H, mo.y - 0.05 * H, 0.04 * H, seg(t, 0.02, 0.18), "rgba(210,210,220,.5)", 172, 3)
	pop(ctx, S, T.x, T.y - 0.3 * th, "咳咳！", 0.2 * th, "#e0e0ea", TC + 0.02, 0.3)
	pop(ctx, S, mo.x, mo.y - 0.18 * H, "咳…", 0.12 * H, "#cfcfd8", 0.44, 0.15)
	end(ctx); return true

# 孤寒鬼：算盤摑人
static func guhangui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.74, 0.64]
	var f = kf(t, [[0, {}], [0.16, {"r": -7, "x": -0.03 * H, "head": -0.12, "armF": 0.2, "orn": 0.3}], [TC, {"r": 10, "x": 0.08 * H, "head": 0.12, "orn": -0.4}, "i"], [0.36, {"r": 8, "x": 0.08 * H}], [0.59, {}]])
	var m = bm(S, f); var w0 = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.78)
	var A = kf(t, [[0, {"x": w0.x, "y": w0.y, "r": 0}], [0.16, {"x": w0.x - 0.02 * H, "y": w0.y - 0.42 * H, "r": -150}], [TC, {"x": T.x - 0.28 * H, "y": T.y + 0.1 * H, "r": -55}, "i"], [0.33, {"x": T.x - 0.26 * H, "y": T.y + 0.16 * H, "r": -35}], [0.45, {"x": w0.x + 0.05 * H, "y": w0.y - 0.05 * H, "r": -15}], [0.59, {"x": w0.x, "y": w0.y, "r": 0}]])
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	if t > 0.18 and t < 0.29: speed(ctx, A.x + 0.1 * H, A.y - 0.15 * H, 1, 0.8, 0.3 * H, 0.15 * H, seg(t, 0.18, 0.22), "rgba(255,240,200,.7)", 181, 4)
	piece_at(ctx, S, "abacus", A.x, A.y, A.r, PV[0], PV[1])
	var p = t - TC
	if p >= 0 and p < 0.35:
		for i in 10:
			var an = -PI * rnd(i + 1); var sp = (0.4 + rnd(i + 5)) * 1.3 * th; var px = T.x + cos(an) * sp * p; var py = T.y + sin(an) * sp * p + 3 * th * p * p
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = Color("#e8b84a"); ctx.strokeStyle = Color("#5a3a10"); ctx.lineWidth = 0.008 * th; ctx.beginPath(); ctx.ellipse(px, py, 0.03 * th, 0.02 * th, 0, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore()
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.32 * th, 1 - p / 0.13, "#fff0c0", 191, 10)
	pop(ctx, S, T.x, T.y - 0.35 * th, "計清楚！", 0.2 * th, "#ffd27a", TC, 0.32)
	end(ctx); return true
