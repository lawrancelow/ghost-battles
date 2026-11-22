# 分村經營場景（第二期，Idle Outpost 式）：睇得見嘅檔口、過路鬼排隊幫襯、員工做嘢、收銀箱、升級條、補給車、子時孤魂
# 由 Garrison.open(ci) 開；數值全部喺 garrison.gd（呢度只係畫面＋撳嘢），舊數字面板由「補給／詳細」開返
extends Control

const FW := 390.0
const FH := 844.0
# 檔口位置（底邊中心）、圖、闊度
const POS := {"bun": Vector2(100, 290), "rest": Vector2(290, 290), "guard": Vector2(100, 590), "store": Vector2(292, 590)}
const SPR := {"bun": "bun", "rest": "plank", "guard": "camp", "store": "store"}
const BW := 150.0
const ROAD_Y := 394.0
const CAR_Y := 708.0
const CSCALE := 0.9      # 角色大細（檔口闊 150，對返村子 0.62×150/106）
const CUST_K := ["youhun", "zhiren", "egui", "xiaogui", "zombie", "shuigui"]
const MAX_PARTS := 60
const MAX_FLOATS := 14
const GOLD := Color("#f3d68a")
const INK := Color("#2b1d12")
const PAPER := Color(0.93, 0.85, 0.64, 0.97)
const LINE := Color("#b89a52")
const RED := Color("#b8322a")
const GREEN := Color("#3d7a3a")
const DIMC := Color("#5e4a30")

var ci := -1
var frame: Control
var bg: TextureRect
var stage: Control
var hud_title: Label
var hud_night: Label
var hud_coins: Label
var hud_bar: ProgressBar
var prev_b: Button
var next_b: Button
var bottom: HBoxContainer
var hint_lbl: Label
var feed_b: Button
var sheet: PanelContainer
var sheet_box: VBoxContainer
var picker: Control
var sel := ""
var k := 1.0

var t := 0.0
var _acc := 0.0
var cust := {"bun": [], "rest": []}
var spawn_in := {"bun": 0.5, "rest": 1.2}
var lone: Array = []
var parts: Array = []
var floats: Array = []
var bubbles: Array = []
var car = null
var banner = null
var guard_go := {}      # 守夜員工 idx → 攔截目標（lone 項）
var pending := {}       # 收編緊嘅鬼 id：等孤魂行埋位先畫做員工
var _raid_key := ""
var _raid_spawned := 0
var _cv_key := "?"
var _last_done := -1.0
var _rng := RandomNumberGenerator.new()
var _chat_t := 8.0

func GR(): return get_node("/root/Garrison")
func T(y: String, z: String) -> String: return GR().T(y, z)
func N(s: String) -> String: return GR().N(s)
func fmt(v) -> String: return GR().fmt(v)

func _ready() -> void:
	_rng.seed = 20261119
	_build()

# ================= 建介面 =================
func _build() -> void:
	if frame != null: return
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP
	bg = TextureRect.new(); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	bg.modulate = Color(0.74, 0.73, 0.78)   # 壓暗少少（唔使多鋪一層全屏 ColorRect）
	frame = Control.new(); frame.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(frame)
	stage = Control.new(); stage.mouse_filter = Control.MOUSE_FILTER_STOP; frame.add_child(stage)
	stage.draw.connect(_draw_stage); stage.gui_input.connect(_stage_input)
	_build_hud(); _build_bottom(); _build_sheet()
	resized.connect(_layout); _layout()

func _layout() -> void:
	if frame == null: return
	var sz = size if size.x > 0 else Vector2(FW, FH)
	k = minf(sz.x / FW, sz.y / FH)
	var fh = maxf(FH, sz.y / k)
	frame.scale = Vector2(k, k); frame.size = Vector2(FW, fh)
	frame.position = Vector2((sz.x - FW * k) / 2.0, 0)
	stage.position = Vector2.ZERO; stage.size = frame.size
	if bottom != null: _place_bottom()

func _lbl(t0: String, sz := 16, col := Color.WHITE, kind := "sans", w := 700, outline := 5) -> Label:
	var l = UIKit.label(N(t0), sz, col, kind, w)
	if outline > 0: l.add_theme_constant_override("outline_size", outline); l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _build_hud() -> void:
	var p = PanelContainer.new(); p.position = Vector2(0, 0); p.size = Vector2(FW, 96); p.custom_minimum_size = Vector2(FW, 96)
	p.add_theme_stylebox_override("panel", UIKit.sb(Color(0.06, 0.04, 0.08, 0.78), 0, Color(LINE, 0.5), 0, Vector4(10, 6, 10, 6)))
	p.mouse_filter = Control.MOUSE_FILTER_STOP; frame.add_child(p)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 2); p.add_child(v)
	var h1 = HBoxContainer.new(); h1.add_theme_constant_override("separation", 6); v.add_child(h1)
	prev_b = _small_btn("◀"); prev_b.pressed.connect(func(): _switch(-1)); h1.add_child(prev_b)
	hud_title = _lbl("", 25, GOLD, "serif", 900, 6); hud_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_title.clip_text = true; hud_title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; h1.add_child(hud_title)
	next_b = _small_btn("▶"); next_b.pressed.connect(func(): _switch(1)); h1.add_child(next_b)
	var cl = _small_btn("✕"); cl.pressed.connect(close); h1.add_child(cl)
	var h2 = HBoxContainer.new(); v.add_child(h2)
	hud_night = _lbl("", 16, Color("#f0e2c8"), "sans", 700, 4); hud_night.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_night.clip_text = true; hud_night.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; h2.add_child(hud_night)
	hud_coins = _lbl("", 18, GOLD, "sans", 900, 5); hud_coins.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; h2.add_child(hud_coins)
	hud_bar = ProgressBar.new(); hud_bar.show_percentage = false; hud_bar.custom_minimum_size = Vector2(0, 10); hud_bar.max_value = 1.0; hud_bar.step = 0.0
	hud_bar.add_theme_stylebox_override("background", UIKit.sb(Color(0.2, 0.18, 0.28, 0.9), 5))
	hud_bar.add_theme_stylebox_override("fill", UIKit.sb(Color("#8f7fd0"), 5)); hud_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(hud_bar)

func _small_btn(tx: String) -> Button:
	var b = UIKit.btn(tx, "", true); b.custom_minimum_size = Vector2(42, 40); b.add_theme_font_size_override("font_size", 17); b.focus_mode = Control.FOCUS_NONE
	return b

func _build_bottom() -> void:
	hint_lbl = _lbl(T("撳檔口升級　撳＋派鬼　撳收銀箱收錢", "點檔口升級　點＋派鬼　點收銀箱收錢"), 14, Color("#e8dcc4"), "sans", 700, 4)
	hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; hint_lbl.position = Vector2(0, 0); hint_lbl.size = Vector2(FW, 22); frame.add_child(hint_lbl)
	bottom = HBoxContainer.new(); bottom.add_theme_constant_override("separation", 8); bottom.alignment = BoxContainer.ALIGNMENT_CENTER
	frame.add_child(bottom)
	var b1 = UIKit.btn(N(T("補給／詳細", "補給／詳細")), "", false); b1.custom_minimum_size = Vector2(118, 50); b1.add_theme_font_size_override("font_size", 16); b1.focus_mode = Control.FOCUS_NONE
	b1.pressed.connect(func(): _snd("click"); GR().open_panel(ci)); bottom.add_child(b1)
	feed_b = UIKit.btn("", "gold", false); feed_b.custom_minimum_size = Vector2(150, 50); feed_b.add_theme_font_size_override("font_size", 16); feed_b.focus_mode = Control.FOCUS_NONE
	feed_b.pressed.connect(_feed_tap); bottom.add_child(feed_b)
	var b3 = UIKit.btn(N(T("收晒錢", "全部收錢")), "", false); b3.custom_minimum_size = Vector2(92, 50); b3.add_theme_font_size_override("font_size", 16); b3.focus_mode = Control.FOCUS_NONE
	b3.pressed.connect(func(): for sid in ["bun", "rest"]: _collect(sid)); bottom.add_child(b3)

func _place_bottom() -> void:
	var fh = frame.size.y
	bottom.position = Vector2(0, fh - 62); bottom.size = Vector2(FW, 52)
	hint_lbl.position = Vector2(0, fh - 88)
	if sheet != null: sheet.position = Vector2(0, fh - sheet.size.y)

func _build_sheet() -> void:
	sheet = PanelContainer.new(); sheet.visible = false; sheet.mouse_filter = Control.MOUSE_FILTER_STOP
	var s = UIKit.sb(PAPER, 14, LINE, 2, Vector4(14, 10, 14, 12)); s.corner_radius_bottom_left = 0; s.corner_radius_bottom_right = 0
	sheet.add_theme_stylebox_override("panel", s); sheet.custom_minimum_size = Vector2(FW, 0); sheet.size = Vector2(FW, 240)
	frame.add_child(sheet)
	sheet_box = VBoxContainer.new(); sheet_box.add_theme_constant_override("separation", 6); sheet.add_child(sheet_box)

# ================= 開／關 =================
func show_map(c: int) -> void:
	_build(); ci = c; visible = true; sel = ""; sheet.visible = false; _close_picker()
	cust = {"bun": [], "rest": []}; lone.clear(); parts.clear(); floats.clear(); bubbles.clear(); car = null; banner = null; guard_go.clear()
	_raid_key = ""; _raid_spawned = 0; _cv_key = "?"; _last_done = -1.0
	var Gr = GR()
	if ci >= 0:
		var md = Gr.map_def(ci); var key = "bg_" + str(md.bg)
		bg.texture = Spr.get_tex(key) if Spr.ok(key) else Spr.get_tex("bg_village")
		# 開場：每個有人睇嘅檔先排兩隻客，唔使等
		for sid in ["bun", "rest"]:
			if _stall_active(sid):
				for i in 2: _spawn_cust(sid, true)
	else: bg.texture = Spr.get_tex("bg_village")
	_recache(); _layout(); _place_bottom(); _refresh_hud(); set_process(true); _hide_village(true)
	_snd("click")
func close() -> void:
	visible = false; set_process(false); _close_picker(); _hide_village(false)
	if GR() != null: GR().save()
	var pn = GR().panel
	if pn != null and is_instance_valid(pn) and pn.visible: pn.close()

# 全屏蓋住村子：暫停村子處理＋唔畫佢（同 menus 面板一樣做法），慳手機效能；關場景還原
var _vill_prev = null
func _hide_village(on: bool) -> void:
	var m = get_tree().root.get_node_or_null("Main") if is_inside_tree() else null
	var v = m.get("village") if m != null else null
	if not (v is CanvasItem) or not is_instance_valid(v): return
	if on:
		if _vill_prev == null: _vill_prev = [v.visible, v.process_mode]
		v.visible = false; v.process_mode = Node.PROCESS_MODE_DISABLED
	elif _vill_prev != null:
		v.visible = _vill_prev[0]; v.process_mode = _vill_prev[1]; _vill_prev = null
func _exit_tree() -> void: _hide_village(false)

func _switch(d: int) -> void:
	var om = GR().open_maps()
	if om.size() < 2: return
	var i = om.find(ci); show_map(om[(i + d + om.size()) % om.size()])

func refresh_live() -> void:   # Garrison._process 每 TICK_SEC 叫
	if sheet.visible and sel != "": _fill_sheet()

# ================= 每格 =================
func _process(dt: float) -> void:
	if not visible: return
	dt = minf(dt, 0.1)
	t += dt; _acc += dt
	var Gr = GR()
	if Gr.S() == null: return
	if _acc >= 0.25:
		_acc = 0.0; Gr.accrue_live(); _recache(); _refresh_hud()
		var g = Gr.st()
		if J.num(g.done) != _last_done:
			if _last_done >= 0: _night_passed()
			_last_done = J.num(g.done)
		_check_convoy()
		if ci >= 0: _raid_sched()
	if ci >= 0:
		for sid in ["bun", "rest"]: _step_stall(sid, dt)
		_step_lone(dt); _step_misc(dt)
	stage.queue_redraw()

func _refresh_hud() -> void:
	var Gr = GR(); var g = Gr.st()
	var om = Gr.open_maps()
	prev_b.visible = om.size() > 1; next_b.visible = om.size() > 1
	hud_title.text = N(str(Gr.map_def(ci).post)) if ci >= 0 else N(T("分村", "分村"))
	var nm = Gr.night_ms(); var fr = Gr.night_frac(); var left = maxf(0.0, (1.0 - fr) * nm / 1000.0)
	var zi = T("・子時！", "・子時！") if Gr.raid_time() else ""
	hud_night.text = N(T("陰間第 %d 夜・今晚剩 %d:%02d%s", "陰間第 %d 夜・今晚剩 %d:%02d%s") % [int(J.num(g.done)) + 1, int(left / 60), int(fmod(left, 60)), zi])
	hud_coins.text = N(T("冥幣 %s", "冥幣 %s") % fmt(J.num(Gr.S().res.coins)))
	hud_bar.value = fr
	hud_bar.add_theme_stylebox_override("fill", UIKit.sb(Color("#c0503a") if Gr.raid_time() else Color("#8f7fd0"), 5))
	var nl = _lone_active().size()
	feed_b.visible = ci >= 0
	feed_b.disabled = nl == 0 or J.num(Gr.S().res.get("buns")) < Gr.feed_cost(maxi(ci, 0))
	feed_b.text = N(T("派宵夜（壽包 %s）", "派宵夜（壽包 %s）") % fmt(Gr.feed_cost(maxi(ci, 0))))
	bottom.visible = not sheet.visible
	hint_lbl.visible = not sheet.visible
	if ci < 0: hint_lbl.text = N(T("未有通關嘅地圖。打贏地圖嘅主線 Boss，就可以喺嗰度開分村。", "還沒有通關的地圖。打贏地圖的主線 Boss，就可以在那裡開分村。"))

# ---------------- 數值快取（每 0.25 秒／有變先重計；畫面每格只讀呢度，唔再逐格行公式） ----------------
var NC := {}
func _recache() -> void:
	if ci < 0: NC = {}; return
	var Gr = GR(); var o = {}
	for sid in ["bun", "rest", "guard", "store"]:
		var lv = Gr.lv_of(ci, sid); var tier = 0
		for x in Gr.D.MILESTONE: if lv >= float(x[0]): tier += 1
		var e = {"lv": lv, "tier": tier, "mn": Gr.mile_name(lv), "name": N(str(Gr.stall_def(sid).name))}
		if sid in ["bun", "rest"]:
			e.inc = Gr.income(ci, sid); e.mgr = Gr.has_mgr(ci, sid); e.till = Gr.till(ci, sid); e.cap = Gr.till_cap(ci, sid)
			e.full = Gr.till_full(ci, sid); e.rate = Gr.rate_ps(ci, sid); e.svc = _svc_time(sid)
		if sid != "store":
			var p = Gr.ms(ci).posts[sid]; var st = []
			for i in p.size():
				var gh = Gr.ghost(p[i]) if p[i] != null else null
				st.append({"k": J.str(J.gp(gh, "k")), "id": J.str(p[i]), "name": J.str(J.gp(gh, "name"))} if gh != null else null)
			e.staff = st; e.nh = Gr.helpers(lv)
		o[sid] = e
	o.guard.gp = Gr.guard_pow(ci); o.guard.need = Gr.guard_need(ci)
	var stk = Gr.ms(ci).stock; o.store.stock = J.num(stk.buns) + J.num(stk.planks); o.store.cap = Gr.store_cap(ci)
	NC = o

# ---------------- 檔口／客人 ----------------
func _stall_active(sid: String) -> bool:
	if ci < 0 or not NC.has(sid): return false
	return NC[sid].inc > 0.0 and not NC[sid].full
func _svc_time(sid: String) -> float:
	var Gr = GR(); var C = Gr.D.CUST
	var n = Gr.staff(ci, sid).size(); var lv = Gr.lv_of(ci, sid)
	return maxf(float(C.svcMin), float(C.svc) / (1.0 + float(C.svcLv) * (lv - 1.0)) / (1.0 + float(C.svcStaff) * maxf(0.0, n - 1.0)))
func _serve_pos(sid: String) -> Vector2:
	var p: Vector2 = POS[sid]; return Vector2(p.x + (16.0 if sid == "bun" else -16.0), p.y + 50.0)
func _queue_pos(sid: String, i: int) -> Vector2:
	var sp = _serve_pos(sid); var d = 1.0 if sid == "bun" else -1.0
	return Vector2(sp.x + d * 30.0 * i, sp.y + 6.0 + 3.0 * i)
func _edge_x(sid: String) -> float: return -30.0 if sid == "bun" else FW + 30.0

func _spawn_cust(sid: String, instant := false) -> void:
	var L: Array = cust[sid]; var waiting = 0
	for c in L: if c.st != "out": waiting += 1
	if waiting > int(GR().D.CUST.queue): return
	var kk = CUST_K[_rng.randi() % CUST_K.size()]
	var c = {"k": kk, "x": _edge_x(sid), "y": ROAD_Y + _rng.randf_range(-6, 6), "st": "in", "prog": 0.0, "ph": _rng.randf() * 10.0, "flip": sid == "rest", "slot": -1}
	if instant:
		var q = _queue_pos(sid, waiting); c.x = q.x; c.y = q.y
	L.append(c)

func _step_stall(sid: String, dt: float) -> void:
	var L: Array = cust[sid]
	var active = _stall_active(sid)
	if active:
		spawn_in[sid] -= dt
		if spawn_in[sid] <= 0.0:
			_spawn_cust(sid); spawn_in[sid] = float(NC[sid].svc) * _rng.randf_range(0.8, 1.25)
	# 排隊次序
	var order = []
	for c in L: if c.st != "out": order.append(c)
	for i in order.size():
		var c = order[i]; var tgt = _serve_pos(sid) if i == 0 else _queue_pos(sid, i)
		if c.st == "in" or c.st == "queue":
			# 先行上路口（ROAD_Y），再入隊
			var goal = tgt
			if absf(c.x - tgt.x) > 30.0 and c.y > tgt.y + 20.0: goal = Vector2(tgt.x, c.y)
			var d = goal - Vector2(c.x, c.y); var sp = 70.0 * dt
			if d.length() > sp: var v = d.normalized() * sp; c.x += v.x; c.y += v.y; c.flip = d.x < 0; c["walk"] = true
			else:
				c.x = goal.x; c.y = goal.y; c["walk"] = false
				if goal == tgt:
					c.st = "queue"
					if i == 0: c.st = "serve"; c.prog = 0.0; c["svc"] = float(NC[sid].svc)
		elif c.st == "serve":
			c.flip = sid == "bun"
			if i != 0: c.st = "queue"; continue
			if not active and NC[sid].inc <= 0.0: continue
			c.prog += dt / float(c.svc)
			if c.prog >= 1.0: _pay(sid, c); c.st = "out"; c["walk"] = true
	for c in L.duplicate():
		if c.st == "out":
			var ex = _edge_x(sid); var d2 = Vector2(ex, ROAD_Y + 18.0) - Vector2(c.x, c.y)
			c.flip = d2.x < 0
			if d2.length() < 4.0: L.erase(c); continue
			var v2 = d2.normalized() * 80.0 * dt; c.x += v2.x; c.y += v2.y
	# 冇得做（收銀箱滿／冇人）：排緊隊嘅慢慢散
	if not active and _rng.randf() < dt * 0.3:
		for c in L:
			if c.st == "queue" or c.st == "in":
				c.st = "out"
				if NC[sid].full: _bubble(Vector2(c.x, c.y - 44), T("收銀箱都爆晒，唔幫襯喇。", "收銀箱都塞滿了，不光顧了。"), "", 2.4)
				break

func _pay(sid: String, c: Dictionary) -> void:
	var amt = float(NC[sid].rate) * float(c.get("svc", 3.0))
	var src = Vector2(c.x, c.y - 30)
	var mgr = NC[sid].mgr
	var dst = Vector2(FW - 60, 52) if mgr else _till_pos(sid)
	var n = clampi(int(2 + amt / 20.0), 2, 5)
	for i in n: _coin(src + Vector2(_rng.randf_range(-6, 6), 0), dst, 0.55 + i * 0.07)
	_float(src + Vector2(0, -12), "+%s" % fmt(maxf(1.0, amt)), GOLD, 17)
	if sid == "rest" and _rng.randf() < 0.5: _float(src + Vector2(18, -30), "Zzz", Color("#cfd8ff"), 15)
	if _rng.randf() < 0.35: _snd("coin")

func _till_pos(sid: String) -> Vector2:
	var p: Vector2 = POS[sid]; return Vector2(p.x - 66.0 if sid == "bun" else p.x + 66.0, p.y + 22.0)

# ---------------- 孤魂（子時） ----------------
func _lone_active() -> Array:
	var o = []
	for l in lone: if l.st in ["walk", "steal", "wait"]: o.append(l)
	return o

func _raid_sched() -> void:
	var Gr = GR()
	if not Gr.raid_time(): return
	var n = J.num(Gr.st().done) + 1.0; var key = "%d:%d" % [ci, int(n)]
	var r = Gr.raid(ci)
	if key != _raid_key: _raid_key = key; _raid_spawned = 0
	var mx = int(Gr.D.RAID.max); var st0 = float(Gr.D.RAID.start); var fr = Gr.night_frac()
	var tot = int(J.num(r.tot)); var gone = int(J.num(r.gone))
	var blocked = (mx - tot) if Gr.guard_pow(ci) > 0.0 else 0
	var V = tot + blocked
	while _raid_spawned < V:
		var i = _raid_spawned
		var at = st0 + (1.0 - st0) * (0.03 + 0.11 * i)
		if fr < at: break
		_raid_spawned += 1
		var thief = i < tot
		if thief and i < gone: continue
		var late = (fr - at) * Gr.night_ms() / 1000.0   # 遲咗幾多秒先睇到
		if not thief and late > 25.0: continue
		_spawn_lone(thief, late)

const STEAL_SPOTS := [Vector2(62, 30), Vector2(-4, 40), Vector2(30, 58), Vector2(-46, 34), Vector2(84, 52), Vector2(-24, 64)]
func _steal_spot(i: int) -> Vector2: return POS.store + STEAL_SPOTS[i % STEAL_SPOTS.size()]
func _spawn_lone(thief: bool, late := 0.0) -> void:
	if lone.size() >= 6: return
	var kk = CUST_K[_rng.randi() % CUST_K.size()]
	var y = 640.0 + _rng.randf_range(-10, 14)
	var used = {}
	for o in lone: used[int(o.get("spot", -1))] = true
	var spot = 0
	while used.has(spot): spot += 1
	if not thief: y = 600.0 + 34.0 * (spot % 3)
	var l = {"k": kk, "x": FW + 30.0, "y": y, "thief": thief, "st": "walk", "t": 0.0, "ph": _rng.randf() * 10, "said": false, "spot": spot}
	if thief and late > 12.0:
		var sp = _steal_spot(spot); l.x = sp.x; l.y = sp.y; l.st = "steal"
	lone.append(l)
	var talking = false
	for b in bubbles: if b.who == N("孤魂"): talking = true
	if not l.said and not talking and _rng.randf() < 0.8:
		l.said = true; _bubble(Vector2(minf(l.x, FW - 60), l.y - 52), _pick_line(LINES_COME), "孤魂", 3.0)

func _step_lone(dt: float) -> void:
	var Gr = GR()
	for l in lone.duplicate():
		l.t += dt
		match l.st:
			"walk":
				var goal = _steal_spot(int(l.spot)) if l.thief else Vector2(FW - 36.0, l.y)
				var d = goal - Vector2(l.x, l.y); var sp = 34.0 * dt
				if d.length() > sp: var v = d.normalized() * sp; l.x += v.x; l.y += v.y
				elif l.thief: l.st = "steal"; l.t = 0.0; _bubble(Vector2(l.x - 20, l.y - 52), _pick_line(LINES_STEAL), "孤魂", 2.6)
				else:
					l.st = "wait"; l.t = 0.0
					var gi = _free_guard()
					if gi >= 0: guard_go[gi] = l
			"wait":   # 俾守夜攔低
				if l.t > 2.2 and not l.get("blocked_said", false):
					l["blocked_said"] = true; _bubble(Vector2(l.x - 70, l.y - 70), _pick_line(LINES_GUARD), _guard_name(), 2.4)
				if l.t > 4.4: _flee(l, false)
				elif l.t > 7.0: _flee(l, false)
			"steal":
				if fmod(l.t, 3.5) < dt and l.t > 0.5:
					_float(Vector2(l.x, l.y - 46), T("偷偷摸摸…", "偷偷摸摸…"), Color("#bfd4ff"), 14)
			"flee":
				var d2 = Vector2(FW + 50.0, l.y + 10.0) - Vector2(l.x, l.y)
				var v2 = d2.normalized() * 150.0 * dt; l.x += v2.x; l.y += v2.y
				if d2.length() < 6.0 or l.t > 4.0: lone.erase(l)
			"eat":
				if l.t > float(l.get("dur", 6.0)):
					var gid = l.get("gid")
					if gid != null:
						pending.erase(J.str(gid)); lone.erase(l)
						_float(Vector2(l.x, l.y - 50), T("入職！", "入職！"), Color("#9fe39a"), 18); _snd("build")
					else: l.st = "flee"; l.t = 0.0
			"loot":
				var d3 = Vector2(FW + 50.0, l.y) - Vector2(l.x, l.y)
				var v3 = d3.normalized() * 60.0 * dt; l.x += v3.x; l.y += v3.y
				if d3.length() < 6.0: lone.erase(l)
	# 守夜員工：返原位
	for gi in guard_go.keys():
		var tg = guard_go[gi]
		if not (tg in lone) or tg.st == "flee": guard_go.erase(gi)

func _free_guard() -> int:
	var p = GR().ms(ci).posts.guard
	for i in p.size():
		if p[i] != null and not guard_go.has(i) and GR().ghost(p[i]) != null: return i
	return -1
func _guard_name() -> String:
	var p = GR().ms(ci).posts.guard
	for i in p.size():
		if p[i] != null:
			var gh = GR().ghost(p[i])
			if gh != null: return J.str(J.gp(gh, "name"))
	return T("守夜", "守夜")

func _flee(l: Dictionary, by_player: bool) -> void:
	l.st = "flee"; l.t = 0.0
	if by_player:
		_snd("scare"); _burst(Vector2(l.x, l.y - 24), Color("#cfe0ff"), 10)
		_bubble(Vector2(l.x - 40, l.y - 56), _pick_line(LINES_SCARED), "孤魂", 2.4)

func _tap_lone(l: Dictionary) -> void:
	if l.st not in ["walk", "steal", "wait"]: return
	if l.thief:
		if GR().raid_scare(ci): _float(Vector2(l.x, l.y - 64), T("今晚少偷啲", "今晚少偷一點"), Color("#9fe39a"), 16)
	_flee(l, true)

func _feed_tap() -> void:
	var L = _lone_active()
	if L.is_empty(): return
	L.sort_custom(func(a, b): return (1 if a.thief else 0) > (1 if b.thief else 0))
	var l = L[0]; var Gr = GR()
	var r = Gr.feed(ci, l.k, l.thief)
	if not r.ok: _float(Vector2(195, 600), r.why, Color("#ffb0a0"), 18); return
	_snd("chest")
	l.st = "eat"; l.t = 0.0
	var mgr = _mgr_name("bun")
	var set_i = _rng.randi() % FEED_SETS.size()
	if not (Gr.S().get("gar") is Dictionary) or Gr.st().get("fed_first") == null: set_i = 0; Gr.st()["fed_first"] = true
	var lines = FEED_SETS[set_i]
	var p0 = Vector2(clampf(l.x - 60, 10, FW - 220), l.y - 64); var pm = POS.bun + Vector2(-30, -80)
	_bubble(p0, TA(lines[0]), "孤魂", 2.4, 0.0)
	_bubble(pm, TA(lines[1]), mgr, 2.4, 2.4)
	if r.gh != null:
		l["gid"] = J.gp(r.gh, "id"); pending[J.str(J.gp(r.gh, "id"))] = true
		_bubble(p0, TA(lines[2]), "孤魂", 2.6, 4.8)
		l["dur"] = 7.6
		var where = ""
		if r.slot.size(): where = T("（%s幫工）", "（%s幫工）") % str(Gr.stall_def(r.slot[0]).name)
		_banner_set(T("收編咗「%s」%s", "收編了「%s」%s") % [J.str(J.gp(r.gh, "name")), where], T("孤魂留低做幫工", "孤魂留下當幫工"), 2.6, 7.4)
	else:
		_bubble(p0, TA(FEED_FULL), "孤魂", 2.6, 4.8)
		l["dur"] = 7.6
	_refresh_hud()

func _mgr_name(sid: String) -> String:
	var p = GR().ms(ci).posts[sid]
	if p[0] != null:
		var gh = GR().ghost(p[0])
		if gh != null: return J.str(J.gp(gh, "name"))
	return T("你", "你")

func _night_passed() -> void:
	# 過咗一晚：未走嘅偷嘢孤魂揹住嘢走
	var any = false
	for l in lone:
		if l.st == "steal" or (l.st == "walk" and l.thief): l.st = "loot"; any = true
		elif l.st == "walk" or l.st == "wait": l.st = "flee"; l.t = 0.0
	var rp = GR().get("last_rep")
	if rp is Dictionary and any:
		var tb = float(rp.theft.buns) + float(rp.theft.planks)
		if tb >= 1.0: _float(Vector2(POS.store.x, POS.store.y - 150), T("孤魂偷走：壽包 %s、棺材板 %s", "孤魂偷走：壽包 %s、棺材板 %s") % [fmt(rp.theft.buns), fmt(rp.theft.planks)], Color("#ffb0a0"), 16, 3.0)
	_raid_key = ""

# ---------------- 補給車 ----------------
func _check_convoy() -> void:
	var cv = GR().st().get("convoy")
	var key = ("%d" % int(J.num(cv.eta))) if cv is Dictionary else ""
	if _cv_key == "?": _cv_key = key; return
	if key == _cv_key: return
	if key != "" and _cv_key == "": convoy_anim("depart")
	elif key == "" and _cv_key != "": convoy_anim("arrive")
	elif key != "" and _cv_key != "": convoy_anim("arrive")
	_cv_key = key

func convoy_anim(kind: String) -> void:
	car = {"x": -110.0 if kind == "arrive" else 70.0, "kind": kind, "t": 0.0}
	_snd("whoosh")
	if kind == "depart": _float(Vector2(120, CAR_Y - 70), T("出車！", "出車！"), GOLD, 20, 2.0)
	else: _float(Vector2(195, CAR_Y - 70), T("補給車到站！", "補給車到站！"), GOLD, 20, 2.0)

# ---------------- 粒子／字／對白 ----------------
func _coin(a: Vector2, b: Vector2, life: float) -> void:
	if parts.size() >= MAX_PARTS: return
	parts.append({"k": "coin", "a": a, "b": b, "t": 0.0, "life": life, "h": _rng.randf_range(50, 90)})
func _burst(p: Vector2, col: Color, n: int) -> void:
	for i in n:
		if parts.size() >= MAX_PARTS: return
		var an = _rng.randf() * TAU; var sp = _rng.randf_range(60, 160)
		parts.append({"k": "dot", "p": p, "v": Vector2(cos(an), sin(an)) * sp, "t": 0.0, "life": _rng.randf_range(0.5, 0.9), "c": col})
func _float(p: Vector2, tx: String, col: Color, sz := 16, life := 1.4) -> void:
	if floats.size() >= MAX_FLOATS: floats.pop_front()
	floats.append({"p": p, "text": N(tx), "c": col, "s": sz, "t": 0.0, "life": life})
func _bubble(p: Vector2, tx: String, who: String, life := 2.6, delay := 0.0) -> void:
	if bubbles.size() >= 5: bubbles.pop_front()
	bubbles.append({"p": p, "text": N(tx), "who": N(who), "t": -delay, "life": life})
func _banner_set(a: String, b: String, life := 2.6, delay := 0.0) -> void:
	banner = {"a": N(a), "b": N(b), "t": -delay, "life": life}

func _step_misc(dt: float) -> void:
	for p in parts.duplicate():
		p.t += dt
		if p.k == "dot": p.p += p.v * dt; p.v *= 0.92
		if p.t >= p.life: parts.erase(p)
	for f in floats.duplicate():
		f.t += dt; f.p.y -= 22.0 * dt
		if f.t >= f.life: floats.erase(f)
	for b in bubbles.duplicate():
		b.t += dt
		if b.t >= b.life: bubbles.erase(b)
	if banner != null:
		banner.t += dt
		if banner.t >= banner.life: banner = null
	if car != null:
		car.t += dt; car.x += 45.0 * dt
		if car.x > FW + 140.0: car = null
	_drift = fmod(_drift + 22.0 * dt, FW + 260.0)   # 車隊喺路上：慢慢行過
	# 過路鬼偶然講句嘢
	_chat_t -= dt
	if _chat_t <= 0.0:
		_chat_t = _rng.randf_range(9.0, 16.0)
		for sid in ["bun", "rest"]:
			var L: Array = cust[sid]
			if L.size() and _rng.randf() < 0.5:
				var c = L[0]
				if c.st == "serve": _bubble(Vector2(clampf(c.x - 50, 6, FW - 200), c.y - 76), _pick_line(LINES_CUST_BUN if sid == "bun" else LINES_CUST_REST), T("過路鬼", "過路鬼"), 2.6); break

# ================= 畫 =================
func _draw_stage() -> void:
	if ci < 0 or GR().S() == null or NC.is_empty(): return
	var ctx = Ctx.new(stage)
	var Gr = GR()
	# 路
	_road(ctx, ROAD_Y + 10.0, 30.0); _road(ctx, CAR_Y - 4.0, 34.0)
	var items: Array = []
	for sid in POS: items.append([POS[sid].y, func(): _draw_stall(ctx, sid)])
	# 員工
	for sid in Gr.STALL_IDS:
		var p = NC[sid].staff
		for i in p.size():
			var sp = _slot_pos(sid, i)
			if p[i] == null or pending.has(p[i].id):
				if i <= NC[sid].nh: items.append([sp.y - 1.0, func(): _draw_empty(ctx, sid, i, sp)])
				continue
			var kk = p[i].k; var o = {"t": t + i * 1.7 + sid.length(), "tamed": true, "shadow": true}
			if sid == "guard":
				if guard_go.has(i):
					var tg = guard_go[i]; var gp = Vector2(tg.x - 30.0, tg.y)
					var cur = _gpos(i, sp); var d = gp - cur
					cur += d.normalized() * minf(d.length(), 140.0 * get_process_delta_time())
					_gcur[i] = cur; sp = cur; o["walk"] = d.length() > 3.0; o["flip"] = d.x < 0
				else:
					var cur2 = _gpos(i, sp); var home = sp + Vector2(sin(t * 0.5 + i) * 26.0, 0); var d2 = home - cur2
					cur2 += d2.normalized() * minf(d2.length(), 90.0 * get_process_delta_time()); _gcur[i] = cur2; sp = cur2
					o["walk"] = d2.length() > 1.0; o["flip"] = d2.x < 0
			else: o["work"] = true; o["flip"] = (i % 2 == 1) == (sid == "bun")
			var spp = sp
			items.append([spp.y, func(): Art.draw_char(ctx, kk, spp.x, spp.y, CSCALE, o)])
	# 客
	for sid in cust:
		for c in cust[sid]:
			var cc = c
			items.append([c.y, func(): _draw_cust(ctx, cc, sid)])
	for l in lone:
		var ll = l
		items.append([l.y, func(): _draw_lone(ctx, ll)])
	items.sort_custom(func(a, b): return a[0] < b[0])
	for it in items: it[1].call()
	_draw_car(ctx)
	_draw_tills(ctx)
	_draw_signs(ctx)
	_draw_parts(ctx)
	for f in floats:
		var a = clampf(1.0 - (f.t / f.life - 0.6) / 0.4, 0.0, 1.0)
		ctx.globalAlpha = a; _txt(ctx, f.text, f.p.x, f.p.y, f.s, f.c, "center", 900, 4); ctx.globalAlpha = 1.0
	_brects.clear()
	for b in bubbles:
		if b.t >= 0.0: _draw_bubble(ctx, b)
	if banner != null and banner.t >= 0.0: _draw_banner(ctx)

var _gcur := {}
var _drift := 0.0
func _gpos(i: int, dflt: Vector2) -> Vector2: return _gcur.get(i, dflt)

func _slot_pos(sid: String, i: int) -> Vector2:
	var p: Vector2 = POS[sid]
	if sid == "guard": return p + [Vector2(-14, 8), Vector2(40, 12), Vector2(-50, 16), Vector2(76, 22)][i]
	if sid == "store": return p
	var d = 1.0 if sid == "bun" else -1.0
	return p + [Vector2(-18 * d, 4), Vector2(26 * d, 2), Vector2(-50 * d, -2), Vector2(56 * d, -4)][i]

func _road(ctx: Ctx, y: float, h: float) -> void:
	ctx.fillStyle = "rgba(40,30,26,.45)"; ctx.fillRect(0, y - h / 2, FW, h)
	ctx.fillStyle = "rgba(220,200,160,.10)"
	for i in 12: ctx.fillRect(i * 36 + fmod(i * 7.0, 11.0), y - 1, 16, 2)

func _draw_stall(ctx: Ctx, sid: String) -> void:
	var p: Vector2 = POS[sid]; var Gr = GR()
	var sel_on = sel == sid
	if sel_on:
		ctx.fillStyle = "rgba(243,214,138,.22)"; Art.el(ctx, p.x, p.y + 2, 84, 16, "rgba(243,214,138,.28)")
	Art.el(ctx, p.x, p.y + 2, 70, 11, "rgba(0,0,0,.35)")
	var r = Art.put(ctx, SPR[sid], p.x, p.y + 6, BW)
	# 招牌燈籠：每個招牌一個
	var tier = NC[sid].tier
	for i in tier:
		var lx = r.position.x + 18 + i * 28; var ly = r.position.y + r.size.y * 0.42 + sin(t * 2 + i) * 1.5
		_lantern(ctx, lx, ly)

func _lantern(ctx: Ctx, x: float, y: float) -> void:
	ctx.strokeStyle = "#3a2410"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(x, y - 12); ctx.lineTo(x, y - 6); ctx.stroke()
	Art.el(ctx, x, y + 4, 18, 18, "rgba(255,170,90,.14)"); Art.el(ctx, x, y + 4, 12, 12, "rgba(255,170,90,.18)")
	Art.el(ctx, x, y + 4, 7, 9, "#d8452e", "#5a1a10", 1.2)
	Art.rr(ctx, x - 4, y - 7, 8, 3, 1, "#f0c060"); Art.rr(ctx, x - 4, y + 12, 8, 3, 1, "#f0c060")

func _draw_empty(ctx: Ctx, sid: String, i: int, sp: Vector2) -> void:
	var pulse = 0.6 + 0.4 * sin(t * 3.0 + i)
	ctx.save(); ctx.globalAlpha = 0.55 + 0.35 * pulse
	Art.el(ctx, sp.x, sp.y - 14, 15, 15, "rgba(20,14,24,.55)", "#f3d68a" if i == 0 else "#d8cdb6", 2)
	_txt(ctx, "＋", sp.x, sp.y - 13, 20, Color("#f3d68a") if i == 0 else Color("#efe6d2"), "center", 900, 0)
	ctx.restore()
	if i == 0 and sid != "guard":
		_txt(ctx, T("請管事", "請管事"), sp.x, sp.y - 42, 16, Color("#ffd27a"), "center", 900, 4)

func _draw_cust(ctx: Ctx, c: Dictionary, sid: String) -> void:
	Art.draw_char(ctx, c.k, c.x, c.y, CSCALE * 0.92, {"t": t + c.ph, "seed": c.ph, "walk": c.get("walk", false), "flip": c.flip, "alpha": 0.92})
	if c.st == "serve":
		var w = 40.0; var x0 = c.x - w / 2; var y0 = c.y - 50
		Art.rr(ctx, x0 - 1, y0 - 1, w + 2, 8, 3, "rgba(0,0,0,.6)")
		Art.rr(ctx, x0, y0, w * clampf(c.prog, 0, 1), 6, 3, "#7fd36a" if sid == "bun" else "#8fb4ff")

func _draw_lone(ctx: Ctx, l: Dictionary) -> void:
	var a = 0.55 + 0.1 * sin(t * 3 + l.ph)
	if l.st == "flee": a = maxf(0.0, 0.6 - l.t * 0.15)
	var o = {"t": t + l.ph, "seed": l.ph, "walk": l.st in ["walk", "flee", "loot"], "flip": l.st in ["walk", "steal", "wait"], "alpha": a, "noShadow": true}
	if l.st == "steal": o["work"] = true
	Art.draw_char(ctx, l.k, l.x, l.y - 4 + sin(t * 2.4 + l.ph) * 3.0, CSCALE * 0.95, o)
	# 藍色鬼火光暈＋小標
	Art.el(ctx, l.x, l.y - 18, 26, 26, "rgba(140,190,255,.10)"); Art.el(ctx, l.x, l.y - 18, 16, 16, "rgba(140,190,255,.12)")
	if l.st == "loot":
		Art.el(ctx, l.x + 10, l.y - 26, 9, 8, "#8a6a4a", "#3a2410", 1.2)
	if l.st in ["walk", "steal", "wait"]:
		_txt(ctx, T("孤魂", "孤魂") if l.thief or l.st != "wait" else T("攔低", "攔下"), l.x, l.y + 14, 14, Color("#cfe0ff"), "center", 900, 4)

func _draw_tills(ctx: Ctx) -> void:
	var Gr = GR()
	for sid in ["bun", "rest"]:
		var p = _till_pos(sid); var e = NC[sid]; var mgr = e.mgr; var v = e.till; var cap = e.cap
		var full = e.full
		var sh = (sin(t * 10) * 2.0) if full else 0.0
		Art.rr(ctx, p.x - 22 + sh, p.y - 14, 44, 28, 4, "#7a2a1e", "#f2c060", 2)
		Art.rr(ctx, p.x - 16 + sh, p.y - 10, 32, 6, 2, "#2a120c")
		_txt(ctx, "冥", p.x + sh, p.y + 5, 14, GOLD, "center", 900, 0)
		if mgr:
			_txt(ctx, T("自動入賬", "自動入賬"), p.x, p.y + 30, 14, Color("#9fe39a"), "center", 900, 4)
		else:
			var col = Color("#ff8a7a") if full else Color.WHITE
			_txt(ctx, fmt(v), p.x, p.y + 31, 20, col, "center", 900, 4)
			if full: _txt(ctx, T("滿！撳我收", "滿！點我收"), p.x, p.y + 52, 15, Color("#ffd27a"), "center", 900, 4)
			elif cap > 0.0:
				Art.rr(ctx, p.x - 26, p.y + 45, 52, 9, 4, "rgba(0,0,0,.6)", "#f2c060", 1); Art.rr(ctx, p.x - 25, p.y + 46, 50 * clampf(v / cap, 0, 1), 7, 3, "#f2c060")

func _sign_style(tier: int) -> Array:   # [底, 邊, 字]
	match tier:
		1: return ["#6b3a1e", "#d8452e", "#f6d58a"]
		2: return ["#9c2219", "#f2c060", "#fff0c0"]
		3: return ["#1e1a22", "#f2c060", "#f6d58a"]
		4: return ["#b8862a", "#fff0b0", "#3a1a08"]
	return ["#4a3020", "#8a6a4a", "#f6d58a"]

func _draw_signs(ctx: Ctx) -> void:
	var Gr = GR()
	for sid in POS:
		var p: Vector2 = POS[sid]; var e = NC[sid]; var lv = e.lv
		var name = e.name
		var mn = e.mn; var tier = e.tier
		var stl = _sign_style(tier)
		var top = p.y - 172.0
		ctx.font = "900 21px serif"; var w = ctx.measureText(name).width + 62.0
		if tier >= 4:
			var gl = ctx.createRadialGradient(p.x, top + 18, 10, p.x, top + 18, w * 0.7); gl.addColorStop(0, "rgba(255,220,120,.35)"); gl.addColorStop(1, "rgba(255,220,120,0)")
			ctx.fillStyle = gl; ctx.fillRect(p.x - w, top - 30, w * 2, 100)
		Art.rr(ctx, p.x - w / 2, top, w, 34, 5, stl[0], stl[1], 2.5)
		_txt(ctx, name, p.x - 16, top + 18, 21, Color(stl[2]), "center", 900, 3, "serif")
		# Lv 圓牌
		Art.el(ctx, p.x + w / 2 - 22, top + 17, 17, 13, "#c2362b", "#f0c8b4", 1.5)
		_txt(ctx, "%d" % int(lv), p.x + w / 2 - 22, top + 18, 16, Color("#fff3e0"), "center", 900, 0)
		if mn != "":
			_txt(ctx, "「%s」" % N(mn), p.x, top + 48, 15, Color("#ffd27a"), "center", 900, 4, "serif")
		# 檔口數值（招牌下面）
		var info = ""
		if sid == "guard": info = T("防守 %s／%s", "防守 %s／%s") % [fmt(e.gp), fmt(e.need)]
		elif sid == "store":
			info = T("存糧 %s／%s", "存糧 %s／%s") % [fmt(e.stock), fmt(e.cap)]
		else:
			var inc = e.inc
			info = T("每晚 %s", "每晚 %s") % fmt(inc) if inc > 0.0 else T("未有人睇檔", "還沒人看檔")
		_info_line(ctx, sid, info)

func _info_line(ctx: Ctx, sid: String, info: String) -> void:
	var p: Vector2 = POS[sid]
	var y = p.y - 172.0 + 48.0 + (18.0 if NC[sid].mn != "" else 0.0)
	_txt(ctx, N(info), p.x, y, 14, Color("#f0e2c8"), "center", 700, 4)

func _draw_car(ctx: Ctx) -> void:
	var Gr = GR(); var g = Gr.st(); var cv = g.get("convoy"); var done = J.num(g.done); var CE = float(Gr.D.CONVOY_EVERY)
	var label = ""
	if cv is Dictionary: label = T("補給車喺路上：仲有 %d 晚到", "補給車在路上：還有 %d 晚到") % int(maxf(0.0, J.num(cv.eta) - done))
	else:
		var nx = (floor(done / CE) + 1.0) * CE
		label = T("下一班車：%d 晚後", "下一班車：%d 晚後") % int(nx - done)
	if car != null: _paper_car(ctx, car.x, CAR_Y, true)
	elif cv is Dictionary: _paper_car(ctx, _drift - 130.0, CAR_Y, true)
	else: _paper_car(ctx, 74, CAR_Y, false)
	_txt(ctx, label, 140, CAR_Y - 22, 16, Color("#f0e2c8"), "left", 900, 5)

func _paper_car(ctx: Ctx, x: float, y: float, moving: bool) -> void:
	var b = (sin(t * 14) * 1.2) if moving else 0.0
	Art.el(ctx, x, y + 2, 52, 6, "rgba(0,0,0,.35)")
	ctx.save(); ctx.translate(0, b)
	# 車身（紙紮：紅紙金邊）
	Art.rr(ctx, x - 50, y - 30, 100, 24, 6, "#c0392b", "#f2c060", 2)
	Art.poly(ctx, [x - 26, y - 30, x - 14, y - 50, x + 22, y - 50, x + 34, y - 30], "#f3e2bd", "#b89a52", 1.5)
	Art.rr(ctx, x - 10, y - 46, 14, 12, 2, "#8fb4d8"); Art.rr(ctx, x + 8, y - 46, 14, 12, 2, "#8fb4d8")
	for i in 5: Art.rr(ctx, x - 46 + i * 20, y - 10, 10, 3, 1, "#f2c060")
	_txt(ctx, "Pocong" if GR().pocong() else T("冥通", "冥通"), x - 2, y - 17, 14, Color("#fff0c0"), "center", 900, 2)
	# 貨
	Art.rr(ctx, x - 46, y - 44, 18, 14, 2, "#a07848", "#3a2410", 1); Art.rr(ctx, x + 36, y - 42, 12, 12, 2, "#e8d8b0", "#3a2410", 1)
	ctx.restore()
	for wx in [x - 30, x + 30]:
		var rot = t * 8.0 if moving else 0.0
		Art.el(ctx, wx, y - 4, 9, 9, "#1a1426", "#f3e2bd", 2)
		ctx.strokeStyle = "#f3e2bd"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(wx + cos(rot) * 7, y - 4 + sin(rot) * 7); ctx.lineTo(wx - cos(rot) * 7, y - 4 - sin(rot) * 7); ctx.stroke()
	if GR().pocong():
		Art.draw_char(ctx, "pocong", x - 70, y, 0.5, {"t": t, "walk": moving})

func _draw_parts(ctx: Ctx) -> void:
	for p in parts:
		var u = clampf(p.t / p.life, 0, 1)
		if p.k == "coin":
			var pos = p.a.lerp(p.b, u); pos.y -= sin(u * PI) * p.h
			Art.el(ctx, pos.x, pos.y, 6, 6, "#f2c060", "#7a4a10", 1.5)
		else:
			ctx.globalAlpha = 1.0 - u; Art.el(ctx, p.p.x, p.p.y, 3, 3, "#%s" % p.c.to_html(false)); ctx.globalAlpha = 1.0

func _wrap(ctx: Ctx, s: String, maxw: float) -> Array:
	var out = []; var cur = ""
	for ch in s:
		if ctx.measureText(cur + ch).width > maxw and cur != "": out.append(cur); cur = ch
		else: cur += ch
	if cur != "": out.append(cur)
	return out

var _brects: Array = []
func _draw_bubble(ctx: Ctx, b: Dictionary) -> void:
	ctx.font = "700 15px sans-serif"
	var lines = _wrap(ctx, b.text, 196.0)
	var w = 0.0
	for l in lines: w = maxf(w, ctx.measureText(l).width)
	w += 20.0; var h = lines.size() * 20.0 + 12.0 + (18.0 if b.who != "" else 0.0)
	var x = clampf(b.p.x, 6.0, FW - w - 6.0); var y = clampf(b.p.y - h, 100.0, 760.0)
	# 唔好疊住之前畫咗嘅對白框：向上推
	for k2 in 6:
		var hit = false
		for r in _brects:
			if r.intersects(Rect2(x, y, w, h).grow(3)): y = r.position.y - h - 6.0; hit = true
		if not hit: break
	if y < 100.0: y = 100.0
	_brects.append(Rect2(x, y, w, h))
	var a = clampf(minf(b.t / 0.15, (b.life - b.t) / 0.3), 0, 1)
	ctx.save(); ctx.globalAlpha = a
	Art.rr(ctx, x, y, w, h, 8, "rgba(250,244,228,.96)", "#5e4a30", 1.5)
	var yy = y + 6.0
	if b.who != "": _txt(ctx, b.who, x + 10, yy + 9, 14, Color("#9c2219"), "left", 900, 0); yy += 18.0
	for l in lines: _txt(ctx, l, x + 10, yy + 10, 15, INK, "left", 700, 0); yy += 20.0
	ctx.restore()

func _draw_banner(ctx: Ctx) -> void:
	var b = banner; var u = b.t / b.life
	var a = clampf(minf(b.t / 0.2, (b.life - b.t) / 0.4), 0, 1)
	var sc = 1.0 + 0.25 * maxf(0.0, 1.0 - b.t / 0.25)
	ctx.save(); ctx.globalAlpha = a
	ctx.fillStyle = "rgba(10,6,14,.72)"; ctx.fillRect(0, 300, FW, 150)
	var g = ctx.createRadialGradient(195, 375, 10, 195, 375, 200); g.addColorStop(0, "rgba(255,210,120,.35)"); g.addColorStop(1, "rgba(255,210,120,0)")
	ctx.fillStyle = g; ctx.fillRect(0, 300, FW, 150)
	# 放射光
	ctx.strokeStyle = "rgba(255,220,140,.25)"; ctx.lineWidth = 3
	for i in 12:
		var an = i * TAU / 12.0 + u * 1.5
		ctx.beginPath(); ctx.moveTo(195 + cos(an) * 40, 375 + sin(an) * 22); ctx.lineTo(195 + cos(an) * 190, 375 + sin(an) * 70); ctx.stroke()
	ctx.translate(195, 375); ctx.scale(sc, sc); ctx.translate(-195, -375)
	_txt(ctx, b.a, 195, 346, 19 if b.a.length() > 16 else 21, Color("#f0e2c8"), "center", 900, 5)
	_txt(ctx, b.b, 195, 398, 42 if b.b.length() <= 6 else 24, GOLD, "center", 900, 7, "serif")
	ctx.restore()

# 文字：描邊＋填色
func _txt(ctx: Ctx, s: String, x: float, y: float, sz: int, col: Color, align := "center", w := 900, outline := 4, fam := "sans-serif") -> void:
	ctx.font = "%d %dpx %s" % [w, sz, fam]; ctx.textAlign = align; ctx.textBaseline = "middle"
	# 唔准出界（爆格）：按闊度夾返入畫面
	var tw = ctx.measureText(s).width
	match align:
		"center": x = clampf(x, tw / 2.0 + 4.0, FW - tw / 2.0 - 4.0)
		"left": x = clampf(x, 4.0, FW - tw - 4.0)
		"right": x = clampf(x, tw + 4.0, FW - 4.0)
	if outline > 0:
		ctx.lineWidth = outline; ctx.strokeStyle = "rgba(10,6,4,.92)"; ctx.lineJoin = "round"; ctx.strokeText(s, x, y)
	ctx.fillStyle = "#" + col.to_html(true); ctx.fillText(s, x, y)

# ================= 撳 =================
func _stage_input(ev: InputEvent) -> void:
	if not (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT): return
	if ci < 0: return
	var p: Vector2 = ev.position
	tap(p)

func tap(p: Vector2) -> void:
	var Gr = GR()
	# 1. 孤魂
	for l in lone:
		if l.st in ["walk", "steal", "wait"] and p.distance_to(Vector2(l.x, l.y - 20)) < 30.0: _tap_lone(l); return
	# 2. 收銀箱
	for sid in ["bun", "rest"]:
		var tp = _till_pos(sid)
		if Rect2(tp.x - 30, tp.y - 30, 60, 74).has_point(p):
			if Gr.has_mgr(ci, sid): _float(tp + Vector2(0, -36), T("有管事，自動入賬", "有管事，自動入賬"), Color("#9fe39a"), 15)
			else: _collect(sid)
			return
	# 3. 員工位
	for sid in Gr.STALL_IDS:
		var nh = Gr.helpers(Gr.lv_of(ci, sid))
		for i in nh + 1:
			var sp = _gpos(i, _slot_pos(sid, i)) if sid == "guard" else _slot_pos(sid, i)
			if Rect2(sp.x - 18, sp.y - 40, 36, 46).has_point(p): _open_picker(sid, i); return
	# 4. 檔口
	for sid in POS:
		var q: Vector2 = POS[sid]
		if Rect2(q.x - 75, q.y - 180, 150, 196).has_point(p): open_sheet(sid); return
	if sheet.visible: close_sheet()

func _collect(sid: String) -> void:
	var Gr = GR()
	if ci < 0 or Gr.has_mgr(ci, sid): return
	var v = Gr.collect(ci, sid)
	if v <= 0.0: return
	var tp = _till_pos(sid)
	for i in clampi(int(4 + v / 50.0), 4, 12): _coin(tp + Vector2(_rng.randf_range(-14, 14), _rng.randf_range(-8, 4)), Vector2(FW - 60, 52), 0.5 + i * 0.05)
	_float(tp + Vector2(0, -40), "+%s" % fmt(v), GOLD, 22, 1.8)
	_snd("coin"); _recache(); _refresh_hud()

# ================= 升級條 =================
func open_sheet(sid: String) -> void:
	sel = sid; sheet.visible = true; _snd("click"); _fill_sheet(); _refresh_hud()
func close_sheet() -> void:
	sel = ""; sheet.visible = false; _refresh_hud()

func _fill_sheet() -> void:
	for c in sheet_box.get_children(): sheet_box.remove_child(c); c.queue_free()
	var Gr = GR(); var sid = sel; var sd = Gr.stall_def(sid); var lv = Gr.lv_of(ci, sid); var mx = float(Gr.D.MAX_LV)
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); sheet_box.add_child(h)
	h.add_child(_lbl(str(sd.name), 22, INK, "serif", 900, 0))
	h.add_child(_lbl("Lv %d" % int(lv), 20, RED, "sans", 900, 0))
	var mn = Gr.mile_name(lv)
	if mn != "": h.add_child(_lbl("「%s」" % mn, 17, Color("#9c2219"), "serif", 900, 0))
	var sp = Control.new(); sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sp.mouse_filter = Control.MOUSE_FILTER_IGNORE; h.add_child(sp)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(42, 40); cb.focus_mode = Control.FOCUS_NONE; cb.pressed.connect(close_sheet); h.add_child(cb)
	# 數值：而家 → 下一級
	var nxt = minf(mx, lv + 1.0); var cur_v = 0.0; var nxt_v = 0.0; var what = ""
	match sid:
		"guard":
			what = T("防守", "防守"); cur_v = Gr.guard_pow(ci); nxt_v = Gr.at_lv(ci, sid, nxt, func(): return Gr.guard_pow(ci))
		"store":
			what = T("容量", "容量"); cur_v = Gr.store_cap(ci); nxt_v = Gr.at_lv(ci, sid, nxt, func(): return Gr.store_cap(ci))
		_:
			what = T("每晚收入", "每晚收入"); cur_v = Gr.income(ci, sid); nxt_v = Gr.at_lv(ci, sid, nxt, func(): return Gr.income(ci, sid))
	var line = "%s %s" % [what, fmt(cur_v)]
	if lv < mx: line += "  →  %s" % fmt(nxt_v)
	var l1 = _lbl(line, 18, INK, "sans", 900, 0); sheet_box.add_child(l1)
	var sub = ""
	if sid in ["bun", "rest"]:
		sub = T("每秒 %s 冥幣・%s", "每秒 %s 冥幣・%s") % [str(snappedf(Gr.rate_ps(ci, sid), 0.01)), T("有管事自動入賬", "有管事自動入賬") if Gr.has_mgr(ci, sid) else T("冇管事：錢留喺收銀箱（上限一晚）", "沒管事：錢留在收銀箱（上限一晚）")]
	elif sid == "guard": sub = T("要 %s 先完全擋得住孤魂；而家每晚俾偷 %s%%", "要 %s 才完全擋得住孤魂；現在每晚被偷 %s%%") % [fmt(Gr.guard_need(ci)), str(snappedf(Gr.theft_rate(ci) * 100.0, 0.1))]
	else: sub = T("壽包 %s・棺材板 %s", "壽包 %s・棺材板 %s") % [fmt(Gr.ms(ci).stock.buns), fmt(Gr.ms(ci).stock.planks)]
	var l2 = _lbl(sub, 14, DIMC, "sans", 700, 0); l2.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l2.custom_minimum_size = Vector2(350, 0); sheet_box.add_child(l2)
	var nm = Gr.next_mile(lv)
	if nm.size():
		var l3 = _lbl(T("再升 %d 級掛新招牌「%s」（%s ×%s）", "再升 %d 級掛新招牌「%s」（%s ×%s）") % [int(float(nm[0]) - lv), nm[2], what, str(nm[1])], 14, Color("#9c2219"), "sans", 900, 0)
		sheet_box.add_child(l3)
	# 員工位
	if sid != "store":
		var sr = HBoxContainer.new(); sr.add_theme_constant_override("separation", 6); sheet_box.add_child(sr)
		var p = Gr.ms(ci).posts[sid]; var nh = Gr.helpers(lv)
		for i in 4: sr.add_child(_slot_btn(sid, i, p[i], i > nh))
	# 升級掣
	var br = HBoxContainer.new(); br.add_theme_constant_override("separation", 8); sheet_box.add_child(br)
	if lv >= mx:
		var b0 = UIKit.btn(N(T("已經最高級", "已經最高級")), "", false); b0.disabled = true; b0.custom_minimum_size = Vector2(0, 50); b0.size_flags_horizontal = Control.SIZE_EXPAND_FILL; br.add_child(b0)
	else:
		for n in [1, 10]:
			var c = Gr.up_cost_n(ci, sid, n); var ok = Gr.can_up_n(ci, sid, n)
			var b = UIKit.btn(N(T("升 %d 級\n板 %s・冥幣 %s", "升 %d 級\n板 %s・冥幣 %s") % [int(c.n), fmt(c.planks), fmt(c.coins)]), "gold" if ok else "", false)
			b.disabled = not ok; b.custom_minimum_size = Vector2(0, 58); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.add_theme_font_size_override("font_size", 15); b.focus_mode = Control.FOCUS_NONE
			var nn = n
			b.pressed.connect(func(): do_upgrade(sid, nn)); br.add_child(b)
	await get_tree().process_frame
	if not is_instance_valid(sheet): return
	sheet.size = Vector2(FW, 0); sheet.reset_size(); sheet.size.x = FW
	sheet.position = Vector2(0, frame.size.y - sheet.size.y)

func _slot_btn(sid: String, i: int, gid, locked: bool) -> Control:
	var Gr = GR()
	var b = Button.new(); b.custom_minimum_size = Vector2(85, 64); b.focus_mode = Control.FOCUS_NONE
	var col = Color(1, 0.97, 0.88, 0.8) if not locked else Color(0.4, 0.35, 0.3, 0.35)
	for stn in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(stn, UIKit.sb(col, 8, Color(RED, 0.8) if i == 0 else LINE, 2 if i == 0 else 1))
	var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 3; hb.offset_right = -3; hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_theme_constant_override("separation", 2); hb.alignment = BoxContainer.ALIGNMENT_CENTER; b.add_child(hb)
	var gh = Gr.ghost(gid) if gid != null else null
	if locked:
		var need = 0
		for hh in Gr.D.HELP: if int(hh[1]) == i: need = int(hh[0])
		hb.add_child(_lbl(T("Lv%d 開", "Lv%d 開") % need, 14, DIMC, "sans", 700, 0)); b.disabled = true
	elif gh == null:
		hb.add_child(_lbl(T("＋管事", "＋管事") if i == 0 else T("＋幫工", "＋幫工"), 15, RED if i == 0 else DIMC, "sans", 900, 0))
	else:
		var pr = UIKit.portrait(J.str(J.gp(gh, "k")), 40); pr.custom_minimum_size = Vector2(32, 44); pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
		var vb = VBoxContainer.new(); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_theme_constant_override("separation", 0); hb.add_child(vb)
		vb.add_child(_lbl(T("管事", "管事") if i == 0 else T("幫工", "幫工"), 14, RED if i == 0 else DIMC, "sans", 900, 0))
		var nl = _lbl(J.str(J.gp(gh, "name")).get_slice("・", 0), 14, INK, "sans", 700, 0); nl.clip_text = true; nl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; nl.custom_minimum_size = Vector2(40, 0); vb.add_child(nl)
	if not locked: b.pressed.connect(func(): _open_picker(sid, i))
	return b

func do_upgrade(sid: String, n: int) -> void:
	var Gr = GR(); var lv0 = Gr.lv_of(ci, sid)
	var q = Gr.quiet; Gr.quiet = true
	var done_n = 0
	for i in n:
		if not Gr.upgrade(ci, sid): break
		done_n += 1
	Gr.quiet = q
	if done_n == 0: return
	var lv1 = Gr.lv_of(ci, sid)
	_snd("build")
	var p: Vector2 = POS[sid]
	_burst(p + Vector2(0, -70), Color("#f3d68a"), 14)
	_float(p + Vector2(0, -40), "Lv %d → %d" % [int(lv0), int(lv1)], GOLD, 22, 1.6)
	# 招牌
	var hit = []
	for x in Gr.D.MILESTONE: if lv0 < float(x[0]) and lv1 >= float(x[0]): hit.append(x)
	if hit.size():
		var x = hit[-1]
		var what = {"store": T("容量", "容量"), "guard": T("防守", "防守")}.get(sid, T("收入", "收入"))
		_banner_set(T("%s 掛新招牌 %s ×%s", "%s 掛上新招牌 %s ×%s") % [Gr.stall_def(sid).name, what, str(pow(float(x[1]), hit.size()))], "「%s」" % str(x[2]), 2.8)
		_snd("levelUp")
		for i in 3: _burst(p + Vector2(_rng.randf_range(-60, 60), -120 + _rng.randf_range(-20, 20)), Color("#ffd27a"), 12)
	_recache(); _fill_sheet(); _refresh_hud()

# ================= 揀人（沿用 pick_list／assign） =================
func _open_picker(sid: String, i: int) -> void:
	var Gr = GR(); var sd = Gr.stall_def(sid)
	_close_picker(); _snd("click")
	picker = Control.new(); picker.position = Vector2.ZERO; picker.size = frame.size; picker.mouse_filter = Control.MOUSE_FILTER_STOP; frame.add_child(picker)
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.55); dim.position = Vector2.ZERO; dim.size = frame.size; picker.add_child(dim)
	dim.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: _close_picker())
	var pn = PanelContainer.new(); pn.position = Vector2(0, frame.size.y * 0.24); pn.size = Vector2(FW, frame.size.y * 0.76)
	var s = UIKit.sb(Color("#ecd9a4"), 12, LINE, 1, Vector4(12, 12, 12, 10)); s.corner_radius_bottom_left = 0; s.corner_radius_bottom_right = 0
	pn.add_theme_stylebox_override("panel", s); picker.add_child(pn)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 8); pn.add_child(v)
	var SN = ["力", "智", "武"]
	var h = HBoxContainer.new(); v.add_child(h)
	var tl = _lbl(T("派鬼：%s・%s（睇%s）", "派鬼：%s・%s（看%s）") % [sd.name, T("管事", "管事") if i == 0 else T("幫工", "幫工"), SN[int(sd.stat)]], 20, INK, "sans", 900, 0)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; tl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; tl.custom_minimum_size = Vector2(10, 0); h.add_child(tl)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(44, 44); cb.pressed.connect(_close_picker); h.add_child(cb)
	if i == 0:
		var l0 = _lbl(T("管事要有名有姓嘅鬼（雜鬼做唔到）。有管事＝收入自動入賬。", "管事要有名有姓的鬼（雜鬼做不到）。有管事＝收入自動入賬。"), 14, DIMC, "sans", 700, 0)
		l0.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l0.custom_minimum_size = Vector2(340, 0); v.add_child(l0)
	var cur = Gr.ms(ci).posts[sid][i]
	if cur != null and Gr.ghost(cur) != null:
		var rb = UIKit.btn(N(T("撤走 %s", "撤走 %s") % J.str(J.gp(Gr.ghost(cur), "name"))), "", false); rb.custom_minimum_size = Vector2(0, 46)
		rb.pressed.connect(func(): Gr.assign(ci, sid, i, null); Gr.save(); _close_picker(); _after_assign()); v.add_child(rb)
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; v.add_child(sc)
	var lst = VBoxContainer.new(); lst.size_flags_horizontal = Control.SIZE_EXPAND_FILL; lst.add_theme_constant_override("separation", 6); sc.add_child(lst)
	var L = Gr.pick_list(ci, sid, i)
	if L.is_empty():
		var le = _lbl(T("冇鬼可以派。去招魂台招多啲雜鬼，或者子時派宵夜收編孤魂。", "沒有鬼可以派。去招魂台多招些雜鬼，或者子時派宵夜收編孤魂。"), 16, DIMC, "sans", 700, 0)
		le.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; le.custom_minimum_size = Vector2(340, 0); lst.add_child(le)
	var PL = J.G.get("postLabel")
	for gh in L.slice(0, 40):
		if J.seq(J.gp(gh, "id"), cur): continue
		var row = Button.new(); row.custom_minimum_size = Vector2(0, 68); row.focus_mode = Control.FOCUS_NONE
		for stn in ["normal", "hover", "pressed"]: row.add_theme_stylebox_override(stn, UIKit.sb(Color(1, 0.97, 0.88, 0.8 if stn != "pressed" else 0.6), 8, LINE, 1))
		var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 8; hb.offset_right = -10; hb.add_theme_constant_override("separation", 10); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; row.add_child(hb)
		var pr = UIKit.portrait(J.str(J.gp(gh, "k")), 52); pr.size_flags_vertical = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(vb)
		var nm = _lbl("%s　Lv%d" % [J.str(J.gp(gh, "name")), int(Gr.glv(gh))], 17, INK, "sans", 900, 0); nm.clip_text = true; nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; vb.add_child(nm)
		var pp = J.gp(gh, "post"); var where = T("閒住", "閒著")
		if J.t(pp): where = (T("分村駐守中（會調過嚟）", "分村駐守中（會調過來）") if J.seq(pp, "garrison") else J.str(J.cl(PL, null, [pp])) + T("（會調走）", "（會調走）")) if PL != null else T("做緊嘢（會調走）", "工作中（會調走）")
		var hm = Gr.home_mul(gh, ci)
		var info = _lbl("%s %d%s・%s" % [SN[int(sd.stat)], int(Gr.stat(gh, int(sd.stat))), ("・老家×%s" % str(hm)) if hm > 1.0 else "", where], 14, GREEN if hm > 1.0 else DIMC, "sans", 700, 0)
		info.clip_text = true; info.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; vb.add_child(info)
		var gid = J.gp(gh, "id")
		row.pressed.connect(func():
			if Gr.assign(ci, sid, i, gid): Gr.save()
			_close_picker(); _after_assign())
		lst.add_child(row)

func _after_assign() -> void:
	_snd("build"); _gcur.clear(); guard_go.clear(); _recache()
	if sheet.visible: _fill_sheet()
	_refresh_hud()
func _close_picker() -> void:
	if picker != null and is_instance_valid(picker): picker.queue_free()
	picker = null

# ================= 其他 =================
func _snd(n: String) -> void:
	var s = get_node_or_null("/root/Snd")
	if s != null: s.play(n)
func TA(a) -> String: return str(a[0]) if DB.lang == "yue" else str(a[1])
func _pick_line(L: Array) -> String: return TA(L[_rng.randi() % L.size()])

# ---------------- 對白（粵語原句＋中文；搞笑七成、心酸兩成、驚嚇一成） ----------------
const LINES_COME := [
	["借借，我淨係嚟聞吓個味。", "借過，我只是來聞聞味道。"],
	["呢度有冇 Wi-Fi？……有壽包都得。", "這裡有沒有 Wi-Fi？……有壽包也行。"],
	["我唔係偷，我係……提早攞。", "我不是偷，我是……提早拿。"],
	["你哋幾點收舖？我等你收咗先嚟。", "你們幾點關門？我等你關了再來。"],
	["我好瘦㗎，攞少少冇人發覺嘅。", "我很瘦的，拿一點點沒人發現的。"],
	["好耐冇人燒嘢俾我喇……", "很久沒人燒東西給我了……"],
	["你睇唔睇到我？……睇到就好。", "你看得見我嗎？……看得見就好。"],
	["噓——我喺你後面好耐㗎喇。", "噓——我在你後面很久了。"],
]
const LINES_STEAL := [
	["一嚿，就攞一嚿……再一嚿。", "一塊，就拿一塊……再一塊。"],
	["呢啲唔係偷，係「代收」。", "這些不是偷，是「代收」。"],
	["棺材板好啊，冬暖夏涼。", "棺材板好啊，冬暖夏涼。"],
	["攞返屋企……我都冇屋企。", "拿回家……我也沒有家。"],
]
const LINES_SCARED := [
	["嘩！唔好意思！我行錯路！", "哇！不好意思！我走錯路！"],
	["我走、我走！拖鞋都唔要喇！", "我走、我走！拖鞋都不要了！"],
	["好好好，聽晚再嚟。", "好好好，明晚再來。"],
	["又係咁……個個見到我都趕。", "又是這樣……每個人看到我都趕。"],
]
const LINES_GUARD := [
	["排隊！偷嘢都要排隊！", "排隊！偷東西也要排隊！"],
	["今晚唔得，聽晚請早。", "今晚不行，明晚請早。"],
	["我武力值好高㗎，你唔好逼我。", "我武力值很高的，你別逼我。"],
	["行開啲，呢度有人睇住㗎。", "走開點，這裡有人看著的。"],
]
const LINES_CUST_BUN := [
	["一個壽包，唔要葱，多謝。", "一個壽包，不要葱，謝謝。"],
	["壽包有冇得加辣？", "壽包可以加辣嗎？"],
	["上次食完，我個名都記返起一半。", "上次吃完，我的名字都想起一半了。"],
]
const LINES_CUST_REST := [
	["呢副棺材有冇床頭燈？", "這副棺材有沒有床頭燈？"],
	["瞓兩個鐘，唔該叫醒我……其實唔叫都得。", "睡兩個鐘，麻煩叫醒我……其實不叫也行。"],
	["行咗三晚路，終於有得躺。", "走了三晚路，終於可以躺下。"],
]
const FEED_SETS := [
	[["……你請我食？我冇錢喎。", "……你請我吃？我沒錢啊。"], ["唔使錢。寫低你個名就得。", "不用錢。寫下你的名字就行。"], ["我個名……我諗吓先。好耐冇人叫過。", "我的名字……我想一想。很久沒人叫過了。"]],
	[["呢個壽包……係俾我嘅？", "這個壽包……是給我的？"], ["係，熱辣辣，食完幫手執枱。", "是，熱騰騰，吃完幫忙收桌。"], ["早講嘛！執枱我最叻，生前做咗廿年。", "早說嘛！收桌我最拿手，生前做了二十年。"]],
	[["食咗你嘅嘢，我係咪要還？", "吃了你的東西，我是不是要還？"], ["還？留低返工就得。", "還？留下來上班就行。"], ["返工……死咗都要返工？……好，起碼有得食。", "上班……死了還要上班？……好吧，起碼有得吃。"]],
]
const FEED_FULL := ["多謝。我會記得呢個味。（名冊滿咗，佢食完就走咗）", "謝謝。我會記得這個味道。（名冊滿了，他吃完就走了）"]
