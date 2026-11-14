# 夜班巡陰（原生）：地圖生成——同網頁版 patrol.js 同一套種子、同一個結果
# 地頭佈局、閘口（含暗路）、深坑／斷崖／陰河 WALLS（格仔化 BFS 驗連通）、擺設 PGRID、探索點、小路
class_name PtMap
extends RefCounted

var D: Dictionary            # JS 常數（Patrol._nat）
var ci := 0
var MIR := false
var CW := 800.0
var CH := 700.0
var COLS := 9
var ROWS := 7
var WW := 7200.0
var WH := 4900.0
var GW := 220.0
var TLAY: Array = []
var TLAIR: Array = []
var TMAIN := {}      # 地頭 → 主線關
var TSECRET := {}
var FACI: Array = []  # {t, z, ox, oy, x, y}
var GATES: Array = [] # {i, a, b, za, zb, sec, vert, x, y}
var WALLS: Array = [] # {h, p, a, b, kind, gap:{c, g}|null}
var props: Array = [] # {x, y, t, s, v, r}
var PGRID := {}
var spots: Array = []
var path: PackedVector2Array
var walk_blk: PackedInt32Array
var walk_seen: PackedByteArray
var walk_gw := 0
var walk_gh := 0
const WG := 40.0

func _init(d: Dictionary, chap: int) -> void:
	D = d; ci = chap; MIR = ci % 2 == 1
	CW = float(D.CW); CH = float(D.CH); COLS = int(D.COLS); ROWS = int(D.ROWS); WW = CW * COLS; WH = CH * ROWS; GW = float(D.GW)
	TLAY = D.TLAY; TLAIR = D.TLAIR
	for k in D.TMAIN: TMAIN[int(k)] = int(D.TMAIN[k])
	for k in D.TSECRET: TSECRET[int(k)] = true
	_mk_faci(); _mk_gates(); _mk_walls(); _mk_props(); _mk_spots(); _mk_path()

# ---------------- 基本 ----------------
func mc(c: int) -> int: return COLS - 1 - c if MIR else c
func ter_at(r: int, c: int) -> int: return int(TLAY[r][COLS - 1 - c if MIR else c])
func zone_cell(z: int) -> Vector2i: return Vector2i(z % COLS, z / COLS)   # (c, r)
func zone_center(z: int) -> Vector2:
	var c = zone_cell(z); return Vector2(c.x * CW + CW / 2, c.y * CH + CH / 2)
func zone_at(x: float, y: float) -> int:
	var r = clampi(int(floor(y / CH)), 0, ROWS - 1); var c = clampi(int(floor(x / CW)), 0, COLS - 1); return r * COLS + c
func ter_of(z: int) -> int:
	var c = zone_cell(z); return ter_at(c.y, c.x)
func ter_xy(x: float, y: float) -> int: return ter_of(zone_at(x, y))
func lair(t: int) -> Vector2:
	var rc = TLAIR[t]; return Vector2(mc(int(rc[1])) * CW + CW / 2, int(rc[0]) * CH + CH / 2)
func guard_pos(si: int) -> Vector2:
	for t in TMAIN: if TMAIN[t] == si: return lair(t)
	return Vector2.ZERO

static func seeded(n: int) -> Callable:
	var st = [n * 9301 + 49297]
	return func() -> float:
		st[0] = (st[0] * 9301 + 49297) % 233280
		return float(st[0]) / 233280.0

func _mk_faci() -> void:
	FACI.clear()
	for f in D.FACI0:
		var z = int(f[1]) * COLS + mc(int(f[2])); var ox = -float(f[3]) if MIR else float(f[3])
		var c = zone_center(z)
		FACI.append({"t": String(f[0]), "z": z, "ox": ox, "oy": float(f[4]), "x": c.x + ox, "y": c.y + float(f[4])})

func _mk_gates() -> void:
	GATES.clear()
	var i = 0
	for g in D.TGATE:
		var ca = g[1 + 1]; var cb = g[3]; var ra = int(ca[0]); var rb = int(cb[0]); var xa = mc(int(ca[1])); var xb = mc(int(cb[1]))
		var o = {"i": i, "a": int(g[0]), "b": int(g[1]), "za": ra * COLS + xa, "zb": rb * COLS + xb, "sec": g.size() > 4 and J.t(g[4])}
		if ra == rb: o.vert = true; o.x = maxi(xa, xb) * CW; o.y = ra * CH + CH / 2
		else: o.vert = false; o.x = xa * CW + CW / 2; o.y = maxi(ra, rb) * CH
		GATES.append(o); i += 1

func key_pts() -> Array:
	var out = []
	for f in FACI: out.append(Vector2(f.x, f.y))
	for t in 9: out.append(lair(t))
	for g in GATES:
		if g.vert: out.append(Vector2(g.x - 60, g.y)); out.append(Vector2(g.x + 60, g.y))
		else: out.append(Vector2(g.x, g.y - 60)); out.append(Vector2(g.x, g.y + 60))
	return out

static func seg_d(w: Dictionary, x: float, y: float) -> float:
	var along = x if w.h else y; var across = y if w.h else x
	var t = clampf(along, w.a, w.b)
	return Vector2(along - t, across - w.p).length()

func blocked_at(x: float, y: float, m := 50.0) -> bool:
	for w in WALLS:
		if seg_d(w, x, y) > m: continue
		if w.gap != null and absf((x if w.h else y) - w.gap.c) < GW / 2: continue
		return true
	return false

# ---------------- 地形 ----------------
func _gate_on(h: bool, p: float, a: float, b: float):
	for g in GATES:
		if h and not g.vert and g.y == p and g.x > a and g.x < b: return g
		if not h and g.vert and g.x == p and g.y > a and g.y < b: return g
	return null

func _mk_walls() -> void:
	WALLS.clear()
	for r in ROWS:
		for c in COLS:
			if c < COLS - 1 and ter_at(r, c) != ter_at(r, c + 1):
				var p = (c + 1) * CW; var a = r * CH; var b = (r + 1) * CH; var g = _gate_on(false, p, a, b)
				WALLS.append({"h": false, "p": p, "a": a, "b": b, "kind": "border", "gap": {"c": g.y, "g": g} if g else null})
			if r < ROWS - 1 and ter_at(r, c) != ter_at(r + 1, c):
				var p2 = (r + 1) * CH; var a2 = c * CW; var b2 = (c + 1) * CW; var g2 = _gate_on(true, p2, a2, b2)
				WALLS.append({"h": true, "p": p2, "a": a2, "b": b2, "kind": "border", "gap": {"c": g2.x, "g": g2} if g2 else null})
	var rnd = seeded(ci * 57 + 11); var kp = key_pts(); var inner = []
	var kind = "river" if ci == 3 or ci == 1 else "ravine"
	var N = COLS * ROWS; var n = 0
	while n < N * 2.4:
		var z = n % N
		if rnd.call() < (0.1 if n < N else 0.45): n += 1; continue
		var cell = zone_cell(z); var h = rnd.call() < 0.5; var Lw = (0.42 + rnd.call() * 0.18) * (CW if h else CH); var off = 0.3 + rnd.call() * 0.4; var from_lo = rnd.call() < 0.5
		var w: Dictionary
		if h: w = {"h": true, "p": cell.y * CH + CH * off, "a": cell.x * CW if from_lo else (cell.x + 1) * CW - Lw, "b": cell.x * CW + Lw if from_lo else (cell.x + 1) * CW, "kind": kind, "gap": null}
		else: w = {"h": false, "p": cell.x * CW + CW * off, "a": cell.y * CH if from_lo else (cell.y + 1) * CH - Lw, "b": cell.y * CH + Lw if from_lo else (cell.y + 1) * CH, "kind": kind, "gap": null}
		var bad = false
		for q in kp: if seg_d(w, q.x, q.y) < 150: bad = true; break
		if not bad:
			for o in inner: if o.h == w.h and absf(o.p - w.p) < 160 and o.a < w.b and w.a < o.b: bad = true; break
		if not bad: inner.append(w)
		n += 1
	# 連通：格仔化 BFS
	walk_gw = int(ceil(WW / WG)); walk_gh = int(ceil(WH / WG))
	walk_blk = PackedInt32Array(); walk_blk.resize(walk_gw * walk_gh)
	for w in WALLS: _paint(w, 1)
	var s0 = Vector2(FACI[0].x, FACI[0].y); var start = int(s0.y / WG) * walk_gw + int(s0.x / WG)
	var kc = []
	for p in kp: kc.append(int(p.y / WG) * walk_gw + int(p.x / WG))
	for w in inner:
		_paint(w, 1)
		if _bfs(start, kc): WALLS.append(w)
		else: _paint(w, -1)
	_bfs(start, kc)

func _paint(w: Dictionary, v: int) -> void:
	var x0 = (w.a - 20) if w.h else (w.p - 20); var x1 = (w.b + 20) if w.h else (w.p + 20)
	var y0 = (w.p - 20) if w.h else (w.a - 20); var y1 = (w.p + 20) if w.h else (w.b + 20)
	for j in range(maxi(0, int(floor(y0 / WG))), mini(walk_gh - 1, int(floor(y1 / WG))) + 1):
		for i in range(maxi(0, int(floor(x0 / WG))), mini(walk_gw - 1, int(floor(x1 / WG))) + 1):
			var x = i * WG + WG / 2; var y = j * WG + WG / 2
			if seg_d(w, x, y) >= 18: continue
			if w.gap != null and absf((x if w.h else y) - w.gap.c) < GW / 2 - 14: continue
			walk_blk[j * walk_gw + i] += v

func _bfs(start: int, kc: Array) -> bool:
	var n = walk_gw * walk_gh
	walk_seen = PackedByteArray(); walk_seen.resize(n)
	var q = PackedInt32Array(); q.resize(n); var h = 0; var t = 0
	q[t] = start; t += 1; walk_seen[start] = 1
	var gw = walk_gw
	while h < t:
		var k = q[h]; h += 1
		var i = k % gw; var j = k / gw
		if i > 0 and walk_seen[k - 1] == 0 and walk_blk[k - 1] == 0: walk_seen[k - 1] = 1; q[t] = k - 1; t += 1
		if i < gw - 1 and walk_seen[k + 1] == 0 and walk_blk[k + 1] == 0: walk_seen[k + 1] = 1; q[t] = k + 1; t += 1
		if j > 0 and walk_seen[k - gw] == 0 and walk_blk[k - gw] == 0: walk_seen[k - gw] = 1; q[t] = k - gw; t += 1
		if j < walk_gh - 1 and walk_seen[k + gw] == 0 and walk_blk[k + gw] == 0: walk_seen[k + gw] = 1; q[t] = k + gw; t += 1
	for k in kc: if walk_seen[k] == 0: return false
	return true

# ---------------- 擺設 ----------------
func _mk_props() -> void:
	PGRID = {}; props = []
	var rnd = seeded(ci * 31 + 3); var rg = D.REG[ci]; var plist: Array = rg.props; var SOLID: Dictionary = D.SOLID
	var avoid = []
	for f in FACI: avoid.append(Vector2(f.x, f.y))
	for f in FACI: if f.t == "station": avoid.append(Vector2(f.x + 60, f.y + 60))
	for g in GATES: avoid.append(Vector2(g.x, g.y))
	for t in 9: avoid.append(lair(t))
	var i = 0
	while i < 3200 and props.size() < 1350:
		i += 1
		var x = 40 + rnd.call() * (WW - 80); var y = 40 + rnd.call() * (WH - 80); var t = String(plist[int(floor(rnd.call() * plist.size()))]); var sc = 0.75 + rnd.call() * 0.5
		var big = SOLID.has(t)
		var bad = false
		for a in avoid: if a.distance_to(Vector2(x, y)) < (190.0 if big else 150.0): bad = true; break
		if bad: continue
		if blocked_at(x, y, 80.0 if big else 56.0): continue
		for o in props:
			if Vector2(o.x - x, (o.y - y) * 1.4).length() < (120.0 if (o.r > 0 or big) else 70.0): bad = true; break
		if bad: continue
		props.append({"x": x, "y": y, "t": t, "s": sc, "v": rnd.call(), "r": float(SOLID[t]) * sc if big else 0.0})
	for o in props:
		if o.r <= 0: continue
		var k = Vector2i(int(floor(o.x / 200)), int(floor(o.y / 200)))
		if not PGRID.has(k): PGRID[k] = []
		PGRID[k].append(o)

# ---------------- 探索點 ----------------
func cells_of(t: int) -> Array:
	var a = []
	for z in COLS * ROWS: if ter_of(z) == t: a.append(z)
	return a

func _mk_spots() -> void:
	spots = []
	var rnd = seeded(ci * 97 + 7); var kp = key_pts(); var gw = walk_gw
	var ok_at = func(x: float, y: float, near: float) -> bool:
		var i = int(floor(x / WG)); var j = int(floor(y / WG))
		if i < 1 or j < 1 or i >= gw - 1 or j >= walk_gh - 1: return false
		for b in range(-2, 3):
			for a in range(-2, 3):
				var k = (j + b) * gw + i + a
				if walk_blk[k] != 0 or walk_seen[k] == 0: return false
		for q in kp: if q.distance_to(Vector2(x, y)) < 230: return false
		for o in spots: if Vector2(o.x - x, o.y - y).length() < near: return false
		var l = PGRID.get(Vector2i(int(floor(x / 200)), int(floor(y / 200))))
		if l: for o in l: if Vector2(o.x - x, o.y - y).length() < o.r + 50: return false
		return true
	var pick = func(cells: Array, near: float):
		for n in 120:
			var z = cells[int(floor(rnd.call() * cells.size()))]; var c = zone_center(z)
			var x = c.x + (rnd.call() - 0.5) * (CW - 120); var y = c.y + (rnd.call() - 0.5) * (CH - 120)
			if ok_at.call(x, y, near): return Vector2(x, y)
		return null
	var li = 0; var LMN: Array = D.LM_N; var names: Array = D.LMNAME[ci]
	for t in 9:
		var cells = cells_of(t)
		for n in int(LMN[t]):
			var q = pick.call(cells, 420.0)
			if q != null: spots.append({"k": "lm", "id": li, "t": t, "x": q.x, "y": q.y, "name": String(names[li])})
			li += 1
	var all = []; var sec = []
	for t in 9:
		for z in cells_of(t):
			all.append(z)
			if TSECRET.has(t): sec.append(z)
	for n in 16:
		var q = pick.call(sec if n < 6 else all, 300.0)
		if q != null: spots.append({"k": "ca", "id": n, "t": ter_xy(q.x, q.y), "x": q.x, "y": q.y})
	var pgs = J.cl(D.pageGhosts, null, [float(ci)])
	var n2 = 0
	for gk in pgs:
		var q = pick.call(sec if n2 % 2 == 1 else all, 360.0)
		if q != null: spots.append({"k": "pg", "id": n2, "gk": String(gk), "t": ter_xy(q.x, q.y), "x": q.x, "y": q.y})
		n2 += 1

# ---------------- 小路 ----------------
func _mk_path() -> void:
	var rnd = seeded(ci * 13 + 5)
	var nb = func(z: int) -> Array:
		var c = zone_cell(z); var out = []
		for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var cc = c.x + d.x; var rr = c.y + d.y
			if rr < 0 or cc < 0 or rr >= ROWS or cc >= COLS: continue
			var z2 = rr * COLS + cc
			if ter_of(z) == ter_of(z2): out.append([z2, null])
			else:
				for g in GATES:
					if not g.sec and ((g.za == z and g.zb == z2) or (g.zb == z and g.za == z2)): out.append([z2, g]); break
		return out
	var route = func(a: int, b: int) -> Array:
		var prev = {a: [-1, null]}; var q = [a]
		while q.size():
			var z = q.pop_front()
			if z == b: break
			for e in nb.call(z):
				if not prev.has(e[0]): prev[e[0]] = [z, e[1]]; q.append(e[0])
		var out = []; var z = b
		while z != a and prev.has(z): out.push_front([z, prev[z][1]]); z = prev[z][0]
		return out
	var pts = PackedVector2Array(); pts.append(Vector2(FACI[0].x + 60, FACI[0].y - 40)); var cur = FACI[0].z
	# 注意：網頁版喺每個非終點格都會抽兩次隨機數，次序要一樣
	for t in [0, 1, 3, 4, 5]:
		var lp = lair(t); var zt = zone_at(lp.x, lp.y)
		for e in route.call(cur, zt):
			if e[1] != null: pts.append(Vector2(e[1].x, e[1].y))
			var c = zone_center(e[0])
			if e[0] != zt: pts.append(Vector2(c.x + (rnd.call() - 0.5) * 200, c.y + (rnd.call() - 0.5) * 180))
		pts.append(Vector2(lp.x, lp.y + 120)); cur = zt
	path = pts
