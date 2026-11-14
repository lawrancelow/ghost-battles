# 主線戰鬥畫面（原生）：逐句對照 battle.js 嘅 draw／poseOf／drawText／drawSpark／drawSlash／drawDust／drawCharge／drawProj
# 用 Ctx 畫（同 JS canvas 一樣嘅 API），慳返轉譯 JS 嘅開銷；角色交俾原生 Art，出招 MOVES／反派 custom 仍叫 JS ART.drawChar
class_name BtDraw

const ATK := {"windup": 1, "strike": 1, "follow": 1, "recover": 1}
const DARK := Color(10 / 255.0, 6 / 255.0, 20 / 255.0, 0.92)
static var _moves = null
static var _rig = null

static func js(n: String): return J.G.get(n)

static func _eo(p: float) -> float: return 1.0 - pow(1.0 - clampf(p, 0, 1), 3)
static func _io(p: float) -> float:
	p = clampf(p, 0, 1)
	return 4 * p * p * p if p < 0.5 else 1 - pow(-2 * p + 2, 3) / 2

static func uy(B: Dictionary, u: Dictionary) -> float:
	var H = J.num(B.get("H", 640)); return H * 0.5 + J.num(u.get("lane", 0)) * H * 0.1
static func scale_of(u: Dictionary) -> float: return 0.75 if J.t(u.get("minion")) else (1.7 if J.t(u.get("boss")) else 1.32)
static func lunge_of(u: Dictionary) -> float: return 12.0 if J.t(u.get("boss")) else (6.0 if J.t(u.get("minion")) else 9.0)

static func pose_of(B: Dictionary, u: Dictionary) -> Dictionary:
	var fw = -1.0 if J.num(u.side) != 0 else 1.0
	var pose = "move" if J.t(u.get("walking")) else "idle"; var pt = 0.0; var ox = 0.0; var oy = 0.0; var rot = 0.0; var alpha = 1.0
	var st: Dictionary = u.st; var hp = J.num(u.hp)
	if hp <= 0:
		var p = minf(1.0, J.num(u.get("deadT", 0)) / 0.8); var d = J.num(u.get("dieDir", -fw)) if u.get("dieDir") != null else -fw
		pose = "die"; pt = p; ox = d * 24 * _eo(p); oy = -sin(minf(1.0, p * 1.4) * PI) * 12; alpha = 1.0 if p < 0.45 else maxf(0.0, 1 - (p - 0.45) / 0.55)
	elif J.num(st.get("air", 0)) > 0:
		var am = J.num(st.get("airMax", 1)); if am == 0: am = 1.0
		var p = 1 - J.num(st.air) / am; pose = "air"; pt = p; ox = -fw * 12 * sin(p * PI)
	elif J.num(st.get("down", 0)) > 0:
		var D = J.num(st.get("downMax", 1.4)); if D == 0: D = 1.4
		var el = D - J.num(st.down); pose = "down"; pt = el / D
		if el < 0.25: oy = -absf(sin(el / 0.25 * PI)) * 7
	elif J.num(st.get("push", 0)) > 0: pose = "hurt"; pt = 1 - J.num(st.push) / 0.25
	elif u.get("casting") != null: pose = "cast"; pt = minf(1.0, J.num(u.casting.t) / J.num(u.casting.dur))
	elif u.get("anim") != null:
		var a = u.anim; var p = J.num(a.t) / J.num(a.dur); var L = lunge_of(u); var ranged = J.num(u.range) > 60
		pose = J.str(a.name); pt = minf(1.0, p)
		if pose == "windup": ox = -fw * (1.0 if ranged else 2.0) * _eo(p)
		elif pose == "strike": ox = -fw * 5 * _eo(p * 2) if ranged else fw * L * _eo(p * 2.4)
		else: ox = -fw * 5 * (1 - _io(p)) if ranged else fw * L * (1 - _io(p))
	elif J.num(u.get("hurtT", 0)) > 0: pose = "hurt"; pt = 1 - J.num(u.hurtT) / 0.25
	if u.get("kbT") != null and hp > 0:
		var p = J.num(u.kbT) / 0.3; var k = _eo(p / 0.25) if p < 0.25 else 1 - _io((p - 0.25) / 0.75)
		ox += (J.num(u.kbDir) if u.get("kbDir") != null else -fw) * (J.num(u.kbAmp) if u.get("kbAmp") != null else 6.0) * k
	if pose == "idle" and hp > 0:
		var ph = J.num(u.get("lane", 0)) * 1.7 + (0.9 if J.num(u.side) != 0 else 0.0); var tt = J.num(B.t) + ph
		oy += -absf(sin(tt * 4.2)) * 2.2
		var tq = fmod(tt, 4.6) / 4.6
		if not J.t(u.get("minion")) and tq > 0.82:
			var k = sin((tq - 0.82) / 0.18 * PI); ox += fw * 4 * k; rot += -fw * 0.05 * k
	return {"pose": pose, "pt": pt, "ox": ox, "oy": oy, "rot": rot, "alpha": alpha}

static func draw_char(ctx: Ctx, k: String, x: float, y: float, s: float, o: Dictionary) -> void:
	if _moves == null: _moves = js("MOVES"); _rig = J.gp(js("MeshAnim"), "RIG")
	var jsd = false
	if ATK.has(o.pose) and _moves is Dictionary and _moves.has(k): jsd = true
	elif _rig is Dictionary and _rig.get(k) is Dictionary and _rig[k].get("custom") != null: jsd = true
	if jsd: J.mc(js("ART"), "drawChar", [ctx, k, x, y, s, o])
	else: Art.draw_char(ctx, k, x, y, s, o.duplicate())

static func rr(ctx: Ctx, x: float, y: float, w: float, h: float, r: float, col: Color) -> void:
	ctx.fillStyle = col; ctx.beginPath(); ctx.roundRect(x, y, maxf(0.0, w), h, r); ctx.fill()

# ---------------- 主畫面 ----------------
static func draw(ctx: Ctx, B: Dictionary) -> void:
	var k = J.num(B.sc); var A = J.num(B.get("shakeA", 0))
	var shx = (randf() - 0.5) * 2 * A if A > 0 else 0.0; var shy = (randf() - 0.5) * 1.2 * A if A > 0 else 0.0
	ctx.setTransform(k, 0, 0, k, shx * k, shy * k)
	var H = J.num(B.h) / k; B["H"] = H
	var T = J.num(B.t)
	var SC = js("SCENE")
	if not J.t(J.mc(SC, "drawBg", [ctx, 390.0, H, B.bg])):
		J.cl(js("paintBg"), null, [ctx, 390.0, H * 0.545, B.bg, T])
		var gy = H * 0.36; var gg = ctx.createLinearGradient(0, gy, 0, H)
		gg.addColorStop(0, "#2a2622"); gg.addColorStop(0.5, "#1c1a1a"); gg.addColorStop(1, "#121012"); ctx.fillStyle = gg; ctx.fillRect(0, gy, 390, H - gy)
	var slowT = J.num(B.get("slowT", 0))
	if slowT > 0: ctx.fillStyle = Color(8 / 255.0, 4 / 255.0, 20 / 255.0, minf(0.35, slowT * 2.4)); ctx.fillRect(-20, -20, 430, H + 40)
	var fxs: Array = B.fx
	for f in fxs: if J.str(f.get("kind", "")) == "dust": draw_dust(ctx, f)
	var list: Array = B.units.duplicate()
	list.sort_custom(func(a, b): return J.num(a.get("lane", 0)) < J.num(b.get("lane", 0)))
	var fw = UIKit.font("sans", 900)
	for u in list:
		var hp = J.num(u.hp)
		if hp <= 0 and J.num(u.get("deadT", 0)) > 0.8: continue
		var P = pose_of(B, u); var s = scale_of(u); var x = J.num(u.x) + P.ox; var y0 = uy(B, u); var y = y0 + P.oy
		var side1 = J.num(u.side) != 0
		var cc = Color("#ff9ac0") if side1 else Color("#9ff3ff")
		if u.get("casting") != null: draw_charge(ctx, T, x, y0 - 28 * s, s, J.num(u.casting.t) / J.num(u.casting.dur), cc, false)
		var tg = u.anim.get("tg") if u.get("anim") is Dictionary else null
		if tg is Dictionary and J.num(tg.hp) <= 0: tg = null
		var o = {"tdx": J.num(tg.x) - J.num(u.x) if tg != null else (-40.0 if side1 else 40.0), "tdy": uy(B, tg) - uy(B, u) if tg != null else 0.0,
			"t": T + J.num(u.get("lane", 0)), "walk": P.pose == "move", "pose": P.pose, "pt": P.pt, "flip": side1, "enemy": side1, "alpha": P.alpha, "rot": P.rot, "tamed": not side1, "untied": not side1}
		draw_char(ctx, J.str(u.k), x, y, s, o)
		var fl = J.num(u.get("flash", 0))
		if fl > 0:
			ctx.save(); ctx.globalCompositeOperation = "lighter"
			var o2 = o.duplicate(); o2.alpha = P.alpha * fl * 0.85; o2.shadow = false
			draw_char(ctx, J.str(u.k), x, y, s, o2); ctx.restore()
		if u.get("casting") != null: draw_charge(ctx, T, x, y0 - 28 * s, s, J.num(u.casting.t) / J.num(u.casting.dur), cc, true)
		if hp > 0:
			var mn = J.t(u.get("minion")); var bo = J.t(u.get("boss"))
			var bx = J.num(u.x) + P.ox * 0.4; var bw = 26.0 if mn else (64.0 if bo else 46.0); var by = y0 - (36.0 if mn else (92.0 if bo else 72.0))
			rr(ctx, bx - bw / 2, by, bw, 5, 2, Color(0, 0, 0, 0.6))
			rr(ctx, bx - bw / 2, by, bw * hp / J.num(u.maxhp), 5, 2, Color("#e84a5f") if side1 else Color("#4ade80"))
			var en = J.num(u.get("energy", 0))
			if u.get("sk") != null and not mn: rr(ctx, bx - bw / 2, by + 6, bw * en / 100.0, 3, 1.5, Color("#ffd84a") if en >= 100 else Color("#7dd3fc"))
			var st: Dictionary = u.st
			ctx.textAlign = "center"
			if bo: ctx.fillStyle = Color("#ffd0d8"); ctx.font = "bold 12px sans-serif"; ctx.fillText(J.str(DB.L(J.str(u.name))), bx, by - 4)
			var air = J.num(st.get("air", 0)) > 0; var down = J.num(st.get("down", 0)) > 0
			if air or down:
				ctx.fillStyle = Color("#99ffff") if air else Color("#ffcc99"); ctx.font = "bold 11px sans-serif"
				ctx.fillText(J.str(DB.L("嚇彈起" if air else "腳軟")), bx, by - (18.0 if bo else 4.0))
			var ft = u.get("fearT")
			if side1 and ft is Dictionary and J.num(ft.get("until", 0)) > T:
				ctx.save(); ctx.font = "bold 11px sans-serif"; ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = Color(20 / 255.0, 0, 30 / 255.0, 0.8); ctx.fillStyle = Color("#e6c4ff")
				var ty = by - (18.0 if bo else 6.0) - (13.0 if air or down else 0.0)
				var tx = J.str(DB.L("失神")) + "・" + J.str(DB.L(J.str(J.mc(js("Rework"), "word", [ft.get("t")]))))
				ctx.strokeText(tx, bx, ty); ctx.fillText(tx, bx, ty); ctx.restore()
	# 軍師／合體技蓄力
	var ac = B.get("advCast")
	if ac is Dictionary: draw_charge(ctx, T, 34, H * 0.36, 1, J.num(ac.t) / J.num(ac.dur), Color("#c8ffb0"), true)
	var cc2 = B.get("comboCast")
	if cc2 is Dictionary:
		var c = B.comboSkill; var p = J.num(cc2.t) / J.num(cc2.dur)
		for u in [c.a, c.b]:
			if J.num(u.hp) > 0: draw_charge(ctx, T, J.num(u.x), uy(B, u) - 28 * scale_of(u), scale_of(u), p, Color("#ffb0ff"), true)
	for p in B.get("proj", []): draw_proj(ctx, p)
	var flashT = J.num(B.get("flashT", 0))
	if flashT > 0: ctx.fillStyle = Color(1, 1, 1, minf(1.0, flashT * 1.5)); ctx.fillRect(-20, -20, 430, H + 40)
	for f in fxs:
		var kd = J.str(f.get("kind", ""))
		if kd == "spark": draw_spark(ctx, f)
		elif kd == "slash": draw_slash(ctx, f)
		elif kd == "ring":
			var p = J.num(f.t) / J.num(f.life); ctx.save(); ctx.globalAlpha = 1 - p; ctx.strokeStyle = f.col; ctx.lineWidth = 3 * (1 - p) + 1
			ctx.beginPath(); ctx.ellipse(J.num(f.x), J.num(f.y), 14 + p * 26, (14 + p * 26) * 0.5, 0, 0, TAU); ctx.stroke(); ctx.restore()
		elif kd != "dust": draw_text(ctx, f)
	var combo = J.num(B.get("combo", 0))
	if J.num(B.get("comboT", 0)) > 0 and combo > 0:
		var z = 1 + J.num(B.get("comboPop", 0)) * 0.7
		ctx.save(); ctx.translate(380, 40); ctx.scale(z, z); ctx.textAlign = "right"; ctx.font = "900 16px sans-serif"; ctx.lineWidth = 4; ctx.strokeStyle = DARK
		var ctext = "COMBO %d" % int(combo)
		ctx.strokeText(ctext, 0, 0); ctx.fillStyle = Color("#ffd84a"); ctx.fillText(ctext, 0, 0); ctx.restore()

# 跳字：彈出（過衝）後往上拋再落下
static func draw_text(ctx: Ctx, f: Dictionary) -> void:
	var t = J.num(f.t); var life = J.num(f.life)
	var a = maxf(0.0, 1 - (t - life * 0.7) / (life * 0.3)) if t > life * 0.7 else 1.0
	var pop = 0.35 + (t / 0.1) * 1.05 if t < 0.1 else (1.4 - (t - 0.1) / 0.1 * 0.4 if t < 0.2 else 1.0)
	var x = J.num(f.x); var y = J.num(f.y)
	var center = J.t(f.get("center")); var big = J.t(f.get("big"))
	if J.str(f.get("kind", "")) == "num": x += J.num(f.get("vx", 0)) * t; y += -120 * t + 0.5 * 330 * t * t
	elif not center: y -= t * 30
	var size = 30 if center else (16 if J.t(f.get("skill")) else (19 if big else 14))
	ctx.save(); ctx.globalAlpha = a; ctx.translate(x, y); ctx.scale(pop, pop); ctx.textAlign = "center"
	ctx.font = "900 %dpx sans-serif" % size
	ctx.lineWidth = 5 if big or center else 4; ctx.lineJoin = "round"; ctx.strokeStyle = DARK
	var tx = J.str(DB.L(J.str(f.text)))
	ctx.strokeText(tx, 0, 0); ctx.fillStyle = f.col; ctx.fillText(tx, 0, 0); ctx.restore()

# 蠟筆風火花
static func draw_spark(ctx: Ctx, f: Dictionary) -> void:
	var p = J.num(f.t) / J.num(f.life); var e = 1 - pow(1 - p, 2); var a = 1 - p; var fk = J.num(f.k)
	ctx.save(); ctx.lineCap = "round"; ctx.translate(J.num(f.x), J.num(f.y))
	var rays: Array = f.rays
	var passes = [[Color(20 / 255.0, 10 / 255.0, 30 / 255.0, 0.85), 4.2 * fk * (1 - p * 0.5), 0.8, 0], [f.col, 2.4 * fk * (1 - p * 0.5), 1.0, 2], [Color.WHITE, 1.0 * fk, 0.9, 4]]
	for ps in passes:
		ctx.strokeStyle = ps[0]; ctx.globalAlpha = ps[2] * a; ctx.lineWidth = ps[1]; var off = ps[3]
		for r in rays:
			var ln = J.num(r.len); var ra = J.num(r.a); var rj = J.num(r.j)
			var r0 = ln * (0.15 + e * 0.55); var r1 = ln * (0.45 + e * 0.75); var c = cos(ra); var sn = sin(ra)
			for i in 2:
				ctx.beginPath()
				ctx.moveTo(c * r0 + sin(rj + (i + off) * 7.3) * 1.6, sn * r0 + sin(rj + (i + off + 3) * 7.3) * 1.6)
				ctx.lineTo(c * r1 + sin(rj + (i + off + 5) * 7.3) * 1.6, sn * r1 + sin(rj + (i + off + 1) * 7.3) * 1.6); ctx.stroke()
	if p < 0.5:
		var q = (1 - p * 2) * 12 * fk; ctx.globalAlpha = 1 - p * 2; ctx.rotate(J.num(f.rot)); ctx.fillStyle = Color.WHITE; ctx.beginPath()
		for i in 8:
			var ang = i * PI / 4; var rr2 = q * 0.28 if i % 2 else q
			ctx.lineTo(cos(ang) * rr2, sin(ang) * rr2)
		ctx.closePath(); ctx.fill()
	ctx.restore()

# 刀光弧
static func draw_slash(ctx: Ctx, f: Dictionary) -> void:
	var p = J.num(f.t) / J.num(f.life); var r = J.num(f.r); var dir = J.num(f.dir); var sweep = minf(1.0, p * 2.2)
	var a0 = -1.25; var a1 = a0 + 2.5 * sweep; var tail = maxf(a0, a1 - 1.6)
	ctx.save(); ctx.translate(J.num(f.x) - dir * r * 0.35, J.num(f.y)); ctx.scale(dir, 1); ctx.globalAlpha = 1 - p * 0.9; ctx.lineCap = "round"
	var cols = [Color(20 / 255.0, 10 / 255.0, 30 / 255.0, 0.6), f.col, Color.WHITE]; var ws = [7.0, 4.0, 1.6]
	for i in 3:
		ctx.strokeStyle = cols[i]; ctx.lineWidth = ws[i] * (1 - p * 0.6)
		ctx.beginPath(); ctx.arc(0, 0, r - i * 1.2 + sin(i * 3) * 0.8, tail, a1); ctx.stroke()
	ctx.restore()

static func draw_dust(ctx: Ctx, f: Dictionary) -> void:
	var p = J.num(f.t) / J.num(f.life); var e = 1 - pow(1 - p, 2)
	ctx.save(); ctx.globalAlpha = 0.55 * (1 - p); ctx.fillStyle = Color(190 / 255.0, 176 / 255.0, 150 / 255.0)
	for q in f.puffs:
		ctx.beginPath(); ctx.arc(J.num(f.x) + J.num(q.dx) + J.num(q.vx) * e * 0.4, J.num(f.y) - 2 - e * 8, J.num(q.r) * (0.6 + e * 0.9), 0, TAU); ctx.fill()
	ctx.restore()

# 蓄力光圈
static func draw_charge(ctx: Ctx, T: float, x: float, y: float, s: float, p: float, col: Color, front: bool) -> void:
	p = minf(1.0, p); ctx.save()
	if not front:
		var g = ctx.createRadialGradient(x, y, 0, x, y, 46 * s); g.addColorStop(0, col); g.addColorStop(1, Color(0, 0, 0, 0))
		ctx.globalCompositeOperation = "lighter"; ctx.globalAlpha = 0.25 + p * 0.45; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, 46 * s, 0, TAU); ctx.fill(); ctx.restore(); return
	var R = (44 - p * 26) * s; ctx.strokeStyle = col; ctx.lineWidth = 2.5; ctx.globalAlpha = 0.4 + p * 0.6
	ctx.setLineDash([7, 5]); ctx.beginPath(); ctx.ellipse(x, y + 20 * s, R * 1.1, R * 0.42, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([])
	ctx.lineWidth = 1.6; ctx.beginPath(); ctx.arc(x, y, R, 0, TAU); ctx.stroke()
	ctx.fillStyle = Color.WHITE
	for i in 8:
		var ang = i * PI / 4 + T * 3; var rr2 = R * (1.25 - p * 0.6); ctx.globalAlpha = 0.9
		ctx.beginPath(); ctx.arc(x + cos(ang) * rr2, y + sin(ang) * rr2 * 0.8, 1.6 + p * 1.4, 0, TAU); ctx.fill()
	ctx.restore()

static func draw_proj(ctx: Ctx, p: Dictionary) -> void:
	ctx.save(); ctx.lineCap = "round"
	var tr: Array = p.trail; var col = p.col
	for i in range(1, tr.size()):
		var f = float(i) / tr.size(); ctx.globalAlpha = f * 0.7; ctx.strokeStyle = col; ctx.lineWidth = 1 + f * 5
		ctx.beginPath(); ctx.moveTo(J.num(tr[i - 1][0]), J.num(tr[i - 1][1])); ctx.lineTo(J.num(tr[i][0]), J.num(tr[i][1])); ctx.stroke()
	var px = J.num(p.x); var py = J.num(p.y)
	if tr.size():
		var l = tr[tr.size() - 1]; ctx.globalAlpha = 0.8; ctx.lineWidth = 6; ctx.beginPath(); ctx.moveTo(J.num(l[0]), J.num(l[1])); ctx.lineTo(px, py); ctx.stroke()
	ctx.globalAlpha = 1; ctx.globalCompositeOperation = "lighter"
	var g = ctx.createRadialGradient(px, py, 0, px, py, 11); g.addColorStop(0, "#fff"); g.addColorStop(0.35, col); g.addColorStop(1, Color(0, 0, 0, 0))
	ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, 11, 0, TAU); ctx.fill()
	ctx.restore()
