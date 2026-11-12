# 拆手揮武器（移植 limbs.js）：身體用 MeshAnim 呼吸，拿武器嘅手係原圖拆出嚟一塊，繞手腕轉
extends Node

const D := PI / 180.0
const DEFK := {"idle": {"th": 0, "lean": 0, "dx": 0, "dy": 0, "sx": 1, "sy": 1}, "antic": {"th": 60, "lean": 8, "dx": -0.04, "dy": -0.02, "sx": 0.96, "sy": 1.05}, "contact": {"th": -70, "lean": -10, "dx": 0.11, "dy": 0, "sx": 1.06, "sy": 0.96}, "follow": {"th": -120, "lean": -18, "dx": 0.14, "dy": 0.02, "sx": 1.04, "sy": 0.95}}
var CH = {}
var WP = {}
var _kn = {}

func _ready() -> void:
	var L: Dictionary = DB.RIGS.get("LIMBS", {})
	CH = L.get("chars", {}); WP = L.get("weapons", {})

func has(type: String) -> bool:
	return CH.has(type) and Spr.ok(type + "__body") and Spr.ok(type + "__arm")

static func _eo(t: float) -> float: return 1 - (1 - t) * (1 - t)
static func _ei(t: float) -> float: return t * t
static func _eio(t: float) -> float: return 2 * t * t if t < 0.5 else 1 - 2 * (1 - t) * (1 - t)
static func _eo3(t: float) -> float: return 1 - pow(1 - t, 3)
static func _lerp(a: Dictionary, b: Dictionary, k: float) -> Dictionary:
	var o = {}
	for n in a: o[n] = float(a[n]) + (float(b[n]) - float(a[n])) * k
	return o

func _keys(type: String) -> Dictionary:
	if _kn.has(type): return _kn[type]
	var src = CH[type].get("K") if CH.has(type) and CH[type].get("K") != null else DEFK
	var o = {}
	for n in src:
		var d = {"th": 0.0, "lean": 0.0, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0, "hx": 0.0, "hy": 0.0, "bend": 0.0}
		for k in src[n]: d[k] = float(src[n][k])
		o[n] = d
	_kn[type] = o
	return o

func state_of(type: String, pose, p: float) -> Dictionary:
	var K = _keys(type); p = clampf(p, 0, 1)
	match pose:
		"windup": return _lerp(K.idle, K.antic, _eo(p))
		"strike": return _lerp(K.antic, K.contact, _ei(p / 0.42)) if p < 0.42 else _lerp(K.contact, K.follow, _eo3((p - 0.42) / 0.58))
		"follow": return _lerp(K.contact, K.follow, _eo3(p))
		"recover": return _lerp(K.follow, K.idle, _eio(p))
		"chop", "hammer":
			var q = fmod(p * 2, 1.0) if pose == "hammer" else p
			if q < 0.62: return _lerp(K.idle, K.antic, _eo(q / 0.62))
			if q < 0.8: return _lerp(K.antic, K.contact, _ei((q - 0.62) / 0.18))
			return _lerp(K.contact, K.follow, _eo3((q - 0.8) / 0.2))
	return K.idle

func weapon_of(type: String, wid = null) -> Variant:
	var id = wid if wid != null else CH[type].get("weapon")
	if id != null and WP.has(id) and Spr.ok(WP[id].img): return WP[id]
	return null

func _draw_weapon(ctx: Ctx, c: Dictionary, wp: Dictionary, H: float, _bend: float) -> Transform2D:
	var im = Spr.get_tex(wp.img); var ww: float = wp.w * H; var wh: float = wp.h * H
	var tx: float = (wp.tip[0] - wp.grip[0]) * ww; var ty: float = (wp.tip[1] - wp.grip[1]) * wh
	ctx.rotate((float(c.hold) - float(wp.ang)) * D)
	ctx.drawImage(im, -wp.grip[0] * ww, -wp.grip[1] * wh, ww, wh)
	ctx.translate(tx, ty)
	return ctx.getTransform()

func draw(ctx: Ctx, type: String, x: float, y: float, H: float, o: Dictionary, faceRight: bool, mesh_pose: Dictionary) -> Variant:
	var c: Dictionary = CH[type]
	var s = state_of(type, o.get("pose"), float(o.get("pt", 0.0)))
	var body = Spr.get_tex(type + "__body"); var arm = Spr.get_tex(type + "__arm")
	var W = H * body.get_width() / body.get_height()
	var wp = weapon_of(type, o.get("weapon"))
	var nr: bool = MeshAnim.NATIVE_R.has(type) or bool(c.get("nativeR", false))
	var pvx: float = 1.0 - c.pivot[0] if nr else c.pivot[0]
	var R = MeshAnim.RIG.get(type)
	var p_ = o.get("pose")
	var atk: bool = p_ == "windup" or p_ == "strike" or p_ == "follow" or p_ == "recover"
	var walking: bool = o.get("walk", false) or p_ == "move" or p_ == "walk" or p_ == "run"
	var t: float = o.get("t", 0.0)
	if R and R.get("hop", false) and not atk and (walking or o.get("enemy", false)): y -= absf(sin(t * 5)) * 0.09 * H
	var th_add = 0.0
	if c.get("weapon") == null and walking: th_add = sin(t * 7) * (float(c.swing) if c.get("swing") != null else 7.0)
	ctx.save(); ctx.translate(x, y)
	if faceRight: ctx.scale(-1, 1)
	ctx.translate(-s.dx * W, s.dy * H); ctx.translate(0, -H * 0.28); ctx.rotate(s.lean * D); ctx.translate(0, H * 0.28); ctx.scale(s.sx, s.sy)
	var mp = mesh_pose.duplicate(); mp.armF = 0.0; mp.axe = 0.0; mp.body = 0.0; mp.x = 0.0
	if c.get("still") != null:
		for b in c.still: mp[b] = 0.0
	var px = (pvx - 0.5) * W; var py: float = -H + c.pivot[1] * H + float(mp.get("y", 0.0)) * H
	var lift = clampf((s.th - 25) / 40.0, 0, 1)
	var lx: float = px + (lift * c.lift[0] + s.hx) * W; var ly: float = py - (lift * c.lift[1] + s.hy) * H
	var hk: float = float(c.hk) if c.get("hk") != null else 1.0
	var ath: float = (s.th + th_add) * hk; var wth: float = (s.th + th_add) - ath
	var wpn = func() -> void:
		if wp == null: return
		ctx.save(); ctx.translate(lx, ly); ctx.rotate(ath * D)
		if nr: ctx.scale(-1, 1)
		ctx.translate((c.grip[0] - c.pivot[0]) * W, (c.grip[1] - c.pivot[1]) * H); ctx.rotate(wth * D * (-1.0 if nr else 1.0))
		_draw_weapon(ctx, c, wp, H, s.bend); ctx.restore()
	var draw_arm = func() -> void:
		ctx.save(); ctx.translate(lx, ly); ctx.rotate(ath * D)
		if nr: ctx.scale(-1, 1)
		ctx.drawImage(arm, -c.pivot[0] * W, -c.pivot[1] * H, W, H)
		ctx.restore()
	var behind: bool = s.th > float(c.behind) or (c.get("behindLo") != null and s.th < float(c.behindLo))
	var wb = c.get("wbehind")
	var w_behind: bool = (s.th > wb[0] and s.th < wb[1]) if wb != null else behind
	if w_behind: wpn.call()
	if behind: draw_arm.call()
	if nr: ctx.save(); ctx.scale(-1, 1)
	MeshAnim.draw_body(ctx, type, type + "__body", H, mp)
	if nr: ctx.restore()
	if not w_behind: wpn.call()
	if not behind: draw_arm.call()
	ctx.restore()
	return null
