# 小玩法通用原生畫布（線 I）：冥街夜市、亂葬崗、運動會……
#  - 規則、AI、DOM 介面（面板、按鈕）照用轉譯 JS；只係 <canvas> 嗰塊改由原生喺 _draw 直接叫 obj.draw()（唔經錄製器）
#  - 原生節點放喺 DOM 下面，位置跟 DOM canvas 嘅版面；canvas 本身留空（透明），所以觸控仍然係 DOM canvas 收
#  - 村子畫布收起（被蓋住都照畫，浪費）
class_name MiniStage
extends Control

static var cur: MiniStage = null

var obj: Dictionary
var sel := ""
var root_sel := ""
var draw_m := "draw"
var bottom_sel := ""   # 有呢個就唔信 sel 嘅高度：畫面底 = 根節點底 − 呢個元素高度（亂葬崗：canvas 一開始被撐大，flex 縮唔返）
var canvas_sel := ""   # 放位用外框（sel），canvas 本身另外指定：canvas 改成 absolute 鋪滿外框，唔再撐大 flex 版面
var stage: Control
var _hidden: Array = []
var _bg_saved := {}
var prof_d := 0
var prof_n := 0

static func hook(o, cv_sel: String, root: String, method := "draw", canvas_sel := "", bottom := "") -> bool:
	if not (o is Dictionary) or OS.has_environment("GB_NOMINI"): return false
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	end_hook()
	var r = MiniStage.new(); r.name = "MiniStage"; r.obj = o; r.sel = cv_sel; r.root_sel = root; r.draw_m = method; r.canvas_sel = canvas_sel; r.bottom_sel = bottom
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())
	cur = r
	r._build()
	return true

static func end_hook() -> void:
	GyEnd.close()
	if cur == null or not is_instance_valid(cur): cur = null; return
	cur._cover(false); cur.queue_free(); cur = null

static func size_of() -> Array:
	if cur == null or not is_instance_valid(cur): return [390.0, 560.0]
	cur._place(); return [cur.stage.size.x, cur.stage.size.y]

static func active_for(o) -> bool: return cur != null and is_instance_valid(cur) and cur.obj == o

func _build() -> void:
	var bg = ColorRect.new(); bg.color = Color("#0c0a12"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	stage = Control.new(); stage.clip_contents = true; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.draw.connect(_draw_stage); add_child(stage)
	_cover(true)
	_place()
	if OS.has_environment("GB_NODOM"):
		var d = get_parent().get("dom"); d.visible = false; d.process_mode = Node.PROCESS_MODE_DISABLED

func _el(s: String): return JSRun.query(s, null)

# DOM 嗰邊：根節點同 canvas 外框背景改透明，等原生畫面透出嚟
func _cover(on: bool) -> void:
	var main = get_parent()
	if on:
		var v = main.get("village")
		if v is CanvasItem and v.visible:
			v.visible = false; v.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(v)
		if canvas_sel != "":
			var cv = _el(canvas_sel)
			if cv: for kv in [["position", "absolute"], ["left", "0px"], ["top", "0px"]]: cv.style[kv[0]] = kv[1]
		for s in [root_sel, sel]:
			var e = _el(s)
			if e == null: continue
			_bg_saved[s] = e.style.get("background")
			e.style["background"] = "transparent"
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true; n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()
		for s in _bg_saved:
			var e = _el(s)
			if e == null: continue
			if _bg_saved[s] == null: e.style.erase("background")
			else: e.style["background"] = _bg_saved[s]

func _place() -> void:
	var e = _el(sel)
	if e == null: return
	var r = e._js_getBoundingClientRect([])
	var p = Vector2(J.num(r.get("left", 0)), J.num(r.get("top", 0))); var s = Vector2(J.num(r.get("width", 0)), J.num(r.get("height", 0)))
	if bottom_sel != "":
		var b = _el(bottom_sel); var rt = _el(root_sel)
		if b and rt:
			var rr = rt._js_getBoundingClientRect([]); var br = b._js_getBoundingClientRect([])
			s.y = maxf(60.0, J.num(rr.get("bottom", 845)) - J.num(br.get("height", 0)) - p.y)
	var dom = get_parent().get("dom")
	if dom is Control: p += dom.position
	if stage.position != p: stage.position = p
	if stage.size != s:
		stage.size = s
		# 版面定咗先叫 JS resize（Godot 冇 ResizeObserver；開場時 canvas 未排版）
		if s.x > 0 and s.y > 0 and obj.get("resize") != null: J.mc(obj, "resize", [])

func _process(_dt: float) -> void:
	if not J.t(obj.get("active")) and obj.get("active") != null:
		return
	_place()
	stage.queue_redraw()

func _draw_stage() -> void:
	var ctx = Ctx.new(stage)
	obj["_natCtx"] = ctx
	var t0 = Time.get_ticks_usec()
	var cp = OS.has_environment("GB_CTXPROF") and prof_n == 29
	if cp: J.CTXPROF.clear(); J.CTXPROF_ON = true
	J.mc(obj, draw_m, [Time.get_ticks_msec() / 1000.0])
	if cp:
		J.CTXPROF_ON = false; var ks = J.CTXPROF.keys().filter(func(k): return not k.begins_with("#"))
		ks.sort_custom(func(a, b): return J.CTXPROF[a] > J.CTXPROF[b])
		print("[ctx] ", ", ".join(ks.slice(0, 14).map(func(k): return "%s %.1f(%d)" % [k, J.CTXPROF[k] / 1000.0, J.CTXPROF["#" + k]])))
	obj["_natCtx"] = null
	if OS.has_environment("GB_PROF"):
		prof_d += Time.get_ticks_usec() - t0; prof_n += 1
		if prof_n >= 30:
			print("[mini] draw=%.1fms js_timers=%.1fms" % [prof_d / 30000.0, JSRun.prof_timer / 30000.0]); JSRun.prof_timer = 0
			prof_d = 0; prof_n = 0

