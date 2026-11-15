# 陰間地圖（world.js）原生化：地圖、各去處木牌、保留地濃霧、返村、新政策掣、底部資料框
#  - 規則照用 JS：World.SPOTS 嘅 ready()／need()／go()、Guide.dot／visit、Policy.announce
#  - world.js open() 照砌 DOM（新政策發佈會 policy.js 要用 DOM 卡位）；平時原生蓋住，發佈會／Theater 進行中就臨時顯示返 DOM
#  - 鎖定提示用原生 toast（DOM 收埋咗，Fx.toast 睇唔到）
class_name WmRun
extends Control

static var cur: WmRun = null

const TOP_H := 56.0
var W
var scroll: ScrollContainer
var mapbox: Control
var map_tex: TextureRect
var tags := {}           # id → {b, spot, off}
var info: VBoxContainer
var top: Control
var toast_l: Label
var _toast_t := 0.0
var _hidden: Array = []
var _sel := ""
var _t0 := 0
var _dom_mode := false
var _t := 0.0
var glows: Array = []

static func js(n: String): return J.G.get(n)
static func L(s) -> String: return J.str(DB.L(J.str(s)))

static func hook(on: bool) -> bool:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if not on:
		if cur != null and is_instance_valid(cur): cur._teardown()
		return true
	if cur != null and is_instance_valid(cur): cur._teardown()
	var r = WmRun.new(); r.name = "WmRun"; r.W = js("World")
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())   # 劇情／面板喺上面
	cur = r
	r._build(); r._cover(true)
	return true

func _teardown() -> void:
	if _wd_hide:
		var wel = _el("#world")
		if wel != null:
			if _wd_saved == null: wel.style.erase("display")
			else: wel.style["display"] = _wd_saved
	_cover(false)
	if cur == self: cur = null
	queue_free()

func _cover(on: bool) -> void:
	var main = get_parent()
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and not _hidden.has(n):
				n.set_meta("wm_vis", n.visible); n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true if n == main.get("dom") else n.get_meta("wm_vis", true); n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()

func _el(sel: String):
	var f = js("$")
	return J.cl(f, null, [sel]) if f != null else null

# ---------------- 版面 ----------------
func _build() -> void:
	_t0 = Time.get_ticks_msec()
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg = ColorRect.new(); bg.color = Color("#120d18"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	scroll = ScrollContainer.new(); scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(scroll)
	var col = VBoxContainer.new(); col.size_flags_horizontal = Control.SIZE_EXPAND_FILL; col.add_theme_constant_override("separation", 0); scroll.add_child(col)
	mapbox = Control.new(); mapbox.custom_minimum_size = Vector2(0, 600); mapbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL; mapbox.clip_contents = true; col.add_child(mapbox)
	map_tex = TextureRect.new(); map_tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; map_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; map_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex = Spr.get_tex("bg_worldmap2")
	if tex == null: tex = load("res://assets/img/world_assets/worldmap2.webp")
	map_tex.texture = tex; mapbox.add_child(map_tex)
	var fx = Control.new(); fx.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); fx.mouse_filter = Control.MOUSE_FILTER_IGNORE; fx.draw.connect(func(): _draw_fx(fx)); mapbox.add_child(fx); glows.append(fx)
	# 去處
	for s in W.SPOTS:
		var id = J.str(s.id); var ready = s.get("ready") == null or J.t(J.cl(s.ready, null, [])); var open = s.get("need") == null or J.t(J.cl(s.need, null, []))
		var dot = js("Guide") != null and J.t(J.mc(js("Guide"), "dot", [id]))
		var sub = L("施工中") if not ready else (L(s.get("lock", "")) if not open else L(s.sub))
		var hit = Control.new(); hit.custom_minimum_size = Vector2(92, 92); hit.size = Vector2(92, 92); hit.mouse_filter = Control.MOUSE_FILTER_STOP
		hit.set_meta("p", Vector2(J.num(s.x), J.num(s.y))); hit.set_meta("c", true); mapbox.add_child(hit)
		hit.gui_input.connect(func(ev): if _tap(ev): _pick(id))
		var b = _tag(L(s.name), sub, "gate" if false else "", not (ready and open), dot)
		b.set_meta("p", Vector2(J.num(s.lx), J.num(s.ly))); mapbox.add_child(b)
		b.gui_input.connect(func(ev): if _tap(ev): _pick(id))
		tags[id] = {"b": b, "spot": s, "off": not (ready and open), "ready": ready, "x": J.num(s.x), "y": J.num(s.y)}
	var RS: Array = W.RES_SPOTS
	for i in mini(int(J.num(W.RESERVED)), RS.size()):
		var r = RS[i]; var b = _tag(L("保留地"), L("濃霧未散"), "res", false, false)
		b.set_meta("p", Vector2(J.num(r.lx), J.num(r.ly))); mapbox.add_child(b)
		var key = "res%d" % i
		b.gui_input.connect(func(ev): if _tap(ev): _pick(key))
		tags[key] = {"b": b, "res": true, "fx": J.num(r.x), "fy": J.num(r.y)}
	var gate = _tag(L("落魄村"), L("返村"), "gate", false, false); gate.set_meta("p", Vector2(0.5, 0.88)); mapbox.add_child(gate)
	gate.gui_input.connect(func(ev): if _tap(ev) and not _ghost(): _close())
	# 底部資料
	var ip = PanelContainer.new(); ip.custom_minimum_size = Vector2(0, 170)
	var ist = StyleBoxFlat.new(); ist.bg_color = Color("#1a1218"); ist.border_color = Color("#8a2a1c"); ist.border_width_top = 4
	ist.content_margin_left = 18; ist.content_margin_right = 18; ist.content_margin_top = 14; ist.content_margin_bottom = 22
	ip.add_theme_stylebox_override("panel", ist); col.add_child(ip)
	info = VBoxContainer.new(); info.add_theme_constant_override("separation", 4); ip.add_child(info)
	_info_hint()
	# 頂欄
	top = Control.new(); top.anchor_right = 1; top.offset_bottom = TOP_H; top.mouse_filter = Control.MOUSE_FILTER_IGNORE; top.draw.connect(_draw_top); add_child(top)
	var hb = HBoxContainer.new(); hb.anchor_right = 1; hb.offset_left = 12; hb.offset_right = -12; hb.offset_top = 8; hb.offset_bottom = TOP_H - 6; hb.add_theme_constant_override("separation", 10); top.add_child(hb)
	var home = _frame_btn("◀ " + L("回村"), Color("#3a1210"), Color("#a83a2a")); home.pressed.connect(func(): if not _ghost(): _close()); hb.add_child(home)
	var tl = UIKit.label(L("陰間地圖"), 20, Color("#f8e8c4"), "serif", 900); tl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tl.add_theme_color_override("font_shadow_color", Color.BLACK); tl.add_theme_constant_override("shadow_offset_x", 2); tl.add_theme_constant_override("shadow_offset_y", 2); hb.add_child(tl)
	var sl = UIKit.label(L("揀個去處"), 12, Color(0.97, 0.91, 0.77, 0.8)); sl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; sl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(sl)
	var pol = _frame_btn(L("新政策"), Color("#251a34"), Color("#7a64a0")); pol.pressed.connect(func():
		if not _ghost() and js("Policy") != null: J.mc(js("Policy"), "announce", []))
	hb.add_child(pol)
	# toast
	toast_l = UIKit.label("", 14, Color("#fff3e0"), "sans", 700); toast_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; toast_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	toast_l.add_theme_stylebox_override("normal", UIKit.sb(Color(0.08, 0.05, 0.08, 0.9), 8, Color("#8a6a40"), 2, Vector4(14, 8, 14, 8)))
	toast_l.anchor_left = 0.1; toast_l.anchor_right = 0.9; toast_l.anchor_top = 0.42; toast_l.anchor_bottom = 0.42; toast_l.offset_bottom = 44; toast_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toast_l.visible = false; toast_l.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(toast_l)
	resized.connect(_layout); _layout.call_deferred()

func _frame_btn(t: String, bg: Color, bd: Color) -> Button:
	var b = Button.new(); b.text = t; b.custom_minimum_size = Vector2(44, 44)
	b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 15)
	var s = UIKit.sb(bg, 0, bd, 3, Vector4(10, 4, 10, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#f6e2b8"))
	return b

# 木牌（crayon 框：鏽紅／金（揀中）／紫（保留地）／紅（返村））
func _tag(name: String, sub: String, kind: String, off: bool, dot: bool) -> PanelContainer:
	var p = PanelContainer.new(); p.mouse_filter = Control.MOUSE_FILTER_STOP; p.custom_minimum_size = Vector2(76, 44)
	p.set_meta("kind", kind); _style_tag(p, false)
	var vb = VBoxContainer.new(); vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_theme_constant_override("separation", 0); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(vb)
	var nl = UIKit.label(name, 15, Color("#f6e2b8") if kind != "res" else Color("#d8cce4"), "serif", 900); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8)); nl.add_theme_constant_override("shadow_offset_y", 1); vb.add_child(nl)
	var sl = UIKit.label(sub, 10.5, Color("#d6b88c") if kind != "res" else Color("#b0a3bf")); sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sl.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(sl)
	if off: p.modulate = Color(0.62, 0.6, 0.58)
	if kind == "res": p.modulate.a = 0.9
	if dot:
		# 紅點：PanelContainer 會將子節點撐滿成個牌，所以直接喺牌角畫
		p.draw.connect(func():
			var c = Vector2(p.size.x - 1, 1)
			p.draw_circle(c, 7.5, Color("#fff3e0")); p.draw_circle(c, 6, Color("#e8303a")))
		p.set_meta("dot", true)
	return p

func _style_tag(p: PanelContainer, sel: bool) -> void:
	var kind = J.str(p.get_meta("kind", ""))
	var bg = Color("#3a2414"); var bd = Color("#9a5a2a")
	if kind == "res": bg = Color(0.19, 0.16, 0.23, 0.85); bd = Color("#8a78a6")
	elif kind == "gate": bg = Color("#4a1612"); bd = Color("#b8402e")
	if sel: bd = Color("#ffcf6a")
	var s = UIKit.sb(bg, 0, bd, 4 if not sel else 5, Vector4(9, 4, 9, 5))
	s.shadow_color = Color(1, 0.75, 0.3, 0.75) if sel else Color(0, 0, 0, 0.5); s.shadow_size = 8 if sel else 3; s.shadow_offset = Vector2(0, 0 if sel else 3)
	p.add_theme_stylebox_override("panel", s)

func _layout() -> void:
	var w = minf(size.x, 560.0); var h = w * 1.5
	mapbox.custom_minimum_size = Vector2(0, h)
	var ox = (size.x - w) / 2.0
	map_tex.position = Vector2(ox, 0); map_tex.size = Vector2(w, h)
	for c in mapbox.get_children():
		if not c.has_meta("p"): continue
		var p: Vector2 = c.get_meta("p")
		c.reset_size()
		var cs = c.get_combined_minimum_size() if not c.has_meta("c") else Vector2(92, 92)
		c.position = Vector2(ox + p.x * w, p.y * h) - cs / 2.0
	_mapw = w; _mapox = ox; _maph = h
var _mapw := 390.0
var _mapox := 0.0
var _maph := 585.0

# 發光、濃霧（動畫）
func _draw_fx(n: Control) -> void:
	var tg = PtGfx.RAD if PtGfx.RAD != null else null
	if tg == null: PtGfx.init(); tg = PtGfx.RAD
	var pul = 0.65 + 0.35 * sin(_t * TAU / 2.4)
	for id in tags:
		var e = tags[id]
		if e.get("res"):
			var c = Vector2(_mapox + e.fx * _mapw, e.fy * _maph); var dr = sin(_t * TAU / 6.0) * 6
			n.draw_texture_rect(tg, Rect2(c.x - 65 + dr, c.y - 45, 130, 90), false, Color(0.67, 0.63, 0.75, 0.55))
			continue
		var c2 = Vector2(_mapox + e.x * _mapw, e.y * _maph)
		var a = (0.35 * pul) * (0.45 if e.off else 1.0)
		n.draw_texture_rect(tg, Rect2(c2.x - 35 * (1 + 0.1 * pul), c2.y - 35 * (1 + 0.1 * pul), 70 * (1 + 0.1 * pul), 70 * (1 + 0.1 * pul)), false, Color(1, 0.86, 0.55, a * 2))

func _draw_top() -> void:
	var w = top.size.x
	var pts = PackedVector2Array([Vector2(0, 0), Vector2(w, 0), Vector2(w, TOP_H + 20), Vector2(0, TOP_H + 20)])
	top.draw_polygon(pts, PackedColorArray([Color(0.055, 0.035, 0.047, 0.95), Color(0.055, 0.035, 0.047, 0.95), Color(0.055, 0.035, 0.047, 0), Color(0.055, 0.035, 0.047, 0)]))

# ---------------- 互動（同 world.js 一樣：撳一下揀中，再撳出發） ----------------
func _tap(ev) -> bool:
	return ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT
func _ghost() -> bool: return Time.get_ticks_msec() - _t0 < 450

func _pick(id: String) -> void:
	if _ghost(): return
	if _sel == id: _go(id); return
	if _sel != "" and tags.has(_sel): _style_tag(tags[_sel].b, false)
	_sel = id; _style_tag(tags[id].b, true); Snd.play("click")
	for c in info.get_children(): c.queue_free()
	var e = tags[id]
	if e.get("res"):
		_info_title(L("保留地"), ""); _info_p(L("呢度仲俾濃霧封住。總部話遲啲會開發，敬請期待。")); return
	var s = e.spot
	_info_title(L(s.name), L(s.sub))
	_info_p(L(J.gp(W.DESC, J.str(s.id))))
	if e.off:
		var lk = UIKit.label("（鎖）" + (L("施工中") if not e.ready else L(s.get("lock", ""))), 14, Color("#d8cce4"), "sans", 700)
		lk.add_theme_stylebox_override("normal", UIKit.sb(Color(0.12, 0.09, 0.16, 0.7), 0, Color("#6a5a8a"), 3, Vector4(10, 8, 10, 8))); info.add_child(lk)
	else:
		var g = _frame_btn(L("出發") + " ▶", Color("#3a1c0c"), Color("#b0602a")); g.custom_minimum_size = Vector2(0, 52); g.add_theme_font_size_override("font_size", 20)
		g.pressed.connect(func(): _go(id)); info.add_child(g)

func _go(id: String) -> void:
	if _ghost(): return
	var e = tags[id]
	if e.get("res"): _toast(L("呢塊地仲俾濃霧封住，遲啲再嚟")); return
	var s = e.spot
	if e.off: _toast(L(s.name) + L("還在施工，快好了") if not e.ready else L(s.get("lock", ""))); return
	Snd.play("click")
	J.mc(W, "close", [])
	if js("Guide") != null: J.mc(js("Guide"), "visit", [J.str(s.id)])
	J.cl(s.go, null, [])

func _close() -> void:
	J.mc(W, "close", [])

func _info_hint() -> void:
	var l = UIKit.label(L("撳地圖上嘅木牌，揀今晚去邊度。"), 15, Color("#a8957f")); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.size_flags_vertical = Control.SIZE_EXPAND_FILL; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.custom_minimum_size = Vector2(0, 120); info.add_child(l)
func _info_title(t: String, sub: String) -> void:
	var l = UIKit.label(t, 22, Color("#f2dfb6"), "serif", 900); l.add_theme_color_override("font_shadow_color", Color.BLACK); l.add_theme_constant_override("shadow_offset_x", 2); l.add_theme_constant_override("shadow_offset_y", 2); info.add_child(l)
	if sub != "": info.add_child(UIKit.label(sub, 13, Color("#c9a77a")))
func _info_p(t: String) -> void:
	var l = UIKit.label(t, 15, Color("#ddd0b6")); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; info.add_child(l)

func _toast(t: String) -> void:
	toast_l.text = t; toast_l.visible = true; _toast_t = 2.2; toast_l.reset_size()

# ---------------- 每幀：新政策發佈會／Theater 期間顯示 DOM ----------------
func _process(dt: float) -> void:
	_t += dt
	for g in glows: g.queue_redraw()
	if _toast_t > 0:
		_toast_t -= dt
		if _toast_t <= 0: toast_l.visible = false
	var th = js("Theater")
	# 小劇場（Theater）播緊：佢嘅原生畫布喺成個 DOM 下面、根節點透明，所以要收埋 DOM 嘅 #world，唔係會透出舊地圖
	var th_on = th != null and J.t(J.gp(th, "on"))
	if th_on != _wd_hide:
		var wel = _el("#world")
		if wel != null:
			_wd_hide = th_on
			if th_on: _wd_saved = wel.style.get("display"); wel.style["display"] = "none"
			elif _wd_saved == null: wel.style.erase("display")
			else: wel.style["display"] = _wd_saved
	# 新政策指卡（#pol-ov）：原生畫（NvPolOv）；GB_POLDOM=1 用返 DOM
	var ov = _el("#pol-ov")
	if ov != null and not OS.has_environment("GB_POLDOM"):
		NvPolOv.ensure(self, ov); ov = null
	var dom_need = (th != null and J.t(J.gp(th, "on"))) or ov != null or _el("#dlg.on") != null
	if dom_need != _dom_mode:
		_dom_mode = dom_need
		visible = not dom_need
		var dom = get_parent().get("dom")
		if dom: dom.visible = dom_need; dom.process_mode = Node.PROCESS_MODE_INHERIT if dom_need else Node.PROCESS_MODE_DISABLED
		mouse_filter = Control.MOUSE_FILTER_IGNORE if dom_need else Control.MOUSE_FILTER_STOP

var _wd_hide := false
var _wd_saved = null

static func t_pick(id: String) -> void:
	if cur != null: cur._t0 = 0; cur._pick(id)
