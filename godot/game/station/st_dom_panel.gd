# 陽間站崗：把 DOM 彈出框（#stt-pick 揀設備／有名鬼、#sq-post 網紅組帖文）原生化
#  做法：直接讀 street.js 砌好嘅 El 樹（同一份 innerHTML），逐個元素轉做 Godot 控件；
#  掣照叫返 El 嘅 onclick（規則、扣錢、存檔全部仲係 JS），canvas 照用佢錄低嘅畫（頭像、設備圖）。
#  JS 重新砌（innerHTML 改咗）就重建；El 被移走（el.remove()）就自己收起。
class_name StDomPanel
extends Control

var el = null          # 根 El（#stt-pick 或者 #sq-post）
var Tf = null
var sig := ""
var box: PanelContainer
var body: VBoxContainer
var scroll: ScrollContainer
var _live: Array = []  # [El, Label/Rich] 要每幀跟住更新文字（例如帖文 like 數）
var _born := 0

const INK := Color("#f1e6d6")
const DIM := Color("#bfb3a2")
const GOLD := Color("#ffd27a")

static func T(y: String, z: String) -> String: return y if DB.lang == "yue" else z

func setup(root_el, tf, mode: String) -> void:
	el = root_el; Tf = tf; _born = Time.get_ticks_msec()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.5 if mode == "pick" else 0.0); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(dim)
	gui_input.connect(_bg_input)
	box = PanelContainer.new()
	var sb = UIKit.sb(Color(0.09, 0.07, 0.08, 0.97), 14, Color("#8a5a3a"), 2, Vector4(14, 12, 14, 12))
	sb.shadow_color = Color(0, 0, 0, 0.55); sb.shadow_size = 10
	box.add_theme_stylebox_override("panel", sb)
	box.anchor_left = 0.5; box.anchor_right = 0.5; box.anchor_top = 0.5; box.anchor_bottom = 0.5
	add_child(box)
	scroll = ScrollContainer.new(); scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; box.add_child(scroll)
	body = VBoxContainer.new(); body.add_theme_constant_override("separation", 7); body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(body)
	if mode == "post":
		box.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: _click_root())
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	rebuild()

func _bg_input(e: InputEvent) -> void:
	# 只係撳框外先當「撳背景」（框入面嘅字／卡會將事件傳上嚟）
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		if box.get_global_rect().has_point(e.global_position): return
		_click_root()

# 撳外面：照 JS「e.target === el 就收起」
func _click_root() -> void:
	if el == null: return
	var ev = {"type": "click", "target": el, "currentTarget": el, "preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}
	el.fire("click", ev)

func alive() -> bool:
	return el != null and el.parentNode != null and not (" " + J.str(el.get("className")) + " ").contains(" out ")

func _process(_dt: float) -> void:
	if not alive(): queue_free(); return
	var s = J.str(el.props.get("innerHTML", ""))
	if s != sig: rebuild()
	for it in _live:
		var t = _bb(it[0])
		if it[1].text != t: it[1].text = t
	_layout()

func _layout() -> void:
	var vs = get_viewport_rect().size
	var w = minf(vs.x - 24, 380.0)
	var need = body.get_combined_minimum_size().y + 26
	var h = minf(need, vs.y * 0.82)
	scroll.custom_minimum_size = Vector2(w - 28, h - 24)
	box.offset_left = -w / 2; box.offset_right = w / 2; box.offset_top = -h / 2; box.offset_bottom = h / 2

func rebuild() -> void:
	sig = J.str(el.props.get("innerHTML", ""))
	_live.clear()
	for c in body.get_children(): c.queue_free()
	for ch in el.children: _add(body, ch)
	_layout()

# ---------------- El → 控件 ----------------
const INLINE := ["#TEXT", "B", "STRONG", "SMALL", "I", "EM", "SPAN", "BR", "U"]

func _is_inline(e) -> bool: return INLINE.has(e.tagName)

func _cls(e) -> Dictionary: return e.classList.d if e.classList else {}

func _add(parent: Control, e) -> void:
	if e.tagName == "#TEXT":
		var tx = J.str(e.props.get("textContent", "")).strip_edges()
		if tx != "": parent.add_child(_rich(tx, 13, INK))
		return
	if J.str(e.style.get("display", "")) == "none": return
	match e.tagName:
		"BUTTON": parent.add_child(_button(e)); return
		"CANVAS": parent.add_child(_canvas(e, 64.0)); return
		"IMG": var im = _img(e); if im: parent.add_child(im)
		"P", "B", "SMALL", "I", "EM", "SPAN", "STRONG":
			var r = _rich(_bb(e), 14 if e.tagName == "P" else 13, DIM if _cls(e).has("gp-note") else INK)
			if e.tagName == "SMALL" or _cls(e).has("sq-x"): r.add_theme_font_size_override("normal_font_size", 11); r.add_theme_color_override("default_color", DIM)
			parent.add_child(r)
			# 帖文 like 數：JS 逐幀改 <i> 文字
			if _has_live(e): _live.append([e, r]); r.set_meta("live_bb", true)
		_:
			_container(parent, e)

func _has_live(e) -> bool:
	for c in e.children:
		if c.tagName == "I" and c.props.has("data-n"): return true
		if c.tagName != "#TEXT" and _has_live(c): return true
	return false

func _container(parent: Control, e) -> void:
	var cl = _cls(e)
	var horiz = cl.has("stp-row") or cl.has("sq-h") or cl.has("sq-f") or cl.has("stp-top")
	var flow = cl.has("stp-two") or cl.has("stp-card2") and false
	# 卡片（有名鬼／二選一）：每個 stp-opt 一張小卡
	if cl.has("stp-opt"):
		var card = PanelContainer.new()
		var on = cl.has("on")
		card.add_theme_stylebox_override("panel", UIKit.sb(Color(0.16, 0.12, 0.1, 0.95), 10, Color("#ffd45a") if on else Color("#5a4632"), 2, Vector4(8, 8, 8, 8)))
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 3); card.add_child(v)
		_children_into(v, e, true)
		parent.add_child(card); return
	var box2: Container
	if flow or _opt_list(e):
		var g = HFlowContainer.new(); g.add_theme_constant_override("h_separation", 6); g.add_theme_constant_override("v_separation", 6); box2 = g
	elif horiz and _nbtn(e) > 3:
		# 好多粒掣（例如揀邊隻鬼加持）：兩欄
		var gc = GridContainer.new(); gc.columns = 2; gc.add_theme_constant_override("h_separation", 6); gc.add_theme_constant_override("v_separation", 6); box2 = gc
	elif horiz:
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); box2 = hb
	else:
		var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 5); box2 = vb
	box2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(box2)
	# 標題（stp-h）：大字
	if cl.has("stp-h"):
		var r = _rich("[b]" + _bb(e) + "[/b]", 16, GOLD); box2.add_child(r); return
	_children_into(box2, e, horiz)

func _nbtn(e) -> int:
	var n = 0
	for c in e.children: if c.tagName == "BUTTON": n += 1
	return n

func _opt_list(e) -> bool:
	var n = 0
	for c in e.children: if c.tagName != "#TEXT" and c.classList and c.classList.d.has("stp-opt"): n += 1
	return n >= 2

# 連續嘅 inline 元素併埋做一行 rich 字，其他照逐個加
func _children_into(parent: Control, e, _horiz: bool) -> void:
	var run: Array = []
	for c in e.children:
		if _is_inline(c): run.append(c); continue
		_flush(parent, run); run = []
		_add(parent, c)
	_flush(parent, run)

func _flush(parent: Control, run: Array) -> void:
	if run.is_empty(): return
	var s = ""
	for c in run: s += _bb_one(c)
	s = s.strip_edges()
	if s == "": return
	var r = _rich(s, 13, INK); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(r)
	for c in run: if _has_live(c) or (c.tagName == "I" and c.props.has("data-n")):
		var host = El.new("span"); host.children = run.duplicate(); _live.append([host, r]); break

func _plain_br(e) -> String:
	var o = ""
	for c in e.children:
		if c.tagName == "BR": o += "・"
		elif c.tagName == "#TEXT": o += J.str(c.props.get("textContent", ""))
		else: o += _plain_br(c)
	return o

func _bb(e) -> String:
	var s = ""
	for c in e.children: s += _bb_one(c)
	return s.strip_edges()

func _bb_one(c) -> String:
	match c.tagName:
		"#TEXT": return J.str(c.props.get("textContent", "")).replace("[", "［").replace("]", "］")
		"BR": return "\n"
		"B", "STRONG": return "[b]" + _bb(c) + "[/b]"
		"EM": return "[color=#ffd27a]" + _bb(c) + "[/color]"
		"SMALL": return "[font_size=11][color=#bfb3a2]" + _bb(c) + "[/color][/font_size]"
		"I": return "[i]" + _bb(c) + "[/i]"
		"SPAN":
			var cl = _cls(c)
			if cl.has("stp-ico"): return " [color=#9fe0b8]" + _bb(c) + "[/color] "
			return _bb(c) + " "
	return _bb(c)

func _rich(bb: String, fs: int, col: Color) -> RichTextLabel:
	var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false
	r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	r.add_theme_font_size_override("normal_font_size", fs); r.add_theme_font_size_override("bold_font_size", fs)
	r.add_theme_font_override("normal_font", UIKit.font("sans", 400)); r.add_theme_font_override("bold_font", UIKit.font("sans", 900))
	r.add_theme_color_override("default_color", col); r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.custom_minimum_size.x = 60
	r.text = bb
	return r

func _button(e) -> Button:
	var b = Button.new()
	var dis = e.props.has("disabled") and e.props.get("disabled") != false and e.props.get("disabled") != null
	var cl = _cls(e)
	var buy = cl.has("stp-buy")
	# 掣入面有 <small>（加持鬼力）就分兩行
	var main_t = ""; var sub_t = ""
	for c in e.children:
		if c.tagName == "SMALL": sub_t += _plain_br(c)
		else: main_t += c._text()
	b.text = main_t.strip_edges() + ("\n" + sub_t.strip_edges() if sub_t.strip_edges() != "" else "")
	b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 13)
	var bg = Color("#7a1c14") if buy else Color("#2a2420")
	var bd = Color("#e0a050") if buy else Color("#6a5a46")
	var s = UIKit.sb(bg, 9, bd, 2, Vector4(10, 6, 10, 6)); var sd = UIKit.sb(Color(0.2, 0.18, 0.17), 9, Color(0.3, 0.27, 0.25), 2, Vector4(10, 6, 10, 6))
	for k in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("disabled", sd); b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, INK)
	b.add_theme_color_override("font_disabled_color", Color(0.6, 0.56, 0.52))
	b.disabled = dis; b.focus_mode = Control.FOCUS_NONE
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.custom_minimum_size.y = 40
	var ee = e
	b.pressed.connect(func():
		if Time.get_ticks_msec() - _born < 250: return
		ee.fire("click")
		Snd.play("click"))
	return b

# canvas：照畫 JS 錄低嘅內容（頭像／設備圖）
func _canvas(e, sz: float) -> Control:
	var cw = J.num(e.get("width")); var ch = J.num(e.get("height"))
	if cw <= 0: cw = 80
	if ch <= 0: ch = 80
	var cv = Control.new(); var k = sz / maxf(cw, ch)
	cv.custom_minimum_size = Vector2(cw * k, ch * k); cv.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cv.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var ee = e
	cv.draw.connect(func():
		var c = Ctx.new(cv); c.drawImage(ee, 0, 0, cw * k, ch * k))
	return cv

# 帖文截圖：street.js 喺原生模式會將截圖畫布擺喺 Tf._sqShotCv（toDataURL 冇得用）
func _img(e) -> Control:
	var src = J.str(e.props.get("src", ""))
	var cv_el = Tf.get("_sqShotCv") if Tf is Dictionary and src == "nat" else null
	if cv_el == null: return null
	var cw = J.num(cv_el.get("width")); var ch = J.num(cv_el.get("height"))
	if cw <= 0 or ch <= 0: return null
	var w = 300.0; var h = w * ch / cw
	var cv = Control.new(); cv.custom_minimum_size = Vector2(w, h); cv.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cv.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	cv.draw.connect(func():
		var c = Ctx.new(cv); c.drawImage(cv_el, 0, 0, w, h))
	return cv
