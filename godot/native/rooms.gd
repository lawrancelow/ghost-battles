# 原生改寫自 rooms.js（回陽間・二十三樓全景 OFFMAP：房間、站位、附身道具、電燈冷氣、小地圖）
# 座標表照原公式即場計；補丁照保留：鏡頭外唔畫（vis）、__nat_scSky、__nat_om（sc_fast.gd 原生畫）
extends RefCounted

const SH := 1024.0
const PXU := 1165.0
const REMAP := [[0.0, 1506.0, 0.0], [4458.0, 5964.0, 1616.0], [2560.0, 2982.0, 3472.0], [1506.0, 2560.0, 4242.0], [2982.0, 4458.0, 6152.0]]
const MT_K := 1.17
const WIN := [[368, 240, 792, 240], [4311, 200, 995, 216], [5296, 200, 746, 216], [6196, 208, 296, 280], [8617, 200, 985, 216]]
const SHORT := {"boss": "陳總", "meeting": "會議", "lobby": "大堂", "main": "工程", "pantry": "茶水", "wc": "洗手", "qa": "設計", "server": "機房", "rest": "休息"}
const DOTCH := {"ken": "K", "it": "晴", "mis": "美", "boss": "陳", "auntie": "娣", "guard": "伯", "daoshi": "道", "kol": "網"}

static var D := {}
static var ROOMS := []
static var RM := {}
static var SPOT := {}
static var A := {}
static var WW := 0.0
static var OX := 0.0
static var SC = null
static var st = null
static var PANO = null
static var CROP := {}
static var TC := {}

# ---------- 小工具 ----------
static func _g(n: String): return J.G.get(n)
static func m(o, f: String, a := []): return J.mc(o, f, a)
static func p(o, k: String, v) -> void: J.sp(o, k, v)
static func n_(v) -> float: return J.num(v)
static func s_(v) -> String: return J.str(v)
static func has_g(n: String) -> bool: return J.G.get(n) != null
static func Rp(v: float) -> float:
	for r in REMAP:
		if v >= r[0] and v <= r[1]: return r[2] + v - r[0]
	return v
static func Ru(u: float) -> float: return Rp(u * PXU) / PXU
static func px(v: float) -> float: return Rp(v) / PXU
static func npx(v: float) -> float: return v / PXU
static func py(v: float) -> float: return v / SH
static func M_(x: float) -> float: return Ru(OX + x)
static func MY(y: float) -> float: return 0.64 + (y - 0.5) * 0.75
static func room_at(x: float):
	for r in ROOMS:
		if x < n_(r.x1): return r
	return ROOMS[ROOMS.size() - 1]
static func ok(k: String) -> bool:
	var f = _g("sprOk"); return f != null and J.t(J.cl(f, null, [k]))
static func P(x: float, y: float) -> Array:
	var r = m(SC, "pt", [x, y]); return [n_(r[0]), n_(r[1])]
static func U(y: float) -> float: return n_(m(SC, "hh", [y])) * (64 / (64 * 1.08))
static func canvas(): return J.S_document_("createElement", ["canvas"])
static func nat_on() -> bool: return J.t(J.gp(SC, "_nat"))

static func pano():
	if PANO != null: return PANO
	if not ok("bg_office_pano"): return null
	var im = J.gp(_g("SPR"), "bg_office_pano"); var c = canvas(); p(c, "width", J.gp(im, "naturalWidth")); p(c, "height", J.gp(im, "naturalHeight"))
	var x = m(c, "getContext", ["2d"]); var ch = n_(J.gp(c, "height")); var cw = n_(J.gp(c, "width")); var k = ch / SH; m(x, "drawImage", [im, 0.0, 0.0])
	p(x, "globalCompositeOperation", "multiply"); p(x, "fillStyle", "rgb(118,110,170)")
	var g = m(x, "createLinearGradient", [0.0, ch * 0.62, 0.0, ch]); m(g, "addColorStop", [0.0, "rgb(255,255,255)"]); m(g, "addColorStop", [1.0, "rgb(160,152,186)"])
	p(x, "fillStyle", g); m(x, "fillRect", [0.0, ch * 0.62, cw, ch * 0.38])
	p(x, "globalCompositeOperation", "screen"); p(x, "globalAlpha", 0.45)
	for w in WIN: m(x, "drawImage", [im, w[0] * k, w[1] * k, w[2] * k, w[3] * k, w[0] * k, w[1] * k, w[2] * k, w[3] * k])
	PANO = c
	return c

static func crop(id: String, a, fill):
	if CROP.has(id): return CROP[id]
	var src = pano()
	if src == null: return null
	var sh_ = n_(J.gp(src, "height")); var k = sh_ / SH
	var a0 = n_(a[0]); var a1 = n_(a[1]); var a2 = n_(a[2]); var a3 = n_(a[3])
	var c = canvas(); p(c, "width", J.round(a2 * k)); p(c, "height", J.round(a3 * k))
	var cw = n_(J.gp(c, "width")); var chh = n_(J.gp(c, "height"))
	m(m(c, "getContext", ["2d"]), "drawImage", [src, Rp(a0) * k, a1 * k, a2 * k, a3 * k, 0.0, 0.0, cw, chh])
	var f = null
	if J.t(fill):
		f = canvas(); p(f, "width", cw); p(f, "height", chh); var fx = m(f, "getContext", ["2d"])
		var sctx = m(src, "getContext", ["2d"])
		var L = J.gp(m(sctx, "getImageData", [maxf(0.0, Rp(a0) * k - 2), a1 * k, 1.0, chh]), "data")
		var Rr = J.gp(m(sctx, "getImageData", [minf(n_(J.gp(src, "width")) - 1, (Rp(a0) + a2) * k + 2), a1 * k, 1.0, chh]), "data")
		for y in int(chh):
			var g = m(fx, "createLinearGradient", [0.0, 0.0, cw, 0.0])
			m(g, "addColorStop", [0.0, "rgb(%s,%s,%s)" % [s_(J.gp(L, y * 4.0)), s_(J.gp(L, y * 4.0 + 1)), s_(J.gp(L, y * 4.0 + 2))]])
			m(g, "addColorStop", [1.0, "rgb(%s,%s,%s)" % [s_(J.gp(Rr, y * 4.0)), s_(J.gp(Rr, y * 4.0 + 1)), s_(J.gp(Rr, y * 4.0 + 2))]])
			p(fx, "fillStyle", g); m(fx, "fillRect", [0.0, float(y), cw, 1.0])
	CROP[id] = {"c": c, "f": f}
	return CROP[id]

static func tint(k: String):
	if TC.has(k): return TC[k]
	if not ok(k): return null
	var im = J.gp(_g("SPR"), k); var c = canvas(); p(c, "width", J.gp(im, "naturalWidth")); p(c, "height", J.gp(im, "naturalHeight"))
	var x = m(c, "getContext", ["2d"]); m(x, "drawImage", [im, 0.0, 0.0]); p(x, "globalCompositeOperation", "source-atop"); p(x, "fillStyle", "rgba(26,18,58,.30)"); m(x, "fillRect", [0.0, 0.0, J.gp(c, "width"), J.gp(c, "height")])
	TC[k] = c
	return c

static func text(ctx, x: float, y: float, s: String, sz: float, a: float) -> void:
	if a <= 0.01: return
	m(ctx, "save"); p(ctx, "globalAlpha", n_(J.gp(ctx, "globalAlpha")) * minf(1.0, a)); p(ctx, "font", "900 " + s_(J.round(sz)) + "px sans-serif"); p(ctx, "textAlign", "center")
	p(ctx, "lineWidth", 3.0); p(ctx, "strokeStyle", "#1a1020"); m(ctx, "strokeText", [s, x, y]); p(ctx, "fillStyle", "#fff3d0"); m(ctx, "fillText", [s, x, y]); m(ctx, "restore")

static func rect(a) -> Array:
	var q1 = P(px(n_(a[0])), py(n_(a[1]))); var q2 = P(px(n_(a[0]) + n_(a[2])), py(n_(a[1]) + n_(a[3])))
	return [q1[0], q1[1], q2[0] - q1[0], q2[1] - q1[1]]

# ---------- 狀態 ----------
static func init(S) -> void:
	SC = S
	var spare = []; var i = 0
	for xy in A.spare:
		spare.append({"x": n_(xy[0]), "y": n_(xy[1]), "ox": 0.0, "oz": 0.0, "vx": 0.0, "vz": 0.0, "sw": 0.4 if i else -0.3, "vs": 0.0}); i += 1
	st = {"t": 0.0, "micro": 0.0, "fridge": 0.0, "vend": 0.0, "can": null, "kettle": 0.0, "tv": 0.0, "speaker": 0.0, "chairs": 0.0, "golf": null, "bchair": 0.0, "trophy": null, "lights": null, "ac": null, "spare": spare}

static func tick(dt: float) -> void:
	if st == null: return
	st.t += dt
	for k in ["micro", "fridge", "vend", "kettle", "tv", "speaker", "chairs", "bchair"]: st[k] = maxf(0.0, st[k] - dt)
	if st.lights != null:
		st.lights.t += dt
		if st.lights.t > 3.6: st.lights = null
	if st.ac != null:
		st.ac.t += dt
		if st.ac.t > 2.6: st.ac = null
	if st.can != null:
		var c = st.can; c.t += dt
		if c.t > 0.35: c.x += c.vx * dt; c.vx *= exp(-dt * 0.9); c.rot += c.vx * dt * 60
		if c.t > 9: st.can = null
	if st.golf != null:
		var g = st.golf; g.t += dt; var k = minf(1.0, g.t / 2.4); var e = 1 - pow(1 - k, 2.2)
		g.x = g.x0 + (g.x1 - g.x0) * e; g.y = g.y0 + (g.y1 - g.y0) * e; g.rot += dt * 18 * (1 - k)
		if g.t > 9: st.golf = null
	if st.trophy != null:
		var T = st.trophy; T.t += dt
		if T.t > 0.35:
			T.vy += 2.4 * dt; T.y += T.vy * dt; T.rot += T.vr * dt
			if T.y >= T.floor:
				T.y = T.floor
				if T.b < 1 and T.vy > 0.3: T.vy = -T.vy * 0.25; T.b += 1; T.land = T.t
				else: T.vy = 0.0; T.vr = 0.0; T.rest += dt; T.rot += (PI / 2 - T.rot) * minf(1.0, dt * 8)
		if T.rest > 10: st.trophy = null; st["trophyBack"] = 0.6
	st["trophyBack"] = maxf(0.0, (st.get("trophyBack") if st.get("trophyBack") != null else 0.0) - dt)
	for c in st.spare:
		if st.chairs > 0 and c.get("tgt") != null:
			var tg = c.tgt; var dx = n_(J.gp(tg, "x")) - (c.x + c.ox); var dz = n_(J.gp(tg, "y")) + c.dy - (c.y + c.oz); var d = J.hypot_([dx, dz])
			if d > 0.09: c.vx += dx / d * 0.5 * dt; c.vz += dz / d * 0.3 * dt
			c.vs = (1.0 if c.vs >= 0 else -1.0) * maxf(absf(c.vs), 5.0)
		c.ox += c.vx * dt; c.oz += c.vz * dt; c.vx *= exp(-dt * 1.6); c.vz *= exp(-dt * 1.6); c.sw += c.vs * dt; c.vs *= exp(-dt * 1.2)
		if st.chairs <= 0:
			c.ox += -c.ox * dt * 0.3; c.oz += -c.oz * dt * 0.3
			if absf(c.vs) < 0.6: c.sw += (J.round(c.sw / (2 * PI)) * 2 * PI + (-0.3 if is_same(c, st.spare[0]) else 0.4) - c.sw) * minf(1.0, dt * 2)

static func on_prop(k: String, n, room) -> void:
	if st == null: return
	if k == "micro": st.micro = 2.6
	if k == "fridge": st.fridge = 3.2
	if k == "vend":
		st.vend = 2.2; var s = A.vendSlot
		st.can = {"x": px(n_(s[0]) + n_(s[2]) * 0.4), "y": 0.645, "t": 0.0, "vx": -(0.12 + randf() * 0.05), "rot": 0.0}
	if k == "kettle": st.kettle = 3.0
	if k == "tv": st.tv = 2.8
	if k == "speaker": st.speaker = 3.0
	if k == "chairs":
		st.chairs = 3.2; var i = 0
		for c in st.spare:
			c["tgt"] = n if J.t(n) else {"x": px(5000), "y": 0.78}; c["dy"] = 0.05 if i else -0.03; c["vs"] = 6.0 if i else -6.0; i += 1
	if k == "golf":
		var x0 = px(120); var y0 = 0.69
		var x1 = (n_(J.gp(n, "x")) + (-0.08 if n_(J.gp(n, "x")) > x0 else 0.08)) if J.t(n) else px(700)
		var y1 = n_(J.gp(n, "y")) + 0.01 if J.t(n) else 0.75
		st.golf = {"x0": x0, "y0": y0, "x1": x1, "y1": y1, "x": x0, "y": y0, "t": 0.0, "rot": 0.0}
	if k == "bchair": st.bchair = 2.8
	if k == "trophy":
		var a = A.trophy
		st.trophy = {"x": px(n_(a[0]) + n_(a[2]) / 2), "y": py(n_(a[1]) + n_(a[3])), "floor": 0.655, "vy": -0.2, "vr": 3.5, "rot": 0.0, "t": 0.0, "b": 0.0, "rest": 0.0, "land": -1.0}
	if k == "lights": st.lights = {"t": 0.0, "room": room if J.t(room) else "main"}
	if k == "ac": st.ac = {"t": 0.0, "room": room if J.t(room) else "main"}

# ---------- 畫：後牆 ----------
static func draw_back(ctx, t: float) -> void:
	var c = pano(); var b = m(SC, "bgScale"); var bs = n_(J.gp(b, "s")); var boy = n_(J.gp(b, "oy")); var W = n_(J.gp(SC, "W"))
	if c != null:
		var ch = n_(J.gp(c, "height")); var k = ch / SH; var sx = n_(J.gp(SC, "camX")) * PXU * k; var sw = W * k / bs
		m(ctx, "drawImage", [c, sx, 0.0, sw, ch, 0.0, boy, W, n_(J.gp(b, "ih")) * bs])
		if boy > 0 and nat_on() and has_g("__nat_scSky"): J.cl(_g("__nat_scSky"), null, [ctx, SC, boy, bs])
		elif boy > 0:
			var y0 = boy; var slab = maxf(10.0, bs * 34)
			var g = m(ctx, "createLinearGradient", [0.0, 0.0, 0.0, y0 - slab]); m(g, "addColorStop", [0.0, "#0b0a1c"]); m(g, "addColorStop", [1.0, "#1d1838"]); p(ctx, "fillStyle", g); m(ctx, "fillRect", [0.0, 0.0, W, y0 - slab + 1])
			m(ctx, "save"); var px0 = n_(J.gp(SC, "camX")) * 140
			for i in 26:
				var bx = fmod(fmod(i * 97 - px0, W + 120) + W + 120, W + 120) - 60; var bh = (0.35 + float((i * 53) % 10) / 16) * (y0 - slab); var bw = 26.0 + (i * 31) % 30
				p(ctx, "fillStyle", "rgba(30,26,58,.9)"); m(ctx, "fillRect", [bx, y0 - slab - bh, bw, bh]); p(ctx, "fillStyle", "rgba(255,214,140,.35)")
				for w in 6:
					if (i * 7 + w * 3) % 5 == 0: m(ctx, "fillRect", [bx + 4 + (w % 3) * 7, y0 - slab - bh + 6 + floor(w / 3.0) * 10, 3.0, 4.0])
			m(ctx, "restore")
			var sg = m(ctx, "createLinearGradient", [0.0, y0 - slab, 0.0, y0]); m(sg, "addColorStop", [0.0, "#5a5068"]); m(sg, "addColorStop", [0.25, "#3c3448"]); m(sg, "addColorStop", [1.0, "#2a2434"]); p(ctx, "fillStyle", sg); m(ctx, "fillRect", [0.0, y0 - slab, W, slab])
			p(ctx, "fillStyle", "rgba(255,255,255,.12)"); m(ctx, "fillRect", [0.0, y0 - slab, W, 1.5]); p(ctx, "fillStyle", "rgba(0,0,0,.45)"); m(ctx, "fillRect", [0.0, y0 - 2, W, 2.0])
	if st == null: return
	if st.micro > 0:
		var r = rect(A.microWin); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]; var on = sin(t * 40) > -0.6
		m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter"); p(ctx, "fillStyle", "rgba(255,200,110," + s_(0.75 if on else 0.35) + ")"); m(ctx, "fillRect", [x, y, w, h])
		p(ctx, "strokeStyle", "rgba(255,240,200,.7)"); p(ctx, "lineWidth", 1.5); m(ctx, "beginPath"); m(ctx, "ellipse", [x + w / 2, y + h * 0.75, w * 0.3, h * 0.1, 0.0, 0.0, PI * 2]); m(ctx, "stroke")
		var a = t * 5; m(ctx, "beginPath"); m(ctx, "moveTo", [x + w / 2, y + h * 0.75]); m(ctx, "lineTo", [x + w / 2 + cos(a) * w * 0.28, y + h * 0.75 + sin(a) * h * 0.09]); m(ctx, "stroke")
		var g = m(ctx, "createRadialGradient", [x + w / 2, y + h / 2, 0.0, x + w / 2, y + h / 2, w * 1.3]); m(g, "addColorStop", [0.0, "rgba(255,190,100,.35)"]); m(g, "addColorStop", [1.0, "rgba(255,190,100,0)"]); p(ctx, "fillStyle", g); m(ctx, "fillRect", [x - w, y - w, w * 3, h + w * 2]); m(ctx, "restore")
		if st.micro < 0.7: text(ctx, x + w / 2, y - h * 0.3, "叮！", h * 0.75, st.micro / 0.7)
		else: text(ctx, x + w / 2, y - h * 0.3, "嗡——", h * 0.5, 0.8)
	if true:
		var d = crop("fdoor", A.fridgeDoor, null); var r = rect(A.fridgeDoor); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]
		var o = minf(minf(1.0, (3.2 - st.fridge) * 3), st.fridge * 1.5) if st.fridge > 0 else 0.0
		if o > 0.01 and d != null:
			m(ctx, "save"); var g = m(ctx, "createLinearGradient", [x, y, x, y + h]); m(g, "addColorStop", [0.0, "#eaf4ff"]); m(g, "addColorStop", [1.0, "#bcd2e8"]); p(ctx, "fillStyle", g); m(ctx, "fillRect", [x, y, w, h]); p(ctx, "strokeStyle", "rgba(120,140,170,.8)"); p(ctx, "lineWidth", 2.0)
			for i in range(1, 3): m(ctx, "beginPath"); m(ctx, "moveTo", [x + 4, y + h * i / 3.0]); m(ctx, "lineTo", [x + w - 4, y + h * i / 3.0]); m(ctx, "stroke")
			p(ctx, "fillStyle", "#d9c06a"); m(ctx, "fillRect", [x + w * 0.2, y + h / 3 - h * 0.12, w * 0.12, h * 0.12]); p(ctx, "fillStyle", "#e88"); m(ctx, "fillRect", [x + w * 0.55, y + h * 2 / 3 - h * 0.1, w * 0.2, h * 0.1])
			var sw = cos(o * PI * 0.62); m(ctx, "translate", [x + w, y]); m(ctx, "scale", [-1.0, 1.0]); m(ctx, "drawImage", [d.c, 0.0, 0.0, w * maxf(0.08, sw), h]); m(ctx, "restore")
			m(ctx, "save"); p(ctx, "globalAlpha", 0.55 * o)
			for i in 6:
				var q = fmod(t * 0.5 + i / 6.0, 1.0); var fx = x + w * (0.2 + 0.12 * i); var fy = y + h + q * h * 1.4; var rr = w * (0.18 + q * 0.35)
				var gg = m(ctx, "createRadialGradient", [fx, fy, 0.0, fx, fy, rr]); m(gg, "addColorStop", [0.0, "rgba(225,240,255,.6)"]); m(gg, "addColorStop", [1.0, "rgba(225,240,255,0)"]); p(ctx, "fillStyle", gg); m(ctx, "beginPath"); m(ctx, "arc", [fx, fy, rr, 0.0, PI * 2]); m(ctx, "fill")
			m(ctx, "restore")
	if st.vend > 0:
		var r = rect(A.vendGlass); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]; var on = sin(t * 33) + sin(t * 19) > 0.2
		m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter" if on else "source-over"); p(ctx, "fillStyle", "rgba(200,240,255,.35)" if on else "rgba(5,4,15,.6)"); m(ctx, "fillRect", [x, y, w, h]); m(ctx, "restore")
		var r2 = rect(A.vendSlot)
		if st.vend > 1.6: text(ctx, r2[0] + r2[2] / 2, r2[1] - r2[3] * 0.4, "哐咚！", r2[3] * 1.1, (st.vend - 1.6) / 0.6)
	if st.kettle > 0:
		var r = rect(A.kettle); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]; var e = minf(minf(1.0, st.kettle), (3 - st.kettle) * 2)
		m(ctx, "save"); p(ctx, "lineCap", "round")
		for i in 5:
			var q = fmod(t * 0.8 + i / 5.0, 1.0); var sx = x + w * 0.78 + sin(t * 3 + i) * w * 0.15; var sy = y + h * 0.05 - q * h * 2.4
			p(ctx, "strokeStyle", "rgba(245,245,250," + s_(0.6 * e * (1 - q)) + ")"); p(ctx, "lineWidth", w * 0.12 * (1 + q)); m(ctx, "beginPath"); m(ctx, "moveTo", [sx, sy + h * 0.2]); m(ctx, "quadraticCurveTo", [sx + w * 0.3 * sin(t * 2 + i), sy, sx, sy - h * 0.2]); m(ctx, "stroke")
		p(ctx, "strokeStyle", "rgba(255,255,255," + s_(0.5 * e) + ")"); p(ctx, "lineWidth", 1.5)
		for s in [-1, 1]: m(ctx, "beginPath"); m(ctx, "arc", [x + w / 2, y + h / 2, w * 0.7 + sin(t * 30) * 2, -0.4 if s > 0 else PI - 0.4, 0.4 if s > 0 else PI + 0.4]); m(ctx, "stroke")
		m(ctx, "restore")
		text(ctx, x + w / 2 + sin(t * 25) * 2, y - h * 1.6, "嗚——", h * 0.55, e)
	if st.tv > 0:
		var r = rect(A.tv); var x0 = r[0]; var y0 = r[1]; var w0 = r[2]; var h0 = r[3]; var x = x0 + w0 * 0.035; var y = y0 + h0 * 0.06; var w = w0 * 0.93; var h = h0 * 0.85
		m(ctx, "save"); m(ctx, "beginPath"); m(ctx, "rect", [x, y, w, h]); m(ctx, "clip"); p(ctx, "fillStyle", "rgba(70,70,90,.92)"); m(ctx, "fillRect", [x, y, w, h])
		for i in 260:
			var v = float(int(randf() * 255)); p(ctx, "fillStyle", "rgba(%s,%s,%s,.9)" % [s_(v), s_(v), s_(v + 10)])
			var rx = x + randf() * w; var ry = y + randf() * h; var rw = 2 + randf() * 3
			m(ctx, "fillRect", [rx, ry, rw, 1.5])
		for i in 4: p(ctx, "fillStyle", "rgba(255,255,255,.25)"); m(ctx, "fillRect", [x, y + fmod(t * 0.7 + i / 4.0, 1.0) * h, w, 2.0])
		var face = st.tv < 1.6 and st.tv > 0.6 and sin(t * 17) > -0.2
		var ART = _g("ART")
		if face and ART != null and J.t(J.gp(ART, "portrait")):
			var pc = m(ART, "portrait", ["afu", 96.0, {"tamed": true}]); var sz = h * 0.9; p(ctx, "globalAlpha", 0.55); p(ctx, "globalCompositeOperation", "luminosity")
			m(ctx, "drawImage", [pc, x + w / 2 - sz / 2 + (randf() - 0.5) * 4, y + h * 0.05, sz, sz])
		m(ctx, "restore"); m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter")
		var g = m(ctx, "createRadialGradient", [x + w / 2, y + h / 2, 0.0, x + w / 2, y + h / 2, w * 0.8]); m(g, "addColorStop", [0.0, "rgba(200,210,255,.25)"]); m(g, "addColorStop", [1.0, "rgba(200,210,255,0)"]); p(ctx, "fillStyle", g); m(ctx, "fillRect", [x - w * 0.3, y - h * 0.3, w * 1.6, h * 1.8]); m(ctx, "restore")
		text(ctx, x + w * 0.85, y - h * 0.08, "沙沙沙", h * 0.14, minf(1.0, st.tv))
	if st.speaker > 0:
		var r = rect(A.speaker); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]; var e = minf(minf(1.0, st.speaker), (3 - st.speaker) * 3); var br = 0.5 + 0.5 * sin(t * 2.6)
		m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter")
		for i in 3:
			var q = fmod(t * 0.6 + i / 3.0, 1.0); p(ctx, "strokeStyle", "rgba(140,255,170," + s_(0.6 * e * (1 - q)) + ")"); p(ctx, "lineWidth", 2.0); m(ctx, "beginPath"); m(ctx, "ellipse", [x + w / 2, y + h * 0.4, w * (0.3 + q * 0.9), h * (0.3 + q * 0.6), 0.0, 0.0, PI * 2]); m(ctx, "stroke")
		p(ctx, "fillStyle", "rgba(140,255,170," + s_(0.8 * e) + ")"); m(ctx, "beginPath"); m(ctx, "arc", [x + w / 2, y + h * 0.35, 3.0, 0.0, PI * 2]); m(ctx, "fill"); m(ctx, "restore")
		text(ctx, x + w / 2, y - h * (1.2 + br * 0.4), "呼……" if br > 0.5 else "……吸", h * 0.75, e * (0.5 + 0.5 * br))
	if st.bchair > 0:
		var C = crop("bchair", A.chair, true); var r = rect(A.chair); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]
		if C != null:
			var e = minf(minf(1.0, st.bchair), (2.8 - st.bchair) * 3); var a = (2.8 - st.bchair) * 7 * e; var scs = cos(a)
			m(ctx, "drawImage", [C.f, x, y, w, h]); m(ctx, "save"); m(ctx, "translate", [x + w / 2, y + h]); m(ctx, "scale", [maxf(0.25, absf(scs)), 1.0])
			if scs < 0: p(ctx, "filter", "brightness(0.6)")
			m(ctx, "drawImage", [C.c, -w / 2, -h, w, h]); m(ctx, "restore")
			text(ctx, x + w / 2, y - h * 0.15, "吱——", h * 0.32, e)
	if st.trophy != null or st.get("trophyBack", 0.0) > 0:
		var C = crop("trophy", A.trophy, true); var r = rect(A.trophy)
		if C != null:
			m(ctx, "drawImage", [C.f, r[0], r[1], r[2], r[3]])
			if st.trophy == null and st.trophyBack > 0:
				m(ctx, "save"); p(ctx, "globalAlpha", 1 - st.trophyBack / 0.6); m(ctx, "drawImage", [C.c, r[0], r[1], r[2], r[3]]); m(ctx, "restore")

# ---------- 地上嘅嘢（同人排前後）----------
static func vis(x: float) -> bool: return not nat_on() or J.t(m(SC, "onScreen", [x, 0.6]))
static func nat_om(args: Array) -> Array:   # 原生畫咗就 [結果]，否則 []
	if nat_on() and has_g("__nat_om"): return [J.cl(_g("__nat_om"), null, args)]
	return []

static func drawables():
	var out = []
	if st == null: return out
	if st.can != null:
		out.append([0.645, func(_t, a):
			var ctx = a[0]; var c = st.can; var q = P(c.x, c.y); var x = q[0]; var y = q[1]; var u = U(c.y); var r = u * 0.035; var hgt = u * 0.075; var drop = (1 - c.t / 0.35) * u * 0.08 if c.t < 0.35 else 0.0
			m(ctx, "save"); m(ctx, "translate", [x, y - r - drop]); m(ctx, "rotate", [c.rot if c.t > 0.35 else 0.0]); p(ctx, "fillStyle", "#d23a3a"); m(ctx, "fillRect", [-hgt / 2, -r, hgt, r * 2]); p(ctx, "fillStyle", "#eee"); m(ctx, "fillRect", [-hgt * 0.15, -r, hgt * 0.3, r * 2])
			p(ctx, "fillStyle", "#aaa"); m(ctx, "fillRect", [-hgt / 2 - 1, -r, 2.0, r * 2]); m(ctx, "fillRect", [hgt / 2 - 1, -r, 2.0, r * 2]); m(ctx, "restore")
			if c.t > 0.3 and c.t < 1.2: text(ctx, x, y - u * 0.18, "咕碌咕碌", u * 0.08, 1 - (c.t - 0.3) / 0.9)
			return null])
	if st.golf != null:
		out.append([st.golf.y, func(_t, a):
			var ctx = a[0]; var g = st.golf; var q = P(g.x, g.y); var x = q[0]; var y = q[1]; var u = U(g.y); var r = u * 0.022
			m(ctx, "save"); p(ctx, "fillStyle", "rgba(0,0,0,.3)"); m(ctx, "beginPath"); m(ctx, "ellipse", [x, y, r * 1.3, r * 0.4, 0.0, 0.0, PI * 2]); m(ctx, "fill")
			p(ctx, "fillStyle", "#fafafa"); p(ctx, "strokeStyle", "#555"); p(ctx, "lineWidth", 1.0); m(ctx, "beginPath"); m(ctx, "arc", [x, y - r, r, 0.0, PI * 2]); m(ctx, "fill"); m(ctx, "stroke")
			p(ctx, "fillStyle", "#bbb"); m(ctx, "beginPath"); m(ctx, "arc", [x + cos(g.rot) * r * 0.5, y - r + sin(g.rot) * r * 0.3, r * 0.18, 0.0, PI * 2]); m(ctx, "fill"); m(ctx, "restore")
			if g.t < 2.4:
				m(ctx, "save"); p(ctx, "strokeStyle", "rgba(255,255,255,.35)"); p(ctx, "lineWidth", 1.5); var sg = sign(g.x1 - g.x0)
				for i in range(1, 4): m(ctx, "beginPath"); m(ctx, "moveTo", [x - sg * u * (0.05 + i * 0.05), y - r - i * 2 + 4]); m(ctx, "lineTo", [x - sg * u * (0.1 + i * 0.05), y - r - i * 2 + 4]); m(ctx, "stroke")
				m(ctx, "restore"); text(ctx, x, y - u * 0.12, "咕碌——", u * 0.07, 1 - g.t / 2.4)
			return null])
	if st.trophy != null:
		out.append([0.656 if st.trophy.y > 0.64 else 0.6, func(_t, a):
			var ctx = a[0]; var T = st.trophy; var C = crop("trophy", A.trophy, true)
			if C == null: return null
			var q = P(T.x, T.y); var x = q[0]; var y = q[1]; var w = rect(A.trophy)[2]; var h = rect(A.trophy)[3]
			m(ctx, "save"); m(ctx, "translate", [x, y - (w * 0.5 if T.y >= T.floor else h * 0.5)]); m(ctx, "rotate", [T.rot]); m(ctx, "drawImage", [C.c, -w / 2, -h / 2, w, h]); m(ctx, "restore")
			if T.land >= 0 and T.t - T.land < 0.6: text(ctx, x, y - h * 0.9, "哐啷！", h * 0.35, 1 - (T.t - T.land) / 0.6)
			return null])
	var tb = tint("of_meet_table")
	if tb != null and vis(n_(SPOT.meetTable[0])):
		var mx = n_(SPOT.meetTable[0]); var my = n_(SPOT.meetTable[1])
		out.append([my, func(_t, a):
			var ctx = a[0]; var nr = nat_om(["meet", ctx, SC, tb, mx, my, SH, MT_K])
			if not nr.is_empty(): return nr[0]
			var b = m(SC, "bgScale"); var k = n_(J.gp(b, "ih")) * n_(J.gp(b, "s")) / SH * MT_K; var w = 869 * k; var h = 192 * k; var q = P(mx, my); var x = q[0]; var y = q[1]
			m(ctx, "save"); p(ctx, "fillStyle", "rgba(6,4,18,.32)"); m(ctx, "beginPath"); m(ctx, "ellipse", [x, y - h * 0.03, w * 0.52, h * 0.14, 0.0, 0.0, PI * 2]); m(ctx, "fill"); m(ctx, "drawImage", [tb, x - w / 2, y - h, w, h]); m(ctx, "restore")
			return null])
	if true:
		var rc = tint("of_reception"); var ch = tint("of_chair_front"); var mon = tint("op_mon_side_on"); var rx = n_(SPOT.reception[0]); var ry = n_(SPOT.reception[1])
		var geo = func():
			var dy = ry + 0.02; var u = U(dy); var h = 0.62 * u; var w = h * (n_(J.gp(rc, "width")) / n_(J.gp(rc, "height")) if rc != null else 2.26); var mx = P(rx, ry)[0]; var y = P(rx, dy)[1]; var wa = w * 400 / 578
			return {"dy": dy, "u": u, "h": h, "w": w, "wa": wa, "x0": mx - wa * 0.36, "y": y}
		if ch != null and vis(rx):
			out.append([ry - 0.006, func(_t, a):
				var ctx = a[0]; var nr = nat_om(["rchair", ctx, SC, ch, rx, ry])
				if not nr.is_empty(): return nr[0]
				var u = U(ry); var h = 0.6 * u; var w = h * n_(J.gp(ch, "width")) / n_(J.gp(ch, "height")); var q = P(rx, ry - 0.006)
				m(ctx, "save"); m(ctx, "translate", [q[0] - w * 0.18, q[1]]); m(ctx, "scale", [-1.0, 1.0]); m(ctx, "drawImage", [ch, -w / 2, -h, w, h]); m(ctx, "restore")
				return null])
		if rc != null and vis(rx):
			out.append([ry + 0.02, func(_t, a):
				var ctx = a[0]; var nr = nat_om(["rdesk", ctx, SC, rc, mon, rx, ry])
				if not nr.is_empty(): return nr[0]
				var g = geo.call()
				m(ctx, "save"); p(ctx, "fillStyle", "rgba(6,4,18,.38)"); m(ctx, "beginPath"); m(ctx, "ellipse", [g.x0 + g.w / 2, g.y - g.h * 0.01, g.w * 0.54, g.h * 0.09, 0.0, 0.0, PI * 2]); m(ctx, "fill")
				if mon != null:
					var mh = g.h * 0.62; var mw = mh * n_(J.gp(mon, "width")) / n_(J.gp(mon, "height")); var top = g.y - g.h * (170.0 / 256)
					m(ctx, "save"); m(ctx, "translate", [g.x0 + g.wa * 0.80, top + mh * 0.05]); m(ctx, "scale", [-1.0, 1.0]); m(ctx, "drawImage", [mon, -mw / 2, -mh, mw, mh]); m(ctx, "restore")
				m(ctx, "drawImage", [rc, g.x0, g.y - g.h, g.w, g.h])
				var bw = (g.w - g.wa) * 0.82; var bh = g.h * 0.11; var bx = g.x0 + g.wa + (g.w - g.wa - bw) / 2 - g.w * 0.005; var by = g.y - g.h - bh * 0.92
				p(ctx, "fillStyle", "#2a1a14"); m(ctx, "fillRect", [bx - 1.5, by - 1.5, bw + 3, bh + 3]); p(ctx, "fillStyle", "#d4b062"); m(ctx, "fillRect", [bx, by, bw, bh])
				p(ctx, "fillStyle", "#2a1a10"); p(ctx, "font", "900 " + s_(J.round(bh * 0.7)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif"); p(ctx, "textAlign", "center"); p(ctx, "textBaseline", "middle"); m(ctx, "fillText", ["接待處", bx + bw / 2, by + bh * 0.55]); m(ctx, "restore")
				return null])
	var chb = tint("of_chair_back")
	if chb != null:
		for c in st.spare:
			var y = c.y + c.oz
			if not vis(c.x + c.ox): continue
			out.append([y, func(_t, a):
				var ctx = a[0]
				if nat_on() and has_g("__nat_om"): return J.cl(_g("__nat_om"), null, ["spare", ctx, SC, chb, c, st.chairs])
				var q = P(c.x + c.ox, y); var x = q[0]; var yy = q[1]; var u = U(y); var h = 0.62 * u; var w = h * n_(J.gp(chb, "width")) / n_(J.gp(chb, "height")); var s = cos(c.sw)
				m(ctx, "save"); p(ctx, "fillStyle", "rgba(6,4,18,.3)"); m(ctx, "beginPath"); m(ctx, "ellipse", [x, yy, w * 0.42, w * 0.1, 0.0, 0.0, PI * 2]); m(ctx, "fill"); m(ctx, "translate", [x, yy]); m(ctx, "scale", [maxf(0.35, absf(s)) * (-1.0 if s < 0 else 1.0), 1.0]); m(ctx, "drawImage", [chb, -w / 2, -h, w, h]); m(ctx, "restore")
				if st.chairs > 0: text(ctx, x, yy - h * 1.05, "吱——", u * 0.1, minf(1.0, st.chairs))
				return null])
	return out

# ---------- 電燈、冷氣 ----------
static func room_screen(r) -> Array:
	var x1 = P(n_(r.x0), 0)[0]; var x2 = P(n_(r.x1), 0)[0]; return [maxf(0.0, x1), minf(n_(J.gp(SC, "W")), x2)]

static func draw_over(ctx, t: float) -> void:
	if st == null: return
	var H = n_(J.gp(SC, "H"))
	if st.lights != null:
		var L = st.lights; var r = RM[J.str(L.room)]; var ab = room_screen(r); var a = ab[0]; var b = ab[1]
		if b > a:
			var q = L.t; var fl = 0.55 if sin(q * 37) + sin(q * 23) > 0.6 else 0.08; var r0 = P(n_(r.x0), 0)[0]; var r1 = P(n_(r.x1), 0)[0]; var bw = (r1 - r0) / 3
			m(ctx, "save"); m(ctx, "beginPath"); m(ctx, "rect", [a, 0.0, b - a, H]); m(ctx, "clip")
			for i in 3:
				var t0 = 0.9 + i * 0.3
				var v = fl if q < 0.9 else ((fl if q < t0 else minf(0.74, 0.2 + (q - t0) * 3)) if q < 2.7 else 0.0)
				if v > 0: p(ctx, "fillStyle", "rgba(4,3,14," + s_(v) + ")"); m(ctx, "fillRect", [r0 + bw * i - 1, 0.0, bw + 2, H])
			if q >= 2.7 and q < 3.1: p(ctx, "fillStyle", "rgba(255,250,230," + s_(0.35 * (1 - (q - 2.7) / 0.4)) + ")"); m(ctx, "fillRect", [a, 0.0, b - a, H])
			m(ctx, "restore")
			if q > 0.95 and q < 2.6:
				var i2 = minf(2.0, floor((q - 0.9) / 0.3))
				text(ctx, maxf(a + 20, minf(b - 20, r0 + bw * (i2 + 0.5))), H * 0.16, "啪", H * 0.035, 1 - fmod(q - 0.9, 0.3) / 0.3)
	if st.ac != null:
		var A0 = st.ac; var r = RM[J.str(A0.room)]; var ab = room_screen(r); var a = ab[0]; var b = ab[1]
		if b > a:
			var e = minf(minf(1.0, A0.t * 3), (2.6 - A0.t) * 3); var vq = P(npx(n_(r.vent[0])), py(n_(r.vent[1]))); var vx = vq[0]; var vy = vq[1]
			m(ctx, "save"); m(ctx, "beginPath"); m(ctx, "rect", [a, 0.0, b - a, H]); m(ctx, "clip"); p(ctx, "fillStyle", "rgba(150,200,255," + s_(0.14 * e) + ")"); m(ctx, "fillRect", [a, 0.0, b - a, H]); p(ctx, "lineCap", "round")
			for i in 9:
				var q = fmod(t * 0.9 + i / 9.0, 1.0); var sx = vx + (i - 4) * 9; var ex = sx + (i - 4) * 14 * q - 10 * q; var ey = vy + q * H * 0.5
				p(ctx, "strokeStyle", "rgba(210,235,255," + s_(0.5 * e * (1 - q)) + ")"); p(ctx, "lineWidth", 2.2 * (1 - q * 0.5)); m(ctx, "beginPath"); m(ctx, "moveTo", [sx, vy]); m(ctx, "quadraticCurveTo", [sx + sin(t * 6 + i) * 8, (vy + ey) / 2, ex, ey]); m(ctx, "stroke")
			m(ctx, "restore")

# ---------- 小地圖 ----------
static func map_html() -> String:
	var parts = []
	for r in ROOMS:
		parts.append("<div class=\"scm-r\" data-r=\"%s\" style=\"left:%s%%;width:%s%%\"><span>%s</span></div>" % [s_(r.k), s_(n_(r.x0) / WW * 100), s_((n_(r.x1) - n_(r.x0)) / WW * 100), s_(SHORT.get(J.str(r.k), r.name))])
	return "<div id=\"sc-map\">%s<i id=\"scm-view\"></i><div id=\"scm-dots\"></div></div><button id=\"sc-follow\" class=\"\" title=\"鏡頭跟住點中嘅人（預設關：唔好自己捲走個畫面）\">跟</button>" % "".join(parts)

static func doc(f: String, a: Array): return J.S_document_(f, a)
static func map_tick(S) -> void:
	var box = doc("getElementById", ["scm-dots"])
	if not J.t(box): return
	var v = doc("getElementById", ["scm-view"]); var vs = J.gp(v, "style")
	p(vs, "left", s_(n_(J.gp(S, "camX")) / WW * 100) + "%"); p(vs, "width", s_(n_(m(S, "viewW")) / WW * 100) + "%")
	var sel0 = J.gp(S, "sel"); var sel = sel0 if (J.t(sel0) and not J.t(J.gp(sel0, "gone")) and not J.t(J.gp(sel0, "out"))) else null
	var wit = J.new_("Set", [m(S, "witnesses", [sel])]) if J.t(sel) else J.new_("Set", [])
	var cr = m(S, "camRoom")
	for e in J.iter(doc("querySelectorAll", ["#sc-map .scm-r"])): m(J.gp(e, "classList"), "toggle", ["cur", J.seq(J.gp(J.gp(e, "dataset"), "r"), J.gp(cr, "k"))])
	var want = []
	for n in J.iter(J.gp(S, "npcs")):
		if not J.t(J.gp(n, "gone")) and not J.t(J.gp(n, "out")): want.append(n)
	if not J.t(J.gp(S, "_dots")): p(S, "_dots", {})
	var DT = J.gp(S, "_dots")
	for n in want:
		var nd = J.gp(n, "d"); var key = J.gp(nd, "k"); var d = J.gp(DT, key)
		if not J.t(d):
			d = doc("createElement", ["b"]); p(DT, key, d)
			var ch = DOTCH.get(J.str(key)); p(d, "textContent", ch if ch != null else J.mc(J.gp(nd, "name"), "charAt", [0.0])); m(box, "appendChild", [d])
		var f = n_(J.gp(n, "fear"))
		var col = "#c070ff" if J.t(J.gp(n, "fleeing")) else ("#ff5a4a" if f >= 50 else ("#ffb84a" if f >= 25 else ("#8ab0d0" if J.t(J.gp(nd, "guard")) else ("#ffd36a" if J.t(J.gp(nd, "daoshi")) else "#7fd6a0"))))
		var sm = maxf(0.6, minf(WW - 0.06, n_(J.gp(n, "x")))) / WW * 100
		var ds = J.gp(d, "style"); p(ds, "left", s_(sm) + "%"); p(ds, "background", col)
		p(d, "className", ("sel" if J.seq(n, sel) else ("wit" if J.t(m(wit, "has", [n])) else "")) + (" walk" if J.seq(J.gp(n, "act"), "walk") else ""))
		p(ds, "display", ""); p(d, "_seen", true)
	var B = J.gp(S, "bryan"); var on = J.t(B) and not J.seq(J.gp(B, "st"), "wait") and not J.seq(J.gp(B, "st"), "gone")
	var db = J.gp(DT, "__bryan")
	if on:
		if not J.t(db): db = doc("createElement", ["b"]); p(DT, "__bryan", db); p(db, "textContent", "B"); m(box, "appendChild", [db])
		var bs = J.gp(db, "style"); p(bs, "left", s_(maxf(0.6, minf(WW - 0.06, n_(J.gp(B, "x")))) / WW * 100) + "%"); p(bs, "background", "#b07aff"); p(bs, "top", "8px"); p(db, "className", "bry"); p(db, "_seen", true)
	for k in J.keys(DT):
		var d = J.gp(DT, k)
		if not J.t(J.gp(d, "_seen")): p(J.gp(d, "style"), "display", "none")
		else: p(J.gp(d, "style"), "display", "")
		p(d, "_seen", false)
	var vs2 = want.duplicate(); vs2.sort_custom(func(a, b): return n_(J.gp(a, "x")) < n_(J.gp(b, "x")))
	var last = -9.0; var row = 0
	for n in vs2:
		var d = J.gp(DT, J.gp(J.gp(n, "d"), "k")); var pp = n_(J.gp(n, "x")) / WW * 100
		row = (row + 1) % 2 if pp - last < 4.2 else 0; last = pp; p(J.gp(d, "style"), "top", "15px" if row else "1px")

# ---------- 接駁 ----------
# 座標表：照 rooms.js 公式即場計（JSON 讀返 double 會差最後一位）
static func build() -> Dictionary:
	var SW = 12168.0; var WALLW = 110.0
	var WALLS = [1506.0, 3122.0, 4132.0, 6042.0, 7628.0, 8438.0, 9948.0, 11258.0]
	var SEAM = []
	for v in WALLS: SEAM.append(npx(v + WALLW / 2))
	var ww = SW / PXU
	var rooms = [
		{"k": "boss", "name": "陳總房", "x0": 0.0, "x1": SEAM[0], "vent": [600.0, 70.0]},
		{"k": "meeting", "name": "會議室", "x0": SEAM[0], "x1": SEAM[1], "vent": [2590.0, 66.0]},
		{"k": "lobby", "name": "電梯大堂", "x0": SEAM[1], "x1": SEAM[2], "vent": [3700.0, 70.0]},
		{"k": "main", "name": "工程師區", "x0": SEAM[2], "x1": SEAM[3], "vent": [5210.0, 70.0]},
		{"k": "pantry", "name": "茶水間", "x0": SEAM[3], "x1": SEAM[4], "vent": [6896.0, 120.0]},
		{"k": "wc", "name": "洗手間", "x0": SEAM[4], "x1": SEAM[5], "vent": [8090.0, 70.0]},
		{"k": "qa", "name": "設計測試區", "x0": SEAM[5], "x1": SEAM[6], "vent": [9250.0, 70.0]},
		{"k": "server", "name": "伺服器房", "x0": SEAM[6], "x1": SEAM[7], "vent": [10660.0, 70.0]},
		{"k": "rest", "name": "休息室", "x0": SEAM[7], "x1": ww, "vent": [11760.0, 70.0]},
	]
	var i = 0
	for r in rooms: r["i"] = float(i); r["cx"] = (r.x0 + r.x1) / 2; i += 1
	OX = 1.37
	var spot = {
		"bossDesk": [px(1010), 0.668], "bossFront": [px(720), 0.73], "golf": [px(300), 0.80], "bossVisit": [px(860), 0.72],
		"water": [px(4060), 0.68], "coffee": [px(3770), 0.675], "micro": [px(3650), 0.68], "vend": [px(4300), 0.70], "fridge": [px(3990), 0.69], "kettle": [px(3860), 0.672], "sink": [px(3470), 0.672],
		"board": [npx(2905), 0.80], "seat1": [npx(2264), 0.72], "seat2": [npx(2477), 0.72], "seat3": [npx(2034), 0.72],
		"elev": [px(2762), 0.655],
		"restTable": [npx(6890), 0.86], "restSeats": [[npx(6720), 0.80], [npx(6890), 0.80], [npx(7060), 0.80]],
		"reception": [npx(3330), 0.80],
		"copier": [npx(6300), 0.70], "wcM": [npx(7868), 0.70], "wcF": [npx(8108), 0.70],
		"meetTable": [npx(2370), 0.82], "server": [npx(10660), 0.78], "qaDesks": [npx(8800), npx(9150), npx(9500)], "sofa": [npx(11850), 0.70],
	}
	var lane = [[Ru(1.80), 0.93], [Ru(2.24), 0.91], [px(3320), 0.93], [px(3960), 0.92], [npx(7900), 0.88], [npx(9300), 0.90], [npx(10700), 0.88], [npx(11500), 0.90], [npx(9600), 0.84], [px(3620), 0.95], [npx(3700), 0.92], [npx(2600), 0.93]]
	var patrol = [[px(780), 0.80], [npx(2750), 0.88], [M_(0.14), MY(0.71)], [npx(6500), 0.90], [npx(8000), 0.84], [npx(9300), 0.86], [npx(10600), 0.84], [npx(11600), 0.84]]
	var a = {
		"micro": [3594.0, 392.0, 120.0, 72.0], "microWin": [3606.0, 402.0, 78.0, 52.0], "fridge": [3906.0, 256.0, 176.0, 350.0], "fridgeDoor": [3910.0, 260.0, 168.0, 148.0],
		"vend": [4202.0, 264.0, 224.0, 344.0], "vendGlass": [4232.0, 288.0, 160.0, 186.0], "vendSlot": [4236.0, 512.0, 124.0, 38.0], "kettle": [3818.0, 392.0, 72.0, 72.0],
		"tv": [4728.0, 195.0, 391.0, 219.0], "speaker": [5143.0, 450.0, 94.0, 36.0], "spare": [[npx(1780), 0.80], [npx(2960), 0.90]],
		"golfBag": [0.0, 328.0, 112.0, 264.0], "chair": [680.0, 362.0, 178.0, 120.0], "trophy": [262.0, 204.0, 46.0, 96.0],
	}
	return {"SW": SW, "SEAM": SEAM, "WALLS": WALLS, "WALLW": WALLW, "PILLAR": WALLW / PXU, "WW": ww, "OX": OX, "ROOMS": rooms, "SPOT": spot, "LANE": lane, "PATROL": patrol, "A": a,
		"WINMAIN": [px(1575), py(200), px(995), py(216)],
		"ELEV": {"x0": px(2652), "x1": px(2872), "seam": px(2762), "top": py(248), "bot": py(570), "btn": [px(2910), py(380)]}}

func run(_env) -> void:
	D = build()
	ROOMS = D.ROOMS; SPOT = D.SPOT; A = D.A; WW = n_(D.WW); OX = n_(D.OX)
	RM = {}
	for r in ROOMS: RM[J.str(r.k)] = r
	SC = null; st = null; PANO = null; CROP = {}; TC = {}
	J.G["OFFMAP"] = {
		"pano": func(_t, _a): return pano(),
		"PXU": PXU, "WW": WW, "SW": D.SW, "SH": SH, "SEAM": D.SEAM, "WALLS": D.WALLS, "WALLW": D.WALLW, "PILLAR": D.PILLAR, "ROOMS": ROOMS, "RM": RM, "OX": OX,
		"M": func(_t, a): return M_(n_(J.arg(a, 0))),
		"MY": func(_t, a): return MY(n_(J.arg(a, 0))),
		"px": func(_t, a): return px(n_(J.arg(a, 0))),
		"npx": func(_t, a): return npx(n_(J.arg(a, 0))),
		"py": func(_t, a): return py(n_(J.arg(a, 0))),
		"Rp": func(_t, a): return Rp(n_(J.arg(a, 0))),
		"Ru": func(_t, a): return Ru(n_(J.arg(a, 0))),
		"roomAt": func(_t, a): return room_at(n_(J.arg(a, 0))),
		"SPOT": SPOT, "LANE": D.LANE, "PATROL": D.PATROL, "A": A,
		"R": func(_t, a): var v = J.arg(a, 0); return [px(n_(v[0])), py(n_(v[1])), px(n_(v[2])), py(n_(v[3]))],
		"init": func(_t, a): init(J.arg(a, 0)); return null,
		"tick": func(_t, a): tick(n_(J.arg(a, 0))); return null,
		"onProp": func(_t, a): on_prop(J.str(J.arg(a, 0)), J.arg(a, 1), J.arg(a, 2)); return null,
		"drawBack": func(_t, a): draw_back(J.arg(a, 0), n_(J.arg(a, 1))); return null,
		"drawables": func(_t, _a): return drawables(),
		"drawOver": func(_t, a): draw_over(J.arg(a, 0), n_(J.arg(a, 1))); return null,
		"mapHTML": func(_t, _a): return map_html(),
		"mapTick": func(_t, a): map_tick(J.arg(a, 0)); return null,
		"WINMAIN": D.WINMAIN, "ELEV": D.ELEV,
	}
