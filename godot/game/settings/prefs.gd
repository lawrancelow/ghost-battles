# [settings] 玩家設置（裝置設定，存 user://settings.cfg；唔跟存檔碼走，重開遊戲記得）
#   聲音：總音量／音樂／音效／語音（各自一條音軌 Music／SFX／Voice，都送去 Master）；靜音開關沿用 Snd.toggle()
#   畫面：幀率 30／60（流暢模式開時照鎖 30）、螢幕常亮
#   劇情：文字速度（慢／中／快／即時）、自動播放
#   對白語言仍然由 DB.set_lang 管（同一個 settings.cfg 嘅 ui/dialogue_lang）
# 熱更新：冇 class_name；用 const PF = preload("res://game/settings/prefs.gd")
extends RefCounted

const FILE := "user://settings.cfg"
const SEC := "prefs"
const BUS := {"music": "Music", "sfx": "SFX", "voice": "Voice"}
const SPEED_SEC := [0.05, 0.028, 0.014, 0.0]   # 每個字幾秒；0 ＝ 即時
const SPEED_NAME := ["慢", "中", "快", "即時"]
const FPS_OPTS := [30, 60]

static var _loaded := false
static var vol := {"master": 0.9, "music": 0.8, "sfx": 0.9, "voice": 1.0}
static var text_speed := 1
static var auto_play := false
static var keep_on := true
static var fps := 60
# [pc] PC 版專屬（Steam）：顯示模式、解析度、垂直同步；手機唔顯示、唔套用
const WIN_MODES := ["視窗", "全螢幕", "無邊框"]
const RES_OPTS := ["1280×720", "1600×900", "1920×1080"]
static var win_mode := 0
static var res := ""        # "" ＝ 未揀過（唔郁視窗大小）
static var vsync := true

static func load_pref() -> void:
	if _loaded: return
	_loaded = true
	var c = ConfigFile.new()
	if c.load(FILE) != OK: return
	for k in vol.keys(): vol[k] = clampf(float(c.get_value(SEC, "vol_" + k, vol[k])), 0.0, 1.0)
	text_speed = clampi(int(c.get_value(SEC, "text_speed", text_speed)), 0, SPEED_SEC.size() - 1)
	auto_play = bool(c.get_value(SEC, "auto_play", auto_play))
	keep_on = bool(c.get_value(SEC, "keep_on", keep_on))
	fps = int(c.get_value(SEC, "fps", fps))
	if not FPS_OPTS.has(fps): fps = 60
	win_mode = clampi(int(c.get_value(SEC, "win_mode", win_mode)), 0, 2)
	res = str(c.get_value(SEC, "res", res)); vsync = bool(c.get_value(SEC, "vsync", vsync))

static func save() -> void:
	var c = ConfigFile.new(); c.load(FILE)   # 保留其他段（例如 ui/dialogue_lang）
	for k in vol.keys(): c.set_value(SEC, "vol_" + k, vol[k])
	c.set_value(SEC, "text_speed", text_speed); c.set_value(SEC, "auto_play", auto_play)
	c.set_value(SEC, "keep_on", keep_on); c.set_value(SEC, "fps", fps)
	c.set_value(SEC, "win_mode", win_mode); c.set_value(SEC, "res", res); c.set_value(SEC, "vsync", vsync)
	c.save(FILE)

# 測試用：清返預設（唔寫檔）
static func reset_defaults() -> void:
	vol = {"master": 0.9, "music": 0.8, "sfx": 0.9, "voice": 1.0}
	text_speed = 1; auto_play = false; keep_on = true; fps = 60; win_mode = 0; res = ""; vsync = true; _loaded = true

# ---------------- 聲音 ----------------
static func ensure_buses() -> void:
	for k in BUS:
		var n: String = BUS[k]
		if AudioServer.get_bus_index(n) >= 0: continue
		AudioServer.add_bus(); var i = AudioServer.bus_count - 1
		AudioServer.set_bus_name(i, n); AudioServer.set_bus_send(i, "Master")

static func bus(kind: String) -> String:
	ensure_buses(); return BUS.get(kind, "Master")

# on：Snd 嘅靜音開關（關 ＝ Master 靜音）
static func apply_audio(on := true) -> void:
	load_pref(); ensure_buses()
	var m = float(vol.master)
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(m, 0.0001)) if on and m > 0.001 else -80.0)
	for k in BUS:
		var i = AudioServer.get_bus_index(BUS[k]); var v = float(vol[k])
		AudioServer.set_bus_volume_db(i, linear_to_db(maxf(v, 0.0001)) if v > 0.001 else -80.0)
		AudioServer.set_bus_mute(i, v <= 0.001)

static func set_vol(k: String, v: float) -> void:
	load_pref(); vol[k] = clampf(v, 0.0, 1.0); save()
	var snd = Engine.get_main_loop().root.get_node_or_null("Snd") if Engine.get_main_loop() is SceneTree else null
	apply_audio(snd.call("is_on") if snd != null and snd.has_method("is_on") else true)

static func pct(k: String) -> int: load_pref(); return int(round(float(vol[k]) * 100.0))

# ---------------- 畫面 ----------------
static func perf_on() -> bool:
	var PM = load("res://ui/perf_mode.gd"); PM.load_pref(); return PM.on

# 幀率：流暢模式開就鎖 30；否則跟設定（30／60）
static func cur_fps() -> int:
	load_pref(); return 30 if perf_on() else fps

static func apply_display() -> void:
	load_pref()
	Engine.max_fps = cur_fps()
	DisplayServer.screen_set_keep_on(keep_on)
	if is_pc(): apply_window()

# ---------------- PC（Steam）----------------
static func is_pc() -> bool: return OS.has_feature("pc") and not OS.has_feature("mobile") and not OS.has_feature("web")

static func res_size(r: String) -> Vector2i:
	var p = r.split("×")
	return Vector2i(int(p[0]), int(p[1])) if p.size() == 2 else Vector2i.ZERO

static func apply_window() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)
	match win_mode:
		1: DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false); DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_:
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			var sz = res_size(res)
			if sz != Vector2i.ZERO:
				DisplayServer.window_set_size(sz)
				var sc = DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen())
				DisplayServer.window_set_position(sc.position + (sc.size - sz) / 2)

static func set_win_mode(i: int) -> void: load_pref(); win_mode = clampi(i, 0, 2); save(); apply_window()
static func set_res(r: String) -> void: load_pref(); res = r; win_mode = 0; save(); apply_window()
static func set_vsync(v: bool) -> void: load_pref(); vsync = v; save(); apply_window()

# [pc] 橫屏（PC 視窗／之後 Steam 版）：keep_width 會令高度得返 200 幾點，改用 expand；直屏照舊 keep_width
static func apply_orient(root: Window) -> void:
	if root == null: return
	var ws = root.size
	var want = Window.CONTENT_SCALE_ASPECT_EXPAND if ws.x > ws.y else Window.CONTENT_SCALE_ASPECT_KEEP_WIDTH
	if root.content_scale_aspect != want: root.content_scale_aspect = want

static func watch_orient(root: Window) -> void:
	if root == null or root.has_meta("gb_orient"): return
	root.set_meta("gb_orient", 1)
	root.size_changed.connect(func(): apply_orient(root))
	apply_orient(root)

static func set_fps(v: int) -> void:
	load_pref(); fps = v if FPS_OPTS.has(v) else 60; save(); apply_display()

static func set_keep_on(v: bool) -> void:
	load_pref(); keep_on = v; save(); apply_display()

# ---------------- 劇情 ----------------
static func type_sec() -> float: load_pref(); return SPEED_SEC[text_speed]
static func set_text_speed(i: int) -> void: load_pref(); text_speed = clampi(i, 0, SPEED_SEC.size() - 1); save()
static func set_auto(v: bool) -> void: load_pref(); auto_play = v; save()
# 自動播放：一句打完字之後等幾耐先翻頁（按字數）
static func auto_wait(n_chars: int) -> float: return 1.2 + 0.05 * n_chars
