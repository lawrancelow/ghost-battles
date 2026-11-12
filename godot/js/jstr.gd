# JS 字串／數字方法
class_name JStr
extends RefCounted

static func call_(s: String, m: String, a: Array):
	match m:
		"slice":
			var n = s.length(); var b = _idx(a[0] if a.size() else null, n, 0); var e = _idx(a[1] if a.size() > 1 else null, n, n)
			return s.substr(b, e - b) if e > b else ""
		"substring":
			var n2 = s.length(); var b2 = clampi(int(J.num(a[0])) if a.size() and a[0] != null else 0, 0, n2); var e2 = clampi(int(J.num(a[1])) if a.size() > 1 and a[1] != null else n2, 0, n2)
			if b2 > e2: var tt = b2; b2 = e2; e2 = tt
			return s.substr(b2, e2 - b2)
		"substr":
			var n3 = s.length(); var b3 = _idx(a[0] if a.size() else null, n3, 0)
			var l = int(J.num(a[1])) if a.size() > 1 and a[1] != null else n3 - b3
			return s.substr(b3, maxi(0, l))
		"indexOf": return float(s.find(J.str(a[0]), int(J.num(a[1])) if a.size() > 1 else 0))
		"lastIndexOf": return float(s.rfind(J.str(a[0])))
		"includes": return s.contains(J.str(a[0]))
		"startsWith": return s.substr(int(J.num(a[1])) if a.size() > 1 else 0).begins_with(J.str(a[0]))
		"endsWith": return s.ends_with(J.str(a[0]))
		"toUpperCase", "toLocaleUpperCase": return s.to_upper()
		"toLowerCase", "toLocaleLowerCase": return s.to_lower()
		"trim": return s.strip_edges()
		"trimStart": return s.strip_edges(true, false)
		"trimEnd": return s.strip_edges(false, true)
		"charAt":
			var i = int(J.num(a[0])) if a.size() else 0
			return s[i] if i >= 0 and i < s.length() else ""
		"charCodeAt", "codePointAt":
			var i2 = int(J.num(a[0])) if a.size() else 0
			return float(s.unicode_at(i2)) if i2 >= 0 and i2 < s.length() else NAN
		"split":
			var sep = a[0] if a.size() else null
			if sep == null: return [s]
			if sep is JSRegExp: return sep.split(s)
			var ss = J.str(sep)
			if ss == "":
				var r = []
				for c in s: r.append(c)
				return r
			return Array(s.split(ss))
		"replace", "replaceAll":
			var pat = a[0]; var rep = a[1]
			if pat is JSRegExp: return pat.replace(s, rep, m == "replaceAll")
			var p = J.str(pat)
			if typeof(rep) == TYPE_CALLABLE:
				var i3 = s.find(p)
				if i3 < 0: return s
				if m == "replaceAll":
					var out = ""; var pos = 0
					while true:
						var k = s.find(p, pos)
						if k < 0: break
						out += s.substr(pos, k - pos) + J.str(J.cl(rep, null, [p, float(k), s])); pos = k + p.length()
					return out + s.substr(pos)
				return s.substr(0, i3) + J.str(J.cl(rep, null, [p, float(i3), s])) + s.substr(i3 + p.length())
			var rs = J.str(rep).replace("$$", "$")
			if m == "replaceAll": return s.replace(p, rs)
			var i4 = s.find(p)
			return s if i4 < 0 else s.substr(0, i4) + rs + s.substr(i4 + p.length())
		"match":
			var re = a[0] if a[0] is JSRegExp else JSRegExp.new(J.str(a[0]), "")
			return re.match_(s)
		"matchAll":
			var re2 = a[0] if a[0] is JSRegExp else JSRegExp.new(J.str(a[0]), "g")
			return re2.match_all(s)
		"search":
			var re3 = a[0] if a[0] is JSRegExp else JSRegExp.new(J.str(a[0]), "")
			var mm = re3.rx.search(s)
			return float(mm.get_start()) if mm else -1.0
		"padStart", "padEnd":
			var w = int(J.num(a[0])); var f = J.str(a[1]) if a.size() > 1 and a[1] != null else " "
			var r2 = s
			while r2.length() < w: r2 = (f + r2) if m == "padStart" else (r2 + f)
			if r2.length() > w: r2 = r2.substr(r2.length() - w) if m == "padStart" else r2.substr(0, w)
			return r2
		"repeat": return s.repeat(maxi(0, int(J.num(a[0]))))
		"concat":
			var r3 = s
			for x in a: r3 += J.str(x)
			return r3
		"localeCompare": return -1.0 if s < J.str(a[0]) else (1.0 if s > J.str(a[0]) else 0.0)
		"normalize", "toString", "valueOf": return s
		"at":
			var k2 = int(J.num(a[0]))
			if k2 < 0: k2 += s.length()
			return s[k2] if k2 >= 0 and k2 < s.length() else null
	push_warning("String." + m)
	return null

static func _idx(v, n: int, d: int) -> int:
	if v == null: return d
	var i = int(J.num(v))
	if i < 0: i = maxi(0, n + i)
	return mini(i, n)

static func num_call(x: float, m: String, a: Array):
	match m:
		"toFixed":
			var d = int(J.num(a[0])) if a.size() else 0
			if d == 0: return J.str(floor(x + 0.5) if x >= 0 else -floor(-x + 0.5))
			var p = pow(10.0, d); var r = floor(absf(x) * p + 0.5) / p
			var s = String.num(r, d)
			if not s.contains("."): s += "."
			var dot = s.find(".")
			while s.length() - dot - 1 < d: s += "0"
			return ("-" if x < 0 and r != 0 else "") + s
		"toString":
			if a.size() and a[0] != null:
				var radix = int(J.num(a[0]))
				if radix == 16: return "%x" % int(x)
				if radix == 2: return String.num_int64(int(x), 2)
				if radix == 36: return String.num_int64(int(x), 36)
			return J.str(x)
		"toPrecision": return String.num(x, int(J.num(a[0])))
		"toLocaleString": return J.str(x)
	return null
