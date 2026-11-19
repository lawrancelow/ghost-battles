# 村子地面（[villageart] 新畫風：蠟筆＋日式恐怖漫畫；暗赭褐泥地、密集排線、螺旋紋、暗灰綠草、深紫黑陰影）
# 只畫一次：由 village.gd 拍成貼圖；nv_village 用預烘嘅 res://assets/img/village_ground.webp
#（重烘：edtest.sh godot va res://tools/tests/villageart_test.gd bake）
# 位置照舊：石板路（x 160–232 直路、y 678／932 橫路）、稻田水塘 (222,388,154,146)、槐樹林 (100,455)
extends Node2D

var POS = {}
const W := 390.0
const WH := 1130.0
var seed = 7
var _tile: Texture2D

func R() -> float:
	seed = (seed * 16807) % 2147483647
	return float(seed) / 2147483647.0

func _c(h: String, a := 1.0) -> Color: return Color(Color(h), a)

func _draw() -> void:
	seed = 7
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
	for i in 46:
		var px = R() * W; var py = 120 + R() * (WH - 120); var r = 40 + R() * 70
		var col = _c("#6b4a30", 0.16) if R() < 0.45 else _c("#160c14", 0.22)
		x.fillStyle = col; x.beginPath(); x.ellipse(px, py, r * 1.5, r, -0.4, 0, TAU); x.fill()
	# 3. 頂部（出村門外）：深紫黑＋極暗紅霧
	var gr = x.createLinearGradient(0, 0, 0, 200); gr.addColorStop(0, "rgba(14,6,16,1)"); gr.addColorStop(0.55, "rgba(22,10,20,.85)"); gr.addColorStop(1, "rgba(22,10,20,0)")
	x.fillStyle = gr; x.fillRect(0, 0, W, 200)
	var hr = x.createLinearGradient(0, 0, 0, 170); hr.addColorStop(0, "rgba(32,2,1,.75)"); hr.addColorStop(1, "rgba(7,0,0,0)")
	x.fillStyle = hr; x.beginPath(); x.moveTo(150, 0); x.lineTo(240, 0); x.lineTo(256, 170); x.lineTo(134, 170); x.fill()
	# 4. 槐樹林：暗綠黑腐葉地
	var gg = x.createRadialGradient(100, 455, 10, 100, 455, 120); gg.addColorStop(0, "rgba(12,10,14,.62)"); gg.addColorStop(0.7, "rgba(14,14,14,.4)"); gg.addColorStop(1, "rgba(14,14,14,0)")
	x.fillStyle = gg; x.beginPath(); x.ellipse(100, 455, 120, 100, 0, 0, TAU); x.fill()
	var lc = ["#2a2c1c", "#33281a", "#242c22", "#2c1e18"]
	for i in 110:
		var a = R() * TAU; var d = R(); x.fillStyle = lc[i % 4]; x.beginPath(); x.ellipse(100 + cos(a) * 100 * d, 455 + sin(a) * 80 * d, 2.4, 1.2, R() * 3, 0, TAU); x.fill()
	# 5. 稻田水塘：黑水＋暗泥框（位置不變）
	x.fillStyle = "#0e1312"; x.fillRect(222, 388, 154, 146)
	x.fillStyle = "rgba(60,90,80,.10)"
	for i in 3: x.fillRect(222, 388 + i * 50 + 34, 154, 3)
	x.strokeStyle = "#241a14"; x.lineWidth = 4; x.strokeRect(222, 388, 154, 146)
	x.strokeStyle = "rgba(107,74,48,.35)"; x.lineWidth = 1; x.strokeRect(220, 386, 158, 150)
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
		if tx > 216 and ty > 382 and ty < 540: return false
		if absf(ty - 690) < 16 or absf(ty - 942) < 16: return false
		return true
	for i in 70:   # 草叢團（參考圖：泥地區之間嘅草邊）
		var cx = R() * W; var cy = 170 + R() * (WH - 170)
		for k in 6:
			var tx = cx + (R() - 0.5) * 34; var ty = cy + (R() - 0.5) * 12
			if grass_ok.call(tx, ty): tuft.call(tx, ty, R() < 0.5)
	for i in 260:
		var tx = R() * W; var ty = 150 + R() * (WH - 150)
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
	var y = 150.0
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
		var sx2 = R() * W; var sy2 = 200 + R() * (WH - 220)
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
	for i in 18000:
		var px = R() * W; var py = 120 + R() * (WH - 120); var ln = 3 + R() * 7; var a = -0.6 + (R() - 0.5) * 0.3
		var c = sc[int(floor(R() * sc.size()))]; var lw = 0.5 + R() * 1.0
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, c, lw * 2, true)
	for i in 3500:
		var px = R() * W; var py = 120 + R() * (WH - 120); var ln = 3 + R() * 5; var a = 0.7 + (R() - 0.5) * 0.3
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, _c("#140a12", 0.16), 1.4, true)
	# 11. 紙紋顆粒
	for i in 6000:
		var c2 = _c("#e6d2b0", 0.05) if R() < 0.55 else _c("#000000", 0.2)
		var rx = R() * W; var ry2 = R() * WH; var rw = 0.5 + R() * 0.9; var rh = 0.5 + R() * 0.9
		draw_rect(Rect2(rx * 2, ry2 * 2, rw * 2, rh * 2), c2)
	# 12. 兩邊深紫黑（夜色暗角喺 village_style 即時畫，呢度只壓兩邊）
	var vg = x.createLinearGradient(0, 0, W, 0); vg.addColorStop(0, "rgba(14,6,18,.55)"); vg.addColorStop(0.14, "rgba(14,6,18,0)"); vg.addColorStop(0.86, "rgba(14,6,18,0)"); vg.addColorStop(1, "rgba(14,6,18,.55)")
	x.fillStyle = vg; x.fillRect(0, 0, W, WH)
