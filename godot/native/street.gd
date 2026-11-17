# 原生改寫：street.js（陽間街／站崗嚇人）——分段做（L3）
# 未完成、未列入 ACTIVE.txt。分段方法：run() 先載轉譯版（jsgen/street.gd）攞齊全部全局，
# 再用原生版逐段覆蓋（轉譯版入面叫 CrUI／DevFx 都係經 J.G 搵，所以覆蓋咗即刻生效），每段對照過先做下一段；
# 全部段落完成之後先拎走轉譯版、加入 ACTIVE.txt。
#   第一段：__stDC、CrUI（蠟筆面板／進度條／手寫字）  ✓
#   第二段：DevFx（設備色框、待機動畫、鬼影現身）  ✓（對照 803/0）
#   第三段：Street 資料、地盤／路線、名氣、離線收益、地圖 ← 而家
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

# ---------------- 第三段：Street 資料、地盤／路線、名氣、離線收益 ----------------
# 數據（KIND、DEV、SQUAD、ELITE、BSK、LAYOUT、OG、ROLE、DATA4、PANO、PEOPLE、CREW、SITES…）由 data/nat/street.json 讀
# （由 street.js 第 257–592 行嘅字面常數用 node 輸出；改原 JS 之後要重新輸出）。
# 行為跟 tools/jsgd/patches.js 打過補丁嘅版本（__nat_stStreet／__nat_stStreetEnd、_n 匯出）。
static var D: Dictionary = {}
static var SQ: Dictionary = {}       # Street 匯出物件（Turf 未改寫之前用轉譯版）
static var _added: Dictionary = {}
static func G(n: String): return J.G.get(n)
static func has(n: String) -> bool: return J.typeof_(J.G.get(n)) != "undefined"
static func S_(): return J.G.get("S")
static func T(yue, zh) -> String:
	var y = J.str(yue)
	if has("LANG") and not _added.has(y): J.mc(G("LANG"), "add", [{y: zh}]); _added[y] = true
	var Wn = G("window")
	if Wn != null and J.t(J.gp(Wn, "L")): return J.str(J.S_window_("L", [y]))
	return y
static func now_ms() -> float: return J.num(J.S_Date_("now", []))
static func pick(a: Array): return a[int(floor(randf() * a.size()))]
static func load_data() -> void:
	if D.size(): return
	var f = FileAccess.open("res://data/nat/street.json", FileAccess.READ)
	D = JSON.parse_string(f.get_as_text())

static func hpMul(lv: float) -> float:
	var P = [[1.0, 1.0], [10.0, 2.55], [24.0, 11.6], [50.0, 198.0]]
	for i in P.size() - 1:
		if lv <= P[i + 1][0]:
			var a = P[i][0]; var va = P[i][1]; var b = P[i + 1][0]; var vb = P[i + 1][1]
			return va * pow(vb / va, (lv - a) / (b - a))
	return 198.0 * pow(1.12, lv - 50)
static func coinOf(lv: float, cap: float) -> float:
	return J.round(13 * pow(1.035, (cap + (lv - cap) * J.num(D.HOT.overRwd) if lv > cap else lv) - 1))
static func _tbl(A: Array, d: float, gr: float) -> float:
	if d < A.size(): return J.num(J.gp(A, maxf(1.0, d)))
	return J.num(A[A.size() - 1]) * pow(gr, d - A.size() + 1)
static func hpP(d: float) -> float: return _tbl(D.HPP, d, 1.096)
static func coP(d: float) -> float: return _tbl(D.COP, d, 1.035)
static func bsk(k): var b = D.BSK.get(J.str(k)); return b if b != null else D.BSK["_"]
static func _grow(g) -> float: return J.num(J.mc(G("GP"), "grow", [g])) if J.t(g) else 1.0
static func bossK(g) -> float:
	var q = _grow(g); return 1 + 4.5 * (q - 1) if q <= 4.0 / 3 else 2.5 + 2 * (q - 4.0 / 3)
static func bossDmg(g) -> float: return J.num(D.BOSS_DMG) * bossK(g)
static func bossCD(g) -> float: return J.num(D.BOSS_CD) / sqrt(_grow(g))
static func staffOf(g, named) -> Dictionary:
	var m = J.num(J.mc(G("GP"), "mul", [g])); var nm = 1.15 if J.t(named) else 1.0; var a = 1 + 0.3 * pow(m, 1.5)
	return {"atk": a * nm, "hp": a * nm, "cd": pow(0.9, m) * (0.89 if J.t(named) else 1.0), "named": 1.0 if J.t(named) else 0.0, "m": m, "pw": J.mc(G("GP"), "pow", [g])}
static func staffTxt(M) -> String:
	var s = "驚嚇 ×" + J.str(J.mc(J.gp(M, "atk"), "toFixed", [2.0])) + "・回靈 ×" + J.str(J.mc(J.gp(M, "cd"), "toFixed", [2.0]))
	return T(s, s)

# ---- 地盤佈局 ----
static func layGet(k):
	var ks = J.str(k)
	return gridLay(ks) if J.t(D.OG.get(ks)) else D.LAYOUT.get(ks)
static func layOf(def, room):
	var rs = J.gp(def, "rooms"); var ri = room if J.t(room) else 0.0
	var k = J.gp(J.gp(rs, ri), "lay") if (J.t(rs) and J.t(J.gp(rs, ri))) else J.gp(def, "lay")
	return layGet(k if J.t(k) else "lobby")
static func gridLay(key: String):
	var Gd = D.OG[key]
	if J.t(Gd.get("lay")): return Gd.lay
	var cw = 1.0 / 6; var ch = 0.1; var x0 = 0.0; var y0 = 0.0
	var at = func(cx: float, cy: float) -> Array: return [x0 + (cx + 0.5) * cw, y0 + (cy + 0.5) * ch]
	var data: String = Gd.data
	var ty = func(cx: float, cy: float) -> float: return 0.0 if (cx < 0 or cy < 0 or cx > 5 or cy > 9) else float(data[int(cy) * 6 + int(cx)].to_int())
	var walk = func(cx, cy) -> bool: var v = ty.call(cx, cy); return v == 3.0 or v == 4.0
	var sx = J.num(Gd.start[0]); var sy = J.num(Gd.start[1]); var ex = J.num(Gd.exit[0]); var ey = J.num(Gd.exit[1])
	var kf = func(x, y) -> String: return J.str(x) + "," + J.str(y)
	var prev = {}; var q = [[sx, sy]]; prev[kf.call(sx, sy)] = null
	while q.size():
		var c0 = q.pop_front(); var x = c0[0]; var y = c0[1]
		if x == ex and y == ey: break
		for dd in [[0, -1], [1, 0], [0, 1], [-1, 0]]:
			var nx = x + dd[0]; var ny = y + dd[1]
			if walk.call(nx, ny) and not prev.has(kf.call(nx, ny)): prev[kf.call(nx, ny)] = [x, y]; q.append([nx, ny])
	var cells = []; var c = [ex, ey]
	while c != null: cells.push_front(c); c = prev.get(kf.call(c[0], c[1]))
	var path = []
	for cc in cells: path.append(at.call(cc[0], cc[1]))
	var s0 = at.call(sx + J.num(Gd.start[2]) * 0.9, sy + J.num(Gd.start[3]) * 0.9); var e0 = at.call(ex + J.num(Gd.exit[2]) * 0.9, ey + J.num(Gd.exit[3]) * 0.9)
	path.push_front(s0); path.append(e0)
	var posts = []; var ni = 0
	for y in 10:
		for x in 6:
			var t = ty.call(x, y)
			if t == 2.0 or t == 4.0:
				var pp = at.call(x, y); ni += 1
				posts.append({"x": pp[0], "y": pp[1], "h": 1.0 if t == 2.0 else 0.0, "n": ("牆位" if t == 2.0 else "路位") + str(ni), "cell": [float(x), float(y)]})
	Gd["lay"] = {"bg": Gd.bg, "path": path, "posts": posts, "grid": {"cw": cw, "ch": ch, "x0": x0, "y0": y0, "ty": func(_t, a): return ty.call(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))}, "max": Gd.max}
	return Gd.lay

static func _d2(a, b) -> float: var dx = J.num(a[0]) - J.num(b[0]); var dy = (J.num(a[1]) - J.num(b[1])) * 1.5; return sqrt(dx * dx + dy * dy)
# 穩定排序（JS Array.sort 係穩定嘅；Godot sort_custom 唔係）
static func _ssort(a: Array, key: Callable) -> Array:
	var o = a.duplicate()
	for i in range(1, o.size()):
		var v = o[i]; var kv = key.call(v); var j = i - 1
		while j >= 0 and key.call(o[j]) > kv: o[j + 1] = o[j]; j -= 1
		o[j + 1] = v
	return o
static func floorGraph(F: Array, block: Array, dL: float, dR: float, entry) -> Dictionary:
	var gx = 0.055; var gy = 0.0367
	var B2 = []
	for r in block: B2.append([J.num(r[0]) - 0.035, J.num(r[1]) - 0.025, J.num(r[2]) + 0.035, J.num(r[3]) + 0.025])
	var inF = func(x: float, y: float) -> bool:
		var inn = false
		for r in F:
			if x >= J.num(r[0]) and x <= J.num(r[2]) and y >= J.num(r[1]) and y <= J.num(r[3]): inn = true; break
		if not inn: return false
		for r in B2:
			if x > r[0] and x < r[2] and y > r[1] and y < r[3]: return false
		return true
	var nodes = {}; var adj = {}
	var i = 0
	while (i + 0.5) * gx < 1:
		var j = 0
		while (j + 0.5) * gy < 1:
			var x = (i + 0.5) * gx; var y = (j + 0.5) * gy
			if inF.call(x, y): nodes["g%d_%d" % [i, j]] = [x, y]
			j += 1
		i += 1
	nodes["E"] = entry if J.t(entry) else [0.0, dL]; nodes["X"] = [1.0, dR]
	var ks = nodes.keys()
	for a in ks: adj[a] = []
	for ii in ks.size():
		for jj in range(ii + 1, ks.size()):
			var a = ks[ii]; var b = ks[jj]; var A = nodes[a]; var B = nodes[b]; var door = a == "E" or a == "X" or b == "E" or b == "X"; var dd = _d2(A, B)
			if dd < (0.075 if door else 0.079) and (door or inF.call((J.num(A[0]) + J.num(B[0])) / 2, (J.num(A[1]) + J.num(B[1])) / 2)): adj[a].append(b); adj[b].append(a)
	var dist = {"X": 0.0}; var q = ["X"]
	while q.size():
		q = _ssort(q, func(k): return dist[k])
		var a = q.pop_front()
		for b in adj[a]:
			var nd = dist[a] + _d2(nodes[a], nodes[b])
			if not dist.has(b) or nd < dist[b] - 1e-9: dist[b] = nd; q.append(b)
	var edges = {}
	for a in ks:
		if a == "X" or not dist.has(a): continue
		var nx = []
		for b in adj[a]:
			if dist.has(b) and dist[b] < dist[a] - 0.025: nx.append(b)
		nx = _ssort(nx, func(k): return dist[k])
		if nx.size(): edges[a] = [nx[0]] + nx if nx.size() > 1 else nx
	var seen = {"E": true}; var stk = ["E"]
	while stk.size():
		var a = stk.pop_back()
		for b in edges.get(a, []):
			if not seen.has(b): seen[b] = true; stk.append(b)
	for k in ks:
		if not seen.has(k): nodes.erase(k); edges.erase(k)
	return {"nodes": nodes, "edges": edges, "dist": dist}
static func procSpec(P) -> Dictionary:
	var dL = J.num(J.gp(P, "dL")); var dR = J.num(J.gp(P, "dR")); var a = minf(dL, 0.5); var b = maxf(dL, 0.5); var c = minf(dR, 0.5); var d = maxf(dR, 0.5)
	var F = [[0.0, dL - 0.07, 0.32, dL + 0.07], [0.18, a - 0.07, 0.32, b + 0.07], [0.18, 0.26, 0.82, 0.74], [0.68, c - 0.07, 0.82, d + 0.07], [0.68, dR - 0.07, 1.0, dR + 0.07]]
	var Sd = [[0.40, 0.43, 0.60, 0.57]]
	var props = [{"k": "boxes", "t": "s", "x0": 0.24, "y0": 0.62, "x1": 0.32, "y1": 0.67}, {"k": "puddle", "t": "p", "x0": 0.70, "y0": 0.48, "x1": 0.78, "y1": 0.52}, {"k": "wire", "t": "e", "x0": 0.72, "y0": 0.29, "x1": 0.78, "y1": 0.32}, {"k": "cart", "t": "s", "x0": 0.66, "y0": 0.64, "x1": 0.75, "y1": 0.69}]
	var slots = [{"n": "上牆燈箱", "x": 0.38, "y": 0.235, "h": 1.0, "s": 1.0}, {"n": "上牆喉管", "x": 0.62, "y": 0.235, "h": 1.0, "s": 1.0}, {"n": "下牆凹位", "x": 0.5, "y": 0.765, "h": 1.0, "s": 2.0}, {"n": "控制台", "x": 0.5, "y": 0.5, "h": 1.0, "s": 2.0},
		{"n": "上通道", "x": 0.5, "y": 0.345, "h": 0.0, "s": 1.0}, {"n": "下通道", "x": 0.5, "y": 0.655, "h": 0.0, "s": 1.0}, {"n": "入口走廊", "x": 0.12, "y": dL, "h": 0.0, "s": 1.0}, {"n": "出口走廊", "x": 0.9, "y": dR, "h": 0.0, "s": 1.0}]
	var obs = [{"k": "console", "t": "w", "x0": Sd[0][0], "y0": Sd[0][1], "x1": Sd[0][2], "y1": Sd[0][3]}]
	return {"F": F, "S": Sd, "props": props, "slots": slots, "obs": obs}
static func _asg(base: Dictionary, srcs: Array) -> Dictionary:
	for o in srcs:
		if o is Dictionary: for k in o: base[k] = o[k]
	return base
static func longLay(_rooms, unlocked, rn, sid):
	var PP: Array = D.PANO.get(J.str(sid), D.PANO.flat); var n = PP.size(); var u = int(minf(n, J.num(unlocked)))
	var posts = []; var nodes = {}; var edges = {}; var hide = J.new_("Set", []); var obs = []; var stairs = []; var tm = 0.0
	var ROOMG = D.DATA4.rooms
	for r in PP.size():
		var P = PP[r]; var N; var Ed; var P0; var O0; var PR0
		if J.t(J.gp(P, "proc")) or J.t(J.gp(P, "floors")):
			var sp
			if J.t(J.gp(P, "proc")): sp = procSpec(P)
			else:
				var sol = J.gp(P, "solids") if J.t(J.gp(P, "solids")) else []; var ob2 = []
				for s2 in sol: ob2.append({"k": "wall", "t": "w", "x0": s2[0], "y0": s2[1], "x1": s2[2], "y1": s2[3]})
				sp = {"F": P.floors, "S": sol, "props": J.gp(P, "props") if J.t(J.gp(P, "props")) else [], "slots": J.gp(P, "slots") if J.t(J.gp(P, "slots")) else [], "obs": ob2}
			var blk = sp.S.duplicate()
			for o in sp.props:
				if J.str(J.gp(o, "t")) == "s": blk.append([o.x0, o.y0, o.x1, o.y1])
			var g = floorGraph(sp.F, blk, J.num(J.gp(P, "dL")), J.num(J.gp(P, "dR")), J.gp(P, "entry")); N = g.nodes; Ed = g.edges; P0 = sp.slots; O0 = sp.obs; PR0 = sp.props; P["_sp"] = sp
		else:
			var R0 = ROOMG[J.str(P.room)]; N = R0.nodes; Ed = R0.edges; P0 = R0.posts; O0 = R0.get("obs", []) if J.t(R0.get("obs")) else []; PR0 = R0.get("props") if J.t(R0.get("props")) else []
		tm += P0.size()
		if r >= u: continue
		var rs = str(r)
		for k in N: nodes[rs + k] = [J.num(N[k][0]) + r, N[k][1]]
		for k in Ed:
			var to = []
			for t in Ed[k]: to.append(rs + J.str(t))
			edges[rs + k] = to
		for pp in P0: posts.append(_asg({"s": 1.0, "d": 0.0}, [pp, {"x": J.num(pp.x) + r, "room": float(r), "kind": "niche" if J.t(J.gp(pp, "h")) else "pad"}]))
		for o in O0: obs.append(_asg({}, [o, {"x0": J.num(o.x0) + r, "x1": J.num(o.x1) + r, "room": float(r), "bg": 1.0}]))
		for o in PR0: obs.append(_asg({}, [o, {"x0": J.num(o.x0) + r, "x1": J.num(o.x1) + r, "room": float(r), "prop": 1.0}]))
		if r > 0:
			var xa = nodes[str(r - 1) + "X"]; var eb = nodes[rs + "E"]
			if absf(J.num(xa[1]) - J.num(eb[1])) > 0.02:
				nodes[rs + "~a"] = [r - 0.02, xa[1]]; nodes[rs + "~b"] = [r + 0.02, eb[1]]; edges[str(r - 1) + "X"] = [rs + "~a"]; edges[rs + "~a"] = [rs + "~b"]; edges[rs + "~b"] = [rs + "E"]
				stairs.append({"x": float(r), "y0": xa[1], "y1": eb[1]})
			else: edges[str(r - 1) + "X"] = [rs + "E"]
	var last = str(u - 1) + "X"; nodes["OUT"] = [J.num(nodes[last][0]) + 0.03, nodes[last][1]]; edges[last] = ["OUT"]
	var preds = {}
	for a in edges:
		for b in edges[a]:
			if not preds.has(b): preds[b] = []
			preds[b].append(a)
	var nv = minf(n, u + 1); var names = []; var rooms = []
	for r in PP.size():
		var P = PP[r]; var nm = J.gp(P, "n")
		if not J.t(nm) and J.t(rn): nm = J.gp(rn, r)
		if not J.t(nm) and J.t(J.gp(P, "room")) and ROOMG.has(J.str(P.room)): nm = ROOMG[J.str(P.room)].get("n")
		names.append(nm if J.t(nm) else ["", ""])
		rooms.append(P.room if J.t(J.gp(P, "room")) else "~" + str(r))
	return {"long": true, "pano": true, "panels": PP, "rooms": rooms, "unlocked": float(u), "posts": posts, "nodes": nodes, "edges": edges, "preds": preds, "hide": hide, "obs": obs, "corrs": [], "stairs": stairs, "start": "0E", "last": last, "worldW": nv, "worldH": 1.0, "nv": nv, "rx": func(_t, a): return J.arg(a, 0), "tm": tm, "names": names}
# NextSet 等概率隨機（同一點寫兩次 = 加權）
static func route(L) -> Array:
	var pts = []; var k = J.gp(L, "start"); var prev = null; var g = 0
	while J.t(k) and g < 600:
		g += 1
		pts.append({"p": J.gp(J.gp(L, "nodes"), k), "k": k, "hide": J.t(prev) and J.t(J.mc(J.gp(L, "hide"), "has", [J.str(prev) + ">" + J.str(k)]))})
		var nx = J.gp(J.gp(L, "edges"), k)
		if not J.t(nx) or J.len(nx) == 0: break
		prev = k; k = pick(nx)
	return pts

# ---- 存檔／鬼 ----
static func st():
	var S = S_()
	if not J.t(J.gp(S, "stnPosts")):
		var sst = J.gp(S, "street")
		if J.t(sst) and J.t(J.gp(sst, "sites")):
			var l = J.gp(sst, "last"); var rt = J.gp(sst, "rate")
			J.sp(S, "stnPosts", {"sites": J.gp(sst, "sites"), "last": l if J.t(l) else now_ms(), "rate": rt if J.t(rt) else 0.0})
		else: J.sp(S, "stnPosts", {"sites": {}, "last": now_ms(), "rate": 0.0})
	return J.gp(S, "stnPosts")
static func site(id, room = null):
	var key = J.str(id) + "#" + J.str(room) if J.t(room) else J.str(id); var sites = J.gp(st(), "sites")
	if not J.t(J.gp(sites, key)): J.sp(sites, key, {"lv": 1.0, "maxLv": 1.0, "hot": 0.0, "combo": 0.0, "scared": 0.0, "leaked": 0.0, "coins": 0.0, "posts": [], "unlocked": 1.0, "lost": 0.0, "bosses": [], "modCur": 0.9})
	return J.gp(sites, key)
static func CHAR_H_OK(k) -> bool:
	var ART = G("ART")
	if J.t(J.gp(ART, "hasRig")) and J.t(J.mc(ART, "hasRig", [k])): return true
	return has("Puppet") and J.t(J.mc(G("Puppet"), "has", [k]))
static func ghost(id):
	if typeof(id) == TYPE_STRING and id.begins_with("dev:"):
		var r = id.substr(4); return {"id": id, "k": D.DEVK.get(r), "name": T(D.DEVN[r][0], D.DEVN[r][1]), "dev": r}
	for g in J.iter(J.gp(S_(), "ghosts")):
		if J.seq(J.gp(g, "id"), id): return g
	return null
static func typesOf(k) -> Array:
	if has("Rework"):
		var t = J.mc(G("Rework"), "typesOf", [k])
		if J.t(t) and J.len(t) > 0: return J.iter(t)
	var SG = G("SCARE_GHOSTS"); var g = J.gp(SG, k) if has("SCARE_GHOSTS") else null
	if J.t(g): return J.iter(J.gp(g, "types")) if J.t(J.gp(g, "types")) else [J.gp(g, "type")]
	return [D.W.keys()[(J.str(k).length() * 7) % 8]]
static func gType(g) -> String:
	for t in typesOf(J.gp(g, "k")):
		if J.t(D.KIND.get(J.str(t))): return J.str(t)
	return "shadow"
static func power(g) -> float:
	var v = J.num(J.mc(G("Station"), "power", [g])) if has("Station") else 40.0
	return v if (is_finite(v) and v > 0) else 40.0
static func freeGhosts() -> Array:
	var nw = now_ms(); var out = []
	for g in J.iter(J.gp(S_(), "ghosts")):
		if J.str(J.gp(g, "k")) != "afu" and not J.t(J.gp(g, "post")) and not J.cmp(J.gp(g, "tiredUntil"), nw, ">"): out.append(g)
	return out
static func save_() -> void: if has("save"): J.cl(G("save"), null, [])

# ---- 名氣 ----
static func addHot(sd, v: float, def) -> String:
	var HOT = D.HOT
	if v > 0:
		J.sp(sd, "combo", J.num(J.gp(sd, "combo")) + 1)
		var cb = J.num(J.gp(sd, "combo"))
		if cb > HOT.comboStart: J.sp(sd, "hot", J.num(J.gp(sd, "hot")) + minf(fmod(cb - HOT.comboStart, 3) + 1, HOT.comboMax))
	else: J.sp(sd, "combo", 0.0)
	J.sp(sd, "hot", J.num(J.gp(sd, "hot")) + v)
	var need = HOT.up * (HOT.overMul if J.num(J.gp(sd, "lv")) >= J.num(J.gp(def, "cap")) else 1.0); var msg = ""
	if J.num(J.gp(sd, "hot")) >= need:
		J.sp(sd, "lv", J.num(J.gp(sd, "lv")) + 1); J.sp(sd, "maxLv", maxf(J.num(J.gp(sd, "maxLv")), J.num(J.gp(sd, "lv")))); J.sp(sd, "hot", 0.0)
		var lv = J.str(J.gp(sd, "lv")); msg = T("傳說愈傳愈勁！路人難度升到 Lv" + lv, "傳說越傳越廣！路人難度升到 Lv" + lv)
	if J.num(J.gp(sd, "hot")) <= HOT.down:
		var lv0 = J.num(J.gp(sd, "lv"))
		if lv0 > 1 and lv0 > J.num(J.gp(sd, "maxLv")) - HOT.minGap:
			J.sp(sd, "lv", lv0 - 1); J.sp(sd, "hot", HOT.downStart); var lv = J.str(J.gp(sd, "lv"))
			msg = T("漏人太多，傳說冷咗，難度跌返 Lv" + lv, "漏掉太多人，傳說冷了，難度降回 Lv" + lv)
		else: J.sp(sd, "hot", HOT.down)
	return msg

# ---- 陽間街地圖（Godot 由原生外殼 game/station/st_street.gd 畫；DOM 版留低對照）----
static func _q(sel: String): return J.cl(G("$"), null, [sel])
static func openStreet() -> void:
	var Wn = G("window")
	if J.t(J.gp(Wn, "Policy")) and J.t(J.gp(G("Policy"), "firstEnter")): J.mc(G("Policy"), "firstEnter", ["station"])
	offline()
	if has("__nat_stStreet") and J.t(J.cl(G("__nat_stStreet"), null, [])): return
	var el = _q("#st-street")
	if not J.t(el):
		el = J.S_document_("createElement", ["section"]); J.sp(el, "id", "st-street"); J.mc(J.gp(G("document"), "body"), "appendChild", [el])
	var src = J.gp(G("SPR_SRC"), "st_street") if has("SPR_SRC") else null
	if not J.t(src): src = ""
	var h = "<div class=\"sts-top\"><button class=\"sts-back\" id=\"sts-back\">◀ " + T("返陰間", "回陰間") + "</button><b>" + T("陽間街・站崗", "陽間街・站崗") + "</b><span>" + T("村莊發展收入", "村莊發展收入") + " +" + J.str(devTotalRate()) + "/" + T("分", "分") + "</span></div>"
	var GP = G("GP"); var myGP = J.mc(GP, "top", [3.0])
	h += "<div class=\"sts-gp\">" + T("你最強三隻鬼平均", "你最強三隻鬼平均") + " " + J.str(J.mc(GP, "tag", [myGP, 0.0])) + "　<small>" + T("紅字＝鬼力未夠，返村升級先", "紅字＝鬼力不足，先回村升級") + "</small></div>"
	h += "<div class=\"sts-map\" style=\"background-image:url('" + J.str(src) + "')\">"
	for d in D.SITES:
		var sd = site(d.id); var held = 0; var lost = 0
		for p in J.iter(J.gp(sd, "posts")):
			if J.t(p) and J.gp(p, "g") != null: held += 1
			if J.t(p) and J.t(J.gp(p, "b")): lost += 1
		var sub
		if held or J.t(J.gp(sd, "scared")): sub = "Lv" + J.str(J.gp(sd, "lv")) + "・" + T("嚇走", "嚇走") + J.str(J.gp(sd, "scared")) + ("・<i>" + T("Bryan 佔", "Bryan 佔") + str(lost) + "</i>" if lost else "")
		else: sub = T("未有鬼站崗", "還沒有鬼站崗")
		var nd = J.mc(GP, "turfNeed", [J.gp(sd, "lv")]); var lowN = J.cmp(myGP, nd, "<")
		h += "<button class=\"sts-plate " + ("" if J.t(d.real) else "wip") + " " + ("war" if lost else "") + "\" data-site=\"" + J.str(d.id) + "\" style=\"left:" + J.str(J.num(d.x) * 100) + "%;top:" + J.str(J.num(d.y) * 100) + "%\"><b>" + T(d.n, d.zh) + "</b><small>" + J.str(sub) + "</small><small class=\"gp-need " + ("gp-low" if lowN else "gp-ok") + "\">" + T("建議鬼力", "建議鬼力") + " " + J.str(nd) + "</small></button>"
	for xy in D.RESERVED:
		h += "<button class=\"sts-plate res\" data-res=\"1\" style=\"left:" + J.str(J.num(xy[0]) * 100) + "%;top:" + J.str(J.num(xy[1]) * 100) + "%\"><b>" + T("保留地", "保留地") + "</b><small>" + T("敬請期待", "敬請期待") + "</small></button>"
	h += "<button class=\"sts-plate gate\" id=\"sts-gate\" style=\"left:" + J.str(J.num(D.GATE[0]) * 100) + "%;top:" + J.str(J.num(D.GATE[1]) * 100) + "%\"><b>" + T("返村", "回村") + "</b></button></div>"
	h += "<p class=\"sts-tip\">" + T("撳地盤入去派鬼站崗。嚇得愈多，傳說愈響，路人就愈難嚇；頂得住就係穩定收入。", "點地盤進去派鬼站崗。嚇得越多，傳說越響，路人就越難嚇；撐得住就是穩定收入。") + "</p>"
	J.sp(el, "innerHTML", h); J.mc(J.gp(el, "classList"), "add", ["on"]); J.mc(J.gp(J.gp(G("document"), "body"), "classList"), "add", ["st-on"])
	var t0 = J.num(J.S_performance_("now", [])); var gc = func() -> bool: return J.num(J.S_performance_("now", [])) - t0 < 450
	for b in J.iter(J.mc(el, "querySelectorAll", [".sts-plate[data-site]"])):
		J.sp(b, "onclick", func(_t = null, _a = null): if not gc.call(): J.mc(J.gp(SQ, "Turf"), "open", [J.gp(J.gp(b, "dataset"), "site")]))
	for b in J.iter(J.mc(el, "querySelectorAll", [".sts-plate[data-res]"])):
		J.sp(b, "onclick", func(_t = null, _a = null): J.mc(G("Fx"), "toast", [T("呢塊地仲未開發，遲啲再嚟", "這塊地還沒開發，晚點再來")]))
	J.sp(_q("#sts-back"), "onclick", func(_t = null, _a = null):
		if gc.call(): return
		closeStreet()
		if has("World"): J.mc(G("World"), "open", []))
	J.sp(_q("#sts-gate"), "onclick", func(_t = null, _a = null): if not gc.call(): closeStreet())
static func closeStreet() -> void:
	if has("__nat_stStreetEnd"): J.cl(G("__nat_stStreetEnd"), null, [])
	var el = _q("#st-street")
	if J.t(el): J.mc(J.gp(el, "classList"), "remove", ["on"]); J.sp(el, "innerHTML", "")
	J.mc(J.gp(J.gp(G("document"), "body"), "classList"), "remove", ["st-on"])
	save_()
	if has("UI") and J.t(J.gp(G("UI"), "refresh")): J.mc(G("UI"), "refresh", [])

# ---- 本關冥幣（sd.wal，經 Turf.sd）＋村莊發展收入（佔領度 ≥50%）----
static func _tsd():
	var Tf = J.gp(SQ, "Turf"); return J.gp(Tf, "sd") if J.t(Tf) else null
static func mk_wal() -> Dictionary:
	return {"__getters": {"v": func(_t, _a): var sd = _tsd(); return (J.num(J.gp(sd, "wal")) if J.t(J.gp(sd, "wal")) else 0.0) if J.t(sd) else 0.0},
		"__setters": {"v": func(_t, a): var sd = _tsd(); if J.t(sd): J.sp(sd, "wal", maxf(0.0, J.round(J.num(J.arg(a, 0))))); return null}}
static func occOf(sd):
	var h = J.gp(sd, "occH") if J.t(sd) else null
	if not J.t(h) or J.len(h) < J.num(D.OCC_MIN): return null
	var a = 0.0
	for x in J.iter(h): a += J.num(x)
	return a / J.len(h)
static func occPush(sd, v) -> void:
	if not J.t(J.gp(sd, "occH")): J.sp(sd, "occH", [])
	var h = J.gp(sd, "occH"); h.append(1.0 if J.t(v) else 0.0)
	var N = int(D.OCC_N)
	if h.size() > N:
		var cut = h.size() - N
		for i in cut: h.pop_front()
static func devRate(sd) -> float:
	var o = occOf(sd)
	if o == null or o < J.num(D.OCC_LINE): return 0.0
	var any = false
	for p in J.iter(J.gp(sd, "posts")):
		if J.t(p) and J.t(J.gp(p, "role")): any = true; break
	if not any: return 0.0
	var ml = J.gp(sd, "maxLv")
	return maxf(1.0, J.round((4 + 3 * (J.num(ml) if J.t(ml) else 1.0)) * (0.5 + o)))
static func devTotalRate() -> float:
	var sites = J.gp(st(), "sites"); var r = 0.0
	for k in J.keys(sites): r += devRate(J.gp(sites, k))
	return r
static func devTick(showToast) -> float:
	var s = st(); var nw = now_ms()
	if not J.t(J.gp(s, "devT")): J.sp(s, "devT", nw); return 0.0
	var mins = minf(480.0, (nw - J.num(J.gp(s, "devT"))) / 60000.0)
	if mins < 1: return 0.0
	var got = 0.0; var sites = J.gp(s, "sites")
	for k in J.keys(sites):
		var sd = J.gp(sites, k); var r = devRate(sd)
		if r > 0:
			var g = floorf(r * mins); J.sp(sd, "devGot", (J.num(J.gp(sd, "devGot")) if J.t(J.gp(sd, "devGot")) else 0.0) + g); got += g
	J.sp(s, "devT", nw)
	if got > 0:
		var res = J.gp(S_(), "res"); var c0 = J.gp(res, "coins"); J.sp(res, "coins", (J.num(c0) if J.t(c0) else 0.0) + got)
		var ds = J.gp(s, "devSum"); J.sp(s, "devSum", (J.num(ds) if J.t(ds) else 0.0) + got)
		if J.t(showToast) or mins >= 3:
			var m = "地盤發展收入：村莊冥幣 +" + J.str(got) + "（" + J.str(J.round(mins)) + " 分鐘）"
			if has("Fx"): J.mc(G("Fx"), "toast", [T(m, m)])
		if has("UI") and J.t(J.gp(G("UI"), "refresh")) and not J.t(J.gp(J.gp(SQ, "Turf"), "on")): J.mc(G("UI"), "refresh", [])
		save_()
	return got
static func offline() -> void: J.sp(st(), "last", now_ms()); devTick(true); save_()
static func mk_street(Turf) -> Dictionary:
	var _n = {"RESERVED": D.RESERVED, "GATE": D.GATE, "devTotalRate": func(_t, _a): return devTotalRate(), "occOf": func(_t, a): return occOf(J.arg(a, 0)),
		"devRate": func(_t, a): return devRate(J.arg(a, 0)), "DEV": D.DEV, "KIND": D.KIND, "CELL": D.CELL, "PX": D.PX, "PPL": D.PPL,
		"ghost": func(_t, a): return ghost(J.arg(a, 0)), "gType": func(_t, a): return gType(J.arg(a, 0)), "CHAR_H_OK": func(_t, a): return CHAR_H_OK(J.arg(a, 0)), "WAL": mk_wal()}
	return {"_n": _n, "TUNE": D.TUNE, "open": func(_t, _a): openStreet(); return null, "close": func(_t, _a): closeStreet(); return null, "Turf": Turf,
		"site": func(_t, a): return site(J.arg(a, 0), J.arg(a, 1)), "st": func(_t, _a): return st(), "hpMul": func(_t, a): return hpMul(J.num(J.arg(a, 0))),
		"coinOf": func(_t, a): return coinOf(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))), "addHot": func(_t, a): return addHot(J.arg(a, 0), J.num(J.arg(a, 1)), J.arg(a, 2)),
		"HOT": D.HOT, "SITES": D.SITES, "KIND": D.KIND}

# ---------------- 第四段：Turf（逐組方法覆蓋喺轉譯版 Turf 物件上；this＝Turf 字典）----------------
# 4a：幾何／路線／鏡頭／經濟小工具
static func _or(v, d): return v if J.t(v) else d
static func Rr(a: float, b: float) -> float: return a + randf() * (b - a)
static func _iw() -> float: return J.num(J.G.get("innerWidth"))
static func _ih() -> float: return J.num(J.G.get("innerHeight"))
static func _hyp(x: float, y: float) -> float: return sqrt(x * x + y * y)
static func _devL(role, sz): return J.gp(J.gp(D.DEV, role), _or(sz, 1.0))
static func tf_P(T, x: float, y: float) -> Array:
	var b = J.gp(T, "box"); return [J.num(J.gp(b, "x")) + x * J.num(J.gp(b, "w")), J.num(J.gp(b, "y")) + y * J.num(J.gp(b, "h"))]
static func tf_buildPath(T) -> void:
	var segs = []; J.sp(T, "segs", segs); var Ln = 0.0; var lay = J.gp(T, "lay")
	if J.t(J.gp(lay, "long")):
		var pts = []; var k = J.gp(lay, "start"); var gd = 0
		while J.t(k) and gd < 80:
			gd += 1; pts.append(J.gp(J.gp(lay, "nodes"), k)); var nx = J.gp(J.gp(lay, "edges"), k); k = J.gp(nx, 0.0) if J.t(nx) else nx
		J.sp(lay, "path", pts)
	var PA = J.gp(lay, "path")
	for i in J.len(PA) - 1:
		var A = J.gp(PA, i); var B = J.gp(PA, i + 1); var ax = J.num(A[0]); var ay = J.num(A[1]); var bx = J.num(B[0]); var by = J.num(B[1]); var d = _hyp(bx - ax, (by - ay) * 1.5)
		segs.append({"ax": ax, "ay": ay, "bx": bx, "by": by, "d": d, "s": Ln}); Ln += d
	J.sp(T, "len", Ln)
static func tf_at(T, t: float) -> Array:
	var segs = J.gp(T, "segs")
	for g in segs:
		if t <= g.s + g.d: var k = (t - g.s) / g.d; return [g.ax + (g.bx - g.ax) * k, g.ay + (g.by - g.ay) * k]
	var z = segs[segs.size() - 1]; return [z.bx, z.by]
static func tf_dist(a, b) -> float: return _hyp(J.num(J.gp(a, 0.0)) - J.num(J.gp(b, 0.0)), (J.num(J.gp(a, 1.0)) - J.num(J.gp(b, 1.0))) * 1.5)
static func tf_mkRoute(T, w, pts0):
	var pts = pts0 if J.t(pts0) else route(J.gp(T, "lay"))
	var j
	if J.gp(w, "j") != null: j = J.num(J.gp(w, "j"))
	else: j = Rr(-0.02, 0.02); J.sp(w, "j", j)
	var segs = []; J.sp(w, "segs", segs); var L0 = 0.0
	var Jf = func(q) -> Array:
		var k = J.str(J.gp(q, "k")); var pp = J.gp(q, "p")
		if k.contains("~in") or k.contains("OUT") or k.contains("@"): return [J.num(J.gp(pp, 0.0)), J.num(J.gp(pp, 1.0))]
		return [J.num(J.gp(pp, 0.0)) + j, J.num(J.gp(pp, 1.0)) + j * 0.6]
	var n = J.len(pts)
	for i in n - 1:
		var A = Jf.call(J.gp(pts, i)); var B = Jf.call(J.gp(pts, i + 1)); var d = _hyp(B[0] - A[0], (B[1] - A[1]) * 1.5)
		if d == 0: d = 1e-6
		var q1 = J.gp(pts, i + 1); var q2 = J.gp(pts, i + 2) if i + 2 < n else null
		segs.append({"ax": A[0], "ay": A[1], "bx": B[0], "by": B[1], "d": d, "s": L0, "hide": J.gp(q1, "hide"), "k": J.gp(q1, "k"), "nk": J.gp(q2, "k") if J.t(q2) else null}); L0 += d
	J.sp(w, "len", L0); return w
static func tf_wp(T, w, dt = null) -> Array:
	if J.seq(J.gp(w, "gone"), "run") and J.t(J.gp(w, "runPath")): return J.mc(T, "runPos", [w])
	var t = J.num(J.gp(w, "t")) + (J.num(dt) if J.t(dt) else 0.0); var S2 = J.gp(w, "segs"); if not J.t(S2): S2 = J.gp(T, "segs")
	for g in J.iter(S2):
		if t <= J.num(J.gp(g, "s")) + J.num(J.gp(g, "d")):
			var k = maxf(0.0, (t - J.num(J.gp(g, "s"))) / J.num(J.gp(g, "d"))); var ax = J.num(J.gp(g, "ax")); var ay = J.num(J.gp(g, "ay"))
			return [ax + (J.num(J.gp(g, "bx")) - ax) * k, ay + (J.num(J.gp(g, "by")) - ay) * k]
	var z = J.gp(S2, J.len(S2) - 1); return [J.gp(z, "bx"), J.gp(z, "by")]
static func tf_camStep(T) -> void:
	var C = J.gp(T, "cam")
	if not J.t(C): C = {"z": 1.5, "x": 0.5, "y": 0.6, "tx": 0.5, "ty": 0.6, "user": 0.0}; J.sp(T, "cam", C)
	var nw = J.num(J.S_performance_("now", [])); var I = J.gp(T, "intro"); var L = J.gp(T, "lay")
	if J.t(I) and J.t(L) and J.t(J.gp(L, "nodes")):
		var lt = J.gp(I, "lt"); J.sp(I, "t", J.num(J.gp(I, "t")) + minf(0.05, (nw - (J.num(lt) if J.t(lt) else nw)) / 1000)); J.sp(I, "lt", nw)
		if J.cmp(J.gp(C, "user"), J.gp(I, "u0"), ">") and J.t(J.gp(I, "u0")): J.sp(T, "intro", null)
		else:
			J.sp(I, "u0", _or(J.gp(I, "u0"), _or(J.gp(C, "user"), 1.0)))
			var nodes = J.gp(L, "nodes"); var pts = [J.gp(nodes, "0E"), J.gp(nodes, J.gp(L, "last")), J.gp(nodes, "0E")]
			var k = minf(1.0, J.num(J.gp(I, "t")) / 8); var sg = 0 if k < 0.55 else 1; var f = (k - 0.55) / 0.45 if sg else k / 0.55; var e = f * f * (3 - 2 * f); var A = pts[sg]; var B = pts[sg + 1]
			J.sp(C, "z", 1.0); var cx = J.num(A[0]) + (J.num(B[0]) - J.num(A[0])) * e; var cy = J.num(A[1]) + (J.num(B[1]) - J.num(A[1])) * e
			J.sp(C, "x", cx); J.sp(C, "tx", cx); J.sp(C, "y", cy); J.sp(C, "ty", cy); J.mc(T, "camClamp", [])
			if k >= 1: J.sp(T, "intro", null); J.sp(C, "user", nw)
			return
	if nw - J.num(J.gp(C, "user")) > 3500 and J.t(J.gp(C, "focus")): J.sp(C, "tx", J.gp(J.gp(C, "focus"), 0.0)); J.sp(C, "ty", J.gp(J.gp(C, "focus"), 1.0))
	var kk = 0.08; J.sp(C, "x", J.num(J.gp(C, "x")) + (J.num(J.gp(C, "tx")) - J.num(J.gp(C, "x"))) * kk); J.sp(C, "y", J.num(J.gp(C, "y")) + (J.num(J.gp(C, "ty")) - J.num(J.gp(C, "y"))) * kk); J.mc(T, "camClamp", [])
static func _box(T):
	var b = J.gp(T, "box"); return b if J.t(b) else {"w": _ih() * 1.2, "h": _ih() * 1.8}
static func _wwh(T) -> Array:
	var L = J.gp(T, "lay"); var WW = J.gp(L, "worldW") if J.t(L) else null; var WH = J.gp(L, "worldH") if J.t(L) else null
	return [J.num(WW) if J.t(WW) else 1.0, J.num(WH) if J.t(WH) else 1.0]
static func tf_zFit(T) -> float:
	var b = _box(T); var w2 = _wwh(T); return minf(1.0, minf(_iw() / (w2[0] * J.num(J.gp(b, "w"))), _ih() / (w2[1] * J.num(J.gp(b, "h")))))
static func tf_camClamp(T) -> void:
	var C = J.gp(T, "cam"); var b = _box(T); var zf = J.num(J.mc(T, "zFit", [])); J.sp(C, "z", maxf(zf, minf(1.5, J.num(J.gp(C, "z")))))
	var z = J.num(J.gp(C, "z")); var hx = (_iw() / 2) / (J.num(J.gp(b, "w")) * z); var hy = (_ih() / 2) / (J.num(J.gp(b, "h")) * z); var w2 = _wwh(T)
	var cl = func(v, h: float, M: float) -> float: return M / 2 if h * 2 >= M else maxf(h, minf(M - h, J.num(v)))
	J.sp(C, "x", cl.call(J.gp(C, "x"), hx, w2[0])); J.sp(C, "tx", cl.call(J.gp(C, "tx"), hx, w2[0])); J.sp(C, "y", cl.call(J.gp(C, "y"), hy, w2[1])); J.sp(C, "ty", cl.call(J.gp(C, "ty"), hy, w2[1]))
static func _cam(T):
	var C = J.gp(T, "cam"); return C if J.t(C) else {"z": 1.0, "x": 0.5, "y": 0.5}
static func tf_toScreen(T, px: float, py: float) -> Array:
	var C = _cam(T); var b = J.gp(T, "box"); var bx = J.num(J.gp(b, "x")); var by = J.num(J.gp(b, "y")); var bw = J.num(J.gp(b, "w")); var bh = J.num(J.gp(b, "h")); var z = J.num(J.gp(C, "z"))
	return [bx + bw / 2 + (px - (bx + J.num(J.gp(C, "x")) * bw)) * z, by + bh / 2 + (py - (by + J.num(J.gp(C, "y")) * bh)) * z]
static func tf_toScene(T, sx: float, sy: float) -> Array:
	var C = _cam(T); var b = J.gp(T, "box"); var bx = J.num(J.gp(b, "x")); var by = J.num(J.gp(b, "y")); var bw = J.num(J.gp(b, "w")); var bh = J.num(J.gp(b, "h")); var z = J.num(J.gp(C, "z"))
	return [(sx - bx - bw / 2) / z + bx + J.num(J.gp(C, "x")) * bw, (sy - by - bh / 2) / z + by + J.num(J.gp(C, "y")) * bh]
static func tf_focusOn(T, x, y) -> void:
	if not J.t(J.gp(T, "cam")): J.mc(T, "camStep", [])
	J.sp(J.gp(T, "cam"), "focus", [x, y])
static func tf_upCost(T, p) -> float:
	var lvs = J.gp(_devL(J.gp(p, "role"), J.gp(p, "sz")), "lv"); var lv = J.num(_or(J.gp(p, "lv"), 1.0)); var nx = J.gp(lvs, lv)
	return J.num(J.gp(nx, 0.0)) if (J.t(nx) and lv < J.num(J.mc(T, "lvCap", []))) else INF
static func tf_stats(_T, g, spot, lv: float) -> Dictionary:
	var ty = gType(g); var K = D.KIND[ty]; var h = J.t(J.gp(spot, "h"))
	var fit = 1.2 if ((J.t(K.get("ground")) and not h) or (J.t(K.get("high")) and h)) else 1.0
	var v = power(g) * J.num(K.mul) * fit * J.num(D.TUNE.dmg) * (1 + 0.25 * (lv - 1))
	return {"ty": ty, "K": K, "scare": J.round(v), "cd": J.mc(J.num(K.cd) * pow(0.92, lv - 1), "toFixed", [2.0])}
static func tf_fixPosts(T) -> void:
	var sd = J.gp(T, "sd"); var LP = J.gp(J.gp(T, "lay"), "posts"); var posts = J.gp(sd, "posts")
	while J.len(posts) < J.len(LP): posts.append(null)
	var out = []
	for i in posts.size():
		var p = posts[i]
		if J.t(p) and J.t(J.gp(p, "role")) and J.t(J.gp(LP, i)):
			var s1 = _or(J.gp(J.gp(LP, i), "s"), 1.0)
			J.sp(p, "sz", s1); J.sp(p, "spent", _or(J.gp(p, "spent"), J.gp(J.gp(J.gp(_devL(J.gp(p, "role"), s1), "lv"), 0.0), 0.0))); out.append(p)
		else: out.append(p if (J.t(p) and J.t(J.gp(p, "role"))) else null)
	J.sp(sd, "posts", out)
static func tf_lvCap(T) -> float: return 3.0 + (2.0 if J.num(J.gp(J.gp(T, "sd"), "unlocked")) >= 3 else 0.0)
static func tf_incomeCap(T) -> float: var RM = D.ROOM_MAXLV; return J.num(RM[int(minf(RM.size(), J.num(J.gp(J.gp(T, "sd"), "unlocked")))) - 1])
static func tf_mod(T) -> float: return maxf(0.9, minf(1.05, J.num(_or(J.gp(J.gp(T, "sd"), "modCur"), 0.9)))) * J.num(_or(J.gp(T, "modMax"), 1.0))
static func tf_unit(T) -> float: return floorf(13 * coP(minf(J.num(J.gp(J.gp(T, "sd"), "lv")), J.num(J.mc(T, "incomeCap", [])))) * 1.15)
static func tf_build(T) -> float:
	var sd = J.gp(T, "sd"); var TM = J.num(J.gp(J.gp(T, "lay"), "tm")); var blt = []
	for p in J.iter(J.gp(sd, "posts")):
		if J.t(p) and J.t(J.gp(p, "role")) and not (J.cmp(J.gp(p, "build"), 0.0, ">") and J.num(_or(J.gp(p, "lv"), 1.0)) == 1): blt.append(p)
	var up = 0.0; var stf = 0
	for p in blt:
		up += (J.num(_or(J.gp(p, "lv"), 1.0)) - 1) * 0.875
		if J.gp(p, "staff") != null: stf += 1
	var v = (blt.size() * 1.5 + up) / (5 * TM) * 0.6 + stf / TM * 0.4
	var bs = J.gp(sd, "bosses")
	if J.t(bs) and J.len(bs) > 0:
		var g = ghost(J.gp(bs, 0.0)); v += 0.1 + minf(0.15, ((J.num(J.mc(G("GP"), "grow", [g])) if J.t(g) else 1.0) - 1) * 0.2)
	return J.round(v * 1000) / 10
static func tf_rect(_T, spot) -> Array:
	var s2 = J.seq(J.gp(spot, "s"), 2.0); var dd = J.t(J.gp(spot, "d")); var CELL = J.num(D.CELL)
	var w = CELL * (2.0 if s2 and not dd else 1.0); var h = CELL * (2.0 if s2 and dd else 1.0) / 1.5; var x = J.num(J.gp(spot, "x")); var y = J.num(J.gp(spot, "y"))
	return [x - w / 2, y - h / 2, x + w / 2, y + h / 2]
static func tf_rdist(T, pt, spot) -> float:
	var r = J.mc(T, "rect", [spot]); var px = J.num(J.gp(pt, 0.0)); var py = J.num(J.gp(pt, 1.0))
	var dx = maxf(maxf(J.num(r[0]) - px, 0.0), px - J.num(r[2])); var dy = maxf(maxf(J.num(r[1]) - py, 0.0), py - J.num(r[3])); return _hyp(dx, dy * 1.5)
static func tf_wseg(_T, w):
	var t = maxf(0.0, J.num(J.gp(w, "t"))); var segs = J.gp(w, "segs")
	for g in J.iter(segs):
		if t <= J.num(J.gp(g, "s")) + J.num(J.gp(g, "d")): return g
	return J.gp(segs, J.len(segs) - 1)
static func tf_runPos(T, w) -> Array:
	var P0 = J.gp(w, "runPath"); var left = minf(J.num(J.gp(w, "runT")), 1.5) * J.num(J.gp(w, "spd")) * 1.8; var n = J.len(P0)
	for i in n - 1:
		var A = J.gp(P0, i); var B = J.gp(P0, i + 1); var d = tf_dist(A, B)
		if left <= d:
			var k = left / d; return [J.num(A[0]) + (J.num(B[0]) - J.num(A[0])) * k, J.num(A[1]) + (J.num(B[1]) - J.num(A[1])) * k]
		left -= d
	return J.gp(P0, n - 1).duplicate()
static func tf_alive(T, w) -> bool: return not J.t(J.gp(w, "gone")) and J.num(J.gp(w, "t")) > 0 and not J.t(J.gp(J.mc(T, "wseg", [w]), "hide"))
static func tf_staffMul(T, p):
	var g = ghost(J.gp(p, "staff")) if J.gp(p, "staff") != null else null
	if not J.t(g): return {"atk": 1.0, "cd": 1.0, "hp": 1.0}
	return staffOf(g, J.t(J.mc(J.gp(T, "SPECIAL"), "includes", [J.gp(g, "k")])))
static func tf_devK(_T, p):
	var g = ghost(J.gp(p, "staff")) if J.gp(p, "staff") != null else null
	return J.gp(g, "k") if J.t(g) else J.gp(J.gp(D.DEV, J.gp(p, "role")), "k")
# 4b：路人生成／命中／嚇走／漏人
static func _pnow() -> float: return J.num(J.S_performance_("now", []))
static func _walAdd(Tf, v: float) -> void:
	var sd = J.gp(Tf, "sd")
	if J.t(sd): J.sp(sd, "wal", maxf(0.0, J.round((J.num(J.gp(sd, "wal")) if J.t(J.gp(sd, "wal")) else 0.0) + v)))
static func _toast(m) -> void: if has("Fx"): J.mc(G("Fx"), "toast", [m])
static func _walkInit(w) -> void:
	w["t"] = 0.0; w["stay"] = 0.0; w["block"] = 0.0; w["fear"] = 0.0; w["slowM"] = 1.0; w["slowT"] = 0.0; w["hist"] = []; w["seed"] = randf() * 9
static func tf_newWalker(Tf, eliteId):
	var sd = J.gp(Tf, "sd"); var w: Dictionary; var PX = J.num(D.PX)
	if J.t(eliteId):
		var E = null
		for e in D.ELITE:
			if J.seq(J.gp(e, "id"), eliteId): E = e; break
		var d = J.num(J.gp(sd, "lv")); var hp = J.round(J.num(E.hp) * hpP(d) * tf_mod(Tf) * 1.25)
		w = {"el": E, "crew": {"n": T(E.n, E.zh), "tag": J.gp(E, "tag")}, "spr": J.gp(E, "spr")}
		w["n"] = T(E.n, E.zh); w["hp"] = hp; w["max"] = hp; w["d"] = d; w["spd"] = J.num(E.spd) * PX * 1.8; w["award"] = J.gp(E, "award")
	else:
		var tw = 0.0
		for q in D.PEOPLE: tw += J.num(q.w)
		tw *= randf(); var p = null
		for q in D.PEOPLE:
			tw -= J.num(q.w)
			if tw <= 0: p = q; break
		if p == null: p = D.PEOPLE[0]
		var r = randf() * 80; var fl = -3.0 if r < 15 else (-2.0 if r < 25 else (-1.0 if r < 32 else 0.0))
		var d = maxf(1.0, J.num(J.gp(sd, "lv")) + fl)
		var hp = J.round(Rr(75, 100) * J.num(p.hp) * hpP(d) * tf_mod(Tf) * 1.25 * (0.8 if J.num(J.gp(sd, "panic")) > 0 else 1.0))
		w = {"p": p, "spr": J.gp(p, "spr"), "tint": J.gp(p, "tint"), "n": T(p.n, p.zh), "hp": hp, "max": hp, "d": d}
		w["spd"] = Rr(100, 110) * J.num(p.spd) * PX * 1.8; w["award"] = 13.0; w["tr"] = J.gp(p, "trait"); w["tT"] = Rr(2, 6)
		if J.seq(J.gp(p, "trait"), "couple"):
			var hp2 = J.round(hp * Rr(0.85, 1.15)); var PA = D.PARTNER
			w["mate"] = {"p": p, "spr": J.gp(PA, "spr"), "tint": J.gp(PA, "tint"), "n": T(PA.n, PA.zh), "hp": hp2, "max": hp2, "d": d, "spd": w.spd, "award": 13.0, "tr": "couple", "tT": 9.0}
	_walkInit(w)
	J.mc(Tf, "mkRoute", [w, null])
	if J.t(w.get("mate")):
		var m = w.mate; _walkInit(m); var sg = []
		for g in J.iter(w.segs): var g2 = g.duplicate(); g2["ax"] = J.num(g.ax) + 0.02; g2["bx"] = J.num(g.bx) + 0.02; sg.append(g2)
		m["segs"] = sg; m["len"] = w.len; m["mate"] = w; m["j"] = w.get("j")
	return w
static func tf_float(Tf, x, y, s, col) -> void: J.gp(Tf, "fx").append({"x": x, "y": y, "s": s, "col": col, "t": 0.0})
const DFX_DUR := {"trap": 1.4, "puzzle": 1.0, "slow": 1.0, "scare": 1.25, "aura": 1.1, "throw": 0.6}
static func tf_hitFx(Tf, w, k) -> void:
	if not J.t(J.gp(Tf, "dfx")): J.sp(Tf, "dfx", [])
	var L = J.gp(Tf, "dfx"); var lim = 0.7 if (k == "aura" or k == "slow" or k == "puzzle") else 0.25
	for e in L:
		if is_same(e.w, w) and J.seq(e.k, k) and J.num(e.t) < lim: return
	if L.size() > 70: L.pop_front()
	L.append({"k": k, "w": w, "t": 0.0, "dur": DFX_DUR.get(J.str(k), 0.8), "seed": randf() * 9})
static func _buf(w, b: String) -> bool: return J.t(J.gp(w, "el")) and J.seq(J.gp(J.gp(w, "el"), "buf"), b)
static func tf_hit(Tf, w, dmg, o) -> void:
	o = o if J.t(o) else {}; dmg = J.num(dmg)
	if J.t(J.gp(w, "gone")) or J.num(J.gp(w, "hp")) <= 0: return
	var pos = tf_wp(Tf, w); var x = J.num(pos[0]); var y = J.num(pos[1]); var PX = J.num(D.PX); var ws = J.iter(J.gp(Tf, "walkers"))
	if not J.t(J.gp(o, "force")) and _buf(w, "dodge") and randf() < 0.3:
		if not J.t(J.gp(o, "aura")): tf_float(Tf, x, y - 0.06, T("閃避", "閃避"), "#9cf")
		return
	if not J.t(J.gp(o, "force")):
		if _buf(w, "tough"): dmg *= 0.7
		var au = _buf(w, "aura")
		if not au:
			for q in ws:
				if not is_same(q, w) and _buf(q, "aura") and tf_alive(Tf, q) and tf_dist(tf_wp(Tf, q), [x, y]) < 200 * PX: au = true; break
		if au: dmg *= 0.85
	if J.num(J.gp(w, "target")) > 0: dmg *= 1.5
	var tr = J.gp(w, "tr")
	if J.t(J.gp(o, "aura")):
		if J.seq(tr, "runner"): dmg *= 0.5
		elif J.seq(tr, "phone") or J.seq(tr, "walkdel"): dmg *= 0.75
	if J.t(J.gp(o, "aura")) or J.t(J.gp(o, "force")):
		for q in ws:
			if J.seq(J.gp(q, "tr"), "durian") and tf_alive(Tf, q) and tf_dist(tf_wp(Tf, q), [x, y]) < 120 * PX: dmg *= 0.7; break
	if J.seq(tr, "drunk") and J.t(J.gp(o, "fright")): o = o.duplicate(); o["fright"] = 0.0
	var SQT = D.SQ_TUNE
	if J.t(J.gp(w, "sq")) and not J.t(J.gp(o, "force")) and J.num(SQT.armor) > 0: dmg = maxf(dmg * 0.25, dmg - J.num(w.max) * J.num(SQT.armor))
	if J.t(J.gp(w, "sq")) and J.num(J.gp(w, "film")) > 0 and (J.seq(J.gp(o, "src"), "aura") or (J.t(J.gp(o, "aura")) and not J.t(J.gp(o, "force")))):
		if not J.t(J.gp(w, "filmSay")) or _pnow() - J.num(w.filmSay) > 2500:
			w["filmSay"] = _pnow(); tf_float(Tf, x, y - 0.07, T("拍緊片，唔覺凍！", "拍緊片，不覺得冷！"), "#ffb0d0")
		return
	if has("StnFoes"): dmg = J.num(J.mc(G("StnFoes"), "onHit", [w, dmg, o, Tf]))
	w["hp"] = J.num(w.hp) - dmg
	if not J.t(J.gp(o, "aura")) or J.num(w.hp) <= 0: w["react"] = 0.6; J.mc(Tf, "say", [w, false])
	if not J.t(J.gp(o, "aura")): tf_float(Tf, x, y - 0.06, "-" + J.str(J.round(dmg)), "#ffd45a" if J.t(J.gp(o, "force")) else "#fff")
	if J.t(J.gp(o, "fear")): w["fear"] = 0.5
	if J.t(J.gp(o, "src")): tf_hitFx(Tf, w, J.gp(o, "src"))
	var fr = J.gp(o, "fright")
	if J.t(fr) and J.num(w.hp) > 0 and not (J.num(J.gp(w, "stay")) > 0): w["stay"] = 2.0 if (fr is bool) else fr
	if J.num(w.hp) <= 0: tf_scared(Tf, w)
static func tf_scared(Tf, w) -> void:
	var sd = J.gp(Tf, "sd"); var pos = tf_wp(Tf, w); w["gone"] = "run"; w["runT"] = 0.0
	var hs = J.iter(J.gp(w, "hist")); var tail = hs.slice(maxi(0, hs.size() - 5)); tail.reverse(); w["runPath"] = [pos] + tail
	J.mc(Tf, "say", [w, true]); var parts = J.gp(Tf, "parts")
	for j in 5: parts.append({"kind": "coin", "x": J.num(pos[0]) + Rr(-0.03, 0.03), "y": J.num(pos[1]) - 0.05, "life": 0.9 + j * 0.08, "k": -j * 0.08})
	var cap = tf_incomeCap(Tf); var wd = J.num(J.gp(w, "d"))
	var coin = floorf(J.num(w.award) * coP(cap if wd > cap else minf(J.num(sd.lv), cap)) * 1.15 * (0.8 if J.num(J.gp(sd, "badPress")) > 0 else 1.0))
	J.sp(sd, "scared", J.num(J.gp(sd, "scared")) + 1); occPush(sd, 1); J.sp(sd, "jar", J.num(J.gp(sd, "jar")) + 1)
	if fmod(J.num(sd.jar), 40.0) == 0:
		var bonus = tf_unit(Tf) * 20; _walAdd(Tf, bonus); _toast(T("收集罐滿咗！冥幣 +" + J.str(bonus), "收集罐滿了！冥幣 +" + J.str(bonus)))
	_walAdd(Tf, coin); J.sp(sd, "coins", J.num(J.gp(sd, "coins")) + coin); J.sp(Tf, "rateAcc", J.num(J.gp(Tf, "rateAcc")) + coin)
	tf_float(Tf, pos[0], J.num(pos[1]) - 0.09, T("嚇走！冥幣+" + J.str(coin), "嚇跑！冥幣+" + J.str(coin)), "#7dffb0")
	var m = addHot(sd, J.num(D.HOT.add), J.gp(Tf, "def")); if m != "": _toast(m)
	var tr = J.gp(w, "tr")
	if J.seq(tr, "couple") and J.t(J.gp(w, "mate")) and tf_alive(Tf, w.mate):
		var mt = w.mate; tf_hit(Tf, mt, J.num(mt.max) * 0.45, {"force": true})
		if not J.t(J.gp(mt, "gone")): mt["back"] = J.num(D.CELL) * 2.5; mt["say"] = {"s": T("等埋我呀！", "等等我啊！"), "t": 1.4}
	if J.seq(tr, "groceries"):
		J.mc(Tf, "addTrace", ["veg", pos[0], pos[1], 80.0, 7.0, {"by": "auntie"}]); J.mc(Tf, "cap", [T("啲餸跌晒落地！", "菜全掉在地上！"), pos[0], J.num(pos[1]) - 0.14, {"col": "#b8f0a0", "size": 13.0, "style": "pop", "font": "sans-serif"}])
	if J.seq(tr, "rider"): J.mc(Tf, "addTrace", ["bowl", pos[0], pos[1], 90.0, 6.0, {"by": "rider"}])
	if J.seq(tr, "walkdel"):
		J.mc(Tf, "addTrace", ["bowl", pos[0], pos[1], 90.0, 6.0, {"by": "rider"}]); J.mc(Tf, "cap", [T("份外賣跌咗落地！", "外送掉在地上了！"), pos[0], J.num(pos[1]) - 0.14, {"col": "#ffd0a0", "size": 13.0, "style": "pop", "font": "sans-serif"}])
	if J.t(J.gp(w, "sq")): J.mc(Tf, "sqMember", [w, "run"])
static func tf_leak(Tf, w) -> void:
	var sd = J.gp(Tf, "sd"); J.sp(sd, "leaked", J.num(J.gp(sd, "leaked")) + 1); occPush(sd, 0); J.sp(sd, "leakAcc", J.num(J.gp(sd, "leakAcc")) + 1)
	if J.num(sd.leakAcc) >= 4: J.sp(sd, "leakAcc", 0.0); J.sp(sd, "modCur", maxf(0.9, J.num(_or(J.gp(sd, "modCur"), 0.9)) - 0.06))
	var m = addHot(sd, J.num(D.HOT.leak), J.gp(Tf, "def")); var L = J.gp(Tf, "lay"); var nd = J.gp(J.gp(L, "nodes"), J.gp(L, "last"))
	tf_float(Tf, J.num(nd[0]) - 0.08, J.num(nd[1]) - 0.04, T("漏咗一個…名氣 −18", "漏掉一個…名氣 −18"), "#ff8a8a")
	if m != "": _toast(m); J.mc(Tf, "gpWarn", ["drop", T("漏人太多，路人膽量跌咗級", "漏掉太多人，路人膽量降級了")])
	if J.t(J.gp(w, "sq")): J.mc(Tf, "sqMember", [w, "out"])
const TF_4B := {"newWalker": 1, "float": 4, "hitFx": 2, "hit": 3, "scared": 1, "leak": 1}

# 4c：特殊路人組（網紅組／探險組）邏輯；橫額／帖文／相（DOM、畫布）仍用轉譯版 sqBanner／sqShot／sqPost
static func _wn(k): var Wn = G("window"); return J.gp(Wn, k) if Wn != null else null
static func tf_sqWaveDone(Tf) -> void:
	var sd = J.gp(Tf, "sd"); J.sp(Tf, "waveNo", J.num(J.gp(Tf, "waveNo")) + 1)
	if J.t(J.gp(Tf, "sqPlan")): return
	var cd = J.gp(Tf, "sqCD"); J.sp(Tf, "sqCD", (1.0 if cd == null else J.num(cd)) - 1)
	var ok = []
	for k in D.SQUAD:
		if J.num(J.gp(sd, "lv")) >= J.num(D.SQUAD[k].minLv): ok.append(k)
	var force = _wn("SQ_FORCE")
	if ok.is_empty() or J.num(J.gp(Tf, "sqCD")) > 0 or randf() > (1.0 if J.t(force) else 0.45): return
	var kind = force if (J.t(force) and D.SQUAD.has(J.str(force))) else pick(ok)
	J.sp(Tf, "sqPlan", {"kind": kind, "wave": J.num(J.gp(Tf, "waveNo")) + 2}); J.sp(Tf, "sqCD", 3.0)
	var S0 = D.SQUAD[J.str(kind)]; var nm = T(S0.n[0], S0.n[1])
	_toast(T("⚠ 今晚有" + nm + "嚟踩場！再過一組就到，快啲執好設備！", "⚠ 今晚有" + nm + "來踩場！再過一組就到，快點佈置好設備！"))
	J.mc(Tf, "sqBanner", [T("今晚有" + nm + "嚟踩場！", "今晚有" + nm + "來踩場！"), T("再過一組就到・佢哋難嚇又識避設備", "再過一組就到・他們難嚇又會避開設備"), S0.tag])
static func _chk(p) -> float:
	var PX = J.num(D.PX); var CELL = J.num(D.CELL)
	if J.seq(J.gp(p, "role"), "slow"): return 1.2 * CELL
	var c = J.gp(_devL(J.gp(p, "role"), J.gp(p, "sz")), "check")
	var v = J.num(c) * PX if c != null else 0.0
	return v if v != 0 else CELL
static func tf_sqMake(Tf, kind):
	var S0 = D.SQUAD[J.str(kind)]; var sd = J.gp(Tf, "sd"); var L = J.gp(Tf, "lay"); var best = null; var bs = 1e9; var SQT = D.SQ_TUNE; var PX = J.num(D.PX)
	var posts = []; var SP = J.iter(J.gp(sd, "posts"))
	for i in SP.size():
		var p = SP[i]
		if J.t(p) and J.t(J.gp(p, "role")) and not (J.num(J.gp(p, "build")) > 0): posts.append([p, J.gp(J.gp(L, "posts"), float(i))])
	for k in int(J.num(SQT.routes)):
		var pts = route(L); var sc = 0
		for q in pts:
			for ps in posts:
				if tf_rdist(Tf, J.gp(q, "p"), ps[1]) <= _chk(ps[0]): sc += 1
		if sc < bs: bs = sc; best = pts
	var sq = {"kind": kind, "mem": [], "scared": 0.0, "leaked": 0.0, "done": false, "cheerT": 2.0}
	var altK = []
	for m in S0.members:
		if J.t(J.gp(m, "alt")): altK.append(m)
	var altPick = pick(altK) if altK.size() else null; var mems = []
	for m in S0.members:
		if not J.t(J.gp(m, "alt")) or is_same(m, altPick) or J.t(_wn("SQ_ALL")): mems.append(m)
	for j in mems.size():
		var m = mems[j]; var w = tf_newWalker(Tf, null); var hp = J.round(J.num(w.max) * J.num(SQT.hp[J.str(kind)]))
		w["sq"] = sq; w["sqRole"] = m; w["sqAcc"] = J.gp(m, "acc"); w["spr"] = J.gp(m, "spr"); w["tint"] = null; w["p"] = {"id": "sq", "n": "", "acc": null}; w["tr"] = ""; w["mate"] = null
		w["n"] = T(S0.n[0], S0.n[1]) + "・" + T(m.r[0], m.r[1]); w["hp"] = hp; w["max"] = hp; w["award"] = J.round(J.num(w.award) * 3); w["j"] = (j - (mems.size() - 1) / 2.0) * 0.016
		w["film"] = 0.0; w["filmT"] = Rr(1, 5); w["spd"] = Rr(102, 106) * PX * 1.8
		tf_mkRoute(Tf, w, best); sq.mem.append(w)
	return sq
static func tf_sqWalk(Tf, w, dt) -> bool:
	var sq = J.gp(w, "sq"); dt = J.num(dt)
	if not J.t(sq) or J.t(J.gp(w, "gone")): return false
	w["rushM"] = 1.0; var PX = J.num(D.PX); var SQT = D.SQ_TUNE
	if J.num(J.gp(w, "film")) > 0: w["film"] = J.num(w.film) - dt
	else:
		w["filmT"] = J.num(J.gp(w, "filmT")) - dt
		if J.num(w.filmT) <= 0 and (J.seq(sq.kind, "influencer") or J.seq(J.gp(w, "sqAcc"), "cam")): w["film"] = 3.0; w["filmT"] = Rr(6, 9)
	if J.num(J.gp(w, "cheerCD")) > 0: w["cheerCD"] = J.num(w.cheerCD) - dt
	else:
		w["cheerCD"] = 2.6; var mates = []
		for q in J.iter(sq.mem):
			if not is_same(q, w) and tf_alive(Tf, q) and J.num(q.hp) < J.num(q.max) * 0.9 and tf_dist(tf_wp(Tf, q), tf_wp(Tf, w)) < 150 * PX: mates.append(q)
		if mates.size() and tf_alive(Tf, w):
			for q in mates: q["hp"] = minf(J.num(q.max), J.num(q.hp) + J.num(q.max) * J.num(SQT.cheer))
			var nw = _pnow()
			if not (J.num(J.gp(sq, "cheerF")) > nw):
				sq["cheerF"] = nw + 4000; var xy = tf_wp(Tf, w); var pc = J.str(J.round(J.num(SQT.cheer) * 100))
				tf_float(Tf, xy[0], J.num(xy[1]) - 0.08, T("隊友打氣 +" + pc + "%", "隊友打氣 +" + pc + "%"), "#9ef0b0")
			if not J.t(J.gp(w, "say")) and randf() < 0.5:
				var used = {}
				for q in J.iter(J.gp(Tf, "walkers")):
					if J.t(J.gp(q, "say")): used[J.str(J.gp(q.say, "s"))] = true
				var o = []
				for c2 in D.SQ_CHEER:
					if not used.has(T(c2[0], c2[1])): o.append(c2)
				if o.size(): var c3 = pick(o); w["say"] = {"s": T(c3[0], c3[1]), "t": 1.3}
	if not tf_alive(Tf, w) or J.num(J.gp(w, "stay")) > 0 or J.num(J.gp(w, "block")) > 0: return false
	var sd = J.gp(Tf, "sd"); var cur = tf_wp(Tf, w); var ahead = tf_wp(Tf, w, 110 * PX); var wait = false; var rush = false
	var SP = J.iter(J.gp(sd, "posts"))
	for i in SP.size():
		var p = SP[i]
		if not J.t(p) or not J.t(J.gp(p, "role")) or J.num(J.gp(p, "build")) > 0: continue
		var role = J.str(p.role)
		if role == "slow" or role == "aura" or role == "puzzle": continue
		var s = J.gp(J.gp(J.gp(Tf, "lay"), "posts"), float(i)); var DL = _devL(p.role, J.gp(p, "sz")); var chk = J.num(J.gp(DL, "check")) * PX
		if chk == 0 or tf_rdist(Tf, ahead, s) > chk or tf_rdist(Tf, cur, s) <= chk: continue
		var L0 = J.gp(J.gp(DL, "lv"), J.num(_or(J.gp(p, "lv"), 1.0)) - 1)
		var ready = J.num(J.gp(p, "cd")) >= J.num(L0[3]) * J.num(J.gp(J.mc(Tf, "staffMul", [p]), "cd")) * 0.8 and not J.t(J.gp(p, "win")) and J.gp(p, "anim") == null
		var blocked = has("StnFoes") and J.t(J.mc(G("StnFoes"), "blocks", [p]))
		if ready and not blocked:
			if not J.t(J.gp(w, "waited")): w["waited"] = {}
			var wv = J.num(J.gp(w.waited, float(i)))
			if wv < J.num(SQT.wait): J.sp(w.waited, float(i), wv + dt); wait = true
		else: rush = true
	if wait:
		if not J.t(J.gp(w, "say")) and randf() < dt * 0.6: w["say"] = {"s": T("等陣，嗰度有古怪……", "等一下，那裡有古怪……"), "t": 1.2}
		return true
	if rush:
		w["rushM"] = SQT.rush
		if not J.t(J.gp(w, "rushSay")): w["rushSay"] = 1.0; var xy = tf_wp(Tf, w); tf_float(Tf, xy[0], J.num(xy[1]) - 0.1, T("趁冷卻衝！", "趁冷卻衝！"), "#ffb060")
	return false
static func tf_sqMember(Tf, w, how) -> void:
	var sq = J.gp(w, "sq")
	if not J.t(sq) or J.t(J.gp(sq, "done")): return
	if J.seq(how, "run"): sq["scared"] = J.num(sq.scared) + 1
	else: sq["leaked"] = J.num(sq.leaked) + 1
	if J.num(sq.scared) + J.num(sq.leaked) < J.len(sq.mem): return
	sq["done"] = true; tf_sqEnd(Tf, sq, w)
static func tf_sqEnd(Tf, sq, last) -> void:
	var sd = J.gp(Tf, "sd"); var S0 = D.SQUAD[J.str(sq.kind)]; var win = J.num(sq.scared) > J.num(sq.leaked); var mem = J.iter(sq.mem); var dk = 0.0
	for q in mem: dk += minf(1.0, maxf(0.0, (J.num(q.max) - maxf(0.0, J.num(q.hp))) / J.num(q.max)))
	dk /= mem.size(); var smooth = not win and dk < 0.25
	if not J.t(J.gp(sd, "sqLog")): J.sp(sd, "sqLog", {"win": 0.0, "lose": 0.0, "exposed": 0.0})
	var lg = J.gp(sd, "sqLog"); var res = "win" if win else ("exposed" if smooth else "lose")
	J.sp(lg, res, J.num(J.gp(lg, res)) + 1); var kr = J.str(sq.kind) + "_" + res; J.sp(lg, kr, J.num(J.gp(lg, kr)) + 1)
	var pos = tf_wp(Tf, last); var def = J.gp(Tf, "def"); var siteN = T(J.gp(def, "n"), J.gp(def, "zh"))
	var shot = J.mc(Tf, "sqShot", [pos, win, sq])
	if win:
		var v = J.round(5 + (1 - minf(1.0, J.num(sq.leaked) / mem.size())) * 3); var m = addHot(sd, v, def); J.sp(sd, "panic", 120.0)
		var bonus = tf_unit(Tf) * 12; _walAdd(Tf, bonus); J.sp(sd, "coins", J.num(J.gp(sd, "coins")) + bonus)
		J.sp(Tf, "slowmo", 0.9); J.sp(Tf, "flash", 0.3); J.sp(Tf, "shake", 0.4)
		J.mc(Tf, "cap", [T("嚇爆！", "嚇爆！"), pos[0], J.num(pos[1]) - 0.12, {"col": "#ff3b2f", "size": 40.0, "style": "pop", "font": "serif"}])
		var s1 = "傳說名氣 +" + J.str(v) + "・冥幣 +" + J.str(bonus); tf_float(Tf, pos[0], J.num(pos[1]) - 0.05, T(s1, s1), "#ffd45a")
		if m != "": _toast(m)
	else:
		var v = -10.0 if smooth else -6.0; var m = addHot(sd, v, def); J.sp(sd, "badPress", 120.0)
		var s1 = "傳說名氣 " + J.str(v); tf_float(Tf, pos[0], J.num(pos[1]) - 0.05, T(s1, s1), "#ff8a8a")
		if m != "": _toast(m); J.mc(Tf, "gpWarn", ["drop", T("嚇唔走成隊人，路人膽量跌咗級", "嚇不走整隊人，路人膽量降級了")])
	J.F_setTimeout([func(_t, _a): J.mc(Tf, "sqPost", [sq, win, smooth, shot, siteN]); return null, 900.0 if win else 300.0])
const TF_4C := {"sqWaveDone": 0, "sqMake": 1, "sqWalk": 2, "sqMember": 2, "sqEnd": 2}

# 4d：每格邏輯 tick（裝置循環 devTick／排隊／Boss／痕跡／障礙／路人特效仍經方法表呼叫）
static func tf_tick(Tf, dt) -> void:
	dt = J.num(dt); var sd = J.gp(Tf, "sd"); var L = J.gp(Tf, "lay"); var LP = J.gp(L, "posts"); var parts = J.gp(Tf, "parts"); var SP = J.iter(J.gp(sd, "posts"))
	J.mc(Tf, "queueTick", [dt])
	for i in SP.size():
		var p = SP[i]
		if J.t(p) and J.num(J.gp(p, "build")) > 0:
			p["build"] = J.num(p.build) - dt
			if randf() < dt * 8:
				var P0 = J.gp(LP, float(i)); var x = J.num(P0.x) + Rr(-0.04, 0.04); var y = J.num(P0.y) + Rr(-0.02, 0.03); var vx = Rr(-0.03, 0.03); var vy = Rr(-0.08, -0.03)
				parts.append({"x": x, "y": y, "vx": vx, "vy": vy, "life": 0.9, "kind": "smoke"})
			if J.num(p.build) <= 0: p["build"] = 0.0; _toast(T("建造完成！", "建造完成！"))
	J.mc(Tf, "bossTick", [dt]); J.mc(Tf, "traceTick", [dt]); J.mc(Tf, "obsTick", [dt])
	if has("StnFoes"): J.mc(G("StnFoes"), "update", [dt, Tf])
	SP = J.iter(J.gp(sd, "posts"))
	for i in SP.size():
		var p = SP[i]
		if J.t(p) and J.t(J.gp(p, "role")) and not (J.num(J.gp(p, "build")) > 0) and J.t(J.gp(LP, float(i))): J.sp(Tf, "_foeRole", p.role); J.mc(Tf, "devTick", [float(i), p, dt])
	J.sp(Tf, "_foeRole", "throw")
	var keep = []
	for s in J.iter(J.gp(Tf, "shots")):
		s["t"] = J.num(s.t) + dt / J.num(s.dur)
		if J.num(s.t) >= 1:
			var hs = []
			for w in J.iter(J.gp(Tf, "walkers")):
				if tf_alive(Tf, w) and tf_dist(tf_wp(Tf, w), s.to) <= J.num(s.eff): hs.append(w)
			for w in hs: tf_hit(Tf, w, s.atk, {"src": "throw"})
			for j in 10:
				var vx = Rr(-0.18, 0.18); var vy = Rr(-0.3, -0.06); parts.append({"x": s.to[0], "y": J.num(s.to[1]) - 0.03, "vx": vx, "vy": vy, "life": 0.7, "kind": "shard"})
		else: keep.append(s)
	J.sp(Tf, "shots", keep)
	for p in J.iter(J.gp(sd, "posts")):
		if J.t(p) and J.t(J.gp(p, "fx")):
			p.fx["t"] = J.num(p.fx.t) + dt
			if J.num(p.fx.t) > 1.1: p["fx"] = null
	for p in J.iter(J.gp(sd, "posts")):
		if J.t(p) and J.num(J.gp(p, "auraOn")) > 0: p["auraOn"] = J.num(p.auraOn) - dt
	for e in J.iter(_or(J.gp(Tf, "dfx"), [])): e["t"] = J.num(e.t) + dt
	if J.num(J.gp(sd, "panic")) > 0: J.sp(sd, "panic", J.num(sd.panic) - dt)
	if J.num(J.gp(sd, "badPress")) > 0: J.sp(sd, "badPress", J.num(sd.badPress) - dt)
	var pk = []
	for q in J.iter(parts):
		q["life"] = J.num(q.life) - dt
		if J.seq(J.gp(q, "kind"), "coin"): q["k"] = minf(1.0, J.num(J.gp(q, "k")) + dt * 1.4)
		else: q["x"] = J.num(q.x) + J.num(q.vx) * dt; q["y"] = J.num(q.y) + J.num(q.vy) * dt; q["vy"] = J.num(q.vy) + 0.35 * dt
		if J.num(q.life) > 0: pk.append(q)
	J.sp(Tf, "parts", pk); parts = pk
	for w in J.iter(J.gp(Tf, "walkers")):
		if J.num(J.gp(w, "react")) > 0: w["react"] = J.num(w.react) - dt
		if J.num(J.gp(w, "frost")) > 0: w["frost"] = J.num(w.frost) - dt
		if J.num(J.gp(w, "fear")) > 0: w["fear"] = J.num(w.fear) - dt
		if J.t(J.gp(w, "say")):
			w.say["t"] = J.num(w.say.t) - dt
			if J.num(w.say.t) <= 0: w["say"] = null
	J.sp(Tf, "shake", maxf(0.0, J.num(J.gp(Tf, "shake")) - dt)); J.sp(Tf, "flash", maxf(0.0, J.num(J.gp(Tf, "flash")) - dt))
	if randf() < dt * 3:
		var SP2 = J.iter(J.gp(sd, "posts")); var q = -1
		for i in SP2.size():
			if J.t(SP2[i]) and J.num(J.gp(SP2[i], "auraOn")) > 0: q = i; break
		if q >= 0:
			var P0 = J.gp(LP, float(q)); var x = J.num(P0.x) + Rr(-0.1, 0.1); var y = J.num(P0.y) + Rr(-0.02, 0.1); var vx = Rr(-0.04, 0.04); var vy = Rr(-0.05, -0.01)
			parts.append({"x": x, "y": y, "vx": vx, "vy": vy, "life": 1.4, "kind": "mist"})
	var CELL = J.num(D.CELL)
	for w in J.iter(J.gp(Tf, "walkers")):
		var gone = J.gp(w, "gone")
		if J.seq(gone, "suck"): w["suckT"] = J.num(J.gp(w, "suckT")) + dt; continue
		if J.seq(gone, "run"): w["runT"] = J.num(J.gp(w, "runT")) + dt; continue
		if J.t(J.gp(w, "sq")) and tf_sqWalk(Tf, w, dt): continue
		if J.t(J.mc(Tf, "walkerFx", [w, dt])): continue
		if J.num(J.gp(w, "spin")) > 0: w["spin"] = J.num(w.spin) - dt; continue
		if J.num(J.gp(w, "stay")) > 0: w["stay"] = J.num(w.stay) - dt; continue
		if J.num(J.gp(w, "block")) > 0: w["block"] = J.num(w.block) - dt; continue
		if J.num(J.gp(w, "back")) > 0:
			var sb = J.num(w.spd) * 1.3 * dt; w["t"] = maxf(0.01, J.num(w.t) - sb); w["back"] = J.num(w.back) - sb; w["rev"] = 0.3; continue
		if J.num(J.gp(w, "rev")) > 0: w["rev"] = J.num(w.rev) - dt
		var sg = tf_wseg(Tf, w); var hide = J.t(sg) and J.t(J.gp(sg, "hide"))
		var sp = J.num(w.spd) * (4.0 if hide else 1.0) * (J.num(w.slowM) if J.num(J.gp(w, "slowT")) > 0 else 1.0) * J.num(_or(J.gp(w, "rushM"), 1.0))
		w["slowT"] = J.num(J.gp(w, "slowT")) - dt
		if J.num(w.slowT) <= 0: w["slowM"] = 1.0
		w["t"] = J.num(w.t) + sp * dt
		if J.num(w.t) > 0 and not hide:
			var pos = tf_wp(Tf, w); var h = J.gp(w, "hist"); var lp = h[h.size() - 1] if h.size() else null
			if not J.t(lp) or tf_dist(lp, pos) >= CELL:
				h.append(pos)
				if h.size() > 6: h.pop_front()
		if J.num(w.t) >= J.num(w.len): w["gone"] = "out"; tf_leak(Tf, w)
	J.sp(Tf, "_foeRole", null); var wk = []
	for w in J.iter(J.gp(Tf, "walkers")):
		var g = J.gp(w, "gone")
		if not (J.seq(g, "out") or (J.seq(g, "run") and J.num(J.gp(w, "runT")) > 2.0) or (J.seq(g, "suck") and J.num(J.gp(w, "suckT")) > 1.1)): wk.append(w)
	J.sp(Tf, "walkers", wk); var fk = []
	for f in J.iter(J.gp(Tf, "fx")):
		f["t"] = J.num(f.t) + dt
		if J.num(f.t) < 1.2: fk.append(f)
	J.sp(Tf, "fx", fk)
	var s0 = st(); var nw = now_ms()
	if J.num(J.gp(s0, "box")) < 1 and nw - J.num(J.gp(s0, "boxAt")) >= 20 * 60000: J.sp(s0, "box", 1.0)
	if J.gp(s0, "tapE") == null: J.sp(s0, "tapE", 100.0)
	if J.num(J.gp(s0, "tapE")) < 100 and nw - J.num(J.gp(s0, "tapAt")) >= 300000: J.sp(s0, "tapE", J.num(s0.tapE) + 1); J.sp(s0, "tapAt", now_ms())
	J.sp(Tf, "rateT", J.num(J.gp(Tf, "rateT")) + dt)
	if J.num(Tf.rateT) >= 60:
		var r0 = J.gp(s0, "rate"); J.sp(s0, "rate", J.num(r0) * 0.6 + J.num(J.gp(Tf, "rateAcc")) * 0.4 if J.t(r0) else J.gp(Tf, "rateAcc")); J.sp(Tf, "rateAcc", 0.0); J.sp(Tf, "rateT", 0.0); J.sp(s0, "last", now_ms()); save_()
const TF_4D := {"tick": 1}

# 4e：排隊／放行／裝置循環（devTick、fire、鬼打牆 puzzleTick）／視線 los
static func tf_los(Tf, a, b2) -> bool:
	for o in J.iter(_or(J.gp(J.gp(Tf, "lay"), "obs"), [])):
		if not J.seq(J.gp(o, "t"), "s"): continue
		var r = [J.num(o.x0) + 0.01, J.num(o.y0) + 0.008, J.num(o.x1) - 0.01, J.num(o.y1) - 0.008]
		for i in range(1, 12):
			var k = i / 12.0; var x = J.num(a[0]) + (J.num(b2[0]) - J.num(a[0])) * k; var y = J.num(a[1]) + (J.num(b2[1]) - J.num(a[1])) * k
			if x > r[0] and x < r[2] and y > r[1] and y < r[3]: return false
	return true
static func tf_queueTick(Tf, dt) -> void:
	dt = J.num(dt); var q = J.gp(Tf, "q"); var sd = J.gp(Tf, "sd"); var n = 3 + minf(3.0, J.num(sd.unlocked) - 1)
	var stt = J.str(q.st)
	if stt == "gap":
		q["t"] = J.num(q.t) - dt
		if J.num(q.t) <= 0:
			q["st"] = "form"; q["n"] = n; q["made"] = 0.0; q["t"] = 0.0; q["list"] = []
			var plan = J.gp(Tf, "sqPlan")
			if J.t(plan) and J.num(J.gp(Tf, "waveNo")) + 1 >= J.num(plan.wave):
				var sq = tf_sqMake(Tf, plan.kind); J.sp(Tf, "sqPlan", null); q["list"] = sq.mem.duplicate(); q["n"] = float(q.list.size()); q["made"] = q.n; q["sq"] = sq; q["st"] = "ready"; q["t"] = 90.0
				var S0 = D.SQUAD[J.str(sq.kind)]
				J.mc(Tf, "sqBanner", [T(J.str(S0.n[0]) + "到咗門口！", J.str(S0.n[1]) + "到門口了！"), T("撳「進入」放佢哋入嚟，或者等 90 秒", "點「進入」放他們進來，或等 90 秒"), S0.tag])
	elif stt == "form":
		q["t"] = J.num(q.t) - dt
		if J.num(q.t) <= 0 and J.num(q.made) < J.num(q.n):
			q["t"] = 0.5; q["made"] = J.num(q.made) + 1; var el = null
			if J.num(J.gp(Tf, "eliteT")) <= 0:
				var ok = []
				for e in D.ELITE:
					if J.num(J.gp(sd, "scared")) >= J.num(e.rep): ok.append(e)
				if ok.size(): el = pick(ok).id; J.sp(Tf, "eliteT", Rr(75, 125))
			var nw = tf_newWalker(Tf, el)
			if not J.t(el) and has("StnFoes"):
				var fid = J.mc(G("StnFoes"), "roll", [sd.lv, q])
				if J.t(fid): J.mc(G("StnFoes"), "decorate", [nw, fid])
			q.list.append(nw)
			if J.t(nw.get("mate")) and J.num(q.made) < J.num(q.n): q["made"] = J.num(q.made) + 1; q.list.append(nw.mate)
		if J.num(q.made) >= J.num(q.n) and J.num(q.t) <= 0: q["st"] = "ready"; q["t"] = 90.0
	elif stt == "ready":
		q["t"] = J.num(q.t) - dt
		if J.num(q.t) <= 0: tf_release(Tf, false)
	J.sp(Tf, "eliteT", J.num(J.gp(Tf, "eliteT")) - dt)
static func tf_release(Tf, manual) -> bool:
	var q = J.gp(Tf, "q"); var stt = J.str(q.st)
	if stt != "ready" and not (J.t(manual) and stt == "form" and J.num(q.made) > 0): return false
	var tt = 0.0; var ls = J.iter(q.list); var W = J.gp(Tf, "walkers")
	for i in ls.size():
		var w = ls[i]
		if J.seq(J.gp(w, "tr"), "couple") and J.t(J.gp(w, "mate")) and i > 0 and is_same(ls[i - 1], w.mate): w["t"] = J.num(ls[i - 1].t) - 0.025
		else: tt -= 0.07; w["t"] = tt
		W.append(w)
	var n = ls.size(); var sd = J.gp(Tf, "sd"); J.sp(sd, "modCur", minf(1.05, J.num(_or(J.gp(sd, "modCur"), 0.9)) + 0.01)); var E = J.gp(J.gp(J.gp(Tf, "lay"), "nodes"), "0E")
	var ns = J.str(n)
	tf_float(Tf, J.num(E[0]) + 0.15, J.num(E[1]) - 0.2, T("放咗 " + ns + " 個人入嚟！", "放了 " + ns + " 個人進來！") if J.t(manual) else T("等足 90 秒，" + ns + " 個人自己行入嚟", "等滿 90 秒，" + ns + " 個人自己走進來"), "#ffe9b0")
	q["st"] = "gap"; q["t"] = 8.0; q["list"] = []; q["made"] = 0.0; q["sq"] = null; tf_sqWaveDone(Tf); J.mc(Tf, "focusOn", [E[0], J.num(E[1]) - 0.3]); return true
static func _foeMul(p) -> float: return J.num(J.mc(G("StnFoes"), "devMul", [p])) if has("StnFoes") else 1.0
static func _pfx(Tf, p, type, tp, aura := false) -> Dictionary:
	var o = {"t": 0.0, "v": 0.0 if randf() < 0.5 else 1.0, "type": type, "k": tf_devK(Tf, p), "tx": tp[0], "ty": tp[1]}
	if aura: o["aura"] = true
	return o
static func tf_devTick(Tf, i, p, dt) -> void:
	dt = J.num(dt)
	if J.num(J.gp(p, "stun")) > 0: p["stun"] = J.num(p.stun) - dt; return
	if has("StnFoes") and J.t(J.mc(G("StnFoes"), "blocks", [p])): return
	var PX = J.num(D.PX); var CELL = J.num(D.CELL); var Dv = J.gp(D.DEV, p.role); var S0 = _devL(p.role, J.gp(p, "sz")); var lvi = J.num(_or(J.gp(p, "lv"), 1.0))
	var L0 = J.gp(J.gp(S0, "lv"), lvi - 1); var M = J.mc(Tf, "staffMul", [p]); var spot = J.gp(J.gp(J.gp(Tf, "lay"), "posts"), J.num(i)); var role = J.str(p.role)
	var amb = (role == "scare" or role == "trap") and J.t(J.mc(Tf, "ambush", [i]))
	var rd = func(w): return tf_rdist(Tf, tf_wp(Tf, w), spot)
	var live = []
	for w in J.iter(J.gp(Tf, "walkers")):
		if tf_alive(Tf, w): live.append(w)
	var atk = J.num(L0[2]) * J.num(M.atk) * (1.3 if amb else 1.0) * _foeMul(p); var reload = J.num(L0[3]) * J.num(M.cd)
	if role == "puzzle": tf_puzzleTick(Tf, i, p, L0, S0, live, rd, atk, M, dt); return
	if role == "slow":
		var R1 = J.num(J.gp(J.gp(S0, "area"), lvi - 1)) * CELL * 0.85; var on = []
		for w in live:
			if rd.call(w) <= R1: on.append(w)
		for w in on: w["slowM"] = minf(J.num(w.slowM) if J.num(J.gp(w, "slowT")) > 0 else 1.0, 1 - J.num(L0[5]) * _foeMul(p)); w["slowT"] = 0.5; w["frost"] = 0.4
		p["auraOn"] = 0.6 if on.size() else J.gp(p, "auraOn")
		p["cd"] = J.num(J.gp(p, "cd")) + dt
		if on.size() and J.num(p.cd) >= reload:
			p["cd"] = 0.0
			for w in on: tf_hit(Tf, w, atk, {"fear": 1.0, "src": "slow"})
			if not J.t(J.gp(p, "fx")): p["fx"] = _pfx(Tf, p, "light", tf_wp(Tf, on[0]), true)
		return
	if J.t(J.gp(p, "win")):
		p.win["t"] = J.num(p.win.t) - dt; var eff = J.num(S0.eff) * PX
		for w in live:
			if not J.t(J.mc(p.win.hit, "has", [w])) and rd.call(w) <= eff:
				J.mc(p.win.hit, "add", [w]); tf_hit(Tf, w, atk, {"fear": 1.0, "aura": 1.0, "src": "aura"} if role == "aura" else {"fright": true, "src": p.role})
		if J.num(p.win.t) <= 0: p["win"] = null; p["cd"] = 0.0
		return
	if J.gp(p, "anim") != null:
		p["anim"] = J.num(p.anim) - dt
		if J.num(p.anim) <= 0:
			p["anim"] = null
			if role == "throw": tf_fire(Tf, i, p, atk, S0, live); p["cd"] = 0.0
			else: p["win"] = {"t": maxf(1.0, J.num(S0.dl)) / 60.0, "hit": J.new_("Set", [])}
		return
	p["cd"] = J.num(J.gp(p, "cd")) + dt
	if J.num(p.cd) < reload: return
	var chk = J.num(S0.check) * PX; var inC = []
	for w in live:
		if rd.call(w) <= chk and ((role != "scare" and role != "throw") or tf_los(Tf, [spot.x, spot.y], tf_wp(Tf, w))): inC.append(w)
	if inC.is_empty():
		if role == "scare":
			for w in live:
				if rd.call(w) <= chk: p["blind"] = 0.5; break
		return
	p["anim"] = J.num(S0.dd) / 60.0; var tg = _ssort(inC, func(w): return -J.num(w.t))[0]; var tp = tf_wp(Tf, tg)
	if role == "aura":
		p["auraOn"] = 1.0; p["flo"] = J.num(J.gp(p, "flo")) - reload
		if J.num(p.flo) <= 0 and not J.t(J.gp(p, "fx")): p["flo"] = Rr(3.5, 5.5); p["fx"] = _pfx(Tf, p, "cold", tp, true)
		return
	p["fx"] = _pfx(Tf, p, J.gp(Dv, "kind"), tp)
	if amb: tf_float(Tf, spot.x, J.num(spot.y) - 0.1, T("埋伏！驚嚇 ×1.3", "埋伏！驚嚇 ×1.3"), "#ffb060")
	if role != "throw": J.mc(Tf, "focusOn", [spot.x, spot.y])
	if role == "scare": J.sp(Tf, "shake", 0.28); J.sp(Tf, "flash", 0.18)
static func tf_fire(Tf, i, p, atk, S0, live) -> void:
	var spot = J.gp(J.gp(J.gp(Tf, "lay"), "posts"), J.num(i)); var seen = []; var walking = []
	for w in live:
		if tf_los(Tf, [spot.x, spot.y], tf_wp(Tf, w)): seen.append(w)
	for w in seen:
		if not (J.num(J.gp(w, "stay")) > 0) and not (J.num(J.gp(w, "block")) > 0): walking.append(w)
	var src = walking if walking.size() else seen
	if src.is_empty(): randf(); return
	var tg = pick(src)
	var to = tf_wp(Tf, tg, 100 * J.num(D.PX))
	J.gp(Tf, "shots").append({"from": [spot.x, J.num(spot.y) - 0.05], "to": to, "t": 0.0, "dur": 0.55, "eff": J.num(S0.eff) * J.num(D.PX), "atk": atk})
	p["fx"] = _pfx(Tf, p, "paper", tf_wp(Tf, tg))
const PZ_SAY := [["又行返嚟呢度？", "又走回這裡？"], ["出口喺邊呀？", "出口在哪啊？"], ["明明行緊直路……", "明明走著直路……"], ["我哋係咪兜緊圈？", "我們是不是在繞圈？"]]
static func tf_puzzleTick(Tf, i, p, L0, S0, live, rd, atk, M, dt) -> void:
	var spot = J.gp(J.gp(J.gp(Tf, "lay"), "posts"), J.num(i)); var mx = J.num(L0[1]) * J.num(M.hp); var fi = J.num(i)
	if J.gp(p, "ph") == null: p["ph"] = mx
	var chk = J.num(S0.check) * J.num(D.PX); var inR = []
	for w in live:
		if rd.call(w) <= chk: inR.append(w)
	if J.num(J.gp(p, "solved")) > 0:
		p["solved"] = J.num(p.solved) - dt
		for w in inR:
			var pz = J.gp(w, "pzIn")
			if not J.seq(J.gp(w, "pzSkip"), fi) and (not J.t(pz) or not J.seq(J.gp(pz, "i"), fi)): w["pzIn"] = {"i": fi, "t": w.t}
		for w in live:
			if J.seq(J.gp(w, "pzSkip"), fi) and rd.call(w) > chk: w["pzSkip"] = null
		if J.num(p.solved) <= 0:
			p["solved"] = 0.0; p["ph"] = mx; var n = 0
			for w in live:
				var pz = J.gp(w, "pzIn")
				if J.t(pz) and J.seq(J.gp(pz, "i"), fi):
					if rd.call(w) <= chk: w["t"] = pz.t; w["block"] = 0.3; w["pulled"] = 1.2; n += 1
					w["pzIn"] = null
			var ns = J.str(n)
			tf_float(Tf, spot.x, J.num(spot.y) - 0.07, T("鬼打牆重新圍返！" + ns + " 個人又兜返轉頭", "鬼打牆重新圍起！" + ns + " 個人又繞回頭") if n else T("鬼打牆重新圍返！", "鬼打牆重新圍起！"), "#c084ff")
		return
	if inR.is_empty(): return
	for w in inR:
		w["block"] = 0.15; w["puz"] = fi; w["fear"] = 0.5; w["lost"] = 0.3
		if not J.t(J.gp(w, "say")) and randf() < 0.01:
			var opts = []
			for s in PZ_SAY: opts.append(T(s[0], s[1]))
			w["say"] = {"s": pick(opts), "t": 1.4}
	var LS = J.num(_or(J.gp(L0, 6.0), 1.0)); var sm = 0.0
	for w in inR:
		var d = J.num(w.d); var d2 = d if d <= LS else LS + ceilf((d - LS) * 0.45)
		sm += (J.num(w.el.atk) if J.t(J.gp(w, "el")) else 10.0) * hpP(d2)
	var avg = sm / inR.size()
	p["ph"] = J.num(p.ph) - avg * sqrt(inR.size()) * dt; p["crack"] = 0.2
	p["cd"] = J.num(J.gp(p, "cd")) + dt
	if J.num(p.cd) >= J.num(L0[3]) * J.num(M.cd):
		p["cd"] = 0.0
		for w in inR: tf_hit(Tf, w, atk, {"fear": 1.0, "aura": 1.0, "src": "puzzle"})
		if not J.t(J.gp(p, "fx")): p["fx"] = _pfx(Tf, p, "phone", tf_wp(Tf, inR[0]))
	if J.num(p.ph) <= 0:
		p["ph"] = 0.0; p["solved"] = L0[4]
		for w in inR: w["block"] = 0.0; w["puz"] = null; w["pzSkip"] = fi
		var ns = J.str(inR.size()); tf_float(Tf, spot.x, J.num(spot.y) - 0.07, T("鬼打牆畀 " + ns + " 個人合力衝破！", "鬼打牆被 " + ns + " 個人合力衝破！"), "#9cf")
const TF_4E := {"los": 2, "queueTick": 1, "release": 1, "devTick": 3, "fire": 5, "puzzleTick": 9}

# 4f：反應／字幕／痕跡／連環跌／路人特性
static func _bossD(Tf) -> float: return J.num(D.BOSS_DMG) * J.num(_or(J.gp(Tf, "bg"), 1.0))
static func _asgn(base: Dictionary, o) -> Dictionary:
	if o is Dictionary:
		for k in o: base[k] = o[k]
	return base
static func tf_lore(Tf, k):
	var LO = J.gp(Tf, "LORE"); var L = J.gp(LO, k)
	if not J.t(L): L = J.gp(LO, "_")
	return J.gp(LO, L.same) if J.t(J.gp(L, "same")) else L
static func tf_cap(Tf, text, x, y, o) -> void:
	if not J.t(J.gp(Tf, "caps")): J.sp(Tf, "caps", [])
	J.gp(Tf, "caps").append(_asgn({"text": text, "x": x, "y": y, "t": 0.0, "life": 1.4, "size": 15.0, "col": "#f4e8ff", "font": "serif", "style": "pop"}, o))
static func tf_act(_Tf, w, pose, t, o) -> void: w["act"] = _asgn({"pose": pose, "t": t, "hold": true, "rot": 0.0}, o)
static func _pk(a: Array):
	var o = []
	for s in a: o.append(T(s[0], s[1]))
	return pick(o)
static func tf_react(Tf, w, kind) -> void:
	tf_wp(Tf, w); var K = kind if J.t(kind) else pick(["scream", "kneel", "head", "fall", "flee"])
	if K == "scream": tf_act(Tf, w, "startle", 1.2, null); w["say"] = {"s": _pk([["呀————！", "啊————！"], ["有鬼呀！！", "有鬼啊！！"], ["救命！！", "救命！！"]]), "t": 1.3}
	elif K == "kneel": tf_act(Tf, w, "cower", 1.6, null); w["say"] = {"s": _pk([["唔好搞我……", "不要搞我……"], ["對唔住對唔住……", "對不起對不起……"]]), "t": 1.4}
	elif K == "head": tf_act(Tf, w, "tremble", 1.5, null); w["say"] = {"s": _pk([["我乜都睇唔到……", "我什麼都看不到……"], ["唔好望唔好望……", "別看別看……"]]), "t": 1.3}
	elif K == "fall": tf_act(Tf, w, "cower", 1.4, {"rot": (-1.0 if randf() < 0.5 else 1.0) * 1.2}); w["say"] = {"s": T("哎呀！", "哎呀！"), "t": 1.0}
	else: w["back"] = J.num(D.CELL) * 1.5; w["say"] = {"s": _pk([["走呀！！", "快跑！！"], ["我唔行喇！", "我不走了！"]]), "t": 1.2}
static func tf_bump(Tf, w0, rad) -> void:
	var R0 = (J.num(rad) if J.t(rad) else 50.0) * J.num(D.PX)
	for o in J.iter(J.gp(Tf, "walkers")):
		if not is_same(o, w0) and tf_alive(Tf, o) and not J.t(J.gp(o, "act")) and tf_dist(tf_wp(Tf, o), tf_wp(Tf, w0)) < R0:
			tf_act(Tf, o, "startle", 0.6, {"rot": 0.35}); o["say"] = {"s": _pk([["咪推呀！", "別推啊！"], ["做咩撞我！", "幹嘛撞我！"]]), "t": 0.9}
static func tf_reroute(Tf, w) -> bool:
	var L = J.gp(Tf, "lay"); var sg = tf_wseg(Tf, w); var E = J.gp(L, "edges")
	if not J.t(sg) or not J.t(J.gp(sg, "k")) or not J.t(J.gp(E, sg.k)): return false
	var pos = tf_wp(Tf, w); var nx = J.iter(J.gp(E, sg.k)); var cur = J.gp(sg, "nk"); var alt = []
	for n in nx:
		if not J.seq(n, cur): alt.append(n)
	var K2 = pick(alt) if alt.size() else null
	if not J.t(K2): return false
	var NS = J.gp(L, "nodes"); var pts = [{"p": pos, "k": "@"}, {"p": J.gp(NS, sg.k), "k": sg.k}]; var k = K2; var g = 0; var prev = sg.k
	while J.t(k) and g < 160:
		g += 1
		pts.append({"p": J.gp(NS, k), "k": k, "hide": J.t(J.mc(J.gp(L, "hide"), "has", [J.str(prev) + ">" + J.str(k)]))})
		var n2 = J.gp(E, k)
		if not J.t(n2) or J.len(n2) == 0: break
		prev = k; k = pick(J.iter(n2))
	tf_mkRoute(Tf, w, pts); w["t"] = 0.001; return true
static func tf_addTrace(Tf, kind, x, y, r, life, o) -> void:
	if not J.t(J.gp(Tf, "traces")): J.sp(Tf, "traces", [])
	J.gp(Tf, "traces").append(_asgn({"kind": kind, "x": x, "y": y, "r": J.num(r) * J.num(D.PX), "life": life, "t": 0.0, "seen": J.new_("Set", [])}, o))
static func tf_segDist(_Tf, p, a, b) -> float:
	var ax = J.num(a[0]); var ay = J.num(a[1]) * 1.5; var bx = J.num(b[0]); var by = J.num(b[1]) * 1.5; var px = J.num(p[0]); var py = J.num(p[1]) * 1.5
	var dx = bx - ax; var dy = by - ay; var l = dx * dx + dy * dy
	if l == 0: l = 1e-9
	var t = maxf(0.0, minf(1.0, ((px - ax) * dx + (py - ay) * dy) / l)); return _hyp(px - ax - dx * t, py - ay - dy * t)
static func tf_chainFall(Tf, w0) -> void:
	var cur = w0; var done = [w0]; var n = 0; var PX = J.num(D.PX)
	for i in 4:
		var p0 = tf_wp(Tf, cur); var cs = []
		for o in J.iter(J.gp(Tf, "walkers")):
			if not tf_alive(Tf, o): continue
			var dn = false
			for d in done:
				if is_same(d, o): dn = true; break
			if dn: continue
			var dd = tf_dist(tf_wp(Tf, o), p0)
			if dd < 90 * PX: cs.append([o, dd])
		if cs.is_empty(): break
		var o = _ssort(cs, func(a): return a[1])[0][0]; done.append(o); n += 1
		o["cb3c"] = 1.0; tf_act(Tf, o, "cower", 1.6 + i * 0.2, {"rot": (-1.0 if i % 2 else 1.0) * 1.25}); tf_hit(Tf, o, _bossD(Tf) * 0.2, {"force": true, "aura": 1.0})
		o["say"] = {"s": _pk([["哎呀！", "哎呀！"], ["咪推呀！", "別推啊！"], ["撞到我喇！", "撞到我了！"]]), "t": 1.2}; cur = o
	if n >= 2:
		var xy = tf_wp(Tf, w0); var ns = J.str(n); tf_cap(Tf, T("連環跌 ×" + ns + "！", "連環跌倒 ×" + ns + "！"), xy[0], J.num(xy[1]) - 0.16, {"col": "#ffb0b0", "style": "pop", "size": 16.0})
static func tf_traceTick(Tf, dt) -> void:
	dt = J.num(dt); var TR = []; var CELL = J.num(D.CELL); var BD = J.num(D.BOSS_DMG); var bg = J.num(_or(J.gp(Tf, "bg"), 1.0))
	for r in J.iter(_or(J.gp(Tf, "traces"), [])):
		r["t"] = J.num(r.t) + dt
		if J.num(r.t) < J.num(r.life): TR.append(r)
	J.sp(Tf, "traces", TR)
	for w in J.iter(J.gp(Tf, "walkers")):
		if not tf_alive(Tf, w): continue
		var p = tf_wp(Tf, w); var on = []; var ks = {}
		for r in TR:
			if tf_dist(p, [r.x, r.y]) < J.num(r.r): on.append(r)
		for r in on: ks[J.str(r.kind)] = true
		if on.size():
			for r in TR:
				if tf_dist(p, [r.x, r.y]) < J.num(r.r) + 0.12: ks[J.str(r.kind)] = true
		if on.is_empty(): continue
		var x = p[0]; var y = J.num(p[1])
		if ks.has("hair") and ks.has("ice") and not J.t(J.gp(w, "cb1")):
			w["cb1"] = 1.0; tf_act(Tf, w, "cower", 2.6, {"rot": 1.3}); tf_hit(Tf, w, BD * bg * 0.6, {"force": true})
			tf_cap(Tf, T("冰髮！跣到四腳朝天！", "冰髮！滑倒在地！"), x, y - 0.1, {"col": "#bfe8ff", "style": "shake", "size": 17.0, "font": "serif"}); J.sp(Tf, "tint", {"col": "rgba(150,210,255,0.25)", "t": 0.8}); continue
		if ks.has("coins") and ks.has("notes") and not J.t(J.gp(w, "cb2")):
			w["cb2"] = 1.0; tf_act(Tf, w, "cower", 3.5, null); w["target"] = 5.0; w["say"] = {"s": T("有錢執呀！", "有錢撿啊！"), "t": 1.5}
			tf_cap(Tf, T("成班人蹲低執錢！（受嚇 ×1.5）", "一群人蹲下撿錢！（受驚 ×1.5）"), x, y - 0.12, {"col": "#ffe08a", "style": "pop", "size": 15.0}); continue
		if ks.has("debt") and J.num(J.gp(w, "amnesia")) > 0 and not (J.num(J.gp(w, "back")) > 0) and not (J.num(J.gp(w, "dbCd")) > 0):
			w["dbCd"] = 1.6; w["cb3"] = J.num(J.gp(w, "cb3")) + 1; w["back"] = CELL * 1.6; tf_bump(Tf, w, 55.0)
			w["say"] = {"s": _pk([["咦？我行過嚟咩？", "咦？我走過來了嗎？"], ["又係你！", "又是你！"]]), "t": 1.2}; tf_hit(Tf, w, BD * 0.25, {"force": true, "aura": 1.0}); tf_chainFall(Tf, w)
			tf_cap(Tf, T("窄口嚟回撞！", "窄口來回撞！"), x, y - 0.1, {"col": "#ff9a9a", "style": "shake", "size": 15.0}); continue
		for r in on:
			var kd = J.str(r.kind)
			if J.t(J.mc(r.seen, "has", [w])):
				if kd in ["hair", "ice", "paper", "clink", "veg"]:
					w["slowM"] = minf(J.num(w.slowM) if J.num(J.gp(w, "slowT")) > 0 else 1.0, 0.6 if (kd == "paper" or kd == "veg") else 0.5); w["slowT"] = 0.3
					if kd == "clink": w["fear"] = 0.5
				continue
			J.mc(r.seen, "add", [w])
			if kd == "veg":
				if randf() < 0.3: tf_act(Tf, w, "cower", 1.2, {"rot": 1.1}); w["say"] = {"s": T("踩親啲菜心！", "踩到菜心了！"), "t": 1.0}
			elif kd == "hair":
				if randf() < 0.45: tf_act(Tf, w, "cower", 1.3, {"rot": 1.1}); w["say"] = {"s": T("啲頭髮好滑！", "頭髮好滑！"), "t": 1.0}
			elif kd == "ice":
				if randf() < 0.45: tf_act(Tf, w, "cower", 1.3, {"rot": -1.1}); w["frost"] = 1.2
			elif kd == "shadow": w["back"] = CELL * 1.2; w["say"] = {"s": _pk([["頭先嗰個白影係咩？", "剛剛那個白影是什麼？"], ["我唔過去喇……", "我不過去了……"]]), "t": 1.4}
			elif kd == "bowl": tf_act(Tf, w, "idle", 1.6, null); w["say"] = {"s": T("邊個個碗喺度轆？", "誰的碗在滾？"), "t": 1.3}
			elif kd == "claw": w["fear"] = 1.5; tf_hit(Tf, w, BD * bg * 0.15, {"force": true, "aura": 1.0})
			elif kd == "coins" or kd == "notes": tf_act(Tf, w, "cower", 1.6, null); w["say"] = {"s": T("跌咗啲散紙！", "掉了零錢！") if kd == "coins" else T("有張銀紙！", "有張鈔票！"), "t": 1.2}
			elif kd == "cloth":
				if tf_reroute(Tf, w): w["say"] = {"s": T("嗰邊有白布……行第二條路", "那邊有白布……走另一條"), "t": 1.4}
			elif kd == "ring": tf_hit(Tf, w, BD * bg * 0.35, {"force": true, "fright": 1.0}); tf_react(Tf, w, "scream")
			elif kd == "soup": w["amnesia"] = 6.0; w["back"] = CELL; w["say"] = {"s": T("我頭先想去邊？", "我剛剛要去哪？"), "t": 1.3}
			elif kd == "debt": w["back"] = CELL * 1.2; tf_bump(Tf, w, 50.0); w["say"] = {"s": T("唔好搵我！", "別找我！"), "t": 1.2}
			elif kd == "clink": w["fear"] = 1.0; w["say"] = {"s": T("邊個喺度數錢？", "誰在數錢？"), "t": 1.2}
	var ck = []
	for q in J.iter(_or(J.gp(Tf, "caps"), [])):
		q["t"] = J.num(q.t) + dt
		if J.num(q.t) < J.num(q.life): ck.append(q)
	J.sp(Tf, "caps", ck)
	var tn = J.gp(Tf, "tint")
	if J.t(tn):
		tn["t"] = J.num(tn.t) - dt
		if J.num(tn.t) <= 0: J.sp(Tf, "tint", null)
static func _postXY(Tf, i): var s = J.gp(J.gp(J.gp(Tf, "lay"), "posts"), float(i)); return [s.x, s.y]
static func tf_traitTick(Tf, w, dt) -> void:
	dt = J.num(dt); w["tT"] = J.num(J.gp(w, "tT")) - dt; var p0 = tf_wp(Tf, w); var PX = J.num(D.PX); var tr = J.str(J.gp(w, "tr")); var SP = J.iter(J.gp(J.gp(Tf, "sd"), "posts")); var tT = J.num(w.tT)
	if tr == "torch" and tT <= 0:
		w["tT"] = 6.0; var best = -1; var bd = 1e9
		for i in SP.size():
			var p = SP[i]
			if not J.t(p) or not J.t(J.gp(p, "role")) or J.num(J.gp(p, "build")) > 0: continue
			var sp = _postXY(Tf, i); var d = tf_dist(p0, sp)
			if d < 200 * PX and d < bd and tf_los(Tf, p0, sp): bd = d; best = i
		if best >= 0:
			var p = SP[best]; p["stun"] = 2.5; w["beam"] = {"i": float(best), "t": 1.0}
			w["say"] = {"s": _pk([["邊個喺度？照下先！", "誰在那？先照一下！"], ["出嚟！我見到你喇！", "出來！我看到你了！"]]), "t": 1.4}
			var sp = _postXY(Tf, best); tf_cap(Tf, T("電筒照住！設備停 2.5 秒", "手電筒照住！設備停 2.5 秒"), sp[0], J.num(sp[1]) - 0.1, {"col": "#fff3b0", "size": 12.0, "style": "pop", "font": "sans-serif"})
	elif tr == "calm" and tT <= 0:
		w["tT"] = 1.0
		for q in J.iter(J.gp(Tf, "walkers")):
			if not is_same(q, w) and tf_alive(Tf, q) and tf_dist(tf_wp(Tf, q), p0) < 120 * PX:
				q["hp"] = minf(J.num(q.max), J.num(q.hp) + J.num(q.max) * 0.02)
				if J.num(J.gp(q, "stay")) > 0.6: q["stay"] = J.num(q.stay) - 0.5
				q["calmFx"] = 0.6
	elif tr == "photo" and tT <= 0:
		w["tT"] = Rr(5, 9); tf_act(Tf, w, "idle", 1.5, null); w["flash"] = 0.25; w["say"] = {"s": T("影張相先！", "先拍張照！"), "t": 1.2}
		for i in SP.size():
			var p = SP[i]
			if J.t(p) and J.t(J.gp(p, "role")) and tf_dist(p0, _postXY(Tf, i)) < 150 * PX: p["stun"] = maxf(J.num(J.gp(p, "stun")), 1.0)
	elif tr == "emf" and tT <= 0:
		w["tT"] = Rr(7, 10); var near = false
		for i in SP.size():
			var p = SP[i]
			if J.t(p) and J.t(J.gp(p, "role")) and not (J.num(J.gp(p, "build")) > 0) and tf_dist(p0, _postXY(Tf, i)) < 160 * PX: near = true
		if near:
			tf_act(Tf, w, "idle", 1.4, null); tf_float(Tf, p0[0], J.num(p0[1]) - 0.09, T("嗶嗶嗶——", "嗶嗶嗶——"), "#9ef07a")
			w["say"] = {"s": _pk([["讀數爆錶！就喺呢度！", "讀數爆表！就在這裡！"], ["等等，我量多次先！", "等等，我再量一次！"]]), "t": 1.3}
	elif tr == "drunk" and tT <= 0:
		w["tT"] = Rr(3, 6)
		if randf() < 0.45: w["back"] = J.num(D.CELL) * 0.7; w["say"] = {"s": _pk([["嗝～行錯路……", "嗝～走錯路……"], ["再飲多杯……", "再喝一杯……"]]), "t": 1.2}
	elif tr == "couple" and J.t(J.gp(w, "mate")) and tT <= 0:
		w["tT"] = Rr(6, 10)
		if randf() < 0.5: var re = J.iter(J.gp(w.p, "re")); var a = pick(re); var b = pick(re); w["say"] = {"s": T(a[0], b[1]), "t": 1.2}
	if J.t(J.gp(w, "beam")):
		w.beam["t"] = J.num(w.beam.t) - dt
		if J.num(w.beam.t) <= 0: w["beam"] = null
	if J.num(J.gp(w, "flash")) > 0: w["flash"] = J.num(w.flash) - dt
	if J.num(J.gp(w, "calmFx")) > 0: w["calmFx"] = J.num(w.calmFx) - dt
static func tf_walkerFx(Tf, w, dt) -> bool:
	dt = J.num(dt)
	if J.t(J.gp(w, "tr")) and tf_alive(Tf, w): tf_traitTick(Tf, w, dt)
	for f in ["amnesia", "target", "breath", "dbCd"]:
		if J.num(J.gp(w, f)) > 0: w[f] = J.num(w[f]) - dt
	if J.t(J.gp(w, "lift")):
		w.lift["t"] = J.num(w.lift.t) + dt
		if J.num(w.lift.t) >= J.num(w.lift.dur):
			w["lift"] = null; tf_act(Tf, w, "cower", 1.2, {"rot": 1.2}); tf_hit(Tf, w, _bossD(Tf) * 0.3, {"force": true, "fright": 1.0}); w["say"] = {"s": T("呀——！", "啊——！"), "t": 1.0}
		return true
	if J.t(J.gp(w, "fly")):
		w.fly["t"] = J.num(w.fly.t) + dt
		if J.num(w.fly.t) >= J.num(w.fly.dur): w["fly"] = null; tf_act(Tf, w, "cower", 1.3, {"rot": 1.3}); w["say"] = {"s": T("痛呀……", "好痛……"), "t": 1.0}
		return true
	if J.t(J.gp(w, "chase")):
		w.chase["t"] = J.num(w.chase.t) + dt
		if randf() < dt * 3: tf_bump(Tf, w, 45.0)
		if J.num(w.chase.t) >= J.num(w.chase.dur): w["chase"] = null
		return true
	if J.t(J.gp(w, "act")):
		w.act["t"] = J.num(w.act.t) - dt
		if J.num(w.act.t) <= 0: w["act"] = null
		elif J.t(w.act.hold): return true
	return false
const TF_4F := {"lore": 1, "cap": 4, "act": 4, "react": 2, "bump": 2, "reroute": 1, "addTrace": 6, "segDist": 3, "chainFall": 1, "traceTick": 1, "traitTick": 2, "walkerFx": 2}

static func _m(f: Callable, n: int) -> Callable:
	# 包成 JS 方法：f(this, a0, a1…)；參數唔夠補 null
	return func(this_, a: Array):
		var args = [this_]
		for i in n: args.append(a[i] if i < a.size() else null)
		return f.callv(args)
const TF_4A := {"P": 2, "buildPath": 0, "at": 1, "mkRoute": 2, "wp": 2, "camStep": 0, "zFit": 0, "camClamp": 0, "toScreen": 2, "toScene": 2, "focusOn": 2,
	"upCost": 1, "stats": 3, "fixPosts": 0, "lvCap": 0, "incomeCap": 0, "mod": 0, "unit": 0, "build": 0, "rect": 1, "rdist": 2, "wseg": 1, "runPos": 1, "alive": 1, "staffMul": 1, "devK": 1}
static func turf_methods(group: Dictionary) -> Dictionary:
	var out = {}
	for k in group: out[k] = _m(Callable(load("res://native/street.gd"), "tf_" + k), group[k])
	out.erase("dist")
	return out
static func tf_install(Tf, group: Dictionary) -> void:
	var M = turf_methods(group)
	for k in M: J.sp(Tf, k, M[k])
	if group == TF_4A: J.sp(Tf, "dist", func(_this, a): return tf_dist(J.arg(a, 0), J.arg(a, 1)))

func run(_env) -> void:
	# 未完成段落：暫時用轉譯版
	var tr = (load("res://jsgen/street.gd") as GDScript).new(); _tr_keep.append(tr); tr.run(null)
	# 已完成段落：原生覆蓋
	J.G["__stDC"] = func(_t, a): stDC(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.arg(a, 5)); return null
	J.G["CrUI"] = mk_crui()
	J.G["DevFx"] = mk_devfx()
	# 第三段：Street 匯出物件原生（Turf 未改寫：暫時用轉譯版 Turf；轉譯版自己嘅 devTick 計時器照行，用 devT 時間戳，唔會重複計）
	load_data()
	SQ = mk_street(J.gp(J.G.get("Street"), "Turf"))
	J.G["Street"] = SQ
	tf_install(J.gp(SQ, "Turf"), TF_4A); tf_install(J.gp(SQ, "Turf"), TF_4B); tf_install(J.gp(SQ, "Turf"), TF_4C); tf_install(J.gp(SQ, "Turf"), TF_4D); tf_install(J.gp(SQ, "Turf"), TF_4E); tf_install(J.gp(SQ, "Turf"), TF_4F)
	if J.G.get("window") != null and J.gp(J.G.window, "Street") != null: J.sp(J.G.window, "Street", SQ)
