# 原生改寫自 daily_hero.js：阿福（主公）喺村入面嘅平日動作（行路張望、跳石頭、打呵欠、伸懶腰、抓頭、
# 不耐煩、擦汗、拍灰、砍完樹得意、插斧睇手機、插斧打瞌睡、被叫醒、企定）同小排程（HeroDaily.update／tap／opts）。
# 全部用原圖：身體 afu__body（MeshAnim 網格）、手 afu__arm、斧頭 afu__axe、手機 afu__phone／震動線 afu__ring；
# 口水泡、Zzz、汗、灰塵、字 = 程式畫嘅蠟筆筆觸。骨架矩陣原本係 DOMMatrix，呢度直接用 Transform2D（同一套數）。
# 座標：一律以「面朝左」為準；th 正 = 手往後上方舉，lean 正 = 後仰，dx 正 = 往前，dy 正 = 往下。
extends RefCounted

const D := PI / 180
const FONTF := "px \"PingFang TC\",\"Noto Sans TC\",\"Noto Sans CJK TC\",sans-serif"
const F := ["dx", "dy", "lean", "sx", "sy", "th", "hx", "hy", "wr", "slide", "head", "armB", "tie", "tail1", "tail2", "mb", "bob", "msy"]
const FIST := [0.245, 0.505]
const FACE := {"mouth": [0.51, 0.378], "nose": [0.49, 0.352], "brow": [0.42, 0.235], "eyeL": [0.40, 0.305], "eyeR": [0.59, 0.29], "top": [0.47, 0.06], "cheek": [0.36, 0.34], "pocket": [0.60, 0.56], "chest": [0.50, 0.58]}
const PLANT := {"th": -122.0, "lean": -17.0, "dx": 0.10, "dy": 0.03, "sx": 0.03, "sy": -0.04, "slide": 0.07, "wr": -6.0, "bob": -1.0, "head": -0.10}
const BLEND := 0.28
const NAMES := ["walk", "yawn", "stretch", "scratch", "tap", "sweat", "dust", "proud", "phone", "doze", "wake", "idle"]

static var MEM := {}
static var stones := {}
static var RB = null
static var LEN := {}
static var PICK := []
static var COOL := {}
static var Q := {}

# ---------------- 小工具 ----------------
static func _g(n: String): return J.G.get(n)
static func cl(v: float, a := 0.0, b := 1.0) -> float: return maxf(a, minf(b, v))
static func S(x: float) -> float: return sin(x)
static func ez(e, t: float) -> float:
	match e:
		"l": return t
		"i": return t * t
		"o": return 1 - (1 - t) * (1 - t)
		"o3": return 1 - pow(1 - t, 3)
		"i3": return t * t * t
		"back":
			var c1 = 1.70158; var c3 = c1 + 1
			return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2)
		"hold": return 0.0
	return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)   # io（預設）
static func ok(k: String) -> bool:
	var so = _g("sprOk")
	return so is Callable and J.t(J.cl(so, null, [k]))
static func spr(k: String): return J.gp(_g("SPR"), k)
static func nw(im) -> float: return J.num(J.gp(im, "naturalWidth"))
static func nh(im) -> float: return J.num(J.gp(im, "naturalHeight"))
static func LD(): return J.gp(J.gp(_g("LIMBS_DATA"), "chars"), "afu")
static func WP(): return J.gp(J.gp(_g("LIMBS_DATA"), "weapons"), "axe")
static func AXE(): return spr("afu__axe") if ok("afu__axe") else spr("afu__wpn")
static func v2(arr, i: int) -> float: return J.num(arr[i])
static func gv(P: Dictionary, k: String) -> float: return float(P.get(k, 0.0)) if P.get(k) != null else 0.0
static func hyp(x: float, y: float) -> float: return sqrt(x * x + y * y)
static func dirf(a: Dictionary) -> float: return 1.0 if J.t(a.get("faceRight")) else -1.0
# DOMMatrix 介面（新矩陣、角度）
static func mt(m: Transform2D, x: float, y: float) -> Transform2D: return m * Transform2D(0.0, Vector2(x, y))
static func mr(m: Transform2D, deg: float) -> Transform2D: return m * Transform2D(deg_to_rad(deg), Vector2.ZERO)
static func ms(m: Transform2D, sx: float, sy: float) -> Transform2D: return m * Transform2D(Vector2(sx, 0), Vector2(0, sy), Vector2.ZERO)

# ---------------- 姿勢 ----------------
static func Z() -> Dictionary:
	var o = {}
	for k in F: o[k] = 0.0
	return o
static func asg(base: Dictionary, add: Dictionary) -> Dictionary:
	var o = base.duplicate()
	for k in add: o[k] = add[k]
	return o
static func lerpP(a: Dictionary, b: Dictionary, k: float) -> Dictionary:
	var o = {}
	for n in F: o[n] = gv(a, n) + (gv(b, n) - gv(a, n)) * k
	return o
static func addP(a: Dictionary, b: Dictionary) -> Dictionary:
	var o = a.duplicate()
	for n in F: o[n] = gv(a, n) + gv(b, n)
	return o
static func track(at: float, keys: Array) -> Dictionary:
	if at <= keys[0][0]: return asg(Z(), keys[0][1])
	for i in range(1, keys.size()):
		var t1: float = keys[i][0]; var v1: Dictionary = keys[i][1]; var e = keys[i][2] if keys[i].size() > 2 else null
		var t0: float = keys[i - 1][0]; var v0: Dictionary = keys[i - 1][1]
		if at < t1:
			var k = ez(e if e != null and e != "" else "io", cl((at - t0) / (t1 - t0)))
			return lerpP(asg(Z(), v0), asg(Z(), v1), k)
	return asg(Z(), keys[keys.size() - 1][1])
static func seg(at: float, t0: float, t1: float) -> float: return cl((at - t0) / (t1 - t0))
static func bell(at: float, t0: float, t1: float) -> float:
	var k = seg(at, t0, t1)
	return 0.0 if k <= 0 or k >= 1 else sin(k * PI)
static func rest(t: float) -> Dictionary:
	return {"head": S(t * 1.3) * 0.05, "armB": S(t * 1.8 + 1) * 0.06, "tie": S(t * 5) * 0.18, "tail1": S(t * 2.6) * 0.12, "tail2": S(t * 2.6 - 1) * 0.22}

# ---------------- 骨架計算（只算矩陣）----------------
static func ground(a: Dictionary) -> Transform2D:
	var m = mt(Transform2D.IDENTITY, J.num(a.x), J.num(a.y))
	return ms(m, -1, 1) if J.t(a.get("faceRight")) else m
static func solveRig(a: Dictionary, P: Dictionary, t: float) -> Dictionary:
	var H = J.num(a.H); var b = spr("afu__body"); var W = H * nw(b) / nh(b); var c = LD()
	var bob = cl(1 + gv(P, "bob"), 0, 1)
	var fl = 0.0 if J.t(a.get("solid")) else (3 + S(t * 2.4) * 2 * bob) * J.num(a.s)
	var my = -0.03 - S(t * 2.2) * 0.02 * bob
	var G = ground(a)
	var Mb = ms(mt(mr(mt(mt(mt(G, 0, -fl), -gv(P, "dx") * H, gv(P, "dy") * H), 0, -H * 0.28), gv(P, "lean")), 0, H * 0.28), 1 + gv(P, "sx"), 1 + gv(P, "sy"))
	var th = gv(P, "th"); var lift = cl((th - 25) / 40, 0, 1)
	var pv = J.gp(c, "pivot"); var lf = J.gp(c, "lift"); var gp_ = J.gp(c, "grip")
	var px = (v2(pv, 0) - 0.5) * W; var py = -H + v2(pv, 1) * H + my * H
	var lx = px + (lift * v2(lf, 0) + gv(P, "hx")) * W; var ly = py - (lift * v2(lf, 1) + gv(P, "hy")) * H
	var Ma = mr(mt(Mb, lx, ly), th)
	var wp = WP(); var ww = J.num(J.gp(wp, "w")) * H; var wh = J.num(J.gp(wp, "h")) * H
	var tip = J.gp(wp, "tip"); var grip = J.gp(wp, "grip")
	var ax = (v2(tip, 0) - v2(grip, 0)) * ww; var ay = (v2(tip, 1) - v2(grip, 1)) * wh; var al = hyp(ax, ay)
	var sl = gv(P, "slide")
	var Mg = mt(mr(mt(Ma, (v2(gp_, 0) - v2(pv, 0)) * W, (v2(gp_, 1) - v2(pv, 1)) * H), gv(P, "wr")), ax / al * sl * H, ay / al * sl * H)
	return {"H": H, "W": W, "G": G, "Mb": Mb, "Ma": Ma, "Mg": Mg, "my": my, "fl": fl, "ww": ww, "wh": wh, "axU": [ax / al, ay / al], "al": al}

# 原圖上一點 (u,v) 經過網格變形 + 身體變形，落喺世界邊度
static func meshPt(R: Dictionary, mp: Dictionary, u: float, v: float) -> Vector2:
	var img = spr("afu__body"); var ar = nh(img) / nw(img)
	if RB == null:
		RB = []
		for b in J.gp(J.gp(J.gp(_g("MeshAnim"), "RIG"), "afu"), "bones"):
			if not (J.str(b[0]) in ["armF", "axe"]): RB.append(b)
	var T = {}
	for b in RB:
		var n = J.str(b[0]); var par = b[1]; var px = J.num(b[2]); var py = J.num(b[3])
		var A0 = J.num(mp[n]) if J.t(mp.get(n)) else 0.0
		var Pp = T[J.str(par)] if J.t(par) else {"a": 0.0, "tx": 0.0, "ty": 0.0}
		var ppx = cos(Pp.a) * px - sin(Pp.a) * py + Pp.tx; var ppy = sin(Pp.a) * px + cos(Pp.a) * py + Pp.ty; var A = Pp.a + A0
		T[n] = {"a": A, "tx": ppx - (cos(A) * px - sin(A) * py), "ty": ppy - (sin(A) * px + cos(A) * py)}
	var X = 0.0; var Y = 0.0; var sum = 0.0; var vy = v * ar
	for b in RB:
		var b2 = J.num(b[2]); var b3 = J.num(b[3])
		var dx = J.num(b[4]) - b2; var dy = (J.num(b[5]) - b3) * ar; var l = dx * dx + dy * dy
		if l == 0: l = 1e-6
		var tt = cl(((u - b2) * dx + (vy - b3 * ar) * dy) / l)
		var d = hyp(u - b2 - tt * dx, vy - b3 * ar - tt * dy) / J.num(b[6]); var w = exp(-d * d * 2.2)
		if b[1] == null: w = maxf(w, 0.05)
		var tr = T[J.str(b[0])]; var c = cos(tr.a); var s = sin(tr.a)
		X += w * (c * u - s * vy + tr.tx); Y += w * (s * u + c * vy + tr.ty); sum += w
	X /= sum; Y = Y / sum / ar
	var msy = J.num(mp.msy) if J.t(mp.get("msy")) else 0.0
	return R.Mb * Vector2((X - 0.5) * R.W, (Y - 1 + R.my) * R.H * (1 + msy))
static func fp(R: Dictionary, k: String) -> Vector2: return meshPt(R, R.mp, FACE[k][0], FACE[k][1])

# ---------------- 畫 ----------------
static func render(ctx: Ctx, a: Dictionary, P: Dictionary, st: Dictionary, t: float) -> Dictionary:
	var base: Transform2D = ctx.getTransform(); var R = solveRig(a, P, t); var H: float = R.H; var c = LD()
	var arm = spr("afu__arm"); var pv = J.gp(c, "pivot")
	var mp = {"head": gv(P, "head"), "armB": gv(P, "armB"), "tie": gv(P, "tie"), "tail1": gv(P, "tail1"), "tail2": gv(P, "tail2"), "body": gv(P, "mb"), "y": R.my, "sy": 1 + gv(P, "msy")}
	var up = -gv(P, "dy")
	var fr = J.t(a.get("faceRight"))
	ctx.save(); ctx.globalAlpha *= 0.55 * cl(1 - up * 2.5, 0.35, 1)
	J.mc(a, "shadow", [J.num(a.x) - (-1.0 if fr else 1.0) * gv(P, "dx") * H * 0.5, (1.0 if J.t(a.get("solid")) else 0.8) * cl(1 - up * 1.6, 0.55, 1.1)])
	ctx.restore()
	var planted = J.str(st.get("axe")) == "plant" and st.get("plantM") != null
	var behind = false if J.t(st.get("front")) else gv(P, "th") > J.num(J.gp(c, "behind"))
	if planted and J.t(st.get("plantBehind")): _drawAxe(ctx, base, R, R.G * st.plantM)
	if behind:
		if J.str(st.get("axe")) == "hand": _drawAxe(ctx, base, R, R.Mg)
		_drawArm(ctx, base, R, st, t, arm, pv)
	ctx.save(); ctx.setTransform(base * R.Mb); J.mc(_g("MeshAnim"), "drawBody", [ctx, "afu", "afu__body", H, mp]); ctx.restore()
	if planted and not J.t(st.get("plantBehind")): _drawAxe(ctx, base, R, R.G * st.plantM)
	if not behind:
		if J.str(st.get("axe")) == "hand": _drawAxe(ctx, base, R, R.Mg)
		_drawArm(ctx, base, R, st, t, arm, pv)
	ctx.setTransform(base)
	R["mp"] = mp; return R
static func _clipGround(ctx: Ctx, base: Transform2D, R: Dictionary) -> void:
	var H: float = R.H
	ctx.setTransform(base * R.G); ctx.beginPath(); ctx.rect(-H * 3, -H * 3, H * 6, H * 3 + H * 0.015); ctx.clip()
static func _drawAxe(ctx: Ctx, base: Transform2D, R: Dictionary, Mx: Transform2D) -> void:
	var wp = WP(); var im = AXE(); var gr = J.gp(wp, "grip")
	ctx.save(); _clipGround(ctx, base, R); ctx.setTransform(base * Mx); ctx.drawImage(im, -v2(gr, 0) * R.ww, -v2(gr, 1) * R.wh, R.ww, R.wh); ctx.restore()
static func _drawArm(ctx: Ctx, base: Transform2D, R: Dictionary, st: Dictionary, t: float, arm, pv) -> void:
	ctx.save(); ctx.setTransform(base * R.Ma); ctx.drawImage(arm, -v2(pv, 0) * R.W, -v2(pv, 1) * R.H, R.W, R.H); ctx.restore()
	if gv(st, "phone") > 0: drawPhoneInHand(ctx, base, R, st, t)
# 手機：拿喺握拳嘅手（手機畫喺拳頭上，手指嗰圈再疊一次蓋住手機下緣）
static func drawPhoneInHand(ctx: Ctx, base: Transform2D, R: Dictionary, st: Dictionary, _t: float) -> void:
	var im = spr("afu__phone")
	if not J.t(im) or not ok("afu__phone"): return
	var k = gv(st, "phone"); var H: float = R.H; var c = LD(); var pv = J.gp(c, "pivot")
	var ph = H * 0.2 * (0.55 + 0.45 * k); var pw = ph * nw(im) / nh(im)
	var Mf = mr(mt(R.Ma, (FIST[0] - v2(pv, 0)) * R.W, (FIST[1] - v2(pv, 1)) * R.H), J.num(st.phoneRot) if st.get("phoneRot") != null else -20.0)
	ctx.save(); ctx.setTransform(base * Mf); ctx.globalAlpha *= cl(k * 3)
	ctx.drawImage(im, -pw * 0.5, -ph * 0.92, pw, ph)
	if J.t(st.get("glow")):
		ctx.globalCompositeOperation = "lighter"; ctx.globalAlpha *= J.num(st.glow) * 0.5; ctx.fillStyle = "#9fe6ff"; ctx.beginPath(); ctx.ellipse(0, -ph * 0.48, pw * 0.36, ph * 0.38, 0, 0, 7); ctx.fill()
	ctx.restore()
	ctx.save(); ctx.setTransform(base * R.Ma); var W: float = R.W
	ctx.beginPath(); ctx.ellipse((0.245 - v2(pv, 0)) * W, (0.515 - v2(pv, 1)) * H, 0.05 * W, 0.04 * H, -0.3, 0, 7); ctx.clip()
	ctx.drawImage(spr("afu__arm"), -v2(pv, 0) * W, -v2(pv, 1) * H, W, H); ctx.restore()

# ---------------- 蠟筆特效 ----------------
static func crayonText(ctx: Ctx, s: String, x: float, y: float, size: float, col: String, alpha: float, rot := 0.0) -> void:
	if alpha <= 0: return
	size = maxf(size, 8)
	ctx.save(); ctx.globalAlpha *= alpha; ctx.translate(x, y)
	if rot != 0: ctx.rotate(rot)
	ctx.font = "bold " + J.str(size) + FONTF; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineJoin = "round"; ctx.lineWidth = maxf(2, size * 0.28); ctx.strokeStyle = "rgba(28,18,26,.92)"; ctx.strokeText(s, 0, 0)
	ctx.fillStyle = col; ctx.fillText(s, 0, 0)
	ctx.globalAlpha *= 0.35; ctx.fillStyle = "#fff"; ctx.fillText(s, -size * 0.04, -size * 0.05)
	ctx.restore()
static func bubble(ctx: Ctx, x: float, y: float, w: float, h: float, alpha: float, tailX = null, tailY = null) -> void:
	if alpha <= 0: return
	ctx.save(); ctx.globalAlpha *= alpha; ctx.lineJoin = "round"
	ctx.beginPath(); ctx.roundRect(x - w / 2, y - h / 2, w, h, h * 0.45)
	if tailX != null: ctx.moveTo(x - w * 0.12, y + h / 2 - 1); ctx.lineTo(tailX, tailY); ctx.lineTo(x + w * 0.08, y + h / 2 - 1)
	ctx.fillStyle = "#fbf3e2"; ctx.fill(); ctx.lineWidth = maxf(1.4, h * 0.09); ctx.strokeStyle = "#3a2a2e"; ctx.stroke()
	ctx.restore()
static func say(ctx: Ctx, s: String, x: float, y: float, size: float, col: String, alpha: float, tx = null, ty = null) -> void:
	if alpha <= 0: return
	size = maxf(size, 8)
	ctx.save(); ctx.font = "bold " + J.str(size) + FONTF; var w = J.num(ctx.measureText(s).get("width")) + size * 1.1; ctx.restore()
	bubble(ctx, x, y, w, size * 1.75, alpha, tx, ty); crayonText(ctx, s, x, y, size, col, alpha)
static func drop(ctx: Ctx, x: float, y: float, r: float, rot: float, alpha: float) -> void:
	if alpha <= 0: return
	ctx.save(); ctx.globalAlpha *= alpha; ctx.translate(x, y); ctx.rotate(rot)
	ctx.beginPath(); ctx.moveTo(0, -r * 1.7); ctx.quadraticCurveTo(r * 1.1, -r * 0.1, r * 0.95, r * 0.35); ctx.arc(0, r * 0.35, r * 0.95, 0, PI); ctx.quadraticCurveTo(-r * 1.1, -r * 0.1, 0, -r * 1.7); ctx.closePath()
	ctx.fillStyle = "rgba(150,215,245,.92)"; ctx.fill(); ctx.lineWidth = maxf(0.8, r * 0.32); ctx.strokeStyle = "#2f5568"; ctx.stroke()
	ctx.fillStyle = "rgba(255,255,255,.85)"; ctx.beginPath(); ctx.ellipse(-r * 0.3, r * 0.1, r * 0.22, r * 0.38, 0.3, 0, 7); ctx.fill()
	ctx.restore()
static func snot(ctx: Ctx, x: float, y: float, r: float, alpha: float) -> void:
	if alpha <= 0 or r <= 0.2: return
	ctx.save(); ctx.globalAlpha *= alpha
	ctx.beginPath(); ctx.arc(x, y, r, 0, 7); ctx.fillStyle = "rgba(190,232,250,.45)"; ctx.fill()
	ctx.lineWidth = maxf(0.7, r * 0.1); ctx.strokeStyle = "rgba(70,120,150,.85)"; ctx.stroke()
	ctx.fillStyle = "rgba(255,255,255,.9)"; ctx.beginPath(); ctx.ellipse(x - r * 0.38, y - r * 0.38, r * 0.2, r * 0.13, -0.7, 0, 7); ctx.fill()
	ctx.beginPath(); ctx.arc(x + r * 0.3, y + r * 0.35, r * 0.07, 0, 7); ctx.fill()
	ctx.restore()
const C3 := [[0.0, 0.0, 0.55], [-0.42, 0.12, 0.4], [0.42, 0.14, 0.42], [0.1, -0.3, 0.38]]
static func puff(ctx: Ctx, x: float, y: float, r: float, alpha: float, col = null) -> void:
	if alpha <= 0: return
	if col == null and ok("fx_dust"):
		var I = spr("fx_dust"); var sc = r * 2 / maxf(nw(I), nh(I))
		ctx.save(); ctx.globalAlpha *= alpha; ctx.drawImage(I, x - nw(I) * sc / 2, y - nh(I) * sc / 2, nw(I) * sc, nh(I) * sc); ctx.restore(); return
	ctx.save(); ctx.globalAlpha *= alpha
	ctx.beginPath()
	for q in C3: ctx.moveTo(x + q[0] * r + q[2] * r, y + q[1] * r); ctx.arc(x + q[0] * r, y + q[1] * r, q[2] * r, 0, 7)
	ctx.lineWidth = maxf(1, r * 0.16); ctx.strokeStyle = "rgba(70,70,85,.55)"; ctx.stroke(); ctx.fillStyle = col if J.t(col) else "rgba(230,225,210,.9)"; ctx.fill()
	ctx.fillStyle = "rgba(255,255,255,.5)"; ctx.beginPath(); ctx.arc(x - r * 0.15, y - r * 0.22, r * 0.18, 0, 7); ctx.fill()
	ctx.restore()
static func lines(ctx: Ctx, x: float, y: float, r: float, n: int, a0: float, a1: float, alpha: float, col = null, w = null) -> void:
	if alpha <= 0: return
	ctx.save(); ctx.globalAlpha *= alpha; ctx.strokeStyle = col if J.t(col) else "#fff3c4"; ctx.lineWidth = J.num(w) if J.t(w) else maxf(1.2, r * 0.12); ctx.lineCap = "round"
	for i in n:
		var an = a0 + (a1 - a0) * (0.5 if n == 1 else float(i) / (n - 1))
		ctx.beginPath(); ctx.moveTo(x + cos(an) * r * 0.55, y + sin(an) * r * 0.55); ctx.lineTo(x + cos(an) * r, y + sin(an) * r); ctx.stroke()
	ctx.restore()
static func sparkle(ctx: Ctx, x: float, y: float, r: float, alpha: float) -> void:
	if alpha <= 0: return
	if ok("fx_spark"):
		var I = spr("fx_spark"); var sc = r * 2 / maxf(nw(I), nh(I))
		ctx.save(); ctx.globalAlpha *= alpha; ctx.drawImage(I, x - nw(I) * sc / 2, y - nh(I) * sc / 2, nw(I) * sc, nh(I) * sc); ctx.restore(); return
	lines(ctx, x, y, r, 4, 0, PI * 1.5, alpha)
static func mouthO(ctx: Ctx, p: Vector2, w: float, h: float, rot: float, alpha: float) -> void:
	if alpha <= 0 or h <= 0.3: return
	ctx.save(); ctx.globalAlpha *= alpha; ctx.translate(p.x, p.y); ctx.rotate(rot)
	ctx.beginPath(); ctx.ellipse(0, h * 0.25, w, h, 0, 0, 7); ctx.fillStyle = "#4a2027"; ctx.fill()
	ctx.lineWidth = maxf(0.9, w * 0.32); ctx.strokeStyle = "#33221f"; ctx.stroke()
	ctx.beginPath(); ctx.ellipse(0, h * 0.25 + h * 0.5, w * 0.6, h * 0.35, 0, PI, 2 * PI); ctx.fillStyle = "#b8565c"; ctx.fill()
	ctx.restore()

# ---------------- 狀態 ----------------
static func mem(a: Dictionary) -> Dictionary:
	var k = J.gp(a.o, "hid"); k = J.str(k) if J.t(k) else "hero"
	if not MEM.has(k): MEM[k] = {"name": null, "P": null, "st": null, "from": null, "fromSt": null}
	return MEM[k]
static func hsh(n: float) -> float:
	var x = S(n * 127.1 + 311.7) * 43758.5453
	return x - floor(x)
static func plantM(a: Dictionary) -> Transform2D:
	var R = solveRig(a, addP(Z(), PLANT), 0)
	return R.G.affine_inverse() * R.Mg
static func _tipW(R: Dictionary, M: Transform2D, f := 1.0) -> Vector2: return M * Vector2(R.axU[0] * R.al * f, R.axU[1] * R.al * f)

# ---------------- 各動作 ----------------
static func act_walk(a: Dictionary, at: float, t: float) -> Dictionary:
	var w = J.cl(J.gp(J.gp(_g("MeshAnim"), "ANIM"), "walk"), null, [t]); var r = rest(t)
	var P = Z()
	P.head = J.num(J.gp(w, "head")) - r.head; P.armB = J.num(J.gp(w, "armB")) - r.armB; P.tie = J.num(J.gp(w, "tie")) - r.tie + S(t * 13) * 0.08
	P.tail1 = J.num(J.gp(w, "tail1")) - r.tail1; P.tail2 = J.num(J.gp(w, "tail2")) - r.tail2
	P.th = S(t * 7) * 5; P.wr = S(t * 7 - 0.6) * 4; P.lean = -3.0; P.dy = -absf(S(t * 7)) * 0.02
	var gi = floor((at + 0.8) / 2.6); var gk = fmod(at + 0.8, 2.6) / 2.6; var g = hsh(gi + 3)
	var look = bell(gk, 0.15, 0.85); var ee = ez("io", cl(look * 1.6))
	if g < 0.4: P.head += -0.16 * ee; P.dx += 0.02 * ee
	elif g < 0.75: P.head += 0.15 * ee; P.lean += 3 * ee
	else: P.head += S(gk * PI * 4) * 0.08 * look
	var hp = -9.0; var stone = null; var base = floor((at - 2.4) / 4.5)
	for i in range(int(maxf(0, base - 1)), int(base + 1) + 1):
		var c = 2.4 + i * 4.5 + hsh(i + 17) * 1.5; var q = (at - c) / 0.55
		if q > -1.2 and q < 1.6: hp = q
	if hp > -1.2 and hp < 1.6: stone = {"k": hp}
	if hp >= 0 and hp < 1:
		var q = hp; var up = 0.0; var sq = 0.0
		if q < 0.18: sq = ez("o", q / 0.18)
		elif q < 0.75:
			var u = (q - 0.18) / 0.57; up = S(u * PI); sq = -0.6 * S(u * PI) + (1 - u / 0.15 if u < 0.15 else 0.0)
		else: sq = S((q - 0.75) / 0.25 * PI) * 0.8
		P.dy += -0.2 * up; P.sy += -0.07 * sq; P.sx += 0.06 * sq; P.lean += -6 * up
		P.tie += 0.35 * up; P.tail1 += 0.25 * up; P.tail2 += 0.45 * up; P.th += 14 * up; P.head += -0.06 * sq
	return {"P": P, "st": {"axe": "hand"}, "stone": stone}

static func act_yawn(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 3.6
	var P = track(at, [
		[0.0, {}],
		[0.45, {"sy": -0.03, "sx": 0.02, "head": -0.08, "dy": 0.01}, "io"],
		[1.25, {"sy": 0.07, "sx": -0.03, "dy": -0.03, "lean": 7.0, "head": 0.22, "th": 94.0, "hx": 0.04, "hy": 0.05, "armB": -0.32, "tail1": -0.15, "tail2": -0.25, "tie": 0.15}, "o3"],
		[2.15, {"sy": 0.08, "sx": -0.035, "dy": -0.035, "lean": 8.0, "head": 0.25, "th": 98.0, "hx": 0.04, "hy": 0.05, "armB": -0.36, "tail1": -0.18, "tail2": -0.3, "tie": 0.2}, "l"],
		[2.75, {"sy": -0.04, "sx": 0.03, "dy": 0.01, "lean": -4.0, "head": -0.1, "th": -6.0, "armB": 0.08, "tail1": 0.08, "tail2": 0.12}, "io"],
		[3.2, {"sy": 0.005, "head": 0.02}, "io"],
		[L, {}, "io"],
	])
	var shake = bell(at, 1.35, 2.15); P.head += S(at * 38) * 0.015 * shake; P.th += S(at * 31) * 1.6 * shake
	var open = ez("io", cl(seg(at, 0.6, 1.2)) * (1 - seg(at, 2.2, 2.75)) if bell(at, 0.6, 2.75) > 0 else 0.0)
	var fx = func(ctx: Ctx, R: Dictionary):
		var m = fp(R, "mouth"); var s: float = R.H; var dr = dirf(a)
		mouthO(ctx, m, s * 0.026 * (0.6 + 0.4 * open), s * 0.034 * open, -(P.head + R.mp.head) * 0.5 * (-1.0 if J.t(a.get("faceRight")) else 1.0), cl(open * 4))
		var ht = seg(at, 1.0, 2.6); var bl = bell(at, 1.0, 2.6)
		crayonText(ctx, "哈～", m.x + dr * s * (0.32 + ht * 0.12), m.y - s * (0.18 + ht * 0.15), s * 0.2, "#fff4d0", 1.0 if bl * 1.6 > 1 else bl * 1.6)
		var tk = seg(at, 2.55, 3.55); var e = meshPt(R, R.mp, 0.345, 0.315)
		if tk > 0 and tk < 1: drop(ctx, e.x, e.y + tk * s * 0.04, s * 0.014 * (tk / 0.2 if tk < 0.2 else 1.0), 0, 1 - ez("i", seg(at, 3.2, 3.55)))
	return {"P": P, "st": {"axe": "hand"}, "L": L, "fx": fx}

static func act_stretch(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 3.6
	var P = track(at, [
		[0.0, {}],
		[0.4, {"sy": -0.05, "sx": 0.03, "dy": 0.015, "head": -0.06, "th": -8.0}, "io"],
		[1.0, {"sy": 0.1, "sx": -0.05, "dy": -0.05, "lean": 12.0, "head": 0.18, "th": 96.0, "hx": 0.04, "hy": 0.06, "armB": -0.5, "wr": 8.0, "tail1": -0.22, "tail2": -0.38, "tie": 0.25}, "o3"],
		[1.45, {"sy": 0.11, "sx": -0.055, "dy": -0.055, "lean": -6.0, "head": 0.08, "th": 100.0, "hx": 0.04, "hy": 0.07, "armB": -0.42, "wr": 10.0, "tail1": 0.2, "tail2": 0.35, "tie": -0.15}, "io"],
		[1.9, {"sy": 0.11, "sx": -0.055, "dy": -0.055, "lean": 14.0, "head": 0.2, "th": 98.0, "hx": 0.04, "hy": 0.07, "armB": -0.55, "wr": 6.0, "tail1": -0.25, "tail2": -0.4, "tie": 0.3}, "io"],
		[2.2, {"sy": 0.11, "sx": -0.05, "dy": -0.05, "lean": 12.0, "head": 0.22, "th": 100.0, "hx": 0.04, "hy": 0.07, "armB": -0.55, "wr": 8.0, "tail1": -0.2, "tail2": -0.35, "tie": 0.25}, "l"],
		[2.75, {"sy": -0.06, "sx": 0.04, "dy": 0.02, "lean": -5.0, "head": -0.12, "th": -10.0, "armB": 0.1, "tail1": 0.1, "tail2": 0.15, "tie": -0.1}, "io"],
		[3.2, {"sy": 0.01, "head": 0.02}, "io"],
		[L, {}, "io"],
	])
	var shake = bell(at, 1.9, 2.25); P.lean += S(at * 40) * 1.2 * shake
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var top = fp(R, "top"); var fr = J.t(a.get("faceRight"))
		var k = seg(at, 2.0, 2.55); var bl = bell(at, 2.0, 2.6)
		crayonText(ctx, "喀", top.x + (-1.0 if fr else 1.0) * s * 0.28, top.y + s * 0.25 - k * s * 0.12, s * 0.17, "#ffe6a8", 1.0 if bl * 1.8 > 1 else bl * 1.8, 0.2)
		lines(ctx, top.x + (-1.0 if fr else 1.0) * s * 0.18, top.y + s * 0.35, s * 0.12, 3, -2.4, -1.2, bell(at, 2.0, 2.3), "#fff3c4")
		var m = fp(R, "mouth"); var pk = seg(at, 2.6, 3.4)
		puff(ctx, m.x + (1.0 if fr else -1.0) * s * (0.12 + pk * 0.15), m.y + s * 0.02 - pk * s * 0.05, s * (0.05 + pk * 0.05), bell(at, 2.6, 3.4) * 0.9, "rgba(235,240,245,.9)")
	return {"P": P, "st": {"axe": "hand"}, "L": L, "fx": fx}

static func act_scratch(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 3.0
	var P = track(at, [
		[0.0, {}],
		[0.35, {"th": -6.0, "head": -0.03, "sy": -0.015}, "io"],
		[0.8, {"th": 80.0, "hx": 0.26, "hy": -0.08, "head": -0.1, "lean": -3.0, "wr": 20.0, "armB": -0.05}, "o3"],
		[2.2, {"th": 80.0, "hx": 0.26, "hy": -0.08, "head": -0.12, "lean": -3.0, "wr": 20.0, "armB": -0.05}, "l"],
		[2.65, {"th": -4.0, "head": -0.02}, "io"],
		[L, {}, "io"],
	])
	var sc = cl(seg(at, 0.75, 0.95)) * (1 - seg(at, 2.05, 2.25)) if bell(at, 0.75, 2.25) > 0 else 0.0
	P.th += S(at * 24) * 6 * sc; P.hy += S(at * 24 + 1.2) * 0.02 * sc; P.wr += S(at * 24) * 5 * sc; P.head += S(at * 12) * 0.025 * sc
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var top = fp(R, "top"); var al = cl(bell(at, 0.8, 2.6) * 2); var dr = dirf(a)
		crayonText(ctx, "？", top.x + dr * s * 0.22, top.y - s * 0.08 - seg(at, 0.8, 1.2) * s * 0.06 + S(at * 6) * s * 0.01, s * 0.24, "#ffe9a8", al, dr * -0.15)
		if sc > 0.2: lines(ctx, top.x - dr * s * 0.3, top.y + s * 0.18, s * 0.1, 2, -2.6 + S(at * 26) * 0.3, -1.9, sc * 0.8, "#e8dfcf")
	return {"P": P, "st": {"axe": "hand"}, "L": L, "fx": fx}

static func act_tap(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 3.4
	var P = track(at, [
		[0.0, {}],
		[0.35, {"lean": 4.0, "head": 0.1, "th": 6.0, "sy": 0.01}, "io"],
		[3.0, {"lean": 4.0, "head": 0.1, "th": 6.0, "sy": 0.01}, "l"],
		[L, {}, "io"],
	])
	var on = cl(seg(at, 0.3, 0.6)) * (1 - seg(at, 2.8, 3.1)) if bell(at, 0.3, 3.1) > 0 else 0.0
	var beat = fmod(at * 3.2, 1.0); var kick = ez("o", beat / 0.35) if beat < 0.35 else 1 - ez("io", (beat - 0.35) / 0.65)
	P.tail1 += (-0.35 + 0.45 * kick) * on; P.tail2 += (-0.9 + 1.2 * kick) * on
	P.dy += -0.006 * (1 - kick) * on; P.sy += 0.012 * (1 - kick) * on
	P.wr += S(at * 6.4) * 9 * on; P.th += S(at * 6.4 + 0.8) * 4 * on
	P.head += S(at * 3.2 * PI) * 0.02 * on
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var g: Vector2 = R.G * Vector2(R.H * 0.02, 0); var dr = dirf(a)
		if on > 0.5 and beat < 0.3: puff(ctx, g.x - dr * s * 0.05, g.y - s * 0.02, s * (0.04 + beat * 0.12), (0.3 - beat) / 0.3 * 0.7)
		var m = fp(R, "mouth"); var k = seg(at, 1.2, 2.2)
		crayonText(ctx, "嘖", m.x - dr * s * (0.32 + k * 0.05), m.y - s * 0.12 - k * s * 0.08, s * 0.17, "#ffd2b0", cl(bell(at, 1.2, 2.3) * 2))
		var top = fp(R, "top"); crayonText(ctx, "…", top.x + dr * s * 0.2, top.y - s * 0.02, s * 0.2, "#fff", cl(bell(at, 0.4, 1.3) * 2) + cl(bell(at, 2.3, 3.2) * 2))
	return {"P": P, "st": {"axe": "hand"}, "L": L, "fx": fx}

static func act_sweat(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 2.8
	var P = track(at, [
		[0.0, {}],
		[0.3, {"th": -4.0, "head": -0.04, "sy": -0.01}, "io"],
		[0.75, {"th": 50.0, "hx": -0.1, "hy": 0.0, "head": 0.08, "wr": -40.0, "lean": -2.0}, "o3"],
		[1.3, {"th": 60.0, "hx": 0.1, "hy": 0.02, "head": 0.16, "wr": -32.0, "lean": 4.0}, "io"],
		[1.6, {"th": 80.0, "hx": 0.27, "hy": -0.06, "head": 0.1, "wr": 16.0, "lean": 3.0}, "o"],
		[2.0, {"th": -6.0, "head": -0.08, "sy": -0.03, "dy": 0.01, "lean": -3.0}, "io"],
		[2.4, {"head": 0.01}, "io"],
		[L, {}, "io"],
	])
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var b = fp(R, "brow"); var dr = dirf(a)
		for i in 3:
			var al = (1 - seg(at, 0.85 + i * 0.12, 1.0 + i * 0.12)) * cl(at / 0.25)
			drop(ctx, b.x + dr * (0.04 - i * 0.07) * s, b.y + [0.0, 0.035, -0.01][i] * s, s * [0.016, 0.012, 0.014][i], 0, al)
		var fk = seg(at, 1.5, 2.2)
		if fk > 0 and fk < 1:
			var pv = J.gp(LD(), "pivot"); var h0: Vector2 = R.Ma * Vector2((FIST[0] - v2(pv, 0)) * R.W, (FIST[1] - v2(pv, 1)) * R.H)
			for i in 3:
				var vx = dr * -(0.25 + i * 0.12); var vy = -0.35 + i * 0.12
				drop(ctx, h0.x + vx * fk * s, h0.y + (vy * fk + 0.9 * fk * fk) * s, s * 0.016, atan2(vy + 1.8 * fk, vx) + PI / 2, 1 - fk)
		var m = fp(R, "mouth"); var pk = seg(at, 1.75, 2.6)
		puff(ctx, m.x + dr * s * (0.1 + pk * 0.14), m.y + s * 0.03 + pk * s * 0.02, s * (0.04 + pk * 0.05), bell(at, 1.75, 2.6), "rgba(235,240,245,.9)")
		crayonText(ctx, "呼～", m.x + dr * s * (0.34 + pk * 0.06), m.y - s * 0.08 - pk * s * 0.06, s * 0.16, "#eaf6ff", cl(bell(at, 1.8, 2.7) * 2))
	return {"P": P, "st": {"axe": "hand", "front": at > 0.35 and at < 1.55}, "L": L, "fx": fx}

static func act_dust(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 3.0
	var P = track(at, [
		[0.0, {}],
		[0.25, {"armB": 0.25, "head": -0.12, "lean": -3.0}, "io"],
		[0.42, {"armB": -0.18, "head": -0.14, "lean": -4.0}, "o"],
		[0.6, {"armB": 0.28, "head": -0.14, "lean": -4.0}, "io"],
		[0.78, {"armB": -0.2, "head": -0.14, "lean": -4.0}, "o"],
		[0.95, {"armB": 0.0, "head": -0.05}, "io"],
		[1.4, {"th": 30.0, "hx": -0.05, "hy": 0.02, "wr": -18.0, "head": -0.02, "lean": -4.0, "dx": 0.01}, "o3"],
		[2.2, {"th": 32.0, "hx": -0.05, "hy": 0.02, "wr": -20.0, "head": -0.06, "lean": -7.0, "dx": 0.02}, "l"],
		[2.65, {"th": -3.0, "head": 0.02}, "io"],
		[L, {}, "io"],
	])
	var blow = bell(at, 1.55, 2.2); P.sy += -0.02 * blow; P.sx += 0.015 * blow
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var c = fp(R, "chest"); var dr = dirf(a)
		for tj in [[0.42, 0], [0.78, 1]]:
			var k = seg(at, tj[0], tj[0] + 0.5)
			if k > 0 and k < 1:
				for i in 2: puff(ctx, c.x - dr * s * (0.08 + i * 0.07 + tj[1] * 0.03) - dr * k * s * 0.1, c.y + s * (0.08 + i * 0.05) - k * s * 0.06, s * (0.05 + k * 0.07), (1 - k) * 0.85)
		var m = fp(R, "mouth"); var bk = seg(at, 1.55, 2.3)
		if bk > 0 and bk < 1:
			ctx.save(); ctx.globalAlpha *= (1 - bk) * 0.9; ctx.strokeStyle = "rgba(235,245,250,.95)"; ctx.lineWidth = maxf(1, s * 0.012); ctx.lineCap = "round"
			for i in 3:
				var y0 = m.y + (i - 1) * s * 0.025; var x0 = m.x + dr * s * 0.05
				ctx.beginPath(); ctx.moveTo(x0, y0); ctx.quadraticCurveTo(x0 + dr * s * 0.12, y0 - s * 0.02, x0 + dr * s * (0.2 + bk * 0.12), y0 + S(bk * 9 + i) * s * 0.02); ctx.stroke()
			ctx.restore()
			var R2 = _tipW(R, R.Mg, 0.9)
			for i in 5:
				var q = cl(bk * 1.3 - i * 0.06)
				if q <= 0 or q >= 1: continue
				var x = R2.x + dr * (0.05 + q * (0.25 + i * 0.05)) * s; var y = R2.y + (-0.04 + i * 0.02 + q * q * 0.25) * s
				ctx.save(); ctx.globalAlpha *= 1 - q; ctx.fillStyle = ["#c8955a", "#a8743e", "#e0b47a"][i % 3]; ctx.translate(x, y); ctx.rotate(q * 9 + i); ctx.fillRect(-s * 0.012, -s * 0.006, s * 0.024, s * 0.012); ctx.restore()
	return {"P": P, "st": {"axe": "hand", "front": true}, "L": L, "fx": fx}

static func act_proud(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 2.2
	var P = track(at, [
		[0.0, {}],
		[0.2, {"sy": -0.07, "sx": 0.05, "dy": 0.02, "head": -0.1, "th": -10.0, "lean": -3.0}, "o"],
		[0.48, {"sy": 0.08, "sx": -0.04, "dy": -0.2, "head": 0.18, "th": 110.0, "hx": 0.0, "hy": 0.1, "wr": -20.0, "lean": 6.0, "armB": -0.45, "tie": 0.4, "tail1": -0.2, "tail2": -0.4}, "o3"],
		[0.62, {"sy": 0.04, "sx": -0.02, "dy": -0.17, "head": 0.16, "th": 112.0, "hx": 0.0, "hy": 0.1, "wr": -20.0, "lean": 6.0, "armB": -0.45, "tie": 0.35, "tail1": -0.1, "tail2": -0.2}, "l"],
		[0.78, {"sy": -0.08, "sx": 0.06, "dy": 0.015, "head": 0.0, "th": 60.0, "hx": -0.03, "hy": 0.1, "wr": 0.0, "lean": 2.0, "armB": -0.2, "tie": -0.1, "tail1": 0.15, "tail2": 0.3}, "i"],
		[1.0, {"sy": 0.02, "sx": -0.01, "dy": 0.0, "head": 0.14, "th": 10.0, "hx": -0.06, "hy": 0.12, "wr": 15.0, "lean": 7.0, "armB": -0.12, "tie": 0.1}, "o"],
		[1.75, {"sy": 0.025, "sx": -0.012, "head": 0.15, "th": 12.0, "hx": -0.06, "hy": 0.13, "wr": 15.0, "lean": 7.0, "armB": -0.12}, "l"],
		[2.0, {"head": 0.02, "th": -4.0}, "io"],
		[L, {}, "io"],
	])
	var chest = bell(at, 1.0, 1.75); P.sy += S(at * 9) * 0.006 * chest
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var top = fp(R, "top"); var dr = dirf(a)
		var tip = _tipW(R, R.Mg)
		var sk = seg(at, 0.42, 1.0)
		if sk > 0 and sk < 1: sparkle(ctx, tip.x, tip.y, s * (0.03 + 0.05 * S(sk * PI)), S(sk * PI))
		for i in 3:
			var k = seg(at, 1.0 + i * 0.15, 1.6 + i * 0.15)
			if k > 0 and k < 1: sparkle(ctx, top.x + dr * s * (-0.3 + i * 0.3), top.y - s * (0.0 + i % 2 * 0.07) - k * s * 0.05, s * 0.035 * S(k * PI), S(k * PI))
		var g: Vector2 = R.G * Vector2(0, 0); var lk = seg(at, 0.76, 1.2)
		if lk > 0 and lk < 1:
			for sd in [-1.0, 1.0]: puff(ctx, g.x + sd * s * (0.12 + lk * 0.12), g.y - s * 0.02 - lk * s * 0.03, s * (0.05 + lk * 0.06), (1 - lk) * 0.8)
	return {"P": P, "st": {"axe": "hand"}, "L": L, "fx": fx}

static func plantKeys(t0: float) -> Array:
	return [
		[0.0, {}],
		[t0 + 0.38, {"th": 62.0, "lean": 7.0, "dx": -0.03, "dy": -0.02, "sx": -0.03, "sy": 0.04, "head": 0.05, "bob": -0.6}, "o"],
		[t0 + 0.52, PLANT.duplicate(), "i"],
	]

static func act_phone(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 7.6; var pk = plantKeys(0)
	var HOLD = {"th": 5.0, "hx": 0.18, "hy": -0.12, "head": -0.15, "lean": -3.0, "armB": 0.05}
	var P = track(at, pk + [
		[0.75, PLANT.duplicate(), "l"],
		[1.0, {"th": -60.0, "hx": -0.02, "hy": 0.02, "lean": -6.0, "dx": 0.04, "head": -0.06, "bob": -0.3}, "io"],
		[1.35, {"th": -12.0, "hx": 0.3, "hy": -0.1, "lean": -4.0, "dx": 0.02, "head": -0.12}, "io"],
		[1.85, HOLD, "back"],
		[2.6, asg(HOLD, {"head": -0.16}), "l"],
		[2.75, asg(HOLD, {"head": -0.11, "dy": -0.012, "th": 9.0, "sy": 0.015}), "o"],
		[3.1, asg(HOLD, {"head": -0.17}), "io"],
		[4.2, asg(HOLD, {"head": -0.2, "th": 3.0}), "l"],
		[4.65, asg(HOLD, {"head": 0.06, "sy": 0.05, "dy": -0.025, "lean": 3.0, "th": 2.0, "hy": -0.14}), "io"],
		[5.4, asg(HOLD, {"head": -0.24, "sy": -0.06, "sx": 0.03, "dy": 0.025, "lean": -7.0, "th": -8.0, "hy": -0.16, "armB": 0.12, "tie": -0.15}), "o"],
		[5.7, asg(HOLD, {"head": -0.22, "sy": -0.05, "sx": 0.025, "dy": 0.02, "lean": -6.0, "th": -8.0, "hy": -0.16, "armB": 0.12}), "l"],
		[6.05, {"th": -12.0, "hx": 0.3, "hy": -0.1, "lean": -4.0, "dx": 0.02, "head": -0.1}, "io"],
		[6.45, {"th": -60.0, "hx": -0.02, "hy": 0.02, "lean": -6.0, "dx": 0.04, "head": -0.04, "bob": -0.6}, "io"],
		[6.8, asg(PLANT, {"head": -0.06}), "io"],
		[6.95, asg(PLANT, {"sy": -0.07, "sx": 0.05, "dy": 0.04, "head": -0.06}), "io"],
		[7.15, {"th": 20.0, "lean": 4.0, "dy": -0.03, "sy": 0.05, "sx": -0.03, "head": 0.06}, "o3"],
		[L, {}, "io"],
	])
	var hasAxe = at < 0.75 or at >= 6.8
	var ph = 0.0
	if at < 1.35: ph = 0.0
	elif at < 1.6: ph = ez("o", (at - 1.35) / 0.25)
	elif at < 5.85: ph = 1.0
	elif at < 6.05: ph = 1 - ez("i", (at - 5.85) / 0.2)
	var scroll = bell(at, 1.9, 2.6) + bell(at, 3.1, 4.2)
	P.th += S(at * 9) * 1.5 * scroll
	var pm = plantM(a)
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var dr = dirf(a)
		plantFx(ctx, a, R, at, 0.52)
		if at > 6.95 and at < 7.6:
			var k = seg(at, 7.0, 7.5); var g = _tipW(R, R.G * plantM(a))
			puff(ctx, g.x, g.y - s * 0.02 - k * s * 0.04, s * (0.05 + k * 0.06), (1 - k) * 0.8)
		var pv = J.gp(LD(), "pivot")
		var pp: Vector2 = mt(R.Ma, (FIST[0] - v2(pv, 0)) * R.W, (FIST[1] - v2(pv, 1)) * R.H) * Vector2(0, -s * 0.15)
		var dk = seg(at, 2.6, 3.6)
		if dk > 0 and dk < 1 and ok("afu__ring"):
			var I = spr("afu__ring"); var sc = s * 0.14 / nh(I) * (1 + 0.15 * S(dk * 30))
			ctx.save(); ctx.globalAlpha *= cl((1 - dk) * 3); ctx.translate(pp.x + dr * s * 0.02, pp.y - s * 0.02)
			if dr < 0: ctx.scale(-1, 1)
			ctx.drawImage(I, 0, -nh(I) * sc * 0.6, nw(I) * sc, nh(I) * sc); ctx.restore()
		var top = fp(R, "top"); var bk = cl(bell(at, 2.6, 3.4) * 3); var bx = top.x + dr * s * 0.34; var by = top.y - s * 0.02
		if bk > 0:
			var pop = ez("back", seg(at, 2.6, 2.8)) if at < 2.8 else 1.0
			ctx.save(); ctx.translate(bx, by); ctx.scale(pop, pop); say(ctx, "叮！", 0, 0, s * 0.13, "#d8402e", bk, -dr * s * 0.1, s * 0.2); ctx.restore()
		var mk = cl(bell(at, 3.3, 4.8) * 3)
		if mk > 0:
			var cx = pp.x + dr * maxf(s * 0.5, 38); var y = pp.y - s * (0.12 + seg(at, 3.3, 3.6) * 0.05)
			say(ctx, "老闆：今晚加班", cx, y, s * 0.1, "#3a2a2e", mk, pp.x + dr * s * 0.08, pp.y - s * 0.02)
		var m = fp(R, "mouth"); var sk = seg(at, 4.7, 5.9)
		puff(ctx, m.x + dr * s * (0.12 + sk * 0.2), m.y + s * 0.05 + sk * s * 0.06, s * (0.05 + sk * 0.07), bell(at, 4.7, 5.9), "rgba(225,235,240,.9)")
		crayonText(ctx, "唉——", m.x + dr * s * (0.5 + sk * 0.08), m.y - s * 0.12 + sk * s * 0.04, s * 0.17, "#cfe0ff", cl(bell(at, 4.75, 6.1) * 2))
	return {"P": P, "st": {"axe": "hand" if hasAxe else "plant", "plantM": pm, "phone": ph, "glow": ph * (0.6 + 0.4 * bell(at, 2.6, 3.0)), "phoneRot": -15.0}, "L": L, "fx": fx}

static func plantFx(ctx: Ctx, a: Dictionary, R: Dictionary, at: float, tHit: float) -> void:
	var s: float = R.H; var g = _tipW(R, R.G * plantM(a))
	var k = seg(at, tHit, tHit + 0.55)
	if k > 0 and k < 1:
		for sd in [-1.0, 1.0]: puff(ctx, g.x + sd * s * (0.05 + k * 0.1), g.y - s * 0.02 - k * s * 0.05, s * (0.04 + k * 0.06), (1 - k) * 0.9)
		lines(ctx, g.x, g.y - s * 0.02, s * 0.14, 5, -PI * 0.95, -PI * 0.05, cl((0.25 - k) * 4), "#fff1c8")
	if at >= tHit:
		ctx.save(); ctx.globalAlpha *= 0.8; ctx.strokeStyle = "rgba(30,22,18,.75)"; ctx.lineWidth = maxf(1, s * 0.012); ctx.lineCap = "round"
		ctx.beginPath(); ctx.moveTo(g.x - s * 0.07, g.y + s * 0.005); ctx.quadraticCurveTo(g.x, g.y - s * 0.012, g.x + s * 0.07, g.y + s * 0.005); ctx.stroke(); ctx.restore()

static func act_doze(a: Dictionary, at: float, _t: float) -> Dictionary:
	var pk = plantKeys(0); var LEAN = asg(PLANT, {"head": -0.22, "msy": -0.025, "tail1": 0.12, "tail2": 0.2, "tie": -0.12})
	var P = track(at, pk + [
		[0.75, PLANT.duplicate(), "l"],
		[1.8, LEAN, "io"],
	])
	var sl = cl((at - 1.6) / 0.8)
	var br = S(at * 1.6); var nodP = fmod(fmod(at - 1.8, 5.2) + 5.2, 5.2)
	var nod = ez("io", nodP / 4.3) if nodP < 4.3 else 1 - ez("back", cl((nodP - 4.3) / 0.35))
	P.msy += br * 0.012 * sl; P.head += (-0.1 * nod + br * 0.015) * sl; P.tie += S(at * 2) * 0.05 * sl; P.tail2 += S(at * 1.2) * 0.08 * sl
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var dr = dirf(a)
		plantFx(ctx, a, R, at, 0.52)
		if sl <= 0: return
		var n = fp(R, "nose"); var r = s * (0.025 + 0.045 * (0.5 + 0.5 * br)) * sl * (0.6 if nodP > 4.3 and nodP < 4.5 else 1.0)
		snot(ctx, n.x + dr * r * 0.55, n.y + r * 0.75, r, sl)
		var top = fp(R, "top")
		for i in 3:
			var k = fmod(at * 0.45 + i / 3.0, 1.0)
			crayonText(ctx, "Z" if i == 1 else "z", top.x - dr * s * (0.3 + k * 0.25) + S(k * 6 + i) * s * 0.03, top.y + s * 0.02 - k * s * 0.4, s * (0.1 + k * 0.08), "#e8e4ff", S(k * PI) * sl, -0.25 * dr)
	return {"P": P, "st": {"axe": "hand", "plantM": plantM(a)}, "fx": fx}

static func act_wake(a: Dictionary, at: float, _t: float) -> Dictionary:
	var L = 2.4
	var SLEEP = asg(PLANT, {"head": -0.28, "msy": -0.025, "tail1": 0.12, "tail2": 0.2, "tie": -0.12})
	var P = track(at, [
		[0.0, SLEEP],
		[0.12, asg(SLEEP, {"head": -0.3, "sy": -0.07, "sx": 0.04}), "o"],
		[0.36, {"th": 70.0, "hx": 0.02, "hy": 0.05, "lean": -8.0, "dy": -0.24, "sy": 0.1, "sx": -0.06, "head": 0.2, "armB": -0.6, "tie": 0.5, "tail1": -0.3, "tail2": -0.5}, "o3"],
		[0.55, {"th": 60.0, "lean": -4.0, "dy": -0.2, "sy": 0.05, "sx": -0.03, "head": 0.16, "armB": -0.5, "tie": 0.4, "tail1": -0.15, "tail2": -0.3}, "l"],
		[0.75, {"th": 10.0, "dy": 0.01, "sy": -0.08, "sx": 0.06, "head": -0.04, "armB": 0.1, "tie": -0.2, "tail1": 0.2, "tail2": 0.35}, "i"],
		[0.95, {"th": 4.0, "head": 0.06, "sy": 0.01}, "o"],
		[1.25, {"th": 4.0, "head": -0.17, "dx": 0.03, "lean": -3.0, "armB": 0.1}, "io"],
		[1.65, {"th": 4.0, "head": 0.18, "lean": 4.0, "dx": -0.01, "armB": -0.1}, "io"],
		[2.0, {"th": 0.0, "head": 0.0}, "io"],
		[L, {}, "io"],
	])
	var sh = bell(at, 0.4, 1.0); P.lean += S(at * 50) * 1.5 * sh
	var fx = func(ctx: Ctx, R: Dictionary):
		var s: float = R.H; var dr = dirf(a); var n = fp(R, "nose")
		var pk = seg(at, 0, 0.18)
		if pk < 1:
			if at < 0.06: snot(ctx, n.x + dr * s * 0.035, n.y + s * 0.05, s * 0.07 * (1 + at * 3), 1)
			else: lines(ctx, n.x + dr * s * 0.035, n.y + s * 0.05, s * 0.1 * (0.7 + pk), 7, 0, PI * 2, 1 - pk, "rgba(200,236,252,.95)")
		crayonText(ctx, "啵", n.x + dr * s * 0.18, n.y + s * 0.02 - pk * s * 0.05, s * 0.13, "#cdeeff", cl(bell(at, 0.02, 0.5) * 2))
		var top = fp(R, "top"); var ek = seg(at, 0.25, 0.4)
		crayonText(ctx, "！", top.x + dr * s * 0.18, top.y - s * 0.08, s * 0.28 * (ez("back", ek) if at < 0.4 else 1.0), "#ff6a4a", cl(bell(at, 0.22, 1.4) * 2.5))
		lines(ctx, top.x, top.y + s * 0.12, s * 0.3, 7, -PI * 0.95, -PI * 0.05, cl(bell(at, 0.25, 0.6) * 2), "#fff3c4", maxf(1, s * 0.012))
		for i in 2:
			var k = seg(at, 0.35 + i * 0.1, 0.9 + i * 0.1)
			if k > 0 and k < 1: drop(ctx, top.x - dr * s * (0.25 + i * 0.05) - dr * k * s * 0.12, top.y + s * (0.2 + i * 0.06) + k * k * s * 0.2, s * 0.022, -dr * 0.6, 1 - k)
		var g = _tipW(R, R.G * plantM(a)); var dk = seg(at, 0.12, 0.6)
		if dk > 0 and dk < 1:
			for sd in [-1.0, 1.0]: puff(ctx, g.x + sd * s * (0.05 + dk * 0.1), g.y - s * 0.02 - dk * s * 0.06, s * (0.04 + dk * 0.07), (1 - dk) * 0.85)
		var lk = seg(at, 0.72, 1.2); var g0: Vector2 = R.G * Vector2(0, 0)
		if lk > 0 and lk < 1:
			for sd in [-1.0, 1.0]: puff(ctx, g0.x + sd * s * (0.12 + lk * 0.1), g0.y - s * 0.02, s * (0.04 + lk * 0.05), (1 - lk) * 0.7)
	return {"P": P, "st": {"axe": "hand"}, "L": L, "fx": fx}

static func act_idle(_a: Dictionary, _at: float, _t: float) -> Dictionary: return {"P": Z(), "st": {"axe": "hand"}}

static func act(name: String, a: Dictionary, at: float, t: float) -> Dictionary:
	match name:
		"walk": return act_walk(a, at, t)
		"yawn": return act_yawn(a, at, t)
		"stretch": return act_stretch(a, at, t)
		"scratch": return act_scratch(a, at, t)
		"tap": return act_tap(a, at, t)
		"sweat": return act_sweat(a, at, t)
		"dust": return act_dust(a, at, t)
		"proud": return act_proud(a, at, t)
		"phone": return act_phone(a, at, t)
		"doze": return act_doze(a, at, t)
		"wake": return act_wake(a, at, t)
	return act_idle(a, at, t)

# ---------------- 登記到 DAILY ----------------
static func drawAct(name: String, ctx, a) -> bool:
	if DB.hero_female(): return false   # 女主未有斧頭骨架動畫，用一般立繪
	if not ok("afu__body") or not ok("afu__arm") or not (ok("afu__axe") or ok("afu__wpn")) or J.str(J.gp(a, "type")) != "afu" or _g("LIMBS_DATA") == null: return false
	if not (ctx is Ctx) or not (a is Dictionary): return false
	var o = a.o; var t = J.num(J.gp(o, "t")) if J.t(J.gp(o, "t")) else 0.0; var at = J.num(J.gp(o, "at")) if J.t(J.gp(o, "at")) else 0.0; var m = mem(a)
	var r = act(name, a, at, t)
	var P = addP(rest(t), r.P); var st: Dictionary = r.st
	if m.name != name:
		if m.P != null: m["from"] = m.P; m["fromSt"] = m.st; m["fromT"] = t; m["fromAt"] = at
		m["name"] = name
	var bk = cl((t - J.num(m.get("fromT"))) / BLEND) if m.get("from") != null else 1.0
	if m.get("from") != null and bk < 1:
		var k = ez("io", bk); P = lerpP(m.from, P, k)
		var fs = m.get("fromSt")
		if fs != null and J.str(fs.get("axe")) == "plant" and J.str(st.get("axe")) == "hand": st = asg(st, {"axe": "hand", "axeBlend": {"M": fs.plantM, "k": k}})
		if fs != null and gv(fs, "phone") > 0 and not (gv(st, "phone") > 0): st = asg(st, {"phone": gv(fs, "phone") * (1 - k)})
	else: m["from"] = null
	m["P"] = P; m["st"] = st
	var ax = J.num(a.x); var ay = J.num(a.y)
	if m.get("lx") != null and t > J.num(m.lt):
		var k2 = cl((t - m.lt) * 6)
		m["vx"] = (J.num(m.vx) if J.t(m.get("vx")) else 0.0) * (1 - k2) + (ax - m.lx) / (t - m.lt) * k2
		m["vy"] = (J.num(m.vy) if J.t(m.get("vy")) else 0.0) * (1 - k2) + (ay - m.ly) / (t - m.lt) * k2
	m["lx"] = ax; m["ly"] = ay; m["lt"] = t
	if r.get("stone") != null: drawStone(ctx, a, r.stone, m)
	if st.get("axeBlend") != null: return renderBlendAxe(ctx, a, P, st, t, r)
	var R = render(ctx, a, P, st, t)
	if r.get("fx") != null: ctx.save(); r.fx.call(ctx, R); ctx.restore()
	return true

# 斧頭插住嗰陣被打斷（去行路）：斧頭由地上飛返手（0.28 秒，矩陣內插）
static func renderBlendAxe(ctx: Ctx, a: Dictionary, P: Dictionary, st: Dictionary, t: float, r: Dictionary) -> bool:
	var s2 = asg(st, {"axe": "none"}); var R = render(ctx, a, P, s2, t)
	var A: Transform2D = R.G * st.axeBlend.M; var B: Transform2D = R.Mg; var k: float = st.axeBlend.k
	var a0 = atan2(A.x.y, A.x.x); var a1 = atan2(B.x.y, B.x.x); var da = a1 - a0
	while da > PI: da -= 2 * PI
	while da < -PI: da += 2 * PI
	var an = a0 + da * k; var sc = hyp(A.x.x, A.x.y) + (hyp(B.x.x, B.x.y) - hyp(A.x.x, A.x.y)) * k
	var det = signf(B.x.x * B.y.y - B.x.y * B.y.x)
	var Mx = Transform2D(Vector2(cos(an) * sc, sin(an) * sc), Vector2(-sin(an) * sc * det, cos(an) * sc * det), Vector2(A.origin.x + (B.origin.x - A.origin.x) * k, A.origin.y + (B.origin.y - A.origin.y) * k))
	var base: Transform2D = ctx.getTransform(); var wp = WP(); var gr = J.gp(wp, "grip")
	ctx.save(); ctx.setTransform(base * Mx); ctx.drawImage(AXE(), -v2(gr, 0) * R.ww, -v2(gr, 1) * R.wh, R.ww, R.wh); ctx.restore()
	var pv = J.gp(LD(), "pivot")
	ctx.save(); ctx.setTransform(base * R.Ma); ctx.drawImage(spr("afu__arm"), -v2(pv, 0) * R.W, -v2(pv, 1) * R.H, R.W, R.H); ctx.restore()
	if r.get("fx") != null: ctx.save(); r.fx.call(ctx, R); ctx.restore()
	return true

# 跳過嘅小石頭：位置記喺世界座標
static func drawStone(ctx: Ctx, a: Dictionary, st: Dictionary, m: Dictionary) -> void:
	var key = J.gp(a.o, "hid"); key = J.str(key) if J.t(key) else "hero"; var H = J.num(a.H)
	var s = stones.get(key)
	var sk: float = st.k
	if s == null or sk < s.k - 0.01:
		var T = (0.45 - sk) * 0.55; var vx = J.num(m.vx) if J.t(m.get("vx")) else 0.0; var vy = J.num(m.vy) if J.t(m.get("vy")) else 0.0; var sp = hyp(vx, vy)
		var dx = vx * T if sp > 3 else dirf(a) * H * 0.3; var dy = vy * T if sp > 3 else 0.0
		s = {"x": J.num(a.x) + dx, "y": J.num(a.y) + dy + H * 0.01, "k": sk}; stones[key] = s
	s["k"] = sk
	var al = cl(1 - absf(sk - 0.2) / 1.4) * cl((1.6 - sk) * 3)
	if al <= 0: return
	ctx.save(); ctx.globalAlpha *= al; ctx.translate(s.x, s.y); ctx.scale(1.35, 1.35)
	ctx.fillStyle = "rgba(0,0,0,.28)"; ctx.beginPath(); ctx.ellipse(0, H * 0.012, H * 0.07, H * 0.02, 0, 0, 7); ctx.fill()
	ctx.beginPath(); ctx.moveTo(-H * 0.06, 0); ctx.quadraticCurveTo(-H * 0.055, -H * 0.05, -H * 0.01, -H * 0.055); ctx.quadraticCurveTo(H * 0.05, -H * 0.05, H * 0.06, -H * 0.005); ctx.quadraticCurveTo(0, H * 0.012, -H * 0.06, 0); ctx.closePath()
	ctx.fillStyle = "#86828a"; ctx.fill(); ctx.lineWidth = maxf(0.8, H * 0.012); ctx.strokeStyle = "#2a2428"; ctx.stroke()
	ctx.fillStyle = "rgba(255,255,255,.18)"; ctx.beginPath(); ctx.ellipse(-H * 0.015, -H * 0.035, H * 0.025, H * 0.01, -0.2, 0, 7); ctx.fill()
	ctx.restore()

# ---------------- 村入面嘅小排程 ----------------
static func start(n: String) -> void:
	Q["cur"] = n; Q["at"] = 0.0
	if COOL.has(n): Q.cool[n] = COOL[n] * (0.8 + randf() * 0.5)
	Q["last"] = n
	if n == "doze": Q["dozeEnd"] = 14 + randf() * 10
static func stop() -> void:
	Q["cur"] = null; Q["at"] = 0.0; Q["idle"] = 0.0; Q["next"] = 3 + randf() * 4
static func update(V, dt: float) -> void:
	var H = J.gp(V, "hero")
	for k in Q.cool: Q.cool[k] = Q.cool[k] - dt
	var pr = J.num(J.gp(V, "proudT")) if J.t(J.gp(V, "proudT")) else 0.0
	var hact = J.gp(H, "act"); var ak = J.gp(hact, "kind") if J.t(hact) else null
	if pr > 0 and Q.prevProud <= 0:
		start("proud")
		if Q.lastKind == "tree": Q["after"] = "sweat" if randf() < 0.65 else null
		else: Q["after"] = "dust" if randf() < 0.6 else "sweat"
	elif Q.hadAct and not J.t(ak) and not J.t(J.gp(H, "walking")) and not J.t(J.gp(H, "target")) and Q.lastKind == "craft":
		start("dust" if randf() < 0.65 else "sweat")
	Q["prevProud"] = pr; Q["hadAct"] = J.t(ak)
	if J.t(ak): Q["lastKind"] = ak
	if J.t(J.gp(H, "walking")):
		if J.t(Q.cur): Q["cur"] = null
		Q["walkT"] = Q.walkT + dt; Q["idle"] = 0.0; return
	Q["walkT"] = 0.0
	if J.t(hact): Q["cur"] = null; Q["idle"] = 0.0; return
	if J.t(Q.cur):
		Q["at"] = Q.at + dt
		if Q.cur == "doze":
			if Q.at > 1.8 + Q.dozeEnd: start("wake")
			return
		if Q.at >= LEN[Q.cur]:
			var nx = Q.after; Q["after"] = null
			if J.t(nx) and Q.cur == "proud": start(nx)
			else: stop()
		return
	Q["idle"] = Q.idle + dt
	var STy = _g("Story")
	var busy = STy != null and J.t(J.gp(STy, "busy")) and J.t(J.mc(STy, "busy", []))
	if Q.idle >= Q.next and not busy:
		var c = []
		for e in PICK:
			var n: String = e[0]
			if not (Q.cool.has(n) and Q.cool[n] > 0) and n != Q.last and (n != "doze" or Q.idle > 8): c.append(e)
		if c.is_empty(): Q["next"] = Q.idle + 2; return
		var tot = 0.0
		for e in c: tot += e[1]
		var r = randf() * tot
		for e in c:
			r -= e[1]
			if r <= 0: start(e[0]); break
static func tap(V, x: float, y: float) -> bool:
	var H = J.gp(V, "hero")
	if Q.cur == "doze" and Q.at > 0.75:
		start("wake"); return hyp(x - J.num(J.gp(H, "x")), y - (J.num(J.gp(H, "y")) - 22)) < 40
	return false
static func opts(V):
	var H = J.gp(V, "hero")
	if J.t(J.gp(H, "walking")): return {"act": "hero_walk", "at": Q.walkT}
	if J.t(J.gp(H, "act")): return null
	if J.t(Q.cur): return {"act": "hero_" + J.str(Q.cur), "at": Q.at}
	return {"act": "hero_idle", "at": Q.idle}

static func reset() -> void:
	MEM = {}; stones = {}; RB = null
	LEN = {"yawn": 3.6, "stretch": 3.6, "scratch": 3.0, "tap": 3.4, "sweat": 2.8, "dust": 3.0, "proud": 2.2, "phone": 7.6, "wake": 2.4}
	PICK = [["yawn", 3.0], ["stretch", 2.0], ["phone", 2.2], ["scratch", 2.0], ["tap", 2.0], ["doze", 1.4]]
	COOL = {"yawn": 25.0, "stretch": 30.0, "phone": 35.0, "scratch": 22.0, "tap": 22.0, "doze": 50.0, "sweat": 10.0, "dust": 10.0}
	Q = {"cur": null, "at": 0.0, "idle": 0.0, "next": 4.0, "cool": {}, "last": null, "walkT": 0.0, "prevProud": 0.0, "hadAct": false, "lastKind": null, "dozeEnd": 0.0, "after": null}

func run(_env) -> void:
	reset()
	var DA = J.G.get("DAILY")
	if not (DA is Dictionary): DA = {}; J.G["DAILY"] = DA
	var ACT = {}
	for n in NAMES:
		var nn: String = n
		DA["hero_" + nn] = func(_t, a): return drawAct(nn, J.arg(a, 0), J.arg(a, 1))
		ACT[nn] = func(_t, a): return act(nn, J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)))
	J.G["HeroDaily"] = {
		"update": func(_t, a): update(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"tap": func(_t, a): return tap(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2))),
		"opts": func(_t, a): return opts(J.arg(a, 0)),
		"ACT": ACT, "LEN": LEN, "Q": Q,
		"rest": func(_t, a): return rest(J.num(J.arg(a, 0))),
		"track": func(_t, a): return track(J.num(J.arg(a, 0)), J.arg(a, 1)),
		"render": func(_t, a): return render(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.num(J.arg(a, 4))),
	}
