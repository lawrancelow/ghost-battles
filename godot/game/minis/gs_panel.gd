# 冥街夜市介面（原生）：頂欄（回村／冥街夜市／冥幣）、底部攤位面板（DomMirror 照住 #gs-panel 畫）、畫布觸控
# 規則、攤位邏輯全部留喺 ghoststreet.js（renderPanel／bind_xxx 照舊寫 DOM，DOM 收埋唔排版）
# GB_GSDOM=1 用返 DOM 版
class_name GsPanel
extends NatPanel

var top: PanelContainer
var coins: Label
var panel: PanelContainer
var scroll: ScrollContainer
var mir: DomMirror
var _pel = null

const PURPLE := Color("#2e2638")

static func style() -> Dictionary:
	var gold = Color("#f3d68a"); var dim = Color("#c8bcd8"); var sub = Color("#bfb2cf")
	return {
		".gs-hint": {"s": 15, "c": Color("#d8cce8")},
		".gs-chips": {"grid": 5, "gap": 6},
		".gs-chip": {"bs": [PURPLE, 10, Color("#5a4a6a"), 1, Vector4(2, 11, 2, 11)], "s": 15, "c": Color("#f3e6c8")},
		".gs-note": {"s": 13, "c": dim},
		".gs-note.dim": {"alpha": 0.7},
		".gs-ph": {"row": true, "gap": 8},
		".gs-ph b": {"s": 20, "c": gold, "serif": true, "b": true, "expand": true},
		".gs-x": {"bs": [PURPLE, 99, Color("#6a5a7a"), 1, Vector4(14, 7, 14, 7)], "s": 15, "c": Color("#dddddd")},
		".gs-body": {"gap": 6},
		".gs-line": {"s": 15, "c": Color("#f0e8dc"), "box": [Color(0.957, 0.925, 0.84, 0.08), 10, Color(0.953, 0.84, 0.54, 0.18), 1, Vector4(11, 8, 11, 8)]},
		".gs-line.bad": {"box": [Color(0.886, 0.282, 0.227, 0.16), 10, Color(0.886, 0.282, 0.227, 0.5), 1, Vector4(11, 8, 11, 8)]},
		".gs-line b": {"c": Color("#ffcf6a"), "pad_r": 1},
		".gs-list": {"gap": 7},
		".gs-card": {"row": true, "gap": 10, "box": [Color("#231c2c"), 12, Color("#4a3a5a"), 1, Vector4(11, 9, 11, 9)]},
		".gs-card.own": {"alpha": 0.6},
		".gs-ci": {"gap": 2, "expand": true},
		".gs-ci b": {"s": 16, "c": Color("#f6ead0")},
		".gs-ci small": {"s": 13, "c": sub},
		".gs-eff": {"c": Color("#9be8b0"), "b": true},
		".gs-card em": {"s": 14, "c": Color("#ffcf6a"), "b": true},
		".gs-hag": {"gap": 4},
		".gs-iname": {"s": 18, "c": Color("#f6ead0"), "serif": true, "b": true},
		".gs-hag small": {"s": 13, "c": sub},
		".gs-prices": {"row": true, "gap": 16},
		".gs-prices span": {"s": 14, "c": dim},
		".gs-prices b": {"s": 16, "c": Color("#ffe08a")},
		".gs-mood": {"row": true, "gap": 4},
		".gs-mood span": {"s": 13, "c": sub},
		".gs-mood i": {"s": 13, "b": true, "c": Color("#8a8098"), "pill": true, "center": true, "expand": true, "box": [Color("#2a2433"), 6, Color(0, 0, 0, 0), 0, Vector4(2, 4, 2, 4)]},
		".gs-mood em": {"hide": true},
		".gs-offer": {"row": true, "gap": 8},
		"#gs-go": {"s": 17, "h": 44},
		"#gs-back2": {"h": 40},
		".gs-stock": {"row": true, "gap": 10},
		".gs-stock div": {"gap": 0, "w": 96},
		".gs-stock small": {"s": 12, "c": sub},
		".gs-px": {"s": 30, "c": Color("#ffe08a"), "b": true, "block": true},
		".gs-stock em": {"s": 14, "b": true, "block": true},
		".up": {"c": Color("#7fe0a0")}, ".dn": {"c": Color("#ff8a7a")},
		"#gs-chart": {"h": 84, "w": 120},
		".gs-trade": {"grid": 5, "gap": 5},
		".gs-trade button": {"s": 14},
		".gs-al": {"h": 42},
	}

func _build() -> void:
	cv_el = _el("#gs-cvs")
	_make_touch()
	# ---- 頂欄 ----
	top = PanelContainer.new(); top.mouse_filter = Control.MOUSE_FILTER_STOP
	top.add_theme_stylebox_override("panel", _grad_sb(Color("#1d1822"), Color("#151119"), Vector4(10, 8, 10, 8)))
	add_child(top)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); top.add_child(hb)
	var bb = UIKit.btn(L("回村")); bb.focus_mode = Control.FOCUS_NONE; bb.add_theme_font_size_override("font_size", 16); hb.add_child(bb)
	bb.pressed.connect(func(): _click("#gs-back"))
	var t = UIKit.label(L("冥街夜市"), 20, Color("#f3d68a"), "serif", 900); t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; hb.add_child(t)
	var cb = HBoxContainer.new(); cb.add_theme_constant_override("separation", 4); cb.custom_minimum_size.x = 76; cb.alignment = BoxContainer.ALIGNMENT_END; hb.add_child(cb)
	var ic = TextureRect.new(); ic.texture = load("res://ui/res_icon.gd").tex("coins"); ic.custom_minimum_size = Vector2(20, 20)
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER; cb.add_child(ic)
	coins = UIKit.label("", 16, Color("#ffe08a"), "sans", 800); coins.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; cb.add_child(coins)
	# ---- 底部面板（蓋喺畫布上，最高 47%）----
	panel = PanelContainer.new(); panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var ps = UIKit.sb(Color("#17111d"), 0, Color("#4a3a5a"), 0, Vector4(12, 10, 12, 10))
	ps.corner_radius_top_left = 14; ps.corner_radius_top_right = 14; ps.border_width_top = 1; ps.border_color = Color("#4a3a5a")
	ps.shadow_color = Color(0, 0, 0, 0.5); ps.shadow_size = 10
	panel.add_theme_stylebox_override("panel", ps)
	add_child(panel)
	scroll = ScrollContainer.new(); scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; panel.add_child(scroll)
	mir = DomMirror.new(); scroll.add_child(mir)
	_pel = _el("#gs-panel")
	mir.setup(_pel, style())
	mir.on_built = func(): scroll.scroll_vertical = 0
	mir.sync(true)

func _tick(_dt: float) -> void:
	if not J.t(G.get("active")): return
	mir.sync()
	var ce = _el("#gs-coins i")
	if ce is El:
		var v = ce._text()
		if coins.text != v: coins.text = v

func _layout() -> void:
	var W = size.x; var H = size.y
	var th = top.get_combined_minimum_size().y
	if top.size != Vector2(W, th): top.position = Vector2.ZERO; top.size = Vector2(W, th)
	# 面板：內容高度，最多 47%
	var ch = mir.get_combined_minimum_size().y
	var maxh = (H - th) * 0.47 - 20
	var want = Vector2(0, minf(ch, maxh))
	if scroll.custom_minimum_size != want: scroll.custom_minimum_size = want
	var ph = panel.get_combined_minimum_size().y
	if panel.position != Vector2(0, H - ph): panel.position = Vector2(0, H - ph)
	if panel.size != Vector2(W, ph): panel.size = Vector2(W, ph)
	# JS targetVH() 讀 #gs-panel.offsetHeight
	if _pel is El:
		var r = _pel.props.get("_rect", {})
		if not (r is Dictionary) or r.get("height", -1.0) != ph: _pel.props["_rect"] = {"left": 0.0, "top": H - ph - th, "width": W, "height": ph}
	_set_stage(Rect2(0, th, W, H - th))
	# 觸控範圍：唔好蓋到面板（面板喺上面，事件先到面板）
