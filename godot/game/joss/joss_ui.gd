# 燒嘢線（joss）介面：化寶爐面板、開包畫面（青煙＋火光＋紙紮成形＋八行箋紙條）、村子提示（青煙＋數字）、後院掣角標。
# 冇 class_name（熱更新規矩）：load("res://game/joss/joss_ui.gd").xxx()
extends RefCounted

const JS := preload("res://game/joss/joss.gd")
const SMOKE := Color(0.62, 0.78, 0.72)       # 青煙
const PAPER_BG := Color("#f4e8c8")
const LINE_RED := Color(0.72, 0.18, 0.13, 0.16)
const OUT := Color("#2a1a10")

static func main():
	var ml = Engine.get_main_loop()
	return ml.root.get_node_or_null("Main") if ml is SceneTree else null
static func T(a: String, b: String) -> String: return JS.T(a, b)
static func _toast(bb: String) -> void:
	var m = main()
	if m != null and m.has_method("show_toast"): m.show_toast(bb)
static func _save() -> void:
	if J.G.get("save") != null: J.cl(J.G.get("save"), null, [])
	var m = main()
	if m != null and m.has_method("refresh"): m.refresh()
static func _close_sheets() -> void:
	var ui = J.G.get("UI")
	if ui is Dictionary and ui.get("close") != null: J.mc(ui, "close", [])
	var m = main()
	if m != null and m.get("sheet") != null and m.sheet.visible: m.close_sheet()

static func _rich(bb: String, size := 15, col := UIKit.INKTXT, kind := "sans") -> RichTextLabel:
	var r = UIKit.rich(bb, size, col, kind); r.mouse_filter = Control.MOUSE_FILTER_PASS; return r
static func _btn(text: String, kind: String, enabled: bool, f: Callable) -> Button:
	var b = UIKit.btn(text, kind, false); b.add_theme_font_size_override("font_size", 15)
	b.disabled = not enabled; b.focus_mode = Control.FOCUS_NONE; b.pressed.connect(f); return b

# ================= 建築面板（menus.gd／main.gd 嘅化寶爐一段） =================
static func panel(body: Control, rerender: Callable) -> void:
	var j = JS.st()
	if j == null: return
	var n = JS.count(); var l = JS.lv(); var left = JS.next_left_s()
	var box = PanelContainer.new()
	box.add_theme_stylebox_override("panel", UIKit.sb(Color(0.16, 0.22, 0.2, 0.14), 4, Color(0.3, 0.45, 0.4, 0.5), 1, Vector4(12, 8, 12, 8)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); box.add_child(vb); body.add_child(box)
	var head = HBoxContainer.new(); head.add_theme_constant_override("separation", 10); vb.add_child(head)
	var ic = Hint.new(); ic.custom_minimum_size = Vector2(46, 46); ic.n = n; ic.mouse_filter = Control.MOUSE_FILTER_IGNORE; head.add_child(ic)
	var tx = []
	tx.append(T("陽間包裹：[b][color=#9c2219]%d[/color][/b] / %d 件", "陽間包裹：[b][color=#9c2219]%d[/color][/b] / %d 件") % [n, JS.CAP])
	if left < 0: tx.append(T("[color=#9c2219]儲滿咗！快啲收，唔係陽間燒落嚟都冇位擺。[/color]", "[color=#9c2219]存滿了！快點收，不然陽間燒下來也沒地方放。[/color]"))
	else: tx.append(T("下一件：約 %d 分鐘後到", "下一件：約 %d 分鐘後到") % maxi(1, int(ceil(left / 60.0))))
	var hr = _rich("\n".join(tx), 15); hr.size_flags_horizontal = Control.SIZE_EXPAND_FILL; head.add_child(hr)
	if JS.early():   # [tavern] 前期：化寶爐係冥幣來源
		vb.add_child(_rich(T("[b]前期：陽間屋企人燒冥幣落嚟[/b]　每件約冥幣 %d（大包裹 ×2.5）\n[color=#6e5838]過勞鬼市集開張之後，屋企人會改燒用得着嘅嘢（祭品模式）。[/color]", "[b]前期：陽間家人燒冥幣下來[/b]　每件約冥幣 %d（大包裹 ×2.5）\n[color=#6e5838]過勞鬼市集開張之後，家人會改燒用得上的東西（祭品模式）。[/color]") % int(JS.early_coins(maxi(1, l), false)), 14))
	vb.add_child(_rich(T("Lv %d：每 %d 分鐘一件　品質：%s\n[color=#6e5838]升級化寶爐：包裹嚟得更密、質素更好。離線最多儲 %d 件。[/color]", "Lv %d：每 %d 分鐘一件　品質：%s\n[color=#6e5838]升級化寶爐：包裹來得更頻繁、品質更好。離線最多存 %d 件。[/color]") % [l, int(round(JS.interval_min(l))), JS.quality_text(l), JS.CAP], 14, Color("#3a2e1a")))
	var get_b = _btn((T("收件（%d）", "收件（%d）") % n) if n > 0 else T("未有包裹", "還沒有包裹"), "gold", n > 0, func(): open_next())
	get_b.custom_minimum_size = Vector2(0, 44); vb.add_child(get_b)
	# 加速卡
	var ts = JS.tix("spd"); var ti = JS.tix("inc")
	if ts > 0 or ti > 0:
		vb.add_child(UIKit.hsep())
		var can = JS.can_use_tix()
		vb.add_child(_rich(T("[b]陽間寄嚟嘅卡[/b]　加速卡 ×%d　收益×2卡 ×%d\n[color=#6e5838]喺移動村即刻開，唔使等冷卻，亦唔會加冷卻。[/color]", "[b]陽間寄來的卡[/b]　加速卡 ×%d　收益×2卡 ×%d\n[color=#6e5838]在移動村立即啟用，不用等冷卻，也不會增加冷卻。[/color]") % [ts, ti], 14))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); vb.add_child(hb)
		for k in ["spd", "inc"]:
			var kk: String = k
			hb.add_child(_btn(T("用", "用") + JS.tix_name(k), "", can and JS.tix(k) > 0, func():
				if JS.use_tix(kk):
					Snd.play("coin"); _toast(T("%s生效！移動村%s", "%s生效！移動村%s") % [JS.tix_name(kk), T("做嘢快一倍。", "做事快一倍。") if kk == "spd" else T("收錢多一倍。", "收入多一倍。")]); _save()
				rerender.call()))
		if not can: vb.add_child(_rich(T("[color=#9c2219]要開咗移動村先用得。[/color]", "[color=#9c2219]要開啟移動村才能使用。[/color]"), 14))
	# 收藏櫃
	if j.deco.size():
		vb.add_child(UIKit.hsep())
		vb.add_child(_rich(T("[b]紙紮收藏櫃[/b]（撳一下睇）", "[b]紙紮收藏櫃[/b]（點一下看）"), 14))
		var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6); vb.add_child(fl)
		for id in j.deco:
			var dd = JS.D().DECO.get(id, {}); var nm = JS.P(dd.get("n", [id, id])); var ds = JS.P(dd.get("d", ["", ""]))
			fl.add_child(_btn(nm, "", true, func(): Snd.play("paper"); _toast("[b]%s[/b]\n%s" % [nm, ds])))
	# 信箱
	if j.log.size():
		vb.add_child(UIKit.hsep())
		vb.add_child(_rich(T("[b]舊信[/b]（撳一下重溫）", "[b]舊信[/b]（點一下重溫）"), 14))
		var k = 0
		for e in j.log:
			if k >= 5: break
			k += 1
			var o = JS.letter(str(e.id))
			if o.is_empty(): continue
			var ee: Dictionary = e
			var b = _btn("%s　%s" % [JS.sender_of(o), JS.item_of(o)], "", true, func(): open_entry(ee))
			b.alignment = HORIZONTAL_ALIGNMENT_LEFT; b.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; b.clip_text = true
			vb.add_child(b)

# ================= 開包 =================
static func _drop_old(m: Node) -> void:
	var old = m.get_node_or_null("JossUnbox")
	if old != null: old.name = "JossUnboxOld"; old.queue_free()
static func open_next() -> void:
	var m = main()
	if m == null: return
	_drop_old(m)
	_close_sheets()
	var r = JS.collect()
	if not J.t(r.get("ok")): _toast(T("而家未有包裹。", "現在還沒有包裹。")); return
	_save()
	load("res://game/onboard/prestall_story.gd").defer_joss(r)   # [opening] 積壓包裹／轉祭品：收起開箱畫面後播劇情
	var u = Unbox.new(); u.name = "JossUnbox"; m.add_child(u); u.setup(r)
	if r.get("early"): load("res://ui/joss_fx.gd").play(m)   # [tavern] 前期冥幣：金銀紙滿屏
	if r.get("shift"): _toast(T("化寶爐轉咗「祭品模式」：以後陽間會燒用得着嘅嘢，冥幣靠過勞鬼市集自己賺。", "化寶爐轉為「祭品模式」：以後陽間會燒用得上的東西，冥幣靠過勞鬼市集自己賺。"))
static func open_entry(e: Dictionary) -> void:
	var m = main()
	if m == null: return
	var r = JS.reread(e)
	if not J.t(r.get("ok")): return
	_close_sheets(); _drop_old(m)
	var u = Unbox.new(); u.name = "JossUnbox"; m.add_child(u); u.setup(r, true)

# ================= 村子提示（nv_village 化寶爐上面）=================
static func draw_hint(c: CanvasItem, X: Transform2D, x: float, y: float, t: float) -> void:
	var n = JS.count()
	if n <= 0: return
	var im = Spr.get_tex("furnace")
	var h = 62.0 * (im.get_height() / float(im.get_width()) if im != null else 1.14)
	var top = y + 6 - h
	c.draw_set_transform_matrix(X)
	smoke(c, Vector2(x + 2, top + 8), t, 1.0, 7)
	badge(c, Vector2(x + 24, top + 4), n, t)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

static func smoke(c: CanvasItem, o: Vector2, t: float, k: float, cnt := 6, col := SMOKE) -> void:
	for i in cnt:
		var p = fmod(t * 0.32 + float(i) / cnt, 1.0)
		var px = o.x + sin(p * 5.0 + i * 1.7 + t * 0.6) * 9.0 * p * k
		var py = o.y - p * 52.0 * k
		var r = (5.0 + p * 13.0) * k
		var a = (1.0 - p) * 0.5 * minf(1.0, p * 5.0)
		c.draw_circle(Vector2(px, py), r, Color(col, a * 0.55))
		c.draw_circle(Vector2(px - r * 0.3, py - r * 0.2), r * 0.6, Color(col.lightened(0.2), a * 0.5))

static func badge(c: CanvasItem, p: Vector2, n: int, t: float) -> void:
	var r = 11.0 + sin(t * 5.0) * 0.8
	c.draw_circle(p + Vector2(0, 1.5), r, Color(0, 0, 0, 0.35))
	c.draw_circle(p, r, Color("#c2362b"))
	c.draw_arc(p, r, 0, TAU, 24, Color("#fff3e0"), 1.6, true)
	var f = UIKit.font("sans", 900)
	c.draw_string(f, p + Vector2(-12, 5.5), str(n), HORIZONTAL_ALIGNMENT_CENTER, 24, 15, Color.WHITE)

# ================= 後院掣角標＋派件提示 =================
static func attach(m: Node, back_btn: Control) -> void:
	if m == null: return
	var w = Watcher.new(); w.name = "JossWatch"; m.add_child(w)
	if back_btn != null:
		var b = Hint.new(); b.name = "JossBadge"; b.small = true; b.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.anchor_left = 1; b.anchor_right = 1; b.offset_left = -18; b.offset_right = 12; b.offset_top = -14; b.offset_bottom = 16
		back_btn.add_child(b); w.badge = b

class Watcher extends Node:
	var JZ = load("res://game/joss/joss.gd")
	var JSUI = load("res://game/joss/joss_ui.gd")
	var acc := 0.0
	var last := -1
	var badge: Control = null
	func _process(dt: float) -> void:
		acc += dt
		if acc < 1.0: return
		acc = 0.0
		if not (J.G.get("S") is Dictionary) or JZ.S() == null: return
		var n = JZ.count() if JZ.lv() > 0 else 0
		if badge != null and is_instance_valid(badge): badge.n = n; badge.visible = n > 0
		var m = get_parent()
		if m == null or m.get("loading") != null or m.get("title_ov") != null: return
		if last < 0:
			last = n
			if n > 0: JSUI.toast_arrive(n, true)
			return
		if n > last: JSUI.toast_arrive(n, false)
		last = n

static func toast_arrive(n: int, boot: bool) -> void:
	if boot: _toast(T("化寶爐有 [b]%d 件陽間包裹[/b] 等你收。", "化寶爐有 [b]%d 件陽間包裹[/b] 等你收。") % n)
	else: Snd.play("paper"); _toast(T("一陣青煙……陽間有人燒嘢落嚟！化寶爐有包裹（%d/%d）", "一陣青煙……陽間有人燒東西下來！化寶爐有包裹（%d/%d）") % [n, JS.CAP])

# 細圖示：青煙＋紅數字（面板頭、後院掣角）
class Hint extends Control:
	var JSU = load("res://game/joss/joss_ui.gd")
	var n := 0
	var small := false
	var t := 0.0
	func _process(dt: float) -> void:
		if not is_visible_in_tree(): return
		t += dt; queue_redraw()
	func _draw() -> void:
		if small:
			if n <= 0: return
			JSU.smoke(self, Vector2(size.x * 0.5 - 4, size.y * 0.5), t, 0.45, 5)
			JSU.badge(self, Vector2(size.x * 0.5, size.y * 0.5), n, t)
			return
		# 面板頭：細爐口＋火光＋青煙
		var cx = size.x * 0.5; var by = size.y - 4
		draw_rect(Rect2(cx - 16, by - 18, 32, 18), Color("#4a3426"))
		draw_rect(Rect2(cx - 16, by - 18, 32, 18), Color("#2a1a10"), false, 2.0)
		var fl = 0.6 + sin(t * 9.0) * 0.2
		draw_circle(Vector2(cx, by - 8), 7.0, Color(1, 0.6, 0.2, fl))
		draw_circle(Vector2(cx, by - 9), 3.5, Color(1, 0.9, 0.5, fl))
		if n > 0:
			JSU.smoke(self, Vector2(cx, by - 18), t, 0.5, 5, Color(0.3, 0.42, 0.38))
			JSU.badge(self, Vector2(cx + 15, 10), n, t)

# ================= 開包畫面 =================
class Unbox extends Control:
	var JSU = load("res://game/joss/joss_ui.gd")
	var JZ = load("res://game/joss/joss.gd")
	var OUT := Color("#2a1a10")
	var R: Dictionary = {}
	var t := 0.0
	var reread := false
	var card: PanelContainer = null
	var card_shown := false
	var strips: Array = []
	var puffs: Array = []
	var sparks: Array = []
	const T_FORM := 1.0
	const T_DONE := 2.1
	const T_CARD := 2.3
	func setup(r: Dictionary, old := false) -> void:
		R = r; reread = old; t = 0.0; card_shown = false
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP; z_index = 80
		if card != null: card.queue_free(); card = null
		strips.clear(); puffs.clear(); sparks.clear()
		for i in 26: strips.append({"a": randf() * TAU, "d": 120 + randf() * 140, "w": 10 + randf() * 16, "rot": randf() * 6.0, "dl": randf() * 0.5})
		for i in 34: puffs.append({"x": (randf() - 0.5) * 70, "ph": randf(), "sp": 0.35 + randf() * 0.4, "r": 14 + randf() * 22})
		Snd.play("whoosh")
		if old: t = T_CARD - 0.01
	func _center() -> Vector2: return Vector2(size.x * 0.5, minf(250.0, size.y * 0.3))
	func _process(dt: float) -> void:
		var pt = t
		t += dt
		if pt < T_DONE and t >= T_DONE:
			Snd.play("gong" if R.get("kind", "n") != "n" or _has_rare() else "coin")
			var c = _center()
			for i in 40: sparks.append({"p": c, "v": Vector2(randf() - 0.5, randf() - 0.9) * (180 + randf() * 260), "life": 0.6 + randf() * 0.8, "t": 0.0})
		for s in sparks:
			s.t += dt; s.v.y += 380 * dt; s.p += s.v * dt
		if t >= T_CARD and not card_shown: _show_card()
		queue_redraw()
	func _has_rare() -> bool:
		for x in R.get("rw", []): if str(x.get("k")) in ["ghost", "deco", "gear"]: return true
		return false
	func _gui_input(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT and t < T_CARD:
			t = T_CARD - 0.01; accept_event()
	func _draw() -> void:
		var W = size.x; var H = size.y; var c = _center()
		var a0 = minf(1.0, t / 0.4)
		draw_rect(Rect2(0, 0, W, H), Color(0.03, 0.03, 0.05, 0.88 * a0))
		# 標題
		var f = UIKit.font("serif", 900)
		var head = R.get("fest", "") if str(R.get("fest", "")) != "" else (JSU.T("舊信重溫", "舊信重溫") if reread else JSU.T("陽間包裹到！", "陽間包裹到！"))
		draw_string(f, Vector2(0, 58), head, HORIZONTAL_ALIGNMENT_CENTER, W, 24, Color(UIKit.GOLD2, a0))
		var sub = JSU.T("寄件人：", "寄件人：") + str(R.get("sender", ""))
		draw_string(UIKit.font("sans", 700), Vector2(0, 86), sub, HORIZONTAL_ALIGNMENT_CENTER, W, 16, Color(0.9, 0.86, 0.78, a0))
		# 爐火：爐口（磚）＋三層火舌
		var fy = c.y + 92
		for i in 7:
			var k = 1.0 - i / 7.0
			draw_circle(Vector2(c.x, fy), 120 * k, Color(1, 0.45 + 0.3 * (1 - k), 0.12, 0.05 * a0))
		var lay = [[Color(0.95, 0.35, 0.08, 0.75), 1.0], [Color(1.0, 0.62, 0.15, 0.85), 0.72], [Color(1.0, 0.92, 0.6, 0.9), 0.42]]
		for L in lay:
			for i in 7:
				var xx = c.x + (i - 3) * 17.0 * (0.6 + 0.4 * L[1]); var ww = 15.0 * L[1] + 4.0
				var hh = (30 + 18 * (0.5 + 0.5 * sin(t * 9.0 + i * 2.1))) * L[1] * (1.15 - absf(i - 3) * 0.1)
				var sw = sin(t * 6.0 + i * 1.3) * 5.0 * L[1]
				var base = fy + 10
				draw_colored_polygon(PackedVector2Array([Vector2(xx - ww, base), Vector2(xx - ww * 0.8, base - hh * 0.4), Vector2(xx - ww * 0.3 + sw * 0.5, base - hh * 0.8), Vector2(xx + sw, base - hh), Vector2(xx + ww * 0.35 + sw * 0.5, base - hh * 0.75), Vector2(xx + ww * 0.8, base - hh * 0.35), Vector2(xx + ww, base)]), Color(L[0], L[0].a * a0))
		draw_rect(Rect2(c.x - 78, fy + 8, 156, 16), Color(0.24, 0.13, 0.1, a0))
		for i in 6: draw_line(Vector2(c.x - 78 + i * 26 + 13, fy + 8), Vector2(c.x - 78 + i * 26 + 13, fy + 24), Color(0.12, 0.06, 0.05, a0), 1.5)
		draw_line(Vector2(c.x - 78, fy + 16), Vector2(c.x + 78, fy + 16), Color(0.12, 0.06, 0.05, a0), 1.5)
		draw_rect(Rect2(c.x - 78, fy + 8, 156, 16), Color(OUT, a0), false, 2.0)
		# 青煙：由爐口升上去，喺中間捲成一團
		for p in puffs:
			var q = fmod(t * p.sp + p.ph, 1.0)
			var gather = clampf((t - 0.2) / 1.2, 0.0, 1.0)
			var px = c.x + lerpf(p.x * (1.0 + q), sin(q * TAU + p.ph * 6.0) * 60.0 * (1.0 - q * 0.4), gather)
			var py = lerpf(fy, c.y - 70, q)
			var al = (1.0 - q) * minf(1.0, q * 4.0) * 0.24 * a0 * (1.0 - clampf((t - T_CARD) / 1.5, 0.0, 0.6))
			draw_circle(Vector2(px, py), p.r * (0.6 + q), Color(JSU.SMOKE, al))
		# 紙片飛埋嚟
		var fk = clampf((t - T_FORM + 0.4) / (T_DONE - T_FORM + 0.4), 0.0, 1.0)
		if fk > 0 and fk < 1:
			for s in strips:
				var e = clampf((fk - s.dl * 0.5) / 0.6, 0.0, 1.0)
				if e <= 0 or e >= 1: continue
				var pos = c + Vector2(cos(s.a), sin(s.a)) * s.d * (1.0 - e)
				draw_set_transform(pos, s.rot * (1.0 - e), Vector2.ONE)
				draw_rect(Rect2(-s.w * 0.5, -3, s.w, 6), Color(0.95, 0.9, 0.78, 0.85 * (1.0 - e * 0.3)))
				draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
		# 紙紮物成形
		var form = clampf((t - T_FORM) / (T_DONE - T_FORM), 0.0, 1.0)
		if form > 0:
			var e2 = 1.0 - pow(1.0 - form, 3)
			var sc = 0.65 + 0.35 * e2 + (sin(t * 2.0) * 0.015 if form >= 1 else 0.0)
			JSU.draw_item(self, c + Vector2(0, -6 + sin(t * 1.6) * 3.0 * form), 118.0 * sc, e2, str(R.get("shape", "box")), str(R.get("art", "")))
			# 名牌（紅紙條）
			var nm = str(R.get("item", ""))
			var nf = UIKit.font("serif", 900)
			var tw = nf.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x + 24
			var lr = Rect2(c.x - tw * 0.5, c.y + 52, tw, 26)
			draw_rect(lr, Color(0.76, 0.21, 0.17, e2)); draw_rect(lr, Color(OUT, e2), false, 1.5)
			draw_string(nf, Vector2(lr.position.x, lr.position.y + 19), nm, HORIZONTAL_ALIGNMENT_CENTER, tw, 16, Color(1, 0.95, 0.85, e2))
		# 一閃
		if t >= T_DONE and t < T_DONE + 0.35:
			var k2 = 1.0 - (t - T_DONE) / 0.35
			draw_circle(c, 90 + 80 * (1 - k2), Color(1, 0.92, 0.7, 0.35 * k2))
		for s in sparks:
			if s.t > s.life: continue
			var k3 = 1.0 - s.t / s.life
			draw_circle(s.p, 1.5 + 2.0 * k3, Color(1, 0.85, 0.45, k3))
		if t < T_CARD:
			draw_string(UIKit.font("sans", 400), Vector2(0, H - 28), JSU.T("（撳一下跳過）", "（點一下跳過）"), HORIZONTAL_ALIGNMENT_CENTER, W, 14, Color(0.8, 0.76, 0.7, 0.7 * a0))
	func _show_card() -> void:
		card_shown = true
		Snd.play("paper")
		var W = size.x; var H = size.y; var cw = minf(W - 28, 380.0)
		var top = _center().y + 112
		var sc = ScrollContainer.new(); sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		sc.position = Vector2((W - cw) * 0.5, top); sc.size = Vector2(cw, H - top - 16); add_child(sc)
		card = PanelContainer.new(); card.custom_minimum_size = Vector2(cw, 0)
		var stb = UIKit.sb(JSU.PAPER_BG, 4, Color("#b89a52"), 2, Vector4(24, 18, 24, 16)); stb.shadow_color = Color(0, 0, 0, 0.5); stb.shadow_size = 10
		card.add_theme_stylebox_override("panel", stb)
		card.draw.connect(func(): JSU.draw_letter_lines(card))
		sc.add_child(card)
		var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 10); card.add_child(vb)
		var txt = JSU._rich(str(R.get("text", "")), 17, UIKit.INKTXT, "serif"); txt.add_theme_constant_override("line_separation", 6)
		vb.add_child(txt)
		if str(R.get("note", "")) != "":
			vb.add_child(JSU._rich("[color=#7a5a3a]※ " + str(R.get("note")) + "[/color]", 14))
		vb.add_child(UIKit.hsep())
		if reread:
			if str(R.get("old", "")) != "": vb.add_child(JSU._rich("[color=#6e5838]" + JSU.T("當時收到：", "當時收到：") + str(R.old) + "[/color]", 14))
		else:
			vb.add_child(JSU._rich("[b]" + JSU.T("包裹入面：", "包裹裡面：") + "[/b]", 15))
			var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6); vb.add_child(fl)
			for x in R.get("rw", []): fl.add_child(JSU.chip(x, cw - 52))
		var hb = HBoxContainer.new(); hb.alignment = BoxContainer.ALIGNMENT_CENTER; hb.add_theme_constant_override("separation", 10); vb.add_child(hb)
		var more = JZ.count() if not reread else 0
		hb.add_child(JSU._btn(JSU.T("收好", "收好") if not reread else JSU.T("返回", "返回"), "" if more > 0 else "gold", true, func(): _close()))
		if more > 0: hb.add_child(JSU._btn(JSU.T("下一件（%d）", "下一件（%d）") % more, "gold", true, func(): _next()))
		sc.modulate.a = 0.0; sc.position.y += 40
		var tw = create_tween(); tw.set_parallel(true)
		tw.tween_property(sc, "modulate:a", 1.0, 0.3); tw.tween_property(sc, "position:y", top, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	func _close() -> void:
		Snd.play("paper"); name = "JossUnboxOld"; queue_free()
		load("res://game/onboard/prestall_story.gd").flush_joss()   # [opening]
	func _next() -> void:
		var r = JZ.collect()
		if not J.t(r.get("ok")): _close(); return
		JSU._save()
		load("res://game/onboard/prestall_story.gd").defer_joss(r)   # [opening]
		for ch in get_children(): ch.queue_free()
		card = null
		setup(r)

static func draw_letter_lines(p: Control) -> void:
	# 八行箋：八條直紅線＋上下雙線
	var w = p.size.x; var h = p.size.y; var m = 14.0
	p.draw_line(Vector2(m, m), Vector2(w - m, m), Color(0.72, 0.18, 0.13, 0.45), 2.0)
	p.draw_line(Vector2(m, m + 4), Vector2(w - m, m + 4), Color(0.72, 0.18, 0.13, 0.3), 1.0)
	p.draw_line(Vector2(m, h - m), Vector2(w - m, h - m), Color(0.72, 0.18, 0.13, 0.45), 2.0)
	p.draw_line(Vector2(m, h - m - 4), Vector2(w - m, h - m - 4), Color(0.72, 0.18, 0.13, 0.3), 1.0)
	for i in 9:
		var x = m + (w - 2 * m) * i / 8.0
		p.draw_line(Vector2(x, m + 4), Vector2(x, h - m - 4), LINE_RED, 1.0)

static func chip(x: Dictionary, maxw := 300.0) -> Control:
	var pc = PanelContainer.new()
	var col = {"mat": Color(0.3, 0.22, 0.1, 0.12), "tix": Color(0.2, 0.4, 0.6, 0.16), "gear": Color(0.5, 0.3, 0.1, 0.18), "ghost": Color(0.5, 0.2, 0.5, 0.18), "deco": Color(0.7, 0.2, 0.15, 0.18), "chest": Color(0.5, 0.2, 0.5, 0.18)}.get(str(x.get("k")), Color(0, 0, 0, 0.1))
	pc.add_theme_stylebox_override("panel", UIKit.sb(col, 4, Color(UIKit.PAPERLINE, 0.8), 1, Vector4(8, 4, 10, 4)))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 5); pc.add_child(hb)
	var ip = str(x.get("icon", ""))
	var iw = 0.0
	if ip != "" and ResourceLoader.exists(ip):
		var tr = TextureRect.new(); tr.texture = load(ip); tr.custom_minimum_size = Vector2(20, 20); tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(tr); iw = 25.0
	var txt = str(x.get("label", ""))
	var lb = UIKit.label(txt, 14, UIKit.INKTXT, "sans", 700)
	var tw = UIKit.font("sans", 700).get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
	if tw + iw + 20 > maxw:   # 太長：成行，自動換行
		lb.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; lb.custom_minimum_size.x = maxw - iw - 20; lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		pc.custom_minimum_size.x = maxw
	hb.add_child(lb)
	return pc

# ================= 紙紮物（有圖用圖；冇圖就程序畫：紙紮風，平塗＋深邊＋摺痕）=================
static func draw_item(c: CanvasItem, o: Vector2, s: float, a: float, shape: String, art: String) -> void:
	if art != "" and Spr.ok(art):
		var tx = Spr.get_tex(art); var k = s / maxf(tx.get_width(), tx.get_height())
		var sz = Vector2(tx.get_width(), tx.get_height()) * k
		c.draw_texture_rect(tx, Rect2(o - sz * 0.5, sz), false, Color(1, 1, 1, a)); return
	var red = Color("#c2362b"); var gold = Color("#e7b94a"); var cream = Color("#f2e4c0"); var teal = Color("#5f8f86"); var pink = Color("#d98a9a"); var blue = Color("#6c87b8"); var brown = Color("#8a5a3a"); var fold = Color(1, 1, 1, 0.45)
	match shape:
		"pot":
			_P(c, o, s, a, [[-0.62, -0.2], [0.62, -0.2], [0.55, 0.55], [0.35, 0.7], [-0.35, 0.7], [-0.55, 0.55]], cream)
			_R(c, o, s, a, -0.7, -0.36, 1.4, 0.18, red); _C(c, o, s, a, 0, -0.48, 0.1, gold)
			_R(c, o, s, a, -0.2, 0.12, 0.4, 0.2, teal); _L(c, o, s, a, -0.5, 0.0, 0.5, 0.0, fold, 2.0)
		"soft":
			_P(c, o, s, a, [[-0.8, -0.35], [0, -0.45], [0.8, -0.35], [0.85, 0.35], [0, 0.45], [-0.85, 0.35]], pink)
			_L(c, o, s, a, -0.5, -0.1, 0.5, 0.1, fold, 3.0); _L(c, o, s, a, -0.4, 0.15, 0.3, 0.25, fold, 2.0)
		"appliance":
			_R(c, o, s, a, -0.78, -0.5, 1.56, 0.95, cream); _R(c, o, s, a, -0.62, -0.36, 1.0, 0.6, blue)
			_C(c, o, s, a, 0.56, -0.25, 0.07, red); _C(c, o, s, a, 0.56, 0.0, 0.07, gold); _L(c, o, s, a, -0.6, 0.6, 0.6, 0.6, Color(OUT), 3.0)
			_L(c, o, s, a, -0.55, -0.3, -0.3, -0.05, fold, 3.0)
		"table":
			_P(c, o, s, a, [[-0.85, -0.15], [0.85, -0.15], [0.65, 0.15], [-0.65, 0.15]], teal)
			_R(c, o, s, a, -0.62, 0.15, 0.1, 0.55, brown); _R(c, o, s, a, 0.52, 0.15, 0.1, 0.55, brown)
			for i in 5: _R(c, o, s, a, -0.5 + i * 0.2, -0.36, 0.14, 0.2, cream)
		"glasses":
			_C(c, o, s, a, -0.38, 0, 0.28, Color(0.8, 0.9, 0.95)); _C(c, o, s, a, 0.38, 0, 0.28, Color(0.8, 0.9, 0.95))
			_L(c, o, s, a, -0.1, -0.05, 0.1, -0.05, Color(OUT), 4.0); _L(c, o, s, a, -0.66, -0.05, -0.9, -0.2, Color(OUT), 4.0); _L(c, o, s, a, 0.66, -0.05, 0.9, -0.2, Color(OUT), 4.0)
			_L(c, o, s, a, -0.5, -0.12, -0.32, 0.06, fold, 3.0); _L(c, o, s, a, 0.26, -0.12, 0.44, 0.06, fold, 3.0)
		"umbrella":
			var pts = [[-0.85, 0.0]]
			for i in 9: pts.append([cos(PI + i * PI / 8.0) * 0.85, sin(PI + i * PI / 8.0) * 0.7])
			_P(c, o, s, a, pts, red)
			for i in 4: _L(c, o, s, a, 0, -0.7, -0.6 + i * 0.4, 0.0, Color(OUT), 1.5)
			_L(c, o, s, a, 0, 0, 0, 0.7, Color(OUT), 4.0); c.draw_arc(o + Vector2(-0.1, 0.7) * s * 0.5, 0.1 * s * 0.5, 0, PI, 12, Color(OUT, a), 4.0)
		"shirt":
			_P(c, o, s, a, [[-0.35, -0.6], [-0.85, -0.35], [-0.7, -0.05], [-0.5, -0.15], [-0.5, 0.7], [0.5, 0.7], [0.5, -0.15], [0.7, -0.05], [0.85, -0.35], [0.35, -0.6], [0.15, -0.45], [-0.15, -0.45]], blue)
			_P(c, o, s, a, [[-0.15, -0.45], [0, -0.25], [0.15, -0.45]], cream)
			for i in 3: _C(c, o, s, a, 0, -0.05 + i * 0.22, 0.04, cream, false)
			_L(c, o, s, a, -0.3, 0.0, -0.3, 0.6, fold, 2.0)
		"cat":
			_P(c, o, s, a, [[-0.6, 0.65], [-0.5, 0.0], [0.4, 0.0], [0.55, 0.65]], Color(0.95, 0.7, 0.35))
			_C(c, o, s, a, 0, -0.25, 0.36, Color(0.95, 0.7, 0.35))
			_P(c, o, s, a, [[-0.3, -0.5], [-0.32, -0.82], [-0.08, -0.6]], Color(0.95, 0.7, 0.35)); _P(c, o, s, a, [[0.3, -0.5], [0.32, -0.82], [0.08, -0.6]], Color(0.95, 0.7, 0.35))
			_C(c, o, s, a, -0.13, -0.28, 0.05, OUT, false); _C(c, o, s, a, 0.13, -0.28, 0.05, OUT, false); _C(c, o, s, a, -0.22, -0.12, 0.05, pink, false); _C(c, o, s, a, 0.22, -0.12, 0.05, pink, false)
			_L(c, o, s, a, 0.5, 0.5, 0.85, 0.1, Color(OUT), 5.0); _L(c, o, s, a, -0.1, -0.15, -0.45, -0.18, Color(OUT), 1.2); _L(c, o, s, a, 0.1, -0.15, 0.45, -0.18, Color(OUT), 1.2)
		"house":
			_R(c, o, s, a, -0.7, -0.2, 1.4, 0.9, cream); _P(c, o, s, a, [[-0.85, -0.2], [0, -0.8], [0.85, -0.2]], red)
			for i in 2:
				for k in 2: _R(c, o, s, a, -0.5 + i * 0.68, -0.05 + k * 0.38, 0.28, 0.22, blue)
			_R(c, o, s, a, -0.12, 0.38, 0.24, 0.32, brown); _L(c, o, s, a, -0.6, -0.2, 0.6, -0.2, Color(OUT), 3.0)
		"phone":
			_R(c, o, s, a, -0.32, -0.75, 0.64, 1.3, Color(0.25, 0.25, 0.3)); _R(c, o, s, a, -0.25, -0.62, 0.5, 1.0, blue)
			_P(c, o, s, a, [[-0.4, 0.55], [0.4, 0.55], [0.55, 0.8], [-0.55, 0.8]], brown); _L(c, o, s, a, -0.18, -0.5, 0.05, -0.2, fold, 3.0)
		"doc":
			_P(c, o, s, a, [[-0.55, -0.72], [0.38, -0.72], [0.55, -0.55], [0.55, 0.72], [-0.55, 0.72]], cream)
			for i in 6: _L(c, o, s, a, -0.4, -0.45 + i * 0.18, 0.38 - (0.2 if i == 5 else 0.0), -0.45 + i * 0.18, Color(0.4, 0.3, 0.2, 0.6), 2.0)
			_C(c, o, s, a, 0.28, 0.48, 0.14, red); _L(c, o, s, a, 0.38, -0.72, 0.38, -0.55, Color(OUT), 1.5); _L(c, o, s, a, 0.38, -0.55, 0.55, -0.55, Color(OUT), 1.5)
		"letter":
			_R(c, o, s, a, -0.8, -0.45, 1.6, 0.95, cream); _P(c, o, s, a, [[-0.8, -0.45], [0, 0.12], [0.8, -0.45]], Color(0.92, 0.84, 0.66))
			_C(c, o, s, a, 0, 0.08, 0.13, red)
		"vehicle":
			_C(c, o, s, a, -0.52, 0.42, 0.26, Color(0.25, 0.25, 0.3)); _C(c, o, s, a, 0.52, 0.42, 0.26, Color(0.25, 0.25, 0.3))
			_C(c, o, s, a, -0.52, 0.42, 0.1, cream, false); _C(c, o, s, a, 0.52, 0.42, 0.1, cream, false)
			_P(c, o, s, a, [[-0.6, 0.2], [-0.2, -0.15], [0.35, -0.15], [0.55, 0.2], [0.2, 0.35], [-0.3, 0.35]], red)
			_L(c, o, s, a, 0.35, -0.15, 0.5, -0.5, Color(OUT), 4.0); _L(c, o, s, a, 0.4, -0.5, 0.65, -0.5, Color(OUT), 4.0); _R(c, o, s, a, -0.35, -0.3, 0.4, 0.12, brown)
		"rod":
			_L(c, o, s, a, -0.8, 0.7, 0.75, -0.75, brown, 6.0); _C(c, o, s, a, -0.45, 0.35, 0.13, gold); _L(c, o, s, a, 0.75, -0.75, 0.75, 0.35, Color(0.9, 0.9, 0.9, 0.9), 1.5)
			_C(c, o, s, a, 0.75, 0.42, 0.08, red)
		"cake":
			_R(c, o, s, a, -0.7, 0.05, 1.4, 0.6, Color(0.95, 0.85, 0.7)); _R(c, o, s, a, -0.45, -0.4, 0.9, 0.45, cream)
			for i in 7: _C(c, o, s, a, -0.6 + i * 0.2, 0.05, 0.08, Color.WHITE, false)
			_C(c, o, s, a, 0, -0.5, 0.1, red)
		"bag":
			_P(c, o, s, a, [[-0.55, -0.35], [0.55, -0.35], [0.7, 0.7], [-0.7, 0.7]], Color(0.82, 0.68, 0.45))
			c.draw_arc(o + Vector2(0, -0.35) * s * 0.5, 0.28 * s * 0.5, PI, TAU, 16, Color(OUT, a), 3.0)
			_R(c, o, s, a, -0.3, 0.05, 0.6, 0.3, red); _L(c, o, s, a, -0.4, -0.2, -0.5, 0.6, fold, 2.0)
		"figure":
			_P(c, o, s, a, [[-0.18, -0.25], [0.18, -0.25], [0.5, 0.75], [-0.5, 0.75]], teal)
			_C(c, o, s, a, 0, -0.48, 0.25, cream); _C(c, o, s, a, -0.12, -0.42, 0.05, pink, false); _C(c, o, s, a, 0.12, -0.42, 0.05, pink, false)
			_C(c, o, s, a, -0.09, -0.52, 0.03, OUT, false); _C(c, o, s, a, 0.09, -0.52, 0.03, OUT, false)
			_L(c, o, s, a, -0.22, -0.05, -0.62, 0.25, Color(OUT), 4.0); _L(c, o, s, a, 0.22, -0.05, 0.62, 0.25, Color(OUT), 4.0)
			_R(c, o, s, a, -0.18, 0.15, 0.36, 0.3, red)
		_:   # box
			_R(c, o, s, a, -0.65, -0.25, 1.3, 0.95, red); _R(c, o, s, a, -0.75, -0.45, 1.5, 0.24, Color("#d8473a"))
			_R(c, o, s, a, -0.08, -0.45, 0.16, 1.15, gold); _R(c, o, s, a, -0.65, 0.12, 1.3, 0.14, gold)
			_P(c, o, s, a, [[0, -0.45], [-0.35, -0.72], [-0.3, -0.45]], gold); _P(c, o, s, a, [[0, -0.45], [0.35, -0.72], [0.3, -0.45]], gold)
			_L(c, o, s, a, -0.5, -0.1, -0.5, 0.55, fold, 2.0)

static func _P(c: CanvasItem, o: Vector2, s: float, a: float, pts: Array, col: Color, line := true) -> void:
	var pv = PackedVector2Array()
	for q in pts: pv.append(o + Vector2(q[0], q[1]) * s * 0.5)
	c.draw_colored_polygon(pv, Color(col, a))
	if line:
		var pl = pv.duplicate(); pl.append(pv[0]); c.draw_polyline(pl, Color(OUT, a), 2.5, true)
static func _C(c: CanvasItem, o: Vector2, s: float, a: float, x: float, y: float, r: float, col: Color, line := true) -> void:
	c.draw_circle(o + Vector2(x, y) * s * 0.5, r * s * 0.5, Color(col, a))
	if line: c.draw_arc(o + Vector2(x, y) * s * 0.5, r * s * 0.5, 0, TAU, 32, Color(OUT, a), 2.5, true)
static func _L(c: CanvasItem, o: Vector2, s: float, a: float, x1: float, y1: float, x2: float, y2: float, col := Color(0.165, 0.102, 0.063), w := 2.0) -> void:
	c.draw_line(o + Vector2(x1, y1) * s * 0.5, o + Vector2(x2, y2) * s * 0.5, Color(col, a * col.a), w, true)
static func _R(c: CanvasItem, o: Vector2, s: float, a: float, x: float, y: float, w: float, h: float, col: Color) -> void:
	_P(c, o, s, a, [[x, y], [x + w, y], [x + w, y + h], [x, y + h]], col)
