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
