# 簡易 HTML 解析：innerHTML 字串 → El 樹（夠用嚟執行網頁版各玩法嘅介面）
class_name Html
extends RefCounted

const VOID := {"br": 1, "img": 1, "input": 1, "hr": 1, "meta": 1, "link": 1, "source": 1, "wbr": 1}
const ENT := {"&nbsp;": " ", "&lt;": "<", "&gt;": ">", "&amp;": "&", "&quot;": "\"", "&#39;": "'", "&apos;": "'", "&times;": "×", "&middot;": "·", "&hellip;": "…", "&mdash;": "—", "&ndash;": "–", "&laquo;": "«", "&raquo;": "»", "&#x27;": "'"}

static func decode(s: String) -> String:
	if not s.contains("&"): return s
	for k in ENT: s = s.replace(k, ENT[k])
	var rx = RegEx.create_from_string("&#(x?)([0-9a-fA-F]+);")
	var out = ""; var pos = 0
	for m in rx.search_all(s):
		out += s.substr(pos, m.get_start() - pos)
		out += String.chr(m.get_string(2).hex_to_int() if m.get_string(1) == "x" else m.get_string(2).to_int())
		pos = m.get_end()
	return out + s.substr(pos)

static func parse_into(root: El, html: String) -> void:
	root.children.clear()
	var stack: Array = [root]
	var i = 0; var n = html.length()
	while i < n:
		var lt = html.find("<", i)
		if lt < 0: lt = n
		if lt > i: _text(stack[-1], html.substr(i, lt - i))
		if lt >= n: break
		if html.substr(lt, 4) == "<!--":
			var ce = html.find("-->", lt); i = n if ce < 0 else ce + 3; continue
		var gt = _tag_end(html, lt)
		if gt < 0: _text(stack[-1], html.substr(lt)); break
		var tag = html.substr(lt + 1, gt - lt - 1)
		i = gt + 1
		if tag.begins_with("/"):
			var name = tag.substr(1).strip_edges().to_lower()
			for k in range(stack.size() - 1, 0, -1):
				if (stack[k] as El).tagName.to_lower() == name: stack.resize(k); break
			continue
		if tag.begins_with("!"): continue
		var self_close = tag.ends_with("/")
		if self_close: tag = tag.substr(0, tag.length() - 1)
		var sp = 0
		while sp < tag.length() and not (tag[sp] in [" ", "\n", "\t", "\r"]): sp += 1
		var tname = tag.substr(0, sp).to_lower()
		var el = El.new(tname)
		_attrs(el, tag.substr(sp))
		el.parentNode = stack[-1]; (stack[-1] as El).children.append(el)
		if tname in ["script", "style", "textarea"]:
			var close = html.findn("</" + tname, i)
			var inner = html.substr(i, (n if close < 0 else close) - i)
			if tname == "textarea": el.props["value"] = decode(inner)
			if tname == "style": Css.add_text(inner)
			i = n if close < 0 else html.find(">", close) + 1
			continue
		if not self_close and not VOID.has(tname): stack.append(el)

static func _tag_end(h: String, lt: int) -> int:
	var q = ""; var j = lt + 1
	while j < h.length():
		var c = h[j]
		if q != "":
			if c == q: q = ""
		elif c == "\"" or c == "'": q = c
		elif c == ">": return j
		j += 1
	return -1

static func _text(parent: El, t: String) -> void:
	if t.strip_edges() == "" and not t.contains("\u00a0"):
		if t.length() > 0 and parent.children.size() and t.find("\n") < 0: pass
		else: return
	var e = El.new("#text"); e.props["textContent"] = decode(t); e.parentNode = parent; parent.children.append(e)

static func _attrs(el: El, s: String) -> void:
	var rx = RegEx.create_from_string("([^\\s=\"'/>]+)(?:\\s*=\\s*(?:\"([^\"]*)\"|'([^']*)'|([^\\s>]+)))?")
	for m in rx.search_all(s):
		var k = m.get_string(1).to_lower()
		var v = m.get_string(2)
		if m.get_start(3) >= 0: v = m.get_string(3)
		elif m.get_start(4) >= 0: v = m.get_string(4)
		v = decode(v)
		match k:
			"id":
				el.id_ = v
				if J.host: J.host.register_id(el)
			"class":
				for c in v.split(" ", false): el.classList.d[c] = true
			"style": Css.inline_into(el.style, v)
			"src": el._set(&"src", v)
			"width": el._set(&"width", J.num(v))
			"height": el._set(&"height", J.num(v))
			_:
				if k.begins_with("data-"): el.dataset[_camel(k.substr(5))] = v
				else: el.props[k] = v if m.get_start(2) >= 0 or m.get_start(3) >= 0 or m.get_start(4) >= 0 else true

static func _camel(s: String) -> String:
	var parts = s.split("-"); var o = parts[0]
	for i in range(1, parts.size()): o += parts[i].capitalize().replace(" ", "") if parts[i] != "" else ""
	return o
