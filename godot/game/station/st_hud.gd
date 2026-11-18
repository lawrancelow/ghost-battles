# 陽間站崗・畫面上嘅蠟筆介面（原生重寫 street.js Turf.drawMy／drawMini／drawTopBar／drawJar 同 CrUI）
#  以前每幀 JS 畫幾百條排線（CrUI.panel 斜線、小地圖路線），佔成幀六七成時間；而家原生一次過畫
class_name StHud
extends RefCounted

const COL := {"bone": Color8(217, 201, 168), "red": Color8(163, 48, 42), "rust": Color8(192, 106, 44), "violet": Color8(138, 111, 176), "gold": Color8(217, 164, 65)}

static func hs(n: float) -> float:
	var x = sin(n * 91.7 + 13.1) * 43758.5453; return x - floor(x)

static func rough(x: float, y: float, w: float, h: float, seed: float, j: float) -> PackedVector2Array:
	var pts = PackedVector2Array(); var n = maxi(3, int(round((w + h) / 26.0))); var k = 0
	var P = func(px, py, kk): return Vector2(px + (hs(seed + kk) - 0.5) * j, py + (hs(seed + kk + 0.5) - 0.5) * j)
	for i in n: pts.append(P.call(x + w * i / n, y, k)); k += 1
	for i in n: pts.append(P.call(x + w, y + h * i / n, k)); k += 1
	for i in n: pts.append(P.call(x + w - w * i / n, y + h, k)); k += 1
	for i in n: pts.append(P.call(x, y + h - h * i / n, k)); k += 1
	return pts

static func _closed(p: PackedVector2Array) -> PackedVector2Array:
	var q = p.duplicate(); q.append(p[0]); return q

static func _fill(c: CanvasItem, p: PackedVector2Array, col: Color) -> void:
	if Geometry2D.triangulate_polygon(p).is_empty(): c.draw_rect(_bounds(p), col)
	else: c.draw_colored_polygon(p, col)

static func _bounds(p: PackedVector2Array) -> Rect2:
	var r = Rect2(p[0], Vector2.ZERO)
	for v in p: r = r.expand(v)
	return r

static func panel(c: CanvasItem, x: float, y: float, w: float, h: float, col: String, fill: Color, U: float, seed: float) -> void:
	var cl: Color = COL.get(col, COL.bone)
	var p = rough(x, y, w, h, seed, 2.2 * U); _fill(c, p, fill)
	# 斜線排線（裁喺框入面：逐條同框邊 clip）
	var hc = Color(235 / 255.0, 215 / 255.0, 185 / 255.0, 0.05)
	var k = -h
	while k < w:
		var a = Vector2(x + k, y + h); var b = Vector2(x + k + h * 0.8, y)
		var seg = Geometry2D.clip_polyline_with_polygon(PackedVector2Array([a, b]), p)
		for s in seg: if s.size() >= 2: c.draw_line(s[0], s[s.size() - 1], hc, 1.0)
		k += 6 * U
	c.draw_polyline(_closed(rough(x, y, w, h, seed + 3, 2.6 * U)), Color(cl, 0.95), 2.6 * U, true)
	c.draw_polyline(_closed(rough(x + 1.5 * U, y + 1.5 * U, w - 3 * U, h - 3 * U, seed + 9, 2.4 * U)), Color(cl, 0.45), 1.2 * U, true)

static func bar(c: CanvasItem, x: float, y: float, w: float, h: float, k: float, c1: Color, c2: Color, U: float) -> void:
	_fill(c, rough(x, y, w, h, x + y, 1.4 * U), Color(0, 0, 0, 0.65))
	if k > 0:
		var fw = w * minf(1.0, k)
		# 漸變：左 c1 → 右 c2（照全長計）
		var n = 8; var p = rough(x, y, fw, h, x + y + 1, 1.2 * U)
		var cols = PackedColorArray()
		for v in p: cols.append(c1.lerp(c2, clampf((v.x - x) / maxf(1.0, w), 0, 1)))
		if not Geometry2D.triangulate_polygon(p).is_empty(): c.draw_polygon(p, cols)
		else: c.draw_rect(Rect2(x, y, fw, h), c1)
		var q = x - h
		while q < x + fw:
			var a = Vector2(maxf(q, x), y + h - (maxf(q, x) - q)); var b = Vector2(minf(q + h, x + fw), y + h - (minf(q + h, x + fw) - q))
			if b.x > a.x: c.draw_line(a, b, Color(0, 0, 0, 0.25), 1.2 * U)
			q += 4 * U
		n = n
	c.draw_polyline(_closed(rough(x, y, w, h, x + y + 5, 1.6 * U)), Color(217 / 255.0, 201 / 255.0, 168 / 255.0, 0.7), 1.4 * U, true)

static func text(c: CanvasItem, s: String, x: float, y: float, size: float, col: Color, align := "left", lw := 3.5, weight := 900) -> void:
	var f = UIKit.font("sans", weight); var fs = int(round(size))
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var px = x - (w / 2 if align == "center" else (w if align == "right" else 0.0))
	var o = int(round(lw))
	c.draw_string_outline(f, Vector2(px + 1, y + 1), s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, o, Color(8 / 255.0, 4 / 255.0, 6 / 255.0, 0.95))
	c.draw_string_outline(f, Vector2(px, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, o, Color(8 / 255.0, 4 / 255.0, 6 / 255.0, 0.95))
	c.draw_string(f, Vector2(px, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)

static func T(y: String, z: String) -> String: return DB.N(y if DB.lang == "yue" else z)

# ---------------- Turf.drawMy ----------------
static func draw_my(c: CanvasItem, ctx: Ctx, Tf: Dictionary) -> void:
	var sc = Tf.get("scr"); if not (sc is Dictionary): return
	var W = J.num(sc.w); var H = J.num(sc.h); var U = W / 390.0
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
	_draw_mini(c, Tf, sc, U)
	# 頂：主題建設度條
	var bd = J.num(J.mc(Tf, "build", []))
	bar(c, 110 * U, 50 * U, W - 220 * U, 8 * U, bd / 100.0, Color("#6d5690"), Color("#c06a2c"), U)
	_draw_jar(c, Tf, W, H, U)
	# 門外排隊
	var q = Tf.get("q")
	if q is Dictionary and J.str(q.get("st")) != "gap" and q.get("list") is Array and (q.list as Array).size():
		var lst: Array = q.list; var n = int(J.num(q.get("n", lst.size()))); if n <= 0: n = lst.size()
		var ready = J.str(q.st) == "ready"
		var bw = minf(W / 2 - 38 * U, 26 * U * n + 70 * U); var bx0 = J.num(sc.x) + 8 * U; var by0 = H - 104 * U
		var qs = minf(26 * U, (bw - 26 * U) / maxf(1.0, n - 0.4))
		panel(c, bx0, by0, bw, 46 * U, "gold" if ready else "violet", Color(26 / 255.0, 18 / 255.0, 22 / 255.0, 0.9), U, 31)
		var s = T("生人將至・%d秒後入場" % ceili(J.num(q.t)), "生人將至・%d秒後入場" % ceili(J.num(q.t))) if ready else T("生人將至 %d/%d" % [int(J.num(q.made)), n], "生人將至 %d/%d" % [int(J.num(q.made)), n])
		text(c, s, bx0 + 8 * U, bx0 * 0 + by0 + 14 * U, 11 * U, Color("#eadbbf"), "left", 3)
		if ready: bar(c, bx0 + 6 * U, by0 + 40 * U, bw - 12 * U, 4 * U, 1 - J.num(q.t) / 90.0, Color("#d9a441"), Color("#c06a2c"), U)
		var tt = Time.get_ticks_msec() / 1000.0
		var NU = J.num(J.G.get("NPC_UNIT", 69.0)); if NU <= 0: NU = 69.0
		for j in lst.size():
			var w = lst[j]; var fx = bx0 + 16 * U + j * qs; var fy = by0 + 41 * U
			_ell(c, Vector2(fx, fy), 8 * U, 2.5 * U, Color(0, 0, 0, 0.4))
			var spk = J.str(w.get("spr"))
			if spk != "" and (MeshAnim.has(spk) or Art.has_spr(spk)):
				Art.draw_char(ctx, spk, fx, fy, 26 * U / NU, {"t": tt + J.num(w.get("seed", 0)), "pose": "idle", "shadow": false})
				c.draw_set_transform_matrix(Transform2D.IDENTITY)
			if w.get("el") is Dictionary: c.draw_circle(Vector2(fx + 7 * U, fy - 26 * U), 3 * U, Color(J.str(w.el.get("tag", "#ff9a5a"))))
		for j in range(lst.size(), n):
			_ell_line(c, Vector2(bx0 + 16 * U + j * qs, by0 + 30 * U), 7 * U, 10 * U, Color(200 / 255.0, 190 / 255.0, 170 / 255.0, 0.35))
	# 嚇人力
	var s0 = J.mc(js("Street"), "st", [])
	var e = J.num(s0.get("tapE")) if s0 is Dictionary and s0.get("tapE") != null else 100.0
	var x = J.num(sc.x) + W - 150 * U; var y = H - 54 * U
	bar(c, x, y, 140 * U, 8 * U, e / 100.0, Color("#8f1f1f"), Color("#b3372c"), U)
	text(c, T("嚇人力 %d/100（撳路人）" % int(e), "嚇人力 %d/100（點路人）" % int(e)), x, y - 4 * U, 10.5 * U, Color("#eadbbf"), "left", 3.5, 700)
	var f = Tf.get("tapFx")
	if f is Dictionary:
		f.t = J.num(f.t) + 1.0 / 30.0; var a = maxf(0, 1 - J.num(f.t) / 0.5); var col = Color(170 / 255.0, 10 / 255.0, 30 / 255.0, a)
		var fp = Vector2(J.num(f.x), J.num(f.y))
		for j in 5:
			var a2 = -0.9 + j * 0.45
			c.draw_set_transform(fp + Vector2(sin(a2) * 16 * U, -cos(a2) * 18 * U), a2, Vector2(4 * U, 9 * U)); c.draw_circle(Vector2.ZERO, 1.0, col)
		c.draw_set_transform(fp + Vector2(0, 6 * U), 0, Vector2(13 * U, 11 * U)); c.draw_circle(Vector2.ZERO, 1.0, col)
		c.draw_set_transform_matrix(Transform2D.IDENTITY)
		if J.num(f.t) > 0.5: Tf["tapFx"] = null
	if Tf.get("moveFrom") != null:
		var bx = J.num(sc.x) + W / 2
		text(c, T("移位：撳另一個同類同大小嘅格（互換）", "移位：點另一個同類同大小的格（互換）"), bx, J.num(sc.y) + 40 * U, 13 * U, Color("#ffe9a0"), "center", 3)

static func js(n: String): return J.G.get(n)

static func _ell(c: CanvasItem, p: Vector2, rx: float, ry: float, col: Color) -> void:
	c.draw_set_transform(p, 0, Vector2(rx, ry)); c.draw_circle(Vector2.ZERO, 1.0, col); c.draw_set_transform_matrix(Transform2D.IDENTITY)

static func _ell_line(c: CanvasItem, p: Vector2, rx: float, ry: float, col: Color) -> void:
	var pts = PackedVector2Array()
	for i in 21:
		if i % 2 == 1: continue
		var a0 = TAU * i / 20.0; var a1 = TAU * (i + 1) / 20.0
		c.draw_line(p + Vector2(cos(a0) * rx, sin(a0) * ry), p + Vector2(cos(a1) * rx, sin(a1) * ry), col, 1.0)
	pts = pts

static func _draw_mini(c: CanvasItem, Tf: Dictionary, sc: Dictionary, U: float) -> void:
	var L = Tf.get("lay"); var b = Tf.get("box")
	if not (L is Dictionary) or not (b is Dictionary) or J.num(L.get("worldW", 0)) <= 0: return
	var W = J.num(sc.w); var WW = J.num(L.worldW); var WH = J.num(L.get("worldH", 1))
	var mw = minf(W - 120 * U, 52 * U * WW); var mh = mw / WW * 1.5; var mx = 8 * U; var my = 70 * U
	Tf["miniBox"] = [mx, my, mw, mh]
	var sx = mw / WW; var sy = mh / WH
	panel(c, mx - 5, my - 5, mw + 10, mh + 10, "bone", Color(14 / 255.0, 9 / 255.0, 12 / 255.0, 0.86), U, 21)
	var nv = int(J.num(L.get("nv", 0))); var unl = int(J.num(L.get("unlocked", 0)))
	var panels: Array = L.get("panels", []) if L.get("panels") is Array else []
	for r in panels.size():
		if r >= nv: continue
		c.draw_rect(Rect2(mx + r * sx + 1, my, sx - 2, mh), Color(110 / 255.0, 100 / 255.0, 80 / 255.0, 0.45) if r < unl else Color(40 / 255.0, 40 / 255.0, 40 / 255.0, 0.7))
	# 路線（固定，緩存一次）
	var key = "%s:%d:%d" % [J.str(J.gp(Tf.get("def"), "id")), nv, int(mw)]
	if Tf.get("_natMiniKey") != key:
		var segs = PackedVector2Array(); var nodes = L.get("nodes", {}); var edges = L.get("edges", {})
		if edges is Dictionary and nodes is Dictionary:
			for a in edges:
				var A = nodes.get(a)
				if not (A is Array): continue
				for z in edges[a]:
					var B = nodes.get(z)
					if not (B is Array): continue
					segs.append(Vector2(J.num(A[0]) * sx, J.num(A[1]) * sy)); segs.append(Vector2(J.num(B[0]) * sx, J.num(B[1]) * sy))
		Tf["_natMiniKey"] = key; Tf["_natMiniSegs"] = segs
	var sg: PackedVector2Array = Tf.get("_natMiniSegs")
	if sg.size() >= 2:
		c.draw_set_transform(Vector2(mx, my), 0, Vector2.ONE); c.draw_multiline(sg, Color(230 / 255.0, 200 / 255.0, 120 / 255.0, 0.4), 1.0); c.draw_set_transform_matrix(Transform2D.IDENTITY)
	var ws = Tf.get("walkers")
	if ws is Array:
		for w in ws:
			if J.t(w.get("gone")) or J.num(w.get("t", 0)) <= 0: continue
			var p = J.mc(Tf, "wp", [w])
			c.draw_rect(Rect2(mx + J.num(p[0]) * sx - 1.5, my + J.num(p[1]) * sy - 1.5, 3, 3), Color("#ff9a5a") if w.get("el") != null and J.t(w.get("el")) else Color("#8fd3ff"))
	var bs = Tf.get("bosses")
	if bs is Array:
		for B in bs:
			var p = J.mc(Tf, "bpos", [B]); c.draw_circle(Vector2(mx + J.num(p[0]) * sx, my + J.num(p[1]) * sy), 3, Color("#c084ff"))
	var C = Tf.get("cam")
	if C is Dictionary:
		var hx = (J.num(J.G.get("innerWidth", W)) / 2) / (J.num(b.w) * J.num(C.z)); var hy = (J.num(J.G.get("innerHeight", 800)) / 2) / (J.num(b.h) * J.num(C.z))
		c.draw_rect(Rect2(mx + (J.num(C.x) - hx) * sx, my + (J.num(C.y) - hy) * sy, 2 * hx * sx, 2 * hy * sy), Color("#ffe9a0"), false, 1.5)

static func _draw_jar(c: CanvasItem, Tf: Dictionary, W: float, H: float, U: float) -> void:
	var sd = Tf.get("sd"); var n = int(J.num(sd.get("jar", 0))) % 40 if sd is Dictionary else 0
	var cx = W / 2; var cy = H - 76 * U; var t = Time.get_ticks_msec() / 1000.0
	_ell(c, Vector2(cx, cy + 22 * U), 30 * U, 7 * U, Color(10 / 255.0, 12 / 255.0, 16 / 255.0, 0.8))
	var jar = PackedVector2Array([Vector2(cx - 20 * U, cy - 18 * U), Vector2(cx - 24 * U, cy + 18 * U)])
	for i in range(1, 8): var k = i / 8.0; jar.append(_quad(Vector2(cx - 24 * U, cy + 18 * U), Vector2(cx, cy + 28 * U), Vector2(cx + 24 * U, cy + 18 * U), k))
	jar.append(Vector2(cx + 24 * U, cy + 18 * U)); jar.append(Vector2(cx + 20 * U, cy - 18 * U))
	_fill(c, jar, Color(120 / 255.0, 160 / 255.0, 190 / 255.0, 0.18))
	var lv = n / 40.0
	if lv > 0:
		var liq = PackedVector2Array([Vector2(cx - 23 * U, cy + 18 * U - lv * 34 * U), Vector2(cx + 23 * U, cy + 18 * U - lv * 34 * U), Vector2(cx + 23 * U, cy + 18 * U)])
		for i in range(1, 8): liq.append(_quad(Vector2(cx + 23 * U, cy + 18 * U), Vector2(cx, cy + 27 * U), Vector2(cx - 23 * U, cy + 18 * U), i / 8.0))
		_fill(c, liq, Color(170 / 255.0, 140 / 255.0, 1, 0.65))
	c.draw_polyline(_closed(jar), Color(200 / 255.0, 220 / 255.0, 230 / 255.0, 0.8), 2.0, true)
	for j in mini(6, n):
		c.draw_circle(Vector2(cx - 12 * U + (j % 3) * 12 * U, cy + 10 * U - floor(j / 3.0) * 9 * U + sin(t * 3 + j) * 2), 2.5 * U, Color(230 / 255.0, 220 / 255.0, 1, 0.8))
	panel(c, cx - 23 * U, cy - 26 * U, 46 * U, 9 * U, "rust", Color(70 / 255.0, 36 / 255.0, 16 / 255.0, 0.95), U, 11)
	text(c, "%d/40" % n, cx, cy + 4 * U, 13 * U, Color("#f3d58a"), "center")

static func _quad(a: Vector2, b: Vector2, d: Vector2, k: float) -> Vector2:
	return a.lerp(b, k).lerp(b.lerp(d, k), k)

# ---------------- Turf.drawUlt（大招開場：壓暗＋橫幅特寫，逐句照 street.js）----------------
static func draw_ult(c: CanvasItem, Tf: Dictionary, Wd: float, Hd: float) -> void:
	var U = Tf.get("ult")
	if not (U is Dictionary): return
	var k = J.num(U.get("t", 0.0))
	if k >= 1.3: return
	var a = k / 0.15 if k < 0.15 else (1.0 - (k - 1.0) / 0.3 if k > 1.0 else 1.0)
	c.draw_rect(Rect2(0, 0, Wd, Hd), Color(0, 0, 0, 0.55 * a))
	var slide = minf(1.0, k / 0.25); var y0 = Hd * 0.36; var bh = Hd * 0.2; var bx = -Wd + Wd * (1.0 - pow(1.0 - slide, 3))
	var poly = PackedVector2Array([Vector2(bx, y0), Vector2(bx + Wd, y0 - 16), Vector2(bx + Wd, y0 + bh - 16), Vector2(bx, y0 + bh)])
	c.draw_colored_polygon(poly, Color(0x12 / 255.0, 0x06 / 255.0, 0x1c / 255.0, a))
	var pl = poly.duplicate(); pl.append(poly[0])
	c.draw_polyline(pl, Color(0xc0 / 255.0, 0x84 / 255.0, 1.0, a), 3.0, true)
	# 頭像：同 ART.portrait 一樣由原圖頂部裁正方形（畫喺 4%～96% 範圍）
	var r = Art.portrait_region(J.str(U.get("k", "")))
	if r.size():
		var S = bh + 20; var px = bx + 8; var py = y0 - 22
		c.draw_texture_rect_region(r[0], Rect2(px + S * 0.04, py + S * 0.04, S * 0.92, S * 0.92), r[1], Color(1, 1, 1, a))
	var tx = bx + bh + 36; var nm = J.str(U.get("name", ""))
	var fser = UIKit.font("serif", 900); var fs = int(round(bh * 0.3))
	while fs > 14 and fser.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > Wd - (tx - bx) - 14: fs -= 2
	c.draw_string_outline(fser, Vector2(tx, y0 + bh * 0.5), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 5, Color(0x2a / 255.0, 0x0a / 255.0, 0x30 / 255.0, a))
	c.draw_string(fser, Vector2(tx, y0 + bh * 0.5), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1.0, 0xe9 / 255.0, 0xb0 / 255.0, a))
	var sub = J.str(U.get("gname", "")) + "・大招"
	var fsan = UIKit.font("sans", 700); var fs2 = int(round(bh * 0.14))
	while fs2 > 10 and fsan.get_string_size(sub, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2).x > Wd - (tx - bx) - 14: fs2 -= 1
	c.draw_string(fsan, Vector2(tx, y0 + bh * 0.78), sub, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2, Color(0xd9 / 255.0, 0xc3 / 255.0, 1.0, a))
