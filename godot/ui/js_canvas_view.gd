# 顯示一塊 JS <canvas>（錄製器）並把觸控轉成 pointer 事件
extends Control

var el: El
var last_ver := -1

func bind(e: El) -> void:
	el = e
	mouse_filter = Control.MOUSE_FILTER_STOP
	JSRun.canvas_rects[el] = func(): return {"left": 0.0, "top": 0.0, "x": 0.0, "y": 0.0, "width": size.x, "height": size.y, "right": size.x, "bottom": size.y}
	resized.connect(func(): el.props["width"] = size.x; el.props["height"] = size.y; JSRun.win_fire("resize"))

func _process(_dt: float) -> void:
	if el != null and visible: queue_redraw()

func _draw() -> void:
	if el == null or el.rec == null: return
	# 網頁版 canvas.width = CSS 寬 × dpr（dpr=1），所以直接 1:1
	var sx := size.x / maxf(1.0, el.rec.width)
	var sy := size.y / maxf(1.0, el.rec.height)
	var t0 := Time.get_ticks_usec()
	el.rec.replay(self, Transform2D(Vector2(sx, 0), Vector2(0, sy), Vector2.ZERO))
	el.rec.stale = true   # JS 下一幀第一筆就清走舊指令
	if OS.has_environment("GB_PROF"): print("[draw] cmds=", el.rec.cmds.size(), " replay=", (Time.get_ticks_usec() - t0) / 1000.0, "ms")

func _ev(p: Vector2, extra := {}) -> Dictionary:
	var e := {"clientX": p.x, "clientY": p.y, "pageX": p.x, "pageY": p.y, "offsetX": p.x, "offsetY": p.y, "button": 0.0, "pointerId": 1.0, "isPrimary": true, "pointerType": "touch", "target": el,
		"preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}
	e.merge(extra, true)
	e["touches"] = [{"clientX": p.x, "clientY": p.y}]; e["changedTouches"] = e["touches"]
	return e

func _gui_input(ev: InputEvent) -> void:
	if el == null: return
	if ev is InputEventMouseButton:
		var p: Vector2 = ev.position
		if ev.button_index == MOUSE_BUTTON_WHEEL_DOWN or ev.button_index == MOUSE_BUTTON_WHEEL_UP:
			if ev.pressed: el.fire("wheel", _ev(p, {"type": "wheel", "deltaY": 60.0 if ev.button_index == MOUSE_BUTTON_WHEEL_DOWN else -60.0}))
			return
		if ev.button_index != MOUSE_BUTTON_LEFT: return
		if ev.pressed:
			el.fire("pointerdown", _ev(p, {"type": "pointerdown"})); el.fire("mousedown", _ev(p, {"type": "mousedown"})); el.fire("touchstart", _ev(p, {"type": "touchstart"}))
		else:
			el.fire("pointerup", _ev(p, {"type": "pointerup"})); JSRun.win_fire("pointerup", _ev(p, {"type": "pointerup"}))
			el.fire("mouseup", _ev(p, {"type": "mouseup"})); el.fire("touchend", _ev(p, {"type": "touchend"})); el.fire("click", _ev(p, {"type": "click"}))
	elif ev is InputEventMouseMotion:
		var p2: Vector2 = ev.position
		el.fire("pointermove", _ev(p2, {"type": "pointermove"})); JSRun.win_fire("pointermove", _ev(p2, {"type": "pointermove"}))
		if ev.button_mask & MOUSE_BUTTON_MASK_LEFT: el.fire("touchmove", _ev(p2, {"type": "touchmove"}))
