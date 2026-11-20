# [zstory] 分區地圖劇情測試（game/outpost/mv_story.gd 嘅 zone_event／zone_ev／next_zone；資料 data/nat/mv_story.json）
# 用法：/home/claude/setup/edtest.sh <godot目錄> zstory res://tools/tests/zstory_test.gd logic|shots|all
#   logic：每關（有分區 beat 嘅關）開場自己播一次、播之前大排檔 open 等；每種事件（zone_seen／zone_cap／boss_pre／boss_win／factory／liberate）
#          觸發一次、主對話忙／戰鬥中／彈出卡唔播、唔重播；boss_pre callback（播完先開戰；播過即刻 call）；id 正規化（加工廠建築 id、野外區 id）；
#          舊存檔（已佔領唔播 zone_seen、已打低唔播 boss_pre、冇事件唔補播、開場照播）；佇列存檔（冇實例都記得）；換圖清走舊佇列；
#          出場條件（has:）；舊大排檔 beat 等分區 beat（ZAFTER）；女主稱呼；粵／中
#   shots：每關開場第一幕＋一個 boss_pre（/tmp/zstory/shots/），量播放器字型最細
# zones.json 未有嘅關（第 2–4 關）用 beat 自己砌假分區圖（測試完還原）；測試期間停 Main 嘅 process，免得真畫面郁存檔。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const STY = preload("res://game/outpost/mv_story.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const SHOTS := "/tmp/zstory/shots/"
var ok := 0
var bad := 0

func _p(m): print("[zstory] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _S(): return J.G.get("S")

class FakeSc extends RefCounted:
	var sim
	var visible := true
	var embed := true
	var hud_on := false   # 鏡頭唔喺大排檔：分區 beat 照播，大排檔 beat 唔播
	var anim = null
	var card = null
	var sheet = null
	var picker = null
	var main = null
	var top_pad := 0.0
	func _bubble(_p, _tx, _who, _life := 2.6) -> void: pass
	func _float(_p, _tx, _c, _sz := 16, _life := 1.4) -> void: pass
	func s2w(p: Vector2) -> Vector2: return p
	func move_next(_instant := false) -> bool: return true

var _q: Array = []
var _busy := false
func _mk(sim) -> Array:
	var st = STY.new()
	_q = []
	st.play_fn = func(scene, cb): _q.append([scene, cb])
	st.busy_fn = func(): return _busy
	var sc = FakeSc.new(); sc.sim = sim
	return [st, sc]
func _finish_all() -> void:
	while _q.size():
		var it = _q.pop_front(); (it[1] as Callable).call()
func _tick(st, sc, n := 4) -> void:
	for i in n:
		st._gap = 0.0; st._ct = 0.0; st.tick(sc, 0.1)
		_finish_all()

func _zbeats(c: int) -> Array:
	var o = []
	for b in STY.beats(c): if STY.is_zone(b): o.append(b)
	return o
func _kind(b) -> String: return str(b.when.get("kind"))

# 用 beat 砌假分區圖（zones.json 未有嗰張）
var _stubbed: Array = []
func _stub(c: int) -> void:
	if not ZD.mdef(c).is_empty(): return
	var res = {}; var fac = {}; var wild = {}
	for b in _zbeats(c):
		var w = b.when; var id = str(w.get("id", ""))
		match _kind(b):
			"zone_cap": res[id] = true
			"factory": fac[id] = true
			"boss_pre":
				var z = str(w.z)
				if not wild.has(z): wild[z] = []
				while wild[z].size() <= int(w.bi): wild[z].append("")
				wild[z][int(w.bi)] = id
	var zs = []
	for z in res:
		var zz = {"id": z, "type": "res", "rect": [0, 0, 10, 10], "n": [z, z], "power": 100}
		if fac.has(z): zz["shops"] = {"b_fac_%d_%s" % [c, z]: {"pos": [0, 0], "need": {}}}
		zz["fields"] = {"b_fld_%d_%s" % [c, z]: {"nodes": [[0, 0]]}}
		zs.append(zz)
	for z in wild:
		var bs = []
		for i in wild[z].size(): bs.append({"id": wild[z][i], "n": [wild[z][i], wild[z][i]]})
		zs.append({"id": z, "type": "wild", "rect": [0, 0, 10, 10], "n": [z, z], "bosses": bs})
	ZD.D().maps[str(c)] = {"w": 100, "h": 100, "zones": zs}
	_stubbed.append(c)
func _unstub() -> void:
	for c in _stubbed: ZD.D().maps.erase(str(c))
	_stubbed = []

func _reset_map(sim, c: int) -> void:
	var S = _S()
	S.erase("mv"); S.erase("mv_story"); S["cleared"] = {}; S["zone"] = {"v": 1.0, "own": {}, "boss": {}, "exp": null, "mig": 1.0}
	S["mv_on"] = true
	sim.st().ci = float(c); sim.reset_live(); sim.st()
	MVW.ws()

func logic(t) -> void: await _logic(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func shots(t) -> void: await _shots(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func all(t) -> void:
	await _logic(t); await _shots(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)

func _logic(t) -> void:
	await _wait_boot(t)
	var m = _main(t)
	if m != null and m.has_method("_hide_title"): m._hide_title()
	await _w(t, 0.5)
	for i in 8:
		if m != null and m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.1)
	if m != null: m.process_mode = Node.PROCESS_MODE_DISABLED
	STY.auto_on = true
	var S = _S()
	var save0 = S.duplicate(true)
	var lang0 = DB.lang
	MD.reload(); STY.reload()
	J.test_clock = 1.9e12
	var sim = SIM.new()
	var cis = []
	for ms in STY.D().MAPS: if not _zbeats(int(ms.ci)).is_empty(): cis.append(int(ms.ci))
	_chk("有分區劇情嘅關：%s" % str(cis), cis.size() >= 1)
	for c in cis: _stub(c)
	for c in cis:
		var zb = _zbeats(c)
		var eb = STY.enter_beat(c)
		_chk("圖%d：有開場 map_enter" % (c + 1), not eb.is_empty())
		# ---------- 開場 ----------
		_reset_map(sim, c)
		var r = _mk(sim); var st = r[0]; var sc = r[1]
		_chk("圖%d：分區地圖開咗" % (c + 1), ZD.on_for(c))
		_chk("圖%d：開場未播 → 大排檔 beat 都唔畀（next_beat 空）" % (c + 1), STY.next_beat(sim).is_empty())
		_busy = true; _tick(st, sc); _busy = false
		_chk("圖%d：主對話忙唔播開場" % (c + 1), not st.played.has(str(eb.id)))
		sc.hud_on = false; _tick(st, sc, 1)
		_chk("圖%d：開場自己播（唔使事件、唔使睇大排檔）" % (c + 1), st.played.size() >= 1 and st.played[0] == str(eb.id), st.played)
		_tick(st, sc, 6)
		_chk("圖%d：開場唔重播；鏡頭唔喺大排檔就唔播大排檔 beat" % (c + 1), st.played.count(str(eb.id)) == 1 and st.played.size() == 1, st.played)
		sc.hud_on = true; _tick(st, sc, 2)
		var opn = ""
		for b in STY.beats(c): if str(b.when.t) == "open": opn = str(b.id)
		_chk("圖%d：開場之後先播大排檔 open（%s）" % [c + 1, opn], opn == "" or (st.played.find(opn) > st.played.find(str(eb.id))), st.played)
		sc.hud_on = false
		# ---------- 每個事件 ----------
		var nk = {}
		for b in zb:
			var k = _kind(b)
			if k == "map_enter": continue
			nk[k] = int(nk.get(k, 0)) + 1
			var id = str(b.id); var zid = str(b.when.get("id", ""))
			if k == "boss_pre":
				var called = [0]
				var ret = st.zone_event(k, zid, func(): called[0] += 1)
				_chk("圖%d %s：boss_pre 即刻排隊、未 call 開戰" % [c + 1, id], ret and called[0] == 0 and _q.size() == 1 and st.played.count(id) == 1)
				_finish_all()
				_chk("圖%d %s：劇情播完先 call 開戰（一次）" % [c + 1, id], called[0] == 1)
				var ret2 = st.zone_event(k, zid, func(): called[0] += 1)
				_chk("圖%d %s：播過再撳 → 即刻開戰、唔重播" % [c + 1, id], not ret2 and called[0] == 2 and _q.is_empty() and st.played.count(id) == 1)
				continue
			_tick(st, sc, 1)
			_chk("圖%d %s：冇事件唔播" % [c + 1, id], not st.played.has(id))
			var ret3 = st.zone_event(k, zid)
			_chk("圖%d %s：事件入佇列" % [c + 1, id], ret3 and STY.zq().has(id))
			_busy = true; _tick(st, sc, 2); _busy = false
			_chk("圖%d %s：主對話忙唔播" % [c + 1, id], not st.played.has(id))
			_tick(st, sc, 2)
			_chk("圖%d %s（%s）：播一次" % [c + 1, id, k], st.played.count(id) == 1)
			st.zone_event(k, zid); _tick(st, sc, 3)
			_chk("圖%d %s：再觸發唔重播" % [c + 1, id], st.played.count(id) == 1 and not STY.zq().has(id))
		_chk("圖%d：事件種類齊（%s）" % [c + 1, str(nk)], nk.has("zone_seen") and nk.has("zone_cap") and nk.has("boss_pre") and nk.has("boss_win") and nk.has("factory") and nk.has("liberate"))
		# ---------- scene 格式 ----------
		var fbad = []
		for b in zb:
			var scn = STY.build_scene(b)
			if scn.lines.is_empty(): fbad.append(str(b.id))
			for l in scn.lines: if not (l is Array and l.size() == 2 and str(l[1]) != ""): fbad.append(str(b.id))
			if str(scn.style) == "chat" and not (scn.get("title") is String and scn.get("group") is String): fbad.append(str(b.id) + ":chat")
			if scn.has("bg") and not Spr.ok("bg_" + str(scn.bg)): fbad.append(str(b.id) + ":bg")
			for who in b.get("art", {}): if not DB.D.SPEAKER_ART.has(who): fbad.append(str(b.id) + ":art")
		_chk("圖%d：分區 beat scene 格式（%d 個）" % [c + 1, zb.size()], fbad.is_empty(), fbad.slice(0, 4))
	# ---------- 正規化、舊存檔、佇列、條件（用第一張有分區劇情嘅圖） ----------
	var c0 = cis[0]
	var res0 = ""; var fac0 = ""; var wild0 = ""; var b0 = []
	for z in ZD.zones(c0):
		if str(z.type) == "res" and res0 == "": res0 = str(z.id)
		if str(z.type) == "res" and fac0 == "" and z.get("shops") is Dictionary and not z.shops.is_empty(): fac0 = str(z.id)
		if str(z.type) == "wild" and wild0 == "": wild0 = str(z.id); b0 = ZD.bosses(wild0, c0)
	_reset_map(sim, c0)
	var r1 = _mk(sim); var s1 = r1[0]; var sc1 = r1[1]
	_tick(s1, sc1, 2)
	# 加工廠建築 id → 區
	var shop = str((ZD.zone(fac0, c0).shops as Dictionary).keys()[0])
	s1.zone_event("factory", shop); _tick(s1, sc1, 2)
	_chk("factory：傳加工廠建築 id（%s）→ 對到 %s 區 beat" % [shop, fac0], s1.played.has("zs%d_factory_%s" % [c0, fac0]), s1.played)
	# 野外區 id → 而家個王
	var called = [0]
	s1.zone_event("boss_pre", wild0, func(): called[0] += 1); _finish_all()
	_chk("boss_pre：傳野外區 id（%s）→ 第一個王 %s" % [wild0, str(b0[0].id)], s1.played.has("zs%d_boss_pre_%s" % [c0, str(b0[0].id)]) and called[0] == 1)
	ZD.st().boss[ZD._k(str(b0[0].id), c0)] = true
	s1.zone_event("boss_win", wild0); _tick(s1, sc1, 2)
	_chk("boss_win：傳野外區 id → 啱啱打低嗰個王", s1.played.has("zs%d_boss_win_%s" % [c0, str(b0[0].id)]), s1.played)
	# 王 id 改咗名：靠 z＋bi 對返
	var bk = str(b0[1].id); b0[1]["id"] = "renamed_boss"
	var bq = STY.zone_beat(c0, "boss_pre", "renamed_boss")
	_chk("王 id 對唔上 → 靠野外區＋第幾個對返", str(bq.get("id", "")) == "zs%d_boss_pre_%s" % [c0, bk])
	b0[1]["id"] = bk
	# 舊存檔：已佔領唔播 zone_seen；已打低唔播 boss_pre（即刻開戰）
	_reset_map(sim, c0)
	var r2 = _mk(sim); var s2 = r2[0]; var sc2 = r2[1]
	ZD.set_owned(res0, c0)
	for i in b0.size(): ZD.st().boss[ZD._k(str(b0[i].id), c0)] = true
	_tick(s2, sc2, 2)
	_chk("舊存檔：第一次入新地圖照播開場", s2.played.has(str(STY.enter_beat(c0).id)))
	s2.zone_event("zone_seen", res0); _tick(s2, sc2, 2)
	_chk("舊存檔：已佔領嘅區唔播 zone_seen（記做跳過）", not s2.played.has("zs%d_zone_seen_%s" % [c0, res0]) and float(STY.seen_d().get("zs%d_zone_seen_%s" % [c0, res0], 0)) == 2.0)
	var c2 = [0]
	var rr = s2.zone_event("boss_pre", str(b0[1].id), func(): c2[0] += 1)
	_chk("舊存檔：已打低嘅王唔播 boss_pre、即刻開戰", not rr and c2[0] == 1 and not s2.played.has("zs%d_boss_pre_%s" % [c0, str(b0[1].id)]))
	_tick(s2, sc2, 4)
	_chk("舊存檔：冇事件唔補播（佔領／打低／解放）", s2.played.size() == 1, s2.played)
	# 舊大排檔 beat 等分區 beat（ZAFTER）
	var waits = []
	for b in STY.beats(c0):
		if STY.is_zone(b): continue
		for a in b.get("need", {}).get("after", []): if str(a).begins_with("zs"): waits.append([str(b.id), str(a)])
	if waits.size():
		var wb = STY.beat(waits[0][0]); var za = STY.beat(waits[0][1])
		_reset_map(sim, c0)
		STY.mark(str(STY.enter_beat(c0).id))
		for a in wb.need.after: if not str(a).begins_with("zs"): STY.mark(str(a))
		_chk("協調：%s 要等 %s" % [waits[0][0], waits[0][1]], STY.need_st(sim, wb) == 1)
		var zw = za.when
		ZD.st().boss[ZD._k(str(zw.id), c0)] = true
		_chk("協調：王已經打低（冇播到）都唔使再等", STY.need_st(sim, wb) != 1)
		ZD.force_off = true
		ZD.st().boss.erase(ZD._k(str(zw.id), c0))
		_chk("協調：分區地圖未開 → 唔等", STY.need_st(sim, wb) != 1)
		ZD.force_off = false
	# 佇列存檔：冇實例都記得；換圖清走
	_reset_map(sim, c0)
	STY._live = null
	STY.zone_ev("zone_cap", res0)
	var qid = "zs%d_zone_cap_%s" % [c0, res0]
	_chk("zone_ev（static，冇實例）→ 記入 S.mv.story_zq", (_S().mv.get("story_zq", []) as Array).has(qid))
	var r3 = _mk(sim); var s3 = r3[0]; var sc3 = r3[1]
	_tick(s3, sc3, 3)
	_chk("之後有實例 tick → 播返佇列", s3.played.has(qid), s3.played)
	STY.zq().append("zs%d_liberate" % c0)
	if cis.size() > 1:
		sim.st().ci = float(cis[1]); sim.reset_live()
		s3.next_zone(sim)
		_chk("換咗圖 → 舊圖佇列清走（唔會喺新圖播）", not STY.zq().has("zs%d_liberate" % c0))
		sim.st().ci = float(c0)
	# 戰鬥中／彈出卡唔播
	_reset_map(sim, c0)
	var r4 = _mk(sim); var s4 = r4[0]; var sc4 = r4[1]
	STY.mark(str(STY.enter_beat(c0).id))
	s4.zone_event("zone_seen", res0)
	var B = J.G.get("Battle"); var act0 = B.get("active") if B is Dictionary else null
	if B is Dictionary: B["active"] = true
	_tick(s4, sc4, 2)
	_chk("戰鬥中唔播分區 beat", B is Dictionary and not s4.played.has("zs%d_zone_seen_%s" % [c0, res0]))
	if B is Dictionary: B["active"] = act0
	sc4.anim = "x"; _tick(s4, sc4, 2)
	_chk("拔營動畫中唔播", not s4.played.has("zs%d_zone_seen_%s" % [c0, res0]))
	sc4.anim = null; _tick(s4, sc4, 2)
	_chk("之後照播", s4.played.has("zs%d_zone_seen_%s" % [c0, res0]))
	# 出場條件 has:
	var cb = {}
	for c in cis:
		for b in _zbeats(c):
			for l in b.scene.lines: if l.size() >= 4 and str(l[3]).begins_with("has:"): cb = b; break
			if not cb.is_empty(): break
		if not cb.is_empty(): break
	if not cb.is_empty():
		var k = ""
		for l in cb.scene.lines: if l.size() >= 4: k = str(l[3]).substr(4); break
		var gh0 = _S().ghosts.duplicate(true)
		var keep = []
		for g in _S().ghosts: if str(g.get("k", "")) != k: keep.append(g)
		_S()["ghosts"] = keep
		var n_off = STY.build_scene(cb).lines.size()
		_S().ghosts.append({"k": k, "id": 99999, "name": k})
		var n_on = STY.build_scene(cb).lines.size()
		_S()["ghosts"] = gh0
		_chk("出場條件 has:%s：未收編唔講（%s：%d → %d 句）" % [k, str(cb.id), n_off, n_on], n_off < n_on and n_on == cb.scene.lines.size())
	# ---------- 粵／中、女主 ----------
	var eb0 = STY.enter_beat(c0)
	DB.lang = "yue"; var sy = STY.build_scene(eb0)
	DB.lang = "zh"; var sz = STY.build_scene(eb0)
	_chk("粵／中揀對欄", str(sy.lines[0][1]) == str(eb0.scene.lines[0][1]) and str(sz.lines[0][1]) == str(eb0.scene.lines[0][2]))
	var hero0 = S.get("hero")
	S["hero"] = {"name": "阿慧", "full": "陳嘉慧", "en": "", "sex": "f", "set": true}
	DB.fem_load()
	var fbad2 = []; var fhit = 0; var nl = 0
	for lg in ["yue", "zh"]:
		DB.lang = lg
		for c in cis:
			for b in _zbeats(c):
				var scn = STY.build_scene(b)
				for l in scn.lines:
					nl += 1
					var shown = str(DB.L(str(l[1])))
					if shown.contains("阿福") or shown.contains("少爺") or shown.contains("陳大福") or shown.contains("陳生") or shown.contains("陳先生"): fbad2.append(shown.substr(0, 24))
					if DB.FEM.has(str(l[1])) and shown == str(DB.FEM[str(l[1])]): fhit += 1
	_chk("女主：分區劇情冇「阿福／少爺／陳生」（%d 句）" % nl, fbad2.is_empty(), fbad2.slice(0, 3))
	_chk("女主：女版句有用到（%d 句）" % fhit, fhit > 0)
	if hero0 == null: S.erase("hero")
	else: S["hero"] = hero0
	DB.lang = lang0
	# 還原
	_unstub()
	J.G["S"] = save0
	J.test_clock = -1.0
	STY.auto_on = false
	if m != null: m.process_mode = Node.PROCESS_MODE_INHERIT

# ================= 截圖 =================
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func _min_font(n: Node, acc: Array) -> void:
	if n is CanvasItem and not (n as CanvasItem).is_visible_in_tree(): return
	if n is RichTextLabel: acc.append([n.get_theme_font_size("normal_font_size"), n.name])
	elif n is Label or n is Button: acc.append([n.get_theme_font_size("font_size"), str(n.get("text")).substr(0, 8)])
	for ch in n.get_children(): _min_font(ch, acc)

func _shots(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0)
	for i in 8:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.2)
	DB.lang = "yue"
	var mn = 99
	for ms in STY.D().MAPS:
		var c = int(ms.ci)
		var eb = STY.enter_beat(c)
		if eb.is_empty(): continue
		var picks = [eb]
		if c == 1:
			for b in _zbeats(c): if _kind(b) == "boss_pre": picks.append(b); break
		for b in picks:
			m.story.queue(STY.build_scene(b))
			var chat = str(b.scene.style) == "chat"
			await _w(t, 0.4)
			if not chat:
				m.story.advance(); await _w(t, 0.3)   # 第 1 句打完字
				m.story.advance(); await _w(t, 0.1); m.story.advance(); await _w(t, 0.3)   # 第 2 句
			else:
				for i in 6: m.story.advance(); await _w(t, 0.5)
			var acc = []; _min_font(m.story, acc)
			var small = []
			for a in acc:
				if int(a[0]) > 0 and not chat: mn = mini(mn, int(a[0]))   # 群組（WA 手機介面）嘅狀態列／時間／標題副題係手機外殼，另外列出
				if int(a[0]) > 0 and int(a[0]) < 14: small.append("%s=%d" % [a[1], a[0]])
			if small.size(): _p("細字（<14px）圖%d %s：%s" % [c + 1, str(b.when.kind), ", ".join(small.slice(0, 8))])
			await _shot(t, "z%d_%s" % [c + 1, str(b.when.kind)])
			_chk("截圖 圖%d %s：播放器開咗" % [c + 1, str(b.id)], m.story.cur != null)
			m.story.skip_scene(); await _w(t, 0.3)
	_chk("劇情播放器（對話／告示／新聞／電台）字型最細 ≥ 14px（%d）" % mn, mn >= 14, mn)
