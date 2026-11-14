# 夜班巡陰（原生）：一隻角色嘅畫法（取代 ART.drawChar ＋ patrol.js drawUnit）
# 原圖網格變形交俾 GPU（pt_mesh.gdshader）；拆手揮武器（limbs）、衣服換色、工作證、裝備武器、血條名牌
class_name PtChar
extends Node2D

const D2R := PI / 180.0
const HOP := {"laojiang": 1, "zombie": 1, "pocong": 1}
const LIMB_POSES := {"idle": 1, "move": 1, "walk": 1, "run": 1, "windup": 1, "strike": 1, "follow": 1, "recover": 1, "chop": 1, "hammer": 1, "proud": 1}
const KEEP := {"y": 1, "sx": 1, "sy": 1}

# 共用（PtRun 開局時填）
static var CHAR_H := {}
static var SOLID := {}
static var NATIVE_R := {}
static var RIG := {}          # JS MeshAnim.RIG（含 n30 tweak）
static var SPECIAL = null

var u                          # PtU
var run                        # PtRun
var k := ""
var mode := "plain"            # limbs / mesh / plain / none
var H0 := 60.0                 # CHAR_H
var solid := false
var glow: PtDraw
var ch: PtDraw
var back: PtDraw
var body_mi: MeshInstance2D
var body_sp: PtDraw
var front: PtDraw
var cloth_mi: MeshInstance2D
var gear: PtDraw
var over: PtDraw
var mat: ShaderMaterial
var cloth_mat: ShaderMaterial
var M: Dictionary = {}         # 身體網格
var MF: Dictionary = {}        # 完整（冇拆手）網格：limbs 角色喺 hurt／die／down 時用
var tex_plain: Texture2D
var limb_c: Dictionary = {}
var back_items: Array = []
var front_items: Array = []
var gear_items: Array = []
var o: Dictionary = {}
var cur_mesh := ""
var tweak = null

static func setup_static() -> void:
	var ART = J.G.get("ART"); var MA = J.G.get("MeshAnim")
	CHAR_H = J.gp(ART, "CHAR_H"); SOLID = J.gp(ART, "SOLID"); NATIVE_R = J.gp(MA, "NATIVE_R"); RIG = J.gp(MA, "RIG")
	SPECIAL = J.G.get("SPECIAL")
	PtGfx.init()

func _init(unit, r) -> void:
	u = unit; run = r; k = u.k
	y_sort_enabled = false
	H0 = J.num(CHAR_H.get(k, 0.0))
	solid = SOLID.has(k)
	var special = SPECIAL != null and J.t(J.mc(SPECIAL, "has", [k]))
	var rig = RIG.get(k)
	if H0 > 0 and Limbs.has(k) and rig != null and PtGfx.tex(k + "__body") != null:
		mode = "limbs"; limb_c = Limbs.CH[k]
	elif H0 > 0 and rig != null and PtGfx.tex(k) != null and not special:
		mode = "mesh"
	elif H0 > 0 and PtGfx.tex(k) != null:
		mode = "plain"
	else:
		mode = "none"; if H0 <= 0: H0 = 58.0
	if rig != null and rig is Dictionary: tweak = rig.get("tweak")
	glow = PtDraw.new(); glow.fn = _draw_glow; var gm = CanvasItemMaterial.new(); gm.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; glow.material = gm; add_child(glow)
	ch = PtDraw.new(); ch.fn = _draw_shadow; add_child(ch)
	back = PtDraw.new(); ch.add_child(back)
	back.fn = func(n): _draw_items(n, back_items)
	mat = ShaderMaterial.new()
	if mode == "limbs" or mode == "mesh":
		mat.shader = PtGfx.SH_MESH
		body_mi = MeshInstance2D.new(); body_mi.material = mat; ch.add_child(body_mi)
		if mode == "limbs":
			var bb = []
			for b in rig.bones: if b[0] != "armF" and b[0] != "axe": bb.append(b)
			M = PtGfx.mesh_for(k + "__body", k + "__body", bb)
		else: M = PtGfx.mesh_for(k, k, rig.bones)
		if mode == "limbs" and PtGfx.tex(k) != null: MF = PtGfx.mesh_for(k, k, rig.bones)
	else:
		mat.shader = PtGfx.SH_SPR
		body_sp = PtDraw.new(); body_sp.fn = _draw_plain; body_sp.material = mat; ch.add_child(body_sp)
		tex_plain = PtGfx.tex(k)
	front = PtDraw.new(); ch.add_child(front)
	front.fn = func(n): _draw_items(n, front_items)
	gear = PtDraw.new(); ch.add_child(gear)
	gear.fn = func(n): _draw_items(n, gear_items)
	over = PtDraw.new(); over.fn = _draw_over; add_child(over)

func _use_mesh(m: Dictionary, key: String) -> void:
	if cur_mesh == key or m.is_empty(): return
	cur_mesh = key; body_mi.mesh = m.mesh; body_mi.texture = m.tex
	mat.set_shader_parameter("dims", Vector3(0, 0, m.ar))
	if cloth_mi: cloth_mi.mesh = m.mesh; cloth_mi.texture = m.tex

# ---------------- 每幀 ----------------
# o：{t, walk, pose, pt, flip, enemy, rot, tdx, tdy, alpha, weapon(gear 圖), cloth, badge}
func sync(oo: Dictionary) -> void:
	o = oo
	position = Vector2(u.x + o.ox, u.y + o.oy)   # 出手衝前、待機彈
	var s: float = o.s; var t: float = o.t; var H := H0 * s
	ch.modulate.a = clampf(o.alpha, 0.0, 1.0)
	mat.set_shader_parameter("flash", o.flash)
	back_items.clear(); front_items.clear(); gear_items.clear()
	var pose = o.pose
	var yfloat = 0.0 if solid else (3 + sin(t * 2.4) * 2) * s
	var used_limbs = false
	if mode == "limbs" and LIMB_POSES.has(pose):
		used_limbs = _sync_limbs(H, s, t, yfloat)
	if not used_limbs and (mode == "mesh" or mode == "limbs"):
		var m = MF if mode == "limbs" else M
		if not m.is_empty():
			_use_mesh(m, "full")
			var pz = MeshAnim.pose_for(k, o) if pose != "down" and pose != "air" else _pose_extra(pose, t, o.pt)
			if tweak != null and tweak is Callable:
				J.cl(tweak, null, [pz, o])
			var R: Dictionary = RIG[k]
			if J.t(R.get("hop")) and (o.walk or o.enemy or pose == "move"): pz.y = J.num(pz.get("y", 0.0)) - absf(sin(t * 5)) * 0.09
			_mesh_draw(m, 0.0, -yfloat, H, pz, not o.flip)
	if mode == "plain" or mode == "none": body_sp.queue_redraw()
	# 衣服
	if o.cloth != null and mode != "plain" and mode != "none" and pose != "down" and not o.dying:
		if cloth_mi == null:
			cloth_mat = ShaderMaterial.new(); cloth_mat.shader = PtGfx.SH_MESH; cloth_mat.set_shader_parameter("mode", 1)
			cloth_mi = MeshInstance2D.new(); cloth_mi.material = cloth_mat; ch.add_child(cloth_mi); ch.move_child(cloth_mi, front.get_index() + 1)
			cloth_mi.mesh = body_mi.mesh; cloth_mi.texture = body_mi.texture
		cloth_mi.visible = true
		cloth_mi.mesh = body_mi.mesh; cloth_mi.texture = body_mi.texture
		for p in ["bone", "dims", "aff_a", "aff_o"]: cloth_mat.set_shader_parameter(p, mat.get_shader_parameter(p))
		cloth_mat.set_shader_parameter("cm", o.cloth)
		var Hc = 58.0 * s
		cloth_mat.set_shader_parameter("clip_y", Vector2(-Hc * 0.5, Hc * 0.12))
	elif cloth_mi: cloth_mi.visible = false
	# 工作證、裝備武器
	if o.badge != null and o.rot == 0.0 and pose != "down" and not o.dying: _badge(s, t)
	if o.wtex != null and pose != "down" and not o.dying: _gear_weapon(s, t, pose, o.pt, o.rot)
	back.queue_redraw(); front.queue_redraw(); gear.queue_redraw(); ch.queue_redraw(); glow.queue_redraw(); over.queue_redraw()

func _pose_extra(pose: String, t: float, p: float) -> Dictionary:
	var base = MeshAnim.idle(t * 0.3 if pose == "down" else t)
	if pose == "down": return MeshAnim._add(base, {"rot": -1.5, "x": -0.2, "y": 0.03, "head": -0.2, "armF": 0.4, "armB": -0.3})
	var kk = sin(minf(1, p) * PI)
	return MeshAnim._add(MeshAnim.idle(t), {"rot": -minf(1, p) * 6.283, "y": -0.55 * kk, "armF": 0.9, "armB": -0.9, "head": -0.3, "legF": 0.4, "legB": -0.4})

# MeshAnim.draw → drawRaw：設 shader 參數
func _mesh_draw(m: Dictionary, x: float, y: float, h: float, pose: Dictionary, face_right: bool, base := Transform2D.IDENTITY) -> void:
	var nr = NATIVE_R.has(k)
	var flip = face_right != nr
	if not nr:
		var mm = {}
		for kk in pose:
			var v = pose[kk]
			mm[kk] = -v if (v is float or v is int) and not KEEP.has(kk) else v
		pose = mm
	_raw(m, x, y, h, pose, flip, base)

func _raw(m: Dictionary, x: float, y: float, h: float, pose: Dictionary, flip: bool, base: Transform2D) -> void:
	var ar: float = m.ar; var W = h / ar
	var A = base * Transform2D(0, Vector2(x + J.num(pose.get("x", 0.0)) * W, y + J.num(pose.get("y", 0.0)) * h))
	if flip: A = A * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
	var rot = J.num(pose.get("rot", 0.0))
	if rot != 0.0 and not is_nan(rot):
		A = A * Transform2D(0, Vector2(0, -h * 0.35)) * Transform2D(rot, Vector2.ZERO) * Transform2D(0, Vector2(0, h * 0.35))
	var sx = pose.get("sx"); var sy = pose.get("sy")
	A = A * Transform2D(Vector2(J.num(sx) if sx != null else 1.0, 0), Vector2(0, J.num(sy) if sy != null else 1.0), Vector2.ZERO) * Transform2D(0, Vector2(-W / 2, -h))
	mat.set_shader_parameter("bone", PtGfx.solve(m.bones, pose))
	mat.set_shader_parameter("dims", Vector3(W, h, ar))
	mat.set_shader_parameter("aff_a", Vector4(A.x.x, A.x.y, A.y.x, A.y.y))
	mat.set_shader_parameter("aff_o", A.origin)

# ---------------- 拆手揮武器（limbs.js draw）----------------
func _sync_limbs(H: float, s: float, t: float, yfloat: float) -> bool:
	var c: Dictionary = limb_c
	var st: Dictionary = Limbs.state_of(k, o.pose, o.pt)
	var bodyt = PtGfx.tex(k + "__body"); var arm = PtGfx.tex(k + "__arm")
	if bodyt == null or arm == null: return false
	_use_mesh(M, "body")
	var W = H * bodyt.get_width() / bodyt.get_height()
	var wp = Limbs.weapon_of(k, o.get("lweapon"))
	var nr: bool = NATIVE_R.has(k) or bool(c.get("nativeR", false))
	var pvx: float = 1.0 - c.pivot[0] if nr else c.pivot[0]
	var R: Dictionary = RIG[k]; var pose = o.pose
	var atk: bool = pose == "windup" or pose == "strike" or pose == "follow" or pose == "recover"
	var walking: bool = o.walk or pose == "move" or pose == "walk" or pose == "run"
	var y = -yfloat
	if J.t(R.get("hop")) and not atk and (walking or o.enemy): y -= absf(sin(t * 5)) * 0.09 * H
	var th_add = 0.0
	if c.get("weapon") == null and walking: th_add = sin(t * 7) * (float(c.swing) if c.get("swing") != null else 7.0)
	var B = Transform2D(0, Vector2(0, y))
	if not o.flip: B = B * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)   # faceRight
	B = B * Transform2D(0, Vector2(-st.dx * W, st.dy * H)) * Transform2D(0, Vector2(0, -H * 0.28)) * Transform2D(st.lean * D2R, Vector2.ZERO) * Transform2D(0, Vector2(0, H * 0.28)) * Transform2D(Vector2(st.sx, 0), Vector2(0, st.sy), Vector2.ZERO)
	var mp = MeshAnim.walk(t) if walking else MeshAnim.idle(t)
	mp.armF = 0.0; mp.axe = 0.0; mp.body = 0.0; mp.x = 0.0
	if c.get("still") != null:
		for b in c.still: mp[b] = 0.0
	var px = (pvx - 0.5) * W; var py: float = -H + c.pivot[1] * H + float(mp.get("y", 0.0)) * H
	var lift = clampf((st.th - 25) / 40.0, 0, 1)
	var lx: float = px + (lift * c.lift[0] + st.hx) * W; var ly: float = py - (lift * c.lift[1] + st.hy) * H
	var hk: float = float(c.hk) if c.get("hk") != null else 1.0
	var ath: float = (st.th + th_add) * hk; var wth: float = (st.th + th_add) - ath
	var NRF = Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
	var behind: bool = st.th > float(c.behind) or (c.get("behindLo") != null and st.th < float(c.behindLo))
	var wb = c.get("wbehind")
	var w_behind: bool = (st.th > wb[0] and st.th < wb[1]) if wb != null else behind
	var wpn_item = null
	if wp != null:
		var im = PtGfx.tex(wp.img); var ww: float = wp.w * H; var wh: float = wp.h * H
		var X = B * Transform2D(0, Vector2(lx, ly)) * Transform2D(ath * D2R, Vector2.ZERO)
		if nr: X = X * NRF
		X = X * Transform2D(0, Vector2((c.grip[0] - c.pivot[0]) * W, (c.grip[1] - c.pivot[1]) * H)) * Transform2D(wth * D2R * (-1.0 if nr else 1.0), Vector2.ZERO)
		X = X * Transform2D((float(c.hold) - float(wp.ang)) * D2R, Vector2.ZERO)
		wpn_item = [im, X, Rect2(-wp.grip[0] * ww, -wp.grip[1] * wh, ww, wh)]
	var XA = B * Transform2D(0, Vector2(lx, ly)) * Transform2D(ath * D2R, Vector2.ZERO)
	if nr: XA = XA * NRF
	var arm_item = [arm, XA, Rect2(-c.pivot[0] * W, -c.pivot[1] * H, W, H)]
	if wpn_item != null: (back_items if w_behind else front_items).append(wpn_item)
	(back_items if behind else front_items).append(arm_item)
	# 身體：MeshAnim.drawBody → drawRaw(imgKey, 0, 0, H, mp, false)
	var BB = B * NRF if nr else B
	_raw(M, 0.0, 0.0, H, mp, false, BB)
	return true

func _draw_items(n: CanvasItem, items: Array) -> void:
	for it in items:
		if it[0] is String:
			_draw_badge(n, it); continue
		n.draw_set_transform_matrix(it[1])
		if it.size() > 3: n.draw_texture_rect(it[0], it[2], false, it[3])
		else: n.draw_texture_rect(it[0], it[2], false)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 冇骨架：整張圖呼吸（art.js drawSprite）＋ 鬼下半身漸隱 ----------------
func _draw_plain(n: CanvasItem) -> void:
	if o.is_empty(): return
	var s: float = o.s; var t: float = o.t
	if mode == "none" or tex_plain == null:
		n.draw_set_transform(Vector2(0, -20 * s), 0, Vector2(12 * s, 18 * s)); n.draw_circle(Vector2.ZERO, 1.0, Color(0.86, 0.9, 0.94, 0.8)); n.draw_set_transform_matrix(Transform2D.IDENTITY); return
	var H = H0 * s; var iw = tex_plain.get_width(); var ih = tex_plain.get_height(); var Wd = H * iw / ih
	var A = Transform2D.IDENTITY
	if o.flip: A = A * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
	if o.rot != 0.0: A = A * Transform2D(0, Vector2(0, -15 * s)) * Transform2D(o.rot, Vector2.ZERO) * Transform2D(0, Vector2(0, 15 * s))
	var ghost = not solid
	var yy = 0.0 if not ghost else -(3 + sin(t * 2.4) * 2) * s
	var sy = 1 + sin(t * 2.2) * 0.02; var sx = 1 - (sy - 1) * 0.5; var r = 0.0; var dy = 0.0
	if o.walk: r += sin(t * 9) * 0.07; dy -= absf(sin(t * 9)) * 1.5 * s
	if HOP.has(k) and (o.walk or o.enemy): dy -= absf(sin(t * 5)) * 5 * s
	A = A * Transform2D(0, Vector2(0, yy + dy)) * Transform2D(r, Vector2.ZERO) * Transform2D(Vector2(sx, 0), Vector2(0, sy), Vector2.ZERO)
	if ghost:
		# 漸隱帶：世界 fy-13s → fy+6s；圖底 = fy
		var f0 = 1.0 - 13.0 * s / H
		mat.set_shader_parameter("fade", Vector2(f0, 1.0 + 6.0 * s / H)); mat.set_shader_parameter("fade_k", 1.0)
	else: mat.set_shader_parameter("fade_k", 0.0)
	n.draw_set_transform_matrix(A)
	n.draw_texture_rect(tex_plain, Rect2(-Wd / 2, -H, Wd, H), false)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 影、光暈、蓄力圈 ----------------
func _draw_shadow(n: CanvasItem) -> void:
	if o.is_empty(): return
	var s: float = o.s
	var k2 = 1.0 if solid else 0.8
	var a = 0.35 * (1.0 if solid else 0.55)
	if mode == "plain" or mode == "none": a = 0.35 * (1.0 if solid else 0.55)
	n.draw_set_transform(Vector2(0, 1 * s), 0, Vector2(14 * s * k2, 4 * s * k2))
	n.draw_circle(Vector2.ZERO, 1.0, Color(0, 0, 0, a))
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

func _draw_glow(n: CanvasItem) -> void:
	if o.is_empty(): return
	var s: float = o.s
	if o.aura > 0.0:
		var ai = run.fx_tex("fx_aura")
		if ai:
			var W = 70 * s; var Hh = W * ai.get_height() / ai.get_width()
			n.draw_texture_rect(ai, Rect2(-W / 2 - o.ox, -Hh * 0.92 - o.oy, W, Hh), false, Color(1, 1, 1, o.aura))
	if o.charge >= 0.0:
		var ri = run.fx_tex("fx_ring")
		if ri:
			var pp = minf(1, o.charge)
			var W2 = (120 - 50 * pp) * s * (1.4 if u.boss else 1.0); var H2 = W2 * ri.get_height() / ri.get_width()
			var col = Color(1, 1, 1, 0.5 + pp * 0.5)
			if u.side == 1: col = Color(1.0, 0.55, 0.75, 0.5 + pp * 0.5)
			n.draw_texture_rect(ri, Rect2(-W2 / 2 - o.ox, -H2 / 2 - o.oy, W2, H2), false, col)

# ---------------- 工作證（掛繩）----------------
func _badge(s0: float, t: float) -> void:
	var s = s0; var H = 58 * s; var fx = -1.0 if o.flip else 1.0
	var nx = fx * H * 0.02; var ny = -H * 0.74; var bx = fx * H * 0.03 + sin(t * 3 + u.x) * 0.8; var by = -H * 0.5
	gear_items.append(["badge", o.badge, s, nx, ny, bx, by])

# ---------------- 裝備武器（patrol.js drawWeapon）----------------
func _gear_weapon(s0: float, t: float, pose, pt: float, rot: float) -> void:
	var im: Texture2D = o.wtex
	var s = s0; var H = 58 * s; var fd = -1.0 if o.flip else 1.0; var sty = o.wsty
	var far = sty in ["shoot", "beam", "poke", "pull", "splash"]
	var eo = func(q: float) -> float: return 1 - pow(1 - clampf(q, 0, 1), 3)
	var a = 0.45 + sin(t * 3 + u.x * 0.01) * 0.05
	if pose == "move": a = 0.6 + sin(t * 9) * 0.12
	elif pose == "windup": a = 0.45 + 0.9 * pt if far else 0.45 - 1.7 * eo.call(pt)
	elif pose == "strike": a = 1.5 if far else -1.25 + 3.0 * eo.call(pt)
	elif pose == "recover": a = 1.5 - 1.05 * pt if far else 1.75 - 1.3 * pt
	var hx = fd * H * 0.2; var hy = -H * 0.4; var h = H * 0.74 * (1.15 if sty == "slam" or sty == "flail" else 1.0); var w = h * im.get_width() / im.get_height()
	var X = Transform2D.IDENTITY
	if rot != 0.0: X = X * Transform2D(0, Vector2(0, -15 * s)) * Transform2D(rot, Vector2.ZERO) * Transform2D(0, Vector2(0, 15 * s))
	X = X * Transform2D(0, Vector2(hx, hy)) * Transform2D(Vector2(fd, 0), Vector2(0, 1), Vector2.ZERO) * Transform2D(a, Vector2.ZERO)
	gear_items.append([im, X, Rect2(-w / 2, -h * 0.86, w, h)])
	if o.swing_t >= 0.0 and o.swing_t < 0.12 and not far:
		gear_items.append([im, X, Rect2(-w / 2, -h * 0.86, w, h), Color(1.6, 1.6, 1.6, 0.5 * (1 - o.swing_t / 0.12))])

func _draw_badge(n: CanvasItem, it: Array) -> void:
	var bd: Dictionary = it[1]; var s: float = it[2]; var nx: float = it[3]; var ny: float = it[4]; var bx: float = it[5]; var by: float = it[6]
	n.draw_set_transform_matrix(Transform2D.IDENTITY)
	n.draw_polyline(PackedVector2Array([Vector2(nx - 5 * s, ny), Vector2(bx, by - 3 * s), Vector2(nx + 5 * s, ny)]), bd.col, 1.4 * s, true)
	var r = Rect2(bx - 3.5 * s, by - 3 * s, 7 * s, 9 * s)
	n.draw_rect(r, Color("#f4efe2")); n.draw_rect(r, Color("#2a2018"), false, 1.0 * s)
	n.draw_rect(Rect2(bx - 3.5 * s, by - 3 * s, 7 * s, 2.4 * s), bd.col)
	if bd.c >= 3: n.draw_rect(Rect2(bx - 1.5 * s, by + 2.5 * s, 3 * s, 2.5 * s), Color("#ffd84a"))

# 名牌、血條、靈體不穩圈、摸魚中
func _draw_over(n: CanvasItem) -> void:
	if o.is_empty() or o.dying: return
	run.draw_over(n, u, o)
