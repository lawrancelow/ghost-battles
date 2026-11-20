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

# [zone2] 每關地面調色／筆觸（zones.json maps[ci].look.g）；冇就用第 1 關原色
func G(k: String, d): 
	var lk = M.get("look", {})
	var g = lk.get("g", {}) if lk is Dictionary else {}
	return g.get(k, d) if g is Dictionary else d
func _cc(e, d: Color) -> Color: return _c(str(e[0]), float(e[1])) if e is Array and e.size() >= 2 else d
func _draw() -> void:
	seed = 11
	var W = float(M.w); var H = float(M.h)
	var X = Transform2D(Vector2(K, 0), Vector2(0, K), Vector2(0, -Y0 * K))
	var x = Ctx.new(self, X)
	draw_set_transform_matrix(X)
	draw_rect(Rect2(0, 0, W, H), _c(str(G("base", "#4a3424"))))
	var tile: Texture2D = _tile
	if tile == null and ResourceLoader.exists("res://assets/spr/vg_ground_tile.png"): tile = load("res://assets/spr/vg_ground_tile.png")
	_tile = tile
	if tile:
		var ts = tile.get_size()
		for gy in int(ceil(H / ts.y)):
			for gx in int(ceil(W / ts.x)):
				var tm = G("tile", [1.0, 0.98, 0.9])
				draw_texture_rect(tile, Rect2(Vector2(gx, gy) * ts, ts), false, Color(float(tm[0]), float(tm[1]), float(tm[2])))
	var roads = []
	_ps = path_samples(M)
	var area = W * H / 440700.0   # 舊村子面積倍數（密度一樣）
	for i in int(50 * area):
		var px = R() * W; var py = R() * H; var r = 40 + R() * 70
		var bl = G("blob", [["#6b4a30", 0.16], ["#160c14", 0.22]])
		x.fillStyle = _cc(bl[0], Color.BLACK) if R() < 0.45 else _cc(bl[1], Color.BLACK)
		x.beginPath(); x.ellipse(px, py, r * 1.5, r, -0.4, 0, TAU); x.fill()
	# 區底色：野外暗紅、竹林暗綠、枯井巷暗藍、禾稈場暗黃（同參考圖一樣）
	var tint = {"wild": Color(0.47, 0.04, 0.08, 0.30), "A": Color(0.08, 0.24, 0.08, 0.20), "B": Color(0.08, 0.16, 0.28, 0.20), "C": Color(0.32, 0.24, 0.04, 0.20)}
	var tg = G("tint", {})
	for tk in tg: tint[tk] = Color(float(tg[tk][0]), float(tg[tk][1]), float(tg[tk][2]), float(tg[tk][3]))
	draw_set_transform_matrix(X)
	for z in M.zones:
		var key = "wild" if str(z.type) == "wild" else str(z.id)
		if tint.has(key):   # [zone v4] 柔邊漸變（交界唔見硬邊）
			var tc: Color = tint[key]; var n = 8
			for k in n: draw_rect(_rect(z.rect).grow(28.0 - k * 8.0), Color(tc.r, tc.g, tc.b, tc.a / n * 1.6))
	# [zone v6] 地面變化：草地斑塊（深綠灰）、泥濘水窪、稻田田埂（唔好成片均勻啡色）
	draw_set_transform_matrix(X)
	for z in M.zones:
		if not (str(z.type) in ["village", "res", "market"]): continue
		var zr = _rect(z.rect).grow(-10)
		var npatch = int(zr.get_area() / 9000.0 * float(G("patch_n", 1.0)))
		var pc = G("patch", [["#2c3a26", 0.10], ["#34422c", 0.10], ["#263020", 0.12]])
		for i in npatch:
			var cx = zr.position.x + R() * zr.size.x; var cy = zr.position.y + R() * zr.size.y
			if _on_road(Vector2(cx, cy)): continue
			var rr = 26.0 + R() * 46.0
			for k in 6:   # 一嚿軟邊草地
				var ox = (R() - 0.5) * rr * 1.2; var oy = (R() - 0.5) * rr * 0.6
				var col = _cc(pc[k % 3], Color.BLACK)
				draw_set_transform(Vector2(cx + ox, cy + oy) * K - Vector2(0, Y0 * K), 0, Vector2(K * 1.5, K * 0.75))
				draw_circle(Vector2.ZERO, rr * (0.5 + R() * 0.4), col)
		draw_set_transform_matrix(X)
		if str(z.type) == "market": continue
		if J.t(z.get("water")):   # [zone2] 河口罾棚：成片淺水（暗綠水光）
			draw_rect(zr.grow(6), _c("#0c1c20", 0.55)); draw_rect(zr.grow(-6), _c("#12282c", 0.35))
			for i in int(zr.get_area() / 900.0):
				var wx = zr.position.x + R() * zr.size.x; var wy = zr.position.y + R() * zr.size.y
				draw_line(Vector2(wx, wy), Vector2(wx + 8 + R() * 14, wy), _c("#4a7a78", 0.18 + R() * 0.12), 1.0)
		var pud_n = float(G("puddle_n", 1.0)); var pud_c = str(G("puddle", "#16202a"))
		for i in int((zr.get_area() / 60000.0 + 1) * pud_n):   # 水窪
			var px = zr.position.x + 20 + R() * (zr.size.x - 40); var py = zr.position.y + 20 + R() * (zr.size.y - 40)
			if _on_road(Vector2(px, py)): continue
			var pw = 9.0 + R() * 9.0
			draw_set_transform(Vector2(px, py) * K - Vector2(0, Y0 * K), 0, Vector2(K * 1.6, K * 0.7))
			draw_circle(Vector2.ZERO, pw + 4, _c("#1c140e", 0.35)); draw_circle(Vector2.ZERO, pw, _c(pud_c, 0.6))
			draw_circle(Vector2(-pw * 0.3, -pw * 0.25), pw * 0.35, _c("#4a6068", 0.25))
			draw_set_transform_matrix(X)
	var V = M.get("village", {})
	if V.get("PADDY_POS") is Array:   # 田埂：稻田一大片（真田＋裝飾田）外圍泥埂
		var pts = V.PADDY_POS.duplicate()
		for pr in V.get("props", []): if str(pr[0]) == "deco:paddy": pts.append([pr[1], pr[2]])
		for q in pts:
			var r0 = Rect2(float(q[0]) - 44, float(q[1]) - 38, 88, 46)
			draw_rect(r0, _c("#24180f", 0.35))
			draw_rect(r0, _c("#6a5034", 0.35), false, 3.0)
	# 草
	var tuft = func(tx: float, ty: float, big: bool) -> void:
		var gc = G("tuft", ["#2c3628", "#36412f", "#283024", "#3c4434"])
		var n = 7 if big else 4
		for k in n:
			x.strokeStyle = gc[int(R() * 4)]; x.lineWidth = 1.3 if big else 1.0
			var bx = tx + (k - n / 2.0) * (2.0 if big else 1.6); var h = (8 + R() * 9) if big else (4 + R() * 5)
			x.beginPath(); x.moveTo(bx, ty); x.quadraticCurveTo(bx + (R() - 0.5) * 3, ty - h * 0.6, bx + (k - n / 2.0) * 1.8 + (R() - 0.5) * 3, ty - h); x.stroke()
	var tn = float(G("tuft_n", 1.0))
	for i in int(70 * area * tn):
		var cx = R() * W; var cy = 10 + R() * (H - 10)
		for k in 6:
			var tx = cx + (R() - 0.5) * 34; var ty = cy + (R() - 0.5) * 12
			if not _on_road(Vector2(tx, ty), roads): tuft.call(tx, ty, R() < 0.5)
	for i in int(260 * area * tn):
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
	# 泥路：連續踩實泥（比地面淺一級、柔邊）＋車轍＋少量碎石（主路闊、小路窄）
	draw_set_transform_matrix(X)
	var rc = G("road", [["#1a120c", 0.035], ["#5e4630", 0.10], ["#7a5c40", 0.11], ["#8a6a4a", 0.05]])
	for e in _ps:
		var q: Vector2 = e[0]; var hw: float = e[1]
		draw_circle(q, hw + 9.0, _cc(rc[0], Color.BLACK))   # 路邊深一級（柔）
	for e in _ps:
		var q: Vector2 = e[0]; var hw: float = e[1]
		draw_circle(q, hw + 2.0, _cc(rc[1], Color.BLACK))
		var c2 = _cc(rc[2], Color.BLACK)
		draw_circle(q, hw - 2.0, Color(c2.r, c2.g, c2.b, c2.a if e[2] == "main" else c2.a * 0.8))
		draw_circle(q, hw * 0.55, _cc(rc[3], Color.BLACK))
	var j = 0
	for i in _ps.size() - 1:   # 車轍（主路兩條）＋碎石
		var e = _ps[i]; var e2 = _ps[i + 1]
		if e[2] != e2[2] or e[0].distance_to(e2[0]) > 12.0: continue
		var d = (e2[0] - e[0]).normalized(); var nrm = Vector2(-d.y, d.x)
		if e[2] == "main":
			for sd in [-0.32, 0.32]:
				var o = nrm * e[1] * sd
				draw_line(e[0] + o, e2[0] + o, _c(str(G("rut", "#3a2a1c")), 0.30), 2.2, true)
		j += 1
		if j % 4 == 0:
			var gp = e[0] + nrm * (R() - 0.5) * e[1] * 1.4
			draw_circle(gp, 1.2 + R() * 1.6, _c(["#4a4248", "#5a5052", "#3a3236"][j % 3], 0.85))
	# [zone2] 石板：古道主路鋪青石板（第 3 關）
	if float(G("slabs", 0.0)) > 0.0:
		var k3 = 0
		for e in _ps:   # 亂鋪青石板：路面隨機位、大細唔一，崩咗啲（唔排到成條路軌）
			k3 += 1
			if e[2] != "main" or k3 % 2 != 0: continue
			var q: Vector2 = e[0]; var hw2: float = e[1]
			for jj in 2:
				if R() < 0.35: continue
				var sw = 10 + R() * 12; var sh = 7 + R() * 6
				slab.call(q.x + (R() - 0.5) * hw2 * 1.3 - sw / 2, q.y + (R() - 0.5) * hw2 * 0.9 - sh / 2, sw, sh)
	# [zone2] 田／梯田等地面圖案（zones.json gfx）
	for gf in M.get("gfx", []):
		if str(gf.get("k")) == "terrace":
			for ty in gf.ys:
				draw_line(Vector2(float(gf.x0), float(ty) + 6), Vector2(float(gf.x1), float(ty) + 6), _c("#20241e", 0.55), 9.0, true)
				draw_line(Vector2(float(gf.x0), float(ty)), Vector2(float(gf.x1), float(ty)), _c("#5a5a48", 0.55), 4.0, true)
	# [zone2] 乾裂（第 1 關饑荒）：網狀裂紋
	for i in int(60 * area * float(G("drycrack", 0.0))):
		var p0 = Vector2(R() * W, R() * H)
		if _on_road(p0): continue
		x.strokeStyle = "rgba(20,12,6,.42)"; x.lineWidth = 0.9
		for b in 3:
			var a = R() * TAU; var q2 = p0
			x.beginPath(); x.moveTo(q2.x, q2.y)
			for k in 4:
				q2 += Vector2(cos(a), sin(a) * 0.6) * (5 + R() * 7); a += (R() - 0.5) * 1.2
				x.lineTo(q2.x, q2.y)
			x.stroke()
	# 螺旋龜裂
	for i in int(16 * area * float(G("crack_n", 1.0))):
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
	if G("stroke", null) is Array:
		scol = []
		for e in G("stroke", []): scol.append(_cc(e, Color.BLACK))
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
		var vc = str(G("void", "#1a1620"))
		draw_rect(vr, _c(vc, 0.80))
		for k in 3: draw_rect(vr.grow(6.0 * (k + 1)), _c(vc, 0.10))
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
		if vr.position.y > mr.end.y: solid.append(Rect2(minf(vr.position.x, mr.position.x), mr.end.y - 4, maxf(vr.size.x, mr.size.x), vr.position.y - mr.end.y + 8))
	var gp = M.get("village", {}).get("POS", {}).get("gate")   # [zone2] 出村門一帶（任何一邊）唔當虛空
	if gp is Array: solid.append(Rect2(float(gp[0]) - 90, float(gp[1]) - 110, 180, 150))
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
