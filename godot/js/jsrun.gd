# JS 宿主（autoload JSRun）：計時器、requestAnimationFrame、DOM 替身、localStorage、window/document、模塊載入
extends Node

var timers: Array = []
var tid = 0
var els_by_id = {}
var ls = {}
var _ls_dirty = false
var modules: Array = []
var frame_t = 0.0
var canvas_rects = {}   # El → Callable 回傳 Rect
var skip_title = false

class WinObj:
	extends RefCounted
	func _get(p: StringName):
		var k = String(p)
		match k:
			"innerWidth": return J.G.get("__vw", 390.0)
			"innerHeight": return J.G.get("__vh", 844.0)
			"devicePixelRatio": return 1.0
			"navigator": return J.G.get("navigator")
			"document": return J.G.get("document")
		return J.G.get(k)
	func _set(p: StringName, v) -> bool: J.G[String(p)] = v; return true
	func _js_addEventListener(a: Array) -> void: J.host.win_listen(J.str(a[0]), a[1])
	func _js_removeEventListener(_a: Array) -> void: pass
	func _js_matchMedia(_a: Array) -> Dictionary: return {"matches": false}
	func _js_dispatchEvent(a: Array) -> bool: J.host.win_fire(J.str(J.gp(a[0], "type")), a[0]); return true
	func _js_getComputedStyle(_a: Array) -> Dictionary: return {}
	func _js_scrollTo(_a: Array) -> void: pass
	func _js_open(_a: Array) -> void: pass

class DocObj:
	extends RefCounted
	var body: El
	var head: El
	var documentElement: El
	var hidden = false
	var visibilityState = "visible"
	var activeElement = null
	var fonts = {"ready": JSPromise.new(null)}
	func _init() -> void: body = El.new("body"); head = El.new("head"); documentElement = El.new("html")

var win_listeners = {}
var doc: DocObj

func _ready() -> void:
	J.host = self
	doc = DocObj.new()
	var f = FileAccess.open("user://localStorage.json", FileAccess.READ)
	if f:
		var o = JSON.parse_string(f.get_as_text())
		if o is Dictionary: ls = o
	_init_globals()

func _init_globals() -> void:
	var G = J.G
	G["window"] = WinObj.new(); G["self"] = G["window"]; G["globalThis"] = G["window"]
	G["document"] = doc
	G["navigator"] = {"userAgent": "Godot", "onLine": true, "webdriver": false, "language": "zh-HK", "maxTouchPoints": 5.0, "vibrate": func(_t, _a): return false, "clipboard": {"writeText": func(_t, _a): DisplayServer.clipboard_set(J.str(_a[0])); return JSPromise.new(null)}}
	G["location"] = {"search": "", "hash": "", "protocol": "https:", "hostname": "godot.local", "href": "https://godot.local/", "pathname": "/", "reload": func(_t, _a): J.host.reload_req()}
	G["history"] = {"replaceState": func(_t, _a): pass}
	G["screen"] = {"width": 390.0, "height": 844.0}
	G["Math"] = {}   # Math.* 喺轉譯時已換成原生
	G["__vw"] = 390.0; G["__vh"] = 844.0
	# 內建函數當「值」用（例如 arr.filter(Boolean)、arr.map(Number)）
	G["Boolean"] = func(_t, a): return J.F_Boolean(a)
	G["Number"] = func(_t, a): return J.F_Number(a)
	G["String"] = func(_t, a): return J.F_String(a)
	G["parseInt"] = func(_t, a): return J.F_parseInt(a)
	G["parseFloat"] = func(_t, a): return J.F_parseFloat(a)
	G["isNaN"] = func(_t, a): return J.F_isNaN(a)
	G["isFinite"] = func(_t, a): return J.F_isFinite(a)
	G["setTimeout"] = func(_t, a): return J.F_setTimeout(a)
	G["clearTimeout"] = func(_t, a): J.F_clearTimeout(a); return null
	G["requestAnimationFrame"] = func(_t, a): return J.F_requestAnimationFrame(a)
	G["encodeURIComponent"] = func(_t, a): return J.F_encodeURIComponent(a)

# ---------------- 計時器 ----------------
func timer(fn, ms: float, repeat: bool, raf := false) -> float:
	tid += 1
	timers.append({"id": float(tid), "fn": fn, "at": frame_t + ms / 1000.0, "iv": ms / 1000.0, "rep": repeat, "raf": raf})
	return float(tid)
func clear_timer(id) -> void:
	var n = J.num(id)
	for t in timers:
		if t.id == n: t.dead = true
func _process(dt: float) -> void:
	frame_t += dt
	var due = []
	for t in timers:
		if not t.get("dead", false) and frame_t >= t.at: due.append(t)
	for t in due:
		if t.get("dead", false): continue
		if t.rep: t.at = frame_t + maxf(t.iv, 0.016)
		else: t.dead = true
		var _u = Time.get_ticks_usec()
		J.cl(t.fn, null, [Time.get_ticks_usec() / 1000.0] if t.raf else [])
		if OS.has_environment("GB_PROF") and Time.get_ticks_usec() - _u > 20000: print("[timer] ", (Time.get_ticks_usec() - _u) / 1000.0, "ms raf=", t.raf)
	timers = timers.filter(func(t): return not t.get("dead", false))
	if _ls_dirty: _ls_dirty = false; _save_ls()

func fire_later(el: El, ev: String) -> void:
	timer(func(_t, _a): el.fire(ev), 0.0, false)

# ---------------- window 事件 ----------------
func win_listen(ev: String, f) -> void:
	if not win_listeners.has(ev): win_listeners[ev] = []
	win_listeners[ev].append(f)
func win_fire(ev: String, e = null) -> void:
	if e == null: e = {"type": ev}
	for f in win_listeners.get(ev, []).duplicate(): J.cl(f, null, [e])

# ---------------- localStorage ----------------
func ls_(m: String, a: Array):
	match m:
		"getItem": return ls.get(J.str(a[0]))
		"setItem": ls[J.str(a[0])] = J.str(a[1]); _ls_dirty = true
		"removeItem": ls.erase(J.str(a[0])); _ls_dirty = true
		"clear": ls.clear(); _ls_dirty = true
		"key": var ks = ls.keys(); return ks[int(J.num(a[0]))] if int(J.num(a[0])) < ks.size() else null
	return null
func _save_ls() -> void:
	var f = FileAccess.open("user://localStorage.json", FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(ls))
func flush_ls() -> void: _save_ls()

# ---------------- document ----------------
func document_(m: String, a: Array):
	match m:
		"querySelector": return query(J.str(a[0]), null)
		"getElementById": return by_id(J.str(a[0]))
		"querySelectorAll", "getElementsByClassName", "getElementsByTagName": return query_all(J.str(a[0]), null)
		"createElement": return El.new(J.str(a[0]))
		"createElementNS": return El.new(J.str(a[1]))
		"createTextNode":
			var e = El.new("#text"); e.props["textContent"] = a[0]; return e
		"addEventListener": win_listen("doc:" + J.str(a[0]), a[1])
		"removeEventListener": pass
		"hasFocus": return true
		"elementFromPoint": return null
		"exitFullscreen": return JSPromise.new(null)
	return null

func window_(m: String, a: Array):
	var w = J.G["window"]
	if w.has_method("_js_" + m): return w.callv("_js_" + m, [a])
	var f = J.G.get(m)   # window.L(...) / window.Policy.x 之類：其實係全局
	if f != null: return J.cl(f, null, a)
	return null

func by_id(id: String):
	var e = els_by_id.get(id)
	if e == null: return null
	# 已經唔喺文件入面（innerHTML 換咗）就當冇
	var p = e
	while p is El:
		if p == doc.body: return e
		p = p.parentNode
	return null

func register_id(e: El) -> void: els_by_id[e.id_] = e

# 選擇器（用 Css 引擎）；document 層由 body 搵，搵唔到 #id 就用登記表／臨時元素
func query(sel: String, root):
	sel = sel.strip_edges()
	if root == null and RegEx.create_from_string("^#[\\w-]+$").search(sel): return by_id(sel.substr(1))
	var base: El = root if root is El else doc.body
	var r = _q(base, sel)
	if r == null and root == null and sel.begins_with("#"):
		var id = sel.substr(1)
		for ch in [" ", ".", "[", ":", ">"]:
			var k = id.find(ch)
			if k >= 0: id = id.substr(0, k)
		var host_el: El = by_id(id)
		var rest = sel.substr(1 + id.length()).strip_edges()
		if rest == "": return host_el
		return _q(host_el, rest) if rest[0] != "." and rest[0] != "[" and rest[0] != ":" else (host_el if Css.sel_matches(host_el, sel) else null)
	return r
func _q(base: El, sel: String):
	for c in base.children:
		if c is El and c.tagName != "#TEXT":
			if Css.sel_matches(c, sel): return c
			var r = _q(c, sel)
			if r != null: return r
	return null
func query_all(sel: String, root) -> Array:
	var out = []
	_qa(root if root is El else doc.body, sel.strip_edges(), out)
	return out
func _qa(base: El, sel: String, out: Array) -> void:
	for c in base.children:
		if c is El and c.tagName != "#TEXT":
			if Css.sel_matches(c, sel): out.append(c)
			_qa(c, sel, out)

# shell.html 嘅 <body> 結構放入 document（各玩法嘅 <section> 都喺度）
func boot_dom(html_path: String) -> void:
	Css.load_sheet("res://web/style.css")
	var h = FileAccess.get_file_as_string(html_path)
	var i = h.find("<body>"); var j = h.find("<script>")
	if i >= 0: Html.parse_into(doc.body, h.substr(i + 6, (j if j > i else h.length()) - i - 6))

func el_removed(_e: El) -> void: pass
func rect_of(e: El):
	if canvas_rects.has(e): return canvas_rects[e].call()
	return null
func new_image() -> El: return El.new("img")
func new_canvas(a: Array) -> El:
	var e = El.new("canvas"); e._set(&"width", a[0] if a.size() else 300.0); e._set(&"height", a[1] if a.size() > 1 else 150.0); return e
func stub_obj(_n: String) -> Dictionary: return {}
func reload_req() -> void: reset_world(); get_tree().call_deferred("reload_current_scene")
func reset_world() -> void:
	timers.clear(); els_by_id.clear(); modules.clear(); canvas_rects.clear(); win_listeners.clear()
	J.G.clear(); doc = DocObj.new(); _init_globals()

# ---------------- 模塊 ----------------
func load_modules(names: Array) -> void:
	for n in names:
		var p = "res://jsgen/%s.gd" % n
		if not ResourceLoader.exists(p): push_warning("缺模塊 " + n); continue
		var scr: GDScript = load(p)
		if scr == null or not scr.can_instantiate(): push_error("模塊編譯失敗 " + n); continue
		var m = scr.new(); modules.append(m)
		m.run(null)
