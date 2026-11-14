# 樓裡有鬼（原生外殼）
#  - 規則／住戶 AI／電梯／入屋：照用 tower.js（數值一模一樣，存檔 S.tower 同網頁版互通）
#  - 畫面：原生喺 _draw 直接叫 TWX.draw()（主樓剖面＋HUD）、LIFT.drawW()（電梯世界層，喺 HUD 之前）、UNIT.drawN()（入屋）
#    → 唔經錄製器、唔經 DOM；蠟筆框／紙紋離屏畫布由 Ctx 拍成貼圖
#  - 電梯面板（𨋢廂內景＋樓層掣＋開關門＋作怪招）原生：以前係 DOM 疊層
#  - 輸入：原生收觸控，轉做邏輯座標交返 tower.js 嘅 pointer 處理（主樓／入屋各自一套）
class_name TwRun
extends Control

static var cur: TwRun = null
const LW := 390.0           # 邏輯闊度（同網頁版手機一樣）

var NT: Dictionary          # window.__twNat：{w, h, s, ctx, cab}
var s := 1.0
var stage: Control
var cab: Control
var lpanel: Control
var lblock: Control
var _hidden: Array = []
var _down := false
var _lift_on := false
var _lui = null
var _lbtns: Array = []      # [{r: Rect2(邏輯), f: Callable, id}]
var _lpress := ""
var _lpress_t := 0
var _mk := {}
var _mk1 := []
var _mk_last := 0
var prof_d := 0
var prof_n := 0

static func js(n: String): return J.G.get(n)
static func TWX(): return J.G.get("TWX")

# ---------------- tower.js open()/close() 叫 ----------------
static func hook(on: bool) -> bool:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if not on:
		if cur != null and is_instance_valid(cur):
			cur._cover(false); cur.queue_free()
		cur = null; J.G["__twNat"] = null
		return true
	if cur != null and is_instance_valid(cur): cur._cover(false); cur.queue_free()
	var r = TwRun.new(); r.name = "TwRun"
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var dom = main.get("dom")
	if dom: main.move_child(r, dom.get_index())
	cur = r
	r._build()
	r._cover(true)
	return true

func _cover(on: bool) -> void:
	var main = get_parent()
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and n.visible:
				n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true; n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()

# ---------------- 版面 ----------------
func _build() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage = Control.new(); stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); stage.mouse_filter = Control.MOUSE_FILTER_STOP
	stage.draw.connect(_draw_stage); stage.gui_input.connect(_stage_input); add_child(stage)
	cab = Control.new(); cab.mouse_filter = Control.MOUSE_FILTER_STOP; cab.visible = false; cab.clip_contents = true
	cab.draw.connect(_draw_cab); add_child(cab)
	lblock = Control.new(); lblock.mouse_filter = Control.MOUSE_FILTER_STOP; lblock.visible = false; add_child(lblock)
	lpanel = Control.new(); lpanel.mouse_filter = Control.MOUSE_FILTER_STOP; lpanel.visible = false
	lpanel.draw.connect(_draw_lpanel); lpanel.gui_input.connect(_lpanel_input); add_child(lpanel)
	# 作怪招喺 cab 底：都係 lpanel 畫（整個面板係一塊全屏透明節點）
	lpanel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fit()
	resized.connect(_fit)

func _fit() -> void:
	var w = maxf(1.0, size.x); var h = maxf(1.0, size.y)
	s = w / LW
	NT = {"w": LW, "h": h / s, "s": s, "ctx": null, "cab": null}
	J.G["__twNat"] = NT
	var X = TWX()
	if X != null: J.cl(X.resize, null, [])

# ---------------- 每幀 ----------------
func _process(_dt: float) -> void:
	var X = TWX()
	if X == null or not J.t(J.cl(X.open, null, [])): return
	stage.queue_redraw()
	_update_lift()

func _unit():
	var X = TWX(); return X.unit if X != null else null
func _lift():
	var X = TWX(); return X.lift if X != null else null
func _covering() -> bool:
	var U = _unit()
	return U != null and J.t(J.mc(U, "covering", []))

func _draw_stage() -> void:
	var X = TWX()
	if X == null: return
	var t0 = Time.get_ticks_usec()
	var ctx = Ctx.new(stage)
	NT["ctx"] = ctx
	if OS.has_environment("GB_TWMARK"):
		_mk_last = Time.get_ticks_usec()
		if prof_n == 29: _mk1.clear()
		J.G["__twMark"] = func(_t, a):
			var now = Time.get_ticks_usec(); var k = J.str(a[0]); _mk[k] = _mk.get(k, 0) + now - _mk_last
			if prof_n == 29: _mk1.append("%s=%.1f" % [k, (now - _mk_last) / 1000.0])
			_mk_last = now
	var cp = OS.has_environment("GB_CTXPROF") and prof_n == 29
	if cp: J.CTXPROF.clear(); J.CTXPROF_ON = true
	if _covering(): J.mc(_unit(), "drawN", [ctx])
	else: J.cl(X.draw, null, [ctx])
	if cp:
		J.CTXPROF_ON = false; var ks = J.CTXPROF.keys().filter(func(k): return not k.begins_with("#"))
		ks.sort_custom(func(a, b): return J.CTXPROF[a] > J.CTXPROF[b])
		var tot = 0
		for k in ks: tot += J.CTXPROF[k]
		print("[ctx] total=%.1fms " % (tot / 1000.0), ", ".join(ks.slice(0, 14).map(func(k): return "%s %.1f(%d)" % [k, J.CTXPROF[k] / 1000.0, J.CTXPROF["#" + k]])))
	NT["ctx"] = null
	if OS.has_environment("GB_TWMARK"): _mk["hud+"] = _mk.get("hud+", 0) + Time.get_ticks_usec() - _mk_last
	if OS.has_environment("GB_PROF"):
		prof_d += Time.get_ticks_usec() - t0; prof_n += 1
		if prof_n >= 30:
			print("[tower] draw=%.1fms js_timers=%.1fms" % [prof_d / 30000.0, JSRun.prof_timer / 30000.0]); JSRun.prof_timer = 0
			print("[twmark1] ", ", ".join(_mk1))
			if _mk.size(): print("[twmark] ", ", ".join(_mk.keys().map(func(k): return "%s=%.1f" % [k, _mk[k] / 30000.0]))); _mk.clear()
			prof_d = 0; prof_n = 0

# ---------------- 輸入 ----------------
var _pid := 1
func _ev(p: Vector2) -> Dictionary:
	var q = p / s
	return {"nx": q.x, "ny": q.y, "clientX": q.x, "clientY": q.y, "pointerId": float(_pid), "isPrimary": true, "button": 0.0,
		"stopPropagation": func(_t, _a): pass, "preventDefault": func(_t, _a): pass}

func _stage_input(ev: InputEvent) -> void:
	var kind := ""; var p := Vector2.ZERO
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		p = ev.position; kind = "PD" if ev.pressed else "PU"
	elif ev is InputEventMouseMotion and _down:
		p = ev.position; kind = "PM"
	else: return
	if kind == "PD": _down = true
	if kind == "PU": _down = false
	var pre = "__twU" if _covering() else "__tw"
	var f = J.G.get(pre + kind)
	if f != null: J.cl(f, null, [_ev(p)])
	accept_event()

# ---------------- 電梯面板（原生） ----------------
func _update_lift() -> void:
	var L = _lift()
	var u = J.mc(L, "ui", []) if L != null and not _covering() else null
	var on = u is Dictionary
	if on != _lift_on:
		_lift_on = on; cab.visible = on; lpanel.visible = on; lblock.visible = on
	_lui = u
	if not on: return
	var lo = J.mc(L, "layoutN", [])
	var top = J.num(J.cl(TWX().top, null, [])); var cabH = J.num(lo.H)
	var bot = maxf(J.num(J.cl(TWX().bot, null, [])), 200.0)
	cab.position = Vector2(0, top * s); cab.size = Vector2(size.x, cabH * s)
	lblock.position = Vector2(0, (top + cabH) * s); lblock.size = Vector2(size.x, maxf(0, (NT.h - bot - top - cabH) * s))
	cab.queue_redraw(); lpanel.queue_redraw()

func _draw_cab() -> void:
	var L = _lift()
	if L == null or not _lift_on: return
	var ctx = Ctx.new(cab)
	NT["cab"] = ctx
	J.mc(L, "drawCabN", [])
	NT["cab"] = null

func _cr(): return TWX().cr
func _txt(ctx, t: String, x: float, y: float, sz: float, col: String, al := "center", mw := 0.0) -> void:
	J.cl(_cr().text, null, [ctx, t, x, y, sz, col, al, mw if mw > 0 else null, true])

func _btn(ctx, id: String, r: Rect2, label: String, tone: String, off: bool, f: Callable) -> void:
	_lbtns.append({"r": r, "f": f, "id": id, "off": off})
	var pz = _lpress == id and Time.get_ticks_msec() - _lpress_t < 200
	J.cl(_cr().btn, null, [ctx, r.position.x, r.position.y, r.size.x, r.size.y, label, tone, pz, off])

func _draw_lpanel() -> void:
	_lbtns.clear()
	var L = _lift(); var u = _lui
	if L == null or not (u is Dictionary): return
	var ctx = Ctx.new(lpanel)
	ctx.setTransform(s, 0, 0, s, 0, 0)
	var W = LW; var H = J.num(NT.h)
	var top = J.num(J.cl(TWX().top, null, [])); var bot = maxf(J.num(J.cl(TWX().bot, null, [])), 200.0)
	var cabH = cab.size.y / s
	# 作怪招（cab 底）
	var TR = L.TR; var tricks = []
	var f = int(J.num(u.f)); var inn = int(J.num(u.inn))
	for k in L.TRK:
		var ok = J.mc(L, "canTrick", [k])
		var show = (ok is bool and ok) or (J.str(ok) == "cd" and ((k == "door" and J.t(u.waitHere)) or (k != "door" and inn > 0))) or J.str(ok) == "busy"
		if show: tricks.append([k, ok])
	if tricks.size():
		var tw = minf(76.0, (W - 12 - 5 * (tricks.size() - 1)) / tricks.size()); var tx = (W - (tw * tricks.size() + 5 * (tricks.size() - 1))) / 2
		for tk in tricks:
			var k = J.str(tk[0]); var ok = tk[1]; var en = ok is bool and ok
			var sub = (str(ceil(J.num(u.cd.get(k, 0)))) + "s") if J.str(ok) == "cd" else ("進行中" if J.str(ok) == "busy" else ("怕 +" + str(int(J.num(TR[k].f)))))
			var kk = k
			_btn(ctx, "t_" + k, Rect2(tx, top + cabH - 58, tw, 52), "", "red", not en, func(): J.mc(L, "trick", [kk]))
			_txt(ctx, J.str(TR[k].n), tx + tw / 2, top + cabH - 38, 14, "#f2e3cc" if en else "#8a7e84")
			_txt(ctx, sub, tx + tw / 2, top + cabH - 19, 11, "#e8c4b0" if en else "#8a7e84")
			tx += tw + 5
	# 底面板
	var y0 = H - bot
	J.cl(_cr().panel, null, [ctx, -8, y0, W + 16, bot + 8, "paper"])
	var stTxt = {"idle": "停定", "closed": "停定", "move": ("▲ 上緊" if J.num(u.dir) > 0 else "▼ 落緊"), "opening": "開門中", "open": "門開咗", "closing": "閂門中", "stuckMove": "⚠ 卡住", "stuck": "⚠ 卡咗喺兩層中間", "unstick": "⚠ 重新起動"}.get(J.str(u.st), "")
	var dest = []
	for d in u.stops: dest.append(J.str(J.cl(L.lab, null, [d])))
	var st = J.str(u.msg) if J.str(u.msg) != "" else ("%s 樓｜%s%s｜𨋢內 %d 人%s" % [J.str(J.cl(L.lab, null, [float(f)])), stTxt, ("｜去 " + "、".join(dest)) if dest.size() else "", inn, "" if tricks.size() else "（冇人一齊搭）"])
	_txt(ctx, st, W / 2, y0 + 26, 15, "#e6a85a", "center", W - 16)
	# 樓層掣
	var n = int(J.num(u.top)) + 1
	var cols = n if n <= 7 else mini(7, ceili(n / 2.0))
	if n > 14: cols = ceili(n / 3.0)
	var rows = ceili(float(n) / cols)
	var bw = minf(56.0, (W - 16 - 6 * (cols - 1)) / cols); var bh = 48.0
	var gx = (W - (bw * cols + 6 * (cols - 1))) / 2; var gy = y0 + 40
	var lit = {}
	for v in u.lit: lit[int(J.num(v))] = true
	var i = 0
	for fl in range(n - 1, -1, -1):
		var r = Rect2(gx + (i % cols) * (bw + 6), gy + (i / cols) * (bh + 6), bw, bh)
		var curf = fl == f and J.t(u.at)
		var tone = "moss" if curf else ("rust" if (lit.has(fl) or J.t(u.all)) else "bone")
		var ff = float(fl)
		_btn(ctx, "f%d" % fl, r, J.str(J.cl(L.lab, null, [ff])), tone, false, func(): J.mc(L, "press", [ff]))
		i += 1
	# 開關門／出𨋢
	var dy = gy + rows * (bh + 6) + 2
	var dw = (W - 16 - 12) / 3.0
	var can_exit = J.str(u.st) == "open" and J.num(u.door) > 0.8 and J.t(u.at)
	_btn(ctx, "open", Rect2(8, dy, dw, 52), "◀▶ 開門", "ink", false, func(): J.mc(L, "open", []))
	_btn(ctx, "close", Rect2(8 + dw + 6, dy, dw, 52), "▶◀ 關門", "ink", false, func(): J.mc(L, "close", []))
	_btn(ctx, "exit", Rect2(8 + (dw + 6) * 2, dy, dw, 52), "出𨋢", "moss", not can_exit, func(): J.mc(L, "exit", []))

func _lpanel_input(ev: InputEvent) -> void:
	if not (ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT and ev.pressed): return
	var q = ev.position / s
	for b in _lbtns:
		if (b.r as Rect2).grow(4).has_point(q):
			_lpress = b.id; _lpress_t = Time.get_ticks_msec()
			b.f.call(); Snd.play("click"); accept_event(); lpanel.queue_redraw(); return
	# 面板以外（頂欄）：交返主樓
	var top = J.num(J.cl(TWX().top, null, []))
	if q.y < top:
		_down = true
		var f = J.G.get("__twPD"); if f != null: J.cl(f, null, [_ev(ev.position)])
		var f2 = J.G.get("__twPU"); if f2 != null: J.cl(f2, null, [_ev(ev.position)])
		_down = false
	accept_event()

# ---------------- 測試 ----------------
static func t_info() -> void:
	var X = TWX()
	print("TW scene=", J.cl(X.scene, null, []), " lift=", cur._lift_on if cur else null, " unit=", cur._covering() if cur else null)

# ---------------- 蠟筆字（tower.js crText 原生版）：偏移暗影＋暗描邊＋主色＋淡重描 ----------------
# 網頁版每個字要叫四次 fillText/strokeText＋save/restore，喺轉譯 JS 入面好慢；呢度一次過畫
static var _tw_cache := {}
static func cr_text(c, s: String, x: float, y: float, sz: float, col, al: String, mw: float, mid: bool, wt: String) -> void:
	if not (c is Ctx): return
	var ctx: Ctx = c
	var ga: float = ctx.globalAlpha
	if ga <= 0.001 or s == "": return
	var weight = 700 if wt == "bold" else (900 if wt == "900" else 400)
	var f: Font = Ctx.font_res("sans", weight)
	var isz = int(round(sz))
	if ctx.ci is Recorder:
		# 離屏畫布：照舊用 Ctx 指令（錄製器識）
		ctx.save(); ctx.font = "%s %dpx sans-serif" % [wt, isz]; ctx.textAlign = al; ctx.textBaseline = "middle" if mid else "alphabetic"
		ctx.fillStyle = "rgba(6,3,8,0.88)"; ctx.fillText(s, x + 1.4, y + 2); ctx.lineWidth = maxf(2.4, sz * 0.2); ctx.strokeStyle = "rgba(8,5,10,0.82)"; ctx.strokeText(s, x, y)
		ctx.fillStyle = col; ctx.fillText(s, x, y); ctx.globalAlpha *= 0.35; ctx.fillText(s, x + 0.6, y - 0.4); ctx.restore(); return
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, isz).x
	var k = 1.0
	if mw > 0 and w > mw: k = mw / w
	var ox = 0.0
	if al == "center": ox = -w * k / 2.0
	elif al == "right" or al == "end": ox = -w * k
	var oy = 0.0
	if mid: oy = (f.get_ascent(isz) - f.get_descent(isz)) / 2.0
	var M: Transform2D = ctx.T * Transform2D(Vector2(k, 0), Vector2(0, 1), Vector2(x + ox, y + oy))
	var ci: CanvasItem = ctx.ci
	var main_c: Color = Ctx.col(col) if not (col is Ctx.Grad) else (col as Ctx.Grad).avg()
	var lw = maxi(1, int(round(maxf(2.4, sz * 0.2))))
	ci.draw_set_transform_matrix(M * Transform2D(0, Vector2(1.4 / k, 2)))
	ci.draw_string(f, Vector2.ZERO, s, HORIZONTAL_ALIGNMENT_LEFT, -1, isz, Color(6 / 255.0, 3 / 255.0, 8 / 255.0, 0.88 * ga))
	ci.draw_set_transform_matrix(M)
	ci.draw_string_outline(f, Vector2.ZERO, s, HORIZONTAL_ALIGNMENT_LEFT, -1, isz, lw, Color(8 / 255.0, 5 / 255.0, 10 / 255.0, 0.82 * ga))
	ci.draw_string(f, Vector2.ZERO, s, HORIZONTAL_ALIGNMENT_LEFT, -1, isz, Color(main_c, main_c.a * ga))
	ci.draw_set_transform_matrix(M * Transform2D(0, Vector2(0.6 / k, -0.4)))
	ci.draw_string(f, Vector2.ZERO, s, HORIZONTAL_ALIGNMENT_LEFT, -1, isz, Color(main_c, main_c.a * ga * 0.35))
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

static func _G(): return J.cl(TWX().G, null, [])
# 鬼直接去本層𨋢口入𨋢
static func t_lift(f: int = 2) -> void:
	var G = _G(); var g = G.gh[int(J.num(G.active))]; var L = J.G.get("LIFT")
	var lid = ""
	for k in G.nodes:
		var nd = G.nodes[k]
		if J.str(nd.kind) == "lift" and int(J.num(nd.f)) == f: lid = k
	if lid == "": print("t_lift: no lift node"); return
	var nd2 = G.nodes[lid]; g.node = lid; g.to = null; g.auto = null; g.x = nd2.x; g.y = nd2.y
	J.mc(L, "setPos", [float(f)])
	print("t_lift enter=", J.mc(L, "enter", [g]))
# 搵一戶入得嘅住戶入屋
static func t_unit() -> void:
	var G = _G(); var g = G.gh[int(J.num(G.active))]; var U = J.G.get("UNIT")
	for un in G.units:
		if J.t(J.mc(U, "canEnter", [g, un])):
			print("t_unit ", J.str(un.name), " ok=", J.mc(U, "enterFromDoor", [g, un])); return
	print("t_unit: none enterable")
static func t_exit_unit() -> void: print("unit exit=", J.mc(J.G.get("UNIT"), "exit", ["door"]))
