# 夜班巡陰：選單介面（準備畫面、揀帶隊主管、裝備房）Godot 原生版（線路 C）
# JS 嘅 Patrol.openPrep / Gear.open 經 patches.js 轉呼叫 __nat_patrolMenu → 呢度。
# 數據、動作仍然用轉譯咗嘅 JS 運行庫（J.G）。
extends Node

const PAPER := Color("#ecd9a4")
const CARD := Color(1, 0.97, 0.88, 0.6)
const LINE := Color("#b89a52")
const INK := Color("#2b1d12")
const DIM := Color("#6e5838")
const RED := Color("#c2362b")
const CN := "一二三四五六"

var layer: CanvasLayer
var panel: Panel
var title_lbl: Label
var scroll: ScrollContainer
var body: VBoxContainer
var gear_tab := "wea"
var gear_back = null   # JS 回呼（返準備畫面）

func _process(_dt: float) -> void:
	if J.G.get("__nat_patrolMenu") == null:
		J.G["__nat_patrolMenu"] = func(_t, a): return _hook(a)

func _hook(a: Array) -> bool:
	var kind := J.str(a[0]) if a.size() else ""
	if kind == "prep": call_deferred("open_prep"); return true
	if kind == "gear": gear_back = a[1] if a.size() > 1 else null; call_deferred("_show_gear"); return true
	return false

# ---------------- JS 小幫手 ----------------
func g(k: String): return J.G.get(k)
func m(o, f: String, args := []): return J.mc(o, f, args)
func menu(): return J.gp(g("Patrol"), "_menu")
func gmenu(): return J.gp(g("Gear"), "_menu")
func T(yue: String, zh: String) -> String: return J.str(m(g("GP"), "T", [yue, zh]))
func fmt(v) -> String: return J.str(J.cl(g("fmt"), null, [v]))
func save() -> void: J.cl(g("save"), null, [])
func strip(h: String) -> String:
	var re = RegEx.new(); re.compile("<[^>]+>"); return re.sub(h, "", true)
func fcol(f: String) -> String: return J.str(J.gp(J.gp(J.gp(menu(), "FAC"), f), "col"))

# ---------------- 外框 ----------------
func _ensure() -> void:
	if layer and is_instance_valid(layer): return
	layer = CanvasLayer.new(); layer.layer = 40; get_tree().root.add_child(layer)
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.45); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); layer.add_child(dim)
	panel = Panel.new(); panel.anchor_right = 1; panel.anchor_top = 0.07; panel.anchor_bottom = 1
	var s = UIKit.sb(PAPER, 10); s.corner_radius_bottom_left = 0; s.corner_radius_bottom_right = 0; s.shadow_color = Color(0, 0, 0, 0.6); s.shadow_size = 20
	panel.add_theme_stylebox_override("panel", s); layer.add_child(panel)
	var head = HBoxContainer.new(); head.anchor_right = 1; head.offset_left = 16; head.offset_right = -12; head.offset_top = 10; head.offset_bottom = 52; panel.add_child(head)
	title_lbl = UIKit.label("", 23, INK, "serif", 900); title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; head.add_child(title_lbl)
	var cl = UIKit.btn("✕", "ghost", true); cl.custom_minimum_size = Vector2(40, 40); cl.pressed.connect(close); head.add_child(cl)
	var line = ColorRect.new(); line.color = LINE; line.anchor_right = 1; line.offset_top = 56; line.offset_bottom = 57.5; panel.add_child(line)
	scroll = ScrollContainer.new(); scroll.anchor_right = 1; scroll.anchor_bottom = 1; scroll.offset_top = 60; scroll.offset_left = 12; scroll.offset_right = -12; scroll.offset_bottom = -8
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; panel.add_child(scroll)
	body = VBoxContainer.new(); body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; body.add_theme_constant_override("separation", 8); scroll.add_child(body)

func _sheet(t: String, keep_scroll := false) -> void:
	_ensure(); layer.visible = true; title_lbl.text = t
	var sc = scroll.scroll_vertical if keep_scroll else 0
	for c in body.get_children(): body.remove_child(c); c.queue_free()
	if keep_scroll: (func(): await get_tree().process_frame; await get_tree().process_frame; scroll.scroll_vertical = sc).call()
	else: scroll.scroll_vertical = 0

func close() -> void:
	if layer and is_instance_valid(layer): layer.visible = false

func is_open() -> bool: return layer != null and is_instance_valid(layer) and layer.visible

func _p(bb: String, size := 15, col := DIM) -> RichTextLabel:
	var r = UIKit.rich(bb, size, col); body.add_child(r); return r

func _card(alpha := 0.6, pad := Vector4(10, 8, 10, 8)) -> PanelContainer:
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, alpha), 5, LINE, 1, pad)); return pc

func _btn(t: String, kind := "", small := true, f := Callable(), enabled := true) -> Button:
	var b = UIKit.btn(t, kind, small); b.disabled = not enabled
	b.add_theme_font_size_override("font_size", 15 if small else 17)
	if f.is_valid(): b.pressed.connect(f)
	return b

func _mats_row(extra: Array) -> void:
	var mats = J.gp(m(menu(), "st"), "mats"); var fac = J.gp(menu(), "FAC")
	var bits = []
	for f in ["yuan", "chan", "lan"]:
		var d = J.gp(fac, f); bits.append("[color=%s][b]%s[/b] %s[/color]" % [J.str(J.gp(d, "col")), J.str(J.gp(d, "mat")), fmt(J.gp(mats, f))])
	for e in extra: bits.append("[b]%s[/b] %s" % e)
	var pc = _card(0.85, Vector4(10, 6, 10, 6)); var r = UIKit.rich("　".join(bits), 15, INK); pc.add_child(r); body.add_child(pc)

# ---------------- 準備畫面 ----------------
func open_prep() -> void:
	var M = menu(); if M == null: return
	m(M, "restRecover"); m(g("UI"), "close")
	var p = m(M, "st")
	if not J.t(J.gp(p, "introSeen")):
		close(); m(M, "intro", [func(_t, _a): open_prep(); return null]); return
	_render_prep()

func _render_prep(keep := false) -> void:
	var M = menu(); var S = g("S"); var p = m(M, "st")
	_sheet("夜班巡陰", keep)
	_p(T("帶部門出去巡邏。打倒嘅遊魂：[b]送去投胎[/b]（冥幣＋執念）或者[b]遞合約[/b]收編（要編制同壽包）。部門主管同區域總監就係主線關卡。", "帶部門出去巡邏。打倒的遊魂：[b]送去投胎[/b]（冥幣＋執念）或[b]遞合約[/b]收編（要編制和壽包）。部門主管和區域總監就是主線關卡。"), 15)
	_mats_row([["壽包", fmt(J.gp(J.gp(S, "res"), "buns"))]])
	# 部門
	var box = _card(0.55, Vector4(10, 10, 10, 10)); var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 8); box.add_child(vb); body.add_child(box)
	var hb = HBoxContainer.new(); vb.add_child(hb)
	var t = UIKit.label("我的部門", 18, INK, "serif", 900); t.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(t)
	hb.add_child(_btn("裝備房", "", true, func(): m(g("Gear"), "open", [func(_t, _a): open_prep(); return null])))
	var leads: Array = m(M, "leads")
	var lr = HBoxContainer.new(); lr.add_theme_constant_override("separation", 8); vb.add_child(lr)
	for i in 3:
		var slot = Button.new(); slot.custom_minimum_size = Vector2(0, 112); slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot.add_theme_stylebox_override("normal", UIKit.sb(Color(1, 0.98, 0.9, 0.75), 6, LINE, 1)); slot.add_theme_stylebox_override("hover", UIKit.sb(Color(1, 0.99, 0.93, 0.9), 6, LINE, 1)); slot.add_theme_stylebox_override("pressed", UIKit.sb(Color(0.95, 0.9, 0.78), 6, LINE, 1)); slot.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var inner = VBoxContainer.new(); inner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); inner.alignment = BoxContainer.ALIGNMENT_CENTER; inner.mouse_filter = Control.MOUSE_FILTER_IGNORE; slot.add_child(inner)
		if i < leads.size():
			var gh = leads[i]; var por = UIKit.portrait(J.str(J.gp(gh, "k")), 58); por.mouse_filter = Control.MOUSE_FILTER_IGNORE; por.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; inner.add_child(por)
			var nl = UIKit.label(J.str(J.gp(gh, "name")), 15, INK, "sans", 900); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nl.mouse_filter = Control.MOUSE_FILTER_IGNORE; inner.add_child(nl)
			var pl = UIKit.label("%s %s" % [T("鬼力", "鬼力"), J.str(m(g("GP"), "pow", [gh]))], 13, DIM); pl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; pl.mouse_filter = Control.MOUSE_FILTER_IGNORE; inner.add_child(pl)
		else:
			var el = UIKit.label("＋\n帶隊主管", 15, DIM); el.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; el.mouse_filter = Control.MOUSE_FILTER_IGNORE; inner.add_child(el)
		var ii = i; slot.pressed.connect(func(): pick_lead(ii)); lr.add_child(slot)
	var crew: Array = m(M, "crewList")
	vb.add_child(UIKit.rich("組員 [b]%d[/b]／編制 %s（民宅越高級編制越多）　陰兵 %s 隊（每 25 個一隊，最多 4 隊）" % [crew.size(), J.str(m(M, "crewCap")), J.str(m(M, "troopTeams"))], 14, DIM))
	if crew.size():
		var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6); vb.add_child(fl)
		for c in crew: fl.add_child(_crew_chip(c))
	else:
		vb.add_child(UIKit.rich("（村裡沒有閒置的雜鬼。先去招魂台招，或在巡邏中收編。）", 14, DIM))
	var all = (J.gp(S, "ghosts") as Array).filter(func(x): var q = J.str(J.gp(x, "q")); return q == "藍" or q == "紫")
	var busy = all.filter(func(x): return J.t(J.gp(x, "post"))).size()
	var tired = all.filter(func(x): return not J.t(J.gp(x, "post")) and J.num(J.gp(x, "fat")) >= 100).size()
	var poached = all.filter(func(x): return J.t(J.gp(x, "poached"))).size()
	if busy or tired or poached:
		var note = ""
		if busy: note += "%d 隻派了工，留在村裡做事。" % busy
		if tired: note += "%d 隻過勞請病假（在村裡休息會慢慢恢復）。" % tired
		if poached: note += "[color=#c2362b][b]%d 隻被 Bryan 挖角[/b][/color]：在巡邏中打贏 Bryan 部門就能搶回來。" % poached
		vb.add_child(UIKit.rich(note, 14, DIM))
	# 區域
	var chs: Array = g("CHAPTERS")
	for ci in chs.size(): body.add_child(_region_card(ci))
	var seen = J.gp(S, "seen")
	if J.t(J.gp(seen, "ch1_end")) and g("Sports") != null:
		var sc = _card(0.7); var sh = HBoxContainer.new(); sc.add_child(sh)
		var st = UIKit.rich("[b]陰間運動會[/b]\n[font_size=13]殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳[/font_size]", 16, INK); st.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sh.add_child(st)
		sh.add_child(_btn("參加", "gold", false, func(): close(); m(g("UI"), "close"); m(g("Sports"), "open")))
		body.add_child(sc)
	var ac = CheckBox.new(); ac.text = "自動送去投胎（不用逐隻選；遞合約要手動）"; ac.button_pressed = J.t(J.gp(p, "auto"))
	ac.add_theme_font_size_override("font_size", 15); ac.add_theme_color_override("font_color", INK); ac.add_theme_color_override("font_pressed_color", INK); ac.add_theme_color_override("font_hover_color", INK); ac.add_theme_color_override("font_hover_pressed_color", INK)
	ac.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ac.toggled.connect(func(on): J.sp(p, "auto", on); save()); body.add_child(ac)
	var sp = Control.new(); sp.custom_minimum_size = Vector2(0, 30); body.add_child(sp)

func _crew_chip(c) -> Control:
	var M = menu(); var k = J.str(J.gp(c, "k"))
	var box = Control.new(); box.custom_minimum_size = Vector2(54, 70)
	var bg = Panel.new(); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.98, 0.9, 0.8), 5, LINE, 1)); box.add_child(bg)
	var por = UIKit.portrait(k, 46); por.position = Vector2(4, 3); box.add_child(por)
	var fc = ColorRect.new(); fc.color = Color(fcol(J.str(m(M, "facOf", [k])))); fc.position = Vector2(4, 50); fc.size = Vector2(46, 4); box.add_child(fc)
	var fat = clampf(J.num(J.gp(c, "fat")), 0, 100)
	var fb = ColorRect.new(); fb.color = RED; fb.position = Vector2(4, 54); fb.size = Vector2(46 * fat / 100.0, 3); box.add_child(fb)
	var lv = UIKit.label("Lv%s" % J.str(m(g("F"), "glv", [c])), 11, INK, "sans", 900); lv.position = Vector2(4, 55); lv.size = Vector2(46, 14); lv.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; box.add_child(lv)
	box.tooltip_text = J.str(J.gp(c, "name"))
	return box

func _region_card(ci: int) -> Control:
	var M = menu(); var S = g("S"); var ch = (g("CHAPTERS") as Array)[ci]
	var open = J.t(m(M, "regionOpen", [ci])); var r = m(M, "regSt", [ci]); var stages: Array = J.gp(ch, "stages"); var cleared = J.gp(S, "cleared")
	var n = 0
	for si in stages.size():
		if J.t(J.gp(cleared, J.str(m(M, "sidOf", [ci, si])))): n += 1
	var cur = open and n < 3
	var pc = PanelContainer.new()
	var bgc = Color(1, 0.96, 0.85, 0.75) if open else Color(0.85, 0.8, 0.68, 0.45)
	pc.add_theme_stylebox_override("panel", UIKit.sb(bgc, 6, RED if cur else LINE, 2 if cur else 1, Vector4(12, 9, 12, 10)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); pc.add_child(vb)
	var name := "第%s區・%s" % [CN[ci], J.str(J.gp(ch, "name"))]
	if not open:
		vb.add_child(UIKit.rich("[b]%s[/b]　🔒\n[font_size=13]打完上一區總監才開放[/font_size]" % name, 16, Color(INK, 0.55)))
		return pc
	m(M, "setMir", [ci]); m(M, "mkFaci")
	var st0 = J.num(m(M, "startZ", [ci])); var kings = J.gp(r, "kings"); var lm = J.gp(r, "lm"); var sta = J.gp(r, "sta")
	var kn = (J.keys(kings) as Array).size() + n; var lmn = (J.keys(lm) as Array).size() if lm != null else 0
	var lmt = (J.gp(J.gp(M, "LMNAME"), ci) as Array).size()
	var stg = stages[min(2, n)]; var need = J.str(m(g("GP"), "stageNeed", [stg, m(M, "sidOf", [ci, min(2, n)])]))
	var req = J.str(J.gp(stages[0], "req"))
	vb.add_child(UIKit.rich("[b]%s[/b]\n[font_size=13]地頭 %d/9　地標 %d/%d　主線 %d/3　%s %s　需主公 Lv%s[/font_size]" % [name, kn, lmn, lmt, n, T("建議鬼力", "建議鬼力"), need, req], 16, INK))
	var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6); vb.add_child(fl)
	var faci: Array = m(M, "faci"); var tn = J.gp(J.gp(M, "TNAME"), ci)
	for f in faci:
		if J.str(J.gp(f, "t")) != "station": continue
		var z = J.num(J.gp(f, "z"))
		if z != st0 and not J.t(J.gp(sta, J.str(z))): continue
		var lab = "出發" if z == st0 else "%s站" % J.str(J.gp(tn, m(M, "terOf", [z])))
		var cci = ci; var zz = z
		fl.add_child(_btn(lab, "gold" if (cur and z == st0) else "", true, func(): go(cci, zz)))
	return pc

func go(ci: int, z: float) -> void:
	close()
	var np = get_tree().root.get_node_or_null("NPatrol")
	if np and np.has_method("begin"): np.begin(ci, z); return
	m(menu(), "start", [float(ci), z])

# ---------------- 揀帶隊主管 ----------------
func pick_lead(i: int) -> void:
	var M = menu(); var S = g("S"); var p = m(M, "st")
	var cur = (m(M, "leads") as Array).map(func(x): return J.gp(x, "id"))
	var now = cur[i] if i < cur.size() else null
	var list = (J.gp(S, "ghosts") as Array).filter(func(x): return J.str(J.gp(x, "q")) == "名")
	list.sort_custom(func(a, b): return J.num(m(g("GP"), "pow", [a])) > J.num(m(g("GP"), "pow", [b])))
	_sheet("帶隊主管")
	_p("選帶隊主管（最多 3 隻）。主管不佔編制，倒下 25 秒後自動歸隊。")
	var setf = func(id):
		var arr: Array = cur.duplicate()
		while arr.size() < 3: arr.append(null)
		var j = arr.find(id) if id != null else -1
		if j >= 0: arr[j] = arr[i]
		arr[i] = id
		J.sp(p, "lead", arr.filter(func(x): return x != null)); save(); _render_prep()
	if now != null:
		var e = _card(0.5); var eb = _btn("— 空著 —", "ghost", false, func(): setf.call(null)); e.add_child(eb); body.add_child(e)
	var skills = g("SKILLS")
	for gh in list:
		var id = J.gp(gh, "id"); var k = J.str(J.gp(gh, "k")); var sk = J.gp(skills, k)
		var pc = _card(0.85 if id == now else 0.55); var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); pc.add_child(hb)
		hb.add_child(UIKit.portrait(k, 60))
		var f = J.str(m(M, "facOf", [k])); var fd = J.gp(J.gp(M, "FAC"), f)
		var txt = "[b]%s[/b]%s\n[font_size=13]Lv%s　[b]%s %s[/b]　[color=%s]%s[/color][/font_size]" % [J.str(J.gp(gh, "name")), "　[bgcolor=#c2362b][color=#fff] 帶隊中 [/color][/bgcolor]" if cur.has(id) else "", J.str(m(g("F"), "glv", [gh])), T("鬼力", "鬼力"), J.str(m(g("GP"), "pow", [gh])), J.str(J.gp(fd, "col")), J.str(J.gp(fd, "name"))]
		if sk != null: txt += "\n[font_size=13][color=#2e5d55]【%s】%s[/color][/font_size]" % [J.str(J.gp(sk, "name")), J.str(J.gp(sk, "desc"))]
		var info = UIKit.rich(txt, 16, INK); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
		var idd = id; hb.add_child(_btn("揀", "gold" if id != now else "", true, func(): setf.call(idd), id != now))
		body.add_child(pc)
	body.add_child(_btn("返回", "", false, func(): _render_prep()))

# ---------------- 裝備房 ----------------
func open_gear(back = null) -> void:
	# 經 JS（等 Gear._menu 準備好）
	m(g("Gear"), "open", [back if back != null else func(_t, _a): open_prep(); return null])

func _show_gear(keep := false) -> void:
	var GM = gmenu(); var M = menu(); var S = g("S"); if GM == null: return
	var s = m(GM, "st"); var slots = J.gp(GM, "SLOTS"); var FK: Array = J.gp(GM, "FK")
	_sheet("裝備房", keep)
	_p("用冥幣、棺材板和執念打造。武器、衣服、掛繩都可以隨時換給別的角色戴。加成會帶到所有玩法（鬼力）。")
	_mats_row([["棺材板", fmt(J.gp(J.gp(S, "res"), "planks"))], ["冥幣", fmt(J.gp(J.gp(S, "res"), "coins"))]])
	var tabs = HBoxContainer.new(); tabs.add_theme_constant_override("separation", 6); body.add_child(tabs)
	for k in ["wea", "arm", "acc"]:
		var kk = k; var b = _btn(J.str(J.gp(slots, k)), "gold" if gear_tab == k else "", false, func(): gear_tab = kk; _show_gear()); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; tabs.add_child(b)
	var items: Array = J.gp(s, "items"); var mine = items.filter(func(it): return J.str(J.gp(it, "slot")) == gear_tab)
	body.add_child(UIKit.label("我的%s（%d）" % [J.str(J.gp(slots, gear_tab)), mine.size()], 18, INK, "serif", 900))
	var who = (J.gp(S, "ghosts") as Array).filter(func(x): var q = J.str(J.gp(x, "q")); return q == "名" or q == "主")
	for it in mine: body.add_child(_item_card(it, who, true))
	if mine.is_empty(): _p("還沒有。在下面打造。")
	body.add_child(UIKit.label("打造", 18, INK, "serif", 900))
	var chs: Array = g("CHAPTERS")
	for c in chs.size():
		var open = J.t(m(M, "regionOpen", [c]))
		for f in FK:
			var it = {"slot": gear_tab, "c": float(c), "f": f, "lv": 1.0}
			body.add_child(_craft_card(it, open))
	body.add_child(_btn("返回", "", false, func(): _gear_back()))
	var sp = Control.new(); sp.custom_minimum_size = Vector2(0, 30); body.add_child(sp)

func _gear_back() -> void:
	if gear_back != null: var b = gear_back; gear_back = null; J.cl(b, null, [])
	else: close()

func _icon(it) -> Control:
	if J.str(J.gp(it, "slot")) != "wea": return null
	var GM = gmenu(); var FK: Array = J.gp(GM, "FK")
	var name = J.str(J.gp(J.gp(J.gp(GM, "WIMG"), int(J.num(J.gp(it, "c")))), FK.find(J.gp(it, "f"))))
	var tex = _tex("res://assets/img/patrol_assets/%s.webp" % name)
	if tex == null: return null
	var tr = TextureRect.new(); tr.texture = tex; tr.custom_minimum_size = Vector2(42, 56); tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.rotation = -0.3; tr.pivot_offset = Vector2(21, 28)
	return tr

var _tcache := {}
func _tex(path: String) -> Texture2D:
	if _tcache.has(path): return _tcache[path]
	var t: Texture2D = null
	if ResourceLoader.exists(path): t = load(path)
	else:
		var img = Image.load_from_file(ProjectSettings.globalize_path(path))
		if img: t = ImageTexture.create_from_image(img)
	_tcache[path] = t; return t

func _cost_bb(c) -> String:
	var r = strip(J.str(J.cl(g("costText"), null, [J.gp(c, "r")])))
	var mats = J.gp(m(menu(), "st"), "mats"); var mat = J.gp(c, "mat"); var fac = J.gp(menu(), "FAC"); var bits = []
	var res = J.gp(g("S"), "res"); var rr = J.gp(c, "r")
	# 冥幣／棺材板：唔夠就紅
	var rb = []
	for k in J.keys(rr):
		var need = J.num(J.gp(rr, k)); if need <= 0: continue
		var ok = J.num(J.gp(res, k)) >= need
		rb.append(("%s %s" if ok else "[color=#c2362b]%s %s[/color]") % [J.str(J.gp(g("RES_NAMES"), k)), fmt(need)])
	for f in J.keys(mat):
		var need2 = J.num(J.gp(mat, f)); var ok2 = J.num(J.gp(mats, f)) >= need2
		bits.append(("%s %s" if ok2 else "[color=#c2362b]%s %s[/color]") % [J.str(J.gp(J.gp(fac, f), "mat")), fmt(need2)])
	return "　".join(rb + bits) if rb.size() else r + "　" + "　".join(bits)

func _item_card(it, who: Array, mine: bool) -> Control:
	var GM = gmenu(); var s = m(GM, "st")
	var pc = _card(0.6); var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); pc.add_child(vb)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); vb.add_child(hb)
	var ic = _icon(it); if ic: hb.add_child(ic)
	var w = J.cl(g("ghostById"), null, [J.gp(it, "who")])
	var txt = "[color=%s][b]%s[/b][/color]  [i]Lv%s[/i]\n[font_size=13]%s[/font_size]\n[font_size=13]%s[/font_size]" % [fcol(J.str(J.gp(it, "f"))), J.str(m(GM, "nameOf", [it])), J.str(J.gp(it, "lv")), J.str(m(GM, "effText", [it])), ("佩戴：" + J.str(J.gp(w, "name"))) if w != null else "未戴"]
	var info = UIKit.rich(txt, 16, INK); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
	var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 8); vb.add_child(row)
	var ob = OptionButton.new(); ob.add_theme_font_size_override("font_size", 15); ob.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ob.add_item("— 不戴 —"); var sel = 0
	for i in who.size():
		ob.add_item(J.str(J.gp(who[i], "name")))
		if J.gp(who[i], "id") == J.gp(it, "who"): sel = i + 1
	ob.select(sel)
	ob.item_selected.connect(func(ix):
		var id = J.gp(who[ix - 1], "id") if ix > 0 else null
		if id != null:
			for x in J.gp(s, "items"):
				if x != it and J.gp(x, "who") == id and J.gp(x, "slot") == J.gp(it, "slot"): J.sp(x, "who", null)
		J.sp(it, "who", id); save(); _show_gear(true))
	row.add_child(ob)
	if J.num(J.gp(it, "lv")) < 10:
		var uc = m(GM, "upCost", [it]); var can = J.t(m(GM, "canPayAll", [uc]))
		var upf = func():
			if not J.t(m(GM, "canPayAll", [uc])): return
			m(GM, "payAll", [uc]); J.sp(it, "lv", J.num(J.gp(it, "lv")) + 1)
			m(g("Fx"), "toast", ["%s 升到 Lv%s" % [J.str(m(GM, "nameOf", [it])), J.str(J.gp(it, "lv"))]]); save(); _show_gear(true)
		row.add_child(_btn("升級", "gold", true, upf, can))
		vb.add_child(UIKit.rich("[font_size=13]升級：%s[/font_size]" % _cost_bb(uc), 13, DIM))
	else:
		row.add_child(UIKit.label("滿級", 14, DIM, "sans", 900))
	return pc

func _craft_card(it: Dictionary, open: bool) -> Control:
	var GM = gmenu(); var s = m(GM, "st")
	var pc = _card(0.6 if open else 0.3); var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 5); pc.add_child(vb)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); vb.add_child(hb)
	var ic = _icon(it); if ic: ic.modulate = Color(1, 1, 1, 1 if open else 0.45); hb.add_child(ic)
	var c = int(it.c); var f = J.str(it.f)
	var info = UIKit.rich("[color=%s][b]%s[/b][/color]  [i]第%s區[/i]\n[font_size=13]%s[/font_size]" % [fcol(f), J.str(m(GM, "nameOf", [it])), CN[c], J.str(m(GM, "effText", [it]))], 16, INK if open else Color(INK, 0.55))
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
	if not open:
		vb.add_child(UIKit.rich("[font_size=13]巡到這區才解鎖[/font_size]", 13, DIM)); return pc
	var cc = m(GM, "craftCost", [float(c), f]); var can = J.t(m(GM, "canPayAll", [cc]))
	var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 8); vb.add_child(row)
	var cl = UIKit.rich("[font_size=13]%s[/font_size]" % _cost_bb(cc), 13, DIM); cl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(cl)
	var mkf = func():
		if not J.t(m(GM, "canPayAll", [cc])): return
		m(GM, "payAll", [cc])
		var uid = J.num(J.gp(s, "uid")); J.sp(s, "uid", uid + 1)
		var ni = {"id": "e" + str(int(uid)), "slot": gear_tab, "c": float(c), "f": f, "lv": 1.0, "who": null}
		(J.gp(s, "items") as Array).append(ni)
		m(g("Fx"), "toast", ["打造了 <b>%s</b>" % J.str(m(GM, "nameOf", [ni]))])
		var snd = g("Sound"); if snd != null: m(snd, "play", ["gong"])
		save(); _show_gear(true)
	row.add_child(_btn("打造", "", true, mkf, can))
	return pc
