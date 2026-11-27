# [onboard] 第一章新手教程：手指＋挖洞遮罩（只亮目標）＋說明（最多 2 行，永遠唔遮住講緊嗰樣嘢）
# 規矩（老闆 11-27）：每步要玩家真係做（唔自動完成）；每步可以「跳過此步」（只係收起提示，任務照做）；冇「一鍵跳過全部」。
# 冇 class_name（熱更新）：main.gd 用 load("res://ui/onboard/tut.gd").attach(self)。
# 讓位：劇情播緊、任何彈窗／面板開咗（main.sheet、G 組彈窗佇列、其他全屏層）→ 收起，唔搶畫面。
extends Control

const OB = preload("res://game/onboard/ob.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const MASK := Color(0.03, 0.02, 0.04, 0.58)
const GOLD := Color("#ffd84a")
const PAD := 10.0

var main = null
var hole := Rect2()       # 螢幕座標（目標）
var tip_rect := Rect2()   # 說明框（測試用）
var key := ""             # 當前步（任務 key）
var shown := false
var t := 0.0
var tip: PanelContainer
var tip_lbl: Label
var skip_btn: Button
var _panned := ""
static var LOG: Array = []   # 測試：[["step", key], ["skip", key]]

static func attach(m) -> Control:
	var o = m.get_node_or_null("OnboardTut")
	if o != null: return o
	o = load("res://ui/onboard/tut.gd").new()
	o.name = "OnboardTut"; o.main = m
	o.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	o.mouse_filter = Control.MOUSE_FILTER_STOP
	o.z_index = 50
	m.add_child(o)
	o._build()
	return o

func _build() -> void:
	tip = PanelContainer.new()
	var s = StyleBoxFlat.new(); s.bg_color = Color("#f4ead2"); s.border_color = Color("#8a5a2a"); s.set_border_width_all(2); s.set_corner_radius_all(8)
	s.content_margin_left = 12; s.content_margin_right = 10; s.content_margin_top = 8; s.content_margin_bottom = 8
	s.shadow_color = Color(0, 0, 0, 0.45); s.shadow_size = 6
	tip.add_theme_stylebox_override("panel", s)
	tip.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(tip)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); tip.add_child(hb)
	tip_lbl = Label.new(); tip_lbl.add_theme_font_size_override("font_size", 14); tip_lbl.add_theme_color_override("font_color", Color("#2b1d12"))
	tip_lbl.autowrap_mode = TextServer.AUTOWRAP_OFF; tip_lbl.max_lines_visible = 2; tip_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tip_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tip_lbl.add_theme_font_override("font", UIKit.font("sans", 700))
	hb.add_child(tip_lbl)
	skip_btn = Button.new(); skip_btn.text = OB.T("跳過此步", "跳過此步"); skip_btn.focus_mode = Control.FOCUS_NONE
	skip_btn.add_theme_font_size_override("font_size", 12); skip_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	skip_btn.pressed.connect(_skip)
	hb.add_child(skip_btn)
	visible = false

func _skip() -> void:
	LOG.append(["skip", key])
	OB.tut_skip(); shown = false; visible = false

# 呢度唔擋：洞入面嘅撳擊穿過去（真動作）；洞外面擋住（只准做呢一步）
func _has_point(p: Vector2) -> bool:
	if not visible: return false
	if tip.visible and tip.get_global_rect().has_point(p + global_position): return false
	return not hole.grow(4).has_point(p)

func _gui_input(e) -> void:
	if e is InputEventMouseButton or e is InputEventScreenTouch: accept_event()

func _busy() -> bool:
	if main == null: return true
	var St = J.G.get("Story")
	if St != null and J.t(J.mc(St, "busy", [])): return true
	if J.t(J.mc(J.G.get("UI"), "modalOpen", [])): return true
	if main.get("sheet") != null and main.sheet.visible: return true
	if str(main.get("tab")) != "village": return true
	var pq = main.get_node_or_null("PopupQ")   # [uxui] G 組彈窗佇列（有就讓位）
	if pq != null and pq.has_method("busy") and pq.busy(): return true
	for c in main.get_children():   # 其他全屏層（揀鬼、建築卡、出擊清單…）
		if c == self or not (c is Control) or not c.visible: continue
		if c.has_meta("modal") or c.name in ["Picker", "Card", "BldCard", "SortieList", "NameCard", "Settings"]: return true
	var em = main.get("mv_embed")
	if em != null and em.get("sc") != null:
		var sc = em.sc
		if sc.get("card") != null and is_instance_valid(sc.card) and sc.card.visible: return true
		if sc.get("sheet") != null and is_instance_valid(sc.sheet) and sc.sheet.visible: return true
		if sc.get("picker") != null and is_instance_valid(sc.picker) and sc.picker.visible: return true
	return false

func _cur_q():
	var Q = J.G.get("QUESTS"); var i = OB.qi()
	return Q[i] if Q is Array and i < Q.size() else null

# 目標（螢幕座標）
func target_rect() -> Rect2:
	var q = _cur_q()
	if q == null or main == null: return Rect2()
	var vil = main.get("village")
	var go = str(q.get("go", "")); var tt = str(q.get("t", ""))
	if tt == "stage":
		var ctl = main.get_node_or_null("CtlSortie")
		if ctl == null:
			for c in main.find_children("CtlSortie", "Button", true, false): ctl = c; break
		if ctl != null and ctl.is_visible_in_tree(): return ctl.get_global_rect().grow(6)
		var tg = ZD.stage_target()
		if tg.has("pos") and vil != null and vil.has_method("zone_w2s"): return _wr(vil, tg.pos, Vector2(150, 120))
		return Rect2()
	if go == "market" and vil != null and vil.has_method("zone_w2s"):
		var r: Rect2 = ZD.zrect("market")
		if tt == "guard":   # 圍欄外：野外門嗰條線
			return _wr(vil, ZD.front_anchor(), Vector2(320, 220))
		var a = vil.zone_w2s(r.position) + vil.global_position; var b = vil.zone_w2s(r.end) + vil.global_position
		var sr = Rect2(a, b - a).intersection(Rect2(Vector2(0, main.TOP_H + 50), size - Vector2(0, main.TOP_H + 50 + main.NAV_H)))
		# 太大：只亮中間 70%（說明先放得落）
		if sr.size.y > size.y * 0.5: sr = sr.grow_individual(0, -sr.size.y * 0.18, 0, -sr.size.y * 0.18)
		return sr
	var V = J.G.get("Village")
	if V == null or vil == null or not vil.has_method("zone_w2s"): return Rect2()
	var p = J.mc(V, "questTarget", [])
	if not (p is Array): return Rect2()
	var big = go in ["plank", "bun", "wood", "rice", "house", "store", "home", "altar"]
	return _wr(vil, Vector2(J.num(p[0]), J.num(p[1]) - (40.0 if big else 20.0)), Vector2(150, 140) if big else Vector2(110, 110))

func _wr(vil, wp: Vector2, wsz: Vector2) -> Rect2:
	var c = vil.zone_w2s(wp) + vil.global_position
	var z = maxf(0.4, float(vil.get("sc")) if vil.get("sc") != null else 1.0)
	var sz = (wsz * z).clamp(Vector2(88, 88), size * 0.7)
	return Rect2(c - sz / 2, sz)

func _process(dt: float) -> void:
	t += dt
	var on = OB.tut_on() and not _busy()
	if not on:
		if visible: visible = false
		return
	var q = _cur_q()
	var k = OB._key(q)
	if k != key:
		key = k; LOG.append(["step", key])
		_panned = ""
	if _panned != key and main.has_method("_quest_go"):   # 第一次：鏡頭帶去目標
		_panned = key; main._quest_go()
		return
	hole = target_rect()
	if hole.size == Vector2.ZERO or not Rect2(Vector2.ZERO, size).intersects(hole):
		visible = false; return
	hole = hole.intersection(Rect2(Vector2.ZERO, size))
	tip_lbl.text = OB.tip_of(q)
	_place_tip()
	visible = true; shown = true
	queue_redraw()

# 說明框：揀洞嘅對面嗰邊（上／下），一定唔疊住個洞
func _place_tip() -> void:
	tip.reset_size()
	var ts = tip.get_combined_minimum_size()
	var w = minf(size.x - 24, maxf(ts.x, 260.0)); var h = ts.y
	var top_y = float(main.TOP_H) + 52.0
	var bot_y = size.y - float(main.NAV_H) - h - 10.0
	var above = Rect2(12, maxf(top_y, hole.position.y - h - 70), w, h)   # 洞上面（手指喺洞頂，要讓多啲位）
	var below = Rect2(12, minf(bot_y, hole.end.y + 16), w, h)
	# 先試頂（主線條下面）：底部係提示訊息（toast）出嘅位，放底會俾佢蓋住
	var cand = [Rect2(12, top_y, w, h), below, above, Rect2(12, bot_y, w, h)]
	cand.append(Rect2(12, float(main.TOP_H) + 4, w, h))   # 最後：疊喺主線條（唔係講緊嘅嘢）
	var pick = cand[cand.size() - 1]
	for r in cand:
		if not r.intersects(hole.grow(6)) and r.position.y >= 0 and r.end.y <= size.y: pick = r; break
	pick.position.x = clampf(hole.get_center().x - w / 2, 12, size.x - w - 12)
	if pick.intersects(hole.grow(6)):
		pick.position.x = 12 if hole.get_center().x > size.x / 2 else size.x - w - 12
	tip.position = pick.position; tip.size = Vector2(w, h)
	tip_rect = Rect2(tip.position, tip.size.max(tip.get_combined_minimum_size()))

func _draw() -> void:
	if not visible: return
	var r = hole
	var W = size.x; var H = size.y
	draw_rect(Rect2(0, 0, W, r.position.y), MASK)
	draw_rect(Rect2(0, r.end.y, W, H - r.end.y), MASK)
	draw_rect(Rect2(0, r.position.y, r.position.x, r.size.y), MASK)
	draw_rect(Rect2(r.end.x, r.position.y, W - r.end.x, r.size.y), MASK)
	var pulse = 0.55 + 0.45 * sin(t * 5.0)
	draw_rect(r, Color(GOLD, 0.55 + 0.4 * pulse), false, 3.0)
	# 手指：由右下指入洞中心（郁吓郁吓）
	var c = r.get_center() + Vector2(10, 10)
	var off = Vector2(1, 1).normalized() * (14.0 + 8.0 * sin(t * 6.0))
	_finger(c + off)

func _finger(p: Vector2) -> void:
	var sk = Color("#fbe3c4"); var ln = Color("#5a3418")
	var pts = PackedVector2Array([p, p + Vector2(10, 6), p + Vector2(30, 26), p + Vector2(44, 22), p + Vector2(54, 34), p + Vector2(46, 58), p + Vector2(22, 62), p + Vector2(12, 44), p + Vector2(4, 12)])
	draw_colored_polygon(pts, sk)
	pts.append(p)
	draw_polyline(pts, ln, 2.0, true)
	draw_circle(p + Vector2(2, 3), 5.0, Color(GOLD, 0.8))
