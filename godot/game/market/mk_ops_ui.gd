# 過勞鬼市集 M1 營運畫面（正式版）。一次只顯示當前嗰條街。
# 畫面座標（街名牌列下面，由上至下排，唔重疊）：
#   ① 人手列：〔櫃檯 n/3〕〔巡邏 n/4〕〔收銀箱 金額・收〕——撳櫃檯／巡邏開人手面板，撳收銀箱即收
#   ② 治安卡：最急嗰件事件（類型、邊個、剩幾多秒、特色版描述）；撳＝主角親自擺平；仲有其他就寫「另有 N 件」
#   ③ 對白條：巡邏鬼擺平後嗰句、甄好賣誇獎、巡邏人數台詞（文案詞庫）
# 世界座標（同台、客人一齊按 y 排）：櫃檯員企櫃台後面、巡邏鬼企崗／去追、搞事鬼（四類各有道具同動作）、
#   抓到／漏網／損失演出、攤位「換貨中／停工」牌、店員過勞四段小卡（已選用美術第 1 款）。
# 面板（底部資料卡，Godot 控件，自動換行唔出格）：
#   人手面板 open_panel(sc, "ctr"/"pat")：名單、撤回、調人；「多派一隻救回幾多 vs 村子少咗幾多」
#   貨架卡 sheet_rows(sc, box, sid)：主貨／副貨（Lv25 解鎖）、揀副貨、產能比例、智能補貨
# mv_scene 掛鈎：draw(sc, ctx)、tap(sc, p)、world_items(sc, ctx, items)、sheet_rows(sc, box, sid)。
extends RefCounted

const MK = preload("res://game/market/mk_data.gd")
const MKO = preload("res://game/market/mk_ops.gd")
const MKU = preload("res://game/market/mk_ui.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const BAR_H := 40.0
const TYPE_N := {"steal_cash": ["偷錢", "偷錢"], "steal_goods": ["偷貨", "偷貨"], "cut_queue": ["打尖", "插隊"], "brawl": ["嗌交", "吵架"]}
const TYPE_C := {"steal_cash": "#c9a227", "steal_goods": "#b8562a", "cut_queue": "#3f7fb0", "brawl": "#b8322a"}
static var _fx: Array = []        # 演出中：{"k", "ev", "t0", "life", ...}
static var _says: Array = []      # 對白條：{"who", "t", "t0", "life"}
static var _ow := {}              # 過勞小卡狀態：sid → {"down": bool, "up_t": float, "say_t": float}
static var _panel := ""           # 開緊嘅人手面板（""＝冇）
static var lay: Array = []         # [57] 今格世界入面已畫嘅牌／卡（世界座標）：後畫嗰塊避開、唔貼住；對白框都避
static var lay_bad: Array = []     # [57] 測試用：避唔開（仲撞）嘅記錄
static var hud_bot := 0.0         # 我哋呢疊（人手列＋治安卡＋對白條）今格嘅底（畫面座標）；M2 嘅 HUD 排喺佢下面
static var _culprit := {}         # 事件 id → 搞事鬼圖鍵
static var _title := {"st": "", "t0": -99.0}   # 切街標題卡（已選用美術：牌坊 A／食街／奢侈品店橫幅）
static func banner_key(street: String) -> String:
	var k = "mk_bn_" + street
	return k if Spr.ok(k) else ("mk_bn_gate" if Spr.ok("mk_bn_gate") else "")

static func on(sc) -> bool: return MKU.on(sc) and MK.is_open(MK.cur())
static func y0(sc) -> float: return MKU.strip_y(sc) + MKU.STRIP_H
static func L(yue: String, zh: String) -> String: return yue if MK.yue() else zh

# ============================ 畫面座標層 ============================
static func _pill(sc, ctx, key: String, x: float, y: float, w: float, h: float, txt: String, fill: String, col: Color, size := 15, stroke := "#5e4a30") -> void:
	Art.rr(ctx, x, y, w, h, 8, fill, stroke, 1.5)
	ctx.font = "900 %dpx sans-serif" % size
	var s = txt
	while s.length() > 2 and ctx.measureText(s).width > w - 10.0: s = s.substr(0, s.length() - 2) + "…"   # 唔出格
	sc._txt(ctx, s, x + w / 2.0, y + h / 2.0 + 1, size, col, "center", 900, 0)
	if key != "": sc._btns[key] = Rect2(x, y, w, h)

static func draw(sc, ctx) -> void:
	hud_bot = 0.0
	if not on(sc): return
	_pump(sc)
	var street = MK.cur(); var y = y0(sc); var W = float(sc.FW)
	ctx.fillStyle = "rgba(38,24,14,.86)"; ctx.fillRect(0, y, W, BAR_H)
	var cn = MKO.counter_n(street); var pn = MKO.patrol_n(street)
	_pill(sc, ctx, "mko:ctr", 6, y + 4, 104, BAR_H - 8, L("櫃檯 %d/%d", "櫃檯 %d/%d") % [cn, MKO.cap("ctr")], "rgba(243,214,138,.96)" if cn > 0 else "rgba(96,70,46,.96)", Color("#3a2414") if cn > 0 else Color("#f5e8cc"))
	_pill(sc, ctx, "mko:pat", 116, y + 4, 104, BAR_H - 8, L("巡邏 %d/%d", "巡邏 %d/%d") % [pn, MKO.cap("pat")], "rgba(243,214,138,.96)" if pn > 0 else "rgba(96,70,46,.96)", Color("#3a2414") if pn > 0 else Color("#f5e8cc"))
	var tl = MKO.till(street)
	if tl > 0.0:
		var pulse = 0.5 + 0.5 * sin(float(sc.t) * 5.0) if cn <= 0 else 0.0
		_pill(sc, ctx, "mko:till", 226, y + 4, W - 232.0, BAR_H - 8, L("收銀箱 %s・收", "收銀箱 %s・收") % MD.fmt(tl), "rgba(%d,96,30,.97)" % int(130 + 50 * pulse), Color("#fff3c8"), 15, "#f3d68a")
	else:
		_pill(sc, ctx, "", 226, y + 4, W - 232.0, BAR_H - 8, L("收銀箱 已入帳", "收銀箱 已入帳"), "rgba(64,48,34,.92)", Color("#b8ac9c"), 14)
	var cy = y + BAR_H + 4.0
	# ② 治安卡（最急嗰件）
	var evs = MKO.events(street)
	if evs.size():
		var e = evs[0]
		for x in evs: if str(x.st) == "open" and (str(e.st) != "open" or float(x.t) > float(e.t)): e = x
		var chase = str(e.st) == "chase"
		var left = maxf(0.0, MKO.cf("events", "deadline_s", 20.0) - float(e.t))
		var tn = MK.T(TYPE_N.get(str(e.k), [str(e.k), str(e.k)]))
		var head = "%s！%s" % [tn, MK.T(e.get("n", ["", ""]))]
		var desc = MK.T(e.desc) if e.get("desc") is Array else ""
		ctx.font = "700 14px sans-serif"
		var dl: Array = sc._wrap(ctx, desc, W - 48.0) if desc != "" else []
		if dl.size() > 2: dl = [dl[0], str(dl[1]).substr(0, maxi(1, str(dl[1]).length() - 1)) + "…"]
		var ch = 34.0 + 19.0 * dl.size() + (6.0 if dl.size() else 0.0)
		Art.rr(ctx, 8, cy, W - 16.0, ch, 10, "rgba(120,96,24,.96)" if chase else "rgba(150,36,30,.96)", "#f3d68a" if chase else "#ffd0c0", 2.0)
		Art.rr(ctx, 14, cy + 6, 6, ch - 12, 3, str(TYPE_C.get(str(e.k), "#fff")))
		ctx.font = "900 16px sans-serif"
		var hs = head
		while hs.length() > 4 and ctx.measureText(hs).width > W - 136.0: hs = hs.substr(0, hs.length() - 2) + "…"
		sc._txt(ctx, hs, 28, cy + 18, 16, Color("#fff6e0"), "left", 900, 0)
		for i in dl.size(): sc._txt(ctx, str(dl[i]), 28, cy + 40 + 19.0 * i, 14, Color("#ffe9d0"), "left", 700, 0)
		var bt = L("巡邏追緊", "巡邏鬼在追") if chase else (L("我嚟 %d", "我來 %d") % int(ceil(left)))
		_pill(sc, ctx, "", W - 104, cy + 5, 88, 26, bt, "rgba(255,246,224,.95)", Color("#7a1f14") if not chase else Color("#5a4410"), 14, "#3a2414")
		sc._btns["mkoe:%d" % int(e.id)] = Rect2(8, cy, W - 16.0, ch)
		if evs.size() > 1: sc._txt(ctx, L("另有 %d 件", "另有 %d 件") % (evs.size() - 1), W - 60, cy + ch - 10, 13, Color("#ffe0b0"), "center", 900, 0)
		cy += ch + 4.0
	# ③ 對白條
	var now = float(sc.t)
	for i in range(_says.size() - 1, -1, -1): if now - float(_says[i].t0) > float(_says[i].life): _says.remove_at(i)
	if _says.size():
		var sy = _says[0]
		ctx.font = "700 14px sans-serif"
		var ls: Array = sc._wrap(ctx, "%s：%s" % [str(sy.who), str(sy.t)], W - 40.0)
		if ls.size() > 3: ls = ls.slice(0, 3)
		var sh = 12.0 + 19.0 * ls.size()
		var a = clampf(minf((now - float(sy.t0)) / 0.25, (float(sy.life) - (now - float(sy.t0))) / 0.4), 0.0, 1.0)
		ctx.globalAlpha = a
		Art.rr(ctx, 8, cy, W - 16.0, sh, 10, "rgba(250,244,228,.97)", "#5e4a30", 2.0)
		for i in ls.size(): sc._txt(ctx, str(ls[i]), 20, cy + 16 + 19.0 * i, 14, Color("#2b1d12"), "left", 700, 0)
		ctx.globalAlpha = 1.0
	hud_bot = cy + (0.0 if _says.is_empty() else 12.0 + 19.0 * 3.0)
	# 搞事鬼喺畫面外：邊緣出指示牌（撳＝鏡頭移過去）
	var oy = maxf(hud_bot + 30.0, y + 200.0)
	for e2 in evs:
		var wp = ev_pos(sc, e2); var spt: Vector2 = sc.w2s(wp)
		if spt.x >= 20.0 and spt.x <= W - 20.0 and spt.y >= hud_bot + 20.0 and spt.y <= float(sc.view_h()) - 40.0: continue
		var right = spt.x > W / 2.0
		var tn2 = MK.T(TYPE_N.get(str(e2.k), ["", ""]))
		var lab = (tn2 + " ▶") if right else ("◀ " + tn2)
		var px = W - 96.0 if right else 8.0
		ctx.globalAlpha = 0.85 + 0.15 * sin(now * 8.0)
		_pill(sc, ctx, "mkog:%d" % int(e2.id), px, oy, 88, 32, lab, "rgba(170,36,30,.97)", Color("#fff6e0"), 15, "#ffd0c0")
		ctx.globalAlpha = 1.0
		oy += 38.0
	for tt in MKO.pop_toasts(): load("res://game/market/mk_fun_ui.gd").toast(sc, str(tt.t), Color(str(tt.c)), 2.2)   # 通告牌（左欄、有底板）；之前浮喺畫面中間會壓住潮流榜／加班牌
	# 切街標題卡：牌坊橫幅＋街名（1.8 秒，淡入淡出；有治安卡就唔出，避免疊住）
	if str(_title.st) != street: _title = {"st": street, "t0": now}
	var tu = now - float(_title.t0)
	if tu < 1.8 and evs.is_empty() and Spr.ok("mk_bn_gate"):
		var ta = clampf(minf(tu / 0.2, (1.8 - tu) / 0.4), 0.0, 1.0)
		ctx.globalAlpha = ta
		var bw = W - 40.0; var bh = bw * 260.0 / 780.0; var by = cy + 6.0
		Art.rr(ctx, 17, by - 3, bw + 6, bh + 6, 16, "rgba(44,28,16,.92)", "#f3d68a", 2.0)
		Art.put(ctx, "mk_bn_gate", W / 2.0, by + bh, bw, bh)
		sc._txt(ctx, MK.name(street), W / 2.0, by + bh * 0.36, 26, Color("#3a2414"), "center", 900, 0, "serif")
		ctx.globalAlpha = 1.0
		hud_bot = maxf(hud_bot, by + bh + 6.0)

static func _pump(sc) -> void:   # 攞演出事件／對白
	var now = float(sc.t)
	for d in MKO.pop_fx():
		var k = str(d.get("k", ""))
		if k in ["ev_done", "ev_lost"]: _fx.append({"k": k, "ev": d.ev, "by": d.get("by", ""), "loss": d.get("loss", 0.0), "capped": d.get("capped", false), "info": d.get("info", {}), "t0": now, "life": 1.8})
		elif k == "ev_miss": _fx.append({"k": k, "id": d.id, "t0": now, "life": 1.0})
		elif k == "till" and str(d.get("by", "")) != "ctr": _fx.append({"k": k, "amt": d.amt, "t0": now, "life": 1.0})
	for d in MKO.pop_say():
		if str(d.get("k", "")) == "pat" and str(d.get("sid", "")) != "":
			var gh = sc.sim.ghost(d.who)
			_says.append({"who": (str(J.gp(gh, "name")) if gh != null else L("巡邏鬼", "巡邏鬼")), "t": str(d.t), "t0": now, "life": 4.5})
		else: _says.append({"who": str(d.who), "t": str(d.t), "t0": now, "life": 4.5})
	while _says.size() > 2: _says.pop_front()
	for i in range(_fx.size() - 1, -1, -1): if now - float(_fx[i].t0) > float(_fx[i].life): _fx.remove_at(i)

static func tap(sc, p: Vector2) -> bool:
	if not on(sc): return false
	var sim = sc.sim; var street = MK.cur()
	for k in sc._btns.keys():
		var ks = str(k)
		if not (ks.begins_with("mko:") or ks.begins_with("mkoe:") or ks.begins_with("mkog:")) or not sc._btns[k].has_point(p): continue
		if ks.begins_with("mkoe:"): MKO.handle_event(sim, int(ks.substr(5)))
		elif ks.begins_with("mkog:"):
			for e in MKO.events(street):
				if int(e.id) == int(ks.substr(5)) and sc.has_method("focus"): var wp = ev_pos(sc, e); sc.focus(wp.y, float(sc.top_pad) + float(sc.view_h()) * 0.62, wp.x)
		elif ks == "mko:till": MKO.collect(sim, street, "tap")
		elif ks == "mko:ctr" or ks == "mko:pat": open_panel(sc, ks.substr(4))
		sc._snd("click")
		return true
	return false

# ============================ 世界座標層 ============================
static func _ctr_pos(sim, i: int, n: int) -> Vector2:
	return Vector2(lerpf(float(sim.L.counter_x0) + 30.0, float(sim.L.counter_x1) - 30.0, (i + 0.5) / maxf(1.0, float(n))), float(sim.L.counter_y) - 8.0)
static func _post_pos(sc, i: int) -> Vector2:   # 巡邏崗：櫃台左下一字排
	var sim = sc.sim
	var x = clampf(float(sim.L.counter_x0) - 6.0 + 30.0 * i, sc.vx0() + 22.0, sc.vx1() - 22.0)
	return Vector2(x, float(sim.L.counter_y) + 64.0 + 6.0 * (i % 2))
static func ev_pos(sc, e: Dictionary) -> Vector2:   # 搞事鬼企邊
	var sim = sc.sim
	match str(e.k):
		"steal_cash": return Vector2(float(sim.L.counter_x1) - 26.0, float(sim.L.counter_y) + 30.0)
		"cut_queue": return sim.queue_pos(1) + Vector2(-34, 4)
		"brawl": return sim.st_pos(str(e.sid)) + Vector2(-14, 62)
	return sim.st_pos(str(e.sid)) + Vector2(44, 46)
static func _clamp(sc, p: Vector2) -> Vector2: return Vector2(clampf(p.x, sc.vx0() + 24.0, sc.vx1() - 24.0), p.y)
static func culprit_key(sim, e: Dictionary) -> String:
	var id = int(e.id)
	if _culprit.has(id): return _culprit[id]
	var arts = []
	for cid in MD.map_def(sim.ci()).get("customers", []):
		var a = str(MD.cust_def(str(cid)).get("art", ""))
		if a != "" and Spr.ok(a) and not arts.has(a): arts.append(a)
	var k = arts[id % arts.size()] if arts.size() else "youhun"
	if _culprit.size() > 40: _culprit.clear()
	_culprit[id] = k
	return k
const GAP := 6.0   # [57] 牌與牌、牌與畫面邊最少隔幾多（唔貼住）
static func _avoid(sc, r: Rect2) -> Rect2:   # [57] 撞到已畫嘅牌／卡／加班牌：向上推（逐次推到啱啱避開），推唔開就記低
	var obs: Array = lay.duplicate()
	if ResourceLoader.exists("res://game/market/mk_fun_ui.gd"):
		var fu = load("res://game/market/mk_fun_ui.gd")
		for k in fu._wbtn: obs.append(fu._wbtn[k])
		for q in fu.grp: obs.append(q)
	var r0 = r
	for dn in [false, true]:   # 先向上推；推上去鑽入頂部牌／生產鏈掣就改向下推
		r = r0
		var ok = false
		for _i in 10:
			var hit = false
			for q in obs:
				var g = (q as Rect2).grow(GAP - 0.5)
				if g.intersects(r): r.position.y = (g.end.y + 0.5 if dn else g.position.y - 0.5 - r.size.y); hit = true
			if not hit: ok = true; break
		if ok and (dn or not sc.mk_hid_w(r)): return r
	lay_bad.append(r)
	return r
static func _tag(sc, ctx, p: Vector2, txt: String, fill: String, col := Color("#fff6e0"), size := 15, avoid := true) -> Vector2:
	ctx.font = "900 %dpx sans-serif" % size
	var w = ctx.measureText(txt).width + 16.0
	var lo = maxf(sc.vx0(), float(sc.s2w(Vector2(0, 0)).x)) + GAP; var hi = minf(sc.vx1(), float(sc.s2w(Vector2(sc.FW, 0)).x)) - w - GAP   # 夾喺畫面入面，唔出格、唔貼邊
	var x = clampf(p.x - w / 2.0, lo, maxf(lo, hi))
	var r = Rect2(x, p.y - 12, w, 24)
	if avoid: r = _avoid(sc, r)
	if sc.mk_hid_w(r): return r.get_center()   # 撞到頂部牌：成塊唔畫
	lay.append(r)
	Art.rr(ctx, r.position.x, r.position.y, w, 24, 8, fill, "#2a1a10", 1.5)
	sc._txt(ctx, txt, r.position.x + w / 2.0, r.position.y + 13, size, col, "center", 900, 0)
	return r.get_center()
static func _char(sc, ctx, key: String, p: Vector2, flip: bool, walk: bool, seed: float, s := 1.0, alpha := 1.0) -> void:
	Art.draw_char(ctx, key, p.x, p.y, float(sc.CS) * 0.9 * s, {"t": float(sc.t) + seed, "seed": seed, "walk": walk, "flip": flip, "alpha": alpha, "tamed": true, "shadow": true})

static func world_items(sc, ctx, items: Array) -> void:
	lay.clear(); lay_bad.clear()   # [57] 每格重新排
	if not on(sc) or sc.sim == null or sc.sim.L.is_empty(): return
	var sim = sc.sim; var street = MK.cur(); var now = float(sc.t)
	# 櫃檯員
	var cl = MKO.staff_of("ctr", street)
	for i in cl.size():
		var gh = sim.ghost(cl[i]); if gh == null: continue
		var p = _ctr_pos(sim, i, cl.size()); var kk = str(J.gp(gh, "k")); var sd = float(i) * 1.7
		items.append([p.y - 1.0, func(): _char(sc, ctx, kk, p, i % 2 == 1, false, sd)])
	if float(MKO.st().get("ctr_stop", 0.0)) > MKO.clk() and str(MKO.st().get("ctr_stop_st", "")) == street:
		var cp = Vector2((float(sim.L.counter_x0) + float(sim.L.counter_x1)) / 2.0, float(sim.L.counter_y) - 96.0)
		items.append([99990.0, func(): _tag(sc, ctx, cp, L("冇櫃檯員：夥計去收錢，全街停手", "沒櫃檯員：店員去收錢，全街停手"), "rgba(120,86,30,.95)", Color("#fff3c8"), 14)])
	# 巡邏鬼：企崗／去追
	var evs = MKO.events(street); var chasing = {}
	for e in evs: if str(e.st) == "chase" and e.who != null: chasing[J.str(e.who)] = e
	var pl = MKO.staff_of("pat", street)
	for i in pl.size():
		var gh = sim.ghost(pl[i]); if gh == null: continue
		var kk = str(J.gp(gh, "k")); var post = _post_pos(sc, i); var sd = 3.0 + i * 1.3
		if chasing.has(J.str(pl[i])):
			var e = chasing[J.str(pl[i])]
			var tgt = _clamp(sc, ev_pos(sc, e)) + Vector2(-30, 4)
			var u = clampf(1.0 - float(e.at) / maxf(0.1, MKO.cf("patrol", "handle_s", 4.0)), 0.0, 1.0)
			var u2 = clampf(u / 0.7, 0.0, 1.0)
			var p = post.lerp(tgt, u2 * u2 * (3.0 - 2.0 * u2))
			var fl = tgt.x < post.x; var wk = u2 < 1.0
			items.append([p.y, func(): _draw_chaser(sc, ctx, kk, p, fl, wk, sd)])
		else:
			items.append([post.y, func(): _char(sc, ctx, kk, post, false, false, sd)])
	if pl.size():
		var pp = _post_pos(sc, 0) + Vector2(15.0 * (pl.size() - 1), 16.0)
		items.append([99980.0, func(): sc._txt(ctx, L("巡邏崗", "巡邏崗"), pp.x, pp.y, 13, Color("#f3d68a"), "center", 900, 3)])
	# 搞事鬼（四類各自睇得明）
	for e in evs:
		var ee = e
		var p = _clamp(sc, ev_pos(sc, e))
		items.append([p.y + 0.2, func(): _draw_event(sc, ctx, ee, p)])
	# 演出：抓到／漏網／損失
	for f in _fx:
		var ff = f
		items.append([99995.0, func(): _draw_fx(sc, ctx, ff)])
	# 攤位狀態牌＋過勞小卡
	for sid in MK.sids_on(sim.ci(), street):
		if not sim.unlocked(sid): continue
		var sp = sim.st_pos(sid); var s2 = sid
		var sw = float(MKO.st().swap.get(sid, 0.0))
		if sw > 0.0: items.append([99991.0, func(): _tag(sc, ctx, sp + Vector2(0, -36), L("換貨中 %d 秒", "換貨中 %d 秒") % int(ceil(sw)), "rgba(110,84,40,.96)")])
		elif float(MKO.st().brawl.get(sid, 0.0)) > MKO.clk():
			var bl = float(MKO.st().brawl[sid]) - MKO.clk()
			items.append([99991.0, func(): _tag(sc, ctx, sp + Vector2(0, -36), L("嗌交停工 %d 秒", "吵架停工 %d 秒") % int(ceil(bl)), "rgba(150,36,30,.95)")])
		items.append([99992.0, func(): _draw_ow(sc, ctx, s2)])

static func _draw_chaser(sc, ctx, kk: String, p: Vector2, fl: bool, wk: bool, sd: float) -> void:
	_char(sc, ctx, kk, p, fl, wk, sd)
	sc._txt(ctx, L("嗶——！", "嗶——！"), p.x, p.y - 78.0 - 3.0 * sin(float(sc.t) * 14.0), 15, Color("#fff3a0"), "center", 900, 4)
static func _draw_event(sc, ctx, e: Dictionary, p: Vector2) -> void:
	var sim = sc.sim; var now = float(sc.t); var key = culprit_key(sim, e); var sd = float(int(e.id) % 7)
	var chase = str(e.st) == "chase"
	var left = maxf(0.0, MKO.cf("events", "deadline_s", 20.0) - float(e.t))
	var jig = sin(now * 16.0) * 2.0
	match str(e.k):
		"steal_cash":   # 偷錢：伸手入收銀箱，冥幣一個個飛入袋
			_char(sc, ctx, key, p + Vector2(jig * 0.4, 0), true, false, sd)
			var box = Vector2(float(sim.L.counter_x1) - 44.0, float(sim.L.counter_y) - 30.0)
			for i in 3:
				var u = fmod(now * 1.4 + i * 0.33, 1.0)
				var q = box.lerp(p + Vector2(0, -44), u); q.y -= sin(u * PI) * 26.0
				sc._coin_ic(ctx, q.x, q.y, 6.5)
		"steal_goods":   # 偷貨：抱住成疊貨，躡手躡腳
			_char(sc, ctx, key, p + Vector2(sin(now * 3.0) * 6.0, 0), sin(now * 3.0) > 0.0, true, sd)
			var gid = MKO.good_of(str(e.sid))
			for i in 3: sc._icon(ctx, gid, p.x + sin(now * 3.0) * 6.0 + (i - 1) * 9.0, p.y - 58.0 - i * 8.0 + jig * 0.5, 24.0)
		"cut_queue":   # 插隊：夾硬逼入條龍，後面客人冒火
			_char(sc, ctx, key, p + Vector2(absf(sin(now * 5.0)) * 12.0, 0), false, true, sd)
			for i in 3:
				var ax = p.x + 30.0 + i * 12.0 + fmod(now * 30.0, 12.0)
				sc._txt(ctx, "»", ax, p.y - 30.0, 20, Color("#ffd27a"), "center", 900, 3)
			for i in 2:
				var q = sim.queue_pos(i + 2) + Vector2(0, -92.0 - 4.0 * sin(now * 9.0 + i))
				sc._txt(ctx, L("嬲", "氣"), q.x, q.y, 16, Color("#ff9a8a"), "center", 900, 4)
		"brawl":   # 吵架打鬧：兩隻鬼面對面推撞，中間爆星
			var k2 = culprit_key(sim, {"id": int(e.id) + 3})
			var push = sin(now * 9.0) * 5.0
			_char(sc, ctx, key, p + Vector2(-16.0 + push, 0), false, false, sd)
			_char(sc, ctx, k2, p + Vector2(22.0 - push, 2), true, false, sd + 2.0)
			var c = p + Vector2(3, -52)
			ctx.strokeStyle = "#ffe27a"; ctx.lineWidth = 3.0
			for i in 6:
				var a = i * PI / 3.0 + now * 4.0; var r0 = 6.0; var r1 = 15.0 + 3.0 * sin(now * 18.0 + i)
				ctx.beginPath(); ctx.moveTo(c.x + cos(a) * r0, c.y + sin(a) * r0); ctx.lineTo(c.x + cos(a) * r1, c.y + sin(a) * r1); ctx.stroke()
	# 頭頂牌：類型＋倒數條
	var tn = MK.T(TYPE_N.get(str(e.k), [str(e.k), str(e.k)]))
	var tp = p + Vector2(0, -104)
	var pulse = 1.0 if chase else 0.85 + 0.15 * sin(now * 8.0)
	ctx.globalAlpha = pulse
	if not chase: tp.y -= 4.0   # [57] 倒數條連埋入牌一齊避
	tp = _tag(sc, ctx, tp, tn + "！", "rgba(120,96,24,.97)" if chase else "rgba(170,36,30,.97)", Color("#fff6e0"), 16)
	ctx.globalAlpha = 1.0
	if not chase and not sc.mk_hid_w(Rect2(tp.x - 22.0, tp.y + 12.0, 44.0, 8.0)):
		var bw = 44.0; var k = clampf(left / maxf(1.0, MKO.cf("events", "deadline_s", 20.0)), 0.0, 1.0)
		var bx = clampf(tp.x - bw / 2.0, sc.vx0() + 2.0, sc.vx1() - bw - 2.0)
		Art.rr(ctx, bx, tp.y + 14, bw, 5, 2, "rgba(44,28,16,.85)")
		Art.rr(ctx, bx, tp.y + 14, bw * k, 5, 2, "#ffd27a" if k > 0.35 else "#ff6a5a")

static func _draw_fx(sc, ctx, f: Dictionary) -> void:
	var now = float(sc.t); var u = clampf((now - float(f.t0)) / float(f.life), 0.0, 1.0)
	var rise = -26.0 * u; var a = clampf(1.0 - (u - 0.7) / 0.3, 0.0, 1.0)
	ctx.globalAlpha = a
	match str(f.k):
		"ev_done":
			var e: Dictionary = f.ev; var p = _clamp(sc, ev_pos(sc, e))
			var key = culprit_key(sc.sim, e)
			_char(sc, ctx, key, p + Vector2(-60.0 * u, 0), true, true, 1.0, 1.0 - 0.3 * u, a)   # 畀人拎走
			_tag(sc, ctx, p + Vector2(0, -104 + rise), (L("主角出手！名聲 +2", "主角出手！名聲 +2") if str(f.by) == "tap" else L("捉到！名聲 +1", "抓到！名聲 +1")), "rgba(46,120,60,.97)", Color("#f0ffe0"), 16)
		"ev_miss":
			for e in MKO.events():
				if int(e.id) == int(f.id): _tag(sc, ctx, _clamp(sc, ev_pos(sc, e)) + Vector2(0, -132 + rise), L("畀佢走甩！換下一隻追", "被他溜了！換下一隻追"), "rgba(150,120,30,.97)", Color("#fff6d0"), 14)
		"ev_lost":
			var e2: Dictionary = f.ev; var p2 = _clamp(sc, ev_pos(sc, e2))
			var key2 = culprit_key(sc.sim, e2)
			_char(sc, ctx, key2, p2 + Vector2(70.0 * u, -6.0 * sin(u * PI * 3.0)), false, true, 1.0, 1.0, a)   # 得手走人
			var tx = L("虛驚一場（今個鐘損失到頂）", "虛驚一場（這段時間損失已到上限）")
			if not J.t(f.capped):
				match str(e2.k):
					"steal_cash": tx = L("冇人理：畀人偷走 %s", "沒人管：被偷走 %s") % MD.fmt(float(f.loss))
					"steal_goods": tx = L("冇人理：唔見咗 %d 件貨", "沒人管：少了 %d 件貨") % int(J.num((f.info as Dictionary).get("n", 0)))
					"cut_queue": tx = L("冇人理：嬲走 %d 位客", "沒人管：氣走 %d 位客人") % int(J.num((f.info as Dictionary).get("n", 0)))
					"brawl": tx = L("冇人理：兩檔停工 15 秒", "沒人管：兩攤停工 15 秒")
			if str(e2.k) == "steal_cash" and not J.t(f.capped):
				for i in 4: sc._coin_ic(ctx, p2.x + 70.0 * u + i * 9.0, p2.y - 50.0 - i * 6.0 - 20.0 * u, 6.0)
			_tag(sc, ctx, p2 + Vector2(0, -104 + rise), tx, "rgba(90,30,30,.97)", Color("#ffd8c8"), 14)
		"till":
			var cp = Vector2(float(sc.sim.L.counter_x1) - 44.0, float(sc.sim.L.counter_y) - 60.0 + rise)
			sc._txt(ctx, "+" + MD.fmt(float(f.amt)), cp.x, cp.y, 18, Color("#ffe27a"), "center", 900, 4)
	ctx.globalAlpha = 1.0

# 店員過勞四段小卡（已選用美術第 1 款）：1 死頂（過勞 ≥70）、2 就嚟唔得（≥90）、3 趴低、4 食包復活（頭 2.5 秒）
static func ow_stage(sc, sid: String) -> int:
	var now = float(sc.t)
	if not _ow.has(sid): _ow[sid] = {"down": false, "up_t": -99.0, "say_t": -99.0}
	var o: Dictionary = _ow[sid]
	var down = MK.is_down(sid)
	if o.down and not down: o.up_t = now
	o.down = down
	if down: return 3
	if now - float(o.up_t) < 2.5: return 4
	var f = MK.fat(sid)
	if f >= 90.0: return 2
	if f >= MK.otf("warn", 70.0): return 1
	return 0
static func _draw_ow(sc, ctx, sid: String) -> void:
	var stg = ow_stage(sc, sid)
	if stg <= 0: return
	var now = float(sc.t); var sp = sc.sim.st_pos(sid)
	var w = 128.0; var h = 64.0
	var lo = maxf(sc.vx0(), float(sc.s2w(Vector2(0, 0)).x)) + 6.0; var hi = minf(sc.vx1(), float(sc.s2w(Vector2(sc.FW, 0)).x)) - w - 6.0   # 成張卡夾喺畫面入面，唔出格
	var x = clampf(sp.x - w / 2.0, lo, maxf(lo, hi)); var y = sp.y - 150.0
	var gr = _avoid(sc, Rect2(x - 3, y - 3, w + 6, h + 6 + 32.0))   # [57] 小卡連下面嗰行字成組避開其他牌（唔貼住）
	y = gr.position.y + 3.0 + (2.0 * sin(now * 3.0) if stg != 3 else 0.0)
	if sc.mk_hid_w(gr): return   # 撞到頂部牌：成組唔畫
	lay.append(gr)
	var edge = ["", "#ffd27a", "#ff9a5a", "#ff5a4a", "#9fe08a"][stg]
	Art.rr(ctx, x - 3, y - 3, w + 6, h + 6, 12, "rgba(44,28,16,.92)", edge, 2.5)
	if Spr.ok("mk_ow_%d" % stg): Art.put(ctx, "mk_ow_%d" % stg, x + w / 2.0, y + h, w, h)
	var cap = [L("", ""), L("死頂緊", "硬撐中"), L("就嚟唔得", "快不行了"), L("趴低咗！餵個包", "趴下了！餵個包子"), L("食飽返生！", "吃飽復活！")][stg]
	_tag(sc, ctx, Vector2(x + w / 2.0, y + h + 16), cap, "rgba(44,28,16,.94)", Color(edge), 14, false)
	var o: Dictionary = _ow[sid]
	if stg in [1, 2] and now - float(o.say_t) > 9.0 and sc.bubbles.is_empty():   # 抱怨泡（詞庫 20 句輪住出）
		o.say_t = now
		var tx = MKO.complain()
		if tx != "": sc._bubble(Vector2(x + w / 2.0, y - 8.0), tx, L("夥計", "店員"), 3.2)   # 泡出喺小卡上面，唔遮住小卡同「餵包」字

# ============================ 人手面板 ============================
static func _clear(box) -> void:
	for c in box.get_children(): box.remove_child(c); c.queue_free()
static func _wl(sc, t: String, sz: int, col: Color, w := 700) -> Label:
	var l = sc._lbl(t, sz, col, "sans", w); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.custom_minimum_size = Vector2(346, 0)
	return l
static func _btn(t: String, kind: String, h := 50.0) -> Button:
	var b = UIKit.btn(t, kind, false); b.custom_minimum_size = Vector2(0, h); b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size", 16); b.clip_text = true; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return b
static func candidate(sim) -> Variant:   # 建議調邊隻：村子產值最低（最閒）嗰隻
	var best = null; var bv = INF; var n = 0
	for gh in sim.pick_list():
		if str(J.gp(gh, "post")) in [MKO.POST_CTR, MKO.POST_PAT]: continue
		var v = float(MKO.ghost_value(sim, J.gp(gh, "id")).coins)
		if not J.t(J.gp(gh, "post")): v = -1.0
		if v < bv: bv = v; best = gh
		n += 1
		if n >= 12 or bv < 0.0: break
	return best
static func open_panel(sc, kind: String) -> void:
	var sim = sc.sim; var street = MK.cur()
	_panel = kind
	sc.sel = ""; sc.sheet.visible = true
	var box = sc.sheet_box; _clear(box)
	var n = MKO.counter_n(street) if kind == "ctr" else MKO.patrol_n(street); var mx = MKO.cap(kind)
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); box.add_child(h)
	h.add_child(sc._lbl("%s・%s" % [MK.name(street), (L("櫃檯", "櫃檯") if kind == "ctr" else L("巡邏隊", "巡邏隊"))], 22, sc.INK, "serif", 900))
	h.add_child(sc._lbl("%d／%d" % [n, mx], 20, sc.RED, "sans", 900))
	var sp = Control.new(); sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sp.mouse_filter = Control.MOUSE_FILTER_IGNORE; h.add_child(sp)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(42, 40); cb.focus_mode = Control.FOCUS_NONE
	cb.pressed.connect(func(): _panel = ""; sc.close_sheet()); h.add_child(cb)
	var bk = banner_key(street)
	if bk != "":   # 已選用美術橫幅（食街／奢侈品店／牌坊）
		var tr = TextureRect.new(); tr.texture = Spr.get_tex(bk); tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.custom_minimum_size = Vector2(346, 96); tr.mouse_filter = Control.MOUSE_FILTER_IGNORE; tr.clip_contents = true; box.add_child(tr)
	if kind == "ctr": box.add_child(_wl(sc, L("櫃檯員幫你收錢。冇人收：夥計每 20 秒要停手去收一次，收銀箱啲錢仲容易畀人偷。", "櫃檯員幫你收錢。沒人收：店員每 20 秒要停手去收一次，收銀箱的錢還容易被偷。"), 15, sc.DIMC))
	else: box.add_child(_wl(sc, L("巡邏鬼會去追小偷、打尖同嗌交嘅鬼。派越多捉得越穩，但唔會百分百。", "巡邏鬼會去追小偷、插隊和吵架的鬼。派越多抓得越穩，但不會百分百。"), 15, sc.DIMC))
	# 名單
	for gid in MKO.staff_of(kind, street):
		var gh = sim.ghost(gid); if gh == null: continue
		var r = HBoxContainer.new(); r.add_theme_constant_override("separation", 8); box.add_child(r)
		var nl = sc._lbl(str(J.gp(gh, "name")), 17, sc.INK, "sans", 900); nl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; nl.clip_text = true; r.add_child(nl)
		var rb = UIKit.btn(L("返村", "回村子"), "ghost", true); rb.custom_minimum_size = Vector2(96, 42); rb.focus_mode = Control.FOCUS_NONE
		var g2 = gid
		rb.pressed.connect(func(): MKO.unassign(sim, g2); sc._save(); sc._snd("click"); open_panel(sc, kind)); r.add_child(rb)
	# 比較：多派一隻救回幾多 vs 村子少咗幾多
	var cmp = PanelContainer.new(); cmp.add_theme_stylebox_override("panel", UIKit.sb(Color(0.3, 0.2, 0.08, 0.1), 8, sc.LINE, 1, Vector4(10, 8, 10, 8)))
	cmp.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(cmp)
	var cv = VBoxContainer.new(); cv.add_theme_constant_override("separation", 3); cv.mouse_filter = Control.MOUSE_FILTER_IGNORE; cmp.add_child(cv)
	var cand = candidate(sim) if n < mx else null
	var gv = MKO.ghost_value(sim, J.gp(cand, "id")) if cand != null else {"coins": 0.0, "txt": ""}
	var gain = 0.0
	if kind == "pat":
		var l0 = MKO.loss10(sim, street, n); var l1 = MKO.loss10(sim, street, n + 1)
		gain = l0 - l1
		cv.add_child(_wl2(sc, L("而家 %d 隻：大約捉到 %d%%，每 10 分鐘蝕約 %s", "現在 %d 隻：大約抓到 %d%%，每 10 分鐘損失約 %s") % [n, int(round(MKO.handle_rate(n) * 100.0)), MD.fmt(l0)], 15, sc.INK))
		if n < mx: cv.add_child(_wl2(sc, L("派多 1 隻：捉到 %d%%，每 10 分鐘救返 +%s", "多派 1 隻：抓到 %d%%，每 10 分鐘多救回 +%s") % [int(round(MKO.handle_rate(n + 1) * 100.0)), MD.fmt(gain)], 15, sc.GREEN, 900))
		else: cv.add_child(_wl2(sc, L("已經滿編。仲有漏網嘅，要你自己撳。", "已經滿編。還有漏網的，要你親自點。"), 15, sc.DIMC))
	else:
		var inc = MKO.income10(sim, street)
		if n <= 0:
			gain = inc * MKO.cf("counter", "stop_s", 3.0) / maxf(1.0, MKO.cf("counter", "auto_s", 20.0))
			cv.add_child(_wl2(sc, L("而家 0 隻：夥計去收錢，全街每 20 秒停 3 秒", "現在 0 隻：店員去收錢，全街每 20 秒停 3 秒"), 15, sc.INK))
			cv.add_child(_wl2(sc, L("派 1 隻：自動入帳唔使停，每 10 分鐘多賺約 +%s", "派 1 隻：自動入帳不用停，每 10 分鐘多賺約 +%s") % MD.fmt(gain), 15, sc.GREEN, 900))
		else:
			cv.add_child(_wl2(sc, L("而家 %d 隻：每 %d 秒自動入帳一次", "現在 %d 隻：每 %d 秒自動入帳一次") % [n, int(round(MKO.cf("counter", "staff_s", 6.0) / n))], 15, sc.INK))
			if n < mx: cv.add_child(_wl2(sc, L("派多 1 隻：收得更快，收銀箱啲錢更難畀人偷", "多派 1 隻：收得更快，收銀箱的錢更難被偷"), 15, sc.GREEN, 900))
			else: cv.add_child(_wl2(sc, L("已經滿編。", "已經滿編。"), 15, sc.DIMC))
	if cand != null:
		var cost = float(gv.coins)
		var ct = L("村子少咗：%s（%s）", "村子少了：%s（%s）") % [str(J.gp(cand, "name")), str(gv.txt)]
		if cost > 0.0: ct += L("，每 10 分鐘 −%s", "，每 10 分鐘 −%s") % MD.fmt(cost)
		cv.add_child(_wl2(sc, ct, 15, sc.RED))
		if kind == "pat" or n <= 0:
			var good = gain >= cost
			cv.add_child(_wl2(sc, (L("抵：救返嘅多過村子少咗嘅", "划算：救回的比村子少的多") if good else L("唔抵：呢條街未夠旺，遲啲先派", "不划算：這條街還不夠旺，晚點再派")), 16, sc.GREEN if good else sc.RED, 900))
	# 調人掣
	var ab: Button
	if n >= mx: ab = _btn(L("已經滿編", "已經滿編"), ""); ab.disabled = true
	elif cand == null: ab = _btn(L("村入面冇鬼可以調", "村裡沒有鬼可以調"), ""); ab.disabled = true
	else:
		ab = _btn(L("由村子調 %s 過嚟", "從村子調 %s 過來") % str(J.gp(cand, "name")), "gold", 56.0)
		var cid = J.gp(cand, "id")
		ab.pressed.connect(func(): MKO.assign(sim, kind, street, cid); sc._save(); sc._snd("click"); open_panel(sc, kind))
	box.add_child(ab)
	sc._ui_sync()
	await sc.get_tree().process_frame
	if is_instance_valid(sc) and is_instance_valid(sc.sheet) and sc.sheet.visible: sc._place_sheet()
static func _wl2(sc, t: String, sz: int, col: Color, w := 700) -> Label:
	var l = sc._lbl(t, sz, col, "sans", w); l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.custom_minimum_size = Vector2(326, 0)
	return l

# ============================ 貨架卡（攤位資料卡入面） ============================
static func slots(sim, sid: String) -> int: return MKO.staff_slots(sid, sim.lv(sid)) if MKO.on() else MD.slots(sid)
static func _good_n(gid: String) -> String: return MD.T(MD.good_def(gid).get("n", [gid, gid]))
static func sheet_rows(sc, box, sid: String) -> void:   # 攤位資料卡入面：一行摘要＋「調整」掣（詳細喺貨架面板，唔好撐爆資料卡）
	if not MKO.on(): return
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(0.3, 0.2, 0.08, 0.1), 8, sc.LINE, 1, Vector4(10, 4, 6, 4)))
	box.add_child(pc)
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 6); pc.add_child(h)
	var g1 = MKO.good_of(sid); var g2 = MKO.sub_of(sid)
	var t = L("貨架　主：%s", "貨架　主：%s") % _good_n(g1)
	if not MKO.sub_open(sid): t += L("　副：Lv%d 開", "　副：Lv%d 解鎖") % int(MKO.cf("goods2", "lv", 25.0))
	else: t += L("　副：%s", "　副：%s") % (_good_n(g2) if g2 != "" else L("未揀", "未選"))
	var l = sc._lbl(t, 15, sc.INK, "sans", 900); l.clip_text = true; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; l.custom_minimum_size = Vector2(120, 0); h.add_child(l)
	var b = UIKit.btn(L("調整貨架", "調整貨架"), "", true); b.custom_minimum_size = Vector2(104, 40); b.focus_mode = Control.FOCUS_NONE
	b.disabled = not MKO.sub_open(sid)
	b.pressed.connect(func(): sc._snd("click"); open_shelf(sc, sid)); h.add_child(b)

static func open_shelf(sc, sid: String) -> void:   # 貨架面板：主貨／副貨、揀副貨、產能分配、智能補貨
	var sim = sc.sim; var c = sim.ci()
	_panel = "shelf"
	sc.sel = ""; sc.sheet.visible = true
	var box = sc.sheet_box; _clear(box)
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); box.add_child(h)
	var tl = sc._lbl("%s・%s" % [MD.T(MD.st_def(sid).get("n", sid)), L("貨架", "貨架")], 21, sc.INK, "serif", 900); tl.clip_text = true; tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; h.add_child(tl)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(42, 40); cb.focus_mode = Control.FOCUS_NONE
	cb.pressed.connect(func(): _panel = ""; sc.open_sheet(sid)); h.add_child(cb)
	var v = box
	var g1 = MKO.good_of(sid); var g2 = MKO.sub_of(sid)
	var main_l = sc._lbl(L("主貨：%s", "主貨：%s") % _good_n(g1), 17, sc.INK, "sans", 900); main_l.clip_text = true; main_l.custom_minimum_size = Vector2(340, 0); v.add_child(main_l)
	var sw = float(MKO.st().swap.get(sid, 0.0))
	var sub_t = (L("副貨：%s", "副貨：%s") % _good_n(g2)) if g2 != "" else L("副貨：未揀（下面揀一樣）", "副貨：還沒選（在下面選一樣）")
	if sw > 0.0: sub_t += L("（換貨中 %d 秒）", "（換貨中 %d 秒）") % int(ceil(sw))
	var sub_l = sc._lbl(sub_t, 17, sc.RED if sw > 0.0 else sc.INK, "sans", 900); sub_l.clip_text = true; sub_l.custom_minimum_size = Vector2(340, 0); v.add_child(sub_l)
	v.add_child(_wl(sc, L("同一個檔可以賣兩樣貨，夥計共用。換貨免費，換完停 10 秒。", "同一個攤可以賣兩樣貨，店員共用。換貨免費，換完停 10 秒。"), 14, sc.DIMC))
	var grid = GridContainer.new(); grid.columns = 2; grid.add_theme_constant_override("h_separation", 6); grid.add_theme_constant_override("v_separation", 6); v.add_child(grid)
	var opts = MKO.sub_choices(c, sid)
	if g2 != "" and not opts.has(g2): opts.push_front(g2)
	for g in opts:
		var gg = str(g)
		var b = _btn(_good_n(gg), "gold" if gg == g2 else "", 46.0); b.custom_minimum_size = Vector2(168, 46); b.disabled = gg == g2
		b.pressed.connect(func(): MKO.set_sub(c, sid, gg); sc._save(); sc._snd("click"); open_shelf(sc, sid))
		grid.add_child(b)
	if g2 != "":
		var nb = _btn(L("唔賣副貨", "不賣副貨"), "ghost", 46.0); nb.custom_minimum_size = Vector2(168, 46)
		nb.pressed.connect(func(): MKO.set_sub(c, sid, ""); sc._save(); sc._snd("click"); open_shelf(sc, sid))
		grid.add_child(nb)
		v.add_child(sc._lbl(L("做貨分配", "產能分配"), 15, sc.DIMC, "sans", 900))
		var rr = HBoxContainer.new(); rr.add_theme_constant_override("separation", 6); v.add_child(rr)
		var cur = MKO.ratio(sid)
		for pr in [[0.3, L("主貨多", "主貨多")], [0.5, L("各一半", "各一半")], [0.7, L("副貨多", "副貨多")]]:
			var rv = float(pr[0])
			var rb = _btn(str(pr[1]), "gold" if absf(cur - rv) < 0.05 else "", 46.0)
			rb.pressed.connect(func(): MKO.set_ratio(sid, rv); sc._save(); sc._snd("click"); open_shelf(sc, sid))
			rr.add_child(rb)
		var sm = MKO.smart(sid)
		var sb2 = _btn((L("智能補貨：開（邊格缺貨先做邊格）", "智能補貨：開（哪格缺貨先做哪格）") if sm else L("智能補貨：關（照上面分配）", "智能補貨：關（照上面分配）")), "" if sm else "ghost", 46.0); sb2.add_theme_font_size_override("font_size", 15)
		sb2.pressed.connect(func(): MKO.set_smart(sid, not sm); sc._save(); sc._snd("click"); open_shelf(sc, sid))
		v.add_child(sb2)
	sc._ui_sync()
	await sc.get_tree().process_frame
	if is_instance_valid(sc) and is_instance_valid(sc.sheet) and sc.sheet.visible: sc._place_sheet()

# [57] 測試用：今格世界牌／卡之間、同畫面邊、同對白框有冇撞（唔貼住）
static func layout_bad(sc) -> Array:
	var bad: Array = []
	for r in lay_bad: bad.append("避唔開 %s" % str(r))
	for i in lay.size():
		var a: Rect2 = lay[i]
		for j in range(i + 1, lay.size()):
			var b: Rect2 = lay[j]
			if a.encloses(b) or b.encloses(a): continue   # 小卡同佢自己嗰行字
			if a.grow(GAP - 1.0).intersects(b): bad.append("牌貼住／重疊 %s %s" % [str(a), str(b)])
		var sa = Rect2(sc.w2s(a.position), sc.w2s(a.end) - sc.w2s(a.position))
		if sa.position.x < 2.0 or sa.end.x > float(sc.FW) - 2.0: bad.append("牌出格 %s" % str(sa))
		for d in sc._drects: if a.intersects(d): bad.append("對白框疊牌 %s %s" % [str(a), str(d)])
		for d in sc._wrects: if a.grow(GAP - 1.0).intersects(d): bad.append("要貨泡貼住／疊牌 %s %s" % [str(a), str(d)])
		if ResourceLoader.exists("res://game/market/mk_fun_ui.gd"):
			var fu = load("res://game/market/mk_fun_ui.gd")
			for g in fu.grp: if a.intersects(g): bad.append("牌疊加班牌 %s %s" % [str(a), str(g)])
	return bad
