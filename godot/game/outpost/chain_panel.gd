# 生產鏈面板（面板線 chainui）：睇晒 T1→T5 每樣材料由邊度嚟、用乜做、去咗邊。冇 class_name、冇 autoload（熱更新規矩）。
# 掛鈎（mv_scene.gd _build 一行）：load("res://game/outpost/chain_panel.gd").attach(self)
#   attach 會喺移動村 HUD 下面右邊加一個「生產鏈」掣（mode = "btn"）；撳落開全螢幕面板（mode = "panel"）。
#   冇移動村場景都開得：load(...).open_in(父 Control)（測試用）。
# 資料：全部經 mat.gd（data/nat/chain.json）＋ mv_data.gd（outpost.json 嘅台名、地圖）。
# 存檔：S.mat_seen = {mid: true}（「新！」睇過就唔再顯示；舊資源 res 有值嘅唔當新）。
# 反查用 mat.gd（M.makers／M.users／M.bin／M.bout／M.rin／M.rout）；解鎖用 chain_eco.gd（CE.unlocked／need_ci／lv）。
#   後院建築（GATHER／WORKSHOPS）：CE.unlocked(bid)（frontier ≥ unlock.ci）先起得；CE.lv(bid) > 0 先算起咗
#   移動村台（RECIPES）：台喺邊張圖（outpost.json MAPS.stations）；CARRY 隨村台每張圖都有；
#     未到嗰張圖 → 鎖；到咗但 S.mv.st[sid].unlocked 未開 → 鎖；過咗嘅圖（已拔營）→ 當有（分村）
extends Control

const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const SELF_PATH := "res://game/outpost/chain_panel.gd"
const FW := 390.0
const INK := Color("#2b1d12")
const PAPER := Color(0.93, 0.85, 0.64, 0.99)
const LINE := Color("#b89a52")
const RED := Color("#b8322a")
const GREEN := Color("#3d7a3a")
const DIMC := Color("#5e4a30")
const LOCKC := Color("#9c2219")
const ICON_COL := ["#d8452e", "#4f7fc0", "#5aa05a", "#b07a30", "#8a5ac0", "#c0a030", "#3aa0a0", "#c05a8a"]
const TIER_N := {1: ["原料", "原料"], 2: ["半成品", "半成品"], 3: ["三級貨", "三級貨"], 4: ["四級貨", "四級貨"], 5: ["頂級貨", "頂級貨"]}
const SLOT_N := {"body": ["身", "身體"], "legs": ["腳", "腿腳"], "head": ["頭", "頭部"], "hand": ["手", "手持"], "shield": ["盾", "盾牌"]}
const MAX_NODES := 40
const MAX_DEPTH := 6

var mode := "panel"        # "btn"／"panel"
var scene = null           # mv_scene（冇都得）
var panel = null           # btn 模式：開咗嘅面板
var owner_btn = null       # panel 模式：開佢嘅掣
var tier := 1
var open_mid := ""
var rows := {}             # mid → 行 Control
var tabs := []             # [Button, 新字 Label]
var view: Control
var list: VBoxContainer
var cap_lbl: Label
var scroll := 0.0
var vel := 0.0
var _press = null
var _hits := []            # [Control, Callable]（撳中邊個）
var _viewed := {}          # 睇過嘅層
var _t := 0.0
var _new_cache := false
var _new_t := 0.0

# ================= 文字 =================
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[0]) if DB.lang == "yue" else str(a[1])
	return str(a) if a != null else ""
static func S(key: String, yue: String, zh: String) -> String:
	var dflt = yue if DB.lang == "yue" else zh
	var a = M.D().STRINGS.get(key)
	if not (a is Array): return dflt
	var s = T(a)
	return s if _sig(s) == _sig(dflt) else dflt
static func _sig(s: String) -> String:
	var o = ""; var i = s.find("%")
	while i >= 0 and i + 1 < s.length():
		o += s[i + 1]; i = s.find("%", i + 2)
	return o
static func qty(v: float) -> String: return MD.fmt(v) if absf(v) >= 1e4 else M.qty(v)

# ================= 反查（全部用 mat.gd 引擎線版本嘅索引，唔自己再寫一套）=================
static func makers(mid: String) -> Array: return M.makers(mid)     # [{"k":"gather"|"shop"|"st","id"}]
static func users(mid: String) -> Array: return M.users(mid)
static func _dict(v) -> Dictionary: return v if v is Dictionary else {}
static func mk_def(mk: Dictionary) -> Dictionary:
	return M.recipe(str(mk.id)) if str(mk.k) == "st" else M.bld(str(mk.id))
static func mk_in(mk: Dictionary) -> Dictionary:
	match str(mk.k):
		"gather": return {}
		"shop": return M.bin(str(mk.id))
	return M.rin(str(mk.id))
static func mk_outs(mk: Dictionary) -> Array:   # 呢個建築／台出乜（mid 陣列）
	if str(mk.k) == "st": return [M.rout(str(mk.id))]
	return M.bout(str(mk.id)).keys().map(func(x): return str(x))
static func mk_name(mk: Dictionary) -> String:
	if str(mk.k) == "st":
		var n = MD.st_def(str(mk.id)).get("n")
		return T(n) if n != null else str(mk.id)
	var n2 = mk_def(mk).get("n")
	return T(n2) if n2 != null else str(mk.id)
static func is_carry(sid: String) -> bool: return sid in M.carry()
static func is_gear(mid: String) -> bool: return M.is_gear(mid)
static func is_item(mid: String) -> bool: return M.is_item(mid)
static func tier_ids(t: int) -> Array:
	var o = []
	for k in M.D().MATS:
		if M.tier(str(k)) == t: o.append(str(k))
	o.sort_custom(func(a, b):
		var ca = _first_ci(a); var cb = _first_ci(b)
		if ca != cb: return ca < cb
		if M.price(a) != M.price(b): return M.price(a) < M.price(b)
		return a < b)
	return o
static func _first_ci(mid: String) -> int:
	var best = 99
	for mk in makers(mid): best = mini(best, mk_ci(mk))
	return best

# ================= 解鎖 =================
static func _S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func cur_ci() -> int:
	var s = _S()
	if s == null or not (s.get("mv") is Dictionary): return 0
	return int(J.num(s.mv.get("ci", 0)))
static func frontier() -> int: return CE.frontier()   # 引擎線 chain_eco.gd
static func st_ci(sid: String) -> int:   # 移動村台喺第幾張圖（-1 = 冇；隨村台 = 0）
	if is_carry(sid): return 0
	for m in MD.D().MAPS:
		if sid in m.get("stations", []): return int(m.get("ci", 0))
	return -1
static func mk_ci(mk: Dictionary) -> int:   # 最早喺邊張圖有
	if str(mk.k) == "st": return maxi(0, st_ci(str(mk.id)))
	return CE.need_ci(str(mk.id))
static func bld_lv(bid: String) -> float: return CE.lv(bid)
static func map_name(ci: int) -> String: return T(MD.map_def(ci).get("name", ["", ""]))
static func _map_lock(ci: int) -> String:
	var nm = map_name(ci)
	if nm == "": return S("cp_lk_map0", "去到第 %d 張圖先解鎖", "到第 %d 張地圖才解鎖") % (ci + 1)
	return S("cp_lk_map", "去到第 %d 張圖「%s」先解鎖", "到第 %d 張地圖「%s」才解鎖") % [ci + 1, nm]
# {"ok":bool, "why":String, "past":bool}
static func mk_state(mk: Dictionary) -> Dictionary:
	if str(mk.k) == "st":
		var sid = str(mk.id); var c = cur_ci(); var mc = st_ci(sid)
		if mc < 0: return {"ok": false, "why": S("cp_lk_none", "呢個台未有", "這個台還沒有")}
		if not is_carry(sid):
			if mc > c: return {"ok": false, "why": _map_lock(mc)}
			if mc < c: return {"ok": true, "why": "", "past": true}
		var s = _S(); var e = null
		if s != null and s.get("mv") is Dictionary and s.mv.get("st") is Dictionary: e = s.mv.st.get(sid)
		if e is Dictionary and J.t(e.get("unlocked")): return {"ok": true, "why": ""}
		return {"ok": false, "why": S("cp_lk_st", "移動村「%s」未開", "移動村「%s」還沒開") % mk_name(mk)}
	if not CE.unlocked(str(mk.id)): return {"ok": false, "why": _map_lock(CE.need_ci(str(mk.id)))}
	if bld_lv(str(mk.id)) <= 0.0: return {"ok": false, "why": S("cp_lk_bld", "後院未起「%s」", "後院還沒建「%s」") % mk_name(mk)}
	return {"ok": true, "why": ""}
static func mat_state(mid: String) -> Dictionary:
	var ms = makers(mid)
	if ms.is_empty(): return {"ok": false, "why": S("cp_lk_nomk", "暫時冇地方做", "暫時沒地方做")}
	var why = ""; var best = 99
	for mk in ms:
		var st = mk_state(mk)
		if st.ok: return st
		var c = mk_ci(mk)
		if why == "" or c < best: why = st.why; best = c
	return {"ok": false, "why": why}
static func unlocked(mid: String) -> bool: return mat_state(mid).ok

# ================= 「新！」 =================
static func _seen() -> Dictionary:
	var s = _S()
	if s == null: return {}
	if not (s.get("mat_seen") is Dictionary): s["mat_seen"] = {}
	return s.mat_seen
static func is_new(mid: String) -> bool:
	if M.res_key(mid) != "": return false      # 舊資源（槐木、糯米、棺材板、壽包…）唔當新
	return M.amt(mid) > 0.0 and not J.t(_seen().get(mid))
static func has_new(t := 0) -> bool:
	for k in M.D().MATS:
		if (t == 0 or M.tier(str(k)) == t) and is_new(str(k)): return true
	return false
static func mark_seen(t := 0) -> void:
	var sn = _seen()
	for k in M.D().MATS:
		if (t == 0 or M.tier(str(k)) == t) and M.amt(str(k)) > 0.0: sn[str(k)] = true

# ================= 掛鈎 =================
static func attach(sc) -> Control:
	var b = load(SELF_PATH).new(); b.mode = "btn"; b.scene = sc; b.name = "ChainBtn"
	var host = sc.get("frame") if sc.get("frame") != null else sc
	host.add_child(b)
	return b
static func open_in(parent: Control, sc = null) -> Control:
	var p = load(SELF_PATH).new(); p.mode = "panel"; p.scene = sc; p.name = "ChainPanel"
	parent.add_child(p)
	return p

func _ready() -> void:
	if mode == "btn":
		custom_minimum_size = Vector2(88, 38); size = custom_minimum_size
		mouse_filter = Control.MOUSE_FILTER_STOP
		gui_input.connect(_btn_input)
		_place_btn()
	else:
		_build_panel()
	set_process(true)

# ---------------- 掣 ----------------
func _place_btn() -> void:
	if scene == null: return
	var tp = float(scene.get("top_pad")) if scene.get("top_pad") != null else 0.0
	var hh = float(scene.get("HUD_H")) if scene.get("HUD_H") != null else 90.0
	position = Vector2(FW - size.x - 8.0, tp + hh + 6.0)
	if scene.has_method("chain_btn_pos"): position = scene.chain_btn_pos(size)   # [camp] 避開影響力條同台名牌
	visible = scene.get("anim") == null and scene.get("card") == null and (panel == null or not is_instance_valid(panel))
	var sm = scene.get("sim")   # [polish4] 大單／招牌彈出卡開住：收埋，唔好壓住卡嘅掣
	if visible and sm != null and sm.get("plus") != null and sm.plus.get("card") != null: visible = false
	if scene.get("embed") == true and scene.get("hud_k") != null and float(scene.hud_k) < 0.5:   # [unify] 合一地圖：睇到大排檔區先出
		var vs = get_viewport_rect().size
		if vs.x > vs.y * 1.2 and visible and scene.get("zone") == true:   # [uxui2] 寬屏（PC）：大排檔 HUD 收埋都照出「生產鏈」，擺右側欄
			position = Vector2(FW - size.x - 8.0, tp + 8.0)
		else: visible = false
func _btn_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT and not ev.pressed and Rect2(Vector2.ZERO, size).has_point(ev.position):
		open_panel(); accept_event()
func open_panel() -> Control:
	if panel != null and is_instance_valid(panel): return panel
	var host = get_parent()
	panel = open_in(host, scene); panel.owner_btn = self
	if scene != null and scene.has_method("close_sheet"): scene.close_sheet()
	_snd("click"); visible = false
	return panel
func _draw() -> void:
	if mode != "btn": return
	var r = Rect2(Vector2.ZERO, size)
	draw_style_box(UIKit.sb(Color("#3a2c26"), 10, Color("#f2d090"), 2), r)
	var f = UIKit.font("sans", 900)
	draw_string(f, Vector2(0, size.y / 2.0 + 6.0), S("cp_btn", "生產鏈", "生產鏈"), HORIZONTAL_ALIGNMENT_CENTER, size.x, 17, Color("#fff3e0"))
	if _new_cache:
		draw_circle(Vector2(size.x - 6.0, 6.0), 7.0, Color("#e0402e")); draw_arc(Vector2(size.x - 6.0, 6.0), 7.0, 0, TAU, 20, Color("#fff3e0"), 1.5)

# ---------------- 面板 ----------------
func _geom() -> Rect2:
	if scene != null and scene.get("H") != null:
		var tp = float(scene.top_pad); var bp = float(scene.bot_pad)
		return Rect2(0, tp, FW, float(scene.H) - tp - bp)
	var ps = get_parent().size if get_parent() is Control else Vector2(FW, 844)
	return Rect2(0, 0, FW, ps.y * FW / maxf(1.0, ps.x)) if ps.x > 0 else Rect2(0, 0, FW, 844)

func _ign(c: Control) -> Control:
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE; return c
func _lbl(t0: String, sz := 15, col := INK, w := 700, kind := "sans") -> Label:
	var l = UIKit.label(t0, maxi(14, sz), col, kind, w); _ign(l)
	return l
func _wl(t0: String, sz := 14, col := DIMC, w := 700) -> Label:   # 會摺行
	var l = _lbl(t0, sz, col, w); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l

var _host_hidden := []     # 面板開住時收埋嘅主畫面浮動掣（例如「後院」）：[[node, visible]]
func _hide_host_btns(on: bool) -> void:
	if on:
		var m = scene.get("main") if scene != null else null
		if m == null or not is_instance_valid(m): return
		for k in ["mv_back"]:
			var n = m.get(k)
			if n is CanvasItem and is_instance_valid(n): _host_hidden.append([n, n.visible]); n.visible = false
	else:
		for e in _host_hidden: if is_instance_valid(e[0]): e[0].visible = e[1]
		_host_hidden.clear()
func _exit_tree() -> void:
	if mode == "panel": _hide_host_btns(false)

func _build_panel() -> void:
	_hide_host_btns(true)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var g = _geom(); position = g.position; size = g.size
	var bgp = Panel.new(); _ign(bgp); bgp.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bgp.add_theme_stylebox_override("panel", UIKit.sb(PAPER, 0, LINE, 0)); add_child(bgp)
	var mc = MarginContainer.new(); _ign(mc); mc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]: mc.add_theme_constant_override("margin_" + side, 10)
	mc.add_theme_constant_override("margin_top", 8); mc.add_theme_constant_override("margin_bottom", 8)
	add_child(mc)
	var v = VBoxContainer.new(); _ign(v); v.add_theme_constant_override("separation", 6); mc.add_child(v)
	# 頂：標題＋關閉
	var h = HBoxContainer.new(); _ign(h); h.add_theme_constant_override("separation", 8); v.add_child(h)
	var tt = _lbl(S("cp_title", "生產鏈", "生產鏈"), 24, INK, 900, "serif"); tt.size_flags_vertical = Control.SIZE_SHRINK_CENTER; h.add_child(tt)
	var sub = _lbl(S("cp_sub", "撳一樣睇佢上下游", "點一樣看它的上下游"), 14, DIMC, 700); sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sub.clip_text = true; sub.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; h.add_child(sub)
	var cb = UIKit.btn("✕", "ghost", true); cb.name = "Close"; cb.custom_minimum_size = Vector2(48, 44); cb.focus_mode = Control.FOCUS_NONE
	cb.add_theme_font_size_override("font_size", 20); cb.pressed.connect(close); h.add_child(cb)
	# 分頁 T1–T5
	var th = HBoxContainer.new(); _ign(th); th.add_theme_constant_override("separation", 4); v.add_child(th)
	tabs.clear()
	for t in range(1, 6):
		var b = Button.new(); b.name = "Tab%d" % t; b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(0, 56); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 15)
		var tt2 = t
		b.pressed.connect(func(): set_tier(tt2))
		th.add_child(b)
		var nb = _lbl(S("cp_new", "新！", "新！"), 14, Color("#fff6e0"), 900)
		nb.add_theme_stylebox_override("normal", UIKit.sb(Color("#d8452e"), 6, Color("#fff3e0"), 1, Vector4(3, 0, 3, 0)))
		nb.anchor_left = 1.0; nb.anchor_right = 1.0; nb.offset_left = -27.0; nb.offset_right = 3.0; nb.offset_top = -9.0; nb.offset_bottom = 12.0
		nb.grow_horizontal = Control.GROW_DIRECTION_BEGIN; nb.visible = false; b.add_child(nb)
		tabs.append([b, nb])
	cap_lbl = _wl("", 14, DIMC); v.add_child(cap_lbl)
	# 列表（自己做拖動：滑鼠／手指都拖得，有慣性）
	view = Control.new(); view.name = "View"; view.clip_contents = true; view.mouse_filter = Control.MOUSE_FILTER_STOP
	view.size_flags_vertical = Control.SIZE_EXPAND_FILL; view.gui_input.connect(_view_input); view.draw.connect(_draw_bar); v.add_child(view)
	list = VBoxContainer.new(); _ign(list); list.add_theme_constant_override("separation", 6); view.add_child(list)
	set_tier(tier)

func set_tier(t: int) -> void:
	tier = clampi(t, 1, 5); _viewed[tier] = true
	if open_mid != "" and M.tier(open_mid) != tier: open_mid = ""
	scroll = 0.0; vel = 0.0
	_refresh_tabs(); _fill()
	_snd("click")

func _refresh_tabs() -> void:
	for i in tabs.size():
		var t = i + 1; var b: Button = tabs[i][0]
		var on = t == tier; var n = tier_ids(t).size()
		b.text = "T%d\n%s" % [t, T(TIER_N[t])]
		var bg = Color("#bb3427") if on else Color(0.23, 0.17, 0.15, 0.85 if n > 0 else 0.4)
		for stn in ["normal", "hover", "pressed", "disabled"]:
			b.add_theme_stylebox_override(stn, UIKit.sb(bg if stn != "pressed" else bg.darkened(0.15), 8, Color("#f2d090") if on else Color("#6a5040"), 2 if on else 1, Vector4(2, 4, 2, 4)))
		for cn in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(cn, Color("#fff3e0") if on or n > 0 else Color("#a89880"))
		tabs[i][1].visible = has_new(t)

func _clear(c: Node) -> void:
	for ch in c.get_children(): c.remove_child(ch); ch.queue_free()

func _fill() -> void:
	_clear(list); rows.clear(); _hits.clear()
	var ids = tier_ids(tier)
	var cap = {1: S("cp_cap1", "全部靠後院嘅採集建築攞", "全部靠後院的採集建築取得"), 2: S("cp_cap2", "後院加工建築用原料整", "後院加工建築用原料製作")}.get(tier, S("cp_cap3", "移動村嘅台用低一級材料做", "移動村的台用低一級材料做"))
	var nu = 0
	for m in ids: if unlocked(m): nu += 1
	cap_lbl.text = S("tier%d" % tier, T(TIER_N[tier]), T(TIER_N[tier])) + "｜" + cap + S("cp_cap_n", "｜共 %d 樣，開咗 %d 樣", "｜共 %d 種，已開 %d 種") % [ids.size(), nu]
	if ids.is_empty():
		list.add_child(_wl(S("cp_empty", "呢層暫時未有材料。", "這層暫時沒有材料。") if not M.D().MATS.is_empty() else S("cp_nodata", "生產鏈資料未有（data/nat/chain.json）。", "生產鏈資料還沒有（data/nat/chain.json）。"), 16, DIMC))
	for mid in ids:
		var r = _row(mid); rows[mid] = r; list.add_child(r)
	list.size = Vector2(_list_w(), 0)

func _list_w() -> float: return maxf(100.0, (view.size.x if view != null and view.size.x > 0 else FW - 20.0) - 8.0)

# ---------------- 一行 ----------------
func _icon(mid: String, sz: float) -> Control:
	var key = M.icon(mid)
	if key != "" and Spr.ok(key) and Spr.get_tex(key) != null:
		var tr = TextureRect.new(); _ign(tr); tr.texture = Spr.get_tex(key)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(sz, sz); tr.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		return tr
	var c = Control.new(); _ign(c); c.custom_minimum_size = Vector2(sz, sz); c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var nm = M.name(mid); var ch = nm.substr(0, 1) if nm.length() > 0 else "?"
	var col = Color(ICON_COL[absi(hash(mid)) % ICON_COL.size()])
	var fs = maxi(14, int(sz * 0.52))
	c.draw.connect(func():
		var ctr = Vector2(sz, sz) / 2.0
		c.draw_circle(ctr, sz / 2.0 - 1.0, col)
		c.draw_arc(ctr, sz / 2.0 - 1.0, 0, TAU, 28, Color("#2a1a10"), 1.5, true)
		c.draw_string(UIKit.font("sans", 900), Vector2(0, ctr.y + fs * 0.36), ch, HORIZONTAL_ALIGNMENT_CENTER, sz, fs, Color("#fff6e0")))
	return c

func _tag(t0: String, bg: Color) -> Label:
	var l = _lbl(t0, 14, Color("#fff6e0"), 900)
	l.add_theme_stylebox_override("normal", UIKit.sb(bg, 6, Color(0, 0, 0, 0), 0, Vector4(5, 0, 5, 1)))
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return l

func _where(mid: String) -> String:
	var o = []
	for mk in makers(mid):
		var suf = ""
		match str(mk.k):
			"gather", "shop": suf = S("cp_w_back", "（後院）", "（後院）")
			_:
				if is_carry(str(mk.id)): suf = "（%s）" % S("carry", "隨村台", "隨村台")
				else:
					suf = S("cp_w_map", "第 %d 張圖", "第 %d 張地圖") % (st_ci(str(mk.id)) + 1)
					if mk_state(mk).get("past", false): suf += S("cp_w_past", "・已拔營", "・已拔營")
					suf = "（%s）" % suf
		o.append(mk_name(mk) + suf)
	return "、".join(o) if o.size() else S("cp_w_none", "冇", "沒有")

func _uses_names(mid: String) -> Array:
	var o = []
	for u in users(mid):
		for m in mk_outs(u):
			if m != "" and not (M.name(m) in o): o.append(M.name(m))
	return o

func _row(mid: String) -> Control:
	var st = mat_state(mid); var ok = st.ok
	var pc = PanelContainer.new(); _ign(pc); pc.name = "Row_" + mid
	var bgc = Color(1, 0.97, 0.88, 0.95) if ok else Color(0.78, 0.75, 0.7, 0.9)
	pc.add_theme_stylebox_override("panel", UIKit.sb(bgc, 8, RED if open_mid == mid else LINE, 2 if open_mid == mid else 1, Vector4(8, 6, 8, 7)))
	var v = VBoxContainer.new(); _ign(v); v.add_theme_constant_override("separation", 3); pc.add_child(v)
	var h = HBoxContainer.new(); _ign(h); h.add_theme_constant_override("separation", 8); v.add_child(h)
	var ic = _icon(mid, 44); h.add_child(ic)
	var col = VBoxContainer.new(); _ign(col); col.size_flags_horizontal = Control.SIZE_EXPAND_FILL; col.add_theme_constant_override("separation", 1); h.add_child(col)
	var nr = HBoxContainer.new(); _ign(nr); nr.add_theme_constant_override("separation", 5); col.add_child(nr)
	var nl = _lbl(M.name(mid), 18, INK if ok else DIMC, 900); nl.clip_text = true; nl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	nl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; nr.add_child(nl)
	if is_new(mid): nr.add_child(_tag(S("cp_new", "新！", "新！"), Color("#d8452e")))
	if is_gear(mid):
		var slk = str(M.D().GEAR[mid].get("slot", "")); var sl = SLOT_N.get(slk, ["", ""])
		var sln = S("slot_" + slk, T(sl), T(sl)) if slk != "" else ""
		nr.add_child(_tag(S("gear", "紙紮裝備", "紙紮裝備") + ("·" + sln if sln != "" else ""), Color("#3f6fa8")))
	if is_item(mid): nr.add_child(_tag(S("battle_item", "戰鬥道具", "戰鬥道具"), Color("#7a4ab0")))
	var info = _lbl(S("cp_amt", "庫存 %s　｜　每件 %s 冥幣", "庫存 %s　｜　每件 %s 冥幣") % [qty(M.amt(mid)), qty(M.price(mid))], 14, DIMC, 700)
	col.add_child(info)
	var arr = _lbl("－" if open_mid == mid else "＋", 20, RED, 900); arr.size_flags_vertical = Control.SIZE_SHRINK_CENTER; h.add_child(arr)
	if not ok:
		ic.modulate = Color(0.55, 0.55, 0.55, 0.85)
		v.add_child(_wl(S("cp_locked", "未解鎖：%s", "未解鎖：%s") % st.why, 14, LOCKC, 900))
	v.add_child(_wl(S("cp_where", "邊度做：%s", "在哪做：%s") % _where(mid), 14, INK if ok else DIMC))
	# 用乜做
	var ins = {}
	for mk in makers(mid):
		ins = mk_in(mk)
		if not ins.is_empty(): break
	if ins.is_empty():
		v.add_child(_wl(S("cp_raw", "用乜做：原料，靠採集", "用什麼做：原料，靠採集"), 14, DIMC))
	else:
		var fl = HFlowContainer.new(); _ign(fl); fl.add_theme_constant_override("h_separation", 8); fl.add_theme_constant_override("v_separation", 2); v.add_child(fl)
		fl.add_child(_lbl(S("cp_need", "用乜做：", "用什麼做："), 14, DIMC, 700))
		for m in ins:
			var chip = HBoxContainer.new(); _ign(chip); chip.add_theme_constant_override("separation", 2); fl.add_child(chip)
			chip.add_child(_icon(str(m), 24))
			chip.add_child(_lbl("%s×%s" % [M.name(str(m)), qty(J.num(ins[m]))], 14, INK, 900))
	var un = _uses_names(mid)
	v.add_child(_wl(S("cp_uses", "用嚟做：%s", "用來做：%s") % "、".join(un) if un.size() else S("cp_uses0", "用嚟做：冇上層要佢，直接賣俾鬼", "用來做：沒有上層需要，直接賣給鬼"), 14, INK if ok else DIMC))
	if is_gear(mid):
		var gd = M.D().GEAR[mid]
		v.add_child(_wl(S("cp_gear", "裝備：攻 +%s　防 +%s　血 +%s", "裝備：攻 +%s　防 +%s　血 +%s") % [qty(J.num(gd.get("atk", 0))), qty(J.num(gd.get("def", 0))), qty(J.num(gd.get("hp", 0)))] + "（%s）" % S("gear_tip", "買咗嘅鬼會留低做義勇軍，幫手守村", "買了的鬼會留下當義勇軍，幫忙守村"), 14, Color("#2f5a8c"), 900))
	if is_item(mid):
		v.add_child(_wl(S("cp_item", "戰鬥道具：%s", "戰鬥道具：%s") % T(M.D().BATTLE_ITEMS[mid].get("desc", "")), 14, Color("#5e3a90"), 900))
	_hits.append([pc, func(): toggle(mid)])
	if open_mid == mid: v.add_child(_chain_view(mid))
	return pc

# ---------------- 上下游鏈 ----------------
func _chain_view(mid: String) -> Control:
	var pc = PanelContainer.new(); _ign(pc); pc.name = "Chain"
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color(0.25, 0.17, 0.12, 0.1), 6, Color(LINE, 0.8), 1, Vector4(6, 5, 6, 6)))
	var v = VBoxContainer.new(); _ign(v); v.add_theme_constant_override("separation", 2); pc.add_child(v)
	var hd = _lbl(S("cp_down", "▼ 由乜做成（追落去原料）", "▼ 由什麼做成（追到原料）"), 15, RED, 900); hd.name = "HDown"; v.add_child(hd)
	var cnt = [0]
	var before = v.get_child_count()
	_tree_down(v, mid, 1, {mid: true}, cnt)
	if v.get_child_count() == before: v.add_child(_wl(S("cp_down0", "佢自己就係原料", "它本身就是原料"), 14, DIMC))
	var hu = _lbl(S("cp_up", "▲ 做得成乜（追上去最高層）", "▲ 可以做成什麼（追到最高層）"), 15, GREEN, 900); hu.name = "HUp"; v.add_child(hu)
	before = v.get_child_count()
	_tree_up(v, mid, 1, {mid: true}, [0])
	if v.get_child_count() == before: v.add_child(_wl(S("cp_up0", "已經係最高層，直接賣俾鬼", "已經是最高層，直接賣給鬼"), 14, DIMC))
	return pc

func _node(v: VBoxContainer, mid: String, depth: int, txt: String, extra: String) -> void:
	var h = HBoxContainer.new(); _ign(h); h.add_theme_constant_override("separation", 4); h.name = "N_" + mid
	var sp = Control.new(); _ign(sp); sp.custom_minimum_size = Vector2(14.0 * (depth - 1), 0); h.add_child(sp)
	h.add_child(_lbl("└", 15, DIMC, 700))
	var ok = unlocked(mid)
	var ic = _icon(mid, 26); h.add_child(ic)
	if not ok: ic.modulate = Color(0.55, 0.55, 0.55, 0.85)
	var l = _lbl(txt, 15, INK if ok else DIMC, 900); h.add_child(l)
	var el = _lbl(extra + ("" if ok else S("cp_n_lock", "（未解鎖）", "（未解鎖）")), 14, DIMC if ok else LOCKC, 700)
	el.size_flags_horizontal = Control.SIZE_EXPAND_FILL; el.clip_text = true; el.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; h.add_child(el)
	v.add_child(h)
	_hits.append([h, func(): jump(mid)])

func _tree_down(v: VBoxContainer, mid: String, depth: int, seen: Dictionary, cnt: Array) -> void:
	if depth > MAX_DEPTH: return
	var ms = makers(mid); var mk = null
	for m in ms:
		if not mk_in(m).is_empty() and (mk == null or mk_state(m).ok): mk = m
		if mk != null and mk_state(mk).ok: break
	if mk == null: return
	var ins = mk_in(mk)
	for m in ins:
		if cnt[0] >= MAX_NODES: return
		var ms2 = str(m); cnt[0] += 1
		var extra = ""
		if makers(ms2).size() and mk_in(makers(ms2)[0]).is_empty() and makers(ms2)[0].k == "gather": extra = S("cp_n_gather", "　採集：%s", "　採集：%s") % mk_name(makers(ms2)[0])
		else:
			var pm = _prim(ms2)
			if pm != null: extra = "　" + mk_name(pm)
		_node(v, ms2, depth, "%s ×%s" % [M.name(ms2), qty(J.num(ins[m]))], extra)
		if not seen.has(ms2):
			var s2 = seen.duplicate(); s2[ms2] = true
			_tree_down(v, ms2, depth + 1, s2, cnt)

func _prim(mid: String):
	var best = null
	for m in makers(mid):
		if best == null or (mk_state(m).ok and not mk_state(best).ok): best = m
	return best

func _tree_up(v: VBoxContainer, mid: String, depth: int, seen: Dictionary, cnt: Array) -> void:
	if depth > MAX_DEPTH: return
	var done = {}
	for u in users(mid):
		for m in mk_outs(u):
			if m == "" or done.has(m) or seen.has(m): continue
			if cnt[0] >= MAX_NODES: return
			done[m] = true; cnt[0] += 1
			var need = J.num(mk_in(u).get(mid, 0))
			_node(v, m, depth, M.name(m), S("cp_n_use", "　%s（用 %s 件）", "　%s（用 %s 件）") % [mk_name(u), qty(need)])
			var s2 = seen.duplicate(); s2[m] = true
			_tree_up(v, m, depth + 1, s2, cnt)

# ---------------- 動作 ----------------
func toggle(mid: String) -> void:
	open_mid = "" if open_mid == mid else mid
	var keep = scroll
	_fill(); scroll = keep; _snd("click")
	if open_mid != "": _reveal(mid, false)

func jump(mid: String) -> void:   # 鏈入面撳一樣 → 跳去佢嗰層展開
	if not M.has_def(mid): return
	tier = clampi(M.tier(mid), 1, 5); _viewed[tier] = true
	open_mid = mid; scroll = 0.0; vel = 0.0
	_refresh_tabs(); _fill(); _snd("click")
	_reveal(mid, true)

func _reveal(mid: String, top: bool) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if not is_instance_valid(self) or not rows.has(mid) or not is_instance_valid(rows[mid]): return
	var r: Control = rows[mid]; var vh = view.size.y
	if top: scroll = r.position.y - 4.0
	elif r.position.y + r.size.y > scroll + vh: scroll = minf(r.position.y - 4.0, r.position.y + r.size.y - vh + 4.0)
	elif r.position.y < scroll: scroll = r.position.y - 4.0
	_clamp_scroll()

func max_scroll() -> float: return maxf(0.0, list.size.y - view.size.y) if list != null and view != null else 0.0
func _clamp_scroll() -> void: scroll = clampf(scroll, 0.0, max_scroll())

func close() -> void:
	if mode != "panel": return
	for t in _viewed: mark_seen(int(t))
	_hide_host_btns(false)
	if owner_btn != null and is_instance_valid(owner_btn): owner_btn.panel = null; owner_btn._new_t = 0.0
	if scene != null and scene.has_method("_save"): scene._save()
	_snd("click")
	queue_free()

func _view_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton:
		if ev.button_index == MOUSE_BUTTON_WHEEL_UP and ev.pressed: scroll -= 70.0; _clamp_scroll(); return
		if ev.button_index == MOUSE_BUTTON_WHEEL_DOWN and ev.pressed: scroll += 70.0; _clamp_scroll(); return
		if ev.button_index != MOUSE_BUTTON_LEFT: return
		if ev.pressed:
			_press = {"y": ev.position.y, "s": scroll, "moved": false, "ly": ev.position.y, "lt": _t}; vel = 0.0
		elif _press != null:
			if not _press.moved: tap_at(ev.position)
			_press = null
	elif ev is InputEventMouseMotion and _press != null:
		var dy = ev.position.y - _press.y
		if not _press.moved and absf(dy) > 9.0: _press.moved = true
		if _press.moved:
			scroll = _press.s - dy
			var dtm = maxf(0.001, _t - _press.lt)
			vel = lerpf(vel, -(ev.position.y - _press.ly) / dtm, 0.5)
			_press.ly = ev.position.y; _press.lt = _t
			scroll = clampf(scroll, -40.0, max_scroll() + 40.0)

func tap_at(p: Vector2) -> bool:   # p：view 本地座標
	var gp = view.get_global_transform() * p
	for i in range(_hits.size() - 1, -1, -1):
		var c: Control = _hits[i][0]
		if not is_instance_valid(c) or not c.is_visible_in_tree(): continue
		var lp = c.get_global_transform().affine_inverse() * gp
		if Rect2(Vector2.ZERO, c.size).has_point(lp):
			_hits[i][1].call(); return true
	return false

func _draw_bar() -> void:
	var ms = max_scroll()
	if ms <= 0.0: return
	var vh = view.size.y; var bh = maxf(30.0, vh * vh / list.size.y)
	var y = (vh - bh) * clampf(scroll / ms, 0, 1)
	view.draw_rect(Rect2(view.size.x - 5.0, y, 4.0, bh), Color(0.36, 0.25, 0.16, 0.5))

func _process(dt: float) -> void:
	_t += dt
	_new_t -= dt
	if _new_t <= 0.0:
		_new_t = 0.5
		var nn = has_new()
		if nn != _new_cache: _new_cache = nn; queue_redraw()
	if mode == "btn": _place_btn(); return
	var g = _geom(); position = g.position; size = g.size
	if list == null: return
	list.size = Vector2(_list_w(), 0)
	if _press == null or not _press.moved:
		if absf(vel) > 2.0: scroll += vel * dt; vel *= pow(0.05, dt)
		else: vel = 0.0
		var ms = max_scroll()
		if scroll < 0.0 or scroll > ms: scroll = lerpf(scroll, clampf(scroll, 0.0, ms), minf(1.0, dt * 12.0)); vel = 0.0
	list.position = Vector2(0, -round(scroll))
	view.queue_redraw()

func _snd(n: String) -> void:
	var s = get_node_or_null("/root/Snd") if is_inside_tree() else null
	if s != null: s.play(n)
