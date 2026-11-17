# 主線／夜班（原生）：活人 NPC 專屬招式——保安阿伯、清潔安娣、陳總（照 moves_spirit.js 逐行移植）
# 共用小工具用 BtMoves2（同一個 js 檔）；本地座標「原圖面朝左」：往前 = -x，往上 = -y，原點 = 自己腳下
extends RefCounted   # 冇 class_name（新增 class_name 要重建全局類別快取）：用 preload 叫

const D := PI / 180.0
const HIT := 0.4 + 0.2 * 0.42
const M2 := preload("res://game/battle/bt_moves2.gd")
const BOSS_HITS := [HIT, 0.6, 0.72]
const GD := {"PV": [0.882, 0.4565], "TIP": [0.752, 0.725]}
const LEANY := 0.3
const FONT := "\"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",sans-serif"

static func table() -> Dictionary: return {"npc_guard": mv_npc_guard, "npc_auntie": mv_npc_auntie, "npc_boss": mv_npc_boss}

static func rot(x: float, y: float, a: float) -> Vector2: return Vector2(x * cos(a) - y * sin(a), x * sin(a) + y * cos(a))
static func world(a: Dictionary, x: float, y: float) -> Array: return [a.x + (-x if a.faceRight else x), a.y + y]
static func ok(k: String) -> bool: return Spr.ok(k)
static func _sh(ctx: Ctx, a: Dictionary, cx: float) -> void:
	if a.get("shadow") != null: J.cl(a.shadow, null, [cx])
	else: M2.a_shadow(ctx, a, cx)
static func pz(t: float, add: Dictionary) -> Dictionary:
	var z = J.cl(J.gp(J.gp(J.G.MeshAnim, "ANIM"), "idle"), null, [t]) if J.G.get("MeshAnim") != null else MeshAnim.idle(t)
	for k in add: z[k] = add[k]
	return z
static func npc_body(ctx: Ctx, type: String, key: String, H: float, t: float, add: Dictionary) -> void:
	var b = {"armF": 0.0, "armB": 0.0, "y": 0.0}
	for k in add: b[k] = add[k]
	var MA = J.G.get("MeshAnim")
	if MA != null and J.gp(MA, "drawBody") != null: J.mc(MA, "drawBody", [ctx, type, key, H, pz(t, b)])
	else: MeshAnim.draw_body(ctx, type, key, H, pz(t, b))
static func piece(ctx: Ctx, key: String, W: float, H: float, pv: Array, at, ang: float, sx := 0.0) -> void:
	ctx.save(); ctx.translate(at[0], at[1]); ctx.rotate(ang)
	if sx: ctx.scale(sx, sx)
	ctx.drawImage(Spr.get_tex(key), -pv[0] * W, -pv[1] * H, W, H); ctx.restore()
static func body_xf(H: float, lean: float, dx: float, dy: float, x: float, y: float) -> Array:
	var p = rot(x, y + H * LEANY, lean); return [p.x + dx, p.y - H * LEANY + dy]
static func push_body(ctx: Ctx, H: float, lean: float, dx: float, dy: float) -> void:
	ctx.translate(dx, dy); ctx.translate(0, -H * LEANY); ctx.rotate(lean); ctx.translate(0, H * LEANY)
static func V(p) -> Vector2: return Vector2(p[0], p[1])
static func line(ctx: Ctx, pts: Array, w: float, col, outline = null) -> void:
	var vv = []
	for p in pts: vv.append(V(p))
	M2.crayon_line(ctx, vv, w, col, outline)
static func upright(ctx: Ctx, a: Dictionary, x: float, y: float) -> void:
	ctx.save(); ctx.translate(x, y)
	if a.faceRight: ctx.scale(-1, 1)
static func small_text(ctx: Ctx, a: Dictionary, x: float, y: float, txt: String, size: float, alpha: float, t: float) -> void:
	if alpha <= 0: return
	upright(ctx, a, x, y)
	ctx.globalAlpha *= alpha; ctx.rotate(sin(t * 23) * 0.06 - 0.08)
	ctx.font = "900 %spx \"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",sans-serif" % J.str(size); ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.lineJoin = "round"
	ctx.strokeStyle = "#2a1a22"; ctx.lineWidth = size * 0.28; ctx.strokeText(txt, 0, 0)
	ctx.fillStyle = "#fff3e8"; ctx.fillText(txt, 0, 0)
	ctx.restore()

# 「鏗！」金屬聲
static func clank(ctx: Ctx, a: Dictionary, x: float, y: float, size: float, k: float, r: float) -> void:
	if k <= 0: return
	upright(ctx, a, x, y)
	var s = 0.6 + 0.55 * M2.back_out(minf(1, k * 1.8)); ctx.scale(s, s); ctx.rotate(r)
	ctx.globalAlpha *= minf(1, (1 - k) * 4)
	ctx.font = "900 %spx %s" % [J.str(size), FONT]; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.lineJoin = "round"
	ctx.strokeStyle = "#2a1608"; ctx.lineWidth = size * 0.2; ctx.strokeText("鏗！", 0, 0)
	var gr = ctx.createLinearGradient(0, -size * 0.5, 0, size * 0.5); gr.addColorStop(0, "#fffbe6"); gr.addColorStop(1, "#ffc93a"); ctx.fillStyle = gr; ctx.fillText("鏗！", 0, 0)
	ctx.restore()

static func burst(ctx: Ctx, x: float, y: float, r: float, k: float, seed: float) -> void:
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= 1 - k; ctx.lineCap = "round"
	for i in 8:
		var an = i / 8.0 * PI * 2 + seed; var r0 = r * (0.35 + 0.5 * k); var r1 = r * (0.75 + 0.6 * k) * (0.75 if i % 2 else 1.0)
		line(ctx, [[x + cos(an) * r0, y + sin(an) * r0], [x + cos(an) * r1, y + sin(an) * r1]], maxf(2, r * 0.09), "#fff3c4", "rgba(60,30,10,.75)")
	ctx.restore()

static func star(ctx: Ctx, x: float, y: float, r: float, an0: float) -> void:
	ctx.save(); ctx.translate(x, y); ctx.rotate(an0); ctx.beginPath()
	for i in 10:
		var an = i / 10.0 * PI * 2; var rr = r * 0.45 if i % 2 else r; ctx.lineTo(cos(an) * rr, sin(an) * rr)
	ctx.closePath(); ctx.lineJoin = "round"; ctx.strokeStyle = "#3a2410"; ctx.lineWidth = r * 0.35; ctx.stroke(); ctx.fillStyle = "#ffd84a"; ctx.fill(); ctx.restore()

static func tea_drops(ctx: Ctx, x: float, y: float, vx: float, vy: float, size: float, q: float, n: int, seed: float) -> void:
	if q <= 0 or q >= 1: return
	ctx.save()
	for i in n:
		var r1 = M2.rnd(seed + i * 1.9); var r2 = M2.rnd(seed + i * 4.1); var sp = 0.55 + r1 * 0.8; var sd = (r2 - 0.5) * 0.9
		var px = x + (vx * sp - vy * sd) * size * q; var py = y + (vy * sp + vx * sd) * size * q + size * 1.3 * q * q; var rr = size * (0.022 + r2 * 0.022) * (1 - q * 0.35)
		ctx.globalAlpha = minf(1, (1 - q) * 1.6)
		var an = atan2(vy + 2.6 * q, vx)
		ctx.fillStyle = "#4a2a10"; ctx.beginPath(); ctx.ellipse(px, py, rr * 1.7, rr * 1.15, an, 0, PI * 2); ctx.fill()
		ctx.fillStyle = "#c98a2e"; ctx.beginPath(); ctx.ellipse(px, py, rr * 1.35, rr * 0.82, an, 0, PI * 2); ctx.fill()
		ctx.fillStyle = "rgba(255,240,200,.9)"; ctx.beginPath(); ctx.arc(px - rr * 0.3, py - rr * 0.3, rr * 0.3, 0, PI * 2); ctx.fill()
	ctx.restore()

static func steam(ctx: Ctx, x: float, y: float, size: float, q: float, seed: float) -> void:
	if q <= 0 or q >= 1: return
	ctx.save(); ctx.globalAlpha *= (1 - q) * 0.8
	for k in 2:
		var pts = []
		for i in 11:
			var u = i / 10.0; pts.append([x + sin(u * 5 + seed + k * 2 + q * 6) * size * 0.12 + (k - 0.5) * size * 0.16, y - u * size * (0.5 + q * 0.6) - q * size * 0.2])
		line(ctx, pts, maxf(1.5, size * 0.05), "rgba(250,246,240,.9)", "rgba(60,50,60,.35)")
	ctx.restore()

# 蠟筆字（粗、紅金漸層、深色外框），畫喺細畫布快取
# 網頁版再用 source-atop 喺字入面撒顆粒同一條高光；Godot 畫布冇呢種混合（會撒成成個正方形），呢度唔畫嗰兩層
static var GLY := {}
static func glyph(ch: String, c1: String, c2: String):
	var key = ch + c1 + c2
	if GLY.has(key): return GLY[key]
	var S = 168.0; var c = J.S_document_("createElement", ["canvas"]); J.sp(c, "width", S); J.sp(c, "height", S); var x = J.mc(c, "getContext", ["2d"])
	var font = "900 120px \"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",\"Heiti TC\",sans-serif"
	x.font = font; x.textAlign = "center"; x.textBaseline = "middle"; x.lineJoin = "round"; x.lineCap = "round"
	x.strokeStyle = "#2a120c"; x.lineWidth = 24; x.strokeText(ch, S / 2 + 3, S / 2 + 6)
	x.lineWidth = 19; x.strokeText(ch, S / 2 - 1, S / 2 + 2)
	var c2_ = J.S_document_("createElement", ["canvas"]); J.sp(c2_, "width", S); J.sp(c2_, "height", S); var y = J.mc(c2_, "getContext", ["2d"])
	y.font = font; y.textAlign = "center"; y.textBaseline = "middle"
	var g = y.createLinearGradient(0, S * 0.18, 0, S * 0.85); g.addColorStop(0, c1); g.addColorStop(1, c2); y.fillStyle = g; y.fillText(ch, S / 2, S / 2 + 2)
	x.drawImage(c2_, 0, 0); GLY[key] = c; return c

# ======================================================================
# 保安阿伯：轉身背對對手，反手用保溫瓶底「鏗！」敲對手臉，茶濺出嚟；再慢慢轉返嚟
# ======================================================================
static func mv_npc_guard(ctx: Ctx, a: Dictionary) -> bool:
	if not ok("npc_guard__bodyC") or not ok("npc_guard__club"): return false
	var o: Dictionary = a.o; var H: float = a.H; var t = J.num(o.get("t")) if J.t(o.get("t")) else 0.0; var g = M2.prog(o); var F = M2.foe(a, 0.68)
	var img = Spr.get_tex("npc_guard__bodyC"); var W = H * img.get_width() / float(img.get_height()); var Ht: float = F.h
	var PV: Array = GD.PV; var TIP: Array = GD.TIP
	var pv = [(PV[0] - 0.5) * W, -H + PV[1] * H]; var vT = [(TIP[0] - PV[0]) * W, (TIP[1] - PV[1]) * H]
	var want = [F.x + Ht * 0.12, F.y - Ht * 0.66]
	var leanHit = 7 * D
	var tipAt = func(th: float, lean: float, dx: float) -> Array:
		var r = rot(vT[0], vT[1], th); var p = body_xf(H, lean, 0, 0, pv[0] + r.x, pv[1] + r.y); return [-p[0] + dx, p[1]]
	var thHit = -105 * D; var be = 1e9
	var d = -40
	while d >= -150:
		var e = absf(tipAt.call(d * D, leanHit, 0.0)[1] - want[1])
		if e < be: be = e; thHit = d * D
		if tipAt.call(d * D, leanHit, 0.0)[1] <= want[1]: break
		d -= 1
	var Lg = M2.cl(tipAt.call(thHit, leanHit, 0.0)[0] - want[0], -H * 0.15, H * 0.6)
	var TH0 = 38 * D; var THF = thHit - 22 * D
	var turn = M2.eio(M2.seg(g, 0.03, 0.17)) if g < 0.6 else 1 - M2.eio(M2.seg(g, 0.72, 0.9))
	var cs = cos(turn * PI); var fx = (1.0 if cs >= 0 else -1.0) * (0.32 + 0.68 * absf(cs))
	var hopT = sin(turn * PI) * H * 0.025
	var th: float; var lean: float; var dx: float
	if g < 0.4:
		var k = M2.eio(M2.seg(g, 0.14, 0.38))
		th = TH0 * k; lean = -6 * D * k; dx = -Lg * 0.4 * M2.eio(M2.seg(g, 0.05, 0.38))
	elif g < HIT:
		var k2 = M2.ei(M2.seg(g, 0.4, HIT)); var m = M2.eo(M2.seg(g, 0.4, HIT))
		th = M2.lerp_(TH0, thHit, k2); lean = M2.lerp_(-6 * D, leanHit, m); dx = M2.lerp_(-Lg * 0.4, -Lg, m)
	elif g < 0.6:
		var k3 = M2.eo3(M2.seg(g, HIT, 0.6))
		th = M2.lerp_(thHit, THF, k3); lean = leanHit + 2 * D * k3; dx = -Lg
	else:
		var k4 = M2.seg(g, 0.6, 1); var q = M2.eio(M2.seg(k4, 0, 0.45))
		var sw = sin((k4 - 0.4) / 0.6 * PI * 2.4) * (1 - (k4 - 0.4) / 0.6) * 10 * D if k4 > 0.4 else 0.0
		th = M2.lerp_(THF, 0, q) + sw; lean = M2.lerp_(leanHit + 2 * D, 0, M2.eio(M2.seg(k4, 0, 0.6))); dx = M2.lerp_(-Lg, 0, M2.eio(M2.seg(k4, 0.15, 1)))
	var walk = absf(dx) / (H * 0.12) * PI; var mv = 1.0 if g < 0.6 else 0.8
	o["vic"] = {"shake": M2.bump(g, HIT, 0.5, 0.6)}
	_sh(ctx, a, world(a, dx, 0)[0])
	M2.begin(ctx, a); ctx.translate(dx, -hopT); ctx.scale(fx, 1); push_body(ctx, H, lean, 0, 0)
	npc_body(ctx, "npc_guard", "npc_guard__bodyC", H, t, {"legF": sin(walk) * 0.2 * mv, "legB": -sin(walk) * 0.2 * mv, "head": (-0.06 * M2.bump(g, 0.4, HIT, 0.66) if g >= 0.4 and g < 0.66 else 0.0), "body": 0.0})
	var trail = ((M2.seg(g, 0.42, 0.45) if g < HIT else 1 - M2.seg(g, HIT, 0.56)) if (g > 0.42 and g < 0.56) else 0.0)
	if trail > 0:
		var th2 = th if g < HIT else thHit; var thA = th2 + 70 * D; var pts = []
		for i in 15:
			var r = rot(vT[0], vT[1], M2.lerp_(thA, th2, i / 14.0)); pts.append([pv[0] + r.x, pv[1] + r.y])
		ctx.save(); ctx.globalAlpha *= 0.6 * trail; line(ctx, pts, H * 0.045, "rgba(255,248,226,.85)", "rgba(70,60,40,.25)"); ctx.restore()
	piece(ctx, "npc_guard__club", W, H, PV, pv, th)
	ctx.restore()
	var hk0 = M2.bump(g, 0.16, 0.24, 0.4)
	if hk0 > 0: M2.begin(ctx, a); small_text(ctx, a, dx + H * 0.2, -H * 1.0, "哼", H * 0.12, hk0, t); ctx.restore()
	var hp = want; var hk = M2.seg(g, HIT, HIT + 0.12)
	if g >= HIT and g < HIT + 0.12: M2.begin(ctx, a); burst(ctx, hp[0], hp[1], Ht * 0.24, hk, 0.4); clank(ctx, a, hp[0] + Ht * 0.05, hp[1] - Ht * 0.4, Ht * 0.2, hk, -0.12); ctx.restore()
	var stk = M2.bump(g, HIT, HIT + 0.03, 0.66)
	if stk > 0:
		M2.begin(ctx, a); ctx.globalAlpha *= stk; var c = [F.x + Ht * 0.04, F.y - Ht * 1.02]
		for i in 3:
			var an = (g - HIT) * 9 + i * PI * 2 / 3; var r2 = Ht * 0.17; star(ctx, c[0] + cos(an) * r2, c[1] + sin(an) * r2 * 0.35, Ht * 0.055, an)
		ctx.restore()
	if g >= HIT - 0.005 and g < 0.75:
		var q2 = M2.seg(g, HIT - 0.005, 0.72); var cp = [hp[0] + Ht * 0.06, hp[1] + Ht * 0.02]
		M2.begin(ctx, a); tea_drops(ctx, cp[0], cp[1], -0.8, -0.85, Ht * 0.6, 0.06 + q2 * 0.94, 6, 7.3); steam(ctx, cp[0] + Ht * 0.04, cp[1] - Ht * 0.04, Ht * 0.35, M2.seg(g, HIT, 0.64), 1.3); ctx.restore()
	if g >= HIT and g < HIT + 0.02: o["hitP"] = world(a, hp[0], hp[1])
	return true

# ======================================================================
# 清潔安娣：兩手握住拖把，往前一戳，濺水
# ======================================================================
static func mv_npc_auntie(ctx: Ctx, a: Dictionary) -> bool:
	if not ok("npc_auntie__bodyH") or not ok("npc_auntie__arm") or not ok("npc_auntie__hip"): return false
	var o: Dictionary = a.o; var H: float = a.H; var t = J.num(o.get("t")) if J.t(o.get("t")) else 0.0; var g = M2.prog(o); var F = M2.foe(a, 0.68)
	var img = Spr.get_tex("npc_auntie__bodyH"); var W = H * img.get_width() / float(img.get_height()); var Ht: float = F.h
	var FIST = [0.275, 0.515]; var TOP = [0.235, 0.34]; var BOT = [0.37, 0.95]; var HEAD = [0.10, 0.36]
	var SH = [0.765, 0.43]; var HAND = [0.735, 0.595]
	var L = func(p: Array) -> Array: return [(p[0] - 0.5) * W, -H + p[1] * H]
	var fist = L.call(FIST); var axisUp = [(TOP[0] - BOT[0]) * W, (TOP[1] - BOT[1]) * H]; var axAng = atan2(axisUp[1], axisUp[0])
	var thT = (-PI - axAng) + 6 * D
	var hold = M2.eio(M2.seg(g, 0.0, 0.26)) if g < 0.6 else 1 - M2.eio(M2.seg(g, 0.68, 1))
	var pullB = M2.eio(M2.seg(g, 0.14, 0.38)) if g < 0.4 else (1 - M2.ei(M2.seg(g, 0.4, HIT)) if g < HIT else 0.0)
	var poke = M2.ei(M2.seg(g, 0.4, HIT)) if g < HIT else (1.0 if g < 0.6 else 1 - M2.eio(M2.seg(g, 0.6, 0.95)))
	var th = thT * hold
	var headV = [(HEAD[0] - FIST[0]) * W, (HEAD[1] - FIST[1]) * H]
	var leanHit = -10 * D; var rh = rot(headV[0], headV[1], thT); var hit0 = body_xf(H, leanHit, 0, 0, fist[0] + rh.x - H * 0.04, fist[1] + rh.y)
	var want = F.x + Ht * 0.16; var Lg = maxf(0, hit0[0] - want)
	var lean = 10 * D * pullB + leanHit * poke; var dx = H * 0.1 * pullB - Lg * poke; var jab = -H * 0.06 * poke + H * 0.05 * pullB
	o["vic"] = {"shake": M2.bump(g, HIT, 0.5, 0.6)}
	_sh(ctx, a, world(a, dx, 0)[0])
	M2.begin(ctx, a); push_body(ctx, H, lean, dx, 0)
	npc_body(ctx, "npc_auntie", "npc_auntie__bodyH", H, t, {"legF": -0.2 * poke, "legB": 0.15 * poke, "head": -0.06 * poke + 0.05 * pullB})
	var fx = fist[0] + jab; var fy = fist[1] + H * 0.01 * hold
	piece(ctx, "npc_auntie__arm", W, H, FIST, [fx, fy], th)
	var ub = rot(-axisUp[0], -axisUp[1], th); var ul = ub.length(); ub /= ul
	var sh = L.call(SH); var hand0 = [L.call(HAND)[0] - sh[0], L.call(HAND)[1] - sh[1]]; var reach = Vector2(hand0[0], hand0[1]).length()
	var bestS = 0.0; var be = 1e9; var s = H * 0.06
	while s < H * 0.45:
		var p = [fx + ub.x * s, fy + ub.y * s]; var e = absf(Vector2(p[0] - sh[0], p[1] - sh[1]).length() - reach * 0.95)
		if e < be: be = e; bestS = s
		s += H * 0.01
	var grip = [fx + ub.x * bestS, fy + ub.y * bestS]
	var ang = atan2(grip[1] - sh[1], grip[0] - sh[0]) - atan2(hand0[1], hand0[0])
	var r = rot(hand0[0], hand0[1], ang); var fixv = [grip[0] - (sh[0] + r.x), grip[1] - (sh[1] + r.y)]
	piece(ctx, "npc_auntie__hip", W, H, SH, [sh[0] + fixv[0] * hold, sh[1] + fixv[1] * hold], ang * hold)
	var hv = rot(headV[0], headV[1], th); var hp = [fx + hv.x, fy + hv.y]
	if hold > 0.5:
		for i in 3: M2.drip(ctx, hp[0] + H * (i - 1) * 0.04, hp[1] + H * 0.05, maxf(1, -(hp[1] + H * 0.05)) / 1.4, fmod(t * 1.4 + i / 3.0, 1.0), i + 40, H * 0.018)
	ctx.restore()
	if g >= HIT - 0.01 and g < 0.75:
		var q = M2.seg(g, HIT - 0.01, 0.72); var w = world(a, want, F.y - Ht * 0.48)
		ctx.save(); ctx.translate(w[0], w[1])
		if not a.faceRight: ctx.scale(-1, 1)
		ctx.rotate(PI / 2 + 0.2); M2.splash(ctx, 0, 0, Ht * 0.5, q, 12, 31.3, 0.8); ctx.restore()
	if g >= HIT and g < HIT + 0.02: o["hitP"] = world(a, want, F.y - Ht * 0.48)
	return true

# ======================================================================
# 陳總：一手指住對手大罵，「扣」「工」「資」三個字由嘴飛出去，逐個砸中
# ======================================================================
static func mv_npc_boss(ctx: Ctx, a: Dictionary) -> bool:
	if not ok("npc_boss__bodyP") or not ok("npc_boss__point"): return false
	var o: Dictionary = a.o; var H: float = a.H; var t = J.num(o.get("t")) if J.t(o.get("t")) else 0.0; var g = M2.prog(o); var F = M2.foe(a, 1.2)
	var img = Spr.get_tex("npc_boss__bodyP"); var W = H * img.get_width() / float(img.get_height()); var Ht: float = F.h
	var SH = [0.775, 0.475]; var HAND = [0.835, 0.75]; var MOUTH = [0.39, 0.315]
	var L = func(p: Array) -> Array: return [(p[0] - 0.5) * W, -H + p[1] * H]
	var point = M2.back_out(M2.seg(g, 0.04, 0.26)) if g < 0.6 else 1 - M2.eio(M2.seg(g, 0.84, 1))
	var yell = M2.bump(g, 0.26, 0.32, 0.86)
	var lean = (-6 * D * point) + (-3 * D * absf(sin((g - 0.26) * 26)) if g > 0.26 and g < 0.86 else 0.0)
	var dx = -H * 0.04 * point
	var tgt = [F.x + Ht * 0.05, F.y - Ht * 0.62]
	var aim = [F.x + Ht * 0.05, F.y - Ht * 0.42]
	var SHF = [0.38, 0.45]
	var kp = M2.cl(point); var A_ = L.call(SH); var B_ = L.call(SHF); var shL = [M2.lerp_(A_[0], B_[0], kp), M2.lerp_(A_[1], B_[1], kp)]
	var sh = body_xf(H, lean, dx, 0, shL[0], shL[1]); var hd = L.call(HAND); var sh0 = L.call(SH)
	var ang0 = atan2(hd[1] - sh0[1], hd[0] - sh0[0])
	var want = atan2(aim[1] - sh[1], aim[0] - sh[0]) - lean
	var dA = want - ang0
	while dA < 0: dA += PI * 2
	while dA > PI * 2: dA -= PI * 2
	var jolt = sin((g - 0.26) * 40) * 0.08 * yell if g > 0.26 and g < 0.86 else 0.0
	var shk = -INF
	for h in BOSS_HITS: shk = maxf(shk, M2.bump(g, h, h + 0.015, h + 0.1))
	o["vic"] = {"shake": shk}
	_sh(ctx, a, world(a, dx, 0)[0])
	M2.begin(ctx, a)
	ctx.save(); push_body(ctx, H, lean, dx, 0)
	npc_body(ctx, "npc_boss", "npc_boss__bodyP", H, t, {"head": -0.16 * yell - jolt, "body": -0.04 * yell, "sy": 1 + 0.03 * yell, "legF": -0.1 * point, "legB": 0.08 * point})
	piece(ctx, "npc_boss__point", W, H, SH, shL, dA * point + sin(t * 30) * 0.03 * yell, 1 + 0.1 * M2.cl(point))
	ctx.restore()
	var mo = L.call(MOUTH); var m = body_xf(H, lean, dx, 0, mo[0], mo[1])
	if yell > 0:
		ctx.save(); ctx.globalAlpha *= yell
		for i in 6:
			var an = PI + 0.95 - i * 0.24 + sin(t * 40 + i) * 0.05; var r0 = H * 0.2; var r1 = H * (0.3 + 0.07 * (i % 2)) * (0.8 + 0.2 * sin(t * 50 + i * 2))
			line(ctx, [[m[0] + cos(an) * r0, m[1] + sin(an) * r0], [m[0] + cos(an) * r1, m[1] + sin(an) * r1]], maxf(1.5, H * 0.02), "#fff6d8", "rgba(60,20,10,.85)")
		ctx.restore()
	var CH = ["扣", "工", "資"]; var S0 = H * 0.3
	for i in 3:
		var hitG: float = BOSS_HITS[i]; var st = hitG - 0.13
		if g < st: continue
		var fly = M2.seg(g, st, hitG); var aft = M2.seg(g, hitG, hitG + 0.14)
		if aft >= 1: continue
		var end = [tgt[0] + Ht * (0.06 + i * 0.03), tgt[1] + Ht * (-0.08 + i * 0.12)]
		var e = M2.ei(fly) * 0.6 + fly * 0.4
		var x = M2.lerp_(m[0] - H * 0.2, end[0], e); var y = M2.lerp_(m[1] - H * 0.12, end[1], e) - sin(fly * PI) * H * 0.14
		var s = S0 * (0.35 + 0.65 * M2.back_out(M2.cl(fly * 2.2))); var r = sin(t * 18 + i * 2) * 0.16 - 0.1; var sx = 1.0; var sy = 1.0; var al = 1.0
		if aft > 0:
			sx = 1 + 0.5 * (1 - aft) * (aft / 0.3 if aft < 0.3 else 1.0); sy = 1 - 0.35 * (1 - aft); x += H * 0.25 * M2.eo(aft) * 0.5; y -= H * 0.3 * M2.eo(aft) - H * 0.4 * aft * aft; r += aft * 2; al = 1 - M2.ei(aft)
		ctx.save(); ctx.translate(x, y)
		if a.faceRight: ctx.scale(-1, 1)
		ctx.rotate(r); ctx.scale(sx, sy); ctx.globalAlpha *= al
		ctx.drawImage(glyph(CH[i], "#ff5a3a", "#ffcf3a"), -s / 2, -s / 2, s, s)
		ctx.restore()
		var pk = M2.bump(g, hitG, hitG + 0.01, hitG + 0.08)
		if pk > 0:
			ctx.save(); ctx.globalAlpha *= pk
			for j in 8:
				var an2 = j / 8.0 * PI * 2 + i; var q0 = Ht * 0.08; var q1 = Ht * (0.14 + 0.1 * (1 - pk))
				line(ctx, [[end[0] + cos(an2) * q0, end[1] + sin(an2) * q0], [end[0] + cos(an2) * q1, end[1] + sin(an2) * q1]], maxf(1.5, Ht * 0.02), "#ffe58a", "rgba(80,20,0,.8)")
			ctx.restore()
	ctx.restore()
	for h in BOSS_HITS:
		if g >= h and g < h + 0.02: o["hitP"] = world(a, tgt[0], tgt[1])
	return true
