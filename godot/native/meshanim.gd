# 原生改寫自 meshanim.js（原圖變形動畫）
# - RIG／NATIVE_R：網頁原碼倒出嚟（data/meshanim_rig.json），其他模塊（n30_rigs、drawBody）會再加入
# - ANIM：逐條照網頁原碼（唔跟轉譯版：轉譯版 idle 有錯）
# - 畫：交俾 core/meshanim.gd 嘅 draw_js（同 patches.js 嘅 __nat_meshDraw 一樣）
extends RefCounted

const KEEP := {"y": 1, "sx": 1, "sy": 1}
const BIG := {"afu": 1, "xiaozhi": 1, "zhiren": 1, "youhun": 1, "laojiang": 1, "zombie": 1}

static var RIG: Dictionary = {}
static var NATIVE_R: Dictionary = {}

static func S(x: float) -> float: return sin(x)
static func ez(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func jmod(a: float, b: float) -> float: return fmod(a, b)

static func tail(t: float, k: float) -> Dictionary: return {"tail1": S(t * 2.6) * 0.12 * k, "tail2": S(t * 2.6 - 1) * 0.22 * k}
static func assign(a: Dictionary, b: Dictionary) -> Dictionary:
	var o = a.duplicate()
	for k in b: o[k] = b[k]
	return o

static func idle(t: float) -> Dictionary:
	return assign({"body": S(t * 1.8) * 0.025, "head": S(t * 1.3) * 0.05, "armF": S(t * 1.8 + 0.5) * 0.05, "armB": S(t * 1.8 + 1) * 0.06, "tie": S(t * 5) * 0.18, "cape": S(t * 2) * 0.06,
		"hairL": S(t * 1.6) * 0.07, "hairR": S(t * 1.6 + 1) * 0.07, "sy": 1 + S(t * 1.8) * 0.015, "sx": 1 - S(t * 1.8) * 0.008, "y": -0.03 - S(t * 2.2) * 0.02, "legF": 0.0, "legB": 0.0}, tail(t, 1))

static func walk(t: float) -> Dictionary:
	return assign({"body": 0.10, "head": -0.04 + S(t * 7) * 0.03, "armF": S(t * 7) * 0.22, "armB": -S(t * 7) * 0.22, "tie": -0.3 + S(t * 9) * 0.2, "cape": -0.15 + S(t * 7) * 0.08,
		"hairL": -0.12, "hairR": -0.18, "legF": S(t * 7) * 0.32, "legB": -S(t * 7) * 0.32, "y": -absf(S(t * 7)) * 0.02 - 0.03}, tail(t * 2, 1.6))

static func attack(t: float) -> Dictionary:
	var p = jmod(t, 1.4) / 1.4; var k: float
	if p < 0.4: k = -ez(p / 0.4)
	elif p < 0.5: k = -1 + 2.4 * ((p - 0.4) / 0.1)
	elif p < 0.62: k = 1.4
	else: k = 1.4 * (1 - ez((p - 0.62) / 0.38))
	return assign({"body": 0.12 * k, "head": 0.06 * k, "armF": -0.9 * k if k > 0 else -1.0 * k, "axe": -0.5 * k if k > 0 else -0.3 * k, "armB": 0.25 * k, "tie": -0.3 * absf(k), "cape": -0.2 * k,
		"hairL": -0.15 * k, "hairR": -0.2 * k, "x": 0.10 * maxf(0, k), "sx": 1 + 0.05 * maxf(0, k), "sy": 1 - 0.04 * maxf(0, k), "y": -0.03, "legF": 0.2 * k, "legB": -0.1 * k}, tail(t, 1 + absf(k)))

static func hurt(t: float) -> Dictionary:
	var p = jmod(t, 1.2) / 1.2; var k = p / 0.08 if p < 0.08 else maxf(0, 1 - (p - 0.08) / 0.5)
	return assign({"body": -0.18 * k, "head": -0.25 * k + S(t * 40) * 0.04 * k, "armF": 0.4 * k, "armB": -0.4 * k, "tie": 0.4 * k, "x": -0.08 * k, "sx": 1 - 0.05 * k, "sy": 1 + 0.05 * k, "y": -0.03 - 0.03 * k}, tail(t, 1))

static func scared(t: float) -> Dictionary:
	var p = jmod(t, 1.6) / 1.6; var jump = 0.0; var sq = 0.0
	if p < 0.1: sq = p / 0.1
	elif p < 0.35: jump = sin((p - 0.1) / 0.25 * PI); sq = -jump * 0.6
	else: sq = 0.0
	var sh = S(t * 45) * 0.03 if p > 0.35 else 0.0
	return assign({"body": -0.1 * jump + sh, "head": -0.2 * jump + sh * 2, "armF": 0.6 * jump + sh, "armB": -0.6 * jump - sh, "legF": 0.25 * jump, "legB": -0.2 * jump, "hairL": -0.3 * jump, "hairR": -0.3 * jump,
		"x": sh * 0.4, "y": -0.16 * jump - 0.02, "sx": 1 + 0.08 * sq, "sy": 1 - 0.1 * sq}, tail(t, 1.5))

static func base(t: float) -> Dictionary: return idle(t)
static func add(a: Dictionary, b: Dictionary) -> Dictionary:
	var o = a.duplicate()
	for k in b:
		var bn = b[k] is float or b[k] is int; var an = a.get(k) is float or a.get(k) is int
		o[k] = float(a[k]) + float(b[k]) if bn and an and k != "sx" and k != "sy" else b[k]
	return o
static func swing(id: String, k: float) -> Dictionary:
	if id == "afu": return {"armF": -0.75 * minf(k, 1.0) - 0.15 * maxf(0, k - 1), "axe": -0.45 * minf(k, 1.2)}
	if BIG.has(id): return {"armB": -0.9 * k, "armF": 0.3 * k}
	return {"armB": -0.6 * k, "armF": 0.18 * k}

static func windup(p: float, t: float, id: String) -> Dictionary:
	var k = ez(minf(1, p))
	return add(base(t), assign({"body": -0.14 * k, "head": -0.10 * k, "x": -0.05 * k, "sx": 1 - 0.05 * k, "sy": 1 + 0.05 * k, "legF": -0.15 * k, "legB": 0.12 * k, "hairL": 0.1 * k, "hairR": 0.1 * k}, swing(id, -0.9 * k)))
static func strike(p: float, t: float, id: String) -> Dictionary:
	var k = minf(1, p * 1.8); var e = 1 - (1 - k) * (1 - k)
	return add(base(t), assign({"body": 0.20 * e, "head": 0.10 * e, "x": 0.18 * e, "sx": 1 + 0.08 * e, "sy": 1 - 0.06 * e, "legF": 0.14 * e, "legB": -0.12 * e, "hairL": -0.2 * e, "hairR": -0.25 * e, "tie": -0.4 * e, "cape": -0.3 * e}, swing(id, -0.9 + 2.2 * e)))
static func follow(p: float, t: float, id: String) -> Dictionary:
	var q = minf(1, p); var e = 1 - pow(1 - q, 3)
	return add(base(t), assign({"body": 0.20 + 0.10 * e, "head": 0.10 + 0.08 * e, "x": 0.18 + 0.04 * e, "sx": 1 + 0.08 - 0.05 * e, "sy": 1 - 0.06 + 0.04 * e, "legF": 0.14 + 0.06 * e, "legB": -0.12 - 0.06 * e,
		"hairL": -0.2 - 0.15 * e, "hairR": -0.25 - 0.15 * e, "tie": -0.4 - 0.3 * e, "cape": -0.3 - 0.2 * e}, swing(id, 1.3 + 0.75 * e)))
static func recover(p: float, t: float, id: String) -> Dictionary:
	var k = 1 - ez(minf(1, p))
	return add(base(t), assign({"body": 0.3 * k, "head": 0.18 * k, "x": 0.22 * k, "legF": 0.2 * k, "legB": -0.18 * k, "hairL": -0.35 * k, "hairR": -0.4 * k}, swing(id, 2.05 * k)))
static func hurt_p(p: float, t: float) -> Dictionary:
	var k = p / 0.15 if p < 0.15 else maxf(0, 1 - (p - 0.15) / 0.85)
	return add(base(t), {"body": -0.22 * k, "head": -0.3 * k + sin(t * 50) * 0.05 * k, "armF": 0.5 * k, "armB": -0.5 * k, "x": -0.10 * k, "sx": 1 - 0.07 * k, "sy": 1 + 0.06 * k, "hairL": 0.3 * k, "hairR": 0.3 * k})
static func cast(p: float, t: float) -> Dictionary:
	var k = ez(minf(1, p * 1.4)); var sh = sin(t * 30) * 0.03 * k
	return add(base(t), {"body": -0.08 * k + sh, "head": -0.18 * k, "armF": 0.85 * k, "armB": -0.85 * k, "y": -0.06 * k, "sx": 1 + 0.04 * k, "sy": 1 + 0.06 * k, "hairL": -0.4 * k, "hairR": 0.4 * k, "legF": 0.15 * k, "legB": -0.15 * k})
static func die(p: float, _t: float) -> Dictionary:
	var k = ez(minf(1, p))
	return add(base(0), {"body": -0.2 * k, "head": -0.4 * k, "armF": 0.8 * k, "armB": -0.8 * k, "rot": -1.35 * k, "x": -0.25 * k, "y": 0.02 * k})
static func air(p: float, t: float) -> Dictionary:
	var k = sin(minf(1, p) * PI)
	return add(base(t), {"rot": -minf(1, p) * 6.283, "y": -0.55 * k, "armF": 0.9, "armB": -0.9, "head": -0.3, "legF": 0.4, "legB": -0.4})
static func down(_p: float, t: float) -> Dictionary:
	return add(base(t * 0.3), {"rot": -1.5, "x": -0.2, "y": 0.03, "head": -0.2, "armF": 0.4, "armB": -0.3})

# 通用骨架（同 meshanim.js mk）
static func mk(o: Dictionary) -> Dictionary:
	var B = []; var legs = o.get("legs"); var top = J.num(legs[0]) if J.t(legs) else 0.72
	var c = J.num(o.c); var n = J.num(o.n)
	if J.t(legs):
		B.append(["hips", null, c, J.num(legs[0]), c, n + 0.15, 0.22])
		B.append(["legF", "hips", J.num(legs[1]), J.num(legs[0]) + 0.02, J.num(legs[1]), 0.98, 0.10]); B.append(["legB", "hips", J.num(legs[2]), J.num(legs[0]) + 0.02, J.num(legs[2]), 0.98, 0.10])
		B.append(["body", "hips", c, J.num(legs[0]) - 0.05, c, n, 0.26])
	else:
		B.append(["body", null, c, top, c, n, 0.30])
		var tx = J.num(o.tail) if o.get("tail") != null else c
		B.append(["tail1", "body", c, 0.80, (c + tx) / 2, 0.90, 0.16]); B.append(["tail2", "tail1", (c + tx) / 2, 0.90, tx, 1.0, 0.14])
	var h = J.num(o.h) if o.get("h") != null else c
	B.append(["head", "body", h, n, h, J.num(o.ht) if o.get("ht") != null else 0.12, J.num(o.hr) if J.t(o.get("hr")) else 0.28])
	var ar = J.num(o.ar) if J.t(o.get("ar")) else 0.12
	if J.t(o.get("L")): B.append(["armF", "body", J.num(o.L[0]), J.num(o.L[1]), J.num(o.L[2]), J.num(o.L[3]), ar])
	if J.t(o.get("R")): B.append(["armB", "body", J.num(o.R[0]), J.num(o.R[1]), J.num(o.R[2]), J.num(o.R[3]), ar])
	if J.t(o.get("hair")):
		var hr = o.hair
		B.append(["hairL", "head", J.num(hr[0]), n - 0.02, J.num(hr[0]) - 0.05, n + 0.3, 0.13]); B.append(["hairR", "head", J.num(hr[1]), n - 0.02, J.num(hr[1]) + 0.05, n + 0.3, 0.13])
	return {"bones": B, "legs": J.t(legs), "hop": J.t(o.get("hop"))}

static func _core(): return Engine.get_main_loop().root.get_node("MeshAnim")

static func draw_raw(ctx, id: String, x: float, y: float, h: float, pose: Dictionary, flip: bool) -> bool:
	return _core().draw_js(ctx, id, RIG.get(id), x, y, h, pose, flip)

static func draw(ctx, id: String, x: float, y: float, h: float, pose: Dictionary, face_right: bool) -> bool:
	var nr = J.t(NATIVE_R.get(id)); var flip = face_right != nr
	if not nr:
		var m = {}
		for k in pose: m[k] = -float(pose[k]) if (pose[k] is float or pose[k] is int) and not KEEP.has(k) else pose[k]
		pose = m
	return draw_raw(ctx, id, x, y, h, pose, flip)

static func draw_body(ctx, rig_id: String, img_key: String, h: float, pose: Dictionary) -> bool:
	if not RIG.has(img_key) and RIG.has(rig_id):
		var bb = []
		for b in RIG[rig_id].bones: if b[0] != "armF" and b[0] != "axe": bb.append(b)
		RIG[img_key] = {"bones": bb}
	return draw_raw(ctx, img_key, 0.0, 0.0, h, pose, false)

static func _n(a, i): return J.num(J.arg(a, i))

func run(_env) -> void:
	var d = JSON.parse_string(FileAccess.get_file_as_string("res://data/meshanim_rig.json"))
	RIG = d.RIG; NATIVE_R = d.NATIVE_R
	var ANIM = {
		"idle": func(_t, a): return idle(_n(a, 0)),
		"walk": func(_t, a): return walk(_n(a, 0)),
		"attack": func(_t, a): return attack(_n(a, 0)),
		"hurt": func(_t, a): return hurt(_n(a, 0)),
		"scared": func(_t, a): return scared(_n(a, 0)),
		"windup": func(_t, a): return windup(_n(a, 0), _n(a, 1), J.str(J.arg(a, 2))),
		"strike": func(_t, a): return strike(_n(a, 0), _n(a, 1), J.str(J.arg(a, 2))),
		"follow": func(_t, a): return follow(_n(a, 0), _n(a, 1), J.str(J.arg(a, 2))),
		"recover": func(_t, a): return recover(_n(a, 0), _n(a, 1), J.str(J.arg(a, 2))),
		"hurtP": func(_t, a): return hurt_p(_n(a, 0), _n(a, 1)),
		"cast": func(_t, a): return cast(_n(a, 0), _n(a, 1)),
		"die": func(_t, a): return die(_n(a, 0), _n(a, 1)),
		"air": func(_t, a): return air(_n(a, 0), _n(a, 1)),
		"down": func(_t, a): return down(_n(a, 0), _n(a, 1)),
	}
	var nogl = [false]
	J.G["MeshAnim"] = {
		"drawBody": func(_t, a): return draw_body(a[0], J.str(a[1]), J.str(a[2]), _n(a, 3), a[4] if J.arg(a, 4) is Dictionary else {}),
		"draw": func(_t, a): return draw(a[0], J.str(a[1]), _n(a, 2), _n(a, 3), _n(a, 4), a[5] if J.arg(a, 5) is Dictionary else {}, J.t(J.arg(a, 6))),
		"ANIM": ANIM, "RIG": RIG, "NATIVE_R": NATIVE_R,
		"mk": func(_t, a): return mk(a[0] if J.arg(a, 0) is Dictionary else {}),
		"gl": func(_t, a): nogl[0] = not J.t(J.arg(a, 0)); return null,
		"has": func(_t, a):
			var id = J.str(J.arg(a, 0)); var so = J.G.get("sprOk")
			return RIG.has(id) and J.t(RIG[id]) and so != null and J.t(J.cl(so, null, [id])),
	}
