# [zone] 分區地圖畫面：區牆＋門洞、區名牌、未佔領資源區（黑霧＋鎖＋建議戰力）、野外區（擺設、王、進度）、點擊、彈出卡
# 全部 static（冇 class_name、冇 autoload）；const ZV = preload("res://game/zone/zone_view.gd")
# 畫：nv_village 嘅兩層 PtDraw（under：地面之上、建築之下；over：建築之上），ctx 係世界座標。
# 字：區名牌／戰力字按縮放放大（縮到最細睇成張圖時畫面上都唔細過 14px）。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const WALL_W := 10.0
const WALL_COL := {"wild": "#4a1c20", "market": "#4a3422", "village": "#4a3422", "res": "#2e2a30"}

static func _fs(nv, base: float) -> int:   # 世界字大細：畫面上最少 base px
	var rel = float(nv.sc) / maxf(0.01, float(nv.size.x) / 390.0)
	return int(ceil(maxf(base, base / maxf(0.05, rel) * 0.95)))
static func _txt(ctx: Ctx, s: String, x: float, y: float, px: int, col := "#f6e2b0", outline := "rgba(20,8,8,.95)") -> void:
	ctx.font = "900 %dpx %s" % [px, Art.SERIF]; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineWidth = maxf(3.0, px * 0.22); ctx.strokeStyle = outline; ctx.lineJoin = "round"; ctx.strokeText(s, x, y)
	ctx.fillStyle = col; ctx.fillText(s, x, y)
static func _plate(ctx: Ctx, s: String, x: float, y: float, px: int, bg: String, fg := "#fff4e2") -> Rect2:
	ctx.font = "900 %dpx %s" % [px, Art.SERIF]
	var w = ctx.measureText(s).width + px * 1.1; var h = px * 1.55
	Art.rr(ctx, x - w / 2, y - h / 2, w, h, px * 0.35, bg, "rgba(255,230,190,.55)", maxf(1.2, px * 0.08))
	_txt(ctx, s, x, y + 1, px, fg)
	return Rect2(x - w / 2, y - h / 2, w, h)

# ---------------- 開口（門洞、野外門、路） ----------------
static func openings() -> Array:
	var o = []
	var m = ZD.cur()
	for z in ZD.zones():
		if z.get("door") is Dictionary: o.append(ZD.rect(z.door.rect).grow(4))
		if z.get("gate") is Dictionary:
			var r = ZD.rect(z.rect); var gx = float(z.gate.x); var gw = float(z.gate.get("w", 60))
			o.append(Rect2(gx - gw / 2.0, r.end.y - 14, gw, 50))
	for rd in m.get("roads", []): o.append(ZD.rect(rd).grow(-1))
	return o
static func _open(p: Vector2, ops: Array) -> bool:
	for r in ops: if r.has_point(p): return true
	return false
# 一條邊（a→b）減咗開口之後嘅實牆段
static func _segs(a: Vector2, b: Vector2, ops: Array) -> Array:
	var o = []; var n = int(ceil(a.distance_to(b) / 4.0)); var st = -1
	for i in n + 1:
		var p = a.lerp(b, float(i) / n)
		var op = _open(p, ops)
		if not op and st < 0: st = i
		if (op or i == n) and st >= 0:
			var e = i if not op else i - 1
			if e > st: o.append([a.lerp(b, float(st) / n), a.lerp(b, float(e) / n)])
			st = -1
	return o

# ---------------- 下層：地形阻隔（山岩懸崖／亂石山脊／木樁防線／樹林帶／石牆拱門／小河木橋）、野外擺設、未佔領門口路障 ----------------
# 老闆 11:52：唔要一格格方框牆，全圖連續地形，區與區之間用地形／建造物隔開（zones.json barriers）。
# 美術鍵（主對話生；未有圖就程序畫）：zb_rock1–3、zb_cliff、zb_stakes、zb_wall、zb_arch、zb_bridge
static func draw_under(c: CanvasItem, nv) -> void:
	if not ZD.on(): return
	var ctx = Ctx.new(c)
	var t: float = nv.t
	var vr: Rect2 = nv.view_rect().grow(120)
	var bs = ZD.cur().get("barriers", [])
	for kind in ["river", "cliff", "ridge", "stakes", "forest", "stonewall"]:
		for b in bs:
			if str(b.k) == kind: _barrier(c, ctx, b, vr, t)
	for z in ZD.zones():
		if str(z.type) == "wild" and ZD.rect(z.rect).intersects(vr): _wild_decor(ctx, z, t)
	for z in ZD.of_type("res"):   # 未佔領：門洞／小徑／橋頭打橫幾條木閘
		if z.get("door") is Dictionary and not ZD.owned(str(z.id)) and ZD.rect(z.door.rect).intersects(vr): _door(ctx, ZD.rect(z.door.rect), false)

static var _geo := {}   # 程序地形快取（固定種子）
# 呢點係咪喺阻隔物上面（碰撞：測試同行路檢查用；門洞／小徑／橋唔算）
static func blocked(p: Vector2) -> bool:
	for b in ZD.cur().get("barriers", []):
		match str(b.k):
			"ridge": if ZD.rect(b.rect).has_point(p): return true
			"cliff":
				for r in b.rects: if ZD.rect(r).has_point(p): return true
			"forest", "stonewall":
				if p.x >= float(b.x0) and p.x <= float(b.x1) and p.y >= float(b.y0) and p.y <= float(b.y1) and not (p.y >= float(b.gap[0]) and p.y <= float(b.gap[1])): return true
			"river":
				var br = b.get("bridge", [0, 0])
				if absf(p.y - river_y(b, p.x)) < 12.0 and not (p.x >= float(br[0]) and p.x <= float(br[1])): return true
			"stakes":
				if p.y > float(b.y) - 34 and p.y < float(b.y) + 3 and p.x >= float(b.x0) and p.x <= float(b.x1):
					var ing = false
					for g in b.gaps: if p.x >= float(g[0]) and p.x <= float(g[1]): ing = true
					if not ing: return true
	return false
static func _barrier(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	match str(b.k):
		"river": _river(c, ctx, b, vr, t)
		"cliff":
			for r in b.rects:
				var rr = ZD.rect(r)
				if rr.intersects(vr): _rock_field(c, "cliff:%s" % str(r), rr, vr, 4200.0, true, t)
		"ridge":
			var rr2 = ZD.rect(b.rect)
			if rr2.intersects(vr): _rock_field(c, "ridge", rr2, vr, 800.0, false, t)
		"stakes": _stakes(c, ctx, b, vr, t)
		"forest": _forest(ctx, b, vr)
		"stonewall": _stonewall(c, ctx, b, vr)

# 貼圖（底部對齊、可以左右翻轉、可以只用一截 src＝[x0,y0,x1,y1] 比例）
static func _sp(c: CanvasItem, key: String, x: float, y: float, w: float, flip := false, tint := Color.WHITE, src = null) -> void:
	if not Spr.ok(key): return
	var tx = Spr.get_tex(key)
	var sr = Rect2(0, 0, tx.get_width(), tx.get_height())
	if src is Array: sr = Rect2(tx.get_width() * src[0], tx.get_height() * src[1], tx.get_width() * (src[2] - src[0]), tx.get_height() * (src[3] - src[1]))
	var h = w * sr.size.y / sr.size.x
	if flip: c.draw_set_transform(Vector2(2.0 * x, 0), 0, Vector2(-1, 1))
	c.draw_texture_rect_region(tx, Rect2(x - w / 2.0, y - h, w, h), sr, tint)
	if flip: c.draw_set_transform_matrix(Transform2D.IDENTITY)

# 山岩：大山岩（zb_rock1）＋細亂石（zb_rock2）；cliff 再加懸崖邊（zb_cliff）、黑森林（黑灌木 zb_bush＋暗枯樹）同濃霧
#   冇圖：程序畫多邊形石
static func _rock_field(c: CanvasItem, key: String, r: Rect2, vr: Rect2, per: float, cliff: bool, t: float) -> void:
	if not _geo.has(key):
		var rng = RandomNumberGenerator.new(); rng.seed = hash(key) & 0x7fffffff
		var it = []
		var n = int(r.get_area() / per)
		for i in n:
			var cx = rng.randf_range(r.position.x, r.end.x); var cy = rng.randf_range(r.position.y + 20, r.end.y + 6)
			var big = rng.randf() < (0.55 if cliff else 0.6)
			it.append({"k": "zb_rock1" if big else "zb_rock2", "x": cx, "y": cy, "w": (rng.randf_range(110, 150) if big else rng.randf_range(80, 110)) * (1.0 if cliff else 0.55), "f": rng.randf() < 0.5, "g": rng.randf_range(0.72, 0.9)})
		if cliff:
			var ed = []
			if r.end.y < 1200 and r.end.y > 1000: ed.append(["b", r.end.y])     # 上面兩塊：底邊（資源區 A／B 頂）係懸崖邊
			var x = r.position.x + 20
			while x < r.end.x:
				for e in ed: it.append({"k": "zb_cliff", "x": x + rng.randf_range(-8, 8), "y": float(e[1]) + 12, "w": rng.randf_range(120, 140), "f": rng.randf() < 0.5, "g": 0.85})
				x += 110.0
			# 黑森林：沿住靠近可行區嗰邊
			var inner_x = r.end.x - 30.0 if r.position.x < 10 else r.position.x + 30.0
			var y = r.position.y + 60
			while y < r.end.y + 10:
				it.append({"k": "zb_bush", "x": inner_x + rng.randf_range(-24, 24), "y": y, "w": rng.randf_range(90, 120), "f": rng.randf() < 0.5, "g": rng.randf_range(0.55, 0.7)})
				y += rng.randf_range(70, 110)
		it.sort_custom(func(a, b2): return a.y < b2.y)
		_geo[key] = it
	var sp = Spr.ok("zb_rock1")
	for e in _geo[key]:
		if e.x < vr.position.x - 80 or e.x > vr.end.x + 80 or e.y < vr.position.y or e.y - 140 > vr.end.y: continue
		if sp: _sp(c, e.k, e.x, e.y, e.w, e.f, Color(e.g, e.g * 0.96, e.g * 1.02))
		else: _proc_rock(c, Vector2(e.x, e.y - e.w * 0.25), e.w * 0.3)
	if cliff:
		PtGfx.init()
		var n2 = int(r.get_area() / 22000.0) + 2
		for i in n2:   # 濃霧：慢慢飄
			var fx = r.position.x + fmod(i * 131.0 + t * (5.0 + (i % 3) * 2.0), r.size.x + 160.0) - 80.0
			var fy = r.position.y + fmod(i * 197.0, maxf(1.0, r.size.y))
			if not vr.grow(120).has_point(Vector2(fx, fy)): continue
			c.draw_texture_rect(PtGfx.RAD, Rect2(fx - 130, fy - 80, 260, 160), false, Color(0.40, 0.34, 0.46, 0.26))
static func _proc_rock(c: CanvasItem, cen: Vector2, rad: float) -> void:
	var pts = PackedVector2Array()
	for k in 8:
		var a = k * PI / 4.0
		pts.append(cen + Vector2(cos(a) * rad * (0.8 + 0.2 * sin(k * 2.1 + cen.x)), sin(a) * rad * 0.75))
	var g = 0.2 + fmod(absf(cen.x * 0.13 + cen.y * 0.07), 0.08)
	c.draw_colored_polygon(pts, Color(g, g - 0.015, g + 0.025))
	var ol = pts.duplicate(); ol.append(pts[0]); c.draw_polyline(ol, Color(0.07, 0.05, 0.09), 1.6, true)
	c.draw_polyline(PackedVector2Array([pts[5], pts[6], pts[7]]), Color(g + 0.12, g + 0.1, g + 0.14), 2.4, true)

# 削尖木樁防線（zb_stakes 一段段拼，錯開、隨機縮放；兩道野外門留空）
static func _stakes(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	var y = float(b.y)
	if y < vr.position.y - 80 or y - 80 > vr.end.y: return
	var gaps = b.get("gaps", [])
	var segs = []   # [x0, x1]
	var x0 = float(b.x0)
	for g in gaps: segs.append([x0, float(g[0])]); x0 = float(g[1])
	segs.append([x0, float(b.x1)])
	if Spr.ok("zb_stakes"):
		for sg in segs:
			var L = float(sg[1]) - float(sg[0]); var n = maxi(1, int(ceil(L / 78.0)))
			var step = L / n
			for i in n:
				var cx = float(sg[0]) + step * (i + 0.5)
				if cx < vr.position.x - 60 or cx > vr.end.x + 60: continue
				var k = 0.85 + fmod(absf(cx * 0.731), 0.25)
				_sp(c, "zb_stakes", cx, y + 8, (step + 14) * 1.02, int(cx / 37.0) % 2 == 1, Color(0.86, 0.8, 0.8), [0.0, 0.25 - (k - 0.85) * 0.2, 1.0, 1.0])
	else:
		for sg in segs:
			var x = float(sg[0])
			while x < float(sg[1]) - 4:
				if x > vr.position.x - 20 and x < vr.end.x + 20:
					var lean = sin(x * 0.37) * 1.5; var hh = 30.0 + fmod(x * 1.7, 8.0)
					var pts = PackedVector2Array([Vector2(x + 1, y + 2), Vector2(x + 12, y + 2), Vector2(x + 12 + lean, y - hh + 8), Vector2(x + 6.5 + lean, y - hh), Vector2(x + 1 + lean, y - hh + 8)])
					c.draw_colored_polygon(pts, Color("#5e4430"))
					var ol = pts.duplicate(); ol.append(pts[0]); c.draw_polyline(ol, Color("#1e140c"), 1.3, true)
				x += 13.0
	for g in gaps: _gate(ctx, (float(g[0]) + float(g[1])) / 2.0, y - 8, float(g[1]) - float(g[0]), t)

# 樹林帶（黑灌木 zb_bush＋竹＋槐樹，錯開疊住），中間一條小徑
static func _forest(ctx: Ctx, b: Dictionary, vr: Rect2) -> void:
	var key = "forest"
	if not _geo.has(key):
		var rng = RandomNumberGenerator.new(); rng.seed = 5151
		var it = []
		var y = float(b.y0) + 26.0
		var kinds = ["zb_bush", "rn_bamboo", "tree", "zb_bush", "rn_bamboo"]
		var i = 0
		while y <= float(b.y1) + 8:
			if not (y > float(b.gap[0]) - 4 and y < float(b.gap[1]) + 40):
				var k = kinds[i % kinds.size()]
				var w = {"zb_bush": rng.randf_range(70, 86), "rn_bamboo": rng.randf_range(50, 60), "tree": rng.randf_range(56, 64)}[k]
				it.append([k, rng.randf_range(float(b.x0) + 14, float(b.x1) - 14), y, w, rng.randf() < 0.5])
				i += 1
			y += 24.0
		it.sort_custom(func(a, b2): return a[2] < b2[2])
		_geo[key] = it
	var c = ctx.ci
	for e in _geo[key]:
		if float(e[2]) < vr.position.y or float(e[2]) - 90 > vr.end.y: continue
		var tint = Color(0.62, 0.58, 0.6) if e[0] == "tree" else (Color(0.66, 0.7, 0.62) if e[0] == "rn_bamboo" else Color(0.8, 0.78, 0.8))
		_sp(c, e[0], float(e[1]), float(e[2]), float(e[3]), e[4], tint)
	var gy = (float(b.gap[0]) + float(b.gap[1])) / 2.0   # 小徑：踩實嘅泥
	Art.el(ctx, (float(b.x0) + float(b.x1)) / 2.0, gy, (float(b.x1) - float(b.x0)) * 0.7, 22, "rgba(70,52,36,.4)")

# 青苔舊石牆（zb_wall 截一段石塊，一節節直疊）＋拱門（zb_arch）
static func _stonewall(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2) -> void:
	var x0 = float(b.x0); var x1 = float(b.x1); var cx = (x0 + x1) / 2.0
	if x1 < vr.position.x - 40 or x0 > vr.end.x + 40: return
	var gy0 = float(b.gap[0]); var gy1 = float(b.gap[1])
	if Spr.ok("zb_wall"):
		var y = float(b.y0) + 26.0; var i = 0
		while y <= float(b.y1) + 4:
			if not (y > gy0 - 2 and y < gy1 + 30) and y > vr.position.y - 10 and y - 60 < vr.end.y:
				var u0 = [0.02, 0.30, 0.55][i % 3]
				_sp(c, "zb_wall", cx + sin(y) * 1.5, y, 46.0, i % 2 == 1, Color(0.82, 0.8, 0.8), [u0, 0.42, u0 + 0.42, 1.0])
			y += 20.0; i += 1
		if Spr.ok("zb_arch"): _sp(c, "zb_arch", cx, gy1 + 22, 96.0, false, Color(0.85, 0.82, 0.82))
		return
	var y2 = float(b.y0); var row = 0
	while y2 < float(b.y1):
		var gap = y2 + 16 > gy0 and y2 < gy1
		if not gap and y2 > vr.position.y - 20 and y2 < vr.end.y + 20:
			var off = 0.0 if row % 2 == 0 else 7.0
			var xx = x0 - off
			while xx < x1:
				var a0 = maxf(xx, x0); var a1 = minf(xx + 15, x1)
				var g = 0.30 + fmod(absf(xx * 13.0 + y2 * 7.0), 9.0) / 100.0
				c.draw_rect(Rect2(a0, y2, a1 - a0 - 1, 15), Color(g, g - 0.03, g - 0.05))
				c.draw_rect(Rect2(a0, y2, a1 - a0 - 1, 15), Color(0.1, 0.08, 0.08), false, 1.0)
				xx += 15.0
		y2 += 16.0; row += 1
	ctx.strokeStyle = "#6a625e"; ctx.lineWidth = 7
	ctx.beginPath(); ctx.ellipse(cx, gy0 + 2, (x1 - x0) * 0.5 + 6, 18, 0, PI, TAU); ctx.stroke()

# 暗色小河（兩端入山岩）＋破木橋
static func river_y(b: Dictionary, x: float) -> float: return float(b.y) + float(b.get("amp", 7)) * sin(x / 70.0)
static func _river(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	var y0 = float(b.y)
	if y0 < vr.position.y - 40 or y0 > vr.end.y + 40: return
	var pts = PackedVector2Array()
	var x = maxf(float(b.x0), vr.position.x - 20)
	while x <= minf(float(b.x1), vr.end.x + 20): pts.append(Vector2(x, river_y(b, x))); x += 12.0
	if pts.size() < 2: return
	c.draw_polyline(pts, Color("#1a2418"), 30.0, true)   # 岸邊濕泥
	c.draw_polyline(pts, Color("#101c28"), 22.0, true)
	c.draw_polyline(pts, Color("#1c3442"), 14.0, true)
	for i in pts.size() - 1:   # 水光：慢慢流
		var ph = fmod(pts[i].x * 0.05 + t * 1.6, 6.0)
		if ph < 1.2: c.draw_line(pts[i] + Vector2(0, -2), pts[i + 1] + Vector2(0, -2), Color(0.45, 0.62, 0.68, 0.5 * (1.2 - ph)), 1.6)
	var br = b.get("bridge")
	if br is Array:
		var bx0 = float(br[0]); var bx1 = float(br[1]); var by = river_y(b, (bx0 + bx1) / 2.0)
		if Spr.ok("zb_bridge"):
			_sp(c, "zb_bridge", (bx0 + bx1) / 2.0, by + 34, (bx1 - bx0) * 2.0, false, Color(0.88, 0.85, 0.85))
			return
		Art.rr(ctx, bx0, by - 20, bx1 - bx0, 40, 2, "#6e5034", "#22160c", 1.6)
		ctx.strokeStyle = "#3e2a18"; ctx.lineWidth = 1.2
		var xx = bx0 + 6.0
		while xx < bx1 - 2:
			ctx.beginPath(); ctx.moveTo(xx, by - 19); ctx.lineTo(xx + sin(xx) * 1.5, by + 19); ctx.stroke(); xx += 8.0
		Art.rr(ctx, bx0 + 22, by - 6, 9, 9, 1, "#1c3442")   # 爛咗一塊
		for sx in [bx0 - 3.0, bx1 - 3.0]: Art.rr(ctx, sx, by - 26, 6, 52, 1.5, "#4a3424", "#1a100a", 1)

static func _wall(ctx: Ctx, a: Vector2, b: Vector2, col: String) -> void:
	var horiz = absf(a.y - b.y) < 0.5
	var x0 = minf(a.x, b.x) - WALL_W / 2; var y0 = minf(a.y, b.y) - WALL_W / 2
	var w = absf(b.x - a.x) + WALL_W; var h = absf(b.y - a.y) + WALL_W
	Art.rr(ctx, x0 + 2, y0 + 3, w, h, 3, "rgba(0,0,0,.35)")   # 影
	Art.rr(ctx, x0, y0, w, h, 3, col, "#120a0c", 1.2)
	ctx.strokeStyle = "rgba(255,225,190,.13)"; ctx.lineWidth = 1.2   # 頂光
	ctx.beginPath()
	if horiz: ctx.moveTo(x0 + 2, y0 + 2.5); ctx.lineTo(x0 + w - 2, y0 + 2.5)
	else: ctx.moveTo(x0 + 2.5, y0 + 2); ctx.lineTo(x0 + 2.5, y0 + h - 2)
	ctx.stroke()
	ctx.strokeStyle = "rgba(10,4,6,.55)"; ctx.lineWidth = 1.0   # 磚縫
	var L = w if horiz else h; var k = 0.0
	while k < L - 4:
		ctx.beginPath()
		if horiz: ctx.moveTo(x0 + k, y0 + 1); ctx.lineTo(x0 + k, y0 + h - 1)
		else: ctx.moveTo(x0 + 1, y0 + k); ctx.lineTo(x0 + w - 1, y0 + k)
		ctx.stroke(); k += 22.0
static func _post(ctx: Ctx, x: float, y: float, h: float) -> void:
	Art.rr(ctx, x - 4, y - h, 8, h + 4, 1.5, "#4a3424", "#1a100a", 1.1)
	Art.poly(ctx, [x - 4, y - h, x + 4, y - h, x, y - h - 5], "#4a3424", "#1a100a", 1)
static func _door(ctx: Ctx, r: Rect2, open: bool) -> void:   # 門洞：兩條木柱；未佔領 = 打橫木閘
	if r.size.x < r.size.y:   # 左右門（直牆）
		_post(ctx, r.get_center().x, r.position.y + 2, 28); _post(ctx, r.get_center().x, r.end.y + 4, 28)
		if not open:
			for k in 3: Art.rr(ctx, r.position.x - 2, r.position.y + 10 + k * 18, r.size.x + 4, 6, 1, "#3a2818", "#120a06", 1)
	else:
		_post(ctx, r.position.x - 2, r.end.y, 30); _post(ctx, r.end.x + 2, r.end.y, 30)
		if not open:
			for k in 2: Art.rr(ctx, r.position.x, r.position.y + 4 + k * 10, r.size.x, 6, 1, "#3a2818", "#120a06", 1)
static func _gate(ctx: Ctx, gx: float, y: float, gw: float, _t: float) -> void:   # 野外門：兩條黑柱＋破布
	for sx in [-1.0, 1.0]:
		var x = gx + sx * (gw / 2.0 + 2.0)
		Art.rr(ctx, x - 5, y - 30, 10, 62, 1.5, "#2a1416", "#0e0406", 1.2)
		Art.rr(ctx, x - 7, y - 34, 14, 6, 1.5, "#3a1c1e", "#0e0406", 1)
	ctx.strokeStyle = "rgba(120,30,30,.55)"; ctx.lineWidth = 2
	ctx.beginPath(); ctx.moveTo(gx - gw / 2, y - 28); ctx.quadraticCurveTo(gx, y - 16, gx + gw / 2, y - 28); ctx.stroke()

static func _wild_decor(ctx: Ctx, z: Dictionary, t: float) -> void:
	if z.get("pit") is Array:   # 餓鬼坑口
		var p = z.pit
		var g = ctx.createRadialGradient(float(p[0]), float(p[1]), 4, float(p[0]), float(p[1]), float(p[2]) * 1.4)
		g.addColorStop(0, "rgba(0,0,0,1)"); g.addColorStop(0.7, "rgba(16,2,4,.95)"); g.addColorStop(1, "rgba(40,6,8,0)")
		ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(float(p[0]), float(p[1]), float(p[2]) * 1.4, float(p[3]) * 1.4, 0, 0, TAU); ctx.fill()
		Art.el(ctx, float(p[0]), float(p[1]), float(p[2]), float(p[3]), "#050002", "rgba(110,30,30,.8)", 3)
		for k in 5:   # 坑邊伸出嚟嘅手
			var a = PI * 1.05 + k * 0.2; var hx = float(p[0]) + cos(a) * float(p[2]) * 0.92; var hy = float(p[1]) + sin(a) * float(p[3]) * 0.92
			var sw = sin(t * 2.0 + k) * 3.0
			ctx.strokeStyle = "rgba(120,100,96,.75)"; ctx.lineWidth = 2.2
			ctx.beginPath(); ctx.moveTo(hx, hy + 6); ctx.lineTo(hx + sw, hy - 8); ctx.stroke()
	for d in z.get("decor", []):
		var k = str(d[0]); var x = float(d[1]); var y = float(d[2])
		if k == "grave": Art.draw_decor(ctx, "grave", x, y, t)
		elif Spr.ok(k):
			ctx.save(); ctx.globalAlpha = 0.85; Art.put(ctx, k, x, y, float(d[3]) if d.size() > 3 and float(d[3]) > 0 else 70.0); ctx.restore()

# ---------------- 上層：黑霧、鎖、區名牌、王 ----------------
static var hits: Array = []      # [[Rect2, kind, zid]]（世界座標，畫嗰陣記低）
static func draw_over(c: CanvasItem, nv) -> void:
	hits.clear()
	if not ZD.on(): return
	var ctx = Ctx.new(c)
	var t: float = nv.t
	var vr: Rect2 = nv.view_rect().grow(40)
	PtGfx.init()
	for z in ZD.zones():
		var r = ZD.rect(z.rect)
		var tp = str(z.type)
		if tp == "res" and not ZD.owned(str(z.id)):
			hits.append([r, "res", str(z.id)])
			if r.intersects(vr): _fog(c, ctx, nv, z, r, t)
			continue
		if tp == "wild":
			hits.append([r, "wild", str(z.id)])
			if r.intersects(vr): _wild_over(ctx, nv, z, r, t)
			continue
		if r.intersects(vr):
			var px = _fs(nv, 17)
			var lb = ZD.T(z.n) + (ZD.L("（起點）", "（起點）") if tp == "village" else "")
			_plate(ctx, lb, r.get_center().x, r.position.y + px * 1.3, px, _rgba(str(z.get("col", "#a8602a")), 0.92))
static func _rgba(hex: String, a: float) -> String:
	var c = Color(hex)
	return "rgba(%d,%d,%d,%.2f)" % [int(c.r * 255), int(c.g * 255), int(c.b * 255), a]

static func _fog(c: CanvasItem, ctx: Ctx, nv, z: Dictionary, r: Rect2, t: float) -> void:
	for k in 6:   # [zone v4] 柔邊：由外向內一層層加深（唔見硬邊）
		var g = 30.0 - k * 8.0
		c.draw_rect(r.grow(g), Color(0.024, 0.012, 0.04, 0.16 + (0.46 if k == 5 else 0.0)))
	var n = int(clampf(r.get_area() / 9000.0, 8, 30))
	for i in n:   # 飄緊嘅霧團
		var fx = r.position.x + fmod(i * 97.0 + t * (6.0 + (i % 3) * 3.0), r.size.x + 120.0) - 60.0
		var fy = r.position.y + fmod(i * 173.0, r.size.y)
		var rr = 70.0 + (i % 4) * 24.0
		c.draw_texture_rect(PtGfx.RAD, Rect2(fx - rr, fy - rr * 0.6, rr * 2, rr * 1.2), false, Color(0.55, 0.52, 0.62, 0.10))
	var cx = r.get_center().x; var cy = r.get_center().y
	var px = _fs(nv, 16)
	_plate(ctx, ZD.T(z.n), cx, r.position.y + px * 1.4, px, _rgba(str(z.get("col", "#3a3036")), 0.92))
	var lk = maxf(22.0, px * 1.6)
	_lock(ctx, cx, cy - lk * 1.4, lk)
	var need = ZD.need(str(z.id)); var pw = ZD.power()
	_txt(ctx, ZD.L("建議戰力 %d", "建議戰力 %d") % need, cx, cy + px * 0.4, px + 2, "#ffd27a")
	_txt(ctx, ZD.L("你嘅陰兵戰力 %d", "你的陰兵戰力 %d") % pw, cx, cy + px * 2.0, px, "#9fe39a" if pw >= need else "#ff9a7a")
	var a = 0.75 + 0.25 * sin(t * 3.0)
	ctx.globalAlpha = a
	_plate(ctx, ZD.L("撳我攻佔", "點我攻佔"), cx, cy + px * 3.8, px, "rgba(150,40,30,.95)")
	ctx.globalAlpha = 1.0
static func _lock(ctx: Ctx, x: float, y: float, s: float) -> void:
	ctx.strokeStyle = "#b8a070"; ctx.lineWidth = s * 0.16
	ctx.beginPath(); ctx.arc(x, y - s * 0.15, s * 0.34, PI, TAU); ctx.lineTo(x + s * 0.34, y + s * 0.1); ctx.moveTo(x - s * 0.34, y - s * 0.15); ctx.lineTo(x - s * 0.34, y + s * 0.1); ctx.stroke()
	Art.rr(ctx, x - s * 0.5, y, s, s * 0.72, s * 0.1, "#8a6a34", "#2a1a0a", maxf(1.5, s * 0.06))
	Art.el(ctx, x, y + s * 0.3, s * 0.09, s * 0.12, "#1a1008")

static func _wild_over(ctx: Ctx, nv, z: Dictionary, r: Rect2, t: float) -> void:
	var zid = str(z.id)
	var px = _fs(nv, 16)
	_plate(ctx, ZD.T(z.n), r.get_center().x, r.position.y + px * 1.3, px, _rgba(str(z.get("col", "#8a1c24")), 0.92))
	var bs = ZD.bosses(zid); var parts = []
	for i in bs.size():
		parts.append(("①②③④⑤")[i] + ZD.T(bs[i].n) + ("✓" if ZD.boss_done(zid, i) else ""))
	var py = _fs(nv, 14)
	_plate(ctx, ZD.L("王：", "王：") + "　".join(parts), r.get_center().x, r.position.y + px * 1.3 + py * 2.0, py, "rgba(20,10,14,.85)", "#ffe8c4")
	var bi = ZD.boss_next(zid)
	var at = ZD.v2(z.get("boss_at", [r.get_center().x, r.get_center().y]))
	if bi < 0:
		_plate(ctx, ZD.L("已解放", "已解放"), at.x, at.y - 20, px, "rgba(40,90,50,.92)")
		return
	var b = bs[bi]
	var k = str(b.get("art", "youhun"))
	var bob = sin(t * 2.0) * 3.0
	var g = ctx.createRadialGradient(at.x, at.y - 40, 6, at.x, at.y - 40, 70)
	g.addColorStop(0, "rgba(200,30,30,.38)"); g.addColorStop(1, "rgba(200,30,30,0)")
	ctx.fillStyle = g; ctx.fillRect(at.x - 70, at.y - 110, 140, 140)
	Art.draw_char(ctx, k, at.x, at.y + bob, 1.05 if J.t(b.get("main")) else 0.9, {"t": t, "flip": false})
	var lbl = ("①②③④⑤")[bi] + ZD.T(b.n) + (ZD.L("（主 Boss）", "（主 Boss）") if J.t(b.get("main")) else "")
	_txt(ctx, lbl, at.x, at.y + px * 1.0, px, "#ffb0a0")
	ctx.globalAlpha = 0.75 + 0.25 * sin(t * 3.0)
	_plate(ctx, ZD.L("撳我挑戰", "點我挑戰"), at.x, at.y + px * 2.6, px, "rgba(150,40,30,.95)")
	ctx.globalAlpha = 1.0

# ---------------- 點擊（世界座標）：回 true＝處理咗 ----------------
static func tap(main, p: Vector2) -> bool:
	if not ZD.on(): return false
	var zid = ZD.door_at(p)
	if zid != "" and not ZD.owned(zid): open_capture(main, zid); return true
	for h in hits:
		if not h[0].has_point(p): continue
		if h[1] == "res": open_capture(main, h[2]); return true
		if h[1] == "wild":
			var z = ZD.zone(h[2])
			var at = ZD.v2(z.get("boss_at", [0, 0]))
			var near_boss = Rect2(at.x - 70, at.y - 130, 140, 200).has_point(p)
			var on_label = p.y < ZD.rect(z.rect).position.y + 110
			if near_boss or on_label: open_boss(main, h[2]); return true
			return false   # 其他位：交俾大排檔（孤魂撳得）
	return false

static func _busy() -> bool:
	var st = J.G.get("Story"); var ui = J.G.get("UI")
	return (st != null and J.t(J.mc(st, "busy", []))) or (ui != null and J.t(J.mc(ui, "modalOpen", [])))

# ---------------- 彈出卡（main.gd 嘅 sheet） ----------------
static func open_capture(main, zid: String) -> void:
	if main == null or _busy(): return
	var z = ZD.zone(zid)
	main.open_sheet(ZD.T(z.n), func(): pass)
	var body = main.sheet_body
	var need = ZD.need(zid); var pw = ZD.power()
	var R = func(bb: String, sz := 16): var r = UIKit.rich(bb, sz, UIKit.INKTXT); body.add_child(r); return r
	R.call("[b]%s[/b]　[color=#a8322a]%d[/color]" % [ZD.L("建議戰力", "建議戰力"), need], 18)
	R.call("[b]%s[/b]　[color=%s]%d[/color]" % [ZD.L("你嘅陰兵戰力", "你的陰兵戰力"), "#3d7a3a" if pw >= need else "#a8322a", pw], 18)
	R.call(ZD.L("陰兵戰力 ＝ 陰兵數 × 民宅加成（民宅每升一級 +8%）。陰兵由民宅嘅遊魂自願當，會慢慢多。", "陰兵戰力 ＝ 陰兵數 × 民宅加成（民宅每升一級 +8%）。陰兵由民宅的遊魂自願加入，會慢慢增加。"), 14)
	var names = []
	for b in ZD._zbids(z): names.append(_bname(b))
	R.call(ZD.L("佔領之後：%s", "佔領之後：%s") % "、".join(names), 15)
	for b in (z.get("shops", {}) as Dictionary):
		var nd = z.shops[b].get("need", {})
		for f in nd: R.call(ZD.L("（%s 要「%s」升到 Lv%d 先起得，只可以起喺呢區）", "（%s 要「%s」升到 Lv%d 才能建，只能建在這區）") % [_bname(b), _bname(str(f)), int(nd[f])], 14)
	body.add_child(UIKit.hsep())
	var b1 = UIKit.btn(ZD.L("派陰兵攻佔（折損 %d 陰兵）", "派陰兵攻佔（折損 %d 陰兵）") % ZD.loss(zid), "gold")
	b1.disabled = pw < need
	b1.pressed.connect(func():
		if ZD.capture_auto(zid) == "ok":
			main.close_sheet(); Snd.play("build")
			main.show_banner(ZD.L("%s 攻佔咗！", "%s 攻佔了！") % ZD.T(z.n)); main.refresh())
	body.add_child(b1)
	if pw < need: R.call("[color=#a8322a]%s[/color]" % ZD.L("戰力未夠：可以靠技巧親自出征強攻", "戰力不夠：可以靠技巧親自出征強攻"), 14)
	var b2 = UIKit.btn(ZD.L("親自出征（用出陣隊伍打一場）", "親自出征（用出陣隊伍打一場）"), "")
	b2.pressed.connect(func():
		var r = ZD.start_battle("cap", zid)
		if r == "noteam": main.show_toast(ZD.L("至少要派一位鬼怪出陣（去「鬼怪」頁揀隊）", "至少要派一位鬼怪出陣（去「鬼怪」頁選隊）"))
		elif r == "ok": main.close_sheet())
	body.add_child(b2)

static func open_boss(main, zid: String) -> void:
	if main == null or _busy(): return
	var z = ZD.zone(zid)
	main.open_sheet(ZD.T(z.n), func(): pass)
	var body = main.sheet_body
	var R = func(bb: String, sz := 16): var r = UIKit.rich(bb, sz, UIKit.INKTXT); body.add_child(r); return r
	var bs = ZD.bosses(zid); var bi = ZD.boss_next(zid)
	R.call(ZD.L("呢度嘅孤魂野鬼會衝落嚟大排檔搞事。王要按次序打：", "這裡的孤魂野鬼會衝下來大排檔搗亂。王要按順序打："), 15)
	for i in bs.size():
		var st = ZD.L("已打低", "已擊敗") if ZD.boss_done(zid, i) else (ZD.L("而家挑戰", "可挑戰") if i == bi else ZD.L("未開", "未開放"))
		R.call("%s [b]%s[/b]%s　—　%s" % [("①②③④⑤")[i], ZD.T(bs[i].n), (ZD.L("（主 Boss）", "（主 Boss）") if J.t(bs[i].get("main")) else ""), st], 16)
	var bc = ZD.boss_count()
	R.call(ZD.L("全部王打低先可以拔營去下一張圖（%d/%d）", "全部王擊敗才能拔營去下一張地圖（%d/%d）") % [bc[0], bc[1]], 14)
	body.add_child(UIKit.hsep())
	if bi < 0:
		R.call("[color=#3d7a3a][b]%s[/b][/color]" % ZD.L("呢區已解放", "這區已解放"), 16); return
	var b2 = UIKit.btn(ZD.L("挑戰 %s", "挑戰 %s") % ZD.T(bs[bi].n), "gold")
	b2.pressed.connect(func():
		var r = ZD.start_battle("boss", zid)
		if r == "noteam": main.show_toast(ZD.L("至少要派一位鬼怪出陣（去「鬼怪」頁揀隊）", "至少要派一位鬼怪出陣（去「鬼怪」頁選隊）"))
		elif r == "ok": main.close_sheet())
	body.add_child(b2)
static func _bname(b: String) -> String:
	var M = load("res://game/outpost/mat.gd")
	var d = M.bld(b)
	return ZD.T(d.get("n", [b, b])) if d is Dictionary and not d.is_empty() else b

# 戰鬥結果（main 每格叫）：出橫額
static func eat_news(main) -> void:
	while ZD.NEWS.size():
		var r = ZD.NEWS.pop_front()
		if main == null: continue
		if r.win:
			if r.kind == "cap": main.show_banner(ZD.L("%s 攻佔咗！", "%s 攻佔了！") % ZD.T(ZD.zone(r.id, r.ci).get("n", ["", ""])))
			else: main.show_banner(ZD.L("打低 %s！", "擊敗 %s！") % str(r.get("boss", "")))
		else: main.show_toast(ZD.L("今次打唔贏……整強啲隊伍再嚟", "這次打不贏……強化隊伍再來"))
