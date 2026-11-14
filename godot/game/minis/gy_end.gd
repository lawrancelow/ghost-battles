# 亂葬崗結算卡（原生）：DOM 版 #gy-end 嘅 overflow:auto 卡片喺 Godot DOM 會溢出（字疊字），改原生畫
# 資料由 graveyard.js finish() 整好（_endRows / _endInfo）；兩個掣照叫 JS 原本嘅 handler（_endBack / _endNext）
class_name GyEnd
extends Control

static var cur: GyEnd = null
var G: Dictionary

static func L(s) -> String: return J.str(DB.L(J.str(s)))

static func hook(g) -> bool:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null or not (g is Dictionary): return false
	close()
	var e = GyEnd.new(); e.G = g; e.name = "GyEnd"
	e.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(e)
	var dom = main.get("dom")
	if dom: main.move_child(e, dom.get_index() + 1)
	cur = e; e._build()
	return true

static func close() -> void:
	if cur != null and is_instance_valid(cur): cur.queue_free()
	cur = null

func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.55); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(dim)
	var info: Dictionary = G.get("_endInfo", {})
	var card = PanelContainer.new()
	card.add_theme_stylebox_override("panel", UIKit.sb(Color("#f3e8cf"), 16, Color(0, 0, 0, 0), 0, Vector4(16, 16, 16, 14)))
	card.anchor_left = 0.5; card.anchor_right = 0.5; card.anchor_top = 0.5; card.anchor_bottom = 0.5
	var w = minf(360.0, get_viewport_rect().size.x * 0.92)
	card.offset_left = -w / 2; card.offset_right = w / 2
	add_child(card)
	var sc = ScrollContainer.new(); sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; card.add_child(sc)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sc.add_child(vb)
	var tl = UIKit.label(L(info.get("title", "")), 24, Color("#2a1a10"), "serif", 900); tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(tl)
	var wd = UIKit.label(L(info.get("word", "")), 14, UIKit.INKDIM); wd.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; wd.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; vb.add_child(wd)
	for r in G.get("_endRows", []):
		var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 8); vb.add_child(row)
		var tg = UIKit.label(J.str(r.tag), 22, Ctx.col(J.str(r.col)), "sans", 900); tg.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8)); tg.add_theme_constant_override("outline_size", 4)
		tg.vertical_alignment = VERTICAL_ALIGNMENT_TOP; row.add_child(tg)
		var tx = UIKit.rich("%s\n[font_size=13][color=#6e5838]%s[/color][/font_size]" % [L(r.a), L(r.b)], 15, Color("#2a1a10"))
		tx.fit_content = true; tx.scroll_active = false; tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(tx)
		var ln = ColorRect.new(); ln.color = Color(0.35, 0.24, 0.12, 0.25); ln.custom_minimum_size = Vector2(0, 1); vb.add_child(ln)
	var stay = J.str(info.get("stay", ""))
	if stay != "":
		var st = UIKit.label(L(stay), 14, Color("#5a2a6a"), "sans", 700); st.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; st.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(st)
	var rw = UIKit.rich("[center]%s%s[/center]" % [L("獎勵："), JSBridge.html2bb(J.str(DB.L(J.str(info.get("got", "")))))], 14, UIKit.INKDIM)
	rw.fit_content = true; rw.scroll_active = false; vb.add_child(rw)
	var acts = HBoxContainer.new(); acts.add_theme_constant_override("separation", 8); vb.add_child(acts)
	var b1 = UIKit.btn(L("回村子")); var b2 = UIKit.btn(L("下一夜"), "gold")
	for b in [b1, b2]: b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.custom_minimum_size = Vector2(0, 44); acts.add_child(b)
	b1.pressed.connect(func(): _go("_endBack"))
	b2.pressed.connect(func(): _go("_endNext"))
	# 卡高：內容高度，最多畫面 92%
	await get_tree().process_frame
	var h = minf(vb.get_combined_minimum_size().y + 32, get_viewport_rect().size.y * 0.92)
	card.offset_top = -h / 2; card.offset_bottom = h / 2

func _go(m: String) -> void:
	Snd.play("click")
	var g = G
	close()
	J.mc(g, m, [])
