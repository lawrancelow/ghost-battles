# [villageart] 原版村子新畫風：截圖（由頂拖到底）＋位置／點擊範圍匯出＋幀率
# 用法：edtest.sh godot va res://tools/tests/villageart_test.gd shots_before|shots_after|bake
# 輸出：/tmp/va/<tag>/*.png、pos.json、fps.txt
extends RefCounted

func _p(m): print("[va] ", m)
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.0)
func _calm(t):
	for i in 40:
		var m = _main(t); var st = m.get("story") if m else null
		if st == null or not st.busy(): break
		if st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
	await _w(t, 3.4)

func shots_before(t) -> void: await _shots(t, "before")
func shots_after(t) -> void: await _shots(t, "after")

func _shots(t, tag: String) -> void:
	var out = "/tmp/va/%s/" % tag
	DirAccess.make_dir_recursive_absolute(out)
	var m = _main(t)
	await _wait_boot(t)
	m._hide_title(); await _w(t, 1.0)
	await _calm(t)
	var S = J.G.S
	if m.has_method("set_mv"): m.set_mv(false)
	# 全部建築起好（前後同一狀態），一棵樹砍倒、一塊田割咗（睇樹樁／收割後）
	for id in J.G.get("BLD_ORDER"): S.bld[id] = 1.0 + (J.G.get("BLD_ORDER").find(id) % 3)
	S.trees[3] = 0; S.treeRegrow[3] = 9999.0; S.paddy[2] = 0; S.paddyRegrow[2] = 9999.0
	await _calm(t)
	var V = J.G.Village; var nv = m.village
	# 鏡頭唔好跟住阿福
	var vh = J.num(V.h) / J.num(V.scale)
	var ys = []
	var y = 0.0
	while y < 1130.0 - vh + 1: ys.append(y); y += 260.0
	ys.append(1130.0 - vh)
	var i = 0
	for cy in ys:
		J.mc(V, "setCam", [cy]); await _w(t, 0.8)
		await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(out + "v%02d_y%04d.png" % [i, int(cy)]); _p("shot %s y=%d" % [tag, int(cy)])
		i += 1
	# 位置／點擊範圍匯出
	var pos = {"POS": J.G.POS, "TREE_POS": J.G.TREE_POS, "PADDY_POS": J.G.PADDY_POS, "DECOR": J.G.DECOR, "statics": {}, "hits": []}
	for k in nv.statics: pos.statics[k] = [nv.statics[k].node.position.x, nv.statics[k].node.position.y]
	var hy = 100.0
	while hy < 1130.0:
		var hx = 10.0
		while hx < 390.0:
			var h = J.mc(V, "hitTest", [hx, hy])
			pos.hits.append([hx, hy, JSON.stringify(h) if h != null else ""])
			hx += 10.0
		hy += 10.0
	var f = FileAccess.open(out + "pos.json", FileAccess.WRITE); f.store_string(JSON.stringify(pos, " ", true)); f.close()
	# 幀率：鏡頭慢慢由頂拖到底再返上去，量 6 秒
	var frames = 0; var t0 = Time.get_ticks_usec(); var worst = 0.0; var last = t0
	while Time.get_ticks_usec() - t0 < 6000000:
		var e = (Time.get_ticks_usec() - t0) / 6000000.0
		J.mc(V, "setCam", [(1130.0 - vh) * (1.0 - absf(e * 2.0 - 1.0))])
		await RenderingServer.frame_post_draw
		var now = Time.get_ticks_usec(); worst = maxf(worst, (now - last) / 1000.0); last = now; frames += 1
	var fps = frames / ((Time.get_ticks_usec() - t0) / 1000000.0)
	_p("FPS %s %.1f worst=%.1fms" % [tag, fps, worst])
	var f2 = FileAccess.open(out + "fps.txt", FileAccess.WRITE); f2.store_string("%.2f %.2f\n" % [fps, worst]); f2.close()
	_p("RESULT ok")

# 重烘地面：ground_painter.gd → res://assets/img/village_ground.webp（780×2260）
func bake(t) -> void:
	await _wait_boot(t)
	var vp = SubViewport.new()
	vp.size = Vector2i(780, 2260); vp.transparent_bg = false
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var painter = Node2D.new(); painter.set_script(load("res://game/ground_painter.gd"))
	var P = {}
	for k in J.G.POS: P[k] = [J.num(J.G.POS[k][0]), J.num(J.G.POS[k][1])]
	painter.set("POS", P)
	vp.add_child(painter); t.get_tree().root.add_child(vp)
	for i in 8: await RenderingServer.frame_post_draw
	var img = vp.get_texture().get_image()
	var path = ProjectSettings.globalize_path("res://assets/img/village_ground.webp")
	img.save_webp(path, false, 0.9)
	_p("baked %s %s" % [path, img.get_size()])
	_p("RESULT ok")
