# [equip] 裝備 UI：兵器檔資料卡（今期款、訂製入口）、訂製面板、名冊三格、換裝面板（全部 static）
extends RefCounted

const EQ = preload("res://game/equip/eq_data.gd")
const EA = preload("res://game/equip/eq_art.gd")
const EV = preload("res://game/equip/eq_view.gd")
const M = preload("res://game/outpost/mat.gd")
const VP = preload("res://game/fxkit/vfx_play.gd")   # [vfx 第四批] 升級特效
static func _set_tier(gid) -> int:   # 套裝已開幾段（2 件、3 件各算一段）
	var n = 0
	for si in EQ.set_info(gid): n += (si.on as Array).size()
	return n
static func _set_fx(gid, t0: int) -> void:   # 著完多開咗一段套裝 → 播「套裝湊齊」
	if _set_tier(gid) > t0: VP.burst("up_set")
const TAGW := {"遠": "遠程", "拉": "拉落地", "掃": "範圍", "破": "破殼", "刺": "斬召喚", "削": "停回血", "回": "吸血治療", "照": "現形", "定": "定驚", "收": "收屍變"}
const SCW := {"breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
const STW := {"atk": "攻", "hp": "血", "taken": "受傷", "energy": "儲能", "aspd": "攻速", "spd": "行速", "heal_in": "受治療"}

static func L(yue: String, zhs: String) -> String: return EQ.L(yue, zhs)
static var popup_root = null      # 測試：最後開嘅面板
static var on_change = null       # 名冊：換裝後重畫

# ---------------- 文字 ----------------
static func stat_txt(id: String) -> String:
	var it = EQ.item(id); var a = []
	var st = it.get("st", {})
	if str(it.get("kind")) == "ml":
		var ak = J.num(it.get("atk_k", 1)); var hk = J.num(it.get("hp_k", 1))
		a.append(L("每人戰力 %.2f", "每人戰力 %.2f") % load("res://game/militia/ml_data.gd").pw(int(J.num(it.tier))))
		if absf(ak - 1.0) > 0.001 or absf(hk - 1.0) > 0.001: a.append(L("攻×%.2f 血×%.2f", "攻×%.2f 血×%.2f") % [ak, hk])
		else: a.append(L("均衡", "均衡"))
		return "　".join(a)
	if st is Dictionary:
		for s in ["atk", "hp", "taken", "energy", "aspd", "spd", "heal_in"]:
			if st.has(s): a.append("%s%+d%%" % [STW[s], int(round(J.num(st[s]) * 100))])
	if str(it.get("tag", "")) != "": a.append(L("補標籤「%s」（%s）", "補標籤「%s」（%s）") % [it.tag, TAGW.get(str(it.tag), "")])
	if str(it.get("sc", "")) != "": a.append(L("同聲同氣「%s」", "同聲同氣「%s」") % SCW.get(str(it.sc), str(it.sc)))
	if EQ.plus(id) > 0 and str(it.get("kind")) == "eq": a.append(L("（已計加工 +%d%%）", "（已計加工 +%d%%）") % int(round(EQ.plus(id) * J.num(EQ.D().get("PLUS", {}).get("per", 0.08)) * 100)))
	return "　".join(a)
# [補丁43] 數值（計埋加工）
static func stat_txt_plus(id: String, cls := "") -> String:
	var it = EQ.item(id)
	if str(it.get("kind")) == "ml": return stat_txt(id)
	var a = []
	var stv = EQ.item_st(id, cls)
	for s0 in ["atk", "hp", "taken", "energy", "aspd", "spd", "heal_in"]:
		if stv.has(s0): a.append("%s%+d%%" % [STW[s0], int(round(J.num(stv[s0]) * 100))])
	if str(it.get("tag", "")) != "": a.append(L("補標籤「%s」", "補標籤「%s」") % it.tag)
	if str(it.get("sc", "")) != "": a.append(L("同聲同氣「%s」", "同聲同氣「%s」") % SCW.get(str(it.sc), str(it.sc)))
	return "　".join(a)
static func meta_txt(id: String) -> String:   # 類別、套裝
	var it = EQ.item(id); var a = []
	if EQ.cat_of(id) != "": a.append(L("%s類（%s穿多 20%%）", "%s類（%s穿加 20%%）") % [EQ.cat_name(EQ.cat_of(id)), {"重": L("坦、戰", "坦、戰"), "輕": L("刺、射", "刺、射"), "巧": L("法、輔、醫", "法、輔、醫")}.get(EQ.cat_of(id), "")])
	var sk = str(it.get("set", ""))
	if sk != "":
		var S0 = EQ.D().get("SETS", {}).get(sk, {})
		a.append(L("【%s】%s；%s", "【%s】%s；%s") % [EQ.T(S0.get("n", [sk, sk])), EQ.T(S0.get("b2", {}).get("d", ["", ""])), EQ.T(S0.get("b3", {}).get("d", ["", ""]))])
	if str(it.get("kind")) == "ex":   # [p45] 有 plus_d（軍團王：升招牌技）就顯示佢；修正舊字串「+5%%」冇 format 照出兩個 %
		var pd = it.get("plus_d")
		if pd is Array and pd.size() >= 2: a.append(L(str(pd[0]), str(pd[1])))
		else: a.append(L("加工令王牌技升級（每級 +5%，+5、+10 各快 2 秒）", "加工讓王牌技升級（每級 +5%，+5、+10 各快 2 秒）"))
	return "　".join(a)
static func plus_txt(id: String) -> String:
	var c = EQ.plus_cost(id); var a = []
	for m in c.mat: a.append("%s %d/%d" % [M.name(str(m)), int(M.amt(str(m))), int(c.mat[m])])
	a.append(L("冥幣 %d", "冥幣 %d") % int(c.coins))
	return "　".join(a)
static func rec_txt(id: String) -> String:
	var it = EQ.item(id); var a = []
	var r = it.get("rec", {})
	if r is Dictionary:
		for m in r: a.append("%s %d/%d" % [M.name(str(m)), int(M.amt(str(m))), int(J.num(r[m]))])
	if J.num(it.get("coin", 0)) > 0: a.append(L("冥幣 %d", "冥幣 %d") % int(J.num(it.coin)))
	return "　".join(a)
static func full_name(id: String) -> String:
	var it = EQ.item(id)
	if str(it.get("kind")) in ["eq", "ex"]:
		var pl = EQ.plus(id)
		var cat = EQ.cat_name(EQ.cat_of(id)) if EQ.cat_of(id) != "" else L("專屬", "專屬")
		return "%s%s〔%s・%s〕" % [EQ.name_of(id), ("+%d" % pl) if pl > 0 else "", EQ.grade_name(EQ.grade_of(id)), cat]
	return EQ.name_of(id)

# ---------------- 小部件 ----------------
class IconC extends Control:
	var id := ""
	var ring := true
	func _draw() -> void:
		if id == "":
			var c = size * 0.5
			draw_circle(c, minf(size.x, size.y) * 0.46, Color(0, 0, 0, 0.12))
			draw_arc(c, minf(size.x, size.y) * 0.46, 0, TAU, 32, Color("#8a7a5a"), 1.5)
			return
		var ctx = Ctx.new(self)
		load("res://game/equip/eq_art.gd").icon(ctx, id, size.x * 0.5, size.y, minf(size.x, size.y), ring)
class PreviewC extends Control:
	var k := ""
	var w := {}
	var last := Rect2()
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.17, 0.12, 0.1, 0.92))
		var ctx = Ctx.new(self)
		last = load("res://game/equip/eq_view.gd").preview(ctx, k, w, Rect2(Vector2(6, 6), size - Vector2(12, 12)))
		draw_rect(Rect2(Vector2.ZERO, size), Color("#6a5040"), false, 2.0)
static func icon_c(id: String, sz: float) -> Control:
	var c = IconC.new(); c.id = id; c.custom_minimum_size = Vector2(sz, sz); c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c
static func _lbl(t: String, sz := 15, col := UIKit.INKTXT, w := 700) -> Label:
	var l = UIKit.label(t, sz, col, "sans", w); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l
static func _btn(t: String, kind: String, en: bool, f: Callable) -> Button:
	var b = UIKit.btn(t, kind, true); b.disabled = not en; b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(84, 40); b.pressed.connect(f)
	return b

# ---------------- 浮動面板（CanvasLayer 疊最上） ----------------
static func popup(title: String, w := 440.0) -> VBoxContainer:
	close_popup()
	var tree = Engine.get_main_loop()
	var cl = CanvasLayer.new(); cl.layer = 60; cl.name = "EqPopup"
	var bg = ColorRect.new(); bg.color = Color(0, 0, 0, 0.55); bg.set_anchors_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_STOP; cl.add_child(bg)
	var vs = tree.root.get_visible_rect().size if tree is SceneTree else Vector2(540, 960)
	var pw = minf(w, vs.x - 20)
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(UIKit.PAPER, 10, UIKit.PAPERLINE, 2, Vector4(12, 10, 12, 12)))
	pc.position = Vector2((vs.x - pw) * 0.5, 40); pc.size = Vector2(pw, vs.y - 80); pc.custom_minimum_size = pc.size; cl.add_child(pc)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 8); pc.add_child(v)
	var h = HBoxContainer.new(); v.add_child(h)
	var tl = UIKit.label(title, 20, UIKit.CINNABAR2, "serif", 900); tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; h.add_child(tl)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(42, 40); cb.focus_mode = Control.FOCUS_NONE; cb.pressed.connect(close_popup); h.add_child(cb)
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; v.add_child(sc)
	var body = VBoxContainer.new(); body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; body.add_theme_constant_override("separation", 6); sc.add_child(body)
	if tree is SceneTree: tree.root.add_child(cl)
	popup_root = cl
	cl.set_meta("body", body); cl.set_meta("title", title)
	return body
static func close_popup() -> void:
	if popup_root != null and is_instance_valid(popup_root): popup_root.queue_free()
	popup_root = null

# ---------------- 兵器檔資料卡（mv_scene._fill_sheet 掛鈎） ----------------
static func sheet_rows(sc, box: Control) -> void:
	if not EQ.on(): return
	var t = EQ.stall_star()
	var l = EQ.ml_items(t)
	var pb = PanelContainer.new(); pb.add_theme_stylebox_override("panel", UIKit.sb(Color(0.4, 0.25, 0.1, 0.10), 8, Color("#b08a50"), 1, Vector4(8, 4, 8, 6))); box.add_child(pb)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 4); pb.add_child(vb)
	if l.size() > 1:
		vb.add_child(_lbl(L("今期賣俾遊魂（揀一款）：", "本期賣給遊魂（選一款）："), 15, Color("#4a2a10"), 900))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 6); vb.add_child(hb)
		for id in l:
			var cur = EQ.ml_pick(t) == id
			var bx = HBoxContainer.new(); bx.add_theme_constant_override("separation", 2)
			var b = _btn(("● " if cur else "") + EQ.name_of(id), "gold" if cur else "", true, func():
				EQ.set_ml_pick(t, id)
				if sc != null and sc.has_method("_fill_sheet"): sc._fill_sheet())
			b.custom_minimum_size = Vector2(150, 44); b.name = "MlPick_" + id
			bx.add_child(icon_c(id, 36)); bx.add_child(b); hb.add_child(bx)
		vb.add_child(_lbl(stat_txt(EQ.ml_pick(t)) + "　" + L("用料：", "用料：") + rec_txt(EQ.ml_pick(t)), 13, Color("#5a4a30")))
	var nb = _btn(L("訂製名鬼裝備（倉庫 %d 件）", "訂製名鬼裝備（倉庫 %d 件）") % inv_total(), "gold", true, func(): open_craft())
	nb.custom_minimum_size = Vector2(0, 44); nb.name = "EqCraftBtn"; vb.add_child(nb)
static func inv_total() -> int:
	var e = EQ.st(); var n = 0
	if e == null: return 0
	for id in e.inv: n += int(J.num(e.inv[id]))
	return n

# ---------------- 訂製面板 ----------------
static func open_craft() -> void:
	var body = popup(L("紙紮兵器檔・訂製名鬼裝備", "紙紮兵器攤・訂製名鬼裝備"), 480)
	_fill_craft(body)
static func _fill_craft(body: VBoxContainer) -> void:
	for c in body.get_children(): body.remove_child(c); c.queue_free()
	body.add_child(_lbl(L("兵器檔★%d　冥幣 %d　訂好入倉，喺「鬼怪名冊」換裝。", "兵器攤★%d　冥幣 %d　訂好入倉，在「鬼怪名冊」換裝。") % [EQ.stall_star(), int(EQ.coins())], 14, UIKit.INKDIM))
	body.add_child(_lbl(L("紙紮師傅加工：倉庫有嘅裝備可以加工 +1 至 +10（每級 +8%）；名品靠回陽間燒落嚟、絕品同專屬物靠打魔王。", "紙紮師傅加工：倉庫有的裝備可以加工 +1 至 +10（每級 +8%）；名品靠回陽間燒下來、絕品和專屬物靠打魔王。"), 13, UIKit.INKDIM))
	for sl in EQ.SLOTS:
		body.add_child(UIKit.label(EQ.slot_name(sl), 17, UIKit.CINNABAR2, "serif", 900))
		for id in EQ.items("eq", sl): body.add_child(_craft_row(body, id))
	var exs = []
	for id in EQ.items("ex", "ex"): if EQ.n_inv(id) > 0: exs.append(id)
	if exs.size():
		body.add_child(UIKit.label(EQ.slot_name("ex"), 17, UIKit.CINNABAR2, "serif", 900))
		for id in exs: body.add_child(_craft_row(body, id))
static func _craft_row(body: VBoxContainer, id: String) -> Control:
	var ok = EQ.unlocked(id)
	var pc = PanelContainer.new(); pc.name = "Craft_" + id
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.95) if ok else Color(0.78, 0.75, 0.7, 0.9), 8, EQ.grade_col(EQ.grade_of(id)), 2, Vector4(8, 6, 8, 6)))
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); pc.add_child(h)
	h.add_child(icon_c(id, 48))
	var v = VBoxContainer.new(); v.size_flags_horizontal = Control.SIZE_EXPAND_FILL; v.add_theme_constant_override("separation", 1); h.add_child(v)
	v.add_child(_lbl(full_name(id) + ("　" + L("倉 %d（空 %d）", "倉 %d（閒 %d）") % [EQ.n_inv(id), EQ.n_free(id)] if EQ.n_inv(id) > 0 else ""), 16, UIKit.INKTXT, 900))
	v.add_child(_lbl(stat_txt_plus(id), 14, Color("#2f5a8c"), 900))
	var mt = meta_txt(id)
	if mt != "": v.add_child(_lbl(mt, 13, Color("#6a4a20"), 700))
	v.add_child(_lbl(EQ.desc_of(id), 13, UIKit.INKDIM, 400))
	if EQ.can_craft_src(id): v.add_child(_lbl((L("用料：", "用料：") + rec_txt(id)) if ok else EQ.lock_txt(id), 13, UIKit.INKTXT if ok else Color("#9c2219"), 700))
	else: v.add_child(_lbl(EQ.src_txt(id), 13, Color("#7a3a8a"), 700))
	if EQ.n_inv(id) > 0 and EQ.plus(id) < 10: v.add_child(_lbl(L("加工 +%d：", "加工 +%d：") % (EQ.plus(id) + 1) + plus_txt(id), 13, UIKit.INKTXT, 700))
	var a = VBoxContainer.new(); a.add_theme_constant_override("separation", 4); h.add_child(a)
	if EQ.can_craft_src(id):
		var mb = _btn(L("訂製", "訂製"), "gold", EQ.can_make(id), func():
			EQ.make(id); _fill_craft(body))
		mb.name = "Make_" + id; a.add_child(mb)
	if EQ.n_inv(id) > 0:
		var pb = _btn(L("加工", "加工") if EQ.plus(id) < 10 else L("已到頂", "已到頂"), "gold", EQ.can_plus(id) == "", func():
			if EQ.do_plus(id):   # [sfx43]＋[vfx 第四批] 加工／專屬物加工升王牌技
				Snd.play("eq_plus"); VP.burst("up_ace" if id.begins_with("ex_") else "up_plus")
			_fill_craft(body))
		pb.name = "Plus_" + id; a.add_child(pb)
	if EQ.n_free(id) > 0:
		var rb = _btn(L("回收 +%d", "回收 +%d") % int(J.num(EQ.item(id).get("price", 0))), "", true, func():
			EQ.recycle(id); _fill_craft(body))
		a.add_child(rb)
	return pc

# ---------------- 名冊：三格（menus._gcard 掛鈎） ----------------
static func roster_strip(card: PanelContainer, hb: Control, gid: String) -> void:
	if not EQ.on() or EQ.ghost(gid) == null: return
	card.remove_child(hb)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 4); card.add_child(v); v.add_child(hb)
	var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 6); row.name = "EqStrip"; v.add_child(row)
	var w = EQ.worn(gid)
	var sls = EQ.SLOTS.duplicate()
	var gk = EQ.k_of(gid)
	if not EQ.item(EQ.ex_id(gk)).is_empty() and load("res://game/soul/soul_up.gd").born_ace(gk): sls.append("ex")   # [補丁43] 天生王牌：專屬物格
	for sl in sls:
		var id = str(w.get(sl, ""))
		var b = Button.new(); b.focus_mode = Control.FOCUS_NONE; b.name = "Slot_" + sl
		b.custom_minimum_size = Vector2(0, 50); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var gc = EQ.grade_col(EQ.grade_of(id)) if id != "" else Color("#b89a52")
		for stn in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(stn, UIKit.sb(Color(0, 0, 0, 0.06 if stn == "normal" else 0.12), 6, gc, 2 if id != "" else 1, Vector4(4, 2, 4, 2)))
		var hb2 = HBoxContainer.new(); hb2.set_anchors_preset(Control.PRESET_FULL_RECT); hb2.offset_left = 4; hb2.offset_right = -4
		hb2.add_theme_constant_override("separation", 3); hb2.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(hb2)
		var ic = icon_c(id, 38); ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb2.add_child(ic)
		var lb = UIKit.label(EQ.name_of(id) if id != "" else EQ.slot_name(sl), 14, UIKit.INKTXT if id != "" else UIKit.INKDIM, "sans", 900 if id != "" else 700)
		lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; lb.clip_text = true; lb.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; lb.size_flags_vertical = Control.SIZE_FILL; lb.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb2.add_child(lb)
		b.pressed.connect(func(): open_slot(gid, sl))
		row.add_child(b)
	var row2 = HBoxContainer.new(); row2.add_theme_constant_override("separation", 6); v.add_child(row2)
	var ab = _btn(L("一鍵穿戴", "一鍵穿戴"), "", true, func():
		var s0 = set_lv(gid); var t0 = _set_tier(gid)   # [sfx43] 一鍵穿戴；套裝湊多一級再加一聲＋[vfx] 套裝湊齊
		if EQ.auto_wear(gid) > 0: wear_sfx(gid, s0)
		_set_fx(gid, t0); _changed())
	ab.name = "AutoWear"; ab.custom_minimum_size = Vector2(110, 38); row2.add_child(ab)
	var sx = []
	for si in EQ.set_info(gid): sx.append("%s %d/3" % [si.name, si.n])
	if sx.size():
		var sl0 = _lbl(L("套裝：", "套裝：") + "　".join(sx), 13, Color("#6a4a20"), 900)
		sl0.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row2.add_child(sl0)
	var ti = EQ.tag_info(gid)
	if str(ti.tag) != "":
		var why = {"": L("生效", "生效"), "own": L("本身已有，冇效", "本身已有，無效"), "full": L("本領已滿 3 個，冇效", "本領已滿 3 個，無效")}[str(ti.why)]
		v.add_child(_lbl(L("裝備標籤「%s」：%s", "裝備標籤「%s」：%s") % [ti.tag, why], 13, Color("#2f5a8c") if str(ti.why) == "" else UIKit.INKDIM))

# ---------------- 換裝面板 ----------------
static func open_slot(gid: String, sl: String) -> void:
	var g = EQ.ghost(gid)
	if g == null: return
	var body = popup(L("%s・%s", "%s・%s") % [J.str(g.get("name")), EQ.slot_name(sl)], 460)
	_fill_slot(body, gid, sl)
static func _fill_slot(body: VBoxContainer, gid: String, sl: String) -> void:
	for c in body.get_children(): body.remove_child(c); c.queue_free()
	var k = EQ.k_of(gid)
	var pv = PreviewC.new(); pv.k = k; pv.w = EQ.worn(gid); pv.custom_minimum_size = Vector2(0, 230); pv.name = "EqPreview"; body.add_child(pv)
	var b = EQ.bonus(gid)
	var parts = []
	for s in ["atk", "hp", "taken", "energy", "aspd", "spd", "heal_in"]:
		if absf(J.num(b[s])) > 0.0001: parts.append("%s%+d%%" % [STW[s], int(round(J.num(b[s]) * 100))])
	body.add_child(_lbl(L("合計：", "合計：") + ("　".join(parts) if parts.size() else L("冇", "無")) + "　" + L("（封頂：攻／血 +45%）", "（封頂：攻／血 +45%）"), 14, Color("#2f5a8c"), 900))
	var cls = load("res://game/rts/roles.gd").cls_of(k)
	body.add_child(_lbl(L("職業：%s　啱著：%s類（數值 +20%%）", "職業：%s　適合：%s類（數值 +20%%）") % [cls, EQ.cat_name(EQ.cat_for_cls(cls))], 13, Color("#6a4a20"), 900))
	for si in EQ.set_info(gid):
		var ds = []
		for bb in si.on: ds.append(EQ.T(bb.get("d", ["", ""])))
		body.add_child(_lbl(L("【%s】%d 件：", "【%s】%d 件：") % [si.name, si.n] + ("；".join(ds) if ds.size() else L("未夠 2 件", "未滿 2 件")), 13, Color("#6a4a20"), 900))
	var own = EQ.own_tags(k)
	body.add_child(_lbl(L("本身標籤：%s　裝備最多補 1 個", "本身標籤：%s　裝備最多補 1 個") % ("、".join(own) if own.size() else L("冇", "無")), 13, UIKit.INKDIM))
	var cur = str(EQ.worn(gid).get(sl, ""))
	if cur != "":
		var ub = _btn(L("卸下 %s", "卸下 %s") % EQ.name_of(cur), "", true, func():
			EQ.unwear(gid, sl); _changed(); _fill_slot(body, gid, sl))
		ub.custom_minimum_size = Vector2(0, 42); ub.name = "Unwear"; body.add_child(ub)
	var any = false
	for id in EQ.items("ex" if sl == "ex" else "eq", sl):
		if EQ.n_inv(id) <= 0: continue
		any = true
		var pc = PanelContainer.new(); pc.name = "Opt_" + id
		pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.95), 8, EQ.grade_col(EQ.grade_of(id)), 3 if id == cur else 1, Vector4(8, 6, 8, 6)))
		var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); pc.add_child(h)
		h.add_child(icon_c(id, 46))
		var v = VBoxContainer.new(); v.size_flags_horizontal = Control.SIZE_EXPAND_FILL; h.add_child(v)
		v.add_child(_lbl(full_name(id) + "　" + L("閒置 %d", "閒置 %d") % EQ.n_free(id), 15, UIKit.INKTXT, 900))
		var tx = stat_txt_plus(id, cls)
		if EQ.cat_match(id, cls): tx += "　" + L("（啱類別 +20%）", "（適合類別 +20%）")
		var tg = str(EQ.item(id).get("tag", ""))
		if tg != "" and own.has(tg): tx += "　" + L("（本身已有）", "（本身已有）")
		elif tg != "" and own.size() >= 3: tx += "　" + L("（本領已滿）", "（本領已滿）")
		var sc = str(EQ.item(id).get("sc", ""))
		if sc != "" and EQ.own_scares(k).has(sc): tx += "　" + L("（同聲同氣 攻+8%）", "（同聲同氣 攻+8%）")
		v.add_child(_lbl(tx, 13, Color("#2f5a8c"), 700))
		var why = EQ.why_not(gid, id)
		if id == cur: h.add_child(_lbl(L("已穿", "已穿"), 14, UIKit.CINNABAR2, 900))
		else:
			var wb = _btn(L("穿上", "穿上"), "gold", why == "", func():
				var s0 = set_lv(gid); var t0 = _set_tier(gid)   # [sfx43]＋[vfx]
				if EQ.wear(gid, id): wear_sfx(gid, s0)
				_set_fx(gid, t0); _changed(); _fill_slot(body, gid, sl))
			wb.name = "Wear_" + id; h.add_child(wb)
			if why != "": v.add_child(_lbl(why, 12, Color("#9c2219")))
		body.add_child(pc)
	if not any: body.add_child(_lbl(L("專屬物要打魔王先有機會掉。", "專屬物要打魔王才有機會掉落。") if sl == "ex" else L("倉庫冇呢格嘅裝備：去大排檔「紙紮兵器檔」訂製。", "倉庫沒有這格的裝備：去大排檔「紙紮兵器攤」訂製。"), 14, UIKit.INKDIM))
static func _changed() -> void:
	if on_change is Callable and on_change.is_valid(): on_change.call()

# [sfx43] 套裝級數（任何一套 ≥2 件＝1，≥3 件＝2）；著完裝如果升咗級就再「叮」一聲
static func set_lv(gid) -> int:
	var lv = 0
	for si in EQ.set_info(gid): lv = maxi(lv, 2 if int(si.n) >= 3 else (1 if int(si.n) >= 2 else 0))
	return lv
static func wear_sfx(gid, s0: int) -> void:
	Snd.play("eq_wear")
	if set_lv(gid) > s0:
		var tr = Engine.get_main_loop()
		if tr is SceneTree: (tr as SceneTree).create_timer(0.35).timeout.connect(func(): Snd.play("eq_set"))
