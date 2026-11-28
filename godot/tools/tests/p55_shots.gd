# [p55] 前後對比截圖（舊版同新版都跑得）：大排檔告急／霸檔、野外區、鬼怪名冊
# 用法：UX_OUT=/tmp/p55/after/ edtest.sh <godot目錄> p55s res://tools/tests/p55_shots.gd all 600
extends RefCounted
const ZD = preload("res://game/zone/zone_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var OUT := "/tmp/p55/shots/"
func _p(s) -> void: print("[p55s] ", s)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String) -> void:
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(OUT + name + ".png"); _p("SHOT " + name)

func all(t) -> void:
	var eo = OS.get_environment("UX_OUT")
	if eo != "": OUT = eo
	DirAccess.make_dir_recursive_absolute(OUT)
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sc = m.mv_view; var sim = sc.sim; var nv = m.village; var cam = nv.zone_cam()
	var w = MVW.ws(); var MD = load("res://game/outpost/mv_data.gd")
	var ss = MD.stations(sim.ci())
	for i in mini(3, ss.size()): if sim.st().st.get(ss[i]) is Dictionary: sim.st().st[ss[i]]["unlocked"] = true
	w.t0 = 99999.0; w.inf[str(sim.ci())] = 10.0; w.wave_t = 9999.0
	w.alarm = {"t": 170.0}
	Engine.time_scale = 3.0
	await _w(t, 8.0)
	Engine.time_scale = 1.0
	await pf._skip(t)
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	cam.center_on(sim.st_pos(ss[0]) + Vector2(60, 60)); await _w(t, 1.0)
	await _shot(t, "market_alarm")
	w.alarm.t = 0.02
	Engine.time_scale = 4.0
	await _w(t, 6.0)
	Engine.time_scale = 1.0
	var os = MVW.occ_sid()
	if os != "": cam.center_on(sim.st_pos(os) + Vector2(40, 20))
	await _w(t, 1.0); await _shot(t, "market_occ")
	# 野外區（亂葬崗）：孤魂＋區域牌
	var wz = null
	for z in ZD.zones(): if str(z.get("type", "")) == "wild": wz = z; break
	if wz != null:
		var r = ZD.rect(wz.rect)
		cam.center_on(r.get_center() + Vector2(0, 60)); await _w(t, 1.5)
		await _shot(t, "wild")
	_p("DONE")
