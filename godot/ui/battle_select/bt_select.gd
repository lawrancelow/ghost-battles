# 主線戰鬥：選關、佈陣（battle.js openSelect／pickSlot）原生化
#  資料、規則照用 JS（Battle.stageOpen／tryStart、GP、Rework、N30W），呢度只畫介面同收撳掣；互換、儲存同 JS 嗰段 click handler 一樣
#  野鬼出沒、地盤入口等 HTML 片段就轉做 BBCode 文字＋原生掣
class_name BtSelect
extends RefCounted

static var _scroll := 0.0

static func main() -> Control: return Engine.get_main_loop().root.get_node_or_null("Main")
static func js(n: String): return J.G.get(n)
static func L(s) -> String: return J.str(DB.L(J.str(s)))
static func S(): return js("S")
static func bb(h) -> String: return JSBridge.html2bb(J.str(h)).replace("[color=#ff8a7a]", "[color=#c2362b]")

static func hook(a: Array) -> bool:
	var m = main()
	if m == null or not m.has_method("open_sheet"): return false
	match J.str(a[0]):
		"select": open_select(); return true
		"pick": open_pick(J.str(a[1]) if a.size() > 1 else "0"); return true
	return false

static func _body() -> VBoxContainer: return main().sheet_body
static func _clear() -> void:
	var b = _body()
	for c in b.get_children(): b.remove_child(c); c.queue_free()
static func _rich(t: String, size := 13.0, col := UIKit.INKDIM) -> RichTextLabel:
	var r = UIKit.rich(t, size, col); r.fit_content = true; r.scroll_active = false; return r
static func _btn(t: String, gold: bool, enabled: bool, f: Callable) -> Button:
	var b = UIKit.btn(t, "gold" if gold else "", true); b.disabled = not enabled; b.pressed.connect(f); return b

static func ghost(id):
	if id == null or J.str(id) == "": return null
	return J.cl(js("ghostById"), null, [id])
static func gp_pow(g) -> int: return int(J.num(J.mc(js("GP"), "pow", [g])))
static func glv(g) -> int: return int(J.num(J.mc(js("F"), "glv", [g])))
static func stat(g, i: int) -> int: return int(J.num(J.mc(js("F"), "stat", [g, i])))

# ---------------- 選關 ----------------
static func open_select() -> void:
	main().open_sheet(L("陽間地盤"), func(): pass)
	_render_select()
	# 自動捲到目前主線關卡
	await Engine.get_main_loop().process_frame
	var sc = _body().get_parent()
	if sc is ScrollContainer and _scroll > 0: sc.scroll_vertical = int(_scroll)

static func _render_select() -> void:
	_clear()
	var Sx = S(); var B = js("Battle"); var GP = js("GP"); var RW = js("Rework")
	var b = _body()
	# 出陣三格＋軍師
	var team = HBoxContainer.new(); team.add_theme_constant_override("separation", 6); b.add_child(team)
	var tg = []
	for i in 3:
		var g = ghost(Sx.team[i]); tg.append(g)
		var sub = ("Lv%d・%s%d" % [glv(g), L("鬼力"), gp_pow(g)]) if g != null else ""
		team.add_child(_slot(g, J.str(g.name) if g != null else "＋\n" + L("出陣"), sub, str(i), false))
	var ad = ghost(Sx.get("adviser"))
	team.add_child(_slot(ad, J.str(ad.name) if ad != null else "＋\n" + L("軍師"), L("軍師") if ad != null else "", "adv", true))
	var myGP = int(J.num(J.mc(GP, "avg", [tg])))
	var bonus = round(stat(ad, 1) / 8.0) if ad != null else 0
	b.add_child(_rich(L("軍師不上場，坐鎮後方：全隊攻擊 +%d%%（看智力），能量滿了也能放技能。出征前可隨時換人。") % bonus))
	b.add_child(_rich("%s [b]%d[/b]　[font_size=11]%s[/font_size]" % [L("出陣平均"), myGP, L("每關都有「建議鬼力」，紅字＝未夠，返村升級或者練嚇功先。")]))
	var troops = int(J.num(Sx.res.troops)); var hasHome = J.t(J.gp(Sx.bld, "home"))
	b.add_child(_rich("[b]%s[/b]　%s %d，%s [b]%d[/b] %s\n[font_size=11]%s[/font_size]" % [L("帶上陣的陰兵"), L("現有"), troops, L("可組成"), mini(8, troops / 25), L("隊（每 25 個一隊，最多 8 隊）"),
		L("村裡的遊魂見你有地盤，會自願當陰兵（民宅越高級來得越快）。戰死的會扣掉。") if hasHome else L("建好民宅，遊魂才會來投靠當陰兵。")], 13, UIKit.INKTXT))
	# 其他入口
	if J.t(J.gp(Sx.seen, "ch1_end")):
		var best = int(J.num(J.gp(J.gp(Sx.get("scare"), "best"), "office")))
		b.add_child(_entry(L("回陽間・夜班嚇人"), "%s %d" % [L("舊公司・二十三樓　最高"), best], L("回去"), func(): main().close_sheet(); J.mc(js("Scare"), "open", ["office"])))
		if js("Sports") != null: b.add_child(_entry(L("陰間運動會"), L("殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳"), L("參加"), func(): main().close_sheet(); J.mc(js("Sports"), "open", [])))
	# 章節
	var first_gold = -1.0
	var CH = js("CHAPTERS")
	for ci in CH.size():
		var ch = CH[ci]
		var head = UIKit.label(L("第%s章・") % "一二三四五六".substr(ci, 1) + L(ch.name), 15, UIKit.INKTXT, "serif", 900); b.add_child(head)
		for si in ch.stages.size():
			var st = ch.stages[si]; var sid = J.str(J.mc(B, "sidOf", [ci, si])); var open = J.t(J.mc(B, "stageOpen", [ci, si]))
			var done = J.t(J.gp(Sx.cleared, sid)); var lvOk = J.num(Sx.lv) >= J.num(st.req); var lost = J.t(J.mc(RW, "isLost", [sid]))
			var need = int(J.num(J.mc(GP, "stageNeed", [st, sid])))
			var txt = "[b]%s　%s[/b]" % [sid, L(st.name)]
			if open:
				txt += "\n[font_size=11]%s Lv%d　[color=%s]%s %d[/color]　%s[/font_size]" % [L("需主公"), int(J.num(st.req)), "#c2362b" if myGP < need else "#2e6d5a", L("建議鬼力"), need, bb(J.mc(RW, "turfTag", [sid]))]
				var eh = bb(J.mc(RW, "enemyHint", [st.en]))
				if eh != "": txt += "\n[font_size=11]%s[/font_size]" % eh
			else: txt += "\n[font_size=11]%s[/font_size]" % L("先打通上一關")
			if done: txt += "　✓"
			var btns = []
			if open:
				var gold = not done or lost
				var label = (L("奪回") if lost else L("巡場")) if done else (L("搶地盤") if lvOk else "Lv%d" % int(J.num(st.req)))
				var cc = ci; var ss = si
				btns.append(_btn(label, gold, lvOk, func(): _scroll = _body().get_parent().scroll_vertical if _body().get_parent() is ScrollContainer else 0.0; J.mc(B, "tryStart", [cc, ss])))
				if gold and first_gold < 0: first_gold = b.get_child_count() * 64.0
			else: btns.append(UIKit.label("🔒", 14))
			b.add_child(_row(txt, btns, J.t(st.get("boss"))))
	# 野鬼出沒
	var N30W = js("N30W")
	if N30W != null: _wild(b, N30W)
	if _scroll <= 0 and first_gold > 0: _scroll = maxf(0, first_gold - 200)

static func _slot(g, name: String, sub: String, slot: String, adv: bool) -> Control:
	var p = PanelContainer.new(); p.size_flags_horizontal = Control.SIZE_EXPAND_FILL; p.custom_minimum_size = Vector2(0, 104)
	p.add_theme_stylebox_override("panel", UIKit.sb(Color("#e9e1cc") if not adv else Color("#d8e0c0"), 4, Color("#a08a5a") if not adv else Color("#5a7a5a"), 1, Vector4(4, 6, 4, 6)))
	var vb = VBoxContainer.new(); vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_theme_constant_override("separation", 1); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(vb)
	if g != null:
		var pr = UIKit.portrait(J.str(g.k), 46); pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(pr)
	var nl = UIKit.label(name, 13, UIKit.INKTXT, "serif", 900); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nl.mouse_filter = Control.MOUSE_FILTER_IGNORE; nl.clip_text = true; vb.add_child(nl)
	if sub != "": var sl = UIKit.label(sub, 10, UIKit.INKDIM); sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sl.mouse_filter = Control.MOUSE_FILTER_IGNORE; sl.clip_text = true; vb.add_child(sl)
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	p.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT: Snd.play("click"); open_pick(slot))
	return p

static func _row(txt: String, btns: Array, boss := false) -> Control:
	var p = PanelContainer.new()
	p.add_theme_stylebox_override("panel", UIKit.sb(Color(0.6, 0.15, 0.1, 0.06) if boss else Color(0, 0, 0, 0.03), 3, Color(0.4, 0.3, 0.2, 0.25), 1, Vector4(8, 6, 8, 6)))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); p.add_child(hb)
	var r = _rich(txt, 13, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
	for x in btns: x.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(x)
	return p

static func _entry(title: String, sub: String, btn: String, f: Callable) -> Control:
	return _row("[b]%s[/b]\n[font_size=11]%s[/font_size]" % [title, sub], [_btn(btn, true, true, f)])

static func _wild(b: VBoxContainer, W) -> void:
	var Sx = S()
	if not J.t(J.gp(Sx.cleared, "1-3")):
		b.add_child(UIKit.label(L("野鬼出沒"), 15, UIKit.INKTXT, "serif", 900)); b.add_child(_rich(L("打完第一章，各處開始有野鬼出沒，打贏就可以收服。"))); return
	b.add_child(UIKit.label(L("野鬼出沒・打贏就收服"), 15, UIKit.INKTXT, "serif", 900))
	b.add_child(_rich(L("每隻野鬼第一次打贏就會跟你返村。已收服的可以再戰，賺冥幣。日本妖怪喺冥街夜市暗巷出沒。")))
	var SITES = js("N30_SITES"); var G = js("N30_G"); var TIER = js("N30_TIER"); var GH = js("GHOSTS")
	for sid in ["field", "road", "kampung", "banana", "death"]:
		var site = SITES.get(sid)
		if site == null: continue
		var ks = []
		if sid == "death": ks = J.mc(W, "roadToday", [])
		else:
			for k in J.mc(W, "ids", []): if J.str(J.gp(G.get(k), "at")) == sid: ks.append(k)
		var open = []
		for k in ks: if J.t(J.mc(W, "open", [k])): open.append(k)
		var locked = ks.size() - open.size()
		b.add_child(_rich("[b]%s[/b]　[font_size=11]%s%s[/font_size]" % [L(site.name), L(site.desc), ("　" + L("另有 %d 隻未出沒") % locked) if sid != "death" and locked > 0 else ""], 13, UIKit.INKTXT))
		for k in open:
			var g = G[k]; var T = TIER[int(J.num(g.t))]; var own = J.t(J.mc(W, "owned", [k])); var lvOk = J.num(Sx.lv) >= J.num(T.req)
			var txt = "[b]%s　%s[/b]\n[font_size=11]%s%s Lv%d　%s[/font_size]" % [["", "前", "中", "後"][int(J.num(g.t))], L(GH[k].name), (L("已收服") + "　") if own else "", L("需主公"), int(J.num(T.req)), L(GH[k].title)]
			if own: txt += "　✓"
			var kk = k
			b.add_child(_row(txt, [_btn(L("再戰") if own else (L("收服") if lvOk else "Lv%d" % int(J.num(T.req))), not own, lvOk, func(): J.mc(W, "fight", [kk]))], true))

# ---------------- 佈陣 ----------------
static func open_pick(slot: String) -> void:
	var Sx = S()
	main().open_sheet(L("佈陣"), func(): pass)
	_clear()
	var b = _body()
	var cur = Sx.get("adviser") if slot == "adv" else Sx.team[int(slot)]
	b.add_child(_rich(L("選擇%s。已在別的位置的，會互換。") % (L("軍師（看智力）") if slot == "adv" else L("出陣鬼怪"))))
	var list: Array = Sx.ghosts.duplicate()
	list.sort_custom(func(x, y): return glv(x) > glv(y))
	if cur != null and J.str(cur) != "": b.add_child(_gi(null, "", slot, false))
	for g in list:
		var where = L("出陣中") if Sx.team.has(g.id) else (L("軍師") if J.str(Sx.get("adviser")) == J.str(g.id) else "")
		b.add_child(_gi(g, where, slot, J.str(g.id) == J.str(cur)))
	var back = UIKit.btn(L("返回")); back.pressed.connect(func(): open_select()); b.add_child(back)
	await Engine.get_main_loop().process_frame
	var sc = _body().get_parent()
	if sc is ScrollContainer: sc.scroll_vertical = 0

static func _gi(g, where: String, slot: String, sel: bool) -> Control:
	var p = PanelContainer.new()
	p.add_theme_stylebox_override("panel", UIKit.sb(Color(0.95, 0.85, 0.5, 0.35) if sel else Color(0, 0, 0, 0.03), 4, Color("#c2362b") if sel else Color(0.4, 0.3, 0.2, 0.25), 2 if sel else 1, Vector4(8, 6, 8, 6)))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(hb)
	if g == null:
		hb.add_child(UIKit.label(L("— 空著 —"), 14, UIKit.INKTXT, "sans", 700))
	else:
		var pr = UIKit.portrait(J.str(g.k), 52); pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
		var sk = js("SKILLS").get(J.str(g.k), {}); var d = J.cl(js("gdef"), null, [g])
		var t = "[b]%s[/b] [color=#7a5a20]%s[/color] %s\n[font_size=11]Lv%d　[b]%s %d[/b]　%s%d %s%d %s%d　%s\n%s[/font_size]\n[font_size=11][color=#7a1a10]【%s】[/color]%s[/font_size]" % [
			J.str(g.name), J.str(g.q), ("[color=#2e6d5a]" + where + "[/color]") if where != "" else "", glv(g), L("鬼力"), gp_pow(g),
			L("力"), stat(g, 0), L("智"), stat(g, 1), L("武"), stat(g, 2), L("遠程") if J.str(J.gp(d, "range")) == "ranged" else L("近戰"),
			bb(J.mc(js("Rework"), "teamHint", [g])), L(J.gp(sk, "name")), L(J.gp(sk, "desc"))]
		var r = _rich(t, 13, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; r.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(r)
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	var gid = g.id if g != null else null
	p.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT: Snd.play("click"); _put(slot, gid))
	return p

# 同 battle.js pickSlot 嘅 click handler 一樣：已喺第二格就互換
static func _put(slot: String, id) -> void:
	var Sx = S()
	var cur = Sx.get("adviser") if slot == "adv" else Sx.team[int(slot)]
	var put = func(s: String, v):
		if s == "adv": Sx["adviser"] = v
		else: Sx.team[int(s)] = v
	if id != null:
		var idx = Sx.team.find(id)
		var from = str(idx) if idx >= 0 else ("adv" if J.str(Sx.get("adviser")) == J.str(id) else "")
		if from != "": put.call(from, cur if cur != null and J.str(cur) != "" else null)
	put.call(slot, id)
	J.cl(js("save"), null, [])
	open_select()

# 測試
static func t_open(i: int) -> void:
	match i:
		0: open_select()
		1: open_pick("0")
		2: open_pick("adv")
