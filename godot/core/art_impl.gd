# 美術（移植 art.js ＋ scene.js 嘅蠟筆畫覆蓋版）：建築、樹、稻田、擺設、烏鴉、角色
extends Node

const OUT := "#1a1426"
const TAU := PI * 2
const SERIF := "\"Songti TC\",\"Noto Serif CJK TC\",serif"
const SOLID := {"npc_it": 1, "npc_mis": 1, "npc_ken": 1, "npc_boss": 1, "npc_guard": 1, "npc_auntie": 1, "laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1}
const HOP := {"laojiang": 1, "zombie": 1, "pocong": 1}
const CHAR_H := {"npc_it": 60, "npc_mis": 62, "npc_ken": 64, "npc_boss": 64, "npc_guard": 64, "npc_auntie": 60, "afu": 58, "xiaozhi": 54, "egui": 54, "eguiking": 66, "xiaogui": 46, "toyol": 46, "laojiang": 58, "zombie": 54, "shuigui": 56, "pontianak": 60, "pocong": 54, "penanggal": 52, "mengpo": 56, "youhun": 46, "baiwu": 76, "heiwu": 76, "niutou": 64, "mamian": 64, "huang": 62, "zhiren": 54, "tianhua": 60, "npc_kiln": 58, "npc_receipt": 56, "npc_driver": 58, "npc_ferry": 60, "npc_shop": 58, "npc_rubber": 58, "npc_fisher": 58, "npc_dock": 60, "npc_stall": 58, "npc_ticket": 56, "npc_dj": 56, "npc_inn": 58, "npc_granny": 54, "npc_grandpa": 56, "npc_hq": 58, "npc_clerk": 56, "res_granny": 54, "res_guard": 58, "res_helper": 56}
const SPECIAL_T := {"penanggal": 1, "pocong": 1, "toyol": 1}
const ACE = preload("res://game/soul/ace_art.gd")   # [p44] 王牌晉級立繪
const HV = preload("res://game/soul/hero_vil.gd")   # [p47] 主角空手＋漂浮兵器

# ---------------- 基本形狀 ----------------
func el(ctx: Ctx, x: float, y: float, rx: float, ry: float, fill = null, stroke = null, lw = null) -> void:
	ctx.beginPath(); ctx.ellipse(x, y, maxf(0.1, rx), maxf(0.1, ry), 0, 0, TAU)
	if fill != null: ctx.fillStyle = fill; ctx.fill()
	if stroke != null: ctx.lineWidth = lw if lw != null else 1.5; ctx.strokeStyle = stroke; ctx.stroke()

func rr(ctx: Ctx, x: float, y: float, w: float, h: float, r: float, fill = null, stroke = null, lw = null) -> void:
	ctx.beginPath(); ctx.roundRect(x, y, w, h, r)
	if fill != null: ctx.fillStyle = fill; ctx.fill()
	if stroke != null: ctx.lineWidth = lw if lw != null else 1.5; ctx.strokeStyle = stroke; ctx.stroke()

func poly(ctx: Ctx, pts: Array, fill = null, stroke = null, lw = null) -> void:
	ctx.beginPath(); ctx.moveTo(pts[0], pts[1])
	for i in range(2, pts.size(), 2): ctx.lineTo(pts[i], pts[i + 1])
	ctx.closePath()
	if fill != null: ctx.fillStyle = fill; ctx.fill()
	if stroke != null: ctx.lineWidth = lw if lw != null else 1.5; ctx.strokeStyle = stroke; ctx.stroke()

func shadow(ctx: Ctx, x: float, y: float, s: float) -> void:
	el(ctx, x, y, 14 * s, 4 * s, "rgba(0,0,0,.35)")

# ---------------- scene.js：以底邊中心畫一張圖 ----------------
const VS = preload("res://game/village_style.gd")   # [villageart] 新畫風調色
var tint := Color.WHITE   # [villageart] put() 用嘅調色（只喺村子樹／稻田／擺設／出村門設）
# ---------------- [seat16] 建築接地：墨線排線影、踩實泥地、前景草叢碎石、墨線描邊 ----------------
var ink_w := 0.0   # put() 描邊粗幼（世界 px）；0＝唔描。只喺村子靜態物件畫嘅時候開
const INK_COL := Color(0.0, 0.0, 0.0, 0.62)
const INK_OFF := [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1), Vector2(0.7, 0.7), Vector2(-0.7, 0.7), Vector2(0.7, -0.7), Vector2(-0.7, -0.7)]
static func _sr(seed: int, k: int) -> float:   # 固定亂數 0..1（同一間建築每次畫都一樣）
	var v = sin(float(seed) * 12.9898 + float(k) * 78.233) * 43758.5453
	return v - floor(v)
# 建築腳下：一塊踩實嘅泥地（蓋住地面圖嘅草同路邊）＋斜排線接地影。喺建築圖之前畫
func seat(ctx: Ctx, x: float, y: float, w: float, seed := 0, pad := true) -> void:
	var rx = w * 0.50; var ry = maxf(7.0, w * 0.105)
	if pad:
		el(ctx, x, y + 2, rx * 1.16, ry * 1.55, "rgba(74,50,32,.20)")
		el(ctx, x, y + 2, rx * 1.02, ry * 1.25, "rgba(66,44,28,.30)")
		el(ctx, x, y + 2, rx * 0.86, ry * 1.00, "rgba(54,36,24,.36)")
	el(ctx, x + rx * 0.06, y + 3, rx * 0.84, ry * 0.80, "rgba(18,10,8,.34)")
	hatch(ctx, x + rx * 0.06, y + 3, rx * 0.96, ry * 1.05, 2.4, "rgba(14,8,5,.72)", 1.0, seed)
# 橢圓入面畫斜排線（同地面圖嘅排線同一方向：左下去右上）
func hatch(ctx: Ctx, cx: float, cy: float, rx: float, ry: float, gap: float, col: String, lw: float, seed := 0) -> void:
	var d = Vector2(0.86, -0.5); var nrm = Vector2(0.5, 0.86)
	var ext = rx * absf(nrm.x) + ry * absf(nrm.y)
	ctx.strokeStyle = col; ctx.lineWidth = lw; ctx.lineCap = "round"
	var k = 0; var o = -ext
	while o < ext:
		var p0 = nrm * o
		var A = d.x * d.x / (rx * rx) + d.y * d.y / (ry * ry)
		var B = 2.0 * (p0.x * d.x / (rx * rx) + p0.y * d.y / (ry * ry))
		var C = p0.x * p0.x / (rx * rx) + p0.y * p0.y / (ry * ry) - 1.0
		var D = B * B - 4.0 * A * C
		if D > 0.0:
			var q = sqrt(D); var s0 = (-B - q) / (2.0 * A); var s1 = (-B + q) / (2.0 * A)
			var j0 = _sr(seed, k) * 0.22; var j1 = _sr(seed, k + 97) * 0.22   # 兩頭隨機縮短少少，似手畫
			var a = p0 + d * lerpf(s0, s1, j0); var b = p0 + d * lerpf(s0, s1, 1.0 - j1)
			ctx.beginPath(); ctx.moveTo(cx + a.x, cy + a.y); ctx.lineTo(cx + b.x, cy + b.y); ctx.stroke()
		o += gap * (0.8 + _sr(seed, k + 31) * 0.4); k += 1
	ctx.lineCap = "butt"
# 一叢墨線枯草（同新地面圖嘅草一樣：赭黃葉、黑邊）
func tuft(ctx: Ctx, x: float, y: float, h: float, seed := 0) -> void:
	var n = 5 + int(_sr(seed, 1) * 3.0)
	for i in n:
		var f = (float(i) + 0.5) / float(n) - 0.5
		var bx = x + f * h * 0.55; var lean = f * h * 1.15 + (_sr(seed, 10 + i) - 0.5) * h * 0.25
		var hh = h * (1.0 - absf(f) * 0.85) * (0.75 + _sr(seed, 20 + i) * 0.4)
		var bw = maxf(0.9, h * 0.085)
		var fillc = "#b59a40" if i % 3 != 1 else "#8f7a30"
		poly(ctx, [bx - bw, y, bx + bw, y, bx + lean, y - hh], fillc, "#1a110a", 0.8)
	ctx.strokeStyle = "rgba(20,12,8,.7)"; ctx.lineWidth = 0.8
	ctx.beginPath(); ctx.moveTo(x - h * 0.34, y + 0.6); ctx.lineTo(x + h * 0.34, y + 0.6); ctx.stroke()
func pebble(ctx: Ctx, x: float, y: float, r: float, seed := 0) -> void:
	el(ctx, x + 0.6, y + r * 0.5, r * 1.05, r * 0.45, "rgba(14,8,6,.45)")
	el(ctx, x, y, r, r * 0.68, "#a8997e" if seed % 2 == 0 else "#8f8068", "#1a110a", 0.7)
# [seat16b] 斜投影：用建築自己嘅剪影，壓扁再向右下斜倒喺地面（光由左後方嚟）
func cast(ctx: Ctx, key: String, x: float, y: float, w: float, h := 0.0) -> void:
	var im = Spr.get_tex(key)
	if im == null: return
	if h == 0.0: h = w * im.get_height() / im.get_width()
	var m = ctx._mod() * Color(0.04, 0.02, 0.02, 0.52)
	var M = Transform2D(Vector2(1, 0), Vector2(-0.70, -0.30), Vector2(x, y))
	ctx.ci.draw_set_transform_matrix(ctx.T * M)
	ctx.ci.draw_texture_rect(im, Rect2(-w / 2, -h, w, h), false, m)
	ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
# 建築圖之後畫：喺底邊前面壓草叢同碎石，遮住條硬邊
func seat_front(ctx: Ctx, x: float, y: float, w: float, seed := 0, mid := true) -> void:
	# [fg16] 前景層：草堆／土堆／石堆貼圖壓喺建築底邊前面（建築名牌喺呢層之後先畫，唔會被遮）
	var sd = seed * 7 + 3; var pw = maxf(w, 92.0)
	var L = ["g", "r", "g", "d"][int(_sr(sd, 1) * 4.0) % 4]; var R = ["r", "g", "d", "g"][int(_sr(sd, 2) * 4.0) % 4]
	if mid: fg(ctx, "d%d" % (1 + int(_sr(sd, 3) * 4.0) % 4), x + (_sr(sd, 4) - 0.5) * w * 0.24, y + 14, pw * 0.50, _sr(sd, 5) > 0.5)
	fg(ctx, "%s%d" % [L, 1 + int(_sr(sd, 6) * 4.0) % 4], x - w * (0.44 + _sr(sd, 7) * 0.08), y + 11 + _sr(sd, 8) * 3, pw * (0.54 + _sr(sd, 9) * 0.10), false)
	fg(ctx, "%s%d" % [R, 1 + int(_sr(sd, 10) * 4.0) % 4], x + w * (0.44 + _sr(sd, 11) * 0.08), y + 10 + _sr(sd, 12) * 3, pw * (0.52 + _sr(sd, 13) * 0.10), true)
	if mid and _sr(sd, 14) > 0.3: fg(ctx, "g%d" % (1 + int(_sr(sd, 15) * 4.0) % 4), x + w * (0.14 + _sr(sd, 16) * 0.12) * (1.0 if _sr(sd, 17) > 0.5 else -1.0), y + 17, pw * 0.34, _sr(sd, 18) > 0.5)
# [fg16b] 後景層：建築後面兩側嘅草叢／矮石（畫喺建築之前，俾建築遮住一半），顏色壓暗少少，前後都包住
func seat_back(ctx: Ctx, x: float, y: float, w: float, seed := 0) -> void:
	var sd = seed * 11 + 5; var pw = maxf(w, 92.0); var dk = Color(0.72, 0.68, 0.66)
	fg(ctx, "g%d" % (1 + int(_sr(sd, 1) * 4.0) % 4), x - w * (0.50 + _sr(sd, 2) * 0.06), y - 6 - _sr(sd, 3) * 5, pw * 0.56, true, dk)
	fg(ctx, "%s%d" % [["g", "r"][int(_sr(sd, 4) * 2.0) % 2], 1 + int(_sr(sd, 5) * 4.0) % 4], x + w * (0.50 + _sr(sd, 6) * 0.06), y - 7 - _sr(sd, 7) * 5, pw * 0.54, false, dk)
	if _sr(sd, 8) > 0.4: fg(ctx, "r%d" % (1 + int(_sr(sd, 9) * 4.0) % 4), x + w * (_sr(sd, 10) - 0.5) * 0.9, y - 14, pw * 0.36, _sr(sd, 11) > 0.5, dk)
# [lamp16] 新路燈（3 款）＋特效：地面暖光、燈籠光暈（呼吸＋閃爍）、飛蛾
const LAMPS := {1: [[0.793, 0.413]], 2: [[0.767, 0.431]], 3: [[0.242, 0.453], [0.84, 0.459]]}
var lamp_seen := {}   # "x,y" → [世界座標燈籠位, 上次畫嘅毫秒, 閃爍強度]（暗影層用嚟開燈光）
static func lamp_flick(t: float, x: float) -> float:
	var f = 0.86 + sin(t * 2.1 + x) * 0.07 + sin(t * 13.7 + x * 1.3) * 0.035
	if fmod(t * 0.37 + x * 0.011, 1.0) > 0.965: f -= 0.22   # 間中閃一下
	return f
func draw_lamp(ctx: Ctx, x: float, y: float, t: float, H := 60.0) -> void:
	var v = [1, 2, 1, 3][int(absf(x * 0.37 + y * 0.11)) % 4]; var flip = int(x / 4.0) % 2 == 0
	if not _fg_tex.has("lamp%d" % v): fg(ctx, "lamp%d" % v, -99999, -99999, 1)
	var im = _fg_tex.get("lamp%d" % v)
	if im == null: return
	var w = H * im.get_width() / im.get_height(); var fl = lamp_flick(t, x)
	PtGfx.init()
	var c = ctx.ci
	c.draw_set_transform_matrix(ctx.T)
	c.draw_texture_rect(PtGfx.RAD, Rect2(x - 46, y - 14, 92, 34), false, ctx._mod() * Color(1.0, 0.78, 0.42, 0.20 * fl))   # 腳下地面暖光
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
	el(ctx, x, y + 1, w * 0.30, 3.2, "rgba(10,5,4,.5)")
	var m = ctx._mod()
	c.draw_set_transform_matrix(ctx.T * Transform2D(Vector2(-1.0 if flip else 1.0, 0), Vector2(0, 1), Vector2(x, y + 3)))
	for o in INK_OFF: c.draw_texture_rect(im, Rect2(-w / 2 + o.x * 0.7, -H + o.y * 0.7, w, H), false, m * INK_COL)
	c.draw_texture_rect(im, Rect2(-w / 2, -H, w, H), false, m)
	c.draw_set_transform_matrix(ctx.T)
	var first = Vector2.ZERO; var k = 0
	for L in LAMPS[v]:
		var lx = x + (L[0] - 0.5) * w * (-1.0 if flip else 1.0); var ly = y + 3 - H + L[1] * H
		if k == 0: first = Vector2(lx, ly)
		var r = H * 0.62 * (0.92 + fl * 0.12)
		c.draw_texture_rect(PtGfx.RAD, Rect2(lx - r, ly - r, r * 2, r * 2), false, m * Color(1.0, 0.80, 0.45, 0.34 * fl))   # 大光暈
		c.draw_texture_rect(PtGfx.RAD, Rect2(lx - r * 0.42, ly - r * 0.42, r * 0.84, r * 0.84), false, m * Color(1.0, 0.95, 0.75, 0.42 * fl))   # 燈芯
		for j in 3:   # 飛蛾：圍住燈籠兜圈、拍翼
			var ph = float(j) * 2.1 + x * 0.05 + float(k); var sp = 1.6 + float(j) * 0.5
			var mx = lx + cos(t * sp + ph) * (H * 0.20 + float(j) * 2.0); var my = ly + sin(t * sp * 1.3 + ph) * H * 0.13 - 1.0
			var wing = 1.1 + absf(sin(t * 22.0 + ph)) * 1.1
			c.draw_line(Vector2(mx - wing, my - 0.6), Vector2(mx + wing, my - 0.6), m * Color(0.93, 0.88, 0.74, 0.85), 0.9)
			c.draw_circle(Vector2(mx, my), 0.6, m * Color(0.22, 0.16, 0.12, 0.9))
		k += 1
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
	var wp = ctx.base.affine_inverse() * (ctx.T * first)
	lamp_seen["%d,%d" % [int(x), int(y)]] = [wp, Time.get_ticks_msec(), fl]
var _fg_tex := {}
func fg(ctx: Ctx, k: String, x: float, y: float, w: float, flip := false, tintc := Color.WHITE) -> void:
	if not _fg_tex.has(k):
		var p = "res://assets/spr/fg_%s.webp" % k
		_fg_tex[k] = load(p) if ResourceLoader.exists(p) else null
	var im = _fg_tex[k]
	if im == null: return
	var h = w * im.get_height() / im.get_width()
	el(ctx, x, y - 1, w * 0.46, maxf(2.0, h * 0.16), "rgba(12,6,5,.38)")   # 貼地暗影
	var m = ctx._mod() * tintc
	ctx.ci.draw_set_transform_matrix(ctx.T * Transform2D(Vector2(-1.0 if flip else 1.0, 0), Vector2(0, 1), Vector2(x, y)))
	ctx.ci.draw_texture_rect(im, Rect2(-w / 2, -h, w, h), false, m)
	ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)

func put(ctx: Ctx, key: String, x: float, y: float, w: float, h := 0.0) -> Rect2:
	var im = Spr.get_tex(key)
	if im == null: return Rect2()
	if h == 0.0: h = w * im.get_height() / im.get_width()
	if w == 0.0: w = h * im.get_width() / im.get_height()
	if ink_w > 0.0:   # [seat16] 墨線描邊：同一張圖染黑、向 8 個方向偏移畫一圈，再畫本體
		var ik = ctx._mod() * INK_COL
		if ik.a > 0.001:
			ctx.ci.draw_set_transform_matrix(ctx.T)
			for o in INK_OFF: ctx.ci.draw_texture_rect(im, Rect2(x - w / 2 + o.x * ink_w, y - h + o.y * ink_w, w, h), false, ik)
			ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	if tint != Color.WHITE:   # [villageart]
		var m = ctx._mod() * tint
		if m.a > 0.001: ctx.ci.draw_set_transform_matrix(ctx.T); ctx.ci.draw_texture_rect(im, Rect2(x - w / 2, y - h, w, h), false, m); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
		return Rect2(x - w / 2, y - h, w, h)
	ctx.drawImage(im, x - w / 2, y - h, w, h)
	return Rect2(x - w / 2, y - h, w, h)
func vput(ctx: Ctx, key: String, x: float, y: float, w: float, h := 0.0) -> Rect2:   # [villageart] 調色版 put
	tint = VS.tint_for(key); var r = put(ctx, key, x, y, w, h); tint = Color.WHITE; return r

const BW := {"house": 150, "gate": 150, "plank": 106, "bun": 106, "wood": 108, "rice": 108, "store": 112, "home": 104, "camp": 108, "altar": 104, "furnace": 62, "barracks": 100}   # [barracks]
const PLAQUE := {"house": [0.47, 0.49, 0.24], "gate": [0.50, 0.335, 0.34], "plank": [0.44, 0.36, 0.32], "store": [0.48, 0.43, 0.33], "wood": [0.40, 0.36, 0.26]}

func lv_badge(ctx: Ctx, x: float, y: float, lv) -> void:
	ctx.save(); ctx.translate(x, y); ctx.rotate(0.12)
	rr(ctx, -1, -8, 22, 16, 2, "#c2362b", "#f0c8b4", 1)
	ctx.fillStyle = "#fff3e0"; ctx.font = "900 10px sans-serif"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(str(lv), 10, 0.5); ctx.restore()

func plaque_text(ctx: Ctx, r: Rect2, p: Array, text: String, lv) -> void:
	var cx: float = r.position.x + r.size.x * p[0]; var cy: float = r.position.y + r.size.y * p[1]; var pw: float = r.size.x * p[2]
	var fs = clampf(pw / (text.length() * 1.08), 7, 15)
	ctx.save(); ctx.font = "900 %spx %s" % [fs, SERIF]; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineWidth = maxf(2, fs * 0.28); ctx.strokeStyle = "rgba(40,20,8,.95)"; ctx.lineJoin = "round"
	ctx.strokeText(text, cx, cy + 0.5); ctx.fillStyle = "#f6d58a"; ctx.fillText(text, cx, cy + 0.5); ctx.restore()
	if lv: lv_badge(ctx, cx + pw / 2 - 2, cy - 9, lv)

func sign_board(ctx: Ctx, x: float, y: float, text: String, lv) -> void:
	ctx.save(); ctx.font = "900 11.5px " + SERIF; var w: float = ctx.measureText(text).width + 14
	rr(ctx, x - 1.5, y - 6, 3, 10, 1, "#4a3020")
	rr(ctx, x - w / 2, y - 21, w, 16, 2, "#7a5634", "#2a1a0e", 1.4)
	ctx.fillStyle = "rgba(255,230,180,.15)"; ctx.fillRect(x - w / 2 + 2, y - 19, w - 4, 2)
	ctx.fillStyle = "#f6e2b0"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(text, x, y - 12.5); ctx.restore()
	if lv: lv_badge(ctx, x + w / 2 - 1, y - 23, lv)

func draw_building(ctx: Ctx, id: String, x: float, y: float, lv, t: float, extra = null) -> void:
	if id == "barracks": load("res://game/barracks/bk_art.gd").draw_building(ctx, x, y, lv, t); return   # [barracks] 兵營圖（bk_art.gd）
	var sd = hash(id) % 997
	seat(ctx, x, y + 1, BW[id], sd)   # [seat16] 踩實泥地＋排線接地影（代替原本嘅朦朧橢圓影）
	seat_back(ctx, x, y + 1, BW[id], sd)   # [fg16b]
	var iw = ink_w; ink_w = 0.0; cast(ctx, id, x, y + 2, BW[id]); ink_w = iw   # [seat16b]
	var r = put(ctx, id, x, y + 6, BW[id])
	seat_front(ctx, x, y + 1, BW[id], sd)
	var bname: String = DB.D.BUILDINGS[id].name
	if PLAQUE.has(id): plaque_text(ctx, r, PLAQUE[id], bname, lv)
	else: sign_board(ctx, x + (0.0 if id == "furnace" else BW[id] * 0.30), y + 12, bname, lv)
	if id == "furnace" and extra:
		var fx = r.position.x + r.size.x * 0.5; var fy = r.position.y + r.size.y * 0.62; var a = 0.35 + sin(t * 7) * 0.12
		var g = ctx.createRadialGradient(fx, fy, 2, fx, fy, 30); g.addColorStop(0, "rgba(255,170,60,%s)" % a); g.addColorStop(1, "rgba(255,170,60,0)")
		ctx.fillStyle = g; ctx.fillRect(fx - 30, fy - 30, 60, 60)

func draw_gate(ctx: Ctx, x: float, y: float, _t: float) -> void:
	seat_back(ctx, x, y + 1, BW.gate, 71)   # [fg16b]
	var r = vput(ctx, "gate", x, y + 6, BW.gate); plaque_text(ctx, r, PLAQUE.gate, "出村", 0)
	seat_front(ctx, x, y + 1, BW.gate, 71, false)   # [fg16] 門洞中間唔放嘢

func draw_site(ctx: Ctx, x: float, y: float, name: String) -> void:
	ctx.save(); ctx.font = "700 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"; var w = maxf(64, ctx.measureText(name).width + 22)
	el(ctx, x, y - 2, w * 0.7, 9, "rgba(60,48,36,.45)")
	ctx.setLineDash([3, 4]); ctx.strokeStyle = "rgba(236,217,164,.35)"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.ellipse(x, y - 2, w * 0.7, 11, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([])
	rr(ctx, x - 1.5, y - 30, 3, 28, 1, "#5a4030")
	rr(ctx, x - w / 2, y - 44, w, 20, 2, "#ecd9a4", "#5a4030", 1.5)
	ctx.fillStyle = "#2b1d12"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(name, x, y - 33.5)
	ctx.fillStyle = "#c2362b"; ctx.font = "900 10px sans-serif"; ctx.fillText("待建", x, y - 14)
	ctx.restore()

# [ruins13] 未起嘅地盤：廢墟（燒焦地、碎石、爛木、雜草）。can＝已解鎖可以起：加一塊細木牌「可重建」＋建築名；未解鎖：淨係廢墟（撳唔到）
var ruin_part := 0   # [perf] 0＝成個廢墟；1＝淨係廢墟（唔畫木牌，烘圖用）；2＝淨係木牌
func draw_ruin(ctx: Ctx, x: float, y: float, name: String, can: bool, seed: int, t := 0.0, req := "") -> void:
	if ruin_part != 2: _ruin_body(ctx, x, y, seed)   # [perf]
	if ruin_part == 1: return
	var rid2 = RUIN_IDS[seed] if seed >= 0 and seed < RUIN_IDS.size() else ""
	if rid2 != "" and load("res://game/rebuild/rb.gd").fixing(rid2): return   # [rebuild3] 搭緊棚：唔好再畫「可重建」木牌（細棟例如化寶爐、招魂台會喺竹棚後面露出一塊牌）
	if rid2 != "" and Spr.ok(rid2 + "_ruin"):   # [rebuild4] 有專屬廢墟圖：木牌擺喺廢墟腳邊（唔好遮住幅圖），冇樁
		var sr: Rect2 = ruin_sign_rect(rid2, name, req, can)
		_ruin_sign(ctx, x, y + sr.position.y + 50.0, name, can, t, req, sr.size.x)
		return
	_ruin_sign(ctx, x, y, name, can, t, req)
# [rebuild4] 廢墟圖嘅不透明範圍（相對建築位置；同 _ruin_body 一樣：闊 BW、底部中心對齊 y+6）
var _ruin_op := {}
func ruin_opaque(rid: String) -> Rect2:
	if _ruin_op.has(rid): return _ruin_op[rid]
	var r := Rect2(-40, -60, 80, 66)
	var tex = Spr.get_tex(rid + "_ruin")
	if tex != null:
		var w: float = float(BW.get(rid, 100)); var k = w / tex.get_width(); var h = tex.get_height() * k
		var img: Image = tex.get_image()
		var u := Rect2i(0, 0, tex.get_width(), tex.get_height())
		if img != null:
			if img.is_compressed(): img.decompress()
			u = img.get_used_rect()
		r = Rect2(-w / 2 + u.position.x * k, 6.0 - h + u.position.y * k, u.size.x * k, u.size.y * k)
	_ruin_op[rid] = r
	return r
# 木牌闊度（唔靠 ctx 量字：測試／撳屏範圍／雜物避位都用同一條數）：中日韓字 1 格、其他半格
func _txt_w(s: String, px: float) -> float:
	var n := 0.0
	for i in s.length(): n += 1.0 if s.unicode_at(i) > 0x2e7f else 0.58
	return n * px
func ruin_sign_w(name: String, req: String, can: bool) -> float:
	if can: return maxf(76.0, _txt_w(name, 14.0) + 20.0)
	return maxf(84.0, maxf(_txt_w(name, 14.0), _txt_w(req, 12.0)) + 20.0)
const SIGN_H := 34.0
const SIGN_GAP := 3.0   # 木牌頂同廢墟圖底嘅距離
# 木牌矩形（相對建築位置）：喺廢墟不透明範圍正下方、水平置中
func ruin_sign_rect(rid: String, name: String, req: String, can: bool) -> Rect2:
	var w = ruin_sign_w(name, req, can)
	return Rect2(-w / 2, ruin_opaque(rid).end.y + SIGN_GAP, w, SIGN_H)
const RUIN_IDS := ["house", "wood", "rice", "plank", "bun", "store", "home", "camp", "altar", "furnace"]   # 同 nv_village.BLD_SEED 一樣次序（seed＝index）
func _ruin_body(ctx: Ctx, x: float, y: float, seed: int) -> void:
	var rid = RUIN_IDS[seed] if seed >= 0 and seed < RUIN_IDS.size() else ""
	if rid != "" and Spr.ok(rid + "_ruin"):   # [rebuild] 美術 B 組：每棟專屬廢墟圖（同完成版同尺寸、底部中心對齊）
		var RB = load("res://game/rebuild/rb.gd")
		if RB.fixing(rid): return   # 搭緊棚：由 rb.draw_scaffold 畫（修復中圖＋接地層），廢墟唔好再疊喺底
		var w: float = BW[rid]
		seat(ctx, x, y + 1, w, seed)   # [rebuild2] 同完成版一樣嘅接地：泥地＋後景＋斜投影＋前景草石
		seat_back(ctx, x, y + 1, w, seed)
		cast(ctx, rid + "_ruin", x, y + 2, w)
		put(ctx, rid + "_ruin", x, y + 6, w)
		seat_front(ctx, x, y + 1, w, seed)
		ruin_front(ctx, x, y + 1, w, seed, RB.weed_k(rid))   # 廢墟加厚：雜草、碎瓦、斷木（清得越多越少）
		return
	el(ctx, x, y - 4, 54, 16, "rgba(24,16,12,.55)")
	el(ctx, x - 8, y - 6, 36, 10, "rgba(52,36,26,.45)")
	hatch(ctx, x, y - 4, 52, 15, 2.8, "rgba(14,8,6,.5)", 0.8, seed + 5)   # [seat16]
	var sv = tint; tint = Color(0.58, 0.52, 0.50)
	var flip = seed % 2 == 1
	if Spr.ok("zb_stakes"): put(ctx, "zb_stakes", x + (10.0 if flip else -10.0), y - 12, 70)
	if Spr.ok("zp_woodpile"): put(ctx, "zp_woodpile", x + (-20.0 if flip else 20.0), y + 2, 46)
	if Spr.ok("zb_rock1"): put(ctx, "zb_rock1", x + (24.0 if flip else -24.0), y + 6, 34)
	if Spr.ok("zb_rock2"): put(ctx, "zb_rock2", x + (2.0 if flip else -4.0), y + 10, 26)
	if Spr.ok("zb_bush"): put(ctx, "zb_bush", x + (-34.0 if flip else 34.0), y + 8, 28)
	tint = sv
	seat_front(ctx, x, y + 2, 104, seed + 40)   # [seat16]
# [rebuild2] 廢墟前景加厚：美術 B 組遮擋物件（野草碎瓦、斷木、碎磚、破紙紮、枯枝）壓喺廢墟底邊前面
#   k＝雜物剩餘比例 0.1–1：清得越多越疏；冇圖時退回墨線枯草＋畫碎瓦
const OVR_RUIN := ["weeds_a", "weeds_b", "weeds_c", "weeds_d"]
const OVR_JUNK := ["rubble_wood", "rubble_brick", "rubble_paper", "rubble_branch"]
const OVR_FIX := ["repair_lumber", "repair_bricks", "repair_rope", "repair_tools"]
const OVR_TINT := Color(0.74, 0.70, 0.68)   # 壓暗少少，貼返夜色地面
var _ov_tex := {}
func ov(ctx: Ctx, k: String, x: float, y: float, w: float, flip := false, tintc := OVR_TINT) -> bool:
	if not _ov_tex.has(k):
		var p = "res://assets/spr/ovr_%s.webp" % k
		_ov_tex[k] = load(p) if ResourceLoader.exists(p) else null
	var im = _ov_tex[k]
	if im == null: return false
	var h = w * im.get_height() / im.get_width()
	el(ctx, x, y - 1, w * 0.44, maxf(2.0, h * 0.14), "rgba(12,6,5,.40)")   # 貼地暗影
	ctx.ci.draw_set_transform_matrix(ctx.T * Transform2D(Vector2(-1.0 if flip else 1.0, 0), Vector2(0, 1), Vector2(x, y)))
	ctx.ci.draw_texture_rect(im, Rect2(-w / 2, -h, w, h), false, ctx._mod() * tintc)
	ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true
func ruin_front(ctx: Ctx, x: float, y: float, w: float, seed: int, k: float) -> void:
	var sd = seed * 13 + 7
	var n_w = int(round(1.0 + 2.0 * k))   # 野草碎瓦：1–3 叢，左右兩邊先
	var slots = [-0.36, 0.34, 0.02]
	var used = false
	for i in n_w:
		var gx = x + slots[i] * w + (_sr(sd, 30 + i) - 0.5) * 8.0
		used = ov(ctx, OVR_RUIN[int(_sr(sd, 40 + i) * 4.0) % 4], gx, y + 15 + _sr(sd, 60 + i) * 4.0, w * (0.42 + _sr(sd, 70 + i) * 0.08) * (0.8 + 0.2 * k), _sr(sd, 80 + i) > 0.5) or used
	if k > 0.4:   # 雜物：斷木／碎磚／破紙紮／枯枝 1–2 件
		var n_j = 1 if k < 0.75 else 2
		for i in n_j:
			var jx = x + (0.18 if i == 0 else -0.16) * w * (1.0 if _sr(sd, 90) > 0.5 else -1.0)
			ov(ctx, OVR_JUNK[int(_sr(sd, 100 + i) * 4.0) % 4], jx, y + 18 + i * 3.0, w * (0.34 + _sr(sd, 110 + i) * 0.06), _sr(sd, 120 + i) > 0.5)
	if used: return
	var n_t = int(round(2.0 + 6.0 * k))   # 冇圖：墨線枯草＋畫碎瓦
	for i in n_t:
		tuft(ctx, x + (_sr(sd, 90 + i) - 0.5) * w * 0.95, y + 8 + _sr(sd, 110 + i) * 12.0, 10.0 + _sr(sd, 130 + i) * 8.0 * (0.6 + k * 0.6), sd + i)
	for i in int(round(2.0 + 4.0 * k)):
		var tx = x + (_sr(sd, 150 + i) - 0.5) * w * 0.80; var ty = y + 10 + _sr(sd, 170 + i) * 10.0
		var a = _sr(sd, 190 + i) * 3.0; var s2 = 4.0 + _sr(sd, 210 + i) * 3.0
		var c = Vector2(cos(a), sin(a) * 0.45) * s2; var d = Vector2(-sin(a), cos(a) * 0.45) * s2 * 0.55
		poly(ctx, [tx - c.x - d.x, ty - c.y - d.y, tx + c.x - d.x, ty + c.y - d.y, tx + c.x + d.x, ty + c.y + d.y, tx - c.x + d.x, ty - c.y + d.y], ["#6a3a2a", "#5a3228", "#7a4a34"][i % 3], "#1a110a", 0.7)
# [rebuild2] 修復中前景：木料堆、新磚堆、麻繩麻袋、工具箱（左右各一件）＋完成版前景草石
func scaffold_front(ctx: Ctx, x: float, y: float, w: float, seed: int) -> void:
	var sd = seed * 17 + 3
	seat_front(ctx, x, y, w, seed)
	var i0 = int(_sr(sd, 1) * 4.0) % 4
	var ok = ov(ctx, OVR_FIX[i0], x - w * 0.34, y + 16, w * 0.40, false)
	ov(ctx, OVR_FIX[(i0 + 1 + int(_sr(sd, 2) * 3.0)) % 4], x + w * 0.34, y + 17, w * 0.38, true)
	if ok: return
	var bx = x + w * 0.30; var by = y + 16   # 冇圖：畫三層紅磚
	for r in 3:
		for c in 3 - r:
			var px = bx - (2 - r) * 5.5 + c * 11.0; var py = by - r * 5.5
			poly(ctx, [px - 5, py, px + 5, py, px + 5, py - 5, px - 5, py - 5], ["#8a4a32", "#7a4030", "#94563a"][(r + c) % 3], "#1a110a", 0.8)
func _ruin_sign(ctx: Ctx, x: float, y: float, name: String, can: bool, t: float, req: String, foot_w := 0.0) -> void:   # foot_w > 0：腳邊款（闊度固定、冇樁、唔浮）
	if not can:   # [ruins13b] 未解鎖：灰色木牌（建築名＋點樣開），唔郁
		ctx.save(); ctx.font = "900 14px %s" % SERIF; var w0 = maxf(84, maxf(ctx.measureText(name).width, ctx.measureText(req).width * 0.86) + 20)
		if foot_w > 0.0: w0 = maxf(foot_w, w0)
		else: rr(ctx, x - 1.5, y - 26, 3, 22, 1, "#4a3a30")
		rr(ctx, x - w0 / 2, y - 50, w0, 34, 3, "#a9a092", "#4a3a30", 1.5)
		ctx.textAlign = "center"; ctx.textBaseline = "middle"
		ctx.fillStyle = "#2b2420"; ctx.fillText(name, x, y - 40)
		ctx.fillStyle = "#5a2a20"; ctx.font = "900 12px sans-serif"; ctx.fillText(req, x, y - 25)
		ctx.restore(); return
	var bob = sin(t * 2.4) * 1.5 if foot_w <= 0.0 else 0.0
	ctx.save(); ctx.font = "900 14px %s" % SERIF; var w = maxf(76, ctx.measureText(name).width + 20)
	if foot_w > 0.0: w = maxf(foot_w, w)
	else: rr(ctx, x - 1.5, y - 26, 3, 22, 1, "#5a4030")
	rr(ctx, x - w / 2, y - 50 + bob, w, 34, 3, "#e6d2a0", "#5a4030", 1.5)
	ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.fillStyle = "#2b1d12"; ctx.fillText(name, x, y - 40 + bob)
	ctx.fillStyle = "#b8321f"; ctx.font = "900 12px sans-serif"; ctx.fillText("可重建", x, y - 25 + bob)
	ctx.restore()

const PERCH := [[-0.22, 0.40, 1], [0.24, 0.30, -1]]
func draw_tree(ctx: Ctx, x: float, y: float, hp: int, t: float, shake: bool, perched: bool, idx: int) -> void:
	if hp <= 0: vput(ctx, "stump", x, y + 3, 38); return
	var sx = sin(t * 60) * 2.2 if shake else 0.0; var H = 80.0 + (idx % 3) * 4
	seat(ctx, x, y + 2, 40, idx + 11, false)   # [seat16]
	ctx.save()
	if shake: ctx.translate(x, y); ctx.rotate(sin(t * 60) * 0.02); ctx.translate(-x, -y)
	var key = "tree_bare" if Spr.ok("tree_bare") else "tree"; var flip = idx % 2 == 1
	if flip: ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
	var tim = Spr.get_tex(key)
	if tim != null: cast(ctx, key, x + sx, y + 2, H * tim.get_width() / tim.get_height(), H)   # [seat16b]
	var r = vput(ctx, key, x + sx, y + 4, 0, H)
	ctx.restore()
	VS.tree_extra(ctx, x + sx, y, r, flip, t)   # [villageart] 樹洞臉／手指枝暗影
	if key == "tree_bare" and perched and Spr.ok("crowsit"):
		for p in PERCH:
			var cx: float = x + r.size.x * p[0] * (-1 if flip else 1) + sx; var cy: float = r.position.y + r.size.y * p[1]
			ctx.save(); ctx.translate(cx, cy); ctx.scale(p[2] * (-1 if flip else 1), 1); vput(ctx, "crowsit", 0, 0, 13); ctx.restore()

func draw_paddy(ctx: Ctx, x: float, y: float, ripe, _t: float, _i: int) -> void:
	if ripe: vput(ctx, "paddy", x, y + 9, 56); return
	if Spr.ok("paddy_cut"): vput(ctx, "paddy_cut", x, y + 9, 56); return
	ctx.save(); ctx.globalAlpha = 0.55; ctx.filter = "brightness(.55) saturate(.4)"; put(ctx, "paddy", x, y + 9, 56, 34); ctx.restore()

func draw_web(ctx: Ctx, cx: float, cy: float, r: float, a0: float, a1: float, alpha := 0.38) -> void:
	ctx.save(); ctx.strokeStyle = "rgba(225,225,235,%s)" % alpha; ctx.lineWidth = 0.6
	var n = 7
	for k in range(n + 1):
		var a = a0 + (a1 - a0) * k / n; ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(cx + cos(a) * r, cy + sin(a) * r); ctx.stroke()
	for ring in range(1, 6):
		var rr2 = r * ring / 5.4; ctx.beginPath()
		for k in range(n + 1):
			var a = a0 + (a1 - a0) * k / n; var sag = 0.88 if k % 2 else 1.0
			var px = cx + cos(a) * rr2 * sag; var py = cy + sin(a) * rr2 * sag
			if k: ctx.lineTo(px, py)
			else: ctx.moveTo(px, py)
		ctx.stroke()
	ctx.restore()

func draw_willo(ctx: Ctx, x: float, y: float, t: float) -> void:
	var fy = y + sin(t * 1.6 + x) * 5; var a = 0.5 + sin(t * 3 + x) * 0.25
	var g = ctx.createRadialGradient(x, fy, 1, x, fy, 14); g.addColorStop(0, "rgba(110,230,180,%s)" % a); g.addColorStop(1, "rgba(110,230,180,0)")   # [villageart] 病態青綠
	ctx.fillStyle = g; ctx.fillRect(x - 14, fy - 14, 28, 28)
	ctx.beginPath(); ctx.moveTo(x - 3, fy + 2); ctx.quadraticCurveTo(x - 3, fy - 5, x + sin(t * 5) * 1.5, fy - 9); ctx.quadraticCurveTo(x + 3, fy - 5, x + 3, fy + 2); ctx.arc(x, fy + 2, 3, 0, PI); ctx.fillStyle = "rgba(170,250,210,%s)" % (a + 0.2); ctx.fill()

const DECO := {"scarecrow": ["scarecrow", 0, 62], "grave": ["grave", 26, 0], "post": ["lamppost", 0, 46], "banana": ["banana", 0, 64]}
func draw_decor(ctx: Ctx, kind: String, x: float, y: float, t: float) -> void:
	if DECO.has(kind) and Spr.ok(DECO[kind][0]):
		var d: Array = DECO[kind]
		if kind == "banana": ctx.save(); ctx.translate(x, y); ctx.rotate(sin(t * 0.8 + x) * 0.02); vput(ctx, d[0], 0, 2, d[1], d[2]); ctx.restore(); return
		if kind == "scarecrow": ctx.save(); ctx.translate(x, y); ctx.rotate(sin(t * 0.9) * 0.03); vput(ctx, d[0], 0, 4, d[1], d[2]); ctx.restore(); return
		if kind == "post" and ResourceLoader.exists("res://assets/spr/fg_lamp1.webp"): draw_lamp(ctx, x, y, t); return   # [lamp16]
		vput(ctx, d[0], x, y + 3, d[1], d[2])
		if kind == "post":
			var a = 0.22 + sin(t * 2 + x) * 0.06; var g = ctx.createRadialGradient(x + 6, y - 30, 1, x + 6, y - 30, 18)
			g.addColorStop(0, "rgba(255,236,190,%s)" % a); g.addColorStop(1, "rgba(255,236,190,0)"); ctx.fillStyle = g; ctx.fillRect(x - 14, y - 50, 40, 40)
		return
	match kind:
		"willo": draw_willo(ctx, x, y, t)
		"webTL": draw_web(ctx, x, y, 30, 0, PI / 2, 0.32)
		"webTR": draw_web(ctx, x, y, 30, PI / 2, PI, 0.32)
		"offer":   # [villageart] 原本係香爐插香（紅線：唔准香燭）→ 改做矮石燈（位置不變，冇點擊）
			el(ctx, x, y - 1, 10, 3, "rgba(10,2,8,.45)")
			rr(ctx, x - 8, y - 5, 16, 5, 1, "#3a3436", "#141016", 1)          # 底座
			rr(ctx, x - 2.5, y - 12, 5, 7, 0.5, "#454044", "#141016", 0.8)     # 柱
			rr(ctx, x - 6, y - 21, 12, 9, 1, "#3e383c", "#141016", 1)          # 燈箱
			var a = 0.55 + sin(t * 1.7 + x) * 0.12
			rr(ctx, x - 3, y - 19, 6, 5, 0.5, "rgba(150,240,190,%s)" % a)      # 病態青綠微光
			poly(ctx, [x - 9, y - 21, x + 9, y - 21, x + 5, y - 26, x - 5, y - 26], "#2e292c", "#141016", 1)   # 石帽
			el(ctx, x, y - 27, 2, 1.5, "#2e292c", "#141016", 0.8)
			ctx.strokeStyle = "rgba(14,8,12,.6)"; ctx.lineWidth = 0.6; ctx.beginPath(); ctx.moveTo(x - 5, y - 4); ctx.lineTo(x - 2, y - 2); ctx.lineTo(x + 1, y - 4); ctx.stroke()   # 裂紋

func draw_crow(ctx: Ctx, x: float, y: float, s: float, ph: float, dir: float, perched: bool) -> void:
	var key = "crowsit" if perched else "crowfly"; var im = Spr.get_tex(key)
	if im == null: return
	ctx.save(); ctx.translate(x, y); ctx.scale(-1 if dir < 0 else 1, 1.0 if perched else 0.55 + absf(sin(ph)) * 0.55)
	var w = (12.0 if perched else 20.0) * s; var h = w * im.get_height() / im.get_width(); ctx.drawImage(im, -w / 2, -h / 2, w, h); ctx.restore()

func draw_lily(ctx: Ctx, x: float, y: float, t: float) -> void:
	ctx.strokeStyle = "#3a5a32"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(x, y + 12); ctx.lineTo(x, y + 2); ctx.stroke()
	ctx.strokeStyle = "rgba(214,40,52,.9)"; ctx.lineWidth = 1.5; ctx.lineCap = "round"
	for k in 6:
		var a = k / 6.0 * PI * 2 + sin(t * 0.6) * 0.15; ctx.beginPath(); ctx.moveTo(x, y)
		ctx.quadraticCurveTo(x + cos(a) * 4, y + sin(a) * 4 - 3, x + cos(a) * 7, y + sin(a) * 6 - 4); ctx.stroke()
	ctx.lineCap = "butt"
	ctx.fillStyle = "#ff6060"; ctx.beginPath(); ctx.arc(x, y, 1.6, 0, 6.3); ctx.fill()

# ---------------- 角色（照 art.js drawChar／drawMesh／drawPuppet／drawSprite）----------------
# 角色高度／實體表：JS 嗰邊（native/art.gd 或轉譯版 ART）嘅 CHAR_H／SOLID 會俾 n30_rigs、npc_antag 等模塊加嘢，以佢為準
const LIMB_POSES := {"": 1, "idle": 1, "move": 1, "walk": 1, "run": 1, "windup": 1, "strike": 1, "follow": 1, "recover": 1, "chop": 1, "hammer": 1, "proud": 1}
const MOVE_POSES := {"windup": 1, "strike": 1, "follow": 1, "recover": 1}
const PUPPET_ANIM := {"walk": 1, "run": 1, "startle": 1, "cower": 1, "tremble": 1, "phone": 1, "look": 1, "mop": 1, "faint": 1, "sip": 1, "stand": 1, "hold": 1, "shrug": 1, "windup": 1, "strike": 1, "recover": 1, "hurt": 1, "cast": 1, "die": 1, "chop": 1, "hammer": 1, "knead": 1, "reap": 1, "proud": 1}

func spr_key(type: String) -> String: return ("afu" if HV.active() else "afu_body") if type == "afu" else type   # [p47] 空手時經 Spr.key_for 換姿勢圖
func has_spr(type: String) -> bool: return char_h(type) > 0 and PtGfx.tex(spr_key(type)) != null
func _jart(k: String):
	var A = J.G.get("ART")
	return J.gp(A, k) if A != null else null
func char_h(type: String) -> float:
	if type.begins_with("soul_"): return SOUL_H   # [eastsoul]
	var h = _jart("CHAR_H")   # JS 表優先；原生另加嘅（巡陰 npc_kiln 等，JS 冇）用本地表
	if h is Dictionary and h.has(type) and J.t(h[type]): return J.num(h[type])
	return float(CHAR_H.get(type, 0))
func is_solid(type: String) -> bool:
	if SOLID.has(type): return true
	var so = _jart("SOLID")
	return so is Dictionary and J.t(so.get(type))
func _special_has(type: String) -> bool:
	var SP = J.G.get("SPECIAL")
	return SP != null and J.t(J.mc(SP, "has", [type]))
func _ma(): return J.G.get("MeshAnim")
func _ma_has(type: String) -> bool:
	if type == "afu" and DB.hero_female(): return false   # 女主冇網格骨架，用一般立繪（afuf_body）
	var M = _ma()
	return M != null and J.t(J.mc(M, "has", [type]))
static func _ot(o: Dictionary) -> float: return J.num(o.get("t")) if J.t(o.get("t")) else 0.0
static func _pz(o: Dictionary) -> String: return J.str(o.pose) if o.get("pose") != null else ""

# js = true：照網頁版，有 o.act 就交俾 DAILY（JS ART.drawChar 叫）；原生場景要講明 o._daily
# [eastsoul] 遊魂一律用東方亡魂（有樣貌、冇腳、下身一縷煙；全部成年人／老人），唔再用白布西方鬼
#   邊一隻：o.seed（每個角色固定，例如客人 ph、戰鬥單位）；冇 seed 就用返做 OT 嗰隻（返工男）
const SOULS := ["soul_a", "soul_b", "soul_c", "soul_d", "soul_f", "soul_g", "soul_h", "soul_i", "soul_j", "soul_k", "soul_l", "soul_m", "soul_n", "soul_p", "soul_q", "soul_r"]
const SOUL_H := 50.0
func soul_of(o: Dictionary) -> String:
	var sd = o.get("seed")
	if sd == null: return "soul_i"
	if sd is String and SOULS.has(sd): return sd
	return SOULS[absi(hash(str(sd))) % SOULS.size()]
func draw_char(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary = {}, js := false) -> void:
	if type == "youhun" and not J.t(o.get("oldGhost")) and PtGfx.tex("soul_i") != null: type = soul_of(o)   # [eastsoul]
	o["t"] = _ot(o)
	if type.begins_with("soul_") and PtGfx.tex(type) != null: _draw_soul(ctx, type, x, y, s, o); return
	if type == "afu" and HV.active():   # [p47] 主角：任何場景都係空手姿勢＋漂浮兵器（做嘢用做工動畫）
		ctx.save()
		if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
		HV.draw(ctx, x, y, s, o); ctx.restore(); return
	if ACE.STAGES.has(type) and ACE.active(type): _draw_plain(ctx, type, x, y, s, o); return   # [p44] 王牌階段圖：整張圖畫（唔用網格／木偶，嗰啲係手持兵器原圖）
	if char_h(type) > 0 and _ma_has(type) and not _special_has(type) and not J.t(o.get("noMesh")):
		_draw_mesh(ctx, type, x, y, s, o, js, false); return
	var PU = J.G.get("Puppet")
	if PU != null and J.t(J.mc(PU, "has", [type])) and not J.t(o.get("noPuppet")):
		ctx.save()
		if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
		if J.t(o.get("rot")): ctx.translate(x, y - 15 * s); ctx.rotate(J.num(o.rot)); ctx.translate(-x, -(y - 15 * s))
		_draw_puppet(ctx, type, x, y, s, o); ctx.restore(); return
	_draw_plain(ctx, type, x, y, s, o)

# [eastsoul] 東方亡魂：直接逐段畫圖（下身慢慢淡出、輕輕擺），唔用錄製＋逐點淡出（戰鬥入面一次十幾隻都夠快）
const SOUL_SL := 7
func _draw_soul(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var img = PtGfx.tex(type); var iw = float(img.get_width()); var ih = float(img.get_height())
	var t: float = J.num(o.get("t", 0.0)); var H = SOUL_H * s; var Wd = H * iw / ih
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	var base = ctx.globalAlpha
	if not (o.get("shadow") is bool and o.shadow == false) and not J.t(o.get("noShadow")):
		ctx.save(); ctx.globalAlpha = base * 0.55; shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore()
	var r = 0.0; var sc = 1.0
	if J.t(o.get("walk")): r += sin(t * 6.0) * 0.05
	if J.t(o.get("work")): r += sin(t * 10.0) * 0.08
	if J.t(o.get("atk")): sc = 1.08
	if J.t(o.get("rot")): r += J.num(o.rot)
	var fy = y - (5 + sin(t * 2.4) * 2.5) * s
	ctx.translate(x, fy)
	if r != 0.0: ctx.rotate(r)
	if J.t(o.get("flip")): ctx.scale(-sc, sc)
	elif sc != 1.0: ctx.scale(sc, sc)
	for i in SOUL_SL:
		var f0 = float(i) / SOUL_SL; var f1 = float(i + 1) / SOUL_SL
		var fa = 1.0 if f1 <= 0.62 else clampf(1.0 - (f0 - 0.62) / 0.38, 0.12, 1.0)
		var sway = sin(t * 2.2 + f0 * 3.0) * 2.2 * s * f0
		ctx.globalAlpha = base * fa
		ctx.drawImage(img, 0.0, ih * f0, iw, ih * (f1 - f0), -Wd / 2 + sway, -H + H * f0, Wd, H * (f1 - f0) + 0.6)
	ctx.restore()

# MOVES 交返 false 之後（BtMoves 叫）：由 custom／Limbs／網格繼續畫，唔再入 MOVES
func draw_char_after_moves(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	o["t"] = _ot(o)
	if char_h(type) > 0 and _ma_has(type) and not _special_has(type) and not J.t(o.get("noMesh")): _draw_mesh(ctx, type, x, y, s, o, false, true)
	else: draw_char(ctx, type, x, y, s, o)

func _arg(type: String, x: float, y: float, s: float, H: float, o: Dictionary, solid: bool, ctx: Ctx) -> Dictionary:
	var sh = func(_t, a):
		var k = J.arg(a, 1)
		shadow(ctx, J.num(J.arg(a, 0)), y + 1 * s, s * (J.num(k) if J.t(k) else (1.0 if solid else 0.8))); return null
	return {"type": type, "x": x, "y": y, "s": s, "H": H, "o": o, "faceRight": not J.t(o.get("flip")), "solid": solid, "shadow": sh}

func _hand(ctx: Ctx, fn, a: Dictionary, o: Dictionary) -> bool:
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	var done = J.cl(fn, null, [ctx, a])
	ctx.restore()
	return not (done is bool and done == false)

func _draw_mesh(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary, js: bool, skip_moves: bool) -> void:
	var solid = is_solid(type) or J.t(o.get("solid")); var H: float = char_h(type) * s; var t: float = o.t   # [herobig] o.solid：當實體畫（主角）
	var pose = _pz(o)
	# 平日動作（DAILY[act]）：回傳 false 先照一般畫法
	var act = o.get("act")
	if J.t(act) and (js or J.t(o.get("_daily"))):
		act = J.str(act)
		if not js and ScDaily.has(act):   # 回陽間辦公室嗰批動作（原生 game/scare/sc_daily.gd）
			ctx.save()
			if o.get("alpha") != null: ctx.globalAlpha = float(o.alpha)
			var ok = ScDaily.draw(ctx, act, {"type": type, "x": x, "y": y, "s": s, "H": H, "o": o, "faceRight": not o.get("flip", false), "solid": solid})
			ctx.restore()
			if ok: return
		else:
			var DA = J.G.get("DAILY")
			if DA is Dictionary and J.t(DA.get(act)) and _hand(ctx, DA[act], _arg(type, x, y, s, H, o, solid, ctx), o): return
	# 專屬招式（MOVES[type]）
	if not skip_moves and MOVE_POSES.has(pose):
		var MV = J.G.get("MOVES")
		if MV is Dictionary and J.t(MV.get(type)) and _hand(ctx, MV[type], _arg(type, x, y, s, H, o, solid, ctx), o): return
	var R = J.gp(J.gp(_ma(), "RIG"), type)
	if R is Dictionary and J.t(R.get("custom")) and _hand(ctx, R.custom, _arg(type, x, y, s, H, o, solid, ctx), o): return
	var A = J.gp(_ma(), "ANIM")
	var fy = y - (0.0 if solid else (3 + sin(t * 2.4) * 2) * s)
	var LB = J.G.get("Limbs")
	if LB != null and J.t(J.mc(LB, "has", [type])) and LIMB_POSES.has(pose) and not J.t(o.get("hurt")):
		var walking = J.t(o.get("walk")) or pose == "move" or pose == "walk" or pose == "run"
		var mp = J.cl(A.walk if walking else A.idle, null, [t])
		ctx.save()
		if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
		if not (o.get("shadow") is bool and o.shadow == false):
			ctx.save()
			if not solid: ctx.globalAlpha *= 0.55
			shadow(ctx, x, y + 1 * s, s * (1.0 if solid else 0.8)); ctx.restore()
		var tip = J.mc(LB, "draw", [ctx, type, x, fy, H, o, not J.t(o.get("flip")), mp])
		ctx.restore()
		if J.t(o.get("tipOut")): J.sp(o.tipOut, "p", tip)
		return
	var pz = mesh_pose(A, type, o)
	if R is Dictionary and J.t(R.get("tweak")): J.cl(R.tweak, null, [pz, o])
	if R is Dictionary and J.t(R.get("hop")) and (J.t(o.get("walk")) or J.t(o.get("enemy")) or pose == "move"): pz["y"] = (J.num(pz.y) if J.t(pz.get("y")) else 0.0) - absf(sin(t * 5)) * 0.09
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	if not (o.get("shadow") is bool and o.shadow == false):
		ctx.save()
		if not solid: ctx.globalAlpha *= 0.55
		shadow(ctx, x, y + 1 * s, s * (1.0 if solid else 0.8)); ctx.restore()
	J.mc(_ma(), "draw", [ctx, type, x, fy, H, pz, not J.t(o.get("flip"))])
	ctx.restore()

# art.js meshPose：動作名 → 骨頭姿勢（用 JS 嗰邊嘅 MeshAnim.ANIM）
func mesh_pose(A, type: String, o: Dictionary) -> Dictionary:
	var t: float = o.t; var p = clampf(J.num(o.get("pt")) if J.t(o.get("pt")) else 0.0, 0, 1)
	var f = func(k: String, args: Array): return J.cl(J.gp(A, k), null, args)
	var pose = _pz(o)
	match pose:
		"windup", "strike", "follow", "recover", "cast", "die", "air", "down": return f.call(pose, [p, t, type])
		"faint": return f.call("die", [p, t])
		"hurt": return f.call("hurtP", [p, t])
		"scared", "startle", "tremble", "cower": return f.call("scared", [t])
		"chop", "hammer":
			var q = p if pose == "chop" else fmod(p * 2, 1.0)
			return f.call("windup", [q / 0.72, t, type]) if q < 0.72 else f.call("strike", [(q - 0.72) / 0.28, t, type])
		"reap": return f.call("strike", [absf(sin(p * PI * 3)), t, type])
		"knead":
			var z = f.call("idle", [t]); z["body"] = 0.15 + sin(p * PI * 4) * 0.05; z["y"] = (J.num(z.y) if J.t(z.get("y")) else 0.0) + absf(sin(p * PI * 4)) * 0.02; z["armF"] = 0.3; z["armB"] = -0.3; return z
		"proud":
			var z2 = f.call("idle", [t]); z2["head"] = -0.12; z2["body"] = -0.05; return z2
		"run", "move", "walk": return f.call("walk", [t * (1.8 if pose == "run" else 1.0)])
	if J.t(o.get("hurt")): return f.call("hurtP", [0.3, t])
	if J.t(o.get("atk")): return f.call("strike", [0.6, t, type])
	if J.t(o.get("walk")): return f.call("walk", [t])
	return f.call("idle", [t])

# art.js drawPuppet（木偶分件；PUPPET_ON 關咗時唔會行到）
func _draw_puppet(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var PU = J.G.Puppet; var A = J.gp(PU, "ANIMS"); var pose = _pz(o)
	var name = pose if pose != "" and J.t(J.gp(A, pose)) else ("move" if J.t(o.get("walk")) else "idle")
	if not J.t(J.mc(PU, "armed", [type])) and J.t(J.gp(A, name + "C")): name = name + "C"
	if J.t(o.get("hurt")) and J.t(J.gp(A, "hurt")): name = "hurt"
	var R = J.gp(J.gp(PU, "RIGS"), type); var human = R != null and J.t(J.gp(R, "lF"))
	if human and name == "idle": name = "stand"
	if human and name == "move": name = "walk"
	var T1 = {"idle": 1, "move": 1, "walk": 1, "run": 1, "look": 1, "mop": 1, "sip": 1, "stand": 1, "hold": 1}
	var pz = J.cl(J.gp(A, name), null, [o.t] if T1.has(name) else [J.num(o.get("pt")) if J.t(o.get("pt")) else 0.0, o.t])
	if J.t(o.get("face")): pz["hk"] = o.face
	if J.t(o.get("weapon")):
		pz["wpn"] = o.weapon
		if not J.t(pz.get("tool")) and type == "afu": pz["tool"] = "_W"; pz["tr"] = -(J.num(pz.get("aF")) + J.num(pz.get("eF"))) + 0.25
	if J.t(o.get("cloth")): pz["cloth"] = o.cloth
	if J.t(o.get("badge")): pz["badge"] = o.badge
	if not J.t(pz.get("tool")) and type != "afu" and not human and J.t(J.mc(PU, "armed", [type])): pz["tool"] = "_W"; pz["tr"] = -(J.num(pz.get("aF")) + J.num(pz.get("eF"))) + 0.15
	if not PUPPET_ANIM.has(name) and J.t(o.get("atk")): pz["aF"] = 1.6; pz["eF"] = 0.1
	if HOP.has(type) and (name == "idle" or name == "move"):
		pz["aF"] = 1.5; pz["eF"] = 0.05; pz["aB"] = 1.4; pz["eB"] = 0.05; pz["lean"] = 0
		if name == "move" or J.t(o.get("enemy")): pz["dy"] = -absf(sin(o.t * 5)) * 7
	var sol = is_solid(type)
	if not (o.get("shadow") is bool and o.shadow == false): shadow(ctx, x, y + 1 * s, s * (1.0 if sol else 0.8))
	J.mc(PU, "draw", [ctx, type, x, y - (0.0 if sol else (3 + sin(o.t * 2.4) * 2) * s), char_h(type) * s * 1.08, pz, not J.t(o.get("flip"))])

# 冇骨架嘅角色：整張圖（drawSprite）或者程序畫法（DRAW）；鬼就浮起，下半身漸隱
const TIE := {"x0": 618, "x1": 946, "y0": 462, "y1": 648, "ow": 953}
var last_fade_raw: Recorder = null   # 對照用：漸隱之前嘅原始指令
func _draw_plain(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var spr = has_spr(type)
	var f = func(c: Ctx, xx: float, yy: float) -> void:
		if spr: _draw_sprite(c, type, xx, yy, s, o)
		else: _draw_youhun(c, xx, yy, s, o)
	var ghost = not is_solid(type) and not J.t(o.get("solid"))   # [herobig]
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	if not (o.get("shadow") is bool and o.shadow == false):
		if ghost: ctx.save(); ctx.globalAlpha *= 0.55; shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore()
		else: shadow(ctx, x, y + 1 * s, s)
	var fl = J.t(o.get("flip"))
	if type == "afu" and DB.hero_female(): fl = not fl   # [face] 女主立繪原圖向左（男主骨架預設向右）→ 反轉，武器同面向一致
	if fl: ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
	if J.t(o.get("rot")): ctx.translate(x, y - 15 * s); ctx.rotate(J.num(o.rot)); ctx.translate(-x, -(y - 15 * s))
	if not ghost: f.call(ctx, x, y); ctx.restore(); return
	# 飄浮：網頁版先畫入暫存畫布再用 destination-out 漸層擦淡下半身；Godot 冇呢種混合 → 錄低再按高度逐點乘透明度（效果一樣）
	var fy = y - (3 + sin(o.t * 2.4) * 2) * s
	var raw = Recorder.new(); var bc = Ctx.new(raw); bc.font = ctx.font
	f.call(bc, x, fy)
	last_fade_raw = raw
	var st = [[0.0, 0.0], [0.6, 0.22], [1.0, 0.55]] if spr else [[0.0, 0.0], [0.55, 0.55], [1.0, 0.92]]
	var faded = fade_rec(raw, fy - 13 * s, fy + 6 * s, fy + 17 * s, st)
	if ctx.ci is Recorder: ctx.ci.rec(faded, ctx.T, ctx.globalAlpha)
	else: faded.replay(ctx.ci, ctx.T, ctx.globalAlpha); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	ctx.restore()

# 垂直漸隱遮罩：y∈[g0, r1] 之間按漸層（g0→g1，stops = [位置, 擦走嘅透明度]）乘 (1-a)；之外不變
static func _fade_a(Y: float, g0: float, g1: float, r1: float, st: Array) -> float:
	if Y < g0 or Y > r1: return 1.0
	var p = clampf((Y - g0) / maxf(0.0001, g1 - g0), 0, 1)
	for i in range(1, st.size()):
		if p <= st[i][0]:
			var q = (p - st[i - 1][0]) / maxf(0.0001, st[i][0] - st[i - 1][0])
			return 1.0 - (st[i - 1][1] + (st[i][1] - st[i - 1][1]) * q)
	return 1.0 - st[-1][1]

static func fade_rec(raw: Recorder, g0: float, g1: float, r1: float, st: Array) -> Recorder:
	var out = Recorder.new(); var cur = Transform2D.IDENTITY
	var ys = [g0, r1]
	for e in st: ys.append(g0 + (g1 - g0) * e[0])
	for c in raw.cmds:
		match c[0]:
			0: cur = c[1]; out.cmds.append(c)
			5, 6:
				var tex: Texture2D = c[1]; var r: Rect2 = c[2]; var m: Color = c[4] if c[0] == 6 else c[3]
				var src: Rect2 = c[3] if c[0] == 6 else Rect2(0, 0, tex.get_width(), tex.get_height())
				var tw = float(tex.get_width()); var th = float(tex.get_height())
				# 喺遮罩範圍入面嘅高度切成橫條（每條頂底各自計透明度；漸層分段點都落喺切線上）
				var ylo = minf((cur * r.position).y, (cur * (r.position + r.size)).y); var yhi = maxf((cur * r.position).y, (cur * (r.position + r.size)).y)
				if yhi < g0 or ylo > r1: out.cmds.append(c); continue
				var vs = [0.0, 1.0]
				var n = clampi(int(ceil(absf(yhi - ylo) / 2.0)), 1, 24)
				for i in range(1, n): vs.append(float(i) / n)
				var inv = cur.affine_inverse()
				for Yc in ys:
					var lp = inv * Vector2((cur * r.position).x, Yc)
					var v = (lp.y - r.position.y) / maxf(0.0001, r.size.y)
					if v > 0 and v < 1: vs.append(v)
				vs.sort()
				var pts = PackedVector2Array(); var uvs = PackedVector2Array(); var cols = PackedColorArray(); var idx = PackedInt32Array()
				for v in vs:
					for u in [0.0, 1.0]:
						var lp2 = r.position + Vector2(u * r.size.x, v * r.size.y); var wp = cur * lp2
						pts.append(wp); uvs.append(Vector2((src.position.x + u * src.size.x) / tw, (src.position.y + v * src.size.y) / th))
						var cc = m; cc.a *= _fade_a(wp.y, g0, g1, r1, st); cols.append(cc)
				for i in range(vs.size() - 1):
					var b0 = i * 2
					idx.append_array([b0, b0 + 1, b0 + 3, b0, b0 + 3, b0 + 2])
				out.cmds.append([0, Transform2D.IDENTITY]); out.cmds.append([10, idx, pts, cols, uvs, tex]); out.cmds.append([0, cur])
			10:
				var cols2: PackedColorArray = (c[3] as PackedColorArray).duplicate(); var pts2: PackedVector2Array = c[2]
				for i in cols2.size(): cols2[i].a *= _fade_a((cur * pts2[i]).y, g0, g1, r1, st)
				out.cmds.append([10, c[1], pts2, cols2, c[4], c[5]])
			4:
				var pp: PackedVector2Array = c[1]; var cen = Vector2.ZERO
				for q in pp: cen += q
				cen /= maxf(1, pp.size()); var c4: Color = c[2]; c4.a *= _fade_a((cur * cen).y, g0, g1, r1, st)
				out.cmds.append([4, pp, c4])
			_: out.cmds.append(c)
	return out

func _draw_sprite(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	if _special_has(type) and not (ACE.STAGES.has(type) and ACE.active(type)): J.mc(J.G.SPECIAL, "draw", [ctx, type, x, y, s, o]); return
	var key = spr_key(type); var img = PtGfx.tex(key); var iw = float(img.get_width()); var ih = float(img.get_height())
	var t: float = o.t; var H: float = char_h(type) * s * ACE.h_k(type); var Wd = H * iw / ih   # [p44] 闊身階段圖收細少少
	var sy = 1 + sin(t * 2.2) * 0.02; var sx = 1 - (sy - 1) * 0.5; var r = 0.0; var dy = 0.0
	if J.t(o.get("walk")): r += sin(t * 9) * 0.07; dy -= absf(sin(t * 9)) * 1.5 * s
	if J.t(o.get("work")): r += sin(t * 12) * 0.12
	if HOP.has(type) and (J.t(o.get("walk")) or J.t(o.get("enemy"))): dy -= absf(sin(t * 5)) * 5 * s
	if J.t(o.get("atk")): sx *= 1.08; sy *= 1.08
	ctx.save(); ctx.translate(x, y + dy); ctx.rotate(r); ctx.scale(sx, sy)
	ctx.drawImage(img, -Wd / 2, -H, Wd, H)
	var tie = PtGfx.tex("afu_tie") if type == "afu" else null
	if tie != null:   # 阿福領帶：分成直條，像在風裡飄
		var tw = float(tie.get_width()); var p = tw / TIE.ow; var kx = Wd / tw; var ky = H / float(tie.get_height())
		var sx0 = TIE.x0 * p; var sx1 = minf(tw, TIE.x1 * p); var sy0 = TIE.y0 * p; var sh = (TIE.y1 - TIE.y0) * p
		var ln = sx1 - sx0; var step = maxf(1, 2 * p); var amp = H * 0.032
		var cx = sx0
		while cx < sx1:
			var d = (cx - sx0) / p; var fr = (cx - sx0) / ln
			var off = sin(t * 6 - d * 0.016) * amp * pow(fr, 1.3) + sin(t * 2.7) * amp * 0.45 * fr
			var w = minf(step, sx1 - cx)
			ctx.drawImage(tie, cx, sy0, w, sh, -Wd / 2 + cx * kx, -H + sy0 * ky + off, w * kx + 0.6, sh * ky)
			cx += step
	ctx.restore()

# DRAW.youhun（冇素材時嘅後備畫法；網頁版 DRAW[type] || DRAW.youhun，其他程序畫法有素材就唔會用到）
func _draw_youhun(ctx: Ctx, x: float, y: float, s: float, o: Dictionary) -> void:
	var t: float = o.t; var hy = y - 26 * s - sin(t * 3) * 2 * s
	ctx.globalAlpha *= 0.88
	var gy = y - sin(t * 3) * 2 * s
	ctx.beginPath(); ctx.moveTo(x - 9 * s, gy - 16 * s)
	ctx.quadraticCurveTo(x - 10 * s, gy - 4 * s, x - 4 * s + sin(t * 4) * 2 * s, gy)
	ctx.quadraticCurveTo(x, gy - 5 * s, x + 4 * s + sin(t * 4 + 1) * 2 * s, gy + 1 * s)
	ctx.quadraticCurveTo(x + 10 * s, gy - 4 * s, x + 9 * s, gy - 16 * s); ctx.closePath()
	ctx.fillStyle = "#dfeaff"; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 1.5 * s; ctx.stroke()
	el(ctx, x, hy, 12 * s, 12 * s, "#e9f1ff", OUT, 1.6 * s)
	var dx = 5 * s; var ey = hy + 1 * s + 1 * s
	if J.t(o.get("enemy")):
		el(ctx, x - dx, ey + 0.5 * s, 1.7 * s, 1.9 * s, OUT); el(ctx, x + dx, ey + 0.5 * s, 1.7 * s, 1.9 * s, OUT)
		ctx.strokeStyle = OUT; ctx.lineWidth = 1.5 * s; ctx.beginPath()
		ctx.moveTo(x - dx - 3 * s, ey - 3.5 * s); ctx.lineTo(x - dx + 2.5 * s, ey - 1.8 * s)
		ctx.moveTo(x + dx + 3 * s, ey - 3.5 * s); ctx.lineTo(x + dx - 2.5 * s, ey - 1.8 * s); ctx.stroke()
	else: el(ctx, x - dx, ey, 1.5 * s, 1.8 * s, OUT); el(ctx, x + dx, ey, 1.5 * s, 1.8 * s, OUT)
	ctx.strokeStyle = OUT; ctx.lineWidth = 1.2 * s
	el(ctx, x, hy + 7 * s, 2.2 * s, 1.8 * s, "#5a1020")
	el(ctx, x + 10 * s, hy - 10 * s, 2 * s, 3 * s, "rgba(160,230,255,.8)")

# 頭像（UI 用）：由原圖頂部裁一個正方形
const PCROP := {"baiwu": [0.30, 0.95], "heiwu": [0.30, 0.95], "penanggal": [0.02, 0.85], "eguiking": [0.0, 0.8], "huang": [0.0, 0.8], "niutou": [0.04, 0.82], "mamian": [0.04, 0.82], "afu": [0.0, 0.72], "tree": [0, 1], "lg_dpl_bing": [0.15, 0.75], "lg_wkj_tank": [0.21, 0.8], "lg_zzj_king": [0.28, 0.9], "lg_wkj_elite": [0.13, 0.86]}   # [p44] 軍團空手改姿勢：古惑鬼頭位降低
func portrait_region(type: String) -> Array:
	var key = spr_key(type)
	var img = PtGfx.tex(key)
	if img == null: return []
	var iw = float(img.get_width()); var ih = float(img.get_height())
	var c: Array = PCROP.get(type, [0.0, 0.86])
	if ACE.STAGES.has(type) and Spr.key_for(type) != type:   # [p44] 階段圖（已裁到內容）：由頂部取頭膊；無常頂帽高，向下移少少
		var S2 = minf(iw, ih * 0.6); var sy2 = ih * (0.13 if type in ["heiwu", "baiwu"] else 0.0)
		return [img, Rect2((iw - S2) / 2, sy2, S2, S2)]
	if (not PCROP.has(type) or type == "afu") and not (type in FACE_SKIP):   # [p55] 冇指定裁位：由圖嘅透明度自動搵塊面（頭頂下面 15–55%），唔再淨係切到額頭
		var fr = face_rect(img, key)
		if fr.size.x > 0.0: return [img, fr]
	var hv = type == "afu" and HV.active()   # [p47] 空手姿勢圖：頭喺正中，唔使向右移
	if hv: c = [0.0, 0.62]
	var S = minf(iw * c[1], ih); var sx = (iw - S) / 2 + (iw * 0.1 if type == "afu" and not hv else 0.0); var sy = minf(ih - S, iw * c[0])
	return [img, Rect2(clampf(sx, 0, iw - S), maxf(0, sy), S, S)]

const FACE_SKIP := ["n30_wutou", "lg_jsj_wutou", "n30_pelesit", "n30_xiangcai", "nw_bajang", "nw_zzcar", "nw_shen", "nw_jinmenken", "nw_teketeke"]   # [p55] 冇頭／唔係人形：照舊裁法（逐隻睇過）
# [p55] 自動搵塊面：縮細圖 → 實心範圍（alpha）→ 頭部（實心頂 12–40% 嘅行）中心同闊度 → 正方形
var _face_cache := {}
func face_rect(img: Texture2D, key: String) -> Rect2:
	if _face_cache.has(key): return _face_cache[key]
	var r = _face_calc(img)
	_face_cache[key] = r
	return r
func _face_calc(img: Texture2D) -> Rect2:
	var im: Image = img.get_image() if img != null else null
	if im == null or im.get_width() < 8: return Rect2()
	if im.is_compressed(): im.decompress()
	var iw = float(im.get_width()); var ih = float(im.get_height())
	var sw = 64; var sh = maxi(8, int(round(ih * 64.0 / iw)))
	var sm = im.duplicate(); sm.resize(sw, sh, Image.INTERPOLATE_BILINEAR)
	var A = 0.35
	var y0 = -1; var y1 = -1
	for y in sh:
		for x in sw:
			if sm.get_pixel(x, y).a > A:
				if y0 < 0: y0 = y
				y1 = y; break
	if y0 < 0: return Rect2()
	var Hc = float(y1 - y0 + 1)
	var cs = []; var ws = []
	for y in range(y0 + int(Hc * 0.12), y0 + int(Hc * 0.40) + 1):
		var a = -1; var b = -1
		for x in sw:
			if sm.get_pixel(x, y).a > A:
				if a < 0: a = x
				b = x
		if a >= 0: cs.append((a + b) / 2.0); ws.append(float(b - a + 1))
	if ws.is_empty(): return Rect2()
	ws.sort(); cs.sort()
	var hw = ws[ws.size() / 2]; var cx = cs[cs.size() / 2]
	var S = clampf(hw * 1.25, Hc * 0.30, minf(Hc * 0.60, float(sw)))
	var cy = y0 + Hc * 0.27
	var top = maxf(float(y0) - Hc * 0.03, cy - S * 0.5)
	var k = iw / float(sw)
	var R = Rect2((cx - S / 2.0) * k, top * k, S * k, S * k)
	R.position.x = clampf(R.position.x, 0.0, maxf(0.0, iw - R.size.x)); R.position.y = clampf(R.position.y, 0.0, maxf(0.0, ih - R.size.y))
	return R
