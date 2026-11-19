# 分村面板（原生 UIKit）：補給線、存糧倉、3 個檔（壽包檔／歇腳檔／守夜檔），派鬼駐守、升級、急件車
# 由 Garrison.open(ci) 開；底圖用嗰張地圖嘅 bg_<site>
extends Control

const PAPER := Color(0.93, 0.85, 0.64, 0.94)
const LINE := Color("#b89a52")
const INK := Color("#2b1d12")
const DIM := Color("#5e4a30")
const RED := Color("#b8322a")
const GREEN := Color("#3d7a3a")
const GOLD := Color("#f3d68a")
const W := 390.0

var ci := -1
var bg: TextureRect
var title_lbl: Label
var sub_lbl: Label
var chips: HBoxContainer
var night_lbl: Label
var night_bar: ProgressBar
var scroll: ScrollContainer
var body: VBoxContainer
var picker: Control
var _last_done := -1.0

func GR(): return get_node("/root/Garrison")
func T(y: String, z: String) -> String: return GR().T(y, z)
func N(s: String) -> String: return GR().N(s)
func fmt(v) -> String: return GR().fmt(v)

func _ready() -> void: _build()

func _build() -> void:
	if bg != null: return
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP
	var base = ColorRect.new(); base.color = Color("#16131b"); base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(base)
	bg = TextureRect.new(); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var shade = ColorRect.new(); shade.color = Color(0.05, 0.04, 0.06, 0.45); shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); shade.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(shade)
	var mc = MarginContainer.new(); mc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for k in ["left", "right"]: mc.add_theme_constant_override("margin_" + k, 12)
	mc.add_theme_constant_override("margin_top", 14); mc.add_theme_constant_override("margin_bottom", 10); add_child(mc)
	var root = VBoxContainer.new(); root.add_theme_constant_override("separation", 6); mc.add_child(root)
	var head = HBoxContainer.new(); root.add_child(head)
	title_lbl = _lbl("", 27, GOLD, "serif", 900); title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.add_theme_constant_override("outline_size", 6); title_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85)); head.add_child(title_lbl)
	var cl = UIKit.btn("✕", "", false); cl.custom_minimum_size = Vector2(46, 46); cl.pressed.connect(close); head.add_child(cl)
	sub_lbl = _lbl("", 16, Color("#f0e2c8")); sub_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub_lbl.add_theme_constant_override("outline_size", 5); sub_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85)); root.add_child(sub_lbl)
	var cs = ScrollContainer.new(); cs.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; cs.custom_minimum_size = Vector2(0, 44); root.add_child(cs)
	chips = HBoxContainer.new(); chips.add_theme_constant_override("separation", 6); cs.add_child(chips)
	var nb = PanelContainer.new(); nb.add_theme_stylebox_override("panel", UIKit.sb(Color(0.08, 0.06, 0.1, 0.78), 8, Color(LINE, 0.6), 1, Vector4(12, 8, 12, 8))); root.add_child(nb)
	var nv = VBoxContainer.new(); nv.add_theme_constant_override("separation", 4); nb.add_child(nv)
	night_lbl = _lbl("", 16, Color("#f0e2c8")); nv.add_child(night_lbl)
	night_bar = _bar(Color("#8f7fd0")); nv.add_child(night_bar)
	scroll = ScrollContainer.new(); scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL; scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; root.add_child(scroll)
	body = VBoxContainer.new(); body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; body.add_theme_constant_override("separation", 10); scroll.add_child(body)

# ---------------- 小部件 ----------------
func _lbl(t: String, size := 16, col := INK, kind := "sans", weight := 400) -> Label:
	var l = UIKit.label(N(t), size, col, kind, weight); return l
func _wl(t: String, size := 16, col := INK, weight := 400) -> Label:   # 會換行嘅 Label
	var l = _lbl(t, size, col, "sans", weight); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.custom_minimum_size = Vector2(10, 0); return l
func _bar(col: Color) -> ProgressBar:
	var b = ProgressBar.new(); b.show_percentage = false; b.custom_minimum_size = Vector2(0, 12); b.max_value = 1.0; b.step = 0.0
	b.add_theme_stylebox_override("background", UIKit.sb(Color(0, 0, 0, 0.35), 5))
	b.add_theme_stylebox_override("fill", UIKit.sb(col, 5)); return b
func _card() -> VBoxContainer:
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(PAPER, 10, LINE, 1, Vector4(12, 10, 12, 12)))
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL; body.add_child(pc)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 6); pc.add_child(v); return v
func _row(parent: Control) -> HBoxContainer:
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); parent.add_child(h); return h
func _stock_row(parent: Control, name: String, v: float, cap: float, col: Color) -> void:
	var h = _row(parent)
	var a = _lbl(name, 16, INK, "sans", 700); a.custom_minimum_size = Vector2(64, 0); h.add_child(a)
	var b = _bar(col); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.size_flags_vertical = Control.SIZE_SHRINK_CENTER; b.value = clampf(v / cap, 0, 1) if cap > 0 else 0.0; h.add_child(b)
	var c = _lbl("%s / %s" % [fmt(v), fmt(cap)], 15, DIM); c.custom_minimum_size = Vector2(112, 0); c.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; h.add_child(c)

# ---------------- 開／關 ----------------
func show_map(c: int) -> void:
	ci = c; visible = true; _build(); _close_picker(); rebuild(false)
func close() -> void:
	visible = false
	if picker != null and is_instance_valid(picker): picker.queue_free(); picker = null

func refresh_live() -> void:
	var g = GR().st()
	if g == null: return
	if J.num(g.done) != _last_done: rebuild(true); return
	_night_ui()

func _night_ui() -> void:
	var g = GR().st(); var nm = GR().night_ms()
	var into = fmod(J.now() - J.num(g.t0), nm); var left = maxf(0.0, (nm - into) / 1000.0)
	night_lbl.text = N(T("陰間第 %d 夜　下一夜：%d 分 %02d 秒", "陰間第 %d 夜　下一夜：%d 分 %02d 秒") % [int(J.num(g.done)) + 1, int(left / 60), int(fmod(left, 60))])
	night_bar.value = into / nm

func rebuild(keep := true) -> void:
	var sc = scroll.scroll_vertical if keep else 0
	for c in body.get_children(): body.remove_child(c); c.queue_free()
	var Gr = GR(); var g = Gr.st(); _last_done = J.num(g.done)
	_night_ui()
	for c in chips.get_children(): chips.remove_child(c); c.queue_free()
	var om = Gr.open_maps()
	if ci < 0 or om.is_empty():
		title_lbl.text = N("分村"); sub_lbl.text = N(T("未有通關嘅地圖。打贏地圖嘅主線 Boss，就可以喺嗰度開分村。", "還沒有通關的地圖。打贏地圖的主線 Boss，就可以在那裡開分村。"))
		bg.texture = Spr.get_tex("bg_village"); _supply_card(); return
	var md = Gr.map_def(ci)
	title_lbl.text = N(str(md.post))
	sub_lbl.text = N(T("%s・特產：%s", "%s・特產：%s") % [md.name, _yield_names(md.yield)])
	var k = "bg_" + str(md.bg)
	bg.texture = Spr.get_tex(k) if Spr.ok(k) else Spr.get_tex("bg_village")
	if om.size() > 1:
		for c2 in om:
			var b = UIKit.btn(N(str(Gr.map_def(c2).post)), "gold" if c2 == ci else "", true)
			b.add_theme_font_size_override("font_size", 15); b.custom_minimum_size = Vector2(0, 40)
			b.pressed.connect(func(): show_map(c2)); chips.add_child(b)
	chips.get_parent().visible = om.size() > 1
	_supply_card(); _store_card()
	for sid in Gr.STALL_IDS: _stall_card(sid)
	_log_card()
	if keep: (func(): await get_tree().process_frame; await get_tree().process_frame; scroll.scroll_vertical = sc).call()
	else: scroll.scroll_vertical = 0

func _yield_names(y: Dictionary) -> String:
	var RN = {"buns": "壽包", "planks": "棺材板", "coins": "冥幣"}; var o = []
	for it in y: o.append(RN.get(it, it))
	return "、".join(o)

# ---------------- 補給線 ----------------
func _supply_card() -> void:
	var Gr = GR(); var g = Gr.st(); var v = _card()
	v.add_child(_lbl(T("補給線", "補給線"), 20, INK, "serif", 900))
	var fci = Gr.frontline(); var u = Gr.upkeep(fci)
	if fci < 0:
		v.add_child(_wl(T("六張地圖全部通關！車隊改送返落魄村。", "六張地圖全部通關！車隊改送回落魄村。"), 16)); _convoy_rows(v); return
	var h = _row(v)
	h.add_child(_lbl(T("前線：", "前線：") + str(Gr.map_def(fci).name), 17, INK, "sans", 700))
	var lvl = Gr.starve_level()
	var stt = _lbl(T("糧草充足", "糧草充足") if lvl == 0 else (T("斷糧 %d 晚・%s", "斷糧 %d 晚・%s") % [lvl, Gr.TA(Gr.D.STARVE[lvl - 1].name)]), 16, GREEN if lvl == 0 else RED, "sans", 900)
	stt.size_flags_horizontal = Control.SIZE_EXPAND_FILL; stt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; h.add_child(stt)
	if u == null:
		v.add_child(_wl(T("呢張係第一張圖，前線唔使食糧。打贏 Boss 開分村之後，下一張圖先開始要補給。", "這是第一張圖，前線不用吃糧。打贏 Boss 開分村之後，下一張圖才開始要補給。"), 15, DIM))
	else:
		_stock_row(v, "壽包", J.num(g.front.buns), Gr.front_cap(fci, "buns"), Color("#c98a3a"))
		_stock_row(v, "棺材板", J.num(g.front.planks), Gr.front_cap(fci, "planks"), Color("#8a6a4a"))
		v.add_child(_wl(T("每晚食：壽包 %s、棺材板 %s。斷糧只影響分村收入（第 1 晚 ×0.85、第 2 晚 ×0.5、第 3 晚起停），主線照打得。", "每晚吃：壽包 %s、棺材板 %s。斷糧只影響分村收入（第 1 晚 ×0.85、第 2 晚 ×0.5、第 3 晚起停），主線照樣能打。") % [fmt(u.buns), fmt(u.planks)], 15, DIM))
	_convoy_rows(v)
	if u != null:
		var hb = CheckButton.new(); hb.text = N(T("老家幫補（每班車最多攞落魄村四成存貨）", "老家幫補（每班車最多拿落魄村四成存貨）"))
		hb.button_pressed = J.t(g.get("home")); hb.add_theme_font_size_override("font_size", 15); hb.add_theme_color_override("font_color", INK); hb.add_theme_color_override("font_pressed_color", INK); hb.add_theme_color_override("font_hover_color", INK)
		hb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; hb.custom_minimum_size = Vector2(10, 40)
		hb.toggled.connect(func(on): g["home"] = on; Gr.save()); v.add_child(hb)
		var p = Gr.urgent_plan()
		if not p.ok:
			v.add_child(_wl(T("急件車：%s", "急件車：%s") % p.why, 15, DIM, 700))
		else:
			var ub = UIKit.btn(N(T("叫急件車（冥幣 %s）", "叫急件車（冥幣 %s）") % fmt(p.cost)), "gold", false)
			ub.custom_minimum_size = Vector2(0, 46); ub.add_theme_font_size_override("font_size", 16)
			ub.pressed.connect(func(): if Gr.urgent(): rebuild(true)); v.add_child(ub)
		if p.ok: v.add_child(_wl(T("即刻送：壽包 %s、棺材板 %s（每件 %s 冥幣，每晚限一次）", "立即送：壽包 %s、棺材板 %s（每件 %s 冥幣，每晚限一次）") % [fmt(p.buns), fmt(p.planks), str(Gr.D.URGENT.perItem)], 14, DIM))

func _convoy_rows(v: Control) -> void:
	var Gr = GR(); var g = Gr.st(); var done = J.num(g.done); var CE = float(Gr.D.CONVOY_EVERY)
	var cv = g.get("convoy"); var who = T("Pocong 速遞", "Pocong 速遞") if Gr.pocong() else T("冥通快遞", "冥通快遞")
	if cv is Dictionary:
		v.add_child(_wl(T("%s喺路上：壽包 %s、棺材板 %s（另有跟車返老家：壽包 %s、棺材板 %s）・第 %d 夜送到（仲有 %d 夜）", "%s在路上：壽包 %s、棺材板 %s（另有跟車回老家：壽包 %s、棺材板 %s）・第 %d 夜送到（還有 %d 夜）") % [who, fmt(cv.buns), fmt(cv.planks), fmt(cv.res.buns), fmt(cv.res.planks), int(cv.eta), int(cv.eta - done)], 15))
	else:
		var nx = (floor(done / CE) + 1.0) * CE
		v.add_child(_wl(T("下一班%s：第 %d 夜出車（仲有 %d 夜），出車後三晚送到", "下一班%s：第 %d 夜出車（還有 %d 夜），出車後三晚送到") % [who, int(nx), int(nx - done)], 15))
	var car = J.t(J.gp(Gr.S().get("seen"), str(Gr.D.CONVOY.carSeen)))
	v.add_child(_wl(T("車隊容量 %s（600 ＋ 陰兵 × %s%s）", "車隊容量 %s（600 ＋ 陰兵 × %s%s）") % [fmt(Gr.convoy_cap()), str(Gr.D.CONVOY.perTroop), T("，媽燒嘅紙紮跑車 ×2", "，媽燒的紙紮跑車 ×2") if car else ""], 15, DIM))

# ---------------- 存糧倉 ----------------
func _store_card() -> void:
	var Gr = GR(); var m = Gr.ms(ci); var v = _card(); var lv = Gr.lv_of(ci, "store")
	var h = _row(v); h.add_child(_lbl("存糧倉", 20, INK, "serif", 900)); h.add_child(_lbl("Lv %d" % int(lv), 18, RED, "sans", 900))
	var mn = Gr.mile_name(lv)
	if mn != "": h.add_child(_badge(mn))
	var cap = Gr.store_cap(ci)
	_stock_row(v, "壽包", J.num(m.stock.buns), cap, Color("#c98a3a"))
	_stock_row(v, "棺材板", J.num(m.stock.planks), cap, Color("#8a6a4a"))
	var y = Gr.yield_of(ci); var parts = []
	for it in y: parts.append("%s +%s" % [{"buns": "壽包", "planks": "棺材板", "coins": "冥幣"}[it], fmt(y[it])])
	v.add_child(_wl(T("駐守產量（每晚）：", "駐守產量（每晚）：") + ("，".join(parts) if parts.size() else T("未有鬼駐守", "還沒有鬼駐守")), 16, INK, 700))
	var gp = Gr.guard_pow(ci); var nd = Gr.guard_need(ci); var tr = Gr.theft_rate(ci)
	v.add_child(_wl(T("守夜防守 %s／要 %s：每晚俾孤魂偷 %s%%", "守夜防守 %s／需要 %s：每晚被孤魂偷 %s%%") % [fmt(gp), fmt(nd), str(snappedf(tr * 100.0, 0.1))], 15, GREEN if tr <= 0 else RED))
	_up_btn(v, "store")

func _badge(t: String) -> Control:
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color("#7a2a1e"), 6, Color("#f2c060"), 1, Vector4(8, 1, 8, 2)))
	var l = _lbl("「%s」" % t, 15, GOLD, "serif", 900); pc.add_child(l); pc.size_flags_vertical = Control.SIZE_SHRINK_CENTER; return pc

func _up_btn(v: Control, sid: String) -> void:
	var Gr = GR(); var lv = Gr.lv_of(ci, sid)
	var nm = Gr.next_mile(lv)
	if nm.size():
		var what = {"store": "容量", "guard": "防守"}.get(sid, "收入")
		v.add_child(_wl(T("下個招牌「%s」：差 %d 級（%s ×%s）", "下個招牌「%s」：差 %d 級（%s ×%s）") % [nm[2], int(float(nm[0]) - lv), what, str(nm[1])], 14, DIM))
	if lv >= float(Gr.D.MAX_LV):
		var b0 = UIKit.btn(N(T("已經最高級", "已經最高級")), "", false); b0.disabled = true; b0.custom_minimum_size = Vector2(0, 44); v.add_child(b0); return
	var c = Gr.up_cost(ci, sid)
	var b = UIKit.btn(N(T("升級（落魄村棺材板 %s、冥幣 %s）", "升級（落魄村棺材板 %s、冥幣 %s）") % [fmt(c.planks), fmt(c.coins)]), "gold" if Gr.can_up(ci, sid) else "", false)
	b.disabled = not Gr.can_up(ci, sid); b.custom_minimum_size = Vector2(0, 44); b.add_theme_font_size_override("font_size", 15)
	b.pressed.connect(func(): if Gr.upgrade(ci, sid): rebuild(true)); v.add_child(b)

# ---------------- 檔口 ----------------
func _stall_card(sid: String) -> void:
	var Gr = GR(); var sd = Gr.stall_def(sid); var lv = Gr.lv_of(ci, sid); var v = _card()
	var h = _row(v); h.add_child(_lbl(str(sd.name), 20, INK, "serif", 900)); h.add_child(_lbl("Lv %d" % int(lv), 18, RED, "sans", 900))
	var mn = Gr.mile_name(lv)
	if mn != "": h.add_child(_badge(mn))
	v.add_child(_wl(Gr.TA(sd.desc), 15, DIM))
	if sid == "guard":
		v.add_child(_wl(T("防守力 %s（要 %s 先完全擋得住）", "防守力 %s（要 %s 才完全擋得住）") % [fmt(Gr.guard_pow(ci)), fmt(Gr.guard_need(ci))], 16, INK, 700))
	else:
		var inc = Gr.income(ci, sid); var raw = Gr.income(ci, sid, false)
		var t = T("每晚冥幣 +%s", "每晚冥幣 +%s") % fmt(inc)
		if inc < raw - 0.5: t += T("（斷糧，本來 +%s）", "（斷糧，原本 +%s）") % fmt(raw)
		v.add_child(_wl(t, 17, INK, 700))
	var sr = HBoxContainer.new(); sr.add_theme_constant_override("separation", 6); sr.alignment = BoxContainer.ALIGNMENT_CENTER; v.add_child(sr)
	var p = Gr.ms(ci).posts[sid]; var nh = Gr.helpers(lv)
	for i in 4: sr.add_child(_slot(sid, i, p[i], i > nh))
	_up_btn(v, sid)

func _slot(sid: String, i: int, gid, locked: bool) -> Control:
	var Gr = GR()
	var b = Button.new(); b.custom_minimum_size = Vector2(76, 124); b.focus_mode = Control.FOCUS_NONE
	var col = Color(1, 0.97, 0.88, 0.75) if not locked else Color(0.4, 0.35, 0.3, 0.35)
	for st in ["normal", "hover", "pressed", "disabled"]:
		b.add_theme_stylebox_override(st, UIKit.sb(col.darkened(0.08) if st == "pressed" else col, 8, Color(RED, 0.8) if i == 0 else LINE, 2 if i == 0 else 1))
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_left = 3; vb.offset_right = -3; vb.offset_top = 3; vb.offset_bottom = -3
	vb.add_theme_constant_override("separation", 1); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(vb)
	var role = _lbl(T("管事", "管事") if i == 0 else T("幫工", "幫工"), 14, RED if i == 0 else DIM, "sans", 900); role.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(role)
	var gh = Gr.ghost(gid) if gid != null else null
	if locked:
		var need = 0
		for hh in Gr.D.HELP: if int(hh[1]) == i: need = int(hh[0])
		var l = _lbl(T("檔口\nLv%d 開", "檔口\nLv%d 開") % need, 15, DIM, "sans", 700); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.size_flags_vertical = Control.SIZE_EXPAND_FILL; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; vb.add_child(l)
		b.disabled = true
	elif gh == null:
		var l2 = _lbl("＋", 34, Color(INK, 0.55), "sans", 900); l2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l2.size_flags_vertical = Control.SIZE_EXPAND_FILL; l2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; vb.add_child(l2)
		var l3 = _lbl(T("派鬼", "派鬼"), 14, DIM); l3.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(l3)
	else:
		var pr = UIKit.portrait(J.str(J.gp(gh, "k")), 56); pr.custom_minimum_size = Vector2(56, 56); pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(pr)
		var nm = _lbl(J.str(J.gp(gh, "name")), 14, INK, "sans", 700); nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nm.clip_text = true; nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; nm.custom_minimum_size = Vector2(68, 0); vb.add_child(nm)
		var hm = Gr.home_mul(gh, ci)
		var l4 = _lbl(("老家×%s" % str(hm)) if hm > 1.0 else "Lv%d" % int(Gr.glv(gh)), 13, GREEN if hm > 1.0 else DIM, "sans", 700); l4.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(l4)
	if not locked: b.pressed.connect(func(): _open_picker(sid, i))
	return b

# ---------------- 揀人 ----------------
func _open_picker(sid: String, i: int) -> void:
	var Gr = GR(); var sd = Gr.stall_def(sid)
	if picker != null and is_instance_valid(picker): picker.queue_free()
	picker = Control.new(); picker.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); picker.mouse_filter = Control.MOUSE_FILTER_STOP; add_child(picker)
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.55); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); picker.add_child(dim)
	dim.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: _close_picker())
	var pn = PanelContainer.new(); pn.anchor_right = 1; pn.anchor_bottom = 1; pn.anchor_top = 0.22
	var s = UIKit.sb(Color("#ecd9a4"), 12, LINE, 1, Vector4(12, 12, 12, 10)); s.corner_radius_bottom_left = 0; s.corner_radius_bottom_right = 0
	pn.add_theme_stylebox_override("panel", s); picker.add_child(pn)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 8); pn.add_child(v)
	var SN = ["力", "智", "武"]
	var h = _row(v)
	var tl = _wl(T("派鬼：%s・%s（睇%s）", "派鬼：%s・%s（看%s）") % [sd.name, T("管事", "管事") if i == 0 else T("幫工", "幫工"), SN[int(sd.stat)]], 20, INK, 900); h.add_child(tl)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(44, 44); cb.pressed.connect(_close_picker); h.add_child(cb)
	if i == 0: v.add_child(_wl(T("管事要有名有姓嘅鬼（雜鬼做唔到）。", "管事要有名有姓的鬼（雜鬼做不到）。"), 14, DIM))
	var cur = Gr.ms(ci).posts[sid][i]
	if cur != null:
		var rb = UIKit.btn(N(T("撤走 %s", "撤走 %s") % J.str(J.gp(Gr.ghost(cur), "name"))), "", false); rb.custom_minimum_size = Vector2(0, 44)
		rb.pressed.connect(func(): Gr.assign(ci, sid, i, null); Gr.save(); _close_picker(); rebuild(true)); v.add_child(rb)
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; v.add_child(sc)
	var lst = VBoxContainer.new(); lst.size_flags_horizontal = Control.SIZE_EXPAND_FILL; lst.add_theme_constant_override("separation", 6); sc.add_child(lst)
	var L = Gr.pick_list(ci, sid, i)
	if L.is_empty(): lst.add_child(_wl(T("冇鬼可以派。去招魂台招多啲雜鬼，或者收編巡陰遇到嘅鬼。", "沒有鬼可以派。去招魂台多招些雜鬼，或者收編巡陰遇到的鬼。"), 16, DIM))
	var PL = J.G.get("postLabel")
	for gh in L:
		if J.seq(J.gp(gh, "id"), cur): continue
		var row = Button.new(); row.custom_minimum_size = Vector2(0, 70); row.focus_mode = Control.FOCUS_NONE
		for stn in ["normal", "hover", "pressed"]: row.add_theme_stylebox_override(stn, UIKit.sb(Color(1, 0.97, 0.88, 0.8 if stn != "pressed" else 0.6), 8, LINE, 1))
		var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 8; hb.offset_right = -10; hb.add_theme_constant_override("separation", 10); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; row.add_child(hb)
		var pr = UIKit.portrait(J.str(J.gp(gh, "k")), 54); pr.size_flags_vertical = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(vb)
		var nm = _lbl("%s　Lv%d" % [J.str(J.gp(gh, "name")), int(Gr.glv(gh))], 17, INK, "sans", 900); nm.clip_text = true; nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; vb.add_child(nm)
		var p = J.gp(gh, "post"); var where = T("閒住", "閒著")
		if J.t(p): where = (T("分村駐守中（會調過嚟）", "分村駐守中（會調過來）") if J.seq(p, "garrison") else J.str(J.cl(PL, null, [p])) + T("（會調走）", "（會調走）")) if PL != null else T("做緊嘢（會調走）", "工作中（會調走）")
		var hm = Gr.home_mul(gh, ci)
		var info = _lbl("%s %d%s・%s" % [SN[int(sd.stat)], int(Gr.stat(gh, int(sd.stat))), ("・老家×%s" % str(hm)) if hm > 1.0 else "", where], 14, GREEN if hm > 1.0 else DIM); info.clip_text = true; info.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; vb.add_child(info)
		row.pressed.connect(func():
			if Gr.assign(ci, sid, i, J.gp(gh, "id")): Gr.save()
			_close_picker(); rebuild(true))
		lst.add_child(row)

func _close_picker() -> void:
	if picker != null and is_instance_valid(picker): picker.queue_free()
	picker = null

# ---------------- 記錄 ----------------
func _log_card() -> void:
	var g = GR().st(); var lg = g.log
	if lg.is_empty(): return
	var v = _card(); v.add_child(_lbl(T("分村日誌", "分村日誌"), 18, INK, "serif", 900))
	for e in lg.slice(0, 5): v.add_child(_wl(T("第 %d 夜：", "第 %d 夜：") % int(J.num(e.n)) + str(e.h), 14, DIM))
