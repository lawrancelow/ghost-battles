# 仿 WhatsApp（深色模式）：主列表、對話紀錄、劇情即時對話
# 剔號：已傳送 ✓（灰）→ 已送達 ✓✓（灰）→ 已讀 ✓✓（藍）；對方「正在輸入…」；未讀數字、綠色時間、「N 則未讀訊息」分隔
class_name WA
extends Control

const BG := Color("#111b21")
const BAR := Color("#1f2c34")
const CHATBG := Color("#0b141a")
const TXT := Color("#e9edef")
const SUB := Color("#8696a0")
const ICONC := Color("#aebac1")
const GREEN := Color("#00a884")
const BLUE := Color("#53bdeb")
const ME := Color("#005c4b")
const THEM := Color("#202c33")
const MID := Color("#182229")
const META := Color(0.914, 0.929, 0.937, 0.6)
const NAMECOLS := ["#e0a96d", "#53bdeb", "#06cf9c", "#fc9775", "#a5b337", "#d88deb", "#ff72a1", "#8b9cff"]

const ICON = {
	"back": '<svg viewBox="0 0 24 24"><path d="M15 5 8 12l7 7" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>',
	"video": '<svg viewBox="0 0 24 24"><rect x="3" y="7" width="12" height="10" rx="2" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="m15 11 6-3v8l-6-3" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>',
	"call": '<svg viewBox="0 0 24 24"><path d="M6.6 3.5 9 6.8 7.4 9c1 2.5 3 4.5 5.6 5.6l2.2-1.6 3.3 2.4-1 3.1c-.3.8-1.1 1.3-2 1.1C9.3 18.6 5.4 14.7 3.4 8.5c-.2-.9.3-1.7 1.1-2z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>',
	"dots": '<svg viewBox="0 0 24 24"><circle cx="12" cy="5" r="1.8" fill="currentColor"/><circle cx="12" cy="12" r="1.8" fill="currentColor"/><circle cx="12" cy="19" r="1.8" fill="currentColor"/></svg>',
	"cam": '<svg viewBox="0 0 24 24"><path d="M4 8h3l2-3h6l2 3h3v11H4z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><circle cx="12" cy="13" r="3.4" fill="none" stroke="currentColor" stroke-width="1.8"/></svg>',
	"smile": '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="9" cy="10" r="1.2" fill="currentColor"/><circle cx="15" cy="10" r="1.2" fill="currentColor"/><path d="M8 14.5c2 2 6 2 8 0" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
	"clip": '<svg viewBox="0 0 24 24"><path d="m15.5 7-7 7a2 2 0 0 0 2.8 2.8l7.5-7.5a3.6 3.6 0 0 0-5-5L6.2 11.9a5 5 0 0 0 7.1 7.1l6-6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
	"mic": '<svg viewBox="0 0 24 24"><rect x="9" y="3" width="6" height="11" rx="3" fill="currentColor"/><path d="M5.5 11a6.5 6.5 0 0 0 13 0M12 17.5V21" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
	"send": '<svg viewBox="0 0 24 24"><path d="M4 12 20 4l-4 16-4-6.5z" fill="currentColor"/><path d="m12 13.5 8-9.5" stroke="#00a884" stroke-width="1.4"/></svg>',
	"pin": '<svg viewBox="0 0 24 24"><path d="M9 3h6l-1 6 3 3H7l3-3zM12 12v9" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>',
	"mute": '<svg viewBox="0 0 24 24"><path d="M4 9h4l5-4v14l-5-4H4z" fill="currentColor"/><path d="m16 9 5 6m0-6-5 6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
	"chat": '<svg viewBox="0 0 24 24"><path d="M4 5h16v11H9l-5 4z" fill="currentColor"/><path d="M8 9.5h8M8 12.5h5" stroke="#00a884" stroke-width="1.6" stroke-linecap="round"/></svg>',
	"search": '<svg viewBox="0 0 24 24"><circle cx="10.5" cy="10.5" r="6" fill="none" stroke="currentColor" stroke-width="1.9"/><path d="m15 15 5 5" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/></svg>',
	"lock": '<svg viewBox="0 0 24 24"><rect x="5" y="10.5" width="14" height="10" rx="2" fill="currentColor"/><path d="M8 10.5V8a4 4 0 0 1 8 0v2.5" fill="none" stroke="currentColor" stroke-width="2"/></svg>',
}

static var _icache = {}
static func icon(name: String, col: Color, px := 22) -> Texture2D:
	var key = "%s|%s|%d" % [name, col.to_html(), px]
	if _icache.has(key): return _icache[key]
	var svg: String = ICON[name].replace("currentColor", "#" + col.to_html(false))
	var img = Image.new()
	img.load_svg_from_string(svg, px * 3.0 / 24.0)
	img.generate_mipmaps()
	var t = ImageTexture.create_from_image(img)
	_icache[key] = t
	return t

static func icon_rect(name: String, col: Color, px := 22) -> TextureRect:
	var r = TextureRect.new(); r.texture = icon(name, col, px)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(px, px); r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	return r

static func F(w := 400) -> Font: return UIKit.font("sans", w)
static func lab(t: String, sz := 15, col := TXT, w := 400) -> Label:
	var l = UIKit.label(t, sz, col, "sans", w); l.mouse_filter = Control.MOUSE_FILTER_IGNORE; return l
static func now_hm() -> String:
	var d = Time.get_time_dict_from_system(); return "%02d:%02d" % [d.hour, d.minute]
static func name_col(n: String) -> Color: return Color(NAMECOLS[abs(n.hash()) % NAMECOLS.size()])

# ====================================================================
# 小元件
# ====================================================================
class StatusBar extends Control:
	var time = "02:13"; var batt = "3%"; var low = true; var bg = Color("#111b21")
	func _init(t, b, l, c) -> void:
		time = t; batt = b; low = l; bg = c; custom_minimum_size = Vector2(0, 28); mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), bg)
		var f = WA.F(700); var fr = WA.F(400); var y = 19.0
		draw_string(f, Vector2(16, y), time, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, WA.TXT)
		var x = size.x - 16
		var pw = fr.get_string_size(batt, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
		x -= pw; draw_string(fr, Vector2(x, y), batt, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, WA.TXT)
		x -= 30
		var br = Rect2(x, 8.5, 22, 11)
		var s = StyleBoxFlat.new(); s.bg_color = Color(0, 0, 0, 0); s.border_color = WA.TXT; s.set_border_width_all(1); s.set_corner_radius_all(3); s.anti_aliasing = true
		draw_style_box(s, br)
		draw_rect(Rect2(br.end.x + 1, 11.5, 2, 4), WA.TXT)
		var fillw = (br.size.x - 4) * (0.12 if low else 0.7)
		draw_rect(Rect2(br.position.x + 2, br.position.y + 2, fillw, br.size.y - 4), Color("#f15c6d") if low else WA.TXT)
		x -= 22
		var hs = [4, 6, 8, 11]
		for i in 4:
			draw_rect(Rect2(x + i * 4.5, 19.5 - hs[i], 3, hs[i]), Color(WA.TXT, 0.35 if i == 3 else 1.0))
		# 網絡標記
		draw_string(fr, Vector2(x - 26, y - 1), "4G", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, WA.TXT)

class Avatar extends Control:
	var av; var sz = 50.0; var ring = false
	func _init(a, s := 50.0, r := false) -> void:
		av = a; sz = s; ring = r; custom_minimum_size = Vector2(s, s); size_flags_vertical = Control.SIZE_SHRINK_CENTER; mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		var c = Vector2(sz, sz) / 2; var r = sz / 2
		if av is String and av == "sys":
			draw_circle(c, r, Color("#06231f"))
			for i in 8: draw_circle(c, r * (1.0 - i * 0.1), Color(0.47, 1, 0.86, 0.035 * i))
			var s = StyleBoxFlat.new(); s.bg_color = Color("#0e2a2a"); s.border_color = Color("#6ff0d0"); s.set_border_width_all(2); s.set_corner_radius_all(int(sz * 0.08)); s.anti_aliasing = true
			draw_style_box(s, Rect2(sz * 0.26, sz * 0.2, sz * 0.48, sz * 0.6))
			var f = WA.F(900); var fs = int(sz * 0.2)
			draw_string(f, Vector2(0, sz * 0.47 + fs * 0.35), "KPI", HORIZONTAL_ALIGNMENT_CENTER, sz, fs, Color("#6ff0d0"))
			draw_rect(Rect2(sz * 0.36, sz * 0.6, sz * 0.28, sz * 0.05), Color("#6ff0d0"))
		else:
			var col = Color(str(av[1])) if av is Array and av.size() > 1 else Color("#555")
			draw_circle(c, r, col)
			var f = WA.F(700); var fs = int(round(sz * 0.42)); var t = str(av[0]) if av is Array else "?"
			var asc = f.get_ascent(fs); var dsc = f.get_descent(fs)
			draw_string(f, Vector2(0, c.y + (asc - dsc) / 2), t, HORIZONTAL_ALIGNMENT_CENTER, sz, fs, Color.WHITE)
		if ring:
			draw_arc(c, r + 3.2, 0, TAU, 48, WA.GREEN, 2.2, true)

class Ticks extends Control:
	var two = false; var col = WA.META
	func _init(t := false, c := WA.META) -> void:
		two = t; col = c; custom_minimum_size = Vector2(17, 11); mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void: WA.draw_ticks(self, Vector2(0, 0), two, col)

static func draw_ticks(ci: CanvasItem, o: Vector2, two: bool, col: Color) -> void:
	if two:
		ci.draw_polyline(PackedVector2Array([o + Vector2(0.5, 6), o + Vector2(3.6, 9.2), o + Vector2(10.2, 1.6)]), col, 1.5, true)
		ci.draw_polyline(PackedVector2Array([o + Vector2(6.4, 8.2), o + Vector2(7.4, 9.2), o + Vector2(14.6, 1.6)]), col, 1.5, true)
	else:
		ci.draw_polyline(PackedVector2Array([o + Vector2(2.5, 6), o + Vector2(5.6, 9.2), o + Vector2(12.2, 1.6)]), col, 1.5, true)

# 對話氣泡：文字自行排版，時間（同剔號）貼喺最後一行右下角，好似真 WhatsApp
class Bubble extends Control:
	var kind = "them"; var who = ""; var text = ""; var time = ""; var tick = 0; var tail = true
	var tick_col = WA.META
	var para: TextParagraph; var maxw = 296.0; var inline_meta = true
	const PL = 9.0; const PR = 9.0; const PT = 6.0; const PB = 8.0; const FS = 15; const LH = 21.0
	func _init(k: String, w: String, t: String, tm: String, tk := 0, tl := true, mw := 296.0) -> void:
		kind = k; who = w; text = t; time = tm; tick = tk; tail = tl; maxw = mw
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		size_flags_horizontal = Control.SIZE_SHRINK_END if k == "me" else (Control.SIZE_SHRINK_CENTER if k == "mid" else Control.SIZE_SHRINK_BEGIN)
		if tick == 3: tick_col = WA.BLUE
		_layout()
	func set_tick(t: int) -> void:
		var was = tick; tick = t
		if t == 3 and was != 3:
			var tw = create_tween(); tw.tween_property(self, "tick_col", WA.BLUE, 0.25)
			tw.parallel().tween_method(func(_v): queue_redraw(), 0.0, 1.0, 0.25)
		else: tick_col = WA.BLUE if t == 3 else WA.META
		_layout(); queue_redraw()
	func _meta_w() -> float:
		if kind == "mid": return 0.0
		var w = WA.F(400).get_string_size(time, HORIZONTAL_ALIGNMENT_LEFT, -1, 11).x
		if kind == "me": w += 20
		return w
	func _layout() -> void:
		var fs = 13 if kind == "mid" else FS
		para = TextParagraph.new()
		para.break_flags = TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
		para.add_string(text, WA.F(400), fs)
		var inner = maxw - PL - PR
		para.width = inner
		var n = para.get_line_count(); var cw = 0.0
		for i in n: cw = maxf(cw, para.get_line_width(i))
		var lh = 18.0 if kind == "mid" else LH
		var h = PT + n * lh + (PB if kind != "mid" else 5.0)
		var w = cw
		if kind == "mid":
			h = 5 + n * lh + 5
		else:
			var mw = _meta_w(); var last = para.get_line_width(n - 1) if n > 0 else 0.0
			if last + 10 + mw <= inner: inline_meta = true; w = maxf(cw, last + 10 + mw)
			else: inline_meta = false; w = maxf(cw, mw); h += 14
		if who != "" and kind == "them": h += 18; w = maxf(w, WA.F(600).get_string_size(who, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x)
		w = maxf(w + PL + PR, 60.0 if kind != "mid" else 0.0)
		custom_minimum_size = Vector2(ceil(w), ceil(h) + (4 if tail else 0))
		pivot_offset = custom_minimum_size * Vector2(1.0 if kind == "me" else (0.5 if kind == "mid" else 0.0), 1.0)
		queue_redraw()
	func _draw() -> void:
		var top = 4.0 if tail else 0.0
		var r = Rect2(0, top, size.x, size.y - top)
		var bgc = WA.ME if kind == "me" else (WA.MID if kind == "mid" else WA.THEM)
		var s = StyleBoxFlat.new(); s.bg_color = bgc; s.set_corner_radius_all(8); s.anti_aliasing = true
		if tail and kind == "me": s.corner_radius_top_right = 0
		if tail and kind == "them": s.corner_radius_top_left = 0
		if kind != "mid":
			var sh = s.duplicate(); sh.bg_color = Color(0, 0, 0, 0.25); draw_style_box(sh, Rect2(r.position + Vector2(0, 1), r.size))
		draw_style_box(s, r)
		if tail and kind == "me":
			draw_colored_polygon(PackedVector2Array([Vector2(size.x - 1, top), Vector2(size.x + 8, top), Vector2(size.x - 1, top + 10)]), bgc)
		elif tail and kind == "them":
			draw_colored_polygon(PackedVector2Array([Vector2(1, top), Vector2(-8, top), Vector2(1, top + 10)]), bgc)
		var y = top + (5.0 if kind == "mid" else PT)
		if who != "" and kind == "them":
			draw_string(WA.F(600), Vector2(PL, y + 13), who, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, WA.name_col(who)); y += 18
		var lh = 18.0 if kind == "mid" else LH
		var col = WA.SUB if kind == "mid" else WA.TXT
		for i in para.get_line_count():
			var lw = para.get_line_width(i); var x = PL
			if kind == "mid": x = (size.x - lw) / 2
			para.draw_line(get_canvas_item(), Vector2(x, y + (lh - para.get_line_size(i).y) / 2 + i * lh), i, col)
		if kind == "mid": return
		var by = size.y - 5.0
		var f = WA.F(400); var tx = size.x - PR - _meta_w()
		draw_string(f, Vector2(tx, by - 1), time, HORIZONTAL_ALIGNMENT_LEFT, -1, 11, WA.META)
		if kind == "me" and tick > 0:
			WA.draw_ticks(self, Vector2(size.x - PR - 16, by - 10), tick >= 2, tick_col)

class Pill extends PanelContainer:
	func _init(t: String, col := WA.SUB, bg := WA.MID, fs := 12, maxw := 0.0) -> void:
		var s = UIKit.sb(bg, 8, Color(0, 0, 0, 0), 0, Vector4(10, 4, 10, 4)); add_theme_stylebox_override("panel", s)
		size_flags_horizontal = Control.SIZE_SHRINK_CENTER; mouse_filter = Control.MOUSE_FILTER_IGNORE
		var l = WA.lab(t, fs, col); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if maxw > 0:
			l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
			var w = WA.F(400).get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			l.custom_minimum_size.x = minf(w + 2, maxw)
		add_child(l)

# 聊天背景：淡淡嘅塗鴉（燈籠、元寶、月亮、星、小鬼）
class Wallpaper extends Control:
	var seeds = []
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var rng = RandomNumberGenerator.new(); rng.seed = 4471
		for i in 22: seeds.append([Vector2(rng.randf() * 200, rng.randf() * 200), rng.randi() % 6, rng.randf() * TAU, 0.8 + rng.randf() * 0.5])
		resized.connect(queue_redraw)
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), WA.CHATBG)
		var c = Color(1, 1, 1, 0.045)
		for ty in int(ceil(size.y / 200.0)) + 1:
			for tx in int(ceil(size.x / 200.0)) + 1:
				var o = Vector2(tx * 200, ty * 200)
				for s in seeds: _doodle(o + s[0], s[1], s[2], s[3], c)
	func _doodle(p: Vector2, k: int, rot: float, sc: float, c: Color) -> void:
		draw_set_transform(p, rot, Vector2(sc, sc))
		match k:
			0: # 小鬼
				draw_arc(Vector2(0, -2), 6, PI, TAU, 12, c, 1.2, true)
				draw_polyline(PackedVector2Array([Vector2(-6, -2), Vector2(-6, 7), Vector2(-3, 5), Vector2(0, 7), Vector2(3, 5), Vector2(6, 7), Vector2(6, -2)]), c, 1.2, true)
				draw_circle(Vector2(-2, -3), 0.9, c); draw_circle(Vector2(2, -3), 0.9, c)
			1: # 燈籠
				draw_arc(Vector2.ZERO, 6, 0, TAU, 14, c, 1.2, true); draw_line(Vector2(-3, -6), Vector2(3, -6), c, 1.2); draw_line(Vector2(0, 6), Vector2(0, 10), c, 1.2)
			2: # 月
				draw_arc(Vector2.ZERO, 6, 0.6, TAU - 0.6, 14, c, 1.2, true); draw_arc(Vector2(3, 0), 4.6, 2.0, 4.3, 10, c, 1.2, true)
			3: # 星
				var pts = PackedVector2Array()
				for i in 11: var a = -PI / 2 + i * TAU / 10; pts.append(Vector2(cos(a), sin(a)) * (6.0 if i % 2 == 0 else 2.6))
				draw_polyline(pts, c, 1.1, true)
			4: # 元寶
				draw_polyline(PackedVector2Array([Vector2(-8, 0), Vector2(-5, 4), Vector2(5, 4), Vector2(8, 0), Vector2(4, 1), Vector2(0, -4), Vector2(-4, 1), Vector2(-8, 0)]), c, 1.2, true)
			5: # 對話框
				draw_polyline(PackedVector2Array([Vector2(-7, -5), Vector2(7, -5), Vector2(7, 3), Vector2(-1, 3), Vector2(-5, 7), Vector2(-4, 3), Vector2(-7, 3), Vector2(-7, -5)]), c, 1.2, true)
		draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

# 跌爛咗嘅玻璃
class Crack extends Control:
	func _ready() -> void: mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		var rng = RandomNumberGenerator.new(); rng.seed = 247
		var o = Vector2(size.x * 0.62, size.y * 0.38)
		var c = Color(1, 1, 1, 0.55)
		for i in 13:
			var a = i * TAU / 13 + rng.randf() * 0.4; var p = o; var pts = PackedVector2Array([p])
			for j in 5:
				p += Vector2(cos(a), sin(a)) * (30 + rng.randf() * 70); a += rng.randf_range(-0.35, 0.35); pts.append(p)
			draw_polyline(pts, c, 1.3 if i % 3 else 2.0, true)
		for k in 3:
			var pts2 = PackedVector2Array()
			for i in 15: var a = i * TAU / 14; pts2.append(o + Vector2(cos(a), sin(a)) * (22 + k * 38 + rng.randf() * 14))
			draw_polyline(pts2, Color(1, 1, 1, 0.3), 1.0, true)
		draw_circle(o, 6, Color(1, 1, 1, 0.35))

# ====================================================================
# 主體
# ====================================================================
var phase = "pre"
var on_enter = Callable()       # 主列表撳主對話
var on_done = Callable()        # 劇情對話完
var on_skip = Callable()
var view: Control
var list_box: VBoxContainer
var chip_on = 0
var chats: Array = []
var body_scroll: ScrollContainer
var body: VBoxContainer
var sub_lbl: Label
var field: PanelContainer
var field_txt: Label
var send_btn: Control
var send_ic: TextureRect
var tap_pill: Control
var send_tw: Tween
var last_kind = ""
static var read_marks = {}      # 已經睇過嘅對話（未讀變已讀）

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	clip_contents = true
	_load_marks()

func _snd(n: String) -> void:
	var s = J.G.get("Sound")
	if s is Dictionary and s.has("play"): J.mc(s, "play", [n])

func _clear_view() -> void:
	_tok += 1
	for c in get_children(): c.queue_free()
	view = null; body = null; body_scroll = null; sub_lbl = null; field = null; send_btn = null; tap_pill = null

func _pre() -> bool: return phase == "pre"

# ---------------- 主列表 ----------------
func show_home(ph: String) -> void:
	phase = ph
	_clear_view()
	if _pre(): chats = _arr(J.G.get("CHATS_PRE"))
	else: chats = _arr(J.cl(J.G.get("chatsPost"), null, []))
	view = VBoxContainer.new(); view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); view.add_theme_constant_override("separation", 0)
	var bgc = ColorRect.new(); bgc.color = BG; bgc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bgc.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bgc)
	add_child(view)
	view.add_child(StatusBar.new("02:13" if _pre() else now_hm(), "3%" if _pre() else "∞", _pre(), BG))
	# 頂欄
	var top = HBoxContainer.new(); top.add_theme_constant_override("separation", 18)
	var tm = MarginContainer.new(); _margins(tm, 16, 10, 16, 8); tm.add_child(top); view.add_child(tm)
	var ttl = lab("WhatsApp", 23, TXT, 700); top.add_child(ttl)
	if not _pre():
		var hell = PanelContainer.new(); hell.add_theme_stylebox_override("panel", UIKit.sb(Color("#c2362b"), 3, Color(0, 0, 0, 0), 0, Vector4(6, 1, 6, 1)))
		hell.add_child(lab("陰間版", 11, Color.WHITE, 900)); hell.rotation = deg_to_rad(-6); hell.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top.add_child(hell); top.add_theme_constant_override("separation", 10)
	var sp = Control.new(); sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sp.mouse_filter = Control.MOUSE_FILTER_IGNORE; top.add_child(sp)
	var snd = Button.new(); snd.flat = true; snd.focus_mode = Control.FOCUS_NONE
	snd.add_theme_font_size_override("font_size", 17); snd.add_theme_font_override("font", F(400))
	snd.text = "🔊" if _sound_on() else "🔇"
	snd.pressed.connect(func():
		var s = J.G.get("Sound"); var on = J.t(J.mc(s, "toggle", [])) if s is Dictionary else false
		snd.text = "🔊" if on else "🔇")
	top.add_child(snd)
	top.add_child(icon_rect("cam", ICONC)); top.add_child(icon_rect("dots", ICONC))
	# 搜尋
	var sm = MarginContainer.new(); _margins(sm, 14, 2, 14, 8); view.add_child(sm)
	var search = PanelContainer.new(); search.add_theme_stylebox_override("panel", UIKit.sb(THEM, 22, Color(0, 0, 0, 0), 0, Vector4(14, 9, 14, 9)))
	search.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shb = HBoxContainer.new(); shb.add_theme_constant_override("separation", 12); search.add_child(shb)
	shb.add_child(icon_rect("search", SUB, 19)); shb.add_child(lab("在 WhatsApp 中搜尋…", 15, SUB))
	sm.add_child(search)
	# 篩選
	var cm = MarginContainer.new(); _margins(cm, 14, 0, 14, 6); view.add_child(cm)
	var chips = HBoxContainer.new(); chips.add_theme_constant_override("separation", 8); cm.add_child(chips)
	var nun = 0
	for c in chats: if _unread(c) > 0: nun += 1
	var chip_names = ["全部", "未讀 %d" % nun if nun > 0 else "未讀", "群組"]
	for i in 3:
		var ch = Button.new(); ch.text = chip_names[i]; ch.focus_mode = Control.FOCUS_NONE
		ch.add_theme_font_override("font", F(600 if i == chip_on else 400)); ch.add_theme_font_size_override("font_size", 14)
		var on = i == chip_on
		var st = UIKit.sb(Color("#103529") if on else THEM, 16, Color(0, 0, 0, 0), 0, Vector4(13, 5, 13, 5))
		for k in ["normal", "hover", "pressed", "focus"]: ch.add_theme_stylebox_override(k, st)
		var fc = Color("#d9fdd3") if on else SUB
		for k in ["font_color", "font_hover_color", "font_pressed_color"]: ch.add_theme_color_override(k, fc)
		ch.pressed.connect(func(): chip_on = i; _snd("click"); show_home(phase))
		chips.add_child(ch)
	# 列表
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	sc.mouse_filter = Control.MOUSE_FILTER_PASS
	view.add_child(sc)
	list_box = VBoxContainer.new(); list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL; list_box.add_theme_constant_override("separation", 0)
	sc.add_child(list_box)
	var shown = 0
	for c in chats:
		if chip_on == 1 and _unread(c) <= 0: continue
		if chip_on == 2 and not (str(c.get("sub", "")) != "" or str(_av_letter(c)) == "群"): continue
		list_box.add_child(_row(c)); shown += 1
	if shown == 0:
		var e = lab("冇未讀訊息" if chip_on == 1 else "冇群組", 14, SUB); e.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; e.custom_minimum_size.y = 80; e.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		list_box.add_child(e)
	var lk = HBoxContainer.new(); lk.alignment = BoxContainer.ALIGNMENT_CENTER; lk.add_theme_constant_override("separation", 5)
	lk.add_child(icon_rect("lock", SUB, 12))
	lk.add_child(lab("你的個人訊息已受" if _pre() else "訊息已陰陽兩界加密，", 12, SUB))
	lk.add_child(lab("端對端加密" if _pre() else "活人看不到", 12, GREEN))
	lk.add_child(lab("保護" if _pre() else "", 12, SUB))
	var lkm = MarginContainer.new(); _margins(lkm, 0, 16, 0, 100); lkm.add_child(lk); list_box.add_child(lkm)
	# 新對話按鈕
	var fab = Panel.new(); var fs = UIKit.sb(GREEN, 16); fs.shadow_color = Color(0, 0, 0, 0.35); fs.shadow_size = 6; fs.shadow_offset = Vector2(0, 3)
	fab.add_theme_stylebox_override("panel", fs)
	fab.anchor_left = 1; fab.anchor_right = 1; fab.anchor_top = 1; fab.anchor_bottom = 1
	fab.offset_left = -74; fab.offset_right = -18; fab.offset_top = -80 - _safe_bottom(); fab.offset_bottom = -24 - _safe_bottom()
	var fi = icon_rect("chat", Color("#111b21"), 26); fi.set_anchors_and_offsets_preset(Control.PRESET_CENTER); fi.offset_left = -13; fi.offset_top = -13; fi.offset_right = 13; fi.offset_bottom = 13
	fab.add_child(fi); add_child(fab)
	fab.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed: _snd("click"); _fab_bounce(fab))

func _fab_bounce(fab: Control) -> void:
	fab.pivot_offset = fab.size / 2
	var tw = fab.create_tween(); tw.tween_property(fab, "scale", Vector2(0.9, 0.9), 0.08); tw.tween_property(fab, "scale", Vector2.ONE, 0.12)

func _row(c: Dictionary) -> Control:
	var main_ = J.t(c.get("main", false))
	var un = _unread(c)
	var row = PanelContainer.new(); row.mouse_filter = Control.MOUSE_FILTER_PASS
	var nst = StyleBoxFlat.new(); nst.bg_color = Color(0, 0, 0, 0); nst.content_margin_left = 16; nst.content_margin_right = 16; nst.content_margin_top = 9; nst.content_margin_bottom = 0
	row.add_theme_stylebox_override("panel", nst)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 13); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; row.add_child(hb)
	var avw = Control.new(); avw.custom_minimum_size = Vector2(54, 54); avw.mouse_filter = Control.MOUSE_FILTER_IGNORE; avw.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var av = Avatar.new(c.get("av"), 50.0, main_); av.position = Vector2(2, 2); avw.add_child(av); hb.add_child(avw)
	var mid = VBoxContainer.new(); mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL; mid.add_theme_constant_override("separation", 3); mid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(mid)
	var l1 = HBoxContainer.new(); l1.add_theme_constant_override("separation", 8); l1.mouse_filter = Control.MOUSE_FILTER_IGNORE; mid.add_child(l1)
	var nm = lab(str(c.get("name", "")), 16, TXT, 600); nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL; nm.clip_text = true; nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	l1.add_child(nm)
	var hot = un > 0 and not J.t(c.get("mute", false))
	var tml = lab(str(c.get("time", "")), 12, GREEN if hot else SUB, 600 if hot else 400); tml.size_flags_vertical = Control.SIZE_SHRINK_END
	l1.add_child(tml)
	var l2 = HBoxContainer.new(); l2.add_theme_constant_override("separation", 5); l2.mouse_filter = Control.MOUSE_FILTER_IGNORE; l2.custom_minimum_size.y = 22; mid.add_child(l2)
	if J.t(c.get("mine", false)):
		var tk = Ticks.new(true, BLUE); tk.size_flags_vertical = Control.SIZE_SHRINK_CENTER; l2.add_child(tk)
	var pv = lab(str(c.get("prev", "")), 14, SUB); pv.size_flags_horizontal = Control.SIZE_EXPAND_FILL; pv.clip_text = true; pv.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	if main_ and un > 0: pv.add_theme_color_override("font_color", Color("#d1d7db"))
	l2.add_child(pv)
	if J.t(c.get("pin", false)): l2.add_child(icon_rect("pin", SUB, 16))
	if J.t(c.get("mute", false)): l2.add_child(icon_rect("mute", SUB, 16))
	if un > 0:
		var badge = PanelContainer.new()
		var muted = J.t(c.get("mute", false)) and not main_
		var bs = UIKit.sb(Color("#667781") if muted else GREEN, 11, Color(0, 0, 0, 0), 0, Vector4(6, 0, 6, 0))
		badge.add_theme_stylebox_override("panel", bs); badge.custom_minimum_size = Vector2(21, 21); badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var bl = lab(str(un), 12, Color("#111b21"), 700); bl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; bl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		badge.add_child(bl); l2.add_child(badge)
		if main_:
			badge.resized.connect(func(): badge.pivot_offset = badge.size / 2)
			var tw = badge.create_tween().set_loops()
			tw.tween_property(badge, "scale", Vector2(1.18, 1.18), 0.6).set_trans(Tween.TRANS_SINE)
			tw.tween_property(badge, "scale", Vector2.ONE, 0.6).set_trans(Tween.TRANS_SINE)
	var line = ColorRect.new(); line.color = Color("#222d34"); line.custom_minimum_size.y = 1; line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var lm = MarginContainer.new(); _margins(lm, 0, 9, 0, 0); lm.add_child(line); lm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mid.add_child(lm)
	var press = [Vector2.ZERO, false]
	row.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed: press[0] = e.global_position; press[1] = true; nst.bg_color = THEM; row.queue_redraw()
			else:
				nst.bg_color = Color(0, 0, 0, 0); row.queue_redraw()
				if press[1] and e.global_position.distance_to(press[0]) < 12:
					_snd("click"); _open(c)
				press[1] = false
		elif e is InputEventMouseMotion and press[1] and e.global_position.distance_to(press[0]) >= 12:
			press[1] = false; nst.bg_color = Color(0, 0, 0, 0); row.queue_redraw())
	return row

func _open(c: Dictionary) -> void:
	if J.t(c.get("main", false)):
		if on_enter.is_valid(): on_enter.call(phase)
		return
	show_chat(c)

# ---------------- 對話紀錄（非主線）----------------
func show_chat(c: Dictionary) -> void:
	var un = _unread(c)
	_build_chat(str(c.get("name", "")), c.get("av"), str(c.get("sub", "")) if str(c.get("sub", "")) != "" else ("最後上線時間：今天 01:58" if _pre() else "最後上線時間：很久以前"), false)
	var msgs: Array = _arr(c.get("msgs", []))
	var group = str(c.get("sub", "")) != ""
	var last_day = ""; var prev_who = ""
	var first_unread = msgs.size()
	var theirs = 0
	for m in msgs: if str(m[0]) != "我": theirs += 1
	un = mini(un, theirs)
	if un > 0:
		var cnt = 0; var i = msgs.size() - 1
		while i >= 0 and cnt < un:
			if str(msgs[i][0]) != "我": cnt += 1
			first_unread = i; i -= 1
	for i in msgs.size():
		var m = msgs[i]; var who = str(m[0]); var when = str(m[1]); var text = DB.L(str(m[2]))
		var day = when.split(" ")[0]
		if when.contains(" ") and day != last_day:
			_add(_day(day)); last_day = day; prev_who = ""
		if i == first_unread and un > 0:
			_add(_unread_bar(un)); prev_who = ""
		var tm = when.split(" ")[1] if when.contains(" ") else when
		var me = who == "我"
		_add(Bubble.new("me" if me else "them", who if group and not me else "", text, tm, 3 if me else 0, prev_who != who, _maxw()))
		prev_who = who
	var hold = str(c.get("hold", ""))
	field.get_meta("txt").text = DB.L(hold) if hold != "" else "輸入訊息"
	if hold != "": field_txt.add_theme_font_size_override("font_size", 14)
	_mark_read(c)
	_scroll_end(false)

func _back() -> void:
	_snd("click"); show_home(phase)

# ---------------- 劇情即時對話 ----------------
var sc_: Dictionary
var sid = ""
var li = 0
var wait = ""
var fast = Callable()
var last_mine: Bubble = null
var chat_prev_who = ""
var _tok = 0

func start_scene(sc: Dictionary, id: String, done: Callable, skip: Callable) -> void:
	sc_ = sc; sid = id; on_done = done; on_skip = skip
	var pro = id == "prologue_chat"
	phase = "pre" if pro else "post"
	var group = str(sc.get("group", ""))
	_build_chat(DB.L(str(sc.get("title", ""))), sc.get("av", ["?", "#555"]), group if group != "" else "在線上", true, "02:13" if pro else now_hm(), "3%" if pro else "∞", pro)
	_add(_day("今天"))
	li = 0; wait = ""; last_mine = null; chat_prev_who = ""
	_show_line()

func _line() -> Array:
	var raw = DB.L(str(sc_.lines[li][1])); var tm = ""
	var rx = RegEx.create_from_string("^(\\d\\d:\\d\\d)\\|([\\s\\S]*)$")
	var m = rx.search(raw)
	if m: tm = m.get_string(1); raw = m.get_string(2)
	return [str(sc_.lines[li][0]), raw, tm if tm != "" else now_hm()]

func _show_line() -> void:
	var l = _line(); _chat_line(l[0], l[1], l[2])

func _next_line() -> void:
	li += 1
	if li >= sc_.lines.size(): _chat_end(); return
	_show_line()

func _after(sec: float, f: Callable) -> void:
	var tok = _tok
	var t = Timer.new(); t.one_shot = true; t.wait_time = maxf(sec, 0.01); add_child(t)
	t.timeout.connect(func():
		t.queue_free()
		if tok == _tok: f.call())
	t.start()

func _cancel() -> void: _tok += 1

func _chat_line(who: String, text: String, tm: String) -> void:
	wait = ""; fast = Callable(); _cancel()
	var group = str(sc_.get("group", ""))
	if who == "阿福":
		var n = [0]
		field_txt.text = ""; field_txt.add_theme_color_override("font_color", TXT)
		var await_send = func():
			_cancel(); field_txt.text = text; send_ic.texture = icon("send", Color("#111b21"), 24); wait = "send"; _pulse_send(true)
		var step = [Callable()]
		step[0] = func():
			n[0] += 1; field_txt.text = text.substr(0, n[0]); _snd("key")
			if n[0] == 1: send_ic.texture = icon("send", Color("#111b21"), 24)
			if n[0] < text.length(): _after(0.055, step[0])
			else: await_send.call()
		fast = await_send
		_after(0.35, step[0])
		return
	if who == "旁白":
		_add(Bubble.new("mid", "", text, "", 0, false, _maxw()), true); chat_prev_who = ""
		_after(1.3, _next_line); fast = func(): _cancel(); _next_line()
		return
	var arrive = func():
		_cancel()
		sub_lbl.text = group if group != "" else "在線上"; sub_lbl.add_theme_color_override("font_color", SUB)
		if last_mine != null: last_mine.set_tick(3); last_mine = null
		_add(Bubble.new("them", who if group != "" else "", text, tm, 0, chat_prev_who != who, _maxw()), true)
		chat_prev_who = who
		_snd("waIn")
		_after(minf(1.8, 0.7 + text.length() * 0.022), _next_line)
		fast = func(): _cancel(); _next_line()
	if li == 0: arrive.call(); return
	sub_lbl.text = (who + " 正在輸入…") if group != "" else "正在輸入…"; sub_lbl.add_theme_color_override("font_color", GREEN)
	_after(minf(1.6, 0.45 + text.length() * 0.03), arrive)
	fast = arrive

func _send() -> void:
	wait = ""; _pulse_send(false)
	var l = _line()
	send_ic.texture = icon("mic", Color("#111b21"), 24)
	field_txt.text = "輸入訊息"; field_txt.add_theme_color_override("font_color", SUB)
	_snd("waOut")
	var b = Bubble.new("me", "", l[1], l[2], 1, chat_prev_who != "阿福", _maxw())
	_add(b, true); last_mine = b; chat_prev_who = "阿福"
	# ✓ 已傳送 →（0.6 秒）✓✓ 已送達 →（對方睇咗）藍色 ✓✓ 已讀
	_after(0.6, func():
		b.set_tick(2)
		_after(0.65, _next_line))
	fast = Callable()

func _chat_end() -> void:
	fast = Callable()
	if str(sc_.get("end", "")) == "crash":
		wait = "crash"
		var tok = _tok
		_after(0.9, func():
			if last_mine != null: last_mine.set_tick(3); last_mine = null
			sub_lbl.text = "正在輸入…"; sub_lbl.add_theme_color_override("font_color", GREEN))
		_after(2.2, func(): _snd("heartbeat"); _flash(0.25))
		_after(3.0, func(): _snd("heartbeat"); _flash(0.4); _drop())
		_after(3.7, func(): _snd("flatline"); _die())
		_after(7.2, func(): _finish())
		return
	wait = "end"
	if tap_pill: tap_pill.visible = true

func _finish() -> void:
	wait = ""; _cancel()
	if on_done.is_valid(): var f = on_done; on_done = Callable(); f.call()

func advance(in_input := false) -> void:
	if wait == "crash": return
	if wait == "end": _finish(); return
	if wait == "send":
		if in_input: _send()
		else: _nudge()
		return
	if fast.is_valid(): var f = fast; fast = Callable(); f.call()

func _gui_input(e: InputEvent) -> void:
	if body == null or not is_story: return
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		var in_input = field != null and field.get_parent().get_global_rect().has_point(e.global_position)
		advance(in_input); accept_event()

func _pulse_send(on: bool) -> void:
	if send_tw: send_tw.kill(); send_tw = null
	send_btn.scale = Vector2.ONE; send_btn.set_meta("glow", 0.0); send_btn.queue_redraw()
	if not on: return
	send_btn.pivot_offset = send_btn.size / 2
	send_tw = send_btn.create_tween().set_loops()
	send_tw.tween_method(func(v): send_btn.scale = Vector2.ONE * (1.0 + 0.06 * v); send_btn.set_meta("glow", v); send_btn.queue_redraw(), 0.0, 1.0, 0.8).set_trans(Tween.TRANS_SINE)
	send_tw.tween_method(func(v): send_btn.scale = Vector2.ONE * (1.0 + 0.06 * v); send_btn.set_meta("glow", v); send_btn.queue_redraw(), 1.0, 0.0, 0.8).set_trans(Tween.TRANS_SINE)

func _nudge() -> void:
	if send_btn.has_meta("nudging"): return
	send_btn.set_meta("nudging", 1)
	var bx = send_btn.position.x
	var tw = send_btn.create_tween()
	for d in [-5.0, 5.0, -3.0, 0.0]: tw.tween_property(send_btn, "position:x", bx + d, 0.06)
	tw.tween_callback(func(): send_btn.remove_meta("nudging"))
	_snd("click")

func _flash(a: float) -> void:
	var f = ColorRect.new(); f.color = Color(0.6, 0, 0, a); f.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); f.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(f); var tw = f.create_tween(); tw.tween_property(f, "color:a", 0.0, 0.35); tw.tween_callback(f.queue_free)

func _drop() -> void:
	view.pivot_offset = view.size / 2
	var tw = view.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(view, "position", Vector2(-6, 10), 0.2); tw.parallel().tween_property(view, "rotation", deg_to_rad(-2.5), 0.2)
	tw.tween_property(view, "position", Vector2(-3, 26), 0.3); tw.parallel().tween_property(view, "rotation", deg_to_rad(-1.2), 0.3)
	var ck = Crack.new(); ck.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); view.add_child(ck)
	ck.modulate.a = 0; ck.create_tween().tween_property(ck, "modulate:a", 1.0, 0.08)

func _die() -> void:
	var tw = view.create_tween()
	tw.tween_property(view, "modulate", Color(0.35, 0.33, 0.33), 2.0)
	tw.tween_property(view, "modulate", Color(0, 0, 0), 1.4)

# ---------------- 對話畫面骨架 ----------------
var is_story = false
func _build_chat(title: String, av, sub: String, story: bool, time := "", batt := "", low := false) -> void:
	_clear_view(); is_story = story
	if time == "": time = "02:13" if _pre() else now_hm()
	if batt == "": batt = "3%" if _pre() else "∞"; low = _pre()
	view = VBoxContainer.new(); view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); view.add_theme_constant_override("separation", 0)
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(view)
	view.add_child(StatusBar.new(time, batt, low, BAR))
	var head = PanelContainer.new(); head.add_theme_stylebox_override("panel", UIKit.sb(BAR, 0, Color(0, 0, 0, 0), 0, Vector4(4, 6, 10, 8)))
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	view.add_child(head)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); head.add_child(hb)
	var back = icon_rect("back", TXT, 26); back.mouse_filter = Control.MOUSE_FILTER_STOP
	if not story: back.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: _back())
	hb.add_child(back)
	hb.add_child(Avatar.new(av, 38.0))
	var who = VBoxContainer.new(); who.size_flags_horizontal = Control.SIZE_EXPAND_FILL; who.add_theme_constant_override("separation", 0); who.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var nm = lab(title, 16, TXT, 600); nm.clip_text = true; nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; who.add_child(nm)
	sub_lbl = lab(sub, 12, SUB); sub_lbl.clip_text = true; sub_lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; who.add_child(sub_lbl)
	hb.add_child(who)
	hb.add_child(icon_rect("video", ICONC)); hb.add_child(icon_rect("call", ICONC, 21))
	if story:
		var sk = Button.new(); sk.text = "跳過 ▸▸"; sk.flat = true; sk.focus_mode = Control.FOCUS_NONE
		sk.add_theme_font_override("font", F(600)); sk.add_theme_font_size_override("font_size", 13)
		for k in ["font_color", "font_hover_color", "font_pressed_color"]: sk.add_theme_color_override(k, ICONC)
		sk.pressed.connect(func(): _cancel(); if on_skip.is_valid(): on_skip.call())
		hb.add_child(sk)
	else: hb.add_child(icon_rect("dots", ICONC))
	# 內容
	var holder = Control.new(); holder.size_flags_vertical = Control.SIZE_EXPAND_FILL; holder.mouse_filter = Control.MOUSE_FILTER_PASS; holder.clip_contents = true
	view.add_child(holder)
	var wp = Wallpaper.new(); wp.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); holder.add_child(wp)
	body_scroll = ScrollContainer.new(); body_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); body_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body_scroll.mouse_filter = Control.MOUSE_FILTER_PASS; body_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	holder.add_child(body_scroll)
	var bm = MarginContainer.new(); _margins(bm, 18, 8, 18, 44 if story else 10); bm.size_flags_horizontal = Control.SIZE_EXPAND_FILL; bm.mouse_filter = Control.MOUSE_FILTER_PASS
	body_scroll.add_child(bm)
	body = VBoxContainer.new(); body.add_theme_constant_override("separation", 2); body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; body.mouse_filter = Control.MOUSE_FILTER_PASS
	body.alignment = BoxContainer.ALIGNMENT_END
	bm.add_child(body)
	body_scroll.resized.connect(func(): bm.custom_minimum_size.y = body_scroll.size.y)
	var lk = HBoxContainer.new(); lk.add_theme_constant_override("separation", 4)
	var lock = PanelContainer.new(); lock.add_theme_stylebox_override("panel", UIKit.sb(MID, 8, Color(0, 0, 0, 0), 0, Vector4(10, 6, 10, 6)))
	lock.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; lock.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ltx = lab("🔒 " + ("訊息和通話皆已端對端加密。對話以外的人（包括 WhatsApp）都無法讀取或收聽。" if _pre() else "訊息已陰陽兩界加密。活人無法讀取，閻王都唔得。"), 12, Color("#ffd279"))
	ltx.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; ltx.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; ltx.custom_minimum_size.x = 290
	lock.add_child(ltx); body.add_child(lock)
	var gap = Control.new(); gap.custom_minimum_size.y = 4; gap.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(gap)
	if story:
		tap_pill = Pill.new("點擊繼續 ▸", TXT, Color(0.07, 0.1, 0.13, 0.9), 13)
		tap_pill.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM); tap_pill.offset_top = -38; tap_pill.offset_bottom = -10; tap_pill.offset_left = -60; tap_pill.offset_right = 60
		tap_pill.visible = false; holder.add_child(tap_pill)
		var tw = tap_pill.create_tween().set_loops(); tw.tween_property(tap_pill, "modulate:a", 0.55, 0.7); tw.tween_property(tap_pill, "modulate:a", 1.0, 0.7)
	# 輸入欄
	var ib = PanelContainer.new(); ib.add_theme_stylebox_override("panel", UIKit.sb(CHATBG, 0, Color(0, 0, 0, 0), 0, Vector4(6, 6, 6, 8 + _safe_bottom())))
	ib.mouse_filter = Control.MOUSE_FILTER_PASS
	view.add_child(ib)
	var ih = HBoxContainer.new(); ih.add_theme_constant_override("separation", 6); ib.add_child(ih)
	field = PanelContainer.new(); field.add_theme_stylebox_override("panel", UIKit.sb(BAR, 24, Color(0, 0, 0, 0), 0, Vector4(12, 6, 14, 6)))
	field.size_flags_horizontal = Control.SIZE_EXPAND_FILL; field.custom_minimum_size.y = 48; field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ih.add_child(field)
	var fh = HBoxContainer.new(); fh.add_theme_constant_override("separation", 10); field.add_child(fh)
	var sm = icon_rect("smile", SUB, 24); sm.size_flags_vertical = Control.SIZE_SHRINK_END; fh.add_child(sm)
	field_txt = lab("輸入訊息", 16, SUB); field_txt.size_flags_horizontal = Control.SIZE_EXPAND_FILL; field_txt.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	field_txt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; field_txt.custom_minimum_size.y = 34; field_txt.max_lines_visible = 4
	fh.add_child(field_txt); field.set_meta("txt", field_txt)
	var cl = icon_rect("clip", SUB, 22); cl.size_flags_vertical = Control.SIZE_SHRINK_END; cl.rotation = deg_to_rad(-40); cl.pivot_offset = Vector2(11, 11); fh.add_child(cl)
	var cm = icon_rect("cam", SUB, 22); cm.size_flags_vertical = Control.SIZE_SHRINK_END; fh.add_child(cm)
	send_btn = Control.new(); send_btn.custom_minimum_size = Vector2(48, 48); send_btn.size_flags_vertical = Control.SIZE_SHRINK_END; send_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	send_btn.draw.connect(func():
		var g = float(send_btn.get_meta("glow", 0.0))
		if g > 0: send_btn.draw_circle(Vector2(24, 24), 24 + 7 * g, Color(0, 0.66, 0.52, 0.3 * g))
		send_btn.draw_circle(Vector2(24, 24), 24, GREEN))
	send_ic = icon_rect("mic", Color("#111b21"), 24); send_ic.position = Vector2(12, 12); send_ic.size = Vector2(24, 24)
	send_btn.add_child(send_ic); ih.add_child(send_btn)

func _add(n: Control, pop := false) -> void:
	body.add_child(n)
	if pop:
		n.modulate.a = 0.0; n.scale = Vector2(0.9, 0.9)
		var tw = n.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tw.tween_property(n, "modulate:a", 1.0, 0.18); tw.parallel().tween_property(n, "scale", Vector2.ONE, 0.18)
	_scroll_end(pop)

func _scroll_end(smooth: bool) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if body_scroll == null or not is_instance_valid(body_scroll): return
	var to = int(body_scroll.get_v_scroll_bar().max_value)
	if smooth: body_scroll.create_tween().tween_property(body_scroll, "scroll_vertical", to, 0.22).set_trans(Tween.TRANS_QUAD)
	else: body_scroll.scroll_vertical = to

func _day(t: String) -> Control:
	var m = MarginContainer.new(); _margins(m, 0, 8, 0, 6); m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(Pill.new(t, SUB, MID, 12)); return m

func _unread_bar(n: int) -> Control:
	var m = MarginContainer.new(); _margins(m, -18, 8, -18, 6); m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var strip = PanelContainer.new(); strip.add_theme_stylebox_override("panel", UIKit.sb(Color(0.07, 0.1, 0.13, 0.75), 0, Color(0, 0, 0, 0), 0, Vector4(0, 4, 0, 4)))
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	strip.add_child(Pill.new("%d 則未讀訊息" % n, TXT, MID, 12)); m.add_child(strip); return m

func _maxw() -> float: return minf(size.x if size.x > 0 else 390.0, 520.0) * 0.8 - 8

func _margins(m: MarginContainer, l: int, t: int, r: int, b: int) -> void:
	m.add_theme_constant_override("margin_left", l); m.add_theme_constant_override("margin_top", t)
	m.add_theme_constant_override("margin_right", r); m.add_theme_constant_override("margin_bottom", b)

func _safe_bottom() -> int:
	return 0

func _sound_on() -> bool:
	var s = J.G.get("Sound")
	return J.t(J.mc(s, "isOn", [])) if s is Dictionary and s.has("isOn") else false

func _arr(v) -> Array:
	if v is Array: return v
	return []

func _av_letter(c: Dictionary) -> String:
	var a = c.get("av"); return str(a[0]) if a is Array else ""

# ---------------- 已讀／未讀 ----------------
func _unread(c: Dictionary) -> int:
	var u = int(J.num(c.get("unread", 0))) if c.get("unread") != null else 0
	if u <= 0: return 0
	if J.t(c.get("main", false)): return u
	var key = phase + ":" + str(c.get("id", ""))
	if read_marks.get(key, -1) == _arr(c.get("msgs", [])).size(): return 0
	return u

func _mark_read(c: Dictionary) -> void:
	read_marks[phase + ":" + str(c.get("id", ""))] = _arr(c.get("msgs", [])).size()
	if phase != "pre": _save_marks()

const MARK_KEY := "ghostBattles_waRead"
func _load_marks() -> void:
	if not read_marks.is_empty(): return
	var raw = JSRun.ls.get(MARK_KEY)
	if raw is String:
		var o = JSON.parse_string(raw)
		if o is Dictionary: for k in o: read_marks[k] = int(o[k])

func _save_marks() -> void:
	var o = {}
	for k in read_marks: if not str(k).begins_with("pre:"): o[k] = read_marks[k]
	JSRun.ls[MARK_KEY] = JSON.stringify(o); JSRun.flush_ls()
