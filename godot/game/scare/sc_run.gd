# 回陽間・夜班嚇人（原生外殼）
#  - 規則／分數／人物 AI：照用 scare.js（Scare.step、hit、useGhost、useProp……），數值一模一樣，存檔 S.scare 同網頁版互通
#  - 畫面：原生喺 _draw 直接叫 Scare.draw()（Ctx 直接畫落節點，唔經錄製器；角色由原生 Art 畫）
#  - 介面：頂欄、小地圖、拖鏡頭、人物卡、出招列全部原生；DOM 介面收起（以前每幀排版 ~100ms）
#  - 偷看手機／電腦／茶水間嘅彈出視窗：原生（sc_ops.gd）；_check_modal 保留做後備（萬一有 DOM 彈窗）
class_name ScRun
extends Control

static var cur: ScRun = null

const TOP_H := 50.0
const MAP_H := 34.0
const SHORT := {"boss": "陳總", "meeting": "會議", "lobby": "大堂", "main": "工程", "pantry": "茶水", "wc": "洗手", "qa": "設計", "server": "機房", "rest": "休息"}
const DOTCH := {"ken": "K", "it": "晴", "mis": "美", "boss": "陳", "auntie": "娣", "guard": "伯", "daoshi": "道", "kol": "網"}

var Sc: Dictionary
var safe_top := 0.0
var safe_bot := 0.0
var stage: Control
var mapc: Control
var top: Control
var panel: Control
var clock_l: Label
var kpi_l: Label
var mana_fill: ColorRect
var quit_b: Button
var follow_b: Button
var tgt_box: VBoxContainer
var dock: HBoxContainer
var room_btns := {}
var ghost_btns := {}
var _tgt_sig := ""
var _dock_sig := ""
var _hidden: Array = []
var _drag = null
var _quit_arm := 0.0
var _modal := false
var ops_layer = null
var _t0 := 0

static func js(n: String): return J.G.get(n)
static var _mk := {}
static var _mk_last := 0
static var _mk_prev := ""
static func mark(k: String) -> void:
	var now = Time.get_ticks_usec()
	if _mk_prev != "": _mk[_mk_prev] = _mk.get(_mk_prev, 0) + now - _mk_last
	_mk_prev = k; _mk_last = now
static func L(s) -> String: return J.str(DB.L(J.str(s)))

# ---------------- 開局（scare.js start 尾叫） ----------------
static func hook(sc) -> bool:
	if not (sc is Dictionary) or J.t(sc.get("headless")): return false
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if cur != null and is_instance_valid(cur): cur.queue_free()
	var r = ScRun.new(); r.name = "ScRun"; r.Sc = sc
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())   # 喺 DOM 下面：DOM 彈出視窗（手機）可以蓋住佢
	cur = r
	sc["_nat"] = true
	sc["_panning"] = func(_t, _a): return r._drag != null and r._drag.moved
	r._build()
	r._cover(true)
	return true

static func size_of() -> Array:
	if cur == null or not is_instance_valid(cur): return [390.0, 580.0]
	return [cur.stage.size.x, maxf(100.0, cur.stage.size.y)]

static func end_hook(_sc) -> void:
	if cur == null or not is_instance_valid(cur): return
	cur._cover(false)
	cur.queue_free(); cur = null

# 收起村子畫布同 DOM（喺下面，畫咗都睇唔到）；#scare 嘅 DOM 頂欄／畫布／出招列收埋
func _cover(on: bool) -> void:
	var main = get_parent()
	var sce = _el("#scare")
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and n.visible:
				n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
		# 喺 ScRun 下面、俾佢成個蓋住嘅介面（村子頂欄、資源格……）：收埋唔使白畫（手機 GPU／軟件渲染都慳）
		for c in main.get_children():   # 頂欄、資源格、底部導航、主線條（冇 script 嘅 Panel；故事、loading 等有自己 script／型別，唔郁）
			if c.get_index() >= get_index() or c.get_script() != null or not (c is Panel or c is PanelContainer): continue
			if c.visible and not _hidden.has(c): c.visible = false; _hidden.append(c)
		if sce: sce.style["background"] = "transparent"
		for id in ["#sc-top", "#sc-stage", "#sc-panel"]:
			var e = _el(id)
			if e: e.style["display"] = "none"
	else:
		for n in _hidden:
			if not is_instance_valid(n): continue
			n.visible = true
			if n.process_mode == Node.PROCESS_MODE_DISABLED: n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()
		if sce: sce.style.erase("background")

func _el(sel: String):
	var f = js("$")
	return J.cl(f, null, [sel]) if f != null else null

# ---------------- 版面 ----------------
func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg = ColorRect.new(); bg.color = Color("#0d0b10"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	# 畫面
	stage = Control.new(); stage.clip_contents = true; stage.mouse_filter = Control.MOUSE_FILTER_STOP
	stage.anchor_right = 1; stage.anchor_bottom = 1; stage.offset_top = TOP_H + safe_top; stage.offset_bottom = -200
	stage.draw.connect(_draw_stage); stage.gui_input.connect(_stage_input); add_child(stage)
	stage.resized.connect(func(): if Sc.get("active"): J.mc(Sc, "resize", []))
	# 頂欄
	top = Panel.new(); top.anchor_right = 1; top.offset_bottom = TOP_H + safe_top
	var ts = StyleBoxFlat.new(); ts.bg_color = Color("#18131d"); ts.border_color = Color("#3a2f2a"); ts.border_width_bottom = 1; top.add_theme_stylebox_override("panel", ts); add_child(top)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); hb.anchor_right = 1; hb.anchor_bottom = 1; hb.offset_left = 10; hb.offset_right = -10; hb.offset_top = 8 + safe_top; hb.offset_bottom = -8; top.add_child(hb)
	quit_b = _flat_btn(L("收工"), Color(0, 0, 0, 0.25), Color("#cbbfa8")); quit_b.custom_minimum_size = Vector2(56, 0); hb.add_child(quit_b)
	quit_b.pressed.connect(_on_quit)
	clock_l = UIKit.label("00:00", 20, Color("#9be8b0"), "sans", 900); clock_l.custom_minimum_size = Vector2(62, 0); clock_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(clock_l)
	var mana = Panel.new(); mana.size_flags_horizontal = Control.SIZE_EXPAND_FILL; mana.custom_minimum_size = Vector2(0, 18); mana.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	mana.add_theme_stylebox_override("panel", UIKit.sb(Color("#241c2c"), 9, Color("#4a3a5a"), 1)); mana.clip_contents = true; hb.add_child(mana)
	mana_fill = ColorRect.new(); mana_fill.color = Color("#6cc08e"); mana_fill.anchor_bottom = 1; mana_fill.offset_left = 1; mana_fill.offset_top = 1; mana_fill.offset_bottom = -1; mana.add_child(mana_fill)
	var ml = UIKit.label(L("陰氣"), 11, Color.WHITE, "sans", 700); ml.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ml.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; ml.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ml.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9)); mana.add_child(ml)
	kpi_l = UIKit.label("", 15, Color("#ffcf6a"), "sans", 900); kpi_l.custom_minimum_size = Vector2(84, 0); kpi_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; kpi_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(kpi_l)
	# 小地圖（全景先有）
	if _pano():
		mapc = Control.new(); mapc.anchor_right = 1; mapc.offset_left = 8; mapc.offset_right = -48; mapc.offset_top = TOP_H + safe_top + 6; mapc.offset_bottom = TOP_H + safe_top + 6 + MAP_H - 4
		mapc.mouse_filter = Control.MOUSE_FILTER_STOP; mapc.draw.connect(_draw_map); mapc.gui_input.connect(_map_input); add_child(mapc)
		follow_b = _flat_btn(L("跟"), Color(0.04, 0.03, 0.06, 0.72), Color("#4a3a5a")); follow_b.anchor_left = 1; follow_b.anchor_right = 1
		follow_b.offset_left = -42; follow_b.offset_right = -8; follow_b.offset_top = TOP_H + safe_top + 6; follow_b.offset_bottom = TOP_H + safe_top + MAP_H + 2
		follow_b.pressed.connect(func():
			Sc["follow"] = not J.t(Sc.get("follow"))
			if Sc.follow: Sc["userPan"] = -99.0
			_style_follow())
		add_child(follow_b); _style_follow()
	# 下面：人物卡＋出招列
	panel = PanelContainer.new(); panel.anchor_top = 1; panel.anchor_right = 1; panel.anchor_bottom = 1; panel.offset_top = -200
	var ps = StyleBoxFlat.new(); ps.bg_color = Color("#16111b"); ps.border_color = Color("#3a2f2a"); ps.border_width_top = 1
	ps.content_margin_left = 9; ps.content_margin_right = 9; ps.content_margin_top = 8; ps.content_margin_bottom = 8 + safe_bot
	panel.add_theme_stylebox_override("panel", ps); add_child(panel)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); panel.add_child(vb)
	tgt_box = VBoxContainer.new(); tgt_box.add_theme_constant_override("separation", 2); tgt_box.custom_minimum_size = Vector2(0, 72); vb.add_child(tgt_box)
	dock = HBoxContainer.new(); dock.add_theme_constant_override("separation", 8); dock.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_child(dock)
	_build_dock()
	_rebuild_target()

func _pano() -> bool: return J.t(J.gp(Sc.get("site"), "pano"))

func _flat_btn(t: String, bg: Color, bd: Color) -> Button:
	var b = Button.new(); b.text = t; b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 13)
	var s = UIKit.sb(bg, 6, bd, 1, Vector4(8, 4, 8, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#e8dcc0"))
	b.add_theme_color_override("font_disabled_color", Color(0.6, 0.6, 0.6, 0.6))
	return b

func _style_follow() -> void:
	if follow_b == null: return
	var on = J.t(Sc.get("follow"))
	var s = UIKit.sb(Color("#2a4a38") if on else Color(0.04, 0.03, 0.06, 0.72), 6, Color("#9be8b0") if on else Color("#4a3a5a"), 1, Vector4(4, 2, 4, 2))
	for k in ["normal", "hover", "pressed"]: follow_b.add_theme_stylebox_override(k, s)

# ---------------- 出招列 ----------------
func _build_dock() -> void:
	for c in dock.get_children(): c.queue_free()
	room_btns.clear(); ghost_btns.clear()
	var P = js("SCARE_PROPS"); var G = js("SCARE_GHOSTS"); var FW = js("FEAR_WORD")
	var col = VBoxContainer.new(); col.add_theme_constant_override("separation", 5); col.custom_minimum_size = Vector2(76, 0); dock.add_child(col)
	for k in ["lights", "ac"]:
		var p = P.get(k)
		if p == null: continue
		var b = _flat_btn("", Color("#2a2232"), Color("#5a4a6a")); b.custom_minimum_size = Vector2(76, 44); b.clip_text = true
		var lb = UIKit.rich("", 12, Color("#e8dcc0")); lb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lb.fit_content = false; lb.scroll_active = false; lb.add_theme_constant_override("line_separation", -2); b.add_child(lb)
		var kk = k
		b.pressed.connect(func():
			if J.t(Sc.get("paused")) or J.num(Sc.get("endAt", 0)) > 0: return
			J.mc(Sc, "useProp", [kk]); _dock_sig = "")
		col.add_child(b); room_btns[k] = {"b": b, "l": lb}
	for k in Sc.team:
		var g = G.get(k)
		if g == null: continue
		var b = Button.new(); b.custom_minimum_size = Vector2(0, 92); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.clip_contents = true
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_top = 6; vb.offset_bottom = -4; vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vb.add_theme_constant_override("separation", 1); b.add_child(vb)
		var pr = TextureRect.new(); pr.custom_minimum_size = Vector2(44, 44); pr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var r = Art.portrait_region(k)
		if r.size(): var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; pr.texture = at
		vb.add_child(pr)
		var nm = UIKit.label(L(g.skill), 13, Color("#f0e6ff"), "sans", 900); nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nm.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(nm)
		var ty: Array = g.get("types", [g.type]) if g.get("types") is Array else [g.type]
		var tw = []
		for t in ty: tw.append(J.str(FW.get(t, t)).right(2) if FW.has(t) else J.str(t))
		var sub = UIKit.label("", 11, Color(0.93, 0.9, 1, 0.7)); sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sub.mouse_filter = Control.MOUSE_FILTER_IGNORE; sub.clip_text = true; vb.add_child(sub)
		var subt = L(g.name) + "・" + "／".join(tw.map(func(x): return L(x))) + ("・" + L("全場") if J.t(g.get("aoe")) else "")
		var cdr = ColorRect.new(); cdr.color = Color(0, 0, 0, 0.6); cdr.anchor_right = 1; cdr.anchor_top = 1; cdr.anchor_bottom = 1; cdr.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(cdr)
		var kk = k
		b.pressed.connect(func(): _ghost_press(kk))
		dock.add_child(b); ghost_btns[k] = {"b": b, "sub": sub, "subt": subt, "cd": cdr}
	_dock_sig = ""

func _ghost_press(k: String) -> void:
	var caught = Sc.get("caught", {}); var cd = Sc.get("cd", {})
	if J.t(caught.get(k)) or J.num(cd.get(k, 0)) > 0 or J.t(Sc.get("paused")) or J.num(Sc.get("endAt", 0)) > 0: return
	var g = js("SCARE_GHOSTS").get(k); var sel = Sc.get("sel")
	if J.t(g.get("aoe")): J.mc(Sc, "useGhost", [k]); Sc["armed"] = null
	elif sel is Dictionary and not J.t(sel.get("gone")) and not J.t(sel.get("out")) and not J.t(J.gp(sel.d, "guard")): J.mc(Sc, "useGhost", [k, sel]); Sc["armed"] = null
	else:
		Sc["armed"] = null if J.str(Sc.get("armed")) == k else k
		J.mc(Sc, "toast", [L("點一個人")])
	_dock_sig = ""

func _update_dock() -> void:
	var P = js("SCARE_PROPS"); var G = js("SCARE_GHOSTS"); var mana = J.num(Sc.get("mana", 0)); var pcd = Sc.get("pcd", {}); var cd = Sc.get("cd", {}); var caught = Sc.get("caught", {})
	var room = J.str(J.gp(J.mc(Sc, "camRoom", []), "name")) if _pano() else "全場"
	var armed = J.str(Sc.get("armed"))
	var sig = "%d|%s|%s" % [int(mana), room, armed]
	for k in room_btns: sig += "|%d" % ceil(J.num(pcd.get(k, 0)) if pcd is Dictionary else 0.0)
	for k in ghost_btns: sig += "|%d%s" % [int(J.num(cd.get(k, 0)) * 10), "c" if J.t(caught.get(k)) else ""]
	if sig == _dock_sig: return
	_dock_sig = sig
	for k in room_btns:
		var p = P.get(k); var c = J.num(pcd.get(k, 0)) if pcd is Dictionary else 0.0; var R = room_btns[k]
		var small = (L("冷卻") + " %d " % ceil(c) + L("秒")) if c > 0 else "%s・%d" % [L(room), int(J.num(p.cost))]
		R.l.text = "[center][b]%s[/b]\n[font_size=11]%s[/font_size][/center]" % [L(p.name), small]
		R.b.modulate.a = 0.5 if c > 0 or mana < J.num(p.cost) else 1.0
	for k in ghost_btns:
		var R = ghost_btns[k]; var g = G.get(k); var c = J.num(cd.get(k, 0)); var ct = J.t(caught.get(k))
		R.sub.text = L("喝茶中") if ct else R.subt
		R.cd.anchor_top = 1.0 - (1.0 if ct else clampf(c / 22.0, 0, 1))
		var low = mana < J.num(g.get("cost", 35))
		var arm = armed == k
		var s = UIKit.sb(Color("#3a2440"), 12, Color("#ffcf6a") if arm else Color("#8a5a9a"), 2 if arm else 1)
		for st in ["normal", "hover", "pressed"]: R.b.add_theme_stylebox_override(st, s)
		R.b.modulate = Color(0.55, 0.55, 0.55, 0.5) if ct else Color(1, 1, 1, 0.6 if low and c <= 0 else 1.0)

# ---------------- 人物卡 ----------------
func _target_sig() -> String:
	var n = Sc.get("sel")
	if not (n is Dictionary) or J.t(n.get("gone")) or J.t(n.get("fleeing")): return "none"
	var ops = js("ScareOps"); var c = J.to_json(J.cl(ops.ctx, null, [Sc, n])) if ops != null else ""
	var known = Sc.get("known", {}); var kn = known.get(J.str(n.d.k)) if known is Dictionary else null
	return "%s|%s|%s|%s|%s" % [J.str(n.d.k), J.t(n.get("out")), J.t(n.get("left")), c, J.to_json(kn)]

func _rebuild_target() -> void:
	_tgt_sig = _target_sig()
	for c in tgt_box.get_children(): c.queue_free()
	var n = Sc.get("sel")
	if _tgt_sig == "none":
		var l = UIKit.label(L("點場景裡的人，或發光的東西。"), 12, Color(0.9, 0.86, 1, 0.65)); tgt_box.add_child(l); return
	var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 6); tgt_box.add_child(row)
	var nm = UIKit.label(L(n.d.name), 16, Color("#f4ecff"), "sans", 900); nm.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; row.add_child(nm)
	var out = J.t(n.get("out"))
	var rl = UIKit.label(L(("已經走了" if J.t(n.get("left")) else "暫時不在") if out else J.str(n.d.role)), 11, Color(0.85, 0.8, 0.95, 0.7)); rl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	rl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; rl.clip_text = true; row.add_child(rl)
	var ops = js("ScareOps")
	if ops != null and not out:
		var O = ops.OPS.get(J.str(n.d.k)); var cx = J.cl(ops.ctx, null, [Sc, n])
		if O is Dictionary:
			if O.get("apps") != null: row.add_child(_op_btn(L("手機"), false, func(): J.cl(ops.openPhone, null, [Sc, n]); _check_modal()))
			if J.t(cx.get("atDesk")): row.add_child(_op_btn(L("電腦"), true, func(): J.cl(ops.openPC, null, [Sc, n]); _check_modal()))
			if J.t(cx.get("pantry")) and not J.t(J.gp(n.d, "guard")): row.add_child(_op_btn(L("茶水間"), true, func(): J.cl(ops.openPantry, null, [Sc, n]); _check_modal()))
	var br = _op_btn(L("背後呼氣"), true, func(): J.mc(Sc, "useBreath", [n])); br.disabled = out; row.add_child(br)
	var pf = UIKit.rich(_html_bb(J.str(J.mc(Sc, "profile", [n]))), 13, Color("#e8e0f0")); pf.fit_content = true; pf.scroll_active = false
	tgt_box.add_child(pf)

func _op_btn(t: String, gold: bool, f: Callable) -> Button:
	var b = _flat_btn(t, Color("#bb3427") if gold else Color("#3a2c26"), Color("#f2a080") if gold else Color("#6a5040"))
	b.add_theme_font_size_override("font_size", 12); b.custom_minimum_size = Vector2(0, 30); b.pressed.connect(f); return b

static func _html_bb(h: String) -> String:
	var s = DB.L(h) if DB.L(h) is String else h
	var rx = RegEx.create_from_string("<b style=\"color:(#[0-9a-fA-F]+)\">([^<]*)</b>"); s = rx.sub(s, "[b][color=$1]$2[/color][/b]", true)
	# 逐段翻譯：「怕：」「唔怕：」等
	for k in ["怕：", "唔怕：", "（全場燈／冷氣都唔怕）", "乜都唔怕", "（做咗三十年夜班）"]: s = s.replace(k, J.str(DB.L(k)))
	return JSBridge.html2bb(s.replace("<b>", "[b]").replace("</b>", "[/b]"))

# ---------------- 每幀 ----------------
var prof_d := 0
var prof_p := 0
var prof_n := 0
func _process(dt: float) -> void:
	if not J.t(Sc.get("active")):
		return
	var _pt0 = Time.get_ticks_usec()
	_process2(dt)
	prof_p += Time.get_ticks_usec() - _pt0
func _process2(dt: float) -> void:
	stage.queue_redraw()
	if mapc: mapc.queue_redraw()
	var t = J.num(Sc.get("t", 0))
	var mins = mini(360, int(floor(t / 180.0 * 360.0)))
	clock_l.text = "%02d:%02d" % [mins / 60, (mins % 60) / 10 * 10]
	kpi_l.text = "%s %d" % [L("驚嚇"), int(J.num(Sc.get("kpi", 0)))]
	var mp = mana_fill.get_parent() as Control
	mana_fill.offset_right = maxf(1.0, (mp.size.x - 2) * clampf(J.num(Sc.get("mana", 0)) / 100.0, 0, 1))
	if _quit_arm > 0:
		_quit_arm -= dt
		if _quit_arm <= 0: quit_b.text = L("收工")
	_update_dock()
	if _target_sig() != _tgt_sig: _rebuild_target()
	if ops_layer != null and not J.t(Sc.get("paused")): ScOps.close_ui(self)
	_check_modal()

# 手機／電腦彈出視窗（DOM）：開咗就臨時顯示返 DOM
func _check_modal() -> void:
	var p = _el("#sc-phone")
	var on = p != null and p.classList.d.has("on")
	if on == _modal: return
	_modal = on
	var dom = get_parent().get("dom")
	if dom:
		dom.visible = on; dom.process_mode = Node.PROCESS_MODE_INHERIT if on else Node.PROCESS_MODE_DISABLED
	if not on: _rebuild_target()

func _on_quit() -> void:
	if _quit_arm <= 0:
		_quit_arm = 2.5; quit_b.text = L("確定？"); return
	_quit_arm = 0
	J.mc(Sc, "finish", [true])

# ---------------- 畫面 ----------------
func _draw_stage() -> void:
	if not J.t(Sc.get("active")) or OS.has_environment("GB_NOSTAGE"): return
	var ctx = Ctx.new(stage)
	Sc["_natCtx"] = ctx
	var t0 = Time.get_ticks_usec()
	var cp = OS.has_environment("GB_CTXPROF") and prof_n == 29
	if cp: J.CTXPROF.clear(); J.CTXPROF_ON = true
	if OS.has_environment("GB_PROF"): mark("pre")
	ScOffice.frame_begin(Sc)
	J.mc(Sc, "draw", [Time.get_ticks_msec() / 1000.0])
	ScOffice.FR = null
	if cp:
		J.CTXPROF_ON = false; var ks = J.CTXPROF.keys().filter(func(k): return not k.begins_with("#"))
		ks.sort_custom(func(a, b): return J.CTXPROF[a] > J.CTXPROF[b])
		var tot = 0
		for k in ks: tot += J.CTXPROF[k]
		print("[ctx] total=%.1fms " % (tot / 1000.0), ", ".join(ks.slice(0, 12).map(func(k): return "%s %.1f(%d)" % [k, J.CTXPROF[k] / 1000.0, J.CTXPROF["#" + k]])))
	Sc["_natCtx"] = null
	if OS.has_environment("GB_PROF"):
		prof_d += Time.get_ticks_usec() - t0; prof_n += 1
		if _mk_prev != "": _mk[_mk_prev] = _mk.get(_mk_prev, 0) + Time.get_ticks_usec() - _mk_last; _mk_prev = ""
		if prof_n >= 30:
			print("[scare] js_timers=%.1fms " % (JSRun.prof_timer / 30000.0)); JSRun.prof_timer = 0
			print("[scare] draw=%.1fms proc=%.1fms " % [prof_d / 30000.0, prof_p / 30000.0], ", ".join(_mk.keys().map(func(k): return "%s=%.1f" % [k, _mk[k] / 30000.0])))
			prof_d = 0; prof_p = 0; prof_n = 0; _mk.clear()

func _unit() -> float:
	var b = J.mc(Sc, "bgScale", [])
	return J.num(b.iw) * J.num(b.s)

func _stage_input(ev: InputEvent) -> void:
	var p := Vector2.ZERO; var kind := ""
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT: p = ev.position; kind = "down" if ev.pressed else "up"
	elif ev is InputEventMouseMotion and (ev.button_mask & MOUSE_BUTTON_MASK_LEFT): p = ev.position; kind = "move"
	elif ev is InputEventScreenTouch: return
	elif ev is InputEventScreenDrag: return
	else: return
	var now = Time.get_ticks_msec()
	if not _pano():
		if kind == "down": J.mc(Sc, "tap", [{"clientX": p.x, "clientY": p.y}])
		return
	match kind:
		"down":
			_drag = {"x0": p.x, "c0": J.num(Sc.get("camX", 0)), "moved": false, "lx": p.x, "lt": now}
			Sc["camV"] = 0.0
		"move":
			if _drag == null: return
			var dx = p.x - _drag.x0
			if not _drag.moved and absf(dx) > 9: _drag.moved = true
			if _drag.moved:
				var u = _unit(); var dtm = maxf(16.0, now - _drag.lt)
				Sc["camX"] = J.num(J.mc(Sc, "clampCam", [_drag.c0 - dx / u]))
				Sc["camV"] = clampf(0.7 * J.num(Sc.get("camV", 0)) + 0.3 * (-(p.x - _drag.lx) / u) / (dtm / 1000.0), -2.5, 2.5)
				_drag.lx = p.x; _drag.lt = now; Sc["userPan"] = J.num(Sc.get("t", 0))
		"up":
			if _drag == null: return
			var was = _drag; _drag = null
			if not was.moved:
				Sc["camV"] = 0.0; J.mc(Sc, "tap", [{"clientX": p.x, "clientY": p.y}]); _dock_sig = ""
			else:
				if now - was.lt > 90 or absf(p.x - was.x0) < 40: Sc["camV"] = 0.0
				Sc["userPan"] = J.num(Sc.get("t", 0))

# ---------------- 小地圖 ----------------
func _draw_map() -> void:
	var OM = js("OFFMAP"); if OM == null: return
	var W = mapc.size.x; var H = mapc.size.y; var WW = J.num(OM.WW)
	var f = UIKit.font("sans", 700)
	mapc.draw_style_box(UIKit.sb(Color(0.04, 0.03, 0.06, 0.72), 8, Color("#4a3a5a"), 1), Rect2(0, 0, W, H))
	var cr = J.str(J.gp(J.mc(Sc, "camRoom", []), "k"))
	for r in OM.ROOMS:
		var x0 = J.num(r.x0) / WW * W; var x1 = J.num(r.x1) / WW * W
		if J.str(r.k) == cr: mapc.draw_rect(Rect2(x0, 1, x1 - x0, H - 2), Color(0.63, 1, 0.78, 0.08))
		if x1 < W - 2: mapc.draw_line(Vector2(x1, 2), Vector2(x1, H - 2), Color(1, 1, 1, 0.18))
		mapc.draw_string(f, Vector2(x0 + 3, H - 3), L(SHORT.get(J.str(r.k), J.str(r.name))), HORIZONTAL_ALIGNMENT_LEFT, x1 - x0 - 4, 9, Color(0.86, 0.82, 0.94, 0.55))
	# 鏡頭範圍
	var vx = J.num(Sc.get("camX", 0)) / WW * W; var vw = J.num(J.mc(Sc, "viewW", [])) / WW * W
	mapc.draw_rect(Rect2(vx, 1, vw, H - 2), Color(0.6, 1, 0.78, 0.9), false, 1.5)
	# 人
	var sel = Sc.get("sel"); var wit = []
	if sel is Dictionary and not J.t(sel.get("gone")) and not J.t(sel.get("out")): wit = J.mc(Sc, "witnesses", [sel])
	else: sel = null
	for n in Sc.npcs:
		if J.t(n.get("gone")) or J.t(n.get("out")): continue
		var fr = J.num(n.get("fear", 0)); var d = n.d
		var col = Color("#c070ff") if J.t(n.get("fleeing")) else Color("#ff5a4a") if fr >= 50 else Color("#ffb84a") if fr >= 25 else Color("#8ab0d0") if J.t(d.get("guard")) else Color("#ffd36a") if J.t(d.get("daoshi")) else Color("#7fd6a0")
		var x = clampf(J.num(n.x), 0.6, WW - 0.06) / WW * W; var y = H * 0.42
		mapc.draw_circle(Vector2(x, y), 6.5, col)
		if n == sel: mapc.draw_arc(Vector2(x, y), 8.5, 0, TAU, 20, Color("#ffd84a"), 2)
		elif wit.has(n): mapc.draw_arc(Vector2(x, y), 8.5, 0, TAU, 20, Color("#ff5a4a"), 2)
		var ch = L(DOTCH.get(J.str(d.k), J.str(d.name).left(1)))
		mapc.draw_string(f, Vector2(x - 6, y + 4), ch, HORIZONTAL_ALIGNMENT_CENTER, 12, 9, Color("#1a1020"))

func _map_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
		var OM = js("OFFMAP"); var x = ev.position.x / mapc.size.x * J.num(OM.WW)
		Sc["camV"] = 0.0; Sc["camTo"] = J.num(J.mc(Sc, "clampCam", [x - J.num(J.mc(Sc, "viewW", [])) / 2.0])); Sc["userPan"] = J.num(Sc.get("t", 0))
		mapc.accept_event()

# ---------------- 測試 ----------------
static func t_act(i: int) -> void:
	if cur == null: print("t_act: no run"); return
	var S = cur.Sc; var npcs: Array = S.npcs
	var ken = null
	for n in npcs: if J.str(n.d.k) == "ken": ken = n
	match i:
		0: S["sel"] = ken; J.mc(S, "useBreath", [ken])
		1: S["mana"] = 100.0; J.mc(S, "useGhost", [S.team[1], ken])
		2: S["mana"] = 100.0; J.mc(S, "useProp", ["lights"])
		3: S["mana"] = 100.0; J.mc(S, "useGhost", [S.team[2], ken])
		4: J.mc(S, "finish", [false])
		5: S["sel"] = ken; cur._rebuild_target()
		6: S["sel"] = ken; J.cl(js("ScareOps").openPhone, null, [S, ken])
		7: J.cl(js("ScareOps").openPhone, null, [S, ken, "photo"])
		8: J.cl(js("ScareOps").compose, null, [S, ken])
		9: S["mana"] = 100.0; J.cl(js("ScareOps").act, null, [S, ken, js("ScareOps").OPS.ken.msgs[1], "msg"])
		10: S["sel"] = ken; J.cl(js("ScareOps").openPC, null, [S, ken])
	print("t_act ", i, " kpi=", S.kpi, " ken.fear=", ken.fear, " t=", S.get("t"), " clock=", cur.clock_l.text if cur else "")
