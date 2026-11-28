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
const GAG := [["口吐白煙……", "口吐白煙……"], ["魂飛咗出去，又被自己扯返嚟", "魂飛了出去，又被自己扯回來"],
	["趴喺蒸籠度扯鼻鼾", "趴在蒸籠上打呼"], ["口水流成條河", "口水流成一條河"]]

static func L(y: String, z: String) -> String: return y if DB.lang == "yue" else z
static func _bar_col(k: float) -> String:
	if k >= 0.7: return "#e0503a"
	if k >= 0.45: return "#e8b23a"
	return "#7fd06a"

# ---------------- 世界：每個攤／櫃台 ----------------
static func draw_world(sc, ctx, vy0: float, vy1: float) -> void:
	_wbtn.clear()
	FUN.ensure()
	if not FUN.on(): return
	var sim = sc.sim
	for sid in MD.stations(sim.ci()):
		if not MK.shown(sim.ci(), sid) or not sim.unlocked(sid): continue
		var p = sim.st_pos(sid)
		if p.y + 60.0 < vy0 or p.y - 200.0 > vy1: continue
		_draw_ot(sc, ctx, sid, p + Vector2(54, -132))
	var Lx = sim.L
	if Lx.has("counter_y") and FUN.counter_staffed():   # 當前街嘅櫃台：冇加班掣，只顯示過勞條／趴低／餵包子
		_draw_ot(sc, ctx, FUN.ctr_key(MK.cur()), Vector2(float(Lx.counter_x1) - 10.0, float(Lx.counter_y) - 96.0), true)
static func _draw_ot(sc, ctx, sid: String, at: Vector2, counter := false) -> void:
	var o = MK.ot(sid)
	if o.is_empty(): return
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
		Art.rr(ctx, x - 8, y, w + 16, h, 7, "rgba(120,60,20,.9)" if bz != "" else "rgba(60,40,48,.82)", "#f6d7a8", 1.4)
		sc._txt(ctx, (L("收銀 %d 人", "收銀 %d 人") % FUN.counter_n(MK.cur())) + (L("・忙", "・忙") if bz != "" else ""), at.x, y + h / 2.0, 12, Color("#fff4e0"), "center", 900, 0)
		Art.rr(ctx, x, y + h + 4.0, w, 7, 3, "rgba(20,12,18,.8)", "", 0)
		if k > 0.0: Art.rr(ctx, x, y + h + 4.0, w * k, 7, 3, _bar_col(k), "", 0)
		if FUN.vet(sid): sc._txt(ctx, L("老收銀", "老收銀"), at.x, y - 10.0, 12, Color("#ffd27a"), "center", 900, 3)
		return
	var fill = "rgba(196,38,30,.95)" if on else "rgba(60,40,48,.82)"
	Art.rr(ctx, x, y, w, h, 7, fill, "#f6d7a8" if on else "#9a8a90", 1.6)
	sc._txt(ctx, L("加班", "加班"), at.x, y + h / 2.0, 15, Color("#fff4e0") if on else Color("#d9cdd2"), "center", 900, 0)
	_wbtn["ot:" + sid] = Rect2(x - 6, y - 6, w + 12, h + 12)
	# 過勞條
	var by = y + h + 4.0
	Art.rr(ctx, x, by, w, 7, 3, "rgba(20,12,18,.8)", "", 0)
	if k > 0.0: Art.rr(ctx, x, by, w * k, 7, 3, _bar_col(k), "", 0)
	if FUN.warn(sid): sc._txt(ctx, L("汗", "汗"), x + w + 10.0, by + 3.0, 12, Color("#9fd8ff"), "center", 900, 2)
	if FUN.vet(sid): sc._txt(ctx, L("老", "老"), x - 10.0, y + h / 2.0, 13, Color("#ffd27a"), "center", 900, 3)
	if FUN.punch_ok():
		var pb = Rect2(x, by + 10.0, w, 20)
		var cd = FUN.punch_left(sid)
		Art.rr(ctx, pb.position.x, pb.position.y, pb.size.x, pb.size.y, 6, "rgba(40,60,90,.85)" if cd <= 0.0 else "rgba(40,40,40,.6)", "#b8d0f0", 1.2)
		sc._txt(ctx, L("打卡放工", "打卡下班") if cd <= 0.0 else "%d:%02d" % [int(cd) / 60, int(cd) % 60], pb.get_center().x, pb.get_center().y, 11, Color("#e8f0ff"), "center", 900, 0)
		_wbtn["punch:" + sid] = pb

# ---------------- 頂部 HUD ----------------
static func draw_hud(sc, ctx, y0 := -1.0) -> void:
	_hbtn.clear()
	FUN.ensure()
	if not FUN.on() or sc.anim != null: return
	var sim = sc.sim
	var y = y0 if y0 >= 0.0 else sc.top_pad + 96.0
	var x = 8.0
	# 子時高峰
	var ph = FUN.rush_phase()
	if ph != "idle":
		var left = FUN.rush_left()
		var tx = ""; var col = "#ffd27a"
		match ph:
			"warn": tx = L("子時高峰 %d 秒後到！", "子時高峰 %d 秒後到！") % int(ceil(left)); col = "#ffd27a"
			"peak": tx = L("子時高峰！客 ×%s　%d", "子時高峰！客流 ×%s　%d") % [FUN.txt_peak_flow(), int(ceil(left))]; col = "#ff7a5a"
			"rest": tx = L("喘息：飲涼茶　%d", "喘息：喝涼茶　%d") % int(ceil(left)); col = "#8fd0ff"
		Art.rr(ctx, x, y, 228, 30, 8, "rgba(14,8,18,.86)", col, 1.6)
		sc._txt(ctx, tx, x + 114.0, y + 15.0, 14, Color(col), "center", 900, 0)
		y += 36.0
	# 限時大客
	for c in sim.custs:
		if J.t(c.get("bigv")) and c.st != "out":
			var left2 = maxf(0.0, float(c.get("tend", 0.0)) - FUN._clock())
			var need = 0; var got = 0
			for g in c.wants: need += int(c.wants[g]); got += int(c.got.get(g, 0))
			Art.rr(ctx, x, y, 228, 30, 8, "rgba(60,20,10,.88)", "#ffcf6a", 1.6)
			sc._txt(ctx, L("%s　%d／%d　%d 秒", "%s　%d／%d　%d 秒") % [str(c.get("vipn", "")), got, need, int(ceil(left2))], x + 114.0, y + 15.0, 14, Color("#ffe8b0"), "center", 900, 0)
			y += 36.0
			break
	# 連單
	var ch = int(FUN.st().get("chain", 0))
	if ch >= 2:
		sc._txt(ctx, L("連單 %d 連", "連單 %d 連") % ch, 390.0 - 70.0, sc.top_pad + 110.0, 18, Color("#ffe98a"), "center", 900, 4)
	# 潮流榜（細牌；撳開睇全部）
	var tl = FUN.trend_list(sim)
	if tl.size():
		var r = Rect2(390.0 - 150.0, sc.top_pad + 128.0, 142.0, 26.0)
		Art.rr(ctx, r.position.x, r.position.y, r.size.x, r.size.y, 7, "rgba(16,30,22,.88)", "#7fe0a0", 1.4)
		sc._txt(ctx, L("陽間潮流榜 ▾", "陽間潮流榜 ▾"), r.get_center().x, r.get_center().y, 13, Color("#c8ffd8"), "center", 900, 0)
		_hbtn["trend"] = r
		if trend_open:
			var yy = r.end.y + 4.0
			var hh = 24.0 * tl.size() + 30.0
			Art.rr(ctx, r.position.x - 40.0, yy, r.size.x + 40.0, hh, 8, "rgba(10,20,14,.94)", "#7fe0a0", 1.4)
			for i in tl.size():
				var sid = str(tl[i])
				sc._txt(ctx, "%s ×%s" % [str(MD.st_def(sid).get("n", [sid, sid])[1 if DB.lang != "yue" else 0]) if MD.st_def(sid).get("n") is Array else sid, FUN.txt_trend_mul()], r.position.x - 30.0, yy + 16.0 + 24.0 * i, 13, Color("#e8fff0"), "left", 800, 0)
			sc._txt(ctx, L("名聲：%s", "名聲：%s") % RN.level_name(), r.position.x - 30.0, yy + 16.0 + 24.0 * tl.size(), 12, Color("#ffd27a"), "left", 800, 0)

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
			sc._float(wp + Vector2(0, -30), L("加班！", "加班！") if now_on else L("收工唞下", "收工歇會"), Color("#ffb0a0") if now_on else Color("#bfe8ff"), 16)
			sc._snd("click"); return true
		if k.begins_with("feed:"):
			var r = FUN.feed(sid)
			if r == "no_bao": sc._float(wp + Vector2(0, -30), L("冇普通包子", "沒有普通包子"), Color("#ffb0a0"), 15)
			sc._snd("click"); return true
		if k.begins_with("punch:"):
			var r2 = FUN.punch(sid)
			if r2 == "cd": sc._float(wp + Vector2(0, -30), L("打卡鐘冷卻緊", "打卡鐘冷卻中"), Color("#ffb0a0"), 15)
			sc._snd("click"); return true
	return false

# ---------------- 事件 → 浮字 ----------------
static func events(sc) -> void:
	var sim = sc.sim
	var evs = FUN.pop_events() + RN.pop_events()
	for e in evs:
		var sid = str(e.get("sid", ""))
		var at = sim.st_pos(sid) + Vector2(0, -150) if sid != "" and not sid.begins_with("_") else Vector2(390.0 / 2.0, sc.s2w(Vector2(0, sc.top_pad + 200)).y)
		match str(e.k):
			"down": sc._float(at, L(GAG[int(e.get("gag", 0)) % GAG.size()][0], GAG[int(e.get("gag", 0)) % GAG.size()][1]), Color("#ffb0a0"), 16, 2.2)
			"vet": sc._float(at, L("升職做老員工！", "升職為老員工！"), Color("#ffd27a"), 18, 2.0)
			"cashier": sc._float(at, L("升職做老收銀！算盤打到飛起", "升職為老收銀！算盤打得飛快"), Color("#ffd27a"), 18, 2.2)
			"captain": sc._float(at, L("升職做巡邏隊長！", "升職為巡邏隊長！"), Color("#ffd27a"), 18, 2.2)
			"punch": sc._float(at, L("打卡放工～", "打卡下班～"), Color("#bfe8ff"), 16)
			"mile": sc._float(at, L("速度翻倍！", "速度翻倍！"), Color("#ffe98a"), 22, 2.2)
			"street_combo": sc._float(at, L("街組合：%s！", "街組合：%s！") % str(e.get("n", "")), Color("#ffe98a"), 20, 2.4)
			"chain": sc._float(e.get("pos", at), L("連單 ×%s", "連單 ×%s") % FUN.txt_chain_mul(float(e.get("mul", 1.5))), Color("#ffe98a"), 18)
			"rush_warn": sc._float(at, L("更夫敲鑼：子時高峰要到！", "更夫敲鑼：子時高峰要到！"), Color("#ffd27a"), 18, 2.2)
			"rush_peak": sc._float(at, L("子時高峰！", "子時高峰！"), Color("#ff7a5a"), 24, 2.0)
			"vip_in": sc._float(at, L("限時大客：%s 要 %d 件！", "限時大客：%s 要 %d 件！") % [str(e.get("name", "")), int(e.get("n", 0))], Color("#ffcf6a"), 18, 2.4)
			"vip_ok": sc._float(at, L("大客收齊！×%s", "大客收齊！×%s") % FUN.txt_vip_mul(), Color("#ffe98a"), 22, 2.2)
			"vip_fail": sc._float(e.get("pos", at), L("「唔夠貨？下次啦。」", "「貨不夠？下次吧。」"), Color("#d9cdd2"), 15, 2.0)
			"critic":
				var b = e.get("best", ["", 1])
				sc._float(sim.st_pos(str(b[0])) + Vector2(0, -160), L("陰間米芝蓮：%d 星", "陰間米其林：%d 星") % int(b[1]), Color("#ffe98a") if int(b[1]) >= 3 else Color("#d9cdd2"), 20, 2.6)
			"reg_name": sc._float(at, L("熟客：%s", "熟客：%s") % str(e.get("name", "")), Color("#ff9ac0"), 16, 2.0)
			"renown_up": sc._float(at, L("名聲升級：%s", "名聲升級：%s") % str(e.get("name", "")), Color("#ffd27a"), 22, 2.6)
			"trend_new": pass
