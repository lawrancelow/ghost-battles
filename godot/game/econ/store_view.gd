# [ux] 倉庫／材料總覽（冇 class_name；熱更新規矩）
# 入口：頂欄任何一格資源（撳落去）。分一級／二級／三級／四級以上／其他，每樣：庫存、每分鐘進／出、由邊度嚟、去邊度。
# 用法：var v = load("res://game/econ/store_view.gd").new(); v.focus = "buns"; main.add_child(v)
extends CanvasLayer

const SW = preload("res://game/econ/stock_watch.gd")
const M = preload("res://game/outpost/mat.gd")
const PACE = preload("res://game/econ/pace.gd")
const TABS := [["一級", 1], ["二級", 2], ["三級", 3], ["四級以上", 4], ["其他", 0]]
const RES2MID := {"wood": "m_wood", "rice": "m_rice", "planks": "m_plank", "buns": "m_shoubao", "coins": "coins", "troops": "troops", "bao": "m_bao"}
# 唔係生產鏈（RECIPES）入面嘅用途：講清楚啲貨仲會去邊
const EXTRA_USE := {
	"m_wood": ["棺材鋪做棺材板"],
	"m_rice": ["包子鋪包普通包子"],
	"m_plank": ["建築升級", "修理被襲擾的建築"],
	"m_bao": ["鬼怪升級（Lv10 前）", "招魂", "練嚇功", "嘆氣蒸籠蒸壽包"],
	"m_shoubao": ["鬼怪升級（Lv10 起）", "出擊陰兵口糧", "派宵夜", "大排檔賣錢"],
	"coins": ["建築升級", "鬼怪升級", "招魂", "大排檔台升級"],
	"troops": ["出擊（每 25 個一隊）", "守村防襲擾"],
}
const EXTRA_SRC := {"coins": ["大排檔賣貨", "打關卡", "開紫箱"], "troops": ["民宅（遊魂自願加入）"], "m_shoubao": ["嘆氣蒸籠", "綠箱"]}

var focus := ""        # 頂欄撳邊格入嚟（res 鍵）
var help_txt := ""     # 嗰格嘅說明
var tab := -1
var _root: Control
var _body: VBoxContainer
var _tabs := []
var _t := 0.0

func _ready() -> void:
	layer = 100; name = "StoreView"
	_root = Control.new(); _root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); _root.mouse_filter = Control.MOUSE_FILTER_STOP; add_child(_root)
	var dim = ColorRect.new(); dim.color = Color(0.02, 0.01, 0.03, 0.75); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); _root.add_child(dim)
	dim.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: close())
	var win = PanelContainer.new(); win.name = "Win"
	win.add_theme_stylebox_override("panel", UIKit.sb(Color("#f1e3bd"), 12, Color("#6b4a2b"), 3, Vector4(12, 10, 12, 12)))
	_root.add_child(win)
	var fit = func():
		var vs = _root.size; var w = minf(vs.x - 16.0, 620.0); var h = vs.y - 120.0
		win.position = Vector2((vs.x - w) * 0.5, 60.0); win.size = Vector2(w, h)
	_root.resized.connect(fit); fit.call()
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); win.add_child(vb)
	var hb = HBoxContainer.new(); vb.add_child(hb)
	var tl = UIKit.label("倉庫總覽", 24, Color("#3a1d10"), "serif", 900); tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(tl)
	var x = UIKit.btn("✕", "gold"); x.name = "Close"; x.custom_minimum_size = Vector2(46, 42); x.pressed.connect(close); hb.add_child(x)
	if help_txt != "":
		var h = RichTextLabel.new(); h.bbcode_enabled = true; h.fit_content = true; h.text = help_txt; h.add_theme_font_size_override("normal_font_size", 15); h.add_theme_font_size_override("bold_font_size", 15)
		h.add_theme_color_override("default_color", Color("#3a2414")); vb.add_child(h)
	var pl = PACE.label()
	if pl != "": vb.add_child(_lbl(pl, 13, Color("#2e5d55")))
	var tb = HBoxContainer.new(); tb.add_theme_constant_override("separation", 4); vb.add_child(tb)
	for i in TABS.size():
		var b = UIKit.btn(TABS[i][0], "", true); b.name = "Tab%d" % i; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.custom_minimum_size = Vector2(0, 40)
		var ii = i; b.pressed.connect(func(): tab = ii; _render()); tb.add_child(b); _tabs.append(b)
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; vb.add_child(sc)
	_body = VBoxContainer.new(); _body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; _body.add_theme_constant_override("separation", 6); sc.add_child(_body)
	if tab < 0: tab = _tab_of(focus)
	_render()

func close() -> void: queue_free()
func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and e.keycode == KEY_ESCAPE: close(); get_viewport().set_input_as_handled()

func _process(dt: float) -> void:
	_t += dt
	if _t >= 1.0: _t = 0.0; _render()

static func key_of(res_key: String) -> String: return RES2MID.get(res_key, res_key)
static func nm(k: String) -> String:
	if k == "coins": return "冥幣"
	if k == "troops": return "陰兵"
	return M.name(k)
static func tier_of(k: String) -> int:
	if k in SW.EXTRA: return 0
	return clampi(M.tier(k), 1, 4)
func _tab_of(res_key: String) -> int:
	var t = tier_of(key_of(res_key)) if res_key != "" else 1
	for i in TABS.size(): if TABS[i][1] == t: return i
	return 0

# 要顯示嘅：有庫存、有進出、或者係核心資源
static func shown(k: String) -> bool:
	if k in ["m_wood", "m_rice", "m_plank", "m_bao", "m_shoubao", "coins", "troops"]: return true
	var r = SW.rate(k)
	return SW.amt(k) >= 0.5 or r[0] > 0.01 or r[1] > 0.01

# 瓶頸：用緊（出 > 進）而且就快用完
static func bottlenecks() -> Array:
	var o = []
	for k in SW.keys():
		var r = SW.rate(k)
		if r[1] > 0.05 and r[1] > r[0] + 0.05 and SW.amt(k) < maxf(10.0, r[1] * 2.0): o.append(k)
	return o

func _render() -> void:
	if _body == null: return
	for c in _body.get_children(): c.queue_free()
	for i in _tabs.size(): _tabs[i].modulate = Color(1, 1, 1) if i == tab else Color(0.7, 0.66, 0.62)
	var bn = bottlenecks()
	if bn.size():
		var t = "[b][color=#b0281c]快不夠用：[/color][/b]" + "、".join(bn.map(func(k): return "%s（每分鐘用 %s／產 %s）" % [nm(k), M.qty(SW.rate(k)[1]), M.qty(SW.rate(k)[0])]))
		t += "\n[color=#6e5838]處理：派更多鬼去生產它的地方，或先暫停用它的台。[/color]"
		_body.add_child(_rich(t, 13))
	var want = TABS[tab][1]; var n = 0; var hid = 0
	for k in SW.keys():
		if tier_of(k) != want: continue
		if not shown(k): hid += 1; continue
		_body.add_child(_row(k)); n += 1
	if n == 0: _body.add_child(_lbl("這一級暫時沒有貨。", 14, Color("#6e5838")))
	if hid > 0: _body.add_child(_lbl("還有 %d 種材料未有庫存（解鎖對應建築／台後會出現）。" % hid, 12, Color("#8a7458")))

func _row(k: String) -> Control:
	var pc = PanelContainer.new(); pc.name = "Row_" + k
	var hl = k == key_of(focus)
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.96, 0.84, 0.75 if hl else 0.45), 6, Color("#c0392b") if hl else Color("#b89a52"), 2 if hl else 1, Vector4(10, 6, 10, 6)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 1); pc.add_child(vb)
	var top = HBoxContainer.new(); vb.add_child(top)
	var a = SW.amt(k)
	var cap = 0.0
	if k == "troops":
		var F = J.G.get("F"); cap = J.num(J.mc(F, "troopCap", [])) if F != null else 0.0
	elif not (k in SW.EXTRA): cap = M.cap(k)
	var name_l = UIKit.label(nm(k), 18, Color("#2b1d12"), "serif", 800); name_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; top.add_child(name_l)
	var amt_t = M.qty(floor(a)) + (("／" + M.qty(cap)) if cap > 0 and cap < 1e8 else "")
	var al = UIKit.label(amt_t, 18, Color("#b0281c") if cap > 0 and a >= cap - 0.5 else Color("#2b1d12"), "sans", 800); al.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; al.custom_minimum_size = Vector2(110, 0); top.add_child(al)
	var r = SW.rate(k)
	var rt = "[color=#2e7d3a]+%s／分[/color]　[color=#b0281c]−%s／分[/color]" % [M.qty(snappedf(r[0], 0.1)), M.qty(snappedf(r[1], 0.1))]
	var net = r[0] - r[1]
	rt += "　淨 %s%s" % ["+" if net >= 0 else "−", M.qty(snappedf(absf(net), 0.1))]
	if cap > 0 and a >= cap - 0.5: rt += "　[color=#b0281c][b]倉庫滿了：再做也不會增加，請升級倉庫或賣掉[/b][/color]"
	vb.add_child(_rich(rt, 14))
	var src = SW.sources(k) + EXTRA_SRC.get(k, [])
	var use = EXTRA_USE.get(k, []) + SW.uses(k)
	if src.size(): vb.add_child(_rich("[color=#6e5838]來自：%s[/color]" % "、".join(_uniq(src).slice(0, 5)), 12))
	if use.size(): vb.add_child(_rich("[color=#6e5838]用途：%s[/color]" % "、".join(_uniq(use).slice(0, 6)), 12))
	return pc

static func _uniq(a: Array) -> Array:
	var o = []
	for x in a: if not o.has(x): o.append(x)
	return o
func _lbl(t: String, sz: int, c: Color) -> Label:
	var l = UIKit.label(t, sz, c); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; return l
func _rich(t: String, sz: int) -> RichTextLabel:
	var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false; r.text = t
	r.add_theme_font_size_override("normal_font_size", sz); r.add_theme_font_size_override("bold_font_size", sz)
	r.add_theme_color_override("default_color", Color("#3a2414")); return r
