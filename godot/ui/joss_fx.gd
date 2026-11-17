# 化寶爐：金銀紙滿屏特效（原生改寫自 game.js JossFx.play）
# 爐口噴出一大把金紙／銀紙（翻面、旋轉、左右飄），天上再落一陣，加火星；2.8 秒後自己消失。
# 用法：JossFxN.play(main)（bridge.connect_ui 將 JS 嘅 JossFx.play 接過嚟）
class_name JossFxN
extends Control

const T := 2.8
var P: Array = []
var S2: Array = []
var el := 0.0
var ox := 0.0
var oy := 0.0
var sz := 1.0

static var cur: JossFxN = null

static func play(main: Node) -> void:
	if main == null: return
	if cur != null and is_instance_valid(cur): cur.queue_free()
	var n := JossFxN.new()
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE; n.z_index = 65; n.top_level = true
	main.add_child(n)
	n._setup(main)
	cur = n

func _setup(main: Node) -> void:
	var vs: Vector2 = get_viewport_rect().size
	position = Vector2.ZERO; size = vs
	var vw = vs.x; var vh = vs.y
	# 爐喺畫面上嘅位置（俾面板擋住都照樣由嗰度噴出嚟）
	ox = vw * 0.8; oy = vh * 0.55
	var v = main.get("village")
	var V = J.G.get("Village"); var POS = J.G.get("POS")
	if v is Control and V is Dictionary and POS is Dictionary and POS.has("furnace"):
		var sc = float(v.get("sc")) if v.get("sc") != null else 1.0
		var fp = POS.furnace
		ox = v.global_position.x + J.num(fp[0]) * sc; oy = v.global_position.y + (J.num(fp[1]) - 40 - J.num(V.get("camY", 0.0))) * sc
	ox = maxf(30, minf(vw - 30, ox)); oy = maxf(vh * 0.25, minf(vh * 0.8, oy))
	var N = 140 if vw < 500 else 170
	sz = maxf(vw, vh) / 844
	for i in N:
		var burst = i < N * 0.55; var gold = randf() < 0.6; var w = (16 + randf() * 12) * sz
		var p = {"gold": gold, "w": w, "h": w * (0.72 + randf() * 0.14), "rot": randf() * 6.3, "vr": (randf() - 0.5) * 7, "fl": randf() * 6.3, "vf": 4 + randf() * 8, "sw": randf() * 6.3, "vs": 1.5 + randf() * 2.5, "delay": 0.0}
		if burst:
			var ang = -PI / 2 + (randf() - 0.5) * 1.9; var sp = (420 + randf() * 520) * sz
			p["x"] = ox; p["y"] = oy; p["vx"] = cos(ang) * sp; p["vy"] = sin(ang) * sp; p["delay"] = randf() * 0.3
		else:
			p["x"] = randf() * vw; p["y"] = -30 - randf() * vh * 0.25; p["vx"] = (randf() - 0.5) * 60; p["vy"] = 320 + randf() * 160; p["delay"] = randf() * 0.5
		p["term"] = 300 + randf() * 160
		P.append(p)
	for i in 46: S2.append({"x": ox + (randf() - 0.5) * 60, "y": oy, "vx": (randf() - 0.5) * 500 * sz, "vy": -(200 + randf() * 700) * sz, "life": 0.6 + randf() * 0.9, "t": 0.0, "d": randf() * 0.5})

func _process(delta: float) -> void:
	var dt = minf(0.05, delta)
	el += delta
	if el >= T:
		if cur == self: cur = null
		queue_free(); return
	var vh = size.y
	for p in P:
		if el < p.delay: continue
		p.vx *= pow(0.35, dt); p.vy += 520 * sz * dt; var term = p.term * sz
		if p.vy > term: p.vy += (term - p.vy) * minf(1, dt * 4)
		p.sw += p.vs * dt; p.x += (p.vx + sin(p.sw) * 70 * sz) * dt; p.y += p.vy * dt; p.rot += p.vr * dt; p.fl += p.vf * dt
	for s in S2:
		if el < s.d: continue
		s.t += dt
		if s.t > s.life: continue
		s.vy += 600 * sz * dt; s.x += s.vx * dt; s.y += s.vy * dt
	queue_redraw()

func _paper(p: Dictionary, a: float) -> void:
	var w: float = p.w; var h: float = p.h; var sx = cos(p.fl)
	var back = sx < 0; var shade = 0.75 + 0.25 * absf(sx)
	# 翻面 = x 方向縮放（scale(sx,1)）：用矩陣畫
	var X = Transform2D(p.rot, Vector2(p.x, p.y)) * Transform2D(Vector2(sx, 0), Vector2(0, 1), Vector2.ZERO)
	draw_set_transform_matrix(X)
	var face: Color; var line: Color; var mark: Color
	if p.gold:
		face = Color8(int(190 * shade), int(140 * shade), int(50 * shade)) if back else Color8(int(236 * shade), int(188 * shade), int(70 * shade))
		line = Color(140 / 255.0, 80 / 255.0, 10 / 255.0, 0.7); mark = Color("#c8281c")
	else:
		face = Color8(int(170 * shade), int(172 * shade), int(178 * shade)) if back else Color8(int(226 * shade), int(228 * shade), int(234 * shade))
		line = Color(90 / 255.0, 95 / 255.0, 110 / 255.0, 0.6); mark = Color("#7d828f")
	face.a = a; line.a *= a; mark.a = a
	draw_rect(Rect2(-w / 2, -h / 2, w, h), face)
	draw_rect(Rect2(-w / 2 + 1.5, -h / 2 + 1.5, w - 3, h - 3), line, false, 1.0)
	if not back:
		var q = h * 0.42
		draw_rect(Rect2(-q / 2, -q / 2, q, q), mark)
		if p.gold: draw_rect(Rect2(-q / 5, -q / 5, q * 0.4, q * 0.4), Color(1, 220 / 255.0, 120 / 255.0, 0.85 * a))

func _draw() -> void:
	var vh = size.y
	var fade = maxf(0, (T - el) / 0.6) if el > T - 0.6 else 1.0
	if el < 0.5:   # 爐口一閃（徑向光）
		var r = 160 * sz; var k = 0.55 * (1 - el / 0.5)
		for i in 8:
			var f = 1.0 - i / 8.0
			draw_circle(Vector2(ox, oy), r * f, Color(1, (200 - 80 * (1 - f)) / 255.0, (90 - 60 * (1 - f)) / 255.0, k / 8.0))
	for p in P:
		if el < p.delay or p.y >= vh + 40: continue
		_paper(p, fade)
	draw_set_transform_matrix(Transform2D.IDENTITY)
	# 火星（疊加光）
	for s in S2:
		if el < s.d or s.t > s.life: continue
		var k = 1 - s.t / s.life; var r = 2 + 3 * k; var c = Color(1, 242 / 255.0, 176 / 255.0, k)
		draw_colored_polygon(PackedVector2Array([Vector2(s.x, s.y - r * 2), Vector2(s.x + r * 0.5, s.y), Vector2(s.x, s.y + r * 2), Vector2(s.x - r * 0.5, s.y)]), c)
		draw_rect(Rect2(s.x - r * 2, s.y - 0.6, r * 4, 1.2), c)
