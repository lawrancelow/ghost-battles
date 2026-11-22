extends RefCounted
const ZD = preload("res://game/zone/zone_data.gd")
const STY = preload("res://game/outpost/mv_story.gd")
var m; var out; var t0 = 0.0; var last = {}
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _log(k, v):
	var line = "[probe] t=%6.1f %s: %s" % [Time.get_ticks_msec() / 1000.0 * Engine.time_scale - t0, k, v]
	print(line)
func poll(t, secs: float, tag: String):
	var n = int(secs / 0.5)
	for i in n:
		await _w(t, 0.5)
		var st = m.story
		if st.cur != null:
			var cc = st.cur.get("sc", st.cur) if st.cur is Dictionary else st.cur
			if cc is Dictionary and cc.has("sc") and cc.sc is Dictionary: cc = cc.sc
			var ti = str(cc.get("title", "")) + " " + str(cc.get("id", "")) + " " + str(st.cur.get("id", ""))
			st.cur = st.cur
			var key = ti + str(cc.get("lines", []).size())
			if last.get("story") != key:
				last["story"] = key
				var sp = []
				for l in cc.get("lines", []):
					if l is Array and l.size() > 0 and not sp.has(str(l[0])): sp.append(str(l[0]))
				_log("劇情", "%s（%d 句，%s）" % [ti, cc.get("lines", []).size(), "、".join(sp)])
				last["sn"] = 0
			if ti.begins_with("村口") and int(last.get("sn", 0)) < 9:
				await _w(t, 0.6); await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png("%s/gate_%d.png" % [out, int(last.get("sn", 0))]); last["sn"] = int(last.get("sn", 0)) + 1
			st.advance()
		else: last["story"] = ""
		for c in m.toasts.get_children():
			var r = c.get_child(0) if c.get_child_count() else null
			if r and not c.has_meta("seen"): c.set_meta("seen", 1); _log("提示", r.text.replace("\n", " "))
		if m.banner_lbl.text != last.get("ban", "") and m.banner.modulate.a > 0.1:
			last["ban"] = m.banner_lbl.text; _log("橫幅", m.banner_lbl.text)
		var mvs = m.mv_view.story if m.get("mv_view") != null else null
		if mvs != null and mvs.played.size() != int(last.get("mvn", 0)):
			_log("大排檔beat", str(mvs.played.slice(int(last.get("mvn", 0))))); last["mvn"] = mvs.played.size()
		var qt = m.quest_lbl.text
		if qt != last.get("q", ""): last["q"] = qt; _log("任務欄", qt)
		var S = J.G.S
		var gq = str(S.get("gq", "")) + str(S.get("guide", ""))
		if gq != last.get("gq", ""): last["gq"] = gq; _log("guide", gq.substr(0, 200))
		if i % 40 == 0:
			await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png("%s/%s_%03d.png" % [out, tag, i])
func all(t):
	out = OS.get_environment("BS_OUT"); DirAccess.make_dir_recursive_absolute(out)
	for i in 120:
		await _w(t, 0.5)
		m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	m._hide_title(); await _w(t, 1.0)
	STY.auto_on = true; STY.pace_on = true; ZD.gate_on = true
	Engine.time_scale = 3.0
	t0 = Time.get_ticks_msec() / 1000.0 * Engine.time_scale
	_log("開始", "新開檔 qi=%s" % J.G.S.qi)
	await poll(t, 20, "a")
	var S = J.G.S
	S["qi"] = 6.0; S.bld["plank"] = 1.0; S.bld["bun"] = 1.0
	_log("動作", "跳到主線第 7 個任務（升到 3 級），而家升級")
	while J.num(S.lv) < 3: J.cl(J.G.get("give"), null, [{"exp": 5.0}])
	_log("等級", str(S.lv))
	await poll(t, 30, "b")
	m._nav("battle")
	await _w(t, 1.5); await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png("%s/nav_out.png" % out)
	await poll(t, 30, "b2")
	var tg = ZD.stage_target()
	_log("迎戰位", str(tg))
	if tg.has("pos"):
		var nv = m.village; var cam = nv.zone_cam(); cam.center_on(tg.pos)
		await _w(t, 1.0); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png("%s/stage_marker.png" % out)
	var MB = load("res://game/zone/zone_battle.gd")
	var r = ZD.start_stage()
	_log("開打", "%s busy=%s" % [r, MB.busy()])
	await _w(t, 2.0); MB.t_skip_march(); await _w(t, 4.0); await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png("%s/stage_fight.png" % out)
	var nv2 = m.village; nv2.zone_cam().z = nv2.zone_cam().z * 1.8; MB.cur.follow = true; await _w(t, 1.5); await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png("%s/stage_fight_zoom.png" % out)
	if MB.busy(): MB.cur._teardown()
	var Bt = J.G.get("Battle"); if Bt is Dictionary: Bt["active"] = false
	_log("動作", "打完 1-1")
	S.cleared["1-1"] = true
	await poll(t, 60, "c")
	_log("動作", "升到 4 級")
	while J.num(S.lv) < 4: J.cl(J.G.get("give"), null, [{"exp": 5.0}])
	await poll(t, 40, "d")
	_log("動作", "派鬼打工（任務 9）→ 1-2 開始")
	S["qi"] = 9.0; m.refresh() if m.has_method("refresh") else null
	J.mc(J.G.get("Quest"), "complete", [])
	await poll(t, 40, "e")
	print("[probe] done")
