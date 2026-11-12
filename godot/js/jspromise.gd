# 極簡 Promise：resolve 值即時可用；then 喺下一幀叫（網頁版主要用嚟等圖片載入）
class_name JSPromise
extends RefCounted
var value
var rejected := false
func _init(v = null, rej := false) -> void: value = v; rejected = rej
func _js_then(a: Array) -> JSPromise:
	var f = a[1] if rejected and a.size() > 1 else (a[0] if not rejected and a.size() else null)
	if f != null and J.host: J.host.timer(func(_t, _a): J.cl(f, null, [value]), 0.0, false)
	return self
func _js_catch(a: Array) -> JSPromise:
	if rejected and a.size() and J.host: J.host.timer(func(_t, _a): J.cl(a[0], null, [value]), 0.0, false)
	return self
func _js_finally(a: Array) -> JSPromise:
	if a.size() and J.host: J.host.timer(func(_t, _a): J.cl(a[0], null, []), 0.0, false)
	return self
