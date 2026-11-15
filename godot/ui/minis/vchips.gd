# 村子角落小牌（線 I）：龐總 KPI／謠言／懲罰（rivals.js antag-chip）、合約與存在感（presence.js pres-chip）
#  - 原本係 DOM 小 div，每秒改 innerHTML 會令成個 DOM 重排；而家 JS 只交文字過嚟，原生 RichTextLabel 顯示
#  - 只喺村子顯示（跟「任務」掣一樣嘅可見規則）
class_name VChips
extends Control

var chips := {}   # key → [PanelContainer, RichTextLabel, html]

static func set_chip(key: String, html: String, cls: String) -> void:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return
	var n: VChips = main.get_node_or_null("VChips")
	if n == null:
		n = VChips.new(); n.name = "VChips"; n.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); n.mouse_filter = Control.MOUSE_FILTER_IGNORE
		main.add_child(n)
	n._apply(key, html, cls)

static func bb(h: String) -> String:
	var s = h.replace("<br>", "\n").replace("<br/>", "\n")
	s = s.replace("<b>", "[b][color=#ff8a6a]").replace("</b>", "[/color][/b]")
	var re = RegEx.create_from_string("<[^>]+>"); return re.sub(s, "", true)

func _apply(key: String, html: String, cls: String) -> void:
	if html == "":
		if chips.has(key): chips[key][0].queue_free(); chips.erase(key)
		return
	if not chips.has(key):
		var p = PanelContainer.new(); p.mouse_filter = Control.MOUSE_FILTER_STOP
		var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false; r.autowrap_mode = TextServer.AUTOWRAP_OFF
		r.add_theme_font_override("normal_font", UIKit.font("sans", 400)); r.add_theme_font_override("bold_font", UIKit.font("sans", 900))
		r.add_theme_font_size_override("normal_font_size", 13); r.add_theme_font_size_override("bold_font_size", 13)
		r.add_theme_color_override("default_color", Color("#f3e6c8")); r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(r); add_child(p)
		p.anchor_top = 1; p.anchor_bottom = 1; p.grow_vertical = Control.GROW_DIRECTION_BEGIN
		if key == "pres":
			p.anchor_left = 1; p.anchor_right = 1; p.grow_horizontal = Control.GROW_DIRECTION_BEGIN; p.offset_right = -8; p.offset_bottom = -58 - 54
		else:
			p.offset_left = 8; p.offset_bottom = -58 - 12
		p.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: _tap(key))
		chips[key] = [p, r, ""]
	var c = chips[key]
	var crit = cls == "cr"
	c[0].add_theme_stylebox_override("panel", UIKit.sb(Color(20 / 255.0, 12 / 255.0, 22 / 255.0, 0.86), 4, Color("#e0604a") if crit else Color(243 / 255.0, 214 / 255.0, 138 / 255.0, 0.45), 2 if crit else 1, Vector4(10, 6, 10, 6)))
	if c[2] != html:
		c[2] = html; c[1].text = ("[right]%s[/right]" % bb(html)) if key == "pres" else bb(html)
		if crit: c[1].add_theme_color_override("default_color", Color("#ffb4a0"))
		else: c[1].add_theme_color_override("default_color", Color("#f3e6c8"))
		# RichTextLabel 唔識自己計闊度：用字型量最長嗰行
		var plain = RegEx.create_from_string("\\[[^\\]]*\\]").sub(bb(html), "", true)
		var w = 0.0; var f = UIKit.font("sans", 900)
		for ln in plain.split("\n"): w = maxf(w, f.get_string_size(ln, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x)
		c[1].custom_minimum_size.x = ceilf(w) + 4
		var mw = c[0].get_combined_minimum_size()
		if key == "pres": c[0].offset_right = -8; c[0].offset_left = -8 - mw.x; c[0].offset_bottom = -58 - 54; c[0].offset_top = c[0].offset_bottom - mw.y
		else: c[0].offset_left = 8; c[0].offset_right = 8 + mw.x; c[0].offset_bottom = -58 - 12; c[0].offset_top = c[0].offset_bottom - mw.y

func _tap(key: String) -> void:
	if key == "pres": J.mc(J.G.get("Presence"), "openPanel", [])
	else:
		var m = get_parent()
		if m and m.has_method("show_toast"): m.show_toast("龐總 KPI：時限內達標有獎勵，未達標有輕微懲罰。時限只計算你在村子裡遊玩的時間。\n謠言：8 分鐘後自行消散。")

func _process(_dt: float) -> void:
	var q = get_node_or_null("/root/QX")
	var vis = q != null and q.get("btn") != null and is_instance_valid(q.btn) and q.btn.visible
	if visible != vis: visible = vis
