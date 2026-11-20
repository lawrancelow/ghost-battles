# [zone] 分區地圖測試（第 1 關）
# 用法：/home/claude/setup/edtest.sh <godot目錄> zone res://tools/tests/zone_test.gd logic|all|bake|smoke
#   bake：烘地面圖 assets/img/zone1_ground_a/_b.webp（1.5 倍）
#   logic：布局冇重疊、建築喺所屬區內、路徑可達、攻佔流程、加工廠只可建喺所屬區、舊存檔遷移、拖動縮放邊界、點擊唔誤觸、野外王／拔營
#   all：logic ＋ 截圖（/tmp/zone/shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/zone/shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const ZW = preload("res://game/zone/zone_walk.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const CF = preload("res://game/outpost/chain_field.gd")

func _p(m): print("[zone] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
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
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _V(): return J.G.get("Village")

# ================= 烘地面 =================
func bake(t) -> void:
	var m = ZD.mdef(0); var K = 1.5
	var W = float(m.w); var H = float(m.h)
	var key = str(m.ground)
	for half in 2:
		var vp = SubViewport.new()
		vp.size = Vector2i(int(W * K), int(ceil(H / 2.0 * K))); vp.transparent_bg = false
		vp.render_target_update_mode = SubViewport.UPDATE_ONCE
		var pn = Node2D.new(); pn.set_script(load("res://game/zone/zone_ground.gd"))
		pn.M = m; pn.K = K; pn.Y0 = H / 2.0 * half
		vp.add_child(pn); t.get_tree().root.add_child(vp)
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var im = vp.get_texture().get_image()
		var path = ProjectSettings.globalize_path("res://assets/img/%s_%s.webp" % [key, "a" if half == 0 else "b"])
		im.save_webp(path, true, 0.82)
		_p("baked %s %s" % [path, im.get_size()])
		vp.queue_free()
	_p("RESULT ok=1 bad=0")

# ================= 冒煙：開機截幾張 =================
func smoke(t) -> void:
	var m = await _boot(t)
	var nv = m.village
	_p("zone on=%s applied=%s size=%s" % [ZD.on(), ZD.applied(), nv.size])
	var c = nv.zone_cam()
	await _w(t, 1.0); await _shot(t, "smoke_home")
	_p("dbg under vis=%s tree=%s over=%s hits=%d owned A=%s idx=%d/%d" % [nv.zone_under.visible, nv.zone_under.is_visible_in_tree(), nv.zone_over.visible, ZV.hits.size(), ZD.owned("A"), nv.zone_under.get_index(), nv.world.get_child_count()])
	_p("dbg parent=%s world_in_tree=%s same=%s" % [nv.zone_under.get_parent(), nv.world.is_inside_tree(), nv.zone_under.get_parent() == nv.world])
	for ch in nv.world.get_children(): _p("  child %s %s vis=%s" % [ch.name, ch.get("tag"), ch.visible])
	c.z = c.z_min(); c.clamp_all(); c.center_on(Vector2(670, 1200)); await _w(t, 0.6); await _shot(t, "smoke_min")
	c.z = nv.size.x / 390.0; c.center_on(Vector2(670, 760)); await _w(t, 1.5); await _shot(t, "smoke_market")
	c.center_on(Vector2(670, 250)); await _w(t, 0.6); await _shot(t, "smoke_wild")
	c.center_on(Vector2(200, 1500)); await _w(t, 0.6); await _shot(t, "smoke_A")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
