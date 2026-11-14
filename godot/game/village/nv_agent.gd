# 村子廣場上一隻鬼（原生）：daily_plaza.js body()/eatDraw()/golfDraw()/hangDraw() 嘅搬遷版
# 座標：ctx 用世界座標（base = 移去自己原點），網格用 GPU
class_name NvAgent
extends Node2D

const D2R := PI / 180.0

var P0: NvPlaza
var k := ""
var turn: Node2D
var sh: PtDraw
var back: PtDraw
var mi: MeshInstance2D
var mat: ShaderMaterial
var front: PtDraw
var after: PtDraw
var head: PtDraw
var golf: PtChar = null
var golf_u: PtU = null
var sh_ops: Array = []
var back_ops: Array = []
var front_ops: Array = []
var after_ops: Array = []
var head_ops: Array = []
var cur_mesh := ""
var spc: NvSpecial = null
var sp_n: PtDraw = null
var sp_args := {}
var ax := 0.0
var ay := 0.0

func _init(p, kk: String) -> void:
	P0 = p; k = kk
	turn = Node2D.new(); add_child(turn)
	sh = _pd(sh_ops); turn.add_child(sh)
	back = _pd(back_ops); turn.add_child(back)
	mat = ShaderMaterial.new(); mat.shader = PtGfx.SH_MESH
	mi = MeshInstance2D.new(); mi.material = mat; turn.add_child(mi)
	front = _pd(front_ops); turn.add_child(front)
	after = _pd(after_ops); turn.add_child(after)
	head = _pd(head_ops); add_child(head)

func _pd(ops: Array) -> PtDraw:
	var n = PtDraw.new(); n.tag = "agent"
	n.fn = func(c): _run_ops(c, ops)
	return n

func _run_ops(c: CanvasItem, ops: Array) -> void:
	var ctx = Ctx.new(c, Transform2D(0, Vector2(-ax, -ay)))
	for f in ops: f.call(ctx)

# ---------------- 每幀 ----------------
func sync(ag: Dictionary, t: float, mute: bool) -> void:
	ax = J.num(ag.x); ay = J.num(ag.y); position = Vector2(ax, ay)
	sh_ops.clear(); back_ops.clear(); front_ops.clear(); after_ops.clear(); head_ops.clear()
	var T = t + J.num(ag.get("seed", 0.0))
	var turnT = J.num(ag.get("turnT", 1.0))
	var tk = maxf(0.08, absf(cos(PI * turnT / NvPlaza.TURN))) if turnT < NvPlaza.TURN else 1.0
	turn.scale = Vector2(tk, 1)
	var style = ag.get("style", {})
	var act = J.str(ag.act) if ag.get("act") != null and ag.get("act") != "" else ("plaza_eat" if J.t(style.get("eat")) else "plaza_walk")
	ag._z = 0.0; ag._stars = 0.0
	var o = {"t": T, "act": act, "at": J.num(ag.get("eatT", 0.0)) if act == "plaza_eat" else J.num(ag.get("at", 0.0)), "w": J.num(ag.get("w", 0.0)), "wph": J.num(ag.get("wph", 0.0)),
		"hp": ag.get("hp"), "run": NvPlaza.cl(J.num(ag.get("w", 0.0))) if J.t(style.get("run")) else 0.0, "sniff": J.t(style.get("sniff")), "sneak": J.t(style.get("sneak")), "stiff": J.t(style.get("stiff")),
		"pl": ag.get("pl") if ag.get("pl") is Dictionary else {}, "flip": not J.t(ag.get("face")), "_z": 0.0, "_stars": 0.0, "_zpos": null, "sit": 0}
	var s = NvPlaza.SC
	var H = J.num(PtChar.CHAR_H.get(k, 50.0)) * s
	var a = {"type": k, "x": ax, "y": ay, "s": s, "H": H, "o": o, "faceRight": not o.flip, "solid": PtChar.SOLID.has(k)}
	mi.visible = true
	if golf: golf.visible = false
	_body(a)
	ag._z = o._z; ag._stars = o._stars
	# 頭上的東西
	var hy = ay - float(NvPlaza.CH.get(k, 50)) * s - (0.0 if NvPlaza.PSOLID.has(k) else 4.0)
	var fwd = 1.0 if J.t(ag.get("face")) else -1.0
	if o._z > 0.05:
		var Hh = float(NvPlaza.CH.get(k, 50)) * s
		var p = o._zpos if o._zpos != null else [ax + fwd * 9, ay - Hh * (1 - float(NvPlaza.FACEV.get(k, 0.3))) - (2.0 if NvPlaza.PSOLID.has(k) else 6.0)]
		var zk = o._z
		head_ops.append(func(ctx): NvPlaza.zzz(ctx, p[0], p[1], T, s, zk))
	if o._stars > 0:
		var sk = o._stars
		head_ops.append(func(ctx): NvPlaza.stars(ctx, ax, hy + 2, T, s, sk))
	var icon = ag.get("icon"); var iconT = J.num(ag.get("iconT", 9.0))
	if icon != null and J.str(icon) != "" and iconT < 1.25 and not mute:
		var k2 = minf(1, minf(iconT * 6, (1.25 - iconT) * 5)); var ic = J.str(icon)
		head_ops.append(func(ctx): NvPlaza.bubble(ctx, ax + fwd * 7, hy - 7 - sin(minf(1, iconT * 3) * PI) * 2, ic, s, k2))
	var ft = ag.get("fxTxt")
	if ft is Dictionary and J.num(ft.t) < 1:
		var ftt = J.num(ft.t); var fs = J.str(ft.s)
		head_ops.append(func(ctx): NvPlaza.txt(ctx, ax, hy - 6 - ftt * 8, fs, 10 * s * 1.4, "#ffe9a8", minf(1, (1 - ftt) * 3), 0.2))
	if k == "shuigui":
		var sd = J.num(ag.get("seed", 0.0))
		after_ops.append(func(ctx): NvPlaza.drips(ctx, ax, ay, t + sd, sd))
	sh.queue_redraw(); back.queue_redraw(); front.queue_redraw(); after.queue_redraw(); head.queue_redraw()

# ---------------- 網格 ----------------
func _use(m: Dictionary, key: String) -> void:
	if cur_mesh == key or m.is_empty(): return
	cur_mesh = key; mi.mesh = m.mesh; mi.texture = m.tex

# MeshAnim.draw(ctx, type, x, y, h, pose, faceRight)：x,y 世界座標；R = 額外外層變換（世界）
func _mesh(x: float, y: float, h: float, pose: Dictionary, face_right: bool, R := Transform2D.IDENTITY) -> void:
	var rig = PtChar.RIG.get(k)
	if rig == null: return
	var m = PtGfx.mesh_for(k, k, rig.bones); _use(m, "full")
	var nr = PtChar.NATIVE_R.has(k); var flip = face_right != nr
	if not nr:
		var mm = {}
		for kk in pose:
			var v = pose[kk]
			mm[kk] = -v if (v is float or v is int) and not NvPlaza.KEEP.has(kk) else v
		pose = mm
	_raw(m, x, y, h, pose, flip, R)

func _raw(m: Dictionary, x: float, y: float, h: float, pose: Dictionary, flip: bool, R: Transform2D) -> void:
	var ar: float = m.ar; var W = h / ar
	var A = Transform2D(0, Vector2(-ax, -ay)) * R * Transform2D(0, Vector2(x + J.num(pose.get("x", 0.0)) * W, y + J.num(pose.get("y", 0.0)) * h))
	if flip: A = A * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
	var rot = J.num(pose.get("rot", 0.0))
	if rot != 0.0 and not is_nan(rot): A = A * Transform2D(0, Vector2(0, -h * 0.35)) * Transform2D(rot, Vector2.ZERO) * Transform2D(0, Vector2(0, h * 0.35))
	var sx = pose.get("sx"); var sy = pose.get("sy")
	A = A * Transform2D(Vector2(J.num(sx) if sx != null else 1.0, 0), Vector2(0, J.num(sy) if sy != null else 1.0), Vector2.ZERO) * Transform2D(0, Vector2(-W / 2, -h))
	mat.set_shader_parameter("bone", PtGfx.solve(m.bones, pose))
	mat.set_shader_parameter("dims", Vector3(W, h, ar))
	mat.set_shader_parameter("aff_a", Vector4(A.x.x, A.x.y, A.y.x, A.y.y))
	mat.set_shader_parameter("aff_o", A.origin)

func _float_y(a: Dictionary) -> float:
	return 0.0 if a.solid else (3 + sin(a.o.t * 2.4) * 2) * a.s * (0.25 if a.o.sit else 1.0)

func _shadow_at(a: Dictionary, lift: float, kk := 1.0) -> void:
	var cl = NvPlaza.cl(lift / (a.H * 0.9))
	var sk = (1.0 if a.solid else 0.8) * kk * (1 - 0.5 * cl)
	var al = (1.0 if a.solid else 0.55) * (1 - 0.4 * cl)
	var x = a.x; var y = a.y; var s = a.s
	sh_ops.append(func(ctx):
		ctx.save(); ctx.globalAlpha *= al; Art.shadow(ctx, x, y + 1 * s, s * sk); ctx.restore())

func _npt(a: Dictionary, u: float, v: float, lift := 0.0) -> Array:
	var img = PtGfx.tex(a.type); var W = a.H * img.get_width() / img.get_height(); var nr = PtChar.NATIVE_R.has(a.type); var flip = a.faceRight != nr
	return [a.x + (-1.0 if flip else 1.0) * (u - 0.5) * W, a.y - _float_y(a) - lift - a.H + v * a.H]

func _draw_m(a: Dictionary, P: Dictionary, lift: float, shK: float) -> void:
	_shadow_at(a, lift, shK)
	_mesh(a.x, a.y - _float_y(a) - lift, a.H, P, a.faceRight)

# ---------------- body ----------------
func _body(a: Dictionary) -> void:
	var o: Dictionary = a.o; var type: String = a.type; var at: float = o.at; var t: float = o.t; var fwd = 1.0 if a.faceRight else -1.0
	var s: float = a.s; var H: float = a.H; var pl: Dictionary = o.pl
	if o.act == "plaza_eat" and type == "eguiking" and _eat(a): return
	if o.act == "plaza_golf" and type == "huang" and _golf(a): return
	if o.act == "plaza_hang" and type == "tianhua" and _hang(a): return
	var P = NvPlaza.base_pose(o, type); var lift = 0.0; var shK = 1.0
	var hp = o.hp
	if NvPlaza.HOPPER.has(type) and hp != null and J.num(hp) >= 0 and (o.act == "" or o.act == "plaza_walk"): lift += _hop_pose(J.num(hp), H, P)
	var w = NvPlaza.cl(o.w)
	if NvPlaza.PAPER.has(type) and w > 0: NvPlaza.add(P, {"armF": sin(t * 31) * 0.05 * w, "armB": sin(t * 27 + 1) * 0.05 * w, "sx": 1 + sin(t * 23) * 0.012 * w, "body": 0.04 * o.run})
	if type == "youhun": P.rot = float(P.get("rot", 0.0)) + sin(t * 1.7) * 0.05 * fwd; lift += (sin(t * 1.1) + 1) * 1.2 * s
	if type == "shuigui": NvPlaza.add(P, {"head": 0.07})
	if o.sniff:
		var sn = pow(maxf(0, sin(t * 2.6)), 6); NvPlaza.add(P, {"head": 0.2 + sin(t * 24) * 0.05 * sn, "body": 0.1})
	if o.sneak: NvPlaza.add(P, {"body": 0.2, "head": 0.06, "sy": 0.9, "sx": 1.05, "armF": -0.32, "armB": 0.3})
	var spk = J.t(pl.get("spk"))
	var d = J.num(pl.get("d", 0.0))
	match o.act:
		"plaza_talk":
			if spk:
				var b = maxf(0, sin(at * 2.1)); NvPlaza.add(P, {"head": 0.02 + sin(at * 8.5) * 0.05 * b, "armF": -0.22 * (0.5 + 0.5 * sin(at * 3.2)) * b, "body": 0.03 * b})
			else:
				var n = sin(PI * NvPlaza.seg(fmod(at, 1.5), 0.2, 0.75)); NvPlaza.add(P, {"head": 0.08 * n, "body": 0.01 * n})
		"plaza_argue":
			if spk: NvPlaza.add(P, {"body": 0.09, "head": 0.07 + sin(at * 12) * 0.06, "armF": -0.32 + sin(at * 6.5) * 0.18, "sx": 1 + absf(sin(at * 6.5)) * 0.015})
			else: NvPlaza.add(P, {"body": -0.06, "head": -0.09 + sin(at * 1.3) * 0.02})
		"plaza_wave":
			var dd = d if d else 1.4; var kk = NvPlaza.env(at, 0, 0.28, dd - 0.35, dd)
			NvPlaza.add(P, {"armF": (-0.5 + sin(at * 11) * 0.16) * kk, "body": -0.03 * kk, "head": 0.05 * kk * sin(at * 5.5)})
		"plaza_bow":
			var dd = d if d else 1.2; var kk = NvPlaza.env(at, 0, dd * 0.3, dd * 0.62, dd); var deep = 1.0 if pl.get("deep") == null else J.num(pl.deep)
			NvPlaza.add(P, {"body": 0.3 * kk * deep, "head": 0.22 * kk * deep, "armF": 0.08 * kk, "armB": -0.08 * kk, "sy": 1 - 0.02 * kk})
		"plaza_doze":
			var dd = d if d else 8.0; var kk = NvPlaza.env(at, 0, 1.4, dd - 0.7, dd); var j = fmod(at, 5.6)
			var wake = sin(PI * NvPlaza.seg(j, 4.3, 4.9)) if j > 4.3 and j < 4.9 else 0.0; var br = sin(t * 1.1)
			NvPlaza.add(P, {"head": (0.28 * (1 - wake * 1.3) + br * 0.03) * kk, "body": 0.07 * kk, "armF": 0.06 * kk, "armB": -0.06 * kk, "sy": 1 + br * 0.018 * kk, "hairL": 0.08 * kk, "hairR": 0.08 * kk})
			o._z = kk * (1 - wake)
		"plaza_look":
			var dd = d if d else 2.0; var kk = NvPlaza.env(at, 0, 0.3, dd - 0.3, dd)
			NvPlaza.add(P, {"head": (-0.06 + sin(at * 2.2) * 0.04) * kk, "body": -0.02 * kk})
		"plaza_stretch":
			var dd = d if d else 2.0; var kk = NvPlaza.env(at, 0, 0.6, dd - 0.6, dd); var q = sin(t * 30) * 0.012 * (1.0 if at > 0.6 and at < dd - 0.6 else 0.0)
			NvPlaza.add(P, {"armF": -0.5 * kk, "armB": 0.5 * kk, "body": -0.1 * kk + q, "head": -0.12 * kk, "sy": 1 + 0.05 * kk, "sx": 1 - 0.025 * kk})
		"plaza_sniff":
			var sn = pow(maxf(0, sin(at * 3.1)), 4)
			NvPlaza.add(P, {"head": 0.24 + sin(at * 24) * 0.06 * sn, "body": 0.12, "sy": 1 - 0.02 * sn})
			var np = _npt(a, 0.5 if NvPlaza.PAPER.has(type) else 0.62, 0.28)
			after_ops.append(func(ctx): NvPlaza.sniff_lines(ctx, np[0], np[1] + 4 * s, at, s, fwd))
		"plaza_backrub":
			var dd = d if d else 2.6; var kk = NvPlaza.env(at, 0, 0.25, dd - 0.7, dd - 0.25); var st = NvPlaza.bump3(at, dd - 0.75, dd - 0.45, dd)
			NvPlaza.add(P, {"body": 0.14 * kk + sin(at * 11) * 0.015 * kk - 0.12 * st, "head": 0.06 * kk - 0.1 * st, "armB": sin(at * 11) * 0.11 * kk, "sy": 1 - 0.03 * kk + 0.04 * st, "sx": 1 + sin(at * 22) * 0.01 * kk})
			var hp2 = _npt(a, 0.45, 0.02)
			after_ops.append(func(ctx): NvPlaza.txt(ctx, hp2[0] + fwd * 8 * s, hp2[1] - 8 * s, "哎喲", 12 * s * 1.3, "#ffd2d2", NvPlaza.env(at, 0.1, 0.25, 1.3, 1.6), sin(at * 9) * 0.5))
		"plaza_soup":
			var dd = d if d else 10.0; var kk = NvPlaza.env(at, 0, 0.7, dd - 0.7, dd); var c = fmod(at - 0.7, 4.4)
			var blow = sin(PI * NvPlaza.seg(c, 0, 1.0)) if at > 0.7 else 0.0; var stir = NvPlaza.env(c, 1.2, 1.5, 3.6, 4.0) if at > 0.7 else 0.0
			o.sit = 1
			NvPlaza.add(P, {"y": 0.07 * kk, "sy": 1 - 0.07 * kk, "sx": 1 + 0.04 * kk, "tail1": 0.3 * kk, "tail2": 0.45 * kk, "head": 0.12 * blow, "body": 0.05 * blow + sin(at * 5) * 0.015 * stir, "armB": (sin(at * 5) * 0.09 + 0.05) * stir})
			var bp = _npt(a, 0.25, 0.47, 0)
			after_ops.append(func(ctx): NvPlaza.steam(ctx, bp[0], bp[1] + H * 0.07 * kk, t, s, 3, 0.55 + 0.6 * blow, fwd * blow * 0.8))
		"plaza_hair":
			var c = fmod(at, 2.3); var up = NvPlaza.eio(NvPlaza.seg(c, 0, 0.35)); var down = NvPlaza.eio(NvPlaza.seg(c, 0.35, 1.25)); var rel = NvPlaza.eio(NvPlaza.seg(c, 1.25, 2.0))
			var arm = -0.75 * up * (1 - down) + 0.15 * down * (1 - rel); var pull = sin(PI * NvPlaza.seg(c, 0.35, 1.5))
			NvPlaza.add(P, {"armF": arm, "head": 0.16 * up * (1 - rel) + 0.04, "hairL": 0.38 * pull - 0.12 * sin(PI * NvPlaza.seg(c, 1.4, 2.3)), "hairR": sin(at * 1.7) * 0.1 + 0.08 * pull, "body": -0.04 * pull + 0.03 * up * (1 - rel)})
		"plaza_shake":
			var shh = NvPlaza.seg(at, 0.25, 1.25); var amp = (1 - shh) * sin(PI * minf(1, shh * 6)) if at > 0.25 and at < 1.25 else 0.0; var cr = sin(PI * NvPlaza.seg(at, 0, 0.3)) * (1.0 if at < 0.3 else 0.0)
			NvPlaza.add(P, {"rot": sin(at * 30) * 0.1 * amp, "head": -sin(at * 30) * 0.12 * amp + 0.1 * NvPlaza.seg(at, 1.25, 1.6), "hairL": sin(at * 30 + 1) * 0.35 * amp, "hairR": sin(at * 30 + 2) * 0.35 * amp, "sy": 1 - 0.08 * cr, "sx": 1 + 0.04 * cr + 0.03 * amp})
			var hp3 = _npt(a, 0.5, 0.3)
			after_ops.append(func(ctx):
				for i in 12:
					var e = at - (0.3 + i * 0.07)
					if e < 0 or e > 0.5: continue
					var an = -PI * (0.1 + 0.8 * NvPlaza.hash(i * 7.7)); var v = (36 + NvPlaza.hash(i) * 34) * s
					NvPlaza.drop(ctx, hp3[0] + cos(an) * v * e * (1 if i % 2 else -1), hp3[1] + sin(an) * v * e + 140 * s * e * e, 1.6 * s, 1 - e / 0.5))
		"plaza_spin":
			var q = NvPlaza.seg(at, 0.25, 1.35); var cr = sin(PI * NvPlaza.seg(at, 0, 0.25)) * (1.0 if at < 0.25 else 0.0); var land = sin(PI * NvPlaza.seg(at, 1.35, 1.75)) * (1.0 if at > 1.35 else 0.0)
			var cc = cos(q * TAU * 2); var sg = signf(cc) if cc != 0 else 1.0
			P.sx = float(P.get("sx", 1.0)) * sg * maxf(0.07, absf(cc)) * (1 + 0.06 * cr)
			NvPlaza.add(P, {"sy": 1 - 0.1 * cr - 0.06 * land + 0.05 * sin(PI * q), "tail1": sin(at * 12) * 0.3 * sin(PI * q), "tail2": sin(at * 12 - 1) * 0.45 * sin(PI * q), "head": -0.08 * sin(PI * q)})
			lift += sin(PI * q) * 8 * s
			if at > 1.3:
				var hp4 = _npt(a, 0.5, 0.0)
				after_ops.append(func(ctx): NvPlaza.bubble(ctx, hp4[0] + fwd * 10 * s, hp4[1] - 16 * s, "♪", s, NvPlaza.env(at, 1.3, 1.45, 2.0, 2.2)))
		"plaza_boo":
			var cr = sin(PI * NvPlaza.seg(at, 0, 0.15)) if at < 0.15 else 0.0; var kk = NvPlaza.env(at, 0.12, 0.26, 0.72, 0.95); var tr = sin(at * 42) * 0.03 if at > 0.26 and at < 0.72 else 0.0
			NvPlaza.add(P, {"sy": 1 - 0.13 * cr + 0.12 * kk, "sx": 1 + 0.06 * cr - 0.05 * kk, "armF": -0.6 * kk + tr, "armB": 0.6 * kk - tr, "head": -0.12 * kk, "body": 0.12 * kk + 0.08 * cr, "x": 0.05 * kk})
			lift += 6 * s * kk
			var hp5 = _npt(a, 0.5, 0.0)
			after_ops.append(func(ctx): NvPlaza.txt(ctx, hp5[0] + fwd * 12 * s, hp5[1] - 6 * s, "哇！", 13 * s * 1.4, "#ffe9a8", NvPlaza.env(at, 0.15, 0.25, 0.8, 1.0), sin(at * 30)))
		"plaza_laugh":
			var dd = d if d else 1.6; var kk = NvPlaza.env(at, 0, 0.15, dd - 0.3, dd); var b = absf(sin(at * 15))
			NvPlaza.add(P, {"body": (0.16 + b * 0.05) * kk, "head": (0.06 + sin(at * 15) * 0.08) * kk, "sy": 1 - b * 0.04 * kk, "armB": 0.25 * kk, "armF": 0.2 * kk})
			var hp6 = _npt(a, 0.5, 0.05)
			after_ops.append(func(ctx): NvPlaza.txt(ctx, hp6[0] - fwd * 10 * s, hp6[1] - 4 * s - b * 2 * s, "嘻嘻", 10 * s * 1.4, "#c8f5b8", kk, sin(at * 15)))
		"plaza_startle", "plaza_eek":
			var dd = d if d else (0.75 if o.act == "plaza_eek" else 1.3)
			var cr = sin(PI * NvPlaza.seg(at, 0, 0.08)) if at < 0.08 else 0.0; var j = sin(PI * NvPlaza.seg(at, 0.06, 0.32)) * (1.0 if at > 0.06 and at < 0.32 else 0.0)
			var tr = sin(at * 45) * 0.03 * (1 - NvPlaza.seg(at, 0.3, dd)) if at > 0.3 else 0.0; var kk = 1 - NvPlaza.eio(NvPlaza.seg(at, dd * 0.65, dd))
			NvPlaza.add(P, {"sy": 1 - 0.1 * cr + 0.06 * j, "armF": (-0.55 * j - 0.2) * kk + tr, "armB": (0.55 * j + 0.2) * kk - tr, "head": (-0.2 * j - 0.06) * kk + tr * 2, "body": (-0.1 * j - 0.04) * kk + tr, "hairL": -0.25 * j, "hairR": -0.25 * j})
			lift += j * 7 * s
		"plaza_reach":
			var kk = NvPlaza.env(at, 0, 0.12, 0.3, 0.5)
			NvPlaza.add(P, {"body": 0.18 * kk, "armF": -0.55 * kk, "head": 0.05 * kk, "x": 0.05 * kk})
		"plaza_bump":
			var im = sin(PI * NvPlaza.seg(at, 0, 0.12)) if at < 0.12 else 0.0; var bk = sin(PI * NvPlaza.seg(at, 0.1, 0.55)) * (1.0 if at > 0.1 and at < 0.55 else 0.0); var land = sin(PI * NvPlaza.seg(at, 0.55, 0.75)) if at > 0.55 else 0.0
			NvPlaza.add(P, {"sx": 1 - 0.14 * im + 0.08 * land, "sy": 1 + 0.07 * im - 0.1 * land, "body": -0.22 * im - 0.12 * bk, "head": -0.2 * im - 0.1 * bk, "armF": 0.25 * im, "armB": -0.25 * im})
			lift += bk * 7 * s
			var hp7 = _npt(a, 0.3, 0.2)
			after_ops.append(func(ctx): NvPlaza.txt(ctx, hp7[0] + fwd * 10 * s, hp7[1] - 4 * s, "咚！", 11 * s * 1.4, "#ffe9a8", NvPlaza.env(at, 0.0, 0.06, 0.45, 0.7), 0.4))
		"plaza_dizzy":
			var dd = d if d else 2.2; var kk = 1 - NvPlaza.eio(NvPlaza.seg(at, dd - 0.6, dd))
			NvPlaza.add(P, {"rot": sin(at * 6) * 0.08 * kk, "head": cos(at * 6) * 0.12 * kk, "body": sin(at * 6 + 1) * 0.05 * kk, "armF": sin(at * 6) * 0.1 * kk, "armB": cos(at * 6) * 0.1 * kk})
			o._stars = kk
	_draw_m(a, P, lift, shK)

func _hop_pose(hp: float, H: float, P: Dictionary) -> float:
	var c = maxf(sin(PI * NvPlaza.seg(hp, 0, 0.24)) * (1.0 if hp < 0.24 else 0.0), 0); var air = NvPlaza.seg(hp, 0.22, 0.9); var land = sin(PI * NvPlaza.seg(hp, 0.9, 1)) if hp > 0.9 else 0.0
	var up = sin(PI * air) * (1.0 if hp >= 0.22 and hp <= 0.9 else 0.0)
	NvPlaza.add(P, {"sy": 1 - 0.1 * c - 0.09 * land + 0.06 * up * (1 - air), "sx": 1 + 0.06 * c + 0.06 * land - 0.03 * up, "body": 0.04 * up, "head": -0.05 * up + 0.06 * land, "armF": 0.08 * up - 0.06 * land, "armB": -0.08 * up + 0.06 * land})
	return up * H * 0.2

# ---------------- 餓鬼王：邊行邊食包 ----------------
func _eat(a: Dictionary) -> bool:
	var c = Limbs.CH.get("eguiking")
	var bodyt = PtGfx.tex("eguiking__body"); var arm = PtGfx.tex("eguiking__arm")
	if c == null or bodyt == null or arm == null: return false
	var o: Dictionary = a.o; var t: float = o.t; var H: float = a.H; var s: float = a.s; var fwd = 1.0 if a.faceRight else -1.0
	var W = H * bodyt.get_width() / bodyt.get_height()
	var P = NvPlaza.base_pose(o, "eguiking")
	var cyc = 3.6; var ph = fmod(o.at + 0.15, cyc)
	var raise = NvPlaza.eio(NvPlaza.seg(ph, 0.1, 0.62)); var away = NvPlaza.eio(NvPlaza.seg(ph, 0.86, 1.3)); var lk = raise * (1 - away)
	var chomp = NvPlaza.bump3(ph, 0.6, 0.67, 0.86); var ck = NvPlaza.seg(ph, 1.3, 2.7); var chew = sin(ck * PI * 6) * (1 - ck * 0.4) if ph > 1.3 and ph < 2.7 else 0.0
	NvPlaza.add(P, {"head": -0.07 * raise * (1 - NvPlaza.seg(ph, 0.55, 0.62)) + 0.1 * chomp + 0.035 * chew, "body": 0.04 * chomp, "sy": 1 - 0.025 * chomp - 0.012 * absf(chew), "sx": 1 + 0.015 * absf(chew)})
	var th = 58 * lk + 4 * chomp; var hx = 0.06 * lk; var hy = 0.045 * lk
	var mp = {}
	for kk in P: mp[kk] = -P[kk] if (P[kk] is float or P[kk] is int) and kk != "y" and kk != "sx" and kk != "sy" else P[kk]
	var fy = (3 + sin(t * 2.4) * 2) * s
	_shadow_at(a, 0, 1)
	var B = Transform2D(0, Vector2(a.x, a.y - fy))
	if a.faceRight: B = B * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
	B = B * Transform2D(0, Vector2(float(mp.get("x", 0.0)) * W, float(mp.get("y", 0.0)) * H)) * Transform2D(Vector2(float(mp.get("sx", 1.0)), 0), Vector2(0, float(mp.get("sy", 1.0))), Vector2.ZERO)
	var bA = float(mp.get("body", 0.0)); var bp = [0.48 * W - W / 2, 0.70 * H - H]; var pv = [c.pivot[0] * W - W / 2, c.pivot[1] * H - H]
	var rx = pv[0] - bp[0]; var ry = pv[1] - bp[1]
	var px = bp[0] + cos(bA) * rx - sin(bA) * ry + hx * W; var py = bp[1] + sin(bA) * rx + cos(bA) * ry - hy * H
	var m2 = mp.duplicate(); m2.x = 0.0; m2.y = 0.0; m2.sx = 1.0; m2.sy = 1.0; m2.rot = 0.0; m2.armF = 0.0
	var rig = PtChar.RIG.get("eguiking"); var bb = []
	for b in rig.bones: if b[0] != "armF" and b[0] != "axe": bb.append(b)
	var m = PtGfx.mesh_for("eguiking__body", "eguiking__body", bb); _use(m, "eat")
	_raw(m, 0, 0, H, m2, false, B)
	var XA = Transform2D(0, Vector2(-ax, -ay)) * B * Transform2D(bA + th * D2R, Vector2(px, py))
	var rr = Rect2(-c.pivot[0] * W, -c.pivot[1] * H, W, H)
	front_ops.append(func(ctx):
		ctx.ci.draw_set_transform_matrix(XA); ctx.ci.draw_texture_rect(arm, rr, false, Color(1, 1, 1, 1)); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY))
	var mx = a.x - fwd * 0.03 * W; var my = a.y - fy - 0.66 * H; var sd = floor((o.at + 0.15) / cyc) * 13 + 3
	after_ops.append(func(ctx): NvPlaza.crumbs(ctx, mx, my, ph - 0.66, s, sd, fwd))
	return true

# ---------------- 黃總：練高爾夫（用 PtChar 嘅拆手）----------------
func _golf(a: Dictionary) -> bool:
	if not Limbs.has("huang"): return false
	var o: Dictionary = a.o; var t: float = o.t; var H: float = a.H; var s: float = a.s; var fwd = 1.0 if a.faceRight else -1.0; var at: float = o.at
	var d = J.num(o.pl.get("d", 9.6)) if o.pl.get("d") != null else 9.6
	var IN = 0.9; var L = 4.0; var n = maxi(1, int(floor((d - IN - 0.7) / L + 0.01))); var last = at >= IN + (n - 1) * L
	var pose = "recover"; var pt = 0.0; var c = -1.0; var ball = 0.0
	if at < IN:
		if at < 0.5: pose = "recover"; pt = 1 - NvPlaza.eio(NvPlaza.seg(at, 0, 0.5))
		else: pose = "follow"; pt = 1 - NvPlaza.eio(NvPlaza.seg(at, 0.5, IN))
		ball = NvPlaza.seg(at, 0.3, 0.8)
	else:
		c = minf(fmod(at - IN, L) + (L if at >= IN + n * L else 0.0), 99.0 if last else L - 1e-6)
		if last: c = at - IN - (n - 1) * L
		if c < 1.0: pose = "strike"; pt = 0.42 - 0.035 * (0.5 - 0.5 * cos(c * TAU * 1.5)) * (1.0 if c < 0.95 else 0.0); ball = 1
		elif c < 1.9: pose = "strike"; pt = 0.42 * (1 - NvPlaza.eio(NvPlaza.seg(c, 1.0, 1.9))); ball = 1
		elif c < 2.1: pose = "strike"; pt = 0; ball = 1
		elif c < 2.24: pose = "strike"; pt = 0.42 * NvPlaza.ei(NvPlaza.seg(c, 2.1, 2.24)); ball = 1
		elif c < 2.55: pose = "follow"; pt = NvPlaza.eo3(NvPlaza.seg(c, 2.24, 2.55))
		elif c < 3.3 or (last and c < 3.4): pose = "follow"; pt = 1
		elif not last: pose = "follow"; pt = 1 - NvPlaza.eio(NvPlaza.seg(c, 3.3, 4.0)); ball = NvPlaza.seg(c, 3.5, 3.9)
		else: pose = "recover"; pt = NvPlaza.eio(NvPlaza.seg(c, 3.4, 4.1))
	if golf == null:
		golf_u = PtU.new(); golf_u.k = "huang"; golf_u.side = 0
		golf = PtChar.new(golf_u, P0.vv.stub); turn.add_child(golf); turn.move_child(golf, mi.get_index())
		golf.over.visible = false; golf.glow.visible = false
	golf.visible = true; mi.visible = false
	golf_u.x = a.x; golf_u.y = a.y
	golf.sync({"t": t, "walk": false, "pose": pose, "pt": pt, "flip": not a.faceRight, "enemy": false, "rot": 0.0, "alpha": 1.0, "flash": 0.0, "ox": 0.0, "oy": 0.0, "s": s,
		"cloth": null, "badge": null, "wtex": null, "wsty": "", "swing_t": -1.0, "aura": 0.0, "charge": -1.0, "dying": false, "lweapon": null})
	golf.position = Vector2.ZERO
	var bx = a.x + fwd * H * 0.42; var by = a.y
	if ball > 0:
		after_ops.append(func(ctx):
			ctx.save(); ctx.globalAlpha *= ball; ctx.fillStyle = "#fbfbf4"; ctx.strokeStyle = "#555"; ctx.lineWidth = 0.4; ctx.beginPath(); ctx.arc(bx, by - 1.2 * s, 1.5 * s, 0, TAU); ctx.fill(); ctx.stroke(); ctx.restore())
	if c >= 2.24 and c < 3.3:
		var e = c - 2.24; var x = bx + fwd * 150 * s * e; var y = by - 1.2 * s - 120 * s * e + 70 * s * e * e
		after_ops.append(func(ctx):
			ctx.save(); ctx.globalAlpha *= 1 - NvPlaza.seg(e, 0.6, 1); ctx.fillStyle = "#fbfbf4"; ctx.beginPath(); ctx.arc(x, y, 1.5 * s * (1 - 0.4 * e), 0, TAU); ctx.fill()
			NvPlaza.crayon(ctx, [[x - fwd * 8 * s, y + 5 * s], [x - fwd * 2 * s, y + 1 * s]], 0.8 * s, "rgba(255,255,255,.6)"); ctx.restore()
			NvPlaza.dust_puff(ctx, bx, by, NvPlaza.seg(e, 0, 0.5), s, 4))
	return true

# ---------------- 天花姐：翻身上屋簷倒掛 ----------------
func _hang(a: Dictionary) -> bool:
	var hang = PtGfx.tex("tianhua_hang")
	if hang == null: return false
	var o: Dictionary = a.o; var at: float = o.at; var t: float = o.t; var H: float = a.H; var s: float = a.s; var fwd = 1.0 if a.faceRight else -1.0; var pl: Dictionary = o.pl
	var eh = J.num(pl.get("eh")) if pl.get("eh") != null else H * 2.2
	var hd = J.num(pl.get("hd")) if pl.get("hd") != null else 6.0
	var T1 = 0.85; var T2 = T1 + hd; var T3 = T2 + 0.4; var T4 = T3 + 1.6
	var hh = H * 645.0 / 577.0; var hw = hh * hang.get_width() / hang.get_height()
	var hx0 = a.x; var hy0 = a.y - eh
	var stand = func(lift: float, rot: float, P: Dictionary) -> void:
		var cy = a.y - _float_y(a) - lift - H * 0.5
		var R = Transform2D(0, Vector2(a.x, cy)) * Transform2D(rot, Vector2.ZERO) * Transform2D(0, Vector2(-a.x, -cy))
		_mesh(a.x, a.y - _float_y(a) - lift, H, P, a.faceRight, R)
	var hang_img = func(y: float, ang: float, sy: float) -> void:
		mi.visible = false
		var X = Transform2D(0, Vector2(-ax, -ay)) * Transform2D(0, Vector2(hx0, y)) * Transform2D(ang, Vector2.ZERO) * Transform2D(Vector2(1, 0), Vector2(0, sy), Vector2.ZERO)
		if not a.faceRight: X = X * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
		front_ops.append(func(ctx):
			ctx.ci.draw_set_transform_matrix(X); ctx.ci.draw_texture_rect(hang, Rect2(-0.72 * hw, 0, hw, hh), false); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY))
	if at < T1:
		var cr = NvPlaza.eo(NvPlaza.seg(at, 0, 0.36)) * (1 - NvPlaza.seg(at, 0.4, 0.5)); var j = NvPlaza.seg(at, 0.45, T1); var up = NvPlaza.eo3(j)
		var P = NvPlaza.add(MeshAnim.idle(t), {"body": 0.2 * cr, "head": 0.12 * cr, "sy": 1 - 0.12 * cr + 0.16 * sin(PI * j) * (1 - j), "sx": 1 + 0.06 * cr - 0.08 * sin(PI * j), "armB": sin(at * 14) * 0.08 * cr, "hairL": -0.3 * sin(PI * j), "hairR": -0.3 * sin(PI * j)})
		var lift = (eh - H * 0.55) * up; var rot = -fwd * PI * NvPlaza.eio(NvPlaza.seg(at, 0.58, T1))
		_shadow_at(a, lift, 1)
		stand.call(lift, rot, P)
		var np = _npt(a, 0.45, 0.0)
		after_ops.append(func(ctx):
			if at > 0.45 and at < 0.7:
				ctx.save(); ctx.globalAlpha *= 1 - NvPlaza.seg(at, 0.5, 0.7)
				for i in range(-1, 2): NvPlaza.crayon(ctx, [[a.x + i * 6 * s, a.y - lift + 4 * s], [a.x + i * 6 * s, a.y - lift + 22 * s]], 0.8 * s, "#e8dfd0")
				ctx.restore()
			NvPlaza.dust_puff(ctx, a.x, a.y, NvPlaza.seg(at, 0.45, 0.9), s, 2)
			NvPlaza.txt(ctx, np[0] + fwd * 9 * s, np[1] - 6 * s, "哎喲", 12 * s * 1.3, "#ffd2d2", NvPlaza.env(at, 0.05, 0.15, 0.4, 0.5), 0.3))
		return true
	if at < T2:
		var e = at - T1; var amp = 22 * exp(-e * 1.7) * cos(e * 4.6); var sway = sin(t * 1.25) * 2.2; var br = 1 + sin(t * 1.6) * 0.012
		var x0 = a.x; var y0 = a.y
		sh_ops.append(func(ctx): ctx.save(); ctx.globalAlpha *= 0.35; Art.shadow(ctx, x0, y0 + 1 * s, s * 0.5); ctx.restore())
		hang_img.call(hy0, (amp + sway) * D2R * fwd, br)
		after_ops.append(func(ctx):
			NvPlaza.dust_puff(ctx, hx0, hy0 + 2 * s, NvPlaza.seg(e, 0, 0.7), s, 9)
			for i in 4:
				var f = e - i * 0.12
				if f < 0 or f > 0.8: continue
				ctx.save(); ctx.globalAlpha *= 1 - f / 0.8; ctx.fillStyle = "#bfb29c"; ctx.beginPath(); ctx.arc(hx0 + (NvPlaza.hash(i) - 0.5) * 14 * s, hy0 + 2 * s + 60 * s * f * f, 0.8 * s, 0, TAU); ctx.fill(); ctx.restore())
		o._z = NvPlaza.seg(e, 1.8, 2.4) * (1 - NvPlaza.seg(at, T2 - 0.5, T2)) if e > 1.8 else 0.0; o._zpos = [hx0 - fwd * hw * 0.35, hy0 + hh * 0.75]
		return true
	if at < T3:
		var q = NvPlaza.seg(at, T2, T3); var fall = NvPlaza.ei(q); var lift2 = (eh - H * 0.55) * (1 - fall)
		var P2 = NvPlaza.add(MeshAnim.idle(t), {"hairL": 0.3, "hairR": 0.3, "sy": 1.05, "sx": 0.96})
		_shadow_at(a, lift2, 1)
		if q < 0.18: hang_img.call(hy0 + 30 * s * q, 0, 1)
		else: stand.call(lift2, -fwd * PI * (1 - NvPlaza.eio(NvPlaza.seg(q, 0.18, 1))), P2)
		return true
	var e2 = at - T3; var sq = sin(PI * NvPlaza.seg(e2, 0, 0.3)) * (1.0 if e2 < 0.3 else 0.0); var kk = NvPlaza.env(e2, 0.15, 0.4, T4 - T3 - 0.4, T4 - T3)
	var P3 = NvPlaza.add(MeshAnim.idle(t), {"sy": 1 - 0.16 * sq, "sx": 1 + 0.1 * sq, "body": 0.2 * sq + 0.13 * kk, "head": 0.12 * sq + 0.06 * kk, "armB": sin(e2 * 11) * 0.11 * kk})
	_shadow_at(a, 0, 1)
	_mesh(a.x, a.y - _float_y(a), H, P3, a.faceRight)
	var np2 = _npt(a, 0.45, 0.0)
	after_ops.append(func(ctx):
		NvPlaza.dust_puff(ctx, a.x, a.y, NvPlaza.seg(e2, 0, 0.5), s, 5)
		NvPlaza.txt(ctx, np2[0] + fwd * 9 * s, np2[1] - 8 * s, "哎喲", 12 * s * 1.3, "#ffd2d2", NvPlaza.env(e2, 0.1, 0.25, 1.1, 1.4), sin(e2 * 9) * 0.5))
	return true

# ---------------- 冇骨架角色（Toyol／Pocong／Penanggal）：drawSpecial ----------------
var sp_frame := 0
func sync_special(ag: Dictionary, t: float, mute: bool) -> void:
	ax = J.num(ag.x); ay = J.num(ag.y); position = Vector2(ax, ay)
	sh_ops.clear(); back_ops.clear(); front_ops.clear(); after_ops.clear(); head_ops.clear()
	mi.visible = false
	if golf: golf.visible = false
	if spc == null:
		spc = NvSpecial.new(k)
		sp_n = PtDraw.new(); sp_n.tag = "special"; turn.add_child(sp_n); turn.move_child(sp_n, mi.get_index())
		sp_n.fn = func(c): _draw_special(c)
	var turnT = J.num(ag.get("turnT", 1.0))
	turn.scale = Vector2(maxf(0.08, absf(cos(PI * turnT / NvPlaza.TURN))) if turnT < NvPlaza.TURN else 1.0, 1)
	var s = NvPlaza.SC; var H = float(NvPlaza.CH.get(k, 50)) * s; var at = J.num(ag.get("at", 0.0)); var fwd = 1.0 if J.t(ag.get("face")) else -1.0
	var act = J.str(ag.get("act", "")) if ag.get("act") != null else ""; var pl = ag.get("pl") if ag.get("pl") is Dictionary else {}
	var dx = 0.0; var dy = 0.0; var rot = 0.0; var sx = 1.0; var sy = 1.0; var walk = J.num(ag.get("w", 0.0)) > 0.3
	var zk = 0.0; var stk = 0.0
	var spk = J.t(pl.get("spk")); var d = J.num(pl.get("d", 0.0))
	match act:
		"plaza_talk", "plaza_argue":
			if spk: dy = -absf(sin(at * 8)) * 1.6 * s; rot = sin(at * 4.2) * 0.05
			else: rot = 0.05 * sin(PI * NvPlaza.seg(fmod(at, 1.5), 0.2, 0.75)) * fwd
		"plaza_wave": rot = sin(at * 9) * 0.07 * NvPlaza.env(at, 0, 0.2, 1.1, 1.4); dy = -absf(sin(at * 9)) * 1.2 * s
		"plaza_bow":
			var dd = d if d else 1.2; var kk = NvPlaza.env(at, 0, dd * 0.3, dd * 0.62, dd); rot = 0.22 * kk * fwd; sy = 1 - 0.04 * kk
		"plaza_doze":
			var dd = d if d else 8.0; var kk = NvPlaza.env(at, 0, 1.4, dd - 0.7, dd); rot = 0.1 * kk * fwd + sin(t * 1.1) * 0.015; sy = 1 + sin(t * 1.1) * 0.015 * kk; zk = kk
		"plaza_look": rot = -0.05 * fwd * NvPlaza.env(at, 0, 0.3, 1.6, 2)
		"plaza_startle", "plaza_eek":
			var j = sin(PI * NvPlaza.seg(at, 0.06, 0.32)) * (1.0 if at > 0.06 and at < 0.32 else 0.0); dy = -j * 7 * s; sy = 1 + 0.08 * j; rot = sin(at * 45) * 0.03 * (1 - NvPlaza.seg(at, 0.3, 1.2)) if at > 0.3 else 0.0
		"plaza_dizzy": rot = sin(at * 6) * 0.09 * (1 - NvPlaza.seg(at, 1.6, 2.2)); stk = 1 - NvPlaza.seg(at, 1.6, 2.2)
		"plaza_stretch":
			var kk = NvPlaza.env(at, 0, 0.6, 1.4, 2); sy = 1 + 0.07 * kk; sx = 1 - 0.035 * kk; rot = -0.05 * kk * fwd
		"plaza_hop": walk = true
		"plaza_coins":
			var c = fmod(at, 1.1); var dd = d if d else 5.0; rot = (0.07 + 0.03 * sin(PI * NvPlaza.seg(c, 0, 0.3))) * fwd * NvPlaza.env(at, 0, 0.3, dd - 0.3, dd); dy = sin(PI * NvPlaza.seg(c, 0, 0.3)) * 0.8 * s
		"plaza_spin":
			var q = NvPlaza.seg(at, 0.25, 1.35); var cc = cos(q * TAU * 2); sx = (signf(cc) if cc != 0 else 1.0) * maxf(0.07, absf(cc)); dy = -sin(PI * q) * 8 * s
	ag._z = zk; ag._stars = stk
	var nr = PtChar.NATIVE_R.has(k); var flip = J.t(ag.get("face")) == nr
	var T = t + J.num(ag.get("seed", 0.0))
	var x = ax + dx; var y = ay + dy
	var solid = PtChar.SOLID.has(k)
	# 外層：繞腳底轉／縮
	var R = Transform2D(0, Vector2(ax, ay)) * Transform2D(rot, Vector2.ZERO) * Transform2D(Vector2(sx, 0), Vector2(0, sy), Vector2.ZERO) * Transform2D(0, Vector2(-ax, -ay))
	var sh_k = 1.0 if solid else 0.8
	sh_ops.append(func(ctx):
		ctx.save(); ctx.transform(R.x.x, R.x.y, R.y.x, R.y.y, R.origin.x, R.origin.y)
		if not solid: ctx.globalAlpha *= 0.55
		Art.shadow(ctx, x, y + 1 * s, s * sh_k); ctx.restore())
	var F = R
	if flip: F = F * Transform2D(0, Vector2(x, 0)) * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO) * Transform2D(0, Vector2(-x, 0))
	var fy = y if solid else y - (3 + sin(T * 2.4) * 2) * s
	# 特殊鬼網格變形較貴：隔幀重算（30fps 形變，位置仍每幀跟）
	sp_frame += 1
	if sp_args.is_empty() or sp_frame % 2 == 0 or sp_args.flip_v != flip:
		sp_args = {"F": F, "x": x - ax, "y": fy - ay, "s": s, "flip_v": flip, "ax": ax, "ay": ay, "o": {"t": T, "walk": walk, "flip": flip, "alpha": 1.0}}
		sp_n.queue_redraw()
	var hy = ay - float(NvPlaza.CH.get(k, 50)) * s - (0.0 if NvPlaza.PSOLID.has(k) else 4.0)
	if act == "plaza_coins":
		var Hk = H; var plc = pl
		after_ops.append(func(ctx): _coins(ctx, at, s, Hk, fwd, plc))
	if zk > 0.05:
		var p = [ax + fwd * 9, ay - H * (1 - float(NvPlaza.FACEV.get(k, 0.3))) - (2.0 if NvPlaza.PSOLID.has(k) else 6.0)]
		head_ops.append(func(ctx): NvPlaza.zzz(ctx, p[0], p[1], T, s, zk))
	if stk > 0: head_ops.append(func(ctx): NvPlaza.stars(ctx, ax, hy + 2, T, s, stk))
	var icon = ag.get("icon"); var iconT = J.num(ag.get("iconT", 9.0))
	if icon != null and J.str(icon) != "" and iconT < 1.25 and not mute:
		var k2 = minf(1, minf(iconT * 6, (1.25 - iconT) * 5)); var ic = J.str(icon)
		head_ops.append(func(ctx): NvPlaza.bubble(ctx, ax + fwd * 7, hy - 7 - sin(minf(1, iconT * 3) * PI) * 2, ic, s, k2))
	var ft = ag.get("fxTxt")
	if ft is Dictionary and J.num(ft.t) < 1:
		var ftt = J.num(ft.t); var fs = J.str(ft.s)
		head_ops.append(func(ctx): NvPlaza.txt(ctx, ax, hy - 6 - ftt * 8, fs, 10 * s * 1.4, "#ffe9a8", minf(1, (1 - ftt) * 3), 0.2))
	sh.queue_redraw(); back.queue_redraw(); front.queue_redraw(); after.queue_redraw(); head.queue_redraw()

func _draw_special(c: CanvasItem) -> void:
	if sp_args.is_empty(): return
	var M = Transform2D(0, Vector2(-sp_args.ax, -sp_args.ay)) * sp_args.F
	spc.draw(c, M, sp_args.x + sp_args.ax, sp_args.y + sp_args.ay, sp_args.s, sp_args.o)

func _coins(ctx: Ctx, at: float, s: float, H: float, fwd: float, pl: Dictionary) -> void:
	var px = ax + fwd * 0.27 * H * 337 / 586; var py = ay - 0.58 * H
	var n = int(floor(at / 1.1)); var c = fmod(at, 1.1); var lost = (n % 5) == 4; var d = J.num(pl.get("d", 5.0)) if pl.get("d") != null else 5.0
	if not lost and at < d - 0.4:
		var e = NvPlaza.seg(c, 0.05, 0.75); var x = px + fwd * sin(PI * e) * 3 * s; var y = py - sin(PI * e) * 15 * s
		if c > 0.05 and c < 0.75:
			var sp = cos(e * TAU * 2); ctx.save(); ctx.translate(x, y); ctx.scale(maxf(0.15, absf(sp)), 1)
			ctx.beginPath(); ctx.arc(0, 0, 2.6 * s, 0, TAU); ctx.fillStyle = "#f2c94c" if sp > 0 else "#d9a62e"; ctx.fill(); ctx.lineWidth = 0.7 * s; ctx.strokeStyle = "#6a4a14"; ctx.stroke()
			ctx.fillStyle = "#6a4a14"; ctx.fillRect(-0.7 * s, -0.7 * s, 1.4 * s, 1.4 * s); ctx.restore()
			if c > 0.5: ctx.save(); ctx.globalAlpha *= 1 - NvPlaza.seg(c, 0.5, 0.75); NvPlaza.star(ctx, x + 3 * s, y - 2 * s, 1.6 * s, c * 5); ctx.restore()
		NvPlaza.txt(ctx, px + fwd * 12 * s, py - 14 * s - NvPlaza.seg(c, 0.4, 1.1) * 6 * s, str(n % 5 + 1), 10 * s * 1.4, "#ffe9a8", NvPlaza.env(c, 0.4, 0.5, 0.9, 1.1), 0)
	elif lost: NvPlaza.bubble(ctx, ax + fwd * 6 * s, ay - H - 10 * s, "?", s, NvPlaza.env(c, 0, 0.15, 0.9, 1.1))
