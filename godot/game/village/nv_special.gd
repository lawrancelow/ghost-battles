# 拆唔開嘅角色（Penanggal／Pocong／Toyol）網格變形——special.js 原生版
# 每隻實例一個 NvSpecial（存彈簧、攻擊計時）；draw() 計好頂點後用三角形一次畫（共用頂點，唔會有裂縫）
class_name NvSpecial
extends RefCounted

const H0 := {"penanggal": 52.0, "pocong": 54.0, "toyol": 46.0}
const GRID := {"penanggal": [7, 18], "pocong": [3, 18], "toyol": [5, 18]}
const PUV := {"penanggal": [0.46, 0.37, 4.5], "pocong": [0.5, 1.0, 1.6], "toyol": [0.5, 0.62, 4.0]}
const ADUR := 0.55
const HDUR := 0.45
const HOP_SY := [[0.0, 1.0], [0.15, 0.84], [0.24, 1.14], [0.45, 1.03], [0.62, 1.08], [0.70, 1.1], [0.78, 0.8], [0.89, 1.05], [1.0, 1.0]]
const PB_KEYS := [[0.0, 0.72], [0.12, 1.22], [0.5, 1.04], [0.85, 1.12], [1.0, 1.1]]

static var _mask := {}
static var _idx := {}

var type := ""
var L := 0.0
var V := 0.0
var lx := 1e9
var seen := 0
var aclk := -1.0
var atk_on := false
var hclk := -1.0
var hurt_on := false
var dt := 0.0
var gc: Array = []     # 姿勢快取 [x,y,r,sx,sy,c,s]
var gc_ok: Array = []
var frame_id := 0
var o: Dictionary
var P := {"t": 0.0, "L": 0.0, "flop": 0.0, "jel": 0.0, "hr": 0.0, "sj": 0.0, "Wd": 0.0, "H": 0.0}

static func has(t: String) -> bool: return GRID.has(t) and PtGfx.tex(t) != null

func _init(t: String) -> void:
	type = t
	for i in 40: gc.append([0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0.0]); gc_ok.append(-1)

static func sm(a: float, b: float, x: float) -> float:
	x = clampf((x - a) / (b - a), 0, 1); return x * x * (3 - 2 * x)
static func lerp_keys(K: Array, p: float) -> float:
	for i in range(1, K.size()):
		if p <= K[i][0]:
			var a = K[i - 1]; var b = K[i]; var q = (p - a[0]) / (b[0] - a[0]); return a[1] + (b[1] - a[1]) * (0.5 - 0.5 * cos(PI * q))
	return K[K.size() - 1][1]

# ---------------- 狀態（彈簧、攻擊計時）----------------
func _state(x: float, flip: bool) -> void:
	var now = Time.get_ticks_msec()
	var d = 0.0 if seen == 0 else (now - seen) / 1000.0
	dt = clampf(d, 0, 0.05)
	var dx = x - lx if lx < 1e8 else 0.0
	if absf(dx) > 40: dx = 0.0
	L -= -dx if flip else dx
	for i in 2:
		var h = dt / 2; var a = -170 * L - 9 * V; V += a * h; L += V * h
	L = clampf(L, -9, 9)
	lx = x; seen = now

func _progress() -> Array:
	var pa = -1.0; var ph = -1.0
	var pose = o.get("pose")
	if pose in ["windup", "strike", "recover", "cast", "attack"] and o.get("pt") != null:
		var p = float(o.pt)
		match pose:
			"windup": pa = 0.3 * minf(1, p)
			"strike": pa = 0.3 + 0.4 * minf(1, p)
			"recover": pa = 0.7 + 0.3 * minf(1, p)
			_: pa = minf(1, p)
	else:
		if o.get("atk", false) and not atk_on: aclk = 0
		atk_on = bool(o.get("atk", false))
		if aclk >= 0:
			pa = aclk / ADUR; aclk += dt
			if pa > 1.6: aclk = -1
	if (pose == "hurt" or pose == "die") and o.get("pt") != null: ph = minf(1, float(o.pt))
	else:
		if o.get("hurt", false) and not hurt_on: hclk = 0
		hurt_on = bool(o.get("hurt", false))
		if hclk >= 0:
			ph = hclk / HDUR; hclk += dt
			if ph > 1.6: hclk = -1
	return [pa, ph]

# ---------------- 各角色 drive／weights／local／lag／gain ----------------
func _hopping() -> bool: return o.get("walk", false) or o.get("enemy", false) or o.get("work", false)
func _hop(tt: float) -> Array:
	var rate = 2.2 if o.get("work", false) else (1.55 if o.get("walk", false) else 1.25); var h = 2.5 if o.get("work", false) else (7.0 if o.get("walk", false) else 4.5)
	var f = tt * rate; return [f - floor(f), h]

func _drive(G: Array, tt: float, pa: float, ph: float, hf: float) -> void:
	var x = 0.0; var y = 0.0; var r = 0.0; var sx = 1.0; var sy = 1.0
	var walk = o.get("walk", false); var work = o.get("work", false)
	match type:
		"penanggal":
			x = sin(tt * 1.3) * 1.2; y = -4 - sin(tt * 2.6) * 2.2; r = sin(tt * 1.3 + 0.6) * 0.06
			if walk: y -= sin(tt * 5.2) * 1.6; r += 0.1 + sin(tt * 5.2 + 0.8) * 0.05; x += sin(tt * 2.6) * 1
			if work: r += sin(tt * 7) * 0.07; y -= absf(sin(tt * 7)) * 1.5
			if pa >= 0:
				var p = clampf(pa, 0, 1)
				var a1 = sm(0, 0.25, p) * (1 - sm(0.27, 0.4, p)); x -= 5 * a1; r -= 0.22 * a1; sy *= 1 + 0.08 * a1; sx *= 1 - 0.06 * a1; y += 1.5 * a1
				var l = sm(0.25, 0.47, p) * (1 - sm(0.62, 1, p)); x += 13 * l; r += 0.08 * l; y += 2 * l
				var st = sin(PI * l); sx *= 1 + 0.22 * st; sy *= 1 - 0.13 * st
				if p > 0.44 and p < 0.7:
					var q = (p - 0.44) / 0.26; var c = absf(sin(q * TAU)) * sin(q * PI) * hf; sy *= 1 - 0.18 * c; sx *= 1 + 0.12 * c
			if ph >= 0 and ph < 1:
				var k = 1 - ph; var k2 = k * k * sm(0, 0.16, ph); var j = sin(ph * 22) * k * sm(0, 0.06, ph) * hf; x -= 7 * k2; y -= 2 * k2; r -= 0.3 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j
		"pocong":
			var atk = pa >= 0 and pa < 1
			if atk:
				var p = maxf(0, pa)
				if p < 0.25: var q = sm(0, 0.25, p); sy = 1 - 0.28 * q; r = -0.08 * q
				elif p < 0.62:
					var q = (p - 0.25) / 0.37; y = -22 * 4 * q * (1 - q); x = 11 * sm(0, 1, q); sy = lerp_keys(PB_KEYS, q); r = 0.18 * sin(PI * q)
				elif p < 0.72: var q = sm(0.62, 0.72, p); x = 11; sy = 1.1 - 0.42 * q
				else:
					var k = (p - 0.72) / 0.28; x = 11 * (1 - sm(0, 1, k)); sy = 1 - 0.32 * (1 - k) * (1 - k) * cos(k * 3 * PI)
				sx = 1 / pow(sy, 0.7)
			elif _hopping():
				var hh = _hop(tt); var f = hh[0]; var h = hh[1]
				sy = lerp_keys(HOP_SY, f); sx = 1 / pow(sy, 0.6)
				if f > 0.2 and f < 0.7:
					var q = (f - 0.2) / 0.5; y = -h * 4 * q * (1 - q); r = (0.08 if walk else 0.04) * sin(PI * q)
					if walk: x = (q - 0.5) * 2.5
				elif walk: x = 1.25 if f > 0.7 else -1.25
			else:
				r = sin(tt * 1.6) * 0.035; sy = 1 + sin(tt * 2.2) * 0.015; sx = 1 - sin(tt * 2.2) * 0.01
			if ph >= 0 and ph < 1:
				var k = 1 - ph; var k2 = k * k * sm(0, 0.16, ph); var j = sin(ph * 20) * k * sm(0, 0.06, ph) * hf; x -= 4 * k2; r -= 0.22 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j
		"toyol":
			x = sin(tt * 1.4) * 0.8; y = -sin(tt * 2.8) * 1.0; r = sin(tt * 1.7) * 0.05; sy = 1 + sin(tt * 3.0) * 0.02; sx = 1 - sin(tt * 3.0) * 0.012
			if walk: r += 0.15 + sin(tt * 6) * 0.03; y += sin(tt * 6) * 0.9
			if work: y -= absf(sin(tt * 6)) * 1.8; r += sin(tt * 6) * 0.06
			if pa >= 0:
				var p = clampf(pa, 0, 1)
				var a1 = sm(0, 0.22, p) * (1 - sm(0.22, 0.32, p)); x -= 4 * a1; r -= 0.14 * a1; sx *= 1 + 0.08 * a1; sy *= 1 - 0.1 * a1; y += 1 * a1
				var l = sm(0.22, 0.4, p) * (1 - sm(0.74, 1, p)); x += 15 * l; r += 0.2 * sin(PI * sm(0.22, 0.4, p)) + 0.06 * l
				var st = sin(PI * l); sx *= 1 + 0.26 * st; sy *= 1 - 0.14 * st
				if p > 0.4 and p < 0.74:
					var q = (p - 0.4) / 0.34; var b = sin(q * 3 * PI) * (1 - q) * hf; sy *= 1 - 0.1 * b; sx *= 1 + 0.07 * b
			if ph >= 0 and ph < 1:
				var k = 1 - ph; var k2 = k * k * sm(0, 0.16, ph); var j = sin(ph * 22) * k * sm(0, 0.06, ph) * hf; x -= 6 * k2; r -= 0.28 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j
	G[0] = x; G[1] = y; G[2] = r; G[3] = sx; G[4] = sy

func _weights(u: float, v: float, W: Dictionary) -> void:
	match type:
		"penanggal":
			var rr = Vector2((u - 0.46) / 0.31, (v - 0.37) / 0.29).length()
			W.hw = sm(0.8, 1.6, rr); W.dw = maxf(W.hw, sm(0.52, 0.95, v))
			var eu = (u - 0.43) / 0.17; W.ew = sm(0.5, 0.9, v) * exp(-eu * eu)
		"pocong":
			W.kw = 1 - sm(0.03, 0.26, v); W.bw = sin(PI * clampf((v - 0.2) / 0.75, 0, 1))
		"toyol":
			W.hw = 1 - sm(0.36, 0.5, v); W.bw = sm(0.4, 0.48, v) * (1 - sm(0.68, 0.76, v))
			var su = (u - 0.8) / 0.17; var sv = (v - 0.55) / 0.15; W.sw = exp(-(su * su + sv * sv)); W.tw = sm(0.68, 1, v)

func _local(u: float, v: float, W: Dictionary) -> Vector2:
	var t: float = P.t
	match type:
		"penanggal":
			var dw: float = W.dw
			return Vector2(dw * (sin(t * 3.1 - v * 7 + u * 2) * 1.4 + sin(t * 1.9 - v * 4.3 + u) * 0.7) * (0.35 + 0.9 * v) + W.ew * sin(t * 2.1 - v * 3.2) * 2.4 * (v - 0.5) * 2 + P.L * dw * v * 1.1,
				W.hw * sin(t * 2.4 - u * 6) * 0.5 + W.ew * sin(t * 4.2 - v * 5) * 0.4)
		"pocong":
			var kw: float = W.kw
			return Vector2(kw * (sin(t * 3.3) * 0.9 + P.flop * 1.8 + P.L * 1.6) * (1.2 - v * 2) + W.bw * P.L * 0.35 + W.bw * P.jel * sin(v * 9 - t * 20) * 0.6, kw * sin(t * 2.6 + u * 3) * 0.3)
		"toyol":
			var tw = pow(W.tw, 1.3); var a = W.hw * P.hr; var ox = (u - 0.5) * P.Wd; var oy = (v - 0.45) * P.H
			var x = ox * cos(a) - oy * sin(a) - ox; var y = ox * sin(a) + oy * cos(a) - oy
			x += W.bw * (u - 0.55) * P.Wd * 0.05 * sin(t * 3)
			y += W.bw * (0.6 - v) * P.H * 0.03 * sin(t * 3) + W.hw * sin(t * 2.8 - 0.6) * 0.5
			x += tw * (sin(t * 4.2 - v * 8) * 2.4 + P.L * 1.6); y += tw * sin(t * 3.1 - v * 6) * 0.4
			x += W.sw * P.sj * sin(t * 37) * 1.4; y += W.sw * (sin(t * 3 + 1) * 0.8 + P.sj * sin(t * 29 + 1) * 1.8)
			return Vector2(x, y)
	return Vector2.ZERO

func _lag(W: Dictionary) -> float:
	match type:
		"penanggal": return W.dw * (0.04 + 0.2 * W.get("_v", 0.0)) + W.ew * 0.06
		"pocong": return W.kw * 0.07 + W.bw * 0.02
		"toyol": return W.hw * 0.06 + W.tw * 0.16
	return 0.0
func _gain(W: Dictionary) -> float:
	match type:
		"penanggal": return 1 + 0.12 * W.dw
		"pocong": return 1 + 0.4 * W.kw
		"toyol": return 1 + 0.5 * W.tw
	return 1.0

var _tmp := [0.0, 0.0, 0.0, 1.0, 1.0]
func _pose_at(idx: int, t: float, pa: float, ph: float) -> Array:
	var G: Array = gc[idx]
	if gc_ok[idx] == frame_id: return G
	var base = idx / 60.0
	if idx == 0: _drive(G, t, pa, ph, 1)
	else:
		var ax = 0.0; var ay = 0.0; var ar = 0.0; var asx = 0.0; var asy = 0.0
		for m in 5:
			var lg = base * (0.3 + 0.35 * m)
			_drive(_tmp, t - lg, pa - lg / ADUR if pa >= 0 else -1.0, ph - lg / HDUR if ph >= 0 else -1.0, exp(-lg * 18))
			ax += _tmp[0] * 0.2; ay += _tmp[1] * 0.2; ar += _tmp[2] * 0.2; asx += _tmp[3] * 0.2; asy += _tmp[4] * 0.2
		G[0] = ax; G[1] = ay; G[2] = ar; G[3] = asx; G[4] = asy
	G[5] = cos(G[2]); G[6] = sin(G[2]); gc_ok[idx] = frame_id
	return G

static func _apply(G: Array, bx: float, by: float, px: float, py: float) -> Vector2:
	var dx = (bx - px) * G[3]; var dy = (by - py) * G[4]
	return Vector2(px + dx * G[5] - dy * G[6] + G[0], py + dx * G[6] + dy * G[5] + G[1])

# 每格有冇內容（透明格唔畫）→ 三角形索引
static func _indices(t: String, img: Texture2D, cols: int, rows: int) -> PackedInt32Array:
	if _idx.has(t): return _idx[t]
	var im = img.get_image()
	if im and im.is_compressed(): im.decompress()
	var iw = img.get_width(); var ih = img.get_height()
	var out = PackedInt32Array(); var nx = cols + 1
	for j in rows:
		for i in cols:
			var any = im == null
			if im:
				var x0 = int(float(i) / cols * iw); var x1 = int(float(i + 1) / cols * iw); var y0 = int(float(j) / rows * ih); var y1 = int(float(j + 1) / rows * ih)
				var y = y0
				while y < y1 and not any:
					var x = x0
					while x < x1:
						if im.get_pixel(mini(x, im.get_width() - 1), mini(y, im.get_height() - 1)).a > 4.0 / 255.0: any = true; break
						x += 3
					y += 3
			if not any: continue
			var k = j * nx + i
			out.append_array([k, k + 1, k + nx, k + 1, k + nx + 1, k + nx])
	_idx[t] = out
	return out

# 畫：ci = 畫布節點；M = 世界 → 節點本地；x0,y0 腳底；s 縮放；oo = 動作選項（t、walk、work、enemy、flip、pose、pt、atk、hurt、alpha）
func draw(ci: CanvasItem, M: Transform2D, x0: float, y0: float, s: float, oo: Dictionary) -> void:
	o = oo
	var img: Texture2D = PtGfx.tex(type)
	if img == null: return
	var iw = img.get_width(); var ih = img.get_height()
	var t: float = float(o.get("t", 0.0)); var H: float = H0[type]; var Wd = H * iw / ih
	var cols: int = GRID[type][0]; var rows: int = GRID[type][1]; var pu: float = PUV[type][0]; var pv: float = PUV[type][1]; var cap: float = PUV[type][2]
	_state(x0, bool(o.get("flip", false)))
	var pp = _progress(); var pa: float = pp[0]; var ph: float = pp[1]
	frame_id += 1
	var px = (pu - 0.5) * Wd; var py = -(1 - pv) * H
	P.t = t; P.L = L / maxf(0.3, s); P.Wd = Wd; P.H = H; P.flop = 0.0; P.jel = 0.0; P.hr = 0.0; P.sj = 0.0
	var dust_k = -1.0; var dust_big = false
	if type == "pocong":
		if pa >= 0 and pa < 1:
			if pa > 0.62: dust_k = (pa - 0.62) / 0.38; dust_big = true; P.jel = maxf(0, 1 - (pa - 0.62) / 0.3)
			P.flop = sin(pa * TAU * 1.5) * (1 - pa)
		elif _hopping():
			var hh = _hop(t); var f = hh[0]; var h = hh[1]
			P.flop = sin(f * TAU - 1.2) * (h / 6)
			if f > 0.7 and h > 3: dust_k = (f - 0.7) / 0.3
			if f > 0.7: P.jel = (1 - (f - 0.7) / 0.3) * 0.6
		if ph >= 0 and ph < 1: P.jel = maxf(P.jel, 1 - ph)
	elif type == "toyol":
		P.hr = sin(t * 1.9 + 0.4) * 0.07 + (0.05 if o.get("walk", false) else 0.0)
		if pa >= 0 and pa < 1: P.sj = sm(0.36, 0.45, pa) * (1 - sm(0.7, 0.85, pa)); P.hr += -0.12 * sm(0.22, 0.4, pa) * (1 - sm(0.4, 0.6, pa))
		if ph >= 0 and ph < 1: P.sj = maxf(P.sj, (1 - ph) * 0.8); P.hr -= 0.2 * (1 - ph) * (1 - ph)
	var nx = cols + 1
	var VX = PackedFloat32Array(); VX.resize(nx * (rows + 1)); var VY = PackedFloat32Array(); VY.resize(nx * (rows + 1))
	var uvs = PackedVector2Array(); uvs.resize(nx * (rows + 1))
	var W = {}
	var G0 = _pose_at(0, t, pa, ph)
	for j in rows + 1:
		var v = float(j) / rows
		for i in nx:
			var u = float(i) / cols
			_weights(u, v, W); W["_v"] = v
			var lo = _local(u, v, W)
			var bx = (u - 0.5) * Wd + lo.x; var by = -(1 - v) * H + lo.y
			var p0 = _apply(G0, bx, by, px, py)
			var X = p0.x; var Y = p0.y
			var lf = minf(38.999, _lag(W) * 60)
			if lf > 0.001:
				var g = _gain(W); var li = int(floor(lf)); var fr = lf - li
				var pa1 = _apply(_pose_at(li, t, pa, ph), bx, by, px, py); var pb1 = _apply(_pose_at(li + 1, t, pa, ph), bx, by, px, py)
				var ox = pa1.x + (pb1.x - pa1.x) * fr; var oy = pa1.y + (pb1.y - pa1.y) * fr
				var ddx = (ox - X) * g; var ddy = (oy - Y) * g; var m = sqrt(ddx * ddx + ddy * ddy)
				if m > 1e-4: var q = cap * tanh(m / cap) / m; ddx *= q; ddy *= q
				X += ddx; Y += ddy
			var k = j * nx + i; VX[k] = x0 + X * s; VY[k] = y0 + Y * s; uvs[k] = Vector2(u, v)
	var mnX = 0.25 * Wd / cols * s; var mnY = 0.25 * H / rows * s
	for j in rows + 1:
		for i in range(1, nx):
			var k = j * nx + i
			if VX[k] < VX[k - 1] + mnX: VX[k] = VX[k - 1] + mnX
	for i in nx:
		for j in range(1, rows + 1):
			var k = j * nx + i
			if VY[k] < VY[k - nx] + mnY: VY[k] = VY[k - nx] + mnY
	var pts = PackedVector2Array(); pts.resize(VX.size())
	for k in VX.size(): pts[k] = M * Vector2(VX[k], VY[k])
	var a = float(o.get("alpha", 1.0))
	var cols_arr = PackedColorArray(); cols_arr.resize(pts.size()); cols_arr.fill(Color(1, 1, 1, a))
	var idx = _indices(type, img, cols, rows)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	# Toyol 衝刺拖影：用延遲姿勢畫成整張（淡）
	if type == "toyol" and pa >= 0 and pa < 1:
		var Ga = _pose_at(0, t, pa, ph); var Gb = _pose_at(2, t, pa, ph); var spd = absf(Ga[0] - Gb[0]) * 30
		if spd > 25:
			var amt = minf(1, (spd - 25) / 120)
			for ii in range(4, 0, -1):
				var G = _pose_at(ii * 2, t, pa, ph)
				var A = Transform2D(Vector2(G[3] * G[5], G[3] * G[6]), Vector2(-G[4] * G[6], G[4] * G[5]), Vector2.ZERO)
				A.origin = Vector2(px + G[0], py + G[1]) - A.basis_xform(Vector2(px, py))
				var X2 = M * Transform2D(0, Vector2(x0, y0)) * Transform2D(Vector2(s, 0), Vector2(0, s), Vector2.ZERO) * A
				ci.draw_set_transform_matrix(X2); ci.draw_texture_rect(img, Rect2(-Wd / 2, -H, Wd, H), false, Color(1, 1, 1, a * amt * 0.22 * (1 - ii / 5.0)))
			ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	RenderingServer.canvas_item_add_triangle_array(ci.get_canvas_item(), idx, pts, cols_arr, uvs, PackedInt32Array(), PackedFloat32Array(), img.get_rid())
	if dust_k > 0 and dust_k < 1:
		var ctx = Ctx.new(ci, M)
		var n = 5 if dust_big else 3; var al = (1 - dust_k) * (0.55 if dust_big else 0.4)
		ctx.fillStyle = "rgba(214,204,184,%.3f)" % al
		for i in n:
			for sd in [-1, 1]:
				var d = (10.0 if dust_big else 6.0) + dust_k * (18.0 if dust_big else 10.0) + i * 3.2; var rr = (3.4 if dust_big else 2.4) * (0.6 + dust_k * 0.9) * (1 - i * 0.12)
				ctx.beginPath(); ctx.ellipse(x0 + sd * d * s, y0 - (1 + i * 0.6 + dust_k * 2.5 * (1 + (i & 1))) * s, rr * s, rr * 0.7 * s, 0, 0, TAU); ctx.fill()
