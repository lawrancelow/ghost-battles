# Canvas 2D 相容層：把網頁版 ctx.xxx() 嘅畫法搬到 Godot CanvasItem 上。
# 用法：喺 _draw() 入面 var ctx = Ctx.new(self)；之後同 JS 一樣 ctx.save()/translate()/fill()/drawImage()…
# 路徑點喺加入嗰刻就用當前變換轉好（同 Canvas 規矩一樣），畫嘅時候用單位矩陣。
class_name Ctx
extends RefCounted

var ci   # CanvasItem 或 Recorder
var canvas = null   # 對應 JS 嘅 ctx.canvas（El）
var base = Transform2D.IDENTITY   # 外層（鏡頭／縮放）
var T = Transform2D.IDENTITY      # 當前變換（含 base）
var globalAlpha = 1.0
var fillStyle: Variant = Color.BLACK
var strokeStyle: Variant = Color.BLACK
var lineWidth = 1.0
var lineCap = "butt"
var lineJoin = "miter"
var font = "10px sans-serif"
var textAlign = "start"
var textBaseline = "alphabetic"
var filter = "none"
var globalCompositeOperation = "source-over"
var _dash: Array = []
var _stack: Array = []
var _paths: Array = []      # Array[PackedVector2Array]（已變換）
var _cur = PackedVector2Array()
var _closed: Array = []     # 每條子路徑係咪 closePath 咗
var _clip = null            # 簡化 clip：只支援矩形（裝置座標 Rect2）

const TAU2 := PI * 2.0

func _init(item, b: Transform2D = Transform2D.IDENTITY) -> void:
	ci = item; base = b; T = b

# ---------------- 狀態 ----------------
func save() -> void:
	_stack.push_back([T, globalAlpha, fillStyle, strokeStyle, lineWidth, lineCap, lineJoin, font, textAlign, textBaseline, filter, globalCompositeOperation, _dash, _clip])

func restore() -> void:
	if _stack.is_empty(): return
	var s: Array = _stack.pop_back()
	T = s[0]; globalAlpha = s[1]; fillStyle = s[2]; strokeStyle = s[3]; lineWidth = s[4]; lineCap = s[5]; lineJoin = s[6]
	font = s[7]; textAlign = s[8]; textBaseline = s[9]; filter = s[10]; globalCompositeOperation = s[11]; _dash = s[12]; _clip = s[13]

func translate(x: float, y: float) -> void: T = T * Transform2D(0.0, Vector2(x, y))
func rotate(a: float) -> void: T = T * Transform2D(a, Vector2.ZERO)
func scale(sx: float, sy: float) -> void: T = T * Transform2D(Vector2(sx, 0), Vector2(0, sy), Vector2.ZERO)
func transform(a: float, b: float, c: float, d: float, e: float, f: float) -> void: T = T * Transform2D(Vector2(a, b), Vector2(c, d), Vector2(e, f))
func setTransform(a = 1.0, b = 0.0, c = 0.0, d = 1.0, e = 0.0, f = 0.0) -> void:
	if a is Transform2D: T = base * a; return
	T = base * Transform2D(Vector2(a, b), Vector2(c, d), Vector2(e, f))
func resetTransform() -> void: T = base
func getTransform() -> Transform2D: return base.affine_inverse() * T
func setLineDash(d: Array) -> void: _dash = d.duplicate()
func _sc() -> float: return sqrt(absf(T.determinant()))

# ---------------- 路徑 ----------------
func beginPath() -> void:
	_paths.clear(); _closed.clear(); _cur = PackedVector2Array()

func _flush() -> void:
	if _cur.size() > 0:
		_paths.push_back(_cur); _closed.push_back(false)
	_cur = PackedVector2Array()

func moveTo(x: float, y: float) -> void:
	_flush(); _cur.push_back(T * Vector2(x, y))

func lineTo(x: float, y: float) -> void:
	if _cur.is_empty(): _cur.push_back(T * Vector2(x, y)); return
	_cur.push_back(T * Vector2(x, y))

func closePath() -> void:
	if _cur.size() > 0:
		_paths.push_back(_cur); _closed.push_back(true)
		var first = _cur[0]
		_cur = PackedVector2Array(); _cur.push_back(first)

func _last_local() -> Vector2:
	if _cur.is_empty(): return Vector2.ZERO
	return T.affine_inverse() * _cur[_cur.size() - 1]

func _segs(r: float) -> int: return clampi(int(r * _sc() * 0.9) + 6, 8, 96)

func quadraticCurveTo(cx: float, cy: float, x: float, y: float) -> void:
	var p0 = _last_local(); var c = Vector2(cx, cy); var p1 = Vector2(x, y)
	if _cur.is_empty(): _cur.push_back(T * p0)
	var n = clampi(int((p0.distance_to(c) + c.distance_to(p1)) * _sc() / 4.0) + 3, 4, 40)
	for i in range(1, n + 1):
		var t = float(i) / n
		_cur.push_back(T * (p0 * (1 - t) * (1 - t) + c * 2 * (1 - t) * t + p1 * t * t))

func bezierCurveTo(c1x: float, c1y: float, c2x: float, c2y: float, x: float, y: float) -> void:
	var p0 = _last_local(); var c1 = Vector2(c1x, c1y); var c2 = Vector2(c2x, c2y); var p1 = Vector2(x, y)
	if _cur.is_empty(): _cur.push_back(T * p0)
	var n = clampi(int((p0.distance_to(c1) + c1.distance_to(c2) + c2.distance_to(p1)) * _sc() / 4.0) + 3, 4, 48)
	for i in range(1, n + 1):
		var t = float(i) / n; var u = 1.0 - t
		_cur.push_back(T * (p0 * u * u * u + c1 * 3 * u * u * t + c2 * 3 * u * t * t + p1 * t * t * t))

func arc(x: float, y: float, r: float, a0: float, a1: float, ccw := false) -> void:
	ellipse(x, y, r, r, 0.0, a0, a1, ccw)

func ellipse(x: float, y: float, rx: float, ry: float, rot: float, a0: float, a1: float, ccw := false) -> void:
	var span = a1 - a0
	if not ccw:
		if span >= TAU2: span = TAU2
		else:
			span = fposmod(span, TAU2)
			if span == 0.0 and a1 != a0: span = TAU2
	else:
		if -span >= TAU2: span = -TAU2
		else:
			span = -fposmod(-span, TAU2)
			if span == 0.0 and a1 != a0: span = -TAU2
	var n = maxi(2, int(_segs(maxf(rx, ry)) * absf(span) / TAU2) + 1)
	var cr = cos(rot); var sr = sin(rot)
	for i in range(n + 1):
		var a = a0 + span * float(i) / n
		var px = cos(a) * rx; var py = sin(a) * ry
		var p = T * Vector2(x + px * cr - py * sr, y + px * sr + py * cr)
		_cur.push_back(p)

func rect(x: float, y: float, w: float, h: float) -> void:
	moveTo(x, y); lineTo(x + w, y); lineTo(x + w, y + h); lineTo(x, y + h); closePath()

func roundRect(x: float, y: float, w: float, h: float, r = 0.0) -> void:
	var rr: float = r[0] if r is Array else float(r)
	if w < 0: x += w; w = -w
	if h < 0: y += h; h = -h
	rr = clampf(rr, 0.0, minf(w, h) / 2.0)
	if rr <= 0.01: rect(x, y, w, h); return
	moveTo(x + rr, y)
	lineTo(x + w - rr, y); arc(x + w - rr, y + rr, rr, -PI / 2, 0)
	lineTo(x + w, y + h - rr); arc(x + w - rr, y + h - rr, rr, 0, PI / 2)
	lineTo(x + rr, y + h); arc(x + rr, y + h - rr, rr, PI / 2, PI)
	lineTo(x, y + rr); arc(x + rr, y + rr, rr, PI, PI * 1.5)
	closePath()

func clip() -> void:
	# 只支援大致矩形：用路徑外框
	_flush()
	var bb = Rect2(); var first = true
	for p in _paths:
		for v in p:
			if first: bb = Rect2(v, Vector2.ZERO); first = false
			else: bb = bb.expand(v)
	_clip = bb if _clip == null else (_clip as Rect2).intersection(bb)

# ---------------- 顏色 ----------------
static var _ccache = {}
static func col(v: Variant) -> Color:
	if v is Color: return v
	if v == null: return Color(0, 0, 0, 0)
	var s: String = str(v)
	if _ccache.has(s): return _ccache[s]
	var c = Color.BLACK
	var t = s.strip_edges().to_lower()
	if t.begins_with("#"):
		var h = t.substr(1)
		if h.length() == 3 or h.length() == 4:
			var e = ""
			for ch in h: e += ch + ch
			h = e
		c = Color.html("#" + h)
	elif t.begins_with("rgb"):
		var inner = t.substr(t.find("(") + 1).trim_suffix(")")
		inner = inner.replace("/", ",")
		var parts = inner.split(",") if inner.contains(",") else inner.split(" ", false)
		var f: Array = []
		for p in parts: f.append(p.strip_edges())
		c = Color(_cc(f[0]) / 255.0, _cc(f[1]) / 255.0, _cc(f[2]) / 255.0, (_ca(f[3]) if f.size() > 3 else 1.0))
	elif t.begins_with("hsl"):
		var inner2 = t.substr(t.find("(") + 1).trim_suffix(")").replace("/", ",")
		var p2 = inner2.split(",") if inner2.contains(",") else inner2.split(" ", false)
		var hh = float(p2[0].strip_edges().trim_suffix("deg")) / 360.0
		var ss = float(p2[1].strip_edges().trim_suffix("%")) / 100.0
		var ll = float(p2[2].strip_edges().trim_suffix("%")) / 100.0
		c = _hsl(hh, ss, ll); if p2.size() > 3: c.a = _ca(p2[3].strip_edges())
	elif t == "transparent": c = Color(0, 0, 0, 0)
	else:
		c = Color.from_string(t, Color.BLACK)
	_ccache[s] = c
	return c

static func _cc(s: String) -> float:
	if s.ends_with("%"): return float(s.trim_suffix("%")) * 2.55
	return float(s)
static func _ca(s: String) -> float:
	if s.ends_with("%"): return float(s.trim_suffix("%")) / 100.0
	return float(s)
static func _hsl(h: float, s: float, l: float) -> Color:
	var q = l * (1 + s) if l < 0.5 else l + s - l * s
	var p = 2 * l - q
	return Color(_h2(p, q, h + 1.0 / 3), _h2(p, q, h), _h2(p, q, h - 1.0 / 3))
static func _h2(p: float, q: float, t: float) -> float:
	t = fposmod(t, 1.0)
	if t < 1.0 / 6: return p + (q - p) * 6 * t
	if t < 0.5: return q
	if t < 2.0 / 3: return p + (q - p) * (2.0 / 3 - t) * 6
	return p

func _a(c: Color) -> Color:
	c.a *= globalAlpha
	if filter != "none" and filter != "":
		c = _apply_filter(c)
	return c

func _apply_filter(c: Color) -> Color:
	# 只做 brightness() / saturate() / grayscale()（網頁版用得最多）
	var f = filter
	var rx = RegEx.create_from_string("(brightness|saturate|grayscale)\\(([0-9.]+)(%?)\\)")
	for m in rx.search_all(f):
		var v = float(m.get_string(2)); if m.get_string(3) == "%": v /= 100.0
		match m.get_string(1):
			"brightness": c = Color(c.r * v, c.g * v, c.b * v, c.a)
			"saturate":
				var g = c.r * 0.299 + c.g * 0.587 + c.b * 0.114
				c = Color(lerpf(g, c.r, v), lerpf(g, c.g, v), lerpf(g, c.b, v), c.a)
			"grayscale":
				var g2 = c.r * 0.299 + c.g * 0.587 + c.b * 0.114
				c = Color(lerpf(c.r, g2, v), lerpf(c.g, g2, v), lerpf(c.b, g2, v), c.a)
	return c

func _mod() -> Color:
	return _a(Color(1, 1, 1, 1))

# ---------------- 漸變 ----------------
func createLinearGradient(x0: float, y0: float, x1: float, y1: float) -> Grad:
	return Grad.new(false, T * Vector2(x0, y0), T * Vector2(x1, y1), 0.0, 0.0)
func createRadialGradient(x0: float, y0: float, r0: float, x1: float, y1: float, r1: float) -> Grad:
	var s = _sc()
	return Grad.new(true, T * Vector2(x0, y0), T * Vector2(x1, y1), r0 * s, r1 * s)

# ---------------- 填色／描邊 ----------------
func fill(_rule := "nonzero") -> void:
	_flush()
	var paths = _paths.duplicate()
	if paths.size() > 1 and globalAlpha >= 0.999 and not (fillStyle is Grad):
		pass
	for p in paths:
		_fill_poly(p, fillStyle)
	# Canvas：fill 之後路徑仲喺度（可以再 stroke）
	_restore_cur_after_flush()

func _restore_cur_after_flush() -> void:
	# _flush 會清咗 _cur；Canvas 保留最後一點以便 lineTo 接落去，呢度唔需要
	pass

func stroke() -> void:
	_flush()
	var c = _a(col(strokeStyle) if not (strokeStyle is Grad) else (strokeStyle as Grad).avg())
	if c.a <= 0.001: return
	var w = maxf(0.5, lineWidth * _sc())
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	for i in _paths.size():
		var p: PackedVector2Array = _paths[i]
		if p.size() < 2: continue
		var pts = p
		if _closed[i] and p[0] != p[p.size() - 1]:
			pts = p.duplicate(); pts.push_back(p[0])
		if _dash.size() >= 2:
			_dashed(pts, c, w)
		else:
			_polyline(pts, c, w, _closed[i])

func _polyline(pts: PackedVector2Array, c: Color, w: float, closed: bool) -> void:
	if pts.size() == 2 and lineCap == "round":
		ci.draw_line(pts[0], pts[1], c, w, true)
		ci.draw_circle(pts[0], w / 2, c); ci.draw_circle(pts[1], w / 2, c)
		return
	# 細線用反鋸齒；粗線：draw_polyline 喺轉角會有縫，補圓
	ci.draw_polyline(pts, c, w, true)
	if w > 2.5 and (lineJoin == "round" or lineCap == "round"):
		for k in range(1 if not closed and lineCap != "round" else 0, pts.size() - (1 if not closed and lineCap != "round" else 0)):
			ci.draw_circle(pts[k], w / 2.0 - 0.3, c)

func _dashed(pts: PackedVector2Array, c: Color, w: float) -> void:
	var s = _sc(); var pat: Array = []
	for d in _dash: pat.append(maxf(0.5, float(d) * s))
	var pi = 0; var left: float = pat[0]; var on = true
	for i in range(pts.size() - 1):
		var a = pts[i]; var b = pts[i + 1]; var L = a.distance_to(b); var pos = 0.0
		while pos < L:
			var step = minf(left, L - pos)
			var p0 = a.lerp(b, pos / L); var p1 = a.lerp(b, (pos + step) / L)
			if on: ci.draw_line(p0, p1, c, w, true)
			pos += step; left -= step
			if left <= 0.0001:
				pi = (pi + 1) % pat.size(); left = pat[pi]; on = not on

func _fill_poly(p: PackedVector2Array, style: Variant) -> void:
	if p.size() < 3: return
	var q = p
	if q[0].distance_squared_to(q[q.size() - 1]) < 0.0001: q = q.slice(0, q.size() - 1)
	if q.size() < 3: return
	q = _dedupe(q)
	if q.size() < 3: return
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	var idx = Geometry2D.triangulate_polygon(q)
	if idx.is_empty():
		# 自交多邊形：用凸包頂住（少見）
		var hull = Geometry2D.convex_hull(q)
		if hull.size() >= 3:
			hull = hull.slice(0, hull.size() - 1)
			idx = Geometry2D.triangulate_polygon(hull); q = hull
	if idx.is_empty(): return
	if style is Grad:
		_fill_grad_tris(q, idx, style)
		return
	var c = _a(col(style))
	if c.a <= 0.001: return
	var cols = PackedColorArray(); cols.resize(q.size()); cols.fill(c)
	_tris(idx, q, cols)

func _dedupe(q: PackedVector2Array) -> PackedVector2Array:
	var o = PackedVector2Array()
	for v in q:
		if o.is_empty() or o[o.size() - 1].distance_squared_to(v) > 0.000001: o.push_back(v)
	if o.size() > 1 and o[0].distance_squared_to(o[o.size() - 1]) < 0.000001: o.remove_at(o.size() - 1)
	return o

func _fill_grad_tris(q: PackedVector2Array, idx: PackedInt32Array, g: Grad) -> void:
	# 細分三角形令漸變順滑
	var pts = PackedVector2Array(); var cols = PackedColorArray()
	var sub = 3 if not g.radial else 5
	for t in range(0, idx.size(), 3):
		var A = q[idx[t]]; var B = q[idx[t + 1]]; var C = q[idx[t + 2]]
		_subtri(A, B, C, sub, g, pts, cols)
	var ii = PackedInt32Array(); ii.resize(pts.size())
	for k in pts.size(): ii[k] = k
	_tris(ii, pts, cols)

func _subtri(A: Vector2, B: Vector2, C: Vector2, n: int, g: Grad, pts: PackedVector2Array, cols: PackedColorArray) -> void:
	var P = func(i: int, j: int) -> Vector2: return A + (B - A) * (float(i) / n) + (C - A) * (float(j) / n)
	for i in range(n):
		for j in range(n - i):
			var a: Vector2 = P.call(i, j); var b: Vector2 = P.call(i + 1, j); var c: Vector2 = P.call(i, j + 1)
			for v in [a, b, c]: pts.push_back(v); cols.push_back(_a(g.at(v)))
			if i + j < n - 1:
				var d: Vector2 = P.call(i + 1, j + 1)
				for v in [b, d, c]: pts.push_back(v); cols.push_back(_a(g.at(v)))

func fillRect(x: float, y: float, w: float, h: float) -> void:
	if fillStyle is Grad and (fillStyle as Grad).radial:
		_radial_rect(x, y, w, h, fillStyle); return
	if fillStyle is Grad:
		_linear_rect(x, y, w, h, fillStyle); return
	var c = _a(col(fillStyle))
	if c.a <= 0.001: return
	var q = PackedVector2Array([T * Vector2(x, y), T * Vector2(x + w, y), T * Vector2(x + w, y + h), T * Vector2(x, y + h)])
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	ci.draw_colored_polygon(q, c)

func _linear_rect(x: float, y: float, w: float, h: float, g: Grad) -> void:
	var n = 12
	var pts = PackedVector2Array(); var cols = PackedColorArray(); var idx = PackedInt32Array()
	for j in range(n + 1):
		for i in range(n + 1):
			var v = T * Vector2(x + w * i / n, y + h * j / n)
			pts.push_back(v); cols.push_back(_a(g.at(v)))
	for j in range(n):
		for i in range(n):
			var a = j * (n + 1) + i
			idx.append_array([a, a + 1, a + n + 1, a + 1, a + n + 2, a + n + 1])
	_tris(idx, pts, cols)

func _radial_rect(x: float, y: float, w: float, h: float, g: Grad) -> void:
	# 光暈：以漸變中心畫同心圓環（外面＝最後一格顏色；透明就唔畫）
	var c1 = g.p1; var R = g.r1
	var outside = g.last()
	var rect_dev = Rect2(T * Vector2(x, y), Vector2.ZERO).expand(T * Vector2(x + w, y + h)).expand(T * Vector2(x + w, y)).expand(T * Vector2(x, y + h))
	var rings = 14; var seg = clampi(int(R * 0.6) + 16, 20, 64)
	var pts = PackedVector2Array(); var cols = PackedColorArray(); var idx = PackedInt32Array()
	pts.push_back(c1); cols.push_back(_a(g.at(c1)))
	for r in range(1, rings + 1):
		var rad = R * float(r) / rings
		for s in seg:
			var a = TAU2 * s / seg
			var v = c1 + Vector2(cos(a), sin(a)) * rad
			pts.push_back(v); cols.push_back(_a(g.at(v)))
	for s in seg:
		idx.append_array([0, 1 + s, 1 + (s + 1) % seg])
	for r in range(1, rings):
		var o0 = 1 + (r - 1) * seg; var o1 = 1 + r * seg
		for s in seg:
			var s2 = (s + 1) % seg
			idx.append_array([o0 + s, o1 + s, o1 + s2, o0 + s, o1 + s2, o0 + s2])
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	# 粗略裁到 rect（光暈通常 rect 包住個圓）
	if not rect_dev.has_point(c1): return
	_tris(idx, pts, cols)
	if outside.a > 0.01:
		var oc = _a(outside)
		# 外圈：rect 減圓，簡單用四條帶
		ci.draw_rect(rect_dev, Color(oc, 0.0), false)

func _tris(idx: PackedInt32Array, pts: PackedVector2Array, cols: PackedColorArray, uvs := PackedVector2Array(), tex = null) -> void:
	if ci is Recorder: ci.tris(idx, pts, cols, uvs, tex); return
	if tex != null: RenderingServer.canvas_item_add_triangle_array(ci.get_canvas_item(), idx, pts, cols, uvs, PackedInt32Array(), PackedFloat32Array(), tex.get_rid())
	else: RenderingServer.canvas_item_add_triangle_array(ci.get_canvas_item(), idx, pts, cols)

func strokeRect(x: float, y: float, w: float, h: float) -> void:
	beginPath(); rect(x, y, w, h); stroke()

func clearRect(_x = 0.0, _y = 0.0, _w = 0.0, _h = 0.0) -> void:
	if ci is Recorder: ci.clear()
func fill_rect_clear(): pass
func getImageData(_a = 0, _b = 0, _c = 0, _d = 0): return null
func putImageData(_a = null, _b = 0, _c = 0) -> void: pass
func createPattern(_a = null, _b = null): return null
func isPointInPath(_a = null, _b = null, _c = null) -> bool: return false
func setLineDashOffset(_a = 0) -> void: pass

# ---------------- 圖片 ----------------
# drawImage(tex, dx, dy) / (tex, dx, dy, dw, dh) / (tex, sx, sy, sw, sh, dx, dy, dw, dh)
func drawImage(src, a: float, b: float, c = null, d = null, e = null, f = null, g = null, h = null) -> void:
	if src == null: return
	var tex: Texture2D = null
	if src is Texture2D: tex = src
	elif src is Object and src.has_method("js_tex"):
		tex = src.js_tex()
		if tex == null:
			var rec = src.js_rec()
			if rec != null: _draw_rec(rec, src, a, b, c, d, e, f, g, h)
			return
	if tex == null: return
	var m := _mod()
	if m.a <= 0.001: return
	ci.draw_set_transform_matrix(T)
	if e == null:
		var w: float = tex.get_width() if c == null else float(c)
		var hh: float = tex.get_height() if d == null else float(d)
		ci.draw_texture_rect(tex, Rect2(a, b, w, hh), false, m)
	else:
		ci.draw_texture_rect_region(tex, Rect2(float(e), float(f), float(g), float(h)), Rect2(a, b, float(c), float(d)), m)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

# 畫另一塊（錄製）畫布：只支援整塊或者整塊縮放；9 參數嘅源矩形用變換對應（唔裁切）
func _draw_rec(rec: Recorder, el, a, b, c, d, e, f, g, h) -> void:
	var cw: float = rec.width; var chh: float = rec.height
	var M := Transform2D.IDENTITY
	if e == null:
		var w: float = cw if c == null else float(c); var hh: float = chh if d == null else float(d)
		M = Transform2D(Vector2(w / maxf(1, cw), 0), Vector2(0, hh / maxf(1, chh)), Vector2(a, b))
	else:
		var sx: float = a; var sy: float = b; var sw: float = float(c); var sh: float = float(d)
		var dx: float = float(e); var dy: float = float(f); var dw: float = float(g); var dh: float = float(h)
		M = Transform2D(Vector2(dw / maxf(0.001, sw), 0), Vector2(0, dh / maxf(0.001, sh)), Vector2(dx, dy)) * Transform2D(0.0, Vector2(-sx, -sy))
	if ci is Recorder: ci.rec(rec, T * M, globalAlpha); return
	rec.replay(ci, T * M, globalAlpha)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

# 網格貼圖（MeshAnim 用）：pts 已係本地座標，會套當前變換
func drawTriangles(tex: Texture2D, pts: PackedVector2Array, uvs: PackedVector2Array, idx: PackedInt32Array, tint := Color.WHITE) -> void:
	var m = _mod() * tint
	if m.a <= 0.001: return
	var dev = PackedVector2Array(); dev.resize(pts.size())
	for i in pts.size(): dev[i] = T * pts[i]
	var cols = PackedColorArray(); cols.resize(pts.size()); cols.fill(m)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	_tris(idx, dev, cols, uvs, tex)

# ---------------- 文字 ----------------
static var _fonts = {}
static func font_res(family: String, weight: int) -> Font:
	var serif = family.to_lower().contains("serif") and not family.to_lower().contains("sans-serif") or family.contains("Song") or family.contains("STSong")
	if family.contains("PingFang") or family.contains("Noto Sans"): serif = false
	var key = ("serif" if serif else "sans") + str(weight)
	if _fonts.has(key): return _fonts[key]
	var file = ""
	if serif: file = "serif_k" if weight >= 900 else "serif_b"
	else: file = "sans_k" if weight >= 900 else ("sans_b" if weight >= 600 else "sans_r")
	var fnt: Font = load("res://fonts/%s.otf" % file)
	_fonts[key] = fnt
	return fnt

static var _fcache = {}
func _parse_font() -> Array:
	if _fcache.has(font): return _fcache[font]
	var weight = 400; var size = 10.0; var fam = "sans-serif"
	var rx = RegEx.create_from_string("([0-9.]+)px\\s*(.*)$")
	var m = rx.search(font)
	if m:
		size = float(m.get_string(1)); fam = m.get_string(2)
		var pre = font.substr(0, m.get_start()).to_lower()
		if pre.contains("bold"): weight = 700
		var rw = RegEx.create_from_string("\\b([1-9]00)\\b").search(pre)
		if rw: weight = int(rw.get_string(1))
	var r = [font_res(fam, weight), size]
	_fcache[font] = r
	return r

func measureText(s: String) -> Dictionary:
	var fr = _parse_font()
	var f: Font = fr[0]; var sz: float = fr[1]
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, int(round(sz))).x * sz / maxf(1.0, round(sz))
	return {"width": w}

func _text_origin(s: String, x: float, y: float) -> Vector2:
	var fr = _parse_font(); var f: Font = fr[0]; var sz: float = fr[1]
	var isz = int(round(sz))
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, isz).x
	var ox = 0.0
	match textAlign:
		"center": ox = -w / 2.0
		"right", "end": ox = -w
	var asc = f.get_ascent(isz); var des = f.get_descent(isz)
	var oy = 0.0
	match textBaseline:
		"top", "hanging": oy = asc
		"middle": oy = (asc - des) / 2.0
		"bottom", "ideographic": oy = -des
	return Vector2(x + ox, y + oy)

func fillText(s: Variant, x: float, y: float, _maxw = null) -> void:
	var str_s = str(s)
	var c = _a(col(fillStyle) if not (fillStyle is Grad) else (fillStyle as Grad).avg())
	if c.a <= 0.001: return
	var fr = _parse_font(); var f: Font = fr[0]; var sz: float = fr[1]
	var o = _text_origin(str_s, x, y)
	ci.draw_set_transform_matrix(T)
	ci.draw_string(f, o, str_s, HORIZONTAL_ALIGNMENT_LEFT, -1, int(round(sz)), c)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

func strokeText(s: Variant, x: float, y: float, _maxw = null) -> void:
	var str_s = str(s)
	var c = _a(col(strokeStyle) if not (strokeStyle is Grad) else (strokeStyle as Grad).avg())
	if c.a <= 0.001: return
	var fr = _parse_font(); var f: Font = fr[0]; var sz: float = fr[1]
	var o = _text_origin(str_s, x, y)
	ci.draw_set_transform_matrix(T)
	ci.draw_string_outline(f, o, str_s, HORIZONTAL_ALIGNMENT_LEFT, -1, int(round(sz)), maxi(1, int(round(lineWidth))), c)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

# 漸變物件
class Grad:
	extends RefCounted
	var radial = false
	var p0: Vector2; var p1: Vector2; var r0 = 0.0; var r1 = 0.0
	var stops: Array = []   # [[pos, Color]]
	func _init(rad: bool, a: Vector2, b: Vector2, ra: float, rb: float) -> void:
		radial = rad; p0 = a; p1 = b; r0 = ra; r1 = rb
	func addColorStop(pos: float, c: Variant) -> void:
		stops.append([pos, Ctx.col(c)])
		stops.sort_custom(func(x, y): return x[0] < y[0])
	func last() -> Color: return stops[-1][1] if stops.size() else Color(0, 0, 0, 0)
	func avg() -> Color: return stops[0][1] if stops.size() else Color.BLACK
	func at(v: Vector2) -> Color:
		if stops.is_empty(): return Color(0, 0, 0, 0)
		var t = 0.0
		if radial:
			var d = v.distance_to(p1)
			t = (d - r0) / maxf(0.0001, r1 - r0)
		else:
			var dir = p1 - p0; var L2 = dir.length_squared()
			t = 0.0 if L2 < 1e-9 else (v - p0).dot(dir) / L2
		t = clampf(t, 0.0, 1.0)
		if t <= stops[0][0]: return stops[0][1]
		for i in range(1, stops.size()):
			if t <= stops[i][0]:
				var a: Array = stops[i - 1]; var b: Array = stops[i]
				var k = (t - a[0]) / maxf(0.00001, b[0] - a[0])
				return (a[1] as Color).lerp(b[1], k)
		return stops[-1][1]
