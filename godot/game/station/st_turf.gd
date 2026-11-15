# 陽間站崗・地盤場景（原生外殼）
#  - 規則／路人 AI／設備／Bryan 一夥：照用 street.js Turf（tick、enter、pickRole……），數值一模一樣，存檔互通
#  - 畫面：JS frame() 只做 tick；原生喺 _draw 直接叫 Turf.draw()／drawUlt()／drawMy()（Ctx 直接畫落節點，唔經錄製器）
#    JS 每推進一格（約 30fps）先重畫一次，draw() 入面嗰啲「每幀 1/30」嘅計時先唔會快過網頁版
#  - 介面：頂欄、右邊掣、進入掣、名氣條、資訊列全部原生；DOM 收起（以前每幀 hud() 改 innerHTML → 成頁重新排版）
#  - 揀設備（#stt-pick）、龐總提示（#pol-tip）仍然用 DOM：出現時先開返 DOM
#  - 提示框（#gp-warn／#sq-warn／#sq-post）用原生框顯示，撳一下收起
class_name StTurf
extends Control

static var cur: StTurf = null

var Tf: Dictionary
var stage: Control
var top: Control
var name_l: Label
var lv_r: RichTextLabel
var coin_l: Label
var info_r: RichTextLabel
var hot_fill: ColorRect
var hot_bg: Panel
var enter_b: Button
var enter_q: Label
var sp_b: Button
var box_b: Button
var zin_b: Button
var build_b: Button
var note: PanelContainer
var note_r: RichTextLabel
var note_back: Button
var _note_id := ""
var _hidden: Array = []
var _modal := false
var _fno := -1
var _drag = null
var _touch := {}
var _pinch = null
var _sig := {}

static func js(n: String): return J.G.get(n)
static func T(y: String, z: String) -> String: return y if DB.lang == "yue" else z

static func hook(tf) -> bool:
	if not (tf is Dictionary): return false
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if cur != null and is_instance_valid(cur): cur._end()
	StFast.install(tf)   # 熱點小函數換原生
	var r = StTurf.new(); r.name = "StTurf"; r.Tf = tf
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())
	cur = r
	r._build(); r._cover(true)
	r.stage.size = main.size; r._sync_vw()
	return true

static func end_hook(_tf) -> void:
	if cur != null and is_instance_valid(cur): cur._end()
	cur = null

func _end() -> void:
	name = "StTurf_closing"
	_cover(false); queue_free()
	if cur == self: cur = null

func _el(sel: String):
	var f = js("$")
	return J.cl(f, null, [sel]) if f != null else null

func _cover(on: bool) -> void:
	var main = get_parent()
	if main == null: return
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and n.visible:
				n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
		# DOM 入面嘅 #st-turf：只留低彈出框（揀設備等），畫布同 HUD 收埋
		var root = _el("#st-turf")
		if root: root.style["background"] = "transparent"
		for id in ["#stt-cv", ".stt-top", "#stt-enter", "#stt-next", "#stt-sp", "#stt-box", ".stt-zoom", "#stt-build", ".stt-hot", "#stt-info"]:
			var e = _el(id)
			if e: e.style["display"] = "none"
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true; n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()

# ---------------- 版面 ----------------
func _sb(bg: Color, r: int, bd: Color, bw := 2, pad := Vector4(8, 4, 8, 4)) -> StyleBoxFlat:
	var s = UIKit.sb(bg, r, bd, bw, pad); return s

func _mk_btn(t: String, bg: Color, bd: Color, fg: Color, fs := 13, r := 12) -> Button:
	var b = Button.new(); b.text = t; b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", fs)
	var s = _sb(bg, r, bd, 2, Vector4(6, 3, 6, 3))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fg)
	b.focus_mode = Control.FOCUS_NONE
	return b

func _rich(fs: int, col: Color) -> RichTextLabel:
	var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false
	r.add_theme_font_size_override("normal_font_size", fs); r.add_theme_font_size_override("bold_font_size", fs)
	r.add_theme_font_override("bold_font", UIKit.font("sans", 900)); r.add_theme_color_override("default_color", col)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage = Control.new(); stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); stage.clip_contents = true; stage.mouse_filter = Control.MOUSE_FILTER_STOP
	stage.draw.connect(_draw_stage); stage.gui_input.connect(_stage_input); add_child(stage)
	stage.resized.connect(func(): if J.t(Tf.get("on")): J.mc(Tf, "resize", []))
	var def = Tf.get("def")
	# 頂欄（照 .stt-top：漸變底、返街、名＋等級、本關冥幣）
	top = Control.new(); top.anchor_right = 1; top.offset_bottom = 66; top.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(top)
	var tg = TextureRect.new(); tg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); tg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var gr = Gradient.new(); gr.set_color(0, Color(0.03, 0.03, 0.047, 0.88)); gr.set_color(1, Color(0.03, 0.03, 0.047, 0.55))
	var gt = GradientTexture2D.new(); gt.gradient = gr; gt.fill_from = Vector2(0, 0); gt.fill_to = Vector2(0, 1); gt.width = 4; gt.height = 32; tg.texture = gt; tg.stretch_mode = TextureRect.STRETCH_SCALE; tg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	top.add_child(tg)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); hb.anchor_right = 1; hb.anchor_bottom = 1; hb.offset_left = 10; hb.offset_right = -10; hb.offset_top = 8; hb.offset_bottom = -4; top.add_child(hb)
	var back = _mk_btn("◀ " + T("返街", "回街上"), Color("#6e1414"), Color("#2a0b0b"), Color("#f1e6d6"), 14)
	back.size_flags_vertical = Control.SIZE_SHRINK_CENTER; back.custom_minimum_size = Vector2(0, 34)
	back.pressed.connect(func(): J.mc(Tf, "close", [])); hb.add_child(back)
	var nb = VBoxContainer.new(); nb.add_theme_constant_override("separation", 0); nb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(nb)
	name_l = UIKit.label(T(J.str(def.n), J.str(def.zh)), 15, Color("#e6dfd2"), "sans", 900); name_l.add_theme_constant_override("outline_size", 3); name_l.add_theme_color_override("font_outline_color", Color.BLACK)
	nb.add_child(name_l)
	lv_r = _rich(10, Color(0.9, 0.87, 0.8, 0.9)); nb.add_child(lv_r)
	coin_l = Label.new(); coin_l.add_theme_font_size_override("font_size", 13); coin_l.add_theme_color_override("font_color", Color("#e6dfd2"))
	var cp = PanelContainer.new(); cp.add_theme_stylebox_override("panel", _sb(Color(0.08, 0.086, 0.094, 0.75), 10, Color("#3a2a2a"), 1, Vector4(9, 3, 9, 3))); cp.add_child(coin_l); cp.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	cp.name = "coin"; hb.add_child(cp)
	# 右邊：放大、建造、有名鬼、驚嚇盒（照 CSS 位置）
	zin_b = _mk_btn("🔍", Color(0.08, 0.086, 0.094, 0.85), Color("#4a1d1d"), Color("#e6dfd2"), 17, 19)
	_put(zin_b, Vector2(-48, 76), Vector2(38, 38)); zin_b.pressed.connect(func(): _fire("#stt-zin"))
	build_b = _mk_btn(T("建造", "建造"), Color(0.08, 0.086, 0.094, 0.9), Color("#6a5a40"), Color("#ffe9b0"), 13, 12)
	_put(build_b, Vector2(-58, 122), Vector2(48, 48)); build_b.pressed.connect(func(): _fire("#stt-build"))
	sp_b = _mk_btn("", Color(0.08, 0.086, 0.094, 0.9), Color("#5c1a1a"), Color("#cdbfe0"), 11, 12)
	_put(sp_b, Vector2(-156, 76), Vector2(98, 44)); sp_b.pressed.connect(func(): J.mc(Tf, "specialPick", []))
	box_b = _mk_btn("", Color(0.08, 0.086, 0.094, 0.9), Color("#5c1a1a"), Color("#e8b8b8"), 11, 12)
	_put(box_b, Vector2(-124, 128), Vector2(66, 40)); box_b.pressed.connect(func(): J.mc(Tf, "useBox", []))
	# 進入掣（右下）
	enter_b = _mk_btn("", Color("#2a1c10"), Color("#6a5a40"), Color("#ffe9b0"), 14, 16)
	enter_b.anchor_left = 1; enter_b.anchor_right = 1; enter_b.anchor_top = 1; enter_b.anchor_bottom = 1
	enter_b.offset_left = -108; enter_b.offset_right = -12; enter_b.offset_top = -186; enter_b.offset_bottom = -106; add_child(enter_b)
	var ev = VBoxContainer.new(); ev.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ev.alignment = BoxContainer.ALIGNMENT_CENTER; ev.mouse_filter = Control.MOUSE_FILTER_IGNORE; enter_b.add_child(ev)
	var e1 = UIKit.label("▲", 22, Color("#ffe9b0"), "sans", 900); e1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; ev.add_child(e1)
	var e2 = UIKit.label(T("進入", "進入"), 14, Color("#ffe9b0"), "sans", 900); e2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; ev.add_child(e2)
	enter_q = UIKit.label("", 10, Color("#ffe9b0"), "sans", 700); enter_q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; ev.add_child(enter_q)
	for c in ev.get_children(): c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	enter_b.pressed.connect(func(): J.mc(Tf, "enter", [true]))
	# 名氣條＋資訊
	hot_bg = Panel.new(); hot_bg.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 1, 1, 0.12), 5)); hot_bg.clip_contents = true; hot_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hot_bg.anchor_right = 1; hot_bg.anchor_top = 1; hot_bg.anchor_bottom = 1; hot_bg.offset_left = 14; hot_bg.offset_right = -14; hot_bg.offset_top = -72; hot_bg.offset_bottom = -62; add_child(hot_bg)
	hot_fill = ColorRect.new(); hot_fill.anchor_bottom = 1; hot_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE; hot_bg.add_child(hot_fill)
	var mid = ColorRect.new(); mid.color = Color("#f8e8c4"); mid.anchor_left = 0.5; mid.anchor_right = 0.5; mid.anchor_bottom = 1; mid.offset_right = 2; mid.mouse_filter = Control.MOUSE_FILTER_IGNORE; hot_bg.add_child(mid)
	info_r = _rich(12, Color("#e6dfd2"))
	info_r.anchor_right = 1; info_r.anchor_top = 1; info_r.anchor_bottom = 1; info_r.offset_left = 8; info_r.offset_right = -8; info_r.offset_top = -58; info_r.offset_bottom = -6; add_child(info_r)
	# 提示框（gp-warn / sq-warn / sq-post）
	note = PanelContainer.new(); note.visible = false; note.mouse_filter = Control.MOUSE_FILTER_STOP
	note.add_theme_stylebox_override("panel", _sb(Color(0.07, 0.06, 0.07, 0.95), 12, Color("#8a5a3a"), 2, Vector4(12, 10, 12, 10)))
	note.anchor_left = 0.5; note.anchor_right = 0.5; note.offset_left = -170; note.offset_right = 170; note.offset_top = 182; add_child(note)
	var nv = VBoxContainer.new(); nv.add_theme_constant_override("separation", 8); note.add_child(nv)
	note_r = _rich(13, Color("#efe4cf")); note_r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; nv.add_child(note_r)
	note_back = _mk_btn(T("返村升級", "回村升級"), Color("#6e1414"), Color("#2a0b0b"), Color("#f1e6d6"), 13, 10); note_back.visible = false; nv.add_child(note_back)
	note_back.pressed.connect(func():
		var GP = js("GP"); _note_close()
		if GP != null: J.mc(GP, "goVillage", []))
	note.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: _note_close())

func _put(b: Control, off: Vector2, sz: Vector2) -> void:
	b.anchor_left = 1; b.anchor_right = 1
	b.offset_left = off.x; b.offset_top = off.y; b.offset_right = off.x + sz.x; b.offset_bottom = off.y + sz.y
	add_child(b)

# street.js 用 innerWidth／innerHeight 計畫面；DOM 收埋咗就唔會更新，自己同步做舞台大小
func _sync_vw() -> void:
	var w = stage.size.x; var h = stage.size.y
	if w > 0 and h > 0 and (J.num(J.G.get("innerWidth", 0)) != w or J.num(J.G.get("innerHeight", 0)) != h):
		# 轉譯版嘅裸 innerWidth 讀 J.G["innerWidth"]（唔經 window 物件）
		J.G["__vw"] = w; J.G["__vh"] = h; J.G["innerWidth"] = w; J.G["innerHeight"] = h; J.mc(Tf, "resize", [])

# DOM 掣嘅 onclick（例如放大、建造）照叫返 JS，邏輯唔使抄
func _fire(sel: String) -> void:
	var e = _el(sel)
	if e == null: return
	var f = J.gp(e, "onclick")
	if f != null: J.cl(f, e, [{"preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}])
	_sig.clear()

# ---------------- 每幀 ----------------
func _process(_dt: float) -> void:
	if not J.t(Tf.get("on")): return
	_sync_vw()
	var fno = int(J.num(Tf.get("_fno", 0)))
	if fno != _fno: _fno = fno; stage.queue_redraw()
	if fno % 6 == 1 or _sig.is_empty(): _hud()
	_check_modal()
	_check_note()

func _set_rich(k: String, r: RichTextLabel, html: String) -> void:
	if _sig.get(k) == html: return
	_sig[k] = html; r.text = _bb(html)

static func _bb(h: String) -> String:
	var s = h
	var rx = RegEx.create_from_string("<b style=\"color:([^\";]+)[^\"]*\">([^<]*)</b>"); s = rx.sub(s, "[color=$1][b]$2[/b][/color]", true)
	rx = RegEx.create_from_string("<span[^>]*>"); s = rx.sub(s, "[bgcolor=#14161880] ", true)
	s = s.replace("</span>", " [/bgcolor] ")
	return JSBridge.html2bb(s)

func _hud() -> void:
	var lv = _el("#stt-lv"); var coin = _el("#stt-coin"); var info = _el("#stt-info"); var bar = _el("#stt-hotbar")
	if lv: _set_rich("lv", lv_r, J.str(lv.innerHTML))
	if coin: var ct = J.str(coin.textContent); if coin_l.text != ct: coin_l.text = ct
	if info: _set_rich("info", info_r, J.str(info.innerHTML))
	if bar:
		var w = J.str(bar.style.get("width", "0%")).trim_suffix("%").to_float() / 100.0
		var l = J.str(bar.style.get("left", "50%")).trim_suffix("%").to_float() / 100.0
		hot_fill.anchor_left = l; hot_fill.anchor_right = clampf(l + w, 0, 1); hot_fill.offset_left = 0; hot_fill.offset_right = 0
		hot_fill.color = Color("#5a6f7a") if J.str(bar.get("className")) == "down" else Color("#b3261e").lerp(Color("#3f7a66"), 0.35)
	var q = _el("#stt-q"); if q: var qt = J.str(q.textContent); if enter_q.text != qt: enter_q.text = qt
	var en = _el("#stt-enter")
	if en:
		var ready = (" " + J.str(en.get("className")) + " ").contains(" autoon ")
		if _sig.get("ready") != ready:
			_sig["ready"] = ready
			var s = _sb(Color("#7a3a12") if ready else Color("#2a1c10"), 16, Color("#ffd45a") if ready else Color("#6a5a40"), 3)
			for k in ["normal", "hover", "pressed"]: enter_b.add_theme_stylebox_override(k, s)
		if ready: enter_b.modulate = Color(1, 1, 1, 0.85 + 0.15 * sin(Time.get_ticks_msec() / 190.0))
		else: enter_b.modulate = Color.WHITE
	var spb = _el("#stt-sp"); if spb: var t1 = _plain(J.str(spb.innerHTML)); if sp_b.text != t1: sp_b.text = t1
	var bx = _el("#stt-box"); if bx: var t2 = _plain(J.str(bx.innerHTML)); if box_b.text != t2: box_b.text = t2
	var bb = _el("#stt-build"); if bb: var t3 = J.str(bb.textContent); if build_b.text != t3: build_b.text = t3
	var on = J.t(Tf.get("buildMode"))
	if _sig.get("bm") != on:
		_sig["bm"] = on
		var s2 = _sb(Color(0.08, 0.086, 0.094, 0.9), 12, Color("#ffd45a") if on else Color("#6a5a40"), 2)
		for k in ["normal", "hover", "pressed"]: build_b.add_theme_stylebox_override(k, s2)
	# 金幣粒子飛去冥幣框
	var cpn = top.get_node_or_null("HBoxContainer/coin")
	if cpn: Tf["_natCoin"] = {"left": cpn.global_position.x, "top": cpn.global_position.y, "width": cpn.size.x, "height": cpn.size.y}

static func _plain(h: String) -> String:
	return JSBridge.html2bb(h).replace("[b]", "").replace("[/b]", "").replace("[i]", "").replace("[/i]", "")

# 揀設備等全屏彈出框（DOM）：開咗先顯示 DOM
var pick_panel: StDomPanel = null
var post_panel: StDomPanel = null
func _check_modal() -> void:
	# 揀設備／有名鬼：原生（讀 DOM El 樹砌控件，掣照叫 JS onclick）；GB_PICKDOM=1 用返 DOM
	var pk = _el("#stt-pick")
	if pk != null and not OS.has_environment("GB_PICKDOM"):
		if pick_panel == null or not is_instance_valid(pick_panel) or pick_panel.el != pk:
			if pick_panel != null and is_instance_valid(pick_panel): pick_panel.queue_free()
			pick_panel = StDomPanel.new(); add_child(pick_panel); pick_panel.setup(pk, Tf, "pick")
		pk = null
	var on = pk != null or _el("#pol-tip") != null
	if on == _modal: return
	_modal = on
	var dom = get_parent().get("dom")
	if dom:
		dom.visible = on; dom.process_mode = Node.PROCESS_MODE_INHERIT if on else Node.PROCESS_MODE_DISABLED
	_sig.clear()

func _check_note() -> void:
	var id = ""; var e = null
	# 網紅組帖文：原生（頭像、截圖、like 數跟 JS 跳）
	var sp = _el("#sq-post")
	if sp != null and not OS.has_environment("GB_PICKDOM"):
		if post_panel == null or not is_instance_valid(post_panel) or post_panel.el != sp:
			if post_panel != null and is_instance_valid(post_panel): post_panel.queue_free()
			post_panel = StDomPanel.new(); add_child(post_panel); post_panel.setup(sp, Tf, "post")
	for k in ["#gp-warn", "#sq-warn"] + ([] if sp != null and not OS.has_environment("GB_PICKDOM") else ["#sq-post"]):
		e = _el(k)
		if e != null and not (" " + J.str(e.get("className")) + " ").contains(" out "): id = k; break
	if id == "":
		if note.visible: note.visible = false; _note_id = ""
		return
	var html = J.str(e.innerHTML)
	if id == _note_id and _sig.get("note") == html: return
	_note_id = id; _sig["note"] = html
	html = RegEx.create_from_string("<button[^>]*>[^<]*</button>").sub(html, "", true)
	html = RegEx.create_from_string("<canvas[^>]*>(</canvas>)?|<img[^>]*>").sub(html, "", true)
	note_r.text = "[center]" + _bb(html) + "[/center]"
	note_back.visible = id == "#gp-warn" and J.str(e.innerHTML).contains("gp-back")
	note.visible = true
	note.offset_bottom = note.offset_top
	note.reset_size()

func _note_close() -> void:
	var e = _el(_note_id) if _note_id != "" else null
	if e != null: J.mc(e, "remove", [])
	note.visible = false; _note_id = ""

# ---------------- 畫面 ----------------
var _wrapped := false
var _dc_us := 0
var _dc_n := 0
var prof_d := 0
var prof_n := 0
func _draw_stage() -> void:
	if not J.t(Tf.get("on")): return
	if OS.has_environment("GB_NODRAW"): return
	var ctx = Ctx.new(stage)
	var keep = Tf.get("c")
	Tf["c"] = ctx
	if OS.has_environment("GB_SUBPROF") and not _wrapped:
		_wrapped = true; var orig = J.G.get("__nat_drawChar")
		J.G["__nat_drawChar"] = func(_t, a): var q0 = Time.get_ticks_usec(); var r = orig.call(_t, a); _dc_us += Time.get_ticks_usec() - q0; _dc_n += 1; return r
	_dc_us = 0; _dc_n = 0
	var t0 = Time.get_ticks_usec()
	var cp = OS.has_environment("GB_CTXPROF") and prof_n == 20 and _fno > 150
	if cp: J.CTXPROF.clear(); J.CTXPROF_ON = true
	if OS.has_environment("GB_JSDRAW"): J.mc(Tf, "draw", [])
	else: StDraw.draw(ctx, Tf)   # 原生移植 Turf.draw()
	var t1 = Time.get_ticks_usec()
	if Tf.get("ult") != null: J.mc(Tf, "drawUlt", [])
	if OS.has_environment("GB_SUBPROF") and prof_n == 20 and _fno > 150:
		var out = []
		for m in ["drawLongBg", "drawProps", "drawTraces", "drawObsFx", "drawSpecial", "drawCaps"]:
			var a0 = Time.get_ticks_usec(); J.mc(Tf, m, []); out.append("%s=%.1f" % [m, (Time.get_ticks_usec() - a0) / 1000.0])
		print("[sub] drawChar=%.1fms(%d) " % [_dc_us / 1000.0, _dc_n], ", ".join(out))
	StHud.draw_my(stage, ctx, Tf)   # 原生重寫 drawMy（小地圖、建設度、收集罐、排隊、嚇人力）
	if cp:
		J.CTXPROF_ON = false; var ks = J.CTXPROF.keys().filter(func(k): return not k.begins_with("#"))
		ks.sort_custom(func(a, b): return J.CTXPROF[a] > J.CTXPROF[b])
		var tot = 0
		for k in ks: tot += J.CTXPROF[k]
		print("[ctx] total=%.1fms draw=%.1f my=%.1f " % [tot / 1000.0, (t1 - t0) / 1000.0, (Time.get_ticks_usec() - t1) / 1000.0], ", ".join(ks.slice(0, 14).map(func(k): return "%s %.1f(%d)" % [k, J.CTXPROF[k] / 1000.0, J.CTXPROF["#" + k]])))
	Tf["c"] = keep
	if OS.has_environment("GB_PROF"):
		prof_d += Time.get_ticks_usec() - t0; prof_n += 1
		if prof_n >= 30:
			print("[turf] draw=%.1fms js_timers=%.1fms" % [prof_d / 30000.0, JSRun.prof_timer / 30000.0]); JSRun.prof_timer = 0
			prof_d = 0; prof_n = 0

# ---------------- 輸入（照 bindInput：拖鏡頭、兩指縮放、撳一下＝tap） ----------------
func _stage_input(ev: InputEvent) -> void:
	var cam = Tf.get("cam"); var box = Tf.get("box")
	if not (cam is Dictionary) or not (box is Dictionary): return
	if ev is InputEventScreenTouch:
		if ev.pressed: _touch[ev.index] = ev.position
		else: _touch.erase(ev.index)
		if _touch.size() == 2:
			var ps = _touch.values(); _pinch = [ps[0].distance_to(ps[1]), J.num(cam.z)]
			if _drag != null: _drag.moved = true
		elif _touch.size() < 2: _pinch = null
		return
	if ev is InputEventScreenDrag:
		_touch[ev.index] = ev.position
		if _pinch != null and _touch.size() == 2:
			var ps = _touch.values(); var d = ps[0].distance_to(ps[1])
			cam.z = _pinch[1] * d / maxf(1.0, _pinch[0]); cam.user = Time.get_ticks_usec() / 1000.0; J.mc(Tf, "camClamp", [])
		return
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed:
			_drag = {"start": ev.position, "cx": J.num(cam.x), "cy": J.num(cam.y), "moved": false}
		else:
			if _drag != null and not _drag.moved and _pinch == null:
				J.mc(Tf, "tap", [{"clientX": ev.position.x, "clientY": ev.position.y}])
			_drag = null
	elif ev is InputEventMouseMotion and _drag != null and (ev.button_mask & MOUSE_BUTTON_MASK_LEFT):
		if _pinch != null: return
		var d: Vector2 = ev.position - _drag.start
		if d.length() > 8: _drag.moved = true
		if _drag.moved:
			var z = J.num(cam.z)
			cam.x = _drag.cx - d.x / (J.num(box.w) * z); cam.tx = cam.x
			cam.y = _drag.cy - d.y / (J.num(box.h) * z); cam.ty = cam.y
			cam.user = Time.get_ticks_usec() / 1000.0; J.mc(Tf, "camClamp", [])
	elif ev is InputEventMagnifyGesture:
		cam.z = J.num(cam.z) * ev.factor; cam.user = Time.get_ticks_usec() / 1000.0; J.mc(Tf, "camClamp", [])
