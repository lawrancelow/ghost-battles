# 畫布錄製器：Ctx 畫入嚟嘅指令先記住，之後喺真 CanvasItem 嘅 _draw() 入面重播（可加變換）
# 網頁版每塊 <canvas>（包括離屏暫存畫布）都對應一個 Recorder
class_name Recorder
extends RefCounted

var cmds: Array = []
var width = 300.0
var height = 150.0
var version = 0
var stale = false          # 顯示用畫布：上一幀已經播完，下一筆指令開始新一幀
var baked: Texture2D = null  # 靜態大畫布：拍成貼圖
var baking = false
var used_frames = 0
var last_ver_seen = -1

func clear() -> void:
	cmds.clear(); version += 1; baked = null
func _nf() -> void:
	if stale: stale = false; cmds.clear(); version += 1; baked = null
func draw_set_transform_matrix(t: Transform2D) -> void: _nf(); cmds.append([0, t])
func draw_polyline(p: PackedVector2Array, c: Color, w: float, aa := false) -> void: _nf(); cmds.append([1, p, c, w, aa])
func draw_line(a: Vector2, b: Vector2, c: Color, w: float, aa := false) -> void: _nf(); cmds.append([2, a, b, c, w, aa])
func draw_circle(p: Vector2, r: float, c: Color) -> void: _nf(); cmds.append([3, p, r, c])
func draw_colored_polygon(p: PackedVector2Array, c: Color) -> void: _nf(); cmds.append([4, p, c])
func draw_texture_rect(t: Texture2D, r: Rect2, tile: bool, m: Color) -> void: _nf(); cmds.append([5, t, r, m])
func draw_texture_rect_region(t: Texture2D, r: Rect2, src: Rect2, m: Color) -> void: _nf(); cmds.append([6, t, r, src, m])
func draw_string(f: Font, p: Vector2, s: String, al, w, sz: int, c: Color) -> void: _nf(); cmds.append([7, f, p, s, sz, c])
func draw_string_outline(f: Font, p: Vector2, s: String, al, w, sz: int, ow: int, c: Color) -> void: _nf(); cmds.append([8, f, p, s, sz, ow, c])
func draw_rect(r: Rect2, c: Color, filled := true, w := -1.0) -> void: _nf(); cmds.append([9, r, c, filled])
func tris(idx: PackedInt32Array, pts: PackedVector2Array, cols: PackedColorArray, uvs := PackedVector2Array(), tex = null) -> void: _nf(); cmds.append([10, idx, pts, cols, uvs, tex])
func rec(other: Recorder, M: Transform2D, alpha: float) -> void: _nf(); cmds.append([11, other, M, alpha])

# 重播到 ci；M = 錄製座標 → ci 本地座标；alpha 乘入所有顏色
func replay(ci: CanvasItem, M := Transform2D.IDENTITY, alpha := 1.0, depth := 0) -> void:
	var cur = Transform2D.IDENTITY
	var rid = ci.get_canvas_item()
	ci.draw_set_transform_matrix(M)
	for c in cmds:
		match c[0]:
			0: cur = c[1]; ci.draw_set_transform_matrix(M * cur)
			1: ci.draw_polyline(c[1], _al(c[2], alpha), c[3], c[4])
			2: ci.draw_line(c[1], c[2], _al(c[3], alpha), c[4], c[5])
			3: ci.draw_circle(c[1], c[2], _al(c[3], alpha))
			4: ci.draw_colored_polygon(c[1], _al(c[2], alpha))
			5: ci.draw_texture_rect(c[1], c[2], false, _al(c[3], alpha))
			6: ci.draw_texture_rect_region(c[1], c[2], c[3], _al(c[4], alpha))
			7: ci.draw_string(c[1], c[2], c[3], HORIZONTAL_ALIGNMENT_LEFT, -1, c[4], _al(c[5], alpha))
			8: ci.draw_string_outline(c[1], c[2], c[3], HORIZONTAL_ALIGNMENT_LEFT, -1, c[4], c[5], _al(c[6], alpha))
			9: ci.draw_rect(c[1], _al(c[2], alpha), c[3])
			10:
				var cols: PackedColorArray = c[3]
				if alpha < 0.999:
					cols = cols.duplicate()
					for i in cols.size(): cols[i].a *= alpha
				if c[5] != null: RenderingServer.canvas_item_add_triangle_array(rid, c[1], c[2], cols, c[4], PackedInt32Array(), PackedFloat32Array(), (c[5] as Texture2D).get_rid())
				else: RenderingServer.canvas_item_add_triangle_array(rid, c[1], c[2], cols)
			11:
				var sub: Recorder = c[1]
				if sub.baked != null:
					ci.draw_set_transform_matrix(M * cur * c[2])
					ci.draw_texture_rect(sub.baked, Rect2(0, 0, sub.width, sub.height), false, Color(1, 1, 1, alpha * c[3]))
					ci.draw_set_transform_matrix(M * cur)
				elif depth < 6:
					sub.replay(ci, M * cur * c[2], alpha * c[3], depth + 1); ci.draw_set_transform_matrix(M * cur)
					if sub.cmds.size() > 400: Baker.request(sub)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

static func _al(c: Color, a: float) -> Color:
	if a >= 0.999: return c
	c.a *= a; return c
