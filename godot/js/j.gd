# JS 運行庫（配合 tools/jsgd.js 轉譯出嚟嘅代碼）：JS 語義 → GDScript
# 函數值 = Callable，簽名 (this_, args: Array)；物件 = Dictionary；陣列 = Array
class_name J
extends RefCounted

static var G = {}            # 瀏覽器嘅全局（所有 script 共用頂層）
static var host: Node         # JSRun autoload（計時器、DOM 樁）

# ---------------- 基本 ----------------
static func t(v) -> bool:
	match typeof(v):
		TYPE_NIL: return false
		TYPE_BOOL: return v
		TYPE_FLOAT: return v != 0.0 and not is_nan(v)
		TYPE_INT: return v != 0
		TYPE_STRING: return v != ""
	return true

static func num(v) -> float:
	match typeof(v):
		TYPE_FLOAT: return v
		TYPE_INT: return float(v)
		TYPE_NIL: return NAN if false else 0.0   # undefined→NaN；實際代碼多數當 0 用
		TYPE_BOOL: return 1.0 if v else 0.0
		TYPE_STRING:
			var s: String = v.strip_edges()
			if s == "": return 0.0
			if s.is_valid_float(): return s.to_float()
			if s.begins_with("0x"): return float(s.hex_to_int())
			return NAN
	return NAN

static func str(v) -> String:
	match typeof(v):
		TYPE_STRING: return v
		TYPE_FLOAT:
			if is_nan(v): return "NaN"
			if is_inf(v): return "Infinity" if v > 0 else "-Infinity"
			if v == floor(v) and absf(v) < 1e21: return String.num_int64(int(v))
			var s = String.num(v, 12)
			return s
		TYPE_INT: return String.num_int64(v)
		TYPE_NIL: return "undefined"
		TYPE_BOOL: return "true" if v else "false"
		TYPE_ARRAY:
			var parts = PackedStringArray()
			for x in v: parts.append("" if x == null else J.str(x))
			return ",".join(parts)
		TYPE_DICTIONARY: return "[object Object]"
	return "%s" % v

static func add(a, b):
	var ta = typeof(a); var tb = typeof(b)
	if (ta == TYPE_FLOAT or ta == TYPE_INT) and (tb == TYPE_FLOAT or tb == TYPE_INT): return float(a) + float(b)
	if ta == TYPE_STRING or tb == TYPE_STRING or ta == TYPE_ARRAY or tb == TYPE_ARRAY or ta == TYPE_DICTIONARY or tb == TYPE_DICTIONARY: return J.str(a) + J.str(b)
	return num(a) + num(b)
static func sub(a, b) -> float: return (float(a) if typeof(a) == TYPE_FLOAT else num(a)) - (float(b) if typeof(b) == TYPE_FLOAT else num(b))
static func mul(a, b) -> float: return (float(a) if typeof(a) == TYPE_FLOAT else num(a)) * (float(b) if typeof(b) == TYPE_FLOAT else num(b))
static func div(a, b) -> float:
	var x = num(a); var y = num(b)
	if y == 0.0:
		if x == 0.0 or is_nan(x): return NAN
		return INF if x > 0 else -INF
	return x / y
static func mod(a, b) -> float:
	var y = num(b)
	if y == 0.0: return NAN
	return fmod(num(a), y)
static func cmp(a, b, op: String) -> bool:
	if typeof(a) == TYPE_STRING and typeof(b) == TYPE_STRING:
		match op:
			"<": return a < b
			">": return a > b
			"<=": return a <= b
			">=": return a >= b
	var x = num(a); var y = num(b)
	if is_nan(x) or is_nan(y): return false
	match op:
		"<": return x < y
		">": return x > y
		"<=": return x <= y
		">=": return x >= y
	return false
static func _isnum(v) -> bool: return typeof(v) == TYPE_FLOAT or typeof(v) == TYPE_INT
static func seq(a, b) -> bool:
	if _isnum(a) and _isnum(b): return float(a) == float(b)
	if typeof(a) != typeof(b): return false
	if typeof(a) == TYPE_DICTIONARY or typeof(a) == TYPE_ARRAY: return is_same(a, b)
	if typeof(a) == TYPE_CALLABLE: return a == b
	return a == b
static func leq(a, b) -> bool:
	if a == null or b == null: return a == null and b == null
	if seq(a, b): return true
	if _isnum(a) and typeof(b) == TYPE_STRING or typeof(a) == TYPE_STRING and _isnum(b): return num(a) == num(b)
	if typeof(a) == TYPE_BOOL or typeof(b) == TYPE_BOOL: return num(a) == num(b)
	return false
static func i32(v) -> int:
	var x = num(v)
	if is_nan(x) or is_inf(x): return 0
	var n = int(x) & 0xFFFFFFFF
	return n - 0x100000000 if n >= 0x80000000 else n
static func bor(a, b) -> float: return float(i32(i32(a) | i32(b)))
static func band(a, b) -> float: return float(i32(i32(a) & i32(b)))
static func bxor(a, b) -> float: return float(i32(i32(a) ^ i32(b)))
static func shl(a, b) -> float: return float(i32(i32(a) << (i32(b) & 31)))
static func shr(a, b) -> float: return float(i32(a) >> (i32(b) & 31))
static func ushr(a, b) -> float: return float((i32(a) & 0xFFFFFFFF) >> (i32(b) & 31))
static func bnot(a) -> float: return float(i32(~i32(a)))
static func trunc(x: float) -> float: return float(int(x)) if not is_nan(x) and not is_inf(x) else x
static func round(x: float) -> float: return floor(x + 0.5)
static func cbrt(x: float) -> float: return signf(x) * pow(absf(x), 1.0 / 3.0)
static func log2(x: float) -> float: return log(x) / log(2.0)
static func log10(x: float) -> float: return log(x) / log(10.0)
static func max_(a: Array) -> float:
	var m = -INF
	for v in a:
		var x = num(v)
		if is_nan(x): return NAN
		if x > m: m = x
	return m
static func min_(a: Array) -> float:
	var m = INF
	for v in a:
		var x = num(v)
		if is_nan(x): return NAN
		if x < m: m = x
	return m
static func hypot_(a: Array) -> float:
	var s = 0.0
	for v in a: s += num(v) * num(v)
	return sqrt(s)
static func math(m: String, a: Array):
	match m:
		"floor": return floor(num(a[0]))
		"ceil": return ceil(num(a[0]))
		"round": return round(num(a[0]))
		"abs": return absf(num(a[0]))
		"sign": return signf(num(a[0]))
		"sqrt": return sqrt(num(a[0]))
		"pow": return pow(num(a[0]), num(a[1]))
		"atan2": return atan2(num(a[0]), num(a[1]))
		"max": return max_(a)
		"min": return min_(a)
		"hypot": return hypot_(a)
		"log1p": return log(1 + num(a[0]))
		"expm1": return exp(num(a[0])) - 1
		"sinh": return sinh(num(a[0]))
		"cosh": return cosh(num(a[0]))
		"tanh": return tanh(num(a[0]))
		"fround": return num(a[0])
		"imul": return float(i32(i32(a[0]) * i32(a[1])))
	push_warning("Math." + m); return 0.0
static func nop(_v) -> void: pass
static func throw_(v) -> void: push_warning("JS throw: %s" % J.str(v))
static func arg(a: Array, i: int): return a[i] if i < a.size() else null
static func key(k) -> String: return J.str(k) if typeof(k) != TYPE_STRING else k
static func typeof_(v) -> String:
	match typeof(v):
		TYPE_NIL: return "undefined"
		TYPE_BOOL: return "boolean"
		TYPE_FLOAT, TYPE_INT: return "number"
		TYPE_STRING: return "string"
		TYPE_CALLABLE: return "function"
		TYPE_DICTIONARY: return "function" if v.has("__class") else "object"
	return "object"

# ---------------- 屬性 ----------------
static func len(o) -> float:
	match typeof(o):
		TYPE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_STRING_ARRAY: return float(o.size())
		TYPE_STRING: return float(o.length())
		TYPE_DICTIONARY: return num(o.get("length")) if o.has("length") else 0.0
		TYPE_CALLABLE: return float(o.get_argument_count()) if o.is_valid() else 0.0
		TYPE_OBJECT:
			if o == null: return 0.0
			var v = o.get("length")
			return num(v) if v != null else 0.0
	return 0.0

static func gp(o, k):
	match typeof(o):
		TYPE_DICTIONARY:
			var ks = k if typeof(k) == TYPE_STRING else J.str(k)
			var v = o.get(ks)
			if v == null and o.has("__getters"):
				var gt = o["__getters"].get(ks)
				if gt != null: return cl(gt, o, [])
			if v == null and o.has("__proto") and not o.has(ks): return gp(o["__proto"], ks)
			return v
		TYPE_ARRAY:
			if typeof(k) == TYPE_FLOAT or typeof(k) == TYPE_INT:
				var i = int(k)
				return o[i] if i >= 0 and i < o.size() and float(i) == float(k) else null
			if typeof(k) == TYPE_STRING:
				if k == "length": return float(o.size())
				if k.is_valid_int():
					var i2: int = k.to_int(); return o[i2] if i2 >= 0 and i2 < o.size() else null
			return null
		TYPE_STRING:
			if typeof(k) == TYPE_FLOAT or typeof(k) == TYPE_INT:
				var i3 = int(k)
				return o[i3] if i3 >= 0 and i3 < o.length() else null
			if k == "length": return float(o.length())
			return null
		TYPE_NIL: return null
		TYPE_OBJECT:
			if o == null: return null
			if o is Texture2D:
				match k:
					"naturalWidth", "width": return float(o.get_width())
					"naturalHeight", "height": return float(o.get_height())
					"complete", "_ok": return true
				return null
			return o.get(J.str(k))
		TYPE_TRANSFORM2D:
			var m: Transform2D = o
			match k:
				"a": return m.x.x
				"b": return m.x.y
				"c": return m.y.x
				"d": return m.y.y
				"e": return m.origin.x
				"f": return m.origin.y
			return null
		TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_PACKED_BYTE_ARRAY:
			if typeof(k) == TYPE_STRING and k == "length": return float(o.size())
			var i4 = int(k); return float(o[i4]) if i4 >= 0 and i4 < o.size() else null
		TYPE_CALLABLE:
			if k == "name": return o.get_method()
			return null
		TYPE_FLOAT, TYPE_INT, TYPE_BOOL: return null
	return null

static func sp(o, k, v) -> void:
	match typeof(o):
		TYPE_DICTIONARY:
			var ks = k if typeof(k) == TYPE_STRING else J.str(k)
			if o.has("__setters") and o["__setters"].has(ks): cl(o["__setters"][ks], o, [v]); return
			o[ks] = v
		TYPE_ARRAY:
			if typeof(k) == TYPE_STRING:
				if k == "length": o.resize(int(num(v))); return
				if not k.is_valid_int(): return
			var i = int(num(k))
			if i < 0: return
			if i >= o.size(): o.resize(i + 1)
			o[i] = v
		TYPE_OBJECT:
			if o != null: o.set(J.str(k), v)
		TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_PACKED_BYTE_ARRAY:
			pass   # Packed 陣列係值類型；轉譯時用 Array 代替

static func del(o, k) -> void:
	if typeof(o) == TYPE_DICTIONARY: o.erase(J.str(k))
	elif typeof(o) == TYPE_ARRAY:
		var i = int(num(k))
		if i >= 0 and i < o.size(): o[i] = null

static func has(o, k) -> bool:
	match typeof(o):
		TYPE_DICTIONARY: return o.has(J.str(k)) or (o.has("__getters") and o["__getters"].has(J.str(k)))
		TYPE_ARRAY: return k == "length" or (_isnum(k) and int(k) >= 0 and int(k) < o.size())
		TYPE_OBJECT: return o != null and (o.has_method(J.str(k)) or J.str(k) in o)
	return false
static func inst(a, b) -> bool:
	if typeof(b) == TYPE_DICTIONARY and b.has("__class"): return typeof(a) == TYPE_DICTIONARY and a.get("__cls") == b
	if typeof(b) == TYPE_STRING: return false
	return false

static func assign(o, srcs: Array):
	if typeof(o) != TYPE_DICTIONARY: return o
	for s in srcs:
		if typeof(s) == TYPE_DICTIONARY:
			for k in s:
				if k == "__getters":
					if not o.has("__getters"): o["__getters"] = {}
					o["__getters"].merge(s["__getters"], true)
				else: o[k] = s[k]
		elif typeof(s) == TYPE_ARRAY:
			for i in s.size(): o[str(i)] = s[i]
	return o
static func omit(o, ks: Array) -> Dictionary:
	var r = {}
	if typeof(o) == TYPE_DICTIONARY:
		for k in o:
			if not ks.has(k): r[k] = o[k]
	return r

# 展開
class Spr_:
	extends RefCounted
	var v
	func _init(x): v = x
static func SP(v) -> Spr_: return Spr_.new(v)
static func spread(parts: Array) -> Array:
	var r = []
	for p in parts:
		if p is Spr_:
			for x in iter(p.v): r.append(x)
		else: r.append(p)
	return r

static func iter(o) -> Array:
	match typeof(o):
		TYPE_ARRAY: return o.duplicate() if o.size() < 64 else o.duplicate()
		TYPE_STRING:
			var r = []
			for c in o: r.append(c)
			return r
		TYPE_DICTIONARY: return o.values()
		TYPE_OBJECT:
			if o != null and o.has_method("_js_iter"): return o._js_iter()
		TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_STRING_ARRAY: return Array(o)
	return []
static func keys(o) -> Array:
	match typeof(o):
		TYPE_DICTIONARY: return o.keys().filter(func(k): return k != "__getters" and k != "__setters" and k != "__proto" and k != "__cls")
		TYPE_ARRAY: return range(o.size()).map(func(i): return str(i))
		TYPE_STRING: return range(o.length()).map(func(i): return str(i))
	return []

# ---------------- 呼叫 ----------------
static func cl(f, this_, args: Array):
	if typeof(f) == TYPE_CALLABLE:
		if f.is_valid(): return f.call(this_, args)
		return null
	if typeof(f) == TYPE_DICTIONARY and f.has("__class"): return construct(f, args)
	if typeof(f) == TYPE_DICTIONARY and f.has("__fn"): return cl(f["__fn"], this_, args)
	return null

static func construct(c, args: Array):
	if typeof(c) == TYPE_DICTIONARY and c.has("__class"):
		var o = {"__cls": c}
		var chain = []; var k = c
		while typeof(k) == TYPE_DICTIONARY and k.has("__class"): chain.push_front(k); k = k.get("super")
		for cc in chain: o.merge(cc.proto, true)
		if c.ctor != null: cl(c.ctor, o, args)
		elif c.get("super") != null and c.super.ctor != null: cl(c.super.ctor, o, args)
		return o
	if typeof(c) == TYPE_CALLABLE:
		var o2 = {}
		var r = c.call(o2, args)
		return r if typeof(r) == TYPE_DICTIONARY else o2
	return {}

static func new_(n: String, a: Array):
	match n:
		"Map":
			var m = JSMap.new()
			if a.size() and a[0] != null:
				for e in iter(a[0]): m.set_(e[0], e[1])
			return m
		"Set":
			var st = JSSet.new()
			if a.size() and a[0] != null:
				for e in iter(a[0]): st.add_(e)
			return st
		"WeakMap": return JSMap.new()
		"WeakSet": return JSSet.new()
		"Array":
			if a.size() == 1 and _isnum(a[0]):
				var r = []; r.resize(int(a[0])); return r
			return a.duplicate()
		"Float32Array", "Float64Array", "Uint8Array", "Uint16Array", "Int16Array", "Int32Array", "Uint32Array", "Uint8ClampedArray":
			if a.size() and _isnum(a[0]):
				var r2 = []; r2.resize(int(a[0])); r2.fill(0.0); return r2
			if a.size() and typeof(a[0]) == TYPE_ARRAY: return a[0].map(func(x): return num(x))
			return []
		"RegExp": return JSRegExp.new(J.str(a[0]) if a.size() else "", J.str(a[1]) if a.size() > 1 and a[1] != null else "")
		"Date": return {"__date": float(a[0]) if a.size() and _isnum(a[0]) else Time.get_unix_time_from_system() * 1000.0}
		"Error": return {"message": a[0] if a.size() else ""}
		"Image": return host.new_image() if host else {}
		"OffscreenCanvas": return host.new_canvas(a) if host else {}
		"Path2D": return JSPath.new()
	return host.stub_obj(n) if host else {}

static func re(p: String, f: String) -> JSRegExp: return JSRegExp.new(p, f)

# 方法呼叫：o.m(args)
static func mc(o, m, a: Array):
	var mm: String = m if typeof(m) == TYPE_STRING else J.str(m)
	match typeof(o):
		TYPE_DICTIONARY:
			var f = o.get(mm)
			if f == null and o.has("__proto") and not o.has(mm): f = gp(o["__proto"], mm)
			if f != null: return cl(f, o, a)
			match mm:
				"hasOwnProperty": return o.has(J.str(a[0]))
				"toString": return "[object Object]"
				"call": return null
			return null
		TYPE_ARRAY: return JA.call_(o, mm, a)
		TYPE_STRING: return JStr.call_(o, mm, a)
		TYPE_FLOAT, TYPE_INT: return JStr.num_call(float(o), mm, a)
		TYPE_CALLABLE:
			match mm:
				"call": return o.call(a[0] if a.size() else null, a.slice(1))
				"apply": return o.call(a[0] if a.size() else null, iter(a[1]) if a.size() > 1 else [])
				"bind":
					var th = a[0] if a.size() else null; var pre = a.slice(1); var ff: Callable = o
					return func(_t, args): return ff.call(th, pre + args)
			return null
		TYPE_OBJECT:
			if o == null: return null
			if o.has_method("_js_" + mm): return o.callv("_js_" + mm, [a])
			if o is Ctx: return _ctx_call(o, mm, a)
			if o.has_method(mm): return o.callv(mm, a)
			return null
		TYPE_TRANSFORM2D:
			var tr: Transform2D = o
			match mm:
				"inverse": return tr.affine_inverse()
				"transformPoint":
					var p = a[0]; var v = tr * Vector2(num(gp(p, "x")), num(gp(p, "y")))
					return {"x": v.x, "y": v.y}
				"multiply": return tr * a[0] if a.size() and a[0] is Transform2D else tr
			return null
		TYPE_BOOL:
			if mm == "toString": return J.str(o)
	return null

# ---------------- 全局物件（JSON / Object / Array / Number / String / Date / console …）----------------
static func S_JSON_(m: String, a: Array):
	if m == "parse":
		var v = JSON.parse_string(J.str(a[0]))
		return v
	if m == "stringify": return to_json(a[0])
	return null
static func to_json(v) -> String:
	match typeof(v):
		TYPE_NIL: return "null"
		TYPE_BOOL: return "true" if v else "false"
		TYPE_FLOAT, TYPE_INT:
			var x = float(v)
			if is_nan(x) or is_inf(x): return "null"
			return J.str(x)
		TYPE_STRING: return JSON.stringify(v)
		TYPE_ARRAY:
			var p = PackedStringArray()
			for x in v: p.append(to_json(x) if typeof(x) != TYPE_CALLABLE else "null")
			return "[" + ",".join(p) + "]"
		TYPE_DICTIONARY:
			var p2 = PackedStringArray()
			for k in v:
				if typeof(v[k]) == TYPE_CALLABLE or k == "__getters" or k == "__cls": continue
				if v[k] == null and false: continue
				p2.append(JSON.stringify(J.str(k)) + ":" + to_json(v[k]))
			return "{" + ",".join(p2) + "}"
		TYPE_OBJECT:
			if v != null and v.has_method("_js_toJSON"): return to_json(v._js_toJSON([]))
	return "null"

static func S_Object_(m: String, a: Array):
	var o = a[0] if a.size() else null
	match m:
		"keys": return keys(o)
		"values":
			if typeof(o) == TYPE_DICTIONARY: return keys(o).map(func(k): return o[k])
			if typeof(o) == TYPE_ARRAY: return o.duplicate()
			return []
		"entries":
			if typeof(o) == TYPE_DICTIONARY: return keys(o).map(func(k): return [k, o[k]])
			if typeof(o) == TYPE_ARRAY: return range(o.size()).map(func(i): return [str(i), o[i]])
			return []
		"assign": return assign(o, a.slice(1))
		"freeze", "seal", "preventExtensions": return o
		"fromEntries":
			var r = {}
			for e in iter(o): r[J.str(e[0])] = e[1]
			return r
		"create":
			var r2 = {}
			if typeof(o) == TYPE_DICTIONARY: r2["__proto"] = o
			return r2
		"getPrototypeOf": return o.get("__proto") if typeof(o) == TYPE_DICTIONARY else null
		"defineProperty":
			if typeof(o) == TYPE_DICTIONARY:
				var d = a[2]
				if typeof(d) == TYPE_DICTIONARY:
					if d.has("get"):
						if not o.has("__getters"): o["__getters"] = {}
						o["__getters"][J.str(a[1])] = d.get
					if d.has("set"):
						if not o.has("__setters"): o["__setters"] = {}
						o["__setters"][J.str(a[1])] = d.set
					if d.has("value"): o[J.str(a[1])] = d.value
			return o
		"is": return seq(a[0], a[1])
	push_warning("Object." + m); return null
static func S_Array_(m: String, a: Array):
	match m:
		"isArray": return typeof(a[0]) == TYPE_ARRAY
		"from":
			var src = a[0]; var r = []
			if typeof(src) == TYPE_DICTIONARY and src.has("length") and not src.has("0"):
				for i in int(num(src.length)): r.append(null)
			else: r = iter(src)
			if a.size() > 1 and a[1] != null:
				var f = a[1]; var o = []
				for i in r.size(): o.append(cl(f, null, [r[i], float(i)]))
				return o
			return r
		"of": return a.duplicate()
	return null
static func S_Number_(m: String, a: Array):
	match m:
		"isFinite": return _isnum(a[0]) and not is_nan(float(a[0])) and not is_inf(float(a[0]))
		"isInteger": return _isnum(a[0]) and float(a[0]) == floor(float(a[0]))
		"isNaN": return _isnum(a[0]) and is_nan(float(a[0]))
		"parseFloat": return F_parseFloat(a)
		"parseInt": return F_parseInt(a)
	return null
static func S_String_(m: String, a: Array):
	if m == "fromCharCode":
		var s = ""
		for c in a: s += String.chr(int(num(c)))
		return s
	if m == "fromCodePoint": return String.chr(int(num(a[0])))
	return null
static func now() -> float: return Time.get_unix_time_from_system() * 1000.0
static func S_Date_(m: String, _a: Array):
	if m == "now": return now()
	return null
static func S_performance_(m: String, _a: Array):
	if m == "now": return Time.get_ticks_usec() / 1000.0
	return 0.0
static func S_console_(m: String, a: Array):
	if m == "error" or m == "warn": push_warning("JS console.%s: %s" % [m, " ".join(a.map(func(x): return J.str(x)))])
	elif OS.is_debug_build() and m == "log": print("JS: ", " ".join(a.map(func(x): return J.str(x))))
	return null
static func S_document_(m: String, a: Array): return host.document_(m, a) if host else null
static func S_globalThis_(m: String, a: Array): return host.window_(m, a) if host else null
static func S_window_(m: String, a: Array): return host.window_(m, a) if host else null
static func S_localStorage_(m: String, a: Array): return host.ls_(m, a) if host else null
static func S_sessionStorage_(m: String, a: Array): return host.ls_(m, a) if host else null
static func S_navigator_(_m: String, _a: Array): return null
static func S_history_(_m: String, _a: Array): return null
static func S_location_(_m: String, _a: Array): return null
static func S_Reflect_(_m: String, _a: Array): return null
static func S_speechSynthesis_(_m: String, _a: Array): return null
static func S_URL_(_m: String, _a: Array): return ""
static func S_Intl_(_m: String, _a: Array): return null
static func S_Promise_(m: String, a: Array):
	if m == "resolve" or m == "all" or m == "race": return JSPromise.new(a[0] if a.size() else null)
	return JSPromise.new(null)

# ---------------- 全局函數 ----------------
static func F_parseInt(a: Array) -> float:
	var s = J.str(a[0]).strip_edges(); var radix = int(num(a[1])) if a.size() > 1 and a[1] != null else 10
	if radix == 16 or s.begins_with("0x"): return float(s.trim_prefix("0x").hex_to_int())
	var rx = RegEx.create_from_string("^[+-]?\\d+")
	var m = rx.search(s)
	return float(m.get_string().to_int()) if m else NAN
static func F_parseFloat(a: Array) -> float:
	var rx = RegEx.create_from_string("^[+-]?(\\d+\\.?\\d*|\\.\\d+)([eE][+-]?\\d+)?")
	var m = rx.search(J.str(a[0]).strip_edges())
	return m.get_string().to_float() if m else NAN
static func F_isNaN(a: Array) -> bool: return is_nan(num(a[0]))
static func F_isFinite(a: Array) -> bool:
	var x = num(a[0]); return not is_nan(x) and not is_inf(x)
static func F_Number(a: Array) -> float: return num(a[0]) if a.size() else 0.0
static func F_String(a: Array) -> String: return J.str(a[0]) if a.size() else ""
static func F_Boolean(a: Array) -> bool: return t(a[0]) if a.size() else false
static func F_Array(a: Array) -> Array: return new_("Array", a)
static func F_Object(a: Array): return a[0] if a.size() and a[0] != null else {}
static func F_setTimeout(a: Array) -> float: return host.timer(a[0], num(a[1]) if a.size() > 1 else 0.0, false) if host else 0.0
static func F_setInterval(a: Array) -> float: return host.timer(a[0], num(a[1]) if a.size() > 1 else 0.0, true) if host else 0.0
static func F_clearTimeout(a: Array) -> void:
	if host and a.size(): host.clear_timer(a[0])
static func F_clearInterval(a: Array) -> void:
	if host and a.size(): host.clear_timer(a[0])
static func F_requestAnimationFrame(a: Array) -> float: return host.timer(a[0], 0.0, false, true) if host else 0.0
static func F_cancelAnimationFrame(a: Array) -> void:
	if host and a.size(): host.clear_timer(a[0])
static func F_queueMicrotask(a: Array) -> void:
	if host: host.timer(a[0], 0.0, false)
static func F_encodeURIComponent(a: Array) -> String: return J.str(a[0]).uri_encode()
static func F_decodeURIComponent(a: Array) -> String: return J.str(a[0]).uri_decode()
static func F_btoa(a: Array) -> String: return Marshalls.raw_to_base64(J.str(a[0]).to_ascii_buffer() if true else PackedByteArray())
static func F_atob(a: Array) -> String: return Marshalls.base64_to_raw(J.str(a[0])).get_string_from_ascii()
static func F_getComputedStyle(_a: Array): return {}
static func F_fetch(_a: Array): return JSPromise.new(null, true)
static func F_alert(_a: Array) -> void: pass
static func F_confirm(_a: Array) -> bool: return true
static func F_structuredClone(a: Array): return JSON.parse_string(to_json(a[0]))

# Canvas 呼叫：null → 0、多出嘅參數截走
static var _argc = {}
static func _ctx_call(o: Ctx, m: String, a: Array):
	if not o.has_method(m): return null
	var n: int = _argc.get(m, -1)
	if n < 0: n = o.get_method_argument_count(m); _argc[m] = n
	var b = a.slice(0, n) if a.size() > n else a.duplicate()
	if m != "drawImage" and m != "setTransform" and m != "fillText" and m != "strokeText" and m != "measureText" and m != "setLineDash" and m != "createPattern" and m != "putImageData" and m != "fill" and m != "stroke" and m != "clip":
		for i in b.size():
			if b[i] == null: b[i] = 0.0
			elif typeof(b[i]) == TYPE_INT: b[i] = float(b[i])
			elif typeof(b[i]) == TYPE_STRING and m != "roundRect": b[i] = J.num(b[i])
	elif m == "drawImage":
		for i in range(1, b.size()): b[i] = J.num(b[i]) if b[i] != null else 0.0
	elif m == "fillText" or m == "strokeText":
		for i in range(1, b.size()): b[i] = J.num(b[i])
	elif m == "setTransform":
		if b.size() and not (b[0] is Transform2D):
			if typeof(b[0]) == TYPE_DICTIONARY: o.setTransform(J.num(b[0].get("a", 1)), J.num(b[0].get("b", 0)), J.num(b[0].get("c", 0)), J.num(b[0].get("d", 1)), J.num(b[0].get("e", 0)), J.num(b[0].get("f", 0))); return null
			for i in b.size(): b[i] = J.num(b[i])
	elif m == "fill" or m == "stroke" or m == "clip":
		if b.size() and b[0] is JSPath: (b[0] as JSPath).replay(o); b = b.slice(1)
		if m == "fill": o.fill()
		elif m == "stroke": o.stroke()
		else: o.clip()
		return null
	return o.callv(m, b)
