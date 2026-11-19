# [villageart] 原版村子新畫風：調色（樹／稻田／路燈／擺設／出村門）、建築底血霧、整體夜色＋四角暗角
# 只改畫法，唔改任何位置／點擊範圍。用法：
#   nv_village._build() 尾：VS.attach(self)    ← 加血霧層（ysort 之下）＋夜色層（top_ui 之下）
#   core/art.gd 畫樹／稻田／擺設／出村門：Art.tint = VS.tint_for(key)
# 熱更新：冇 class_name、冇 autoload；靠 preload 用
extends RefCounted

# 舊圖（光、偏暖）壓暗調色，貼近參考背景（暗赭褐＋深紫黑）
const TINT := {
	"tree": Color(0.60, 0.52, 0.56), "tree_bare": Color(0.60, 0.52, 0.56), "stump": Color(0.58, 0.50, 0.52),
	"paddy": Color(0.62, 0.58, 0.50), "paddy_cut": Color(0.55, 0.50, 0.46),
	"lamppost": Color(0.70, 0.62, 0.60), "banana": Color(0.50, 0.54, 0.48), "grave": Color(0.52, 0.50, 0.56),
	"scarecrow": Color(0.62, 0.55, 0.55), "gate": Color(0.66, 0.58, 0.60), "crowsit": Color(0.70, 0.66, 0.72),
}
# 血霧色板（老闆指定）：#200201 → #070000
const MIST_A := Color(0x20 / 255.0, 0x02 / 255.0, 0x01 / 255.0)
const MIST_B := Color(0x07 / 255.0, 0.0, 0.0)
const MIST_W := {"house": 150.0, "furnace": 64.0}
const NIGHT := Color(0.06, 0.02, 0.10, 0.16)

static var _mist := {}       # id → [底霧, 霧團, 細絲]
static var _vig: Texture2D

static func tint_for(key: String) -> Color: return TINT.get(key, Color.WHITE)

# ---------------- 掛鈎 ----------------
static func attach(nv) -> void:
	if nv.world == null or nv.world.has_node("va_mist"): return
	var m = Layer.new(); m.name = "va_mist"; m.fn = func(c): draw_mist(c, nv)
	nv.world.add_child(m); nv.world.move_child(m, nv.ysort.get_index())          # 地面之上、建築之下
	var n = Layer.new(); n.name = "va_night"; n.fn = func(c): draw_night(c, nv)
	nv.world.add_child(n); nv.world.move_child(n, nv.top_ui.get_index())         # 泡泡／浮字／箭頭之下

class Layer extends Node2D:
	var fn: Callable
	func _process(_dt: float) -> void:
		if is_visible_in_tree(): queue_redraw()
	func _draw() -> void:
		if fn.is_valid(): fn.call(self)

# ---------------- 血霧 ----------------
static func _hash(s: String) -> int:
	var h := 2166136261
	for ch in s.to_utf8_buffer(): h = ((h ^ ch) * 16777619) & 0x7fffffff
	return h

# 預先畫成貼圖：[0] 地上血漬底霧、[1] 飄動霧團（短蠟筆筆觸）、[2] 上升細絲
static func mist_tex(id: String) -> Array:
	if _mist.has(id): return _mist[id]
	var rng = RandomNumberGenerator.new(); rng.seed = _hash(id)
	var W := 128; var H := 48
	var out = []
	for layer in 3:
		var a = PackedFloat32Array(); a.resize(W * H)
		var tone = PackedFloat32Array(); tone.resize(W * H)
		if layer < 2:
			var blobs = 16 if layer == 0 else 9
			for b in blobs:
				var cx = W * 0.5 + rng.randf_range(-0.40, 0.40) * W; var cy = H * (0.62 if layer == 0 else 0.48) + rng.randf_range(-0.16, 0.16) * H
				var rx = (rng.randf_range(16, 34) if layer == 0 else rng.randf_range(12, 24)) * 0.667; var ry = rx * rng.randf_range(0.32, 0.5)
				var pk = rng.randf_range(0.55, 0.9) if layer == 0 else rng.randf_range(0.4, 0.7)
				for y in range(maxi(0, int(cy - ry)), mini(H, int(cy + ry) + 1)):
					for x in range(maxi(0, int(cx - rx)), mini(W, int(cx + rx) + 1)):
						var d = Vector2((x - cx) / rx, (y - cy) / ry).length()
						if d >= 1.0: continue
						var v = pk * (1.0 - d * d)
						var i = y * W + x; a[i] = 1.0 - (1.0 - a[i]) * (1.0 - v); tone[i] = maxf(tone[i], 1.0 - d)
			# 短蠟筆筆觸（斜線，同地面排線同方向）
			for s in (170 if layer == 0 else 90):
				var sx = rng.randf() * W; var sy = H * 0.3 + rng.randf() * H * 0.65; var ln = rng.randf_range(2, 6); var ang = -0.6 + rng.randf_range(-0.2, 0.2)
				var base = a[clampi(int(sy), 0, H - 1) * W + clampi(int(sx), 0, W - 1)]
				if base < 0.08: continue
				for k in int(ln):
					var px = int(sx + cos(ang) * k); var py = int(sy + sin(ang) * k)
					if px < 0 or px >= W or py < 0 or py >= H: continue
					var i = py * W + px; a[i] = clampf(a[i] + rng.randf_range(0.12, 0.3), 0, 0.95); tone[i] = minf(1.0, tone[i] + 0.3)
		else:
			# 上升細絲：由底向上彎彎曲曲，越高越淡
			for f in 7:
				var x0 = W * 0.5 + rng.randf_range(-0.36, 0.36) * W; var ph = rng.randf() * TAU; var amp = rng.randf_range(1.5, 4)
				for y in range(H - 6, 2, -1):
					var fy = 1.0 - float(y) / H
					var x = int(x0 + sin(ph + fy * 7.0) * amp * (0.4 + fy))
					for dx in [-1, 0, 1]:
						var px = x + dx
						if px < 0 or px >= W: continue
						var i = y * W + px; var v = (0.55 if dx == 0 else 0.22) * (1.0 - fy * 0.9)
						a[i] = maxf(a[i], v); tone[i] = 0.7
		# 邊緣淡出
		var img = Image.create(W, H, false, Image.FORMAT_RGBA8)
		for y in H:
			for x in W:
				var i = y * W + x
				var ex = minf(1.0, minf(x, W - 1 - x) / 10.0) * minf(1.0, minf(y, H - 1 - y) / 5.0)
				var c = MIST_B.lerp(MIST_A, clampf(tone[i] * 1.2, 0, 1))
				img.set_pixel(x, y, Color(c, clampf(a[i] * ex, 0, 1)))
		out.append(ImageTexture.create_from_image(img))
	_mist[id] = out
	return out

static func draw_mist(c: CanvasItem, nv) -> void:
	var S = J.G.get("S"); var POS = J.G.get("POS"); var order = J.G.get("BLD_ORDER")
	if not (S is Dictionary) or POS == null or order == null: return
	var t: float = nv.t; var top: float = nv.cam_y - 60; var bot: float = nv.cam_y + nv.size.y / maxf(0.01, nv.sc) + 60
	var made := false   # 未快取嘅貼圖每幀最多畫一張（唔好一次過卡）
	for id in order:
		if not POS.has(id) or not J.t(S.bld.get(id, 0)): continue
		var p = POS[id]; var x = J.num(p[0]); var y = J.num(p[1])
		if y < top or y > bot: continue
		if not _mist.has(id):
			if made: continue
			made = true
		var tx = mist_tex(id); var w = MIST_W.get(id, 118.0); var h = w * 48.0 / 128.0
		var ph = float(_hash(id) % 1000) * 0.01
		# 底霧：唔郁，透明度慢慢起伏
		c.draw_texture_rect(tx[0], Rect2(x - w / 2, y - h * 0.62 + 4, w, h), false, Color(1, 1, 1, 0.9 + sin(t * 0.7 + ph) * 0.08))
		# 霧團：左右飄
		var dx = sin(t * 0.45 + ph) * 5.0
		c.draw_texture_rect(tx[1], Rect2(x - w / 2 + dx, y - h * 0.66 + 2, w, h), false, Color(1, 1, 1, 0.62 + sin(t * 0.9 + ph * 2) * 0.14))
		c.draw_texture_rect(tx[1], Rect2(x + w / 2 - dx * 0.7, y - h * 0.6 + 4, -w * 0.9, h * 0.9), false, Color(1, 1, 1, 0.4 + cos(t * 0.8 + ph) * 0.12))
		# 細絲：向上升，循環淡入淡出
		for k in 2:
			var f = fmod(t * 0.18 + ph + k * 0.5, 1.0)
			c.draw_texture_rect(tx[2], Rect2(x - w / 2, y - h * 0.8 - f * 22.0, w, h), false, Color(1, 1, 1, sin(f * PI) * 0.75))

# ---------------- 夜色＋四角暗角（只蓋世界，唔蓋 UI 字）----------------
static func vig_tex() -> Texture2D:
	if _vig: return _vig
	var g = Gradient.new()
	# 夜色（NIGHT）同暗角合成一張：每幀只畫一次全屏
	g.set_color(0, NIGHT); g.set_color(1, Color(0.02, 0.0, 0.04, 0.8))
	g.add_point(0.55, NIGHT); g.add_point(0.82, Color(0.04, 0.01, 0.07, 0.4))
	var gt = GradientTexture2D.new(); gt.gradient = g; gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.5); gt.fill_to = Vector2(1.08, 1.08); gt.width = 128; gt.height = 256
	_vig = gt
	return _vig

static func draw_night(c: CanvasItem, nv) -> void:
	var vh: float = nv.size.y / maxf(0.01, nv.sc); var y0: float = nv.cam_y - 4
	var r = Rect2(-4, y0, 398.0, vh + 8)
	c.draw_texture_rect(vig_tex(), r, false)

# ---------------- 槐樹：樹洞臉眼光、樹幹排線暗影、樹枝尾「手指」 ----------------
# r：樹圖實際矩形（世界座標）；flip：圖左右反咗。全部畫喺樹圖範圍內，唔改點擊範圍
const TREE_EYES := [[0.455, 0.525], [0.535, 0.522]]
const TREE_TIPS := [[0.07, 0.50, -1.0], [0.93, 0.47, 1.0], [0.18, 0.12, -1.0], [0.84, 0.16, 1.0], [0.04, 0.27, -1.0], [0.96, 0.30, 1.0]]
static func tree_extra(ctx: Ctx, x: float, y: float, r: Rect2, flip: bool, _t: float) -> void:
	if r.size.x <= 0: return
	var fx = func(u: float) -> float:
		var px = r.position.x + r.size.x * u
		return 2.0 * x - px if flip else px
	var fy = func(v: float) -> float: return r.position.y + r.size.y * v
	ctx.save()
	# 樹幹排線暗影（深紫黑短斜線）
	ctx.strokeStyle = "rgba(18,6,20,.32)"; ctx.lineWidth = 0.8
	var sd = int(absf(x * 7.0 + y * 3.0)) % 97
	for k in 16:
		var u = 0.36 + fmod((k * 37 + sd) * 0.61803, 1.0) * 0.28; var v = 0.56 + fmod((k * 53 + sd) * 0.38197, 1.0) * 0.3
		var px = fx.call(u); var py = fy.call(v)
		ctx.beginPath(); ctx.moveTo(px, py); ctx.lineTo(px + 3.2, py - 2.2); ctx.stroke()
	# 樹枝尾：三條彎彎嘅「手指」
	ctx.strokeStyle = "rgba(22,10,16,.85)"; ctx.lineWidth = 0.9; ctx.lineCap = "round"
	for tp in TREE_TIPS:
		var px = fx.call(tp[0]); var py = fy.call(tp[1]); var dir: float = tp[2] * (-1.0 if flip else 1.0)
		for k in 3:
			var a = (-0.5 + k * 0.5) * 0.8
			var ex = px + dir * cos(a) * 5.5; var ey = py + sin(a) * 5.5 - 1.0
			ctx.beginPath(); ctx.moveTo(px, py); ctx.quadraticCurveTo(px + dir * 3.5, py + sin(a) * 1.5 - 1.5, ex, ey); ctx.stroke()
	ctx.lineCap = "butt"
	# 樹洞入面兩點病態青綠眼光
	for e in TREE_EYES:
		var ex2 = fx.call(e[0]); var ey2 = fy.call(e[1])
		var g = ctx.createRadialGradient(ex2, ey2, 0.3, ex2, ey2, 3.2); g.addColorStop(0, "rgba(150,240,190,.55)"); g.addColorStop(1, "rgba(150,240,190,0)")
		ctx.fillStyle = g; ctx.fillRect(ex2 - 3.2, ey2 - 3.2, 6.4, 6.4)
		ctx.fillStyle = "rgba(200,255,220,.8)"; ctx.beginPath(); ctx.ellipse(ex2, ey2, 0.7, 0.9, 0, 0, TAU); ctx.fill()
	ctx.restore()
