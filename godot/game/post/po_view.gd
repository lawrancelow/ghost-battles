# [post] 野外 v2 畫面：駐點木牌（營業中／空缺／收銀箱滿／停業整頓）、名鬼請假倒數、駐點卡（派主任、收錢、產量、守備）、提示（全部 static；冇 class_name）
#   const PV = preload("res://game/post/po_view.gd")
#   so_view.draw／tap／want／open_card 掛鈎；ui/main.gd _mv_tick 叫 tick(main)。
#   所有顯示嘅數字（每小時產量、收銀箱上限、守備／來犯、掉落檔位同百分比、請假倒數）都直接讀 po_data 計出嚟嘅值，唔另外寫死。
extends RefCounted

const PO = preload("res://game/post/po_data.gd")
const ZD = preload("res://game/zone/zone_data.gd")
static var card: Control = null
static var card_key := ""
static var pick_on := false
static var last_msg := ""

static func L(yue: String, zhs: String) -> String: return PO.L(yue, zhs)
static func _SO(): return load("res://game/sortie/so_data.gd")
static func _SV(): return load("res://game/sortie/so_view.gd")
static func _rts(): return load("res://game/rts/rts.gd")

# ======================= 每 0.5 秒（ui/main.gd _mv_tick） =======================
static func tick(main) -> void:
	if PO.off(): return
	PO.tick()
	eat_news(main)
	if card != null and is_instance_valid(card) and card_key != "" and not pick_on:   # 卡開住：每秒更新數字
		var ms = Time.get_ticks_msec()
		if ms - _card_ms >= 1000:
			_card_ms = ms
			var e = PO.camp_of(card_key)
			if not e.is_empty() and PO.held(e) and not PO.lost(e): open_card(e)
static var _card_ms := 0
static func eat_news(main) -> void:
	while PO.NEWS.size():
		var n = PO.NEWS.pop_front()
		if main == null or not is_instance_valid(main): continue
		var e = PO.camp_of(str(n.get("key", "")))
		var nm = PO.camp_name(e) if not e.is_empty() else ""
		match str(n.k):
			"open":
				main.show_banner(L("駐點開張！", "駐點開張！"))
				main.show_toast(L("%s開張。撳木牌派隻鬼去做主任，就會自動有冥幣同棺材板。", "%s開張。點木牌派一隻鬼去當主任，就會自動有冥幣和棺材板。") % nm)
				_juice(main, true)
			"retake":
				main.show_toast(L("%s收復咗，重新開張。記得再派主任。", "%s收復了，重新開張。記得再派主任。") % nm)
			"siege":
				main.show_toast(L("主任守唔住！幫派衝去%s。撳上面紅色條親自迎戰，或者撳木牌派包子打發。", "主任守不住！幫派衝向%s。點上面紅色條親自迎戰，或者點木牌派包子打發。") % nm)
			"repel":
				var how = str(n.get("how", ""))
				if how == "fight":
					main.show_banner(L("擊退反撲！", "擊退反撲！"))
					var t = L("%s守住咗。之後 %d 分鐘產量 ×%s。", "%s守住了。之後 %d 分鐘產量 ×%s。") % [nm, int(PO.P().get("boost_min", 30)), str(PO.P().get("boost", 1.5))]
					if str(n.get("line", "")) != "": t += str(n.line)
					main.show_toast(t)
					_juice(main, false)
				elif how == "feed":
					main.show_toast(L("班餓鬼攞咗 %d 個壽包就走咗，%s冇事。", "那群餓鬼拿了 %d 個壽包就走了，%s沒事。") % [int(PO.feed_cost()), nm])
				else:
					main.show_toast(L("主任自己趕走咗反撲，%s冇事。", "主任自己趕走了反撲，%s沒事。") % nm)
			"lost":
				main.show_banner(L("駐點停業整頓！", "駐點停業整頓！"))
				main.show_toast(L("%s畀人搶返：收銀箱冇咗 %d 冥幣、%d 棺材板，主任返咗村。要再打贏一次先收復。", "%s被搶回去：收銀箱少了 %d 冥幣、%d 棺材板，主任回村了。要再打贏一次才能收復。") % [nm, int(J.num(n.get("coins", 0))), int(J.num(n.get("planks", 0)))])
		if card != null and is_instance_valid(card) and card_key == str(n.get("key", "")): close_card()
static func _juice(main, big: bool) -> void:   # [juice] 有先叫；設定關咗佢自己會唔做
	if not ResourceLoader.exists("res://ui/juice.gd"): return
	var JU = load("res://ui/juice.gd")
	if JU == null or not JU.on(): return
	for m in JU.get_script_method_list():
		if str(m.get("name", "")) == "celebrate_banner": JU.celebrate_banner(big); return

# ======================= 木牌（so_view.draw 掛鈎） =======================
# 回 {} ＝呢個據點照舊畫；否則 {l1, l2, bg, bd, col, col2, seal:bool, dot:String}
static func sign_of(e: Dictionary, s: String) -> Dictionary:
	if PO.off() or not PO.on_for(int(J.num(e.get("c", 0)))): return {}
	if PO.is_post(e):
		if s == "held":
			var d = {"l1": L("駐點辦事處", "駐點辦事處"), "bg": Color(0.1, 0.24, 0.16, 0.95), "bd": Color("#8fd49a"), "col": Color("#eaffe0"), "col2": Color("#ffd27a"), "seal": false, "dot": ""}
			var g = PO.chief(e)
			if g == null:
				d["l2"] = L("空缺：撳我派主任", "空缺：點我派主任"); d["bg"] = Color(0.26, 0.2, 0.08, 0.95); d["bd"] = Color("#e8b060"); d["col2"] = Color("#ff9a6a")
			elif PO.till_full(e):
				d["l2"] = L("收銀箱滿咗：撳我收錢", "收銀箱滿了：點我收錢"); d["col2"] = Color("#ff9a6a")
			else:
				d["l2"] = L("營業中　冥幣 +%d／小時", "營業中　冥幣 +%d／小時") % int(round(PO.rate(e).coins))
			var t = PO.till(e)
			if not PO.auto_bank(e) and t.coins >= 1.0: d["dot"] = str(int(t.coins))
			return d
		if PO.lost(e):
			return {"l1": L("駐點・停業整頓", "駐點・停業整頓"), "l2": L("打贏一次先收復", "打贏一次才能收復"), "bg": Color(0.28, 0.08, 0.08, 0.95), "bd": Color("#e06050"),
				"col": Color("#ffe0d8"), "col2": Color("#ffb0a0"), "seal": true, "dot": ""}
		return {}
	if (s == "open" or s == "cleared") and PO.guard_away(e):
		return {"l1": _SO().short(e), "l2": L("名鬼%s", "名鬼%s") % PO.leave_text(e), "bg": Color(0.2, 0.2, 0.24, 0.92), "bd": Color("#9aa0c0"), "col": Color("#e4e6f4"), "col2": Color("#c8d0ff"), "seal": false, "dot": "",
			"l3": (L("代班頭目頂住，照打得", "代班頭目頂著，照樣可以打") if s == "open" else "")}
	return {}
# 畫（座標已經 v._at 去木牌位）：回 true＝畫咗
static func draw_sign(v, n: CanvasItem, f: Font, e: Dictionary, s: String, at: Vector2) -> bool:
	var d = sign_of(e, s)
	if d.is_empty(): return false
	var l1 = str(d.l1); var l2 = str(d.l2)
	var w = maxf(f.get_string_size(l1, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x, f.get_string_size(l2, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x)
	if v.has_method("_avoid_w"): v._avoid_w(at + Vector2(0, 40), Rect2(-w / 2 - 10, -18, w + 20, 48))
	n.draw_style_box(v._box(Color(0, 0, 0, 0.35), 6), Rect2(-w / 2 - 6, -13, w + 16, 44))
	n.draw_style_box(v._box(d.bd, 6), Rect2(-w / 2 - 8, -16, w + 16, 44))
	n.draw_style_box(v._box(d.bg, 5), Rect2(-w / 2 - 6, -14, w + 12, 40))
	v._str(n, f, l1, 0, 4, 15, d.col, 0)
	v._str(n, f, l2, 0, 22, 14, d.col2, 0)
	if J.t(d.get("seal")):   # 停業封條：紅色斜條
		n.draw_line(Vector2(-w / 2 - 8, 26), Vector2(w / 2 + 8, -14), Color(0.86, 0.16, 0.12, 0.85), 5.0)
		n.draw_line(Vector2(-w / 2 - 8, -14), Vector2(w / 2 + 8, 26), Color(0.86, 0.16, 0.12, 0.85), 5.0)
	if str(d.get("dot", "")) != "":   # 收銀箱：金色圓點＋數
		var tw = f.get_string_size(str(d.dot), HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
		var c = Vector2(w / 2 + 6, -18)
		n.draw_style_box(v._box(Color("#c8322a"), 9), Rect2(c.x - tw / 2 - 8, c.y - 10, tw + 16, 20))
		v._str(n, f, str(d.dot), c.x, c.y + 5, 13, Color("#fff4c0"), 0)
	return true

# ======================= 駐點卡 =======================
static func close_card() -> void:
	if card != null and is_instance_valid(card): card.queue_free()
	card = null; card_key = ""; pick_on = false
# 卡上面每一行（測試用：顯示＝實際）
static func card_lines(e: Dictionary) -> Dictionary:
	var o = {}
	var g = PO.chief(e); var r = PO.rate(e); var b = PO.base_rate(e); var t = PO.till(e); var cap = PO.till_cap(e)
	o["head"] = PO.camp_name(e)
	o["sub"] = L("%s　第%d圈", "%s　第%d圈") % [_SO().short(e), int(e.ring)]
	if g == null:
		o["chief"] = L("主任：空缺（冇主任唔會有收入）", "主任：空缺（沒有主任就沒有收入）")
		o["rate"] = L("派咗主任：每小時 冥幣 %d、棺材板 %d", "派了主任後：每小時 冥幣 %d、棺材板 %d") % [int(round(b.coins)), int(round(b.planks))]
	else:
		o["chief"] = L("主任：%s　Lv%d（%s）", "主任：%s　Lv%d（%s）") % [PO.gname(g), int(PO._BK().glv(g)), L("名鬼：自動入賬", "名鬼：自動入帳") if PO.auto_bank(e) else L("普通鬼：要自己收錢", "普通鬼：要自己收錢")]
		o["rate"] = L("每小時 冥幣 %d、棺材板 %d", "每小時 冥幣 %d、棺材板 %d") % [int(round(r.coins)), int(round(r.planks))]
		if PO.boost_on(e): o["rate"] += L("（親自擊退加成 ×%s）", "（親自擊退加成 ×%s）") % str(PO.P().get("boost", 1.5))
		if float(r.mul) <= 0.0: o["rate"] += L("（主任罷工：去酒館派夜宵）", "（主任罷工：去酒館派夜宵）")
		elif PO.work_mul(e) < 1.0: o["rate"] += L("（主任肚餓，產量減半）", "（主任肚子餓，產量減半）")
	if PO.auto_bank(e): o["till"] = L("收銀箱：自動入賬，唔使收", "收銀箱：自動入帳，不用收")
	else: o["till"] = L("收銀箱：冥幣 %d／%d　棺材板 %d／%d（滿咗就停）", "收銀箱：冥幣 %d／%d　棺材板 %d／%d（滿了就停）") % [int(t.coins), int(round(cap.coins)), int(t.planks), int(round(cap.planks))]
	o["def"] = L("守備 %d　幫派來犯 %d（%s）", "守備 %d　幫派來犯 %d（%s）") % [PO.def_pow(e), PO.foe_pow(e), L("守得住", "守得住") if PO.def_pow(e) >= PO.foe_pow(e) else L("守唔住，要親自迎戰或者派包子", "守不住，要親自迎戰或派包子")]
	var k = PO.leader(e)
	o["leader"] = L("反撲領隊：%s。親自擊退有魂魄＋%d 分鐘產量 ×%s", "反撲領隊：%s。親自擊退有魂魄＋%d 分鐘產量 ×%s") % [PO._SOUL().gname(k) if k != "" else L("雜兵", "雜兵"), int(PO.P().get("boost_min", 30)), str(PO.P().get("boost", 1.5))]
	o["lost"] = L("冇守住：收銀箱冇咗 %d%%、主任返村、停業到你打贏一次為止", "沒守住：收銀箱少 %d%%、主任回村、停業到你打贏一次為止") % int(round(float(PO.P().get("fail_store", 0.3)) * 100.0))
	o["can_collect"] = not PO.auto_bank(e) and (t.coins >= 1.0 or t.planks >= 1.0)
	o["feed"] = PO.can_feed() and _raid_key() == PO.key(e)
	o["feed_txt"] = L("派包子打發（壽包 %d）", "派包子打發（壽包 %d）") % int(PO.feed_cost())
	return o
static func _raid_key() -> String:
	var r = load("res://game/raid/raid.gd")._peek()
	if r == null or not (r.get("cur") is Dictionary): return ""
	var k = str(r.cur.get("tgt", ""))
	return k.substr(2) if PO.is_tkey(k) else ""
static func _btn(t: String, on := true, hot := false, w := 120.0) -> Button:
	var b = Button.new(); b.text = t; b.focus_mode = Control.FOCUS_NONE; b.custom_minimum_size = Vector2(w, 44)
	var gs = UIKit.sb((Color("#8a2a18") if hot else Color("#3a2c26")) if on else Color("#4a4440"), 8, (Color("#f0b070") if hot else Color("#8a6a50")) if on else Color("#706860"), 2, Vector4(10, 4, 10, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, gs)
	b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 17)
	for k in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color"]: b.add_theme_color_override(k, Color("#fff0dc") if on else Color("#a8a0a0"))
	b.disabled = not on
	return b
static func open_card(e: Dictionary, picking := false) -> void:
	_SV().close_card()
	close_card()
	var host = _SV()._host()
	if host == null: return
	var d = card_lines(e)
	var pc = PanelContainer.new(); pc.name = "PostCard"
	var sb = UIKit.sb(Color(0.07, 0.12, 0.09, 0.97), 12, Color("#8fd49a"), 2, Vector4(14, 10, 14, 10))
	sb.shadow_color = Color(0, 0, 0, 0.5); sb.shadow_size = 8
	pc.add_theme_stylebox_override("panel", sb)
	pc.mouse_filter = Control.MOUSE_FILTER_STOP
	pc.anchor_left = 0; pc.anchor_right = 1; pc.anchor_top = 0; pc.anchor_bottom = 0
	pc.offset_left = 10; pc.offset_right = -10; pc.offset_top = 232; pc.grow_vertical = Control.GROW_DIRECTION_END
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 5); pc.add_child(vb)
	var lab = func(t: String, px: int, col: Color):
		var l = UIKit.label(t, px, col, "sans", 900); l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; l.custom_minimum_size = Vector2(0, 0); l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_child(l); return l
	lab.call(d.head, 21, Color("#d8ffd0"))
	lab.call(d.sub, 15, Color("#b8d8b8"))
	if picking:
		pick_on = true
		lab.call(L("揀邊個去做主任（揀咗會由原本嘅工作調走）：", "選誰去當主任（選了會從原本的工作調走）："), 16, Color("#ffd27a"))
		var cands = PO.candidates()
		if cands.is_empty(): lab.call(L("冇鬼可以派。去酒館招隻普通鬼，或者去祭壇招降名鬼。", "沒有鬼可以派。去酒館招一隻普通鬼，或到祭壇招降名鬼。"), 15, Color("#ff9a6a"))
		var sc = ScrollContainer.new(); sc.custom_minimum_size = Vector2(0, minf(300.0, 52.0 * cands.size())); sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; vb.add_child(sc)
		var lb = VBoxContainer.new(); lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; lb.add_theme_constant_override("separation", 4); sc.add_child(lb)
		for g in cands:
			var gid = g.get("id")
			var t = "%s　Lv%d　%s　%s" % [PO.gname(g), int(PO._BK().glv(g)), L("名鬼", "名鬼") if PO.is_named_ghost(g) else L("普通鬼", "普通鬼"), PO._BK().job_label(g)]
			var b = _btn(t, true, false, 0.0); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.alignment = HORIZONTAL_ALIGNMENT_LEFT
			b.pressed.connect(func(): press_assign(e, gid))
			lb.add_child(b)
		var bk = _btn(L("返回", "返回")); bk.pressed.connect(func(): open_card(e)); vb.add_child(bk)
	else:
		lab.call(d.chief, 16, Color("#f0f0e0"))
		lab.call(d.rate, 17, Color("#ffd27a"))
		lab.call(d.till, 16, Color("#f0e0c0"))
		lab.call(d.def, 15, Color("#c8e8ff"))
		lab.call(d.leader, 14, Color("#e0c8ff"))
		lab.call(d.lost, 14, Color("#ffb0a0"))
		var bb = HFlowContainer.new(); bb.add_theme_constant_override("h_separation", 10); bb.add_theme_constant_override("v_separation", 8); vb.add_child(bb)
		var b1 = _btn(L("收錢", "收錢"), d.can_collect, d.can_collect); b1.pressed.connect(func(): press_collect(e)); bb.add_child(b1)
		var b2 = _btn(L("派主任", "派主任") if PO.chief(e) == null else L("換主任", "換主任"), true, PO.chief(e) == null); b2.pressed.connect(func(): open_card(e, true)); bb.add_child(b2)
		if PO.chief(e) != null:
			var b3 = _btn(L("叫返村", "叫回村")); b3.pressed.connect(func(): PO.recall(e); open_card(e)); bb.add_child(b3)
		if d.feed:
			var b4 = _btn(d.feed_txt, true, true, 200.0); b4.pressed.connect(func(): press_feed(e)); bb.add_child(b4)
		var cl = _btn(L("關閉", "關閉"), true, false, 96.0); cl.pressed.connect(func(): close_card()); bb.add_child(cl)
	host.add_child(pc)
	card = pc; card_key = PO.key(e); pick_on = picking
static func press_collect(e: Dictionary) -> Dictionary:
	var g = PO.collect(e)
	if g.coins > 0 or g.planks > 0:
		_rts().toast(L("收銀箱：冥幣 +%d　棺材板 +%d", "收銀箱：冥幣 +%d　棺材板 +%d") % [int(g.coins), int(g.planks)])
		Snd.play("coin")
	open_card(e)
	return g
static func press_assign(e: Dictionary, gid) -> String:
	var r = PO.assign(e, gid)
	last_msg = r
	if r != "ok": _rts().toast(r)
	else: Snd.play("click")
	open_card(e)
	return r
static func press_feed(e: Dictionary) -> String:
	var r = PO.feed()
	last_msg = r
	if r != "ok": _rts().toast(r)
	close_card()
	return r

# ======================= 出擊卡加行（so_view.open_card 掛鈎） =======================
# 名鬼據點：首殺必掉／四檔數量同百分比／請假倒數；停業整頓嘅駐點：收復說明。回 [[字, 字號, 色]…]
static func sortie_rows(e: Dictionary) -> Array:
	var o = []
	if PO.off() or not PO.on_for(int(J.num(e.get("c", 0)))): return o
	var SOUL = PO._SOUL()
	if PO.is_post(e):
		if PO.lost(e): o.append([L("停業整頓緊：打贏呢場就收復（對面只有平時八成）", "停業整頓中：打贏這場就收復（對面只有平時八成）"), 16, Color("#ffb0a0")])
		else:
			var b = PO.base_rate(e)
			o.append([L("普通據點：打贏就佔領做駐點辦事處，派主任之後每小時 冥幣 %d、棺材板 %d", "普通據點：打贏就佔領成駐點辦事處，派主任後每小時 冥幣 %d、棺材板 %d") % [int(round(b.coins)), int(round(b.planks))], 15, Color("#b8f0b8")])
			var k0 = SOUL.guard_of(e)
			if k0 != "" and not PO.first_done(k0): o.append([L("首殺必掉：%s魂魄 %d 個", "首殺必掉：%s魂魄 %d 個") % [SOUL.gname(k0), PO.first_n(SOUL.pin(k0))], 15, Color("#ffd27a")])
		return o
	var k = SOUL.guard_of(e)
	if k == "": return o
	var pin = SOUL.pin(k)
	o.append([L("名鬼據點：唔可以佔領，名鬼銷假就打得（%s品：請假 %s）", "名鬼據點：不能佔領，名鬼銷假就能再打（%s品：請假 %s）") % [pin, cd_text(pin)], 15, Color("#c8d0ff")])
	if PO.guard_away(e): o.append([L("名鬼%s。而家打：代班頭目，冇主魂", "名鬼%s。現在打：代班頭目，沒有主魂") % PO.leave_text(e), 16, Color("#ffb0a0")])
	if not PO.first_done(k): o.append([L("首殺必掉：%s魂魄 %d 個", "首殺必掉：%s魂魄 %d 個") % [SOUL.gname(k), PO.first_n(pin)], 16, Color("#ffd27a")])
	o.append([L("每場魂魄：", "每場魂魄：") + tiers_text(pin), 15, Color("#e8d8ff")])
	return o
static func cd_text(pin: String) -> String:
	var m = PO.cd_min(pin)
	if m >= 60.0: return L("%s 小時", "%s 小時") % (str(int(m / 60.0)) if is_equal_approx(fmod(m, 60.0), 0.0) else "%.1f" % (m / 60.0))
	return L("%d 分鐘", "%d 分鐘") % int(m)
static func tiers_text(pin: String) -> String:   # 「很少 1 個 30%｜普通 3 個 37%…」（同 PO.roll 同一張表）
	var p = []
	for t in PO.tiers(pin): p.append(L("%s %d 個 %s%%", "%s %d 個 %s%%") % [t.name, int(t.n), pct_str(float(t.pct))])
	return "｜".join(p)
static func pct_str(x: float) -> String:
	return str(int(round(x))) if absf(x - round(x)) < 0.05 else "%.1f" % x
