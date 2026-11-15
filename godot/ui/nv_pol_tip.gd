# 龐總第一次入玩法提示（policy.js firstEnter 嘅 #pol-tip）原生畫（線 F3）：撳提示＝撳 El（下一句／收埋）；撳提示以外＝收起（同網頁版一樣）
class_name NvPolTip
extends Button

var _sig := ""

static func ensure(host: Control) -> NvPolTip:
	for c in host.get_children(): if c is NvPolTip: return c
	var t = NvPolTip.new(); t.name = "NvPolTip"; host.add_child(t); t._build()
	return t

# 原生站崗（陽間街地圖／站崗）仲開住？開住就喺最上面嗰個畫面掛提示框
static func station_on() -> bool:
	var host: Control = null
	if StTurf.cur != null and is_instance_valid(StTurf.cur) and StTurf.cur.is_visible_in_tree(): host = StTurf.cur
	elif StStreet.cur != null and is_instance_valid(StStreet.cur) and StStreet.cur.is_visible_in_tree(): host = StStreet.cur
	if host == null: return false
	if el() != null and not OS.has_environment("GB_PICKDOM"): ensure(host)
	return true

static func el():
	return JSRun.by_id("pol-tip")

func _build() -> void:
	alignment = HORIZONTAL_ALIGNMENT_LEFT; autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; focus_mode = Control.FOCUS_NONE
	add_theme_font_override("font", UIKit.font("sans", 700)); add_theme_font_size_override("font_size", 16)
	var sb = UIKit.sb(Color(246 / 255.0, 236 / 255.0, 210 / 255.0, 0.96), 14, Color("#3a2a1a"), 2, Vector4(12, 8, 12, 9))
	sb.shadow_color = Color(0, 0, 0, 0.55); sb.shadow_size = 10
	for k in ["normal", "hover", "pressed", "focus"]: add_theme_stylebox_override(k, sb)
	for k in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]: add_theme_color_override(k, Color("#2a1a10"))
	anchor_left = 0; anchor_right = 1; anchor_top = 1; anchor_bottom = 1
	offset_left = 16; offset_right = -16; offset_bottom = -10; grow_vertical = Control.GROW_DIRECTION_BEGIN
	pressed.connect(func():
		var e = el()
		if e != null: e.fire("click", {"type": "click", "target": e, "currentTarget": e, "stopPropagation": func(_t, _a): pass, "preventDefault": func(_t, _a): pass}))
	visible = false

func _process(_dt: float) -> void:
	var e = el()
	var txt := ""
	if e != null:
		var b = J.mc(e, "querySelector", ["b"]); var sp = J.mc(e, "querySelector", ["span"]); var sm = J.mc(e, "querySelector", ["small"])
		txt = "%s\n%s\n%s" % [J.str(J.gp(b, "textContent")) if b else "", J.str(J.gp(sp, "textContent")) if sp else "", J.str(J.gp(sm, "textContent")) if sm else ""]
	if txt == _sig: return
	_sig = txt; visible = txt != ""
	if visible: move_to_front()
	text = txt
	offset_left = 16; offset_right = -16; offset_bottom = -10; offset_top = -10   # 高度由內容撐（向上長）

func _input(ev: InputEvent) -> void:
	if not visible: return
	if ev is InputEventMouseButton and ev.pressed and not get_global_rect().has_point(ev.global_position):
		var e = el()
		if e != null: J.mc(e, "remove", [])
