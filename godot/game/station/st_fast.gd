# 陽間站崗・熱點小函數原生版（直接換入 Turf 物件，邏輯同 street.js 一模一樣）
#  wp／wseg／alive／rect／rdist／dist／P／runPos：每幀叫幾千次（tick 同 draw 都用），轉譯版每次 ~70µs
class_name StFast
extends RefCounted

const CELL := 150.0 / 2160.0

static func n(v) -> float:
	if v is float: return v
	if v is int: return float(v)
	return J.num(v)

static func install(tf: Dictionary) -> void:
	tf["wp"] = func(th, a): return wp(th, a[0], a[1] if a.size() > 1 else null)
	tf["wseg"] = func(th, a): return wseg(a[0])
	tf["alive"] = func(th, a): return alive(a[0])
	tf["rect"] = func(th, a): return rect(a[0])
	tf["rdist"] = func(th, a): return rdist(a[0], a[1])
	tf["dist"] = func(th, a): return dist(a[0], a[1])
	tf["runPos"] = func(th, a): return run_pos(a[0])
	tf["P"] = func(th, a):
		var b = th.box
		return [n(b.x) + n(a[0]) * n(b.w), n(b.y) + n(a[1]) * n(b.h)]

static func wp(th: Dictionary, w: Dictionary, dt):
	if J.str(w.get("gone")) == "run" and J.t(w.get("runPath")): return run_pos(w)
	var t = n(w.get("t", 0)) + (n(dt) if J.t(dt) else 0.0)
	var S2 = w.get("segs"); if not J.t(S2): S2 = th.get("segs")
	var segs: Array = S2
	for g in segs:
		var gs = n(g.s); var gd = n(g.d)
		if t <= gs + gd:
			var k = maxf(0.0, (t - gs) / gd)
			var ax = n(g.ax); var ay = n(g.ay)
			return [ax + (n(g.bx) - ax) * k, ay + (n(g.by) - ay) * k]
	var z = segs[segs.size() - 1]
	return [n(z.bx), n(z.by)]

static func wseg(w: Dictionary):
	var t = maxf(0.0, n(w.get("t", 0)))
	var segs: Array = w.segs
	for g in segs:
		if t <= n(g.s) + n(g.d): return g
	return segs[segs.size() - 1]

static func alive(w: Dictionary) -> bool:
	return not J.t(w.get("gone")) and n(w.get("t", 0)) > 0 and not J.t(wseg(w).get("hide"))

static func rect(spot: Dictionary) -> Array:
	var s2 = n(spot.get("s", 0)) == 2.0; var d = J.t(spot.get("d"))
	var w = CELL * (2.0 if s2 and not d else 1.0); var h = CELL * (2.0 if s2 and d else 1.0) / 1.5
	var x = n(spot.x); var y = n(spot.y)
	return [x - w / 2, y - h / 2, x + w / 2, y + h / 2]

static func rdist(pt, spot: Dictionary) -> float:
	var r = rect(spot); var px = n(pt[0]); var py = n(pt[1])
	var dx = maxf(maxf(r[0] - px, 0.0), px - r[2]); var dy = maxf(maxf(r[1] - py, 0.0), py - r[3])
	return Vector2(dx, dy * 1.5).length()

static func dist(a, b) -> float:
	return Vector2(n(a[0]) - n(b[0]), (n(a[1]) - n(b[1])) * 1.5).length()

static func run_pos(w: Dictionary):
	var P0: Array = w.runPath
	var left = minf(n(w.runT), 1.5) * n(w.spd) * 1.8
	for i in P0.size() - 1:
		var d = dist(P0[i], P0[i + 1])
		if left <= d:
			var k = left / d
			return [n(P0[i][0]) + (n(P0[i + 1][0]) - n(P0[i][0])) * k, n(P0[i][1]) + (n(P0[i + 1][1]) - n(P0[i][1])) * k]
		left -= d
	var z = P0[P0.size() - 1]
	return [n(z[0]), n(z[1])]
