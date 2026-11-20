# 移動村（出殯巡遊大排檔）經營場景：Idle Outpost 式。全部由 data/nat/outpost.json 驅動。
# 用法：var sc = load("res://game/outpost/mv_scene.gd").new(); 父節點.add_child(sc); sc.setup(main); sc.on_show()
#   size 跟父節點（PRESET_FULL_RECT）；setup(main) 之後自動留返主畫面頂欄／底欄位（重疊幾多留幾多）。
# 公開：setup(main)、on_show()、on_hide()、mv_state()、ci()、can_move()、move_next()（拔營，有動畫）、offline_gain(ms)
# 數值／狀態：mv_sim.gd（S.mv）；公式：mv_data.gd。冇 class_name、冇 autoload。
extends Control

const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const FX = preload("res://game/outpost/mv_fx.gd")
const M = preload("res://game/outpost/mat.gd")   # [chain]
const IDL = preload("res://game/outpost/mv_idle.gd")   # [idle]
const MIST = preload("res://game/outpost/mv_mist.gd")   # [unify] 血霧（mapart 線）：台、櫃台底
const MOT = preload("res://game/outpost/mv_motion.gd")
const ZDs = preload("res://game/zone/zone_data.gd")   # [zone]   # [motion] 角色特別動作
const FW := 390.0
const GOLD := Color("#f3d68a")
const INK := Color("#2b1d12")
const PAPER := Color(0.93, 0.85, 0.64, 0.97)
const LINE := Color("#b89a52")
const RED := Color("#b8322a")
const GREEN := Color("#3d7a3a")
const DIMC := Color("#5e4a30")
const MAX_PARTS := 70
const MAX_FLOATS := 16
const CS := 1.1            # 角色大細（客人）；員工 ×0.9、守夜 ×0.95、孤魂 ×0.9
# 冇美術圖時嘅後備（現有圖）
const ST_FALLBACK := {"mvs_steamer": "bun", "mvs_tailor": "store", "mvs_soup": "furnace", "mvs_coffin": "plank", "mvs_phone": "home", "mvs_garage": "wood", "mvs_house": "house"}
const ICON_COL := ["#d8452e", "#4f7fc0", "#5aa05a", "#b07a30", "#8a5ac0", "#c0a030", "#3aa0a0", "#c05a8a"]

var main = null
var sim
var frame: Control
var bg: TextureRect
var stage: Control
var over: Control           # 蓋喺升級條上面：橫額、離線卡、拔營
var sheet: PanelContainer
var sheet_box: VBoxContainer
var picker: Control = null
var sel := ""
var k := 1.0
var H := 844.0
var top_pad := 0.0
var bot_pad := 0.0
var t := 0.0
var parts: Array = []
var floats: Array = []
var bubbles: Array = []
var banner = null
var card = null            # 離線收益卡
var anim = null            # 拔營動畫 {t, from, done}
var shake := {}            # 圍欄搖：x → 剩餘時間
var coin_show := 0.0       # HUD 冥幣（追住真數，錢飛到先加）
var _save_t := 0.0
var _line_t := 6.0
var _rng := RandomNumberGenerator.new()
var _btns := {}            # 畫出嚟嘅掣：名 → Rect2
var _shown := false
# 鏡頭（大地圖直向拖動）：世界 y → 畫面 y = 世界 y − cam + top_pad
var cam := 0.0
var cam_v := 0.0
var cam_tgt = null
var _press = null           # 撳落：{"p","cam","t","drag"}
var _wbtns := {}            # 世界座標嘅掣
var bg_tex: Texture2D = null
var amb := {"g": [], "f": [], "tg": 2.0, "tf": 5.0}   # 環境：背景遊魂、飛過嘅烏鴉／紙錢
const HUD_H := 90.0
const AMB_GHOSTS := 2
const AMB_FLY := 3
var story = null   # [story] 劇本接駁（game/outpost/mv_story.gd）：beat、客人／惡鬼氣泡
var mot = null   # [motion] 角色特別動作（mv_motion.gd）
var camp = null   # [camp] 營地（原本村子嘅建築，喺地圖底）：game/outpost/mv_camp.gd
# [unify] 嵌入模式（合一地圖）：由 game/outpost/mv_embed.gd 掛入村子畫面（ui/nv_village.gd），
#   大排檔區世界 y 0..EH ＝ 村子 y -EH..0；鏡頭跟村子（embed 每格設 cam）；唔自己處理拖動／點擊（村子轉發 tap）；
#   唔畫紙紮大屋、營地；HUD 只喺睇到大排檔區先出（hud_on）。
var embed := false
var embed_top := 0.0          # HUD 頂（畫面座標，主線任務條下面）
var hud_on := true
var hud_k := 1.0              # HUD 淡入淡出
var embed_draw = null         # Callable(ctx, vy0, vy1)：嵌入層額外畫（挑夫鬼、留位）
var embed_ground = null       # [village2] Callable(ctx, vy0, vy1)：地面畫完之後（接駁原村子地面嘅漸變帶）
# [zone] 分區地圖：大排檔世界＝分區地圖世界座標（同村子一樣）；鏡頭由村子（nv_village 2D 鏡頭）每格設 zt
#   zt.z ＝ 舞台單位 ÷ 世界單位，zt.x／zt.y ＝ 畫面左上角嘅世界座標；唔畫自己嘅地面／柵欄（地面、區牆由村子畫）
var zone := false
var zt := {"z": 1.0, "x": 0.0, "y": 0.0}
var zfocus = null             # [zone] focus() 要求鏡頭移動：[世界 y, 畫面 y, 世界 x]
var _tx0 := 0.0               # [zone] 世界字夾邊（畫世界時 = 畫面可見範圍）
var _tx1 := FW

func _ready() -> void:
	_rng.seed = 7
	_build()

# ================= 公開 API =================
func setup(m) -> void:
	main = m
	_build(); _layout()
func on_show() -> void:
	_build(); visible = true; _shown = true
	_hide_host(true)
	sim.reg_post(); sim.st(); sim.validate(); sim.reset_live(); sim.sync()
	_set_bg(); _layout()
	if not embed: cam_home()   # [unify] 嵌入：鏡頭跟村子
	_prefill()
	coin_show = sim.coins()
	var r = sim.check_away()
	if r.has("coins") and float(r.coins) > 0.0: _show_card(r)
	set_process(true); _snd("click")
func on_hide() -> void:
	if sim != null and sim.st() != null: sim.st().last = J.now()
	_close_picker(); close_sheet(); set_process(false); _shown = false
	_hide_host(false)
	_save()
# 嵌入主畫面時：收埋村子（停處理，慳手機效能）同主線任務條（會蓋住目標條）；on_hide 還原。hide_host = false 就唔郁。
var hide_host := true
var _host_prev = null
func _hide_host(on: bool) -> void:
	if not hide_host or main == null or not is_instance_valid(main): return
	var nodes = [main.get("village"), main.get("quest_bar")]
	if on:
		if _host_prev != null: return
		_host_prev = []
		for n in nodes:
			if n is CanvasItem and is_instance_valid(n):
				_host_prev.append([n, n.visible, n.process_mode]); n.visible = false
				if n == main.get("village"): n.process_mode = Node.PROCESS_MODE_DISABLED
	elif _host_prev != null:
		for e in _host_prev:
			if is_instance_valid(e[0]): e[0].visible = e[1]; e[0].process_mode = e[2]
		_host_prev = null
func _exit_tree() -> void: _hide_host(false)
func mv_state(): return sim.st()
func ci() -> int: return sim.ci()
func can_move() -> bool: return sim.can_move()
func move_next(instant := false) -> bool:
	if anim != null or not sim.can_move(): return false
	if story != null and story.before_move(self, instant): return true   # [story] 拔營 beat：撳咗確定、動畫之前播，播完先郁
	if instant:
		var ok = sim.move_next(); _after_move(); return ok
	close_sheet(); _close_picker()
	anim = {"t": 0.0, "from": sim.ci(), "done": false, "line": _move_line()}
	sim.paused = true; _snd("whoosh")
	return true
func offline_gain(ms: float) -> Dictionary:
	var r = sim.offline_gain(ms)
	if visible and float(r.get("coins", 0.0)) > 0.0: _show_card(r)
	return r

# ================= 建介面 =================
func _build() -> void:
	if frame != null: return
	sim = SIM.new()
	story = load("res://game/outpost/mv_story.gd").new()   # [story]
	mot = MOT.new()   # [motion]
	if not embed: camp = load("res://game/outpost/mv_camp.gd").new(); camp.sc = self   # [camp]（[unify] 嵌入模式取消營地）
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_IGNORE if embed else Control.MOUSE_FILTER_STOP
	clip_contents = true
	bg = TextureRect.new(); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.modulate = Color(0.7, 0.68, 0.76); add_child(bg)
	frame = Control.new(); frame.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(frame)
	stage = Control.new(); stage.mouse_filter = Control.MOUSE_FILTER_IGNORE if embed else Control.MOUSE_FILTER_STOP; frame.add_child(stage)
	stage.draw.connect(_draw_stage); stage.gui_input.connect(_stage_input)
	sheet = PanelContainer.new(); sheet.visible = false; sheet.mouse_filter = Control.MOUSE_FILTER_STOP
	var s = UIKit.sb(PAPER, 14, LINE, 2, Vector4(14, 10, 14, 12)); s.corner_radius_bottom_left = 0; s.corner_radius_bottom_right = 0
	sheet.add_theme_stylebox_override("panel", s); sheet.custom_minimum_size = Vector2(FW, 0); frame.add_child(sheet)
	sheet_box = VBoxContainer.new(); sheet_box.add_theme_constant_override("separation", 6); sheet.add_child(sheet_box)
	over = Control.new(); over.mouse_filter = Control.MOUSE_FILTER_IGNORE; frame.add_child(over); over.draw.connect(_draw_over)
	if ResourceLoader.exists("res://game/outpost/chain_panel.gd"): load("res://game/outpost/chain_panel.gd").attach(self)   # [chainui] 生產鏈掣＋面板
	resized.connect(_layout)
	set_process(false)
	_layout()

func _layout() -> void:
	if frame == null: return
	var sz = size if size.x > 0 else Vector2(FW, 844)
	k = sz.x / FW
	H = sz.y / k
	frame.scale = Vector2(k, k); frame.size = Vector2(FW, H); frame.position = Vector2.ZERO
	stage.size = frame.size; over.size = frame.size
	top_pad = 0.0; bot_pad = 0.0
	if main != null and is_instance_valid(main) and is_inside_tree():
		var cm = main.get_script().get_script_constant_map() if main.get_script() != null else {}
		var th = float(cm.get("TOP_H", 0.0)); var nh = float(cm.get("NAV_H", 0.0))
		var my = get_global_rect(); var mr = main.get_global_rect()
		top_pad = maxf(0.0, (mr.position.y + th - my.position.y) / k)
		bot_pad = maxf(0.0, (my.end.y - (mr.end.y - nh)) / k)
	if embed: top_pad = embed_top / k; bot_pad = 0.0   # [unify]
	sim.relayout()
	_clamp_cam(true)
	if sheet.visible: _place_sheet()

func view_h() -> float: return H - top_pad - bot_pad
func w2s(p: Vector2) -> Vector2:
	if zone: return (p - Vector2(zt.x, zt.y)) * float(zt.z)   # [zone]
	return Vector2(p.x, p.y - cam + top_pad)
func s2w(p: Vector2) -> Vector2:
	if zone: return p / float(zt.z) + Vector2(zt.x, zt.y)   # [zone]
	return Vector2(p.x, p.y + cam - top_pad)
func vx0() -> float: return 0.0                                                 # [zone] 世界字／氣泡夾邊：世界範圍（舊豎條 0..390）
func vx1() -> float: return float(sim.L.get("w", FW)) if zone and sim != null else FW
func view_x0() -> float: return float(zt.x) if zone else 0.0                    # [zone] 畫面可見世界 x 範圍
func view_x1() -> float: return float(zt.x) + FW / float(zt.z) if zone else FW
func cam_min() -> float: return -HUD_H * 0.6
func cam_max() -> float: return maxf(cam_min(), world_h() - view_h())
func world_h() -> float: return maxf(float(sim.L.get("h", 844)), camp.bottom()) if camp != null and sim.st() != null else float(sim.L.get("h", 844))   # [camp] 地圖底加營地
# [camp] 頂部「生產鏈」掣（chain_panel.gd）擺位：影響力條下面，先試右邊、再試左邊、再試右邊低啲；
#   邊個位冇遮住台名牌／台／營地建築就用邊個（而家用緊嘅位冇遮就唔郁，避免閃）
var _plates: Array = []
var _cb_pos = null
var _drects: Array = []   # [polish4] 今格已經畫咗嘅對白框
var _wrects: Array = []   # [polish4] 今格客人要貨氣泡（連脾氣牌）位，對白框避開
var _cb_sz := Vector2.ZERO   # [play]
func chain_btn_pos(sz: Vector2) -> Vector2:
	_cb_sz = sz   # [play] 記低掣大細（對白框要避開）
	var y0 = (float(sim.war.hud_y(self)) if sim != null and sim.war != null else top_pad + HUD_H) + 48.0
	var cands = [Vector2(FW - sz.x - 8.0, y0), Vector2(8.0, y0)]
	for k in range(1, 4): cands.append_array([Vector2(FW - sz.x - 8.0, y0 + 110.0 * k), Vector2(8.0, y0 + 110.0 * k)])
	var best = cands[0]; var best_a = INF
	if _cb_pos != null:   # 而家個位排第一
		for c in cands: if c.is_equal_approx(_cb_pos): cands.erase(c); cands.push_front(_cb_pos); break
	for c in cands:
		var a = _cover(Rect2(s2w(c), sz).grow(4))
		if a <= 0.0: _cb_pos = c; return c
		if a < best_a: best_a = a; best = c
	_cb_pos = best
	return best
func _cover(r: Rect2) -> float:
	var a = 0.0
	for q in _plates: a += r.intersection(q).get_area() * 3.0
	for k in _wbtns:
		if k.begins_with("st:") or k.begins_with("camp") or k.begins_with("unl:"): a += r.intersection(_wbtns[k]).get_area()
	if sim != null and sim.plus != null:   # [polish4] 唔好遮住事件名（「棺材自己開蓋」嗰啲）同左下小卡
		for q in sim.plus.label_rects: if q is Rect2: a += r.intersection(q).get_area() * 3.0
		for k in sim.plus._btn: if not str(k).begins_with("card:"): a += r.intersection(Rect2(s2w(sim.plus._btn[k].position), sim.plus._btn[k].size)).get_area() * 3.0
		if embed and _pill_rect is Rect2 and hud_k > 0.5: a += r.intersection(Rect2(s2w(_pill_rect.position), _pill_rect.size)).get_area() * 3.0
	return a
func cam_camp() -> void:   # [camp] 鏡頭移去營地
	if camp == null: return   # [unify]
	close_sheet(); _close_picker(); cam_v = 0.0
	cam_tgt = clampf(camp.top() - HUD_H - 6.0, cam_min(), cam_max())
func focus_camp(id: String) -> bool:   # [camp] 鏡頭移去營地某間建築（主線任務條撳落去用）
	if camp == null: return false   # [unify]
	var it = camp.item(id)
	if it == null: return false
	close_sheet(); _close_picker(); cam_v = 0.0
	cam_tgt = clampf(float(it.y) - view_h() * 0.6, cam_min(), cam_max())
	return true
func _clamp_cam(hard := false) -> void:
	var lo = cam_min(); var hi = cam_max()
	if sheet != null and sheet.visible: lo -= 260.0; hi += 420.0   # 開住升級條：可以拉過界，等個台唔俾遮住
	if hard: cam = clampf(cam, lo, hi)
	elif cam < lo or cam > hi:
		cam = lerpf(cam, clampf(cam, lo, hi), 0.25); cam_v = 0.0
func focus(wy: float, screen_y: float, wx := NAN) -> void:   # 將世界 y 移去畫面 screen_y
	if zone: zfocus = [wy, screen_y, wx]; return   # [zone] 交俾村子 2D 鏡頭（mv_embed）
	cam_tgt = wy + top_pad - screen_y
func _step_cam(dt: float) -> void:
	if _press != null and _press.drag: return
	if cam_tgt != null:
		cam = lerpf(cam, float(cam_tgt), minf(1.0, dt * 7.0)); cam_v = 0.0
		if absf(cam - float(cam_tgt)) < 0.5: cam = float(cam_tgt); cam_tgt = null
	elif absf(cam_v) > 1.0:
		cam += cam_v * dt; cam_v *= pow(0.04, dt)    # 慣性
	else: cam_v = 0.0
	_clamp_cam()
func cam_home() -> void:   # 開場：鏡頭對住櫃台
	cam = float(sim.L.counter_y) - view_h() * 0.62; cam_tgt = null; cam_v = 0.0; _clamp_cam(true)

func _set_bg() -> void:
	var b = str(MD.map_def(sim.ci()).get("bg", "village"))
	var key = b if b.begins_with("bg_") else "bg_" + b
	bg_tex = Spr.get_tex(key) if Spr.ok(key) else Spr.get_tex("bg_village")
	bg.texture = null; bg.visible = false

func _prefill() -> void:   # 開場唔使等：先排兩個客、出兩隻孤魂
	for i in 2: sim.spawn_cust()
	var j = 0
	for c in sim.custs: c.s = sim.queue_s(j); c.pos = sim.queue_pos(j); j += 1
	sim.spawn_foe()

func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])

# ================= 每格 =================
func _process(dt: float) -> void:
	if not visible or sim.st() == null: return
	dt = minf(dt, 0.1)
	t += dt
	if anim != null: _step_anim(dt)
	else: sim.step(dt)
	if not embed: _step_cam(dt)   # [unify]
	else:
		hud_k = move_toward(hud_k, 1.0 if hud_on else 0.0, dt * 5.0)
		if sim.plus.card == null: _pexp = maxf(0.0, _pexp - dt) if hud_on else 0.0   # [polish4] 玩法掣自動收
	_step_amb(dt)
	if camp != null: camp.step(dt)   # [camp]
	if story != null and anim == null: story.tick(self, dt)   # [story]
	_eat_events()
	if mot != null: mot.step(self, dt)   # [motion]
	_step_fx(dt)
	# HUD 冥幣追真數（飛緊嘅錢到咗先跳）
	var real = sim.coins()
	var flying = 0.0
	for p in parts: if p.k == "coin" and p.has("v"): flying += p.v
	var target = real - flying
	if target < coin_show: coin_show = target
	else: coin_show = minf(target, coin_show + maxf(1.0, (target - coin_show) * minf(1.0, dt * 8.0)))
	_save_t += dt
	if _save_t > 2.0: _save_t = 0.0; sim.st().last = J.now()
	_line_t -= dt
	if _line_t <= 0.0: _line_t = _rng.randf_range(7.0, 12.0); _random_line()
	if sheet.visible and sel != "" and fmod(t, 0.5) < dt: _refresh_sheet_btns(); _refresh_recipe()   # [chain]
	stage.queue_redraw(); over.queue_redraw()

func _eat_events() -> void:
	var hud_coin = Vector2(FW - 70, top_pad + 68)
	if story != null: story.eat(self)   # [story] 先換句（客人 say／惡鬼 FOE），再俾 war 出
	sim.war.eat(self)   # [war]
	sim.plus.eat(self)   # [play]
	for e in sim.ev:
		match e.k:
			"pay":
				var amt = float(e.amt)
				var n = clampi(3 + int(log(maxf(1.0, amt)) / log(10.0)), 3, 8)
				for i in n: _coin(w2s(e.pos) + Vector2(_rng.randf_range(-14, 14), _rng.randf_range(-6, 6)), hud_coin, 0.6 + i * 0.06, amt / n)
				_float(e.pos + Vector2(0, -6), "+" + MD.fmt(amt), GOLD, 26 if amt >= 1000 else 22, 1.6)
				if _rng.randf() < 0.6: _snd("coin")
			"leave":
				_float(e.pos, MD.S("leave", "等到嬲，走人！", "等太久，走了！"), Color("#ffb0a0"), 15, 1.2)
			"take":
				_item(e.from, e.to, str(e.gid), 0.32)
			"deliver":
				_burst(e.pos + Vector2(0, -20), Color("#f3e2bd"), 4)
			"collect":
				for i in mini(int(e.n), 6): _item(e.pos + Vector2(_rng.randf_range(-20, 20), -40), sim.counter_slot(str(e.gid)), str(e.gid), 0.45 + i * 0.05)
				_snd("click")
			"made":
				_float(e.pos + Vector2(0, -80), "+" + MD.fmt(e.n), Color("#f0e2c8"), 15, 0.8)
			"stock":   # [chain] 入倉：貨飛去紙紮大屋
				for i in mini(int(e.n), 4): _item(e.pos + Vector2(_rng.randf_range(-16, 16), -40), sim.L.house + Vector2(0, -40), str(e.mid), 0.6 + i * 0.06)
				_float(e.pos + Vector2(0, -100), MD.S("stocked", "入倉 +%s", "入倉 +%s") % MD.fmt(e.n), Color("#9fd8ff"), 15, 1.0)
			"starve":   # [chain]
				_float(e.pos + Vector2(0, -110), _starve_txt(e.miss), Color("#ffb0a0"), 15, 1.4)
			"hit":
				_burst(e.pos, Color("#bfe0ff"), 5 if e.by == "guard" else 8)
				_float(e.pos + Vector2(_rng.randf_range(-8, 8), -10), "-" + MD.fmt(e.dmg), Color("#ffb0a0"), 16, 0.7)
				parts.append({"k": "slash", "p": e.pos, "t": 0.0, "life": 0.22, "a": _rng.randf() * PI})
				if _rng.randf() < 0.4: _snd("scare")
			"kill":
				_burst(e.pos, Color("#9fc8ff"), 14)
				for i in 3: _coin(w2s(e.pos) + Vector2(_rng.randf_range(-10, 10), 0), hud_coin, 0.6 + i * 0.08, float(e.coins) / 3.0)
				_float(e.pos + Vector2(0, -16), "+" + MD.fmt(e.coins), GOLD, 20, 1.3)
				_snd("coin")
			"bang":
				shake[_fence_i(e.pos.x)] = 0.4
				if fence_art():   # [camp] 柵欄喺背景圖：撞擊點出塵＋碎木
					_burst(e.pos + Vector2(0, 6), Color("#b8a888"), 5); _burst(e.pos, Color("#7a5634"), 4)
				if story != null:   # [story] 遊魂句（FOE.roam）：story.eat 揀咗先出
					if e.has("line"): _bubble(e.pos + Vector2(-60, -64), str(e.line), MD.S("foe", "孤魂", "孤魂"), 2.4)
				elif _rng.randf() < 0.5: _bubble(e.pos + Vector2(-60, -64), MD.T(_pick(MD.D().FOE_LINES)), MD.S("foe", "孤魂", "孤魂"), 2.4)
			"rattle":
				shake[_fence_i(e.x)] = 0.3
			"up":
				var p = sim.st_pos(str(e.sid))
				_burst(p + Vector2(0, -60), GOLD, 12)
				_float(p + Vector2(0, -96), "Lv %d → %d" % [int(e.from), int(e.to)], GOLD, 20, 1.4)
				_snd("build")
			"mile":
				var p2 = sim.st_pos(str(e.sid))
				_banner_set(MD.T(MD.st_def(str(e.sid)).get("n")) + MD.S("mile_a", " 到 Lv%d", " 達到 Lv%d") % int(e.lv), MD.S("mile_b", "收益 ×%d！", "收益 ×%d！") % int(e.x), 2.6)
				for i in 4: _burst(p2 + Vector2(_rng.randf_range(-50, 50), -70 + _rng.randf_range(-30, 20)), Color("#ffd27a"), 12)
				_snd("levelUp")
			"unlock":
				var p3 = sim.st_pos(str(e.sid))
				for i in 3: _burst(p3 + Vector2(_rng.randf_range(-40, 40), -50), GOLD, 12)
				_banner_set(MD.S("unl_a", "開新檔", "開新攤"), MD.T(MD.st_def(str(e.sid)).get("n")), 2.2)
				_snd("build")
			"claim":
				_banner_set(MD.S("goal_a", "目標完成", "目標完成"), "+" + MD.fmt(e.coins) + " " + MD.S("coin", "冥幣", "冥幣"), 2.2)
				for i in 6: _coin(Vector2(190, top_pad + 26), hud_coin, 0.5 + i * 0.07, float(e.coins) / 6.0)
				_snd("chest")
			"boost":
				_float(s2w(Vector2(195, top_pad + 150)), MD.S("inc_on", "收益 ×2 開咗！", "收益 ×2 開啟！") if e.kind == "inc" else MD.S("spd_on", "加速 ×2 開咗！", "加速 ×2 開啟！"), Color("#9fe39a"), 20, 1.6)
				_snd("levelUp")
	sim.ev.clear()

func _fence_i(x: float) -> int: return int(x / (FENCE_TW if _has("mvs_fence") else 26.0))
func _random_line() -> void:
	if story != null: story.random_line(self); return   # [story] 排隊 q／等太耐 wait
	for c in sim.custs:
		if c.st == "serve" and c.lines is Array and c.lines.size():
			_bubble(c.pos + Vector2(-90, -120), MD.T(c.lines[_rng.randi() % c.lines.size()]), MD.S("cust", "客人", "客人"), 2.8)
			return

# ================= 特效 =================
func _coin(a: Vector2, b: Vector2, life: float, v := 0.0) -> void:
	if parts.size() >= MAX_PARTS: return
	var p = {"k": "coin", "a": a, "b": b, "t": 0.0, "life": life, "h": _rng.randf_range(40, 80)}
	if v > 0.0: p["v"] = v
	parts.append(p)
func _item(a: Vector2, b: Vector2, gid: String, life: float) -> void:
	if parts.size() >= MAX_PARTS: return
	parts.append({"k": "item", "a": a, "b": b, "t": 0.0, "life": life, "g": gid, "h": 30.0})
func _burst(p: Vector2, col: Color, n: int) -> void:
	for i in n:
		if parts.size() >= MAX_PARTS: return
		var an = _rng.randf() * TAU; var sp = _rng.randf_range(60, 160)
		parts.append({"k": "dot", "p": p, "v": Vector2(cos(an), sin(an)) * sp, "t": 0.0, "life": _rng.randf_range(0.4, 0.8), "c": col})
func _float(p: Vector2, tx: String, col: Color, sz := 16, life := 1.4) -> void:
	if floats.size() >= MAX_FLOATS: floats.pop_front()
	floats.append({"p": p, "text": tx, "c": col, "s": sz, "t": 0.0, "life": life})
# [polish4] 飄字避開事件名（label_rects，世界座標）：撞到就打橫推出框外（推唔出就推上框頂），位移慢慢跟，唔會跳
func _float_dodge(ctx: Ctx, f: Dictionary, lrs: Array) -> Vector2:
	var cur: Vector2 = f.get("dd", Vector2.ZERO)
	var tgt := Vector2.ZERO
	if not lrs.is_empty():
		ctx.font = "900 %dpx sans-serif" % int(f.s); var tw = ctx.measureText(str(f.text)).width + 8.0
		var hh = float(f.s) + 6.0
		for _i in 2:   # 推完再驗一次（兩個事件名相鄰）
			var fr = Rect2(f.p.x + tgt.x - tw / 2.0, f.p.y + tgt.y - hh / 2.0, tw, hh)
			for r in lrs:
				if not (r is Rect2) or not fr.intersects(r): continue
				var lx = r.position.x - tw / 2.0 - 2.0; var rx = r.end.x + tw / 2.0 + 2.0
				var ok_l = lx - tw / 2.0 >= 2.0; var ok_r = rx + tw / 2.0 <= FW - 2.0
				var cx = f.p.x + tgt.x
				if ok_l and (not ok_r or cx - lx <= rx - cx): tgt.x = lx - f.p.x
				elif ok_r: tgt.x = rx - f.p.x
				else: tgt.y = r.position.y - hh / 2.0 - 2.0 - f.p.y
				fr = Rect2(f.p.x + tgt.x - tw / 2.0, f.p.y + tgt.y - hh / 2.0, tw, hh)
	if not f.has("dd"): cur = tgt   # 一出世已經撞：直接放喺框外
	else: cur = cur.lerp(tgt, 0.25)
	f["dd"] = cur
	return cur
func _bubble(p: Vector2, tx: String, who: String, life := 2.6) -> void:
	if bubbles.size() >= 3: bubbles.pop_front()
	bubbles.append({"p": p, "text": tx, "who": who, "t": 0.0, "life": life})
func _banner_set(a: String, b: String, life := 2.4) -> void:
	banner = {"a": a, "b": b, "t": 0.0, "life": life}
func _step_fx(dt: float) -> void:
	for p in parts.duplicate():
		p.t += dt
		if p.k == "dot": p.p += p.v * dt; p.v *= 0.92
		if p.t >= p.life:
			parts.erase(p)
	for f in floats.duplicate():
		f.t += dt; f.p.y -= 26.0 * dt
		if f.t >= f.life: floats.erase(f)
	for b in bubbles.duplicate():
		b.t += dt
		if b.t >= b.life: bubbles.erase(b)
	if banner != null:
		banner.t += dt
		if banner.t >= banner.life: banner = null
	for x in shake.keys():
		shake[x] -= dt
		if shake[x] <= 0.0: shake.erase(x)

# ================= 拔營動畫 =================
# 0–1.4 紙紮屋同檔口摺埋；1.2–3.8 抬住紙紮屋嘅隊伍行出畫面；3.6–4.4 轉黑；4.0 換圖；4.4–5.6 新圖淡入
const A_FOLD := 1.4
const A_WALK := 3.8
const A_SWAP := 4.0
const A_END := 5.6
func _step_anim(dt: float) -> void:
	anim.t += dt
	if not anim.done and anim.t >= A_SWAP:
		anim.done = true
		sim.move_next(); _after_move(false)
	if anim.t >= A_END:
		anim = null; sim.paused = false
		_banner_set(MD.S("arrive", "抵達", "抵達"), MD.T(MD.map_def(sim.ci()).get("name")), 2.6)
		_prefill()
func _after_move(fresh := true) -> void:
	sim.reset_live(); sim.st(); sim.sync(); _tiles_ci = -1
	if camp != null: camp.invalidate()   # [camp]
	_set_bg(); _layout()
	if not embed: cam_home()
	parts.clear(); bubbles.clear(); shake.clear(); amb.g.clear(); amb.f.clear()
	_save()
	if fresh: _prefill()
func _move_line() -> String:
	var ml = MD.map_def(sim.ci()).get("move_line", [])
	return MD.T(ml[_rng.randi() % ml.size()]) if ml is Array and ml.size() else MD.S("move_btn", "拔營！", "拔營！")
func _fold_k() -> float:   # 1 = 正常，0 = 摺晒
	if anim == null: return 1.0
	if anim.done: return 1.0
	return clampf(1.0 - anim.t / A_FOLD, 0.0, 1.0)

# ================= 畫 =================
static var _mb_s = null
static func _mbf() -> bool:   # [mapbattle] 分區大地圖打緊仗（行軍／開打／結算）
	if _mb_s == null: _mb_s = load("res://game/zone/zone_battle.gd")
	return _mb_s.fighting()
func _draw_stage() -> void:
	if sim == null or sim.st() == null or sim.L.is_empty(): return
	var ctx = Ctx.new(stage)
	var L = sim.L
	_btns.clear(); _wbtns.clear(); _plates.clear()
	if embed: sim.plus._btn.clear()   # [polish4] 合一地圖：HUD 收埋嗰陣唔留舊小卡掣
	var vy0 = cam - top_pad - 10.0; var vy1 = cam - top_pad + H + 10.0     # 鏡頭內（世界 y）
	ctx.save()
	if zone:   # [zone] 2D 鏡頭；地面由村子畫
		vy0 = float(zt.y) - 10.0; vy1 = float(zt.y) + H / float(zt.z) + 10.0
		ctx.scale(float(zt.z), float(zt.z)); ctx.translate(-float(zt.x), -float(zt.y))
		_tx0 = vx0(); _tx1 = vx1()
	else:
		ctx.translate(0, top_pad - cam)
		_draw_ground(ctx, vy0, vy1)
		if embed and embed_ground != null: embed_ground.call(ctx, vy0, vy1)   # [village2]
	var fk = _fold_k()
	var walking = anim != null and not anim.done and anim.t >= A_FOLD - 0.2
	# 圍欄外孤魂＋圍欄（地圖頂）
	if zone or vy0 < L.fence_y + 80.0:   # [zone2] 分區地圖：野外區可以喺大排檔下面
		var fo = sim.foes.duplicate(); fo.sort_custom(func(a, b): return a.pos.y < b.pos.y)
		for f in fo: _draw_foe(ctx, f)
		if not fence_art(): _draw_fence(ctx)   # [camp] fence_art：柵欄喺背景圖
		if not walking:
			for g in sim.guards: _draw_guard(ctx, g)
			if not _mbf(): _draw_guard_slots(ctx)   # [mapbattle] 打緊仗：收埋「派鬼守夜」牌
	_draw_amb_ghosts(ctx, vy0, vy1)
	# 佈景＋台＋人：按 y 排（只畫鏡頭內）
	var items = []
	var Ly = MD.layout(sim.ci())
	for d in Ly.get("decor", []):
		var dy = float(d.y)
		if str(d.k) in ["stream", "bridge", "fogbank"]: continue
		if dy < vy0 - 20.0 or dy - 160.0 > vy1: continue
		var dd = d
		items.append([dy, func(): _draw_decor(ctx, dd)])
	if camp != null: camp.add_items(ctx, items, vy0, vy1, fk, walking)   # [camp] 營地建築
	if fk > 0.04 and L.counter_y + 40.0 > vy0 and L.counter_y - 220.0 < vy1:
		if not embed: items.append([L.house.y, func(): _draw_house(ctx, fk)])   # [unify] 嵌入：紙紮大屋＝原版村子（出村門後面）
		items.append([L.counter_y, func(): _draw_counter(ctx, fk)])
	if not walking:
		for c in sim.custs:
			if c.pos.y < vy0 - 20.0 or c.pos.y - 160.0 > vy1: continue
			var cc = c
			items.append([c.pos.y + c.slot * 0.01, func(): _draw_cust(ctx, cc)])
	if fk > 0.04:
		for sid in MD.stations(sim.ci()):
			var sp = sim.st_pos(sid)
			if sp.y + 90.0 < vy0 or sp.y - 160.0 > vy1: continue
			var s2 = sid
			items.append([sp.y - 30.0, func(): _draw_station(ctx, s2, fk)])
	if not walking:
		for w in sim.workers:
			if w.pos.y < vy0 - 20.0 or w.pos.y - 120.0 > vy1: continue
			var ww = w
			items.append([w.pos.y, func(): _draw_worker(ctx, ww)])
	if embed and embed_draw != null: embed_draw.call(ctx, vy0, vy1, items)   # [unify] 留位、挑夫鬼（入 y 排序）
	if mot != null and not walking: mot.add_items(self, ctx, items, vy0, vy1)   # [motion] 粒子、領班
	items.sort_custom(func(a, b): return a[0] < b[0])
	for it in items: it[1].call()
	sim.war.draw_world(self, ctx, vy0, vy1)   # [war] 義勇軍＋霸檔標記
	sim.plus.draw_world(self, ctx, vy0, vy1)   # [play] 夜色、事件記認、決定掣
	if walking: _draw_proc(ctx)
	if not walking:
		_wrects.clear()   # [polish4] 要貨氣泡由櫃台頭排起，撞到就推高
		var qs = sim.custs.duplicate(); qs.sort_custom(func(a, b): return int(a.get("slot", 0)) < int(b.get("slot", 0)))
		if not _mbf():   # [mapbattle] 打緊仗：收埋要貨氣泡
			for c in qs: if c.st != "out" and c.pos.y > vy0 and c.pos.y - 200.0 < vy1: _draw_want(ctx, c)
	_draw_fog(ctx, vy0, vy1)
	_draw_amb_fly(ctx)
	_draw_parts(ctx, true)
	var lrs: Array = sim.plus.label_rects if sim.plus != null else []   # [polish4] 事件名位置（play 線記低）
	for f in floats:
		var a = clampf(1.0 - (f.t / f.life - 0.6) / 0.4, 0.0, 1.0)
		var sc = 1.0 + 0.3 * maxf(0.0, 1.0 - f.t / 0.15)
		var fp: Vector2 = f.p + _float_dodge(ctx, f, lrs)
		ctx.globalAlpha = a; _txt(ctx, f.text, fp.x, fp.y, int(f.s * sc), f.c, "center", 900, 5); ctx.globalAlpha = 1.0
	_brects.clear(); _drects.clear()
	if embed:   # [unify] 對白框避開台名牌、台
		for q in _plates: _brects.append(q.grow(2))
		for kk in _wbtns: if kk.begins_with("st:"): _brects.append(_wbtns[kk])
	_brects.append_array(sim.plus.avoid_rects(self))
	if zone: _brects.append_array(load("res://game/zone/zone_taunt.gd").world_rects)   # [mapbattle] 閒談對白框避開王嘅叫囂泡泡   # [play] 對白框避開事件名同右上「生產鏈」掣
	if not _mbf():   # [mapbattle] 打緊仗：收埋閒談對白框
		for b in bubbles: _draw_bubble(ctx, b)
	if embed and anim != null:   # [unify] 拔營：大排檔區＋村外區淡出、換圖、淡入（原村子唔變）
		var fa = clampf(1.0 - absf(float(anim.t) - A_SWAP) / 1.8, 0.0, 1.0)
		if fa > 0.0: ctx.fillStyle = "rgba(8,4,10,%.3f)" % fa; ctx.fillRect(0, maxf(vy0, -40.0), float(sim.L.get("w", FW)), minf(vy1, world_h()) - maxf(vy0, -40.0))
	ctx.restore()
	_tx0 = 0.0; _tx1 = FW   # [zone] HUD 用畫面闊
	_draw_parts(ctx, false)
	if not embed or hud_k > 0.01:   # [unify] 嵌入：睇到大排檔區先出 HUD
		ctx.globalAlpha = hud_k if embed else 1.0
		_draw_hud(ctx)
		ctx.globalAlpha = 1.0

# ---------------- 地面：背景圖直向鋪（隔塊反轉接縫）＋路＋小河＋橋 ----------------
func _draw_ground(ctx: Ctx, vy0: float, vy1: float) -> void:
	var L = sim.L
	if embed: vy1 = minf(vy1, world_h())   # [unify] 嵌入：只畫大排檔區（下面係原村子）
	ctx.fillStyle = "#1a1620"; ctx.fillRect(0, vy0, FW, vy1 - vy0)
	if _draw_tiles(ctx, vy0, vy1): return   # [camp] 新手繪背景（MAPS[ci].bg_tiles）：路、河、橋都喺圖入面，唔再程序畫
	if bg_tex != null:
		# 頂：成張背景（天、遠景）；下面：用背景下半截（地面）一節節鋪，隔節左右反轉
		var iw = float(bg_tex.get_width()); var ih = float(bg_tex.get_height())
		var th = FW * ih / iw
		if vy0 < th: ctx.drawImage(bg_tex, 0, 0, FW, th)
		var sy0 = ih * 0.58; var sh = ih * 0.38; var stp = FW * sh / iw
		var i0 = maxi(0, int(floor((vy0 - th) / stp))); var i1 = int(floor((vy1 - th) / stp))
		for i in range(i0, i1 + 1):
			var y = th - 30.0 + i * stp
			if y + stp < vy0 or y > vy1: continue
			if i % 2 == 0: ctx.drawImage(bg_tex, 0, sy0, iw, sh, 0, y, FW, stp + 1)
			else:
				ctx.save(); ctx.translate(FW, 0); ctx.scale(-1, 1); ctx.drawImage(bg_tex, 0, sy0, iw, sh, 0, y, FW, stp + 1); ctx.restore()
	ctx.fillStyle = "rgba(12,8,20,.32)"; ctx.fillRect(0, vy0, FW, vy1 - vy0)
	var Ly = MD.layout(sim.ci())
	for d in Ly.get("decor", []):
		if str(d.k) == "stream" and absf(float(d.y) - (vy0 + vy1) / 2.0) < (vy1 - vy0): _draw_stream(ctx, float(d.y))
	# 村道
	var rd = L.road
	for pass_i in 2:
		ctx.strokeStyle = "rgba(40,28,20,.55)" if pass_i == 0 else "rgba(150,120,85,.55)"
		ctx.lineWidth = 50.0 if pass_i == 0 else 40.0; ctx.lineJoin = "round"
		ctx.beginPath(); ctx.moveTo(rd[0].x, rd[0].y)
		for i in range(1, rd.size()): ctx.lineTo(rd[i].x, rd[i].y)
		ctx.stroke()
	ctx.fillStyle = "rgba(90,70,50,.5)"   # 路上石仔
	for i in range(1, rd.size()):
		var a = rd[i - 1]; var b = rd[i]
		if maxf(a.y, b.y) < vy0 or minf(a.y, b.y) > vy1: continue
		var n = int(a.distance_to(b) / 26.0)
		for k2 in n:
			var q = a.lerp(b, (k2 + 0.5) / maxf(1, n)) + Vector2(sin(k2 * 7.1 + i) * 12.0, 0)
			Art.el(ctx, q.x, q.y, 3.0, 2.0, "rgba(70,55,40,.55)")
	for d in Ly.get("decor", []):
		if str(d.k) == "bridge" and absf(float(d.y) - (vy0 + vy1) / 2.0) < (vy1 - vy0): _draw_bridge(ctx, float(d.x), float(d.y))
	_draw_camp_road(ctx, vy0, vy1)   # [camp]

# [camp] 營地泥路（layout.camp.road）：比村道窄少少
func _draw_camp_road(ctx: Ctx, vy0: float, vy1: float) -> void:
	if camp == null: return   # [unify]
	var P = camp.road()
	if P.size() < 2 or P[P.size() - 1].y < vy0 or P[0].y > vy1: return
	for pass_i in 2:
		ctx.strokeStyle = "rgba(40,28,20,.5)" if pass_i == 0 else "rgba(140,110,78,.5)"
		ctx.lineWidth = 34.0 if pass_i == 0 else 26.0; ctx.lineJoin = "round"; ctx.lineCap = "round"
		ctx.beginPath(); ctx.moveTo(P[0].x, P[0].y)
		for i in range(1, P.size() - 1):   # 彎路：折點中間用二次曲線
			var m = (P[i] + P[i + 1]) / 2.0
			ctx.quadraticCurveTo(P[i].x, P[i].y, m.x, m.y)
		ctx.lineTo(P[P.size() - 1].x, P[P.size() - 1].y)
		ctx.stroke()
	ctx.lineCap = "butt"

# [camp] 新背景：MAPS[ci].bg_tiles = ["圖鍵1","圖鍵2","圖鍵3"]，每塊縮到 390 闊，按次序直向疊；
#   接縫：下一塊頂部 BG_SEAM px 疊落上一塊度，逐步淡入。地圖長過全部圖：由第 2 塊起循環（第 1 塊係村外荒野＋柵欄）。
#   有任何一個圖鍵未有圖 → 回 false（照舊鋪法）。
const BG_SEAM := 60.0
var _tiles_ci := -1
var _tiles: Array = []
func _bg_tiles() -> Array:
	if _tiles_ci == sim.ci(): return _tiles
	_tiles_ci = sim.ci(); _tiles = []
	var keys = MD.map_def(sim.ci()).get("bg_tiles", [])
	if not (keys is Array) or keys.is_empty(): return _tiles
	var o = []
	for k in keys:
		var key = str(k)
		if not _has(key): return _tiles
		o.append(Spr.get_tex(key))
	_tiles = o
	return _tiles
func tile_rects() -> Array:   # [[tex, y, h], ...]（世界座標，蓋晒 world_h()）
	var T = _bg_tiles(); var o = []
	if T.is_empty(): return o
	var y = 0.0; var i = 0; var wh = world_h() + 40.0
	while y < wh and i < 200 and not (embed and i >= T.size()):   # [unify] 嵌入：兩塊就夠
		var ti = i if i < T.size() else (1 + (i - 1) % maxi(1, T.size() - 1) if T.size() > 1 else 0)
		var tx: Texture2D = T[ti]
		var th = FW * tx.get_height() / maxf(1.0, tx.get_width())
		o.append([tx, y, th])
		y += th - BG_SEAM; i += 1
	return o
func _draw_tiles(ctx: Ctx, vy0: float, vy1: float) -> bool:
	var R = tile_rects()
	if R.is_empty(): return false
	for i in R.size():
		var tx: Texture2D = R[i][0]; var y: float = R[i][1]; var th: float = R[i][2]
		if y > vy1 or y + th < vy0: continue
		var iw = float(tx.get_width()); var ih = float(tx.get_height()); var k2 = ih / th
		if i == 0: ctx.drawImage(tx, 0, y, FW, th); continue
		var n = 12; var sh = BG_SEAM / n   # 接縫淡入
		for j in n:
			ctx.globalAlpha = (j + 1.0) / (n + 1.0)
			ctx.drawImage(tx, 0, j * sh * k2, iw, sh * k2, 0, y + j * sh, FW, sh + 0.5)
		ctx.globalAlpha = 1.0
		ctx.drawImage(tx, 0, BG_SEAM * k2, iw, ih - BG_SEAM * k2, 0, y + BG_SEAM, FW, th - BG_SEAM)
	ctx.fillStyle = "rgba(12,8,20,.16)"; ctx.fillRect(0, vy0, FW, vy1 - vy0)
	return true
func fence_art() -> bool: return J.t(MD.layout(sim.ci()).get("fence_art"))   # [camp] 柵欄畫咗喺背景圖

func _draw_stream(ctx: Ctx, y: float) -> void:
	ctx.fillStyle = "rgba(30,50,70,.75)"; ctx.fillRect(0, y - 20, FW, 40)
	ctx.strokeStyle = "rgba(160,200,230,.35)"; ctx.lineWidth = 1.5
	for i in 7:
		var x = fmod(i * 61.0 + t * 18.0, FW + 40.0) - 20.0; var yy = y - 10 + (i % 3) * 9
		ctx.beginPath(); ctx.moveTo(x, yy); ctx.quadraticCurveTo(x + 10, yy - 3, x + 20, yy); ctx.stroke()
	ctx.fillStyle = "rgba(60,90,60,.5)"; ctx.fillRect(0, y - 23, FW, 4); ctx.fillRect(0, y + 19, FW, 4)
func _draw_bridge(ctx: Ctx, x: float, y: float) -> void:
	Art.rr(ctx, x - 36, y - 26, 72, 52, 4, "#7a5a38", "#3a2410", 2)
	for i in 6: Art.rr(ctx, x - 34, y - 24 + i * 8.6, 68, 6, 1, "#9a7448")
	ctx.strokeStyle = "#4a3018"; ctx.lineWidth = 3
	for sx in [-36.0, 36.0]:
		ctx.beginPath(); ctx.moveTo(x + sx, y - 30); ctx.lineTo(x + sx, y + 30); ctx.stroke()
		for k2 in 3: Art.rr(ctx, x + sx - 3, y - 30 + k2 * 28, 6, 8, 1, "#5a3a20")
	_lantern_at(ctx, Vector2(x - 36, y - 32), 0.8, 1.3)

# ---------------- 佈景 ----------------
const DECOR_W := {"tree": 120.0, "tree_bare": 110.0, "stump": 50.0, "scarecrow": 64.0, "paddy": 70.0, "banana": 110.0, "lamppost": 44.0,
	"street_lanternR": 30.0, "street_lanternW": 30.0, "pr_boxes": 52.0, "pr_cart": 60.0, "pr_pot": 46.0, "pr_stools": 44.0, "pr_cone": 26.0,
	"pr_motorbike": 72.0, "pr_bin": 36.0, "pr_puddle": 60.0, "pr_sign": 40.0, "pr_durianbox": 50.0, "pr_wire": 70.0, "of_plant": 40.0, "of_water": 34.0, "of_cabinet": 44.0}
func _draw_decor(ctx: Ctx, d: Dictionary) -> void:
	var k2 = str(d.k); var x = float(d.x); var y = float(d.y); var sc = float(d.get("s", 1.0)); var ph = x * 0.37 + y * 0.11
	match k2:
		"grass": _grass(ctx, x, y, sc, ph)
		"rock":
			Art.el(ctx, x, y - 6 * sc, 14 * sc, 9 * sc, "#4a4650", "#2a2630", 1.2); Art.el(ctx, x - 4 * sc, y - 9 * sc, 5 * sc, 3 * sc, "rgba(140,140,150,.4)")
		"lantern": _lantern_post(ctx, x, y, sc, ph)
		_:
			if not _has(k2): return
			var w = DECOR_W.get(k2, 60.0) * sc
			ctx.save()
			if k2 in ["tree", "tree_bare", "banana", "paddy"]:   # 樹同草：輕輕擺
				ctx.translate(x, y); ctx.transform(1, 0, sin(t * 0.9 + ph) * 0.025, 1, 0, 0); ctx.translate(-x, -y)
			if J.t(d.get("f")): ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
			Art.el(ctx, x, y, w * 0.32, w * 0.07, "rgba(0,0,0,.3)")
			var r = Art.put(ctx, k2, x, y + 2, w)
			ctx.restore()
			if k2 in ["lamppost", "street_lanternR", "street_lanternW"]:   # 燈：閃
				var fl = 0.75 + 0.25 * sin(t * 7.0 + ph) * sin(t * 2.3 + ph)
				var gp = Vector2(x, r.position.y + r.size.y * 0.18)
				Art.el(ctx, gp.x, gp.y, 26 * fl, 26 * fl, "rgba(255,190,110,.13)"); Art.el(ctx, gp.x, gp.y, 12 * fl, 12 * fl, "rgba(255,210,140,.22)")
func _grass(ctx: Ctx, x: float, y: float, sc: float, ph: float) -> void:
	ctx.strokeStyle = "rgba(90,120,70,.85)"; ctx.lineWidth = 2
	for i in 5:
		var bx = x - 10 * sc + i * 5 * sc; var sw = sin(t * 1.8 + ph + i * 0.6) * 4.0 * sc
		ctx.beginPath(); ctx.moveTo(bx, y); ctx.quadraticCurveTo(bx + sw * 0.4, y - 8 * sc, bx + sw, y - (14 + (i % 2) * 5) * sc); ctx.stroke()
func _lantern_post(ctx: Ctx, x: float, y: float, sc: float, ph: float) -> void:
	ctx.strokeStyle = "#3a2a1a"; ctx.lineWidth = 3
	ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x, y - 56 * sc); ctx.lineTo(x + 18 * sc, y - 56 * sc); ctx.stroke()
	_lantern_at(ctx, Vector2(x + 18 * sc, y - 56 * sc), sc, ph)
func _lantern_at(ctx: Ctx, top: Vector2, sc: float, ph: float) -> void:
	var a = sin(t * 1.6 + ph) * 0.18
	var c = top + Vector2(sin(a) * 12 * sc, cos(a) * 12 * sc)
	ctx.strokeStyle = "#2a1a10"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(top.x, top.y); ctx.lineTo(c.x, c.y); ctx.stroke()
	var fl = 0.7 + 0.3 * sin(t * 8.0 + ph * 3.0) * sin(t * 3.1 + ph)
	Art.el(ctx, c.x, c.y + 8 * sc, 22 * sc * fl, 22 * sc * fl, "rgba(255,150,80,.14)")
	Art.el(ctx, c.x, c.y + 8 * sc, 7 * sc, 9 * sc, "#d8452e", "#5a1a10", 1.2)
	Art.rr(ctx, c.x - 4 * sc, c.y - 1 * sc, 8 * sc, 3 * sc, 1, "#f0c060"); Art.rr(ctx, c.x - 4 * sc, c.y + 16 * sc, 8 * sc, 3 * sc, 1, "#f0c060")

# ---------------- 霧（慢慢飄） ----------------
func _draw_fog(ctx: Ctx, vy0: float, vy1: float) -> void:
	var Ly = MD.layout(sim.ci())
	for d in Ly.get("decor", []):
		if str(d.k) != "fogbank": continue
		var y = float(d.y)
		if y < vy0 - 120.0 or y > vy1 + 120.0: continue
		var sc = float(d.get("s", 1.0))
		for i in 3:
			var x = fmod(float(d.x) + t * (9.0 + i * 4.0) + i * 140.0, FW + 300.0) - 150.0
			Art.el(ctx, x, y + i * 26.0 - 20.0, 150 * sc, 34 * sc, "rgba(190,200,220,.07)")
			Art.el(ctx, x + 40, y + i * 26.0 - 24.0, 90 * sc, 20 * sc, "rgba(200,210,230,.06)")

# ---------------- 環境：背景遊魂、烏鴉、紙錢 ----------------
func _step_amb(dt: float) -> void:
	if zone: amb.g.clear(); amb.f.clear(); return   # [zone] 分區地圖：唔出背景遊魂／烏鴉（佢哋由舊豎條兩邊飛入）
	var vy0 = cam - top_pad + HUD_H; var vh = view_h() - HUD_H
	amb.tg -= dt
	if amb.tg <= 0.0:
		amb.tg = _rng.randf_range(6.0, 12.0)
		if amb.g.size() < AMB_GHOSTS:
			var l2r = _rng.randf() < 0.5
			amb.g.append({"x": -40.0 if l2r else FW + 40.0, "y": vy0 + _rng.randf_range(0.2, 0.8) * vh, "v": (22.0 if l2r else -22.0) * _rng.randf_range(0.7, 1.3), "ph": _rng.randf() * 9.0})
	amb.tf -= dt
	if amb.tf <= 0.0:
		amb.tf = _rng.randf_range(7.0, 15.0)
		if amb.f.size() < AMB_FLY:
			if _rng.randf() < 0.45:
				var l2r2 = _rng.randf() < 0.5
				amb.f.append({"k": "crow", "x": -30.0 if l2r2 else FW + 30.0, "y": vy0 + _rng.randf_range(0.05, 0.4) * vh, "vx": (90.0 if l2r2 else -90.0), "vy": _rng.randf_range(-10, 6), "ph": 0.0})
			else:
				for i in 4: amb.f.append({"k": "paper", "x": _rng.randf_range(20, FW - 20), "y": vy0 - 10.0 - i * 30.0, "vx": _rng.randf_range(-12, 12), "vy": _rng.randf_range(26, 40), "ph": _rng.randf() * 9.0})
	for g in amb.g.duplicate():
		g.x += g.v * dt
		if g.x < -60.0 or g.x > FW + 60.0: amb.g.erase(g)
	for f in amb.f.duplicate():
		f.x += f.vx * dt; f.y += f.vy * dt; f.ph += dt
		if f.x < -60.0 or f.x > FW + 60.0 or f.y > vy0 + vh + 40.0: amb.f.erase(f)
func _draw_amb_ghosts(ctx: Ctx, vy0: float, vy1: float) -> void:
	for g in amb.g:
		if g.y < vy0 or g.y > vy1 or (embed and g.y > world_h() - 60.0): continue   # [unify]
		Art.draw_char(ctx, "youhun", g.x, g.y + sin(t * 1.4 + g.ph) * 8.0, CS * 0.75, {"t": t + g.ph, "flip": g.v < 0, "alpha": 0.22, "noShadow": true})
func _draw_amb_fly(ctx: Ctx) -> void:
	for f in amb.f:
		if embed and f.y > world_h() - 40.0: continue   # [unify]
		if f.k == "crow":
			if _has("crowfly"):
				ctx.save(); ctx.translate(f.x, f.y)
				if f.vx < 0: ctx.scale(-1, 1)
				ctx.scale(1.0, 0.75 + 0.25 * sin(f.ph * 12.0))
				Art.put(ctx, "crowfly", 0, 10, 40); ctx.restore()
			else:
				ctx.strokeStyle = "#141018"; ctx.lineWidth = 2.5; var w2 = sin(f.ph * 12.0) * 6.0
				ctx.beginPath(); ctx.moveTo(f.x - 10, f.y - w2); ctx.lineTo(f.x, f.y); ctx.lineTo(f.x + 10, f.y - w2); ctx.stroke()
		else:
			ctx.save(); ctx.translate(f.x + sin(f.ph * 2.0) * 10.0, f.y); ctx.rotate(sin(f.ph * 3.0) * 0.8)
			Art.rr(ctx, -6, -4 * absf(cos(f.ph * 4.0)) - 0.5, 12, 8 * absf(cos(f.ph * 4.0)) + 1, 1, "rgba(230,200,120,.75)", "rgba(120,80,20,.7)", 0.8)
			ctx.restore()

func _draw_over() -> void:
	if sim == null or sim.st() == null or sim.L.is_empty(): return
	var ctx = Ctx.new(over)
	if anim != null: _draw_anim(ctx)
	if banner != null and not _mbf(): _draw_banner(ctx)   # [mapbattle] 打緊仗唔出橫額
	if card != null: _draw_card(ctx)

# ---------------- 圍欄 ----------------
const FENCE_TW := 130.0
func _draw_fence(ctx: Ctx) -> void:
	var y = sim.L.fence_y
	Art.rr(ctx, 0, y - 2, FW, 14, 0, "rgba(0,0,0,.35)")
	if _has("mvs_fence"):   # 美術圍欄：一節節鋪，撞欄嗰節會搖
		for i in int(ceil(FW / FENCE_TW)) + 1:
			var sh = sin(t * 40.0) * 2.5 if shake.has(i) else 0.0
			Art.put(ctx, "mvs_fence", i * FENCE_TW + FENCE_TW / 2.0 - 6.0 + sh, y + 10.0, FENCE_TW + 4.0)
		return
	for i in 16:
		var x = i * 26.0 + 8.0
		var sh = sin(t * 40.0) * 2.5 if shake.has(i) else 0.0
		Art.poly(ctx, [x - 6 + sh, y + 8, x - 6 + sh, y - 30, x + sh, y - 38, x + 6 + sh, y - 30, x + 6 + sh, y + 8], "#d8c49a", "#4a3420", 1.5)
		Art.el(ctx, x + sh, y - 22, 2.5, 2.5, "#8a2a1e")
	ctx.fillStyle = "#b8a070"; ctx.fillRect(0, y - 24, FW, 5); ctx.fillRect(0, y - 6, FW, 5)
	ctx.fillStyle = "rgba(60,40,20,.6)"; ctx.fillRect(0, y - 19, FW, 1.5); ctx.fillRect(0, y - 1, FW, 1.5)
func _map_label(ctx: Ctx) -> void:   # 畫面座標（HUD 下面）
	var md = MD.map_def(sim.ci())
	_txt(ctx, "%s  %d/%d" % [MD.T(md.get("name")), sim.ci() + 1, MD.maps_n()], 10, top_pad + HUD_H + 14, 15, Color("#e8dcc4"), "left", 900, 4, "serif")

func _draw_foe(ctx: Ctx, f: Dictionary) -> void:
	if f.get("boss", false): sim.war.draw_boss(self, ctx, f); return   # [war]
	if mot != null and mot.foe(self, ctx, f): return   # [motion]
	var a = 0.92
	if f.st == "die": a = maxf(0.0, 0.92 - f.t * 1.3)
	var y = f.pos.y + float(f.get("bob", 0.0)) + sin(t * 2.2 + f.ph) * 2.0
	var o = {"t": t + f.ph, "walk": f.get("walk", false) or f.st == "bang", "flip": f.get("flip", false), "alpha": a, "noShadow": true}
	if f.has("hurt"): o["hurt"] = true
	if f.st == "bang": o["atk"] = true
	Art.el(ctx, f.pos.x, y - 26, 30, 30, "rgba(140,190,255,.12)"); Art.el(ctx, f.pos.x, y - 26, 18, 18, "rgba(160,200,255,.14)")
	Art.draw_char(ctx, str(f.k), f.pos.x, y, CS * 0.9, o)
	if f.hp < f.mx and f.st != "die":
		var w = 36.0
		Art.rr(ctx, f.pos.x - w / 2 - 1, y - 62, w + 2, 7, 3, "rgba(0,0,0,.7)")
		Art.rr(ctx, f.pos.x - w / 2, y - 61, w * clampf(f.hp / f.mx, 0, 1), 5, 2, "#e05a4a")

func _draw_guard(ctx: Ctx, g: Dictionary) -> void:
	var o = {"t": t + g.ph, "walk": g.get("walk", false), "flip": g.get("flip", false), "tamed": true, "shadow": true}
	if g.atk > 0.0: o["atk"] = true
	if mot == null or not mot.guard(self, ctx, g, o): Art.draw_char(ctx, str(g.k), g.pos.x, g.pos.y, CS * 0.95, o)   # [motion]
	_txt(ctx, MD.S("guard_tag", "守夜", "守夜"), g.pos.x, g.pos.y + 12, 14, Color("#ffd27a"), "center", 900, 4)

func _draw_guard_slots(ctx: Ctx) -> void:
	var gs = sim.st().guards
	for i in gs.size():
		if gs[i] != null: continue
		var p = sim.guard_home(i)
		_plus(ctx, p, i == 0)
		_wbtns["guard:%d" % i] = Rect2(p.x - 22, p.y - 40, 44, 50)
		if i == 0 and sim.guards.is_empty(): _txt(ctx, MD.S("need_guard", "派鬼守夜", "派鬼守夜"), p.x, p.y + 12, 14, Color("#ffd27a"), "center", 900, 4)

func _plus(ctx: Ctx, p: Vector2, hot: bool) -> void:
	var pulse = 0.6 + 0.4 * sin(t * 3.0 + p.x)
	if embed:   # [unify] 冇派鬼嘅空位：細啲、半透明
		ctx.save(); ctx.globalAlpha = (0.55 if hot else 0.38) + 0.15 * pulse
		Art.el(ctx, p.x, p.y - 12, 10, 10, "rgba(20,14,24,.5)", "#f3d68a" if hot else "#d8cdb6", 1.5)
		_txt(ctx, "＋", p.x, p.y - 11, 14, Color("#f3d68a") if hot else Color("#efe6d2"), "center", 900, 0)
		ctx.restore(); return
	ctx.save(); ctx.globalAlpha = 0.6 + 0.35 * pulse
	Art.el(ctx, p.x, p.y - 16, 15, 15, "rgba(20,14,24,.6)", "#f3d68a" if hot else "#d8cdb6", 2)
	_txt(ctx, "＋", p.x, p.y - 15, 20, Color("#f3d68a") if hot else Color("#efe6d2"), "center", 900, 0)
	ctx.restore()

# ---------------- 紙紮大屋＋櫃台 ----------------
func _has(key: String) -> bool: return key != "" and Spr.ok(key) and Spr.get_tex(key) != null   # 鍵喺登記但圖未匯入都當冇
func _house_key() -> String:
	return "mvs_house" if _has("mvs_house") else "house"
func _draw_house(ctx: Ctx, fk: float) -> void:
	if anim != null and not anim.done and anim.t > A_FOLD: return   # 已經摺埋抬走
	var L = sim.L
	var cx = float(L.house.x); var by = float(L.house.y)
	ctx.save(); ctx.translate(cx, by); ctx.scale(lerpf(0.5, 1.0, fk), fk); ctx.translate(-cx, -by)
	ctx.globalAlpha = 0.95
	Art.put(ctx, _house_key(), cx, by, 168.0)
	ctx.restore()

func _draw_counter(ctx: Ctx, fk: float) -> void:
	var L = sim.L
	var x0 = L.counter_x0; var x1 = L.counter_x1; var y = L.counter_y
	ctx.save(); ctx.translate((x0 + x1) / 2.0, y + 10); ctx.scale(1.0, maxf(0.05, fk)); ctx.translate(-(x0 + x1) / 2.0, -(y + 10))
	if _has("mvs_counter"):
		var ctex = Spr.get_tex("mvs_counter"); var cw = x1 - x0 + 16; var chh = cw * ctex.get_height() / maxf(1.0, ctex.get_width())
		_mist(ctx, "pd:counter", Vector2((x0 + x1) / 2.0, y + 14), cw * 0.92, chh, false)   # [unify] 血霧
		Art.put(ctx, "mvs_counter", (x0 + x1) / 2.0, y + 14, cw)
		_mist(ctx, "pd:counter", Vector2((x0 + x1) / 2.0, y + 14), cw * 0.92, chh, true)
	else:
		Art.rr(ctx, x0, y - 22, x1 - x0, 34, 4, "#7a2a1e", "#f2c060", 2)
		Art.rr(ctx, x0 - 6, y - 30, x1 - x0 + 12, 10, 3, "#e8d2a0", "#5a3a1a", 1.5)
		for i in 6: Art.rr(ctx, x0 + 10 + i * 30, y - 14, 18, 18, 3, "rgba(255,210,120,.12)", "rgba(242,192,96,.5)", 1)
		_txt(ctx, MD.S("counter", "陰間大排檔", "陰間大排檔"), (x0 + x1) / 2.0, y - 4, 15, GOLD, "center", 900, 3, "serif")
	# 櫃台面疊貨
	# [play] 貨種多、格太窄（< 34px）：每格只疊細堆，唔逐格寫數，改喺櫃台中間寫一個「×總數」（免得數字黐埋爆格）
	var gl = sim.goods_list(); var tight = (x1 - x0 - 52.0) / maxf(1.0, gl.size()) < 34.0; var tot = 0
	for gid in gl:
		var n = sim.counter_n(gid); if n <= 0: continue
		tot += n
		var p = sim.counter_slot(gid)
		var vis = mini(n, 3 if tight else 5)
		for i in vis: _icon(ctx, gid, p.x + (i % 2) * 4.0 - 2.0, p.y - i * 6.0, 22.0 if tight else 26.0)
		if not tight: _txt(ctx, MD.fmt(n), p.x + 16, p.y + 6, 15, Color.WHITE, "center", 900, 4)
	if tight and tot > 0:
		var lb = "×%s" % MD.fmt(tot); ctx.font = "900 15px sans-serif"; var lw = ctx.measureText(lb).width + 16.0
		Art.rr(ctx, (x0 + x1) / 2.0 - lw / 2.0, y - 11, lw, 22, 8, "rgba(20,10,8,.85)", "#f2c060", 1.5)
		_txt(ctx, lb, (x0 + x1) / 2.0, y, 15, Color.WHITE, "center", 900, 0)
	ctx.restore()

# ---------------- 客人 ----------------
func _draw_cust(ctx: Ctx, c: Dictionary) -> void:
	var o = {"t": t + c.ph, "walk": c.get("walk", false), "flip": c.get("flip", true), "alpha": 0.95}
	if not sim.plus.act_draw(self, ctx, c, CS, o):   # [play] 事件動作優先
		if mot == null or not mot.cust(self, ctx, c): Art.draw_char(ctx, str(c.k), c.pos.x, c.pos.y, CS, o)   # [motion] 冇事件：種族專屬動作
	if c.st == "out" and (mot == null or mot.happy(c)):   # [motion] 嬲走唔出 ♪
		_txt(ctx, "♪", c.pos.x + 16, c.pos.y - 72 + sin(t * 6.0) * 3.0, 16, Color("#ffd27a"), "center", 900, 3)

func _draw_want(ctx: Ctx, c: Dictionary) -> void:   # 頭頂氣泡：貨品圖示 × 仲要幾多
	var rows = []
	for g in c.wants:
		var left = int(c.wants[g]) - int(c.got.get(g, 0))
		rows.append([g, left])
	var h = rows.size() * 28.0 + 8.0; var w = 64.0
	var x = clampf(c.pos.x - w / 2.0, vx0() + 4, vx1() - w - 4); var y = c.pos.y - 74.0 - h - (40.0 if int(c.slot) % 2 == 1 else 0.0)
	# [polish4] 同前面客人嘅氣泡（連脾氣牌）、事件名、「生產鏈」掣錯開，盡量唔蓋台名牌：
	#   候選位＝（原位／打橫移 ±24／±48）×（原高度／每個障礙物上面／下面），揀代價最細又唔撞嘅
	var th = 0.0; var tgw = w
	var tg = sim.plus.tag_txt(c)
	if tg != "":
		th = 22.0; ctx.font = "900 14px sans-serif"; tgw = maxf(w, ctx.measureText(tg).width + 12.0)
	var y_nat = y; var x_nat = x
	var obst: Array = _wrects + sim.plus.avoid_rects(self)   # 一定要避
	var soft: Array = []   # 台名牌（盡量避）
	for q in _plates: soft.append(q)
	var y_lo = y_nat + (40.0 if int(c.slot) % 2 == 1 else 0.0)   # 最低去到冇錯開時嘅位（唔好遮個客）
	var y_top = s2w(Vector2(0, top_pad + (EHUD_H if embed else HUD_H) + 4.0)).y   # 唔好鑽入頂部 HUD 下面（[zone] 經 s2w）
	var ys: Array = [y_nat, y_lo]
	for r in obst + soft:
		if r is Rect2: ys.append_array([r.position.y - h - 4.0, r.end.y + 4.0 + th])
	var box = func(bx: float, by: float) -> Rect2:   # 氣泡＋脾氣牌（牌可能闊過氣泡）
		return Rect2(minf(bx, bx + w / 2.0 - tgw / 2.0), by - th, maxf(w, tgw), h + th)
	var picked = false
	for pass_i in 2:   # 第一輪連台名牌都避；冇位就只避一定要避嘅
		var rs: Array = obst + soft if pass_i == 0 else obst
		var best = INF
		for dx in [0.0, -24.0, 24.0, -48.0, 48.0]:
			var cx = clampf(x_nat + dx, vx0() + 4.0, vx1() - w - 4.0)
			for cy in ys:
				if cy > y_lo + 0.5 or cy - th < y_top: continue
				var cost = absf(cy - y_nat) + 1.5 * absf(cx - x_nat)
				if cost >= best: continue
				var bb: Rect2 = box.call(cx, cy).grow(1.0)
				var clash = false
				for r in rs: if r is Rect2 and r.intersects(bb): clash = true; break
				if not clash: best = cost; x = cx; y = cy; picked = true
		if picked: break
	if not picked:
		for _k in 6:
			var hit = false
			for r in obst:
				if r is Rect2 and r.intersects(box.call(x, y).grow(1.0)): y = r.position.y - h - 4.0; hit = true
			if not hit: break
	_wrects.append(box.call(x, y))
	Art.rr(ctx, x, y, w, h, 8, "rgba(250,244,228,.95)", "#5e4a30", 1.5)
	var px = clampf(c.pos.x, x + 10.0, x + w - 10.0)   # 尖角（打橫移咗都喺氣泡底）
	var seg = Rect2(minf(px, c.pos.x) - 1.0, y + h, absf(c.pos.x - px) + 2.0, maxf(0.0, y_nat - y))
	var seg_ok = true
	for r in obst: if r is Rect2 and r.intersects(seg): seg_ok = false; break
	if (y < y_nat - 1.0 or absf(px - c.pos.x) > 1.0) and seg_ok:   # 移咗位：細線連返個客（穿過事件名就唔畫）
		ctx.strokeStyle = "rgba(250,244,228,.8)"; ctx.lineWidth = 2.0
		ctx.beginPath(); ctx.moveTo(px, y + h); ctx.lineTo(c.pos.x, maxf(y_nat, y) + h + 7.0); ctx.stroke()
	Art.poly(ctx, [px - 6, y + h - 1, px + 6, y + h - 1, px, y + h + 7], "rgba(250,244,228,.95)")
	var yy = y + 4.0
	for r in rows:
		_icon(ctx, r[0], x + 17, yy + 24, 24.0)
		if r[1] <= 0: _txt(ctx, "✓", x + 46, yy + 13, 18, GREEN, "center", 900, 0)
		else: _txt(ctx, "×" + MD.fmt(r[1]), x + 46, yy + 13, 16, INK, "center", 900, 0)
		yy += 28.0
	sim.plus.draw_tag(self, ctx, c, x, y, w, h)   # [play] 脾氣牌

# ---------------- 生產台 ----------------
func _st_key(sid: String) -> String:
	var a = str(MD.st_def(sid).get("art", ""))
	if _has(a): return a
	var fb = ST_FALLBACK.get(a, "")
	return fb if _has(fb) else ""
func _st_w() -> float: return 112.0 if embed else 128.0   # [unify] 嵌入：一行左右兩個台

func _draw_station(ctx: Ctx, sid: String, fk: float) -> void:
	var p = sim.st_pos(sid); var w = _st_w()
	var un = sim.unlocked(sid)
	var sel_on = sel == sid
	ctx.save(); ctx.translate(p.x, p.y); ctx.scale(lerpf(0.4, 1.0, fk), maxf(0.02, fk)); ctx.translate(-p.x, -p.y)
	if sel_on: Art.el(ctx, p.x, p.y + 2, w * 0.62, 16, "rgba(243,214,138,.32)")
	Art.el(ctx, p.x, p.y + 2, w * 0.5, 10, "rgba(0,0,0,.35)")
	if not un: ctx.globalAlpha = 0.4
	var an = MD.st_def(sid).get("anim", {}); var on = un and _producing(sid); var ph = p.x * 0.05
	if not (an is Dictionary): an = {}
	ctx.save()
	if un and an.size(): FX.pre(ctx, an, p + Vector2(0, 4), t, on, ph)
	var key = _st_key(sid); var r: Rect2
	var mh = w * 200.0 / 240.0
	if key != "" and un: _mist(ctx, "pd:" + sid, Vector2(p.x, p.y + 4), w * 0.92, mh, false)   # [unify] 血霧後層
	if key != "": r = Art.put(ctx, key, p.x, p.y + 4, w)
	else: r = _proc_station(ctx, sid, p, w)
	if un and an.size(): FX.post(ctx, an, r, t, on, ph)
	if key != "" and un: _mist(ctx, "pd:" + sid, Vector2(p.x, p.y + 4), w * 0.92, mh, true)   # [unify] 血霧前層
	ctx.restore()
	ctx.globalAlpha = 1.0
	_wbtns["st:" + sid] = Rect2(p.x - w / 2, r.position.y, w, p.y + 8 - r.position.y)
	if un:
		# 台面貨（手做剩低／員工做緊）
		var pn = sim.pile_n(sid); var gid = str(MD.st_def(sid).get("good", ""))
		for i in mini(pn, 6): _icon(ctx, gid, p.x - 26 + (i % 3) * 14, p.y - 26 - (i / 3) * 10, 24.0)
		# 進度圈
		var rp = Vector2(p.x + w / 2 - 14, r.position.y + 12)
		var prog = float(sim.mk.get(sid, -1.0)); var manned = sim.nworkers(sid) > 0
		if manned:
			prog = 0.0
			for wk in sim.workers: if wk.sid == sid and wk.st == "work": prog = maxf(prog, wk.prog)
		_ring(ctx, rp, 17.0, prog, manned, pn, sid)
		if (manned or sim.mk_starve.has(sid)) and sim.missing(sid).size() > 0:   # [chain] 斷料牌
			var st_t = _starve_txt(sim.missing(sid))
			ctx.font = "900 14px sans-serif"; var sw = minf(ctx.measureText(st_t).width + 14.0, _cell_w())
			Art.rr(ctx, p.x - sw / 2.0, r.position.y - 30, sw, 24, 7, "rgba(120,20,16,.9)", "#ffb0a0", 1.5)
			_txt(ctx, _fit(ctx, st_t, sw - 10.0, 14)[0], p.x, r.position.y - 18, 14, Color("#fff0e0"), "center", 900, 0)
		# 員工空位
		var ws = sim.sst(sid).workers
		for i in ws.size():
			if ws[i] == null:
				var sp = sim.slot_pos(sid, i)
				if not walking_now(): _plus(ctx, sp, i == 0 and not manned)
				_wbtns["slot:%s:%d" % [sid, i]] = Rect2(sp.x - 20, sp.y - 40, 40, 46)
	ctx.restore()
	# 名牌：名＋等級＋里程碑星
	if fk > 0.5:
		var ny = p.y + 42.0
		var name = MD.T(MD.st_def(sid).get("n"))
		var cw = _cell_w() - 8.0
		if un:
			var ft = _fit(ctx, name, cw - 12.0, 15)
			ctx.font = "900 %dpx sans-serif" % ft[1]; var tw = ctx.measureText(ft[0]).width + 14
			Art.rr(ctx, p.x - tw / 2, ny - 11, tw, 22, 6, "rgba(30,18,12,.82)", "#b89a52", 1)
			var pw2 = maxf(tw, 46.0 + 6.0 * 13.0)   # [polish4] 連第二行 Lv＋星（通常闊過名牌）
			_plates.append(Rect2(p.x - pw2 / 2, ny - 11, pw2, 42))   # [camp] 名牌位（生產鏈掣避開）
			_txt(ctx, ft[0], p.x, ny, ft[1], Color("#f6e6c0"), "center", 900, 0)
			# 第二行：Lv＋里程碑星
			var nm = MD.nm(sid, sim.lv(sid)); var tot = MD.miles(sid).size()
			var lvs = "Lv%d" % int(sim.lv(sid))
			ctx.font = "900 14px sans-serif"; var lw = ctx.measureText(lvs).width
			var rw = lw + 6.0 + tot * 13.0; var x0 = p.x - rw / 2.0
			_txt(ctx, lvs, x0, ny + 20, 14, GOLD, "left", 900, 4)
			for i in tot: _star(ctx, x0 + lw + 12.0 + i * 13.0, ny + 20, 6.0, i < nm)
		else:
			var cost = float(MD.st_def(sid).get("unlock_cost", 0))
			var ureq = IDL.unlock_req(sim, sid)   # [idle] 解鎖鏈：上一個台未到 Lv10 → 顯示條件、唔畀撳
			var ok = sim.coins() >= cost and ureq[0]
			_lock(ctx, Vector2(p.x, p.y - 46))
			_plates.append(Rect2(p.x - cw / 2, ny - 16, cw, 56))   # [camp]
			var ft2 = _fit(ctx, name, cw, 15)
			_txt(ctx, ft2[0], p.x, ny - 4, ft2[1], Color("#f0e2c8"), "center", 900, 4)
			var bw = minf(112.0 if ureq[0] else cw, cw)   # [idle] 解鎖條件字長啲：用成格闊
			Art.rr(ctx, p.x - bw / 2, ny + 8, bw, 28, 8, "#bb3427" if ok else "#4a3a30", "#f2a080" if ok else "#7a6050", 1.5)
			if ureq[0]: _coin_ic(ctx, p.x - bw / 2 + 16, ny + 22, 8.0)   # [idle]
			if not ureq[0]:   # [idle]
				var rq = _fit(ctx, MD.S("unl_req", "要%s Lv%d", "需%s Lv%d") % [MD.T(MD.st_def(ureq[1]).get("n")), ureq[2]], bw - 8.0, 14)
				_txt(ctx, rq[0], p.x, ny + 22, rq[1], Color("#d8c8b0"), "center", 900, 0)
			else: _txt(ctx, MD.S("unlock_btn", "解鎖 %s", "解鎖 %s") % MD.fmt(cost), p.x + 8, ny + 22, 15, Color("#fff3e0") if ok else Color("#b8a898"), "center", 900, 0)
			_wbtns["unl:" + sid] = Rect2(p.x - bw / 2, ny + 4, bw, 36)

# [unify] 血霧：用 Ctx 而家嘅變換（鏡頭、摺埋動畫）畫
func _mist(ctx: Ctx, key: String, base: Vector2, w: float, h: float, front: bool) -> void:
	if not ResourceLoader.exists("res://game/outpost/mv_mist.gd"): return
	ctx.ci.draw_set_transform_matrix(ctx.T)
	MIST.draw(ctx.ci, key, base, w, h, Time.get_ticks_msec() / 1000.0, front)
	ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
func _cell_w() -> float: return 150.0 if embed else 176.0   # 名牌最闊（大地圖台與台之間有位）
# 收窄字：先 15→14px，再唔夠就截尾加「…」
func _fit(ctx: Ctx, s: String, maxw: float, sz: int) -> Array:
	for z in [sz, 14]:
		ctx.font = "900 %dpx sans-serif" % z
		if ctx.measureText(s).width <= maxw: return [s, z]
	var t2 = s
	while t2.length() > 2 and ctx.measureText(t2 + "…").width > maxw: t2 = t2.substr(0, t2.length() - 1)
	return [t2 + "…", 14]
func _producing(sid: String) -> bool:   # 有人做緊／手做緊 → 播生產動態
	if float(sim.mk.get(sid, -1.0)) >= 0.0: return true
	for w in sim.workers:
		if w.sid == sid and w.st == "work" and not w.get("walk", false) and w.prog > 0.0: return true
	return false
func walking_now() -> bool: return anim != null and not anim.done

func _proc_station(ctx: Ctx, sid: String, p: Vector2, w: float) -> Rect2:   # 冇圖：紙紮攤檔
	var h = w * 0.78
	var x = p.x - w / 2; var y = p.y - h
	Art.rr(ctx, x + 6, y + h * 0.42, w - 12, h * 0.58, 4, "#8a4a2a", "#3a1a08", 2)
	Art.poly(ctx, [x, y + h * 0.44, x + 10, y + 8, x + w - 10, y + 8, x + w, y + h * 0.44], "#c0392b", "#5a1a10", 2)
	for i in 5: Art.rr(ctx, x + 8 + i * (w - 16) / 5.0, y + h * 0.36, (w - 16) / 10.0, 8, 2, "#f2e2c0")
	Art.rr(ctx, x + 2, y + h * 0.5, w - 4, 8, 2, "#e8d2a0", "#5a3a1a", 1)
	return Rect2(x, y, w, h)

func _ring(ctx: Ctx, c: Vector2, r: float, prog: float, manned: bool, pile: int, sid: String) -> void:
	Art.el(ctx, c.x, c.y, r + 3, r + 3, "rgba(20,14,24,.82)", "#f3d68a" if not manned else "#9fe39a", 2)
	if prog > 0.0:
		ctx.strokeStyle = "#9fe39a" if manned else "#f3d68a"; ctx.lineWidth = 5
		ctx.beginPath(); ctx.arc(c.x, c.y, r - 2, -PI / 2, -PI / 2 + TAU * clampf(prog, 0, 1)); ctx.stroke()
	if not manned:
		var tx = MD.S("collect", "收", "收") if pile > 0 else (MD.S("make", "做", "做") if prog < 0.0 else "")
		if tx != "": _txt(ctx, tx, c.x, c.y + 1, 17, GOLD, "center", 900, 3)
		if pile > 0: _txt(ctx, "×" + MD.fmt(pile), c.x, c.y + r + 12, 14, Color.WHITE, "center", 900, 4)
		_wbtns["ring:" + sid] = Rect2(c.x - r - 10, c.y - r - 10, (r + 10) * 2, (r + 10) * 2)
	else:
		_icon(ctx, str(MD.st_def(sid).get("good", "")), c.x, c.y + 9, 20.0)

func _star(ctx: Ctx, x: float, y: float, r: float, on: bool) -> void:
	var pts = []
	for i in 10:
		var a = -PI / 2 + i * PI / 5.0; var rr = r if i % 2 == 0 else r * 0.45
		pts.append(x + cos(a) * rr); pts.append(y + sin(a) * rr)
	Art.poly(ctx, pts, "#f3c24a" if on else "rgba(40,30,30,.7)", "#5a3a10" if on else "#8a7a6a", 1)

func _lock(ctx: Ctx, p: Vector2) -> void:
	ctx.strokeStyle = "#e8d8b0"; ctx.lineWidth = 4
	ctx.beginPath(); ctx.arc(p.x, p.y - 6, 9, PI, TAU); ctx.stroke()
	Art.rr(ctx, p.x - 14, p.y - 6, 28, 22, 4, "#c09a40", "#3a2410", 2)
	Art.el(ctx, p.x, p.y + 3, 3, 3, "#3a2410")

func _coin_ic(ctx: Ctx, x: float, y: float, r: float) -> void:
	Art.el(ctx, x, y, r, r, "#f2c060", "#7a4a10", 1.5)
	Art.rr(ctx, x - r * 0.35, y - r * 0.35, r * 0.7, r * 0.7, 1, "#7a4a10")

# 貨品圖示（160×160 圖，冇就畫個色塊＋字）
func _icon(ctx: Ctx, gid: String, x: float, y: float, sz: float) -> void:
	var gd = MD.good_def(gid); var key = str(gd.get("icon", ""))
	if gd.is_empty() and M.has_def(gid):   # [chain] 材料（唔喺 GOODS）：用 MATS 圖鍵，冇就用舊資源圖示
		key = M.icon(gid); gd = {"n": M.def(gid).get("n", [gid, gid])}
		if not _has(key) and M.res_key(gid) != "" and ResourceLoader.exists("res://assets/ui/i-%s.svg" % M.res_key(gid)):
			ctx.ci.draw_set_transform_matrix(ctx.T)
			ctx.ci.draw_texture_rect(load("res://assets/ui/i-%s.svg" % M.res_key(gid)), Rect2(x - sz / 2, y - sz, sz, sz), false)
			ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY); return
	if _has(key):
		Art.put(ctx, key, x, y, sz, sz); return
	var gi = maxi(0, MD.D().GOODS.keys().find(gid)) if MD.D().GOODS.has(gid) else absi(hash(gid))
	Art.rr(ctx, x - sz / 2, y - sz, sz, sz, sz * 0.22, ICON_COL[gi % ICON_COL.size()], "#2a1a10", 1.5)
	var nm = MD.T(gd.get("n", ["?", "?"]))
	_txt(ctx, nm.substr(nm.length() - 1, 1) if nm.length() else "?", x, y - sz / 2, maxi(14, int(sz * 0.6)), Color("#fff6e0"), "center", 900, 2)

func _draw_worker(ctx: Ctx, w: Dictionary) -> void:
	if mot != null and not mot.play_busy(w) and mot.worker(self, ctx, w): return   # [motion] 玩法線事件動作（偷食、打瞌睡……）優先
	var o = {"t": t + w.ph, "tamed": true, "shadow": true, "walk": w.get("walk", false), "flip": w.get("flip", false)}
	if w.st == "work" and not w.get("walk", false): o["work"] = true; o["flip"] = int(w.slot) % 2 == 1
	if not sim.plus.act_draw(self, ctx, w, CS * 0.9, o): Art.draw_char(ctx, str(w.k), w.pos.x, w.pos.y, CS * 0.9, o)   # [play] 特別動作
	if w.carry > 0:
		var gid = str(MD.st_def(w.sid).get("good", ""))
		var by = w.pos.y - 66.0 + sin(t * 10.0 + w.ph) * 1.5
		for i in mini(int(w.carry), 3): _icon(ctx, gid, w.pos.x + i * 3.0, by - i * 7.0, 22.0)
		if w.carry > 1: _txt(ctx, "×" + MD.fmt(w.carry), w.pos.x + 22, by - 8, 14, Color.WHITE, "center", 900, 4)
		if w.get("wait", false): _txt(ctx, MD.S("full", "櫃台滿", "櫃台滿"), w.pos.x, by - 34, 14, Color("#ffb0a0"), "center", 900, 4)

func _draw_parts(ctx: Ctx, world: bool) -> void:   # 冥幣飛去頂部係畫面座標；其他喺世界
	for p in parts:
		if (p.k == "coin") == world: continue
		var u = clampf(p.t / p.life, 0, 1)
		match p.k:
			"coin":
				var pos = p.a.lerp(p.b, u * u); pos.y -= sin(u * PI) * p.h
				_coin_ic(ctx, pos.x, pos.y, 7.0)
			"item":
				var pos2 = p.a.lerp(p.b, u); pos2.y -= sin(u * PI) * p.h
				_icon(ctx, p.g, pos2.x, pos2.y + 10, 22.0)
			"slash":
				ctx.globalAlpha = 1.0 - u; ctx.strokeStyle = "#ffffff"; ctx.lineWidth = 4.0 * (1.0 - u) + 1.0
				var d = Vector2(cos(p.a), sin(p.a)) * (14.0 + 16.0 * u)
				ctx.beginPath(); ctx.moveTo(p.p.x - d.x, p.p.y - d.y); ctx.lineTo(p.p.x + d.x, p.p.y + d.y); ctx.stroke()
				ctx.globalAlpha = 1.0
			_:
				ctx.globalAlpha = 1.0 - u; Art.el(ctx, p.p.x, p.p.y, 3, 3, "#%s" % p.c.to_html(false)); ctx.globalAlpha = 1.0

# ---------------- 頂部 HUD ----------------
func _draw_hud(ctx: Ctx) -> void:
	if embed: _draw_hud_embed(ctx); return   # [unify]
	var y0 = top_pad
	ctx.fillStyle = "rgba(10,6,14,.62)"; ctx.fillRect(0, y0, FW, HUD_H)
	_map_label(ctx)
	# 目標條
	var gi = sim.cur_goal(); var G = MD.goals(sim.ci())
	Art.rr(ctx, 8, y0 + 6, FW - 16, 46, 10, "rgba(250,244,228,.95)", "#5e4a30", 2)
	if gi >= 0:
		var g = G[gi]; var pr = sim.goal_prog(gi); var done = pr[0] >= pr[1]
		_goal_icon(ctx, g, Vector2(32, y0 + 29))
		var tx = MD.T(g.get("txt"))
		var right = FW - 16.0 - (100.0 if done else 64.0)
		ctx.font = "900 16px sans-serif"
		var maxw = right - 60.0
		while tx.length() > 4 and ctx.measureText(tx).width > maxw: tx = tx.substr(0, tx.length() - 2) + "…"
		_txt(ctx, tx, 56, y0 + 22, 16, INK, "left", 900, 0)
		# 進度條
		Art.rr(ctx, 56, y0 + 36, right - 60, 8, 4, "rgba(60,40,20,.25)")
		Art.rr(ctx, 56, y0 + 36, (right - 60) * clampf(pr[0] / maxf(1.0, pr[1]), 0, 1), 8, 4, "#5aa05a" if done else "#c0902a")
		if done:
			var bx = FW - 112.0
			var pulse = 1.0 + 0.04 * sin(t * 6.0)
			Art.rr(ctx, bx, y0 + 11, 96 * pulse, 36, 8, "#3d7a3a", "#bff0a0", 2)
			var rw = g.get("reward", {}); var rc = float(rw.get("coins", 0)) if rw is Dictionary else 0.0
			_txt(ctx, MD.S("claim", "領獎", "領獎") + (" +" + MD.fmt(rc) if rc > 0 else ""), bx + 48, y0 + 29, 15, Color("#fff8e0"), "center", 900, 2)
			_btns["claim"] = Rect2(bx - 6, y0 + 4, 110, 50)
		else:
			_txt(ctx, "%s/%s" % [MD.fmt(pr[0]), MD.fmt(pr[1])], FW - 46, y0 + 29, 16, DIMC, "center", 900, 0)
	else:
		_txt(ctx, MD.S("all_done", "呢度做齊喇！", "這裡全部完成！"), 195, y0 + 29, 17, GREEN, "center", 900, 0)
	# 第二行：地圖進度點、收益、加速、冥幣
	var y2 = y0 + 70.0
	var n = G.size(); var dn = sim.goals_claimed_n()
	var dx = minf(14.0, 96.0 / maxf(1.0, n))
	for i in n:
		var cx = 16.0 + i * dx
		var is_boss = str(G[i].get("t")) == "boss"
		Art.el(ctx, cx, y2, 5.5 if not is_boss else 7.0, 5.5 if not is_boss else 7.0, "#f3c24a" if i < dn else "rgba(60,50,50,.9)", "#f0e2c8", 1.2)
	_boost_btn(ctx, "inc", Rect2(118, y2 - 15, 84, 30), MD.S("income", "收益", "收益") + "×2")
	_boost_btn(ctx, "spd", Rect2(208, y2 - 15, 72, 30), MD.S("speed", "加速", "加速"))
	_coin_ic(ctx, 296, y2, 9.0)
	_txt(ctx, MD.fmt(coin_show), 310, y2 + 1, 19, GOLD, "left", 900, 4)
	# 拔營掣
	if anim == null:
		if sim.can_move():
			var pulse2 = 1.0 + 0.05 * sin(t * 5.0)
			var bw = 200.0 * pulse2; var bx2 = 195.0 - bw / 2.0; var by2 = y0 + 116.0
			var gl = ctx.createRadialGradient(195, by2 + 24, 10, 195, by2 + 24, 150); gl.addColorStop(0, "rgba(255,210,120,.35)"); gl.addColorStop(1, "rgba(255,210,120,0)")
			ctx.fillStyle = gl; ctx.fillRect(40, by2 - 30, 310, 110)
			Art.rr(ctx, bx2, by2, bw, 50, 12, "#bb3427", "#ffd27a", 3)
			_txt(ctx, MD.S("move_btn", "拔營！", "拔營！"), 195, by2 + 25, 24, Color("#fff3e0"), "center", 900, 4, "serif")
			_btns["move"] = Rect2(bx2, by2, bw, 50)
		elif gi >= 0 and str(G[gi].get("t")) == "boss" and not sim.boss_ok(sim.ci(), str(G[gi].get("k", ""))):
			_txt(ctx, MD.S("need_boss", "要先打低主線 Boss", "要先打倒主線 Boss") + MD.S("need_boss2", "（去巡陰）", "（去巡陰）"), 195, y0 + 128, 15, Color("#ffb0a0"), "center", 900, 4)
	sim.war.draw_hud(self, ctx)   # [war] 影響力條、義勇軍數、鬼潮、告急、出征掣
	sim.plus.draw_hud(self, ctx)   # [play] 左下小卡（夜潮／大單／招牌／匯率）＋彈出卡

# [unify] 嵌入模式精簡 HUD（主線任務條收埋，併入第一行）：
#   第一行（40）：左半＝主線任務（撳落去＝原本任務條）；右半＝呢張圖目標（做齊變「領獎」）
#   第二行（42）：左＝地圖名＋收益×2／加速（細掣）；右＝影響力條（戰鬥線 draw_hud，移上嚟同一行）
const EHUD_H := 88.0
func _draw_hud_embed(ctx: Ctx) -> void:
	var y0 = top_pad
	ctx.fillStyle = "rgba(10,6,14,.70)"; ctx.fillRect(0, y0, FW, EHUD_H)
	# 主線（左半）
	Art.rr(ctx, 6, y0 + 4, 186, 36, 8, "rgba(250,244,228,.95)", "#5e4a30", 1.5)
	Art.rr(ctx, 10, y0 + 10, 34, 24, 3, "#b8322a")
	_txt(ctx, "主線", 27, y0 + 22, 14, Color("#fbe6d6"), "center", 900, 0, "serif")
	var qt = ""; var qp = ""
	if main != null and is_instance_valid(main):
		var ql = main.get("quest_lbl"); var qpl = main.get("quest_prog")
		if ql != null and is_instance_valid(ql): qt = ql.get_parsed_text() if ql.has_method("get_parsed_text") else str(ql.text)
		if qpl != null and is_instance_valid(qpl): qp = str(qpl.text)
	ctx.font = "900 14px sans-serif"; var pw = ctx.measureText(qp).width
	_txt(ctx, _fit(ctx, qt, 186 - 48 - pw - 10, 14)[0], 48, y0 + 22, 14, INK, "left", 900, 0)
	_txt(ctx, qp, 186, y0 + 22, 14, RED, "right", 900, 0)
	_btns["quest"] = Rect2(6, y0 + 4, 186, 36)
	# 目標（右半）
	var gi = sim.cur_goal(); var G = MD.goals(sim.ci())
	var gx = 198.0; var gw = FW - gx - 6.0
	Art.rr(ctx, gx, y0 + 4, gw, 36, 8, "rgba(250,244,228,.95)", "#5e4a30", 1.5)
	if gi >= 0:
		var g = G[gi]; var pr = sim.goal_prog(gi); var done = pr[0] >= pr[1]
		_goal_icon(ctx, g, Vector2(gx + 16, y0 + 22))
		if done:
			var rw = g.get("reward", {}); var rc = float(rw.get("coins", 0)) if rw is Dictionary else 0.0
			Art.rr(ctx, gx + 34, y0 + 7, gw - 38, 30, 8, "#3d7a3a", "#bff0a0", 2)
			_txt(ctx, MD.S("claim", "領獎", "領獎") + (" +" + MD.fmt(rc) if rc > 0 else ""), gx + 34 + (gw - 38) / 2.0, y0 + 22, 15, Color("#fff8e0"), "center", 900, 2)
			_btns["claim"] = Rect2(gx, y0, gw, 44)
		else:
			var cnt = "%s/%s" % [MD.fmt(pr[0]), MD.fmt(pr[1])]
			ctx.font = "900 14px sans-serif"; var cw2 = ctx.measureText(cnt).width
			var tx = _fit(ctx, MD.T(g.get("txt")), gw - 40 - cw2 - 8, 14)[0]
			_txt(ctx, tx, gx + 32, y0 + 18, 14, INK, "left", 900, 0)
			_txt(ctx, cnt, gx + gw - 6, y0 + 18, 14, DIMC, "right", 900, 0)
			Art.rr(ctx, gx + 32, y0 + 30, gw - 40, 5, 3, "rgba(60,40,20,.25)")
			Art.rr(ctx, gx + 32, y0 + 30, (gw - 40) * clampf(pr[0] / maxf(1.0, pr[1]), 0, 1), 5, 3, "#c0902a")
	else:
		_txt(ctx, MD.S("all_done", "呢度做齊喇！", "這裡全部完成！"), gx + gw / 2.0, y0 + 22, 14, GREEN, "center", 900, 0)
	# 第二行：地圖名＋細掣
	var md = MD.map_def(sim.ci())
	_boost_btn(ctx, "inc", Rect2(6, y0 + 45, 84, 22), MD.S("income", "收益", "收益") + "×2", 14)
	_boost_btn(ctx, "spd", Rect2(96, y0 + 45, 74, 22), MD.S("speed", "加速", "加速"), 14)
	var nb = sim.war != null and sim.war.has_method("newbie") and sim.war.newbie()   # 新手保護字（戰鬥線）會出喺第二行左邊
	if not nb: _txt(ctx, "%s %d/%d" % [MD.T(md.get("name")), sim.ci() + 1, MD.maps_n()], 8, y0 + 79, 14, Color("#e8dcc4"), "left", 900, 3, "serif")
	if anim == null:
		if sim.can_move():
			var pulse2 = 1.0 + 0.05 * sin(t * 5.0)
			var bw = 160.0 * pulse2; var by2 = y0 + EHUD_H + 6.0
			Art.rr(ctx, 8, by2, bw, 44, 12, "#bb3427", "#ffd27a", 3)
			_txt(ctx, MD.S("move_btn", "拔營！", "拔營！"), 8 + bw / 2.0, by2 + 22, 22, Color("#fff3e0"), "center", 900, 4, "serif")
			_btns["move"] = Rect2(8, by2, bw, 44)
		elif gi >= 0 and str(G[gi].get("t")) == "boss" and not sim.boss_ok(sim.ci(), str(G[gi].get("k", ""))):
			_txt(ctx, MD.S("need_boss", "要先打低主線 Boss", "要先打倒主線 Boss"), 8, y0 + EHUD_H + 14, 14, Color("#ffb0a0"), "left", 900, 4)
		elif zone and (gi < 0 or str(G[gi].get("t")) == "boss") and not ZDs.all_bosses_done(sim.ci()):   # [zone] 野外區啲王未打晒
			var bc = ZDs.boss_count(sim.ci())
			_txt(ctx, MD.S("need_zboss", "打低野外區全部王先拔得營", "擊敗野外區全部王才能拔營") + "（%d/%d）" % [bc[0], bc[1]], 8, y0 + EHUD_H + 14, 14, Color("#ffb0a0"), "left", 900, 4)
	# 影響力（戰鬥線）：佢排喺 top_pad + 90 下面 → 臨時上移，同第二行齊
	var tp = top_pad; top_pad = tp - (90.0 - 44.0)
	sim.war.draw_hud(self, ctx)
	top_pad = tp
	_draw_plus_embed(ctx)
# [polish4] 合一地圖：玩法線小卡（夜潮／大單／招牌／匯率／事件）＋彈出卡。
#   大排檔區好密（櫃台、台、客人），成疊小卡點擺都遮嘢 → 收埋做一粒「玩法掣」：
#   擺喺精簡 HUD 下面左邊（有「拔營！」就排佢右邊），顯示最急嗰樣（可交大單／匯率事件會跳）；
#   撳一下向下展開成疊小卡（8 秒冇撳自動收），撳小卡開卡同全屏版一樣。
#   只喺鏡頭睇住大排檔區（HUD 出咗）先畫；掣位抄入 _btns（plus:*）→ mv_embed.on_tap 轉俾 tap()
const PILL_OPEN_S := 8.0
var _pexp := 0.0   # 展開剩低秒數
var _pill_rect = null   # 上一格玩法掣位（畫面座標；「生產鏈」掣避開）
var _pill_side := 0   # 0 左 1 右（有黏性）
func _pill_xy(pw := 150.0) -> Vector2:   # 左（有「拔營！」就排佢右邊）或者右：揀遮台名牌／台／「生產鏈」掣最少嗰邊
	var y = top_pad + EHUD_H + 6.0
	var xs = [184.0 if (anim == null and sim.can_move()) else 8.0, FW - pw - 8.0]   # 「拔營！」掣最闊 168（跳動）
	var cost = []
	for x in xs:
		var r = Rect2(s2w(Vector2(x, y)), Vector2(pw, 34.0)).grow(4.0)
		var a = 0.0
		for q in _plates: a += r.intersection(q).get_area() * 3.0
		for k in _wbtns: if k.begins_with("st:") or k.begins_with("ring:") or k.begins_with("unl:"): a += r.intersection(_wbtns[k]).get_area()
		if _cb_pos is Vector2: a += r.intersection(Rect2(s2w(_cb_pos), _cb_sz)).get_area() * 10.0
		cost.append(a)
	if cost[1 - _pill_side] < cost[_pill_side] * 0.5 - 50.0: _pill_side = 1 - _pill_side
	return Vector2(xs[_pill_side], y)
func _pill_info() -> Array:   # [字, 色, 要唔要跳]
	var P = sim.plus; var EVs = load("res://game/outpost/mv_event.gd")
	var e = P.live.get("ev")
	if e is Dictionary and not J.t(e.get("done")) and str(e.k) in ["rate_up", "rate_down"]:
		return [EVs.ev_name(P, sim, e), "#9fe39a" if str(e.k) == "rate_up" else "#ff8a7a", true]
	var od = P.ps(sim).orders
	for o in od:
		if EVs.can_finish(P, sim, o): return [MD.S("chip_ord", "大單 %s %s", "大單 %s %s") % [EVs.prog_txt(P, sim, o), _mmss(J.num(o.left))], "#ffd27a", true]
	if od.size() > 0: return [MD.S("chip_ord", "大單 %s %s", "大單 %s %s") % [EVs.prog_txt(P, sim, od[0]), _mmss(J.num(od[0].left))], "#f2a080", false]
	if P.live.rate is Dictionary: return [MD.S("chip_rate", "匯率 ×%.2f %s", "匯率 ×%.2f %s") % [float(P.live.rate.mul), _mmss(float(P.live.rate.left))], "#9fe39a" if float(P.live.rate.mul) >= 1.0 else "#ff8a7a", false]
	if not P.sign_def(sim.ci()).is_empty() and P._sign_seen(sim): return [MD.S("pill_sign", "招牌菜", "招牌菜"), "#9fe39a" if P.sign_ok(sim) else "#c8b898", P.sign_ok(sim)]
	var tn = P.tide(sim)
	return [MD.S("pill_tide_n", "夜潮 %s", "夜潮 %s") % _mmss(float(tn[1])) if tn[0] else MD.S("pill_day", "白晝 %s", "白晝 %s") % _mmss(float(tn[1])), "#d8b0ff" if tn[0] else "#e8dcc4", false]
func _draw_plus_embed(ctx: Ctx) -> void:
	if hud_k < 0.5 and sim.plus.card == null: return
	var P = sim.plus
	if P.card != null:   # 卡開住：淨係畫卡（成個畫面嘅撳都交俾卡；撳卡外＝關）
		P._btn.clear(); P._sc = self; P._draw_card(self, ctx)
		for k in P._btn: _btns["plus:" + str(k)] = P._btn[k]
		_btns["plus:card_bg"] = Rect2(0, 0, FW, H)
		return
	if sheet != null and sheet.visible or picker != null: return
	var info = _pill_info()
	var open = _pexp > 0.0
	var tx = ("▴ " if open else "▾ ") + str(info[0])
	ctx.font = "900 15px sans-serif"
	var pw = clampf(ctx.measureText(tx).width + 22.0, 96.0, FW - 192.0)
	var pp = _pill_xy(pw)
	var sz = 1.0 + (0.04 * sin(t * 6.0) if info[2] and not open else 0.0)
	Art.rr(ctx, pp.x, pp.y, pw * sz, 34.0, 10, "rgba(14,8,18,.88)", str(info[1]), 2.0)
	_txt(ctx, _fit(ctx, tx, pw - 16.0, 15)[0], pp.x + 10.0, pp.y + 17.0, 15, Color(str(info[1])), "left", 900, 0)
	_btns["plus_pill"] = Rect2(pp.x, pp.y, pw, 34.0).grow(3); _pill_rect = _btns["plus_pill"]
	if open:
		P.chip_x = minf(pp.x, FW - 168.0 - 8.0); P.chip_down = true
		P.draw_hud(self, ctx, pp.y + 40.0)
		P.chip_x = 8.0; P.chip_down = false
		for k in P._btn: _btns["plus:" + str(k)] = P._btn[k]
	else:
		P._btn.clear()
		load("res://game/outpost/mv_event.gd").draw_hud(P, self, ctx, -1000.0)   # 收埋都要畫紙錢雨（匯率小卡畫喺畫面外）
		P._btn.erase("ev")
func _boost_btn(ctx: Ctx, kind: String, r: Rect2, label: String, fs := 15) -> void:
	var on = sim.boost_left(kind) > 0.0; var cd = sim.boost_cd(kind)
	var col = "#3d7a3a" if on else ("#4a3a30" if cd > 0.0 else "#bb3427")
	Art.rr(ctx, r.position.x, r.position.y, r.size.x, r.size.y, 8, col, "#f2d090" if not (cd > 0.0 and not on) else "#7a6050", 1.5)
	var tx = label
	if on: tx = label.substr(0, 2) + " " + _mmss(sim.boost_left(kind))
	elif cd > 0.0: tx = _mmss(cd)
	_txt(ctx, tx, r.position.x + r.size.x / 2.0, r.position.y + r.size.y / 2.0 + 1, fs, Color("#fff3e0") if (on or cd <= 0.0) else Color("#c8b8a8"), "center", 900, 2)
	_btns["boost:" + kind] = r.grow(4)
func _mmss(s: float) -> String: return "%d:%02d" % [int(s) / 60, int(s) % 60]

func _goal_icon(ctx: Ctx, g: Dictionary, c: Vector2) -> void:
	Art.el(ctx, c.x, c.y, 19, 19, "#3a2a20", "#c0902a", 2)
	var k2 = str(g.get("k", ""))
	match str(g.get("t")):
		"sell": _icon(ctx, k2, c.x, c.y + 13, 26.0)
		"unlock", "level":
			var key = _st_key(k2)
			if key != "": Art.put(ctx, key, c.x, c.y + 14, 32.0)
			else: _icon(ctx, str(MD.st_def(k2).get("good", "")), c.x, c.y + 13, 26.0)
		"hire": Art.draw_char(ctx, "youhun", c.x, c.y + 16, 0.36, {"t": t})
		"boss":
			_txt(ctx, "王", c.x, c.y + 1, 20, Color("#ff8a7a"), "center", 900, 2, "serif")

# ---------------- 對白框／橫額／離線卡 ----------------
var _brects: Array = []
func _wrap(ctx: Ctx, s: String, maxw: float) -> Array:
	var out = []; var cur = ""
	for ch in s:
		if ctx.measureText(cur + ch).width > maxw and cur != "" and not "，。、！？：；）」』…—,.!?".contains(ch): out.append(cur); cur = ch   # [story] 標點唔放行頭（掛喺上一行尾）
		else: cur += ch
	if cur != "": out.append(cur)
	return out
func _draw_bubble(ctx: Ctx, b: Dictionary) -> void:
	ctx.font = "700 15px sans-serif"
	var lines = _wrap(ctx, b.text, 200.0)
	var w = 0.0
	for l in lines: w = maxf(w, ctx.measureText(l).width)
	w += 20.0; var h = lines.size() * 20.0 + 12.0 + (18.0 if b.who != "" else 0.0)
	var wtop = s2w(Vector2(0, top_pad + HUD_H + 4.0)).y; var wbot = s2w(Vector2(0, top_pad + view_h())).y - h - 10.0   # [zone] 經 s2w
	if sim.war != null: wtop = maxf(wtop, s2w(Vector2(0, float(sim.war.hud_y(self)) + 46.0)).y)   # [camp] 對白框唔好俾影響力條遮住
	if zone and float(zt.z) < 0.7: return   # [zone] 縮到好細：對白框唔出（字會細過 14px）
	if embed:   # [unify] 嵌入：講嘢嘅人唔喺鏡頭（或者喺原村子）就唔出框；框唔好落到出村門下面
		if b.p.y > world_h() or b.p.y < s2w(Vector2.ZERO).y or b.p.y > s2w(Vector2(0, H)).y: return
		if zone and (b.p.x < view_x0() or b.p.x > view_x1()): return
		wbot = minf(wbot, world_h() - h - 4.0)
		if not hud_on: wtop = s2w(Vector2(0, 8.0)).y
	var X0 = view_x0() + 6.0; var X1 = view_x1() - w - 6.0   # [zone] 對白框夾喺畫面內
	var x = clampf(b.p.x, X0, X1); var y = clampf(b.p.y - h, wtop, maxf(wtop, wbot))
	# [polish4] 要避開：台名牌／事件名／其他對白框（_brects）＋客人要貨氣泡（_wrects）。
	#   候選位＝原位、每個障礙物上面／下面；揀離原位最近又乜都唔撞嘅；全部都撞就照舊逐個推落去
	var obs: Array = _brects + _wrects
	var cands: Array = [y]
	for r in obs: cands.append_array([r.position.y - h - 6.0, r.end.y + 6.0])
	var y0 = y; var x0 = x
	var found = false; var best = INF
	for cx in [x0, X0, X1]:   # 打橫都試：靠左／靠右
		for cy in cands:
			if cy < wtop - 0.5 or cy > maxf(wtop, wbot) + 0.5: continue
			var cost = absf(cy - y0) + 0.5 * absf(cx - x0)
			if cost >= best: continue
			var clash = false
			for r in obs: if r.intersects(Rect2(cx, cy, w, h).grow(3)): clash = true; break
			if not clash: best = cost; x = cx; y = cy; found = true
	if not found:   # 冇完全唔撞嘅位：揀遮得最少嘅（遮要貨氣泡算重啲）
		var least = INF
		for cx in [x0, X0, X1]:
			for cy in cands:
				if cy < wtop - 0.5 or cy > maxf(wtop, wbot) + 0.5: continue
				var br = Rect2(cx, cy, w, h).grow(3)
				var ov = 0.0
				for r in _brects: ov += br.intersection(r).get_area()
				for r in _wrects: ov += br.intersection(r).get_area() * 2.0
				for r in _drects: ov += br.intersection(r).get_area() * 4.0   # 對白框疊對白框最差（睇唔到字）
				ov += absf(cy - y0) * 2.0
				if ov < least: least = ov; x = cx; y = cy
	_brects.append(Rect2(x, y, w, h)); _drects.append(Rect2(x, y, w, h))
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
	var sc = 1.0 + 0.35 * maxf(0.0, 1.0 - b.t / 0.25)
	var cy = top_pad + 300.0
	ctx.save(); ctx.globalAlpha = a
	ctx.fillStyle = "rgba(10,6,14,.72)"; ctx.fillRect(0, cy - 75, FW, 150)
	var g = ctx.createRadialGradient(195, cy, 10, 195, cy, 200); g.addColorStop(0, "rgba(255,210,120,.35)"); g.addColorStop(1, "rgba(255,210,120,0)")
	ctx.fillStyle = g; ctx.fillRect(0, cy - 75, FW, 150)
	ctx.strokeStyle = "rgba(255,220,140,.25)"; ctx.lineWidth = 3
	for i in 12:
		var an = i * TAU / 12.0 + u * 1.5
		ctx.beginPath(); ctx.moveTo(195 + cos(an) * 40, cy + sin(an) * 22); ctx.lineTo(195 + cos(an) * 190, cy + sin(an) * 70); ctx.stroke()
	ctx.translate(195, cy); ctx.scale(sc, sc); ctx.translate(-195, -cy)
	_txt(ctx, b.a, 195, cy - 30, 20, Color("#f0e2c8"), "center", 900, 5)
	_txt(ctx, b.b, 195, cy + 20, 40 if b.b.length() <= 8 else 26, GOLD, "center", 900, 7, "serif")
	ctx.restore()

func _show_card(r: Dictionary) -> void:
	close_sheet(); _close_picker()
	card = r.duplicate(); card["t"] = 0.0
	_snd("chest")
func _draw_card(ctx: Ctx) -> void:
	card.t = float(card.t) + get_process_delta_time()
	ctx.fillStyle = "rgba(0,0,0,.6)"; ctx.fillRect(0, 0, FW, H)
	var rows = card.get("rows", [])
	var h = 220.0 + mini(rows.size(), 5) * 26.0
	var y = (H - h) / 2.0; var x = 30.0; var w = FW - 60.0
	var sc = minf(1.0, 0.8 + float(card.t) * 1.5)
	ctx.save(); ctx.translate(195, y + h / 2); ctx.scale(sc, sc); ctx.translate(-195, -(y + h / 2))
	Art.rr(ctx, x, y, w, h, 14, "rgba(250,244,228,.98)", "#b89a52", 3)
	_txt(ctx, MD.S("offline_t", "你唔喺度嘅時候", "你不在的時候"), 195, y + 30, 20, INK, "center", 900, 0, "serif")
	var hrs = float(card.secs) / 3600.0
	var dur = (MD.S("hm", "%d 小時 %d 分", "%d 小時 %d 分") % [int(hrs), int(fmod(float(card.secs) / 60.0, 60.0))])
	if card.get("capped", false): dur += MD.S("cap", "（上限 8 小時）", "（上限 8 小時）")
	_txt(ctx, MD.S("offline_b", "員工照開工：%s", "員工照常開工：%s") % dur, 195, y + 58, 15, DIMC, "center", 700, 0)
	_coin_ic(ctx, 120, y + 100, 14.0)
	_txt(ctx, "+" + MD.fmt(card.coins), 140, y + 101, 34, Color("#b8322a"), "left", 900, 0, "serif")
	var yy = y + 140.0
	for i in mini(rows.size(), 5):
		var rr = rows[i]
		_txt(ctx, MD.T(MD.st_def(str(rr[0])).get("n")), x + 24, yy, 15, INK, "left", 700, 0)
		_txt(ctx, "+" + MD.fmt(rr[1]), x + w - 24, yy, 15, INK, "right", 900, 0)
		yy += 26.0
	Art.rr(ctx, 195 - 80, y + h - 56, 160, 40, 10, "#bb3427", "#f2a080", 2)
	_txt(ctx, MD.S("take", "收下", "收下"), 195, y + h - 36, 18, Color("#fff3e0"), "center", 900, 0)
	ctx.restore()

# ---------------- 拔營畫面 ----------------
func _draw_anim(ctx: Ctx) -> void:
	var a = anim; var tt = float(a.t)
	if not a.done and tt >= A_FOLD - 0.2 and tt < A_SWAP:
		ctx.font = "900 17px sans-serif"
		var ls = _wrap(ctx, str(a.line), 350.0)
		for li in ls.size(): _txt(ctx, ls[li], 195, top_pad + HUD_H + 46 + li * 24.0, 17, GOLD, "center", 900, 5)
	# 轉黑／淡入
	var dark = 0.0
	if tt >= A_WALK - 0.2 and tt < A_SWAP: dark = clampf((tt - (A_WALK - 0.2)) / (A_SWAP - A_WALK + 0.2), 0, 1)
	elif tt >= A_SWAP: dark = clampf(1.0 - (tt - A_SWAP) / (A_END - A_SWAP), 0, 1)
	if dark > 0.0:
		ctx.fillStyle = "rgba(6,4,10,%s)" % str(dark); ctx.fillRect(0, 0, FW, H)
		if tt >= A_SWAP:
			ctx.globalAlpha = dark
			_txt(ctx, MD.S("next_map", "下一站", "下一站"), 195, H / 2 - 30, 18, Color("#f0e2c8"), "center", 900, 4)
			_txt(ctx, MD.T(MD.map_def(sim.ci()).get("name")), 195, H / 2 + 14, 34, GOLD, "center", 900, 6, "serif")
			ctx.globalAlpha = 1.0

# 文字：描邊＋填色（夾返入畫面，唔爆格）
# 拔營隊伍（世界座標）：抬住摺埋嘅紙紮屋沿路行出入口
func _draw_proc(ctx: Ctx) -> void:
	var tt = float(anim.t)
	var u = clampf((tt - A_FOLD + 0.2) / (A_WALK - A_FOLD + 0.2), 0, 1)
	var ql = sim.QLEN + 120.0
	var s0 = lerpf(-60.0, ql, u * u * 0.4 + u * 0.6)
	var bp = MD.poly_at(sim.QP, s0)
	var bob = sin(tt * 12.0) * 3.0
	var crew = []
	for w in sim.workers: crew.append(str(w.k))
	for g in sim.guards: crew.append(str(g.k))
	while crew.size() < 4: crew.append(["zhiren", "youhun", "zombie", "egui"][crew.size()])
	for i in 4:
		var q = MD.poly_at(sim.QP, s0 - 30.0 + i * 20.0) + Vector2((i % 2) * 24.0 - 12.0, 0)
		Art.draw_char(ctx, crew[i], q.x, q.y, CS * 0.85, {"t": tt + i, "walk": true, "tamed": true})
	ctx.save(); ctx.translate(bp.x, bp.y - 70 + bob); ctx.rotate(sin(tt * 3.0) * 0.04)
	if _has("mvs_house_fold"): Art.put(ctx, "mvs_house_fold", 0, 30, 170)
	else:
		Art.rr(ctx, -80, -18, 160, 32, 6, "#e8d2a0", "#5a3a1a", 2)
		for i in 7: Art.rr(ctx, -72 + i * 21, -14, 12, 24, 2, "#c0392b" if i % 2 == 0 else "#f2c060")
	ctx.restore()
	for i in range(4, crew.size()):
		var q2 = MD.poly_at(sim.QP, s0 - 60.0 - (i - 3) * 34.0)
		Art.draw_char(ctx, crew[i], q2.x, q2.y, CS * 0.8, {"t": tt + i, "walk": true, "tamed": true})

func _txt(ctx: Ctx, s: String, x: float, y: float, sz: int, col: Color, align := "center", w := 900, outline := 4, fam := "sans-serif") -> void:
	ctx.font = "%d %dpx %s" % [w, sz, fam]; ctx.textAlign = align; ctx.textBaseline = "middle"
	var tw = ctx.measureText(s).width
	match align:
		"center": x = clampf(x, _tx0 + tw / 2.0 + 4.0, _tx1 - tw / 2.0 - 4.0)   # [zone] _tx0／_tx1：畫世界時係可見範圍
		"left": x = clampf(x, _tx0 + 4.0, _tx1 - tw - 4.0)
		"right": x = clampf(x, _tx0 + tw + 4.0, _tx1 - 4.0)
	if outline > 0:
		ctx.lineWidth = outline; ctx.strokeStyle = "rgba(10,6,4,.92)"; ctx.lineJoin = "round"; ctx.strokeText(s, x, y)
	ctx.fillStyle = "#" + col.to_html(true); ctx.fillText(s, x, y)

# ================= 撳 =================
func _stage_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed:
			_press = {"p": ev.position, "cam": cam, "t": t, "drag": false, "last": ev.position.y, "lt": t}
			cam_v = 0.0; cam_tgt = null
		elif _press != null:
			if not _press.drag: tap(ev.position)
			_press = null
	elif ev is InputEventMouseMotion and _press != null:
		var dy = ev.position.y - _press.p.y
		if not _press.drag and absf(dy) > 9.0 and card == null and anim == null and _press.p.y > top_pad + HUD_H: _press.drag = true
		if _press.drag:
			cam = _press.cam - dy
			var dtm = maxf(0.001, t - _press.lt)
			cam_v = lerpf(cam_v, -(ev.position.y - _press.last) / dtm, 0.5)
			_press.last = ev.position.y; _press.lt = t
			_clamp_cam()
	elif ev is InputEventScreenDrag:
		pass

func _hit(name: String, p: Vector2) -> bool: return _btns.has(name) and _btns[name].has_point(p)
func tap(p: Vector2) -> void:
	if card != null:
		if float(card.t) > 0.3: card = null; _snd("coin")
		return
	if anim != null: return
	if embed and sim.plus.card == null and _hit("plus_pill", p):   # [polish4] 合一地圖玩法掣：展開／收埋
		_pexp = 0.0 if _pexp > 0.0 else PILL_OPEN_S; _snd("click"); return
	if embed and _pexp > 0.0: _pexp = PILL_OPEN_S   # 撳緊小卡：唔好收
	if sim.plus.card != null: sim.plus.tap(self, p); return   # [polish4] 大單／招牌卡開住：撳嘢全部交俾卡（唔好穿過去撳到領獎／主線）
	if _hit("claim", p):
		if sim.claim(sim.cur_goal()): _save()
		return
	if _hit("move", p): move_next(); return
	if embed and _hit("quest", p):   # [unify] 精簡 HUD 嘅主線 → 原本任務條
		var qb = main.get("quest_bar") if main != null else null
		if qb != null:
			var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true
			qb.gui_input.emit(ev)
		return
	for kind in ["inc", "spd"]:
		if _hit("boost:" + kind, p):
			if not sim.use_boost(kind): _float(s2w(p + Vector2(0, 30)), MD.S("cd", "冷卻緊", "冷卻中"), Color("#ffb0a0"), 15)
			return
	if sim.plus.tap(self, p): return   # [play]
	if sim.war.tap(self, p): return   # [war] 出征掣／頭目
	if p.y < top_pad + (EHUD_H if embed else HUD_H) and (not embed or hud_on): return
	var sp = p; p = s2w(p)   # 以下世界座標
	if sim.tap_foe(p): return
	if mot != null and mot.tap(self, p): return   # [motion] 撳醒瞓緊嘅領班
	for key in _wbtns.keys():
		if not _wbtns[key].has_point(p): continue
		var a = key.split(":")
		match a[0]:
			"ring":
				var r = sim.tap_station(a[1])
				if r == "full": _float(p + Vector2(0, -30), MD.S("full", "櫃台滿", "櫃台滿"), Color("#ffb0a0"), 15)
				elif r == "make": _snd("click")
				return
			"unl":
				if sim.unlock(a[1]): _save()
				elif not IDL.unlock_req(sim, a[1])[0]:   # [idle]
					var rq2 = IDL.unlock_req(sim, a[1])
					_float(p + Vector2(0, -30), MD.S("unl_need", "要 %s 升到 Lv%d 先解鎖到", "要 %s 升到 Lv%d 才能解鎖") % [MD.T(MD.st_def(rq2[1]).get("n")), rq2[2]], Color("#ffb0a0"), 15); _snd("click")
				else: _float(p + Vector2(0, -30), MD.S("no_coin", "冥幣唔夠", "冥幣不夠"), Color("#ffb0a0"), 16); _snd("click")
				return
			"campa", "campc": camp.tap(a[0], a[1]); _snd("click"); return   # [camp]
			"slot": _open_picker(a[1], int(a[2])); return
			"guard": _open_picker("guard", int(a[1])); return
	for key in _wbtns.keys():
		if key.begins_with("st:") and _wbtns[key].has_point(p):
			var sid = key.substr(3)
			if sim.unlocked(sid): open_sheet(sid)
			return
	if sheet.visible: close_sheet()

# ================= 升級條 =================
var _up_btns := []
func open_sheet(sid: String) -> void:
	sel = sid; sheet.visible = true; _snd("click"); _fill_sheet()
	focus(sim.st_pos(sid).y, top_pad + HUD_H + 150.0, sim.st_pos(sid).x)   # 個台移去升級條上面
func focus_station(sid: String) -> void: focus(sim.st_pos(sid).y, top_pad + view_h() * 0.55, sim.st_pos(sid).x)
func close_sheet() -> void:
	sel = ""
	if sheet != null: sheet.visible = false
func _place_sheet() -> void:
	sheet.size = Vector2(FW, 0); sheet.reset_size(); sheet.size.x = FW
	sheet.position = Vector2(0, H - bot_pad - sheet.size.y)

func _lbl(t0: String, sz := 16, col := INK, kind := "sans", w := 700) -> Label:
	var l = UIKit.label(t0, sz, col, kind, w); l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _fill_sheet() -> void:
	for c in sheet_box.get_children(): sheet_box.remove_child(c); c.queue_free()
	_up_btns.clear()
	var sid = sel; var sd = MD.st_def(sid); var l = sim.lv(sid); var c = sim.ci(); var mx = MD.max_lv(sid)
	var h = HBoxContainer.new(); h.add_theme_constant_override("separation", 8); sheet_box.add_child(h)
	h.add_child(_lbl(MD.T(sd.get("n")), 22, INK, "serif", 900))
	h.add_child(_lbl("Lv %d" % int(l), 20, RED, "sans", 900))
	h.add_child(_lbl("★".repeat(MD.stars(sid, l)) + "☆".repeat(MD.miles(sid).size() - MD.stars(sid, l)), 16, Color("#b8860b"), "sans", 900))   # [idle] 品質星
	var sp = Control.new(); sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sp.mouse_filter = Control.MOUSE_FILTER_IGNORE; h.add_child(sp)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(42, 40); cb.focus_mode = Control.FOCUS_NONE; cb.pressed.connect(close_sheet); h.add_child(cb)
	var how = _lbl(MD.T(sd.get("how", "")), 14, DIMC, "sans", 700); how.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; how.custom_minimum_size = Vector2(350, 0); sheet_box.add_child(how)
	_recipe_row(sid)   # [chain] 用乜做 → 出乜
	# 數值：而家 → 下一級
	var nx = minf(mx, l + 1.0)
	var grid = GridContainer.new(); grid.columns = 2; grid.add_theme_constant_override("h_separation", 14); grid.add_theme_constant_override("v_separation", 2); sheet_box.add_child(grid)
	var arrow = func(a: String, b: String) -> String: return a if l >= mx or a == b else "%s → %s" % [a, b]
	grid.add_child(_lbl(MD.S("s_out", "每次產量", "每次產量"), 15, DIMC)); grid.add_child(_lbl(arrow.call(MD.fmt(MD.out(sid, l)), MD.fmt(MD.out(sid, nx))), 16, INK, "sans", 900))
	grid.add_child(_lbl(MD.S("s_tm", "做貨時間", "製作時間"), 15, DIMC)); grid.add_child(_lbl(arrow.call("%.1f秒" % MD.tm(sid, l), "%.1f秒" % MD.tm(sid, nx)), 16, INK, "sans", 900))
	grid.add_child(_lbl(MD.S("s_val", "每件賣", "每件售價"), 15, DIMC)); grid.add_child(_lbl(arrow.call(_v(MD.val(sid, l, c)), _v(MD.val(sid, nx, c))), 16, INK, "sans", 900))
	grid.add_child(_lbl(MD.S("s_w", "員工", "員工"), 15, DIMC)); grid.add_child(_lbl("%d／%d" % [sim.nworkers(sid), MD.slots(sid)], 16, INK, "sans", 900))
	_idle_rows(sid)   # [idle] 里程碑效果／累計產量／品質星／領班／解鎖下一台
	sim.plus.sheet_rows(self, sid)   # [play] 夥計羈絆
	# 員工位
	var sr = HBoxContainer.new(); sr.add_theme_constant_override("separation", 6); sheet_box.add_child(sr)
	var ws = sim.sst(sid).workers
	for i in ws.size(): sr.add_child(_slot_btn(sid, i, ws[i]))
	# 升級掣：升 1／升 10／升到下個里程碑
	var br = HBoxContainer.new(); br.add_theme_constant_override("separation", 6); sheet_box.add_child(br)
	if l >= mx:
		var b0 = UIKit.btn(MD.S("maxed", "已經最高級", "已經最高級"), "", false); b0.disabled = true; b0.custom_minimum_size = Vector2(0, 54); b0.size_flags_horizontal = Control.SIZE_EXPAND_FILL; br.add_child(b0)
	else:
		for mode in ["1", "10", "mile"]:
			var b = UIKit.btn("", "gold", false); b.custom_minimum_size = Vector2(0, 58); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.add_theme_font_size_override("font_size", 15); b.focus_mode = Control.FOCUS_NONE
			var mm = mode
			b.pressed.connect(func(): _do_up(sid, mm))
			br.add_child(b); _up_btns.append([b, mode])
		_refresh_sheet_btns()
	await get_tree().process_frame
	if not is_instance_valid(sheet): return
	_place_sheet()

# [chain] 資料卡：用乜做（材料圖示＋每轉數量＋而家庫存）→ 出乜；分流掣（自動／全部入倉／全部出售）
var _recipe_rows: Array = []
func _recipe_row(sid: String) -> void:
	_recipe_rows.clear()
	var nd = sim.need(sid); var out_mid = M.rout(sid); var gid = str(MD.st_def(sid).get("good", ""))
	var box = PanelContainer.new(); box.add_theme_stylebox_override("panel", UIKit.sb(Color(0.3, 0.2, 0.08, 0.1), 8, LINE, 1, Vector4(8, 4, 8, 4)))
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE; sheet_box.add_child(box)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 4); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.add_child(hb)
	if nd.is_empty(): hb.add_child(_lbl(MD.S("r_free", "唔使料", "不用材料"), 15, DIMC, "sans", 900))
	var first = true
	for mid in nd:
		if not first: hb.add_child(_lbl("＋", 15, DIMC, "sans", 900))
		first = false
		hb.add_child(_mat_ic(mid, 34))
		var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", -2); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(vb)
		vb.add_child(_lbl("%s ×%s" % [M.name(mid), M.qty(nd[mid])], 14, INK, "sans", 900))
		var have = _lbl("", 14, GREEN, "sans", 700); vb.add_child(have)
		_recipe_rows.append([have, mid, nd[mid]])
	hb.add_child(_lbl("→", 18, RED, "sans", 900))
	var oid = out_mid if out_mid != "" else gid
	hb.add_child(_mat_ic(oid, 34))
	var ov = VBoxContainer.new(); ov.add_theme_constant_override("separation", -2); ov.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(ov)
	var onm = M.name(out_mid) if out_mid != "" else MD.T(MD.good_def(gid).get("n"))
	ov.add_child(_lbl("%s ×%s" % [onm, MD.fmt(MD.out(sid, sim.lv(sid)))], 14, INK, "sans", 900))
	if out_mid != "":
		var oh = _lbl("", 14, DIMC, "sans", 700); ov.add_child(oh); _recipe_rows.append([oh, out_mid, -1.0])
	# 分流
	if out_mid != "":
		var rr = HBoxContainer.new(); rr.add_theme_constant_override("separation", 6); sheet_box.add_child(rr)
		var rl = _lbl(_route_txt(sid), 14, DIMC, "sans", 700); rl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; rl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; rr.add_child(rl)
		var rb = UIKit.btn(_route_name(sim.route(sid)), "", true); rb.custom_minimum_size = Vector2(112, 40); rb.focus_mode = Control.FOCUS_NONE; rb.add_theme_font_size_override("font_size", 15)
		rb.pressed.connect(func(): sim.next_route(sid); _save(); _snd("click"); _fill_sheet())
		rr.add_child(rb)
	_refresh_recipe()
func _refresh_recipe() -> void:
	for e in _recipe_rows:
		if not is_instance_valid(e[0]): continue
		var a = M.amt(e[1])
		if e[2] < 0.0: e[0].text = MD.S("r_stock", "庫存 %s", "庫存 %s") % M.qty(floor(a))
		else:
			e[0].text = MD.S("r_have", "有 %s", "有 %s") % M.qty(floor(a))
			e[0].add_theme_color_override("font_color", GREEN if a >= e[2] - 1e-6 else RED)
func _route_name(r: String) -> String:
	match r:
		"stock": return MD.S("rt_stock", "全部入倉", "全部入倉")
		"sell": return MD.S("rt_sell", "全部出售", "全部出售")
	return MD.S("rt_auto", "自動分流", "自動分流")
func _route_txt(sid: String) -> String:
	var mid = M.rout(sid)
	match sim.route(sid):
		"stock": return MD.S("rtt_stock", "做好嘅貨全部入倉（倉滿先擺櫃台）", "做好的貨全部入倉（倉滿才擺櫃台）")
		"sell": return MD.S("rtt_sell", "做好嘅貨全部擺櫃台賣", "做好的貨全部擺櫃台賣")
	var users = sim.consumers(mid, sid)
	if users.size():
		var nm = []
		for u in users.slice(0, 2): nm.append(MD.T(MD.st_def(u).get("n")))
		return MD.S("rtt_up", "上層要料優先：%s 用緊，庫存未夠 %s 就入倉，夠咗先賣", "上層要料優先：%s 在用，庫存未夠 %s 就入倉，夠了才賣") % ["、".join(nm), M.qty(ceil(sim.buffer_of(mid, sid)))]
	if mid == "m_shoubao": return MD.S("rtt_bun", "壽包係前線口糧：一半入倉、一半擺櫃台", "壽包是前線口糧：一半入倉、一半擺櫃台")
	if M.is_item(mid): return MD.S("rtt_item", "戰鬥道具：庫存未夠 %d 件就入倉", "戰鬥道具：庫存未夠 %d 件就入倉") % int(sim.ITEM_KEEP)
	return MD.S("rtt_sale", "冇台用呢樣貨：全部擺櫃台賣", "沒有台用這樣貨：全部擺櫃台賣")
# 材料圖示（Control）
func _mat_ic(mid: String, sz: float) -> Control:
	var c = Control.new(); c.custom_minimum_size = Vector2(sz, sz); c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func(): _icon(Ctx.new(c), mid, sz / 2.0, sz, sz))
	return c
func _starve_txt(miss) -> String:
	var nm = []
	for mid in (miss if miss is Array else []): nm.append(M.name(str(mid)))
	return MD.S("starve", "斷料：缺 %s", "斷料：缺 %s") % "、".join(nm)

func _v(x: float) -> String: return MD.fmt(x) if x >= 100.0 else ("%.1f" % x).trim_suffix(".0")

# [idle] 資料卡：下個里程碑效果、累計產量進度、門檻提示、領班位、解鎖下一台條件
var _idle_lbls: Array = []
func _wl(t0: String, sz: int, col: Color) -> Label:
	var x = _lbl(t0, sz, col, "sans", 900); x.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; x.custom_minimum_size = Vector2(350, 0)
	return x
func _idle_rows(sid: String) -> void:
	_idle_lbls.clear()
	var l = sim.lv(sid); var nm = MD.next_mile(sid, l)
	if nm > 0:
		var i = MD.mile_idx(sid, nm)
		sheet_box.add_child(_wl(MD.S("s_mile2", "升到 Lv%d：%s＋品質 ★%d（里程碑 %d／%d）", "升到 Lv%d：%s＋品質 ★%d（里程碑 %d／%d）") % [nm, IDL.mile_txt(sid, i), MD.stars(sid, l) + 1, i + 1, MD.miles(sid).size()], 15, Color("#9c2219")))
		var pl = _wl("", 14, DIMC); sheet_box.add_child(pl); _idle_lbls.append(["gate", pl])
		var pb = ProgressBar.new(); pb.custom_minimum_size = Vector2(350, 12); pb.show_percentage = false; pb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pb.add_theme_stylebox_override("background", UIKit.sb(Color(0.3, 0.2, 0.08, 0.18), 6, LINE, 1)); pb.add_theme_stylebox_override("fill", UIKit.sb(Color("#c8902a"), 6, Color("#c8902a"), 0))
		sheet_box.add_child(pb); _idle_lbls.append(["bar", pb])
	var fr = HBoxContainer.new(); fr.add_theme_constant_override("separation", 6); sheet_box.add_child(fr)
	var fl = _lbl(MD.S("fore_t", "領班", "領班"), 15, DIMC, "sans", 900); fr.add_child(fl)
	fr.add_child(_slot_btn("fore:" + sid, 0, IDL.fore(sim, sid)))
	var fd = _lbl(MD.S("fore_on", "自動開工、自動收錢，做貨快 25%", "自動開工、自動收錢，做貨快 25%") if IDL.has_fore(sim, sid) else MD.S("fore_off", "冇領班：冇員工要自己撳台開工收貨", "沒有領班：沒員工要自己點台開工收貨"), 14, DIMC, "sans", 700)
	fd.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; fd.size_flags_horizontal = Control.SIZE_EXPAND_FILL; fr.add_child(fd)
	var nx = IDL.next_of(sim.ci(), sid)
	if nx != "" and not sim.unlocked(nx):
		var ok = l >= IDL.UNLOCK_LV
		sheet_box.add_child(_wl((MD.S("nx_ok", "已可解鎖下一台：%s", "已可解鎖下一台：%s") % MD.T(MD.st_def(nx).get("n"))) if ok else (MD.S("nx_req", "升到 Lv%d 解鎖下一台：%s", "升到 Lv%d 解鎖下一台：%s") % [IDL.UNLOCK_LV, MD.T(MD.st_def(nx).get("n"))]), 14, GREEN if ok else DIMC))
	_refresh_idle()
func _refresh_idle() -> void:
	if sel == "": return
	var g = IDL.gate_block(sim, sel); var nm = MD.next_mile(sel, sim.lv(sel))
	var need = float(MD.gate(sel, nm)) if nm > 0 else 0.0; var have = IDL.made_n(sim, sel)
	for e in _idle_lbls:
		if not is_instance_valid(e[1]): continue
		if e[0] == "gate":
			if int(g[0]) > 0: e[1].text = MD.S("gate_need", "再產 %s 件先可以升到 Lv%d（累計 %s／%s）", "再產 %s 件才能升到 Lv%d（累計 %s／%s）") % [MD.fmt(g[2]), int(g[0]), MD.fmt(have), MD.fmt(g[1])]; e[1].add_theme_color_override("font_color", RED)
			else: e[1].text = MD.S("gate_ok", "累計產量 %s／%s：夠數，可以升", "累計產量 %s／%s：夠數，可以升") % [MD.fmt(have), MD.fmt(need)]; e[1].add_theme_color_override("font_color", GREEN)
		elif e[0] == "bar": e[1].max_value = maxf(1.0, need); e[1].value = minf(have, need)
func _refresh_sheet_btns() -> void:
	_refresh_idle()   # [idle]
	if sel == "": return
	for e in _up_btns:
		var b: Button = e[0]
		if not is_instance_valid(b): continue
		var n = sim.up_n_for(sel, e[1])
		var cost = MD.cost_n(sel, sim.lv(sel), n)
		var head = MD.S("up_n", "升 %d 級", "升 %d 級") % n
		if e[1] == "mile": head = MD.S("up_mile", "升到 Lv%d", "升到 Lv%d") % int(sim.lv(sel) + n)
		b.text = "%s\n%s %s" % [head, MD.S("coin", "冥幣", "冥幣"), MD.fmt(cost)]
		if n <= 0 and int(IDL.gate_block(sim, sel)[0]) > 0: b.text = MD.S("up_gate", "產量未夠\n再產 %s 件", "產量未夠\n再產 %s 件") % MD.fmt(IDL.gate_block(sim, sel)[2])   # [idle]
		b.disabled = n <= 0 or sim.coins() < cost

func _do_up(sid: String, mode: String) -> void:
	var n = sim.up_n_for(sid, mode)
	if sim.upgrade(sid, n) > 0: _save(); _fill_sheet()

func _slot_btn(sid: String, i: int, gid) -> Control:
	var b = Button.new(); b.custom_minimum_size = Vector2(110, 60); b.focus_mode = Control.FOCUS_NONE
	for stn in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(stn, UIKit.sb(Color(1, 0.97, 0.88, 0.8), 8, LINE, 1))
	var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 4; hb.offset_right = -4; hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_theme_constant_override("separation", 3); hb.alignment = BoxContainer.ALIGNMENT_CENTER; b.add_child(hb)
	var gh = sim.ghost(gid) if gid != null else null
	if gh == null: hb.add_child(_lbl(MD.S("hire", "＋派鬼", "＋派鬼"), 15, RED, "sans", 900))
	else:
		var pr = UIKit.portrait(J.str(J.gp(gh, "k")), 40); pr.custom_minimum_size = Vector2(32, 44); pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
		var nl = _lbl(J.str(J.gp(gh, "name")).get_slice("・", 0), 14, INK, "sans", 700); nl.clip_text = true; nl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; nl.custom_minimum_size = Vector2(60, 0); hb.add_child(nl)
	b.pressed.connect(func(): _open_picker(sid, i))
	return b

# ================= 揀鬼 =================
func _open_picker(list: String, i: int) -> void:
	_close_picker(); _snd("click")
	picker = Control.new(); picker.position = Vector2.ZERO; picker.size = frame.size; picker.mouse_filter = Control.MOUSE_FILTER_STOP; frame.add_child(picker)
	var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.55); dim.position = Vector2.ZERO; dim.size = frame.size; picker.add_child(dim)
	dim.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: _close_picker())
	var top = maxf(top_pad + 60.0, H * 0.24)
	var pn = PanelContainer.new(); pn.position = Vector2(0, top); pn.size = Vector2(FW, H - bot_pad - top)
	var s = UIKit.sb(Color("#ecd9a4"), 12, LINE, 1, Vector4(12, 12, 12, 10)); s.corner_radius_bottom_left = 0; s.corner_radius_bottom_right = 0
	pn.add_theme_stylebox_override("panel", s); picker.add_child(pn)
	var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 8); pn.add_child(v)
	var h = HBoxContainer.new(); v.add_child(h)
	var what = MD.S("guard_job", "守圍欄", "守圍欄") if list == "guard" else MD.T(MD.st_def(list).get("n"))
	if list.begins_with("fore:"): what = MD.S("fore_job", "%s 領班", "%s 領班") % MD.T(MD.st_def(list.substr(5)).get("n"))   # [idle]
	var tl = _lbl(MD.S("pick_t", "派鬼：%s", "派鬼：%s") % what, 20, INK, "sans", 900)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; h.add_child(tl)
	var cb = UIKit.btn("✕", "ghost", true); cb.custom_minimum_size = Vector2(44, 44); cb.pressed.connect(_close_picker); h.add_child(cb)
	var arr = sim.st().guards if list == "guard" else sim.sst(list).workers
	if list.begins_with("fore:"): arr = IDL.fore_arr(sim, list.substr(5))   # [idle]
	var cur = arr[i] if i < arr.size() else null
	if cur != null and sim.ghost(cur) != null:
		var rb = UIKit.btn(MD.S("unpick", "撤走 %s", "撤走 %s") % J.str(J.gp(sim.ghost(cur), "name")), "", false); rb.custom_minimum_size = Vector2(0, 46)
		rb.pressed.connect(func(): sim.assign(list, i, null); _save(); _close_picker(); _after_assign()); v.add_child(rb)
	var sc = ScrollContainer.new(); sc.size_flags_vertical = Control.SIZE_EXPAND_FILL; sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; v.add_child(sc)
	var lst = VBoxContainer.new(); lst.size_flags_horizontal = Control.SIZE_EXPAND_FILL; lst.add_theme_constant_override("separation", 6); sc.add_child(lst)
	var Lp = sim.pick_list()
	if Lp.is_empty():
		var le = _lbl(MD.S("no_ghost", "冇鬼可以派。去招魂台招多啲鬼先。", "沒有鬼可以派。先去招魂台多招些鬼。"), 16, DIMC); le.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; le.custom_minimum_size = Vector2(340, 0); lst.add_child(le)
	var PL = J.G.get("postLabel")
	for gh in Lp.slice(0, 40):
		if J.seq(J.gp(gh, "id"), cur): continue
		var row = Button.new(); row.custom_minimum_size = Vector2(0, 66); row.focus_mode = Control.FOCUS_NONE
		for stn in ["normal", "hover", "pressed"]: row.add_theme_stylebox_override(stn, UIKit.sb(Color(1, 0.97, 0.88, 0.8 if stn != "pressed" else 0.6), 8, LINE, 1))
		var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.offset_left = 8; hb.offset_right = -10; hb.add_theme_constant_override("separation", 10); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; row.add_child(hb)
		var pr = UIKit.portrait(J.str(J.gp(gh, "k")), 50); pr.size_flags_vertical = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(vb)
		var nm = _lbl("%s　Lv%d" % [J.str(J.gp(gh, "name")), int(sim.glv(gh))], 17, INK, "sans", 900); nm.clip_text = true; nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; vb.add_child(nm)
		var pp = J.gp(gh, "post"); var where = MD.S("idle", "閒住", "閒著")
		if J.seq(pp, "mv"): where = MD.S("in_mv", "移動村開工中（會調過嚟）", "移動村工作中（會調過來）")
		elif J.seq(pp, "garrison"): where = MD.S("in_gar", "分村駐守中（會調過嚟）", "分村駐守中（會調過來）")
		elif J.t(pp): where = (J.str(J.cl(PL, null, [pp])) if PL != null else MD.S("busy", "做緊嘢", "工作中")) + MD.S("moved", "（會調走）", "（會調走）")
		var info = _lbl(where, 14, DIMC); info.clip_text = true; info.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; vb.add_child(info)
		var gid = J.gp(gh, "id")
		row.pressed.connect(func():
			if sim.assign(list, i, gid): _save()
			_close_picker(); _after_assign())
		lst.add_child(row)

func _after_assign() -> void:
	_snd("build"); sim.sync()
	if sheet.visible and sel != "": _fill_sheet()
func _close_picker() -> void:
	if picker != null and is_instance_valid(picker): picker.queue_free()
	picker = null

# ================= 其他 =================
func _snd(n: String) -> void:
	var s = get_node_or_null("/root/Snd") if is_inside_tree() else null
	if s != null: s.play(n)
func _pick(a: Array):
	return a[_rng.randi() % a.size()] if a.size() else ["", ""]

# ---------------- 整合／測試用（同整合線假場景同名嘅 API）----------------
func sids() -> Array: return MD.stations(ci())
func ent(sid: String) -> Dictionary: return sim.sst(sid)
func sdef(sid: String) -> Dictionary: return MD.st_def(sid)
func up_cost(sid: String) -> float: return MD.cost1(sid, sim.lv(sid))
func _pay_unlock(sid: String, cost: float) -> void:
	if sim.coins() < cost: sim.add_coins(cost - sim.coins())
	sim.unlock(sid)
func _pay_up(sid: String, cost: float) -> void:
	if sim.coins() < cost: sim.add_coins(cost - sim.coins())
	sim.upgrade(sid, 1)
func _hire(sid: String) -> bool:
	var w: Array = sim.sst(sid).workers
	var slot = w.find(null)
	if slot < 0: return false
	for gh in sim.pick_list():
		if not J.t(J.gp(gh, "post")): return sim.assign(sid, slot, J.gp(gh, "id"))
	return false
func income_ps() -> float: return sim.offline_rate()
