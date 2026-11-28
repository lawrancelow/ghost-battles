# [roster_scroll] 補丁 55：鬼怪名冊拖動捲動＋頭像
#   1. 手指撳喺卡／掣上面拖：超過門檻即捲（捲動距離≈拖動距離），放手唔會觸發個掣
#   2. 快拖放手有慣性（放手後仲繼續捲）
#   3. 冇拖（原地撳）照舊觸發掣
#   4. 名冊頭像放大（≥ 90px）；全部名鬼（S2.list）頭像裁位喺圖入面、塊面喺上半（自動搵面），截圖見 por_sheet
# 用法：/home/claude/setup/edtest.sh <godot目錄> roster_scroll res://tools/tests/roster_scroll_test.gd all 600
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/roster_scroll/shots/"
func _p(m): print("[roster_scroll] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

var vp: Viewport
func _btn(p: Vector2, down: bool) -> void:
	var e = InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = down; e.position = p; e.global_position = p
	e.button_mask = MOUSE_BUTTON_MASK_LEFT if down else 0
	vp.push_input(e, true)
func _move(p: Vector2, rel: Vector2) -> void:
	var e = InputEventMouseMotion.new(); e.position = p; e.global_position = p; e.relative = rel; e.button_mask = MOUSE_BUTTON_MASK_LEFT
	vp.push_input(e, true)
func _drag(t, p0: Vector2, dy: float, steps: int, frames_per := 1) -> void:
	_btn(p0, true); await _f(t)
	var p = p0
	for i in steps:
		var np = p + Vector2(0, dy / steps); _move(np, np - p); p = np
		await _f(t, frames_per)
	_btn(p, false); await _f(t)

func _buttons(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Button and c.is_visible_in_tree() and not c.disabled: out.append(c)
		_buttons(c, out)

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = t.get_tree().root.get_node_or_null("Main")
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.0)
	var m = t.get_tree().root.get_node_or_null("Main")
	m._hide_title(); await _w(t, 1.0)
	for i in 8:
		var st = m.get("story")
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
	vp = t.get_viewport()
	var S = J.G.S
	var ks = ["n30_qionggui", "n30_danxiao", "n30_maoshi", "n30_yangui", "n30_jiugui", "n30_dugui", "nw_huli", "nw_kappa" if false else "n30_kappa", "n30_hannya", "nw_toutai"]
	for i in ks.size():
		S.ghosts.append({"id": "t_rs%d" % i, "k": ks[i], "name": "測試%d" % i, "q": "藍", "lv": 3.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	var Menus = load("res://ui/menus/menus.gd")
	Menus.open_roster(); await _w(t, 1.2)
	var sc: ScrollContainer = m.sheet_scroll
	_chk("名冊打開、可以捲（內容高過畫面）", m.sheet.visible and sc.get_v_scroll_bar().max_value > sc.size.y + 200.0, [sc.get_v_scroll_bar().max_value, sc.size.y])
	await _shot(t, "roster_top")
	# 頭像大細
	var pors = []
	var fn = func(n, rec):
		for c in n.get_children():
			if c is TextureRect and c.texture is AtlasTexture: pors.append(c)
			elif c.get_script() != null and str(c.get_script().resource_path).ends_with("ace_frame.gd"): pors.append(c)
			rec.call(c, rec)
	fn.call(m.sheet_body, fn)
	var big = pors.filter(func(c): return c.custom_minimum_size.x >= 90.0 or c.size.x >= 90.0)
	_chk("名冊頭像放大（≥ 90px，原本 60）", pors.size() > 0 and big.size() >= mini(pors.size(), ks.size()), [pors.size(), big.size()])
	# 1. 撳喺掣上面拖
	var bs = []; _buttons(m.sheet_body, bs)
	var sr = sc.get_global_rect()
	var target: Button = null
	for b in bs:
		var r = b.get_global_rect()
		if r.position.y > sr.position.y + 260.0 and r.end.y < sr.end.y - 40.0: target = b; break
	_chk("搵到卡上面嘅掣做拖動起點", target != null, bs.size())
	if target == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	var fired = [0]
	var cb = func(): fired[0] += 1
	target.pressed.connect(cb)
	var p0 = target.get_global_rect().get_center()
	sc.scroll_vertical = 0; await _f(t, 2)
	var v0 = sc.scroll_vertical
	await _drag(t, p0, -240.0, 12, 2)
	await _w(t, 0.05)
	var moved = sc.scroll_vertical - v0
	_chk("撳住掣向上拖 240：名冊捲落（≈ 拖動距離）", moved >= 200, moved)
	_chk("拖完放手：個掣冇觸發", fired[0] == 0, fired[0])
	await _w(t, 0.6)
	# 2. 慣性：快拖
	sc.scroll_vertical = 0; await _w(t, 0.3)
	var pb = Vector2(sr.get_center().x, sr.position.y + sr.size.y * 0.7)
	await _drag(t, pb, -160.0, 4, 1)
	var after_rel = sc.scroll_vertical
	await _w(t, 0.5)
	_chk("快拖放手有慣性（放手後繼續捲）", sc.scroll_vertical > after_rel + 20, [after_rel, sc.scroll_vertical])
	await _shot(t, "roster_scrolled")
	# 3. 原地撳掣照觸發（揀「一鍵穿戴」呢類唔會開新畫面嘅掣都得，淨係數 pressed）
	await _w(t, 1.0)
	sc.scroll_vertical = 0; await _f(t, 3)
	bs = []; _buttons(m.sheet_body, bs)
	var tb: Button = null
	for b in bs:
		var r = b.get_global_rect()
		if r.position.y > sr.position.y + 200.0 and r.end.y < sr.end.y - 20.0: tb = b; break
	if tb != null:
		var f2 = [0]; tb.pressed.connect(func(): f2[0] += 1)
		var c = tb.get_global_rect().get_center()
		_btn(c, true); await _f(t, 2); _move(c + Vector2(0, 4), Vector2(0, 4)); await _f(t); _btn(c + Vector2(0, 4), false); await _f(t, 2)
		_chk("原地撳（郁咗 4px，未過門檻）：掣照觸發", f2[0] == 1, [f2[0], tb.text, tb.get_global_rect()])
	else: _chk("搵到原地撳嘅掣", false)
	# 4. 全部名鬼頭像裁位
	var badc = []
	for x in load("res://game/soul/soul2.gd").list():
		var k = str(x.k); var r = Art.portrait_region(k)
		if r.size() < 2: continue
		var img: Texture2D = r[0]; var rc: Rect2 = r[1]
		var iw = float(img.get_width()); var ih = float(img.get_height())
		if rc.size.x <= 4.0 or rc.position.x < -0.5 or rc.position.y < -0.5 or rc.end.x > iw + 0.5 or rc.end.y > ih + 0.5 or rc.get_center().y > ih * 0.7: badc.append([k, rc, iw, ih])
	_chk("全部名鬼頭像：裁位喺圖入面、中心喺上半（塊面）", badc.is_empty(), badc.slice(0, 6))
	_p("RESULT ok=%d bad=%d" % [ok, bad])
