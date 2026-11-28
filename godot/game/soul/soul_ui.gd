# [soul] 祭壇（招魂台升級）四頁：招降／升職／散魂／招雜鬼；出擊小卡嘅駐守鬼、魂魄、怨氣行（全部 static；冇 class_name）
#   入口：ui/menus/menus.gd _draw_bld("altar") 掛鈎 → altar(body, refresh)；招雜鬼頁＝舊介面原封不動（回 false 由 menus 照畫）
#   出擊小卡：game/sortie/so_view.gd → card_info(e)／card_rows(vb, info)
#   暫代圖：頭像全部用老闆原圖（UIKit.portrait）；未遇見＝原圖黑色剪影，未招降＝灰色。冇新畫圖。
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")

static var tab := "summon"     # summon／promote／san／fodder
const TABS := [["summon", ["招降", "招降"]], ["promote", ["升職", "升職"]], ["fuse", ["融合", "融合"]], ["star", ["突破", "突破"]], ["san", ["散魂", "散魂"]], ["fodder", ["招雜鬼", "招雜鬼"]]]
const INK := Color("#2b1d12")
const DIM := Color("#6e5838")
const RED := Color("#b0281c")
const GOOD := Color("#2e6b3a")
const PINC := {"凡": "#8f8a7e", "靈": "#3f88c8", "煞": "#9a4ad0", "王": "#e0a020"}   # 同 soul_up.PJ_COL

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)
static func _main(): return Engine.get_main_loop().root.get_node_or_null("Main")

# ======================= 共用小部件 =======================
static func _rich(t: String, px := 16, col := INK) -> RichTextLabel:
	var r = UIKit.rich(t, px, col); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return r
static func _btn(t: String, kind: String, on: bool, f: Callable) -> Button:
	var b = UIKit.btn(t, kind); b.disabled = not on; b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size", 16); b.custom_minimum_size = Vector2(0, 44)
	b.pressed.connect(func(): Snd.play("click"); f.call())
	return b
static func _confirm(t: String, msg: String, f: Callable) -> Button:
	var b = UIKit.btn(t, ""); b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size", 15); b.custom_minimum_size = Vector2(0, 42)
	var armed = [0]
	b.pressed.connect(func():
		var now = Time.get_ticks_msec()
		if now - armed[0] < 2500: f.call(); return
		armed[0] = now; b.text = msg
		b.get_tree().create_timer(2.5).timeout.connect(func(): if is_instance_valid(b): b.text = t))
	return b
static func _por(k: String, size: int, mode: String) -> Control:   # mode: own／gray／shadow
	if mode == "own" and load("res://game/soul/ace_frame.gd").lvl(k) > 0: return load("res://game/soul/ace_frame.gd").por(k, size)   # [p44] 最高階撐爆畫框（升職／突破／入職信）
	var t = UIKit.portrait(k, size)
	if mode == "gray": t.modulate = Color(0.42, 0.42, 0.45)
	elif mode == "shadow": t.modulate = Color(0.05, 0.04, 0.06)
	var w = PanelContainer.new(); w.add_theme_stylebox_override("panel", UIKit.sb(Color(0.17, 0.12, 0.1, 0.9), 6, Color("#6a5040"), 1))
	w.custom_minimum_size = Vector2(size + 4, size + 4); w.add_child(t)
	w.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	return w
static func _bar(v: float, mx: float, col: Color) -> ProgressBar:
	var b = ProgressBar.new(); b.max_value = maxf(1.0, mx); b.value = clampf(v, 0.0, mx); b.show_percentage = false
	b.custom_minimum_size = Vector2(0, 12); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_stylebox_override("background", UIKit.sb(Color(0, 0, 0, 0.18), 5)); b.add_theme_stylebox_override("fill", UIKit.sb(col, 5))
	return b
static func _pin_tag(k: String) -> String:
	var U = load("res://game/soul/soul_up.gd")
	return "[color=#%s][b]%s[/b][/color]" % [U.tag_col(k).darkened(0.15).to_html(false), U.tag_name(k)]
static func _card(parent: Control) -> VBoxContainer:
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55), 6, UIKit.PAPERLINE, 1, Vector4(10, 8, 10, 8)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 5); pc.add_child(vb); parent.add_child(pc)
	return vb
static func _h(parent: Control, t: String) -> void:
	parent.add_child(_rich("[b]%s[/b]" % t, 18, Color("#7a2416")))

# ======================= 祭壇 =======================
# 回 true＝已畫（menus 唔使畫舊招魂）；false＝招雜鬼頁（menus 照畫舊介面）
static func altar(body: VBoxContainer, refresh: Callable) -> bool:
	if SOUL.st() == null: return false
	SOUL.flush_toast()
	var top = GridContainer.new(); top.columns = 3; top.add_theme_constant_override("h_separation", 4); top.add_theme_constant_override("v_separation", 4)   # [soul_up] 六頁分兩行
	for t in TABS:
		var id = str(t[0])
		var n = 0
		if id == "summon": n = _ready_n(false)
		elif id == "promote": n = _ready_n(true)
		var b = UIKit.btn(SOUL.T(t[1]) + ("・%d" % n if n > 0 else ""), "gold" if tab == id else "")
		b.focus_mode = Control.FOCUS_NONE; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.add_theme_font_size_override("font_size", 16); b.custom_minimum_size = Vector2(0, 42)
		b.pressed.connect(func(): Snd.play("paper"); tab = id; refresh.call())
		top.add_child(b)
	body.add_child(top)
	body.add_child(_rich(L("祭壇 [b]Lv %d[/b]　散魂 [b]%d[/b]", "祭壇 [b]Lv %d[/b]　散魂 [b]%d[/b]") % [SOUL.altar_lv(), SOUL.san()] + "　[font_size=14][color=#6e5838]" + _altar_hint() + "[/color][/font_size]", 16))
	body.add_child(UIKit.hsep())
	match tab:
		"summon": _summon(body, refresh)
		"promote": _promote(body, refresh)
		"san": _san(body, refresh)
		"fuse": load("res://game/soul/soul_up_ui.gd").fuse_page(body, refresh)
		"star": load("res://game/soul/soul_up_ui.gd").star_page(body, refresh)
		_: return false
	return true
static func _altar_hint() -> String:
	var lv = SOUL.altar_lv()
	var ok = []
	var U = load("res://game/soul/soul_up.gd")
	for p in SOUL.PINS: if lv >= int(SOUL.ALTAR_PIN[p]): ok.append(U.pin_label(p))
	var t = L("招得：%s", "可招降：%s") % "・".join(ok)
	if lv < 4: t += L("（祭壇 Lv%d 開%s）", "（祭壇 Lv%d 開放%s）") % [lv + 1, U.pin_label(SOUL.PINS[lv])]
	return t
static func _ready_n(promote: bool) -> int:
	var o = SOUL.st(); var n = 0
	for k in o.sh:
		if J.num(o.sh[k]) <= 0: continue
		if promote and SOUL.owned(k) and SOUL.can_promote(k).ok: n += 1
		elif not promote and not SOUL.owned(k) and SOUL.can_summon(k).ok: n += 1
	return n

static func _why(w: String, c: Dictionary, k: String) -> String:
	match w:
		"souls": return L("魂魄未夠", "魂魄不夠")
		"altar": return L("要祭壇 Lv%d", "需要祭壇 Lv%d") % int(c.cost.altar if c.has("cost") and c.cost.has("altar") else c.get("altar", 0))
		"coins": return L("冥幣唔夠", "冥幣不夠")
		"wish": return L("%s唔夠", "%s不夠") % SOUL.res_name(str(c.cost.wish))
		"story": return L("劇情先加入", "劇情才加入")
		"max": return L("已經係合夥人", "已經是合夥人")
	return ""

# ---- 招降頁 ----
static func summon_list() -> Array:   # [{k, ready, have, need}]
	var o = SOUL.st(); var out = []
	var ks = {}
	for k in o.sh: ks[k] = true
	for k in o.seen: ks[k] = true
	for k in o.got: ks[k] = true
	for k in ks:
		var kk = str(k)
		if not SOUL.is_ghost(kk) or SOUL.owned(kk) or SOUL.unsummonable(kk): continue
		if SOUL.story(kk) and not J.t(o.got.get(kk)): continue
		var c = SOUL.can_summon(kk)
		out.append({"k": kk, "ready": c.ok, "have": c.have, "need": c.need, "c": c})
	out.sort_custom(func(a, b):
		if a.ready != b.ready: return a.ready
		var da = a.need - a.have; var db = b.need - b.have
		if da != db: return da < db
		return a.k < b.k)
	return out
static func _summon(body: VBoxContainer, refresh: Callable) -> void:
	var lst = summon_list()
	var rd = lst.filter(func(x): return x.ready)
	var ch = lst.filter(func(x): return not x.ready)
	if lst.is_empty():
		body.add_child(_rich(L("未有魂魄。去野外據點打駐守名鬼，打贏就會掉佢嘅魂魄；夠數就返嚟呢度招降。", "還沒有魂魄。到野外據點打駐守名鬼，打贏就會掉他的魂魄；夠數就回來這裡招降。"), 16, DIM))
	if rd.size():
		_h(body, L("● 夠數可以招降（%d）", "● 夠數可以招降（%d）") % rd.size())
		for x in rd: _summon_row(body, x, refresh)
	if ch.size():
		_h(body, L("● 追緊（按差幾多排）", "● 收集中（按差多少排）"))
		for x in ch.slice(0, 24): _summon_row(body, x, refresh)
	var unseen = 0
	for k in SOUL.D().PIN:
		if SOUL.is_ghost(str(k)) and not SOUL.seen(str(k)) and not SOUL.story(str(k)): unseen += 1
	if unseen > 0: body.add_child(_rich(L("仲有 %d 隻名鬼未遇見：去野外據點打，就會知道係邊個。", "還有 %d 隻名鬼未遇見：到野外據點打，就會知道是誰。") % unseen, 15, DIM))
static func _summon_row(body: VBoxContainer, x: Dictionary, refresh: Callable) -> void:
	var k = str(x.k); var c: Dictionary = x.c; var cs: Dictionary = c.cost
	var vb0 = _card(body)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); vb0.add_child(hb)
	hb.add_child(_por(k, 60, "gray"))
	var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 3); hb.add_child(vb)
	var miss = maxi(0, int(x.need) - int(x.have))
	vb.add_child(_rich("[b]%s[/b]　%s　[font_size=15]%s %d/%d%s[/font_size]" % [SOUL.gname(k), _pin_tag(k), L("魂魄", "魂魄"), int(x.have), int(x.need),
		("　[color=#2e6b3a]✓[/color]" if miss == 0 else "　[color=#b0281c]" + L("差 %d", "差 %d") % miss + "[/color]")], 17))
	vb.add_child(_bar(x.have, x.need, Color("#5aa070") if miss == 0 else Color("#c09040")))
	if cs.re: vb.add_child(_rich(L("重新招魂：只要一半魂魄，唔失憶，職級保留（%s）", "重新招魂：只要一半魂魄，不失憶，職級保留（%s）") % SOUL.rank_name(SOUL.rank(k)), 14, DIM))
	else:
		vb.add_child(_rich(L("心願：%s %d　「%s」", "心願：%s %d　「%s」") % [SOUL.res_name(str(cs.wish)), int(cs.wish_n), str(cs.say)], 14, Color("#5a3a20")))
		vb.add_child(_rich(L("費用：冥幣 %d（有 %d）　%s（有 %d）　祭壇 Lv%d", "費用：冥幣 %d（有 %d）　%s（有 %d）　祭壇 Lv%d") % [int(cs.coins), int(SOUL.have("coins")), SOUL.res_name(str(cs.wish)), int(SOUL.have(str(cs.wish))), int(cs.altar)], 14, DIM))
	var src = _where(k)
	if src != "": vb.add_child(_rich(L("邊度有：", "哪裡有：") + src, 14, DIM))
	var bb = HBoxContainer.new(); bb.add_theme_constant_override("separation", 8); bb.alignment = BoxContainer.ALIGNMENT_END; vb0.add_child(bb)
	var lab = L("招降", "招降")
	if c.ok and int(c.sub) > 0: lab = L("用散魂補 %d 隻（%d 散魂）→ 招降", "用散魂補 %d 隻（%d 散魂）→ 招降") % [int(c.sub), int(c.sub_cost)]
	elif not c.ok: lab = L("招降（%s）", "招降（%s）") % _why(str(c.why), c, k)
	bb.add_child(_btn(lab, "gold", c.ok, func():
		var r = SOUL.summon(k)
		var m = _main()
		if r == "ok" and k.begins_with("bm_"): Snd.play("boss_capture")   # [sfx43] 魔王收服
		if r == "ok" and m != null:
			if m.has_method("show_banner"): m.show_banner(L("【%s】簽咗入職合約！", "【%s】簽了入職合約！") % SOUL.gname(k))
			var bsc = load("res://game/newghost/ng_boss.gd").recruit_scene(k) if k.begins_with("bm_") else null   # [補丁43] 收服魔王劇情
			if k.begins_with("bm_"): load("res://game/fxkit/vfx_play.gd").burst("up_tame")   # [vfx 第四批] 魔王收服（大型 2 秒）
			if bsc != null and J.G.get("Story") != null: J.mc(J.G.get("Story"), "queue", [bsc, func(_a = null, _b = null): pass])
			_letter(k, false)
		refresh.call()))
	var e = _go_camp(k)
	if not e.is_empty(): bb.add_child(_btn(L("去出擊", "去出擊"), "", true, func(): go_camp(e)))
static func _where(k: String) -> String:
	var o = []
	for x in SOUL.sources(k):
		var e = x.e
		o.append(L("第%d章 Lv.%d %s（%s）", "第%d章 Lv.%d %s（%s）") % [int(e.c) + 1, int(e.lv), load("res://game/zone/zone_data.gd").T(load("res://game/sortie/so_data.gd").RING_NAME[SOUL.ri(e.ring)]), L("主", "主") if x.pri else L("副", "副")])
		if o.size() >= 3: break
	return "、".join(o)
static func _go_camp(k: String) -> Dictionary:
	var ZD = load("res://game/zone/zone_data.gd")
	if not ZD.on(): return {}
	var best = {}
	for x in SOUL.sources(k):
		if int(x.e.c) == ZD.ci() and (best.is_empty() or (x.pri and not best.pri)): best = x
	return best.e if not best.is_empty() else {}
static func go_camp(e: Dictionary) -> void:
	var m = _main()
	if m == null: return
	if m.has_method("close_sheet"): m.close_sheet()
	if m.has_method("_nav_on"): m._nav_on("village")
	var nv = m.get("village")
	if nv != null and nv.has_method("zone_cam"): nv.zone_cam().glide_to(e.pos)
	m.get_tree().create_timer(0.6).timeout.connect(func(): load("res://game/sortie/so_view.gd").open_card(e))

# 入職通知書／升職信（短卡，3 秒自動收；撳一下即收）
static func _letter(k: String, promote: bool) -> void:
	if load("res://game/soul/soul_fx.gd").letter(k, promote): return   # [soul2] 入職通知書／升職演出
	var m = _main()
	if m == null: return
	var host = m.get("sheet") if m.get("sheet") != null else m
	var pc = PanelContainer.new(); pc.name = "SoulLetter"
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color("#f6ead0"), 8, Color("#9c2219"), 3, Vector4(18, 14, 18, 14)))
	pc.anchor_left = 0.08; pc.anchor_right = 0.92; pc.anchor_top = 0.3; pc.anchor_bottom = 0.3; pc.grow_vertical = Control.GROW_DIRECTION_END
	pc.mouse_filter = Control.MOUSE_FILTER_STOP
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); pc.add_child(vb)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 12); vb.add_child(hb)
	hb.add_child(_por(k, 72, "own"))
	var r = SOUL.rank(k)
	var head = (L("升職信", "升職信") if promote else L("入職通知書", "入職通知書"))
	var body = L("%s：由即日起擔任【%s】。", "%s：即日起擔任【%s】。") % [SOUL.gname(k), SOUL.rank_name(r)]
	var tail = L("「做得幾好，繼續努力。」——阿福（好難得）", "「做得不錯，繼續努力。」——阿福（很難得）") if promote else L("試用期三個月，冇勞工假。——阿福", "試用期三個月，沒有勞工假。——阿福")
	hb.add_child(_rich("[b]%s[/b]\n%s" % [head, body], 18, INK))
	vb.add_child(_rich(tail, 15, Color("#7a2416")))
	host.add_child(pc)
	pc.gui_input.connect(func(ev): if ev is InputEventMouseButton and ev.pressed and is_instance_valid(pc): pc.queue_free())
	m.get_tree().create_timer(3.0).timeout.connect(func(): if is_instance_valid(pc): pc.queue_free())

# ---- 升職頁 ----
static func promote_list() -> Array:
	var s = SOUL.S(); var out = []
	for g in J.iter(s.get("ghosts")):
		var k = J.str(g.get("k"))
		if not SOUL.is_ghost(k) or J.str(g.get("q")) != "名": continue
		out.append({"k": k, "g": g, "c": SOUL.can_promote(k)})
	out.sort_custom(func(a, b):
		if a.c.ok != b.c.ok: return a.c.ok
		var ra = SOUL.rank(a.k); var rb = SOUL.rank(b.k)
		if ra != rb: return ra > rb
		return SOUL.souls(a.k) > SOUL.souls(b.k))
	return out
static func _promote(body: VBoxContainer, refresh: Callable) -> void:
	var lst = promote_list()
	if lst.is_empty(): body.add_child(_rich(L("未有名鬼。", "還沒有名鬼。"), 16, DIM)); return
	body.add_child(_rich(L("重複嘅魂魄用嚟升職：每升一級三圍上升、等級上限 +%d。散魂可以頂替魂魄（每隻 品值×2）。", "重複的魂魄用來升職：每升一級三圍上升、等級上限 +%d。散魂可以頂替魂魄（每隻 品值×2）。") % SOUL.CAP_PER_RANK, 14, DIM))
	for x in lst: _promote_row(body, x, refresh)
static func _promote_row(body: VBoxContainer, x: Dictionary, refresh: Callable) -> void:
	var k = str(x.k); var g = x.g; var c: Dictionary = x.c; var r = SOUL.rank(k)
	var vb0 = _card(body)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); vb0.add_child(hb)
	hb.add_child(_por(k, 56, "own"))
	var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 3); hb.add_child(vb)
	var stars = "★".repeat(r) + "☆".repeat(SOUL.RANK_MAX - r)
	vb.add_child(_rich("[b]%s[/b]　%s　[color=#b07a1f]%s[/color]　[font_size=15]%s　Lv%d[/font_size]" % [SOUL.gname(k), _pin_tag(k), stars, SOUL.rank_name(r), int(J.num(g.get("lv", 1)))], 17))
	if r >= SOUL.RANK_MAX:
		vb.add_child(_rich(L("已經係合夥人：之後嘅魂魄自動化成散魂。", "已經是合夥人：之後的魂魄自動化成散魂。"), 14, GOOD))
		return
	var to = r + 1
	vb.add_child(_bar(SOUL.souls(k), c.need, Color("#c09040")))
	var cap0 = SOUL.cap_of(g); var t0 = SOUL.stat_target(k, r); var t1 = SOUL.stat_target(k, to)
	vb.add_child(_rich(L("下一級【%s】：魂魄 %d/%d　冥幣 %d　祭壇 Lv%d", "下一級【%s】：魂魄 %d/%d　冥幣 %d　祭壇 Lv%d") % [SOUL.rank_name(to), SOUL.souls(k), int(c.need), int(c.coins), int(c.altar)], 15, INK))
	vb.add_child(_rich(L("效果：三圍 +%d%%（%d/%d/%d → %d/%d/%d）、等級上限 %d → %d", "效果：三圍 +%d%%（%d/%d/%d → %d/%d/%d）、等級上限 %d → %d") % [int(round(SOUL.STAT_PCT[SOUL.pin(k)] * 100)), t0[0], t0[1], t0[2], t1[0], t1[1], t1[2], int(cap0), int(cap0 + SOUL.CAP_PER_RANK)], 14, DIM))
	var bb = HBoxContainer.new(); bb.alignment = BoxContainer.ALIGNMENT_END; vb0.add_child(bb)
	var lab = L("升職", "升職")
	if c.ok and int(c.sub) > 0: lab = L("用散魂補 %d 隻（%d 散魂）→ 升職", "用散魂補 %d 隻（%d 散魂）→ 升職") % [int(c.sub), int(c.sub_cost)]
	elif not c.ok: lab = L("升職（%s）", "升職（%s）") % _why(str(c.why), c, k)
	bb.add_child(_btn(lab, "gold", c.ok, func():
		var pw0 = load("res://ui/juice.gd").pow_of_k(k)
		if SOUL.promote(k) == "ok":
			load("res://ui/juice.gd").power_show(k, SOUL.gname(k), pw0, load("res://ui/juice.gd").pow_of_k(k), true, L("升職做%s", "升職為%s") % SOUL.rank_name(SOUL.rank(k)))   # [juice] 全屏升職演出
			var m = _main()
			if m != null and m.has_method("show_banner"): m.show_banner(L("【%s】升職做%s！", "【%s】升職為%s！") % [SOUL.gname(k), SOUL.rank_name(SOUL.rank(k))])
			_letter(k, true)
		refresh.call()))

# ---- 散魂頁 ----
static func _san(body: VBoxContainer, refresh: Callable) -> void:
	body.add_child(_rich(L("散魂＝萬能魂：可以頂替招降（最多一半）同升職嘅魂魄，每隻要 品值×2 散魂。分解魂魄：每隻得 品值 ×（1＋2%×祭壇等級）散魂。合夥人之後，重複魂魄會自動化成散魂。", "散魂＝萬能魂：可以頂替招降（最多一半）與升職的魂魄，每隻要 品值×2 散魂。分解魂魄：每隻得 品值 ×（1＋2%×祭壇等級）散魂。合夥人之後，重複魂魄會自動化成散魂。"), 14, DIM))
	var o = SOUL.st(); var ks = []
	for k in o.sh: if J.num(o.sh[k]) > 0 and SOUL.is_ghost(str(k)): ks.append(str(k))
	ks.sort_custom(func(a, b): return SOUL.souls(a) > SOUL.souls(b))
	if ks.is_empty(): body.add_child(_rich(L("而家冇魂魄可以分解。", "現在沒有魂魄可以分解。"), 16, DIM)); return
	for k in ks:
		var vb0 = _card(body)
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); vb0.add_child(hb)
		hb.add_child(_por(k, 48, "own" if SOUL.owned(k) else "gray"))
		var n = SOUL.souls(k); var rate = SOUL.dismantle_rate(k)
		var st = L("已招降", "已招降") if SOUL.owned(k) else L("未招降：分咗就要重新打", "未招降：分解了就要重新打")
		hb.add_child(_rich("[b]%s[/b]　%s　%s %d\n[font_size=14][color=#6e5838]%s　每隻 → 散魂 %.2f[/color][/font_size]" % [SOUL.gname(k), _pin_tag(k), L("魂魄", "魂魄"), n, st, rate], 16))
		var bb = HBoxContainer.new(); bb.add_theme_constant_override("separation", 8); bb.alignment = BoxContainer.ALIGNMENT_END; vb0.add_child(bb)
		var kk = k
		bb.add_child(_confirm(L("分解 1 隻", "分解 1 隻"), L("再撳確認", "再按確認"), func(): SOUL.dismantle(kk, 1); refresh.call()))
		bb.add_child(_confirm(L("全部分解（%d）", "全部分解（%d）") % n, L("再撳確認", "再按確認"), func(): SOUL.dismantle(kk, SOUL.souls(kk)); refresh.call()))

# ======================= 出擊小卡 =======================
static func card_info(e: Dictionary) -> Dictionary:
	var o = {}
	if SOUL.st() == null: return o
	var k = SOUL.guard_of(e)
	var key = SOUL.ckey(e); var r = SOUL.ri(e.ring)
	var SO = load("res://game/sortie/so_data.gd")
	var first = not J.t(SO.cst(e).get("first"))
	o["k"] = k
	o["live"] = SOUL.guard_live(e)
	o["seen"] = k != "" and SOUL.seen(k)
	o["fresh"] = SOUL.fresh_text(key)
	o["mul"] = SOUL.fresh_mul(key)
	o["v2"] = load("res://game/post/po_data.gd").on_for(int(J.num(e.get("c", 0))))   # [post] 野外 v2：掉落行由 po_view.sortie_rows 出（首殺必掉＋四檔），冇每日打折
	o["san"] = SOUL.SAN[r]
	if k != "":
		o["name"] = SOUL.gname(k); o["pin"] = SOUL.pin(k)
		o["owned"] = SOUL.owned(k); o["rank"] = SOUL.rank(k)
		o["have"] = SOUL.souls(k)
		o["need"] = SOUL.rank_cost(k, SOUL.rank(k) + 1) if o.owned and o.rank < SOUL.RANK_MAX else SOUL.need_of(k)
		var lo = maxi(1, int(round(SOUL.PRI[r] * o.mul))); var hi = maxi(1, int(round((SOUL.PRI[r] + 1) * o.mul)))
		o["per"] = "+%d～%d" % [lo, hi] if hi > lo else "+%d" % lo
		o["first"] = SOUL.FIRST[r] if first else 0
		o["partner"] = SOUL.all_max(k)   # [post] 全部到頂先化散魂
	var g2 = SOUL.guard2_of(e)   # [roster2] 雙駐守（第二批新鬼）
	o["g2"] = g2
	if g2 != "":
		o["g2_name"] = SOUL.gname(g2) if SOUL.seen(g2) else "？？？"
		o["g2_have"] = SOUL.souls(g2)
		o["g2_need"] = SOUL.rank_cost(g2, SOUL.rank(g2) + 1) if SOUL.owned(g2) and SOUL.rank(g2) < SOUL.RANK_MAX else SOUL.need_of(g2)
	var k2 = SOUL.sec_of(e)
	o["k2"] = k2
	if k2 != "":
		o["name2"] = SOUL.gname(k2) if SOUL.seen(k2) else "？？？"
		o["pity2"] = maxi(1, SOUL.SEC_PITY - int(J.num(SOUL.st().sec.get(key, 0))))
	return o
static func card_rows(vb: VBoxContainer, d) -> void:
	if not (d is Dictionary) or d.is_empty() or str(d.get("k", "")) == "": return
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(0.25, 0.14, 0.3, 0.55), 8, Color("#a070c0"), 1, Vector4(8, 6, 8, 6)))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); pc.add_child(hb)
	var k = str(d.k)
	var mode = "own" if J.t(d.get("owned")) else ("gray" if J.t(d.get("seen")) else "shadow")
	hb.add_child(_por(k, 54, mode))
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 2); v.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(v)
	var lab = func(t: String, px: int, col: Color):
		var l = UIKit.label(t, px, col, "sans", 900); l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; v.add_child(l)
	if not J.t(d.get("live")):
		lab.call(L("駐守：%s（劇情未到，暫時由頭目代守）", "駐守：%s（劇情未到，暫由頭目代守）") % (str(d.name) if J.t(d.get("seen")) else "？？？"), 16, Color("#e8d0ff"))
	elif not J.t(d.get("seen")):
		lab.call(L("駐守：？？？（打贏就知道佢係邊個）", "駐守：？？？（打贏就知道他是誰）"), 16, Color("#e8d0ff"))
	else:
		var tail = ""
		if J.t(d.get("partner")): tail = L("　魂魄 → 散魂 ×%d", "　魂魄 → 散魂 ×%d") % int(SOUL.PV[str(d.pin)])
		elif J.t(d.get("owned")): tail = L("　升職魂魄 %d/%d", "　升職魂魄 %d/%d") % [int(d.have), int(d.need)]
		else: tail = L("　魂魄 %d/%d", "　魂魄 %d/%d") % [int(d.have), int(d.need)]
		lab.call(L("駐守：%s（%s）", "駐守：%s（%s）") % [str(d.name), str(d.pin)] + tail, 16, Color("#f4e2ff"))
	if J.t(d.get("live")) and not J.t(d.get("v2")):
		var l2 = L("每次 %s", "每次 %s") % str(d.get("per", ""))
		if int(d.get("first", 0)) > 0: l2 += L("　首勝 +%d", "　首勝 +%d") % int(d.first)
		lab.call(l2, 15, Color("#ffd27a"))
	if str(d.get("g2", "")) != "":   # [roster2] 雙駐守
		lab.call((L("雙駐守：%s　魂魄 %d/%d（各自抽）", "雙駐守：%s　魂魄 %d/%d（各自抽）") if J.t(d.get("v2")) else L("雙駐守：%s　魂魄 %d/%d（每次同樣掉）", "雙駐守：%s　魂魄 %d/%d（每次同樣掉）")) % [str(d.g2_name), int(d.g2_have), int(d.g2_need)], 15, Color("#f4e2ff"))
	if not J.t(d.get("v2")): lab.call(str(d.fresh), 15, Color("#a8f0a0") if float(d.mul) > 0.99 else Color("#ff9a7a"))
	var l3 = L("散魂 +%d", "散魂 +%d") % int(d.san)
	if str(d.get("k2", "")) != "": l3 = L("副魂 %s 25%%（保底：再 %d 次必得）　", "副魂 %s 25%%（保底：再 %d 次必得）　") % [str(d.name2), int(d.pity2)] + l3
	lab.call(l3, 14, Color("#d8c0f0"))
	vb.add_child(pc)
