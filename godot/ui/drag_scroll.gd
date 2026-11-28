# [p55] 拖動捲動（掛喺 ScrollContainer 做子節點）：手指喺入面拖過 THRESH px 就當捲動——
#   之後嘅移動全部用嚟捲（唔畀卡／掣食咗），放手有慣性；冇拖過門檻嘅一下撳照舊交俾掣。
#   掣嗰邊：一開始捲就補一下「喺畫面外放手」，個掣唔會觸發、亦唔會卡住撳低樣。
#   用法：DS.attach(scroll)（ScrollContainer 自己嘅拖動 deadzone 會調到好大，避免兩邊一齊捲）
extends Node

const THRESH := 12.0
const DECAY := 5.0
const VMIN := 30.0

var sc: ScrollContainer = null
var _down := false
var _active := false
var _p0 := Vector2.ZERO
var _last := Vector2.ZERO
var _lt := 0.0
var _vel := 0.0
var _fake := false
var _acc := 0.0   # 捲動未用晒嘅小數（scroll_vertical 係 int）

static func attach(s: ScrollContainer) -> Node:
	for c in s.get_children(): if c.get_script() == load("res://ui/drag_scroll.gd"): return c
	var n = load("res://ui/drag_scroll.gd").new(); n.sc = s; n.name = "DragScroll"
	s.add_child(n, false, Node.INTERNAL_MODE_FRONT)
	s.scroll_deadzone = 100000
	return n

func dragging() -> bool: return _active

func _now() -> float: return Time.get_ticks_msec() / 1000.0

func _input(ev: InputEvent) -> void:
	if _fake or sc == null or not sc.is_visible_in_tree(): return
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed:
			if sc.get_global_rect().has_point(ev.position):
				_down = true; _active = false; _p0 = ev.position; _last = ev.position; _lt = _now(); _vel = 0.0; _acc = 0.0
		else:
			if _down and _active: get_viewport().set_input_as_handled()   # 拖完放手：唔畀掣收到
			_down = false; _active = false
	elif ev is InputEventMouseMotion and _down:
		if not (ev.button_mask & MOUSE_BUTTON_MASK_LEFT): _down = false; _active = false; return
		if not _active and absf(ev.position.y - _p0.y) > THRESH:
			_active = true; _cancel_press()
		if _active:
			var dy = ev.position.y - _last.y
			var t = _now(); var dt = maxf(0.001, t - _lt)
			_scroll_by(-dy)
			_vel = lerpf(_vel, -dy / dt, 0.5)
			_last = ev.position; _lt = t
			get_viewport().set_input_as_handled()

func _cancel_press() -> void:   # 補一下畫面外放手：撳低咗嘅掣唔會觸發
	var far = Vector2(-9999, -9999)
	var mv = InputEventMouseMotion.new(); mv.position = far; mv.global_position = far; mv.button_mask = MOUSE_BUTTON_MASK_LEFT   # 先郁出掣外（BaseButton 記低「唔喺掣入面」）
	var e = InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = false; e.position = far; e.global_position = far
	_fake = true; get_viewport().push_input(mv, true); get_viewport().push_input(e, true); _fake = false

func _scroll_by(d: float) -> void:
	_acc += d
	var n = int(_acc); _acc -= n
	if n != 0: sc.scroll_vertical += n

func _process(dt: float) -> void:
	if sc == null or _down: return
	if absf(_vel) < VMIN: _vel = 0.0; return
	var before = sc.scroll_vertical
	_scroll_by(_vel * dt)
	_vel *= exp(-DECAY * dt)
	if sc.scroll_vertical == before and absf(_vel * dt) >= 1.0: _vel = 0.0   # 去到盡頭
