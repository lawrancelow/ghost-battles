# [soul2] 演出：①戰後魂火飛向戰況條 ②招降「入職通知書」③升職演出 ④抄功課「影印戰報」卡（全部 static；冇 class_name）
#   畫法：core/art.gd 墨線（OUT #1a1426 墨邊、紙色底、斜線陰影、硃砂印），全部程序畫；鬼用老闆原圖（全身、按比例縮入框，唔裁切）
#   全部演出：撳一下跳過／收起；唔擋住之後嘅操作（自動收）
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")
const INK := Color("#1a1426")
const PAPER := Color("#f3e6c8")
const PAPER2 := Color("#e6d3a8")
const CINNABAR := Color("#b0281c")
const GOLD := Color("#e8b040")
const SOUL_C := Color("#6fe0c0")
const SEC_C := Color("#9fd4ff")

static var LOG: Array = []
static var last = null      # 最近一個演出節點（測試用）

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)
static func _main(): return Engine.get_main_loop().root.get_node_or_null("Main") if Engine.get_main_loop() != null else null
static func font(kind := "sans") -> Font: return UIKit.font(kind, 900)
static func tex_of(k: String) -> Texture2D:   # 全身原圖；冇就頭像圖集
	if k == "": return null
	var t = PtGfx.tex(Art.spr_key(k))
	return t
# 圖按比例縮入 box（唔裁切、唔出界）
static func fit(t: Texture2D, box: Rect2) -> Rect2:
	if t == null: return box
	var s = minf(box.size.x / maxf(1.0, t.get_width()), box.size.y / maxf(1.0, t.get_height()))
	var sz = Vector2(t.get_width(), t.get_height()) * s
	return Rect2(box.position + (box.size - sz) * Vector2(0.5, 1.0), sz)   # 腳貼底
# 墨線紙卡
static func ink_card(c: CanvasItem, r: Rect2, bg := PAPER, seed := 0, edge := INK) -> void:
	c.draw_rect(Rect2(r.position + Vector2(4, 5), r.size), Color(0, 0, 0, 0.35))
	c.draw_rect(r, bg)
	var rng = RandomNumberGenerator.new(); rng.seed = 9137 + seed
	var gap = 9.0
	var x = r.position.x - r.size.y
	while x < r.end.x:   # 右下角斜線陰影（墨線畫風）
		var a = Vector2(x, r.end.y); var b = Vector2(x + r.size.y * 0.35, r.end.y - r.size.y * 0.35)
		if b.x > r.position.x + r.size.x * 0.55: c.draw_line(Vector2(maxf(a.x, r.position.x), a.y - maxf(0.0, r.position.x - a.x)), Vector2(minf(b.x, r.end.x), b.y + maxf(0.0, b.x - r.end.x)), Color(INK, 0.06), 1.0)
		x += gap
	for i in 2:   # 手畫墨邊：兩重、少少抖
		var j = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * (1.2 + i)
		c.draw_rect(Rect2(r.position + j, r.size), Color(edge, 0.9 if i == 0 else 0.35), false, 2.6 if i == 0 else 1.2)
static func seal(c: CanvasItem, p: Vector2, txt: String, sz := 46.0, k := 1.0, rot := -0.12) -> void:   # 硃砂印
	c.draw_set_transform(p, rot, Vector2(k, k))
	var r = Rect2(-sz / 2, -sz / 2, sz, sz)
	c.draw_rect(r, Color(CINNABAR, 0.88))
	c.draw_rect(r.grow(-3), Color(PAPER, 0.85), false, 2.0)
	var f = font("serif")
	var n = txt.length()
	if n <= 2:
		var fs = int(sz * (0.62 if n == 1 else 0.4))
		for i in n:
			var ch = txt.substr(i, 1)
			var w = f.get_string_size(ch, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			var y = (0.0 if n == 1 else (-0.22 + 0.44 * i) * sz) + fs * 0.36
			c.draw_string(f, Vector2(-w / 2, y), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, PAPER)
	else:   # 四字印：2×2
		var fs2 = int(sz * 0.36)
		for i in mini(4, n):
			var ch = txt.substr(i, 1)
			var w = f.get_string_size(ch, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2).x
			var cx = (0.22 if i < 2 else -0.22) * sz; var cy = (-0.2 if i % 2 == 0 else 0.24) * sz
			c.draw_string(f, Vector2(cx - w / 2, cy + fs2 * 0.3), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2, PAPER)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
static func text_c(c: CanvasItem, s: String, cx: float, y: float, px: int, col: Color, kind := "sans", maxw := -1.0, ow := 0, oc := INK) -> void:   # 置中字（太闊就縮細，最細 12）
	var f = font(kind)
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	while maxw > 0 and w > maxw and px > 12:
		px -= 1; w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	if ow > 0: c.draw_string_outline(f, Vector2(cx - w / 2, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, ow, oc)
	c.draw_string(f, Vector2(cx - w / 2, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
static func text_l(c: CanvasItem, s: String, x: float, y: float, px: int, col: Color, kind := "sans", maxw := -1.0) -> void:
	var f = font(kind)
	while maxw > 0 and f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > maxw and px > 12: px -= 1
	c.draw_string(f, Vector2(x, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
# 魂火（墨邊水滴火）
static func flame(c: CanvasItem, p: Vector2, r: float, dir: Vector2, col: Color, t: float) -> void:
	var d = dir.normalized() if dir.length() > 0.01 else Vector2(0, -1)
	var back = -d; var side = Vector2(-d.y, d.x)
	var pts = PackedVector2Array()
	for i in 18:
		var a = float(i) / 18.0 * TAU
		var v = Vector2(cos(a), sin(a))
		var along = v.dot(back)
		var k = 1.0 + maxf(0.0, along) * (1.5 + 0.25 * sin(t * 18.0 + i))   # 尾拉長
		pts.append(p + (back * along * k + side * v.dot(side) * (1.0 - maxf(0.0, along) * 0.35)) * r)
	c.draw_colored_polygon(pts, Color(col, 0.92))
	pts.append(pts[0])
	c.draw_polyline(pts, INK, 2.0, true)
	c.draw_circle(p + d * r * 0.12, r * 0.45, Color(1, 1, 0.95, 0.85))

# ======================= ① 魂火飛向戰況條 =======================
# so_data.settle 打贏 → soul2.after_win → 呢度。sl = soul_data.on_sortie_win 回傳 {items:[{k,n,sec}], mul, san}
static func soul_fire(op, sl: Dictionary) -> Node:
	var items = sl.get("items", [])
	if not (items is Array) or items.is_empty(): return null
	var RV = load("res://game/rts/rts_view.gd")
	var v = RV.inst
	if v == null or not is_instance_valid(v) or v.get("ui") == null or v.get("root") == null: return null
	var ui: Control = v.ui
	var inv = ui.get_global_transform_with_canvas().affine_inverse()
	var from = Vector2(ui.size.x * 0.5, ui.size.y * 0.45)
	for u in op.units:   # 駐守鬼倒低嘅位
		if J.num(u.get("side")) == 1 and J.str(u.get("k")) == str(items[0].k) and u.get("p") is Vector2:
			from = inv * (v.root.get_global_transform_with_canvas() * (u.p as Vector2) + Vector2(0, -30))
			break
	from = Vector2(clampf(from.x, 30, ui.size.x - 30), clampf(from.y, 120, ui.size.y - 120))
	var chip = v.get("chip")
	var to = Vector2(70, ui.size.y - 28)
	if chip is Control and is_instance_valid(chip): to = inv * (chip.get_global_rect().get_center())
	var fx = Fire.new()
	fx.name = "SoulFire"; fx.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fx.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fx.a = from; fx.b = to; fx.chip = chip if chip is Control else null
	var mul = float(sl.get("mul", 1.0))
	for i in items.size():
		var it = items[i]
		var nm = SOUL.gname(str(it.k))
		var tail = ""
		if mul < 0.99 and not J.t(it.get("sec")): tail = L("（怨氣已散 ×%s）", "（怨氣已散 ×%s）") % ("½" if mul >= 0.5 else "¼")
		fx.items.append({"n": int(it.n), "sec": J.t(it.get("sec")), "txt": L("%s魂魄 +%d", "%s魂魄 +%d") % [nm, int(it.n)] + (L("（副）", "（副）") if J.t(it.get("sec")) else "") + tail, "d": 0.28 * i})
	ui.add_child(fx)
	last = fx
	LOG.append(["fire", items.size()])
	return fx

class Fire extends Control:
	var F = load("res://game/soul/soul_fx.gd")
	var a := Vector2.ZERO
	var b := Vector2.ZERO
	var chip: Control = null
	var items: Array = []
	var t := 0.0
	const RISE := 0.35
	const FLY := 0.8
	func _ready() -> void: set_process(true)
	func _pos(u: float) -> Vector2:   # 先升起，再沿弧線飛
		if u < RISE: return a + Vector2(0, -36.0 * ease(u / RISE, 0.5))
		var k = clampf((u - RISE) / FLY, 0.0, 1.0)
		k = k * k * (3.0 - 2.0 * k)
		var s = a + Vector2(0, -36)
		var ctrl = Vector2(lerpf(s.x, b.x, 0.25), minf(s.y, b.y) - 160.0)
		return s.lerp(ctrl, k).lerp(ctrl.lerp(b, k), k)
	func _process(dt: float) -> void:
		t += dt
		for it in items:
			if not it.get("hit", false) and t - float(it.d) >= RISE + FLY:
				it["hit"] = true
				_arrive(it)
		queue_redraw()
		if t > RISE + FLY + 0.28 * items.size() + 1.8: queue_free()
	func _arrive(it: Dictionary) -> void:
		if chip != null and is_instance_valid(chip):
			chip.modulate = Color(2.2, 2.2, 1.6)
			var tw = chip.create_tween(); tw.tween_property(chip, "modulate", Color.WHITE, 0.45)
		var p = Pop.new(); p.txt = str(it.txt); p.n = int(it.n); p.col = F.SEC_C if it.sec else F.GOLD
		p.at = b + Vector2(0, -36 - 34 * items.find(it)); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		get_parent().add_child(p)
		Snd.play("coin")
	func _draw() -> void:
		for it in items:
			var u = t - float(it.d)
			if u < 0 or it.get("hit", false): continue
			var p = _pos(u); var p0 = _pos(maxf(0.0, u - 0.05))
			var col = F.SEC_C if it.sec else F.SOUL_C
			for j in 7:   # 尾巴：一粒粒淡落去
				var q = _pos(maxf(0.0, u - 0.035 * (j + 1)))
				draw_circle(q, maxf(1.5, 9.0 - j * 1.2), Color(col, 0.42 - j * 0.055))
			var r = 13.0 * (0.4 + 0.6 * clampf(u / RISE, 0.0, 1.0))
			F.flame(self, p, r, p - p0 if u > RISE else Vector2(0, -1), col, t)

class Pop extends Control:
	var F = load("res://game/soul/soul_fx.gd")
	var txt := ""
	var n := 0
	var col: Color = F.GOLD
	var at := Vector2.ZERO
	var t := 0.0
	func _ready() -> void: set_process(true)
	func _process(dt: float) -> void:
		t += dt; queue_redraw()
		if t > 1.9: queue_free()
	func _draw() -> void:
		var al = clampf(1.0 - maxf(0.0, t - 1.2) / 0.7, 0.0, 1.0)
		var y = at.y - 26.0 * ease(minf(1.0, t / 0.5), 0.4)
		var f = F.font("sans")
		var w = f.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
		var x = clampf(at.x - 40.0, 8.0, size.x - w - 8.0)
		var k = 1.0 + 0.25 * maxf(0.0, 1.0 - t / 0.18)
		draw_set_transform(Vector2(x, y), 0, Vector2(k, k))
		draw_string_outline(f, Vector2.ZERO, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, 6, Color(F.INK, al))
		draw_string(f, Vector2.ZERO, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(col, al))
		draw_set_transform_matrix(Transform2D.IDENTITY)

# ======================= ② 招降入職通知書 ③ 升職演出 =======================
# soul_ui._letter 掛鈎：回 true＝已播（soul_ui 唔使再出舊卡）
static func letter(k: String, promote: bool) -> bool:
	var m = _main()
	if m == null: return false
	var old = m.get_node_or_null("SoulShow")
	if old != null: old.name = "SoulShowOld"; old.queue_free()
	var sh = Show.new(); sh.name = "SoulShow"; sh.k = k; sh.promote = promote
	sh.r = SOUL.rank(k)
	sh.nm = SOUL.gname(k)
	sh.pin = SOUL.pin(k)
	sh.tex = tex_of(k)
	if promote:
		var g = SOUL.ghost(k)
		var r0 = maxi(0, sh.r - 1)
		var a0 = SOUL.stat_target(k, r0); var a1 = SOUL.stat_target(k, sh.r)
		sh.lines = [L("三圍 %d/%d/%d → %d/%d/%d（+%d%%）", "三圍 %d/%d/%d → %d/%d/%d（+%d%%）") % [a0[0], a0[1], a0[2], a1[0], a1[1], a1[2], int(round(SOUL.STAT_PCT[sh.pin] * 100))]]
		if g != null:
			var cap = int(SOUL.cap_of(g))
			sh.lines.append(L("等級上限 %d → %d", "等級上限 %d → %d") % [cap - SOUL.CAP_PER_RANK, cap])
		if sh.r == 2: sh.lines.append(L("開專長 1（被動能力）", "開專長 1（被動能力）"))
		if sh.r == 4: sh.lines.append(L("開專長 2（被動能力）", "開專長 2（被動能力）"))
		if sh.r == 5: sh.lines.append(L("金框名牌；之後嘅魂魄自動化散魂", "金框名牌；之後的魂魄自動化成散魂"))
	sh.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sh.mouse_filter = Control.MOUSE_FILTER_STOP
	m.add_child(sh)
	last = sh
	LOG.append(["letter", k, promote])
	return true

class Show extends Control:
	var F = load("res://game/soul/soul_fx.gd")
	var k := ""
	var nm := ""
	var pin := "凡"
	var r := 0
	var promote := false
	var tex: Texture2D = null
	var lines: Array = []
	var t := 0.0
	var smoke: Array = []
	var bits: Array = []
	var skip_at := 0.0
	const T_PAPER := 0.7     # 黃紙寫名
	const T_BURN := 1.4      # 化寶爐火燒
	const T_GHOST := 2.1     # 青煙＋鬼現身
	const T_CARD := 2.5      # 入職通知書
	const T_END := 6.5
	func _ready() -> void:
		set_process(true)
		var rng = RandomNumberGenerator.new(); rng.seed = hash(k)
		for i in 26: smoke.append({"x": rng.randf_range(-70, 70), "v": rng.randf_range(30, 70), "r": rng.randf_range(16, 34), "d": rng.randf_range(0, 0.6), "w": rng.randf_range(0, TAU)})
		for i in 34: bits.append({"x": rng.randf_range(-1, 1), "y": rng.randf_range(-0.2, 0.3), "v": rng.randf_range(60, 160), "s": rng.randf_range(4, 9), "a": rng.randf_range(0, TAU), "c": [F.GOLD, F.CINNABAR, F.PAPER][i % 3]})
		if promote: t = T_CARD - 0.4   # 升職：直接出升職信（有金紙碎＋星星逐粒亮）
		Snd.play("praise" if promote else "whoosh")
	func _gui_input(ev: InputEvent) -> void:
		if (ev is InputEventMouseButton and ev.pressed) or (ev is InputEventScreenTouch and ev.pressed):
			accept_event()
			if t < T_CARD: t = T_CARD     # 撳一下：跳去通知書
			elif t > T_CARD + 0.5: queue_free()
	var _gong := false
	func _process(dt: float) -> void:
		t += dt; queue_redraw()
		if not _gong and t > T_CARD + 0.35: _gong = true; Snd.play("gong" if not promote else "chest")
		if t > T_END: queue_free()
	func _card_rect() -> Rect2:
		var w = minf(size.x * 0.88, 420.0); var h = 430.0 if not promote else 470.0
		return Rect2((size.x - w) / 2, size.y * 0.2, w, h)
	func _draw() -> void:
		var W = size.x; var H = size.y
		var dim = clampf(t / 0.3, 0, 1) * (1.0 - clampf((t - (T_END - 0.4)) / 0.4, 0, 1))
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.04, 0.03, 0.05, 0.62 * dim))
		var c = Vector2(W / 2, H * 0.42)
		if not promote and t < T_CARD + 0.3: _draw_rite(c)
		if t >= T_CARD - 0.4: _draw_card()
	func _draw_rite(c: Vector2) -> void:
		# 化寶爐（墨線）
		var base = c + Vector2(0, 150)
		var pot = PackedVector2Array([base + Vector2(-70, -40), base + Vector2(70, -40), base + Vector2(56, 30), base + Vector2(-56, 30)])
		draw_colored_polygon(pot, Color("#4a3a30")); pot.append(pot[0]); draw_polyline(pot, F.INK, 3.0, true)
		for i in 5: draw_line(base + Vector2(-44 + i * 22, -30), base + Vector2(-38 + i * 22, 22), Color(F.INK, 0.35), 1.5)
		draw_rect(Rect2(base + Vector2(-80, -48), Vector2(160, 10)), Color("#5a4838")); draw_rect(Rect2(base + Vector2(-80, -48), Vector2(160, 10)), F.INK, false, 2.0)
		# 黃紙：飄落 → 喺爐口燒
		var pt = clampf(t / T_PAPER, 0, 1)
		var burn = clampf((t - T_PAPER) / (T_BURN - T_PAPER), 0, 1)
		if burn < 1.0:
			var pc = c.lerp(base + Vector2(0, -70), ease(clampf((t - T_PAPER * 0.6) / 0.6, 0, 1), 0.6))
			var ph = 150.0 * (1.0 - burn); var pw = 62.0
			var pr = Rect2(pc.x - pw / 2, pc.y - 75, pw, ph)
			draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
			if ph > 2:
				draw_rect(pr, Color("#e8c64a", pt)); draw_rect(pr, Color(F.INK, pt), false, 2.0)
				var f = F.font("serif")
				var n = mini(nm.length(), 5)
				for i in n:   # 豎寫名（逐隻字寫出）
					var ch = nm.substr(i, 1)
					var y = pr.position.y + 26 + i * 24
					if y > pr.end.y - 4 or float(i) / n > pt * 1.2: continue
					var w = f.get_string_size(ch, HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x
					draw_string(f, Vector2(pc.x - w / 2, y), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(F.CINNABAR, pt))
				if burn > 0:   # 焦邊＋火舌
					draw_line(Vector2(pr.position.x, pr.end.y), Vector2(pr.end.x, pr.end.y), Color("#3a2010"), 4.0)
					for i in 5:
						var fx = pr.position.x + 6 + i * (pw - 12) / 4.0
						F.flame(self, Vector2(fx, pr.end.y + 4), 7.0 + 3.0 * sin(t * 20.0 + i), Vector2(0, -1), Color("#ff9a3a"), t)
		if t > T_PAPER:   # 爐火
			for i in 4: F.flame(self, base + Vector2(-36 + i * 24, -54), 10.0 + 4.0 * sin(t * 14.0 + i * 1.7), Vector2(0, -1), Color("#ff8a30"), t)
		# 青煙
		var sm = clampf((t - T_BURN + 0.3) / 0.9, 0, 1)
		if sm > 0:
			for s in smoke:
				var u = maxf(0.0, t - T_BURN + 0.3 - float(s.d))
				if u <= 0: continue
				var p = base + Vector2(float(s.x) + sin(u * 2.0 + float(s.w)) * 14.0, -60 - float(s.v) * u * 2.2)
				var al = clampf(0.5 - u * 0.22, 0, 0.5) * (1.0 - clampf((t - T_CARD) / 0.3, 0, 1))
				draw_circle(p, float(s.r) * (1.0 + u * 0.6), Color(0.55, 0.75, 0.68, al))
				draw_arc(p, float(s.r) * (1.0 + u * 0.6), 0, TAU, 20, Color(F.INK, al * 0.5), 1.2, true)
		# 鬼現身（原圖，淡入＋飄）
		var ga = clampf((t - T_BURN) / (T_GHOST - T_BURN), 0, 1) * (1.0 - clampf((t - T_CARD) / 0.3, 0, 1))
		if ga > 0 and tex != null:
			var box = Rect2(c.x - 90, c.y - 150 + sin(t * 3.0) * 6.0 - 20.0 * ga, 180, 240)
			draw_texture_rect(tex, F.fit(tex, box), false, Color(0.75 + 0.25 * ga, 1, 0.92 + 0.08 * ga, ga))
	func _draw_card() -> void:
		var R = _card_rect()
		var u = clampf((t - (T_CARD - 0.4)) / 0.4, 0, 1)
		var off = (1.0 - ease(u, 0.4)) * 90.0
		var al = u * (1.0 - clampf((t - (T_END - 0.4)) / 0.4, 0, 1))
		modulate.a = 1.0
		var cr = Rect2(R.position + Vector2(0, off), R.size)
		draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
		F.ink_card(self, cr, Color(F.PAPER, al), hash(k) % 97, Color(F.INK, al))
		draw_rect(cr.grow(-10), Color(F.CINNABAR, 0.7 * al), false, 2.0)
		var cx = cr.get_center().x
		var head = F.L("升職信", "升職信") if promote else F.L("入職通知書", "入職通知書")
		F.text_c(self, head, cx, cr.position.y + 50, 30, Color(F.INK, al), "serif")
		draw_line(Vector2(cr.position.x + 30, cr.position.y + 64), Vector2(cr.end.x - 30, cr.position.y + 64), Color(F.INK, 0.4 * al), 1.5)
		# 左：鬼（全身原圖，入框唔裁切）
		var box = Rect2(cr.position.x + 22, cr.position.y + 78, 132, 176)
		draw_rect(box, Color(F.PAPER2, al)); draw_rect(box, Color(F.INK, al), false, 2.0)
		if tex != null: draw_texture_rect(tex, F.fit(tex, box.grow(-6)), false, Color(1, 1, 1, al))
		var tx = box.end.x + 14; var tw = cr.end.x - 20 - tx
		var y = cr.position.y + 104
		F.text_l(self, nm, tx, y, 26, Color(F.INK, al), "serif", tw); y += 34
		F.text_l(self, F.L("%s品", "%s品") % pin, tx, y, 18, Color(F.PINC.get(pin, Color.GRAY), al), "sans", tw); y += 30
		if promote:
			F.text_l(self, F.L("由【%s】", "由【%s】") % SOUL.rank_name(maxi(0, r - 1)), tx, y, 18, Color(F.INK, 0.75 * al), "sans", tw); y += 28
			F.text_l(self, F.L("升為【%s】", "升為【%s】") % SOUL.rank_name(r), tx, y, 22, Color(F.CINNABAR, al), "sans", tw); y += 34
			# 星：逐粒亮
			for i in SOUL.RANK_MAX:
				var sp = Vector2(tx + 12 + i * 24, y - 6)
				var lit = i < r - 1 or (i == r - 1 and t > T_CARD + 0.25)
				var pop = 1.0 + (0.6 * maxf(0.0, 1.0 - (t - T_CARD - 0.25) / 0.25) if i == r - 1 and lit else 0.0)
				_star(sp, 10.0 * pop, Color(F.GOLD, al) if lit else Color(F.INK, 0.25 * al))
		else:
			F.text_l(self, F.L("職位：試用", "職位：試用"), tx, y, 20, Color(F.CINNABAR, al), "sans", tw); y += 30
			F.text_l(self, F.L("即日起生效", "即日起生效"), tx, y, 17, Color(F.INK, 0.75 * al), "sans", tw)
		var by = box.end.y + 30
		if promote:
			for ln in lines:
				F.text_l(self, "・" + str(ln), cr.position.x + 26, by, 17, Color(F.INK, al), "sans", cr.size.x - 52); by += 28
			by += 6
			F.text_l(self, F.L("「做得幾好，繼續努力。」", "「做得不錯，繼續努力。」"), cr.position.x + 26, by, 19, Color(F.CINNABAR, al), "serif", cr.size.x - 52); by += 26
			F.text_l(self, F.L("——阿福（好難得咁讚人）", "——阿福（難得稱讚人）"), cr.position.x + 26, by, 16, Color(F.INK, 0.7 * al), "sans", cr.size.x - 52)
		else:
			F.text_l(self, F.L("茲聘請 %s 為落魄村員工。", "茲聘請 %s 為落魄村員工。") % nm, cr.position.x + 26, by, 18, Color(F.INK, al), "sans", cr.size.x - 52); by += 30
			F.text_l(self, F.L("試用期三個月，冇勞工假。", "試用期三個月，沒有勞工假。"), cr.position.x + 26, by, 18, Color(F.INK, al), "sans", cr.size.x - 52); by += 30
			F.text_l(self, F.L("簽名：阿福", "簽名：阿福"), cr.end.x - 160, by + 8, 18, Color(F.INK, 0.8 * al), "serif", 140)
		# 硃砂印：落印（由大縮細＋輕震）
		var st = clampf((t - T_CARD - 0.35) / 0.18, 0, 1)
		if st > 0:
			var k2 = lerpf(2.2, 1.0, ease(st, 0.3))
			F.seal(self, Vector2(cr.end.x - 58, cr.end.y - 58), F.L("升職", "升職") if promote else F.L("落魄村印", "落魄村印"), 58.0, k2)
		# 升職：金紙碎
		if promote:
			for b in bits:
				var u2 = t - T_CARD
				if u2 < 0: continue
				var p = Vector2(cx + float(b.x) * cr.size.x * 0.5, cr.position.y + float(b.y) * 100 + float(b.v) * u2)
				if p.y > cr.end.y + 40: continue
				draw_set_transform(p, float(b.a) + u2 * 4.0, Vector2.ONE)
				draw_rect(Rect2(-float(b.s) / 2, -float(b.s) / 4, float(b.s), float(b.s) / 2), Color(b.c, al * 0.9))
				draw_set_transform_matrix(Transform2D.IDENTITY)
		if t > T_CARD + 0.6: F.text_c(self, F.L("撳一下收起", "按一下收起"), cx, cr.end.y + 34, 16, Color(1, 0.95, 0.85, 0.8 * al), "sans", -1, 4)
	func _star(p: Vector2, r: float, col: Color) -> void:
		var pts = PackedVector2Array()
		for i in 10:
			var a = -PI / 2 + i * PI / 5
			pts.append(p + Vector2(cos(a), sin(a)) * (r if i % 2 == 0 else r * 0.45))
		draw_colored_polygon(pts, col); pts.append(pts[0]); draw_polyline(pts, Color(F.INK, col.a), 1.5, true)

const PINC := {"凡": Color("#5a6b78"), "靈": Color("#2f6fb0"), "煞": Color("#8a2a8a"), "王": Color("#b07a1f"), "主": Color("#9c2219")}

# ======================= ④ 抄功課：影印戰報卡（約 1.4 秒） =======================
static func photocopy(title: String, line: String) -> Node:
	var m = _main()
	if m == null: return null
	var old = m.get_node_or_null("SoulCopy")
	if old != null: old.name = "SoulCopyOld"; old.queue_free()
	var c = Copy.new(); c.name = "SoulCopy"; c.title = title; c.line = line
	c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(c)
	last = c
	LOG.append(["copy", title])
	return c

class Copy extends Control:
	var F = load("res://game/soul/soul_fx.gd")
	var title := ""
	var line := ""
	var t := 0.0
	func _ready() -> void: set_process(true)
	func _process(dt: float) -> void:
		t += dt; queue_redraw()
		if t > 1.6: queue_free()
	func _draw() -> void:
		var w = minf(size.x * 0.7, 300.0); var h = 150.0
		var x = (size.x - w) / 2
		var slot_y = size.y * 0.16 + 30   # 頂部（唔遮下面戰場同按鈕）
		# 影印機出紙口
		draw_rect(Rect2(x - 20, slot_y - 18, w + 40, 20), Color("#3a3430")); draw_rect(Rect2(x - 20, slot_y - 18, w + 40, 20), F.INK, false, 2.0)
		var out = ease(clampf(t / 0.45, 0, 1), 0.4)
		var al = 1.0 - clampf((t - 1.25) / 0.35, 0, 1)
		var r = Rect2(x, slot_y, w, h * out)
		if r.size.y < 2: return
		F.ink_card(self, r, Color(1, 1, 1, al), 3, Color(F.INK, al))
		draw_rect(Rect2(x, slot_y, w, minf(h * out, 6)), Color(0, 0, 0, 0.25 * al))   # 出紙口陰影
		var cx = x + w / 2
		if r.size.y > 50: F.text_c(self, F.L("影印戰報", "影印戰報"), cx, slot_y + 38, 24, Color(F.INK, al), "serif")
		if r.size.y > 80: F.text_c(self, title, cx, slot_y + 70, 17, Color(F.INK, 0.8 * al), "sans", w - 24)
		if r.size.y > 110: F.text_c(self, F.L("（格式完全一樣）", "（格式完全一樣）"), cx, slot_y + 100, 15, Color(F.INK, 0.6 * al), "sans", w - 24)
		if t > 0.5:
			var k = lerpf(2.0, 1.0, ease(clampf((t - 0.5) / 0.15, 0, 1), 0.3))
			F.seal(self, Vector2(x + w - 40, slot_y + h - 40), F.L("已抄", "已抄"), 48.0, k * al if al > 0.05 else 0.01)
