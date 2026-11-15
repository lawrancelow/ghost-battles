# 陽間站崗・地盤場景主畫面（原生移植 street.js Turf.draw()）
#  逐句照搬：背景、範圍、設備框、路人（原生 Art）、崗位鬼、深度排序＋前景遮擋、拋物、粒子、飄字、閃白
#  仍然叫 JS 嘅部分（少用或者有自己狀態）：drawLongBg、DevFx.frame/draw、drawProps/Traces/ObsFx、drawProp、
#    StnFoes.draw/drawBody、drawSpecial、drawDfx、drawUltScene、drawCaps、drawAcc、wOff、fgList/fgCover/fgHold、ambush
#  鏡頭外嘅路人／崗位唔畫（但 draw 入面嘅計時遞減照做，同 JS 一致）
class_name StDraw
extends RefCounted

static var N: Dictionary = {}
static var _charok := {}

static func n(v) -> float:
	if v is float: return v
	if v is int: return float(v)
	return J.num(v)
static func T(y: String, z: String) -> String: return y if DB.lang == "yue" else z
static func js(k: String): return J.G.get(k)
static func rgba(r: float, g: float, b: float, a: float) -> Color: return Color(r / 255.0, g / 255.0, b / 255.0, clampf(a, 0, 1))

static func char_ok(k: String) -> bool:
	if not _charok.has(k): _charok[k] = J.t(J.cl(N.CHAR_H_OK, null, [k]))
	return _charok[k]

static func ghost_draw(c: Ctx, k: String, x: float, y: float, sc: float, o: Dictionary) -> void:
	if OS.has_environment("GB_SD4"): return
	o["shadow"] = false
	Art.draw_char(c, k, x, y, sc, o)

static func txt(c: Ctx, s: String, x: float, y: float, font: String, fill, stroke = null, lw := 3.0, align := "center") -> void:
	c.font = font; c.textAlign = align
	if stroke != null: c.lineWidth = lw; c.strokeStyle = stroke; c.strokeText(s, x, y)
	c.fillStyle = fill; c.fillText(s, x, y)

static func draw(c: Ctx, Tf: Dictionary) -> void:
	N = js("Street")._n
	var b = Tf.box; var bx = n(b.x); var by = n(b.y); var bw = n(b.w); var bh = n(b.h)
	var Wd = n(J.G.get("innerWidth", 390)); var Hd = n(J.G.get("innerHeight", 844))
	var t = Time.get_ticks_usec() / 1000000.0
	var P = func(x, y) -> Vector2: return Vector2(bx + n(x) * bw, by + n(y) * bh)
	c.fillStyle = Color("#0d0a14"); c.fillRect(0, 0, Wd, Hd)
	c.save(); c.beginPath(); c.rect(bx, by, bw, bh); c.clip()
	var shake = n(Tf.get("shake", 0))
	if shake > 0: c.translate((randf() - 0.5) * 10 * shake / 0.28, (randf() - 0.5) * 8 * shake / 0.28)
	J.mc(Tf, "camStep", [])
	var cam = Tf.cam; var z = n(cam.z)
	c.translate(bx + bw / 2, by + bh / 2); c.scale(z, z); c.translate(-(bx + n(cam.x) * bw), -(by + n(cam.y) * bh))
	# 鏡頭範圍（場景座標），留邊
	var v0 = J.mc(Tf, "toScene", [0.0, 0.0]); var v1 = J.mc(Tf, "toScene", [Wd, Hd])
	var view = Rect2(n(v0[0]), n(v0[1]), n(v1[0]) - n(v0[0]), n(v1[1]) - n(v0[1])).grow(bh * 0.12)
	var lay = Tf.lay; var def = Tf.def
	if J.t(lay.get("long")): J.mc(Tf, "drawLongBg", [])
	else:
		var bg = J.gp(js("SPR"), J.str(lay.get("bg")))
		if bg is Texture2D:
			c.save(); c.filter = "brightness(0.92) saturate(0.9)" if not J.t(def.get("hue")) else "brightness(0.62) saturate(0.7) contrast(1.1)"; c.drawImage(bg, bx, by, bw, bh); c.restore()
		c.fillStyle = rgba(20, 40, 40, 0.12) if not J.t(def.get("hue")) else rgba(30, 50, 110, 0.22); c.fillRect(bx, by, bw, bh)
		var vg = c.createRadialGradient(bx + bw / 2, by + bh * 0.5, bw * 0.25, bx + bw / 2, by + bh * 0.5, bh * 0.62); vg.addColorStop(0, "rgba(0,0,0,0)"); vg.addColorStop(1, "rgba(5,0,15,0.78)"); c.fillStyle = vg; c.fillRect(bx, by, bw, bh)
	var sd = Tf.sd; var U = bw / 840.0; Tf["_bub"] = 0
	var DEV = N.DEV; var KIND = N.KIND; var CELL = n(N.CELL); var PX = n(N.PX); var PPL = n(N.PPL)
	var posts: Array = lay.posts; var sposts: Array = sd.posts
	var DevFx = js("DevFx")
	var build_mode = J.t(Tf.get("buildMode"))
	var now_ms = Time.get_ticks_usec() / 1000.0
	var Ln = func(i): return sposts[i] if i < sposts.size() else null
	# 範圍與氛圍
	for i in posts.size():
		var p = Ln.call(i)
		if not (p is Dictionary) or not J.t(p.get("role")) or n(p.get("build", 0)) > 0: continue
		var s = posts[i]; var role = J.str(p.role); var sz = int(n(p.get("sz", 1))) if J.t(p.get("sz")) else 1; var lv = int(n(p.get("lv", 1))) if J.t(p.get("lv")) else 1
		var S0 = DEV[role][str(sz)]; var xy = P.call(s.x, s.y); var x = xy.x; var y = xy.y
		var rr = (0.0 if role == "throw" else (n(S0.area[lv - 1]) * CELL * 0.85 if role == "slow" else (n(S0.eff) if role == "aura" else n(S0.check)) * PX)) + CELL * (0.8 if sz == 2 else 0.5)
		if rr == 0: continue
		if not view.grow(rr * bw).has_point(xy): continue
		if (role == "aura" or role == "slow") and n(p.get("auraOn", 0)) > 0:
			var rg = c.createRadialGradient(x, y, 4, x, y, rr * bw); rg.addColorStop(0, "rgba(110,170,255,0.26)" if role == "slow" else "rgba(170,220,255,0.2)"); rg.addColorStop(1, "rgba(120,160,255,0)")
			c.fillStyle = rg; c.beginPath(); c.ellipse(x, y, rr * bw, rr * bw / 1.5, 0, 0, 7); c.fill()
		var win = p.get("win")
		if J.t(win) and role != "aura":
			var re = (n(S0.eff) * PX + CELL * 0.5) * bw; var k = 1 - n(win.t) / (maxf(1.0, n(S0.dl)) / 60.0)
			c.strokeStyle = rgba(255, 120, 90, 0.7 * (1 - k)); c.lineWidth = 3; c.beginPath(); c.ellipse(x, y, re * (0.6 + 0.4 * k), re * (0.6 + 0.4 * k) / 1.5, 0, 0, 7); c.stroke()
		if build_mode or (n(Tf.get("selPost", -1)) == i and Tf.get("selPost") != null and now_ms - n(Tf.get("selAt", 0)) < 6000):
			var cl = J.str(DevFx.COL[role]); var ra = rr * bw
			c.fillStyle = "rgba(%s,0.1)" % cl; c.strokeStyle = "rgba(%s,%s)" % [cl, 0.75 + 0.2 * sin(t * 4)]; c.lineWidth = 2.5
			c.beginPath(); c.ellipse(x, y, ra, ra / 1.5, 0, 0, 7); c.fill(); c.stroke()
			txt(c, T("射程", "射程"), x, y + ra / 1.5 - 4 * U, "bold %spx sans-serif" % (10 * U), "rgb(%s)" % cl)
		c.strokeStyle = rgba(190, 160, 255, 0.16); c.setLineDash([3, 6]); c.lineWidth = 1.5; c.beginPath(); c.ellipse(x, y, rr * bw, rr * bw / 1.5, 0, t * 0.3, t * 0.3 + 6.283); c.stroke(); c.setLineDash([])
	# 建造格
	var G = lay.get("grid")
	if J.t(G):
		for yy in 10:
			for xx in 6:
				var tt = int(n(J.cl(G.ty, G, [float(xx), float(yy)])))
				if tt == 3 or tt == 4:
					var px = bx + (n(G.x0) + xx * n(G.cw)) * bw; var py = by + (n(G.y0) + yy * n(G.ch)) * bh
					c.strokeStyle = rgba(200, 220, 210, 0.10); c.lineWidth = 1; c.strokeRect(px + 1, py + 1, n(G.cw) * bw - 2, n(G.ch) * bh - 2)
	var move_from = Tf.get("moveFrom")
	var cap = int(n(J.mc(Tf, "lvCap", [])))
	var wal = n(J.gp(N.WAL, "v"))
	for i in posts.size():
		var s = posts[i]; var p = Ln.call(i)
		var xy = P.call(s.x, s.y); var x = xy.x; var y = xy.y
		var q = StFast.rect(s); var x0 = bx + q[0] * bw + 2; var y0 = by + q[1] * bh + 2; var cw = (q[2] - q[0]) * bw - 4; var ch = (q[3] - q[1]) * bh - 4
		var hi = J.t(s.get("h")); var col = [168, 104, 200] if hi else [214, 138, 58]; var cs = minf(cw, ch)
		var onv = view.intersects(Rect2(x0 - 40 * U, y0 - 50 * U, cw + 80 * U, ch + 80 * U))
		var pd = p is Dictionary
		# 只喺 draw 遞減嘅計時：鏡頭外都要減
		if pd and n(p.get("blind", 0)) > 0 and not onv: p["blind"] = n(p.blind) - 1.0 / 30.0
		if not onv: continue
		if move_from != null:
			var A = posts[int(n(move_from))]
			if i != int(n(move_from)) and J.t(A.get("h")) == hi and n(A.get("s", 1) if J.t(A.get("s")) else 1) == n(s.get("s", 1) if J.t(s.get("s")) else 1):
				c.strokeStyle = rgba(255, 233, 160, 0.5 + 0.5 * sin(t * 6)); c.lineWidth = 4; c.strokeRect(x0 - 3, y0 - 3, cw + 6, ch + 6)
		if not pd or not J.t(p.get("role")):
			if not build_mode: continue
			var pu = 0.8 + 0.2 * sin(t * 2.5 + i)
			c.fillStyle = rgba(col[0], col[1], col[2], 0.62 * pu); c.fillRect(x0, y0, cw, ch); c.setLineDash([6, 4]); c.strokeStyle = rgba(255, 240, 210, 0.9); c.lineWidth = 2; c.strokeRect(x0 + 2, y0 + 2, cw - 4, ch - 4); c.setLineDash([])
			txt(c, "+", x, y + cs * 0.08, "900 %spx sans-serif" % (cs * 0.42), Color("#fff6e6"), rgba(60, 30, 10, 0.8), 3)
			var lb = (T("2格・", "2格・") if n(s.get("s", 0)) == 2 else "") + T("建造", "建造")
			txt(c, lb, x, y + cs * 0.38, "bold %spx sans-serif" % (cs * 0.2), Color("#fff6e6"), rgba(60, 30, 10, 0.8), 3)
			continue
		var role = J.str(p.role); var sz = int(n(p.get("sz"))) if J.t(p.get("sz")) else 1; var lv = int(n(p.get("lv"))) if J.t(p.get("lv")) else 1
		var building = n(p.get("build", 0)) > 0
		if not building:
			J.mc(DevFx, "frame", [c, role, x0, y0, cw, ch, t, float(i), J.mc(DevFx, "trigOf", [p, t]), U])
			if (role == "scare" or role == "trap") and J.t(J.mc(Tf, "ambush", [float(i)])):
				txt(c, T("埋伏", "埋伏"), x0 + 2 * U, y0 + 10 * U, "bold %spx sans-serif" % (9 * U), Color("#ffb060"), Color.BLACK, 3, "left")
		elif build_mode:
			c.strokeStyle = rgba(col[0], col[1], col[2], 0.6); c.lineWidth = 2; c.strokeRect(x0, y0, cw, ch)
		else:
			c.fillStyle = rgba(60, 40, 80, 0.35) if hi else rgba(80, 60, 30, 0.35); c.beginPath(); c.ellipse(x, y + ch * 0.32, cw * 0.5, ch * 0.22, 0, 0, 7); c.fill()
		var mx2 = lv >= 5
		txt(c, "MAX" if mx2 else "Lv%d" % lv, x, y0 - 34 * U, "900 %spx sans-serif" % (11 * U), Color("#ffd45a") if mx2 else (Color("#f0c080") if lv >= cap else Color("#ffe9b0")), Color.BLACK, 3)
		var smul = null
		if building:
			var k = 1 - n(p.build) / (3.0 if lv > 1 else 5.0)
			c.fillStyle = rgba(0, 0, 0, 0.6); c.fillRect(x0, y0 - 14 * U, cw, 9 * U); c.fillStyle = Color("#7fd38f"); c.fillRect(x0, y0 - 14 * U, cw * maxf(0, k), 9 * U)
			txt(c, T("招魂中…", "招魂中…"), x0, y0 - 18 * U, "bold %spx sans-serif" % (10 * U), Color.WHITE, null, 3, "left")
		elif role == "puzzle" and p.get("ph") != null:
			var L0 = DEV.puzzle[str(sz)].lv[lv - 1]; smul = J.mc(Tf, "staffMul", [p]); var mx = n(L0[1]) * n(smul.hp)
			var solved = n(p.get("solved", 0)); var kk = 1 - solved / n(L0[4]) if solved > 0 else maxf(0, n(p.ph)) / mx
			c.fillStyle = rgba(0, 0, 0, 0.7); c.fillRect(x0, y0 + ch - 9 * U, cw, 7 * U); c.fillStyle = Color("#6a6a7a") if solved > 0 else Color("#c084ff"); c.fillRect(x0, y0 + ch - 9 * U, cw * kk, 7 * U)
			var tx2 = T("重置 %d秒" % ceili(solved), "重置 %d秒" % ceili(solved)) if solved > 0 else "%d/%d" % [maxi(0, roundi(n(p.ph))), roundi(mx)]
			txt(c, tx2, x, y0 + ch - 12 * U, "bold %spx sans-serif" % (10 * U), Color("#bbbbbb") if solved > 0 else Color("#f0dcff"), Color.BLACK, 3)
		elif role != "aura" and role != "slow" and not J.t(p.get("win")) and p.get("anim") == null:
			var L0 = DEV[role][str(sz)].lv[lv - 1]; smul = J.mc(Tf, "staffMul", [p])
			var k = minf(1.0, n(p.get("cd", 0)) / (n(L0[3]) * n(smul.cd)))
			if k < 1:
				c.fillStyle = rgba(0, 0, 0, 0.6); c.fillRect(x0, y0 + ch - 6 * U, cw, 4 * U); c.fillStyle = Color("#e8c070"); c.fillRect(x0, y0 + ch - 6 * U, cw * k, 4 * U)
		if build_mode:
			c.fillStyle = rgba(20, 20, 24, 0.8); c.fillRect(x0, y0 - 2, 30 * U, 14 * U)
			txt(c, "Lv%d" % lv, x0 + 3 * U, y0 + 9 * U, "bold %spx sans-serif" % (10 * U), Color("#ffe9b0"), null, 3, "left")
		if p.get("staff") != null:
			if smul == null: smul = J.mc(Tf, "staffMul", [p])
			var nm2 = J.t(smul.get("named"))
			c.strokeStyle = rgba(255, 212, 90, 0.6 + 0.3 * sin(t * 4)) if nm2 else rgba(158, 240, 176, 0.7); c.lineWidth = 3; c.strokeRect(x0 - 2, y0 - 2, cw + 4, ch + 4)
			txt(c, T("加持", "加持") + ("★" if nm2 else ""), x0 + cw - 2, y0 + ch - 3, "bold %spx sans-serif" % (9 * U), Color("#ffd45a") if nm2 else Color("#9ef0b0"), null, 3, "right")
		if n(p.get("blind", 0)) > 0:
			p["blind"] = n(p.blind) - 1.0 / 30.0
			c.fillStyle = rgba(0, 0, 0, 0.6); c.fillRect(x0, y0 + ch * 0.35, cw, 14 * U)
			txt(c, T("視線被擋", "視線被擋"), x0 + cw / 2, y0 + ch * 0.35 + 10.5 * U, "bold %spx sans-serif" % (9.5 * U), Color("#ffb0a0"))
		if n(p.get("stun", 0)) > 0:
			c.fillStyle = rgba(255, 250, 200, 0.35); c.fillRect(x0, y0, cw, ch)
			txt(c, T("被照住", "被照住"), x0 + cw / 2, y0 + ch * 0.6, "bold %spx sans-serif" % (9.5 * U), Color("#fff3b0"))
		if wal >= n(J.mc(Tf, "upCost", [p])) and not building:
			c.fillStyle = Color("#e8303a"); c.beginPath(); c.arc(x0 + cw - 4 * U, y0 + 2 * U, 5 * U, 0, 7); c.fill(); c.strokeStyle = Color.WHITE; c.lineWidth = 1.5; c.stroke()
	J.mc(Tf, "drawProps", []); J.mc(Tf, "drawTraces", []); J.mc(Tf, "drawObsFx", [])
	# ---------------- 路人 ----------------
	var NU = n(J.G.get("NPC_UNIT", 69.0)); if NU <= 0: NU = 69.0
	var hh = bh * 0.042; var hhP = hh * PPL
	var ult = Tf.get("ult")
	var walkers: Array = Tf.walkers
	var items: Array = []
	for w in walkers:
		var wt = n(w.get("t", 0)); var gone = w.get("gone")
		if wt < 0: continue
		if not J.t(gone) and J.t(StFast.wseg(w).get("hide")): continue
		if J.str(gone) == "suck" and J.t(ult) and J.t(ult.get("mouth")): continue
		var pos = StFast.wp(Tf, w, null); var x = bx + n(pos[0]) * bw; var y = by + n(pos[1]) * bh
		if J.str(gone) == "suck":
			var e = minf(1.0, n(w.suckT) / 1.0); var e2 = e * e; var a = P.call(w.suckFrom[0], w.suckFrom[1])
			var tgt = Vector2(n(ult.mouthXY[0]), n(ult.mouthXY[1])) if J.t(ult) and J.t(ult.get("mouthXY")) else P.call(w.suckTo[0], w.suckTo[1])
			var r2 = 1 - e2; var an = e * PI * 3; var dx = a.x - tgt.x; var dy = a.y - tgt.y
			x = tgt.x + (dx * cos(an) - dy * sin(an)) * r2; y = tgt.y + (dx * sin(an) + dy * cos(an)) * r2 * 0.8
		if not J.t(gone):
			var of = J.mc(Tf, "wOff", [w, U]); x += n(of[0]); y += n(of[1]); w["_rot"] = of[2]
		else: w["_rot"] = 0.0
		items.append([y, 0, w, x])
	var hd_cache := {}
	for i in posts.size():
		var p = Ln.call(i)
		if not (p is Dictionary) or p.get("g") == null: continue
		var s = posts[i]
		var hd = J.mc(Tf, "fgHold", [s])
		var ky = by + StFast.rect(s)[3] * bh if J.t(p.get("role")) else P.call(s.x, s.y).y
		items.append([maxf(ky, by + n(hd.fy) * bh + 0.5 if J.t(hd) else 0.0), 1, s, i])
	if lay.get("obs") is Array:
		for o in lay.obs:
			if J.t(o.get("prop")) and J.str(o.get("t")) != "p" and J.str(o.get("t")) != "e": items.append([by + n(o.y1) * bh, 2, o])
	var fgl = J.mc(Tf, "fgList", [])
	if fgl is Array:
		for F in fgl: items.append([by + n(F.fy) * bh, 3, F])
	items.sort_custom(func(a2, z2): return a2[0] < z2[0] or (a2[0] == z2[0] and a2[1] < z2[1]))
	var hidW = []
	for it in items:
		if it[1] == 0 and not J.t(it[2].get("gone")) and view.has_point(Vector2(it[3], it[0])):
			if J.t(J.mc(Tf, "fgCover", [(it[3] - bx) / bw, (it[0] - by) / bh])): it.append(1); hidW.append(it)
	var ctxo = {"c": c, "Tf": Tf, "U": U, "t": t, "hh": hhP, "NU": NU, "bx": bx, "bw": bw, "view": view}
	for it in items:
		match it[1]:
			0: if not OS.has_environment("GB_SD1"): draw_walker(ctxo, it[0], it[2], it[3], "body" if it.size() > 4 else "")
			1: if not OS.has_environment("GB_SD2") and view.grow(bw * 0.15).has_point(P.call(it[2].x, it[2].y)) or _post_busy(Ln.call(it[3])): draw_post(c, Tf, it[2], it[3], hh, U, t, P, bx, by, bw, bh)
			2: if view.intersects(Rect2(bx + n(it[2].x0) * bw, by + n(it[2].y0) * bh, (n(it[2].x1) - n(it[2].x0)) * bw + 1, (n(it[2].y1) - n(it[2].y0)) * bh + 1).grow(40)): J.mc(Tf, "drawProp", [it[2]])
			3: _draw_fg(c, it[2], bx, by, bw, view)
	for it in hidW: if not OS.has_environment("GB_SD1"): draw_walker(ctxo, it[0], it[2], it[3], "ghost")
	var SF = js("StnFoes")
	if SF != null: J.mc(SF, "draw", [c, Tf])
	for w in walkers:
		var bm = w.get("beam")
		if not J.t(bm) or J.t(w.get("gone")): continue
		if int(n(bm.i)) >= posts.size(): continue
		var sp = posts[int(n(bm.i))]; var a = StFast.wp(Tf, w, null); var A2 = P.call(a[0], a[1]); var B2 = P.call(sp.x, sp.y)
		var g2 = c.createLinearGradient(A2.x, A2.y - hhP * 0.5 / PPL * PPL, B2.x, B2.y); g2.addColorStop(0, "rgba(255,250,200,0.75)"); g2.addColorStop(1, "rgba(255,250,200,0.1)")
		c.fillStyle = g2; c.beginPath(); c.moveTo(A2.x, A2.y - hh * 0.5); c.lineTo(B2.x - 22 * U, B2.y - 14 * U); c.lineTo(B2.x + 22 * U, B2.y + 14 * U); c.closePath(); c.fill()
	J.mc(Tf, "drawSpecial", [])
	J.mc(Tf, "drawDfx", [U, hhP, t])
	# 鬼被彈飛
	var B = Tf.get("blown")
	if J.t(B):
		B["t"] = n(B.t) + 1.0 / 30.0; var bt = n(B.t); var xy = P.call(B.x, B.y)
		if J.t(B.get("k")): ghost_draw(c, J.str(B.k), xy.x + bt * 120 * U, xy.y - bt * 160 * U, hh / 60.0 * (1 - bt * 0.5), {"t": t, "pose": "startle", "alpha": maxf(0, 1 - bt), "rot": bt * 6, "flip": false})
		if bt > 1: Tf["blown"] = null
	# 拋物
	for s2 in Tf.get("shots", []):
		var k = n(s2.t)
		if k < 0: continue
		var A = P.call(s2.from[0], s2.from[1]); var Bp = P.call(s2.to[0], s2.to[1])
		c.save(); c.translate(A.x + (Bp.x - A.x) * k, A.y + (Bp.y - A.y) * k - sin(k * 3.14) * (90 if J.t(s2.get("hi")) else 50) * U); c.rotate(k * 10)
		c.fillStyle = Color("#efe5cc"); c.strokeStyle = Color("#2e4a86"); c.lineWidth = 1.5; c.beginPath(); c.ellipse(0, 0, 9 * U, 5 * U, 0, 0, PI); c.closePath(); c.fill(); c.stroke()
		c.beginPath(); c.ellipse(0, 0, 9 * U, 2.4 * U, 0, 0, 7); c.fillStyle = Color("#d8ccb0"); c.fill(); c.stroke(); c.restore()
		c.strokeStyle = rgba(242, 234, 210, 0.25); c.lineWidth = 2; c.beginPath()
		for j in 9:
			var kk = k * j / 8.0; var px = A.x + (Bp.x - A.x) * kk; var py = A.y + (Bp.y - A.y) * kk - sin(kk * 3.14) * 50 * U
			if j: c.lineTo(px, py)
			else: c.moveTo(px, py)
		c.stroke()
	# 粒子
	var cr = Tf.get("_natCoin"); if not (cr is Dictionary): cr = {"left": Wd - 60, "top": 20, "width": 40, "height": 20}
	var ccx = n(cr.left) + n(cr.width) / 2; var ccy = n(cr.top) + n(cr.height) / 2
	var parts: Array = Tf.get("parts", [])
	for q in parts:
		var kind = J.str(q.get("kind"))
		if kind == "coin": continue
		var pp = P.call(q.x, q.y); var px = pp.x; var py = pp.y; var al = minf(1.0, n(q.life))
		if not view.has_point(pp): continue
		match kind:
			"mist":
				var rg = c.createRadialGradient(px, py, 1, px, py, 18 * U); rg.addColorStop(0, "rgba(200,225,255,%s)" % (0.25 * al)); rg.addColorStop(1, "rgba(200,225,255,0)"); c.fillStyle = rg; c.beginPath(); c.arc(px, py, 18 * U, 0, 7); c.fill()
			"smoke":
				var rg = c.createRadialGradient(px, py, 1, px, py, 16 * U); rg.addColorStop(0, "rgba(235,235,235,%s)" % (0.55 * al)); rg.addColorStop(1, "rgba(235,235,235,0)"); c.fillStyle = rg; c.beginPath(); c.arc(px, py, 16 * U, 0, 7); c.fill()
			"shard":
				c.save(); c.translate(px, py); c.rotate(n(q.life) * 12 + n(q.x) * 90)
				c.fillStyle = rgba(60, 90, 160, al) if fmod(n(q.x) * 1e4, 3) < 1 else rgba(240, 232, 212, al)
				c.beginPath(); c.moveTo(0, -4 * U); c.lineTo(4 * U, 3 * U); c.lineTo(-3 * U, 2 * U); c.closePath(); c.fill(); c.restore()
			"soul":
				c.fillStyle = rgba(190, 170, 255, al); c.beginPath(); c.arc(px, py, 3 * U, 0, 7); c.fill()
			_:
				c.fillStyle = rgba(242, 234, 210, al); c.fillRect(px - 3 * U, py - 2 * U, 6 * U, 4 * U)
	c.textAlign = "center"
	for f in Tf.get("fx", []):
		var pp = P.call(f.x, f.y); var ft = n(f.t)
		c.globalAlpha = maxf(0, 1 - ft / 1.2); c.font = "bold %spx sans-serif" % (15 * U); c.lineWidth = 4; c.strokeStyle = Color("#1a0f08"); c.strokeText(J.str(f.s), pp.x, pp.y - ft * 30); c.fillStyle = f.col; c.fillText(J.str(f.s), pp.x, pp.y - ft * 30)
	if J.t(Tf.get("ult")): J.mc(Tf, "drawUltScene", [])
	J.mc(Tf, "drawCaps", [])
	c.globalAlpha = 1; c.restore()
	var tint = Tf.get("tint")
	if J.t(tint): c.fillStyle = tint.col; c.globalAlpha = minf(1.0, n(tint.t) / 0.4); c.fillRect(0, 0, Wd, Hd); c.globalAlpha = 1
	for q in parts:
		if J.str(q.get("kind")) != "coin" or n(q.get("k", 0)) < 0: continue
		var sc = J.mc(Tf, "toScreen", [bx + n(q.x) * bw, by + n(q.y) * bh]); var sx = n(sc[0]); var sy = n(sc[1]); var qk = n(q.k); var e = qk * qk
		var px = sx + (ccx - sx) * e; var py = sy + (ccy - sy) * e - sin(qk * PI) * 60 * U
		c.fillStyle = Color("#ffd45a"); c.strokeStyle = Color("#7a4a10"); c.lineWidth = 1.5; c.beginPath(); c.arc(px, py, 5 * U, 0, 7); c.fill(); c.stroke()
	var fl = n(Tf.get("flash", 0))
	if fl > 0: c.fillStyle = Color(1, 1, 1, fl / 0.18 * 0.55); c.fillRect(0, 0, Wd, Hd)

static func _post_busy(p) -> bool:
	return p is Dictionary and (J.t(p.get("fx")) or n(p.get("hurt", 0)) > 0)

static func _draw_fg(c: Ctx, F: Dictionary, bx: float, by: float, bw: float, view: Rect2) -> void:
	var it = F.it; var k = bw / n(J.G.get("STN_FG_W", 768))
	var r = Rect2(bx + n(F.r) * bw + n(it.x) * k, by + n(it.y) * k, n(it.w) * k, n(it.h) * k)
	if not view.intersects(r): return
	var im = J.cl(J.G.get("STN_FG_img"), null, [it])
	var tex = im if im is Texture2D else (im.js_tex() if im is Object and im.has_method("js_tex") else null)
	if tex == null: return
	c.save(); c.filter = "brightness(0.92) saturate(0.9)"; c.drawImage(tex, r.position.x, r.position.y, r.size.x, r.size.y); c.restore()

# ---------------- 一個路人（drawW）----------------
static func draw_walker(o: Dictionary, y0: float, w: Dictionary, x0: float, mode: String) -> void:
	var c: Ctx = o.c; var Tf = o.Tf; var U: float = o.U; var t: float = o.t; var hh: float = o.hh
	var gone = J.str(w.get("gone")) if J.t(w.get("gone")) else ""
	var run = gone == "run"; var suck = gone == "suck"
	var react = n(w.get("react", 0)) / 0.6 if n(w.get("react", 0)) > 0 else 0.0
	var gh2 = mode == "ghost"
	# 鏡頭外：只做 draw 入面嘅狀態更新（同 JS 一致），唔畫
	var onv = (o.view as Rect2).grow(hh).has_point(Vector2(x0, y0))
	if not gh2 and n(w.get("hair", 0)) > 0: w["hair"] = n(w.hair) - 1.0 / 30.0
	if run and w.get("fall") == null: w["fall"] = randf() < 0.35
	if not onv:
		if mode != "body":
			if react <= 0: w["weak2"] = null
			if n(w.get("pulled", 0)) > 0: w["pulled"] = n(w.pulled) - 1.0 / 30.0
		return
	var x = x0; var y = y0; var a = 1.0
	if run: a = 1.0 if n(w.runT) < 1.5 else maxf(0, 1 - (n(w.runT) - 1.5) / 0.5)
	var ssc = maxf(0.05, 1 - n(w.suckT)) if suck else 1.0
	var lift = sin(react * PI) * hh * 0.35; var spin = n(w.get("spin", 0)) > 0
	var right: bool
	if run:
		var rp = w.get("runPath")
		right = ((n(rp[1][0]) - n(rp[0][0])) if rp is Array and rp.size() > 1 else 0.0) < 0
	else:
		right = (n(StFast.wp(Tf, w, 0.01)[0]) - n(StFast.wp(Tf, w, null)[0])) >= 0
	c.save(); c.globalAlpha = a * (0.34 if gh2 else 1.0)
	if not gh2: c.fillStyle = rgba(0, 0, 0, 0.4); c.beginPath(); c.ellipse(x, y, hh * 0.24, hh * 0.06, 0, 0, 7); c.fill()
	if not gh2 and n(w.get("frost", 0)) > 0:
		c.strokeStyle = rgba(140, 200, 255, 0.9); c.lineWidth = 2
		for j in 3: c.beginPath(); c.ellipse(x, y - hh * (0.2 + j * 0.25), hh * 0.3, hh * 0.07, 0, t * 2 + j, t * 2 + j + 4.5); c.stroke()
	if spin:
		for j in 4:
			var ang = t * 3 + j * 1.57; var rx = x + cos(ang) * hh * 0.7; var ry = y - hh * 0.4 + sin(ang) * hh * 0.25
			c.fillStyle = rgba(120, 80, 170, 0.35); c.fillRect(rx - hh * 0.12, ry - hh * 0.45, hh * 0.24, hh * 0.7)
	c.translate(x + ((randf() - 0.5) * 3 if react else 0.0), y - lift)
	if suck: c.scale(ssc, ssc); c.rotate(n(w.suckT) * 8)
	if spin: c.scale(1.0 if cos(t * 9) >= 0 else -1.0, 1)
	var rot = n(w.get("_rot", 0))
	if rot != 0: c.translate(0, -hh * 0.4); c.rotate(rot); c.translate(0, hh * 0.4)
	var falling = run and J.t(w.get("fall")) and n(w.runT) < 0.45
	var act = w.get("act")
	var pose: String
	if suck: pose = "startle"
	elif falling: pose = "cower"
	elif run: pose = "run"
	elif react > 0:
		if not J.t(w.get("weak2")): w["weak2"] = "tremble" if randf() < 0.4 else "startle"
		pose = J.str(w.weak2)
	elif J.t(act): pose = J.str(act.pose)
	elif J.t(w.get("lift")) or J.t(w.get("fly")): pose = "startle"
	elif J.t(w.get("chase")): pose = "run"
	elif n(w.get("stay", 0)) > 0: pose = "startle"
	elif n(w.get("block", 0)) > 0: pose = "cower"
	elif n(w.get("back", 0)) > 0: pose = "run"
	elif n(w.get("fear", 0)) > 0: pose = "tremble"
	else: pose = "move"
	var face = "t" if run or react > 0 else ("n" if gone == "out" else null)
	if J.t(w.get("tint")): c.filter = J.str(w.tint)
	if gh2: c.filter = "brightness(0) invert(1) sepia(1) hue-rotate(150deg) saturate(4)"
	var flipv = right if (run or n(w.get("back", 0)) > 0 or n(w.get("rev", 0)) > 0) else not right
	var ok = false
	var SF = js("StnFoes")
	if J.t(w.get("foe")) and SF != null: ok = J.t(J.mc(SF, "drawBody", [c, w, hh, t, {"flip": flipv}]))
	var spr = J.str(w.get("spr"))
	if not ok and char_ok(spr):
		if not J.t(w.get("seed")): w["seed"] = randf() * 9
		var oo = {"t": t + n(w.seed), "pose": pose, "pt": 1 - react if react else 0.0, "walk": not react and not (n(w.get("stay", 0)) > 0) and not (n(w.get("block", 0)) > 0) and not (J.t(act) and J.t(act.get("hold"))), "flip": flipv, "shadow": false}
		if face != null: oo["face"] = face
		Art.draw_char(c, spr, 0, 0, hh / o.NU, oo); ok = true
	if not ok:
		var im = Spr.get_tex(spr)
		if im == null:
			var js_im = J.gp(js("SPR"), spr)
			if js_im is Texture2D: im = js_im
		if im != null: draw_sprite(c, Tf, im, w, hh * (0.92 if spr.begins_with("pb_") or spr.begins_with("foe_") else 1.06), pose, t, flipv, react, U)
	if OS.has_environment("GB_WDBG"): print("WDRAW ", J.str(w.get("spr")), " ok=", ok, " pose=", pose, " hh=", hh, " x=", x, " y=", y, " a=", a)
	c.filter = "none"; c.globalAlpha = a
	J.mc(Tf, "drawAcc", [w, hh, t, U])
	if J.t(w.get("sqAcc")): J.mc(Tf, "drawSqAcc", [w, hh, t])
	c.restore()
	if mode == "body": return
	c.save(); c.globalAlpha = a
	var crew = w.get("crew")
	if J.t(crew):
		txt(c, J.str(w.n), x, y - hh - 16 * U, "bold %spx sans-serif" % (11 * U), crew.tag, Color.BLACK, 3)
		var af = w.get("atkFx")
		if J.t(af):
			var P0 = Tf.lay.posts[int(n(af.i))]; var pp = Vector2(o.bx + n(P0.x) * o.bw, n(Tf.box.y) + n(P0.y) * n(Tf.box.h)); var k = 1 - n(af.t) / 0.6
			if J.str(crew.n) == "天師":
				for j in 3:
					var rr = fmod(k * 1.2 + j * 0.3, 1.0)
					c.strokeStyle = rgba(255, 210, 90, 1 - rr); c.lineWidth = 3; c.beginPath(); c.arc(x + hh * 0.25, y - hh * 0.8, rr * 40 * U, -1, 1); c.stroke()
				c.fillStyle = Color("#ffd45a"); c.font = "bold %spx sans-serif" % (12 * U); c.fillText("叮鈴！", x + 18 * U, y - hh * 1.05)
			else:
				var g2 = c.createLinearGradient(x, y - hh * 0.6, pp.x, pp.y); g2.addColorStop(0, "rgba(255,250,200,0.7)" if J.str(crew.n) == "保安" else "rgba(255,255,255,0.85)"); g2.addColorStop(1, "rgba(255,255,220,0)")
				c.fillStyle = g2; c.beginPath(); c.moveTo(x, y - hh * 0.6); c.lineTo(pp.x - 18 * U, pp.y - 10 * U); c.lineTo(pp.x + 18 * U, pp.y + 10 * U); c.closePath(); c.fill()
				if J.str(crew.n) != "保安" and k < 0.3:
					c.fillStyle = rgba(255, 255, 255, 0.7); c.beginPath(); c.arc(x + 10 * U, y - hh * 0.7, 12 * U, 0, 7); c.fill()
					c.fillStyle = Color("#ff4d6a"); c.font = "bold %spx sans-serif" % (10 * U); c.fillText("● LIVE", x, y - hh * 1.15)
	if gone == "":
		var bw2 = hh * 0.4
		c.fillStyle = rgba(0, 0, 0, 0.65); c.fillRect(x - bw2 / 2, y - hh - 7 * U, bw2, 4 * U)
		c.fillStyle = Color("#ff8a5a") if J.t(crew) else Color("#6ec3ff"); c.fillRect(x - bw2 / 2, y - hh - 7 * U, bw2 * maxf(0, n(w.hp) / n(w.max)), 4 * U)
	if react <= 0: w["weak2"] = null
	if n(w.get("pulled", 0)) > 0:
		w["pulled"] = n(w.pulled) - 1.0 / 30.0
		c.strokeStyle = rgba(192, 132, 255, n(w.pulled)); c.lineWidth = 3
		for j in 2: c.beginPath(); c.arc(x, y - hh * 0.5, (14 + j * 9) * U, t * 5 + j, t * 5 + j + 4.5); c.stroke()
	if (react > 0 or n(w.get("stay", 0)) > 0) and not J.t(crew):
		txt(c, "!", x + hh * 0.32, y - hh - 14 * U - lift, "900 %spx sans-serif" % (18 * U), Color("#ffe14a"), Color("#2a1006"), 4)
	var say = w.get("say")
	if J.t(say):
		Tf["_bub"] = n(Tf.get("_bub", 0)) + 1
		if n(Tf._bub) <= 3:
			var s2 = J.str(say.s); c.font = "bold %spx sans-serif" % (12 * U)
			var tw = n(c.measureText(s2).width) + 12 * U; var bx2 = maxf(o.bx + 4, minf(o.bx + o.bw - tw - 4, x - tw / 2)); var by2 = y - hh - 40 * U - lift
			c.fillStyle = rgba(255, 250, 235, 0.95); c.strokeStyle = Color("#3a2212"); c.lineWidth = 2; c.beginPath(); c.roundRect(bx2, by2, tw, 20 * U, 8 * U); c.fill(); c.stroke()
			c.fillStyle = Color("#3a2212"); c.textAlign = "left"; c.textBaseline = "middle"; c.fillText(s2, bx2 + 6 * U, by2 + 10 * U); c.textBaseline = "alphabetic"
	c.restore()

static func draw_sprite(c: Ctx, Tf, im: Texture2D, w: Dictionary, H: float, pose: String, t: float, flip: bool, react: float, U: float) -> void:
	var iw = float(im.get_width()); var ih = float(im.get_height())
	var ww = H * iw / ih; var ph = t * (n(w.get("spd", 0)) / n(N.PX) / 45.0) + n(w.get("seed", 0))
	var dy = 0.0; var rot = 0.0; var sx = 1.0; var sy = 1.0; var dx = 0.0
	match pose:
		"move": dy = -absf(sin(ph * 3.2)) * 3.2 * U; rot = sin(ph * 3.2) * 0.045; sy = 1 - absf(sin(ph * 3.2)) * 0.02
		"run": dy = -absf(sin(ph * 5.5)) * 5 * U; rot = 0.16 + sin(ph * 5.5) * 0.06
		"startle": var k = react if react > 0 else 0.5; dy = -sin(k * PI) * H * 0.14; sx = 1.04; sy = 1.06; dx = (randf() - 0.5) * 3
		"cower": sy = 0.82; sx = 1.08; rot = 0.1
		"tremble": dx = (randf() - 0.5) * 4 * U; sy = 0.96
		"idle": sy = 1 + sin(t * 2 + n(w.get("seed", 0))) * 0.012
	if J.str(w.get("tr")) == "drunk" and pose == "move": rot += sin(t * 1.3 + n(w.get("seed", 0))) * 0.08
	c.save(); c.translate(dx, dy); c.rotate(-rot if flip else rot); c.scale((-1.0 if flip else 1.0) * sx, sy)
	var spr = J.str(w.spr); var NOLEG = J.G.get("STN_AB_NOLEG")
	if (pose == "move" or pose == "run") and (spr.begins_with("pb_") or spr.begins_with("foe_")) and not (NOLEG is Dictionary and J.t(NOLEG.get(spr))):
		var lt = 0.76; var f2 = 5.5 if pose == "run" else 3.2; var sw = sin(ph * f2); var A = (0.08 if pose == "run" else 0.055) * H
		for pr in [[1, -1], [0, 1]]:
			var lf = maxf(0, pr[1] * sw) * A
			c.drawImage(im, pr[0] * iw / 2, ih * lt, iw / 2, ih * (1 - lt), -ww / 2 + pr[0] * ww / 2 + pr[1] * sw * ww * 0.035, -H + H * lt - lf, ww / 2 + 0.5, H * (1 - lt))
		c.drawImage(im, 0, 0, iw, ih * lt + 1, -ww / 2, -H, ww, H * lt + H / ih)
	else: c.drawImage(im, -ww / 2, -H, ww, H)
	c.restore()
	if J.str(w.get("tr")) == "torch" and not J.t(w.get("beam")) and not J.t(w.get("gone")):
		var bxx = (-1.0 if flip else 1.0) * ww * 0.3; var sgn = -1.0 if flip else 1.0
		c.fillStyle = rgba(255, 240, 170, 0.16); c.beginPath(); c.moveTo(bxx, -H * 0.45); c.lineTo(bxx + sgn * H * 0.7, -H * 0.6); c.lineTo(bxx + sgn * H * 0.7, -H * 0.2); c.closePath(); c.fill()

# ---------------- 崗位鬼（drawPost）----------------
static func draw_post(c: Ctx, Tf: Dictionary, s: Dictionary, i: int, hh: float, U: float, t: float, P: Callable, bx: float, by: float, bw: float, bh: float) -> void:
	var p = Tf.sd.posts[i]
	if not (p is Dictionary) or p.get("g") == null: return
	var g = J.cl(N.ghost, null, [p.g])
	if not J.t(g): return
	if OS.has_environment("GB_SD5"): return
	var role = J.str(p.get("role")) if J.t(p.get("role")) else ""
	var gk = J.str(J.mc(Tf, "devK", [p])) if role != "" else J.str(g.k)
	var DEV = N.DEV; var KIND = N.KIND
	var type = J.str(DEV[role].kind) if role != "" else J.str(J.cl(N.gType, null, [g]))
	var K = KIND[type]; var xy = P.call(s.x, s.y); var x = xy.x; var y = xy.y
	var sz = int(n(p.sz)) if J.t(p.get("sz")) else 1
	var base = hh * 1.3 / 60.0 * 1.45 * (1.3 if sz == 2 else 1.0); var fx = p.get("fx")
	if n(p.get("build", 0)) > 0: return
	var dim = Spr.get_tex("dv_%s_%d" % [role, sz]) if role != "" else null
	var dimOk = dim != null
	if dimOk:
		var q = StFast.rect(s); var dw = (q[2] - q[0]) * bw * 1.25; var dh = dw * dim.get_height() / dim.get_width(); var dby = by + q[3] * bh + 4 * U
		var sh = 1 + sin(t * 40) * 0.03 if p.get("anim") != null or J.t(p.get("win")) else 1.0
		c.save(); c.translate(x, dby); c.scale(sh, sh)
		var DevFx = js("DevFx")
		var em = J.mc(DevFx, "emerge", [p, t])
		var kk = J.str(J.mc(Tf, "devK", [p])) if p.get("staff") != null and J.t(J.cl(N.ghost, null, [p.staff])) else null
		if not OS.has_environment("GB_SD3"): J.mc(DevFx, "draw", [c, J.gp(js("SPR"), "dv_%s_%d" % [role, sz]), role, float(sz), -dw / 2, -dh, dw, dh, t, float(i), {"p": em, "k": kk, "sc": base * 0.95}])
		c.restore()
	if OS.has_environment("GB_SD6"): return
	var tx = P.call(fx.tx, fx.ty).x if J.t(fx) else x
	var flip = tx < x if J.t(fx) else sin(t * 0.4 + i) < 0
	var gx = x; var gy = y + 10 * U; var sc = base; var al = 0.62 + 0.14 * sin(t * 1.6 + i); var pose = "idle"; var pt = 0.0; var rot = sin(t * 1.3 + i) * 0.04
	if J.t(s.get("h")): gy += sin(t * 1.5 + i) * 3 * U
	else: sc *= 1 + sin(t * 2 + i) * 0.02
	if n(p.get("hurt", 0)) > 0: p["hurt"] = n(p.hurt) - 1.0 / 30.0; gx += (randf() - 0.5) * 6 * U
	if not dimOk and (role == "aura" or role == "slow") and n(p.get("auraOn", 0)) > 0:
		al = 0.75; pose = "cast"; pt = fmod(t * 0.8, 1.0); gx += sin(t * 2.2 + i) * 8 * U
		for j in range(1, 4): ghost_draw(c, gk, gx - sin(t * 2.2 + i - j * 0.25) * 8 * U * j * 0.6, gy, sc, {"t": t, "pose": pose, "pt": pt, "alpha": 0.12 / j, "flip": flip})
	if J.t(fx):
		var ft = n(fx.t); var k = minf(1.0, ft / 0.9); var hit = k / 0.25 if k < 0.25 else 1 - (k - 0.25) / 0.75
		al = 0.95 * (1 - maxf(0, k - 0.8) * 4); pose = "windup" if k < 0.25 else "strike"; pt = k / 0.25 if k < 0.25 else minf(1.0, (k - 0.25) * 2)
		var tp = P.call(fx.tx, fx.ty); var dx = tx - x; var dy = tp.y - y
		var ftype = J.str(fx.get("type")); var fv = J.t(fx.get("v"))
		var clipped = false
		if J.t(fx.get("aura")):
			if fv: gx += dx * hit * 0.7; gy += dy * hit * 0.7; rot = sin(t * 9) * 0.2
			else: sc *= 1 + hit * 0.35; rot = hit * 0.6 * sin(k * 12)
			pose = "cast"
		elif ftype == "sound" and fv: gy -= (1 - minf(1.0, k * 3)) * 70 * U; rot = (1 - minf(1.0, k * 3)) * 3; sc *= 1 + hit * 0.2; c.save(); clipped = true
		elif ftype == "sound": gy += (1 - minf(1.0, k * 3)) * 26 * U; sc *= 1 + hit * 0.25; c.save(); c.beginPath(); c.rect(x - 80 * U, y - 160 * U, 160 * U, 160 * U + 12 * U); c.clip(); clipped = true
		elif (ftype == "face" or ftype == "shadow") and fv: gx = tx + (1 if flip else -1) * 18 * U; gy = tp.y + 4 * U; sc *= 0.4 + hit * 1.1; al *= minf(1.0, k * 5); rot = sin(t * 30) * 0.05 * hit
		elif ftype == "face" or ftype == "shadow": gx += dx * hit * 0.55; gy += dy * hit * 0.55; sc *= 1 + hit * 0.9; rot = (-1 if flip else 1) * hit * 0.15
		elif ftype == "phone" and fv:
			pose = "cast"; var sp = k * 2 if k < 0.5 else 1.0; gx = x + dx * sp; gy = y + 10 * U + dy * sp; rot = sp * 6.28; al *= 0.4 + 0.6 * absf(cos(k * 9))
		elif ftype == "phone": pose = "cast"
		elif ftype == "paper": pose = "windup" if k < 0.3 else "cast"
		if gk == "toyol":
			var e3 = sin(k * PI); gx = x + dx * e3; gy = y + 10 * U + dy * e3 - (absf(sin(k * PI * 4)) * 20 * U if fv else 0.0); pose = "move"
		var hang = Spr.get_tex("tianhua_hang") if gk == "tianhua" else null
		if dimOk: pass
		elif hang != null:
			var H2 = hh * 2.2; var W2 = H2 * hang.get_width() / hang.get_height(); var drop = sin(minf(1.0, k * 2.5) * PI / 2) * (1 - maxf(0, k - 0.8) * 5)
			c.save(); c.globalAlpha = maxf(0, al); c.translate(tx, y - H2 * 0.4 + drop * (tp.y - y + H2 * 0.15) - H2 * 0.6); c.rotate(sin(t * 7) * 0.08); c.drawImage(hang, -W2 / 2, 0, W2, H2); c.restore()
		else: ghost_draw(c, gk, gx, gy, sc, {"t": t, "pose": pose, "pt": pt, "atk": hit > 0.4, "alpha": maxf(0, al), "flip": flip, "rot": rot})
		if clipped: c.restore()
		if ftype == "sound" and k > 0.2 and k < 0.8:
			var rr = (k - 0.2) / 0.6; c.strokeStyle = rgba(255, 220, 120, 1 - rr); c.lineWidth = 4; c.beginPath(); c.ellipse(x, y + 6 * U, n(K.r) * bw * rr, n(K.r) * bw * rr * 0.45, 0, 0, 7); c.stroke()
		if ftype == "phone" and k < 0.9:
			c.strokeStyle = rgba(160, 110, 220, 0.7 - k * 0.6); c.lineWidth = 3
			for j in 5:
				var ang = j * 1.256 + t
				c.beginPath(); c.moveTo(tx + cos(ang) * 22 * U, tp.y - 30 * U + sin(ang) * 10 * U); c.lineTo(tx + cos(ang) * 30 * U, tp.y - 60 * U + sin(ang) * 12 * U); c.stroke()
		var LINE = {"pontianak": "嘻——嘻——", "eguiking": "開飯喇！", "toyol": "嘻嘻，錢錢～", "tianhua": "……", "laojiang": "嗚——", "xiaozhi": "沙沙沙…"}.get(gk, "")
		if LINE != "" and k > 0.15 and k < 0.85:
			var lx = maxf(bx + 50 * U, minf(bx + bw - 50 * U, gx))
			txt(c, LINE, lx, gy - hh * 1.5, "900 %spx serif" % (13 * U), rgba(255, 215, 235, 0.95), Color("#1a0010"), 3)
	elif not dimOk:
		ghost_draw(c, gk, gx, gy, sc, {"t": t, "pose": pose, "pt": pt, "alpha": al, "flip": flip, "rot": rot})
	var hpK = 1.0 if role != "" else maxf(0, n(p.get("hp", 0))) / maxf(1e-6, n(p.get("max", 1)))
	if hpK < 0.999:
		c.fillStyle = rgba(0, 0, 0, 0.6); c.fillRect(x - 16 * U, y + 14 * U, 32 * U, 4 * U); c.fillStyle = Color("#a8f0a8") if hpK > 0.4 else Color("#ff7a6a"); c.fillRect(x - 16 * U, y + 14 * U, 32 * U * hpK, 4 * U)
