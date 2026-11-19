# [mapart] 通用血霧測試（game/outpost/mv_mist.gd）
# 用法：/home/claude/setup/edtest.sh <godot目錄> mist res://tools/tests/mist_test.gd all
#   logic：種子固定、同 key 形狀一致、唔同 key 唔同、快取生效、前後層 alpha 範圍、顏色喺老闆色板、細絲 3–5、
#          畫面外唔畫、唔擋點擊、效能（一幀畫 40 座建築耗時）
#   all：logic ＋ 截圖（/tmp/mist/shots/：新建築放喺 bg_map0_tileA 背景上，有霧／冇霧＋放大）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/mist/shots/"
const REF := "/home/claude/ctx/ref/"
const MI = preload("res://game/outpost/mv_mist.gd")

func _p(m): print("[mist] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _frames(t, n: int):
	for i in n: await t.get_tree().process_frame
func _tex(path: String) -> Texture2D:
	var im = Image.load_from_file(path)
	return ImageTexture.create_from_image(im) if im != null else null
func _alpha_stats(tex: Texture2D) -> Dictionary:
	var im = tex.get_image(); var mx = 0.0; var sum = 0.0; var n = 0; var hi = 0
	var sr = 0.0; var sg = 0.0; var sb = 0.0; var cn = 0; var out = 0
	for y in im.get_height():
		for x in im.get_width():
			var c = im.get_pixel(x, y)
			if c.a <= 0.01: continue
			mx = maxf(mx, c.a); sum += c.a; n += 1
			if c.a > 0.3:
				sr += c.r; sg += c.g; sb += c.b; cn += 1
				if c.r8 > 0x3a or c.g8 > 0x06 or c.b8 > 0x07: out += 1   # 超出色板（最亮 #3a0607）
	return {"max": mx, "mean": sum / maxf(1, n), "n": n, "r": sr / maxf(1, cn), "g": sg / maxf(1, cn), "b": sb / maxf(1, cn), "out": out}

# 收埋 root 底下所有遊戲畫面（CanvasItem／CanvasLayer；純 Node 就睇佢下一層），回收埋咗嘅節點俾測完還原
func _quiet(t) -> Array:
	var out = []
	var stack = t.get_tree().root.get_children()
	while stack.size():
		var n = stack.pop_back()
		if n is CanvasItem or n is CanvasLayer:
			if n.visible: n.visible = false; out.append(n)
		elif not (n is Window): stack.append_array(n.get_children())
	return out

func all(t) -> void: await _run(t, true)
func logic(t) -> void: await _run(t, false)

func _run(t, shots: bool) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _w(t, 1.0)
	MI.clear_cache(); MI.enabled = true
	var src = FileAccess.get_file_as_string("res://game/outpost/mv_mist.gd")
	_chk("冇 class_name", RegEx.create_from_string("(?m)^\\s*class_name").search(src) == null)

	# ---------- 1. 種子固定、同 key 一致 ----------
	var a1 = MI.entry("vil:house", 150.0, 140.0, true)
	var g0 = MI.gen_n
	MI.clear_cache()
	var a2 = MI.entry("vil:house", 150.0, 140.0, true)
	var same = a1.front.get_image().get_data() == a2.front.get_image().get_data() and a1.back.get_image().get_data() == a2.back.get_image().get_data()
	for i in a1.wisps.size(): same = same and a1.wisps[i].tex.get_image().get_data() == a2.wisps[i].tex.get_image().get_data()
	_chk("種子固定：清快取再整，同 key 一模一樣（前、後、細絲）", same and a1.seed == a2.seed)
	var b1 = MI.entry("pd:stall3", 150.0, 140.0, true)
	_chk("唔同 key 形狀唔同", b1.front.get_image().get_data() != a2.front.get_image().get_data() and b1.seed != a2.seed)
	_chk("細絲 3–5 縷", a2.wisps.size() >= 3 and a2.wisps.size() <= 5, a2.wisps.size())

	# ---------- 2. 快取 ----------
	var g1 = MI.gen_n
	var a3 = MI.entry("vil:house", 150.0, 140.0); var a4 = MI.entry("vil:house", 151.0, 146.0)
	_chk("快取：同 key 同尺寸攞返同一份、差少少（同一級）共用", a3 == a2 and a4 == a2 and MI.gen_n == g1, "%d→%d" % [g1, MI.gen_n])
	var a5 = MI.entry("vil:house", 220.0, 140.0, true)
	_chk("快取：闊度唔同級另整", a5 != a2 and MI.gen_n == g1 + 1)
	_chk("快取份數 = 鍵數", MI.cache.size() == 3, MI.cache.size())

	# ---------- 3. 前後層 alpha、顏色 ----------
	var sf = _alpha_stats(a2.front); var sbk = _alpha_stats(a2.back)
	_p("前層 alpha 最濃 %.2f 平均 %.2f；後層 最濃 %.2f 平均 %.2f" % [sf.max, sf.mean, sbk.max, sbk.mean])
	_chk("前層 alpha：最濃 0.55–0.9（主體 ≤0.75＋筆觸）", sf.max >= 0.55 and sf.max <= 0.9, "%.2f" % sf.max)
	_chk("後層較淡：最濃 ≤ 0.85、平均 < 前層", sbk.max <= 0.86 and sbk.mean < sf.mean, "%.2f < %.2f" % [sbk.mean, sf.mean])
	_chk("後層較闊", MI.back_rect(Vector2.ZERO, 150, 140).size.x > MI.front_rect(Vector2.ZERO, 150, 140).size.x)
	_chk("前層蓋住建築底同地面接縫（範圍跨過 base 線）", MI.front_rect(Vector2(0, 100), 150, 140).position.y < 100 and MI.front_rect(Vector2(0, 100), 150, 140).end.y > 100)
	_chk("顏色喺老闆色板（極暗紅，冇超過 #3a0607 嘅點）", sf.out == 0 and sbk.out == 0 and sf.r > sf.g * 3.0 and sf.r < 0.16, "R%.3f G%.3f B%.3f out=%d/%d" % [sf.r, sf.g, sf.b, sf.out, sbk.out])

	# ---------- 4. 畫面外唔畫、通用 CanvasItem、唔擋點擊 ----------
	# 隔開遊戲本身：合一地圖嘅村子（village_style，vil:*）同大排檔（mv_scene，pd:*）每幀都用同一個 MIST 畫霧，
	# gen_n／culled／cache 係全域計數 → 第 4、5 節要數「本測試自己」整咗幾多份，就要先收埋遊戲畫面（測完還原）。
	var hid = _quiet(t)
	await _frames(t, 2)
	var layer = CanvasLayer.new(); layer.layer = 100
	t.get_tree().root.add_child(layer)
	var btn = Button.new(); btn.position = Vector2(150, 400); btn.size = Vector2(150, 80); btn.text = "TAP"
	layer.add_child(btn)
	var tapped = {"n": 0}
	btn.pressed.connect(func(): tapped.n += 1)
	var host = Node2D.new(); layer.add_child(host)
	var res = {"on": 0, "off": 0}
	MI.clear_cache(); var gc = MI.gen_n; var cu = MI.culled
	host.draw.connect(func():
		var tt = Time.get_ticks_msec() / 1000.0
		if MI.draw_both(host, "t:tap", Vector2(225, 480), 150.0, 140.0, tt): res.on += 1
		if MI.draw(host, "t:far", Vector2(225, 5000), 150.0, 140.0, tt, true): res.off += 1
		if MI.draw(host, "t:far", Vector2(-3000, 480), 150.0, 140.0, tt, false): res.off += 1)
	for k in 4: host.queue_redraw(); await _frames(t, 1)
	_chk("通用 API 畫到任何 CanvasItem", res.on > 0 and MI.cache.has(MI.cache_key("t:tap", 150, 140)))
	_chk("畫面外：唔畫、唔整貼圖", res.off == 0 and not MI.cache.has(MI.cache_key("t:far", 150, 140)) and MI.culled > cu and MI.gen_n == gc + 1, "gen+%d culled+%d" % [MI.gen_n - gc, MI.culled - cu])
	_chk("唔加任何 Node", host.get_child_count() == 0)
	var cpos = btn.global_position + btn.size * 0.5   # 血霧前層正正蓋住呢粒掣
	cpos = t.get_viewport().get_final_transform() * cpos   # canvas_items 拉伸 → 視窗座標
	var mv = InputEventMouseMotion.new(); mv.position = cpos; mv.global_position = cpos
	Input.parse_input_event(mv); await _frames(t, 2)
	for pr in [true, false]:
		var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = pr; ev.position = cpos; ev.global_position = cpos
		Input.parse_input_event(ev)
		await _frames(t, 2)
	_chk("唔擋點擊：霧下面嘅掣照撳到", tapped.n == 1, tapped.n)
	_chk("程式冇 mouse_filter／input 處理", RegEx.create_from_string("(?m)^[^#]*(mouse_filter|func _input|func _gui_input|_unhandled)").search(src) == null)
	btn.queue_free(); host.queue_free()

	# ---------- 5. 效能：一幀畫 40 座建築 ----------
	var keys = []
	for i in 40: keys.append("perf:%d" % i)
	var sizes = [Vector2(130, 120), Vector2(150, 140), Vector2(170, 150), Vector2(110, 100)]
	MI.clear_cache()
	var gt0 = Time.get_ticks_usec()
	for i in 40: MI.prewarm(keys[i], sizes[i % 4].x * 0.6, sizes[i % 4].y * 0.6)
	var warm_ms = (Time.get_ticks_usec() - gt0) / 1000.0
	_p("預整 40 份：%.0f ms（平均 %.1f ms／份）" % [warm_ms, warm_ms / 40.0])
	_chk("整一份貼圖 < 40ms（每幀最多 %d 份）" % MI.GEN_PER_FRAME, warm_ms / 40.0 < 40.0, "%.1f" % (warm_ms / 40.0))
	var gw = MI.gen_n
	var ph = Node2D.new(); layer.add_child(ph)
	var perf = {"us": 0, "n": 0, "drawn": 0}
	ph.draw.connect(func():
		var tt = Time.get_ticks_msec() / 1000.0
		var u0 = Time.get_ticks_usec(); var d = 0
		for i in 40:
			var s = sizes[i % 4]
			var base = Vector2(45 + (i % 5) * 90, 90 + int(i / 5) * 110)
			if MI.draw(ph, keys[i], base, s.x * 0.6, s.y * 0.6, tt, false): d += 1
			if MI.draw(ph, keys[i], base, s.x * 0.6, s.y * 0.6, tt, true): d += 1
		perf.us += Time.get_ticks_usec() - u0; perf.n += 1; perf.drawn = d)
	var f0 = Engine.get_process_frames(); var tm0 = Time.get_ticks_msec()
	for k in 90: ph.queue_redraw(); await _frames(t, 1)
	var fps_on = (Engine.get_process_frames() - f0) * 1000.0 / maxf(1, Time.get_ticks_msec() - tm0)
	var per = perf.us / 1000.0 / maxf(1, perf.n)
	_p("40 座建築（80 層）每幀畫霧 CPU：%.3f ms（%d 幀平均），xvfb 軟件渲染 %.1f fps" % [per, perf.n, fps_on])
	_chk("40 座建築全部有畫（80 層）", perf.drawn == 80, perf.drawn)
	_chk("40 座建築每幀 CPU < 3ms（debug 版 GDScript）", per < 3.0, "%.3f ms" % per)
	MI.enabled = false
	f0 = Engine.get_process_frames(); tm0 = Time.get_ticks_msec()
	for k in 90: ph.queue_redraw(); await _frames(t, 1)
	var fps_off = (Engine.get_process_frames() - f0) * 1000.0 / maxf(1, Time.get_ticks_msec() - tm0)
	MI.enabled = true
	_p("對照：熄霧 %.1f fps／開霧 %.1f fps" % [fps_off, fps_on])
	_chk("快取生效：90 幀重畫冇再整", MI.gen_n == gw and MI.cache.size() == 40, "gen %d→%d cache=%d" % [gw, MI.gen_n, MI.cache.size()])
	ph.queue_free()
	for n in hid: n.visible = true
	await _frames(t, 2)

	# ---------- 6. 截圖 ----------
	if shots:
		var bg = _tex(REF + "bg_map0_tileA.png")
		var blds = []
		for nm in ["n_house", "n_store", "n_furnace", "n_rice", "n_wood"]: blds.append(_tex(REF + nm + ".webp"))
		# 擺位（底中心、闊）
		var place = [[Vector2(140, 330), 200.0], [Vector2(345, 470), 170.0], [Vector2(95, 610), 150.0], [Vector2(320, 760), 180.0], [Vector2(130, 900), 160.0]]
		var sc = Node2D.new(); layer.add_child(sc)
		sc.draw.connect(func():
			var tt = Time.get_ticks_msec() / 1000.0
			sc.draw_texture_rect(bg, Rect2(Vector2(-60, 0), Vector2(1024, 1536) * 0.66), false)
			for i in blds.size():
				var base: Vector2 = place[i][0]; var w: float = place[i][1]; var h = w * 480.0 / 520.0
				var r = Rect2(base.x - w * 0.5, base.y - h * 0.995, w, h)   # 圖底 478/480 = 地面線
				MI.draw_both(sc, "shot:%d" % i, base, w * 0.92, h, tt, blds[i], r))
		for nm in ["mist_off", "mist_on", "mist_on_t2"]:
			MI.enabled = nm != "mist_off"
			for k in (60 if nm == "mist_on_t2" else 8): sc.queue_redraw(); await _frames(t, 1)
			await RenderingServer.frame_post_draw
			var img = t.get_viewport().get_texture().get_image()
			img.save_png(SHOTS + nm + ".png")
			var c = img.get_region(Rect2i(0, 190, 300, 230)); c.resize(600, 520, Image.INTERPOLATE_BILINEAR)
			c.save_png(SHOTS + nm + "_zoom.png")
			_p("shot " + nm)
		MI.enabled = true
		sc.queue_free()
	layer.queue_free()
	MI.clear_cache()
	_p("RESULT ok=%d bad=%d" % [ok, bad])
