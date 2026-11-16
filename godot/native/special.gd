# 原生改寫自 special.js（拆不開的角色 Penanggal／Pocong／Toyol：網格變形動畫）
# 介面同轉譯版一樣：J.G["SPECIAL"] = { has, draw, _dbg }；draw(ctx, type, x0, y0, s, o) 經 ctx（Ctx／錄製器）逐格 drawImage，算法同網頁版
# 修正：轉譯版嘅格子遮罩靠 canvas getImageData（Godot 回傳 null）→ 遮罩全 0、角色唔見；呢度直接由貼圖透明度計
extends RefCounted

const TAU_ := TAU
const H0 := {"penanggal": 52.0, "pocong": 54.0, "toyol": 46.0}
const ADUR := 0.55
const HDUR := 0.45
const HOP_SY := [[0.0, 1.0], [0.15, 0.84], [0.24, 1.14], [0.45, 1.03], [0.62, 1.08], [0.70, 1.1], [0.78, 0.8], [0.89, 1.05], [1.0, 1.0]]
const PB_KEYS := [[0.0, 0.72], [0.12, 1.22], [0.5, 1.04], [0.85, 1.12], [1.0, 1.1]]
const DEF := {"penanggal": {"grid": [7, 18], "pu": 0.46, "pv": 0.37, "cap": 4.5}, "pocong": {"grid": [3, 18], "pu": 0.5, "pv": 1.0, "cap": 1.6}, "toyol": {"grid": [5, 18], "pu": 0.5, "pv": 0.62, "cap": 4.0}}

static var states := {}
static var uid := 0
static var last_clean := 0.0
static var epoch := 0
static var last_call := 0.0
static var masks := {}
static var GC: Array = []
static var frame_id := 0
static var P := {"t": 0.0, "L": 0.0, "flop": 0.0, "jel": 0.0, "hr": 0.0, "sj": 0.0, "Wd": 0.0, "H": 0.0}

static func sm(a: float, b: float, x: float) -> float:
	x = (x - a) / (b - a); x = clampf(x, 0, 1); return x * x * (3 - 2 * x)
static func lerp_keys(K: Array, p: float) -> float:
	for i in range(1, K.size()):
		if p <= K[i][0]:
			var a = K[i - 1]; var b = K[i]; var q = (p - a[0]) / (b[0] - a[0])
			return a[1] + (b[1] - a[1]) * (0.5 - 0.5 * cos(PI * q))
	return K[K.size() - 1][1]
static func _o(o, k: String): return J.gp(o, k) if J.t(o) else null
static func _ob(o, k: String) -> bool: return J.t(_o(o, k))
static func _now() -> float: return J.S_performance_("now", [])

# ---------- 每個實例的狀態（彈簧、攻擊計時），以位置追蹤 ----------
static func get_state(type: String, x: float, o) -> Dictionary:
	var now = _now()
	if now - last_call > 6: epoch += 1
	last_call = now
	var key = _o(o, "key"); var st = null
	if key != null: st = states.get(type + "#" + J.str(key))
	else:
		var best = 1e9
		for s in states.values():
			if s.type != type or s.keyed or now - s.seen > 400 or s.ep == epoch: continue
			var d = absf(s.x - x)
			if d < 30 and d < best: best = d; st = s
	if st == null:
		st = {"type": type, "keyed": key != null, "x": x, "seen": now - 16, "ep": -1, "L": 0.0, "V": 0.0, "aclk": -1.0, "atkOn": false, "hclk": -1.0, "hurtOn": false, "dt": 0.0}
		if key != null: states[type + "#" + J.str(key)] = st
		else: states[type + "@" + str(uid)] = st; uid += 1
	var dt = clampf((now - st.seen) / 1000.0, 0, 0.05)
	var dx = x - st.x
	if absf(dx) > 40: dx = 0
	st.L -= (-dx if _ob(o, "flip") else dx)
	for i in 2:
		var h = dt / 2; var a = -170 * st.L - 9 * st.V; st.V += a * h; st.L += st.V * h
	st.L = clampf(st.L, -9, 9)
	st.x = x; st.seen = now; st.dt = dt; st.ep = epoch
	if now - last_clean > 2000:
		last_clean = now
		for k in states.keys(): if now - states[k].seen > 2000: states.erase(k)
	return st

static func atkpose(pose: String, p: float) -> float:
	match pose:
		"windup": return 0.3 * minf(1, p)
		"strike": return 0.3 + 0.4 * minf(1, p)
		"recover": return 0.7 + 0.3 * minf(1, p)
		"cast", "attack": return minf(1, p)
	return -1.0
static func progress(st: Dictionary, o) -> Array:
	var pa = -1.0; var ph = -1.0
	var pose = J.str(_o(o, "pose")) if _o(o, "pose") != null else ""; var pt = _o(o, "pt")
	if pose in ["windup", "strike", "recover", "cast", "attack"] and pt != null: pa = atkpose(pose, J.num(pt))
	else:
		if _ob(o, "atk") and not st.atkOn: st.aclk = 0.0
		st.atkOn = _ob(o, "atk")
		if st.aclk >= 0:
			pa = st.aclk / ADUR; st.aclk += st.dt
			if pa > 1.6: st.aclk = -1.0
	if (pose == "hurt" or pose == "die") and pt != null: ph = minf(1, J.num(pt))
	else:
		if _ob(o, "hurt") and not st.hurtOn: st.hclk = 0.0
		st.hurtOn = _ob(o, "hurt")
		if st.hclk >= 0:
			ph = st.hclk / HDUR; st.hclk += st.dt
			if ph > 1.6: st.hclk = -1.0
	return [pa, ph]

# ---------- 各角色：drive（身體整體姿勢）----------
static func hopping(o) -> bool: return _ob(o, "walk") or _ob(o, "enemy") or _ob(o, "work")
static func hop(tt: float, o) -> Array:
	var rate = 2.2 if _ob(o, "work") else (1.55 if _ob(o, "walk") else 1.25); var h = 2.5 if _ob(o, "work") else (7.0 if _ob(o, "walk") else 4.5)
	var f = tt * rate; return [f - floor(f), h]

static func drive(type: String, G: Dictionary, tt: float, pa: float, ph: float, o, hf: float) -> void:
	var x = 0.0; var y = 0.0; var r = 0.0; var sx = 1.0; var sy = 1.0
	var walk = _ob(o, "walk"); var work = _ob(o, "work")
	if type == "penanggal":
		x = sin(tt * 1.3) * 1.2; y = -4 - sin(tt * 2.6) * 2.2; r = sin(tt * 1.3 + 0.6) * 0.06
		if walk: y -= sin(tt * 5.2) * 1.6; r += 0.1 + sin(tt * 5.2 + 0.8) * 0.05; x += sin(tt * 2.6) * 1
		if work: r += sin(tt * 7) * 0.07; y -= absf(sin(tt * 7)) * 1.5
		if pa >= 0:
			var p = clampf(pa, 0, 1)
			var a1 = sm(0, 0.25, p) * (1 - sm(0.27, 0.4, p))
			x -= 5 * a1; r -= 0.22 * a1; sy *= 1 + 0.08 * a1; sx *= 1 - 0.06 * a1; y += 1.5 * a1
			var l = sm(0.25, 0.47, p) * (1 - sm(0.62, 1, p))
			x += 13 * l; r += 0.08 * l; y += 2 * l
			var stv = sin(PI * l); sx *= 1 + 0.22 * stv; sy *= 1 - 0.13 * stv
			if p > 0.44 and p < 0.7:
				var q = (p - 0.44) / 0.26; var c = absf(sin(q * TAU_)) * sin(q * PI) * hf; sy *= 1 - 0.18 * c; sx *= 1 + 0.12 * c
		if ph >= 0 and ph < 1:
			var k = 1 - ph; var k2 = k * k * sm(0, 0.16, ph); var j = sin(ph * 22) * k * sm(0, 0.06, ph) * hf
			x -= 7 * k2; y -= 2 * k2; r -= 0.3 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j
	elif type == "pocong":
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
		elif hopping(o):
			var fh = hop(tt, o); var f = fh[0]; var h = fh[1]
			sy = lerp_keys(HOP_SY, f); sx = 1 / pow(sy, 0.6)
			if f > 0.2 and f < 0.7:
				var q = (f - 0.2) / 0.5; y = -h * 4 * q * (1 - q); r = (0.08 if walk else 0.04) * sin(PI * q)
				if walk: x = (q - 0.5) * 2.5
			elif walk: x = 1.25 if f > 0.7 else -1.25
		else:
			r = sin(tt * 1.6) * 0.035; sy = 1 + sin(tt * 2.2) * 0.015; sx = 1 - sin(tt * 2.2) * 0.01
		if ph >= 0 and ph < 1:
			var k = 1 - ph; var k2 = k * k * sm(0, 0.16, ph); var j = sin(ph * 20) * k * sm(0, 0.06, ph) * hf
			x -= 4 * k2; r -= 0.22 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j
	else: # toyol
		x = sin(tt * 1.4) * 0.8; y = -sin(tt * 2.8) * 1.0; r = sin(tt * 1.7) * 0.05; sy = 1 + sin(tt * 3.0) * 0.02; sx = 1 - sin(tt * 3.0) * 0.012
		if walk: r += 0.15 + sin(tt * 6) * 0.03; y += sin(tt * 6) * 0.9
		if work: y -= absf(sin(tt * 6)) * 1.8; r += sin(tt * 6) * 0.06
		if pa >= 0:
			var p = clampf(pa, 0, 1)
			var a1 = sm(0, 0.22, p) * (1 - sm(0.22, 0.32, p))
			x -= 4 * a1; r -= 0.14 * a1; sx *= 1 + 0.08 * a1; sy *= 1 - 0.1 * a1; y += 1 * a1
			var l = sm(0.22, 0.4, p) * (1 - sm(0.74, 1, p))
			x += 15 * l; r += 0.2 * sin(PI * sm(0.22, 0.4, p)) + 0.06 * l
			var stv = sin(PI * l); sx *= 1 + 0.26 * stv; sy *= 1 - 0.14 * stv
			if p > 0.4 and p < 0.74:
				var q = (p - 0.4) / 0.34; var b = sin(q * 3 * PI) * (1 - q) * hf; sy *= 1 - 0.1 * b; sx *= 1 + 0.07 * b
		if ph >= 0 and ph < 1:
			var k = 1 - ph; var k2 = k * k * sm(0, 0.16, ph); var j = sin(ph * 22) * k * sm(0, 0.06, ph) * hf
			x -= 6 * k2; r -= 0.28 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j
	G.x = x; G.y = y; G.r = r; G.sx = sx; G.sy = sy

static func weights(type: String, u: float, v: float, W: Dictionary) -> void:
	if type == "penanggal":
		var rr = Vector2((u - 0.46) / 0.31, (v - 0.37) / 0.29).length()
		W.hw = sm(0.8, 1.6, rr); W.dw = maxf(W.hw, sm(0.52, 0.95, v))
		var eu = (u - 0.43) / 0.17; W.ew = sm(0.5, 0.9, v) * exp(-eu * eu)
	elif type == "pocong":
		W.kw = 1 - sm(0.03, 0.26, v); W.bw = sin(PI * clampf((v - 0.2) / 0.75, 0, 1))
	else:
		W.hw = 1 - sm(0.36, 0.5, v); W.bw = sm(0.4, 0.48, v) * (1 - sm(0.68, 0.76, v))
		var su = (u - 0.8) / 0.17; var sv = (v - 0.55) / 0.15; W.sw = exp(-(su * su + sv * sv)); W.tw = sm(0.68, 1, v)

static func local(type: String, u: float, v: float, W: Dictionary, out: Dictionary) -> void:
	var t = P.t
	if type == "penanggal":
		var dw = W.dw
		out.x = dw * (sin(t * 3.1 - v * 7 + u * 2) * 1.4 + sin(t * 1.9 - v * 4.3 + u) * 0.7) * (0.35 + 0.9 * v) + W.ew * sin(t * 2.1 - v * 3.2) * 2.4 * (v - 0.5) * 2 + P.L * dw * v * 1.1
		out.y = W.hw * sin(t * 2.4 - u * 6) * 0.5 + W.ew * sin(t * 4.2 - v * 5) * 0.4
	elif type == "pocong":
		var kw = W.kw
		out.x = kw * (sin(t * 3.3) * 0.9 + P.flop * 1.8 + P.L * 1.6) * (1.2 - v * 2) + W.bw * P.L * 0.35 + W.bw * P.jel * sin(v * 9 - t * 20) * 0.6
		out.y = kw * sin(t * 2.6 + u * 3) * 0.3
	else:
		var tw = pow(W.tw, 1.3)
		var a = W.hw * P.hr; var ox = (u - 0.5) * P.Wd; var oy = (v - 0.45) * P.H
		var x = ox * cos(a) - oy * sin(a) - ox; var y = ox * sin(a) + oy * cos(a) - oy
		x += W.bw * (u - 0.55) * P.Wd * 0.05 * sin(t * 3)
		y += W.bw * (0.6 - v) * P.H * 0.03 * sin(t * 3) + W.hw * sin(t * 2.8 - 0.6) * 0.5
		x += tw * (sin(t * 4.2 - v * 8) * 2.4 + P.L * 1.6); y += tw * sin(t * 3.1 - v * 6) * 0.4
		x += W.sw * P.sj * sin(t * 37) * 1.4; y += W.sw * (sin(t * 3 + 1) * 0.8 + P.sj * sin(t * 29 + 1) * 1.8)
		out.x = x; out.y = y

static func lag(type: String, v: float, W: Dictionary) -> float:
	if type == "penanggal": return W.dw * (0.04 + 0.2 * v) + W.ew * 0.06
	if type == "pocong": return W.kw * 0.07 + W.bw * 0.02
	return W.hw * 0.06 + W.tw * 0.16
static func gain(type: String, W: Dictionary) -> float:
	if type == "penanggal": return 1 + 0.12 * W.dw
	if type == "pocong": return 1 + 0.4 * W.kw
	return 1 + 0.5 * W.tw

# ---------- 網格繪製 ----------
# 每格是否有內容：由貼圖透明度計（同網頁版縮成每格 6×6 取樣）
static func mask(type: String, cols: int, rows: int) -> PackedByteArray:
	if masks.has(type): return masks[type]
	var m = PackedByteArray(); m.resize(cols * rows); m.fill(1)
	var tex: Texture2D = PtGfx.tex(type)
	var im: Image = tex.get_image() if tex != null else null
	if im != null:
		im = im.duplicate()
		if im.is_compressed(): im.decompress()
		var cw = cols * 6; var ch = rows * 6
		im.resize(cw, ch, Image.INTERPOLATE_BILINEAR)
		for j in rows:
			for i in cols:
				var any = 0
				for yy in range(j * 6, j * 6 + 6):
					for xx in range(i * 6, i * 6 + 6):
						if im.get_pixel(xx, yy).a * 255.0 > 4: any = 1; break
					if any: break
				m[j * cols + i] = any
	masks[type] = m
	return m

static func pose_at(type: String, idx: int, t: float, pa: float, ph: float, o) -> Dictionary:
	var G = GC[idx]
	if G.ok == frame_id: return G
	var base = idx / 60.0
	if idx == 0: drive(type, G, t, pa, ph, o, 1.0)
	else:
		G.x = 0.0; G.y = 0.0; G.r = 0.0; G.sx = 0.0; G.sy = 0.0
		var TMP = {"x": 0.0, "y": 0.0, "r": 0.0, "sx": 1.0, "sy": 1.0}
		for m in 5:
			var lg = base * (0.3 + 0.35 * m)
			drive(type, TMP, t - lg, pa - lg / ADUR if pa >= 0 else -1.0, ph - lg / HDUR if ph >= 0 else -1.0, o, exp(-lg * 18))
			G.x += TMP.x * 0.2; G.y += TMP.y * 0.2; G.r += TMP.r * 0.2; G.sx += TMP.sx * 0.2; G.sy += TMP.sy * 0.2
	G.c = cos(G.r); G.s = sin(G.r); G.ok = frame_id
	return G
static func apply(G: Dictionary, bx: float, by: float, px: float, py: float, out: Dictionary) -> void:
	var dx = (bx - px) * G.sx; var dy = (by - py) * G.sy
	out.x = px + dx * G.c - dy * G.s + G.x; out.y = py + dx * G.s + dy * G.c + G.y

static func _set_t(ctx, a: float, b: float, c: float, d: float, e: float, f: float) -> void: J.mc(ctx, "setTransform", [a, b, c, d, e, f])

static func draw_whole(ctx, img, M: Transform2D, G: Dictionary, x0: float, y0: float, s: float, Wd: float, H: float, px: float, py: float) -> void:
	var a = G.sx * G.c; var b = G.sx * G.s; var c = -G.sy * G.s; var d = G.sy * G.c
	var e = px + G.x - (a * px + c * py); var f = py + G.y - (b * px + d * py)
	var la = a * s; var lb = b * s; var lc = c * s; var ld = d * s; var le = e * s + x0; var lf = f * s + y0
	var Ma = M.x.x; var Mb = M.x.y; var Mc = M.y.x; var Md = M.y.y; var Me = M.origin.x; var Mf = M.origin.y
	_set_t(ctx, Ma * la + Mc * lb, Mb * la + Md * lb, Ma * lc + Mc * ld, Mb * lc + Md * ld, Ma * le + Mc * lf + Me, Mb * le + Md * lf + Mf)
	J.mc(ctx, "drawImage", [img, -Wd / 2, -H, Wd, H])

static func dust(ctx, x0: float, y0: float, s: float, k: float, big: bool) -> void:
	if k <= 0 or k >= 1: return
	var n = 5 if big else 3; var a = (1 - k) * (0.55 if big else 0.4)
	J.mc(ctx, "save", []); J.sp(ctx, "fillStyle", "rgba(214,204,184,%s)" % JStr.num_call(a, "toFixed", [3.0]))
	for i in n:
		for sd in [-1.0, 1.0]:
			var d = (10.0 if big else 6.0) + k * (18.0 if big else 10.0) + i * 3.2; var rr = (3.4 if big else 2.4) * (0.6 + k * 0.9) * (1 - i * 0.12)
			J.mc(ctx, "beginPath", []); J.mc(ctx, "ellipse", [x0 + sd * d * s, y0 - (1 + i * 0.6 + k * 2.5 * (1 + (i & 1))) * s, rr * s, rr * 0.7 * s, 0.0, 0.0, TAU_]); J.mc(ctx, "fill", [])
	J.mc(ctx, "restore", [])

static func draw(ctx, type: String, x0: float, y0: float, s: float, o) -> void:
	var df = DEF[type]; var img = J.gp(J.G.get("SPR"), type); var iw = J.num(J.gp(img, "naturalWidth")); var ih = J.num(J.gp(img, "naturalHeight"))
	var t = J.num(_o(o, "t")); var H = H0[type]; var Wd = H * iw / ih; var cols: int = df.grid[0]; var rows: int = df.grid[1]
	var st = get_state(type, x0, o); var pp = progress(st, o); var pa: float = pp[0]; var ph: float = pp[1]
	frame_id += 1
	var px = (df.pu - 0.5) * Wd; var py = -(1 - df.pv) * H
	P.t = t; P.L = st.L / maxf(0.3, s); P.Wd = Wd; P.H = H; P.flop = 0.0; P.jel = 0.0; P.hr = 0.0; P.sj = 0.0
	var dust_k = -1.0; var dust_big = false
	if type == "pocong":
		if pa >= 0 and pa < 1:
			if pa > 0.62: dust_k = (pa - 0.62) / 0.38; dust_big = true; P.jel = maxf(0, 1 - (pa - 0.62) / 0.3)
			P.flop = sin(pa * TAU_ * 1.5) * (1 - pa)
		elif hopping(o):
			var fh = hop(t, o); var f = fh[0]; var h = fh[1]
			P.flop = sin(f * TAU_ - 1.2) * (h / 6)
			if f > 0.7 and h > 3: dust_k = (f - 0.7) / 0.3
			if f > 0.7: P.jel = (1 - (f - 0.7) / 0.3) * 0.6
		if ph >= 0 and ph < 1: P.jel = maxf(P.jel, 1 - ph)
	elif type == "toyol":
		P.hr = sin(t * 1.9 + 0.4) * 0.07 + (0.05 if _ob(o, "walk") else 0.0)
		if pa >= 0 and pa < 1: P.sj = sm(0.36, 0.45, pa) * (1 - sm(0.7, 0.85, pa)); P.hr += -0.12 * sm(0.22, 0.4, pa) * (1 - sm(0.4, 0.6, pa))
		if ph >= 0 and ph < 1: P.sj = maxf(P.sj, (1 - ph) * 0.8); P.hr -= 0.2 * (1 - ph) * (1 - ph)
	var nx = cols + 1
	var VX = PackedFloat32Array(); VX.resize(nx * (rows + 1)); var VY = PackedFloat32Array(); VY.resize(nx * (rows + 1))
	var W = {}; var out = {"x": 0.0, "y": 0.0}; var cap: float = df.cap
	for j in rows + 1:
		var v = float(j) / rows
		for i in nx:
			var u = float(i) / cols
			weights(type, u, v, W); local(type, u, v, W, out)
			var bx = (u - 0.5) * Wd + out.x; var by = -(1 - v) * H + out.y
			var G0 = pose_at(type, 0, t, pa, ph, o)
			apply(G0, bx, by, px, py, out)
			var X = out.x; var Y = out.y
			var lf = minf(38.999, lag(type, v, W) * 60)
			if lf > 0.001:
				var g = gain(type, W); var X0 = X; var Y0 = Y; var li = int(floor(lf)); var fr = lf - li
				apply(pose_at(type, li, t, pa, ph, o), bx, by, px, py, out); var ax = out.x; var ay = out.y
				apply(pose_at(type, li + 1, t, pa, ph, o), bx, by, px, py, out)
				out.x = ax + (out.x - ax) * fr; out.y = ay + (out.y - ay) * fr
				var ddx = (out.x - X0) * g; var ddy = (out.y - Y0) * g; var m = sqrt(ddx * ddx + ddy * ddy)
				if m > 1e-4: var q = cap * tanh(m / cap) / m; ddx *= q; ddy *= q
				X = X0 + ddx; Y = Y0 + ddy
			var k = j * nx + i; VX[k] = x0 + X * s; VY[k] = y0 + Y * s
	# 防摺保險
	var mnX = 0.25 * Wd / cols * s; var mnY = 0.25 * H / rows * s
	for j in rows + 1:
		for i in range(1, nx):
			var k = j * nx + i
			if VX[k] < VX[k - 1] + mnX: VX[k] = VX[k - 1] + mnX
	for i in nx:
		for j in range(1, rows + 1):
			var k = j * nx + i
			if VY[k] < VY[k - nx] + mnY: VY[k] = VY[k - nx] + mnY
	var M: Transform2D = J.mc(ctx, "getTransform", []); var mk = mask(type, cols, rows)
	var cw = iw / cols; var chh = ih / rows
	var Ms = maxf(0.2, M.x.length())
	var Ma = M.x.x; var Mb = M.x.y; var Mc = M.y.x; var Md = M.y.y; var Me = M.origin.x; var Mf = M.origin.y
	J.mc(ctx, "save", [])
	if type == "toyol" and pa >= 0 and pa < 1:
		var Ga = pose_at(type, 0, t, pa, ph, o); var Gb = pose_at(type, 2, t, pa, ph, o)
		var spd = absf(Ga.x - Gb.x) * 30
		if spd > 25:
			var base_a = J.num(J.gp(ctx, "globalAlpha")); var amt = minf(1, (spd - 25) / 120)
			for i in range(4, 0, -1):
				J.sp(ctx, "globalAlpha", base_a * amt * 0.22 * (1 - i / 5.0)); draw_whole(ctx, img, M, pose_at(type, i * 2, t, pa, ph, o), x0, y0, s, Wd, H, px, py)
			J.sp(ctx, "globalAlpha", base_a)
	for j in rows:
		for i in cols:
			if not mk[j * cols + i]: continue
			var k00 = j * nx + i; var k10 = k00 + 1; var k01 = k00 + nx; var k11 = k01 + 1
			var ex = (VX[k10] - VX[k00] + VX[k11] - VX[k01]) * 0.5; var ey = (VY[k10] - VY[k00] + VY[k11] - VY[k01]) * 0.5
			var fx = (VX[k01] - VX[k00] + VX[k11] - VX[k10]) * 0.5; var fy = (VY[k01] - VY[k00] + VY[k11] - VY[k10]) * 0.5
			var ox = (VX[k00] + VX[k10] + VX[k01] + VX[k11]) * 0.25 - (ex + fx) * 0.5; var oy = (VY[k00] + VY[k10] + VY[k01] + VY[k11]) * 0.25 - (ey + fy) * 0.5
			_set_t(ctx, Ma * ex + Mc * ey, Mb * ex + Md * ey, Ma * fx + Mc * fy, Mb * fx + Md * fy, Ma * ox + Mc * oy + Me, Mb * ox + Md * oy + Mf)
			var twS = Vector2(VX[k00] + VX[k11] - VX[k10] - VX[k01], VY[k00] + VY[k11] - VY[k10] - VY[k01]).length() * 0.25 * Ms
			var lx = maxf(1, Vector2(ex, ey).length() * Ms); var ly = maxf(1, Vector2(fx, fy).length() * Ms)
			var aL = minf(0.25, twS / lx); var aR = minf(0.3, (1.1 + twS) / lx); var aT = minf(0.25, twS / ly); var aB = minf(0.3, (1.1 + twS) / ly)
			var sx0 = maxf(0, (i - aL) * cw); var sx1 = minf(iw, (i + 1 + aR) * cw); var sy0 = maxf(0, (j - aT) * chh); var sy1 = minf(ih, (j + 1 + aB) * chh)
			J.mc(ctx, "drawImage", [img, sx0, sy0, sx1 - sx0, sy1 - sy0, sx0 / cw - i, sy0 / chh - j, (sx1 - sx0) / cw, (sy1 - sy0) / chh])
	_set_t(ctx, Ma, Mb, Mc, Md, Me, Mf)
	if dust_k > 0: dust(ctx, x0, y0, s, dust_k, dust_big)
	J.mc(ctx, "restore", [])

static func has(type) -> bool:
	var SPR = J.G.get("SPR")
	var k = J.str(type)
	return DEF.has(k) and SPR != null and J.t(J.gp(SPR, k)) and J.t(J.gp(J.gp(SPR, k), "naturalWidth"))

func run(_env) -> void:
	states = {}; uid = 0; last_clean = 0.0; epoch = 0; last_call = 0.0; frame_id = 0
	GC = []
	for i in 40: GC.append({"x": 0.0, "y": 0.0, "r": 0.0, "sx": 1.0, "sy": 1.0, "c": 1.0, "s": 0.0, "ok": -1})
	J.G["SPECIAL"] = {
		"has": func(_t, a): return has(J.arg(a, 0)),
		"draw": func(_t, a): draw(J.arg(a, 0), J.str(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5) if J.t(J.arg(a, 5)) else {}); return null,
		"_dbg": {"C": DEF.duplicate(true)},
	}
