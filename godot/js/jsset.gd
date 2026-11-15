class_name JSSet
extends RefCounted
var d = {}
var size = 0.0
var _o: Array = []   # 物件 key（Dictionary／Array）：用 is_same 比身份
static func _k(k): return float(k) if typeof(k) == TYPE_INT else k
static func _obj(k) -> bool: return typeof(k) == TYPE_DICTIONARY or typeof(k) == TYPE_ARRAY
func _oi(k) -> int:
	for i in _o.size():
		if is_same(_o[i], k): return i
	return -1
func _sz() -> void: size = d.size() + _o.size()
func add_(v) -> JSSet:
	if _obj(v):
		if _oi(v) < 0: _o.append(v)
	else: d[_k(v)] = true
	_sz(); return self
func _js_add(a: Array) -> JSSet: return add_(a[0])
func _js_has(a: Array) -> bool: return _oi(a[0]) >= 0 if _obj(a[0]) else d.has(_k(a[0]))
func _js_delete(a: Array) -> bool:
	var r := false
	if _obj(a[0]):
		var i = _oi(a[0]); if i >= 0: _o.remove_at(i); r = true
	else: r = d.erase(_k(a[0]))
	_sz(); return r
func _js_clear(_a: Array) -> void: d.clear(); _o.clear(); size = 0
func _js_values(_a: Array) -> Array: return d.keys() + _o
func _js_keys(_a: Array) -> Array: return d.keys() + _o
func _js_forEach(a: Array) -> void:
	for k in d.keys() + _o: J.cl(a[0], null, [k, k, self])
func _js_iter() -> Array: return d.keys() + _o
