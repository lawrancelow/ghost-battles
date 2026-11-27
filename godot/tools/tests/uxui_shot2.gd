# [uxui] 出擊＋告急＋招牌菜＋技能鈕 同場：重現老闆截圖嘅介面打架
extends RefCounted
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const T0 = preload("res://tools/tests/sortie_test.gd")
var OUT := "/tmp/uxui/shots/"
func _p(m): print("[uxui2] ", m)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String) -> void:
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(OUT + name + ".png"); _p("shot " + name)
func all(t) -> void:
	var eo = OS.get_environment("UX_OUT")
	if eo != "": OUT = eo
	DirAccess.make_dir_recursive_absolute(OUT)
	var T = T0.new()
	var m = await T._boot(t)
	await T._prep(t, m)
	SO.force_open = true; SO.test_now = 1000000.0
	T._rich()
	var S = J.G.S
	var hid = S.ghosts[0].id
	if not S.team.has(hid): S.team[0] = hid
	for g in S.ghosts:
		if S.team.size() < 3 and not S.team.has(g.id): S.team.append(g.id)
	var gate = RTS.gate_pos()
	var mk = ZD.zrect("market").get_center() if ZD.zrect("market").size.x > 0 else gate + Vector2(0, -260)
	var H = J.G.Village.hero; H["x"] = mk.x; H["y"] = mk.y + 120; H["tx"] = H.x; H["ty"] = H.y
	m.village.zone_cam().center_on(mk + Vector2(0, 160)); await _w(t, 0.6)
	# 告急
	var sc = m.mv_view; var sim = sc.sim
	var ws = MVW.ws(); ws.t0 = 99999.0; ws.inf[str(sim.ci())] = 10.0
	await _w(t, 1.5)
	await _shot(t, "s_alarm")
	var e = SO.camps()[0]
	SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	if op != null:
		for i in 400:
			RTS._last_f = -1; RTS.tick(0.1)
			if op.phase == "fight": break
	await _w(t, 0.8)
	await _shot(t, "s_fight")
	_p("phase " + (str(op.phase) if op != null else "none"))
	_p("DONE")
