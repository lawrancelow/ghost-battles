# 把一小段（已收埋嘅）DOM 照住畫成原生控件：唔排 CSS，靠一張「款式表」（按 #id／.class／tag 對）
# 規則全部留喺 JS：掣 → 叫返嗰粒 DOM 掣嘅 onclick／pointerdown；拉桿 → 改 value 再 fire("input")
# DOM 結構（tag／class／id／disabled）變咗先重砌；只係字變就原地更新（拉緊拉桿都唔會斷）
# 款式表每項：c 字色、s 字號、b 粗、serif、hide、row、grid（欄數）、box [底色, 圓角, 邊色, 邊寬, pad(Vector4)]、
#   btn（"gold"/"ghost"/""）、gap、expand、center、alpha、h（最少高）、pill（.on 時用 style --c 做底）
class_name DomMirror
extends VBoxContainer

var src: El = null
var sty: Dictionary = {}
var on_built: Callable
var _ver := -1
var _sig := ""
var _binds: Array = []   # [kind, El, Control]
var _sliding := false

static func L(s) -> String: return J.str(DB.L(J.str(s)))

func setup(root: El, style: Dictionary) -> void:
	src = root; sty = style; _ver = -1
	add_theme_constant_override("separation", 6)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

func sync(force := false) -> bool:
	if src == null: return false
	if not force and _ver == El.dom_ver: return false
	_ver = El.dom_ver
	var sig = _struct(src)
	if sig != _sig or force:
		_sig = sig; _rebuild(); return true
	_update(); return false

# ---------- 款式 ----------
func _st(e: El) -> Dictionary:
	var o = {}
	var t = e.tagName.to_lower()
	if sty.has(t): o.merge(sty[t], true)
	for c in e.classList.d.keys():
		if sty.has("." + c): o.merge(sty["." + c], true)
	if e.id_ != "" and sty.has("#" + e.id_): o.merge(sty["#" + e.id_], true)
	# 組合：「.父 tag」／「.類.類」
	# 「.祖先 tag」：遠嘅先，近嘅後（近嘅贏）
	var anc = []
	var p = e.parentNode
	while p is El and p != src and anc.size() < 6: anc.push_front(p); p = p.parentNode
	if p == src and src != null: anc.push_front(src)
	for a in anc:
		for c in a.classList.d.keys():
			var k = "." + c + " " + t
			if sty.has(k): o.merge(sty[k], true)
	for c in e.classList.d.keys():
		for c2 in e.classList.d.keys():
			if c != c2 and sty.has("." + c + "." + c2): o.merge(sty["." + c + "." + c2], true)
	return o

const INLINE := ["B", "I", "SMALL", "EM", "SPAN", "BR", "STRONG", "U", "#TEXT"]

func _is_inline(e: El) -> bool:
	if not (e.tagName in INLINE): return false
	var s = _st(e)
	return not (s.has("box") or s.has("row") or s.has("grid") or s.has("block"))

func _inline_only(e: El) -> bool:
	for c in e.children:
		if not _is_inline(c) or not _inline_only(c): return false
	return true

func _struct(e: El) -> String:
	if e.tagName == "#TEXT": return ""
	var o = e.tagName + "#" + e.id_ + "." + ",".join(e.classList.d.keys())
	if J.t(e.props.get("disabled")) and not (e.tagName == "BUTTON" and _inline_only(e)): o += "!"
	o += "("
	for c in e.children: o += _struct(c)
	return o + ")"

# ---------- 砌 ----------
func _rebuild() -> void:
	for c in get_children(): remove_child(c); c.queue_free()
	_binds.clear()
	_kids(src, self, _st(src))
	if on_built.is_valid(): on_built.call()

# 一個容器入面嘅細路：連續嘅 inline 併埋做一段字（row／grid 入面就逐個獨立）
func _kids(e: El, parent: Control, pst: Dictionary) -> void:
	var lone = pst.has("row") or pst.has("grid")
	var run: Array = []
	for c in e.children:
		if _st(c).get("hide", false): continue
		if not lone and _is_inline(c) and _inline_only(c):
			run.append(c); continue
		if run.size(): _text_run(run, parent, pst); run = []
		if c.tagName == "#TEXT":
			if J.str(c.props.get("textContent", "")).strip_edges() != "": _text_run([c], parent, pst)
			continue
		_node(c, parent, lone, pst)
	if run.size(): _text_run(run, parent, pst)

func _text_run(run: Array, parent: Control, pst: Dictionary) -> void:
	var bb = ""
	for c in run: bb += _bb(c)
	if bb.strip_edges() == "": return
	var r = _rich(pst); r.text = bb.strip_edges()
	parent.add_child(r)
	_binds.append(["run", run, r])

func _rich(st: Dictionary) -> RichTextLabel:
	var r = UIKit.rich("", int(st.get("s", 14)), st.get("c", Color("#eeeeee")), "serif" if st.get("serif", false) else "sans")
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if st.get("b", false): r.add_theme_font_override("normal_font", UIKit.font("serif" if st.get("serif", false) else "sans", 900))
	if st.has("lh"): r.add_theme_constant_override("line_separation", int(st.lh))
	return r

func _bb(e: El) -> String:
	if e.tagName == "#TEXT": return L(J.str(e.props.get("textContent", ""))).replace("[", "[lb]")
	if e.tagName == "BR": return "\n"
	var st = _st(e)
	if st.get("hide", false): return ""
	var inner = ""
	for c in e.children: inner += _bb(c)
	if e.tagName == "SMALL" and not st.has("inline"): inner = "\n" + inner
	if st.has("s"): inner = "[font_size=%d]%s[/font_size]" % [int(st.s), inner]
	if st.has("c"): inner = "[color=#%s]%s[/color]" % [Color(st.c).to_html(true), inner]
	if st.get("b", false) or (e.tagName in ["B", "STRONG"] and not st.has("b")): inner = "[b]%s[/b]" % inner
	if st.has("pad_r"): inner += " ".repeat(int(st.pad_r))
	return inner

func _wrap_box(st: Dictionary, parent: Control, inner: Control, expand: bool) -> Control:
	var host: Control = inner
	if st.has("box"):
		var bx = st.box
		var pc = PanelContainer.new()
		pc.add_theme_stylebox_override("panel", UIKit.sb(bx[0], bx[1], bx[2], bx[3], bx[4]))
		pc.add_child(inner); host = pc
		pc.mouse_filter = Control.MOUSE_FILTER_PASS
	if expand or st.get("expand", false): host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if st.has("alpha"): host.modulate.a = st.alpha
	if st.has("h"): host.custom_minimum_size.y = st.h
	if st.has("w"): host.custom_minimum_size.x = st.w
	parent.add_child(host)
	return host

func _node(e: El, parent: Control, lone: bool, pst: Dictionary) -> void:
	var st = _st(e)
	var expand = lone and (pst.has("grid") or st.get("expand", false))
	match e.tagName:
		"BUTTON":
			if not _inline_only(e):
				_card(e, st, parent, expand); return
			var b = UIKit.btn(L(e._text().strip_edges()), st.get("btn", "gold" if e.classList.d.has("gold") else ("ghost" if e.classList.d.has("ghost") else "")), e.classList.d.has("sm"))
			b.focus_mode = Control.FOCUS_NONE
			if st.has("bs"): _restyle(b, st.bs)
			if st.has("s"): b.add_theme_font_size_override("font_size", int(st.s))
			if st.has("c"): for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, st.c)
			if st.has("h"): b.custom_minimum_size.y = st.h
			b.disabled = J.t(e.props.get("disabled"))
			if expand or e.classList.d.has("wide") or st.get("expand", false):
				b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.clip_text = true
			b.button_down.connect(func(): _press(e, "pointerdown"))
			b.pressed.connect(func(): _press(e, "click"))
			parent.add_child(b)
			_binds.append(["btn", e, b])
		"INPUT":
			var sl = HSlider.new()
			sl.min_value = J.num(e.props.get("min", 0)); sl.max_value = J.num(e.props.get("max", 100)); sl.step = J.num(e.props.get("step", 1))
			sl.value = J.num(e.props.get("value", 0)); sl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			sl.size_flags_vertical = Control.SIZE_SHRINK_CENTER; sl.custom_minimum_size = Vector2(60, 30); sl.focus_mode = Control.FOCUS_NONE
			sl.add_theme_icon_override("grabber", _knob()); sl.add_theme_icon_override("grabber_highlight", _knob())
			sl.add_theme_stylebox_override("slider", UIKit.sb(Color("#3a3044"), 3, Color(0, 0, 0, 0), 0, Vector4(0, 3, 0, 3)))
			sl.add_theme_stylebox_override("grabber_area", UIKit.sb(Color("#c2362b"), 3, Color(0, 0, 0, 0), 0, Vector4(0, 3, 0, 3)))
			sl.add_theme_stylebox_override("grabber_area_highlight", UIKit.sb(Color("#d8473b"), 3, Color(0, 0, 0, 0), 0, Vector4(0, 3, 0, 3)))
			sl.value_changed.connect(func(v):
				if _sliding: return
				e.props["value"] = str(int(v)); El.dom_ver += 1; e.fire("input"))
			parent.add_child(sl)
			_binds.append(["slider", e, sl])
		"CANVAS":
			var cv = Control.new(); cv.set_script(load("res://ui/js_canvas_view.gd"))
			cv.bind(e); cv.mouse_filter = Control.MOUSE_FILTER_IGNORE
			cv.custom_minimum_size = Vector2(st.get("w", 80), st.get("h", 84))
			cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			parent.add_child(cv)
			if st.has("redraw"): cv.resized.connect(st.redraw)
		_:
			if _inline_only(e) and not (st.has("row") or st.has("grid")):
				var bb = ""
				for c in e.children: bb += _bb(c)
				var r = _rich(st); r.text = bb.strip_edges()
				if st.get("center", false): r.text = "[center]%s[/center]" % r.text
				if lone and not expand and not st.get("expand", false):
					# row 入面唔撐開嘅字：唔好摺行（否則闊度變 0 逐字摺）
					r.autowrap_mode = TextServer.AUTOWRAP_OFF; r.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
				var host = _wrap_box(_pill(e, st), parent, r, expand)
				if st.has("pill"): r.add_theme_color_override("default_color", Color("#1a1010") if e.classList.d.has("on") else st.get("c", Color("#8a8098")))
				_binds.append(["el", e, r, st.get("center", false)])
				if host != r: pass
				return
			var box: Container
			if st.has("grid"):
				var g = GridContainer.new(); g.columns = int(st.grid); box = g
				g.add_theme_constant_override("h_separation", int(st.get("gap", 6))); g.add_theme_constant_override("v_separation", int(st.get("gap", 6)))
			elif st.has("row"):
				box = HBoxContainer.new(); box.add_theme_constant_override("separation", int(st.get("gap", 8)))
				box.alignment = BoxContainer.ALIGNMENT_BEGIN
			else:
				box = VBoxContainer.new(); box.add_theme_constant_override("separation", int(st.get("gap", 4)))
			box.mouse_filter = Control.MOUSE_FILTER_PASS
			_wrap_box(st, parent, box, expand)
			if st.has("row"):
				# row 入面嘅 inline 字：垂直置中
				_kids(e, box, st)
				for ch in box.get_children(): ch.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			else: _kids(e, box, st)

func _pill(e: El, st: Dictionary) -> Dictionary:
	if not st.has("pill"): return st
	var o = st.duplicate()
	var bx = (st.box as Array).duplicate()
	if e.classList.d.has("on"):
		var c = J.str(e.style.get("--c", "#888888"))
		bx[0] = Color(c) if c.begins_with("#") else Color("#888888")
	o.box = bx
	return o

func _knob() -> Texture2D:
	var im = Image.create(18, 18, false, Image.FORMAT_RGBA8)
	for y in 18:
		for x in 18:
			var d = Vector2(x - 8.5, y - 8.5).length()
			im.set_pixel(x, y, Color("#f3e6c8") if d < 7.5 else (Color("#c2362b") if d < 8.8 else Color(0, 0, 0, 0)))
	return ImageTexture.create_from_image(im)

func _restyle(b: Button, bs: Array) -> void:
	var s = UIKit.sb(bs[0], bs[1], bs[2], bs[3], bs[4])
	for k in ["normal", "hover"]: b.add_theme_stylebox_override(k, s)
	var p = s.duplicate(); p.bg_color = bs[0].lightened(0.12); b.add_theme_stylebox_override("pressed", p)
	var d = s.duplicate(); d.bg_color = Color(bs[0], bs[0].a * 0.5); b.add_theme_stylebox_override("disabled", d)

# 成張卡係一粒掣（例：講價攤嘅貨品）
func _card(e: El, st: Dictionary, parent: Control, expand: bool) -> void:
	var box = HBoxContainer.new() if st.has("row") else VBoxContainer.new()
	box.add_theme_constant_override("separation", int(st.get("gap", 8)))
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var host = _wrap_box(st, parent, box, true)
	_kids(e, box, st)
	for ch in box.get_children(): ch.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_ignore_all(box)
	var dis = J.t(e.props.get("disabled"))
	host.mouse_filter = Control.MOUSE_FILTER_STOP
	if dis: host.modulate.a = minf(host.modulate.a, 0.6)
	host.gui_input.connect(func(ev):
		if dis: return
		if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
			if ev.pressed: host.modulate = Color(1.15, 1.1, 1.0, host.modulate.a); _press(e, "pointerdown")
			else: host.modulate = Color(1, 1, 1, host.modulate.a); _press(e, "click")
			host.accept_event())

func _ignore_all(n: Node) -> void:
	for c in n.get_children():
		if c is Control: c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ignore_all(c)

func _press(e: El, ev: String) -> void:
	if J.t(e.props.get("disabled")): return
	var o = {"type": ev, "target": e, "currentTarget": e, "clientX": 0.0, "clientY": 0.0, "pointerId": 1.0, "button": 0.0,
		"preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}
	e.fire(ev, o)
	sync()

# ---------- 原地更新（字／disabled／拉桿值）----------
func _update() -> void:
	for b in _binds:
		match b[0]:
			"run":
				var bb = ""
				for c in b[1]: bb += _bb(c)
				bb = bb.strip_edges()
				if b[2].text != bb: b[2].text = bb
			"el":
				var bb2 = ""
				for c in b[1].children: bb2 += _bb(c)
				bb2 = bb2.strip_edges()
				if b.size() > 3 and b[3]: bb2 = "[center]%s[/center]" % bb2
				if b[2].text != bb2: b[2].text = bb2
			"btn":
				var t = L(b[1]._text().strip_edges())
				if b[2].text != t: b[2].text = t
				b[2].disabled = J.t(b[1].props.get("disabled"))
			"slider":
				var v = J.num(b[1].props.get("value", 0))
				if b[2].value != v: _sliding = true; b[2].value = v; _sliding = false
