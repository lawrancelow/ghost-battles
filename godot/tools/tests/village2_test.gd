# [village2] 村子線 2：一級資源點（親手採／派鬼自動採／再生／舊存檔遷移）、柵欄、地面無縫、稻田／出村門暗塊
# 用法：/home/claude/setup/edtest.sh godot v2 res://tools/tests/village2_test.gd logic|all|shots
#   logic：邏輯（唔截圖）
#   shots：截圖（完整長圖＋稻田＋出村門柵欄＋親手採／自動採連續幀），輸出 /tmp/v2/shots/
#   all：logic ＋ shots
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const SHOTS := "/tmp/v2/shots/"
var ok := 0
var bad := 0

func _p(m): print("[v2] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _img(t) -> Image:
	await RenderingServer.frame_post_draw
	return t.get_viewport().get_texture().get_image()
func _shot(t, name: String):
	var im = await _img(t)
	im.save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
func _calm(t, fade := true):
	for i in 40:
		var m = _main(t); var st = m.get("story") if m else null
		if st == null or not st.busy(): break
		if st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
	if fade: await _w(t, 3.4)
func _V(): return J.G.get("Village")
func _cam(y: float) -> void: J.mc(_V(), "setCam", [y])
func _camY() -> float: return J.num(_V().get("camY"))
func N(): return J.gp(J.G.get("UI"), "_n")

func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.6)
	CB.install()
	return m

# 完整長圖：鏡頭由最頂（柵欄外）拖到最底（拓展區底），每次截村子畫面中間一段，拼成一張
func long_shot(t, m, name: String) -> Image:
	var vr0: Rect2 = m.village.get_global_rect()
	var vh = vr0.size.y / (vr0.size.x / 390.0)
	var f = 450.0 / t.get_viewport().get_visible_rect().size.x   # 畫布座標 → 截圖像素（視窗 450 闊，有拉伸）
	var vr = Rect2(vr0.position * f, vr0.size * f)
	var k = vr.size.x / 390.0
	var top = -m.mv_embed.eh() - m.mv_embed.top_extra() if m.mv_embed != null else 0.0
	var bot = maxf(1130.0, CB.world_h()) - vh
	var band0 = vh * 0.30; var band1 = vh * 0.70   # 每張只要中間一段（避開 HUD、任務條）
	var total_h = int(ceil((bot + vh - top) * k))
	var out = Image.create(int(vr.size.x), total_h, false, Image.FORMAT_RGB8)
	out.fill(Color(1, 0, 1))
	var cy = top
	var first = true
	while true:
		_cam(cy); await _w(t, 0.25)
		var real = _camY()
		var im = await _img(t)
		im.convert(Image.FORMAT_RGB8)
		var a = 0.0 if first else band0
		var b = vh if real >= bot - 0.5 else band1
		var src = Rect2i(int(vr.position.x), int(vr.position.y + a * k), int(vr.size.x), mini(int((b - a) * k) + 3, int(vr.end.y - (vr.position.y + a * k))))
		out.blit_rect(im, src, Vector2i(0, int((real - top + a) * k)))
		first = false
		if real >= bot - 0.5: break
		cy = real + (band1 - band0)
	out.save_png(SHOTS + name + ".png"); _p("long shot %s %dx%d" % [name, out.get_width(), out.get_height()])
	return out

func shots0(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	S.mv["ci"] = 2.0
	await _calm(t)
	_p("viewport %s village %s" % [t.get_viewport().get_texture().get_image().get_size(), m.village.get_global_rect()])
	_cam(-220.0); await _w(t, 1.0); await _shot(t, "q_gate")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# 重烘地面：村子（780×2260）＋拓展區（780×3200，ext 模式，世界 y 1130 起）
func bake(t) -> void:
	await _wait_boot(t)
	for which in ["main", "ext"]:
		var hh = 1130.0 if which == "main" else 1600.0
		var vp = SubViewport.new()
		vp.size = Vector2i(780, int(hh * 2)); vp.transparent_bg = false
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		var painter = Node2D.new(); painter.set_script(load("res://game/ground_painter.gd"))
		var P = {}
		for k in J.G.POS: P[k] = [J.num(J.G.POS[k][0]), J.num(J.G.POS[k][1])]
		painter.set("POS", P)
		if which == "ext":
			painter.set("ext", true); painter.set("HH", hh); painter.set("Y0", 1130.0)
			painter.set("join_tex", ImageTexture.create_from_image(Image.load_from_file(ProjectSettings.globalize_path("res://assets/img/village_ground.webp"))))
		vp.add_child(painter); t.get_tree().root.add_child(vp)
		for i in 8: await RenderingServer.frame_post_draw
		var img = vp.get_texture().get_image()
		var path = ProjectSettings.globalize_path("res://assets/img/village_ground%s.webp" % ("" if which == "main" else "_ext"))
		img.save_webp(path, false, 0.9)
		_p("baked %s %s" % [path, img.get_size()])
		vp.queue_free()
	_p("RESULT ok=1 bad=0")
