# 回陽間：每幀都畫、但 JS 解釋起嚟好貴嘅細節，逐筆照搬做原生（畫法、數值同 JS 一樣）
class_name ScFast
extends RefCounted

# rooms.js OFFMAP.drawBack：鏡頭拉遠時上面嘅大樓剖面（夜空、遠處大廈燈、上一層樓板）
static func sky(ctx: Ctx, Sc: Dictionary, y0: float, bs: float) -> void:
	var W = J.num(Sc.W); var slab = maxf(10.0, bs * 34)
	var g = ctx.createLinearGradient(0, 0, 0, y0 - slab); g.addColorStop(0, "#0b0a1c"); g.addColorStop(1, "#1d1838"); ctx.fillStyle = g; ctx.fillRect(0, 0, W, y0 - slab + 1)
	ctx.save(); var px0 = J.num(Sc.get("camX", 0)) * 140
	var lit = Color(1, 214 / 255.0, 140 / 255.0, 0.35); var bld = Color(30 / 255.0, 26 / 255.0, 58 / 255.0, 0.9)
	for i in 26:
		var m = W + 120; var bx = fposmod(i * 97 - px0, m) - 60; var bh = (0.35 + float((i * 53) % 10) / 16.0) * (y0 - slab); var bw = 26 + (i * 31) % 30
		ctx.fillStyle = bld; ctx.fillRect(bx, y0 - slab - bh, bw, bh); ctx.fillStyle = lit
		for w in 6:
			if (i * 7 + w * 3) % 5 == 0: ctx.fillRect(bx + 4 + (w % 3) * 7, y0 - slab - bh + 6 + floor(w / 3.0) * 10, 3, 4)
	ctx.restore()
	var sg = ctx.createLinearGradient(0, y0 - slab, 0, y0); sg.addColorStop(0, "#5a5068"); sg.addColorStop(0.25, "#3c3448"); sg.addColorStop(1, "#2a2434"); ctx.fillStyle = sg; ctx.fillRect(0, y0 - slab, W, slab)
	ctx.fillStyle = Color(1, 1, 1, 0.12); ctx.fillRect(0, y0 - slab, W, 1.5); ctx.fillStyle = Color(0, 0, 0, 0.45); ctx.fillRect(0, y0 - 2, W, 2)

# scare.js drawBubble：對白框（彈出、換行、避開其他框），逐筆照搬
static func bubble(ctx: Ctx, Sc: Dictionary, text: String, x: float, y: float, ghost: bool, age) -> void:
	var pk = 1.0 if age == null else minf(1.0, J.num(age) / 0.22)
	var ps = 1.0 if pk >= 1 else 1 + 2.70158 * pow(pk - 1, 3) + 1.70158 * pow(pk - 1, 2)
	ctx.save(); ctx.translate(x, y); ctx.scale(maxf(0.05, ps), maxf(0.05, ps)); ctx.translate(-x, -y)
	if pk < 1: ctx.globalAlpha *= minf(1.0, pk * 3)
	ctx.font = "600 13px sans-serif"; var maxW = 200.0
	var lines: Array = []; var cur = ""
	for i in text.length():
		var ch = text[i]
		if J.num(ctx.measureText(cur + ch).width) > maxW: lines.append(cur); cur = ch
		else: cur += ch
	lines.append(cur)
	if lines.size() > 1 and String(lines[-1]).length() <= 2:
		var pv: String = lines[-2]; var k = maxi(0, pv.length() - 2)
		lines[-1] = pv.substr(k) + lines[-1]; lines[-2] = pv.substr(0, k)
	var mw = 0.0
	for l in lines: mw = maxf(mw, J.num(ctx.measureText(l).width))
	var w = minf(maxW, mw) + 16; var h = lines.size() * 17 + 10
	var bx = maxf(6.0, minf(J.num(Sc.W) - w - 6, x - w / 2)); var by = y - h - 10; var by0 = by
	if not (Sc.get("_bubR") is Array): Sc["_bubR"] = []
	var R: Array = Sc._bubR
	for k in 6:
		var o = null
		for r in R:
			if bx < J.num(r[0]) + J.num(r[2]) + 3 and bx + w + 3 > J.num(r[0]) and by < J.num(r[1]) + J.num(r[3]) + 3 and by + h + 3 > J.num(r[1]): o = r; break
		if o == null: break
		by = J.num(o[1]) - h - 5
	if by < 4: by = 4
	R.append([bx, by, w, float(h)])
	if by < by0 - 2:
		ctx.strokeStyle = Color(180 / 255.0, 138 / 255.0, 216 / 255.0, 0.8) if ghost else Color(1, 253 / 255.0, 245 / 255.0, 0.8); ctx.lineWidth = 1.5
		ctx.beginPath(); ctx.moveTo(x, by + h); ctx.lineTo(x, y - 2); ctx.stroke()
	ctx.fillStyle = Color(60 / 255.0, 30 / 255.0, 80 / 255.0, 0.92) if ghost else Color(1, 253 / 255.0, 245 / 255.0, 0.95); ctx.strokeStyle = Color("#b48ad8") if ghost else Color("#3a2a1a"); ctx.lineWidth = 1.5
	ctx.beginPath(); ctx.roundRect(bx, by, w, h, 9); ctx.fill(); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(x - 6, by + h); ctx.lineTo(x, by + h + 8); ctx.lineTo(x + 6, by + h); ctx.fill()
	ctx.fillStyle = Color("#f0e0ff") if ghost else Color("#2a1a10"); ctx.textAlign = "left"
	for i in lines.size(): ctx.fillText(lines[i], bx + 8, by + 18 + i * 17)
	ctx.restore()

# scare.js propMarks：可附身家具嘅虛線框＋名（避開名牌、對白框）；propOK 照叫 JS（規則）
static func prop_marks(ctx: Ctx, Sc: Dictionary, t: float) -> void:
	var PR = J.G.get("SCARE_PROPS"); var sel = Sc.get("sel"); var pano = J.t(J.gp(Sc.get("site"), "pano"))
	var cam = J.num(Sc.get("camX", 0)); var vw = J.num(Sc.get("_vw")) if Sc.get("_vw") != null else -1.0
	var W = J.num(Sc.get("W", 390)); var mana = J.num(Sc.get("mana", 0)); var office = J.t(J.mc(Sc, "office", []))
	var pcd = Sc.get("pcd") if Sc.get("pcd") is Dictionary else {}
	var TR: Array = Sc.get("_tagR") if Sc.get("_tagR") is Array else []
	var BR: Array = Sc.get("_bubLast") if Sc.get("_bubLast") is Array else []
	for k in PR:
		var p = PR[k]; var rc = p.rect
		if pano:
			var cx = J.num(rc[0]) + J.num(rc[2]) / 2
			if vw > 0:
				if not (cx > cam and cx < cam + vw): continue
			elif not J.t(J.mc(Sc, "onScreen", [cx, 0.0])): continue
		if J.t(p.get("group")) or not J.t(J.mc(Sc, "propOK", [k, sel])): continue
		var a1 = ScOffice.pt(Sc, J.num(rc[0]), J.num(rc[1])); var a2 = ScOffice.pt(Sc, J.num(rc[0]) + J.num(rc[2]), J.num(rc[1]) + J.num(rc[3]))
		var x1 = a1.x; var y1 = a1.y; var x2 = a2.x; var y2 = a2.y
		var ok = mana >= J.num(p.cost)   # propOK 上面已經過咗
		var a = (0.35 + 0.25 * sin(t * 3 + x1)) if ok else 0.1
		ctx.strokeStyle = Color(150 / 255.0, 1, 200 / 255.0, a); ctx.lineWidth = 2; ctx.setLineDash([5, 4]); ctx.strokeRect(x1, y1, x2 - x1, y2 - y1); ctx.setLineDash([])
		var grp = J.t(p.get("group"))
		var cdl = (str(ceili(J.num(pcd[k]))) + "秒") if grp and J.num(pcd.get(k, 0)) > 0 else J.str(p.cost)
		var lab = J.str(p.name) + ("（全場）" if grp else "") + "・" + cdl
		ctx.font = "600 11px sans-serif"; ctx.textAlign = "center"
		var tw = J.num(ctx.measureText(lab).width) / 2 + 4; var lx = maxf(tw, minf(W - tw, (x1 + x2) / 2))
		var hit = func(yy: float) -> bool:
			for r in TR:
				if absf(J.num(r[0]) - lx) < tw + 44 and yy > J.num(r[1]) - 22 and yy - 12 < J.num(r[1]) + J.num(r[2]): return true
			for r in BR:
				if lx + tw > J.num(r[0]) and lx - tw < J.num(r[0]) + J.num(r[2]) and yy > J.num(r[1]) and yy - 12 < J.num(r[1]) + J.num(r[3]): return true
			return false
		var ly = y1 - 5 if J.str(p.get("label")) == "up" else y2 + 13
		for c in [y1 - 5, y2 + 13, y1 + 14]:
			if not hit.call(ly): break
			else: ly = c
		if hit.call(ly): continue
		if office: ctx.lineWidth = 3; ctx.strokeStyle = Color(10 / 255.0, 8 / 255.0, 20 / 255.0, 0.75); ctx.strokeText(lab, lx, ly)
		ctx.fillStyle = Color(190 / 255.0, 215 / 255.0, 1, 0.9 if ok else 0.4) if grp else Color(190 / 255.0, 1, 215 / 255.0, 0.9 if ok else 0.4); ctx.fillText(lab, lx, ly)

# scare.js drawTeam：未出手嘅鬼喺天花下面淡淡飄；俾保安捉咗嘅喺佢隔籬飲茶
static func team(ctx: Ctx, Sc: Dictionary, t: float) -> void:
	var busy = {}
	for f in Sc.fx: if J.str(f.get("kind")) == "ghost": busy[J.str(f.get("ghost"))] = true
	var g = null
	for n in Sc.npcs:
		if J.t(n.d.get("guard")) and not J.t(n.get("gone")): g = n; break
	var caught = Sc.get("caught") if Sc.get("caught") is Dictionary else {}
	var cd = Sc.get("cd") if Sc.get("cd") is Dictionary else {}
	var W = J.num(Sc.get("W", 390)); var H = J.num(Sc.get("H", 580)); var mana = J.num(Sc.get("mana", 0))
	var pano = J.t(J.gp(Sc.get("site"), "pano"))
	var ci = 0; var i = -1
	for kk in Sc.team:
		i += 1; var k = J.str(kk)
		if busy.has(k): continue
		var cau = J.t(caught.get(k))
		if cau and g != null:
			ci += 1; var gx = J.num(g.x) - J.num(g.get("dir", 1)) * 0.075 * ci; var p = ScOffice.pt(Sc, gx, J.num(g.y) + 0.004); var s = ScOffice.hh(Sc, J.num(g.y)) / 62.0
			Art.draw_char(ctx, k, p.x, p.y, s, {"t": t + i, "pose": "idle", "alpha": 0.5, "flip": J.num(g.x) < gx, "shadow": false})
			ctx.strokeStyle = Color(1, 1, 1, 0.35); ctx.lineWidth = 1.5
			for j in 2:
				var sx = p.x + (j - 0.5) * 6; var sy = p.y - s * 66
				ctx.beginPath(); ctx.moveTo(sx, sy); ctx.bezierCurveTo(sx + 5, sy - 6 - sin(t * 3 + j) * 3, sx - 5, sy - 12, sx + sin(t * 2 + j) * 3, sy - 20); ctx.stroke()
			continue
		var ready = not cau and cd.has(k) and J.num(cd[k]) <= 0 and mana >= 35; var dx = sin(t * 0.35 + i * 2.1)
		var x = W * (0.17 + 0.33 * i) + dx * W * 0.06; var y = (ScOffice.pt(Sc, 0, 0.36).y if pano else H * 0.27) + sin(t * 0.9 + i) * 6
		var a = (0.34 if ready else 0.13) + 0.06 * sin(t * 1.7 + i)
		Art.draw_char(ctx, k, x, y, 0.8, {"t": t + i * 1.3, "pose": "idle", "alpha": a, "flip": cos(t * 0.35 + i * 2.1) < 0, "shadow": false})

# rooms.js OFFMAP.drawables：會議枱、大堂前台（椅、櫃、螢幕、接待處牌）、後備椅；畫法逐筆照搬
static func _w(el) -> float: return J.num(J.gp(el, "width"))
static func _h(el) -> float: return J.num(J.gp(el, "height"))
static func _U(Sc, y: float) -> float: return ScOffice.hh(Sc, y) * (64.0 / (64.0 * 1.08))
static func om_meet(ctx: Ctx, Sc, tb, mx: float, my: float, SH: float, MTK: float) -> void:
	var b = J.mc(Sc, "bgScale", []); var k = J.num(b.ih) * J.num(b.s) / SH * MTK; var w = 869 * k; var h = 192 * k; var p = ScOffice.pt(Sc, mx, my)
	ctx.save(); ctx.fillStyle = Color(6 / 255.0, 4 / 255.0, 18 / 255.0, 0.32); ctx.beginPath(); ctx.ellipse(p.x, p.y - h * 0.03, w * 0.52, h * 0.14, 0, 0, TAU); ctx.fill(); ctx.drawImage(tb, p.x - w / 2, p.y - h, w, h); ctx.restore()
static func om_rchair(ctx: Ctx, Sc, ch, rx: float, ry: float) -> void:
	var u = _U(Sc, ry); var h = 0.6 * u; var w = h * _w(ch) / _h(ch); var p = ScOffice.pt(Sc, rx, ry - 0.006)
	ctx.save(); ctx.translate(p.x - w * 0.18, p.y); ctx.scale(-1, 1); ctx.drawImage(ch, -w / 2, -h, w, h); ctx.restore()
static func om_rdesk(ctx: Ctx, Sc, rc, mon, rx: float, ry: float) -> void:
	var dy = ry + 0.02; var u = _U(Sc, dy); var h = 0.62 * u; var w = h * (_w(rc) / _h(rc) if rc != null else 2.26)
	var mx = ScOffice.pt(Sc, rx, ry).x; var y = ScOffice.pt(Sc, rx, dy).y; var wa = w * 400 / 578; var x0 = mx - wa * 0.36
	ctx.save(); ctx.fillStyle = Color(6 / 255.0, 4 / 255.0, 18 / 255.0, 0.38); ctx.beginPath(); ctx.ellipse(x0 + w / 2, y - h * 0.01, w * 0.54, h * 0.09, 0, 0, TAU); ctx.fill()
	if mon != null:
		var mh = h * 0.62; var mw = mh * _w(mon) / _h(mon); var top = y - h * (170.0 / 256.0)
		ctx.save(); ctx.translate(x0 + wa * 0.80, top + mh * 0.05); ctx.scale(-1, 1); ctx.drawImage(mon, -mw / 2, -mh, mw, mh); ctx.restore()
	ctx.drawImage(rc, x0, y - h, w, h)
	var bw = (w - wa) * 0.82; var bh = h * 0.11; var bx = x0 + wa + (w - wa - bw) / 2 - w * 0.005; var by = y - h - bh * 0.92
	ctx.fillStyle = Color("#2a1a14"); ctx.fillRect(bx - 1.5, by - 1.5, bw + 3, bh + 3); ctx.fillStyle = Color("#d4b062"); ctx.fillRect(bx, by, bw, bh)
	ctx.fillStyle = Color("#2a1a10"); ctx.font = "900 %dpx \"PingFang TC\",\"Noto Sans TC\",sans-serif" % int(round(bh * 0.7)); ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText("接待處", bx + bw / 2, by + bh * 0.55); ctx.restore()
static func om_spare(ctx: Ctx, Sc, ch, c: Dictionary, chairs: float) -> void:
	var y = J.num(c.y) + J.num(c.oz); var p = ScOffice.pt(Sc, J.num(c.x) + J.num(c.ox), y); var u = _U(Sc, y); var h = 0.62 * u; var w = h * _w(ch) / _h(ch); var s = cos(J.num(c.sw))
	ctx.save(); ctx.fillStyle = Color(6 / 255.0, 4 / 255.0, 18 / 255.0, 0.3); ctx.beginPath(); ctx.ellipse(p.x, p.y, w * 0.42, w * 0.1, 0, 0, TAU); ctx.fill(); ctx.translate(p.x, p.y); ctx.scale(maxf(0.35, absf(s)) * (-1 if s < 0 else 1), 1); ctx.drawImage(ch, -w / 2, -h, w, h); ctx.restore()
	if chairs > 0:
		var a = minf(1.0, chairs)
		if a > 0.01:
			ctx.save(); ctx.globalAlpha *= minf(1, a); ctx.font = "900 %dpx sans-serif" % int(round(u * 0.1)); ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = "#1a1020"; ctx.strokeText("吱——", p.x, p.y - h * 1.05); ctx.fillStyle = "#fff3d0"; ctx.fillText("吱——", p.x, p.y - h * 1.05); ctx.restore()
