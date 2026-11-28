# 過勞鬼市集（市集程序組 M2）：過勞營業掛牌＋爽點畫面。冇 class_name、冇 autoload（熱更新規矩）。
#   mv_scene 叫：draw_world(sc, ctx, vy0, vy1)（台／櫃台頭頂：加班牌、過勞條、趴低、餵包子、打卡鐘）
#               draw_hud(sc, ctx)（頂部：子時高峰倒數、潮流榜、連單數、限時大客、名聲）
#               tap(sc, p) -> bool（畫面座標）、events(sc)（每格：浮字／演出）
#   台詞先用佔位（文案組 story_market_v1 寫正式版）；原文書面中文，粵語放第一格。
extends RefCounted

const MK = preload("res://game/market/mk_data.gd")
const FUN = preload("res://game/market/mk_fun.gd")
const RN = preload("res://game/market/mk_renown.gd")
const MD = preload("res://game/outpost/mv_data.gd")
static var _wbtn := {}   # 世界座標掣
static var _hbtn := {}   # 畫面座標掣
static var trend_open := false
static var _toasts: Array = []    # 通告牌（取代浮喺場景嘅字）：{t, c, t0, life}；排喺左欄最底，有底板，同其他牌唔重疊
static var fit_bad: Array = []    # 今格畫 HUD 時有冇字闊過個框（測試用）
static var world_hid := 0         # 今格有幾多個加班牌因為會撞到頂部牌而唔畫（測試用）
const TOAST_W := 240.0
static func toast(sc, tx: String, col: Color, life := 2.4) -> void:
	if tx == "": return
	for q in _toasts: if str(q.t) == tx: q.t0 = float(sc.t); q.life = life; return   # 同一句：續時間，唔好疊兩行
	_toasts.append({"t": tx, "c": col, "t0": float(sc.t), "life": life})
	while _toasts.size() > 3: _toasts.pop_front()
static func _gap(ctx, x: float, y: float, top: float) -> void:   # 兩塊牌之間 6px 罅填實（唔係第一塊先填），後面場景嘅字唔會喺罅度露半截
	if y - 6.0 >= top: ctx.fillStyle = "rgba(24,16,12,.96)"; ctx.fillRect(x + 4.0, y - 6.0, TOAST_W - 8.0, 6.0)
static func _fit(ctx, name: String, tx: String, font: String, box_w: float) -> void:
	ctx.font = font
	var w = float(ctx.measureText(tx).width)
	if w > box_w + 0.5: fit_bad.append([name, tx, w, box_w])
static var hud_rects: Array = []   # 市集 HUD 佔位（畫面座標）：「生產鏈」掣避開用
static var _card := {}   # 人物小卡（熟客／評論家／大客）：{art, a, b, t0, life, col}
static var _mid_n := 0
static var _mid_t := -99.0
static var hud_bot := 0.0   # 市集 HUD 底（畫面座標）：浮字唔好鑽入去
const GAG := [["口吐白煙……", "口吐白煙……"], ["魂飛咗出去，又被自己扯返嚟", "魂飛了出去，又被自己扯回來"],
	["趴喺蒸籠度扯鼻鼾", "趴在蒸籠上打呼"], ["口水流成條河", "口水流成一條河"]]

static func L(y: String, z: String) -> String: return y if DB.lang == "yue" else z
static func _bar_col(k: float) -> String:
	if k >= 0.7: return "#e0503a"
	if k >= 0.45: return "#e8b23a"
	return "#7fd06a"

# ---------------- 世界：每個攤／櫃台 ----------------
static var grp: Array = []   # [57] 今格畫咗嘅加班成組牌（世界座標）
static func draw_world(sc, ctx, vy0: float, vy1: float) -> void:
	_wbtn.clear(); world_hid = 0; grp.clear()
	FUN.ensure()
	if not FUN.on(): return
	var sim = sc.sim
	for sid in MD.stations(sim.ci()):
		if not MK.shown(sim.ci(), sid) or not sim.unlocked(sid): continue
		var p = sim.st_pos(sid)
		if p.y + 60.0 < vy0 or p.y - 200.0 > vy1: continue
		_draw_ot(sc, ctx, sid, p + Vector2(-118, -146))   # 攤位左上角外面：中間頂係 M1 過勞小卡（128 闊）、右上角係「做／收」圓掣，三樣唔好撞
	var Lx = sim.L
	if Lx.has("counter_y") and FUN.counter_staffed():   # 當前街嘅櫃台：冇加班掣，只顯示過勞條／趴低／餵包子
		_draw_ot(sc, ctx, FUN.ctr_key(MK.cur()), Vector2(float(Lx.counter_x1) - 10.0, float(Lx.counter_y) - 96.0), true)
static func _draw_ot(sc, ctx, sid: String, at: Vector2, counter := false) -> void:
	var o = MK.ot(sid)
	if o.is_empty(): return
	# 成組牌（加班牌＋過勞條＋打卡鐘／餵包子）嘅畫面位置：撞到頂部任何一塊牌，或者鑽咗入頂部列，就成組唔畫（等鏡頭移開先出），唔好半遮半掩
	var sp0: Vector2 = sc.w2s(Vector2(at.x - 62.0, at.y - 22.0)); var sp1: Vector2 = sc.w2s(Vector2(at.x + 62.0, at.y + 72.0))
	var scr = Rect2(sp0, sp1 - sp0)
	var top_lim = 0.0
	if ResourceLoader.exists("res://game/market/mk_ops_ui.gd"): top_lim = float(load("res://game/market/mk_ops_ui.gd").hud_bot)
	if ResourceLoader.exists("res://game/market/mk_ui.gd"): top_lim = maxf(top_lim, float(load("res://game/market/mk_ui.gd").strip_rect(sc).end.y))
	if scr.position.y < top_lim + 2.0: world_hid += 1; return
	for q in hud_rects: if scr.intersects((q as Rect2).grow(2.0)): world_hid += 1; return
	grp.append(Rect2(at.x - 62.0, at.y - 20.0, 124.0, 86.0))   # [57] 成組牌佔位（M1 牌／卡避開）
	var down = MK.is_down(sid)
	var on = MK.ot_on(sid)
	var k = MK.fat_k(sid)
	# 加班木牌
	var w = 58.0; var h = 26.0
	var x = at.x - w / 2.0; var y = at.y
	if down:
		var pulse = 0.5 + 0.5 * sin(sc.t * 5.0)
		Art.rr(ctx, x - 6, y, w + 12, h, 7, "rgba(160,30,24,%.2f)" % (0.75 + 0.2 * pulse), "#ffd0c0", 1.6)
		sc._txt(ctx, L("趴低 %d" % int(ceil(float(o.get("down", 0.0)))), "趴下 %d" % int(ceil(float(o.get("down", 0.0))))), at.x, y + h / 2.0, 14, Color("#fff0e8"), "center", 900, 0)
		# 餵包子掣
		var fb = Rect2(at.x - 44, y + h + 4, 88, 26)
		Art.rr(ctx, fb.position.x, fb.position.y, fb.size.x, fb.size.y, 7, "rgba(255,228,160,.95)", "#7a4a1a", 1.6)
		sc._txt(ctx, L("餵包子", "餵包子"), fb.get_center().x, fb.get_center().y, 14, Color("#4a2a0a"), "center", 900, 0)
		_wbtn["feed:" + sid] = fb
		return
	if counter:   # 櫃台：繁忙牌＋過勞條
		var bz = FUN.counter_busy(sc.sim, MK.cur())
		var cw = 112.0 if bz != "" else 84.0   # 字 14px：按字數定牌闊，唔出格
		Art.rr(ctx, at.x - cw / 2.0, y, cw, h, 7, "rgba(120,60,20,.9)" if bz != "" else "rgba(60,40,48,.82)", "#f6d7a8", 1.4)
		sc._txt(ctx, (L("收銀 %d 人", "收銀 %d 人") % FUN.counter_n(MK.cur())) + (L("・忙", "・忙") if bz != "" else ""), at.x, y + h / 2.0, 14, Color("#fff4e0"), "center", 900, 0)
		Art.rr(ctx, x, y + h + 4.0, w, 7, 3, "rgba(20,12,18,.8)", "", 0)
		if k > 0.0: Art.rr(ctx, x, y + h + 4.0, w * k, 7, 3, _bar_col(k), "", 0)
		if FUN.vet(sid): sc._txt(ctx, L("老收銀", "老收銀"), at.x, y - 11.0, 14, Color("#ffd27a"), "center", 900, 3)
		return
	var fill = "rgba(196,38,30,.95)" if on else "rgba(60,40,48,.82)"
	Art.rr(ctx, x, y, w, h, 7, fill, "#f6d7a8" if on else "#9a8a90", 1.6)
	sc._txt(ctx, L("加班", "加班"), at.x, y + h / 2.0, 15, Color("#fff4e0") if on else Color("#d9cdd2"), "center", 900, 0)
	_wbtn["ot:" + sid] = Rect2(x - 6, y - 6, w + 12, h + 12)
	# 過勞條
	var by = y + h + 4.0
	Art.rr(ctx, x, by, w, 7, 3, "rgba(20,12,18,.8)", "", 0)
	if k > 0.0: Art.rr(ctx, x, by, w * k, 7, 3, _bar_col(k), "", 0)
	if FUN.warn(sid): sc._txt(ctx, L("汗", "汗"), x + w + 11.0, by + 3.0, 14, Color("#9fd8ff"), "center", 900, 2)
	if FUN.vet(sid): sc._txt(ctx, L("老", "老"), x - 11.0, y + h / 2.0, 14, Color("#ffd27a"), "center", 900, 3)
	if FUN.punch_ok():
		var pb = Rect2(at.x - 37.0, by + 10.0, 74.0, 24.0)
		var cd = FUN.punch_left(sid)
		Art.rr(ctx, pb.position.x, pb.position.y, pb.size.x, pb.size.y, 6, "rgba(40,60,90,.85)" if cd <= 0.0 else "rgba(40,40,40,.6)", "#b8d0f0", 1.2)
		sc._txt(ctx, L("打卡放工", "打卡下班") if cd <= 0.0 else "%d:%02d" % [int(cd) / 60, int(cd) % 60], pb.get_center().x, pb.get_center().y, 14, Color("#e8f0ff"), "center", 900, 0)
		_wbtn["punch:" + sid] = pb

# ---------------- 頂部 HUD ----------------
static func draw_hud(sc, ctx, y0 := -1.0) -> void:
	_hbtn.clear()
	FUN.ensure()
	if not FUN.on() or sc.anim != null: return
	var sim = sc.sim
	var y = y0 if y0 >= 0.0 else sc.top_pad + 96.0
	if ResourceLoader.exists("res://game/market/mk_ui.gd"):   # M1 街名牌列：排喺佢下面，唔好疊
		var MKU = load("res://game/market/mk_ui.gd")
		if MKU != null and MKU.on(sc): y = MKU.strip_rect(sc).end.y + 6.0
	if ResourceLoader.exists("res://game/market/mk_ops_ui.gd"):   # M1 人手列／治安卡／對白條：再排落去
		var MKOU = load("res://game/market/mk_ops_ui.gd")
		if MKOU != null and MKOU.on(sc): y = maxf(y, float(MKOU.hud_bot) + 6.0)
	var x = 8.0
	hud_rects.clear(); fit_bad.clear()
	# 全部排喺左邊一欄（右上角留畀「生產鏈」掣）：第一行＝潮流榜細牌＋連單數；下面＝子時高峰、限時大客
	var tl = FUN.trend_list(sim)
	var ytop = y
	var r = Rect2(x, y, 142.0, 30.0)
	if tl.size():
		Art.rr(ctx, r.position.x, r.position.y, r.size.x, r.size.y, 7, "rgba(16,30,22,.96)", "#7fe0a0", 1.4)
		sc._txt(ctx, L("陽間潮流榜 ▾", "陽間潮流榜 ▾"), r.get_center().x, r.get_center().y, 14, Color("#c8ffd8"), "center", 900, 0)
		_fit(ctx, "trend_btn", L("陽間潮流榜 ▾", "陽間潮流榜 ▾"), "900 14px sans-serif", r.size.x - 8.0)
		_hbtn["trend"] = r; hud_rects.append(r)
	var ch = int(FUN.st().get("chain", 0))
	if ch >= 2:
		var cr = Rect2(x + 148.0 if tl.size() else x, y, 92.0, 30.0)
		Art.rr(ctx, cr.position.x, cr.position.y, cr.size.x, cr.size.y, 8, "rgba(40,28,8,.96)", "#ffe98a", 1.4)
		sc._txt(ctx, L("連單 %d 連", "連單 %d 連") % ch, cr.get_center().x, cr.get_center().y, 15, Color("#ffe98a"), "center", 900, 0)
		_fit(ctx, "chain", L("連單 %d 連", "連單 %d 連") % ch, "900 15px sans-serif", cr.size.x - 6.0)
		hud_rects.append(cr)
	if tl.size() or ch >= 2: y += 36.0
	var ypop = y
	if tl.size() and trend_open:   # 潮流榜：過審素材（名次牌 mk_tr_b1–3、熱賣火 mk_tr_hot）；冇圖就淨字
		var rh = 38.0; var bw = 228.0
		var hh = rh * tl.size() + 36.0
		Art.rr(ctx, x, ypop, bw, hh, 8, "rgba(46,30,18,.97)", "#e8b04a", 1.6)
		for i in tl.size():
			var sid = str(tl[i]); var ry = ypop + 6.0 + rh * i
			var bk = "mk_tr_b%d" % (i + 1); var tx = x + 12.0
			if Spr.ok(bk): Art.put(ctx, bk, x + 20.0, ry + rh - 2.0, 20.0, 35.0); tx = x + 38.0
			else: sc._txt(ctx, str(i + 1), x + 14.0, ry + rh / 2.0, 15, Color("#ffd27a"), "center", 900, 0); tx = x + 28.0
			var nm = str(MD.st_def(sid).get("n", [sid, sid])[1 if DB.lang != "yue" else 0]) if MD.st_def(sid).get("n") is Array else sid
			sc._txt(ctx, nm, tx, ry + rh / 2.0 + 1.0, 15 if nm.length() <= 6 else 13, Color("#fff0d8"), "left", 800, 0)
			if Spr.ok("mk_tr_hot"): Art.put(ctx, "mk_tr_hot", x + bw - 58.0, ry + rh - 7.0, 16.0, 24.0)
			sc._txt(ctx, "×%s" % FUN.txt_trend_mul(), x + bw - 10.0, ry + rh / 2.0 + 1.0, 15, Color("#ffd27a"), "right", 900, 0)
		sc._txt(ctx, L("名聲：%s", "名聲：%s") % RN.level_name(), x + 12.0, ypop + 20.0 + rh * tl.size(), 14, Color("#ffd27a"), "left", 800, 0)
		hud_rects.append(Rect2(x, ypop, 228.0, hh))
		hud_bot = ypop + hh
		return   # 榜打開嗰陣：高峰牌／大客牌／小卡／通告牌暫時收埋（之前係蓋住佢哋；撳任何地方就收榜）
	var ph = FUN.rush_phase()
	if ph != "idle":
		var left = FUN.rush_left()
		var tx = ""; var col = "#ffd27a"
		match ph:
			"warn": tx = L("子時高峰 %d 秒後到！", "子時高峰 %d 秒後到！") % int(ceil(left)); col = "#ffd27a"
			"peak": tx = L("子時高峰！客 ×%s　%d", "子時高峰！客流 ×%s　%d") % [FUN.txt_peak_flow(), int(ceil(left))]; col = "#ff7a5a"
			"rest": tx = L("喘息：飲涼茶　%d", "喘息：喝涼茶　%d") % int(ceil(left)); col = "#8fd0ff"
		_gap(ctx, x, y, ytop + 1.0)
		Art.rr(ctx, x, y, 240, 30, 8, "rgba(14,8,18,.96)", col, 1.6)
		sc._txt(ctx, tx, x + 120.0, y + 15.0, 14, Color(col), "center", 900, 0)
		_fit(ctx, "rush", tx, "900 14px sans-serif", 232.0)
		hud_rects.append(Rect2(x, y, 240, 30)); y += 36.0
	for c in sim.custs:
		if J.t(c.get("bigv")) and c.st != "out":
			var left2 = maxf(0.0, float(c.get("tend", 0.0)) - FUN._clock())
			var need = 0; var got = 0
			for g in c.wants: need += int(c.wants[g]); got += int(c.got.get(g, 0))
			var va = str(c.get("vipart", "")); var has = va != "" and Spr.ok(va)
			var vh = 52.0 if has else 30.0
			_gap(ctx, x, y, ytop + 1.0)
			Art.rr(ctx, x, y, 240, vh, 8, "rgba(60,20,10,.96)", "#ffcf6a", 1.6)
			if has: Art.put(ctx, va, x + 28.0, y + vh - 2.0, 0.0, vh - 4.0)
			var tx0 = x + (56.0 if has else 12.0)
			if has:
				sc._txt(ctx, L("限時大客：%s", "限時大客：%s") % str(c.get("vipn", "")), tx0, y + 16.0, 15, Color("#ffe8b0"), "left", 900, 0)
				sc._txt(ctx, L("%d／%d 件　剩 %d 秒", "%d／%d 件　剩 %d 秒") % [got, need, int(ceil(left2))], tx0, y + 37.0, 14, Color("#fff4e0"), "left", 800, 0)
			else: sc._txt(ctx, L("%s　%d／%d　%d 秒", "%s　%d／%d　%d 秒") % [str(c.get("vipn", "")), got, need, int(ceil(left2))], x + 120.0, y + 15.0, 14, Color("#ffe8b0"), "center", 900, 0)
			hud_rects.append(Rect2(x, y, 240, vh)); y += vh + 6.0
			break
	# 人物小卡（熟客來了／記住名字／評論家評分）：頭像＋兩行字，幾秒後收
	if not _card.is_empty():
		var tu = float(sc.t) - float(_card.t0)
		if tu > float(_card.life): _card = {}
		else:
			var ca = clampf(minf(tu / 0.2, (float(_card.life) - tu) / 0.4), 0.0, 1.0)
			var ka = str(_card.get("art", "")); var khas = ka != "" and Spr.ok(ka)
			ctx.globalAlpha = ca
			if ca > 0.6: _gap(ctx, x, y, ytop + 1.0)
			Art.rr(ctx, x, y, 240, 56, 8, "rgba(250,244,228,.97)", str(_card.get("col", "#5e4a30")), 2.0)
			if khas: Art.put(ctx, ka, x + 30.0, y + 54.0, 0.0, 52.0)
			var kx = x + (60.0 if khas else 12.0)
			sc._txt(ctx, str(_card.get("a", "")), kx, y + 18.0, 15, Color("#2b1d12"), "left", 900, 0)
			sc._txt(ctx, str(_card.get("b", "")), kx, y + 39.0, 14, Color("#5a3a1a"), "left", 800, 0)
			_fit(ctx, "card_a", str(_card.get("a", "")), "900 15px sans-serif", x + 240.0 - kx - 6.0)
			_fit(ctx, "card_b", str(_card.get("b", "")), "800 14px sans-serif", x + 240.0 - kx - 6.0)
			ctx.globalAlpha = 1.0
			hud_rects.append(Rect2(x, y, 240, 56)); y += 62.0
	# 通告牌：一句一塊，逐塊向下排（長句自動分兩行，字唔細過 14）
	var now2 = float(sc.t)
	for i in range(_toasts.size() - 1, -1, -1): if now2 - float(_toasts[i].t0) >= float(_toasts[i].life) or now2 < float(_toasts[i].t0) - 0.5: _toasts.remove_at(i)
	for q in _toasts:
		ctx.font = "900 14px sans-serif"
		var ls: Array = sc._wrap(ctx, str(q.t), TOAST_W - 20.0)
		if ls.size() > 3: ls = ls.slice(0, 3)
		var th = 12.0 + 20.0 * ls.size()
		var ta = clampf(minf((now2 - float(q.t0)) / 0.15, (float(q.life) - (now2 - float(q.t0))) / 0.35), 0.0, 1.0)
		ctx.globalAlpha = ta
		if ta > 0.6: _gap(ctx, x, y, ytop + 1.0)
		Art.rr(ctx, x, y, TOAST_W, th, 8, "rgba(30,20,14,.97)", "#" + (q.c as Color).to_html(false), 1.6)
		for li in ls.size():
			sc._txt(ctx, str(ls[li]), x + TOAST_W / 2.0, y + 16.0 + 20.0 * li, 14, q.c, "center", 900, 0)
			_fit(ctx, "toast", str(ls[li]), "900 14px sans-serif", TOAST_W - 8.0)
		ctx.globalAlpha = 1.0
		hud_rects.append(Rect2(x, y, TOAST_W, th)); y += th + 6.0
	hud_bot = y

# ---------------- 撳 ----------------
static func tap(sc, p: Vector2) -> bool:
	if not FUN.on(): return false
	for k in _hbtn.keys():
		if _hbtn[k].grow(3).has_point(p):
			if k == "trend": trend_open = not trend_open; sc._snd("click"); return true
	if trend_open: trend_open = false; return true
	var wp = sc.s2w(p)
	for k in _wbtn.keys():
		if not (_wbtn[k] as Rect2).has_point(wp): continue
		var sid = k.substr(k.find(":") + 1)
		if k.begins_with("ot:"):
			var now_on = MK.toggle_ot(sid)
			toast(sc, _sn(sid) + (L("加班！", "加班！") if now_on else L("收工唞下", "收工歇會")), Color("#ffb0a0") if now_on else Color("#bfe8ff"), 1.6)
			sc._snd("click"); return true
		if k.begins_with("feed:"):
			var r = FUN.feed(sid)
			if r == "no_bao": toast(sc, L("冇普通包子", "沒有普通包子"), Color("#ffb0a0"), 1.8)
			sc._snd("click"); return true
		if k.begins_with("punch:"):
			var r2 = FUN.punch(sid)
			if r2 == "cd": toast(sc, L("打卡鐘冷卻緊", "打卡鐘冷卻中"), Color("#ffb0a0"), 1.8)
			sc._snd("click"); return true
	return false

# ---------------- 事件 → 浮字 ----------------
static func events(sc) -> void:
	var sim = sc.sim
	var evs = FUN.pop_events() + RN.pop_events()
	for e in evs:
		var sid = str(e.get("sid", ""))
		var stall = sid != "" and not sid.begins_with("_")
		if stall and (not _seen(sc, sim.st_pos(sid)) or not MK.shown(sim.ci(), sid)): continue   # 唔喺畫面／唔係而家條街：唔出浮字
		if str(e.k) in ["chain", "vip_fail"] and e.has("pos") and not _seen(sc, e.pos): e.erase("pos")
		var pre = _sn(sid) if stall else ""   # 攤位事件：通告牌前面寫攤名
		match str(e.k):
			"down": toast(sc, pre + L(GAG[int(e.get("gag", 0)) % GAG.size()][0], GAG[int(e.get("gag", 0)) % GAG.size()][1]), Color("#ffb0a0"), 2.2)
			"vet": toast(sc, pre + L("升職做老員工！", "升職為老員工！"), Color("#ffd27a"), 2.0)
			"cashier": toast(sc, pre + L("升職做老收銀！算盤打到飛起", "升職為老收銀！算盤打得飛快"), Color("#ffd27a"), 2.2)
			"captain": toast(sc, pre + L("升職做巡邏隊長！", "升職為巡邏隊長！"), Color("#ffd27a"), 2.2)
			"punch": toast(sc, pre + L("打卡放工～", "打卡下班～"), Color("#bfe8ff"), 2.2)
			"mile": toast(sc, pre + L("速度翻倍！", "速度翻倍！"), Color("#ffe98a"), 2.2)
			"street_combo": toast(sc, pre + L("街組合：%s！", "街組合：%s！") % str(e.get("n", "")), Color("#ffe98a"), 2.4)
			"chain": pass   # 連單數喺左上角細牌度睇（之前浮喺客人頭上，會壓住其他字）
			"rush_warn": toast(sc, pre + L("更夫敲鑼：子時高峰要到！", "更夫敲鑼：子時高峰要到！"), Color("#ffd27a"), 2.2)
			"rush_peak": toast(sc, pre + L("子時高峰！", "子時高峰！"), Color("#ff7a5a"), 2.0)
			"vip_in": toast(sc, pre + L("限時大客：%s 要 %d 件！", "限時大客：%s 要 %d 件！") % [str(e.get("name", "")), int(e.get("n", 0))], Color("#ffcf6a"), 2.4)
			"vip_ok": toast(sc, pre + L("大客收齊！×%s", "大客收齊！×%s") % FUN.txt_vip_mul(), Color("#ffe98a"), 2.2)
			"vip_fail": toast(sc, pre + L("「唔夠貨？下次啦。」", "「貨不夠？下次吧。」"), Color("#d9cdd2"), 2.0)
			"critic":
				var b = e.get("best", ["", 1])
				var cn = MK.T(FUN.D().critic.get("name", ["甘先生", "甘先生"])); var gd = MK.T(FUN.D().critic.get("guide", ["冥其林指南", "冥其林指南"]))
				var stn = str(MD.st_def(str(b[0])).get("n", ["", ""])[1 if DB.lang != "yue" else 0]) if MD.st_def(str(b[0])).get("n") is Array else ""
				card(sc, str(FUN.D().critic.get("art", "")), "%s《%s》" % [cn, gd], L("%s：%d 盞燈籠", "%s：%d 盞燈籠") % [stn, int(b[1])], 4.5, "#c9a227" if int(b[1]) >= 3 else "#6a5a50")
			"reg_name": card(sc, str(e.get("art", "")), L("記住咗熟客個名", "記住熟客的名字了"), str(e.get("name", "")), 3.6, "#c8508a")
			"reg_in": card(sc, str(e.get("art", "")), L("熟客嚟咗", "熟客來了"), str(e.get("name", "")) if str(e.get("name", "")) != "" else L("（幫襯多幾次就識佢）", "（多光顧幾次就認得他）"), 2.8, "#c8508a")
			"renown_up": toast(sc, pre + L("名聲升級：%s", "名聲升級：%s") % str(e.get("name", "")), Color("#ffd27a"), 2.6)
			"trend_new": pass

# 浮字位置（世界座標）：畫面中間、市集 HUD 下面，連續幾條就逐行排落去；攤位上面嘅浮字唔好鑽入 HUD
static func _mid(sc) -> Vector2:
	if float(sc.t) - _mid_t < 1.6: _mid_n = (_mid_n + 1) % 5
	else: _mid_n = 0
	_mid_t = float(sc.t)
	return sc.s2w(Vector2(sc.FW / 2.0, maxf(hud_bot, sc.top_pad + 200.0) + 64.0 + 36.0 * _mid_n))
static func _seen(sc, wp: Vector2) -> bool:   # 呢個世界位喺唔喺畫面入面（畫面外嘅攤唔出浮字，費事疊埋一齊）
	var sp: Vector2 = sc.w2s(wp)
	return sp.x >= 40.0 and sp.x <= sc.FW - 40.0
static func _at(sc, wp: Vector2) -> Vector2:
	var sp: Vector2 = sc.w2s(wp)
	sp.x = clampf(sp.x, 110.0, sc.FW - 110.0)
	sp.y = maxf(sp.y, maxf(hud_bot, sc.top_pad + 200.0) + 44.0)
	return sc.s2w(sp)
static func _sn(sid: String) -> String:   # 「攤名：」
	if sid == "" or sid.begins_with("_"): return ""
	var d = MD.st_def(sid).get("n")
	return (str(d[1 if DB.lang != "yue" else 0]) + "：") if d is Array and d.size() >= 2 else ""
# 測試用：今格版面有冇問題（頂部牌互相重疊／出畫面／字闊過框／撞到 M1 頂部列／撞到「生產鏈」掣／加班牌撞到頂部牌）
static func layout_bad(sc) -> Array:
	var bad: Array = []
	var top_lim = 0.0
	if ResourceLoader.exists("res://game/market/mk_ops_ui.gd"): top_lim = float(load("res://game/market/mk_ops_ui.gd").hud_bot)
	for i in hud_rects.size():
		var a: Rect2 = hud_rects[i]
		if a.position.x < 0.0 or a.end.x > float(sc.FW) or a.position.y < top_lim - 0.5: bad.append("牌出界 %s" % str(a))
		for j in range(i + 1, hud_rects.size()): if a.intersects(hud_rects[j]): bad.append("牌重疊 %s %s" % [str(a), str(hud_rects[j])])
		if sc._cb_pos != null and a.intersects(Rect2(sc._cb_pos, sc._cb_sz)): bad.append("牌撞生產鏈掣 %s" % str(a))
		for k in _wbtn:
			var w: Rect2 = _wbtn[k]; var p0: Vector2 = sc.w2s(w.position); var p1: Vector2 = sc.w2s(w.end)
			if a.intersects(Rect2(p0, p1 - p0)): bad.append("牌撞 %s" % str(k))
	for f in fit_bad: bad.append("字出框 %s" % str(f))
	return bad
static func card(sc, art: String, a: String, b: String, life := 3.0, col := "#5e4a30") -> void:
	_card = {"art": art, "a": a, "b": b, "t0": float(sc.t), "life": life, "col": col}
