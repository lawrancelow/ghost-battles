# [landmark] 地標測試：無名義山、破塔樓（六關）
# 用法：/home/claude/setup/edtest.sh <godot目錄> landmark res://tools/tests/landmark_test.gd logic|all|survey <秒>
#   logic：資料／布局（六關）、解鎖條件、黑霧、撳地標開啱嘅卡、入舊玩法＋返地標旁邊、第一次劇情（一次、女主版）、
#          舊存檔升級、拔營跟住搬、行動目標登記、紅點、棟篤笑提示
#   all：logic ＋ 截圖（/home/claude/docs/landmark_shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/landmark_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const ZW = preload("res://game/zone/zone_walk.gd")
const LM = preload("res://game/zone/landmark.gd")
const LA = preload("res://game/zone/landmark_art.gd")
const AT = preload("res://game/outpost/act_targets.gd")
const MS = preload("res://game/outpost/mv_story.gd")

func _p(m): print("[landmark] ", m)
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
	cam.vel = Vector2.ZERO
	cam.z = nv.size.x / 390.0 if z < 0 else z
	cam.center_on(p)
func _spr_rect(key: String, x: float, y: float, w: float) -> Rect2:
	var tx = Spr.get_tex(key) if Spr.ok(key) else null
	var h = w * tx.get_height() / tx.get_width() if tx != null else w
	return Rect2(x - w / 2.0, y + 6.0 - h, w, h)
func _qidx(tp: String, key: String) -> int: return ZD._qidx(tp, key)
func _solid_in(r: Rect2) -> bool:   # 呢個範圍有冇大山實色（每 5 點抽樣）
	var a = LM.at("hill")
	if not r.intersects(LM.art_rect("hill")): return false
	var y = r.position.y
	while y <= r.end.y:
		var x = r.position.x
		while x <= r.end.x:
			if LA.solid("hill", a, Vector2(x, y)): return true
			x += 5.0
		y += 5.0
	return false
# 截圖：村子全景（看到村＋山）、無名義山近景、破塔樓近景
func _shot_map(t, m, c: int) -> void:
	var nv = m.village; var cam = nv.zone_cam()
	m.close_sheet()
	var vr = ZD.zrect("village"); var hr = LM.art_rect("hill")
	var box = vr.merge(hr)
	cam.vel = Vector2.ZERO
	cam.z = maxf(cam.z_min(), minf(nv.size.x / (box.size.x + 40.0), nv.size.y * 0.78 / (box.size.y + 40.0)))
	cam.center_on(box.get_center() + Vector2(0, -30)); await _w(t, 1.0); await _shot(t, "m%d_pano" % (c + 1))
	_cam(m, hr.get_center() + Vector2(0, 10), nv.size.x / 470.0); await _w(t, 0.8); await _shot(t, "m%d_hill" % (c + 1))
	_cam(m, hr.get_center() + Vector2(0, 0), nv.size.x / 300.0); await _w(t, 0.8); await _shot(t, "m%d_hill_near" % (c + 1))
	if LM.has("tower"):
		_cam(m, LM.at("tower") + Vector2(0, -70)); await _w(t, 0.8); await _shot(t, "m%d_tower" % (c + 1))
	var qr = LM.art_rect("zhiqian")
	_cam(m, qr.get_center() + Vector2(0, 10), nv.size.x / 470.0); await _w(t, 0.8); await _shot(t, "m%d_zhiqian" % (c + 1))

func survey(t) -> void:
	var m = await _boot(t)
	var nv = m.village; var cam = nv.zone_cam()
	for c in 6:
		await _goto(t, m, c)
		cam.vel = Vector2.ZERO
		cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(ZD.world_size() / 2); await _w(t, 1.0); await _shot(t, "survey_m%d" % (c + 1))
	_p("RESULT ok=1 bad=0")

func logic(t) -> void: await _run(t, false)
func all(t) -> void: await _run(t, true)

func _run(t, shots: bool) -> void:
	var m = await _boot(t)
	var S = J.G.S
	var bak = {"qi": S.get("qi"), "cleared": (S.get("cleared", {}) as Dictionary).duplicate(true), "lm": S.get("lm"), "seen": (S.get("seen", {}) as Dictionary).duplicate(true),
		"visit": (S.get("visit", {}) as Dictionary).duplicate(true), "hero": (S.get("hero", {}) as Dictionary).duplicate(true)}
	await _data_check(t, m)
	await _maps_check(t, m, shots)
	await _unlock_check(t, m, shots)
	await _card_check(t, m, shots)
	await _story_check(t, m, shots)
	await _return_check(t, m)
	await _migrate_check(t, m)
	await _misc_check(t, m)
	await _zq_check(t, m, shots)
	ZD.gate_on = false; MS.auto_on = false; LM.go_fn = Callable()
	S["qi"] = bak.qi; S["cleared"] = bak.cleared; S["seen"] = bak.seen; S["visit"] = bak.visit; S["hero"] = bak.hero
	if bak.lm == null: S.erase("lm")
	else: S["lm"] = bak.lm
	await _goto(t, m, 0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 1. 資料／布局（六關） =================
func _data_check(_t, _m) -> void:
	var hill_all = true; var tower_ok = true
	for c in 6:
		if LM.zone_of("hill", c).is_empty(): hill_all = false
		var tw = LM.zone_of("tower", c)
		if (c == 0) != tw.is_empty(): tower_ok = false
	_chk("六關都有無名義山（拔營跟住搬：每關村邊一座）", hill_all)
	_chk("破塔樓：第 1 關冇，第 2–6 關每關一座", tower_ok)
	var tx = load(LA.ART.hill.png)
	_chk("無名義山用大圖 lm_hill_big（1314×867）、舊細圖唔入包", tx != null and tx.get_width() == 1314 and tx.get_height() == 867 and not ResourceLoader.exists("res://assets/spr/lm_hill.webp"))
	var hw = LA.size_of("hill").x
	_chk("無名義山闊＝3.5～4 棟民宅（民宅 104）", hw >= 104 * 3.5 and hw <= 104 * 4.0, hw)
	for c in 6:
		var tag = "第 %d 關：" % (c + 1)
		var vr = ZD.zrect("village", c)
		var ar = LM.art_rect("hill", c)
		var ws = Vector2(float(ZD.mdef(c).w), float(ZD.mdef(c).h))
		_chk(tag + "無名義山圖成幅喺地圖入面（唔裁切）", Rect2(Vector2(-1, -1), ws + Vector2(2, 2)).encloses(Rect2(ar.position, ar.size - Vector2(0, 10))), [ar, ws])
		var dx = maxf(0.0, maxf(vr.position.x - ar.end.x, ar.position.x - vr.end.x)); var dy = maxf(0.0, maxf(vr.position.y - ar.end.y, ar.position.y - vr.end.y))
		_chk(tag + "無名義山喺村邊（距離村 ≤ 200）", Vector2(dx, dy).length() <= 200.0, Vector2(dx, dy).length())
		var ovh = []
		for z in ZD.zones(c): if not (str(z.type) in ["landmark", "village"]) and ZD.rect(z.rect).intersects(ar.grow(-2)): ovh.append(str(z.id))
		_chk(tag + "無名義山唔疊資源區／大排檔／野外", ovh.is_empty(), ovh)
		_chk(tag + "無名義山解鎖＝主線 1-2", str(LM.zone_of("hill", c).get("unlock", {}).get("quest_done", [])) == str(["stage", "1-2"]))
		var blkh = []
		for b in ZD.mdef(c).get("barriers", []):
			if str(b.k) in ["void", "cliff"]:
				for r in b.rects: if ZD.rect(r).intersects(Rect2(ar.position + Vector2(0, ar.size.y * 0.55), Vector2(ar.size.x, ar.size.y * 0.45 - 10)).grow(-2)): blkh.append(r)
		_chk(tag + "山腳挖咗虛空／山岩（之後主角行得到）", blkh.is_empty(), blkh)
		var ring = LM.zone_of("hill", c).get("ring", [])
		var bad_r = []
		for e in ring:
			var q = Vector2(float(e[1]), float(e[2]))
			for z in ZD.zones(c): if str(z.type) != "landmark" and ZD.rect(z.rect).has_point(q): bad_r.append([e[0], z.id])
		_chk(tag + "山腳外圍亂葬崗道具 ≥ 12 件、唔入村／其他區", ring.size() >= 12 and bad_r.is_empty(), [ring.size(), bad_r])
		var keys = {}
		for e in ring: keys[str(e[0])] = 1
		_chk(tag + "外圍道具用現有墳／碑／石／骨等（唔係一種）", keys.size() >= 5 and (keys.has("grave")) and keys.has("proc:bones"), keys.keys())
		var fr = ZD.rect(LM.zone_of("hill", c).rect); var enc = fr.encloses(Rect2(ar.position, ar.size - Vector2(0, 10)))
		for e in ring: if not fr.grow(2).has_point(Vector2(float(e[1]), float(e[2]))): enc = false
		_chk(tag + "黑霧範圍包住山＋外圍", enc)
		if c == 0: continue
		var tz = LM.zone_of("tower", c); var tr = ZD.rect(tz.rect)
		_chk(tag + "破塔樓圖喺自己區入面", tr.encloses(LM.art_rect("tower", c)), [tr, LM.art_rect("tower", c)])
		var ov = []
		for z in ZD.zones(c): if str(z.type) != "landmark" and ZD.rect(z.rect).intersects(tr): ov.append(str(z.id))
		_chk(tag + "破塔樓區唔疊其他區", ov.is_empty(), ov)
		_chk(tag + "破塔樓解鎖＝到埗睇完開場劇情", J.t(tz.get("unlock", {}).get("enter")))
		var blk = []
		var bars = ZD.mdef(c).get("barriers", [])
		for b in bars:
			if str(b.k) in ["void", "cliff"]:
				for r in b.rects: if ZD.rect(r).intersects(tr.grow(-2)): blk.append(r)
		_chk(tag + "破塔樓空地冇虛空／山岩（之後主角行得過去）", blk.is_empty(), blk)
		var sce = []
		for s in ZD.mdef(c).get("scenery", []): if tr.grow(40).has_point(Vector2(float(s[1]), float(s[2]))): sce.append(s[0])
		_chk(tag + "破塔樓空地冇區外佈景", sce.is_empty(), sce)

# 每關：套用、靜態圖跟住搬、布局唔撞建築／樹／田／路、撳開啱嘅卡
func _maps_check(t, m, shots: bool) -> void:
	var nv = m.village
	ZD.gate_on = false
	for c in 6:
		await _goto(t, m, c)
		var tag = "第 %d 關：" % (c + 1)
		var POS = J.G.get("POS")
		var hr = LM.art_rect("hill")
		var hit = []
		for k in POS:
			if k == "gate": continue
			var r = _spr_rect(k, J.num(POS[k][0]), J.num(POS[k][1]), float(Art.BW.get(k, 100)))
			if _solid_in(Rect2(r.position.x + r.size.x * 0.1, r.position.y + r.size.y * 0.2, r.size.x * 0.8, r.size.y * 0.8)): hit.append(k)
		for i in J.G.TREE_POS.size():
			var p = J.G.TREE_POS[i]; if _solid_in(Rect2(p[0] - 22, p[1] - 80, 44, 80)): hit.append("tree%d" % i)
		for i in J.G.PADDY_POS.size():
			var p = J.G.PADDY_POS[i]; if _solid_in(Rect2(p[0] - 36, p[1] - 30, 72, 34)): hit.append("paddy%d" % i)
		for e in nv.extras(): if _solid_in(Rect2(e[1] - e[3] / 2.0, e[2] - 50, e[3], 50)): hit.append(e[0])
		var ZG = load("res://game/zone/zone_ground.gd")
		for e in ZG.path_samples(ZD.cur(), 6.0):
			var q: Vector2 = e[0]; var hw: float = e[1]
			if hr.has_point(q) and LA.solid("hill", LM.at("hill"), q): hit.append("road"); break
		if LM.has("tower"):
			var tr2 = LM.art_rect("tower")
			if _solid_in(Rect2(tr2.position.x + 8, tr2.position.y, tr2.size.x - 16, tr2.size.y - 10)): hit.append("tower")
		_chk(tag + "無名義山唔遮建築／槐樹／稻田／公告板／路／破塔樓", hit.is_empty(), hit)
		var sd = LM.stand("hill")
		_chk(tag + "無名義山企位（山腳前面）唔喺阻隔上、唔畀山遮", not ZV.blocked(sd) and sd.y > LM.at("hill").y + LA.sort_dy("hill") and (ZW.region(sd) == "village" or ZD.zone_at(sd) in ["", "lm_hill"]), sd)
		var near = INF
		for yy in range(int(hr.position.y), int(hr.end.y), 4):
			for xx in range(int(hr.position.x), int(hr.end.x), 4):
				if LA.solid("hill", LM.at("hill"), Vector2(xx, yy)): near = minf(near, sd.distance_to(Vector2(xx, yy)))
		_chk(tag + "企位貼住山腳（≤ 60）", near <= 60.0, near)
		await _w(t, 0.3)
		var sn = nv.statics.get("lm_hill"); var stn = nv.statics.get("lm_tower")
		_chk(tag + "無名義山圖畫咗、y 排序位＝山腳橢圓中", sn != null and sn.node.visible and absf(sn.node.position.y - (LM.at("hill").y + LA.sort_dy("hill"))) < 0.5)
		var ring = LM.zone_of("hill").get("ring", [])
		var rn = 0
		for i in ring.size():
			var q = nv.statics.get("lmr_%d" % i)
			if q != null and q.node.visible and absf(q.node.position.y - float(ring[i][2])) < 0.5: rn += 1
		var stale = nv.statics.get("lmr_%d" % ring.size())
		_chk(tag + "外圍道具每件自己 y 排序、冇上一關剩低", rn == ring.size() and (stale == null or not stale.node.visible), [rn, ring.size()])
		var pt = nv.statics.get("lm_hill_pt")
		_chk(tag + "山腳泥地喺最底（y＝圖頂）", pt != null and pt.node.visible and pt.node.position.y <= hr.position.y + 0.5)
		if c == 0: _chk(tag + "冇破塔樓圖", stn == null or not stn.node.visible)
		else:
			_chk(tag + "破塔樓圖畫咗", stn != null and stn.node.visible and absf(stn.node.position.y - LM.at("tower").y) < 0.5)
			_chk(tag + "破塔樓企位唔喺阻隔上", not ZV.blocked(LM.stand("tower")) and not ZV.blocked(LM.at("tower")))
		# 撳 → 開啱嘅卡（測試唔閘：已開）；大山：山頂枯樹、山腰、山腳都撳得；四角透明天空唔算
		var lms = []
		for z in LM.zones_of(): lms.append(str(z.lm))
		var lov = []
		for i in lms.size():
			for j in range(i + 1, lms.size()):
				if LM.art_rect(lms[i]).grow(-4).intersects(LM.art_rect(lms[j]).grow(-4)): lov.append("%s×%s" % [lms[i], lms[j]])
				for e in LM.zone_of(lms[i]).get("ring", []):
					if LA.solid(lms[j], LM.at(lms[j]), Vector2(float(e[1]), float(e[2]) - 6.0), LM.zw(lms[j])): lov.append("%s 道具壓 %s" % [lms[i], lms[j]])
		_chk(tag + "三個地標（同外圍道具）互不重疊", lov.is_empty(), lov)
		for lm in ["hill", "tower", "zhiqian"]:
			if not LM.has(lm): continue
			var ar = LM.art_rect(lm)
			var pts = [ar.get_center()]
			if lm == "hill": pts = [ar.position + Vector2(ar.size.x * 0.46, ar.size.y * 0.06), ar.position + Vector2(ar.size.x * 0.3, ar.size.y * 0.55), ar.position + Vector2(ar.size.x * 0.5, ar.size.y * 0.9), ar.position + Vector2(ar.size.x * 0.06, ar.size.y * 0.75)]
			if lm == "zhiqian": pts = [ar.position + Vector2(ar.size.x * 0.5, ar.size.y * 0.3), ar.position + Vector2(ar.size.x * 0.12, ar.size.y * 0.5), ar.position + Vector2(ar.size.x * 0.85, ar.size.y * 0.75)]
			var okn = 0
			for p in pts:
				m.close_sheet(); LM.CARD = ""
				_cam(m, p); await _w(t, 0.25)
				var r0 = ZV.tap(m, p)
				await _w(t, 0.15)
				if r0 and m.sheet.visible and LM.CARD == lm and m.sheet_title.text == LM.name_of(lm): okn += 1
			_chk(tag + "撳%s（%d 個位）→ 開%s嘅選地點卡" % [lm, pts.size(), lm], okn == pts.size(), okn)
			m.close_sheet()
			if lm == "hill":
				_chk(tag + "大山四角透明位唔當撳中", LM.lm_at(ar.position + Vector2(6, 6)) == "" and LM.lm_at(Vector2(ar.end.x - 6, ar.position.y + 6)) == "")
		if shots:
			await _shot_map(t, m, c)
		# 名牌（每個地標一個）
		_cam(m, LM.at("hill") + Vector2(0, -60)); await _w(t, 0.4)
		var n = 0
		for s in ZV.plates: if s == LM.name_of("hill") or s.begins_with("地標　無名義山"): n += 1
		_chk(tag + "無名義山名牌畫一次", n == 1, ZV.plates)
	await _goto(t, m, 0)

# ================= 2. 解鎖條件＋黑霧 =================
func _unlock_check(t, m, shots: bool) -> void:
	var S = J.G.S
	ZD.gate_on = true
	await _goto(t, m, 0)
	S["lm"] = {}
	S.cleared.erase("1-2"); S["qi"] = float(_qidx("stage", "1-2"))
	LM.poll(true)
	_chk("1-2 未打：無名義山未開", not LM.unlocked("hill"))
	_chk("提示講明要完成 1-2", LM.hint("hill").contains("1-2"), LM.hint("hill"))
	_cam(m, LM.at("hill") + Vector2(0, -60)); await _w(t, 0.6)
	var fl = []
	for e in ZV.fog_log: if e[0] == "lm_fog": fl.append(e[1])
	_chk("未開：無名義山有黑霧", fl.has("hill"), ZV.fog_log)
	if shots: await _shot(t, "m1_hill_locked")
	m.close_sheet()
	var r = ZV.tap(m, LM.art_rect("hill").get_center())
	await _w(t, 0.2)
	_chk("撳未開嘅無名義山：出提示、唔開卡", r and not m.sheet.visible)
	_chk("未開：行動目標冇佢", LM.targets().filter(func(x): return x.id == "lm_hill").is_empty())
	# 打完 1-2 → 開
	S.cleared["1-2"] = true; S["qi"] = float(_qidx("stage", "1-2") + 1)
	LM.NEWS.clear()
	var op = LM.poll(true)
	_chk("打完 1-2：無名義山開咗（入 toast）", LM.unlocked("hill") and op == ["hill"] and LM.NEWS == ["hill"], [op, LM.NEWS])
	await _w(t, 0.3)
	_chk("開咗嘅 toast 出咗（NEWS 食咗）", LM.NEWS.is_empty())
	await _w(t, 0.3)
	fl = []
	for e in ZV.fog_log: if e[0] == "lm_fog": fl.append(e[1])
	_chk("開咗：冇黑霧", not fl.has("hill"))
	_chk("無名義山開過一次：去第 2 關都係開（跟村拔營）", LM.unlocked("hill", 1))
	# 破塔樓：第 2 關，開場劇情未播 → 未開；播完 → 開
	await _goto(t, m, 1)
	MS.auto_on = true   # 同一格做完（唔 await），免得劇情線自己播咗開場
	var eb = MS.enter_beat(1)
	var sd = MS.seen_d(); var had = sd.get(str(eb.get("id", "")))
	sd.erase(str(eb.get("id", "")))
	S.lm.open.erase("1:tower")
	LM.poll(true)
	_chk("第 2 關開場劇情未睇：破塔樓未開", not LM.unlocked("tower"))
	_chk("破塔樓提示：睇完開場劇情", LM.hint("tower").contains("開場劇情"), LM.hint("tower"))
	MS.mark(str(eb.id), 1.0)
	LM.poll(true)
	_chk("睇完開場劇情：破塔樓開", LM.unlocked("tower"))
	_chk("第 3 關嘅破塔樓仲未開（每關各自）", not LM.unlocked("tower", 2) or J.t(S.lm.open.get("2:tower")))
	if had == null: sd.erase(str(eb.id))
	else: sd[str(eb.id)] = had
	MS.auto_on = false
	LM.NEWS.clear()

# ================= 3. 選地點卡 =================
func _find(m, nm: String):
	return m.sheet_body.find_child(nm, true, false)
func _card_check(t, m, shots: bool) -> void:
	var S = J.G.S
	ZD.gate_on = true
	await _goto(t, m, 1)
	S.lm.open["hill"] = 1.0; S.lm.open["1:tower"] = 1.0
	if not (S.get("seen") is Dictionary): S["seen"] = {}
	S.seen["ch1_end"] = true
	S["visit"] = {}; S["wmSeen"] = {}
	S.lm["card"] = {}
	_chk("未開過卡：無名義山有紅點", LM.dot("hill"))
	m.close_sheet(); LM.open_card(m, "hill"); await _w(t, 0.3)
	_chk("無名義山卡：冥街夜市、亂葬崗兩行", _find(m, "lm_street") != null and _find(m, "lm_gyard") != null and _find(m, "lm_station") == null)
	_chk("冥街夜市行：有插圖、有「去」掣、有新紅點", _find(m, "go_street") != null and _find(m, "lm_street").find_child("dot", true, false) != null)
	var pics = 0
	for n in ["lm_street", "lm_gyard"]:
		var tr = _find(m, n).find_children("*", "TextureRect", true, false)
		if tr.size() and tr[0].texture != null: pics += 1
	_chk("每個地點都有插圖（暫用舊世界地圖）", pics == 2)
	if shots: await _w(t, 0.4); await _shot(t, "card_hill")
	m.close_sheet(); LM.open_card(m, "tower"); await _w(t, 0.3)
	_chk("破塔樓卡：陽間站崗、回陽間（夜班嚇人＋樓裡有鬼）", _find(m, "lm_station") != null and _find(m, "lm_back") != null and _find(m, "go_scare") != null and _find(m, "go_tower") != null and _find(m, "lm_street") == null)
	if shots: await _w(t, 0.4); await _shot(t, "card_tower")
	# 未開嘅地點寫明點樣開
	S.seen.erase("ch1_end")
	m.close_sheet(); LM.open_card(m, "tower"); await _w(t, 0.3)
	var lk = _find(m, "lock_station")
	_chk("未開嘅地點：冇「去」掣，寫明點樣開", lk != null and _find(m, "go_station") == null and str(lk.text).contains("第一章"), lk.text if lk else "")
	_chk("未開嘅地點插圖：灰階＋鎖", _find(m, "lm_station").find_child("lock", true, false) != null and _find(m, "lm_station").find_child("pic", true, false).texture is ImageTexture)
	var arts = []
	for pid in ["street", "gyard", "station", "scare", "tower", "battle", "yard"]: if not str(LA.ILLUS[pid][0]).begins_with("res://assets/img/lm_card_") or LA.illus(pid) == null: arts.append(pid)
	_chk("選地點卡用正式插圖（lm_card_*，唔再用舊世界地圖暫代）", arts.is_empty(), arts)
	if shots: await _w(t, 0.3); await _shot(t, "card_tower_locked")
	S.seen["ch1_end"] = true
	# 撳「去」：入啱嘅玩法（測試代替真正開）
	LM.GO_LOG.clear()
	var got = []
	LM.go_fn = func(pid): got.append(pid)
	m.close_sheet(); LM.open_card(m, "hill"); await _w(t, 0.2)
	_find(m, "go_gyard").pressed.emit(); await _w(t, 0.2)
	_chk("撳亂葬崗「去」：開亂葬崗（gyard）、卡收埋、記低返嚟位", got == ["gyard"] and not m.sheet.visible and str(LM.ret.get("lm", "")) == "hill" and J.t(S.visit.get("gyard")), [got, LM.ret])
	LM.ret = {}
	for pid in ["street", "station", "scare", "tower"]:
		var lm = "hill" if pid == "street" else "tower"
		m.close_sheet(); LM.open_card(m, lm); await _w(t, 0.2)
		_find(m, "go_" + pid).pressed.emit(); await _w(t, 0.1)
		LM.ret = {}
	_chk("其餘地點：冥街夜市、陽間站崗、夜班嚇人、樓裡有鬼都開啱", got == ["gyard", "street", "station", "scare", "tower"], got)
	_chk("去過之後：冇紅點", not LM.place_dot("street") and not LM.place_dot("back"))
	LM.go_fn = Callable()
	# 地點對應舊世界地圖嘅玩法
	var W = J.G.get("World")
	var ids = []
	for s in J.iter(W.SPOTS): ids.append(str(s.id))
	_chk("地點 id 全部對到舊世界地圖（玩法照用）", ids.has("street") and ids.has("gyard") and ids.has("station") and ids.has("scare") and ids.has("tower"))
	m.close_sheet()

# ================= 4. 第一次開：短劇情（一次、粵語＋中文、女主版） =================
func _story_check(t, m, shots: bool) -> void:
	var S = J.G.S
	for lm in LM.STORY:
		var sc = LM.STORY[lm]
		var n = sc.lines.size(); var both = true
		for l in sc.lines: if l.size() < 3 or str(l[1]) == "" or str(l[2]) == "": both = false
		_chk("%s 劇情 2–5 句、每句有粵語＋中文" % lm, n >= 2 and n <= 5 and both, n)
	await _goto(t, m, 0)
	ZD.gate_on = true; S.lm.open["hill"] = 1.0
	MS.seen_d().erase(LM.story_id("hill"))
	LM.STORY_LOG.clear()
	m.close_sheet()
	_cam(m, LM.at("hill") + Vector2(0, -60)); await _w(t, 0.4)
	MS.auto_on = true
	if shots:
		ZV.tap(m, LM.art_rect("hill").get_center()); await _w(t, 1.2)
		await _shot(t, "story_hill")
		await _skip(t, 8); await _w(t, 0.5)
	else:
		ZV.tap(m, LM.art_rect("hill").get_center()); await _w(t, 0.5); await _skip(t, 8); await _w(t, 0.5)
	_chk("第一次撳無名義山：先播劇情、播完開卡", LM.STORY_LOG == [LM.story_id("hill")] and MS.is_seen(LM.story_id("hill")) and m.sheet.visible and LM.CARD == "hill", [LM.STORY_LOG, m.sheet.visible])
	var h = MS.hold_d()
	_chk("劇情播完照「等」（一個任務一段故事）", not MS.pace_on or h != null)
	m.close_sheet(); LM.STORY_LOG.clear()
	ZV.tap(m, LM.art_rect("hill").get_center()); await _w(t, 0.4)
	_chk("第二次撳：唔再播劇情，直接開卡", LM.STORY_LOG.is_empty() and m.sheet.visible)
	m.close_sheet()
	MS.auto_on = false
	# 女主版：講者稱呼經 DB.N（少爺 → 大小姐；阿福 → 女主名）
	var h0 = S.get("hero", {}).duplicate()
	S["hero"] = {"name": "阿慧", "full": "陳慧", "en": "Wai", "sex": "f", "set": true}
	var lang0 = DB.lang
	var txt = ""
	for lang in ["yue", "zh"]:
		DB.lang = lang
		var sc2 = MS.build_scene({"id": "x", "scene": LM.STORY.hill})
		for l in sc2.lines: txt += str(DB.L(l[1])) + str(DB.N(l[0]))
	_chk("女主版：少爺 → 大小姐、阿福 → 女主名", txt.contains("大小姐") and not txt.contains("少爺") and txt.contains("阿慧") and not txt.contains("阿福"), txt.substr(0, 60))
	DB.lang = lang0; S["hero"] = h0

# ================= 5. 入舊玩法、玩完返地標旁邊（唔開舊世界地圖） =================
func _return_check(t, m) -> void:
	var S = J.G.S
	ZD.gate_on = true
	await _goto(t, m, 1)
	S.lm.open["hill"] = 1.0; S.lm.open["1:tower"] = 1.0; S.seen["ch1_end"] = true
	# 亂葬崗（真開）：玩法蓋住村子 → 收咗 → 主角企喺無名義山旁邊、鏡頭喺山
	var V = J.G.Village
	V.hero["x"] = 700.0; V.hero["y"] = 900.0
	m.close_sheet(); LM.open_card(m, "hill"); await _w(t, 0.2)
	_find(m, "go_gyard").pressed.emit()
	await _w(t, 1.5)
	var Y = J.G.get("Graveyard")
	_chk("亂葬崗真係開咗（蓋住村子）", J.t(Y.get("active")) and not m.village.is_visible_in_tree(), [Y.get("active"), m.village.is_visible_in_tree()])
	J.mc(Y, "close", [])
	await _w(t, 1.0)
	var st = LM.stand("hill")
	_chk("亂葬崗收咗：主角企喺無名義山旁邊", Vector2(J.num(V.hero.x), J.num(V.hero.y)).distance_to(st) < 2.0 and LM.ret.is_empty(), [V.hero.x, V.hero.y, st])
	var cam = m.village.zone_cam()
	var vr = m.village.view_rect()
	_chk("鏡頭帶返去無名義山", vr.has_point(LM.at("hill")), vr)
	_chk("冇開舊世界地圖", m.get_node_or_null("WmRun") == null)
	# 陽間站崗：收尾叫 World.open → 攔住，返破塔樓旁邊
	m.close_sheet(); LM.open_card(m, "tower"); await _w(t, 0.2)
	_find(m, "go_station").pressed.emit()
	await _w(t, 1.5)
	_chk("陽間站崗開咗（蓋住村子）", not m.village.is_visible_in_tree())
	var Sq = J.G.get("Street")
	J.mc(Sq, "close", [])
	J.mc(J.G.get("World"), "open", [])
	await _w(t, 1.0)
	_chk("陽間站崗收尾叫 World.open：冇開舊世界地圖", m.get_node_or_null("WmRun") == null and m.village.is_visible_in_tree())
	_chk("返到破塔樓旁邊", Vector2(J.num(V.hero.x), J.num(V.hero.y)).distance_to(LM.stand("tower")) < 2.0, [V.hero.x, V.hero.y])
	# 冇由地標入：World.open 照舊（唔攔）
	LM.ret = {}
	_chk("冇由地標入：唔攔 World.open", not LM.intercept_world())

# ================= 6. 舊存檔升級 =================
func _migrate_check(t, m) -> void:
	var S = J.G.S
	ZD.gate_on = true
	await _goto(t, m, 0)
	S.erase("lm")   # 舊存檔冇呢欄
	S.cleared["1-2"] = true; S["qi"] = float(_qidx("stage", "1-3") + 2)
	_chk("舊存檔（冇 S.lm）：讀唔報錯、未開", not LM.unlocked("hill") and S.get("lm") is Dictionary)
	LM.poll(true)
	_chk("舊存檔（過咗 1-2）：升級後無名義山即開", LM.unlocked("hill"))
	_chk("舊存檔：未開過卡有紅點", LM.dot("hill"))
	S.erase("lm")
	await _goto(t, m, 2)
	LM.poll(true)
	_chk("舊存檔（喺第 3 關）：無名義山、破塔樓都開（劇情線自動播關＝開場當播完）", LM.unlocked("hill") and LM.unlocked("tower"))
	await _goto(t, m, 0)

# ================= 7. 行動目標、棟篤笑提示 =================
func _misc_check(t, m) -> void:
	var S = J.G.S
	await _skip(t, 10)
	ZD.gate_on = true
	var has_p = false
	for c in AT.providers: if c is Callable and c.get_method() == "targets": has_p = true
	_chk("act_targets.providers 登記咗地標", has_p, AT.providers.size())
	S.lm.open["hill"] = 1.0
	var all = []
	for c in AT.providers: all.append_array(c.call(m))
	var tg = all.filter(func(x): return x.kind == "landmark" and x.id == "lm_hill")
	_chk("行動目標：無名義山（kind landmark、位＝山腳企位、名）", tg.size() == 1 and tg[0].id == "lm_hill" and tg[0].pos == LM.stand("hill") and tg[0].name == "無名義山" and tg[0].foe_pow == 0, tg)
	m.close_sheet(); LM.CARD = ""
	if tg.size(): tg[0].go.call()
	_chk("行動目標 go：開選地點卡", m.sheet.visible and LM.CARD == "hill", [m.sheet.visible, LM.CARD, ZV._busy(), J.mc(J.G.get("UI"), "modalOpen", []), J.mc(J.G.get("Story"), "busy", [])])
	m.close_sheet()
	_chk("棟篤笑提示：無名義山開咗先出（冥街夜市去得）", LM.street_ok())
	S.lm.open.erase("hill")
	_chk("棟篤笑提示：無名義山未開唔出", not LM.street_ok())
	S.lm.open["hill"] = 1.0
	# [outgate] 主線清單兩份對齊（core.json 嗰份拎走 visit 插入任務）：1-2 之後任務條唔再顯示「去冥街夜市」
	var A = DB.D.QUESTS; var B = J.G.QUESTS; var same = A.size() == B.size()
	if same:
		for i in A.size():
			if str(A[i].get("t")) != str(B[i].get("t")) or str(A[i].get("s", A[i].get("b", ""))) != str(B[i].get("s", B[i].get("b", ""))): same = false
	_chk("主線清單（core.json）同 JS 清單對齊（冇 visit 插入任務）", same, [A.size(), B.size()])
	var qi0 = S.qi
	S["qi"] = float(_qidx("stage", "1-2") + 1)
	var q = G.quest_cur()
	_chk("打完 1-2 之後任務條：同 JS 一樣（唔係「下班後去冥街夜市逛逛」）", q is Dictionary and str(q.get("t")) == str(B[int(S.qi)].get("t")) and str(q.get("t")) != "visit", q)
	S["qi"] = qi0

# ================= 8. 紙錢陣（老闆 19:42／19:47） =================
func _zq_check(t, m, shots: bool) -> void:
	var S = J.G.S
	# 資料（六關）
	for c in 6:
		var tag = "紙錢陣第 %d 關：" % (c + 1)
		var z = LM.zone_of("zhiqian", c)
		if z.is_empty(): _chk(tag + "有", false); continue
		var ar = LM.art_rect("zhiqian", c); var vr = ZD.zrect("village", c)
		var ws = Vector2(float(ZD.mdef(c).w), float(ZD.mdef(c).h))
		_chk(tag + "成幅喺地圖入面（唔裁切）", Rect2(Vector2(-1, -1), ws + Vector2(2, 2)).encloses(Rect2(ar.position, ar.size - Vector2(0, 10))), ar)
		_chk(tag + "大小同無名義山同級（闊 ≥ 290）", ar.size.x >= 290.0, ar.size.x)
		var dx = maxf(0.0, maxf(vr.position.x - ar.end.x, ar.position.x - vr.end.x)); var dy = maxf(0.0, maxf(vr.position.y - ar.end.y, ar.position.y - vr.end.y))
		_chk(tag + "喺村邊（距離村 ≤ 260）", Vector2(dx, dy).length() <= 260.0, Vector2(dx, dy).length())
		var ov = []
		for zz in ZD.zones(c): if str(zz.type) != "landmark" and ZD.rect(zz.rect).intersects(ar.grow(-2)): ov.append(str(zz.id))
		_chk(tag + "唔疊村／資源區／大排檔／野外", ov.is_empty(), ov)
		_chk(tag + "解鎖＝主線 1-3（打低餓鬼王）", str(z.get("unlock", {}).get("quest_done", [])) == str(["stage", "1-3"]))
		var ring = z.get("ring", []); var keys = {}; var bad_r = []
		for e in ring:
			keys[str(e[0])] = 1
			for zz in ZD.zones(c): if str(zz.type) != "landmark" and ZD.rect(zz.rect).has_point(Vector2(float(e[1]), float(e[2]))): bad_r.append(e[0])
		_chk(tag + "外圍散件 ≥ 15 件、≥ 6 款、唔入其他區", ring.size() >= 15 and keys.size() >= 6 and bad_r.is_empty(), [ring.size(), keys.size(), bad_r])
		var blk = []
		for b in ZD.mdef(c).get("barriers", []):
			if str(b.k) in ["void", "cliff"]:
				for r in b.rects: if ZD.rect(r).intersects(ar.grow(-4)): blk.append(r)
		_chk(tag + "陣地挖咗虛空（之後行得到）", blk.is_empty(), blk)
	_chk("散件做咗通用道具（Spr 登記，連新汽水樽／膠袋汽水）", Spr.ok("zq_ingots") and Spr.ok("zq_paper_horse") and Spr.ok("zq_dancer") and Spr.ok("zq_soda_bottles") and Spr.ok("zq_soda_bags"))
	_chk("舊綁繩鬼魂圖冇入包", not ResourceLoader.exists("res://assets/spr/zqg_yanked.webp"))
	# 動態：純函數抽樣 60 秒（唔使畫）：絕不出木樁圈外緣、同時 ≥ 4 隻、分佈全陣（左右前後）、冇綁繩、各段齊、撞屏障停 ≥ 1 秒
	var w = 375.0; var h = LA.size_of("zhiqian").y; var G = LA._geo(500, 500, w, h)
	var mo = 0.0; var vis4 = 0; var spread = 0; var n = 0; var poses = {}; var rip = false; var smoke = false; var maxv = 0
	var tt = 0.0
	while tt < 60.0:
		var v = 0; var quads = {}
		for i in LA.ZQ_N:
			var o = LA.ghost_state(i, tt, 500, 500, w, h)
			if float(o.u) < 0.80 and float(o.a) > 0.0:
				v += 1
				poses[str(o.pose)] = 1
				mo = maxf(mo, LA.inside(G, o.pos, float(o.gh) * LA.ZQ_HALF))
				var d = o.pos - G.ctr
				if d.length() > 25.0: quads[("R" if d.x > 0 else "L") + ("F" if d.y > 0 else "B")] = 1
			if float(o.rip) > 0.5: rip = true
			if float(o.smoke) > 0.5: smoke = true
		if v >= 4: vis4 += 1
		if quads.size() >= 3: spread += 1
		maxv = maxi(maxv, v)
		n += 1; tt += 0.05
	_chk("鬼魂絕不越過木樁圈外緣（60 秒抽樣，連身闊）", mo <= 1.0, mo)
	_chk("同時 ≥ 4 隻（≥ 80% 時間）、最多 5", float(vis4) / n >= 0.8 and maxv <= 5, [float(vis4) / n, maxv])
	_chk("分佈全陣：≥ 50% 時間同時喺 3 個方位以上（左前／左後／右前／右後）", float(spread) / n >= 0.5, float(spread) / n)
	_chk("冇綁繩姿勢、用無繩新圖（浮現／飄／螺旋／掙扎／縮返）", not poses.has("yanked") and poses.has("emerge") and poses.has("drift") and poses.has("spiral") and poses.has("press") and poses.has("recoil") and Spr.ok("zqg2_press") and not Spr.ok("zqg_yanked"), poses.keys())
	_chk("屏障漣漪、化煙散去都有", rip and smoke)
	_chk("撞屏障停 ≥ 1 秒", 0.24 * LA.ZQ_PER >= 1.0, 0.24 * LA.ZQ_PER)
	var o1 = LA.ghost_state(0, 1.0, 500, 500, w, h); var o2 = LA.ghost_state(0, 1.0, 500, 500, w, h)
	_chk("動態係時間嘅純函數（每格唔使存狀態）", o1.pos == o2.pos and o1.a == o2.a)
	# 遊戲入面：解鎖、撳、卡、去
	ZD.gate_on = true
	await _goto(t, m, 0)
	S.lm.open.erase("zhiqian")
	S.cleared.erase("1-3"); S["qi"] = float(_qidx("stage", "1-3"))
	LM.poll(true)
	_chk("1-3 未打：紙錢陣未開、提示講要擊敗餓鬼王", not LM.unlocked("zhiqian") and LM.hint("zhiqian").contains("餓鬼王"), LM.hint("zhiqian"))
	_chk("紙錢陣未開：巡陰日常／區域目標仍然停（patrol_ok 假）", not LM.patrol_ok())
	m.close_sheet()
	_cam(m, LM.art_rect("zhiqian").get_center()); await _w(t, 0.5)
	var fl = []
	for e in ZV.fog_log: if e[0] == "lm_fog": fl.append(e[1])
	_chk("未開：紙錢陣有黑霧", fl.has("zhiqian"), fl)
	if shots: await _shot(t, "zq_locked")
	var r = ZV.tap(m, LM.art_rect("zhiqian").get_center()); await _w(t, 0.2)
	_chk("撳未開嘅紙錢陣：出提示、唔開卡", r and not m.sheet.visible)
	S.cleared["1-3"] = true; S["qi"] = float(_qidx("stage", "1-3") + 1)
	LM.NEWS.clear()
	var op = LM.poll(true)
	_chk("打低餓鬼王（1-3）：紙錢陣開", LM.unlocked("zhiqian") and op.has("zhiqian"), op)
	_chk("紙錢陣開咗：巡陰日常／區域目標重開（patrol_ok）", LM.patrol_ok())
	_chk("開過一次：第 4 關都開（跟村拔營）", LM.unlocked("zhiqian", 3))
	LM.NEWS.clear()
	var tg = []
	for c2 in AT.providers: tg.append_array(c2.call(m))
	tg = tg.filter(func(x): return x.id == "lm_zhiqian")
	_chk("行動目標：紙錢陣（kind landmark、位＝企位）", tg.size() == 1 and tg[0].kind == "landmark" and tg[0].pos == LM.stand("zhiqian"), tg)
	# 第一次：劇情 → 卡
	MS.seen_d().erase(LM.story_id("zhiqian")); LM.STORY_LOG.clear(); MS.auto_on = true
	m.close_sheet()
	ZV.tap(m, LM.art_rect("zhiqian").get_center()); await _w(t, 1.0)
	if shots: await _shot(t, "zq_story")
	await _skip(t, 8); await _w(t, 0.5)
	_chk("第一次撳紙錢陣：先播劇情、播完開卡", LM.STORY_LOG == [LM.story_id("zhiqian")] and m.sheet.visible and LM.CARD == "zhiqian", [LM.STORY_LOG, LM.CARD])
	MS.auto_on = false
	_chk("紙錢陣卡：夜班巡陰、陰陽交界", _find(m, "lm_battle") != null and _find(m, "lm_yard") != null and _find(m, "go_battle") != null and _find(m, "go_yard") != null and _find(m, "lm_street") == null)
	_chk("紙錢陣卡頭圖（唔裁唔拉）", _find(m, "head") != null and _find(m, "head").stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	if shots: await _w(t, 0.3); await _shot(t, "card_zhiqian")
	var got = []
	LM.go_fn = func(pid): got.append(pid)
	for pid in ["battle", "yard"]:
		m.close_sheet(); LM.open_card(m, "zhiqian"); await _w(t, 0.2)
		_find(m, "go_" + pid).pressed.emit(); await _w(t, 0.1); LM.ret = {}
	_chk("撳「去」：夜班巡陰、陰陽交界開啱", got == ["battle", "yard"], got)
	LM.go_fn = Callable()
	m.close_sheet()
	# 舊存檔：冇 S.lm、已過 1-3 → 即開
	var keep = S.lm.duplicate(true)
	S.erase("lm"); LM.poll(true)
	_chk("舊存檔（已過 1-3、冇 S.lm）：紙錢陣即開", LM.unlocked("zhiqian"))
	S["lm"] = keep
	# 動態：鏡頭喺度先畫；鏡頭外唔畫
	var nv = m.village
	LA.FX_LOG.frames = 0; LA.FX_LOG.max_out = 0.0
	_cam(m, LM.art_rect("zhiqian").get_center(), nv.size.x / 470.0); await _w(t, 2.0)
	var f_on = LA.FX_LOG.frames
	_chk("鏡頭對住：動態每格畫", f_on >= 10, f_on)
	_chk("實際畫出嚟嘅鬼魂冇出木樁圈", LA.FX_LOG.max_out <= 1.0, LA.FX_LOG.max_out)
	var top = nv.world.get_node_or_null("lm_zq_top"); var vn = nv.world.get_node_or_null("va_night")
	_chk("鬼魂層喺夜色層之上、泡泡層之下（唔畀夜色壓暗）", top != null and top.visible and vn != null and top.get_index() > vn.get_index() and top.get_index() < nv.top_ui.get_index() and top.get_index() > nv.ysort.get_index(), [top.get_index() if top else -1, vn.get_index() if vn else -1])
	if shots:
		for k in 4: await _shot(t, "zq_anim_night_%d" % k); await _w(t, 1.5)
		var VS = load("res://game/village_style.gd")   # 白天對照：熄暗影、夜色暈邊
		VS.dark_on = false
		if vn: vn.visible = false
		await _w(t, 0.3)
		for k in 4: await _shot(t, "zq_anim_day_%d" % k); await _w(t, 1.5)
		VS.dark_on = true
		if vn: vn.visible = true
	_cam(m, ZD.zrect("village").get_center()); await _w(t, 0.6)
	LA.FX_LOG.frames = 0; await _w(t, 1.0)
	_chk("鏡頭外：動態唔畫（效能）", LA.FX_LOG.frames <= 1, LA.FX_LOG.frames)
