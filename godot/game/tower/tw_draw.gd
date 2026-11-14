# 樓裡有鬼：大樓剖面上嘅「熱點」原生畫（以前喺轉譯 JS 入面每幀行幾百個 ctx 指令）
#  - 畫法逐行照 tower.js（draw() 住戶燈／任務圈、drawProps2 電器、房間遮罩、燈泡閃＋冷霧）
#  - 只讀 G（遊戲狀態），唔改任何數值
class_name TwDraw
extends RefCounted

static var _circ := PackedVector2Array()
static var _glow: Texture2D = null
static var _cols := {}

static func C(h: String) -> Color:
	if not _cols.has(h): _cols[h] = Ctx.col(h)
	return _cols[h]

static func _unit_circle() -> PackedVector2Array:
	if _circ.is_empty():
		for i in 28: _circ.append(Vector2(cos(i * TAU / 28), sin(i * TAU / 28)))
	return _circ

static func glow_tex() -> Texture2D:
	if _glow == null:
		var g = Gradient.new(); g.set_color(0, Color(1, 1, 1, 1)); g.set_color(1, Color(1, 1, 1, 0))
		var t = GradientTexture2D.new(); t.gradient = g; t.fill = GradientTexture2D.FILL_RADIAL; t.fill_from = Vector2(0.5, 0.5); t.fill_to = Vector2(1, 0.5); t.width = 64; t.height = 64
		_glow = t
	return _glow

static func ell(ci: CanvasItem, cx: float, cy: float, rx: float, ry: float, col: Color) -> void:
	var u = _unit_circle(); var pts = PackedVector2Array(); pts.resize(u.size())
	for i in u.size(): pts[i] = Vector2(cx + u[i].x * rx, cy + u[i].y * ry)
	ci.draw_colored_polygon(pts, col)
static func ell_line(ci: CanvasItem, cx: float, cy: float, rx: float, ry: float, col: Color, w: float) -> void:
	var u = _unit_circle(); var pts = PackedVector2Array(); pts.resize(u.size() + 1)
	for i in u.size(): pts[i] = Vector2(cx + u[i].x * rx, cy + u[i].y * ry)
	pts[u.size()] = pts[0]
	ci.draw_polyline(pts, col, w)
static func arc_line(ci: CanvasItem, cx: float, cy: float, r: float, a0: float, a1: float, col: Color, w: float) -> void:
	ci.draw_arc(Vector2(cx, cy), r, a0, a1, maxi(8, int(absf(a1 - a0) * r / 4)), col, w)
# 徑向光暈（等如 createRadialGradient(x,y,r0,x,y,r) 由 col→透明）
static func glow(ci: CanvasItem, x: float, y: float, r: float, col: Color) -> void:
	ci.draw_texture_rect(glow_tex(), Rect2(x - r, y - r, r * 2, r * 2), false, col)

static func _font(): return Ctx.font_res("sans", 700)
static func label(ci: CanvasItem, s: String, x: float, y: float, sz: int, fill: Color, outline := Color("#0c0c0e"), ow := 3) -> void:
	var f: Font = _font(); var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, sz).x
	var p = Vector2(x - w / 2, y)
	if ow > 0: ci.draw_string_outline(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, sz, ow, outline)
	ci.draw_string(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, sz, fill)

static func n(v) -> float: return J.num(v)
static func fy(FYS, f) -> float: return J.num(FYS[int(J.num(f))])

# ---------------- draw()：住戶燈、任務圈、故事標記 ----------------
static func units1(ctx: Ctx, G, CL, FYS) -> bool:
	if ctx.ci is Recorder: return false
	var ci: CanvasItem = ctx.ci
	ci.draw_set_transform_matrix(ctx.T)
	var y0 = n(CL.y0); var y1 = n(CL.y1); var t = n(G.t)
	var story: Array = G.story
	for un in G.units:
		var top = fy(FYS, n(un.f) + 1) + 16; var uy = n(un.y)
		if uy < y0 or top > y1: continue
		var rx0 = n(un.rx[0]); var rx1 = n(un.rx[1])
		if J.t(un.get("lit")): ci.draw_rect(Rect2(rx0, top, rx1 - rx0, uy - top - 4), Color(1, 230 / 255.0, 140 / 255.0, 0.38))
		var task = un.get("task")
		if task != null and not J.t(un.get("taskDone")):
			var tk = J.str(task)
			var col = C({"food": "#ffd54a", "money": "#ffe27a", "comb": "#e8b0a0"}.get(tk, "#ffd54a"))
			var ux = n(un.x)
			ell_line(ci, ux, uy - 34, 16, 5, Color(col, 0.6 + 0.3 * sin(t * 4)), 3)
			label(ci, {"food": "宵夜", "money": "銀包", "comb": "梳頭"}.get(tk, ""), ux, uy - 44, 11, col)
		if J.t(un.get("story")):
			var tt = "✦已收集" if story.has(un.si) else "✦故事"
			label(ci, tt, (rx0 + rx1) / 2, top + 14, 11, C("#cfe8dc"))
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true

# ---------------- 燈泡閃＋冷霧 ----------------
static func lamps(ctx: Ctx, G, FYS, FL: int, camy: float, viewH: float, WW: float) -> bool:
	if ctx.ci is Recorder: return false
	var ci: CanvasItem = ctx.ci
	ci.draw_set_transform_matrix(ctx.T)
	var t = n(G.t); var dark = G.dark
	for f in FL:
		if fy(FYS, f) < camy - 20 or fy(FYS, f + 1) > camy + viewH + 40: continue
		var ly = fy(FYS, f + 1) + 18
		var fl = 0.55 + 0.45 * sin(t * 13 + f * 2.1) * sin(t * 3.7 + f)
		if int(floor(t * 7 + f * 5)) % 23 == 0: fl = 0.1
		var dk = n(dark[f]) if dark is Array and f < dark.size() else n(J.gp(dark, str(f)))
		if dk != 0: fl = 0
		if fl > 0:
			for u in G.units:
				if int(n(u.f)) != f: continue
				var lx = (n(u.rx[0]) + n(u.rx[1])) / 2
				glow(ci, lx, ly, 46, Color(1, 214 / 255.0, 140 / 255.0, 0.32 * fl))
		for k in 3:
			var fx = fposmod(t * (10 + k * 4) + k * 200 + f * 90, WW + 100) - 50
			ell(ci, fx, fy(FYS, f) - 6, 70, 9, Color(180 / 255.0, 220 / 255.0, 210 / 255.0, 0.07))
		if dk != 0:
			ci.draw_rect(Rect2(0, fy(FYS, f + 1) + 8, WW, fy(FYS, f) - fy(FYS, f + 1) - 6), Color(0, 0, 0, minf(0.78, dk * 0.6)))
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true

# ---------------- 房間遮罩：未踩點＝黑屋；鎖住＝鎖頭；門閂住＝木門；屋內有乜 ----------------
static func mask(ctx: Ctx, G, CL, FYS, ITEM) -> bool:
	if ctx.ci is Recorder: return false
	var ci: CanvasItem = ctx.ci
	ci.draw_set_transform_matrix(ctx.T)
	var y0 = n(CL.y0); var y1 = n(CL.y1)
	for u in G.units:
		var top = fy(FYS, n(u.f) + 1) + 16; var uy = n(u.y)
		if uy < y0 or top > y1: continue
		var rx0 = n(u.rx[0]); var rx1 = n(u.rx[1]); var w = rx1 - rx0; var hgt = uy - top - 4
		var opn = J.t(u.get("open"))
		if not J.t(u.get("seen")):
			ci.draw_rect(Rect2(rx0, top, w, hgt), Color(2 / 255.0, 2 / 255.0, 4 / 255.0, 0.82 if opn else 0.9))
			var uf = n(u.get("unlockFx", 0))
			if uf > 0: ci.draw_rect(Rect2(rx0 + 2, top + 2, w - 4, hgt - 4), Color(159 / 255.0, 214 / 255.0, 191 / 255.0, uf), false, 3)
		var ot = u.get("ot")
		if not opn and J.str(ot) != "deity":
			var cx = (rx0 + rx1) / 2; var cy = top + hgt * 0.5
			ci.draw_circle(Vector2(cx, cy), 20, Color(0, 0, 0, 0.6))
			arc_line(ci, cx, cy - 5, 6, PI, TAU, C("#c8a050"), 2.5)
			ci.draw_rect(Rect2(cx - 8, cy - 4, 16, 12), C("#c8a050"))
			var otn = n(ot) if (ot is float or ot is int) else -1.0
			var tx = ("破鎮宅 %s/%s" % [J.str(u.paid), J.str(u.cost)]) if otn == 2 else ("要鎖匙" if otn == 11 else "隔籬未亂")
			label(ci, tx, cx, cy + 30, 11, C("#ffe9a0"), Color.BLACK)
			if otn == 2 and n(u.paid) > 0: arc_line(ci, cx, cy, 24, -PI / 2, -PI / 2 + TAU * n(u.paid) / maxf(1, n(u.cost)), C("#9fd6bf"), 4)
		if J.t(u.get("door")):
			var dx = n(u.x); var dop = n(u.get("doorOpen", 0)); var a = 0.25 if dop > 0 else 1.0
			ci.draw_rect(Rect2(dx - 12, uy - 62, 24, 58), Color(C("#4a3020"), a))
			ci.draw_rect(Rect2(dx - 12, uy - 62, 24, 58), Color(C("#c8a050"), a), false, 2)
			ci.draw_rect(Rect2(dx + 6, uy - 34, 3, 3), Color(C("#c8a050"), a))
			if dop > 0: label(ci, "門開咗！", dx, uy - 68, 11, C("#9fd6bf"), Color.BLACK, 0)
		var items = u.get("items")
		if J.t(u.get("seen")) and items is Array and items.size() and opn:
			var cnt = {}; var ord = []
			for k in items:
				if not cnt.has(k): cnt[k] = 0; ord.append(k)
				cnt[k] += 1
			var parts = []
			for k in ord: parts.append(J.str(J.gp(ITEM[k], "n")) + ("×%d" % cnt[k] if cnt[k] > 1 else ""))
			var f: Font = Ctx.font_res("sans", 400)
			var s = " ".join(parts); var sw = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x
			var p = Vector2((rx0 + rx1) / 2 - sw / 2, top + 28)
			ci.draw_string_outline(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, 3, Color.BLACK)
			ci.draw_string(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, C("#e8d8b0"))
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true

# ---------------- drawProps2：電器、走廊機關、防煙門 ----------------
static func props(ctx: Ctx, G, CL, FYS) -> bool:
	if ctx.ci is Recorder: return false
	var ci: CanvasItem = ctx.ci
	var T0: Transform2D = ctx.T
	ci.draw_set_transform_matrix(T0)
	var y0 = n(CL.y0); var y1 = n(CL.y1); var T = n(G.t)
	var F: Font = _font()
	for u in G.units:
		if not J.t(u.get("seen")) and not J.t(u.get("entered")): continue
		var uy = n(u.y)
		if uy < y0 or uy - 140 > y1: continue
		for p in u.props:
			var x = n(p.x); var y = uy - 4; var pt = n(p.t); var a = pt > 0; var k = J.str(p.k)
			match k:
				"tv":
					ci.draw_rect(Rect2(x - 14, y - 40, 28, 20), C("#1a1a1e"))
					ci.draw_rect(Rect2(x - 12, y - 38, 24, 16), Color(220 / 255.0, 230 / 255.0, 240 / 255.0, 0.5 + 0.5 * randf()) if a else C("#2a3440"))
					if a: ci.draw_circle(Vector2(x, y - 30), 5, Color(20 / 255.0, 20 / 255.0, 20 / 255.0, 0.7))
					ci.draw_rect(Rect2(x - 10, y - 20, 20, 16), C("#4a3424"))
				"fan":
					ci.draw_line(Vector2(x, y), Vector2(x, y - 30), C("#bbb"), 2)
					var rot = T * (40.0 if a else 6.0)
					for i in 3:
						ci.draw_set_transform_matrix(T0 * Transform2D(rot + 2.094 * (i + 1), Vector2(x, y - 34)))
						ci.draw_rect(Rect2(0, -2, 9, 4), Color(200 / 255.0, 210 / 255.0, 220 / 255.0, 0.8))
					ci.draw_set_transform_matrix(T0)
					ci.draw_arc(Vector2(x, y - 34), 10, 0, TAU, 20, C("#888"), 2)
				"fridge":
					ci.draw_rect(Rect2(x - 9, y - 40, 18, 38), C("#7d8786"))
					ci.draw_rect(Rect2(x - 9, y - 40, 5, 38), Color(1, 1, 1, 0.12))
					ci.draw_rect(Rect2(x - 9, y - 40, 18, 38), C("#2a2e2e"), false, 1.5)
					ci.draw_line(Vector2(x - 9, y - 26), Vector2(x + 9, y - 26), C("#2a2e2e"), 1.5)
					ci.draw_rect(Rect2(x + 5, y - 36, 2, 7), C("#c8c8c0"))
					if a:
						var o = absf(sin(T * 9)) * 16
						ci.draw_rect(Rect2(x + 10, y - 46, o, 30), C("#b8c0c0")); ci.draw_rect(Rect2(x - 8, y - 44, 16, 26), Color(200 / 255.0, 240 / 255.0, 1, 0.5))
				"pc":
					ci.draw_rect(Rect2(x - 13, y - 38, 26, 18), C("#202428"))
					ci.draw_rect(Rect2(x - 11, y - 36, 22, 14), (C("#e8e8e8") if int(floor(T * 8)) % 2 else C("#d02020")) if a else C("#3a6ad0"))
					if a:
						ci.draw_rect(Rect2(x - 5, y - 32, 3, 3), Color.BLACK); ci.draw_rect(Rect2(x + 2, y - 32, 3, 3), Color.BLACK); ci.draw_rect(Rect2(x - 4, y - 26, 8, 2), Color.BLACK)
					ci.draw_rect(Rect2(x - 16, y - 20, 32, 4), C("#4a3424"))
				"radio":
					ci.draw_rect(Rect2(x - 10, y - 26, 20, 12), C("#8a5a3a")); ci.draw_rect(Rect2(x + 3, y - 23, 4, 4), C("#ffd54a"))
					if a:
						var w1 = F.get_string_size("♪", HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
						ci.draw_string(F, Vector2(x - 8 + sin(T * 5) * 6 - w1 / 2, y - 34 - fposmod(T * 30, 14)), "♪", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, C("#ffe9a0"))
						ci.draw_string(F, Vector2(x + 8 - w1 / 2, y - 30 - fposmod(T * 30 + 7, 14)), "♫", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, C("#ffe9a0"))
				"phone":
					ci.draw_rect(Rect2(x - 4, y - 22, 8, 12), C("#202428"))
					if a:
						for i in 2: arc_line(ci, x, y - 16, 7 + i * 5 + fposmod(T * 20, 5), -0.8, 0.8, Color(159 / 255.0, 224 / 255.0, 1, 0.8), 1.5)
				"mahjong":
					ci.draw_rect(Rect2(x - 22, y - 24, 44, 6), C("#2a6a3a")); ci.draw_rect(Rect2(x - 20, y - 18, 4, 14), C("#4a3424")); ci.draw_rect(Rect2(x + 16, y - 18, 4, 14), C("#4a3424"))
					for i in 8: ci.draw_rect(Rect2(x - 18 + i * 4.6, y - 28 - (absf(sin(T * 14 + i)) * 6 if a else 0.0), 3.6, 4), C("#f0ead8"))
				"doorbell":
					var ux = n(u.x)
					ci.draw_circle(Vector2(ux + 16, y - 52), 3, C("#c8a050"))
					for i in 3: ci.draw_rect(Rect2(x - 14 + i * 9, y - 10 - (i % 2) * 8, 10, 8), C("#a07040"))
					if a:
						var wd = F.get_string_size("叮噹", HORIZONTAL_ALIGNMENT_LEFT, -1, 11).x
						ci.draw_string(F, Vector2(ux + 16 - wd / 2, y - 60), "叮噹", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, C("#ffd54a"))
				"washer":
					ci.draw_rect(Rect2(x - 12, y - 30, 24, 28), C("#e8e8e2")); ci.draw_rect(Rect2(x - 12, y - 30, 24, 28), C("#777"), false, 1)
					ci.draw_set_transform_matrix(T0 * Transform2D(T * 20 if a else 0.0, Vector2(x, y - 15)))
					ci.draw_circle(Vector2.ZERO, 8, C("#6a8aa8")); ci.draw_rect(Rect2(-2, -7, 4, 6), C("#e8e2d0"))
					ci.draw_set_transform_matrix(T0)
				"kettle", "rice":
					ell(ci, x, y - 26, 8, 7, C("#b8bcc0") if k == "kettle" else C("#e8e2d0"))
					if a:
						for i in 2: ci.draw_circle(Vector2(x + (6 if i else -2), y - 36 - fposmod(T * 30 + i * 8, 16)), 3, Color(230 / 255.0, 230 / 255.0, 230 / 255.0, 0.5))
				"ancestor":
					ci.draw_rect(Rect2(x - 9, y - 56, 18, 22), C("#6a1a16")); ci.draw_rect(Rect2(x - 6, y - 53, 12, 3), C("#ffd54a"))
					ci.draw_circle(Vector2(x, y - 30), 4, Color(C("#ff8a5a"), 0.35 + 0.15 * sin(T * 3)))
			if a and k != "ancestor": ci.draw_arc(Vector2(x, y - 28), 22 + (3 - pt) * 10, 0, TAU, 32, Color(138 / 255.0, 1, 200 / 255.0, 0.4 * pt / 3), 2)
	# 走廊機關
	var cps = G.get("cprops")
	if cps is Array:
		for p in cps:
			var nd = G.nodes[p.node]; var x = n(nd.x) + 22; var y = n(nd.y)
			if y < y0 or y - 130 > y1: continue
			var pt = n(p.t)
			if J.str(p.k) == "pipeK":
				ci.draw_line(Vector2(x, y - 110), Vector2(x, y - 6), C("#7a8a86"), 3)
				if pt > 0:
					for i in 3: ci.draw_arc(Vector2(x, y - 60), 8 + i * 7 + (3 - pt) * 6, 0, TAU, 24, Color(1, 213 / 255.0, 74 / 255.0, pt / 3), 3)
			else:
				var on = (int(floor(T * 12)) % 2) if pt > 0 else 1
				var nx = n(nd.x)
				ci.draw_rect(Rect2(nx - 10, y - 118, 20, 4), Color(1, 240 / 255.0, 180 / 255.0, 0.9) if on else C("#333"))
				if on: glow(ci, nx, y - 114, 40, Color(1, 240 / 255.0, 180 / 255.0, 0.25))
	# 防煙門
	if not G.has("_fe"):
		var fe = []
		for e in G.edges: if e.get("fire") != null: fe.append(e)
		G["_fe"] = fe
	for e in G._fe:
		var fr = e.fire; var x = n(fr.x); var y = fy(FYS, fr.f)
		if y < y0 or y - 80 > y1: continue
		var sh = n(fr.shut)
		if sh > 0:
			ci.draw_rect(Rect2(x - 6, y - 70, 12, 66), C("#6a1e1a")); ci.draw_rect(Rect2(x - 6, y - 70, 12, 66), C("#ffd54a"), false, 1.5)
			var f9: Font = Ctx.font_res("sans", 400); var s = str(int(ceil(sh))); var sw = f9.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, 9).x
			ci.draw_string(f9, Vector2(x - sw / 2, y - 74), s, HORIZONTAL_ALIGNMENT_LEFT, -1, 9, C("#e8e2d0"))
		else: ci.draw_rect(Rect2(x - 6, y - 70, 12, 66), Color(160 / 255.0, 60 / 255.0, 50 / 255.0, 0.5), false, 1)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true

# ---------------- 小地圖（drawMini，crPanel 底照用 JS 畫） ----------------
static func mini(ctx: Ctx, G, FYS, mx: float, my: float, mw: float, mh: float, WW: float, WH: float, camx: float, camy: float, vw: float, vh: float, FL: int) -> bool:
	if ctx.ci is Recorder: return false
	var ci: CanvasItem = ctx.ci
	ci.draw_set_transform_matrix(ctx.T)
	var sx = mw / WW; var sy = mh / WH
	for u in G.units:
		var top = fy(FYS, n(u.f) + 1) + 16
		var col = C("#5a2420") if J.str(u.get("ot")) == "deity" else (C("#2a2430") if not J.t(u.get("open")) else (C("#3a4632") if (J.t(u.get("seen")) or J.t(u.get("entered"))) else C("#1c1820")))
		ci.draw_rect(Rect2(mx + n(u.rx[0]) * sx + 0.5, my + top * sy, (n(u.rx[1]) - n(u.rx[0])) * sx - 1, (n(u.y) - top) * sy), col)
	for id in ["f0_e", "f%d_p" % FL]:
		var nd = G.nodes.get(id)
		if nd != null: ci.draw_rect(Rect2(mx + n(nd.x) * sx - 2, my + n(nd.y) * sy - 3, 4, 3), C("#8aac6c"))
	for h in G.guards:
		var st = J.str(h.state)
		if st == "gone": continue
		var col2 = C("#d87e3c") if J.str(h.kind) == "collector" else (C("#e0483a") if st == "chase" else C("#b8786a"))
		ci.draw_rect(Rect2(mx + n(h.x) * sx - 1.5, my + n(h.y) * sy - 3, 3, 3), col2)
	var i = 0; var act = int(n(G.active))
	for g in G.gh:
		if not J.t(g.get("home")) and not J.t(g.get("out")):
			ci.draw_circle(Vector2(mx + n(g.x) * sx, my + n(g.y) * sy - 2), 3 if i == act else 2, C("#efe5cf") if i == act else C("#9c88cc"))
		i += 1
	ci.draw_rect(Rect2(mx + camx * sx, my + camy * sy, vw * sx, vh * sy), Color(216 / 255.0, 204 / 255.0, 176 / 255.0, 0.6), false, 1.2)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true
