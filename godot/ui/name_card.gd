# 頭七回魂夜開場：手機「重新開機」→ 設定名字 → 選擇個人頭像（＝揀性別）
# 原生 UI；冇 class_name（熱更新規矩：唔可以加新 class_name），用 load("res://ui/name_card.gd") 叫
# 寫入：S.hero = {"name","full","en","sex","set":true}，同步 S.ghosts 入面 id=="afu" 嗰隻嘅 name
# 開場列表：data/story_v2.json 嘅 "opening"（女主有 "opening_f" 就用佢，冇就同男主一樣）
extends Control

const DEF_M := {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m"}
const DEF_F := {"name": "阿慧", "full": "陳嘉慧", "en": "", "sex": "f"}
# 名字會被塞入對白（ApaKhabar 對白用「時間|內容」、富文本用 [ ]），呢啲字元唔准入
const BAD := ["|", "[", "]", "{", "}", "<", ">", "\\", "\n", "\r", "\t"]
const OPEN_DEF := ["prologue_chat", "op_wake", "op_guard", "op_desk", "op_home", "op_dinner", "op_photo", "op_door", "prologue_road", "prologue_sys"]
const SCREEN := Color("#07080c")
const GLOW := Color("#9fe8d8")
const TXT := Color("#eef2f0")
const SUB := Color("#9aa6a8")

static var _v2 = null

# ---------------- 共用（main.gd、native/phone.gd 都用） ----------------
static func _story_v2() -> Dictionary:
	if _v2 == null:
		_v2 = {}
		var f = FileAccess.open("res://data/story_v2.json", FileAccess.READ)
		if f:
			var o = JSON.parse_string(f.get_as_text())
			if o is Dictionary: _v2 = o
	return _v2

static func hero_of(S) -> Dictionary:
	if S is Dictionary and S.get("hero") is Dictionary: return S.hero
	return {}

static func hero_set(S) -> bool: return bool(hero_of(S).get("set", false))

# 開場要播嘅劇情（次序）
static func opening(S = null) -> Array:
	var v2 = _story_v2()
	var key = "opening_f" if str(hero_of(S).get("sex", "m")) == "f" and v2.has("opening_f") else "opening"
	var a = v2.get(key, OPEN_DEF)
	return (a as Array).duplicate() if a is Array and not a.is_empty() else OPEN_DEF.duplicate()

# 開場中途斷咗：由最後一場睇過（即係播到一半）嗰場重新接；乜都未睇 → 0
static func resume_index(S) -> int:
	var seen = S.get("seen", {}) if S is Dictionary else {}
	if not (seen is Dictionary): return 0
	var ids = opening(S); var at = 0
	for i in ids.size():
		if seen.has(ids[i]): at = i
	return at

# 新開場未完：1 級、乜資源都冇、未睇 prologue_sys（舊存檔睇過 prologue_road 都當完咗，保持舊行為）
static func opening_unfinished(S) -> bool:
	if not (S is Dictionary) or int(J.num(S.get("lv", 1))) > 1: return false
	var tot = 0.0
	var res = S.get("res", {})
	if res is Dictionary:
		for v in res.values(): tot += J.num(v)
	if tot > 0: return false
	var seen = S.get("seen", {})
	if not (seen is Dictionary): seen = {}
	if seen.has("prologue_sys"): return false
	# 舊流程（冇新開場）播到黑白無常就當完：只限未改過名、又未睇過新開場任何一場
	var any_op = false
	for id in opening(S): if str(id).begins_with("op_") and seen.has(id): any_op = true
	if seen.has("prologue_road") and not hero_set(S) and not any_op: return false
	return true

static func female_ready() -> bool:
	return Spr.has_method("ok") and Spr.ok("afuf")

static func clean(s: String, maxlen: int) -> String:
	var t = s
	for b in BAD: t = t.replace(b, "")
	t = t.strip_edges()
	while t.contains("  "): t = t.replace("  ", " ")
	return t.substr(0, maxlen)

static func apply_hero(S: Dictionary, h: Dictionary) -> void:
	var d = DEF_F if str(h.get("sex", "m")) == "f" else DEF_M
	var o = {"name": clean(str(h.get("name", "")), 6), "full": clean(str(h.get("full", "")), 8), "en": clean(str(h.get("en", "")), 12), "sex": d.sex, "set": true}
	if o.name == "": o.name = d.name
	if o.full == "": o.full = d.full
	if o.en == "" and not h.has("en"): o.en = d.en
	S["hero"] = o
	var gs = S.get("ghosts", [])
	if gs is Array:
		for g in gs:
			if g is Dictionary and str(g.get("id", "")) == "afu": g["name"] = o.name

# ---------------- 介面 ----------------
var on_done: Callable = Callable()
var sex := "m"
var page: VBoxContainer
var ed := {}            # name/full/en → LineEdit
var touched := {}       # 玩家改過嘅欄（揀女主時唔覆蓋）
var tiles := {}
var ok_btn: Button

func _ready() -> void:
	name = "NameCard"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg = ColorRect.new(); bg.color = SCREEN; bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	var h = hero_of(G.S)
	if str(h.get("sex", "m")) == "f" and female_ready(): sex = "f"
	_page_boot()

func _clear_page() -> void:
	if page: page.queue_free()
	page = VBoxContainer.new(); page.add_theme_constant_override("separation", 14)
	page.anchor_left = 0; page.anchor_right = 1; page.anchor_top = 0; page.anchor_bottom = 1
	page.offset_left = 26; page.offset_right = -26; page.offset_top = 70; page.offset_bottom = -30
	add_child(page)
	tiles = {}; ok_btn = null

func _lbl(t: String, sz: int, col := TXT, kind := "sans", w := 400) -> Label:
	var l = UIKit.label(t, sz, col, kind, w); l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l

func _big_btn(t: String, gold := true) -> Button:
	var b = UIKit.btn(t, "gold" if gold else "")
	b.add_theme_font_size_override("font_size", 20); b.custom_minimum_size = Vector2(0, 54); b.focus_mode = Control.FOCUS_NONE
	return b

# 第一頁：重新開機＋名字
func _page_boot() -> void:
	_clear_page()
	var t = _lbl("系統已重新開機", 26, GLOW, "serif", 900); page.add_child(t)
	page.add_child(_lbl("歡迎！請設定你的名字。", 19, TXT))
	var sp = Control.new(); sp.custom_minimum_size = Vector2(0, 6); page.add_child(sp)
	var h = hero_of(G.S); var d = DEF_F if sex == "f" else DEF_M
	_field("name", "名字（大家這樣叫你）", str(h.get("name", d.name)) if h.has("name") else d.name, 6)
	_field("full", "全名", str(h.get("full", d.full)) if h.has("full") else d.full, 8)
	_field("en", "英文名（可以留空）", str(h.get("en", d.en)) if h.has("en") else d.en, 12)
	var sp2 = Control.new(); sp2.custom_minimum_size = Vector2(0, 8); page.add_child(sp2)
	var nb = _big_btn("下一步"); nb.pressed.connect(_page_avatar); page.add_child(nb)
	_fade_in(page)

func _field(key: String, cap: String, val: String, maxlen: int) -> void:
	var c = UIKit.label(cap, 17, SUB, "sans", 700); page.add_child(c)
	var e = LineEdit.new(); e.text = val; e.max_length = maxlen; e.placeholder_text = val
	e.custom_minimum_size = Vector2(0, 54); e.alignment = HORIZONTAL_ALIGNMENT_CENTER
	e.add_theme_font_override("font", UIKit.font("sans", 700)); e.add_theme_font_size_override("font_size", 24)
	e.add_theme_color_override("font_color", TXT); e.add_theme_color_override("font_placeholder_color", Color(TXT, 0.35))
	e.add_theme_color_override("caret_color", GLOW)
	var n = UIKit.sb(Color("#141a1f"), 8, Color(GLOW, 0.45), 2, Vector4(12, 6, 12, 6))
	var f = UIKit.sb(Color("#18222a"), 8, GLOW, 2, Vector4(12, 6, 12, 6))
	e.add_theme_stylebox_override("normal", n); e.add_theme_stylebox_override("focus", f)
	e.text_changed.connect(func(_t): touched[key] = true)
	page.add_child(e); ed[key] = e

func _read_fields() -> Dictionary:
	var o = {}
	for k in ["name", "full", "en"]:
		if ed.has(k) and is_instance_valid(ed[k]): o[k] = ed[k].text
	return o

var _vals := {}

# 第二頁：選擇個人頭像（黑色螢幕倒影）
func _page_avatar() -> void:
	_vals = _read_fields()
	# 手機中文輸入法未必觸發 text_changed：凡係同預設唔同嘅欄都當玩家改過（揀女主時唔可以覆蓋玩家打嘅名）
	var d0 = DEF_F if sex == "f" else DEF_M
	for k in _vals: if clean(str(_vals[k]), 12) != str(d0[k]) and clean(str(_vals[k]), 12) != "": touched[k] = true
	_clear_page()
	page.add_child(_lbl("選擇個人頭像", 26, GLOW, "serif", 900))
	page.add_child(_lbl("黑色的螢幕上，倒映出一個人影。", 18, SUB))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 14); hb.alignment = BoxContainer.ALIGNMENT_CENTER
	page.add_child(hb)
	hb.add_child(_tile("m", "打工仔", true))
	hb.add_child(_tile("f", "四眼妹", female_ready()))
	var who = _lbl("", 19, TXT); who.name = "Who"; page.add_child(who)
	var sp = Control.new(); sp.size_flags_vertical = Control.SIZE_EXPAND_FILL; page.add_child(sp)
	ok_btn = _big_btn("確定"); ok_btn.pressed.connect(_confirm); page.add_child(ok_btn)
	var bk = _big_btn("返回改名字", false); bk.pressed.connect(func(): _page_boot_keep()); page.add_child(bk)
	_pick(sex)
	_fade_in(page)

func _page_boot_keep() -> void:
	var keep = _vals.duplicate()
	_page_boot()
	for k in keep: if ed.has(k): ed[k].text = keep[k]

class Sil extends Control:
	# 未有美術嘅女主：倒影剪影（短髮、眼鏡）
	func _draw() -> void:
		var w = size.x; var h = size.y; var c = Color(0.62, 0.7, 0.78, 0.55); var cx = w / 2
		var head = Vector2(cx, h * 0.36); var r = w * 0.2
		draw_colored_polygon(PackedVector2Array([Vector2(cx - w * 0.36, h * 0.98), Vector2(cx - w * 0.3, h * 0.66), Vector2(cx - w * 0.1, h * 0.58), Vector2(cx + w * 0.1, h * 0.58), Vector2(cx + w * 0.3, h * 0.66), Vector2(cx + w * 0.36, h * 0.98)]), c)
		draw_circle(head, r, c)
		draw_colored_polygon(PackedVector2Array([head + Vector2(-r * 1.15, r * 0.9), head + Vector2(-r * 1.2, -r * 0.2), head + Vector2(-r * 0.6, -r * 1.15), head + Vector2(r * 0.6, -r * 1.15), head + Vector2(r * 1.2, -r * 0.2), head + Vector2(r * 1.15, r * 0.9), head + Vector2(r * 0.8, r * 0.2), head + Vector2(-r * 0.8, r * 0.2)]), c.darkened(0.25))
		var gl = Color(0.9, 0.97, 1.0, 0.85)
		draw_arc(head + Vector2(-r * 0.42, r * 0.08), r * 0.3, 0, TAU, 24, gl, 2.5, true)
		draw_arc(head + Vector2(r * 0.42, r * 0.08), r * 0.3, 0, TAU, 24, gl, 2.5, true)
		draw_line(head + Vector2(-r * 0.12, r * 0.08), head + Vector2(r * 0.12, r * 0.08), gl, 2.0, true)

func _tile(sx: String, cap: String, open: bool) -> Control:
	var b = Button.new(); b.custom_minimum_size = Vector2(158, 250); b.focus_mode = Control.FOCUS_NONE; b.toggle_mode = true
	b.add_theme_stylebox_override("normal", UIKit.sb(Color("#0e1216"), 10, Color(GLOW, 0.25), 2))
	b.add_theme_stylebox_override("hover", UIKit.sb(Color("#121820"), 10, Color(GLOW, 0.4), 2))
	b.add_theme_stylebox_override("pressed", UIKit.sb(Color("#16222a"), 10, GLOW, 3))
	b.add_theme_stylebox_override("disabled", UIKit.sb(Color("#0b0d10"), 10, Color(1, 1, 1, 0.12), 2))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var art: Control
	var key = "afu" if sx == "m" else "afuf"
	if Spr.ok(key) and (sx == "m" or open):
		var tr = TextureRect.new(); tr.texture = Spr.get_tex(key); tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.modulate = Color(0.62, 0.7, 0.8, 0.82)   # 黑色螢幕上嘅倒影：暗、偏冷
		art = tr
	else:
		art = Sil.new()
	art.anchor_right = 1; art.anchor_bottom = 1; art.offset_left = 12; art.offset_right = -12; art.offset_top = 12; art.offset_bottom = -56
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(art)
	var l = UIKit.label(cap, 20, TXT, "serif", 900); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.anchor_top = 1; l.anchor_bottom = 1; l.anchor_right = 1; l.offset_top = -50; l.offset_bottom = -14; l.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(l)
	if not open:
		b.disabled = true
		art.modulate = Color(1, 1, 1, 0.45)
		var lk = PanelContainer.new(); lk.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.78), 6, Color("#f3d68a"), 1, Vector4(10, 6, 10, 6)))
		lk.anchor_left = 0.5; lk.anchor_right = 0.5; lk.anchor_top = 0.42; lk.anchor_bottom = 0.42; lk.grow_horizontal = Control.GROW_DIRECTION_BOTH; lk.grow_vertical = Control.GROW_DIRECTION_BOTH
		lk.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ll = UIKit.label("美術製作中", 17, Color("#f3d68a"), "sans", 900); ll.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; lk.add_child(ll)
		b.add_child(lk)
	else:
		b.pressed.connect(func(): _pick(sx))
	tiles[sx] = b
	return b

func _pick(sx: String) -> void:
	if sx == "f" and not female_ready(): sx = "m"
	if sx != sex:
		# 換性別：玩家冇改過嘅欄換成嗰邊嘅預設
		var d = DEF_F if sx == "f" else DEF_M
		for k in ["name", "full", "en"]:
			if not touched.get(k, false): _vals[k] = d[k]
	sex = sx
	for k in tiles: tiles[k].button_pressed = k == sex
	var who = page.get_node_or_null("Who")
	if who: who.text = "%s（%s）" % [clean(str(_vals.get("name", "")), 6) if clean(str(_vals.get("name", "")), 6) != "" else (DEF_F if sex == "f" else DEF_M).name, "女" if sex == "f" else "男"]

func _confirm() -> void:
	var h = _vals.duplicate(); h["sex"] = sex
	apply_hero(G.S, h)
	G.crumb("ng:hero_" + str(G.S.hero.sex))
	G.save(); JSRun.flush_ls()   # 即刻落地：改完名就閃退都唔使再改
	var f = on_done; on_done = Callable()
	queue_free()
	if f.is_valid(): f.call()

func _fade_in(n: Control) -> void:
	n.modulate.a = 0.0
	var tw = n.create_tween(); tw.tween_property(n, "modulate:a", 1.0, 0.45)

# ---------------- 測試用（tools：GB_TEST 腳本 ["call","/root/Main/NameCard","t_fill",...]） ----------------
func t_fill(nm: String, full := "", en := "") -> void:
	if ed.has("name") and is_instance_valid(ed.name): ed.name.text = nm; touched["name"] = true
	if full != "" and ed.has("full") and is_instance_valid(ed.full): ed.full.text = full; touched["full"] = true
	if en != "" and ed.has("en") and is_instance_valid(ed.en): ed.en.text = en; touched["en"] = true
func t_next() -> void: _page_avatar()
func t_pick(sx: String) -> void: _pick(sx)
func t_ok() -> void: _confirm()
