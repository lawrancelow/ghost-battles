# [uiart] 美術二組：面板盤點截圖。每次跑一個 shot（arg = 名稱），輸出到 UIART_OUT（預設 /tmp/uiart/shots/）
# GB_TEST：[["wait",3],["gdrun","res://tools/tests/uiart_shot.gd","<名>"],["quit"]]
extends RefCounted

const PT = preload("res://tools/tests/play_test.gd")
const MD = preload("res://game/outpost/mv_data.gd")
var OUT := "/tmp/uiart/shots/"

func _p(s) -> void: print("[uiart] ", s)
func _wait(s: float) -> void: await Engine.get_main_loop().create_timer(s).timeout
func _shot(name: String) -> void:
	await Engine.get_main_loop().process_frame
	await RenderingServer.frame_post_draw
	var img = Engine.get_main_loop().root.get_viewport().get_texture().get_image()
	img.save_png(OUT + name + ".png"); _p("SHOT " + OUT + name + ".png")

func _skip(m) -> void:
	for i in 8:
		var st = m.get("story")
		if st and st.get("cur") != null: st.skip_scene()
		await _wait(0.2)

func _game(m) -> void:
	var pt = PT.new(); pt._setup(1e9)
	var S = J.G.get("S"); S.res["coins"] = 123456.0
	if m.has_method("_hide_title"): m._hide_title()
	await _wait(1.0); await _skip(m)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _wait(1.2); await _skip(m)

func _run(name: String, tt) -> void:
	var eo = OS.get_environment("UIART_OUT")
	if eo != "": OUT = eo
	DirAccess.make_dir_recursive_absolute(OUT)
	var m = tt.main()
	if OS.get_environment("UIART_WIDE") == "1":   # [uikit] 寬屏截圖
		Engine.get_main_loop().root.size = Vector2i(1920, 1080); await _wait(1.0)
	match name:
		"title":
			await _wait(2.0)
		"settings_title":
			await _wait(1.5); m.open_settings(true, false); await _wait(1.0)
		_:
			await _game(m)
	match name:
		"hud": pass
		"station":
			var sc = m.mv_view
			if sc: sc.open_sheet("st_shoubao"); await _wait(1.0)
		"picker":
			var sc = m.mv_view
			if sc: sc.open_sheet("st_shoubao"); await _wait(0.6); sc._open_picker("workers", 0); await _wait(0.8)
		"roster": m.open_roster(); await _wait(1.0)
		"chests": m.open_chests(); await _wait(1.0)
		"story": m.open_story(); await _wait(1.0)
		"building": m.open_building("wood"); await _wait(1.0)
		"backyard": m.open_backyard(); await _wait(1.0)
		"import": m.open_import(); await _wait(1.0)
		"codex": load("res://game/soul/soul_codex.gd").open(); await _wait(1.2)
		"codex_detail": load("res://game/soul/soul_codex.gd").open_detail("mengpo"); await _wait(1.2)
		"equip": load("res://game/equip/eq_ui.gd").open_craft(); await _wait(1.2)
		"barracks": load("res://game/barracks/bk_data.gd").open_panel(); await _wait(1.2)
		"chain":
			var sc = m.mv_view
			load("res://game/outpost/chain_panel.gd").open_in(m, sc); await _wait(1.2)
		"toast": m.show_toast("獲得 壽包 ×10"); m.show_banner("鬼潮來襲！"); await _wait(0.5)
		"settings_sound", "settings_gfx", "settings_story", "settings_save", "settings_help":
			m.open_settings(false, true); await _wait(0.8)
			var sp = m.get_node_or_null("SettingsPanel")
			var ix = ["settings_sound", "settings_gfx", "settings_story", "settings_save", "settings_help"].find(name)
			if sp: sp.show_tab(ix); await _wait(0.6)
	await _wait(0.6)
	await _shot(name)

func run(tt) -> void: pass
func title(tt): await _run("title", tt)
func settings_title(tt): await _run("settings_title", tt)
func hud(tt): await _run("hud", tt)
func station(tt): await _run("station", tt)
func picker(tt): await _run("picker", tt)
func roster(tt): await _run("roster", tt)
func chests(tt): await _run("chests", tt)
func story(tt): await _run("story", tt)
func building(tt): await _run("building", tt)
func backyard(tt): await _run("backyard", tt)
func import(tt): await _run("import", tt)
func codex(tt): await _run("codex", tt)
func codex_detail(tt): await _run("codex_detail", tt)
func equip(tt): await _run("equip", tt)
func barracks(tt): await _run("barracks", tt)
func chain(tt): await _run("chain", tt)
func toast(tt): await _run("toast", tt)
func settings_sound(tt): await _run("settings_sound", tt)
func settings_gfx(tt): await _run("settings_gfx", tt)
func settings_story(tt): await _run("settings_story", tt)
func settings_save(tt): await _run("settings_save", tt)
func settings_help(tt): await _run("settings_help", tt)
