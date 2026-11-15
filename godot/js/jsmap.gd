class_name JSMap
extends RefCounted
var d = {}
var size = 0.0
var _ok: Array = []   # 物件 key（Dictionary／Array）：用 is_same 比身份
var _ov: Array = []
static func _k(k): return float(k) if typeof(k) == TYPE_INT else k
static func _obj(k) -> bool: return typeof(k) == TYPE_DICTIONARY or typeof(k) == TYPE_ARRAY
func _oi(k) -> int:
	for i in _ok.size():
		if is_same(_ok[i], k): return i
	return -1
func _sz() -> void: size = d.size() + _ok.size()
func set_(k, v) -> JSMap:
	if _obj(k):
		var i = _oi(k)
		if i >= 0: _ov[i] = v
		else: _ok.append(k); _ov.append(v)
	else: d[_k(k)] = v
	_sz(); return self
func _js_set(a: Array) -> JSMap: return set_(a[0], a[1] if a.size() > 1 else null)
func _js_get(a: Array):
	if _obj(a[0]):
		var i = _oi(a[0]); return _ov[i] if i >= 0 else null
	return d.get(_k(a[0]))
func _js_has(a: Array) -> bool: return _oi(a[0]) >= 0 if _obj(a[0]) else d.has(_k(a[0]))
func _js_delete(a: Array) -> bool:
	var r := false
	if _obj(a[0]):
		var i = _oi(a[0]); if i >= 0: _ok.remove_at(i); _ov.remove_at(i); r = true
	else: r = d.erase(_k(a[0]))
	_sz(); return r
func _js_clear(_a: Array) -> void: d.clear(); _ok.clear(); _ov.clear(); size = 0
func _js_keys(_a: Array) -> Array: return d.keys() + _ok
func _js_values(_a: Array) -> Array: return d.values() + _ov
func _js_entries(_a: Array) -> Array:
	var r = d.keys().map(func(k): return [k, d[k]])
	for i in _ok.size(): r.append([_ok[i], _ov[i]])
	return r
func _js_forEach(a: Array) -> void:
	for k in d.keys(): J.cl(a[0], null, [d[k], k, self])
	for i in _ok.size(): J.cl(a[0], null, [_ov[i], _ok[i], self])
func _js_iter() -> Array: return _js_entries([])
