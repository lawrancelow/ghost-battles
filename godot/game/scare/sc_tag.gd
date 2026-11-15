# 回陽間・名牌（scare.js draw 入面「眼＋恐懼條＋名＋狀態膠囊＋？！」）原生版
#  計法（watching／sees／witnesses）照叫 JS；畫法逐筆跟 scare.js，數值一樣
class_name ScTag
extends RefCounted

static func draw(ctx: Ctx, Sc: Dictionary, n: Dictionary, x: float, by: float, t: float, sel) -> void:
	var d = n.d; var name = J.str(d.name)
	var dir = J.num(n.get("dir", 1)); if dir == 0: dir = 1
	# 眼
	ctx.font = "700 11px sans-serif"
	var nw2 = J.num(ctx.measureText(name).width) / 2.0
	var ex = x - nw2 - 12; var ey = by - 10
	var op = J.t(J.mc(Sc, "watching", [n]))
	var red = sel != null and not is_same(n, sel) and J.t(J.mc(Sc, "sees", [n, sel]))
	ctx.save(); ctx.fillStyle = Color(0, 0, 0, 0.6); ctx.beginPath(); ctx.arc(ex, ey, 7.5, 0, TAU); ctx.fill(); ctx.lineWidth = 1.6
	if op:
		ctx.fillStyle = Color("#ff6a5a") if red else Color("#f2f2f2"); ctx.beginPath(); ctx.ellipse(ex, ey, 5.5, 3.5, 0, 0, TAU); ctx.fill()
		ctx.fillStyle = Color("#111111"); ctx.beginPath(); ctx.arc(ex + dir * 1.2, ey, 2, 0, TAU); ctx.fill()
	else:
		ctx.strokeStyle = Color("#99aaaa"); ctx.beginPath(); ctx.arc(ex, ey - 2, 4.5, 0.25 * PI, 0.75 * PI); ctx.stroke()
	ctx.restore()
	# 恐懼條
	var bw = 60.0; var fear = J.num(n.get("fear", 0)); var f = minf(1.0, fear / 100.0)
	var hk = maxf(0.0, J.num(n.get("barHit", 0))); var shk = J.num(n.get("shaken", 0)) > 0; var bh = 6 + hk * 3
	ctx.fillStyle = Color(0, 0, 0, 0.65); ctx.fillRect(x - bw / 2 - 2, by - 3 - hk * 1.5, bw + 4, bh + 4)
	if shk:
		ctx.strokeStyle = Color(1, 90 / 255.0, 80 / 255.0, 0.45 + 0.4 * sin(t * 7)); ctx.lineWidth = 1.6; ctx.strokeRect(x - bw / 2 - 2.5, by - 3.5 - hk * 1.5, bw + 5, bh + 5)
	ctx.fillStyle = Color("#ff5a4a") if f >= 0.5 else (Color("#ffb84a") if f >= 0.25 else Color("#9be8b0")); ctx.fillRect(x - bw / 2, by - 1 - hk * 1.5, bw * f, bh)
	if hk > 0: ctx.fillStyle = Color(1, 1, 1, hk * 0.75); ctx.fillRect(x - bw / 2, by - 1 - hk * 1.5, bw * f, bh)
	ctx.fillStyle = Color(1, 1, 1, 0.4); ctx.fillRect(x - bw / 2 + bw * 0.25, by - 2, 1, bh + 2); ctx.fillRect(x - bw / 2 + bw * 0.5, by - 2, 1, bh + 2)
	# 名
	ctx.font = "700 11px sans-serif"; ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = Color(0, 0, 0, 0.8); ctx.strokeText(name, x, by - 6)
	ctx.fillStyle = Color("#a8ffcf") if is_same(n, Sc.get("sel")) else Color("#eeeeee"); ctx.fillText(name, x, by - 6)
	# 狀態膠囊
	var mocked = J.num(n.get("mocked", 0))
	var is_sel = sel != null and is_same(n, sel)
	if is_sel or (mocked > 0 and not J.t(d.get("guard"))):
		var nw = -1
		if is_sel: nw = (J.mc(Sc, "witnesses", [n]) as Array).size()
		var a = "" if nw < 0 else ("%d人望緊" % nw if nw else "冇人望緊")
		var b = ("冇人信×%d" % mini(4, int(mocked))) if mocked > 0 else ""
		ctx.font = "800 11px sans-serif"
		var parts = []
		if a != "": parts.append(a)
		if b != "": parts.append(b)
		var tx = "・".join(parts); var tw = J.num(ctx.measureText(tx).width)
		ctx.fillStyle = Color(10 / 255.0, 8 / 255.0, 18 / 255.0, 0.72); ctx.beginPath(); ctx.roundRect(x - tw / 2 - 6, by - 33, tw + 12, 15, 7.5); ctx.fill()
		ctx.fillStyle = Color("#ff8a7a") if nw > 0 else (Color("#d6a0ff") if b != "" and nw < 0 else Color("#8fe8b0")); ctx.fillText(tx, x, by - 21.5)
	# ？！
	var mark = "!!!" if J.t(n.get("fleeing")) else ("！" if fear >= 50 else ("？" if fear >= 25 else ""))
	if mark != "":
		ctx.font = "700 11px sans-serif"; ctx.save()
		ctx.translate(x + J.num(ctx.measureText(name).width) / 2 + (16 if mark.length() > 1 else 10), by - 3 - absf(sin(t * 6)) * 2)
		# 註：scare.js 原句嘅 scale／rotate 俾同一行嘅註解食咗，所以呢度都唔放大唔搖（同網頁版一樣）
		ctx.font = "900 %dpx sans-serif" % (19 if fear >= 50 else 16); ctx.textAlign = "center"; ctx.fillStyle = Color("#ff6a5a") if fear >= 50 else Color("#ffd36a")
		ctx.strokeStyle = Color.BLACK; ctx.lineWidth = 3; ctx.strokeText(mark, 0, 0); ctx.fillText(mark, 0, 0); ctx.restore()
