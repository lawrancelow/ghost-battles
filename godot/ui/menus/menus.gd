# 線路 H：村子面板原生化（建築、派人、名冊、箱子）
# 資料同規則全部經 JS（UI._n.*：同原本 game.js click handler 一模一樣），呢度只負責畫介面同收撳掣。
# 原生做唔到（例如新鬼圖鑑、劇情回顧）就照用 DOM。
class_name Menus
extends RefCounted

static var cur := ""          # 而家開緊邊個面板："bld:<id>" / "pick:<post>" / "roster" / "chest"
static var arg_a := ""
static var arg_b := ""
static var sig := ""          # 上次畫嘅資料簽名：冇變就唔重畫（唔使每 0.5 秒成個面板重砌）

static func main() -> Control: return Engine.get_main_loop().root.get_node_or_null("Main")
static func N(): return J.gp(J.G.get("UI"), "_n")
static func jn(m: String, a := []): return J.mc(N(), m, a)
static func T(yue: String, zh: String) -> String: return zh if DB.lang != "yue" else yue

static func hook(a: Array) -> bool:
	var m = main()
	if m == null or N() == null: return false
	var kind = J.str(a[0])
	match kind:
		"bld": open_bld(J.str(a[1]))
		"pick": open_pick(J.str(a[1]), J.str(a[2]) if a.size() > 2 else "")
		"roster": open_roster()
		"chest": open_chest()
		_: return false
	return true

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
	var r = UIKit.rich(bb, size, col, kind); _body().add_child(r); return r

static func _row(text_bb: String, buttons: Array, parent: Control = null) -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
	var r = UIKit.rich(text_bb, 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
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
	r.text = text; return r

static func bb(h) -> String: return JSBridge.html2bb(J.str(h)).replace("[color=#ff8a7a]", "[color=#c2362b]")

static func _keep_scroll(f: Callable) -> void:
	var m = main(); var sc = m.sheet_scroll.scroll_vertical
	f.call()
	m.sheet_scroll.set_deferred("scroll_vertical", sc)

static func _changed(data) -> bool:
	var s = JSON.stringify(data)
	if s == sig: return false
	sig = s; return true

static func _por(k: String, size := 56, alpha := 1.0) -> Control:
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
		else: _row("建造費用：" + bb(d.cost), [_btn("建造", "gold", J.t(d.canBuild), func(): _act_bld(id, "build"))])
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
	var fu = d.get("furnace")
	if fu != null:
		var left = J.num(fu.left)
		_row(("還要 %d 分鐘" % int(ceil(left / 60)) if left > 0 else "爐火正旺！") + "　可燒出 冥幣 %d" % int(J.num(fu.coins)), [_btn("燒", "gold", left <= 0, func(): _act_bld(id, "burn"))])
	var al = d.get("altar")
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
		_row("盂蘭宴：壽包 300\n[font_size=12]全村智力總和 %d/%d%s[/font_size]" % [int(J.num(fe.iq)), int(J.num(fe.need)), "　冷卻 %d 分" % int(ceil(left2 / 60)) if left2 > 0 else ""], [_btn("擺宴", "gold", J.t(fe.can), func(): _act_bld(id, "feast"))])
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
		var r = UIKit.rich("[b]%s[/b] %s　[color=#9c2219][b]%s[/b][/color]%s　%s\n[font_size=12]%s%s[/font_size]" % [J.str(g.name), _qtag(J.str(g.q)), keytxt, ("　Lv%d" % int(J.num(g.lv))) if stn != "等級" else "", J.str(g.other), ("目前：" + J.str(g.where)) if J.str(g.where) != "閒著" else "閒著", "　[color=#c2362b]怕糯米，不肯去[/color]" if fb else ""], 14, UIKit.INKTXT)
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
	return "用壽包升級鬼怪。等級上限 %d。雜鬼名額 %d/%d　壽包 %s" % [int(J.num(d.cap)), int(J.num(d.fcnt)), int(J.num(d.rcap)), J.str(d.buns)]

static func _draw_roster(d) -> void:
	_clear(); r_cards.clear()
	r_head = _p(_roster_head(d), 14)
	_p(T("鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：喺村升級、落訓練班練嚇功，出面即刻勁啲。出面打唔過，就返嚟升級。", "鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：在村裡升級、去訓練班練嚇功，外面立即變強。外面打不過，就回來升級。"), 12.5, Color("#7a4a2a"))
	if d.get("codex") != null:
		var cb = _btn("新鬼圖鑑（%s）" % J.str(d.codex), "", true, func(): close_hook(); J.mc(J.G.get("N30W"), "openCodex", []))
		cb.custom_minimum_size = Vector2(0, 40); _body().add_child(cb)
	for g in d.list: r_cards[J.str(g.id)] = [JSON.stringify(g), _gcard(g)]

static func _gcard(g) -> Control:
	var card = PanelContainer.new()
	var st = UIKit.sb(Color(0, 0, 0, 0.05), 8, Color("#d9b440") if J.t(g.gold) else Color(UIKit.PAPERLINE, 0.6), 2 if J.t(g.gold) else 1, Vector4(8, 8, 8, 8))
	card.add_theme_stylebox_override("panel", st)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); card.add_child(hb)
	var po = _por(J.str(g.k), 60, J.num(g.alpha) if g.get("alpha") != null else 1.0); po.size_flags_vertical = Control.SIZE_SHRINK_BEGIN; hb.add_child(po)
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
		var ub = _btn("升級\n壽包 %d" % int(J.num(g.cost)), "gold", J.t(g.canUp), func(): jn("rosterAct", ["up", gid]); _render_roster(false), true)
		ub.custom_minimum_size = Vector2(76, 46); act.add_child(ub)
	else: act.add_child(UIKit.label("已達上限", 11, UIKit.INKDIM))
	if J.t(g.canRel):
		var rb = _confirm_btn("送去投胎", "ghost", "確定？", func(): jn("rosterAct", ["rel", gid]); _render_roster(false))
		rb.custom_minimum_size = Vector2(76, 30); act.add_child(rb)
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
