# 運動會介面（原生）：頂欄（收場／項目名／即時成績）、底部面板（DomMirror 照住 #sp-panel：規則、掣、結算卡）、畫布觸控
# 規則全部留喺 sports.js；掣係 pointerdown 監聽（快速連按），DomMirror 照樣 fire
# 畫布高度開場定咗（JS 只係開場 resize）；結算卡長高咗就蓋喺畫布上，同網頁版一樣唔再縮畫布
# GB_SPDOM=1 用返 DOM 版
class_name SpPanel
extends NatPanel

var top: PanelContainer
var title: Label
var hud: Label
var panel: PanelContainer
var mir: DomMirror
var _fixed := -1.0     # 開場時面板高度（畫布底）
var _settle := 0

static func style() -> Dictionary:
	return {
		"#sp-rule": {"s": 13, "c": Color(0.953, 0.918, 0.847, 0.88)},
		"#sp-rule i": {"c": Color("#ffd0a0")},
		".gp-sub": {"s": 12, "c": Color("#c8bcd8")},
		"#sp-btns": {"row": true, "gap": 10, "h": 58},
		".sp-b": {"s": 22, "h": 58, "expand": true},
		".sp-tip": {"s": 14, "c": Color(0.95, 0.92, 0.85, 0.85), "center": true, "expand": true},
		".sp-end": {"gap": 4},
		".sp-end h3": {"s": 20, "c": Color("#ffd84a"), "b": true},
		".sp-big": {"s": 30, "b": true, "c": Color("#f3ead8")},
		".desc": {"s": 14, "c": Color("#efe4cc")},
		".sp-endb": {"row": true, "gap": 10},
		".sp-endb button": {"expand": true, "h": 46, "s": 16},
	}

func _build() -> void:
	cv_el = _el("#sp-cvs")
	_make_touch()
	top = PanelContainer.new(); top.mouse_filter = Control.MOUSE_FILTER_STOP
	top.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.45), 0, Color(0, 0, 0, 0), 0, Vector4(12, 8, 12, 8)))
	add_child(top)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); top.add_child(hb)
	var bq = UIKit.btn(L("收場"), "ghost", true); bq.focus_mode = Control.FOCUS_NONE; hb.add_child(bq)
	for st in ["normal", "hover", "pressed"]: bq.add_theme_stylebox_override(st, UIKit.sb(Color(1, 1, 1, 0.06 if st != "pressed" else 0.12), 4, Color("#6a5a70"), 1, Vector4(11, 6, 11, 6)))
	for c in ["font_color", "font_hover_color", "font_pressed_color"]: bq.add_theme_color_override(c, Color("#e8dcef"))
	bq.pressed.connect(func(): _click("#sp-quit"))
	title = UIKit.label("", 17, Color("#ffd84a"), "sans", 900); title.size_flags_horizontal = Control.SIZE_EXPAND_FILL; title.clip_text = true; hb.add_child(title)
	var tb = _el("#sp-top b")
	if tb is El: title.text = L(tb._text())
	hud = UIKit.label("", 14, Color("#f3ead8")); hud.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(hud)
	panel = PanelContainer.new(); panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var ps = UIKit.sb(Color(0.118, 0.094, 0.133, 0.96), 0, Color(1, 1, 1, 0.08), 0, Vector4(14, 10, 14, 12)); ps.border_width_top = 1
	panel.add_theme_stylebox_override("panel", ps)
	add_child(panel)
	mir = DomMirror.new(); panel.add_child(mir)
	mir.setup(_el("#sp-panel"), style())
	mir.sync(true)
	# 開場：未有排版寬度，規則字高度未準 → 先估；之後幾幀排好再 resize 一次
	_fixed = -1.0; _settle = 0

func _tick(_dt: float) -> void:
	mir.sync()
	var h = _el("#sp-hud")
	if h is El:
		var t = h._text()
		if hud.text != t: hud.text = t

func _layout() -> void:
	var W = size.x; var H = size.y
	var th = top.get_combined_minimum_size().y
	if top.size != Vector2(W, th): top.position = Vector2.ZERO; top.size = Vector2(W, th)
	var ph = panel.get_combined_minimum_size().y
	if panel.position != Vector2(0, H - ph): panel.position = Vector2(0, H - ph)
	if panel.size != Vector2(W, ph): panel.size = Vector2(W, ph)
	var ended = J.str(G.get("phase", "")) == "end"
	if not ended and _settle < 4:
		_settle += 1
		_fixed = ph
	var bottom = H - (_fixed if _fixed > 0 else ph)
	if _set_stage(Rect2(0, th, W, maxf(60.0, bottom - th))):
		JSRun.win_fire("resize")
