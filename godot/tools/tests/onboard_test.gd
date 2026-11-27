# [onboard] 第一章新手節奏測試（策劃方案 claude/HC_GhostBattles_Ch1_Onboarding_Plan_20261127.md）
# 用法：/home/claude/setup/edtest.sh <godot目錄> onboard res://tools/tests/onboard_test.gd all 1500
#   新開檔 → 只用玩家操作（qaudit 嗰套途徑）推到 1-1 打完；每一步：
#     解鎖次序（鬼怪→箱子→大排檔→守夜→野外／鬼潮）、頭 30 分鐘唔會「大排檔＋野外＋鬼潮」一齊、教程框唔遮目標、說明 ≤ 2 行
#   舊存檔：按進度對應、唔重播劇情、唔出教程、唔重新上鎖；男女主名字啱
#   截圖：/home/claude/docs/shots/onboard/HC_GB_Ch1_Tutorial_*.jpg
extends "res://tools/tests/qaudit_test.gd"

const OB = preload("res://game/onboard/ob.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const SH := "/home/claude/docs/shots/onboard/"
var shots := 0
var SHP := ""   # [qa54] 截圖前綴（女主＝F_）
var tmark := {}     # 事件 → simt
var stage_t := {}   # 階段 → 開始 simt

func _p(m): print("[onboard] ", m)

func _shot_tut(t, m, name: String) -> void:
	var tu = m.get_node_or_null("OnboardTut")
	for i in 30:
		if tu != null and tu.visible: break
		await t.get_tree().create_timer(0.1).timeout
	await t.get_tree().create_timer(0.35).timeout
	if name == "guard_3" and tu != null:   # [qa54] 守夜：等孤魂出，再睇鏡頭有冇自動移過去、手指有冇出
		var sc0 = m.get("mv_view")
		for i in 40:
			var has = false
			if sc0 != null:
				for f in sc0.sim.foes: if f.get("ob") and f.st != "die": has = true
			if has: break
			await t.get_tree().create_timer(0.1).timeout
		await t.get_tree().create_timer(1.5).timeout
		_chk("教程 guard：孤魂出咗之後手指喺畫面入面", tu.visible and Rect2(Vector2.ZERO, tu.size).intersects(tu.hole), "why=%s hole=%s" % [tu.why, str(tu.hole)])
	await RenderingServer.frame_post_draw
	shots += 1
	var fn = SH + "HC_GB_Ch1_Tutorial_%s%02d_%s.jpg" % [SHP, shots, name]
	t.get_viewport().get_texture().get_image().save_jpg(fn, 0.88)
	if tu != null and tu.visible:
		var lines = tu.tip_lbl.get_line_count()
		_chk("教程 %s：說明框唔遮住目標" % name, not tu.tip_rect.intersects(tu.hole), "hole=%s tip=%s" % [str(tu.hole), str(tu.tip_rect)])
		_chk("教程 %s：說明 ≤ 2 行（%d）" % [name, lines], lines <= 2 and tu.tip_lbl.text.split("\n").size() <= 2, tu.tip_lbl.text)
		_chk("教程 %s：說明框喺畫面入面" % name, Rect2(Vector2.ZERO, tu.size).encloses(tu.tip_rect), str(tu.tip_rect))
		# [qa54] 提示（toast）唔准疊住教程目標：塞一條測試提示，量佢嘅位置
		m.show_toast("（測試）任務完成：教程提示避讓")
		await t.get_tree().process_frame; await t.get_tree().process_frame
		var bad = []
		for c in m.toasts.get_children():
			if c is Control and c.visible and c.get_global_rect().intersects(tu.hole): bad.append(str(c.get_global_rect()))
		_chk("教程 %s：提示唔遮住目標" % name, bad.is_empty(), "hole=%s toast=%s" % [str(tu.hole), str(bad)])
	_p("shot " + fn + ("（教程顯示）" if tu != null and tu.visible else "（教程冇顯示：%s）" % (tu.why if tu != null else "")))

func _mark(k: String) -> void:
	if not tmark.has(k): tmark[k] = simt; _p("  ⏱ %s @ %ds" % [k, int(simt)])
func _watch(m) -> void:
	if ZD.revealed("market"): _mark("market")
	if ZD.wild_open(): _mark("wild")
	var sc = m.get("mv_view")
	if sc != null and sc.sim.war.get("wave") != null: _mark("wave")
	var st = OB.stage()
	if not stage_t.has(st): stage_t[st] = simt

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SH)
	var m = await _boot(t)
	var S = _S()
	if OS.get_environment("OB_FEM") == "1":   # [qa54] 女主走一次：截圖另放
		S["hero"] = DB.hero_make("阿珍", "f"); SHP = "F_"
	S["ob"] = S.get("ob", {}) if S.get("ob") is Dictionary else {}
	S.ob["test"] = 1.0
	ZD.gate_on = true   # 測試預設唔閘霧：呢個測試要睇解霧次序
	if not J.t(S.seen.get("prologue_sys")) and int(J.num(S.qi)) == 0: S.seen["prologue_sys"] = true   # 測試開機唔播開場：當睇完
	# ---------- 新開檔 ----------
	_chk("新開檔 qv = 4", int(J.num(S.get("qv"))) == OB.QV, S.get("qv"))
	_chk("新開檔唔當舊玩家", not OB.old_save())
	var Q: Array = J.G.get("QUESTS"); var keys = []
	for i in 12: keys.append(OB._key(Q[i]))
	_chk("主線前段次序（J.G）", keys == OB.EARLY, keys)
	var Q2: Array = DB.D.get("QUESTS"); var k2 = []
	for i in 12: k2.append(OB._key(Q2[i]))
	_chk("主線前段次序（DB.D 同 J.G 對齊）", k2 == OB.EARLY, k2)
	_chk("文字：包普通包子（冇「包壽包」）", str(Q[5].text).contains("普通包子") and not MB.quest_text(Q[5]).contains("壽包"), MB.quest_text(Q[5]))
	for i in 12:   # 交村劇情由每 0.5 秒嘅任務檢查排入：等佢排咗先跳
		if J.t(S.seen.get("ob_arrive")): break
		await _w(t, 0.25)
	await _skip(t, 4)
	_chk("序章後：黑無常交村劇情播咗（ob_arrive）", J.t(S.seen.get("ob_arrive")), S.seen.keys())
	_chk("階段 1", OB.stage() == 1, OB.stage())
	for tb in ["roster", "chest"]: _chk("階段 1：「%s」鎖住（%s）" % [tb, OB.tab_lock(tb)], OB.tab_lock(tb) != "" and OB.tab_lock(tb).ends_with("之後開放"))
	_chk("階段 1：大排檔未解霧", not ZD.revealed("market"))
	_chk("階段 1：新手保護（唔告急／唔襲擾）", MVW.newbie())
	m._nav("roster"); await _w(t, 0.3)
	_chk("撳鎖住嘅「鬼怪」：唔開面板", not m.sheet.visible)
	await _shot_tut(t, m, "chop")
	# ---------- 玩家途徑推到 1-1 ----------
	Engine.time_scale = TS
	CTL.attach(m)
	var order = []   # 每步開始：[qi, key, stage, roster鎖, chest鎖, market, wild]
	var last = -1; var stuck = 0
	var i11 = OB.EARLY.find("stage:1-1")
	for loop in 40:
		await _skip(t, 2)
		J.mc(_Q(), "check", [])
		_watch(m)
		var qi = _qi()
		if qi > i11 or J.t(S.cleared.get("1-1")): break
		var q = _cur()
		if qi == last:
			stuck += 1; _chk("任務 %d「%s」推得郁" % [qi, MB.quest_text(q)], false, "STUCK"); break
		last = qi
		var key = OB._key(q)
		order.append([qi, key, OB.stage(), OB.tab_lock("roster") == "", OB.tab_lock("chest") == "", ZD.revealed("market"), ZD.wild_open()])
		if key != "chop": await _shot_tut(t, m, key.replace(":", "_"))
		var t0 = simt
		var bar = await _tap_bar(t, m)
		var how = ""
		match str(q.t):
			"chop": how = await _do_field(t, m, q, "tree")
			"rice": how = await _do_field(t, m, q, "paddy")
			"craftPlank", "craftBun": how = await _do_craft(t, q)
			"build": how = await _do_build(t, q)
			"bLevel": how = await _do_blevel(t, q)
			"level": how = await _do_level(t, q)
			"assign": how = await _do_assign(t, q)
			"sell": how = await _do_sell(t, m, q)
			"guard": how = await _do_guard(t, m, q)
			"stage": how = await _do_stage(t, m, q)
		if key == "build:bun":   # 小紙到埗（包子鋪起好就送，唔等主公 4 級）
			for w in 20:
				await _skip(t, 2)
				if _xz() != null: break
			_chk("包子鋪起好：小紙即刻到（主公 %d 級）" % int(J.num(S.lv)), _xz() != null and J.num(S.lv) < 4, J.num(S.lv))
		await _skip(t, 3)
		J.mc(_Q(), "check", [])
		await _w(t, 0.3)
		_watch(m)
		_p("Q%02d %s｜階段%d｜任務條:%s｜%s｜%ds" % [qi, MB.quest_text(q), OB.stage(), bar, how, int(simt - t0)])
		if key == "guard:3": _chk("守夜：冇輸（新手保護、冇偷嘢）", J.num(S.res.coins) >= 0.0)
	Engine.time_scale = 1.0
	_watch(m)
	_chk("推到 1-1 打完", J.t(S.cleared.get("1-1")), _qi())
	_chk("冇卡住", stuck == 0)
	# ---------- 解鎖次序 ----------
	var first = func(col: int) -> int:
		for r in order: if r[col]: return int(r[0])
		return 99
	var r_roster = first.call(3); var r_chest = first.call(4); var r_mkt = first.call(5)
	_chk("「鬼怪」喺小紙到咗之後先開（階段 3）", r_roster >= OB.EARLY.find("craftBun:3") - 1 and r_roster <= OB.EARLY.find("assign:1"), r_roster)
	_chk("「箱子」喺「鬼怪」之後", r_chest > r_roster, [r_roster, r_chest])
	_chk("大排檔喺「箱子」之後先解霧（升 3 級完）", r_mkt > r_chest and r_mkt == OB.EARLY.find("sell:10"), [r_chest, r_mkt])
	var w_before = false
	for r in order: if r[6] and int(r[0]) <= i11: w_before = true
	_chk("野外喺 1-1 打完之前未開", not w_before)
	var ss = []
	for r in order: ss.append(r[2])
	var mono = true
	for j in range(1, ss.size()): if ss[j] < ss[j - 1]: mono = false
	_chk("階段只升唔跌（%s）" % str(ss), mono and ss.has(3) and ss.has(5) and ss.has(6) and ss.has(7))
	# 頭 30 分鐘：大排檔＋野外＋鬼潮唔會一齊
	var all3 = tmark.has("market") and tmark.has("wild") and tmark.has("wave") and maxf(tmark.market, maxf(tmark.wild, tmark.wave)) < 1800.0
	_chk("頭 30 分鐘冇「大排檔＋野外＋鬼潮」一齊（%s）" % str(tmark), not all3)
	_chk("1-1 打完：階段 8", OB.stage() == 8, OB.stage())
	_chk("1-1 打完：鬼怪、箱子開放", OB.tab_lock("roster") == "" and OB.tab_lock("chest") == "")
	_chk("1-3 之前：仲係新手保護（唔告急、唔襲擾、唔偷）", MVW.newbie())
	S.cleared["1-3"] = true
	_chk("1-3 之後：新手保護完（第一張圖已玩過 600 秒先算）", not OB.calm())
	S.cleared.erase("1-3")
	# 鬼潮溫和
	var sc = m.get("mv_view")
	if sc != null:
		var w0 = sc.sim.war.get("wave")
		if w0 == null: sc.sim.war.start_wave(sc.sim)
		var wv = sc.sim.war.wave
		_chk("1-3 之前鬼潮溫和：≤ %d 隻、冇頭目" % (OB.GENTLE_SIZE + 1), int(wv.n) <= OB.GENTLE_SIZE + 1 and not wv.q.has(true), wv.n)
		_chk("1-3 之前鬼潮間隔 %d 秒" % int(OB.GENTLE_GAP), J.num(MVW.ws().wave_t) >= OB.GENTLE_GAP - 1.0, MVW.ws().wave_t)
	# ---------- 時間 ----------
	var keys_t = stage_t.keys(); keys_t.sort()
	var parts = []
	for k in keys_t: parts.append("階段%d@%ds" % [int(k), int(stage_t[k])])
	_p("TIMING 出村（1-1 打完）simt=%ds（%.1f 分鐘）｜%s｜畀資源 %d 次" % [int(simt), simt / 60.0, "，".join(parts), gifts.size()])
	await _shot_tut(t, m, "after_1_1")
	# ---------- 舊存檔 ----------
	_old_saves()
	_names()
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= pace：唔畀資源、唔畀好評，純玩家動作量時間（劇情閱讀時間另外按每句 3 秒估） =================
var nogift := false
func _rich() -> void:
	if not nogift: super._rich()
func _idle(t) -> void:
	var V = J.G.get("Village")
	for j in 30:
		await _w(t, 0.5)
		if V.hero.get("target") == null and V.hero.get("act") == null: break
func _gather(t, m) -> void:   # 斬倒一棵樹（撳到佢跌）＋割一次禾＋（要板先）做一次板
	var V = J.G.get("Village"); var S = _S()
	for kind in ["tree", "paddy"]:
		var arr = S.trees if kind == "tree" else S.paddy
		var i = -1
		for j in arr.size(): if J.num(arr[j]) > 0: i = j; break
		if i < 0: continue
		var p = load("res://native/game.gd")._pos("TREE_POS" if kind == "tree" else "PADDY_POS", i)
		for hit in 4:
			if J.num(arr[i]) <= 0: break
			J.mc(V, "tap", [J.num(p[0]), J.num(p[1]) - (20.0 if kind == "tree" else 0.0)])
			await _idle(t)
	var cq = _cur(); var want_pl = cq is Dictionary and (str(cq.t) in ["craftPlank", "bLevel"] or (str(cq.t) == "level" and J.num(S.res.planks) < 30))
	if want_pl and J.num(S.bld.get("plank", 0)) > 0 and J.num(S.res.wood) >= 8 and J.num(S.res.planks) < 60:
		_bld("plank", "craft", 1)
		await _idle(t)
func _until(t, m, q, f: Callable, lim := 120) -> int:
	var n = 0
	for k in lim:
		if _prog(q)[0] >= _prog(q)[1]: break
		f.call(); await _idle(t); J.mc(_Q(), "check", [])
		if _prog(q)[0] >= _prog(q)[1]: break
		await _gather(t, m); n += 1; await _skip(t, 1)
		if n % 5 == 0:
			var S = _S(); var V = J.G.get("Village")
			_p("  … %s 輪%d 進度%s 木%d 米%d 板%d 幣%d lv%d 英雄 act=%s tgt=%s 劇情=%s" % [OB._key(q), n, str(_prog(q)), int(J.num(S.res.wood)), int(J.num(S.res.rice)), int(J.num(S.res.planks)), int(J.num(S.res.coins)), int(J.num(S.lv)), str(V.hero.get("act")), str(V.hero.get("target")), str(_story_busy(_main(t)))])
	return n
func _sell_mat(t, m) -> float:
	if not nogift: return await super._sell_mat(t, m)
	var V = J.G.get("Village")
	if J.num(_S().res.rice) < 4: await _gather(t, m)
	_bld("bun", "craft", 1)
	for j in 14:
		await _w(t, 0.5)
		if V.hero.get("target") == null and V.hero.get("act") == null: break
	return 0.0
var reads := 0   # 播過幾多句劇情（估閱讀時間）
func pace(t) -> void:
	DirAccess.make_dir_recursive_absolute(SH)
	nogift = true
	var m = await _boot(t)
	var S = _S()
	S["ob"] = {"test": 1.0}
	ZD.gate_on = true
	if not J.t(S.seen.get("prologue_sys")) and int(J.num(S.qi)) == 0: S.seen["prologue_sys"] = true
	CTL.attach(m)
	await _skip(t, 4); await _w(t, 3.0)
	var i11 = OB.EARLY.find("stage:1-1")
	var last = -1; var st_t = {}
	var seen0 = S.seen.keys().size()
	for loop in 40:
		await _skip(t, 2)
		J.mc(_Q(), "check", [])
		_watch(m)
		var qi = _qi()
		if qi > i11 or J.t(S.cleared.get("1-1")): break
		if qi == last:
			for r in 6:   # 劇情／完成提示等緊：多等陣
				await _skip(t, 4); J.mc(_Q(), "check", []); await _w(t, 1.0)
				if _qi() != qi: break
			if _qi() != qi: continue
			var V = J.G.get("Village")
			_p("  stuck %s 進度%s 劇情=%s cnt=%s trees=%s hero=%s qt=%s" % [OB._key(_cur()), str(_prog(_cur())), str(_story_busy(m)), str(_S().cnt), str(_S().trees), str([V.hero.get("x"), V.hero.get("y"), V.hero.get("act"), V.hero.get("target")]), str(J.mc(V, "questTarget", []))])
			_chk("pace：任務 %d 推得郁" % qi, false, "STUCK"); break
		last = qi
		var q = _cur(); var t0 = simt; var how = ""
		await _tap_bar(t, m)
		match str(q.t):
			"chop": how = await _do_field(t, m, q, "tree")
			"rice": how = await _do_field(t, m, q, "paddy")
			"craftPlank", "craftBun": how = "親手做 %d 輪（不足去斬／割）" % await _until(t, m, q, func(): _bld("plank" if str(q.t) == "craftPlank" else "bun", "craft", 1))
			"build": how = "建造（等料 %d 輪）" % await _until(t, m, q, func(): _bld(str(q.b), "build"))
			"bLevel": how = "升級（等料 %d 輪）" % await _until(t, m, q, func(): _bld(str(q.b), "up"))
			"level": how = "做嘢儲好評 %d 輪" % await _until(t, m, q, func(): pass)
			"assign": how = await _do_assign(t, q)
			"sell": how = await _do_sell(t, m, q)
			"guard": how = await _do_guard(t, m, q)
			"stage": how = await _do_stage(t, m, q)
		await _skip(t, 2); J.mc(_Q(), "check", [])
		_p("PACE Q%02d %s｜階段%d｜%s｜%ds" % [qi, MB.quest_text(q), OB.stage(), how, int(simt - t0)])
	_watch(m)
	var lines = 0
	for id in S.seen.keys():
		var sc = DB.D.SCENES.get(id)
		if sc is Dictionary: lines += (sc.get("lines", []) as Array).size()
	var rd = lines * 3
	var keys_t = stage_t.keys(); keys_t.sort()
	var parts = []
	for k in keys_t: parts.append("階段%d@%.1f分" % [int(k), stage_t[k] / 60.0])
	_p("PACE 出村（1-1 打完）操作 %.1f 分＋劇情 %d 句×3 秒≈%.1f 分 → 合共 ≈ %.1f 分｜%s｜畀資源 %d 次 %s" % [simt / 60.0, lines, rd / 60.0, (simt + rd) / 60.0, "，".join(parts), gifts.size(), str(gifts)])
	_chk("pace：推到 1-1 打完", J.t(S.cleared.get("1-1")))
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _xz():
	for g in _S().ghosts: if str(g.k) == "xiaozhi": return g
	return null

func _old_saves() -> void:
	var S = _S(); var bk = S.duplicate(true)
	var cases = [[0, 0], [3, 3], [5, 5], [6, 6], [7, 11], [8, 12], [9, 13], [10, 13], [11, 14], [12, 14], [13, 15], [20, 22]]
	for c in cases:
		S["qv"] = 3.0; S["qi"] = float(c[0]); S["ob"] = {}; S.seen["prologue_sys"] = true; S.seen.erase("ob_arrive")
		OB.migrate(S, false)
		_chk("舊存檔 qi %d → %d" % [c[0], c[1]], int(J.num(S.qi)) == c[1], S.qi)
		_chk("舊存檔 qi %d：唔出教程、唔上鎖、唔重播" % c[0], OB.old_save() and not OB.tut_on() and OB.tab_lock("roster") == "" and OB.tab_lock("chest") == "" and not OB.arrive_due())
		S.ob["test"] = 1.0
		_chk("舊存檔 qi %d：再開唔會再搬" % c[0], (func(): OB.migrate(S, false); return int(J.num(S.qi)) == c[1]).call())
	# 舊玩家 qi 7（以前喺「出村 1-1」）：任務照舊係 1-1
	S["qv"] = 3.0; S["qi"] = 7.0; S["ob"] = {}; OB.migrate(S, false)
	_chk("舊玩家做緊 1-1：搬完仲係 1-1", OB._key(J.G.QUESTS[int(S.qi)]) == "stage:1-1", OB._key(J.G.QUESTS[int(S.qi)]))
	for k in bk: S[k] = bk[k]

func _names() -> void:
	var S = _S(); var h0 = S.get("hero")
	var lines = []
	for id in OB.SC: for l in OB.SC[id].lines: if str(l[1]).contains("阿福") or str(l[0]) == "阿福": lines.append(l)
	S["hero"] = DB.hero_make("阿珍", "f")
	var sp = DB.N("阿福")
	_chk("女主：講嘢人名換做「阿珍」", sp == "阿珍", sp)
	_chk("女主：舊劇情「少爺」換「大小姐」", DB.N("少爺好！") == "大小姐好！", DB.N("少爺好！"))
	var bad_n = 0
	for id in OB.SC:
		for l in OB.SC[id].lines:
			for s in [DB.N(l[1]), DB.N(l[2])]: if str(s).contains("阿福") or str(s).contains("少爺"): bad_n += 1
	_chk("女主：新劇情冇男主名／男性稱呼", bad_n == 0, bad_n)
	var CHn = load("res://native/chatter.gd")
	var cl = CHn.fill("少爺，我想報個興趣班：游水。", null)
	_chk("女主：村民碎碎念「少爺」換「大小姐」", not cl.contains("少爺") and cl.contains("大小姐"), cl)
	S["hero"] = DB.hero_make("阿強", "m")
	_chk("男主改名：講嘢人「阿強」", DB.N("阿福") == "阿強")
	if h0 == null: S.erase("hero")
	else: S["hero"] = h0
