# 原生改寫自 npc_antag.js：三個反派 NPC（籃球仔 npc_rival、HR 姐 npc_hr、陰間大老闆 npc_kpiboss）嘅畫法
# 只動原圖：每人 4 張原畫（站、走、招牌動作、嚇親），網格變形（N30K／MeshAnim）＋原圖剪出嚟嘅籃球；蠟筆小特效程式畫
# 載入時照 JS 登記：MeshAnim.RIG／NATIVE_R、RIG[id].custom、ART.CHAR_H、DAILY.ag_<狀態>、MOVES.npc_*
# 介面：J.G["Antag"] = { draw, STATES, ZH, dur, P }
# 注意：N.txt 嘅參數次序同 N30K 定義唔同（字號同文字對調）——網頁版原本就係咁，照傳以保持一致
extends RefCounted

const TAU := PI * 2
const P := {
	"npc_rival": {"h": 66.0, "solid": 0.0, "zh": "籃球仔", "poses": {
		"stand": {"img": "npc_rival", "k": 1.0, "nr": 0.0, "rig": {"c": 0.55, "n": 0.38, "h": 0.58, "ht": 0.03, "hr": 0.24, "L": [0.45, 0.43, 0.25, 0.30], "R": [0.72, 0.43, 0.74, 0.70], "tail": 0.72}},
		"walk": {"img": "npc_rival_walk", "k": 0.91, "nr": 0.0, "rig": {"c": 0.55, "n": 0.38, "h": 0.48, "ht": 0.03, "hr": 0.24, "L": [0.45, 0.46, 0.25, 0.58], "R": [0.72, 0.46, 0.92, 0.76], "tail": 0.75}},
		"gossip": {"img": "npc_rival_gossip", "k": 0.88, "nr": 0.0, "rig": {"c": 0.55, "n": 0.42, "h": 0.35, "ht": 0.03, "hr": 0.26, "L": [0.42, 0.46, 0.24, 0.36], "R": [0.74, 0.44, 0.70, 0.30], "tail": 0.40}},
		"jump": {"img": "npc_rival_jump", "k": 0.74, "nr": 0.0, "rig": {"c": 0.45, "n": 0.46, "h": 0.42, "ht": 0.05, "hr": 0.24, "L": [0.38, 0.52, 0.10, 0.32], "R": [0.55, 0.52, 0.50, 0.45], "tail": 0.62}}}},
	"npc_hr": {"h": 60.0, "solid": 0.0, "zh": "HR 姐", "poses": {
		"stand": {"img": "npc_hr", "k": 1.0, "nr": 0.0, "rig": {"c": 0.52, "n": 0.46, "h": 0.42, "ht": 0.02, "hr": 0.32, "L": [0.30, 0.52, 0.12, 0.60], "R": [0.72, 0.52, 0.55, 0.52], "tail": 0.88}},
		"walk": {"img": "npc_hr_walk", "k": 0.81, "nr": 0.0, "rig": {"c": 0.50, "n": 0.46, "h": 0.45, "ht": 0.02, "hr": 0.30, "L": [0.35, 0.52, 0.08, 0.53], "R": [0.72, 0.54, 0.55, 0.62], "tail": 0.75}},
		"stamp": {"img": "npc_hr_stamp", "k": 0.83, "nr": 0.0, "rig": {"c": 0.55, "n": 0.50, "h": 0.45, "ht": 0.04, "hr": 0.30, "L": [0.40, 0.56, 0.38, 0.76], "R": [0.74, 0.60, 0.62, 0.76], "tail": 0.80}},
		"jump": {"img": "npc_hr_jump", "k": 0.75, "nr": 0.0, "rig": {"c": 0.60, "n": 0.50, "h": 0.55, "ht": 0.03, "hr": 0.28, "L": [0.45, 0.55, 0.22, 0.55], "R": [0.80, 0.56, 0.80, 0.66], "tail": 0.45}}}},
	"npc_kpiboss": {"h": 66.0, "solid": 0.0, "zh": "陰間大老闆", "poses": {
		"stand": {"img": "npc_kpiboss", "k": 1.0, "nr": 1.0, "rig": {"c": 0.50, "n": 0.43, "h": 0.52, "ht": 0.04, "hr": 0.32, "L": [0.22, 0.46, 0.12, 0.64], "R": [0.80, 0.46, 0.90, 0.64], "tail": 0.32}},
		"walk": {"img": "npc_kpiboss_walk", "k": 1.03, "nr": 1.0, "rig": {"c": 0.45, "n": 0.43, "h": 0.48, "ht": 0.04, "hr": 0.30, "L": [0.30, 0.46, 0.55, 0.55], "R": [0.74, 0.50, 0.86, 0.48], "tail": 0.12}},
		"yell": {"img": "npc_kpiboss_yell", "k": 0.90, "nr": 1.0, "rig": {"c": 0.40, "n": 0.46, "h": 0.52, "ht": 0.04, "hr": 0.30, "L": [0.18, 0.50, 0.14, 0.66], "R": [0.60, 0.55, 0.70, 0.86], "tail": 0.10}},
		"jump": {"img": "npc_kpiboss_jump", "k": 1.0, "nr": 1.0, "rig": {"c": 0.45, "n": 0.43, "h": 0.48, "ht": 0.04, "hr": 0.30, "L": [0.30, 0.50, 0.26, 0.56], "R": [0.76, 0.50, 0.86, 0.44], "tail": 0.20}}}},
}
const CUTS := {"npc_rival": ["ball", "swoosh", "swoosh2"], "npc_rival_walk": ["ball", "fx"]}
const BALL := {"npc_rival": [0.228, 0.158], "npc_rival_walk": [0.205, 0.71]}
const PRE := {"npc_rival": "rival", "npc_hr": "hr", "npc_kpiboss": "kpi"}
const DUR := {"spin": 2.4, "dribble": 2.5, "jumpshot": 2.2, "gossip": 3.6, "clip": 3.2, "glasses": 2.6, "stamp": 2.0, "inspect": 4.0, "tap": 3.0, "sigh": 3.2, "yell": 2.2, "jump": 1.4, "idle": 4.0, "walk": 2.0}
const STATES := {
	"npc_rival": ["idle", "walk", "spin", "dribble", "jumpshot", "gossip", "jump", "attack", "hurt", "scared", "down", "die"],
	"npc_hr": ["idle", "walk", "clip", "glasses", "stamp", "jump", "attack", "hurt", "scared", "down", "die"],
	"npc_kpiboss": ["idle", "walk", "inspect", "tap", "sigh", "yell", "jump", "attack", "hurt", "scared", "down", "die"],
}
const ACT_NAMES := ["rival_idle", "spin", "dribble", "jumpshot", "gossip", "rival_walk", "rival_jump", "hr_idle", "clip", "glasses", "stamp", "hr_walk", "hr_jump",
	"kpi_idle", "inspect", "tap", "sigh", "yell", "kpi_walk", "kpi_jump"]

static var N = null
static var PD: Dictionary = {}   # P 嘅可改副本（MeshAnim.mk 會攞住 rig；對外 Antag.P 同 JS 一樣係同一份）

static func _g(n: String): return J.G.get(n)
static func n_(m: String, a: Array): return J.mc(N, m, a)
# MoveKit 嘅小工具（同 moves_chain.js 一模一樣）
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func seg(t: float, a: float, b: float) -> float: return cl((t - a) / (b - a))
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func Eo(t: float) -> float: return 1 - (1 - t) * (1 - t)
static func Ei(t: float) -> float: return t * t
static func Eio(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func sw(g: float, n := 1.0, ph := 0.0) -> float: return sin(g * TAU * n + ph)
static func bump(g: float, a: float, b: float) -> float: return sin(seg(g, a, b) * PI)
static func TC() -> float: return J.num(J.gp(N, "TC"))
static func H(S) -> float: return J.num(J.gp(S, "H"))
static func _spr(k): return J.gp(_g("SPR"), k)
static func _nat_wh(im) -> float: return J.num(J.gp(im, "naturalWidth")) / J.num(J.gp(im, "naturalHeight"))
static func A(base, o: Dictionary) -> Dictionary:
	var r = {}
	for k in J.keys(base): r[k] = J.gp(base, k)
	for k in o: r[k] = o[k]
	return r

static func nb(img: String) -> String:
	if CUTS.has(img): return J.str(J.mc(_g("N30"), "cutBody", [img, CUTS[img].duplicate(), img + "__nb"]))
	return img
# 某張原畫嘅「S」
static func pose_s(S, id: String, pk: String):
	var p = P[id].poses[pk]; var im = _spr(p.img)
	if not J.t(im) or not J.t(n_("ok", [p.img])): return null
	var h = H(S) * p.k
	return A(S, {"id": p.img, "nr": J.t(p.nr), "H": h, "W": h * _nat_wh(im), "k": p.k})
# 網格姿勢：底子 = 待機（或走路），extra 正 = 往前
static func mp(S2, extra, walkT, idleK):
	var z
	if walkT != null:
		z = J.mc(J.gp(_g("MeshAnim"), "ANIM"), "walk", [walkT])
		for n in J.keys(z):
			var v = J.gp(z, n)
			if (v is float or v is int) and not (n in ["y", "sx", "sy"]) and not J.t(J.gp(S2, "nr")): J.sp(z, n, -v)
		J.sp(z, "x", 0.0); J.sp(z, "rot", 0.0)
	else: z = n_("pose", [S2, {}, 0.7 if idleK == null else idleK])
	if J.t(extra):
		for n in J.keys(extra):
			if n in ["x", "y", "r", "px", "py", "sx", "sy", "a"]: continue
			var cur = J.gp(z, n)
			var ev = J.num(J.gp(extra, n))
			J.sp(z, n, (J.num(cur) if J.t(cur) else 0.0) + (ev if J.t(J.gp(S2, "nr")) else -ev))
	return z
static func draw_pose(ctx, S, id: String, pk: String, f: Dictionary, opt = null):
	var S2 = pose_s(S, id, pk)
	if S2 == null: return null
	var o = opt if opt is Dictionary else {}
	var m = n_("bm", [S2, f])
	n_("body", [ctx, S2, m, mp(S2, f, o.get("walkT"), o.get("idleK")), nb(J.str(S2.id)) if J.t(o.get("cut")) else S2.id, f.a if f.get("a") != null else null])
	return {"S2": S2, "m": m}
static func setup(a): return n_("setup", [a])
static func begin(ctx, S, f, sk) -> void:
	J.mc(ctx, "save", []); J.mc(J.gp(N, "K"), "enter", [ctx, S])
	var fx = J.gp(f, "x") if f != null else null
	n_("shadow", [ctx, S, fx if J.t(fx) else 0.0, 0.0, sk])
static func end_(ctx) -> void: J.mc(ctx, "restore", [])
static func ball(ctx, S2, x, y, rot, sc = null) -> void:   # 一律用站姿原畫剪出嚟嗰粒完整嘅波
	var im = _spr("npc_rival")
	if not J.t(im): return
	var st_ = A(S2, {"id": "npc_rival", "nr": false})
	st_["H"] = H(S2) / J.num(S2.k); st_["W"] = st_.H * _nat_wh(im)
	var c = BALL.npc_rival
	n_("pieceAt", [ctx, st_, "ball", x, y, rot, c[0], c[1], J.num(sc) if J.t(sc) else 1.0])
static func ball_rest(S2, m):
	var b = BALL[J.str(S2.id)]
	return n_("at", [S2, m, b[0], b[1]])
static func ball_r(S2) -> float: return 0.192 * (H(S2) / J.num(S2.k)) * _nat_wh(_spr("npc_rival"))
# 蠟筆印章
static func seal(ctx, S, x, y, size, txt, k, al) -> void:
	if al <= 0: return
	var z = 1.6 - 0.6 * Eo(k) if k < 1 else 1.0
	J.mc(ctx, "save", []); J.mc(ctx, "translate", [x, y]); J.mc(ctx, "scale", [J.gp(S, "fw"), 1.0]); J.mc(ctx, "rotate", [-0.18]); J.mc(ctx, "scale", [z, z])
	J.sp(ctx, "globalAlpha", J.num(J.gp(ctx, "globalAlpha")) * cl(al))
	J.sp(ctx, "strokeStyle", "#d0141e"); J.sp(ctx, "lineWidth", size * 0.09); J.sp(ctx, "lineJoin", "round")
	J.mc(ctx, "strokeRect", [-size * 0.55, -size * 0.32, size * 1.1, size * 0.64]); J.mc(ctx, "strokeRect", [-size * 0.48, -size * 0.25, size * 0.96, size * 0.5])
	J.sp(ctx, "fillStyle", "#d0141e"); J.sp(ctx, "font", "900 " + J.str(size * 0.42) + "px \"PingFang TC\",\"Noto Sans TC\",\"Noto Sans CJK TC\",serif"); J.sp(ctx, "textAlign", "center"); J.sp(ctx, "textBaseline", "middle")
	J.mc(ctx, "fillText", [txt, 0.0, size * 0.02])
	J.mc(ctx, "restore", [])
# 紅色 KPI 跌勢圖
static func crash(ctx, x, y, w, k, seed_) -> void:
	if k <= 0: return
	var pts = []; var n = 6
	for i in n + 1:
		var q = float(i) / n
		if q > k: break
		pts.append([x - w / 2 + q * w, y - w * 0.35 + q * w * 0.7 + (-w * 0.14 if i % 2 else w * 0.06)])
	if pts.size() < 2: return
	n_("crayon", [ctx, pts, "#ffffff", w * 0.1, seed_]); n_("crayon", [ctx, pts, "#e0202a", w * 0.06, seed_ + 1])
	var e = pts[-1]; var p0 = pts[-2]; var an = atan2(e[1] - p0[1], e[0] - p0[0])
	J.mc(ctx, "save", []); J.mc(ctx, "translate", [e[0], e[1]]); J.mc(ctx, "rotate", [an]); J.sp(ctx, "fillStyle", "#e0202a"); J.mc(ctx, "beginPath", [])
	J.mc(ctx, "moveTo", [w * 0.12, 0.0]); J.mc(ctx, "lineTo", [-w * 0.04, -w * 0.08]); J.mc(ctx, "lineTo", [-w * 0.04, w * 0.08]); J.mc(ctx, "closePath", []); J.mc(ctx, "fill", []); J.mc(ctx, "restore", [])
static func rings(ctx, x, y, r, k, col) -> void:
	for i in 3:
		var q = cl(k * 1.4 - i * 0.2)
		if q > 0 and q < 1: n_("ring", [ctx, x, y, r * (0.3 + q), r * (0.3 + q) * 0.8, col, r * 0.06 * (1 - q) + 1, 1 - q])
static func _txt(ctx, S, x, y, a4, a5, col, al) -> void: n_("txt", [ctx, S, x, y, a4, a5, col, al])

# ======================= 狀態 =======================
static func act(name: String, ctx, S, g: float, t: float, walk := false) -> void:
	var h = H(S)
	match name:
		"rival_idle":
			var r = draw_pose(ctx, S, "npc_rival", "stand", {}, {"cut": true, "idleK": 0.8})
			if r == null: return
			var c = ball_rest(r.S2, r.m); ball(ctx, r.S2, c[0], c[1] + sin(t * 6) * 0.004 * h, t * 360)
		"spin":
			var r = draw_pose(ctx, S, "npc_rival", "stand", {"head": sw(g, 2) * 0.05, "body": sw(g) * 0.02}, {"cut": true})
			if r == null: return
			var c = ball_rest(r.S2, r.m)
			ball(ctx, r.S2, c[0], c[1] - absf(sw(g, 4)) * 0.006 * h, t * 900)
			J.mc(ctx, "save", []); J.mc(ctx, "translate", [c[0], c[1]]); J.mc(ctx, "rotate", [t * 6]); J.mc(ctx, "translate", [-c[0], -c[1]])
			n_("piece", [ctx, r.S2, "swoosh", r.m, 0.5, 1.0]); n_("piece", [ctx, r.S2, "swoosh2", r.m, 0.5, 1.0]); J.mc(ctx, "restore", [])
		"dribble":
			var ph = fmod(t * 2.4, 1.0)
			var f = {"body": 0.05, "y": -absf(sin(t * 3)) * 0.02 * h, "armF": -0.12 * cos(ph * TAU), "tail1": -0.2 + sin(t * 5) * 0.1, "tail2": -0.3 + sin(t * 5 - 1) * 0.15} if walk else {"body": 0.04 + 0.03 * absf(sw(ph)), "armF": -0.12 * cos(ph * TAU)}
			var r = draw_pose(ctx, S, "npc_rival", "walk", f, {"cut": true, "idleK": 1.0})
			if r == null: return
			var top = ball_rest(r.S2, r.m); var R = ball_r(r.S2); var floor_ = -R; var q = absf(cos(ph * PI))   # 1 喺手、0 喺地
			var by = lerp_(floor_, J.num(top[1]), q); var squash = 1 - (0.08 - q) * 2 if q < 0.08 else 1.0
			ball(ctx, r.S2, J.num(top[0]) + (0.0 if walk else sin(t * 1.2) * 0.04 * h), by, t * 120, 1.0)
			if squash < 1: n_("puff", [ctx, top[0], -0.01 * h, 0.05 * h, fmod(ph * 2, 1.0), "rgba(200,190,170,.45)", 3.0, 3.0])
			if q < 0.15: n_("piece", [ctx, r.S2, "fx", r.m, 0.5, 1.0, 1 - q / 0.15])
		"jumpshot":
			var f = n_("kf", [g, [[0.0, {}], [0.18, {"sy": 0.9, "sx": 1.04, "armF": -0.2}], [0.32, {"y": -0.28 * h, "sy": 1.05, "armF": -0.6, "armB": -0.4, "head": -0.1}, "o"], [0.48, {"y": 0.0, "sy": 0.94}, "i"], [0.6, {}]]])
			var r = draw_pose(ctx, S, "npc_rival", "stand", f, {"cut": true})
			if r == null: return
			var c0 = ball_rest(r.S2, r.m)
			var bx = J.num(c0[0]); var by = J.num(c0[1]); var rot = t * 300
			if g > 0.3 and g < 0.9:
				var q = seg(g, 0.3, 0.9); bx = J.num(c0[0]) + sin(q * PI) * 0.6 * h; by = J.num(c0[1]) - sin(q * PI) * 0.75 * h; rot = q * 900
			ball(ctx, r.S2, bx, by, rot)
			n_("pop", [ctx, A(S, {"tt": g}), 0.25 * h, -1.15 * h, "三分！", 0.13 * h, "#ffb347", 0.5, 0.45])
		"gossip":
			var r = draw_pose(ctx, S, "npc_rival", "gossip", {"head": sw(g, 3) * 0.04, "body": 0.03 + sw(g, 1.5) * 0.02, "armF": sw(g, 6) * 0.03})
			if r == null: return
			var mo = n_("at", [r.S2, r.m, 0.20, 0.30]); var lines = ["聽講……", "佢呀……", "咪講畀人知"]
			var i = int(floor(g * 3)) % 3; var q = fmod(g * 3, 1.0)
			_txt(ctx, S, J.num(mo[0]) - J.num(J.gp(S, "fw")) * 0 - 0.12 * h, J.num(mo[1]) - 0.1 * h - q * 0.06 * h, 0.085 * h, lines[i], "#f0e0ff", sin(q * PI))
		"rival_walk": act("dribble", ctx, S, g, t, true)
		"rival_jump":   # 三個都係鬼：冇腳，飄住行
			var j = bump(g, 0, 0.35); draw_pose(ctx, S, "npc_rival", "jump", {"y": -0.12 * h * j, "x": sin(t * 50) * 0.006 * h * (1 - j), "sy": 1 + 0.04 * j})
		# ---- HR 姐 ----
		"hr_idle": draw_pose(ctx, S, "npc_hr", "stand", {}, {"idleK": 0.8})
		"clip":
			var k = Eio(seg(g, 0.05, 0.2)) * (1 - Eio(seg(g, 0.85, 1)))
			var r = draw_pose(ctx, S, "npc_hr", "stand", {"head": 0.18 * k, "body": 0.04 * k, "armB": -0.12 * k + sw(g, 6) * 0.03 * k})
			if r == null: return
			var cb = n_("at", [r.S2, r.m, 0.55, 0.52])
			for i in 3:
				var q = seg(g, 0.25 + i * 0.18, 0.45 + i * 0.18)
				if q > 0 and q < 1: _txt(ctx, S, J.num(cb[0]) + (i - 1) * 0.06 * h, J.num(cb[1]) - 0.05 * h - q * 0.06 * h, 0.07 * h, "✗" if i == 2 else "✓", "#ff5050" if i == 2 else "#9ff0a0", sin(q * PI))
		"glasses":
			var k = bump(g, 0.1, 0.7); var r = draw_pose(ctx, S, "npc_hr", "stand", {"head": -0.1 * k, "armB": -0.35 * k})
			if r == null: return
			if g > 0.35 and g < 0.6:
				var p = n_("at", [r.S2, r.m, 0.35, 0.3]); n_("burst", [ctx, p[0], p[1], 0.08 * h, 1 - seg(g, 0.35, 0.6), "#ffffff", 5.0, 6.0])
			_txt(ctx, S, 0.15 * h, -1.05 * h, 0.08 * h, "嗯哼～", "#ffd0e0", bump(g, 0.4, 0.95))
		"stamp":
			var ph = fmod(g * 2, 1.0); var hit = ph > 0.45 and ph < 0.6
			var k = -Eo(ph / 0.4) if ph < 0.4 else (-1 + 2 * Ei((ph - 0.4) / 0.1) if ph < 0.5 else 1 - Eio(seg(ph, 0.5, 1)))
			var r = draw_pose(ctx, S, "npc_hr", "stamp", {"armF": -0.25 * k, "body": 0.05 * k, "head": 0.04 * k, "x": sin(t * 90) * 0.004 * h if hit else 0.0, "sy": 1 - 0.03 * maxf(0.0, k)})
			if r == null: return
			var sp = n_("at", [r.S2, r.m, 0.40, 0.86])
			if ph > 0.48:
				seal(ctx, S, J.num(sp[0]) - J.num(J.gp(S, "fw")) * 0, J.num(sp[1]) - 0.01 * h, 0.12 * h, "批", seg(ph, 0.48, 0.55), 1 - seg(ph, 0.85, 1))
				n_("burst", [ctx, sp[0], J.num(sp[1]) - 0.05 * h, 0.12 * h, 1 - seg(ph, 0.48, 0.65), "#ffe14a", 7.0, 7.0])
		"hr_walk": draw_pose(ctx, S, "npc_hr", "walk", {"body": 0.05, "y": -absf(sin(t * 3)) * 0.02 * h, "tail1": -0.2 + sin(t * 5) * 0.1, "tail2": -0.3 + sin(t * 5 - 1) * 0.15}, {"idleK": 1.0})
		"hr_jump":
			var j = bump(g, 0, 0.35); draw_pose(ctx, S, "npc_hr", "jump", {"y": -0.1 * h * j, "x": sin(t * 50) * 0.006 * h * (1 - j)})
		# ---- 陰間大老闆 ----
		"kpi_idle": draw_pose(ctx, S, "npc_kpiboss", "stand", {"y": -sin(t * 1.6) * 0.01 * h}, {"idleK": 0.8})
		"inspect":
			draw_pose(ctx, S, "npc_kpiboss", "stand", {"head": sw(g) * 0.12, "body": sw(g, 1, 0.5) * 0.03, "x": sw(g) * 0.04 * h})
			_txt(ctx, S, 0.25 * h, -1.1 * h, 0.085 * h, "嗯……", "#e8e8f0", bump(g, 0.3, 0.8))
		"tap":
			var r = draw_pose(ctx, S, "npc_kpiboss", "walk", {"armF": maxf(0.0, sw(g, 4)) * 0.08, "head": 0.06})
			if r == null: return
			var tb = n_("at", [r.S2, r.m, 0.80, 0.42])
			crash(ctx, J.num(tb[0]), J.num(tb[1]) - 0.32 * h, 0.22 * h, seg(g, 0.1, 0.6), 11.0)
			_txt(ctx, S, tb[0], J.num(tb[1]) - 0.55 * h, 0.08 * h, "又跌？", "#ff7070", bump(g, 0.5, 0.95))
		"sigh":
			var k = bump(g, 0.15, 0.9)
			draw_pose(ctx, S, "npc_kpiboss", "stand", {"head": 0.15 * k, "sy": 1 - 0.04 * k, "y": 0.02 * h * k})
			n_("puff", [ctx, 0.2 * h, -0.75 * h, 0.06 * h, seg(g, 0.3, 0.9), "rgba(220,220,230,.55)", 13.0, 4.0])
			_txt(ctx, S, 0.25 * h, -1.05 * h, 0.09 * h, "唉……", "#e0e0ea", bump(g, 0.3, 0.9))
		"yell":
			var sh = sin(t * 70) * 0.006 * h; var r = draw_pose(ctx, S, "npc_kpiboss", "yell", {"x": sh, "head": sw(g, 3) * 0.04})
			if r == null: return
			var mo = n_("at", [r.S2, r.m, 0.62, 0.36]); rings(ctx, J.num(mo[0]) + 0.1 * h, J.num(mo[1]), 0.3 * h, fmod(g * 2, 1.0), "rgba(255,240,240,.9)")
			_txt(ctx, S, 0.15 * h, -1.15 * h, 0.11 * h, "KPI 呢？！", "#ff5050", 0.95)
		"kpi_walk": draw_pose(ctx, S, "npc_kpiboss", "walk", {"body": 0.05, "y": -absf(sin(t * 3)) * 0.02 * h, "tail1": -0.2 + sin(t * 5) * 0.1, "tail2": -0.3 + sin(t * 5 - 1) * 0.15}, {"idleK": 1.0})
		"kpi_jump":
			var j = bump(g, 0, 0.35); draw_pose(ctx, S, "npc_kpiboss", "jump", {"y": -0.12 * h * j, "x": sin(t * 50) * 0.006 * h * (1 - j)})

# 搵狀態嘅畫法：通用名（idle/walk/jump）轉做每人自己嘅
static func act_fn(id: String, st: String) -> String:
	var own = J.str(PRE.get(id)) + "_" + st
	if own in ACT_NAMES: return own
	return st if (STATES[id].has(st) and st in ACT_NAMES) else ""
static func run_(ctx, a, st: String, at) -> bool:
	var S = setup(a)
	if not J.t(S): return false
	var fn = act_fn(J.str(J.gp(a, "type")), st)
	if fn == "": return false
	var dur = DUR.get(st, 2.0); var t = J.num(at) if J.t(at) else 0.0; var g = fmod(t, dur) / dur
	begin(ctx, S, null, 1.0 if J.t(J.gp(a, "solid")) else 0.8)
	act(fn, ctx, S, g, t, false); end_(ctx)
	return true
# drawMesh 嘅掛鉤：待機、走路、嚇親用各自嘅原畫
static func custom(ctx, a):
	var o = J.gp(a, "o"); var ps = J.str(J.gp(o, "pose"))
	if J.t(J.gp(o, "hurt")) or ps in ["hurt", "die", "down", "air", "cast", "faint"]: return false
	if ps in ["scared", "startle", "tremble", "cower"]: return run_(ctx, a, "jump", J.gp(o, "t"))
	if J.t(J.gp(o, "walk")) or ps in ["move", "walk", "run"]: return run_(ctx, a, "walk", J.gp(o, "t"))
	return run_(ctx, a, "idle", J.gp(o, "t"))

# ======================= 戰鬥招式（五段）=======================
static func move_rival(ctx, a):   # 入波
	var S = setup(a)
	if not J.t(S): return false
	var t = J.num(S.tt); var h = H(S); var th = J.num(S.th); var D2 = maxf(0.0, J.num(S.tx) - 0.45 * th - 0.25 * h); var tc = TC()
	var f = n_("kf", [t, [[0.0, {}], [0.16, {"sy": 0.88, "sx": 1.05, "armF": 0.3, "armB": 0.3, "head": 0.06}], [0.22, {"y": -0.35 * h, "x": D2 * 0.6, "sy": 1.06, "armF": -0.8, "armB": -0.5, "head": -0.1}, "o"], [tc, {"y": -0.18 * h, "x": D2, "armF": -0.2, "armB": -0.1, "r": 10.0, "head": 0.12}, "i"], [0.36, {"y": 0.0, "x": D2, "sy": 0.93}, "i"], [0.59, {}]]])
	var fy = J.gp(f, "y")
	begin(ctx, S, f, 1 - cl(-(J.num(fy) if J.t(fy) else 0.0) / h) * 0.6)
	var r = draw_pose(ctx, S, "npc_rival", "stand", f, {"cut": true})
	if r == null: end_(ctx); return false
	var c0 = ball_rest(r.S2, r.m); var hd = n_("tgt", [S, 0.95]); var chest = n_("at", [r.S2, r.m, 0.45, 0.42]); var R = ball_r(r.S2)
	var bx = 0.0; var by = 0.0; var rot = t * 600
	if t < 0.16:
		var q = Eio(seg(t, 0.02, 0.16)); bx = lerp_(J.num(c0[0]), J.num(chest[0]), q); by = lerp_(J.num(c0[1]), J.num(chest[1]), q)
	elif t < 0.22:
		var up = n_("at", [r.S2, r.m, 0.30, 0.0]); bx = lerp_(J.num(chest[0]), J.num(up[0]), Eo(seg(t, 0.16, 0.22))); by = lerp_(J.num(chest[1]), J.num(up[1]), Eo(seg(t, 0.16, 0.22)))
	elif t < tc:
		var up = n_("at", [r.S2, r.m, 0.30, 0.0]); var q = Ei(seg(t, 0.22, tc)); bx = lerp_(J.num(up[0]), J.num(hd[0]), q); by = lerp_(J.num(up[1]), J.num(hd[1]) - R, q)
	elif t < 0.40:
		var q = seg(t, tc, 0.40); bx = J.num(hd[0]) + q * 0.1 * th; by = lerp_(J.num(hd[1]) - R, -R, Ei(q))
	else:
		var q = seg(t, 0.40, 0.59); var rest = ball_rest(r.S2, n_("bm", [r.S2, {}])); bx = lerp_(J.num(hd[0]) + 0.1 * th, J.num(rest[0]), Eio(q)); by = lerp_(-R, J.num(rest[1]), Eo(q)) - sin(q * PI) * 0.3 * h
	ball(ctx, r.S2, bx, by, rot)
	if t > 0.2 and t < tc: n_("speed", [ctx, bx, by - R, 0.3, 1.0, 0.3 * h, 0.15 * h, 0.8, "rgba(255,240,220,.7)", 21.0, 4.0])
	var p = t - tc
	if p >= 0 and p < 0.14: n_("burst", [ctx, hd[0], hd[1], 0.4 * th, 1 - p / 0.14, "#ffd27a", 23.0, 11.0])
	if t > 0.36 and t < 0.42: n_("puff", [ctx, bx, -0.02 * h, 0.06 * h, seg(t, 0.36, 0.42), "rgba(200,190,170,.5)", 25.0, 3.0])
	n_("pop", [ctx, S, hd[0], J.num(hd[1]) - 0.35 * th, "入波！", 0.26 * th, "#ffb347", tc, 0.3])
	n_("hit", [S, hd[0], hd[1]]); end_(ctx)
	return null
static func move_hr(ctx, a):   # 蓋印
	var S = setup(a)
	if not J.t(S): return false
	var t = J.num(S.tt); var h = H(S); var th = J.num(S.th); var tc = TC()
	var T = n_("tgt", [S, 0.55]); var D2 = maxf(0.0, J.num(S.tx) - 0.42 * th - 0.18 * h)
	begin(ctx, S, null, 1.0)
	if t < 0.2 or t > 0.46:
		var k = Eo(seg(t, 0, 0.18)) if t < 0.2 else 1 - Eio(seg(t, 0.46, 0.59))
		draw_pose(ctx, S, "npc_hr", "stand", {"r": -8 * k, "armF": 0.6 * k, "head": -0.1 * k, "x": -0.03 * h * k} if t < 0.2 else {"x": D2 * 0.3 * k, "r": 3 * k})
	else:
		var f = n_("kf", [t, [[0.2, {"x": D2 * 0.6, "y": -0.04 * h, "armF": 0.35, "sy": 1.03}], [tc, {"x": D2, "armF": -0.25, "sy": 0.95, "body": 0.05}, "i"], [0.36, {"x": D2, "armF": -0.2, "sy": 0.97}], [0.46, {"x": D2 * 0.6}]]])
		if t > tc and t < 0.34: J.sp(f, "x", J.num(J.gp(f, "x")) + sin(t * 120) * 0.004 * h)
		draw_pose(ctx, S, "npc_hr", "stamp", f)
	var p = t - tc
	if p >= 0: seal(ctx, S, J.num(T[0]), J.num(T[1]), 0.36 * th, "警告", seg(p, 0, 0.06), 1 - seg(t, 0.5, 0.59))
	if p >= 0 and p < 0.14: n_("burst", [ctx, T[0], T[1], 0.38 * th, 1 - p / 0.14, "#ffd0d0", 31.0, 11.0])
	n_("pop", [ctx, S, T[0], J.num(T[1]) - 0.6 * th, "扣你假！", 0.2 * th, "#ff6060", tc + 0.02, 0.3])
	n_("hit", [S, T[0], T[1]]); end_(ctx)
	return null
static func move_kpi(ctx, a):   # 拍平板
	var S = setup(a)
	if not J.t(S): return false
	var t = J.num(S.tt); var h = H(S); var th = J.num(S.th); var D2 = maxf(0.0, J.num(S.tx) - 0.45 * th - 0.25 * h); var tc = TC()
	var T = n_("tgt", [S, 0.6])
	begin(ctx, S, null, 0.9)
	if t < 0.2: draw_pose(ctx, S, "npc_kpiboss", "walk", {"head": 0.1 * Eo(seg(t, 0, 0.18)), "y": -0.04 * h * Eo(seg(t, 0, 0.18)), "x": sin(t * 80) * 0.004 * h * seg(t, 0.08, 0.2)})
	elif t < 0.46:
		var f = n_("kf", [t, [[0.2, {"x": D2 * 0.5, "y": -0.08 * h}], [tc, {"x": D2, "y": 0.02 * h, "sy": 0.94, "r": 6.0}, "i"], [0.36, {"x": D2, "sy": 0.97, "r": 4.0}], [0.46, {"x": D2 * 0.6}]]])
		if t > tc and t < 0.36: J.sp(f, "x", J.num(J.gp(f, "x")) + sin(t * 110) * 0.005 * h)
		draw_pose(ctx, S, "npc_kpiboss", "yell", f)
	else: draw_pose(ctx, S, "npc_kpiboss", "stand", {"x": D2 * 0.6 * (1 - Eio(seg(t, 0.46, 0.59)))})
	var p = t - tc
	if p >= -0.06 and t < 0.5:
		var k = seg(t, tc - 0.06, tc); var y0 = J.num(T[1]) - 0.85 * th; var y = lerp_(y0, J.num(T[1]) - 0.25 * th, Ei(k))
		J.mc(ctx, "save", []); J.sp(ctx, "globalAlpha", J.num(J.gp(ctx, "globalAlpha")) * (1 - seg(t, 0.42, 0.5))); crash(ctx, J.num(T[0]) + 0.05 * th, y, 0.36 * th, 1.0, 41.0); J.mc(ctx, "restore", [])
	if p >= 0: rings(ctx, J.num(T[0]) - 0.2 * th, J.num(S.ty) - 0.05 * th, 0.6 * th, seg(p, 0, 0.3), "rgba(255,220,220,.9)")
	if p >= 0 and p < 0.14: n_("burst", [ctx, T[0], T[1], 0.4 * th, 1 - p / 0.14, "#ffb0b0", 43.0, 12.0])
	n_("pop", [ctx, S, J.num(T[0]) - 0.15 * th, J.num(T[1]) - 0.95 * th, "KPI 呢？！", 0.2 * th, "#ff5050", tc, 0.32])
	n_("hit", [S, T[0], T[1]]); end_(ctx)
	return null

# ======================= 對外：一行畫一個反派 =======================
static func draw(ctx, id, x, y, h, state, t, opt) -> bool:
	var ids = J.str(id)
	if not P.has(ids): return false
	var op = opt if J.t(opt) else {}
	var s = J.num(h) / P[ids].h; var tt = J.num(t) if J.t(t) else 0.0
	var tm = J.gp(op, "time")
	var o = {"t": J.num(tm) if tm != null else tt, "flip": J.seq(J.gp(op, "faceRight"), false), "alpha": J.gp(op, "alpha"), "shadow": J.gp(op, "shadow"), "tamed": true}
	var st = J.str(state) if state != null else ""
	if st == "attack":
		var q = tt; var Wd = 0.22; var Sx = 0.12; var R = 0.25
		if q < Wd: o["pose"] = "windup"; o["pt"] = q / Wd
		elif q < Wd + Sx: o["pose"] = "strike"; o["pt"] = (q - Wd) / Sx
		elif q < Wd + Sx + R: o["pose"] = "recover"; o["pt"] = (q - Wd - Sx) / R
		else: o["pose"] = "idle"
		var tdx = J.gp(op, "tdx"); var tdy = J.gp(op, "tdy")
		o["tdx"] = J.num(tdx) if tdx != null else (-0.75 * J.num(h) if J.seq(J.gp(op, "faceRight"), false) else 0.75 * J.num(h)); o["tdy"] = J.num(tdy) if J.t(tdy) else 0.0
	elif st in ["hurt", "die", "down", "scared"]:
		o["pose"] = st; o["pt"] = cl(tt / 0.25) if st == "hurt" else (cl(tt / 0.8) if st == "die" else cl(tt / 1.8))
	elif st == "walk": o["pose"] = "move"; o["walk"] = true; o["t"] = tt
	elif st == "idle" or st == "": o["pose"] = "idle"; o["t"] = J.num(tm) if tm != null else tt
	else: o["act"] = "ag_" + st; o["at"] = tt
	J.mc(_g("ART"), "drawChar", [ctx, id, x, y, s, o])
	return true

func run(_env) -> void:
	N = _g("N30K")
	var MA = _g("MeshAnim"); var ART = _g("ART")
	PD = P.duplicate(true)
	for id in PD:
		var d = PD[id]
		for k in d.poses:
			var p = d.poses[k]; var R = J.mc(MA, "mk", [p.rig])
			J.sp(J.gp(MA, "RIG"), p.img, R)
			if J.t(p.nr): J.sp(J.gp(MA, "NATIVE_R"), p.img, 1.0)
		J.sp(J.gp(J.gp(MA, "RIG"), id), "custom", func(_t, a): return custom(J.arg(a, 0), J.arg(a, 1)))
		J.sp(J.gp(ART, "CHAR_H"), id, d.h)
		if J.t(d.solid): J.sp(J.gp(ART, "SOLID"), id, 1.0)
	var DAILY = _g("DAILY")
	for st in ["spin", "dribble", "jumpshot", "gossip", "clip", "glasses", "stamp", "inspect", "tap", "sigh", "yell", "jump", "walk", "idle"]:
		J.sp(DAILY, "ag_" + st, func(_t, a):
			var ag = J.arg(a, 1)
			if not P.has(J.str(J.gp(ag, "type"))): return false
			var at = J.gp(J.gp(ag, "o"), "at")
			return run_(J.arg(a, 0), ag, st, at if J.t(at) else 0.0))
	var MOVES = _g("MOVES")
	J.sp(MOVES, "npc_rival", func(_t, a): return move_rival(J.arg(a, 0), J.arg(a, 1)))
	J.sp(MOVES, "npc_hr", func(_t, a): return move_hr(J.arg(a, 0), J.arg(a, 1)))
	J.sp(MOVES, "npc_kpiboss", func(_t, a): return move_kpi(J.arg(a, 0), J.arg(a, 1)))
	J.G["Antag"] = {
		"draw": func(_t, a): return draw(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.arg(a, 5), J.arg(a, 6), J.arg(a, 7)),
		"STATES": STATES.duplicate(true),
		"ZH": {"npc_rival": "籃球仔", "npc_hr": "HR 姐", "npc_kpiboss": "陰間大老闆"},
		"dur": func(_t, a):
			var st = J.str(J.arg(a, 1))
			return DUR[st] if DUR.has(st) else (0.59 if st == "attack" else 2.0),
		"P": PD,
	}
