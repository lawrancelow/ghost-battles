# 主線戰鬥（原生）：新鬼 40 隻專屬招式嘅工具（N30K、N30M，n30_moves.js）＋拆件身體（N30.body／cutBody，n30_rigs.js）
#  招式本體喺 bt_n30a.gd、bt_n30b.gd……（逐招照 JS 移植）
#  座標「F」：原點 = 自己腳底，+x = 往敵人，y 向下；陣列點 [x, y] 用 Vector2
class_name BtN30

const D := PI / 180.0
const TW := BtMoves.TW
const TC := BtMoves.TC
const TE := BtMoves.TE
const ONE := {"sx": 1.0, "sy": 1.0, "a": 1.0}
const TF := {"x": 1, "y": 1, "r": 1, "px": 1, "py": 1, "sx": 1, "sy": 1, "a": 1}

# ---------------- 數學 ----------------
static func seg(t: float, a: float, b: float) -> float: return BtMoves.seg(t, a, b)
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func cl(v: float, a := 0.0, b := 1.0) -> float: return clampf(v, a, b)
static func rnd(i: float) -> float: return BtMoves.rnd(i)
static func ez(name: String, p: float) -> float:
	match name:
		"lin": return p
		"o": return BtMoves.eo(p)
		"i": return BtMoves.ei(p)
		"back": return BtMoves.eback(p)
	return BtMoves.eio(p)

# ---------------- 開局 ----------------
static var _rigok := {}
# JS 嘅 n30 骨架（n30_rigs.js 用 MeshAnim.mk 砌）抄落原生 MeshAnim.RIG
static func ensure_rig(id: String) -> bool:
	if _rigok.has(id): return _rigok[id]
	var ok := false
	var JR = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), id)
	if JR is Dictionary and JR.get("bones") is Array:
		if not MeshAnim.RIG.has(id): MeshAnim.RIG[id] = {"bones": JR.bones}
		if J.t(J.gp(J.gp(J.G.get("MeshAnim"), "NATIVE_R"), id)): MeshAnim.NATIVE_R[id] = 1
		ok = true
	_rigok[id] = ok
	return ok

static func setup(a: Dictionary):
	var id: String = a.type; var o: Dictionary = a.o
	if not Spr.ok(id) or not ensure_rig(id): return null
	var img = Spr.get_tex(id)
	var fw = 1.0 if a.faceRight else -1.0; var s: float = a.s; var H: float = a.H; var W = H * img.get_width() / img.get_height()
	var nr = MeshAnim.NATIVE_R.has(id); var tt = BtMoves.tau(o); var lg = BtMoves.lunge_of(o, s); var th = 58 * s
	var tx = maxf(0.3 * H, (J.num(o.tdx) * fw if o.get("tdx") != null else 44 * s) - lg); var ty = J.num(o.get("tdy", 0))
	var fl = 0.0 if a.solid else (3 + sin(J.num(o.get("t", 0)) * 2.4) * 2) * s
	return {"a": a, "id": id, "o": o, "fw": fw, "s": s, "H": H, "W": W, "nr": nr, "tt": tt, "tx": tx, "ty": ty, "th": th, "fl": fl, "t": J.num(o.get("t", 0)), "solid": a.solid, "back": BtMoves.tgt_back(tt, th)}

# 關鍵格：[[時間, {欄位}, ease?], …]（欄位缺當 0；sx/sy/a 缺當 1）
static func kf(t: float, keys: Array) -> Dictionary:
	if t <= keys[0][0]: return (keys[0][1] as Dictionary).duplicate()
	for i in keys.size() - 1:
		var t0: float = keys[i][0]; var A: Dictionary = keys[i][1]; var t1: float = keys[i + 1][0]; var B: Dictionary = keys[i + 1][1]
		if t <= t1:
			var den = t1 - t0
			var p = (t - t0) / (den if den != 0 else 1.0)
			var k = ez(keys[i + 1][2] if keys[i + 1].size() > 2 else "", p)
			var r = {}
			for n in A: r[n] = lerp_(float(A[n]), float(B[n]) if B.has(n) else float(ONE.get(n, 0.0)), k)
			for n in B: if not A.has(n): r[n] = lerp_(float(ONE.get(n, 0.0)), float(B[n]), k)
			return r
	return (keys[-1][1] as Dictionary).duplicate()
static func g(f: Dictionary, n: String, d := 0.0) -> float: return float(f.get(n, d))

# 身體矩陣：位移 (x,y)、繞 (px,py) 轉 r 度、以腳底為準縮放
static func bm(S: Dictionary, f: Dictionary) -> Transform2D:
	var px = g(f, "px"); var py = g(f, "py", -0.45 * S.H)
	return BtMoves.mt(g(f, "x"), g(f, "y") - S.fl) * BtMoves.mt(px, py) * BtMoves.mr(g(f, "r") * D) * BtMoves.mt(-px, -py) * BtMoves.sc(g(f, "sx", 1.0), g(f, "sy", 1.0))
static func pose(S: Dictionary, f: Dictionary, idleK = null) -> Dictionary:
	var z = MeshAnim.idle(S.t); var k = 0.5 if idleK == null else float(idleK)
	for n in z: if z[n] is float: z[n] = 1 + (z[n] - 1) * k if (n == "sx" or n == "sy") else z[n] * k
	z.x = 0.0; z.rot = 0.0
	for n in f: if not TF.has(n): z[n] = float(z.get(n, 0.0)) + (float(f[n]) if S.nr else -float(f[n]))
	return z
static func body(ctx: Ctx, S: Dictionary, m: Transform2D, mp: Dictionary, key := "", alpha = null) -> void:
	ctx.save(); BtMoves.mset(ctx, m)
	if not S.nr: ctx.scale(-1, 1)
	if alpha != null: ctx.globalAlpha *= float(alpha)
	var k = key if key != "" else S.id
	if not MeshAnim.RIG.has(k): MeshAnim.RIG[k] = MeshAnim.RIG[S.id]
	MeshAnim.draw_body(ctx, S.id, k, S.H, mp); ctx.restore()
static func whole(ctx: Ctx, S: Dictionary, f: Dictionary, key := "", idleK = null) -> void:
	body(ctx, S, bm(S, f), pose(S, f, idleK), key, f.get("a"))
static func ip(S: Dictionary, u: float, v: float) -> Vector2: return Vector2((1.0 if S.nr else -1.0) * (u - 0.5) * S.W, (v - 1) * S.H)
static func at(S: Dictionary, m: Transform2D, u: float, v: float) -> Vector2: return m * ip(S, u, v)
static func piece(ctx: Ctx, S: Dictionary, name: String, m: Transform2D, pu: float, pv: float, alpha = null) -> void:
	BtMoves.piece(ctx, S, S.id + "__" + name, m, pu, pv, alpha)
static func piece_at(ctx: Ctx, S: Dictionary, name: String, x: float, y: float, r: float, pu: float, pv: float, sx := 1.0, sy = null, alpha = null) -> void:
	piece(ctx, S, name, BtMoves.mt(x, y) * BtMoves.mr(r * D) * BtMoves.sc(sx, sx if sy == null else float(sy)), pu, pv, alpha)

# ---------- 帶狀貼圖（舌頭、脖子、手臂）：一個網格畫晒 ----------
static func ribbon(ctx: Ctx, S: Dictionary, name: String, srcUV: Array, hw: float, dst: Array, wk = null) -> void:
	var key = S.id + "__" + name
	if not Spr.ok(key): return
	var img = Spr.get_tex(key); var iw = float(img.get_width()); var ih = float(img.get_height())
	var N = 28
	var src = []
	for p in srcUV: src.append(Vector2(p[0] * iw, p[1] * ih))
	var Sp = BtMoves2._resample(src, N)[0]; var SN = BtMoves2._normals(Sp); var Dp = BtMoves2._resample(dst, N)[0]; var DN = BtMoves2._normals(Dp)
	var sw = hw * ih; var dw = hw * S.H; var flip = 1.0 if S.nr else -1.0
	var pts = PackedVector2Array(); var uvs = PackedVector2Array(); var idx = PackedInt32Array()
	for i in N:
		var w = dw * (float(wk.call(i, N)) if wk != null else 1.0)
		pts.append_array([Dp[i] + DN[i] * w * flip, Dp[i] - DN[i] * w * flip])
		var a0 = Sp[i] + SN[i] * sw; var b0 = Sp[i] - SN[i] * sw
		uvs.append_array([Vector2(a0.x / iw, a0.y / ih), Vector2(b0.x / iw, b0.y / ih)])
		if i < N - 1: var b = i * 2; idx.append_array([b, b + 1, b + 2, b + 1, b + 3, b + 2])
	ctx.drawTriangles(img, pts, uvs, idx)
static func rest_line(S: Dictionary, m: Transform2D, uv: Array) -> Array:
	var o = []
	for p in uv: o.append(at(S, m, p[0], p[1]))
	return o
static func lerp_line(A: Array, B: Array, k: float) -> Array:
	var o = []
	for i in A.size(): o.append(A[i].lerp(B[i], k))
	return o
static func quad(a: Vector2, c: Vector2, b: Vector2, n: int) -> Array:
	var o = []
	for i in n:
		var t = float(i) / (n - 1); var u = 1 - t; o.append(u * u * a + 2 * u * t * c + t * t * b)
	return o
static func same(pts: Array, n: int) -> Array: return BtMoves2._resample(pts, n)[0]
# N30M.line：休息形狀 ↔ 二次曲線（root→ctrl→tip），b = 伸出程度
static func line(S: Dictionary, m: Transform2D, src: Array, root, ctrl: Vector2, tip: Vector2, b: float) -> Array:
	var rest = same(rest_line(S, m, src), 14); var cur = quad(root if root != null else rest[0], ctrl, tip, 14)
	return lerp_line(rest, cur, cl(b))

# ---------- 蠟筆特效 ----------
static func crayon(ctx: Ctx, pts: Array, col, w: float, seed: float) -> void: BtMoves.crayon(ctx, pts, col, w, seed)
static func burst(ctx: Ctx, x: float, y: float, r: float, k: float, col, seed: float, n := 9) -> void: BtMoves.burst(ctx, x, y, r, k, col, seed, n)
static func speed(ctx: Ctx, x: float, y: float, dx: float, dy: float, len: float, spread: float, k: float, col, seed: float, n := 4) -> void: BtMoves.speed(ctx, x, y, dx, dy, len, spread, k, col, seed, n)
static func txt(ctx: Ctx, S: Dictionary, x: float, y: float, s: String, size: float, col = null, al = null, rot := 0.0) -> void:
	s = J.str(DB.L(s))
	if al != null and float(al) <= 0: return
	ctx.save(); ctx.translate(x, y); ctx.scale(S.fw, 1)
	if rot != 0.0: ctx.rotate(rot)
	if al != null: ctx.globalAlpha *= cl(float(al))
	ctx.font = "900 %dpx sans-serif" % maxi(1, int(round(size))); ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineJoin = "round"; ctx.lineWidth = maxf(2, size * 0.22); ctx.strokeStyle = Color(26 / 255.0, 20 / 255.0, 38 / 255.0, 0.92); ctx.strokeText(s, 0, 0)
	ctx.fillStyle = col if col != null else Color("#fff3d6"); ctx.fillText(s, 0, 0); ctx.restore()
static func pop(ctx: Ctx, S: Dictionary, x: float, y: float, s: String, size: float, col, t0: float, dur: float) -> void:
	var p = (S.tt - t0) / dur
	if p < 0 or p > 1: return
	var z = 0.4 + p / 0.15 * 0.75 if p < 0.15 else (1.15 - (p - 0.15) / 0.1 * 0.15 if p < 0.25 else 1.0)
	ctx.save(); ctx.translate(x, y - p * 0.08 * S.H); ctx.scale(z, z); txt(ctx, S, 0, 0, s, size, col, (1 - p) / 0.25 if p > 0.75 else 1.0, (rnd(s.length()) - 0.5) * 0.25); ctx.restore()
static func puff(ctx: Ctx, x: float, y: float, r: float, k: float, col, seed: float, n := 5) -> void:
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= sin(k * PI) * 0.85
	for i in n:
		var an = rnd(seed + i) * 6.28; var d = r * (0.3 + k) * rnd(seed + i + 3); var rr = r * (0.35 + 0.4 * rnd(seed + i + 7)) * (0.6 + k)
		ctx.fillStyle = col; ctx.beginPath(); ctx.arc(x + cos(an) * d, y + sin(an) * d * 0.6 - k * r * 0.5, rr, 0, 7); ctx.fill()
		ctx.strokeStyle = Color(60 / 255.0, 50 / 255.0, 70 / 255.0, 0.35); ctx.lineWidth = maxf(0.6, r * 0.05); ctx.stroke()
	ctx.restore()
static func drops(ctx: Ctx, x: float, y: float, r: float, k: float, col, seed: float, n := 7, up := 0.0) -> void:
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= 1 - k * 0.7
	for i in n:
		var an = -PI / 2 + (rnd(seed + i) - 0.5) * (up if up != 0.0 else 2.6); var sp = r * (0.6 + rnd(seed + i + 5)); var px = x + cos(an) * sp * k; var py = y + sin(an) * sp * k + r * 2.2 * k * k
		ctx.fillStyle = col; ctx.beginPath(); ctx.ellipse(px, py, r * 0.09, r * 0.13, an + PI / 2, 0, 7); ctx.fill(); ctx.strokeStyle = Color(30 / 255.0, 30 / 255.0, 50 / 255.0, 0.5); ctx.lineWidth = maxf(0.5, r * 0.025); ctx.stroke()
	ctx.restore()
static func stars(ctx: Ctx, x: float, y: float, r: float, t: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k)
	for i in 3:
		var an = t * 7 + i * 2.09; var px = x + cos(an) * r; var py = y + sin(an) * r * 0.35
		ctx.fillStyle = Color("#ffd84a"); ctx.strokeStyle = Color("#5a3a10"); ctx.lineWidth = maxf(0.6, r * 0.06); ctx.beginPath()
		for j in 10:
			var a2 = j * PI / 5 - PI / 2; var rr = r * 0.12 if j % 2 else r * 0.28; ctx.lineTo(px + cos(a2) * rr, py + sin(a2) * rr)
		ctx.closePath(); ctx.fill(); ctx.stroke()
	ctx.restore()
static func cracks(ctx: Ctx, x: float, y: float, r: float, k: float, seed: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k)
	for i in 6:
		var an = (i / 6.0) * TAU + rnd(seed + i); var pts = [Vector2(x, y)]; var px = x; var py = y
		for j in range(1, 4):
			px += cos(an + (rnd(seed + i * 3 + j) - 0.5)) * r * 0.33; py += sin(an + (rnd(seed + i * 3 + j) - 0.5)) * r * 0.12; pts.append(Vector2(px, py))
		crayon(ctx, pts, "rgba(40,28,22,.85)", maxf(1, r * 0.05), seed + i)
	ctx.restore()
static func ring(ctx: Ctx, x: float, y: float, rx: float, ry: float, col, w: float, al: float) -> void:
	if al <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(al); ctx.strokeStyle = col; ctx.lineWidth = w; ctx.beginPath(); ctx.ellipse(x, y, maxf(0.1, rx), maxf(0.1, ry), 0, 0, 7); ctx.stroke(); ctx.restore()
static func tgt(S: Dictionary, f: float) -> Vector2: return Vector2(S.tx + S.back, S.ty - f * S.th)
# N30M.begin／end
static func begin(ctx: Ctx, S: Dictionary, sx := 0.0, sk = null) -> void:
	ctx.save(); BtMoves.enter(ctx, S); BtMoves.shadow(ctx, S, sx, 0, sk)
static func end(ctx: Ctx) -> void: ctx.restore()

# ---------- 拆件身體：原圖 − 件（件範圍挖走）＋ 補丁（n30_rigs.js cutBody） ----------
static var _cut := {}
static func nb(id: String):
	if _cut.has(id): return _cut[id]
	var key = null
	var d = J.gp(J.gp(J.G.get("N30"), "DEF"), id.substr(4))
	if d is Dictionary and d.get("cut") is Array: key = cut_body(id, d.cut, id + "__nb")
	_cut[id] = key
	return key

static func cut_body(id: String, pieces: Array, key: String):
	if Spr._tex.has(key): return key
	if not Spr.ok(id): return null
	for p in pieces: if not Spr.ok(id + "__" + J.str(p)): return null
	var img: Image = Spr.get_tex(id).get_image()
	if img == null: return null
	if img.is_compressed(): img.decompress()
	img.convert(Image.FORMAT_RGBA8)
	var w = img.get_width(); var h = img.get_height()
	var mask = PackedFloat32Array(); mask.resize(w * h)
	for p in pieces:
		var pi_: Image = Spr.get_tex(id + "__" + J.str(p)).get_image()
		if pi_.is_compressed(): pi_.decompress()
		pi_.convert(Image.FORMAT_RGBA8)
		if pi_.get_width() != w or pi_.get_height() != h: pi_.resize(w, h, Image.INTERPOLATE_BILINEAR)
		var pd = pi_.get_data()
		for i in w * h:
			var m = pd[i * 4 + 3]
			if m > mask[i]: mask[i] = m
	var data = img.get_data()
	for i in w * h:
		var m = mask[i]
		if m > 8: data[i * 4 + 3] = 0
		elif m > 0: data[i * 4 + 3] = int(data[i * 4 + 3] * (1 - m / 8.0))
	var out = Image.create_from_data(w, h, false, Image.FORMAT_RGBA8, data)
	if Spr.ok(id + "__fill"):
		var fi: Image = Spr.get_tex(id + "__fill").get_image()
		if fi.is_compressed(): fi.decompress()
		fi.convert(Image.FORMAT_RGBA8)
		if fi.get_width() != w or fi.get_height() != h: fi.resize(w, h, Image.INTERPOLATE_BILINEAR)
		fi.blend_rect(out, Rect2i(0, 0, w, h), Vector2i.ZERO); out = fi
	Spr._tex[key] = ImageTexture.create_from_image(out)
	if MeshAnim.RIG.has(id): MeshAnim.RIG[key] = MeshAnim.RIG[id]
	return key
