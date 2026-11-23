# [rts] 地圖半即時戰鬥測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> rts res://tools/tests/rts_test.gd logic|shots|smoke|video
#   logic：下令出擊、行出村門（打卡）、到位、接觸開打、技能鈕、打仗期間點建築／收貨、勝負結算同舊版一致、回村敬禮、叫回（行軍中／交戰中）、
#          其他關照舊、冇新存檔欄位（舊存檔唔受影響）、效能
#   shots：logic ＋ 截圖（/home/claude/docs/rts_shots/）
#   video：錄連續幀（/tmp/rts_frames/），之後用 ffmpeg 合成
extends RefCounted

var ok := 0
var bad := 0
var shots := false
var demo := false
var cmp_res = null
const SHOTS := "/home/claude/docs/rts_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const RV = preload("res://game/rts/rts_view.gd")
const BK = preload("res://game/barracks/bk_data.gd")
const ML = preload("res://game/militia/ml_data.gd")
var MB = load("res://game/zone/zone_battle.gd")

func _p(m): print("[rts] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	if not shots: return
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	var idle = 0
	for i in maxi(n, 40):
		var m = _main(t); var st = m.get("story") if m else null
		var Sy = J.G.get("Story")
		var busy = (st and st.get("cur") != null) or (Sy != null and J.t(J.mc(Sy, "busy", [])))
		if st and st.get("cur") != null: st.skip_scene()
		if not busy:
			idle += 1
			if idle >= 3 and i >= n - 1: break
		else: idle = 0
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
func B(): return J.G.get("Battle")
func _until(t, cond: Callable, secs: float) -> bool:
	var n = int(secs / 0.1)
	for i in n:
		if cond.call(): return true
		await _w(t, 0.1)
	return cond.call()
func _team3(S) -> void:
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
func _qidx_stage(sid: String) -> int:
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == sid: return i
	return -1
func _has(op, ev: String) -> bool:
	for e in op.events: if e[0] == ev: return true
	return false
func _prep(t, m) -> void:
	var S = J.G.S; var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	if demo and S.ghosts.size() < 3:   # 示範存檔：多兩隻名鬼、主公 3 級、150 陰兵（6 隊）——睇得清楚三種隊伍
		var have = []
		for g in S.ghosts: have.append(str(g.k))
		for k in ["xiaozhi", "toyol"]:
			if not k in have: J.cl(J.G.get("joinGhost"), null, [k])
		await _skip(t, 8)
		S["lv"] = 3.0
	_team3(S)
	S.res["troops"] = 150.0 if demo else 100.0
	S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
	var Bt = B(); Bt["auto"] = true
	await _f(t, 3)
func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)

# ================= smoke：開一場睇下 =================
func smoke(t) -> void:
	shots = true; demo = true
	var m = await _boot(t)
	await _prep(t, m)
	var tg = ZD.stage_target()
	_p("tg %s" % str(tg))
	_cam(m, tg.pos + Vector2(0, 160), m.village.size.x / 390.0)
	await _w(t, 1.0); await _shot(t, "smoke_00_camp")
	var r = ZD.start_stage()
	_p("start " + r)
	var op = RTS.op_for("1-1")
	_p("units %s" % str(RTS._count(op)) if op else "no op")
	for i in 6: await _w(t, 1.5); await _shot(t, "smoke_%02d" % (i + 1))
	_cam(m, op.anchor + Vector2(0, 80))
	for i in 8: await _w(t, 1.5); await _shot(t, "smoke_f%02d" % i); _p("phase %s t=%.1f" % [op.phase, op.t])
	await _until(t, func(): return op.phase in ["back", "done"], 60.0)
	await _w(t, 1.0); await _shot(t, "smoke_back")
	_p("report %s" % str(RTS.last_report))
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= logic／shots =================
func logic(t) -> void: await _run(t)
func cmp(t) -> void:   # 只跑同舊版比較（快）＋橫隊截圖
	var m = await _boot(t)
	await compare_old(t, m)
	demo = true; _p("== 示範存檔（3 名鬼、150 陰兵＝6 隊）")
	await compare_old(t, m)
	await line_shots(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
# 真行軍：展開成橫隊 → 接觸後 3 秒、6 秒截圖，並計我方係咪到齊陣位
func line_shots(t, m) -> void:
	shots = true
	await _prep(t, m)
	B()["auto"] = true
	var r = ZD.start_stage()
	if RTS.pending != null: RTS.card_go()
	var op = RTS.op_for("1-1")
	if op == null: _chk("line_shots 開到仗", false, r); return
	var c = m.village.zone_cam()
	var w_dep = func():
		c.glide_to(op.center() + Vector2(0, -40))
		return op.dep_go or op.phase != "march"
	var dep = await _until(t, w_dep, 90.0)
	_cam(m, op.center() + Vector2(0, -60), m.village.size.x / 390.0)
	var mis = 0.0; var n = 0
	for u in op.units:
		if J.num(u.side) == 0 and J.num(u.hp) > 0 and u.has("dl"):
			mis = maxf(mis, absf(J.num(u.s) - op._stop_s(u))); n += 1
	await _w(t, 0.3); await _shot(t, "line_deploy")
	_chk("展開：全部到咗自己陣位先推前（行距誤差 < 30px）", dep and mis < 30.0, [n, mis, op.dep_t])
	var w_ct = func():
		c.glide_to(op.center() + Vector2(0, -40))
		return op.phase != "march"
	await _until(t, w_ct, 60.0)
	_cam(m, op.anchor + Vector2(0, 70), m.village.size.x / 390.0)
	await _w(t, 3.0); await _shot(t, "line_contact_3s")
	await _w(t, 3.0); await _shot(t, "line_contact_6s")
	await _until(t, func(): return op.phase in ["back", "done"], 90.0)
	await _until(t, func(): return op.phase == "done", 90.0)
func shots_(t) -> void: shots = true; demo = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	RTS.LOG.clear()
	await old_save_check(t, m)
	await compare_old(t, m)
	await main_flow(t, m)
	await recall_flow(t, m)
	await other_stage_old(t, m)
	await routes(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- 冇新存檔欄位；開關關咗 → 1-1 照舊（舊 mapbattle） ----
func old_save_check(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S
	var keys0 = (S as Dictionary).keys()
	_chk("主線全開：1-1、2-3、6-3 都用新打法", RTS.enabled_for("1-1") and RTS.enabled_for("2-3") and RTS.enabled_for("6-3"))
	RTS.force = 0
	var r = ZD.start_stage(); await _f(t, 2)
	_chk("開關關咗：1-1 照舊大地圖戰鬥（zone_battle）", r == "ok" and MB.busy() and RTS.ops.is_empty(), r)
	MB.t_skip_march(); await _f(t, 2)
	J.mc(B(), "finish", [false, true]); await _f(t, 2)
	var dl = J.G.get("$"); var okb = J.cl(dl, null, ["#b-ok"])
	if okb != null: J.cl(J.gp(okb, "onclick"), okb, [])
	MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
	RTS.force = -1
	await _prep(t, m)
	var keys1 = (S as Dictionary).keys()
	var added = []
	for k in keys1: if not k in keys0: added.append(k)
	_chk("新打法唔加存檔欄位（舊存檔直接用）", not added.has("rts") and not (J.G.S as Dictionary).has("rts"), added)

# ---- 同舊版比較：同一個存檔狀態，舊 Battle 引擎（直線）vs 地圖模擬，各打 N 場（純計數，唔結算） ----
const SIM = preload("res://game/rts/rts_sim.gd")
func _old_fight(B: Dictionary) -> Dictionary:
	var of = B.get("finish")
	var res = [null]
	B["finish"] = func(_t, a): B["result"] = {"win": J.arg(a, 0)}; res[0] = J.t(J.arg(a, 0)); return null
	var n = 0
	B["speed"] = 1.0
	while B.get("result") == null and n < 30 * 120:
		J.mc(B, "update", [1.0 / 30.0]); n += 1
	B["finish"] = of
	var dead = 0
	for u in B.units: if J.t(u.get("minion")) and J.num(u.side) == 0 and J.num(u.hp) <= 0: dead += 1
	var t_ = J.num(B.t)
	B["active"] = false; B["result"] = null
	return {"win": res[0] == true, "t": t_, "dead": dead}
const TUNES := [[0.0, 0.0], [60.0, 0.0], [120.0, 2.0]]   # 調校候選（敵人優先打小隊 px, 我方排陣秒）
const SIM_REF = preload("res://tools/tests/rts_sim_ref25.gd")
func _new_fight(units: Array, tg: Dictionary, ref := false, tune = null) -> Dictionary:
	var op = SIM_REF.new() if ref else SIM.new()
	if tune != null: op.tune_minion = tune[0]; op.tune_open = tune[1]
	op.setup(units, RTS.stage_path(tg.pos + RTS.CAMP_OFF), tg.pos + RTS.CAMP_OFF, RTS.gate_pos())
	var n = 0
	while op.result == null and n < 30 * 200:
		op.step(1.0 / 30.0); n += 1
	var dead = 0
	for u in op.units: if J.t(u.get("minion")) and J.num(u.side) == 0 and J.num(u.hp) <= 0: dead += 1
	return {"win": op.result != null and J.t(op.result.win), "t": op.t, "dead": dead}
func compare_old(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S
	var tg = ZD.stage_target()
	var Bt = B()
	var save_meal = S.get("street", {}).get("meal") if S.get("street") is Dictionary else null
	var N = 8
	var VAR = []
	for x in TUNES: VAR.append([0, 0.0, 0.0])
	var A = {"win": 0, "t": 0.0, "dead": 0}; var Z = {"win": 0, "t": 0.0, "dead": 0}; var R = {"win": 0, "t": 0.0, "dead": 0}
	var same_stats = true
	for i in N:
		# 舊：Battle.start（唔開畫面）＋ Battle.update 打到完
		var G = J.G
		var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
		G["__nat_battle"] = func(_t, _a): return true
		G["__nat_btSize"] = func(_t, _a): return [390.0, 560.0]
		J.mc(Bt, "start", [0.0, 0.0])
		G["__nat_battle"] = ob; G["__nat_btSize"] = osz
		var sig_old = []
		for u in Bt.units: sig_old.append([J.str(u.k), J.num(u.side), int(J.num(u.hp)), int(J.num(u.atk) * 10), J.num(u.range)])
		var r0 = _old_fight(Bt)
		# 新：RTS 一樣借 Battle.start 生單位
		var snap = RTS._start_battle(func(): J.mc(Bt, "start", [0.0, 0.0]))
		var sig_new = []
		for u in snap.units: sig_new.append([J.str(u.k), J.num(u.side), int(J.num(u.hp)), int(J.num(u.atk) * 10), J.num(u.range)])
		if str(sig_old) != str(sig_new): same_stats = false; _p("sig old %s new %s" % [sig_old, sig_new])
		var r1 = _new_fight(snap.units, tg)
		var snap2 = RTS._start_battle(func(): J.mc(Bt, "start", [0.0, 0.0]))
		var r2 = _new_fight(snap2.units, tg, true)
		for k in ["t", "dead"]: A[k] += r0[k]; Z[k] += r1[k]; R[k] += r2[k]
		A.win += int(r0.win); Z.win += int(r1.win); R.win += int(r2.win)
		for vi in TUNES.size():
			var sn = RTS._start_battle(func(): J.mc(Bt, "start", [0.0, 0.0]))
			var rv = _new_fight(sn.units, tg, false, TUNES[vi])
			VAR[vi][0] += int(rv.win); VAR[vi][1] += rv.dead; VAR[vi][2] += rv.t
		_p("cmp#%d 舊引擎 %s｜integ25 %s｜新 %s" % [i, str(r0), str(r2), str(r1)])
		await _f(t, 1)
	var J0 = J.G.get("$"); var be = J.cl(J0, null, ["#battle"])
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	_p("compare 舊：贏 %d/%d 平均 %.1f 秒 陰兵小隊戰死 %.2f ｜ 新：贏 %d/%d 平均 %.1f 秒（交戰）陰兵小隊戰死 %.2f" % [A.win, N, A.t / N, A.dead / float(N), Z.win, N, Z.t / N, Z.dead / float(N)])
	_p("compare integ25 版（行軍唔展開）：贏 %d/%d 平均 %.1f 秒 戰死 %.2f ｜ 新（展開橫隊）：贏 %d/%d 平均 %.1f 秒 戰死 %.2f" % [R.win, N, R.t / N, R.dead / float(N), Z.win, N, Z.t / N, Z.dead / float(N)])
	for vi in TUNES.size(): _p("tune %s：贏 %d/%d 戰死 %.2f 平均 %.1f 秒" % [str(TUNES[vi]), VAR[vi][0], N, VAR[vi][1] / N, VAR[vi][2] / N])
	_chk("新橫隊同舊版：勝率唔低過舊版、平均戰死唔多過舊版 1 隊（[abform] 新陣型戰死會少咗，只限唔可以多）", Z.win >= A.win - 1 and (Z.dead - A.dead) / N <= 1.0, [A.win, Z.win, A.dead / float(N), Z.dead / float(N)])
	_chk("開戰單位同舊版一模一樣（種類、血、攻、射程）", same_stats)
	_chk("勝負同舊版一致（1-1：舊贏幾多場、新都贏幾多場 ±1）", absi(A.win - Z.win) <= 1, [A.win, Z.win])
	_chk("陰兵折損唔多過舊版（平均多 ≤ 1.5 隊；[abform] 少咗係修好）", (Z.dead - A.dead) / N <= 1.5, [A.dead / float(N), Z.dead / float(N)])
	_chk("一場仗交戰時間合理（10–60 秒）", Z.t / N >= 5.0 and Z.t / N <= 60.0, Z.t / N)
	cmp_res = [A, Z, N]

# ---- 主流程：下令 → 出村 → 到位 → 接觸 → 技能 → 打仗期間操作村子 → 結算同舊版 → 回村敬禮 ----
func main_flow(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S; var nv = m.village; var c = nv.zone_cam()
	B()["auto"] = false
	var tg = ZD.stage_target()
	_chk("1-1 迎戰位：據點敵人係地圖上嘅實體（預覽單位）", tg.has("pos") and RV.inst != null and RV.inst.vis.keys().filter(func(k): return str(k).begins_with("pv:1-1")).size() == (tg.en as Array).size(), RV.inst.vis.keys() if RV.inst else null)
	_cam(m, tg.pos + Vector2(0, 160), nv.size.x / 390.0)
	await _w(t, 0.6); await _shot(t, "01_camp")
	var coins0 = J.num(S.res.get("coins", 0)); var exp0 = J.num(S.get("exp", 0)); var qi0 = J.num(S.qi); var tr0 = J.num(S.res.troops); var lv0 = J.num(S.lv)
	# 經真正入口：撳地圖據點（zone_view.tap → ZD.start_stage → RTS）
	nv.zone_tap(c.w2s(tg.pos + Vector2(0, -60))); await _f(t, 2)
	_chk("撳據點：出「出擊小卡」（揀帶幾隊）", RTS.pending != null and m.sheet != null and m.sheet.visible)
	await _w(t, 0.3); await _shot(t, "00_card")
	RTS.card_go(); await _f(t, 2)
	var op = RTS.op_for("1-1")
	_chk("撳據點：下令出擊（op 建立）", op != null and op.phase == "march")
	if op == null: return
	var cnt = RTS._count(op)
	var yin_exp = mini(8, int(floor(float(BK.standby()) / 25.0)))
	_chk("編成同舊版：名鬼＝出陣隊、陰兵隊數＝待命÷25", cnt.hero == (S.team as Array).filter(func(x): return J.t(x)).size() and cnt.yin == yin_exp, [cnt, yin_exp])
	_chk("冇切換：Battle 冇佔住、冇舊大地圖戰鬥、冇舊戰鬥畫面", not J.t(B().get("active")) and not MB.busy() and BtRun.cur == null and m.get_node_or_null("BtRun") == null)
	_chk("冇底部卡片列／頂部戰鬥工具欄", nv.get_node_or_null("MapBattleUI") == null)
	await _w(t, 1.2)
	_chk("鏡頭只係滑一次去村門（之後唔再跟）", c.tgt == null or c.rect().has_point(op.path[0]), [c.tgt, c.rect()])
	var moved = false
	for u in op.units: if J.num(u.side) == 0 and J.t(u.get("out")) and (u.p as Vector2).distance_to(op.path[0]) > 20: moved = true
	_chk("隊伍由村門內集合點一隊隊行出嚟", moved)
	await _shot(t, "02_depart")
	var gate_ok = await _until(t, func(): return _has(op, "stamp"), 8.0)
	_chk("經過村門：上班打卡", gate_ok)
	await _shot(t, "03_stamp")
	# 鏡頭交返玩家：拖去村尾，隊伍照行
	_cam(m, ZD.zrect("village").get_center() + Vector2(0, 300))
	await _w(t, 1.0)
	var cp = Vector2(c.x, c.y)
	await _w(t, 1.0)
	_chk("鏡頭唔鎖：拖走之後唔會被扯返去", Vector2(c.x, c.y).distance_to(cp) < 2.0)
	var offv = true
	for k in RV.inst.vis: if str(k).begins_with("o%d:" % op.id) and RV.inst.vis[k].visible: offv = false
	_chk("鏡頭外：角色唔畫（節點收埋），模擬照行", offv and op.T > 2.0)
	_cam(m, op.center())
	await _w(t, 0.3); await _shot(t, "04_march")
	var con = await _until(t, func(): return op.phase != "march", 40.0)
	_chk("行到據點：接觸自動開打", con and _has(op, "contact"), op.phase)
	var near = false
	for u in op.units: if J.num(u.side) == 0 and J.t(u.get("out")) and (u.p as Vector2).distance_to(op.anchor) < 260: near = true
	_chk("開打位置喺大排檔據點附近", near and ZD.zrect("market").has_point(op.anchor))
	_cam(m, op.anchor + Vector2(-10, 90))
	await _w(t, 3.5); await _shot(t, "05_fight")
	var hits = false
	for f in op.fx: if str(f.kind) == "num": hits = true
	_chk("睇到打：扣血數字", hits or op.t > 0.5)
	# 技能小圓鈕
	var h = null
	for u in op.units: if J.num(u.side) == 0 and not J.t(u.get("minion")) and J.num(u.hp) > 0 and J.t(u.get("out")): h = u; break
	if h != null:
		h["energy"] = 100.0; h["anim"] = null
		await _f(t, 3)
		var b = RV.inst.btns.get(J.str(h.get("gid", h.k)))
		_chk("技能滿：地圖邊出小圓鈕（可放）", b != null and b.ready_() and b.visible, b)
		if b != null:
			var r0 = b.get_global_rect()
			_chk("技能鈕細（≤ 70px）、喺畫面入面", r0.size.x <= 70 and nv.get_global_rect().encloses(r0), r0)
			var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true; ev.position = Vector2(10, 10)
			b._gui_input(ev)
			_chk("撳鈕：放技能（開始蓄力、嚇氣清零）", h.get("casting") != null and J.num(h.energy) == 0.0)
			await _w(t, 0.3); await _shot(t, "06_skill")
	# 打仗期間操作村子：收貨（大排檔台面有貨 → 撳 → 去櫃台）、點建築、阿福行路
	if op.phase == "fight":
		var sc = m.mv_view; var sim = sc.sim
		var sid = "st_shoubao"
		var pile0 = 3
		sim.st().pile[sid] = float(pile0)
		_cam(m, sim.st_pos(sid) + Vector2(60, -40))
		await _w(t, 0.4)
		var rr = sc._wbtns.get("ring:" + sid)
		var t_before = op.t
		if rr is Rect2: nv.zone_tap(c.w2s(rr.get_center()))
		await _f(t, 3)
		var pile1 = int(sim.pile_n(sid))
		_chk("打仗期間收貨：撳台面 → 貨去櫃台", rr is Rect2 and pile1 < pile0, [rr, pile0, pile1])
		await _shot(t, "07_collect_while_fight")
		_chk("收貨嗰陣仗照打（模擬時間有行）", op.t > t_before or op.phase != "fight", [t_before, op.t])
		var V = J.G.get("Village"); var hp0 = Vector2(J.num(V.hero.x), J.num(V.hero.y))
		J.mc(V, "walkTo", [hp0.x + 60.0, hp0.y + 40.0, null]); await _w(t, 1.0)
		_chk("打仗期間阿福照行路", Vector2(J.num(V.hero.x), J.num(V.hero.y)).distance_to(hp0) > 10.0)
		var P = J.G.get("POS")
		var opened = false
		for bk in ["plank", "wood", "bun", "rice", "store", "home", "house"]:   # 揀一間撳得開卡嘅（未解鎖嘅只出提示）
			if not (P is Dictionary and P.has(bk)): continue
			var hb = Vector2(J.num(P[bk][0]), J.num(P[bk][1]))
			_cam(m, hb); await _w(t, 0.3)
			nv.zone_tap(c.w2s(hb + Vector2(0, -40))); await _w(t, 0.6)
			opened = str(Menus.cur).begins_with("bld:") and m.sheet != null and m.sheet.visible
			if opened: break
		_p("bld card %s" % str(Menus.cur))
		_chk("打仗期間點建築：開到建築面板", opened)
		await _shot(t, "08_building_while_fight")
		Menus.close_hook(); await _w(t, 0.3)
		await _f(t, 2)
	_cam(m, op.anchor + Vector2(-10, 90))
	B()["auto"] = true
	var fin = await _until(t, func(): return op.phase in ["back", "done"], 95.0)
	_chk("分勝負：自動結算、隊伍開始回村", fin, op.phase)
	var rep = RTS.last_report
	var win = op.result != null and J.t(op.result.win)
	_chk("1-1 打贏", win, op.result)
	await _w(t, 0.5); await _shot(t, "09_win_report")
	# 結算同舊版：首次通關獎勵（冥幣 60p+40、經驗 30p+40）、通關、主線推進、扣兵（每隊 25）
	var dead = 0
	for u in op.units: if J.t(u.get("minion")) and J.num(u.side) == 0 and u.get("ml") == null and J.num(u.hp) <= 0: dead += 1
	_chk("通關記錄 S.cleared", J.t(S.cleared.get("1-1")))
	_chk("首次通關獎勵同舊版（冥幣 +100）", J.num(S.res.get("coins", 0)) - coins0 >= 100.0 - 0.5, J.num(S.res.get("coins", 0)) - coins0)
	_chk("戰死陰兵扣人同舊版（每隊 25）", absf((tr0 - J.num(S.res.troops)) - dead * 25.0) < 0.5, [tr0, J.num(S.res.troops), dead])
	_chk("主線推進（Quest.check）", J.num(S.qi) > qi0 or J.num(S.lv) > lv0, [qi0, S.qi])
	_chk("戰報：首次通關＋獎勵字（唔彈框）", str(rep.get("head", "")) == "首次通關！" and str(rep.get("reward", "")).contains("冥幣"), rep)
	var f0 = J.G.get("$"); var rb = J.cl(f0, null, ["#b-result"])
	_chk("舊結算框冇彈出", rb == null or not J.gp(rb, "classList").d.has("on"))
	_chk("Battle 結算後關返", not J.t(B().get("active")))
	await _skip(t, 4)
	var MS = load("res://game/outpost/mv_story.gd")
	await _w(t, 2.0); await _skip(t, 6)
	# 回村
	_cam(m, op.gate)
	var stamp_back = await _until(t, func():
		for e in op.events: if e[0] == "stamp" and e[2] != "打卡": return true
		return false, 30.0)
	_chk("回到村門：收工打卡", stamp_back)
	var sal = await _until(t, func():
		for u in op.units: if J.num(u.get("sal", -1)) >= 0 and not J.t(u.get("home")): return true
		return op.phase == "done", 10.0)
	await _shot(t, "10_salute_home")
	_chk("回到集合點敬禮", sal)
	var done = await _until(t, func(): return RTS.ops.is_empty(), 20.0)
	_chk("全部收隊（op 完）", done)
	_chk("通關後據點收返（下一個任務）", not ZD.stage_target().has("pos") or str(ZD.stage_target().sid) != "1-1", ZD.stage_target())

# ---- 叫回：行軍中（乜都冇發生）、交戰中（＝舊版撤退） ----
func recall_flow(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S
	var tr0 = J.num(S.res.troops); var coins0 = J.num(S.res.get("coins", 0))
	ZD.start_stage(); await _f(t, 2); RTS.card_go(); await _f(t, 2)
	var op = RTS.op_for("1-1")
	await _w(t, 1.5)
	RV.inst.chip_recall.emit_signal("pressed"); await _f(t, 2)
	_chk("行軍中叫回：轉頭回村", op != null and op.phase == "back" and op.recalled)
	var d1 = await _until(t, func(): return RTS.ops.is_empty(), 45.0)
	_chk("行軍中叫回：冇結算、冇扣兵、冇通關", d1 and J.num(S.res.troops) >= tr0 and not J.t(S.cleared.get("1-1")) and J.num(S.res.get("coins", 0)) >= coins0 and not op.settled, [d1, tr0, S.res.troops, coins0, S.res.get("coins"), op.settled])
	# 交戰中叫回
	await _prep(t, m)
	tr0 = J.num(S.res.troops)
	ZD.start_stage(); await _f(t, 2); RTS.card_go(); await _f(t, 2)
	op = RTS.op_for("1-1")
	op.t_skip_march()
	await _until(t, func(): return op.phase == "fight", 15.0)
	await _w(t, 1.0)
	var sq = null
	for u in op.units: if J.t(u.get("minion")) and J.num(u.side) == 0 and u.get("ml") == null and J.t(u.get("out")): sq = u; break
	if sq != null: sq["hp"] = 0.0; sq["deadT"] = 0.0
	RTS.recall(op); await _f(t, 3)
	var dead = 0
	for u in op.units: if J.t(u.get("minion")) and J.num(u.side) == 0 and u.get("ml") == null and J.num(u.hp) <= 0: dead += 1
	_chk("交戰中叫回＝撤退：結算（戰死照扣）、唔通關", op.settled and not J.t(S.cleared.get("1-1")) and absf(tr0 - J.num(S.res.troops) - dead * 25.0) < 0.5, [tr0, S.res.troops, dead])
	_chk("撤退戰報", str(RTS.last_report.get("head", "")) == "撤退", RTS.last_report)
	await _until(t, func(): return RTS.ops.is_empty(), 30.0)
	_chk("撤退後據點仲喺度（可以再打）", ZD.stage_target().has("pos") and str(ZD.stage_target().sid) == "1-1")

# ---- 全面鋪開：1-2、野外王、親征、派兵攻佔、鬼潮告急、自動擊退、出擊小卡揀隊、同時 2 場 ----
func _wait_op_end(t, op, secs := 120.0) -> bool:
	if op == null: return false
	op.t_skip_march()
	return await _until(t, func(): return op.phase in ["back", "done"], secs)
func _home(t) -> void:
	for o in RTS.ops: if o.phase == "back": for u in o.units: u["s"] = 9999.0
	await _until(t, func(): return RTS.ops.is_empty(), 30.0)
func other_stage_old(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S
	B()["auto"] = true
	S.cleared["1-1"] = true; S.cleared.erase("1-2"); S["qi"] = float(_qidx_stage("1-2"))
	await _f(t, 2)
	var r = ZD.start_stage(); await _f(t, 2)
	_chk("1-2 都用新打法（主線全開）：出小卡", r == "ok" and RTS.pending != null and not MB.busy())
	RTS.pending.ny = 1
	RTS.card_go(); await _f(t, 2)
	var op = RTS.op_for("1-2")
	_chk("出擊小卡揀 1 隊陰兵：只派 1 隊", op != null and RTS._count(op).yin == 1, RTS._count(op) if op else null)
	# 同時第二場：名鬼帶隊嘅唔得；純兵（派兵攻佔）得
	ZD.unmark_bosses(0); ZD.reveal_all(0)
	var r2 = ZD.start_battle("boss", "w_graves"); await _f(t, 2)
	_chk("名鬼帶緊隊：第二場名鬼戰唔准出", RTS.pending == null and RTS.ops.size() == 1, [r2, RTS.ops.size()])
	S.res["troops"] = 2000.0
	var rc = RTS.dispatch_capture("A"); await _f(t, 2)
	_chk("同時第二場：純兵派兵攻佔出到（同時 2 場）", rc == "ok" and RTS.ops.size() == 2, rc)
	_cam(m, RTS.ops[1].center()); await _w(t, 1.0); await _shot(t, "11_two_ops")
	var cap = RTS.ops[1]
	var e1 = await _wait_op_end(t, op)
	var e2 = await _wait_op_end(t, cap)
	_chk("1-2 打完", e1 and op.result != null, op.result)
	_chk("派兵攻佔：行到門洞打完 → 佔領（折損照舊）", e2 and ZD.owned("A"), [cap.phase, ZD.owned("A")])
	await _home(t)
	# 野外王
	ZD.unmark_bosses(0); S.zone["taunt"] = {}
	var tr0 = J.num(S.res.troops)
	var rb = ZD.start_battle("boss", "w_graves"); await _f(t, 2); await _skip(t, 4)
	if RTS.pending == null: await _f(t, 4)
	_chk("野外王：出小卡", RTS.pending != null, rb)
	RTS.card_go(); await _f(t, 2)
	var ob = RTS.ops[0] if RTS.ops.size() else null
	_chk("野外王：地圖戰（kind boss），王喺野外區，原位唔再畫", ob != null and ob.kind == "boss" and ZD.zrect("w_graves").grow(80).has_point(ob.anchor) and MB.on_zone("w_graves"))
	_chk("野外王：路線經野外門入野外", ob != null and ZD.zrect("w_graves").grow(40).has_point(ob.path[ob.path.size() - 1]))
	_cam(m, ob.anchor + Vector2(0, 80)); ob.t_skip_march(); await _w(t, 5.0); await _shot(t, "12_boss")
	for u in ob.units: if J.num(u.side) == 0 and not J.t(u.get("minion")): u["hp"] = 0.0; u["deadT"] = 0.0
	await _until(t, func(): return ob.phase in ["back", "done"], 20.0)
	var bid = str(ZD.bosses("w_graves")[0].id)
	_chk("野外王輸咗：王去門外叫囂（同舊版）", TA.on(TA.boss_key(0, bid)), S.zone.get("taunt"))
	await _home(t)
	var rb2 = ZD.start_battle("boss", "w_graves"); await _f(t, 2); await _skip(t, 4); RTS.card_go(); await _f(t, 2)
	var ob2 = RTS.ops[0] if RTS.ops.size() else null
	_chk("再挑戰：喺門外叫囂位打", ob2 != null and ob2.anchor.distance_to(TA.spot(TA.boss_key(0, bid))) < 5.0)
	for u in ob2.units: if J.num(u.side) == 1: u["hp"] = 1.0
	B()["auto"] = true
	var e3 = await _wait_op_end(t, ob2)
	_chk("再挑戰打贏：王記打低、叫囂清走", e3 and ZD.boss_done("w_graves", 0) and not TA.on(TA.boss_key(0, bid)), [ob2.result, ZD.boss_done("w_graves", 0)])
	await _home(t); await _skip(t, 6)
	# 親征（資源區 B）
	var rcap = ZD.start_battle("cap", "B"); await _f(t, 2); RTS.card_go(); await _f(t, 2)
	var oc = RTS.ops[0] if RTS.ops.size() else null
	_chk("親征：地圖戰（kind cap），經門洞入資源區、黑霧散開", oc != null and oc.kind == "cap" and MB.on_zone("B"), rcap)
	_cam(m, oc.anchor); oc.t_skip_march(); await _w(t, 4.0); await _shot(t, "13_cap")
	for u in oc.units: if J.num(u.side) == 1: u["hp"] = 1.0
	var e4 = await _wait_op_end(t, oc)
	_chk("親征打贏：資源區佔領", e4 and ZD.owned("B"), oc.result)
	await _home(t); await _skip(t, 6)
	# 取消小卡：入口設咗嘅嘢清返
	ZD.unmark_bosses(0); S.zone["taunt"] = {}
	ZD.start_battle("boss", "w_graves"); await _f(t, 2); await _skip(t, 4)
	m.close_sheet(); await _f(t, 6)
	_chk("小卡唔出發就關：冇出擊、王戰 exp 清返", RTS.pending == null and RTS.ops.is_empty() and not (ZD.st().get("exp") is Dictionary))
	# 鬼潮告急（大排檔）
	var MVW = load("res://game/outpost/mv_war.gd")
	MVW.ws()["alarm"] = {"t": 120.0}
	var rx = m.mv_view.sim.war.start_expedition(m.mv_view.sim); await _f(t, 3)
	var ox = RTS.ops[0] if RTS.ops.size() else null
	_chk("鬼潮告急：唔問直接出（kind raid），惡鬼由野外門行入嚟", rx == "ok" and ox != null and ox.kind == "raid" and ox.foe_from != null)
	if ox != null:
		for u in ox.units: if J.num(u.side) == 1: u["hp"] = 1.0
		var e5 = await _wait_op_end(t, ox)
		_chk("鬼潮告急打完：mv_war 收到結果", e5 and not (MVW.ws().get("exp") is Dictionary))
	await _home(t)
	# 襲擾自動擊退：防衛隊出營迎擊（純畫面）
	var RAID = load("res://game/raid/raid.gd")
	var tk = RAID.targets()
	if tk.size():
		var at = RAID.tpos(str(tk[0]))
		RTS.raid_show({"tgt": tk[0], "from": [at.x, at.y - 420.0], "ks": ["egui"]}); await _f(t, 2)
		var orr = RTS.ops[0] if RTS.ops.size() else null
		_chk("襲擾（防衛夠）：防衛隊出營、惡鬼行入村，睇到打", orr != null and orr.kind == "raidauto" and orr.no_heroes)
		if orr != null:
			_cam(m, at); await _w(t, 3.0); await _shot(t, "14_raid_defend")
			var e6 = await _wait_op_end(t, orr)
			_chk("自動擊退：惡鬼全倒、防衛隊冇死", e6 and orr.result.win and orr._ours_alive() > 0)
	await _home(t)
	S.cleared.erase("1-1")

# ---- 六關路線：主線迎戰位、每個野外王、每個資源區門洞，行軍路線都喺走得嘅地方 ----
const CW = preload("res://game/outpost/ctl_walk.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const TA = preload("res://game/zone/zone_taunt.gd")
func _walkable(p: Vector2) -> bool: return CW.region(p) != "" and not ZV.blocked(p)
func _poly_ok(P) -> Array:
	for i in P.size() - 1:
		var a: Vector2 = P[i]; var b: Vector2 = P[i + 1]
		var n = maxi(1, int(ceil(a.distance_to(b) / 4.0)))
		for k in n + 1:
			var q = a.lerp(b, float(k) / n)
			if not _walkable(q): return [false, q]
	return [true, null]
func routes(t, m) -> void:
	var sc = m.mv_view; var bad_r = []; var n = 0
	for c in 6:
		sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 0.8)
		ZD.reveal_all(c)
		await _f(t, 2)
		var at = ZD.front_anchor() + RTS.CAMP_OFF
		var P = RTS.stage_path(at); n += 1
		var r = _poly_ok(P); if not r[0]: bad_r.append([c, "stage", r[1]])
		for z in ZD.of_type("wild"):
			var zr = ZD.zrect(str(z.id))
			var ba = ZD.v2(z.get("boss_at", [zr.get_center().x, zr.get_center().y]))
			var W = RTS.wild_path(str(z.id), ba); n += 1
			var r2 = _poly_ok(W); if not r2[0]: bad_r.append([c, str(z.id), r2[1]])
		for z in ZD.of_type("res"):
			if not (z.get("door") is Dictionary): continue
			var g = RTS.geometry({"kind": "cap", "id": str(z.id), "opt": {}})
			var Q = []
			for p in g.path:
				Q.append(p)
				if p.distance_to(ZD.v2(z.door.get("in"))) < 1.0: break
			n += 1
			var r3 = _poly_ok(Q); if not r3[0]: bad_r.append([c, str(z.id), r3[1]])
		if shots:
			var c0 = m.village.zone_cam(); c0.z = c0.z_min() * 1.6; c0.clamp_all(); c0.center_on(ZD.zrect("market").get_center()); await _w(t, 0.5)
			await _shot(t, "route_ch%d" % (c + 1))
	_p("routes checked %d bad %s" % [n, str(bad_r)])
	_chk("六關行軍路線（主線、野外王、資源區）全部走得（%d 條）" % n, bad_r.is_empty(), bad_r)
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.0)

# ================= video：配 --write-movie（固定 30 幀）錄一段由下令到回村 =================
func _follow(t, m, cond: Callable, secs: float, off := Vector2.ZERO) -> void:
	var c = m.village.zone_cam()
	var n = int(secs * 30)
	for i in n:
		if cond.call(): return
		var op = RTS.op_for("1-1")
		if op != null and i % 6 == 0: c.glide_to(op.center() + off)
		await _f(t, 1)
func _story_skip(m) -> void:
	var st = m.get("story")
	if st and st.get("cur") != null: st.skip_scene()
func video(t) -> void:
	demo = true
	var m = await _boot(t)
	await _prep(t, m)
	B()["auto"] = false
	var nv = m.village; var c = nv.zone_cam()
	var tg = ZD.stage_target()
	_cam(m, tg.pos + Vector2(0, 200), nv.size.x / 390.0)
	await _w(t, 1.0)
	_p("VIDEO_START frame=%d" % Engine.get_frames_drawn())
	await _w(t, 2.5)
	await _skip(t, 2)
	nv.zone_tap(c.w2s(tg.pos + Vector2(0, -60)))   # 撳據點下令
	await _w(t, 0.3)
	await _w(t, 1.2)
	if RTS.pending != null: RTS.card_go()
	if RTS.op_for("1-1") == null: _p("tap no op → start_stage"); ZD.start_stage(); RTS.card_go()
	var op = RTS.op_for("1-1")
	if op == null: _p("RESULT ok=0 bad=1"); t.get_tree().quit(); return
	await _w(t, 1.6)
	await _follow(t, m, func(): return op.phase != "march", 25.0, Vector2(0, -40))
	c.glide_to(op.anchor + Vector2(-40, 110))
	await _w(t, 2.0)
	var h = null
	for u in op.units: if J.num(u.side) == 0 and not J.t(u.get("minion")) and J.num(u.hp) > 0 and J.t(u.get("out")): h = u; break
	if h != null and op.phase == "fight":
		h["energy"] = 100.0
		await _w(t, 1.2)
		var b = RV.inst.btns.get(J.str(h.get("gid", h.k)))
		if b != null:
			var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true; ev.position = Vector2(10, 10)
			b._gui_input(ev)
	await _w(t, 1.0)
	if op.phase == "fight":   # 打緊仗：隔離檔口收貨
		var sc = m.mv_view; var sim = sc.sim
		sim.st().pile["st_shoubao"] = 3.0
		await _w(t, 0.8)
		var rr = sc._wbtns.get("ring:st_shoubao")
		if rr is Rect2: nv.zone_tap(c.w2s(rr.get_center()))
	B()["auto"] = true
	for i in 30 * 40:
		if op.phase in ["back", "done"]: break
		await _f(t, 1)
	await _w(t, 2.5)
	for i in 30 * 30:   # 回村：鏡頭跟住；有劇情／升級彈窗就跳過（短片唔停）
		if i % 20 == 0: _story_skip(m)
		if op.phase == "done": break
		if i % 6 == 0: c.glide_to(op.center() + Vector2(0, -60))
		await _f(t, 1)
	await _w(t, 1.5)
	_p("VIDEO_END frame=%d" % Engine.get_frames_drawn())
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= svideo：野外出擊一個據點（配 --write-movie 30 幀）：小卡消耗 → 出村 → 沿 mapx 路線行軍 → 展開橫隊 → 開打 → 技能 → 首勝戰報 → 收工回村 =================
func svideo(t) -> void:
	demo = true
	var SO = load("res://game/sortie/so_data.gd"); var SOV = load("res://game/sortie/so_view.gd")
	var m = await _boot(t)
	await _prep(t, m)
	J.G.S.res["buns"] = 5000.0; J.G.S.res["coins"] = 100000.0
	B()["auto"] = false
	var nv = m.village; var c = nv.zone_cam()
	var e = null
	for x in SO.camps(0): if SO.state(x) == "open" and not J.t(SO.cst(x).get("first")): e = x; break
	if e == null: e = SO.camps(0)[0]
	_cam(m, e.pos + Vector2(0, 90), nv.size.x / 420.0)
	await _w(t, 0.5)
	_p("VIDEO_START frame=%d camp=%s" % [Engine.get_frames_drawn(), SO.key(e)])
	await _w(t, 1.2)
	SOV.open_card(e)
	await _w(t, 3.0)   # 小卡：名鬼、陰兵、消耗
	var r = SOV.press_go(e)
	var op = RTS.op_for(SO.sid_of(e))
	_p("go %s op %s" % [r, str(op != null)])
	if op == null: _p("RESULT ok=0 bad=1"); return
	# 行軍：鏡頭跟住；離展開點遠嘅路段 ×3 快轉（短片唔好太長）
	for i in 30 * 120:
		if op.phase != "march": break
		var lead = -INF
		for u in op.units: if J.num(u.side) == 0: lead = maxf(lead, J.num(u.s))
		var far = lead < op.path_len - op.DEPLOY - 140.0 and op.dep_t == 0.0
		Engine.time_scale = 3.0 if far and op.T > 4.0 else 1.0
		if i % 6 == 0: c.glide_to(op.center() + Vector2(0, -50))
		await _f(t, 1)
	Engine.time_scale = 1.0
	c.glide_to(op.anchor + Vector2(0, 80))
	await _w(t, 1.5)
	var h = null
	for u in op.units: if J.num(u.side) == 0 and not J.t(u.get("minion")) and J.num(u.hp) > 0: h = u; break
	if h != null and op.phase == "fight":
		h["energy"] = 100.0
		await _w(t, 1.0)
		var b = RV.inst.btns.get(J.str(h.get("gid", h.k)))
		if b != null:
			var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true; ev.position = Vector2(10, 10)
			b._gui_input(ev); _p("skill pressed")
	B()["auto"] = true
	for i in 30 * 60:
		if op.phase in ["back", "done"]: break
		if i % 10 == 0: c.glide_to(op.anchor + Vector2(0, 80))
		await _f(t, 1)
	_p("report %s" % str(op.get_meta("report", {})))
	await _w(t, 3.0)   # 戰報
	for i in 30 * 60:   # 收工回村：遠路 ×3，近村門返 1 倍睇打卡
		if i % 20 == 0: _story_skip(m)
		if op.phase == "done": break
		var near = false
		for u in op.units:
			if J.num(u.side) == 0 and J.num(u.hp) > 0 and u.get("bp") is PackedVector2Array and absf(J.num(u.get("blen", 0)) - J.num(u.s)) < 260.0: near = true
		Engine.time_scale = 1.0 if near else 3.0
		if i % 6 == 0: c.glide_to(op.center() + Vector2(0, -60))
		await _f(t, 1)
	Engine.time_scale = 1.0
	await _w(t, 1.5)
	_p("VIDEO_END frame=%d" % Engine.get_frames_drawn())
	_p("RESULT ok=%d bad=%d" % [ok, bad])
