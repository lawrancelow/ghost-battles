# JS 正則（Godot RegEx = PCRE2，語法大致相同）
class_name JSRegExp
extends RefCounted
var rx: RegEx
var source = ""
var flags = ""
var global = false
var lastIndex = 0.0

func _init(p: String, f: String) -> void:
	source = p; flags = f; global = f.contains("g")
	var pre = ""
	if f.contains("i"): pre += "(?i)"
	if f.contains("m"): pre += "(?m)"
	if f.contains("s"): pre += "(?s)"
	rx = RegEx.new()
	# JS \d \w 同 PCRE 一樣；\u{...} / \uXXXX 轉做 \x{...}
	var src = p
	var u = RegEx.create_from_string("\\\\u([0-9a-fA-F]{4})")
	src = u.sub(src, "\\x{$1}", true)
	if rx.compile(pre + src) != OK: push_warning("RegExp 編譯失敗: " + p)

func _arr(m: RegExMatch) -> Array:
	var r = []
	for i in m.get_group_count() + 1: r.append(m.get_string(i) if m.get_start(i) >= 0 else null)
	return r

func _js_test(a: Array) -> bool: return rx.search(J.str(a[0])) != null
func _js_exec(a: Array):
	var s = J.str(a[0])
	var m = rx.search(s, int(lastIndex) if global else 0)
	if m == null: lastIndex = 0; return null
	if global: lastIndex = m.get_end()
	var r = _arr(m)
	return r
func match_(s: String):
	if global:
		var all = rx.search_all(s)
		if all.is_empty(): return null
		return all.map(func(m): return m.get_string())
	var m = rx.search(s)
	return _arr(m) if m else null
func match_all(s: String) -> Array:
	return rx.search_all(s).map(func(m): return _arr(m))
func split(s: String) -> Array:
	var out = []; var pos = 0
	for m in rx.search_all(s):
		if m.get_end() == m.get_start() and m.get_start() == pos and pos < s.length():
			out.append(s.substr(pos, 1)); pos += 1; continue
		out.append(s.substr(pos, m.get_start() - pos)); pos = m.get_end()
	out.append(s.substr(pos))
	return out
func replace(s: String, rep, all: bool) -> String:
	var ms: Array = rx.search_all(s) if (global or all) else ([rx.search(s)] if rx.search(s) else [])
	if ms.is_empty(): return s
	var out = ""; var pos = 0
	for m in ms:
		out += s.substr(pos, m.get_start() - pos)
		if typeof(rep) == TYPE_CALLABLE:
			var args = _arr(m); args.append(float(m.get_start())); args.append(s)
			out += J.str(J.cl(rep, null, args))
		else:
			var r = J.str(rep)
			var o = ""; var i = 0
			while i < r.length():
				var c = r[i]
				if c == "$" and i + 1 < r.length():
					var n = r[i + 1]
					if n == "$": o += "$"; i += 2; continue
					if n == "&": o += m.get_string(); i += 2; continue
					if n.is_valid_int():
						var gi = n.to_int()
						if i + 2 < r.length() and r[i + 2].is_valid_int() and (n + r[i + 2]).to_int() <= m.get_group_count(): gi = (n + r[i + 2]).to_int(); i += 1
						o += m.get_string(gi) if gi <= m.get_group_count() else ""; i += 2; continue
				o += c; i += 1
			out += o
		pos = m.get_end()
	return out + s.substr(pos)
