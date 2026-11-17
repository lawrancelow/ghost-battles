# 主線戰鬥（原生）：專屬招式（MOVES）逐招移植——數值、時序照 moves_*.js／n30_moves.js
#  Kit = MoveKit（moves_chain.js）；矩陣 M 用 Transform2D（m.t(x,y) = m * mt(x,y)）
#  draw() 回 false = 呢隻未移植，照叫 JS ART.drawChar
class_name BtMoves

const D := PI / 180.0
# 戰鬥節奏（battle.js）：蓄力 0.22 → 出手 0.12（第 0.42 命中）→ 收招 0.25
const TW := 0.22
const TS := 0.12
const TR := 0.25
const TC := TW + 0.42 * TS
const TE := TW + TS + TR

static var FN := {}           # id → Callable(ctx, a) -> bool
static var _init_done := false

static func _setup_table() -> void:
	if _init_done: return
	_init_done = true
	FN["eguiking"] = mv_eguiking
	FN["egui"] = mv_egui
	FN["xiaogui"] = mv_xiaogui
	FN["laojiang"] = mv_jiangshi
	FN["zombie"] = mv_jiangshi
	for tb in [BtMoves2.table(), preload("res://game/battle/bt_moves3.gd").table(), BtN30a.table(), BtN30b.table(), BtN30c.table(), BtN30d.table()]:
		for k in tb: FN[k] = tb[k]

static func has(k: String) -> bool:
	_setup_table(); return FN.has(k)

# art.js drawMesh 嘅 MOVES 分支；未移植回 false；移植咗但唔接手（缺圖）就用原生 Art 照一般畫法
static func draw(ctx: Ctx, k: String, x: float, y: float, s: float, o: Dictionary) -> bool:
	_setup_table()
	if not FN.has(k): return false
	var ch = Art.char_h(k)
	if k.begins_with("n30_"): BtN30.ensure_rig(k)
	if ch <= 0 or not MeshAnim.has(k) or (Art.SPECIAL_T.has(k) and Art.has_spr(k)):
		Art.draw_char(ctx, k, x, y, s, o.duplicate()); return true
	var solid = Art.SOLID.has(k) or J.t(J.gp(J.gp(J.G.get("ART"), "SOLID"), k))
	var a = {"type": k, "x": x, "y": y, "s": s, "H": ch * s, "o": o, "faceRight": not J.t(o.get("flip")), "solid": solid}
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = float(o.alpha)
	var done = FN[k].call(ctx, a)
	ctx.restore()
	if done == false: Art.draw_char_after_moves(ctx, k, x, y, s, o.duplicate())   # 唔接手：照 art.js 由 MOVES 之後繼續（唔再入 MOVES）
	return true

# ---------------- 數學 ----------------
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func eo(t: float) -> float: return 1 - (1 - t) * (1 - t)
static func ei(t: float) -> float: return t * t
static func eio(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func eo3(t: float) -> float: return 1 - pow(1 - t, 3)
static func ei3(t: float) -> float: return t * t * t
static func esin(t: float) -> float: return 0.5 - 0.5 * cos(PI * t)
static func eback(t: float) -> float:
	var c = 1.6; return 1 + (c + 1) * pow(t - 1, 3) + c * pow(t - 1, 2)
static func seg(t: float, a: float, b: float) -> float: return cl((t - a) / (b - a))
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func rnd(i: float) -> float:
	var v = sin(i * 127.1 + 311.7) * 43758.5453; return v - floor(v)
static func mt(x: float, y: float) -> Transform2D: return Transform2D(0.0, Vector2(x, y))
static func mr(an: float) -> Transform2D: return Transform2D(an, Vector2.ZERO)
static func sc(x: float, y = null) -> Transform2D: return Transform2D(Vector2(x, 0), Vector2(0, x if y == null else float(y)), Vector2.ZERO)
static func mset(ctx: Ctx, m: Transform2D) -> void: ctx.transform(m.x.x, m.x.y, m.y.x, m.y.y, m.origin.x, m.origin.y)

static func tau(o: Dictionary) -> float:
	var p = cl(J.num(o.get("pt", 0)))
	match o.get("pose"):
		"windup": return p * TW
		"strike": return TW + p * TS
		"follow": return TW + (0.42 + 0.58 * p) * TS
		"recover": return TW + TS + p * TR
	return 0.0

static func _eoc(q: float) -> float: return 1 - pow(1 - cl(q), 3)
static func _ioc(q: float) -> float:
	q = cl(q); return 4 * q * q * q if q < 0.5 else 1 - pow(-2 * q + 2, 3) / 2
static func lunge_of(o: Dictionary, s: float) -> float:
	if o.get("tdx") == null: return 0.0
	var p = cl(J.num(o.get("pt", 0))); var L = 12.0 if s > 1.5 else (6.0 if s < 1 else 9.0)
	match o.get("pose"):
		"windup": return -2 * _eoc(p)
		"strike": return L * _eoc(p * 2.4)
		"follow": return L
		"recover": return L * (1 - _ioc(p))
	return 0.0

static func tgt_back(tt: float, th: float) -> float:
	var p = (tt - TC) / 0.3
	if p <= 0: return 0.0
	var kb = 0.0
	if p < 1: kb = (1 - pow(1 - p / 0.25, 3)) if p < 0.25 else 1 - _ioc((p - 0.25) / 0.75)
	var p2 = (tt - TC) / 0.25; var k = 0.0 if p2 >= 1 else (p2 / 0.15 if p2 < 0.15 else maxf(0, 1 - (p2 - 0.15) / 0.85))
	return kb * 9 + 0.07 * th * k

static func ok(k: String) -> bool: return Spr.ok(k)

# ---------------- MoveKit ----------------
static func setup(a: Dictionary):
	var id: String = a.type; var o: Dictionary = a.o
	if not ok(id + "__body") or not ok(id + "__arm") or not Limbs.CH.has(id): return null
	var img = Spr.get_tex(id + "__body")
	var C: Dictionary = Limbs.CH[id]
	var fw = 1.0 if a.faceRight else -1.0; var s: float = a.s; var H: float = a.H; var W = H * img.get_width() / img.get_height()
	var nr = MeshAnim.NATIVE_R.has(id) or J.t(C.get("nativeR"))
	var tt = tau(o); var lg = lunge_of(o, s); var th = 58 * s
	var tx = (J.num(o.tdx) * fw if o.get("tdx") != null else 44 * s) - lg; var ty = J.num(o.get("tdy", 0))
	var fl = 0.0 if a.solid else (3 + sin(J.num(o.get("t", 0)) * 2.4) * 2) * s
	return {"a": a, "id": id, "o": o, "fw": fw, "s": s, "H": H, "W": W, "nr": nr, "tt": tt, "tx": tx, "ty": ty, "th": th, "fl": fl, "t": J.num(o.get("t", 0)), "C": C, "solid": a.solid}

static func enter(ctx: Ctx, K: Dictionary) -> void: ctx.translate(K.a.x, K.a.y); ctx.scale(K.fw, 1)
static func ip(K: Dictionary, u: float, v: float) -> Vector2: return Vector2((1.0 if K.nr else -1.0) * (u - 0.5) * K.W, (v - 1) * K.H)
const KEEP := {"y": 1, "sx": 1, "sy": 1}
static func pose(K: Dictionary, extra = null, idleK = null) -> Dictionary:
	var z = MeshAnim.idle(K.t)
	if idleK != null:
		var ik = float(idleK)
		for k in z: if z[k] is float: z[k] = 1 + (z[k] - 1) * ik if (k == "sx" or k == "sy") else z[k] * ik
	z.armF = 0.0; z.axe = 0.0; z.body = 0.0; z.x = 0.0
	if K.C.get("still") != null:
		for b in K.C.still: z[b] = 0.0
	if extra != null:
		for k in extra:
			var v = float(extra[k])
			z[k] = (float(z.get(k, 0.0)) + v if k == "y" else v) if KEEP.has(k) else float(z.get(k, 0.0)) + (v if K.nr else -v)
	return z
# 畫身體：同網頁版一樣經全局 MeshAnim.drawBody（網頁骨架；core MeshAnim 嘅 DB 骨架係舊資料，會偏 2px 左右）
static func mesh_body(ctx: Ctx, rig_id: String, key: String, h: float, mp: Dictionary) -> void:
	var JM = J.G.get("MeshAnim")
	if JM is Dictionary and JM.get("drawBody") != null: J.mc(JM, "drawBody", [ctx, rig_id, key, h, mp])
	else: MeshAnim.draw_body(ctx, rig_id, key, h, mp)

static func body(ctx: Ctx, K: Dictionary, m: Transform2D, mp: Dictionary, key := "") -> void:
	ctx.save(); mset(ctx, m)
	if not K.nr: ctx.scale(-1, 1)
	mesh_body(ctx, K.id, key if key != "" else K.id + "__body", K.H, mp); ctx.restore()
static func piece(ctx: Ctx, K: Dictionary, key: String, m: Transform2D, pu: float, pv: float, alpha = null) -> void:
	var tex = Spr.get_tex(key) if ok(key) else null
	if tex == null: return
	ctx.save(); mset(ctx, m)
	if not K.nr: ctx.scale(-1, 1)
	if alpha != null: ctx.globalAlpha *= float(alpha)
	ctx.drawImage(tex, -pu * K.W, -pv * K.H, K.W, K.H); ctx.restore()
static func ppt(K: Dictionary, m: Transform2D, pu: float, pv: float, u: float, v: float) -> Vector2:
	return m * Vector2((1.0 if K.nr else -1.0) * (u - pu) * K.W, (v - pv) * K.H)
static func shadow(ctx: Ctx, K: Dictionary, x: float, y: float, k = null) -> void:
	if K.o.get("shadow") == false: return
	ctx.save()
	if not K.solid: ctx.globalAlpha *= 0.55
	var kk = float(k) if k != null and float(k) != 0.0 else (1.0 if K.solid else 0.8)
	ctx.fillStyle = Color(0, 0, 0, 0.35); ctx.beginPath(); ctx.ellipse(x, y + K.s, 14 * K.s * kk, 4 * K.s * kk, 0, 0, 7); ctx.fill(); ctx.restore()
static func tgt_body(K: Dictionary, back := 0.0) -> Dictionary: return {"x": K.tx + back, "y": K.ty - 0.5 * K.th, "rx": 0.25 * K.th, "ry": 0.5 * K.th}
static func clip_out(ctx: Ctx, e: Dictionary) -> void:
	ctx.beginPath(); ctx.rect(-5000, -5000, 10000, 10000); ctx.ellipse(e.x, e.y, e.rx, e.ry, 0, 0, 7); ctx.clip()

# ---------- 蠟筆風特效 ----------
static func crayon(ctx: Ctx, pts: Array, col, w: float, seed: float) -> void:
	if pts.size() < 2: return
	ctx.save(); ctx.lineCap = "round"; ctx.lineJoin = "round"; ctx.strokeStyle = col
	for pass_ in 2:
		ctx.globalAlpha *= 0.55 if pass_ else 1.0; ctx.lineWidth = w * (0.55 if pass_ else 1.0); ctx.beginPath()
		for i in pts.size():
			var p = pts[i]; var j = (rnd(seed + i * 7 + pass_ * 31) - 0.5) * w * 0.5
			if i: ctx.lineTo(p.x + j, p.y - j)
			else: ctx.moveTo(p.x + j, p.y + j)
		ctx.stroke()
	ctx.restore()
static func burst(ctx: Ctx, x: float, y: float, r: float, k: float, col, seed: float, n := 9) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k)
	for i in n:
		var an = float(i) / n * 6.283 + rnd(seed + i) * 0.5; var r0 = r * (0.25 + 0.35 * (1 - k)); var r1 = r * (0.7 + 0.5 * rnd(seed + i + 9)) * (1.2 - 0.4 * k)
		crayon(ctx, [Vector2(x + cos(an) * r0, y + sin(an) * r0), Vector2(x + cos(an) * r1, y + sin(an) * r1)], col, maxf(1, r * 0.09), seed + i)
	ctx.restore()
static func speed(ctx: Ctx, x: float, y: float, dx: float, dy: float, len: float, spread: float, k: float, col, seed: float, n := 4) -> void:
	if k <= 0: return
	var l = Vector2(dx, dy).length(); if l == 0: l = 1.0
	var ux = dx / l; var uy = dy / l
	ctx.save(); ctx.globalAlpha *= cl(k)
	for i in n:
		var o = (i - (n - 1) / 2.0) * spread / n + (rnd(seed + i) - 0.5) * spread * 0.2; var L = len * (0.6 + 0.4 * rnd(seed + i + 4)); var b = len * 0.3 * rnd(seed + i + 8)
		var px = x - uy * o - ux * b; var py = y + ux * o - uy * b
		crayon(ctx, [Vector2(px, py), Vector2(px - ux * L, py - uy * L)], col, maxf(1, len * 0.06), seed + i)
	ctx.restore()

# =================================================================
# 餓鬼王：丟包子
static func mv_eguiking(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null or not ok("eguiking__bun") or not ok("eguiking__hand"): return false
	var tt: float = S.tt; var H: float = S.H; var th: float = S.th
	var PV: Array = S.C.pivot; var BC = [0.1329, 0.2928]; var REL = 0.145
	var rig = func(t: float) -> Dictionary:
		var kB = eo(seg(t, 0, 0.11)); var kT = ei(seg(t, 0.11, 0.18)); var kF = eo(seg(t, 0.20, 0.30)); var kG = eio(seg(t, 0.34, 0.44)); var kU = eio(seg(t, 0.44, 0.59))
		var lean = -10 * kB; var bdx = -0.035 * kB; var rot = -32 * kB; var wx = -0.02 * kB; var wy = -0.045 * kB; var head = -0.10 * kB
		lean = lerp_(lean, 10, kT); bdx = lerp_(bdx, 0.045, kT); rot = lerp_(rot, 95, kT); wx = lerp_(wx, 0.015, kT); wy = lerp_(wy, 0, kT); head = lerp_(head, 0.10, kT)
		rot = lerp_(rot, 120, kF)
		lean = lerp_(lean, 3, kG); bdx = lerp_(bdx, 0.01, kG); rot = lerp_(rot, 172, kG); wx = lerp_(wx, 0.01, kG); wy = lerp_(wy, 0.01, kG); head = lerp_(head, 0.06, kG)
		lean *= 1 - kU; bdx *= 1 - kU; rot *= 1 - kU; wx *= 1 - kU; wy *= 1 - kU; head *= 1 - kU
		var bp = ip(S, 0.5, 0.8)
		var bm = mt(bdx * H, -S.fl) * mt(bp.x, bp.y) * mr(lean * D) * mt(-bp.x, -bp.y)
		var pv = ip(S, PV[0], PV[1])
		var hm = bm * mt(pv.x + wx * H, pv.y + wy * H) * mr(rot * D)
		return {"bm": bm, "hm": hm, "head": head, "behind": t > 0.37 and t < 0.455}
	var R = rig.call(tt)
	var back = tgt_back(tt, th)
	var Tp = Vector2(S.tx - 0.06 * th, S.ty - 0.80 * th)
	var R0 = ppt(S, rig.call(REL).hm, PV[0], PV[1], BC[0], BC[1])
	var sgn = 1.0 if S.nr else -1.0
	var bun_m = func(m: Transform2D, s_: float) -> Transform2D: return m * mt(sgn * (BC[0] - PV[0]) * S.W, (BC[1] - PV[1]) * S.H) * sc(s_)
	ctx.save(); enter(ctx, S)
	shadow(ctx, S, 0, 0)
	var grow = 1.0 if tt < REL else (0.0 if tt < 0.44 else eback(seg(tt, 0.44, 0.53)))
	var draw_hand = func():
		if grow > 0.01: piece(ctx, S, "eguiking__bun", bun_m.call(R.hm, grow), BC[0], BC[1])
		piece(ctx, S, "eguiking__hand", R.hm, PV[0], PV[1])
	if R.behind: draw_hand.call()
	body(ctx, S, R.bm, pose(S, {"head": R.head}))
	if not R.behind: draw_hand.call()
	if tt > 0.45 and tt < 0.59:
		var c = ppt(S, R.hm, PV[0], PV[1], BC[0], BC[1]); _steam(ctx, c.x, c.y - 0.05 * H, 0.10 * H, seg(tt, 0.45, 0.59), 5)
	var bun_piece = func(x: float, y: float, rot: float, sx: float, sy: float, al = null):
		piece(ctx, S, "eguiking__bun", mt(x, y) * mr(rot) * sc(sx, sy), BC[0], BC[1], al)
	if tt >= REL and tt < TC:
		var sq = seg(tt, REL, TC); var q = esin(sq) * 0.3 + sq * 0.7; var x = lerp_(R0.x, Tp.x, q); var y = lerp_(R0.y, Tp.y, q) - 0.42 * H * 4 * q * (1 - q)
		var q2 = maxf(0, q - 0.12); var x2 = lerp_(R0.x, Tp.x, q2); var y2 = lerp_(R0.y, Tp.y, q2) - 0.42 * H * 4 * q2 * (1 - q2)
		speed(ctx, x, y, x - x2, y - y2, 0.13 * H, 0.07 * H, 0.9, "rgba(255,248,230,.75)", 7, 3)
		bun_piece.call(x, y, q * 7.5, 1.0, 1.0)
	elif tt >= TC and tt < 0.47:
		var p = tt - TC; var bx = Tp.x + back
		if p < 0.035:
			var k = sin(p / 0.035 * PI * 0.5); bun_piece.call(bx, Tp.y + 0.02 * H * k, 0.0, 1 + 0.32 * k, 1 - 0.45 * k)
		else:
			var q = p - 0.035
			bun_piece.call(bx - q * 0.35 * H, Tp.y + 0.02 * H + q * q * 9 * H - q * 0.5 * H, -q * 9, 1.32 - minf(0.3, q * 3), 0.55 + minf(0.4, q * 4), 1 - seg(tt, 0.40, 0.47))
		var k = 1 - seg(tt, TC + 0.15, TC + 0.26)
		ctx.save(); ctx.globalAlpha *= k
		ctx.strokeStyle = Color(90 / 255.0, 60 / 255.0, 40 / 255.0, 0.7); ctx.lineWidth = 0.5
		for i in 14:
			var an = -2.7 + rnd(i) * 3.6; var sp = (0.5 + rnd(i + 30)) * 1.25 * H; var px = bx + cos(an) * sp * p - 0.15 * H * p; var py = Tp.y + sin(an) * sp * p + 2.6 * H * p * p
			ctx.fillStyle = Color("#8a5a3a") if i % 4 == 3 else (Color("#f6ead6") if i % 2 else Color("#eedcc0"))
			ctx.beginPath(); ctx.ellipse(px, py, 0.014 * H * (1 + rnd(i + 5)), 0.01 * H * (1 + rnd(i + 6)), i, 0, 7); ctx.fill(); ctx.stroke()
		ctx.restore()
		if p < 0.12: burst(ctx, bx, Tp.y, 0.17 * th, 1 - p / 0.12, "#fff3d6", 23, 10)
		_steam(ctx, bx, Tp.y - 0.04 * H, 0.16 * H, seg(tt, TC, 0.5), 17)
	ctx.restore()
	return true

static func _steam(ctx: Ctx, x: float, y: float, h: float, q: float, seed: float) -> void:
	if q <= 0 or q >= 1: return
	var al = sin(q * PI) * 0.8
	for i in 3:
		var ox = (i - 1) * h * 0.28; var pts = []
		for j in 9:
			var f = j / 8.0; pts.append(Vector2(x + ox + sin(f * 6 + i * 2 + q * 8) * h * 0.08 * (0.4 + f), y - f * h * (0.5 + q * 0.7) - q * h * 0.3))
		ctx.save(); ctx.globalAlpha *= al * (0.6 + 0.4 * rnd(seed + i)); crayon(ctx, pts, "rgba(250,250,250,.85)", h * 0.07, seed + i * 5); ctx.restore()

# 餓鬼：撲上去咬
static func mv_egui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var tt: float = S.tt; var H: float = S.H; var th: float = S.th
	var PV: Array = S.C.pivot; var MO = [0.76, 0.27]; var CH = [TC, 0.315, 0.36]
	var back = tgt_back(tt, th)
	var Bp = Vector2(S.tx - 0.12 * th, S.ty - 0.70 * th)
	var rig = func(t: float, dx: float, dy: float) -> Dictionary:
		var kC = eo(seg(t, 0, 0.15)); var kL = ei(seg(t, 0.15, TC)); var kO = eio(seg(t, 0.40, 0.59))
		var lean = -14 * kC; var hr = -38 * kC; var hs = 1.0
		lean = lerp_(lean, 16, kL); hr = lerp_(hr, 14, kL)
		var chomp = 0.0
		for c in CH:
			var p = (t - c) / 0.045
			if p >= 0 and p < 1: chomp = maxf(chomp, sin(p * PI))
		var shakeA = sin((t - TC) * 95) * 7 * (1 - seg(t, 0.36, 0.40)) if t > TC and t < 0.40 else 0.0
		hr += chomp * 12 + shakeA; hs = 1 - 0.09 * chomp
		lean *= 1 - kO; hr *= 1 - kO
		var bp = ip(S, 0.5, 0.85)
		var bm = mt(dx, dy - S.fl) * mt(bp.x, bp.y) * mr(lean * D) * mt(-bp.x, -bp.y) * mt(bp.x, bp.y) * sc(1 - 0.05 * kC + 0.04 * kL * (1 - kO), 1 + 0.06 * kC - 0.05 * kL * (1 - kO)) * mt(-bp.x, -bp.y)
		var pv = ip(S, PV[0], PV[1])
		var hm = bm * mt(pv.x, pv.y + 0.015 * H * chomp) * mr(hr * D) * sc(1 + 0.05 * chomp, hs)
		return {"bm": bm, "hm": hm, "chomp": chomp}
	var m0 = rig.call(TC, 0.0, 0.0); var mo = ppt(S, m0.hm, PV[0], PV[1], MO[0], MO[1])
	var Dx = maxf(0, Bp.x - mo.x); var Dy = Bp.y - mo.y
	var dx: float; var dy: float
	if tt < 0.15:
		var k = eo(seg(tt, 0, 0.15)); dx = -0.07 * H * k; dy = 0.01 * H * k
	elif tt < TC:
		var q = ei(seg(tt, 0.15, TC)); dx = lerp_(-0.07 * H, Dx, q); dy = lerp_(0.01 * H, Dy, q) - 0.10 * H * sin(q * PI)
	elif tt < 0.40: dx = Dx + back + sin(tt * 120) * 0.006 * H; dy = Dy
	else:
		var q = eio(seg(tt, 0.40, 0.59)); dx = lerp_(Dx + back, 0, q); dy = lerp_(Dy, 0, q) - 0.12 * H * sin(q * PI)
	var R = rig.call(tt, dx, dy)
	ctx.save(); enter(ctx, S)
	shadow(ctx, S, dx, 0, 0.8 - 0.15 * minf(1, maxf(0, -dy) / (0.15 * H)))
	if tt > 0.15 and tt < TC: speed(ctx, dx - 0.15 * S.W, -0.55 * H + dy, 1, 0.1, 0.22 * H, 0.35 * H, seg(tt, 0.15, 0.22), "rgba(235,245,225,.6)", 3, 4)
	var tk = seg(tt, 0.15, 0.27) * (1 - seg(tt, 0.4, 0.59))
	body(ctx, S, R.bm, pose(S, {"tail1": -0.25 * tk, "tail2": -0.35 * tk}))
	piece(ctx, S, "egui__arm", R.hm, PV[0], PV[1])
	var bx = Bp.x + back; var by = Bp.y
	for i in CH.size():
		var p = (tt - CH[i]) / 0.06
		if p < 0 or p > 1: continue
		var close = minf(1, p * 2.2); var al = 1 - maxf(0, p - 0.5) * 2; var w = 0.20 * th; var gap = 0.08 * th * (1 - close) + 0.012 * th
		for sg in [-1, 1]:
			var pts = []
			for j in 7: pts.append(Vector2(bx - w / 2 + j * w / 6 + sg * 0.01 * th, by + sg * gap + (-sg if j % 2 else 0) * 0.035 * th))
			ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, "#fffaf0", 0.022 * th, 50 + i * 9 + sg); ctx.restore()
		if i == 0: burst(ctx, bx, by, 0.2 * th, 1 - p, "#ffe9c8", 61, 9)
		else: burst(ctx, bx, by, 0.13 * th, (1 - p) * 0.8, "#ffd6c8", 61 + i, 6)
	if tt > TC and tt < 0.55:
		var k = 1 - seg(tt, 0.42, 0.55); ctx.save(); ctx.globalAlpha *= k * 0.9
		for sg in [-1, 1]:
			for j in 4:
				var x = bx - 0.06 * th + j * 0.04 * th; var y = by + sg * 0.03 * th
				crayon(ctx, [Vector2(x - 0.012 * th, y), Vector2(x, y + sg * 0.014 * th), Vector2(x + 0.012 * th, y)], "#a23a3a", 0.012 * th, 80 + j + sg)
		ctx.restore()
	ctx.restore()
	return true

# 小鬼：飛過去繞一圈抓
static func mv_xiaogui(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var tt: float = S.tt; var H: float = S.H; var th: float = S.th
	var PV: Array = S.C.pivot; var BC = [0.45, 0.52]
	var bc0 = ip(S, BC[0], BC[1])
	var back = tgt_back(tt, th)
	var cx = S.tx + back; var cy = S.ty - 0.55 * th; var Rx = 0.46 * th; var Ry = 0.13 * th
	var home = Vector2(bc0.x, bc0.y - S.fl)
	var at = func(t: float) -> Array:   # [p, ph or null]
		if t < 0.08:
			var k = eo(seg(t, 0, 0.08)); return [Vector2(home.x - 0.06 * H * k, home.y + 0.02 * H * k), null]
		if t < 0.15:
			var q = eio(seg(t, 0.08, 0.15)); var e = Vector2(cx - Rx, cy)
			return [Vector2(lerp_(home.x - 0.06 * H, e.x, q), lerp_(home.y + 0.02 * H, e.y, q) - 0.08 * H * sin(q * PI)), null]
		if t < 0.33:
			var ph = lerp_(PI, 2.5 * PI, esin(seg(t, 0.15, TC)) * 0.15 + seg(t, 0.15, TC) * 0.85) if t < TC else lerp_(2.5 * PI, 3 * PI, eo(seg(t, TC, 0.33)))
			return [Vector2(cx + cos(ph) * Rx, cy + sin(ph) * Ry), ph]
		var q = eio(seg(t, 0.33, 0.59)); var s0 = Vector2(cx - Rx, cy)
		return [Vector2(lerp_(s0.x, home.x, q), lerp_(s0.y, home.y, q) - 0.10 * H * sin(q * PI)), null]
	var A = at.call(tt); var A2 = at.call(maxf(0, tt - 0.012)); var vx = A[0].x - A2[0].x; var vy = A[0].y - A2[0].y
	var ph = A[1]
	var face = 1.0
	if ph != null:
		var sg = -sin(ph); face = clampf(sg * 3.2, -1, 1)
		if absf(face) < 0.15: face = 0.15 * (1.0 if sg >= 0 else -1.0)
	var depth = sin(ph) if ph != null else 0.0; var scl = 1 + 0.10 * depth
	var hidden = ph != null and depth < -0.15
	var sgf = signf(face) if face != 0 else 1.0
	var bank = clampf(vx / (0.05 * H), -1, 1) * 14 * sgf
	var kU = eo(seg(tt, 0.20, 0.255)); var kS = ei(seg(tt, 0.255, TC)); var kF = eo(seg(tt, TC, 0.31)); var kR = eio(seg(tt, 0.31, 0.40))
	var crot = lerp_(0, -70, kU); crot = lerp_(crot, 35, kS); crot = lerp_(crot, 75, kF); crot *= 1 - kR
	if tt < 0.08: crot = -20 * eo(seg(tt, 0, 0.08))
	elif tt < 0.20: crot = lerp_(-20, 0, seg(tt, 0.08, 0.2))
	var m = mt(A[0].x, A[0].y) * sc(face * scl, scl) * mr((bank + (-8 * eo(seg(tt, 0, 0.08)) if tt < 0.08 else 0.0)) * D) * mt(-bc0.x, -bc0.y)
	var pv = ip(S, PV[0], PV[1])
	var cm = m * mt(pv.x, pv.y) * mr(crot * D)
	var vxl = vx * sgf
	var tail = clampf(-vxl / (0.04 * H), -1, 1)
	ctx.save(); enter(ctx, S)
	var den = cx - Rx - home.x
	var trav = cl((A[0].x - home.x) / (den if den != 0 else 1.0))
	shadow(ctx, S, A[0].x - bc0.x, S.ty * trav + (sin(ph) * Ry if ph != null else 0.0), 0.8 * scl)
	ctx.save(); ctx.globalAlpha *= 0.5
	if hidden: clip_out(ctx, tgt_body(S, back))
	if tt > 0.08 and tt < 0.5:
		for w in 3:
			for i in 7:
				var q0 = at.call(maxf(0, tt - 0.01 - i * 0.007))[0]; var q1 = at.call(maxf(0, tt - 0.01 - (i + 1) * 0.007))[0]; var o = (w - 1) * 0.07 * H; var yo = (0.18 + 0.05 * w) * H
				ctx.save(); ctx.globalAlpha *= (1 - i / 7.0) * 0.7; crayon(ctx, [Vector2(q0.x, q0.y + yo + o * 0.3), Vector2(q1.x, q1.y + yo + o * 0.3)], "#e6f7ee", 0.018 * H * (1 - i / 9.0), 9 + w * 13 + i); ctx.restore()
	ctx.restore()
	ctx.save()
	if hidden: clip_out(ctx, tgt_body(S, back))
	body(ctx, S, m, pose(S, {"tail1": 0.45 * tail, "tail2": 0.7 * tail, "body": 0}))
	piece(ctx, S, "xiaogui__arm", cm, PV[0], PV[1])
	ctx.restore()
	var hx = cx; var hy = cy
	if tt > 0.255 and tt < 0.45:
		var p = seg(tt, 0.255, 0.30); var k = 1 - seg(tt, 0.34, 0.45)
		ctx.save(); ctx.globalAlpha *= k
		for i in 3:
			var o = (i - 1) * 0.07 * th; var pts = []
			for j in 7:
				var f = j / 6.0 * p; pts.append(Vector2(hx + 0.16 * th - f * 0.30 * th + o * 0.4, hy - 0.16 * th + o + f * 0.30 * th))
			crayon(ctx, pts, "#6e1820", 0.042 * th * (1 - 0.3 * absf(i - 1)), 70 + i)
			crayon(ctx, pts, "#fff6ea" if i == 1 else "#ffd0c4", 0.022 * th * (1 - 0.3 * absf(i - 1)), 90 + i)
		ctx.restore()
	var hk = 1 - seg(tt, TC, TC + 0.12)
	if tt >= TC and hk > 0: burst(ctx, hx, hy, 0.2 * th, hk, "#f2fff0", 33, 9)
	if tt > 0.08 and tt < 0.15: speed(ctx, A[0].x - 0.1 * H, A[0].y, vx, vy, 0.2 * H, 0.25 * H, 0.8, "rgba(225,245,235,.7)", 5, 4)
	ctx.restore()
	return true

# 老殭、殭屍兵：跳過去、雙手一戳
const HOPS := [[0, 0.03, 0.11, 0.13, 0, 0.5, 0.20], [0.13, 0.155, 0.25, 0.2704, 0.5, 1, 0.16], [0.355, 0.375, 0.455, 0.47, 1, 0.45, 0.14], [0.47, 0.49, 0.565, 0.59, 0.45, 0, 0.12]]
static func mv_jiangshi(ctx: Ctx, a: Dictionary) -> bool:
	var S = setup(a)
	if S == null: return false
	var tt: float = S.tt; var H: float = S.H; var th: float = S.th
	var PV: Array = S.C.pivot; var TIP: Array = S.C.tip
	var tip0 = ip(S, TIP[0], TIP[1])
	var EXT = 0.17 * S.W
	var Jx = S.tx - 0.06 * th
	var Dx = maxf(-0.04 * H, Jx - (tip0.x + EXT + 0.04 * H)); var Dy: float = S.ty
	var f = 0.0 if tt < 0.13 else ((0.5 if tt < 0.2704 else 1.0) if tt < 0.355 else (1.0 if tt < 0.47 else (0.45 if tt < 0.59 else 0.0)))
	var hy = 0.0; var sx = 1.0; var sy = 1.0
	for hp in HOPS:
		var t0: float = hp[0]; var t1: float = hp[1]; var t2: float = hp[2]; var t3: float = hp[3]; var f0: float = hp[4]; var f1: float = hp[5]; var hh: float = hp[6]
		if tt < t0 or tt >= t3: continue
		if tt < t1:
			var k = sin(seg(tt, t0, t1) * PI * 0.5); sx = 1 + 0.08 * k; sy = 1 - 0.10 * k; f = f0
		elif tt < t2:
			var q = seg(tt, t1, t2); f = lerp_(f0, f1, q); hy = -hh * H * 4 * q * (1 - q); var st = sin(q * PI); sx = 1 - 0.05 * st; sy = 1 + 0.07 * st
		else:
			var k = sin(seg(tt, t2, t3) * PI); sx = 1 + 0.09 * k; sy = 1 - 0.11 * k; f = f1
	var kJ = eo3(seg(tt, 0.235, TC)); var kH = 1 - eio(seg(tt, 0.33, 0.37))
	var jab = kJ * kH; var jit = sin(tt * 210) * 0.004 * H if tt > TC and tt < 0.33 else 0.0
	var lean = 7 * jab; var push = 0.03 * H * jab
	var dx = Dx * f + push + jit; var dy = Dy * f
	var stiff = 1 - seg(tt, 0, 0.04) * (1 - seg(tt, 0.55, 0.59))
	var bm = mt(dx, dy + hy) * mr(lean * D) * sc(sx, sy)
	var pv = ip(S, PV[0], PV[1])
	var am = bm * mt(pv.x + EXT * jab, pv.y - 0.01 * H * jab) * mr((-4 * jab + (-3.0 if hy < 0 else 0.0)) * D)
	ctx.save(); enter(ctx, S)
	shadow(ctx, S, dx, dy, 1 - 0.4 * minf(1, -hy / (0.2 * H)))
	if jab > 0.2:
		var tp0 = ppt(S, am, PV[0], PV[1], TIP[0], TIP[1]); speed(ctx, tp0.x - 0.08 * H, tp0.y, 1, 0, 0.18 * H, 0.10 * H, jab * (1 - seg(tt, 0.29, 0.33)), "rgba(240,235,220,.8)", 13, 3)
	body(ctx, S, bm, pose(S, null, stiff))
	piece(ctx, S, S.id + "__arm", am, PV[0], PV[1])
	var tp = ppt(S, am, PV[0], PV[1], TIP[0], TIP[1])
	var hk = 1 - seg(tt, TC, TC + 0.12)
	if tt >= TC and hk > 0: burst(ctx, tp.x + 0.02 * H, tp.y, 0.2 * th, hk, "#fff0c8", 44, 10)
	if tt >= TC - 0.01 and tt < 0.33:
		var k = seg(tt, TC - 0.01, 0.33); ctx.save(); ctx.globalAlpha *= 1 - k; ctx.strokeStyle = Color("#fff6dc"); ctx.lineWidth = 0.02 * th
		for o in [-0.07, 0.03]:
			ctx.beginPath(); ctx.ellipse(tp.x + 0.03 * H, tp.y + o * H, 0.03 * th + k * 0.12 * th, 0.08 * th + k * 0.1 * th, 0, -1.2, 1.2); ctx.stroke()
		ctx.restore()
	if tt > 0.13 and tt < 0.25 and hy < -0.02 * H: speed(ctx, dx - 0.25 * S.W, dy + hy - 0.5 * H, 1, 0.3, 0.12 * H, 0.4 * H, 0.6, "rgba(230,225,215,.5)", 21, 3)
	ctx.restore()
	return true
