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
var hud: Control
var hvp: SubViewport
var hud_tex: TextureRect
var _hsig = null
var _hud_called := false
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
var _mkc := {}
var _mkc_last := 0
var _mk_last := 0
var prof_d := 0
var prof_n := 0

static func js(n: String): return J.G.get(n)
static func TWX(): return J.G.get("TWX")

# ---------------- tower.js open()/close() 叫 ----------------
# 樓裡有鬼其餘原生函數喺開樓時先登記（唔再改共用 bridge.gd）
static func register() -> void:
	var G = J.G
	if not G.has("__twNatL"): G["__twNatL"] = true
	G["__nat_twRes"] = func(_t, a): return TwLogic.res_tick(a[0], J.num(a[1]), J.num(a[2]), J.num(a[3]))
	G["__nat_twRes2"] = func(_t, a): return TwLogic.res2(a[0], J.num(a[1]), J.num(a[2]), J.num(a[3]), a[4])
	G["__nat_twLit"] = func(_t, a): return TwLogic.lit(a[0], J.num(a[1]))
	for k in TwDraw2.natives().keys(): G[k] = TwDraw2.natives()[k]
	# HUD 快取：HUD 畫喺獨立節點，簽名（時辰、警覺、能量、按鈕狀態…）有變先重畫
	G["__twHudN"] = func(_t, _a):
		if cur == null or cur.hud == null: return false
		cur._hud_called = true
		var sig = cur._hud_sig()
		if cur._hsig == null or sig != cur._hsig: cur._hsig = sig; cur.hud.queue_redraw(); cur.hvp.render_target_update_mode = SubViewport.UPDATE_ONCE
		return true

static func hook(on: bool) -> bool:
	register()
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
	# HUD 畫入 SubViewport（簽名有變先重畫一次），平時只係畫一張貼圖：GPU 每幀少幾百個 draw call
	hvp = SubViewport.new(); hvp.transparent_bg = true; hvp.disable_3d = true; hvp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	hvp.gui_disable_input = true; add_child(hvp)
	hud = Control.new(); hud.mouse_filter = Control.MOUSE_FILTER_IGNORE; hud.draw.connect(_draw_hud); hvp.add_child(hud)
	hud_tex = TextureRect.new(); hud_tex.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hud_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_tex.texture = hvp.get_texture(); hud_tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; hud_tex.stretch_mode = TextureRect.STRETCH_SCALE; add_child(hud_tex)
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
	if hvp: hvp.size = Vector2i(int(w), int(h)); hud.size = Vector2(w, h); _hsig = null
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
	_update_tip()

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
	if OS.has_environment("GB_TWBLANK"): return
	var t0 = Time.get_ticks_usec()
	var ctx = Ctx.new(stage)
	NT["ctx"] = ctx
	if OS.has_environment("GB_TWMARK"):
		_mk_last = Time.get_ticks_usec()
		J.G["__twMark"] = func(_t, a):
			var now = Time.get_ticks_usec(); var k = J.str(a[0])
			if k != "pre": _mk[k] = _mk.get(k, 0) + now - _mk_last
			if J.CTXPROF_ON:
				var c = 0
				for kk in J.CTXPROF: if kk.begins_with("#"): c += J.CTXPROF[kk]
				_mkc[k] = c - _mkc_last; _mkc_last = c
			_mk_last = Time.get_ticks_usec()
	var cp = OS.has_environment("GB_CTXPROF") and prof_n == 29
	if cp: J.CTXPROF.clear(); J.CTXPROF_ON = true; _mkc.clear(); _mkc_last = 0
	_hud_called = false
	if _covering(): J.mc(_unit(), "drawN", [ctx])
	else: J.cl(X.draw, null, [ctx])
	if hud_tex.visible != _hud_called: hud_tex.visible = _hud_called; _hsig = null
	if cp:
		J.CTXPROF_ON = false; var ks = J.CTXPROF.keys().filter(func(k): return not k.begins_with("#"))
		ks.sort_custom(func(a, b): return J.CTXPROF[a] > J.CTXPROF[b])
		var tot = 0
		for k in ks: tot += J.CTXPROF[k]
		print("[ctxn] ", _mkc)
		print("[ctx] total=%.1fms " % (tot / 1000.0), ", ".join(ks.slice(0, 14).map(func(k): return "%s %.1f(%d)" % [k, J.CTXPROF[k] / 1000.0, J.CTXPROF["#" + k]])))
	NT["ctx"] = null
	if OS.has_environment("GB_TWMARK"): _mk["hud+"] = _mk.get("hud+", 0) + Time.get_ticks_usec() - _mk_last
	if OS.has_environment("GB_PROF"):
		prof_d += Time.get_ticks_usec() - t0; prof_n += 1
		if prof_n >= 30:
			print("[tower] draw=%.1fms js_timers=%.1fms dc=%d prims=%d objs=%d" % [prof_d / 30000.0, JSRun.prof_timer / 30000.0, Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME), Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)]); JSRun.prof_timer = 0
			if _mk.size(): print("[twmark] ", ", ".join(_mk.keys().map(func(k): return "%s=%.1f" % [k, _mk[k] / 30000.0]))); _mk.clear()
			prof_d = 0; prof_n = 0

# HUD 簽名：drawHUD 用到嘅所有會變嘅值（量化到像素），一樣就唔使重畫
func _hud_sig() -> Array:
	var X = TWX(); var G = J.cl(X.G, null, []); var v = J.cl(X.hudV, null, [])
	var PHT = J.num(v[0]); var VW = J.num(v[1])
	var gt = J.num(G.t); var gate = G.get("gate"); var keys = G.get("keys", {})
	var a = [gate != null and gate is Dictionary, ceili(30.0 - J.num(gate.t)) if gate is Dictionary else -1, J.num(G.phase), floori(minf(1.0, gt / (PHT * 3.0)) * (VW - 24.0)),
		G.get("wave"), G.get("alert"), G.get("fear"), (G.bag as Array).size(), G.get("dolls"), keys.get("key"), keys.get("key2"), J.t(G.get("carry")), (G.story as Array).size(),
		J.str(G.get("toast")) if J.num(G.get("toastT")) > 0 else "", G.get("active"), J.t(G.get("gpHas")), G.get("ult") != null, J.t(G.get("choice")) or J.t(G.get("showStory")) or J.t(G.get("over"))]
	a.append_array(v.slice(1))
	var gi = int(J.num(G.active)); var gh: Array = G.gh
	for i in gh.size():
		var o = gh[i]; var en = J.num(o.get("energy")); var home = J.t(o.get("home"))
		a.append_array([roundi(en * 0.52), home, J.t(o.get("out")), o.get("caught"), o.get("pow"), J.t(o.get("trainee")), roundi(gt * 15.0) if en >= 100 and not home else 0])
		if i == gi: a.append_array([ceili(J.num(o.get("invCd"))) if J.num(o.get("invCd")) > 0 else 0, en >= 100])
	if a[17]: a.append(gt)
	return a

func _draw_hud() -> void:
	var X = TWX()
	if X == null or not _hud_called: return
	if OS.has_environment("GB_TWNOHUD"): return
	var t0 = Time.get_ticks_usec()
	var ctx = Ctx.new(hud)
	J.cl(X.hudDraw, null, [ctx])
	if OS.has_environment("GB_TWMARK"): _mk["HUDDRAW"] = _mk.get("HUDDRAW", 0) + Time.get_ticks_usec() - t0; _mk["HUDN"] = _mk.get("HUDN", 0) + 1000

# ---------------- 輸入 ----------------
var _pid := 1
func _ev(p: Vector2) -> Dictionary:
	var q = p / s
	return {"nx": q.x, "ny": q.y, "clientX": q.x, "clientY": q.y, "pointerId": float(_pid), "isPrimary": _pid == 1, "button": 0.0,
		"stopPropagation": func(_t, _a): pass, "preventDefault": func(_t, _a): pass}

# 手機：多點觸控直接轉做 pointerId（tower.js 本身有雙指縮放，用 pts／pinch）；滑鼠（電腦）照舊
#  觸控模擬出嚟嘅滑鼠事件（device == -1）唔再轉，免得同一隻手指送兩次
func _stage_input(ev: InputEvent) -> void:
	var kind := ""; var p := Vector2.ZERO; var pid := 1
	if ev is InputEventScreenTouch:
		p = ev.position; kind = "PD" if ev.pressed else "PU"; pid = ev.index + 1; _touch = true
	elif ev is InputEventScreenDrag:
		p = ev.position; kind = "PM"; pid = ev.index + 1; _touch = true
	elif ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if _touch or ev.device == -1: return
		p = ev.position; kind = "PD" if ev.pressed else "PU"
	elif ev is InputEventMouseMotion and _down:
		if _touch or ev.device == -1: return
		p = ev.position; kind = "PM"
	else: return
	if kind == "PD" and pid == 1: _down = true; _tip_off()
	if kind == "PU" and pid == 1: _down = false
	var pre = "__twU" if _covering() else "__tw"
	var f = J.G.get(pre + kind)
	_pid = pid
	if f != null: J.cl(f, null, [_ev(p)])
	_pid = 1
	accept_event()
var _touch := false

# ---------------- 龐總提示（policy.js #pol-tip，DOM 收埋咗，原生照畫） ----------------
var tip: Button
var _tip_sig := ""
func _update_tip() -> void:
	var el = JSRun.by_id("pol-tip")
	var txt := ""
	if el != null:
		var b = J.mc(el, "querySelector", ["b"]); var sp = J.mc(el, "querySelector", ["span"]); var sm = J.mc(el, "querySelector", ["small"])
		txt = "%s\n%s\n%s" % [J.str(J.gp(b, "textContent")) if b else "", J.str(J.gp(sp, "textContent")) if sp else "", J.str(J.gp(sm, "textContent")) if sm else ""]
	if txt == _tip_sig: return
	_tip_sig = txt
	if txt == "":
		if tip: tip.visible = false
		return
	if tip == null:
		tip = Button.new(); tip.alignment = HORIZONTAL_ALIGNMENT_LEFT; tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tip.add_theme_font_override("font", UIKit.font("sans", 700)); tip.add_theme_font_size_override("font_size", 15)
		var sb = UIKit.sb(Color(246 / 255.0, 236 / 255.0, 210 / 255.0, 0.96), 6, Color("#8a6a4a"), 2, Vector4(12, 8, 12, 9))
		for k in ["normal", "hover", "pressed", "focus"]: tip.add_theme_stylebox_override(k, sb)
		for k in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]: tip.add_theme_color_override(k, Color("#3a2618"))
		tip.anchor_left = 0; tip.anchor_right = 1; tip.anchor_top = 1; tip.anchor_bottom = 1
		tip.offset_left = 12; tip.offset_right = -12; tip.offset_bottom = -10; tip.grow_vertical = Control.GROW_DIRECTION_BEGIN
		tip.pressed.connect(func():
			var e = JSRun.by_id("pol-tip")
			if e != null: e.fire("click", {"type": "click", "stopPropagation": func(_t, _a): pass, "preventDefault": func(_t, _a): pass, "target": e}))
		add_child(tip)
	tip.text = txt; tip.visible = true

# 撳提示以外：同網頁版一樣收起提示
func _tip_off() -> void:
	if tip and tip.visible:
		var e = JSRun.by_id("pol-tip")
		if e != null: J.mc(e, "remove", [])

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
static func t_tip() -> void:
	if cur and cur.tip and cur.tip.visible: cur.tip.pressed.emit(); print("tip pressed")
	else: print("no tip")
# 模擬原生觸控（邏輯座標）
static func t_touch(x: float, y: float) -> void:
	if cur == null: return
	var p = Vector2(x, y) * cur.s
	var d = InputEventMouseButton.new(); d.button_index = MOUSE_BUTTON_LEFT; d.pressed = true; d.position = p; cur._stage_input(d)
	var u = InputEventMouseButton.new(); u.button_index = MOUSE_BUTTON_LEFT; u.pressed = false; u.position = p; cur._stage_input(u)
static func t_counts() -> void:
	var G = _G()
	print("TWCNT res=", G.res.size(), " units=", G.units.size(), " edges=", G.edges.size(), " nodes=", G.nodes.size(), " guards=", G.guards.size(), " parts=", G.parts.size(), " traces=", (G.get("traces", []) as Array).size(), " cprops=", (G.get("cprops", []) as Array).size())
# 對拍：同一種子，JS 原版 vs 原生版各跑 n 幀，比較狀態雜湊
static func t_ab(n: int = 3000, dt: float = 0.05, mode: int = 0) -> void:
	var X = TWX()
	if cur: cur._mk.clear(); cur._mk_last = Time.get_ticks_usec()
	if mode == 1:
		for k in 2:
			J.G["__twNatL"] = false; J.cl(X.sim, null, [12345.0, float(n), dt]); var hA = J.str(J.cl(X.hash, null, []))
			J.G["__twNatL"] = false; J.cl(X.sim, null, [12345.0, float(n), dt]); var hB = J.str(J.cl(X.hash, null, []))
			print("TWAB js-vs-js same=", hA == hB)
			if hA != hB:
				var a = hA.split("|"); var b = hB.split("|")
				for i in mini(a.size(), b.size()):
					if a[i] != b[i]: print("TWAB diff @", i, " ", a[i], " vs ", b[i]); break
		return
	for sd in [12345.0, 777.0]:
		J.G["__twNatL"] = false
		var ms0 = J.cl(X.sim, null, [sd, float(n), dt]); var h0 = J.str(J.cl(X.hash, null, []))
		J.G["__twNatL"] = true
		print("TWDBG win=", J.gp(J.G.get("window"), "__twNatL"), " f=", J.G.get("__nat_twRes2") != null)
		var ms1 = J.cl(X.sim, null, [sd, float(n), dt]); var h1 = J.str(J.cl(X.hash, null, []))
		print("TWAB seed=%d js=%sms nat=%sms same=%s len=%d" % [int(sd), J.str(ms0), J.str(ms1), h0 == h1, h0.length()])
		print("TWPT ", TwLogic.PT, " n=", n); TwLogic.PT.clear()
		if cur and cur._mk.size(): print("TWABMK ", ", ".join(cur._mk.keys().map(func(k): return "%s=%.2f" % [k, cur._mk[k] / 1000.0 / (2.0 * n)]))); cur._mk.clear()
		if h0 != h1:
			var a = h0.split("|"); var b = h1.split("|")
			for i in mini(a.size(), b.size()):
				if a[i] != b[i]: print("TWAB diff @", i, " ", a[i], " vs ", b[i]); break
	J.G["__twNatL"] = true
static func t_timers() -> void:
	var h = J.host
	var raf = 0; var iv = 0
	for t in h.timers:
		if t.get("dead", false): continue
		if t.raf: raf += 1
		else: iv += 1
	print("TWTIMERS raf=", raf, " other=", iv, " total=", h.timers.size())
# 測試：模擬雙指縮放（兩隻手指由相距 80 拉開到 200）
static func t_pinch() -> void:
	if cur == null: return
	var c = Vector2(200, 450)
	print("TWPINCH z0=", J.cl(TWX().camz, null, []))
	var mk = func(i, pos, pressed):
		var e = InputEventScreenTouch.new(); e.index = i; e.position = pos; e.pressed = pressed; return e
	var dr = func(i, pos):
		var e = InputEventScreenDrag.new(); e.index = i; e.position = pos; return e
	cur._stage_input(mk.call(0, c - Vector2(40, 0), true)); cur._stage_input(mk.call(1, c + Vector2(40, 0), true))
	for k in 6:
		var d = 40 + k * 12
		cur._stage_input(dr.call(0, c - Vector2(d, 0))); cur._stage_input(dr.call(1, c + Vector2(d, 0)))
	cur._stage_input(mk.call(1, c + Vector2(100, 0), false)); cur._stage_input(mk.call(0, c - Vector2(100, 0), false))
	print("TWPINCH z1=", J.cl(TWX().camz, null, []))
# 測試：用遊戲本身 update() 快進成晚（每步 0.05 秒），再由天台陰門收工
static func t_night(sec: float = 200.0) -> void:
	var X = TWX(); var t0 = Time.get_ticks_msec()
	var gt = J.cl(X.step, null, [float(int(sec / 0.05)), 0.05])
	var G = J.cl(X.G, null, [])
	print("TWNIGHT t=", gt, " phase=", G.phase, " fear=", G.fear, " alert=", G.alert, " over=", G.get("over") != null, " ms=", Time.get_ticks_msec() - t0)
static func t_end(w: String = "gate") -> void:
	J.cl(TWX().endN, null, [w]); var G = J.cl(TWX().G, null, []); print("TWEND over=", G.get("over"))
