# [ctl] 第一期「操作」：底部行動按鈕、「出擊」清單、地圖目標手指大小點擊（敵人優先）、村門唔再開舊地圖、「地盤」掣變灰、主角喺大排檔／野外都睇到
#   掛法（main.gd 一行）：load("res://game/outpost/ctl_ui.gd").attach(main)
#   目標全部經 act_targets.gd（AT.collect）；主角走路經 zone_walk（→ ctl_walk.gd 全圖可走）。
#   冇 class_name、冇 autoload（熱更新規矩）。
extends Node

const AT = preload("res://game/outpost/act_targets.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const NEAR := 120.0          # 主角距離「企位」幾多（世界 px）之內就出行動按鈕
const FINGER_PX := 28.0      # 手指半徑（畫面 px）：點擊範圍最少 56px 闊
const LIST_MAX := 5
const BOOST := 1.6           # 出擊清單自動行：額外加速（倍數 × 正常步速）
const C_OK := Color("#7be08a")
const C_MID := Color("#ffd45a")
const C_BAD := Color("#ff7a66")

static var inst = null       # 而家嗰個（weakref 唔使：跟 main 一齊死）
static var LOG: Array = []   # 測試：[["go"/"tap"/"list"/"nav", id], …]

var main = null
var act_btn: Button
var act_face: Control
var act_name: Label
var act_pow: Label
var act_tag: Label
var sortie_btn: Button
var hero_ov: Control         # 主角喺大排檔／野外：MvScene 之上再畫一次
var hero_ov2: Node2D
var cur = {}                 # 行動按鈕而家對住嘅目標
var auto = {}                # 出擊清單揀咗、主角行緊過去嘅目標
var _t := 0.0
var _toast_b0 = null
var _ts: Array = []          # 目標快取（每 SCAN 秒重收一次，慳效能）
var _scan := 0.0
const SCAN := 0.15

static func attach(m) -> Node:
	if inst != null and is_instance_valid(inst): return inst
	var n = load("res://game/outpost/ctl_ui.gd").new(); n.name = "CtlUI"
	n.main = m
	m.add_child(n)
	inst = n
	return n

static func L(yue: String, zhs: String) -> String: return ZD.L(yue, zhs)

func _ready() -> void:
	_build_act()
	_build_sortie()

# ================= 行動按鈕 =================
func _build_act() -> void:
	act_btn = Button.new(); act_btn.name = "CtlAct"; act_btn.focus_mode = Control.FOCUS_NONE
	var n = UIKit.sb(Color(0.10, 0.06, 0.06, 0.94), 14, Color("#e8b070"), 2, Vector4(8, 6, 14, 6))
	n.shadow_color = Color(0, 0, 0, 0.55); n.shadow_size = 8; n.shadow_offset = Vector2(0, 3)
	var h = n.duplicate(); h.bg_color = Color(0.16, 0.08, 0.07, 0.96)
	var p = n.duplicate(); p.bg_color = Color(0.30, 0.10, 0.08, 0.98)
	for k in ["normal", "hover", "focus"]: act_btn.add_theme_stylebox_override(k, n if k != "hover" else h)
	act_btn.add_theme_stylebox_override("pressed", p)
	act_btn.anchor_left = 0.5; act_btn.anchor_right = 0.5; act_btn.anchor_top = 1; act_btn.anchor_bottom = 1
	act_btn.offset_left = -146; act_btn.offset_right = 146; act_btn.offset_top = -184; act_btn.offset_bottom = -114
	var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 8; hb.offset_right = -12; hb.offset_top = 6; hb.offset_bottom = -6
	hb.add_theme_constant_override("separation", 10); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	act_btn.add_child(hb)
	act_face = Control.new(); act_face.custom_minimum_size = Vector2(58, 58); act_face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	act_face.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	act_face.draw.connect(func(): _draw_face(act_face, cur))
	hb.add_child(act_face)
	var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 2); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(vb)
	act_name = UIKit.label("", 19, Color("#fff0d6"), "serif", 900); act_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	act_name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; act_name.clip_text = true
	vb.add_child(act_name)
	var pr = HBoxContainer.new(); pr.add_theme_constant_override("separation", 8); pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(pr)
	act_pow = UIKit.label("", 16, Color("#f0dcc0"), "sans", 700); act_pow.mouse_filter = Control.MOUSE_FILTER_IGNORE; pr.add_child(act_pow)
	act_tag = UIKit.label("", 16, C_OK, "sans", 900); act_tag.mouse_filter = Control.MOUSE_FILTER_IGNORE; pr.add_child(act_tag)
	act_btn.pressed.connect(press_act)
	act_btn.visible = false
	main.add_child(act_btn)
	if main.get("sheet") != null: main.move_child(act_btn, main.sheet.get_index())   # 面板、劇情蓋住佢

func press_act() -> void:
	if cur.is_empty() or not act_btn.visible: return
	var t = cur
	LOG.append(["go", str(t.id)])
	Snd.play("click")
	auto = {}
	if t.get("go") is Callable and t.go.is_valid(): t.go.call()

# 戰力對比：[文字, 標籤, 顏色]
static func pow_info(t: Dictionary) -> Array:
	var my = int(t.get("my_pow", 0)); var foe = int(t.get("foe_pow", 0))
	if foe <= 0: return ["", L("撳一下入去", "點一下進入"), C_OK]
	var lab = L("陰兵 %d／建議 %d", "陰兵 %d／建議 %d") if str(t.get("kind")) == "res" else L("鬼力 %d／敵 %d", "鬼力 %d／敵 %d")
	if str(t.get("kind")) == "res" and load("res://game/militia/ml_data.gd").power() > 0: lab = L("兵力 %d／建議 %d", "兵力 %d／建議 %d")   # [militia] 陰兵＋遊魂兵
	var r = float(my) / float(maxi(1, foe))
	if r >= 1.0: return [lab % [my, foe], L("勝算高", "勝算高"), C_OK]
	if r >= 0.8: return [lab % [my, foe], L("有啲險", "有點險"), C_MID]
	return [lab % [my, foe], L("好危險", "很危險"), C_BAD]

# 頭像：圓框＋角色上半身（資源區：鎖）
func _draw_face(c: Control, t: Dictionary) -> void:
	var sz = c.size
	var col = pow_info(t)[2] if not t.is_empty() else C_OK
	c.draw_circle(sz / 2.0, sz.x / 2.0, Color(0.22, 0.14, 0.13))
	if not t.is_empty():
		var ctx = Ctx.new(c)
		var ic = str(t.get("icon", ""))
		if ic == "": load("res://game/zone/zone_view.gd")._lock(ctx, sz.x / 2.0, sz.y * 0.36, sz.x * 0.46)
		else:   # 成隻縮入圓框，唔裁（大隻王按 CHAR_H 縮細）
			var sc = 0.8 * sz.x / 58.0
			var ch = float(Art.char_h(ic))
			if ch > 0.0: sc = minf(sc, sz.y * 0.7 / ch)
			Art.draw_char(ctx, ic, sz.x / 2.0, sz.y * 0.88, sc, {"t": _t, "flip": false, "seed": str(t.id)})
	c.draw_arc(sz / 2.0, sz.x / 2.0 - 1.5, 0, TAU, 40, col, 3.0, true)

# ================= 「出擊」掣＋清單 =================
func _build_sortie() -> void:
	sortie_btn = Button.new(); sortie_btn.name = "CtlSortie"; sortie_btn.text = L("出擊", "出擊"); sortie_btn.focus_mode = Control.FOCUS_NONE
	sortie_btn.add_theme_font_override("font", UIKit.font("serif", 900)); sortie_btn.add_theme_font_size_override("font_size", 16)
	var n = UIKit.sb(Color("#8e2a20"), 8, Color("#f2b088"), 2, Vector4(8, 2, 8, 2))
	n.shadow_color = Color(0, 0, 0, 0.5); n.shadow_size = 4; n.shadow_offset = Vector2(0, 2)
	var p = n.duplicate(); p.bg_color = Color("#6a1c14")
	for k in ["normal", "hover"]: sortie_btn.add_theme_stylebox_override(k, n)
	sortie_btn.add_theme_stylebox_override("pressed", p); sortie_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: sortie_btn.add_theme_color_override(k, Color("#fff0dc"))
	sortie_btn.anchor_left = 1; sortie_btn.anchor_right = 1; sortie_btn.anchor_top = 1; sortie_btn.anchor_bottom = 1
	sortie_btn.offset_left = -172; sortie_btn.offset_right = -94; sortie_btn.offset_top = -58 - 46; sortie_btn.offset_bottom = -58 - 12
	sortie_btn.pressed.connect(open_list)
	sortie_btn.visible = false
	main.add_child(sortie_btn)
	if main.get("sheet") != null: main.move_child(sortie_btn, main.sheet.get_index())

# 出擊清單：敵人（主線關卡先）＋可攻佔，按距離；最多 5 個
func list_targets() -> Array:
	var hp = hero_pos()
	var a = AT.collect(main).filter(func(t): return str(t.get("kind", "")) in ["stage", "king", "res", "raid"])   # [integ] 出擊只列可打目標（地標、兵營唔算；佢哋照用行動按鈕）
	a.sort_custom(func(x, y):
		var px = 0 if str(x.kind) == "stage" else 1; var py = 0 if str(y.kind) == "stage" else 1
		if px != py: return px < py
		return hp.distance_to(AT.stand_of(x)) < hp.distance_to(AT.stand_of(y)))
	return a.slice(0, LIST_MAX)
static func dist_txt(d: float) -> String: return L("約 %d 步", "約 %d 步") % maxi(1, int(round(d / 24.0)))

func open_list() -> void:
	if not ZD.on() or _busy(): return
	LOG.append(["list", ""])
	Snd.play("click")
	main.open_sheet(L("出擊", "出擊"), func(): pass)
	var body: VBoxContainer = main.sheet_body
	var ts = list_targets()
	var hp = hero_pos()
	var hint = UIKit.rich(DB.N(L("揀一個目標：鏡頭帶你過去，阿福自己行埋去，到咗撳底部個大掣就開打。", "選一個目標：鏡頭帶你過去，阿福自己走過去，到了按底部的大按鈕就開打。")), 16, UIKit.INKTXT)
	body.add_child(hint)
	if ts.is_empty():
		body.add_child(UIKit.rich("[color=#6e5838]%s[/color]" % L("而家冇可以打嘅目標。完成主線任務會開放更多地方。", "現在沒有可以打的目標。完成主線任務會開放更多地方。"), 16, UIKit.INKTXT))
		return
	for t in ts: body.add_child(_row(t, hp.distance_to(AT.stand_of(t))))

func _row(t: Dictionary, d: float) -> Control:
	var b = Button.new(); b.focus_mode = Control.FOCUS_NONE; b.custom_minimum_size = Vector2(0, 92)
	var n = UIKit.sb(Color("#f6e6bc"), 8, Color("#b89a52"), 1, Vector4(0, 0, 0, 0))
	var p = n.duplicate(); p.bg_color = Color("#e6cf94")
	for k in ["normal", "hover", "focus"]: b.add_theme_stylebox_override(k, n)
	b.add_theme_stylebox_override("pressed", p)
	var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 8; hb.offset_right = -10; hb.offset_top = 6; hb.offset_bottom = -6
	hb.add_theme_constant_override("separation", 10); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(hb)
	var face = Control.new(); face.custom_minimum_size = Vector2(62, 62); face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	face.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var tt = t
	face.draw.connect(func(): _draw_face(face, tt))
	hb.add_child(face)
	var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 1); vb.clip_contents = true; hb.add_child(vb)
	var nm = UIKit.label(str(t.name), 18, UIKit.INKTXT, "serif", 900); nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; nm.clip_text = true; vb.add_child(nm)
	var pi = pow_info(t)
	var col = {C_OK: Color("#2e7a36"), C_MID: Color("#9a6a00"), C_BAD: Color("#b02a1c")}.get(pi[2], UIKit.INKTXT)
	var ln = UIKit.rich("%s　[b][color=#%s]%s[/color][/b]" % [pi[0], col.to_html(false), pi[1]] if pi[0] != "" else "[b]%s[/b]" % pi[1], 16, UIKit.INKDIM)
	ln.autowrap_mode = TextServer.AUTOWRAP_OFF; ln.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(ln)
	var dl = UIKit.label(L("距離 %s", "距離 %s") % dist_txt(d), 16, UIKit.INKDIM, "sans", 700); dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(dl)
	b.pressed.connect(func(): pick(tt))
	b.set_meta("tid", str(t.id))
	return b

# 揀咗清單一項：鏡頭帶過去，主角自動行過去（到咗就出行動按鈕）
func pick(t: Dictionary) -> void:
	LOG.append(["pick", str(t.id)])
	main.close_sheet()
	if main.has_method("_nav_on"): main._nav_on("village")
	var nv = main.village
	if nv != null and nv.has_method("zone_cam"):
		var c = nv.zone_cam()
		if c != null: c.glide_to(t.pos)
	var st = AT.stand_of(t)
	var V = J.G.get("Village")
	if V is Dictionary:
		var H = V.hero
		H["act"] = null; H["target"] = null
		J.mc(V, "walkTo", [st.x, st.y, null])
	auto = t

# ================= 每格 =================
func hero_pos() -> Vector2:
	var V = J.G.get("Village")
	if not (V is Dictionary) or not (V.get("hero") is Dictionary): return Vector2.ZERO
	return Vector2(J.num(V.hero.x), J.num(V.hero.y))
func _busy() -> bool:
	var st = J.G.get("Story"); var ui = J.G.get("UI")
	if st != null and J.t(J.mc(st, "busy", [])): return true
	if ui != null and J.t(J.mc(ui, "modalOpen", [])): return true
	var sy = main.get("story")
	if sy != null and sy.has_method("busy") and sy.busy(): return true
	return false
# 行動按鈕／出擊掣可唔可以出（劇情、彈窗、戰鬥、標題畫面期間收埋）
func ui_ok() -> bool:
	if main == null or not ZD.on(): return false
	if main.get("loading") != null or main.get("title_ov") != null or main.get("phone") != null or main.get("selftest") != null: return false
	if str(main.get("tab")) != "village": return false
	if main.village == null or not main.village.is_visible_in_tree(): return false
	if main.sheet != null and main.sheet.visible: return false
	var SOVc = load("res://game/sortie/so_view.gd").card   # [soul2] 出擊小卡開住：浮動「出擊」掣、行動按鈕收起（唔遮小卡）
	if SOVc != null and is_instance_valid(SOVc): return false
	if _busy(): return false
	if load("res://game/zone/zone_battle.gd").busy(): return false
	var sc = main.get("mv_view")
	if sc != null and is_instance_valid(sc):
		if sc.get("card") != null or sc.get("anim") != null: return false
		var sh = sc.get("sheet")
		if sh is Control and sh.visible: return false
		var sim = sc.get("sim")
		if sim != null and sim.get("plus") != null and sim.plus.get("card") != null: return false
	return true

# 近邊個目標（敵人優先，然後最近）
func near_target(ts: Array) -> Dictionary:
	var hp = hero_pos(); var best = {}; var bk = INF
	for t in ts:
		var d = hp.distance_to(AT.stand_of(t))
		if d > NEAR: continue
		var k = d - (1000.0 if AT.is_enemy(t) else 0.0)
		if k < bk: bk = k; best = t
	return best

func _process(dt: float) -> void:
	_t += dt
	if main == null or main.get("loading") != null: return
	_install_v()
	_nav_gray()
	var on = ZD.on()
	sortie_btn.visible = on and ui_ok()
	_scan -= dt
	if _scan <= 0.0 or not on: _scan = SCAN; _ts = AT.collect(main) if on else []
	var t = near_target(_ts) if ui_ok() else {}
	if t.is_empty() != cur.is_empty() or (not t.is_empty() and str(t.id) != str(cur.get("id", ""))) or (not t.is_empty() and (t.my_pow != cur.get("my_pow") or t.foe_pow != cur.get("foe_pow"))):
		cur = t
		if not t.is_empty():
			act_name.text = str(t.name)
			var pi = pow_info(t)
			act_pow.text = pi[0]; act_pow.visible = pi[0] != ""
			act_tag.text = pi[1]; act_tag.add_theme_color_override("font_color", pi[2])
	act_btn.visible = not cur.is_empty()
	if act_btn.visible: act_face.queue_redraw()
	_toasts_up(act_btn.visible)
	_auto_step(dt)
	_hero_overlay()

# toast 避開行動按鈕
func _toasts_up(up: bool) -> void:
	var tb = main.get("toasts")
	if not (tb is Control): return
	if _toast_b0 == null: _toast_b0 = tb.offset_bottom
	var want = -190.0 if up else float(_toast_b0)
	if tb.offset_bottom != want: tb.offset_bottom = want

# 出擊清單自動行：加快步速；玩家自己撳第二度（終點變咗）就停
func _auto_step(dt: float) -> void:
	if auto.is_empty(): return
	var V = J.G.get("Village")
	if not (V is Dictionary): auto = {}; return
	var H = V.hero
	var st = AT.stand_of(auto)
	var fin = Vector2(J.num(H.tx), J.num(H.ty))
	if H.get("zf") is Array: fin = Vector2(float(H.zf[0]), float(H.zf[1]))
	if fin.distance_to(st) > 40.0 or H.get("act") != null or H.get("target") != null: auto = {}; return
	var hp = hero_pos()
	if hp.distance_to(st) <= 6.0: auto = {}; return
	var tp = Vector2(J.num(H.tx), J.num(H.ty))
	var d = hp.distance_to(tp)
	if d <= 2.5 or not ui_ok(): return
	var sp = J.num(J.mc(J.G.get("F"), "walk", [])) * BOOST * minf(dt, 0.1)
	var np = hp + (tp - hp) / d * minf(sp, maxf(0.0, d - 2.0))
	H["x"] = np.x; H["y"] = np.y

# ================= 主角喺大排檔／野外：MvScene 蓋住村子世界，喺佢上面再畫一次主角 =================
func _hero_overlay() -> void:
	var nv = main.village
	if nv == null or not ZD.on():
		if hero_ov != null: hero_ov.visible = false
		return
	var sc = main.get("mv_view")
	if hero_ov == null:
		hero_ov = Control.new(); hero_ov.name = "CtlHeroOv"; hero_ov.mouse_filter = Control.MOUSE_FILTER_IGNORE; hero_ov.clip_contents = true
		hero_ov.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hero_ov2 = Node2D.new(); hero_ov.add_child(hero_ov2)
		hero_ov2.draw.connect(_draw_hero_ov)
		nv.add_child(hero_ov)
	if sc != null and is_instance_valid(sc) and sc.get_parent() == nv and hero_ov.get_index() != sc.get_index() + 1:
		nv.move_child(hero_ov, sc.get_index() + 1)
	var hp = hero_pos()
	var zid = ZD.zone_at(hp)
	var tp = str(ZD.zone(zid).get("type", "")) if zid != "" else ""
	var show = tp == "market" or tp == "wild" or (zid == "" and ZD.zrect("market").grow(60).has_point(hp))   # 走廊（出村門、野外門）近大排檔嗰邊都要畫
	hero_ov.visible = show and nv.get("hero_seg") != null
	if not hero_ov.visible: return
	var top = 0.0
	if sc != null and is_instance_valid(sc) and sc.get("hud_on") and nv.has_method("_zone_top_px"): top = nv._zone_top_px()
	if hero_ov.offset_top != top: hero_ov.offset_top = top
	hero_ov2.transform = Transform2D(0, Vector2(0, -top)) * nv.world.transform
	var n = nv.get("hero_seg")
	if n != null and is_instance_valid(n): hero_ov2.modulate = nv.ysort.modulate * n.self_modulate
	hero_ov2.queue_redraw()
func _draw_hero_ov() -> void:
	var nv = main.village
	var n = nv.get("hero_seg")
	if n == null or not is_instance_valid(n) or not n.has_meta("rec"): return
	var r = n.get_meta("rec")
	r.replay(hero_ov2, Transform2D.IDENTITY)

# ================= 村門：分區地圖唔再開舊世界地圖（hitTest 唔再認「gate」→ 撳落去就係行過去） =================
func _install_v() -> void:
	var V = J.G.get("Village")
	if not (V is Dictionary): return
	if V.get("__ctl_ht_w") != null and is_same(V.get("__ctl_ht_w"), V.get("hitTest")): return
	var o = V.get("hitTest")
	var ht = func(t, a):
		var r = J.cl(o, t, a)
		if ZD.on() and r is Dictionary and J.str(r.get("kind")) == "gate": return null   # [ctl] 村門保留、照畫，但唔再開地圖
		return r
	V["hitTest"] = ht; V["__ctl_ht_w"] = ht

# ================= 「地盤」掣：灰色，撳咗講「之後開放」 =================
func _nav_gray() -> void:
	var nb = main.get("nav_btns")
	if not (nb is Dictionary) or not nb.has("battle"): return
	var b: Button = nb.battle[0]
	var want = Color(0.42, 0.40, 0.40, 0.85) if ZD.on() else Color.WHITE
	if b.modulate != want: b.modulate = want
static func nav_battle(m) -> bool:
	if not ZD.on(): return false
	LOG.append(["nav", "battle"])
	if m != null and m.has_method("show_toast"): m.show_toast(L("「地盤」之後開放", "「地盤」之後開放"))
	return true

# ================= 地圖點擊（世界座標）：目標點擊範圍最少手指大小，重疊時敵人優先；回 true＝處理咗 =================
static func tap(m, p: Vector2) -> bool:
	if not ZD.on(): return false
	var z = 1.0
	if m != null and m.get("village") != null: z = maxf(0.05, float(m.village.sc))
	var t = pick_at(AT.collect(m), p, z)
	if t.is_empty(): return false
	LOG.append(["tap", str(t.id)])
	var f = t.get("tap") if t.get("tap") is Callable else t.get("go")
	if f is Callable and f.is_valid(): f.call()
	return true
static func hit_rect(t: Dictionary, z: float) -> Rect2:
	var r: Rect2 = t.hit if t.get("hit") is Rect2 else Rect2(t.pos.x - 40, t.pos.y - 110, 80, 130)
	var mw = FINGER_PX * 2.0 / z
	if r.size.x < mw: r = r.grow_individual((mw - r.size.x) / 2.0, 0, (mw - r.size.x) / 2.0, 0)
	if r.size.y < mw: r = r.grow_individual(0, (mw - r.size.y) / 2.0, 0, (mw - r.size.y) / 2.0)
	return r
static func pick_at(ts: Array, p: Vector2, z: float) -> Dictionary:
	var best = {}; var bk = INF
	for t in ts:
		var r = hit_rect(t, z)
		var c = r.get_center()
		var ok = r.has_point(p) or c.distance_to(p) <= FINGER_PX / z
		if not ok: continue
		var k = c.distance_to(p) - (1.0e6 if AT.is_enemy(t) else 0.0)
		if k < bk: bk = k; best = t
	return best

# 撳大排檔／野外空地：主角行過去（mv_embed.zone_world_tap 掛鈎）
static func walk_free(wp: Vector2) -> void:
	if not ZD.on(): return
	var V = J.G.get("Village")
	if V is Dictionary: J.mc(V, "walkTo", [wp.x, wp.y, null])
