# [raid] 村子被惡鬼襲擾測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> raid res://tools/tests/raid_test.gd logic|all 900
#   logic：開始條件（餓鬼王＋劇情）、頻率與預告、劇情／戰鬥／新手期間唔計時、離線最多一次、自動擊退、停工 3 分鐘（產出停）、
#          連續 3 次壞咗要修、修好恢復、擊退重置連續、親自迎戰（行動按鈕 act_targets、大地圖 kind raid 落點）、舊存檔升級
#   all：logic ＋ 截圖（/home/claude/docs/raid_shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/raid_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const RAID = preload("res://game/raid/raid.gd")
const RV = preload("res://game/raid/raid_view.gd")
const AT = preload("res://game/outpost/act_targets.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
var MS = load("res://game/outpost/mv_story.gd")
var MB = load("res://game/zone/zone_battle.gd")
var shots := false

func _p(m): print("[raid] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	if not shots: return
	await _f(t, 3)
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
	load("res://game/rts/rts.gd").force = 0   # [rts] 呢個測試測舊戰鬥接口／數值（新地圖打法見 rts_test）
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
func _ok_btn(t) -> void:
	var dl = J.G.get("$")
	var okb = J.cl(dl, null, ["#b-ok"]) if dl != null else null
	if okb != null and okb.get("onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])
	await _w(t, 0.3)
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
func r(): return RAID.st()
# 而家／之後幾秒（毫秒鐘，RAID.now_override）
func _now() -> float: return RAID.now_ms()
func _adv(sec: float) -> void: RAID.now_override = RAID.now_ms() + sec * 1000.0
# 強制下一隻惡鬼去 key（預告完，下一格到）
func _force(key: String, def := -1) -> void:
	var rr = r()
	var ap = RAID.approach(key)
	rr["ph"] = "warn"; rr["left"] = 0.2
	rr["cur"] = {"tgt": key, "dir": ap[0], "from": [ap[1].x, ap[1].y], "pow": float(RAID.foe_pow()), "ks": RAID.foe_kinds(), "t": 0.0, "ci": float(RAID.ci())}
	if def >= 0: rr.cur["force"] = float(def)
func _tick(dt := 0.5) -> void: RAID.tick(null, dt)
# 惡鬼行到、圍住到時間：襲擾成功
func _let_fail(key: String) -> void:
	_force(key, 0)
	_tick(0.5)
	for i in 200:
		if RAID.phase() != "siege": break
		_tick(2.0)
func _rates() -> Dictionary: return J.cl(J.G.get("ratesPerMin"), null, [])

func logic(t) -> void: await _run(t)
func all(t) -> void: shots = true; await _run(t)

func _run(t) -> void:
	load("res://game/econ/pace.gd").force = 2   # [ux] 呢個測試驗正常階段數值（前期節奏另有 econ_test）
	var m = await _boot(t)
	var S = J.G.S
	_team3(S); S.res["troops"] = 300.0
	var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	for id in ["wood", "rice", "plank", "bun", "store", "home", "camp"]: S.bld[id] = maxf(1.0, J.num(S.bld.get(id, 0)))
	await _w(t, 0.5)
	_chk("第 1 關分區地圖開住", ZD.on())
	await start_cond(t, m)
	await freq(t, m)
	await hold(t, m)
	await offline(t, m)
	await auto_repel(t, m)
	await stop3(t, m)
	await break3(t, m)
	await fight(t, m)
	await upgrade(t, m)
	RAID.hold_fn = Callable(); RAID.now_override = 0.0
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 開始條件 =================
func start_cond(t, m) -> void:
	var S = J.G.S
	RAID.t_reset()
	RAID.hold_fn = func(): return ""
	ZD.unmark_bosses(0)
	if S.get("cleared") is Dictionary: S.cleared.erase("1-3")
	MS.seen_d().erase(RAID.INTRO)
	_tick()
	_chk("餓鬼王未打低：唔開始", not RAID.unlocked() and not J.t(r().on))
	ZD.mark_all_bosses(0)
	_tick()
	_chk("打低餓鬼王：劇情入佇列（等下一個任務先播）、未開始計時", RAID.king_done() and MS.zq().has(RAID.INTRO) and not J.t(r().on) and J.t(r().iq), MS.zq())
	var b = MS.beat(RAID.INTRO)
	var sc0 = MS.build_scene(b)
	var yue = ""; for l in b.scene.lines: yue += str(l[1])
	var zh = ""; for l in b.scene.lines: zh += str(l[2])
	_chk("劇情：港式粵語原句＋中文（兩版都有）", yue.contains("佢哋") and yue.contains("唔") and not zh.contains("佢哋") and sc0.lines.size() == 6, sc0.lines.size())
	_chk("劇情：有講餓鬼王倒咗、手下搵新地盤", yue.contains("餓鬼王") and yue.contains("新地盤"))
	_chk("劇情：分區劇情（守一個任務只放一段故事，用 mv_story 佇列）", MS.is_zone(b) and str(b.when.kind) == "raid_intro")
	_tick()
	_chk("劇情未播：仍然唔開始", not J.t(r().on))
	MS.mark(RAID.INTRO, 1.0)
	_tick()
	_chk("劇情播咗：開始，第一次 %d 秒後到" % int(RAID.TUNE.first), J.t(r().on) and str(r().ph) == "idle" and absf(J.num(r().left) - float(RAID.TUNE.first)) < 0.01, r().left)
	# 劇情 beat 喺 mv_story 播（auto_on）：佇列 → 播放（播完記 seen）
	var keep = MS.auto_on
	MS.seen_d().erase(RAID.INTRO); MS.zq().clear()
	MS.mark("zs0_map_enter", 1.0); MS.mark("zs0_boss_win_zb_eguiking", 1.0)
	MS.zone_ev("raid_intro", "")
	var nz = MS.next_zone(m.mv_view.sim)
	_chk("mv_story 揀到呢段劇情嚟播", str(nz.get("id", "")) == RAID.INTRO, nz.get("id", ""))
	MS.mark(RAID.INTRO, 1.0); MS.auto_on = keep

# ================= 頻率與預告 =================
func freq(t, m) -> void:
	var rr = r()
	var ok_r = true
	for i in 300:
		var g = RAID.next_gap()
		if g < 480.0 or g > 720.0: ok_r = false
	_chk("每次相隔 8～12 分鐘（480～720 秒）", ok_r and RAID.TUNE.every_min == 480.0 and RAID.TUNE.every_max == 720.0)
	rr["ph"] = "idle"; rr["left"] = 61.0
	_tick(0.5)
	_chk("距離到達 >60 秒：未預告", str(rr.ph) == "idle")
	RAID.NEWS.clear()
	_tick(1.0)
	_chk("距離到達 60 秒：預告（揀咗目標、方向）", str(rr.ph) == "warn" and rr.cur is Dictionary and RAID.all_targets().has(str(rr.cur.tgt)) and str(rr.cur.dir) in ["N", "S", "E", "W"], rr.cur)
	await _f(t, 3)
	var rv = m.village.get_node("RaidView"); var bar = rv.bar; var bt = str(rv.bar_l.text)
	_chk("預告：畫面上方橫條出字（方向＋目標＋倒數）", bar.visible and bt.contains(RAID.tname(str(rr.cur.tgt))) and bt.contains("面有一隊") and bt.contains("秒"), bt)
	_chk("預告：橫條喺大排檔 HUD 下面、畫面上方", bar.global_position.y < m.village.global_position.y + m.village.size.y * 0.35, bar.global_position.y)
	var n0 = J.num(rr.n)
	for i in 29: _tick(2.0)
	_chk("預告 58 秒：未到", str(rr.ph) == "warn")
	S_troops(300.0)
	_tick(2.0)
	_chk("預告 60 秒後到達（防衛夠：自動擊退）", J.num(rr.n) == n0 + 1.0 and str(rr.ph) == "idle", [rr.ph, rr.n])
	_chk("擊退之後下一次 8～12 分鐘後", J.num(rr.left) >= 480.0 and J.num(rr.left) <= 720.0, rr.left)
func S_troops(n: float) -> void: J.G.S.res["troops"] = n

# ================= 劇情／戰鬥／新手中唔計時 =================
func hold(t, m) -> void:
	var S = J.G.S; var rr = r()
	RAID.hold_fn = Callable()
	var qi0 = J.num(S.get("qi", 0))
	S["qi"] = 0.0
	rr["ph"] = "idle"; rr["left"] = 61.0
	_chk("新手（主線任務未夠 %d 個）：唔計時" % int(RAID.TUNE.min_qi), RAID.hold_reason(m) == "newbie", RAID.hold_reason(m))
	_tick(5.0)
	_chk("新手：倒數冇郁", J.num(rr.left) == 61.0 and str(rr.ph) == "idle")
	S["qi"] = 20.0
	_chk("過咗新手期：可以計", RAID.hold_reason(m) == "", RAID.hold_reason(m))
	var Sy = J.G.get("Story")
	J.mc(Sy, "queue", [{"style": "talk", "lines": [["阿福", "測試"], ["小紙", "測試二"]]}])
	await _f(t, 2)
	_chk("劇情播緊：唔計時", RAID.hold_reason(m) == "story", RAID.hold_reason(m))
	RAID.tick(m, 5.0)
	_chk("劇情播緊：倒數冇郁、冇預告", J.num(rr.left) == 61.0 and str(rr.ph) == "idle")
	await _skip(t, 2)
	B()["active"] = true
	rr["ph"] = "idle"; rr["left"] = 61.0
	_chk("戰鬥中：唔計時", RAID.hold_reason(m) == "battle")
	RAID.tick(m, 5.0)
	_chk("戰鬥中：倒數冇郁", J.num(rr.left) == 61.0)
	B()["active"] = false
	RAID.tick(m, 2.0)
	_chk("冇劇情冇戰鬥：照計（入預告）", str(rr.ph) == "warn", [rr.ph, rr.left])
	# 預告途中開戰：唔會趁打緊到達
	rr["left"] = 1.0
	B()["active"] = true
	RAID.tick(m, 2.0)
	_chk("預告途中開戰：唔會到達", str(rr.ph) == "warn")
	B()["active"] = false
	S["qi"] = maxf(qi0, 20.0)
	RAID.hold_fn = func(): return ""
	_tick(2.0)
	if str(rr.ph) == "siege": _tick(200.0)

# ================= 離線最多積一次 =================
func offline(t, m) -> void:
	var rr = r()
	rr["ph"] = "idle"; rr["left"] = 500.0; rr["cur"] = null
	var n0 = J.num(rr.n)
	rr["seen"] = _now() - 5.0 * 3600.0 * 1000.0   # 離開 5 個鐘（夠嚟 25 次）
	_tick(0.0)
	_chk("離線 5 個鐘返嚟：即刻預告一次（唔會一次過到幾次）", str(rr.ph) == "warn" and J.num(rr.left) <= 60.0 and J.num(rr.left) >= 59.0 and J.num(rr.n) == n0, [rr.ph, rr.left, rr.n])
	S_troops(300.0)
	for i in 31: _tick(2.0)
	_chk("離線積嘅一次到咗（只一次），之後重新 8～12 分鐘", J.num(rr.n) == n0 + 1.0 and str(rr.ph) == "idle" and J.num(rr.left) >= 480.0 - 0.01, [rr.n, rr.left])
	rr["seen"] = _now() - 3600.0 * 1000.0
	_tick(0.0)
	_chk("再離線：都係最多一次", str(rr.ph) == "warn" and J.num(rr.n) == n0 + 1.0)
	rr["left"] = 20.0
	rr["seen"] = _now() - 600.0 * 1000.0
	_tick(0.0)
	_chk("預告途中離開：返嚟重新預告 60 秒（唔趁你唔喺度打）", str(rr.ph) == "warn" and absf(J.num(rr.left) - 60.0) < 0.01, rr.left)
	rr["seen"] = _now() - 10.0 * 1000.0
	var l0 = J.num(rr.left)
	_tick(0.5)
	_chk("相隔 10 秒唔當離線", absf(J.num(rr.left) - (l0 - 0.5)) < 0.01)
	rr["ph"] = "idle"; rr["left"] = 500.0; rr["cur"] = null

# ================= 自動擊退 =================
func auto_repel(t, m) -> void:
	var S = J.G.S; var rr = r()
	var BK = load("res://game/barracks/bk_data.gd")
	var lv0 = J.num(S.bld.get("barracks", 0))
	var army0 = S.get("army")
	if army0 is Dictionary: army0 = army0.duplicate(true)
	S_troops(300.0)
	# ① 冇兵營：全部陰兵算待命
	S.bld["barracks"] = 0.0
	S["army"] = {"def": 50.0}   # 冇兵營嘅殘留派遣唔計
	var dp = RAID.def_pow()
	_chk("冇兵營：防衛戰力＝全部陰兵 × 加成 × %.2f（保底）" % RAID.TUNE.def_frac, dp == int(floor(300.0 * BK.troop_mul() * RAID.TUNE.def_frac)) and RAID.deployed_pow() == 0 and dp > 0, dp)
	_chk("冇兵營、唔派兵：初期襲擾守得住（惡鬼戰力 ≤ 防衛）", RAID.foe_pow(0) <= dp and RAID.foe_pow(5) <= dp, [RAID.foe_pow(0), RAID.foe_pow(5), dp])
	S_troops(60.0)
	_chk("冇兵營、得 60 陰兵（第 3 級任務送嘅數）：第一次襲擾都守得住", RAID.foe_pow(0) <= RAID.def_pow(), [RAID.foe_pow(0), RAID.def_pow()])
	S_troops(300.0)
	# ② 有兵營、未派防衛
	S.bld["barracks"] = 1.0
	S["army"] = {}
	BK.set_def(0)
	var dp2 = RAID.def_pow()
	_chk("有兵營未派防衛：防衛戰力＝待命 × %.2f" % RAID.TUNE.def_frac, RAID.deployed_pow() == 0 and dp2 == int(floor(float(BK.power()) * RAID.TUNE.def_frac)) and dp2 > 0, dp2)
	_chk("有兵營未派防衛：初期襲擾都守得住", RAID.foe_pow(0) <= dp2, [RAID.foe_pow(0), dp2])
	# ③ 派咗防衛：用兵營算法（bk_data.def_power），比唔派更穩
	BK.set_def(120)
	var dp3 = RAID.def_pow()
	_chk("派咗防衛：防衛戰力＝兵營 def_power × %.1f ＋ 待命 × %.2f" % [RAID.TUNE.def_full, RAID.TUNE.def_frac], RAID.deployed_pow() == BK.def_power() and BK.def_power() > 0 and dp3 == int(floor(float(BK.def_power()) * RAID.TUNE.def_full + float(BK.power()) * RAID.TUNE.def_frac)), [dp3, BK.def_power(), BK.power()])
	_chk("派咗防衛：比唔派更穩", dp3 > dp2, [dp3, dp2])
	if S.ghosts.size():
		S.army["cap_def"] = [S.ghosts[0].id]
		_chk("派咗防衛＋防衛隊長：再高", RAID.def_pow() >= dp3, [RAID.def_pow(), dp3])
	S["army"] = {"def": 0.0}
	_chk("S.army 欄位唔齊都讀得", RAID.def_pow() >= 0)
	# 還原
	S.bld["barracks"] = lv0
	if army0 is Dictionary: S["army"] = army0
	else: S.erase("army")
	BK.set_def(0)
	_chk("惡鬼戰力：第 1 關容易（≤ 保底防衛）", RAID.foe_pow() <= RAID.def_pow(), [RAID.foe_pow(), RAID.def_pow()])
	rr.streak["b:bun"] = 2.0
	var c0 = J.num(S.res.coins)
	_force("b:bun")
	RAID.NEWS.clear()
	_tick(0.5)
	_chk("防衛夠：自動擊退", str(rr.ph) == "idle" and RAID.state_of("b:bun") == "", rr.ph)
	_chk("自動擊退：小收入（冥幣 +%d）" % int(RAID.TUNE.auto_coins), absf(J.num(S.res.coins) - c0 - float(RAID.TUNE.auto_coins)) < 0.01, J.num(S.res.coins) - c0)
	var has_news = false
	for e in RAID.NEWS: if e.k == "repel" and e.how == "auto": has_news = true
	_chk("自動擊退：有小提示", has_news)
	_chk("擊退：嗰處連續計數歸零", RAID.streak("b:bun") == 0)
	await _f(t, 2)

# ================= 停工 3 分鐘 =================
func stop3(t, m) -> void:
	var S = J.G.S; var rr = r()
	RAID.now_override = _now()
	var g = S.ghosts[0]; var post0 = g.get("post")
	g["post"] = "bun"
	var r0 = _rates()
	_chk("包子鋪有人做：有產出", J.num(r0.get("bao", 0)) > 0.0, r0.get("bao"))
	S_troops(0.0)
	_force("b:bun", 0)
	_tick(0.5)
	_chk("防衛唔夠：惡鬼行去目標（圍住）", str(rr.ph) == "siege")
	_chk("圍住期間可以親自迎戰（行動按鈕登記 kind raid）", _at_raid().size() == 1)
	_tick(float(RAID.TUNE.walk) + float(RAID.TUNE.siege) - 1.0)
	_chk("未夠時間：仲圍住", str(rr.ph) == "siege")
	_tick(2.0)
	_chk("唔理：襲擾成功 → 停工", RAID.state_of("b:bun") == "down" and str(rr.ph) == "idle", RAID.state_of("b:bun"))
	_chk("停工 3 分鐘", absf(RAID.down_left("b:bun") - 180.0) < 1.0, RAID.down_left("b:bun"))
	_chk("連續第 1 次", RAID.streak("b:bun") == 1)
	var r1 = _rates()
	_chk("停工：包子鋪冇產出", J.num(r1.get("bao", 0)) == 0.0, r1.get("bao"))
	_chk("停工中嘅唔會再被揀", not RAID.targets().has("b:bun"))
	if shots:
		var nv = m.village; nv.zone_cam().center_on(RAID.tpos("b:bun") + Vector2(0, -60))
		await _w(t, 1.0); await _shot(t, "raid_02_down_bun")
	_adv(179.0); _tick(0.5)
	_chk("179 秒：仲停工", RAID.state_of("b:bun") == "down")
	_adv(2.0); _tick(0.5)
	_chk("3 分鐘後：恢復開工、產出返", RAID.state_of("b:bun") == "" and J.num(_rates().get("bao", 0)) > 0.0)
	# 大排檔停工
	_let_fail("market")
	var sim = m.mv_view.sim
	var any_sid = ""
	for sid in sim.st().st: any_sid = str(sid); break
	_chk("大排檔被襲擾：全部檔停工", RAID.state_of("market") == "down" and sim.war.blocked(sim, any_sid), any_sid)
	if shots:
		m.village.zone_cam().center_on(RAID.tpos("market") + Vector2(0, -60))
		await _w(t, 1.0); await _shot(t, "raid_03_down_market")
	_adv(181.0); _tick(0.5)
	_chk("大排檔恢復", not sim.war.blocked(sim, any_sid))
	# 資源區停工
	S.zone.own["0:A"] = true
	var bid = "b_strip"
	S.bld[bid] = maxf(1.0, J.num(S.bld.get(bid, 0)))
	g["post"] = bid
	var e0 = CE.rates().has(bid)
	_let_fail(RAID.tkey_z("A"))
	_chk("資源區被襲擾：區內建築停工（%s）" % bid, e0 and not CE.rates().has(bid) and RAID.bid_down(bid), [e0, RAID.bid_down(bid)])
	if shots:
		m.village.zone_cam().center_on(RAID.tpos(RAID.tkey_z("A")) + Vector2(0, -40))
		await _w(t, 1.0); await _shot(t, "raid_04_down_zoneA")
	_adv(181.0); _tick(0.5)
	_chk("資源區恢復", CE.rates().has(bid))
	g["post"] = post0
	RAID.now_override = 0.0

func _at_raid() -> Array:
	var o = []
	for cb in AT.providers:
		for x in cb.call(null): if x.kind == "raid": o.append(x)
	return o

# ================= 連續 3 次壞咗、修理 =================
func break3(t, m) -> void:
	var S = J.G.S; var rr = r()
	RAID.now_override = _now()
	var key = "b:plank"
	var g = S.ghosts[0]; var post0 = g.get("post"); g["post"] = "plank"
	S.res["wood"] = 500.0
	_let_fail(key); _adv(181.0); _tick(0.5)
	_let_fail(key); _adv(181.0); _tick(0.5)
	_chk("連續 2 次：停工完恢復（未壞）", RAID.state_of(key) == "" and RAID.streak(key) == 2)
	_let_fail(key)
	_chk("連續第 3 次：壞咗", RAID.state_of(key) == "broken" and RAID.streak(key) == 3)
	_adv(3600.0); _tick(0.5)
	_chk("壞咗：過幾耐都唔會自己好", RAID.state_of(key) == "broken")
	_chk("壞咗：冇產出（棺材板）", J.num(_rates().get("planks", 0)) == 0.0)
	_chk("壞咗：唔會再被揀", not RAID.targets().has(key))
	if shots:
		m.village.zone_cam().center_on(RAID.tpos(key) + Vector2(0, -60))
		await _w(t, 1.0); await _shot(t, "raid_05_broken_plank")
	await _f(t, 3)
	var hit = null
	for h in RV.hits: if h[1] == "repair" and h[2] == key: hit = h
	_chk("壞咗：建築上面有「撳我修理」", hit != null)
	var cost = RAID.repair_cost(key)
	S.res["planks"] = 0.0; S.res["coins"] = 0.0
	_chk("資源唔夠：修唔到", not RAID.can_repair(key) and not RAID.repair(key))
	if hit != null:
		RV.tap(m, (hit[0] as Rect2).get_center())
		await _f(t, 3)
		_chk("撳壞咗嘅建築：出修理面板（掣灰咗）", m.sheet.visible and _sheet_btn(m) != null and _sheet_btn(m).disabled)
		m.close_sheet()
	S.res["planks"] = 1000.0; S.res["coins"] = 1000.0
	if hit != null:
		RV.tap(m, (hit[0] as Rect2).get_center())
		await _f(t, 3)
		if shots: await _shot(t, "raid_06_repair_sheet")
		var b = _sheet_btn(m)
		_chk("夠資源：修理掣撳得", b != null and not b.disabled)
		if b != null: b.pressed.emit()
		await _f(t, 2)
	else: RAID.repair(key)
	_chk("修理：扣資源（%s）" % RAID.cost_txt(cost), absf(J.num(S.res.planks) - (1000.0 - float(cost.planks))) < 0.01 and absf(J.num(S.res.coins) - (1000.0 - float(cost.coins))) < 0.01)
	_chk("修好：恢復運作、連續計數歸零、有產出", RAID.state_of(key) == "" and RAID.streak(key) == 0 and J.num(_rates().get("planks", 0)) > 0.0)
	_chk("修好：可以再被揀", RAID.targets().has(key))
	# 擊退會重置連續計數
	_let_fail(key); _adv(181.0); _tick(0.5)
	_let_fail(key); _adv(181.0); _tick(0.5)
	S_troops(300.0); _force(key); _tick(0.5)
	_chk("連續 2 次之後擊退一次：計數歸零", RAID.streak(key) == 0)
	_let_fail(key); _adv(181.0); _tick(0.5)
	_chk("之後再失守：重新由第 1 次計（只停工唔壞）", RAID.streak(key) == 1 and RAID.state_of(key) == "")
	g["post"] = post0
	RAID.now_override = 0.0
func _sheet_btn(m) -> Button:
	for c in m.sheet_body.get_children():
		if c is Button and c.text.contains("修理"): return c
	return null

# ================= 親自迎戰 =================
func fight(t, m) -> void:
	var S = J.G.S; var rr = r()
	await _skip(t, 2)
	S_troops(0.0)
	var key = "b:bun"
	rr.streak[key] = 2.0
	if shots:
		_force(key, 0); rr["left"] = 45.0; rr["ph"] = "warn"
		m.village.zone_cam().center_on(RAID.tpos(key) + Vector2(0, -60))
		await _w(t, 1.0); await _shot(t, "raid_01_warn")
	_force(key, 0); _tick(0.5)
	_tick(float(RAID.TUNE.walk) * 0.5)
	if shots:
		m.village.zone_cam().center_on(RAID.siege_pos() + Vector2(0, -40))
		await _w(t, 1.0); await _shot(t, "raid_07_siege_walk")
	_tick(float(RAID.TUNE.walk))
	if shots:
		m.village.zone_cam().center_on(RAID.tpos(key))
		await _w(t, 1.0); await _shot(t, "raid_08_siege")
	var a = _at_raid()
	_chk("行動按鈕：登記 kind raid（名、位置、戰力、go）", a.size() == 1 and str(a[0].name).contains(RAID.tname(key)) and a[0].pos is Vector2 and a[0].go is Callable and int(a[0].foe_pow) > 0, a)
	await _f(t, 3)
	var hit = null
	for h in RV.hits: if h[1] == "fight": hit = h
	_chk("惡鬼身上有「撳我迎戰」", hit != null)
	var res = a[0].go.call() if a.size() else ""
	await _f(t, 3)
	var mb = MB.cur
	_chk("撳迎戰：大地圖即時戰鬥 kind raid", res == "ok" and MB.busy() and mb.kind == "raid" and BtRun.cur == null, res)
	_chk("落點：目標建築（唔係大排檔）", mb != null and mb.raid_at is Vector2 and mb.field.get_center().distance_to(RAID.tpos(key)) < 260.0 and not ZD.zrect("market").has_point(mb.field.get_center()), mb.field if mb else null)
	var t0 = J.num(rr.cur.t); _tick(5.0)
	_chk("迎戰中：圍住倒數停咗", J.num(rr.cur.t) == t0)
	_chk("迎戰中：唔再顯示行動按鈕", _at_raid().is_empty())
	if shots:
		await _w(t, 2.5); await _shot(t, "raid_09_fight_march")
	MB.t_skip_march(); await _w(t, 1.5)
	if shots: await _shot(t, "raid_10_fight")
	var c0 = J.num(S.res.coins)
	J.mc(B(), "finish", [true]); await _f(t, 3); await _ok_btn(t)
	_tick(0.5)
	_chk("打贏：擊退、連續計數歸零、冥幣 +%d" % int(RAID.TUNE.fight_coins), str(rr.ph) == "idle" and RAID.streak(key) == 0 and J.num(S.res.coins) - c0 >= float(RAID.TUNE.fight_coins) - 0.01, [rr.ph, J.num(S.res.coins) - c0])
	_chk("打贏：唔污染主線通關紀錄", not J.t(S.cleared.get(RAID.fight_sid())))
	await _until(t, func(): return not MB.busy(), 25.0)
	# 打輸
	await _skip(t, 2)
	_force(key, 0); _tick(0.5)
	RAID.start_fight(); await _f(t, 3)
	MB.t_skip_march(); await _f(t, 2)
	J.mc(B(), "finish", [false]); await _f(t, 3); await _ok_btn(t)
	_tick(0.5)
	_chk("打輸：襲擾成功（停工）", RAID.state_of(key) == "down" and RAID.streak(key) == 1)
	await _until(t, func(): return not MB.busy(), 25.0)
	_adv(181.0); _tick(0.5); RAID.now_override = 0.0
	# 資源區落點
	await _skip(t, 2)
	var zk = RAID.tkey_z("A")
	_force(zk, 0); _tick(0.5)
	RAID.start_fight(); await _f(t, 3)
	mb = MB.cur
	_chk("落點擴到資源區：戰場喺資源區 A", mb != null and ZD.zrect("A").grow(4).encloses(mb.field), mb.field if mb else null)
	MB.t_skip_march(); await _f(t, 2)
	J.mc(B(), "finish", [true]); await _f(t, 3); await _ok_btn(t)
	_tick(0.5)
	await _until(t, func(): return not MB.busy(), 25.0)
	# 冇隊伍
	var tm = S.team; S["team"] = []
	_force(key, 0); _tick(0.5)
	_chk("冇出陣隊伍：唔開打（提示揀隊）", RAID.start_fight() == "noteam" and not MB.busy())
	S["team"] = tm
	_tick(200.0)
	_adv(200.0); _tick(0.5); RAID.now_override = 0.0

# ================= 舊存檔升級 =================
func upgrade(t, m) -> void:
	var S = J.G.S
	S.erase("raid"); S.erase("army")
	_chk("舊存檔冇 S.raid：產出掛鈎當冇事", not RAID.post_down("bun") and not RAID.market_down() and not RAID.bid_down("b_strip"))
	_tick(0.5)
	var rr = S.get("raid")
	_chk("舊存檔：自動補 S.raid、已打低餓鬼王＋劇情播過 → 開始", rr is Dictionary and J.t(rr.on) and rr.streak is Dictionary and rr.down is Dictionary and rr.broken is Dictionary)
	S["raid"] = {"on": 1.0, "ph": "idle", "left": 100.0}
	var r2 = RAID.st()
	_chk("舊版欄位唔齊：補齊、保留原值", J.num(r2.left) == 100.0 and r2.has("streak") and r2.has("broken") and r2.has("down") and r2.has("n"))
	_tick(0.5)
	_chk("補齊之後照行", absf(J.num(r2.left) - 99.5) < 0.01, r2.left)
	# 已經過咗第 1 關嘅舊存檔（冇睇過呢段劇情）：唔補播，系統通知一句就開始
	var sc = m.mv_view
	S.erase("raid"); MS.seen_d().erase(RAID.INTRO)
	sc.sim.st().ci = 1.0; sc._after_move(); await _w(t, 1.5)
	RAID.hold_fn = func(): return ""
	_tick(0.5)
	var r3 = RAID.st()
	_chk("第 2 關舊存檔：唔等第 1 關劇情，系統通知（style sys）後開始", J.t(r3.note) and J.t(r3.on) and not MS.zq().has(RAID.INTRO), [r3.note, r3.on])
	_chk("第 2 關：惡鬼較強、用該關惡鬼", RAID.foe_pow() > int(RAID.TUNE.pow_base) and RAID.foe_name() == "惡鬼")
	await _skip(t, 2)
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.5)
