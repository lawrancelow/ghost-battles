# [uxui] 介面流程截圖：村子／移動村 HUD、告急、劇情中
extends RefCounted
const MD = preload("res://game/outpost/mv_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const PT = preload("res://tools/tests/play_test.gd")
var OUT := "/tmp/uxui/shots/"
func _p(s) -> void: print("[uxui] ", s)
func _S(): return J.G.get("S")
func _wait(s: float) -> void: await Engine.get_main_loop().create_timer(s).timeout
func _shot(name: String) -> void:
	await Engine.get_main_loop().process_frame
	await RenderingServer.frame_post_draw
	var img = Engine.get_main_loop().root.get_viewport().get_texture().get_image()
	img.save_png(OUT + name + ".png"); _p("SHOT " + name)
func _skip(m) -> void:
	for i in 8:
		var st0 = m.get("story")
		if st0 and st0.get("cur") != null: st0.skip_scene()
		await _wait(0.2)
func all(tt) -> void:
	var eo = OS.get_environment("UX_OUT")
	if eo != "": OUT = eo
	DirAccess.make_dir_recursive_absolute(OUT)
	var pt = PT.new()
	var m = tt.main()
	if m.has_method("_hide_title"): m._hide_title(); await _wait(1.0)
	await _skip(m)
	pt._setup(1000000000.0)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _wait(1.0); await _skip(m)
	await _shot("v_default")
	var sc = m.mv_view; var sim = sc.sim
	# 告急：影響力壓低、離開新手保護
	var ws = MVW.ws(); ws.t0 = 99999.0
	ws.inf[str(sim.ci())] = 10.0
	await _wait(2.0); await _skip(m)
	await _shot("v_alarm")
	# 劇情中觸發提示
	G.story_req.emit("gift_xiaozhi", Callable())
	await _wait(0.6)
	G.toast.emit("測試提示：劇情中唔應該見到")
	G.banner.emit("測試橫幅")
	await _wait(0.4)
	await _shot("v_story_toast")
	_p("DONE")
