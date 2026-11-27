# [account] 登入／註冊面板（標題畫面之前彈出；要登入先玩得）
#   模式：login 登入／register 註冊／verify 等驗證郵件／forgot 忘記密碼
#   成功登入 → 同步（舊玩家本機進度自動綁定；兩邊都有又唔同 → 衝突對話框）→ on_done
# 用法（熱更新：冇 class_name）：
#   var lp = load("res://ui/account/login_panel.gd").new(); lp.host = main; lp.on_done = func(): ...; main.add_child(lp)
extends Control

const ACC = preload("res://game/account/acct.gd")
const AC = preload("res://game/account/acct_cfg.gd")
const MAX_W := 520.0
const C_PANEL := Color("#f1e3bd")
const C_TXT := Color("#2b1d12")
const C_DIM := Color("#6e5838")
const C_RED := Color("#9a2a1e")

var host: Node
var on_done: Callable = Callable()
var mode := "login"
var busy := false
var pend_email := ""
var pend_pw := ""

var _win: PanelContainer
var _body: VBoxContainer
var _title: Label
var _err: Label
var f_email: LineEdit
var f_pw: LineEdit
var f_pw2: LineEdit
var btn_main: Button
var _btns: Array = []

func _ready() -> void:
	name = "LoginPanel"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP; z_index = 60
	var bg = ColorRect.new(); bg.color = Color("#17121a"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
	var TV = load("res://ui/title/title_view.gd")
	var land = size.x > size.y
	var ct: Texture2D = TV.tex("cover2_wide") if land else null
	if ct == null: ct = TV.tex("cover2")
	if ct == null: ct = TV.tex("cover")
	if ct != null:
		var cv = TextureRect.new(); cv.name = "Cover"; cv.texture = ct; cv.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cv.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		cv.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); cv.modulate = Color(0.45, 0.42, 0.48); cv.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(cv)
	var dim = ColorRect.new(); dim.color = Color(0.03, 0.02, 0.04, 0.45); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dim.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(dim)
	_win = PanelContainer.new(); _win.name = "Win"
	var ps = UIKit.sb(C_PANEL, 14, Color("#6b4a2b"), 3); ps.shadow_color = Color(0, 0, 0, 0.6); ps.shadow_size = 18
	_win.add_theme_stylebox_override("panel", ps); add_child(_win)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 0); _win.add_child(vb)
	var head = PanelContainer.new(); var hs = UIKit.sb(Color("#3a2c26"), 0, Color(0, 0, 0, 0), 0, Vector4(18, 12, 18, 12))
	hs.corner_radius_top_left = 11; hs.corner_radius_top_right = 11; head.add_theme_stylebox_override("panel", hs); vb.add_child(head)
	_title = UIKit.label("", 24, Color("#f3d68a"), "serif", 900); _title.add_theme_color_override("font_outline_color", Color("#140c08")); _title.add_theme_constant_override("outline_size", 4)
	head.add_child(_title)
	var m = MarginContainer.new(); for s in ["left", "right"]: m.add_theme_constant_override("margin_" + s, 22)
	m.add_theme_constant_override("margin_top", 14); m.add_theme_constant_override("margin_bottom", 20); vb.add_child(m)
	_body = VBoxContainer.new(); _body.name = "Body"; _body.add_theme_constant_override("separation", 10); m.add_child(_body)
	resized.connect(_fit)
	show_mode("login")
	_fit()
	_win.modulate.a = 0; create_tween().tween_property(_win, "modulate:a", 1.0, 0.2)

func _fit() -> void:
	if _win == null: return
	var w = size.x; var h = size.y; var land = w > h
	var ww = minf(MAX_W, w - 28)
	_win.anchor_left = 0.5; _win.anchor_right = 0.5; _win.anchor_top = 0.5; _win.anchor_bottom = 0.5
	_win.offset_left = -ww / 2; _win.offset_right = ww / 2
	var ch = _win.get_combined_minimum_size().y
	_win.offset_top = -ch / 2 + (0.0 if land else h * 0.04); _win.offset_bottom = _win.offset_top + ch

func _input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and (e.keycode == KEY_ENTER or e.keycode == KEY_KP_ENTER) and btn_main != null and not busy:
		btn_main.pressed.emit(); get_viewport().set_input_as_handled()

# ---------------- 介面小工具 ----------------
func _clear() -> void:
	for c in _body.get_children(): _body.remove_child(c); c.queue_free()
	_btns.clear(); f_email = null; f_pw = null; f_pw2 = null; btn_main = null

func _txt(t: String, sz := 15, col := C_TXT) -> Label:
	var l = UIKit.label(t, sz, col); l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; _body.add_child(l); return l

func _field(ph: String, secret := false) -> LineEdit:
	var le = LineEdit.new(); le.placeholder_text = ph; le.secret = secret; le.custom_minimum_size = Vector2(0, 50)
	le.add_theme_font_override("font", UIKit.font("sans", 700)); le.add_theme_font_size_override("font_size", 18)
	le.add_theme_color_override("font_color", C_TXT); le.add_theme_color_override("font_placeholder_color", Color(C_DIM, 0.6)); le.add_theme_color_override("caret_color", C_TXT)
	le.add_theme_stylebox_override("normal", UIKit.sb(Color("#fbf3dc"), 8, Color("#b89a52"), 2, Vector4(14, 8, 14, 8)))
	le.add_theme_stylebox_override("focus", UIKit.sb(Color("#fffaf0"), 8, Color("#bb3427"), 2, Vector4(14, 8, 14, 8)))
	if not secret: le.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_EMAIL_ADDRESS
	else: le.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_PASSWORD
	_body.add_child(le); return le

func _btn(t: String, kind: String, cb: Callable) -> Button:
	var b = UIKit.btn(t, kind); b.custom_minimum_size.y = 52 if kind == "gold" else 44; b.add_theme_font_size_override("font_size", 18 if kind == "gold" else 15)
	b.focus_mode = Control.FOCUS_NONE
	b.pressed.connect(func():
		if busy: return
		_snd("click"); cb.call())
	_body.add_child(b); _btns.append(b); return b

func _link(t: String, cb: Callable) -> Button:
	var b = Button.new(); b.text = t; b.flat = true; b.focus_mode = Control.FOCUS_NONE; b.custom_minimum_size.y = 38
	b.add_theme_font_override("font", UIKit.font("sans", 700)); b.add_theme_font_size_override("font_size", 15)
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#8a3a1e"))
	b.pressed.connect(func():
		if busy: return
		_snd("click"); cb.call())
	_body.add_child(b); _btns.append(b); return b

func _snd(n: String) -> void:
	var s = get_node_or_null("/root/Snd")
	if s != null and s.has_method("play"): s.call("play", n)

func err(t: String) -> void:
	if _err: _err.text = t; _err.visible = t != ""

func _busy(on: bool, t := "連線中…") -> void:
	busy = on
	for b in _btns:
		if is_instance_valid(b): (b as BaseButton).disabled = on
	if _err == null: return
	if on:
		_err.text = t; _err.visible = true; _err.add_theme_color_override("font_color", C_DIM)
	else:
		_err.add_theme_color_override("font_color", C_RED); _err.visible = false; _err.text = ""

func _err_label() -> void:
	_err = UIKit.label("", 14, C_RED, "sans", 700); _err.name = "Err"; _err.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; _err.visible = false; _body.add_child(_err)

# ---------------- 各模式 ----------------
func show_mode(md: String) -> void:
	mode = md; _clear()
	match md:
		"login": _m_login()
		"register": _m_register()
		"verify": _m_verify()
		"forgot": _m_forgot()
	if ACC.is_mock(): _txt("（測試模式：帳號只存在這部裝置，正式後端未接上）", 11, Color(C_DIM, 0.8))
	call_deferred("_fit")

func _local_note() -> void:
	var ls = ACC._ls()
	if ls is Dictionary and ls.has(ACC.SAVE_KEY):
		var s = ACC.summary(str(ls[ACC.SAVE_KEY]))
		if int(s.lv) > 0:
			var n = _txt("這部裝置已經有進度（%s主公 %d 級）。登入或註冊後會自動綁定到帳號，不會丟失。" % [(str(s.name) + "・") if str(s.name) != "" else "", int(s.lv)], 13, Color("#2e5d55"))
			n.name = "LocalNote"

func _m_login() -> void:
	_title.text = "登入帳號"
	_txt("登入後，進度會綁定你的郵箱。換手機、重裝遊戲，登入同一個帳號就能接著玩。", 14, C_DIM)
	_local_note()
	f_email = _field("郵箱"); f_email.name = "Email"; f_email.text = pend_email
	f_pw = _field("密碼", true); f_pw.name = "Pw"
	_err_label()
	btn_main = _btn("登入", "gold", _do_login); btn_main.name = "BtnLogin"
	var hb = HBoxContainer.new(); _body.add_child(hb)
	var a = _link("忘記密碼？", func(): pend_email = f_email.text; show_mode("forgot")); a.name = "LinkForgot"; _body.remove_child(a); hb.add_child(a)
	var sp = Control.new(); sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(sp)
	var b = _link("沒有帳號？註冊", func(): pend_email = f_email.text; show_mode("register")); b.name = "LinkRegister"; _body.remove_child(b); hb.add_child(b)

func _m_register() -> void:
	_title.text = "註冊帳號"
	_txt("用郵箱註冊。之後進度跟帳號走，不怕換機。", 14, C_DIM)
	_local_note()
	f_email = _field("郵箱"); f_email.name = "Email"; f_email.text = pend_email
	f_pw = _field("密碼（至少 %d 個字元）" % AC.MIN_PW, true); f_pw.name = "Pw"
	f_pw2 = _field("再輸入一次密碼", true); f_pw2.name = "Pw2"
	_err_label()
	btn_main = _btn("註冊", "gold", _do_register); btn_main.name = "BtnRegister"
	var b = _link("已經有帳號？登入", func(): pend_email = f_email.text; show_mode("login")); b.name = "LinkLogin"

func _m_verify() -> void:
	_title.text = "驗證郵箱"
	_txt("驗證郵件已經寄到：", 15, C_TXT)
	var e = _txt(pend_email, 18, Color("#8a3a1e")); e.add_theme_font_override("font", UIKit.font("sans", 900))
	_txt("打開郵件，點裡面的連結。完成後回來按「我已驗證，登入」。\n收不到？看看垃圾郵件，或者重寄一次。", 14, C_DIM)
	_err_label()
	btn_main = _btn("我已驗證，登入", "gold", func(): _sign_in(pend_email, pend_pw)); btn_main.name = "BtnVerified"
	_btn("重寄驗證郵件", "", func():
		_busy(true); var r = await ACC.resend(pend_email, pend_pw); _busy(false)
		if r.ok: err(""); _txt("已經重寄。", 13, Color("#2e5d55"))
		else: err(ACC.msg(str(r.err))))
	if ACC.is_mock():
		var mb = _btn("（測試）模擬已點擊驗證連結", "ghost", func():
			load("res://game/account/svc_mock.gd").mock_verify(pend_email); err(""); _txt("模擬：郵箱已驗證。", 13, Color("#2e5d55")))
		mb.name = "BtnMockVerify"
	_link("改用其他郵箱", func(): show_mode("register"))

func _m_forgot() -> void:
	_title.text = "忘記密碼"
	_txt("輸入註冊時的郵箱，我們會寄一封重設密碼的郵件給你。", 14, C_DIM)
	f_email = _field("郵箱"); f_email.name = "Email"; f_email.text = pend_email
	_err_label()
	btn_main = _btn("寄重設密碼郵件", "gold", func():
		_busy(true); var r = await ACC.recover(f_email.text); _busy(false)
		if r.ok: pend_email = f_email.text; err(""); _txt("已寄出。按郵件裡的連結重設密碼，再回來登入。", 14, Color("#2e5d55"))
		else: err(ACC.msg(str(r.err))))
	btn_main.name = "BtnRecover"
	_link("返回登入", func(): pend_email = f_email.text; show_mode("login"))

# ---------------- 動作 ----------------
func _do_login() -> void:
	await _sign_in(f_email.text, f_pw.text)

func _do_register() -> void:
	var e = f_email.text.strip_edges(); var p = f_pw.text
	if not ACC.ok_email(e.to_lower()): err(ACC.msg("bad_email")); return
	if p.length() < AC.MIN_PW: err(ACC.msg("weak_pw")); return
	if p != f_pw2.text: err(ACC.msg("mismatch")); return
	_busy(true)
	var r = await ACC.sign_up(e, p)
	_busy(false)
	if not r.ok: err(ACC.msg(str(r.err))); return
	pend_email = e.to_lower(); pend_pw = p
	if bool(r.get("need_verify", false)): show_mode("verify"); return
	await _after_login()

func _sign_in(e: String, p: String) -> void:
	if e.strip_edges() == "" or p == "": err("請輸入郵箱和密碼。"); return
	_busy(true)
	var r = await ACC.sign_in(e, p)
	_busy(false)
	if not r.ok:
		if str(r.err) == "unverified": pend_email = e.strip_edges().to_lower(); pend_pw = p; show_mode("verify"); err(ACC.msg("unverified")); return
		err(ACC.msg(str(r.err))); return
	await _after_login()

# 登入成功 → 同步：舊進度綁定／下載／衝突
func _after_login() -> void:
	_busy(true, "同步進度中…")
	var r = await ACC.sync()
	_busy(false)
	var st = str(r.get("state", ""))
	if st == "download":
		ACC.apply_cloud(str(r.data), int(r.rev)); return   # 重新載入 → 標題畫面
	if st == "conflict":
		var sd = load("res://ui/account/sync_dialog.gd").new(); sd.info = r
		sd.on_done = func(c): if c == "local": _finish()
		add_child(sd); return
	_finish()

func _finish() -> void:
	if host != null and host.has_method("show_toast"): host.call("show_toast", "已登入：" + ACC.email)
	var cb = on_done
	queue_free()
	if cb.is_valid(): cb.call()
