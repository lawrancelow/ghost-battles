# 原生改寫自 pantry.js（茶水間：電器浮出嚟、待機小動作、用／嚇嘅效果、休息區圓枱）
# 照舊 monkeypatch OFFMAP.init／tick／drawBack／drawables／onProp；隨機數（randf）次序同 JS 一模一樣
extends RefCounted

const PXU := 1165.0
const SH := 1024.0
const PI_ := PI
const LINES_SRC := {
	"fridge": [["雪櫃門……自己開咗？", "冰箱門……自己開了？"], ["喂，邊個開咗雪櫃唔閂啊？", "喂，誰打開冰箱沒關啊？"]],
	"vend": [["我都未入錢……點解會跌嘢出嚟？", "我都還沒投錢……怎麼會掉東西出來？"]],
	"water": [["水機漏水呀？成地都係……", "飲水機漏水啊？滿地都是……"]],
	"coffee": [["咖啡機自己沖咖啡？我冇撳掣喎……", "咖啡機自己沖咖啡？我沒按按鈕啊……"]],
	"micro": [["入面冇嘢……佢叮乜嘢啊？", "裡面沒東西……它在叮什麼啊？"]],
}
const AP_SRC := {
	"cab": {"sh": [[6514, 206, 552, 132, 6]], "floor": false},
	"micro": {"sh": [[6757, 392, 132, 79, 9]], "floor": false},
	"coffee": {"sh": [[6899, 365, 88, 106, 9]], "floor": false},
	"fridge": {"sh": [[7073, 249, 186, 366, 13]], "floor": true},
	"water": {"sh": [[7268, 300, 92, 116, 16], [7263, 405, 102, 210, 10]], "floor": true},
	"vend": {"sh": [[7371, 262, 227, 353, 9]], "floor": true},
}
const ORDER := ["cab", "micro", "coffee", "fridge", "water", "vend"]
const USE := ["micro", "coffee", "water", "fridge", "vend"]
const FRIDGE_IT := [[0.12, 1, 0.14, 0.2, "#e3c25a"], [0.32, 1, 0.1, 0.24, "#7fc28a"], [0.55, 2, 0.24, 0.13, "#e98a8a"], [0.15, 2, 0.16, 0.16, "#f4f0e0"], [0.62, 1, 0.12, 0.18, "#8aaee8"], [0.4, 3, 0.3, 0.12, "#d9a46b"]]

static var LINES := {}
static var AP := {}
static var table = null
static var seats = null
static var NIGHT = null
static var CUT := {}
static var SHC := {}
static var DIMC := {}
static var st = null
static var ORIG := {}

# ---------- 小工具 ----------
static func _g(n: String): return J.G.get(n)
static func Sc(): return J.G.get("Scare")
static func m(o, f: String, a := []): return J.mc(o, f, a)
static func p(o, k: String, v) -> void: J.sp(o, k, v)
static func n_(v) -> float: return J.num(v)
static func s_(v) -> String: return J.str(v)
static func ok(k: String) -> bool:
	var f = _g("sprOk")
	return f != null and J.t(J.cl(f, null, [k]))
static func sc() -> float: return n_(J.gp(m(Sc(), "bgScale"), "s"))
static func Q(x: float, y: float) -> Array:
	var r = m(Sc(), "pt", [x / PXU, y / SH]); return [n_(r[0]), n_(r[1])]
static func rand() -> float: return randf()
static func rr(c, x: float, y: float, w: float, h: float, r: float) -> void:
	m(c, "beginPath"); m(c, "moveTo", [x + r, y]); m(c, "arcTo", [x + w, y, x + w, y + h, r]); m(c, "arcTo", [x + w, y + h, x, y + h, r]); m(c, "arcTo", [x, y + h, x, y, r]); m(c, "arcTo", [x, y, x + w, y, r]); m(c, "closePath")
static func canvas():
	return J.S_document_("createElement", ["canvas"])
static func ease_(x: float) -> float: return 0.0 if x < 0 else (1.0 if x > 1 else x * x * (3 - 2 * x))
static func pick(a: Array): return a[int(floor(rand() * a.size()))]
static func fmod_js(a: float, b: float) -> float: return fmod(a, b)

static func night():
	if NIGHT != null: return NIGHT
	if not ok("bg_office_pano"): return null
	var im = J.gp(_g("SPR"), "bg_office_pano"); var k = n_(J.gp(im, "naturalHeight")) / SH; var X0 = 6480.0; var X1 = 7620.0; var c = canvas()
	p(c, "width", J.round((X1 - X0) * k)); p(c, "height", J.gp(im, "naturalHeight")); var x = m(c, "getContext", ["2d"])
	var ch = n_(J.gp(c, "height")); var cw = n_(J.gp(c, "width"))
	m(x, "drawImage", [im, X0 * k, 0.0, (X1 - X0) * k, ch, 0.0, 0.0, cw, ch])
	p(x, "globalCompositeOperation", "multiply"); p(x, "fillStyle", "rgb(150,140,196)"); m(x, "fillRect", [0.0, 0.0, cw, ch])
	var g = m(x, "createLinearGradient", [0.0, ch * 0.62, 0.0, ch]); m(g, "addColorStop", [0.0, "rgb(255,255,255)"]); m(g, "addColorStop", [1.0, "rgb(160,152,186)"]); p(x, "fillStyle", g); m(x, "fillRect", [0.0, ch * 0.62, cw, ch * 0.38])
	NIGHT = {"c": c, "k": k, "X0": X0}
	return NIGHT

static func cut(id: String):
	if CUT.has(id): return CUT[id]
	var N = night()
	if N == null: return null
	var A = AP[id]; var b = A.b; var bx = b[0]; var by = b[1]; var bw = b[2]; var bh = b[3]; var k = N.k
	var c = canvas(); p(c, "width", ceil(bw * k)); p(c, "height", ceil(bh * k)); var x = m(c, "getContext", ["2d"])
	m(x, "drawImage", [N.c, (bx - N.X0) * k, by * k, bw * k, bh * k, 0.0, 0.0, J.gp(c, "width"), J.gp(c, "height")])
	p(x, "globalCompositeOperation", "destination-in"); p(x, "fillStyle", "#000")
	for sh in A.sh:
		rr(x, (sh[0] - bx) * k, (sh[1] - by) * k, sh[2] * k, sh[3] * k, sh[4] * k); m(x, "fill")
	CUT[id] = c
	return c

static func cut_rect(id: String, rx: float, ry: float, rw: float, rh: float):
	if CUT.has(id): return CUT[id]
	var N = night()
	if N == null: return null
	var k = N.k; var c = canvas(); p(c, "width", ceil(rw * k)); p(c, "height", ceil(rh * k))
	var x = m(c, "getContext", ["2d"]); m(x, "drawImage", [N.c, (rx - N.X0) * k, ry * k, rw * k, rh * k, 0.0, 0.0, J.gp(c, "width"), J.gp(c, "height")])
	p(x, "globalCompositeOperation", "destination-in"); rr(x, 0.0, 0.0, n_(J.gp(c, "width")), n_(J.gp(c, "height")), 10 * k); m(x, "fill")
	CUT[id] = c
	return c

static func visible() -> bool:
	var a = Q(6480, 0)[0]; var b = Q(7640, 0)[0]
	var W = J.gp(Sc(), "W")
	return b > -40 and a < (n_(W) if J.t(W) else 390.0) + 40

# ---------- 狀態 ----------
static func reset() -> void:
	st = {"t": 0.0, "micro": null, "coffee": null, "fridge": null, "water": null, "vend": null, "items": [], "puddles": [], "drips": [], "mist": [], "bub": [], "flick": 0.0, "nextFlick": 3.0, "nextBub": 4.0, "use": {}}

static func headless() -> bool: return J.t(J.gp(Sc(), "headless"))
static func snd(x: String) -> void:
	if not headless(): m(_g("Sound"), "play", [x])

static func fx(k: String, n, use) -> void:
	if st == null: reset()
	var s = not J.t(use)
	var lk = k.replace("loop", "").replace("snack", "vend")
	if k == "micro": st.micro = {"t": 0.0, "dur": 4.5 if s else 4.0}; snd("click")
	elif k == "coffee": st.coffee = {"t": 0.0, "dur": 5.0}; snd("click")
	elif k == "fridge" or k == "fridgeloop": st.fridge = {"t": 0.0, "dur": 7.2 if k == "fridgeloop" else (3.4 if s else 3.0), "loop": k == "fridgeloop", "bang": 0.0}; snd("whoosh")
	elif k == "water":
		st.water = {"t": 0.0, "dur": 7.0 if s else 2.6, "leak": s}
		if s: st.puddles.append({"x": 7314.0, "y": 0.655, "r": 0.0, "rmax": 0.07 + rand() * 0.015, "t": 0.0, "grow": 7.0, "life": 32.0})
	elif k == "vend" or k == "snack":
		var col = floor(rand() * 4); var row = 0.0 if k == "snack" else 3.0
		st.vend = {"t": 0.0, "dur": 2.8, "kind": "snack" if k == "snack" else "can", "col": col, "row": row, "hue": [8.0, 35.0, 95.0, 200.0][int(col)]}
		st.flick = 1.4; snd("paper")
	elif k == "kettle" or k == "lights": J.cl(ORIG.onProp, ORIG, [k, n, "pantry"]); return
	# say
	if s and J.t(n) and J.t(J.gp(Sc(), "bubble")) and LINES.has(lk):
		J.F_setTimeout([func(_t = null, _a = null):
			var S = Sc()
			if J.t(J.gp(S, "active")) and not J.t(J.gp(n, "gone")) and not J.t(J.gp(n, "fleeing")):
				p(n, "bubT", 0.0); m(S, "bubble", [n, J.cl(_g("L"), null, [pick(LINES[lk])]), 2.6])
			return null, 2200.0])

# ---------- tick ----------
static func tick(dt: float) -> void:
	if st == null: reset()
	st.t += dt
	for k in ["micro", "coffee", "fridge", "water"]:
		var e = st[k]
		if e != null:
			e.t += dt
			if k == "micro" and not e.get("ding") and e.t > e.dur - 0.8:
				e["ding"] = 1.0; snd("click")
			if e.t > e.dur: st[k] = null
	var V = st.vend
	if V != null:
		V.t += dt
		if not V.get("out") and V.t > 1.15:
			V["out"] = 1.0
			var ix = 7450 + rand() * 40
			var vx = -(70 + rand() * 30) if V.kind == "can" else -(30 + rand() * 15)
			st.items.append({"kind": V.kind, "hue": V.hue, "x": ix, "y": 0.62, "t": 0.0, "vx": vx, "rot": 0.0, "dist": 0.0})
			snd("hit")
		if V.t > V.dur: st.vend = null
	for it in st.items:
		it.t += dt
		if it.t > 0.25:
			var f = 0.8 if it.kind == "can" else 2.6
			it.x += it.vx * dt; it.vx *= exp(-dt * f); it.y = minf(0.69, it.y + dt * 0.06 * exp(-it.t))
			if it.kind == "can": it.rot += it.vx * dt / 9
	st.items = st.items.filter(func(it): return it.t < 14)
	for pd in st.puddles:
		pd.t += dt; var gg = minf(1.0, pd.t / pd.grow)
		pd.r = pd.rmax * (1 - pow(1 - gg, 2)) * (maxf(0.35, 1 - (pd.t - pd.life * 0.55) / (pd.life * 0.45) * 0.65) if pd.t > pd.life * 0.55 else 1.0)
	st.puddles = st.puddles.filter(func(pd): return pd.t < pd.life)
	var F = st.fridge
	if F != null and fridge_open(F) > 0.4:
		if rand() < dt * 14:
			var mx = 7095 + rand() * 140; var my = 330 + rand() * 60; var mvx = -10 + rand() * 30; var mvy = 25 + rand() * 30; var mr = 8 + rand() * 8
			st.mist.append({"x": mx, "y": my, "vx": mvx, "vy": mvy, "r": mr, "t": 0.0, "life": 1.6 + rand()})
	for mm in st.mist:
		mm.t += dt; mm.x += mm.vx * dt; mm.y += mm.vy * dt
		if mm.y > 600: mm.y = 600.0; mm.vy = 0.0; mm.vx += (1.0 if mm.vx >= 0 else -1.0) * 18 * dt
		mm.r += dt * 10
	st.mist = st.mist.filter(func(mm): return mm.t < mm.life)
	var W = st.water
	if W != null and rand() < dt * (6 if W.leak else 9):
		st.drips.append({"x": 7330.0 if W.leak else 7329.0, "y": 487.0, "vy": 0.0, "t": 0.0, "fl": W.leak and W.t > 1.4})
	for d in st.drips: d.t += dt; d.vy += 900 * dt; d.y += d.vy * dt
	st.drips = st.drips.filter(func(d): return d.y < (640 if d.fl else 508))
	st.nextBub -= dt * (6 if W != null else 1)
	if st.nextBub <= 0:
		st.nextBub = 5 + rand() * 7
		for i in 4:
			var bx = 7300 + rand() * 28; var br = 2 + rand() * 3.5
			st.bub.append({"x": bx, "y": 404.0 + i * 6, "r": br, "t": -i * 0.15})
	for b in st.bub:
		b.t += dt
		if b.t > 0: b.y -= dt * (55 + b.r * 6)
	st.bub = st.bub.filter(func(b): return b.y > 318)
	st.flick = maxf(0.0, st.flick - dt); st.nextFlick -= dt
	if st.nextFlick <= 0: st.nextFlick = 4 + rand() * 8; st.flick = 0.5 + rand() * 0.5
	npc_use(dt)

static func npc_use(dt: float) -> void:
	var S = Sc()
	if not J.t(J.gp(S, "npcs")) or not J.t(J.gp(S, "site")) or not J.t(J.gp(J.gp(S, "site"), "pano")): return
	var SP = J.gp(_g("OFFMAP"), "SPOT")
	for n in J.iter(J.gp(S, "npcs")):
		if J.t(J.gp(n, "gone")) or J.t(J.gp(n, "out")) or J.t(J.gp(n, "fleeing")) or J.t(J.gp(J.gp(n, "d"), "guard")): p(n, "_pu", null); continue
		var hit = null
		for k in USE:
			var s = J.gp(SP, k)
			if J.t(s) and absf(n_(J.gp(n, "x")) - n_(s[0])) < 0.05 and absf(n_(J.gp(n, "y")) - n_(s[1])) < 0.035: hit = k; break
		if hit == null or J.seq(J.gp(n, "act"), "walk"):
			if hit == null: p(n, "_pu", null)
			continue
		var pu = J.gp(n, "_pu")
		if not J.t(pu) or not J.seq(J.gp(pu, "k"), hit): pu = {"k": hit, "t": 0.0, "done": false}; p(n, "_pu", pu)
		p(pu, "t", n_(J.gp(pu, "t")) + dt)
		var busy = st.vend if hit == "vend" else st[hit]
		if not J.t(J.gp(pu, "done")) and n_(J.gp(pu, "t")) > 0.8 and busy == null:
			p(pu, "done", true)
			if hit != "vend" or rand() < 0.7:
				fx("snack" if (hit == "vend" and rand() < 0.5) else hit, n, true)

static func fridge_open(F) -> float:
	if F == null: return 0.0
	var t = F.t
	if F.loop:
		var c = 1.8; var ph = fmod(t, c); var i = floor(t / c)
		if i >= 4: return 0.0
		return ease_(ph / 0.45) if ph < 0.45 else (1.0 if ph < 1.1 else ease_(1 - (ph - 1.1) / 0.3))
	return minf(ease_(t / 0.6), ease_((F.dur - t) / 0.5))

# ---------- 畫 ----------
static func pop_out(ctx, id: String, _t) -> void:
	var A = AP[id]; var img = cut(id)
	if img == null: return
	var s = sc(); var b = A.b; var bx = b[0]; var by = b[1]; var bw = b[2]; var bh = b[3]
	var q = Q(bx, by); var x = q[0]; var y = q[1]; var w = bw * s; var h = bh * s
	if A.floor:
		var cq = Q(bx + bw / 2, by + bh - 2); var cx = cq[0]; var cy = cq[1]
		m(ctx, "save"); var g = m(ctx, "createRadialGradient", [cx, cy, 0.0, cx, cy, w * 0.62])
		m(g, "addColorStop", [0.0, "rgba(8,4,22,.55)"]); m(g, "addColorStop", [0.6, "rgba(8,4,22,.25)"]); m(g, "addColorStop", [1.0, "rgba(8,4,22,0)"])
		p(ctx, "fillStyle", g); m(ctx, "translate", [cx, cy]); m(ctx, "scale", [1.0, 0.16]); m(ctx, "beginPath"); m(ctx, "arc", [0.0, 0.0, w * 0.62, 0.0, PI_ * 2]); m(ctx, "fill"); m(ctx, "restore")
	var f = 1.018 if A.floor else 1.012; var dw = w * f; var dh = h * f; var dx = x + (w - dw) / 2; var dy = y + h - dh
	var M = m(ctx, "getTransform"); var iw = n_(J.gp(img, "width")); var ih = n_(J.gp(img, "height"))
	var k = J.hypot_([J.gp(M, "a"), J.gp(M, "b")]) * dw / iw
	var bl = 27 * s / k; var ox = 6 * s / k; var oy = 4 * s / k; var key = id + "|" + s_(J.round(bl * 2))
	var c = SHC.get(key)
	if c == null:
		var pad = ceil(bl * 2 + maxf(ox, oy)); c = canvas(); p(c, "width", iw + pad * 2); p(c, "height", ih + pad * 2)
		var g2 = m(c, "getContext", ["2d"]); p(g2, "shadowColor", "rgba(6,2,20,.55)"); p(g2, "shadowBlur", bl); p(g2, "shadowOffsetX", ox); p(g2, "shadowOffsetY", oy); p(g2, "imageSmoothingQuality", "high"); m(g2, "drawImage", [img, pad, pad])
		p(c, "pad", pad); SHC[key] = c
	var u = dw / iw; var cpad = n_(J.gp(c, "pad"))
	m(ctx, "save"); p(ctx, "imageSmoothingQuality", "high"); m(ctx, "drawImage", [c, dx - cpad * u, dy - cpad * u, n_(J.gp(c, "width")) * u, n_(J.gp(c, "height")) * u]); m(ctx, "restore")
	m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter"); p(ctx, "lineWidth", maxf(1.0, 2.2 * s))
	var gl = m(ctx, "createLinearGradient", [dx, dy, dx + dw * 0.6, dy + dh * 0.6]); m(gl, "addColorStop", [0.0, "rgba(170,160,255,.42)"]); m(gl, "addColorStop", [1.0, "rgba(170,160,255,0)"]); p(ctx, "strokeStyle", gl)
	for sh in A.sh:
		var pq = Q(bx + (sh[0] - bx) * f - (bw * (f - 1)) / 2, by + bh - (by + bh - sh[1]) * f)
		rr(ctx, pq[0] + 1.5 * s, pq[1] + 1.5 * s, sh[2] * s * f - 3 * s, sh[3] * s * f - 3 * s, sh[4] * s); m(ctx, "stroke")
	m(ctx, "restore")

static func R(x: float, y: float, w: float, h: float) -> Array:
	var q = Q(x, y); var s = sc(); return [q[0], q[1], w * s, h * s]

static func glow_at(ctx, x: float, y: float, r: float, col: String, a: float) -> void:
	var q = Q(x, y); var X = q[0]; var Y = q[1]; var s = sc(); var g = m(ctx, "createRadialGradient", [X, Y, 0.0, X, Y, r * s])
	m(g, "addColorStop", [0.0, "rgba(" + col + "," + s_(a) + ")"]); m(g, "addColorStop", [1.0, "rgba(" + col + ",0)"])
	m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter"); p(ctx, "fillStyle", g); m(ctx, "fillRect", [X - r * s, Y - r * s, r * s * 2, r * s * 2]); m(ctx, "restore")

static func led(ctx, x: float, y: float, col: String, a: float) -> void:
	var q = Q(x, y); var s = sc()
	m(ctx, "save"); p(ctx, "fillStyle", "rgba(" + col + "," + s_(a) + ")"); m(ctx, "beginPath"); m(ctx, "arc", [q[0], q[1], maxf(1.3, 3 * s), 0.0, PI_ * 2]); m(ctx, "fill"); m(ctx, "restore")
	glow_at(ctx, x, y, 14, col, a * 0.5)

static func sfx(ctx, x: float, y: float, s0: String, sz: float, a: float) -> void:
	if a <= 0.01: return
	var q = Q(x, y); var s = sc()
	m(ctx, "save"); p(ctx, "globalAlpha", n_(J.gp(ctx, "globalAlpha")) * minf(1.0, a)); p(ctx, "font", "900 " + s_(J.round(maxf(13.0, sz * s))) + "px sans-serif"); p(ctx, "textAlign", "center")
	p(ctx, "lineWidth", 3.0); p(ctx, "strokeStyle", "#1a1020"); m(ctx, "strokeText", [s0, q[0], q[1]]); p(ctx, "fillStyle", "#fff3d0"); m(ctx, "fillText", [s0, q[0], q[1]]); m(ctx, "restore")

static func draw_fridge(ctx, t: float) -> void:
	var F = st.fridge; var o = fridge_open(F); var s = sc()
	led(ctx, 7238, 268, "120,255,170", 0.55 + 0.25 * sin(t * 2.2))
	if o <= 0.005: return
	var r = R(7081, 256, 170, 138); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]
	m(ctx, "save"); var g = m(ctx, "createLinearGradient", [x, y, x, y + h]); m(g, "addColorStop", [0.0, "#f2f8ff"]); m(g, "addColorStop", [1.0, "#b7cbe4"]); p(ctx, "fillStyle", g); rr(ctx, x, y, w, h, 8 * s); m(ctx, "fill"); m(ctx, "clip")
	p(ctx, "strokeStyle", "rgba(110,130,165,.8)"); p(ctx, "lineWidth", maxf(1.0, 2 * s))
	for i in range(1, 3): m(ctx, "beginPath"); m(ctx, "moveTo", [x, y + h * i / 3.0]); m(ctx, "lineTo", [x + w, y + h * i / 3.0]); m(ctx, "stroke")
	for it in FRIDGE_IT:
		p(ctx, "fillStyle", it[4]); p(ctx, "strokeStyle", "#3b2c3a"); p(ctx, "lineWidth", maxf(1.0, 1.5 * s))
		rr(ctx, x + w * it[0], y + h * it[1] / 3.0 - h * it[3] - 2 * s, w * it[2], h * it[3], 3 * s); m(ctx, "fill"); m(ctx, "stroke")
	m(ctx, "restore")
	glow_at(ctx, 7166, 330, 190, "200,230,255", 0.55 * o)
	var d = cut_rect("fdoor", 7079, 254, 174, 141)
	if d != null:
		var cw = cos(o * PI_ * 0.46); var dw = maxf(0.06, cw) * w * 1.02
		m(ctx, "save"); m(ctx, "drawImage", [d, x + w * 1.01 - dw, y - 2 * s, dw, h + 4 * s])
		p(ctx, "fillStyle", "rgba(20,14,40," + s_(0.35 * o) + ")"); m(ctx, "fillRect", [x + w * 1.01 - dw, y - 2 * s, dw, h + 4 * s])
		p(ctx, "fillStyle", "#d8d4e8"); p(ctx, "strokeStyle", "#2b2033"); p(ctx, "lineWidth", maxf(1.0, 1.5 * s)); var th = 9 * s * o
		m(ctx, "fillRect", [x + w * 1.01 - dw - th, y - 2 * s, th, h + 4 * s]); m(ctx, "strokeRect", [x + w * 1.01 - dw - th, y - 2 * s, th, h + 4 * s]); m(ctx, "restore")
	var q0 = Q(7090, 612); var fx0 = q0[0]; var fy0 = q0[1]; var fx1 = Q(7250, 612)[0]
	m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter"); var lg = m(ctx, "createLinearGradient", [0.0, fy0, 0.0, fy0 + 90 * s])
	m(lg, "addColorStop", [0.0, "rgba(170,210,255," + s_(0.28 * o) + ")"]); m(lg, "addColorStop", [1.0, "rgba(170,210,255,0)"]); p(ctx, "fillStyle", lg)
	m(ctx, "beginPath"); m(ctx, "moveTo", [fx0, fy0]); m(ctx, "lineTo", [fx1, fy0]); m(ctx, "lineTo", [fx1 + 60 * s, fy0 + 90 * s]); m(ctx, "lineTo", [fx0 - 60 * s, fy0 + 90 * s]); m(ctx, "closePath"); m(ctx, "fill"); m(ctx, "restore")
	if F.loop:
		var ph = fmod(F.t, 1.8)
		if ph > 1.35 and ph < 1.75 and F.t < 7.2: sfx(ctx, 7166, 236, "砰！", 34, 1 - (ph - 1.35) / 0.4)

static func draw_mist(ctx) -> void:
	if st.mist.is_empty(): return
	var s = sc(); m(ctx, "save")
	for mm in st.mist:
		var q = Q(mm.x, mm.y); var X = q[0]; var Y = q[1]; var a = sin(minf(1.0, mm.t / mm.life) * PI_) * 0.13; var r = mm.r * s
		var g = m(ctx, "createRadialGradient", [X, Y, 0.0, X, Y, r]); m(g, "addColorStop", [0.0, "rgba(225,240,255," + s_(a) + ")"]); m(g, "addColorStop", [1.0, "rgba(225,240,255,0)"])
		p(ctx, "fillStyle", g); m(ctx, "fillRect", [X - r, Y - r, r * 2, r * 2])
	m(ctx, "restore")

static func draw_micro(ctx, t: float) -> void:
	var M = st.micro; var s = sc()
	var q = Q(6864, 416)
	m(ctx, "save"); p(ctx, "font", "700 " + s_(maxf(6.0, J.round(9 * s))) + "px monospace"); p(ctx, "textAlign", "center")
	p(ctx, "fillStyle", "rgba(255,190,90,.95)" if M != null else "rgba(120,255,170," + s_(0.9 if sin(t * 3) > 0 else 0.45) + ")")
	m(ctx, "fillText", [("0:" + s_(maxf(0.0, ceil(M.dur - M.t))).lpad(2, "0")) if M != null else "12:00", q[0] + 5 * s, q[1]]); m(ctx, "restore")
	if M == null: return
	var r = R(6770, 406, 84, 52); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]; var on = M.t < M.dur - 0.8
	m(ctx, "save"); rr(ctx, x, y, w, h, 4 * s); m(ctx, "clip")
	if on:
		p(ctx, "fillStyle", "rgba(255,196,110,.85)"); m(ctx, "fillRect", [x, y, w, h]); var a = M.t * 3.2
		p(ctx, "strokeStyle", "rgba(120,70,30,.7)"); p(ctx, "lineWidth", maxf(1.0, 1.5 * s)); m(ctx, "beginPath"); m(ctx, "ellipse", [x + w / 2, y + h * 0.8, w * 0.36, h * 0.1, 0.0, 0.0, PI_ * 2]); m(ctx, "stroke")
		var bx = x + w / 2 + cos(a) * w * 0.16; var bz = sin(a); p(ctx, "fillStyle", "#9a5a3a" if bz > 0 else "#7d4a32")
		m(ctx, "beginPath"); m(ctx, "ellipse", [bx, y + h * 0.72, w * 0.13 * (0.85 + 0.15 * absf(cos(a))), h * 0.13, 0.0, 0.0, PI_ * 2]); m(ctx, "fill")
		p(ctx, "fillStyle", "#c87a4a"); m(ctx, "fillRect", [bx - w * 0.12, y + h * 0.6, w * 0.24, h * 0.1])
	m(ctx, "restore")
	if on: glow_at(ctx, 6812, 432, 110, "255,180,90", 0.35 + 0.1 * sin(t * 30))
	if on: sfx(ctx, 6812, 386, "嗡——", 20, 0.75)
	else: sfx(ctx, 6812, 386, "叮！", 34, (M.dur - M.t) / 0.8)

static func draw_coffee(ctx, t: float) -> void:
	var C = st.coffee; var s = sc()
	led(ctx, 6973, 381, "255,90,70" if C != null else "120,255,170", 0.9 if C != null else (0.8 if sin(t * 1.6) > 0.3 else 0.25))
	if C == null: return
	var k = minf(1.0, C.t / (C.dur - 0.6))
	if C.t < C.dur - 0.6:
		var q0 = Q(6940, 409); var Y1 = Q(6940, 452 - k * 30)[1]
		m(ctx, "save"); p(ctx, "strokeStyle", "rgba(70,35,18,.95)"); p(ctx, "lineWidth", maxf(1.0, 2.2 * s)); m(ctx, "setLineDash", [[4 * s, 3 * s]]); p(ctx, "lineDashOffset", -t * 60)
		m(ctx, "beginPath"); m(ctx, "moveTo", [q0[0], q0[1]]); m(ctx, "lineTo", [q0[0], Y1]); m(ctx, "stroke"); m(ctx, "restore")
	var r = R(6914, 415, 52, 42); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]
	m(ctx, "save"); m(ctx, "beginPath"); m(ctx, "ellipse", [x + w / 2, y + h * 0.58, w * 0.5, h * 0.48, 0.0, 0.0, PI_ * 2]); m(ctx, "clip"); p(ctx, "fillStyle", "rgba(80,40,20,.92)")
	var lv = h * (0.25 + 0.7 * k); m(ctx, "fillRect", [x, y + h - lv, w, lv]); p(ctx, "fillStyle", "rgba(255,220,180,.25)"); m(ctx, "fillRect", [x, y + h - lv, w, 2 * s]); m(ctx, "restore")
	m(ctx, "save"); p(ctx, "lineCap", "round")
	for i in 3:
		var ph = fmod(t * 0.7 + i / 3.0, 1.0); var q = Q(6930 + i * 10 + sin(t * 2 + i) * 4, 366 - ph * 60); var X = q[0]; var Y = q[1]
		p(ctx, "strokeStyle", "rgba(240,235,255," + s_(0.45 * (1 - ph)) + ")"); p(ctx, "lineWidth", maxf(1.0, 4 * s * (1 - ph * 0.5)))
		m(ctx, "beginPath"); m(ctx, "moveTo", [X, Y]); m(ctx, "quadraticCurveTo", [X + 8 * s, Y - 10 * s, X, Y - 20 * s]); m(ctx, "stroke")
	m(ctx, "restore")
	if C.t < 1.0: sfx(ctx, 6942, 350, "嘀", 22, 1 - C.t)
	elif C.t < C.dur - 0.6: sfx(ctx, 6942, 350, "咕嚕咕嚕", 18, 0.7)

static func draw_water(ctx, t: float) -> void:
	var W = st.water; var s = sc()
	led(ctx, 7344, 462, "255,120,90", 0.35 + 0.15 * sin(t * 1.3))
	m(ctx, "save")
	for b in st.bub:
		if b.t < 0: continue
		var q = Q(b.x + sin(b.t * 9 + b.r) * 2, b.y); p(ctx, "strokeStyle", "rgba(220,240,255,.75)"); p(ctx, "lineWidth", maxf(1.0, 1.3 * s))
		m(ctx, "beginPath"); m(ctx, "arc", [q[0], q[1], b.r * s, 0.0, PI_ * 2]); m(ctx, "stroke")
	m(ctx, "restore")
	m(ctx, "save"); p(ctx, "fillStyle", "rgba(160,210,255,.95)")
	for d in st.drips:
		var q = Q(d.x, d.y); m(ctx, "beginPath"); m(ctx, "ellipse", [q[0], q[1], 2.2 * s + 0.6, 3.6 * s + 0.8, 0.0, 0.0, PI_ * 2]); m(ctx, "fill")
	m(ctx, "restore")
	if W != null and W.leak and W.t > 1.0:
		var q0 = Q(7300, 512); var Y1 = Q(7300, 612)[1]
		m(ctx, "save"); p(ctx, "strokeStyle", "rgba(150,200,255,.5)"); p(ctx, "lineWidth", maxf(1.0, 2 * s)); m(ctx, "setLineDash", [[6 * s, 8 * s]]); p(ctx, "lineDashOffset", -t * 120)
		m(ctx, "beginPath"); m(ctx, "moveTo", [q0[0], q0[1]]); m(ctx, "lineTo", [q0[0], Y1]); m(ctx, "stroke"); m(ctx, "restore")
	if W != null and W.leak: sfx(ctx, 7314, 290, "滴…滴…", 18, minf(minf(1.0, W.t), W.dur - W.t))
	if W != null and not W.leak:
		var r = R(7319, 486, 22, 22); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]
		m(ctx, "save"); p(ctx, "fillStyle", "rgba(240,240,250,.9)"); p(ctx, "strokeStyle", "#2b2033"); p(ctx, "lineWidth", maxf(1.0, 1.4 * s)); m(ctx, "fillRect", [x, y, w, h]); m(ctx, "strokeRect", [x, y, w, h])
		p(ctx, "fillStyle", "rgba(150,200,255,.8)"); var lv = h * minf(0.85, W.t / W.dur); m(ctx, "fillRect", [x + 1, y + h - lv, w - 2, lv]); m(ctx, "restore")

static func draw_vend(ctx, t: float) -> void:
	var V = st.vend; var s = sc(); var fl = st.flick > 0 and sin(t * 47) + sin(t * 29) > 0.3
	var r = R(7398, 289, 141, 211); var x = r[0]; var y = r[1]; var w = r[2]; var h = r[3]
	m(ctx, "save"); p(ctx, "globalCompositeOperation", "source-over" if fl else "lighter"); p(ctx, "fillStyle", "rgba(6,4,18,.5)" if fl else "rgba(150,215,255," + s_(0.16 + 0.03 * sin(t * 5)) + ")"); rr(ctx, x, y, w, h, 4 * s); m(ctx, "fill")
	if not fl:
		var g = m(ctx, "createLinearGradient", [x, y, x + w, y + h]); m(g, "addColorStop", [0.0, "rgba(255,255,255,0)"]); m(g, "addColorStop", [0.45, "rgba(255,255,255,.14)"]); m(g, "addColorStop", [0.55, "rgba(255,255,255,0)"]); p(ctx, "fillStyle", g); m(ctx, "fillRect", [x, y, w, h])
	m(ctx, "restore")
	if not fl: glow_at(ctx, 7468, 400, 200, "120,190,255", 0.16)
	var q0 = Q(7380, 614); var fx0 = q0[0]; var fy0 = q0[1]; var fx1 = Q(7590, 614)[0]
	m(ctx, "save"); p(ctx, "globalCompositeOperation", "lighter"); var g2 = m(ctx, "createLinearGradient", [0.0, fy0, 0.0, fy0 + 70 * s])
	m(g2, "addColorStop", [0.0, "rgba(120,190,255," + s_(0.03 if fl else 0.16) + ")"]); m(g2, "addColorStop", [1.0, "rgba(120,190,255,0)"]); p(ctx, "fillStyle", g2); m(ctx, "fillRect", [fx0 - 30 * s, fy0, fx1 - fx0 + 60 * s, 70 * s]); m(ctx, "restore")
	if V == null: return
	var cx = 7420 + V.col * 35; var ry = 322 + V.row * 50; var k = minf(1.0, V.t / 1.1); var yy = ry + (505 - ry) * k * k
	if V.t < 1.15:
		m(ctx, "save"); m(ctx, "beginPath"); m(ctx, "rect", [x, y, w, h + 50 * s]); m(ctx, "clip"); item(ctx, V.kind, V.hue, cx, yy, 0.0, k * 2.5); m(ctx, "restore")
	if V.t > 1.1 and V.t < 2.2: sfx(ctx, 7474, 515, "哐咚！", 30, 1 - (V.t - 1.1) / 1.1)

static func item(ctx, kind, hue, bx: float, by: float, rot: float, spin = null) -> void:
	var q = Q(bx, by); var s = sc() * 1.5
	m(ctx, "save"); m(ctx, "translate", [q[0], q[1] - 12 * s]); m(ctx, "rotate", [rot + (n_(spin) if J.t(spin) else 0.0)]); p(ctx, "strokeStyle", "#2b2033"); p(ctx, "lineWidth", maxf(1.0, 1.6 * s))
	if kind == "can":
		var cw = 16 * s; var ch = 26 * s; p(ctx, "fillStyle", "hsl(" + s_(hue) + ",62%,48%)"); rr(ctx, -cw / 2, -ch / 2, cw, ch, 3 * s); m(ctx, "fill"); m(ctx, "stroke")
		p(ctx, "fillStyle", "rgba(255,255,255,.85)"); m(ctx, "fillRect", [-cw / 2 + 1, -ch * 0.1, cw - 2, ch * 0.2]); p(ctx, "fillStyle", "#cfd2da"); m(ctx, "fillRect", [-cw / 2 + 1, -ch / 2 + 1, cw - 2, 3 * s])
	else:
		var cw = 24 * s; var ch = 30 * s; p(ctx, "fillStyle", "hsl(" + s_(hue) + ",70%,58%)")
		m(ctx, "beginPath"); m(ctx, "moveTo", [-cw / 2, -ch / 2]); m(ctx, "lineTo", [cw / 2, -ch / 2]); m(ctx, "lineTo", [cw / 2 - 2 * s, ch / 2]); m(ctx, "lineTo", [-cw / 2 + 2 * s, ch / 2]); m(ctx, "closePath"); m(ctx, "fill"); m(ctx, "stroke")
		p(ctx, "fillStyle", "rgba(255,255,255,.6)"); m(ctx, "fillRect", [-cw / 2 + 2 * s, -ch / 2, cw - 4 * s, 4 * s]); m(ctx, "fillRect", [-cw / 2 + 3 * s, ch / 2 - 4 * s, cw - 6 * s, 3 * s])
		p(ctx, "fillStyle", "rgba(255,255,255,.75)"); m(ctx, "beginPath"); m(ctx, "arc", [0.0, 0.0, 5 * s, 0.0, PI_ * 2]); m(ctx, "fill")
	m(ctx, "restore")

static func draw_back(ctx, t) -> void:
	J.cl(ORIG.drawBack, _g("OFFMAP"), [ctx, t])
	var site = J.gp(Sc(), "site")
	if not J.t(site) or not J.t(J.gp(site, "pano")) or st == null or not visible(): return
	var tt = n_(t)
	for id in ORDER: pop_out(ctx, id, tt)
	draw_micro(ctx, tt); draw_coffee(ctx, tt); draw_fridge(ctx, tt); draw_water(ctx, tt); draw_vend(ctx, tt); draw_mist(ctx)

static func t0() -> float:
	var t = J.gp(Sc(), "t"); return n_(t) if J.t(t) else 0.0

static func drawables():
	var out = J.cl(ORIG.drawables, _g("OFFMAP"), [])
	var site = J.gp(Sc(), "site")
	if st == null or not J.t(site) or not J.t(J.gp(site, "pano")): return out
	for pd in st.puddles:
		out.append([0.625, func(_t, a):
			var ctx = a[0]; var q = Q(pd.x, pd.y * SH); var X = q[0]; var Y = q[1]; var rx = pd.r * PXU * sc()
			var al = maxf(0.0, 1 - (pd.t - pd.life * 0.55) / (pd.life * 0.45)) if pd.t > pd.life * 0.55 else 1.0
			if rx < 1: return null
			m(ctx, "save"); p(ctx, "globalAlpha", al); p(ctx, "fillStyle", "rgba(110,150,220,.32)"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, Y, rx, rx * 0.16, 0.0, 0.0, PI_ * 2]); m(ctx, "ellipse", [X - rx * 0.35, Y + rx * 0.05, rx * 0.55, rx * 0.11, 0.0, 0.0, PI_ * 2]); m(ctx, "fill")
			p(ctx, "globalCompositeOperation", "lighter"); p(ctx, "strokeStyle", "rgba(200,225,255,.35)"); p(ctx, "lineWidth", 1.5); m(ctx, "beginPath"); m(ctx, "ellipse", [X + rx * 0.15, Y - rx * 0.03, rx * 0.5, rx * 0.06, 0.0, PI_ * 1.1, PI_ * 1.8]); m(ctx, "stroke")
			var rp = fmod(t0() * 0.8, 1.0); p(ctx, "strokeStyle", "rgba(200,225,255," + s_(0.3 * (1 - rp)) + ")"); m(ctx, "beginPath"); m(ctx, "ellipse", [X + rx * 0.2, Y, rx * 0.3 * rp, rx * 0.05 * rp, 0.0, 0.0, PI_ * 2]); m(ctx, "stroke"); m(ctx, "restore")
			return null])
	for it in st.items:
		var yy = it.y
		out.append([yy, func(_t, a):
			var ctx = a[0]; var al = 1 - (it.t - 12) / 2 if it.t > 12 else 1.0; var in_slot = it.t < 0.25; var q = Q(it.x, yy * SH); var X = q[0]; var Y = q[1]; var s = sc()
			m(ctx, "save"); p(ctx, "globalAlpha", al)
			if not in_slot: p(ctx, "fillStyle", "rgba(6,4,18,.35)"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, Y, 14 * s, 3.5 * s, 0.0, 0.0, PI_ * 2]); m(ctx, "fill")
			if in_slot:
				m(ctx, "beginPath"); var sq = Q(7414, 518); m(ctx, "rect", [sq[0], sq[1], 120 * s, 36 * s]); m(ctx, "clip"); item(ctx, it.kind, it.hue, it.x, 552, 0.0)
			else: item(ctx, it.kind, it.hue, it.x, yy * SH, it.rot if it.kind == "can" else -0.15 + minf(it.t, 1.0) * -1.25)
			m(ctx, "restore")
			if it.t > 0.25 and it.t < 1.3: sfx(ctx, it.x, yy * SH - 50, "咕碌咕碌" if it.kind == "can" else "啪", 16, 1 - (it.t - 0.25))
			return null])
	for se in J.iter(seats):
		var sx = n_(se[0]); var sy = n_(se[1])
		out.append([sy - 0.004, func(_t, a): chair(a[0], sx, sy); return null])
	out.append([table[1], func(_t, a): draw_table(a[0]); return null])
	return out

static func chair(ctx, x: float, y: float) -> void:
	if not ok("of_chair_front"): return
	var im = J.gp(_g("SPR"), "of_chair_front"); var S = Sc(); var q = m(S, "pt", [x, y]); var X = n_(q[0]); var Y = n_(q[1])
	var H = n_(m(S, "hh", [y])) * 0.6; var W = H * n_(J.gp(im, "naturalWidth")) / n_(J.gp(im, "naturalHeight"))
	m(ctx, "save"); p(ctx, "fillStyle", "rgba(6,4,18,.3)"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, Y, W * 0.42, W * 0.09, 0.0, 0.0, PI_ * 2]); m(ctx, "fill")
	if not DIMC.has("chair"):
		var c = canvas(); p(c, "width", J.gp(im, "naturalWidth")); p(c, "height", J.gp(im, "naturalHeight")); var g = m(c, "getContext", ["2d"]); p(g, "filter", "brightness(.78) saturate(.9)"); m(g, "drawImage", [im, 0.0, 0.0]); DIMC["chair"] = c
	m(ctx, "drawImage", [DIMC.chair, X - W / 2, Y - H, W, H]); m(ctx, "restore")

static func draw_table(ctx) -> void:
	var x = n_(table[0]); var y = n_(table[1]); var S = Sc(); var q = m(S, "pt", [x, y]); var X = n_(q[0]); var Y = n_(q[1]); var u = n_(m(S, "hh", [y])); var R0 = u * 0.36; var top = Y - u * 0.4; var lw = maxf(1.5, u * 0.012)
	m(ctx, "save"); p(ctx, "lineJoin", "round"); p(ctx, "strokeStyle", "#2a1f2e"); p(ctx, "lineWidth", lw)
	p(ctx, "fillStyle", "rgba(6,4,18,.38)"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, Y, R0 * 0.75, R0 * 0.16, 0.0, 0.0, PI_ * 2]); m(ctx, "fill")
	p(ctx, "fillStyle", "#7b6878"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, Y - u * 0.012, R0 * 0.42, R0 * 0.09, 0.0, 0.0, PI_ * 2]); m(ctx, "fill"); m(ctx, "stroke")
	p(ctx, "fillStyle", "#8c7a88"); m(ctx, "fillRect", [X - u * 0.022, top, u * 0.044, Y - top - u * 0.012]); m(ctx, "strokeRect", [X - u * 0.022, top, u * 0.044, Y - top - u * 0.012])
	p(ctx, "fillStyle", "#9f8079"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, top + u * 0.03, R0, R0 * 0.26, 0.0, 0.0, PI_ * 2]); m(ctx, "fill"); m(ctx, "stroke")
	p(ctx, "fillStyle", "#c9a99a"); m(ctx, "beginPath"); m(ctx, "ellipse", [X, top, R0, R0 * 0.26, 0.0, 0.0, PI_ * 2]); m(ctx, "fill"); m(ctx, "stroke")
	p(ctx, "strokeStyle", "rgba(255,240,230,.25)"); p(ctx, "lineWidth", lw * 0.8); m(ctx, "beginPath"); m(ctx, "ellipse", [X, top, R0 * 0.78, R0 * 0.18, 0.0, PI_ * 1.1, PI_ * 1.6]); m(ctx, "stroke")
	if ok("op_mug"):
		var im = J.gp(_g("SPR"), "op_mug"); var mh = u * 0.09; var mw = mh * n_(J.gp(im, "naturalWidth")) / n_(J.gp(im, "naturalHeight")); m(ctx, "drawImage", [im, X - R0 * 0.45 - mw / 2, top - mh * 0.85, mw, mh])
	if ok("op_phone"):
		var im2 = J.gp(_g("SPR"), "op_phone"); var mh2 = u * 0.05; var mw2 = mh2 * n_(J.gp(im2, "naturalWidth")) / n_(J.gp(im2, "naturalHeight")); m(ctx, "drawImage", [im2, X + R0 * 0.3 - mw2 / 2, top - mh2 * 0.6, mw2, mh2])
	m(ctx, "restore")

# ---------- 接駁 ----------
func run(_env) -> void:
	LINES = {}
	var zh = {}
	for k in LINES_SRC:
		LINES[k] = []
		for pr in LINES_SRC[k]: LINES[k].append(pr[0]); zh[pr[0]] = pr[1]
	var LANG = _g("LANG")
	if LANG != null: m(LANG, "add", [zh])
	AP = {}
	for k in AP_SRC:
		var sh = []
		for r in AP_SRC[k].sh: sh.append([float(r[0]), float(r[1]), float(r[2]), float(r[3]), float(r[4])])
		var x0 = 1e9; var y0 = 1e9; var x1 = -1e9; var y1 = -1e9
		for r in sh: x0 = minf(x0, r[0]); y0 = minf(y0, r[1]); x1 = maxf(x1, r[0] + r[2]); y1 = maxf(y1, r[1] + r[3])
		AP[k] = {"sh": sh, "floor": AP_SRC[k].floor, "b": [x0, y0, x1 - x0, y1 - y0]}
	var OM = _g("OFFMAP")
	var SPOT = J.gp(OM, "SPOT")
	table = J.gp(SPOT, "restTable"); seats = J.gp(SPOT, "restSeats")
	NIGHT = null; CUT = {}; SHC = {}; DIMC = {}; st = null
	ORIG = {"drawBack": J.gp(OM, "drawBack"), "drawables": J.gp(OM, "drawables"), "tick": J.gp(OM, "tick"), "onProp": J.gp(OM, "onProp"), "init": J.gp(OM, "init")}
	p(OM, "init", func(this_, a): reset(); return J.cl(ORIG.init, this_, a))
	p(OM, "tick", func(this_, a): var r = J.cl(ORIG.tick, this_, a); tick(n_(J.arg(a, 0))); return r)
	p(OM, "drawBack", func(_t, a): draw_back(J.arg(a, 0), J.arg(a, 1)); return null)
	p(OM, "drawables", func(_t, _a): return drawables())
	p(OM, "onProp", func(this_, a):
		var k = J.str(J.arg(a, 0))
		if k in ["micro", "fridge", "vend", "water", "coffee"]: fx(k, J.arg(a, 1), false); return null
		return J.cl(ORIG.onProp, this_, a))
	J.G["Pantry"] = {
		"table": table, "seats": seats, "AP": AP, "_orig": ORIG,
		"fx": func(_t, a): fx(J.str(J.arg(a, 0)), J.arg(a, 1), false); return null,
		"use": func(_t, a): fx(J.str(J.arg(a, 0)), J.arg(a, 1), true); return null,
		"state": func(_t, _a):
			if st == null: return null
			return {"micro": st.micro != null, "coffee": st.coffee != null, "fridge": st.fridge != null, "water": st.water != null, "vend": st.vend != null, "items": float(st.items.size()), "puddles": float(st.puddles.size())},
	}
