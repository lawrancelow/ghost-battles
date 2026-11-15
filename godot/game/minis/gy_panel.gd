# 亂葬崗介面（原生）：頂欄（收工／第幾夜／機會／規矩）、提示條、底部面板（魂掣、資料卡、全部退回／送他們安息）、畫布觸控
# DOM 版 #gyard 每幀排版 30ms+（複雜 CSS 選擇器），改原生之後成個 #gyard 收埋（display:none）
# 規則、狀態全部留喺 graveyard.js：呢度只係讀 Graveyard 嘅狀態嚟畫，掣就叫返 DOM 掣本身嘅 onclick（或者 JS 方法）
# GB_GYDOM=1 用返 DOM 版
class_name GyPanel
extends Control

static var cur: GyPanel = null

var G: Dictionary
var ms: Control            # MiniStage
var top: PanelContainer
var title: Label
var tries: Label
var bquit: Button
var brule: Button
var hint: PanelContainer
var hint_l: Label
var touch: Control
var panel: PanelContainer
var chips: HBoxContainer
var info_sc: ScrollContainer
var info: VBoxContainer
var breset: Button
var bgo: Button
var _sig := ""
var _hsig := ""
var _quit_t := 0.0
var _down := false
var _rect_saved = null

const CHIP_BG := Color("#2a2433")

static func L(s) -> String: return J.str(DB.L(J.str(s)))

static func attach(g, mini: Control) -> bool:
	if OS.has_environment("GB_GYDOM") or not (g is Dictionary): return false
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	close()
	var p = GyPanel.new(); p.G = g; p.ms = mini; p.name = "GyPanel"
	main.add_child(p)
	var dom = main.get("dom")
	if dom: main.move_child(p, dom.get_index() + 1)
	cur = p; p._build()
	return true

static func close() -> void:
	if cur != null and is_instance_valid(cur):
		cur._restore_dom(); cur.queue_free()
	cur = null

static func stage_rect() -> Rect2:
	if cur == null or not is_instance_valid(cur): return Rect2()
	return cur._stage_rect()

func _el(s: String): return JSRun.query(s, null)

func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_follow_dom()
	_hide_dom(true)
	# ---- 頂欄 ----
	top = PanelContainer.new(); top.mouse_filter = Control.MOUSE_FILTER_STOP
	top.add_theme_stylebox_override("panel", _grad_sb(Color("#1d1822"), Color("#151119"), Vector4(10, 8, 10, 8)))
	add_child(top)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); top.add_child(hb)
	bquit = UIKit.btn(L("收工"), "ghost", true); _dark_ghost(bquit); hb.add_child(bquit)
	title = UIKit.label("", 18, Color("#eeeeee"), "serif", 900); title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; title.clip_text = true; hb.add_child(title)
	tries = UIKit.label("", 13, Color("#ffcf6a")); tries.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(tries)
	brule = UIKit.btn(L("規矩"), "", true); hb.add_child(brule)
	bquit.pressed.connect(_on_quit)
	brule.pressed.connect(func(): _click("#gy-rule"))
	# ---- 提示條（蓋喺畫布頂）----
	hint = PanelContainer.new(); hint.mouse_filter = Control.MOUSE_FILTER_STOP; hint.visible = false
	var hs = UIKit.sb(Color("#221a2c"), 0, Color(0, 0, 0, 0), 0, Vector4(12, 6, 8, 6)); hs.border_color = Color("#4a3a5a"); hs.border_width_bottom = 1
	hint.add_theme_stylebox_override("panel", hs); add_child(hint)
	var hh = HBoxContainer.new(); hh.add_theme_constant_override("separation", 6); hint.add_child(hh)
	hint_l = UIKit.label("", 14, Color("#e8e0f4")); hint_l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; hint_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hh.add_child(hint_l)
	var hx = Button.new(); hx.text = "✕"; hx.flat = true; hx.add_theme_color_override("font_color", Color("#aaaaaa")); hx.add_theme_font_size_override("font_size", 16)
	hx.focus_mode = Control.FOCUS_NONE; hh.add_child(hx)
	hx.pressed.connect(func():
		var h = _el("#gy-hint")
		if h is El: h.classList._js_remove(["on"])
		hint.visible = false)
	# ---- 畫布觸控 ----
	touch = Control.new(); touch.mouse_filter = Control.MOUSE_FILTER_STOP
	touch.gui_input.connect(_on_touch); add_child(touch); move_child(touch, 0)
	# ---- 底部面板 ----
	panel = PanelContainer.new(); panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.add_theme_stylebox_override("panel", _grad_sb(Color("#1a1520"), Color("#120e16"), Vector4(10, 8, 10, 8)))
	add_child(panel)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 7); panel.add_child(vb)
	chips = HBoxContainer.new(); chips.add_theme_constant_override("separation", 6); vb.add_child(chips)
	var ip = PanelContainer.new(); ip.add_theme_stylebox_override("panel", UIKit.sb(Color("#f3e8cf"), 12, Color(0, 0, 0, 0), 0, Vector4(12, 9, 12, 9)))
	vb.add_child(ip)
	info_sc = ScrollContainer.new(); info_sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; ip.add_child(info_sc)
	info = VBoxContainer.new(); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; info.add_theme_constant_override("separation", 2); info_sc.add_child(info)
	var acts = HBoxContainer.new(); acts.add_theme_constant_override("separation", 8); vb.add_child(acts)
	breset = UIKit.btn(L("全部退回")); bgo = UIKit.btn("", "gold")
	for b in [breset, bgo]:
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.custom_minimum_size = Vector2(0, 44); b.add_theme_font_size_override("font_size", 16); acts.add_child(b)
	breset.pressed.connect(func(): _click("#gy-reset"))
	bgo.pressed.connect(func(): _click("#gy-go"))
	_layout()
	_refresh(true)

func _grad_sb(a: Color, b: Color, pad: Vector4) -> StyleBoxTexture:
	var g = Gradient.new(); g.colors = PackedColorArray([a, b])
	var s = StyleBoxTexture.new(); s.texture = GradTex.vertical(g, 4, 32)   # 唔用 GradientTexture2D（Adreno 閃退）
	s.content_margin_left = pad.x; s.content_margin_top = pad.y; s.content_margin_right = pad.z; s.content_margin_bottom = pad.w
	return s

func _dark_ghost(b: Button) -> void:
	var pad = Vector4(11, 6, 11, 6)
	for st in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(st, UIKit.sb(Color(1, 1, 1, 0.06 if st != "pressed" else 0.12), 4, Color("#6a5a70"), 1, pad))
	for c in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(c, Color("#e8dcef"))

# ---------- DOM ----------
func _hide_dom(on: bool) -> void:
	var e = _el("#gyard")
	if e == null: return
	if on: e.style["display"] = "none"
	else: e.style.erase("display")

func _restore_dom() -> void:
	_hide_dom(false)
	var cv = _el("#gy-cvs")
	if cv is El: cv.props.erase("_rect")

func _follow_dom() -> void:
	var dom = get_parent().get("dom") if get_parent() else null
	if dom is Control:
		if position != dom.position: position = dom.position
		if size != dom.size: size = dom.size
	else: size = get_viewport_rect().size

func _layout() -> void:
	var W = size.x; var H = size.y
	var th = top.get_combined_minimum_size().y
	top.position = Vector2(0, 0); top.size = Vector2(W, th)
	var ph = panel.get_combined_minimum_size().y
	panel.position = Vector2(0, H - ph); panel.size = Vector2(W, ph)
	var hhh = hint.get_combined_minimum_size().y if hint.visible else 0.0
	hint.position = Vector2(0, th); hint.size = Vector2(W, hhh)
	var sr = _stage_rect()
	touch.position = sr.position; touch.size = sr.size

func _stage_rect() -> Rect2:
	var th = top.position.y + top.size.y
	var hb = hint.size.y if hint.visible else 0.0
	return Rect2(0, th + hb, size.x, maxf(60.0, panel.position.y - th - hb))

# ---------- 每幀 ----------
func _process(dt: float) -> void:
	if not J.t(G.get("active")):
		return
	_follow_dom()
	if _quit_t > 0:
		_quit_t -= dt
		if _quit_t <= 0: bquit.text = L("收工")
	_refresh(false)
	_layout()
	# 畫布嘅「位置」：原生舞台左上角 = (0,0)，JS local() 直接用 clientX/Y
	var sr = _stage_rect()
	var cv = _el("#gy-cvs")
	if cv is El:
		var r = {"left": 0.0, "top": 0.0, "x": 0.0, "y": 0.0, "width": sr.size.x, "height": sr.size.y, "right": sr.size.x, "bottom": sr.size.y}
		if _rect_saved == null or _rect_saved.width != r.width or _rect_saved.height != r.height:
			cv.props["_rect"] = r; _rect_saved = r

func _refresh(force: bool) -> void:
	# 提示條：照 DOM #gy-hint 嘅狀態（JS hint() 自己計時收埋）
	var h = _el("#gy-hint")
	var ht = ""
	if h is El and h.classList.d.has("on"):
		for c in h.children:
			if c is El and c.tagName == "SPAN": ht = J.str(c._text()); break
	if ht != _hsig or force:
		_hsig = ht; hint.visible = ht != ""; hint_l.text = L(ht)
	var souls = G.get("souls", [])
	var view = G.get("view", {})
	var sel = G.get("sel")
	var ph = J.str(G.get("phase", ""))
	var places = []
	for s in souls: places.append(s.get("place"))
	var sig = JSON.stringify([J.num(G.get("tries", 0)), sel, view, ph, places, _night()])
	if sig == _sig and not force: return
	_sig = sig
	title.text = L("亂葬崗・第 %d 夜" % _night())
	var tn = int(J.num(G.get("tries", 0)))
	tries.text = L("機會 ") + "●".repeat(maxi(0, 2 - tn)) + "○".repeat(mini(2, tn))
	_build_chips(souls, view, sel)
	_build_info(souls, view, sel)
	var unplaced = 0
	for s in souls: if s.get("place") == null: unplaced += 1
	bgo.text = L("送他們安息") if unplaced == 0 else L("送他們安息（差 %d）" % unplaced)
	bgo.disabled = ph != "play" or unplaced > 0
	breset.disabled = ph != "play"

func _night() -> int:
	var y = J.gp(J.G.get("S"), "yard")
	return int(J.num(J.gp(y, "night"))) if y is Dictionary else 1

func _vk(view) -> String: return J.str(view.get("k", "")) if view is Dictionary else ""
func _vi(view) -> int: return int(J.num(view.get("i", 0))) if view is Dictionary else 0

func _build_chips(souls: Array, view, sel) -> void:
	for c in chips.get_children(): c.queue_free()
	var graves = J.gp(G.get("p"), "graves")
	for s in souls:
		var i = int(J.num(s.get("i")))
		var col = Ctx.col(J.str(s.get("col")))
		var b = Button.new(); b.focus_mode = Control.FOCUS_NONE; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.custom_minimum_size = Vector2(0, 46)
		var is_sel = sel != null and int(J.num(sel)) == i
		var is_on = _vk(view) == "soul" and _vi(view) == i
		var bg = Color("#4a3a20") if is_sel else (Color("#3a3048") if is_on else CHIP_BG)
		var bw = 3 if is_sel else (2 if is_on else 1)
		var st = UIKit.sb(bg, 10, col if (is_sel or is_on) else Color("#4a3a5a"), bw, Vector4(2, 4, 2, 4))
		for k in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(k, st)
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var vb = VBoxContainer.new(); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_theme_constant_override("separation", 0)
		vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.alignment = BoxContainer.ALIGNMENT_CENTER
		var tg = UIKit.label(J.str(s.get("tag")), 20, col, "sans", 900); tg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; tg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var pl = s.get("place")
		var sm_t = L("還沒安置")
		if pl != null and graves is Array:
			var g = graves[int(J.num(pl))]
			sm_t = J.str(g.get("name")).substr(0, 1) + L("家墳前")
		var sm = UIKit.label(sm_t, 11, Color(0.87, 0.87, 0.87, 0.8)); sm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sm.clip_text = true; sm.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vb.add_child(tg); vb.add_child(sm); b.add_child(vb)
		b.pressed.connect(_chip.bind(i))
		chips.add_child(b)

func _chip(i: int) -> void:
	var cs = _el("#gy-chips")
	if cs is El:
		var n = 0
		for c in cs.children:
			if c is El and c.tagName != "#TEXT":
				if n == i: _fire(c); return
				n += 1

func _build_info(souls: Array, view, sel) -> void:
	for c in info.get_children(): c.queue_free()
	var k = _vk(view)
	var ink = Color("#2a1a10")
	if k == "rules":
		for r in J.G.get("GY_RULES", []):
			var t = UIKit.rich("[bgcolor=#2a2433][color=#ffe9a8][font_size=13] %s [/font_size][/color][/bgcolor] %s" % [L(r[0]), L(r[1])], 14, ink)
			t.size_flags_horizontal = Control.SIZE_EXPAND_FILL; info.add_child(t)
	elif k == "grave":
		var gi = _vi(view)
		var p = G.get("p"); var g = p.graves[gi]
		var spot = J.gp(J.G.get("GY_SPOTS"), J.str(g.get("spot")))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); info.add_child(hb)
		hb.add_child(UIKit.label(J.str(g.get("name")), 22, ink, "serif", 900))
		var yl = UIKit.label("%d – %d" % [int(J.num(g.get("birth"))), int(J.num(g.get("death")))], 14, ink, "sans", 700); yl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(yl)
		var em = PanelContainer.new(); em.add_theme_stylebox_override("panel", UIKit.sb(Color("#2a2433"), 99, Color(0, 0, 0, 0), 0, Vector4(7, 2, 7, 2)))
		em.add_child(UIKit.label(L(J.str(J.gp(spot, "name"))), 12, Color("#ffe9a8"))); em.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(em)
		for row in [["生前", g.get("job")], ["碑文", g.get("ep")], ["祭品", g.get("off")]]:
			var t = UIKit.rich("[color=#8a5a2a][font_size=13][b]%s[/b][/font_size][/color]  %s" % [L(row[0]), L(J.str(row[1]))], 16, ink)
			t.size_flags_horizontal = Control.SIZE_EXPAND_FILL; info.add_child(t)
		var who = null
		for s in souls: if s.get("place") != null and int(J.num(s.get("place"))) == gi: who = s
		var note = ""
		if who != null: note = "[b][color=%s]%s[/color][/b] %s" % [J.str(who.get("col")), J.str(who.get("tag")), L("站在這座墳前。")]
		elif sel == null: note = L("先點一個魂，再點這座墳，就能把他送過來。")
		if note != "":
			var nt = UIKit.rich(note, 13, Color(ink, 0.8)); nt.size_flags_horizontal = Control.SIZE_EXPAND_FILL; info.add_child(nt)
	else:
		var i = _vi(view)
		if i >= souls.size(): return
		var s = souls[i]; var d = G.get("p").souls[i]
		var col = Ctx.col(J.str(s.get("col")))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); info.add_child(hb)
		var tg = UIKit.label(J.str(s.get("tag")), 22, ink, "sans", 900); tg.add_theme_color_override("font_outline_color", col); tg.add_theme_constant_override("outline_size", 6); hb.add_child(tg)
		var is_sel = sel != null and int(J.num(sel)) == i
		var st = UIKit.label(L("選好了：點一座墳，把他送過去") if is_sel else L("他記得的事"), 13, Color(ink, 0.7)); st.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(st)
		for ln in d.get("lines", []):
			var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 6); info.add_child(row)
			var dot = UIKit.label("·", 16, Color("#8a4a20"), "sans", 900); dot.vertical_alignment = VERTICAL_ALIGNMENT_TOP; row.add_child(dot)
			var t = UIKit.label(L(J.str(ln)), 16, ink); t.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; t.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(t)
			var sep = ColorRect.new(); sep.color = Color(0.35, 0.24, 0.12, 0.2); sep.custom_minimum_size = Vector2(0, 1); info.add_child(sep)
	info_sc.custom_minimum_size = Vector2(0, minf(168.0, get_viewport_rect().size.y * 0.21))
	info_sc.scroll_vertical = 0

# ---------- 掣 ----------
func _fire(e) -> void:
	if not (e is El): return
	var f = e.props.get("onclick")
	if f == null: return
	J.cl(f, e, [{"type": "click", "target": e, "currentTarget": e, "preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}])

func _click(sel: String) -> void:
	var e = _el(sel)
	if e is El and J.t(e.props.get("disabled")): return
	_fire(e)
	_refresh(true)

func _on_quit() -> void:
	if J.str(G.get("phase", "")) != "play": return
	if _quit_t <= 0:
		_quit_t = 3.0; bquit.text = L("確定收工？"); Snd.play("click"); return
	_quit_t = 0
	J.mc(G, "close", [])

func _ev(p: Vector2) -> Dictionary:
	return {"type": "pointer", "clientX": p.x, "clientY": p.y, "pointerId": 1.0, "isPrimary": true, "pointerType": "touch", "button": 0.0,
		"preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}

func _on_touch(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed: _down = true; J.mc(G, "down", [_ev(ev.position)])
		elif _down: _down = false; J.mc(G, "up", [_ev(ev.position)])
		_refresh(false)
		touch.accept_event()
	elif ev is InputEventMouseMotion and _down:
		J.mc(G, "move", [_ev(ev.position)])
		touch.accept_event()
