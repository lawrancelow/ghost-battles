# [pace] 劇情節奏測試（game/outpost/mv_story.gd 嘅 pace_on：一幕一等、區介紹跟解霧、舊存檔默默記跳過）
# 用法：/home/claude/setup/edtest.sh <godot目錄> pace res://tools/tests/pace_test.gd logic
#   logic：
#     A 佇列：播完一幕之後「等」——再 tick 都唔播；任務動作（S.qi／建築／收成／佔領／打王／攤位）或者 60 秒先放；
#       村子劇情（主劇情播放器）播完都要等；等嘅狀態存檔（新實例都記得）；佇列次序：打王／佔領回應先、區介紹後
#     B 解霧閘：霧未散嘅區 zone_seen 事件唔入佇列、唔記播過；"reveal" 事件／revealed 變 true 先入佇列；佇列有都要等解霧
#     C boss_pre：等緊都即刻播、播完即刻開戰（cb）；auto_on 關 → cb 即刻 call、唔播
#     D 新開檔第 1 關：村子開場劇情之後先到開場新聞，之後一個解霧一幕（跟主線任務次序走完第 1 關，印出播放次序）
#     E 第 2–4 關：開場先播，播完先解霧，區介紹一幕一幕
#     F 舊存檔：播過嘅唔重播；第 1 關中段／第 3 關已經打晒 → 默默記跳過，唔會一次過補播；新開檔唔郁
# 測試期間停 Main 嘅 process；完咗還原存檔。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const STY = preload("res://game/outpost/mv_story.gd")
const ZD = preload("res://game/zone/zone_data.gd")
var ok := 0
var bad := 0

func _p(m): print("[pace] ", m)
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
	var hud_on := true
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
var _log: Array = []   # 播放次序（beat id）
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
# 模擬 n 格，每格 dt 秒（_gap 照真咁數：GAP 1.2 秒）
func _tick(st, sc, n := 4, dt := 0.1) -> void:
	for i in n:
		st.tick(sc, dt)
		_finish_all()
func _settle(st, sc) -> void: _tick(st, sc, 30, 0.1)   # 3 秒：夠 GAP＋CHECK_DT
# 新播咗幾多幕（自從 n0）
func _new(st, n0: int) -> Array: return st.played.slice(n0)

func _reset_map(sim, c: int, keep_seen := false) -> void:
	var S = _S()
	var seen = S.mv.get("story_seen", {}).duplicate() if keep_seen and S.get("mv") is Dictionary else {}
	S.erase("mv"); S.erase("mv_story"); S["cleared"] = {}
	S["zone"] = {"v": 1.0, "own": {}, "boss": {}, "exp": null, "mig": 9.0, "rev": {}, "sent": {}}
	S["mv_on"] = true; S["qi"] = 0.0
	if not (S.get("cnt") is Dictionary): S["cnt"] = {}
	S.bld["home"] = 0.0; S.bld["wood"] = 1.0
	sim.st().ci = float(c); sim.reset_live(); sim.st()
	if keep_seen: S.mv["story_seen"] = seen
	MVW.ws()
	ZD.REV_NEWS.clear()

func _rev(zid: String, c: int) -> void:   # 解霧（好似 reveal_poll 咁：記低再發事件）
	ZD._rev()[ZD._k(zid, c)] = 1.0
	ZD.ev("reveal", zid)

func logic(t) -> void: await _logic(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func all(t) -> void: await logic(t)

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
	var S = _S()
	var save0 = S.duplicate(true)
	var a0 = STY.auto_on; var p0 = STY.pace_on; var g0 = ZD.gate_on
	STY.auto_on = true; STY.pace_on = true; ZD.gate_on = true; ZD.hook = null
	MD.reload(); STY.reload()
	J.test_clock = 1.9e12
	var sim = SIM.new()
	_test_queue(sim)
	_test_gate(sim)
	_test_boss(sim)
	_test_new_l1(sim)
	_test_l24(sim)
	_test_old(sim)
	_test_qv()
	# 還原
	STY.auto_on = a0; STY.pace_on = p0; ZD.gate_on = g0
	for k in S.keys(): S.erase(k)
	for k in save0: S[k] = save0[k]
	J.test_clock = -1.0
	if m != null: m.process_mode = Node.PROCESS_MODE_INHERIT

# ---------------- A 佇列 ----------------
func _test_queue(sim) -> void:
	_reset_map(sim, 0)
	var r = _mk(sim); var st = r[0]; var sc = r[1]
	_settle(st, sc)
	_chk("A 第 1 關：大排檔未解霧 → 開場新聞都唔播", st.played.is_empty(), st.played)
	ZD._rev()[ZD._k("market", 0)] = 1.0; STY.mark("mv0_open", 2.0)
	_settle(st, sc)
	_chk("A 新開檔第 1 關：開場新聞播（一幕）", st.played == ["zs0_map_enter"], st.played)
	_chk("A 播完 → 等（S.mv.story_hold）", STY.held())
	# 解霧兩區（C、w_pit），佇列有兩幕
	_rev("C", 0); _rev("w_pit", 0)
	_chk("A 解霧 → 區介紹入佇列", STY.zq().has("zs0_zone_seen_C") and STY.zq().has("zs0_zone_seen_w_pit"), STY.zq())
	_tick(st, sc, 200, 0.1)   # 20 秒，冇動作
	_chk("A 等緊（20 秒、冇動作）→ 唔播", st.played.size() == 1, st.played)
	# 新實例（重開遊戲）都記得等緊
	var r2 = _mk(sim); var st2 = r2[0]
	_tick(st2, sc, 30, 0.1)
	_chk("A 等嘅狀態存檔：新實例都唔播", st2.played.is_empty(), st2.played)
	# 任務動作：S.qi 前進 → 放一幕
	S_inc("qi")
	_settle(st, sc)
	_chk("A 主線任務前進 → 放一幕（只一幕）", st.played.size() == 2, st.played)
	_settle(st, sc)
	_chk("A 播完又等：第二幕唔會即刻跟", st.played.size() == 2 and STY.held(), st.played)
	# [outgate] 唔再計時放行：等幾耐都唔放，一定要做完一個任務
	_tick(st, sc, 6000, 0.1)   # 10 分鐘
	_chk("A 等 10 分鐘冇做任務 → 都唔放", st.played.size() == 2, st.played)
	S_inc("qi"); _settle(st, sc)
	_chk("A 再做一個任務 → 放下一幕", st.played.size() == 3, st.played)
	# 村子劇情（主劇情播放器）播完都要等（播完等 1 秒先開始等，等住嗰陣結算嘅主線任務都計埋）
	STY.hold_clear()
	_busy = true; _tick(st, sc, 10, 0.1); _busy = false; _tick(st, sc, 15, 0.1)
	_chk("A 村子劇情播完 → 都要等", STY.held())
	STY.hold_clear()
	_busy = true; _tick(st, sc, 10, 0.1); S_inc("qi"); _busy = false; _tick(st, sc, 15, 0.1)
	_chk("A 村子劇情播完先結算嘅主線任務：算返呢個任務，唔會即刻放", STY.held(), st.played)
	# [outgate] 只有「任務」先放：主線任務、佔領、打（非主線）王；斬樹收成、升建築、升攤位、主線關卡通關（同主線任務一齊計）唔放
	for act in ["own", "boss"]:
		STY.hold_clear(); st.hold_start(sim)
		_act(sim, act)
		_tick(st, sc, 10, 0.1)
		_chk("A 任務「%s」→ 放" % act, not STY.held())
	for act in ["bld", "cnt", "cleared", "station"]:
		STY.hold_clear(); st.hold_start(sim)
		_act(sim, act)
		_tick(st, sc, 10, 0.1)
		_chk("A 細動作「%s」→ 唔放" % act, STY.held())
	# 佇列次序：打王回應先過區介紹
	_reset_map(sim, 0)
	ZD._rev()[ZD._k("market", 0)] = 1.0; STY.mark("mv0_open", 2.0)
	r = _mk(sim); st = r[0]; sc = r[1]
	_settle(st, sc)
	_rev("w_graves", 0)
	_S().zone.boss[ZD._k("zb_egui", 0)] = 1.0
	STY.zq().append("zs0_boss_win_zb_egui")
	S_inc("qi"); _settle(st, sc)
	_chk("A 佇列次序：boss_win 先過之前入佇列嘅區介紹", st.played.size() == 2 and st.played[1] == "zs0_boss_win_zb_egui", st.played)

func S_inc(k: String) -> void: _S()[k] = J.num(_S().get(k, 0)) + 1.0
func _act(sim, act: String) -> void:
	var S = _S()
	match act:
		"bld": S.bld["house"] = J.num(S.bld.get("house", 0)) + 1.0
		"cnt":
			if not (S.get("cnt") is Dictionary): S["cnt"] = {}
			S.cnt["rice"] = J.num(S.cnt.get("rice", 0)) + 1.0
		"own": S.zone.own[ZD._k("A", 0)] = 1.0
		"boss": S.zone.boss[ZD._k("zb_paper", 0)] = 1.0
		"cleared": S.cleared["9-9"] = true
		"station":
			for k in sim.st().st:
				sim.st().st[k]["lv"] = J.num(sim.st().st[k].get("lv", 0)) + 1.0
				break

# ---------------- B 解霧閘 ----------------
func _test_gate(sim) -> void:
	_reset_map(sim, 0)
	var r = _mk(sim); var st = r[0]; var sc = r[1]
	_settle(st, sc)
	_chk("B 大排檔有霧：開場新聞等", st.played.is_empty(), st.played)
	STY.mark("zs0_map_enter"); STY.hold_clear()
	var n0 = st.played.size()
	var fogged = []
	for z in ZD.zones(0): if str(z.type) != "village" and not ZD.revealed(str(z.id), 0): fogged.append(str(z.id))
	_chk("B 新開檔：村外全部有霧", fogged.size() >= 5 and fogged.has("market"), fogged)
	for zid in ["A", "B", "C", "w_graves", "w_pit"]: st.zone_event("zone_seen", zid)
	_chk("B 霧未散：zone_seen 唔入佇列", STY.zq().is_empty(), STY.zq())
	_settle(st, sc)
	_chk("B 霧未散：唔播、唔記播過", _new(st, n0) == [] and not STY.is_seen("zs0_zone_seen_A"), st.played)
	_chk("B 大排檔未解霧：開檔劇情唔播", not STY.is_seen("mv0_open"))
	# 佇列有（舊版留低）但未解霧：等
	STY.zq().append("zs0_zone_seen_B")
	_settle(st, sc)
	_chk("B 佇列有但未解霧：唔播", _new(st, n0).is_empty() and STY.zq().has("zs0_zone_seen_B"), st.played)
	# revealed 變 true（冇 reveal 事件）→ 自己入佇列
	ZD._rev()[ZD._k("A", 0)] = 1.0
	_settle(st, sc)
	_chk("B revealed 變 true（冇事件）→ 播嗰區介紹", _new(st, n0) == ["zs0_zone_seen_A"], st.played)
	# reveal 事件（static zone_ev，冇實例都得）
	STY._live = null
	ZD._rev()[ZD._k("B", 0)] = 1.0
	STY.zone_ev("reveal", "B")
	_chk("B reveal 事件（static）→ 入佇列", STY.zq().has("zs0_zone_seen_B"), STY.zq())
	S_inc("qi"); _settle(st, sc)
	_chk("B 解咗霧 → 播", _new(st, n0) == ["zs0_zone_seen_A", "zs0_zone_seen_B"], st.played)
	# 大排檔解霧 → 開檔劇情（大排檔 beat）
	S_inc("qi"); ZD._rev()[ZD._k("market", 0)] = 1.0
	_settle(st, sc)
	_chk("B 大排檔解霧 → 開檔劇情", _new(st, n0) == ["zs0_zone_seen_A", "zs0_zone_seen_B", "mv0_open"], st.played)

# ---------------- C boss_pre ----------------
func _test_boss(sim) -> void:
	_reset_map(sim, 0)
	ZD._rev()[ZD._k("market", 0)] = 1.0; STY.mark("mv0_open", 2.0)
	var r = _mk(sim); var st = r[0]; var sc = r[1]
	_settle(st, sc)
	_rev("w_pit", 0); _rev("w_graves", 0)
	_chk("C 等緊", STY.held())
	var called = [0]
	var ret = st.zone_event("boss_pre", "w_pit", func(): called[0] += 1)
	_chk("C boss_pre：等緊都即刻排入播放器", ret and _q.size() == 1, _q.size())
	_finish_all()
	_chk("C boss_pre：播完即刻開戰（cb 一次）", called[0] == 1)
	var ret2 = st.zone_event("boss_pre", "w_pit", func(): called[0] += 1)
	_chk("C boss_pre 播過：即刻 cb", not ret2 and called[0] == 2)
	# 打低 → boss_win 即刻放（打王＝任務動作）
	S_inc("qi"); _settle(st, sc)   # 先清走等
	var n0 = st.played.size()
	_S().zone.boss[ZD._k("zb_egui", 0)] = 1.0
	st.zone_event("boss_win", "zb_egui")
	_settle(st, sc)
	_chk("C 打低王 → boss_win 即刻播（唔使等 60 秒）", _new(st, n0).has("zs0_boss_win_zb_egui"), _new(st, n0))
	# auto_on 關：cb 即刻
	STY.auto_on = false
	var c3 = [0]
	var ret3 = st.zone_event("boss_pre", "zb_eguiking", func(): c3[0] += 1)
	_chk("C auto_on 關：唔播、cb 即刻", not ret3 and c3[0] == 1 and _q.is_empty() and not STY.is_seen("zs0_boss_pre_zb_eguiking"))
	STY.auto_on = true

# ---------------- D 新開檔第 1 關（跟主線任務次序） ----------------
# [onboard] 第一章主線前段重排咗（ob.gd）：呢度寫嘅係舊清單位置，換算去新清單
func _obq(qi: int) -> int:
	for q in J.G.get("QUESTS"): if q is Dictionary and str(q.get("t", "")) == "sell": return load("res://game/onboard/ob.gd").map_old_qi(qi)
	return qi
func _qi_to(sim, st, sc, qi: int) -> void:
	_S()["qi"] = float(_obq(qi))
	ZD.reveal_poll(true)
	_settle(st, sc)
func _test_new_l1(sim) -> void:
	_reset_map(sim, 0)
	var S = _S()
	var r = _mk(sim); var st = r[0]; var sc = r[1]
	# 村子開場（主劇情播放器）播緊
	_busy = true; _tick(st, sc, 20, 0.1)
	_chk("D 村子開場播緊：分區開場唔播", st.played.is_empty(), st.played)
	_busy = false; _settle(st, sc)
	_chk("D 村子開場播完：唔會即刻接開場新聞", st.played.is_empty() and STY.held(), st.played)
	S.cnt["chop"] = J.num(S.cnt.get("chop", 0)) + 1.0   # 斬第一棵樹
	_settle(st, sc)
	for qi in range(1, 7): _qi_to(sim, st, sc, qi)
	_chk("D 主線 0–5（大排檔未開）：乜劇情都冇（開場新聞等大排檔）", st.played.is_empty(), st.played)
	_qi_to(sim, st, sc, 7)   # 升到 3 級 → 大排檔解霧
	_chk("D 大排檔解霧 → 開場新聞（一幕）", st.played == ["zs0_map_enter"], st.played)
	_busy = true; _tick(st, sc, 5); _busy = false; _settle(st, sc)   # ch1_intro（村子）
	_chk("D 村子 ch1_intro 播完：唔即刻接開檔", st.played.size() == 1, st.played)
	S.cnt["rice"] = J.num(S.cnt.get("rice", 0)) + 1.0; _settle(st, sc)
	_qi_to(sim, st, sc, 8)   # 1-1 → 餓鬼坑
	S.cleared["1-1"] = true; _settle(st, sc)
	var cb0 = [0]
	st.zone_event("boss_pre", "w_pit", func(): cb0[0] += 1); _finish_all()
	_chk("D 餓鬼坑王戰前劇情播完即刻開戰", cb0[0] == 1)
	sim.sst("st_nuomici")["unlocked"] = true; _settle(st, sc)
	_qi_to(sim, st, sc, 9); _qi_to(sim, st, sc, 10)
	S.zone.boss[ZD._k("zb_egui", 0)] = 1.0; st.zone_event("boss_win", "zb_egui"); _settle(st, sc)   # 王戰前（boss_pre）喺下面另計
	_qi_to(sim, st, sc, 11)   # 1-2 → 亂葬崗
	S.cleared["1-2"] = true; _settle(st, sc)
	_qi_to(sim, st, sc, 12)   # 伐木場 2 級 → 後山竹林
	sim.st().sold["x"] = 300.0; _settle(st, sc)
	_qi_to(sim, st, sc, 13)
	_qi_to(sim, st, sc, 14)   # 1-3 → 枯井巷
	S_inc("qi"); _settle(st, sc); S_inc("qi"); _settle(st, sc)
	S.zone.own[ZD._k("A", 0)] = 1.0; st.zone_event("zone_cap", "A"); _settle(st, sc)
	for qi in range(17, 21): _qi_to(sim, st, sc, qi)   # 民宅（第 16 個任務）→ 荒田
	_p("D 荒田解霧：%s" % str(ZD.revealed("C", 0)))
	S.zone.own[ZD._k("C", 0)] = 1.0; st.zone_event("zone_cap", "C"); _settle(st, sc)
	S.zone.own[ZD._k("B", 0)] = 1.0; st.zone_event("zone_cap", "B"); _settle(st, sc)
	for z in ["A", "B", "C"]: st.zone_event("factory", z); _settle(st, sc)
	for b in [["w_pit", "zb_eguiking"], ["w_graves", "zb_paper"], ["w_graves", "zb_keeper"]]:
		var cbn = [0]
		st.zone_event("boss_pre", b[1], func(): cbn[0] += 1); _finish_all()
		S.zone.boss[ZD._k(b[1], 0)] = 1.0; st.zone_event("boss_win", b[1]); _settle(st, sc)
	for i in MD.goals(0).size():
		if str(MD.goals(0)[i].get("t")) != "boss" and not sim.goal_claimed(i): sim.st().goals_done.append(float(i))
	_settle(st, sc)
	st.zone_event("liberate", ""); _settle(st, sc)
	for i in 12: S_inc("qi"); _settle(st, sc)   # 沖晒佇列
	st.before_move(sc, true)
	_settle(st, sc)
	_p("D 第 1 關播放次序（新開檔）：")
	var prev = ""
	for id in st.played:
		var b = STY.beat(id)
		var tt = b.get("scene", {}).get("title", "")
		_p("    %s　%s" % [id, str(tt[0]) if tt is Array else str(tt)])
	_chk("D 第一幕係開場新聞", st.played.size() > 0 and st.played[0] == "zs0_map_enter")
	var dup = {}
	for id in st.played: dup[id] = int(dup.get(id, 0)) + 1
	var dd = []
	for k in dup: if dup[k] > 1: dd.append(k)
	_chk("D 冇一幕播兩次", dd.is_empty(), dd)
	var miss = []
	for b in STY.beats(0):
		var id = str(b.id)
		if not st.played.has(id) and STY.seen_d().get(id) != 2.0: miss.append(id)
	_chk("D 第 1 關每幕都播過（或者按規則跳過）", miss.is_empty(), miss)

# ---------------- E 第 2–4 關 ----------------
func _test_l24(sim) -> void:
	for c in [1, 2, 3]:
		if ZD.mdef(c).is_empty(): continue
		_reset_map(sim, c)
		var S = _S()
		S.mv["story_pace"] = 1.0
		var r = _mk(sim); var st = r[0]; var sc = r[1]
		ZD.reveal_poll(true)
		var hid = 0
		for z in ZD.zones(c): if str(z.type) != "village" and not ZD.revealed(str(z.id), c): hid += 1
		_chk("E 圖%d：開場未播 → 區有霧（%d）" % [c + 1, hid], hid >= 5)
		_settle(st, sc)
		_chk("E 圖%d：開場先播（一幕）" % (c + 1), st.played.size() == 1 and st.played[0] == "zs%d_map_enter" % c, st.played)
		ZD.reveal_poll(true); _settle(st, sc)
		_chk("E 圖%d：開場播完 → 解霧，但係唔即刻接區介紹" % (c + 1), st.played.size() == 1 and ZD.revealed(str(ZD.of_type("wild", c)[0].id), c), st.played)
		var got = []
		for i in 10:
			S_inc("qi"); ZD.reveal_poll(true); _settle(st, sc)
			got.append(st.played.size())
		_chk("E 圖%d：一個動作放一幕（播幕數 %s）" % [c + 1, str(got)], got[0] == 2 and got[1] == 3 and got[2] == 4)
		var zs = []
		for id in st.played: if str(id).contains("zone_seen"): zs.append(id)
		var pre = "zs%d_zone_seen_" % c
		var wild_ok = true
		for z in ZD.of_type("wild", c): wild_ok = wild_ok and st.played.has(pre + str(z.id))
		_chk("E 圖%d：開場之後野外區介紹播晒、開檔之後先到資源區 A" % (c + 1), wild_ok and st.played.has(pre + "A") and st.played.find(pre + "A") > st.played.find("mv%d_open" % c), st.played)
		_chk("E 圖%d：B／C 仲有霧 → 介紹唔播" % (c + 1), not ZD.revealed("B", c) and not st.played.has(pre + "B") and not st.played.has(pre + "C"), zs)

# ---------------- F 舊存檔 ----------------
func _test_old(sim) -> void:
	# 第 1 關中段：播過開場＋A 介紹；大排檔開咗、賣過嘢、佔咗 A、打低餓鬼
	_reset_map(sim, 0)
	var S = _S()
	S["qi"] = 15.0; S.cleared["1-1"] = true; S.cleared["1-2"] = true; S.cleared["1-3"] = true
	S.mv["story_seen"] = {"zs0_map_enter": 1.0, "zs0_zone_seen_A": 1.0, "mv0_open": 1.0}
	S.zone.own[ZD._k("A", 0)] = 1.0; S.zone.boss[ZD._k("zb_egui", 0)] = 1.0
	sim.st().sold["x"] = 300.0
	ZD.reveal_all(0, true)
	S.mv["story_zq"] = ["zs0_zone_seen_B", "zs0_zone_cap_A"]
	var r = _mk(sim); var st = r[0]; var sc = r[1]
	_settle(st, sc)
	for i in 6: S_inc("qi"); _settle(st, sc)
	_chk("F 第 1 關中段舊存檔：唔會一次過補播（播 %d 幕）" % st.played.size(), st.played.size() <= 1, st.played)
	_chk("F 播過嘅唔重播", not st.played.has("zs0_map_enter") and not st.played.has("zs0_zone_seen_A") and not st.played.has("mv0_open"), st.played)
	_chk("F 已解霧區介紹默默記跳過", STY.seen_d().get("zs0_zone_seen_B") == 2.0 and STY.seen_d().get("zs0_zone_seen_w_graves") == 2.0, STY.seen_d())
	_chk("F 已達成嘅大排檔 beat 默默記跳過（賣 250）", STY.seen_d().get("mv0_debt") == 2.0)
	_chk("F 舊佇列清走", STY.zq().is_empty(), STY.zq())
	# 第 3 關已經打晒（之前嘅圖、呢張圖全部過咗）
	for c in [2]:
		if ZD.mdef(c).is_empty(): continue
		_reset_map(sim, c)
		S = _S()
		S["qi"] = 40.0
		S.mv["story_seen"] = {"zs%d_map_enter" % c: 1.0}
		ZD.reveal_all(c, true)
		for z in ZD.of_type("res", c): S.zone.own[ZD._k(str(z.id), c)] = 1.0
		for z in ZD.of_type("wild", c):
			for b in ZD.bosses(str(z.id), c): S.zone.boss[ZD._k(str(b.id), c)] = 1.0
		sim.st().sold["x"] = 5000.0
		for k in sim.st().st: sim.st().st[k]["unlocked"] = true; sim.st().st[k]["lv"] = 30.0
		var bk = STY.boss_k(c)
		if bk != "": S.cleared[bk] = true
		for i in MD.goals(c).size(): sim.st().goals_done.append(float(i))
		r = _mk(sim); st = r[0]; sc = r[1]
		_settle(st, sc)
		for i in 8: S_inc("qi"); _settle(st, sc)
		_chk("F 第 %d 關打晒嘅舊存檔：冇補播（播 %s）" % [c + 1, str(st.played)], st.played.is_empty())
		var prev = 0
		for mp in STY.D().MAPS:
			if int(mp.ci) >= c: continue
			for b in mp.beats: if STY.is_seen(str(b.id)): prev += 1
		_chk("F 之前嘅圖全部記低（%d）" % prev, prev > 0)
	# 新開檔：唔郁（story_seen 空、第 1 關）
	_reset_map(sim, 0)
	var r3 = _mk(sim)
	r3[0].migrate(sim)
	_chk("F 新開檔：遷移唔記任何跳過", STY.seen_d().is_empty(), STY.seen_d())

# ---------------- [outgate] 舊存檔：拎走冥街夜市、陰陽交界兩個插入任務之後，主線索引對返 ----------------
func _test_qv() -> void:
	var Gd = load("res://native/guide.gd")
	var Q: Array = J.G.get("QUESTS")
	var has_visit = false
	for q in Q: if str(q.get("t")) == "visit": has_visit = true
	_chk("Q 主線冇咗「visit」任務（冥街夜市、陰陽交界）", not has_visit)
	var i12 = -1; var i13 = -1; var i11 = -1
	for i in Q.size():
		if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-2": i12 = i
		if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-3": i13 = i
		if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-1": i11 = i
	_chk("Q 1-1 開頭冇劇情、1-2 開頭係新聞＋餓鬼搶包", (Q[i11].get("onStart", []) as Array).is_empty() and Q[i12].get("onStart") == ["ch1_intro", "ch1_intro2"], [Q[i11].get("onStart"), Q[i12].get("onStart")])
	# 第 2 版清單：[… 1-2(i12), 夜市(i12+1), …, 1-3(i13+1), 交界(i13+2), …]
	var S = _S(); var save = [S.get("qi"), S.get("qv")]
	# [onboard] 清單已經重排（ob.gd）：Guide.at 記嘅係重排前位置；Guide 遷移出嚟係第 3 版（重排前）索引，之後先由 ob.migrate 換去新清單
	var obp = _obq(1000) != 1000
	if obp and Gd.at.size() == 2: i12 = int(Gd.at[0]) - 1; i13 = int(Gd.at[1]) - 1
	var cases = [[i12, i12], [i12 + 1, i12 + 1], [i12 + 2, i12 + 1], [i13 + 1, i13], [i13 + 2, i13 + 1], [i13 + 3, i13 + 1], [i13 + 10, i13 + 8]]
	var bad = []
	for c in cases:
		S["qv"] = 2.0; S["qi"] = float(c[0]); Gd.migrate(false)
		if int(S.qi) != int(c[1]) or J.num(S.qv) != 3.0: bad.append([c, S.qi])
	_chk("Q 第 2 版存檔：主線索引減返已做嘅插入任務（做緊嗰個就跳去下一個）", bad.is_empty(), bad)
	if obp:   # 成條鏈：Guide（2→3）再 ob（3→4）
		var OBm = load("res://game/onboard/ob.gd"); var bad2 = []; var ob0 = (S.get("ob", {}) as Dictionary).duplicate(true)
		for c in cases:
			S["qv"] = 2.0; S["qi"] = float(c[0]); Gd.migrate(false); OBm.migrate(S, false)
			if int(S.qi) != OBm.map_old_qi(int(c[1])) or int(J.num(S.qv)) != OBm.QV: bad2.append([c, S.qi])
		_chk("Q 第 2 版存檔 → 新手重排：索引對返新清單", bad2.is_empty(), bad2)
		S["ob"] = ob0
	S["qv"] = 1.0; S["qi"] = 20.0; Gd.migrate(false)
	_chk("Q 第 1 版存檔（未插過）：索引唔郁", int(S.qi) == 20 and J.num(S.qv) == 3.0, S.qi)
	S["qi"] = save[0]; S["qv"] = save[1]
