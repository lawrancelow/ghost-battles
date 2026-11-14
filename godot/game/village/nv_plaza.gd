# 村子廣場鬼（原生畫法）：搬 daily_plaza.js 嘅 drawAgent／body／eatDraw／golfDraw／hangDraw 同蠟筆特效
# 行為（揀目的地、傾偈、追逐、捉弄）仍然係 JS PlazaLife.update；呢度只負責每幀畫：身體網格交俾 GPU（pt_mesh.gdshader）。
class_name NvPlaza
extends RefCounted

const SC := 0.58
const TURN := 0.22
const D2R := PI / 180.0
const HOPPER := {"laojiang": 1, "zombie": 1}
const PAPER := {"xiaozhi": 1, "zhiren": 1}
const PSOLID := {"laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1}
const CH := {"xiaozhi": 54, "egui": 54, "eguiking": 66, "xiaogui": 46, "toyol": 46, "laojiang": 58, "zombie": 54, "shuigui": 56, "pontianak": 60, "pocong": 54, "penanggal": 52, "mengpo": 56, "youhun": 46, "baiwu": 76, "heiwu": 76, "niutou": 64, "mamian": 64, "huang": 62, "zhiren": 54, "tianhua": 60}
const FACEV := {"heiwu": 0.5, "baiwu": 0.45, "niutou": 0.3, "mamian": 0.3, "eguiking": 0.28, "huang": 0.3, "laojiang": 0.35, "zombie": 0.35, "toyol": 0.3}
const KEEP := {"y": 1, "sx": 1, "sy": 1}

var vv
var nodes := {}
var used := {}
var wet_n: PtDraw
var wets: Array = []
var pr := {}

func _init(v) -> void:
	vv = v
	PtGfx.init(); PtChar.setup_static()
	wet_n = PtDraw.new(); wet_n.fn = _draw_wet; vv.ysort.add_child(wet_n)

func prof_str(n: int) -> String:
	var s = ""
	for k in pr: s += "%s=%.2f " % [k, pr[k] / 1000.0 / n]
	return s
func prof_reset() -> void: pr.clear()

func begin_frame() -> void: used.clear()
func try_item(it, _y: float) -> bool: return it.get("kind") == "plaza"

func end_frame() -> void:
	var W = vv.V.get("plaza")
	if not W is Dictionary:
		for id in nodes: nodes[id].visible = false
		return
	var t0 = Time.get_ticks_usec()
	var t: float = vv.t
	wets = W.get("wet", [])
	wet_n.position = Vector2.ZERO; wet_n.z_index = 0; wet_n.queue_redraw()
	var b = vv.V.get("bubble")
	var SPECIAL = J.G.get("SPECIAL")
	var vy0: float = vv.cam_y - 90.0; var vy1: float = vv.cam_y + vv.size.y / maxf(0.01, vv.sc) + 40.0
	for ag in W.get("list", []):
		var ay = J.num(ag.y)
		if ay < vy0 or ay > vy1: continue  # 鏡頭外唔畫
		var k = J.str(ag.k)
		var mute = b is Dictionary and ag.get("g") is Dictionary and b.get("id") == ag.g.get("id") and not J.t(b.get("hero"))
		var special = SPECIAL != null and J.t(J.mc(SPECIAL, "has", [k]))
		var nat_sp = special and NvSpecial.has(k)
		if not nat_sp and (special or not (PtChar.RIG.has(k) and PtGfx.tex(k) != null)):
			# 冇網格嘅（Toyol、Pocong、Penanggal）：交返 JS 畫入錄製器
			var n = vv._seg(); n.position = Vector2(0, J.num(ag.y))
			var r: Recorder = n.get_meta("rec"); r.clear()
			vv.rec_ctx.ci = r; vv.rec_ctx.T = Transform2D.IDENTITY; vv.rec_ctx.base = Transform2D.IDENTITY; vv.rec_ctx.globalAlpha = 1.0
			J.mc(J.G.get("PlazaLife"), "drawAgent", [vv.rec_ctx, ag, t, {"noIcon": mute}])
			n.queue_redraw()
			continue
		var id = J.str(ag.id)
		var na: NvAgent = nodes.get(id)
		if na == null: na = NvAgent.new(self, k); vv.ysort.add_child(na); nodes[id] = na
		used[id] = 1
		na.visible = true
		if nat_sp: na.sync_special(ag, t, mute)
		else: na.sync(ag, t, mute)
	for id in nodes:
		if not used.has(id) and nodes[id].visible: nodes[id].visible = false
	pr["plaza"] = pr.get("plaza", 0) + Time.get_ticks_usec() - t0

func _draw_wet(c: CanvasItem) -> void:
	var ctx = Ctx.new(c)
	for w in wets:
		var wt = J.num(w.t); var life = J.num(w.life); var r = J.num(w.r); var x = J.num(w.x); var y = J.num(w.y)
		var k = 1 - wt / life; var g = minf(1, wt * 6)
		ctx.save(); ctx.globalAlpha *= 0.5 * k; ctx.fillStyle = "#1d3440"; ctx.beginPath(); ctx.ellipse(x, y, r * (0.6 + 0.4 * g), r * 0.42 * (0.6 + 0.4 * g), 0, 0, TAU); ctx.fill()
		ctx.globalAlpha *= 0.8; ctx.fillStyle = "#6fa6bd"; ctx.beginPath(); ctx.ellipse(x - r * 0.25, y - r * 0.1, r * 0.3, r * 0.1, 0, 0, TAU); ctx.fill()
		if wt < 0.35: ctx.globalAlpha = 0.7 * (1 - wt / 0.35); ctx.strokeStyle = "#9fd0e6"; ctx.lineWidth = 0.6; ctx.beginPath(); ctx.ellipse(x, y, r * (1 + wt * 6), r * 0.42 * (1 + wt * 6), 0, 0, TAU); ctx.stroke()
		ctx.restore()

# ---------------- 數學小工具（同 daily_plaza.js）----------------
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func eo(t: float) -> float: return 1 - (1 - t) * (1 - t)
static func ei(t: float) -> float: return t * t
static func eio(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func eo3(t: float) -> float: return 1 - pow(1 - t, 3)
static func seg(g: float, a: float, b: float) -> float: return cl((g - a) / (b - a))
static func env(g: float, a: float, b: float, c: float, d: float) -> float: return eio(seg(g, a, b)) * (1 - eio(seg(g, c, d)))
static func hash(i: float) -> float:
	var v = sin(i * 127.1 + 311.7) * 43758.5453; return v - floor(v)
static func bump3(g: float, a: float, m: float, b: float) -> float:
	if g <= a or g >= b: return 0.0
	return eio((g - a) / (m - a)) if g < m else 1 - eio((g - m) / (b - m))
static func add(p: Dictionary, d: Dictionary) -> Dictionary:
	for k in d:
		if k == "sx" or k == "sy": p[k] = float(p.get(k, 1.0) if p.get(k) != null else 1.0) * d[k]
		else: p[k] = float(p.get(k, 0.0) if p.get(k) != null else 0.0) + d[k]
	return p
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k

static func base_pose(o: Dictionary, type: String) -> Dictionary:
	var t: float = o.t; var w = cl(o.w); var I = MeshAnim.idle(t)
	if HOPPER.has(type) or w <= 0.001: return I
	var run: float = o.run; var Wk = MeshAnim.walk(o.wph)
	if run > 0: Wk.legF *= 1 + 0.5 * run; Wk.legB *= 1 + 0.5 * run; Wk.armF *= 1 + 0.7 * run; Wk.armB *= 1 + 0.7 * run; Wk.body += 0.07 * run
	if o.stiff: Wk.armF *= 0.35; Wk.armB *= 0.35; Wk.body = 0.03; Wk.head = 0.0
	var P = I.duplicate()
	for k in Wk: P[k] = lerp_(float(I.get(k, 0.0)), float(Wk[k]), w)
	return P

# ---------------- 蠟筆特效（Ctx 版，同 JS 一樣）----------------
static func crayon(ctx: Ctx, pts: Array, w: float, col: String) -> void:
	ctx.save(); ctx.lineCap = "round"; ctx.lineJoin = "round"; ctx.strokeStyle = col; var g0 = ctx.globalAlpha
	for p in 2:
		ctx.globalAlpha = g0 * (0.5 if p else 1.0); ctx.lineWidth = w * (0.55 if p else 1.0); ctx.beginPath()
		for i in pts.size():
			var j = w * 0.35 if p else 0.0; var jx = (hash(i * 3.1 + p) - 0.5) * j; var jy = (hash(i * 5.7 + p) - 0.5) * j
			if i: ctx.lineTo(pts[i][0] + jx, pts[i][1] + jy)
			else: ctx.moveTo(pts[i][0] + jx, pts[i][1] + jy)
		ctx.stroke()
	ctx.restore()
static func steam(ctx: Ctx, x: float, y: float, t: float, s: float, n: int, k: float, push: float) -> void:
	for i in n:
		var ph = fmod(t * 0.5 + float(i) / n + hash(i) * 0.2, 1.0); var al = sin(ph * PI) * 0.6 * k
		if al <= 0.02: continue
		var pts = []; var x0 = x + (i - (n - 1) / 2.0) * 3 * s
		for j in 7:
			var q = j / 6.0; var h = (ph * 20 + q * 9) * s
			pts.append([x0 + sin(q * 5 + t * 2.3 + i * 2) * 2 * s * (0.4 + q) + push * h * 0.9, y - h])
		ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, 1.4 * s, "#f3eee4"); ctx.restore()
static func txt(ctx: Ctx, x: float, y: float, s: String, size: float, col: String, k: float, wob: float) -> void:
	if k <= 0: return
	ctx.save(); var sc = 0.55 + 0.45 * eo(cl(k * 2.2)); ctx.globalAlpha *= cl(k * 3)
	ctx.translate(x, y); ctx.rotate(wob * 0.12); ctx.scale(sc, sc)
	ctx.font = "900 %spx sans-serif" % size; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineJoin = "round"; ctx.lineWidth = size * 0.28; ctx.strokeStyle = "rgba(28,18,30,.92)"; ctx.strokeText(s, 0, 0); ctx.fillStyle = col; ctx.fillText(s, 0, 0)
	ctx.restore()
static func zzz(ctx: Ctx, x: float, y: float, t: float, s: float, k: float) -> void:
	for i in 3:
		var ph = fmod(t * 0.42 + i / 3.0, 1.0); var al = sin(ph * PI) * k
		if al <= 0.02: continue
		ctx.save(); ctx.globalAlpha *= al; txt(ctx, x + ph * 11 * s + sin(ph * 6 + i) * 2 * s, y - ph * 24 * s, "z", (8 + ph * 7) * s * 1.4, "#d6e6ff", 1, sin(ph * 4)); ctx.restore()
static func star(ctx: Ctx, x: float, y: float, r: float, rot: float) -> void:
	ctx.save(); ctx.translate(x, y); ctx.rotate(rot); ctx.beginPath()
	for i in 10:
		var rr = r * 0.45 if i % 2 else r; var an = i * PI / 5 - PI / 2; ctx.lineTo(cos(an) * rr, sin(an) * rr)
	ctx.closePath(); ctx.fillStyle = "#ffe27a"; ctx.fill(); ctx.lineWidth = r * 0.3; ctx.strokeStyle = "#6a4a20"; ctx.stroke(); ctx.restore()
static func stars(ctx: Ctx, x: float, y: float, t: float, s: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= k
	for i in 3:
		var an = t * 5.5 + i * TAU / 3; star(ctx, x + cos(an) * 11 * s, y + sin(an) * 3.5 * s, (2.2 + sin(an) * 0.6) * s * 1.3, t * 3 + i)
	ctx.restore()
static func bubble(ctx: Ctx, x: float, y: float, ch: String, s: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k * 4); var sc = (0.6 + 0.4 * eo(cl(k * 3))) * s * 1.7
	ctx.translate(x, y); ctx.scale(sc, sc)
	ctx.beginPath(); ctx.ellipse(0, 0, 8.5, 6.5, 0, 0, TAU); ctx.fillStyle = "#ecd9a4"; ctx.fill(); ctx.lineWidth = 1.1; ctx.strokeStyle = "#5a4030"; ctx.stroke()
	ctx.beginPath(); ctx.moveTo(-2.5, 5.6); ctx.lineTo(-4.5, 10); ctx.lineTo(1, 6.2); ctx.fillStyle = "#ecd9a4"; ctx.fill(); ctx.stroke()
	ctx.beginPath(); ctx.ellipse(0, 0, 7.6, 5.6, 0, 0, TAU); ctx.fillStyle = "#ecd9a4"; ctx.fill()
	ctx.fillStyle = "#c2362b" if ch == "!" else ("#3a6aa8" if ch == "♪" else "#2b1d12")
	if ch == "…":
		for i in range(-1, 2): ctx.beginPath(); ctx.arc(i * 3, 0.5, 1.05, 0, TAU); ctx.fill()
	else: ctx.font = "900 9px sans-serif"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(ch, 0, 0.6)
	ctx.restore()
static func crumbs(ctx: Ctx, x: float, y: float, tb: float, s: float, sd: float, fwd: float) -> void:
	if tb < 0 or tb > 0.65: return
	for i in 6:
		var vx = fwd * (6 + hash(sd + i) * 26) * s * 1.6 * (1.0 if hash(sd + i * 2) > 0.3 else -0.6); var vy = (-26 - hash(sd + i * 3) * 24) * s * 1.6
		var px = x + vx * tb; var py = y + vy * tb + 170 * s * tb * tb; var al = 1 - tb / 0.65
		ctx.save(); ctx.globalAlpha *= al; ctx.translate(px, py); ctx.rotate(tb * 9 + i)
		ctx.fillStyle = "#f4e7c6"; ctx.strokeStyle = "#8a6a44"; ctx.lineWidth = 0.35; var r = (0.7 + hash(i + sd) * 0.6) * s * 1.6
		ctx.beginPath(); ctx.ellipse(0, 0, r, r * 0.75, 0, 0, TAU); ctx.fill(); ctx.stroke(); ctx.restore()
static func drop(ctx: Ctx, x: float, y: float, r: float, al: float) -> void:
	ctx.save(); ctx.globalAlpha *= al; ctx.fillStyle = "#9fd0e6"; ctx.strokeStyle = "#2c5566"; ctx.lineWidth = r * 0.35
	ctx.beginPath(); ctx.moveTo(x, y - r * 1.6); ctx.quadraticCurveTo(x + r, y - r * 0.2, x, y + r * 0.6); ctx.quadraticCurveTo(x - r, y - r * 0.2, x, y - r * 1.6); ctx.fill(); ctx.stroke(); ctx.restore()
static func dust_puff(ctx: Ctx, x: float, y: float, k: float, s: float, sd: float) -> void:
	if k <= 0 or k >= 1: return
	for i in 5:
		var an = PI + (i / 4.0) * PI + (hash(sd + i) - 0.5) * 0.5; var r = (4 + 10 * eo(k)) * s * (0.7 + hash(sd + i * 2) * 0.6)
		ctx.save(); ctx.globalAlpha *= (1 - k) * 0.55; ctx.fillStyle = "#cdbfa8"
		ctx.beginPath(); ctx.arc(x + cos(an) * r * 1.4, y + sin(an) * r * 0.35, (1.6 + 2.2 * k) * s, 0, TAU); ctx.fill(); ctx.restore()
static func sniff_lines(ctx: Ctx, x: float, y: float, t: float, s: float, fwd: float) -> void:
	for i in 2:
		var ph = fmod(t * 1.6 + i * 0.5, 1.0); var al = sin(ph * PI) * 0.8; var pts = []
		for j in 6:
			var q = j / 5.0; pts.append([x + fwd * (14 - ph * 10 - q * 6) * s, y + (i * 4 - 2 + sin(q * 6 + t * 8) * 1.2) * s])
		ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, 0.9 * s, "#e9e2cf"); ctx.restore()
static func drips(ctx: Ctx, ag_x: float, ag_y: float, t: float, seed: float) -> void:
	var H = 56.0 * SC
	for i in 3:
		var ph = fmod(t * 0.9 + i * 0.37 + seed, 1.0); var x = ag_x + (hash(i + floor(t * 0.9 + i * 0.37 + seed)) - 0.5) * H * 0.5; var y0 = ag_y - H * (0.35 + 0.2 * hash(i * 3))
		drop(ctx, x, y0 + (ag_y - y0) * ei(ph), 1.1, 0.8 * (1 - seg(ph, 0.85, 1)))
