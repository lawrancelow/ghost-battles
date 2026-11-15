# 回陽間・偷看手機／電腦／茶水間（scare_ops.js openPhone／compose／openPC／openPantry）原生視窗
#  情報、冷卻、陰氣、出招全部照用 JS（ScareOps.act／intel／cdOf）；呢度只畫視窗同收撳掣
#  開住視窗時遊戲暫停（JS 嗰邊設 Sc.paused），✕ 或者出招之後由 ScareOps.close 解除
class_name ScOps
extends RefCounted

static func js(n: String): return J.G.get(n)
static func L(s) -> String: return J.str(DB.L(J.str(s)))
static func ops(): return js("ScareOps")

static func hook(a: Array) -> bool:
	var r = ScRun.cur
	if r == null or not is_instance_valid(r): return false
	var kind = J.str(a[0]); var Sc = a[1]; var n = a[2]
	var box = _open(r)
	match kind:
		"phone": _phone(box, Sc, n, J.str(a[3]) if a.size() > 3 else "msg", a[4] if a.size() > 4 else [])
		"msg": _compose(box, Sc, n)
		"pc": _pc(box, Sc, n)
		"pantry": _pantry(box, Sc, n)
		_: return false
	return true

# 半透明遮罩＋中間一個卡
static func _open(r: ScRun) -> VBoxContainer:
	close_ui(r)
	var lay = Control.new(); lay.name = "ScOpsLayer"; lay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); lay.mouse_filter = Control.MOUSE_FILTER_STOP
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.6); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dim.mouse_filter = Control.MOUSE_FILTER_IGNORE; lay.add_child(dim)
	var pc = PanelContainer.new(); pc.anchor_right = 1; pc.anchor_bottom = 1
	pc.offset_left = 14; pc.offset_right = -14; pc.offset_top = 60 + r.safe_top; pc.offset_bottom = -(24 + r.safe_bot)
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color("#1b1622"), 14, Color("#5a4a6a"), 2, Vector4(12, 10, 12, 12)))
	lay.add_child(pc)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 8); pc.add_child(vb)
	r.add_child(lay); r.ops_layer = lay
	return vb

static func close_ui(r) -> void:
	if r == null or not is_instance_valid(r): return
	if r.ops_layer != null and is_instance_valid(r.ops_layer): r.ops_layer.queue_free()
	r.ops_layer = null

static func _close(Sc) -> void:
	J.cl(ops().close, null, [Sc]); close_ui(ScRun.cur)

static func _head(vb: VBoxContainer, title: String, Sc) -> void:
	var hb = HBoxContainer.new(); vb.add_child(hb)
	var t = UIKit.label(title, 16, Color("#f4ecff"), "sans", 900); t.size_flags_horizontal = Control.SIZE_EXPAND_FILL; t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(t)
	var x = UIKit.btn("✕", "", true); x.pressed.connect(func(): _close(Sc)); hb.add_child(x)

static func _scroll(vb: VBoxContainer) -> VBoxContainer:
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; vb.add_child(sc)
	var b = VBoxContainer.new(); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.add_theme_constant_override("separation", 6); sc.add_child(b)
	return b

static func _txt(t: String, size := 13, col := Color("#e8e0f0")) -> RichTextLabel:
	var r = UIKit.rich(t, size, col); r.fit_content = true; r.scroll_active = false; return r

static func _bubble(t: String, bg: Color, right := false) -> Control:
	var p = PanelContainer.new(); p.add_theme_stylebox_override("panel", UIKit.sb(bg, 8, Color(0, 0, 0, 0), 0, Vector4(8, 5, 8, 6)))
	p.size_flags_horizontal = Control.SIZE_SHRINK_END if right else Control.SIZE_SHRINK_BEGIN
	var r = _txt(t, 13); r.custom_minimum_size = Vector2(200, 0); p.add_child(r)
	return p

# ---------- 手機 ----------
const TABS := ["msg", "photo", "search", "note"]
static func _phone(vb: VBoxContainer, Sc, n, tab: String, got) -> void:
	var O = ops().OPS[J.str(n.d.k)]; var A = O.apps; var TAB = ops().TAB
	_head(vb, L(n.d.name) + " " + L("的手機"), Sc)
	var tb = HBoxContainer.new(); tb.add_theme_constant_override("separation", 4); vb.add_child(tb)
	for k in TABS:
		var b = UIKit.btn(L(TAB[k]), "gold" if k == tab else "", true); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var kk = k; b.pressed.connect(func(): J.cl(ops().openPhone, null, [Sc, n, kk])); tb.add_child(b)
	var body = _scroll(vb)
	var me = J.str(n.d.name)
	match tab:
		"msg":
			for c in A.msg:
				body.add_child(UIKit.label(L(c.title), 12, Color("#c8a8ff"), "sans", 900))
				for m in c.items:
					if J.str(m[0]) == "": body.add_child(_txt("[center][font_size=11]%s[/font_size][/center]" % L(m[2]), 11, Color(0.8, 0.75, 0.9, 0.7)))
					else:
						var mine = J.str(m[0]) == me
						body.add_child(_bubble("[font_size=10][color=#a898c0]%s・%s[/color][/font_size]\n%s" % [L(m[0]), L(m[1]), L(m[2])], Color("#2d5a3e") if mine else Color("#2e2638"), mine))
				body.add_child(UIKit.hsep())
		"photo":
			var g = GridContainer.new(); g.columns = 2; g.add_theme_constant_override("h_separation", 6); g.add_theme_constant_override("v_separation", 6); body.add_child(g)
			var i = 0
			for p in A.photo:
				i += 1
				var pp = PanelContainer.new(); pp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; pp.custom_minimum_size = Vector2(0, 84)
				pp.add_theme_stylebox_override("panel", UIKit.sb(Color("#2a2232"), 6, Color("#4a3a5a"), 1, Vector4(6, 6, 6, 6)))
				pp.add_child(_txt("[b][color=#8a7aa0]%d[/color][/b]\n%s" % [i, L(p)], 12)); g.add_child(pp)
		"search":
			for s in A.search: body.add_child(_txt("🔍 " + L(s[0]), 13))
		"note":
			var pp = PanelContainer.new(); pp.add_theme_stylebox_override("panel", UIKit.sb(Color("#f3e6a0"), 6, Color(0, 0, 0, 0), 0, Vector4(10, 8, 10, 8)))
			var ls = []
			for l in A.note: ls.append(L(l))
			pp.add_child(_txt("\n".join(ls), 13, Color("#3a2c10"))); body.add_child(pp)
	if got is Array and got.size():
		var gs = []
		for x in got: gs.append(L(x))
		vb.add_child(_txt("[color=#ffd84a]%s%s[/color]" % [L("得到情報："), "、".join(gs)], 13))
	var msgs = O.get("msgs")
	if msgs is Array and msgs.size():
		var s = UIKit.btn(L("傳訊息嚇他"), "gold"); s.pressed.connect(func(): J.cl(ops().compose, null, [Sc, n])); vb.add_child(s)
	vb.add_child(_txt("[center][font_size=11]%s[/font_size][/center]" % L("看手機時，時間是停的。"), 11, Color(0.8, 0.75, 0.9, 0.6)))

# ---------- 選項 ----------
static func _opt(Sc, n, o, locked: bool, kind: String, list) -> Control:
	var cd = J.num(J.cl(ops().cdOf, null, [Sc, n, o.id])); var poor = J.num(Sc.mana) < J.num(o.cost)
	var sub := ""
	if locked: sub = L("需要情報：") + L(ops().INTEL_NAME.get(J.str(o.need), o.need)) + L("（先看他的手機）")
	elif cd > 0: sub = L("冷卻") + " %d " % ceili(cd) + L("秒")
	else:
		sub = L("陰氣") + " %d" % int(J.num(o.cost))
		if not (J.t(o.get("trap")) or J.t(o.get("warm"))): sub += "・" + L("算「") + L(js("FEAR_WORD").get(J.str(o.type))) + "」"
	var t = ("[b][color=#ffcf6a]%s[/color][/b]\n" % L(o.who)) if J.t(o.get("who")) else ""
	t += "%s\n[font_size=11][color=#a898c0]%s[/color][/font_size]" % [L(o.text), sub]
	var b = Button.new(); b.custom_minimum_size = Vector2(0, 52); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bg = Color("#2a2232") if not locked else Color("#1e1a24")
	b.add_theme_stylebox_override("normal", UIKit.sb(bg, 8, Color("#5a4a6a"), 1))
	b.add_theme_stylebox_override("hover", UIKit.sb(bg.lightened(0.06), 8, Color("#7a6a8a"), 1))
	b.add_theme_stylebox_override("pressed", UIKit.sb(bg.darkened(0.1), 8, Color("#7a6a8a"), 1))
	b.add_theme_stylebox_override("disabled", UIKit.sb(bg, 8, Color("#3a3040"), 1))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var r = _txt(t, 13); r.mouse_filter = Control.MOUSE_FILTER_IGNORE; r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); r.offset_left = 10; r.offset_right = -10; r.offset_top = 6
	b.add_child(r)
	b.resized.connect(func(): b.custom_minimum_size.y = maxf(52, r.get_content_height() + 12))
	b.disabled = locked or cd > 0
	if locked or cd > 0 or poor: b.modulate = Color(1, 1, 1, 0.55)
	b.pressed.connect(func(): J.cl(ops().act, null, [Sc, n, o, kind]); if not J.t(Sc.get("paused")): close_ui(ScRun.cur))
	return b

static func _hint(t: String) -> RichTextLabel: return _txt("[font_size=12]%s[/font_size]" % L(t), 12, Color(0.85, 0.8, 0.95, 0.75))

static func _compose(vb: VBoxContainer, Sc, n) -> void:
	var O = ops().OPS[J.str(n.d.k)]; var I = J.cl(ops().intel, null, [Sc, n.d.k])
	_head(vb, L("傳訊息給") + " " + L(n.d.name), Sc)
	var body = _scroll(vb)
	body.add_child(_hint("選冒充誰、傳什麼。對準他怕的、用上情報，嚇得最狠；選錯了可能反效果。"))
	for o in O.msgs:
		var locked = J.t(o.get("need")) and not J.t(J.mc(I, "has", [o.need]))
		body.add_child(_opt(Sc, n, o, locked, "msg", O.msgs))
	var bk = UIKit.btn(L("返回手機"), "", true); bk.pressed.connect(func(): J.cl(ops().openPhone, null, [Sc, n])); vb.add_child(bk)

static func _pc(vb: VBoxContainer, Sc, n) -> void:
	var P = ops().OPS[J.str(n.d.k)].pc
	_head(vb, L(n.d.name) + " " + L("的電腦"), Sc)
	var mon = PanelContainer.new(); mon.add_theme_stylebox_override("panel", UIKit.sb(Color("#0e1a2a"), 6, Color("#3a5a7a"), 2, Vector4(10, 8, 10, 8)))
	var ls = ["[b]%s[/b]" % L(P.title)]
	for l in P.lines: ls.append(L(l))
	mon.add_child(_txt("\n".join(ls), 12, Color("#bfe0ff"))); vb.add_child(mon)
	var body = _scroll(vb)
	for o in P.ops: body.add_child(_opt(Sc, n, o, false, "pc", P.ops))

static func _pantry(vb: VBoxContainer, Sc, n) -> void:
	_head(vb, L("茶水間") + "・" + L(n.d.name), Sc)
	var body = _scroll(vb)
	body.add_child(_hint("他在茶水間。選一樣他怕的。"))
	for o in ops().PANTRY: body.add_child(_opt(Sc, n, o, false, "pantry", ops().PANTRY))
