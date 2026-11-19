# 生產鏈（設計線）截圖：每張圖鏡頭去最頂（隨村台喺第 2 張圖起排最尾＝圍欄邊）
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/chain_shots.gd","top"],["quit"]]
extends "res://game/outpost/mv_test.gd"

func _scenes() -> Array:
	var o = []
	for n in Engine.get_main_loop().root.find_children("*", "", true, false):
		var s = n.get_script()
		if s != null and str(s.resource_path).ends_with("mv_scene.gd"): o.append(n)
	return o
func _cam_all(y) -> void:
	for x in _scenes():
		x.cam = (x.cam_min() if y == null else y); x.cam_tgt = null; x.cam_v = 0.0; x._clamp_cam(true)

func top(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_setup()
	J.test_clock = -1.0
	var m = tt.main()
	sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvScene"
	var vil = m.get("village")
	m.add_child(sc)
	if vil != null: m.move_child(sc, vil.get_index() + 1)
	sc.setup(m)
	var sim = sc.sim
	sim.st(); sc.on_show()
	for c in range(0, 6):
		var n = D.MAPS[c].stations.size()
		_goto_map(sim, c, n, [5, 14, 26, 11, 40, 2, 9, 30])
		for x in _scenes(): if x != sc: x._after_move(false)
		await _wait(3.0); _cam_all(null); await _wait(0.5)
		_p("ci%d 場景 %d 個；台 %s" % [c, _scenes().size(), str(D.MAPS[c].stations)])
		await _shot("chain_map%d_top" % c)
		_cam_all(sim.st_pos(_sids(c)[n - 3]).y - 300.0); await _wait(0.5)
		await _shot("chain_map%d_mid" % c)
