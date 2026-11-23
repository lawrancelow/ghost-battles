# [barracks] 陰兵兵營＋派遣＋名鬼分配 測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> barracks res://tools/tests/barracks_test.gd all <秒>
#   派遣後數量、戰力計算、名鬼一職、清剿收入與折損（含離線上限）、舊存檔升級（唔變弱）、敬禮觸發、劇情只播一次、行動目標
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const BK = preload("res://game/barracks/bk_data.gd")
const BP = preload("res://game/barracks/bk_patrol.gd")
const AT = preload("res://game/outpost/act_targets.gd")
const NG = preload("res://native/game.gd")

func _p(m): print("[bk] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
func _boot(t):
	load("res://game/rts/rts.gd").force = 0   # [rts] 呢個測試測舊戰鬥接口／數值（新地圖打法見 rts_test）
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
func _named(S) -> Array:
	var o = []
	for g in S.ghosts: if BK.is_named(g): o.append(g)
	return o
func _roles(S, g) -> int:   # 呢隻鬼而家有幾多份工
	var n = 0; var a = BK.st()
	if S.team.has(g.id): n += 1
	if BK.village_post(g.get("post")): n += 1
	for x in a.cap_def: if J.str(x) == J.str(g.id): n += 1
	for k in a.cap_sweep: if J.str(a.cap_sweep[k]) == J.str(g.id): n += 1
	return n

func all(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	BK.install()
	_chk("兵營已登記入建築表／次序／POS", J.G.BUILDINGS.has("barracks") and J.G.BLD_ORDER.has("barracks") and J.G.POS.has("barracks") and DB.D.BUILDINGS.has("barracks"))
	_chk("分區地圖：兵營喺村子區入面", not ZD.on() or ZD.zrect("village").has_point(Vector2(J.G.POS.barracks[0], J.G.POS.barracks[1])), J.G.POS.barracks)

	_layout()

	# ================= 1. 舊存檔升級：戰力唔變弱 =================
	S.erase("army"); S.bld["home"] = 5.0; S.bld.erase("barracks"); S.res["troops"] = 500.0
	var old_pow = int(floor(500.0 * (1.0 + 0.08 * 4.0)))
	_chk("舊存檔（民宅 Lv5、冇兵營）：戰力同舊公式一樣 %d" % old_pow, ZD.power() == old_pow, ZD.power())
	_chk("遷移：保底倍率 1.32", absf(J.num(S.army.floor) - 1.32) < 0.001 and S.army.has("cap_def") and S.army.sweep is Dictionary, S.army)
	S.bld["home"] = 6.0
	_chk("遷移後再升民宅：唔再加戰力（加成已搬去兵營）", ZD.power() == old_pow)
	S.bld["barracks"] = 3.0
	_chk("兵營 Lv3（×1.24 < 保底 1.32）：仍然 %d" % old_pow, ZD.power() == old_pow, ZD.power())
	S.bld["barracks"] = 5.0
	_chk("兵營 Lv5（×1.40 > 保底）：戰力 700", ZD.power() == 700, ZD.power())
	_chk("戰鬥陰兵加成 troop_mul 同步", absf(ZD.troop_mul() - 1.40) < 0.001)
	var cap0 = 150 + 150 * 6 + 50 * J.num(S.bld.get("camp", 0))
	_chk("陰兵上限 +100×Lv", absf(NG.troop_cap() - (cap0 + 500.0)) < 0.01, NG.troop_cap())
	var rt = J.num(NG.rates_per_min().troops)
	_chk("民宅招兵速度 ×(1+0.15×Lv)", absf(rt - (1.2 + 1.3 * 6) * 1.75) < 0.01, rt)
	# 新存檔：冇民宅加成
	S.erase("army"); S.bld["home"] = 1.0; S.bld["barracks"] = 0.0; S.res["troops"] = 400.0
	_chk("新存檔（民宅 Lv1、冇兵營）：戰力 = 陰兵", ZD.power() == 400 and absf(J.num(S.army.floor) - 1.0) < 0.001)

	# ================= 2. 起兵營（照建築卡流程）＋劇情一次 =================
	S.bld["barracks"] = 0.0; S.army.erase("story")
	S.bld["home"] = 0.0
	_chk("未有民宅：兵營未解鎖", not NG.bld_unlocked("barracks") and NG.bld_req("barracks").contains("民宅"), NG.bld_req("barracks"))
	S.bld["home"] = 1.0
	_chk("有民宅：兵營解鎖", NG.bld_unlocked("barracks"))
	S.res["planks"] = 5000.0; S.res["coins"] = 50000.0
	var N = J.gp(J.G.UI, "_n")
	J.mc(N, "bldAct", ["barracks", "build", null])
	_chk("建造：兵營 Lv1", BK.lv() == 1, S.bld.get("barracks"))
	var story = m.get("story")
	_chk("第一次建成：劇情排咗隊／播緊", J.t(S.army.get("story")) and story != null and story.busy())
	await _skip(t, 4)
	BK.on_built("barracks")
	_chk("再叫一次：唔會再播", story == null or not story.busy())
	var sc = BK.story_scene()
	_chk("劇情 2～5 句", sc.lines.size() >= 2 and sc.lines.size() <= 5)
	var h0 = S.get("hero", {}).duplicate()
	S["hero"] = {"name": "阿慧", "full": "陳慧", "en": "Wai", "sex": "f", "set": true}
	var txt = ""
	for l in sc.lines: txt += str(DB.N(l[0])) + str(DB.L(l[1]))
	_chk("女主版：稱呼經 DB.N（少爺→大小姐、阿福→阿慧）", txt.contains("大小姐") and not txt.contains("少爺") and txt.contains("阿慧") and not txt.contains("阿福"), txt.substr(0, 60))
	var lg = DB.lang; DB.lang = "yue"; var ty = ""
	for l in sc.lines: ty += str(DB.L(l[1]))
	DB.lang = "zh"; var tz = ""
	for l in sc.lines: tz += str(DB.L(l[1]))
	DB.lang = lg
	_chk("粵語原句／中文兩版", ty.contains("冇腳") and tz.contains("沒腳") and not tz.contains("冇腳"), [ty.substr(0, 20), tz.substr(0, 20)])
	S["hero"] = h0
	J.mc(N, "bldAct", ["barracks", "up", null])
	_chk("升級：照原本建築升級（Lv2）", BK.lv() == 2 or J.num(S.bld.house) < 2, [BK.lv(), S.bld.house])
	S.bld["barracks"] = 2.0

	# ================= 3. 派遣：數量＋戰力 =================
	S.res["troops"] = 400.0; S.army["def"] = 0.0; S.army["sweep"] = {}
	var mul = BK.troop_mul()
	BK.set_def(120)
	_chk("防衛 120：待命 280", BK.def_n() == 120 and BK.standby() == 280)
	_chk("攻佔戰力只計待命", ZD.power() == int(floor(280 * mul)), [ZD.power(), mul])
	_chk("防衛戰力 = 防衛 × 倍率（冇隊長）", BK.def_power() == int(floor(120 * mul)))
	BK.add_def(1000)
	_chk("加防衛唔可以超過陰兵總數", BK.def_n() == 400 and BK.standby() == 0)
	BK.add_def(-BK.STEP)
	_chk("減 10：防衛 390", BK.def_n() == 390 and BK.standby() == 10)
	BK.set_def(100)
	# 清剿：要有已打王嘅野外區
	var zs0 = BK.sweep_zones()
	ZD.mark_all_bosses(ZD.ci())
	var zs = BK.sweep_zones()
	_chk("打低王之前冇得清剿、之後有", zs0.is_empty() and zs.size() > 0, [zs0, zs])
	var z = str(zs[0]) if zs.size() else ""
	BK.test_now = 1.0e12
	_chk("清剿派 120：數量啱", BK.set_sweep(z, 120) == 120 and BK.sweep_n() == 120 and BK.standby() == 180)
	_chk("清剿唔可以超過每區上限 %d" % BK.sweep_cap(), BK.set_sweep(z, 9999) <= BK.sweep_cap() and BK.sweep_n(z) <= BK.standby() + BK.sweep_n(z))
	BK.set_sweep(z, 100)
	_chk("唔可以清剿未打王嘅區", BK.set_sweep("no_such", 50) == 0)
	_chk("攻佔：待命唔夠就唔得（總數夠都唔得）", true if ZD.of_type("res").is_empty() else _cap_weak(S))

	# ================= 4. 清剿收入＋折損＋離線上限 =================
	S.res["coins"] = 0.0; S.res["planks"] = 0.0
	var a = BK.st(); a["t"] = 1.0e12; a["lacc"] = 0.0
	var r1 = BK.sweep_rate(z)
	var exp_c = r1.coins * 60.0
	var o = BK.tick(1.0e12 + 60.0 * 60000.0)
	_chk("結算 60 分鐘", int(o.min) == 60, o)
	_chk("冥幣收入 = 每分鐘 × 60", absf(J.num(S.res.coins) - exp_c) < 0.5, [S.res.coins, exp_c])
	_chk("棺材板收入", J.num(S.res.planks) > 0.0 and absf(J.num(S.res.planks) - minf(J.num(J.mc(J.G.F, "cap", [])), r1.planks * 60.0)) < 0.5, S.res.planks)
	_chk("折損：6 次 × 1%（最少 1）＝ 6，陰兵同清剿一齊減", o.lost == 6 and BK.sweep_n(z) == 94 and int(J.num(S.res.troops)) == 394, [o.lost, BK.sweep_n(z), S.res.troops])
	o = BK.tick(1.0e12 + 60.0 * 60000.0 + 30000.0)
	_chk("唔夠 1 分鐘：唔結算", int(o.min) == 0)
	o = BK.tick(1.0e12 + 60.0 * 60000.0 + 10.0 * 3600000.0)
	_chk("離線 10 小時：最多計 240 分鐘", int(o.min) == 240, o)
	# 隊長：收入多、折損少
	var tro = int(J.num(S.res.troops))
	S.res["troops"] = 1000.0; BK.set_sweep(z, 200)
	var g_list = _named(S)
	if g_list.size() < 3:
		for k in ["eguiking", "toyol", "laojiang", "pontianak"]: J.cl(J.G.joinGhost, null, [k])
		g_list = _named(S)
	var g1 = g_list[0]; var g2 = g_list[1]; var g3 = g_list[2]
	var base = BK.sweep_rate(z)
	_chk("委任清剿隊長", BK.set_job(g1.id, "cap_sweep", z) == "ok" and J.str(BK.st().cap_sweep.get(z)) == J.str(g1.id))
	var cr = BK.sweep_rate(z)
	_chk("清剿隊長：收入上升、折損唔多過冇隊長", cr.coins > base.coins and cr.loss <= base.loss, [base, cr])
	# 正常化：陰兵死咗（例如打仗）→ 先減清剿
	S.res["troops"] = 150.0
	BK.normalize()
	_chk("陰兵唔夠：先減清剿、防衛保留", BK.reserved() <= 150 and BK.def_n() == 100 and BK.sweep_n() == 50, [BK.def_n(), BK.sweep_n()])
	S.res["troops"] = 1000.0

	# ================= 5. 名鬼一職 =================
	S.bld["wood"] = maxf(1.0, J.num(S.bld.get("wood", 1)))
	_chk("出陣", BK.set_job(g2.id, "team") == "ok" or S.team.has(g2.id), BK.job_label(g2))
	_chk("出陣 → 生產：自動離開出陣", BK.set_job(g2.id, "post", "wood") == "ok" and not S.team.has(g2.id) and J.str(g2.post) == "wood" and _roles(S, g2) == 1)
	_chk("生產 → 防衛隊長：自動離開工位", BK.set_job(g2.id, "cap_def") == "ok" and g2.get("post") == null and _roles(S, g2) == 1 and BK.job(g2) == "cap_def")
	BK.st().cap_def = [g2.id]
	var r_full = BK.set_job(g3.id, "cap_def")
	_chk("防衛隊長滿（Lv2 一位）：唔換人就唔得", r_full != "ok" and BK.max_def_caps() == 1, r_full)
	_chk("指明換走：g3 上、g2 變閒", BK.set_job(g3.id, "cap_def", g2.id) == "ok" and BK.job(g3) == "cap_def" and BK.job(g2) == "idle")
	_chk("防衛隊長 → 清剿隊長（換走原本嗰位）：只得一職", BK.set_job(g3.id, "cap_sweep", z) == "ok" and BK.job(g3) == "cap_sweep" and BK.st().cap_def.is_empty() and BK.job(g1) == "idle" and _roles(S, g3) == 1)
	_chk("防衛隊長加防衛戰力", true if BK.set_job(g2.id, "cap_def") != "ok" else BK.def_power() > int(floor(BK.def_n() * BK.troop_mul())), BK.def_power())
	# 舊介面掛鈎：派人去工位、佈陣
	J.mc(N, "pickDo", ["wood", g3.id])
	_chk("舊「派人」去工位：名鬼自動唔再做清剿隊長", J.str(g3.post) == "wood" and BK.job(g3) == "post" and _roles(S, g3) == 1)
	var free = S.team.find(null)
	if free < 0: S.team[2] = null; free = 2
	S.team[free] = g3.id; BK.after_team(g3.id)
	_chk("舊「佈陣」上陣：名鬼自動離開工位", BK.job(g3) == "team" and g3.get("post") == null and _roles(S, g3) == 1)
	_chk("休息：乜職務都冇", BK.set_job(g3.id, "idle") == "ok" and _roles(S, g3) == 0)
	var fod = null
	for g in S.ghosts: if J.str(g.q) == "藍" or J.str(g.q) == "紫": fod = g
	if fod != null: _chk("雜鬼唔可以做隊長", BK.set_job(fod.id, "cap_def") != "ok")
	var all1 = true
	for g in _named(S): if _roles(S, g) > 1 and not (S.team.has(g.id) and BK.village_post(g.get("post"))): all1 = false
	_chk("全部名鬼（新安排）最多一職", all1)
	var rl = J.mc(N, "roster", [])
	var has_job = false
	for e in rl.list: if J.t(e.get("job")): has_job = true
	_chk("名冊資料有「分配」", has_job)

	# ================= 6. 敬禮觸發 =================
	var P = BP.new(3)
	var org = Vector2(1000, 1000); var bp = org + BP.NODES.D + Vector2(28, -30)
	_chk("巡邏數量：每 25 隻 1 個、最多 8、冇兵營 0", BP.count_for(60, true) == 3 and BP.count_for(1000, true) == 8 and BP.count_for(500, false) == 0 and BP.count_for(0, true) == 0)
	var P8 = BP.new(5); P8.sync(8, org, bp)
	var close = {}
	for f in 200:
		P8.step(0.05, Vector2.INF)
		for i in range(2, 8):
			for j in range(i + 1, 8):
				if P8.sol[i].p.distance_to(P8.sol[j].p) < 8.0:
					var kk = "%d-%d" % [i, j]
					close[kk] = close.get(kk, 0) + 1
	var stuck = close.keys().filter(func(k): return close[k] > 100)
	_chk("8 隻巡邏：唔會兩隻疊埋一齊行", stuck.is_empty(), close)
	P.sync(4, org, bp)
	for i in 30: P.step(0.05, Vector2.INF)
	var s3 = P.sol[3]
	var far = s3.p + Vector2(300, 0)
	P.step(0.05, far)
	_chk("主角遠：冇敬禮", P.saluting() == 0)
	var hero = s3.p + Vector2(-30, 4)
	var p_before = s3.p
	P.step(0.05, hero)
	_chk("主角行近：停低敬禮、轉身向主角", s3.pose == "salute" and s3.dir < 0 and s3.p == p_before, [s3.pose, s3.dir])
	var tt = 0.0
	while tt < 0.9: P.step(0.05, hero); tt += 0.05
	_chk("敬禮約 1 秒：0.9 秒仲敬緊", s3.pose == "salute")
	P.step(0.2, hero); P.step(0.05, hero)
	_chk("1 秒後繼續（唔再敬禮）", s3.pose != "salute", s3.pose)
	for i in 20: P.step(0.05, hero)
	_chk("主角企喺度：唔會不停重複敬禮", s3.pose != "salute" or s3.sal > 0.5)
	P.step(0.05, s3.p + Vector2(400, 0)); P.step(0.05, s3.p + Vector2(20, 0))
	_chk("主角行開再返嚟：再敬禮（面向右）", s3.pose == "salute" and s3.dir > 0)
	var g0 = P.sol[0]
	P.step(0.05, g0.p + Vector2(0, -40))
	_chk("門口崗哨都會敬禮", g0.pose == "salute")
	# 陰兵圖（教官款）：四張齊、統一縮放、顯示高度同亡魂協調
	var BA = load("res://game/barracks/bk_art.gd")
	var all4 = true
	for ps in BA.POSES: if BA.pose_tex(ps) == null: all4 = false
	_chk("陰兵圖四張齊（企／行／敬禮／打）", all4)
	if all4:
		var hh = BA._sc * BA.pose_tex("stand").get_height()
		_chk("陰兵顯示高度 %.1f（亡魂約 41–47）" % hh, hh >= 41.0 and hh <= 50.0)
		var ax_ok = true
		for ps in BA.POSES: if float(BA._ax.get(ps, -1)) <= 0.0 or float(BA._ax.get(ps, -1)) >= BA.pose_tex(ps).get_width(): ax_ok = false
		_chk("落腳點自動計（喺圖入面）", ax_ok, BA._ax)
	var bkp = m.village.get_node_or_null("BkPatrol") if m.get("village") != null else null
	_chk("村裡巡邏節點掛咗", bkp != null)

	# ================= 7. 行動目標 =================
	var tg = []
	for f in AT.providers: tg.append_array(f.call(m))
	var bt = tg.filter(func(x): return x.kind == "barracks")
	_chk("act_targets 有兵營目標", bt.size() == 1 and bt[0].go is Callable and bt[0].pos is Vector2 and bt[0].foe_pow == 0, bt)
	if bt.size():
		bt[0].go.call(); await _w(t, 0.4)
		_chk("go：開兵營介面", Menus.cur == "bld:barracks", Menus.cur)
		Menus.close_hook()
	BK.test_now = -1.0
	ZD.unmark_bosses(ZD.ci())
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _cap_weak(S) -> bool:
	var rz = ""
	for zz in ZD.of_type("res"): if not ZD.owned(str(zz.id)): rz = str(zz.id); break
	if rz == "": return true
	var need = ZD.need(rz)
	var keep = J.num(S.res.troops); var d0 = BK.def_n(); var sw = BK.st().sweep.duplicate()
	S.res["troops"] = float(need + 50); BK.st()["sweep"] = {}; BK.set_def(100)
	var r = ZD.capture_auto(rz)
	var res = r == "weak" and not ZD.owned(rz)
	S.res["troops"] = keep; BK.st()["sweep"] = sw; BK.st()["def"] = float(d0)
	return res

# 六關：兵營腳底範圍喺村子區入面、唔撞其他建築／樹／稻田／擺設／公告板
func _layout() -> void:
	for ck in ZD.D().maps:
		var c = int(ck); var m = ZD.mdef(c); var v = m.village
		var vr = ZD.zrect("village", c)
		var bp = vr.position + BK.REL
		var me = Rect2(bp.x - 52, bp.y - 26, 104, 34)
		var hit = []
		for k in v.POS:
			var p = ZD.v2(v.POS[k]); var w = float(Art.BW.get(k, 100)) * 0.86
			if Rect2(p.x - w / 2, p.y - 26, w, 34).intersects(me): hit.append(k)
		for p in v.TREE_POS: if Rect2(float(p[0]) - 20, float(p[1]) - 14, 40, 20).intersects(me): hit.append("tree")
		for p in v.PADDY_POS: if Rect2(float(p[0]) - 36, float(p[1]) - 30, 72, 34).intersects(me): hit.append("paddy")
		for d in v.DECOR: if str(d[0]) != "willo" and Rect2(float(d[1]) - 12, float(d[2]) - 10, 24, 14).intersects(me): hit.append(str(d[0]))
		for e in v.get("EXTRA", []): if Rect2(float(e[1]) - float(e[3]) / 2, float(e[2]) - 20, float(e[3]), 24).intersects(me): hit.append(str(e[0]))
		# 巡邏路線：每段路唔穿過任何建築（連兵營）、樹、稻田、公告板
		var phit = []
		var allpos = v.POS.duplicate(); allpos["barracks"] = [bp.x, bp.y]
		for e in BP.EDGES:
			var a0 = vr.position + BP.NODES[e[0]]; var b0 = vr.position + BP.NODES[e[1]]
			for i in 81:
				var q = a0.lerp(b0, i / 80.0)
				for k in allpos:
					var pp = ZD.v2(allpos[k]); var hw = float(Art.BW.get(k, 100)) * 0.45
					if absf(q.x - pp.x) < hw and q.y > pp.y - 40 and q.y < pp.y + 10: phit.append("%s-%s:%s" % [e[0], e[1], k])
				for tp in v.TREE_POS: if absf(q.x - float(tp[0])) < 16 and q.y > float(tp[1]) - 12 and q.y < float(tp[1]) + 8: phit.append("tree")
				for tp in v.PADDY_POS: if absf(q.x - float(tp[0])) < 36 and q.y > float(tp[1]) - 30 and q.y < float(tp[1]) + 8: phit.append("paddy")
				for ex in v.get("EXTRA", []): if absf(q.x - float(ex[1])) < float(ex[3]) / 2 and q.y > float(ex[2]) - 24 and q.y < float(ex[2]) + 6: phit.append(str(ex[0]))
			if not vr.has_point(a0) or not vr.has_point(b0): phit.append("out")
		var uniq = []
		for h in phit: if not uniq.has(h): uniq.append(h)
		_chk("第 %d 關：巡邏路線唔穿過建築／樹／稻田" % (c + 1), uniq.is_empty(), uniq)
		_chk("第 %d 關：兵營喺村子入面、唔撞其他嘢" % (c + 1), vr.grow(-8).encloses(Rect2(bp.x - 58, bp.y - 100, 116, 110)) and hit.is_empty(), [bp, hit])
