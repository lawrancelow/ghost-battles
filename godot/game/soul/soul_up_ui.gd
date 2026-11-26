# [soul_up] 祭壇「融合」「突破」兩頁（soul_ui.gd altar 掛鈎）
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")
const UP = preload("res://game/soul/soul_up.gd")
const UI = preload("res://game/soul/soul_ui.gd")

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)

static func _owned() -> Array:
	var out = []
	for g in J.iter(SOUL.S().get("ghosts")):
		var k = J.str(g.get("k"))
		if SOUL.is_ghost(k) and J.str(g.get("q")) == "名": out.append({"k": k, "g": g})
	return out

static func _ladder(body: VBoxContainer) -> void:   # 品階梯：開放到鬼王・上品，冥君／幽皇顯示「未開放」
	var t = ""
	for i in UP.PJ.size():
		var open = i * 3 <= UP.OPEN_MAX
		var nm = UP.T(UP.PJ[i]) if open else "？？？"
		t += "[color=%s][b]%s[/b][/color]" % [UP.PJ_COL[i] if open else "#8a8070", nm]
		if i < UP.PJ.size() - 1: t += " → "
	body.add_child(UI._rich(t + "　[font_size=13][color=#6e5838]" + L("（每品分下、中、上三品；未開放嘅等日後改版）", "（每品分下、中、上三品；未開放的等日後改版）") + "[/color][/font_size]", 16))

static func fuse_page(body: VBoxContainer, refresh: Callable) -> void:
	_ladder(body)
	body.add_child(UI._rich(L("融合：用本鬼魂魄＋同系其他鬼嘅魂魄＋散魂，升一階（下品→中品→上品→下一品）。每升一階三圍 +3%、品越高星級上限越高。煞鬼起要「精魄」：只有打特定嘅王先有極低機會掉。", "融合：用本鬼魂魄＋同系其他鬼的魂魄＋散魂，升一階（下品→中品→上品→下一品）。每升一階三圍 +3%、品越高星級上限越高。煞鬼起需要「精魄」：只有打特定的王才有極低機會掉落。"), 14, UI.DIM))
	var jps = []
	for sy in load("res://game/rts/roles.gd").SYS_ZH:
		if UP.jp(sy) > 0: jps.append("%s %d" % [sy, UP.jp(sy)])
	body.add_child(UI._rich(L("精魄：", "精魄：") + ("、".join(jps) if jps.size() else L("未有", "還沒有")) + "　" + L("冥火：%d", "冥火：%d") % UP.mh(), 15, UI.INK))
	var lst = _owned()
	if lst.is_empty(): body.add_child(UI._rich(L("未有名鬼。", "還沒有名鬼。"), 16, UI.DIM)); return
	lst.sort_custom(func(a, b):
		var ca = UP.can_fuse(a.k).ok; var cb = UP.can_fuse(b.k).ok
		if ca != cb: return ca
		return UP.pj(a.k) > UP.pj(b.k))
	for x in lst:
		var k = str(x.k); var c = UP.can_fuse(k)
		var vb0 = UI._card(body)
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); vb0.add_child(hb)
		hb.add_child(UI._por(k, 52, "own"))
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 2); hb.add_child(vb)
		vb.add_child(UI._rich("[b]%s[/b]　[color=#%s][b]%s[/b][/color]　%s系" % [SOUL.gname(k), UP.pj_col(k).to_html(false), UP.pj_name(k), UP.sys_of(k)], 16))
		if str(c.why) in ["max", "locked"]:
			vb.add_child(UI._rich(UP.why_txt(str(c.why), c, k), 14, UI.GOOD)); continue
		vb.add_child(UI._rich(L("下一階【%s】：本鬼魂魄 %d/%d　同系魂魄 %d/%d　散魂 %d　冥幣 %d", "下一階【%s】：本鬼魂魄 %d/%d　同系魂魄 %d/%d　散魂 %d　冥幣 %d") % [UP.pj_name_i(int(c.to)), SOUL.souls(k), int(c.own), UP.same_sys_souls(k), int(c.sys), int(c.san), int(c.coins)]
			+ ((L("　%s系精魄 %d/%d", "　%s系精魄 %d/%d") % [UP.sys_of(k), UP.jp(UP.sys_of(k)), int(c.jp)]) if int(c.jp) > 0 else ""), 14, UI.INK))
		var bb = HBoxContainer.new(); bb.alignment = BoxContainer.ALIGNMENT_END; vb0.add_child(bb)
		if not c.ok: vb.add_child(UI._rich("[color=#b0281c]" + UP.why_txt(str(c.why), c, k) + "[/color]", 14))
		var lab = L("融合", "融合")
		bb.add_child(UI._btn(lab, "gold", c.ok, func():
			if UP.fuse(k) == "ok":
				Snd.play("fuse")   # [sfx43]
				var m = UI._main()
				if m != null and m.has_method("show_banner"): m.show_banner(L("【%s】融合成%s！", "【%s】融合成%s！") % [SOUL.gname(k), UP.pj_name(k)])
			refresh.call()))

static func star_page(body: VBoxContainer, refresh: Callable) -> void:
	body.add_child(UI._rich(L("突破：升到合夥人之後，用本鬼魂魄＋冥火突破星級（★1–★5）。每星三圍 +6%；★1 主技升級、★2 副技升級、★3 換進階立繪、★4 副技再升、★5 主技再升。星級上限：凡魂 1、靈鬼 3、煞鬼 4、鬼王 5。冥火：打野外王、魔王、第 4 圈據點掉。", "突破：升到合夥人之後，用本鬼魂魄＋冥火突破星級（★1–★5）。每星三圍 +6%；★1 主技升級、★2 副技升級、★3 換進階立繪、★4 副技再升、★5 主技再升。星級上限：凡魂 1、靈鬼 3、煞鬼 4、鬼王 5。冥火：打野外王、魔王、第 4 圈據點掉落。"), 14, UI.DIM))
	body.add_child(UI._rich(L("冥火：%d", "冥火：%d") % UP.mh(), 15, UI.INK))
	var lst = _owned()
	if lst.is_empty(): body.add_child(UI._rich(L("未有名鬼。", "還沒有名鬼。"), 16, UI.DIM)); return
	lst.sort_custom(func(a, b):
		var ra = SOUL.rank(a.k) >= SOUL.RANK_MAX; var rb = SOUL.rank(b.k) >= SOUL.RANK_MAX
		if ra != rb: return ra
		return UP.star(a.k) > UP.star(b.k))
	for x in lst:
		var k = str(x.k); var c = UP.can_star(k); var s0 = UP.star(k)
		var vb0 = UI._card(body)
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); vb0.add_child(hb)
		hb.add_child(UI._por(k, 52, "own"))
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 2); hb.add_child(vb)
		var stars = "[color=#e0a020]" + "★".repeat(s0) + "[/color][color=#9a9080]" + "☆".repeat(UP.star_cap(k) - mini(s0, UP.star_cap(k))) + "[/color]"
		vb.add_child(UI._rich("[b]%s[/b]　%s　%s" % [SOUL.gname(k), stars, SOUL.rank_name(SOUL.rank(k))], 16))
		if str(c.why) in ["rank", "max", "cap"]:
			vb.add_child(UI._rich(UP.why_txt(str(c.why), c, k), 14, UI.DIM if str(c.why) != "max" else UI.GOOD)); continue
		vb.add_child(UI._rich(L("下一星 ★%d：本鬼魂魄 %d/%d　冥火 %d/%d　冥幣 %d", "下一星 ★%d：本鬼魂魄 %d/%d　冥火 %d/%d　冥幣 %d") % [int(c.to), SOUL.souls(k), int(c.own), UP.mh(), int(c.mh), int(c.coins)], 14, UI.INK))
		var bb = HBoxContainer.new(); bb.alignment = BoxContainer.ALIGNMENT_END; vb0.add_child(bb)
		if not c.ok: vb.add_child(UI._rich("[color=#b0281c]" + UP.why_txt(str(c.why), c, k) + "[/color]", 14))
		var lab = L("突破", "突破")
		bb.add_child(UI._btn(lab, "gold", c.ok, func():
			if UP.up_star(k) == "ok":
				Snd.play("star")   # [sfx43]
				var m = UI._main()
				if m != null and m.has_method("show_banner"): m.show_banner(L("【%s】突破到 ★%d！", "【%s】突破到 ★%d！") % [SOUL.gname(k), UP.star(k)])
			refresh.call()))
