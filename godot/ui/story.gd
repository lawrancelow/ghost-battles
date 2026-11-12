# 劇情播放器（移植 game.js Story）：talk（舞台＋對話框）、sys（陰司 KPI 系統視窗）；其他樣式暫時用旁白框
extends Control

var q: Array = []
var cur = null
var li = 0
var typing = false
var shown = 0
var full_text = ""
var type_acc = 0.0
var actors: Array = []

var stage: Control
var talkbox: Panel
var nm: Label
var tx: Label
var pt: TextureRect
var syswin: Panel
var sysbody: VBoxContainer
var sysscroll: ScrollContainer
var tap_hint: Label
var cur_line_label: Label

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	G.story_busy = func() -> bool: return busy()
	G.story_req.connect(queue)

func busy() -> bool: return cur != null or q.size() > 0

func queue(sc, cb: Callable = Callable()) -> void:
	q.append({"sc": sc, "cb": cb})
	if cur == null: next()

func next() -> void:
	if cur != null and cur.cb.is_valid():
		var f: Callable = cur.cb; cur.cb = Callable(); f.call()
	if q.is_empty():
		cur = null; visible = false; _clear(); G.refreshed.emit(); G.quest_check(); G.save(); return
	var it: Dictionary = q.pop_front()
	var sc = it.sc
	if sc is String:
		G.S.seen[sc] = true
		sc = DB.D.SCENES.get(sc)
		if sc == null: next(); return
	cur = {"sc": sc, "cb": it.cb, "id": it.sc if it.sc is String else ""}
	li = 0; visible = true
	_build(sc)
	if wa != null: return
	_show_line()

func _clear() -> void:
	for c in get_children(): c.queue_free()
	stage = null; talkbox = null; syswin = null; wa = null

var wa: WA = null

func _build(sc: Dictionary) -> void:
	_clear()
	var dim = ColorRect.new(); dim.color = Color(0.04, 0.03, 0.05, 0.72); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dim.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(dim)
	var style: String = sc.get("style", "talk")
	if style == "chat":
		dim.color = Color(0, 0, 0, 1)
		wa = WA.new(); add_child(wa)
		wa.start_scene(sc, str(cur.id), func(): next(), func(): skip_scene())
		return
	if style == "talk":
		stage = Control.new(); stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stage.set_script(load("res://ui/story_stage.gd")); add_child(stage)
		actors = []
		for l in sc.lines:
			var who: String = l[0]
			if DB.D.SPEAKER_ART.has(who) and who != "黑白無常" and not actors.has(who): actors.append(who)
		actors = actors.slice(0, 6)
		stage.set("player", self)
		talkbox = Panel.new()
		var s = UIKit.sb(UIKit.PAPER, 2, UIKit.PAPERLINE, 1); s.shadow_color = Color(0, 0, 0, 0.6); s.shadow_size = 12
		talkbox.add_theme_stylebox_override("panel", s)
		talkbox.anchor_left = 0; talkbox.anchor_right = 1; talkbox.anchor_top = 1; talkbox.anchor_bottom = 1
		talkbox.offset_left = 8; talkbox.offset_right = -8; talkbox.offset_top = -168; talkbox.offset_bottom = -14
		talkbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(talkbox)
		pt = TextureRect.new(); pt.position = Vector2(8, 22); pt.size = Vector2(92, 92); pt.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pt.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		talkbox.add_child(pt)
		var nmp = PanelContainer.new(); nmp.add_theme_stylebox_override("panel", UIKit.sb(UIKit.CINNABAR, 2, Color("#f0c8b4"), 1, Vector4(12, 3, 12, 3)))
		nmp.position = Vector2(108, -15); talkbox.add_child(nmp)
		nm = UIKit.label("", 16, Color("#fff3e0"), "serif", 900); nmp.add_child(nm)
		tx = UIKit.label("", 18, UIKit.INKTXT); tx.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		tx.position = Vector2(108, 24); tx.size = Vector2(250, 120); tx.anchor_right = 1; tx.offset_right = -14
		talkbox.add_child(tx)
	else:
		syswin = Panel.new()
		var ss = UIKit.sb(Color(0.016, 0.118, 0.11, 0.94), 6, Color("#6ff0d0"), 2); ss.shadow_color = Color(0.43, 0.94, 0.82, 0.3); ss.shadow_size = 24
		if style != "sys": ss = UIKit.sb(Color(0.08, 0.06, 0.09, 0.95), 4, Color("#8a6a4a"), 1)
		syswin.add_theme_stylebox_override("panel", ss)
		syswin.anchor_left = 0.05; syswin.anchor_right = 0.95; syswin.anchor_top = 0.5; syswin.anchor_bottom = 0.5; syswin.offset_top = -90; syswin.offset_bottom = 90
		syswin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(syswin)
		var hl = UIKit.label("陰司 KPI 系統" if style == "sys" else str(sc.get("title", "")), 18, Color("#6ff0d0") if style == "sys" else UIKit.GOLD2, "serif", 900)
		hl.position = Vector2(14, 10); syswin.add_child(hl)
		sysscroll = ScrollContainer.new(); sysscroll.anchor_right = 1; sysscroll.anchor_bottom = 1; sysscroll.offset_left = 14; sysscroll.offset_top = 44; sysscroll.offset_right = -14; sysscroll.offset_bottom = -14
		sysscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; sysscroll.mouse_filter = Control.MOUSE_FILTER_IGNORE
		syswin.add_child(sysscroll)
		sysbody = VBoxContainer.new(); sysbody.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sysbody.add_theme_constant_override("separation", 10)
		sysscroll.add_child(sysbody)
		tap_hint = UIKit.label("點擊繼續", 13, Color(1, 1, 1, 0.55)); tap_hint.position = Vector2(0, 0); tap_hint.size = Vector2(390, 20); tap_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(tap_hint)
	var sk = UIKit.btn("跳過 ▸▸", "ghost", true); sk.anchor_left = 1; sk.anchor_right = 1; sk.offset_left = -96; sk.offset_top = 10; sk.offset_right = -10
	sk.add_theme_color_override("font_color", Color("#e8dcc0"))
	sk.pressed.connect(skip_scene); add_child(sk)

func _show_line() -> void:
	var sc: Dictionary = cur.sc
	var ln: Array = sc.lines[li]; var who: String = ln[0]; var text: String = DB.L(str(ln[1]))
	full_text = text; shown = 0; typing = true; type_acc = 0.0
	if talkbox != null:
		nm.get_parent().visible = who != "旁白"; nm.text = who
		var art = "sys" if who == "系統" else DB.D.SPEAKER_ART.get(who)
		pt.visible = art != null
		if art != null and art != "sys":
			var r = Art.portrait_region(art)
			if r.size(): var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; pt.texture = at
		elif art == "sys": pt.texture = null
		tx.add_theme_color_override("font_color", UIKit.INKDIM if who == "旁白" else UIKit.INKTXT)
		cur_line_label = tx; tx.text = ""
		if stage: stage.queue_redraw()
	else:
		var row = UIKit.rich("", 16, Color("#d8fff4") if sc.get("style") == "sys" else Color("#f0e2c8"))
		var pre = ""
		if sc.get("style") == "sys": pre = "[b][color=#6ff0d0]【系統】[/color][/b]" if who == "系統" else ("" if who == "旁白" else "[b]%s：[/b]" % who)
		else: pre = "" if who == "旁白" or who == "內文" else "[b]%s：[/b]" % who
		row.set_meta("pre", pre); sysbody.add_child(row)
		cur_line_label = null; _sysrow = row
		if who == "旁白": row.add_theme_color_override("default_color", Color("#c8c0b0"))

var _sysrow: RichTextLabel

func _process(dt: float) -> void:
	if cur == null or not typing: return
	type_acc += dt
	while type_acc >= 0.028 and shown < full_text.length():
		type_acc -= 0.028; shown += 1
	_render_text()
	if shown >= full_text.length(): typing = false

func _render_text() -> void:
	var s = full_text.substr(0, shown)
	if cur_line_label: cur_line_label.text = s
	elif _sysrow:
		_sysrow.text = str(_sysrow.get_meta("pre", "")) + s.replace("[", "[lb]")
		await get_tree().process_frame
		if sysscroll == null or syswin == null: return
		var want = minf(sysbody.size.y + 58, size.y * 0.6 + 58)
		syswin.offset_top = -want / 2; syswin.offset_bottom = want / 2
		tap_hint.position.y = size.y / 2 + want / 2 + 14
		sysscroll.scroll_vertical = int(sysscroll.get_v_scroll_bar().max_value)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: advance()

func advance() -> void:
	if cur == null: return
	if wa != null: wa.advance(false); return
	if typing: shown = full_text.length(); _render_text(); typing = false; return
	li += 1
	if li >= cur.sc.lines.size(): next(); return
	_show_line()

func skip_scene() -> void:
	typing = false; next()

func speaker() -> String:
	if wa != null: return ""
	if cur == null or li >= cur.sc.lines.size(): return ""
	return cur.sc.lines[li][0]
