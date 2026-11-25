# 挑夫鬼（搬材料去大排檔）截圖：開局 → 村子分頁 → 有料 → 出兩隻挑夫 → 鏡頭跟住影
# 用法：edtest.sh <godot目錄> porter res://tools/tests/porter_shot.gd shots 300   → /tmp/porter/*.png ＋ 每張圖挑夫位置（porter.json）
extends RefCounted

const SHOTS := "/tmp/porter/"
const MD = preload("res://game/outpost/mv_data.gd")
func _p(m): print("[porter] ", m)
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)

func shots(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	var em = m.mv_embed; var sc = em.sc
	for sid in MD.stations(sc.sim.ci()): sc.sim.sst(sid).unlocked = true
	var M = load("res://game/outpost/mat.gd")
	for mid in ["m_bao", "m_bamboo", "m_paper", "m_rice", "m_wood"]: M.add(mid, 50)
	em.porters.clear()
	var kinds = ["youhun", "n30_jiugui", "egui"]
	var mids = []
	for sid in MD.stations(sc.sim.ci()):
		for mid in sc.sim.need(sid): if not mids.has(str(mid)): mids.append(str(mid))
	_p("mids " + str(mids))
	var E = em.eh()
	var vh = m.village.size.y / (m.village.size.x / 390.0)
	var L = MD.poly_len(em._path())
	var info = []
	for i in 3:
		em.porters.clear(); em._pt = 999.0
		var p = {"s": L * 0.45, "k": kinds[i], "mid": mids[i % maxi(mids.size(), 1)] if mids.size() else "m_bao", "back": false, "ph": 1.0 + i}
		em.porters.append(p)
		var wp = em.porter_pos(p)
		var nv = m.village; var cam = nv.zone_cam()
		for z in [nv.size.x / 390.0, nv.size.x / 390.0 * 3.0]:
			cam.z = z; cam.center_on(wp + Vector2(0, -40))
			await _w(t, 0.15)
			for f in 3:
				p.s = L * 0.45   # 定住位置
				await RenderingServer.frame_post_draw
				var fn = "%s%d_%s_z%d_%d.png" % [SHOTS, i, kinds[i], int(z), f]
				t.get_viewport().get_texture().get_image().save_png(fn)
				info.append({"f": fn, "wp": [wp.x, wp.y], "sp": [cam.w2s(wp).x, cam.w2s(wp).y], "mid": p.mid})
				await _w(t, 0.07)
	var fa = FileAccess.open(SHOTS + "porter.json", FileAccess.WRITE); fa.store_string(JSON.stringify(info)); fa.close()
	_p("RESULT ok=1 bad=0")
