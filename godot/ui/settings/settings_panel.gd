# [settings] 設置面板（全螢幕）：聲音／畫面／劇情／存檔／支援
# 入口：標題畫面「設置」按鈕、遊戲內頂欄齒輪、劇情回顧頁「設置」按鈕
# 用法（熱更新：冇 class_name）：
#   var sp = load("res://ui/settings/settings_panel.gd").new(); sp.host = main; sp.in_title = true; sp.has_save = ...; main.add_child(sp)
extends Control

const PF = preload("res://game/settings/prefs.gd")
const TABS := ["聲音", "畫面", "劇情", "存檔", "支援"]
const SAVE_KEY := "ghostBattles_v1"

var host: Node            # Main（ui/main.gd）
var in_title := false     # 由標題畫面打開
var has_save := true      # 冇存檔：存檔頁相關項停用
var tab := 0
var on_close: Callable = Callable()

var _body: VBoxContainer
var _scroll: ScrollContainer
var _tabs: Array = []
var _toast: Label
var _win: PanelContainer
const MAX_W := 600.0   # [pc] 橫屏／闊螢幕：面板置中、限最大闊度
var _toast_t := 0.0

const C_BG := Color("#1b1519")
const C_PANEL := Color("#f1e3bd")
const C_LINE := Color("#b89a52")
const C_TXT := Color("#2b1d12")
const C_DIM := Color("#6e5838")
const C_RED := Color("#bb3427")

func _ready() -> void:
	name = "SettingsPanel"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 50
	PF.load_pref()
	var dim = ColorRect.new(); dim.color = Color(0.02, 0.01, 0.03, 0.72); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(dim)
	dim.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: pass)
	var pn = PanelContainer.new(); pn.name = "Win"
	var ps = UIKit.sb(C_PANEL, 14, Color("#6b4a2b"), 3, Vector4(0, 0, 0, 0)); ps.shadow_color = Color(0, 0, 0, 0.6); ps.shadow_size = 18
	pn.add_theme_stylebox_override("panel", ps)
	add_child(pn); _win = pn
	resized.connect(_fit); _fit()
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 0); pn.add_child(vb)
	# 標題列
	var head = PanelContainer.new(); var hs = UIKit.sb(Color("#3a2c26"), 0, Color(0, 0, 0, 0), 0, Vector4(18, 10, 10, 10))
	hs.corner_radius_top_left = 11; hs.corner_radius_top_right = 11; head.add_theme_stylebox_override("panel", hs); vb.add_child(head)
	var hb = HBoxContainer.new(); head.add_child(hb)
	var tl = UIKit.label("設置", 26, Color("#f3d68a"), "serif", 900); tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tl.add_theme_color_override("font_outline_color", Color("#140c08")); tl.add_theme_constant_override("outline_size", 4); hb.add_child(tl)
	var x = UIKit.btn("✕", "gold"); x.name = "Close"; x.custom_minimum_size = Vector2(48, 44); x.add_theme_font_size_override("font_size", 20)
	x.pressed.connect(close); hb.add_child(x)
	# 分頁
	var tb = HBoxContainer.new(); tb.add_theme_constant_override("separation", 4)
	var tbm = MarginContainer.new(); for s in ["left", "right"]: tbm.add_theme_constant_override("margin_" + s, 10)
	tbm.add_theme_constant_override("margin_top", 10); tbm.add_theme_constant_override("margin_bottom", 6); tbm.add_child(tb); vb.add_child(tbm)
	for i in TABS.size():
		var b = Button.new(); b.text = TABS[i]; b.name = "Tab%d" % i; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.custom_minimum_size = Vector2(0, 46); b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 17)
		var ii = i; b.pressed.connect(func(): _snd("click"); show_tab(ii)); tb.add_child(b); _tabs.append(b)
	vb.add_child(_line())
	_scroll = ScrollContainer.new(); _scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL; _scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var m = MarginContainer.new(); m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for s in ["left", "right"]: m.add_theme_constant_override("margin_" + s, 16)
	m.add_theme_constant_override("margin_top", 8); m.add_theme_constant_override("margin_bottom", 16)
	_body = VBoxContainer.new(); _body.name = "Body"; _body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; _body.add_theme_constant_override("separation", 6)
	m.add_child(_body); _scroll.add_child(m); vb.add_child(_scroll)
	_toast = UIKit.label("", 15, Color("#fff3e0"), "sans", 700); _toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; _toast.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	var ts = UIKit.sb(Color(0.1, 0.06, 0.05, 0.92), 8, Color("#f3d68a"), 1, Vector4(14, 10, 14, 10)); _toast.add_theme_stylebox_override("normal", ts)
	_toast.anchor_left = 0.08; _toast.anchor_right = 0.92; _toast.anchor_top = 1; _toast.anchor_bottom = 1; _toast.offset_top = -120; _toast.offset_bottom = -70
	_toast.visible = false; _toast.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(_toast)
	show_tab(tab)
	# 彈出動畫
	pn.modulate.a = 0; pn.scale = Vector2(0.96, 0.96)
	var tw = create_tween().set_parallel(); tw.tween_property(pn, "modulate:a", 1.0, 0.16); tw.tween_property(pn, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _fit() -> void:
	if _win == null: return
	var w = size.x; var h = size.y
	_win.anchor_top = 0; _win.anchor_bottom = 1
	if w > MAX_W + 28:   # 闊螢幕：置中
		_win.anchor_left = 0.5; _win.anchor_right = 0.5; _win.offset_left = -MAX_W / 2; _win.offset_right = MAX_W / 2
		_win.offset_top = 46 if h > w else 24; _win.offset_bottom = -30 if h > w else -24
	else:
		_win.anchor_left = 0; _win.anchor_right = 1; _win.offset_left = 14; _win.offset_right = -14; _win.offset_top = 46; _win.offset_bottom = -30
	_win.pivot_offset = _win.size / 2

func _process(dt: float) -> void:
	if _toast_t > 0:
		_toast_t -= dt
		if _toast_t <= 0: _toast.visible = false

func _input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and e.keycode == KEY_ESCAPE: close(); get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST: close()

func close() -> void:
	if is_queued_for_deletion(): return
	_snd("click")
	if on_close.is_valid(): on_close.call()
	queue_free()

func toast(s: String) -> void:
	_toast.text = s; _toast.visible = true; _toast_t = 2.6

func _snd(n: String) -> void:
	var s = get_node_or_null("/root/Snd")
	if s != null and s.has_method("play"): s.call("play", n)

# ---------------- 分頁 ----------------
func show_tab(i: int) -> void:
	tab = i
	for j in _tabs.size():
		var b: Button = _tabs[j]; var sel = j == i
		var bg = Color("#3a2c26") if sel else Color(0.23, 0.17, 0.15, 0.12)
		var st = UIKit.sb(bg, 6, Color("#3a2c26") if sel else C_LINE, 1, Vector4(4, 6, 4, 6))
		for k in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(k, st)
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var fg = Color("#f3d68a") if sel else C_DIM
		for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fg)
	for c in _body.get_children(): c.queue_free()
	_scroll.scroll_vertical = 0
	match i:
		0: _tab_sound()
		1: _tab_gfx()
		2: _tab_story()
		3: _tab_save()
		4: _tab_support()

# ---------------- 小工具 ----------------
func _line() -> Control:
	var c = ColorRect.new(); c.color = Color(C_LINE, 0.7); c.custom_minimum_size = Vector2(0, 1); return c

func _h(t: String) -> void:
	var l = UIKit.label(t, 15, C_RED, "serif", 900); l.custom_minimum_size.y = 30; l.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM; _body.add_child(l)

func _note(t: String) -> Label:
	var l = UIKit.label(t, 13, C_DIM); l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; _body.add_child(l); return l

# 一行：左邊標題（＋細字說明），右邊控件
func _row(title: String, ctrl: Control, desc := "") -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); hb.custom_minimum_size.y = 52
	var lv = VBoxContainer.new(); lv.size_flags_horizontal = Control.SIZE_EXPAND_FILL; lv.alignment = BoxContainer.ALIGNMENT_CENTER; lv.add_theme_constant_override("separation", 0)
	var t = UIKit.label(title, 17, C_TXT, "sans", 700); lv.add_child(t)
	if desc != "":
		var d = UIKit.label(desc, 12, C_DIM); d.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; lv.add_child(d)
	hb.add_child(lv)
	ctrl.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(ctrl)
	_body.add_child(hb); _body.add_child(_line())
	return hb

# 分段選擇（例如 慢／中／快／即時）
func _seg(opts: Array, cur: int, cb: Callable, w := 56) -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 3)
	var btns: Array = []
	var paint = func(sel: int):
		for j in btns.size():
			var b: Button = btns[j]; var on = j == sel
			var st = UIKit.sb(C_RED if on else Color(1, 1, 1, 0.35), 6, Color("#7a2a1e") if on else C_LINE, 1, Vector4(6, 6, 6, 6))
			for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, st)
			var fg = Color("#fff3e0") if on else C_TXT
			for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fg)
	for j in opts.size():
		var b = Button.new(); b.text = str(opts[j]); b.custom_minimum_size = Vector2(w, 42); b.focus_mode = Control.FOCUS_NONE
		if w == 0: b.size_flags_horizontal = Control.SIZE_EXPAND_FILL   # 闊度 0：平均分滿成行
		b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 15)
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var jj = j; b.pressed.connect(func(): _snd("click"); paint.call(jj); cb.call(jj)); hb.add_child(b); btns.append(b)
	paint.call(cur)
	return hb

func _toggle(on: bool, cb: Callable) -> HBoxContainer:
	return _seg(["關", "開"], 1 if on else 0, func(j): cb.call(j == 1), 52)

func _slider(k: String) -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8)
	var s = HSlider.new(); s.name = "Vol_" + k; s.min_value = 0; s.max_value = 100; s.step = 1; s.value = PF.pct(k)
	s.custom_minimum_size = Vector2(150, 36); s.focus_mode = Control.FOCUS_NONE
	var tr = StyleBoxFlat.new(); tr.bg_color = Color("#3a2e26"); tr.set_corner_radius_all(4); tr.content_margin_top = 4; tr.content_margin_bottom = 4
	var fl = StyleBoxFlat.new(); fl.bg_color = C_RED; fl.set_corner_radius_all(4); fl.content_margin_top = 4; fl.content_margin_bottom = 4
	s.add_theme_stylebox_override("slider", tr); s.add_theme_stylebox_override("grabber_area", fl); s.add_theme_stylebox_override("grabber_area_highlight", fl)
	var g = _knob(); s.add_theme_icon_override("grabber", g); s.add_theme_icon_override("grabber_highlight", g)
	var pl = UIKit.label("%d" % PF.pct(k), 16, C_TXT, "sans", 900); pl.custom_minimum_size = Vector2(38, 0); pl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	s.value_changed.connect(func(v): pl.text = "%d" % int(v); PF.set_vol(k, v / 100.0))
	s.drag_ended.connect(func(_c): if k != "music": _snd("click"))
	hb.add_child(s); hb.add_child(pl); return hb

static var _knob_tex: Texture2D
func _knob() -> Texture2D:
	if _knob_tex: return _knob_tex
	var n := 26; var img = Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for xx in n:
			var d = Vector2(xx + 0.5, y + 0.5).distance_to(Vector2(n / 2.0, n / 2.0))
			var a = clampf(n / 2.0 - d, 0.0, 1.0)
			var c = Color("#f3d68a") if d < n / 2.0 - 3 else Color("#6b4a2b")
			img.set_pixel(xx, y, Color(c, a))
	_knob_tex = ImageTexture.create_from_image(img); return _knob_tex

func _wide(t: String, kind := "", cb: Callable = Callable(), enabled := true) -> Button:
	var b = UIKit.btn(t, kind); b.custom_minimum_size.y = 48; b.add_theme_font_size_override("font_size", 16); b.disabled = not enabled
	if cb.is_valid(): b.pressed.connect(func(): _snd("click"); cb.call())
	_body.add_child(b); return b

# 二次確認按鈕
func _confirm(t: String, again: String, cb: Callable, enabled := true) -> Button:
	var b = UIKit.btn(t, "ghost"); b.custom_minimum_size.y = 48; b.add_theme_font_size_override("font_size", 16); b.disabled = not enabled
	b.pressed.connect(func():
		if not b.has_meta("armed"): b.set_meta("armed", 1); b.text = again; return
		cb.call())
	_body.add_child(b); return b

# ---------------- 聲音 ----------------
func _snd_on() -> bool:
	var s = get_node_or_null("/root/Snd"); return s == null or not s.has_method("is_on") or bool(s.call("is_on"))

func _tab_sound() -> void:
	_h("聲音")
	_row("聲音", _toggle(_snd_on(), func(v):
		var s = get_node_or_null("/root/Snd")
		if s != null and bool(s.call("is_on")) != v: s.call("toggle")), "關掉＝全部靜音")
	_row("總音量", _slider("master"))
	_row("音樂", _slider("music"), "背景音樂、環境聲")
	_row("音效", _slider("sfx"), "按鈕、戰鬥、做工")
	_row("語音", _slider("voice"), "劇情配音")

# ---------------- 畫面 ----------------
func _tab_gfx() -> void:
	var PM = load("res://ui/perf_mode.gd"); PM.load_pref()
	_h("畫面")
	var fps_row: HBoxContainer
	_row("流暢模式", _toggle(PM.on, func(v):
		PM.set_on(v, host); PF.apply_display()
		if fps_row: fps_row.modulate.a = 0.45 if v else 1.0), "解像度 0.75、少霧、鎖 30 幀；手機卡就開")
	fps_row = _row("幀率上限", _seg(["30", "60"], 0 if PF.fps == 30 else 1, func(j): PF.set_fps(30 if j == 0 else 60)), "流暢模式開時固定 30")
	fps_row.modulate.a = 0.45 if PM.on else 1.0
	_row("螢幕常亮", _toggle(PF.keep_on, func(v): PF.set_keep_on(v)), "玩的時候手機不自動熄屏")
	_row("安全畫面模式", _toggle(G.safe_gfx, func(v): G.set_safe_gfx(v)), "閃退時用；重開遊戲生效")
	if PF.is_pc(): _pc_rows()

# [pc] 電腦版（Steam）專屬：顯示模式、解析度、垂直同步（手機唔顯示）
func _pc_rows() -> void:
	_h("電腦版")
	var res_row: Control
	_row("顯示模式", _seg(PF.WIN_MODES, PF.win_mode, func(j):
		PF.set_win_mode(j)
		if res_row: res_row.modulate.a = 1.0 if j == 0 else 0.45), "無邊框＝全螢幕但切換視窗快")
	var cur = PF.RES_OPTS.find(PF.res)
	if cur < 0:
		var ws = DisplayServer.window_get_size(); cur = PF.RES_OPTS.find("%d×%d" % [ws.x, ws.y])
	# 解析度：三粒掣放標題下面成行（直屏視窗都唔會撐爆面板）
	var rv = VBoxContainer.new(); rv.add_theme_constant_override("separation", 6); rv.custom_minimum_size.y = 52
	var rl = UIKit.label("解析度", 17, C_TXT, "sans", 700); rv.add_child(rl)
	var rd = UIKit.label("視窗模式用", 12, C_DIM); rv.add_child(rd)
	var rseg = _seg(PF.RES_OPTS, cur, func(j): PF.set_res(PF.RES_OPTS[j]), 0); rseg.name = "ResSeg"
	for b in rseg.get_children(): b.add_theme_font_size_override("font_size", 14)
	rv.add_child(rseg); _body.add_child(rv); _body.add_child(_line())
	res_row = rv
	_row("垂直同步", _toggle(PF.vsync, func(v): PF.set_vsync(v)), "防止畫面撕裂；關閉後幀率可能更高")

# ---------------- 劇情 ----------------
func _tab_story() -> void:
	_h("劇情")
	_row("對白語言", _seg(["中文", "粵語"], 0 if DB.lang == "zh" else 1, func(j): _set_lang("zh" if j == 0 else "yue")))
	_row("文字速度", _seg(PF.SPEED_NAME, PF.text_speed, func(j): PF.set_text_speed(j), 50))
	_row("自動播放", _toggle(PF.auto_play, func(v): PF.set_auto(v)), "一句講完自動翻頁；點畫面照樣可以快進")

func _set_lang(l: String) -> void:
	DB.set_lang(l)
	var LG = J.G.get("LANG") if J.G is Dictionary else null
	if LG != null: J.mc(LG, "set", [DB.lang])

# ---------------- 存檔 ----------------
func _tab_save() -> void:
	_acct_rows()
	_h("存檔")
	if not has_save: _note("還沒有存檔。開始遊戲之後才可以備份。")
	_wide("備份存檔（複製存檔碼）", "", func():
		G.save(); var code = G.enc(G.S); DisplayServer.clipboard_set(code)
		toast("存檔碼已複製，貼去記事本或者聊天軟件自己收好"), has_save)
	_note("存檔碼可以換手機、重裝遊戲時用來搬進度。")
	_wide("導入存檔碼", "gold", func():
		if host != null and host.has_method("open_import"): close(); host.call("open_import"))
	_body.add_child(Control.new())
	_h("重新開始")
	_note("會刪掉現在的進度（自動留一份備份）。")
	_confirm("重新開始（刪除存檔）", "再按一次確定刪檔", func():
		if JSRun.ls.has(SAVE_KEY): JSRun.ls[SAVE_KEY + "_del"] = JSRun.ls[SAVE_KEY]
		if host != null: host.call("restart_with", null, true), has_save)

# [account] 帳號：郵箱、上次同步、立即同步、登出、更換帳號
const ACC = preload("res://game/account/acct.gd")
func _acct_rows() -> void:
	_h("帳號")
	if not ACC.logged_in():
		_note("還沒有登入。登入後進度會綁定郵箱，換機也不怕。")
		var lb = _wide("登入／註冊", "gold", func(): _open_login()); lb.name = "AcctLogin"
		_body.add_child(Control.new()); return
	var er = _row("郵箱", _val(ACC.email)); er.name = "AcctEmail"
	var sl = _val(ACC.last_sync_text()); sl.name = "AcctSyncVal"
	_row("上次同步", sl, "遊戲中每幾分鐘、切出去時自動同步")
	var sb = _wide("立即同步", "", func(): pass); sb.name = "AcctSync"
	sb.pressed.connect(func():
		if sb.disabled: return
		sb.disabled = true; sb.text = "同步中…"
		var r: Dictionary = await ACC.sync()
		if not is_instance_valid(sb): return
		sb.disabled = false; sb.text = "立即同步"; sl.text = ACC.last_sync_text()
		var st = str(r.get("state", ""))
		if st in ["same", "none"]: toast("進度已經是最新。")
		elif st == "uploaded": toast("已上傳到帳號。")
		elif st == "download":
			toast("帳號裡有較新的進度，正在載入…"); ACC.apply_cloud(str(r.data), int(r.rev))
		elif st == "conflict":
			var sd = load("res://ui/account/sync_dialog.gd").new(); sd.info = r; add_child(sd)
		else: toast(ACC.msg(st)))
	var lo = _confirm("登出", "再按一次確定登出（會先同步進度）", func(): _logout()); lo.name = "AcctLogout"
	var sw = _confirm("更換帳號", "再按一次：登出並換另一個帳號", func(): _logout()); sw.name = "AcctSwitch"
	_note("登出後這部裝置的進度會先上傳，再從這部裝置清走；登入回同一個帳號就會接回來。")
	_body.add_child(Control.new())

func _logout() -> void:
	toast("登出中…")
	var r: Dictionary = await ACC.sign_out()
	if not bool(r.get("synced", false)): toast("沒能上傳（離線？）。進度已留在這部裝置，登入同一帳號會接回。")
	JSRun.skip_title = false; JSRun.reset_world(); get_tree().call_deferred("reload_current_scene")

func _open_login() -> void:
	var lp = load("res://ui/account/login_panel.gd").new(); lp.host = host
	lp.on_done = func(): if is_instance_valid(self): show_tab(3)
	add_child(lp)

# ---------------- 支援 ----------------
func _tab_support() -> void:
	_h("遊戲資訊")
	var ver = str(host.call("_ver_text")) if host != null and host.has_method("_ver_text") else str(ProjectSettings.get_setting("application/config/version", "dev"))
	_row("版本", _val(ver))
	_row("製作", _val("Lawrance"))
	_h("出問題時")
	_wide("錯誤記錄（複製給開發者）", "", func():
		if host == null: return
		var lt = UIKit.label(str(host.call("log_tail", 40)), 10, C_TXT); lt.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; _body.add_child(lt)
		DisplayServer.clipboard_set(str(host.call("log_tail", 200))); toast("記錄已複製，可以貼去訊息給開發者"))
	_wide("全面自檢（約 3–5 分鐘，出報告給開發者）", "ghost", func():
		SelfTest.start(true); JSRun.reset_world(); get_tree().call_deferred("reload_current_scene"))

func _val(t: String) -> Label:
	var l = UIKit.label(t, 15, C_DIM, "sans", 700); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	l.custom_minimum_size = Vector2(200, 0); return l
