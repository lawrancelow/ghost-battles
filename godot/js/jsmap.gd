class_name JSMap
extends RefCounted
var d = {}
var size = 0.0
static func _k(k): return float(k) if typeof(k) == TYPE_INT else k
func set_(k, v) -> JSMap: d[_k(k)] = v; size = d.size(); return self
func _js_set(a: Array) -> JSMap: return set_(a[0], a[1] if a.size() > 1 else null)
func _js_get(a: Array): return d.get(_k(a[0]))
func _js_has(a: Array) -> bool: return d.has(_k(a[0]))
func _js_delete(a: Array) -> bool: var r = d.erase(_k(a[0])); size = d.size(); return r
func _js_clear(_a: Array) -> void: d.clear(); size = 0
func _js_keys(_a: Array) -> Array: return d.keys()
func _js_values(_a: Array) -> Array: return d.values()
func _js_entries(_a: Array) -> Array: return d.keys().map(func(k): return [k, d[k]])
func _js_forEach(a: Array) -> void:
	for k in d.keys(): J.cl(a[0], null, [d[k], k, self])
func _js_iter() -> Array: return _js_entries([])
