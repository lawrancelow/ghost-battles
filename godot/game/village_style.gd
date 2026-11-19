# [villageart] 原版村子新畫風：調色（樹／稻田／路燈／擺設／出村門）、建築底血霧、整體夜色＋四角暗角
# 只改畫法，唔改任何位置／點擊範圍。用法：
#   nv_village._build() 尾：VS.attach(self)    ← 加血霧層（ysort 之下）＋夜色層（top_ui 之下）
#   core/art.gd 畫樹／稻田／擺設／出村門：Art.tint = VS.tint_for(key)
# 熱更新：冇 class_name、冇 autoload；靠 preload 用
extends RefCounted

# 舊圖（光、偏暖）壓暗調色，貼近參考背景（暗赭褐＋深紫黑）
const TINT := {
	"tree": Color(0.60, 0.52, 0.56), "tree_bare": Color(0.60, 0.52, 0.56), "stump": Color(0.58, 0.50, 0.52),
	"paddy": Color(0.62, 0.58, 0.50), "paddy_cut": Color(0.55, 0.50, 0.46),
	"lamppost": Color(0.70, 0.62, 0.60), "banana": Color(0.50, 0.54, 0.48), "grave": Color(0.52, 0.50, 0.56),
	"scarecrow": Color(0.62, 0.55, 0.55), "gate": Color(0.66, 0.58, 0.60), "crowsit": Color(0.70, 0.66, 0.72),
}
const NIGHT := Color(0.06, 0.02, 0.10, 0.16)

static var _vig: Texture2D

static func tint_for(key: String) -> Color: return TINT.get(key, Color.WHITE)

# ---------------- 掛鈎 ----------------
static func attach(nv) -> void:
	if nv.world == null or nv.world.has_node("va_mist"): return
	var m = Layer.new(); m.name = "va_mist"; m.fn = func(c): draw_mist(c, nv, false)
	nv.world.add_child(m); nv.world.move_child(m, nv.ysort.get_index())          # 後層：地面之上、建築之下
	var mf = Layer.new(); mf.name = "va_mist_f"; mf.fn = func(c): draw_mist(c, nv, true)
	nv.world.add_child(mf); nv.world.move_child(mf, nv.ysort.get_index() + 1)    # 前層：建築之上
	var n = Layer.new(); n.name = "va_night"; n.fn = func(c): draw_night(c, nv)
	nv.world.add_child(n); nv.world.move_child(n, nv.top_ui.get_index())         # 泡泡／浮字／箭頭之下

class Layer extends Node2D:
	var fn: Callable
	func _process(_dt: float) -> void:
		if is_visible_in_tree(): queue_redraw()
	func _draw() -> void:
		if fn.is_valid(): fn.call(self)

# ---------------- 血霧：用通用版 game/outpost/mv_mist.gd（後層喺建築下、前層喺建築上）----------------
const MIST = preload("res://game/outpost/mv_mist.gd")
static func draw_mist(c: CanvasItem, nv, front: bool) -> void:
	var S = J.G.get("S"); var POS = J.G.get("POS"); var order = J.G.get("BLD_ORDER")
	if not (S is Dictionary) or POS == null or order == null: return
	var BW: Dictionary = Art.BW
	for id in order:
		if not POS.has(id) or not J.t(S.bld.get(id, 0)) or not BW.has(id): continue
		var im = Spr.get_tex(id)
		if im == null: continue
		var p = POS[id]; var w: float = BW[id]; var h = w * im.get_height() / im.get_width()
		var base = Vector2(J.num(p[0]), J.num(p[1]) + 6.0 - h * 0.005)   # 新圖地面線約圖高 99.5%
		var drawn = MIST.draw(c, "vil:" + id, base, w * 0.92, h, nv.t, front)
		if front and drawn: _relabel(c, id, J.num(p[0]), J.num(p[1]), w, h, S.bld.get(id, 0))

# 前層血霧會蓋住建築名牌／等級：喺霧上面再寫一次（同 Art.draw_building 一樣嘅位置），字唔會睇唔清
static func _relabel(c: CanvasItem, id: String, x: float, y: float, w: float, h: float, lv) -> void:
	var ctx = Ctx.new(c)
	var bname: String = DB.D.BUILDINGS[id].name
	if Art.PLAQUE.has(id): Art.plaque_text(ctx, Rect2(x - w / 2, y + 6 - h, w, h), Art.PLAQUE[id], bname, lv)
	else: Art.sign_board(ctx, x + (0.0 if id == "furnace" else w * 0.30), y + 12, bname, lv)

# ---------------- 夜色＋四角暗角（只蓋世界，唔蓋 UI 字）----------------
static func vig_tex() -> Texture2D:
	if _vig: return _vig
	var g = Gradient.new()
	# 夜色（NIGHT）同暗角合成一張：每幀只畫一次全屏
	g.set_color(0, NIGHT); g.set_color(1, Color(0.02, 0.0, 0.04, 0.8))
	g.add_point(0.55, NIGHT); g.add_point(0.82, Color(0.04, 0.01, 0.07, 0.4))
	var gt = GradientTexture2D.new(); gt.gradient = g; gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.5); gt.fill_to = Vector2(1.08, 1.08); gt.width = 128; gt.height = 256
	_vig = gt
	return _vig

static func draw_night(c: CanvasItem, nv) -> void:
	var vh: float = nv.size.y / maxf(0.01, nv.sc); var y0: float = nv.cam_y - 4
	var r = Rect2(-4, y0, 398.0, vh + 8)
	c.draw_texture_rect(vig_tex(), r, false)

# ---------------- 槐樹：樹洞臉眼光、樹幹排線暗影、樹枝尾「手指」 ----------------
# r：樹圖實際矩形（世界座標）；flip：圖左右反咗。全部畫喺樹圖範圍內，唔改點擊範圍
const TREE_EYES := [[0.455, 0.525], [0.535, 0.522]]
const TREE_TIPS := [[0.07, 0.50, -1.0], [0.93, 0.47, 1.0], [0.18, 0.12, -1.0], [0.84, 0.16, 1.0], [0.04, 0.27, -1.0], [0.96, 0.30, 1.0]]
static func tree_extra(ctx: Ctx, x: float, y: float, r: Rect2, flip: bool, _t: float) -> void:
	if r.size.x <= 0: return
	var fx = func(u: float) -> float:
		var px = r.position.x + r.size.x * u
		return 2.0 * x - px if flip else px
	var fy = func(v: float) -> float: return r.position.y + r.size.y * v
	ctx.save()
	# 樹幹排線暗影（深紫黑短斜線）
	ctx.strokeStyle = "rgba(18,6,20,.32)"; ctx.lineWidth = 0.8
	var sd = int(absf(x * 7.0 + y * 3.0)) % 97
	for k in 16:
		var u = 0.36 + fmod((k * 37 + sd) * 0.61803, 1.0) * 0.28; var v = 0.56 + fmod((k * 53 + sd) * 0.38197, 1.0) * 0.3
		var px = fx.call(u); var py = fy.call(v)
		ctx.beginPath(); ctx.moveTo(px, py); ctx.lineTo(px + 3.2, py - 2.2); ctx.stroke()
	# 樹枝尾：三條彎彎嘅「手指」
	ctx.strokeStyle = "rgba(22,10,16,.85)"; ctx.lineWidth = 0.9; ctx.lineCap = "round"
	for tp in TREE_TIPS:
		var px = fx.call(tp[0]); var py = fy.call(tp[1]); var dir: float = tp[2] * (-1.0 if flip else 1.0)
		for k in 3:
			var a = (-0.5 + k * 0.5) * 0.8
			var ex = px + dir * cos(a) * 5.5; var ey = py + sin(a) * 5.5 - 1.0
			ctx.beginPath(); ctx.moveTo(px, py); ctx.quadraticCurveTo(px + dir * 3.5, py + sin(a) * 1.5 - 1.5, ex, ey); ctx.stroke()
	ctx.lineCap = "butt"
	# 樹洞入面兩點病態青綠眼光
	for e in TREE_EYES:
		var ex2 = fx.call(e[0]); var ey2 = fy.call(e[1])
		var g = ctx.createRadialGradient(ex2, ey2, 0.3, ex2, ey2, 3.2); g.addColorStop(0, "rgba(150,240,190,.55)"); g.addColorStop(1, "rgba(150,240,190,0)")
		ctx.fillStyle = g; ctx.fillRect(ex2 - 3.2, ey2 - 3.2, 6.4, 6.4)
		ctx.fillStyle = "rgba(200,255,220,.8)"; ctx.beginPath(); ctx.ellipse(ex2, ey2, 0.7, 0.9, 0, 0, TAU); ctx.fill()
	ctx.restore()
