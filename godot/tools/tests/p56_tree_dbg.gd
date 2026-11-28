# [p56] 調查：第 1 關第 4 棵槐樹（索引 3）撳完冇反應
extends "res://tools/tests/paddyfix_test.gd"
const RVq = preload("res://game/raid/raid_view.gd")

func dbg(t) -> void:
	var m = await _boot(t)
	ZD.gate_on = false
	var sc = m.mv_view
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2); await _skip(t)
	var V = J.G.get("Village"); var nv = m.village; var cam = nv.zone_cam(); var TP = J.G.TREE_POS
	for i in TP.size():
		var vr = _tree_vis(ZD.v2(TP[i]), i)
		cam.center_on(vr.get_center()); await _w(t, 0.2)
		var p = nv.zone_w2s(vr.get_center()); var w = nv.zone_s2w(p)
		var em = nv._zone_em()
		var hud = em.zone_hud_tap(p) if em != null and false else "skip"
		var eh = nv.extra_hit(p)
		var zid = ZD.zone_at(w)
		var tp = str(ZD.zone(zid).get("type", "")) if zid != "" else ""
		var ht = J.mc(V, "hitTest", [w.x, w.y])
		_p("tree %d pos=%s w=%s extra=%s zone=%s(%s) hit=%s" % [i, str(TP[i]), str(w), eh, zid, tp, str(ht)])
	for i in [2, 3]:
		_reset_hero(V)
		var vr = _tree_vis(ZD.v2(TP[i]), i)
		cam.center_on(vr.get_center()); await _w(t, 0.3)
		_unblock(m)
		var p = nv.zone_w2s(vr.get_center()); var w = nv.zone_s2w(p)
		var em = nv._zone_em()
		var a = em.zone_hud_tap(p) if em != null else false
		var b = false; var c = false
		if not a: b = RVq.tap(m, w)
		if not a and not b: c = ZV.tap(m, w)
		if not a and not b and not c: J.mc(V, "tap", [w.x, w.y])
		await _w(t, 0.3)
		_p("tap tree %d hud=%s raid=%s zv=%s hero=%s tgt=%s act=%s walk=%s" % [i, a, b, c, str([V.hero.x, V.hero.y]), str(V.hero.get("target")), str(V.hero.get("act")), str(V.hero.get("tx"))])
	_p("RESULT ok=0 bad=0")
