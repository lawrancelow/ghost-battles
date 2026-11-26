# [yinbing] 陰兵兵種（刀盾／長兵／弓弩／醫護）× 階級（雜兵／士兵／衛兵／親兵）測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> yinbing res://tools/tests/yinbing_test.gd logic|shots 900
#   logic：數據、★→階級、編制分隊、戰鬥單位套兵種（射程／行速／血攻）、揀少隊重分、醫護兵回血（只醫陰兵／遊魂兵、唔醫名鬼、射程、間隔）、
#          醫護兵唔出手、弓弩手射飛彈、遊魂兵唔受影響、16 張立繪、兵營面板、真戰鬥打到完冇錯
#   shots：logic ＋ 實機戰鬥截圖（/home/claude/docs/yinbing_shots/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/yinbing_shots/"
const YB = preload("res://game/yinbing/yb_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SIM = preload("res://game/rts/rts_sim.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const BK = preload("res://game/barracks/bk_data.gd")

func _p(m): print("[yb] ", m)
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
func _yin(n: int) -> Array:
	var o = []
	for i in n: o.append({"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": 100.0, "maxhp": 100.0, "atk": 10.0, "range": 38.0, "spd": 52.0})
	return o
func _cnt(us: Array) -> Dictionary:
	var c = {}
	for u in us:
		if u.get("yb_c") != null: c[str(u.yb_c)] = int(c.get(str(u.yb_c), 0)) + 1
	return c

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	S.erase("yinbing")
	# ---- 數據 ----
	_chk("數據讀到（yinbing.json）", YB.on())
	_chk("4 兵種", YB.classes().size() == 4)
	_chk("4 階級", YB.ranks().size() == 4)
	var n16 = 0
	for c in YB.classes():
		for r in YB.ranks():
			if not YB.cell(str(c.id), str(r.id)).is_empty(): n16 += 1
	_chk("16 格齊", n16 == 16, n16)
	var mp = ["za", "za", "shi", "shi", "wei", "wei", "qin"]; var good = true
	for s in 7: good = good and YB.rank_of_star(s) == mp[s]
	_chk("兵器檔 ★0–6 → 雜雜士士衛衛親", good)
	_chk("第一期：階級倍率一律 1.0", YB.rank_k("qin") == 1.0 and YB.rank_k("za") == 1.0)
	_chk("兵種倍率生效（刀盾手血 ×1.25、弓弩手血 ×0.65）", is_equal_approx(YB.mul("jin", "za", "hp"), 1.25) and is_equal_approx(YB.mul("yuan", "qin", "hp"), 0.65))
	var tot = 0.0
	for k in YB.mix(): tot += float(YB.mix()[k])
	_chk("預設編制加埋 = 1", absf(tot - 1.0) < 0.001, YB.mix())
	# ---- 分隊 ----
	_chk("0 隊冇、1 隊 → 刀盾手", YB.split(1) == ["jin"] and YB.split(0).is_empty(), YB.split(1))
	_chk("4 隊 → 刀盾 2 長兵 1 弓弩 1", YB.split(4) == ["jin", "jin", "zhong", "yuan"], YB.split(4))
	_chk("8 隊 → 刀盾 3 長兵 2 弓弩 2 醫護 1", YB.split(8) == ["jin", "jin", "jin", "zhong", "zhong", "yuan", "yuan", "yi"], YB.split(8))
	YB.set_preset("bow")
	_chk("編制預設「重弓」：8 隊有 3 隊弓弩以上", YB.split(8).count("yuan") >= 3 and YB.preset() == "bow", YB.split(8))
	YB.set_preset("std")
	# ---- 套落單位 ----
	var hero = {"side": 0.0, "k": "xiaozhi", "name": "小志", "hp": 300.0, "maxhp": 300.0, "atk": 20.0, "range": 46.0, "spd": 50.0}
	var mlu = {"side": 0.0, "k": "youhun", "name": "遊魂兵", "minion": true, "ml": 2.0, "hp": 100.0, "maxhp": 100.0, "atk": 10.0, "range": 38.0, "spd": 52.0}
	var us = _yin(8) + [hero, mlu]
	YB.force_rank = "shi"
	YB.assign(us)
	_chk("陰兵 8 隊全部分咗兵種", _cnt(us) == {"jin": 3, "zhong": 2, "yuan": 2, "yi": 1}, _cnt(us))
	_chk("名鬼、遊魂兵唔受影響", hero.get("yb_c") == null and mlu.get("yb_c") == null and mlu.range == 38.0 and hero.hp == 300.0)
	_chk("刀盾手血 ×1.25、攻 ×0.95", is_equal_approx(us[0].maxhp, 125.0) and is_equal_approx(us[0].atk, 9.5), [us[0].maxhp, us[0].atk])
	_chk("弓弩手射程 150（> 60 當遠程）", us[5].range == 150.0 and us[5].yb_c == "yuan")
	_chk("醫護兵有回血設定、階級跟 force_rank", us[7].get("yb_heal") is Dictionary and us[7].yb_r == "shi")
	_chk("單位名＝階級・兵種", str(us[0].name) == YB.name_of("jin", "shi") and str(us[0].name) != "陰兵", us[0].name)
	# 揀少隊重分
	var us2 = us.slice(0, 2)
	us2[0]["hp"] = J.num(us2[0].hp) * 1.1; us2[0]["maxhp"] = J.num(us2[0].maxhp) * 1.1   # 之後乘落去嘅血倍率（yin_k）
	YB.reassign(us2)
	_chk("揀少咗隊：2 隊重新分成刀盾＋長兵", _cnt(us2) == {"jin": 1, "zhong": 1}, _cnt(us2))
	_chk("重分：第 2 隊（長兵）先還原刀盾倍率再乘 ×0.95", is_equal_approx(us2[1].maxhp, 95.0) and us2[1].range == 56.0, us2[1].maxhp)
	_chk("重分：第 1 隊（刀盾）血 = 100 × 1.1 × 1.25", is_equal_approx(us2[0].maxhp, 137.5), us2[0].maxhp)
	# ---- 醫護兵 ----
	var sim = SIM.new()
	var med = {"side": 0.0, "minion": true, "hp": 80.0, "maxhp": 80.0, "p": Vector2(0, 0), "out": true, "yb_c": "yi", "yb_r": "wei", "yb_heal": {"t": 3.0, "r": 160.0, "pct": 0.05}, "yb_ht": 0.0}
	var a1 = {"side": 0.0, "minion": true, "hp": 50.0, "maxhp": 200.0, "p": Vector2(60, 0), "out": true}
	var a2 = {"side": 0.0, "minion": true, "hp": 150.0, "maxhp": 200.0, "p": Vector2(80, 0), "out": true}
	var far = {"side": 0.0, "minion": true, "hp": 10.0, "maxhp": 200.0, "p": Vector2(400, 0), "out": true}
	var hh = {"side": 0.0, "hp": 10.0, "maxhp": 500.0, "p": Vector2(20, 0), "out": true}
	var foe = {"side": 1.0, "minion": true, "hp": 10.0, "maxhp": 200.0, "p": Vector2(30, 0)}
	sim.units = [med, a1, a2, far, hh, foe]
	var r0 = YB.heal_tick(sim, med, 2.0)
	_chk("醫護兵：未夠 3 秒唔醫", r0 == null)
	var r1 = YB.heal_tick(sim, med, 1.1)
	_chk("醫護兵：醫範圍內最傷嗰隊陰兵（唔揀太遠、唔揀名鬼、唔揀敵人）", r1 != null and r1[1] == a1, r1[1] if r1 != null else null)
	_chk("醫護兵：回最大血 5%", r1 != null and is_equal_approx(J.num(a1.hp), 60.0), a1.hp)
	_chk("醫護兵：名鬼、敵人、遠處嘅冇被醫", hh.hp == 10.0 and foe.hp == 10.0 and far.hp == 10.0)
	# ---- 立繪 ----
	var ims = 0
	for c in YB.classes():
		for r in YB.ranks():
			if ResourceLoader.exists("res://assets/spr/yb_%s_%s_stand.webp" % [str(c.id), str(r.id)]): ims += 1
	_chk("16 張兵種×階級立繪齊", ims == 16, ims)
	var BA = load("res://game/barracks/bk_art.gd")
	var tq = BA.yb_tex("yb_jin_qin")
	_chk("親兵刀盾手立繪讀到（同一比例：衛兵高 340）", tq != null and BA.yb_tex("yb_jin_wei").get_height() == 340, tq)
	# ---- 兵營面板 ----
	S.bld["barracks"] = maxf(1.0, J.num(S.bld.get("barracks", 0)))
	var vb = VBoxContainer.new(); m.add_child(vb)
	YB.box(vb, func(): pass)
	var txt = ""
	for n in vb.find_children("*", "RichTextLabel", true, false): txt += n.text
	_chk("兵營面板：顯示階級同兵種編制", txt.find(YB.T(YB.rank("shi").n)) >= 0 and txt.find(YB.T(YB.cls("yi").n)) >= 0, txt.substr(0, 80))
	vb.queue_free()
	# ---- 真戰鬥：1-1 用 Battle.start 生單位 → RTS 模擬打到完 ----
	_team3(S)
	S.res["troops"] = 200.0
	S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
	await _f(t, 3)
	var Bt = J.G.get("Battle"); Bt["auto"] = true
	var snap = RTS._start_battle(func(): J.mc(Bt, "start", [0.0, 0.0]))
	var cc = _cnt(snap.units)
	_chk("真戰鬥：陰兵小隊按編制分兵種（8 隊）", cc.get("jin", 0) == 3 and cc.get("yi", 0) == 1, cc)
	var tg = ZD.stage_target()
	var op = SIM.new()
	op.setup(snap.units, RTS.stage_path(tg.pos + RTS.CAMP_OFF), tg.pos + RTS.CAMP_OFF, RTS.gate_pos())
	var h0 = YB.HEALS
	var fired = false; var healed = false; var med_swing = false; var nstep = 0
	while op.result == null and nstep < 30 * 200:
		op.step(1.0 / 30.0); nstep += 1
		for q in op.proj:
			if q.src is Dictionary and str(q.src.get("yb_c", "")) == "yuan": fired = true
			if q.src is Dictionary and str(q.src.get("yb_c", "")) == "yi": med_swing = true
		for u in op.units:
			if str(u.get("yb_c", "")) == "yi" and u.get("anim") != null: med_swing = true
	_chk("真戰鬥：打得完（有結果）", op.result != null, op.t)
	_chk("真戰鬥：弓弩手射飛彈", fired)
	_chk("真戰鬥：醫護兵從來唔出手", not med_swing)
	healed = YB.HEALS > h0
	_chk("真戰鬥：醫護兵有幫陰兵回血", healed, YB.HEALS - h0)
	var ok_sh = 0
	for k in ["jin", "zhong", "yuan", "yi"]:
		if cc.has(k): ok_sh += 1
	_chk("真戰鬥：四個兵種都有上陣", ok_sh == 4, cc)
	_p("真戰鬥結果 %s 時間 %.1f 秒 healed_ev=%s" % [str(op.result), op.t, str(healed)])
	if shots: await _shots(t, m)
	YB.force_rank = ""
	print("RESULT yinbing ok=%d bad=%d" % [ok, bad])

# ---- 實機截圖：真入口出擊，交戰時影（雜兵、親兵各一場）----
func _shots(t, m) -> void:
	var S = J.G.S; var nv = m.village
	for rk in ["za", "qin"]:
		YB.force_rank = rk
		S.res["troops"] = 200.0
		S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
		await _f(t, 3)
		var tg = ZD.stage_target()
		var c = nv.zone_cam()
		c.tgt = null; c.vel = Vector2.ZERO; c.center_on(tg.pos + Vector2(0, 160))
		await _w(t, 0.4)
		nv.zone_tap(c.w2s(tg.pos + Vector2(0, -60))); await _f(t, 2)
		RTS.card_go(); await _f(t, 2)
		var op = RTS.op_for("1-1")
		if op == null: _p("no op"); continue
		for i in 400:
			if op.phase != "march": break
			await _w(t, 0.1)
		c.tgt = null; c.vel = Vector2.ZERO; c.z = 2.2; c.clamp_all(); c.center_on(op.anchor + Vector2(0, 70))
		await _w(t, 2.5); await _shot(t, "fight_%s_a" % rk)
		await _w(t, 2.0); await _shot(t, "fight_%s_b" % rk)
		for i in 600:
			if op.phase in ["back", "done"] or RTS.op_for("1-1") == null: break
			await _w(t, 0.1)
		await _w(t, 0.5)
