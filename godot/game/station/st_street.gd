# 陽間站崗・街地圖（原生）
#  - 取代 street.js openStreet() 嘅 DOM 頁面（以前每幀排版）
#  - 資料、規則照用 JS：Street.SITES / site() / _n.RESERVED / GATE / devTotalRate、GP.top / turfNeed
class_name StStreet
extends Control

static var cur: StStreet = null
var _hidden: Array = []
var _t0 := 0
var mapr: TextureRect
var plates: Array = []   # [Button, fx, fy]

static func js(n: String): return J.G.get(n)
static func T(y: String, z: String) -> String: return y if DB.lang == "yue" else z

static func hook() -> bool:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if cur != null and is_instance_valid(cur): cur._close_now()
	var r = StStreet.new(); r.name = "StStreet"
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())
	cur = r
	r._t0 = Time.get_ticks_msec()
	r._build(); r._cover(true)
	return true

static func end_hook() -> void:
	if cur != null and is_instance_valid(cur): cur._close_now()
	cur = null

func _close_now() -> void:
	name = "StStreet_closing"   # 即刻讓名，新開嗰個先叫得返 StStreet（任務掣靠個名判斷）
	_cover(false); queue_free()
	if cur == self: cur = null

func _cover(on: bool) -> void:
	var main = get_parent()
	if main == null: return
	if on:
		for nm in ["village"]:
			var n = main.get(nm)
			if n is CanvasItem and n.visible:
				n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true; n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()

func _ghost_click() -> bool: return Time.get_ticks_msec() - _t0 < 450

func _btn(t: String, bg: Color, bd: Color, fg: Color, fs := 14) -> Button:
	var b = Button.new(); b.text = t; b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", fs)
	var s = UIKit.sb(bg, 12, bd, 2, Vector4(10, 5, 10, 5)); s.shadow_color = Color(0, 0, 0, 0.6); s.shadow_size = 4
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fg)
	return b

func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg = ColorRect.new(); bg.color = Color("#0c0d0e"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	var St = js("Street"); var N = St.get("_n")
	var col = VBoxContainer.new(); col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); col.add_theme_constant_override("separation", 4); add_child(col)
	# 頂欄
	var top = HBoxContainer.new(); top.add_theme_constant_override("separation", 10); top.custom_minimum_size = Vector2(0, 52)
	var tpad = MarginContainer.new(); for k in ["left", "right"]: tpad.add_theme_constant_override("margin_" + k, 12)
	tpad.add_theme_constant_override("margin_top", 10); tpad.add_child(top); col.add_child(tpad)
	var back = _btn("◀ " + T("返陰間", "回陰間"), Color("#6e1414"), Color("#2a0b0b"), Color("#f1e6d6"))
	back.pressed.connect(func():
		if _ghost_click(): return
		J.mc(St, "close", [])
		var W = js("World")
		if W != null: J.mc(W, "open", []))
	top.add_child(back)
	var ttl = UIKit.label(T("陽間街・站崗", "陽間街・站崗"), 19, Color("#e6dfd2"), "serif", 900); ttl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ttl.add_theme_constant_override("outline_size", 4); ttl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8)); top.add_child(ttl)
	var sp = Control.new(); sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; top.add_child(sp)
	var inc = Label.new(); inc.text = "%s +%d/%s" % [T("村莊發展收入", "村莊發展收入"), int(J.num(J.cl(N.devTotalRate, null, []))), T("分", "分")]
	inc.add_theme_font_size_override("font_size", 13); inc.add_theme_color_override("font_color", Color("#e6dfd2")); inc.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var incp = PanelContainer.new(); incp.add_theme_stylebox_override("panel", UIKit.sb(Color(0.08, 0.086, 0.094, 0.75), 10, Color("#3a2a2a"), 1, Vector4(10, 4, 10, 4))); incp.add_child(inc)
	incp.size_flags_vertical = Control.SIZE_SHRINK_CENTER; top.add_child(incp)
	# 鬼力
	var GP = js("GP"); var my = J.num(J.mc(GP, "top", [3.0]))
	var gp = RichTextLabel.new(); gp.bbcode_enabled = true; gp.fit_content = true; gp.scroll_active = false; gp.autowrap_mode = TextServer.AUTOWRAP_OFF
	gp.add_theme_font_size_override("normal_font_size", 13); gp.add_theme_font_size_override("bold_font_size", 13); gp.add_theme_font_override("bold_font", UIKit.font("sans", 900))
	gp.add_theme_color_override("default_color", Color("#d8d4c8"))
	gp.text = "[center]%s [bgcolor=#2f6b45][color=#e8ffe8][b] %s %d [/b][/color][/bgcolor]　[font_size=11][color=#b9a9a0]%s[/color][/font_size][/center]" % [T("你最強三隻鬼平均", "你最強三隻鬼平均"), T("鬼力", "鬼力"), int(my), T("紅字＝鬼力未夠，返村升級先", "紅字＝鬼力不足，先回村升級")]
	col.add_child(gp)
	# 地圖
	var holder = Control.new(); holder.size_flags_vertical = Control.SIZE_EXPAND_FILL; holder.clip_contents = true; col.add_child(holder)
	mapr = TextureRect.new(); mapr.texture = Spr.get_tex("st_street"); mapr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; mapr.stretch_mode = TextureRect.STRETCH_SCALE
	mapr.mouse_filter = Control.MOUSE_FILTER_IGNORE; holder.add_child(mapr)
	holder.resized.connect(func(): _layout_map(holder))
	var SITES: Array = St.get("SITES")
	for d in SITES:
		var sd = J.mc(St, "site", [d.id])
		var posts: Array = sd.get("posts", []) if sd.get("posts") is Array else []
		var held = 0; var lost = 0
		for p in posts:
			if p is Dictionary and p.get("g") != null: held += 1
			if p is Dictionary and J.t(p.get("b")): lost += 1
		var lv = int(J.num(sd.get("lv", 1))); var sc = int(J.num(sd.get("scared", 0)))
		var sub = ("Lv%d・%s%d" % [lv, T("嚇走", "嚇走"), sc] + ("・[color=#ff6b5a][b]%s%d[/b][/color]" % [T("Bryan 佔", "Bryan 佔"), lost] if lost else "")) if held or sc else T("未有鬼站崗", "還沒有鬼站崗")
		var nd = int(J.num(J.mc(GP, "turfNeed", [float(lv)]))); var low = my < nd
		var bb = "[center][b][font_size=15]%s[/font_size][/b]\n[font_size=11][color=#8fb8a8]%s[/color]\n[color=%s]%s %d[/color][/font_size][/center]" % [T(J.str(d.n), J.str(d.zh)), sub, "#ff7a6a" if low else "#7dd8a0", T("建議鬼力", "建議鬼力"), nd]
		var id = J.str(d.id)
		var b = _plate(bb, Color(0.094, 0.1, 0.11, 0.92), Color("#b3261e") if lost else Color("#5c1a1a"), func():
			if _ghost_click(): return
			J.mc(St.Turf, "open", [id]))
		holder.add_child(b); plates.append([b, J.num(d.x), J.num(d.y)])
	for xy in N.RESERVED:
		var b = _plate("[center][b][font_size=15]%s[/font_size][/b]\n[font_size=11][color=#7f968d]%s[/color][/font_size][/center]" % [T("保留地", "保留地"), T("敬請期待", "敬請期待")], Color(0.07, 0.078, 0.086, 0.8), Color("#3d5a50"), func():
			J.mc(js("Fx"), "toast", [T("呢塊地仲未開發，遲啲再嚟", "這塊地還沒開發，晚點再來")]))
		holder.add_child(b); plates.append([b, J.num(xy[0]), J.num(xy[1])])
	var gate = _plate("[center][b][font_size=15]%s[/font_size][/b][/center]" % T("返村", "回村"), Color("#6e1414"), Color("#2a0b0b"), func():
		if not _ghost_click(): J.mc(St, "close", []))
	holder.add_child(gate); plates.append([gate, J.num(N.GATE[0]), J.num(N.GATE[1])])
	var tip = UIKit.label(T("撳地盤入去派鬼站崗。嚇得愈多，傳說愈響，路人就愈難嚇；頂得住就係穩定收入。", "點地盤進去派鬼站崗。嚇得越多，傳說越響，路人就越難嚇；撐得住就是穩定收入。"), 13, Color(0.85, 0.83, 0.78, 0.85))
	tip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; tip.custom_minimum_size = Vector2(0, 44)
	var tpad2 = MarginContainer.new(); for k in ["left", "right"]: tpad2.add_theme_constant_override("margin_" + k, 16)
	tpad2.add_theme_constant_override("margin_bottom", 14); tpad2.add_child(tip); col.add_child(tpad2)

func _plate(bb: String, bg: Color, bd: Color, f: Callable) -> Control:
	var b = Button.new(); b.flat = true
	var s = UIKit.sb(bg, 12, bd, 2, Vector4(9, 5, 9, 5)); s.shadow_color = Color(0, 0, 0, 0.7); s.shadow_size = 5; s.shadow_offset = Vector2(0, 3)
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", s); pc.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(pc)
	var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false; r.autowrap_mode = TextServer.AUTOWRAP_OFF
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE; r.add_theme_color_override("default_color", Color("#e6dfd2")); r.add_theme_font_override("bold_font", UIKit.font("sans", 900))
	r.text = bb; pc.add_child(r)
	b.pressed.connect(f)
	pc.resized.connect(func(): b.custom_minimum_size = pc.size; b.size = pc.size; _place(b))
	return b

func _layout_map(h: Control) -> void:
	var w = h.size.x; var hh = h.size.y
	var mw = minf(w, hh * 2.0 / 3.0); var mh = mw * 1.5
	mapr.position = Vector2((w - mw) / 2, (hh - mh) / 2); mapr.size = Vector2(mw, mh)
	for p in plates: _place(p[0])

func _place(b: Control) -> void:
	for p in plates:
		if p[0] == b:
			var pc = b.get_child(0) as Control
			var sz = pc.size if pc else b.size
			b.position = mapr.position + Vector2(p[1] * mapr.size.x, p[2] * mapr.size.y) - sz / 2
			return
