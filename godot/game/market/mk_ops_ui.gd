# 過勞鬼市集 M1 營運畫面（佔位版，等美術）：街名牌列下面一條「人手／治安」列。
#   左：櫃檯 n/3 [−][＋]、巡邏 n/4 [−][＋]（＋＝由村子調一隻最閒嘅鬼過嚟；−＝放返村）
#   右：收銀箱未入帳金額（撳＝即收）
#   下面：呢條街未處理嘅治安事件（紅牌＋倒數；巡邏員追緊變黃）；撳＝主角親自處理（名聲 +2）
# mv_scene：draw_strip 之後叫 draw(sc, ctx)；MKU.tap 之前叫 tap(sc, p)。
extends RefCounted

const MK = preload("res://game/market/mk_data.gd")
const MKO = preload("res://game/market/mk_ops.gd")
const MKU = preload("res://game/market/mk_ui.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const ROW_H := 30.0
const EV_H := 30.0
const TYPE_N := {"steal_cash": ["偷錢", "偷錢"], "steal_goods": ["偷貨", "偷貨"], "cut_queue": ["打尖", "插隊"], "brawl": ["嘈交", "吵架"]}

static func on(sc) -> bool: return MKU.on(sc) and MK.is_open(MK.cur())
static func y0(sc) -> float: return MKU.strip_y(sc) + MKU.STRIP_H
static func _pill(sc, ctx, key: String, x: float, y: float, w: float, h: float, txt: String, fill: String, col: Color, size := 13) -> void:
	Art.rr(ctx, x, y, w, h, 6, fill, "#5e4a30", 1.2)
	sc._txt(ctx, txt, x + w / 2.0, y + h / 2.0 + 1, size, col, "center", 900, 0)
	if key != "": sc._btns[key] = Rect2(x, y, w, h)

static func draw(sc, ctx) -> void:
	if not on(sc): return
	var street = MK.cur(); var y = y0(sc); var yue = MK.yue()
	ctx.fillStyle = "rgba(14,8,18,.72)"; ctx.fillRect(0, y, sc.FW, ROW_H)
	var x = 6.0
	for row in [["ctr", "櫃檯", MKO.counter_n(street), MKO.cap("ctr")], ["pat", "巡邏", MKO.patrol_n(street), MKO.cap("pat")]]:
		sc._txt(ctx, "%s %d/%d" % [row[1], row[2], row[3]], x + 30, y + ROW_H / 2.0 + 1, 13, Color("#f5e8cc"), "center", 900, 0)
		_pill(sc, ctx, "mko:-" + str(row[0]), x + 62, y + 4, 24, ROW_H - 8, "−", "rgba(70,52,40,.95)", Color("#f5e8cc"), 16)
		_pill(sc, ctx, "mko:+" + str(row[0]), x + 90, y + 4, 24, ROW_H - 8, "＋", "rgba(243,214,138,.95)" if int(row[2]) < int(row[3]) else "rgba(60,54,50,.9)", Color("#3a2414"), 15)
		x += 122.0
	var tl = MKO.till(street)
	if tl > 0.0:
		_pill(sc, ctx, "mko:till", x, y + 4, sc.FW - x - 6.0, ROW_H - 8, ("收銀箱 %s 收" if yue else "收銀箱 %s 收") % MD.fmt(tl), "rgba(120,86,30,.95)", Color("#fff3c8"), 12)
	var ey = y + ROW_H + 3.0
	for e in MKO.events(street):
		var chase = str(e.st) == "chase"
		var left = maxf(0.0, MKO.cf("events", "deadline_s", 20.0) - float(e.t))
		var nm = MK.T(e.get("n", ["", ""]))
		var tn = MK.T(TYPE_N.get(str(e.k), [str(e.k), str(e.k)]))
		var tail = ("巡邏追緊" if yue else "巡邏員追捕中") if chase else (("撳我處理 %d 秒" if yue else "點我處理 %d 秒") % int(ceil(left)))
		var a = 1.0 if chase else 0.9 + 0.1 * sin(float(sc.t) * 7.0)
		ctx.globalAlpha = a
		_pill(sc, ctx, "mkoe:%d" % int(e.id), 10, ey, sc.FW - 20.0, EV_H - 4, "%s｜%s　%s" % [tn, nm, tail], "rgba(150,120,30,.94)" if chase else "rgba(160,40,32,.94)", Color("#fff6e0"), 12)
		ctx.globalAlpha = 1.0
		ey += EV_H
	for tt in MKO.pop_toasts():
		sc._float(sc.s2w(Vector2(sc.FW / 2.0, ey + 64.0)), str(tt.t), Color(str(tt.c)), 15)

static func tap(sc, p: Vector2) -> bool:
	if not on(sc): return false
	var sim = sc.sim; var street = MK.cur()
	for k in sc._btns.keys():
		var ks = str(k)
		if not (ks.begins_with("mko:") or ks.begins_with("mkoe:")) or not sc._btns[k].has_point(p): continue
		if ks.begins_with("mkoe:"): MKO.handle_event(sim, int(ks.substr(5)))
		elif ks == "mko:till": MKO.collect(sim, street, "tap")
		else:
			var kind = ks.substr(5)
			if ks[4] == "+":
				var r = "bad"
				for gh in sim.pick_list():   # 最閒嗰隻先（pick_list 已按「冇崗位 → 其他崗位」排）
					if str(J.gp(gh, "post")) in [MKO.POST_CTR, MKO.POST_PAT]: continue
					r = MKO.assign(sim, kind, street, J.gp(gh, "id"))
					if r != "bad": break
				if r == "full": MKO.toast("人滿了" if not MK.yue() else "夠人喇", "#ffd0a0")
				elif r != "ok": MKO.toast("村裡沒有閒著的鬼" if not MK.yue() else "村入面冇得閒嘅鬼", "#ffb0a0")
			else:
				var L = MKO.staff_of(kind, street)
				if L.size(): MKO.unassign(sim, L.back())
		sc._snd("click")
		return true
	return false
