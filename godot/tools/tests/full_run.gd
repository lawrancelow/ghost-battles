# 全遊戲一條龍測試（測試版準備）
# 用法：XDG_DATA_HOME=<新資料夾>（冇存檔）GB_TEST=tools/tests/full_run.json
#   ["gdrun","res://tools/tests/full_run.gd","all"]
# 每段：開始 → 等 → 量幀率 → 截圖 /tmp/full_<段>.png → 存檔 → 重新載入場景（等同重開 App，順手驗存檔讀檔）
# 輸出：[full] begin/end <段> fps=… 、[bake] 尺寸（新遊戲流程烘焙咗乜）；SCRIPT ERROR 按 log 次序歸段
extends RefCounted

static var t0 := 0

func _p(m): print("[full] ", m)
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout

func _skip_story(t, n := 10):
	for i in n:
		var m = _main(t)
		var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.4)

func _fps(t, secs := 3.0) -> float:
	var f0 = Engine.get_process_frames(); var a = Time.get_ticks_msec()
	await _w(t, secs)
	return (Engine.get_process_frames() - f0) * 1000.0 / maxf(1.0, Time.get_ticks_msec() - a)

func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png("/tmp/full_%s.png" % name)

func _end(t, name: String):
	var fps = await _fps(t)
	await _shot(t, name)
	_p("end %s fps=%.1f t=%ds" % [name, fps, (Time.get_ticks_msec() - t0) / 1000])

func _reload(t):
	var sv = J.G.get("save")
	if sv != null: J.cl(sv, null, [])
	JSRun.reset_world()   # 同遊戲內重開一樣（main.restart_with）；唔清會留低舊場景嘅閉包，報幾千個假錯
	t.get_tree().reload_current_scene()
	for i in 60:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 2.0)
	var m2 = _main(t)
	if m2 and m2.has_method("_hide_title"): m2._hide_title()
	await _skip_story(t, 4)

func _stage(t, name: String, f: Callable, wait := 6.0):
	_p("begin " + name)
	var ok = true
	await f.call()
	await _w(t, wait)
	await _skip_story(t, 4)
	await _end(t, name)

func all(t):
	t0 = Time.get_ticks_msec()
	# 記低新遊戲流程嘅烘焙（SubViewport 拍照＋讀返）尺寸
	_p("begin newgame")
	var m = _main(t)
	var tov = m.get("title_ov")
	var bs = []
	var st = [tov if tov != null else m]
	while st.size() > 0:
		var n = st.pop_back()
		if n is TextureButton: bs.append(n)
		for c in n.get_children(): st.append(c)
	m._title_new(true, bs[0] if bs.size() > 0 else null, Label.new())
	await _w(t, 3.0); await _shot(t, "phone")
	_p("end phone fps=%.1f" % await _fps(t, 2.0))
	_p("begin prologue")
	m._phone_enter("pre")
	await _skip_story(t, 16)
	await _w(t, 3.0)
	await _end(t, "prologue")
	await _stage(t, "village_task", func():
		J.mc(J.G.get("Village"), "tap", [90.0, 380.0]), 8.0)
	_p("state: lv=%s res=%s" % [str(J.G.S.get("lv")), str(J.G.S.get("res")).substr(0, 160)])
	# 之後玩法要解鎖：換做舊存檔繼續（亦驗證匯入）
	_p("begin import_save")
	var code = FileAccess.get_file_as_string("/tmp/claude-0/save_code.txt").strip_edges()
	if code != "": _p("import ok=%s" % str(_main(t).import_save(code)))
	await _w(t, 12.0)
	await _reload(t)
	await _end(t, "village_save")
	var l3 = load("res://tools/tests/l3_play.gd").new()
	var pt = load("res://tools/tests/l1_pt_play.gd").new()
	await _stage(t, "battle", func(): l3.bt(t), 10.0)
	l3.bt_res(t); await _reload(t)
	await _stage(t, "world", func(): l3.wm(t), 3.0)
	l3.wm_close(t); await _reload(t)
	await _stage(t, "patrol", func():
		pt.prep(t); await _w(t, 2.0); await _skip_story(t, 6); pt.go(t), 8.0)
	pt.run_state(t); pt.quit(t); await _w(t, 2.0); pt.close(t); await _w(t, 2.0); pt.back(t)
	await _reload(t)
	await _stage(t, "scare_night", func():
		J.mc(J.G.get("Scare"), "start", ["office", ["afu", "eguiking", "toyol"]]), 20.0)
	await _reload(t)
	await _stage(t, "squad_select", func():
		J.mc(J.G.get("ScareX"), "open", [J.G.get("SCARE_SITES").keys()[0]]), 3.0)
	await _reload(t)
	await _stage(t, "tower", func():
		l3.tw_open(t); await _w(t, 2.0); await _skip_story(t, 4); l3.tw_start(t), 10.0)
	await _reload(t)
	await _stage(t, "street", func(): J.mc(J.G.get("Street"), "open", []), 6.0)
	await _reload(t)
	await _stage(t, "gstreet", func(): l3.gs(t), 8.0)
	await _reload(t)
	await _stage(t, "gyard", func():
		l3.gy(t); await _w(t, 3.0); await _skip_story(t, 4); l3.gy_solve(t), 6.0)
	l3.gy_state(t); await _reload(t)
	await _stage(t, "sports", func(): l3.sp(t), 8.0)
	await _reload(t)
	await _stage(t, "theater", func():
		var L = J.G.get("SKITS")
		if L is Array and L.size() > 0: _p("theater play=%s" % str(J.mc(J.G.get("Skits"), "play", [L[0], true]))), 6.0)
	await _reload(t)
	_p("save_check lv=%s ghosts=%s" % [str(J.G.S.get("lv")), str(J.G.S.ghosts.size() if J.G.S.get("ghosts") is Array else -1)])
	_p("done total=%ds" % ((Time.get_ticks_msec() - t0) / 1000))
