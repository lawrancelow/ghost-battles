# 回陽間：路人（企／行／逃跑）嘅原生畫法＝scare.js drawNpc + npcPose + drawNpcSprite + npcFx 嘅逐行移植
# 坐喺工位（OFFICE.drawKen）同美美（OFFICE.drawMis）仍然由 JS 畫
class_name ScNpc
extends RefCounted

const NPC_UNIT := 64.0 * 1.08

static func _b(v) -> bool: return J.t(v)
static func _n(v, d := 0.0) -> float: return J.num(v) if v != null else d

static func pose(Sc: Dictionary, n: Dictionary) -> Dictionary:
	var d: Dictionary = n.d; var f = _n(n.get("fear")); var rxr = n.get("rx")
	var rx = rxr if rxr is Dictionary and _n(rxr.get("t")) >= 0 else null
	var walking = J.str(n.get("act")) == "walk"
	var hab = false
	var H = n.get("hab")
	if H is Dictionary:
		for k in H: if _n(H[k]) >= 1.5: hab = true; break
	var dk = J.str(d.k)
	var calm = "b" if dk == "ken" or dk == "auntie" else (("q" if sin(_n(n.get("at")) * 0.9) > 0.55 else "n") if dk == "boss" else "n")
	var o = {"pose": "idle", "face": "b" if hab and f < 25 else calm, "pt": 0.0, "walk": false, "src": null, "sx": 1.0, "sy": 1.0, "lift": 0.0, "jit": 0.0, "rot": 0.0, "spd": 1.0}
	var t = _n(Sc.get("t"))
	if _b(n.get("fleeing")):
		var age = t - _n(n.get("fleeT")); var hold = _n(n.get("fleeHold"))
		if age >= hold or _b(n.get("gone")):
			o.merge({"pose": "run", "face": "t", "walk": true, "jit": 0.35, "spd": 2.2, "run": true}, true); return o
		if age >= hold - 0.4:
			var p = (age - hold + 0.4) / 0.4; var s = sin(p * PI)
			o.merge({"pose": "startle", "pt": p, "face": "t", "lift": s * 1.3, "sy": 1 + 0.14 * s, "sx": 1 / (1 + 0.14 * s), "src": rxr.get("src") if rxr is Dictionary else null}, true); return o
	var act = J.str(n.get("act"))
	if walking:
		o.pose = "move"; o.walk = true
		if f >= 50: o.merge({"face": "t" if f >= 80 else "f", "jit": 0.45, "spd": 0.75}, true)
		elif f >= 25: o.face = "q"
	elif f >= 80: o.merge({"pose": "cower", "face": "t", "jit": 0.8}, true)
	elif f >= 50: o.merge({"pose": "tremble", "face": "f", "jit": 0.3}, true)
	elif f >= 25: o.merge({"pose": "look", "face": "q"}, true)
	elif act == "brk_nap": o.merge({"pose": "idle", "face": "c", "doze": true}, true)
	elif act == "brk_phone": o.merge({"pose": "phone", "face": "b"}, true)
	elif act == "brk_drink": o.merge({"pose": "sip", "face": "c"}, true)
	elif dk == "ken": o.merge({"pose": "phone", "face": "b"}, true)
	elif act == "mop": o.merge({"pose": "mop", "face": "b"}, true)
	elif _b(d.get("daoshi")) and act == "ritual": o.pose = "ritual"
	elif _b(d.get("guard")) and act == "doze": o.merge({"pose": "idle", "face": "c", "doze": true}, true)
	elif _b(d.get("guard")): o.merge({"pose": "look", "face": "n"}, true)
	elif dk == "boss": o.pose = "hold"
	var TW = J.G.get("TOWN")
	if f < 25 and not walking and not _b(n.get("fleeing")) and TW != null and J.cl(TW.actAnim, null, [n]) != null: o.pose = act
	if rx != null:
		var rt = _n(rx.get("t")); var p = minf(1.0, rt / maxf(0.0001, _n(rx.get("dur"), 1.0))); o.src = rx.get("src"); var rk = J.str(rx.get("k"))
		var jump = func(A: float, mul: float):
			if rt < A: o.sx = 1.09; o.sy = 0.88; o.face = "s"; return
			var q = minf(1.0, (rt - A) / maxf(0.2, (0.55 if rk == "burst" else _n(rx.get("dur"), 1.0)) - A)); var up = sin(minf(1.0, q * 1.5) * PI)
			o.merge({"pose": "startle", "pt": q, "walk": false, "face": "t" if rk == "burst" or (q > 0.4 and f >= 75) else "s", "lift": up * mul, "sy": 1 + 0.13 * up, "sx": 1 / (1 + 0.13 * up), "jit": 0.0}, true)
		match rk:
			"flinch": o.merge({"pose": "move" if o.walk else "hurt", "pt": p, "face": "s", "sx": 1 + 0.06 * (1 - p), "sy": 1 - 0.06 * (1 - p)}, true)
			"startle": jump.call(0.08, 1.1 if _b(rx.get("big")) else 0.75)
			"weakjump": jump.call(0.09, 1.5)
			"burst":
				if rt < 0.55: jump.call(0.07, 1.4)
				elif o.walk: o.merge({"face": "t", "jit": 1.0, "spd": 1.6}, true)
				else: o.merge({"pose": "cower", "face": "t", "jit": 1.0, "pt": minf(1.0, (rt - 0.55) / 0.3)}, true)
			"rational":
				var sh = sin(minf(1.0, rt / 0.55) * PI)
				o.merge({"face": "q", "sy": 1 + 0.06 * sh, "sx": 1 - 0.02 * sh, "lift": 0.18 * sh, "rot": -0.06 * sh, "shrug": sh}, true)
				if not o.walk: o.pose = "shrug"; o.pt = minf(1.0, rt / 0.9)
			"numb":
				o.face = "b"
				if not o.walk: o.pose = "phone" if dk == "ken" else ("mop" if _b(d.get("mop")) else ("hold" if dk == "boss" else "idle"))
			"sip":
				if not o.walk: o.pose = "sip"
				o.face = "c"
			"catch": o.pose = "look"; o.face = "q"; o.walk = false
			"chill":
				var t2 = rt; var sh = 1 - t2 / 0.7 if t2 < 0.7 else 0.0
				var sq = minf(1.0, minf(absf(t2 - 0.9) / 0.12, absf(t2 - 1.9) / 0.12))
				o.merge({"face": "s" if t2 < 0.7 else "q", "jit": 0.5 * sh, "sy": 1 - 0.06 * sh, "sx": (1 + 0.03 * sh) * (0.45 + 0.55 * sq)}, true)
				if not o.walk: o.pose = "tremble" if t2 < 0.7 else "look"
				o.turn = t2 > 0.9 and t2 < 1.9
		o.rxk = rk
	return o

# 回傳 [x, top]
static func draw(ctx: Ctx, Sc: Dictionary, n: Dictionary, t: float) -> Dictionary:
	var OF = J.G.get("OFFICE"); var office = _b(J.mc(Sc, "office", []))
	var st = _n(Sc.get("t"))
	var ga = 1.0
	if office and _b(n.get("gone")): ga = maxf(0, 1 - (st - _n(n.get("exitT"))) / 0.8)
	elif _b(n.get("out")): ga = maxf(0, 1 - (st - _n(n.get("outAt"))) / 0.6)
	elif n.get("inAt") != null and st - _n(n.get("inAt")) < 0.6: ga = minf(1, (st - _n(n.get("inAt"))) / 0.6)
	ctx.globalAlpha = ga
	var vp: Array = J.mc(Sc, "visPos", [n])
	var vx = _n(vp[0]); var vy = _n(vp[1])
	if office: vx += _n(J.mc(OF, "kenOff", [n]))
	var P = ScOffice.pt(Sc, vx, vy); var x = P.x; var y = P.y; var hh = ScOffice.hh(Sc, vy); var d: Dictionary = n.d
	n["vX"] = vx; n["vY"] = vy
	var o = pose(Sc, n); n["spd"] = o.spd
	var right = (_n(vp[2]) > 0) if vp[2] != null else _n(n.get("dir"), 1) > 0
	if o.src != null and not _b(d.get("guard")) and not o.walk and not o.get("run", false): right = _n(o.src) >= vx
	if o.get("turn", false): right = not right
	var spr = J.str(d.spr)
	var rig = _b(J.mc(Sc, "rigOK", [spr]))
	var jx = (randf() - 0.5) * 3.2 * o.jit if o.jit else 0.0; var jy = (randf() - 0.5) * 1.2 * o.jit if o.jit else 0.0
	var lift = o.lift * hh * (0.1 if rig else 0.16)
	if n == Sc.get("sel") and not _b(n.get("gone")) and not _b(n.get("fleeing")):
		ctx.fillStyle = "rgba(160,255,200,.28)"; ctx.beginPath(); ctx.ellipse(x, y, hh * 0.34, hh * 0.08, 0, 0, TAU); ctx.fill()
	var shk = 1 - minf(0.5, o.lift * 0.35)
	ctx.fillStyle = "rgba(0,0,0,.35)"; ctx.beginPath(); ctx.ellipse(x, y, hh * 0.22 * shk * (1.2 if o.pose == "cower" else 1.0), hh * 0.05 * shk, 0, 0, TAU); ctx.fill()
	var sit = hh * 0.22 if _b(J.mc(Sc, "sitting", [n])) else 0.0
	if sit and J.str(d.k) == "mis" and o.src == null: right = true
	ctx.save()
	if sit: ctx.beginPath(); ctx.rect(x - hh, y - hh * 2, hh * 2, hh * 2 - hh * 0.02); ctx.clip()
	ctx.translate(x + jx, y + jy - lift + sit)
	if o.rot: ctx.rotate(o.rot * (1 if right else -1))
	ctx.scale(o.sx, o.sy)
	if d.get("tint") != null: ctx.filter = J.str(d.tint)
	if rig:
		var TW = J.G.get("TOWN"); var oo = {"t": _n(n.get("at")), "pose": o.pose, "pt": o.pt, "face": o.face, "flip": not right, "walk": o.walk, "shadow": false, "_daily": true}
		if TW != null:
			var no = J.cl(TW.npcOpts, null, [n])
			if no is Dictionary: oo.merge(no, true)
		Art.draw_char(ctx, spr, 0, 0, hh / NPC_UNIT, oo)
	else: _sprite(ctx, n, o, hh, right)
	ctx.filter = "none"; ctx.restore()
	if _b(d.get("mop")) and o.pose == "mop" and randf() < 0.05:
		Sc.parts.append({"kind": "drop", "x": vx + (1 if right else -1) * 0.05, "y": vy, "vx": 0.0, "vy": 0.0, "life": 1.4})
	_fx(ctx, Sc, n, o, x + jx, y - lift, hh, right, t); ctx.globalAlpha = 1.0
	var daily = n.get("daily")
	var nap = hh * 0.15 if J.str(n.get("act")) == "brk_nap" and daily is Dictionary and _b(daily.get("forced")) and _n(daily.get("w")) > 0.5 else 0.0
	return {"x": x, "top": y - lift + sit + nap - hh * (0.8 if o.pose == "cower" else 1.0) * o.sy}

static func _sprite(ctx: Ctx, n: Dictionary, o: Dictionary, hh: float, right: bool) -> void:
	var tex = Spr.get_tex(J.str(n.d.spr))
	if tex == null: return
	var w = hh * tex.get_width() / tex.get_height(); var a = _n(n.get("at"))
	var bob = 0.0; var tilt = 0.0; var sx = 1.0; var sy = 1 + sin(a * 2.2) * 0.012
	match o.pose:
		"move": bob = absf(sin(a * 9)) * hh * 0.05; tilt = sin(a * 9) * 0.04
		"run": bob = absf(sin(a * 11)) * hh * 0.08; tilt = 0.22 + sin(a * 11) * 0.06; sx = 1.04
		"startle": tilt = -0.25 * sin(minf(1, o.pt * 1.6) * PI)
		"cower": sy = 0.8 + sin(a * 30) * 0.015; sx = 1.1; tilt = 0.12
		"tremble": tilt = sin(a * 40) * 0.025
		"phone": tilt = 0.06 + sin(a * 1.3) * 0.01
		"mop": tilt = sin(a * 4) * 0.06
		"look": tilt = sin(a * 1.6) * 0.05
		"hurt": tilt = -0.2 * (1 - o.pt)
		"sip": tilt = -0.05 + sin(a * 1.2) * 0.03
	ctx.translate(0, -bob); ctx.rotate(tilt * (1 if right else -1)); ctx.scale((1 if right else -1) * sx, sy); ctx.drawImage(tex, -w / 2, -hh, w, hh)

static func _fx(ctx: Ctx, Sc: Dictionary, n: Dictionary, o: Dictionary, x: float, y: float, hh: float, right: bool, t: float) -> void:
	var side = 1.0 if right else -1.0; var hy = y - hh * 0.86; var hx = x + side * hh * 0.03
	var rxk = o.get("rxk")
	ctx.save(); ctx.lineCap = "round"
	if o.pose == "phone" and rxk == null:
		var gx = x + side * hh * 0.14; var gy = y - hh * 0.66; var r = hh * 0.3; var ph = _n(n.get("ph"))
		var fl = 0.3 + 0.06 * sin(t * 3 + ph) + (0.15 if sin(t * 0.7 + ph) > 0.92 else 0.0)
		var g = ctx.createRadialGradient(gx, gy, 0, gx, gy, r); g.addColorStop(0, Color(150 / 255.0, 220 / 255.0, 1, fl)); g.addColorStop(1, Color(150 / 255.0, 220 / 255.0, 1, 0))
		ctx.fillStyle = g; ctx.beginPath(); ctx.arc(gx, gy, r, 0, TAU); ctx.fill()
	var goose = maxf(_n(n.get("goose")), 0.6 if o.face == "f" or o.face == "t" else 0.0)
	if goose > 0:
		ctx.strokeStyle = Color(1, 1, 1, minf(0.85, goose * 0.7)); ctx.lineWidth = 1.4
		for s in [-1.0, 1.0]:
			for i in 3:
				var bx = x + s * hh * (0.24 + 0.03 * sin(t * 20 + i)); var by = y - hh * (0.62 - i * 0.09)
				ctx.beginPath(); ctx.moveTo(bx, by)
				for j in range(1, 4): ctx.lineTo(bx + s * j * 3, by + (-3 if j % 2 else 3))
				ctx.stroke()
	var hair = _n(n.get("hair"))
	if hair > 0:
		var k = minf(1, hair); ctx.strokeStyle = Color(30 / 255.0, 24 / 255.0, 30 / 255.0, k); ctx.lineWidth = 2
		for i in range(-2, 3):
			var bx = hx + i * hh * 0.045; var by = hy - hh * 0.06
			ctx.beginPath(); ctx.moveTo(bx, by); ctx.quadraticCurveTo(bx + sin(t * 50 + i) * 2.5, by - hh * 0.07 * k, bx + i * 1.5, by - hh * 0.14 * k); ctx.stroke()
	var shock = _n(n.get("shock"))
	if shock > 0:
		var k = 1 - shock / 0.5; ctx.strokeStyle = Color(1, 236 / 255.0, 150 / 255.0, minf(1, shock * 3)); ctx.lineWidth = 2.2
		for i in 9:
			var a = -PI * 0.95 + i * PI * 0.95 / 8 - 0.05; var r0 = hh * (0.2 + k * 0.08); var r1 = r0 + hh * 0.1
			ctx.beginPath(); ctx.moveTo(hx + cos(a) * r0, hy + sin(a) * r0); ctx.lineTo(hx + cos(a) * r1, hy + sin(a) * r1); ctx.stroke()
	if rxk == "rational" or rxk == "numb":
		ctx.strokeStyle = Color(40 / 255.0, 40 / 255.0, 90 / 255.0, 0.75); ctx.lineWidth = 1.6
		for i in 3:
			var bx = hx - side * hh * 0.02 + (i - 1) * hh * 0.035
			ctx.beginPath(); ctx.moveTo(bx, hy - hh * 0.02); ctx.lineTo(bx, hy + hh * (0.06 + (0.02 if i == 1 else 0.0))); ctx.stroke()
		var rx = n.get("rx")
		var dx = hx - side * hh * 0.13; var dy = hy + hh * 0.02 + (minf(1, _n(rx.get("t"))) * hh * 0.05 if rx is Dictionary else 0.0)
		ctx.fillStyle = Color(160 / 255.0, 215 / 255.0, 1, 0.95); ctx.beginPath(); ctx.moveTo(dx, dy - 6); ctx.quadraticCurveTo(dx + 4.5, dy + 2, dx, dy + 3.5); ctx.quadraticCurveTo(dx - 4.5, dy + 2, dx, dy - 6); ctx.fill()
		var shrug = o.get("shrug", 0.0)
		if shrug > 0.2:
			ctx.strokeStyle = Color(1, 1, 1, shrug * 0.7); ctx.lineWidth = 1.5
			for s in [-1.0, 1.0]:
				ctx.beginPath()
				if s > 0: ctx.arc(x + s * hh * 0.26, y - hh * 0.62, 5, -1.2, 1.2)
				else: ctx.arc(x + s * hh * 0.26, y - hh * 0.62, 5, PI - 1.2, PI + 1.2)
				ctx.stroke()
	if o.pose == "tremble" or o.pose == "cower" or (o.jit > 0.5 and not o.get("run", false)):
		ctx.strokeStyle = Color(1, 200 / 255.0, 180 / 255.0, 0.55); ctx.lineWidth = 1.5
		for s in [-1.0, 1.0]:
			for i in 2:
				var r = hh * (0.3 + i * 0.06) + sin(t * 30) * 1.5
				ctx.beginPath()
				if s > 0: ctx.arc(x, y - hh * 0.45, r, -0.35, 0.35)
				else: ctx.arc(x, y - hh * 0.45, r, PI - 0.35, PI + 0.35)
				ctx.stroke()
	var daily = n.get("daily")
	if o.get("doze", false) and rxk == null and not (daily is Dictionary and _b(daily.get("forced")) and _n(daily.get("w")) > 0):
		ctx.font = "800 13px sans-serif"; ctx.textAlign = "center"
		for i in 3:
			var q = fmod(t * 0.45 + i / 3.0, 1.0); ctx.fillStyle = Color(220 / 255.0, 230 / 255.0, 1, 0.85 * sin(q * PI))
			ctx.fillText("Z", x + side * hh * (0.18 + q * 0.15), y - hh * (0.95 + q * 0.3))
	if o.get("run", false):
		ctx.strokeStyle = Color(1, 1, 1, 0.45); ctx.lineWidth = 2
		for i in 4:
			var ly = y - hh * (0.25 + i * 0.17); var lx = x - side * hh * (0.3 + fmod(t * 3 + i * 0.37, 1.0) * 0.15)
			ctx.beginPath(); ctx.moveTo(lx, ly); ctx.lineTo(lx - side * hh * 0.25, ly); ctx.stroke()
	if o.get("run", false) and n.get("bub") == null:
		var k = minf(1, _n(n.get("scream")) * 2) if _n(n.get("scream")) > 0 else 0.75
		var txt = J.str(DB.L("哎呀——！" if J.str(n.d.k) == "auntie" else "啊——！"))
		var fs = round(14 + hh * 0.05); var step = fs * 0.85; var w = step * txt.length()
		var W = _n(Sc.get("W"), 390)
		var x0 = x + hh * 0.3 if side > 0 else x - hh * 0.3 - w
		if x0 + w > W - 6: x0 = x - hh * 0.3 - w
		if x0 < 6: x0 = x + hh * 0.3
		ctx.font = "900 %dpx sans-serif" % int(fs); ctx.textAlign = "left"; ctx.lineWidth = 3.5; ctx.strokeStyle = Color(0, 0, 0, k); ctx.fillStyle = Color(1, 96 / 255.0, 80 / 255.0, k)
		for i in txt.length():
			var ch = txt[i]; var ox = x0 + i * step + (randf() - 0.5) * 3; var oy = y - hh * 0.5 + sin(t * 25 + i) * 2.5 - i * 1.5
			ctx.strokeText(ch, ox, oy); ctx.fillText(ch, ox, oy)
	ctx.restore()
