# DOM 元素替身：屬性隨便讀寫（記低），常用方法有樁；<canvas> 有 Recorder，<img> 有貼圖
class_name El
extends RefCounted

var tagName = "DIV"
var props = {}
var style = {}
var dataset = {}
var classList: ElClass
var children: Array = []
var parentNode = null
var listeners = {}
var rec: Recorder = null
var ctx2d = null
var tex: Texture2D = null
var id_ = ""

func _init(tag := "div") -> void:
	tagName = tag.to_upper(); classList = ElClass.new()
	if tagName == "CANVAS": rec = Recorder.new()

func js_tex() -> Texture2D: return tex
func js_rec() -> Recorder: return rec

func _get(p: StringName):
	match p:
		&"width": return rec.width if rec else props.get("width", 0.0)
		&"height": return rec.height if rec else props.get("height", 0.0)
		&"naturalWidth": return float(tex.get_width()) if tex else 0.0
		&"naturalHeight": return float(tex.get_height()) if tex else 0.0
		&"complete": return tex != null or not props.has("src")
		&"_ok": return tex != null
		&"id": return id_
		&"className": return " ".join(classList.d.keys())
		&"firstChild", &"firstElementChild": return children[0] if children.size() else null
		&"lastChild", &"lastElementChild": return children[-1] if children.size() else null
		&"childElementCount": return float(children.size())
		&"offsetWidth", &"clientWidth", &"scrollWidth": return props.get("_rect", {}).get("width", props.get("width", 390.0))
		&"offsetHeight", &"clientHeight": return props.get("_rect", {}).get("height", props.get("height", 844.0))
		&"scrollTop", &"scrollLeft", &"scrollHeight": return props.get(String(p), 0.0)
		&"canvas": return null
		&"textContent", &"innerText": return _text()
		&"innerHTML": return props.get("innerHTML", "")
		&"value": return props.get("value", "")
		&"offsetLeft": return props.get("_rect", {}).get("left", 0.0)
		&"offsetTop": return props.get("_rect", {}).get("top", 0.0)
		&"parentElement": return parentNode
		&"nextElementSibling", &"nextSibling":
			if parentNode is El:
				var i: int = parentNode.children.find(self)
				return parentNode.children[i + 1] if i >= 0 and i + 1 < parentNode.children.size() else null
			return null
		&"previousElementSibling", &"previousSibling":
			if parentNode is El:
				var i2: int = parentNode.children.find(self)
				return parentNode.children[i2 - 1] if i2 > 0 else null
			return null
		&"isConnected": return parentNode != null
		&"ownerDocument": return J.G.get("document")
	if props.has(String(p)): return props[String(p)]
	return null

func _set(p: StringName, v) -> bool:
	match p:
		&"width":
			if rec: rec.width = J.num(v); rec.clear()
			props["width"] = J.num(v); return true
		&"height":
			if rec: rec.height = J.num(v); rec.clear()
			props["height"] = J.num(v); return true
		&"src":
			props["src"] = v
			var s = J.str(v)
			if s.begins_with("res://"): tex = load(s)
			if tex != null and J.host: J.host.fire_later(self, "onload")
			elif J.host: J.host.fire_later(self, "onerror")
			return true
		&"id":
			id_ = J.str(v)
			if J.host: J.host.register_id(self)
			return true
		&"className":
			classList.d.clear()
			for c in J.str(v).split(" ", false): classList.d[c] = true
			return true
		&"innerHTML":
			props["innerHTML"] = v; Html.parse_into(self, J.str(v) if v != null else ""); return true
		&"textContent", &"innerText":
			if tagName == "STYLE": Css.add_text(J.str(v))
			children.clear()
			var t = El.new("#text"); t.props["textContent"] = J.str(v) if v != null else ""; t.parentNode = self; children.append(t)
			return true
		&"outerHTML": return true
	props[String(p)] = v
	return true

# 方法
func _js_getContext(_a: Array):
	if rec == null: return null
	if ctx2d == null:
		ctx2d = Ctx.new(rec); ctx2d.canvas = self
	return ctx2d
func _js_appendChild(a: Array):
	var c = a[0]
	if c is El:
		c.parentNode = self; children.append(c)
		if c.tagName == "STYLE": Css.add_text(c._text())
	return c
func _js_append(a: Array) -> void:
	for c in a: _js_appendChild([c])
func _js_prepend(a: Array) -> void:
	for c in a:
		if c is El: c.parentNode = self; children.push_front(c)
func _js_insertBefore(a: Array): return _js_appendChild([a[0]])
func _js_removeChild(a: Array): children.erase(a[0]); return a[0]
func _js_remove(_a: Array) -> void:
	if parentNode is El: parentNode.children.erase(self)
	parentNode = null
	if J.host: J.host.el_removed(self)
func _js_replaceChildren(a: Array) -> void: children.clear(); _js_append(a)
func _js_querySelector(a: Array): return J.host.query(J.str(a[0]), self) if J.host else null
func _js_querySelectorAll(a: Array) -> Array: return J.host.query_all(J.str(a[0]), self) if J.host else []
func _js_getElementsByTagName(_a: Array) -> Array: return []
func _js_closest(a: Array):
	var sel = J.str(a[0]); var e = self
	while e is El:
		if e.tagName != "#TEXT" and Css.sel_matches(e, sel): return e
		e = e.parentNode
	return null
func _text() -> String:
	if tagName == "#TEXT": return J.str(props.get("textContent", ""))
	var o = ""
	for c in children: o += c._text()
	return o
func _js_insertAdjacentHTML(a: Array) -> void:
	var tmp = El.new("div"); Html.parse_into(tmp, J.str(a[1]))
	var where = J.str(a[0])
	for c in tmp.children:
		c.parentNode = self
		if where == "afterbegin": children.insert(0, c)
		else: children.append(c)
func _js_contains(a: Array) -> bool: return a[0] == self or children.has(a[0])
func _js_matches(a: Array) -> bool: return Css.sel_matches(self, J.str(a[0]))
func _js_addEventListener(a: Array) -> void:
	var ev = J.str(a[0])
	if not listeners.has(ev): listeners[ev] = []
	listeners[ev].append(a[1])
func _js_removeEventListener(a: Array) -> void:
	var ev = J.str(a[0])
	if listeners.has(ev): listeners[ev].erase(a[1])
func _js_dispatchEvent(a: Array) -> bool: fire(J.str(J.gp(a[0], "type")), a[0]); return true
func fire(ev: String, e = null) -> void:
	if e == null: e = {"type": ev, "target": self, "currentTarget": self, "preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}
	var h = props.get("on" + ev)
	if h != null: J.cl(h, self, [e])
	for f in listeners.get(ev, []).duplicate(): J.cl(f, self, [e])
func _js_click(_a: Array) -> void: fire("click")
func _js_focus(_a: Array) -> void: pass
func _js_blur(_a: Array) -> void: pass
func _js_select(_a: Array) -> void: pass
func _js_scrollIntoView(_a: Array) -> void: pass
func _js_scrollTo(_a: Array) -> void: pass
func _js_setAttribute(a: Array) -> void:
	var k = J.str(a[0])
	if k == "class": _set(&"className", a[1])
	elif k.begins_with("data-"): dataset[k.substr(5)] = J.str(a[1])
	else: props[k] = a[1]
func _js_getAttribute(a: Array): return props.get(J.str(a[0]))
func _js_removeAttribute(a: Array) -> void: props.erase(J.str(a[0]))
func _js_hasAttribute(a: Array) -> bool: return props.has(J.str(a[0]))
func _js_getBoundingClientRect(_a: Array) -> Dictionary:
	if props.has("_rect"): return props["_rect"]
	var w = J.num(props.get("width", 390.0)); var h = J.num(props.get("height", 844.0))
	if J.host:
		var r = J.host.rect_of(self)
		if r != null: return r
	return {"left": 0.0, "top": 0.0, "x": 0.0, "y": 0.0, "width": w, "height": h, "right": w, "bottom": h}
func _js_animate(_a: Array): return {"onfinish": null, "finished": JSPromise.new(null), "cancel": func(_t, _a2): pass}
func _js_requestFullscreen(_a: Array): return JSPromise.new(null)
func _js_cloneNode(_a: Array) -> El:
	var e = El.new(tagName); e.props = props.duplicate(); return e
func _js_decode(_a: Array) -> JSPromise: return JSPromise.new(null)
func _js_play(_a: Array): return JSPromise.new(null)
func _js_pause(_a: Array) -> void: pass
func _js_toDataURL(_a: Array) -> String: return ""
func _js_setPointerCapture(_a: Array) -> void: pass
func _js_releasePointerCapture(_a: Array) -> void: pass
func _js_getAnimations(_a: Array) -> Array: return []
