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
	m.visible = bld_mist; mf.visible = bld_mist   # [perf] 血霧熄咗：兩層唔使每格重畫
	# [dark16] 全地圖半透明暗影：一塊全屏暗色，shader 入面喺路燈／起好嘅建築／主角附近挖亮兼加暖光
	var dk = Layer.new(); dk.name = "va_dark"
	var sh = Shader.new(); sh.code = DARK_SH
	var sm = ShaderMaterial.new(); sm.shader = sh; dk.material = sm
	dk.fn = func(c): draw_dark(c, nv, sm)
	nv.world.add_child(dk); nv.world.move_child(dk, nv.zone_over.get_index())   # 喺 zone_over 之下：黑霧、王、區名牌、提示字唔會被壓暗
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
	if not bld_mist: return   # [dark16] 新地面上血霧變成一塊污漬，熄咗；接地改由前景層＋暗影層做
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

static var dark_on := true
static var bld_mist := false
const NL := 40
const DARK_SH := """shader_type canvas_item;
uniform vec2 lp[40]; uniform vec2 lr[40]; uniform float li[40]; uniform int ln = 0;
uniform vec4 dark : source_color = vec4(0.03, 0.03, 0.13, 0.54);
uniform vec3 warm : source_color = vec3(1.0, 0.72, 0.36);
uniform vec2 mp[16]; uniform int mn = 0; uniform vec4 mcol = vec4(0.784, 0.824, 0.784, 0.06);
varying vec2 wp;
void vertex() { wp = VERTEX; }
void fragment() {
	// [perf] 村入面飄嘅霧團（以前 nv_village 霧層逐團畫 PtGfx.RAD：中心實、半徑 90 線性變透明）併入呢個 shader 一次畫
	float ma = 0.0;
	for (int i = 0; i < mn; i++) ma = max(ma, clamp(1.0 - length(wp - mp[i]) / 90.0, 0.0, 1.0));
	ma *= mcol.a;
	float L = 0.0;
	for (int i = 0; i < ln; i++) {
		vec2 d = (wp - lp[i]) / lr[i];
		float f = clamp(1.0 - dot(d, d), 0.0, 1.0);
		L += f * f * (3.0 - 2.0 * f) * li[i];
	}
	L = clamp(L, 0.0, 1.0);
	vec4 D = vec4(mix(dark.rgb, warm, L), mix(dark.a, 0.10, L));
	// 霧（下）＋暗影（上）兩層 alpha 疊合（同以前分兩層畫嘅結果一樣）
	float A = D.a + ma * (1.0 - D.a);
	vec3 C = (D.rgb * D.a + mcol.rgb * ma * (1.0 - D.a)) / max(A, 0.0001);
	COLOR = vec4(C, A);
}"""
# [perf] 霧團交俾暗影 shader 畫：nv_village._draw_mist 填 mist_pts（世界座標）、mist_col
static var mist_pts := PackedVector2Array()
static var mist_col := Color(200 / 255.0, 210 / 255.0, 200 / 255.0, 0.06)
static func mist_in_dark() -> bool: return dark_on
static func draw_dark(c: CanvasItem, nv, sm: ShaderMaterial) -> void:
	if not dark_on: sm.set_shader_parameter("ln", 0); return
	var P = PackedVector2Array(); var R = PackedVector2Array(); var I = PackedFloat32Array()
	var S = J.G.get("S"); var POS = J.G.get("POS"); var order = J.G.get("BLD_ORDER")
	var vr: Rect2 = nv.view_rect().grow(170)
	var now = Time.get_ticks_msec()
	for k in Art.lamp_seen:   # 路燈：暖光圈跟住閃爍
		var e = Art.lamp_seen[k]
		if now - int(e[1]) > 400 or not vr.has_point(e[0]) or P.size() >= NL: continue
		P.append(e[0] + Vector2(0, 16)); R.append(Vector2(105, 84)); I.append(clampf(float(e[2]) * 1.05, 0.0, 1.0))
	if S is Dictionary and POS != null and order != null:
		var BW: Dictionary = Art.BW
		for id in order:   # 起好嘅建築：成間屋連門口亮返
			if not POS.has(id) or not J.t(S.bld.get(id, 0)) or not BW.has(id) or P.size() >= NL: continue
			var p = Vector2(J.num(POS[id][0]), J.num(POS[id][1]))
			if not vr.has_point(p): continue
			var w: float = BW[id]
			P.append(p + Vector2(0, -w * 0.26)); R.append(Vector2(w * 0.98, w * 0.80)); I.append(0.86 + sin(nv.t * 1.3 + p.x) * 0.05)
		var RB = load("res://game/rebuild/rb.gd")   # [rebuild2] 荒村廢墟／搭緊棚：暗啲嘅光，睇得清楚但比開咗嘅暗
		if RB.active():
			for id in RB.ALL:
				if not POS.has(id) or J.t(S.bld.get(id, 0)) or not BW.has(id) or P.size() >= NL: continue
				var p2 = Vector2(J.num(POS[id][0]), J.num(POS[id][1]))
				if not vr.has_point(p2): continue
				var w2: float = BW[id]
				P.append(p2 + Vector2(0, -w2 * 0.22)); R.append(Vector2(w2 * 0.85, w2 * 0.66)); I.append(0.62 if RB.fixing(id) else 0.42)
		if POS.has("gate") and P.size() < NL:
			P.append(Vector2(J.num(POS.gate[0]), J.num(POS.gate[1]) - 40)); R.append(Vector2(150, 110)); I.append(0.85)
	var ZD = load("res://game/zone/zone_data.gd")
	if ZD.on():   # 村外：大排檔成個場亮、野外區王企嗰度亮、已攻佔資源區亮
		for z in ZD.zones():
			if P.size() >= NL - 1: break
			var zr: Rect2 = ZD.rect(z.rect); var tp = str(z.type); var zid = str(z.id)
			if not zr.intersects(vr): continue
			if tp == "market" and ZD.revealed(zid):
				P.append(zr.get_center()); R.append(zr.size * 0.62); I.append(0.80)
			elif tp == "wild" and ZD.revealed(zid):
				P.append(ZD.v2(z.get("boss_at", [zr.get_center().x, zr.get_center().y])) + Vector2(0, -20)); R.append(Vector2(190, 160)); I.append(0.78 + sin(nv.t * 1.7 + zr.position.x) * 0.05)
				P.append(zr.get_center()); R.append(zr.size * 0.60); I.append(0.38)
			elif tp == "res" and ZD.owned(zid):
				P.append(zr.get_center()); R.append(zr.size * 0.62); I.append(0.66)
	var V = J.G.get("Village")
	if V != null and V.get("hero") is Dictionary and V.hero.has("x") and P.size() < NL:   # 主角身邊一圈微光
		P.append(Vector2(J.num(V.hero.x), J.num(V.hero.y) - 24)); R.append(Vector2(82, 74)); I.append(0.95)   # [herobig] 主角夠光，唔會俾暗影食咗
	var n = P.size()
	P.resize(NL); R.resize(NL); I.resize(NL)
	for i in range(n, NL): R[i] = Vector2(1, 1)
	sm.set_shader_parameter("lp", P); sm.set_shader_parameter("lr", R); sm.set_shader_parameter("li", I); sm.set_shader_parameter("ln", n)
	var mpp = mist_pts.duplicate(); var mn = mini(mpp.size(), 16); mpp.resize(16)   # [perf] 霧團
	sm.set_shader_parameter("mp", mpp); sm.set_shader_parameter("mn", mn); sm.set_shader_parameter("mcol", mist_col)
	c.draw_rect(nv.view_rect().grow(8), Color.WHITE)

static func draw_night(c: CanvasItem, nv) -> void:
	var r: Rect2 = nv.view_rect().grow(4)   # [zone] 分區地圖：跟 2D 鏡頭
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
