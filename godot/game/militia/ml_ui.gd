# [militia] 遊魂兵 UI（飄字、兵器檔資料卡、兵營面板一欄、出擊構成、攻佔字）；全部 static
extends RefCounted

const ML = preload("res://game/militia/ml_data.gd")
const BK = preload("res://game/barracks/bk_data.gd")
const ZD = preload("res://game/zone/zone_data.gd")

static func L(yue: String, zhs: String) -> String: return ML.L(yue, zhs)

# 大排檔事件：遊魂兵加入
static func eat(sc) -> void:
	for e in sc.sim.ev:
		if str(e.get("k", "")) != "ml_join": continue
		sc._float(e.pos, str(e.line), Color("#bff0a0"), 17, 2.0)
		if sc.has_method("_burst"): sc._burst(e.pos + Vector2(0, 30), Color("#d8f0b0"), 10)

# 遊魂兵一覽（各級人數）
static func roster_txt() -> String:
	var a = []
	for t in range(ML.TIERS.size() - 1, -1, -1):
		var n = ML.n_of(t)
		if n > 0: a.append("%s ×%d" % [ML.tier_name(t), n])
	return "、".join(a) if a.size() else L("（未有：等遊魂嚟買兵器）", "（還沒有：等遊魂來買兵器）")
static func army_txt() -> String:
	return L("出擊兵力 %d ＝ 陰兵 %d ＋ 遊魂兵 %d", "出擊兵力 %d ＝ 陰兵 %d ＋ 遊魂兵 %d") % [ML.army_pow(), ML.troop_pow(), ML.power()]

# 兵器檔資料卡（mv_scene._fill_sheet 掛鈎）：今期兵器、下一級、遊魂兵數
static func sheet_rows(sc, box: Control) -> void:
	var t = ML.tier_now()
	var pb = PanelContainer.new(); pb.add_theme_stylebox_override("panel", UIKit.sb(Color(0.25, 0.32, 0.12, 0.12), 8, Color("#8aa060"), 1, Vector4(8, 4, 8, 4)))
	pb.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(pb)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 2); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; pb.add_child(vb)
	var lb = func(s: String, sz: int, col: Color, w := 700):
		var l = sc._lbl(s, sz, col, "sans", w); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.custom_minimum_size = Vector2(340, 0); vb.add_child(l)
	lb.call(L("今期兵器：%s（每個遊魂兵戰力 %.2f）", "本期兵器：%s（每個遊魂兵戰力 %.2f）") % [ML.tier_name(t), ML.pw(t)], 15, Color("#3a4a1a"), 900)
	lb.call(ML.tier_desc(t), 13, Color("#5a5040"))
	if t + 1 < ML.TIERS.size():
		var nm = MD().sorted_miles(ML.SID)
		var at = nm[t] if t < nm.size() else 0
		lb.call(L("下一級（Lv%d）：%s　用料 %s", "下一級（Lv%d）：%s　用料 %s") % [at, ML.tier_name(t + 1), ML.recipe_txt(t + 1)], 13, Color("#5a5040"))
	lb.call(L("遊魂兵 %d／%d：%s", "遊魂兵 %d／%d：%s") % [ML.total(), ML.cap(), roster_txt()], 14, Color("#2a3a10"), 900)
	lb.call(L("買咗兵器嘅遊魂唔使訓練就加入；只出去打主線、野外王、攻佔，唔守村。", "買了兵器的遊魂不用訓練就加入；只出去打主線、野外王、攻佔，不守村。"), 12, Color("#6a6050"))
static func MD(): return load("res://game/outpost/mv_data.gd")

# 兵營面板（bk_ui.panel 掛鈎）：遊魂兵一欄
static func bk_box(body: Control) -> void:
	var box = PanelContainer.new(); box.add_theme_stylebox_override("panel", UIKit.sb(Color(0, 0, 0, 0.06), 6, Color(UIKit.PAPERLINE, 0.7), 1, Vector4(10, 8, 10, 8)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); box.add_child(vb); body.add_child(box)
	var R = func(bb: String, sz := 13.5):
		var r = UIKit.rich(str(DB.N(bb)), sz, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_child(r)
	R.call("[b]%s[/b]" % L("遊魂兵（民兵：只對外，唔守村）", "遊魂兵（民兵：只對外，不守村）"), 15)
	R.call(L("遊魂兵 [b]%d[/b]／%d　出擊兵力 [b][color=#9c2219]%d[/color][/b]", "遊魂兵 [b]%d[/b]／%d　出擊兵力 [b][color=#9c2219]%d[/color][/b]") % [ML.total(), ML.cap(), ML.power()])
	R.call("[font_size=12]%s[/font_size]" % roster_txt())
	R.call("[font_size=12]%s[/font_size]" % army_txt())
	R.call("[font_size=12]%s[/font_size]" % L("來源：大排檔「紙紮兵器檔」賣兵器；兵器檔升級（★）就賣更好嘅兵器。陰兵＝正規軍（少、耐打、守村）；遊魂兵＝民兵（多、免費、脆）。", "來源：大排檔「紙紮兵器攤」賣兵器；兵器攤升級（★）就賣更好的兵器。陰兵＝正規軍（少、耐打、守村）；遊魂兵＝民兵（多、免費、脆）。"), 12)

# 攻佔面板（zone_view 掛鈎）
static func cap_split_txt() -> String:
	return L("（陰兵 %d ＋ 遊魂兵 %d；遊魂兵只出去打，唔守村）", "（陰兵 %d ＋ 遊魂兵 %d；遊魂兵只出去打，不守村）") % [ML.troop_pow(), ML.power()]
static func cap_btn_txt(zid: String) -> String:
	var lm = ZD.loss_ml(zid)
	if lm <= 0: return ZD.L("派陰兵攻佔（折損 %d 陰兵）", "派陰兵攻佔（折損 %d 陰兵）") % ZD.loss(zid)
	return L("派兵攻佔（折損 陰兵 %d、遊魂兵 %d）", "派兵攻佔（折損 陰兵 %d、遊魂兵 %d）") % [ZD.loss(zid), lm]

# 大地圖戰鬥（zone_battle._build_ui 掛鈎）：底部面板上面一條「出擊構成」
static func battle_bar(mb) -> void:
	var B = mb.B
	if not J.t(B.get("ml_ext")): return
	var sq = B.get("ml_sq", [0, 0, 0])
	var my = int(J.num(B.get("ml_my", 0))); var foe = int(J.num(B.get("ml_foe", 0)))
	var l = UIKit.label("", 14, Color("#f3e3c0"), "sans", 900)
	l.name = "MlArmy"; l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.anchor_right = 1.0; l.offset_left = 6; l.offset_right = -6; l.offset_top = -30; l.offset_bottom = -4
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9)); l.add_theme_constant_override("outline_size", 5)
	l.text = bar_text(int(J.num(sq[0])), int(J.num(sq[1])), my, int(J.num(sq[2])), foe)
	var r = float(my) / float(maxi(1, foe))
	if foe > 0: l.add_theme_color_override("font_color", Color("#9fe39a") if r >= 1.0 else (Color("#ffd27a") if r >= 0.8 else Color("#ff9a7a")))
	mb.ui.add_child(l)
static func bar_text(ny: int, nm: int, my: int, nf: int, foe: int) -> String:
	var s = L("陰兵 %d 隊＋遊魂兵 %d 隊（%d）", "陰兵 %d 隊＋遊魂兵 %d 隊（%d）") % [ny, nm, my]
	if foe > 0: s += L(" 對 嘍囉 %d 隊（%d）", " 對 嘍囉 %d 隊（%d）") % [nf, foe]
	return s
