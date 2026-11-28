# 過勞鬼市集畫面（市集程序組 M1）：頂部五條街名牌列（小地圖）、左右滑動切街、未開街鎖牌。
# mv_scene 喺 HUD 之後叫 draw_strip(sc, ctx)；撳嘢：tap(sc, p)（畫面座標）；滑動：swipe(sc, ev, k)（合一地圖由 nv_village 轉入）。
extends RefCounted

const MK = preload("res://game/market/mk_data.gd")
const STRIP_H := 40.0
const PAD_X := 7.0      # 街名牌：字左右留白
const LOCK_W := 16.0    # 鎖圖示闊
const LOCK_GAP := 3.0
static var lay: Array = []   # 今格每格嘅位置（測試用）：{id, cell, lock, txt, fs}
static func lay_bad(sc) -> Array:   # 測試用：字／鎖出格、鎖同字重疊、字細過 13、格出界
	var bad: Array = []
	for i in lay.size():
		var d = lay[i]; var c: Rect2 = d.cell; var tx: Rect2 = d.txt; var lk: Rect2 = d.lock
		if int(d.fs) < 13: bad.append("%s 字太細 %d" % [d.id, int(d.fs)])
		if tx.position.x < c.position.x + 2.0 or tx.end.x > c.end.x - 2.0: bad.append("%s 字出格" % d.id)
		if lk.size.x > 0.0 and (lk.position.x < c.position.x + 2.0 or lk.end.x + 2.0 > tx.position.x): bad.append("%s 鎖同字疊／出格" % d.id)
		if c.position.x < 22.0 or c.end.x > float(sc.FW) - 22.0: bad.append("%s 格出界" % d.id)
		if i > 0 and c.position.x < (lay[i - 1].cell as Rect2).end.x: bad.append("%s 格重疊" % d.id)
	return bad
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
	var cur = MK.cur(); var ci = sc.sim.ci()
	# 每格闊度按內容分（街名字數＋鎖圖示），唔再五格平分：之前「鎖＋奢侈品店」五個字迫埋一格。字號全列一樣，放唔落先全列一齊縮，最細 13。
	var x0 = 22.0; var tot = sc.FW - 44.0
	var fs = 16; var ws: Array = []; var tws: Array = []
	while true:
		ws.clear(); tws.clear(); var sum = 0.0
		ctx.font = "900 %dpx sans-serif" % fs
		for id0 in ids:
			var tw0 = float(ctx.measureText(MK.name(id0)).width)
			var w0 = tw0 + PAD_X * 2.0 + (0.0 if MK.is_open(id0) else LOCK_W + LOCK_GAP)
			tws.append(tw0); ws.append(w0); sum += w0
		if sum <= tot or fs <= 13:
			var extra = (tot - sum) / n   # 有剩就平均分；13 號字都放唔落（街名好長）就平均收窄留白，字號唔再縮
			for k in ws.size(): ws[k] = float(ws[k]) + extra
			break
		fs -= 1
	sc._txt(ctx, "‹", 11, y0 + STRIP_H / 2.0 + 1, 22, Color("#e8d6b0"), "center", 900, 3); sc._btns["mks_prev"] = Rect2(0, y0, 22, STRIP_H)
	sc._txt(ctx, "›", sc.FW - 11, y0 + STRIP_H / 2.0 + 1, 22, Color("#e8d6b0"), "center", 900, 3); sc._btns["mks_next"] = Rect2(sc.FW - 22, y0, 22, STRIP_H)
	lay.clear()
	var x = x0
	for i in ids.size():
		var id: String = ids[i]; var cw = float(ws[i]); var tw = float(tws[i])
		var op = MK.is_open(id); var sel = id == cur
		var fill = "rgba(243,214,138,.95)" if sel else ("rgba(70,52,40,.92)" if op else "rgba(40,34,38,.85)")
		Art.rr(ctx, x + 2, y0 + 5, cw - 4, STRIP_H - 10, 7, fill, "#f3d68a" if sel else "#5e4a30", 1.5)
		var col = Color("#3a2414") if sel else (Color("#f5e8cc") if op else Color("#b0a49c"))
		var nm = MK.name(id)
		var inner = tw + (0.0 if op else LOCK_W + LOCK_GAP)
		var ix = x + (cw - inner) / 2.0; var cyy = y0 + STRIP_H / 2.0
		var lock_r = Rect2()
		if not op:   # 鎖圖示（紅底細牌＋金色鎖頭），唔用細字「鎖」
			lock_r = Rect2(ix, cyy - 8.0, LOCK_W, 16.0)
			Art.rr(ctx, lock_r.position.x, lock_r.position.y, LOCK_W, 16.0, 4, "rgba(150,36,30,.95)", "#e8b8a0", 1.0)
			var lx = ix + LOCK_W / 2.0
			ctx.strokeStyle = "#ffe9a8"; ctx.lineWidth = 2
			ctx.beginPath(); ctx.arc(lx, cyy - 1.5, 3.0, PI, TAU); ctx.stroke()
			Art.rr(ctx, lx - 4.5, cyy - 1.5, 9.0, 6.5, 2, "#ffe9a8", "", 0)
			ix += LOCK_W + LOCK_GAP
		sc._txt(ctx, nm, ix, cyy + 1, fs, col, "left", 900, 0)
		lay.append({"id": id, "cell": Rect2(x + 2, y0 + 5, cw - 4, STRIP_H - 10), "lock": lock_r, "txt": Rect2(ix, cyy - fs / 2.0, tw, float(fs)), "fs": fs})
		if MK.sids_on(ci, id).is_empty() and op: Art.el(ctx, x + cw - 9, y0 + STRIP_H - 11, 3, 3, "#c9b9a0")   # 呢條街本章冇貨：右下角灰點（之前係 9 號字「無貨」，睇唔清；入到去有大字講）
		if _alert(sc, id):   # 被霸：紅點閃
			var a = 0.55 + 0.45 * sin(float(sc.t) * 6.0)
			ctx.globalAlpha = a; Art.el(ctx, x + cw - 8, y0 + 9, 5, 5, "#e0392b", "#fff0e0", 1.0); ctx.globalAlpha = 1.0
		sc._btns["mks:" + id] = Rect2(x, y0, cw, STRIP_H)
		x += cw
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
