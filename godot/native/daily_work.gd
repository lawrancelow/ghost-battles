# 原生改寫自 daily_work.js：崗位打工（伐木、割稻、做棺材板、包壽包、管倉庫、工頭、嚇人訓練班）
# 任何鬼怪都做得來：身體 = 原圖網格（MeshAnim／MoveKit 嗰套）；有拆出手嘅角色用原圖隻手拎工具；
# 拆唔開嘅（Toyol、Pocong、Penanggal）同餓鬼用成個身體做：彎腰、跳上去壓、頭頂扛、隔空飄起嘢。
# 工具同道具全部原圖（tool_*、fx_*、wood__log、store__crate、bun__*、furnace__paper…）；木屑、米粒、蒸氣、汗、金幣、火苗 = 蠟筆小特效。
# 矩陣：MoveKit.M 嗰套（a,b,c,d,e,f，雙精度、右乘），呢度用 6 個數嘅 Array，計法逐條照抄，同轉譯版逐格一致。
# 蠟筆線／爆星／速度線直接叫 MoveKit（moves_chain 嘅工具組，原生招式亦唔經佢；佢係同一份畫法）。
# F 座標：原點 = 腳底，+x = 面向嗰邊，y 向下；長度以身高 H 為單位，角度用「度」（正 = 向前）。
extends RefCounted

const D := PI / 180
const TAU := PI * 2
const DEF := {"lean": 0.0, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0, "bend": 0.0, "head": 0.0, "hx": 0.0, "hy": 0.0, "hr": 0.0, "ang": 0.0}
const HOPS := {"laojiang": 1, "zombie": 1, "pocong": 1}
const ARMCARRY := {"laojiang": 1, "zombie": 1}
const PAPER := {"zhiren": 1, "xiaozhi": 1}
const GLUTTON := {"egui": 1, "eguiking": 1}
const SOLIDS := {"laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1, "npc_ken": 1, "npc_boss": 1, "npc_guard": 1, "npc_auntie": 1}
const TOOLS := {
	"axe": {"key": "tool_axe", "len": 0.44, "grip": [0.5, 0.86], "head": [0.42, 0.2], "mir": true},
	"mallet": {"key": "tool_mallet", "len": 0.34, "grip": [0.5, 0.86], "head": [0.5, 0.18], "mir": false},
	"sickle": {"key": "tool_sickle", "len": 0.32, "grip": [0.13, 0.86], "head": [0.6, 0.2], "mir": false},
}
const POST_ACTS := {
	"wood": [["chop", 5.0], ["haul", 3.0], ["rest", 1.4]],
	"rice": [["reap", 5.0], ["plant", 4.0], ["rest", 1.4]],
	"plank": [["hammer", 5.0], ["sand", 3.0], ["sight", 2.0], ["rest", 0.8]],
	"bun": [["knead", 5.0], ["steam", 3.0], ["sneak", 1.5]],
	"store": [["crate", 4.0], ["coins", 4.0], ["push", 2.0]],
	"boss": [["inspect", 5.0], ["burn", 2.5], ["rest", 1.0]],
	"camp": [["boo", 4.0], ["grimace", 3.0], ["blow", 3.0]],
}
const NAMES := ["chop", "haul", "crate", "rest", "reap", "plant", "hammer", "sand", "sight", "knead", "steam", "sneak", "coins", "push", "inspect", "burn", "march", "salute", "drill", "boo", "grimace", "blow"]
const SPECIAL_H := {"toyol": 46.0, "pocong": 54.0, "penanggal": 52.0}
const CHOP_T := 1.25
const REAP_T := 0.95

static var RC := {}
static var AIM := {}
static var TINT := {}
static var STATE := {}

# ---------------- 小工具 ----------------
static func _g(n: String): return J.G.get(n)
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func seg(t: float, a: float, b: float) -> float: return cl((t - a) / (b - a))
static func ez(n, t: float) -> float:
	match n:
		"lin": return t
		"o": return 1 - (1 - t) * (1 - t)
		"i": return t * t
		"o3": return 1 - pow(1 - t, 3)
		"i3": return t * t * t
		"sin": return 0.5 - 0.5 * cos(PI * t)
		"back":
			var c = 1.7; return 1 + (c + 1) * pow(t - 1, 3) + c * pow(t - 1, 2)
	return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func rnd(i: float) -> float:
	var v = sin(i * 127.1 + 311.7) * 43758.5453; return v - floor(v)
static func ok(k: String) -> bool:
	var so = _g("sprOk")
	return so is Callable and J.t(J.cl(so, null, [k]))
static func spr(k: String): return J.gp(_g("SPR"), k)
static func nw(im) -> float: return J.num(J.gp(im, "naturalWidth"))
static func nh(im) -> float: return J.num(J.gp(im, "naturalHeight"))
static func hasImg(im) -> bool: return J.t(im) and J.t(J.gp(im, "naturalWidth"))
static func sp(v) -> float:
	var s = J.gp(v, "sp") if J.t(v) else null
	return J.num(s) if J.t(s) else 1.0
static func vn(v, k: String) -> float: return J.num(J.gp(v, k))
static func MK(): return _g("MoveKit")
static func idle(t: float) -> Dictionary:
	var z = J.mc(J.gp(_g("MeshAnim"), "ANIM"), "idle", [t])
	return z.duplicate() if z is Dictionary else {}
static func zn(z: Dictionary, k: String) -> float: return J.num(z[k]) if J.t(z.get(k)) else 0.0

# ---------------- 矩陣（MoveKit.M：右乘）----------------
static func mm(m: Array, n: Array) -> Array:
	var a = m[0]; var b = m[1]; var c = m[2]; var d = m[3]; var e = m[4]; var f = m[5]
	return [a * n[0] + c * n[1], b * n[0] + d * n[1], a * n[2] + c * n[3], b * n[2] + d * n[3], a * n[4] + c * n[5] + e, b * n[4] + d * n[5] + f]
static func M0() -> Array: return [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
static func mt(m: Array, x: float, y: float) -> Array: return mm(m, [1.0, 0.0, 0.0, 1.0, x, y])
static func mr(m: Array, an: float) -> Array:
	var c = cos(an); var s = sin(an); return mm(m, [c, s, -s, c, 0.0, 0.0])
static func msc(m: Array, x: float, y = null) -> Array: return mm(m, [x, 0.0, 0.0, x if y == null else float(y), 0.0, 0.0])
static func pt(m: Array, x: float, y: float) -> Array: return [m[0] * x + m[2] * y + m[4], m[1] * x + m[3] * y + m[5]]
static func mset(ctx: Ctx, m: Array) -> void: ctx.transform(m[0], m[1], m[2], m[3], m[4], m[5])

# ---------------- 關鍵姿勢 ----------------
static func full(o: Dictionary) -> Dictionary:
	var r = DEF.duplicate()
	for k in o: r[k] = float(o[k])
	return r
static func asg(a: Dictionary, b: Dictionary) -> Dictionary:
	var r = a.duplicate()
	for k in b: r[k] = b[k]
	return r
# keys = [[時間, {欄位}, 緩動名]]；緩動名套用喺「去到呢一格」嗰段
static func kf(keys: Array, t: float) -> Dictionary:
	if t <= keys[0][0]: return full(keys[0][1])
	for i in range(1, keys.size()):
		if t <= keys[i][0]:
			var a = full(keys[i - 1][1]); var b = full(keys[i][1])
			var dd = keys[i][0] - keys[i - 1][0]
			var q = ez(keys[i][2] if keys[i].size() > 2 and keys[i][2] != null else "io", (t - keys[i - 1][0]) / (dd if dd != 0 else 1.0))
			var o = {}
			for k in a: o[k] = lerp_(a[k], float(b.get(k, NAN)), q)
			return o
	return full(keys[keys.size() - 1][1])
static func add(k: Dictionary, o: Dictionary) -> Dictionary:
	for n in o: k[n] = k[n] * o[n] if (n == "sx" or n == "sy") else k[n] + o[n]
	return k

# ---------------- 角色資料 ----------------
static func special_has(id: String) -> bool:
	var SP = _g("SPECIAL")
	return SP != null and J.t(J.mc(SP, "has", [id]))
static func rigOf(id: String):
	if RC.has(id): return RC[id]
	var special = special_has(id)
	var LD = _g("LIMBS_DATA")
	var C = J.gp(J.gp(LD, "chars"), id) if LD != null else null
	var still = J.gp(C, "still") if J.t(C) else null
	var arm = (not special) and J.t(C) and ok(id + "__body") and ok(id + "__arm") and not (J.t(still) and J.iter(still).has("head")) and _g("MoveKit") != null
	var MA = _g("MeshAnim")
	var RG = J.gp(J.gp(MA, "RIG"), id) if (not special and MA != null) else null
	var bb = null; var hb = null
	if J.t(RG):
		for b in J.iter(J.gp(RG, "bones")):
			if bb == null and J.str(b[0]) == "body": bb = b
			if hb == null and J.str(b[0]) == "head": hb = b
	var img = spr(id + "__body" if arm else id)
	if not hasImg(img): return null
	var ar = nw(img) / nh(img)
	var NR = J.gp(MA, "NATIVE_R") if MA != null else null
	var nr = J.t(J.gp(NR, id) if J.t(NR) else null) or (J.t(C) and J.t(J.gp(C, "nativeR")))
	var pv = J.gp(C, "pivot") if arm else null
	var gp_ = null
	if arm:
		gp_ = J.gp(C, "grip")
		if not J.t(gp_): gp_ = J.gp(C, "tip")
		if not J.t(gp_): gp_ = J.gp(C, "pivot")
	var long_ = false
	if arm:
		var tp = J.gp(C, "tip")
		var dx = (J.num(tp[0]) - J.num(pv[0])) * ar; var dy = J.num(tp[1]) - J.num(pv[1])
		long_ = sqrt(dx * dx + dy * dy) > 0.12
	var R = {"id": id, "special": special, "arm": arm, "C": C, "nr": nr, "ar": ar,
		"pv": [J.num(pv[0]), J.num(pv[1])] if arm else null, "gp": [J.num(gp_[0]), J.num(gp_[1])] if arm else null, "long": long_, "mesh": (not special) and J.t(RG),
		"bp": [J.num(bb[2]), J.num(bb[3])] if bb != null else [0.5, 0.66], "hd": [J.num(hb[4]), J.num(hb[5])] if hb != null else [0.5, 0.2],
		"legs": J.t(RG) and J.t(J.gp(RG, "legs")), "hop": HOPS.has(id), "solid": SOLIDS.has(id)}
	RC[id] = R
	return R

# MoveKit.pose：待機底子（手臂骨、身體骨歸零）再疊 extra（正 = 向前轉）
static func mk_pose(K: Dictionary, extra: Dictionary) -> Dictionary:
	var z = idle(K.t)
	z["armF"] = 0.0; z["axe"] = 0.0; z["body"] = 0.0; z["x"] = 0.0
	var still = J.gp(K.C, "still")
	if J.t(still): for b in J.iter(still): z[J.str(b)] = 0.0
	for k in extra:
		var v: float = extra[k]
		if k == "y": z[k] = zn(z, "y") + v
		elif k == "sx" or k == "sy": z[k] = v
		else: z[k] = zn(z, k) + (v if K.nr else -v)
	return z
static func mk_body(ctx: Ctx, K: Dictionary, m: Array, mp: Dictionary) -> void:
	ctx.save(); mset(ctx, m)
	if not K.nr: ctx.scale(-1, 1)
	J.mc(_g("MeshAnim"), "drawBody", [ctx, K.id, K.id + "__body", K.H, mp]); ctx.restore()
static func mk_piece(ctx: Ctx, K: Dictionary, key: String, m: Array, pu: float, pv: float) -> void:
	if not ok(key): return
	ctx.save(); mset(ctx, m)
	if not K.nr: ctx.scale(-1, 1)
	ctx.drawImage(spr(key), -pu * K.W, -pv * K.H, K.W, K.H); ctx.restore()
static func mk_ppt(K: Dictionary, m: Array, pu: float, pv: float, u: float, v: float) -> Array:
	return pt(m, (1.0 if K.nr else -1.0) * (u - pu) * K.W, (v - pv) * K.H)

# ---------------- 解算：身體矩陣、手、工具、頭頂、嘴 ----------------
static func solve(a: Dictionary, fr: Dictionary) -> Dictionary:
	var R = rigOf(J.str(a.type)); var H: float = J.num(a.H); var k: Dictionary = fr.k; var W = H * R.ar
	var o = a.o; var t = J.num(J.gp(o, "t")) if J.t(J.gp(o, "t")) else 0.0
	var nr: bool = R.nr
	var fl = 0.0 if (R.solid or R.special) else (3 + sin(t * 2.4) * 2) * J.num(a.s)
	var dy = k.dy * H; var lean: float = k.lean; var legF = 0.0; var legB = 0.0; var sx: float = k.sx; var sy: float = k.sy; var lift = -k.dy
	var fw = J.num(fr.get("walk")) if J.t(fr.get("walk")) else 0.0
	if fw != 0:
		var w = fw
		if R.hop:
			var h = absf(sin(w * 5.5)); dy -= h * 0.1 * H; lift += h * 0.1; var g = 1 - minf(1, h * 6); sy *= 1 - 0.07 * g; sx *= 1 + 0.05 * g
		elif R.legs:
			legF = sin(w * 8) * 0.34; legB = -legF; dy -= absf(sin(w * 8)) * 0.022 * H
		else:
			lean += 7; dy -= sin(w * 4) * 0.015 * H
	var hip = 0.35 if R.special else 1 - R.bp[1]
	var ox = J.num(fr.get("ox")) if J.t(fr.get("ox")) else 0.0
	var oy = J.num(fr.get("oy")) if J.t(fr.get("oy")) else 0.0
	var face = J.num(fr.get("face")) if J.t(fr.get("face")) else 1.0
	var bm = msc(mt(mr(mt(mt(msc(mt(M0(), ox * H, oy), face, 1.0), k.dx * H, dy - fl), 0, -hip * H), lean * D), 0, hip * H), sx, sy)
	var P = {"R": R, "H": H, "W": W, "bm": bm, "lift": lift, "legF": legF, "legB": legB, "fl": fl}
	if R.special:
		var b2 = k.bend * 0.55
		var bm2 = mt(mr(mt(bm, 0, -0.3 * H), b2 * D), 0, 0.3 * H); P["bm"] = bm2
		P["top"] = pt(bm2, 0, -0.97 * H); P["mouth"] = pt(bm2, 0.12 * H, -0.7 * H); P["G"] = pt(bm2, 0.3 * H, -0.45 * H); P["belly"] = pt(bm2, 0.15 * H, -0.4 * H)
		return P
	var mp = null
	if R.arm:
		P["K"] = {"id": R.id, "nr": nr, "W": W, "H": H, "C": R.C, "t": t, "o": o}
		mp = mk_pose(P.K, {"body": k.bend * D, "head": k.head * D, "legF": legF, "legB": legB})
	var yoff: float
	if mp != null: yoff = zn(mp, "y") * H
	else: yoff = zn(idle(t), "y") * H
	P["mp"] = mp
	var bend = k.bend * D; var c = cos(bend); var s = sin(bend)
	var ip = func(u: float, v: float) -> Array: return [(1.0 if nr else -1.0) * (u - 0.5) * W, (v - 1) * H]
	var bpp: Array = ip.call(R.bp[0], R.bp[1] * R.ar)
	var bodyPt = func(u: float, v: float) -> Array:
		var p: Array = ip.call(u, v); var ddx = p[0] - bpp[0]; var dy2 = p[1] - bpp[1]
		return [bpp[0] + c * ddx - s * dy2, bpp[1] + s * ddx + c * dy2 + yoff]
	var fwd = func(u: float, du: float) -> float: return u + du if nr else u - du
	P["bodyPt"] = bodyPt
	var bp1: Array = bodyPt.call(R.hd[0], 0.02); P["top"] = pt(bm, bp1[0], bp1[1])
	var bp2: Array = bodyPt.call(fwd.call(R.hd[0], 0.13), R.hd[1] + 0.09); P["mouth"] = pt(bm, bp2[0], bp2[1])
	var bp3: Array = bodyPt.call(fwd.call(R.bp[0], 0.18), R.bp[1] - 0.1); P["belly"] = pt(bm, bp3[0], bp3[1])
	if R.arm:
		var hp: Array = bodyPt.call(R.pv[0], R.pv[1])
		var hmL = mr(mt(M0(), hp[0] + k.hx * H, hp[1] + k.hy * H), (k.hr + k.bend) * D)
		P["hm"] = mm(bm, hmL)
		var gl = pt(hmL, (1.0 if nr else -1.0) * (R.gp[0] - R.pv[0]) * W, (R.gp[1] - R.pv[1]) * H)
		P["G"] = pt(bm, gl[0], gl[1]); P["gl"] = gl
		if J.t(fr.get("tool")):
			var T = TOOLS[fr.tool]; var img = spr(T.key)
			if hasImg(img):
				var th = T.len * H; var tw = th * nw(img) / nh(img); var mx = -1.0 if T.mir else 1.0
				var tm = mr(mt(bm, gl[0], gl[1]), k.ang * D)
				P["tool"] = {"tm": tm, "img": img, "th": th, "tw": tw, "T": T, "mx": mx}
				P["tip"] = pt(tm, mx * (T.head[0] - T.grip[0]) * tw, (T.head[1] - T.grip[1]) * th)
	else:
		var bp4: Array = bodyPt.call(fwd.call(R.bp[0], 0.26), 0.5); P["G"] = pt(bm, bp4[0], bp4[1])
	return P

# ---------------- 畫 ----------------
static func prop(ctx: Ctx, key: String, x: float, y: float, w: float, rot: float, o := {}) -> void:
	var img = spr(key)
	if not hasImg(img) or w <= 0: return
	var h = w * nh(img) / nw(img); var an: Array = o.get("an", [0.5, 1.0])
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha *= cl(o.alpha)
	ctx.translate(x, y)
	if rot != 0: ctx.rotate(rot * D)
	var osx = float(o.get("sx", 0.0)); var osy = float(o.get("sy", 0.0))
	if osx != 0 or osy != 0: ctx.scale(osx if osx != 0 else 1.0, osy if osy != 0 else 1.0)
	if o.get("flip", false): ctx.scale(-1, 1)
	if o.get("clip") != null:
		var cp: Array = o.clip
		ctx.beginPath(); ctx.rect((cp[0] - an[0]) * w, -an[1] * h - 2, (cp[1] - cp[0]) * w, h + 4); ctx.clip()
	ctx.drawImage(img, -an[0] * w, -an[1] * h, w, h); ctx.restore()
static func propH(key: String, w: float) -> float:
	var img = spr(key)
	return w * nh(img) / nw(img) if hasImg(img) else w * 0.6
static func shadow(ctx: Ctx, a: Dictionary, P: Dictionary, x: float) -> void:
	if J.gp(a.o, "shadow") is bool and J.gp(a.o, "shadow") == false: return
	var k = maxf(0.45, 1 - P.lift * 1.6); var r = 14 * J.num(a.s) * (1.0 if P.R.solid else 0.8) * k
	ctx.save()
	if not P.R.solid: ctx.globalAlpha *= 0.55
	ctx.fillStyle = "rgba(0,0,0,.35)"
	ctx.beginPath(); ctx.ellipse(x, 1 * J.num(a.s), r, r * 0.29, 0, 0, TAU); ctx.fill(); ctx.restore()
static func drawBody(ctx: Ctx, a: Dictionary, P: Dictionary, fr: Dictionary) -> void:
	var R = P.R; var H: float = P.H; var k = fr.k
	if R.special:
		ctx.save(); mset(ctx, P.bm)
		var ef = (1.0 if J.t(a.get("faceRight")) else -1.0) * (J.num(fr.face) if J.t(fr.get("face")) else 1.0)
		ctx.scale(ef, 1)
		var wk = J.gp(a.o, "wkey")
		J.mc(_g("ART"), "drawChar", [ctx, R.id, 0.0, 0.0, J.num(a.s), {"t": J.gp(a.o, "t"), "flip": ef < 0, "shadow": false, "key": J.add("w", wk) if wk != null else null, "work": false}])
		ctx.restore(); return
	if R.arm: mk_body(ctx, P.K, P.bm, P.mp); return
	var z = idle(J.num(J.gp(a.o, "t")) if J.t(J.gp(a.o, "t")) else 0.0)
	z["body"] = zn(z, "body") + k.bend * D; z["head"] = zn(z, "head") + k.head * D; z["legF"] = P.legF; z["legB"] = P.legB
	ctx.save(); mset(ctx, P.bm); J.mc(_g("MeshAnim"), "draw", [ctx, R.id, 0.0, 0.0, H, z, true]); ctx.restore()
static func drawTool(ctx: Ctx, P: Dictionary) -> void:
	var T = P.get("tool")
	if T == null: return
	ctx.save(); mset(ctx, T.tm); ctx.scale(T.mx, 1); ctx.drawImage(T.img, -T.T.grip[0] * T.tw, -T.T.grip[1] * T.th, T.tw, T.th); ctx.restore()
static func drawHand(ctx: Ctx, P: Dictionary, key) -> void:
	if not P.R.arm: return
	mk_piece(ctx, P.K, J.str(key) if J.t(key) else P.R.id + "__arm", P.hm, P.R.pv[0], P.R.pv[1])
static func _cb(fr: Dictionary, n: String, ctx: Ctx, P: Dictionary) -> void:
	var f = fr.get(n)
	if f is Callable: f.call(ctx, P)
# fr = { k, tool, face, ox, oy, walk, back0, back, mid, front, hand, toolBehind, emptyHand }
static func render(ctx: Ctx, a: Dictionary, fr: Dictionary) -> Dictionary:
	var P = solve(a, fr)
	ctx.save(); ctx.translate(J.num(a.x), J.num(a.y)); ctx.scale(1.0 if J.t(a.get("faceRight")) else -1.0, 1)
	_cb(fr, "back0", ctx, P)
	shadow(ctx, a, P, P.bm[4])
	_cb(fr, "back", ctx, P)
	if J.t(fr.get("toolBehind")): drawTool(ctx, P)
	drawBody(ctx, a, P, fr)
	_cb(fr, "mid", ctx, P)
	if not J.t(fr.get("toolBehind")): drawTool(ctx, P)
	var hand = fr.get("hand")
	if not (hand is bool and hand == false):
		var hk = hand if J.t(hand) else ("eguiking__hand" if (P.R.id == "eguiking" and (J.t(fr.get("tool")) or J.t(fr.get("emptyHand"))) and ok("eguiking__hand")) else null)
		drawHand(ctx, P, hk)
	_cb(fr, "front", ctx, P)
	ctx.restore()
	return P
# 試算某一格嘅位置（唔畫），用嚟擺道具；以身高為單位快取
static func aim(a: Dictionary, name: String, fn: Callable) -> Dictionary:
	var key = J.str(a.type) + "|" + name
	if not AIM.has(key):
		var P = solve({"type": a.type, "x": 0.0, "y": 0.0, "s": J.num(a.s) / J.num(a.H), "H": 1.0, "o": {"t": 0.0}, "faceRight": true}, fn.call())
		var pick = func(p): return [p[0], p[1]] if p != null else null
		AIM[key] = {"G": pick.call(P.get("G")), "tip": pick.call(P.get("tip")), "top": pick.call(P.get("top")), "mouth": pick.call(P.get("mouth")), "belly": pick.call(P.get("belly"))}
	var A = AIM[key]; var H = J.num(a.H)
	var sc = func(p): return [p[0] * H, p[1] * H] if p != null else null
	return {"G": sc.call(A.G), "tip": sc.call(A.tip), "top": sc.call(A.top), "mouth": sc.call(A.mouth), "belly": sc.call(A.belly)}

# ---------------- 蠟筆小特效 ----------------
static func crayon(ctx: Ctx, pts: Array, col: String, w: float, seed: float) -> void: J.mc(MK(), "crayon", [ctx, pts, col, w, seed])
static func burst(ctx: Ctx, x: float, y: float, r: float, k: float, col: String, seed: float, n: float) -> void: J.mc(MK(), "burst", [ctx, x, y, r, k, col, seed, n])
# 噴出嚟嘅細嘢：拋物線，n 粒，age 秒
static func spray(ctx: Ctx, x: float, y: float, age: float, life: float, n: int, seed: float, H: float, opt: Dictionary, drawOne: Callable) -> void:
	if age < 0 or age > life: return
	for i in n:
		var r1 = rnd(seed + i * 3.1); var r2 = rnd(seed + i * 5.7 + 1); var r3 = rnd(seed + i * 9.3 + 2)
		var vx = (float(opt.get("dir", 0.0)) + (r1 - 0.5) * float(opt.get("spread", 1.6))) * H * float(opt.get("v", 1.1)); var vy = -(0.6 + r2 * 0.9) * H * float(opt.get("up", 1.3))
		var g = float(opt.get("g", 5.5)) * H; var px = x + vx * age
		var py = minf(float(opt.floor) if opt.get("floor") != null else 1e9, y + vy * age + 0.5 * g * age * age)
		var al = 1 - pow(age / life, 2)
		drawOne.call(ctx, px, py, i, al, r3, age)
static func chips(ctx: Ctx, x: float, y: float, age: float, seed: float, H: float, floor_) -> void:
	spray(ctx, x, y, age, 0.55, 5, seed, H, {"up": 1.1, "floor": floor_}, func(c: Ctx, px, py, i, al, r, ag):
		var w = H * (0.05 + r * 0.035); c.save(); c.globalAlpha *= al; c.translate(px, py); c.rotate((r * 6 + ag * (8 + r * 10)) * (1 if i % 2 else -1))
		var img = spr("fx_chips")
		if hasImg(img): c.drawImage(img, -w / 2, -w / 2, w, w)
		c.restore())
static func grains(ctx: Ctx, x: float, y: float, age: float, seed: float, H: float, dir: float) -> void:
	spray(ctx, x, y, age, 0.6, 7, seed, H, {"up": 1.0, "v": 0.8, "dir": dir, "spread": 1.4}, func(c: Ctx, px, py, i, al, r, _ag):
		c.save(); c.globalAlpha *= al; crayon(c, [[px, py], [px + H * 0.018 * (r - 0.5), py - H * 0.022]], "#f2cf5a" if i % 3 else "#c9a23a", maxf(1, H * 0.022), seed + i); c.restore())
static func tinted(kind: String):
	var img = spr("fx_dust")
	if not hasImg(img): return null
	if TINT.has(kind): return TINT[kind]
	var c = J.S_document_("createElement", ["canvas"]); J.sp(c, "width", nw(img)); J.sp(c, "height", nh(img)); var x = J.mc(c, "getContext", ["2d"])
	J.mc(x, "drawImage", [img, 0.0, 0.0]); J.sp(x, "globalCompositeOperation", "source-atop"); J.sp(x, "fillStyle", "rgba(165,112,58,.5)"); J.mc(x, "fillRect", [0.0, 0.0, J.gp(c, "width"), J.gp(c, "height")])
	TINT[kind] = c
	return c
static func puff(ctx: Ctx, x: float, y: float, age: float, life: float, w: float, seed: float, tint = null) -> void:
	if age < 0 or age > life: return
	var q = age / life; var img = tinted("wood") if tint == "wood" else spr("fx_dust")
	if not J.t(img) or not J.t(J.gp(img, "width")): return
	ctx.save(); ctx.globalAlpha *= (1 - q) * (0.85 if tint == "flour" else (0.6 if tint == "wood" else 0.4))
	var iw = J.num(J.gp(img, "width")); var ih = J.num(J.gp(img, "height"))
	var ww = w * (0.6 + 0.7 * ez("o", q)); var hh = ww * ih / iw; ctx.translate(x + (rnd(seed) - 0.5) * w * 0.3 * q, y - w * 0.35 * q)
	if rnd(seed + 1) < 0.5: ctx.scale(-1, 1)
	ctx.drawImage(img, -ww / 2, -hh, ww, hh)
	ctx.restore()
static func spark(ctx: Ctx, x: float, y: float, age: float, w: float) -> void:
	if age < 0 or age > 0.16: return
	var img = spr("fx_spark")
	if not hasImg(img): return
	var q = age / 0.16; var ww = w * (0.5 + 0.7 * ez("o", q))
	ctx.save(); ctx.globalAlpha *= 1 - q; ctx.translate(x, y); ctx.rotate(q * 0.6); ctx.drawImage(img, -ww / 2, -ww / 2, ww, ww); ctx.restore()
static func steam(ctx: Ctx, x: float, y: float, age: float, life: float, H: float, seed: float, n: int) -> void:
	if age < 0: return
	for i in (n if n else 3):
		var a0 = age - i * 0.18
		if a0 < 0 or a0 > life: continue
		var q = a0 / life; var ox = (i - 1) * H * 0.07; var pts = []
		for j in 7:
			var f = j / 6.0; pts.append([x + ox + sin(f * 5 + a0 * 4 + i) * H * 0.035 * (0.4 + f), y - H * (0.05 + 0.32 * ez("o", q)) * f - H * 0.25 * q])
		ctx.save(); ctx.globalAlpha *= (1 - q) * 0.8; crayon(ctx, pts, "rgba(240,240,236,.95)", maxf(1.2, H * 0.03 * (1 - q * 0.5)), seed + i * 13); ctx.restore()
static func sweat(ctx: Ctx, x: float, y: float, age: float, H: float, _seed: float) -> void:
	if age < 0 or age > 0.7: return
	for i in 2:
		var q = age / 0.7; var dir = 1.0 if i else -0.6; var px = x + dir * H * 0.12 * q; var py = y - H * 0.08 * sin(q * PI) + H * 0.12 * q * q
		ctx.save(); ctx.globalAlpha *= 1 - q * q; ctx.translate(px, py); ctx.rotate(dir * 0.5)
		var r = H * 0.026; ctx.fillStyle = "#bfe6ff"; ctx.strokeStyle = "#3a6e96"; ctx.lineWidth = maxf(0.8, r * 0.35)
		ctx.beginPath(); ctx.moveTo(0, -r * 1.7); ctx.quadraticCurveTo(r * 1.1, -r * 0.1, 0, r); ctx.quadraticCurveTo(-r * 1.1, -r * 0.1, 0, -r * 1.7); ctx.fill(); ctx.stroke(); ctx.restore()
static func coin(ctx: Ctx, x: float, y: float, H: float, rot: float, alpha = null) -> void:
	var r = H * 0.045; ctx.save()
	if alpha != null: ctx.globalAlpha *= cl(alpha)
	ctx.translate(x, y); ctx.scale(maxf(0.15, absf(cos(rot))), 1)
	ctx.fillStyle = "#f0c24a"; ctx.strokeStyle = "#6b4a12"; ctx.lineWidth = maxf(0.8, r * 0.28)
	ctx.beginPath(); ctx.arc(0, 0, r, 0, TAU); ctx.fill(); ctx.stroke()
	ctx.fillStyle = "#6b4a12"; ctx.fillRect(-r * 0.28, -r * 0.28, r * 0.56, r * 0.56)
	ctx.fillStyle = "rgba(255,250,210,.8)"; ctx.beginPath(); ctx.arc(-r * 0.45, -r * 0.45, r * 0.22, 0, TAU); ctx.fill(); ctx.restore()
static func coinFlat(ctx: Ctx, x: float, y: float, H: float, alpha = null) -> void:
	var r = H * 0.045; ctx.save()
	if alpha != null: ctx.globalAlpha *= cl(alpha)
	ctx.fillStyle = "#d9a83a"; ctx.strokeStyle = "#6b4a12"; ctx.lineWidth = maxf(0.8, r * 0.25)
	ctx.beginPath(); ctx.ellipse(x, y, r, r * 0.38, 0, 0, TAU); ctx.fill(); ctx.stroke()
	ctx.fillStyle = "rgba(255,240,180,.7)"; ctx.beginPath(); ctx.ellipse(x - r * 0.3, y - r * 0.08, r * 0.35, r * 0.1, 0, 0, TAU); ctx.fill(); ctx.restore()
static func twinkle(ctx: Ctx, x: float, y: float, age: float, H: float, seed: float) -> void:
	if age < 0 or age > 0.45: return
	var q = age / 0.45
	burst(ctx, x, y, H * 0.12, 1 - q, "#ffe9a0", seed, 6)
static func flame(ctx: Ctx, x: float, y: float, age: float, life: float, H: float, seed: float) -> void:
	if age < 0 or age > life: return
	var q = age / life; var k = sin(minf(1, q * 2.2) * PI * 0.5) * (1 - ez("i", q))
	for i in 4:
		var ox = (i - 1.5) * H * 0.05; var hh = H * (0.12 + 0.12 * rnd(seed + i)) * k; var sw = sin(age * 25 + i * 2) * H * 0.02
		crayon(ctx, [[x + ox, y], [x + ox * 1.2 + sw, y - hh * 0.6], [x + ox * 0.6 - sw, y - hh]], "#ffb43a" if i % 2 else "#ff6a2a", maxf(1.2, H * 0.035 * k), seed + i * 7)
	spark(ctx, x, y - H * 0.08, age, H * 0.22)
static func wisp(ctx: Ctx, from: Array, to: Array, H: float, seed: float, alpha = null) -> void:
	ctx.save(); ctx.globalAlpha *= 0.45 * cl(1.0 if alpha == null else alpha)
	var mx = (from[0] + to[0]) / 2; var my = minf(from[1], to[1]) - H * 0.08
	var pts = []
	for j in 9:
		var f = j / 8.0; var x = (1 - f) * (1 - f) * from[0] + 2 * (1 - f) * f * mx + f * f * to[0]; var y = (1 - f) * (1 - f) * from[1] + 2 * (1 - f) * f * my + f * f * to[1]
		pts.append([x, y + sin(f * 9 + seed) * H * 0.01])
	crayon(ctx, pts, "rgba(160,230,220,.9)", maxf(1, H * 0.02), seed); ctx.restore()
static func bang(ctx: Ctx, x: float, y: float, H: float, k: float, seed: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k)
	crayon(ctx, [[x, y - H * 0.16], [x + H * 0.01, y - H * 0.05]], "#ffe27a", maxf(1.5, H * 0.04), seed)
	crayon(ctx, [[x + H * 0.012, y - H * 0.012], [x + H * 0.014, y]], "#ffe27a", maxf(1.5, H * 0.045), seed + 3); ctx.restore()

# ===================== 各動作 =====================
static func dur(n: String, v) -> float:
	var s = sp(v); var vnn = vn(v, "n") if J.t(J.gp(v, "n")) else 0.0
	match n:
		"chop": return vnn * CHOP_T / s + 1.0
		"haul", "crate": return 5.2 / s
		"rest": return 3.6 / s
		"reap": return vnn * REAP_T / s + 1.4
		"plant": return vnn * 1.0 / s + 1.6
		"hammer": return (vnn * 1.6 + 0.6) / s
		"sand": return (vnn * 0.9 + 0.8) / s
		"sight": return 3.4 / s
		"knead": return (vnn * 0.85 + 0.9) / s
		"steam": return 3.6 / s
		"sneak": return 5.0 / s
		"coins": return (vnn * 0.9 + 1.6) / s
		"push": return 3.4 / s
		"inspect": return 4.6 / s
		"burn": return (4.0 if J.t(J.gp(v, "walk")) else 0.0) + (vnn * 1.4 + 0.6) / s
		"march": return (vnn * 0.5 + 0.8) / s
		"salute": return 3.2 / s
		"drill": return (vnn * 0.9 + 0.5) / s
		"boo": return (vnn * 1.7 + 0.3) / s
		"grimace": return 2.8 / s
		"blow": return 2.6 / s
	return 1.0
static func f_act(n: String, a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	match n:
		"chop": return f_chop(a, R, at, v)
		"haul": return f_carry(a, R, at, v, "wood__log", 0.4, "wood__log")
		"crate": return f_carry(a, R, at, v, "store__crate", 0.3, "store__crate")
		"rest": return f_rest(a, R, at, v)
		"reap": return f_reap(a, R, at, v)
		"plant": return f_plant(a, R, at, v)
		"hammer": return f_hammer(a, R, at, v)
		"sand": return f_sand(a, R, at, v)
		"sight": return f_sight(a, R, at, v)
		"knead": return f_knead(a, R, at, v)
		"steam": return f_steam(a, R, at, v)
		"sneak": return f_sneak(a, R, at, v)
		"coins": return f_coins(a, R, at, v)
		"push": return f_push(a, R, at, v)
		"inspect": return f_inspect(a, R, at, v)
		"burn": return f_burn(a, R, at, v)
		"march": return f_march(a, R, at, v)
		"salute": return f_salute(a, R, at, v)
		"drill": return f_drill(a, R, at, v)
		"boo": return f_boo(a, R, at, v)
		"grimace": return f_grimace(a, R, at, v)
		"blow": return f_blow(a, R, at, v)
	return {"k": DEF.duplicate()}

# ---------- 伐木場：劈柴 ----------
static func chopKeys(R: Dictionary, p: float) -> Dictionary:
	if R.arm: return kf([[0.0, {"ang": 45}], [0.36, {"ang": -76, "hy": -0.07, "hx": -0.03, "lean": -8, "dx": -0.03, "dy": -0.02, "sy": 1.05, "sx": 0.96, "bend": -6, "head": -6}, "o"],
		[0.5, {"ang": -84, "hy": -0.075, "hx": -0.035, "lean": -9, "dx": -0.035, "dy": -0.025, "sy": 1.06, "sx": 0.955, "bend": -7, "head": -8}, "io"],
		[0.6, {"ang": 94, "hy": 0.03, "hx": 0.05, "lean": 11, "dx": 0.05, "sx": 1.05, "sy": 0.95, "bend": 14, "head": 6}, "i3"],
		[0.76, {"ang": 92, "hy": 0.03, "hx": 0.05, "lean": 10, "dx": 0.05, "sx": 1.02, "sy": 0.98, "bend": 13, "head": 5}, "o"], [1.0, {"ang": 45}, "io"]], p)
	return kf([[0.0, {}], [0.3, {"sy": 0.86, "sx": 1.1, "lean": -4}, "o"], [0.5, {"dy": -0.36, "dx": 0.22, "sy": 1.1, "sx": 0.93, "lean": 8}, "o"],
		[0.6, {"dy": -0.2, "dx": 0.4, "sy": 0.8, "sx": 1.2, "lean": 4}, "i3"], [0.72, {"dy": -0.2, "dx": 0.4, "sy": 0.9, "sx": 1.1}, "o"],
		[0.86, {"dy": -0.3, "dx": 0.22, "sy": 1.05, "sx": 0.96}, "o"], [1.0, {}, "io"]], p)
static func handRot(R: Dictionary, k: Dictionary, ang0: float) -> Dictionary:
	if R.arm: k["hr"] += (k.ang - ang0) * (0.55 if R.long else 0.2)
	return k
static func f_chop(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var T = CHOP_T / sp(v); var H = J.num(a.H); var n = int(vn(v, "n")); var i = mini(n - 1, int(floor(at / T)))
	var p = (at - i * T) / T if at < n * T else 1.0; var tail = at - n * T
	var k = handRot(R, chopKeys(R, p), 45)
	if R.arm and p > 0.6 and p < 0.7: k["ang"] += sin((p - 0.6) * T * 90) * 4 * (1 - (p - 0.6) / 0.1)
	if tail > 0: add(k, {"head": sin(seg(tail, 0.2, 0.7) * PI) * 8, "sy": 1 + sin(seg(tail, 0.2, 0.7) * PI) * 0.02})
	var A = aim(a, "chop", func(): return {"k": handRot(R, chopKeys(R, 0.6), 45), "tool": "axe"})
	var hitX = A.tip[0] if R.arm else 0.4 * H; var logT = 0.12 * H
	var top = cl(-A.tip[1] - logT * 0.55, 0.16 * H, 0.42 * H) if R.arm else 0.2 * H
	var sw = top / 0.84 * 620 / 408; var logW = minf(0.34 * H, sw * 0.8)
	var seed = vn(v, "seed")
	var hitAge = func(j: int) -> float: return at - (j * T + 0.6 * T)
	var back = func(ctx: Ctx, _P):
		prop(ctx, "stump", hitX, 0.5, sw, 0, {"an": [0.5, 0.97]})
		var ly = -top + 0.02 * H; var bounce = 0.0
		for j in n:
			var g: float = hitAge.call(j)
			if g > 0 and g < 0.2: bounce = -sin(g / 0.2 * PI) * 0.025 * H * (0.0 if j == n - 1 else 1.0)
		var gL: float = hitAge.call(n - 1)
		if gL < 0:
			var pop = ez("back", seg(at, 0, 0.3)); prop(ctx, "wood__log", hitX, ly + bounce, logW * pop, 0, {"an": [0.5, 1.0]})
		else:
			var q = seg(gL, 0, 0.5); var fall = ez("i", q); var al = 1 - seg(gL, 0.6, 0.95)
			prop(ctx, "wood__log", hitX - fall * 0.16 * H, lerp_(ly, 0, fall), logW, -fall * 70, {"an": [1.0, 1.0], "clip": [0.0, 0.5], "alpha": al})
			prop(ctx, "wood__log", hitX + fall * 0.16 * H, lerp_(ly, 0, fall), logW, fall * 70, {"an": [0.0, 1.0], "clip": [0.5, 1.0], "alpha": al})
	var front = func(ctx: Ctx, _P):
		for j in n:
			var g: float = hitAge.call(j); chips(ctx, hitX, -top, g, 11 + j * 7 + seed, H, 0.0)
			if j == n - 1: puff(ctx, hitX, 0, g - 0.25, 0.5, 0.3 * H, 5 + seed, "wood")
	return {"k": k, "tool": "axe", "back": back, "front": front, "toolBehind": R.arm and k.ang < -12}

# ---------- 搬嘢（伐木場搬木頭、倉庫搬木箱）----------
static func f_carry(a: Dictionary, R: Dictionary, at: float, v, key: String, w: float, pileKey: String) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var armC = ARMCARRY.has(R.id) and R.arm
	var k = kf([[0.0, {}], [0.5, {"bend": 34, "lean": 8, "head": 10, "sy": 0.96, "hy": 0.05}, "io"], [0.62, {"bend": 30, "lean": 6, "sy": 0.88, "sx": 1.08, "hy": 0.05}, "o"],
		[0.9, {"bend": -4, "lean": -3, "sy": 1.06, "sx": 0.96, "hy": 0.0 if armC else -0.03}, "o"], [1.1, {"sy": 0.93, "sx": 1.05, "hy": 0.0 if armC else -0.03}, "io"], [1.3, {"sy": 0.96, "sx": 1.02}],
		[2.75, {"sy": 0.96, "sx": 1.02}], [2.9, {"lean": -6, "sy": 1.02}, "o"], [3.05, {"lean": 12, "sy": 0.95, "sx": 1.04}, "i"], [3.3, {}, "io"]], t)
	var face = 1.0; var ox = 0.0; var walk = 0.0
	if t > 1.15 and t < 3.35: face = -1.0
	var X1 = -0.62
	if t > 1.3 and t < 2.7: ox = lerp_(0, X1, ez("sin", seg(t, 1.3, 2.7))); walk = t
	elif t >= 2.7 and t < 3.5: ox = X1
	elif t >= 3.5 and t < 4.9: ox = lerp_(X1, 0, ez("sin", seg(t, 3.5, 4.9))); walk = t
	if t > 1.1 and t < 1.3: add(k, {"sy": 1 - 0.05 * sin(seg(t, 1.1, 1.3) * PI)})
	if t > 3.3 and t < 3.5: add(k, {"sy": 1 - 0.04 * sin(seg(t, 3.3, 3.5) * PI)})
	var pw = w * H; var ph = propH(key, pw); var pileX = (X1 - 0.42) * H; var gx = 0.3 * H
	var seed = vn(v, "seed")
	var fr = {"k": k, "face": face, "ox": ox, "walk": walk * 1.0 if walk != 0 else 0.0}
	var pick = func(P: Dictionary) -> Array: return [P.G[0], P.G[1] - 0.02 * H] if armC else [P.top[0], P.top[1] + 0.02 * H]
	var pileTop = -ph * 0.72 * (1.25 if pileKey == "store__crate" else 1.0)
	fr["back"] = func(ctx: Ctx, _P):
		prop(ctx, pileKey, pileX, 0.5, pw * 1.05, 0, {"an": [0.5, 1.0]})
		prop(ctx, pileKey, pileX - 0.06 * H, -ph * 0.72, pw * 0.95, 4.0 if pileKey == "wood__log" else -3.0, {"an": [0.5, 1.0]})
		if t > 3.3:
			var al = 1 - seg(t, 4.6, 5.0); prop(ctx, key, pileX + 0.05 * H, pileTop - ph * 0.62, pw * 0.9, -5.0 if pileKey == "wood__log" else 2.0, {"an": [0.5, 1.0], "alpha": al})
		if t < 0.62: prop(ctx, key, gx, 0.5, pw, 0, {"an": [0.5, 1.0]})
		if t > 4.6: prop(ctx, key, gx, 0.5, pw * ez("back", seg(t, 4.6, 5.0)), 0, {"an": [0.5, 1.0]})
	fr["front"] = func(ctx: Ctx, P: Dictionary):
		if t >= 0.62 and t < 3.05:
			var q = ez("io", seg(t, 0.62, 0.95)); var tp: Array = pick.call(P); var from = [gx, 0.0]
			var x = lerp_(from[0], tp[0], q); var y = lerp_(from[1], tp[1], q) - sin(q * PI) * 0.12 * H
			prop(ctx, key, x, y, pw, (1.0 if face < 0 else -1.0) * sin(t * 6) * 1.5, {"an": [0.5, 1.0]})
		elif t >= 3.05 and t < 3.3:
			var q = seg(t, 3.05, 3.3); var tp: Array = pick.call(P); var to = [pileX + 0.05 * H, pileTop - ph * 0.62]
			prop(ctx, key, lerp_(tp[0], to[0], ez("o", q)), lerp_(tp[1], to[1], ez("i", q)) - sin(q * PI) * 0.15 * H, pw * 0.95, -q * 12, {"an": [0.5, 1.0]})
		puff(ctx, pileX, pileTop * 0.4, t - 3.3, 0.5, 0.35 * H, 3 + seed, "wood" if key == "wood__log" else null)
		puff(ctx, gx, 0, t - 0.6, 0.45, 0.25 * H, 9 + seed)
	return fr

# ---------- 歇一陣：抹汗、伸懶腰 ----------
static func f_rest(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H)
	var wipe = ({"hr": -75, "hx": 0.02, "hy": -0.08, "head": 10} if R.long else {"hy": -0.05, "hx": -0.01, "hr": -20, "head": 16, "bend": 10}) if R.arm else {"head": 14, "bend": 8, "sy": 0.97}
	var k = kf([[0.0, {}], [0.35, {"lean": -3, "sy": 1.02}], [0.75, wipe, "io"],
		[1.0, asg(wipe, {"hx": float(wipe.get("hx", 0)) - 0.03, "hr": float(wipe.get("hr", 0)) - 12}), "io"], [1.25, asg(wipe, {"hx": float(wipe.get("hx", 0)) + 0.02}), "io"],
		[1.55, {}, "io"], [2.15, {"lean": -10, "bend": -14, "head": -14, "sy": 1.07, "sx": 0.96, "hy": -0.03, "dy": -0.01}, "o"], [2.5, {"lean": -11, "bend": -15, "head": -16, "sy": 1.08, "sx": 0.955, "hy": -0.035, "dy": -0.012}],
		[2.95, {"sy": 0.94, "sx": 1.04, "head": 6}, "io"], [3.6, {}, "io"]], t)
	if t > 2.95 and t < 3.4: k["sy"] += sin(seg(t, 2.95, 3.4) * PI * 2) * 0.01
	var seed = vn(v, "seed")
	var front = func(ctx: Ctx, P: Dictionary): sweat(ctx, P.top[0] + 0.08 * H, P.top[1] + 0.14 * H, t - 1.1, H, 7 + seed)
	return {"k": k, "front": front}

# ---------- 糯米田：割禾 ----------
static func reapKeys(R: Dictionary, p: float) -> Dictionary:
	if R.arm: return kf([[0.0, {"bend": 28, "lean": 8, "head": 8, "ang": 120, "hx": 0.05, "hy": 0.04}], [0.4, {"bend": 32, "lean": 10, "head": 10, "ang": 150, "hx": 0.08, "hy": 0.06, "sy": 0.97}, "o"],
		[0.58, {"bend": 26, "lean": 6, "head": 6, "ang": 205, "hx": -0.03, "hy": 0.05, "sy": 0.95, "sx": 1.04}, "i3"], [0.72, {"bend": 25, "lean": 5, "head": 6, "ang": 210, "hx": -0.035, "hy": 0.04}, "o"],
		[1.0, {"bend": 28, "lean": 8, "head": 8, "ang": 120, "hx": 0.05, "hy": 0.04}, "io"]], p)
	return kf([[0.0, {"bend": 20, "lean": 10, "head": 10}], [0.4, {"bend": 34, "lean": 16, "head": 16, "sy": 0.94, "dx": 0.03}, "o"], [0.58, {"bend": 14, "lean": 2, "head": -6, "sy": 1.04, "dx": -0.02}, "i3"],
		[0.75, {"bend": 16, "lean": 6, "head": 4}, "o"], [1.0, {"bend": 20, "lean": 10, "head": 10}, "io"]], p)
static func f_reap(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var T = REAP_T / sp(v); var H = J.num(a.H); var n = int(vn(v, "n")); var in0 = 0.5; var body = at - in0
	var k: Dictionary
	if body < 0: k = kf([[0.0, {}], [in0, {"bend": 28, "lean": 8, "head": 8, "ang": 120, "hx": 0.05, "hy": 0.04} if R.arm else {"bend": 20, "lean": 10, "head": 10}, "io"]], at)
	elif body < n * T:
		var i = int(floor(body / T)); var p = (body - i * T) / T; k = reapKeys(R, p); k["dx"] += -i * 0.06 - ez("io", seg(p, 0.75, 1)) * 0.06
	else:
		var q = body - n * T; k = kf([[0.0, reapKeys(R, 1)], [0.5, {"lean": -6, "bend": -8, "head": -8, "sy": 1.04}, "o"], [0.9, {}, "io"]], q); k["dx"] += -n * 0.06 * (1 - ez("io", seg(q, 0.2, 0.9)))
	if R.arm: k["hr"] += (k.ang - 120) * (0.4 if R.long else 0.15)
	var seed = vn(v, "seed")
	var front = func(ctx: Ctx, P: Dictionary):
		for j in n:
			var g = body - (j * T + 0.55 * T); var x = (0.3 - j * 0.06) * H; grains(ctx, x, -0.18 * H, g, 21 + j * 5 + seed, H, -0.6)
		if not R.arm:
			for j in n: grains(ctx, P.mouth[0], P.mouth[1], body - (j * T + 0.5 * T), 33 + j + seed, H, 0.2)
	return {"k": k, "tool": "sickle", "front": front}

# ---------- 糯米田：插秧 ----------
static func f_plant(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var T = 1.0 / sp(v); var H = J.num(a.H); var n = int(vn(v, "n")); var in0 = 0.5; var body = at - in0
	var dip = ({"bend": 30, "lean": 10, "head": 8, "hr": 35, "hy": 0.06, "hx": 0.03} if R.long else {"bend": 40, "lean": 14, "head": 10, "hy": 0.05, "hx": 0.03}) if R.arm else {"bend": 36, "lean": 20, "head": 16, "sy": 0.92}
	var up = {"bend": 22, "lean": 6, "head": 4, "hy": 0.0} if R.arm else {"bend": 16, "lean": 6, "head": 4}
	var k: Dictionary; var step = 0.0
	if body < 0: k = kf([[0.0, {}], [in0, up, "io"]], at)
	elif body < n * T:
		var i = int(floor(body / T)); var p = (body - i * T) / T
		k = kf([[0.0, up], [0.35, dip, "io"], [0.5, asg(dip, {"sy": float(dip.get("sy", 1.0)) * 0.97}), "o"], [0.75, up, "o"], [1.0, up]], p); step = i + ez("io", seg(p, 0.75, 1))
	else:
		var q = body - n * T; k = kf([[0.0, up], [0.6, {"lean": -8, "bend": -10, "head": -10, "sy": 1.05, "hy": -0.02}, "o"], [1.1, {}, "io"]], q); step = n * (1 - ez("io", seg(q, 0.4, 1.1)))
	k["dx"] -= step * 0.07
	var D_ = dur("plant", v)
	var front = func(ctx: Ctx, _P):
		for j in n:
			var g = body - (j * T + 0.42 * T)
			if g < 0: continue
			var x = (0.3 - j * 0.07) * H + k.dx * 0; var al = 1 - seg(at, D_ - 0.6, D_)
			if g < 0.6:
				ctx.save(); ctx.globalAlpha *= (1 - g / 0.6) * 0.7; ctx.strokeStyle = "#a9d6e6"; ctx.lineWidth = maxf(1, 0.015 * H); ctx.beginPath(); ctx.ellipse(x, 0, 0.05 * H + g * 0.14 * H, 0.015 * H + g * 0.04 * H, 0, 0, TAU); ctx.stroke(); ctx.restore()
			var gr = ez("back", seg(g, 0, 0.25)); ctx.save(); ctx.globalAlpha *= al
			for m in 3: crayon(ctx, [[x + (m - 1) * 0.012 * H, 0.0], [x + (m - 1) * 0.03 * H + sin(at * 2 + m + j) * 0.006 * H, -0.09 * H * gr * (1.2 if m == 1 else 1.0)]], "#7fbf4a" if m == 1 else "#5f9a38", maxf(1, 0.02 * H), 50 + j * 3 + m)
			ctx.restore()
	return {"k": k, "front": front}

# ---------- 棺材鋪：釘棺材板 ----------
static func hammerKeys(R: Dictionary, p: float) -> Dictionary:
	if R.arm: return kf([[0.0, {"bend": 12, "lean": 4, "ang": 60}], [0.18, {"bend": 13, "lean": 5, "ang": 10, "hy": -0.02}, "o"], [0.26, {"bend": 15, "lean": 6, "ang": 98, "hy": 0.01}, "i"], [0.36, {"bend": 13, "lean": 5, "ang": 15, "hy": -0.02}, "o"], [0.44, {"bend": 15, "lean": 6, "ang": 98, "hy": 0.01}, "i"],
		[0.85, {"bend": 2, "lean": -6, "ang": -62, "hy": -0.07, "hx": -0.02, "dy": -0.02, "sy": 1.05, "sx": 0.97, "head": -6}, "o"], [0.98, {"bend": 1, "lean": -7, "ang": -70, "hy": -0.075, "hx": -0.025, "dy": -0.025, "sy": 1.06, "sx": 0.96, "head": -8}],
		[1.08, {"bend": 18, "lean": 9, "ang": 100, "hy": 0.02, "hx": 0.03, "sy": 0.94, "sx": 1.05, "head": 8}, "i3"], [1.25, {"bend": 17, "lean": 8, "ang": 98, "hy": 0.02, "hx": 0.03, "sy": 0.97, "sx": 1.02, "head": 6}, "o"], [1.6, {"bend": 12, "lean": 4, "ang": 60}, "io"]], p)
	return kf([[0.0, {"bend": 10}], [0.18, {"bend": 4, "dy": -0.04}, "o"], [0.26, {"bend": 20, "lean": 8, "sy": 0.95}, "i"], [0.36, {"bend": 4, "dy": -0.04}, "o"], [0.44, {"bend": 20, "lean": 8, "sy": 0.95}, "i"],
		[0.85, {"bend": -8, "lean": -10, "dy": -0.08, "sy": 1.08, "sx": 0.95}, "o"], [0.98, {"bend": -9, "lean": -11, "dy": -0.09, "sy": 1.09, "sx": 0.94}], [1.08, {"bend": 28, "lean": 16, "sy": 0.88, "sx": 1.1, "dx": 0.04}, "i3"], [1.25, {"bend": 26, "lean": 14, "sy": 0.93, "sx": 1.05, "dx": 0.04}, "o"], [1.6, {"bend": 10}, "io"]], p)
static func hamRot(R: Dictionary, k: Dictionary) -> Dictionary:
	if R.arm: k["hr"] += (k.ang - 60) * (0.45 if R.long else 0.15)
	return k
static func benchOf(a: Dictionary, R: Dictionary) -> Dictionary:
	var H = J.num(a.H)
	var A = aim(a, "hammer", func(): return {"k": hamRot(R, hammerKeys(R, 1.08)), "tool": "mallet"})
	if R.arm: return {"x": cl(A.tip[0] + 0.04 * H, 0.42 * H, 0.75 * H), "top": cl(-A.tip[1] - 0.06 * H, 0.14 * H, 0.42 * H)}
	return {"x": cl(A.mouth[0] + 0.12 * H, 0.42 * H, 0.75 * H), "top": cl(-A.mouth[1] - 0.1 * H, 0.14 * H, 0.4 * H)}
static func drawBench(ctx: Ctx, B: Dictionary, H: float, shake: float, plankLift := false) -> void:
	var cw = 0.2 * H; var chH = propH("store__crate", cw); var sc = B.top / (chH * 0.92)
	prop(ctx, "store__crate", B.x - 0.2 * H, 0.5, cw * minf(1.4, sc), 0, {"an": [0.5, 1.0], "sy": sc / minf(1.4, sc)})
	prop(ctx, "store__crate", B.x + 0.2 * H, 0.5, cw * minf(1.4, sc), 0, {"an": [0.5, 1.0], "sy": sc / minf(1.4, sc), "flip": true})
	if not plankLift: prop(ctx, "fx_plank", B.x, -B.top + 0.06 * H + shake, 0.52 * H, 0, {"an": [0.5, 0.8]})
static func f_hammer(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var B = benchOf(a, R); var T = 1.6; var i = int(floor(t / T)); var p = t - i * T
	var n = int(vn(v, "n"))
	var k: Dictionary; var hits = []
	if i < n: k = hamRot(R, hammerKeys(R, p))
	else: k = hamRot(R, kf([[0.0, hammerKeys(R, 1.6)], [0.6, {"ang": 45} if R.arm else {}, "io"]], p))
	for j in n:
		var b = j * T; hits.append([(b + 0.26) / s, 0.4]); hits.append([(b + 0.44) / s, 0.4]); hits.append([(b + 1.08) / s, 1.0])
	var back = func(ctx: Ctx, _P):
		var sh = 0.0
		for h in hits:
			var g = at - h[0]
			if g > 0 and g < 0.12: sh = sin(g / 0.12 * PI * 2) * 0.012 * H * h[1]
		drawBench(ctx, B, H, sh)
	var front = func(ctx: Ctx, P: Dictionary):
		var hx = P.tip[0] if P.get("tip") != null else P.mouth[0]
		for h in hits:
			var g = at - h[0]; spark(ctx, hx, -B.top + 0.02 * H, g, (0.3 if h[1] > 0.5 else 0.16) * H)
			if h[1] > 0.5: puff(ctx, hx, -B.top + 0.04 * H, g, 0.45, 0.22 * H, 4 + h[0] * 10, "wood")
	return {"k": k, "tool": "mallet", "back": back, "front": front, "toolBehind": R.arm and k.ang < -20}
# ---------- 棺材鋪：刨平 ----------
static func f_sand(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var B = benchOf(a, R); var T = 0.9; var n = int(vn(v, "n")); var in0 = 0.4; var b = t - in0
	var rest = {"bend": 14, "lean": 6, "hy": 0.02} if R.arm else {"bend": 18, "lean": 10}
	var push = {"bend": 20, "lean": 12, "dx": 0.06, "hx": 0.06, "hy": 0.03, "sy": 0.96, "sx": 1.03, "head": 6} if R.arm else {"bend": 24, "lean": 16, "dx": 0.1, "sy": 0.94, "sx": 1.05, "head": 8}
	var pull = {"bend": 12, "lean": 3, "dx": -0.02, "hx": -0.02, "hy": 0.02, "head": 2} if R.arm else {"bend": 14, "lean": 6, "dx": -0.02}
	var k: Dictionary
	if b < 0: k = kf([[0.0, {}], [in0, rest]], t)
	elif b < n * T:
		var p = fmod(b, T) / T; k = kf([[0.0, pull], [0.45, push, "io"], [0.6, push], [1.0, pull, "io"]], p)
	else: k = kf([[0.0, pull], [0.4, {}, "io"]], b - n * T)
	var seed = vn(v, "seed")
	var back = func(ctx: Ctx, _P): drawBench(ctx, B, H, 0)
	var front = func(ctx: Ctx, _P):
		for j in n:
			var g = (b - (j * T + 0.45 * T)) / s; var x = B.x + 0.18 * H; puff(ctx, x + j % 2 * 0.04 * H, -B.top + 0.03 * H, g, 0.55, 0.2 * H, 30 + j + seed, "wood")
	return {"k": k, "back": back, "front": front}
# ---------- 棺材鋪：舉起塊板睇直唔直 ----------
static func f_sight(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H); var B = benchOf(a, R)
	var k = kf([[0.0, {}], [0.5, {"bend": 14, "lean": 6, "hy": 0.03}, "io"], [0.75, {"bend": 10, "lean": 2, "sy": 0.95}, "o"], [1.2, {"bend": -6, "lean": -5, "head": -12, "hy": -0.06, "sy": 1.03}, "o"],
		[1.7, {"bend": -7, "lean": -6, "head": -4, "hy": -0.06}, "io"], [2.0, {"bend": -7, "lean": -6, "head": -16, "hy": -0.06}, "io"], [2.2, {"bend": -6, "lean": -5, "head": -8, "hy": -0.06}, "io"],
		[2.85, {"bend": 14, "lean": 6, "hy": 0.03}, "io"], [3.4, {}, "io"]], t)
	var lifted = t > 0.62 and t < 2.85
	var back = func(ctx: Ctx, _P): drawBench(ctx, B, H, 0, lifted)
	var front = func(ctx: Ctx, P: Dictionary):
		if not lifted: return
		var q = ez("io", seg(t, 0.62, 1.2)) * (1 - ez("io", seg(t, 2.3, 2.85)))
		var hold = [P.G[0] + 0.05 * H, P.G[1] - 0.02 * H]; var rs = [B.x, -B.top + 0.06 * H]
		var x = lerp_(rs[0], hold[0], q); var y = lerp_(rs[1], hold[1], q)
		prop(ctx, "fx_plank", x, y, 0.52 * H * (1 - 0.3 * q), -q * 62, {"an": [0.5, 0.8]})
		if not R.arm: wisp(ctx, P.belly, [x, y], H, 3, q)
	return {"k": k, "back": back, "front": front}

# ---------- 包點舖：搓麵 ----------
static func counterOf(a: Dictionary, R: Dictionary) -> Dictionary:
	var H = J.num(a.H)
	if not R.arm: return {"x": 0.4 * H, "top": 0.26 * H}
	var A = aim(a, "knead", func(): return {"k": asg(DEF, {"bend": 16.0, "lean": 8.0, "hy": 0.04, "sy": 0.95})})
	return {"x": cl(A.G[0] + 0.02 * H, 0.22 * H, 0.6 * H), "top": cl(-A.G[1] - 0.04 * H, 0.16 * H, 0.42 * H)}
static func drawCounter(ctx: Ctx, C: Dictionary, H: float) -> void:
	var sw = 0.36 * H; var sh = propH("bun__steamer", sw); var sc = C.top / (sh * 0.95)
	prop(ctx, "bun__steamer", C.x, 0.5, sw, 0, {"an": [0.5, 1.0], "sy": sc})
static func f_knead(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var C = counterOf(a, R); var T = 0.85; var n = int(vn(v, "n")); var in0 = 0.45; var b = t - in0
	var k: Dictionary; var dq = 0.0; var roll = 0.0
	if R.arm:
		var up = {"bend": 10, "lean": 4, "hy": 0.0}; var press = {"bend": 18, "lean": 9, "hy": 0.05, "sy": 0.93, "sx": 1.04, "dy": 0.01, "head": 6}
		if b < 0: k = kf([[0.0, {}], [in0, up]], t)
		elif b < n * T:
			var p = fmod(b, T) / T
			k = kf([[0.0, up], [0.32, press, "i"], [0.45, press], [0.62, up, "o"], [0.8, asg(up, {"hx": 0.04, "hy": 0.02}), "io"], [1.0, up, "io"]], p)
			dq = maxf(0, sin(seg(p, 0.2, 0.6) * PI)); roll = sin(seg(p, 0.62, 1) * PI)
		else: k = kf([[0.0, up], [0.45, {}, "io"]], b - n * T)
	else:
		var sit = {"dy": -C.top / H + 0.06, "dx": 0.4, "sy": 0.84, "sx": 1.15}
		if b < 0: k = kf([[0.0, {}], [in0 * 0.6, {"sy": 0.88, "sx": 1.08}, "o"], [in0, {"dy": -C.top / H - 0.12, "dx": 0.3, "sy": 1.08}, "o"]], t)
		elif b < n * T:
			var p = fmod(b, T) / T
			k = kf([[0.0, {"dy": -C.top / H - 0.12, "dx": 0.38, "sy": 1.06}], [0.35, sit, "i3"], [0.5, asg(sit, {"sy": 0.9}), "o"], [1.0, {"dy": -C.top / H - 0.12, "dx": 0.38, "sy": 1.06}, "o"]], p)
			dq = maxf(0, sin(seg(p, 0.3, 0.7) * PI))
		else: k = kf([[0.0, {"dy": -C.top / H - 0.12, "dx": 0.38}], [0.5, {}, "io"], [0.7, {"sy": 0.94}, "o"], [0.9, {}, "io"]], b - n * T)
	var seed = vn(v, "seed")
	var back = func(ctx: Ctx, _P):
		drawCounter(ctx, C, H)
		var dw = 0.26 * H; prop(ctx, "fx_dough", C.x + roll * 0.04 * H, -C.top + 0.03 * H, dw * (1 + 0.3 * dq), roll * 8, {"an": [0.5, 0.9], "sy": 1 - 0.4 * dq})
	var front = func(ctx: Ctx, _P):
		for j in n: puff(ctx, C.x, -C.top, (b - (j * T + 0.32 * T)) / s, 0.5, 0.22 * H, 40 + j + seed, "flour")
	return {"k": k, "back": back, "front": front}
# ---------- 包點舖：掀蒸籠 ----------
static func f_steam(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H); var C = counterOf(a, R); var cx = C.x if R.arm else 0.36 * H
	var k = kf([[0.0, {}], [0.45, {"bend": 12, "lean": 5, "hy": 0.03}, "io"], [0.65, {"bend": 8, "lean": 2, "sy": 0.95}, "o"], [0.95, {"bend": -2, "lean": -2, "hy": -0.06, "sy": 1.03}, "o"],
		[1.1, {"bend": -12, "lean": -14, "head": -16, "dx": -0.06, "hy": -0.06, "sy": 1.06, "sx": 0.95}, "o"], [1.6, {"bend": -8, "lean": -8, "head": -10, "dx": -0.05, "hy": -0.04, "hr": 25}, "io"],
		[1.8, {"bend": -8, "lean": -8, "head": -10, "dx": -0.05, "hy": -0.04, "hr": -25}, "io"], [2.0, {"bend": -8, "lean": -8, "head": -10, "dx": -0.05, "hy": -0.04, "hr": 25}, "io"], [2.2, {"bend": -6, "lean": -6, "head": -6, "dx": -0.04, "hy": -0.04}, "io"],
		[2.9, {"bend": 12, "lean": 5, "hy": 0.03}, "io"], [3.6, {}, "io"]], t)
	if not R.arm: k["hr"] = 0.0
	var bw = 0.34 * H; var bh = propH("bun__basket", bw); var baseTop = 0.12 * H
	var lidW = 0.32 * H; var lidH = propH("bun__steamer", lidW)
	var seed = vn(v, "seed")
	var back = func(ctx: Ctx, _P):
		prop(ctx, "store__crate", cx, 0.5, 0.26 * H, 0, {"an": [0.5, 1.0], "sy": baseTop / (propH("store__crate", 0.26 * H) * 0.9)})
		prop(ctx, "bun__basket", cx, -baseTop + 0.01 * H, bw, 0, {"an": [0.5, 0.95]})
	var front = func(ctx: Ctx, P: Dictionary):
		var q = ez("io", seg(t, 0.62, 0.95)) * (1 - ez("io", seg(t, 2.4, 2.9)))
		var rs = [cx, -baseTop - bh * 0.62]; var hold = [P.G[0] + 0.02 * H, P.G[1] + 0.06 * H] if R.arm else [cx - 0.02 * H, -baseTop - bh - 0.3 * H]
		var x = lerp_(rs[0], hold[0], q); var y = lerp_(rs[1], hold[1], q)
		steam(ctx, cx, -baseTop - bh * 0.5, t - 0.85, 1.2, H, 60 + seed, 4)
		prop(ctx, "bun__steamer", x, y, lidW, q * (-10.0 if R.arm else 6.0) + (sin((t - 2.9) * 60) * 2 if (t > 2.9 and t < 3.1) else 0.0), {"an": [0.5, 1.0]})
		if not R.arm and q > 0.02: wisp(ctx, P.top, [x, y - lidH * 0.3], H, 8, q)
	return {"k": k, "back": back, "front": front}
# ---------- 包點舖：偷食 ----------
static func crumbs(ctx: Ctx, P: Dictionary, t: float, H: float) -> void:
	for j in 3:
		spray(ctx, P.mouth[0], P.mouth[1] + 0.03 * H, t - (2.5 + j * 0.38), 0.4, 3, 70 + j, H, {"up": 0.3, "v": 0.5, "g": 4.0}, func(c: Ctx, px, py, _i, al, _r, _ag):
			c.save(); c.globalAlpha *= al; c.fillStyle = "#f4ead8"; c.beginPath(); c.arc(px, py, H * 0.012, 0, TAU); c.fill(); c.restore())
static func f_sneak(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H); var bx = 0.34 * H; var baseTop = 0.12 * H
	var face = 1.0
	if (t > 0.3 and t < 0.75) or (t > 1.05 and t < 1.3): face = -1.0
	var eat = ({"hr": -55, "hy": -0.06, "hx": 0.0, "bend": 8, "head": 12} if R.long else {"hy": -0.04, "hx": -0.01, "bend": 26, "lean": 10, "head": 18}) if R.arm else {"bend": 22, "lean": 12, "head": 16}
	var k = kf([[0.0, {}], [0.25, {"head": -6, "sy": 0.97}, "o"], [0.75, {"head": -6, "sy": 0.97}], [1.0, {"head": -4, "sy": 0.96}], [1.3, {"head": -4, "sy": 0.96}], [1.45, {"sy": 0.95}],
		[1.75, {"bend": 14, "lean": 8, "hx": 0.05, "hy": 0.04, "head": 6}, "io"], [1.9, {"bend": 12, "lean": 6, "hx": 0.05, "hy": 0.03, "sy": 0.96}, "o"], [2.3, eat, "io"],
		[3.5, eat], [3.75, asg(eat, {"head": float(eat.get("head", 0)) - 18, "sy": 1.06, "sx": 0.96, "bend": float(eat.get("bend", 0)) - 10}), "o"],
		[4.3, {"head": -8, "sy": 1.04, "lean": -4}, "io"], [5.0, {}, "io"]], t)
	if t > 2.3 and t < 3.5:
		var c = absf(sin((t - 2.3) * PI * 2.5)); k["head"] += c * 7; k["sy"] *= 1 - c * 0.02
	var bites = int(floor(seg(t, 2.4, 3.5) * 3 + (1 if t > 2.4 else 0)))
	var bunW = 0.16 * H; var bs = [1.0, 0.75, 0.5, 0.3][mini(3, bites)] if t < 3.5 else 0.0
	var kingHand = R.id == "eguiking"
	var back = func(ctx: Ctx, _P):
		prop(ctx, "store__crate", bx, 0.5, 0.26 * H, 0, {"an": [0.5, 1.0], "sy": baseTop / (propH("store__crate", 0.26 * H) * 0.9)})
		prop(ctx, "bun__basket", bx, -baseTop + 0.01 * H, 0.34 * H, 0, {"an": [0.5, 0.95]})
	if kingHand and ok("eguiking__hand") and ok("eguiking__bun"):
		var fr = {"k": k, "face": face, "back": back, "hand": "eguiking__hand"}
		fr["front"] = func(ctx: Ctx, P: Dictionary):
			var BC = [0.1329, 0.2928]; var kb = 1.0 if t < 2.4 else (bs if t < 3.5 else (0.0 if t < 4.3 else ez("back", seg(t, 4.3, 4.6))))
			if kb > 0:
				var c = mk_ppt(P.K, P.hm, P.R.pv[0], P.R.pv[1], BC[0], BC[1]); ctx.save(); ctx.translate(c[0], c[1]); ctx.scale(kb, kb); ctx.translate(-c[0], -c[1]); mk_piece(ctx, P.K, "eguiking__bun", P.hm, P.R.pv[0], P.R.pv[1]); ctx.restore()
			crumbs(ctx, P, t, H)
			if t > 4.0: twinkle(ctx, P.top[0] + 0.1 * H, P.top[1] + 0.1 * H, t - 4.0, H, 9)
		return fr
	var front = func(ctx: Ctx, P: Dictionary):
		if t > 1.85 and t < 3.6 and bs > 0:
			var g = seg(t, 1.85, 2.3); var from = [bx, -baseTop - 0.08 * H]; var to = [P.G[0], P.G[1]] if R.arm else [P.mouth[0] + 0.02 * H, P.mouth[1] + 0.02 * H]
			var p = to if R.arm else [lerp_(from[0], to[0], ez("io", g)), lerp_(from[1], to[1], ez("io", g)) - sin(g * PI) * 0.05 * H]
			prop(ctx, "bun__bun", p[0], p[1], bunW * bs, 0, {"an": [0.5, 0.6]})
			if not R.arm: wisp(ctx, P.mouth, p, H, 5, 1 - g)
		crumbs(ctx, P, t, H)
		if t > 4.0: twinkle(ctx, P.top[0] + 0.1 * H, P.top[1] + 0.1 * H, t - 4.0, H, 9)
	return {"k": k, "face": face, "back": back, "front": front}

# ---------- 倉庫：數冥幣 ----------
static func f_coins(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var n = int(vn(v, "n")); var T = 0.9; var in0 = 0.4; var b = t - in0; var sx0 = 0.36 * H; var stackX = 0.7 * H
	var thief = R.id == "toyol"; var ts = int(floor(n / 2.0))
	var dip = {"bend": 18, "lean": 8, "hx": 0.05, "hy": 0.05} if R.arm else {"bend": 16, "lean": 8, "head": 8}
	var look = {"bend": 2, "hy": -0.03, "hx": 0.0, "head": 4, "hr": -15} if R.arm else {"bend": 0, "head": 6}
	var k: Dictionary; var face = 1.0
	if b < 0: k = kf([[0.0, {}], [in0, look]], t)
	elif b < n * T:
		var p = fmod(b, T) / T
		k = kf([[0.0, look], [0.25, dip, "io"], [0.5, look, "io"], [0.62, asg(look, {"head": float(look.get("head", 0)) + 10}), "o"], [0.75, look, "io"], [0.9, asg(look, {"hx": float(look.get("hx", 0)) - 0.03}), "o"], [1.0, look, "io"]], p)
	else:
		var q = b - n * T; k = kf([[0.0, look], [0.4, {"bend": 16, "lean": 8, "hx": 0.0, "hy": 0.05}, "io"], [0.8, {"bend": 14, "lean": 6, "hx": 0.07, "hy": 0.05}, "io"], [1.2, {}, "io"]], q)
	if thief and b > ts * T - 0.6 and b < ts * T:
		var q = (b - (ts * T - 0.6)) / 0.6; face = -1.0 if (q > 0.25 and q < 0.6) else 1.0; k["sy"] *= 0.96
	if thief and b > ts * T + 0.6 and b < ts * T + 0.95:
		var c = sin(seg(b, ts * T + 0.6, ts * T + 0.95) * PI * 3); k["sy"] *= 1 + 0.03 * absf(c)
	var back = func(ctx: Ctx, _P): prop(ctx, "store__sack", sx0, 0.5, 0.36 * H, 0, {"an": [0.5, 1.0]})
	var front = func(ctx: Ctx, P: Dictionary):
		var stacked = 0
		for j in n: if b > j * T + 0.95 * T and not (thief and j == ts): stacked += 1
		var sweep = seg(b - n * T, 0.4, 0.8) if b > n * T else 0.0
		for j in stacked: coinFlat(ctx, lerp_(stackX, sx0, ez("i", sweep)) + (0.006 if j % 2 else -0.004) * H, -0.012 * H - j * 0.024 * H - sin(sweep * PI) * 0.08 * H, H, 1 - seg(sweep, 0.7, 1))
		if b >= 0 and b < n * T:
			var j = int(floor(b / T)); var p = fmod(b, T) / T
			if p > 0.22:
				var c: Array
				if p < 0.82: c = [P.G[0], P.G[1] - 0.02 * H] if R.arm else [lerp_(sx0, P.mouth[0] + 0.12 * H, ez("io", seg(p, 0.22, 0.5))), lerp_(-0.2 * H, P.mouth[1] + 0.04 * H, ez("io", seg(p, 0.22, 0.5)))]
				else:
					var q = seg(p, 0.82, 1); var from = [P.G[0], P.G[1]] if R.arm else [P.mouth[0] + 0.12 * H, P.mouth[1] + 0.04 * H]
					var to = [P.belly[0] + 0.02 * H, P.belly[1]] if (thief and j == ts) else [stackX, -0.012 * H - stacked * 0.022 * H]
					c = [lerp_(from[0], to[0], q), lerp_(from[1], to[1], ez("i", q)) - sin(q * PI) * 0.1 * H]
				coin(ctx, c[0], c[1], H, p * 9 + j, 1)
				if not R.arm and p < 0.82: wisp(ctx, P.mouth, c, H, 11 + j, 1)
			if p > 0.55 and p < 0.7: twinkle(ctx, P.G[0] if R.arm else P.mouth[0] + 0.12 * H, (P.G[1] if R.arm else P.mouth[1]) - 0.04 * H, (p - 0.55) * T / s, H * 0.7, j)
		if thief: twinkle(ctx, P.belly[0], P.belly[1], (b - (ts * T + T)) / s, H, 77)
	return {"k": k, "face": face, "back": back, "front": front}
# ---------- 倉庫：推米袋 ----------
static func f_push(a: Dictionary, _R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H)
	var k = kf([[0.0, {}], [0.4, {"lean": -4, "bend": -4, "sy": 1.03}, "o"], [0.8, {"lean": 18, "bend": 16, "dx": 0.08, "sy": 0.93, "sx": 1.05, "hx": 0.05}, "i"], [1.6, {"lean": 20, "bend": 18, "dx": 0.2, "sy": 0.92, "sx": 1.06, "hx": 0.05}, "io"],
		[1.9, {"lean": 12, "bend": 10, "dx": 0.2, "sy": 0.97, "hx": 0.03}, "o"], [2.3, {"lean": -6, "bend": -6, "dx": 0.18, "sy": 1.04, "head": -6}, "o"], [2.8, {"dx": 0.08, "sy": 0.98}, "io"], [3.4, {}, "io"]], t)
	if t > 0.8 and t < 1.6: k["dx"] += sin((t - 0.8) * 30) * 0.004
	var slide = 0.12 * ez("io", seg(t, 0.85, 1.6)) * (1 - ez("io", seg(t, 2.6, 3.4)))
	var back = func(ctx: Ctx, _P): prop(ctx, "store__sack", (0.42 + slide) * H, 0.5, 0.38 * H, 0, {"an": [0.5, 1.0]})
	var front = func(ctx: Ctx, _P): puff(ctx, 0.5 * H, 0, t - 1.1, 0.5, 0.25 * H, 81); puff(ctx, 0.56 * H, 0, t - 1.45, 0.5, 0.22 * H, 82)
	return {"k": k, "back": back, "front": front}
# ---------- 工頭：巡視 ----------
static func f_inspect(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H)
	var face = 1.0
	if t > 0.6 and t < 1.4: face = -1.0
	var point = ({"hr": -70, "hx": 0.03, "hy": -0.02, "lean": 4, "head": -4} if R.long else {"hx": 0.05, "hy": -0.04, "hr": -30, "lean": 6, "head": -4}) if R.arm else {"lean": 10, "dx": 0.03, "head": -6}
	var k = kf([[0.0, {}], [0.5, {"head": -6}], [0.7, {"head": 4}, "o"], [1.3, {"head": 4}], [1.5, {"head": -2}, "o"], [1.8, {"head": 8}, "io"], [2.0, {"head": -2}, "io"], [2.2, {"head": 8}, "io"], [2.5, {}, "io"],
		[2.8, point, "o"], [3.0, asg(point, {"dx": float(point.get("dx", 0)) + 0.02}), "o"], [3.15, point, "io"], [3.3, asg(point, {"dx": float(point.get("dx", 0)) + 0.02}), "o"], [3.7, point], [4.2, {}, "io"]], t)
	if t > 1.5 and t < 2.5:
		var c = absf(sin((t - 1.5) * PI * 4)); k["dy"] -= c * 0.012; k["sy"] *= 1 - (1 - c) * 0.015
	var front = func(ctx: Ctx, P: Dictionary): bang(ctx, P.top[0] + 0.14 * H, P.top[1] + 0.02 * H, H, seg(t, 2.8, 2.9) * (1 - seg(t, 3.6, 3.9)), 5)
	return {"k": k, "face": face, "front": front}
# ---------- 化寶爐：燒金紙 ----------
static func f_burn(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var H = J.num(a.H); var s = sp(v); var wk = 2.0 if J.t(J.gp(v, "walk")) else 0.0; var paper = PAPER.has(R.id); var fw = 1.0 if J.t(a.get("faceRight")) else -1.0
	var n = int(vn(v, "n"))
	var vst = J.gp(v, "stand")
	var st = [J.num(vst[0]) * fw, J.num(vst[1])] if J.t(vst) else [0.0, 0.0]
	var wt = J.gp(a.o, "wtarget")
	var tw = [J.num(wt[0]), J.num(wt[1])] if J.t(wt) else [0.75 * H * fw, -0.12 * H]
	var tg = [tw[0] * fw, tw[1]]
	var bt = at - wk; var total = (n * 1.4 + 0.6) / s; var dirOut = 1.0 if st[0] >= 0 else -1.0; var faceB = 1.0 if tg[0] >= 0 else -1.0
	var ox = 0.0; var oy = 0.0; var face = faceB; var walk = 0.0
	if wk != 0:
		if at < wk:
			var q = ez("sin", seg(at, 0, wk)); ox = st[0] / H * q; oy = st[1] * q; walk = at; face = dirOut
		elif bt > total:
			var q = ez("sin", seg(bt - total, 0, wk)); ox = st[0] / H * (1 - q); oy = st[1] * (1 - q); walk = at; face = -dirOut
		else: ox = st[0] / H; oy = st[1]
	var b = bt * s; var T = 1.4
	var k = DEF.duplicate()
	if bt >= 0 and bt <= total:
		var i = int(floor(b / T)); var p = fmod(b, T) / T
		if i < n:
			var flinch = {"lean": -18, "bend": -12, "head": -18, "dx": -0.12, "dy": -0.06, "sy": 1.08, "sx": 0.94} if paper else {"lean": -10, "bend": -6, "head": -10, "dx": -0.05, "sy": 0.95, "sx": 1.04}
			k = kf([[0.0, {}], [0.3, {"lean": -6, "bend": -4, "hx": -0.04, "hy": -0.02, "hr": -25, "sy": 1.03}, "o"], [0.45, {"lean": 8, "bend": 8, "hx": 0.05, "hy": -0.03, "hr": 30, "sy": 0.97}, "i"],
				[0.62, {"lean": 5, "bend": 5, "hx": 0.03, "hr": 15}, "o"], [0.72, flinch, "o"], [0.9, flinch], [1.0, {}, "io"]], p)
			if paper and p > 0.72 and p < 0.92: k["dx"] += sin(p * 120) * 0.006
	var fr = {"k": k, "face": face, "ox": ox, "oy": oy, "walk": walk}
	fr["front"] = func(ctx: Ctx, P: Dictionary):
		if bt < 0 or bt > total: return
		var i = int(floor(b / T)); var p = fmod(b, T) / T; var mouth = [st[0] + tg[0], st[1] + tg[1]]
		if i < n:
			var hand = [P.G[0], P.G[1] - 0.02 * H] if R.arm else [P.belly[0] + 0.08 * H * face, P.belly[1] - 0.08 * H]
			if p < 0.45: prop(ctx, "furnace__paper", hand[0], hand[1], 0.13 * H * ez("back", seg(p, 0, 0.15)), -20, {"an": [0.5, 0.5]})
			elif p < 0.7:
				var q = seg(p, 0.45, 0.7); prop(ctx, "furnace__paper", lerp_(hand[0], mouth[0], q), lerp_(hand[1], mouth[1], q) - sin(q * PI) * 0.14 * H, 0.13 * H * (1 - 0.4 * q), -20 + q * 260, {"an": [0.5, 0.5]})
			if not R.arm and p < 0.7: wisp(ctx, P.belly, hand, H, 4, 1)
		for j in n: flame(ctx, mouth[0], mouth[1] + 0.05 * H, (b - (j * T + 0.68 * T)) / s, 0.55, H * (1.15 if paper else 1.0), 90 + j)
	return fr
# ---------- 陰兵營：原地踏步 ----------
static func f_march(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var n = vn(v, "n"); var b = t - 0.3
	var k = kf([[0.0, {}], [0.3, {"head": -6, "sy": 1.03}]], t)
	if b > 0 and b < n * 0.5:
		var ph = b / 0.5 * PI; var c = sin(ph)
		k = asg(DEF, {"head": -6.0, "hx": c * 0.03, "hr": c * (30.0 if R.long else 12.0), "lean": 2.0})
		if R.hop:
			var h = absf(c); k["dy"] = -h * 0.08; k["sy"] = 1 - (1 - minf(1, h * 5)) * 0.06
		elif not R.legs:
			k["dy"] = -absf(c) * 0.035; k["lean"] += c * 3; k["sy"] = 1 + absf(c) * 0.02
		else: k["dy"] = -absf(c) * 0.02
	elif b >= n * 0.5:
		var q = b - n * 0.5; k = kf([[0.0, {"head": -6}], [0.12, {"dy": -0.03, "head": -8, "sy": 1.05}, "o"], [0.25, {"sy": 0.92, "sx": 1.05, "head": -4}, "i"], [0.5, {}, "io"]], q)
	var fr = {"k": k}
	if R.legs and b > 0 and b < n * 0.5: fr["walk"] = b * 0.5 / 0.5 * PI / 8 * 2
	fr["front"] = func(ctx: Ctx, _P):
		if b > n * 0.5: puff(ctx, 0, 0, (b - n * 0.5 - 0.22) / s, 0.45, 0.3 * H, 12)
	return fr
# ---------- 陰兵營：立正、敬禮 ----------
static func f_salute(_a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v)
	var sal = ({"hr": -115, "hx": 0.02, "hy": -0.05, "head": -6} if R.long else {"hx": -0.03, "hy": -0.06, "hr": -20, "head": -4}) if R.arm else {"head": -8}
	var k = kf([[0.0, {}], [0.25, {"dy": -0.03, "sy": 1.06, "sx": 0.95, "head": -8}, "o"], [0.4, {"sy": 1.04, "sx": 0.97, "head": -8}, "io"], [0.6, asg({"sy": 1.04}, sal), "o"],
		[1.5, asg({"sy": 1.04}, sal)], [1.75, {"sy": 1.02, "head": -4}, "io"], [2.15, {"bend": 30, "lean": 10, "head": 14, "sy": 0.98}, "io"], [2.45, {"bend": 31, "lean": 10, "head": 15}], [2.85, {"head": -4}, "io"], [3.2, {}, "io"]], t)
	return {"k": k}
# ---------- 陰兵營：操練 ----------
static func f_drill(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var n = int(vn(v, "n")); var T = 0.9; var i = int(floor(t / T)); var p = fmod(t, T) / T
	var k = DEF.duplicate()
	if i < n: k = kf([[0.0, {}], [0.4, {"lean": -8, "bend": -6, "dx": -0.04, "hx": -0.03, "hr": -20, "sy": 1.03, "sx": 0.97, "head": -4}, "o"], [0.52, {"lean": 14, "bend": 10, "dx": 0.1, "hx": 0.05, "hr": 45.0 if R.long else 15.0, "sy": 0.95, "sx": 1.05, "head": 4}, "i3"],
		[0.7, {"lean": 12, "bend": 9, "dx": 0.1, "hx": 0.05, "hr": 42.0 if R.long else 14.0, "sy": 0.97, "sx": 1.03}, "o"], [1.0, {}, "io"]], p)
	var front = func(ctx: Ctx, P: Dictionary):
		for j in n:
			var g = (t - (j * T + 0.52 * T)) / s
			if g < 0 or g > 0.3: continue
			var pp: Array = P.G if R.arm else P.mouth
			J.mc(MK(), "speed", [ctx, pp[0] + 0.04 * H, pp[1], 1.0, 0.0, 0.18 * H, 0.08 * H, 1 - g / 0.3, "rgba(255,240,210,.85)", 20.0 + j, 3.0])
			burst(ctx, pp[0] + 0.14 * H, pp[1], 0.1 * H, 1 - g / 0.3, "#ffe9a0", 30 + j, 7)
	return {"k": k, "front": front}
# ---------- 嚇人訓練班：縮埋 → 彈起「嘩！」 ----------
static func f_boo(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var s = sp(v); var t = at * s; var H = J.num(a.H); var n = int(vn(v, "n")); var T = 1.7; var i = int(floor(t / T)); var p = fmod(t, T)
	var k = DEF.duplicate()
	if i < n: k = kf([[0.0, {}], [0.45, {"sy": 0.9, "sx": 1.06, "bend": 22, "lean": 6, "head": 12, "hx": -0.02, "hy": 0.03}, "io"], [0.75, {"sy": 0.9, "sx": 1.06, "bend": 24, "lean": 7, "head": 14, "hx": -0.02, "hy": 0.03}],
		[0.86, {"dy": -0.07, "sy": 1.12, "sx": 0.92, "bend": -6, "lean": -4, "head": -12, "hx": 0.03, "hy": -0.1, "hr": -70.0 if R.long else -30.0}, "o"], [1.25, {"dy": -0.05, "sy": 1.08, "sx": 0.95, "bend": -5, "lean": -3, "head": -10, "hx": 0.03, "hy": -0.09, "hr": -66.0 if R.long else -28.0}], [1.7, {}, "io"]], p)
	var front = func(ctx: Ctx, P: Dictionary):
		for j in n:
			var g = (t - (j * T + 0.86)) / s
			if g < 0 or g > 0.35: continue
			burst(ctx, P.mouth[0] + 0.1 * H, P.mouth[1] - 0.02 * H, 0.13 * H, 1 - g / 0.35, "#e8d0ff", 40 + j, 8)
	return {"k": k, "front": front}
# ---------- 嚇人訓練班：扮鬼臉 ----------
static func f_grimace(a: Dictionary, R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H); var w = sin((t - 0.3) * 7.5) if (t > 0.3 and t < 2.4) else 0.0
	var e = minf(1, maxf(0, (t - 0.3) * 4)) * minf(1, maxf(0, (2.4 - t) * 4))
	var k = asg(DEF, {"head": w * 14 * e - 4 * e, "lean": w * 4 * e, "sx": 1 + 0.05 * w * e, "sy": 1 - 0.05 * w * e, "hx": 0.02 * e, "hy": -0.04 * e, "hr": (-40.0 if R.long else -14.0) * e})
	var front = func(ctx: Ctx, P: Dictionary):
		if e > 0.5 and absf(w) > 0.92: burst(ctx, P.mouth[0] + 0.06 * H * signf(w), P.mouth[1] - 0.05 * H, 0.06 * H, 0.6, "#ffe0f0", 60 + round(t * 3), 5)
	return {"k": k, "front": front}
# ---------- 嚇人訓練班：練「背後吹氣」 ----------
static func f_blow(a: Dictionary, _R: Dictionary, at: float, v) -> Dictionary:
	var t = at * sp(v); var H = J.num(a.H)
	var k = kf([[0.0, {}], [0.4, {"dy": 0.01, "sy": 1.04, "sx": 0.97, "bend": -6, "head": -8}, "io"], [0.6, {"lean": 14, "bend": 12, "head": 8, "sy": 0.96, "sx": 1.03, "dx": 0.03}, "o"], [1.8, {"lean": 15, "bend": 13, "head": 9, "sy": 0.97, "sx": 1.02, "dx": 0.035}], [2.6, {}, "io"]], t)
	var front = func(ctx: Ctx, P: Dictionary):
		for j in 4:
			var g = t - 0.6 - j * 0.25; puff(ctx, P.mouth[0] + 0.05 * H + maxf(0, g) * 0.25 * H, P.mouth[1], g, 0.9, 0.22 * H, 80 + j)
	return {"k": k, "front": front}

# ===================== 對外：DAILY 登記 =====================
static func run_act(name: String, ctx, a) -> bool:
	if not (ctx is Ctx) or not (a is Dictionary): return false
	var R = rigOf(J.str(a.type))
	if R == null or _g("MoveKit") == null: return false
	if not R.special and not R.mesh: return false
	var wv = J.gp(a.o, "wv")
	var v = wv if J.t(wv) else defaults(name, J.str(a.type), 1)
	var at0 = J.gp(a.o, "at"); var at = maxf(0, J.num(at0) if J.t(at0) else 0.0)
	var fr = f_act(name, a, R, at, v)
	render(ctx, a, fr)
	return true

# ===================== 排班：每個崗位做邊幾種，輪住做、唔同步 =====================
static func defaults(name: String, _type: String, r: float) -> Dictionary:
	var Rf = func(x: float) -> float: return rnd(r * 13.7 + x * 7.1)
	var v = {"sp": 0.88 + Rf.call(1) * 0.24, "seed": floor(Rf.call(2) * 100)}
	match name:
		"chop", "reap": v["n"] = 3 + floor(Rf.call(3) * 2)
		"plant": v["n"] = 3.0
		"hammer": v["n"] = 2 + floor(Rf.call(3) * 2)
		"sand": v["n"] = 4 + floor(Rf.call(3) * 2)
		"knead": v["n"] = 4 + floor(Rf.call(3) * 3)
		"coins": v["n"] = 4 + floor(Rf.call(3) * 2)
		"burn": v["n"] = 2 + floor(Rf.call(3) * 2)
		"march": v["n"] = 8 + 2 * floor(Rf.call(3) * 3)
		"boo": v["n"] = 2.0
		"drill": v["n"] = 3.0
	return v
static func pickNext(post: String, type: String, prev, info) -> String:
	var all: Array = POST_ACTS.get(post, [["rest", 1.0]])
	var list = []
	for e in all: if e[0] != prev: list.append(e)
	if not J.t(info) or not J.t(J.gp(info, "furnace")):
		var l2 = []
		for e in list: if e[0] != "burn": l2.append(e)
		list = l2
	if list.is_empty(): list = all
	var wt = func(e: Array) -> float: return e[1] * (4.0 if (e[0] == "sneak" and GLUTTON.has(type)) else 1.0) * (2.0 if (e[0] == "coins" and type == "toyol") else 1.0)
	var sum = 0.0
	for e in list: sum += wt.call(e)
	var r = randf() * sum
	for e in list:
		r -= wt.call(e)
		if r <= 0: return e[0]
	return list[0][0]
static func plan(s, t: float, info) -> Dictionary:
	var g = J.gp(s, "g"); var gid = J.gp(g, "id"); var id = gid if J.t(gid) else J.gp(g, "k")
	var gk = J.str(J.gp(g, "k")); var post = J.str(J.gp(s, "post"))
	var st = STATE.get(id)
	if st != null and (st.post != post or t < st.t0 - 1 or st.k != gk): st = null
	var fresh = func(prev) -> Dictionary:
		var act = pickNext(post, gk, prev, info); var v = defaults(act, gk, randf() * 1000 + 1)
		if act == "haul" or act == "crate":
			var fw = -1.0 if J.t(J.gp(s, "flip")) else 1.0; var px = J.num(J.gp(s, "x")) - fw * 58; v["mirror"] = px < 14 or px > 376
		if act == "burn":
			v["walk"] = 1.0; var fu = J.gp(info, "furnace"); var sx = J.num(J.gp(s, "x")); var sy = J.num(J.gp(s, "y"))
			var side = -1.0 if J.num(fu[0]) >= sx else 1.0; v["stand"] = [J.num(fu[0]) + side * 30 - sx, J.num(fu[1]) + 16 - sy]
		return {"act": act, "v": v}
	if st == null:
		var n0: Dictionary = fresh.call(null); st = {"post": post, "k": gk, "act": n0.act, "v": n0.v, "dur": dur(n0.act, n0.v)}; st["t0"] = t - randf() * st.dur * 0.9; STATE[id] = st
	if t - st.t0 >= st.dur:
		var n1: Dictionary = fresh.call(st.act); st["act"] = n1.act; st["v"] = n1.v; st["t0"] = t + randf() * 0.35; st["dur"] = dur(n1.act, n1.v)
	return st
static func drawWorker(ctx, s, t: float, scale, info) -> Dictionary:
	if not J.t(info): info = {}
	var g = J.gp(s, "g"); var k = J.str(J.gp(g, "k")); var sc = J.num(scale) if J.t(scale) else 0.62; var st = plan(s, t, info); var at = maxf(0, t - st.t0)
	var ph = J.gp(s, "ph"); var sflip = J.t(J.gp(s, "flip"))
	var o = {"t": t + (J.num(ph) if J.t(ph) else 0.0), "flip": (not sflip) if J.t(st.v.get("mirror")) else sflip, "tamed": true, "untied": true, "act": "work_" + st.act, "at": at, "wv": st.v, "wkey": J.gp(g, "id")}
	var fu = J.gp(info, "furnace")
	if st.act == "burn" and st.v.get("stand") != null and J.t(fu):
		o["wtarget"] = [J.num(fu[0]) - (J.num(J.gp(s, "x")) + st.v.stand[0]), J.num(fu[1]) - (J.num(J.gp(s, "y")) + st.v.stand[1])]
	var ART = _g("ART")
	if special_has(k):
		if not run_act(st.act, ctx, {"type": k, "x": J.gp(s, "x"), "y": J.gp(s, "y"), "s": sc, "H": SPECIAL_H.get(k, 50.0) * sc, "o": o, "faceRight": not o.flip, "solid": true}):
			J.mc(ART, "drawChar", [ctx, k, J.gp(s, "x"), J.gp(s, "y"), sc, {"t": o.t, "work": true, "flip": sflip, "tamed": true, "untied": true}])
		return st
	J.mc(ART, "drawChar", [ctx, k, J.gp(s, "x"), J.gp(s, "y"), sc, o])
	return st
static func drawAct(ctx, type: String, x, y, sc, act: String, at, o2) -> void:
	var wv = J.gp(o2, "wv") if J.t(o2) else null
	var v = wv if J.t(wv) else defaults(act, type, 1)
	var o = {"t": at, "act": "work_" + act, "at": at, "wv": v}
	if o2 is Dictionary: for kk in o2: o[kk] = o2[kk]
	if special_has(type):
		if not run_act(J.str(o.act).substr(5), ctx, {"type": type, "x": x, "y": y, "s": sc, "H": SPECIAL_H.get(type, 50.0) * J.num(sc), "o": o, "faceRight": not J.t(o.get("flip")), "solid": true}):
			J.mc(_g("ART"), "drawChar", [ctx, type, x, y, sc, o])
		return
	J.mc(_g("ART"), "drawChar", [ctx, type, x, y, sc, o])

static func reset() -> void:
	RC = {}; AIM = {}; TINT = {}; STATE = {}

func run(_env) -> void:
	reset()
	var DA = J.G.get("DAILY")
	if not (DA is Dictionary): DA = {}; J.G["DAILY"] = DA
	var ACT = {}
	for n in NAMES:
		var nn: String = n
		DA["work_" + nn] = func(_t, a): return run_act(nn, J.arg(a, 0), J.arg(a, 1))
		ACT[nn] = {"dur": func(_t, a): return dur(nn, J.arg(a, 0)), "f": func(_t, a): return f_act(nn, J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.arg(a, 3))}
	var PA = {}
	for p in POST_ACTS: PA[p] = POST_ACTS[p].duplicate(true)
	J.G["WORK"] = {
		"drawWorker": func(_t, a): return drawWorker(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.arg(a, 3), J.arg(a, 4)),
		"drawAct": func(_t, a): drawAct(J.arg(a, 0), J.str(J.arg(a, 1)), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.str(J.arg(a, 5)), J.arg(a, 6), J.arg(a, 7)); return null,
		"ACT": ACT, "POST_ACTS": PA, "STATE": STATE,
		"defaults": func(_t, a): return defaults(J.str(J.arg(a, 0)), J.str(J.arg(a, 1)), J.num(J.arg(a, 2))),
		"rigOf": func(_t, a): return rigOf(J.str(J.arg(a, 0))),
		"render": func(_t, a): return render(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"kf": func(_t, a): return kf(J.arg(a, 0), J.num(J.arg(a, 1))),
	}
