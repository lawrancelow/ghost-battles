# 主線戰鬥招式用嘅 Ctx：補返矩形 clip（Ctx 只記低 clip 框，冇真正裁）
#  - drawTriangles／drawImage（5 參數以內）喺有 clip 時逐個三角形用 Sutherland–Hodgman 裁落 clip 框（裝置座標）
#  水鬼沉落水、手從水窪伸出嚟就靠呢個
class_name BtCtx
extends Ctx

func drawTriangles(tex: Texture2D, pts: PackedVector2Array, uvs: PackedVector2Array, idx: PackedInt32Array, tint := Color.WHITE) -> void:
	if _clip == null: super.drawTriangles(tex, pts, uvs, idx, tint); return
	var m = _mod() * tint
	if m.a <= 0.001: return
	var r: Rect2 = _clip
	if r.size.x > 8000 and r.size.y > 8000: super.drawTriangles(tex, pts, uvs, idx, tint); return
	var dev = PackedVector2Array(); dev.resize(pts.size())
	for i in pts.size(): dev[i] = T * pts[i]
	var op = PackedVector2Array(); var ou = PackedVector2Array(); var oi = PackedInt32Array()
	var i = 0
	while i + 2 < idx.size():
		var P = [dev[idx[i]], dev[idx[i + 1]], dev[idx[i + 2]]]; var U = [uvs[idx[i]], uvs[idx[i + 1]], uvs[idx[i + 2]]]
		i += 3
		var inside = true
		for p in P: if not r.has_point(p): inside = false
		if not inside:
			var res = _clip_poly(P, U, r)
			P = res[0]; U = res[1]
		if P.size() < 3: continue
		var b = op.size()
		for k in P.size(): op.append(P[k]); ou.append(U[k])
		for k in range(1, P.size() - 1): oi.append_array([b, b + k, b + k + 1])
	if oi.is_empty(): return
	var cols = PackedColorArray(); cols.resize(op.size()); cols.fill(m)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	_tris(oi, op, cols, ou, tex)

static func _clip_poly(P: Array, U: Array, r: Rect2) -> Array:
	var planes = [[0, r.position.x, 1], [0, r.end.x, -1], [1, r.position.y, 1], [1, r.end.y, -1]]
	for pl in planes:
		if P.is_empty(): break
		var ax: int = pl[0]; var v: float = pl[1]; var sg: float = pl[2]
		var nP = []; var nU = []
		for k in P.size():
			var a: Vector2 = P[k]; var b: Vector2 = P[(k + 1) % P.size()]
			var ua: Vector2 = U[k]; var ub: Vector2 = U[(k + 1) % P.size()]
			var da = (a[ax] - v) * sg; var db = (b[ax] - v) * sg
			if da >= 0: nP.append(a); nU.append(ua)
			if (da >= 0) != (db >= 0):
				var f = da / (da - db); nP.append(a.lerp(b, f)); nU.append(ua.lerp(ub, f))
		P = nP; U = nU
	return [P, U]

func drawImage(src, a: float, b: float, c = null, d = null, e = null, f = null, g = null, h = null) -> void:
	if _clip == null or e != null or not (src is Texture2D):
		super.drawImage(src, a, b, c, d, e, f, g, h); return
	var w: float = src.get_width() if c == null else float(c); var hh: float = src.get_height() if d == null else float(d)
	drawTriangles(src, PackedVector2Array([Vector2(a, b), Vector2(a + w, b), Vector2(a + w, b + hh), Vector2(a, b + hh)]),
		PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]), PackedInt32Array([0, 1, 2, 0, 2, 3]))
