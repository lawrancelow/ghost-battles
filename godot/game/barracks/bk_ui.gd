# [barracks] 介面：兵營面板（派遣三種、隊長）、名冊「分配」（名鬼一職）
#   兵營面板接喺 ui/menus/menus.gd 建築卡底（升級照用原本嗰套）；文字全部經 DB.N（女主名、稱號）
extends RefCounted

const BK = preload("res://game/barracks/bk_data.gd")

static func T(yue: String, zhs: String) -> String: return BK.T(yue, zhs)
static func _rich(bb: String, size := 14.0, col := UIKit.INKTXT) -> RichTextLabel:
	var r = UIKit.rich(str(DB.N(bb)), size, col); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; return r
static func _b(text: String, kind: String, enabled: bool, f: Callable) -> Button:
	var b = UIKit.btn(text, kind, true); b.disabled = not enabled; b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(46, 34)
	b.pressed.connect(func(): Snd.play("click"); f.call())
	return b
static func _box(parent: Control, title: String) -> VBoxContainer:
	var box = PanelContainer.new(); box.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.06), 6, Color(UIKit.PAPERLINE, 0.7), 1, Vector4(10, 8, 10, 8)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); box.add_child(vb); parent.add_child(box)
	vb.add_child(_rich("[b]%s[/b]" % title, 15))
	return vb
static func _line(vb: Control, bb: String, btns: Array) -> void:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 4)
	hb.add_child(_rich(bb, 13.5))
	for b in btns: hb.add_child(b)
	vb.add_child(hb)

# 建築卡效果行
static func effect_text() -> String:
	var L = BK.lv()
	var s = T("陰兵上限 +%d　民宅招兵速度 ×%.2f　陰兵戰力 ×%.2f", "陰兵上限 +%d　民宅招兵速度 ×%.2f　陰兵戰力 ×%.2f") % [int(BK.cap_bonus()), BK.train_mul(), BK.troop_mul()]
	s += "<br>" + T("防衛隊長名額 %d　每區清剿上限 %d　陰兵 %d（待命 %d／防衛 %d／清剿 %d）", "防衛隊長名額 %d　每區清剿上限 %d　陰兵 %d（待命 %d／防衛 %d／清剿 %d）") % [BK.max_def_caps(), BK.sweep_cap(), BK.total(), BK.standby(), BK.def_n(), BK.sweep_n()]
	var a = BK.st()
	if a != null and J.num(a.get("floor", 1.0)) > 1.0 + BK.POW_K * L + 0.0001:
		s += "<br>" + T("（舊村子民宅加成保底 ×%.2f：兵營升到 Lv%d 先會再加）", "（舊村子民宅加成保底 ×%.2f：兵營升到 Lv%d 才會再加）") % [J.num(a.floor), int(ceil((J.num(a.floor) - 1.0) / BK.POW_K + 0.0001))]
	return s

# ================= 兵營面板（派遣） =================
static func panel(body: VBoxContainer, refresh: Callable) -> void:
	if not BK.built(): return
	BK.normalize()
	var rf = func(): refresh.call()
	# 待命
	var v0 = _box(body, T("待命（攻佔資源區用）", "待命（攻佔資源區用）"))
	_line(v0, T("待命陰兵 [b]%d[/b]　攻佔戰力 [b][color=#9c2219]%d[/color][/b]\n[font_size=12]喺地圖撳資源區「派陰兵攻佔」就用呢班；攻佔會折損約三成。[/font_size]", "待命陰兵 [b]%d[/b]　攻佔戰力 [b][color=#9c2219]%d[/color][/b]\n[font_size=12]在地圖點資源區「派陰兵攻佔」就用這批；攻佔會折損約三成。[/font_size]") % [BK.standby(), BK.power()], [])
	load("res://game/militia/ml_ui.gd").bk_box(body)   # [militia] 遊魂兵（民兵）一欄
	# 防衛
	var v1 = _box(body, T("村子防衛（守村口、大排檔、已佔資源區）", "村子防衛（守村口、大排檔、已佔資源區）"))
	var can_add = BK.standby() > 0
	_line(v1, T("防衛陰兵 [b]%d[/b]　防衛戰力 [b]%d[/b]", "防衛陰兵 [b]%d[/b]　防衛戰力 [b]%d[/b]") % [BK.def_n(), BK.def_power()], [
		_b("−%d" % BK.STEP, "", BK.def_n() > 0, func(): BK.add_def(-BK.STEP); rf.call()),
		_b("+%d" % BK.STEP, "gold", can_add, func(): BK.add_def(BK.STEP); rf.call()),
		_b(T("全部", "全部"), "", can_add, func(): BK.add_def(BK.standby()); rf.call())])
	var a = BK.st()
	var mx = BK.max_def_caps()
	v1.add_child(_rich(T("[font_size=12]防衛隊長 %d/%d（名鬼；每位按等級加防衛戰力，Lv1 = +1.2%%）[/font_size]", "[font_size=12]防衛隊長 %d/%d（名鬼；每位按等級加防衛戰力，Lv1 = +1.2%%）[/font_size]") % [a.cap_def.size(), mx], 13, UIKit.INKDIM))
	for id in a.cap_def:
		var g = BK.ghost(id)
		if g == null: continue
		var gid = J.str(id)
		_line(v1, "%s　Lv%d" % [J.str(g.name), int(BK.glv(g))], [_b(T("換人", "換人"), "", true, func(): open_cap_pick("cap_def", gid)), _b(T("撤下", "撤下"), "", true, func(): BK.set_job(gid, "idle"); rf.call())])
	if a.cap_def.size() < mx: _line(v1, "[color=#8a7650]" + T("空缺", "空缺") + "[/color]", [_b(T("委任", "委任"), "gold", true, func(): open_cap_pick("cap_def", null))])
	# 清剿
	var v2 = _box(body, T("野外清剿（已打低王嘅野外區）", "野外清剿（已打倒王的野外區）"))
	var zs = BK.sweep_zones()
	if zs.is_empty():
		v2.add_child(_rich(T("[color=#8a7650]未有可以清剿嘅野外區：先打低野外區入面所有王。[/color]", "[color=#8a7650]還沒有可以清剿的野外區：先打倒野外區裡所有王。[/color]"), 13))
	for zid in zs:
		var z: String = zid
		var n = BK.sweep_n(z); var r = BK.sweep_rate(z)
		var info = T("[b]%s[/b]　陰兵 %d/%d", "[b]%s[/b]　陰兵 %d/%d") % [BK.zone_name(z), n, BK.sweep_cap()]
		if n > 0: info += "\n[font_size=12]" + T("每小時 冥幣 +%d、棺材板 +%d；每 10 分鐘折損 %d", "每小時 冥幣 +%d、棺材板 +%d；每 10 分鐘折損 %d") % [int(r.coins * 60), int(r.planks * 60), int(r.loss)] + "[/font_size]"
		_line(v2, info, [
			_b("−%d" % BK.STEP, "", n > 0, func(): BK.add_sweep(z, -BK.STEP); rf.call()),
			_b("+%d" % BK.STEP, "gold", BK.standby() > 0 and n < BK.sweep_cap(), func(): BK.add_sweep(z, BK.STEP); rf.call()),
			_b(T("最多", "最多"), "", BK.standby() > 0 and n < BK.sweep_cap(), func(): BK.set_sweep(z, BK.sweep_cap()); rf.call())])
		var cg = BK.ghost(a.cap_sweep.get(z))
		if cg != null:
			var cid = J.str(cg.id)
			_line(v2, "[font_size=12]" + T("清剿隊長 %s Lv%d：收入 +%d%%、折損 −%d%%", "清剿隊長 %s Lv%d：收入 +%d%%、折損 −%d%%") % [J.str(cg.name), int(BK.glv(cg)), int(1.5 * BK.glv(cg)), int(100 - 100 * maxf(0.3, 1.0 - 0.02 * BK.glv(cg)))] + "[/font_size]",
				[_b(T("換人", "換人"), "", true, func(): open_cap_pick("cap_sweep", z)), _b(T("撤下", "撤下"), "", true, func(): BK.set_job(cid, "idle"); rf.call())])
		else: _line(v2, "[font_size=12][color=#8a7650]" + T("清剿隊長：空缺", "清剿隊長：空缺") + "[/color][/font_size]", [_b(T("委任", "委任"), "gold", true, func(): open_cap_pick("cap_sweep", z))])
	var e = a.get("earn", {})
	if e is Dictionary and (J.num(e.get("coins", 0)) > 0 or J.num(e.get("lost", 0)) > 0):
		v2.add_child(_rich("[font_size=12]" + T("累計收入：冥幣 %d、棺材板 %d；折損陰兵 %d", "累計收入：冥幣 %d、棺材板 %d；折損陰兵 %d") % [int(J.num(e.get("coins", 0))), int(J.num(e.get("planks", 0))), int(J.num(e.get("lost", 0)))] + "[/font_size]", 12, UIKit.INKDIM))
	v2.add_child(_rich("[font_size=12]" + T("收入自動入倉（棺材板唔過倉庫上限）。離線最多計 4 小時。", "收入自動入倉（棺材板不超過倉庫上限）。離線最多計 4 小時。") + "[/font_size]", 12, UIKit.INKDIM))

# ================= 揀隊長 =================
static func _named() -> Array:
	var s = BK.S(); var o = []
	for g in s.get("ghosts", []): if BK.is_named(g): o.append(g)
	o.sort_custom(func(x, y): return BK.glv(x) > BK.glv(y))
	return o
static func open_cap_pick(jb: String, arg) -> void:
	var m = Menus.main()
	var title = T("委任防衛隊長", "委任防衛隊長") if jb == "cap_def" else T("委任清剿隊長・", "委任清剿隊長・") + BK.zone_name(str(arg))
	Menus._begin(title, "bkcap:" + jb, func(): pass)
	Menus._clear()
	var body = Menus._body()
	body.add_child(_rich(T("揀一隻名鬼。每隻名鬼同時只做一件事：揀咗佢，佢會自動由原本嘅職務（出陣、生產、隊長）調過嚟。", "選一隻名鬼。每隻名鬼同時只做一件事：選了他，他會自動從原本的職務（出陣、生產、隊長）調過來。"), 13.5, UIKit.INKDIM))
	var a = BK.st()
	for g in _named():
		var gid = J.str(g.id)
		var cur = BK.job_label(g)
		var away = BK.job(g) == "away"
		var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 8)
		row.add_child(Menus._por(J.str(g.k), 44, 0.5 if away else 1.0))
		row.add_child(_rich("[b]%s[/b] Lv%d\n[font_size=12]%s[/font_size]" % [J.str(g.name), int(BK.glv(g)), T("目前：", "目前：") + cur], 14))
		var rep = null
		if jb == "cap_def" and a.cap_def.size() >= BK.max_def_caps() and a.cap_def.size() > 0: rep = a.cap_def[0] if arg == null else arg
		var ar = arg if jb == "cap_sweep" else rep
		var same = (jb == "cap_def" and BK.job(g) == "cap_def") or (jb == "cap_sweep" and J.str(a.cap_sweep.get(str(arg))) == gid)
		row.add_child(_b(T("而家係佢", "現在是他") if same else T("揀佢", "選他"), "gold", not away and not same, func():
			var r = BK.set_job(gid, jb, ar)
			if r != "ok": _toast(r)
			Menus.open_bld("barracks")))
		body.add_child(row); body.add_child(UIKit.hsep())
	var bk = _b(T("返回", "返回"), "", true, func(): Menus.open_bld("barracks")); bk.custom_minimum_size = Vector2(0, 40); body.add_child(bk)

# ================= 名冊：分配（名鬼一職） =================
static func job_btn(gid: String) -> Button:
	var b = UIKit.btn(T("分配", "分配"), "", true); b.focus_mode = Control.FOCUS_NONE; b.custom_minimum_size = Vector2(76, 30)
	b.pressed.connect(func(): Snd.play("click"); open_job(gid))
	return b
static func _toast(bb: String) -> void:
	var m = Menus.main()
	if m != null and m.has_method("show_toast"): m.show_toast(str(DB.N(bb)))
static func _do(gid: String, jb: String, arg = null) -> void:
	var r = BK.set_job(gid, jb, arg)
	if r != "ok": _toast(r)
	open_job(gid)
static func open_job(gid: String) -> void:
	var g = BK.ghost(gid)
	if g == null: Menus.open_roster(); return
	Menus._begin(T("分配：", "分配：") + J.str(g.name), "bkjob:" + gid, func(): pass)
	Menus._clear()
	var body = Menus._body(); var s = BK.S(); var a = BK.st()
	var top = HBoxContainer.new(); top.add_theme_constant_override("separation", 8)
	top.add_child(Menus._por(J.str(g.k), 56))
	top.add_child(_rich("[b]%s[/b]　Lv%d\n%s[b][color=#9c2219]%s[/color][/b]\n[font_size=12]%s[/font_size]" % [J.str(g.name), int(BK.glv(g)), T("而家：", "現在："), BK.job_label(g),
		T("每隻名鬼同時只做一件事。揀新職務，佢會自動由原本嘅職務移走。", "每隻名鬼同時只做一件事。選新職務，他會自動從原本的職務移走。")], 14))
	body.add_child(top); body.add_child(UIKit.hsep())
	if BK.job(g) == "away":
		body.add_child(_rich(T("[color=#c2362b]佢喺村外工作緊（站崗／樓裡有鬼等），要先喺嗰邊撤返。[/color]", "[color=#c2362b]他在村外工作中（站崗／樓裡有鬼等），要先在那邊撤回。[/color]"), 14))
	else:
		# 出陣
		var vt = _box(body, T("出陣（最多 3）", "出陣（最多 3）"))
		var in_team = J.iter(s.get("team", [])).has(g.id)
		if in_team: vt.add_child(_rich(T("已經出陣緊。", "已經在出陣。"), 13))
		elif J.iter(s.get("team", [])).has(null): _line(vt, T("有空位", "有空位"), [_b(T("出陣", "出陣"), "gold", true, func(): _do(gid, "team"))])
		else:
			for x in s.team:
				var og = BK.ghost(x)
				if og == null: continue
				var xid = J.str(x)
				_line(vt, T("換走 %s", "換走 %s") % J.str(og.name), [_b(T("換", "換"), "", true, func(): _do(gid, "team", xid))])
		# 生產
		var vp = _box(body, T("生產（村子工位）", "生產（村子工位）"))
		var P = J.G.get("POSTS"); var F = J.G.get("F"); var any = false
		for pk in P:
			var n = int(J.num(J.mc(F, "slots", [pk])))
			if n <= 0: continue
			any = true
			var used = 0
			for x in s.ghosts: if J.str(x.get("post")) == J.str(pk): used += 1
			var here = J.str(g.get("post")) == J.str(pk)
			var post: String = J.str(pk)
			_line(vp, "%s　%d/%d%s" % [J.str(P[pk].name), used, n, ("　[color=#2e6d3a]" + T("（而家喺度）", "（現在在這）") + "[/color]") if here else ""], [_b(T("去", "去"), "", not here, func(): _do(gid, "post", post))])
		if not any: vp.add_child(_rich(T("未有開咗嘅工位。", "還沒有開放的工位。"), 13))
		# 隊長
		var vc = _box(body, T("兵營隊長", "兵營隊長"))
		if not BK.built(): vc.add_child(_rich(T("[color=#8a7650]先起陰兵兵營（要先有民宅）。[/color]", "[color=#8a7650]先建陰兵兵營（要先有民宅）。[/color]"), 13))
		else:
			var full = a.cap_def.size() >= BK.max_def_caps()
			if BK.job(g) != "cap_def":
				if not full: _line(vc, T("防衛隊長（%d/%d）", "防衛隊長（%d/%d）") % [a.cap_def.size(), BK.max_def_caps()], [_b(T("當", "當"), "gold", true, func(): _do(gid, "cap_def"))])
				else:
					for x in a.cap_def:
						var og2 = BK.ghost(x)
						if og2 == null: continue
						var xid2 = J.str(x)
						_line(vc, T("防衛隊長：換走 %s", "防衛隊長：換走 %s") % J.str(og2.name), [_b(T("換", "換"), "", true, func(): _do(gid, "cap_def", xid2))])
			for zid in BK.sweep_zones():
				var z: String = zid
				var cg = BK.ghost(a.cap_sweep.get(z))
				if cg != null and J.str(cg.id) == gid: continue
				_line(vc, T("清剿隊長・%s%s", "清剿隊長・%s%s") % [BK.zone_name(z), (T("（換走 %s）", "（換走 %s）") % J.str(cg.name)) if cg != null else ""], [_b(T("當", "當"), "gold", true, func(): _do(gid, "cap_sweep", z))])
			if BK.sweep_zones().is_empty(): vc.add_child(_rich(T("[font_size=12][color=#8a7650]清剿隊長：未有可以清剿嘅野外區。[/color][/font_size]", "[font_size=12][color=#8a7650]清剿隊長：還沒有可以清剿的野外區。[/color][/font_size]"), 12))
		if BK.job(g) != "idle":
			var ib = _b(T("休息（乜都唔做）", "休息（什麼都不做）"), "", true, func(): _do(gid, "idle")); ib.custom_minimum_size = Vector2(0, 38); body.add_child(ib)
	var bk = _b(T("返名冊", "回名冊"), "", true, func(): Menus.open_roster()); bk.custom_minimum_size = Vector2(0, 40); body.add_child(bk)
