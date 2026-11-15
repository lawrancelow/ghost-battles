# 新政策發佈會：喺陰間地圖指住張卡（policy.js point() 嘅 #pol-ov）原生畫（線 F3）
#  外框發光＋箭咀指住原生木牌（唔遮卡），對白框放喺卡上面，位唔夠先放下面；字照讀 JS 寫落 El 嘅 textContent
#  撳任何位置 = 撳 #pol-ov（JS onclick 揭下一句／完咗就移走 El，再接 Theater）
class_name NvPolOv
extends Control

var W: WmRun
var el = null
var card_id := ""
var box: PanelContainer
var who_l: Label
var txt_l: Label
var hint_l: Label
var _t := 0.0
var _scrolled := false

static func ensure(w: WmRun, ov) -> NvPolOv:
	for c in w.get_children():
		if c is NvPolOv:
			if c.el == ov: return c
			c.queue_free()
	var n = NvPolOv.new(); n.W = w; n.el = ov; n.card_id = J.str(ov.dataset.get("card", ""))
	n.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); n.mouse_filter = Control.MOUSE_FILTER_STOP
	w.add_child(n); n._build()
	return n

func _build() -> void:
	box = PanelContainer.new(); box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb = UIKit.sb(Color("#f6ecd2"), 14, Color("#3a2a1a"), 2, Vector4(14, 10, 14, 12))
	sb.shadow_color = Color(0, 0, 0, 0.55); sb.shadow_size = 10; sb.shadow_offset = Vector2(0, 6)
	box.add_theme_stylebox_override("panel", sb); add_child(box)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 2); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(vb)
	who_l = UIKit.label("", 14, Color("#b0302a"), "serif", 900); vb.add_child(who_l)
	txt_l = UIKit.label("", 18, Color("#2a1a10"), "sans", 700); txt_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; vb.add_child(txt_l)
	hint_l = UIKit.label("", 12, Color("#8a6a4a")); hint_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; vb.add_child(hint_l)
	for l in [who_l, txt_l, hint_l]: l.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _q(sel: String) -> String:
	var e = J.mc(el, "querySelector", [sel])
	return J.str(J.gp(e, "textContent")) if e != null else ""

# 張卡喺本節點座標入面嘅位置
func _card_rect() -> Rect2:
	var t = W.tags.get(card_id)
	if t == null: return Rect2()
	var b: Control = t.b
	if not _scrolled:
		_scrolled = true; W.scroll.ensure_control_visible(b)
	return Rect2(b.global_position - global_position, b.size)

func _process(dt: float) -> void:
	_t += dt
	if el == null or el.parentNode == null: queue_free(); return
	who_l.text = _q("b"); txt_l.text = _q("span"); hint_l.text = _q("small")
	var r = _card_rect(); var pad = 5.0
	var bw = size.x - 32
	box.size = Vector2(bw, 0); box.reset_size(); box.size.x = bw
	var bh = box.get_combined_minimum_size().y
	var above = r.position.y - pad - 20 - bh - 8
	box.position = Vector2(16, above if above >= 56 or r.size == Vector2.ZERO else r.end.y + pad + 12)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(10 / 255.0, 8 / 255.0, 14 / 255.0, 0.25))
	var r = _card_rect()
	if r.size == Vector2.ZERO: return
	var pad = 5.0; var rr = r.grow(pad)
	var k = 0.5 - 0.5 * cos(_t * TAU / 1.1)
	# 發光：幾層由大到細嘅半透明框
	for i in 4:
		var g = 4.0 + i * (4.0 + 4.0 * k)
		_rrect(rr.grow(g), Color(1.0, 0.8 + 0.05 * k, 0.4, (0.32 + 0.2 * k) / (i + 1)), 4.0)
	_rrect(rr, Color("#ffd36a").lerp(Color("#fff1b8"), k), 3.0)
	# 箭咀（上下彈）
	var cx = r.position.x + r.size.x / 2; var ty = rr.position.y - 14 + 6 * (0.5 - 0.5 * cos(_t * TAU / 0.8))
	var tri = PackedVector2Array([Vector2(cx - 10, ty - 13 + 13), Vector2(cx + 10, ty), Vector2(cx, ty + 13)])
	tri = PackedVector2Array([Vector2(cx - 10, ty), Vector2(cx + 10, ty), Vector2(cx, ty + 13)])
	draw_colored_polygon(PackedVector2Array([tri[0] + Vector2(0, 2), tri[1] + Vector2(0, 2), tri[2] + Vector2(0, 2)]), Color(0, 0, 0, 0.5))
	draw_colored_polygon(tri, Color("#ffd36a"))

func _rrect(r: Rect2, c: Color, w: float) -> void:
	var sb = StyleBoxFlat.new(); sb.draw_center = false; sb.border_color = c
	sb.set_border_width_all(int(w)); sb.set_corner_radius_all(18); sb.anti_aliasing = true
	draw_style_box(sb, r)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		if el != null: el.fire("click", {"type": "click", "target": el, "currentTarget": el, "stopPropagation": func(_t2, _a): pass, "preventDefault": func(_t2, _a): pass})
