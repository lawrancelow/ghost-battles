# [roster2] 第二批新名鬼 30 隻（131 隻名冊）測試
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> roster2 res://tools/tests/roster2_test.gd all 600
#   1. 名冊 131 隻：全部登記（J.G／DB.D）、名鬼、全部有圖（真圖或暫代圖）、有能力、主動技唔重複、台詞全部唔重複＋中文
#   2. 第二批 30 隻：系、嚇法、怕兩種唔怕一種（同 abil.json ENEMY、counter.json 8 系表一致）、標籤 2–3＝積木推導、品級（soul.json PIN）、出處、SKILLS、ENEMY_T、紅線字
#   3. 主魂來源：counter.json 雙駐守 guard2、src 主魂、SOUL.sources 有主、打贏同樣掉主魂（唔影響原駐守）、出擊小卡
#   4. 合體技 5 組：成員喺 131 隻、可觸發、唔夠人唔觸發、為虎作倀入舊 COMBOS
#   5. 真出擊一個雙駐守據點：敵陣有新鬼、頭目仍係原駐守
extends RefCounted

const NG = preload("res://game/newghost/ng_data.gd")
const SO = preload("res://game/sortie/so_data.gd")
const CT = preload("res://game/counter/ct_data.gd")
const AB = preload("res://game/rts/abil.gd")
const RTS = preload("res://game/rts/rts.gd")
const SOUL = preload("res://game/soul/soul_data.gd")
const SUI = preload("res://game/soul/soul_ui.gd")
const TAGS := ["遠", "拉", "掃", "破", "刺", "削", "回", "照", "定", "收"]
const MECHS := ["飛", "隱", "殼", "再生", "散骨", "召喚", "反傷", "嚇氣光環", "霸體", "屍變", "突襲", "迷魂", "分身"]
const MULTI := ["circle", "self_circle", "cone", "line", "chain"]
const BANNED := ["盂蘭", "盂兰", "超度", "狐狸精", "唐僧", "佛教", "梵語", "判官", "和尚", "道士", "神父", "上帝", "兒童", "小孩", "細路"]
const IDS := ["nw_bifang", "nw_qiongqi", "nw_nian", "nw_shen", "nw_wangliang", "nw_niexiaoqian", "nw_zhizhama", "nw_luotoumin", "nw_guiamngaan", "nw_guisihknai",
	"nw_paakbok", "nw_dikseigwai", "nw_mosinna", "nw_kamaitachi", "nw_nurikabe", "nw_akaname", "nw_makuragaeshi", "nw_dodomeki", "nw_ungaikyo", "nw_jinmenken",
	"nw_ushioni", "nw_nekomata", "nw_harimau", "nw_banaspati", "nw_bonceng", "nw_nangtani", "nw_manananggal", "nw_nuno", "nw_dokkaebi", "nw_poltergeist"]

var ok := 0
var bad := 0
func _p(m): print("[r2] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	if m != null and m.has_method("_hide_title"): m._hide_title(); await _w(t, 1.0)
	return m

func data(t) -> void: await _run(t, false)
func all(t) -> void: await _run(t, true)
func _run(t, flow: bool) -> void:
	var m = await _boot(t)
	roster_check()
	new_check()
	soul_check()
	link_check()
	if flow: await flow_check(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------------- 標籤推導（同 build_cdata.py derive()／cdata_test 一致） ----------------
func _derive(a: Dictionary) -> Array:
	var t = []
	var ps = []; var src = [a.act.fx]
	for p in a.get("pas", []): src.append(p.fx)
	if a.get("aura") is Dictionary: src.append(a.aura.fx)
	while src.size():
		var fx = src.pop_front()
		for x in fx:
			ps.append(x)
			if str(x.p) == "zone": src.append(x.get("fx", []))
	var ids = {}
	for x in ps: ids[str(x.p)] = true
	var act = a.act; var tg = act.tg
	if float(a.rng) >= 150: t.append("遠")
	if ids.has("down") or ids.has("pull"): t.append("拉")
	var zone_act = false
	for x in act.fx: if str(x.p) == "zone": zone_act = true
	if str(tg.get("shape", "")) in MULTI or zone_act: t.append("掃")
	var hits2 = false; var big = false
	var single = str(tg.get("shape", "single")) == "single" and not (str(tg.get("sel", "")) in ["allies", "self"])
	for x in act.fx:
		if str(x.p) != "dmg": continue
		var h = int(x.get("hits", 1))
		if h >= 2: hits2 = true
		var mm = x.mult[0] if x.mult is Array else float(x.mult)
		if h < 2 and float(mm) >= 1.7: big = true
	if hits2 or ids.has("shield_break") or ids.has("armor_break"): t.append("破")
	if (single and big) or ids.has("execute") or ids.has("dash"): t.append("刺")
	if ids.has("sap") or ids.has("wound") or ids.has("silence") or ids.has("interrupt"): t.append("削")
	if ids.has("drain") or ids.has("heal") or ids.has("hot"): t.append("回")
	if ids.has("reveal") or "light" in a.sc: t.append("照")
	var steady = ids.has("taunt") or ids.has("guard")
	if a.get("aura") is Dictionary and str(a.aura.side) == "ally":
		for x in a.aura.fx:
			if str(x.p) == "immune" and ("fear_aura" in x.get("tags", []) or "confuse" in x.get("tags", [])): steady = true
	if steady: t.append("定")
	if ids.has("banish"): t.append("收")
	return t
func _sig(a: Dictionary) -> String:
	var act = a.get("act", {})
	if not (act is Dictionary) or act.is_empty(): return ""
	var ps = []
	for f in act.get("fx", []): ps.append(str(f.get("p", "")))
	ps.sort()
	return JSON.stringify(act.get("tg", {}), "", true) + "|" + ",".join(ps)
func _art_ok(k: String) -> bool:
	var tex = PtGfx.tex(Art.spr_key(k))
	return tex != null and Art.char_h(k) > 0 and Art.portrait_region(k).size() == 2

# ================= 1. 名冊 131 =================
func roster_check() -> void:
	_chk("newghost2.json 讀到、已登記（install2）", NG.installed2 and not NG.D2().is_empty())
	var R = NG.roster_all(); var GH = J.G.GHOSTS
	var uniq = {}
	for k in R: uniq[str(k)] = true
	_chk("名冊 131 隻、唔重複（101＋第二批 30）", R.size() == 131 and uniq.size() == 131 and NG.roster().size() == 101, R.size())
	_chk("第二批 30 隻 id 同 roster2_ids.md 一致", NG.keys2() == IDS, NG.keys2())
	var miss = []; var notnamed = []; var miss_db = []
	for k in R:
		var g = GH.get(k)
		if not (g is Dictionary): miss.append(k); continue
		if not (str(g.get("q", "")) in ["名", "主"]): notnamed.append(k)
	for k in IDS: if not (DB.D.GHOSTS.get(k) is Dictionary): miss_db.append(k)
	_chk("131 隻全部喺 GHOSTS（J.G）、都係名鬼", miss.is_empty() and notnamed.is_empty(), [miss, notnamed])
	_chk("第二批 30 隻入咗 DB.D.GHOSTS（原生介面用）", miss_db.is_empty(), miss_db)
	var noart = []
	for k in R: if not _art_ok(str(k)): noart.append(k)
	_chk("131 隻全部有圖（真圖或暫代圖）：貼圖、高度、頭像", noart.is_empty(), noart)
	var ph2 = IDS.filter(func(k): return NG.is_placeholder(k))
	var real2 = IDS.filter(func(k): return not NG.is_placeholder(k) and str(NG.spr_path(k)).ends_with(k + ".webp"))
	_chk("第二批圖：真圖（assets/spr/<id>.webp）或暫代圖（ng_ph），換圖只改一處", ph2.size() + real2.size() == 30, "暫代 %d、真圖 %d" % [ph2.size(), real2.size()])
	var noab = []; var sigs = {}; var dup = []
	for k in R:
		var a = NG.abil_of(str(k))
		if a.is_empty(): noab.append(k); continue
		var sg = _sig(a)
		if sg == "": continue
		if sigs.has(sg) and str(k) in IDS: dup.append([k, sigs[sg]])
		sigs[sg] = k
	_chk("131 隻全部有能力", noab.is_empty(), noab)
	_chk("第二批主動技（目標＋積木）唔同 131 隻任何一隻重複", dup.is_empty(), dup)
	var nosay = []; var says = {}; var dsay = []
	for k in R:
		var s = NG.say_of(str(k))
		if s == "": nosay.append(k); continue
		if says.has(s): dsay.append([k, says[s]])
		says[s] = k
	_chk("131 隻全部有台詞", nosay.is_empty(), nosay)
	_chk("131 句台詞全部唔重複", dsay.is_empty(), dsay)
	var zh = []; var zs = {}
	for k in IDS:
		var y = str(GH[k].say); var z = str(DB.D.LANG_ZH.get(y, ""))
		if z == "" or z == y or zs.has(z): zh.append(k)
		zs[z] = k
	_chk("第二批台詞有中文版（LANG_ZH，句句唔同）", zh.is_empty(), zh)
	# 台詞唔撞遊戲其他字串（第一批、cdata、劇情）：abil.json 舊 ABIL 嘅 say、newghost.json
	var old = {}
	for k in AB.data().get("ABIL", {}):
		if str(k) in IDS: continue
		var y = AB.data().ABIL[k].get("say")
		if y is Array and y.size(): old[str(y[0])] = k
	var hit = []
	for k in IDS: if old.has(str(GH[k].say)): hit.append(k)
	_chk("第二批台詞唔撞現有名鬼台詞（abil.json／newghost.json）", hit.is_empty(), hit)

# ================= 2. 第二批 30 隻數據 =================
func new_check() -> void:
	var GH = J.G.GHOSTS; var E: Dictionary = AB.data().get("ENEMY", {}); var ET = J.G.ENEMY_T
	var badd = []; var badf = []; var badt = []; var red = []
	var tc = {}
	for k in IDS:
		var g = GH[k]; var a = NG.abil(k); var e = NG.enemy(k); var ea = E.get(k, {})
		var good = (J.G.SKILLS.get(k) is Dictionary) and (ET.get(k) is Array) and str(g.get("lore", "")).length() > 10 and str(g.get("title", "")) != "" and str(g.get("trait", "")) != ""
		good = good and NG.pin(k) in ["凡", "靈", "煞"] and SOUL.pin(k) == NG.pin(k) and int(J.num(e.get("ch", 0))) >= 1 and int(J.num(e.get("ch", 0))) <= 6
		good = good and (a.get("act", {}).get("fx", []) as Array).size() > 0 and str(a.act.get("name", "")) != "" and (a.get("pas", []) as Array).size() > 0
		for m in e.get("mech", []): if not m in MECHS: good = false
		if not good: badd.append(k)
		# 怕兩種唔怕一種：同 8 系表、abil.json ENEMY（cdata 生成）一致
		var si = CT.sys_info(str(e.get("sys", "")))
		var fe: Array = ea.get("fear", []); var im: Array = ea.get("imm", [])
		var fok = not si.is_empty() and fe.size() == 2 and im.size() == 1 and str(im[0]) == str(si.imm) and not (str(ea.sc[0]) in fe)
		for f in fe: if not f in si.get("fear", []): fok = false
		fok = fok and ea.get("fear") == e.get("fear") and ea.get("imm") == e.get("imm") and ea.get("sys") == e.get("sys") and ea.get("sc") == a.get("sc") and J.t(ea.get("recruit"))
		if not fok: badf.append(k)
		# 標籤 2–3、＝積木推導
		var tg: Array = a.get("tags", [])
		var d = _derive(a); var s1 = tg.duplicate(); s1.sort(); d.sort()
		if tg.size() < 2 or tg.size() > 3 or s1 != d: badt.append("%s %s≠%s" % [k, s1, d])
		for x in tg: tc[x] = int(tc.get(x, 0)) + 1
		for w in BANNED:
			for txt in [str(g.name), str(g.title), str(g.trait), str(g.say), str(DB.D.LANG_ZH.get(str(g.say), ""))]:
				if txt.contains(w): red.append("%s:%s" % [k, w])
	_chk("30 隻：SKILLS、ENEMY_T、出處、稱號、特性、品級（soul.json＝newghost2）、出場章、主動＋被動、機制屬 13 種", badd.is_empty(), badd)
	_chk("30 隻：怕兩種、唔怕一種，照 8 系表，同 abil.json ENEMY 一致、可招降", badf.is_empty(), badf)
	_chk("30 隻：標籤 2–3 個，等於積木推導（cdata 規則）", badt.is_empty(), badt)
	_chk("30 隻：名、稱號、特性、台詞冇紅線字（宗教／兒童）", red.is_empty(), red)
	var ti = []
	for x in TAGS: ti.append("%s%d" % [x, int(tc.get(x, 0))])
	_p("第二批標籤：" + " ".join(ti))
	_chk("優先補偏少標籤：收≥4、回≥8、照≥5、定≥8", int(tc.get("收", 0)) >= 4 and int(tc.get("回", 0)) >= 8 and int(tc.get("照", 0)) >= 5 and int(tc.get("定", 0)) >= 8, ti)
	var nm = {}; var dn = []
	for k in NG.roster_all():
		var n = str(GH[k].name)
		if nm.has(n): dn.append([k, nm[n]])
		nm[n] = k
	_chk("131 隻名冇重複", dn.is_empty(), dn)
	_chk("Nuno sa Punso 用「Tabi tabi po」做台詞梗（有禮貌就放行）", str(GH.nw_nuno.say).contains("Tabi tabi po") and str(GH.nw_nuno.say).contains("有禮貌"))
	var cj = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/codex.json"))
	var L = cj.get("LIST", []) if cj is Dictionary else []
	var have = {}
	for x in L: have[str(x.k)] = true
	_chk("圖鑑 codex.json 131 格、包晒第二批", L.size() == 131 and IDS.all(func(k): return have.has(k)), L.size())

# ================= 3. 主魂來源（雙駐守） =================
func soul_check() -> void:
	var D = CT.data(); var C: Dictionary = D.get("camps", {}); var SRC: Dictionary = D.get("src", {})
	var g2 = {}
	for id in C: if str(C[id].get("guard2", "")) != "": g2[str(C[id].guard2)] = id
	var nos = []; var nsrc = []; var nen = []; var nsoul = []
	for k in IDS:
		if not g2.has(k): nos.append(k); continue
		var c = C[g2[k]]
		var pri = false
		for x in SRC.get(k, []): if str(x.get("t", "")) == "camp" and J.t(x.get("guard", false)): pri = true
		if not pri: nsrc.append(k)
		if not (k in c.en) or str(c.guard) == k or J.t(c.get("king")) or c.has("bm") or int(c.ring) < 2: nen.append(k)
		var ss = SOUL.sources(k).filter(func(x): return x.pri)
		if ss.is_empty(): nsoul.append(k)
	_chk("30 隻每隻都係一個據點嘅雙駐守（counter.json camps[id].guard2）", nos.is_empty() and g2.size() == 30, nos)
	_chk("counter.json src：30 隻都有主魂來源（guard）", nsrc.is_empty(), nsrc)
	_chk("雙駐守喺敵陣入面、唔係原駐守、唔放野外王／魔王據點、第 2～4 圈", nen.is_empty(), nen)
	_chk("SOUL.sources：30 隻都有主魂據點", nsoul.is_empty(), nsoul)
	var ch_bad = []
	for k in IDS:
		var c = C[g2[k]]
		if int(c.c) + 1 != int(J.num(NG.enemy(k).ch)) or SOUL.ch_of(k) != int(c.c): ch_bad.append(k)
	_chk("雙駐守據點喺出場章、招降費按該章計", ch_bad.is_empty(), ch_bad)
	var dupc = []
	for k in g2: if (g2.values() as Array).count(g2[k]) > 1: dupc.append(k)
	_chk("每個據點最多一隻雙駐守", dupc.is_empty(), dupc)
	# 打贏：原駐守同雙駐守都掉主魂；副魂唔會係雙駐守
	var k = "nw_nian"; var id = str(g2[k])
	var e = SO.camp(id, int(C[id].c))
	_chk("SOUL.guard2_of（年獸據點 %s）" % id, not e.is_empty() and SOUL.guard2_of(e) == k and SOUL.guard_of(e) == str(C[id].guard), [SOUL.guard2_of(e), SOUL.guard_of(e)])
	var o = SOUL.st()
	SOUL.test_now = 777.0 * 86400000.0 + 12 * 3600000.0
	o.fr = {"day": -1.0, "n": {}}
	var gk = SOUL.guard_of(e)
	var b1 = SOUL.souls(gk); var b2 = SOUL.souls(k)
	SOUL.rng.seed = 11
	var r = SOUL.on_sortie_win(e, true)
	var d1 = SOUL.souls(gk) - b1; var d2 = SOUL.souls(k) - b2
	var ri = SOUL.ri(e.ring)
	_chk("打贏雙駐守據點：原駐守照掉主魂；雙駐守掉主魂（首勝＋圈 %d）" % (ri + 1), d1 >= SOUL.PRI[ri] + SOUL.FIRST[ri] and d2 == maxi(1, SOUL.PRI[ri]) + SOUL.FIRST[ri], [gk, d1, k, d2])
	_chk("戰報寫埋雙駐守", str(r.line).contains(str(J.G.GHOSTS[k].name)), r.line)
	_chk("副魂唔係雙駐守", SOUL.sec_of(e) != k, SOUL.sec_of(e))
	var info = SUI.card_info(e)
	_chk("出擊小卡有雙駐守一行資料", str(info.get("g2", "")) == k and int(info.get("g2_need", 0)) > 0, info.get("g2"))
	# counter 關咗 → 冇雙駐守（一鍵回退）
	J.G.S["ct_off"] = true
	_chk("counter 關（S.ct_off）→ 冇雙駐守", SOUL.guard2_of(e) == "")
	J.G.S.erase("ct_off")
	# 冇雙駐守嘅據點唔受影響
	var e0 = SO.camps(0)[0]
	_chk("第 1 章第 1 據點冇雙駐守", SOUL.guard2_of(e0) == "")
	SOUL.test_now = -1.0

# ================= 4. 合體技 =================
func link_check() -> void:
	var L2 = NG.D2().get("LINK", [])
	_chk("第二批合體技 5 組（3–5）", L2.size() >= 3 and L2.size() <= 5, L2.size())
	var R = {}
	for k in NG.roster_all(): R[str(k)] = true
	var ABL = {}
	for x in AB.data().get("LINK", []): if x is Dictionary: ABL[str(x.get("id", ""))] = true
	var bad_m = []; var fail = []; var lone = []; var noab = []
	for L in L2:
		for m in L.m: if not R.has(str(m)): bad_m.append([L.id, m])
		if not ABL.has(str(L.id)): noab.append(L.id)
		var team = (L.m as Array).slice(0, int(L.need))
		var got = NG.active_links(team).map(func(x): return x.id)
		if not (str(L.id) in got): fail.append(L.id)
		var one = NG.active_links([L.m[0]]).map(func(x): return x.id)
		if str(L.id) in one: lone.append(L.id)
		if str(L.lore).length() < 6: bad_m.append([L.id, "冇民俗依據"])
	_chk("成員全部喺 131 隻、有民俗依據", bad_m.is_empty(), bad_m)
	_chk("全部可觸發（一隊最多 3 隻）", fail.is_empty(), fail)
	_chk("得一隻成員唔會觸發", lone.is_empty(), lone)
	_chk("已併入能力引擎 LINK（abil.gd links）", noab.is_empty(), noab)
	var cb = J.G.get("COMBOS"); var has = false
	if cb is Array:
		for c in cb: if c is Dictionary and str(c.get("id", "")) == "weihu" and str(c.get("a", "")) == "n30_changgui" and str(c.get("b", "")) == "nw_harimau": has = true
	_chk("為虎作倀（倀鬼＋Harimau Jadian）合擊入舊 COMBOS", has)
	var feud = []
	var BF = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/bonds_data.json"))
	for f in (BF.get("BOND_FEUDS", []) if BF is Dictionary else []):
		for L in L2:
			if (L.m as Array).size() == 2 and str(f.a) in L.m and str(f.b) in L.m: feud.append(L.id)
	_chk("冇一組係冤家", feud.is_empty(), feud)

# ================= 5. 真出擊雙駐守據點 =================
func flow_check(t, m) -> void:
	var S = J.G.S
	S.res["buns"] = 9000.0; S.res["coins"] = 900000.0
	if (S.get("team", []) as Array).is_empty() and (S.get("ghosts", []) as Array).size() > 0: S["team"] = [S.ghosts[0].id]
	SO.force_open = true; SO.test_now = 5000000.0
	var C: Dictionary = CT.data().get("camps", {})
	var id = ""
	for x in C: if str(C[x].get("guard2", "")) == "nw_nian": id = x
	var e = SO.camp(id, int(C[id].c)) if id != "" else {}
	if e.is_empty(): _chk("找到年獸雙駐守據點", false); SO.force_open = false; return
	var st = SO.stage_of(e)
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	_chk("雙駐守據點（%s）出擊得" % id, r == "ok" and op != null, r)
	if op != null:
		var ks = []; var last = null
		for u in op.units:
			if J.num(u.side) == 1 and not J.t(u.get("minion")): ks.append(str(u.k)); last = u
		_chk("敵陣有年獸（雙駐守）＝counter.json 組合", "nw_nian" in ks and ks == st.en, [ks, st.en])
		_chk("頭目（最後一隻）仍係原駐守、op 記住駐守鬼", last != null and str(last.k) == str(st.guard) and J.t(last.get("boss")) and str(op.get_meta("guard", "")) == str(st.guard), [last.k if last else null, st.guard])
		var nu = null
		for u in op.units: if J.num(u.side) == 1 and str(u.k) == "nw_nian": nu = u
		_chk("年獸單位有能力（abcore 讀到 ABIL／機制）", nu != null and AB.on() and (AB.tags_of("nw_nian") as Array).size() >= 2, AB.tags_of("nw_nian") if nu != null else null)
		RTS.recall(op); RTS.ops.erase(op)
	await _w(t, 0.3)
	SO.force_open = false; SO.test_now = -1.0
