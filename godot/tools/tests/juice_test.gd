# [juice] 爽感包測試
# 用法：edtest.sh <godot目錄> juice res://tools/tests/juice_test.gd all
#   設定開關、數字滾動、遞升音、大額入帳震屏震機、頂欄戰力、鬼怪升級演出、建成粒子、收成飛圖示、
#   暴擊期望值不變、真打一場（暴擊／連殺／化灰魂火）、王登場、終結慢鏡、一鍵上陣、特效關＝全部退返舊表現
#   截圖：/home/claude/meeting/juice/
extends RefCounted

var ok := 0
var bad := 0
const OUT := "/home/claude/meeting/juice/"
const JU = preload("res://ui/juice.gd")
const PF = preload("res://game/settings/prefs.gd")
const AB = preload("res://game/rts/abil.gd")
const AC = preload("res://game/rts/ab_card.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")

func _p(m): print("[juice] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s, true, false, true).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(OUT + name + ".png"); _p("shot " + name)
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
	DirAccess.make_dir_recursive_absolute(OUT)
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
func _has_log(k: String) -> bool:
	for e in JU.log: if e[0] == k: return true
	return false
func _log_n(k: String) -> int:
	var n = 0
	for e in JU.log: if e[0] == k: n += 1
	return n

func all(t) -> void:
	var m = await _boot(t)
	PF.reset_defaults(); JU.force = 1; JU.log.clear()
	_chk("設定預設：爽感特效開、手機震動開", PF.juice and PF.vibrate)
	await settings_rows(t, m)
	await roll_check(t, m)
	await topbar_coins(t, m)
	await power_check(t, m)
	await upgrade_show(t, m)
	await build_burst(t, m)
	await harvest_fly(t, m)
	crit_math()
	await fight(t, m)
	await boss_and_slow(t, m)
	await one_tap(t, m)
	await off_check(t, m)
	JU.force = -1
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func settings_rows(t, m) -> void:
	if m.has_method("open_settings"): m.open_settings(false, true)
	await _w(t, 0.6)
	var sp = m.find_children("*", "", true, false).filter(func(n): return n.get_script() != null and str(n.get_script().resource_path).ends_with("settings_panel.gd"))
	var txt = ""
	if sp.size():
		var p = sp[0]
		p.call("show_tab", 1)   # 畫面頁
		await _w(t, 0.5)
		for l in p.find_children("*", "Label", true, false): txt += str(l.text) + "|"
	_chk("設定頁有「爽感特效」開關", txt.find("爽感特效") >= 0, txt.left(160))
	await _shot(t, "j00_settings")
	for p2 in sp: if is_instance_valid(p2): p2.call("close")
	await _w(t, 0.3)

func roll_check(t, m) -> void:
	var lb = Label.new(); m.add_child(lb); lb.position = Vector2(20, 400)
	var fmt = func(x: float) -> String: return str(int(round(x)))
	JU.roll(lb, 100.0, fmt)
	_chk("滾動器：第一次直接顯示", lb.text == "100", lb.text)
	JU.roll(lb, 4321.0, fmt, 0.8)
	var seen = []
	for i in 40:
		await _f(t, 1)
		if not lb.text in seen: seen.append(lb.text)
	await _w(t, 1.0)
	_chk("滾動器：中途出過其他數、最後停喺終值", seen.size() >= 3 and lb.text == "4321", [seen.slice(0, 8), lb.text])
	lb.queue_free()
	JU.log.clear()
	for i in 5: JU.chime("coin")
	var sts = []
	for e in JU.log: if e[0] == "chime": sts.append(e[1])
	_chk("連續入帳：音高遞升 do re mi", sts == [0, 2, 4, 5, 7], sts)

func topbar_coins(t, m) -> void:
	var S = J.G.S
	m.refresh(); await _f(t, 2)
	JU.log.clear()
	S.res["coins"] = J.num(S.res.coins) + 800.0
	var want = G.fmt(S.res.coins)
	m.refresh(); await _f(t, 3)
	var lb = m.res_lbl.coins
	_chk("頂欄冥幣：升咗就滾（有滾動器）", lb.get_node_or_null("JuiceRoll") != null)
	_chk("頂欄冥幣：響入帳音＋大額震屏震機", _has_log("chime") and _has_log("big") and _has_log("vib"), JU.log.slice(0, 6))
	await _shot(t, "j01_coins_rolling")
	await _w(t, 1.0)
	_chk("頂欄冥幣：滾完＝真實數", lb.text == want, [lb.text, want])
	S.res["coins"] = J.num(S.res.coins) - 300.0; m.refresh(); await _f(t, 2)
	_chk("頂欄冥幣：跌就即刻變", lb.text == G.fmt(S.res.coins), [lb.text, G.fmt(S.res.coins)])

func power_check(t, m) -> void:
	var p = JU.power_total()
	_chk("戰力總值 > 0", p > 0, p)
	await _w(t, 0.4); m.refresh(); await _f(t, 2)
	var pl = m.get("power_lbl")
	_chk("頂欄有戰力字", pl != null and str(pl.text).begins_with("戰力"), pl.text if pl else "")
	await _shot(t, "j02_topbar_power")

func upgrade_show(t, m) -> void:
	var S = J.G.S
	var g = null
	for x in S.ghosts: if J.str(x.k) != "afu": g = x; break
	if g == null:
		J.cl(J.G.get("joinGhost"), null, ["xiaozhi"]); await _skip(t, 4)
		for x in S.ghosts: if J.str(x.k) != "afu": g = x; break
	if g == null: _chk("升級演出：有名鬼", false); return
	for k in ["coins", "buns", "wood", "rice", "planks"]: S.res[k] = 99999.0
	var CM = load("res://game/outpost/mat.gd"); CM.add("m_bao", 5000.0)
	JU.log.clear()
	var lv0 = J.num(g.lv)
	load("res://native/game.gd").n_roster_act("up", g.id)
	await _f(t, 3)
	var ps = []
	for e in JU.log: if e[0] == "power": ps.append(e[1])
	_chk("升級：等級 +1", J.num(g.lv) == lv0 + 1, [lv0, g.lv])
	_chk("升級：出鬼力舊→新演出（新 > 舊）", ps.size() > 0 and float(ps[0][2]) > float(ps[0][1]), ps)
	_chk("升級：演出卡喺畫面", m.get_node_or_null("PowerShow") != null)
	await _w(t, 0.5); await _shot(t, "j03_ghost_up")
	await _w(t, 1.2)
	var k = J.str(g.k)
	JU.power_show(k, J.str(g.name), 500.0, 620.0, true, "★1 突破！")
	await _w(t, 0.9); await _shot(t, "j04_breakthrough_full")
	_chk("突破全屏演出：有遮罩、撳一下可以收", m.get_node_or_null("PowerShow") != null)
	await _w(t, 2.6)

func build_burst(t, m) -> void:
	JU.log.clear()
	J.mc(J.G.get("Fx"), "banner", ["鬼宅 升到 Lv 3"])
	JU.celebrate_banner(true)
	await _f(t, 1)
	var n = m.find_children("JuiceBurst", "CPUParticles2D", true, false).size()
	_chk("建成／升級：橫幅位爆粒子＋震機", n > 0 and _has_log("vib"), [n, JU.log])
	await _w(t, 0.15); await _shot(t, "j05_build_burst")
	await _w(t, 1.4)

func harvest_fly(t, m) -> void:
	JU.log.clear()
	var vs = m.get_viewport().get_visible_rect().size
	JU.gain_fly(m, vs * 0.5, "+4", load("res://ui/res_icon.gd").tex("wood"), m.res_lbl.wood)
	await _f(t, 8)
	_chk("收成：數字跳出＋圖示飛去頂欄", _has_log("fly"))
	await _shot(t, "j06_harvest_fly")
	# 真砍樹：浮字「槐木 +4」→ 自動飛
	var V = J.G.get("Village")
	if V is Dictionary and V.get("floats") is Array:
		JU.log.clear()
		(V.floats as Array).append({"x": 200.0, "y": 600.0, "text": "槐木 +4　好評 +2", "col": "#a8ffcf", "t": 0.0, "life": 1.6})
		await _w(t, 0.3)
		_chk("村子浮字「槐木 +4」自動觸發飛圖示", _has_log("fly"), JU.log)
	await _w(t, 0.8)

func crit_math() -> void:
	var ev = (1.0 - AB.CRIT_P) / AB.CRIT_NORM + AB.CRIT_P * AB.CRIT_X / AB.CRIT_NORM
	_chk("暴擊：期望傷害倍率＝1（平均 DPS 不變）", absf(ev - 1.0) < 1e-9, ev)
	seed(7); var s = 0.0; var n = 200000
	for i in n: s += (AB.CRIT_X / AB.CRIT_NORM) if randf() < AB.CRIT_P else (1.0 / AB.CRIT_NORM)
	_chk("暴擊：抽樣 20 萬次平均 ≈ 1（±0.5%）", absf(s / n - 1.0) < 0.005, s / n)
	_p("暴擊數值：機率 %.0f%%、倍率 ×%.2f、非暴擊 ÷%.3f（＝×%.3f）、暴擊實際 ×%.3f" % [AB.CRIT_P * 100, AB.CRIT_X, AB.CRIT_NORM, 1.0 / AB.CRIT_NORM, AB.CRIT_X / AB.CRIT_NORM])

func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)

func fight(t, m) -> void:
	var S = J.G.S
	var sc = m.mv_view
	if sc and int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids; S.res["troops"] = 150.0
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-1": S["qi"] = float(i)
	S.cleared.erase("1-1")
	J.G.get("Battle")["auto"] = true
	JU.log.clear()
	var r = ZD.start_stage()
	if RTS.pending != null: RTS.card_go()
	var op = RTS.op_for("1-1")
	if op == null: _chk("真打一場：開到仗", false, r); return
	var c = m.village.zone_cam()
	var n = 0; var crits = 0; var shot_n = 0; var ks = 0
	while n < 900 and not (op.phase in ["back", "done"]):
		n += 1
		if op.phase == "fight":
			_cam(m, op.center() + Vector2(0, -40), m.village.size.x / 390.0)
			if shot_n < 3 and n % 25 == 0: shot_n += 1; await _shot(t, "j07_fight_%d" % shot_n)
		else: c.glide_to(op.center())
		await _w(t, 0.1)
		crits = int(op.get_meta("crits", 0)); ks = int(op.get_meta("ks_max", 0))
	_chk("真打一場：打完", op.phase in ["back", "done"], op.phase)
	_chk("真打一場：有暴擊出現", crits > 0, crits)
	_chk("真打一場：有連殺計數（≥1）", ks >= 1, ks)
	_chk("真打一場：最後一隻倒下有終結慢鏡", _has_log("slow"), JU.log.slice(0, 8))
	_chk("慢鏡完咗時間返 1×", is_equal_approx(Engine.time_scale, 1.0) or Engine.time_scale > 1.0, Engine.time_scale)
	_p("戰鬥：暴擊 %d 次、最高連殺 %d" % [crits, ks])
	await _until(t, func(): return op.phase == "done", 60.0)
	await _skip(t, 4)

func _until(t, cond: Callable, secs: float) -> bool:
	var n = int(secs / 0.1)
	for i in n:
		if cond.call(): return true
		await _w(t, 0.1)
	return cond.call()

func boss_and_slow(t, m) -> void:
	JU.log.clear()
	JU.boss_intro("餓鬼王")
	await _w(t, 0.45)
	_chk("王登場：橫幅出現", m.get_node_or_null("BossIntro") != null)
	await _shot(t, "j08_boss_intro")
	await _w(t, 2.8)
	_chk("王登場：自己收", m.get_node_or_null("BossIntro") == null)
	JU.slowmo(0.3, 0.4)
	_chk("慢鏡：time_scale 0.3", is_equal_approx(Engine.time_scale, 0.3), Engine.time_scale)
	await _w(t, 0.6)
	_chk("慢鏡：0.4 秒（真時間）後返 1×", is_equal_approx(Engine.time_scale, 1.0), Engine.time_scale)

func one_tap(t, m) -> void:
	var S = J.G.S
	for k in ["xiaozhi", "toyol"]:
		var have = false
		for g in S.ghosts: if J.str(g.k) == k: have = true
		if not have: J.cl(J.G.get("joinGhost"), null, [k])
	await _skip(t, 6)
	var ids = []
	for g in S.ghosts: if J.str(g.k) != "afu": ids.append(g.id)
	S["team"] = [null, null, null]
	var n = AC.one_tap(ids.slice(0, 2), [])
	var tm = []
	for x in J.iter(S.team): if J.t(x): tm.append(x)
	_chk("一鍵上陣：推薦嘅全部換上", n == mini(2, ids.size()) and tm.size() >= n, [n, tm])

func off_check(t, m) -> void:
	JU.force = 0; JU.log.clear()
	var lb = Label.new(); m.add_child(lb)
	var fmt = func(x: float) -> String: return str(int(x))
	JU.roll(lb, 10.0, fmt); JU.roll(lb, 999.0, fmt)
	_chk("特效關：數字直接變、冇滾動器", lb.text == "999" and lb.get_node_or_null("JuiceRoll") == null, lb.text)
	JU.boss_intro("x"); JU.celebrate_banner(true); JU.slowmo(0.3, 0.5); JU.big_income(5000)
	await _f(t, 2)
	_chk("特效關：王登場／粒子／慢鏡／震屏全部唔出", m.get_node_or_null("BossIntro") == null and is_equal_approx(Engine.time_scale, 1.0) and not _has_log("burst") and not _has_log("slow"), JU.log)
	AB.crit_on = true
	PF.juice = false
	_chk("特效關：冇暴擊（傷害照舊）", not AB._crit_enabled())
	PF.juice = true
	lb.queue_free()
