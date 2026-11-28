# 過勞鬼市集畫面（市集程序組 M1）：頂部五條街名牌列（小地圖）、左右滑動切街、未開街鎖牌。
# mv_scene 喺 HUD 之後叫 draw_strip(sc, ctx)；撳嘢：tap(sc, p)（畫面座標）；滑動：swipe(sc, ev, k)（合一地圖由 nv_village 轉入）。
extends RefCounted

const MK = preload("res://game/market/mk_data.gd")
const STRIP_H := 40.0
static var _sw = null   # 滑動起點（畫面座標）

static func on(sc) -> bool:
	if not MK.active() or sc == null or sc.sim == null or sc.sim.st() == null: return false
	if sc.get("zone") and not load("res://game/zone/zone_data.gd").revealed("market"): return false
	return true
static func strip_y(sc) -> float: return float(sc.top_pad) + (float(sc.EHUD_H) if sc.embed else float(sc.HUD_H))
static func strip_rect(sc) -> Rect2: return Rect2(0, strip_y(sc), sc.FW, STRIP_H)

static func _alert(sc, id: String) -> bool:   # 呢條街有檔畀孤魂霸咗
	var os = sc.sim.war.occ_sid()
	return os != "" and MK.street_of(sc.sim.ci(), os) == id

static func draw_strip(sc, ctx) -> void:
	if not on(sc): return
	var y0 = strip_y(sc); var ids = MK.ids(); var n = maxi(1, ids.size())
	ctx.fillStyle = "rgba(14,8,18,.82)"; ctx.fillRect(0, y0, sc.FW, STRIP_H)
	var x0 = 22.0; var cw = (sc.FW - 44.0) / n
	sc._txt(ctx, "‹", 11, y0 + STRIP_H / 2.0 + 1, 22, Color("#e8d6b0"), "center", 900, 3); sc._btns["mks_prev"] = Rect2(0, y0, 22, STRIP_H)
	sc._txt(ctx, "›", sc.FW - 11, y0 + STRIP_H / 2.0 + 1, 22, Color("#e8d6b0"), "center", 900, 3); sc._btns["mks_next"] = Rect2(sc.FW - 22, y0, 22, STRIP_H)
	var cur = MK.cur(); var ci = sc.sim.ci()
	for i in ids.size():
		var id: String = ids[i]; var x = x0 + i * cw
		var op = MK.is_open(id); var sel = id == cur
		var fill = "rgba(243,214,138,.95)" if sel else ("rgba(70,52,40,.92)" if op else "rgba(40,34,38,.85)")
		Art.rr(ctx, x + 2, y0 + 5, cw - 4, STRIP_H - 10, 7, fill, "#f3d68a" if sel else "#5e4a30", 1.5)
		var col = Color("#3a2414") if sel else (Color("#f5e8cc") if op else Color("#8a7f78"))
		var nm = MK.name(id) if op else "鎖・" + MK.name(id)
		sc._txt(ctx, nm, x + cw / 2.0, y0 + STRIP_H / 2.0 + 1, 13 if nm.length() <= 4 else 11, col, "center", 900, 0)
		if MK.sids_on(ci, id).is_empty() and op: sc._txt(ctx, "無貨", x + cw - 12, y0 + 10, 9, Color("#c9b9a0"), "center", 700, 0)
		if _alert(sc, id):   # 被霸：紅點閃
			var a = 0.55 + 0.45 * sin(float(sc.t) * 6.0)
			ctx.globalAlpha = a; Art.el(ctx, x + cw - 8, y0 + 9, 5, 5, "#e0392b", "#fff0e0", 1.0); ctx.globalAlpha = 1.0
		sc._btns["mks:" + id] = Rect2(x, y0, cw, STRIP_H)
	if not MK.is_open(cur):   # 未開街：鎖牌（畫面中間偏上，唔擋頂部）
		var ly = y0 + STRIP_H + 26.0; var lw = sc.FW - 60.0
		Art.rr(ctx, 30, ly, lw, 62, 10, "rgba(20,12,16,.88)", "#b8322a", 2.0)
		sc._txt(ctx, MK.name(cur) + "　未開放", sc.FW / 2.0, ly + 20, 17, Color("#f3d68a"), "center", 900, 0, "serif")
		var gid = MK.kpi_gate(cur)
		var kt = MK.lock_text(cur, ci)
		if gid != "" and MK.KG().on() and MK.KG().active(gid): kt = ("撳呢度：%s 考核中" if MK.yue() else "點這裡：%s 考核中") % str(MK.KG().gate(gid).get("boss_n", ""))
		sc._txt(ctx, kt, sc.FW / 2.0, ly + 44, 13, Color("#f5e8cc"), "center", 700, 0)
		sc._btns["mk_lock"] = Rect2(30, ly, lw, 62)
	elif MK.sids_on(ci, cur).is_empty():
		var ly2 = y0 + STRIP_H + 26.0
		Art.rr(ctx, 50, ly2, sc.FW - 100, 40, 10, "rgba(20,12,16,.8)", "#5e4a30", 1.5)
		sc._txt(ctx, "本章呢條街未有貨" if MK.yue() else "本章這條街還沒有貨", sc.FW / 2.0, ly2 + 21, 13, Color("#f5e8cc"), "center", 700, 0)

static func go(sc, id: String) -> bool:
	if not sc.sim.market_street(id): return false
	if sc.has_method("close_sheet"): sc.close_sheet()
	sc._snd("click")
	return true
static func step(sc, dir: int) -> void:
	var L = MK.ids(); if L.is_empty(): return
	var i = (L.find(MK.cur()) + dir + L.size()) % L.size()
	go(sc, L[i])

static func tap(sc, p: Vector2) -> bool:   # 畫面座標
	if not on(sc): return false
	if not MK.is_open(MK.cur()) and sc._btns.has("mk_lock") and sc._btns.mk_lock.has_point(p):   # 鎖牌：打開市集考核卡
		var gid = MK.kpi_gate(MK.cur())
		if gid != "" and MK.KG().on() and MK.KG().active(gid):
			var main = sc.get_tree().root.get_node_or_null("Main")
			if main != null: load("res://game/kpi/kpi_ui.gd").open(main, gid)
		sc._snd("click"); return true
	if not strip_rect(sc).has_point(p): return false
	if sc._btns.has("mks_prev") and sc._btns.mks_prev.has_point(p): step(sc, -1); return true
	if sc._btns.has("mks_next") and sc._btns.mks_next.has_point(p): step(sc, 1); return true
	for id in MK.ids():
		var k = "mks:" + id
		if sc._btns.has(k) and sc._btns[k].has_point(p):
			if id == MK.cur(): sc._snd("click")
			else: go(sc, id)
			return true
	return true

# 滑動：喺街名牌列按落，左右拉過 40px 就切街（唔畀地圖鏡頭食咗）。回 true＝食咗呢個事件
static func swipe(sc, ev: InputEvent, k := 1.0) -> bool:
	if not on(sc): _sw = null; return false
	var kk = maxf(0.01, k)
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		var p = ev.position / kk
		if ev.pressed:
			if strip_rect(sc).has_point(p): _sw = p; return true
			return false
		if _sw != null:
			var dx = p.x - _sw.x
			if absf(dx) > 40.0: step(sc, -1 if dx > 0 else 1)
			else: tap(sc, _sw)
			_sw = null; return true
		return false
	if ev is InputEventMouseMotion and _sw != null: return true
	return false
