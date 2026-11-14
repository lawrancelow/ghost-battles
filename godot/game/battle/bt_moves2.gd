# 主線戰鬥（原生）：專屬招式第二批——moves_spirit.js（Pontianak、水鬼、天花姐）、moves_chain.js（黑無常鎖魂鏈）
#  數值／時序逐句照 JS；本地座標「前方 = -x」（spirit）／「F 座標 +x = 往敵人」（MoveKit）
class_name BtMoves2

const D := PI / 180.0
const HIT := 0.4 + 0.2 * 0.42

static func table() -> Dictionary:
	return {"shuigui": mv_shuigui, "pontianak": mv_pontianak, "tianhua": mv_tianhua, "heiwu": mv_heiwu}

# ---------------- moves_spirit.js 共用 ----------------
static func eo(t: float) -> float: return 1 - (1 - t) * (1 - t)
static func ei(t: float) -> float: return t * t
static func eio(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func eo3(t: float) -> float: return 1 - pow(1 - t, 3)
static func back_out(t: float) -> float:
	var c = 1.7; return 1 + (c + 1) * pow(t - 1, 3) + c * pow(t - 1, 2)
static func cl(v: float, a := 0.0, b := 1.0) -> float: return clampf(v, a, b)
static func seg(g: float, a: float, b: float) -> float: return cl((g - a) / (b - a))
static func bump(g: float, a: float, m: float, b: float) -> float:
	if g < a or g > b: return 0.0
	return eo((g - a) / (m - a)) if g < m else 1 - eio((g - m) / (b - m))
static func rnd(s: float) -> float:
	var x = sin(s * 127.1 + 311.7) * 43758.5453; return x - floor(x)
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func prog(o: Dictionary) -> float:
	var p = cl(J.num(o.get("pt", 0)))
	match o.get("pose"):
		"windup": return 0.4 * p
		"strike": return 0.4 + 0.2 * p
		"follow": return 0.6
		"recover": return 0.6 + 0.4 * p
	return 0.0
static func foe(a: Dictionary, def: float) -> Dictionary:
	var o: Dictionary = a.o
	var f = (J.num(o.tdx) if a.faceRight else -J.num(o.tdx)) if o.get("tdx") != null else def * a.H
	f = maxf(f, a.H * 0.3)
	return {"x": -f, "y": J.num(o.get("tdy", 0)), "h": 58 * (a.s if a.s else a.H / 60)}
static func begin(ctx: Ctx, a: Dictionary) -> void:
	ctx.save(); ctx.translate(a.x, a.y)
	if a.faceRight: ctx.scale(-1, 1)
static func world_x(a: Dictionary, x: float) -> float: return a.x + (-x if a.faceRight else x)
static func float_y(a: Dictionary) -> float:
	return 0.0 if a.solid else -(3 + sin(J.num(a.o.get("t", 0)) * 2.4) * 2) * (a.s if a.s else a.H / 60)
static func pz(t: float, add := {}) -> Dictionary:
	var z = MeshAnim.idle(t); z.merge(add, true); return z
static func a_shadow(ctx: Ctx, a: Dictionary, cx: float, k := 0.0) -> void:
	var s: float = a.s
	Art.shadow(ctx, cx, a.y + 1 * s, s * (k if k != 0.0 else (1.0 if a.solid else 0.8)))
static func upright_begin(ctx: Ctx, a: Dictionary, x: float, y: float) -> void:
	ctx.save(); ctx.translate(x, y)
	if a.faceRight: ctx.scale(-1, 1)

static func path(ctx: Ctx, pts: Array) -> void:
	ctx.beginPath()
	for i in pts.size():
		if i: ctx.lineTo(pts[i].x, pts[i].y)
		else: ctx.moveTo(pts[i].x, pts[i].y)
static func crayon_line(ctx: Ctx, pts: Array, w: float, col, outline = null) -> void:
	ctx.lineCap = "round"; ctx.lineJoin = "round"
	if outline != null: ctx.strokeStyle = outline; ctx.lineWidth = w * 2.1; path(ctx, pts); ctx.stroke()
	ctx.strokeStyle = col; ctx.lineWidth = w; path(ctx, pts); ctx.stroke()

static func small_text(ctx: Ctx, a: Dictionary, x: float, y: float, txt: String, size: float, alpha: float, t: float) -> void:
	if alpha <= 0: return
	upright_begin(ctx, a, x, y)
	ctx.globalAlpha *= alpha; ctx.rotate(sin(t * 23) * 0.06 - 0.08)
	ctx.font = "900 %dpx sans-serif" % int(size); ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.lineJoin = "round"
	ctx.strokeStyle = Color("#2a1a22"); ctx.lineWidth = size * 0.28; ctx.strokeText(txt, 0, 0)
	ctx.fillStyle = Color("#fff3e8"); ctx.fillText(txt, 0, 0)
	ctx.restore()

static func puddle(ctx: Ctx, x: float, y: float, r: float, k: float, t: float, seed: float) -> void:
	if r <= 0.5: return
	var ry = r * 0.27
	var pp = func(rr: float, ryy: float):
		ctx.beginPath()
		for i in 41:
			var an = i / 40.0 * TAU; var j = 1 + 0.07 * sin(an * 5 + seed) + 0.04 * sin(an * 11 + seed * 2 + t * 3)
			var px = x + cos(an) * rr * j; var py = y + sin(an) * ryy * j
			if i: ctx.lineTo(px, py)
			else: ctx.moveTo(px, py)
		ctx.closePath()
	ctx.save(); ctx.globalAlpha *= k
	pp.call(r * 1.06, ry * 1.1); ctx.fillStyle = Color(12 / 255.0, 22 / 255.0, 28 / 255.0, 0.55); ctx.fill()
	pp.call(r, ry)
	var g = ctx.createRadialGradient(x, y, 0, x, y, r); g.addColorStop(0, "rgba(6,14,20,.97)"); g.addColorStop(0.7, "rgba(14,34,44,.94)"); g.addColorStop(1, "rgba(34,66,80,.88)")
	ctx.fillStyle = g; ctx.fill()
	ctx.strokeStyle = Color(130 / 255.0, 190 / 255.0, 205 / 255.0, 0.55); ctx.lineWidth = maxf(1, r * 0.035)
	for i in 2:
		var q = fmod(t * 0.9 + i * 0.5, 1.0); ctx.globalAlpha = k * (1 - q) * 0.8
		ctx.beginPath(); ctx.ellipse(x, y, r * (0.25 + 0.7 * q), ry * (0.25 + 0.7 * q), 0, 0, TAU); ctx.stroke()
	ctx.globalAlpha = k * 0.6; ctx.strokeStyle = Color(190 / 255.0, 230 / 255.0, 240 / 255.0, 0.5)
	ctx.beginPath(); ctx.ellipse(x - r * 0.25, y - ry * 0.35, r * 0.3, ry * 0.18, 0, PI * 1.1, PI * 1.8); ctx.stroke()
	ctx.restore()

static func splash(ctx: Ctx, x: float, y: float, size: float, q: float, n: int, seed: float, up := 0.0) -> void:
	if q <= 0 or q >= 1: return
	ctx.save()
	for i in n:
		var r1 = rnd(seed + i * 1.7); var r2 = rnd(seed + i * 3.3); var an = -PI / 2 + (r1 - 0.5) * (2.0 if up != 0.0 else 2.8); var sp = size * (0.6 + r2 * 0.9)
		var px = x + cos(an) * sp * q; var py = y + sin(an) * sp * q * (up if up != 0.0 else 1.0) + size * 1.6 * q * q; var rr = size * (0.018 + r2 * 0.02) * (1 - q * 0.4)
		if py > y + size * 0.03: continue
		ctx.globalAlpha = (1 - q) * 0.95
		ctx.fillStyle = Color(30 / 255.0, 60 / 255.0, 72 / 255.0, 0.9); ctx.beginPath(); ctx.ellipse(px, py, rr * 1.25, rr * 1.7, an + PI / 2, 0, TAU); ctx.fill()
		ctx.fillStyle = Color(160 / 255.0, 215 / 255.0, 230 / 255.0, 0.95); ctx.beginPath(); ctx.ellipse(px, py, rr, rr * 1.4, an + PI / 2, 0, TAU); ctx.fill()
		ctx.fillStyle = Color(1, 1, 1, 0.9); ctx.beginPath(); ctx.arc(px - rr * 0.3, py - rr * 0.4, rr * 0.35, 0, TAU); ctx.fill()
	ctx.restore()

static func drip(ctx: Ctx, x: float, y: float, size: float, q: float, _seed: float, rad := 0.0) -> void:
	if q <= 0 or q >= 1: return
	var py = y + size * 1.4 * q * q; var rr = rad if rad != 0.0 else size * 0.03
	ctx.save(); ctx.globalAlpha = 1 - q * 0.6; ctx.fillStyle = Color(30 / 255.0, 60 / 255.0, 72 / 255.0, 0.9); ctx.beginPath(); ctx.ellipse(x, py, rr * 1.2, rr * 1.8, 0, 0, TAU); ctx.fill()
	ctx.fillStyle = Color(165 / 255.0, 215 / 255.0, 232 / 255.0, 0.95); ctx.beginPath(); ctx.ellipse(x, py, rr * 0.9, rr * 1.4, 0, 0, TAU); ctx.fill(); ctx.restore()

static func streaks(ctx: Ctx, x: float, y0: float, y1: float, w: float, n: int, alpha: float, seed: float) -> void:
	if alpha <= 0: return
	ctx.save(); ctx.globalAlpha *= alpha; ctx.lineCap = "round"
	for i in n:
		var xx = x + (rnd(seed + i) - 0.5) * w; var a = y0 + (y1 - y0) * rnd(seed + i * 2.3) * 0.3; var b = y1 - (y1 - y0) * rnd(seed + i * 5.1) * 0.3
		ctx.strokeStyle = Color(40 / 255.0, 24 / 255.0, 40 / 255.0, 0.5); ctx.lineWidth = 4; ctx.beginPath(); ctx.moveTo(xx, a); ctx.lineTo(xx, b); ctx.stroke()
		ctx.strokeStyle = Color(1, 246 / 255.0, 230 / 255.0, 0.85); ctx.lineWidth = 1.8; ctx.beginPath(); ctx.moveTo(xx, a); ctx.lineTo(xx, b); ctx.stroke()
	ctx.restore()

static func dust(ctx: Ctx, x: float, y: float, size: float, q: float, n: int, seed: float) -> void:
	if q <= 0 or q >= 1: return
	ctx.save()
	for i in n:
		var r1 = rnd(seed + i); var r2 = rnd(seed + i * 2.7); var px = x + (r1 - 0.5) * size * (0.6 + q); var py = y + size * 0.8 * q * q * (0.5 + r2) - size * 0.15 * q
		ctx.globalAlpha = (1 - q) * 0.8; ctx.fillStyle = Color(205 / 255.0, 190 / 255.0, 170 / 255.0, 0.9) if i % 3 else Color(120 / 255.0, 100 / 255.0, 90 / 255.0, 0.9)
		ctx.beginPath(); ctx.arc(px, py, size * (0.012 + r2 * 0.02), 0, TAU); ctx.fill()
	ctx.restore()

static func slash(ctx: Ctx, x0: float, y0: float, x1: float, y1: float, w: float) -> void:
	var dx = x1 - x0; var dy = y1 - y0; var l = Vector2(dx, dy).length(); if l == 0: l = 1.0
	var nx = -dy / l * w; var ny = dx / l * w; var mx = (x0 + x1) / 2; var my = (y0 + y1) / 2
	ctx.beginPath(); ctx.moveTo(x0, y0); ctx.quadraticCurveTo(mx + nx * 2, my + ny * 2, x1, y1); ctx.quadraticCurveTo(mx - nx * 2, my - ny * 2, x0, y0); ctx.closePath()
	ctx.lineJoin = "round"; ctx.strokeStyle = Color(120 / 255.0, 10 / 255.0, 30 / 255.0, 0.75); ctx.lineWidth = w * 0.9; ctx.stroke(); ctx.fillStyle = Color("#fff4f2"); ctx.fill()

# 帶狀貼圖：原圖上一條（src 折線，像素座標、半寬 sw）沿畫面一條（dst 折線、半寬 wf(i)）貼過去（一個網格畫晒，唔使逐個三角形 clip）
static func _resample(pts: Array, n: int) -> Array:
	var L = [0.0]
	for i in range(1, pts.size()): L.append(L[i - 1] + pts[i].distance_to(pts[i - 1]))
	var tot = L[-1] if L[-1] != 0 else 1.0; var out = []; var j = 0
	for i in n:
		var s = tot * i / (n - 1)
		while j < pts.size() - 2 and L[j + 1] < s: j += 1
		var den = L[j + 1] - L[j]; var k = (s - L[j]) / (den if den != 0 else 1.0)
		out.append(pts[j].lerp(pts[j + 1], k))
	return [out, tot]
static func _normals(P: Array) -> Array:
	var out = []
	for i in P.size():
		var a = P[maxi(0, i - 1)]; var b = P[mini(P.size() - 1, i + 1)]; var d = b - a; var l = d.length()
		if l == 0: l = 1.0
		out.append(Vector2(-d.y / l, d.x / l))
	return out
static func ribbon(ctx: Ctx, tex: Texture2D, src: Array, sw: float, dst: Array, wf: Callable, stretch: float, depth: Callable) -> void:
	var R = _resample(src, 40); var SP: Array = R[0]; var per: float = R[1]; var SN = _normals(SP); var N = dst.size()
	if N < 2: return
	var iw = float(tex.get_width()); var ih = float(tex.get_height())
	var DN = _normals(dst); var acc = 0.0; var sp = []
	for i in N:
		if i: acc += dst[i].distance_to(dst[i - 1])
		var q = fmod(acc / stretch, 2 * per)
		if q > per: q = 2 * per - q
		var f = q / per * (SP.size() - 1); var j = mini(SP.size() - 2, int(floor(f))); var k = f - j
		var c = SP[j].lerp(SP[j + 1], k); var n = SN[j]
		sp.append([Vector2((c.x + n.x * sw) / iw, (c.y + n.y * sw) / ih), Vector2((c.x - n.x * sw) / iw, (c.y - n.y * sw) / ih)])
	# 按 depth 分兩批（1 同 <1）
	for pass_ in 2:
		var pts = PackedVector2Array(); var uvs = PackedVector2Array(); var idx = PackedInt32Array(); var dv = 1.0
		for i in N - 1:
			var dd: float = depth.call(i)
			if (dd >= 0.999) != (pass_ == 0): continue
			dv = dd
			var w0: float = wf.call(i); var w1: float = wf.call(i + 1); var d = dst[i]; var e = dst[i + 1]; var n0 = DN[i]; var n1 = DN[i + 1]
			var b = pts.size()
			pts.append_array([d + n0 * w0, d - n0 * w0, e + n1 * w1, e - n1 * w1])
			uvs.append_array([sp[i][0], sp[i][1], sp[i + 1][0], sp[i + 1][1]])
			idx.append_array([b, b + 1, b + 2, b + 1, b + 3, b + 2])
		if idx.size(): ctx.drawTriangles(tex, pts, uvs, idx, Color(1, 1, 1, dv))

# =================================================================
# 水鬼：自己沉落水；對手腳下冒黑水，手伸出嚟捉住、拖落去；再由自己個水窪浮返上嚟
static func mv_shuigui(ctx: Ctx, a: Dictionary) -> bool:
	if not BtMoves.ok("shuigui") or not BtMoves.ok("shuigui__arm"): return false
	var o: Dictionary = a.o; var H: float = a.H; var t = J.num(o.get("t", 0)); var g = prog(o); var F = foe(a, 0.68)
	var img = Spr.get_tex("shuigui"); var W = H * img.get_width() / img.get_height(); var Ht: float = F.h
	var sink = eio(seg(g, 0.04, 0.34)) if g < 0.6 else 1 - eo3(seg(g, 0.74, 0.98))
	var myP = bump(g, 0.0, 0.12, 1.0) * (1 - seg(g, 0.9, 1) if g > 0.9 else 1.0)
	var tp = eo(seg(g, 0.16, 0.42)) if g < 0.7 else 1 - eio(seg(g, 0.72, 0.96))
	var rise = back_out(seg(g, 0.40, HIT)) if g < HIT else 1.0; var pull = eio(seg(g, 0.53, 0.76))
	if sink < 0.95: a_shadow(ctx, a, a.x, 0.8 * (1 - sink))
	begin(ctx, a)
	puddle(ctx, 0, 0, H * 0.27 * eo(cl(myP * 1.6)), 1, t, 1.3)
	if sink < 0.995:
		ctx.save(); ctx.beginPath(); ctx.rect(-H * 3, -H * 4, H * 6, H * 4 + H * 0.01); ctx.clip()
		var dy = float_y(a) * (1 - sink) + sink * H * 1.02; var lean = 0.12 * sink if g < 0.6 else -0.1 * sink
		ctx.translate(0, dy); ctx.scale(-1, 1)
		MeshAnim.draw_body(ctx, "shuigui", "shuigui", H, pz(t, {"body": lean, "head": -0.1 * sink, "armB": -0.5 * sink, "armF": 0.4 * sink, "hairL": 0.3 * sink, "hairR": -0.3 * sink, "sy": 1 + 0.06 * sink, "sx": 1 - 0.04 * sink}))
		ctx.restore()
		if g > 0.74:
			for i in 6:
				var yy = -H * (0.25 + rnd(i * 2.1) * 0.5) * (1 - sink)
				drip(ctx, (rnd(i + 3) - 0.5) * W * 0.6, yy, -yy / 1.4, fmod((g - 0.74) * 4 + rnd(i * 5.3), 1.0), i, H * 0.016)
	splash(ctx, 0, 0, H * 0.5, seg(g, 0.2, 0.42), 7, 2.2)
	var tx: float = F.x; var ty: float = F.y; var rP = Ht * 0.4 * tp
	puddle(ctx, tx, ty + Ht * 0.01, rP, 1, t, 4.1)
	if g > 0.36 and g < 0.86:
		var arm = Spr.get_tex("shuigui__arm"); var k = 2.1; var PVx = 0.72; var PVy = 0.53; var len = (0.95 - PVx) * W * k
		var up = rise * (1 - pull * 0.85)
		var ang = (90 - 14 * cl(rise) + 10 * pull) * D
		var reachY = ty - Ht * 0.48
		var px = tx + Ht * 0.14 + cos(ang) * len; var py = lerp_(ty + len * 1.1, reachY + len * sin(ang), up)
		ctx.save(); ctx.beginPath(); ctx.rect(tx - Ht * 2, ty - Ht * 3, Ht * 4, Ht * 3 + Ht * 0.012); ctx.clip()
		ctx.save(); ctx.translate(px, py); ctx.rotate(ang); ctx.scale(-k, k)
		ctx.drawImage(arm, -PVx * W, -PVy * H, W, H)
		ctx.restore()
		var ux = -cos(ang); var uy = -sin(ang); var s0 = (py - ty) / -uy; var s1 = maxf(s0 + len * 0.25 * cl(up * 2), len * 0.3)
		if s1 > s0 + 1:
			var nx = -uy; var ny = ux; var pts = []
			for i in 9:
				var q = i / 8.0; var spp = lerp_(s0, s1, q); var w = Ht * (0.085 - 0.06 * q) * (1 + 0.15 * sin(t * 9 + i * 1.7)); pts.append(Vector2(px + ux * spp + nx * w, py + uy * spp + ny * w))
			for i in range(8, -1, -1):
				var q = i / 8.0; var spp = lerp_(s0, s1, q); var w = Ht * (0.085 - 0.06 * q) * (1 + 0.15 * sin(t * 9 + i * 2.3 + 1)); pts.append(Vector2(px + ux * spp - nx * w, py + uy * spp - ny * w))
			path(ctx, pts); ctx.closePath()
			ctx.fillStyle = Color(10 / 255.0, 26 / 255.0, 34 / 255.0, 0.88); ctx.fill(); ctx.strokeStyle = Color(130 / 255.0, 190 / 255.0, 205 / 255.0, 0.55); ctx.lineWidth = maxf(1, Ht * 0.012); ctx.stroke()
		ctx.restore()
		splash(ctx, tx + Ht * 0.12, ty, Ht * 0.8, seg(g, 0.40, 0.62), 12, 7.7)
		splash(ctx, tx, ty, Ht * 0.6, seg(g, 0.56, 0.8), 9, 12.9, 0.7)
		for i in 3: drip(ctx, tx + Ht * (0.06 + 0.06 * i), ty - Ht * 0.45 * up, Ht * 0.45 * up / 1.4, fmod((g - 0.45) * 3.5 + i / 3.0, 1.0), i + 20, Ht * 0.016)
	ctx.restore()
	return true

# Pontianak：長髮纏——三束長髮甩出去，捲住對手勒緊；佢尖叫住向前飄
const PT_SRC := [[0.30, 0.14], [0.22, 0.27], [0.15, 0.40], [0.11, 0.52], [0.11, 0.64], [0.15, 0.76]]
const PT_DEFS := [{"root": [0.27, 0.20], "h": 0.50, "turns": 1.25, "w": 0.075, "sh": 0.0, "ph": 0.0}, {"root": [0.24, 0.27], "h": 0.70, "turns": 1.1, "w": 0.068, "sh": -0.025, "ph": 1.7}, {"root": [0.22, 0.34], "h": 0.33, "turns": 1.0, "w": 0.062, "sh": 0.02, "ph": 3.1}]
static func mv_pontianak(ctx: Ctx, a: Dictionary) -> bool:
	if not BtMoves.ok("pontianak") or not MeshAnim.RIG.has("pontianak"): return false
	var o: Dictionary = a.o; var H: float = a.H; var t = J.num(o.get("t", 0)); var g = prog(o); var F = foe(a, 0.68)
	var img = Spr.get_tex("pontianak"); var iw = float(img.get_width()); var ih = float(img.get_height()); var W = H * iw / ih; var Ht: float = F.h
	var rear = eio(seg(g, 0.0, 0.34)); var go = eo3(seg(g, 0.32, HIT)); var bk = eio(seg(g, 0.66, 1))
	var fwd = minf(H * 0.22, maxf(0, -F.x - H * 0.55))
	var dx = (H * 0.06 * rear * (1 - go) - (fwd + H * 0.04) * go) * (1 - bk); var dy = float_y(a) - H * (0.05 * rear + 0.04 * go) * (1 - bk)
	var shake = sin(t * 60) * H * 0.006 if g > 0.22 and g < 0.66 else 0.0
	var ps = pz(t, {"body": (0.10 * rear - 0.16 * go) * (1 - bk), "head": (-0.14 * rear - 0.06 * go) * (1 - bk), "hairL": (0.35 * rear - 0.25 * go) * (1 - bk), "hairR": (-0.3 * rear + 0.2 * go) * (1 - bk),
		"armF": (0.4 * rear) * (1 - bk), "armB": (-0.4 * rear) * (1 - bk), "sy": 1 + 0.04 * rear - 0.03 * go, "sx": 1 - 0.03 * rear + 0.03 * go})
	a_shadow(ctx, a, world_x(a, dx), 0.8)
	begin(ctx, a)
	var ox = dx + shake; var oy = dy
	var P = func(fx: float, fy: float) -> Vector2: return Vector2(ox + (fx - 0.5) * W, oy - H + fy * H)
	var ext = eo(seg(g, 0.37, HIT)) if g < HIT else (1.0 if g < 0.64 else 1 - eio(seg(g, 0.64, 0.92)))
	var sq = bump(g, HIT, 0.52, 0.66)
	var strands = []
	if ext > 0.01:
		var C = Vector2(F.x, F.y); var rx0 = Ht * 0.2 * (1 - 0.2 * sq)
		for kk in PT_DEFS.size():
			var d = PT_DEFS[kk]
			var r0 = P.call(d.root[0], d.root[1]); var cy = C.y - Ht * d.h; var rx = rx0 * (1 - kk * 0.06); var ry = Ht * 0.055
			var s0 = Vector2(C.x - rx, cy); var c1 = Vector2(r0.x - H * 0.12, r0.y - H * (0.32 + 0.07 * kk)); var c2 = Vector2(C.x - rx * 1.6, C.y - Ht * (1.15 + 0.05 * kk)); var app = []
			for i in 27:
				var u = i / 26.0; var v = 1 - u
				app.append(v * v * v * r0 + 3 * u * v * v * c1 + 3 * u * u * v * c2 + u * u * u * s0)
			var wrap = []; var NT = int(round(28 * d.turns))
			for i in range(1, NT + 1):
				var an = PI - float(i) / NT * d.turns * TAU; wrap.append(Vector2(C.x + rx * cos(an), cy + ry * sin(an) - Ht * 0.06 * (float(i) / NT * d.turns)))
			var full = app + wrap; var dep = []
			for i in full.size():
				var p = full[i]
				if i < app.size(): dep.append(0.4 if p.x < C.x + rx * 0.2 and p.y > C.y - Ht * 1.0 else 1.0)
				else: dep.append(1.0 if sin(PI - float(i - app.size() + 1) / NT * d.turns * TAU) >= 0 else 0.4)
			var n = full.size(); var show = maxi(2, int(round(n * ext)))
			var pts = []
			for i in show:
				var p = full[i]
				if i < app.size():
					var u = float(i) / app.size(); var wv = sin(u * PI * 2.2 - t * 14 + d.ph) * H * 0.07 * (1 - ext * 0.85) * sin(u * PI); p = Vector2(p.x, p.y + wv)
				pts.append(p)
			var src = []
			for q in PT_SRC: src.append(Vector2((q[0] + d.sh) * iw, q[1] * ih))
			strands.append({"pts": pts, "dep": dep, "w": H * d.w, "src": src})
	var draw_strand = func(s: Dictionary, from: int, to: int):
		var sg = s.pts.slice(from, to + 1)
		if sg.size() < 2: return
		var n = s.pts.size()
		ribbon(ctx, img, s.src, iw * 0.06, sg, func(i): var u = float(from + i) / maxi(1, n - 1); return s.w * (0.95 - 0.5 * u) * (0.75 + u * 5 if u < 0.05 else 1.0), H / ih * 1.3,
			func(i): return s.dep[from + i] if from + i < s.dep.size() else 1.0)
	for s in strands: draw_strand.call(s, 0, mini(s.pts.size() - 1, 6))
	ctx.save(); ctx.translate(ox, oy); MeshAnim.draw_body(ctx, "pontianak", "pontianak", H, ps); ctx.restore()
	for s in strands: draw_strand.call(s, mini(s.pts.size() - 1, 6), s.pts.size() - 1)
	var sk = bump(g, 0.2, 0.36, 0.7)
	if sk > 0:
		var m = P.call(0.43, 0.29)
		for i in 3:
			var q = fmod((g - 0.2) * 4.2 + i / 3.0, 1.0); var r = H * (0.1 + 0.5 * q)
			var pts = []
			for j in 17:
				var an = PI + (j / 16.0 - 0.5) * 1.5; var rr = r * (1 + 0.012 * sin(j * 1.3 + t * 40)); pts.append(Vector2(m.x + cos(an) * rr, m.y + sin(an) * rr))
			ctx.save(); ctx.globalAlpha *= sk * minf(1, (1 - q) * 1.6); crayon_line(ctx, pts, maxf(2, H * 0.024), Color("#f4f8ff"), Color(40 / 255.0, 24 / 255.0, 70 / 255.0, 0.7)); ctx.restore()
	ctx.restore()
	return true

# 天花姐：扶腰「哎喲」→ 蹬上天花板 → 倒掛由對手頭上垂落嚟一爪 → 縮返上去 → 跌返原位
static func mv_tianhua(ctx: Ctx, a: Dictionary) -> bool:
	if not BtMoves.ok("tianhua") or not BtMoves.ok("tianhua_hang"): return false
	var o: Dictionary = a.o; var H: float = a.H; var t = J.num(o.get("t", 0)); var g = prog(o); var F = foe(a, 1.9); var Ht: float = F.h
	var hang = Spr.get_tex("tianhua_hang"); var hh = H * 645 / 577.0; var hw = hh * hang.get_width() / hang.get_height()
	var OUT = H * 5
	var gy = null; var ps = null; var ouch = 0.0
	if g < 0.32:
		var crouch = eo(seg(g, 0.0, 0.14)); var jump = ei(seg(g, 0.15, 0.32))
		gy = -OUT * jump; ouch = bump(g, 0.0, 0.05, 0.22)
		ps = {"body": 0.18 * crouch * (1 - jump), "head": 0.12 * crouch, "sy": 1 - 0.1 * crouch * (1 - jump) + 0.25 * jump, "sx": 1 + 0.06 * crouch * (1 - jump) - 0.12 * jump, "y": 0.02 * crouch * (1 - jump)}
	elif g > 0.8:
		var fall = seg(g, 0.8, 0.9); var land = seg(g, 0.9, 1)
		gy = -OUT * 0.5 * (1 - ei(fall)); ouch = bump(g, 0.9, 0.93, 1.0) + 0.001 if g > 0.9 else 0.0
		var sq = sin(land * PI) * (1 - land * 0.5) if g > 0.9 else 0.0
		ps = {"body": 0.22 * sq, "head": 0.15 * sq, "sy": 1 - 0.16 * sq + (0.12 if g < 0.9 else 0.0), "sx": 1 + 0.1 * sq - (0.06 if g < 0.9 else 0.0), "y": 0.02 * sq}
	if gy != null: a_shadow(ctx, a, a.x, maxf(0.2, 1 + gy / (H * 1.5)))
	var claw = Vector2(-(0.82 - 0.72) * hw, 0.86 * hh)
	var ax = F.x + Ht * 0.04 - claw.x; var ay = F.y - Ht * 0.86 - claw.y
	var hy = null; var sw = 0.0
	if g >= 0.38 and g <= 0.8:
		var drop = back_out(seg(g, 0.38, HIT)); var up = ei(seg(g, 0.64, 0.8))
		hy = ay - OUT * (1 - drop) - OUT * up
		sw = -26 * seg(g, 0.38, HIT) if g < HIT else (lerp_(-26, 30, eo3(seg(g, HIT - 0.03, 0.58))) if g < 0.6 else lerp_(30, 0, eio(seg(g, 0.6, 0.7))))
		if g < HIT: sw = -26 * eo(seg(g, 0.4, 0.46)) + 26 * ei(seg(g, 0.46, HIT)) * 0.9
	if hy != null: a_shadow(ctx, a, a.x + (-1.0 if a.faceRight else 1.0) * ax, 0.5)
	begin(ctx, a)
	if gy != null:
		ctx.save(); ctx.translate(0, gy + float_y(a)); MeshAnim.draw_body(ctx, "tianhua", "tianhua", H, pz(t, ps)); ctx.restore()
		if g > 0.14 and g < 0.34: streaks(ctx, 0, gy - H * 0.2, gy + H * 1.2, H * 0.5, 7, seg(g, 0.14, 0.2) * (1 - seg(g, 0.3, 0.34)), 5)
		if g > 0.8 and g < 0.92: streaks(ctx, 0, gy - H * 1.6, gy - H * 0.9, H * 0.5, 6, 0.8, 9)
		dust(ctx, 0, 0, H * 0.6, seg(g, 0.15, 0.4), 8, 3.3)
		dust(ctx, 0, 0, H * 0.6, seg(g, 0.9, 1.0), 8, 6.1)
		if ouch > 0: small_text(ctx, a, H * 0.2, gy - H * 1.08, J.str(DB.L("哎喲")), H * 0.2, minf(1, ouch * 2), t)
	dust(ctx, F.x, F.y - Ht * 2.1, Ht * 1.2, seg(g, 0.27, 0.45), 9, 14.2)
	if hy != null:
		var topY: float = hy
		if g < HIT + 0.04: streaks(ctx, ax, topY - H * 1.6, topY + hh * 0.4, hw * 0.7, 8, seg(g, 0.38, 0.42) * (1 - seg(g, HIT, HIT + 0.04)), 2)
		if g > 0.64: streaks(ctx, ax, topY - H * 0.3, topY + hh * 0.9, hw * 0.7, 8, (1 - seg(g, 0.74, 0.8)), 4)
		dust(ctx, ax, ay, H * 0.9, seg(g, HIT - 0.02, 0.7), 10, 8.8)
		ctx.save(); ctx.translate(ax, hy); ctx.rotate(sw * D + sin(t * 3) * 0.03)
		ctx.scale(-1, 1)
		ctx.drawImage(hang, -0.72 * hw, 0, hw, hh)
		ctx.restore()
		var ck = bump(g, HIT - 0.01, HIT + 0.02, 0.62)
		if ck > 0:
			ctx.save(); ctx.globalAlpha *= ck; var cx = F.x + Ht * 0.02; var cy = F.y - Ht * 0.78
			var grow = eo(seg(g, HIT - 0.01, HIT + 0.03))
			for i in range(-1, 2): slash(ctx, cx + Ht * (0.08 + i * 0.055), cy - Ht * 0.12, cx + Ht * (0.08 + i * 0.055) + (Ht * (-0.1)) * grow, cy - Ht * 0.12 + Ht * 0.3 * grow, Ht * 0.014)
			ctx.restore()
	ctx.restore()
	return true

# 黑無常：鎖魂鏈（moves_chain.js）
static func mv_heiwu(ctx: Ctx, a: Dictionary) -> bool:
	var S = BtMoves.setup(a)
	if S == null or not BtMoves.ok("heiwu__wpn"): return false
	var wp = Limbs.WP.get("iron_chain")
	if wp == null: return false
	var tt: float = S.tt; var H: float = S.H; var th: float = S.th
	var PV: Array = S.C.pivot; var GR: Array = S.C.grip; var TP: Array = S.C.tip
	var kW = BtMoves.eo(BtMoves.seg(tt, 0, 0.15)); var kL = BtMoves.eo3(BtMoves.seg(tt, 0.15, 0.22)); var kY = BtMoves.eback(BtMoves.seg(tt, 0.345, 0.40)); var kR = BtMoves.eio(BtMoves.seg(tt, 0.46, 0.59))
	var lean = -9 * kW; var bdx = -0.03 * kW
	lean = lerp_(lean, 8, kL); bdx = lerp_(bdx, 0.035, kL)
	lean = lerp_(lean, -13, kY); bdx = lerp_(bdx, -0.05, kY)
	lean *= 1 - kR; bdx *= 1 - kR
	var shake = sin(tt * 260) * 0.004 * H if tt > 0.36 and tt < 0.46 else 0.0
	var bp = BtMoves.ip(S, 0.5, 0.78)
	var bm = BtMoves.mt(bdx * H + shake, -S.fl) * BtMoves.mt(bp.x, bp.y) * BtMoves.mr(lean * D) * BtMoves.mt(-bp.x, -bp.y)
	var fx = lerp_(0, -0.05, kW); var fy = lerp_(0, -0.11, kW); var fr = lerp_(0, -25, kW)
	fx = lerp_(fx, 0.05, kL); fy = lerp_(fy, -0.05, kL); fr = lerp_(fr, 15, kL)
	fx = lerp_(fx, -0.06, kY); fy = lerp_(fy, 0.03, kY); fr = lerp_(fr, -10, kY)
	fx *= 1 - kR; fy *= 1 - kR; fr *= 1 - kR
	var pv = BtMoves.ip(S, PV[0], PV[1])
	var fm = bm * BtMoves.mt(pv.x + fx * H, pv.y + fy * H) * BtMoves.mr(fr * D)
	var G = BtMoves.ppt(S, fm, PV[0], PV[1], GR[0], GR[1])
	var img = Spr.get_tex("heiwu__wpn"); var ih = float(img.get_height()); var upx = J.num(wp.h) * H / ih
	var R0 = 0.098 * ih; var RH = 0.4126 * ih; var RT = 0.6084 * ih; var RE = 0.979 * ih; var PER = RT - RH
	var Lr = (RE - R0) * upx
	var restTip = BtMoves.ip(S, TP[0], TP[1]); var restG = BtMoves.ip(S, GR[0], GR[1])
	var a0 = atan2(restTip.y - restG.y, restTip.x - restG.x)
	var bk = BtMoves.tgt_back(tt, th)
	var tight = 1 - 0.16 * BtMoves.esin(BtMoves.seg(tt, 0.345, 0.40)) * (1 - BtMoves.seg(tt, 0.44, 0.48))
	var cx = S.tx + bk; var yc0 = S.ty - 0.60 * th; var rx = 0.205 * th * tight; var ry = 0.06 * th * tight; var pitch = 0.075 * th
	var Tn = Vector2(cx + rx, yc0)
	var aT = atan2(Tn.y - G.y, Tn.x - G.x) + TAU; var dT = Tn.distance_to(G)
	var pts = []
	var polar = func(an: float, Rr: float, lag: float, wave: float):
		for i in 27:
			var f = i / 26.0; var A = an - lag * pow(f, 1.4); var w = wave * sin(f * 9 - tt * 70) * f * (1 - f) * 4
			pts.append(Vector3(G.x + cos(A) * Rr * f - sin(A) * w, G.y + sin(A) * Rr * f + cos(A) * w, 0))
	if tt < 0.15:
		var q = BtMoves.eio(BtMoves.seg(tt, 0, 0.15)); polar.call(lerp_(a0, a0 + 2.65, q), Lr, 0.9 * sin(q * PI), 0.02 * H)
	elif tt < 0.27:
		var q = BtMoves.eo(BtMoves.seg(tt, 0.15, 0.27)); var qa = BtMoves.esin(BtMoves.seg(tt, 0.15, 0.27)) * 0.5 + q * 0.5
		var s0 = Vector2(G.x + cos(a0 + 2.65) * Lr, G.y + sin(a0 + 2.65) * Lr)
		var c1 = Vector2(maxf(G.x, Tn.x) + 0.22 * H, minf(G.y, Tn.y) - 0.75 * H)
		var tip = (1 - qa) * (1 - qa) * s0 + 2 * (1 - qa) * qa * c1 + qa * qa * Tn
		var mid = (G + tip) / 2; var ctl = mid.lerp(c1, 0.55 * (1 - q))
		for i in 31:
			var f = i / 30.0; var w = 0.03 * H * (1 - q) * sin(f * 10 - tt * 80) * sin(f * PI)
			var p = (1 - f) * (1 - f) * G + 2 * (1 - f) * f * ctl + f * f * tip
			pts.append(Vector3(p.x, p.y + w, 0))
	elif tt < 0.53:
		var sag = 0.05 * H * (1 - BtMoves.eo(BtMoves.seg(tt, 0.33, 0.37))) + (0.06 * H * BtMoves.seg(tt, 0.46, 0.53) if tt > 0.46 else 0.0)
		var vib = 0.006 * H * sin(tt * 300) if tt > 0.355 and tt < 0.47 else 0.0
		for i in 23:
			var f = i / 22.0; pts.append(Vector3(lerp_(G.x, Tn.x, f), lerp_(G.y, Tn.y, f) + sag * 4 * f * (1 - f) + vib * sin(f * PI * 3), 0))
		var umax = 2.5 * TAU * (BtMoves.eo(BtMoves.seg(tt, 0.27, 0.345)) if tt < 0.46 else 1 - BtMoves.ei(BtMoves.seg(tt, 0.46, 0.53)))
		var n = int(ceil(umax / (PI / 12)))
		for i in range(1, n + 1):
			var u = minf(umax, i * PI / 12); var j = sin(tt * 220 + i) * 0.006 * th if tt > 0.36 and tt < 0.45 else 0.0
			pts.append(Vector3(cx + cos(u) * rx + j, yc0 + u / TAU * pitch + sin(u) * ry, 1 if sin(u) < -0.05 else 0))
	else:
		var q = BtMoves.eo3(BtMoves.seg(tt, 0.53, 0.59)); polar.call(lerp_(aT - TAU, a0, q), lerp_(dT, Lr, q), -0.8 * sin(q * PI), 0.04 * H * (1 - q))
	ctx.save(); BtMoves.enter(ctx, S)
	BtMoves.shadow(ctx, S, bdx * H, 0)
	BtMoves.body(ctx, S, bm, BtMoves.pose(S, {"head": lean * -0.004}))
	_chain(ctx, pts, img, upx, [R0, RH, RT, RE, PER])
	BtMoves.piece(ctx, S, "heiwu__arm", fm, PV[0], PV[1])
	if tt > 0.17 and tt < 0.27:
		var p = pts[-1]; var q = pts[-4]; BtMoves.speed(ctx, p.x, p.y, p.x - q.x, p.y - q.y, 0.16 * H, 0.06 * H, 1, "rgba(235,235,245,.8)", 3)
	var hk = 1 - BtMoves.seg(tt, BtMoves.TC, BtMoves.TC + 0.12)
	if tt >= BtMoves.TC and hk > 0: BtMoves.burst(ctx, Tn.x, Tn.y, 0.16 * th, hk, "#fff2c0", 11)
	if tt > 0.345 and tt < 0.47:
		var k = sin(BtMoves.seg(tt, 0.345, 0.47) * PI)
		for i in 3:
			var yy = yc0 + (i - 1) * 0.12 * th; BtMoves.speed(ctx, cx - rx * 1.2, yy, -1, 0.05 * (i - 1), 0.12 * H, 0.03 * H, k * 0.9, "rgba(255,240,200,.85)", 20 + i, 2)
		BtMoves.burst(ctx, cx, yc0 + pitch, 0.30 * th, k * 0.6, "rgba(210,230,255,.9)", 41, 7)
	ctx.restore()
	return true

# 沿路徑貼原圖鏈節：一個網格畫晒（JS 係逐片 drawImage）；喺敵人背後嗰幾段（z=1）JS 用 evenodd clip 擋，Ctx 本身唔支援，照畫
static func _chain(ctx: Ctx, P: Array, img: Texture2D, upx: float, R: Array) -> void:
	var R0: float = R[0]; var RH: float = R[1]; var RT: float = R[2]; var RE: float = R[3]; var PER: float = R[4]
	var iw = float(img.get_width()); var ih = float(img.get_height()); var cxp = 0.43 * iw
	var cum = [0.0]
	for i in range(1, P.size()): cum.append(cum[i - 1] + Vector2(P[i].x, P[i].y).distance_to(Vector2(P[i - 1].x, P[i - 1].y)))
	var Lu: float = cum[-1]
	if Lu < 1: return
	var Lpx = Lu / upx; var head = RH - R0; var tail = RE - RT; var n = maxi(0, int(round((Lpx - head - tail) / PER))); var texL = head + tail + n * PER; var k = texL / Lpx
	var step = PER / 6.0; var j = 0
	var pts = PackedVector2Array(); var uvs = PackedVector2Array(); var idx = PackedInt32Array()
	var tx = 0.0
	while tx < texL - 0.01:
		var st = minf(step, texL - tx)
		var row = R0 + tx if tx < head else (RH + fmod(tx - head, PER) if tx < head + n * PER else RT + (tx - head - n * PER))
		var s0 = tx / k * upx; var s1 = (tx + st) / k * upx
		var ps = []
		for s in [s0, s1]:
			while j < cum.size() - 2 and cum[j + 1] < s: j += 1
			while j > 0 and cum[j] > s: j -= 1
			var l = cum[j + 1] - cum[j]; if l == 0: l = 1.0
			var f = clampf((s - cum[j]) / l, 0, 1)
			ps.append(Vector2(P[j].x + (P[j + 1].x - P[j].x) * f, P[j].y + (P[j + 1].y - P[j].y) * f))
		var p0: Vector2 = ps[0]; var p1: Vector2 = ps[1]
		var an = atan2(p1.y - p0.y, p1.x - p0.x) - PI / 2; var len = p0.distance_to(p1)
		var X = Transform2D(an, p0)
		var sh = minf(st + 0.8, ih - row)
		var x0 = -cxp * upx; var x1 = x0 + iw * upx; var y1 = len + 0.8 * upx
		var b = pts.size()
		pts.append_array([X * Vector2(x0, 0), X * Vector2(x1, 0), X * Vector2(x1, y1), X * Vector2(x0, y1)])
		uvs.append_array([Vector2(0, row / ih), Vector2(1, row / ih), Vector2(1, (row + sh) / ih), Vector2(0, (row + sh) / ih)])
		idx.append_array([b, b + 1, b + 2, b, b + 2, b + 3])
		tx += step
	ctx.drawTriangles(img, pts, uvs, idx)
