# [rtsfx] 地圖半即時戰鬥特效：同夜班巡陰用同一套配方（game/fxkit/fx_kit.gd）、同一批 fx 貼圖、同一個畫法
#   - 只食 rts_sim 嘅 vq（畫面隊列）；鏡頭外嘅仗唔開 vfx_on，零特效、零成本
#   - 震屏輕微，只喺鏡頭內嘅仗；命中停頓寫入該場 op.hstop（只停嗰場）
#   - 特效數量上限 MAX_FX
extends RefCounted

const FXK = preload("res://game/fxkit/fx_kit.gd")
const VC = preload("res://game/fxkit/vfx_cat.gd")   # [vfx] 序列幀特效目錄
const MAX_FX := 120
const SHAKE_K := 0.35          # 巡陰震屏量 × 0.35（輕微）
const SHAKE_MAX := 3.2

var fx: Array = []
var groups := {}
var ground: Node2D
var top: Node2D
var vr := Rect2()
var shake := 0.0
var _snd_at := 0
var _sty := {}
var _appeared := {}
var _tex := {}
var emit: Callable
static var STATS := {"spawn": 0, "drop": 0, "peak": 0, "kinds": {}}

func _init(g: Node2D, t: Node2D) -> void:
	ground = g; top = t; emit = spr
	PtGfx.init()

func tex(n: String) -> Texture2D:
	if n == "_rad": return PtGfx.RAD_SOFT
	if n.begins_with("vx:"): return VC.tex(n.substr(3))
	if not _tex.has(n): _tex[n] = PtGfx.tex(n)
	return _tex[n]

func spr(n: String, x: float, y: float, o := {}) -> void:
	if fx.size() >= MAX_FX and not o.get("prio", false): STATS.drop += 1; return
	if not vr.has_point(Vector2(x, y)): return
	fx.append(FXK.spr_dict(n, x, y, o)); STATS.spawn += 1
	STATS.kinds[n] = int(STATS.kinds.get(n, 0)) + 1

func glow(x: float, y: float, k: float, a := 0.4) -> void:   # 光照：命中位一團柔光
	spr("_rad", x, y, {"s0": 0.25 * k, "s1": 0.6 * k, "life": 0.22, "alpha": a})

static func _types(k: String) -> Array:
	var R = J.G.get("Rework")
	if R == null: return []
	var ts = J.mc(R, "typesOf", [k])
	return ts if ts is Array else []

# 出手者風格 {sty, hue, k, type}
func sty_of(u: Dictionary) -> Dictionary:
	var key = "%s|%d|%s|%s" % [J.str(u.get("k")), int(J.num(u.get("side", 0))), J.t(u.get("minion")), J.num(u.get("range", 0)) > 60]
	if _sty.has(key): return _sty[key]
	var side1 = J.num(u.get("side", 0)) != 0; var mn = J.t(u.get("minion")); var bo = J.t(u.get("boss"))
	var ts = _types(J.str(u.get("k")))
	var tp = J.str(ts[0]) if ts.size() else ""
	var sty = "slash"
	if J.num(u.get("range", 0)) > 60: sty = "shoot"
	elif mn: sty = "slash"
	elif bo: sty = "smash"
	elif FXK.TYPE_STY.has(tp): sty = FXK.TYPE_STY[tp]
	var hue = FXK.HUE.foe if side1 else (0.0 if mn or tp == "" else float(FXK.TYPE_HUE.get(tp, 0.0)))
	var k = 0.6 if mn else (1.3 if bo else 0.9)
	var o = {"sty": sty, "hue": hue, "k": k, "type": tp, "app": int(FXK.TYPE_APPEAR.get(tp, 1))}
	_sty[key] = o
	return o

func _hy(op, v: Dictionary) -> float: return op.head(v).lerp(v.p, 0.45).y

func _hitstop(op, s: float) -> void: op.hstop = maxf(op.hstop, minf(s, 0.07))
func _shake(v: float) -> void: shake = minf(SHAKE_MAX, maxf(shake, v * SHAKE_K))

# 每格：食該場仗嘅 vq
func consume(op) -> void:
	for e in op.vq:
		match str(e[0]):
			"melee":
				var u: Dictionary = e[1]; var v: Dictionary = e[2]
				var S = sty_of(u)
				var r = FXK.strike(emit, S.sty, u.p, v.p, _hy(op, v), S.hue, S.k)
				if r.shake > 0: _shake(r.shake); _hitstop(op, r.stop)
			"phit":
				var u2: Dictionary = e[1]; var p: Vector2 = e[3]
				var S2 = sty_of(u2)
				spr("fx_fire", p.x, p.y, {"s0": 0.12, "s1": 0.26, "life": 0.18, "hue": S2.hue, "rot": atan2(p.y - (u2.p as Vector2).y, p.x - (u2.p as Vector2).x) + PI})
			"hit":
				var src: Dictionary = e[1]; var v2: Dictionary = e[2]; var big: bool = e[3]; var dead: bool = e[4]
				var hp_ = op.head(v2).lerp(v2.p, 0.45)
				var mn = J.t(v2.get("minion"))
				FXK.spark(emit, hp_.x, hp_.y, 1.35 if big else (0.7 if mn else 0.9), J.num(v2.get("side", 0)) == 0)
				glow(hp_.x, hp_.y, 1.2 if big else 0.8, 0.35)
				if big: _shake(4.0); _hitstop(op, 0.05)
				if Time.get_ticks_msec() - _snd_at > 80: _snd_at = Time.get_ticks_msec(); Snd.play("hit")
				if dead: _down(op, v2, hp_)
			"sk2": sk2(op, e[1], e[2], e[3])
			"cast":
				var cu: Dictionary = e[1]
				if cu.get("p") != null: spr("fx_aura", cu.p.x, cu.p.y + 4, {"ground": true, "s0": 0.15, "s1": 0.32, "life": 0.6, "anchor": 0.5, "sy": 0.5, "hue": sty_of(cu).hue, "prio": true})
			"skill":
				var su: Dictionary = e[1]; var kd: String = e[2]; var tg = e[3]
				if su.get("p") == null: continue
				var S3 = sty_of(su)
				var tp = tg.p if tg is Dictionary else null
				var r3 = FXK.skill(emit, kd, su.p, tp, _hy(op, tg) if tg is Dictionary else 0.0, S3.hue, 1.0)
				if kd == "heal":
					for v3 in op.units:
						if J.num(v3.get("side", 0)) == J.num(su.get("side", 0)) and op.alive(v3):
							spr("fx_heal", v3.p.x, v3.p.y - 30, {"s0": 0.15, "s1": 0.35, "life": 0.8, "vy": 30.0, "spin": 1.5, "prio": true})
							spr("fx_ring", v3.p.x, v3.p.y, {"ground": true, "s0": 0.15, "s1": 0.4, "life": 0.5, "sy": 0.5, "hue": FXK.HUE.yuan})
				else:
					# 嚇法特色：同一隻名鬼嘅大招有自己味道（紙紮碎紙、黑影煙、陰寒鬼火、光柱）
					var at: Vector2 = tp if tp is Vector2 else su.p
					match S3.type:
						"paper": spr("fx2_scraps", at.x, at.y - 30, {"s0": 0.25, "s1": 0.6, "life": 0.85, "add": false, "spin": 5.0, "alpha": 0.95, "prio": true})
						"shadow": spr("fx2_smoke", at.x, at.y - 20, {"s0": 0.2, "s1": 0.7, "life": 0.8, "add": false, "alpha": 0.8, "vy": 20.0, "prio": true})
						"cold": spr("fx2_ghostfire", at.x, at.y - 10, {"s0": 0.12, "s1": 0.32, "life": 0.7, "vy": 50.0, "anchor": 0.9, "alpha": 0.85, "hue": 35.0, "prio": true})
						"light": spr("fx_beam", at.x, at.y + 6, {"s0": 0.35, "s1": 0.5, "sx": 0.7, "life": 0.6, "anchor": 0.95, "fadeIn": true, "hue": S3.hue, "prio": true})
						"sound": spr("fx_scream", at.x, at.y - 40, {"s0": 0.3, "s1": 1.2, "life": 0.5, "alpha": 0.8, "hue": S3.hue, "prio": true})
					if r3.flash > 0: spr("_rad", su.p.x, su.p.y - 30, {"s0": 1.0, "s1": 2.6, "life": 0.35, "alpha": 0.5, "prio": true})
					_shake(r3.shake); _hitstop(op, r3.stop)
				Snd.play("skill")
	op.vq.clear()

# [vfx] 副技／王牌技序列幀：u＝出手者、pe＝技能資料、ts＝目標 [[unit, k], ...]
static var SK2 := {"n": 0, "keys": {}}
func sk2(op, u: Dictionary, pe: Dictionary, ts) -> void:
	if not (u.get("p") is Vector2): return
	var key = VC.key_of(pe, J.str(u.get("k")))
	var E = VC.get_e(key) if key != "" else null
	if E == null: return
	SK2.n += 1; SK2.keys[key] = int(SK2.keys.get(key, 0)) + 1
	var tg = []
	if ts is Array:
		for x in ts:
			var w = x[0] if x is Array and x.size() else null
			if w is Dictionary and w.get("p") is Vector2 and w != u: tg.append(w)
	var at = str(E.get("at", "tgt")); var sc = float(E.get("s", 0.6)); var life = float(E.get("life", 1.0))
	var o = {"grid": VC.GRID, "s0": sc * 0.96, "s1": sc * 1.04, "life": life, "alpha": 1.0, "prio": true, "anchor": float(E.get("anchor", 0.5))}
	var up: Vector2 = u.p
	var n = "vx:" + key
	match at:
		"self": spr(n, up.x, _hy(op, u), o)
		"area", "self_g":
			var o2 = o.duplicate(); o2["anchor"] = 0.62; spr(n, up.x, up.y, o2)
		"tgt_all":
			var i = 0
			for w in (tg if tg.size() else [u]):
				if i >= 4: break
				var o3 = o.duplicate(); o3["t"] = -0.08 * i; spr(n, w.p.x, _hy(op, w), o3); i += 1
		"tgt_g":
			var w2 = tg[0] if tg.size() else u
			spr(n, w2.p.x, w2.p.y, o)
		"line":
			var w3 = tg[0] if tg.size() else null
			var v3: Vector2 = w3.p if w3 != null else up + Vector2(120, 0)
			var o4 = o.duplicate(); o4["flip"] = v3.x < up.x
			spr(n, (up.x + v3.x) * 0.5, (_hy(op, u) + (_hy(op, w3) if w3 != null else _hy(op, u))) * 0.5, o4)
		_:
			var w4 = tg[0] if tg.size() else u
			var o5 = o.duplicate()
			if E.get("dirflip", false): o5["flip"] = (w4.p as Vector2).x < up.x
			spr(n, w4.p.x, _hy(op, w4), o5)
	if key.begins_with("ace_"):
		glow(up.x, up.y - 30, 2.0, 0.35); _shake(4.0)

func _down(op, v: Dictionary, hp_: Vector2) -> void:
	FXK.spark(emit, hp_.x, hp_.y, 1.6, false)
	var p: Vector2 = v.p
	if J.num(v.get("side", 0)) == 1:
		_hitstop(op, 0.06); _shake(5.0)
		if J.t(v.get("boss")):
			spr("fx2_crack", p.x, p.y + 6, {"ground": true, "add": false, "s0": 0.32, "s1": 0.4, "life": 1.6, "alpha": 1.0, "sy": 0.6, "prio": true})
			spr("fx2_pillar", p.x, p.y + 8, {"s0": 0.5, "s1": 0.62, "sx": 0.8, "life": 1.3, "anchor": 0.95, "fadeIn": true, "alpha": 0.9, "prio": true})
		elif not J.t(v.get("minion")):
			spr("fx2_smoke", p.x, p.y - 30, {"s0": 0.2, "s1": 0.5, "life": 0.7, "add": false, "alpha": 0.9})
	else: _shake(3.0)
	FXK.dust(emit, p.x - 12, p.y, 1.2); FXK.dust(emit, p.x + 12, p.y, 1.0)

# 名鬼／大王出場（開打嗰下，鏡頭內先出）
func appear_op(op) -> void:
	if _appeared.has(op.id): return
	_appeared[op.id] = true
	var n = 0
	for u in op.units:
		if J.t(u.get("minion")) or u.get("p") == null or not op.present(u): continue
		if J.num(u.get("side", 0)) == 0 and not J.t(u.get("out")): continue
		var S = sty_of(u)
		var k = 1.2 if J.t(u.get("boss")) else 0.8
		var p: Vector2 = u.p
		FXK.appear(func(nm, x, y, o): o["prio"] = true; spr(nm, x, y, o), p.x, p.y, S.app, k)
		n += 1
	if n: Snd.play("hit")

func tick(dt: float) -> void:
	var keep = []
	for f in fx:
		f.t += dt
		if f.t < f.life: keep.append(f)
	fx = keep
	STATS.peak = maxi(int(STATS.peak), fx.size())
	shake = maxf(0.0, shake - dt * 12.0)
	FXK.sync_groups(fx, groups, ground, top, tex)

func clear() -> void:
	fx.clear(); shake = 0.0
	for k in groups: groups[k].visible = false
