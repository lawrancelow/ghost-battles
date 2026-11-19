# 村子地面（[villageart] 新畫風：蠟筆＋日式恐怖漫畫；暗赭褐泥地、密集排線、螺旋紋、暗灰綠草、深紫黑陰影）
# 只畫一次：由 village.gd 拍成貼圖；nv_village 用預烘嘅 res://assets/img/village_ground.webp
#（重烘：edtest.sh godot va res://tools/tests/villageart_test.gd bake）
# 位置照舊：石板路（x 160–232 直路、y 678／932 橫路）、稻田水塘 (222,388,154,146)、槐樹林 (100,455)
extends Node2D

var POS = {}
const W := 390.0
const WH := 1130.0
# [village2] ext = true：畫拓展區（村尾 WH 以下）嘅地面，同一套筆觸、底紋相位接得上（無縫）；HH = 高度；Y0 = 世界 y 起點
var ext := false
var HH := WH
var Y0 := 0.0
var seed = 7
var _tile: Texture2D

func R() -> float:
	seed = (seed * 16807) % 2147483647
	return float(seed) / 2147483647.0

func _c(h: String, a := 1.0) -> Color: return Color(Color(h), a)

func _draw() -> void:
	seed = 7 if not ext else 9173
	if ext: _draw_ext(); return
	var S2 = Transform2D(Vector2(2, 0), Vector2(0, 2), Vector2.ZERO)
	var x = Ctx.new(self, S2)
	# 1. 泥地底：參考背景截出嚟嘅可平鋪蠟筆泥地（vg_ground_tile）；冇圖就用純色
	draw_rect(Rect2(0, 0, W * 2, WH * 2), _c("#4a3424"))
	var tile: Texture2D = _tile   # 要留住引用：_draw 完咗貼圖俾人釋放就會畫成白色
	if tile == null and ResourceLoader.exists("res://assets/spr/vg_ground_tile.png"): tile = load("res://assets/spr/vg_ground_tile.png")
	_tile = tile
	if tile:   # 逐格貼（唔靠 texture_repeat，GL 相容模式都穩）
		var ts = tile.get_size() * 2.0
		for gy in int(ceil(WH * 2 / ts.y)):
			for gx in int(ceil(W * 2 / ts.x)): draw_texture_rect(tile, Rect2(Vector2(gx, gy) * ts, ts), false, Color(1.0, 0.98, 0.9))
	# 2. 大片光暗（低頻）：赭褐亮塊／深紫黑陰影塊，打散平鋪感
	for i in 50:   # [village2] 由 y 0 起（出村門外都係同一種泥地）
		var px = R() * W; var py = R() * WH; var r = 40 + R() * 70
		var col = _c("#6b4a30", 0.16) if R() < 0.45 else _c("#160c14", 0.22)
		x.fillStyle = col; x.beginPath(); x.ellipse(px, py, r * 1.5, r, -0.4, 0, TAU); x.fill()
	# 3. [village2] 頂部（出村門外）原本係深紫黑＋極暗紅楔形（門後暗紅長方形）——合一地圖之後門外係大排檔區，
	#    呢段要同村子同一種泥地，唔再畫（老闆截圖「門下一大片暗紫黑、門後一塊暗紅長方形」嘅根本原因）
	# 4. 槐樹林：暗綠黑腐葉地
	var gg = x.createRadialGradient(100, 455, 10, 100, 455, 120); gg.addColorStop(0, "rgba(12,10,14,.62)"); gg.addColorStop(0.7, "rgba(14,14,14,.4)"); gg.addColorStop(1, "rgba(14,14,14,0)")
	x.fillStyle = gg; x.beginPath(); x.ellipse(100, 455, 120, 100, 0, 0, TAU); x.fill()
	var lc = ["#2a2c1c", "#33281a", "#242c22", "#2c1e18"]
	for i in 110:
		var a = R() * TAU; var d = R(); x.fillStyle = lc[i % 4]; x.beginPath(); x.ellipse(100 + cos(a) * 100 * d, 455 + sin(a) * 80 * d, 2.4, 1.2, R() * 3, 0, TAU); x.fill()
	# 5. [village2] 稻田：原本係一整塊 154×146 黑水（#0e1312，稻田之間露出「一整塊深色」）→ 改做濕泥地：
	#    淡淡一層深啲嘅泥（軟邊）＋田埂＋幾條水光；每格稻田自己有泥框（paddy 圖），唔再有實色方塊
	var wet = x.createRadialGradient(299, 461, 20, 299, 461, 105); wet.addColorStop(0, "rgba(20,14,12,.30)"); wet.addColorStop(0.75, "rgba(20,14,12,.16)"); wet.addColorStop(1, "rgba(20,14,12,0)")
	x.fillStyle = wet; x.beginPath(); x.ellipse(299, 461, 112, 92, 0, 0, TAU); x.fill()
	for py in [437, 487]:   # 田埂（橫）
		x.fillStyle = "rgba(107,74,48,.16)"; x.beginPath(); x.ellipse(299, py, 76, 3.2, 0, 0, TAU); x.fill()
	x.fillStyle = "rgba(107,74,48,.14)"; x.beginPath(); x.ellipse(293, 461, 3.2, 68, 0, 0, TAU); x.fill()   # 田埂（直）
	x.strokeStyle = "rgba(120,150,140,.10)"; x.lineWidth = 1
	for i in 5:
		var wy = 400 + i * 30 + R() * 8; var wx = 232 + R() * 120
		x.beginPath(); x.moveTo(wx, wy); x.quadraticCurveTo(wx + 8, wy - 1.5, wx + 16, wy); x.stroke()
	# 6. 建築底：唔再畫淺色地台，只係一圈深色泥（血霧喺 village_style 即時畫）
	for id in POS:
		if id == "gate": continue
		var b: Array = POS[id]; var w = 74.0 if id == "house" else (28.0 if id == "furnace" else 52.0)
		x.fillStyle = "rgba(16,8,10,.28)"; x.beginPath(); x.ellipse(b[0], b[1] - 2, w, 15, 0, 0, TAU); x.fill()
	# 7. 草（暗灰綠，一叢叢）：先畫，石板路蓋上面
	var tuft = func(tx: float, ty: float, big: bool) -> void:
		var gc = ["#2c3628", "#36412f", "#283024", "#3c4434"]
		var n = 7 if big else 4
		for k in n:
			x.strokeStyle = gc[int(R() * 4)]; x.lineWidth = 1.3 if big else 1.0
			var bx = tx + (k - n / 2.0) * (2.0 if big else 1.6); var h = (8 + R() * 9) if big else (4 + R() * 5)
			x.beginPath(); x.moveTo(bx, ty); x.quadraticCurveTo(bx + (R() - 0.5) * 3, ty - h * 0.6, bx + (k - n / 2.0) * 1.8 + (R() - 0.5) * 3, ty - h); x.stroke()
	var grass_ok = func(tx: float, ty: float) -> bool:
		if tx > 156 and tx < 236: return false
		if tx > 222 and tx < 376 and ty > 392 and ty < 530 and fmod(tx * 7.3 + ty, 5.0) > 1.2: return false   # [village2] 稻田：疏啲草，唔係完全冇
		if absf(ty - 690) < 16 or absf(ty - 942) < 16: return false
		return true
	for i in 70:   # 草叢團（參考圖：泥地區之間嘅草邊）
		var cx = R() * W; var cy = 10 + R() * (WH - 10)
		for k in 6:
			var tx = cx + (R() - 0.5) * 34; var ty = cy + (R() - 0.5) * 12
			if grass_ok.call(tx, ty): tuft.call(tx, ty, R() < 0.5)
	for i in 260:
		var tx = R() * W; var ty = 4 + R() * (WH - 4)
		if grass_ok.call(tx, ty): tuft.call(tx, ty, false)
	# 8. 石板路：暗石＋裂紋＋刻螺旋（同舊版一樣嘅格）
	var slabc = ["#2b2729", "#272325", "#302a2b", "#24201f"]
	var slab = func(sx: float, sy: float, w: float, h: float) -> void:
		var j = (R() - 0.5) * 2
		x.fillStyle = "rgba(8,4,8,.55)"; x.beginPath(); x.roundRect(sx + j - 0.5, sy + 0.5, w - 1, h - 1, 3); x.fill()
		x.fillStyle = slabc[int(floor(R() * 4))]; x.beginPath(); x.roundRect(sx + j, sy, w - 2, h - 2, 3); x.fill()
		x.fillStyle = "rgba(107,74,48,.10)"; x.fillRect(sx + j + 2, sy + 1, w - 6, 1.2)
		x.fillStyle = "rgba(0,0,0,.45)"; x.fillRect(sx + j, sy + h - 3, w - 2, 1.5)
		var r0 = R()
		if r0 < 0.42:   # 裂紋
			x.strokeStyle = "rgba(10,6,8,.85)"; x.lineWidth = 0.7
			var px = sx + j + 3 + R() * (w - 8); var py = sy + 1.5
			x.beginPath(); x.moveTo(px, py)
			for k in 3:
				px += (R() - 0.5) * 7; py += (h - 4) / 3.0; x.lineTo(clampf(px, sx + 1, sx + w - 3), py)
			x.stroke()
		elif r0 < 0.52:   # 刻螺旋
			var ccx = sx + j + w / 2 - 1; var ccy = sy + h / 2 - 1
			x.strokeStyle = "rgba(12,6,10,.7)"; x.lineWidth = 0.6; x.beginPath()
			for k in 26:
				var a = k * 0.42; var rr = 0.4 + k * 0.17
				if k == 0: x.moveTo(ccx + cos(a) * rr, ccy + sin(a) * rr)
				else: x.lineTo(ccx + cos(a) * rr, ccy + sin(a) * rr)
			x.stroke()
	var y = -4.0   # [village2] 石板路一直去到地圖頂（出村門外接大排檔區），格線對齊 WH（拓展區由 WH 起接落去）
	while y < WH:
		var off = 0.0 if fmod(y / 18.0, 2.0) != 0.0 else 12.0
		slab.call(172 - off / 2, y, 24 + off / 2, 18); slab.call(196 + (0.0 if off else -6.0), y, 24 - (0.0 if off else -6.0), 18)
		y += 18
	for ry in [678, 932]:
		var xx = 0.0
		while xx < W:
			if not (xx > 160 and xx < 222): slab.call(xx, ry, 22, 11); slab.call(xx + 11, ry + 11, 22, 11)
			xx += 22
	# 9. 泥地上嘅螺旋紋＋龜裂（恐怖漫畫感，淡淡地）
	for i in 16:
		var sx2 = R() * W; var sy2 = 30 + R() * (WH - 50)
		if (sx2 > 150 and sx2 < 242) or (sx2 > 212 and sy2 > 378 and sy2 < 546): continue
		x.strokeStyle = "rgba(14,8,10,.38)"; x.lineWidth = 0.8; x.beginPath()
		var turns = 2.2 + R() * 1.5; var rmax = 7 + R() * 9; var a0 = R() * TAU
		for k in 40:
			var f = k / 39.0; var a = a0 + f * turns * TAU
			var p = Vector2(sx2 + cos(a) * rmax * f, sy2 + sin(a) * rmax * f * 0.6)
			if k == 0: x.moveTo(p.x, p.y)
			else: x.lineTo(p.x, p.y)
		x.stroke()
		for k in 3:   # 由螺旋伸出去嘅裂紋
			var a = R() * TAU; var px = sx2 + cos(a) * rmax; var py = sy2 + sin(a) * rmax * 0.6
			x.beginPath(); x.moveTo(px, py)
			for m in 3: px += cos(a) * 6 + (R() - 0.5) * 5; py += sin(a) * 3.5 + (R() - 0.5) * 4; x.lineTo(px, py)
			x.stroke()
	# 10. 蠟筆密集排線（斜 -0.6 rad，同參考圖一樣嘅筆觸方向）＋少量交叉排線喺陰影
	var sc = [_c("#6b4a30", 0.20), _c("#4a3424", 0.26), _c("#2a1a14", 0.26), _c("#3a3a2c", 0.12), _c("#1e1222", 0.22), _c("#7a5638", 0.10)]
	for i in 19500:
		var px = R() * W; var py = -8 + R() * (WH + 8); var ln = 3 + R() * 7; var a = -0.6 + (R() - 0.5) * 0.3
		var c = sc[int(floor(R() * sc.size()))]; var lw = 0.5 + R() * 1.0
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, c, lw * 2, true)
	for i in 3800:
		var px = R() * W; var py = -6 + R() * (WH + 6); var ln = 3 + R() * 5; var a = 0.7 + (R() - 0.5) * 0.3
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, _c("#140a12", 0.16), 1.4, true)
	# 11. 紙紋顆粒
	for i in 6000:
		var c2 = _c("#e6d2b0", 0.05) if R() < 0.55 else _c("#000000", 0.2)
		var rx = R() * W; var ry2 = R() * WH; var rw = 0.5 + R() * 0.9; var rh = 0.5 + R() * 0.9
		draw_rect(Rect2(rx * 2, ry2 * 2, rw * 2, rh * 2), c2)
	# 12. 兩邊深紫黑（夜色暗角喺 village_style 即時畫，呢度只壓兩邊）
	var vg = x.createLinearGradient(0, 0, W, 0); vg.addColorStop(0, "rgba(14,6,18,.55)"); vg.addColorStop(0.14, "rgba(14,6,18,0)"); vg.addColorStop(0.86, "rgba(14,6,18,0)"); vg.addColorStop(1, "rgba(14,6,18,.55)")
	x.fillStyle = vg; x.fillRect(0, 0, W, WH)

# ================= [village2] 拓展區地面（村尾 WH 以下）=================
# 同村子同一套：泥地平鋪（相位接 WH）、光暗塊、草叢、石板路（x 172–220，格線由 WH 起每 18 一格，同上面對齊）、
# 螺旋龜裂、蠟筆排線、紙紋、兩邊深紫黑。冇稻田／槐樹林／建築底。
func _draw_ext() -> void:
	var S2 = Transform2D(Vector2(2, 0), Vector2(0, 2), Vector2.ZERO)
	var x = Ctx.new(self, S2)
	var H = HH
	draw_rect(Rect2(0, 0, W * 2, H * 2), _c("#4a3424"))
	var tile: Texture2D = _tile
	if tile == null and ResourceLoader.exists("res://assets/spr/vg_ground_tile.png"): tile = load("res://assets/spr/vg_ground_tile.png")
	_tile = tile
	if tile:
		var ts = tile.get_size() * 2.0
		var ph = fmod(Y0 * 2.0, ts.y)   # 平鋪相位：同村子貼圖嘅格接得上
		var gy = 0
		while -ph + gy * ts.y < H * 2:
			for gx in int(ceil(W * 2 / ts.x)): draw_texture_rect(tile, Rect2(Vector2(gx * ts.x, -ph + gy * ts.y), ts), false, Color(1.0, 0.98, 0.9))
			gy += 1
	var n_blob = int(50.0 * H / WH)
	for i in n_blob:
		var px = R() * W; var py = R() * H; var r = 40 + R() * 70
		var col = _c("#6b4a30", 0.16) if R() < 0.45 else _c("#160c14", 0.22)
		x.fillStyle = col; x.beginPath(); x.ellipse(px, py, r * 1.5, r, -0.4, 0, TAU); x.fill()
	var tuft = func(tx: float, ty: float, big: bool) -> void:
		var gc = ["#2c3628", "#36412f", "#283024", "#3c4434"]
		var n = 7 if big else 4
		for k in n:
			x.strokeStyle = gc[int(R() * 4)]; x.lineWidth = 1.3 if big else 1.0
			var bx = tx + (k - n / 2.0) * (2.0 if big else 1.6); var h = (8 + R() * 9) if big else (4 + R() * 5)
			x.beginPath(); x.moveTo(bx, ty); x.quadraticCurveTo(bx + (R() - 0.5) * 3, ty - h * 0.6, bx + (k - n / 2.0) * 1.8 + (R() - 0.5) * 3, ty - h); x.stroke()
	var grass_ok = func(tx: float, ty: float) -> bool: return not (tx > 156 and tx < 236)
	for i in int(70.0 * H / WH):
		var cx = R() * W; var cy = 6 + R() * (H - 6)
		for k in 6:
			var tx = cx + (R() - 0.5) * 34; var ty = cy + (R() - 0.5) * 12
			if grass_ok.call(tx, ty): tuft.call(tx, ty, R() < 0.5)
	for i in int(260.0 * H / WH):
		var tx = R() * W; var ty = 4 + R() * (H - 4)
		if grass_ok.call(tx, ty): tuft.call(tx, ty, false)
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
	var y = 0.0
	while y < H:
		slab.call(172, y, 24, 18); slab.call(196, y, 24, 18)
		y += 18
	for i in int(16.0 * H / WH):
		var sx2 = R() * W; var sy2 = 20 + R() * (H - 40)
		if sx2 > 150 and sx2 < 242: continue
		x.strokeStyle = "rgba(14,8,10,.38)"; x.lineWidth = 0.8; x.beginPath()
		var turns = 2.2 + R() * 1.5; var rmax = 7 + R() * 9; var a0 = R() * TAU
		for k in 40:
			var f = k / 39.0; var a = a0 + f * turns * TAU
			var p = Vector2(sx2 + cos(a) * rmax * f, sy2 + sin(a) * rmax * f * 0.6)
			if k == 0: x.moveTo(p.x, p.y)
			else: x.lineTo(p.x, p.y)
		x.stroke()
	var sc = [_c("#6b4a30", 0.20), _c("#4a3424", 0.26), _c("#2a1a14", 0.26), _c("#3a3a2c", 0.12), _c("#1e1222", 0.22), _c("#7a5638", 0.10)]
	for i in int(19500.0 * H / WH):
		var px = R() * W; var py = -8 + R() * (H + 8); var ln = 3 + R() * 7; var a = -0.6 + (R() - 0.5) * 0.3
		var c = sc[int(floor(R() * sc.size()))]; var lw = 0.5 + R() * 1.0
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, c, lw * 2, true)
	for i in int(3800.0 * H / WH):
		var px = R() * W; var py = -6 + R() * (H + 6); var ln = 3 + R() * 5; var a = 0.7 + (R() - 0.5) * 0.3
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, _c("#140a12", 0.16), 1.4, true)
	for i in int(6000.0 * H / WH):
		var c2 = _c("#e6d2b0", 0.05) if R() < 0.55 else _c("#000000", 0.2)
		var rx = R() * W; var ry2 = R() * H; var rw = 0.5 + R() * 0.9; var rh = 0.5 + R() * 0.9
		draw_rect(Rect2(rx * 2, ry2 * 2, rw * 2, rh * 2), c2)
	var vg = x.createLinearGradient(0, 0, W, 0); vg.addColorStop(0, "rgba(14,6,18,.55)"); vg.addColorStop(0.14, "rgba(14,6,18,0)"); vg.addColorStop(0.86, "rgba(14,6,18,0)"); vg.addColorStop(1, "rgba(14,6,18,.55)")
	x.fillStyle = vg; x.fillRect(0, 0, W, H)
	# 接縫：將村子地面最底 BLEND 行上下反轉、由實到透鋪喺拓展區頂 → 第一行同村子最後一行一樣（石板路格線本身已對齊，唔使混）
	if join_tex != null:
		var BLEND := 70.0; var n = 35; var d = BLEND / n
		var k = join_tex.get_height() / WH
		for j in n:
			var v = j * d; var f = 1.0 - (v + d * 0.5) / BLEND; var a = f * f * (3.0 - 2.0 * f)
			for seg in [[0.0, 162.0], [230.0, W]]:
				var sx0: float = seg[0]; var sx1: float = seg[1]
				draw_set_transform(Vector2(0, (v + d) * 2), 0, Vector2(1, -1))   # 上下反轉（唔靠負高度矩形）
				draw_texture_rect_region(join_tex, Rect2(sx0 * 2, 0, (sx1 - sx0) * 2, d * 2 + 0.5), Rect2(sx0 * k, (WH - v - d) * k, (sx1 - sx0) * k, d * k), Color(1, 1, 1, a))
		draw_set_transform_matrix(Transform2D.IDENTITY)
var join_tex: Texture2D = null   # [village2] 村子地面（烘拓展區時用嚟做接縫漸變）
