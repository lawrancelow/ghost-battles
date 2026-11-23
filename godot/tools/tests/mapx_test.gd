# [mapx] 野外分圈擴展測試（六關）
# 用法：/home/claude/setup/edtest.sh <godot目錄> mapx res://tools/tests/mapx_test.gd logic|all <秒>
#   logic：每圈據點數、等級遞增、可達（路線沿可走路）、行軍 ≤ 40 秒（rts 行軍速度）、不重疊、黑霧分圈、ring_key 開下一圈、舊存檔
#   all：logic ＋ 截圖（/home/claude/docs/mapx_shots/：六關全景＋各圈近景＋黑霧）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/mapx_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const ZR = preload("res://game/zone/zone_rings.gd")
const CW = preload("res://game/outpost/ctl_walk.gd")
const SIM = preload("res://game/rts/rts_sim.gd")

func _p(m): print("[mapx] ", m)
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
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _goto(t, m, c: int) -> void:
	var sc = m.mv_view
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2)
func _cam(m, p: Vector2, z := -1.0) -> void:
	var nv = m.village; var cam = nv.zone_cam()
	cam.vel = Vector2.ZERO; cam.tgt = null
	cam.z = nv.size.x / 390.0 if z < 0 else z
	cam.clamp_all(); cam.center_on(p)

func logic(t) -> void: await _run(t, false)
func all(t) -> void: await _run(t, true)

func _run(t, shots: bool) -> void:
	var m = await _boot(t)
	var S = J.G.S
	var zst = ZD.st()
	var bak_rings = (zst.get("rings", {}) as Dictionary).duplicate(true) if zst.get("rings") is Dictionary else {}
	ZD.gate_on = false
	for c in 6:
		await _goto(t, m, c)
		_data_check(c)
		if shots: await _shots(t, m, c)
	await _fog_check(t, m, shots)
	_migrate_check()
	ZD.gate_on = false
	zst["rings"] = bak_rings
	await _goto(t, m, 0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _plen(pts: Array) -> float:
	var L = 0.0
	for i in pts.size() - 1: L += ZD.v2(pts[i]).distance_to(ZD.v2(pts[i + 1]))
	return L

# ================= 1. 資料（每關）：圈、據點、可達、行軍、重疊 =================
func _data_check(c: int) -> void:
	var tag = "第%d關 " % (c + 1)
	var rs = ZD.rings(c); var so = ZD.sorties(c)
	_chk(tag + "分 4 圈（近郊→荒野→深處→最外圈）", rs.size() == 4 and str(rs[0].key) == "outskirt" and str(rs[3].key) == "peaks", rs.size())
	var core = Rect2(Vector2.ZERO, ZD.world_size(c)); var bb = ZD.bounds(c)
	_chk(tag + "地圖邊界擴大（核心地圖完整喺入面）", bb.encloses(core) and bb.size.x > core.size.x + 2000 and bb.size.y > core.size.y + 2000, [core, bb])
	var lv_prev = 0; var cnt = []; var lv_ok = true; var key_ok = true
	for k in range(1, 5):
		var rr = so.filter(func(s): return int(s.ring) == k)
		cnt.append(rr.size())
		var lo = 999; var hi = 0
		for s in rr: lo = mini(lo, int(s.lv)); hi = maxi(hi, int(s.lv))
		if lo <= lv_prev: lv_ok = false
		lv_prev = hi
		var nk = rr.filter(func(s): return J.t(s.get("ring_key"))).size()
		if nk != (1 if k < 4 else 0): key_ok = false
		if k < 4 and ZD.ring_key(k, c) == "": key_ok = false
	_chk(tag + "每圈 3～5 個據點", cnt.all(func(n): return n >= 3 and n <= 5), cnt)
	_chk(tag + "等級隨圈遞增", lv_ok, so.map(func(s): return int(s.lv)))
	var lv0 = int(so[0].lv) if so.size() else 0
	_chk(tag + "等級範圍（第1關 Lv1～12，每關 +10）", lv0 == 1 + c * 10 and int(so[so.size() - 1].lv) == 12 + c * 10, [lv0, so[so.size() - 1].lv if so.size() else 0])
	_chk(tag + "每圈（最外圈除外）一個 ring_key", key_ok)
	# 位置：喺自己嗰圈、唔重疊、唔遮地貌散件
	var pos_ok = true; var ov_ok = true; var prop_ok = true; var bad_l = []
	for s in so:
		var p = ZD.v2(s.pos)
		if ZD.ring_at(p, c) != int(s.ring): pos_ok = false; bad_l.append(s.id)
		for s2 in so:
			if s2 != s and p.distance_to(ZD.v2(s2.pos)) < 200.0: ov_ok = false
		for e in ZD.ring_props(c):
			if p.distance_to(Vector2(float(e[1]), float(e[2]))) < 100.0: prop_ok = false
	_chk(tag + "據點喺自己嗰圈入面", pos_ok, bad_l)
	_chk(tag + "據點互相唔重疊（≥200）", ov_ok)
	_chk(tag + "據點唔遮地貌散件（≥100）", prop_ok)
	# 可達＋行軍時間：路線由村門出發；核心地圖段每 8px 抽樣要喺可走區（ctl_walk.region），出咗核心之後要喺圈帶
	var reach_ok = true; var t_ok = true; var tmax = 0.0; var far = ""; var bad_r = []
	var gate = ZD.v2(ZD.mdef(c).village.POS.gate)
	for s in so:
		var rt: Array = s.route
		if ZD.v2(rt[0]).distance_to(gate) > 140.0 or ZD.v2(rt[rt.size() - 1]).distance_to(ZD.v2(s.pos)) > 1.0: reach_ok = false; bad_r.append([s.id, "頭尾"])
		for i in rt.size() - 1:
			var a = ZD.v2(rt[i]); var b = ZD.v2(rt[i + 1])
			var n = maxi(1, int(a.distance_to(b) / 8.0))
			for j in n + 1:
				var q = a.lerp(b, float(j) / n)
				var ra = ZD.ring_at(q, c)
				if ra == 0:
					if CW.region(q) == "":
						reach_ok = false; bad_r.append([s.id, q]); break
				elif ra < 0: reach_ok = false; bad_r.append([s.id, "出界", q]); break
		var sec = _plen(rt) / SIM.MARCH
		if sec > tmax: tmax = sec; far = str(s.id)
		if sec > 40.0: t_ok = false
	_chk(tag + "路線可達（核心段沿可走區、出咗核心喺圈帶）", reach_ok, bad_r.slice(0, 3))
	_chk(tag + "最遠據點行軍 ≤ 40 秒（rts 行軍速度 %d px/s）" % int(SIM.MARCH), t_ok, "%s %.1f 秒" % [far, tmax])
	# 地貌：每圈都有散件，荒野／深處／最外圈用新地貌圖 tr_*
	var per = [0, 0, 0, 0, 0]; var tr = [0, 0, 0, 0, 0]
	for e in ZD.ring_props(c):
		per[int(e[5])] += 1
		if str(e[0]).begins_with("tr_"): tr[int(e[5])] += 1
	_chk(tag + "每圈有點綴散件；荒野／深處／最外圈新地貌圖只做點綴（≤60 件）", per[1] > 20 and per[2] > 20 and per[3] > 20 and per[4] > 20 and tr[2] >= 5 and tr[3] >= 5 and tr[4] >= 5 and tr[1] == 0 and tr[2] + tr[3] + tr[4] <= 60, [per, tr])
	var tex_ok = true
	for k in ["tr_wood_deadtrees", "tr_wood_log", "tr_wood_thorn", "tr_wood_fence", "tr_ruin_arch", "tr_ruin_wall", "tr_swamp_pool", "tr_swamp_roots", "tr_mt_rocks", "tr_mt_pine_cliff", "tr_mt_bridge", "tr_mt_watchpost"]:
		if not Spr.ok(k): tex_ok = false
	if c == 0: _chk("新地貌圖 12 張載入得", tex_ok)
	var gp = "res://assets/img/mapx_ground_%d.webp" % c
	var gt = load(gp) if ResourceLoader.exists(gp) else null
	var bb2 = ZD.bounds(c)
	_chk(tag + "瓦片地面烘圖載入、大細啱 ext（×0.5）", gt != null and absf(gt.get_width() - bb2.size.x * 0.5) <= 2 and absf(gt.get_height() - bb2.size.y * 0.5) <= 2, [gt.get_size() if gt else null, bb2.size])

# ================= 2. 黑霧分圈 =================
func _fog_check(t, m, shots: bool) -> void:
	await _goto(t, m, 0)
	var zst = ZD.st()
	ZD.gate_on = true
	zst["rings"] = {}
	_chk("新開局：近郊開", ZD.ring_open(1))
	_chk("新開局：荒野／深處／最外圈未開", not ZD.ring_open(2) and not ZD.ring_open(3) and not ZD.ring_open(4))
	var k1 = ZD.ring_key(1)
	var non = ""
	for s in ZD.sorties(): if int(s.ring) == 1 and not J.t(s.ring_key): non = str(s.id); break
	_chk("打低近郊非關鍵據點：荒野唔開", not ZD.sortie_won(non) and not ZD.ring_open(2))
	var r2 = ZD.sorties().filter(func(s): return int(s.ring) == 2)[0]
	_chk("荒野據點未散霧（sortie_open＝false）", not ZD.sortie_open(str(r2.id)))
	# 畫面：鏡頭對住荒野據點 → 有第 2 圈黑霧
	_cam(m, ZD.v2(r2.pos), m.village.size.x / 390.0 * 0.5); await _w(t, 0.6)
	var fogs = ZR.log.filter(func(e): return e[0] == "fog").map(func(e): return e[1])
	_chk("未開：荒野畫黑霧", fogs.has(2), ZR.log)
	if shots: await _shot(t, "fog_m1_ring2_locked")
	_chk("打低近郊關鍵據點 %s：荒野散霧" % k1, ZD.sortie_won(k1) and ZD.ring_open(2) and not ZD.ring_open(3))
	_chk("荒野據點已散霧（sortie_open＝true）", ZD.sortie_open(str(r2.id)))
	await _w(t, 2.2)
	fogs = ZR.log.filter(func(e): return e[0] == "fog").map(func(e): return e[1])
	_chk("散霧後：荒野冇黑霧", not fogs.has(2), ZR.log)
	if shots: await _shot(t, "fog_m1_ring2_open")
	_chk("重複打關鍵據點唔會再開", not ZD.sortie_won(k1))
	_chk("深處關鍵據點開最外圈（順序開）", ZD.sortie_won(ZD.ring_key(2)) and ZD.ring_open(3) and ZD.sortie_won(ZD.ring_key(3)) and ZD.ring_open(4))
	_chk("各關分開記", not ZD.ring_open(2, 1))
	# 全景：只開近郊
	zst["rings"] = {}
	var cam = m.village.zone_cam()
	cam.vel = Vector2.ZERO; cam.tgt = null; cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(ZD.bounds().get_center()); await _w(t, 0.8)
	if shots: await _shot(t, "fog_m1_overview_start")
	ZD.gate_on = false

# ================= 3. 舊存檔 =================
func _migrate_check() -> void:
	var s = {"mv": {"ci": 2.0}, "qi": 6.0, "lv": 5.0, "cleared": {"1-1": 1}}
	var z = {"own": {}, "boss": {}}
	ZD._migrate4(s, z)
	_chk("舊存檔（有進度）：已去過嘅關近郊＋荒野直接開", int(z.rings.get("0", 0)) == 2 and int(z.rings.get("1", 0)) == 2 and int(z.rings.get("2", 0)) == 2, z.rings)
	_chk("舊存檔：未去到嘅關唔送", not z.rings.has("3"), z.rings)
	var s2 = {"mv": {"ci": 0.0}, "qi": 0.0, "lv": 1.0}
	var z2 = {"own": {}, "boss": {}}
	ZD._migrate4(s2, z2)
	_chk("新玩家：唔送（只開近郊）", (z2.rings as Dictionary).is_empty(), z2.rings)
	_chk("遷移版本 mig＝4", int(J.num(z2.get("mig"))) == 4)

# ================= 4. 截圖 =================
func _shots(t, m, c: int) -> void:
	var nv = m.village; var cam = nv.zone_cam()
	cam.vel = Vector2.ZERO; cam.tgt = null
	cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(ZD.bounds().get_center()); await _w(t, 1.0)
	_chk("第%d關全景：鏡頭睇得晒擴大後成張圖" % (c + 1), cam.rect().grow(4).encloses(ZD.bounds()) or (cam.vw() >= ZD.bounds().size.x - 2 or cam.vh() >= ZD.bounds().size.y - 2), [cam.rect(), ZD.bounds()])
	await _shot(t, "m%d_overview" % (c + 1))
	for k in range(1, 5):
		var s = ZD.sorties(c).filter(func(s): return int(s.ring) == k)[0]
		_cam(m, ZD.v2(s.pos), nv.size.x / 390.0 * 0.55); await _w(t, 0.6)
		var np = 0
		for e in ZR.log: if e[0] == "props": np = int(e[2])
		var gdraw = ZR.log.filter(func(e): return e[0] == "ground").size()
		_chk("第%d關第%d圈近景：瓦片地面一次畫、散件只畫鏡頭入面（%d 件）" % [c + 1, k, np], gdraw == 1 and np < ZD.ring_props(c).size() / 2, [gdraw, np])
		await _shot(t, "m%d_ring%d" % [c + 1, k])
