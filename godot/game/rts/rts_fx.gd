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
var loops: Array = []            # [vfx 第三批] 今格狀態循環（每格重建，唔佔 MAX_FX）
var _stc := {}                   # 狀態快取 {unit id: [t, [keys]]}（每 0.25 秒先重算）
var _lt := 0.0
const AHm = preload("res://game/rts/ab_hud.gd")
const ST_MAX_SHOW := 2           # 每隻最多疊 2 個狀態循環（控場／負面優先）
const ST_PER := 1.0              # 循環一次 1 秒
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
	if op.result is Dictionary and J.t(op.result.get("win")) and not op.has_meta("j_slow") and JU().on():   # [juice] 贏咗（最後一擊唔經 hit 都計）：終結慢鏡
		op.set_meta("j_slow", true); JU().vib(40); JU().slowmo(0.4, 0.55)
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
				var crit: bool = e.size() > 5 and bool(e[5])
				if crit and JU().on():   # [juice] 暴擊：大光、重震、停頓長啲、專屬聲
					glow(hp_.x, hp_.y, 1.8, 0.55); _shake(9.0); _hitstop(op, 0.07)
					if Time.get_ticks_msec() - _snd_at > 60: _snd_at = Time.get_ticks_msec(); Snd.play("crit")
				elif big: _shake(4.0); _hitstop(op, 0.05)
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
	status_loops(op)

# [vfx 第三批] 狀態循環：每隻單位揀最重要 2 個有圖嘅狀態，疊喺身上（按 pos 放頭頂／嘴前／身中／腳底／背後）
static func st_keys(op, u: Dictionary) -> Array:
	var o = []
	for e in AHm.effects(op, u): o.append(str(e.k))
	var s0 = AHm.status(op, u)
	if s0.get("daze", false): o.push_front("st_daze")
	if J.num(s0.get("shield", 0)) > 0.5: o.append("st_shield")
	if s0.get("stealth", false): o.append("st_stealth")
	var r = []
	for k in o:
		if r.size() >= ST_MAX_SHOW: break
		if not r.has(k) and VC.st_e(k) != null: r.append(k)
	return r
func status_loops(op) -> void:
	for j in op.units.size():
		var u: Dictionary = op.units[j]
		if J.num(u.get("hp", 0)) <= 0 or not (u.get("p") is Vector2): continue
		if not vr.has_point(u.p): continue
		var id = int(op.id) * 1000 + j
		var c = _stc.get(id)
		if c == null or _lt - float(c[0]) > 0.25:
			c = [_lt, st_keys(op, u)]; _stc[id] = c
		st_draw(c[1], u.p, op.head(u), id)
# 一隻單位嘅狀態循環（ks＝狀態鍵、p＝腳、hd＝頭、id＝錯開相位）；vfx_test 直接用嚟出樣本
func st_draw(ks: Array, p: Vector2, hd: Vector2, id: int) -> void:
	for i in ks.size():
		var E = VC.st_e(ks[i])
		if E == null: continue
		var pos = str(E.get("pos", "body"))
		var at: Vector2 = p
		match pos:
			"head": at = hd + Vector2(0, -8)
			"mouth": at = hd.lerp(p, 0.18)
			"body", "back": at = hd.lerp(p, 0.5)
		var sc = float(E.get("s", VC.ST_POS_S.get(pos, 0.24)))
		at.y += float(E.get("dy", 0.0))
		var fi = int(floor((_lt + float(id % 97) * 0.13) / float(E.get("per", ST_PER)) * 16.0))
		var f = FXK.spr_dict("vx:" + str(E.get("sheet", ks[i])), at.x, at.y, {"grid": VC.GRID, "fi": fi, "s0": sc, "s1": sc, "life": 1.0, "t": 0.0, "alpha": 0.95 if i == 0 else 0.8, "gain": float(E.get("gain", 1.7)), "ground": pos in ["feet", "back"], "anchor": 0.5})
		loops.append(f)

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
		"area":
			var o2 = o.duplicate(); o2["anchor"] = 0.62; spr(n, up.x, up.y, o2)
		"self_g": spr(n, up.x, up.y, o)   # [第二批] 自己腳底（anchor＝圖入面腳嘅位置）
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
		"tgt_h", "circ", "self_circ", "cone", "beam", "chain":
			sk2_shape(op, u, pe, E, tg, at, o, n)
		_:
			var w4 = tg[0] if tg.size() else u
			var o5 = o.duplicate()
			if E.get("dirflip", false): o5["flip"] = (w4.p as Vector2).x < up.x
			spr(n, w4.p.x, _hy(op, w4), o5)
	if E.has("ring"): ring_of(op, u, pe, E, o)
	if key.begins_with("ace_"):
		glow(up.x, up.y - 30, 2.0, 0.35); _shake(4.0)

# [vfx 修正一] 第一批群攻／加持補地面範圍圈：自己為圓心，半徑＝技能 tg.r（唔改原圖，另疊一張俯視圈）
#   目錄 ring＝圈序列幀鍵、ring_rr＝圈圖半徑（px，每格 256、s=1）、ring_ar＝橫／直
static func ring_geom(u: Dictionary, pe: Dictionary, E: Dictionary) -> Dictionary:
	var T = pe.get("tg") if pe.get("tg") is Dictionary else {}
	return {"c": u.p, "r": J.num(T.get("r", E.get("ring_r", 120)))}
func ring_of(op, u: Dictionary, pe: Dictionary, E: Dictionary, o: Dictionary) -> void:
	if VC.tex(str(E.ring)) == null: return   # 冇圖唔播
	var G = ring_geom(u, pe, E)
	var s = J.num(G.r) / float(E.get("ring_rr", 100)); var c: Vector2 = G.c
	var o2 = o.duplicate(); o2.merge({"ground": true, "anchor": 0.5, "s0": s * 0.97, "s1": s, "sy": float(E.get("ring_ar", 1.0)), "alpha": float(E.get("ring_a", 0.85)), "life": float(E.get("ring_life", E.get("life", 1.0)))}, true)
	spr("vx:" + str(E.ring), c.x, c.y, o2)

# [vfx 第二批] 群攻範圍形狀：大小由技能實際 tg（r／len／w／deg）計，唔靠估
#   circ＝敵人最密嗰度圓心半徑 r｜self_circ＝自己為圓心半徑 r（隊友加持）＋每個隊友腳底細印｜cone＝自己為尖、向目標扇形
#   beam＝由自己出發一條直線 len｜chain＝每個目標各一下＋目標之間連線｜tgt_h＝目標頭（封口）
#   目錄（vfx_cat）入面：rr＝圖入面圈半徑（px，每格 256、s=1）；ar＝圖橫半徑／直半徑（壓返做正圓）；
#   ax＝扇形尖／直線頭喺格心左邊幾多 px；ra＝扇形尖到弧邊 px；bl＝直線圖長 px；bw＝直線圖粗 px
static func sk2_geom(op, u: Dictionary, pe: Dictionary, E: Dictionary, tg: Array) -> Dictionary:
	var at = str(E.get("at", "tgt")); var T = pe.get("tg") if pe.get("tg") is Dictionary else {}
	var up: Vector2 = u.p
	var g = {"at": at}
	match at:
		"circ", "self_circ":
			var r = J.num(T.get("r", 90)); g["r"] = r
			g["c"] = up if at == "self_circ" else aoe_center(tg, r, up)
		"cone", "beam":
			var d = _dir_to(u, tg); g["dir"] = d; g["o"] = up
			if at == "cone": g["r"] = J.num(T.get("r", 140)); g["deg"] = J.num(T.get("deg", 80))
			else: g["len"] = J.num(T.get("len", 260)); g["w"] = J.num(T.get("w", 44))
	return g
static func aoe_center(tg: Array, r: float, fb: Vector2) -> Vector2:   # 圓心＝目標入面同其他全部距離 ≤ r、總距離最細嗰隻（同 abil select dense 一致）
	if tg.is_empty(): return fb
	var best = tg[0]; var bs = INF
	for w in tg:
		var ok = true; var sm = 0.0
		for w2 in tg:
			var d = (w.p as Vector2).distance_to(w2.p); sm += d
			if d > r + 0.5: ok = false
		if ok and sm < bs: bs = sm; best = w
	return best.p
static func _dir_to(u: Dictionary, tg: Array) -> Vector2:
	var up: Vector2 = u.p; var cur = u.get("tg")
	if cur is Dictionary and tg.has(cur): return ((cur.p as Vector2) - up).normalized()
	var bn = INF; var d = Vector2.RIGHT if J.num(u.get("side", 0)) == 0 else Vector2.LEFT
	for w in tg:
		var dd = up.distance_to(w.p)
		if dd < bn and dd > 0.5: bn = dd; d = ((w.p as Vector2) - up).normalized()
	return d

func sk2_shape(op, u: Dictionary, pe: Dictionary, E: Dictionary, tg: Array, at: String, o: Dictionary, n: String) -> void:
	var G = sk2_geom(op, u, pe, E, tg)
	var life = float(E.get("life", 1.0))
	match at:
		"tgt_h":
			var w = tg[0] if tg.size() else u
			var hp: Vector2 = op.head(w)
			spr(n, hp.x, hp.y + 10, o)
		"circ", "self_circ":
			var s = J.num(G.r) / float(E.get("rr", 110)); var c: Vector2 = G.c
			var o2 = o.duplicate(); o2.merge({"ground": true, "anchor": 0.5, "s0": s * 0.97, "s1": s, "sy": float(E.get("ar", 1.0)), "alpha": float(E.get("alpha", 1.0))}, true)
			spr(n, c.x, c.y, o2)
			if at == "self_circ":   # 隊友加持：每個受惠隊友腳底一個細印（同一張圖縮細）
				var i = 0
				for w in tg:
					if i >= 6: break
					var o3 = o.duplicate(); o3.merge({"ground": true, "anchor": 0.5, "s0": 0.16, "s1": 0.2, "sy": float(E.get("ar", 1.0)) * 0.6, "t": -0.12 - 0.04 * i, "life": life * 0.8}, true)
					spr(n, w.p.x, w.p.y, o3); i += 1
		"cone":
			var s2 = J.num(G.r) / float(E.get("ra", 200)); var d: Vector2 = G.dir
			var c2: Vector2 = (u.p as Vector2) - d * float(E.get("ax", -100)) * s2
			var o4 = o.duplicate(); o4.merge({"ground": true, "anchor": 0.5, "s0": s2, "s1": s2, "rot": d.angle(), "sy": tan(deg_to_rad(J.num(G.deg) * 0.5)) / tan(deg_to_rad(float(E.get("deg_art", G.deg)) * 0.5))}, true)
			spr(n, c2.x, c2.y, o4)
		"beam":
			var s3 = J.num(G.len) / float(E.get("bl", 220)); var d3: Vector2 = G.dir
			var c3: Vector2 = (u.p as Vector2) - d3 * float(E.get("ax", -110)) * s3
			var o5 = o.duplicate(); o5.merge({"ground": true, "anchor": 0.5, "s0": s3, "s1": s3, "rot": d3.angle(), "sy": clampf(J.num(G.w) / (float(E.get("bw", 40)) * s3), 0.3, 1.6)}, true)
			spr(n, c3.x, c3.y, o5)
		"chain":
			var pts = [Vector2(u.p.x, _hy(op, u))]
			for w in tg: pts.append(Vector2(w.p.x, _hy(op, w)))
			var ls = float(E.get("ls", 0.4)); var bl = float(E.get("bl", 220))
			for i in range(1, pts.size()):
				var a: Vector2 = pts[i - 1]; var b: Vector2 = pts[i]; var L = a.distance_to(b)
				var dly = -0.1 * (i - 1)
				if L > 8.0:
					var ol = o.duplicate(); ol.merge({"anchor": 0.5, "s0": ls, "s1": ls, "sx": L / (bl * ls), "rot": (b - a).angle(), "t": dly, "life": life * 0.7}, true)
					spr("vx:" + str(E.get("link", n.substr(3) + "_l")), (a.x + b.x) * 0.5, (a.y + b.y) * 0.5, ol)
				var oi = o.duplicate(); oi.merge({"t": dly - 0.06}, true)
				spr(n, b.x, b.y, oi)

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
	if J.num(v.get("side", 0)) == 1 and JU().on(): _juice_kill(op, v, p)

# [juice] 敵人倒下：化灰＋魂火升天；連殺數；最後一隻＝終結慢鏡；打低王＝震機
static func JU(): return load("res://ui/juice.gd")
func _juice_kill(op, v: Dictionary, p: Vector2) -> void:
	var mn = J.t(v.get("minion"))
	spr("fx2_smoke", p.x, p.y - 18, {"s0": 0.12 if mn else 0.2, "s1": 0.32 if mn else 0.55, "life": 0.8, "add": false, "alpha": 0.55, "vy": 18.0, "hue": 0.0})   # 化灰
	spr("fx2_ghostfire", p.x, p.y - 24, {"s0": 0.08 if mn else 0.14, "s1": 0.18 if mn else 0.3, "life": 0.9, "vy": 70.0, "anchor": 0.9, "alpha": 0.85, "hue": 190.0})   # 魂火升天
	var now = float(op.T)
	var n = int(op.get_meta("ks_n", 0)) + 1 if now - float(op.get_meta("ks_t", -9.0)) < 2.2 else 1
	op.set_meta("ks_n", n); op.set_meta("ks_t", now); op.set_meta("ks_max", maxi(n, int(op.get_meta("ks_max", 0))))
	if n >= 3:
		op.text(op.center() + Vector2(0, -112), "%d 連殺！" % n, "#ffcf4a" if n < 8 else "#ff6a3a", 1.0, mini(30, 16 + n))
		Snd.play("combo", n)
	var last = op.foes_alive() == 0
	if J.t(v.get("boss")):
		JU().vib(90); JU().slowmo(0.3, 0.9)
		op.text(op.center() + Vector2(0, -140), "擊破！", "#ff5a3a", 1.4, 30)
	elif last and not op.has_meta("j_slow"):
		op.set_meta("j_slow", true); JU().vib(40); JU().slowmo(0.4, 0.55)

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
		if J.t(u.get("boss")) and J.num(u.get("side", 0)) == 1 and JU().on():   # [juice] 王登場演出
			_shake(9.0); JU().boss_intro(J.str(u.get("name", "")), J.str(u.get("k", ""))); JU().vib(60)
	if n: Snd.play("hit")

func tick(dt: float) -> void:
	var keep = []
	for f in fx:
		f.t += dt
		if f.t < f.life: keep.append(f)
	fx = keep
	STATS.peak = maxi(int(STATS.peak), fx.size())
	shake = maxf(0.0, shake - dt * 12.0)
	_lt += dt
	if _stc.size() > 400: _stc.clear()
	FXK.sync_groups(fx + loops if loops.size() else fx, groups, ground, top, tex)
	loops.clear()

func clear() -> void:
	fx.clear(); loops.clear(); shake = 0.0
	for k in groups: groups[k].visible = false
