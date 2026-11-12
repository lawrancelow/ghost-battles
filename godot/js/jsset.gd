class_name JSSet
extends RefCounted
var d = {}
var size = 0.0
static func _k(k): return float(k) if typeof(k) == TYPE_INT else k
func add_(v) -> JSSet: d[_k(v)] = true; size = d.size(); return self
func _js_add(a: Array) -> JSSet: return add_(a[0])
func _js_has(a: Array) -> bool: return d.has(_k(a[0]))
func _js_delete(a: Array) -> bool: var r = d.erase(_k(a[0])); size = d.size(); return r
func _js_clear(_a: Array) -> void: d.clear(); size = 0
func _js_values(_a: Array) -> Array: return d.keys()
func _js_keys(_a: Array) -> Array: return d.keys()
func _js_forEach(a: Array) -> void:
	for k in d.keys(): J.cl(a[0], null, [k, k, self])
func _js_iter() -> Array: return d.keys()
