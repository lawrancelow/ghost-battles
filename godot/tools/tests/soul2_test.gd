# [soul2] 養成第二部份測試：抄功課、名鬼圖鑑、演出、王座重遊
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> soul2 res://tools/tests/soul2_test.gd logic|shots_ 600
#   logic：圖鑑資料（101 格、四種狀態、篩選、完成獎）、抄功課（贏 3 次、每日 20、消耗、魂魄＋怨氣、鬼力 90%、05:00 重置）、
#          王座重遊（解鎖、每王每日 1 次、難度 ×1.1、掉 3 魂魄、黑白無常兩隻都掉）、演出節點（魂火、入職通知書、升職、影印戰報）、出擊打贏掛鈎
#   shots_：logic ＋ 截圖（/home/claude/docs/shots/soul2/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/shots/soul2/"
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const SOV = preload("res://game/sortie/so_view.gd")
const SOUL = preload("res://game/soul/soul_data.gd")
const S2 = preload("res://game/soul/soul2.gd")
const CX = preload("res://game/soul/soul_codex.gd")
const FX = preload("res://game/soul/soul_fx.gd")
const DAY := 86400000.0

func _p(m): print("[soul2] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
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
	for i in int(max_s / 0.1):
		if op.phase in until_phases: return
		RTS._last_f = -1
		RTS.tick(0.1)
func _rich() -> void:
	var S = J.G.S
	for k in ["buns", "coins", "wood", "rice", "planks"]: S.res[k] = 100000.0
func _join(k: String) -> void:
	if not SOUL.owned(k): load("res://native/game.gd").join_ghost(k)
func _drop_k(k: String) -> void:
	var S = J.G.S
	S["ghosts"] = (S.ghosts as Array).filter(func(g): return J.str(g.k) != k)
	S["team"] = (S.team as Array).map(func(x): return x if x == null or J.G.S.ghosts.any(func(g): return J.str(g.id) == J.str(x)) else null)
func _team() -> void:
	var S = J.G.S
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
	S["lv"] = maxf(3.0, J.num(S.lv)); S.res["troops"] = 100.0
	J.G.Battle["auto"] = true

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	SO.force_open = true
	SO.test_now = 1000000.0
	SOUL.rng.seed = 4242; SO.rng.seed = 4242
	S2.o()
	_team(); _rich()
	data_check()
	state_check()
	ms_check()
	sweep_check()
	await throne_check(t, m)
	await fx_check(t, m)
	await sortie_hook_check(t, m)
	if shots: await shot_all(t, m)
	SOUL.test_now = -1.0
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- 圖鑑資料 ----
func data_check() -> void:
	var L = S2.list()
	_chk("圖鑑 131 格（roster2 加第二批 30）", L.size() == 131, L.size())
	var ks = {}
	for x in L: ks[str(x.k)] = true
	_chk("131 格冇重複", ks.size() == 131)
	_chk("第一格係阿福", str(L[0].k) == "afu")
	var miss = []
	for k in J.G.GHOSTS:
		var d = J.G.GHOSTS[k]
		if (str(d.get("q", "")) == "名" or k == "afu") and not ks.has(k): miss.append(k)
	_chk("現有 72 隻名鬼＋阿福全部有格", miss.is_empty() and J.G.GHOSTS.size() == 73, miss)
	var nw = L.filter(func(x): return str(x.k).begins_with("nw_"))
	_chk("新鬼 26＋第二批 30 隻（roster2）、冇 Sundel Bolong、有 Teke Teke", nw.size() == 56 and not ks.has("nw_sundel") and ks.has("nw_teketeke"), nw.size())
	_chk("牛頭、馬面升名鬼有格", ks.has("niutou") and ks.has("mamian"))
	var nm_ok = true
	for x in L:
		if str(x.k) == "nw_huli" and str(x.name) != "狐妖": nm_ok = false
		if str(x.k) == "nw_zzcar" and str(x.name) != "紙紮跑車": nm_ok = false
	_chk("定案名：狐妖、紙紮跑車", nm_ok)
	var cnt = {}
	for x in L: cnt[S2.pin(str(x.k))] = int(cnt.get(S2.pin(str(x.k)), 0)) + 1
	_chk("每格都有品級（凡靈煞王＋阿福）", int(cnt.get("凡", 0)) + int(cnt.get("靈", 0)) + int(cnt.get("煞", 0)) + int(cnt.get("王", 0)) == 130 and int(cnt.get("主", 0)) == 1, cnt)   # [roster2] 100→130
	var sysc = {}
	for x in L: if str(x.k) != "afu": sysc[S2.sys_of(str(x.k))] = true
	_chk("每格都有 8 系之一", sysc.size() == 8 and not sysc.has(""), sysc.keys())
	CX.f_pin = "煞"; CX.f_sys = ""
	var fl = CX.filtered()
	_chk("篩選品級：煞 %d 隻、全部係煞" % fl.size(), fl.size() > 10 and fl.all(func(x): return S2.pin(str(x.k)) == "煞"))
	CX.f_pin = ""; CX.f_sys = "紙紮"
	fl = CX.filtered()
	_chk("篩選系：紙紮 %d 隻" % fl.size(), fl.size() >= 5 and fl.all(func(x): return S2.sys_of(str(x.k)) == "紙紮"))
	CX.f_pin = "靈"; CX.f_sys = "厲"
	fl = CX.filtered()
	_chk("篩選可以疊：靈＋厲", fl.size() >= 1 and fl.all(func(x): return S2.pin(str(x.k)) == "靈" and S2.sys_of(str(x.k)) == "厲"), fl.size())
	CX.f_pin = ""; CX.f_sys = ""
	var nolore = []
	for x in L:
		var k = str(x.k)
		var gd = J.G.GHOSTS.get(k, {})
		if str(gd.get("lore", "")) == "" and str(x.get("note", "")) == "" and not SOUL.story(k) and k != "afu": nolore.append(k)
	_chk("每隻非劇情鬼都有出處（lore 或名冊備註）", nolore.is_empty(), nolore)

# ---- 四種狀態 ----
func state_check() -> void:
	var o = SOUL.st()
	_join("n30_qionggui")
	var k2 = "n30_dugui"; if SOUL.owned(k2): _drop_k(k2)
	o.got.erase(k2); o.sh[k2] = 12.0
	var k3 = "n30_yecha"; if SOUL.owned(k3): _drop_k(k3)
	o.sh.erase(k3); o.got.erase(k3); o.seen[k3] = 1.0
	var k4 = "n30_hannya"; if SOUL.owned(k4): _drop_k(k4)
	o.sh.erase(k4); o.got.erase(k4); o.seen.erase(k4)
	_chk("狀態：已招降", S2.state("n30_qionggui") == "own")
	_chk("狀態：有魂魄未招降", S2.state(k2) == "prog")
	_chk("狀態：已遇見冇魂魄", S2.state(k3) == "seen")
	_chk("狀態：未遇見", S2.state(k4) == "unseen")
	_chk("狀態：新鬼（未有數據）＝未遇見", S2.state("nw_huapi") == "unseen")
	_chk("狀態：阿福永遠已招降", S2.state("afu") == "own")
	_chk("傳聞：未遇見顯示 lore 頭一句（≤12 字）", CX._rumor(k4).length() > 0 and CX._rumor(k4).length() <= 12, CX._rumor(k4))
	_chk("地點：未遇見顯示第幾章", CX._where(k4, true).contains("第"), CX._where(k4, true))

# ---- 每 10 隻完成獎 ----
func ms_check() -> void:
	var o = S2.o(); var S = J.G.S
	o["ms"] = {}
	var n0 = S2.got_n()
	if n0 >= 10:
		_chk("完成獎準備（已有 %d 隻）" % n0, true)
	else:
		_chk("未夠 10 隻：領唔到", S2.ms_claim(10) == "lock", n0)
	var pool = []
	for x in S2.list():
		var k = str(x.k)
		if SOUL.is_ghost(k) and not SOUL.owned(k) and not SOUL.story(k): pool.append(k)
	var i = 0
	while S2.got_n() < 10 and i < pool.size(): _join(pool[i]); i += 1
	var san0 = SOUL.san()
	if not (S.get("chests") is Dictionary): S["chests"] = {"g": 0, "b": 0, "p": 0}
	var p0 = int(J.num(S.chests.get("p", 0)))
	_chk("夠 10 隻：可以領", S2.ms_list()[0].state == "can", S2.got_n())
	_chk("領獎：散魂 +20、紫箱 +1", S2.ms_claim(10) == "ok" and SOUL.san() == san0 + S2.MS_SAN and int(J.num(S.chests.p)) == p0 + 1)
	_chk("領過唔可以再領", S2.ms_claim(10) == "got" and S2.ms_list()[0].state == "got")
	_chk("完成獎共 10 級（10…100）", S2.ms_list().size() == 10 and int(S2.ms_list()[9].m) == 100, S2.ms_list().map(func(x): return x.m))

# ---- 抄功課 ----
func sweep_check() -> void:
	var o = S2.o(); var S = J.G.S
	_team(); _rich()
	SOUL.test_now = 3000.0 * DAY + 12 * 3600000.0
	SO.test_now = SOUL.test_now
	var e = SO.camps(0)[2]
	var key = SO.key(e)
	S.sortie.camps.erase(key)
	o.swp_gp.erase(SOUL.ckey(e))
	o.fr = {"day": float(SOUL.today()), "n": {}}
	var c = SO.cst(e); c["first"] = true; c["wins"] = 2.0; c["clr"] = 0.0
	var r0 = S2.can_sweep(e)
	_chk("贏 2 次：未可以抄（why=wins）", not r0.ok and r0.why == "wins" and S2.why_text(r0).contains("2/3"), [r0.why, S2.why_text(r0)])
	c["wins"] = 3.0
	var r1 = S2.can_sweep(e)
	_chk("贏夠 3 次：可以抄", r1.ok, r1)
	var k = SOUL.guard_of(e)
	var b0 = S.res.buns; var c0 = S.res.coins; var s0 = SOUL.souls(k); var w0 = J.num(c.wins)
	var cost = r1.cost
	var r = S2.sweep(e)
	var lv = float(e.lv)
	_chk("抄功課成功", r.ok, r)
	_chk("照扣出擊消耗（壽包 %d）" % int(cost.get("buns", 0)), absf((b0 - S.res.buns) - float(cost.get("buns", 0))) < 0.01, [b0, S.res.buns, cost])
	var exp_c = -float(cost.get("coins", 0)) + SO.REW_COIN * lv + 20.0 * lv
	_chk("冥幣 ＝ −消耗＋出擊獎＋再打獎", absf((S.res.coins - c0) - exp_c) < 0.6, [S.res.coins - c0, exp_c])
	_chk("照掉主魂（×1）", SOUL.souls(k) - s0 >= SOUL.PRI[0] and SOUL.souls(k) - s0 <= SOUL.PRI[0] + 1, SOUL.souls(k) - s0)
	_chk("勝場 +1、據點清空入重生", J.num(c.wins) == w0 + 1 and SO.state(e) == "cleared")
	_chk("今日抄咗 1 次", S2.swp_today() == 1)
	_chk("戰報行有「抄功課」同魂魄", str(r.line).contains("抄功課") and str(r.line).contains("魂魄："), r.line)
	_chk("清空中：抄唔到（why=cleared）", S2.can_sweep(e).why == "cleared")
	# 怨氣照計：第 2 次 ×1、第 3 次 ×½
	c["clr"] = 0.0
	S2.sweep(e)
	c["clr"] = 0.0
	var s2 = SOUL.souls(k)
	var r3 = S2.sweep(e)
	_chk("第 3 次（同日同據點）：魂魄 ×½", r3.ok and float(r3.soul.mul) == 0.5 and SOUL.souls(k) - s2 >= 1 and SOUL.souls(k) - s2 <= 3, [r3.soul.mul, SOUL.souls(k) - s2])
	_chk("戰報行有「怨氣已散 ×½」", str(r3.line).contains("怨氣已散"))
	# 每日上限 20
	c["clr"] = 0.0
	o.swp["n"] = 20.0
	var rc = S2.can_sweep(e)
	_chk("每日上限 20：第 21 次抄唔到", not rc.ok and rc.why == "cap", rc.why)
	SOUL.test_now += DAY; SO.test_now = SOUL.test_now
	_chk("05:00 過咗：上限重置", S2.swp_today() == 0 and S2.can_sweep(e).ok)
	# 鬼力 90%
	o.swp_gp[SOUL.ckey(e)] = float(S2.team_pow()) * 1.2
	var rg = S2.can_sweep(e)
	_chk("出陣鬼力唔夠上次 90%%：抄唔到", not rg.ok and rg.why == "gp", [rg.gp, rg.need_gp])
	o.swp_gp[SOUL.ckey(e)] = float(S2.team_pow()) * 1.05
	_chk("鬼力 ≥ 上次 90%%：可以抄", S2.can_sweep(e).ok)
	# 資源唔夠
	var keep = S.res.duplicate()
	S.res["buns"] = 0.0; S.res["coins"] = 0.0
	var rp = S2.can_sweep(e)
	_chk("資源唔夠：抄唔到", not rp.ok and rp.why == "poor" or float(rp.cost.get("buns", 0)) + float(rp.cost.get("coins", 0)) == 0.0, rp.why)
	S["res"] = keep
	# 小卡掣
	SOUL.test_now = -1.0; SO.test_now = 1000000.0

# ---- 王座重遊 ----
func throne_check(t, m) -> void:
	var o = S2.o(); var S = J.G.S
	var ks = S2.kings()
	var ids = ks.map(func(x): return str(x.k))
	_chk("劇情王 7 場（餓鬼王、Toyol、老殭、Pontianak、Pocong、Penanggal、黑白無常）", ids == ["eguiking", "toyol", "laojiang", "pontianak", "pocong", "penanggal", "heiwu"], ids)
	_chk("黃總（大魔王）唔喺王座重遊", not ("huang" in ids))
	var wc = S2.king("heiwu")
	_chk("黑白無常：兩隻都掉魂魄", "baiwu" in wc.ks and "heiwu" in wc.ks, wc.ks)
	var cl0 = S.cleared.duplicate()
	S.cleared.erase("1-3")
	_chk("未打低主線 1-3：未解鎖", S2.can_throne("eguiking").why == "lock")
	S.cleared["1-3"] = true
	SOUL.test_now = 5000.0 * DAY + 12 * 3600000.0
	o.king = {"day": -1.0, "done": {}}
	for op in RTS.ops.duplicate(): RTS.ops.erase(op)
	_team()
	var c = S2.can_throne("eguiking")
	_chk("打低 1-3 後可以挑戰", c.ok, c)
	# 原王戰數值（同一場 Battle.start）
	var B = J.G.Battle
	var snap0 = RTS._start_battle(func(): J.mc(B, "start", [0.0, 2.0]))
	var hp0 = 0.0; var at0 = 0.0
	for u in snap0.get("units", []): if J.num(u.side) == 1 and J.str(u.k) == "eguiking": hp0 = J.num(u.hp); at0 = J.num(u.atk)
	var r = S2.throne_go("eguiking")
	var op = RTS.op_for(S2.throne_sid(S2.king("eguiking")))
	_chk("王座重遊出發", r == "ok" and op != null and op.kind == "throne", r)
	if op == null: S.cleared = cl0; return
	var hp1 = 0.0; var at1 = 0.0
	for u in op.units: if J.num(u.side) == 1 and J.str(u.k) == "eguiking": hp1 = J.num(u.hp); at1 = J.num(u.atk)
	_chk("難度：王血、攻 ＝ 原王戰 ×1.1", hp0 > 0 and absf(hp1 / hp0 - 1.1) < 0.01 and absf(at1 / at0 - 1.1) < 0.01, [hp0, hp1, at0, at1])
	_chk("出擊中：唔可以再開一場", S2.can_throne("eguiking").ok == false)
	var s0 = SOUL.souls("eguiking")
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0
	_ff(op, ["back", "done"]); _ff(op, ["done"])
	_chk("打贏：餓鬼王魂魄 +3", SOUL.souls("eguiking") - s0 == S2.THRONE_SOULS, SOUL.souls("eguiking") - s0)
	_chk("今日已挑戰：唔可以再打", S2.can_throne("eguiking").why == "done")
	_chk("主線冇被推（1-3 仍然係通關、冇新增關卡）", J.t(S.cleared.get("1-3")) and not S.cleared.has(S2.throne_sid(S2.king("eguiking"))))
	SOUL.test_now += DAY
	_chk("第二日 05:00 後可以再挑戰", S2.can_throne("eguiking").ok)
	# 第 5 章：原王戰有 SOFT 0.55 → ×1.1
	_chk("第 5 章王：難度倍數 ＝ 0.55×1.1", absf(S2.throne_mul(S2.king("pocong")) - 0.55 * 1.1) < 0.001, S2.throne_mul(S2.king("pocong")))
	# 輸咗唔計次數
	var rep = S2.on_throne_end("toyol", false)
	_chk("輸咗：唔記今日已打", not J.t(S2._kday().done.get("toyol")) and str(rep.head).contains("撤退"))
	S["cleared"] = cl0
	SOUL.test_now = -1.0

# ---- 演出節點 ----
func fx_check(t, m) -> void:
	var sh = FX.letter("n30_qionggui", false)
	var n = m.get_node_or_null("SoulShow")
	_chk("入職通知書演出節點", sh and n != null and not n.promote)
	n.t = 99.0; await _w(t, 0.1)
	_chk("演出時間到自動收", not is_instance_valid(n) or n.is_queued_for_deletion())
	var g = SOUL.ghost("n30_qionggui")
	var o = SOUL.st(); o.rk["n30_qionggui"] = 2.0
	FX.letter("n30_qionggui", true)
	var n2 = m.get_node_or_null("SoulShow")
	_chk("升職演出：專長 1、上限、三圍", n2 != null and n2.promote and str(n2.lines).contains("專長 1") and str(n2.lines).contains("等級上限") and str(n2.lines).contains("三圍"), n2.lines if n2 else null)
	if n2: n2.queue_free()
	o.rk["n30_qionggui"] = 0.0
	# soul_ui 掛鈎：舊卡唔再出
	load("res://game/soul/soul_ui.gd")._letter("n30_qionggui", false)
	await _w(t, 0.05)
	_chk("祭壇招降叫 _letter → 新演出（舊 SoulLetter 卡唔出）", m.get_node_or_null("SoulShow") != null and m.find_child("SoulLetter", true, false) == null)
	var n3 = m.get_node_or_null("SoulShow"); if n3: n3.queue_free()
	var cp = FX.photocopy("Lv.1 近郊據點", "抄功課")
	_chk("影印戰報卡", cp != null and m.get_node_or_null("SoulCopy") != null)
	await _w(t, 1.8)
	_chk("影印戰報卡 1.6 秒內自動收", m.get_node_or_null("SoulCopy") == null)

# ---- 出擊打贏：掛鈎（鬼力記錄、遇見、魂火） ----
func sortie_hook_check(t, m) -> void:
	var S = J.G.S; var o = S2.o()
	var sc = m.mv_view
	if sc != null and int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	_team(); _rich()
	var e = SO.camps(0)[4]
	S.sortie.camps.erase(SO.key(e))
	o.swp_gp.erase(SOUL.ckey(e))
	var gk = SOUL.guard_of(e)
	o.seen.erase(gk)
	_cam(m, e.pos + Vector2(0, 60), m.village.size.x / 420.0)
	await _w(t, 0.4)
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	_chk("出擊", r == "ok" and op != null, r)
	if op == null: return
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0
	_ff(op, ["back", "done"])
	_chk("打贏：記低今次鬼力（抄功課門檻）", J.num(o.swp_gp.get(SOUL.ckey(e), 0)) > 0, o.swp_gp.get(SOUL.ckey(e)))
	_chk("打贏：駐守鬼記遇見", SOUL.seen(gk))
	var RV = load("res://game/rts/rts_view.gd")
	var fire = RV.inst.ui.get_node_or_null("SoulFire") if RV.inst != null and RV.inst.get("ui") != null else null
	_chk("魂火演出：喺戰況條嗰層生成，目標＝戰況條", fire != null and fire.chip != null and fire.items.size() >= 1, fire)
	if fire != null:
		var cr = fire.chip.get_global_rect()
		_chk("魂火終點喺戰況條中間", fire.b.distance_to(RV.inst.ui.get_global_transform_with_canvas().affine_inverse() * cr.get_center()) < 2.0, [fire.b, cr])
		if shots:
			fire.t = 0.75; fire.set_process(false); fire.queue_redraw(); await _w(t, 0.1)
			await _shot(t, "10_soulfire_fly")
			fire.t = Fire_arrive(fire); fire.set_process(true)
			await _w(t, 0.12); await _shot(t, "11_soulfire_hit")
	_ff(op, ["done"])
	await _w(t, 1.0)
func Fire_arrive(_f) -> float: return 0.35 + 0.8 + 0.01

# ---- 截圖 ----
func shot_all(t, m) -> void:
	var S = J.G.S; var o = SOUL.st()
	_rich()
	# 砌各種狀態
	for x in [["n30_dugui", 54], ["n30_danxiao", 12], ["n30_jiugui", 25], ["pg_tuimo", 6]]:
		if SOUL.owned(x[0]): _drop_k(x[0])
		o.got.erase(x[0]); o.sh[x[0]] = float(x[1]); o.seen[x[0]] = 1.0
	o.rk["n30_qionggui"] = 3.0
	o.seen["n30_wutou"] = 1.0; o.sh.erase("n30_wutou")
	if SOUL.owned("n30_wutou"): _drop_k("n30_wutou")
	CX.f_pin = ""; CX.f_sys = ""
	Menus.open_roster(); await _w(t, 0.8)
	await _shot(t, "01_roster_btns")
	CX.open(); await _w(t, 0.8)
	await _shot(t, "02_codex_top")
	var sc = m.sheet_scroll
	sc.scroll_vertical = 420; await _w(t, 0.4); await _shot(t, "03_codex_grid")
	sc.scroll_vertical = 2400; await _w(t, 0.4); await _shot(t, "04_codex_grid_late")
	CX.f_pin = "靈"; CX.f_sys = "厲"; CX.render(); await _w(t, 0.6)
	await _shot(t, "05_codex_filter")
	CX.f_pin = ""; CX.f_sys = ""
	CX.open_detail("n30_qionggui"); await _w(t, 0.6); await _shot(t, "06_detail_own")
	sc.scroll_vertical = 600; await _w(t, 0.4); await _shot(t, "06b_detail_own_scroll")
	CX.open_detail("n30_dugui"); await _w(t, 0.6); await _shot(t, "07_detail_prog")
	o.seen.erase("n30_hannya"); o.sh.erase("n30_hannya")
	if SOUL.owned("n30_hannya"): _drop_k("n30_hannya")
	CX.open_detail("n30_hannya"); await _w(t, 0.6); await _shot(t, "08_detail_unseen")
	CX.open_detail("nw_huapi"); await _w(t, 0.6); await _shot(t, "08b_detail_new")
	S.cleared["1-3"] = true; S.cleared["2-3"] = true
	CX.open_throne(); await _w(t, 0.6); await _shot(t, "09_throne")
	m.close_sheet(); Menus.close_hook(); await _w(t, 0.5)
	# 出擊小卡：抄功課（可以／未夠勝場）
	var e = SO.camps(0)[0]
	var c = SO.cst(e); c["first"] = true; c["wins"] = 5.0; c["clr"] = 0.0
	S2.o().swp_gp.erase(SOUL.ckey(e))
	_cam(m, e.pos + Vector2(0, 80), m.village.size.x / 420.0)
	await _w(t, 0.6)
	SOV.open_card(e); await _w(t, 0.6); await _shot(t, "12_card_sweep")
	var b = SOV.card.find_child("SweepBtn", true, false) if SOV.card != null else null
	_chk("小卡有抄功課掣（可撳）", b != null and not b.disabled)
	if b != null:
		var gr = b.get_global_rect()
		var vs = t.get_viewport().get_visible_rect().size
		_chk("抄功課掣喺畫面入面、唔撞底部導航", Rect2(0, 0, vs.x, vs.y - 60).encloses(gr), [gr, vs])
		_chk("小卡冇變闊出界", SOV.card.get_global_rect().end.x <= vs.x + 0.5, [SOV.card.get_global_rect(), vs])
		_chk("小卡冇因抄功課變高出界", SOV.card.get_global_rect().end.y <= vs.y - 60, SOV.card.get_global_rect())
	S2.press_sweep(e)
	await _w(t, 0.35); await _shot(t, "13_photocopy")
	await _w(t, 1.6)
	var e2 = SO.camps(0)[3]
	var c2 = SO.cst(e2); c2["wins"] = 1.0; c2["clr"] = 0.0; c2["first"] = true
	SOV.open_card(e2); await _w(t, 0.6); await _shot(t, "14_card_sweep_locked"); SOV.close_card()
	# 招降演出：黃紙 → 火燒 → 鬼現身 → 通知書
	for x in [[0.55, "15_summon_paper"], [1.15, "16_summon_burn"], [1.95, "17_summon_ghost"], [3.4, "18_summon_letter"]]:
		FX.letter("n30_qionggui", false)
		var n = m.get_node_or_null("SoulShow")
		n.t = float(x[0]); n.set_process(false); n.queue_redraw()
		await _w(t, 0.15); await _shot(t, str(x[1]))
		n.queue_free(); await _w(t, 0.05)
	o.rk["n30_qionggui"] = 4.0
	FX.letter("n30_qionggui", true)
	var n2 = m.get_node_or_null("SoulShow")
	n2.t = 2.5 + 0.55; n2.set_process(false); n2.queue_redraw()
	await _w(t, 0.15); await _shot(t, "19_promote")
	n2.queue_free()
	o.rk["n30_qionggui"] = 3.0
