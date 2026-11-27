# [equip] 武器裝備系統測試
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> equip res://tools/tests/equip_test.gd all <秒>
#   logic：數據（40 件、紅線、用料存在）、民用 A/B 款（今期款、用料、賣出變遊魂兵＋外觀）、訂製（解鎖、扣料扣錢、回收）、
#          名鬼穿脫（槽位、名品限 1 件、倉庫數）、數值封頂、標籤（補 1 個、本身已有、已滿）、同聲同氣、戰鬥單位接入、abil buff／tags、舊存檔
#   shots：/home/claude/docs/shots/equip/（兵器檔資料卡、訂製面板、名冊三格、換裝面板、地圖戰鬥名鬼＋遊魂兵、顯示格網唔出界）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/shots/equip/"
const EQ = preload("res://game/equip/eq_data.gd")
const EV = preload("res://game/equip/eq_view.gd")
const EUI = preload("res://game/equip/eq_ui.gd")
const ML = preload("res://game/militia/ml_data.gd")
const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const AB = preload("res://game/rts/abil.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")

func _p(m): print("[equip] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
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

func all(t) -> void:
	var m = await _boot(t)
	await _logic(t, m)
	await _shots(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func logic(t) -> void:
	var m = await _boot(t)
	await _logic(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func shots(t) -> void:
	var m = await _boot(t)
	_setup_rich(m)
	await _shots(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------------- 準備：兵器檔開到 ★5、材料冥幣夠、多幾隻名鬼 ----------------
func _stall(lv: float) -> void:
	var S = J.G.S
	var mv = S.mv
	if not (mv.st.get(ML.SID) is Dictionary): mv.st[ML.SID] = {"unlocked": true, "lv": lv}
	mv.st[ML.SID].unlocked = true; mv.st[ML.SID].lv = lv
func _rich_mats() -> void:
	var S = J.G.S
	for mid in ["m_bamboo", "m_wood", "m_strip", "m_rope", "m_paper", "m_plank"]:
		var rk = M.res_key(mid)
		if rk != "": S.res[rk] = 99999.0
		else:
			if not (S.get("mat") is Dictionary): S["mat"] = {}
			S.mat[mid] = 99999.0
	S.res["coins"] = 9.0e7
func _setup_rich(m) -> void:
	var S = J.G.S
	_stall(150.0); _rich_mats()
	var have = []
	for g in S.ghosts: have.append(str(g.k))
	for k in ["xiaozhi", "toyol", "laojiang"]:
		if not k in have: J.cl(J.G.get("joinGhost"), null, [k])
func _gid(k: String) -> String:
	for g in J.G.S.ghosts: if str(g.k) == k: return str(g.id)
	return ""

func _logic(t, m) -> void:
	var S = J.G.S
	# ---------- 數據 ----------
	EQ.reload()
	var all_ids = EQ.D().ITEMS.keys()
	# [equip-list] 件數跟返現況：民 14＋名鬼 51（補丁43 31 件＋真兵器 18＋武館 2）＋專屬物 27（主角兵器 hero 唔計）
	var nh = 0
	for id in all_ids: if J.t(EQ.item(id).get("hero")): nh += 1
	_chk("數據：equip.json 有 92 件（民 14＋名鬼 51＋專屬物 27）", all_ids.size() - nh == 92 and EQ.items("ml").size() == 14 and EQ.items("eq").size() == 51 and EQ.items("ex").size() == 27, [all_ids.size(), EQ.items("ml").size(), EQ.items("eq").size(), EQ.items("ex").size()])
	_chk("名鬼三格：兵器 29、護身 11、隨身物 11", EQ.items("eq", "wea").size() == 29 and EQ.items("eq", "arm").size() == 11 and EQ.items("eq", "acc").size() == 11, [EQ.items("eq", "wea").size(), EQ.items("eq", "arm").size(), EQ.items("eq", "acc").size()])
	var grades = [0, 0, 0, 0, 0]
	for id in EQ.items("eq"): grades[EQ.grade_of(id)] += 1
	_chk("五個等級都有（凡良精名絕）", grades.min() >= 2, grades)
	var badw = []
	var RED = ["桃木", "符", "八卦", "念珠", "佛珠", "道士", "道袍", "神像", "經文", "佛經", "銅錢劍", "十字架", "法器", "Keris", "判官筆", "法劍", "Nike", "Adidas", "Lui Char", "LV"]
	for id in all_ids:
		var tx = str(EQ.item(id).n) + str(EQ.item(id).d)
		for w in RED: if tx.contains(w): badw.append([id, w])
	_chk("紅線：冇宗教法器、冇品牌字眼", badw.is_empty(), badw)
	var miss = []
	for id in all_ids:
		for mid in EQ.item(id).get("rec", {}): if not M.has_def(str(mid)): miss.append([id, mid])
	_chk("全部用料都係村子現有材料（chain.json MATS）", miss.is_empty(), miss)
	var nshape = []
	for id in all_ids: if str(EQ.item(id).get("shape", "")) == "": nshape.append(id)
	_chk("每件都有外觀形狀（暫代圖）", nshape.is_empty(), nshape)
	# ---------- 民用：A/B 款 ----------
	S.erase("equip")
	_stall(1.0)
	var per = true
	for tt in 7: if EQ.ml_items(tt).size() != 2 or str(EQ.item(EQ.ml_items(tt)[0]).var) != "A": per = false
	_chk("民用：每級 2 款，A 款排第一", per)
	_chk("今期款預設 A＝原本嗰件（晾衫竹），名同 militia 一樣", EQ.ml_now() == "ml_zhugan" and ML.tier_name(0) == EQ.name_of("ml_zhugan"), [EQ.ml_now(), ML.tier_name(0)])
	_chk("A 款用料＝militia 原用料（唔影響舊平衡）", JSON.stringify(M.recipe(ML.SID).get("in")) == JSON.stringify(ML.TIERS[0].rec), M.recipe(ML.SID))
	var abk = true
	for tt in 7:
		var b = EQ.item(EQ.ml_items(tt)[1])
		if absf(J.num(b.atk_k) * J.num(b.hp_k) - 1.0) > 0.02: abk = false
	_chk("B 款倍率乘積 ≈1（只改分配，唔改總強度）", abk)
	_stall(10.0)   # ★1
	_chk("兵器檔 ★1：今期級 1", EQ.stall_star() == 1, EQ.stall_star())
	EQ.set_ml_pick(1, "ml_wokchan")
	_chk("揀 B 款（鐵鑊鏟）：用料換成 B 款", JSON.stringify(M.recipe(ML.SID).get("in")) == JSON.stringify(EQ.item("ml_wokchan").rec) and ML.tier_name(1) == EQ.name_of("ml_wokchan"), M.recipe(ML.SID))
	# 賣出 → 遊魂兵（經 militia on_paid → join → EQ.ml_join）
	var sim = m.mv_view.sim if m.get("mv_view") != null else null
	if sim != null:
		var tot0 = ML.total(); var n1 = ML.n_of(1)
		ML.on_paid(sim, {"got": {"m_bingqi": 3}, "pos": Vector2(200, 400)})
		_chk("賣出 3 件鐵鑊鏟：遊魂兵 +3（級 1）", ML.total() == tot0 + 3 and ML.n_of(1) == n1 + 3, [ML.total(), ML.st().n])
		_chk("佢哋揸嘅款記低（外觀＝鐵鑊鏟）", EQ.ml_look(1) == "ml_wokchan" and J.num(EQ.st().ml_look["1"]["ml_wokchan"]) == 3.0, EQ.st().ml_look)
	else: _chk("搵到大排檔 sim", false)
	# 遊魂兵戰鬥單位：B 款倍率＋外觀
	var mu = {"side": 0.0, "minion": true, "ml": 1.0, "hp": 100.0, "maxhp": 100.0, "atk": 10.0, "k": "youhun"}
	EQ.battle_units({"units": [mu]})
	_chk("遊魂兵小隊：攻×1.12、血×0.9、外觀 eq_ml", is_equal_approx(J.num(mu.atk), 11.2) and is_equal_approx(J.num(mu.maxhp), 90.0) and str(mu.get("eq_ml")) == "ml_wokchan", mu)
	# ---------- 名鬼：訂製 ----------
	_stall(1.0)
	_chk("★0：凡品解鎖、良品未解鎖", EQ.unlocked("eq_tuoxie") and not EQ.unlocked("eq_suanpan"))
	var S_mat_bak = (S.get("mat", {}) as Dictionary).duplicate(true); var res_bak = (S.res as Dictionary).duplicate(true)
	_rich_mats()
	var c0 = EQ.coins(); var pl0 = M.amt("m_plank")
	_chk("訂製膠拖鞋：成功、入倉 1、扣冥幣 200、扣棺材板 2", EQ.make("eq_tuoxie") and EQ.n_inv("eq_tuoxie") == 1 and is_equal_approx(c0 - EQ.coins(), 200.0) and is_equal_approx(pl0 - M.amt("m_plank"), 2.0), [EQ.coins(), M.amt("m_plank")])
	_chk("未解鎖嘅良品訂唔到", not EQ.make("eq_suanpan"))
	S.res["coins"] = 10.0
	_chk("冥幣唔夠訂唔到（missing 寫明差幾多）", not EQ.can_make("eq_wokchan") and EQ.missing("eq_wokchan").has("coins"))
	_rich_mats()
	_stall(150.0)   # ★5：名品
	# [p45] 補丁43 起：凡良精喺兵器檔造；名品只靠回陽間燒落嚟；絕品＝打魔王掉（equip_build.py SRC）
	_chk("★5：凡良精全部造得（兵器檔 ★%d）" % EQ.stall_star(), EQ.unlocked("eq_huanshou") and EQ.unlocked("eq_tiewok") and EQ.unlocked("eq_dianzhan"))
	var bad_src = []
	for id in EQ.items("eq"):
		var g5 = EQ.grade_of(id); var sr5 = EQ.item(id).get("src", [])
		var want = ["make"] if g5 <= 1 else (["make", "offer"] if g5 == 2 else (["offer"] if g5 == 3 else ["boss"]))
		if JSON.stringify(sr5) != JSON.stringify(want) or EQ.unlocked(id) != (g5 <= 2): bad_src.append([id, g5, sr5])
	_chk("來源：凡良＝造、精＝造或燒、名＝只燒、絕＝只魔王；★5 名／絕都唔喺兵器檔造", bad_src.is_empty(), bad_src)
	_chk("★5：名品唔造得、寫明「回陽間…燒下來」", not EQ.unlocked("eq_huoqi") and not EQ.make("eq_laogong") and EQ.lock_txt("eq_laogong").contains("陽間"), EQ.lock_txt("eq_laogong"))
	_chk("絕品唔造得、寫明「打魔王」", not EQ.unlocked("eq_jue_caidao") and not EQ.make("eq_jue_caidao") and EQ.lock_txt("eq_jue_caidao").contains("魔王"), EQ.lock_txt("eq_jue_caidao"))
	# 回陽間燒貨：三星先有名品；掉落池只有 src 有 offer 嘅精／名
	seed(4545)
	var got_o = {}; var bad_o = []
	for i in 400:
		var id_o = EQ.drop_offer(3)
		if id_o == "": continue
		got_o[EQ.grade_of(id_o)] = int(got_o.get(EQ.grade_of(id_o), 0)) + 1
		if not (EQ.item(id_o).get("src", []) as Array).has("offer"): bad_o.append(id_o)
	var g1_name = 0
	for i in 400:
		var id1 = EQ.drop_offer(1)
		if id1 != "" and EQ.grade_of(id1) >= 3: g1_name += 1
	_chk("回陽間燒落嚟：三星有名品（%s）、一星冇名品、池冇絕品" % str(got_o), int(got_o.get(3, 0)) > 0 and not got_o.has(4) and bad_o.is_empty() and g1_name == 0, [got_o, bad_o, g1_name])
	var got_b = {}
	for i in 300:
		for id_b in EQ.drop_boss(false): got_b[str(EQ.item(id_b).get("kind")) + str(EQ.grade_of(id_b))] = 1
	_chk("打魔王掉：只會係絕品（或專屬物）", got_b.has("eq4") and not got_b.has("eq3") and not got_b.has("eq2"), got_b)
	EQ.st().inv.clear(); EQ.st().worn.clear()   # 清走上面掉落測試入倉嘅嘢，下面數倉準確
	for id in ["eq_huanshou", "eq_baoan", "eq_dianzhan", "eq_liangcha", "eq_jimao", "eq_suanpan", "eq_weiqun", "eq_tiewok", "eq_yinji", "eq_guanban", "eq_xizhuang", "eq_staffcard"]:
		EQ.make(id)
	for id in ["eq_huoqi", "eq_laogong", "eq_jinzheng"]: EQ.give(id)   # 名品：當回陽間燒落嚟
	EQ.make("eq_huanshou")
	_chk("訂咗 2 把環首刀", EQ.n_inv("eq_huanshou") == 2)
	var c1 = EQ.coins()
	_chk("回收 1 把：退 3600 冥幣", EQ.recycle("eq_huanshou") and is_equal_approx(EQ.coins() - c1, 3600.0) and EQ.n_inv("eq_huanshou") == 1, EQ.coins() - c1)
	# ---------- 名鬼：穿脫 ----------
	_setup_rich(m); await _skip(t, 8)
	var gx = _gid("xiaozhi"); var gl = _gid("laojiang")
	_chk("有小紙、老殭兩隻名鬼", gx != "" and gl != "", [gx, gl])
	_chk("小紙穿生鏽環首刀（兵器格）", EQ.wear(gx, "eq_huanshou") and str(EQ.worn(gx).get("wea")) == "eq_huanshou")
	_chk("同一把唔可以兩隻鬼一齊穿（倉庫冇剩）", not EQ.wear(gl, "eq_huanshou") and EQ.why_not(gl, "eq_huanshou") != "")
	_chk("護身格穿名品（老員工制服）", EQ.wear(gx, "eq_laogong"))
	_chk("名品每隻鬼最多 1 件（隨身物名品穿唔到）", not EQ.wear(gx, "eq_jinzheng") and EQ.why_not(gx, "eq_jinzheng").contains("名品"))
	EQ.wear(gx, "eq_dianzhan")
	_chk("三格齊：兵器／護身／隨身物", EQ.worn(gx).size() == 3, EQ.worn(gx))
	var b = EQ.bonus(gx)
	# [p45] 補丁43 起有職業類別 +20%：期望值按小紙職業逐件計（基礎值：刀攻 13%、制服血 18%／受傷 −6%／儲能 5%、電筒儲能 5%）
	var clsx = load("res://game/rts/roles.gd").cls_of("xiaozhi")
	var ex_b = {"atk": 0.0, "hp": 0.0, "taken": 0.0, "energy": 0.0}
	for id in ["eq_huanshou", "eq_laogong", "eq_dianzhan"]:
		var kx = 1.2 if EQ.cat_match(id, clsx) else 1.0
		for s0 in EQ.item(id).st: if ex_b.has(s0): ex_b[s0] += J.num(EQ.item(id).st[s0]) * kx
	if AB.scares_of("xiaozhi").has("light"): ex_b.atk += 0.08
	var base_ok = is_equal_approx(J.num(EQ.item("eq_huanshou").st.atk), 0.13) and is_equal_approx(J.num(EQ.item("eq_laogong").st.hp), 0.18) and is_equal_approx(J.num(EQ.item("eq_laogong").st.taken), -0.06) and is_equal_approx(J.num(EQ.item("eq_laogong").st.energy) + J.num(EQ.item("eq_dianzhan").st.energy), 0.10)
	_chk("加成：攻 +13%%、血 +18%%、受傷 −6%%、儲能 +10%%（×職業類別；小紙 %s）" % clsx, base_ok and is_equal_approx(b.atk, ex_b.atk) and is_equal_approx(b.hp, ex_b.hp) and is_equal_approx(b.taken, ex_b.taken) and is_equal_approx(b.energy, ex_b.energy), [b, ex_b])
	# 標籤：小紙本身標籤
	var own = AB.tags_of("xiaozhi")
	var ti = EQ.tag_info(gx)
	_chk("標籤：三件之中等級最高帶標籤嗰件（環首刀「刺」）生效", str(ti.id) == "eq_huanshou" and str(ti.tag) == "刺", [ti, own])
	var exp_why = "own" if own.has("刺") else ("full" if own.size() >= 3 else "")
	_chk("標籤規則：本身已有／已滿 3 個＝冇效（小紙：%s）" % str(own), str(ti.why) == exp_why, ti)
	# 老殭（本身標籤少）：補「照」
	EQ.make("eq_dianzhan"); EQ.wear(gl, "eq_dianzhan")
	var ownl = AB.tags_of("laojiang")
	var til = EQ.tag_info(gl)
	_chk("老殭揸保安電筒：補「照」（本身 %s）" % str(ownl), str(til.tag) == "照" and (str(til.why) == "" if not ownl.has("照") and ownl.size() < 3 else true), til)
	# 同聲同氣：搵一隻嚇法係燈嘅鬼
	var sc_l = AB.scares_of("laojiang")
	var bl = EQ.bonus(gl)
	_chk("同聲同氣：電筒（燈）只有用燈嘅鬼先加攻 8%%（老殭嚇法 %s）" % str(sc_l), (is_equal_approx(bl.atk, 0.08) if sc_l.has("light") else is_equal_approx(bl.atk, 0.0)), bl)
	# 封頂
	var fake = {"wea": "eq_huoqi", "arm": "eq_tiewok", "acc": "eq_jinzheng"}
	EQ.st().worn["capx"] = fake
	var bc = EQ.bonus("capx", "afu")
	_chk("封頂：攻 ≤25%、血 ≤25%", bc.atk <= 0.25 + 1e-6 and bc.hp <= 0.25 + 1e-6, bc)
	EQ.st().worn.erase("capx")
	# 卸下
	_chk("卸下隨身物", EQ.unwear(gx, "acc") and not EQ.worn(gx).has("acc") and EQ.n_free("eq_dianzhan") >= 0)
	if EQ.n_free("eq_dianzhan") > 0: EQ.wear(gx, "eq_dianzhan")
	# ---------- 戰鬥單位 ----------
	var Bt = J.G.get("Battle")
	var g = EQ.ghost(gx)
	var u0 = J.mc(Bt, "mkGhostUnit", [g, 0.0])
	var hp0 = J.num(u0.maxhp); var atk0 = J.num(u0.atk)
	var bb = EQ.bonus(gx, "xiaozhi")
	EQ.battle_units({"units": [u0]})
	_chk("戰鬥單位：血、攻按裝備乘（血×%.2f 攻×%.2f）" % [1 + bb.hp, 1 + bb.atk], is_equal_approx(J.num(u0.maxhp), hp0 * (1 + bb.hp)) and is_equal_approx(J.num(u0.atk), atk0 * (1 + bb.atk)) and u0.get("eq") is Dictionary, [hp0, u0.maxhp, atk0, u0.atk])
	var sim2 = load("res://game/rts/rts_sim.gd").new()
	AB.compile(sim2, u0)
	var tk = AB.stat(sim2, u0, "taken")
	_chk("abil：受傷 buff 經 stat() 生效（×%.2f）" % tk, is_equal_approx(tk, 1.0 + bb.taken), tk)
	_chk("abil：儲能 buff 經 stat() 生效", is_equal_approx(AB.stat(sim2, u0, "energy"), 1.0 + bb.energy))
	var tg = EQ.tag_of(gx, "xiaozhi")
	_chk("abil：生效嘅裝備標籤入咗 u.ab.tags（%s）" % tg, tg == "" or (u0.ab.tags as Array).has(tg), u0.ab.tags)
	var ul = J.mc(Bt, "mkGhostUnit", [EQ.ghost(gl), 1.0])
	EQ.battle_units({"units": [ul]}); AB.compile(sim2, ul)
	_chk("老殭戰鬥中有「照」標籤（裝備補位）", AB.has_tag(ul, "照"), ul.ab.tags)
	# ---------- 舊存檔 ----------
	var bak = S.get("equip")
	S.erase("equip")
	var u1 = J.mc(Bt, "mkGhostUnit", [g, 0.0]); var h1 = J.num(u1.maxhp)
	EQ.battle_units({"units": [u1]})
	_chk("舊存檔（冇 S.equip）：自動建立空表、戰鬥數值同舊一樣", S.get("equip") is Dictionary and is_equal_approx(J.num(u1.maxhp), h1) and not u1.has("eq"))
	S["equip"] = bak
	EQ.off = true
	var u2 = J.mc(Bt, "mkGhostUnit", [g, 0.0]); var h2 = J.num(u2.maxhp)
	EQ.battle_units({"units": [u2]})
	_chk("一鍵關（EQ.off）：唔改數值", is_equal_approx(J.num(u2.maxhp), h2))
	EQ.off = false
	# 村子廣場
	var ops = []
	EV.village(ops, "xiaozhi", 100, 200, 60, 1.0)
	var bops = []
	EV.village(ops, "xiaozhi", 100, 200, 60, 1.0, bops)
	_chk("村子廣場：小紙有裝兵器有畫出（pin：手持身後一層／float：飄浮）", (bops.size() == 1 and ops.size() >= 1) if EV.scheme() == "pin" else (ops.size() + bops.size() >= 1), [EV.scheme(), ops.size(), bops.size()])   # [補丁29] 預設改 float
	var ops2 = []
	EV.village(ops2, "zzz_none", 100, 200, 60, 1.0)
	_chk("冇裝備嘅鬼：乜都唔加", ops2.is_empty())
	# 錨點
	var a1 = EV.anchor("xiaozhi"); var a2 = EV.anchor("n30_jiugui"); var a3 = EV.auto_anchor("n30_jiugui")
	_chk("錨點：名鬼錨點表 ≥100 隻（人工＋輪廓生成）、表外仍可即時自動估", EQ.D().ANCHOR.size() >= 100 and str(a1.src) in ["data", "manual"] and str(a2.src) in ["data", "manual"] and str(a3.src) == "auto", [EQ.D().ANCHOR.size(), a1, a3])

# ---------------- 截圖 ----------------
class Grid extends Control:
	var ks: Array = []
	var sets: Array = []
	var bounds := {}
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.13, 0.11, 0.1))
		var EVv = load("res://game/equip/eq_view.gd")
		var cw = size.x / 4.0; var ch = 150.0
		for i in ks.size():
			var r = Rect2(Vector2((i % 4) * cw, floor(i / 4.0) * ch + 10), Vector2(cw - 6, ch - 8))
			draw_rect(r, Color("#6a5040"), false, 1.0)
			var ctx = Ctx.new(self)
			EVv.preview(ctx, ks[i], sets[i % sets.size()], r)
			bounds[ks[i]] = EVv.LAST.get(ks[i])

func _shots(t, m) -> void:
	var S = J.G.S
	_setup_rich(m); await _skip(t, 8)
	var gx = _gid("xiaozhi")
	# 1. 兵器檔資料卡
	var sc = m.mv_view
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.5)
	if sc != null and sc.has_method("open_sheet"):
		_stall(150.0); sc.open_sheet(ML.SID); await _w(t, 0.6)
		var pick = sc.sheet_box.find_child("MlPick_ml_huanshou", true, false)
		_chk("兵器檔資料卡：有 A/B 今期款掣＋訂製入口", pick != null and sc.sheet_box.find_child("EqCraftBtn", true, false) != null)
		await _shot(t, "01_stall_sheet")
		if pick: pick.emit_signal("pressed"); await _w(t, 0.4)
		_chk("撳 B 款：今期改做環首刀", EQ.ml_now() == "ml_huanshou")
		await _shot(t, "02_stall_pick_b")
		sc.close_sheet()
	EUI.open_craft(); await _w(t, 0.5)
	_chk("訂製面板開到", EUI.popup_root != null and is_instance_valid(EUI.popup_root))
	await _shot(t, "03_craft_panel")
	EUI.close_popup(); await _w(t, 0.2)
	# 2. 名冊
	Menus.open_roster(); await _w(t, 0.8)
	var root = t.get_tree().root
	var strip = root.find_child("EqStrip", true, false)
	_chk("名冊：卡上有裝備三格", strip != null and strip.get_child_count() >= 3)
	await _shot(t, "04_roster_strip")
	EUI.open_slot(gx, "wea"); await _w(t, 0.6)
	var pv = EUI.popup_root.find_child("EqPreview", true, false) if EUI.popup_root else null
	_chk("換裝面板：有預覽", pv != null)
	await _shot(t, "05_slot_panel")
	var wb = EUI.popup_root.find_child("Wear_eq_liangcha", true, false) if EUI.popup_root else null
	if wb: wb.emit_signal("pressed"); await _w(t, 0.5)
	_chk("換裝面板撳「穿上」晾衫叉：兵器格換咗", str(EQ.worn(gx).get("wea")) == "eq_liangcha", EQ.worn(gx))
	pv = EUI.popup_root.find_child("EqPreview", true, false) if EUI.popup_root else null
	await _w(t, 0.3); await _shot(t, "06_slot_after_wear")
	if pv: _chk("預覽：裝備唔出框", Rect2(Vector2.ZERO, pv.size).grow(1).encloses(pv.last), [pv.last, pv.size])
	EUI.close_popup()
	Menus.close_hook()
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.5)
	# 3. 顯示格網：多隻鬼 × 三種配搭，檢查唔出界
	var ks = ["afu", "xiaozhi", "laojiang", "eguiking", "pontianak", "tianhua", "n30_jiugui", "n30_kappa", "n30_hanba", "nw_ganshi", "n30_qionggui", "youhun"]
	var sets = [{"wea": "eq_huoqi", "arm": "eq_anquan", "acc": "eq_dianzhan"}, {"wea": "eq_liangcha", "arm": "eq_laogong", "acc": "eq_yinji"}, {"ml": "ml_gongdi"}, {"wea": "eq_tengpai", "arm": "eq_guanban"}]
	var cl = CanvasLayer.new(); cl.layer = 70; root.add_child(cl)
	var gd = Grid.new(); gd.ks = ks; gd.sets = sets; gd.size = t.get_viewport().get_visible_rect().size; cl.add_child(gd)
	await _w(t, 0.4); await _shot(t, "07_display_grid")
	var oob = []
	for k in gd.bounds:
		var rn = gd.bounds[k]
		if rn is Rect2 and not EV.in_box(rn): oob.append([k, rn])
	_chk("顯示：12 隻鬼 × 配搭，全部喺 1.25H 框內（唔爆格）", oob.is_empty() and gd.bounds.size() == ks.size(), oob)
	var face = []
	for k in ks:
		var A = EV.anchor(k)
		if not A.has("nh") and absf(A.hand.x) < 0.05: face.append(k)   # [anchor] 手可以喺圖左（x<0）；無手（nh）另計
	_chk("兵器喺身前手位（唔喺臉中線）", face.is_empty(), face)
	cl.queue_free(); await _w(t, 0.2)
	# 4. 地圖戰鬥：名鬼揸兵器、遊魂兵揸 B 款
	_stall(150.0)
	var ml = ML.st(); ml.n["5"] = 50.0
	EQ.st().ml_look["5"] = {"ml_huanshou": 50.0}
	var ids = [gx, _gid("laojiang"), _gid("afu")]
	S["team"] = ids
	if EQ.n_free("eq_wokchan") <= 0: EQ.make("eq_wokchan")
	EQ.wear(ids[2], "eq_wokchan")
	EQ.make("eq_anquan"); EQ.wear(ids[1], "eq_anquan")
	S.res["troops"] = 50.0
	if int(J.num(m.mv_view.sim.st().ci)) != 0: m.mv_view.sim.st().ci = 0.0; m.mv_view._after_move(); await _w(t, 1.2)
	S.cleared.erase("1-1")
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-1": S["qi"] = float(i)
	J.G.get("Battle")["auto"] = true
	var r = ZD.start_stage()
	if RTS.pending != null: RTS.card_go()
	await _f(t, 3)
	var op = RTS.op_for("1-1")
	_chk("1-1 地圖戰鬥開到", op != null, r)
	if op == null: return
	var heq = 0; var meq = 0
	for u in op.units:
		if J.num(u.side) == 0 and u.get("eq") is Dictionary: heq += 1
		if J.num(u.side) == 0 and str(u.get("eq_ml", "")) == "ml_huanshou": meq += 1
	_chk("出陣名鬼帶住裝備（%d 隻）、遊魂兵小隊揸環首刀（%d 隊）" % [heq, meq], heq >= 2 and meq >= 1)
	var c = m.village.zone_cam()
	var waitc = func():
		c.glide_to(op.center() + Vector2(0, -40))
		return op.phase != "march"
	var t0 = 0
	while t0 < 600 and not waitc.call(): await _w(t, 0.1); t0 += 1
	c.z = m.village.size.x / 300.0; c.clamp_all(); c.tgt = null; c.vel = Vector2.ZERO; c.center_on(op.center() + Vector2(0, -30))
	await _w(t, 1.2)
	var RV = load("res://game/rts/rts_view.gd")
	var nover = 0
	if RV.inst != null:
		for key in RV.inst.vis:
			var vv = RV.inst.vis[key]
			for ch in vv.chars: if ch.get_node_or_null("EqOver") != null: nover += 1
	_chk("戰場角色掛咗裝備疊層（%d 個）" % nover, nover >= 3)
	await _shot(t, "08_rts_fight")
	await _w(t, 1.5); await _shot(t, "09_rts_fight2")
	var mu2 = null
	for u in op.units: if str(u.get("eq_ml", "")) != "" and J.num(u.hp) > 0: mu2 = u; break
	var hu = null
	for u in op.units: if u.get("eq") is Dictionary and J.num(u.hp) > 0: hu = u; break
	if hu != null:
		c.z = m.village.size.x / 170.0; c.clamp_all(); c.tgt = null; c.vel = Vector2.ZERO; c.center_on((hu.p as Vector2) + Vector2(0, -30))
		await _w(t, 0.3); await _shot(t, "10_rts_hero_zoom")
	if mu2 != null:
		c.center_on((mu2.p as Vector2) + Vector2(0, -25))
		await _w(t, 0.3); await _shot(t, "11_rts_militia_zoom")
	var t1 = 0
	while t1 < 900 and not (op.phase in ["back", "done"]): await _w(t, 0.1); t1 += 1

# ---------------- 錨點表：全部名鬼（不透明輪廓＋手／頭偵測），寫 tools/equip_anchor.json ----------------
func _all_keys() -> Array:
	var ks = {}
	for src in ["res://data/abil.json", "res://data/nat/counter.json"]:
		var o = JSON.parse_string(FileAccess.get_file_as_string(src))
		if not (o is Dictionary): continue
		for sec in ["SCARE", "ABIL", "names"]:
			if o.get(sec) is Dictionary: for k in o[sec]: ks[str(k)] = true
	if DB.D is Dictionary and DB.D.get("GHOSTS") is Dictionary:
		for k in DB.D.GHOSTS: ks[str(k)] = true
	var o2 = []
	for k in ks.keys():
		if PtGfx.tex(Art.spr_key(k)) != null: o2.append(k)
	o2.sort()
	return o2
func anchors(t) -> void:
	await _boot(t)
	var ks = _all_keys()
	var out = {}
	var src = {"auto": 0, "default": 0}
	for k in ks:
		var a = EV.auto_anchor(k)
		src[str(a.src)] = int(src.get(str(a.src), 0)) + 1
		out[k] = {"hand": [snappedf(a.hand.x, 0.01), snappedf(a.hand.y, 0.01)], "head": [snappedf(a.head.x, 0.01), snappedf(a.head.y, 0.01)], "src": str(a.src)}
	var f = FileAccess.open("res://tools/equip_anchor.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(out, " ", true)); f.close()
	_chk("錨點表：%d 隻名鬼有圖（auto %d、default %d）" % [ks.size(), src.auto, src.default], ks.size() >= 100, src)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------------- 抽查：錨點點＋裝備疊層（20 隻一版） ----------------
class Check extends Control:
	var ks: Array = []
	var w := {}
	var cols := 5
	var bounds := {}
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.13, 0.11, 0.1))
		var EVv = load("res://game/equip/eq_view.gd")
		var cw = size.x / cols; var ch = size.y / ceil(ks.size() / float(cols))
		var f = ThemeDB.fallback_font
		for i in ks.size():
			var r = Rect2(Vector2((i % cols) * cw, floor(i / float(cols)) * ch), Vector2(cw - 4, ch - 4))
			draw_rect(r, Color("#6a5040"), false, 1.0)
			var box = Rect2(r.position + Vector2(2, 2), r.size - Vector2(4, 16))
			var ctx = Ctx.new(self)
			EVv.preview(ctx, ks[i], w, box)
			bounds[ks[i]] = EVv.LAST.get(ks[i])
			draw_string(f, Vector2(r.position.x + 2, r.end.y - 3), str(ks[i]).replace("n30_", "").replace("nw_", ""), HORIZONTAL_ALIGNMENT_LEFT, cw - 6, 11, Color("#e8d8b0"))
func check20(t) -> void:
	var m = await _boot(t)
	var ks = _all_keys()
	var picks = []
	var step = maxf(1.0, ks.size() / 20.0)
	for i in 20: if int(i * step) < ks.size(): picks.append(ks[int(i * step)])
	await _grid_shot(t, picks, {"wea": "eq_liangcha", "arm": "eq_anquan", "acc": "eq_staffcard"}, "20_anchor_check_a", 5)
	await _grid_shot(t, picks, {"wea": "eq_wokchan", "arm": "eq_laogong"}, "21_anchor_check_b", 5)
	var picks2 = []
	for i in 20: if int(i * step + step * 0.5) < ks.size(): picks2.append(ks[int(i * step + step * 0.5)])
	await _grid_shot(t, picks2, {"wea": "eq_huanshou", "arm": "eq_anquan"}, "22_anchor_check_c", 5)
	# 五種體型（人形、獸形、紙紮物件、飄浮無腳、大魔王）大圖
	var five = []
	for k in ["afu", "n30_kappa", "nw_zzhouse", "nw_guihuo", "eguiking"]:
		if ks.has(k): five.append(k)
	await _grid_shot(t, five, {"wea": "eq_huoqi", "arm": "eq_anquan", "acc": "eq_dianzhan"}, "23_five_types_a", 2)
	await _grid_shot(t, five, {"wea": "eq_liangcha", "arm": "eq_baoan"}, "24_five_types_b", 2)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func _grid_shot(t, ks: Array, w: Dictionary, name: String, cols: int) -> void:
	var cl = CanvasLayer.new(); cl.layer = 80; t.get_tree().root.add_child(cl)
	var g = Check.new(); g.ks = ks; g.w = w; g.cols = cols; g.size = t.get_viewport().get_visible_rect().size; cl.add_child(g)
	await _w(t, 0.5); await _shot(t, name)
	var oob = []
	for k in g.bounds:
		if g.bounds[k] is Rect2 and not EV.in_box(g.bounds[k]): oob.append(k)
	_chk("%s：%d 隻全部喺框內" % [name, ks.size()], oob.is_empty(), oob)
	cl.queue_free(); await _w(t, 0.2)

# ---------------- [anchor] 全部名鬼穿戴預覽：長兵器（晾衫叉）＋安全帽，4×4 一版，大圖 SubViewport 出 ----------------
#   用法：edtest.sh … equip_test.gd anchor_all
#   未入庫嘅第二批（/home/claude/docs/art_pending/b2）直接由檔案載入暫用，只為預覽
const B2_DIR := "/home/claude/docs/art_pending/b2/"
class AllGrid extends Control:
	var ks: Array = []
	var w := {}
	var bounds := {}
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.16, 0.15, 0.17))
		var EVv = load("res://game/equip/eq_view.gd")
		var cw = size.x / 4.0; var ch = size.y / 4.0
		var f = ThemeDB.fallback_font
		for i in ks.size():
			var r = Rect2(Vector2((i % 4) * cw, floor(i / 4.0) * ch), Vector2(cw - 6, ch - 6))
			draw_rect(r, Color(0.27, 0.26, 0.29))
			draw_rect(r, Color("#6a5040"), false, 2.0)
			var box = Rect2(r.position + Vector2(4, 4), r.size - Vector2(8, 30))
			var ctx = Ctx.new(self)
			EVv.preview(ctx, ks[i], w, box)
			bounds[ks[i]] = EVv.LAST.get(ks[i])
			var A = EVv.anchor(ks[i])
			draw_string(f, Vector2(r.position.x + 6, r.end.y - 8), "%s  %s%s" % [ks[i], str(A.get("src")), ("  " + str(A.get("nh"))) if A.has("nh") else ""], HORIZONTAL_ALIGNMENT_LEFT, cw - 12, 20, Color("#f0e0b8"))
func anchor_all(t) -> void:
	var m = await _boot(t)
	var A = EQ.D().get("ANCHOR", {})
	var ks = A.keys(); ks.sort()
	var miss = []
	for k in ks:
		if PtGfx.tex(Art.spr_key(k)) == null:
			var p = B2_DIR + k + ".webp"
			if FileAccess.file_exists(p):
				var im = Image.load_from_file(p)
				if im != null: PtGfx._tex[Spr.key_for(Art.spr_key(k))] = ImageTexture.create_from_image(im)
			if PtGfx.tex(Art.spr_key(k)) == null: miss.append(k)
	_chk("全部錨點鬼都搵到全身圖（%d 隻）" % ks.size(), miss.is_empty(), miss)
	var man = 0
	for k in ks: if str(A[k].get("src")) == "manual": man += 1
	_chk("錨點全部人工定（%d/%d）" % [man, ks.size()], man == ks.size())
	var badh = []
	for k in ks:
		var a = EV.anchor(k)
		if not a.has("nh") and absf(a.hand.x) < 0.05: badh.append(k)
	_chk("有手嘅鬼：手位唔喺中線（揸住喺身側）", badh.is_empty(), badh)
	var w = {"wea": "eq_liangcha", "arm": "eq_anquan"}
	var oob = []
	var page = 0
	for s in range(0, ks.size(), 16):
		var sv = SubViewport.new(); sv.size = Vector2i(1600, 1800); sv.transparent_bg = false
		sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		t.get_tree().root.add_child(sv)
		var g = AllGrid.new(); g.ks = ks.slice(s, s + 16); g.w = w; g.size = Vector2(1600, 1800); sv.add_child(g)
		await _f(t, 3); await RenderingServer.frame_post_draw
		var name = "anchor_all_%02d" % page
		sv.get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
		for k in g.bounds:
			if g.bounds[k] is Rect2 and not EV.in_box(g.bounds[k]): oob.append([k, g.bounds[k]])
		sv.queue_free(); await _f(t, 2)
		page += 1
	_chk("全部名鬼穿戴（長兵器＋安全帽）喺 1.25H 框內", oob.is_empty(), oob)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
