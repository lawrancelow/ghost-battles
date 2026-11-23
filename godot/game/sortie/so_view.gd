# [sortie] 野外出擊：據點敵人（交 rts_view 畫實體）、等級木牌、已清空／重生倒數、出擊小卡（全部 static；冇 class_name）
extends RefCounted

const SO = preload("res://game/sortie/so_data.gd")
const ZD = preload("res://game/zone/zone_data.gd")

static var _pv := {}       # 據點 key → 預覽單位
static var card = null     # 而家開住嘅出擊小卡
static var card_key := ""
static var last_msg := ""

static func L(yue: String, zhs: String) -> String: return SO.L(yue, zhs)
static func _rts(): return load("res://game/rts/rts.gd")

# rts_view._want 掛鈎：未出擊、未清空嘅據點企住啲敵人
static func want() -> Array:
	var o = []
	if not ZD.on(): return o
	var RTS = _rts()
	for e in SO.camps():
		var k = SO.key(e)
		var s = SO.state(e)
		if s == "cleared" or s == "out": _pv.erase(k); continue
		if not _pv.has(k):
			var stg = load("res://game/soul/soul_data.gd").guard_stage(e, SO.stage_of(e))   # [soul] 駐守名鬼企喺據點
			var pth = load("res://game/sortie/so_data.gd").path_of(e, e.pos)   # [integ]
			var din = (pth[pth.size() - 1] - pth[pth.size() - 2]).normalized() if pth.size() >= 2 else Vector2(0, -1)
			var pos = RTS.SIM.camp_layout(e.pos, stg.en.size(), din)
			var ET = J.G.get("ENEMY_T")
			var us = []
			for i in stg.en.size():
				var kk = str(stg.en[i])
				var nm = str(ET[kk][2]) if ET is Dictionary and ET.has(kk) else kk
				us.append({"side": 1.0, "k": kk, "name": nm, "hp": 1.0, "maxhp": 1.0, "st": {}, "boss": int(e.ring) >= 4 and i == stg.en.size() - 1, "p": pos[i], "post": pos[i],
					"face": -1.0 if din.x >= 0 else 1.0, "preview": true})
			_pv[k] = us
		var us2: Array = _pv[k]
		for i in us2.size(): o.append(["so:%s:%d" % [k, i], us2[i], null])
	return o

# rts_view._draw_txt 掛鈎：據點木牌（等級、圈、狀態）
static func draw(v, n: CanvasItem, f: Font, vr: Rect2) -> void:
	if not ZD.on(): return
	for e in SO.camps():
		var at: Vector2 = e.pos
		if not vr.has_point(at): continue
		var s = SO.state(e)
		v._at(n, at + Vector2(0, 40))
		var l1 = SO.short(e)
		var l2 = ""
		var bg = Color(0.32, 0.2, 0.1, 0.95); var bd = Color("#e8b060"); var col = Color("#fff0d0")
		match s:
			"open":
				var c = SO.cst(e)
				l2 = L("首勝有獎", "首勝有獎") if not J.t(c.get("first")) else L("可重複出擊", "可重複出擊")
			"out": l2 = L("出擊中", "出擊中"); bd = Color("#7ac0b0")
			"locked":
				l2 = L("未開放", "未開放")
				bg = Color(0.18, 0.16, 0.16, 0.9); bd = Color("#6a6060"); col = Color("#c8c0b8")
			"cleared":
				var left = int(ceil(SO.cleared_left_s(e)))
				l1 = SO.short(e) + "　" + L("已清空", "已清空")
				l2 = L("重生 %d:%02d", "重生 %d:%02d") % [left / 60, left % 60]
				bg = Color(0.2, 0.2, 0.2, 0.88); bd = Color("#909090"); col = Color("#e0e0e0")
		var w = maxf(f.get_string_size(l1, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x, f.get_string_size(l2, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x)
		n.draw_style_box(v._box(Color(0, 0, 0, 0.35), 6), Rect2(-w / 2 - 6, -13, w + 16, 44))
		n.draw_style_box(v._box(bd, 6), Rect2(-w / 2 - 8, -16, w + 16, 44))
		n.draw_style_box(v._box(bg, 5), Rect2(-w / 2 - 6, -14, w + 12, 40))
		v._str(n, f, l1, 0, 4, 15, col, 0)
		v._str(n, f, l2, 0, 22, 14, Color(col, 0.85) if s != "open" else Color("#ffd27a"), 0)
		if s == "cleared":   # 空營：一面倒咗嘅旗
			v._at(n, at + Vector2(0, -6))
			n.draw_line(Vector2(-14, 8), Vector2(18, -6), Color(0.35, 0.25, 0.15, 0.9), 3.0)
			n.draw_colored_polygon(PackedVector2Array([Vector2(18, -6), Vector2(8, -18), Vector2(2, -6)]), Color(0.5, 0.15, 0.1, 0.8))
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

# zone_view.tap 掛鈎：撳中據點 → 出擊小卡
static func hit(p: Vector2) -> Dictionary:
	if not ZD.on(): return {}
	for e in SO.camps():
		if Rect2(e.pos.x - 75, e.pos.y - 110, 150, 210).has_point(p): return e
	return {}
static func tap(_main, p: Vector2) -> bool:
	var e = hit(p)
	if e.is_empty(): return false
	if SO.state(e) == "out":
		var op = _rts().op_for(SO.sid_of(e))
		if op != null: _rts().focus(op)
		return true
	open_card(e)
	return true

# ======================= 出擊小卡 =======================
static func _host():
	var RV = load("res://game/rts/rts_view.gd")
	var v = RV.inst
	if v == null or not is_instance_valid(v): return null
	if v.get("ui") == null: v._build()
	return v.ui
static func close_card() -> void:
	if card != null and is_instance_valid(card): card.queue_free()
	card = null; card_key = ""
static func card_lines(e: Dictionary) -> Dictionary:
	var lu = SO.lineup(); var cs = SO.cost(e, lu); var c = SO.cst(e); var r = SO.ri(e.ring)
	var o = {}
	o["head"] = SO.title(e) + L("　第%d圈", "　第%d圈") % int(e.ring)
	o["state"] = SO.state(e)
	o["team"] = L("陣容：名鬼 %d　陰兵 %d 隊　遊魂兵 %d 隊", "陣容：名鬼 %d　陰兵 %d 隊　遊魂兵 %d 隊") % [lu.hero, lu.yin, lu.ml]
	var parts = []
	for k in ["buns", "coins"]:
		var need = float(cs.get(k, 0))
		parts.append([("%s %d（有 %d）" % [SO.res_name(k), int(need), int(SO.have(k))]), SO.have(k) >= need])
	o["cost"] = parts
	o["afford"] = SO.afford(cs)
	o["cs"] = cs
	o["normal"] = L("每次打贏：冥幣 %d、好評 %d、棺材板 %d", "每次打贏：冥幣 %d、好評 %d、棺材板 %d") % [int((SO.REW_COIN + 20.0) * e.lv), int(8.0 * e.lv), SO.REW_PLANK[r]]
	var ch = {}
	for k in SO.FIRST_CHEST[r]: ch[k] = int(ch.get(k, 0)) + 1
	var cp = []
	for k in ch: cp.append("%s×%d" % [{"g": L("綠箱", "綠箱"), "b": L("藍箱", "藍箱"), "p": L("紫箱", "紫箱")}[k], ch[k]])
	o["first"] = (L("首勝（已領）", "首勝（已領）") if J.t(c.get("first")) else L("首勝特殊獎：", "首勝特殊獎：")) + "、".join(cp) + L("、冥幣 %d", "、冥幣 %d") % int(SO.FIRST_COIN * e.lv)
	o["rare"] = L("有機會獲得（極稀有）：%s", "有機會獲得（極稀有）：%s") % SO.rare_text(r)
	o["pity"] = L("保底：再打贏 %d 次必得", "保底：再打贏 %d 次必得") % SO.pity_left(e)
	o["soul"] = load("res://game/soul/soul_ui.gd").card_info(e)   # [soul] 駐守鬼、魂魄、怨氣
	return o
static func open_card(e: Dictionary) -> void:
	close_card()
	var host = _host()
	if host == null: return
	var d = card_lines(e)
	var pc = PanelContainer.new(); pc.name = "SortieCard"
	var sb = UIKit.sb(Color(0.12, 0.07, 0.05, 0.96), 12, Color("#e8b060"), 2, Vector4(14, 10, 14, 10))
	sb.shadow_color = Color(0, 0, 0, 0.5); sb.shadow_size = 8
	pc.add_theme_stylebox_override("panel", sb)
	pc.mouse_filter = Control.MOUSE_FILTER_STOP
	pc.anchor_left = 0; pc.anchor_right = 1; pc.anchor_top = 0; pc.anchor_bottom = 0   # 擺上半（下面係 toast、行動按鈕）
	pc.offset_left = 10; pc.offset_right = -10; pc.offset_top = 232; pc.grow_vertical = Control.GROW_DIRECTION_END
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 4); pc.add_child(vb)
	var lab = func(t: String, px: int, col: Color):
		var l = UIKit.label(t, px, col, "sans", 900); l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; l.custom_minimum_size = Vector2(0, 0); l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_child(l); return l
	lab.call(d.head, 20, Color("#ffe0a0"))
	match d.state:
		"cleared":
			var left = int(ceil(SO.cleared_left_s(e)))
			lab.call(L("已清空：%d:%02d 後重生", "已清空：%d:%02d 後重生") % [left / 60, left % 60], 16, Color("#c0c0c0"))
		"locked": lab.call(L("未開放：先打下上一圈據點", "未開放：先打下上一圈據點"), 16, Color("#c0c0c0"))
	load("res://game/soul/soul_ui.gd").card_rows(vb, d.soul)   # [soul]
	lab.call(d.team, 15, Color("#f0e0d0"))
	load("res://game/rts/ab_card.gd").add_to(vb, SO.stage_of(e).en, {"dark": true, "host": pc, "on_change": func(): open_card(e)})   # [abui] 偵察卡＋揀軍師
	var hb = HFlowContainer.new(); hb.add_theme_constant_override("h_separation", 10); vb.add_child(hb)
	var l0 = UIKit.label(L("出擊消耗：", "出擊消耗："), 16, Color("#ffd27a"), "sans", 900); hb.add_child(l0)
	for x in d.cost:
		var l = UIKit.label(x[0], 16, Color("#a8f0a0") if x[1] else Color("#ff7a6a"), "sans", 900); hb.add_child(l)
	lab.call(d.normal, 14, Color("#e8d8c0"))
	lab.call(d.first, 14, Color("#9a9a9a") if d.first.begins_with(L("首勝（已領）", "首勝（已領）")) else Color("#ffc080"))
	lab.call(d.rare, 14, Color("#e0a0ff"))
	lab.call(d.pity, 14, Color("#c8a0e0"))
	var bb = HBoxContainer.new(); bb.add_theme_constant_override("separation", 12); bb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_child(bb)
	var go = Button.new(); go.text = L("出擊", "出擊"); go.focus_mode = Control.FOCUS_NONE; go.custom_minimum_size = Vector2(140, 42)
	var ok = d.state == "open" and d.afford
	var gs = UIKit.sb(Color("#8a2a18") if ok else Color("#4a4440"), 8, Color("#f0b070") if ok else Color("#706860"), 2, Vector4(10, 4, 10, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: go.add_theme_stylebox_override(k, gs)
	go.add_theme_font_override("font", UIKit.font("sans", 900)); go.add_theme_font_size_override("font_size", 18)
	for k in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color"]: go.add_theme_color_override(k, Color("#fff0dc") if ok else Color("#a8a0a0"))
	go.disabled = not ok
	bb.add_child(go)
	var cl = Button.new(); cl.text = L("關閉", "關閉"); cl.focus_mode = Control.FOCUS_NONE; cl.custom_minimum_size = Vector2(100, 42)
	var cs2 = UIKit.sb(Color("#3a2c26"), 8, Color("#6a5040"), 2, Vector4(10, 4, 10, 4))
	for k in ["normal", "hover", "pressed"]: cl.add_theme_stylebox_override(k, cs2)
	cl.add_theme_font_override("font", UIKit.font("sans", 900)); cl.add_theme_font_size_override("font_size", 16)
	bb.add_child(cl)
	load("res://game/soul/soul2.gd").card_row(vb, e)   # [soul2] 抄功課
	if d.state == "open" and not d.afford: lab.call(L("資源不夠，不能出擊", "資源不夠，不能出擊"), 15, Color("#ff7a6a"))
	go.pressed.connect(func(): press_go(e))
	cl.pressed.connect(func(): close_card())
	host.add_child(pc)
	card = pc; card_key = SO.key(e)
static func press_go(e: Dictionary) -> String:
	var r = SO.dispatch(e)
	var msg = {"poor": L("資源不夠，不能出擊", "資源不夠，不能出擊"), "busy": L("而家打緊另一場，等佢打完先", "現在正在打另一場，等它打完再說"),
		"noteam": L("未有出戰隊伍：去「鬼怪」揀隊先", "還沒有出戰隊伍：先到「鬼怪」選隊"), "cleared": L("據點已清空，等重生", "據點已清空，等重生"), "locked": L("未開放", "未開放")}
	last_msg = r
	if r == "ok": close_card()
	elif msg.has(r): _rts().toast(msg[r])
	return r
