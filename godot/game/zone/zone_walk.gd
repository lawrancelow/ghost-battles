# [zone] 分區地圖：阿福行路經門洞（村子 ↔ 資源區 A／B／C），唔穿牆；未佔領嘅區入唔到；大排檔／野外唔去（同舊柵欄一樣）
# 包住 JS Village.walkTo（排路點 hero.zq）同 Village.update（到咗一個路點就行下一個）。冇 class_name、冇 autoload。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const INSET := 22.0   # 夾入區內（樹林帶／石牆／河都喺區邊，唔好踩到）

static func install(V: Dictionary) -> void:
	if not is_same(V.get("__zn_ws_w"), V.get("workerSpots")): _wrap_spots(V)
	if not is_same(V.get("__zn_walk_w"), V.get("walkTo")): _wrap_walk(V)
	if not is_same(V.get("__zn_up_w"), V.get("update")): _wrap_up(V)
static func _wrap_walk(V: Dictionary) -> void:
	var o_walk = V.get("walkTo")
	var walk = func(t, a):
		var me = t if t != null else V
		if not ZD.on() or J.t(me.get("__zn_in")): return J.cl(o_walk, me, a)
		var H = me.get("hero")
		var dst = Vector2(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); var tg = J.arg(a, 2)
		var from = Vector2(J.num(H.x), J.num(H.y))
		var pts = route(from, dst)
		var fin = pts.pop_back()
		H["zq"] = pts; H["zt"] = tg; H["zf"] = [fin.x, fin.y]
		var p0 = fin if pts.is_empty() else pts.pop_front()
		H["zq"] = pts
		me["__zn_in"] = true   # 下面再有一層（重包咗）就唔好再排路
		var r = J.cl(o_walk, me, [p0.x, p0.y, tg if pts.is_empty() and p0 == fin else null])
		me["__zn_in"] = false
		if p0 == fin: H.erase("zf")
		return r
	V["walkTo"] = walk; V["__zn_walk_w"] = walk
static func _wrap_up(V: Dictionary) -> void:
	var o_up = V.get("update")
	var up = func(t, a):
		var r = J.cl(o_up, t, a)
		var o_walk = V.get("walkTo")   # 經最外層（有 __zn_in 就唔排路），其他包裝（柵欄夾限）照行
		var me = t if t != null else V
		var H = me.get("hero")
		if ZD.on() and H is Dictionary and H.get("zf") is Array and H.get("act") == null and H.get("target") == null:
			if Vector2(J.num(H.x), J.num(H.y)).distance_to(Vector2(J.num(H.tx), J.num(H.ty))) <= 2.5:
				var q = H.get("zq") if H.get("zq") is Array else []
				me["__zn_in"] = true
				if q.size():
					var p = q.pop_front()
					J.cl(o_walk, me, [p.x, p.y, null]); H["zq"] = q
				else:
					var f = H.zf; var tg = H.get("zt"); H.erase("zf"); H["zt"] = null
					if absf(J.num(H.tx) - float(f[0])) > 1.0 or absf(J.num(H.ty) - float(f[1])) > 1.0 or tg != null:
						J.cl(o_walk, me, [float(f[0]), float(f[1]), tg])
				me["__zn_in"] = false
		return r
	V["update"] = up; V["__zn_up_w"] = up

# 阿福可以企嘅區：村子＋已佔領資源區（門洞當村子）
static func region(p: Vector2) -> String:
	for z in ZD.of_type("res"):
		if z.get("door") is Dictionary and ZD.rect(z.door.rect).grow(4).has_point(p): return "village"
	var zid = ZD.zone_at(p)
	if zid == "": return ""
	var tp = str(ZD.zone(zid).type)
	if tp == "village": return "village"
	if tp == "res" and ZD.owned(zid): return zid
	return ""
static func _clamp_in(zid: String, p: Vector2) -> Vector2:
	var r = ZD.zrect(zid).grow(-INSET)
	return Vector2(clampf(p.x, r.position.x, r.end.x), clampf(p.y, r.position.y + 10.0, r.end.y))
static func _near_region(p: Vector2) -> String:   # 撳咗牆／虛空：搵最近嘅可以企嘅區
	var best = "village"; var bd = INF
	for zid in ["village"] + _owned_res():
		var r = ZD.zrect("village" if zid == "village" else zid)
		var q = Vector2(clampf(p.x, r.position.x, r.end.x), clampf(p.y, r.position.y, r.end.y))
		if q.distance_to(p) < bd: bd = q.distance_to(p); best = zid
	return best
static func _owned_res() -> Array:
	var o = []
	for z in ZD.of_type("res"): if ZD.owned(str(z.id)): o.append(str(z.id))
	return o
# 路點（最尾一個係終點）
static func route(from: Vector2, dst: Vector2) -> Array:
	var fr = region(from); if fr == "": fr = _near_region(from)
	var tr = region(dst)
	if tr == "": tr = _near_region(dst); dst = _clamp_in("village" if tr == "village" else tr, dst)
	var o = []
	if fr != tr:
		if fr != "village":
			var d = ZD.zone(fr).door; o.append(ZD.v2(d.out)); o.append(ZD.v2(d.in))
		if tr != "village":
			var d2 = ZD.zone(tr).door; o.append(ZD.v2(d2.in)); o.append(ZD.v2(d2.out))
	o.append(dst)
	return o

# 打工鬼企位：JS 嘅位係舊豎條座標 → 換做 zones.json village.spots（按崗位、第幾隻）
static func _wrap_spots(V: Dictionary) -> void:
	var o_ws = V.get("workerSpots")
	var ws = func(t, a):
		var r = J.cl(o_ws, t, a)
		if not ZD.on() or not (r is Array): return r
		var SP = ZD.cur().village.get("spots", {}); var cnt = {}
		for e in r:
			var post = J.str(J.gp(e, "post"))
			if not SP.has(post): continue
			var i = int(cnt.get(post, 0)); cnt[post] = i + 1
			var q = SP[post][i % SP[post].size()]
			e["x"] = float(q[0]); e["y"] = float(q[1]); e["flip"] = int(q[2]) == 1
		return r
	V["workerSpots"] = ws; V["__zn_ws_w"] = ws
