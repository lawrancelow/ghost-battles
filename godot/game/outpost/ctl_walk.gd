# [ctl] 主角全圖可走：村、大排檔、野外、已佔領資源區（zone_walk.route／region 掛鈎入嚟）
#   區域樹：village（根）→ 已佔領資源區（經門洞 door.in ↔ door.out）
#                       → 大排檔 market（經出村門：沿挑夫路 market.porter，已知唔撞柵欄／溝／圍欄）
#                            → 野外區 wild（經野外門：門中心上下 70px，穿木樁缺口／橋）
#   黑霧：未解霧（ZD.revealed＝false）嘅大排檔／野外區、未佔領資源區 → 唔入，停喺最近可以企嘅區邊（擋在黑霧邊）。
#   全部 static；冇 class_name、冇 autoload。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const INSET := 22.0
static var enabled := true

static func _dir_v2m() -> Vector2:   # 村子 → 大排檔方向（gate_side）
	match str(ZD.cur().get("gate_side", "N")):
		"S": return Vector2(0, 1)
		"E": return Vector2(1, 0)
		"W": return Vector2(-1, 0)
	return Vector2(0, -1)
static func gate_of(zid: String) -> Array:   # [門中心, dir（1＝野外喺上面）]（同 zone_taunt.gate_of）
	var z = ZD.zone(zid)
	var r = ZD.rect(z.rect); var g = z.get("gate", {})
	var dir = float(g.get("dir", 1))
	var gy = float(g.get("y", r.end.y + 10.0 if dir > 0 else r.position.y - 10.0))
	return [Vector2(float(g.get("x", r.get_center().x)), gy), dir]

# 出村門走廊（村子同大排檔之間嗰條罅）：當村子
static func _vgate_rect() -> Rect2:
	var pts = _porter()
	if pts.size() < 2: return Rect2()
	var r = Rect2(pts[0], Vector2.ZERO)
	for p in pts: r = r.expand(p)
	return r.grow(26)
static func _porter() -> Array:
	var o = []
	var m = ZD.cur().get("market", {})
	for q in m.get("porter", []): o.append(Vector2(float(q[0]), float(q[1])))
	return o
static func _wgate_rect(zid: String) -> Rect2:
	var g = gate_of(zid); var c: Vector2 = g[0]
	var r = Rect2(c.x - 26, c.y - 40, 52, 80)
	var wr = ZD.zrect(zid); var mr = ZD.zrect("market")   # 由野外區邊一直去到大排檔邊（中間有河／橋都計）
	var y0 = wr.end.y if float(g[1]) > 0 else mr.end.y
	var y1 = mr.position.y if float(g[1]) > 0 else wr.position.y
	if y1 > y0: r = r.merge(Rect2(c.x - 26, y0 - 2, 52, y1 - y0 + 4))
	return r

static func _open(zid: String) -> bool:
	if zid.begins_with("x_"): return true   # [dirs4] 出路小路
	if zid.begins_with("rg_"):   # [dirs4] 圈帶：經野外區出口嘅方向要野外區已散霧
		var e = _ex(zid.substr(3))
		return not e.is_empty() and (str(e.kind) != "wild" or _open(str(e.wz)))
	var z = ZD.zone(zid)
	if z.is_empty(): return false
	match str(z.get("type")):
		"village": return true
		"res": return ZD.owned(zid)
		"market", "wild": return ZD.revealed(zid)
	return false
static func _parent(zid: String) -> String:
	if zid.begins_with("x_"): return "village"   # [dirs4]
	if zid.begins_with("rg_"):
		var e = _ex(zid.substr(3))
		return ("x_" + str(e.dir)) if str(e.get("kind")) == "path" else str(e.get("wz", "village"))
	match str(ZD.zone(zid).get("type")):
		"res", "market": return "village"
		"wild": return "market"
	return ""

# 阿福可以企嘅區（"" ＝ 企唔到）
static func region(p: Vector2) -> String:
	var xr = _dirs_region(p)   # [dirs4] 出路小路／已散霧圈帶
	if xr != "": return xr if _open(xr) else ""
	for z in ZD.of_type("res"):
		if z.get("door") is Dictionary and ZD.rect(z.door.rect).grow(4).has_point(p): return "village"
	var zid = ZD.zone_at(p)
	if zid != "":
		if str(ZD.zone(zid).type) == "village": return "village"
		return zid if _open(zid) else ""
	if _open("market") and _vgate_rect().has_point(p): return "village"
	for z in ZD.of_type("wild"):
		if _open(str(z.id)) and _wgate_rect(str(z.id)).has_point(p): return "market"
	return ""
static func _clamp_in(zid: String, p: Vector2) -> Vector2:
	if zid.begins_with("x_") or zid.begins_with("rg_"): return _dirs_clamp(zid, p)   # [dirs4]
	var r = ZD.zrect(zid).grow(-INSET)
	return Vector2(clampf(p.x, r.position.x, r.end.x), clampf(p.y, r.position.y + 10.0, r.end.y))
static func _regions() -> Array:
	var o = []
	for z in ZD.zones(): if _open(str(z.id)): o.append(str(z.id))
	return o
static func _near_region(p: Vector2) -> String:
	var best = "village"; var bd = INF
	for zid in _regions():
		var r = ZD.zrect(zid)
		var q = Vector2(clampf(p.x, r.position.x, r.end.x), clampf(p.y, r.position.y, r.end.y))
		if q.distance_to(p) < bd: bd = q.distance_to(p); best = zid
	return best
static func _chain(zid: String) -> Array:   # [zid, 父, …, village]
	var o = [zid]
	var k = 0
	while o[o.size() - 1] != "village" and k < 6:
		var pa = _parent(o[o.size() - 1])
		if pa == "": break
		o.append(pa); k += 1
	return o
# 由 a 區去隔籬嘅 b 區（a、b 一定係父子）要經嘅路點
static func _hop(a: String, b: String) -> Array:
	if a.begins_with("x_") or b.begins_with("x_") or a.begins_with("rg_") or b.begins_with("rg_"): return _dirs_hop(a, b)   # [dirs4]
	var ta = str(ZD.zone(a).get("type")); var tb = str(ZD.zone(b).get("type"))
	if ta == "res" or tb == "res":
		var r = a if ta == "res" else b
		var d = ZD.zone(r).door
		var pin = ZD.v2(d.get("in", d.out)); var pout = ZD.v2(d.out)
		return [pout, pin] if ta == "res" else [pin, pout]
	if ta == "wild" or tb == "wild":
		var w = a if ta == "wild" else b
		var g = gate_of(w); var c: Vector2 = g[0]; var dy = float(g[1])
		var ws = _clamp_in(w, c + Vector2(0, -dy * 70.0)); var ms = _clamp_in("market", c + Vector2(0, dy * 70.0))
		return [ws, ms] if ta == "wild" else [ms, ws]
	# 村子 ↔ 大排檔：沿挑夫路（最後一點喺村子 → 第一點喺大排檔）
	var pts = _porter(); var vr = ZD.zrect("village"); var mr = ZD.zrect("market")
	var iv = 0; var im = pts.size() - 1
	for i in pts.size(): if vr.has_point(pts[i]): iv = i
	for i in range(pts.size() - 1, -1, -1): if mr.has_point(pts[i]): im = i
	var seg = []
	if pts.size() >= 2 and iv < im: seg = pts.slice(iv, im + 1)
	else:
		var gp = ZD.v2(ZD.cur().get("village", {}).get("POS", {}).get("gate", [vr.get_center().x, vr.position.y]))
		var dv = _dir_v2m()
		seg = [_clamp_in("village", gp - dv * 40.0), _clamp_in("market", gp + dv * 80.0)]
	if ta == "market": seg.reverse()
	return seg
# 未開放嘅區嘅入口：[可以企嘅區, 入口點]（冇就 []）
static func _entry(zid: String) -> Array:
	if zid == "" or _open(zid): return []
	match str(ZD.zone(zid).get("type")):
		"res":
			var d = ZD.zone(zid).get("door")
			if d is Dictionary: return ["village", ZD.v2(d.get("in", d.out))]
		"market":
			var h = _hop("village", "market")
			if h.size(): return ["village", h[0]]
		"wild":
			if not _open("market"): return _entry("market")
			return ["market", _hop("market", zid)[0]]
	return []
# 路點（最尾一個係終點）
static func route(from: Vector2, dst: Vector2) -> Array:
	var fr = region(from); if fr == "": fr = _near_region(from)
	var tr = region(dst)
	if tr == "" and ZD.ring_at(dst) != 0:   # [dirs4] 撳咗圈帶（未散霧／出晒界）：停喺霧邊
		var sd = _side(dst); var rz = "rg_" + sd
		if _open(rz): tr = rz; dst = _dirs_clamp(rz, dst)
		else:
			var e0 = _ex(sd)
			var e1 = _entry(str(e0.get("wz", "")))
			if e1.size(): tr = e1[0]; dst = e1[1]
	if tr == "":
		var e = _entry(ZD.zone_at(dst))   # 撳咗未開放嘅區（黑霧／未佔領）：停喺入口（霧邊）
		if e.size(): tr = e[0]; dst = e[1]
		else: tr = _near_region(dst); dst = _clamp_in(tr, dst)
	var o = []
	if fr != tr:
		var ca = _chain(fr); var cb = _chain(tr)
		var lca = "village"
		for z in ca: if z in cb: lca = z; break
		var up = ca.slice(0, ca.find(lca) + 1)          # fr … lca
		var down = cb.slice(0, cb.find(lca) + 1); down.reverse()   # lca … tr
		var path = up + down.slice(1)
		for i in path.size() - 1: o.append_array(_hop(path[i], path[i + 1]))
	o.append(dst)
	return o

# ================= [dirs4] 四方向出路＋圈帶（老闆 11:06） =================
#   x_<方向>：核心地圖入面（村外）嗰段出路小路（zones.json exits4 kind=path），父＝village
#   rg_<方向>：核心地圖外面、已散霧嘅圈帶（分東南西北四邊），父＝x_<方向> 或嗰邊嘅野外區（kind=wild）
#   未散霧嘅圈：停喺已開圈嘅外邊（霧邊），同核心黑霧規則一樣
const XW := 24.0
static func _ex(d: String) -> Dictionary:
	for e in ZD.exits4(): if str(e.dir) == d: return e
	return {}
static func _side(p: Vector2) -> String:
	var ws = ZD.world_size()
	var cx = (p.x - ws.x / 2.0) / ws.x; var cy = (p.y - ws.y / 2.0) / ws.y
	if absf(cx) > absf(cy): return "E" if cx > 0 else "W"
	return "S" if cy > 0 else "N"
static func _open_outer() -> Rect2:
	var rs = ZD.rings()
	var lv = 0
	for rg in rs: if ZD.ring_open(int(rg.ring)): lv = int(rg.ring)
	if lv <= 0: return Rect2(Vector2.ZERO, ZD.world_size())
	return ZD.rect(rs[lv - 1].outer)
static func _segq(p: Vector2, a: Vector2, b: Vector2) -> Vector2:
	var ab = b - a; var L2 = ab.length_squared()
	if L2 <= 0.0: return a
	return a + ab * clampf((p - a).dot(ab) / L2, 0.0, 1.0)
static func _xnear(e: Dictionary, p: Vector2) -> Vector2:
	var pts = e.pts; var best = ZD.v2(pts[0]); var bd = INF
	for i in pts.size() - 1:
		var q = _segq(p, ZD.v2(pts[i]), ZD.v2(pts[i + 1]))
		if q.distance_to(p) < bd: bd = q.distance_to(p); best = q
	return best
static func _dirs_region(p: Vector2) -> String:
	if ZD.exits4().is_empty(): return ""
	var core = Rect2(Vector2.ZERO, ZD.world_size())
	if not core.has_point(p):
		if _open_outer().grow(-INSET + 1.0).has_point(p): return "rg_" + _side(p)
		for e in ZD.exits4():   # 出口外 60 嗰小段（核心邊 → 圈帶）
			if str(e.kind) == "path" and _xnear(e, p).distance_to(p) <= XW: return "x_" + str(e.dir)
		return ""
	for z in ZD.zones():   # [integ] 貼住區邊（≤3px）嘅出路唔當入咗個區
		if ZD.rect(z.rect).grow(-3.0).has_point(p): return ""
	for e in ZD.exits4():
		if str(e.kind) == "path" and _xnear(e, p).distance_to(p) <= XW: return "x_" + str(e.dir)
	return ""
static func _dirs_clamp(zid: String, p: Vector2) -> Vector2:
	if zid.begins_with("x_"): return _xnear(_ex(zid.substr(2)), p)
	var d = zid.substr(3); var o = _open_outer().grow(-INSET); var ws = ZD.world_size()
	var q = Vector2(clampf(p.x, o.position.x, o.end.x), clampf(p.y, o.position.y, o.end.y))
	match d:   # 推出核心地圖外（企喺嗰邊圈帶）
		"N": q.y = minf(q.y, -INSET)
		"S": q.y = maxf(q.y, ws.y + INSET)
		"W": q.x = minf(q.x, -INSET)
		"E": q.x = maxf(q.x, ws.x + INSET)
	return q
static func _dirs_hop(a: String, b: String) -> Array:
	var rev = false; var x = a; var y = b
	if b == "village" or (a.begins_with("rg_") and not b.begins_with("rg_")): rev = true; x = b; y = a   # 統一由內行出
	var o = []
	if x == "village" and y.begins_with("x_"):
		var pts = _ex(y.substr(2)).pts
		for i in pts.size() - 1: o.append(ZD.v2(pts[i]))
	elif y.begins_with("rg_"):
		var pts = _ex(y.substr(3)).pts
		o = [ZD.v2(pts[pts.size() - 2]), ZD.v2(pts[pts.size() - 1])]
	if rev: o.reverse()
	return o
