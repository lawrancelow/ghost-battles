# 原生改寫自 daily_plaza.js：村子廣場閒逛同互動（PlazaLife：揀目的地、停低、各自小動作、碰面傾偈、追逐、捉弄、巡邏）
# 身體一律用原圖網格（MeshAnim）／原圖拆出嘅手（Limbs）；泡泡、Zzz、星星、蒸氣、碎屑、水滴係程式畫嘅蠟筆線。
# DAILY['plaza_*'] 畫身體＋貼身特效；頭頂嘅泡泡等由 PlazaLife.drawAgent 疊上去。遊戲：Village.collect → PlazaLife.frame(...)
# 規矩：隨機數（randf）次序同 JS 一模一樣；廣場鬼（agent）、步驟（step）照用 JS 嘅字典結構（其他模塊會讀）；步驟入面嘅 fn 係 J 函數（_t, [ag]）
extends RefCounted

const TAU := PI * 2
const D := PI / 180
const HOPPER := {"laojiang": 1, "zombie": 1}
const PAPER := {"xiaozhi": 1, "zhiren": 1}
const SOLID := {"laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1}
const CH := {"xiaozhi": 54, "egui": 54, "eguiking": 66, "xiaogui": 46, "toyol": 46, "laojiang": 58, "zombie": 54, "shuigui": 56, "pontianak": 60, "pocong": 54, "penanggal": 52, "mengpo": 56, "youhun": 46, "baiwu": 76, "heiwu": 76, "niutou": 64, "mamian": 64, "huang": 62, "zhiren": 54, "tianhua": 60}
const FACEV := {"heiwu": 0.5, "baiwu": 0.45, "niutou": 0.3, "mamian": 0.3, "eguiking": 0.28, "huang": 0.3, "laojiang": 0.35, "zombie": 0.35, "toyol": 0.3}
const SC := 0.58
const FONT := "\"PingFang TC\",\"Noto Sans TC\",sans-serif"

# ---------------- 小工具 ----------------
static func _g(n: String): return J.G.get(n)
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func eo(t: float) -> float: return 1 - (1 - t) * (1 - t)
static func ei(t: float) -> float: return t * t
static func eio(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func eo3(t: float) -> float: return 1 - pow(1 - t, 3)
static func seg(g: float, a: float, b: float) -> float: return cl((g - a) / (b - a))
static func env(g: float, a: float, b: float, c: float, d: float) -> float: return eio(seg(g, a, b)) * (1 - eio(seg(g, c, d)))
static func hsh(i: float) -> float:
	var v = sin(i * 127.1 + 311.7) * 43758.5453
	return v - floor(v)
static func jm(a: float, b: float) -> float: return fmod(a, b)          # JS %
static func z0(v) -> float: return J.num(v) if J.t(v) else 0.0          # JS (v || 0)
static func ok(k: String) -> bool:
	var so = _g("sprOk")
	return so != null and J.t(J.cl(so, null, [k]))
# 測試用：轉譯版 `const R = Math.random` 喺轉譯後係空值（R() 永遠 0），對照時設 test_r0 = true 令原生都回 0
static var test_r0 := false
static func R() -> float: return 0.0 if test_r0 else randf()
static func _ma(): return _g("MeshAnim")
static func _spr(k: String): return J.gp(_g("SPR"), k)
static func _anim(n: String, a: Array) -> Dictionary: return J.cl(J.gp(J.gp(_ma(), "ANIM"), n), null, a)
static func _hyp(x: float, y: float) -> float: return sqrt(x * x + y * y)
static func _sign(v: float) -> float: return 1.0 if v > 0 else (-1.0 if v < 0 else 0.0)

# ======================= 身體姿勢（MeshAnim 嘅 ANIM 座標：正 = 往前）=======================
static func base_pose(o: Dictionary, type: String) -> Dictionary:
	var t = z0(o.get("t")); var w = cl(z0(o.get("w"))); var I = _anim("idle", [t])
	if HOPPER.has(type) or w <= 0.001: return I
	var run = z0(o.get("run")); var Wk = _anim("walk", [z0(o.get("wph"))])
	if run:
		Wk["legF"] = J.num(Wk.legF) * (1 + 0.5 * run); Wk["legB"] = J.num(Wk.legB) * (1 + 0.5 * run); Wk["armF"] = J.num(Wk.armF) * (1 + 0.7 * run); Wk["armB"] = J.num(Wk.armB) * (1 + 0.7 * run); Wk["body"] = J.num(Wk.body) + 0.07 * run
	if J.t(o.get("stiff")):
		Wk["armF"] = J.num(Wk.armF) * 0.35; Wk["armB"] = J.num(Wk.armB) * 0.35; Wk["body"] = 0.03; Wk["head"] = 0.0
	var P = {}
	for k in I: P[k] = I[k]
	for k in Wk: P[k] = lerp_(J.num(I[k]) if I.get(k) != null else 0.0, J.num(Wk[k]), w)
	return P
static func add(p: Dictionary, d: Dictionary) -> Dictionary:
	for k in d:
		if k == "sx" or k == "sy": p[k] = (1.0 if p.get(k) == null else J.num(p[k])) * J.num(d[k])
		else: p[k] = z0(p.get(k)) + J.num(d[k])
	return p
static func float_y(a: Dictionary) -> float:
	if J.t(a.get("solid")): return 0.0
	var o = a.o
	return (3 + sin(z0(o.get("t")) * 2.4) * 2) * J.num(a.s) * (0.25 if J.t(o.get("sit")) else 1.0)
static func shadow_at(ctx, a: Dictionary, lift: float, k) -> void:
	var solid = J.t(a.get("solid")); var H = J.num(a.H)
	var sk = (1.0 if solid else 0.8) * (1.0 if k == null else J.num(k)) * (1 - 0.5 * cl(lift / (H * 0.9)))
	ctx.save()
	if not solid: ctx.globalAlpha *= 0.55
	ctx.globalAlpha *= 1 - 0.4 * cl(lift / (H * 0.9)); J.cl(a.shadow, null, [a.x, sk]); ctx.restore()
static func draw_m(ctx, a: Dictionary, P: Dictionary, lift: float, shK) -> void:
	shadow_at(ctx, a, lift, shK)
	J.cl(J.gp(_ma(), "draw"), null, [ctx, a.type, J.num(a.x), J.num(a.y) - float_y(a) - lift, a.H, P, a.faceRight])
# 原圖上某一點（0~1）喺世界嘅位置（唔計變形，俾特效定位）
static func npt(a: Dictionary, u: float, v: float, lift := 0.0) -> Array:
	var img = _spr(J.str(a.type)); var H = J.num(a.H); var W = H * J.num(J.gp(img, "naturalWidth")) / J.num(J.gp(img, "naturalHeight"))
	var nr = J.t(J.gp(J.gp(_ma(), "NATIVE_R"), J.str(a.type))); var flip = J.t(a.faceRight) != nr
	return [J.num(a.x) + (-1.0 if flip else 1.0) * (u - 0.5) * W, J.num(a.y) - float_y(a) - lift - H + v * H]

# ======================= 蠟筆特效 =======================
static func crayon(ctx, pts: Array, w: float, col) -> void:
	ctx.save(); ctx.lineCap = "round"; ctx.lineJoin = "round"; ctx.strokeStyle = col; var g0 = ctx.globalAlpha
	for p in 2:
		ctx.globalAlpha = g0 * (0.5 if p else 1.0); ctx.lineWidth = w * (0.55 if p else 1.0); ctx.beginPath()
		for i in pts.size():
			var j = w * 0.35 if p else 0.0; var jx = (hsh(i * 3.1 + p) - 0.5) * j; var jy = (hsh(i * 5.7 + p) - 0.5) * j
			if i: ctx.lineTo(pts[i][0] + jx, pts[i][1] + jy)
			else: ctx.moveTo(pts[i][0] + jx, pts[i][1] + jy)
		ctx.stroke()
	ctx.restore()
static func steam(ctx, x: float, y: float, t: float, s: float, n: int, k: float, push: float) -> void:
	for i in n:
		var ph = jm(t * 0.5 + float(i) / n + hsh(i) * 0.2, 1); var al = sin(ph * PI) * 0.6 * k
		if al <= 0.02: continue
		var pts = []; var x0 = x + (i - (n - 1) / 2.0) * 3 * s
		for j in 7:
			var q = j / 6.0; var h = (ph * 20 + q * 9) * s
			pts.append([x0 + sin(q * 5 + t * 2.3 + i * 2) * 2 * s * (0.4 + q) + push * h * 0.9, y - h])
		ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, 1.4 * s, "#f3eee4"); ctx.restore()
static func txt(ctx, x: float, y: float, s: String, size: float, col: String, k: float, wob: float) -> void:
	if k <= 0: return
	ctx.save(); var sc = 0.55 + 0.45 * eo(cl(k * 2.2)); ctx.globalAlpha *= cl(k * 3)
	ctx.translate(x, y); ctx.rotate(wob * 0.12); ctx.scale(sc, sc)
	ctx.font = "900 %spx %s" % [J.str(size), FONT]; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineJoin = "round"; ctx.lineWidth = size * 0.28; ctx.strokeStyle = "rgba(28,18,30,.92)"; ctx.strokeText(s, 0, 0); ctx.fillStyle = col; ctx.fillText(s, 0, 0)
	ctx.restore()
static func zzz(ctx, x: float, y: float, t: float, s: float, k: float) -> void:
	for i in 3:
		var ph = jm(t * 0.42 + i / 3.0, 1); var al = sin(ph * PI) * k
		if al <= 0.02: continue
		ctx.save(); ctx.globalAlpha *= al; txt(ctx, x + ph * 11 * s + sin(ph * 6 + i) * 2 * s, y - ph * 24 * s, "z", (8 + ph * 7) * s * 1.4, "#d6e6ff", 1, sin(ph * 4)); ctx.restore()
static func star(ctx, x: float, y: float, r: float, rot: float) -> void:
	ctx.save(); ctx.translate(x, y); ctx.rotate(rot); ctx.beginPath()
	for i in 10:
		var rr = r * 0.45 if i % 2 else r; var an = i * PI / 5 - PI / 2
		ctx.lineTo(cos(an) * rr, sin(an) * rr)
	ctx.closePath(); ctx.fillStyle = "#ffe27a"; ctx.fill(); ctx.lineWidth = r * 0.3; ctx.strokeStyle = "#6a4a20"; ctx.stroke(); ctx.restore()
static func stars(ctx, x: float, y: float, t: float, s: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= k
	for i in 3:
		var an = t * 5.5 + i * TAU / 3
		star(ctx, x + cos(an) * 11 * s, y + sin(an) * 3.5 * s, (2.2 + sin(an) * 0.6) * s * 1.3, t * 3 + i)
	ctx.restore()
static func bubble(ctx, x: float, y: float, ch: String, s: float, k: float) -> void:   # 細對話泡泡（顏色同碎碎念泡泡一樣）
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k * 4); var sc = (0.6 + 0.4 * eo(cl(k * 3))) * s * 1.7
	ctx.translate(x, y); ctx.scale(sc, sc)
	ctx.beginPath(); ctx.ellipse(0, 0, 8.5, 6.5, 0, 0, TAU); ctx.fillStyle = "#ecd9a4"; ctx.fill(); ctx.lineWidth = 1.1; ctx.strokeStyle = "#5a4030"; ctx.stroke()
	ctx.beginPath(); ctx.moveTo(-2.5, 5.6); ctx.lineTo(-4.5, 10); ctx.lineTo(1, 6.2); ctx.fillStyle = "#ecd9a4"; ctx.fill(); ctx.stroke()
	ctx.beginPath(); ctx.ellipse(0, 0, 7.6, 5.6, 0, 0, TAU); ctx.fillStyle = "#ecd9a4"; ctx.fill()
	ctx.fillStyle = "#c2362b" if ch == "!" else ("#3a6aa8" if ch == "♪" else "#2b1d12")
	if ch == "…":
		for i in range(-1, 2): ctx.beginPath(); ctx.arc(i * 3, 0.5, 1.05, 0, TAU); ctx.fill()
	else:
		ctx.font = "900 9px " + FONT; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(ch, 0, 0.6)
	ctx.restore()
static func crumbs(ctx, x: float, y: float, tb: float, s: float, seed: float, fwd: float) -> void:
	if tb < 0 or tb > 0.65: return
	for i in 6:
		var vx = fwd * (6 + hsh(seed + i) * 26) * s * 1.6 * (1.0 if hsh(seed + i * 2) > 0.3 else -0.6); var vy = (-26 - hsh(seed + i * 3) * 24) * s * 1.6
		var px = x + vx * tb; var py = y + vy * tb + 170 * s * tb * tb; var al = 1 - tb / 0.65
		ctx.save(); ctx.globalAlpha *= al; ctx.translate(px, py); ctx.rotate(tb * 9 + i)
		ctx.fillStyle = "#f4e7c6"; ctx.strokeStyle = "#8a6a44"; ctx.lineWidth = 0.35; var r = (0.7 + hsh(i + seed) * 0.6) * s * 1.6
		ctx.beginPath(); ctx.ellipse(0, 0, r, r * 0.75, 0, 0, TAU); ctx.fill(); ctx.stroke(); ctx.restore()
static func drop(ctx, x: float, y: float, r: float, al: float) -> void:
	ctx.save(); ctx.globalAlpha *= al; ctx.fillStyle = "#9fd0e6"; ctx.strokeStyle = "#2c5566"; ctx.lineWidth = r * 0.35
	ctx.beginPath(); ctx.moveTo(x, y - r * 1.6); ctx.quadraticCurveTo(x + r, y - r * 0.2, x, y + r * 0.6); ctx.quadraticCurveTo(x - r, y - r * 0.2, x, y - r * 1.6); ctx.fill(); ctx.stroke(); ctx.restore()
static func dust_puff(ctx, x: float, y: float, k: float, s: float, seed: float) -> void:   # 細團灰
	if k <= 0 or k >= 1: return
	for i in 5:
		var an = PI + (i / 4.0) * PI + (hsh(seed + i) - 0.5) * 0.5; var r = (4 + 10 * eo(k)) * s * (0.7 + hsh(seed + i * 2) * 0.6)
		ctx.save(); ctx.globalAlpha *= (1 - k) * 0.55; ctx.fillStyle = "#cdbfa8"
		ctx.beginPath(); ctx.arc(x + cos(an) * r * 1.4, y + sin(an) * r * 0.35, (1.6 + 2.2 * k) * s, 0, TAU); ctx.fill(); ctx.restore()
static func sniff_lines(ctx, x: float, y: float, t: float, s: float, fwd: float) -> void:
	for i in 2:
		var ph = jm(t * 1.6 + i * 0.5, 1); var al = sin(ph * PI) * 0.8; var pts = []
		for j in 6:
			var q = j / 5.0
			pts.append([x + fwd * (14 - ph * 10 - q * 6) * s, y + (i * 4 - 2 + sin(q * 6 + t * 8) * 1.2) * s])
		ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, 0.9 * s, "#e9e2cf"); ctx.restore()

# ======================= 殭屍跳：真係一下一下跳 =======================
# hp：0~1 一跳；0~0.22 蹲（預備）、0.22~0.9 騰空、0.9~1 落地壓扁
static func hop_pose(hp: float, H: float, P: Dictionary) -> float:
	var c = maxf(sin(PI * seg(hp, 0, 0.24)) * (1.0 if hp < 0.24 else 0.0), 0); var air = seg(hp, 0.22, 0.9); var land = sin(PI * seg(hp, 0.9, 1)) if hp > 0.9 else 0.0
	var up = sin(PI * air) * (1.0 if hp >= 0.22 and hp <= 0.9 else 0.0)
	add(P, {"sy": 1 - 0.1 * c - 0.09 * land + 0.06 * up * (1 - air), "sx": 1 + 0.06 * c + 0.06 * land - 0.03 * up, "body": 0.04 * up, "head": -0.05 * up + 0.06 * land, "armF": 0.08 * up - 0.06 * land, "armB": -0.08 * up + 0.06 * land})
	return up * H * 0.2
static func bump3(g: float, a: float, m: float, b: float) -> float:
	if g <= a or g >= b: return 0.0
	return eio((g - a) / (m - a)) if g < m else 1 - eio((g - m) / (b - m))

# ======================= 各動作嘅身體（DAILY['plaza_*']）=======================
static func body(ctx, a: Dictionary):
	var o: Dictionary = a.o; var type = J.str(a.type); var at = z0(o.get("at")); var t = z0(o.get("t")); var fwd = 1.0 if J.t(a.faceRight) else -1.0; var s = J.num(a.s); var H = J.num(a.H)
	var pl = o.get("pl") if J.t(o.get("pl")) else {}
	if not J.t(J.cl(J.gp(_ma(), "has"), null, [type])): return false
	var act = J.str(o.get("act")) if o.get("act") != null else ""
	if act == "plaza_eat" and type == "eguiking" and not (eat_draw(ctx, a) is bool): return null
	if act == "plaza_golf" and type == "huang" and not (golf_draw(ctx, a) is bool): return null
	if act == "plaza_hang" and type == "tianhua" and not (hang_draw(ctx, a) is bool): return null
	var P = base_pose(o, type); var lift = 0.0; var shK = 1.0
	if HOPPER.has(type) and o.get("hp") != null and J.num(o.hp) >= 0 and (act == "" or act == "plaza_walk"): lift += hop_pose(J.num(o.hp), H, P)
	var w = cl(z0(o.get("w")))
	# 走路嘅個性
	if PAPER.has(type) and w > 0: add(P, {"armF": sin(t * 31) * 0.05 * w, "armB": sin(t * 27 + 1) * 0.05 * w, "sx": 1 + sin(t * 23) * 0.012 * w, "body": 0.04 * z0(o.get("run"))})
	if type == "youhun": P["rot"] = z0(P.get("rot")) + sin(t * 1.7) * 0.05 * fwd; lift += (sin(t * 1.1) + 1) * 1.2 * s
	if type == "shuigui": add(P, {"head": 0.07})
	if J.t(o.get("sniff")):
		var sn = pow(maxf(0, sin(t * 2.6)), 6); add(P, {"head": 0.2 + sin(t * 24) * 0.05 * sn, "body": 0.1})
	if J.t(o.get("sneak")): add(P, {"body": 0.2, "head": 0.06, "sy": 0.9, "sx": 1.05, "armF": -0.32, "armB": 0.3})
	var after = null
	var pd = J.gp(pl, "d")
	match act:
		"plaza_talk":
			if J.t(J.gp(pl, "spk")):
				var b = maxf(0, sin(at * 2.1)); add(P, {"head": 0.02 + sin(at * 8.5) * 0.05 * b, "armF": -0.22 * (0.5 + 0.5 * sin(at * 3.2)) * b, "body": 0.03 * b})
			else:
				var n = sin(PI * seg(jm(at, 1.5), 0.2, 0.75)); add(P, {"head": 0.08 * n, "body": 0.01 * n})
		"plaza_argue":
			if J.t(J.gp(pl, "spk")): add(P, {"body": 0.09, "head": 0.07 + sin(at * 12) * 0.06, "armF": -0.32 + sin(at * 6.5) * 0.18, "sx": 1 + absf(sin(at * 6.5)) * 0.015})
			else: add(P, {"body": -0.06, "head": -0.09 + sin(at * 1.3) * 0.02})
		"plaza_wave":
			var dd = J.num(pd) if J.t(pd) else 1.4; var k = env(at, 0, 0.28, dd - 0.35, dd)
			add(P, {"armF": (-0.5 + sin(at * 11) * 0.16) * k, "body": -0.03 * k, "head": 0.05 * k * sin(at * 5.5)})
		"plaza_bow":
			var dd = J.num(pd) if J.t(pd) else 1.2; var k = env(at, 0, dd * 0.3, dd * 0.62, dd); var deep = 1.0 if J.gp(pl, "deep") == null else J.num(J.gp(pl, "deep"))
			add(P, {"body": 0.3 * k * deep, "head": 0.22 * k * deep, "armF": 0.08 * k, "armB": -0.08 * k, "sy": 1 - 0.02 * k})
		"plaza_doze":
			var dd = J.num(pd) if J.t(pd) else 8.0; var k = env(at, 0, 1.4, dd - 0.7, dd); var j = jm(at, 5.6); var wake = sin(PI * seg(j, 4.3, 4.9)) if (j > 4.3 and j < 4.9) else 0.0; var br = sin(t * 1.1)
			add(P, {"head": (0.28 * (1 - wake * 1.3) + br * 0.03) * k, "body": 0.07 * k, "armF": 0.06 * k, "armB": -0.06 * k, "sy": 1 + br * 0.018 * k, "hairL": 0.08 * k, "hairR": 0.08 * k})
			o["_z"] = k * (1 - wake)
		"plaza_look":
			var dd = J.num(pd) if J.t(pd) else 2.0; var k = env(at, 0, 0.3, dd - 0.3, dd)
			add(P, {"head": (-0.06 + sin(at * 2.2) * 0.04) * k, "body": -0.02 * k})
		"plaza_stretch":
			var dd = J.num(pd) if J.t(pd) else 2.0; var k = env(at, 0, 0.6, dd - 0.6, dd); var q = sin(t * 30) * 0.012 * (1.0 if at > 0.6 and at < dd - 0.6 else 0.0)
			add(P, {"armF": -0.5 * k, "armB": 0.5 * k, "body": -0.1 * k + q, "head": -0.12 * k, "sy": 1 + 0.05 * k, "sx": 1 - 0.025 * k})
		"plaza_sniff":
			var sn = pow(maxf(0, sin(at * 3.1)), 4)
			add(P, {"head": 0.24 + sin(at * 24) * 0.06 * sn, "body": 0.12, "sy": 1 - 0.02 * sn})
			after = func():
				var np = npt(a, 0.5 if PAPER.has(type) else 0.62, 0.28); sniff_lines(ctx, np[0], np[1] + 4 * s, at, s, fwd)
		"plaza_backrub":
			var dd = J.num(pd) if J.t(pd) else 2.6; var k = env(at, 0, 0.25, dd - 0.7, dd - 0.25); var st = bump3(at, dd - 0.75, dd - 0.45, dd)
			add(P, {"body": 0.14 * k + sin(at * 11) * 0.015 * k - 0.12 * st, "head": 0.06 * k - 0.1 * st, "armB": sin(at * 11) * 0.11 * k, "sy": 1 - 0.03 * k + 0.04 * st, "sx": 1 + sin(at * 22) * 0.01 * k})
			after = func():
				var hp = npt(a, 0.45, 0.02); txt(ctx, hp[0] + fwd * 8 * s, hp[1] - 8 * s, "哎喲", 12 * s * 1.3, "#ffd2d2", env(at, 0.1, 0.25, 1.3, 1.6), sin(at * 9) * 0.5)
		"plaza_soup":
			var dd = J.num(pd) if J.t(pd) else 10.0; var k = env(at, 0, 0.7, dd - 0.7, dd); var c = jm(at - 0.7, 4.4); var blow = sin(PI * seg(c, 0, 1.0)) if at > 0.7 else 0.0; var stir = env(c, 1.2, 1.5, 3.6, 4.0) if at > 0.7 else 0.0
			o["sit"] = 1.0
			add(P, {"y": 0.07 * k, "sy": 1 - 0.07 * k, "sx": 1 + 0.04 * k, "tail1": 0.3 * k, "tail2": 0.45 * k, "head": 0.12 * blow, "body": 0.05 * blow + sin(at * 5) * 0.015 * stir, "armB": (sin(at * 5) * 0.09 + 0.05) * stir})
			after = func():
				var bp = npt(a, 0.25, 0.47, 0); steam(ctx, bp[0], bp[1] + H * 0.07 * k, t, s, 3, 0.55 + 0.6 * blow, fwd * blow * 0.8)
		"plaza_hair":
			var c = jm(at, 2.3); var up = eio(seg(c, 0, 0.35)); var down = eio(seg(c, 0.35, 1.25)); var rel = eio(seg(c, 1.25, 2.0))
			var arm = -0.75 * up * (1 - down) + 0.15 * down * (1 - rel); var pull = sin(PI * seg(c, 0.35, 1.5))
			add(P, {"armF": arm, "head": 0.16 * up * (1 - rel) + 0.04, "hairL": 0.38 * pull - 0.12 * sin(PI * seg(c, 1.4, 2.3)), "hairR": sin(at * 1.7) * 0.1 + 0.08 * pull, "body": -0.04 * pull + 0.03 * up * (1 - rel)})
		"plaza_shake":
			var sh = seg(at, 0.25, 1.25); var amp = (1 - sh) * sin(PI * minf(1, sh * 6)) if at > 0.25 and at < 1.25 else 0.0; var cr = sin(PI * seg(at, 0, 0.3)) * (1.0 if at < 0.3 else 0.0)
			add(P, {"rot": sin(at * 30) * 0.1 * amp, "head": -sin(at * 30) * 0.12 * amp + 0.1 * seg(at, 1.25, 1.6), "hairL": sin(at * 30 + 1) * 0.35 * amp, "hairR": sin(at * 30 + 2) * 0.35 * amp, "sy": 1 - 0.08 * cr, "sx": 1 + 0.04 * cr + 0.03 * amp})
			after = func():
				var hp = npt(a, 0.5, 0.3)
				for i in 12:
					var e = at - (0.3 + i * 0.07)
					if e < 0 or e > 0.5: continue
					var an = -PI * (0.1 + 0.8 * hsh(i * 7.7)); var v = (36 + hsh(i) * 34) * s
					drop(ctx, hp[0] + cos(an) * v * e * (1.0 if i % 2 else -1.0), hp[1] + sin(an) * v * e + 140 * s * e * e, 1.6 * s, 1 - e / 0.5)
		"plaza_spin":
			var q = seg(at, 0.25, 1.35); var cr = sin(PI * seg(at, 0, 0.25)) * (1.0 if at < 0.25 else 0.0); var land = sin(PI * seg(at, 1.35, 1.75)) * (1.0 if at > 1.35 else 0.0)
			var c = cos(q * TAU * 2); P["sx"] = (J.num(P.sx) if J.t(P.get("sx")) else 1.0) * _sign(c if c else 1.0) * maxf(0.07, absf(c)) * (1 + 0.06 * cr)
			add(P, {"sy": 1 - 0.1 * cr - 0.06 * land + 0.05 * sin(PI * q), "tail1": sin(at * 12) * 0.3 * sin(PI * q), "tail2": sin(at * 12 - 1) * 0.45 * sin(PI * q), "head": -0.08 * sin(PI * q)})
			lift += sin(PI * q) * 8 * s
			after = func():
				if at > 1.3:
					var hp = npt(a, 0.5, 0.0); bubble(ctx, hp[0] + fwd * 10 * s, hp[1] - 16 * s, "♪", s, env(at, 1.3, 1.45, 2.0, 2.2))
		"plaza_boo":
			var cr = sin(PI * seg(at, 0, 0.15)) if at < 0.15 else 0.0; var k = env(at, 0.12, 0.26, 0.72, 0.95); var tr = sin(at * 42) * 0.03 if at > 0.26 and at < 0.72 else 0.0
			add(P, {"sy": 1 - 0.13 * cr + 0.12 * k, "sx": 1 + 0.06 * cr - 0.05 * k, "armF": -0.6 * k + tr, "armB": 0.6 * k - tr, "head": -0.12 * k, "body": 0.12 * k + 0.08 * cr, "x": 0.05 * k})
			lift += 6 * s * k
			after = func():
				var hp = npt(a, 0.5, 0.0); txt(ctx, hp[0] + fwd * 12 * s, hp[1] - 6 * s, "哇！", 13 * s * 1.4, "#ffe9a8", env(at, 0.15, 0.25, 0.8, 1.0), sin(at * 30))
		"plaza_laugh":
			var dd = J.num(pd) if J.t(pd) else 1.6; var k = env(at, 0, 0.15, dd - 0.3, dd); var b = absf(sin(at * 15))
			add(P, {"body": (0.16 + b * 0.05) * k, "head": (0.06 + sin(at * 15) * 0.08) * k, "sy": 1 - b * 0.04 * k, "armB": 0.25 * k, "armF": 0.2 * k})
			after = func():
				var hp = npt(a, 0.5, 0.05); txt(ctx, hp[0] - fwd * 10 * s, hp[1] - 4 * s - b * 2 * s, "嘻嘻", 10 * s * 1.4, "#c8f5b8", k, sin(at * 15))
		"plaza_startle", "plaza_eek":
			var dd = J.num(pd) if J.t(pd) else (0.75 if act == "plaza_eek" else 1.3)
			var cr = sin(PI * seg(at, 0, 0.08)) if at < 0.08 else 0.0; var j = sin(PI * seg(at, 0.06, 0.32)) * (1.0 if at > 0.06 and at < 0.32 else 0.0); var tr = sin(at * 45) * 0.03 * (1 - seg(at, 0.3, dd)) if at > 0.3 else 0.0; var k = 1 - eio(seg(at, dd * 0.65, dd))
			add(P, {"sy": 1 - 0.1 * cr + 0.06 * j, "armF": (-0.55 * j - 0.2) * k + tr, "armB": (0.55 * j + 0.2) * k - tr, "head": (-0.2 * j - 0.06) * k + tr * 2, "body": (-0.1 * j - 0.04) * k + tr, "hairL": -0.25 * j, "hairR": -0.25 * j})
			lift += j * 7 * s
		"plaza_reach":
			var k = env(at, 0, 0.12, 0.3, 0.5)
			add(P, {"body": 0.18 * k, "armF": -0.55 * k, "head": 0.05 * k, "x": 0.05 * k})
		"plaza_bump":
			var im = sin(PI * seg(at, 0, 0.12)) if at < 0.12 else 0.0; var back = sin(PI * seg(at, 0.1, 0.55)) * (1.0 if at > 0.1 and at < 0.55 else 0.0); var land = sin(PI * seg(at, 0.55, 0.75)) if at > 0.55 else 0.0
			add(P, {"sx": 1 - 0.14 * im + 0.08 * land, "sy": 1 + 0.07 * im - 0.1 * land, "body": -0.22 * im - 0.12 * back, "head": -0.2 * im - 0.1 * back, "armF": 0.25 * im, "armB": -0.25 * im})
			lift += back * 7 * s
			after = func():
				var hp = npt(a, 0.3, 0.2); txt(ctx, hp[0] + fwd * 10 * s, hp[1] - 4 * s, "咚！", 11 * s * 1.4, "#ffe9a8", env(at, 0.0, 0.06, 0.45, 0.7), 0.4)
		"plaza_dizzy":
			var dd = J.num(pd) if J.t(pd) else 2.2; var k = 1 - eio(seg(at, dd - 0.6, dd))
			add(P, {"rot": sin(at * 6) * 0.08 * k, "head": cos(at * 6) * 0.12 * k, "body": sin(at * 6 + 1) * 0.05 * k, "armF": sin(at * 6) * 0.1 * k, "armB": cos(at * 6) * 0.1 * k})
			o["_stars"] = k
	draw_m(ctx, a, P, lift, shK)
	if after != null: after.call()
	return null

# ---- 餓鬼王：邊行邊食包（原圖拆出嘅「拎包嘅手」繞膊頭轉到嘴邊）----
static func eat_draw(ctx, a: Dictionary):
	var LD = _g("LIMBS_DATA"); var c = J.gp(J.gp(LD, "chars"), "eguiking") if LD != null else null
	if not J.t(c) or not ok("eguiking__body") or not ok("eguiking__arm"): return false
	var o: Dictionary = a.o; var t = z0(o.get("t")); var H = J.num(a.H); var s = J.num(a.s); var fwd = 1.0 if J.t(a.faceRight) else -1.0; var bd = _spr("eguiking__body"); var arm = _spr("eguiking__arm")
	var W = H * J.num(J.gp(bd, "naturalWidth")) / J.num(J.gp(bd, "naturalHeight"))
	var P = base_pose(o, "eguiking")
	var cyc = 3.6; var ph = jm(z0(o.get("at")) + 0.15, cyc)
	var raise = eio(seg(ph, 0.1, 0.62)); var away = eio(seg(ph, 0.86, 1.3)); var lk = raise * (1 - away)
	var chomp = bump3(ph, 0.6, 0.67, 0.86); var ck = seg(ph, 1.3, 2.7); var chew = sin(ck * PI * 6) * (1 - ck * 0.4) if ph > 1.3 and ph < 2.7 else 0.0
	add(P, {"head": -0.07 * raise * (1 - seg(ph, 0.55, 0.62)) + 0.1 * chomp + 0.035 * chew, "body": 0.04 * chomp, "sy": 1 - 0.025 * chomp - 0.012 * absf(chew), "sx": 1 + 0.015 * absf(chew)})
	var th = 58 * lk + 4 * chomp; var hx = 0.06 * lk; var hy = 0.045 * lk
	# 換到「原圖朝左」嘅座標畫
	var mp = {}
	for k in P: mp[k] = -J.num(P[k]) if ((P[k] is float or P[k] is int) and k != "y" and k != "sx" and k != "sy") else P[k]
	var fy = (3 + sin(t * 2.4) * 2) * s
	shadow_at(ctx, a, 0, 1)
	ctx.save(); ctx.translate(J.num(a.x), J.num(a.y) - fy)
	if J.t(a.faceRight): ctx.scale(-1, 1)
	ctx.translate(z0(mp.get("x")) * W, z0(mp.get("y")) * H); ctx.scale(J.num(mp.sx) if J.t(mp.get("sx")) else 1.0, J.num(mp.sy) if J.t(mp.get("sy")) else 1.0)
	var pivot = J.gp(c, "pivot"); var pvx = J.num(pivot[0]); var pvy = J.num(pivot[1])
	var bA = z0(mp.get("body")); var bp = [0.48 * W - W / 2, 0.70 * H - H]; var pv = [pvx * W - W / 2, pvy * H - H]
	var rx = pv[0] - bp[0]; var ry = pv[1] - bp[1]; var px = bp[0] + cos(bA) * rx - sin(bA) * ry + hx * W; var py = bp[1] + sin(bA) * rx + cos(bA) * ry - hy * H
	var m2 = mp.duplicate(); m2.merge({"x": 0.0, "y": 0.0, "sx": 1.0, "sy": 1.0, "rot": 0.0, "armF": 0.0}, true)
	J.cl(J.gp(_ma(), "drawBody"), null, [ctx, "eguiking", "eguiking__body", H, m2])
	ctx.save(); ctx.translate(px, py); ctx.rotate(bA + th * D); ctx.drawImage(arm, -pvx * W, -pvy * H, W, H); ctx.restore()
	ctx.restore()
	# 碎屑：咬落去嗰下由嘴邊噴出嚟
	var mx = J.num(a.x) - fwd * 0.03 * W; var my = J.num(a.y) - fy - 0.66 * H
	crumbs(ctx, mx, my, ph - 0.66, s, floor((z0(o.get("at")) + 0.15) / cyc) * 13 + 3, fwd)
	return null

# ---- 黃總：練高爾夫（原圖拆出嘅球桿手）----
static func golf_draw(ctx, a: Dictionary):
	var LB = _g("Limbs")
	if LB == null or not J.t(J.mc(LB, "has", ["huang"])): return false
	var o: Dictionary = a.o; var t = z0(o.get("t")); var H = J.num(a.H); var s = J.num(a.s); var fwd = 1.0 if J.t(a.faceRight) else -1.0; var at = z0(o.get("at"))
	var d = J.num(J.gp(o.get("pl"), "d")) if J.t(o.get("pl")) and J.t(J.gp(o.pl, "d")) else 9.6
	var IN = 0.9; var L = 4.0; var n = maxf(1, floor((d - IN - 0.7) / L + 0.01)); var last = at >= IN + (n - 1) * L
	var pose = "recover"; var pt = 0.0; var c = -1.0; var ball = 0.0
	if at < IN:
		if at < 0.5: pose = "recover"; pt = 1 - eio(seg(at, 0, 0.5))
		else: pose = "follow"; pt = 1 - eio(seg(at, 0.5, IN))
		ball = seg(at, 0.3, 0.8)
	else:
		c = minf(jm(at - IN, L) + (L if at >= IN + n * L else 0.0), 99.0 if last else L - 1e-6)
		if last: c = at - IN - (n - 1) * L
		if c < 1.0: pose = "strike"; pt = 0.42 - 0.035 * (0.5 - 0.5 * cos(c * TAU * 1.5)) * (1.0 if c < 0.95 else 0.0); ball = 1
		elif c < 1.9: pose = "strike"; pt = 0.42 * (1 - eio(seg(c, 1.0, 1.9))); ball = 1
		elif c < 2.1: pose = "strike"; pt = 0; ball = 1
		elif c < 2.24: pose = "strike"; pt = 0.42 * ei(seg(c, 2.1, 2.24)); ball = 1
		elif c < 2.55: pose = "follow"; pt = eo3(seg(c, 2.24, 2.55))
		elif c < 3.3 or (last and c < 3.4): pose = "follow"; pt = 1
		elif not last: pose = "follow"; pt = 1 - eio(seg(c, 3.3, 4.0)); ball = seg(c, 3.5, 3.9)
		else: pose = "recover"; pt = eio(seg(c, 3.4, 4.1))
	var mp = _anim("idle", [t])
	if c > 2.4: mp["head"] = -0.1 * env(c, 2.4, 2.7, 3.1, 3.5)
	var fy = (3 + sin(t * 2.4) * 2) * s
	shadow_at(ctx, a, 0, 1)
	J.mc(LB, "draw", [ctx, "huang", a.x, J.num(a.y) - fy, H, {"pose": pose, "pt": pt, "t": t, "walk": false}, a.faceRight, mp])
	# 細白波：擺喺腳前，打出去飛走
	var bx = J.num(a.x) + fwd * H * 0.42; var by = J.num(a.y)
	if ball > 0: ctx.save(); ctx.globalAlpha *= ball; ctx.fillStyle = "#fbfbf4"; ctx.strokeStyle = "#555"; ctx.lineWidth = 0.4; ctx.beginPath(); ctx.arc(bx, by - 1.2 * s, 1.5 * s, 0, TAU); ctx.fill(); ctx.stroke(); ctx.restore()
	if c >= 2.24 and c < 3.3:
		var e = c - 2.24; var x = bx + fwd * 150 * s * e; var y = by - 1.2 * s - 120 * s * e + 70 * s * e * e
		ctx.save(); ctx.globalAlpha *= 1 - seg(e, 0.6, 1); ctx.fillStyle = "#fbfbf4"; ctx.beginPath(); ctx.arc(x, y, 1.5 * s * (1 - 0.4 * e), 0, TAU); ctx.fill()
		crayon(ctx, [[x - fwd * 8 * s, y + 5 * s], [x - fwd * 2 * s, y + 1 * s]], 0.8 * s, "rgba(255,255,255,.6)"); ctx.restore()
		dust_puff(ctx, bx, by, seg(e, 0, 0.5), s, 4)
	return null

# ---- 天花姐：翻身上屋簷倒掛休息（用佢自己嘅倒掛原圖）----
# pl.eh = 屋簷離地幾高（世界單位），pl.hd = 掛幾耐
static func hang_times(pl) -> Dictionary:
	var hd = J.num(J.gp(pl, "hd")) if J.t(J.gp(pl, "hd")) else 6.0
	var T1 = 0.85; var T2 = T1 + hd; var T3 = T2 + 0.4; var T4 = T3 + 1.6
	return {"T1": T1, "T2": T2, "T3": T3, "T4": T4}
static func hang_draw(ctx, a: Dictionary):
	if not ok("tianhua_hang"): return false
	var o: Dictionary = a.o; var at = z0(o.get("at")); var t = z0(o.get("t")); var H = J.num(a.H); var s = J.num(a.s); var fwd = 1.0 if J.t(a.faceRight) else -1.0
	var pl = o.get("pl") if J.t(o.get("pl")) else {}; var eh = J.num(J.gp(pl, "eh")) if J.t(J.gp(pl, "eh")) else H * 2.2
	var TT = hang_times(pl); var T1 = TT.T1; var T2 = TT.T2; var T3 = TT.T3; var T4 = TT.T4
	var hang = _spr("tianhua_hang"); var hh = H * 645 / 577; var hw = hh * J.num(J.gp(hang, "naturalWidth")) / J.num(J.gp(hang, "naturalHeight"))
	var ax = J.num(a.x); var ay = J.num(a.y) - eh
	var stand = func(lift: float, rot: float, P: Dictionary):   # 企姿原圖（可以成個反轉）
		var cy = J.num(a.y) - float_y(a) - lift - H * 0.5
		ctx.save(); ctx.translate(J.num(a.x), cy); ctx.rotate(rot); ctx.translate(-J.num(a.x), -cy)
		J.cl(J.gp(_ma(), "draw"), null, [ctx, "tianhua", a.x, J.num(a.y) - float_y(a) - lift, H, P, a.faceRight]); ctx.restore()
	var hang_img = func(y: float, ang: float, sy: float):
		ctx.save(); ctx.translate(ax, y); ctx.rotate(ang); ctx.scale(1, sy if sy else 1.0)
		if not J.t(a.faceRight): ctx.scale(-1, 1)
		ctx.drawImage(hang, -0.72 * hw, 0, hw, hh); ctx.restore()
	if at < T1:   # 蹲（扶腰哎喲）→ 跳起翻身
		var cr = eo(seg(at, 0, 0.36)) * (1 - seg(at, 0.4, 0.5)); var j = seg(at, 0.45, T1); var up = eo3(j)
		var P = add(_anim("idle", [t]), {"body": 0.2 * cr, "head": 0.12 * cr, "sy": 1 - 0.12 * cr + 0.16 * sin(PI * j) * (1 - j), "sx": 1 + 0.06 * cr - 0.08 * sin(PI * j), "armB": sin(at * 14) * 0.08 * cr, "hairL": -0.3 * sin(PI * j), "hairR": -0.3 * sin(PI * j)})
		var lift = (eh - H * 0.55) * up; var rot = -fwd * PI * eio(seg(at, 0.58, T1))
		shadow_at(ctx, a, lift, 1)
		stand.call(lift, rot, P)
		if at > 0.45 and at < 0.7:
			ctx.save(); ctx.globalAlpha *= 1 - seg(at, 0.5, 0.7)
			for i in range(-1, 2): crayon(ctx, [[ax + i * 6 * s, J.num(a.y) - lift + 4 * s], [ax + i * 6 * s, J.num(a.y) - lift + 22 * s]], 0.8 * s, "#e8dfd0")
			ctx.restore()
		dust_puff(ctx, ax, J.num(a.y), seg(at, 0.45, 0.9), s, 2)
		var hp = npt(a, 0.45, 0.0); txt(ctx, hp[0] + fwd * 9 * s, hp[1] - 6 * s, "哎喲", 12 * s * 1.3, "#ffd2d2", env(at, 0.05, 0.15, 0.4, 0.5), 0.3)
		return null
	if at < T2:   # 倒掛：捉住屋簷盪一盪、慢慢停，呼吸
		var e = at - T1; var amp = 22 * exp(-e * 1.7) * cos(e * 4.6); var sway = sin(t * 1.25) * 2.2; var br = 1 + sin(t * 1.6) * 0.012
		ctx.save(); ctx.globalAlpha *= 0.35; J.cl(a.shadow, null, [a.x, 0.5]); ctx.restore()
		hang_img.call(ay, (amp + sway) * D * fwd, br)
		dust_puff(ctx, ax, ay + 2 * s, seg(e, 0, 0.7), s, 9)
		for i in 4:
			var f = e - i * 0.12
			if f < 0 or f > 0.8: continue
			ctx.save(); ctx.globalAlpha *= 1 - f / 0.8; ctx.fillStyle = "#bfb29c"; ctx.beginPath(); ctx.arc(ax + (hsh(i) - 0.5) * 14 * s, ay + 2 * s + 60 * s * f * f, 0.8 * s, 0, TAU); ctx.fill(); ctx.restore()
		o["_z"] = seg(e, 1.8, 2.4) * (1 - seg(at, T2 - 0.5, T2)) if e > 1.8 else 0.0; o["_zpos"] = [ax - fwd * hw * 0.35, ay + hh * 0.75]
		return null
	if at < T3:   # 鬆手：翻返轉落地
		var q = seg(at, T2, T3); var fall = ei(q); var lift = (eh - H * 0.55) * (1 - fall)
		var P = add(_anim("idle", [t]), {"hairL": 0.3, "hairR": 0.3, "sy": 1.05, "sx": 0.96})
		shadow_at(ctx, a, lift, 1)
		if q < 0.18: hang_img.call(ay + 30 * s * q, 0.0, 1.0)
		else: stand.call(lift, -fwd * PI * (1 - eio(seg(q, 0.18, 1))), P)
		return null
	# 落地壓扁 → 扶腰揉一揉「哎喲」
	var e = at - T3; var sq = sin(PI * seg(e, 0, 0.3)) * (1.0 if e < 0.3 else 0.0); var k = env(e, 0.15, 0.4, T4 - T3 - 0.4, T4 - T3)
	var P = add(_anim("idle", [t]), {"sy": 1 - 0.16 * sq, "sx": 1 + 0.1 * sq, "body": 0.2 * sq + 0.13 * k, "head": 0.12 * sq + 0.06 * k, "armB": sin(e * 11) * 0.11 * k})
	shadow_at(ctx, a, 0, 1)
	J.cl(J.gp(_ma(), "draw"), null, [ctx, "tianhua", a.x, J.num(a.y) - float_y(a), H, P, a.faceRight])
	dust_puff(ctx, ax, J.num(a.y), seg(e, 0, 0.5), s, 5)
	var hp = npt(a, 0.45, 0.0); txt(ctx, hp[0] + fwd * 9 * s, hp[1] - 8 * s, "哎喲", 12 * s * 1.3, "#ffd2d2", env(e, 0.1, 0.25, 1.1, 1.4), sin(e * 9) * 0.5)
	return null

const NAMES := ["walk", "eat", "golf", "hang", "talk", "argue", "wave", "bow", "doze", "look", "stretch", "sniff", "backrub", "soup", "hair", "shake", "spin", "boo", "laugh", "startle", "eek", "reach", "bump", "dizzy"]

# ======================= 冇網格骨架嘅角色（Toyol、Pocong、Penanggal）：成張原圖做整體動作 =======================
static func draw_special(ctx, ag: Dictionary, t: float) -> void:
	var k = J.str(ag.k); var s = SC; var H = float(CH.get(k, 50)) * s; var at = J.num(ag.at); var fwd = 1.0 if J.t(ag.face) else -1.0; var act = J.str(ag.act) if ag.get("act") != null else ""
	var pl = ag.pl if J.t(ag.get("pl")) else {}
	var dx = 0.0; var dy = 0.0; var rot = 0.0; var sx = 1.0; var sy = 1.0; var walk = J.num(ag.w) > 0.3
	match act:
		"plaza_talk", "plaza_argue":
			if J.t(J.gp(pl, "spk")): dy = -absf(sin(at * 8)) * 1.6 * s; rot = sin(at * 4.2) * 0.05
			else: rot = 0.05 * sin(PI * seg(jm(at, 1.5), 0.2, 0.75)) * fwd
		"plaza_wave": rot = sin(at * 9) * 0.07 * env(at, 0, 0.2, 1.1, 1.4); dy = -absf(sin(at * 9)) * 1.2 * s
		"plaza_bow":
			var d = J.num(J.gp(pl, "d")) if J.t(J.gp(pl, "d")) else 1.2; var kk = env(at, 0, d * 0.3, d * 0.62, d); rot = 0.22 * kk * fwd; sy = 1 - 0.04 * kk
		"plaza_doze":
			var d = J.num(J.gp(pl, "d")) if J.t(J.gp(pl, "d")) else 8.0; var kk = env(at, 0, 1.4, d - 0.7, d); rot = 0.1 * kk * fwd + sin(t * 1.1) * 0.015; sy = 1 + sin(t * 1.1) * 0.015 * kk; ag["_z"] = kk
		"plaza_look": rot = -0.05 * fwd * env(at, 0, 0.3, 1.6, 2)
		"plaza_startle", "plaza_eek":
			var j = sin(PI * seg(at, 0.06, 0.32)) * (1.0 if at > 0.06 and at < 0.32 else 0.0); dy = -j * 7 * s; sy = 1 + 0.08 * j; rot = sin(at * 45) * 0.03 * (1 - seg(at, 0.3, 1.2)) if at > 0.3 else 0.0
		"plaza_dizzy": rot = sin(at * 6) * 0.09 * (1 - seg(at, 1.6, 2.2)); ag["_stars"] = 1 - seg(at, 1.6, 2.2)
		"plaza_stretch":
			var kk = env(at, 0, 0.6, 1.4, 2); sy = 1 + 0.07 * kk; sx = 1 - 0.035 * kk; rot = -0.05 * kk * fwd
		"plaza_hop": walk = true   # Pocong 原地跳
		"plaza_coins":
			var c = jm(at, 1.1); var d = J.num(J.gp(pl, "d")) if J.t(J.gp(pl, "d")) else 5.0
			rot = (0.07 + 0.03 * sin(PI * seg(c, 0, 0.3))) * fwd * env(at, 0, 0.3, d - 0.3, d); dy = sin(PI * seg(c, 0, 0.3)) * 0.8 * s
		"plaza_spin":
			var q = seg(at, 0.25, 1.35); var c = cos(q * TAU * 2); sx = _sign(c if c else 1.0) * maxf(0.07, absf(c)); dy = -sin(PI * q) * 8 * s
	var x = J.num(ag.x); var y = J.num(ag.y)
	ctx.save(); ctx.translate(x, y); ctx.rotate(rot); ctx.scale(sx, sy); ctx.translate(-x, -y)
	var nr = J.t(J.gp(J.gp(_ma(), "NATIVE_R"), k))
	J.mc(_g("ART"), "drawChar", [ctx, k, x + dx, y + dy, s, {"t": t + J.num(ag.seed), "walk": walk, "tamed": true, "untied": true, "flip": J.t(ag.face) == nr, "key": "plz" + J.str(ag.id)}])
	ctx.restore()
	if act == "plaza_coins": coins_fx(ctx, ag, at, s, H, fwd, pl)
# Toyol 數錢：錢袋入面一個一個彈出嚟、翻、跌返落去，旁邊冒數字；數到一半唔記得，「？」重新嚟過
static func coins_fx(ctx, ag: Dictionary, at: float, s: float, H: float, fwd: float, pl) -> void:
	var px = J.num(ag.x) + fwd * 0.27 * H * 337 / 586; var py = J.num(ag.y) - 0.58 * H
	var n = int(floor(at / 1.1)); var c = jm(at, 1.1); var lost = (n % 5) == 4
	var d = J.num(J.gp(pl, "d")) if J.t(J.gp(pl, "d")) else 5.0
	if not lost and at < d - 0.4:
		var e = seg(c, 0.05, 0.75); var x = px + fwd * sin(PI * e) * 3 * s; var y = py - sin(PI * e) * 15 * s
		if c > 0.05 and c < 0.75:
			var sp = cos(e * TAU * 2); ctx.save(); ctx.translate(x, y); ctx.scale(maxf(0.15, absf(sp)), 1)
			ctx.beginPath(); ctx.arc(0, 0, 2.6 * s, 0, TAU); ctx.fillStyle = "#f2c94c" if sp > 0 else "#d9a62e"; ctx.fill(); ctx.lineWidth = 0.7 * s; ctx.strokeStyle = "#6a4a14"; ctx.stroke()
			ctx.fillStyle = "#6a4a14"; ctx.fillRect(-0.7 * s, -0.7 * s, 1.4 * s, 1.4 * s); ctx.restore()
			if c > 0.5: ctx.save(); ctx.globalAlpha *= 1 - seg(c, 0.5, 0.75); star(ctx, x + 3 * s, y - 2 * s, 1.6 * s, c * 5); ctx.restore()
		txt(ctx, px + fwd * 12 * s, py - 14 * s - seg(c, 0.4, 1.1) * 6 * s, str(n % 5 + 1), 10 * s * 1.4, "#ffe9a8", env(c, 0.4, 0.5, 0.9, 1.1), 0)
	elif lost: bubble(ctx, J.num(ag.x) + fwd * 6 * s, J.num(ag.y) - H - 10 * s, "?", s, env(c, 0, 0.15, 0.9, 1.1))

# ======================= 廣場模擬 =======================
# 行得嘅地方（世界座標）：A = 伐木場同糯米田中間嗰塊（包石板路），B = 兩間屋前面、圍牆入面嗰長條
const ZA := [158.0, 232.0, 534.0, 676.0]
const ZB := [24.0, 366.0, 636.0, 676.0]
static func zone_pt() -> Array:
	var aA = (ZA[1] - ZA[0]) * (ZA[3] - ZA[2]); var aB = (ZB[1] - ZB[0]) * (ZB[3] - ZB[2])
	var Z = ZA if R() * (aA + aB) < aA else ZB
	var x = Z[0] + R() * (Z[1] - Z[0])
	return [x, Z[2] + R() * (Z[3] - Z[2])]
static func near_z(x: float, y: float) -> Array:   # 兩塊行得嘅區域入面，離 (x,y) 最近嘅點
	var pa = [cl(x, ZA[0], ZA[1]), cl(y, ZA[2], ZA[3])]; var pb = [cl(x, ZB[0], ZB[1]), cl(y, ZB[2], ZB[3])]
	return pa if _hyp(pa[0] - x, pa[1] - y) <= _hyp(pb[0] - x, pb[1] - y) else pb
static func clamp_z(a: Dictionary) -> void:
	var x = J.num(a.x); var y = J.num(a.y)
	var inA = x > ZA[0] - 4 and x < ZA[1] + 4 and y > ZA[2] - 4; var inB = y > ZB[2] - 4 and x > ZB[0] - 4 and x < ZB[1] + 4
	if not inA and not inB: return   # 喺香蕉樹下呢啲特別位置：唔理
	var p = near_z(x, y); a["x"] = p[0]; a["y"] = p[1]
static func side_x(x: float) -> bool: return x < ZA[0] - 2 or x > ZA[1] + 2
static func route(ax: float, ay: float, bx: float, by: float) -> Array:   # 有需要先行去兩區重疊嘅地方，免得穿過屋
	var sa = near_z(ax, ay)
	if _hyp(sa[0] - ax, sa[1] - ay) > 3:
		var q = near_z(ax, ay + 40); return [[q[0], q[1]]] + route(q[0], q[1], bx, by)
	if (ay < ZB[2] - 2 and side_x(bx)) or (by < ZB[2] - 2 and side_x(ax)):
		var mx = cl(ax if ay < ZB[2] - 2 else bx, ZA[0] + 6, ZA[1] - 6); return [[mx, 652 + R() * 14], [bx, by]]
	return [[bx, by]]
static func free_pt(W: Dictionary, me, near = null) -> Array:
	var best = null; var bs = -1e9
	for i in 9:
		var p = zone_pt(); var sc = 0.0
		for o in W.list:
			if is_same(o, me): continue
			var d1 = _hyp(J.num(o.x) - p[0], J.num(o.y) - p[1]); var d2 = _hyp(J.num(o.tx) - p[0], J.num(o.ty) - p[1]) if o.get("tx") != null else 99.0
			sc += -maxf(0, 26 - minf(d1, d2)) * 3
		if me != null:
			var d = _hyp(J.num(me.x) - p[0], J.num(me.y) - p[1])
			sc += -absf(d - J.num(near)) * 0.5 if J.t(near) else minf(d, 90) * 0.15
		if sc > bs: bs = sc; best = p
	return best
const VMAX := {"eguiking": 13, "egui": 17, "xiaozhi": 20, "zhiren": 20, "laojiang": 15, "zombie": 15, "tianhua": 14, "mengpo": 12, "heiwu": 15, "baiwu": 16, "niutou": 17, "mamian": 17, "huang": 14, "pontianak": 14, "shuigui": 13, "youhun": 11, "xiaogui": 19, "toyol": 17, "pocong": 14, "penanggal": 15}
static func mk_agent(g, i: float, W: Dictionary) -> Dictionary:
	var p = free_pt(W, null)
	var face = R() < 0.5; var wph = R() * 9; var seed = R() * 50; var dur = 0.3 + R() * 3.5 + i * 0.37
	var c_talk = 2 + R() * 6; var c_prank = 6 + R() * 10; var c_tag = 4 + R() * 8
	var k = J.str(J.gp(g, "k"))
	var ag = {"id": J.gp(g, "id"), "g": g, "k": J.gp(g, "k"), "x": p[0], "y": p[1], "face": face, "want": null, "turnT": 9.0, "sp": 0.0, "w": 0.0, "wph": wph, "hp": -1.0, "seed": seed,
		"vmax": float(VMAX.get(k, 15)), "q": [], "cur": null, "st": "idle", "at": 0.0, "dur": dur, "act": null, "pl": {}, "style": {}, "cd": {"talk": c_talk, "hero": 0.0, "prank": c_prank, "tag": c_tag}, "lock": null, "eatT": 0.0, "wetT": 0.0, "iconT": 9.0, "icon": null}
	ag["want"] = ag.face; ag["tx"] = ag.x; ag["ty"] = ag.y; ag["W"] = W
	return ag
static func is_free(ag: Dictionary) -> bool: return not J.t(ag.get("lock")) and (ag.st == "idle" or (ag.st == "go" and not J.t(J.gp(ag.style, "purpose"))))
static func set_plan(ag: Dictionary, steps: Array) -> void: ag["q"] = steps.duplicate(); next(ag)
static func next(ag: Dictionary) -> void:
	var q: Array = ag.q
	var c = q.pop_front() if q.size() else null
	if not J.t(c): c = null
	ag["cur"] = c; ag["at"] = 0.0
	if c == null: ag["st"] = "idle"; ag["act"] = null; ag["pl"] = {}; ag["style"] = {}; ag["dur"] = 0.8 + R() * 2.6; return
	if J.t(c.get("fn")): J.cl(c.fn, null, [ag]); next(ag); return
	if J.t(c.get("go")):
		ag["st"] = "go"; ag["style"] = c.style if J.t(c.get("style")) else {}; ag["act"] = J.gp(ag.style, "act") if J.t(J.gp(ag.style, "act")) else null; ag["pl"] = {}; ag["tx"] = c.go[0]; ag["ty"] = c.go[1]; return
	ag["st"] = "act" if J.t(c.get("act")) else "idle"; ag["act"] = c.act if J.t(c.get("act")) else null; ag["dur"] = c.get("d"); var pl = {"d": c.get("d")}
	if J.t(c.get("p")): pl.merge(c.p, true)
	ag["pl"] = pl; ag["style"] = c.style if J.t(c.get("style")) else {}
	if c.get("face") != null: ag["want"] = (J.num(J.gp(c.face, "x")) > J.num(ag.x)) if c.face is Dictionary else J.t(c.face)
static func go_steps(ag: Dictionary, x: float, y: float, style = null) -> Array:
	var out = []
	for p in route(J.num(ag.x), J.num(ag.y), x, y): out.append({"go": p, "style": style})
	return out
static func pick_w(arr: Array) -> Callable:
	var tot = 0.0
	for e in arr: tot += e[0]
	var r = R() * tot
	for e in arr:
		r -= e[0]
		if r <= 0: return e[1]
	return arr[arr.size() - 1][1]
static func night() -> bool:
	var h = Time.get_datetime_dict_from_system().hour
	return h >= 22 or h < 6
static func _face_to(o: Dictionary) -> Callable: return _fn(func(x): x["want"] = J.num(o.x) > J.num(x.x))
static func _set_boo(G: Dictionary) -> Callable: return _fn(func(_x): G["boo"] = 1.0)
static func _unlock(a: Dictionary) -> void: a["lock"] = null
static func _end_soc(y: Dictionary) -> void: end_social(null, y)
static func _prank_end(W: Dictionary) -> Callable: return _fn(func(a): _prank_end2(W, a))
static func _prank_end2(W: Dictionary, a: Dictionary) -> void:
	a["lock"] = null; a.cd["prank"] = 22 + R() * 20; var p = free_pt(W, a); a["q"] = go_steps(a, p[0], p[1], {"run": 1.0, "spd": 1.5})
static func _patrol_end(b: Dictionary, G: Dictionary) -> Callable: return _fn(func(x): _patrol_end2(x, b, G))
static func _patrol_end2(x: Dictionary, b: Dictionary, G: Dictionary) -> void:
	x["lock"] = null; b["lock"] = null; b["q"] = []; G["done"] = 1.0
static func _want_fn(v: bool) -> Callable: return func(x): x["want"] = v
static func _fn(f: Callable) -> Callable: return func(_t, a): f.call(a[0]); return null   # 步驟嘅 fn（J 函數）

# 自己決定跟住做乜
static func choose(ag: Dictionary, W: Dictionary) -> void:
	var k = J.str(ag.k); var opts = []
	var busy = func(n: String) -> float:
		var c = 0
		for o in W.list: if not is_same(o, ag) and J.str(o.get("act")) == n: c += 1
		return pow(0.25, c)   # 人哋做緊嘅，少啲做（唔好同步）
	var wander = func(style, after) -> Callable:
		return func():
			var p = free_pt(W, ag); set_plan(ag, go_steps(ag, p[0], p[1], style) + (after if after != null else []))
	opts.append([5.0, wander.call(null, null)])
	opts.append([1.4 * busy.call("plaza_look"), func(): set_plan(ag, [{"act": "plaza_look", "d": 1.8 + R()}])])
	opts.append([0.9 * busy.call("plaza_stretch"), func(): set_plan(ag, [{"act": "plaza_stretch", "d": 2.0}])])
	opts.append([(2.4 if night() else 0.7) * busy.call("plaza_doze"), func(): set_plan(ag, [{"act": "plaza_doze", "d": 6 + R() * 5}])])
	var mate = []
	for o in W.list: if not is_same(o, ag) and is_free(o) and J.num(o.cd.talk) <= 0: mate.append(o)
	var ntalk = 0
	for G in W.games: if G.kind == "talk": ntalk += 1
	if mate.size() and J.num(ag.cd.talk) <= 0 and ntalk < maxf(1, J.round(W.list.size() / 7.0)):
		opts.append([1.6, func():
			var o = mate[int(floor(R() * mate.size()))]; var dx = -1.0 if J.num(ag.x) < J.num(o.x) else 1.0
			var q = near_z(J.num(o.x) + dx * 20, J.num(o.y) + (R() - 0.5) * 6); set_plan(ag, go_steps(ag, q[0], q[1], {"seek": o}))])
	var free_of = func(kk: String):
		for o in W.list: if not is_same(o, ag) and J.str(o.k) == kk and is_free(o): return o
		return null
	match k:
		"eguiking":
			opts.append([5.0, wander.call({"eat": 1.0, "act": "plaza_eat"}, [{"act": "plaza_eat", "d": 3.6 + R() * 3.6}])]); opts.append([2.0, func(): set_plan(ag, [{"act": "plaza_eat", "d": 5 + R() * 4}])])
		"egui":
			var king = null
			for o in W.list: if J.str(o.k) == "eguiking" and J.str(o.get("act")) == "plaza_eat": king = o; break
			if king != null: opts.append([5.0, func(): set_plan(ag, [{"go": [king.x, king.y], "style": {"follow": king, "sniff": 1.0, "purpose": 1.0}}, {"act": "plaza_sniff", "d": 1.6 + R()}])])
			opts.append([2.0, func(): set_plan(ag, [{"act": "plaza_sniff", "d": 2 + R() * 2}])]); opts.append([1.5, wander.call({"sniff": 1.0}, null)])
		"xiaozhi", "zhiren":
			var o = null
			for x in W.list: if not is_same(x, ag) and PAPER.has(J.str(x.k)) and is_free(x) and J.num(x.cd.tag) <= 0: o = x; break
			if o != null and J.num(ag.cd.tag) <= 0: opts.append([4.0, func(): start_tag(W, ag, o)])
		"laojiang", "zombie":
			opts.append([1.8, func():
				var b = SPOTS.bumps[int(floor(R() * SPOTS.bumps.size()))]
				var fw = _fn(_want_fn(b[2] > 0))
				set_plan(ag, go_steps(ag, b[0] - b[2] * 30, b[1], {}) + [{"go": [b[0], b[1]], "style": {"purpose": 1.0}}, {"fn": fw}, {"act": "plaza_bump", "d": 0.75, "p": {"dir": b[2]}}, {"act": "plaza_dizzy", "d": 2.2}])])
		"tianhua":
			opts.append([2.5, func(): set_plan(ag, [{"act": "plaza_backrub", "d": 2.6}])])
			var near_eave = false
			for o in W.list: if not is_same(o, ag) and _hyp(J.num(o.x) - SPOTS.eave.x, J.num(o.y) - SPOTS.eave.y) < 18: near_eave = true
			if J.t(J.gp(W.bld, "wood")) and not near_eave:
				var hd = 5 + R() * 5; var pl = {"eh": SPOTS.eave.y - SPOTS.eave.ey, "hd": hd}; var T = hang_times(pl)
				opts.append([2.2, func(): set_plan(ag, go_steps(ag, SPOTS.eave.x, SPOTS.eave.y, {"purpose": 1.0}) + [{"act": "plaza_hang", "d": T.T4, "p": pl, "face": R() < 0.5}])])
		"mengpo": opts.append([4.0, wander.call({"purpose": 1.0}, [{"act": "plaza_soup", "d": 9 + R() * 6}])])
		"heiwu", "baiwu":
			var o = free_of.call("baiwu" if k == "heiwu" else "heiwu")
			if o != null and J.num(ag.cd.talk) <= 0 and J.num(o.cd.talk) <= 0: opts.append([4.0, func(): start_talk(W, ag, o, true)])
		"niutou", "mamian":
			var o = free_of.call("mamian" if k == "niutou" else "niutou")
			if o != null: opts.append([4.0, func(): start_patrol(W, ag, o)])
		"huang": opts.append([4.0, func(): set_plan(ag, [{"act": "plaza_golf", "d": 0.9 + 4 * (1 + floor(R() * 2)) + 0.7}])])
		"pontianak":
			var b = SPOTS.banana[int(floor(R() * 2))]
			opts.append([3.0, func(): set_plan(ag, go_steps(ag, b[0], b[1], {"purpose": 1.0}) + [{"act": "plaza_hair", "d": 4.6 + R() * 4, "face": b[2] > 0}])]); opts.append([1.5, func(): set_plan(ag, [{"act": "plaza_hair", "d": 4.6}])])
		"shuigui": opts.append([2.0, func(): set_plan(ag, [{"act": "plaza_shake", "d": 1.8}])])
		"youhun": opts.append([2.2, func(): set_plan(ag, [{"act": "plaza_spin", "d": 2.2}])]); opts.append([2.0, wander.call(null, null)])
		"xiaogui":
			var v = prank_victim(W, ag)
			if v != null and J.num(ag.cd.prank) <= 0: opts.append([4.0, func(): start_prank(W, ag, v)])
		"toyol": opts.append([4.0, func(): set_plan(ag, [{"act": "plaza_coins", "d": 5.5 + R() * 3.3}])])
		"pocong": opts.append([2.0, func(): set_plan(ag, [{"act": "plaza_hop", "d": 1.3 + R() * 1.5}])])
	pick_w(opts).call()

# ---- 兩隻碰面傾偈（黑白無常係嗌交）----
static func start_talk(W: Dictionary, a: Dictionary, b: Dictionary, argue: bool) -> void:
	var spk = a if R() < 0.5 else b
	var G = {"kind": "talk", "a": a, "b": b, "argue": argue, "spk": spk, "sw": 0.8, "T": (6 + R() * 4) if argue else (3.5 + R() * 3)}
	a["lock"] = G; b["lock"] = G; a.cd["talk"] = 99.0; b.cd["talk"] = 99.0
	var d = _hyp(J.num(a.x) - J.num(b.x), J.num(a.y) - J.num(b.y))
	var act = "plaza_argue" if argue else "plaza_talk"
	var g1 = "plaza_wave" if R() < 0.5 else "plaza_bow"; var g2 = "plaza_wave" if R() < 0.5 else "plaza_bow"
	var pre = []
	if argue and d > 30:
		var mx = (J.num(a.x) + J.num(b.x)) / 2; var my = (J.num(a.y) + J.num(b.y)) / 2; var q = near_z(mx + (-11.0 if J.num(a.x) < J.num(b.x) else 11.0), my); pre = go_steps(a, q[0], q[1], {"purpose": 1.0})
	elif d < 18 or absf(J.num(a.y) - J.num(b.y)) > 6:   # 企到對方隔籬（同一排），面對面
		var side = -1.0 if J.num(a.x) < J.num(b.x) else 1.0; var q = near_z(J.num(b.x) + side * 21, J.num(b.y) + (R() - 0.5) * 3)
		if absf(q[0] - J.num(b.x)) < 15: side = -side; q = near_z(J.num(b.x) + side * 21, J.num(b.y))
		pre = go_steps(a, q[0], q[1], {"purpose": 1.0})
	G["t"] = 0.0; G["act"] = act
	set_plan(a, pre + [{"fn": _face_to(b)}, {"act": "plaza_look", "d": 0.5} if argue else {"act": g1, "d": 1.3, "p": {"deep": 0.7}}, {"act": act, "d": 60.0, "p": {}}])
	set_plan(b, [{"fn": _face_to(a)}, {"d": 0.3 if argue else 0.35}, {"act": "plaza_look", "d": 0.5} if argue else {"act": g2, "d": 1.3, "p": {"deep": 0.7}}, {"act": act, "d": 60.0, "p": {}}])
	W.games.append(G)
static func end_social(_W, ag: Dictionary) -> void:
	ag["lock"] = null; ag.cd["talk"] = 10 + R() * 12
	var p = free_pt(ag.W, ag); ag["q"] = go_steps(ag, p[0], p[1])   # 講完各行各路

# ---- 紙人追逐（小紙、紙人偶）----
static func start_tag(W: Dictionary, a: Dictionary, b: Dictionary) -> void:
	var G = {"kind": "tag", "ch": a, "ru": b, "T": 9 + R() * 5, "t": 0.0, "pause": 0.0}
	a["lock"] = G; b["lock"] = G; a.cd["tag"] = 99.0; b.cd["tag"] = 99.0
	a["q"] = []; b["q"] = []; a["cur"] = null; b["cur"] = null
	W.games.append(G)
static func tag_tick(_W: Dictionary, G: Dictionary, dt: float) -> void:
	G["t"] = J.num(G.t) + dt; var ch = G.ch; var ru = G.ru
	if J.num(G.pause) > 0:
		G["pause"] = J.num(G.pause) - dt
		if J.num(G.pause) <= 0: var x = G.ch; G["ch"] = G.ru; G["ru"] = x
		return
	if J.num(G.t) > J.num(G.T):   # 玩攰咗：抖一抖
		for x in [ch, ru]: x["lock"] = null; x.cd["tag"] = 18 + R() * 14; set_plan(x, [{"act": "plaza_bow", "d": 1.4, "p": {"deep": 0.6}}])
		G["done"] = 1.0; return
	if ru.st != "go" or _hyp(J.num(ru.x) - J.num(ru.tx), J.num(ru.y) - J.num(ru.ty)) < 6:   # 走去離鬼遠啲嘅地方
		var best = null; var bs = -1.0
		for i in 6:
			var p = zone_pt(); var sc = _hyp(p[0] - J.num(ch.x), p[1] - J.num(ch.y)) - _hyp(p[0] - J.num(ru.x), p[1] - J.num(ru.y)) * 0.3
			if sc > bs: bs = sc; best = p
		set_plan(ru, go_steps(ru, best[0], best[1], {"run": 1.0, "spd": 1.55, "purpose": 1.0}))
	if not J.t(ch.get("cur")) or not J.t(ch.cur.get("go")) or not is_same(J.gp(ch.style, "follow"), ru): set_plan(ch, [{"go": [ru.x, ru.y], "style": {"follow": ru, "chase": 1.0, "run": 1.0, "spd": 1.7, "purpose": 1.0}}])
	if _hyp(J.num(ch.x) - J.num(ru.x), (J.num(ch.y) - J.num(ru.y)) * 1.4) < 11:   # 捉到！
		ch["want"] = J.num(ru.x) > J.num(ch.x); ru["want"] = J.num(ch.x) > J.num(ru.x)
		set_plan(ch, [{"act": "plaza_reach", "d": 0.5}, {"d": 0.5}]); set_plan(ru, [{"act": "plaza_eek", "d": 0.75}, {"d": 0.25}])
		ch["fxTxt"] = {"s": "抓到！", "t": 0.0}; G["pause"] = 1.0

# ---- 小鬼惡作劇：靜雞雞行到人哋背後「哇！」----
static func prank_victim(W: Dictionary, x: Dictionary):
	var c = []
	for o in W.list:
		if is_same(o, x) or J.t(o.get("lock")) or J.str(o.k) == "xiaogui" or J.str(o.get("act")) == "plaza_hang": continue
		if (o.st == "act" and J.num(o.dur) - J.num(o.at) > 3) or (o.st == "idle" and J.num(o.dur) - J.num(o.at) > 1.5): c.append(o)
	return c[int(floor(R() * c.size()))] if c.size() else null
static func start_prank(W: Dictionary, x: Dictionary, v: Dictionary) -> void:
	var G = {"kind": "prank", "x": x, "v": v, "vx": v.x, "vy": v.y}
	x["lock"] = G; v["lock"] = G; x.cd["prank"] = 99.0
	var bb = near_z(J.num(v.x) - (1.0 if J.t(v.face) else -1.0) * 17, J.num(v.y) + 1); var bx = bb[0]; var by = bb[1]
	var dist = _hyp(bx - J.num(x.x), by - J.num(x.y)); var tt = dist / (J.num(x.vmax) * 0.45) + 1.5
	v["dur"] = maxf(J.num(v.dur), J.num(v.at) + tt + 1.2)
	set_plan(x, go_steps(x, bx, by, {"sneak": 1.0, "spd": 0.45, "purpose": 1.0}) + [{"fn": _face_to(v)}, {"d": 0.35}, {"fn": _set_boo(G)}, {"act": "plaza_boo", "d": 0.95}, {"act": "plaza_laugh", "d": 1.7},
		{"fn": _prank_end(W)}])
	W.games.append(G)
static func prank_tick(_W: Dictionary, G: Dictionary) -> void:
	var x = G.x; var v = G.v
	if not J.t(G.get("boo")) and _hyp(J.num(v.x) - J.num(G.vx), J.num(v.y) - J.num(G.vy)) > 10:   # 對方行開咗：算數
		x["lock"] = null; v["lock"] = null; x.cd["prank"] = 10.0; set_plan(x, [{"act": "plaza_look", "d": 1.6}]); G["done"] = 1.0; return
	if J.num(G.get("boo")) == 1 and J.str(x.get("act")) == "plaza_boo" and J.num(x.at) > 0.2:
		G["boo"] = 2.0; v["want"] = J.num(x.x) > J.num(v.x)
		set_plan(v, [{"act": "plaza_startle", "d": 1.3}, {"act": "plaza_look", "d": 1.2}, {"fn": _fn(_unlock)}])
		v["icon"] = "!"; v["iconT"] = 0.0; G["done"] = 1.0

# ---- 牛頭馬面：一前一後巡邏 ----
static func start_patrol(W: Dictionary, a: Dictionary, b: Dictionary) -> void:
	var G = {"kind": "patrol", "a": a, "b": b}
	a["lock"] = G; b["lock"] = G
	var pts = [[170.0, 560.0], [226.0, 650.0], [340.0, 656.0], [200.0, 668.0], [50.0, 656.0], [190.0, 600.0]]; var st = int(floor(R() * pts.size())); var steps = []
	for i in 4:
		var p = pts[(st + i) % pts.size()]; steps.append({"go": p, "style": {"stiff": 1.0, "purpose": 1.0}}); steps.append({"act": "plaza_look", "d": 1.6})
	steps.append({"fn": _patrol_end(b, G)})
	set_plan(a, steps)
	set_plan(b, [{"go": [a.x, a.y], "style": {"follow": a, "stiff": 1.0, "side": 1.0, "purpose": 1.0, "keep": 1.0}}])
	W.games.append(G)

# ======================= 每格更新 =======================
const TURN := 0.22
static func tick(ag: Dictionary, dt: float, W: Dictionary) -> void:
	ag["at"] = J.num(ag.at) + dt
	for k in ag.cd: ag.cd[k] = J.num(ag.cd[k]) - dt
	ag["iconT"] = J.num(ag.iconT) + dt
	if J.t(ag.get("fxTxt")): ag.fxTxt["t"] = J.num(ag.fxTxt.t) + dt
	var hopper = HOPPER.has(J.str(ag.k))
	if ag.st == "go":
		var st = ag.style; var tx = J.num(ag.tx); var ty = J.num(ag.ty); var stopD = 1.2
		var fo = J.gp(st, "follow")
		if J.t(fo):
			var fd = 1.0 if J.t(fo.face) else -1.0
			if J.t(J.gp(st, "chase")): tx = J.num(fo.x); ty = J.num(fo.y); stopD = 0.0
			elif J.t(J.gp(st, "side")): tx = J.num(fo.x) - fd * 8; ty = J.num(fo.y) + 12; stopD = 3.0
			else: tx = J.num(fo.x) - fd * 24; ty = J.num(fo.y) + 3; stopD = 4.0
		var sk = J.gp(st, "seek")
		if J.t(sk):
			if J.t(sk.get("lock")) or J.num(ag.at) > 7: next(ag); return
			tx = J.num(sk.x) + (-20.0 if J.num(ag.x) < J.num(sk.x) else 20.0); ty = J.num(sk.y)
		if (J.t(sk) or (J.t(fo) and not J.t(J.gp(st, "chase")))) and not (J.t(fo) and J.str(fo.get("act")) == "plaza_hang"):
			var q = near_z(tx, ty); tx = q[0]; ty = q[1]
		var dx = tx - J.num(ag.x); var dy = ty - J.num(ag.y); var d = _hyp(dx, dy); var vm = J.num(ag.vmax) * (J.num(J.gp(st, "spd")) if J.t(J.gp(st, "spd")) else 1.0)
		var tsp = 0.0 if d <= stopD else minf(vm, (d - stopD) * 2.4 + 2)
		if J.t(fo) and not J.t(J.gp(st, "chase")) and not J.t(J.gp(st, "keep")) and (J.num(ag.at) > 9 or J.str(fo.get("act")) != "plaza_eat"): next(ag); return
		var sp = J.num(ag.sp); sp += (tsp - sp) * minf(1, dt * (6.0 if tsp < sp else 3.5)); ag["sp"] = sp
		var mv = sp * dt
		if hopper:   # 淨係騰空嗰陣先前進
			if J.num(ag.hp) < 0: ag["hp"] = 0.0
			var hp = J.num(ag.hp); var air = hp >= 0.22 and hp <= 0.9; mv = minf(d, (1.0 if sp > 0.5 else 0.0) * 13 * dt / (0.68 * 0.62)) if air else 0.0
		if d > 0.01:
			var ax = J.num(ag.x); var ay = J.num(ag.y)
			var nx = ax + dx / d * minf(mv, d); var ny = ay + dy / d * minf(mv, d); var zz0 = near_z(ax, ay); var zz1 = near_z(tx, ty)
			if _hyp(zz0[0] - ax, zz0[1] - ay) < 0.5 and _hyp(zz1[0] - tx, zz1[1] - ty) < 0.5:
				var q = near_z(nx, ny); ag["x"] = q[0]; ag["y"] = q[1]   # 喺廣場入面行：貼住邊滑，唔切過屋角
			else: ag["x"] = nx; ag["y"] = ny
		if absf(dx) > 2.5 and J.num(ag.sp) > 2: ag["want"] = dx > 0
		if not J.t(fo) and d < 1.5:
			ag["sp"] = 0.0 if hopper else ag.sp; next(ag)
		if J.t(fo) and J.t(J.gp(st, "side")) and not J.t(fo.get("lock")): next(ag)
	else:
		ag["sp"] = maxf(0, J.num(ag.sp) - dt * J.num(ag.vmax) * 3.2)
		if ag.st == "act" or J.t(ag.get("cur")):
			if J.num(ag.at) >= J.num(ag.dur): next(ag)
		elif J.num(ag.at) >= J.num(ag.dur):
			if (ag.q as Array).size(): next(ag)
			else: choose(ag, W)
		if J.str(ag.get("act")) == "plaza_bump":
			if not is_same(ag.get("_bkC"), ag.cur): ag["_bkC"] = ag.cur; ag["_bk"] = 0.0
			var k = eo(seg(J.num(ag.at), 0.1, 0.55)); var dir = J.num(J.gp(ag.pl, "dir")) if J.t(J.gp(ag.pl, "dir")) else 1.0
			ag["x"] = J.num(ag.x) - dir * 10 * (k - J.num(ag._bk)); ag["_bk"] = k
		if J.str(ag.get("act")) == "plaza_look" and J.num(ag.at) > 0.75 and not J.t(ag.get("_lk")):
			ag["_lk"] = 1.0
			if not J.t(ag.get("lock")): ag["want"] = not J.t(ag.face)
		if J.str(ag.get("act")) != "plaza_look": ag["_lk"] = 0.0
	# 跳嘅：一跳要跳完
	if hopper:
		if ag.st == "go" or J.num(ag.hp) >= 0:
			ag["hp"] = J.num(ag.hp) + dt / 0.62
			if J.num(ag.hp) >= 1: ag["hp"] = J.num(ag.hp) - 1 if ag.st == "go" else -1.0
	ag["w"] = 0.0 if hopper else cl(J.num(ag.sp) / (J.num(ag.vmax) * 0.85))
	ag["wph"] = J.num(ag.wph) + dt * (J.num(ag.sp) / J.num(ag.vmax)) * (1.6 if J.t(J.gp(ag.style, "run")) else (0.55 if J.t(J.gp(ag.style, "sneak")) else 1.0))
	if J.str(ag.get("act")) == "plaza_eat" or J.t(J.gp(ag.style, "eat")): ag["eatT"] = J.num(ag.eatT) + dt
	# 傾偈嘅：面對面
	var G = ag.get("lock")
	if J.t(G) and J.str(G.get("kind")) == "talk":
		var o = G.b if is_same(G.a, ag) else G.a
		if ag.st != "go": ag["want"] = J.num(o.x) > J.num(ag.x)
	# 轉身：好似紙片翻面
	if J.t(ag.want) != J.t(ag.face) and J.num(ag.turnT) >= TURN: ag["turnT"] = 0.0
	if J.num(ag.turnT) < TURN:
		ag["turnT"] = J.num(ag.turnT) + dt
		if J.num(ag.turnT) >= TURN / 2 and not J.t(ag.get("_flipped")): ag["face"] = ag.want; ag["_flipped"] = 1.0
		if J.num(ag.turnT) >= TURN: ag["_flipped"] = 0.0
	# 水鬼：滴水
	if J.str(ag.k) == "shuigui":
		ag["wetT"] = J.num(ag.wetT) - dt
		if J.num(ag.wetT) <= 0:
			ag["wetT"] = 0.32 if J.num(ag.sp) > 3 else 0.9 + R() * 0.6
			var wx = J.num(ag.x) + (R() - 0.5) * 8; var wy = J.num(ag.y) + (R() - 0.5) * 3; var life = 4 + R() * 2; var r = 1.8 + R() * 1.6
			W.wet.append({"x": wx, "y": wy, "t": 0.0, "life": life, "r": r, "d": 0.0})
static func _talking(x) -> bool: return J.str(x.get("act")) == "plaza_talk" or J.str(x.get("act")) == "plaza_argue"
static func talk_tick(G: Dictionary, dt: float) -> void:
	var a = G.a; var b = G.b; G["sw"] = J.num(G.sw) - dt
	var on = _talking(a) or _talking(b)
	if on and J.num(G.sw) <= 0:
		if R() < 0.75: G["spk"] = b if is_same(G.spk, a) else a
		G["sw"] = (0.6 + R() * 0.9) if J.t(G.argue) else (0.9 + R() * 0.8)
		var pool = ((["…", "…", "!"] if J.str(G.spk.k) == "heiwu" else ["!", "?", "!", "…"]) if J.t(G.argue) else ["…", "♪", "?", "!", "…"])
		G.spk["icon"] = pool[int(floor(R() * pool.size()))]; G.spk["iconT"] = 0.0
	for x in [a, b]:
		if _talking(x): x.pl["spk"] = is_same(G.spk, x)
	if J.str(a.get("act")) == J.str(G.act) and J.str(b.get("act")) == J.str(G.act): G["t"] = J.num(G.t) + dt
	if J.num(G.t) >= J.num(G.T) or not is_same(a.get("lock"), G) or not is_same(b.get("lock"), G):   # 傾完：點個頭，各行各路
		G["done"] = 1.0
		var xs = [a, b]
		for i in 2:
			var x = xs[i]
			if is_same(x.get("lock"), G): set_plan(x, [{"d": i * 0.25}, {"act": "plaza_bow", "d": 0.9, "p": {"deep": 0.45}}, {"fn": _fn(_end_soc)}])
static func update(W: Dictionary, dt: float, hero) -> void:
	for ag in W.list: tick(ag, dt, W)
	for G in W.games:
		if J.t(G.get("done")): continue
		match J.str(G.kind):
			"tag": tag_tick(W, G, dt)
			"prank": prank_tick(W, G)
			"talk": talk_tick(G, dt)
			"patrol":
				if not J.t(G.a.get("lock")): G["done"] = 1.0
	W["games"] = W.games.filter(func(G): return not J.t(G.get("done")))
	# 行行下撞到：停低傾兩句
	W["socT"] = J.num(W.socT) - dt
	var talks = 0
	for G in W.games: if G.kind == "talk": talks += 1
	var max_talk = maxf(1, J.round(W.list.size() / 7.0))
	if J.num(W.socT) <= 0 and talks < max_talk:
		W["socT"] = 0.25
		var L: Array = W.list; var i = 0
		while i < L.size():
			var j = i + 1; var hit = false
			while j < L.size():
				var a = L[i]; var b = L[j]
				if not is_free(a) or not is_free(b) or J.num(a.cd.talk) > 0 or J.num(b.cd.talk) > 0: j += 1; continue
				var seeks = is_same(J.gp(a.style, "seek"), b) or is_same(J.gp(b.style, "seek"), a)
				if _hyp(J.num(a.x) - J.num(b.x), (J.num(a.y) - J.num(b.y)) * 1.6) < 30 and (a.st == "go" or b.st == "go" or seeks) and (seeks or R() < 0.12):
					start_talk(W, a, b, (J.str(a.k) == "heiwu" and J.str(b.k) == "baiwu") or (J.str(a.k) == "baiwu" and J.str(b.k) == "heiwu")); hit = true; break
				j += 1
			if hit: break
			i += 1
	# 唔好逼埋一齊
	for a in W.list:
		for b in W.list:
			var la = a.get("lock")
			if is_same(a, b) or a.st == "go" or J.str(a.get("act")) == "plaza_hang" or (J.t(la) and is_same(la, b.get("lock")) and J.str(la.kind) != "talk"): continue
			var dx = J.num(a.x) - J.num(b.x); var dy = (J.num(a.y) - J.num(b.y)) * 1.8; var d = _hyp(dx, dy); var rr = 15.0 if J.t(la) and is_same(la, b.get("lock")) else 19.0
			if d > rr or d < 0.01: continue
			var k = (rr - d) * dt * 1.2; a["x"] = J.num(a.x) + dx / d * k; a["y"] = J.num(a.y) + dy / d * k * 0.4; clamp_z(a)
	# 阿福經過：揮手打招呼
	W["heroT"] = J.num(W.heroT) - dt
	if J.t(hero) and J.t(J.gp(hero, "walking")) and J.num(W.heroT) <= 0:
		var c = []
		for o in W.list:
			if o.st == "idle" and not J.t(o.get("lock")) and not (o.q as Array).size() and J.num(o.cd.hero) <= 0 and _hyp(J.num(o.x) - J.num(J.gp(hero, "x")), (J.num(o.y) - J.num(J.gp(hero, "y"))) * 1.5) < 46: c.append(o)
		if c.size():
			var o = c[int(floor(R() * c.size()))]; o.cd["hero"] = 25 + R() * 20; W["heroT"] = 4.0
			set_plan(o, [{"act": "plaza_wave" if R() < 0.7 else "plaza_bow", "d": 1.4, "face": hero, "p": {"deep": 0.6}}])
	for w in W.wet: w["t"] = J.num(w.t) + dt
	W["wet"] = W.wet.filter(func(w): return J.num(w.t) < J.num(w.life))

# ======================= 畫 =======================
static func head_y(ag: Dictionary) -> float: return J.num(ag.y) - float(CH.get(J.str(ag.k), 50)) * SC - (0.0 if SOLID.has(J.str(ag.k)) else 4.0)
static func draw_agent(ctx, ag: Dictionary, t: float, opt) -> void:
	var k = J.str(ag.k); var T = t + J.num(ag.seed); var x = J.num(ag.x)
	var tk = maxf(0.08, absf(cos(PI * J.num(ag.turnT) / TURN))) if J.num(ag.turnT) < TURN else 1.0
	ctx.save(); ctx.translate(x, 0); ctx.scale(tk, 1); ctx.translate(-x, 0)
	var style = ag.style if J.t(ag.get("style")) else {}
	var act = J.str(ag.act) if J.t(ag.get("act")) else ("plaza_eat" if J.t(J.gp(style, "eat")) else "plaza_walk")
	ag["_z"] = 0.0; ag["_stars"] = 0.0
	var SP = _g("SPECIAL")
	if J.t(J.cl(J.gp(_ma(), "has"), null, [k])) and not (SP != null and J.t(J.mc(SP, "has", [k]))):
		var o = {"t": T, "act": act, "at": ag.eatT if act == "plaza_eat" else ag.at, "w": ag.w, "wph": ag.wph, "hp": ag.hp, "run": cl(J.num(ag.w)) if J.t(J.gp(style, "run")) else 0.0, "sniff": J.gp(style, "sniff"), "sneak": J.gp(style, "sneak"), "stiff": J.gp(style, "stiff"), "pl": ag.pl, "flip": not J.t(ag.face), "tamed": true, "untied": true}
		J.mc(_g("ART"), "drawChar", [ctx, k, x, ag.y, SC, o])
		ag["_z"] = z0(o.get("_z")); ag["_stars"] = z0(o.get("_stars")); ag["_zpos"] = o.get("_zpos")   # 轉譯版同 JS 一樣：鍵照設（值可以係空）
	else: draw_special(ctx, ag, T)
	ctx.restore()
	# 頭頂嘅嘢
	var hy = head_y(ag); var s = SC; var fwd = 1.0 if J.t(ag.face) else -1.0
	if J.num(ag._z) > 0.05:
		var H = float(CH.get(k, 50)) * SC; var p = ag.get("_zpos")
		if not J.t(p): p = [x + fwd * 9, J.num(ag.y) - H * (1 - float(FACEV.get(k, 0.3))) - (2.0 if SOLID.has(k) else 6.0)]
		zzz(ctx, J.num(p[0]), J.num(p[1]), T, s, J.num(ag._z))
	if J.num(ag._stars) > 0: stars(ctx, x, hy + 2, T, s, J.num(ag._stars))
	var it = J.num(ag.get("iconT"))
	if J.t(ag.get("icon")) and it < 1.25 and not (J.t(opt) and J.t(J.gp(opt, "noIcon"))):
		var k2 = minf(minf(1, it * 6), (1.25 - it) * 5); bubble(ctx, x + fwd * 7, hy - 7 - sin(minf(1, it * 3) * PI) * 2, J.str(ag.icon), s, k2)
	var fx = ag.get("fxTxt")
	if J.t(fx) and J.num(fx.t) < 1: txt(ctx, x, hy - 6 - J.num(fx.t) * 8, J.str(fx.s), 10 * s * 1.4, "#ffe9a8", minf(1, (1 - J.num(fx.t)) * 3), 0.2)
static func draw_wet(ctx, w: Dictionary) -> void:
	var wt = J.num(w.t); var r = J.num(w.r); var x = J.num(w.x); var y = J.num(w.y)
	var k = 1 - wt / J.num(w.life); var g = minf(1, wt * 6)
	ctx.save(); ctx.globalAlpha *= 0.5 * k; ctx.fillStyle = "#1d3440"; ctx.beginPath(); ctx.ellipse(x, y, r * (0.6 + 0.4 * g), r * 0.42 * (0.6 + 0.4 * g), 0, 0, TAU); ctx.fill()
	ctx.globalAlpha *= 0.8; ctx.fillStyle = "#6fa6bd"; ctx.beginPath(); ctx.ellipse(x - r * 0.25, y - r * 0.1, r * 0.3, r * 0.1, 0, 0, TAU); ctx.fill()
	if wt < 0.35: ctx.globalAlpha = 0.7 * (1 - wt / 0.35); ctx.strokeStyle = "#9fd0e6"; ctx.lineWidth = 0.6; ctx.beginPath(); ctx.ellipse(x, y, r * (1 + wt * 6), r * 0.42 * (1 + wt * 6), 0, 0, TAU); ctx.stroke()
	ctx.restore()
# 水鬼身上一路滴水（由衫、頭髮跌落地）
static func draw_drips(ctx, ag: Dictionary, t: float) -> void:
	var H = float(CH.shuigui) * SC; var seed = J.num(ag.seed); var x0 = J.num(ag.x); var ay = J.num(ag.y)
	for i in 3:
		var ph = jm(t * 0.9 + i * 0.37 + seed, 1); var x = x0 + (hsh(i + floor(t * 0.9 + i * 0.37 + seed)) - 0.5) * H * 0.5; var y0 = ay - H * (0.35 + 0.2 * hsh(i * 3))
		drop(ctx, x, y0 + (ay - y0) * ei(ph), 1.1, 0.8 * (1 - seg(ph, 0.85, 1)))

static func new_world() -> Dictionary: return {"list": [], "games": [], "wet": [], "socT": 1.0, "heroT": 2.0, "last": null, "bld": {"wood": 1.0}}
# 遊戲接口：Village.collect／draw 每格叫
static func frame(V: Dictionary, ghosts: Array, items: Array, vis: Array, ctx, t: float) -> void:
	if not J.t(V.get("plaza")): V["plaza"] = new_world()
	var W: Dictionary = V.plaza
	var dt = 0.0 if W.get("last") == null else t - J.num(W.last); W["last"] = t; dt = cl(dt, 0, 0.1)
	var S = _g("S")
	W["bld"] = S.bld if S is Dictionary and J.t(S.get("bld")) else W.bld
	# 名單同步：新嚟嘅搵空位出現，被派去打工嘅離開
	var ids = {}
	for g in ghosts: ids[J.gp(g, "id")] = true
	var keep = []
	for a in W.list:
		if ids.has(a.id): keep.append(a); continue
		for G in W.games:
			var mem = false
			for kk in ["a", "b", "ch", "ru", "x", "v"]: if is_same(G.get(kk), a): mem = true
			if mem:
				G["done"] = 1.0
				for kk in ["a", "b", "ch", "ru", "x", "v"]:
					var o = G.get(kk)
					if o != null and not is_same(o, a):
						o["lock"] = null; o["q"] = []; o["cur"] = null; o["st"] = "idle"; o["act"] = null; o["at"] = 0.0; o["dur"] = 0.5; o["style"] = {}
	W["list"] = keep
	var have = {}
	for a in W.list: have[a.id] = true
	for g in ghosts: if not have.has(J.gp(g, "id")): W.list.append(mk_agent(g, W.list.size(), W))
	for a in W.list:
		var found = null
		for g in ghosts: if J.gp(g, "id") == a.id: found = g; break
		if found != null: a["g"] = found
	update(W, dt, V.get("hero"))
	for w in W.wet:
		var ww = w
		items.append({"y": J.num(w.y) - 40, "f": func(_t, _a): draw_wet(ctx, ww); return null})
	var b = V.get("bubble")
	for ag in W.list:
		var aa = ag
		vis.append({"g": ag.g, "x": ag.x, "y": ag.y})
		var mute = J.t(b) and J.gp(b, "id") == J.gp(ag.g, "id") and not J.t(J.gp(b, "hero"))
		items.append({"y": ag.y, "f": func(_t, _a):
			draw_agent(ctx, aa, t, {"noIcon": mute})
			if J.str(aa.k) == "shuigui": draw_drips(ctx, aa, t + J.num(aa.seed))
			return null})

const SPOTS := {
	"eave": {"x": 124.0, "y": 640.0, "ey": 556.0},                                                      # 伐木場正面橫樑（天花姐倒掛）
	"banana": [[368.0, 590.0, -1.0], [34.0, 640.0, 1.0]],                                               # 香蕉樹下（Pontianak）
	"bumps": [[160.0, 600.0, -1.0], [234.0, 606.0, 1.0], [172.0, 674.0, -1.0], [218.0, 674.0, 1.0]],    # 殭屍撞到：伐木場牆角、糯米田籬笆、兩支燈柱
}

func run(_env) -> void:
	var DA = _g("DAILY")
	if DA is Dictionary:
		for n in NAMES: DA["plaza_" + n] = func(_t, a): return body(J.arg(a, 0), J.arg(a, 1))
	J.G["PlazaLife"] = {
		"frame": func(_t, a): frame(a[0], J.iter(a[1]), a[2], a[3], a[4], J.num(a[5])); return null,
		"newWorld": func(_t, _a): return new_world(),
		"update": func(_t, a): update(a[0], J.num(a[1]), J.arg(a, 2)); return null,
		"drawAgent": func(_t, a): draw_agent(a[0], a[1], J.num(a[2]), J.arg(a, 3)); return null,
		"drawWet": func(_t, a): draw_wet(a[0], a[1]); return null,
		"drawDrips": func(_t, a): draw_drips(a[0], a[1], J.num(a[2])); return null,
		"mkAgent": func(_t, a): return mk_agent(a[0], J.num(a[1]), a[2]),
		"setPlan": func(_t, a): set_plan(a[0], J.iter(a[1])); return null,
		"choose": func(_t, a): choose(a[0], a[1]); return null,
		"startTalk": func(_t, a): start_talk(a[0], a[1], a[2], J.t(J.arg(a, 3))); return null,
		"startTag": func(_t, a): start_tag(a[0], a[1], a[2]); return null,
		"startPrank": func(_t, a): start_prank(a[0], a[1], a[2]); return null,
		"startPatrol": func(_t, a): start_patrol(a[0], a[1], a[2]); return null,
		"hangTimes": func(_t, a): return hang_times(J.arg(a, 0)),
		"SPOTS": SPOTS.duplicate(true), "ZA": ZA.duplicate(), "ZB": ZB.duplicate(), "SC": SC,
	}
