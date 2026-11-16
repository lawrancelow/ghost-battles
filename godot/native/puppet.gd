# 原生改寫自 puppet.js：木偶貼片動畫（頭、身、上臂＋前臂，工具揸喺手）
# 介面同轉譯版一樣：J.G["Puppet"] = { addTool, TOOLS, armed, has, draw, ANIMS, tipWorld, RIGS, addRigs }；J.G["PUPPET_ON"] = false（木偶分件目前關閉）
# 數字一律用 float（同 JS 一樣），姿勢字典嘅 key 次序同 JS Object.assign 一致
extends RefCounted

const BASE := {"lean": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0, "head": 0.0, "hk": "n", "aF": 0.15, "eF": 0.1, "aB": -0.12, "eB": 0.15, "tool": null, "tr": -1.57, "ik": 0.0, "tail": 0.0, "lF": 0.0, "lB": 0.0, "jx": 0.0}
const CHOP_STRIKE := {"lean": 0.22, "dy": 3.0, "sx": 1.04, "sy": 0.95, "head": 0.18, "hk": "s", "aF": 1.0, "eF": -0.1, "aB": 0.55, "eB": 0.5, "tool": "axe", "tr": -3.0, "ik": 1.0}
const CHOP_UP := {"lean": -0.16, "dy": -5.0, "sx": 0.96, "sy": 1.05, "head": -0.2, "hk": "s", "aF": 3.35, "eF": 0.35, "aB": 2.6, "eB": 0.4, "tool": "axe", "tr": -1.5, "ik": 1.0}
const CLAW_UP := {"lean": -0.18, "dy": -3.0, "sx": 0.96, "sy": 1.04, "head": -0.15, "hk": "a", "aF": -1.1, "eF": -0.9, "aB": -0.7, "eB": -0.5}
const CLAW_HIT := {"lean": 0.3, "dy": 2.0, "sx": 1.05, "sy": 0.96, "head": 0.12, "hk": "a", "aF": 1.65, "eF": -0.15, "aB": 1.2, "eB": 0.1}
const NAMES := ["idle", "move", "chop", "hammer", "knead", "reap", "windup", "strike", "recover", "windupC", "strikeC", "recoverC", "cast", "proud", "die", "hurt",
	"walk", "run", "startle", "cower", "tremble", "phone", "look", "mop", "faint", "sip", "stand", "hold", "shrug"]
const T_ONLY := ["idle", "move", "walk", "run", "look", "mop", "sip", "stand", "hold"]   # 呢啲只收 t

static var RIGS: Dictionary = {}
static var TOOLS: Dictionary = {}
static var MIRRORED: Array = []

static func _g(n: String): return J.G.get(n)

# ---------- 姿勢 ----------
static func A(base: Dictionary, o: Dictionary) -> Dictionary:   # Object.assign({}, base, o)
	var r = base.duplicate()
	for k in o: r[k] = o[k]
	return r
static func H_(o: Dictionary) -> Dictionary: return A(BASE, o)
static func ez(e: String, t: float) -> float:
	match e:
		"lin": return t
		"in": return t * t
		"out": return 1 - (1 - t) * (1 - t)
		"back":
			var c = 1.9
			return 1 + (c + 1) * pow(t - 1, 3) + c * pow(t - 1, 2)
	return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)   # io
static func _isnum(v) -> bool: return v is float or v is int
static func mix(a: Dictionary, b: Dictionary, k: float) -> Dictionary:
	var o = {}
	for key in a:
		var va = a[key]; var vb = b.get(key)
		o[key] = va + (vb - va) * k if _isnum(va) and _isnum(vb) else (va if k < 0.5 else vb)
	return o
static func keys(list: Array, p: float) -> Dictionary:
	if p <= list[0][0]: return A(BASE, list[0][1])
	for i in range(1, list.size()):
		if p <= list[i][0]:
			var t0 = list[i - 1][0]; var a = list[i - 1][1]; var t1 = list[i][0]; var b = list[i][1]
			var e = list[i][2] if list[i].size() > 2 else "io"
			return mix(A(BASE, a), A(BASE, b), ez(e, (p - t0) / (t1 - t0)))
	return A(BASE, list[-1][1])

static func anim(name: String, p: float, t: float) -> Dictionary:
	match name:
		"idle":
			var b = sin(t * 2.2)
			return A(BASE, {"dy": b * 2.5, "sy": 1 + b * 0.012, "sx": 1 - b * 0.008, "head": sin(t * 1.1) * 0.05, "aF": 0.35 + sin(t * 1.7) * 0.06, "eF": 0.55 + sin(t * 1.7 + 0.6) * 0.08, "aB": -0.3 + sin(t * 1.7 + 1) * 0.05, "eB": 0.5, "tail": t, "tool": null})
		"move":
			var s = sin(t * 7)
			return A(BASE, {"lean": 0.2, "dy": absf(cos(t * 7)) * -3, "head": 0.05 + s * 0.04, "aF": -0.35 + s * 0.55, "eF": 0.35, "aB": 0.25 - s * 0.55, "eB": 0.35, "tail": t * 2.6})
		"chop":   # 砍樹：一下 = 一個循環；循環結束嗰刻砍中
			return A(keys([[0.0, CHOP_STRIKE], [0.16, CHOP_STRIKE], [0.5, A(CHOP_UP, {"aF": 2.6, "aB": 2.2, "lean": -0.1, "hk": "n"}), "io"], [0.8, CHOP_UP, "out"], [1.0, CHOP_STRIKE, "in"]], p), {"tail": t})
		"hammer":   # 錘棺材板：兩下一份
			var q = fmod(p * 2, 1.0)
			var up = {"lean": -0.02, "dy": -3.0, "head": -0.12, "hk": "s", "aF": 2.7, "eF": 0.5, "aB": 0.6, "eB": 0.9, "tool": "mallet", "tr": -1.7}
			var dn = {"lean": 0.25, "dy": 3.0, "sx": 1.03, "sy": 0.96, "head": 0.25, "hk": "s", "aF": 0.75, "eF": 0.35, "aB": 0.7, "eB": 0.9, "tool": "mallet", "tr": -3.2}
			return A(keys([[0.0, dn], [0.12, dn], [0.7, up, "io"], [1.0, dn, "in"]], q), {"tail": t})
		"knead":   # 揉壽包
			var a = sin(p * PI * 4); var b = sin(p * PI * 4 + PI)
			return A(BASE, {"lean": 0.42 + a * 0.04, "dy": 2 + absf(a) * 2, "head": 0.3, "hk": "p" if p > 0.85 else "s", "aF": 0.9 + a * 0.35, "eF": 0.5 - a * 0.25, "aB": 0.95 + b * 0.35, "eB": 0.45 - b * 0.25, "tail": t, "sx": 1 + maxf(0.0, a) * 0.03, "sy": 1 - maxf(0.0, a) * 0.03})
		"reap":   # 割稻
			var w = sin(p * PI * 6)
			return A(BASE, {"lean": 0.55, "dy": 4.0, "head": 0.28 + w * 0.05, "hk": "p" if p > 0.85 else "s", "aF": 0.4 + w * 0.75, "eF": 0.25, "aB": 0.85 - w * 0.2, "eB": 0.6, "tool": "sickle", "tr": -1.3 - w * 0.25, "tail": t})
		"windup": return A(mix(A(BASE, {"tool": "_W", "tr": -1.4, "ik": 1.0}), CHOP_UP, ez("out", minf(1.0, p))), {"tail": t})
		"strike": return A(mix(CHOP_UP, CHOP_STRIKE, ez("out", minf(1.0, p * 1.6))), {"tail": t})
		"recover": return A(mix(CHOP_STRIKE, A(BASE, {"tool": "_W", "tr": -1.4}), ez("io", minf(1.0, p))), {"tail": t})
		"windupC": return A(mix(BASE, CLAW_UP, ez("out", minf(1.0, p))), {"tail": t})
		"strikeC": return A(mix(CLAW_UP, CLAW_HIT, ez("out", minf(1.0, p * 1.6))), {"tail": t})
		"recoverC": return A(mix(CLAW_HIT, BASE, ez("io", minf(1.0, p))), {"tail": t})
		"cast":
			var w2 = sin(t * 18) * 0.06
			return A(BASE, {"lean": -0.12, "dy": -4 - p * 4, "hk": "a", "head": -0.2, "aF": 2.0 + w2, "eF": -0.4, "aB": 1.8 - w2, "eB": -0.3, "tail": t, "sx": 1 + p * 0.04, "sy": 1 + p * 0.04})
		"proud": return A(anim("idle", t, t), {"hk": "p", "head": -0.15, "aF": -0.25, "eF": 2.2, "aB": -0.3, "eB": 2.1})
		"die": return A(anim("hurt", 0.0, t), {"hk": "h", "lean": -0.6 * p, "dy": -6 * p})
		"hurt":
			var k = maxf(0.0, 1 - p)
			return A(BASE, {"lean": -0.35 * k, "dy": -4 * k, "hk": "h", "head": -0.3 * k, "aF": 1.2 * k + 0.1, "eF": 0.9 * k, "aB": 1.0 * k, "eB": 1.1 * k, "tail": t, "sx": 1 - 0.06 * k, "sy": 1 + 0.06 * k})
		# ---------- 活人動作 ----------
		"walk":
			var s2 = sin(t * 8)
			return H_({"lean": 0.06, "dy": -absf(cos(t * 8)) * 1.6, "head": sin(t * 8) * 0.03, "aF": -s2 * 0.45, "eF": 0.25, "aB": s2 * 0.45, "eB": 0.25, "lF": s2 * 0.42, "lB": -s2 * 0.42})
		"run":
			var s3 = sin(t * 15)
			return H_({"lean": 0.32, "dy": -absf(cos(t * 15)) * 4, "head": -0.15 + s3 * 0.06, "hk": "t", "aF": 2.3 + s3 * 0.7, "eF": -0.3, "aB": 2.0 - s3 * 0.7, "eB": -0.2, "lF": s3 * 0.85, "lB": -s3 * 0.85, "jx": sin(t * 41) * 0.6})
		"startle":
			var up2 = ez("out", p / 0.35) if p < 0.35 else 1 - ez("in", (p - 0.35) / 0.65) * 0.75
			return H_({"lean": -0.32 * up2, "dy": -9 * sin(minf(1.0, p / 0.7) * PI) - (-3.0 if p < 0.08 else 0.0), "sx": 1 - 0.06 * up2, "sy": 1 + 0.08 * up2, "head": -0.25 * up2, "hk": "s", "aF": 2.7 * up2 + 0.2, "eF": -0.4 * up2, "aB": 2.5 * up2, "eB": -0.3 * up2, "lF": 0.45 * up2, "lB": -0.35 * up2, "jx": sin(t * 50) * 0.8 * (1 - p)})
		"cower":
			var j = sin(t * 45) * 0.04
			return H_({"lean": 0.35, "dy": 7.0, "sx": 1.04, "sy": 0.9, "head": 0.35 + j, "hk": "t", "aF": 2.5 + j, "eF": 1.7, "aB": 2.3 - j, "eB": 1.8, "lF": 0.55, "lB": -0.5, "jx": sin(t * 47) * 0.7})
		"tremble":
			var j2 = sin(t * 38)
			return H_({"lean": -0.05, "dy": 1.5, "head": 0.08 + j2 * 0.03, "hk": "f", "aF": 0.85 + j2 * 0.05, "eF": 1.9, "aB": 0.75 - j2 * 0.05, "eB": 2.0, "lF": 0.12 + j2 * 0.04, "lB": -0.12 - j2 * 0.04, "jx": j2 * 0.9, "sx": 0.98, "sy": 1.0})
		"phone":
			var b2 = sin(t * 1.6)
			return H_({"lean": 0.06, "dy": b2 * 0.6, "head": 0.28 + b2 * 0.02, "hk": "b", "aF": 0.75, "eF": 1.45 + b2 * 0.03, "aB": 0.65, "eB": 1.55, "tool": "_P", "tr": -1.4, "lF": 0.0, "lB": 0.0})
		"look":
			var w3 = sin(t * 1.3)
			return H_({"lean": -0.02, "head": w3 * 0.18 - 0.05, "hk": "q", "aF": 1.45 + w3 * 0.15, "eF": 0.05, "aB": -0.15, "eB": 0.4, "tool": "_P", "tr": -3.0, "dy": sin(t * 2) * 0.5})
		"mop":
			var w4 = sin(t * 4.5)
			return H_({"lean": 0.18, "dy": 1.0, "head": 0.15, "hk": "b", "aF": 0.55 + w4 * 0.35, "eF": 0.35, "aB": 0.8 + w4 * 0.3, "eB": 0.5, "tool": "_P", "tr": -3.5 + w4 * 0.15, "ik": 1.0, "lF": w4 * 0.08, "lB": -w4 * 0.08})
		"faint":
			var k2 = ez("in", minf(1.0, p))
			return H_({"lean": -1.35 * k2, "dy": 4 * k2, "head": -0.3 * k2, "hk": "x", "aF": 2.6 * k2, "eF": 0.4, "aB": 2.4 * k2, "eB": 0.5, "lF": 0.6 * k2, "lB": 0.3 * k2})
		"sip":
			var w5 = sin(t * 1.4)
			return H_({"head": -0.08 + w5 * 0.03, "hk": "c", "aF": 0.55, "eF": 2.15 + w5 * 0.05, "aB": -0.1, "eB": 0.3, "dy": sin(t * 2) * 0.5})
		"stand":
			var b3 = sin(t * 2)
			return H_({"dy": b3 * 0.5, "sy": 1 + b3 * 0.006, "head": sin(t * 0.9) * 0.04, "aF": 0.12 + b3 * 0.03, "eF": 0.2, "aB": -0.1, "eB": 0.2})
		"hold":
			var b4 = sin(t * 2)
			return H_({"dy": b4 * 0.5, "head": -0.05, "hk": "q", "aF": 0.55, "eF": 1.25, "aB": 0.45, "eB": 1.35, "tool": "_P", "tr": -1.57})
		"shrug":
			var k3 = sin(minf(1.0, p) * PI)
			return H_({"head": -0.15 * k3, "hk": "q", "aF": 0.6 * k3, "eF": -1.2 * k3, "aB": 0.5 * k3, "eB": -1.1 * k3, "dy": -1.5 * k3})
	return BASE.duplicate()

# ---------- 資料 ----------
static func mirror(R: Dictionary) -> void:
	for m in MIRRORED: if is_same(m, R): return
	MIRRORED.append(R)
	var tw = float(R.torso[1])
	var mx = func(p): return [tw - p[0], p[1]]
	R["root"] = mx.call(R.root); R["neck"] = mx.call(R.neck); R["shF"] = mx.call(R.shF); R["shB"] = mx.call(R.shB)
	R["head"] = [R.head[0], R.head[1], 1 - R.head[2], R.head[3]]
	if J.t(R.get("hipF")): R["hipF"] = mx.call(R.hipF); R["hipB"] = mx.call(R.hipB)
	for k in ["uF", "fF", "uB", "fB", "lF", "lB"]:
		var P = R.get(k)
		if not J.t(P): continue
		P[3] = [P[1] - P[3][0], P[3][1]]; P[4] = [P[1] - P[4][0], P[4][1]]
	if J.t(R.get("tool")):
		var T = R.tool
		TOOLS["_" + J.str(R.id)] = [T[0], T[1], T[2], [T[1] - T[3][0], T[3][1]], false]
static func add_rigs(obj) -> void:
	for id in J.keys(obj):
		var R = J.gp(obj, id); J.sp(R, "id", id); RIGS[id] = R
static func ok(k) -> bool:
	var f = _g("sprOk")
	return f != null and J.t(J.cl(f, null, [k]))
static func has(id) -> bool:
	if not J.t(_g("PUPPET_ON")): return false
	var r = RIGS.get(J.str(id))
	if r != null: mirror(r)
	return r != null and ok(r.torso[0]) and ok(r.heads.n) and ok(r.uF[0]) and ok(r.fF[0]) and ok(r.uB[0]) and ok(r.fB[0])
static func _spr(k): return J.gp(_g("SPR"), k)
static func img(k, x, y, w, h, ctx) -> void:
	J.mc(ctx, "save", []); J.mc(ctx, "scale", [-1.0, 1.0]); J.mc(ctx, "drawImage", [_spr(k), -x - w, y, w, h]); J.mc(ctx, "restore", [])
static func tool_def(name):
	if name == null: return null
	var d = TOOLS.get(J.str(name))
	if d == null or not ok(d[0]): return null
	if not J.t(d[1]) and J.str(d[0]).begins_with("tool_s"):
		var im = _spr(d[0]); var sc = 1 / 0.55
		d[1] = J.num(J.gp(im, "naturalWidth")) * sc; d[2] = J.num(J.gp(im, "naturalHeight")) * sc; d[3] = [d[1] - d[1] * 0.13, d[2] * 0.85]
	return d

# ---------- 繪製 ----------
static func ik2(sx, sy, tx, ty, L1, L2) -> Array:   # [上臂角, 手肘角]
	var dx = tx - sx; var dy = ty - sy
	var d = minf(sqrt(dx * dx + dy * dy), L1 + L2 - 1)
	var base = atan2(-dx, dy)
	var c = maxf(-1.0, minf(1.0, (L1 * L1 + d * d - L2 * L2) / (2 * L1 * d)))
	var a1 = base - acos(c)
	var c2 = maxf(-1.0, minf(1.0, (L1 * L1 + L2 * L2 - d * d) / (2 * L1 * L2)))
	return [a1, PI - acos(c2)]
static func rot(x, y, a) -> Array: return [x * cos(a) - y * sin(a), x * sin(a) + y * cos(a)]
static func _n(v) -> float: return J.num(v) if J.t(v) else 0.0
static func draw_torso(ctx, R, pz) -> void:
	var k = R.torso[0]; var w = float(R.torso[1]); var h = float(R.torso[2]); var im = _spr(k)
	var rx = float(R.root[0]); var ry = float(R.root[1]); var cut = h if J.t(R.get("lF")) else ry - 20
	var nw = J.num(J.gp(im, "naturalWidth")); var pw = nw / w   # 圖縮過，換算回原圖像素
	J.mc(ctx, "save", [])
	if J.t(pz.get("cloth")): J.sp(ctx, "filter", pz.cloth)
	J.mc(ctx, "scale", [-1.0, 1.0]); var u0 = rx - w
	J.mc(ctx, "drawImage", [im, 0.0, 0.0, nw, cut * pw, u0, -ry, w, cut])
	var step = 8.0   # 尾巴一條一條畫，越往下飄得越大
	var y = cut
	while y < h - 0.5:
		var f = (y - cut) / (h - cut); var off = sin(_n(pz.get("tail")) * 3.2 - f * 3) * 16 * f * f + _n(pz.get("lean")) * -40 * f * f
		var hh = minf(step, h - y)
		J.mc(ctx, "drawImage", [im, 0.0, y * pw, nw, hh * pw, u0 - off, y - ry, w, hh + 0.8])
		y += step
	J.mc(ctx, "restore", [])
static func draw(ctx, id, x, y, worldH, pz, flip) -> Array:
	var R = RIGS[J.str(id)]; var k = worldH / float(R.h)
	J.mc(ctx, "save", []); J.mc(ctx, "translate", [x, y + _n(pz.get("dy")) * worldH / 58])
	if J.t(flip): J.mc(ctx, "scale", [-1.0, 1.0])
	J.mc(ctx, "scale", [k * J.num(pz.sx), k * J.num(pz.sy)])
	J.mc(ctx, "translate", [_n(pz.get("jx")) / k * (worldH / 58), -(float(R.tailY) - float(R.root[1]))])
	if J.t(R.get("lF")):   # 雙腿：從髖關節轉
		var LS = J.num(R.legS) if J.t(R.get("legS")) else 1.0; var rx0 = float(R.root[0]); var ry0 = float(R.root[1])
		var leg = func(hp, a, L):
			J.mc(ctx, "save", []); J.mc(ctx, "translate", [hp[0] - rx0, hp[1] - ry0]); J.mc(ctx, "rotate", [a]); J.mc(ctx, "scale", [LS, LS])
			img(L[0], -L[3][0], -L[3][1], L[1], L[2], ctx); J.mc(ctx, "restore", [])
		leg.call(R.hipB, _n(pz.get("lB")), R.lB); leg.call(R.hipF, _n(pz.get("lF")), R.lF)
	J.mc(ctx, "rotate", [-J.num(pz.lean)])
	var AS = J.num(R.armS) if J.t(R.get("armS")) else 0.62
	var rx = float(R.root[0]); var ry = float(R.root[1])
	var tl = pz.get("tool")
	if J.str(tl) == "_P": pz = A(pz, {"tool": ("_" + J.str(id)) if J.t(R.get("tool")) else null})
	tl = pz.get("tool")
	if J.t(pz.get("wpn")) and (J.str(tl) == "_W" or J.str(tl) == "axe") and tool_def(pz.wpn) != null: pz = A(pz, {"tool": pz.wpn})
	elif J.str(tl) == "_W" or (J.str(tl) == "axe" and J.str(id) != "afu"): pz = A(pz, {"tool": ("_" + J.str(id)) if J.t(R.get("tool")) else ("axe" if J.str(id) == "afu" else null)})
	var T = tool_def(pz.get("tool"))
	var sF = [R.shF[0] - rx, R.shF[1] - ry]
	var uF = R.uF; var fF = R.fF; var uB = R.uB; var fB = R.fB
	var L1F = (uF[4][1] - uF[3][1]) * AS; var L2F = (fF[4][1] - fF[3][1]) * AS
	var e1 = rot(0.0, L1F, pz.aF); var elb = [sF[0] + e1[0], sF[1] + e1[1]]
	var e2 = rot(0.0, L2F, pz.aF + pz.eF); var grip = [elb[0] + e2[0], elb[1] + e2[1]]
	var aB = pz.aB; var eB = pz.eB
	var sB = [R.shB[0] - rx, R.shB[1] - ry]
	if T != null and J.t(pz.get("ik")):   # 雙手握：後手抓喺握把再下面少少
		var ta = pz.aF + pz.eF + pz.tr; var d = rot(0.0, 70 * AS, ta)
		var L1B = (uB[4][1] - uB[3][1]) * AS; var L2B = (fB[4][1] - fB[3][1]) * AS
		var r = ik2(sB[0], sB[1], grip[0] + d[0], grip[1] + d[1], L1B, L2B); aB = r[0]; eB = r[1]
	var arm = func(sh, a, e, U, Fm, is_front):
		J.mc(ctx, "save", []); J.mc(ctx, "translate", [sh[0], sh[1]]); J.mc(ctx, "rotate", [a]); J.mc(ctx, "scale", [AS, AS])
		img(U[0], -U[3][0], -U[3][1], U[1], U[2], ctx)
		J.mc(ctx, "translate", [U[4][0] - U[3][0], U[4][1] - U[3][1]]); J.mc(ctx, "rotate", [e])
		if is_front and T != null:
			J.mc(ctx, "save", []); J.mc(ctx, "translate", [Fm[4][0] - Fm[3][0], Fm[4][1] - Fm[3][1]]); J.mc(ctx, "rotate", [pz.tr])
			if J.t(T[4]): J.mc(ctx, "scale", [-1.0, 1.0])
			if J.t(R.get("toolS")): J.mc(ctx, "scale", [R.toolS, R.toolS])
			img(T[0], -T[3][0], -T[3][1], T[1], T[2], ctx); J.mc(ctx, "restore", [])
		img(Fm[0], -Fm[3][0], -Fm[3][1], Fm[1], Fm[2], ctx)
		J.mc(ctx, "restore", [])
	arm.call(sB, aB, eB, uB, fB, false)
	draw_torso(ctx, R, pz)
	var hk = R.heads.get(J.str(pz.hk))
	if not (J.t(hk) and ok(hk)): hk = R.heads.n
	var hi = _spr(hk)
	var hw = float(R.head[0]); var fx = float(R.head[2]); var fy = float(R.head[3])
	var hh = hw * J.num(J.gp(hi, "naturalHeight")) / J.num(J.gp(hi, "naturalWidth"))
	J.mc(ctx, "save", []); J.mc(ctx, "translate", [R.neck[0] - rx, R.neck[1] - ry + 10]); J.mc(ctx, "rotate", [-J.num(pz.head)]); J.mc(ctx, "scale", [-1.0, 1.0])
	J.mc(ctx, "drawImage", [hi, -hw * (1 - fx), -hh * fy, hw, hh]); J.mc(ctx, "restore", [])
	arm.call(sF, pz.aF, pz.eF, uF, fF, true)
	J.mc(ctx, "restore", [])
	return grip   # 工具頭（身體座標）
# 工具前端嘅世界座標：放木屑、火花
static func tip_world(id, x, y, worldH, pz, flip, along) -> Array:
	var R = RIGS[J.str(id)]; var k = worldH / float(R.h); var rx = float(R.root[0]); var ry = float(R.root[1]); var T = tool_def(pz.get("tool"))
	var AS = J.num(R.armS) if J.t(R.get("armS")) else 0.62; var uF = R.uF; var fF = R.fF
	var L1F = (uF[4][1] - uF[3][1]) * AS; var L2F = (fF[4][1] - fF[3][1]) * AS
	var p = [R.shF[0] - rx, R.shF[1] - ry]; var r1 = rot(0.0, L1F, pz.aF); p = [p[0] + r1[0], p[1] + r1[1]]; r1 = rot(0.0, L2F, pz.aF + pz.eF); p = [p[0] + r1[0], p[1] + r1[1]]
	if T != null:
		var d = rot(0.0, -(J.num(along) if J.t(along) else T[2] * 0.7) * AS, pz.aF + pz.eF + pz.tr); p = [p[0] + d[0], p[1] + d[1]]
	var w = rot(p[0], p[1], -J.num(pz.lean)); w = [w[0], w[1] - (float(R.tailY) - float(R.root[1]))]
	w = [w[0] * k * J.num(pz.sx), w[1] * k * J.num(pz.sy)]
	return [x + (-w[0] if J.t(flip) else w[0]), y + _n(pz.get("dy")) * worldH / 58 + w[1]]
static func armed(id) -> bool: return J.str(id) == "afu" or (RIGS.has(J.str(id)) and J.t(RIGS[J.str(id)].get("tool")))
static func add_tool(name, key, w, h, gy) -> void:
	TOOLS[J.str(name)] = [key, w, h, [w / 2, h * (J.num(gy) if J.t(gy) else 0.88)], false]

func run(_env) -> void:
	RIGS = {"afu": {
		"h": 600.0, "root": [120.0, 240.0], "tailY": 380.0,
		"torso": ["rg_afu_torso", 261.0, 384.0],
		"heads": {"n": "rg_afu_head", "s": "rg_afu_head_s", "h": "rg_afu_head_h", "p": "rg_afu_head_p"}, "head": [440.0, 362.0, 0.512, 0.925],
		"neck": [135.0, 28.0], "shF": [212.0, 78.0], "shB": [45.0, 78.0],
		"uF": ["rg_afu_uarmF", 155.0, 291.0, [95.0, 34.0], [88.0, 262.0]],
		"fF": ["rg_afu_farmF", 138.0, 287.0, [62.0, 30.0], [62.0, 222.0]],
		"uB": ["rg_afu_uarmB", 166.0, 292.0, [58.0, 34.0], [85.0, 262.0]],
		"fB": ["rg_afu_farmB", 144.0, 328.0, [66.0, 32.0], [56.0, 292.0]]}}
	TOOLS = {"axe": ["tool_axe", 205.0, 374.0, [205.0 - 42, 300.0], false], "mallet": ["tool_mallet", 241.0, 371.0, [241.0 - 85, 300.0], false], "sickle": ["tool_sickle", 0.0, 0.0, [0.0, 0.0], false]}
	MIRRORED = []
	var ANIMS = {}
	for n in NAMES:
		if T_ONLY.has(n): ANIMS[n] = func(_t, a): var t = J.num(J.arg(a, 0)); return anim(n, t, t)
		else: ANIMS[n] = func(_t, a): return anim(n, J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))
	J.G["PUPPET_ON"] = false
	J.G["Puppet"] = {
		"addTool": func(_t, a): add_tool(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4)); return null,
		"TOOLS": TOOLS, "RIGS": RIGS, "ANIMS": ANIMS,
		"armed": func(_t, a): return armed(J.arg(a, 0)),
		"has": func(_t, a): return has(J.arg(a, 0)),
		"draw": func(_t, a): return draw(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6)),
		"tipWorld": func(_t, a): return tip_world(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4), J.arg(a, 5), J.arg(a, 6)),
		"addRigs": func(_t, a): add_rigs(J.arg(a, 0)); return null,
	}
