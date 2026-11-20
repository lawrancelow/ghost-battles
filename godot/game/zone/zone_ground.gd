# [zone] 分區地圖地面（沿用 game/ground_painter.gd 嘅筆觸：蠟筆泥地平鋪、光暗塊、草叢、石板路、螺旋龜裂、密集排線、紙紋）
# 只烘一次：tools/tests/zone_test.gd bake → assets/img/<ground>_a.webp（上半）、_b.webp（下半），1.5 倍解像度。
# 用法：Node2D 掛呢個腳本，設 M（zones.json 一張圖）、K（倍數）、Y0（呢塊由世界 y 幾多開始），放入 SubViewport 拍照。
# 成張圖用同一個種子畫（每塊都由頭畫晒再平移），上下兩塊接縫一模一樣。
extends Node2D

var M := {}
var K := 1.5
var Y0 := 0.0
var seed = 11
var _tile: Texture2D

func R() -> float:
	seed = (seed * 16807) % 2147483647
	return float(seed) / 2147483647.0
func _c(h: String, a := 1.0) -> Color: return Color(Color(h), a)
static func _rect(a) -> Rect2: return Rect2(float(a[0]), float(a[1]), float(a[2]) - float(a[0]), float(a[3]) - float(a[1]))

# [zone v5] 路：彎曲泥石路（paths 折線經 Catmull-Rom 變順）；回 [[點, 半闊, 種類], ...]
static func path_samples(M: Dictionary, step := 5.0) -> Array:
	var o = []
	for pa in M.get("paths", []):
		var P = []
		for q in pa.pts: P.append(Vector2(float(q[0]), float(q[1])))
		var hw = float(pa.get("w", 30)) / 2.0
		for i in P.size() - 1:
			var p0 = P[maxi(0, i - 1)]; var p1 = P[i]; var p2 = P[i + 1]; var p3 = P[mini(P.size() - 1, i + 2)]
			var n = maxi(1, int(p1.distance_to(p2) / step))
			for k in n:
				var t = float(k) / n
				var t2 = t * t; var t3 = t2 * t
				var q = 0.5 * ((2.0 * p1) + (-p0 + p2) * t + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3)
				o.append([q, hw, str(pa.get("k", "lane"))])
		o.append([P[P.size() - 1], hw, str(pa.get("k", "lane"))])
	return o
var _ps := []
func _on_road(p: Vector2, _roads = null) -> bool:
	for e in _ps:
		if absf(e[0].x - p.x) < e[1] + 6 and e[0].distance_to(p) < e[1] + 4: return true
	return false

func _draw() -> void:
	seed = 11
	var W = float(M.w); var H = float(M.h)
	var X = Transform2D(Vector2(K, 0), Vector2(0, K), Vector2(0, -Y0 * K))
	var x = Ctx.new(self, X)
	draw_set_transform_matrix(X)
	draw_rect(Rect2(0, 0, W, H), _c("#4a3424"))
	var tile: Texture2D = _tile
	if tile == null and ResourceLoader.exists("res://assets/spr/vg_ground_tile.png"): tile = load("res://assets/spr/vg_ground_tile.png")
	_tile = tile
	if tile:
		var ts = tile.get_size()
		for gy in int(ceil(H / ts.y)):
			for gx in int(ceil(W / ts.x)): draw_texture_rect(tile, Rect2(Vector2(gx, gy) * ts, ts), false, Color(1.0, 0.98, 0.9))
	var roads = []
	_ps = path_samples(M)
	var area = W * H / 440700.0   # 舊村子面積倍數（密度一樣）
	for i in int(50 * area):
		var px = R() * W; var py = R() * H; var r = 40 + R() * 70
		x.fillStyle = _c("#6b4a30", 0.16) if R() < 0.45 else _c("#160c14", 0.22)
		x.beginPath(); x.ellipse(px, py, r * 1.5, r, -0.4, 0, TAU); x.fill()
	# 區底色：野外暗紅、竹林暗綠、枯井巷暗藍、禾稈場暗黃（同參考圖一樣）
	var tint = {"wild": Color(0.47, 0.04, 0.08, 0.30), "A": Color(0.08, 0.24, 0.08, 0.20), "B": Color(0.08, 0.16, 0.28, 0.20), "C": Color(0.32, 0.24, 0.04, 0.20)}
	draw_set_transform_matrix(X)
	for z in M.zones:
		var key = "wild" if str(z.type) == "wild" else str(z.id)
		if tint.has(key):   # [zone v4] 柔邊漸變（交界唔見硬邊）
			var tc: Color = tint[key]; var n = 8
			for k in n: draw_rect(_rect(z.rect).grow(28.0 - k * 8.0), Color(tc.r, tc.g, tc.b, tc.a / n * 1.6))
	# 草
	var tuft = func(tx: float, ty: float, big: bool) -> void:
		var gc = ["#2c3628", "#36412f", "#283024", "#3c4434"]
		var n = 7 if big else 4
		for k in n:
			x.strokeStyle = gc[int(R() * 4)]; x.lineWidth = 1.3 if big else 1.0
			var bx = tx + (k - n / 2.0) * (2.0 if big else 1.6); var h = (8 + R() * 9) if big else (4 + R() * 5)
			x.beginPath(); x.moveTo(bx, ty); x.quadraticCurveTo(bx + (R() - 0.5) * 3, ty - h * 0.6, bx + (k - n / 2.0) * 1.8 + (R() - 0.5) * 3, ty - h); x.stroke()
	for i in int(70 * area):
		var cx = R() * W; var cy = 10 + R() * (H - 10)
		for k in 6:
			var tx = cx + (R() - 0.5) * 34; var ty = cy + (R() - 0.5) * 12
			if not _on_road(Vector2(tx, ty), roads): tuft.call(tx, ty, R() < 0.5)
	for i in int(260 * area):
		var tx = R() * W; var ty = 4 + R() * (H - 4)
		if not _on_road(Vector2(tx, ty), roads): tuft.call(tx, ty, false)
	# 石板路
	var slabc = ["#2b2729", "#272325", "#302a2b", "#24201f"]
	var slab = func(sx: float, sy: float, w: float, h: float) -> void:
		var j = (R() - 0.5) * 2
		x.fillStyle = "rgba(8,4,8,.55)"; x.beginPath(); x.roundRect(sx + j - 0.5, sy + 0.5, w - 1, h - 1, 3); x.fill()
		x.fillStyle = slabc[int(floor(R() * 4))]; x.beginPath(); x.roundRect(sx + j, sy, w - 2, h - 2, 3); x.fill()
		x.fillStyle = "rgba(107,74,48,.10)"; x.fillRect(sx + j + 2, sy + 1, w - 6, 1.2)
		x.fillStyle = "rgba(0,0,0,.45)"; x.fillRect(sx + j, sy + h - 3, w - 2, 1.5)
		var r0 = R()
		if r0 < 0.42:
			x.strokeStyle = "rgba(10,6,8,.85)"; x.lineWidth = 0.7
			var px = sx + j + 3 + R() * (w - 8); var py = sy + 1.5
			x.beginPath(); x.moveTo(px, py)
			for k in 3:
				px += (R() - 0.5) * 7; py += (h - 4) / 3.0; x.lineTo(clampf(px, sx + 1, sx + w - 3), py)
			x.stroke()
		elif r0 < 0.52:
			var ccx = sx + j + w / 2 - 1; var ccy = sy + h / 2 - 1
			x.strokeStyle = "rgba(12,6,10,.7)"; x.lineWidth = 0.6; x.beginPath()
			for k in 26:
				var a = k * 0.42; var rr = 0.4 + k * 0.17
				if k == 0: x.moveTo(ccx + cos(a) * rr, ccy + sin(a) * rr)
				else: x.lineTo(ccx + cos(a) * rr, ccy + sin(a) * rr)
			x.stroke()
	# 泥石路：踩實嘅泥（柔邊）＋主路中間散落石板／碎石
	draw_set_transform_matrix(X)
	for e in _ps:
		var q: Vector2 = e[0]; var hw: float = e[1]
		draw_circle(q, hw + 7.0, _c("#1e140e", 0.05))
		draw_circle(q, hw, _c("#4e3a28", 0.16 if e[2] == "main" else 0.13))
		draw_circle(q, hw * 0.6, _c("#5e4632", 0.10))
	var j = 0
	for e in _ps:
		j += 1
		var q: Vector2 = e[0]; var hw: float = e[1]
		if e[2] == "main":
			if j % 3 != 0: continue
			for k in 2:
				var sx = q.x + (R() - 0.5) * hw * 1.3; var sy = q.y + (R() - 0.5) * 6
				var w = 9 + R() * 9; var h = 6 + R() * 5
				slab.call(sx - w / 2, sy - h / 2, w, h)
		elif j % 5 == 0:
			x.fillStyle = "rgba(40,32,30,.6)"; x.beginPath(); x.ellipse(q.x + (R() - 0.5) * hw, q.y + (R() - 0.5) * 4, 2 + R() * 2, 1.5 + R(), 0, 0, TAU); x.fill()
	# 螺旋龜裂
	for i in int(16 * area):
		var sx2 = R() * W; var sy2 = 30 + R() * (H - 50)
		if _on_road(Vector2(sx2, sy2)): continue
		x.strokeStyle = "rgba(14,8,10,.38)"; x.lineWidth = 0.8; x.beginPath()
		var turns = 2.2 + R() * 1.5; var rmax = 7 + R() * 9; var a0 = R() * TAU
		for k in 40:
			var f = k / 39.0; var a = a0 + f * turns * TAU
			var p = Vector2(sx2 + cos(a) * rmax * f, sy2 + sin(a) * rmax * f * 0.6)
			if k == 0: x.moveTo(p.x, p.y)
			else: x.lineTo(p.x, p.y)
		x.stroke()
	# 蠟筆排線＋紙紋
	draw_set_transform_matrix(X)
	var scol = [_c("#6b4a30", 0.20), _c("#4a3424", 0.26), _c("#2a1a14", 0.26), _c("#3a3a2c", 0.12), _c("#1e1222", 0.22), _c("#7a5638", 0.10)]
	for i in int(19500 * area):
		var px = R() * W; var py = -8 + R() * (H + 8); var ln = 3 + R() * 7; var a = -0.6 + (R() - 0.5) * 0.3
		draw_line(Vector2(px, py), Vector2(px + cos(a) * ln, py + sin(a) * ln), scol[int(floor(R() * scol.size()))], (0.5 + R() * 1.0), true)
	for i in int(3800 * area):
		var px = R() * W; var py = -6 + R() * (H + 6); var ln = 3 + R() * 5; var a = 0.7 + (R() - 0.5) * 0.3
		draw_line(Vector2(px, py), Vector2(px + cos(a) * ln, py + sin(a) * ln), _c("#140a12", 0.16), 0.7, true)
	for i in int(6000 * area):
		var c2 = _c("#e6d2b0", 0.05) if R() < 0.55 else _c("#000000", 0.2)
		draw_rect(Rect2(R() * W, R() * H, 0.5 + R() * 0.9, 0.5 + R() * 0.9), c2)
	# 虛空：唔屬任何區（四角）→ 深紫黑，邊位淡出
	draw_set_transform_matrix(X)
	# 虛空（山岩懸崖底）：灰黑岩地，邊位慢慢暗落去（山岩、黑森林、濃霧由 zone_view 即時畫）
	for v in _void(W, H):
		var vr: Rect2 = v
		draw_rect(vr, _c("#1a1620", 0.80))
		for k in 3: draw_rect(vr.grow(6.0 * (k + 1)), _c("#1a1620", 0.10))
	draw_set_transform_matrix(Transform2D.IDENTITY)

# 虛空矩形：全圖減去所有區（區外 14px 當牆位，唔算虛空）同走廊
func _void(W: float, H: float) -> Array:
	var solid = []
	for z in M.zones: solid.append(_rect(z.rect).grow(12))
	var mk = M.get("market", {})
	if mk.get("counter") is Array:   # 大排檔底 → 出村門走廊
		var vz = {}
		for z in M.zones: if str(z.type) == "village": vz = z
		var vr = _rect(vz.rect); var mr = Rect2()
		for z in M.zones: if str(z.type) == "market": mr = _rect(z.rect)
		solid.append(Rect2(minf(vr.position.x, mr.position.x), mr.end.y - 4, maxf(vr.size.x, mr.size.x), vr.position.y - mr.end.y + 8))
	# 粗格掃描（20 單位）：唔喺任何實區嘅格合併做橫條
	var o = []; var G = 20.0
	var y = 0.0
	while y < H:
		var x0 = -1.0; var xx = 0.0
		while xx <= W:
			var cen = Vector2(xx + G / 2.0, y + G / 2.0)
			var inside = xx >= W
			if not inside:
				for r in solid: if r.has_point(cen): inside = true; break
			if not inside and x0 < 0: x0 = xx
			if inside and x0 >= 0: o.append(Rect2(x0, y, xx - x0, G)); x0 = -1.0
			xx += G
		y += G
	return o
