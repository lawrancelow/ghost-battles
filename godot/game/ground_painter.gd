# 村子地面（移植 game.js groundLayer）：只畫一次，由 village.gd 拍成貼圖
extends Node2D

var POS = {}
const W := 390.0
const WH := 1130.0
var seed = 7

func R() -> float:
	seed = (seed * 16807) % 2147483647
	return float(seed) / 2147483647.0

func _draw() -> void:
	var x = Ctx.new(self, Transform2D(Vector2(2, 0), Vector2(0, 2), Vector2.ZERO))
	seed = 7
	var gr = x.createLinearGradient(0, 0, 0, WH); gr.addColorStop(0, "#140f12"); gr.addColorStop(0.13, "#211b19"); gr.addColorStop(0.5, "#26201b"); gr.addColorStop(1, "#221d1a")
	x.fillStyle = gr; x.fillRect(0, 0, W, WH)
	var hr = x.createLinearGradient(0, 0, 0, 160); hr.addColorStop(0, "rgba(110,30,30,.55)"); hr.addColorStop(1, "rgba(70,30,30,0)")
	x.fillStyle = hr; x.beginPath(); x.moveTo(160, 0); x.lineTo(230, 0); x.lineTo(246, 160); x.lineTo(144, 160); x.fill()
	for i in 700:
		var px = R() * W; var py = 140 + R() * (WH - 140); var r = 2 + R() * 9
		x.fillStyle = "rgba(255,240,210,.025)" if R() < 0.5 else "rgba(0,0,0,.12)"; x.beginPath(); x.ellipse(px, py, r * 1.6, r, 0, 0, 6.3); x.fill()
	x.fillStyle = "rgba(20,30,22,.55)"; x.beginPath(); x.ellipse(100, 455, 110, 92, 0, 0, 6.3); x.fill()
	var lc = ["#3a3a20", "#4a3a1c", "#2e3a26"]
	for i in 90:
		var a = R() * 6.3; var d = R(); x.fillStyle = lc[i % 3]; x.beginPath(); x.ellipse(100 + cos(a) * 100 * d, 455 + sin(a) * 80 * d, 2.2, 1.2, R() * 3, 0, 6.3); x.fill()
	x.fillStyle = "#18221f"; x.fillRect(222, 388, 154, 146)
	x.fillStyle = "rgba(70,100,95,.18)"
	for i in 3: x.fillRect(222, 388 + i * 50 + 34, 154, 4)
	x.strokeStyle = "#3a3a2c"; x.lineWidth = 3; x.strokeRect(222, 388, 154, 146)
	for id in POS:
		if id == "gate": continue
		var b: Array = POS[id]; var w = 80.0 if id == "house" else (30.0 if id == "furnace" else 56.0)
		x.fillStyle = "rgba(60,48,36,.35)"; x.beginPath(); x.ellipse(b[0], b[1] - 4, w, 16, 0, 0, 6.3); x.fill()
	var slabc = ["#3c3a3e", "#36363a", "#413e40"]
	var slab = func(sx: float, sy: float, w: float, h: float) -> void:
		var j = (R() - 0.5) * 2; x.fillStyle = slabc[int(floor(R() * 3))]; x.beginPath(); x.roundRect(sx + j, sy, w - 2, h - 2, 3); x.fill()
		x.fillStyle = "rgba(255,255,255,.05)"; x.fillRect(sx + j + 2, sy + 1, w - 6, 1.5); x.fillStyle = "rgba(0,0,0,.35)"; x.fillRect(sx + j, sy + h - 3, w - 2, 1.5)
	var y = 150.0
	while y < WH:
		var off = 0.0 if fmod(y / 18.0, 2.0) != 0.0 else 12.0   # 同網頁版一樣用浮點取餘
		slab.call(172 - off / 2, y, 24 + off / 2, 18); slab.call(196 + (0.0 if off else -6.0), y, 24 - (0.0 if off else -6.0), 18)
		y += 18
	for ry in [678, 932]:
		var xx = 0.0
		while xx < W:
			if not (xx > 160 and xx < 222): slab.call(xx, ry, 22, 11); slab.call(xx + 11, ry + 11, 22, 11)
			xx += 22
	var tuft = func(tx: float, ty: float) -> void:
		x.strokeStyle = "#34463a" if R() < 0.5 else "#3e5040"; x.lineWidth = 1.3
		for k in range(-2, 3):
			x.beginPath(); x.moveTo(tx + k * 1.6, ty); x.quadraticCurveTo(tx + k * 2.2, ty - 4, tx + k * 3 + (R() - 0.5) * 2, ty - 6 - R() * 4); x.stroke()
	for i in 220:
		var tx = R() * W; var ty = 150 + R() * (WH - 150)
		if tx > 160 and tx < 230: continue
		if tx > 218 and ty > 384 and ty < 538: continue
		if absf(ty - 690) < 16 or absf(ty - 942) < 16: continue
		tuft.call(tx, ty)
	var vg = x.createLinearGradient(0, 0, W, 0); vg.addColorStop(0, "rgba(0,0,0,.35)"); vg.addColorStop(0.12, "rgba(0,0,0,0)"); vg.addColorStop(0.88, "rgba(0,0,0,0)"); vg.addColorStop(1, "rgba(0,0,0,.35)")
	var sc = ["rgba(120,92,62,.16)", "rgba(70,56,40,.22)", "rgba(150,120,80,.10)", "rgba(60,80,58,.14)", "rgba(20,14,10,.22)"]
	x.lineCap = "round"
	# 蠟筆短筆觸：直接用 draw_line（一萬六千筆，唔經 Ctx 路徑，快好多）
	for i in 16000:
		var px = R() * W; var py = 120 + R() * (WH - 120); var ln = 3 + R() * 7; var a = -0.6 + (R() - 0.5) * 0.35
		var c = Ctx.col(sc[int(floor(R() * sc.size()))]); var lw = 0.6 + R() * 1.1
		draw_line(Vector2(px, py) * 2, Vector2(px + cos(a) * ln, py + sin(a) * ln) * 2, c, lw * 2, true)
	for i in 5000:
		var c2 = Ctx.col("rgba(235,220,190,.07)" if R() < 0.6 else "rgba(0,0,0,.18)")
		var rx = R() * W; var ry2 = R() * WH; var rw = 0.5 + R() * 0.9; var rh = 0.5 + R() * 0.9
		draw_rect(Rect2(rx * 2, ry2 * 2, rw * 2, rh * 2), c2)
	x.fillStyle = vg; x.fillRect(0, 0, W, WH)
