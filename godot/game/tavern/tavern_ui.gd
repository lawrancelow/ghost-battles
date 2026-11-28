# [tavern] 陰間酒館面板（掛喺招魂台／酒館建築面板，取代舊「招雜鬼」一行）
# panel(body, refresh)：名單卡（名、稀有度、三圍、口頭禪、價錢、招募鍵）、手動刷新、夜宵狀態＋派夜宵。
extends RefCounted

const TV := preload("res://game/tavern/tavern.gd")
const GEN := preload("res://game/tavern/tv_gen.gd")
const M := preload("res://game/outpost/mat.gd")
const RAR_COL := [Color("#3d6a8a"), Color("#7a3a9a"), Color("#b8860b")]

static func T(y: String, z: String) -> String: return TV.T(y, z)
static func _rich(bb: String, size := 14, col := UIKit.INKTXT) -> RichTextLabel: return UIKit.rich(bb, size, col)
static func _btn(text: String, kind: String, enabled: bool, f: Callable) -> Button:
	var b = UIKit.btn(text, kind); b.disabled = not enabled; b.focus_mode = Control.FOCUS_NONE
	b.pressed.connect(func(): f.call())
	return b
static func _toast(bb: String) -> void:
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, "toast", [bb])
static func _save() -> void:
	var sv = J.G.get("save")
	if sv != null: J.cl(sv, null, [])

static func panel(body: Control, refresh: Callable) -> void:
	if not TV.on(): return
	var KGq = load("res://game/kpi/kpi_data.gd")
	if KGq.on() and not KGq.is_open("tavern"):   # [kpi] 酒館要錢不漏考核達標先開門
		body.add_child(_rich(T("[b]陰間酒館（未開門）[/b]　三更嬸：「水電賬未清，錢不漏總管未簽字，我唔開得檔。」\n通過錢不漏嘅 KPI 考核之後，酒館就開門招鬼。", "[b]陰間酒館（未開門）[/b]　三更嬸：「水電帳還沒清，錢不漏總管還沒簽字，我開不了門。」\n通過錢不漏的 KPI 考核之後，酒館就開門招鬼。"), 15, Color("#7a2416")))
		return
	TV.tick_list()
	var t = TV.st(); var s = TV.S()
	body.add_child(_rich(T("[b]陰間酒館[/b]　三更嬸：「請佢哋飲杯，傾得掂就跟你走。」", "[b]陰間酒館[/b]　三更嬸：「請他們喝一杯，談得攏就跟你走。」"), 16, Color("#7a2416")))
	var left = TV.next_left_s()
	var mc = TV.manual_cost()
	var top = HBoxContainer.new(); top.add_theme_constant_override("separation", 8); body.add_child(top)
	var tl = _rich(T("約 %d 分鐘後換一批客", "約 %d 分鐘後換一批客") % maxi(1, int(ceil(left / 60.0))), 13, UIKit.INKDIM); tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; top.add_child(tl)
	top.add_child(_btn(T("請多輪（冥幣 %d）", "再請一輪（冥幣 %d）") % int(mc), "", J.num(s.res.get("coins", 0)) >= mc, func():
		var r = TV.manual_refresh()
		if r.ok: Snd.play("paper"); _save()
		refresh.call()))
	var i = 0
	for g in t.list:
		var ii = i
		body.add_child(_card(g, ii, refresh))
		i += 1
	# 夜宵
	body.add_child(UIKit.hsep())
	var eat = TV.eaters(); var hungry = []; var strike = []
	for g in eat:
		match TV.hunger_of(g):
			1: hungry.append(str(g.name))
			2: strike.append(str(g.name))
	var tx = T("[b]夜宵[/b]　開工嘅酒館鬼 %d 隻，每更食普通包子 %d 個（每小時約 %d 個）　存貨 %d", "[b]宵夜[/b]　開工的酒館鬼 %d 隻，每更吃普通包子 %d 個（每小時約 %d 個）　存貨 %d") % [eat.size(), int(TV.meal_cost()), int(TV.per_hour_bao()), int(M.amt("m_bao"))]
	if strike.size(): tx += "\n[color=#c2362b]" + T("罷工：", "罷工：") + "、".join(strike) + "[/color]"
	if hungry.size(): tx += "\n[color=#b5651d]" + T("肚餓（產量減半）：", "肚子餓（產量減半）：") + "、".join(hungry) + "[/color]"
	if strike.is_empty() and hungry.is_empty() and eat.size(): tx += "\n[color=#4a6a3a]" + T("全部食飽，安心開工。", "全部吃飽，安心開工。") + "[/color]"
	var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 8); body.add_child(row)
	var rl = _rich(tx, 13); rl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(rl)
	if hungry.size() or strike.size():
		row.add_child(_btn(T("派夜宵", "派宵夜"), "gold", M.amt("m_bao") >= 1, func():
			var r = TV.feed_now(); _save()
			_toast(T("餵飽 %d 隻%s", "餵飽 %d 隻%s") % [int(r.fed), (T("，仲有 %d 隻冇得食（去包子鋪做普通包子）", "，還有 %d 隻沒得吃（去包子鋪做普通包子）") % int(r.left)) if r.left > 0 else ""])
			refresh.call()))

static func _card(g: Dictionary, i: int, refresh: Callable) -> Control:
	var rar = clampi(int(g.get("rar", 0)), 0, 2)
	var pc = PanelContainer.new()
	var edge = RAR_COL[rar]
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55) if rar == 0 else Color(edge, 0.12), 6, edge, 2 if rar > 0 else 1, Vector4(10, 6, 10, 6)))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); pc.add_child(hb)
	var tag = GEN.rar_label(rar)
	if g.get("named") != null: tag = T("名鬼", "名鬼") + "・" + tag
	var st = g.get("st", [0, 0, 0])
	var info = "[b]%s[/b]　[color=#%s]%s[/color]%s\n[font_size=12]力 %d　智 %d　武 %d[/font_size]\n[font_size=12][color=#6e5838]「%s」[/color][/font_size]" % [
		str(g.name), edge.to_html(false), tag, ("　✦" if str(g.get("look", {}).get("halo", "")) != "" else ""),
		int(st[0]), int(st[1]), int(st[2]), GEN.cp_text(g)]
	if g.get("named") != null: info += "\n[font_size=12]%s・%s[/font_size]" % [str(g.get("life", "")), str(g.get("trait", ""))]
	var rl = _rich(info, 14); rl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(rl)
	if g.get("taken"):
		hb.add_child(_rich(T("已簽約", "已簽約"), 13, UIKit.INKDIM))
		return pc
	var ck = TV.can_recruit(i)
	var why = ""
	match str(ck.get("why", "")):
		"cap": why = T("名額滿（升民宅）", "名額滿（升級民宅）")
		"coins": why = T("差冥幣 %d", "差冥幣 %d") % int(J.num(ck.need) - J.num(ck.have))
	var vb = VBoxContainer.new(); hb.add_child(vb)
	vb.add_child(_btn(T("請飲杯　冥幣 %d", "請喝一杯　冥幣 %d") % int(TV.cost_of(g)), "gold", bool(ck.ok), func():
		var r = TV.recruit(i)
		if r.ok:
			Snd.play("gong" if rar >= 2 else "whoosh"); _save()
			_toast("[b]%s[/b]：%s" % [str(r.g.name), str(r.line)])
			var q = J.G.get("Quest")
			if q != null: J.mc(q, "check", [])
		refresh.call()))
	if why != "": vb.add_child(_rich("[font_size=11][color=#c2362b]%s[/color][/font_size]" % why, 11))
	return pc
