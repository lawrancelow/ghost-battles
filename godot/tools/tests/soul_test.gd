# [soul] 魂魄招降／祭壇測試
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> soul res://tools/tests/soul_test.gd logic|shots 600
#   logic：數據（72 隻品級、90 據點駐守）、舊存檔遷移（S.soul.mig 防重複補發）、掉落（首勝、主魂、副魂保底、散魂）、
#          怨氣（第 3 次 ½、第 4 次 ¼、05:00 重置）、招降（魂魄＋心願供品＋祭壇等級＋散魂頂一半）、升職（試用→合夥人、三圍、上限）、
#          合夥人後魂魄化散魂、分解、舊直接加入改送魂魄、存在感名鬼唔散（休養）、出擊打贏掉魂魄＋戰報一行
#   shots：logic ＋ 截圖（/home/claude/docs/shots/soul/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/shots/soul/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const SOV = preload("res://game/sortie/so_view.gd")
const SOUL = preload("res://game/soul/soul_data.gd")
const SUI = preload("res://game/soul/soul_ui.gd")
const DAY := 86400000.0

func _p(m): print("[soul] ", m)
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
func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)
func _ff(op, until_phases: Array, max_s := 300.0) -> void:
	var n = int(max_s / 0.1)
	for i in n:
		if op.phase in until_phases: return
		RTS._last_f = -1
		RTS.tick(0.1)
func _rich() -> void:
	var S = J.G.S
	for k in ["buns", "coins", "wood", "rice", "planks"]: S.res[k] = 100000.0
func _drop_k(k: String) -> void:   # 測試：移走某隻鬼（唔經存在感）
	var S = J.G.S
	S["ghosts"] = (S.ghosts as Array).filter(func(g): return J.str(g.k) != k)
	S["team"] = (S.team as Array).map(func(x): return x if x == null or J.G.S.ghosts.any(func(g): return J.str(g.id) == J.str(x)) else null)

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	SO.force_open = true
	SO.test_now = 1000000.0
	SOUL.rng.seed = 777
	data_check()
	migrate_check()
	await drops_check(t, m)
	fresh_check()
	summon_check()
	promote_check()
	join_check()
	presence_check()
	await sortie_check(t, m)
	if shots: await shot_all(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- 數據 ----
func data_check() -> void:
	var D = SOUL.D()
	_chk("soul.json：定案名冊 130 隻名鬼（不計阿福；roster2 加第二批 30）都有品級、現有 72 隻全部有", D.PIN.size() == 130 and J.G.GHOSTS.keys().filter(func(k): return k != "afu" and not D.PIN.has(k)).is_empty(), D.PIN.size())
	var nocamp = []; var bad_g = []
	for c in 6:
		var cs = SO.camps(c)
		for e in cs:
			var k = SOUL.guard_of(e)
			if k == "":
				var raw = str(SOUL.D().CAMP.get(SOUL.ckey(e), ""))
				if not (raw in ["niutou", "mamian"]): nocamp.append(SOUL.ckey(e))   # 牛頭馬面：cdata 定咗升名鬼，但未有 GHOSTS 資料 → 暫時唔掉主魂
			elif not J.G.GHOSTS.has(k): bad_g.append(k)
	_chk("90 個據點都有駐守名鬼（牛頭、馬面未入名冊除外）", nocamp.is_empty() and SO.camps(0).filter(func(x): return str(x.get("bm", "")) == "").size() == 15, nocamp)
	_chk("駐守鬼全部係現有名鬼（有圖）", bad_g.is_empty(), bad_g)
	var cnt = {"凡": 0, "靈": 0, "煞": 0, "王": 0}
	for k in D.PIN: cnt[D.PIN[k]] += 1
	_chk("品級分布（按名冊 T 值）凡22＋11 靈46＋12 煞26＋7 王6（roster2 第二批 30），冇 k1/k2", cnt == {"凡": 33, "靈": 58, "煞": 33, "王": 6} and not D.PIN.has("new_k1"), cnt)
	_chk("id 統一：審批官 nw_shenpi、Teke Teke nw_teketeke（冇 nw_panguan／nw_sundel）", D.PIN.has("nw_shenpi") and D.PIN.has("nw_teketeke") and not D.PIN.has("nw_panguan") and not D.PIN.has("nw_sundel") and not JSON.stringify(D).contains("nw_panguan") and not JSON.stringify(D).contains("nw_sundel"))
	var e = SO.camps(0)[0]
	_chk("第1章第1據點：主魂窮鬼、有副魂（往後第 5 個據點）", SOUL.guard_of(e) == "n30_qionggui" and SOUL.sec_of(e) == SOUL.guard_of(SO.camps(0)[5]), [SOUL.guard_of(e), SOUL.sec_of(e)])
	var miss = []; var nopri = []
	for k in J.G.GHOSTS:
		if k == "afu" or SOUL.story(k): continue
		var src = SOUL.sources(k)
		var wild = false
		for c in 6:
			for z in J.iter(ZD.mdef(c).get("zones", [])):
				for b in J.iter(z.get("bosses", [])):
					if SOUL.king_ghost(str(b.get("id", "")), c) == k: wild = true
		if src.is_empty() and not wild: miss.append(k)
		elif src.filter(func(x): return x.pri).is_empty(): nopri.append(k)
	_chk("每隻現有非劇情名鬼起碼 1 個來源（據點主／副，或野外王首殺）", miss.is_empty(), miss)
	_p("只有副魂來源（等 cdata 補主魂據點／野外王重打）：%s" % str(nopri))
	var both = 0
	for k in D.PIN: if SOUL.sources(k).size() >= 2: both += 1
	_chk("起碼 30 隻名鬼有 ≥2 個據點來源（主＋副）", both >= 30, both)

# ---- 舊存檔遷移 ----
func migrate_check() -> void:
	var S = J.G.S
	var back = S.duplicate(true)
	S.erase("soul")
	# 砌一個「補丁前」存檔：老鬼 lv25、首勝據點、打低野外王、通關 3 關、魂飛魄散名鬼
	var NG = load("res://native/game.gd")
	for k in ["n30_dugui", "n30_yangui"]:
		if not SOUL.owned(k): NG.join_ghost(k)
	var g = SOUL.ghost("n30_dugui"); g["lv"] = 25.0; g["st"] = [10.0, 10.0, 10.0]
	var g2 = SOUL.ghost("n30_yangui"); g2["lv"] = 5.0
	var old_st = (g2.st as Array).duplicate()
	S["sortie"] = {"v": 1.0, "n": 3.0, "camps": {"0:so1_r1_1": {"first": true, "wins": 7.0}, "0:so1_r1_2": {"first": false, "wins": 0.0}}}
	if not (S.get("zone") is Dictionary): S["zone"] = {"v": 1.0, "own": {}, "boss": {}, "exp": null}
	var zb0 = (S.zone.boss as Dictionary).duplicate()
	S.zone.boss["0:zb_keeper"] = true
	var cl0 = (S.cleared as Dictionary).duplicate()
	for sid in ["1-1", "1-2", "1-3"]: S.cleared[sid] = true
	if not (S.get("presence") is Dictionary): load("res://native/presence.gd").st()
	S.presence.gone.append({"k": "n30_jiugui", "name": "酒鬼", "q": "名", "lv": 22.0, "st": [1, 1, 1]})
	S.presence.gone.append({"k": "youhun", "name": "遊魂・甲", "q": "藍", "lv": 3.0, "st": [1, 1, 1]})
	var nst = 0
	for sid in S.cleared: if RegEx.create_from_string("^\\d-\\d$").search(str(sid)) != null and J.t(S.cleared[sid]): nst += 1
	var o = SOUL.st()
	_chk("遷移：mig=1", int(J.num(o.mig)) == 1)
	_chk("遷移：lv25 老鬼送主任，三圍＝基礎×(1+6%×2)", SOUL.rank("n30_dugui") == 2 and g.st == SOUL.stat_target("n30_dugui", 2), [SOUL.rank("n30_dugui"), g.st])
	_chk("遷移：lv5 唔送職級、三圍唔減", SOUL.rank("n30_yangui") == 0 and g2.st[0] >= old_st[0], g2.st)
	_chk("遷移：已招降記 got／seen", J.t(o.got.get("n30_dugui")) and J.t(o.seen.get("n30_dugui")))
	var exp_q = SOUL.FIRST[0] + 2 * 5
	_chk("遷移：已首勝據點補首勝禮＋2×min(勝,5)（窮鬼 %d）" % exp_q, SOUL.souls("n30_qionggui") == exp_q, SOUL.souls("n30_qionggui"))
	_chk("遷移：未首勝據點唔補", SOUL.souls(SOUL.guard_of(SO.camps(0)[1])) == 0)
	_chk("遷移：打低非劇情野外王補 15（Jerangkung）", SOUL.souls("n30_jerangkung") == SOUL.KING_FIRST, SOUL.souls("n30_jerangkung"))
	_chk("遷移：通關主線每關散魂 10", SOUL.san() == SOUL.STAGE_SAN * nst, [SOUL.san(), nst])
	var gone_k = []
	for x in S.presence.gone: gone_k.append(str(x.k))
	_chk("遷移：魂飛魄散名鬼移出舊名單、送一半招降數、可重新招魂", not ("n30_jiugui" in gone_k) and "youhun" in gone_k and SOUL.souls("n30_jiugui") == 15 and SOUL.need_of("n30_jiugui") == 15 and SOUL.rank("n30_jiugui") == 2, [gone_k, SOUL.souls("n30_jiugui")])
	# 重複叫：唔會再補
	var snap = JSON.stringify(o)
	SOUL.st(); SOUL.st()
	_chk("再讀存檔：唔重複補發", JSON.stringify(SOUL.st()) == snap)
	# 模擬存讀檔（JSON 來回，數字變 float）
	S["soul"] = JSON.parse_string(JSON.stringify(o))
	_chk("存讀檔後 mig 仍然生效、唔重複", SOUL.souls("n30_qionggui") == exp_q and SOUL.san() == SOUL.STAGE_SAN * nst)
	# 還原
	for k in back: S[k] = back[k]
	for k in S.keys(): if not back.has(k): S.erase(k)
	S["soul"] = {"v": 1.0, "mig": 1.0}   # 之後嘅測試由乾淨魂魄記錄開始
	SOUL.st()

# ---- 掉落 ----
func drops_check(t, m) -> void:
	var o = SOUL.st()
	var e = SO.camps(0)[0]   # 圈 1：窮鬼
	SOUL.test_now = 1000.0 * DAY + 12 * 3600000.0
	var r0 = SOUL.on_sortie_win(e, true)
	var n0 = SOUL.souls("n30_qionggui")
	_chk("首勝：主魂 = 3～4 ＋ 首勝 10", n0 >= 13 and n0 <= 14, [n0, r0.line])
	_chk("散魂 +1（圈 1）", SOUL.san() == 1, SOUL.san())
	_chk("戰報一行：「魂魄：窮鬼 +N（x/30）…散魂 +1」", str(r0.line).begins_with("魂魄：") and str(r0.line).contains("窮鬼") and str(r0.line).contains("散魂 +1"), r0.line)
	_chk("打贏記遇見", SOUL.seen("n30_qionggui"))
	o.fr = {"day": -1.0, "n": {}}
	SOUL.rng.seed = 5; var bg0 = SOUL.souls("n30_qionggui"); SOUL.on_sortie_win(e, false, false); var dn = SOUL.souls("n30_qionggui") - bg0
	o.fr = {"day": -1.0, "n": {}}
	SOUL.rng.seed = 5; bg0 = SOUL.souls("n30_qionggui"); var rg = SOUL.on_sortie_win(e, false, true); var dg = SOUL.souls("n30_qionggui") - bg0
	_chk("打得好（用到正確應對）：主魂 +1、戰報寫明", dg == dn + 1 and str(rg.line).contains("打得好"), [dn, dg])
	o.fr = {"day": -1.0, "n": {}}
	# 副魂保底：每據點連續 3 次冇，第 4 次必得；統計比率
	var key = SOUL.ckey(e)
	o.sec[key] = 0.0
	var hits = 0; var gap = 0; var gmax = 0
	for i in 4000:
		o.fr = {"day": float(SOUL.today()), "n": {}}
		var before = SOUL.souls(SOUL.sec_of(e))
		SOUL.on_sortie_win(e, false)
		gap += 1
		if SOUL.souls(SOUL.sec_of(e)) > before: hits += 1; gmax = maxi(gmax, gap); gap = 0
	var p = hits / 4000.0
	# 理論：每 4 次窗口 p_eff = 1 / E[次數]；E = Σ (1-q)^k, k=0..3，q=0.25
	var E = 0.0
	for k in 4: E += pow(0.75, k)
	_chk("副魂 25%%＋保底：實際 %.3f（理論 %.3f），最長 %d 次（≤4）" % [p, 1.0 / E, gmax], absf(p - 1.0 / E) < 0.03 and gmax <= SOUL.SEC_PITY)
	# 圈 4：主魂 6～7
	var e4 = SO.camps(0)[13]
	o.fr = {"day": float(SOUL.today()), "n": {}}
	var k4 = SOUL.guard_of(e4); var b4 = SOUL.souls(k4)
	SOUL.on_sortie_win(e4, false)
	_chk("圈 4 主魂 6～7、散魂 +2", SOUL.souls(k4) - b4 >= 6 and SOUL.souls(k4) - b4 <= 7, [k4, SOUL.souls(k4) - b4])
	# 劇情鬼據點（小紙）：小紙未加入 → 唔掉主魂
	var ex = SO.camps(0)[11].duplicate(); ex["guard"] = "xiaozhi"   # 劇情鬼據點（zones.json 可直接寫 guard）
	var hadx = SOUL.owned("xiaozhi")
	if hadx: _drop_k("xiaozhi")
	var bx = SOUL.souls("xiaozhi")
	SOUL.on_sortie_win(ex, true)
	_chk("劇情鬼據點：劇情未加入唔掉主魂、唔放佢入陣", SOUL.souls("xiaozhi") == bx and not SOUL.guard_live(ex) and not SOUL.guard_stage(ex, {"en": ["egui", "egui"]}).has("guard"))
	if hadx: J.cl(J.G.get("joinGhost"), null, ["xiaozhi"])
	SOUL.test_now = -1.0

# ---- 怨氣 ----
func fresh_check() -> void:
	var o = SOUL.st()
	var e = SO.camps(0)[1]   # 膽小鬼
	var k = SOUL.guard_of(e)
	var bias = float(Time.get_time_zone_from_system().get("bias", 0)) * 60000.0
	var d0 = 2000.0 * DAY - bias   # 本地 00:00
	SOUL.test_now = d0 + 10 * 3600000.0   # 本地 10:00
	o.fr = {"day": -1.0, "n": {}}
	var got = []
	for i in 5:
		SOUL.rng.seed = 99   # 固定擲骰：每次 base 一樣
		var b = SOUL.souls(k)
		SOUL.on_sortie_win(e, false)
		got.append(SOUL.souls(k) - b)
	var base = got[0]
	_chk("怨氣：第 1、2 次全數，第 3 次 ½，第 4、5 次 ¼（最少 1）", got[1] == base and got[2] == maxi(1, int(round(base * 0.5))) and got[3] == maxi(1, int(round(base * 0.25))) and got[4] == got[3], got)
	_chk("小卡：怨氣散", SOUL.fresh_text(SOUL.ckey(e)).contains("散") and SOUL.fresh_mul(SOUL.ckey(e)) == 0.25)
	var e2 = SO.camps(0)[2]
	_chk("怨氣每據點各自計（另一據點仍然滿）", SOUL.fresh_mul(SOUL.ckey(e2)) == 1.0)
	SOUL.test_now = d0 + DAY + 4 * 3600000.0 + 59 * 60000.0   # 翌日 04:59
	_chk("翌日 04:59：未重置", SOUL.fresh_mul(SOUL.ckey(e)) == 0.25)
	SOUL.test_now = d0 + DAY + 5 * 3600000.0 + 60000.0   # 翌日 05:01
	_chk("翌日 05:01：怨氣重置做滿", SOUL.fresh_mul(SOUL.ckey(e)) == 1.0 and SOUL.wins_today(SOUL.ckey(e)) == 0)
	var c0 = J.num(J.G.S.res.coins)
	SOUL.test_now = -1.0
	_chk("怨氣只影響魂魄、唔郁冥幣", J.num(J.G.S.res.coins) == c0)

# ---- 招降 ----
func summon_check() -> void:
	var S = J.G.S; var o = SOUL.st()
	var k = "n30_maoshi"   # 冒失鬼（凡，第 1 章）
	if SOUL.owned(k): _drop_k(k)
	o.got.erase(k); o.sh.erase(k); o.seen.erase(k)
	S.bld["altar"] = 1.0
	_rich()
	_chk("冇魂魄：唔招得", SOUL.can_summon(k).why == "souls")
	o["san"] = 1000.0
	o.sh[k] = 20.0
	_chk("未遇見都有魂魄（有魂魄＝見過）：散魂可補", SOUL.can_summon(k).ok)
	o.sh[k] = 14.0
	_chk("散魂最多頂一半（差 16 > 15）：唔得", SOUL.can_summon(k).why == "souls", SOUL.can_summon(k))
	o.sh[k] = 15.0
	var c = SOUL.can_summon(k)
	_chk("差 15：散魂補（每隻 2 散魂＝30）", c.ok and c.sub == 15 and c.sub_cost == 30, c)
	var cs = SOUL.summon_cost(k)
	_chk("費用：冥幣 80×(章+1)、心願供品 20×(章+1)（冒失鬼預設壽包）", cs.coins == 80.0 and cs.wish == "buns" and cs.wish_n == 20.0, cs)
	var coin0 = J.num(S.res.coins); var bun0 = J.num(S.res.buns); var n0 = (S.ghosts as Array).size()
	var r = SOUL.summon(k)
	_chk("招降成功：加入名冊、職級試用", r == "ok" and SOUL.owned(k) and SOUL.rank(k) == 0 and (S.ghosts as Array).size() == n0 + 1, r)
	_chk("招降扣：魂魄清、散魂 −30、冥幣 −80、壽包 −20", SOUL.souls(k) == 0 and SOUL.san() == 970 and J.num(S.res.coins) == coin0 - 80 and J.num(S.res.buns) == bun0 - 20, [SOUL.souls(k), SOUL.san()])
	_chk("招降後 q 仍然係「名」", J.str(SOUL.ghost(k).q) == "名")
	_chk("已招降：唔可以再招", SOUL.can_summon(k).why == "owned")
	# 品級要祭壇等級
	var kl = "n30_guhangui"   # 孤寒鬼（靈）
	if SOUL.owned(kl): _drop_k(kl)
	o.got.erase(kl); o.sh[kl] = 60.0
	S.bld["altar"] = 1.0
	_chk("靈品要祭壇 Lv2", SOUL.can_summon(kl).why == "altar")
	S.bld["altar"] = 2.0
	var cs2 = SOUL.summon_cost(kl)
	var c1 = float(SOUL.ch_of(kl) + 1)
	_chk("心願供品：孤寒鬼要冥幣（招降 160×(章+1)＋心願 40×(章+1)）", cs2.wish == "coins" and cs2.coins == 160.0 * c1 and cs2.wish_n == 40.0 * c1, cs2)
	S.res["coins"] = 200.0 * c1 - 1.0
	_chk("冥幣唔夠：唔招得", SOUL.can_summon(kl).why == "coins")
	_rich()
	_chk("夠晒：招得", SOUL.summon(kl) == "ok" and SOUL.owned(kl))
	_chk("劇情鬼唔喺祭壇招（小紙）", SOUL.owned("xiaozhi") or SOUL.can_summon("xiaozhi").why == "story")

# ---- 升職 ----
func promote_check() -> void:
	var S = J.G.S; var o = SOUL.st()
	var k = "n30_maoshi"
	var g = SOUL.ghost(k)
	S.bld["altar"] = 1.0
	o.sh[k] = 5.0; o["san"] = 0.0
	_chk("正式要祭壇 Lv2", SOUL.can_promote(k).why == "altar")
	S.bld["altar"] = 9.0
	var cap0 = SOUL.cap_of(g)
	var coin0 = J.num(S.res.coins)
	_chk("升正式：魂魄 5、冥幣 50", SOUL.promote(k) == "ok" and SOUL.rank(k) == 1 and SOUL.souls(k) == 0 and J.num(S.res.coins) == coin0 - 50)
	_chk("三圍 ＝ 基礎 ×1.05（凡）", g.st == SOUL.stat_target(k, 1), [g.st, SOUL.stat_target(k, 1)])
	_chk("等級上限 +2", SOUL.cap_of(g) == cap0 + 2, [cap0, SOUL.cap_of(g)])
	# 名冊升級：超過 ghostCap 都升得
	var NG = load("res://native/game.gd")
	g["lv"] = NG.ghost_cap()
	var lv0 = J.num(g.lv)
	NG.n_roster_act("up", g.id)
	_chk("名冊：職級令等級上限 +2（ghostCap 之後仲升得）", J.num(g.lv) == lv0 + 1, [lv0, g.lv])
	var re = NG.n_roster()
	var ent = {}
	for x in re.list: if J.str(x.id) == J.str(g.id): ent = x
	_chk("名冊顯示品級、職級", str(ent.get("extra", [])).contains("職級：正式"), ent.get("extra"))
	# 一路升到合夥人
	var need_total = 0
	for r in range(2, 6): need_total += SOUL.rank_cost(k, r)
	o.sh[k] = float(need_total)
	for r in range(2, 6): SOUL.promote(k)
	_chk("升到合夥人（5 級）用晒 %d 隻" % need_total, SOUL.rank(k) == 5 and SOUL.souls(k) == 0, [SOUL.rank(k), SOUL.souls(k)])
	_chk("合夥人三圍 ＝ 基礎 ×1.25（凡；其餘品 ×1.20）、上限 +10", g.st == SOUL.stat_target(k, 5) and SOUL.stat_target("n30_guhangui", 5)[0] == round(J.G.GHOSTS.n30_guhangui.base[0] * 1.2) and SOUL.cap_of(g) == cap0 + 10)
	_chk("專長格：合夥人 2、試用 0、王品試用 1", SOUL.perk_slots(k) == 2 and SOUL.perk_slots("n30_guhangui") == 0 and SOUL.perk_slots("laojiang") == 1)
	_chk("合夥人唔可以再升", SOUL.can_promote(k).why == "max")
	var s0 = SOUL.san()
	var gg = SOUL.gain(k, 4, "test")
	_chk("合夥人之後魂魄自動化散魂（凡 ×1）", SOUL.souls(k) == 0 and SOUL.san() == s0 + 4 and gg.to_san == 4)
	# 散魂頂升職（冇上限）
	var k2 = "n30_guhangui"
	o.sh[k2] = 0.0; o["san"] = 999.0
	_chk("升職散魂頂替封頂一半：0/10 唔得", SOUL.can_promote(k2).why == "souls")
	o.sh[k2] = 5.0
	var c = SOUL.can_promote(k2)
	_chk("升職散魂頂替：靈差 5 隻 × 4 散魂 = 20", c.ok and c.sub == 5 and c.sub_cost == 20, c)
	# 分解
	o.sh[k2] = 10.0; o["san"] = 0.0; S.bld["altar"] = 5.0
	var got = SOUL.dismantle(k2, 10)
	_chk("分解：靈 10 隻 → 散魂 floor(10×2×1.10)=22", got == 22 and SOUL.san() == 22 and SOUL.souls(k2) == 0, got)

# ---- 舊直接加入途徑 → 送魂魄 ----
func join_check() -> void:
	var o = SOUL.st()
	var k = "n30_kappa"
	if SOUL.owned(k): _drop_k(k)
	o.got.erase(k); o.dir.erase(k); o.sh.erase(k)
	J.cl(J.G.get("joinGhost"), null, [k])
	_chk("舊途徑（例如巡陰簽約）：唔直接加入，送夠招降數魂魄", not SOUL.owned(k) and SOUL.souls(k) == SOUL.need_of(k), SOUL.souls(k))
	J.cl(J.G.get("joinGhost"), null, [k])
	_chk("同一隻第二次：再送 10", SOUL.souls(k) == SOUL.need_of(k) + 10)
	var had = SOUL.owned("toyol")
	if had: _drop_k("toyol")
	J.cl(J.G.get("joinGhost"), null, ["toyol"])
	_chk("劇情鬼（Toyol）照舊直接加入", SOUL.owned("toyol"))

# ---- 存在感：名鬼唔散，改休養 ----
func presence_check() -> void:
	var PR = load("res://native/presence.gd")
	var p = PR.st()
	var g = SOUL.ghost("n30_maoshi")
	if g == null or p == null: _chk("存在感測試準備", false); return
	p.p[J.str(g.id)] = 1.0
	p.warn[J.str(g.id)] = 1.0; p.cd[J.str(g.id)] = 1.0   # 舊存檔：已經喺倒數
	p["grace"] = 0.0
	PR.update()
	var scn = PR.scenes.filter(func(s): return str(s.get("kind")) == "farewell" and is_same(s.get("g"), g))
	_chk("名鬼存在感跌到底：唔入魂飛魄散倒數、冇道別", not p.cd.has(J.str(g.id)) and scn.is_empty())
	_chk("名鬼改做「休養」", PR.resting(g) and J.t(p.get("rest", {}).get(J.str(g.id))) and PR.badge(g).contains("休養"))
	PR.vanish(g)
	_chk("就算叫 vanish：名鬼都唔會散", SOUL.owned("n30_maoshi"))
	p.p[J.str(g.id)] = 100.0
	PR.update()
	_chk("存在感返嚟：休養解除", not J.t(p.get("rest", {}).get(J.str(g.id))))

# ---- 出擊打贏：戰報一行、駐守鬼喺據點 ----
func sortie_check(t, m) -> void:
	var S = J.G.S
	var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
	S["lv"] = maxf(3.0, J.num(S.lv)); S.res["troops"] = 100.0
	J.G.Battle["auto"] = true
	_rich()
	var e = SO.camps(0)[4]   # 圈 2
	S.sortie.camps.erase(SO.key(e))
	var stg = SOUL.guard_stage(e, SO.stage_of(e))
	_chk("據點敵人有駐守名鬼", SOUL.guard_of(e) in stg.en and stg.get("guard") == SOUL.guard_of(e), stg.en)
	var info = SUI.card_info(e)
	_chk("小卡資料：駐守、怨氣、副魂、散魂", info.k == SOUL.guard_of(e) and str(info.fresh).contains("怨氣") and info.k2 != "" and int(info.san) == 1, info)
	var gk = SOUL.guard_of(e)
	var b0 = SOUL.souls(gk)
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	_chk("出擊", r == "ok" and op != null, r)
	if op == null: return
	var gu = op.units.filter(func(u): return J.num(u.side) == 1 and J.str(u.get("k")) == gk)
	_chk("戰場上有駐守名鬼", gu.size() >= 1)
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0
	_ff(op, ["back", "done"]); _ff(op, ["done"])
	var rep = RTS.last_report
	_chk("打贏掉主魂（首勝 +8 起）", SOUL.souls(gk) - b0 >= SOUL.PRI[1] + SOUL.FIRST[1], SOUL.souls(gk) - b0)
	_chk("戰報有魂魄一行", str(rep.get("soul", "")).begins_with("魂魄：") and str(rep.get("lost", [])).contains("魂魄："), rep.get("soul"))

# ---- 截圖 ----
func _altar(t, m, tb: String, name: String) -> void:
	SUI.tab = tb
	Menus.open_bld("altar")
	await _w(t, 0.7)
	await _shot(t, name)
func shot_all(t, m) -> void:
	var S = J.G.S; var o = SOUL.st()
	S.bld["altar"] = 3.0
	_rich()
	o["san"] = 37.0
	for x in [["n30_qionggui", 30], ["n30_dugui", 54], ["n30_yecha", 33], ["n30_danxiao", 12], ["n30_jerangkung", 20], ["n30_taozhai", 3]]:
		if SOUL.owned(x[0]): _drop_k(x[0])
		o.got.erase(x[0]); o.sh[x[0]] = float(x[1]); o.seen[x[0]] = 1.0
	o.sh["n30_guhangui"] = 12.0; o.sh["pg_tuimo"] = 6.0
	await _altar(t, m, "summon", "01_altar_summon")
	var sc = m.sheet_scroll
	sc.scroll_vertical = 700; await _w(t, 0.4); await _shot(t, "02_altar_summon_scroll")
	sc.scroll_vertical = 0
	# 招降演出：入職通知書
	SOUL.summon("n30_qionggui"); SUI._letter("n30_qionggui", false)
	await _w(t, 0.3); await _shot(t, "03_letter")
	await _w(t, 3.0)
	await _altar(t, m, "promote", "04_altar_promote")
	await _altar(t, m, "san", "05_altar_san")
	await _altar(t, m, "fodder", "06_altar_fodder")
	m.close_sheet(); await _w(t, 0.5)
	# 出擊小卡
	var e = SO.camps(0)[0]
	S.sortie.camps.erase(SO.key(e))
	_cam(m, e.pos + Vector2(0, 80), m.village.size.x / 420.0)
	await _w(t, 0.6)
	SOV.open_card(e); await _w(t, 0.6); await _shot(t, "07_card_guard"); SOV.close_card()
	var e2 = SO.camps(0)[9]
	SO.cst(e2)
	_cam(m, e2.pos + Vector2(0, 80), m.village.size.x / 420.0)
	o.seen.erase(SOUL.guard_of(e2)); o.sh.erase(SOUL.guard_of(e2))
	SOV.open_card(e2); await _w(t, 0.6); await _shot(t, "08_card_unseen"); SOV.close_card()
	# 打贏戰報
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	if op != null:
		for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0
		_ff(op, ["back"])
		await _w(t, 0.6); await _shot(t, "09_report")
		_ff(op, ["done"])
