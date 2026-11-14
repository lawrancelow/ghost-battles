# 主線戰鬥（原生外殼）
#  - 規則／AI／傷害／連嚇：照用 battle.js＋rework.js（Battle.update、hit、cast……），數值一模一樣
#  - 畫面：原生喺 _draw 直接叫 Battle.draw()（Ctx 直接畫落節點，唔經錄製器）；角色由原生 Art 畫，出招 MOVES／反派 custom 仍用 JS
#  - 介面：頂欄（撤退、標題、倒數、速度、自動）、提示、技能卡全部原生；DOM 收起
#  - 結算：用返 DOM 嘅 #b-result（只顯示結算框，背景透明，原生戰場喺下面繼續畫）
class_name BtRun
extends Control

static var cur: BtRun = null

const TOP_H := 48.0
const CARD_H := 92.0

var B: Dictionary
var safe_top := 0.0
var safe_bot := 0.0
var stage: Control
var top: Panel
var title_l: Label
var time_l: Label
var speed_b: Button
var auto_b: Button
var quit_b: Button
var hint_l: Label
var cards: HBoxContainer
var card_list: Array = []      # [{u, box, fill, glow, seal, kind}]
var _hidden: Array = []
var _quit_arm := 0.0
var _result_shown := false
var _title_t := 0.0

static func js(n: String): return J.G.get(n)
static func L(s) -> String: return J.str(DB.L(J.str(s)))

# ---------------- 開局（battle.js start 尾叫） ----------------
static func hook(b) -> bool:
	if not (b is Dictionary): return false
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if cur != null and is_instance_valid(cur): cur._teardown()
	var r = BtRun.new(); r.name = "BtRun"; r.B = b
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())   # DOM（結算框）喺上面
	cur = r
	r._build()
	r._cover(true)
	return true

static func size_of() -> Array:
	if cur == null or not is_instance_valid(cur) or cur.stage == null: return [390.0, 560.0]
	return [maxf(100.0, cur.stage.size.x), maxf(100.0, cur.stage.size.y)]

func _teardown() -> void:
	_cover(false)
	if cur == self: cur = null
	queue_free()

func _el(sel: String):
	var f = js("$")
	return J.cl(f, null, [sel]) if f != null else null

# 收起村子同 DOM；#battle 嘅 DOM 部件收埋（結算時再開 DOM）
func _cover(on: bool) -> void:
	var main = get_parent()
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and not _hidden.has(n):
				n.set_meta("bt_vis", n.visible); n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
		var be = _el("#battle")
		if be: be.style["background"] = "transparent"
		for id in ["#b-top", "#bcvs", "#b-hint", "#b-cards"]:
			var e = _el(id)
			if e: e.style["visibility"] = "hidden"
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = n.get_meta("bt_vis", true); n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()
		var main2 = get_parent(); var d2 = main2.get("dom")
		if d2 is CanvasItem: d2.visible = true; d2.process_mode = Node.PROCESS_MODE_INHERIT
		var be = _el("#battle")
		if be: be.style.erase("background")
		for id in ["#b-top", "#bcvs", "#b-hint", "#b-cards"]:
			var e = _el(id)
			if e: e.style.erase("visibility")

# 結算：顯示返 DOM（只得結算框睇到）
func _show_dom(on: bool) -> void:
	var dom = get_parent().get("dom")
	if dom == null: return
	dom.visible = on; dom.process_mode = Node.PROCESS_MODE_INHERIT if on else Node.PROCESS_MODE_DISABLED


# ---------------- 版面 ----------------
func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg = ColorRect.new(); bg.color = Color("#0d0b10"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	# 頂欄
	top = Panel.new(); top.anchor_right = 1; top.offset_bottom = TOP_H + safe_top
	var ts = StyleBoxFlat.new(); ts.bg_color = Color("#18131d"); ts.border_color = Color("#3a2f2a"); ts.border_width_bottom = 1
	top.add_theme_stylebox_override("panel", ts); add_child(top)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 7); hb.anchor_right = 1; hb.anchor_bottom = 1
	hb.offset_left = 9; hb.offset_right = -9; hb.offset_top = 8 + safe_top; hb.offset_bottom = -8; top.add_child(hb)
	quit_b = _btn(L("撤退"), Color(0, 0, 0, 0.25), Color("#6a5a50"), Color("#c8b8a8")); hb.add_child(quit_b); quit_b.pressed.connect(_on_quit)
	title_l = UIKit.label("", 17, Color("#f3e3c0"), "serif", 900); title_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_l.clip_text = true; title_l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; title_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(title_l)
	time_l = UIKit.label("", 15, Color("#ffcf6a"), "sans", 900); time_l.custom_minimum_size = Vector2(38, 0); time_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; time_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(time_l)
	speed_b = _btn("×1", Color("#3a2c26"), Color("#6a5040"), Color("#f0e2c8")); hb.add_child(speed_b)
	speed_b.pressed.connect(func():
		B["speed"] = 1.0 if J.num(B.get("speed", 1)) == 2.0 else 2.0
		_ls("gb_speed", str(int(J.num(B.speed)))); _sync_btns())
	auto_b = _btn("", Color("#3a2c26"), Color("#6a5040"), Color("#f0e2c8")); auto_b.custom_minimum_size = Vector2(70, 0); hb.add_child(auto_b)
	auto_b.pressed.connect(func():
		B["auto"] = not J.t(B.get("auto"))
		_ls("gb_auto", "1" if J.t(B.auto) else "0"); _sync_btns())
	# 戰場
	stage = Control.new(); stage.clip_contents = true; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.anchor_right = 1; stage.anchor_bottom = 1; stage.offset_top = TOP_H + safe_top; stage.offset_bottom = -(CARD_H + 36 + 18 + safe_bot)
	stage.draw.connect(_draw_stage); add_child(stage)
	stage.resized.connect(func(): if J.t(B.get("active")): J.mc(B, "resize", []))
	# 提示
	hint_l = UIKit.label(L("符滿了就點。先用敵人怕的嚇法嚇到他「失神」，再接另一種他怕的，就是「連嚇」。"), 12.5, Color(0.86, 0.8, 0.72, 0.75))
	hint_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; hint_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; hint_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var hbg = Panel.new(); var hs = StyleBoxFlat.new(); hs.bg_color = Color("#151119"); hbg.add_theme_stylebox_override("panel", hs)
	hbg.anchor_top = 1; hbg.anchor_right = 1; hbg.anchor_bottom = 1; hbg.offset_top = -(CARD_H + 36 + 18 + safe_bot); hbg.offset_bottom = -(CARD_H + 18 + safe_bot); hbg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(hbg)
	hint_l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hint_l.offset_left = 10; hint_l.offset_right = -10; hbg.add_child(hint_l)
	# 黃符技能卡
	var cbg = Panel.new(); var cs = StyleBoxFlat.new(); cs.bg_color = Color("#221512"); cs.border_color = Color("#5a2e22"); cs.border_width_top = 2
	cbg.add_theme_stylebox_override("panel", cs); cbg.anchor_top = 1; cbg.anchor_right = 1; cbg.anchor_bottom = 1; cbg.offset_top = -(CARD_H + 18 + safe_bot); cbg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(cbg)
	cards = HBoxContainer.new(); cards.add_theme_constant_override("separation", 6)
	cards.anchor_top = 1; cards.anchor_right = 1; cards.anchor_bottom = 1; cards.offset_left = 8; cards.offset_right = -8; cards.offset_top = -(CARD_H + 10 + safe_bot); cards.offset_bottom = -(10 + safe_bot)
	add_child(cards)
	_build_cards()
	_sync_btns()
	_title_t = 0

func _btn(t: String, bg: Color, bd: Color, fg: Color) -> Button:
	var b = Button.new(); b.text = t; b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 13)
	var s = UIKit.sb(bg, 4, bd, 1, Vector4(9, 4, 9, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fg)
	return b

func _ls(k: String, v: String) -> void:
	var ls = js("localStorage")
	if ls != null: J.mc(ls, "setItem", [k, v])

func _sync_btns() -> void:
	var on = J.t(B.get("auto"))
	auto_b.text = L("自動 ON") if on else L("自動 OFF")
	var s = UIKit.sb(Color("#2e5d55") if on else Color("#3a2c26"), 4, Color("#7ac0b0") if on else Color("#6a5040"), 1, Vector4(9, 4, 9, 4))
	for k in ["normal", "hover", "pressed"]: auto_b.add_theme_stylebox_override(k, s)
	speed_b.text = "×%d" % int(J.num(B.get("speed", 1)))
	J.mc(B, "syncBtns", [])

# 卡：英雄（技能）、軍師、合體技
func _build_cards() -> void:
	for c in cards.get_children(): c.queue_free()
	card_list.clear()
	for u in B.units:
		if J.num(u.side) == 0 and not J.t(u.get("minion")): _mk_card(u, "hero")
	if B.get("adviser") is Dictionary: _mk_card(B.adviser, "adv")
	if B.get("comboSkill") is Dictionary: _mk_card(B.comboSkill, "combo")

func _mk_card(u: Dictionary, kind: String) -> void:
	var base := Color("#e9ca68"); var edge := Color("#9a7a2a"); var inner := Color(0.67, 0.16, 0.12, 0.55); var ink := Color("#7a1a10")
	if kind == "adv": base = Color("#ccd6b0"); edge = Color("#5a7a5a"); inner = Color(0.18, 0.36, 0.33, 0.6); ink = Color("#2a4a3a")
	elif kind == "combo": base = Color("#dcaccc"); edge = Color("#7a3a6a"); inner = Color(0.47, 0.12, 0.35, 0.6); ink = Color("#5a0a4a")
	var box = Panel.new(); box.size_flags_horizontal = Control.SIZE_EXPAND_FILL; box.custom_minimum_size = Vector2(0, CARD_H); box.clip_contents = true
	box.mouse_filter = Control.MOUSE_FILTER_STOP
	var st = StyleBoxFlat.new(); st.bg_color = base; st.border_color = edge; st.set_border_width_all(2); st.set_corner_radius_all(1)
	st.shadow_color = Color(0, 0, 0, 0.5); st.shadow_size = 0; st.shadow_offset = Vector2(0, 2)
	box.add_theme_stylebox_override("panel", st)
	var fill = ColorRect.new(); fill.color = Color(0.78, 0.2, 0.16, 0.26); fill.anchor_right = 1; fill.anchor_top = 1; fill.anchor_bottom = 1; fill.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(fill)
	var fl = ColorRect.new(); fl.color = Color(0.63, 0.12, 0.08, 0.5); fl.anchor_right = 1; fl.offset_bottom = 1.5; fl.mouse_filter = Control.MOUSE_FILTER_IGNORE; fill.add_child(fl)
	var frame = Panel.new(); var fs = StyleBoxFlat.new(); fs.draw_center = false; fs.border_color = inner; fs.set_border_width_all(1); fs.set_expand_margin_all(-3)
	frame.add_theme_stylebox_override("panel", fs); frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); frame.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(frame)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_top = 6; vb.offset_bottom = -6; vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 1); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(vb)
	if kind != "combo":
		var pc = PanelContainer.new(); pc.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; pc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.98, 0.9, 0.6), 20))
		var pr = TextureRect.new(); pr.custom_minimum_size = Vector2(40, 40); pr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var r = Art.portrait_region(J.str(u.k))
		if r.size(): var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; pr.texture = at
		pc.add_child(pr); vb.add_child(pc)
	var t1 = ""; var t2 = ""
	if kind == "combo":
		var c = u.c; t1 = L(c.name); t2 = "%s＋%s" % [L(u.a.name), L(u.b.name)]
		var h = UIKit.label(L("合體技"), 14.5, ink, "serif", 900); h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; h.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(h)
	else:
		t1 = L(J.gp(u.get("sk"), "name")) if u.get("sk") != null else ""
		t2 = (L("軍師・") if kind == "adv" else "") + L(u.name)
	var nm = UIKit.label(t1, 14.5, ink, "serif", 900); nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nm.clip_text = true
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; nm.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(nm)
	var sm = UIKit.label(t2, 11, Color("#6a4a20")); sm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sm.clip_text = true
	sm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; sm.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(sm)
	# 「敕」印（滿符）
	var seal = Label.new(); seal.text = "敕"; seal.add_theme_font_override("font", UIKit.font("serif", 900)); seal.add_theme_font_size_override("font_size", 13)
	seal.add_theme_color_override("font_color", Color.WHITE); seal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; seal.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var sbx = UIKit.sb(Color("#c8372d"), 2); seal.add_theme_stylebox_override("normal", sbx)
	seal.anchor_left = 1; seal.anchor_right = 1; seal.offset_left = -22; seal.offset_right = -3; seal.offset_top = 3; seal.offset_bottom = 22; seal.rotation = 0.14; seal.pivot_offset = Vector2(9.5, 9.5)
	seal.mouse_filter = Control.MOUSE_FILTER_IGNORE; seal.visible = false; box.add_child(seal)
	var uu = u; var kk = kind
	box.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			if B.get("result") != null: return
			if kk == "combo": J.mc(B, "castCombo", [])
			else: J.mc(B, "cast", [uu])
			box.accept_event())
	cards.add_child(box)
	card_list.append({"u": u, "box": box, "fill": fill, "seal": seal, "kind": kind, "st": st, "edge": edge, "sig": ""})

func _update_cards() -> void:
	for c in card_list:
		var u = c.u; var en = J.num(u.get("energy", 0)); var ready := false; var dead := false
		if c.kind == "hero": ready = en >= 100 and J.num(u.hp) > 0 and u.get("casting") == null; dead = J.num(u.hp) <= 0
		elif c.kind == "adv": ready = en >= 100 and B.get("advCast") == null
		else: ready = en >= 100
		var sig = "%d%s%s" % [int(en), ready, dead]
		if sig == c.sig: continue
		c.sig = sig
		c.fill.anchor_top = 1.0 - clampf(en / 100.0, 0, 1)
		c.seal.visible = ready and not dead
		c.box.position.y = -4 if ready and not dead else 0
		var st: StyleBoxFlat = c.st
		st.border_color = Color("#c8372d") if ready and not dead else c.edge
		st.shadow_color = Color(1, 0.75, 0.35, 0.75) if ready and not dead else Color(0, 0, 0, 0.5)
		st.shadow_size = 7 if ready and not dead else 0
		c.box.modulate = Color(0.35, 0.35, 0.35) if dead else (Color.WHITE if ready else Color(0.86, 0.82, 0.74))

# ---------------- 每幀 ----------------
var prof_d := 0
var prof_n := 0
func _process(dt: float) -> void:
	if not J.t(B.get("active")):
		_teardown(); return
	if not OS.has_environment("GB_NODRAW"): stage.queue_redraw()
	if B.get("result") != null:
		if not _result_shown:
			_result_shown = true; _show_dom(true)
			for x in [top, cards]: x.modulate.a = 0.45
		return
	var left = maxf(0.0, ceil(J.num(B.get("timeLimit", 90)) - J.num(B.get("t", 0))))
	time_l.text = "%ds" % int(left)
	time_l.add_theme_color_override("font_color", Color("#ff7a6a") if left <= 10 else Color("#ffcf6a"))
	_title_t -= dt
	if _title_t <= 0:
		_title_t = 0.5
		var te = _el("#b-title")
		if te != null: title_l.text = L(J.gp(te, "textContent"))
	if _quit_arm > 0:
		_quit_arm -= dt
		if _quit_arm <= 0: quit_b.text = L("撤退")
	_update_cards()

func _draw_stage() -> void:
	if not J.t(B.get("active")): return
	var ctx = Ctx.new(stage)
	B["_natCtx"] = ctx
	var t0 = Time.get_ticks_usec()
	var cp = OS.has_environment("GB_CTXPROF") and prof_n == 29
	if cp: J.CTXPROF.clear(); J.CTXPROF_ON = true
	if OS.has_environment("GB_JSDRAW"): J.mc(B, "draw", [])
	else: BtDraw.draw(ctx, B)
	if cp:
		J.CTXPROF_ON = false; var ks = J.CTXPROF.keys().filter(func(k): return not k.begins_with("#"))
		ks.sort_custom(func(a, b): return J.CTXPROF[a] > J.CTXPROF[b])
		print("[ctx] ", ", ".join(ks.slice(0, 14).map(func(k): return "%s %.1f(%d)" % [k, J.CTXPROF[k] / 1000.0, J.CTXPROF["#" + k]])))
	B["_natCtx"] = null
	if OS.has_environment("GB_PROF"):
		prof_d += Time.get_ticks_usec() - t0; prof_n += 1
		if prof_n >= 30:
			print("[battle] draw=%.1fms js_timers=%.1fms" % [prof_d / 30000.0, JSRun.prof_timer / 30000.0]); JSRun.prof_timer = 0
			prof_d = 0; prof_n = 0

func _on_quit() -> void:
	if B.get("result") != null: return
	if _quit_arm <= 0:
		_quit_arm = 2.5; quit_b.text = L("確定？"); return
	_quit_arm = 0
	J.mc(B, "finish", [false, true])

# ---------------- 測試 ----------------
static func t_bt(i: int) -> void:
	if cur == null: print("t_bt: no battle"); return
	var b = cur.B
	match i:
		0: # 全部英雄滿符
			for u in b.units: if J.num(u.side) == 0 and u.get("sk") != null: u["energy"] = 100.0
		1: b["auto"] = true; cur._sync_btns()
		2: b["speed"] = 2.0; cur._sync_btns()
		3: # 敵人剩三成血
			for u in b.units: if J.num(u.side) == 1: u["hp"] = J.num(u.hp) * 0.3
		4: # 撳結算「回村子／繼续」
			var ok = cur._el("#b-ok")
			if ok != null and ok.get("onclick") != null: J.cl(ok.onclick, ok, [])
	print("t_bt ", i, " t=", b.get("t"), " units=", b.units.size())
