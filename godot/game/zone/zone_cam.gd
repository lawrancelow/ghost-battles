# [zone] 分區地圖鏡頭：上下左右拖動、兩指縮放、滾輪縮放、慣性、邊界夾住；單指撳＝點擊（拖過就唔當撳）
# 冇 class_name（熱更新規矩）：var cam = load("res://game/zone/zone_cam.gd").new()
#   x, y：鏡頭左上角（世界座標）；z：縮放（畫面 px ÷ 世界單位）
#   view：畫面大細（px）；world：世界大細；top_extra：頂部可以拉過界嘅世界高度（HUD 蓋住嗰段）
#   handle(ev) → 回 {"tap": 畫面座標} 或者 {}；step(dt) 行慣性
extends RefCounted

const TAP_SLOP := 10.0        # 手指郁超過呢個 px 就當拖動
const MAX_UNITS := 300.0      # 最大縮放：畫面闊最少睇到 300 世界單位
const FRICTION := 0.04        # 慣性：每秒剩 4% 速度

var x := 0.0
var y := 0.0
var z := 1.0
var view := Vector2(390, 700)
var world := Vector2(390, 1130)
var top_extra := 0.0
var vel := Vector2.ZERO
var tgt = null                # 平滑移動目標（左上角）
var touches := {}             # index → 位置（畫面）
var _press = null             # {"p","moved","last","lt"}
var _pinch = null             # {"d0","z0","mid_w"}
var _t := 0.0
var _touch_seen := false
var dragging := false

func z_min() -> float: return view.x / maxf(1.0, world.x)          # 睇到成張圖闊度
func z_max() -> float: return maxf(z_min(), view.x / MAX_UNITS)
func vw() -> float: return view.x / z
func vh() -> float: return view.y / z
func s2w(p: Vector2) -> Vector2: return Vector2(x, y) + p / z
func w2s(p: Vector2) -> Vector2: return (p - Vector2(x, y)) * z
func rect() -> Rect2: return Rect2(x, y, vw(), vh())

func clamp_all() -> void:
	z = clampf(z, z_min(), z_max())
	var w = vw(); var h = vh()
	if w >= world.x: x = (world.x - w) / 2.0
	else: x = clampf(x, 0.0, world.x - w)
	if h >= world.y + top_extra: y = (world.y - h) / 2.0
	else: y = clampf(y, -top_extra, world.y - h)

func set_zoom(nz: float, about: Vector2) -> void:   # about：畫面座標（縮放時呢點唔郁）
	var wp = s2w(about)
	z = clampf(nz, z_min(), z_max())
	x = wp.x - about.x / z; y = wp.y - about.y / z
	clamp_all()
func center_on(p: Vector2) -> void:
	x = p.x - vw() / 2.0; y = p.y - vh() / 2.0; clamp_all()
func glide_to(p: Vector2) -> void:   # 平滑移去（中心）
	var w = vw(); var h = vh()
	tgt = Vector2(p.x - w / 2.0, p.y - h / 2.0); vel = Vector2.ZERO

func step(dt: float) -> void:
	_t += dt
	if dragging or _pinch != null: return
	if tgt != null:
		var o = Vector2(x, y); var n = o.lerp(tgt, minf(1.0, dt * 7.0))
		x = n.x; y = n.y
		var before = Vector2(x, y); clamp_all()
		if n.distance_to(tgt) < 0.5 or Vector2(x, y).distance_to(before) > 0.01: tgt = null
		return
	if vel.length() > 4.0:
		x += vel.x * dt; y += vel.y * dt
		vel *= pow(FRICTION, dt)
		var b = Vector2(x, y); clamp_all()
		if absf(b.x - x) > 0.01: vel.x = 0.0
		if absf(b.y - y) > 0.01: vel.y = 0.0
	else: vel = Vector2.ZERO

# 輸入（畫面座標）。觸控同滑鼠都收：有觸控事件就唔理模擬出嚟嘅滑鼠
func handle(ev: InputEvent) -> Dictionary:
	if ev is InputEventScreenTouch:
		_touch_seen = true
		if ev.pressed:
			touches[ev.index] = ev.position
			if touches.size() == 1: _down(ev.position)
			elif touches.size() == 2: _pinch_begin()
		else:
			touches.erase(ev.index)
			if touches.size() < 2 and _pinch != null:
				_pinch = null
				if _press != null: _press.moved = true   # 縮放過：放手唔當撳
				if touches.size() == 1:
					var p = touches.values()[0]; _press.last = p; _press.p = p
			if touches.is_empty(): return _up(ev.position)
		return {}
	if ev is InputEventScreenDrag:
		_touch_seen = true
		touches[ev.index] = ev.position
		if touches.size() >= 2: _pinch_move()
		elif _press != null: _move(ev.position)
		return {}
	if ev is InputEventMouseButton:
		if ev.button_index == MOUSE_BUTTON_WHEEL_UP and ev.pressed: set_zoom(z * 1.12, ev.position); return {}
		if ev.button_index == MOUSE_BUTTON_WHEEL_DOWN and ev.pressed: set_zoom(z / 1.12, ev.position); return {}
		if ev.button_index != MOUSE_BUTTON_LEFT or not touches.is_empty(): return {}
		if ev.pressed: _down(ev.position)
		else: return _up(ev.position)
	elif ev is InputEventMouseMotion and _press != null and touches.is_empty():
		_move(ev.position)
	elif ev is InputEventMagnifyGesture:
		set_zoom(z * ev.factor, ev.position)
	elif ev is InputEventPanGesture:
		x += ev.delta.x * 8.0 / z; y += ev.delta.y * 8.0 / z; clamp_all()
	return {}

func _down(p: Vector2) -> void:
	_press = {"p": p, "moved": false, "last": p, "lt": _t}
	vel = Vector2.ZERO; tgt = null
func _move(p: Vector2) -> void:
	if _press == null: return
	if not _press.moved and p.distance_to(_press.p) > TAP_SLOP: _press.moved = true; dragging = true; _press.last = p
	if not _press.moved: return
	var d = p - _press.last
	x -= d.x / z; y -= d.y / z; clamp_all()
	var dtm = maxf(0.008, _t - float(_press.lt))
	vel = vel.lerp(-d / z / dtm, 0.5)
	_press.last = p; _press.lt = _t
func _up(p: Vector2) -> Dictionary:
	var pr = _press; _press = null; dragging = false
	if pr == null: return {}
	if pr.moved:
		if _t - float(pr.lt) > 0.12: vel = Vector2.ZERO   # 停咗先放手：冇慣性
		return {"drag": true}
	vel = Vector2.ZERO
	return {"tap": pr.p}
func _pinch_begin() -> void:
	var ps = touches.values()
	_pinch = {"d0": maxf(10.0, ps[0].distance_to(ps[1])), "z0": z, "m0": (ps[0] + ps[1]) / 2.0}
	_pinch["w0"] = s2w(_pinch.m0)
	if _press != null: _press.moved = true
	dragging = true; vel = Vector2.ZERO
func _pinch_move() -> void:
	if _pinch == null: _pinch_begin()
	var ps = touches.values()
	var d = maxf(10.0, ps[0].distance_to(ps[1])); var m = (ps[0] + ps[1]) / 2.0
	z = clampf(float(_pinch.z0) * d / float(_pinch.d0), z_min(), z_max())
	x = _pinch.w0.x - m.x / z; y = _pinch.w0.y - m.y / z   # 兩指中點對住嘅世界點唔郁（順便平移）
	clamp_all()
