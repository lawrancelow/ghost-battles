class_name ElClass
extends RefCounted
var d := {}
func _js_add(a: Array) -> void:
	for c in a: d[J.str(c)] = true
func _js_remove(a: Array) -> void:
	for c in a: d.erase(J.str(c))
func _js_toggle(a: Array) -> bool:
	var c := J.str(a[0]); var on: bool = (not d.has(c)) if a.size() < 2 or a[1] == null else J.t(a[1])
	if on: d[c] = true
	else: d.erase(c)
	return on
func _js_contains(a: Array) -> bool: return d.has(J.str(a[0]))
func _js_replace(a: Array) -> void: d.erase(J.str(a[0])); d[J.str(a[1])] = true
