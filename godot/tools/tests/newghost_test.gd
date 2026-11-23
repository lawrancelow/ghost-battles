# [newghost] 新名鬼／大魔王／新雜兵／合體技／魔王據點 測試
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> newghost res://tools/tests/newghost_test.gd all 600
#   1. 名冊 101 隻：全部登記、全部有圖（或暫代圖）、有能力、有台詞且唔重複；新鬼數據齊（系、嚇法、怕／唔怕、標籤 2–3、品級、出處）
#   2. 大魔王 7、新雜兵 8：ENEMY_T、機制、圖
#   3. 合體技 25 組：成員都喺 101 隻入面、全部可觸發（最多 3 隻同場）、唔夠人唔觸發、合擊兩人組入舊 COMBOS
#   4. 魔王據點 6 個：每關第 4 圈一個、可達（沿可走區）、行軍 ≤ 40 秒、唔重疊、鎖／開、出擊打贏掉散魂、酒吞童子重現
extends RefCounted

const NG = preload("res://game/newghost/ng_data.gd")
const NGB = preload("res://game/newghost/ng_boss.gd")
const SO = preload("res://game/sortie/so_data.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const CW = preload("res://game/outpost/ctl_walk.gd")
const SIM = preload("res://game/rts/rts_sim.gd")
const RTS = preload("res://game/rts/rts.gd")

var ok := 0
var bad := 0
func _p(m): print("[ng] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _boot(t):
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
func _goto(t, m, c: int) -> void:
	var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) == c: return
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2)

func all(t) -> void:
	var m = await _boot(t)
	roster_check()
	enemy_check()
	link_check()
	await camp_check(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 1. 名冊 =================
func _art_ok(k: String) -> bool:
	var tex = PtGfx.tex(Art.spr_key(k))
	return tex != null and Art.char_h(k) > 0 and Art.portrait_region(k).size() == 2
func _sig(a: Dictionary) -> String:
	var act = a.get("act", {})
	if not (act is Dictionary) or act.is_empty(): return ""
	var ps = []
	for f in act.get("fx", []): ps.append(str(f.get("p", "")))
	ps.sort()
	return JSON.stringify(act.get("tg", {}), "", true) + "|" + ",".join(ps)

func roster_check() -> void:
	_chk("newghost.json 讀到、已登記（patrol_ghosts 掛鈎）", NG.installed and not NG.D().is_empty())
	var R = NG.roster(); var GH = J.G.GHOSTS
	var uniq = {}
	for k in R: uniq[str(k)] = true
	_chk("名冊 101 隻、唔重複", R.size() == 101 and uniq.size() == 101, R.size())
	var miss = []; var notnamed = []
	for k in R:
		var g = GH.get(k)
		if not (g is Dictionary): miss.append(k); continue
		if not (str(g.get("q", "")) in ["名", "主"]): notnamed.append(k)
	_chk("101 隻全部喺 GHOSTS（J.G）", miss.is_empty(), miss)
	_chk("101 隻都係名鬼（q＝名；阿福＝主）", notnamed.is_empty(), notnamed)
	var miss_db = []
	for k in NG.keys(): if not (DB.D.GHOSTS.get(k) is Dictionary): miss_db.append(k)
	_chk("新鬼 26＋牛頭馬面都入咗 DB.D.GHOSTS（原生介面用）", miss_db.is_empty() and NG.keys().size() == 28, miss_db)
	# 圖
	var noart = []
	for k in R: if not _art_ok(str(k)): noart.append(k)
	_chk("101 隻全部有圖（真圖或暫代圖）：貼圖、高度、頭像", noart.is_empty(), noart)
	var ph = NG.placeholders()
	_p("暫代圖 %d 張：%s" % [ph.size(), ", ".join(PackedStringArray(ph))])
	_chk("暫代圖只係新鬼／魔王／雜兵（舊鬼唔受影響）", ph.all(func(k): return str(k).begins_with("nw_") or str(k).begins_with("bm_") or str(k).begins_with("zd_")))
	_chk("牛頭馬面用返原有圖", not NG.is_placeholder("niutou") and not NG.is_placeholder("mamian") and str(Spr._man.get("niutou", "")).ends_with("niutou.webp"))
	# 能力
	var noab = []; var sigs = {}; var dup = []
	for k in R:
		var a = NG.abil_of(str(k))
		if a.is_empty(): noab.append(k); continue
		var sg = _sig(a)
		if sg == "": continue
		if sigs.has(sg) and str(k).begins_with("nw_"): dup.append([k, sigs[sg]])
		sigs[sg] = k
	_chk("101 隻全部有能力（abil.json／newghost ABIL／舊 SKILLS）", noab.is_empty(), noab)
	var own = []
	for k in NG.new_keys():
		var a = NG.abil(str(k))
		if a.is_empty() or (a.get("act", {}).get("fx", []) as Array).is_empty() or str(a.act.get("name", "")) == "": own.append(k)
	_chk("新鬼 26 隻自己有主動技（ABIL act：名＋積木）", own.is_empty() and NG.new_keys().size() == 26, own)
	_chk("新鬼主動技唔同任何其他鬼重複（目標＋積木組合）", dup.is_empty(), dup)
	# 台詞
	var nosay = []; var says = {}; var dsay = []
	for k in R:
		var s = NG.say_of(str(k))
		if s == "": nosay.append(k); continue
		if says.has(s): dsay.append([k, says[s]])
		says[s] = k
	_chk("101 隻全部有台詞", nosay.is_empty(), nosay)
	_chk("101 句台詞全部唔重複", dsay.is_empty(), dsay)
	var zh = 0
	for k in NG.keys(): if str(DB.D.LANG_ZH.get(str(GH[k].say), "")) != "": zh += 1
	_chk("新鬼台詞有中文版（LANG_ZH）", zh == 28, zh)
	# 新鬼數據
	var badd = []
	for k in NG.keys():
		var e = NG.enemy(str(k)); var g = GH[k]
		var tg = (NG.abil(str(k)).get("tags", e.get("tags", [])) as Array)
		if k in ["niutou", "mamian"]: tg = ["x", "y"]   # 標籤歸 cdata ABIL
		var good = e.has("sys") and (e.get("sc", []) as Array).size() == 1 and (e.get("fear", []) as Array).size() == 2 and (e.get("imm", []) as Array).size() == 1
		good = good and not (e.sc[0] in e.fear) and tg.size() >= 2 and tg.size() <= 3
		good = good and NG.pin(str(k)) in ["凡", "靈", "煞"] and str(g.get("lore", "")).length() > 10 and str(g.get("title", "")) != "" and str(g.get("trait", "")) != ""
		good = good and (J.G.SKILLS.get(k) is Dictionary) and (J.G.ENEMY_T.get(k) is Array)
		if not good: badd.append(k)
	_chk("新鬼／牛頭馬面：系、嚇法、怕兩種唔怕一種（自己嚇法唔喺怕）、標籤 2–3、品級、出處、SKILLS、ENEMY_T", badd.is_empty(), badd)
	_chk("改名定案：陰司審批官、投胎辦事處職員、紙紮跑車、狐妖", GH.nw_shenpi.name == "陰司審批官" and GH.nw_toutai.name == "投胎辦事處職員" and GH.nw_zzcar.name == "紙紮跑車" and GH.nw_huli.name == "狐妖")
	_chk("陰司審批官有「收」；Teke Teke 第 5 關、冇免疫腳軟", "收" in NG.abil("nw_shenpi").tags and int(NG.enemy("nw_teketeke").ch) == 5 and not JSON.stringify(NG.abil("nw_teketeke")).contains("\"down\",\"push\"") and not JSON.stringify(NG.abil("nw_teketeke").get("pas", [])).contains("immune"))

# ================= 2. 大魔王＋雜兵 =================
func enemy_check() -> void:
	var ET = J.G.ENEMY_T
	var bs = NG.boss_keys(); var fs = NG.fod_keys()
	_chk("大魔王 7 隻（6 據點＋酒吞童子）、新雜兵 8 種", bs.size() == 7 and fs.size() == 8, [bs.size(), fs.size()])
	var b1 = []
	for k in bs:
		var e = NG.enemy(str(k)); var a = NG.abil(str(k))
		if not (ET.get(k) is Array) or not _art_ok(str(k)) or (e.get("mech", []) as Array).size() != 3 or J.t(e.get("recruit")) or a.is_empty() or J.G.GHOSTS.has(k):
			b1.append(k)
		if NG.D().BOSS[k].get("drop", {}).get("first", 0) <= 0: b1.append(str(k) + ":drop")
	_chk("大魔王：ENEMY_T、圖、3 個機制、主動技＋被動、不可招降（唔喺 GHOSTS）、有散魂掉落", b1.is_empty(), b1)
	var f1 = []
	for k in fs:
		var e = NG.enemy(str(k))
		if not (ET.get(k) is Array) or not _art_ok(str(k)) or not e.has("mech") or not e.has("quirk") or str(e.get("kind")) != "fod": f1.append(k)
	_chk("新雜兵：ENEMY_T、圖、機制／習性", f1.is_empty(), f1)
	var mf = 0
	for k in fs: mf += (NG.enemy(str(k)).mech as Array).size() + (NG.enemy(str(k)).quirk as Array).size()
	_chk("8 種雜兵每種都有機制或習性", fs.all(func(k): return (NG.enemy(str(k)).mech as Array).size() + (NG.enemy(str(k)).quirk as Array).size() > 0), mf)
	var src = ["egui", "youhun", "xiaogui", "zombie", "zd_shanjing", "zd_bone", "zd_hongyi", "zd_shuihou", "zd_paotui", "zd_yinchai"]
	_chk("魔王嘍囉全部有 ENEMY_T", src.all(func(k): return ET.has(k)))

# ================= 3. 合體技 =================
func link_check() -> void:
	var L = NG.links(); var R = NG.roster()
	_chk("合體技 25 組", L.size() == 25, L.size())
	var notin = []; var fail = []; var lone = []
	for x in L:
		for mm in x.m: if not (mm in R): notin.append([x.id, mm])
		var team = (x.get("must", []) as Array).duplicate()
		for mm in x.m:
			if team.size() >= int(x.need): break
			if not (mm in team): team.append(mm)
		var act = NG.active_links(team).map(func(a): return a.id)
		if team.size() > 3 or not (x.id in act): fail.append([x.id, team])
		var one = NG.active_links([team[0]]).map(func(a): return a.id)
		if x.id in one: lone.append(x.id)
		# 「任 N」：其他成員組合都得
		if x.m.size() > int(x.need) and not x.has("must"):
			var t2 = (x.m as Array).slice(x.m.size() - int(x.need))
			if not (x.id in NG.active_links(t2).map(func(a): return a.id)): fail.append([x.id, t2])
	_chk("合體技成員全部喺 101 隻入面", notin.is_empty(), notin)
	_chk("25 組全部可觸發（最多 3 隻同場；任 N 組任揀都得）", fail.is_empty(), fail)
	_chk("得一隻成員唔會觸發", lone.is_empty(), lone)
	var nm = NG.active_links(["mamian", "baiwu"]).map(func(a): return a.id)
	_chk("奈何橋一定要有孟婆（白無常＋馬面唔觸發）", not ("naihe" in nm))
	var CB = J.G.COMBOS; var have = {}
	for c in CB: have[str(c.get("a", "")) + "+" + str(c.get("b", ""))] = true
	var miss = []
	for x in L:
		if str(x.kind) == "strike" and (x.m as Array).size() == 2 and not have.has(str(x.m[0]) + "+" + str(x.m[1])): miss.append(x.id)
	_chk("合擊兩人組全部入咗舊 COMBOS（舊戰鬥引擎都觸發到）", miss.is_empty(), miss)
	var feud = []
	for f in J.G.get("BOND_FEUDS", []):
		for x in L:
			if (x.m as Array).size() == 2 and str(f.a) in x.m and str(f.b) in x.m: feud.append(x.id)
	_chk("冇一組係冤家", feud.is_empty(), feud)

# ================= 4. 魔王據點 =================
func camp_check(t, m) -> void:
	var S = J.G.S
	var bak_sortie = (S.get("sortie", {}) as Dictionary).duplicate(true) if S.get("sortie") is Dictionary else null
	var bak_ngb = S.get("ngb"); var bak_soul = S.get("soul")
	var bak_ci = int(J.num(m.mv_view.sim.st().ci))
	var want = NG.D().BOSS_CAMP
	for c in 6:
		await _goto(t, m, c)
		var tag = "第%d關 " % (c + 1)
		var bz = ZD.sorties(c).filter(func(s): return s.has("boss"))
		_chk(tag + "第 4 圈有一個魔王據點（%s）" % str(want[c]), bz.size() == 1 and int(bz[0].ring) == 4 and str(bz[0].boss) == str(want[c]), bz.size())
		if bz.is_empty(): continue
		var s = bz[0]; var p = ZD.v2(s.pos)
		_chk(tag + "魔王據點喺第 4 圈帶入面", ZD.ring_at(p, c) == 4, ZD.ring_at(p, c))
		var near = 99999.0
		for s2 in ZD.sorties(c): if s2 != s: near = minf(near, p.distance_to(ZD.v2(s2.pos)))
		_chk(tag + "同其他據點唔重疊（≥200）", near >= 200.0, int(near))
		var reach = true; var why = []
		var rt: Array = s.route
		var gate = ZD.v2(ZD.mdef(c).village.POS.gate)
		if ZD.v2(rt[0]).distance_to(gate) > 140.0 or ZD.v2(rt[rt.size() - 1]).distance_to(p) > 1.0: reach = false; why.append("頭尾")
		var L = 0.0
		for i in rt.size() - 1:
			var a = ZD.v2(rt[i]); var b = ZD.v2(rt[i + 1]); L += a.distance_to(b)
			var n = maxi(1, int(a.distance_to(b) / 8.0))
			for j in n + 1:
				var q = a.lerp(b, float(j) / n); var ra = ZD.ring_at(q, c)
				if (ra == 0 and CW.region(q) == "") or ra < 0: reach = false; why.append(q); break
		_chk(tag + "魔王據點可達（由村門沿可走區、出核心後喺圈帶）", reach, why.slice(0, 2))
		_chk(tag + "行軍 ≤ 40 秒", L / SIM.MARCH <= 40.0, "%.1f 秒" % (L / SIM.MARCH))
		_chk(tag + "方向同出路一致（經 %s 出路）" % str(s.dir), (rt.slice(0, ZD.exits4(c).filter(func(e): return e.dir == s.dir)[0].pts.size()) == ZD.exits4(c).filter(func(e): return e.dir == s.dir)[0].pts))
		var e = SO.camps(c).filter(func(x): return str(x.get("bm", "")) != "")
		_chk(tag + "SO.camps 帶魔王（bm）", e.size() == 1 and str(e[0].bm) == str(want[c]))
		if e.is_empty(): continue
		var stg = SO.stage_of(e[0])
		_chk(tag + "敵陣：最後一隻係魔王、全部有 ENEMY_T", (stg.en as Array).size() == SO.ENEMY_N[3] and str(stg.en[-1]) == str(want[c]) and (stg.en as Array).all(func(k): return J.G.ENEMY_T.has(k)), stg.en)
	# ---- 鎖／開＋出擊打贏（第 1 關） ----
	await _goto(t, m, 0)
	S.erase("ngb")
	SO.force_open = true; SO.test_now = 5000000.0
	S["sortie"] = {"v": 1.0, "camps": {}, "n": 0.0}
	var eb = SO.camps(0).filter(func(x): return str(x.get("bm", "")) != "")[0]
	_chk("第 4 圈其他據點未首勝：魔王據點鎖住", SO.state(eb) == "locked" and SO.dispatch(eb) == "locked")
	for x in SO.camps(0): if int(x.ring) == 4 and str(x.get("bm", "")) == "": SO.cst(x)["first"] = true
	_chk("第 4 圈其他據點全部首勝：魔王據點開放", SO.state(eb) == "open", SO.state(eb))
	# 隊伍
	if S.ghosts.size() < 3:
		var have = []
		for g in S.ghosts: have.append(str(g.k))
		for k in ["xiaozhi", "toyol"]:
			if not k in have: J.cl(J.G.get("joinGhost"), null, [k])
		await _skip(t, 8)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids; S["lv"] = maxf(3.0, J.num(S.lv)); S.res["troops"] = 100.0; S.res["buns"] = 5000.0; S.res["coins"] = 100000.0
	J.G.Battle["auto"] = true
	var san0 = J.num((S.get("soul", {}) as Dictionary).get("san", 0)) if S.get("soul") is Dictionary else 0.0
	var r = SO.dispatch(eb)
	var op = RTS.op_for(SO.sid_of(eb))
	_chk("魔王據點出擊 ok", r == "ok" and op != null, r)
	if op != null:
		var bu = op.units.filter(func(u): return J.num(u.side) == 1 and str(u.k) == "bm_taotie")
		_chk("戰場有魔王單位、名牌「饕餮」、頭目", bu.size() == 1 and str(bu[0].name) == "饕餮" and J.t(bu[0].get("boss")), bu.map(func(u): return u.name))
		for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0; u["maxhp"] = maxf(1.0, J.num(u.maxhp))
		for i in 3000:
			if op.phase == "done": break
			RTS._last_f = -1; RTS.tick(0.1)
		var rep = RTS.last_report
		var dr = NG.D().BOSS.bm_taotie.drop
		var san1 = J.num(S.soul.get("san", 0)) if S.get("soul") is Dictionary else 0.0
		_chk("打贏魔王：戰報勝利、首勝", J.t(rep.get("win")) and J.t(rep.get("first")), rep.get("head"))
		_chk("掉散魂（首勝 %d＋%d）" % [int(dr.first), int(dr.win)], absf(san1 - san0 - dr.first - dr.win) < 0.01, [san0, san1])
		_chk("戰報有散魂一行", str(rep.get("full", "")).contains("散魂"), rep.get("full"))
		_chk("魔王唔會變名鬼（S.ghosts 冇 bm_）", S.ghosts.all(func(g): return not str(g.k).begins_with("bm_")))
		_chk("記錄打低魔王", NGB.beat("bm_taotie") == 1)
	# ---- 酒吞童子 ----
	for k in NG.D().BOSS_CAMP: NGB.st().beat[k] = 1.0
	var e2 = SO.camps(0).filter(func(x): return str(x.get("bm", "")) != "")[0]
	_chk("六隻章魔王全部打低：第 1 關魔王據點換酒吞童子", str(e2.bm) == "bm_shuten" and str(SO.stage_of(e2).en[-1]) == "bm_shuten", e2.bm)
	var e3 = SO.camps(1).filter(func(x): return str(x.get("bm", "")) != "")[0]
	_chk("其他關魔王據點唔受影響", str(e3.bm) == "bm_jembalang")
	# 還原
	SO.force_open = false; SO.test_now = -1.0
	if bak_sortie != null: S["sortie"] = bak_sortie
	else: S.erase("sortie")
	if bak_ngb != null: S["ngb"] = bak_ngb
	else: S.erase("ngb")
	if bak_soul != null: S["soul"] = bak_soul
	await _goto(t, m, bak_ci)
