# JS 陣列方法
class_name JA
extends RefCounted

static func _f(f, args: Array): return J.cl(f, null, args)

static func call_(o: Array, m: String, a: Array):
	match m:
		"push":
			for x in a: o.append(x)
			return float(o.size())
		"pop": return o.pop_back() if o.size() else null
		"shift": return o.pop_front() if o.size() else null
		"unshift":
			for i in range(a.size() - 1, -1, -1): o.push_front(a[i])
			return float(o.size())
		"slice":
			var n = o.size()
			var s = _idx(a[0] if a.size() else null, n, 0); var e = _idx(a[1] if a.size() > 1 else null, n, n)
			return o.slice(s, e) if e > s else []
		"splice":
			var n2 = o.size(); var s2 = _idx(a[0] if a.size() else null, n2, 0)
			var dc: int = n2 - s2 if a.size() < 2 else clampi(int(J.num(a[1])), 0, n2 - s2)
			var removed = o.slice(s2, s2 + dc)
			for i in dc: o.remove_at(s2)
			for i in range(a.size() - 1, 1, -1): o.insert(s2, a[i])
			return removed
		"indexOf":
			var from = int(J.num(a[1])) if a.size() > 1 else 0
			for i in range(maxi(0, from), o.size()):
				if J.seq(o[i], a[0]): return float(i)
			return -1.0
		"lastIndexOf":
			for i in range(o.size() - 1, -1, -1):
				if J.seq(o[i], a[0]): return float(i)
			return -1.0
		"includes":
			for x in o:
				if J.seq(x, a[0]) or (typeof(x) == TYPE_FLOAT and typeof(a[0]) == TYPE_FLOAT and is_nan(x) and is_nan(a[0])): return true
			return false
		"join":
			var sep: String = "," if a.is_empty() or a[0] == null else J.str(a[0])
			var p = PackedStringArray()
			for x in o: p.append("" if x == null else J.str(x))
			return sep.join(p)
		"concat":
			var r = o.duplicate()
			for x in a:
				if typeof(x) == TYPE_ARRAY: r.append_array(x)
				else: r.append(x)
			return r
		"reverse": o.reverse(); return o
		"map":
			var r2 = []; r2.resize(o.size()); var f = a[0]
			for i in o.size(): r2[i] = _f(f, [o[i], float(i), o])
			return r2
		"filter":
			var r3 = []; var f2 = a[0]
			for i in o.size():
				if J.t(_f(f2, [o[i], float(i), o])): r3.append(o[i])
			return r3
		"forEach":
			var f3 = a[0]; var arr = o.duplicate() if o.size() < 2000 else o
			for i in arr.size(): _f(f3, [arr[i], float(i), o])
			return null
		"find":
			for i in o.size():
				if J.t(_f(a[0], [o[i], float(i), o])): return o[i]
			return null
		"findIndex":
			for i in o.size():
				if J.t(_f(a[0], [o[i], float(i), o])): return float(i)
			return -1.0
		"findLast":
			for i in range(o.size() - 1, -1, -1):
				if J.t(_f(a[0], [o[i], float(i), o])): return o[i]
			return null
		"findLastIndex":
			for i in range(o.size() - 1, -1, -1):
				if J.t(_f(a[0], [o[i], float(i), o])): return float(i)
			return -1.0
		"some":
			for i in o.size():
				if J.t(_f(a[0], [o[i], float(i), o])): return true
			return false
		"every":
			for i in o.size():
				if not J.t(_f(a[0], [o[i], float(i), o])): return false
			return true
		"reduce":
			var i0 = 0; var acc
			if a.size() > 1: acc = a[1]
			else:
				if o.is_empty(): return null
				acc = o[0]; i0 = 1
			for i in range(i0, o.size()): acc = _f(a[0], [acc, o[i], float(i), o])
			return acc
		"reduceRight":
			var i1 = o.size() - 1; var acc2
			if a.size() > 1: acc2 = a[1]
			else:
				if o.is_empty(): return null
				acc2 = o[i1]; i1 -= 1
			for i in range(i1, -1, -1): acc2 = _f(a[0], [acc2, o[i], float(i), o])
			return acc2
		"sort":
			if a.is_empty() or a[0] == null:
				o.sort_custom(func(x, y): return J.str(x) < J.str(y))
			else:
				var f4 = a[0]
				_stable_sort(o, func(x, y): return J.num(_f(f4, [x, y])) < 0)
			return o
		"fill":
			var n3 = o.size(); var s3 = _idx(a[1] if a.size() > 1 else null, n3, 0); var e3 = _idx(a[2] if a.size() > 2 else null, n3, n3)
			for i in range(s3, e3): o[i] = a[0]
			return o
		"flat":
			var r4 = []
			for x in o:
				if typeof(x) == TYPE_ARRAY: r4.append_array(x)
				else: r4.append(x)
			return r4
		"flatMap":
			var r5 = []
			for i in o.size():
				var v = _f(a[0], [o[i], float(i), o])
				if typeof(v) == TYPE_ARRAY: r5.append_array(v)
				else: r5.append(v)
			return r5
		"keys": return range(o.size()).map(func(i): return float(i))
		"values": return o.duplicate()
		"entries": return range(o.size()).map(func(i): return [float(i), o[i]])
		"at":
			var k = int(J.num(a[0]))
			if k < 0: k += o.size()
			return o[k] if k >= 0 and k < o.size() else null
		"toString": return J.str(o)
		"set": # TypedArray.set
			var off = int(J.num(a[1])) if a.size() > 1 else 0
			var src = a[0]
			for i in J.iter(src).size(): J.sp(o, float(off + i), J.iter(src)[i])
			return null
		"subarray": return call_(o, "slice", a)
		"copyWithin": return o
	push_warning("Array." + m)
	return null

static func _idx(v, n: int, d: int) -> int:
	if v == null: return d
	var i = int(J.num(v))
	if i < 0: i = maxi(0, n + i)
	return mini(i, n)

# JS 嘅 sort 係穩定排序；Godot sort_custom 唔保證，用合併排序
static func _stable_sort(o: Array, less: Callable) -> void:
	if o.size() < 2: return
	var tmp = o.duplicate()
	_ms(o, tmp, 0, o.size(), less)
static func _ms(a: Array, t: Array, lo: int, hi: int, less: Callable) -> void:
	if hi - lo < 2: return
	if hi - lo <= 8:
		for i in range(lo + 1, hi):
			var x = a[i]; var j = i - 1
			while j >= lo and less.call(x, a[j]): a[j + 1] = a[j]; j -= 1
			a[j + 1] = x
		return
	var mid = (lo + hi) >> 1
	_ms(a, t, lo, mid, less); _ms(a, t, mid, hi, less)
	var i2 = lo; var j2 = mid; var k = lo
	while i2 < mid and j2 < hi:
		if less.call(a[j2], a[i2]): t[k] = a[j2]; j2 += 1
		else: t[k] = a[i2]; i2 += 1
		k += 1
	while i2 < mid: t[k] = a[i2]; i2 += 1; k += 1
	while j2 < hi: t[k] = a[j2]; j2 += 1; k += 1
	for q in range(lo, hi): a[q] = t[q]
