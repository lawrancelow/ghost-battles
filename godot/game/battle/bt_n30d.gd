# 新鬼專屬招式（原生）第四批（各種死法嘅意外鬼）：車禍鬼、電死鬼、凍死鬼、椰子、榴槤、噎死、笑死、嚇死、雷劈、自拍、中暑、撐死、蛇咬、食物中毒、打機猝死、大象踩扁
class_name BtN30d
extends BtN30

static func table() -> Dictionary:
	return {"n30_chehuo": chehuo, "n30_diansi": diansi, "n30_dongsi": dongsi, "n30_yezi": yezi, "n30_liulian": liulian, "n30_yesi": yesi, "n30_xiaosi": xiaosi, "n30_xiasi": xiasi,
		"n30_leipi": leipi, "n30_zipai": zipai, "n30_zhongshu": zhongshu, "n30_chengsi": chengsi, "n30_shedu": shedu, "n30_shidu": shidu, "n30_daji": daji, "n30_xiangcai": xiangcai}

static func V(x: float, y: float) -> Vector2: return Vector2(x, y)
static func sgn1(v: float) -> float: return signf(v) if v != 0 else 1.0

# 閃電（鋸齒線）
static func bolt(ctx: Ctx, a: Vector2, b: Vector2, w: float, seed: float, col = null, al = null) -> void:
	var pts = [a]; var n = 7
	for i in range(1, n):
		var k = float(i) / n; pts.append(V(lerp_(a.x, b.x, k) + (rnd(seed + i) - 0.5) * w * 6, lerp_(a.y, b.y, k) + (rnd(seed + i + 9) - 0.5) * w * 2))
	pts.append(b)
	ctx.save(); ctx.globalAlpha *= 1.0 if al == null else float(al); crayon(ctx, pts, "rgba(255,255,255,.95)", w * 1.6, seed); crayon(ctx, pts, col if col != null else "#ffe14a", w, seed + 3); ctx.restore()
const CLOUD := [[-0.6, 0.1, 0.45], [-0.2, -0.15, 0.55], [0.3, -0.1, 0.5], [0.7, 0.1, 0.4], [0.1, 0.2, 0.5]]
static func cloud(ctx: Ctx, x: float, y: float, r: float, al: float, col = null) -> void:
	if al <= 0: return
	ctx.save(); ctx.globalAlpha *= al
	for pass_ in 2:
		var k = r * 0.05 if pass_ == 0 else 0.0
		ctx.beginPath()
		for c in CLOUD:
			ctx.moveTo(x + c[0] * r + c[2] * r + k, y + c[1] * r); ctx.arc(x + c[0] * r, y + c[1] * r, c[2] * r + k, 0, 7)
		ctx.fillStyle = Color(20 / 255.0, 16 / 255.0, 30 / 255.0, 0.85) if pass_ == 0 else (col if col != null else Color("#4a4458")); ctx.fill()
	ctx.restore()

# 車禍鬼：催油門撞過去
static func chehuo(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.35 * th - 0.3 * H); var vib = sin(t * 140) * 0.006 * H if t < 0.2 else 0.0
	var f = kf(t, [[0, {}], [0.16, {"r": 8, "sy": 0.95, "armF": -0.5, "armB": -0.4, "head": 0.08, "x": -0.03 * H}], [TC, {"r": 14, "x": D2, "armF": -0.6, "armB": -0.5, "head": 0.1, "legF": -0.2, "legB": 0.2}, "i"], [0.33, {"r": -6, "x": D2 - 0.03 * H, "sy": 1.03}], [0.45, {"r": 5, "x": D2 * 0.5}], [0.59, {}]])
	f["x"] = g(f, "x") + vib; f["px"] = 0.0; f["py"] = 0.0
	begin(ctx, S, g(f, "x"))
	if t > 0.2:
		var al = 1 - seg(t, 0.45, 0.59); var x1 = minf(g(f, "x"), D2)
		for dy in [-0.012, 0.012]:
			ctx.save(); ctx.globalAlpha *= al * 0.8; ctx.strokeStyle = Color(30 / 255.0, 24 / 255.0, 20 / 255.0, 0.85); ctx.lineWidth = 0.02 * H; ctx.setLineDash([0.03 * H, 0.02 * H])
			ctx.beginPath(); ctx.moveTo(-0.1 * H, dy * H); ctx.lineTo(x1 + 0.1 * H, dy * H); ctx.stroke(); ctx.restore()
	whole(ctx, S, f, "", 0.3)
	for i in 3: puff(ctx, g(f, "x") - 0.35 * H - i * 0.05 * H, -0.2 * H, 0.06 * H, cl(fmod(t * 5 + i / 3.0, 1.0)), "rgba(70,64,70,.55)", 700 + i, 3)
	if t > 0.18 and t < TC: speed(ctx, g(f, "x") - 0.3 * H, -0.5 * H, 1, 0, 0.4 * H, 0.5 * H, 1, "rgba(240,240,255,.7)", 703, 5)
	pop(ctx, S, -0.1 * H, -1.05 * H, "叭叭！", 0.12 * H, "#ffe066", 0.02, 0.2)
	var T = tgt(S, 0.55); var p = t - TC
	if p >= 0 and p < 0.35:
		for i in 6:
			var an = -PI * (0.1 + 0.8 * rnd(i + 710)); var sp = (0.5 + rnd(i + 720)) * 1.2 * th; var x = T.x + cos(an) * sp * p; var y = T.y + sin(an) * sp * p + 3 * th * p * p
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.translate(x, y); ctx.rotate(p * 15 + i); ctx.fillStyle = Color("#9aa0ae") if i % 2 else Color("#d0d4dc"); ctx.strokeStyle = Color("#3a3a44"); ctx.lineWidth = 0.008 * th
			ctx.beginPath(); ctx.arc(0, 0, 0.025 * th, 0, 7); ctx.fill(); ctx.stroke(); ctx.fillStyle = Color("#3a3a44"); ctx.fillRect(-0.008 * th, -0.008 * th, 0.016 * th, 0.016 * th); ctx.restore()
	if p >= 0 and p < 0.14: burst(ctx, T.x, T.y, 0.4 * th, 1 - p / 0.14, "#fff0b0", 731, 12)
	pop(ctx, S, T.x, T.y - 0.5 * th, "碰！", 0.28 * th, "#ffe066", TC, 0.3)
	end(ctx); return true

# 電死鬼：插蘇放電
static func diansi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var jit = sin(t * 160) * 0.01 * H if t > 0.22 and t < 0.4 else 0.0
	var f = kf(t, [[0, {}], [0.16, {"armF": -0.55, "head": -0.1, "hairL": 0.25, "hairR": 0.25, "r": -3}], [TC, {"armF": -0.75, "head": 0.08, "hairL": 0.35, "hairR": 0.35, "r": 5, "x": 0.02 * H}, "o"], [0.40, {"armF": -0.6, "hairL": 0.3, "hairR": 0.3}], [0.5, {"head": 0.15, "sy": 0.96}], [0.59, {}]])
	f["x"] = g(f, "x") + jit
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var plug = at(S, m, 0.14, 0.32); var T = tgt(S, 0.55)
	if t < 0.22:
		for i in 4:
			var an = rnd(floor(t * 40) + i) * 6.28; crayon(ctx, [plug, V(plug.x + cos(an) * 0.08 * H, plug.y + sin(an) * 0.08 * H)], "#ffe14a", 0.012 * H, 740 + i)
	if t > 0.2 and t < 0.42:
		var k = seg(t, 0.2, TC); var e = plug.lerp(T, k); var sd = floor(t * 50)
		bolt(ctx, plug, e, 0.02 * H, 750 + sd, "#ffe14a", 1 - seg(t, 0.36, 0.42)); bolt(ctx, plug, e, 0.012 * H, 760 + sd, "#9fe8ff", 0.8 * (1 - seg(t, 0.36, 0.42)))
	var p = t - TC
	if p >= 0 and p < 0.22:
		var al = 1 - p / 0.22
		for i in 6:
			var an = i / 6.0 * 6.28 + p * 20; var r1 = 0.3 * th; var r2 = 0.42 * th
			bolt(ctx, V(T.x + cos(an) * r1 * 0.6, T.y + sin(an) * r1), V(T.x + cos(an + 0.4) * r2 * 0.6, T.y + sin(an + 0.4) * r2), 0.012 * th, 770 + i + floor(p * 40), "#ffe14a", al)
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.36 * th, 1 - p / 0.12, "#fffbd0", 781, 10)
	pop(ctx, S, T.x, T.y - 0.55 * th, "滋滋滋！", 0.2 * th, "#ffe14a", TC, 0.32)
	var hp = at(S, m, 0.55, 0.05)
	puff(ctx, hp.x, hp.y, 0.07 * H, seg(t, 0.42, 0.59), "rgba(110,100,100,.55)", 782, 4)
	end(ctx); return true

# 凍死鬼：一個乞嗤射出冰柱
static func dongsi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.08, {"head": -0.12, "r": -2}], [0.12, {"head": -0.06}], [0.19, {"head": -0.25, "r": -6, "sy": 1.04, "body": -0.08}], [0.23, {"head": 0.25, "r": 9, "sy": 0.96, "body": 0.12, "x": 0.03 * H}, "o"], [0.40, {"head": 0.15, "r": 6, "x": 0.03 * H}], [0.59, {}]])
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var nose = at(S, m, 0.40, 0.3); var T = tgt(S, 0.75)
	pop(ctx, S, nose.x, nose.y - 0.3 * H, "哈……", 0.1 * H, "#cfeaff", 0.02, 0.18)
	pop(ctx, S, nose.x + 0.1 * H, nose.y - 0.3 * H, "哈啾！", 0.14 * H, "#ffffff", 0.2, 0.2)
	if t > 0.21 and t < TC + 0.01:
		var k = seg(t, 0.21, TC); var x = lerp_(nose.x, T.x, k); var y = lerp_(nose.y, T.y, k); var L = 0.16 * H
		ctx.save(); ctx.translate(x, y); ctx.rotate(atan2(T.y - nose.y, T.x - nose.x)); ctx.fillStyle = Color(210 / 255.0, 240 / 255.0, 1, 0.95); ctx.strokeStyle = Color("#4a8ac8"); ctx.lineWidth = 0.008 * H
		ctx.beginPath(); ctx.moveTo(L * 0.5, 0); ctx.lineTo(-L * 0.5, -0.03 * H); ctx.lineTo(-L * 0.45, 0.03 * H); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore()
		speed(ctx, x, y, 1, 0, 0.25 * H, 0.06 * H, 0.8, "rgba(220,240,255,.8)", 790, 3)
	var p = t - TC
	if p >= 0 and p < 0.3:
		var C = V(S.tx + S.back, S.ty); var w = 0.62 * th; var h = 1.05 * th; var crack = seg(p, 0.15, 0.3); var al = 1 - crack
		ctx.save(); ctx.globalAlpha *= al * 0.75; ctx.fillStyle = Color(190 / 255.0, 230 / 255.0, 1, 0.55); ctx.strokeStyle = Color("#6aaee0"); ctx.lineWidth = 0.02 * th
		ctx.beginPath(); ctx.roundRect(C.x - w / 2, C.y - h, w, h, 0.05 * th); ctx.fill(); ctx.stroke()
		ctx.strokeStyle = Color(1, 1, 1, 0.9); ctx.beginPath(); ctx.moveTo(C.x - w * 0.35, C.y - h * 0.85); ctx.lineTo(C.x - w * 0.2, C.y - h * 0.55); ctx.stroke()
		if crack > 0: crayon(ctx, [V(C.x, C.y - h), V(C.x - 0.05 * th, C.y - h * 0.6), V(C.x + 0.06 * th, C.y - h * 0.3), V(C.x, C.y)], "#ffffff", 0.015 * th, 795)
		ctx.restore()
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.12, "#e8f6ff", 797, 9)
	pop(ctx, S, T.x, T.y - 0.45 * th, "凍親！", 0.2 * th, "#c8e8ff", TC, 0.3)
	end(ctx); return true

# 椰子砸死鬼：「小心頭頂！」跌椰子
static func yezi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var CC = [0.20, 0.585]
	var f = kf(t, [[0, {}], [0.12, {"head": -0.25, "armB": -0.9, "r": -4}], [0.24, {"head": -0.15, "armB": -0.8}], [TC, {"head": 0.1, "armB": -0.2, "sy": 0.95}, "o"], [0.40, {"head": 0.15, "sy": 0.96}], [0.59, {}]])
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.95); var top = V(T.x, T.y - 1.8 * H)
	if t > 0.08 and t < 0.5:
		var x: float; var y: float; var r: float
		if t < TC:
			var k = BtMoves.ei(seg(t, 0.1, TC)); x = top.x; y = lerp_(top.y, T.y - 0.1 * th, k); r = k * 90
		else:
			var q = seg(t, TC, 0.5); x = T.x + q * 0.6 * th; y = T.y - 0.1 * th - 0.5 * th * sin(q * PI) + q * q * 0.9 * th; r = 90 + q * 400
		piece_at(ctx, S, "coconut", x, y, r, CC[0], CC[1], 1.0, 1.0, 1 - seg(t, 0.45, 0.5))
		if t < TC: speed(ctx, x, y - 0.1 * H, 0, -1, 0.25 * H, 0.12 * H, seg(t, 0.18, 0.24), "rgba(255,255,255,.7)", 800, 3)
	var m = bm(S, f); var hd = at(S, m, 0.42, 0.1)
	pop(ctx, S, hd.x, hd.y - 0.15 * H, "小心頭頂！", 0.1 * H, "#ffe066", 0.06, 0.2)
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.32 * th, 1 - p / 0.13, "#fff0c0", 805, 10)
	if p >= 0 and p < 0.3: stars(ctx, T.x, T.y - 0.05 * th, 0.2 * th, t, 1 - p / 0.3)
	pop(ctx, S, T.x, T.y - 0.25 * th, "咚！", 0.26 * th, "#ffe066", TC, 0.26)
	pop(ctx, S, hd.x, hd.y - 0.15 * H, "好痛呀……", 0.1 * H, "#ffd0d0", 0.42, 0.17)
	end(ctx); return true

# 榴槤砸死鬼：由背後再掏一個榴槤擲過去
static func liulian(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var DC = [0.16, 0.56]
	var f = kf(t, [[0, {}], [0.15, {"armB": 0.9, "r": -8, "body": -0.1, "head": -0.08}], [0.21, {"armB": -1.0, "r": 10, "body": 0.15, "x": 0.04 * H}, "o"], [0.38, {"armB": -0.6, "r": 6, "x": 0.03 * H}], [0.59, {}]])
	begin(ctx, S, g(f, "x"))
	var m = bm(S, f); var bk = at(S, m, 0.82, 0.5); var T = tgt(S, 0.6)
	var x: float; var y: float; var r: float; var s = 1.0; var al = 1.0
	if t < 0.17:
		var k = BtMoves.eback(seg(t, 0.04, 0.15)); x = bk.x; y = bk.y - 0.05 * H; r = -20; s = 0.85 * k
	elif t < TC:
		var q = seg(t, 0.17, TC); var st = at(S, m, 0.6, 0.15); x = lerp_(st.x, T.x, q); y = lerp_(st.y, T.y, q) - 0.3 * H * 4 * q * (1 - q); r = q * 400; s = 0.85
	else:
		var q = seg(t, TC, 0.55); x = T.x + 0.1 * th - q * 0.2 * th; y = lerp_(T.y, S.ty - 0.15 * th, BtMoves.ei(minf(1, q * 2))); r = 400 + q * 200; s = 0.85; al = 1 - seg(t, 0.5, 0.56)
	var behind = t < 0.17
	if behind and s > 0.02: piece_at(ctx, S, "durian", x, y, r, DC[0], DC[1], s, s, al)
	whole(ctx, S, f, "", 0.3)
	if not behind and al > 0: piece_at(ctx, S, "durian", x, y, r, DC[0], DC[1], s, s, al)
	var p = t - TC
	if p >= 0 and p < 0.25:
		for i in 10:
			var an = i / 10.0 * 6.28; var r0 = 0.15 * th; var r1 = (0.25 + p) * th
			crayon(ctx, [V(T.x + cos(an) * r0, T.y + sin(an) * r0), V(T.x + cos(an) * r1, T.y + sin(an) * r1)], "#c8d060", 0.02 * th, 810 + i)
	if p >= 0:
		for i in 3:
			var q = seg(t, TC + i * 0.04, 0.59); var pts = []
			for j in 7: pts.append(V(T.x + (i - 1) * 0.12 * th + sin(j + t * 12 + i) * 0.03 * th, T.y - j * 0.06 * th - q * 0.2 * th))
			crayon(ctx, pts, "rgba(150,190,80,.75)", 0.015 * th, 820 + i)
	pop(ctx, S, T.x, T.y - 0.5 * th, "拮！", 0.26 * th, "#d8e070", TC, 0.28)
	end(ctx); return true

# 噎死鬼：一聲咳，湯圓當子彈
static func _ball(ctx: Ctx, x: float, y: float, r: float) -> void:
	ctx.save(); ctx.translate(x, y); ctx.fillStyle = Color("#fbf8f0"); ctx.strokeStyle = Color("#4a3a3a"); ctx.lineWidth = r * 0.15; ctx.beginPath(); ctx.arc(0, 0, r, 0, 7); ctx.fill(); ctx.stroke()
	ctx.fillStyle = Color(1, 1, 1, 0.9); ctx.beginPath(); ctx.arc(-r * 0.35, -r * 0.35, r * 0.25, 0, 7); ctx.fill(); ctx.restore()
static func yesi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.17, {"r": -9, "head": -0.25, "body": -0.1, "armF": -0.6, "sy": 1.04}], [0.22, {"r": 12, "head": 0.3, "body": 0.18, "armF": 0.2, "sy": 0.95, "x": 0.03 * H}, "o"], [0.40, {"r": 8, "head": 0.2, "body": 0.1}], [0.59, {}]])
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var mo = at(S, m, 0.48, 0.24); var T = tgt(S, 0.86); var shake = sin(t * 90) * 0.01 * H if t < 0.2 else 0.0
	var R = 0.045 * H
	if t > 0.2 and t < TC:
		var k = seg(t, 0.2, TC); var bx = lerp_(mo.x, T.x, k); var by = lerp_(mo.y, T.y, k)
		_ball(ctx, bx, by, R); speed(ctx, bx, by, T.x - mo.x, T.y - mo.y, 0.2 * H, 0.06 * H, 0.9, "rgba(255,255,255,.8)", 830, 3)
	elif t >= TC and t < 0.5:
		var q = seg(t, TC, 0.5); _ball(ctx, T.x - q * 0.4 * th, T.y - 0.4 * th * sin(q * PI) + q * q * 0.9 * th, R)
	pop(ctx, S, mo.x + shake, mo.y - 0.25 * H, "咳！", 0.14 * H, "#ffffff", 0.19, 0.18)
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#ffffff", 835, 9)
	pop(ctx, S, T.x, T.y - 0.3 * th, "噗！", 0.24 * th, "#ffffff", TC, 0.28)
	pop(ctx, S, mo.x, mo.y - 0.25 * H, "呼～", 0.11 * H, "#d8f0ff", 0.44, 0.15)
	end(ctx); return true

# 笑死鬼：會傳染嘅笑
static func xiaosi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var lb = absf(sin(t * 40))
	var f = kf(t, [[0, {}], [0.16, {"r": -6, "head": -0.15, "sy": 1.03}], [0.24, {"r": 14, "head": 0.25, "body": 0.2, "x": 0.02 * H}, "o"], [0.45, {"r": 10, "head": 0.2, "body": 0.15}], [0.59, {}]])
	f["y"] = g(f, "y") - lb * 0.015 * H; f["head"] = g(f, "head") + lb * 0.06
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var mo = at(S, m, 0.3, 0.3); var T = tgt(S, 0.8)
	for i in 6:
		var q = seg(t, 0.18 + i * 0.012, TC + i * 0.012)
		if q <= 0 or q >= 1: continue
		txt(ctx, S, lerp_(mo.x, T.x, q), lerp_(mo.y, T.y, q) + sin(q * 12 + i) * 0.06 * H, "哈", 0.1 * H * (0.8 + 0.4 * q), "#ffe066" if i % 2 else "#ffb347", 1 - q * 0.3, (rnd(i) - 0.5) * 0.6)
	if t < 0.2: pop(ctx, S, mo.x, mo.y - 0.25 * H, "噗…", 0.1 * H, "#ffe066", 0.03, 0.16)
	var p = t - TC
	if p >= 0 and p < 0.3:
		var k = p / 0.3
		txt(ctx, S, T.x, T.y - 0.35 * th, "哈…哈哈！", 0.18 * th, "#ffe066", 1 - k)
		drops(ctx, T.x, T.y, 0.3 * th, fmod(p * 3, 1.0), "rgba(150,210,255,.9)", 840 + floor(p * 3), 4)
		ctx.save(); ctx.globalAlpha *= 1 - k; ctx.strokeStyle = Color("#ffe066"); ctx.lineWidth = 0.015 * th; ctx.beginPath()
		for j in 40:
			var an = j * 0.4 + t * 10; var r = j * 0.004 * th; ctx.lineTo(T.x + cos(an) * r, T.y - 0.1 * th + sin(an) * r * 0.5)
		ctx.stroke(); ctx.restore()
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.28 * th, 1 - p / 0.12, "#fff3b0", 845, 9)
	end(ctx); return true

# 嚇死鬼：突然跳出嚟嚇你
static func xiasi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.4 * th - 0.3 * H)
	var f = kf(t, [[0, {}], [0.18, {"sy": 0.82, "sx": 1.04, "head": 0.12, "armF": 0.3, "armB": -0.3, "hairL": 0.2, "hairR": 0.2}], [0.235, {"sy": 1.22, "sx": 1.12, "y": -0.06 * H, "x": D2, "armF": -0.7, "armB": 0.7, "head": -0.1, "hairL": -0.45, "hairR": -0.45, "r": 6}, "back"], [0.38, {"sy": 1.15, "sx": 1.1, "y": -0.03 * H, "x": D2, "armF": -0.6, "armB": 0.6, "r": 5}], [0.59, {}]])
	begin(ctx, S, g(f, "x"))
	var sc_ = seg(t, 0.2, 0.235) * (1 - seg(t, 0.38, 0.5))
	if sc_ > 0:
		var C = V(g(f, "x"), -0.6 * H); var r = 0.65 * H * (0.6 + 0.4 * sc_)
		ctx.save(); ctx.globalAlpha *= sc_ * 0.9; ctx.fillStyle = Color("#ffe14a"); ctx.strokeStyle = Color("#5a3a10"); ctx.lineWidth = 0.012 * H; ctx.beginPath()
		for i in 24:
			var an = i / 24.0 * 6.283; var rr = r * 0.72 if i % 2 else r; ctx.lineTo(C.x + cos(an) * rr, C.y + sin(an) * rr * 0.85)
		ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore()
	whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.7); var p = t - TC
	pop(ctx, S, g(f, "x"), -1.35 * H, "哇！！", 0.2 * H, "#ff5050", 0.21, 0.3)
	if p >= 0 and p < 0.3:
		txt(ctx, S, T.x + 0.15 * th, T.y - 0.45 * th - p * 0.3 * th, "！", 0.3 * th, "#ffffff", 1 - p / 0.3)
		drops(ctx, T.x, T.y - 0.2 * th, 0.3 * th, p / 0.3, "rgba(150,210,255,.9)", 850, 5)
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.12, "#ffffff", 851, 9)
	end(ctx); return true

# 雷劈鬼：擎遮招雷
static func leipi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.17, {"armB": -0.6, "umb": -0.2, "head": -0.2, "r": -4, "y": -0.03 * H}], [TC, {"armB": -0.5, "umb": -0.1, "head": -0.1}], [0.44, {"armB": -0.5}], [0.48, {"armB": 0.1, "sy": 0.92, "head": 0.2}, "o"], [0.59, {}]])
	begin(ctx, S, g(f, "x"))
	var T = tgt(S, 0.5); var cpos = V(S.tx + S.back, S.ty - 1.45 * th); var ca = seg(t, 0.05, 0.2) * (1 - seg(t, 0.45, 0.59))
	cloud(ctx, cpos.x, cpos.y, 0.3 * th * (0.6 + 0.4 * ca), ca)
	whole(ctx, S, f, "", 0.3)
	var p = t - TC
	if p >= -0.02 and p < 0.16:
		var al = 1 - seg(p, 0.06, 0.16)
		bolt(ctx, V(cpos.x, cpos.y + 0.15 * th), V(T.x, S.ty - 0.4 * th), 0.04 * th, 860 + floor(t * 40), "#ffe14a", al)
		ctx.save(); ctx.globalAlpha *= al * 0.5; var gr = ctx.createRadialGradient(T.x, T.y, 0, T.x, T.y, 1.2 * th); gr.addColorStop(0, "rgba(255,251,220,.9)"); gr.addColorStop(1, "rgba(255,251,220,0)")
		ctx.fillStyle = gr; ctx.fillRect(T.x - 1.2 * th, T.y - 1.2 * th, 2.4 * th, 2.4 * th); ctx.restore()
	for i in 3: puff(ctx, T.x + (i - 1) * 0.12 * th, T.y - 0.4 * th, 0.1 * th, seg(t, TC + i * 0.03, 0.59), "rgba(80,70,70,.55)", 865 + i, 3)
	var m = bm(S, f); var um = at(S, m, 0.75, 0.2)
	if t > 0.43 and t < 0.5: bolt(ctx, V(um.x, um.y - 0.6 * H), um, 0.02 * H, 870, "#ffe14a", 1 - seg(t, 0.47, 0.5))
	var hp = at(S, m, 0.35, 0.05)
	puff(ctx, hp.x, hp.y, 0.07 * H, seg(t, 0.46, 0.59), "rgba(80,70,70,.6)", 872, 4)
	pop(ctx, S, T.x, T.y - 0.6 * th, "轟隆！", 0.24 * th, "#ffe14a", TC, 0.28)
	pop(ctx, S, -0.1 * H, -1.1 * H, "又嚟！", 0.12 * H, "#ffd0a0", 0.46, 0.13)
	end(ctx); return true

# 自拍跌死鬼：閃光燈，再踩中蕉皮滑過去
static func zipai(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.25 * th - 0.25 * H)
	var f = kf(t, [[0, {}], [0.14, {"armB": -0.25, "stick": -0.1, "head": -0.08, "r": -3}], [0.19, {"armB": -0.25, "r": -3}], [TC, {"r": -55, "px": 0, "py": 0, "x": D2, "y": -0.05 * H, "armB": 0.3, "armF": -0.6, "stick": 0.3}, "i"], [0.36, {"r": -60, "px": 0, "py": 0, "x": D2, "y": -0.03 * H, "armB": 0.3, "armF": -0.6}], [0.48, {"r": -15, "px": 0, "py": 0, "x": D2 * 0.4}], [0.59, {}]])
	f["px"] = 0.0; f["py"] = 0.0
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m0 = bm(S, kf(minf(t, 0.19), [[0, {}], [0.14, {"armB": -0.25, "r": -3}]])); var ph = at(S, m0, 0.80, 0.14); var T = tgt(S, 0.5)
	pop(ctx, S, -0.05 * H, -1.1 * H, "茄子～", 0.12 * H, "#ffe0f0", 0.02, 0.17)
	var fl = seg(t, 0.18, 0.2) * (1 - seg(t, 0.2, 0.3))
	if fl > 0:
		var gr = ctx.createRadialGradient(ph.x, ph.y, 0, ph.x, ph.y, 0.9 * H); gr.addColorStop(0, Color(1, 1, 1, 0.95 * fl)); gr.addColorStop(1, Color(1, 1, 1, 0))
		ctx.fillStyle = gr; ctx.fillRect(ph.x - H, ph.y - H, 2 * H, 2 * H); burst(ctx, ph.x, ph.y, 0.2 * H, fl, "#ffffff", 880, 10)
	pop(ctx, S, ph.x, ph.y - 0.12 * H, "咔嚓", 0.1 * H, "#ffffff", 0.18, 0.12)
	if t > 0.2 and t < TC: speed(ctx, g(f, "x"), -0.1 * H, 1, 0, 0.3 * H, 0.12 * H, 0.8, "rgba(255,240,180,.7)", 882, 3)
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#fff8d0", 885, 9)
	pop(ctx, S, T.x, T.y - 0.5 * th, "哎吔！", 0.2 * th, "#ffe066", TC, 0.28)
	end(ctx); return true

# 中暑鬼：太陽曬＋自己溶咗
static func zhongshu(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var f = kf(t, [[0, {}], [0.16, {"armF": -0.7, "head": 0.1}], [TC, {"armF": -0.2, "head": -0.15, "r": -3}], [0.36, {"sy": 0.72, "sx": 1.22, "head": 0.2, "armF": 0.3, "armB": -0.3}, "o"], [0.46, {"sy": 0.75, "sx": 1.2}], [0.59, {}, "back"]])
	begin(ctx, S, g(f, "x"), 1 + (1 - g(f, "sy", 1.0)) * 1.5); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.6); var sun = V(T.x, S.ty - 1.6 * th); var k = seg(t, 0.12, TC) * (1 - seg(t, 0.42, 0.59))
	if k > 0:
		ctx.save(); ctx.globalAlpha *= k; ctx.fillStyle = Color("#ffb030"); ctx.strokeStyle = Color("#a05a10"); ctx.lineWidth = 0.015 * th; ctx.beginPath(); ctx.arc(sun.x, sun.y, 0.14 * th, 0, 7); ctx.fill(); ctx.stroke()
		for i in 10:
			var an = i / 10.0 * 6.28 + t * 2; crayon(ctx, [V(sun.x + cos(an) * 0.19 * th, sun.y + sin(an) * 0.19 * th), V(sun.x + cos(an) * 0.28 * th, sun.y + sin(an) * 0.28 * th)], "#ffb030", 0.025 * th, 890 + i)
		ctx.restore()
		var b = seg(t, 0.2, TC) * (1 - seg(t, 0.4, 0.5))
		if b > 0:
			ctx.save(); ctx.globalAlpha *= b * 0.5; var gr = ctx.createLinearGradient(0, sun.y, 0, S.ty); gr.addColorStop(0, "rgba(255,220,100,.9)"); gr.addColorStop(1, "rgba(255,170,60,.2)"); ctx.fillStyle = gr
			ctx.beginPath(); ctx.moveTo(sun.x - 0.1 * th, sun.y); ctx.lineTo(sun.x + 0.1 * th, sun.y); ctx.lineTo(T.x + 0.32 * th, S.ty); ctx.lineTo(T.x - 0.32 * th, S.ty); ctx.closePath(); ctx.fill(); ctx.restore()
	var p = t - TC
	if p >= 0:
		drops(ctx, T.x, T.y - 0.3 * th, 0.4 * th, seg(p, 0, 0.3), "rgba(150,210,255,.9)", 900, 6); puff(ctx, T.x, T.y - 0.5 * th, 0.1 * th, seg(p, 0, 0.3), "rgba(255,255,255,.5)", 901, 3)
	if t > 0.3 and t < 0.55:
		ctx.save(); ctx.globalAlpha *= 0.6 * sin(seg(t, 0.3, 0.55) * PI); ctx.fillStyle = Color(230 / 255.0, 120 / 255.0, 100 / 255.0, 0.5); ctx.beginPath(); ctx.ellipse(g(f, "x"), 0, 0.35 * H, 0.04 * H, 0, 0, 7); ctx.fill(); ctx.restore()
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.12, "#ffd080", 905, 9)
	pop(ctx, S, T.x, T.y - 0.5 * th, "曬！", 0.24 * th, "#ffb030", TC, 0.3)
	end(ctx); return true

# 撐死鬼：大肚腩一頂
const FOOD := ["#e8a050", "#7ac060", "#f0d080", "#d05040"]
static func chengsi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = maxf(0, S.tx - 0.3 * th - 0.45 * S.W)
	var f = kf(t, [[0, {}], [0.16, {"r": -12, "sx": 1.1, "sy": 1.02, "x": -0.03 * H, "head": -0.15, "armF": 0.3, "armB": -0.2}], [TC, {"r": -6, "sx": 1.16, "sy": 0.94, "x": D2, "head": -0.05}, "i"], [0.32, {"r": -4, "sx": 0.96, "sy": 1.04, "x": D2 - 0.02 * H}], [0.40, {"sx": 1.04, "sy": 0.98, "x": D2 * 0.6}], [0.59, {}]])
	f["px"] = 0.0; f["py"] = 0.0
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.5); var p = t - TC; var m = bm(S, f); var pl = at(S, m, 0.82, 0.22)
	if p >= 0 and p < 0.35:
		for i in 7:
			var an = -PI * (0.2 + 0.6 * rnd(i + 910)); var sp = (0.3 + rnd(i + 920)) * 1.0 * H; var x = pl.x + cos(an) * sp * p; var y = pl.y + sin(an) * sp * p + 2.5 * H * p * p
			ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = Color(FOOD[i % 4]); ctx.beginPath(); ctx.ellipse(x, y, 0.02 * H, 0.014 * H, i, 0, 7); ctx.fill(); ctx.restore()
	if p >= 0 and p < 0.14: burst(ctx, T.x - 0.15 * th, T.y, 0.4 * th, 1 - p / 0.14, "#fff0d0", 925, 11)
	pop(ctx, S, T.x, T.y - 0.55 * th, "嘭！", 0.28 * th, "#ffd27a", TC, 0.28)
	pop(ctx, S, -0.1 * H, -1.05 * H, "嗝～", 0.12 * H, "#ffe0b0", 0.44, 0.15)
	end(ctx); return true

# 蛇咬鬼：屁股條蛇撲出去
static func shedu(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var key = nb(S.id)
	if key == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var PV = [0.70, 0.575]
	var f = kf(t, [[0, {}], [0.10, {"y": -0.06 * H, "r": -4}], [0.18, {"y": 0, "sy": 0.95}], [0.44, {"r": 3}], [0.50, {"y": -0.08 * H, "r": -6, "armF": -0.3}, "o"], [0.59, {}]])
	var m = bm(S, f); var home = at(S, m, PV[0], PV[1]); var T = tgt(S, 0.72)
	var x: float; var y: float; var r: float; var sx = 1.0
	if t < 0.15:
		var k = BtMoves.eo(seg(t, 0, 0.15)); x = home.x - 0.03 * H * k; y = home.y + 0.02 * H * k; r = 15 * k; sx = 1 - 0.1 * k
	elif t < TC:
		var q = seg(t, 0.15, TC); x = lerp_(home.x, T.x - 0.05 * th, q); y = lerp_(home.y, T.y, q) - 0.55 * H * 4 * q * (1 - q); r = lerp_(15, -150, q)
	elif t < 0.38:
		x = T.x - 0.05 * th + sin(t * 90) * 0.01 * H; y = T.y; r = -150
	else:
		var q = BtMoves.eio(seg(t, 0.38, 0.52)); x = lerp_(T.x - 0.05 * th, home.x, q); y = lerp_(T.y, home.y, q) - 0.4 * H * 4 * q * (1 - q); r = lerp_(-150, 0, q)
		if t > 0.52: x = home.x; y = home.y; r = 0
	begin(ctx, S, g(f, "x")); body(ctx, S, m, pose(S, f, 0.3), key)
	piece_at(ctx, S, "snake", x, y, r, PV[0], PV[1], sx, 1.0)
	var p = t - TC
	if p >= 0 and p < 0.13: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.13, "#e8f0a0", 935, 9)
	pop(ctx, S, T.x, T.y - 0.4 * th, "嘶！", 0.24 * th, "#d8e870", TC, 0.28)
	pop(ctx, S, -0.1 * H, -1.1 * H, "哎喲！", 0.12 * H, "#ffe066", 0.5, 0.09)
	end(ctx); return true

# 食物中毒鬼：轉身放一個綠色嘅屁
static func shidu(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th
	var turn = cos(seg(t, 0.05, 0.11) * PI) if t < 0.12 else (-cos(seg(t, 0.5, 0.56) * PI) if t > 0.45 else -1.0)
	var f = kf(t, [[0, {}], [0.12, {"body": 0.1, "head": 0.1}], [0.2, {"body": 0.25, "head": 0.15, "sy": 0.95, "r": -6}], [0.24, {"body": 0.2, "sy": 1.03, "r": -3}, "o"], [0.45, {"body": 0.1}], [0.59, {}]])
	f["sx"] = 0.15 * sgn1(turn) if absf(turn) < 0.15 else turn; f["px"] = 0.0; f["py"] = -0.4 * H
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.6); var src = V(0.12 * H, -0.45 * H)
	for i in 6:
		var q = seg(t, 0.2 + i * 0.01, TC + 0.02 + i * 0.01); var x = lerp_(src.x, T.x + (i - 2.5) * 0.06 * th, BtMoves.eo(q)); var y = lerp_(src.y, T.y + (rnd(i) - 0.5) * 0.3 * th, BtMoves.eo(q)); var al = 1 - seg(t, 0.45, 0.59)
		if q <= 0: continue
		ctx.save(); ctx.globalAlpha *= al * 0.85; ctx.fillStyle = Color(140 / 255.0, 190 / 255.0, 70 / 255.0, 0.8) if i % 2 else Color(110 / 255.0, 160 / 255.0, 60 / 255.0, 0.8); ctx.strokeStyle = Color(50 / 255.0, 80 / 255.0, 30 / 255.0, 0.7); ctx.lineWidth = 0.008 * H
		ctx.beginPath(); ctx.arc(x, y, (0.05 + 0.07 * q) * H, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore()
	if t > TC:
		for i in 3:
			var q = seg(t, TC + i * 0.03, 0.59); var pts = []
			for j in 7: pts.append(V(T.x + (i - 1) * 0.12 * th + sin(j + t * 14 + i) * 0.03 * th, T.y - 0.2 * th - j * 0.06 * th - q * 0.2 * th))
			crayon(ctx, pts, "rgba(120,170,60,.85)", 0.018 * th, 940 + i)
	pop(ctx, S, src.x + 0.1 * H, src.y - 0.1 * H, "噗——", 0.12 * H, "#b8e070", 0.2, 0.2)
	pop(ctx, S, T.x, T.y - 0.55 * th, "臭！", 0.26 * th, "#b8e070", TC + 0.02, 0.3)
	end(ctx); return true

# 打機猝死鬼：手掣狂撳連段
const ARROWS := ["↑", "↑", "↓", "↓", "←", "→"]
const BTNS := [["A", "#4ac060"], ["B", "#e84a4a"], ["X", "#4a8ae8"], ["Y", "#e8c84a"]]
const PIX := ["#ffe14a", "#ff5a8a", "#5ae8ff"]
static func daji(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var mash = sin(t * 70) * 0.06
	var f = kf(t, [[0, {}], [0.16, {"head": 0.1, "body": 0.08, "r": 2}], [TC, {"head": -0.05, "body": -0.05, "r": -4, "x": 0.02 * H}], [0.59, {}]])
	if t < 0.4: f["armF"] = g(f, "armF") + mash; f["armB"] = g(f, "armB") - mash
	begin(ctx, S, g(f, "x")); whole(ctx, S, f, "", 0.3)
	var m = bm(S, f); var pad = at(S, m, 0.4, 0.6); var hd = at(S, m, 0.42, 0.02); var T = tgt(S, 0.6)
	for i in ARROWS.size():
		var q = seg(t, 0.02 + i * 0.025, 0.25)
		if q > 0 and q < 1: txt(ctx, S, hd.x + (i - 2.5) * 0.08 * H, hd.y - 0.1 * H - q * 0.06 * H, ARROWS[i], 0.08 * H, "#9fe8ff", sin(q * PI))
	for i in 8:
		var q = seg(t, 0.18 + i * 0.008, TC + i * 0.008)
		if q <= 0 or q >= 1: continue
		var x = lerp_(pad.x, T.x, q); var y = lerp_(pad.y, T.y + (i % 3 - 1) * 0.1 * th, q) - sin(q * PI) * 0.1 * H; var r = 0.035 * H; var bb = BTNS[i % 4]
		ctx.save(); ctx.fillStyle = Color(bb[1]); ctx.strokeStyle = Color("#1a1a2a"); ctx.lineWidth = r * 0.2; ctx.beginPath(); ctx.arc(x, y, r, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore()
		txt(ctx, S, x, y, bb[0], r * 1.3, "#ffffff")
	var p = t - TC
	if p >= 0 and p < 0.3:
		for i in 12:
			var an = rnd(i + 950) * 6.28; var d = (0.1 + p * 1.2) * th * (0.5 + rnd(i + 960)); var s = 0.035 * th * (1 - p / 0.3)
			ctx.fillStyle = Color(PIX[i % 3]); ctx.fillRect(T.x + cos(an) * d - s / 2, T.y + sin(an) * d - s / 2, s, s)
	pop(ctx, S, T.x, T.y - 0.5 * th, "COMBO ×8", 0.16 * th, "#ffe14a", TC, 0.3)
	pop(ctx, S, hd.x, hd.y - 0.1 * H, "GG", 0.12 * H, "#9fe8ff", 0.45, 0.14)
	end(ctx); return true

# 大象踩扁鬼：扁成一張紙，打橫削過去
static func xiangcai(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var t: float = S.tt; var H: float = S.H; var th: float = S.th; var D2 = S.tx - 0.1 * th
	var fl = sin(t * 30) * 0.06
	var f = kf(t, [[0, {}], [0.10, {"y": -0.25 * H, "r": -8, "sy": 1.08}], [0.19, {"y": -0.6 * H, "sy": 0.14, "r": 0}], [TC, {"y": -0.6 * H, "sy": 0.12, "x": D2, "r": 4}, "i"], [0.34, {"y": -0.6 * H, "sy": 0.14, "x": D2 + 0.1 * H}], [0.44, {"y": -0.35 * H, "sy": 0.7, "x": D2 * 0.5, "r": -10}], [0.52, {"y": -0.1 * H, "sy": 1.05, "x": D2 * 0.15, "r": 6}], [0.59, {}]])
	f["px"] = 0.0; f["py"] = -0.5 * H
	if t < 0.5: f["armF"] = fl * 2
	f["armB"] = -fl * 2
	begin(ctx, S, g(f, "x"), 1 - cl(-g(f, "y") / H) * 0.6)
	if t > 0.19 and t < TC + 0.02: speed(ctx, g(f, "x") - 0.4 * S.W, g(f, "y") - 0.5 * H, 1, 0, 0.5 * H, 0.06 * H, 1, "rgba(240,240,255,.8)", 970, 3)
	whole(ctx, S, f, "", 0.3)
	var T = tgt(S, 0.6); var p = t - TC
	if p >= 0 and p < 0.2:
		var k = minf(1, p / 0.04); crayon(ctx, [V(T.x - 0.35 * th, T.y - 0.05 * th), V(T.x - 0.35 * th + 0.7 * th * k, T.y + 0.05 * th)], "rgba(255,255,255,.95)", 0.03 * th, 975)
	if p >= 0 and p < 0.12: burst(ctx, T.x, T.y, 0.3 * th, 1 - p / 0.12, "#ffffff", 977, 9)
	pop(ctx, S, T.x, T.y - 0.45 * th, "唰！", 0.24 * th, "#ffffff", TC, 0.28)
	end(ctx); return true
