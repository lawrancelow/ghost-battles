# 簡易 CSS：讀網頁版 style.css，做選擇器匹配同計算樣式（夠畫各玩法嘅介面）
class_name Css
extends RefCounted

static var rules: Array = []      # [ [compiled_selector, specificity, order, decls:Dictionary] ]
static var by_key = {}           # 索引：最右邊 compound 嘅 id/class/tag → rule 清單
static var vars = {}
static var loaded = false

const INHERIT := ["color", "font-size", "font-weight", "font-family", "text-align", "line-height", "white-space", "visibility", "letter-spacing", "font-style", "text-shadow"]

static func load_sheet(path: String) -> void:
	if loaded: return
	loaded = true
	var css = FileAccess.get_file_as_string(path)
	css = RegEx.create_from_string("/\\*[\\s\\S]*?\\*/").sub(css, "", true)
	_parse_block(css, 0)

# JS 動態加入嘅 <style>
static var _seen_sheets = {}
static func add_text(css: String) -> void:
	var h = css.hash()
	if _seen_sheets.has(h): return
	_seen_sheets[h] = true
	css = RegEx.create_from_string("/\\*[\\s\\S]*?\\*/").sub(css, "", true)
	_parse_block(css, 0)

static func _parse_block(css: String, depth: int) -> void:
	var i = 0; var n = css.length(); var order = rules.size()
	while i < n:
		var ob = css.find("{", i)
		if ob < 0: break
		var sel = css.substr(i, ob - i).strip_edges()
		# 配對括號
		var d = 1; var j = ob + 1
		while j < n and d > 0:
			if css[j] == "{": d += 1
			elif css[j] == "}": d -= 1
			j += 1
		var body = css.substr(ob + 1, j - ob - 2)
		i = j
		if sel.begins_with("@media") or sel.begins_with("@supports"):
			if sel.contains("prefers-reduced-motion") or sel.contains("min-width") or sel.contains("hover"): continue
			_parse_block(body, depth + 1); continue
		if sel.begins_with("@"): continue
		var decls = _decls(body)
		if sel == ":root":
			for k in decls:
				if k.begins_with("--"): vars[k] = decls[k]
			continue
		for one in sel.split(","):
			var s = one.strip_edges()
			var pk = ""
			for suf in ["::before", "::after", ":before", ":after"]:
				if s.ends_with(suf): pk = suf.trim_prefix(":").trim_prefix(":"); s = s.substr(0, s.length() - suf.length()); break
			if pk != "" and not (s.contains(":hover") or s.contains(":active") or s.contains(":focus") or s.contains("::")):
				var pc = _compile(s)
				if pc != null:
					order += 1
					if not pseudo_rules.has(pk): pseudo_rules[pk] = []
					pseudo_rules[pk].append([pc, _spec(pc) + 1, order, decls])
				continue
			if s == "" or s.contains("::") or s.contains(":before") or s.contains(":after") or s.contains(":hover") or s.contains(":active") or s.contains(":focus") or s.contains(":placeholder") or s.contains("::-webkit"): continue
			var comp = _compile(s)
			if comp == null: continue
			order += 1
			var r = [comp, _spec(comp), order, decls]
			rules.append(r)
			var last: Dictionary = comp[-1][1]
			var key = ("#" + last.id) if last.id != "" else (("." + last.cls[0]) if last.cls.size() else ("t:" + last.tag if last.tag != "" else "*"))
			if not by_key.has(key): by_key[key] = []
			by_key[key].append(r)

static func _decls(body: String) -> Dictionary:
	var d = {}
	for part in _split_decls(body):
		var c = part.find(":")
		if c < 0: continue
		var k = part.substr(0, c).strip_edges().to_lower(); var v = part.substr(c + 1).strip_edges()
		var imp = v.ends_with("!important")
		if imp: v = v.trim_suffix("!important").strip_edges()
		_expand(d, k, v)
	return d

static func _split_decls(body: String) -> Array:
	var out = []; var cur = ""; var depth = 0
	for ch in body:
		if ch == "(": depth += 1
		elif ch == ")": depth -= 1
		if ch == ";" and depth == 0: out.append(cur); cur = ""
		else: cur += ch
	if cur.strip_edges() != "": out.append(cur)
	return out

static func inline_into(style: Dictionary, s: String) -> void:
	for part in _split_decls(s):
		var c = part.find(":")
		if c < 0: continue
		_expand(style, part.substr(0, c).strip_edges().to_lower(), part.substr(c + 1).strip_edges().trim_suffix("!important").strip_edges())

static func _box4(v: String) -> Array:
	var p = _tokens(v)
	match p.size():
		1: return [p[0], p[0], p[0], p[0]]
		2: return [p[0], p[1], p[0], p[1]]
		3: return [p[0], p[1], p[2], p[1]]
	return [p[0], p[1], p[2], p[3]] if p.size() >= 4 else ["0", "0", "0", "0"]

static func _tokens(v: String) -> Array:
	var out = []; var cur = ""; var depth = 0
	for ch in v:
		if ch == "(": depth += 1
		elif ch == ")": depth -= 1
		if (ch == " " or ch == "\t" or ch == "\n") and depth == 0:
			if cur != "": out.append(cur); cur = ""
		else: cur += ch
	if cur != "": out.append(cur)
	return out

static func _expand(d: Dictionary, k: String, v: String) -> void:
	match k:
		"margin", "padding":
			var b = _box4(v); d[k + "-top"] = b[0]; d[k + "-right"] = b[1]; d[k + "-bottom"] = b[2]; d[k + "-left"] = b[3]
		"inset":
			var b2 = _box4(v); d["top"] = b2[0]; d["right"] = b2[1]; d["bottom"] = b2[2]; d["left"] = b2[3]
		"border":
			if v == "none" or v == "0": d["border-width"] = "0"; return
			for t in _tokens(v):
				if t.ends_with("px") or t.is_valid_float(): d["border-width"] = t
				elif t in ["solid", "dashed", "dotted", "double"]: d["border-style"] = t
				else: d["border-color"] = t
		"border-top", "border-bottom", "border-left", "border-right":
			for t in _tokens(v):
				if t.ends_with("px"): d[k + "-width"] = t
				elif not (t in ["solid", "dashed", "dotted"]): d[k + "-color"] = t
		"flex":
			var t2 = _tokens(v)
			if v == "none": d["flex-grow"] = "0"; d["flex-shrink"] = "0"
			elif v == "auto": d["flex-grow"] = "1"
			elif t2.size(): d["flex-grow"] = t2[0]; d["flex-basis"] = t2[2] if t2.size() > 2 else ("0" if t2[0].is_valid_float() else t2[0])
		"gap":
			var g = _tokens(v); d["row-gap"] = g[0]; d["column-gap"] = g[1] if g.size() > 1 else g[0]
		"background":
			d["background"] = v
		"place-items": d["align-items"] = v
		_: d[k] = v

# ---------------- 選擇器 ----------------
# 編譯成 [[combinator, {tag,id,cls[],attrs[],not[],pseudo[]}], ...]（由左到右）
static func _compile(s: String):
	var parts = []; var comb = " "; var cur = ""; var i = 0; var depth = 0
	s = s.replace(">", " > ").replace("+", " + ").replace("~", " ~ ")
	for t in s.split(" ", false):
		if t == ">" or t == "+" or t == "~": comb = t; continue
		var c = _compound(t)
		if c == null: return null
		parts.append([comb, c]); comb = " "
	return parts if parts.size() else null

static func _compound(t: String):
	var c = {"tag": "", "id": "", "cls": [], "attrs": [], "nots": [], "pseudo": []}
	var i = 0; var n = t.length()
	var rx = RegEx.create_from_string("^([a-zA-Z0-9_*-]+)")
	var m = rx.search(t)
	if m: c.tag = m.get_string(1).to_upper() if m.get_string(1) != "*" else ""; i = m.get_end()
	while i < n:
		var ch = t[i]
		if ch == "#" or ch == ".":
			var j = i + 1
			while j < n and not (t[j] in ["#", ".", "[", ":"]): j += 1
			var name = t.substr(i + 1, j - i - 1)
			if ch == "#": c.id = name
			else: c.cls.append(name)
			i = j
		elif ch == "[":
			var j2 = t.find("]", i)
			if j2 < 0: return null
			var a = t.substr(i + 1, j2 - i - 1)
			var eq = a.find("=")
			if eq < 0: c.attrs.append([a, null])
			else:
				var op = "="
				if eq > 0 and a[eq - 1] in ["^", "*", "$", "~", "|"]: op = a[eq - 1] + "="; c.attrs.append([a.substr(0, eq - 1), a.substr(eq + 1).trim_prefix("\"").trim_suffix("\"").trim_prefix("'").trim_suffix("'"), op])
				else: c.attrs.append([a.substr(0, eq), a.substr(eq + 1).trim_prefix("\"").trim_suffix("\"").trim_prefix("'").trim_suffix("'"), op])
			i = j2 + 1
		elif ch == ":":
			var j3 = i + 1; var dd = 0
			while j3 < n:
				if t[j3] == "(": dd += 1
				elif t[j3] == ")": dd -= 1
				elif dd == 0 and (t[j3] in [".", "#", "[", ":"]): break
				j3 += 1
			var ps = t.substr(i + 1, j3 - i - 1)
			if ps.begins_with("not("):
				var inner = _compound(ps.substr(4, ps.length() - 5))
				if inner != null: c.nots.append(inner)
			else: c.pseudo.append(ps)
			i = j3
		else: i += 1
	return c

static func _spec(comp: Array) -> int:
	var a = 0; var b = 0; var cc = 0
	for p in comp:
		var x: Dictionary = p[1]
		if x.id != "": a += 1
		b += x.cls.size() + x.attrs.size() + x.pseudo.size()
		if x.tag != "": cc += 1
	return a * 10000 + b * 100 + cc

static func match_compound(el: El, c: Dictionary) -> bool:
	if c.tag != "" and el.tagName != c.tag: return false
	if c.id != "" and el.id_ != c.id: return false
	for k in c.cls:
		if not el.classList.d.has(k): return false
	for at in c.attrs:
		var name: String = at[0]; var val
		if name.begins_with("data-"): val = el.dataset.get(Html._camel(name.substr(5)))
		elif name == "class": val = " ".join(el.classList.d.keys())
		elif name == "id": val = el.id_ if el.id_ != "" else null
		else: val = el.props.get(name)
		if at[1] == null:
			if val == null or (typeof(val) == TYPE_BOOL and not val): return false
		else:
			var sv = J.str(val) if val != null else ""
			var op: String = at[2] if at.size() > 2 else "="
			var ok = true
			if op == "=": ok = val != null and sv == at[1]
			elif op == "^=": ok = sv.begins_with(at[1])
			elif op == "$=": ok = sv.ends_with(at[1])
			elif op == "*=": ok = sv.contains(at[1])
			elif op == "~=": ok = at[1] in sv.split(" ")
			if not ok: return false
	for nt in c.nots:
		if match_compound(el, nt): return false
	for ps in c.pseudo:
		var par = el.parentNode
		var sibs: Array = (par.children.filter(func(x): return x.tagName != "#TEXT")) if par is El else [el]
		if ps == "first-child" and (sibs.is_empty() or sibs[0] != el): return false
		if ps == "last-child" and (sibs.is_empty() or sibs[-1] != el): return false
		if ps == "empty" and el.children.size(): return false
		if ps == "checked" and not J.t(el.props.get("checked")): return false
		if ps.begins_with("has("):
			var hs = ps.substr(4, ps.length() - 5)
			if not _has_desc(el, hs): return false
		if ps == "disabled":
			var dv = el.props.get("disabled")
			if dv == null or (typeof(dv) == TYPE_BOOL and not dv): return false
		if ps.begins_with("nth-child("):
			var arg = ps.substr(10, ps.length() - 11); var idx = sibs.find(el) + 1
			if arg == "odd" and idx % 2 == 0: return false
			if arg == "even" and idx % 2 == 1: return false
			if arg.is_valid_int() and idx != arg.to_int(): return false
	return true

static func _has_desc(el: El, sel: String) -> bool:
	for k in el.children:
		if not (k is El) or k.tagName == "#TEXT": continue
		if sel_matches(k, sel) or _has_desc(k, sel): return true
	return false

static func matches(el: El, comp: Array) -> bool:
	return _match_from(el, comp, comp.size() - 1)
static func _match_from(el: El, comp: Array, i: int) -> bool:
	if not match_compound(el, comp[i][1]): return false
	if i == 0: return true
	var comb: String = comp[i][0]
	if comb == ">":
		return el.parentNode is El and _match_from(el.parentNode, comp, i - 1)
	if comb == "+" or comb == "~":
		var par = el.parentNode
		if not (par is El): return false
		var k: int = par.children.find(el)
		for j in range(k - 1, -1, -1):
			var sib: El = par.children[j]
			if sib.tagName == "#TEXT": continue
			if _match_from(sib, comp, i - 1): return true
			if comb == "+": return false
		return false
	var p = el.parentNode
	while p is El:
		if _match_from(p, comp, i - 1): return true
		p = p.parentNode
	return false

static var _sel_cache = {}
static func sel_matches(el: El, selector: String) -> bool:
	for one in selector.split(","):
		var s = one.strip_edges()
		if not _sel_cache.has(s): _sel_cache[s] = _compile(s)
		var c = _sel_cache[s]
		if c != null and matches(el, c): return true
	return false

# ---------------- 計算樣式 ----------------
# ::before／::after：冇 content 就當冇；有就返一份計好嘅樣式（已繼承宿主）
static var pseudo_rules = {}
static func pseudo(el: El, kind: String, host_cs: Dictionary):
	if not pseudo_rules.has(kind): return null
	var hits = []
	for r in pseudo_rules[kind]:
		if matches(el, r[0]): hits.append(r)
	if hits.is_empty(): return null
	hits.sort_custom(func(a, b): return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]))
	var cs = {}
	for k in INHERIT:
		if host_cs.has(k): cs[k] = host_cs[k]
	for r in hits:
		for k in r[3]: cs[k] = r[3][k]
	if not cs.has("content") or cs.get("display", "") == "none": return null
	return cs

static func computed(el: El, parent_cs: Dictionary) -> Dictionary:
	var cs = {}
	for k in INHERIT:
		if parent_cs.has(k): cs[k] = parent_cs[k]
	var cand: Array = []
	if el.id_ != "" and by_key.has("#" + el.id_): cand.append_array(by_key["#" + el.id_])
	for c in el.classList.d:
		if by_key.has("." + c): cand.append_array(by_key["." + c])
	if by_key.has("t:" + el.tagName): cand.append_array(by_key["t:" + el.tagName])
	if by_key.has("*"): cand.append_array(by_key["*"])
	var hits = []
	for r in cand:
		if matches(el, r[0]): hits.append(r)
	hits.sort_custom(func(a, b): return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]))
	for r in hits:
		for k in r[3]: cs[k] = r[3][k]
	# 行內樣式（HTML style= 或者 JS el.style.x = ...）
	for k in el.style:
		var v = el.style[k]
		if k == "cssText": inline_into(cs, J.str(v)); continue
		var kk = _kebab(String(k))
		if v == null or J.str(v) == "": continue
		_expand(cs, kk, J.str(v))
	return cs

static func _kebab(k: String) -> String:
	if not k.contains("-") and k.to_lower() != k:
		var o = ""
		for ch in k:
			if ch != ch.to_lower(): o += "-" + ch.to_lower()
			else: o += ch
		return o
	return k

static func resolve_var(v: String) -> String:
	var guard = 0
	while v.contains("var(") and guard < 8:
		guard += 1
		var i = v.find("var(")
		var d = 0; var j = i + 4
		while j < v.length():
			if v[j] == "(": d += 1
			elif v[j] == ")":
				if d == 0: break
				d -= 1
			j += 1
		var inner = v.substr(i + 4, j - i - 4); var comma = inner.find(",")
		var name = (inner.substr(0, comma) if comma >= 0 else inner).strip_edges()
		var fb = inner.substr(comma + 1).strip_edges() if comma >= 0 else ""
		v = v.substr(0, i) + str(vars.get(name, fb)) + v.substr(j + 1)
	return v

# 長度 → px（ref = 百分比基準）
static func px(v, ref: float, fs: float = 16.0, vw: float = 390.0, vh: float = 844.0):
	if v == null: return null
	var s = resolve_var(J.str(v)).strip_edges()
	if s.contains("env("): s = RegEx.create_from_string("env\\([^)]*\\)").sub(s, "0px", true)
	if s == "" or s == "auto" or s == "none" or s == "normal" or s == "fit-content" or s == "max-content" or s == "min-content": return null
	if s.begins_with("calc(") or s.begins_with("min(") or s.begins_with("max(") or s.begins_with("clamp("): return _calc(s, ref, fs, vw, vh)
	if s.begins_with("env("): return 0.0
	if s.ends_with("px"): return s.trim_suffix("px").to_float()
	if s.ends_with("%"): return s.trim_suffix("%").to_float() / 100.0 * ref
	if s.ends_with("rem"): return s.trim_suffix("rem").to_float() * 16.0
	if s.ends_with("em"): return s.trim_suffix("em").to_float() * fs
	if s.ends_with("vw"): return s.trim_suffix("vw").to_float() / 100.0 * vw
	if s.ends_with("vh") or s.ends_with("dvh") or s.ends_with("svh"): return s.trim_suffix("dvh").trim_suffix("svh").trim_suffix("vh").to_float() / 100.0 * vh
	if s.is_valid_float(): return s.to_float()
	return null

static func _calc(s: String, ref: float, fs: float, vw: float, vh: float) -> float:
	var fn = s.substr(0, s.find("("))
	var inner = s.substr(s.find("(") + 1, s.length() - s.find("(") - 2)
	if fn == "min" or fn == "max" or fn == "clamp":
		var args = []; var cur = ""; var d = 0
		for ch in inner:
			if ch == "(": d += 1
			elif ch == ")": d -= 1
			if ch == "," and d == 0: args.append(cur); cur = ""
			else: cur += ch
		args.append(cur)
		var vals = []
		for a in args:
			var r = px(a.strip_edges(), ref, fs, vw, vh); vals.append(0.0 if r == null else r)
		if fn == "min": return vals.min()
		if fn == "max": return vals.max()
		return clampf(vals[1], vals[0], vals[2])
	# calc：遞迴下降（支援括號、+ - * /）
	var src = inner.replace("(", " ( ").replace(")", " ) ")
	var toks: Array = []
	for t in src.split(" ", false): toks.append(t)
	var st = {"i": 0}
	return _cexpr(toks, st, ref, fs, vw, vh)

static func _cexpr(toks: Array, st: Dictionary, ref: float, fs: float, vw: float, vh: float) -> float:
	var v = _cterm(toks, st, ref, fs, vw, vh)
	while st.i < toks.size() and (toks[st.i] == "+" or toks[st.i] == "-"):
		var op: String = toks[st.i]; st.i += 1
		var r = _cterm(toks, st, ref, fs, vw, vh)
		v = v + r if op == "+" else v - r
	return v
static func _cterm(toks: Array, st: Dictionary, ref: float, fs: float, vw: float, vh: float) -> float:
	var v = _cfac(toks, st, ref, fs, vw, vh)
	while st.i < toks.size() and (toks[st.i] == "*" or toks[st.i] == "/"):
		var op: String = toks[st.i]; st.i += 1
		var r = _cfac(toks, st, ref, fs, vw, vh)
		v = v * r if op == "*" else v / maxf(0.0001, r)
	return v
static func _cfac(toks: Array, st: Dictionary, ref: float, fs: float, vw: float, vh: float) -> float:
	if st.i >= toks.size(): return 0.0
	var t: String = toks[st.i]; st.i += 1
	if t == "(":
		var v = _cexpr(toks, st, ref, fs, vw, vh)
		if st.i < toks.size() and toks[st.i] == ")": st.i += 1
		return v
	if t == "-": return -_cfac(toks, st, ref, fs, vw, vh)
	var r = px(t, ref, fs, vw, vh)
	return 0.0 if r == null else r

static func color(v) -> Color:
	if v == null: return Color(0, 0, 0, 0)
	var s = resolve_var(J.str(v)).strip_edges()
	if s == "" or s == "none" or s == "transparent" or s == "currentColor": return Color(0, 0, 0, 0)
	return Ctx.col(s)
