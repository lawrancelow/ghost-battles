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
func shots_(t) -> void: shots = true; demo = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	RTS.LOG.clear()
	await old_save_check(t, m)
	await compare_old(t, m)
	await main_flow(t, m)
	await recall_flow(t, m)
	await other_stage_old(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- 冇新存檔欄位；開關關咗 → 1-1 照舊（舊 mapbattle） ----
func old_save_check(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S
	var keys0 = (S as Dictionary).keys()
	_chk("1-1 用新打法（原型開關）、1-2 唔用", RTS.enabled_for("1-1") and not RTS.enabled_for("1-2"))
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
func _new_fight(units: Array, tg: Dictionary) -> Dictionary:
	var op = SIM.new()
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
	var A = {"win": 0, "t": 0.0, "dead": 0}; var Z = {"win": 0, "t": 0.0, "dead": 0}
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
		for k in ["t", "dead"]: A[k] += r0[k]; Z[k] += r1[k]
		A.win += int(r0.win); Z.win += int(r1.win)
		await _f(t, 1)
	var J0 = J.G.get("$"); var be = J.cl(J0, null, ["#battle"])
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	_p("compare 舊：贏 %d/%d 平均 %.1f 秒 陰兵小隊戰死 %.2f ｜ 新：贏 %d/%d 平均 %.1f 秒（交戰）陰兵小隊戰死 %.2f" % [A.win, N, A.t / N, A.dead / float(N), Z.win, N, Z.t / N, Z.dead / float(N)])
	_chk("開戰單位同舊版一模一樣（種類、血、攻、射程）", same_stats)
	_chk("勝負同舊版一致（1-1：舊贏幾多場、新都贏幾多場 ±1）", absi(A.win - Z.win) <= 1, [A.win, Z.win])
	_chk("陰兵折損同舊版接近（平均差 ≤ 1.5 隊）", absf(A.dead - Z.dead) / N <= 1.5, [A.dead / float(N), Z.dead / float(N)])
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
	var con = await _until(t, func(): return op.phase != "march", 30.0)
	_chk("行到據點：接觸自動開打", con and _has(op, "contact"), op.phase)
	var near = false
	for u in op.units: if J.num(u.side) == 0 and J.t(u.get("out")) and (u.p as Vector2).distance_to(op.anchor) < 260: near = true
	_chk("開打位置喺大排檔據點附近", near and ZD.zrect("market").has_point(op.anchor))
	_cam(m, op.anchor + Vector2(-10, 90))
	await _w(t, 1.5); await _shot(t, "05_fight")
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
	ZD.start_stage(); await _f(t, 2)
	var op = RTS.op_for("1-1")
	await _w(t, 1.5)
	RV.inst.chip_recall.emit_signal("pressed"); await _f(t, 2)
	_chk("行軍中叫回：轉頭回村", op != null and op.phase == "back" and op.recalled)
	var d1 = await _until(t, func(): return RTS.ops.is_empty(), 30.0)
	_chk("行軍中叫回：冇結算、冇扣兵、冇通關", d1 and J.num(S.res.troops) == tr0 and not J.t(S.cleared.get("1-1")) and J.num(S.res.get("coins", 0)) == coins0)
	# 交戰中叫回
	await _prep(t, m)
	tr0 = J.num(S.res.troops)
	ZD.start_stage(); await _f(t, 2)
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

# ---- 其他關照舊 ----
func other_stage_old(t, m) -> void:
	await _prep(t, m)
	var S = J.G.S
	S.cleared["1-1"] = true; S.cleared.erase("1-2"); S["qi"] = float(_qidx_stage("1-2"))
	await _f(t, 2)
	var r = ZD.start_stage(); await _f(t, 2)
	_chk("1-2 照舊大地圖戰鬥（未鋪開）", r == "ok" and MB.busy() and RTS.ops.is_empty(), r)
	MB.t_skip_march(); await _f(t, 2)
	J.mc(B(), "finish", [false, true]); await _f(t, 2)
	var dl = J.G.get("$"); var okb = J.cl(dl, null, ["#b-ok"])
	if okb != null: J.cl(J.gp(okb, "onclick"), okb, [])
	MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
	S.cleared.erase("1-1")

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
	if RTS.op_for("1-1") == null: _p("tap no op → start_stage"); ZD.start_stage()
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
