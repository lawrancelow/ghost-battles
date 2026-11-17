# 原生改寫：street.js（陽間街／站崗嚇人）——分段做（L3）
# 未完成、未列入 ACTIVE.txt。分段方法：run() 先載轉譯版（jsgen/street.gd）攞齊全部全局，
# 再用原生版逐段覆蓋（轉譯版入面叫 CrUI／DevFx 都係經 J.G 搵，所以覆蓋咗即刻生效），每段對照過先做下一段；
# 全部段落完成之後先拎走轉譯版、加入 ACTIVE.txt。
#   第一段：__stDC、CrUI（蠟筆面板／進度條／手寫字）  ✓
#   第二段：DevFx（設備色框、待機動畫、鬼影現身）  ← 而家
#   第三段：Street 資料、地盤／路線、離線收益 ← 而家
#   第四段：Turf（地盤場景、路人、Bryan 一夥、建設）
extends RefCounted

static var _tr_keep: Array = []

# ---------------- 第一段：__stDC ----------------
static func stDC(c, k, x, y, s, o) -> void:
	var nd = J.G.get("__nat_drawChar")
	if nd != null: J.cl(nd, null, [c, k, x, y, s, o if o != null else {}])
	else: J.mc(J.G.get("ART"), "drawChar", [c, k, x, y, s, o])

# ---------------- 第一段：CrUI ----------------
const CR_COL := {"bone": "217,201,168", "red": "163,48,42", "rust": "192,106,44", "violet": "138,111,176", "gold": "217,164,65"}
static func cr_hs(n: float) -> float:
	var x = sin(n * 91.7 + 13.1) * 43758.5453; return x - floor(x)
# 抖邊多邊形（seed 固定，唔會閃）
static func cr_rough(c, x: float, y: float, w: float, h: float, seed_v: float, j: float) -> void:
	var n = maxi(3, int(J.round((w + h) / 26))); var pts = []; var k = 0
	for i in n: pts.append([x + w * i / n, y, k]); k += 1
	for i in n: pts.append([x + w, y + h * i / n, k]); k += 1
	for i in n: pts.append([x + w - w * i / n, y + h, k]); k += 1
	for i in n: pts.append([x, y + h - h * i / n, k]); k += 1
	c.beginPath()
	for i in pts.size():
		var q = pts[i]; var px = q[0] + (cr_hs(seed_v + q[2]) - 0.5) * j; var py = q[1] + (cr_hs(seed_v + q[2] + 0.5) - 0.5) * j
		if i: c.lineTo(px, py)
		else: c.moveTo(px, py)
	c.closePath()
static func _o(o, k, d = null):
	var v = J.gp(o, k) if o != null else null
	return v if J.t(v) else d
# 面板：深色紙底＋斜線排線＋兩層蠟筆邊
static func cr_panel(c, x: float, y: float, w: float, h: float, o) -> void:
	var seed_v = J.num(_o(o, "seed", x * 7 + y * 3)); var ck = _o(o, "col", "bone"); var col = CR_COL[ck] if CR_COL.has(J.str(ck)) else J.gp(o, "col"); var U = J.num(_o(o, "U", 1.0))
	c.save(); cr_rough(c, x, y, w, h, seed_v, 2.2 * U); c.fillStyle = _o(o, "fill", "rgba(26,18,22,0.9)"); c.fill(); c.save(); c.clip(); c.strokeStyle = "rgba(235,215,185,0.05)"; c.lineWidth = 1
	var k = -h
	while k < w: c.beginPath(); c.moveTo(x + k, y + h); c.lineTo(x + k + h * 0.8, y); c.stroke(); k += 6 * U
	c.restore()
	c.lineJoin = "round"; c.strokeStyle = "rgba(" + J.str(col) + ",0.95)"; c.lineWidth = 2.6 * U; cr_rough(c, x, y, w, h, seed_v + 3, 2.6 * U); c.stroke()
	c.strokeStyle = "rgba(" + J.str(col) + ",0.45)"; c.lineWidth = 1.2 * U; cr_rough(c, x + 1.5 * U, y + 1.5 * U, w - 3 * U, h - 3 * U, seed_v + 9, 2.4 * U); c.stroke(); c.restore()
# 進度條：蠟筆塗色（斜紋）＋粗糙框
static func cr_bar(c, x: float, y: float, w: float, h: float, k: float, col1, col2, U0) -> void:
	var U = J.num(U0) if J.t(U0) else 1.0
	c.save(); cr_rough(c, x, y, w, h, x + y, 1.4 * U); c.fillStyle = "rgba(0,0,0,0.65)"; c.fill()
	if k > 0:
		c.save(); cr_rough(c, x, y, w * minf(1.0, k), h, x + y + 1, 1.2 * U); c.clip(); var g = c.createLinearGradient(x, 0, x + w, 0); g.addColorStop(0, col1); g.addColorStop(1, col2 if J.t(col2) else col1); c.fillStyle = g; c.fillRect(x - 2, y - 2, w + 4, h + 4)
		c.strokeStyle = "rgba(0,0,0,0.25)"; c.lineWidth = 1.2 * U
		var q = x - h
		while q < x + w: c.beginPath(); c.moveTo(q, y + h); c.lineTo(q + h, y); c.stroke(); q += 4 * U
		c.restore()
	c.strokeStyle = "rgba(217,201,168,0.7)"; c.lineWidth = 1.4 * U; cr_rough(c, x, y, w, h, x + y + 5, 1.6 * U); c.stroke(); c.restore()
# 手寫感字：黑描邊＋輕微陰影
static func cr_text(c, s, x: float, y: float, o) -> void:
	c.save(); c.font = _o(o, "font", "bold 12px sans-serif"); c.textAlign = _o(o, "align", "left"); c.lineJoin = "round"; c.lineWidth = J.num(_o(o, "lw", 3.5)); c.strokeStyle = "rgba(8,4,6,0.95)"
	c.strokeText(s, x + 1, y + 1); c.strokeText(s, x, y); c.fillStyle = _o(o, "col", "#eadbbf"); c.fillText(s, x, y); c.restore()

static func mk_crui() -> Dictionary:
	return {
		"panel": func(_t, a): cr_panel(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5)); return null,
		"bar": func(_t, a): cr_bar(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.arg(a, 6), J.arg(a, 7), J.arg(a, 8)); return null,
		"text": func(_t, a): cr_text(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4)); return null,
		"rough": func(_t, a): cr_rough(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.num(J.arg(a, 6))); return null,
		"COL": CR_COL.duplicate(),
	}

# ---------------- 第二段：DevFx（設備色框、待機動畫、鬼由設備現身）----------------
# 注意：網頁版 Math.sin 等別名（const sn = Math.sin）喺轉譯版係 null（J.G.Math 係空）——原生跟網頁版用真正 sin/cos；
# createImageData 冇 → 雜訊畫布係空白；
# shadowBlur／shadowColor／lineDashOffset 寫落 Ctx 冇效果，唔寫。
const FX_COL := {"trap": "255,74,74", "puzzle": "190,116,255", "slow": "64,228,206", "scare": "255,150,46", "aura": "196,228,255", "throw": "255,214,64"}
const FX_HEX := {"trap": "#ff4a4a", "puzzle": "#be74ff", "slow": "#40e4ce", "scare": "#ff962e", "aura": "#c4e4ff", "throw": "#ffd640"}
const FX_KEY := {"trap": ["crack", "box"], "puzzle": ["ring", "screen"], "slow": ["pool", "pond"], "scare": ["locker", "wardrobe"], "aura": ["tv", "tube"], "throw": ["basket", "cupboard"]}
const FX_DUR := 1.25
static var MK = null
static var mx = null
static var NZ = null
static var EM = null
static func sm(k: float) -> float: return 0.0 if k <= 0 else (1.0 if k >= 1 else k * k * (3 - 2 * k))
static func bk(k: float) -> float:
	k = maxf(0.0, minf(1.0, k)); var s = 2.2; return 1 + (s + 1) * pow(k - 1, 3) + s * pow(k - 1, 2)
static func outK(p) -> float:
	if p == null: return 0.0
	var q = J.num(p)
	return 0.0 if q < 0.1 else (sm((q - 0.1) / 0.26) if q < 0.36 else (1.0 if q < 0.7 else (1 - sm((q - 0.7) / 0.24) if q < 0.94 else 0.0)))
static func actK(p) -> float:
	if p == null: return 0.0
	var q = J.num(p)
	return sm(q / 0.12) if q < 0.12 else (1.0 if q < 0.8 else (1 - sm((q - 0.8) / 0.2) if q < 1 else 0.0))
static func fx_hs(n: float) -> float:
	var x = sin(n * 127.1 + 311.7) * 43758.5453; return x - floor(x)
static func fx_mk(W: float, H: float):
	if not J.t(MK): MK = J.S_document_("createElement", ["canvas"]); mx = J.mc(MK, "getContext", ["2d"])
	if J.num(J.gp(MK, "width")) < W + 2 or J.num(J.gp(MK, "height")) < H + 2:
		J.sp(MK, "width", maxf(J.num(J.gp(MK, "width")), W + 2)); J.sp(MK, "height", maxf(J.num(J.gp(MK, "height")), H + 2))
	mx.setTransform(1, 0, 0, 1, 0, 0); mx.globalCompositeOperation = "source-over"; mx.globalAlpha = 1; mx.filter = "none"; mx.clearRect(0, 0, W + 2, H + 2); return mx
static func fx_put(c, W: float, H: float) -> void: c.drawImage(MK, 0, 0, W, H, 0, 0, W, H)
static func fx_noise() -> Array:
	if NZ != null: return NZ
	NZ = []
	for n in 4:
		var cv = J.S_document_("createElement", ["canvas"]); J.sp(cv, "width", 64.0); J.sp(cv, "height", 48.0); var x = J.mc(cv, "getContext", ["2d"])
		var d = J.mc(x, "createImageData", [64.0, 48.0])   # Ctx 冇 → null（轉譯版一樣），迴圈唔行
		var L = J.num(J.gp(J.gp(d, "data"), "length"))
		var i = 0
		while i < L:
			var v = (30 + randf() * 60) if randf() < 0.5 else (170 + randf() * 85); var dd = J.gp(d, "data"); J.sp(dd, i, v); J.sp(dd, i + 1, v); J.sp(dd, i + 2, v + 8); J.sp(dd, i + 3, 255.0); i += 4
		J.mc(x, "putImageData", [d, 0.0, 0.0]); NZ.append(cv)
	return NZ
static func fx_poly(x, P: Array, W: float, H: float) -> void:
	x.beginPath()
	for j in P.size():
		if j: x.lineTo(P[j][0] * W, P[j][1] * H)
		else: x.moveTo(P[j][0] * W, P[j][1] * H)
	x.closePath()
static func fx_piece(x, im, W: float, H: float, r: Array, ax: float, ay: float, sx: float, sy: float, rot: float, dx: float, dy: float) -> void:
	var u0 = r[0]; var v0 = r[1]; var u1 = r[2]; var v1 = r[3]
	x.save(); x.translate(ax * W + dx, ay * H + dy)
	if rot: x.rotate(rot)
	x.scale(sx, sy); x.translate(-ax * W, -ay * H)
	x.drawImage(im, u0 * W, v0 * H, (u1 - u0) * W, (v1 - v0) * H, u0 * W, v0 * H, (u1 - u0) * W, (v1 - v0) * H); x.restore()
static func fx_baseExcept(x, im, W: float, H: float, rects: Array) -> void:
	x.save(); x.beginPath(); x.rect(0, 0, W, H)
	for r in rects: x.rect(r[0] * W, r[1] * H, (r[2] - r[0]) * W, (r[3] - r[1]) * H)
	x.clip(); x.drawImage(im, 0, 0); x.restore()
static func fx_stripsH(x, im, W: float, H: float, v0: float, v1: float, n: int, fn: Callable) -> void:
	var y0 = v0 * H; var hh = (v1 - v0) * H / n
	x.drawImage(im, 0, 0, W, y0, 0, 0, W, y0)
	if v1 < 1: x.drawImage(im, 0, v1 * H, W, H - v1 * H, 0, v1 * H, W, H - v1 * H)
	for j in n:
		var sy = y0 + j * hh; x.drawImage(im, 0, sy, W, hh, fn.call((sy + hh / 2) / H), sy, W, hh + 0.6)
static func fx_stripsV(x, im, W: float, H: float, n: int, fn: Callable) -> void:
	var ww = W / n
	for j in n:
		var sx = j * ww; x.drawImage(im, sx, 0, ww, H, sx, fn.call((sx + ww / 2) / W), ww + 0.6, H)
static func fx_blob(c, x: float, y: float, r: float, col: String, a: float) -> void:
	if a <= 0.004: return
	var g = c.createRadialGradient(x, y, 0, x, y, r); g.addColorStop(0, "rgba(" + col + "," + J.str(a) + ")"); g.addColorStop(1, "rgba(" + col + ",0)"); c.fillStyle = g; c.beginPath(); c.arc(x, y, r, 0, 7); c.fill()
# 通用鬼影（冇加持時用）
static func fx_shade(c, x: float, y: float, Hh: float, o: Dictionary) -> void:
	c.save(); c.globalAlpha *= 1.0 if o.get("alpha") == null else maxf(0.0, minf(1.0, J.num(o.alpha))); c.translate(x, y)
	if J.t(o.get("rot")): c.translate(0, -Hh * 0.35); c.rotate(J.num(o.rot)); c.translate(0, Hh * 0.35)
	if J.t(o.get("flip")): c.scale(-1, 1)
	var t = J.num(o.get("t")) if J.t(o.get("t")) else 0.0; var w = Hh * 0.34; var g = c.createLinearGradient(0, -Hh, 0, 0); g.addColorStop(0, "rgba(14,10,26,0.96)"); g.addColorStop(0.65, "rgba(22,14,38,0.86)"); g.addColorStop(1, "rgba(30,20,52,0)")
	c.fillStyle = g; c.beginPath(); c.moveTo(-w * 0.42, -Hh * 0.66); c.quadraticCurveTo(-w * 1.0, -Hh * 0.32, -w * 0.72 + sin(t * 5) * w * 0.08, -Hh * 0.02)
	for j in range(1, 5): c.lineTo(-w * 0.72 + j * w * 0.36, -Hh * 0.02 + sin(t * 6 + j * 1.7) * Hh * 0.05 - (j % 2) * Hh * 0.06)
	c.quadraticCurveTo(w * 1.0, -Hh * 0.32, w * 0.42, -Hh * 0.66); c.closePath(); c.fill(); c.strokeStyle = "rgba(170,140,235,0.55)"; c.lineWidth = maxf(1.0, Hh * 0.018); c.stroke()
	c.fillStyle = "rgba(14,10,26,0.97)"; c.beginPath(); c.ellipse(0, -Hh * 0.78, w * 0.44, Hh * 0.16, 0, 0, 7); c.fill(); c.stroke(); fx_blob(c, 0, -Hh * 0.62, w * 0.9, "120,90,200", 0.12)
	var rc = J.num(o.get("reach")) if J.t(o.get("reach")) else 0.0
	if rc > 0:
		c.strokeStyle = "rgba(16,11,30,0.93)"; c.lineWidth = Hh * 0.075; c.lineCap = "round"
		for s in [-1.0, 1.0]: c.beginPath(); c.moveTo(s * w * 0.36, -Hh * 0.6); c.quadraticCurveTo(s * w * (0.8 + rc * 0.3), -Hh * (0.62 + rc * 0.12), s * w * (0.6 + rc * 0.6), -Hh * (0.46 + rc * 0.36 + sin(t * 9 + s) * 0.03)); c.stroke()
	var bl = 0.15 if sin(t * 1.3 + x) > 0.97 else 1.0; fx_blob(c, -w * 0.16, -Hh * 0.79, Hh * 0.07, "160,225,255", 0.5)
	fx_blob(c, w * 0.16, -Hh * 0.79, Hh * 0.07, "160,225,255", 0.5); c.fillStyle = "rgba(225,246,255,0.98)"
	for s in [-1.0, 1.0]: c.beginPath(); c.ellipse(s * w * 0.16, -Hh * 0.79, w * 0.075, Hh * 0.022 * bl, 0, 0, 7); c.fill()
	c.restore()
static func fx_vx(k):
	var S = J.G.get("SPR"); var im = J.gp(S, k) if S != null else null
	return im if (J.t(im) and J.t(J.gp(im, "naturalWidth"))) else null
static func fx_vxDraw(c, im, x: float, y: float, Hh: float, o) -> void:
	if not J.t(im): return
	if o == null: o = {}
	var a = 1.0 if o.get("alpha") == null else J.num(o.alpha)
	if a <= 0.01: return
	var h = Hh; var w = h * J.num(J.gp(im, "naturalWidth")) / J.num(J.gp(im, "naturalHeight"))
	c.save(); c.globalAlpha *= minf(1.0, a); c.translate(x, y)
	if J.t(o.get("rot")): c.rotate(J.num(o.rot))
	c.scale((-1.0 if J.t(o.get("flip")) else 1.0) * (J.num(o.sx) if J.t(o.get("sx")) else 1.0), J.num(o.sy) if J.t(o.get("sy")) else 1.0)
	c.drawImage(im, -w * (0.5 if o.get("ax") == null else J.num(o.ax)), -h * (1.0 if o.get("ay") == null else J.num(o.ay)), w, h); c.restore()
static func fx_shadeArt(c, x: float, y: float, Hh: float, o: Dictionary, p0) -> bool:
	var A = fx_vx("vfx_ghost_rise"); var B = fx_vx("vfx_ghost_lunge"); var C = fx_vx("vfx_ghost_smoke")
	if not J.t(A) or not J.t(B) or not J.t(C): return false
	var p = 0.5 if p0 == null else J.num(p0)
	var al = 1.0 if o.get("alpha") == null else J.num(o.alpha); var fl = J.t(o.get("flip")); var H2 = Hh * 1.12; var t = J.num(o.get("t")) if J.t(o.get("t")) else 0.0
	var wA = 1.0 if p < 0.36 else (1 - sm((p - 0.36) / 0.06) if p < 0.42 else 0.0)
	var wB = 0.0 if p < 0.36 else (sm((p - 0.36) / 0.06) if p < 0.42 else (1.0 if p < 0.68 else (1 - sm((p - 0.68) / 0.06) if p < 0.74 else 0.0)))
	var wC = 0.0 if p < 0.68 else (sm((p - 0.68) / 0.06) if p < 0.74 else 1.0)
	var rise = sm(minf(1.0, p / 0.3)); var lun = sm(maxf(0.0, minf(1.0, (p - 0.36) / 0.3))); var fade = 1.0 if p < 0.74 else 1 - sm((p - 0.74) / 0.26)
	var wob = sin(t * 7) * 0.03; var sg = 1.0 if fl else -1.0
	if wA > 0: fx_vxDraw(c, A, x, y, H2 * (0.55 + 0.45 * rise), {"alpha": al * wA, "sx": 0.85 + 0.15 * rise, "rot": wob, "flip": fl})
	if wB > 0: fx_vxDraw(c, B, x + sg * Hh * 0.18 * lun, y - Hh * 0.05 * lun, H2 * (1 + 0.14 * lun), {"alpha": al * wB, "rot": sg * 0.1 * lun + wob, "flip": fl})
	if wC > 0: fx_vxDraw(c, C, x + sg * Hh * 0.2, y - Hh * 0.18 * (1 - fade), H2 * (1 + 0.25 * (1 - fade)), {"alpha": al * wC * fade, "flip": fl})
	return true
# 1. 類型色框
static func fx_frame(c, role, x0: float, y0: float, w: float, h: float, t: float, i: float, trig: float, U: float) -> void:
	var col = FX_COL.get(J.str(role))
	if col == null: return
	var br = minf(1.6, 0.62 + 0.22 * sin(t * 2.3 + i * 1.3) + trig * 0.95); var pd = 4 * U
	var R = [x0 - pd, y0 - pd, w + pd * 2, h + pd * 2, minf(w, h) * 0.2]
	c.save(); var cx = x0 + w / 2; var cy = y0 + h * 0.66; var g = c.createRadialGradient(cx, cy, 2, cx, cy, w * 0.66)
	g.addColorStop(0, "rgba(" + col + "," + J.str(0.26 * br) + ")"); g.addColorStop(1, "rgba(" + col + ",0)"); c.fillStyle = g; c.beginPath(); c.ellipse(cx, cy, w * 0.66, h * 0.4, 0, 0, 7); c.fill()
	_rr(c, R); c.fillStyle = "rgba(" + col + "," + J.str(0.08 * br) + ")"; c.fill()
	for la in [[10 * U, 0.09], [5.5 * U, 0.2], [2.2 * U, 0.78]]: c.strokeStyle = "rgba(" + col + "," + J.str(minf(1.0, la[1] * br)) + ")"; c.lineWidth = la[0]; _rr(c, R); c.stroke()
	if trig > 0.05: c.strokeStyle = "rgba(255,255,255," + J.str(0.7 * trig) + ")"; c.lineWidth = 1.5 * U; _rr(c, R); c.stroke()
	c.restore()
static func _rr(c, R: Array) -> void: c.beginPath(); c.roundRect(R[0], R[1], R[2], R[3], R[4])   # Ctx 有 roundRect（轉譯版 if (c.roundRect) 係真）
# 現身計時（唔寫入存檔）
static func fx_emerge(p, t: float):
	if EM == null: EM = JSMap.new()
	var s = EM._js_get([p])
	if s == null: s = {"fx": null, "t0": -9.0}; EM._js_set([p, s])
	var pf = J.gp(p, "fx")
	if J.t(pf) and not J.seq(pf, s.fx):
		s["fx"] = pf
		if t - J.num(s.t0) > FX_DUR * 0.85: s["t0"] = t
	var k = (t - J.num(s.t0)) / FX_DUR
	return k if (k >= 0 and k < 1) else null
static func fx_trigOf(p, t: float) -> float:
	var k = fx_emerge(p, t)
	return maxf(maxf((1 - k / 0.4) if (k != null and k < 0.4) else 0.0, 0.6 if J.t(J.gp(p, "win")) else 0.0), 0.4 if J.gp(p, "anim") != null else 0.0)

# 2＋3. 設備待機動態＋鬼現身；E = { p:現身進度 0~1 或 null, k:加持鬼 key 或 null, sc:鬼嘅世界縮放 }
static func _fxG(Z: Dictionary, lx: float, ly: float, s: float, op0: Dictionary) -> void:
	var E = Z.E
	if not J.t(E): return
	var op = {"t": Z.t, "alpha": 1.0}; op.merge(op0, true)
	if J.num(op.alpha) <= 0.01: return
	var c = Z.c; var ART = J.G.get("ART")
	if J.t(J.gp(E, "k")) and ART != null and J.t(J.gp(ART, "drawChar")):
		var o2 = {"shadow": false}; o2.merge(op, true)
		J.cl(J.G.get("__stDC"), null, [c, J.gp(E, "k"), lx, ly, J.num(J.gp(E, "sc")) * s / Z.f * 0.78, o2]); return
	if not fx_shadeArt(c, lx, ly, Z.gh * s, op, Z.p): fx_shade(c, lx, ly, Z.gh * s, op)
static func _jt(rat: float) -> float: return (randf() - 0.5) * 1.6 * rat if rat != 0 else 0.0
static func fx_draw(c, im, role, sz, dx: float, dy: float, dw: float, dh: float, t: float, i: float, E) -> void:
	var W = J.num(J.gp(im, "naturalWidth")); var H = J.num(J.gp(im, "naturalHeight")); var f = dw / W
	var kl = FX_KEY.get(J.str(role), []); var key = kl[1 if J.seq(sz, 2.0) else 0] if kl.size() else null; var sd = i * 1.7 + (0.9 if J.seq(sz, 2.0) else 0.0)
	if key == null: c.drawImage(im, dx, dy, dw, dh); return
	var p = J.gp(E, "p") if (J.t(E) and J.gp(E, "p") != null) else null; var pn = J.num(p) if p != null else 0.0
	var o = outK(p); var a = actK(p); var gh = 52 * J.num(J.gp(E, "sc")) / f if J.t(E) else H * 0.8
	var Z = {"c": c, "E": E, "p": p, "f": f, "gh": gh, "t": t}
	c.save(); c.translate(dx, dy); c.scale(f, f)
	var x
	match key:
		"crack":
			x = fx_mk(W, H); x.drawImage(im, 0, 0)
			var grip = 1 + 0.035 * (0.5 + 0.5 * sin(t * 2.4 + sd)) + (0.03 * absf(sin(t * 22)) if sin(t * 0.9 + sd) > 0.8 else 0.0) + a * 0.08
			fx_piece(x, im, W, H, [0.44, 0.36, 0.76, 0.64], 0.47, 0.6, grip, grip, -0.03 * (grip - 1) * 10, 0, 0); fx_put(c, W, H)
			c.save(); c.globalCompositeOperation = "lighter"; fx_blob(c, 0.55 * W, 0.47 * H, 0.2 * W, "255,40,30", 0.1 + 0.06 * sin(t * 3 + sd) + a * 0.35); c.restore()
			for j in 4:
				var ph = fmod(t * 0.32 + j / 4.0 + fx_hs(sd + j) * 0.2, 1.0); fx_blob(c, (0.52 + sin(ph * 5 + j) * 0.05) * W, (0.44 - ph * 0.42) * H, (0.05 + ph * 0.09) * W, "190,190,200", (1 - ph) * ph * 4 * 0.28)
			for j in 2:
				var an = t * 0.55 + j * 3.1 + sd; var lift = (0.5 + 0.5 * sin(t * 1.7 + j * 2)) * 0.14 + a * 0.2
				c.save(); c.translate((0.52 + cos(an) * 0.34) * W, (0.52 + sin(an) * 0.18 - lift) * H); c.rotate(sin(t * 2.1 + j) * 0.8); c.scale(1, 0.55 + 0.45 * absf(cos(t * 3 + j)))
				c.fillStyle = "rgba(216,196,150,0.92)"; c.fillRect(-0.05 * W, -0.028 * H, 0.1 * W, 0.056 * H); c.fillStyle = "rgba(170,40,32,0.85)"; c.fillRect(-0.016 * W, -0.016 * H, 0.032 * W, 0.032 * H); c.restore()
			if o > 0:
				var ly = 0.56 * H; c.save(); c.beginPath(); c.rect(-W, -H * 4, W * 3, H * 4 + ly); c.clip()
				_fxG(Z, 0.54 * W + sin(t * 7) * 0.01 * W, ly + gh * (1 - o) * 0.95, 1, {"pose": "strike" if o > 0.85 else "windup", "pt": o, "alpha": minf(1.0, o * 2.5), "reach": o, "rot": sin(t * 6) * 0.05 * o, "atk": o > 0.8}); c.restore()
				for j in 6:
					var k2 = fmod(pn * 3 + j / 6.0, 1.0); c.fillStyle = "rgba(150,140,130," + J.str((1 - k2) * o) + ")"; c.fillRect((0.4 + fx_hs(j) * 0.3) * W + sin(j * 3) * k2 * 30, ly - k2 * 0.3 * H, 4, 4)
		"box":
			var LID = [[0.03, 0.29], [0.13, 0.17], [0.86, 0.04], [0.92, 0.13], [0.44, 0.33], [0.4, 0.42], [0.05, 0.38]]
			var bump = pow(maxf(0.0, sin(t * 1.6 + sd)), 8); var lift = bump * 0.03 * H + a * 0.2 * H + (sin(pn * 40) * (1 - pn) * 0.02 * H if a > 0 else 0.0); var rot = -(bump * 0.04 + a * 0.22)
			x = fx_mk(W, H); x.save(); fx_poly(x, LID, W, H); x.rect(W, 0, -W, H); x.clip(); x.drawImage(im, 0, 0); x.restore()
			x.save(); fx_poly(x, LID, W, H); x.clip(); fx_poly(x, [[0.1, 0.3], [0.44, 0.31], [0.42, 0.43], [0.09, 0.41]], W, H); x.fillStyle = "rgba(10,12,9,1)"; x.fill(); x.restore()
			var EY = [[0.39, 0.47, 0.45, 0.45], [0.53, 0.5, 0.59, 0.49], [0.6, 0.35, 0.66, 0.36], [0.69, 0.44, 0.75, 0.45]]
			for j in EY.size():
				var e = EY[j]; var bl = sin(t * 0.8 + j * 2.3 + sd) > 0.93 or (a > 0 and pn < 0.15)
				if bl:
					x.fillStyle = "rgba(8,9,7,0.88)"
					for k2 in [0, 2]: x.beginPath(); x.ellipse(e[k2] * W, e[k2 + 1] * H, 0.022 * W, 0.016 * H, 0, 0, 7); x.fill()
			x.save(); fx_poly(x, LID, W, H); x.restore()
			x.save(); x.translate(0.4 * W, 0.4 * H - lift); x.rotate(rot); x.translate(-0.4 * W, -0.4 * H); fx_poly(x, LID, W, H); x.clip(); x.drawImage(im, 0, 0); x.restore(); fx_put(c, W, H)
			c.save(); c.globalCompositeOperation = "lighter"
			for j in EY.size():
				if sin(t * 0.8 + j * 2.3 + sd) > 0.93: continue
				var e = EY[j]; var gl = 0.25 + 0.15 * sin(t * 3 + j); fx_blob(c, e[0] * W, e[1] * H, 0.035 * W, "210,255,150", gl); fx_blob(c, e[2] * W, e[3] * H, 0.035 * W, "210,255,150", gl)
			c.restore()
			if o > 0:
				c.save(); c.beginPath(); c.moveTo(-W, -4 * H); c.lineTo(2 * W, -4 * H); c.lineTo(2 * W, 0.3 * H); c.lineTo(0.95 * W, 0.3 * H); c.lineTo(0.68 * W, 0.56 * H); c.lineTo(0.05 * W, 0.45 * H); c.lineTo(-W, 0.45 * H); c.closePath(); c.clip()
				var sp = bk(minf(1.0, o * 1.1)); _fxG(Z, 0.56 * W, 0.56 * H + gh * (1 - sp) * 0.9, 1, {"pose": "strike", "pt": minf(1.0, o), "alpha": minf(1.0, o * 3), "reach": o, "rot": sin(t * 9) * 0.06 * o, "atk": true}); c.restore()
		"ring":
			x = fx_mk(W, H); fx_stripsV(x, im, W, H, 18, func(u): return sin(t * 2.4 - u * 6.283 + sd) * 0.012 * H * (1 + a)); fx_put(c, W, H)
			c.save(); c.strokeStyle = "rgba(200,150,255," + J.str(0.22 + 0.1 * sin(t * 2) + a * 0.4) + ")"; c.lineWidth = 2; c.setLineDash([7, 9]); c.beginPath(); c.ellipse(0.5 * W, 0.56 * H, 0.27 * W, 0.15 * H, 0, 0, 7); c.stroke(); c.restore()
			for j in 3:
				var an = t * 0.9 + j * 2.094 + sd; c.fillStyle = "rgba(232,214,180," + J.str(0.55 + 0.3 * sin(an * 2)) + ")"; c.save(); c.translate((0.5 + cos(an) * 0.32) * W, (0.52 + sin(an) * 0.2 - 0.06) * H); c.rotate(an * 2); c.fillRect(-3, -2, 6, 4); c.restore()
			if p != null:
				var fl = maxf(0.0, 1 - absf(pn - 0.12) / 0.12); c.save(); c.globalCompositeOperation = "lighter"; fx_blob(c, 0.5 * W, 0.72 * H, 0.16 * W, "255,240,255", fl * 0.7); c.restore()
				for j in 8:
					var k2 = minf(1.0, pn * 2.2); var an = j * 0.785; c.fillStyle = "rgba(236,218,184," + J.str(1 - k2) + ")"; c.fillRect(0.5 * W + cos(an) * k2 * 0.3 * W, 0.72 * H + sin(an) * k2 * 0.2 * H - k2 * 0.1 * H, 5, 4)
				_fxG(Z, 0.5 * W, 0.93 * H, 0.55 + 0.45 * o, {"pose": "strike" if o > 0.7 else "cast", "pt": o, "alpha": minf(1.0, o * 2), "reach": o, "rot": sin(t * 8) * 0.04})
		"screen":
			if o > 0:
				var lean = sin(minf(1.0, o) * 1.57); _fxG(Z, 0.36 * W + lean * 0.06 * W, minf(0.62 * H, 0.06 * H + gh * 0.62) + gh * (1 - o) * 0.85, 1, {"pose": "cast", "pt": o, "alpha": 1.0, "rot": -0.22 * lean, "reach": o * 0.6})
			x = fx_mk(W, H); fx_stripsH(x, im, W, H, 0, 0.98, 14, func(v): return sin(t * 1.5 + sd) * (1 - v) * (0.012 + a * 0.02) * W)
			var sx = (fmod(t * 0.18 + fx_hs(sd), 1.6) - 0.3) * W
			x.save(); x.globalCompositeOperation = "source-atop"
			var g = x.createRadialGradient(sx, 0.45 * H, 2, sx, 0.45 * H, 0.16 * W); g.addColorStop(0, "rgba(10,6,16,0.55)"); g.addColorStop(1, "rgba(10,6,16,0)"); x.fillStyle = g; x.beginPath(); x.ellipse(sx, 0.45 * H, 0.11 * W, 0.3 * H, 0, 0, 7); x.fill(); x.fillStyle = "rgba(10,6,16,0.45)"; x.beginPath(); x.arc(sx, 0.2 * H, 0.045 * W, 0, 7); x.fill()
			x.restore(); fx_put(c, W, H)
		"pool", "pond":
			var pool = key == "pool"; var HA = [[0.28, 0, 0.5, 0.27], [0.64, 0, 0.88, 0.32]] if pool else null
			x = fx_mk(W, H)
			if pool:
				x.save(); x.beginPath(); x.rect(0, 0, W, H)
				for r in HA: x.rect(r[0] * W, r[1] * H, (r[2] - r[0]) * W, (r[3] - r[1]) * H)
				x.clip(); fx_stripsH(x, im, W, H, 0.3, 1, 16, func(v): return sin(t * 2.2 + v * 34 + sd) * 0.006 * W); x.restore()
				for j in HA.size():
					var r = HA[j]; var ph = fmod(t * 0.22 + j * 0.5 + fx_hs(sd + j), 1.0)
					var dn = (0.0 if ph < 0.5 else (sm((ph - 0.5) / 0.15) if ph < 0.65 else (1.0 if ph < 0.85 else 1 - sm((ph - 0.85) / 0.15)))) * (0.75 + a * 0.25)
					x.save(); x.beginPath(); x.rect(r[0] * W, -H, (r[2] - r[0]) * W, H + r[3] * H); x.clip(); x.drawImage(im, r[0] * W, 0, (r[2] - r[0]) * W, r[3] * H + 0.06 * H, r[0] * W + sin(t * 3 + j) * 1.2, dn * r[3] * H * 1.05, (r[2] - r[0]) * W, r[3] * H + 0.06 * H); x.restore()
			else:
				fx_stripsH(x, im, W, H, 0.05, 0.98, 18, func(v): return sin(t * 2 + v * 30 + sd) * 0.006 * W)
				fx_piece(x, im, W, H, [0.56, 0.2, 0.76, 0.46], 0.68, 0.44, 1 + 0.04 * (0.5 + 0.5 * sin(t * 2.2 + sd)), 1 + 0.05 * (0.5 + 0.5 * sin(t * 2.2 + sd)), sin(t * 1.4) * 0.03, 0, 0)
				fx_piece(x, im, W, H, [0.32, 0.46, 0.52, 0.72], 0.4, 0.7, 1 + 0.04 * (0.5 + 0.5 * sin(t * 2.6 + sd + 2)), 1 + 0.05 * (0.5 + 0.5 * sin(t * 2.6 + sd + 2)), sin(t * 1.1 + 1) * 0.03, 0, 0)
			fx_put(c, W, H)
			var RP = [[0.39, 0.3], [0.76, 0.35], [0.55, 0.62]] if pool else [[0.68, 0.44], [0.42, 0.7], [0.62, 0.62]]
			c.save()
			for j in RP.size():
				var q = RP[j]
				for n in 2:
					var ph = fmod(t * 0.6 + j * 0.37 + n * 0.5, 1.0); var rr = 0.03 + ph * 0.12; c.strokeStyle = "rgba(150,230,225," + J.str(0.45 * (1 - ph)) + ")"; c.lineWidth = 1.5; c.beginPath(); c.ellipse(q[0] * W, q[1] * H, rr * W, rr * W * 0.38, 0, 0, 7); c.stroke()
			c.restore()
			if p != null:
				var cx2 = (0.55 if pool else 0.5) * W; var ly = (0.6 if pool else 0.62) * H
				for n in 3:
					var ph = fmod(minf(1.0, pn * 1.5 + n * 0.2), 1.0); c.strokeStyle = "rgba(160,240,235," + J.str(0.8 * (1 - ph)) + ")"; c.lineWidth = 2.5; c.beginPath(); c.ellipse(cx2, ly, (0.06 + ph * 0.3) * W, (0.06 + ph * 0.3) * W * 0.36, 0, 0, 7); c.stroke()
				if o > 0:
					c.save(); c.beginPath(); c.rect(-W, -4 * H, 3 * W, 4 * H + ly); c.clip(); _fxG(Z, cx2, ly + gh * (1 - o) * 0.95, 1, {"pose": "strike" if o > 0.8 else "cast", "pt": o, "alpha": minf(1.0, o * 2), "reach": o, "rot": sin(t * 4) * 0.05}); c.restore()
					for j in 7:
						var k2 = fmod(pn * 2.5 + j / 7.0, 1.0); c.fillStyle = "rgba(170,235,230," + J.str((1 - k2) * o) + ")"; c.beginPath(); c.arc(cx2 + (fx_hs(j + 3) - 0.5) * 0.3 * W, ly - sin(k2 * 3.14) * 0.22 * H, 2.5, 0, 7); c.fill()
		"locker":
			var DR = [0.585, 0.06, 0.84, 0.955]; var hx = 0.84 * W; var idle = 0.06 + 0.07 * (0.5 + 0.5 * sin(t * 0.9 + sd)) + (0.12 if sin(t * 0.37 + sd) > 0.85 else 0.0)
			var op = minf(0.9, idle + a * 0.85 + (sin(pn * 60) * 0.05 if (a > 0 and pn < 0.25) else 0.0))
			x = fx_mk(W, H); fx_baseExcept(x, im, W, H, [DR])
			x.fillStyle = "rgb(8,7,9)"; x.fillRect(DR[0] * W - 1, (DR[1] + 0.025) * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1] - 0.05) * H)
			var ex = 0.62 * W + (op - 0.1) * 0.06 * W; var ey = 0.41 * H; var bl = 0.15 if sin(t * 0.7 + sd) > 0.95 else 1.0; var lk = sin(t * 0.9 + sd * 2) * 0.012 * W
			if o <= 0:
				x.fillStyle = "rgba(235,225,200,0.95)"; x.beginPath(); x.ellipse(ex, ey, 0.03 * W, 0.016 * H * bl, 0, 0, 7); x.fill(); x.fillStyle = "rgb(30,10,8)"; x.beginPath(); x.arc(ex + lk, ey, 0.012 * W * minf(1.0, bl * 2), 0, 7); x.fill(); x.fillStyle = "rgba(255,90,60,0.9)"; x.beginPath(); x.arc(ex + lk, ey, 0.005 * W, 0, 7); x.fill()
			fx_put(c, W, H)
			if o > 0:
				var fall = sm(minf(1.0, o * 1.2)); _fxG(Z, 0.56 * W + fall * 0.05 * W, 0.93 * H + fall * 0.05 * H, 0.85 + 0.2 * o, {"pose": "strike" if o > 0.6 else "windup", "pt": o, "alpha": minf(1.0, o * 3), "rot": -fall * 0.3 + sin(t * 10) * 0.04, "reach": o, "atk": true})
			c.save(); c.translate(hx, 0); c.scale(1 - op, 1); c.translate(-hx, 0); c.drawImage(im, DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H, DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H)
			c.fillStyle = "rgba(0,0,0," + J.str(op * 0.45) + ")"; c.fillRect(DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H); c.restore()
		"wardrobe":
			var DR = [0.495, 0.135, 0.805, 0.83]; var hx = 0.805 * W; var shk = (sin(t * 40) * 0.8 if sin(t * 0.6 + sd) > 0.82 else 0.0) + (sin(t * 50) * 1.5 if (a > 0 and pn < 0.2) else 0.0)
			var op = sm(minf(1.0, a * 1.0)) * 0.55 * minf(1.0, pn * 2.2)
			x = fx_mk(W, H)
			if op > 0.01: fx_baseExcept(x, im, W, H, [DR]); x.fillStyle = "rgb(12,7,5)"; x.fillRect(DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H)
			else: x.drawImage(im, 0, 0)
			fx_put(c, W, H)
			if o > 0: c.save(); c.beginPath(); c.rect(DR[0] * W, -2 * H, (DR[2] - DR[0]) * W, 2 * H + DR[3] * H); c.clip(); _fxG(Z, 0.6 * W, 0.9 * H, 1, {"pose": "cast", "pt": o, "alpha": 1.0, "rot": -0.15 * o, "reach": o * 0.7, "flip": true}); c.restore()
			c.save(); c.translate(hx + shk, 0); c.scale(1 - op, 1); c.translate(-hx, 0); c.drawImage(im, DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H, DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H)
			if op > 0.01: c.fillStyle = "rgba(0,0,0," + J.str(op * 0.4) + ")"; c.fillRect(DR[0] * W, DR[1] * H, (DR[2] - DR[0]) * W, (DR[3] - DR[1]) * H)
			c.restore()
			var gl = 0.35 + 0.3 * (0.5 + 0.5 * sin(t * 2.2 + sd)) + a * 0.5; c.save(); c.globalCompositeOperation = "lighter"; c.lineCap = "round"
			var CL = [[[0.4, 0.27], [0.25, 0.55]], [[0.76, 0.25], [0.6, 0.53]]]
			for j in CL.size():
				if j == 1 and op > 0.05: continue
				var L = CL[j]
				for n in 3:
					var ox = (n - 1) * 0.045 * W; var sk = shk if j else 0.0; c.strokeStyle = "rgba(255," + J.str(110 + n * 20) + ",60," + J.str(gl * 0.55) + ")"; c.lineWidth = 5; c.beginPath(); c.moveTo(L[0][0] * W + ox + sk, L[0][1] * H + n * 4); c.lineTo(L[1][0] * W + ox + sk, L[1][1] * H + n * 4); c.stroke(); c.strokeStyle = "rgba(255,200,150," + J.str(gl * 0.5) + ")"; c.lineWidth = 1.5; c.stroke()
			c.restore()
		"tv":
			var SC = [0.17, 0.33, 0.67, 0.73]; var NZs = fx_noise(); var nz = NZs[int(floor(t * 18)) % 4]; var face = (1 if sin(t * 0.45 + sd) > 0.94 else 0) + (1 if (p != null and pn < 0.12) else 0)
			x = fx_mk(W, H); x.drawImage(im, 0, 0)
			x.save(); x.beginPath(); x.rect(SC[0] * W, SC[1] * H, (SC[2] - SC[0]) * W, (SC[3] - SC[1]) * H); x.clip()
			x.globalAlpha = 0.42 + a * 0.4; x.drawImage(nz, fmod(t * 37, 1.0) * -10, fmod(t * 53, 1.0) * -8, (SC[2] - SC[0]) * W + 12, (SC[3] - SC[1]) * H + 10); x.globalAlpha = 1; x.translate(SC[0] * W, SC[1] * H)
			var by = fmod(t * 0.5 + sd, 1.0) * (SC[3] - SC[1]) * H; x.fillStyle = "rgba(220,240,255,0.16)"; x.fillRect(0, by, W, 0.04 * H)
			if face:
				var fx = (SC[2] - SC[0]) * W / 2 + sin(t * 40) * 2; var fy = (SC[3] - SC[1]) * H * 0.48; x.globalAlpha = 0.55; x.fillStyle = "rgba(225,232,236,1)"; x.beginPath(); x.ellipse(fx, fy, 0.09 * W, 0.12 * H, 0, 0, 7); x.fill(); x.fillStyle = "rgba(10,10,14,1)"
				x.beginPath(); x.ellipse(fx - 0.035 * W, fy - 0.02 * H, 0.016 * W, 0.022 * H, 0, 0, 7); x.ellipse(fx + 0.035 * W, fy - 0.02 * H, 0.016 * W, 0.022 * H, 0, 0, 7); x.fill(); x.beginPath(); x.ellipse(fx, fy + 0.06 * H, 0.02 * W, 0.03 * H, 0, 0, 7); x.fill()
			x.restore(); fx_put(c, W, H)
			c.save(); c.globalCompositeOperation = "lighter"; fx_blob(c, 0.42 * W, 0.53 * H, 0.32 * W, "170,210,255", 0.08 + 0.05 * sin(t * 17) + a * 0.2); c.restore()
			for j in 3:
				var ph = fmod(t * 0.25 + j / 3.0 + fx_hs(sd + j) * 0.3, 1.0); fx_blob(c, (0.5 + sin(ph * 4 + j) * 0.12) * W, (0.8 + ph * 0.12) * H, (0.06 + ph * 0.06) * W, "200,240,240", (1 - ph) * 0.22)
			if o > 0:
				var inS = pn < 0.42; var q = minf(1.0, pn / 0.42) if pn < 0.42 else 1.0
				c.save()
				if inS: c.beginPath(); c.rect(SC[0] * W, SC[1] * H, (SC[2] - SC[0]) * W, (SC[3] - SC[1]) * H); c.clip()
				var s2 = (0.3 + 0.12 * q) if inS else (0.42 + 0.58 * minf(1.0, (pn - 0.42) / 0.2) * o); var gx = 0.42 * W; var gy = (SC[3] - 0.02) * H if inS else SC[3] * H + (0.24 * H) * minf(1.0, (pn - 0.42) / 0.2) * o
				_fxG(Z, gx, gy, s2, {"pose": "cast" if inS else "strike", "pt": o, "alpha": q if inS else maxf(0.15, o), "rot": 0.0 if inS else 0.5 * o, "reach": o, "atk": not inS}); c.restore()
		"tube":
			var f1 = ((0.25 if int(floor(t * 14)) % 2 else 1.0) if sin(t * 0.7 + sd) > 0.9 else 1.0)
			var f2 = 0.04 if (p != null and pn > 0.06 and pn < 0.34) else (((0.3 if int(floor(t * 18)) % 2 else 1.0)) if (p != null and pn < 0.5) else 1.0)
			var fl = f1 * f2
			x = fx_mk(W, H); fx_stripsH(x, im, W, H, 0.44, 1, 14, func(v): return sin(t * 1.6 - v * 9 + sd) * 0.012 * W * (v - 0.4) * 2)
			if fl < 1: x.save(); x.globalCompositeOperation = "source-atop"; x.fillStyle = "rgba(8,10,14," + J.str((1 - fl) * 0.8) + ")"; x.fillRect(0.18 * W, 0.17 * H, 0.74 * W, 0.27 * H); x.restore()
			fx_put(c, W, H)
			c.save(); c.globalCompositeOperation = "lighter"
			for ty in [0.245, 0.37]: fx_blob(c, 0.55 * W, ty * H, 0.36 * W, "200,255,240", 0.13 * fl + 0.03 * sin(t * 30) * fl)
			c.restore()
			for j in 4:
				var ph = fmod(t * 0.2 + j / 4.0 + fx_hs(sd + j) * 0.2, 1.0); fx_blob(c, (0.3 + j * 0.15 + sin(ph * 3 + j) * 0.06) * W, (0.48 + ph * 0.45) * H, (0.07 + ph * 0.07) * W, "210,245,240", (1 - ph) * ph * 4 * 0.2)
			if p != null and pn > 0.06 and pn < 0.34: c.save(); c.globalAlpha = 0.55 * minf(1.0, (pn - 0.06) * 10); fx_blob(c, 0.5 * W, 0.6 * H, 0.8 * W, "0,0,6", 0.7); c.restore()
			if o > 0: _fxG(Z, 0.52 * W, 1.04 * H, 1, {"pose": "strike" if o > 0.7 else "cast", "pt": o, "alpha": (0.35 if pn < 0.34 else 1.0) * minf(1.0, o * 1.6) * (0.5 if (fl < 0.5 and pn > 0.34) else 1.0), "reach": o * 0.8})
		"basket", "cupboard":
			var bas = key == "basket"
			if bas and o > 0: _fxG(Z, 0.48 * W, 0.62 * H - o * 0.1 * H, 1, {"pose": "cast", "pt": o, "alpha": o, "reach": o})
			var rat = (1.0 if sin(t * 0.8 + sd) > 0.85 else 0.0) + a * 1.5
			x = fx_mk(W, H)
			if bas:
				fx_baseExcept(x, im, W, H, [[0.43, 0, 0.77, 0.25]]); var j1 = _jt(rat); var j2 = _jt(rat); var j3 = _jt(rat)
				fx_piece(x, im, W, H, [0.16, 0.35, 0.8, 0.6], 0.48, 0.6, 1.01, 1.01, 0, j1, j2 - absf(j3)); fx_put(c, W, H)
				var bob = sin(t * 1.8 + sd) * 0.03 * H - a * 0.22 * H - (sin(minf(1.0, pn) * 3.14) * 0.05 * H if p != null else 0.0); c.save(); c.translate(0.6 * W, 0.12 * H + bob); c.rotate(sin(t * 1.3 + sd) * 0.08 + a * sin(t * 9) * 0.25); c.translate(-0.6 * W, -0.12 * H); c.drawImage(im, 0.43 * W, 0, 0.34 * W, 0.25 * H, 0.43 * W, 0, 0.34 * W, 0.25 * H); c.restore()
			else:
				var DG = [0.14, 0.11, 0.42, 0.63]; var hx = 0.15 * W; var dop = minf(0.6, (0.08 if sin(t * 0.5 + sd) > 0.88 else 0.0) + a * 0.55)
				var FLY = a > 0.02
				if dop > 0.01 or FLY:
					fx_baseExcept(x, im, W, H, [DG, [0.65, 0.11, 0.84, 0.31], [0.71, 0.35, 0.99, 0.57]] if FLY else [DG]); x.fillStyle = "rgb(16,12,9)"
					if dop > 0.01: x.fillRect(DG[0] * W, DG[1] * H, (DG[2] - DG[0]) * W, (DG[3] - DG[1]) * H)
					if FLY: x.fillRect(0.65 * W, 0.11 * H, 0.19 * W, 0.2 * H); x.fillRect(0.71 * W, 0.35 * H, 0.14 * W, 0.22 * H)
				else: x.drawImage(im, 0, 0)
				var a1 = _jt(rat); var a2 = _jt(rat); fx_piece(x, im, W, H, [0.41, 0.19, 0.56, 0.34], 0.48, 0.33, 1.03, 1.03, 0, a1, a2)
				var b1 = _jt(rat); var b2 = _jt(rat); fx_piece(x, im, W, H, [0.44, 0.47, 0.67, 0.63], 0.55, 0.62, 1.03, 1.03, 0, b1, b2); fx_put(c, W, H)
				if o > 0: _fxG(Z, 0.5 * W, 1.0 * H, 1, {"pose": "cast", "pt": o, "alpha": o * 0.95, "reach": o})
				c.save(); c.translate(hx, 0); c.scale(1 - dop, 1); c.translate(-hx, 0); c.drawImage(im, DG[0] * W, DG[1] * H, (DG[2] - DG[0]) * W, (DG[3] - DG[1]) * H, DG[0] * W, DG[1] * H, (DG[2] - DG[0]) * W, (DG[3] - DG[1]) * H); c.restore()
				var RR = [[0.65, 0.11, 0.84, 0.31, 0.74, 0.2, 0.0], [0.71, 0.35, 0.99, 0.57, 0.85, 0.46, 1.6]]
				for j in 2:
					var r = RR[j]; var bob = sin(t * 1.7 + sd + r[6]) * 0.02 * H - a * (0.16 + j * 0.06) * H
					c.save(); c.translate(r[4] * W, r[5] * H + bob); c.rotate(sin(t * 1.2 + r[6]) * 0.07 + a * sin(t * 8 + j) * 0.3); c.scale(1.04, 1.04); c.translate(-r[4] * W, -r[5] * H); c.drawImage(im, r[0] * W, r[1] * H, (r[2] - r[0]) * W, (r[3] - r[1]) * H, r[0] * W, r[1] * H, (r[2] - r[0]) * W, (r[3] - r[1]) * H); c.restore()
			if p != null and pn < 0.85:
				for j in 4:
					var k2 = minf(1.0, pn * 1.6); var sx = ((0.3 + j * 0.13) if bas else (0.45 + j * 0.08)) * W; var sy = (0.45 if bas else 0.4) * H - sin(k2 * 2.6) * (0.3 + fx_hs(j) * 0.2) * H
					c.save(); c.translate(sx + (j - 1.5) * k2 * 18, sy); c.rotate(k2 * (j + 1) * 3); c.fillStyle = "rgba(236,226,204,0.95)"; c.strokeStyle = "rgba(60,80,120,0.9)"; c.lineWidth = 1.5; c.beginPath(); c.ellipse(0, 0, 0.05 * W, 0.022 * H, 0, 0, 7); c.fill(); c.stroke(); c.restore()
			for j in 2:
				var ph = fmod(t * 0.3 + j / 2.0, 1.0); fx_blob(c, (0.55 if bas else 0.75) * W + sin(ph * 6 + j) * 0.06 * W, ((0.3 if bas else 0.25) - ph * 0.25) * H, (0.04 + ph * 0.05) * W, "170,240,220", (1 - ph) * ph * 4 * 0.22)
	c.restore()

static func mk_devfx() -> Dictionary:
	return {"COL": FX_COL.duplicate(), "HEX": FX_HEX.duplicate(), "KEY": FX_KEY.duplicate(true), "DUR": FX_DUR,
		"frame": func(_t, a): fx_frame(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.num(J.arg(a, 6)), J.num(J.arg(a, 7)), J.num(J.arg(a, 8)), J.num(J.arg(a, 9))); return null,
		"draw": func(_t, a): fx_draw(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.num(J.arg(a, 6)), J.num(J.arg(a, 7)), J.num(J.arg(a, 8)), J.num(J.arg(a, 9)), J.arg(a, 10)); return null,
		"emerge": func(_t, a): return fx_emerge(J.arg(a, 0), J.num(J.arg(a, 1))),
		"trigOf": func(_t, a): return fx_trigOf(J.arg(a, 0), J.num(J.arg(a, 1))),
		"shade": func(_t, a): fx_shade(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4)); return null,
		"shadeArt": func(_t, a): return fx_shadeArt(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4), J.arg(a, 5)),
		"vx": func(_t, a): return fx_vx(J.arg(a, 0)),
		"vxDraw": func(_t, a): fx_vxDraw(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5)); return null,
	}

func run(_env) -> void:
	# 未完成段落：暫時用轉譯版
	var tr = (load("res://jsgen/street.gd") as GDScript).new(); _tr_keep.append(tr); tr.run(null)
	# 已完成段落：原生覆蓋
	J.G["__stDC"] = func(_t, a): stDC(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.arg(a, 5)); return null
	J.G["CrUI"] = mk_crui()
	J.G["DevFx"] = mk_devfx()
