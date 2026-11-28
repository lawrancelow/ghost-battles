# 主畫面（移植 shell.html ＋ game.js UI）：頂欄、村子、任務條、底部導航、面板、劇情、提示、標題畫面
extends Control

var village: Control
# 移動村（出殯巡遊大排檔）：S.mv_on 開咗就用佢做 home 分頁，舊村子畫面收埋（代碼保留，開關關咗照用）
const MVB := preload("res://game/outpost/mv_bridge.gd")
const MVW := preload("res://game/outpost/mv_war.gd")   # [war] 親自出征：收戰鬥結果
const RAID := preload("res://game/raid/raid.gd")   # [raid] 村子被惡鬼襲擾
const MV_SCENE := "res://game/outpost/mv_scene.gd"            # 引擎線交貨
const MV_STUB := "res://game/outpost/mv_scene_stub.gd"        # 整合線假場景（引擎未交貨時用）
const CBLD := preload("res://game/outpost/chain_bld.gd")   # [village] 後院拓展建築
var mv_host: Control
var mv_view: Control = null
var mv_back: Button
var mv_embed: Node = null   # [unify] 合一地圖：村子分頁頂段嘅大排檔區（game/outpost/mv_embed.gd）
const ZDm := preload("res://game/zone/zone_data.gd")   # [zone] 分區地圖
const LMm := preload("res://game/zone/landmark.gd")   # [landmark] 地標
const ZVm := preload("res://game/zone/zone_view.gd")   # [zone]
const UNIFY := true          # [unify] 合一地圖（移動村獨立全屏畫面、後院掣、營地取消）
var dom: Control
var quest_bar: PanelContainer
var quest_go: Button   # [onboard]
var quest_lbl: RichTextLabel
var quest_prog: Label
var lv_lbl: Label
var exp_fill: ColorRect
var exp_bar: ColorRect
var exp_txt: Label
var res_lbl = {}
var res_cell = {}
var nav_btns = {}
var chest_badge: Label
var sheet: Panel
var sheet_title: Label
var sheet_body: VBoxContainer
var sheet_scroll: ScrollContainer
var sheet_refresh = Callable()
var story: Control
var toasts: VBoxContainer
var banner: PanelContainer
var banner_lbl: Label
var praise_box: PanelContainer
var praise_lbl: Label
var title_ov: Control
var tab = "village"
var ui_t = 0.0
var save_t = 0.0
var last_praise = {}

const TOP_H := 102.0
const NAV_H := 58.0

func _ready() -> void:
	print("[boot] main ready")
	load("res://game/settings/prefs.gd").apply_display()   # [settings] 幀率、螢幕常亮（PC：視窗模式、解析度、垂直同步）
	load("res://game/settings/prefs.gd").watch_orient(get_tree().root)   # [pc] 橫屏改用 expand 縮放
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg = ColorRect.new(); bg.color = UIKit.INK; bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
	load("res://ui/kit_skin.gd").install(get_tree())   # [uikit] 紙底面板自動換紙紋＋鐵櫃框
	_build_village(); _build_top(); _build_nav(); _build_sheet()
	story = Control.new(); story.set_script(load("res://ui/story.gd"))
	var scl = CanvasLayer.new(); scl.layer = 125; scl.name = "StoryLayer"; add_child(scl); scl.add_child(story)   # [uxui] 劇情永遠喺最上（面板 100、提示 105、特效 110、裝備彈窗 115 都喺佢下面）
	_build_fx()
	load("res://game/outpost/ctl_ui.gd").attach(self)   # [ctl] 行動按鈕、出擊清單、地盤掣變灰
	load("res://ui/onboard/tut.gd").attach(self)   # [onboard] 第一章新手教程（手指＋挖洞遮罩）
	move_child(praise_box, sheet.get_index())   # 系統誇獎喺村子層，面板蓋住佢（同網頁版 z-index 一樣）
	G.modal_open = func() -> bool: return J.t(J.mc(J.G.get("UI"), "modalOpen", []))
	G.refreshed.connect(refresh); G.toast.connect(show_toast); G.banner.connect(show_banner); G.praise.connect(show_praise)
	get_tree().auto_accept_quit = false
	# ---- 轉譯版 JS 遊戲：逐個模塊載入（每幀一個），顯示進度 ----
	_boot_js()

var loading: Control
func _boot_js() -> void:
	loading = ColorRect.new(); loading.color = Color("#0d0b10"); loading.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(loading)
	# 封面闊度鋪滿、靠頂（長身手機唔再左右裁走），下面接底色
	var TVc = load("res://ui/title/title_view.gd"); var ctex: Texture2D = TVc.tex("cover2")   # [title] 有新封面先用
	var nc = ctex != null
	if not nc: ctex = Spr.get_tex("cover")
	var cov = TextureRect.new(); cov.texture = ctex; cov.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cov.stretch_mode = TextureRect.STRETCH_SCALE
	cov.anchor_right = 1; cov.modulate = Color(0.72, 0.72, 0.74) if nc else Color(0.55, 0.55, 0.55); loading.add_child(cov)
	var cfd = TextureRect.new(); cfd.texture = _vgrad([[0.0, Color(0.05, 0.04, 0.06, 0)], [1.0, Color("#0d0b10")]]); cfd.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cfd.stretch_mode = TextureRect.STRETCH_SCALE; cfd.anchor_right = 1; loading.add_child(cfd)
	var lgt: Texture2D = TVc.tex("title_logo") if nc else null
	if lgt != null:
		var lg = TextureRect.new(); lg.texture = lgt; lg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; lg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		lg.anchor_left = 0.07; lg.anchor_right = 0.93; lg.anchor_top = 0.045; lg.anchor_bottom = 0.30; loading.add_child(lg)
	var cfit = func():
		if ctex == null: return
		var ch = loading.size.x * ctex.get_height() / ctex.get_width(); cov.offset_bottom = ch; cfd.offset_top = ch * 0.72; cfd.offset_bottom = ch + 2
	loading.resized.connect(cfit); cfit.call()
	var lb = UIKit.label("陰間連線中…", 16, Color("#f3e6c8"), "serif", 900); lb.anchor_left = 0; lb.anchor_right = 1; lb.anchor_top = 0.82; lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; loading.add_child(lb)
	var bar_bg = ColorRect.new(); bar_bg.color = Color("#3a2e26"); bar_bg.anchor_left = 0.15; bar_bg.anchor_right = 0.85; bar_bg.anchor_top = 0.87; bar_bg.anchor_bottom = 0.87; bar_bg.offset_bottom = 6; loading.add_child(bar_bg)
	var bar = ColorRect.new(); bar.color = Color("#c2362b"); bar.size = Vector2(0, 6); bar_bg.add_child(bar)
	# 統一進度條：開機畫面（ui/launch.gd）嘅大進度條由更新一路推到載完模塊；冇（例如重載）就自己開一個只顯示用嘅
	var ov = get_node_or_null("/root/GBLoad")
	if ov == null:
		ov = load("res://ui/launch.gd").Overlay.new(); ov.passive = true; ov.name = "GBLoad"; get_tree().root.add_child(ov)
	else: ov.handoff()
	await get_tree().process_frame
	# 開機麵包屑（user://boot_crumb.txt，每步寫入）：上次未到「ok」就係閃退／卡死 → 救命畫面
	#   畫面階段出事會自動開安全畫面模式（G.read_crumb）
	G.read_crumb()
	# 全面自檢（新版第一次開會自動跑；閃退重開會自動繼續）
	SelfTest.on_boot()
	if SelfTest.active() or G.last_crash != "":
		if is_instance_valid(ov): ov.hide_now()   # 自檢畫面／救命畫面要撳得到，唔好遮住
	if SelfTest.active():
		G.last_crash = ""
		if str(SelfTest.S.res.get("boot", "")) == "閃退": G.safe_gfx = true   # 開機本身都閃退：用安全模式先行得落去
		selftest = SelfTest.new(); selftest.build(self)
		if str(SelfTest.S.res.get("boot", "")) == "閃退兩次":
			# 安全模式都開唔到：唔再試，直接出報告
			selftest._finish(); return
		await selftest.run_pre()
		JSRun.ls[SAVE_KEY] = SelfTest.test_save_json()
		if not SelfTest.S.res.has("boot"): SelfTest.begin("boot")
	if G.last_crash != "":
		var choice = await _boot_rescue(loading, G.last_crash)
		if choice == "fresh": _set_aside_save()
		elif choice == "selftest": SelfTest.start(true); JSRun.reset_world(); get_tree().call_deferred("reload_current_scene"); return
		elif choice == "safe": G.set_safe_gfx(true)
	G.crumb("modules")
	var t0 = Time.get_ticks_msec(); boot_full_t = t0 + 70000   # 載模塊階段：90 秒都未完先出記錄
	JSBridge.install_natives(JSRun)
	JSRun.boot_dom("res://web/shell.html")
	dom = Control.new(); dom.set_script(load("res://ui/dom_view.gd")); add_child(dom); move_child(dom, sheet.get_index())
	var names = FileAccess.get_file_as_string("res://jsgen/modules.txt").split("\n", false)
	for i in names.size():
		if i % 8 == 0: G.crumb("mod:" + names[i])
		JSRun.load_modules([names[i]])
		bar.size.x = bar_bg.size.x * float(i + 1) / names.size()
		if is_instance_valid(ov): ov.prog(float(i + 1) / names.size())
		await get_tree().process_frame
	print("[boot] modules ", Time.get_ticks_msec() - t0, "ms")
	lb.text = "陰間連線中…（開門）"; boot_full_t = Time.get_ticks_msec()
	# 每一步獨立行：其中一步出錯都唔會卡死喺載入畫面；出錯會記低，喺畫面同設定入面睇到
	_boot_step("ui", func(): JSBridge.connect_ui(self))
	_boot_step("village", func(): village.bind(JSRun.by_id("village")))
	_boot_step("start", func(): J.cl(J.G.get("startGame"), null, []))
	_boot_step("state", func(): G.S = J.G["S"]; G.js_mode = true)
	_boot_step("mv", func(): MVB.install(); MVB.migrate(); _mv_apply())
	_boot_step("soul", func(): load("res://game/soul/soul_data.gd").install())   # [soul] 祭壇：舊直接加入改送魂魄、改名
	_boot_step("resize", func(): J.mc(J.G.get("Village"), "resize", []))
	_boot_step("refresh", func(): refresh())
	# 逐樣顯示：每樣畫完一幀先開下一樣；手機驅動喺第一次畫某樣嘢時閃退，麵包屑就會講係邊樣（show:xxx）
	await _staged_reveal()
	if is_instance_valid(ov): ov.finish()
	loading.queue_free(); loading = null
	_boot_step("snd", func(): Snd.warm())
	print("[boot] ready ", Time.get_ticks_msec() - t0, "ms")
	# 首幾幀都畫到先算開機成功（Adreno 等驅動 shader 出事會喺第一次畫嘢時閃退）
	G.crumb("frame1"); await RenderingServer.frame_post_draw
	for i in 30:
		if not is_inside_tree(): return   # [unify] 開機後即刻導入存檔（重載）：舊 Main 已經離開場景樹
		await get_tree().process_frame
	G.crumb("frame30"); await RenderingServer.frame_post_draw
	if selftest != null:
		if str(SelfTest.S.get("cur", "")) == "boot": SelfTest.done("boot", "OK")
		selftest.run_post(self); return
	get_tree().create_timer(8.0).timeout.connect(func(): if G.crumb_now() == "frame30": G.crumb("ok"))   # 只清開機記號，唔好蓋過之後（新遊戲等）嘅記號
	if G.last_crash != "" and G.safe_gfx:
		show_toast("上次開機喺「%s」出事，而家用緊安全畫面模式（角色冇骨架動畫）。可以喺設定入面切換。" % G.last_crash)
	var lt = log_tail(400); var nerr = lt.count("SCRIPT ERROR")
	if nerr > 0: boot_fail.append("%d 個腳本錯誤" % nerr)
	if boot_fail.size():
		show_toast("開機有 %d 步出錯（%s），可以喺設定「錯誤記錄」睇詳情，截圖俾開發者。" % [boot_fail.size(), ", ".join(boot_fail)])

# 顯示卡測試：逐樣試一次（只試一次，記錄喺 user://gfx_probe.txt）；試嘅時候閃退，下次就避開嗰樣
func _gfx_probes() -> void:
	var done = FileAccess.get_file_as_string("user://gfx_probe.txt") if FileAccess.file_exists("user://gfx_probe.txt") else ""
	for p in ["grad", "replay", "bake", "cpuskin2", "cpuskin_cloth"]:
		if done.contains(p + ";") or G.gfx_bad.has(p): continue
		G.crumb("probe:" + p)
		var n = PtDraw.new(); n.z_index = -100; add_child(n); move_child(n, 0)
		match p:
			"grad":
				n.fn = func(c):
					var ctx = Ctx.new(c); var g = ctx.createLinearGradient(0, 0, 0, 100); g.addColorStop(0, "#202020"); g.addColorStop(1, "#000000")
					ctx.fillStyle = g; ctx.fillRect(0, 0, 100, 100)
					var r = ctx.createRadialGradient(50, 50, 0, 50, 50, 50); r.addColorStop(0, "rgba(255,255,255,.2)"); r.addColorStop(1, "rgba(255,255,255,0)")
					ctx.fillStyle = r; ctx.fillRect(0, 0, 100, 100)
			"replay":
				var gl = J.cl(J.G.get("groundLayer"), null, [])
				var rec = gl.rec if gl is El else null
				n.fn = func(c): if rec: rec.replay(c, Transform2D(Vector2(0.1, 0), Vector2(0, 0.1), Vector2.ZERO))
			"bake":
				var r2 = Recorder.new(); r2.width = 64; r2.height = 64
				var cx = Ctx.new(r2); cx.fillStyle = "#334455"; cx.fillRect(0, 0, 64, 64)
				if Baker.host == null: Baker.host = self
				Baker._bake(r2)
			"cpuskin2":   # 真角色骨架（CPU 蒙皮）：同村民一樣嘅網格同畫法
				PtGfx.init()
				if PtChar.RIG.is_empty(): PtChar.setup_static()
				var kk = "afu" if PtChar.RIG.has("afu") else (PtChar.RIG.keys()[0] if PtChar.RIG.size() > 0 else "")
				var m = PtGfx.mesh_for(kk, kk, PtChar.RIG[kk].bones) if kk != "" else {}
				if not m.is_empty():
					var cs = CpuSkin.new(); cs.mesh = m.mesh; cs.texture = m.tex; n.add_child(cs)
					var h = 80.0; var W = h / m.ar
					cs.set_shader_parameter("bone", PtGfx.solve(m.bones, {"a1": 0.3}))
					cs.set_shader_parameter("dims", Vector3(W, h, m.ar))
					cs.set_shader_parameter("aff_a", Vector4(1, 0, 0, 1)); cs.set_shader_parameter("aff_o", Vector2(10, 10))
			"cpuskin_cloth":   # 衣服換色層：身體層 + mode 1（同巡陰角色衣服一樣）
				PtGfx.init()
				if PtChar.RIG.is_empty(): PtChar.setup_static()
				var kc = "afu" if PtChar.RIG.has("afu") else (PtChar.RIG.keys()[0] if PtChar.RIG.size() > 0 else "")
				var mc = PtGfx.mesh_for(kc, kc, PtChar.RIG[kc].bones) if kc != "" else {}
				if not mc.is_empty():
					var hc = 80.0; var Wc = hc / mc.ar
					var body = CpuSkin.new(); body.mesh = mc.mesh; body.texture = mc.tex; n.add_child(body)
					var cl = CpuSkin.new(); cl.src = body; cl.mesh = mc.mesh; cl.texture = mc.tex; n.add_child(cl)
					for c in [body, cl]:
						c.set_shader_parameter("bone", PtGfx.solve(mc.bones, {"a1": 0.3}))
						c.set_shader_parameter("dims", Vector3(Wc, hc, mc.ar))
						c.set_shader_parameter("aff_a", Vector4(1, 0, 0, 1)); c.set_shader_parameter("aff_o", Vector2(10, 10))
					cl.set_shader_parameter("mode", 1.0); cl.set_shader_parameter("cm", Basis(Vector3(0.9, 0.1, 0.1), Vector3(0.1, 0.5, 0.1), Vector3(0.1, 0.1, 0.4)))
		n.queue_redraw()
		for i in 3: await RenderingServer.frame_post_draw
		n.queue_free()
		done += p + ";"
		var f = FileAccess.open("user://gfx_probe.txt", FileAccess.WRITE)
		if f: f.store_string(done); f.close()

func _staged_reveal() -> void:
	await _gfx_probes()
	var top_items = []
	for c in get_children():
		if c != loading and c is CanvasItem and c.visible: top_items.append(c); c.visible = false
	var w = village.get("world")
	var w_items = []
	if w is Node2D and village.visible:   # 移動村開住時舊村子收埋：唔好收佢啲子節點（否則轉返舊村子會一片黑）
		for c in w.get_children():
			if c is CanvasItem and c.visible: w_items.append(c); c.visible = false
	for c in top_items:
		G.crumb("show:" + str(c.name)); c.visible = true
		await RenderingServer.frame_post_draw
		if c == village and w is Node2D:
			for k in w_items:
				if k is Node2D and k.y_sort_enabled:
					# y 排序層：按種類分批開（擺設、地段、角色…）
					var groups := {}
					for g in k.get_children():
						if g is CanvasItem and g.visible:
							var key = g.get_class() + ":" + str(g.get("tag") if g.get("tag") != null else g.name).substr(0, 3)
							if not groups.has(key): groups[key] = []
							groups[key].append(g); g.visible = false
					G.crumb("show:village/" + str(k.name)); k.visible = true
					await RenderingServer.frame_post_draw
					for key in groups:
						G.crumb("show:village/" + str(k.name) + "/" + key)
						for g in groups[key]: g.visible = true
						await RenderingServer.frame_post_draw
				else:
					G.crumb("show:village/" + str(k.name) + ":" + str(k.get("tag") if k.get("tag") != null else "")); k.visible = true
					await RenderingServer.frame_post_draw
	G.crumb("show:agents"); G.boot_agents_ok = true
	for i in 3: await RenderingServer.frame_post_draw

var selftest: SelfTest = null
var boot_fail: Array = []
var _step_ok := false
# 上一次嘅記錄檔（Godot 開機會將舊 godot.log 改名加日期）
static func prev_log_tail(n := 40) -> String:
	var d = DirAccess.open("user://logs")
	if d == null: return "（冇舊記錄）"
	var fs = Array(d.get_files()).filter(func(x): return x.ends_with(".log") and x != "godot.log")
	if fs.is_empty(): return "（冇舊記錄）"
	fs.sort()
	var f = FileAccess.open("user://logs/" + fs[-1], FileAccess.READ)
	if f == null: return "（讀唔到舊記錄）"
	var lines = f.get_as_text().split("\n")
	return "\n".join(lines.slice(maxi(0, lines.size() - n)))

# 救命畫面：顯示上次卡喺邊、舊記錄；可以照常開或者暫時用新存檔（舊存檔保留，唔會刪）
func _boot_rescue(host: Control, prev: String) -> String:
	var box = PanelContainer.new(); box.anchor_right = 1; box.anchor_bottom = 1; box.offset_left = 10; box.offset_right = -10; box.offset_top = 30; box.offset_bottom = -30
	var st = StyleBoxFlat.new(); st.bg_color = Color(0.07, 0.05, 0.08, 0.93); st.set_corner_radius_all(8); st.set_content_margin_all(10); box.add_theme_stylebox_override("panel", st)
	host.add_child(box)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 8); box.add_child(vb)
	var h = Label.new(); h.text = "上次開遊戲喺「%s」呢一步閃退／卡住。%s\n請截圖呢版俾開發者，然後揀點開：" % [prev, "\n（已自動轉用安全畫面模式）" if G.safe_gfx else ""]
	h.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; h.add_theme_font_size_override("font_size", 14); h.add_theme_color_override("font_color", Color("#ffe2c8")); vb.add_child(h)
	var lg = Label.new(); lg.text = prev_log_tail(36); lg.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; lg.add_theme_font_size_override("font_size", 8)
	lg.add_theme_color_override("font_color", Color("#c8b8a8")); lg.size_flags_vertical = Control.SIZE_EXPAND_FILL; lg.clip_text = true; vb.add_child(lg)
	DisplayServer.clipboard_set("stage=" + prev + "\n" + prev_log_tail(200))
	var b1 = Button.new(); b1.text = "照常開遊戲"; b1.custom_minimum_size = Vector2(0, 44); vb.add_child(b1)
	var b3 = Button.new(); b3.text = "用安全畫面模式開（角色冇骨架動畫）"; b3.custom_minimum_size = Vector2(0, 44); vb.add_child(b3)
	b3.visible = not G.safe_gfx
	var b2 = Button.new(); b2.text = "暫時用新存檔試開（舊存檔會保留，唔會刪）"; b2.custom_minimum_size = Vector2(0, 44); vb.add_child(b2)
	var b4 = Button.new(); b4.text = "全面自檢（約 3–5 分鐘，出報告俾開發者）"; b4.custom_minimum_size = Vector2(0, 44); vb.add_child(b4)
	var res = [""]
	b4.pressed.connect(func(): res[0] = "selftest")
	b1.pressed.connect(func(): res[0] = "normal")
	b2.pressed.connect(func(): res[0] = "fresh")
	b3.pressed.connect(func(): res[0] = "safe")
	while res[0] == "": await get_tree().process_frame
	box.queue_free()
	return res[0]

func _set_aside_save() -> void:
	var src = "user://localStorage.json"
	if FileAccess.file_exists(src):
		DirAccess.rename_absolute(src, "user://localStorage_kept_%d.json" % int(Time.get_unix_time_from_system()))
	JSRun.ls = {}

func _boot_step(name: String, f: Callable) -> void:
	G.crumb(name); _step_ok = false
	_boot_run(f)
	if not _step_ok: boot_fail.append(name); push_error("[boot] step failed: " + name)
func _boot_run(f: Callable) -> void:
	f.call()
	_step_ok = true

# 讀返 Godot 記錄檔最尾幾十行（手機上冇電腦都可以睇錯誤）
static func log_tail(n := 60) -> String:
	var p = ProjectSettings.get_setting("debug/file_logging/log_path", "user://logs/godot.log")
	var f = FileAccess.open(p, FileAccess.READ)
	if f == null: return "（冇記錄檔）"
	var lines = f.get_as_text().split("\n")
	return "\n".join(lines.slice(maxi(0, lines.size() - n)))

func _process_js_state() -> void:
	if J.G.get("S") is Dictionary and not is_same(J.G["S"], G.S): G.S = J.G["S"]

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		G.crumb("ok" if loading == null else "bg")   # 正常離開／切出去唔當閃退；載入途中切出去（之後被系統收咗）記「bg」，下次唔彈救命畫面
		G.save()
		JSRun.flush_ls()   # 即刻寫落磁碟：切出去之後 Android 唔再跑幀，等下一幀先寫就會冇咗（被系統收咗就冇存到）
		if what == NOTIFICATION_WM_CLOSE_REQUEST: get_tree().quit()
	if what == NOTIFICATION_APPLICATION_RESUMED and not G.S.is_empty() and title_ov == null: G.offline_gain()

var boot_full_t := 0
var _boot_diag = null
func _process(dt: float) -> void:
	if loading != null:
		# 看門狗：模塊載完 20 秒仲未入到遊戲 → 喺載入畫面顯示錯誤記錄，可以截圖俾開發者
		if boot_full_t > 0 and Time.get_ticks_msec() - boot_full_t > 20000 and _boot_diag == null:
			_boot_diag = Label.new(); _boot_diag.text = "開機卡住咗，請截圖俾開發者：\n" + log_tail(30)
			_boot_diag.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; _boot_diag.add_theme_font_size_override("font_size", 9)
			_boot_diag.add_theme_color_override("font_color", Color("#ffd8c8")); _boot_diag.anchor_right = 1; _boot_diag.anchor_bottom = 0.78
			_boot_diag.offset_left = 8; _boot_diag.offset_right = -8; _boot_diag.offset_top = 40; loading.add_child(_boot_diag)
			DisplayServer.clipboard_set(log_tail(200))
		return
	_process_js_state()
	if not G.S.is_empty():   # [ux] 庫存監察（倉庫總覽／頂欄 +n）
		load("res://game/econ/stock_watch.gd").tick(dt); _res_float(dt)
	_mq_tick(dt)   # [uxui]
	var scl = story.get_parent() if story != null else null
	if scl is CanvasLayer and scl.visible != story.visible: scl.visible = story.visible   # [uxui] 冇劇情就收埋劇情層（唔好當咗最高層）
	var _m0 = Time.get_ticks_usec()
	LMm.tick(self)   # [landmark] 玩完舊玩法 → 返地標旁邊；地標解鎖 toast
	ui_t += dt
	if ui_t > 0.5 and title_ov == null: ui_t = 0; refresh(); load("res://game/barracks/bk_data.gd").poll()   # [barracks] 清剿結算
	if OS.has_environment("GB_PROF") and Time.get_ticks_usec() - _m0 > 20000: print("[main] ", (Time.get_ticks_usec() - _m0) / 1000.0, "ms")

# ---------------- 版面 ----------------
func _build_village() -> void:
	village = Control.new(); village.set_script(load("res://ui/nv_village.gd"))
	village.anchor_right = 1; village.anchor_bottom = 1; village.offset_top = TOP_H; village.offset_bottom = -NAV_H
	add_child(village)
	mv_host = Control.new(); mv_host.name = "MvHost"; mv_host.visible = false
	mv_host.anchor_right = 1; mv_host.anchor_bottom = 1; mv_host.offset_top = TOP_H + 50; mv_host.offset_bottom = -NAV_H
	add_child(mv_host)
	mv_back = UIKit.btn("後院", "", true); mv_back.add_theme_font_size_override("font_size", 14)
	mv_back.anchor_left = 1; mv_back.anchor_right = 1; mv_back.offset_left = -70; mv_back.offset_right = -8; mv_back.offset_top = 6; mv_back.offset_bottom = 40
	mv_back.pressed.connect(open_backyard)
	load("res://game/joss/joss_ui.gd").attach(self, mv_back)   # [joss] 後院掣角標（青煙＋數字）＋新包裹提示
	quest_bar = PanelContainer.new()
	var s = UIKit.sb(UIKit.PAPER, 2, UIKit.PAPERLINE, 1, Vector4(7, 7, 12, 7)); s.shadow_color = Color(0, 0, 0, 0.35); s.shadow_size = 0; s.shadow_offset = Vector2(0, 3)
	quest_bar.add_theme_stylebox_override("panel", s)
	quest_bar.anchor_right = 1; quest_bar.offset_left = 8; quest_bar.offset_right = -8; quest_bar.offset_top = TOP_H + 8
	add_child(quest_bar)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9); quest_bar.add_child(hb)
	var tagp = PanelContainer.new(); tagp.add_theme_stylebox_override("panel", UIKit.sb(UIKit.CINNABAR, 2, Color(0, 0, 0, 0), 0, Vector4(7, 3, 7, 3)))
	tagp.add_child(UIKit.label("主線", 13, Color("#fbe6d6"), "serif", 900)); hb.add_child(tagp)
	quest_lbl = UIKit.rich("", 15, UIKit.INKTXT); quest_lbl.add_theme_font_override("normal_font", UIKit.font("sans", 700)); quest_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL; quest_lbl.autowrap_mode = TextServer.AUTOWRAP_OFF
	quest_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE; quest_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(quest_lbl)
	quest_prog = UIKit.label("", 15, UIKit.CINNABAR2, "sans", 900); quest_prog.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(quest_prog)
	quest_go = UIKit.btn(OBm().T("前往", "前往"), "", true); quest_go.add_theme_font_size_override("font_size", 13); quest_go.custom_minimum_size = Vector2(52, 28)
	quest_go.size_flags_vertical = Control.SIZE_SHRINK_CENTER; quest_go.focus_mode = Control.FOCUS_NONE; quest_go.pressed.connect(_quest_go); hb.add_child(quest_go)   # [onboard] 主線條「前往」掣
	quest_bar.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: _quest_go())

static func OBm(): return load("res://game/onboard/ob.gd")
# 主線條：撳條或者「前往」→ 帶去當前階段目標
func _quest_go() -> void:
	var q = G.quest_cur()
	var nl = load("res://game/onboard/need.gd").quest_lack(q) if q else {}   # [p56] 缺料先講清楚
	if not nl.is_empty(): show_toast(str(nl.text))
	if q and q.go == "roster": open_roster(); return
	if mv_on() and not UNIFY:   # [unify] 合一地圖：原村子任務照舊（鏡頭去原村子建築）
		if q and (q.get("t") == "stage" or q.get("go") == "gate"): close_sheet(); J.mc(J.G.get("World"), "open", []); return
		close_sheet(); _nav_on("village")
		var cg = {"tree": "wood", "paddy": "rice"}.get(str(q.get("go")), str(q.get("go"))) if q else ""   # [camp] 營地建築任務：鏡頭移去嗰間
		if not nl.is_empty() and str(nl.up) != "": cg = str(nl.up)   # [p56]
		if mv_view != null and mv_view.has_method("focus_camp") and cg != "": mv_view.focus_camp(cg)
		return
	if q and str(q.get("go", "")) == "market" and ZDm.on():   # [onboard] 大排檔賣貨／第一次守夜：鏡頭去大排檔
		close_sheet(); _nav_on("village")
		if ZDm.revealed("market"): _cam_to(ZDm.zrect("market").get_center())
		return
	if ZDm.on() and _stage_focus(): return   # [outgate] 主線關卡：去大排檔前面迎戰
	var p = J.mc(J.G.get("Village"), "questTarget", [])
	if p: close_sheet(); J.mc(J.G.get("Village"), "focus", [p[0], p[1]])

func _build_top() -> void:
	var top = Panel.new(); top.anchor_right = 1; top.offset_bottom = TOP_H
	var st = StyleBoxFlat.new(); st.bg_color = Color("#1a1520"); st.border_color = Color("#3a2f2a"); st.border_width_bottom = 1; st.shadow_color = Color(0, 0, 0, 0.45); st.shadow_size = 8
	var KS = load("res://ui/kit_skin.gd")
	if KS.ok():
		var dk = KS.dark(); dk.modulate_color = Color(0.55, 0.5, 0.5); top.add_theme_stylebox_override("panel", dk); top.set_meta("ks_done", true)
	else: top.add_theme_stylebox_override("panel", st)
	add_child(top)
	# 主公印
	var seal = Panel.new(); seal.position = Vector2(9, 22); seal.size = Vector2(58, 58); seal.rotation = deg_to_rad(-3); seal.pivot_offset = Vector2(29, 29)
	var ss = UIKit.sb(UIKit.CINNABAR, 6, Color("#f0c8b4"), 2); ss.shadow_color = Color("#5a120c"); ss.shadow_size = 0; ss.shadow_offset = Vector2(0, 2)
	seal.add_theme_stylebox_override("panel", ss); top.add_child(seal)
	if KS.ok():   # [uikit] 主公等級牌
		var pl = StyleBoxTexture.new(); pl.texture = KS.tex("lord_plaque"); seal.add_theme_stylebox_override("panel", pl); seal.rotation = 0.0
		seal.position = Vector2(4, 18); seal.size = Vector2(68, 66)
	var sm = UIKit.label("主公", 11, Color("#fbe6d6"), "serif", 700); sm.position = Vector2(0, 5); sm.size = Vector2(58, 14); sm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; seal.add_child(sm)
	lv_lbl = UIKit.label("1", 26, Color("#fbe6d6"), "serif", 900); lv_lbl.position = Vector2(0, 20); lv_lbl.size = Vector2(seal.size.x, 36); lv_lbl.add_theme_color_override("font_outline_color", Color(0.1, 0.02, 0.02)); lv_lbl.add_theme_constant_override("outline_size", 5); lv_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; seal.add_child(lv_lbl)
	# 好評條
	exp_bar = ColorRect.new(); exp_bar.color = Color("#3a2e26"); exp_bar.position = Vector2(76, 16); exp_bar.size = Vector2(200, 6); top.add_child(exp_bar)
	exp_fill = ColorRect.new(); exp_fill.color = Color("#b06a34"); exp_fill.size = Vector2(0, 6); exp_bar.add_child(exp_fill)
	if KS.ok():   # [uikit] 好評條：鐵槽＋金條（大小照舊）
		var tk = KS.tex("bar_track"); var fl = KS.tex("bar_fill")
		var tr0 = NinePatchRect.new(); tr0.texture = tk; tr0.patch_margin_left = 6; tr0.patch_margin_right = 6; tr0.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); tr0.offset_top = -3; tr0.offset_bottom = 3; tr0.mouse_filter = Control.MOUSE_FILTER_IGNORE
		exp_bar.color = Color(0, 0, 0, 0); exp_bar.add_child(tr0); exp_bar.move_child(tr0, 0)
		var f2 = NinePatchRect.new(); f2.texture = fl; f2.patch_margin_left = 4; f2.patch_margin_right = 4; f2.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); f2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		exp_fill.color = Color(0, 0, 0, 0); exp_fill.add_child(f2)
	exp_txt = UIKit.label("", 12, UIKit.DIM); exp_txt.anchor_left = 1; exp_txt.anchor_right = 1; exp_txt.offset_left = -162; exp_txt.offset_right = -54; exp_txt.offset_top = 10
	exp_txt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; top.add_child(exp_txt)
	# 資源格
	var grid = GridContainer.new(); grid.columns = 3; grid.add_theme_constant_override("h_separation", 4); grid.add_theme_constant_override("v_separation", 4)
	grid.anchor_right = 1; grid.offset_left = 76; grid.offset_top = 36; grid.offset_right = -9; grid.add_theme_constant_override("v_separation", 5); top.add_child(grid)
	# [settings] 頂欄右上：設置（原本嘅「聲／靜」開關搬入設置面板）
	var snd = UIKit.btn("設置", "", true); snd.name = "SetBtn"; snd.anchor_left = 1; snd.anchor_right = 1; snd.offset_left = -48; snd.offset_right = -9; snd.offset_top = 5; snd.offset_bottom = 31; snd.add_theme_font_size_override("font_size", 12)
	var gt = load("res://ui/title/title_view.gd").tex("ico_gear")
	if gt != null: snd.text = ""; snd.icon = gt; snd.expand_icon = true; snd.offset_left = -38; snd.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	snd.pressed.connect(func(): open_settings(false, true)); top.add_child(snd)
	var help = {"wood": "槐木：主公親手砍樹，或派鬼怪去[b]伐木場[/b]伐木。", "rice": "糯米：主公親手收割，或派鬼怪去[b]糯米田[/b]割稻。", "planks": "棺材板：在[b]棺材鋪[/b]把 2 槐木做成 1 板（力量高的鬼做得快）。藍箱也會開出。用來建造和升級建築。", "buns": "壽包：在[b]包子鋪[/b]把 2 糯米包成 1 個（智力高的鬼包得快）。綠箱也會開出。用來升級 Lv10 以上鬼怪、出擊口糧。（Lv10 前升級改用普通包子＋冥幣）", "coins": "冥幣：打關卡、開紫箱、賣貨。Toyol 管倉庫時也會「撿到」冥幣。", "troops": "陰兵：村裡的遊魂見你有地盤，自願加入。[b]民宅[/b]越高級來得越快、上限越高。"}   # [joss] 化寶爐唔再燒冥幣
	for k in ["wood", "rice", "planks", "buns", "coins", "troops"]:
		var cell = PanelContainer.new(); cell.custom_minimum_size = Vector2(0, 26); cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cs = StyleBoxFlat.new(); cs.bg_color = Color("#1f3c36"); cs.border_color = Color("#4f8076"); cs.set_border_width_all(1); cs.set_corner_radius_all(3)
		cs.content_margin_left = 3; cs.content_margin_right = 6
		cell.add_theme_stylebox_override("panel", cs)
		if KS.ok():   # [uikit] 頂欄資源格（左圓位放圖示）
			var rs = KS.box("res_slot", Vector4(5, 0, 8, 0)); rs.texture_margin_top = 0; rs.texture_margin_bottom = 0
			cell.add_theme_stylebox_override("panel", rs); cell.custom_minimum_size.y = 28
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 4); cell.add_child(hb)
		var ic = TextureRect.new(); ic.texture = load("res://ui/res_icon.gd").tex(k); ic.custom_minimum_size = Vector2(22, 22) if load("res://ui/res_icon.gd").is_art(k) else Vector2(18, 18); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hb.add_child(ic)
		var v = UIKit.label("0", 15, Color("#f4ecd4"), "sans", 700); v.size_flags_horizontal = Control.SIZE_EXPAND_FILL; v.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hb.add_child(v); res_lbl[k] = v; res_cell[k] = cs
		var key: String = k
		cell.gui_input.connect(func(e):
			if e is InputEventMouseButton and e.pressed:
				open_store(key, (MV_HELP[key] if mv_on() else help[key] + ("\n（建好民宅，遊魂才會來）" if key == "troops" and float(G.S.bld.home) == 0 else ""))))   # [ux] 撳資源格 → 倉庫總覽
		grid.add_child(cell)
	top.resized.connect(func(): exp_bar.size.x = top.size.x - 76 - 116)

const MV_HELP := {"wood": "槐木（一級）：村子[b]伐木場[/b]派鬼砍伐。棺材鋪用來做棺材板。", "rice": "糯米（一級）：村子[b]糯米田[/b]派鬼收割。包子鋪用來包普通包子。", "planks": "棺材板（二級）：村子[b]棺材鋪[/b]生產（2 槐木 → 1 板）。藍箱也會開出。用來升級建築，移動村部分台也要用。", "buns": "壽包（三級）：只由隨村台[b]嘆氣蒸籠[/b]用普通包子蒸成。綠箱也會開出。用來升級 Lv10 以上鬼怪、派宵夜、出擊口糧、賣錢。（Lv10 前升級和練嚇功改用普通包子＋冥幣）", "coins": "冥幣：大排檔賣貨收錢、打關卡、開紫箱。", "troops": "陰兵：村裡遊魂自願加入，[b]民宅[/b]越高級來得越快。按「出擊」時每 25 個編成一隊。"}   # [chain] [qaudit] [ux] 改中文、寫明壽包新用途

# [ux] 倉庫總覽（全部材料庫存、每分鐘進出、來源／用途、瓶頸）
func open_store(key := "", help_t := "") -> void:
	if get_node_or_null("StoreView") != null: return
	var v = load("res://game/econ/store_view.gd").new(); v.focus = key; v.help_txt = help_t; add_child(v)

# [ux] 頂欄資源有進出：喺嗰格冒「+n／−n」小字（每格最快 1.5 秒一次）
var _rf_t := 0.0
func _res_float(dt: float) -> void:
	_rf_t += dt
	if _rf_t < 1.5: return
	_rf_t = 0.0
	var SW = load("res://game/econ/stock_watch.gd")
	for k in ["wood", "rice", "planks", "buns", "coins", "troops"]:
		if not res_lbl.has(k) or not is_instance_valid(res_lbl[k]): continue
		var mid = {"wood": "m_wood", "rice": "m_rice", "planks": "m_plank", "buns": "m_shoubao"}.get(k, k)
		var d = SW.take_pending(mid, 1.0)
		if d == 0.0: continue
		var l = res_lbl[k]
		var f = UIKit.label(("+" if d > 0 else "−") + G.fmt(absf(round(d))), 13, Color("#7dff8a") if d > 0 else Color("#ff8a7a"), "sans", 900)
		f.add_theme_color_override("font_outline_color", Color(0.05, 0.02, 0.02)); f.add_theme_constant_override("outline_size", 4); f.mouse_filter = Control.MOUSE_FILTER_IGNORE
		f.top_level = true; f.z_index = 60; f.global_position = l.global_position + Vector2(l.size.x - 30.0, -4.0); add_child(f)
		var tw = f.create_tween(); tw.set_parallel(true)
		tw.tween_property(f, "global_position:y", f.global_position.y - 14.0, 1.2)
		tw.tween_property(f, "modulate:a", 0.0, 1.2).set_delay(0.3)
		tw.chain().tween_callback(f.queue_free)

func _build_nav() -> void:
	var nav = Panel.new(); nav.anchor_top = 1; nav.anchor_bottom = 1; nav.anchor_right = 1; nav.offset_top = -NAV_H
	var ns = StyleBoxFlat.new(); ns.bg_color = Color("#22150f"); ns.border_color = Color("#5a2e22"); ns.border_width_top = 2
	nav.add_theme_stylebox_override("panel", ns); add_child(nav)
	var KS = load("res://ui/kit_skin.gd")
	if KS.ok():   # [uikit] 底部導航底條
		var nb = KS.box("nav_bar", Vector4(0, 0, 0, 0)); nb.texture_margin_top = 0; nb.texture_margin_bottom = 0
		nav.add_theme_stylebox_override("panel", nb); nav.set_meta("ks_done", true)
	var hb = HBoxContainer.new(); hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.add_theme_constant_override("separation", 0); nav.add_child(hb)
	for it in [["village", "村子"], ["roster", "鬼怪"], ["battle", "地盤"], ["chest", "箱子"], ["story", "劇情"]]:
		var b = Button.new(); b.flat = true; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.focus_mode = Control.FOCUS_NONE
		var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_theme_constant_override("separation", 1); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ic = TextureRect.new(); ic.custom_minimum_size = Vector2(40, 36) if KS.ok() else Vector2(26, 26); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var lb = UIKit.label(it[1], 12, Color("#b8a08e"), "sans", 700); lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if KS.ok(): lb.add_theme_color_override("font_outline_color", Color(0.05, 0.02, 0.02)); lb.add_theme_constant_override("outline_size", 4); vb.add_theme_constant_override("separation", -4)   # [uikit] 字唔俾底條吃掉
		vb.add_child(ic); vb.add_child(lb); b.add_child(vb); hb.add_child(b)
		nav_btns[it[0]] = [b, ic, lb]
		var id: String = it[0]
		b.pressed.connect(func(): _nav(id))
		if id == "chest":
			chest_badge = UIKit.label("", 11, Color.WHITE, "sans", 900)
			var bs = UIKit.sb(UIKit.CINNABAR, 8, Color(0, 0, 0, 0), 0, Vector4(5, 0, 5, 0)); chest_badge.add_theme_stylebox_override("normal", bs)
			chest_badge.anchor_left = 0.5; chest_badge.anchor_right = 0.5; chest_badge.offset_left = 8; chest_badge.offset_top = 4; b.add_child(chest_badge)
	_nav_on("village")

func _nav_on(t: String) -> void:
	tab = t
	if mv_view != null and mv_on():
		if t == "village": mv_view.on_show()
		else: mv_view.on_hide()
	_qx_btn_vis()
	for k in nav_btns:
		var on: bool = k == t
		var KS = load("res://ui/kit_skin.gd")
		var kn = {"village": "village", "roster": "ghost", "battle": "map", "chest": "chest", "story": "book"}.get(k, "")
		var kt = KS.tex("nav_%s%s" % [kn, "_on" if on else ""]) if KS.ok() and kn != "" else null   # [uikit] 導航圖示
		nav_btns[k][1].texture = kt if kt != null else load("res://assets/ui/n-%s%s.svg" % [k, "_on" if on else ("_main" if k == "battle" else "")])
		nav_btns[k][2].add_theme_color_override("font_color", UIKit.GOLD2 if on else (Color("#f0c8a0") if k == "battle" else Color("#b8a08e")))
	_ob_nav_gray()
	var jui = J.G.get("UI")
	if jui is Dictionary: jui["tab"] = t

func _nav(t: String) -> void:
	var ui = J.G.get("UI")
	var lk = OBm().tab_lock(t)   # [onboard] 新手階段：未開放嘅分頁講「XX 之後開放」
	if lk != "": show_toast(lk); return
	if t == "battle" and load("res://game/outpost/ctl_ui.gd").nav_battle(self): return   # [ctl] 「地盤」掣：灰色，之後開放
	if t == "battle" and ZDm.on(): J.mc(J.G.get("UI"), "close", []); _go_out(); return   # [outgate] 新版：唔開舊世界地圖，鏡頭去出村門外
	if t == "battle": J.mc(J.G.get("UI"), "close", []); J.mc(J.G.get("World"), "open", []); return
	J.mc(ui, "open", [t])

# [onboard] 鎖住嘅分頁：圖示同字變淡
func _ob_nav_gray() -> void:
	for k in nav_btns:
		var b = nav_btns[k][0]
		if is_instance_valid(b): b.modulate.a = 0.42 if OBm().tab_lock(k) != "" else 1.0

# [outgate] 新版出村：舊世界地圖（夜班巡陰、冥街夜市、陰陽交界…）暫時唔開；「地盤」掣同主線關卡任務都帶鏡頭去出村門外
func _cam_to(p: Vector2) -> void:
	if village == null or not village.has_method("zone_cam"): return
	var cam = village.zone_cam()
	if cam != null: cam.center_on(p)
# 主線關卡任務：鏡頭去迎戰位／野外王；回 true＝處理咗
func _stage_focus(toast_if_none := true) -> bool:
	var tg = ZDm.stage_target()
	if tg.is_empty(): return false
	close_sheet(); _nav_on("village")
	if tg.has("pos"): _cam_to(tg.pos); return true
	if tg.has("zid"):
		var z = ZDm.zone(str(tg.zid))
		_cam_to(ZDm.v2(z.get("boss_at", [0, 0])) if z.get("boss_at") != null else ZDm.zrect(str(tg.zid)).get_center())
		return true
	if J.t(tg.get("locked")): show_toast(ZDm.reveal_hint("market")); return true
	if J.t(tg.get("later")) and toast_if_none: show_toast(ZDm.L("呢一關喺下一站：先解放呢度，再拔營過去", "這一關在下一站：先解放這裡，再拔營過去")); return true
	return false
func _go_out() -> void:
	_nav_on("village")
	if _stage_focus(false): return
	if not ZDm.revealed("market"): show_toast(ZDm.reveal_hint("market")); _cam_to(ZDm.v2(ZDm.cur().get("village", {}).get("POS", {}).get("gate", [0, 0]))); return
	_cam_to(ZDm.zrect("market").get_center())

func _build_sheet() -> void:
	sheet = Panel.new(); sheet.anchor_right = 1; sheet.anchor_top = 0.16; sheet.anchor_bottom = 1; sheet.visible = false
	var s = UIKit.sb(UIKit.PAPER); s.shadow_color = Color(0, 0, 0, 0.65); s.shadow_size = 24
	sheet.add_theme_stylebox_override("panel", s); add_child(sheet)
	var head = HBoxContainer.new(); head.anchor_right = 1; head.offset_left = 16; head.offset_right = -12; head.offset_top = 10; head.offset_bottom = 50
	sheet.add_child(head)
	sheet_title = UIKit.label("", 22, UIKit.INKTXT, "serif", 900); sheet_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL; head.add_child(sheet_title)
	var cl = UIKit.btn("✕", "ghost", true); cl.custom_minimum_size = Vector2(34, 34); cl.pressed.connect(func(): close_sheet(); _nav_on("village")); head.add_child(cl)
	var line = ColorRect.new(); line.color = UIKit.PAPERLINE; line.anchor_right = 1; line.offset_top = 54; line.offset_bottom = 55.5; sheet.add_child(line)
	sheet_scroll = ScrollContainer.new(); sheet_scroll.anchor_right = 1; sheet_scroll.anchor_bottom = 1; sheet_scroll.offset_top = 58; sheet_scroll.offset_left = 14; sheet_scroll.offset_right = -14; sheet_scroll.offset_bottom = -10
	sheet_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sheet.add_child(sheet_scroll)
	load("res://ui/drag_scroll.gd").attach(sheet_scroll)   # [p55] 拖過門檻就當捲動（唔畀卡／掣食咗）＋慣性
	sheet_body = VBoxContainer.new(); sheet_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sheet_body.add_theme_constant_override("separation", 6)
	sheet_scroll.add_child(sheet_body)

func _build_fx() -> void:
	praise_box = PanelContainer.new(); praise_box.add_theme_stylebox_override("panel", UIKit.sb(Color(0.055, 0.125, 0.118, 0.92), 4, Color("#5fbfaa"), 1, Vector4(10, 6, 10, 6)))
	praise_box.anchor_right = 1; praise_box.offset_left = 14; praise_box.offset_right = -14; praise_box.offset_top = TOP_H + 56; praise_box.modulate.a = 0; praise_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	praise_lbl = UIKit.label("", 15, Color("#d4fff2")); praise_lbl.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; praise_box.add_child(praise_lbl); add_child(praise_box)
	toasts = VBoxContainer.new(); toasts.anchor_top = 1; toasts.anchor_bottom = 1; toasts.anchor_right = 1; toasts.offset_left = 12; toasts.offset_right = -12; toasts.offset_bottom = -86; toasts.grow_vertical = Control.GROW_DIRECTION_BEGIN
	toasts.alignment = BoxContainer.ALIGNMENT_END; toasts.add_theme_constant_override("separation", 6); toasts.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tcl = CanvasLayer.new(); tcl.layer = 105; tcl.name = "ToastLayer"; add_child(tcl); tcl.add_child(toasts)   # [uilayer] 提示字永遠喺面板上面（台面板喺 100 層）
	banner = PanelContainer.new(); banner.add_theme_stylebox_override("panel", UIKit.sb(UIKit.CINNABAR, 3, Color("#f0c8b4"), 2, Vector4(30, 12, 30, 12)))
	banner.anchor_left = 0.5; banner.anchor_right = 0.5; banner.anchor_top = 0.32; banner.anchor_bottom = 0.32; banner.grow_horizontal = Control.GROW_DIRECTION_BOTH; banner.grow_vertical = Control.GROW_DIRECTION_BOTH
	banner.modulate.a = 0; banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner_lbl = UIKit.label("", 22, Color("#fff3e0"), "serif", 900); banner.add_child(banner_lbl); add_child(banner)

# ---------------- 刷新 ----------------
func refresh() -> void:
	if G.S.is_empty(): return
	var S = G.S
	lv_lbl.text = str(int(S.lv))
	var need = G.expNeed(S.lv)
	exp_fill.size.x = exp_bar.size.x * (1.0 if S.lv >= 20 else minf(1, float(S.exp) / need))
	exp_txt.text = "好評 MAX" if S.lv >= 20 else "好評 %s/%s" % [G.fmt(S.exp), G.fmt(need)]
	var cap = G.cap()
	for k in ["wood", "rice", "planks", "buns"]:
		res_lbl[k].text = G.fmt(S.res[k])
		res_lbl[k].add_theme_color_override("font_color", Color("#ffb46a") if float(S.res[k]) >= cap - 0.5 else Color("#f4ecd4"))
	res_lbl.coins.text = G.fmt(S.res.coins); res_lbl.troops.text = G.fmt(S.res.troops)
	var q = G.quest_cur()
	if q:
		var p = G.quest_progress(q)
		var a = minf(float(p[0]), float(p[1]))
		if mv_on(): p = MVB.quest_disp(q, p); a = minf(float(p[0]), float(p[1]))
		quest_lbl.text = ((_unify_qtext(MVB.quest_text(q)) if UNIFY else MVB.quest_text(q)) if mv_on() else q.text) + load("res://game/onboard/need.gd").quest_short(q); quest_prog.text = "%d/%d" % [int(a), int(p[1])]
		quest_prog.add_theme_color_override("font_color", Color("#2e6d3a") if float(p[0]) >= float(p[1]) else UIKit.CINNABAR2)
	else: quest_lbl.text = "第一季完。村子由你慢慢經營。" if S.ended else "—"; quest_prog.text = ""
	_ob_nav_gray()
	_mv_tick()
	CBLD.install()   # [village] 後院拓展建築：包裝村子／建築卡／產出（已裝就即刻返）
	var ch = int(S.chests.g) + int(S.chests.b) + int(S.chests.p)
	chest_badge.text = str(ch) if ch else ""; chest_badge.visible = ch > 0
	if sheet.visible and sheet_refresh.is_valid(): sheet_refresh.call()

# ---------------- 移動村 ----------------
func mv_on() -> bool: return G.S is Dictionary and not G.S.is_empty() and J.t(G.S.get("mv_on"))

# 按 S.mv_on 決定 home 分頁用邊個畫面（開機、切換開關、匯入存檔後叫）
func _mv_apply() -> void:
	if UNIFY: _unify_apply(); return   # [unify]
	var on = mv_on()
	if on and mv_view == null:
		var path = MV_SCENE if ResourceLoader.exists(MV_SCENE) else MV_STUB
		mv_view = Control.new(); mv_view.set_script(load(path)); mv_view.name = "MvScene"
		mv_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		mv_host.add_child(mv_view)
		mv_view.setup(self)
		mv_host.add_child(mv_back)
		MVB.set_scene(mv_view)
		print("[mv] scene ", path)
	if mv_view != null: mv_view.on_hide()   # 先還原場景收埋過嘅嘢，再按開關設定（否則還原會蓋過）
	mv_host.visible = on
	village.visible = not on
	village.process_mode = Node.PROCESS_MODE_INHERIT
	quest_bar.visible = true
	if mv_view != null and on and tab == "village": mv_view.on_show()
	_qx_btn_vis()

# [unify] 任務字：原村子建築已經返晒原位，唔再講「營地」
func _unify_qtext(s: String) -> String:
	return s.trim_prefix("營地：").replace("營地或者生產台", "村子或者大排檔")

# [unify] 合一地圖：村子分頁頂段嵌入大排檔區（原村子位置全部唔變）；mv_on 一律開（生產鏈／戰鬥／橋接層都靠佢）
func _unify_apply() -> void:
	var s0 = J.G.get("S")
	if s0 is Dictionary and not s0.is_empty() and not J.t(s0.get("mv_on")): MVB.migrate(); s0["mv_on"] = true   # 舊存檔：一律開合一
	if mv_embed == null:
		mv_embed = load("res://game/outpost/mv_embed.gd").attach(self, village)
		mv_view = mv_embed.sc
		MVB.set_scene(mv_view)
		print("[mv] unified embed")
	mv_host.visible = false
	village.visible = true; village.process_mode = Node.PROCESS_MODE_INHERIT
	quest_bar.visible = true
	if tab == "village": mv_view.on_show()
	else: mv_view.on_hide()
	_qx_btn_vis()

# 移動村畫面有自己嘅目標條，右下角「任務」浮動掣會遮住升級條：喺移動村分頁收埋
func _qx_btn_vis() -> void:
	var q = get_node_or_null("/root/QX")
	if q == null or not ("btn" in q) or q.btn == null or not is_instance_valid(q.btn): return
	q.btn.visible = UNIFY or not (mv_view != null and mv_on() and tab == "village")   # [unify] 合一地圖：原村子照舊有任務掣

func set_mv(on: bool) -> void:
	if G.S.is_empty(): return
	G.S["mv_on"] = on
	if on: MVB.migrate()
	MVB.sync(); _mv_apply(); G.save(); refresh()

func _mv_tick() -> void:
	if not mv_on(): return
	MVW.poll()   # [war]
	ZDm.poll(); ZVm.eat_news(self)   # [zone] 攻佔／野外王戰鬥結果
	RAID.tick(self)   # [raid]
	MVB.tick()
	# 舊存檔第一次入嚟：簡短介紹（等標題、手機、劇情、自檢都完先彈）
	if MVB.intro_pending() and title_ov == null and phone == null and loading == null and selftest == null:
		var st = J.G.get("Story")
		if st is Dictionary and not J.t(J.mc(st, "busy", [])):
			G.S["mv_intro"] = 2.0
			J.mc(st, "queue", [{"style": "sys", "lines": MVB.intro_lines()}])
			G.save()
	_gift_tick()   # [gift]

# [gift] 測試大禮包：存檔碼帶 S.gift（唔放入 res，否則開場會被當成「已完成」略過）；
# 開場睇完（已改名、開場劇情完）先一次過派：res／mat（唔受倉庫上限）／chests，派完刪走 S.gift。
func _gift_tick() -> void:
	var g = G.S.get("gift")
	if not (g is Dictionary): return
	if title_ov != null or phone != null or loading != null or selftest != null: return
	if not NameCardGD.hero_set(G.S) or NameCardGD.opening_unfinished(G.S): return
	var st = J.G.get("Story")
	if st is Dictionary and J.t(J.mc(st, "busy", [])): return
	var MATm = load("res://game/outpost/mat.gd")
	var r = g.get("res", {})
	if r is Dictionary:
		for k in r: G.S.res[k] = J.num(G.S.res.get(k, 0)) + J.num(r[k])
	var m = g.get("mat", {})
	if m is Dictionary:
		var store = MATm._store(G.S)
		for k in m: store[k] = J.num(store.get(k, 0)) + J.num(m[k])
	var c = g.get("chests", {})
	if c is Dictionary:
		if not (G.S.get("chests") is Dictionary): G.S["chests"] = {"g": 0, "b": 0, "p": 0}
		for k in c: G.S.chests[k] = J.num(G.S.chests.get(k, 0)) + J.num(c[k])
	if g.get("soul") is Dictionary: load("res://game/soul/soul_data.gd").gift(g.soul)   # [soul] 送魂魄／散魂
	G.S.erase("gift"); G.save(); refresh()
	show_toast(str(g.get("msg", "收到測試大禮包！")))

# 後院：舊村子建築（招魂台、化寶爐、鬼宅鬼節宴、嚇人訓練班、倉庫…）照用得；等級由移動村進度帶動（只升唔跌），亦可以照舊用棺材板升
func open_backyard() -> void:
	open_sheet("後院（舊村子設施）", func(): pass); _clear_body()
	_p("原本條村嘅建築已經搬咗入大地圖底嘅「營地」（紙紮大屋後面，拔營一齊抬走），喺大地圖直接撳就用得；呢度係清單捷徑。佢哋嘅等級會跟住移動村進度自動升（只升唔跌），亦可以照舊用棺材板同冥幣升。" if DB.lang == "yue" else "原本村子的建築已經搬進大地圖底部的「營地」（紙紮大屋後面，拔營一起搬走），在大地圖直接點就能用；這裡是清單捷徑。它們的等級會跟著移動村進度自動升（只升不降），也可以照舊用棺材板和冥幣升級。")   # [camp]
	var S = G.S; var D = DB.D
	for id in D.BLD_ORDER:
		var lv = int(S.bld.get(id, 0)); var bid: String = id
		var b = _act(UIKit.btn("打開", "", true), func(): open_building(bid), lv > 0 or G.bldUnlocked(bid))
		var jn = load("res://game/joss/joss.gd").count() if id == "furnace" and lv > 0 else 0   # [joss]
		_row("[b]%s[/b]　%s" % [D.BUILDINGS[id].name, ("Lv %d" % lv) if lv > 0 else "未有"] + ("　[color=#9c2219]有 %d 件陽間包裹[/color]" % jn if jn > 0 else ""), [b])   # [joss]
	CBLD.backyard_ui(self)   # [village] 後院拓展建築列表＋入後院睇
	var sw = UIKit.btn("暫時用返舊村子畫面", "ghost"); sheet_body.add_child(sw)
	sw.pressed.connect(func(): close_sheet(); set_mv(false); show_toast("已轉返舊村子畫面。喺「劇情」頁可以轉返移動村。"))

# ---------------- 提示 ----------------
# [uxui] 模態佇列：劇情（同名字卡、插圖）播緊 → 提示、橫幅、誇獎全部排隊；全螢幕面板／設置開住 → 橫幅、誇獎排隊（提示照出，係撳掣嘅即時回應）
var _mq: Array = []
var _mq_t := 0.0
func story_modal() -> bool:
	if story != null and is_instance_valid(story) and (story.visible or story.busy()): return true
	var nc = get_node_or_null("NameCard")
	return nc != null and nc.visible
func panel_modal() -> bool:
	if title_ov != null: return true
	if sheet != null and sheet.visible: return true
	if get_node_or_null("SettingsPanel") != null: return true
	var mv = get("mv_view")
	if mv != null and is_instance_valid(mv) and mv.get("ui_cl") != null and mv.ui_cl.visible: return true
	return false
func _mq_blocked(kind: String) -> bool:
	if story_modal(): return true
	return kind != "toast" and panel_modal()
func _mq_tick(dt: float) -> void:
	if _mq.is_empty(): return
	_mq_t -= dt
	if _mq_t > 0.0: return
	for i in _mq.size():
		var it = _mq[i]
		if _mq_blocked(it[0]): continue
		_mq.remove_at(i); _mq_t = 0.7
		match it[0]:
			"toast": show_toast(it[1])
			"banner": show_banner(it[1])
			"praise": show_praise(it[1])
		return
func show_toast(bb: String) -> void:
	if _mq_blocked("toast"):
		if _mq.size() < 12: _mq.append(["toast", bb])
		return
	while toasts.get_child_count() >= 3: toasts.get_child(0).free()
	var p = PanelContainer.new()
	var s = StyleBoxFlat.new(); s.bg_color = Color("#241b17"); s.border_color = UIKit.CINNABAR; s.border_width_left = 5; s.set_corner_radius_all(2)
	s.content_margin_left = 12; s.content_margin_right = 12; s.content_margin_top = 9; s.content_margin_bottom = 9; s.shadow_color = Color(0, 0, 0, 0.5); s.shadow_size = 8
	p.add_theme_stylebox_override("panel", s); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var r = UIKit.rich(bb, 14, Color("#f0e2c8")); r.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(r)
	toasts.add_child(p)
	var tw = create_tween(); tw.tween_interval(2.6); tw.tween_property(p, "modulate:a", 0.0, 0.6); tw.tween_callback(p.queue_free)

func show_banner(text: String) -> void:
	if _mq_blocked("banner"):
		if _mq.size() < 12: _mq.append(["banner", text])
		return
	banner_lbl.text = text
	banner.modulate.a = 0; banner.scale = Vector2(0.85, 0.85)
	await get_tree().process_frame
	banner.pivot_offset = banner.size / 2
	var tw = create_tween(); tw.tween_property(banner, "modulate:a", 1.0, 0.18); tw.parallel().tween_property(banner, "scale", Vector2.ONE, 0.18)
	tw.tween_interval(1.4); tw.tween_property(banner, "modulate:a", 0.0, 0.4)

func show_praise(kind: String) -> void:
	if _mq_blocked("praise"):
		if _mq.size() < 12: _mq.append(["praise", kind])
		return
	var D = DB.D
	var pool: Array = D.PRAISE_KIND if G.S.ended else (D.PRAISE_CHOP if kind == "chop" else (D.PRAISE_RICE if kind == "rice" else D.PRAISE_CRAFT))
	var i = randi() % pool.size()
	while pool.size() > 1 and i == last_praise.get(kind, -1): i = randi() % pool.size()
	last_praise[kind] = i
	praise_lbl.text = "【KPI】" + DB.L(pool[i])
	praise_box.modulate.a = 0
	var tw = create_tween(); tw.tween_property(praise_box, "modulate:a", 1.0, 0.2); tw.tween_interval(2.2); tw.tween_property(praise_box, "modulate:a", 0.0, 0.4)
	if G.S.lv >= 3 and randf() < 0.04: G.S.chests.g = int(G.S.chests.g) + 1; show_toast("系統太滿意了，掉落一個[b]綠箱[/b]！")

# ---------------- 面板 ----------------
func open_sheet(title: String, refresher := Callable()) -> void:
	sheet.visible = true; sheet_title.text = title; sheet_refresh = refresher
	for c in sheet_body.get_children(): c.queue_free()

func close_sheet() -> void:
	sheet.visible = false; sheet_refresh = Callable()

func _clear_body() -> void:
	for c in sheet_body.get_children(): sheet_body.remove_child(c); c.queue_free()

func _p(bb: String, size := 14, col := UIKit.INKDIM, kind := "sans") -> RichTextLabel:
	var r = UIKit.rich(bb, size, col, kind); sheet_body.add_child(r); return r

func _row(text_bb: String, buttons: Array) -> HBoxContainer:
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
	var r = UIKit.rich(text_bb, 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
	var bx = HBoxContainer.new(); bx.add_theme_constant_override("separation", 4)
	for b in buttons: bx.add_child(b)
	hb.add_child(bx); sheet_body.add_child(hb); sheet_body.add_child(UIKit.hsep())
	return hb

func _act(b: Button, f: Callable, enabled := true) -> Button:
	b.disabled = not enabled; b.pressed.connect(f); return b

# --- 建築 ---
func open_building(id: String) -> void:
	var render = func() -> void: _render_building(id)
	open_sheet(DB.D.BUILDINGS[id].name, func(): pass)
	_render_building(id)

func _render_building(id: String) -> void:
	_clear_body()
	var S = G.S; var D = DB.D; var b: Dictionary = D.BUILDINGS[id]; var lv = int(S.bld.get(id, 0))
	_p(str(D.FLAVOR.get(id, "")), 14.5, UIKit.INKTXT, "serif"); sheet_body.add_child(UIKit.hsep())
	_p(b.desc, 14)
	var re = func(): G.save(); refresh(); _render_building(id)
	if lv == 0:
		if not G.bldUnlocked(id): _p("[color=#c2362b]尚未解鎖。[/color]")
		else: _row("建造費用：" + G.costText(b.build), [_act(UIKit.btn("建造", "gold"), func():
			G.pay(b.build); S.bld[id] = 1; G.gainExp(15); show_banner("%s 建好了！" % b.name); G.quest_check(); re.call(), G.canPay(b.build))])
		return
	_p("等級 [b]Lv %d[/b]%s" % [lv, "" if id == "house" else "（上限 = 鬼宅等級 %d）" % int(S.bld.house)], 15, UIKit.INKTXT)
	var eff = _bld_effect(id)
	if eff != "": _p(eff, 13.5, Color("#2e5d55"))
	if lv < G.bldMax(id):
		var c = G.upCost(id, lv); var bd = G.builderDiscount()
		_row("升級：" + G.costText(c) + ("\n[font_size=12]工頭省了 %d%% 棺材板[/font_size]" % int(round(bd * 100)) if bd else ""), [_act(UIKit.btn("升級", "gold"), func():
			var c2 = G.upCost(id, int(S.bld[id])); G.pay(c2); S.bld[id] = int(S.bld[id]) + 1; G.gainExp(10 + 8 * int(S.bld[id])); show_banner("%s 升到 Lv %d" % [b.name, int(S.bld[id])]); G.quest_check(); re.call(), G.canPay(c))])
	else: _p("已達最高等級。" if id == "house" else "已達上限，先升級鬼宅。")
	if id == "plank" or id == "bun":
		var src = "wood" if id == "plank" else "rice"; var can = int(floor(float(S.res[src]) / 4))
		var bs = []
		for n in [1, 5, 10]:
			var nn: int = n
			bs.append(_act(UIKit.btn("做%d份" % n if n == 1 else "一次做%d份" % n, "", true), func(): close_sheet(); _nav_on("village"); J.mc(J.G.get("Village"), "craft", [id, nn]), can >= 1))
		_row("親手做：每份 4 %s　好評 +1\n[font_size=12]現有%s %s，夠做 %s 份[/font_size]" % ["槐木 → 2 棺材板" if id == "plank" else "糯米 → 2 壽包", D.RES_NAMES[src], G.fmt(S.res[src]), G.fmt(can)], bs)
	if id == "furnace": load("res://game/joss/joss_ui.gd").panel(sheet_body, func(): _render_building(id))   # [joss] 陽間包裹
	if id == "altar":
		var rc = G.recruitCost()
		_row("招魂一次：%s\n[font_size=12]雜鬼名額 %d/%d（升級民宅增加；收服的名鬼不佔名額）[/font_size]" % [G.costText(rc), G.fodderCount(), G.rosterCap()], [_act(UIKit.btn("招魂", "gold"), func():
			G.pay(rc); var g = G.recruitFodder(false); S.cnt.recruit = int(S.cnt.recruit) + 1; show_toast("招來了 [b]%s[/b]（%s）" % [g.name, g.q]); G.quest_check(); re.call(), G.canPay(rc) and G.fodderCount() < G.rosterCap())])
	if id == "house" and S.lv >= 12:
		var iq = 0
		for g in S.ghosts: iq += G.stat(g, 1)
		var left2 = maxf(0, G.feastCD - (G.now_ms() - float(S.feastAt)) * G.TIME_SCALE / 1000)
		_row("鬼節宴：壽包 300\n[font_size=12]全村智力總和 %d/%d%s[/font_size]" % [iq, G.feastNeed, ("　冷卻 %d 分" % int(ceil(left2 / 60))) if left2 > 0 else ""], [_act(UIKit.btn("擺宴", "gold"), func():
			S.res.buns = float(S.res.buns) - 300; S.feastAt = G.now_ms(); S.cnt.feast = int(S.cnt.feast) + 1; G.gainExp(150)
			if G.fodderCount() < G.rosterCap(): var g2 = G.recruitFodder(true); show_toast("鬼節宴請來了稀客 [b]%s[/b]（紫）！好評 +150" % g2.name)
			else: S.chests.p = int(S.chests.p) + 1; show_toast("鬼節宴賓客滿座，可惜村裡住不下了。客人留下一個[b]紫箱[/b]就走了。好評 +150")
			G.quest_check(); re.call(), float(S.res.buns) >= 300 and iq >= G.feastNeed and left2 <= 0)])
	for post in b.posts: _post_ui(post, id)

func _bld_effect(id: String) -> String:
	var ce = CBLD.old_effect(id, false)   # [village] 舊建築卡顯示新材料名
	if ce != "": return ce
	var r = G.ratesPerMin(); var S = G.S
	match id:
		"house": return "其他建築最高可升到 Lv %d" % int(S.bld.house)
		"wood": return "每崗產量 ×%.1f　崗位 %d　目前 槐木 +%.1f/分" % [G.mult("wood"), G.slots("wood"), r.wood]
		"rice": return "每崗產量 ×%.1f　崗位 %d　目前 糯米 +%.1f/分" % [G.mult("rice"), G.slots("rice"), r.rice]
		"plank": return "崗位 %d　目前 棺材板 +%.1f/分（耗槐木 %.1f/分）\n藍箱可開出 棺材板 %s" % [G.slots("plank"), r.planks, r.woodUse, G.fmt(G.chestGain("b").planks)]
		"bun": return "崗位 %d　目前 壽包 +%.1f/分（耗糯米 %.1f/分）\n綠箱可開出 壽包 %s" % [G.slots("bun"), r.buns, r.riceUse, G.fmt(G.chestGain("g").buns)]
		"store": return "槐木、糯米、棺材板、壽包 存放上限：%s" % G.fmt(G.cap())
		"home": return "雜鬼名額 %d　遊魂自願當陰兵 +%.1f/分　陰兵上限 %s" % [G.rosterCap(), r.troops, G.fmt(G.troopCap())]
		"camp": return "練習速度 ×%.1f　崗位 %d　耗普通包子 %.1f/分\n嚇功越高：回陽間招式更嚇人、更省陰氣；戰鬥嚇法更痛。" % [G.mult("camp"), G.slots("camp"), r.bunUse]
	return ""

func _post_ui(post: String, back: String) -> void:
	var P: Dictionary = DB.D.POSTS[post]; var n = G.slots(post)
	if n == 0: return
	var head = UIKit.rich("[b]%s崗位[/b] [font_size=12]%s[/font_size]" % [P.name, P.desc], 15, UIKit.INKTXT, "serif"); sheet_body.add_child(head)
	if G.S.lv < 4: _p("[color=#c2362b]升到 4 級【略懂管理學】後可派鬼怪打工。[/color]"); return
	var ws = G.workersAt(post)
	for i in n:
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9)
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55), 3, UIKit.PAPERLINE, 1, Vector4(8, 5, 8, 5)))
		pc.add_child(hb); sheet_body.add_child(pc)
		if i < ws.size():
			var g: Dictionary = ws[i]
			hb.add_child(UIKit.portrait(g.k, 44))
			var info = UIKit.rich("[b]%s[/b]\n[font_size=12]Lv%d　%s[/font_size]" % [g.name, G.glv(g), _post_stat(g, post)], 14.5, UIKit.INKTXT); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
			hb.add_child(_act(UIKit.btn("撤下", "", true), func(): g.post = null; G.save(); refresh(); _render_building(back)))
		else:
			var e = UIKit.label("空崗位", 14.5, UIKit.INKDIM); e.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(e)
			hb.add_child(_act(UIKit.btn("派人", "", true), func(): pick_worker(post, back)))

func _post_stat(g: Dictionary, post: String) -> String:
	var s = int(DB.D.POSTS[post].stat)
	return "%s %d" % [DB.D.STAT_NAMES[s], G.stat(g, s)] if s >= 0 else "等級 %d" % G.glv(g)

func pick_worker(post: String, back: String) -> void:
	var D = DB.D; var s = int(D.POSTS[post].stat)
	var val = func(g): return G.stat(g, s) if s >= 0 else G.glv(g)
	var fbd = func(g): return 1 if D.GHOSTS.has(g.k) and (D.GHOSTS[g.k].get("forbid", []) as Array).has(post) else 0
	var list = G.S.ghosts.filter(func(g): return g.k != "afu" and g.get("post") != post)
	list.sort_custom(func(a, b):
		if fbd.call(a) != fbd.call(b): return fbd.call(a) < fbd.call(b)
		if val.call(a) != val.call(b): return val.call(a) > val.call(b)
		return G.glv(a) > G.glv(b))
	open_sheet("派人：" + D.POSTS[post].name)
	_clear_body()
	_p("挑一位去「%s」。%s已在別處打工的，會被調過來。" % [D.POSTS[post].name, ("這份工看【%s】。" % D.STAT_NAMES[s]) if s >= 0 else "這份工看等級。"])
	for g in list:
		var fb: bool = fbd.call(g) == 1
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55 if not fb else 0.25), 3, UIKit.PAPERLINE, 1, Vector4(8, 6, 8, 6)))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 9); pc.add_child(hb)
		hb.add_child(UIKit.portrait(g.k, 48))
		var others = []
		for i in 3:
			if i != s: others.append("%s%d" % [D.STAT_NAMES[i], G.stat(g, i)])
		var where: String = ("目前：" + D.POSTS[g.post].name) if g.get("post") != null and D.POSTS.has(g.post) else "閒著"
		var info = UIKit.rich("[b]%s[/b] [color=#9c2219]%s[/color]\n[font_size=12][b]%s %d[/b]　%s%s[/font_size]\n[font_size=12]%s%s[/font_size]" % [g.name, g.q, D.STAT_NAMES[s] if s >= 0 else "等級", val.call(g), ("Lv%d　" % G.glv(g)) if s >= 0 else "", " ".join(others), where, "　[color=#c2362b]怕糯米，不肯去[/color]" if fb else ""], 14, UIKit.INKTXT)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)
		if not fb:
			var b = UIKit.btn("派", "gold", true); hb.add_child(b)
			b.pressed.connect(func():
				if G.workersAt(post).size() >= G.slots(post): G.workersAt(post)[0].post = null
				g.post = post; load("res://game/barracks/bk_data.gd").after_post(g)   # [xzfollow] 名鬼一職：同 n_pick_do 一樣，派工即刻由出陣隊移走（以前留喺隊，之後一調隊就無聲咁清走崗位）
				G.quest_check(); G.save(); refresh(); open_building(back))
		sheet_body.add_child(pc)
	if list.is_empty(): _p("沒有可以派的鬼怪。")
	var bk = UIKit.btn("返回"); bk.pressed.connect(func(): open_building(back)); sheet_body.add_child(bk)

# --- 鬼怪名冊 ---
func open_roster() -> void:
	open_sheet("鬼怪名冊"); _render_roster(); _nav_on("roster")

func _render_roster() -> void:
	_clear_body()
	var S = G.S; var D = DB.D
	_p("升級鬼怪：Lv10 前冥幣＋普通包子，Lv10 起壽包＋冥幣。等級上限 %d。雜鬼名額 %d/%d　壽包 %s" % [G.ghostCap(), G.fodderCount(), G.rosterCap(), G.fmt(S.res.buns)])
	var order: Array = S.ghosts.duplicate()
	order.sort_custom(func(a, b):
		if a.k == "afu": return true
		if b.k == "afu": return false
		var qa = 0 if a.q == "名" else 1; var qb = 0 if b.q == "名" else 1
		if qa != qb: return qa < qb
		return G.glv(a) > G.glv(b))
	for g in order:
		var lv = G.glv(g); var cost = G.lvCost(lv); var d = G.gdef(g); var sk: Dictionary = D.SKILLS.get(g.k, {"name": "", "desc": ""})
		var tag = "出陣" if (S.team as Array).has(g.id) else ("軍師" if S.adviser == g.id else "")
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55), 3, UIKit.PAPERLINE, 1, Vector4(9, 8, 9, 8)))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); pc.add_child(hb)
		hb.add_child(UIKit.portrait(g.k, 60))
		var gd: Dictionary = D.GHOSTS.get(g.k, {})
		var txt = "[b]%s[/b] [color=#9c2219]%s[/color] [b]Lv%d[/b] %s\n[font_size=12]%s力 %d　智 %d　武 %d　%s[/font_size]\n[font_size=12][color=#2e5d55]【%s】%s[/color][/font_size]" % [DB.N(g.name), g.q, lv, ("[bgcolor=#c2362b][color=#fff] %s [/color][/bgcolor]" % tag) if tag else "", (DB.N(gd.title) + "　") if gd.has("title") else "", G.stat(g, 0), G.stat(g, 1), G.stat(g, 2), "遠程" if d.get("range") == "ranged" else "近戰", sk.name, sk.desc]
		if gd.has("trait"): txt += "\n[font_size=12][color=#6e5838]%s[/color][/font_size]" % DB.L(gd.trait)
		txt += "\n[font_size=12]%s[/font_size]" % (("打工：" + D.POSTS[g.post].name) if g.get("post") != null and D.POSTS.has(g.post) else ("主公本人" if g.k == "afu" else "閒著"))
		var info = UIKit.rich(DB.N(txt), 14, UIKit.INKTXT); info.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(info)   # [femfix] 女主：名、稱號（過勞死學霸）照改
		var act = VBoxContainer.new(); hb.add_child(act)
		if g.k == "afu": act.add_child(UIKit.label("隨主公\n等級成長", 11, UIKit.INKDIM))
		elif lv < G.ghostCap():
			var NG = load("res://native/game.gd"); var pp = NG.lv_pay(float(lv))   # [ux] 前期冥幣＋普通包子，Lv10 起壽包
			act.add_child(_act(UIKit.btn("升級\n" + NG.pay_plain(pp).replace("＋", "\n"), "gold", true), func():
				var c = G.lvCost(int(g.lv)); var p2 = NG.lv_pay(float(g.lv))
				if not NG.can_pay(p2): return
				NG.pay(p2); g.spent = float(g.spent) + c; g.lv = int(g.lv) + 1; G.gainExp(2); G.quest_check(); G.save(); refresh(); _render_roster(), NG.can_pay(pp)))
		else: act.add_child(UIKit.label("已達上限", 11, UIKit.INKDIM))
		if g.q != "名" and g.q != "主":
			var rb = UIKit.btn("送去投胎", "ghost", true); act.add_child(rb)
			rb.pressed.connect(func():
				if not rb.has_meta("armed"): rb.set_meta("armed", 1); rb.text = "確定？"; return
				var back = int(floor(float(g.spent) * 0.9)); S.res.coins = float(S.res.coins) + back   # [ux] 退冥幣
				S.ghosts.erase(g); S.team = S.team.map(func(x): return null if x == g.id else x)
				if S.adviser == g.id: S.adviser = null
				show_toast("%s 去投胎了。退回 冥幣 %s" % [g.name, G.fmt(back)]); G.save(); refresh(); _render_roster())
		load("res://game/equip/eq_ui.gd").roster_strip(pc, hb, J.str(g.id))   # [equip] 裝備三格
		load("res://game/equip/eq_ui.gd").on_change = func(): _render_roster()   # [equip]
		sheet_body.add_child(pc)

# --- 箱子 ---
func open_chests() -> void:
	open_sheet("箱子"); _render_chests()

func _render_chests() -> void:
	_clear_body()
	var S = G.S
	_p("小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。")
	for c in [["g", "綠箱", "開出 壽包 %s（隨包子鋪等級提升）" % G.fmt(G.chestGain("g").buns)], ["b", "藍箱", "開出 棺材板 %s（隨棺材鋪等級提升）" % G.fmt(G.chestGain("b").planks)], ["p", "紫箱", "開出 冥幣 %s（隨鬼宅等級提升）" % G.fmt(G.chestGain("p").coins)]]:
		var k: String = c[0]; var have = int(S.chests[k])
		var open_n = func(n: int) -> void:
			var tot = {}
			for i in n:
				var gg = G.chestGain(k)
				for r in gg: tot[r] = tot.get(r, 0) + gg[r]
			S.chests[k] = int(S.chests[k]) - n; S.cnt.chest = int(S.cnt.chest) + n; show_toast("開箱：" + G.give(tot)); G.save(); refresh(); _render_chests()
		_row("[b]%s ×%s[/b]\n[font_size=12]%s[/font_size]" % [c[1], G.fmt(have), c[2]], [_act(UIKit.btn("開 1", "gold", true), func(): open_n.call(1), have > 0), _act(UIKit.btn("全開", "", true), func(): open_n.call(int(S.chests[k])), have > 1)])

# --- 劇情／設定 ---
func open_story() -> void:
	open_sheet("劇情"); _clear_body()
	var S = G.S; var D = DB.D
	_p("看過的劇情，可以在這裡重溫。")
	for e in D.SCENE_ORDER:
		var ids: Array = e[1]; var ok = ids.any(func(id): return S.seen.get(id, false))
		var b = UIKit.btn(e[0] if ok else "？？？", "" if ok else "ghost"); b.disabled = not ok
		b.pressed.connect(func():
			close_sheet(); _nav_on("village")
			for id in ids:
				if S.seen.get(id, false): story.queue(id))
		sheet_body.add_child(b)
	sheet_body.add_child(UIKit.hsep())
	var setb = UIKit.btn("設置（聲音、畫面、劇情、存檔）", "gold"); setb.name = "OpenSettings"; sheet_body.add_child(setb)   # [settings] 語言、存檔碼等搬入設置面板
	setb.pressed.connect(func(): open_settings(false, true))
	var mvb = UIKit.btn("村子畫面：" + ("移動村（大排檔）" if mv_on() else "舊村子"), "ghost"); mvb.visible = not UNIFY; sheet_body.add_child(mvb)   # [unify] 合一地圖：唔再切換
	mvb.pressed.connect(func(): set_mv(not mv_on()); mvb.text = "村子畫面：" + ("移動村（大排檔）" if mv_on() else "舊村子"))
	_p("[font_size=11]Godot 版 %s（對應網頁版 %s）[/font_size]" % [ProjectSettings.get_setting("application/config/version", "dev"), D.get("GAME_VER", "")], 11)

# ---------------- 標題畫面 ----------------
func _show_title(fresh: bool) -> void:
	if JSRun.skip_title:
		var v = JSRun.skip_title; JSRun.skip_title = false
		if v is String and v == "pre": call_deferred("start_opening")
		return
	# [title] 新版標題畫面（ui/title/title_view.gd）：封面推鏡、飄霧、鬼火、Logo、按鈕＋設置／導入存檔
	var tv = load("res://ui/title/title_view.gd").new(); tv.host = self; tv.fresh = fresh
	title_ov = tv; add_child(tv)

# [settings] 設置面板（標題畫面、頂欄齒輪、劇情回顧頁都用呢個）
func open_settings(in_title := false, has_save := true) -> void:
	if get_node_or_null("SettingsPanel") != null: return
	var sp = load("res://ui/settings/settings_panel.gd").new(); sp.host = self; sp.in_title = in_title
	sp.has_save = has_save and G.S is Dictionary and not G.S.is_empty()
	add_child(sp)

# 版本號：開機畫面已經檢查／裝好更新（唔使重開）；只有 Boot 自己喺背景落緊／落好（後備）先用佢嘅字
func _ver_text() -> String:
	if Engine.has_meta("gb_ver") and not (str(Boot.status) in ["downloading", "pending"]):
		var s = str(Engine.get_meta("gb_ver"))
		match str(Boot.status):
			"latest": s += "・已是最新"
			"offline": s += "・連不上更新伺服器"
			"dlfail": s += "・更新下載失敗"
		return s
	return Boot.label()

func _title_cont(fresh: bool) -> void:
	if fresh: return
	# 新遊戲開頭途中閃退／中斷：存檔仲係 1 級、乜都未有、未睇過開場 → 繼續就由開場接返，唔好直接入咗個空村
	# 判斷（name_card.gd opening_unfinished）：1 級、冇資源、未睇 prologue_sys；改咗名或者睇過新開場任何一場都算「未完」
	if NameCardGD.opening_unfinished(G.S):
		_snd("gong"); _hide_title(); start_opening(); return
	_snd("gong"); _hide_title(); phone_home("post")   # 網頁版：繼續遊戲 → 手機（陰間版 WhatsApp）→ 主對話 → 結算離線收益

func _title_new(fresh: bool, bn: Control, hint: Label) -> void:
	if not fresh and not bn.has_meta("armed"):
		bn.set_meta("armed", 1); hint.text = "會刪掉現在的存檔。再點一次「開始新遊戲」確定。"; return
	G.crumb("ng:click")
	if not fresh: restart_with(null, "pre"); return
	G.crumb("ng:sound"); _snd("gong")
	G.crumb("ng:hide_title"); _hide_title()
	G.crumb("ng:refresh"); refresh()
	G.crumb("ng:opening"); start_opening()
	await RenderingServer.frame_post_draw; await RenderingServer.frame_post_draw
	G.crumb("ng:opening_shown")

# 頭七回魂夜開場：未改名 → 手機重新開機（改名＋揀頭像）→ 02:13 手機 → 開場劇情（data/story_v2.json "opening"）
const NameCardGD = preload("res://ui/name_card.gd")
func start_opening() -> void:
	if not NameCardGD.hero_set(G.S):
		var s = J.G.get("Sound")
		if s is Dictionary: J.mc(s, "setMode", ["office"])
		var nc = NameCardGD.new(); nc.on_done = _opening_go
		add_child(nc); move_child(nc, get_child_count() - 1)
		return
	_opening_go()

func _opening_go() -> void:
	var i = NameCardGD.resume_index(G.S)
	if i <= 0: phone_home("pre"); return
	# 中途斷咗：由播到一半嗰場接返，唔使再由手機開始
	refresh()
	for id in NameCardGD.opening(G.S).slice(i): story.queue(id)

func _vgrad(stops: Array) -> Texture2D:
	var gr = Gradient.new()
	gr.offsets = PackedFloat32Array(stops.map(func(x): return x[0])); gr.colors = PackedColorArray(stops.map(func(x): return x[1]))
	return GradTex.vertical(gr, 4, 128)

func _gray_mat() -> ShaderMaterial:
	var sh = Shader.new(); sh.code = "shader_type canvas_item; void fragment(){ vec4 c = texture(TEXTURE, UV) * COLOR; float g = dot(c.rgb, vec3(0.299,0.587,0.114)); COLOR = vec4(mix(c.rgb, vec3(g), 0.85), c.a); }"
	var m = ShaderMaterial.new(); m.shader = sh; return m

# ---------------- 手機（仿 WhatsApp）----------------
var phone: WA = null
func phone_home(ph: String) -> void:
	if phone == null:
		phone = WA.new(); add_child(phone)
		phone.on_enter = _phone_enter
	move_child(phone, get_child_count() - 1)
	if ph == "pre": _pre_chats()
	phone.show_home(ph)
	_phone_flag(true)
	var s = J.G.get("Sound")
	if s is Dictionary: J.mc(s, "setMode", ["office" if ph == "pre" else "story"])

# 女主生前手機（大學群組）；男主用返原本 CHATS_PRE（第一次記低原本嗰份）
func _pre_chats() -> void:
	if not J.G.has("CHATS_PRE_M"): J.G["CHATS_PRE_M"] = J.G.get("CHATS_PRE")
	var PG = load("res://native/phone.gd")
	J.G["CHATS_PRE"] = PG.chats_pre_f() if PG.is_female(G.S) else J.G.get("CHATS_PRE_M")

func phone_close() -> void:
	if phone: phone.queue_free(); phone = null
	_phone_flag(false)

func _phone_flag(on: bool) -> void:
	var p = J.G.get("Phone")
	if p is Dictionary: p["on"] = on

func _phone_enter(ph: String) -> void:
	G.crumb("ng:enter_" + ph)
	phone_close()
	if ph == "pre":
		for id in NameCardGD.opening(G.S): story.queue(id)
	else:
		G.offline_gain()
		var s = J.G.get("Sound")
		if s is Dictionary: J.mc(s, "setMode", ["village"])

func _snd(n: String) -> void:
	var s = J.G.get("Sound")
	if s is Dictionary and s.has("play"): J.mc(s, "play", [n])

func _hide_title() -> void:
	if title_ov: title_ov.queue_free(); title_ov = null

# ---------------- 存檔：經 JS 嘅 localStorage，然後重新載入場景（同網頁版 location.reload 一樣）----------------
const SAVE_KEY := "ghostBattles_v1"
# 原生「匯入存檔碼」視窗：貼上網頁版（或其他機）嘅存檔碼，即刻換成嗰個進度
func open_import() -> void:
	var ov = ColorRect.new(); ov.color = Color(0, 0, 0, 0.6); ov.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(ov)
	var pn = PanelContainer.new(); pn.add_theme_stylebox_override("panel", UIKit.sb(Color("#f3e7c9"), 10, Color("#6b4a2b"), 2, Vector4(16, 14, 16, 14)))
	pn.set_anchors_and_offsets_preset(Control.PRESET_CENTER); pn.offset_left = -170; pn.offset_right = 170; pn.offset_top = -190; pn.offset_bottom = 190
	ov.add_child(pn)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 10); pn.add_child(vb)
	vb.add_child(UIKit.label("導入存檔碼", 18, UIKit.INKTXT, "serif", 700))
	var tip = UIKit.label("在網頁版「劇情」頁最上面按「搬去正式版：備份存檔」，存檔碼會自動複製，再回來貼在下面。", 13, UIKit.INKTXT); tip.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; vb.add_child(tip)
	var te = TextEdit.new(); te.custom_minimum_size = Vector2(0, 150); te.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	te.placeholder_text = "長按貼上存檔碼"; te.add_theme_font_size_override("font_size", 12); vb.add_child(te)
	var info = UIKit.label("", 14, Color("#9a2a1e"), "sans", 700); info.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; vb.add_child(info)
	var check = func():
		var o = G.dec(te.text)
		info.text = ("讀到：主公 %d 級存檔。按「換成這個進度」馬上轉過來。" % int(J.num(o.get("lv", 1)))) if o != null else ("存檔碼讀不到，檢查一下有沒有貼完整" if te.text.strip_edges() != "" else "")
		return o
	te.text_changed.connect(func(): check.call())
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); vb.add_child(hb)
	var mk = func(t: String, f: Callable):
		var b = Button.new(); b.text = t; b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.custom_minimum_size.y = 42
		b.add_theme_font_override("font", UIKit.font("sans", 700)); b.add_theme_font_size_override("font_size", 14)
		b.pressed.connect(f); hb.add_child(b); return b
	mk.call("貼上", func(): te.text = DisplayServer.clipboard_get(); check.call())
	mk.call("取消", func(): ov.queue_free())
	mk.call("換成這個進度", func():
		if check.call() != null: ov.queue_free(); import_save(te.text))
	if DisplayServer.clipboard_has() and G.dec(DisplayServer.clipboard_get()) != null:
		te.text = DisplayServer.clipboard_get(); check.call()

func import_save(code: String) -> bool:
	var o = G.dec(code)
	if o == null: show_toast("存檔碼讀不到，檢查一下有沒有貼完整"); return false
	o.last = G.now_ms()
	# [gift] 匯入嘅係「全新開局」存檔（例如測試大禮包）：跳過標題後照播開場（改名卡＋頭七回魂夜）
	restart_with(o, "pre" if NameCardGD.opening_unfinished(o) else true); return true

func restart_with(save, skip_title) -> void:
	if JSRun.ls.has(SAVE_KEY): JSRun.ls[SAVE_KEY + "_bak"] = JSRun.ls[SAVE_KEY]
	if save == null: JSRun.ls.erase(SAVE_KEY)
	else: JSRun.ls[SAVE_KEY] = J.to_json(save)
	JSRun.flush_ls()
	JSRun.skip_title = skip_title
	JSRun.reset_world()
	get_tree().call_deferred("reload_current_scene")

func open_html_sheet(title: String, html: String) -> void:
	open_sheet(title); _clear_body()
	_p(JSBridge.html2bb(html), 14, UIKit.INKTXT)

func t_dump_ground(path: String) -> void: village.t_dump_ground(path)

# 測試用（GB_TEST 腳本 ["call","main",...]）：開場劇情跳場／跳行／報告
func t_story_skip() -> void: story.skip_scene()
func t_story_goto(i) -> void:
	if story.cur == null or story.wa != null: return
	story.li = clampi(int(i), 0, story.cur.sc.lines.size() - 1); story._show_line()
func t_story_adv(n = 1) -> void:
	for k in int(n): story.advance()
func t_story_id() -> void: print("STORY ", (story.cur.id if story.cur != null else "<none>"), " li=", story.li, " q=", story.q.size())
