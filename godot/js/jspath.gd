# Path2D：記住指令，fill/stroke 時重播
class_name JSPath
extends RefCounted
var cmds: Array = []
func _rec(n: String, a: Array) -> void: cmds.append([n, a])
func _js_moveTo(a: Array) -> void: _rec("moveTo", a)
func _js_lineTo(a: Array) -> void: _rec("lineTo", a)
func _js_arc(a: Array) -> void: _rec("arc", a)
func _js_ellipse(a: Array) -> void: _rec("ellipse", a)
func _js_rect(a: Array) -> void: _rec("rect", a)
func _js_roundRect(a: Array) -> void: _rec("roundRect", a)
func _js_quadraticCurveTo(a: Array) -> void: _rec("quadraticCurveTo", a)
func _js_bezierCurveTo(a: Array) -> void: _rec("bezierCurveTo", a)
func _js_closePath(a: Array) -> void: _rec("closePath", a)
func replay(ctx) -> void:
	ctx.beginPath()
	for c in cmds: ctx.callv(c[0], c[1].map(func(x): return J.num(x) if J._isnum(x) or x == null else x))
