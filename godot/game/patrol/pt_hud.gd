# 夜班巡陰（原生）：介面——頂欄、小地圖、資源、訊息、設施／靈體不穩卡、底部掣、結算、全圖
class_name PtHud
extends Control

var run: PtRun
var top_bg: PtDraw
var quit_b: Button
var ttl: Label
var zone_l: Label
var clock_l: Label
var ph_l: Label
var mini: PtDraw
var res_l: RichTextLabel
var msg_p: PanelContainer
var msg_l: RichTextLabel
var msg_until := 0.0
var act_p: PanelContainer
var act_box: VBoxContainer
var down_p: PanelContainer
var down_bar: ColorRect
var down_bar_bg: ColorRect
var bar: HBoxContainer
var leads_box: HBoxContainer
var lead_btns := {}
var auto_b: Button
var pie_b: PtDraw
var dash_b: PtDraw
var joy_n: PtDraw
var end_p: Control
var map_p: Control
var fog_img: Image
var fog_tex: ImageTexture
var fog_ver := -1
var paper_sb: StyleBoxFlat
var fps_l: Label

const MINI_W := 132.0
const MINI_H := 90.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var safe_top = 0.0
	top_bg = PtDraw.new(); top_bg.fn = func(c):
		var w = size.x
		c.draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(w, 0), Vector2(w, 58), Vector2(0, 58)]), PackedColorArray([Color(20 / 255.0, 16 / 255.0, 26 / 255.0, 0.92), Color(20 / 255.0, 16 / 255.0, 26 / 255.0, 0.92), Color(20 / 255.0, 16 / 255.0, 26 / 255.0, 0), Color(20 / 255.0, 16 / 255.0, 26 / 255.0, 0)]))
	add_child(top_bg)
	quit_b = _ghost_btn("收工"); quit_b.position = Vector2(8, 7 + safe_top); quit_b.size = Vector2(48, 32); add_child(quit_b)
	var confirm = [0.0]
	quit_b.pressed.connect(func():
		if run.ended: return
		if Time.get_ticks_msec() - confirm[0] < 2500: run.end(false); return
		confirm[0] = Time.get_ticks_msec(); quit_b.text = "確定？"
		get_tree().create_timer(2.5).timeout.connect(func(): if is_instance_valid(quit_b): quit_b.text = "收工"))
	ttl = _lbl("", 15, Color("#f3e3c0"), "serif", 900); ttl.position = Vector2(64, 6); ttl.size = Vector2(130, 20); ttl.clip_text = true; ttl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; add_child(ttl)
	zone_l = _lbl("", 11.5, Color("#b8a8c8")); zone_l.position = Vector2(64, 24); zone_l.size = Vector2(130, 16); zone_l.clip_text = true; zone_l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; add_child(zone_l)
	clock_l = _lbl("", 16, Color("#ffe9a0"), "sans", 900); clock_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; clock_l.add_theme_font_override("font", SystemFont.new()); add_child(clock_l)
	ph_l = _lbl("", 11, Color("#c9b8ff")); ph_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; add_child(ph_l)
	var mini_hit = Control.new(); mini_hit.name = "mini_hit"; mini_hit.mouse_filter = Control.MOUSE_FILTER_STOP; mini_hit.clip_contents = true; add_child(mini_hit)
	mini = PtDraw.new(); mini.fn = _draw_mini; mini.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST; mini_hit.add_child(mini)
	mini_hit.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: open_map())
	res_l = UIKit.rich("", 11.5, Color("#dddddd")); res_l.position = Vector2(8, 98); res_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	res_l.add_theme_color_override("font_shadow_color", Color.BLACK); res_l.add_theme_constant_override("shadow_offset_y", 1); res_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(res_l)
	msg_p = PanelContainer.new(); var ms = UIKit.sb(Color(16 / 255.0, 12 / 255.0, 22 / 255.0, 0.86), 6, Color("#5a4a6a"), 1, Vector4(11, 7, 11, 7)); msg_p.add_theme_stylebox_override("panel", ms)
	msg_p.mouse_filter = Control.MOUSE_FILTER_IGNORE; msg_p.modulate.a = 0; add_child(msg_p)
	msg_l = UIKit.rich("", 13, Color("#f0e6ff")); msg_l.mouse_filter = Control.MOUSE_FILTER_IGNORE; msg_p.add_child(msg_l)
	act_p = PanelContainer.new(); act_p.add_theme_stylebox_override("panel", UIKit.sb(Color(18 / 255.0, 14 / 255.0, 24 / 255.0, 0.94), 10, Color("#5a4a6a"), 1, Vector4(11, 9, 11, 9))); act_p.visible = false; add_child(act_p)
	act_box = VBoxContainer.new(); act_box.add_theme_constant_override("separation", 6); act_p.add_child(act_box)
	paper_sb = UIKit.sb(UIKit.PAPER, 10, Color("#7a1a10"), 2, Vector4(11, 9, 11, 9)); paper_sb.shadow_color = Color(0, 0, 0, 0.6); paper_sb.shadow_size = 12
	down_p = PanelContainer.new(); down_p.add_theme_stylebox_override("panel", paper_sb); down_p.visible = false; add_child(down_p)
	# 底部
	leads_box = HBoxContainer.new(); leads_box.add_theme_constant_override("separation", 6); add_child(leads_box)
	auto_b = Button.new(); auto_b.add_theme_font_size_override("font_size", 11); auto_b.add_theme_font_override("font", UIKit.font("sans", 700))
	var ab = UIKit.sb(Color(20 / 255.0, 16 / 255.0, 28 / 255.0, 0.85), 6, Color("#4a3a5a"), 1, Vector4(7, 5, 7, 5))
	for s in ["normal", "hover", "pressed"]: auto_b.add_theme_stylebox_override(s, ab)
	auto_b.add_theme_stylebox_override("focus", StyleBoxEmpty.new()); auto_b.add_theme_color_override("font_color", Color("#cbb8ff")); auto_b.add_theme_color_override("font_hover_color", Color("#cbb8ff")); auto_b.add_theme_color_override("font_pressed_color", Color("#cbb8ff"))
	auto_b.button_down.connect(func(): var p = run.st(); p.autoSk = p.get("autoSk") == false; run.save(); update_hud())
	add_child(auto_b)
	pie_b = _round_btn("畫大餅", 58, false, func(): run.pie()); add_child(pie_b)
	dash_b = _round_btn("衝刺", 74, true, func(): run.dash()); add_child(dash_b)
	joy_n = PtDraw.new(); joy_n.fn = _draw_joy; add_child(joy_n)
	fps_l = _lbl("", 10, Color(1, 1, 1, 0.45)); fps_l.position = Vector2(8, 84); add_child(fps_l)
	resized.connect(_layout); _layout()

func _layout() -> void:
	var w = size.x; var h = size.y
	clock_l.position = Vector2(w - 138 - 8 - 70, 5); clock_l.size = Vector2(70, 18)
	ph_l.position = Vector2(w - 138 - 8 - 70, 23); ph_l.size = Vector2(70, 14)
	ttl.size.x = w - 64 - 138 - 8 - 76; zone_l.size.x = ttl.size.x
	var mh = get_node("mini_hit"); mh.position = Vector2(w - 8 - MINI_W, 6); mh.size = Vector2(MINI_W, MINI_H)
	res_l.size = Vector2(w - 16, 22)
	msg_p.position = Vector2(12, 124); msg_p.size = Vector2(w - 24, 0); msg_p.custom_minimum_size.x = w - 24
	act_p.custom_minimum_size.x = w - 20; down_p.custom_minimum_size.x = w - 20
	_place_bottom()
	dash_b.position = Vector2(w - 8 - 74, h - 10 - 74)
	pie_b.position = Vector2(w - 8 - 74 - 8 - 58, h - 10 - 58)
	auto_b.reset_size(); auto_b.position = Vector2(w - 8 - 74 - 8 - 58 - 8 - auto_b.size.x, h - 10 - 58 / 2.0 - auto_b.size.y / 2)
	leads_box.position = Vector2(8, h - 10 - 54)

func _place_bottom() -> void:
	var w = size.x; var h = size.y
	for p in [act_p, down_p]:
		p.reset_size(); p.size.x = w - 20; p.position = Vector2(10, h - 96 - p.size.y)

func _lbl(t: String, sz: float, col: Color, kind := "sans", wt := 400) -> Label:
	var l = UIKit.label(t, int(sz), col, kind, wt); l.mouse_filter = Control.MOUSE_FILTER_IGNORE; return l

func _ghost_btn(t: String) -> Button:
	var b = Button.new(); b.text = t; b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 13)
	var s = UIKit.sb(Color(0, 0, 0, 0.25), 4, Color("#cbbfa8"), 1, Vector4(8, 4, 8, 4))
	for k in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#e8dcc0"))
	return b

# 圓掣（畫大餅／衝刺）：按下即發（同網頁 pointerdown 一樣）
func _round_btn(label: String, d: float, big: bool, f: Callable) -> PtDraw:
	var n = PtDraw.new(); var st = {"cd": 0.0, "label": label, "d": d, "big": big}
	n.set_meta("st", st)
	n.fn = func(c):
		var r = d / 2.0; var cen = Vector2(r, r)
		var c0 = Color("#3a5a6a") if big else Color("#5a2a20"); var c1 = Color("#142630") if big else Color("#2a1410")
		c.draw_circle(cen + Vector2(0, 3), r, Color(0, 0, 0, 0.45))
		c.draw_texture_rect(PtGfx.RAD, Rect2(0, 0, d, d), false, c0)
		var pts = PackedVector2Array()
		for i in 49: pts.append(cen + Vector2(cos(TAU * i / 48), sin(TAU * i / 48)) * r)
		c.draw_colored_polygon(pts, c1); c.draw_texture_rect(PtGfx.RAD_SOFT, Rect2(0, 0, d, d), false, c0)
		if st.cd > 0:
			var hh = d * st.cd; var y0 = d - hh; var poly = PackedVector2Array()
			for i in 49:
				var p = cen + Vector2(cos(TAU * i / 48), sin(TAU * i / 48)) * r
				if p.y >= y0: poly.append(p)
				else: poly.append(Vector2(p.x, y0))
			c.draw_colored_polygon(poly, Color(0, 0, 0, 0.6))
		c.draw_arc(cen, r - 1, 0, TAU, 48, Color("#7dd3fc") if big else Color("#c8402c"), 2, true)
		var fnt = UIKit.font("serif", 900); var tw = fnt.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		c.draw_string(fnt, Vector2(r - tw / 2, r + 5), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#ffe9c0", 0.55 if st.cd > 0 else 1.0))
	var hit = Control.new(); hit.size = Vector2(d, d); hit.mouse_filter = Control.MOUSE_FILTER_STOP
	hit.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: f.call(); accept_event())
	n.add_child(hit)
	return n

func _portrait(k: String, sz: float) -> TextureRect:
	var tr = TextureRect.new(); tr.custom_minimum_size = Vector2(sz, sz); tr.size = Vector2(sz, sz)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var r = Art.portrait_region(k)
	if r.is_empty():
		var tx = PtGfx.tex(k)
		if tx:
			var iw = float(tx.get_width()); var ih = float(tx.get_height()); var S = minf(iw * 0.86, ih)
			r = [tx, Rect2((iw - S) / 2, 0, S, S)]
	if r.size():
		var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; tr.texture = at
	return tr

# ---------------- 主管頭像掣 ----------------
func refresh_leads() -> void:
	for c in leads_box.get_children(): c.queue_free()
	lead_btns.clear()
	for u in run.units:
		if u.role != "lead": continue
		var uu = u
		var b = Control.new(); b.custom_minimum_size = Vector2(54, 54); b.mouse_filter = Control.MOUSE_FILTER_STOP
		var dr = PtDraw.new(); b.add_child(dr)
		dr.fn = func(c):
			var cen = Vector2(27, 27)
			c.draw_circle(cen + Vector2(0, 3), 27, Color(0, 0, 0, 0.5)); c.draw_circle(cen, 27, Color(20 / 255.0, 16 / 255.0, 28 / 255.0, 0.85))
			var e = clampf(uu.energy / 100.0, 0, 1) if uu.hp > 0 else 0.0
			if e > 0:
				var y0 = 54 - 54 * e; var poly = PackedVector2Array()
				for i in 49:
					var p = cen + Vector2(cos(TAU * i / 48), sin(TAU * i / 48)) * 27
					poly.append(p if p.y >= y0 else Vector2(p.x, y0))
				c.draw_colored_polygon(poly, Color(1, 216 / 255.0, 74 / 255.0, 0.45) if uu.energy >= 100 else Color(125 / 255.0, 211 / 255.0, 252 / 255.0, 0.35))
			var ready = uu.hp > 0 and uu.energy >= 100
			c.draw_arc(cen, 26, 0, TAU, 48, Color("#ffd84a") if ready else Color("#4a3a5a"), 3 if ready else 2, true)
			if ready: c.draw_arc(cen, 29, 0, TAU, 48, Color(1, 216 / 255.0, 74 / 255.0, 0.35 + 0.3 * sin(run.t * 6)), 3, true)
		var pt = _portrait(uu.k, 46); pt.position = Vector2(4, 4); b.add_child(pt)
		b.gui_input.connect(func(ev):
			if not (ev is InputEventMouseButton and ev.pressed): return
			accept_event()
			if uu.hp <= 0: return
			if uu.energy >= 100:
				uu.want_cast = true
				var fl = []
				for f in run.foes: if f.hp > 0: fl.append(f)
				var tg = run.nearest(uu, fl, 300)
				if tg != null and uu.act == null: run.start_attack(uu, tg, true)
			else: run.jm("Fx", "toast", ["%s：符未滿" % uu.name]))
		leads_box.add_child(b); lead_btns[uu] = [b, dr, pt]

# ---------------- 每幀 ----------------
func frame() -> void:
	var now = Time.get_ticks_msec() / 1000.0
	var want = 1.0 if now < msg_until else 0.0
	msg_p.modulate.a = move_toward(msg_p.modulate.a, want, 0.12)
	fps_l.text = "FPS %d" % Engine.get_frames_per_second()
	pie_b.get_meta("st").cd = run.pie_cd / 30.0 if run.pie_cd > 0 else 0.0
	dash_b.get_meta("st").cd = run.dash_cd / 3.5 if run.dash_cd > 0 else 0.0
	pie_b.queue_redraw(); dash_b.queue_redraw(); mini.queue_redraw(); joy_n.queue_redraw()
	for u in lead_btns:
		var a = lead_btns[u]; a[1].queue_redraw(); a[2].modulate = Color(0.35, 0.35, 0.35) if u.hp <= 0 else Color.WHITE
	if down_p.visible and run.down_v != null:
		var v = run.down_v; down_bar.size.x = down_bar_bg.size.x * maxf(0, v.down / v.down_max)

func update_hud() -> void:
	var p = run.st(); var mn = J.num(p.min); var ph = run.N.PH[run.phase(mn)]
	var z = run.MAP.zone_at(run.L.x, run.L.y)
	ttl.text = "第%s區・%s" % [PtRun.CN[run.ci], run.CHAPTERS[run.ci].name]
	zone_l.text = "地頭・%s%s" % [run.N.TNAME[run.ci][run.MAP.ter_of(z)], "（已拿下）" if run.king_done(run.MAP.ter_of(z)) else ""]
	clock_l.text = "%02d:%02d" % [int(mn / 60), int(fmod(mn, 60))]; ph_l.text = J.str(ph.n); ph_l.tooltip_text = J.str(ph.d)
	var crew = 0; var crew_all = 0
	for u in run.units:
		if u.role == "crew":
			crew_all += 1
			if u.hp > 0: crew += 1
	var s = "冥幣 %s　壽包 %s　" % [run.fmt(run.S.res.coins), run.fmt(run.S.res.buns)]
	for f in run.FAC: s += "[color=%s]%s %s[/color]　" % [run.FAC[f].col, run.FAC[f].mat, run.fmt(p.mats[f])]
	s += "部門 %d/%d" % [crew, crew_all]
	if run.streak > 4: s += "　[color=#ffd84a]連巡 ×%.2f[/color]" % (1 + minf(1, run.streak * 0.01))
	res_l.text = s
	auto_b.text = "技能：手動" if p.get("autoSk") == false else "技能：自動"
	_layout_auto()

func _layout_auto() -> void:
	var w = size.x; var h = size.y
	auto_b.reset_size(); auto_b.position = Vector2(w - 8 - 74 - 8 - 58 - 8 - auto_b.size.x, h - 10 - 29 - auto_b.size.y / 2)

func msg(bb: String, sec: float) -> void:
	msg_l.text = bb; msg_until = Time.get_ticks_msec() / 1000.0 + sec
	msg_p.reset_size(); msg_p.size.x = size.x - 24

# ---------------- 設施卡 ----------------
func act_hide() -> void: act_p.visible = false
func act_show(title: String, desc: String, btns: Array) -> void:
	for c in act_box.get_children(): c.queue_free()
	act_box.add_child(_lbl(title, 14.5, Color("#f3e3c0"), "serif", 900))
	var d = _lbl(desc, 12, Color("#b8a8c8")); d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; act_box.add_child(d)
	if btns.size():
		var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6); act_box.add_child(fl)
		for b in btns:
			var bt = UIKit.btn(b[0], "gold" if b[3] else "", true); bt.disabled = not b[1]; var f: Callable = b[2]
			bt.pressed.connect(func(): f.call()); fl.add_child(bt)
	act_p.visible = not down_p.visible
	_place_bottom.call_deferred()

# ---------------- 靈體不穩卡 ----------------
func down_hide() -> void:
	down_p.visible = false
	if run.act_key != "": act_p.visible = act_box.get_child_count() > 0 and run.act_key != ""
func down_show(v: PtU, I: Dictionary) -> void:
	for c in down_p.get_children(): c.queue_free()
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 7); down_p.add_child(vb)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9); vb.add_child(hb)
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.08), 20)); pc.custom_minimum_size = Vector2(40, 40)
	pc.add_child(_portrait(v.k, 40)); hb.add_child(pc)
	var f = run.FAC.get(v.fac, run.FAC.lan)
	var nb = VBoxContainer.new(); nb.add_theme_constant_override("separation", 0); hb.add_child(nb)
	var nm = HBoxContainer.new(); nb.add_child(nm)
	nm.add_child(_lbl(v.name, 16, UIKit.INKTXT, "serif", 900))
	if v.elite:
		var tg = PanelContainer.new(); tg.add_theme_stylebox_override("panel", UIKit.sb(Color("#7a1a10"), 3, Color(0, 0, 0, 0), 0, Vector4(5, 1, 5, 1)))
		tg.add_child(_lbl("釘子戶", 11, Color.WHITE)); tg.size_flags_vertical = Control.SIZE_SHRINK_CENTER; nm.add_child(tg)
	var fc = Color(J.str(f.col)).darkened(0.35)
	nb.add_child(_lbl("%s・靈體不穩" % f.name, 12, fc, "sans", 800))
	down_bar_bg = ColorRect.new(); down_bar_bg.color = Color(0, 0, 0, 0.12); down_bar_bg.custom_minimum_size = Vector2(0, 3); vb.add_child(down_bar_bg)
	down_bar = ColorRect.new(); down_bar.color = Color("#c8402c"); down_bar.size = Vector2(0, 3); down_bar_bg.add_child(down_bar)
	var bb = HBoxContainer.new(); bb.add_theme_constant_override("separation", 8); vb.add_child(bb)
	var b1 = _two_line_btn("送去投胎", "冥幣＋%s" % f.mat, ""); b1.pressed.connect(func(): run.resolve_down(v, "soul")); bb.add_child(b1)
	var sub = ("壽包 %d%s" % [I.cost, "・對症" if I.fear else ""]) if I.ok else I.why
	var b2 = _two_line_btn("遞合約 %s" % (("%d%%" % I.ch) if I.has("ch") else ""), sub, "gold"); b2.disabled = not I.ok; b2.pressed.connect(func(): run.resolve_down(v, "sign")); bb.add_child(b2)
	down_p.visible = true; act_p.visible = false
	_place_bottom.call_deferred()

func _two_line_btn(a: String, b: String, kind: String) -> Button:
	var bt = UIKit.btn("", kind); bt.size_flags_horizontal = Control.SIZE_EXPAND_FILL; bt.custom_minimum_size.y = 50
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_theme_constant_override("separation", 0)
	var fg = Color("#fff3e0") if kind == "gold" else Color("#f0e2c8")
	var l1 = _lbl(a, 15, fg, "sans", 900); l1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(l1)
	var l2 = _lbl(b, 11, Color(fg, 0.85), "sans", 600); l2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(l2)
	bt.add_child(vb)
	return bt

# ---------------- 結算 ----------------
func end_show(died: bool, quip: String, l: Dictionary) -> void:
	act_p.visible = false; down_p.visible = false
	end_p = ColorRect.new(); end_p.color = Color(0, 0, 0, 0.6); end_p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); end_p.mouse_filter = Control.MOUSE_FILTER_STOP; add_child(end_p)
	var cc = CenterContainer.new(); cc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); end_p.add_child(cc)
	var card = PanelContainer.new(); var sb = UIKit.sb(UIKit.PAPER, 6, Color(0, 0, 0, 0), 0, Vector4(16, 16, 16, 16)); sb.shadow_color = Color(0, 0, 0, 0.6); sb.shadow_size = 30
	card.add_theme_stylebox_override("panel", sb); card.custom_minimum_size.x = minf(330, size.x * 0.88); cc.add_child(card)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); card.add_child(vb)
	var h2 = _lbl("阿福倒下了" if died else "收工", 22, Color("#7a1a10"), "serif", 900); h2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(h2)
	if died:
		var qp = PanelContainer.new(); qp.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.05), 4, Color(0, 0, 0, 0), 0, Vector4(7, 7, 7, 7)))
		var ql = _lbl(quip, 13.5, Color("#5a3a2a")); ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; qp.add_child(ql); vb.add_child(qp)
	var lines = ["擊倒 %d　收編 %d" % [l.kills, l.rec], "冥幣 +%s　好評 +%s" % [run.fmt(l.coins), run.fmt(l.exp)]]
	for s in lines: var lb = _lbl(s, 14, UIKit.INKTXT); lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(lb)
	var mats = ""
	for f in run.FAC: mats += "[color=%s]%s +%d[/color]　" % [Color(J.str(run.FAC[f].col)).darkened(0.35).to_html(false), run.FAC[f].mat, l[f]]
	var ml = UIKit.rich("[center]" + mats.strip_edges() + "[/center]", 14, UIKit.INKTXT); vb.add_child(ml)
	if l.buns: var bl = _lbl("合約工資：壽包 -%d" % l.buns, 14, UIKit.INKTXT); bl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(bl)
	var dl = _lbl(("材料和冥幣全部保留。" if died else "") + "部門回村休息，過勞會慢慢恢復。", 12.5, UIKit.INKDIM); dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; dl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; vb.add_child(dl)
	var ok = UIKit.btn("返村", "gold"); ok.pressed.connect(func(): run.close_run()); vb.add_child(ok)

# ---------------- 搖桿 ----------------
func _draw_joy(c: CanvasItem) -> void:
	var j = run.joy
	if j == null: return
	c.draw_arc(Vector2(j.x0, j.y0), 46, 0, TAU, 48, Color(1, 1, 1, 0.35), 2, true)
	var d = Vector2(j.x - j.x0, j.y - j.y0); var dl = d.length(); var m = minf(46, dl) / (dl if dl > 0 else 1.0)
	c.draw_circle(Vector2(j.x0, j.y0) + d * m, 20, Color(1, 1, 1, 0.35))

# ---------------- 地圖 ----------------
const TC := [Color(120 / 255.0, 200 / 255.0, 140 / 255.0, 0.12), Color(220 / 255.0, 180 / 255.0, 90 / 255.0, 0.12), Color(140 / 255.0, 160 / 255.0, 240 / 255.0, 0.12), Color(220 / 255.0, 120 / 255.0, 200 / 255.0, 0.12), Color(110 / 255.0, 210 / 255.0, 230 / 255.0, 0.12), Color(240 / 255.0, 90 / 255.0, 90 / 255.0, 0.14), Color(90 / 255.0, 1, 190 / 255.0, 0.10), Color(90 / 255.0, 1, 190 / 255.0, 0.10), Color(90 / 255.0, 1, 190 / 255.0, 0.10)]

func _fog_texture() -> ImageTexture:
	if run.fog_dirty or fog_tex == null:
		run.fog_dirty = false
		var data = PackedByteArray(); data.resize(run.fog.size() * 4)
		for i in run.fog.size():
			var v = 255 if run.fog[i] == 1 else 0
			data[i * 4] = 255; data[i * 4 + 1] = 255; data[i * 4 + 2] = 255; data[i * 4 + 3] = v
		var img = Image.create_from_data(run.fog_w, run.fog_h, false, Image.FORMAT_RGBA8, data)
		if fog_tex == null: fog_tex = ImageTexture.create_from_image(img)
		else: fog_tex.update(img)
	return fog_tex

func draw_map(m: CanvasItem, W: float, H: float, ox: float, oy: float, k: float, big: bool) -> void:
	var M = run.MAP; var rs = run.reg_st()
	m.draw_rect(Rect2(0, 0, W, H), Color(8 / 255.0, 6 / 255.0, 12 / 255.0, 0.92))
	var X = Transform2D(0, Vector2(-ox * k, -oy * k))
	m.draw_set_transform_matrix(X)
	var F = float(run.N.FOG)
	m.draw_texture_rect(_fog_texture(), Rect2(0, 0, run.fog_w * F * k, run.fog_h * F * k), false, Color(120 / 255.0, 110 / 255.0, 140 / 255.0, 0.45))
	for z in M.COLS * M.ROWS:
		var cl = M.zone_cell(z); m.draw_rect(Rect2(cl.x * M.CW * k, cl.y * M.CH * k, M.CW * k + 0.5, M.CH * k + 0.5), TC[M.ter_of(z)])
	var GW = M.GW
	for w in M.WALLS:
		var th = (2.0 if w.kind == "border" else 1.3) * (1.6 if big else 1.0); var col = Color("#0e2a24") if w.kind == "river" else Color.BLACK
		var seg = func(a: float, b: float, cc: Color, tt: float) -> void:
			if b <= a: return
			if w.h: m.draw_rect(Rect2(a * k, w.p * k - tt / 2, (b - a) * k, tt), cc)
			else: m.draw_rect(Rect2(w.p * k - tt / 2, a * k, tt, (b - a) * k), cc)
		if w.gap != null and w.gap.g.sec and not run.sec_found(w.gap.g): seg.call(w.a, w.b, col, th); continue
		if w.gap != null:
			seg.call(w.a, w.gap.c - GW / 2, col, th); seg.call(w.gap.c + GW / 2, w.b, col, th)
			if w.gap.g.sec: m.draw_circle(Vector2(w.gap.g.x * k, w.gap.g.y * k), 4 if big else 2, Color("#7dffc0"))
			elif not run.gate_open(w.gap.g): seg.call(w.gap.c - GW / 2, w.gap.c + GW / 2, Color("#e84a5f"), 4.0 if big else 3.0)
		else: seg.call(w.a, w.b, col, th)
	var sz = 2.0 if big else 1.0
	for f in M.FACI:
		var col2 = (Color("#3fa36a") if J.t(rs.sta.get(str(f.z))) else Color("#666")) if f.t == "station" else (Color("#ffd69a") if f.t == "tea" else (Color("#d8c8c8") if f.t == "prison" else Color("#9cc8ff")))
		m.draw_rect(Rect2(f.x * k - 2 * sz, f.y * k - 2 * sz, 4 * sz, 4 * sz), col2)
	for sp in run.spots:
		if sp.k == "lm" and J.t(rs.lm.get(str(sp.id))):
			m.draw_set_transform_matrix(X * Transform2D(PI / 4, Vector2(sp.x * k, sp.y * k)))
			m.draw_rect(Rect2(-2 * sz, -2 * sz, 4 * sz, 4 * sz), Color("#e8d29a"))
	m.draw_set_transform_matrix(X)
	for tt in 9:
		if run.king_done(tt): continue
		var q = M.lair(tt); var main = M.TMAIN.has(tt); var kd = run.king_def(tt); if kd == null: kd = {}
		var bigK = M.TMAIN[tt] == 2 if main else kd.get("big") != null
		if M.TSECRET.has(tt) and not run.fog_at(q.x, q.y): continue
		m.draw_circle(Vector2(q.x * k, q.y * k), (3.5 if bigK else 2.6) * sz, Color("#ff4a6a") if main else (Color("#7dffc0") if kd.get("guard") else Color("#c77dff")))
	if run.bryan != null:
		var b = run.bryan[0]; m.draw_rect(Rect2(b.x * k - 1.5 * sz, b.y * k - 1.5 * sz, 3 * sz, 3 * sz), Color("#ff6a6a"))
	if big:
		var fnt = UIKit.font("sans", 900)
		for tt in 9:
			var sx = 0.0; var sy = 0.0; var n = 0; var seen = false
			for z in M.COLS * M.ROWS:
				if M.ter_of(z) == tt:
					var c2 = M.zone_center(z); sx += c2.x; sy += c2.y; n += 1
					if run.fog_at(c2.x, c2.y): seen = true
			if M.TSECRET.has(tt) and not seen: continue
			var nm = J.str(run.N.TNAME[run.ci][tt]) if seen else "？？？"
			var tw = fnt.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x; var p = Vector2(sx / n * k - tw / 2, sy / n * k - 14)
			m.draw_string_outline(fnt, p, nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, 3, Color(0, 0, 0, 0.8))
			m.draw_string(fnt, p, nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(200 / 255.0, 220 / 255.0, 200 / 255.0, 0.75) if run.king_done(tt) else Color(1, 240 / 255.0, 210 / 255.0, 0.92))
		var f2 = UIKit.font("sans", 700)
		for sp in run.spots:
			if sp.k == "lm" and J.t(rs.lm.get(str(sp.id))):
				var tw2 = f2.get_string_size(sp.name, HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x; var p2 = Vector2(sp.x * k - tw2 / 2, sp.y * k + 13)
				m.draw_string_outline(f2, p2, sp.name, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, 3, Color(0, 0, 0, 0.8)); m.draw_string(f2, p2, sp.name, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("#e8d29a"))
	var lp = Vector2(run.L.x * k, run.L.y * k)
	m.draw_circle(lp, 5 if big else 3, Color("#ffe9a0")); m.draw_arc(lp, 5 if big else 3, 0, TAU, 24, Color.BLACK, 1.5, true)
	m.draw_set_transform_matrix(Transform2D.IDENTITY)

func _draw_mini(c: CanvasItem) -> void:
	var W = MINI_W; var H = MINI_H; var VWm = 2600.0; var k = W / VWm; var VHm = H / k
	var ox = clampf(run.L.x - VWm / 2, 0, run.MAP.WW - VWm); var oy = clampf(run.L.y - VHm / 2, 0, run.MAP.WH - VHm)
	# 用 clip：畫完再蓋邊（簡單做法：只畫喺框入面嘅嘢，超出嘅由外框遮）
	c.draw_rect(Rect2(-1, -1, W + 2, H + 2), Color("#4a3a5a"))
	var cl = get_node_or_null("mini_clip")
	draw_map(c, W, H, ox, oy, k, false)
	# 外框外面嘅嘢用背景色蓋住（左右上下四條）
	var bg = Color(0, 0, 0, 0)
	c.draw_rect(Rect2(-1, -1, W + 2, H + 2), Color("#4a3a5a"), false, 1)

func toggle_map() -> void:
	if map_p != null: close_map()
	else: open_map()
func close_map() -> void:
	if map_p: map_p.queue_free(); map_p = null
	run.paused = false
func open_map() -> void:
	if map_p != null or run.ended: return
	run.paused = true
	map_p = ColorRect.new(); map_p.color = Color(6 / 255.0, 4 / 255.0, 10 / 255.0, 0.94); map_p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); map_p.mouse_filter = Control.MOUSE_FILTER_STOP; add_child(map_p)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_left = 8; vb.offset_right = -8; vb.offset_top = 8; vb.offset_bottom = -8; map_p.add_child(vb)
	var hd = HBoxContainer.new(); hd.add_theme_constant_override("separation", 8); vb.add_child(hd)
	var tv = VBoxContainer.new(); tv.size_flags_horizontal = Control.SIZE_EXPAND_FILL; tv.add_theme_constant_override("separation", 0); hd.add_child(tv)
	tv.add_child(_lbl("第%s區・%s" % [PtRun.CN[run.ci], run.CHAPTERS[run.ci].name], 16, Color("#f0e4c8"), "sans", 900))
	var rs = run.reg_st(); var kn = 0
	for tt in 9: if run.king_done(tt): kn += 1
	var st = _lbl("地頭 %d/9　地標 %d/%d　殘頁 %d/%d　寶藏 %d/16　暗路 %d/5" % [kn, rs.lm.size(), run.N.LMNAME[run.ci].size(), rs.pg.size(), run.page_ghosts().size(), rs.ca.size(), rs.sg.size()], 12, Color("#ccbbbb"))
	st.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; tv.add_child(st)
	var bk = UIKit.btn("返回", "", true); bk.size_flags_vertical = Control.SIZE_SHRINK_CENTER; bk.pressed.connect(close_map); hd.add_child(bk)
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; vb.add_child(sc)
	var key = UIKit.rich("[color=#ff4a6a]■[/color]主線　[color=#c77dff]■[/color]地頭王　[color=#7dffc0]■[/color]秘境／暗路　[color=#e8d29a]■[/color]地標　[color=#3fa36a]■[/color]地鐵站　[color=#ffd69a]■[/color]茶水間", 12, Color("#ccbbbb")); vb.add_child(key)
	await get_tree().process_frame
	if map_p == null: return
	var box = sc.size; var k0 = maxf(box.y / run.MAP.WH, box.x / run.MAP.WW)
	var cv = PtDraw.new(); var holder = Control.new(); holder.custom_minimum_size = Vector2(run.MAP.WW * k0, run.MAP.WH * k0); holder.mouse_filter = Control.MOUSE_FILTER_PASS
	holder.add_child(cv); sc.add_child(holder)
	cv.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	cv.fn = func(c): draw_map(c, run.MAP.WW * k0, run.MAP.WH * k0, 0, 0, k0, true)
	await get_tree().process_frame
	if map_p == null: return
	sc.scroll_horizontal = int(run.L.x * k0 - box.x / 2); sc.scroll_vertical = int(run.L.y * k0 - box.y / 2)
