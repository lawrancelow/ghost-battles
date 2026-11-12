# 主畫面（移植 shell.html ＋ game.js UI）：頂欄、村子、任務條、底部導航、面板、劇情、提示、標題畫面
extends Control

var village: Control
var dom: Control
var quest_bar: PanelContainer
var quest_lbl: RichTextLabel
var quest_prog: Label
var lv_lbl: Label
var exp_fill: ColorRect
var exp_bar: ColorRect
var exp_txt: Label
var res_lbl = {}
var res_cell = {}
var nav_btns = {}
var chest_badge: Label
var sheet: Panel
var sheet_title: Label
var sheet_body: VBoxContainer
var sheet_scroll: ScrollContainer
var sheet_refresh = Callable()
var story: Control
var toasts: VBoxContainer
var banner: PanelContainer
var banner_lbl: Label
var praise_box: PanelContainer
var praise_lbl: Label
var title_ov: Control
var tab = "village"
var ui_t = 0.0
var save_t = 0.0
var last_praise = {}

const TOP_H := 102.0
const NAV_H := 58.0

func _ready() -> void:
	print("[boot] main ready")
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg = ColorRect.new(); bg.color = UIKit.INK; bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
	_build_village(); _build_top(); _build_nav(); _build_sheet()
	story = Control.new(); story.set_script(load("res://ui/story.gd")); add_child(story)
	_build_fx()
	move_child(praise_box, sheet.get_index())   # 系統誇獎喺村子層，面板蓋住佢（同網頁版 z-index 一樣）
	G.modal_open = func() -> bool: return J.t(J.mc(J.G.get("UI"), "modalOpen", []))
	G.refreshed.connect(refresh); G.toast.connect(show_toast); G.banner.connect(show_banner); G.praise.connect(show_praise)
	get_tree().auto_accept_quit = false
	# ---- 轉譯版 JS 遊戲：逐個模塊載入（每幀一個），顯示進度 ----
	_boot_js()

var loading: Control
func _boot_js() -> void:
	loading = ColorRect.new(); loading.color = Color("#0d0b10"); loading.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(loading)
	var cov = TextureRect.new(); cov.texture = Spr.get_tex("cover"); cov.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cov.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	cov.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); cov.modulate = Color(0.55, 0.55, 0.55); loading.add_child(cov)
	var lb = UIKit.label("陰間連線中…", 16, Color("#f3e6c8"), "serif", 900); lb.anchor_left = 0; lb.anchor_right = 1; lb.anchor_top = 0.82; lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; loading.add_child(lb)
	var bar_bg = ColorRect.new(); bar_bg.color = Color("#3a2e26"); bar_bg.anchor_left = 0.15; bar_bg.anchor_right = 0.85; bar_bg.anchor_top = 0.87; bar_bg.anchor_bottom = 0.87; bar_bg.offset_bottom = 6; loading.add_child(bar_bg)
	var bar = ColorRect.new(); bar.color = Color("#c2362b"); bar.size = Vector2(0, 6); bar_bg.add_child(bar)
	await get_tree().process_frame
	var t0 = Time.get_ticks_msec()
	JSBridge.install_natives(JSRun)
	JSRun.boot_dom("res://web/shell.html")
	dom = Control.new(); dom.set_script(load("res://ui/dom_view.gd")); add_child(dom); move_child(dom, sheet.get_index())
	var names = FileAccess.get_file_as_string("res://jsgen/modules.txt").split("\n", false)
	for i in names.size():
		JSRun.load_modules([names[i]])
		bar.size.x = bar_bg.size.x * float(i + 1) / names.size()
		await get_tree().process_frame
	print("[boot] modules ", Time.get_ticks_msec() - t0, "ms")
	JSBridge.connect_ui(self)
	village.bind(JSRun.by_id("village"))
	J.cl(J.G.get("startGame"), null, [])
	G.S = J.G["S"]; G.js_mode = true
	J.mc(J.G.get("Village"), "resize", [])
	refresh()
	loading.queue_free(); loading = null
	Snd.warm()
	print("[boot] ready ", Time.get_ticks_msec() - t0, "ms")

func _process_js_state() -> void:
	if J.G.get("S") is Dictionary and not is_same(J.G["S"], G.S): G.S = J.G["S"]

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		G.save()
		if what == NOTIFICATION_WM_CLOSE_REQUEST: get_tree().quit()
	if what == NOTIFICATION_APPLICATION_RESUMED and not G.S.is_empty() and title_ov == null: G.offline_gain()

func _process(dt: float) -> void:
	if loading != null: return
	_process_js_state()
	ui_t += dt
	if ui_t > 0.5 and title_ov == null: ui_t = 0; refresh()

# ---------------- 版面 ----------------
func _build_village() -> void:
	village = Control.new(); village.set_script(load("res://ui/js_canvas_view.gd"))
	village.anchor_right = 1; village.anchor_bottom = 1; village.offset_top = TOP_H; village.offset_bottom = -NAV_H
	add_child(village)
	quest_bar = PanelContainer.new()
	var s = UIKit.sb(UIKit.PAPER, 2, UIKit.PAPERLINE, 1, Vector4(7, 7, 12, 7)); s.shadow_color = Color(0, 0, 0, 0.35); s.shadow_size = 0; s.shadow_offset = Vector2(0, 3)
	quest_bar.add_theme_stylebox_override("panel", s)
	quest_bar.anchor_right = 1; quest_bar.offset_left = 8; quest_bar.offset_right = -8; quest_bar.offset_top = TOP_H + 8
	add_child(quest_bar)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9); quest_bar.add_child(hb)
	var tagp = PanelContainer.new(); tagp.add_theme_stylebox_override("panel", UIKit.sb(UIKit.CINNABAR, 2, Color(0, 0, 0, 0), 0, Vector4(7, 3, 7, 3)))
	tagp.add_child(UIKit.label("主線", 13, Color("#fbe6d6"), "serif", 900)); hb.add_child(tagp)
	quest_lbl = UIKit.rich("", 15, UIKit.INKTXT); quest_lbl.add_theme_font_override("normal_font", UIKit.font("sans", 700)); quest_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; quest_lbl.autowrap_mode = TextServer.AUTOWRAP_OFF
	quest_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE; quest_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(quest_lbl)
	quest_prog = UIKit.label("", 15, UIKit.CINNABAR2, "sans", 900); quest_prog.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(quest_prog)
	quest_bar.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			var q = G.quest_cur()
			if q and q.go == "roster": open_roster(); return
			var p = J.mc(J.G.get("Village"), "questTarget", [])
			if p: close_sheet(); J.mc(J.G.get("Village"), "focus", [p[0], p[1]]))

func _build_top() -> void:
	var top = Panel.new(); top.anchor_right = 1; top.offset_bottom = TOP_H
	var st = StyleBoxFlat.new(); st.bg_color = Color("#1a1520"); st.border_color = Color("#3a2f2a"); st.border_width_bottom = 1; st.shadow_color = Color(0, 0, 0, 0.45); st.shadow_size = 8
	top.add_theme_stylebox_override("panel", st); add_child(top)
	# 主公印
	var seal = Panel.new(); seal.position = Vector2(9, 22); seal.size = Vector2(58, 58); seal.rotation = deg_to_rad(-3); seal.pivot_offset = Vector2(29, 29)
	var ss = UIKit.sb(UIKit.CINNABAR, 6, Color("#f0c8b4"), 2); ss.shadow_color = Color("#5a120c"); ss.shadow_size = 0; ss.shadow_offset = Vector2(0, 2)
	seal.add_theme_stylebox_override("panel", ss); top.add_child(seal)
	var sm = UIKit.label("主公", 11, Color("#fbe6d6"), "serif", 700); sm.position = Vector2(0, 5); sm.size = Vector2(58, 14); sm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; seal.add_child(sm)
	lv_lbl = UIKit.label("1", 26, Color("#fbe6d6"), "serif", 900); lv_lbl.position = Vector2(0, 17); lv_lbl.size = Vector2(58, 34); lv_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; seal.add_child(lv_lbl)
	# 好評條
	exp_bar = ColorRect.new(); exp_bar.color = Color("#3a2e26"); exp_bar.position = Vector2(76, 16); exp_bar.size = Vector2(200, 6); top.add_child(exp_bar)
	exp_fill = ColorRect.new(); exp_fill.color = Color("#b06a34"); exp_fill.size = Vector2(0, 6); exp_bar.add_child(exp_fill)
	exp_txt = UIKit.label("", 12, UIKit.DIM); exp_txt.anchor_left = 1; exp_txt.anchor_right = 1; exp_txt.offset_left = -150; exp_txt.offset_right = -42; exp_txt.offset_top = 10
	exp_txt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; top.add_child(exp_txt)
	# 資源格
	var grid = GridContainer.new(); grid.columns = 3; grid.add_theme_constant_override("h_separation", 4); grid.add_theme_constant_override("v_separation", 4)
	grid.anchor_right = 1; grid.offset_left = 76; grid.offset_top = 36; grid.offset_right = -9; grid.add_theme_constant_override("v_separation", 5); top.add_child(grid)
	var snd = UIKit.btn("聲", "", true); snd.anchor_left = 1; snd.anchor_right = 1; snd.offset_left = -35; snd.offset_right = -9; snd.offset_top = 6; snd.offset_bottom = 30; snd.add_theme_font_size_override("font_size", 12)
	snd.text = "聲" if Snd.is_on() else "靜"
	snd.pressed.connect(func(): snd.text = "聲" if Snd.toggle() else "靜"); top.add_child(snd)
	var help = {"wood": "槐木：主公親手砍樹，或派鬼怪去[b]伐木場[/b]伐木。", "rice": "糯米：主公親手收割，或派鬼怪去[b]糯米田[/b]割稻。", "planks": "棺材板：在[b]棺材鋪[/b]把 2 槐木做成 1 板（力量高的鬼做得快）。藍箱也會開出。用來建造和升級建築。", "buns": "壽包：在[b]包子鋪[/b]把 2 糯米包成 1 個（智力高的鬼包得快）。綠箱也會開出。用來升級鬼怪、練陰兵。", "coins": "冥幣：打關卡、開紫箱、燒[b]化寶爐[/b]。Toyol 管倉庫時也會「撿到」冥幣。", "troops": "陰兵：村裡的遊魂見你有地盤，自願加入。[b]民宅[/b]越高級來得越快、上限越高。"}
	for k in ["wood", "rice", "planks", "buns", "coins", "troops"]:
		var cell = PanelContainer.new(); cell.custom_minimum_size = Vector2(0, 26); cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cs = StyleBoxFlat.new(); cs.bg_color = Color("#1f3c36"); cs.border_color = Color("#4f8076"); cs.set_border_width_all(1); cs.set_corner_radius_all(3)
		cs.content_margin_left = 3; cs.content_margin_right = 6
		cell.add_theme_stylebox_override("panel", cs)
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 4); cell.add_child(hb)
		var ic = TextureRect.new(); ic.texture = load("res://assets/ui/i-%s.svg" % k); ic.custom_minimum_size = Vector2(18, 18); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hb.add_child(ic)
		var v = UIKit.label("0", 15, Color("#f4ecd4"), "sans", 700); v.size_flags_horizontal = Control.SIZE_EXPAND_FILL; v.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hb.add_child(v); res_lbl[k] = v; res_cell[k] = cs
		var key: String = k
		cell.gui_input.connect(func(e):
			if e is InputEventMouseButton and e.pressed: show_toast(help[key] + ("\n（建好民宅，遊魂才會來）" if key == "troops" and float(G.S.bld.home) == 0 else "")))
		grid.add_child(cell)
	top.resized.connect(func(): exp_bar.size.x = top.size.x - 76 - 116)

func _build_nav() -> void:
	var nav = Panel.new(); nav.anchor_top = 1; nav.anchor_bottom = 1; nav.anchor_right = 1; nav.offset_top = -NAV_H
	var ns = StyleBoxFlat.new(); ns.bg_color = Color("#22150f"); ns.border_color = Color("#5a2e22"); ns.border_width_top = 2
	nav.add_theme_stylebox_override("panel", ns); add_child(nav)
	var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.add_theme_constant_override("separation", 0); nav.add_child(hb)
	for it in [["village", "村子"], ["roster", "鬼怪"], ["battle", "地盤"], ["chest", "箱子"], ["story", "劇情"]]:
		var b = Button.new(); b.flat = true; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.focus_mode = Control.FOCUS_NONE
		var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_theme_constant_override("separation", 1); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ic = TextureRect.new(); ic.custom_minimum_size = Vector2(26, 26); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var lb = UIKit.label(it[1], 12, Color("#b8a08e"), "sans", 700); lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vb.add_child(ic); vb.add_child(lb); b.add_child(vb); hb.add_child(b)
		nav_btns[it[0]] = [b, ic, lb]
		var id: String = it[0]
		b.pressed.connect(func(): _nav(id))
		if id == "chest":
			chest_badge = UIKit.label("", 11, Color.WHITE, "sans", 900)
			var bs = UIKit.sb(UIKit.CINNABAR, 8, Color(0, 0, 0, 0), 0, Vector4(5, 0, 5, 0)); chest_badge.add_theme_stylebox_override("normal", bs)
			chest_badge.anchor_left = 0.5; chest_badge.anchor_right = 0.5; chest_badge.offset_left = 8; chest_badge.offset_top = 4; b.add_child(chest_badge)
	_nav_on("village")

func _nav_on(t: String) -> void:
	tab = t
	for k in nav_btns:
		var on: bool = k == t
		nav_btns[k][1].texture = load("res://assets/ui/n-%s%s.svg" % [k, "_on" if on else ("_main" if k == "battle" else "")])
		nav_btns[k][2].add_theme_color_override("font_color", UIKit.GOLD2 if on else (Color("#f0c8a0") if k == "battle" else Color("#b8a08e")))
	var jui = J.G.get("UI")
	if jui is Dictionary: jui["tab"] = t

func _nav(t: String) -> void:
	var ui = J.G.get("UI")
	if t == "battle": J.mc(J.G.get("UI"), "close", []); J.mc(J.G.get("World"), "open", []); return
	J.mc(ui, "open", [t])

func _build_sheet() -> void:
	sheet = Panel.new(); sheet.anchor_right = 1; sheet.anchor_top = 0.16; sheet.anchor_bottom = 1; sheet.visible = false
	var s = UIKit.sb(UIKit.PAPER); s.shadow_color = Color(0, 0, 0, 0.65); s.shadow_size = 24
	sheet.add_theme_stylebox_override("panel", s); add_child(sheet)
	var head = HBoxContainer.new(); head.anchor_right = 1; head.offset_left = 16; head.offset_right = -12; head.offset_top = 10; head.offset_bottom = 50
	sheet.add_child(head)
	sheet_title = UIKit.label("", 22, UIKit.INKTXT, "serif", 900); sheet_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL; head.add_child(sheet_title)
	var cl = UIKit.btn("✕", "ghost", true); cl.custom_minimum_size = Vector2(34, 34); cl.pressed.connect(func(): close_sheet(); _nav_on("village")); head.add_child(cl)
	var line = ColorRect.new(); line.color = UIKit.PAPERLINE; line.anchor_right = 1; line.offset_top = 54; line.offset_bottom = 55.5; sheet.add_child(line)
	sheet_scroll = ScrollContainer.new(); sheet_scroll.anchor_right = 1; sheet_scroll.anchor_bottom = 1; sheet_scroll.offset_top = 58; sheet_scroll.offset_left = 14; sheet_scroll.offset_right = -14; sheet_scroll.offset_bottom = -10
	sheet_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sheet.add_child(sheet_scroll)
	sheet_body = VBoxContainer.new(); sheet_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sheet_body.add_theme_constant_override("separation", 6)
	sheet_scroll.add_child(sheet_body)

func _build_fx() -> void:
	praise_box = PanelContainer.new(); praise_box.add_theme_stylebox_override("panel", UIKit.sb(Color(0.055, 0.125, 0.118, 0.92), 4, Color("#5fbfaa"), 1, Vector4(10, 6, 10, 6)))
	praise_box.anchor_right = 1; praise_box.offset_left = 14; praise_box.offset_right = -14; praise_box.offset_top = TOP_H + 56; praise_box.modulate.a = 0; praise_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	praise_lbl = UIKit.label("", 15, Color("#d4fff2")); praise_lbl.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; praise_box.add_child(praise_lbl); add_child(praise_box)
	toasts = VBoxContainer.new(); toasts.anchor_top = 1; toasts.anchor_bottom = 1; toasts.anchor_right = 1; toasts.offset_left = 12; toasts.offset_right = -12; toasts.offset_bottom = -86; toasts.grow_vertical = Control.GROW_DIRECTION_BEGIN
	toasts.alignment = BoxContainer.ALIGNMENT_END; toasts.add_theme_constant_override("separation", 6); toasts.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(toasts)
	banner = PanelContainer.new(); banner.add_theme_stylebox_override("panel", UIKit.sb(UIKit.CINNABAR, 3, Color("#f0c8b4"), 2, Vector4(30, 12, 30, 12)))
	banner.anchor_left = 0.5; banner.anchor_right = 0.5; banner.anchor_top = 0.32; banner.anchor_bottom = 0.32; banner.grow_horizontal = Control.GROW_DIRECTION_BOTH; banner.grow_vertical = Control.GROW_DIRECTION_BOTH
	banner.modulate.a = 0; banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner_lbl = UIKit.label("", 22, Color("#fff3e0"), "serif", 900); banner.add_child(banner_lbl); add_child(banner)

# ---------------- 刷新 ----------------
func refresh() -> void:
	if G.S.is_empty(): return
	var S = G.S
	lv_lbl.text = str(int(S.lv))
	var need = G.expNeed(S.lv)
	exp_fill.size.x = exp_bar.size.x * (1.0 if S.lv >= 20 else minf(1, float(S.exp) / need))
	exp_txt.text = "好評 MAX" if S.lv >= 20 else "好評 %s/%s" % [G.fmt(S.exp), G.fmt(need)]
	var cap = G.cap()
	for k in ["wood", "rice", "planks", "buns"]:
		res_lbl[k].text = G.fmt(S.res[k])
		res_lbl[k].add_theme_color_override("font_color", Color("#ffb46a") if float(S.res[k]) >= cap - 0.5 else Color("#f4ecd4"))
	res_lbl.coins.text = G.fmt(S.res.coins); res_lbl.troops.text = G.fmt(S.res.troops)
	var q = G.quest_cur()
	if q:
		var p = G.quest_progress(q)
		var a = minf(float(p[0]), float(p[1]))
		quest_lbl.text = q.text; quest_prog.text = "%d/%d" % [int(a), int(p[1])]
		quest_prog.add_theme_color_override("font_color", Color("#2e6d3a") if float(p[0]) >= float(p[1]) else UIKit.CINNABAR2)
	else: quest_lbl.text = "第一季完。村子由你慢慢經營。" if S.ended else "—"; quest_prog.text = ""
	var ch = int(S.chests.g) + int(S.chests.b) + int(S.chests.p)
	chest_badge.text = str(ch) if ch else ""; chest_badge.visible = ch > 0
	if sheet.visible and sheet_refresh.is_valid(): sheet_refresh.call()

# ---------------- 提示 ----------------
func show_toast(bb: String) -> void:
	while toasts.get_child_count() >= 3: toasts.get_child(0).free()
	var p = PanelContainer.new()
	var s = StyleBoxFlat.new(); s.bg_color = Color("#241b17"); s.border_color = UIKit.CINNABAR; s.border_width_left = 5; s.set_corner_radius_all(2)
	s.content_margin_left = 12; s.content_margin_right = 12; s.content_margin_top = 9; s.content_margin_bottom = 9; s.shadow_color = Color(0, 0, 0, 0.5); s.shadow_size = 8
	p.add_theme_stylebox_override("panel", s); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var r = UIKit.rich(bb, 14, Color("#f0e2c8")); r.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(r)
	toasts.add_child(p)
	var tw = create_tween(); tw.tween_interval(2.6); tw.tween_property(p, "modulate:a", 0.0, 0.6); tw.tween_callback(p.queue_free)

func show_banner(text: String) -> void:
	banner_lbl.text = text
	banner.modulate.a = 0; banner.scale = Vector2(0.85, 0.85)
	await get_tree().process_frame
	banner.pivot_offset = banner.size / 2
	var tw = create_tween(); tw.tween_property(banner, "modulate:a", 1.0, 0.18); tw.parallel().tween_property(banner, "scale", Vector2.ONE, 0.18)
	tw.tween_interval(1.4); tw.tween_property(banner, "modulate:a", 0.0, 0.4)

func show_praise(kind: String) -> void:
	var D = DB.D
	var pool: Array = D.PRAISE_KIND if G.S.ended else (D.PRAISE_CHOP if kind == "chop" else (D.PRAISE_RICE if kind == "rice" else D.PRAISE_CRAFT))
	var i = randi() % pool.size()
	while pool.size() > 1 and i == last_praise.get(kind, -1): i = randi() % pool.size()
	last_praise[kind] = i
	praise_lbl.text = "【KPI】" + DB.L(pool[i])
	praise_box.modulate.a = 0
	var tw = create_tween(); tw.tween_property(praise_box, "modulate:a", 1.0, 0.2); tw.tween_interval(2.2); tw.tween_property(praise_box, "modulate:a", 0.0, 0.4)
	if G.S.lv >= 3 and randf() < 0.04: G.S.chests.g = int(G.S.chests.g) + 1; show_toast("系統太滿意了，掉落一個[b]綠箱[/b]！")

# ---------------- 面板 ----------------
func open_sheet(title: String, refresher := Callable()) -> void:
	sheet.visible = true; sheet_title.text = title; sheet_refresh = refresher
	for c in sheet_body.get_children(): c.queue_free()

func close_sheet() -> void:
	sheet.visible = false; sheet_refresh = Callable()

func _clear_body() -> void:
	for c in sheet_body.get_children(): sheet_body.remove_child(c); c.queue_free()

func _p(bb: String, size := 14, col := UIKit.INKDIM, kind := "sans") -> RichTextLabel:
	var r = UIKit.rich(bb, size, col, kind); sheet_body.add_child(r); return r

func _row(text_bb: String, buttons: Array) -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
	var r = UIKit.rich(text_bb, 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
	var bx = HBoxContainer.new(); bx.add_theme_constant_override("separation", 4)
	for b in buttons: bx.add_child(b)
	hb.add_child(bx); sheet_body.add_child(hb); sheet_body.add_child(UIKit.hsep())
	return hb

func _act(b: Button, f: Callable, enabled := true) -> Button:
	b.disabled = not enabled; b.pressed.connect(f); return b

# --- 建築 ---
func open_building(id: String) -> void:
	var render = func() -> void: _render_building(id)
	open_sheet(DB.D.BUILDINGS[id].name, func(): pass)
	_render_building(id)

func _render_building(id: String) -> void:
	_clear_body()
	var S = G.S; var D = DB.D; var b: Dictionary = D.BUILDINGS[id]; var lv = int(S.bld.get(id, 0))
	_p(str(D.FLAVOR.get(id, "")), 14.5, UIKit.INKTXT, "serif"); sheet_body.add_child(UIKit.hsep())
	_p(b.desc, 14)
	var re = func(): G.save(); refresh(); _render_building(id)
	if lv == 0:
		if not G.bldUnlocked(id): _p("[color=#c2362b]尚未解鎖。[/color]")
		else: _row("建造費用：" + G.costText(b.build), [_act(UIKit.btn("建造", "gold"), func():
			G.pay(b.build); S.bld[id] = 1; G.gainExp(15); show_banner("%s 建好了！" % b.name); G.quest_check(); re.call(), G.canPay(b.build))])
		return
	_p("等級 [b]Lv %d[/b]%s" % [lv, "" if id == "house" else "（上限 = 鬼宅等級 %d）" % int(S.bld.house)], 15, UIKit.INKTXT)
	var eff = _bld_effect(id)
	if eff != "": _p(eff, 13.5, Color("#2e5d55"))
	if lv < G.bldMax(id):
		var c = G.upCost(id, lv); var bd = G.builderDiscount()
		_row("升級：" + G.costText(c) + ("\n[font_size=12]工頭省了 %d%% 棺材板[/font_size]" % int(round(bd * 100)) if bd else ""), [_act(UIKit.btn("升級", "gold"), func():
			var c2 = G.upCost(id, int(S.bld[id])); G.pay(c2); S.bld[id] = int(S.bld[id]) + 1; G.gainExp(10 + 8 * int(S.bld[id])); show_banner("%s 升到 Lv %d" % [b.name, int(S.bld[id])]); G.quest_check(); re.call(), G.canPay(c))])
	else: _p("已達最高等級。" if id == "house" else "已達上限，先升級鬼宅。")
	if id == "plank" or id == "bun":
		var src = "wood" if id == "plank" else "rice"; var can = int(floor(float(S.res[src]) / 4))
		var bs = []
		for n in [1, 5, 10]:
			var nn: int = n
			bs.append(_act(UIKit.btn("做%d份" % n if n == 1 else "一次做%d份" % n, "", true), func(): close_sheet(); _nav_on("village"); J.mc(J.G.get("Village"), "craft", [id, nn]), can >= 1))
		_row("親手做：每份 4 %s　好評 +1\n[font_size=12]現有%s %d，夠做 %d 份[/font_size]" % ["槐木 → 2 棺材板" if id == "plank" else "糯米 → 2 壽包", D.RES_NAMES[src], int(S.res[src]), can], bs)
	if id == "furnace":
		var left = maxf(0, G.furnaceCD - (G.now_ms() - float(S.furnaceAt)) * G.TIME_SCALE / 1000)
		_row(("還要 %d 分鐘" % int(ceil(left / 60)) if left > 0 else "爐火正旺！") + "　可燒出 冥幣 %d" % G.furnaceCoins(), [_act(UIKit.btn("燒", "gold"), func():
			if not G.furnaceReady(): return
			S.furnaceAt = G.now_ms(); var c3 = G.furnaceCoins(); S.res.coins = float(S.res.coins) + c3; show_toast("化寶爐燒出 [b]冥幣 %d[/b]" % c3); re.call(), left <= 0)])
	if id == "altar":
		var rc = G.recruitCost()
		_row("招魂一次：%s\n[font_size=12]雜鬼名額 %d/%d（升級民宅增加；收服的名鬼不佔名額）[/font_size]" % [G.costText(rc), G.fodderCount(), G.rosterCap()], [_act(UIKit.btn("招魂", "gold"), func():
			G.pay(rc); var g = G.recruitFodder(false); S.cnt.recruit = int(S.cnt.recruit) + 1; show_toast("招來了 [b]%s[/b]（%s）" % [g.name, g.q]); G.quest_check(); re.call(), G.canPay(rc) and G.fodderCount() < G.rosterCap())])
	if id == "house" and S.lv >= 12:
		var iq = 0
		for g in S.ghosts: iq += G.stat(g, 1)
		var left2 = maxf(0, G.feastCD - (G.now_ms() - float(S.feastAt)) * G.TIME_SCALE / 1000)
		_row("盂蘭宴：壽包 300\n[font_size=12]全村智力總和 %d/%d%s[/font_size]" % [iq, G.feastNeed, ("　冷卻 %d 分" % int(ceil(left2 / 60))) if left2 > 0 else ""], [_act(UIKit.btn("擺宴", "gold"), func():
			S.res.buns = float(S.res.buns) - 300; S.feastAt = G.now_ms(); S.cnt.feast = int(S.cnt.feast) + 1; G.gainExp(150)
			if G.fodderCount() < G.rosterCap(): var g2 = G.recruitFodder(true); show_toast("盂蘭宴請來了稀客 [b]%s[/b]（紫）！好評 +150" % g2.name)
			else: S.chests.p = int(S.chests.p) + 1; show_toast("盂蘭宴賓客滿座，可惜村裡住不下了。客人留下一個[b]紫箱[/b]就走了。好評 +150")
			G.quest_check(); re.call(), float(S.res.buns) >= 300 and iq >= G.feastNeed and left2 <= 0)])
	for post in b.posts: _post_ui(post, id)

func _bld_effect(id: String) -> String:
	var r = G.ratesPerMin(); var S = G.S
	match id:
		"house": return "其他建築最高可升到 Lv %d" % int(S.bld.house)
		"wood": return "每崗產量 ×%.1f　崗位 %d　目前 槐木 +%.1f/分" % [G.mult("wood"), G.slots("wood"), r.wood]
		"rice": return "每崗產量 ×%.1f　崗位 %d　目前 糯米 +%.1f/分" % [G.mult("rice"), G.slots("rice"), r.rice]
		"plank": return "崗位 %d　目前 棺材板 +%.1f/分（耗槐木 %.1f/分）\n藍箱可開出 棺材板 %d" % [G.slots("plank"), r.planks, r.woodUse, G.chestGain("b").planks]
		"bun": return "崗位 %d　目前 壽包 +%.1f/分（耗糯米 %.1f/分）\n綠箱可開出 壽包 %d" % [G.slots("bun"), r.buns, r.riceUse, G.chestGain("g").buns]
		"store": return "槐木、糯米、棺材板、壽包 存放上限：%s" % G.fmt(G.cap())
		"home": return "雜鬼名額 %d　遊魂自願當陰兵 +%.1f/分　陰兵上限 %s" % [G.rosterCap(), r.troops, G.fmt(G.troopCap())]
		"camp": return "練習速度 ×%.1f　崗位 %d　耗壽包 %.1f/分\n嚇功越高：回陽間招式更嚇人、更省陰氣；戰鬥嚇法更痛。" % [G.mult("camp"), G.slots("camp"), r.bunUse]
	return ""

func _post_ui(post: String, back: String) -> void:
	var P: Dictionary = DB.D.POSTS[post]; var n = G.slots(post)
	if n == 0: return
	var head = UIKit.rich("[b]%s崗位[/b] [font_size=12]%s[/font_size]" % [P.name, P.desc], 15, UIKit.INKTXT, "serif"); sheet_body.add_child(head)
	if G.S.lv < 4: _p("[color=#c2362b]升到 4 級【略懂管理學】後可派鬼怪打工。[/color]"); return
	var ws = G.workersAt(post)
	for i in n:
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9)
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55), 3, UIKit.PAPERLINE, 1, Vector4(8, 5, 8, 5)))
		pc.add_child(hb); sheet_body.add_child(pc)
		if i < ws.size():
			var g: Dictionary = ws[i]
			hb.add_child(UIKit.portrait(g.k, 44))
			var info = UIKit.rich("[b]%s[/b]\n[font_size=12]Lv%d　%s[/font_size]" % [g.name, G.glv(g), _post_stat(g, post)], 14.5, UIKit.INKTXT); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
			hb.add_child(_act(UIKit.btn("撤下", "", true), func(): g.post = null; G.save(); refresh(); _render_building(back)))
		else:
			var e = UIKit.label("空崗位", 14.5, UIKit.INKDIM); e.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(e)
			hb.add_child(_act(UIKit.btn("派人", "", true), func(): pick_worker(post, back)))

func _post_stat(g: Dictionary, post: String) -> String:
	var s = int(DB.D.POSTS[post].stat)
	return "%s %d" % [DB.D.STAT_NAMES[s], G.stat(g, s)] if s >= 0 else "等級 %d" % G.glv(g)

func pick_worker(post: String, back: String) -> void:
	var D = DB.D; var s = int(D.POSTS[post].stat)
	var val = func(g): return G.stat(g, s) if s >= 0 else G.glv(g)
	var fbd = func(g): return 1 if D.GHOSTS.has(g.k) and (D.GHOSTS[g.k].get("forbid", []) as Array).has(post) else 0
	var list = G.S.ghosts.filter(func(g): return g.k != "afu" and g.get("post") != post)
	list.sort_custom(func(a, b):
		if fbd.call(a) != fbd.call(b): return fbd.call(a) < fbd.call(b)
		if val.call(a) != val.call(b): return val.call(a) > val.call(b)
		return G.glv(a) > G.glv(b))
	open_sheet("派人：" + D.POSTS[post].name)
	_clear_body()
	_p("挑一位去「%s」。%s已在別處打工的，會被調過來。" % [D.POSTS[post].name, ("這份工看【%s】。" % D.STAT_NAMES[s]) if s >= 0 else "這份工看等級。"])
	for g in list:
		var fb: bool = fbd.call(g) == 1
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55 if not fb else 0.25), 3, UIKit.PAPERLINE, 1, Vector4(8, 6, 8, 6)))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9); pc.add_child(hb)
		hb.add_child(UIKit.portrait(g.k, 48))
		var others = []
		for i in 3:
			if i != s: others.append("%s%d" % [D.STAT_NAMES[i], G.stat(g, i)])
		var where: String = ("目前：" + D.POSTS[g.post].name) if g.get("post") != null and D.POSTS.has(g.post) else "閒著"
		var info = UIKit.rich("[b]%s[/b] [color=#9c2219]%s[/color]\n[font_size=12][b]%s %d[/b]　%s%s[/font_size]\n[font_size=12]%s%s[/font_size]" % [g.name, g.q, D.STAT_NAMES[s] if s >= 0 else "等級", val.call(g), ("Lv%d　" % G.glv(g)) if s >= 0 else "", " ".join(others), where, "　[color=#c2362b]怕糯米，不肯去[/color]" if fb else ""], 14, UIKit.INKTXT)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
		if not fb:
			var b = UIKit.btn("派", "gold", true); hb.add_child(b)
			b.pressed.connect(func():
				if G.workersAt(post).size() >= G.slots(post): G.workersAt(post)[0].post = null
				g.post = post; G.quest_check(); G.save(); refresh(); open_building(back))
		sheet_body.add_child(pc)
	if list.is_empty(): _p("沒有可以派的鬼怪。")
	var bk = UIKit.btn("返回"); bk.pressed.connect(func(): open_building(back)); sheet_body.add_child(bk)

# --- 鬼怪名冊 ---
func open_roster() -> void:
	open_sheet("鬼怪名冊"); _render_roster(); _nav_on("roster")

func _render_roster() -> void:
	_clear_body()
	var S = G.S; var D = DB.D
	_p("用壽包升級鬼怪。等級上限 %d。雜鬼名額 %d/%d　壽包 %s" % [G.ghostCap(), G.fodderCount(), G.rosterCap(), G.fmt(S.res.buns)])
	var order: Array = S.ghosts.duplicate()
	order.sort_custom(func(a, b):
		if a.k == "afu": return true
		if b.k == "afu": return false
		var qa = 0 if a.q == "名" else 1; var qb = 0 if b.q == "名" else 1
		if qa != qb: return qa < qb
		return G.glv(a) > G.glv(b))
	for g in order:
		var lv = G.glv(g); var cost = G.lvCost(lv); var d = G.gdef(g); var sk: Dictionary = D.SKILLS.get(g.k, {"name": "", "desc": ""})
		var tag = "出陣" if (S.team as Array).has(g.id) else ("軍師" if S.adviser == g.id else "")
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55), 3, UIKit.PAPERLINE, 1, Vector4(9, 8, 9, 8)))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); pc.add_child(hb)
		hb.add_child(UIKit.portrait(g.k, 60))
		var gd: Dictionary = D.GHOSTS.get(g.k, {})
		var txt = "[b]%s[/b] [color=#9c2219]%s[/color] [b]Lv%d[/b] %s\n[font_size=12]%s力 %d　智 %d　武 %d　%s[/font_size]\n[font_size=12][color=#2e5d55]【%s】%s[/color][/font_size]" % [g.name, g.q, lv, ("[bgcolor=#c2362b][color=#fff] %s [/color][/bgcolor]" % tag) if tag else "", (gd.title + "　") if gd.has("title") else "", G.stat(g, 0), G.stat(g, 1), G.stat(g, 2), "遠程" if d.get("range") == "ranged" else "近戰", sk.name, sk.desc]
		if gd.has("trait"): txt += "\n[font_size=12][color=#6e5838]%s[/color][/font_size]" % DB.L(gd.trait)
		txt += "\n[font_size=12]%s[/font_size]" % (("打工：" + D.POSTS[g.post].name) if g.get("post") != null and D.POSTS.has(g.post) else ("主公本人" if g.k == "afu" else "閒著"))
		var info = UIKit.rich(txt, 14, UIKit.INKTXT); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
		var act = VBoxContainer.new(); hb.add_child(act)
		if g.k == "afu": act.add_child(UIKit.label("隨主公\n等級成長", 11, UIKit.INKDIM))
		elif lv < G.ghostCap():
			act.add_child(_act(UIKit.btn("升級\n壽包 %d" % cost, "gold", true), func():
				var c = G.lvCost(int(g.lv))
				if float(S.res.buns) < c: return
				S.res.buns = float(S.res.buns) - c; g.spent = float(g.spent) + c; g.lv = int(g.lv) + 1; G.gainExp(2); G.quest_check(); G.save(); refresh(); _render_roster(), float(S.res.buns) >= cost))
		else: act.add_child(UIKit.label("已達上限", 11, UIKit.INKDIM))
		if g.q != "名" and g.q != "主":
			var rb = UIKit.btn("送去投胎", "ghost", true); act.add_child(rb)
			rb.pressed.connect(func():
				if not rb.has_meta("armed"): rb.set_meta("armed", 1); rb.text = "確定？"; return
				var back = int(floor(float(g.spent) * 0.6)); S.res.buns = float(S.res.buns) + back
				S.ghosts.erase(g); S.team = S.team.map(func(x): return null if x == g.id else x)
				if S.adviser == g.id: S.adviser = null
				show_toast("%s 去投胎了。退回 壽包 %d" % [g.name, back]); G.save(); refresh(); _render_roster())
		sheet_body.add_child(pc)

# --- 箱子 ---
func open_chests() -> void:
	open_sheet("箱子"); _render_chests()

func _render_chests() -> void:
	_clear_body()
	var S = G.S
	_p("小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。")
	for c in [["g", "綠箱", "開出 壽包 %d（隨包子鋪等級提升）" % G.chestGain("g").buns], ["b", "藍箱", "開出 棺材板 %d（隨棺材鋪等級提升）" % G.chestGain("b").planks], ["p", "紫箱", "開出 冥幣 %d（隨鬼宅等級提升）" % G.chestGain("p").coins]]:
		var k: String = c[0]; var have = int(S.chests[k])
		var open_n = func(n: int) -> void:
			var tot = {}
			for i in n:
				var gg = G.chestGain(k)
				for r in gg: tot[r] = tot.get(r, 0) + gg[r]
			S.chests[k] = int(S.chests[k]) - n; S.cnt.chest = int(S.cnt.chest) + n; show_toast("開箱：" + G.give(tot)); G.save(); refresh(); _render_chests()
		_row("[b]%s ×%d[/b]\n[font_size=12]%s[/font_size]" % [c[1], have, c[2]], [_act(UIKit.btn("開 1", "gold", true), func(): open_n.call(1), have > 0), _act(UIKit.btn("全開", "", true), func(): open_n.call(int(S.chests[k])), have > 1)])

# --- 劇情／設定 ---
func open_story() -> void:
	open_sheet("劇情"); _clear_body()
	var S = G.S; var D = DB.D
	_p("看過的劇情，可以在這裡重溫。")
	for e in D.SCENE_ORDER:
		var ids: Array = e[1]; var ok = ids.any(func(id): return S.seen.get(id, false))
		var b = UIKit.btn(e[0] if ok else "？？？", "" if ok else "ghost"); b.disabled = not ok
		b.pressed.connect(func():
			close_sheet(); _nav_on("village")
			for id in ids:
				if S.seen.get(id, false): story.queue(id))
		sheet_body.add_child(b)
	sheet_body.add_child(UIKit.hsep())
	var lb = UIKit.btn("對白語言：" + ("中文" if DB.lang == "zh" else "粵語"))
	lb.pressed.connect(func(): DB.set_lang("yue" if DB.lang == "zh" else "zh"); lb.text = "對白語言：" + ("中文" if DB.lang == "zh" else "粵語"))
	sheet_body.add_child(lb)
	var ex = UIKit.btn("備份存檔（複製存檔碼）"); sheet_body.add_child(ex)
	var ta = TextEdit.new(); ta.custom_minimum_size = Vector2(0, 90); ta.placeholder_text = "貼上存檔碼（網頁版的存檔碼也可以）"; ta.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	ta.add_theme_font_override("font", UIKit.font("sans", 400)); ta.add_theme_font_size_override("font_size", 13)
	ex.pressed.connect(func(): G.save(); var code = G.enc(G.S); DisplayServer.clipboard_set(code); ta.text = code; show_toast("存檔碼已複製，貼去記事本或者 WhatsApp 自己收好"))
	var im = UIKit.btn("導入存檔碼", "gold"); sheet_body.add_child(ta); sheet_body.add_child(im)
	im.pressed.connect(func():
		var o = G.dec(ta.text if ta.text.strip_edges() != "" else DisplayServer.clipboard_get())
		if o == null: show_toast("存檔碼讀唔到，檢查吓有冇貼齊"); return
		if not im.has_meta("armed"): im.set_meta("armed", 1); im.text = "再按一次：換成主公 %d 級嘅存檔" % int(o.get("lv", 1)); return
		import_save(ta.text if ta.text.strip_edges() != "" else DisplayServer.clipboard_get()))
	var rs = UIKit.btn("重新開始（刪除存檔）", "ghost"); sheet_body.add_child(rs)
	rs.pressed.connect(func():
		if not rs.has_meta("armed"): rs.set_meta("armed", 1); rs.text = "再按一次確定刪檔"; return
		restart_with(null, true))
	_p("[font_size=11]Godot 版 %s（對應網頁版 %s）[/font_size]" % [ProjectSettings.get_setting("application/config/version", "dev"), D.get("GAME_VER", "")], 11)

# ---------------- 標題畫面 ----------------
func _show_title(fresh: bool) -> void:
	if JSRun.skip_title:
		var v = JSRun.skip_title; JSRun.skip_title = false
		if v is String and v == "pre": call_deferred("phone_home", "pre")
		return
	title_ov = Control.new(); title_ov.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); title_ov.mouse_filter = Control.MOUSE_FILTER_STOP; add_child(title_ov)
	var bg = ColorRect.new(); bg.color = Color("#2e2422"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); title_ov.add_child(bg)
	# 封面：寬度鋪滿、靠頂（background-size:100% auto; position:center top），底部漸變接返底色
	var tex: Texture2D = Spr.get_tex("cover")
	var cov = TextureRect.new(); cov.texture = tex; cov.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cov.stretch_mode = TextureRect.STRETCH_SCALE
	cov.anchor_right = 1; cov.mouse_filter = Control.MOUSE_FILTER_IGNORE; title_ov.add_child(cov)
	var cfade = TextureRect.new(); cfade.texture = _vgrad([[0.0, Color(0.18, 0.14, 0.13, 0)], [0.82, Color(0.18, 0.14, 0.13, 0)], [1.0, Color("#2e2422")]])
	cfade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cfade.stretch_mode = TextureRect.STRETCH_SCALE; cfade.anchor_right = 1; cfade.mouse_filter = Control.MOUSE_FILTER_IGNORE; title_ov.add_child(cfade)
	var fit = func():
		var w: float = title_ov.size.x; var h: float = w * tex.get_height() / tex.get_width()
		cov.offset_bottom = h; cfade.offset_bottom = w * 1.5
	title_ov.resized.connect(fit); fit.call()
	var fog = TextureRect.new(); fog.texture = _vgrad([[0.0, Color(0.05, 0.04, 0.06, 0)], [0.45, Color(0.05, 0.04, 0.06, 0.55)], [1.0, Color(0.05, 0.04, 0.06, 0.85)]])
	fog.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; fog.stretch_mode = TextureRect.STRETCH_SCALE
	fog.anchor_right = 1; fog.anchor_top = 0.58; fog.anchor_bottom = 1; fog.mouse_filter = Control.MOUSE_FILTER_IGNORE; title_ov.add_child(fog)
	var vb = VBoxContainer.new(); vb.anchor_left = 0; vb.anchor_right = 1; vb.anchor_top = 1; vb.anchor_bottom = 1; vb.grow_vertical = Control.GROW_DIRECTION_BEGIN
	vb.offset_bottom = -26; vb.add_theme_constant_override("separation", 10); vb.alignment = BoxContainer.ALIGNMENT_END
	title_ov.add_child(vb)
	var mk = func(key: String, off: bool) -> TextureButton:
		var t2: Texture2D = Spr.get_tex(key)
		var b = TextureButton.new(); b.texture_normal = t2; b.ignore_texture_size = true; b.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		var w = minf(390 * 0.78, 330); b.custom_minimum_size = Vector2(w, w * t2.get_height() / t2.get_width()); b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.pivot_offset = b.custom_minimum_size / 2
		if off: b.modulate = Color(0.5, 0.5, 0.5, 0.7); b.material = _gray_mat()
		else:
			var tw = b.create_tween().set_loops(); tw.tween_property(b, "rotation", deg_to_rad(-1.2), 1.5).set_trans(Tween.TRANS_SINE); tw.tween_property(b, "rotation", deg_to_rad(1.2), 1.5).set_trans(Tween.TRANS_SINE)
		vb.add_child(b); return b
	var bn: TextureButton = mk.call("btn_new", false)
	var bc: TextureButton = mk.call("btn_cont", fresh)
	var hint = UIKit.label("還沒有存檔" if fresh else "", 13, Color("#e8dcc4")); hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; hint.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; hint.custom_minimum_size = Vector2(0, 18)
	hint.add_theme_color_override("font_shadow_color", Color.BLACK); hint.add_theme_constant_override("shadow_offset_y", 1); vb.add_child(hint)
	bc.pressed.connect(_title_cont.bind(fresh))
	bn.pressed.connect(_title_new.bind(fresh, bn, hint))

func _title_cont(fresh: bool) -> void:
	if fresh: return
	_snd("gong"); _hide_title(); phone_home("post")   # 網頁版：繼續遊戲 → 手機（陰間版 WhatsApp）→ 主對話 → 結算離線收益

func _title_new(fresh: bool, bn: TextureButton, hint: Label) -> void:
	if not fresh and not bn.has_meta("armed"):
		bn.set_meta("armed", 1); hint.text = "會刪掉現在的存檔。再點一次「開始新遊戲」確定。"; return
	if not fresh: restart_with(null, "pre"); return
	_snd("gong"); _hide_title(); refresh(); phone_home("pre")

func _vgrad(stops: Array) -> GradientTexture2D:
	var gt = GradientTexture2D.new(); var gr = Gradient.new()
	gr.offsets = PackedFloat32Array(stops.map(func(x): return x[0])); gr.colors = PackedColorArray(stops.map(func(x): return x[1]))
	gt.gradient = gr; gt.fill_from = Vector2(0, 0); gt.fill_to = Vector2(0, 1); gt.width = 4; gt.height = 128
	return gt

func _gray_mat() -> ShaderMaterial:
	var sh = Shader.new(); sh.code = "shader_type canvas_item; void fragment(){ vec4 c = texture(TEXTURE, UV) * COLOR; float g = dot(c.rgb, vec3(0.299,0.587,0.114)); COLOR = vec4(mix(c.rgb, vec3(g), 0.85), c.a); }"
	var m = ShaderMaterial.new(); m.shader = sh; return m

# ---------------- 手機（仿 WhatsApp）----------------
var phone: WA = null
func phone_home(ph: String) -> void:
	if phone == null:
		phone = WA.new(); add_child(phone)
		phone.on_enter = _phone_enter
	move_child(phone, get_child_count() - 1)
	phone.show_home(ph)
	_phone_flag(true)
	var s = J.G.get("Sound")
	if s is Dictionary: J.mc(s, "setMode", ["office" if ph == "pre" else "story"])

func phone_close() -> void:
	if phone: phone.queue_free(); phone = null
	_phone_flag(false)

func _phone_flag(on: bool) -> void:
	var p = J.G.get("Phone")
	if p is Dictionary: p["on"] = on

func _phone_enter(ph: String) -> void:
	phone_close()
	if ph == "pre":
		for id in ["prologue_chat", "prologue_narr", "prologue_road", "prologue_sys"]: story.queue(id)
	else:
		G.offline_gain()
		var s = J.G.get("Sound")
		if s is Dictionary: J.mc(s, "setMode", ["village"])

func _snd(n: String) -> void:
	var s = J.G.get("Sound")
	if s is Dictionary and s.has("play"): J.mc(s, "play", [n])

func _hide_title() -> void:
	if title_ov: title_ov.queue_free(); title_ov = null

# ---------------- 存檔：經 JS 嘅 localStorage，然後重新載入場景（同網頁版 location.reload 一樣）----------------
const SAVE_KEY := "ghostBattles_v1"
func import_save(code: String) -> bool:
	var o = G.dec(code)
	if o == null: show_toast("存檔碼讀唔到，檢查吓有冇貼齊"); return false
	o.last = G.now_ms()
	restart_with(o, true); return true

func restart_with(save, skip_title) -> void:
	if JSRun.ls.has(SAVE_KEY): JSRun.ls[SAVE_KEY + "_bak"] = JSRun.ls[SAVE_KEY]
	if save == null: JSRun.ls.erase(SAVE_KEY)
	else: JSRun.ls[SAVE_KEY] = J.to_json(save)
	JSRun.flush_ls()
	JSRun.skip_title = skip_title
	JSRun.reset_world()
	get_tree().call_deferred("reload_current_scene")

func open_html_sheet(title: String, html: String) -> void:
	open_sheet(title); _clear_body()
	_p(JSBridge.html2bb(html), 14, UIKit.INKTXT)
