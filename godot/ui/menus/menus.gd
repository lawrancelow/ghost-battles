# 線路 H：村子面板原生化（建築、派人、名冊、箱子）
# 資料同規則全部經 JS（UI._n.*：同原本 game.js click handler 一模一樣），呢度只負責畫介面同收撳掣。
# 原生做唔到（例如新鬼圖鑑、劇情回顧）就照用 DOM。
class_name Menus
extends RefCounted

const SAVE_KEY := "ghostBattles_v1"
static var cur := ""          # 而家開緊邊個面板："bld:<id>" / "pick:<post>" / "roster" / "chest"
static var arg_a := ""
static var arg_b := ""
static var sig := ""          # 上次畫嘅資料簽名：冇變就唔重畫（唔使每 0.5 秒成個面板重砌）

static func main() -> Control: return Engine.get_main_loop().root.get_node_or_null("Main")
static func N(): return J.gp(J.G.get("UI"), "_n")
static func jn(m: String, a := []): return J.mc(N(), m, a)
static func T(yue: String, zh: String) -> String: return DB.N(zh if DB.lang != "yue" else yue)

static func hook(a: Array) -> bool:
	var m = main()
	if m == null or N() == null: return false
	_ensure_pause(m)
	var kind = J.str(a[0])
	match kind:
		"bld": open_bld(J.str(a[1]))
		"pick": open_pick(J.str(a[1]), J.str(a[2]) if a.size() > 2 else "")
		"roster": open_roster()
		"chest": open_chest()
		"codex": open_codex()
		"story": open_story()
		"pres": open_pres()
		"sports": open_sports()
		_: return false
	return true

# 面板開住（佢蓋住大半個村）就暫停村子原生繪畫同物件同步（約 7ms／格）；JS 嘅生產、任務照行
static var _pause_hooked := false
static func _ensure_pause(m) -> void:
	if _pause_hooked or m.village == null: return
	_pause_hooked = true
	m.sheet.visibility_changed.connect(func():
		if is_instance_valid(m.village): m.village.process_mode = Node.PROCESS_MODE_DISABLED if m.sheet.visible else Node.PROCESS_MODE_INHERIT)

static func close_hook() -> void:
	if cur == "": return
	cur = ""; sig = ""
	var m = main()
	if m and m.sheet.visible: m.close_sheet()

# ---------------- 共用 ----------------
static func _begin(title: String, key: String, refresher: Callable) -> void:
	var m = main()
	var same = cur == key and m.sheet.visible
	cur = key; sig = ""
	if not same:
		m.open_sheet(title, refresher)
		Snd.play("paper")
	else:
		m.sheet_title.text = title; m.sheet_refresh = refresher

static func _body() -> VBoxContainer: return main().sheet_body
static func _clear() -> void:
	var b = _body()
	for c in b.get_children(): b.remove_child(c); c.queue_free()

static func _p(bb: String, size := 14.0, col := UIKit.INKDIM, kind := "sans") -> RichTextLabel:
	var r = UIKit.rich(DB.N(bb), size, col, kind); _body().add_child(r); return r

static func _row(text_bb: String, buttons: Array, parent: Control = null) -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
	var r = UIKit.rich(DB.N(text_bb), 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
	var bx = HBoxContainer.new(); bx.add_theme_constant_override("separation", 4); bx.alignment = BoxContainer.ALIGNMENT_END
	for b in buttons: bx.add_child(b)
	hb.add_child(bx)
	var par = parent if parent else _body()
	par.add_child(hb); par.add_child(UIKit.hsep())
	return hb

static func _btn(text: String, kind: String, enabled: bool, f: Callable, small := false) -> Button:
	var b = UIKit.btn(text, kind, small); b.disabled = not enabled; b.focus_mode = Control.FOCUS_NONE
	b.pressed.connect(func(): Snd.play("click"); f.call())
	return b

# 撳兩下先做（同網頁版 confirmInline 一樣）
static func _confirm_btn(text: String, kind: String, msg: String, f: Callable, small := true) -> Button:
	# 註：small=false 用喺闊掣
	var b = UIKit.btn(text, kind, small); b.focus_mode = Control.FOCUS_NONE
	var armed = [0]
	b.pressed.connect(func():
		var now = Time.get_ticks_msec()
		if now - armed[0] < 2500: f.call(); return
		armed[0] = now; b.text = msg
		b.get_tree().create_timer(2.5).timeout.connect(func(): if is_instance_valid(b): b.text = text))
	return b

# 快版 RichTextLabel：先設字體再設文字（UIKit.rich 先設文字會排版兩次）
static func _rich(text: String, size := 14.0, col := UIKit.INKTXT) -> RichTextLabel:
	var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false; r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	r.add_theme_font_override("normal_font", UIKit.font("sans", 400)); r.add_theme_font_override("bold_font", UIKit.font("sans", 900))
	r.add_theme_font_size_override("normal_font_size", int(size)); r.add_theme_font_size_override("bold_font_size", int(size))
	r.add_theme_color_override("default_color", col); r.mouse_filter = Control.MOUSE_FILTER_PASS
	r.text = DB.N(text); return r   # [femfix] 女主：名、稱號照改

static func bb(h) -> String: return JSBridge.html2bb(J.str(h)).replace("[color=#ff8a7a]", "[color=#c2362b]")

static func _keep_scroll(f: Callable) -> void:
	var m = main(); var sc = m.sheet_scroll.scroll_vertical
	f.call()
	m.sheet_scroll.set_deferred("scroll_vertical", sc)

static func _changed(data) -> bool:
	var s = JSON.stringify(data)
	if s == sig: return false
	sig = s; return true

static func _por(k: String, size := 56, alpha := 1.0, brk := false) -> Control:
	if brk and load("res://game/soul/ace_frame.gd").lvl(k) > 0: return load("res://game/soul/ace_frame.gd").por(k, size, alpha)   # [p44] 最高階撐爆畫框
	var t = UIKit.portrait(k, size); t.modulate.a = alpha
	var w = PanelContainer.new(); w.add_theme_stylebox_override("panel", UIKit.sb(Color(0.17, 0.12, 0.1, 0.9), 6, Color("#6a5040"), 1))
	w.custom_minimum_size = Vector2(size + 4, size + 4); w.add_child(t); return w

static func _qtag(q: String) -> String:
	var c = {"藍": "#2f6fb0", "紫": "#7a3fb0", "名": "#b07a1f", "主": "#c2362b"}.get(q, "#6e5838")
	return "[color=%s][b]%s[/b][/color]" % [c, q]

# ---------------- 建築 ----------------
static func open_bld(id: String) -> void:
	var d = jn("bld", [id])
	_begin(J.str(d.name), "bld:" + id, func(): _render_bld(id, false))
	_render_bld(id, true)

static func _render_bld(id: String, force: bool) -> void:
	if cur != "bld:" + id: return
	var d = jn("bld", [id])
	if not _changed(d) and not force: return
	_keep_scroll(func(): _draw_bld(id, d))

static func _act_bld(id: String, a: String, arg = null) -> void:
	var r = jn("bldAct", [id, a, arg])
	if J.str(r) == "close": return
	_render_bld(id, true)

static func _draw_bld(id: String, d) -> void:
	_clear()
	_p(J.str(d.flavor), 14.5, UIKit.INKTXT, "serif"); _body().add_child(UIKit.hsep())
	_p(bb(d.desc), 14)
	var lv = int(J.num(d.lv))
	if lv == 0:
		if not J.t(d.unlocked): _p("[color=#c2362b]尚未解鎖。[/color]")
		else: _row(("%s費用：" % J.str(d.get("buildLbl")) if d.get("buildLbl") != null else "建造費用：") + bb(d.cost), [_btn(J.str(d.get("buildLbl")) if d.get("buildLbl") != null else "建造", "gold", J.t(d.canBuild), func(): _act_bld(id, "build"))])   # [village2] 資源田：「開墾」
		return
	_p("等級 [b][color=#9c2219]Lv %d[/color][/b]%s" % [lv, "" if id == "house" else "（上限 = 鬼宅等級 %d）" % int(J.num(d.house))], 15, UIKit.INKTXT)
	var eff = bb(J.gp(d, "effect"))
	if eff != "":
		var ep = PanelContainer.new(); ep.add_theme_stylebox_override("panel", UIKit.sb(Color(0.3, 0.22, 0.1, 0.12), 3, Color(0, 0, 0, 0), 0, Vector4(10, 6, 10, 6)))
		ep.add_child(_rich(eff, 13.5, Color("#3a2e1a"))); _body().add_child(ep)
	if d.get("upCost") != null:
		var disc = int(J.num(d.get("disc", 0)))
		_row("升級：" + bb(d.upCost) + ("\n[font_size=12]工頭省了 %d%% 棺材板[/font_size]" % disc if disc else ""), [_btn("升級", "gold", J.t(d.canUp), func(): _act_bld(id, "up"))])
	else: _p("已達最高等級。" if id == "house" else "已達上限，先升級鬼宅。")
	var cr = d.get("craft")
	if cr != null:
		var can = int(J.num(cr.can)); var bs = []
		for n in [1, 5, 10]:
			var nn: int = n
			bs.append(_btn("做1份" if n == 1 else "一次做%d份" % n, "", can >= 1, func(): _act_bld(id, "craft", nn), true))
		var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 4)
		vb.add_child(UIKit.rich("親手做：每份 4 %s　好評 +1\n[font_size=12]現有%s %d，夠做 %d 份[/font_size]" % [J.str(cr.label), J.str(cr.src), int(J.num(cr.have)), can], 14, UIKit.INKTXT))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 4)
		for b in bs: hb.add_child(b)
		vb.add_child(hb); _body().add_child(vb); _body().add_child(UIKit.hsep())
	if d.get("furnace") != null: load("res://game/joss/joss_ui.gd").panel(_body(), func(): _render_bld(id, true))   # [joss] 陽間包裹
	var al = d.get("altar")
	if al != null and load("res://game/soul/soul_ui.gd").altar(_body(), func(): _render_bld(id, true)): al = null   # [soul] 祭壇四頁（招雜鬼頁照用下面舊介面）
	if al != null:
		_row("招魂一次：%s\n[font_size=12]雜鬼名額 %d/%d（升級民宅增加；收服的名鬼不佔名額）[/font_size]" % [bb(al.cost), int(J.num(al.cnt)), int(J.num(al.cap))], [_btn("招魂", "gold", J.t(al.can), func(): _act_bld(id, "recruit"))])
		_p("目前可能招到：%s。收服更多鬼怪後，招魂池會變大。" % J.str(al.pool), 13)
		var gone = al.get("gone")
		if gone is Array and gone.size():
			_p("[b]魂飛魄散名單[/b]", 15, UIKit.INKTXT, "serif")
			_p("淡走了的鬼，招魂台上還留著寫有他們名字的黃紙。重新招魂費用跟招魂一樣；回來的會失憶（等級剩一半，冤家關係重新開始）。", 13)
			var i = 0
			for o in gone:
				var ii = i
				_row("%s　Lv%d" % [J.str(o.name), int(J.num(o.lv))], [_btn("重新招魂", "gold", true, func(): _act_bld(id, "regone", ii), true)])
				i += 1
	var fe = d.get("feast")
	if fe != null:
		var left2 = J.num(fe.left)
		_row("鬼節宴：壽包 300\n[font_size=12]全村智力總和 %d/%d%s[/font_size]" % [int(J.num(fe.iq)), int(J.num(fe.need)), "　冷卻 %d 分" % int(ceil(left2 / 60)) if left2 > 0 else ""], [_btn("擺宴", "gold", J.t(fe.can), func(): _act_bld(id, "feast"))])
	if id == "barracks": load("res://game/barracks/bk_ui.gd").panel(_body(), func(): _render_bld(id, true))   # [barracks] 派遣、隊長
	for p in d.posts:
		_post_ui(id, p)

static func _post_ui(id: String, p) -> void:
	var box = PanelContainer.new(); box.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.06), 6, Color(UIKit.PAPERLINE, 0.7), 1, Vector4(10, 8, 10, 8)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); box.add_child(vb); _body().add_child(box)
	vb.add_child(UIKit.rich("[b]%s崗位[/b] [font_size=12][color=#6e5838]%s[/color][/font_size]" % [J.str(p.name), J.str(p.desc)], 15, UIKit.INKTXT))
	if J.t(p.lock):
		vb.add_child(UIKit.rich("[color=#c2362b]升到 4 級【略懂管理學】後可派鬼怪打工。[/color]", 13)); return
	var post = J.str(p.post)
	for s in p.slots:
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8)
		if s != null:
			hb.add_child(_por(J.str(s.k), 44))
			var r = UIKit.rich("[b]%s[/b]\n[font_size=12]Lv%d　%s[/font_size]" % [J.str(s.name), int(J.num(s.lv)), J.str(s.stat)], 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
			var gid = J.str(s.id)
			hb.add_child(_btn("撤下", "", true, func(): _act_bld(id, "unassign", gid), true))
		else:
			var r2 = UIKit.rich("[color=#8a7650]空崗位[/color]", 14); r2.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r2)
			hb.add_child(_btn("派人", "", true, func(): open_pick(post, id), true))
		vb.add_child(hb)

# ---------------- 派人 ----------------
static func open_pick(post: String, back: String) -> void:
	arg_a = post; arg_b = back
	var d = jn("pick", [post])
	_begin("派人：" + J.str(d.name), "pick:" + post, func(): pass)
	_clear()
	var stn = J.str(d.stat)
	_p("挑一位去「%s」。%s已在別處打工的，會被調過來。" % [J.str(d.name), "這份工看【%s】。" % stn if stn != "等級" else "這份工看等級。"], 14)
	_p("▼ 已按【%s】由高到低排好" % stn, 12.5, UIKit.CINNABAR2)
	if d.list.size() == 0: _p("沒有可以派的鬼怪。")
	for g in d.list:
		var fb = J.t(g.fb)
		var row = Button.new(); row.flat = true; row.focus_mode = Control.FOCUS_NONE; row.custom_minimum_size = Vector2(0, 62); row.disabled = fb
		row.add_theme_stylebox_override("normal", UIKit.sb(Color(0, 0, 0, 0.05), 6, Color(UIKit.PAPERLINE, 0.6), 1))
		row.add_theme_stylebox_override("hover", UIKit.sb(Color(0.8, 0.6, 0.3, 0.15), 6, UIKit.PAPERLINE, 1))
		row.add_theme_stylebox_override("pressed", UIKit.sb(Color(0.8, 0.5, 0.3, 0.3), 6, UIKit.PAPERLINE, 1))
		row.add_theme_stylebox_override("disabled", UIKit.sb(Color(0, 0, 0, 0.1), 6, Color(UIKit.PAPERLINE, 0.4), 1))
		var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 6; hb.offset_right = -6; hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_theme_constant_override("separation", 8)
		var po = _por(J.str(g.k), 48, 0.5 if fb else 1.0); po.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(po)
		var keytxt = "%s %d" % [stn, int(J.num(g.key))]
		var r = UIKit.rich(DB.N("[b]%s[/b] %s　[color=#9c2219][b]%s[/b][/color]%s　%s\n[font_size=12]%s%s[/font_size]" % [J.str(g.name), _qtag(J.str(g.q)), keytxt, ("　Lv%d" % int(J.num(g.lv))) if stn != "等級" else "", J.str(g.other), ("目前：" + J.str(g.where)) if J.str(g.where) != "閒著" else "閒著", "　[color=#c2362b]怕糯米，不肯去[/color]" if fb else ""]), 14, UIKit.INKTXT)
		r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; r.mouse_filter = Control.MOUSE_FILTER_IGNORE; r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hb.add_child(r); row.add_child(hb)
		var gid = J.str(g.id)
		row.pressed.connect(func(): Snd.play("click"); jn("pickDo", [post, gid]); open_bld(back))
		_body().add_child(row)
	var bk = _btn("返回", "", true, func(): open_bld(back)); bk.custom_minimum_size = Vector2(0, 40); _body().add_child(bk)

# ---------------- 名冊 ----------------
static func open_roster() -> void:
	_begin("鬼怪名冊", "roster", func(): _render_roster(false))
	_render_roster(true)

static var r_head: RichTextLabel
static var r_cards := {}     # id -> [簽名, 卡 node]
static func _render_roster(force: bool) -> void:
	if cur != "roster": return
	var d = jn("roster")
	if force or r_head == null or not is_instance_valid(r_head):
		_keep_scroll(func(): _draw_roster(d)); return
	# 局部更新：只換有變嘅卡（以前每 0.5 秒成個名冊重砌 ~80ms）
	r_head.text = _roster_head(d)
	var seen = {}
	var order = []
	for g in d.list:
		var id = J.str(g.id); seen[id] = true; order.append(id)
		var sg = JSON.stringify(g)
		var old = r_cards.get(id)
		if old != null and old[0] == sg and is_instance_valid(old[1]): continue
		var nc = _gcard(g)
		if old != null and is_instance_valid(old[1]):
			var idx = old[1].get_index(); _body().remove_child(old[1]); old[1].queue_free(); _body().move_child(nc, idx)
		r_cards[id] = [sg, nc]
	for id in r_cards.keys():
		if not seen.has(id):
			var o = r_cards[id]
			if is_instance_valid(o[1]): _body().remove_child(o[1]); o[1].queue_free()
			r_cards.erase(id)
	# 排序有變（例如升級後）就照新次序排
	var base = r_cards[order[0]][1].get_index() if order.size() else 0
	for i in order.size():
		var n: Control = r_cards[order[i]][1]
		if n.get_index() != base + i: _body().move_child(n, base + i)

static func _roster_head(d) -> String:
	return "升級鬼怪：Lv10 前用冥幣＋普通包子，Lv10 起用壽包＋冥幣。等級上限 %d。雜鬼名額 %d/%d　壽包 %s" % [int(J.num(d.cap)), int(J.num(d.fcnt)), int(J.num(d.rcap)), J.str(d.buns)]   # [ux]

static func _draw_roster(d) -> void:
	_clear(); r_cards.clear()
	r_head = _p(_roster_head(d), 14)
	_p(T("鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：喺村升級、落訓練班練嚇功，出面即刻勁啲。出面打唔過，就返嚟升級。", "鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：在村裡升級、去訓練班練嚇功，外面立即變強。外面打不過，就回來升級。"), 12.5, Color("#7a4a2a"))
	if d.get("codex") != null:
		var cb = _btn("新鬼圖鑑（%s）" % J.str(d.codex), "", true, func(): close_hook(); J.mc(J.G.get("N30W"), "openCodex", []))
		cb.custom_minimum_size = Vector2(0, 40); _body().add_child(cb)
	load("res://game/soul/soul_codex.gd").roster_btns(_body())   # [soul2] 名鬼圖鑑、王座重遊
	for g in d.list: r_cards[J.str(g.id)] = [JSON.stringify(g), _gcard(g)]

static func _gcard(g) -> Control:
	var card = PanelContainer.new()
	var st = UIKit.sb(Color(0, 0, 0, 0.05), 8, Color("#d9b440") if J.t(g.gold) else Color(UIKit.PAPERLINE, 0.6), 2 if J.t(g.gold) else 1, Vector4(8, 8, 8, 8))
	card.add_theme_stylebox_override("panel", st)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); card.add_child(hb)
	var po = _por(J.str(g.k), 60, J.num(g.alpha) if g.get("alpha") != null else 1.0, true); po.size_flags_vertical = Control.SIZE_SHRINK_BEGIN; hb.add_child(po)
	# 一張卡只用一個 RichTextLabel（以前每行一個，7 張卡要 90ms）
	var L = []
	var tag = J.str(g.tag)
	L.append("[font_size=15][b]%s[/b] %s [color=#9c2219]Lv%d[/color]%s[/font_size]" % [J.str(g.name), _qtag(J.str(g.q)), int(J.num(g.lv)), (" [bgcolor=#c2362b][color=#fff3e0] %s [/color][/bgcolor]" % tag) if tag != "" else ""])
	var stt = g.st
	L.append("%s力 %d　智 %d　武 %d　%s" % [(J.str(g.title) + "　") if J.str(g.title) != "" else "", int(J.num(stt[0])), int(J.num(stt[1])), int(J.num(stt[2])), "遠程" if J.t(g.ranged) else "近戰"])
	var gp = "[color=#5a3a1a]鬼力 [b]%d[/b]" % int(J.num(g.gp))
	if g.get("gpNext") != null: gp += "　升級後 [b][color=#2e6d3a]%d[/color][/b]（+%d）" % [int(J.num(g.gpNext)), int(J.num(g.gpNext) - J.num(g.gp))]
	if g.get("drill") != null: gp += "　嚇功 Lv%d" % int(J.num(g.drill))
	L.append(gp + "[/color]")
	if J.str(g.sk) != "": L.append("[color=#7a3a1a]【%s】[/color]%s" % [J.str(g.sk), J.str(g.skd)])
	if J.str(g.trait) != "": L.append(bb(g.trait))
	if J.str(g.lore) != "": L.append(bb(g.lore))
	for e in g.extra: L.append("[color=%s]%s[/color]" % [J.str(e[0]), J.str(e[1])])
	if g.get("pres") != null:
		var v = int(J.num(g.pres)); var col = "#3e9a4c" if v > 60 else ("#b88a1a" if v > 30 else "#c0392b"); var nb = clampi(int(round(v / 10.0)), 0, 10)
		var line = "存在感 %d [color=%s]%s[/color][color=#00000030]%s[/color]" % [v, col, "▮".repeat(nb), "▮".repeat(10 - nb)]
		if g.get("presDays") != null: line += "　[color=#c0392b][b]魂飛魄散倒數 %d 日[/b][/color]" % int(J.num(g.presDays))
		elif v <= 30: line += "　[color=#c0392b][b]⚠ 存在感不足[/b][/color]"
		elif v < 60: line += "　[color=#9a7a3a]變淡中[/color]"
		L.append(line)
	L.append(J.str(g.where))
	var rt = _rich("\n".join(L), 12.5, UIKit.INKDIM); rt.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(rt)
	var act = VBoxContainer.new(); act.add_theme_constant_override("separation", 4); act.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(act)
	var gid = J.str(g.id)
	if J.t(g.afu): act.add_child(UIKit.label("隨主公等級成長", 11, UIKit.INKDIM))
	elif not J.t(g.maxed):
		var pt = J.str(g.get("payTxt")) if g.get("payTxt") != null else "壽包 %d" % int(J.num(g.cost))   # [ux] 用料按等級（前期冥幣＋普通包子）
		var ub = _btn("升級\n" + pt.replace("＋", "\n"), "gold", J.t(g.canUp), func(): jn("rosterAct", ["up", gid]); _render_roster(false), true)
		ub.custom_minimum_size = Vector2(92, 46); ub.add_theme_font_size_override("font_size", 12); act.add_child(ub)
	else: act.add_child(UIKit.label("已達上限", 11, UIKit.INKDIM))
	if J.t(g.get("job")): act.add_child(load("res://game/barracks/bk_ui.gd").job_btn(gid))   # [barracks] 名鬼分配
	if J.t(g.canRel):
		var rb = _confirm_btn("送去投胎", "ghost", "確定？", func(): jn("rosterAct", ["rel", gid]); _render_roster(false))
		rb.custom_minimum_size = Vector2(76, 30); act.add_child(rb)
	load("res://game/equip/eq_ui.gd").roster_strip(card, hb, gid)   # [equip] 裝備三格（撳開換裝）
	load("res://game/equip/eq_ui.gd").on_change = func(): _render_roster(true)   # [equip]
	_body().add_child(card)
	return card

# ---------------- 箱子 ----------------
static func open_chest() -> void:
	_begin("箱子", "chest", func(): _render_chest(false))
	_render_chest(true)

static func _render_chest(force: bool) -> void:
	if cur != "chest": return
	var d = jn("chests")
	if not _changed(d) and not force: return
	_clear()
	_p("小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。", 14)
	for c in d:
		var k = J.str(c.k); var n = int(J.num(c.n))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
		var ic = ChestIcon.new(); ic.k = k; ic.custom_minimum_size = Vector2(46, 38); ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(ic)
		var r = UIKit.rich("[b]%s ×%d[/b]\n[font_size=12]%s[/font_size]" % [J.str(c.name), n, J.str(c.d)], 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
		hb.add_child(_btn("開 1", "gold", n > 0, func(): jn("chestOpen", [k, false]); _render_chest(true), true))
		hb.add_child(_btn("全開", "", n > 1, func(): jn("chestOpen", [k, true]); _render_chest(true), true))
		_body().add_child(hb); _body().add_child(UIKit.hsep())

# ---------------- 新鬼圖鑑（含野鬼出沒挑戰入口）----------------
static func open_codex() -> void:
	var d = jn("codex")
	_begin("新鬼圖鑑", "codex", func(): pass)
	_clear()
	_p("新鬼圖鑑：已收服 %d/%d。未收服的會寫低喺邊度出沒。" % [int(J.num(d.got)), int(J.num(d.total))], 14)
	if not J.t(d.wild): _p("[color=#9c2219]打完第一章，各處開始有野鬼出沒，打贏就可以收服。[/color]", 13)
	for site in d.sites:
		var h = UIKit.label(J.str(site.name), 16, UIKit.CINNABAR2, "serif", 900); _body().add_child(h)
		for g in site.list:
			var own = J.t(g.own); var k = J.str(g.k)
			var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8)
			var po = _por(k, 52); if not own: po.get_child(0).modulate = Color(0.15, 0.15, 0.15)
			po.size_flags_vertical = Control.SIZE_SHRINK_BEGIN; hb.add_child(po)
			var r = _rich("[font_size=15][b]%s[/b][/font_size] %s\n[color=#6e5838]%s[/color]\n%s" % [J.str(g.name) + ("" if own else "（未收服）"), J.str(g.title), bb(g.lore), J.str(g.skill)], 12.5, UIKit.INKDIM)
			r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
			if J.t(g.fight):
				var lvok = J.t(g.lvOk)
				var fb = _btn("再戰" if own else ("收服" if lvok else "Lv%d" % int(J.num(g.req))), "" if own else "gold", lvok, func(): close_hook(); J.mc(J.G.get("N30W"), "fight", [k]), true)
				fb.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(fb)
			_body().add_child(hb); _body().add_child(UIKit.hsep())
	var bk = _btn("返回名冊", "", true, func(): open_roster()); bk.custom_minimum_size = Vector2(0, 40); _body().add_child(bk)

# ---------------- 劇情回顧／設定 ----------------
static func _wide(text: String, kind: String, enabled: bool, f: Callable) -> Button:
	var b = _btn(text, kind, enabled, f); b.custom_minimum_size = Vector2(0, 40); _body().add_child(b); return b
static func _h4(t: String) -> void:
	_body().add_child(UIKit.label(t, 16, UIKit.CINNABAR2, "serif", 900))
static func _sa(a: String, x = null): return J.mc(J.gp(J.G.get("UI"), "_n"), "_storyAct", [a, x])

static func open_story() -> void:
	var d = J.mc(J.gp(J.G.get("UI"), "_n"), "_story", [])
	var m = main()
	_begin("劇情", "story", func(): pass)
	_clear()
	_p("看過的劇情，可以在這裡重溫。", 14)
	for e in d.scenes:
		var i = int(J.num(e.i)); var ok = J.t(e.ok)
		_wide(J.str(e.name) if ok else "？？？", "" if ok else "ghost", ok, func(): close_hook(); _sa("scene", i))
	_h4("開麥之夜・陰間脫口秀"); _p("村裡的鬼，入了村就能上台。", 13)
	for e in d.standup:
		var i = int(J.num(e.i)); var ok = J.t(e.ok)
		_wide(("%s　%s" % [J.str(e.who), J.str(e.title)]) if ok else "？？？（%s）" % J.str(e.hint), "" if ok else "ghost", ok, func(): close_hook(); _sa("stand", i))
	var bo = d.get("bonds")
	if bo != null:
		_h4("收服劇情・冤家"); _p("收服名鬼後會上演入村劇情；有些鬼天生不和，日後會吵起來（%d/%d）。" % [bo.fds.size(), int(J.num(bo.total))], 13)
		for r in bo.rec:
			var k = J.str(r.k); _wide("%s入村" % J.str(r.name), "", true, func(): close_hook(); _sa("brec", k))
		for f in bo.fds:
			var id = J.str(f.id); _wide("冤家：%s（%s）" % [J.str(f.title), J.str(f.end)], "", true, func(): close_hook(); _sa("bfeud", id))
		if bo.rec.size() + bo.fds.size() == 0: _p("還沒有。去收服幾隻名鬼吧。", 13)
	var sk = d.get("skits")
	if sk != null:
		_h4("陰間日常"); _p("在村子裡玩，偶爾會上演一段。看過的可以在這裡重溫（%d/%d）。" % [sk.list.size(), int(J.num(sk.total))], 13)
		for e in sk.list:
			var id = J.str(e.id); _wide(J.str(e.title), "", true, func(): close_hook(); _sa("skit", id))
		if sk.list.size() == 0: _p("還沒看過。在村子裡多玩一會兒。", 13)
	var qx = Engine.get_main_loop().root.get_node_or_null("QX")   # [bryan] 記仇簿收集品
	if qx != null and qx.has_method("diary_pages"):
		var pg: Array = qx.call("diary_pages")
		_h4("Bryan 的感恩日記"); _p("Bryan 那本皮面本子，見到一頁收一頁（%d/%d）。" % [pg.size(), int(qx.call("diary_total"))], 13)
		for e in pg:
			var id = str(e.id); var n = int(e.n)
			_wide(("最後一頁" if id == "c7_bryanbook" else "第 %d 頁" % n), "", true, func(): close_hook(); qx.call("diary_show", id))
		if pg.size() == 0: _p("還沒有。Bryan 遲早會出現的。", 13)
	var su = d.get("su")
	if su != null:
		_h4("冥街夜市・棟篤笑"); _p("在冥街夜市看過的節目，可以在這裡重溫。", 13)
		for e in su:
			var id = J.str(e.id); var ok = J.t(e.seen)
			_wide(("%s　%s" % [J.str(e.who), J.str(e.title)]) if ok else "？？？（%s）" % J.str(e.hint), "" if ok else "ghost", ok, func(): close_hook(); _sa("su", id))
	_body().add_child(UIKit.hsep())
	_wide("看手機", "", true, func(): close_hook(); _sa("phone"))
	_wide("改名（現在叫：%s）" % str(DB.hero().get("name", "")), "", true, func():   # [name] 開新檔名打錯／被預設蓋咗都可以改返
		close_hook()
		var nc = load("res://ui/name_card.gd").new(); nc.rename_only = true
		nc.on_done = func(): m.show_toast("已改名：" + str(DB.hero().get("name", "")))
		m.add_child(nc))
	var setb = _wide("設置（聲音、畫面、劇情、存檔）", "gold", true, func(): close_hook(); m.open_settings(false, true))   # [settings] 聲音、語言、存檔碼、畫面等搬入設置面板
	setb.name = "OpenSettings"
	var rs = d.get("restore")
	if rs != null:
		var k = J.str(rs.k)
		var rb = _confirm_btn("恢復備份存檔（主公 %d 級）" % int(J.num(rs.lv)), "gold", "再按一次確定恢復", func():
			var v = J.str(_sa("restore", k))
			if JSRun.ls.has(SAVE_KEY): JSRun.ls[SAVE_KEY + "_bak"] = JSRun.ls[SAVE_KEY]
			JSRun.ls[SAVE_KEY] = v; JSRun.flush_ls(); JSRun.skip_title = true; JSRun.reset_world(); m.get_tree().call_deferred("reload_current_scene"), false)
		rb.custom_minimum_size = Vector2(0, 40); _body().add_child(rb)
	_p("[font_size=11]Godot 版 %s[/font_size]" % ProjectSettings.get_setting("application/config/version", "dev"), 11)

# ---------------- 合約與存在感 ----------------
# 陰間運動會：揀項目（資料由 Sports._n.panel()，撳參賽 Sports._n.go(id)）
static func open_sports() -> void:
	_begin("陰間運動會", "sports", func(): _render_sports(false))
	_render_sports(true)

static func _render_sports(force: bool) -> void:
	if cur != "sports": return
	var d = J.mc(J.gp(J.G.get("Sports"), "_n"), "panel", [])
	if not _changed(d) and not force: return
	_keep_scroll(func(): _draw_sports(d))

static func _draw_sports(d) -> void:
	_clear()
	_p(J.str(DB.L("陰間運動會：靠鬼自己的怪癖比賽。每項每日第一次贏過 Bryan 的紀錄，出賽的鬼存在感 +12、全村 +3、合約 KPI +2、冥幣 60。")), 13)
	for e in d.list:
		var won = J.t(e.won)
		var card = PanelContainer.new()
		card.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 1, 1, 0.35), 10, Color(0, 0, 0, 0), 0, Vector4(8, 8, 8, 8)))
		if won: card.modulate.a = 0.85
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); card.add_child(hb)
		var por = _por(J.str(e.k), 52); por.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(por)
		var who = J.str(e.who) + ("（替補）" if J.t(e.sub) else "")
		var best = ("你的最佳：" + J.str(e.best)) if e.get("best") != null else "未參賽"
		var tx = "[font_size=15][b]%s[/b][/font_size]\n[font_size=12]%s\n%s%s[/font_size]" % [J.str(DB.L(J.str(e.name))), J.str(DB.L("出賽：" + who + "　" + J.str(e.goal))), J.str(DB.L(best)),
			("　[color=#3a7a2a][b]" + J.str(DB.L("今日已贏")) + "[/b][/color]") if won else ""]
		var r = _rich(tx, 12, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; r.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(r)
		var id = J.str(e.id)
		var b = _btn(J.str(DB.L("再玩" if won else "參賽")), "" if won else "gold", true, func(): J.mc(J.gp(J.G.get("Sports"), "_n"), "go", [id]), true)
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(b)
		_body().add_child(card)
		var gap = Control.new(); gap.custom_minimum_size.y = 4; _body().add_child(gap)

static func open_pres() -> void:
	_begin("合約與存在感", "pres", func(): _render_pres(false))
	_render_pres(true)

static func _render_pres(force: bool) -> void:
	if cur != "pres": return
	var d = J.mc(J.gp(J.G.get("Presence"), "_n"), "panel", [])
	if not _changed(d) and not force: return
	_keep_scroll(func(): _draw_pres(d))

static func _draw_pres(d) -> void:
	_clear()
	var st = J.str(d.state)
	if st == "none": _p("打完第一章後，龐總會來跟你簽試用期合約。", 14)
	else:
		_p("職級：[b]%s[/b]%s" % [J.str(d.rank), "（年度考核）" if J.t(d.top) else ""], 14)
		if st == "active":
			var kpi = J.num(d.kpi); var tg = maxf(1, J.num(d.target))
			_p("KPI %d／%d" % [int(kpi), int(J.num(d.target))], 14)
			var bar = ProgressBar.new(); bar.max_value = 1; bar.value = minf(1, kpi / tg); bar.show_percentage = false; bar.custom_minimum_size = Vector2(0, 10)
			bar.add_theme_stylebox_override("background", UIKit.sb(Color(0, 0, 0, 0.18), 5)); bar.add_theme_stylebox_override("fill", UIKit.sb(Color("#d9a441"), 5)); _body().add_child(bar)
			_p("剩下 [b]%.1f[/b] 日" % J.num(d.left), 14)
		else: _p("[color=#c0392b][b]淡化危機[/b]：%.1f 日內回陽間完成一晚（一星或以上），阿福就會被記起。不會遊戲結束。[/color]" % J.num(d.crisis), 14)
		var nx = d.get("next")
		_p(("下一級：[b]%s[/b]　解鎖：%s" % [J.str(nx.name), J.str(nx.unlock)]) if nx != null else "已經是最高職級。每期過關有花紅。", 14)
		_p("KPI 怎樣算：每晚回陽間，每顆星 10 分；傳說熱度每級 5 分（最多 25）；有驚嚇值 5 分；被道士請走扣 5 分。另外陽間地盤每日收租（每 3 個地盤 +1），奪回被搶的地盤 +4。", 13)
	_h4("村裡的存在感")
	_p("鬼要有人記得才存在。每天自然流失 %s；回陽間一晚全村 +%d～%d，出動的鬼更多。上台講棟篤笑、打贏仗、在陰間日常出場也有少少。" % [J.str(d.decay), int(J.num(d.ripple)), int(J.num(d.rippleMax))], 13)
	if d.get("grace") != null: _p("新功能保護期：還有 %s 日不會流失。" % J.str(d.grace), 13)
	_p("上供品：用 %d 個壽包替一隻鬼上供，存在感 +%d（每隻鬼每日一次）。壽包 %s" % [int(J.num(d.offer.buns)), int(J.num(d.offer.add)), J.str(d.buns)], 13)
	var fade = J.num(d.fade); var warn = J.num(d.warn)
	for g in d.list:
		var v = J.num(g.v); var nb = clampi(int(round(v / 10.0)), 0, 10)
		var col = "#6ec27a" if v > fade else ("#e0b44a" if v > warn else "#e0604a")
		var badge = ""
		if g.get("days") != null: badge = "　[color=#c0392b][b]魂飛魄散倒數 %d 日[/b][/color]" % int(J.num(g.days))
		elif v <= warn: badge = "　[color=#c0392b][b]⚠ 存在感不足[/b][/color]"
		elif v < fade: badge = "　[color=#9a7a3a]變淡中[/color]"
		var txt = "%s\n[font_size=12]%d [color=%s]%s[/color][color=#00000030]%s[/color]%s[/font_size]" % [J.str(g.name), int(v), col, "▮".repeat(nb), "▮".repeat(10 - nb), badge]
		var bs = []
		if J.t(g.canOffer):
			var id = J.str(g.id); var done = J.t(g.done)
			bs.append(_btn("已上供" if done else "上供", "" if done else "gold", not done, func(): J.mc(J.gp(J.G.get("Presence"), "_n"), "offer", [id]); _render_pres(true), true))
		_row(txt, bs)

# 箱仔圖示（對應 style.css .chest .cb）
class ChestIcon extends Control:
	var k := "g"
	func _draw() -> void:
		var c = {"g": [Color("#5fa070"), Color("#2e6040")], "b": [Color("#5a86b8"), Color("#2a4a78")], "p": [Color("#9a6ab8"), Color("#5a2e7a")]}[k]
		var w = size.x; var h = size.y
		draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(w, 0), Vector2(w, h), Vector2(0, h)]), PackedColorArray([c[0], c[0], c[1], c[1]]))
		draw_rect(Rect2(1, 1, w - 2, h - 2), Color("#1a120a"), false, 2)
		draw_rect(Rect2(2, h * 0.38, w - 4, 5), Color(0, 0, 0, 0.35))
		draw_rect(Rect2(w / 2 - 4.5, h * 0.3, 9, 12), Color("#e0b44a")); draw_rect(Rect2(w / 2 - 4.5, h * 0.3, 9, 12), Color("#5a3a08"), false, 1)

# 測試：逐個動作計時（ms），並驗證狀態有變
static func t_bench(_x = null) -> void:
	var S = J.G.get("S")
	var t0 = Time.get_ticks_usec(); open_roster(); var t_ro = (Time.get_ticks_usec() - t0) / 1000.0
	var g = null
	for x in S.ghosts: if J.str(x.k) != "afu" and J.str(x.q) == "名": g = x; break
	var lv0 = J.num(g.lv); var b0 = J.num(S.res.buns)
	t0 = Time.get_ticks_usec(); jn("rosterAct", ["up", J.str(g.id)]); _render_roster(false); var t_up = (Time.get_ticks_usec() - t0) / 1000.0
	print("TB roster open=%.1fms up=%.1fms lv %d->%d buns %d->%d" % [t_ro, t_up, lv0, J.num(g.lv), b0, J.num(S.res.buns)])
	var c0 = J.num(S.chests.g); var bb0 = J.num(S.res.buns)
	open_chest(); t0 = Time.get_ticks_usec(); jn("chestOpen", ["g", false]); _render_chest(true); var t_ch = (Time.get_ticks_usec() - t0) / 1000.0
	print("TB chest=%.1fms g %d->%d buns %d->%d" % [t_ch, c0, J.num(S.chests.g), bb0, J.num(S.res.buns)])
	var hl = J.num(S.bld.house)
	t0 = Time.get_ticks_usec(); open_bld("house"); var t_b = (Time.get_ticks_usec() - t0) / 1000.0
	t0 = Time.get_ticks_usec(); _act_bld("house", "up"); var t_bu = (Time.get_ticks_usec() - t0) / 1000.0
	print("TB bld open=%.1fms up=%.1fms house %d->%d" % [t_b, t_bu, hl, J.num(S.bld.house)])
	var w0 = 0
	for x in S.ghosts: if J.str(x.get("post")) == "bun": w0 += 1
	t0 = Time.get_ticks_usec(); open_pick("bun", "bun"); var t_p = (Time.get_ticks_usec() - t0) / 1000.0
	var d = jn("pick", ["bun"]); var gid = J.str(d.list[0].id)
	t0 = Time.get_ticks_usec(); jn("pickDo", ["bun", gid]); open_bld("bun"); var t_pd = (Time.get_ticks_usec() - t0) / 1000.0
	var w1 = 0
	for x in S.ghosts: if J.str(x.get("post")) == "bun": w1 += 1
	print("TB pick open=%.1fms assign=%.1fms bun workers %d->%d" % [t_p, t_pd, w0, w1])
static func t_prof(_x = null) -> void:
	var t0 = Time.get_ticks_usec(); var d = jn("roster"); var t1 = Time.get_ticks_usec()
	open_roster(); var t2 = Time.get_ticks_usec()
	print("TP roster data=%.1fms total=%.1fms n=%d" % [(t1 - t0) / 1000.0, (t2 - t1) / 1000.0, d.list.size()])
	for k in ["gp", "chat", "pres", "bond"]:
		pass
static func t_prof2(_x = null) -> void:
	var d = jn("roster"); var t0 = Time.get_ticks_usec()
	for g in d.list: var p = _por(J.str(g.k), 60); p.free()
	var t1 = Time.get_ticks_usec()
	for g in d.list: var r = _rich("[b]%s[/b]\\n%s\\n%s" % [J.str(g.name), J.str(g.skd), bb(g.trait)], 12.5); r.free()
	var t2 = Time.get_ticks_usec()
	for g in d.list: var r = _rich("[b]%s[/b]\\n%s\\n%s" % [J.str(g.name), J.str(g.skd), bb(g.trait)], 12.5); _body().add_child(r)
	var t3 = Time.get_ticks_usec()
	for i in 7: var b = _btn("升級\\n壽包 1", "gold", true, func(): pass, true); b.free()
	var t4 = Time.get_ticks_usec()
	print("TP2 por=%.1f rich=%.1f richadd=%.1f btn=%.1f" % [(t1 - t0) / 1000.0, (t2 - t1) / 1000.0, (t3 - t2) / 1000.0, (t4 - t3) / 1000.0])
# 撳掣到畫面出齊（包埋下一格排版同繪畫）：原生 vs 舊 DOM
static func t_cmp(tester = null) -> void:
	var tree = Engine.get_main_loop()
	for mode in ["native", "dom", "native", "dom"]:
		var keep = J.G.get("__nat_menu")
		if mode == "dom": J.G.erase("__nat_menu")
		for kind in [["openRoster"], ["openChests"], ["openBuilding", "bun"]]:
			J.mc(J.G.get("UI"), "close", []); await tree.process_frame; await tree.process_frame
			var t0 = Time.get_ticks_usec()
			J.mc(J.G.get("UI"), kind[0], kind.slice(1))
			await tree.process_frame; await tree.process_frame
			print("TC %s %s %.1fms" % [mode, kind[0], (Time.get_ticks_usec() - t0) / 1000.0])
		J.G["__nat_menu"] = keep
static func t_ops2(_x = null) -> void:
	var S = J.G.get("S"); var m = main()
	print("T2 village paused=", m.village.process_mode == Node.PROCESS_MODE_DISABLED, " sheet=", m.sheet.visible)
	var d = J.mc(J.gp(J.G.get("Presence"), "_n"), "panel", [])
	var b0 = J.num(S.res.buns)
	for g in d.list:
		if J.t(g.canOffer) and not J.t(g.done):
			var t0 = Time.get_ticks_usec(); J.mc(J.gp(J.G.get("Presence"), "_n"), "offer", [J.str(g.id)]); _render_pres(true)
			print("T2 offer %s %.1fms buns %d->%d" % [J.str(g.name), (Time.get_ticks_usec() - t0) / 1000.0, b0, J.num(S.res.buns)]); break
	for k in ["codex", "story", "pres"]:
		var t1 = Time.get_ticks_usec(); hook([k]); print("T2 open %s %.1fms" % [k, (Time.get_ticks_usec() - t1) / 1000.0])
	var on0 = J.t(_sa("snd")); var on1 = J.t(_sa("snd")); print("T2 snd toggle ", on0, "->", on1)
	print("T2 export len=", J.str(_sa("export")).length())
