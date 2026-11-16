# 小玩法原生介面嘅底：DOM 根節點收埋（display:none），頂欄／底部面板自己畫，畫布觸控轉返 JS canvas 嘅 pointer 事件
# 子類：GsPanel（冥街）、SpPanel（運動會）。亂葬崗係 GyPanel（較早寫，獨立）
# MiniStage._place 用 stage_rect() 放原生畫布
class_name NatPanel
extends Control

static var by_key := {}

var key := ""
var G: Dictionary          # JS 玩法物件
var ms: Control            # MiniStage
var cv_el = null           # JS <canvas> El（觸控目標）
var touch: Control
var _down := false
var _srect := Rect2()

static func L(s) -> String: return J.str(DB.L(J.str(s)))

static func attach_for(root: String, o, mini: Control) -> void:
	match root:
		"#gstreet":
			if not OS.has_environment("GB_GSDOM"): _attach(GsPanel.new(), root, o, mini)
		"#sports":
			if not OS.has_environment("GB_SPDOM"): _attach(SpPanel.new(), root, o, mini)

static func _attach(p: NatPanel, root: String, o, mini: Control) -> void:
	if not (o is Dictionary): p.free(); return
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: p.free(); return
	close_key(root)
	p.key = root; p.G = o; p.ms = mini; p.name = "NatPanel_" + root.trim_prefix("#")
	main.add_child(p)
	var dom = main.get("dom")
	if dom: main.move_child(p, dom.get_index() + 1)
	by_key[root] = p
	p._follow_dom()
	p._hide_dom(true)
	p._build()
	p._layout()

static func get_for(root: String) -> NatPanel:
	var p = by_key.get(root)
	return p if p != null and is_instance_valid(p) else null

static func close_key(root := "") -> void:
	for k in (by_key.keys() if root == "" else [root]):
		var p = by_key.get(k)
		by_key.erase(k)
		if p != null and is_instance_valid(p): p._restore(); p.queue_free()

func _el(s: String): return JSRun.query(s, null)

# ---------- 子類要寫 ----------
func _build() -> void: pass
func _layout() -> void: pass
func _tick(_dt: float) -> void: pass
func stage_rect() -> Rect2: return _srect   # 相對本 Control

# ---------- DOM ----------
func _hide_dom(on: bool) -> void:
	var e = _el(key)
	if e == null: return
	if on: e.style["display"] = "none"
	else: e.style.erase("display")

func _restore() -> void:
	_hide_dom(false)
	if cv_el is El: JSRun.canvas_rects.erase(cv_el)

func _follow_dom() -> void:
	var dom = get_parent().get("dom") if get_parent() else null
	if dom is Control:
		if position != dom.position: position = dom.position
		if size != dom.size: size = dom.size
	else: size = get_viewport_rect().size

# 設定舞台（畫布）位置；變咗就話俾 JS 知（canvas 嘅 rect 係舞台本地座標：左上 = 0,0）
func _set_stage(r: Rect2) -> bool:
	if touch: touch.position = r.position; touch.size = r.size
	if r == _srect: return false
	_srect = r
	if cv_el is El:
		var w = r.size.x; var h = r.size.y
		JSRun.canvas_rects[cv_el] = func(): return {"left": 0.0, "top": 0.0, "x": 0.0, "y": 0.0, "width": w, "height": h, "right": w, "bottom": h}
	return true

func _make_touch() -> void:
	touch = Control.new(); touch.mouse_filter = Control.MOUSE_FILTER_STOP
	touch.gui_input.connect(_on_touch); add_child(touch); move_child(touch, 0)

func _ev(p: Vector2, t: String) -> Dictionary:
	return {"type": t, "clientX": p.x, "clientY": p.y, "pageX": p.x, "pageY": p.y, "offsetX": p.x, "offsetY": p.y, "pointerId": 1.0, "isPrimary": true,
		"pointerType": "touch", "button": 0.0, "target": cv_el, "currentTarget": cv_el,
		"preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}

func _on_touch(ev: InputEvent) -> void:
	if not (cv_el is El): return
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed: _down = true; cv_el.fire("pointerdown", _ev(ev.position, "pointerdown"))
		elif _down: _down = false; cv_el.fire("pointerup", _ev(ev.position, "pointerup"))
		touch.accept_event()
	elif ev is InputEventMouseMotion:
		cv_el.fire("pointermove", _ev(ev.position, "pointermove"))
		touch.accept_event()

func _process(dt: float) -> void:
	# 上面疊咗另一個玩法（例：冥街開棟篤笑）→ 跟 MiniStage 一齊收埋
	var vis = ms == null or not is_instance_valid(ms) or ms.visible
	if visible != vis: visible = vis
	if not vis: return
	_follow_dom()
	_tick(dt)
	_layout()

# ---------- 共用小件 ----------
func _grad_sb(a: Color, b: Color, pad: Vector4, radius_top := 0) -> StyleBoxTexture:
	var g = Gradient.new(); g.colors = PackedColorArray([a, b])
	var s = StyleBoxTexture.new(); s.texture = GradTex.vertical(g, 4, 32)   # 唔用 GradientTexture2D（Adreno 閃退）
	s.content_margin_left = pad.x; s.content_margin_top = pad.y; s.content_margin_right = pad.z; s.content_margin_bottom = pad.w
	return s

func _click(sel: String) -> void:
	var e = _el(sel)
	if not (e is El) or J.t(e.props.get("disabled")): return
	e.fire("click", {"type": "click", "target": e, "currentTarget": e, "preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass})
