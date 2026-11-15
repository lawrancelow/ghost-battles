# 回陽間・帶隊出更（scare_squad.js open）原生化
#  資料、規則照用 JS（ScareX.squad／legend／_n.owned／maxSq、Scare.starsOf／gpq、GP、Rework.KITS），呢度只畫介面同收撳掣
#  揀鬼、供品道具箱嘅開關同儲存，同 JS 嗰段 click handler 一模一樣
class_name ScSelect
extends RefCounted

static var _site := ""
static var _chosen: Array = []

static func main() -> Control: return Engine.get_main_loop().root.get_node_or_null("Main")
static func js(n: String): return J.G.get(n)
static func L(s) -> String: return J.str(DB.L(J.str(s)))
static func Lf(s, d: Dictionary) -> String:
	var r = L(s)
	for k in d: r = r.replace("{%s}" % k, str(d[k]))
	return r
static func _rich(t: String, size := 13.0, col := UIKit.INKDIM) -> RichTextLabel:
	var r = UIKit.rich(t, size, col); r.fit_content = true; r.scroll_active = false; return r

static func hook(site_id) -> bool:
	var m = main()
	if m == null or not m.has_method("open_sheet"): return false
	_site = J.str(site_id)
	J.mc(js("Scare"), "migrate", [])
	_chosen = []
	for k in J.mc(js("ScareX").squad, "get", []): _chosen.append(J.str(k))
	m.open_sheet(L("回陽間・帶隊出更"), func(): pass)
	_render()
	return true

static func _max() -> int: return int(J.num(J.cl(js("ScareX")._n.maxSq, null, [])))
static func _cn(n: int) -> String:
	var CN = js("ScareX")._n.get("CN")
	return J.str(CN[n]) if CN is Array and n < CN.size() else str(n)

static func _render() -> void:
	var m = main(); var b: VBoxContainer = m.sheet_body
	var keep = b.get_parent().scroll_vertical if b.get_parent() is ScrollContainer else 0
	for c in b.get_children(): b.remove_child(c); c.queue_free()
	var Sc = js("Scare"); var X = js("ScareX"); var S = js("S"); var FW = js("FEAR_WORD")
	var site = js("SCARE_SITES").get(_site)
	var npcs = []
	for d in site.npcs: if not J.t(d.get("guard")): npcs.append(d)
	var best = int(J.num(J.gp(J.gp(S.get("scare"), "best"), _site)))
	var st = int(J.num(J.mc(Sc, "starsOf", [_site, best])))
	var lg = J.cl(X.legend, null, [_site])
	b.add_child(_rich("%s。%s" % [L(site.name), Lf("揀今晚帶邊幾隻鬼：招式啱佢哋怕嘅嘢，先嚇得到人。阿福一定去，另外最多帶{n}隻。", {"n": _cn(_max())})], 13, UIKit.INKTXT))
	b.add_child(_rich("%s：%d　%s　｜　%s Lv%d「%s」" % [L("最高紀錄"), best, "★".repeat(st) + "☆".repeat(3 - st), L("都市傳說"), int(J.num(lg.lv)), L(lg.name)]))
	# 今晚嘅人怕乜
	var who = []
	var known = Sc.get("known") if Sc.get("known") is Dictionary else {}
	for d in npcs:
		var ws = []
		var kn = known.get(J.str(d.k))
		for t in d.weak:
			var hid = d.get("hide") is Array and d.hide.has(t) and not (kn != null and J.t(J.mc(kn, "has", [t])))
			ws.append("？" if hid else L(FW.get(t)))
		who.append("[b]%s[/b] %s %s" % [L(d.name), L("怕"), "、".join(ws)])
	var wb = PanelContainer.new(); wb.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.05), 4, Color(0.4, 0.3, 0.2, 0.25), 1, Vector4(8, 6, 8, 6)))
	wb.add_child(_rich("\n".join(who), 12, UIKit.INKTXT)); b.add_child(wb)
	# 鬼卡
	var grid = GridContainer.new(); grid.columns = 3; grid.add_theme_constant_override("h_separation", 6); grid.add_theme_constant_override("v_separation", 6); b.add_child(grid)
	grid.add_child(_card("afu", true, npcs))
	for k in J.cl(X._n.owned, null, []): grid.add_child(_card(J.str(k), false, npcs))
	var names = []
	for k in _chosen: names.append(L(js("SCARE_GHOSTS")[k].name))
	b.add_child(_rich("%s %d/%d：%s" % [L("已揀"), _chosen.size(), _max(), "、".join(names) if names.size() else "—"], 13, UIKit.INKTXT))
	# 供品／道具箱
	var RW = js("Rework")
	if RW != null and RW.get("KITS") is Dictionary:
		if not (S.get("scareKit") is Dictionary): S["scareKit"] = {}
		b.add_child(_rich("[b]%s[/b]（%s）：" % [L("帶上村裡的產出"), L("出發時扣")], 13, UIKit.INKTXT))
		var kr = HBoxContainer.new(); kr.add_theme_constant_override("separation", 6); b.add_child(kr)
		for k in RW.KITS: kr.add_child(_kit(k, RW.KITS[k]))
	var go = UIKit.btn(L("出發，回陽間"), "gold"); go.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	go.pressed.connect(_go)
	b.add_child(go)
	if keep > 0:
		await Engine.get_main_loop().process_frame
		if b.get_parent() is ScrollContainer: b.get_parent().scroll_vertical = keep

static func _go() -> void:
	J.mc(js("ScareX").squad, "set", [_chosen.duplicate()])
	main().close_sheet()
	var team = ["afu"]; team.append_array(J.mc(js("ScareX").squad, "get", []))
	J.mc(js("Scare"), "start", [_site, team])

static func _card(k: String, fixed: bool, npcs: Array) -> Control:
	var g = js("SCARE_GHOSTS")[k]; var FW = js("FEAR_WORD"); var Sc = js("Scare"); var GP = js("GP")
	var ts = g.types if g.get("types") is Array else [g.type]
	var w := 0; var im := true
	for t in ts:
		var wc = 0; var ic = 0
		for d in npcs:
			if d.weak.has(t): wc += 1
			if d.immune.has(t): ic += 1
		w += wc
		if ic == 0: im = false
	im = im and w == 0
	var on = fixed or _chosen.has(k)
	var bg = Color("#f3e6c0") if on else Color("#e2d8c0")
	var bd = Color("#c2362b") if on else (Color("#2e8a5a") if w >= 2 else (Color("#8a8a8a") if im else Color("#a08a5a")))
	var p = PanelContainer.new(); p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UIKit.sb(bg, 5, bd, 2 if on or w >= 2 else 1, Vector4(4, 5, 4, 5)))
	if im and not on: p.modulate = Color(1, 1, 1, 0.6)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 0); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(vb)
	var pr = UIKit.portrait(k, 44); pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(pr)
	var pw = int(J.num(J.mc(GP, "pow", [_afu()]))) if k == "afu" else int(J.num(J.mc(GP, "kindPow", [k])))
	var fear = "%.2f" % (1 + 0.35 * (J.num(J.mc(Sc, "gpq", [k])) - 1))
	var tw = []
	for t in ts: tw.append(L(FW.get(t)))
	var txt = "[center][b]%s[/b]\n[font_size=10]%s[/font_size]\n[font_size=10][color=#6e5838]%s %d・%s ×%s[/color][/font_size]\n[font_size=10]%s%s・%d[/font_size]%s[/center]" % [
		L(g.name), L(g.skill), L("鬼力"), pw, L("驚嚇"), fear, "／".join(tw), "・全場" if J.t(g.get("aoe")) else "", int(J.num(g.get("cost", 35))),
		("\n[font_size=10][color=#2e6d5a][b]%d%s[/b][/color][/font_size]" % [w, L("人怕")]) if w > 0 else ""]
	var r = _rich(txt, 12, UIKit.INKTXT); r.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(r)
	if not fixed:
		p.mouse_filter = Control.MOUSE_FILTER_STOP
		p.gui_input.connect(func(ev):
			if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT: _toggle(k))
	return p

static func _afu():
	for g in js("S").ghosts: if J.str(g.k) == "afu": return g
	return null

static func _toggle(k: String) -> void:
	Snd.play("click")
	if _chosen.has(k): _chosen.erase(k)
	elif _chosen.size() < _max(): _chosen.append(k)
	else:
		main().show_toast(Lf("最多帶{n}隻", {"n": _cn(_max())})); return
	_render()

static func _kit(k: String, K: Dictionary) -> Control:
	var S = js("S")
	var on = J.t(S.scareKit.get(k)); var ok = J.t(J.cl(js("canPay"), null, [K.cost]))
	var RN = js("RES_NAMES"); var cs = []
	for r in K.cost:
		var have = J.num(J.gp(S.res, r)) >= J.num(K.cost[r])
		cs.append(("%s %d" if have else "[color=#c2362b]%s %d[/color]") % [L(RN.get(r, r)), int(J.num(K.cost[r]))])
	var p = PanelContainer.new(); p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UIKit.sb(Color("#f3e6c0") if on else Color("#e2d8c0"), 5, Color("#c2362b") if on else Color("#a08a5a"), 2 if on else 1, Vector4(6, 5, 6, 5)))
	if not ok and not on: p.modulate = Color(1, 1, 1, 0.6)
	var r = _rich("[b]%s[/b]%s\n[font_size=11]%s[/font_size]\n[font_size=11]%s[/font_size]" % [L(K.name), "　✓" if on else "", "　".join(cs), L(K.desc)], 13, UIKit.INKTXT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(r)
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	p.gui_input.connect(func(ev):
		if not (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT): return
		Snd.play("click")
		var SK = js("S").scareKit
		if not J.t(SK.get(k)) and not J.t(J.cl(js("canPay"), null, [K.cost])):
			main().show_toast(L("材料不夠")); return
		SK[k] = not J.t(SK.get(k))
		J.cl(js("save"), null, [])
		_render())
	return p
