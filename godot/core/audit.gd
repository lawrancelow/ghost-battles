# 繪圖審計（GB_AUDIT=1）：統計每秒經 JS ART.drawChar、Recorder 重播、DOM 繪畫嘅次數同耗時
class_name Audit
extends RefCounted

static var on := OS.has_environment("GB_AUDIT")
static var acc := {}     # key -> [count, usec]
static var _last := 0
static var _frames := 0
static var _wrapped := false

static func add(key: String, us: int) -> void:
	var a = acc.get(key)
	if a == null: acc[key] = [1, us]
	else: a[0] += 1; a[1] += us

static func wrap_js() -> void:
	if not on or _wrapped: return
	var ART = J.G.get("ART")
	if not (ART is Dictionary) or ART.get("drawChar") == null: return
	_wrapped = true
	var orig = ART.drawChar
	ART["drawChar"] = func(t, a):
		var u = Time.get_ticks_usec()
		var r = J.cl(orig, t, a)
		add("js:ART.drawChar:" + J.str(a[1] if a.size() > 1 else "?"), Time.get_ticks_usec() - u)
		return r

static func tick() -> void:
	if not on: return
	wrap_js()
	_frames += 1
	var now = Time.get_ticks_msec()
	if _last == 0: _last = now; return
	if now - _last < 2000: return
	var dt = (now - _last) / 1000.0; _last = now
	var rows = []
	for k in acc: rows.append([acc[k][1], k, acc[k][0]])
	rows.sort_custom(func(x, y): return x[0] > y[0])
	var out = "[audit] fps=%.1f " % (_frames / dt)
	for r in rows.slice(0, 14): out += "| %s n/f=%.1f ms/f=%.2f " % [r[1], r[2] / float(_frames), r[0] / 1000.0 / _frames]
	print(out)
	acc.clear(); _frames = 0
