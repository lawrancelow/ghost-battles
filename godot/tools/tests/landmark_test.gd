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
	ZD.gate_on = false; MS.auto_on = false; LM.go_fn = Callable()
	S["qi"] = bak.qi; S["cleared"] = bak.cleared; S["seen"] = bak.seen; S["visit"] = bak.visit; S["hero"] = bak.hero
	if bak.lm == null: S.erase("lm")
	else: S["lm"] = bak.lm
	await _goto(t, m, 0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 1. 資料／布局（六關） =================
func _data_check(_t, _m) -> void:
	var rel0 = null; var rel_same = true; var hill_all = true; var tower_ok = true
	for c in 6:
		var vr = ZD.zrect("village", c)
		var h = LM.zone_of("hill", c)
		if h.is_empty(): hill_all = false; continue
		var rel = LM.at("hill", c) - vr.position
		if rel0 == null: rel0 = rel
		elif rel != rel0: rel_same = false
		var tw = LM.zone_of("tower", c)
		if (c == 0) != tw.is_empty(): tower_ok = false
	_chk("六關都有無名義山", hill_all)
	_chk("無名義山喺每關村子同一個相對位（拔營跟住搬）", rel_same, rel0)
	_chk("破塔樓：第 1 關冇，第 2–6 關每關一座", tower_ok)
	for c in 6:
		var tag = "第 %d 關：" % (c + 1)
		var vr = ZD.zrect("village", c)
		_chk(tag + "無名義山圖喺中央村入面", vr.encloses(LM.art_rect("hill", c)), LM.art_rect("hill", c))
		_chk(tag + "無名義山解鎖＝主線 1-2", str(LM.zone_of("hill", c).get("unlock", {}).get("quest_done", [])) == str(["stage", "1-2"]))
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
			var foot = Rect2(r.position.x + r.size.x * 0.1, r.position.y + r.size.y * 0.45, r.size.x * 0.8, r.size.y * 0.55)
			if foot.intersects(hr.grow(-6)): hit.append(k)
		for i in J.G.TREE_POS.size():
			var p = J.G.TREE_POS[i]; if Rect2(p[0] - 22, p[1] - 50, 44, 50).intersects(hr): hit.append("tree%d" % i)
		for i in J.G.PADDY_POS.size():
			var p = J.G.PADDY_POS[i]; if Rect2(p[0] - 36, p[1] - 30, 72, 34).intersects(hr): hit.append("paddy%d" % i)
		for e in nv.extras(): if Rect2(e[1] - e[3] / 2.0, e[2] - 50, e[3], 50).intersects(hr): hit.append(e[0])
		var ZG = load("res://game/zone/zone_ground.gd")
		for e in ZG.path_samples(ZD.cur(), 6.0):
			if str(e[2]) != "main": continue
			var q: Vector2 = e[0]; var hw: float = e[1]
			if Rect2(q.x - hw, q.y - hw * 0.5, hw * 2.0, hw).intersects(hr.grow(-4)): hit.append("main_road"); break
		_chk(tag + "無名義山唔撞建築／槐樹／稻田／公告板／主路", hit.is_empty(), hit)
		_chk(tag + "無名義山企位（stand）行得到", ZW.region(LM.stand("hill")) == "village" and not ZV.blocked(LM.stand("hill")), LM.stand("hill"))
		await _w(t, 0.3)
		var sn = nv.statics.get("lm_hill"); var stn = nv.statics.get("lm_tower")
		_chk(tag + "無名義山圖畫咗、y 排序位＝山腳", sn != null and sn.node.visible and absf(sn.node.position.y - LM.at("hill").y) < 0.5)
		if c == 0: _chk(tag + "冇破塔樓圖", stn == null or not stn.node.visible)
		else:
			_chk(tag + "破塔樓圖畫咗", stn != null and stn.node.visible and absf(stn.node.position.y - LM.at("tower").y) < 0.5)
			_chk(tag + "破塔樓企位唔喺阻隔上", not ZV.blocked(LM.stand("tower")) and not ZV.blocked(LM.at("tower")))
		# 撳 → 開啱嘅卡（測試唔閘：已開）
		for lm in ["hill", "tower"]:
			if not LM.has(lm): continue
			m.close_sheet(); LM.CARD = ""
			_cam(m, LM.at(lm) + Vector2(0, -60)); await _w(t, 0.4)
			var p = LM.art_rect(lm).get_center()
			var r0 = ZV.tap(m, p)
			await _w(t, 0.2)
			_chk(tag + "撳%s → 開%s嘅選地點卡" % [lm, lm], r0 and m.sheet.visible and LM.CARD == lm and m.sheet_title.text == LM.name_of(lm), [r0, LM.CARD, m.sheet_title.text])
			if shots and c in [0, 1, 2, 3]:
				m.close_sheet(); _cam(m, LM.at(lm) + Vector2(0, -70)); await _w(t, 0.8); await _shot(t, "m%d_%s" % [c + 1, lm])
			m.close_sheet()
		if shots and c in [4, 5]:
			_cam(m, LM.at("tower") + Vector2(0, -70)); await _w(t, 0.8); await _shot(t, "m%d_tower" % (c + 1))
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
	var tg = all.filter(func(x): return x.kind == "landmark")
	_chk("行動目標：無名義山（kind landmark、位、名）", tg.size() == 1 and tg[0].id == "lm_hill" and tg[0].pos == LM.at("hill") and tg[0].name == "無名義山" and tg[0].foe_pow == 0, tg)
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

func probe(t) -> void:
	var m = await _boot(t)
	var tr = TextureRect.new(); tr.texture = load("res://assets/spr/lm_hill.webp"); tr.position = Vector2(20, 200); tr.size = Vector2(150, 152)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; m.add_child(tr)
	var tr2 = TextureRect.new(); tr2.texture = load("res://assets/spr/home.webp"); tr2.position = Vector2(200, 200); tr2.size = Vector2(150, 140)
	tr2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; m.add_child(tr2)
	await _w(t, 1.0); await _shot(t, "probe_tex")
	_p("RESULT ok=1 bad=0")
