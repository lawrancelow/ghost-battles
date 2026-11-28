# [tavern] 陰間酒館＋普通鬼生成器＋前期化寶爐 專項測試
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/tavern_test.gd","logic"],["quit"]]
extends RefCounted

const TV = preload("res://game/tavern/tavern.gd")
const GEN = preload("res://game/tavern/tv_gen.gd")
const JS = preload("res://game/joss/joss.gd")
const M = preload("res://game/outpost/mat.gd")
var bad := 0
var rows := 0
var _saved := {}
func _p(s) -> void: print("[tav] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[tav]   %-46s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _S(): return J.G.get("S")

func logic(_t) -> void:
	_saved = _S().duplicate(true)
	gen_unique()
	rarity()
	same_screen()
	refresh_pity()
	recruit()
	hunger()
	rates_hook()
	ui_panel()
	joss_switch()
	var S = _S()
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	TV.now_override = -1.0; JS.now_override = -1.0; J.G.erase("stall_open_fn")
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])

func gen_unique() -> void:
	_p("===== 1. 生成器：同種子同結果、唔同種子大量唔重複 =====")
	var a = GEN.gen(12345); var b = GEN.gen(12345)
	_chk("同種子＝同一隻（名、外觀、三圍）", a.name == b.name and a.look == b.look and a.st == b.st, a.name)
	var looks = {}; var names = {}
	for i in 2000:
		var g = GEN.gen(1000 + i * 7919)
		looks[str(g.look)] = 1; names[g.name] = 1
	_chk("2000 隻外觀組合唔同 ≥ 1990", looks.size() >= 1990, looks.size())
	_chk("2000 隻名字種類 ≥ 300", names.size() >= 300, names.size())
	var ok = true
	for i in 300:
		var g = GEN.gen(77 + i)
		if g.st.size() != 3 or GEN.cp_text(g) == "" or GEN.gag_text(g) == "" or str(g.k) == "": ok = false
		for x in GEN.D().NAMED: if str(x.name) == g.name: ok = false
		if g.name.find("李嘉") >= 0: ok = false
	_chk("每隻有三圍、口頭禪、死因梗、外觀鍵；唔撞 15 名鬼／黑名單", ok)
	var l = GEN.line(a, "sign")
	_chk("簽約台詞套入名字", l.find(a.name) >= 0, l)

func rarity() -> void:
	_p("===== 2. 稀有度機率（按 RAR.p 0.78/0.18/0.04）=====")
	var c = [0, 0, 0]; var N = 20000
	var sm = [0.0, 0.0, 0.0]
	for i in N:
		var g = GEN.gen(500000 + i * 31)
		c[g.rar] += 1; sm[g.rar] += g.st[0] + g.st[1] + g.st[2]
	var p = [float(c[0]) / N, float(c[1]) / N, float(c[2]) / N]
	_chk("普通 ≈78%", absf(p[0] - 0.78) < 0.02, p[0])
	_chk("好 ≈18%", absf(p[1] - 0.18) < 0.02, p[1])
	_chk("出眾 ≈4%", absf(p[2] - 0.04) < 0.01, p[2])
	_chk("平均三圍：出眾 > 好 > 普通", sm[2] / c[2] > sm[1] / c[1] and sm[1] / c[1] > sm[0] / c[0], [sm[0] / c[0], sm[1] / c[1], sm[2] / c[2]])
	var nm = GEN.named("wei", 3)
	_chk("名鬼（魏大狀，煞鬼）＝出眾、金光暈", nm.rar == 2 and nm.look.halo == "gold", nm.name)

func _fresh() -> void:
	var S = _S()
	S.erase("tav")
	S.res["coins"] = 5000.0
	if not (S.get("mat") is Dictionary): S["mat"] = {}
	TV.now_override = 2.0e12
	TV.st().seed = 4242

func same_screen() -> void:
	_p("===== 3. 同一畫面唔重名、唔重口頭禪（1000 輪名單）=====")
	_fresh()
	var dn = 0; var dc = 0
	for i in 1000:
		var list = TV.refresh(true)
		var ns = {}; var cs = {}
		for g in list:
			if ns.has(g.name): dn += 1
			if cs.has(int(g.cp)): dc += 1
			ns[g.name] = 1; cs[int(g.cp)] = 1
	_chk("同名單撞名 0 次", dn == 0, dn)
	_chk("同名單撞口頭禪 0 次", dc == 0, dc)

func refresh_pity() -> void:
	_p("===== 4. 刷新：定時、手動收錢遞增、保底 =====")
	_fresh()
	TV.tick_list()
	var t = TV.st()
	var best = 0
	for g in t.list: best = maxi(best, int(g.rar))
	_chk("第一次名單必有「好」以上", best >= 1, best)
	_chk("名單 %d 格" % int(GEN.D().SLOTS), t.list.size() == int(GEN.D().SLOTS))
	var first = str(t.list[0].name) + str(t.list[1].name)
	TV.now_override += 599.0 * 1000.0 / TV.tscale(); TV.tick_list()
	_chk("未夠 10 分鐘唔換", str(t.list[0].name) + str(t.list[1].name) == first)
	TV.now_override += 2.0 * 1000.0 / TV.tscale(); TV.tick_list()
	_chk("夠鐘自動換一批", str(TV.st().list[0].name) + str(TV.st().list[1].name) != first)
	var c0 = _S().res.coins; var mc1 = TV.manual_cost()
	TV.manual_refresh(); var mc2 = TV.manual_cost(); TV.manual_refresh()
	_chk("手動刷新收冥幣，第二次貴啲", _S().res.coins == c0 - mc1 - mc2 and mc2 > mc1, [mc1, mc2])
	TV.now_override += 700.0 * 1000.0 / TV.tscale(); TV.tick_list()
	_chk("自動刷新後手動價重計", TV.manual_cost() == float(GEN.D().MANUAL.base), TV.manual_cost())
	_S().res["coins"] = 0.0
	_chk("冇錢唔刷", not TV.manual_refresh().ok)
	_S().res["coins"] = 5000.0
	# 保底：連續 pity 次冇出眾 → 必出
	var maxdry = 0; var dry = 0
	for i in 3000:
		var l = TV.refresh(true)
		var top = false
		for g in l: if int(g.rar) >= 2: top = true
		dry = 0 if top else dry + 1
		maxdry = maxi(maxdry, dry)
	_chk("連續冇「出眾」最多 %d 次" % (int(GEN.D().RAR.pity) - 1), maxdry <= int(GEN.D().RAR.pity) - 1, maxdry)
	var nseen = {}
	for i in 600:
		for g in TV.refresh(true): if g.get("named") != null: nseen[g.named] = 1
	_chk("600 輪見到 15 名鬼中 ≥ 12 隻", nseen.size() >= 12, nseen.size())

func recruit() -> void:
	_p("===== 5. 招募 =====")
	_fresh()
	var S = _S()
	S.bld["home"] = 10.0
	TV.tick_list()
	var g0 = TV.st().list[0]
	var c0 = S.res.coins; var n0 = S.ghosts.size()
	var r = TV.recruit(0)
	_chk("招到：入名冊、扣冥幣", r.ok and S.ghosts.size() == n0 + 1 and S.res.coins == c0 - TV.cost_of(g0), r.get("cost"))
	var rec = S.ghosts[S.ghosts.size() - 1]
	_chk("記錄 gen（外觀、名固定）", rec.get("gen") is Dictionary and rec.name == g0.name and rec.gen.look == g0.look, rec.name)
	_chk("已簽約嗰格唔可以再招", not TV.recruit(0).ok)
	S.res["coins"] = 0.0
	var ck = TV.can_recruit(1)
	_chk("冇錢：講差幾多", not ck.ok and ck.why == "coins" and J.num(ck.need) > 0, ck)
	S.res["coins"] = 5000.0
	S.bld["home"] = 0.0
	var full = true
	for i in 30:
		TV.refresh(true)
		var rr = TV.recruit(0)
		if not rr.ok: full = rr.why == "cap"; break
	_chk("名額滿就唔可以招（why=cap）", full)
	S.bld["home"] = 10.0

func _worker(id: String, post: String) -> Dictionary:
	var g = GEN.gen(id.hash())
	var rec = {"id": id, "k": g.k, "name": g.name, "q": "藍", "lv": 3.0, "st": g.st, "post": post, "spent": 0.0, "gen": g}
	_S().ghosts.append(rec)
	return rec

func hunger() -> void:
	_p("===== 6. 夜宵：食包、肚餓、罷工、復工 =====")
	_fresh()
	var S = _S()
	var a = _worker("t_tv_a", "wood"); var b = _worker("t_tv_b", "rice")
	var old = {"id": "t_tv_old", "k": "youhun", "name": "舊鬼", "q": "藍", "lv": 3.0, "st": [20.0, 20.0, 20.0], "post": "wood", "spent": 0.0}
	S.ghosts.append(old)
	S.mat["m_bao"] = 10.0
	var fs = float(GEN.D().FEED_S)
	TV._acc = 0.0
	TV.tick(fs + 1)
	_chk("一更：兩隻酒館鬼各食 1 個（舊鬼唔食）", absf(M.amt("m_bao") - 8.0) < 0.01, M.amt("m_bao"))
	_chk("食飽：產量 ×1", TV.work_mul(a) == 1.0 and TV.work_mul(old) == 1.0)
	S.mat["m_bao"] = 0.0
	TV.tick(fs)
	_chk("冇包：肚餓（×0.5）", TV.hunger_of(a) == 1 and TV.work_mul(a) == 0.5, TV.hunger_of(a))
	_chk("有氣泡台詞", TV.bubble(a) != "", TV.bubble(a))
	TV.tick(fs)
	_chk("再冇包：罷工（×0）", TV.hunger_of(a) == 2 and TV.work_mul(b) == 0.0)
	S.mat["m_bao"] = 1.0
	var r = TV.feed_now()
	_chk("派夜宵：包唔夠只餵到一隻", r.fed == 1 and r.left == 1, r)
	S.mat["m_bao"] = 5.0
	TV.tick(1.0)
	_chk("有包即刻自動復工", TV.hunger_of(a) == 0 and TV.hunger_of(b) == 0)
	a.post = null
	_chk("冇崗位嘅鬼唔食", not TV.eaters().has(a))
	for g in [a, b, old]: S.ghosts.erase(g)

func rates_hook() -> void:
	_p("===== 7. 產量掛鈎（rates_per_min）=====")
	_fresh()
	var S = _S()
	var keep = []
	for g in S.ghosts: keep.append(g.get("post")); g["post"] = null
	var a = _worker("t_tv_r", "wood")
	var NG = load("res://native/game.gd")
	var r1 = J.num(NG.rates_per_min().wood)
	TV.st().hunger[a.id] = 1
	var r2 = J.num(NG.rates_per_min().wood)
	TV.st().hunger[a.id] = 2
	var r3 = J.num(NG.rates_per_min().wood)
	_chk("肚餓伐木產量減半", r1 > 0 and absf(r2 - r1 * 0.5) < 0.01, [r1, r2])
	_chk("罷工伐木產量 0", r3 == 0.0, r3)
	S.ghosts.erase(a)
	var i = 0
	for g in S.ghosts: g["post"] = keep[i]; i += 1

func ui_panel() -> void:
	_p("===== 8. 酒館面板畫得出 =====")
	_fresh()
	var body = VBoxContainer.new()
	var ok = true
	load("res://game/tavern/tavern_ui.gd").panel(body, func(): pass)
	_chk("面板有名單卡（≥ %d）" % int(GEN.D().SLOTS), body.get_child_count() >= int(GEN.D().SLOTS) + 2, body.get_child_count())
	body.free()

func joss_switch() -> void:
	_p("===== 9. 化寶爐：前期冥幣 → 大排檔後祭品模式 =====")
	var S = _S()
	S.erase("joss"); S.bld["furnace"] = 1.0
	J.G["stall_open_fn"] = func(): return false
	JS.now_override = 2.0e12
	var j = JS.st(); j.q.append({"k": "n", "t": JS.now()}); j.q.append({"k": "n", "t": JS.now()})
	_chk("大排檔未開＝前期模式，5 分鐘一件", JS.early() and absf(JS.interval_ms(1) - 300000.0 / JS.tscale()) < 1.0, JS.interval_ms(1))
	var c0 = J.num(S.res.coins)
	var r = JS.collect()
	_chk("第一件：積壓包裹＋冥幣", r.ok and r.early and r.backlog and J.num(S.res.coins) - c0 == J.num(r.coins) and J.num(r.coins) >= float(GEN.D().JOSS_EARLY.backlog), r.get("coins"))
	var c1 = J.num(S.res.coins)
	var r2 = JS.collect()
	_chk("第二件：冥幣（無積壓）", r2.ok and r2.early and not r2.backlog and J.num(S.res.coins) > c1, r2.get("coins"))
	_chk("寄件人／信有內容", str(r2.sender) != "" and str(r2.text) != "", r2.sender)
	J.G["stall_open_fn"] = func(): return true
	_chk("大排檔開咗：唔再係前期模式", not JS.early())
	j.q.append({"k": "n", "t": JS.now()})
	var c2 = J.num(S.res.coins)
	var r3 = JS.collect()
	_chk("轉祭品模式：shift=true、唔係冥幣包", r3.ok and r3.get("shift") == true and not r3.get("early", false), r3.get("id"))
	j.q.append({"k": "n", "t": JS.now()})
	var r4 = JS.collect()
	_chk("之後唔再 shift", r4.ok and r4.get("shift") == false)
	J.G["stall_open_fn"] = func(): return false
	_chk("轉咗之後就算條件變返都唔再退回前期", not JS.early())
	_chk("間隔返回正常（40 分鐘）", absf(JS.interval_ms(1) - 40.0 * 60000.0 / JS.tscale()) < 1.0)
