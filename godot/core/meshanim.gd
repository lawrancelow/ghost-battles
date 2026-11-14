# 原圖變形動畫（移植 meshanim.js）：把原圖鋪成網格，骨頭轉動時網格跟住彎，原圖貼上去。
extends Node

const GX := 14
const GY := 20
var RIG = {}
var NATIVE_R = {}
var _cache = {}

func _ready() -> void:
	RIG = DB.RIGS.get("RIG", {})
	NATIVE_R = DB.RIGS.get("NATIVE_R", {})

func has(id: String) -> bool:
	return RIG.has(id) and Spr.ok(id)

static func _seg_dist(px: float, py: float, ax: float, ay: float, bx: float, by: float) -> float:
	var dx = bx - ax; var dy = by - ay; var l = dx * dx + dy * dy
	if l == 0.0: l = 1e-6
	var t = clampf(((px - ax) * dx + (py - ay) * dy) / l, 0.0, 1.0)
	return Vector2(px - ax - t * dx, py - ay - t * dy).length()

func _build(R: Dictionary, tex: Texture2D) -> Dictionary:
	var B: Array = R.bones
	var ar = float(tex.get_height()) / tex.get_width()
	var uv = PackedVector2Array(); var W: Array = []
	for j in range(GY + 1):
		for i in range(GX + 1):
			var u = float(i) / GX; var v = float(j) / GY
			var w = PackedFloat32Array(); w.resize(B.size()); var sum = 0.0
			for k in B.size():
				var b: Array = B[k]
				var d = _seg_dist(u, v * ar, b[2], b[3] * ar, b[4], b[5] * ar) / float(b[6])
				var ww = exp(-d * d * 2.2)
				if b[1] == null: ww = maxf(ww, 0.05)
				w[k] = ww; sum += ww
			for k in w.size(): w[k] /= sum
			uv.push_back(Vector2(u, v)); W.append(w)
	# 透明格唔畫
	var img = tex.get_image()
	var tris = PackedInt32Array()
	if img and img.is_compressed(): img.decompress()
	var iw = tex.get_width(); var ih = tex.get_height()
	for j in range(GY):
		for i in range(GX):
			var hit = true
			if img:
				hit = false
				var x0 = maxi(0, int(floor(float(i) / GX * iw)) - 2); var x1 = mini(iw, int(ceil(float(i + 1) / GX * iw)) + 2)
				var y0 = maxi(0, int(floor(float(j) / GY * ih)) - 2); var y1 = mini(ih, int(ceil(float(j + 1) / GY * ih)) + 2)
				var y = y0
				while y < y1 and not hit:
					var x = x0
					while x < x1:
						if img.get_pixel(x, y).a > 4.0 / 255.0: hit = true; break
						x += 2
					y += 2
			if not hit: continue
			var a = j * (GX + 1) + i; var b2 = a + 1; var c = a + GX + 1; var d2 = c + 1
			tris.append_array([a, b2, c, b2, d2, c])
	return {"R": R, "uv": uv, "w": W, "ar": ar, "tris": tris}

func _solve(R: Dictionary, pose: Dictionary) -> Dictionary:
	var T = {}
	for b in R.bones:
		var n: String = b[0]; var par = b[1]; var px: float = b[2]; var py: float = b[3]
		var pv = pose.get(n); var a: float = 0.0 if pv == null else float(J.num(pv))
		var P: Array = T[par] if par != null and T.has(par) else [0.0, 0.0, 0.0]
		var ppx: float = cos(P[0]) * px - sin(P[0]) * py + P[1]
		var ppy: float = sin(P[0]) * px + cos(P[0]) * py + P[2]
		var A: float = P[0] + a
		T[n] = [A, ppx - (cos(A) * px - sin(A) * py), ppy - (sin(A) * px + cos(A) * py)]
	return T

const KEEP := {"y": 1, "sx": 1, "sy": 1}

# faceRight：面向畫面右邊
func draw(ctx: Ctx, id: String, x: float, y: float, h: float, pose: Dictionary, faceRight: bool) -> bool:
	var nr = NATIVE_R.has(id)
	var flip = faceRight != nr
	if not nr:
		var m = {}
		for k in pose:
			var v = pose[k]
			m[k] = -v if (v is float or v is int) and not KEEP.has(k) else v
		pose = m
	return draw_raw(ctx, id, x, y, h, pose, flip)

func draw_raw(ctx: Ctx, id: String, x: float, y: float, h: float, pose: Dictionary, flip: bool, rig_from := "") -> bool:
	var tex = Spr.get_tex(id)
	var rk = rig_from if rig_from != "" else id
	if tex == null or not RIG.has(rk): return false
	var C: Dictionary = _cache.get(id + "|" + rk, {})
	if C.is_empty():
		C = _build(RIG[rk], tex)
		_cache[id + "|" + rk] = C
	var R: Dictionary = C.R; var ar: float = C.ar
	var W = h / ar
	var T = _solve(R, pose); var bones: Array = R.bones
	var cs: Array = []
	for b in bones:
		var t: Array = T[b[0]]; cs.append([cos(t[0]), sin(t[0]), t[1], t[2]])
	var uv: PackedVector2Array = C.uv; var Wt: Array = C.w
	var pts = PackedVector2Array(); pts.resize(uv.size())
	for i in uv.size():
		var u = uv[i].x; var vy = uv[i].y * ar; var X = 0.0; var Y = 0.0
		var w: PackedFloat32Array = Wt[i]
		for k in bones.size():
			var wk = w[k]
			if wk < 0.002: continue
			var q: Array = cs[k]
			X += wk * (q[0] * u - q[1] * vy + q[2]); Y += wk * (q[1] * u + q[0] * vy + q[3])
		pts[i] = Vector2(X * W, Y / ar * h)
	ctx.save()
	ctx.translate(x + float(pose.get("x", 0.0)) * W, y + float(pose.get("y", 0.0)) * h)
	if flip: ctx.scale(-1, 1)
	var rot = float(pose.get("rot", 0.0))
	if rot != 0.0:
		ctx.translate(0, -h * 0.35); ctx.rotate(rot); ctx.translate(0, h * 0.35)
	ctx.scale(float(pose.get("sx", 1.0)), float(pose.get("sy", 1.0))); ctx.translate(-W / 2, -h)
	ctx.drawTriangles(tex, pts, uv, C.tris)
	ctx.restore()
	return true

# 拆咗手嘅身體：沿用原角色骨架（去掉手臂骨），畫喺原點，原圖方向
func draw_body(ctx: Ctx, rig_id: String, img_key: String, h: float, pose: Dictionary) -> bool:
	if not RIG.has(img_key) and RIG.has(rig_id):
		var bb: Array = []
		for b in RIG[rig_id].bones:
			if b[0] != "armF" and b[0] != "axe": bb.append(b)
		RIG[img_key] = {"bones": bb}
	return draw_raw(ctx, img_key, 0, 0, h, pose, false)

# ---------------- 動作 ----------------
static func _ease(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func _tail(t: float, k: float) -> Dictionary: return {"tail1": sin(t * 2.6) * 0.12 * k, "tail2": sin(t * 2.6 - 1) * 0.22 * k}
static func _merge(a: Dictionary, b: Dictionary) -> Dictionary:
	var o = a.duplicate(); o.merge(b, true); return o
static func _add(a: Dictionary, b: Dictionary) -> Dictionary:
	var o = a.duplicate()
	for k in b:
		if a.has(k) and k != "sx" and k != "sy" and (b[k] is float) and (a[k] is float): o[k] = a[k] + b[k]
		else: o[k] = b[k]
	return o

func idle(t: float) -> Dictionary:
	return _merge({"body": sin(t * 1.8) * 0.025, "head": sin(t * 1.3) * 0.05, "armF": sin(t * 1.8 + 0.5) * 0.05, "armB": sin(t * 1.8 + 1) * 0.06, "tie": sin(t * 5) * 0.18, "cape": sin(t * 2) * 0.06, "hairL": sin(t * 1.6) * 0.07, "hairR": sin(t * 1.6 + 1) * 0.07, "sy": 1 + sin(t * 1.8) * 0.015, "sx": 1 - sin(t * 1.8) * 0.008, "y": -0.03 - sin(t * 2.2) * 0.02, "legF": 0.0, "legB": 0.0}, _tail(t, 1))

func walk(t: float) -> Dictionary:
	return _merge({"body": 0.10, "head": -0.04 + sin(t * 7) * 0.03, "armF": sin(t * 7) * 0.22, "armB": -sin(t * 7) * 0.22, "tie": -0.3 + sin(t * 9) * 0.2, "cape": -0.15 + sin(t * 7) * 0.08, "hairL": -0.12, "hairR": -0.18, "legF": sin(t * 7) * 0.32, "legB": -sin(t * 7) * 0.32, "y": -absf(sin(t * 7)) * 0.02 - 0.03}, _tail(t * 2, 1.6))

func scared(t: float) -> Dictionary:
	var p = fmod(t, 1.6) / 1.6; var jump = 0.0; var sq = 0.0
	if p < 0.1: sq = p / 0.1
	elif p < 0.35: jump = sin((p - 0.1) / 0.25 * PI); sq = -jump * 0.6
	var sh = sin(t * 45) * 0.03 if p > 0.35 else 0.0
	return _merge({"body": -0.1 * jump + sh, "head": -0.2 * jump + sh * 2, "armF": 0.6 * jump + sh, "armB": -0.6 * jump - sh, "legF": 0.25 * jump, "legB": -0.2 * jump, "hairL": -0.3 * jump, "hairR": -0.3 * jump, "x": sh * 0.4, "y": -0.16 * jump - 0.02, "sx": 1 + 0.08 * sq, "sy": 1 - 0.1 * sq}, _tail(t, 1.5))

const BIG := {"afu": 1, "xiaozhi": 1, "zhiren": 1, "youhun": 1, "laojiang": 1, "zombie": 1}
func _swing(id: String, k: float) -> Dictionary:
	if id == "afu": return {"armF": -0.75 * minf(k, 1.0) - 0.15 * maxf(0, k - 1), "axe": -0.45 * minf(k, 1.2)}
	if BIG.has(id): return {"armB": -0.9 * k, "armF": 0.3 * k}
	return {"armB": -0.6 * k, "armF": 0.18 * k}

func windup(p: float, t: float, id: String) -> Dictionary:
	var k = _ease(minf(1, p))
	return _add(idle(t), _merge({"body": -0.14 * k, "head": -0.10 * k, "x": -0.05 * k, "sx": 1 - 0.05 * k, "sy": 1 + 0.05 * k, "legF": -0.15 * k, "legB": 0.12 * k, "hairL": 0.1 * k, "hairR": 0.1 * k}, _swing(id, -0.9 * k)))
func strike(p: float, t: float, id: String) -> Dictionary:
	var k = minf(1, p * 1.8); var e = 1 - (1 - k) * (1 - k)
	return _add(idle(t), _merge({"body": 0.20 * e, "head": 0.10 * e, "x": 0.18 * e, "sx": 1 + 0.08 * e, "sy": 1 - 0.06 * e, "legF": 0.14 * e, "legB": -0.12 * e, "hairL": -0.2 * e, "hairR": -0.25 * e, "tie": -0.4 * e, "cape": -0.3 * e}, _swing(id, -0.9 + 2.2 * e)))
func follow(p: float, t: float, id: String) -> Dictionary:
	var q = minf(1, p); var e = 1 - pow(1 - q, 3)
	return _add(idle(t), _merge({"body": 0.20 + 0.10 * e, "head": 0.10 + 0.08 * e, "x": 0.18 + 0.04 * e, "sx": 1 + 0.08 - 0.05 * e, "sy": 1 - 0.06 + 0.04 * e, "legF": 0.14 + 0.06 * e, "legB": -0.12 - 0.06 * e, "hairL": -0.2 - 0.15 * e, "hairR": -0.25 - 0.15 * e, "tie": -0.4 - 0.3 * e, "cape": -0.3 - 0.2 * e}, _swing(id, 1.3 + 0.75 * e)))
func recover(p: float, t: float, id: String) -> Dictionary:
	var k = 1 - _ease(minf(1, p))
	return _add(idle(t), _merge({"body": 0.3 * k, "head": 0.18 * k, "x": 0.22 * k, "legF": 0.2 * k, "legB": -0.18 * k, "hairL": -0.35 * k, "hairR": -0.4 * k}, _swing(id, 2.05 * k)))
func hurtP(p: float, t: float) -> Dictionary:
	var k = p / 0.15 if p < 0.15 else maxf(0, 1 - (p - 0.15) / 0.85)
	return _add(idle(t), {"body": -0.22 * k, "head": -0.3 * k + sin(t * 50) * 0.05 * k, "armF": 0.5 * k, "armB": -0.5 * k, "x": -0.10 * k, "sx": 1 - 0.07 * k, "sy": 1 + 0.06 * k, "hairL": 0.3 * k, "hairR": 0.3 * k})
func cast(p: float, t: float) -> Dictionary:
	var k = _ease(minf(1, p * 1.4)); var sh = sin(t * 30) * 0.03 * k
	return _add(idle(t), {"body": -0.08 * k + sh, "head": -0.18 * k, "armF": 0.85 * k, "armB": -0.85 * k, "y": -0.06 * k, "sx": 1 + 0.04 * k, "sy": 1 + 0.06 * k, "hairL": -0.4 * k, "hairR": 0.4 * k, "legF": 0.15 * k, "legB": -0.15 * k})
func die(p: float, _t: float) -> Dictionary:
	var k = _ease(minf(1, p))
	return _add(idle(0), {"body": -0.2 * k, "head": -0.4 * k, "armF": 0.8 * k, "armB": -0.8 * k, "rot": -1.35 * k, "x": -0.25 * k, "y": 0.02 * k})

# art.js meshPose
func pose_for(type: String, o: Dictionary) -> Dictionary:
	var t: float = o.get("t", 0.0); var p = clampf(float(o.get("pt", 0.0)), 0, 1)
	var pose = o.get("pose")
	var atk = func(q: float) -> Dictionary: return windup(q / 0.72, t, type) if q < 0.72 else strike((q - 0.72) / 0.28, t, type)
	match pose:
		"windup": return windup(p, t, type)
		"strike": return strike(p, t, type)
		"follow": return follow(p, t, type)
		"recover": return recover(p, t, type)
		"cast": return cast(p, t)
		"die", "faint": return die(p, t)
		"hurt": return hurtP(p, t)
		"scared", "startle", "tremble", "cower": return scared(t)
		"chop": return atk.call(p)
		"hammer": return atk.call(fmod(p * 2, 1.0))
		"reap": return strike(absf(sin(p * PI * 3)), t, type)
		"knead":
			var z = idle(t); z.body = 0.15 + sin(p * PI * 4) * 0.05; z.y = float(z.get("y", 0)) + absf(sin(p * PI * 4)) * 0.02; z.armF = 0.3; z.armB = -0.3; return z
		"proud":
			var z2 = idle(t); z2.head = -0.12; z2.body = -0.05; return z2
		"run", "move", "walk": return walk(t * (1.8 if pose == "run" else 1.0))
	if o.get("hurt", false): return hurtP(0.3, t)
	if o.get("atk", false): return strike(0.6, t, type)
	if o.get("walk", false): return walk(t)
	return idle(t)

# 轉譯版 meshanim.js 嘅 drawRaw 交俾呢度（rig = JS 嗰邊嘅 RIG[id]，可能係 n30_rigs 加嘅）
var _jcache := {}
var _warned := {}
var prof_us := 0
var prof_n := 0
func draw_js(ctx, id: String, rig, x: float, y: float, h: float, pose: Dictionary, flip: bool) -> bool:
	var __t0 = Time.get_ticks_usec()
	var __r = _draw_js(ctx, id, rig, x, y, h, pose, flip)
	prof_us += Time.get_ticks_usec() - __t0; prof_n += 1
	return __r
func _draw_js(ctx, id: String, rig, x: float, y: float, h: float, pose: Dictionary, flip: bool) -> bool:
	if not (ctx is Ctx):
		if not _warned.has(id): _warned[id] = 1; push_warning("meshDraw 冇 ctx: %s %s" % [id, typeof(ctx)])
		return false
	var tex := Spr.get_tex(id)
	if tex == null or rig == null: return false
	var C: Dictionary = _jcache.get(id, {})
	if C.is_empty() or C.R != rig:
		var bones: Array = rig.get("bones", [])
		C = _build({"bones": bones}, tex); C.R = rig; _jcache[id] = C
	var ar: float = C.ar; var W := h / ar
	var bones2: Array = rig.get("bones", [])
	var T := _solve({"bones": bones2}, pose)
	var cs: Array = []
	for b in bones2:
		var t: Array = T[b[0]]; cs.append([cos(t[0]), sin(t[0]), t[1], t[2]])
	var uv: PackedVector2Array = C.uv; var Wt: Array = C.w
	var pts := PackedVector2Array(); pts.resize(uv.size())
	for i in uv.size():
		var u := uv[i].x; var vy := uv[i].y * ar; var X := 0.0; var Y := 0.0
		var w: PackedFloat32Array = Wt[i]
		for k in bones2.size():
			var wk := w[k]
			if wk < 0.002: continue
			var q: Array = cs[k]
			X += wk * (q[0] * u - q[1] * vy + q[2]); Y += wk * (q[1] * u + q[0] * vy + q[3])
		pts[i] = Vector2(X * W, Y / ar * h)
	ctx.save()
	ctx.translate(x + float(J.num(pose.get("x", 0.0))) * W, y + float(J.num(pose.get("y", 0.0))) * h)
	if flip: ctx.scale(-1, 1)
	var rot := J.num(pose.get("rot", 0.0))
	if rot != 0.0 and not is_nan(rot):
		ctx.translate(0, -h * 0.35); ctx.rotate(rot); ctx.translate(0, h * 0.35)
	var sx = pose.get("sx"); var sy = pose.get("sy")
	ctx.scale(J.num(sx) if sx != null else 1.0, J.num(sy) if sy != null else 1.0); ctx.translate(-W / 2, -h)
	ctx.drawTriangles(tex, pts, uv, C.tris)
	ctx.restore()
	return true
