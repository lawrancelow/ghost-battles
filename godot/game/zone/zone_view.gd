# [zone] 分區地圖畫面：區牆＋門洞、區名牌、未佔領資源區（黑霧＋鎖＋建議戰力）、野外區（擺設、王、進度）、點擊、彈出卡
# 全部 static（冇 class_name、冇 autoload）；const ZV = preload("res://game/zone/zone_view.gd")
# 畫：nv_village 嘅兩層 PtDraw（under：地面之上、建築之下；over：建築之上），ctx 係世界座標。
# 字：區名牌／戰力字按縮放放大（縮到最細睇成張圖時畫面上都唔細過 14px）。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const WALL_W := 10.0
const WALL_COL := {"wild": "#4a1c20", "market": "#4a3422", "village": "#4a3422", "res": "#2e2a30"}

# 世界標籤跟地圖一齊縮：細節字（戰力、點我、王名）固定世界大細，縮到畫面細過 14px 就淡出收埋；
#   只有區名牌一直留（畫面上最少 14px，縮到好細改用短名）
static func _rel(nv) -> float: return float(nv.sc) / maxf(0.01, float(nv.size.x) / 390.0)
static func _fs(nv, base: float) -> int: return int(base)
static func _det(nv) -> float: return clampf((_rel(nv) - 0.82) / 0.1, 0.0, 1.0)   # 16 世界 px × 0.875 ≈ 14 畫面 px
static func _name_px(nv) -> int: return int(ceil(maxf(17.0, 14.5 / maxf(0.05, _rel(nv)))))
static func _name(nv, z: Dictionary) -> String:
	var n = ZD.T(z.get("n", ["", ""]))
	if _rel(nv) < 0.6 and n.contains("　"): n = n.split("　")[-1]
	return n
static func _txt(ctx: Ctx, s: String, x: float, y: float, px: int, col := "#f6e2b0", outline := "rgba(20,8,8,.95)") -> void:
	ctx.font = "900 %dpx %s" % [px, Art.SERIF]; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineWidth = maxf(3.0, px * 0.22); ctx.strokeStyle = outline; ctx.lineJoin = "round"; ctx.strokeText(s, x, y)
	ctx.fillStyle = col; ctx.fillText(s, x, y)
static var plates: Array = []   # 今格畫咗嘅牌（測試：每區名牌只畫一個）
static func _plate(ctx: Ctx, s: String, x: float, y: float, px: int, bg: String, fg := "#fff4e2") -> Rect2:
	plates.append(s)
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
	if _geo_ci != ZD.ci(): _geo.clear(); _geo_ci = ZD.ci()   # [zone2] 換圖：程序地形快取重做
	var bs = ZD.cur().get("barriers", [])
	for kind in ["void", "river", "vriver", "cliff", "ridge", "ditch", "jetties", "steps", "belt", "fence", "vfence", "rail", "stakes", "forest", "stonewall"]:
		for b in bs:
			if str(b.k) == kind: _barrier(c, ctx, b, vr, t)
	_scenery(c, vr)   # [zone2] 區外佈景（高腳屋殘骸、崖石枯松、紅樹林…）
	for z in ZD.zones():
		if str(z.type) == "wild" and ZD.rect(z.rect).intersects(vr): _wild_decor(ctx, z, t)
	_props(c, ctx, vr, t)
	for z in ZD.of_type("res"):   # 未佔領：門洞／小徑／橋頭打橫幾條木閘
		if z.get("door") is Dictionary and not ZD.owned(str(z.id)):
			var dr = ZD.rect(z.door.get("vis", z.door.rect))
			if dr.intersects(vr): _door(ctx, dr, false)

static var _geo := {}   # 程序地形快取（固定種子）
static var _geo_ci := -1
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
				if absf(p.y - river_y(b, p.x)) < float(b.get("w", 24)) / 2.0 + 4.0 and p.x >= float(b.x0) - 4 and p.x <= float(b.x1) + 4 and not _in_br(b, p.x): return true
			"stakes":
				if p.y > float(b.y) - 34 and p.y < float(b.y) + 3 and p.x >= float(b.x0) and p.x <= float(b.x1):
					var ing = false
					for g in b.gaps: if p.x >= float(g[0]) and p.x <= float(g[1]): ing = true
					if not ing: return true
			"void":   # [zone2] 四周天然邊界（熱帶黑樹林／峭壁／紅樹林泥灘）
				for r in b.rects: if ZD.rect(r).has_point(p): return true
			"vriver":
				if absf(p.x - vriver_x(b, p.y)) < float(b.get("w", 24)) / 2.0 + 4.0 and p.y >= float(b.y0) - 30 and p.y <= float(b.y1) + 30 and not _in_br(b, p.y): return true
			"ditch", "vfence", "rail":
				var hw = float(b.get("w", 16)) / 2.0 + 4.0
				if absf(p.x - float(b.x)) < hw and p.y >= float(b.y0) and p.y <= float(b.y1) and not (p.y >= float(b.gap[0]) and p.y <= float(b.gap[1])): return true
			"belt", "fence":
				var up = 34.0 if str(b.k) == "belt" else 26.0
				if p.y > float(b.y) - up and p.y < float(b.y) + 6 and p.x >= float(b.x0) and p.x <= float(b.x1) and not (p.x >= float(b.gap[0]) and p.x <= float(b.gap[1])): return true
	return false
# 橋（[x0, x1] 或 [x0, x1, 圖鍵]；舊格式 bridge＝[x0, x1]）
static func _brs(b: Dictionary) -> Array:
	if b.get("bridges") is Array: return b.bridges
	if b.get("bridge") is Array: return [b.bridge]
	return []
static func _in_br(b: Dictionary, v: float) -> bool:
	for br in _brs(b): if v >= float(br[0]) and v <= float(br[1]): return true
	return false
static func _barrier(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	match str(b.k):
		"void": _void(c, b, vr, t)
		"vriver": _vriver(c, ctx, b, vr, t)
		"ditch": _ditch(c, ctx, b, vr, t)
		"belt", "fence": _hrow(c, ctx, b, vr)
		"vfence", "rail": _vrow(c, ctx, b, vr)
		"steps":
			for q in b.pts:
				if vr.grow(80).has_point(Vector2(float(q[0]), float(q[1]))): _sp(c, "zt_steps", float(q[0]), float(q[1]) + 8, float(q[2]), bool(q[3]), _gtint())
		"jetties":
			for q in b.pts:
				if vr.grow(100).has_point(Vector2(float(q[0]), float(q[1]))): _sp(c, "zt_jetty", float(q[0]), float(q[1]), float(q[2]), int(q[0]) % 2 == 1, _gtint())
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
			var fg = _fogc()
			c.draw_texture_rect(PtGfx.RAD, Rect2(fx - 130, fy - 80, 260, 160), false, Color(fg.r, fg.g, fg.b, 0.26))
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

# 青苔舊石牆（透視：zb_wall 縮細、一段段斜向錯開疊落去，有崩口長草＋碎石）＋拱門（zb_arch，前後接住兩段牆）
static func _stonewall(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2) -> void:
	var x0 = float(b.x0); var x1 = float(b.x1); var cx = (x0 + x1) / 2.0
	if x1 < vr.position.x - 60 or x0 > vr.end.x + 60: return
	var gy0 = float(b.gap[0]); var gy1 = float(b.gap[1])
	if not _geo.has("wall"):
		var rng = RandomNumberGenerator.new(); rng.seed = 7171
		var it = []
		var y = float(b.y0) + 34.0; var i = 0
		while y <= float(b.y1) + 6:
			if not (y > gy0 - 10 and y < gy1 + 36):
				var brk = rng.randf() < 0.16   # 崩口：碎石＋草
				var dx = (6.0 if i % 2 == 0 else -6.0) + rng.randf_range(-3, 3)   # 一段段錯開（透視：牆身打斜望）
				if brk: it.append(["zb_rock2", cx + dx, y + 4, rng.randf_range(58, 70), rng.randf() < 0.5, 0.78])
				else: it.append(["zb_wall", cx + dx, y, rng.randf_range(64, 74), rng.randf() < 0.5, rng.randf_range(0.76, 0.9)])
				if rng.randf() < 0.35: it.append(["zb_bush", cx + dx + rng.randf_range(-22, 22), y + 6, rng.randf_range(34, 46), rng.randf() < 0.5, 0.68])
			y += rng.randf_range(28, 34); i += 1
		_geo["wall"] = it
	if Spr.ok("zb_wall_v"):   # 南北走向石牆圖：上下拼接（接位用碎石／雜草蓋），拱門喺門洞
		var tx = Spr.get_tex("zb_wall_v"); var ww = 64.0; var hh = ww * tx.get_height() / tx.get_width(); var stp = hh * 0.82
		for seg in [[float(b.y0), gy0 + 4.0], [gy1 + 30.0, float(b.y1) + 8.0]]:
			var yb = float(seg[0]) + stp
			var k2 = 0
			while yb <= float(seg[1]) + stp * 0.5:
				var ybb = minf(yb, float(seg[1]))
				if ybb - hh < vr.end.y and ybb > vr.position.y - 20:
					_sp(c, "zb_wall_v", cx + (3.0 if k2 % 2 == 0 else -3.0), ybb, ww, k2 % 2 == 1, Color(0.86, 0.83, 0.83))
					if Spr.ok("zb_rock2") and ybb < float(seg[1]) - 4: _sp(c, "zb_rock2", cx + 4, ybb + 6, 54.0, k2 % 2 == 0, Color(0.8, 0.78, 0.8))
				yb += stp; k2 += 1
		if Spr.ok("zb_arch"): _sp(c, "zb_arch", cx, gy1 + 26, 104.0, false, Color(0.86, 0.83, 0.83))
		return
	if Spr.ok("zb_wall"):
		for e in _geo["wall"]:
			if float(e[2]) < vr.position.y - 10 or float(e[2]) - 50 > vr.end.y: continue
			var g = float(e[5])
			_sp(c, e[0], float(e[1]), float(e[2]), float(e[3]), e[4], Color(g, g * 0.97, g * 0.97))
		if Spr.ok("zb_arch"): _sp(c, "zb_arch", cx, gy1 + 26, 104.0, false, Color(0.86, 0.83, 0.83))
		return
	var y2 = float(b.y0)
	while y2 < float(b.y1):
		if not (y2 + 16 > gy0 and y2 < gy1) and y2 > vr.position.y - 20 and y2 < vr.end.y + 20:
			var g2 = 0.30 + fmod(absf(y2 * 7.0), 9.0) / 100.0
			c.draw_rect(Rect2(x0, y2, x1 - x0, 15), Color(g2, g2 - 0.03, g2 - 0.05)); c.draw_rect(Rect2(x0, y2, x1 - x0, 15), Color(0.1, 0.08, 0.08), false, 1.0)
		y2 += 16.0
	ctx.strokeStyle = "#6a625e"; ctx.lineWidth = 7
	ctx.beginPath(); ctx.ellipse(cx, gy0 + 2, (x1 - x0) * 0.5 + 6, 18, 0, PI, TAU); ctx.stroke()

# 村子自然填充：雜草叢、碎石、黑灌木、樹、木桶、晾衫竹、籮、木頭車（zones.json village.props）
static func _all_props() -> Array:   # 村子院落＋資源區自然填充（[zone2]）
	var o = ZD.cur().get("village", {}).get("props", []).duplicate()
	for z in ZD.of_type("res"): o.append_array(z.get("props", []))
	return o
static func _props(c: CanvasItem, ctx: Ctx, vr: Rect2, t: float) -> void:
	for e in _all_props():
		var k = str(e[0]); var x = float(e[1]); var y = float(e[2]); var w = float(e[3])
		if not vr.grow(60).has_point(Vector2(x, y)): continue
		if k.begins_with("proc:"):
			match k.substr(5):
				"grass":
					for j in 9:
						var gx = x + (j - 4) * 4.0 + sin(j * 2.3) * 3.0; var h = 10.0 + fmod(j * 3.7, 9.0)
						ctx.strokeStyle = ["#2c3628", "#3a4630", "#46523a"][j % 3]; ctx.lineWidth = 1.6
						ctx.beginPath(); ctx.moveTo(gx, y); ctx.quadraticCurveTo(gx + 2 + sin(t + j) * 1.2, y - h * 0.6, gx + 4 + sin(t * 1.3 + j) * 2.0, y - h); ctx.stroke()
				"barrel":
					Art.el(ctx, x, y, 12, 4, "rgba(8,2,8,.35)")
					Art.rr(ctx, x - 10, y - 24, 20, 24, 4, "#5a3e28", "#1e140c", 1.3)
					for yy in [y - 19, y - 7]: Art.rr(ctx, x - 11, yy, 22, 3, 1, "#2e2a28")
					Art.el(ctx, x, y - 24, 10, 3, "#3e2a1a", "#1e140c", 1)
				"laundry":   # 晾衫竹：兩條竹＋一條橫竹，掛住幾件舊衫（陰間風，灰白）
					for sx in [-28.0, 28.0]: Art.rr(ctx, x + sx - 2, y - 46, 4, 46, 1, "#8a8a5a", "#2a2a1a", 1)
					ctx.strokeStyle = "#a0a070"; ctx.lineWidth = 2.5; ctx.beginPath(); ctx.moveTo(x - 32, y - 44); ctx.lineTo(x + 32, y - 44); ctx.stroke()
					var cols = ["#b8b0a0", "#8a6a6a", "#c8c0b0"]
					for j in 3:
						var cx2 = x - 18 + j * 18; var sw = sin(t * 1.5 + j) * 2.0
						Art.poly(ctx, [cx2 - 7, y - 43, cx2 + 7, y - 43, cx2 + 8 + sw, y - 26, cx2 - 6 + sw, y - 26], cols[j], "#3a3430", 1)
				"fence":   # 矮竹籬：一排斜斜嘅竹枝＋兩條橫竹
					var n = int(w / 7.0)
					for j in n:
						var fx = x - w / 2.0 + j * 7.0; var hh = 16.0 + fmod(j * 3.1, 5.0)
						Art.rr(ctx, fx - 1.5, y - hh, 3, hh, 1, "#8a8a52", "#2a2a16", 0.8)
					for yy in [y - 12.0, y - 6.0]: Art.rr(ctx, x - w / 2.0 - 2, yy, w + 2, 2.5, 1, "#a0a060")
				"woodpile":   # 柴堆
					for j in 3:
						for i2 in 4 - j:
							var lx = x - 16 + i2 * 10 + j * 5; var ly = y - 5 - j * 8
							Art.el(ctx, lx, ly, 5, 4.5, "#6a4a2a", "#2a1a0e", 1); Art.el(ctx, lx, ly, 2, 1.8, "#a88a5a")
				"jar":   # 水缸
					Art.el(ctx, x, y, 12, 4, "rgba(8,2,8,.35)")
					Art.poly(ctx, [x - 9, y - 22, x + 9, y - 22, x + 12, y - 10, x + 8, y, x - 8, y, x - 12, y - 10], "#4a4a52", "#16161c", 1.2)
					Art.el(ctx, x, y - 22, 9, 3, "#1a2a34", "#16161c", 1)
				"coop":   # 雞籠（冇活物）：竹籠＋幾條羽毛
					Art.el(ctx, x, y, 20, 5, "rgba(8,2,8,.3)")
					Art.poly(ctx, [x - 18, y, x + 18, y, x + 14, y - 22, x - 14, y - 22], "rgba(120,100,60,.85)", "#2a1e10", 1.2)
					for j in 6: Art.rr(ctx, x - 15 + j * 6, y - 21, 1.2, 20, 0.5, "#3a2a16")
					Art.el(ctx, x + 22, y - 2, 2.5, 1, "#d8d0c0")
				"veg":   # 小菜圃：幾行泥畦＋暗綠菜
					Art.rr(ctx, x - w / 2.0, y - 22, w, 22, 2, "rgba(54,38,26,.9)", "#1e140c", 1)
					for r in 3:
						for j in int(w / 10.0):
							Art.el(ctx, x - w / 2.0 + 6 + j * 10, y - 17 + r * 7, 3.5, 2.5, ["#3c5a30", "#4a6a38", "#34502a"][(j + r) % 3])
				"mill":   # 石磨
					Art.el(ctx, x, y - 4, 16, 6, "#5a565a", "#1a181a", 1.2)
					Art.rr(ctx, x - 13, y - 14, 26, 9, 3, "#6a666a", "#1a181a", 1.2)
					Art.el(ctx, x, y - 14, 12, 4, "#7a767a", "#1a181a", 1)
					Art.rr(ctx, x + 8, y - 24, 3, 11, 1, "#5a3e28")
				"pebbles":
					for j in 6: Art.el(ctx, x - 12 + fmod(j * 7.3, 24.0), y - fmod(j * 3.7, 8.0), 2.5 + fmod(j, 2.0), 1.8, ["#4a4448", "#5a5458", "#3a3438"][j % 3], "#161216", 0.6)
				"flowers":   # 野花（暗紅、灰白）
					for j in 7:
						var fx2 = x - 12 + fmod(j * 5.3, 24.0); var fy2 = y - fmod(j * 4.1, 10.0)
						ctx.strokeStyle = "#2c3628"; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(fx2, fy2 + 6); ctx.lineTo(fx2, fy2); ctx.stroke()
						Art.el(ctx, fx2, fy2, 2, 2, ["#8a2a2a", "#c8c0b0", "#6a2a4a"][j % 3])
		elif k.begins_with("deco:"):
			match k.substr(5):
				"tree": _sp(c, "tree", x, y, w, int(x) % 2 == 1, Color(0.5, 0.46, 0.5))
				"banana":
					if Spr.ok("banana"): _sp(c, "banana", x, y + 4, w, int(x) % 2 == 1, Color(0.66, 0.7, 0.62))
				"paddy":
					if Spr.ok("paddy"): _sp(c, "paddy", x, y + 4, w, int(y) % 2 == 1, Color(0.6, 0.56, 0.48))
				"scarecrow":
					if Spr.ok("scarecrow"): _sp(c, "scarecrow", x, y + 4, w, false, Color(0.62, 0.55, 0.55))
				"post":
					if Spr.ok("lamppost"):
						_sp(c, "lamppost", x, y + 3, 35.0, false, Color(0.7, 0.62, 0.6))
						PtGfx.init(); c.draw_texture_rect(PtGfx.RAD, Rect2(x + 6 - 20, y - 30 - 20, 40, 40), false, Color(_lamp().r, _lamp().g, _lamp().b, 0.24 + sin(t * 2 + x) * 0.06))
		elif Spr.ok(k):
			var tint = Color(0.62, 0.58, 0.6) if k == "tree" else (Color(0.86, 0.83, 0.83) if k.begins_with("zp_") or k.begins_with("zq_") else Color(0.78, 0.76, 0.78))
			_sp(c, k, x, y, w, int(x) % 2 == 1, tint)

# 暗色小河（兩端入山岩）＋破木橋
static func river_y(b: Dictionary, x: float) -> float: return float(b.y) + float(b.get("amp", 7)) * sin(x / 70.0)
static func _river(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	var y0 = float(b.y)
	if y0 < vr.position.y - 60 or y0 > vr.end.y + 60: return
	var W2 = float(b.get("w", 30))
	var pts = PackedVector2Array()
	var x = maxf(float(b.x0), vr.position.x - 20)
	while x <= minf(float(b.x1), vr.end.x + 20): pts.append(Vector2(x, river_y(b, x))); x += 12.0
	if pts.size() < 2: return
	var wc = _water()
	c.draw_polyline(pts, Color(0.10, 0.12, 0.08, 0.55), W2 + 14.0, true)   # 岸邊濕泥（柔）
	c.draw_polyline(pts, Color("#141c18"), W2 + 6.0, true)
	c.draw_polyline(pts, wc[0], W2, true)
	c.draw_polyline(pts, wc[1], W2 * 0.55, true)
	for i in pts.size() - 1:   # 水光：慢慢流
		var ph = fmod(pts[i].x * 0.05 + t * 1.6, 6.0)
		if ph < 1.2: c.draw_line(pts[i] + Vector2(0, -3), pts[i + 1] + Vector2(0, -3), Color(0.45, 0.62, 0.68, 0.5 * (1.2 - ph)), 1.6)
	# 兩端流入山岩：岩石堆蓋住河頭河尾
	for ex in [float(b.x0) + 20.0, float(b.x1) - 20.0]:
		if ex < vr.position.x - 100 or ex > vr.end.x + 100: continue
		if ex < 30.0 or ex > ZD.world_size().x - 30.0: continue   # [zone2] 流出地圖邊：唔使岩石收口
		var ey = river_y(b, ex)
		for j in 4:
			var ox = (j - 1.5) * 26.0 * (1.0 if ex < 670 else -1.0)
			if Spr.ok("zb_rock1"): _sp(c, "zb_rock1" if j % 2 == 0 else "zb_rock2", ex + ox, ey + 18 + (j % 2) * 8, 90.0 - j * 8, j % 2 == 1, Color(0.78, 0.76, 0.8))
			else: _proc_rock(c, Vector2(ex + ox, ey), 24.0)
	for br in _brs(b):
		var bm = (float(br[0]) + float(br[1])) / 2.0
		if bm < vr.position.x - 120 or bm > vr.end.x + 120: continue
		if br.size() > 2 and str(br[2]) != "zb_bridge_v" and Spr.ok(str(br[2])): _bridge_k(c, str(br[2]), float(br[0]), float(br[1]), river_y(b, bm), W2, false)
		else: _bridge(c, ctx, float(br[0]), float(br[1]), river_y(b, bm), W2)
# 破木橋：南北向（對準中路），木板一塊塊打橫，兩邊扶手，爛咗一塊
static func _bridge(c: CanvasItem, ctx: Ctx, bx0: float, bx1: float, by: float, W2: float) -> void:
	if Spr.ok("zb_bridge_v"):   # 南北向破木橋圖（中段畫咗河水）：水面對準條河
		var w0 = (bx1 - bx0) * 1.7; var tx = Spr.get_tex("zb_bridge_v"); var h0 = w0 * tx.get_height() / tx.get_width()
		_sp(c, "zb_bridge_v", (bx0 + bx1) / 2.0, by + h0 * 0.45, w0, false, Color(0.88, 0.85, 0.85))
		return
	var y0 = by - W2 / 2.0 - 14.0; var y1 = by + W2 / 2.0 + 14.0
	Art.el(ctx, (bx0 + bx1) / 2.0, y1 + 2, (bx1 - bx0) * 0.6, 5, "rgba(4,2,6,.4)")
	var yy = y0; var k = 0
	while yy < y1:
		var g = 0.36 + fmod(k * 0.37, 0.1)
		if k != 3: Art.rr(ctx, bx0 + sin(k * 1.7) * 1.5, yy, bx1 - bx0, 7, 1.2, "rgba(%d,%d,%d,1)" % [int(g * 255), int(g * 0.72 * 255), int(g * 0.5 * 255)], "#1e140c", 1)
		yy += 7.5; k += 1
	for sx in [bx0 - 4.0, bx1 - 2.0]:
		Art.rr(ctx, sx, y0 - 8, 6, y1 - y0 + 10, 1.5, "#4a3424", "#1a100a", 1)
		for py in [y0 - 12, y1 - 6]: Art.rr(ctx, sx - 1, py, 8, 12, 1.5, "#5a3e28", "#1a100a", 1)

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
	hits.clear(); plates.clear()
	if not ZD.on(): return
	var ctx = Ctx.new(c)
	var t: float = nv.t
	var vr: Rect2 = nv.view_rect().grow(40)
	PtGfx.init()
	draw_atmo(c, nv)   # [zone2] 天氣／環境粒子
	ZD.watch(nv.view_rect())   # [zone2] 劇情事件：第一次見到某區、二級廠解鎖、解放
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
		if tp == "res" and J.t(z.get("nofac")) and r.intersects(vr) and _det(nv) > 0.0:   # [zone2] 冇二級廠
			ctx.globalAlpha = _det(nv)
			_plate(ctx, ZD.L("二級廠：暫無", "二級廠：暫無"), r.end.x - 110, r.end.y - 44, 15, "rgba(30,24,20,.86)", "#d8ccb4")
			ctx.globalAlpha = 1.0
		if r.intersects(vr):
			var px = _name_px(nv)
			var lb = _name(nv, z) + (ZD.L("（起點）", "（起點）") if tp == "village" and _rel(nv) >= 0.6 else "")
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
		var fg = _fogc().lerp(Color(0.55, 0.52, 0.62), 0.5)
		c.draw_texture_rect(PtGfx.RAD, Rect2(fx - rr, fy - rr * 0.6, rr * 2, rr * 1.2), false, Color(fg.r, fg.g, fg.b, 0.10))
	var cx = r.get_center().x; var cy = r.get_center().y
	var npx = _name_px(nv)
	_plate(ctx, _name(nv, z), cx, r.position.y + npx * 1.4, npx, _rgba(str(z.get("col", "#3a3036")), 0.92))
	var px = 16; var da = _det(nv)
	var lk = maxf(26.0, npx * 1.4)
	_lock(ctx, cx, cy - (lk * 1.4 if da > 0.0 else lk * 0.4), lk)
	if da <= 0.0: return
	ctx.globalAlpha = da
	var need = ZD.need(str(z.id)); var pw = ZD.power()
	_txt(ctx, ZD.L("建議戰力 %d", "建議戰力 %d") % need, cx, cy + px * 0.4, px + 2, "#ffd27a")
	_txt(ctx, ZD.L("你嘅陰兵戰力 %d", "你的陰兵戰力 %d") % pw, cx, cy + px * 2.0, px, "#9fe39a" if pw >= need else "#ff9a7a")
	ctx.globalAlpha = da * (0.75 + 0.25 * sin(t * 3.0))
	_plate(ctx, ZD.L("撳我攻佔", "點我攻佔"), cx, cy + px * 3.8, px, "rgba(150,40,30,.95)")
	ctx.globalAlpha = 1.0
static func _lock(ctx: Ctx, x: float, y: float, s: float) -> void:
	ctx.strokeStyle = "#b8a070"; ctx.lineWidth = s * 0.16
	ctx.beginPath(); ctx.arc(x, y - s * 0.15, s * 0.34, PI, TAU); ctx.lineTo(x + s * 0.34, y + s * 0.1); ctx.moveTo(x - s * 0.34, y - s * 0.15); ctx.lineTo(x - s * 0.34, y + s * 0.1); ctx.stroke()
	Art.rr(ctx, x - s * 0.5, y, s, s * 0.72, s * 0.1, "#8a6a34", "#2a1a0a", maxf(1.5, s * 0.06))
	Art.el(ctx, x, y + s * 0.3, s * 0.09, s * 0.12, "#1a1008")

static func _wild_over(ctx: Ctx, nv, z: Dictionary, r: Rect2, t: float) -> void:
	var zid = str(z.id)
	var npx = _name_px(nv); var px = 16; var da = _det(nv)
	_plate(ctx, _name(nv, z), r.get_center().x, r.position.y + npx * 1.3, npx, _rgba(str(z.get("col", "#8a1c24")), 0.92))
	var bs = ZD.bosses(zid); var parts = []
	for i in bs.size():
		parts.append(("①②③④⑤")[i] + ZD.T(bs[i].n) + ("✓" if ZD.boss_done(zid, i) else ""))
	var py = 14
	ctx.globalAlpha = da
	if da > 0.0: _plate(ctx, ZD.L("王：", "王：") + "　".join(parts), r.get_center().x, r.position.y + npx * 1.3 + npx * 0.9 + py * 1.2, py, "rgba(20,10,14,.85)", "#ffe8c4")
	ctx.globalAlpha = 1.0
	var bi = ZD.boss_next(zid)
	var at = ZD.v2(z.get("boss_at", [r.get_center().x, r.get_center().y]))
	if bi < 0:
		_plate(ctx, ZD.L("已解放", "已解放"), at.x, at.y - 20, maxi(px, int(npx * 0.8)), "rgba(40,90,50,.92)")
		return
	var b = bs[bi]
	var k = str(b.get("art", "youhun"))
	var bob = sin(t * 2.0) * 3.0
	var g = ctx.createRadialGradient(at.x, at.y - 40, 6, at.x, at.y - 40, 70)
	g.addColorStop(0, "rgba(200,30,30,.38)"); g.addColorStop(1, "rgba(200,30,30,0)")
	ctx.fillStyle = g; ctx.fillRect(at.x - 70, at.y - 110, 140, 140)
	Art.draw_char(ctx, k, at.x, at.y + bob, 1.05 if J.t(b.get("main")) else 0.9, {"t": t, "flip": false})
	if da <= 0.0: return
	var lbl = ("①②③④⑤")[bi] + ZD.T(b.n) + (ZD.L("（主 Boss）", "（主 Boss）") if J.t(b.get("main")) else "")
	ctx.globalAlpha = da
	_txt(ctx, lbl, at.x, at.y + px * 1.0, px, "#ffb0a0")
	ctx.globalAlpha = da * (0.75 + 0.25 * sin(t * 3.0))
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
	if J.t(z.get("nofac")): R.call(ZD.L("二級廠：暫無（呢區嘅一級資源直接用）", "二級廠：暫無（這區的一級資源直接使用）"), 14)
	if z.get("note") != null: R.call(ZD.T(z.note), 14)
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

# ================= [zone2] 每關獨有 look：氣氛參數（zones.json maps[ci].look.atmo） =================
static func look() -> Dictionary:
	var l = ZD.cur().get("look", {})
	return l if l is Dictionary else {}
static func lkey() -> String: return str(look().get("key", "l1"))
static func _atmo() -> Dictionary:
	var a = look().get("atmo", {})
	return a if a is Dictionary else {}
static func _col3(a, dflt: Color) -> Color: return Color(float(a[0]), float(a[1]), float(a[2])) if a is Array and a.size() >= 3 else dflt
static func grade() -> Color: return _col3(_atmo().get("grade"), Color.WHITE) if ZD.on() else Color.WHITE   # 建築／人物色調（modulate）
static func _fogc() -> Color: return _col3(_atmo().get("fog"), Color(0.40, 0.34, 0.46))
static func _lamp() -> Color: return _col3(_atmo().get("lamp"), Color(1, 0.92, 0.75))
static func mist_col() -> Color:
	var m = _atmo().get("mist")
	return Color(float(m[0]), float(m[1]), float(m[2]), float(m[3])) if m is Array and m.size() >= 4 else Color(200 / 255.0, 210 / 255.0, 200 / 255.0, 0.06)
static func _gtint() -> Color:   # 地形佈景圖（籬笆、石階、棧橋）跟色調：暗少少
	var g = grade()
	return Color(0.86 * g.r, 0.84 * g.g, 0.84 * g.b)
static func _water() -> Array:
	match lkey():
		"l2": return [Color("#0c1e1c"), Color("#16343a")]
		"l3": return [Color("#101a26"), Color("#22303e")]
		"l4": return [Color("#0a1c20"), Color("#1a3436")]
	return [Color("#0e1a26"), Color("#183040")]

# 四周天然邊界（void）：熱帶黑樹林（jungle）／峭壁崖石枯松（cliff）／紅樹林蘆葦泥灘（marsh）；固定種子
const VOID_KIT := {
	"jungle": [["zb_bush", 90, 120, 0.55], ["zt_banana", 80, 110, 0.6], ["zb_bush", 100, 130, 0.5], ["tree_bare", 80, 100, 0.5], ["zt_banana", 90, 120, 0.55]],
	"cliff": [["zb_rock1", 110, 150, 0.7], ["zb_rock2", 80, 110, 0.72], ["zt_cliffpine", 100, 140, 0.7], ["zb_rock1", 120, 150, 0.66], ["zb_cliff", 120, 140, 0.7]],
	"marsh": [["zt_mangrove", 110, 150, 0.6], ["zt_reeds", 80, 110, 0.66], ["zt_mangrove", 100, 140, 0.55], ["zt_reeds", 90, 120, 0.6], ["zb_bush", 80, 110, 0.5]]}
static func _void(c: CanvasItem, b: Dictionary, vr: Rect2, t: float) -> void:
	var st = str(b.get("style", "jungle"))
	var kit = VOID_KIT.get(st, VOID_KIT.jungle)
	var fg = _fogc()
	for r0 in b.rects:
		var r = ZD.rect(r0)
		if not r.grow(150).intersects(vr): continue
		var key = "void:%s" % str(r0)
		if not _geo.has(key):
			var rng = RandomNumberGenerator.new(); rng.seed = hash(key) & 0x7fffffff
			var it = []
			var n = maxi(1, int(r.get_area() / (5200.0 if st != "cliff" else 4600.0)))
			for i in n:
				var e = kit[rng.randi() % kit.size()]
				var w = rng.randf_range(float(e[1]), float(e[2]))
				var x = rng.randf_range(r.position.x + 10, r.end.x - 10); var y = rng.randf_range(r.position.y + 30, r.end.y + 8)
				it.append([str(e[0]), x, y, w * (0.8 if r.size.x < 80 else 1.0), rng.randf() < 0.5, float(e[3]) * rng.randf_range(0.85, 1.1)])
			it.sort_custom(func(a, b2): return a[2] < b2[2])
			_geo[key] = it
		for e in _geo[key]:
			if e[1] < vr.position.x - 90 or e[1] > vr.end.x + 90 or e[2] < vr.position.y - 10 or e[2] - 170 > vr.end.y: continue
			var g = float(e[5])
			if Spr.ok(e[0]): _sp(c, e[0], e[1], e[2], e[3], e[4], Color(g * fg.r * 1.6, g * fg.g * 1.6, g * fg.b * 1.6).clamp(Color(0, 0, 0), Color(1, 1, 1)))
			else: _proc_rock(c, Vector2(e[1], e[2] - e[3] * 0.25), e[3] * 0.3)
		PtGfx.init()
		var nf = int(r.get_area() / 26000.0) + 1
		for i in nf:   # 邊界霧：慢慢飄
			var fx = r.position.x + fmod(i * 131.0 + t * (5.0 + (i % 3) * 2.0), r.size.x + 160.0) - 80.0
			var fy = r.position.y + fmod(i * 197.0, maxf(1.0, r.size.y))
			if not vr.grow(140).has_point(Vector2(fx, fy)): continue
			c.draw_texture_rect(PtGfx.RAD, Rect2(fx - 140, fy - 84, 280, 168), false, Color(fg.r, fg.g, fg.b, 0.28))

# 縱向河（第 4 關島兩邊）：同橫河一樣畫法，橋打橫
static func vriver_x(b: Dictionary, y: float) -> float: return float(b.x) + float(b.get("amp", 5)) * sin(y / 70.0)
static func _vriver(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	var x0 = float(b.x)
	if x0 < vr.position.x - 80 or x0 > vr.end.x + 80: return
	var W2 = float(b.get("w", 40))
	var pts = PackedVector2Array()
	var y = maxf(float(b.y0), vr.position.y - 20)
	while y <= minf(float(b.y1), vr.end.y + 20): pts.append(Vector2(vriver_x(b, y), y)); y += 12.0
	if pts.size() < 2: return
	var wc = _water()
	c.draw_polyline(pts, Color(0.10, 0.12, 0.08, 0.55), W2 + 14.0, true)
	c.draw_polyline(pts, Color("#141c18"), W2 + 6.0, true)
	c.draw_polyline(pts, wc[0], W2, true)
	c.draw_polyline(pts, wc[1], W2 * 0.55, true)
	for i in pts.size() - 1:
		var ph = fmod(pts[i].y * 0.05 + t * 1.6, 6.0)
		if ph < 1.2: c.draw_line(pts[i] + Vector2(-3, 0), pts[i + 1] + Vector2(-3, 0), Color(0.45, 0.62, 0.68, 0.5 * (1.2 - ph)), 1.6)
	for br in _brs(b):
		var bm = (float(br[0]) + float(br[1])) / 2.0
		_bridge_k(c, str(br[2]) if br.size() > 2 else "zb_bridge", vriver_x(b, bm) - W2 / 2.0 - 14.0, vriver_x(b, bm) + W2 / 2.0 + 14.0, bm, float(br[1]) - float(br[0]), true)
# 圖橋：橫過（horiz＝true：東西向，x0..x1 係河兩岸；by＝橋中線 y）或者直過（南北向：x0..x1 係橋闊，by＝河中線）
static func _bridge_k(c: CanvasItem, key: String, x0: float, x1: float, by: float, W2: float, horiz: bool) -> void:
	if not Spr.ok(key): return
	var tx = Spr.get_tex(key)
	if horiz:
		var w = (x1 - x0) * 1.15; var h = w * tx.get_height() / tx.get_width()
		_sp(c, key, (x0 + x1) / 2.0, by + h * 0.42, w, false, _gtint())
	else:
		var w2 = (x1 - x0) * 2.1; var h2 = w2 * tx.get_height() / tx.get_width()
		_sp(c, key, (x0 + x1) / 2.0, by + maxf(h2 * 0.5, W2 * 0.5 + 18.0), w2, false, _gtint())

# 排水溝（窄、深色、直向）＋木板橋（打橫）＋溝邊甘榜籬笆
static func _ditch(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2, t: float) -> void:
	var x = float(b.x); var w = float(b.get("w", 22))
	if x < vr.position.x - 100 or x > vr.end.x + 100: return
	var y0 = maxf(float(b.y0), vr.position.y - 20); var y1 = minf(float(b.y1), vr.end.y + 20)
	if y1 <= y0: return
	var wc = _water()
	c.draw_rect(Rect2(x - w / 2.0 - 7, y0, w + 14, y1 - y0), Color(0.10, 0.08, 0.06, 0.6))
	c.draw_rect(Rect2(x - w / 2.0, y0, w, y1 - y0), wc[0])
	c.draw_rect(Rect2(x - w / 4.0, y0, w / 2.0, y1 - y0), wc[1])
	var yy = y0 - fmod(y0, 18.0)
	while yy < y1:   # 溝邊木板／水光
		var ph = fmod(yy * 0.07 + t * 1.4, 5.0)
		if ph < 1.0: c.draw_line(Vector2(x - 2, yy), Vector2(x - 2, yy + 14), Color(0.45, 0.62, 0.66, 0.45 * (1.0 - ph)), 1.4)
		c.draw_line(Vector2(x - w / 2.0 - 3, yy), Vector2(x - w / 2.0 - 3, yy + 12), Color(0.24, 0.16, 0.10, 0.9), 2.0)
		c.draw_line(Vector2(x + w / 2.0 + 3, yy + 6), Vector2(x + w / 2.0 + 3, yy + 16), Color(0.24, 0.16, 0.10, 0.9), 2.0)
		yy += 18.0
	if b.get("fence") != null and Spr.ok(str(b.fence)):   # 膠園邊甘榜籬笆（門口留空）
		_vrow(c, ctx, {"x": float(b.get("fx", x - 30)), "y0": float(b.y0) + 20, "y1": float(b.y1) - 10, "gap": [float(b.gap[0]) - 14, float(b.gap[1]) + 14], "key": str(b.fence), "pw": 74.0}, vr)
	var gm = (float(b.gap[0]) + float(b.gap[1])) / 2.0
	_bridge_k(c, str(b.get("key", "zb_bridge")), x - w / 2.0 - 22, x + w / 2.0 + 22, gm, float(b.gap[1]) - float(b.gap[0]), true)

# 橫向一排（香蕉樹灌木帶 belt／籬笆、護欄 fence）：中間留缺口（小徑／閘口）
static func _hrow(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2) -> void:
	var y = float(b.y)
	if y < vr.position.y - 20 or y - 140 > vr.end.y: return
	var key = str(b.get("key", "zt_pagar"))
	if not Spr.ok(key): return
	var belt = str(b.k) == "belt"
	var step = float(b.get("step", 64 if belt else 84)); var seg = float(b.get("seg", step + 10))
	for sp in [[float(b.x0), float(b.gap[0])], [float(b.gap[1]), float(b.x1)]]:
		var L = sp[1] - sp[0]
		if L < 20: continue
		var n = maxi(1, int(ceil(L / step))); var st2 = L / n
		for i in n:
			var cx = sp[0] + st2 * (i + 0.5)
			if cx < vr.position.x - 80 or cx > vr.end.x + 80: continue
			var w = seg * (0.92 + fmod(absf(cx * 0.37), 0.18)) if belt else st2 + 10.0
			_sp(c, key, cx, y + (fmod(absf(cx * 1.3), 10.0) - 5.0 if belt else 0.0) + 6.0, w, int(cx / 31.0) % 2 == 1, _gtint())
	if not belt:   # 閘口兩條柱
		for gx in [float(b.gap[0]) - 2.0, float(b.gap[1]) + 2.0]: _post(ctx, gx, y + 4, 34)
# 直向一排（村邊籬笆 vfence／殘破青石護欄 rail）：正面圖上下疊（同參考預覽圖），中間留門口
static func _vrow(c: CanvasItem, ctx: Ctx, b: Dictionary, vr: Rect2) -> void:
	var x = float(b.x)
	if x < vr.position.x - 80 or x > vr.end.x + 80: return
	var key = str(b.get("key", "zt_pagar"))
	if not Spr.ok(key): return
	var pw = float(b.get("pw", 78.0)); var tx = Spr.get_tex(key); var ph = pw * tx.get_height() / tx.get_width()
	var step = ph * 0.62
	for sp in [[float(b.y0), float(b.gap[0])], [float(b.gap[1]), float(b.y1)]]:
		var L = sp[1] - sp[0]
		if L < 20: continue
		var n = maxi(1, int(ceil(L / step))); var st2 = L / n
		for i in n:
			var yb = sp[0] + st2 * (i + 1)
			if yb < vr.position.y - 10 or yb - ph > vr.end.y: continue
			var k2 = key
			if str(b.get("k", "")) == "rail" and int(yb / st2) % 4 == 2 and Spr.ok("zb_rock2"): k2 = "zb_rock2"   # 護欄崩口：碎石
			_sp(c, k2, x + (3.0 if i % 2 == 0 else -3.0), yb, pw * (0.8 if k2 == "zb_rock2" else 1.0), i % 2 == 1, _gtint())
	for gy in [float(b.gap[0]), float(b.gap[1]) + 8.0]: _post(ctx, x, gy, 30)

# 區外佈景（zones.json scenery：[圖鍵, x, y, 闊]）
static func _scenery(c: CanvasItem, vr: Rect2) -> void:
	var fg = _fogc()
	for e in ZD.cur().get("scenery", []):
		var x = float(e[1]); var y = float(e[2]); var w = float(e[3])
		if x < vr.position.x - w or x > vr.end.x + w or y < vr.position.y - 10 or y - w * 1.2 > vr.end.y: continue
		_sp(c, str(e[0]), x, y, w, int(x) % 2 == 1, Color(0.62 + fg.r * 0.3, 0.6 + fg.g * 0.3, 0.6 + fg.b * 0.3))

# ================= [zone2] 天氣／環境粒子（世界座標錨定：512×512 一格重複，唔跟鏡頭飄） =================
#   l1 枯葉＋紙錢灰；l2 螢火蟲＋青綠鬼火＋貼地水氣；l3 山霧大團飄過＋冷月光；l4 淡紅月色＋偶爾落雨（約 70 秒一場、下 22 秒）
const CELL := 512.0
static func _h(i: int, k: int) -> float: return fmod(absf(sin(float(i) * 12.9898 + float(k) * 78.233) * 43758.5453), 1.0)
static func draw_atmo(c: CanvasItem, nv) -> void:
	if not ZD.on(): return
	PtGfx.init()
	var t: float = nv.t
	var vr: Rect2 = nv.view_rect().grow(60)
	var fx = str(_atmo().get("fx", ""))
	var cx0 = int(floor(vr.position.x / CELL)); var cx1 = int(floor(vr.end.x / CELL)); var cy0 = int(floor(vr.position.y / CELL)); var cy1 = int(floor(vr.end.y / CELL))
	var dens = clampf(_rel(nv), 0.35, 1.0)   # 縮到好細：粒子少啲
	for gy in range(cy0, cy1 + 1):
		for gx in range(cx0, cx1 + 1):
			var base = Vector2(gx * CELL, gy * CELL); var cid = gx * 7919 + gy * 104729
			match fx:
				"leaves": _fx_leaves(c, base, cid, t, dens)
				"fireflies": _fx_fireflies(c, base, cid, t, dens)
				"fog": _fx_fog(c, base, cid, t, dens)
				"rain": _fx_rain(c, base, cid, t, dens)
	if fx == "rain": _fx_rain_tint(c, vr, t)
	if fx == "fog": c.draw_rect(vr, Color(0.55, 0.65, 0.85, 0.05))   # 冷月光
static func rain_k(t: float) -> float:   # 0..1：而家落雨幾大
	var ph = fmod(t, 70.0)
	if ph < 40.0 or ph > 64.0: return 0.0
	return clampf(minf(ph - 40.0, 64.0 - ph) / 3.0, 0.0, 1.0)
static func _fx_leaves(c: CanvasItem, base: Vector2, cid: int, t: float, dens: float) -> void:
	var n = int(7 * dens)
	for i in n:
		var k = cid + i * 31
		var sp = 18.0 + _h(k, 1) * 16.0
		var y = fmod(_h(k, 2) * CELL + t * sp, CELL)
		var x = _h(k, 3) * CELL + sin(t * 0.9 + _h(k, 4) * 6.0) * 16.0 + y * 0.18
		var p = base + Vector2(fmod(x, CELL), y)
		var ash = i % 3 == 0
		var a = t * (1.5 + _h(k, 5)) + _h(k, 6) * 6.0
		var col = Color(0.62, 0.6, 0.58, 0.55) if ash else [Color(0.62, 0.44, 0.18, 0.8), Color(0.5, 0.36, 0.16, 0.8), Color(0.7, 0.56, 0.24, 0.75)][i % 3]
		var s = 3.0 if ash else 4.5
		c.draw_set_transform(p, a, Vector2(1.0, 0.45 + 0.4 * absf(sin(a * 1.3))))
		if ash: c.draw_rect(Rect2(-s / 2, -s / 2, s, s), col)
		else: c.draw_colored_polygon(PackedVector2Array([Vector2(-s, 0), Vector2(0, -s * 0.5), Vector2(s, 0), Vector2(0, s * 0.5)]), col)
		c.draw_set_transform_matrix(Transform2D.IDENTITY)
static func _fx_fireflies(c: CanvasItem, base: Vector2, cid: int, t: float, dens: float) -> void:
	var n = int(9 * dens)
	for i in n:
		var k = cid + i * 17
		var p = base + Vector2(_h(k, 1) * CELL + sin(t * 0.7 + _h(k, 2) * 9.0) * 22.0, _h(k, 3) * CELL + cos(t * 0.5 + _h(k, 4) * 9.0) * 14.0)
		var bl = clampf(sin(t * (1.6 + _h(k, 5) * 1.5) + _h(k, 6) * 9.0) * 1.4, 0.0, 1.0)
		if bl <= 0.02: continue
		c.draw_texture_rect(PtGfx.RAD, Rect2(p.x - 9, p.y - 9, 18, 18), false, Color(0.75, 1.0, 0.45, 0.35 * bl))
		c.draw_circle(p, 1.6, Color(0.92, 1.0, 0.6, 0.9 * bl))
	if _h(cid, 9) < 0.55:   # 青綠鬼火：一格最多一團，慢慢飄
		var q = base + Vector2(_h(cid, 10) * CELL + sin(t * 0.3 + cid) * 40.0, _h(cid, 11) * CELL + sin(t * 0.45 + cid * 0.3) * 18.0)
		var fl = 0.7 + 0.3 * sin(t * 5.0 + cid)
		c.draw_texture_rect(PtGfx.RAD, Rect2(q.x - 30, q.y - 30, 60, 60), false, Color(0.2, 0.95, 0.75, 0.22 * fl))
		c.draw_texture_rect(PtGfx.RAD, Rect2(q.x - 9, q.y - 14, 18, 24), false, Color(0.55, 1.0, 0.9, 0.6 * fl))
	for j in 2:   # 貼地潮濕水氣
		var mx = base.x + fmod(_h(cid, 20 + j) * CELL + t * (6.0 + j * 3.0), CELL + 200.0) - 100.0; var my = base.y + _h(cid, 30 + j) * CELL
		c.draw_texture_rect(PtGfx.RAD, Rect2(mx - 150, my - 30, 300, 60), false, Color(0.6, 0.85, 0.75, 0.07))
static func _fx_fog(c: CanvasItem, base: Vector2, cid: int, t: float, dens: float) -> void:
	for j in 3:
		var mx = base.x + fmod(_h(cid, 40 + j) * CELL + t * (9.0 + j * 4.0), CELL + 320.0) - 160.0; var my = base.y + _h(cid, 50 + j) * CELL
		var sz = 220.0 + _h(cid, 60 + j) * 140.0
		c.draw_texture_rect(PtGfx.RAD, Rect2(mx - sz, my - sz * 0.4, sz * 2.0, sz * 0.8), false, Color(0.82, 0.88, 0.98, 0.12))
	var n = int(4 * dens)
	for i in n:   # 細霧絲
		var k = cid + i * 13
		var x = base.x + fmod(_h(k, 1) * CELL + t * 14.0, CELL); var y = base.y + _h(k, 2) * CELL
		c.draw_texture_rect(PtGfx.RAD, Rect2(x - 60, y - 10, 120, 20), false, Color(0.86, 0.9, 1.0, 0.10))
static func _fx_rain(c: CanvasItem, base: Vector2, cid: int, t: float, dens: float) -> void:
	var rk = rain_k(t)
	for j in 2:   # 水面暗紅反光（一直有）
		var q = base + Vector2(_h(cid, 70 + j) * CELL, _h(cid, 80 + j) * CELL)
		c.draw_texture_rect(PtGfx.RAD, Rect2(q.x - 40, q.y - 8, 80, 16), false, Color(0.9, 0.4, 0.4, 0.06 + 0.04 * sin(t * 2.0 + j)))
	if rk <= 0.0: return
	var n = int(26 * dens * rk)
	for i in n:
		var k = cid + i * 7
		var y = fmod(_h(k, 1) * CELL + t * 620.0 * (0.9 + _h(k, 2) * 0.2), CELL)
		var x = fmod(_h(k, 3) * CELL - y * 0.18, CELL)
		var p = base + Vector2(x if x >= 0 else x + CELL, y)
		c.draw_line(p, p + Vector2(-4, 18), Color(0.8, 0.78, 0.86, 0.38), 1.2)
	for i in int(6 * rk):   # 地面水花
		var k = cid + i * 53 + int(t * 3.0) * 101
		var p2 = base + Vector2(_h(k, 1) * CELL, _h(k, 2) * CELL)
		var ph = fmod(t * 3.0, 1.0)
		c.draw_arc(p2, 2.0 + ph * 6.0, 0, TAU, 10, Color(0.8, 0.8, 0.9, 0.35 * (1.0 - ph)), 1.0)
static func _fx_rain_tint(c: CanvasItem, vr: Rect2, t: float) -> void:
	var rk = rain_k(t)
	if rk > 0.0: c.draw_rect(vr, Color(0.10, 0.12, 0.18, 0.12 * rk))
