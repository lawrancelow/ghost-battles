# [cdata] 克制數據校驗：abil.json（ABIL／ENEMY）、counter.json（8 系、ch_k、24 鬼幫、90 據點）、據點敵人改讀 counter.json、SOFT 步驟 A、文字修正
# 用法：/home/claude/setup/edtest.sh <godot目錄> cdata res://tools/tests/cdata_test.gd data|all <秒>
#   data：純數據校驗（唔出擊）
#   all：data ＋ 真出擊第 5 關第 4 圈據點，驗打折、頂替縮細、頭目保留真名、駐守鬼，之後叫回
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const CT = preload("res://game/counter/ct_data.gd")
const AB = preload("res://game/rts/abil.gd")

const TAGS := ["遠", "拉", "掃", "破", "刺", "削", "回", "照", "定", "收"]
const MECHS := ["飛", "隱", "殼", "再生", "散骨", "召喚", "反傷", "嚇氣光環", "霸體", "屍變", "突襲", "迷魂", "分身"]
const SYSS := ["屍", "魂", "紙紮", "妖", "厲", "使", "官", "橫"]
const SCS := ["breath", "light", "cold", "sound", "paper", "phone", "face", "shadow"]
const MULTI := ["circle", "self_circle", "cone", "line", "chain"]
const BANNED := ["盂蘭", "盂兰", "超度", "狐狸精", "唐僧", "佛教", "梵語", "判官"]

func _p(m): print("[cdata] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	return _main(t)

func data(t) -> void: await _run(t, false)
func all(t) -> void: await _run(t, true)
func _run(t, flow: bool) -> void:
	var m = await _boot(t)
	abil_check()
	enemy_check()
	counter_check()
	camp_check()
	soften_check()
	text_check()
	if flow: await flow_check(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------------- 標籤推導（同 tools/cdata/build_cdata.py derive() 一致） ----------------
func _prims(a: Dictionary) -> Array:
	var o = []
	var src = [a.act.fx]
	for p in a.get("pas", []): src.append(p.fx)
	if a.get("aura") is Dictionary: src.append(a.aura.fx)
	while src.size():
		var fx = src.pop_front()
		for x in fx:
			o.append(x)
			if str(x.p) == "zone": src.append(x.get("fx", []))
	return o
func _derive(a: Dictionary) -> Array:
	var t = []
	var ps = _prims(a); var ids = {}
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
	var s = [str(a.act.tg.get("sel", "")), str(a.act.tg.get("shape", "single"))]
	var ps = []
	for x in a.act.fx: ps.append(str(x.p))
	ps.sort(); s.append_array(ps)
	var pp = []
	for p in a.get("pas", []):
		var q = []
		for x in p.fx: q.append(str(x.p))
		q.sort(); pp.append(str(p.tr) + ":" + ",".join(q))
	pp.sort(); s.append_array(pp)
	if a.get("aura") is Dictionary:
		var q = []
		for x in a.aura.fx: q.append(str(x.p))
		q.sort(); s.append("aura:" + ",".join(q))
	return "|".join(s)

# ---------------- ABIL ----------------
func abil_check() -> void:
	var D = AB.data()
	_chk("abil.json 讀得到、有 ABIL／ENEMY／TAGS／MECH", D.get("ABIL") is Dictionary and D.get("ENEMY") is Dictionary and D.get("TAGS") is Dictionary and D.get("MECH") is Dictionary)
	var A: Dictionary = {}   # 只校驗 cdata 自己 abil.json 嘅 ABIL（newghost 嘅新鬼 ABIL 行起身先加入，歸 newghost 線）
	var FJ = JSON.parse_string(FileAccess.get_file_as_string("res://data/abil.json"))
	if FJ is Dictionary: A = FJ.get("ABIL", {})
	var GH = {}
	for k in J.G.get("GHOSTS"): if not str(k).begins_with("nw_") and not str(k).begins_with("lg_"): GH[k] = true   # [legion] 八大軍團 ABIL 歸 legion.json（legion_test 校驗）
	var miss = []
	for k in GH: if not A.has(k): miss.append(k)
	for k in ["niutou", "mamian"]: if not A.has(k): miss.append(k)
	_chk("72 隻名鬼（＋阿福）＋牛頭、馬面全部有 ABIL", miss.is_empty() and A.size() >= 75, "缺 %s；共 %d" % [miss, A.size()])
	var badtag = []; var mism = []; var nfx = []; var sys_bad = []; var tagc = {}
	for k in A:
		var a = A[k]
		var tg: Array = a.get("tags", [])
		if tg.size() < 2 or tg.size() > 3: badtag.append("%s:%d" % [k, tg.size()])
		for x in tg:
			if not x in TAGS: badtag.append("%s:%s" % [k, x])
			tagc[x] = int(tagc.get(x, 0)) + 1
		var d = _derive(a)
		var s1 = tg.duplicate(); s1.sort(); d.sort()
		if s1 != d: mism.append("%s %s≠%s" % [k, s1, d])
		if not (a.get("act") is Dictionary) or (a.act.get("fx", []) as Array).is_empty() or str(a.act.get("name", "")) == "": nfx.append(k)
		if not (str(a.get("sys", "")) in SYSS) or (a.get("sc", []) as Array).size() < 1 or not (str(a.sc[0]) in SCS): sys_bad.append(k)
	_chk("每隻 2–3 個應對標籤（10 種之內）", badtag.is_empty(), badtag)
	_chk("標籤同能力積木一致（照推導規則）", mism.is_empty(), mism)
	_chk("每隻有主動技（名＋積木）", nfx.is_empty(), nfx)
	_chk("每隻有系＋嚇法（全部名鬼都有嚇法）", sys_bad.is_empty(), sys_bad)
	var seen = {}; var dup = []
	for k in A:
		var s = _sig(A[k])
		if seen.has(s): dup.append([seen[s], k])
		seen[s] = k
	_chk("冇兩隻能力（主動＋被動積木組合）完全一樣", dup.is_empty(), dup)
	var says = {}; var sdup = []; var sbad = []
	for k in A:
		var y = A[k].get("say", [])
		if not (y is Array) or y.size() < 2 or str(y[0]) == "": sbad.append(k); continue
		if says.has(str(y[0])): sdup.append([says[str(y[0])], k])
		says[str(y[0])] = k
		for w in BANNED: if str(y[0]).contains(w) or str(y[1]).contains(w): sbad.append("%s:%s" % [k, w])
	_chk("每隻有港式粵語台詞＋中文，句句唔同、冇紅線字", sdup.is_empty() and sbad.is_empty(), [sdup, sbad])
	# 每機制 ≥3 隻應對（第一階段 75 隻之中）
	var M: Dictionary = D.MECH
	var weak = []; var info = []
	for m in MECHS:
		if not M.has(m): weak.append(m + ":冇定義"); continue
		var n = 0
		for k in A:
			for x in M[m].get("counter", []):
				if x in A[k].tags: n += 1; break
		info.append("%s%d" % [m, n])
		if n < 8: weak.append("%s:%d" % [m, n])
	_chk("13 種機制每種 ≥8 隻名鬼應對", weak.is_empty(), " ".join(info) + (" 不足:%s" % str(weak) if weak.size() else ""))
	var ti = []
	for x in TAGS: ti.append("%s%d" % [x, int(tagc.get(x, 0))])
	_p("標籤分佈：" + " ".join(ti))
	# 3 隻改名技能
	var rn = A.get("n30_kasaobake", {}).get("act", {}).get("name", "") == "開遮" and A.get("n30_chengsi", {}).get("act", {}).get("name", "") == "再嚟一碟" and A.get("n30_dongsi", {}).get("act", {}).get("name", "") == "披毯"
	_chk("唐傘妖、撐死鬼、凍死鬼 3 個技能改名（開遮、再嚟一碟、披毯）", rn)
	# 遠程
	var rg = 0
	for k in A: if float(A[k].rng) >= 150: rg += 1
	_chk("遠程名鬼 ≥ 12 隻（原本 4 隻）", rg >= 12, rg)

# ---------------- ENEMY ----------------
func enemy_check() -> void:
	var E: Dictionary = AB.data().get("ENEMY", {})
	var ET = J.G.get("ENEMY_T")
	var miss = []; var badm = []; var badf = []
	for k in ET:
		if not E.has(k): miss.append(k); continue
		var e = E[k]
		for m in e.get("mech", []): if not m in MECHS: badm.append("%s:%s" % [k, m])
		var si = CT.sys_info(str(e.get("sys", "")))
		var fe: Array = e.get("fear", []); var im: Array = e.get("imm", [])
		if si.is_empty() or fe.is_empty() or not (si.get("imm") in im): badf.append(k)
		for f in fe: if not f in si.get("fear", []): badf.append(k)
		if fe.size() == 1 and not (e.get("sc", [""])[0] in im): badf.append(k)
		for f in e.get("fear", []): if f in e.get("sc", []): badf.append("%s 怕自己嚇法" % k)
	_chk("現有 ENEMY_T 全部（%d）有 ENEMY 條目" % ET.size(), miss.is_empty(), miss)
	_chk("ENEMY 機制全部屬 13 種", badm.is_empty(), badm)
	_chk("ENEMY 怕／唔怕照 8 系表（取代 hash 隨機；例外嚇法：自己識嘅唔怕）", badf.is_empty(), badf)
	var pc = E.get("pocong", {})
	_chk("Pocong 矛盾修好：唔再怕自己嘅嚇法", not (pc.get("sc", [""])[0] in pc.get("fear", [])), pc)
	_chk("黃總唔可招降、名鬼型可招降", not J.t(E.get("huang", {}).get("recruit")) and J.t(E.get("n30_bunian", {}).get("recruit")))
	var mc = 0
	for k in E: if (E[k].get("mech", []) as Array).size() > 0: mc += 1
	_chk("大部份敵人有機制", mc >= 60, mc)

# ---------------- counter.json ----------------
func counter_check() -> void:
	var D = CT.data()
	_chk("counter.json 讀得到、CT.on()", not D.is_empty() and CT.on())
	var S: Dictionary = D.get("sys", {})
	var fc = {}; var ic = {}; var okf = S.size() == 8
	for s in SYSS:
		var f = S.get(s, {})
		if (f.get("fear", []) as Array).size() != 2 or str(f.get("imm", "")) == "" or str(f.imm) in f.fear: okf = false
		for x in f.get("fear", []): fc[x] = int(fc.get(x, 0)) + 1
		ic[str(f.get("imm", ""))] = int(ic.get(str(f.get("imm", "")), 0)) + 1
	for x in SCS: if int(fc.get(x, 0)) != 2 or int(ic.get(x, 0)) != 1: okf = false
	_chk("8 系表：每系怕 2 唔怕 1；每種嚇法剛好被 2 系怕、1 系唔怕", okf, [fc, ic])
	var k4 = D.get("ch_k", {}).get("4", {}); var k5 = D.get("ch_k", {}).get("5", {})
	_chk("ch_k＝SOFT 步驟 A（第 5 關血 0.70 攻 0.55；第 6 關血 0.65 攻 0.50）", is_equal_approx(float(k4.get("hp", 0)), 0.70) and is_equal_approx(float(k4.get("atk", 0)), 0.55) and is_equal_approx(float(k5.get("hp", 0)), 0.65) and is_equal_approx(float(k5.get("atk", 0)), 0.50))
	var s4 = D.get("sortie_k", {}).get("4", {}); var s5 = D.get("sortie_k", {}).get("5", {})
	_chk("sortie_k＝據點步驟 A（第 5 關 0.70／0.55、第 6 關 0.65／0.50；balance 線統一，據點難度改由 hm／am 校準）", is_equal_approx(float(s4.get("hp", 0)), 0.70) and is_equal_approx(float(s4.get("atk", 0)), 0.55) and is_equal_approx(float(s5.get("hp", 0)), 0.65) and is_equal_approx(float(s5.get("atk", 0)), 0.5))   # [balance]
	var nt = D.get("new", {})
	_chk("新鬼 26 隻有第二階段標籤規格；陰司審批官有「收」；Teke Teke 喺第 5 關", nt.size() == 26 and "收" in nt.get("nw_shenpi", {}).get("tags", []) and int(nt.get("nw_teketeke", {}).get("ch", 0)) == 5)
	# 魂魄來源：每隻可招降鬼最少一個
	var SRC: Dictionary = D.get("src", {}); var A = AB.data().ABIL; var E = AB.data().ENEMY
	var nos = []
	for k in A:
		if k in ["afu", "xiaozhi", "mengpo"] or not J.t(E.get(k, {}).get("recruit")) or str(k).begins_with("lg_"): continue   # [legion] 軍團兵種嘅魂魄來源＝軍團營（legion.json，legion_test 校驗）
		if (SRC.get(k, []) as Array).is_empty(): nos.append(k)
	_chk("每隻可招降名鬼最少一個魂魄來源（據點／野外王／王座重遊）", nos.is_empty(), nos)
	var nop = []
	var keys = []
	for k in A:
		if not (k in ["afu", "xiaozhi", "mengpo"]) and J.t(E.get(k, {}).get("recruit")) and not str(k).begins_with("lg_"): keys.append(k)   # [legion]
	for k in D.get("new", {}): keys.append(k)
	for k in keys:
		var okp = false
		for x in SRC.get(k, []):
			if str(x.get("t", "")) != "camp" or J.t(x.get("guard", false)): okp = true
		if not okp: nop.append(k)
	_chk("每隻可招降鬼（含 26 新鬼）最少一個主魂來源（據點駐守 guard／野外王／王座重遊／階段 2 魔王據點）", nop.is_empty(), nop)
	var g1 = []
	for k in ["n30_banshee", "n30_leipi", "pg_ji"]:
		var gd = false
		for x in SRC.get(k, []): if str(x.get("t", "")) == "camp" and J.t(x.get("guard", false)) and not J.t(x.get("plan", false)): gd = true
		if not gd: g1.append(k)
	_chk("Banshee、雷劈鬼、聻 第一階段有主魂據點（駐守）", g1.is_empty(), g1)
	_chk("陰司審批官（nw_shenpi）有主魂來源；id 統一（冇 nw_panguan／nw_sundel）", (SRC.get("nw_shenpi", []) as Array).size() > 0 and not JSON.stringify(D).contains("nw_panguan") and not JSON.stringify(D).contains("nw_sundel"))
	# 教學節奏：第 1 章 ≤3 種，之後每章新加 ≤2
	var intro: Dictionary = D.get("mech_intro", {}); var per = {}
	for m in intro: per[int(intro[m])] = int(per.get(int(intro[m]), 0)) + 1
	var pace = int(per.get(0, 0)) <= 3
	for c in range(1, 6): if int(per.get(c, 0)) > 2: pace = false
	_chk("機制教學節奏：第 1 章 ≤3 種、之後每章新加 ≤2 種（13 種全部有登場章）", pace and intro.size() == 13, per)
	var G: Dictionary = D.get("gangs", {})
	var ng = 0; var gbad = []
	for c in G:
		for d in G[c]:
			ng += 1
			var g = G[c][d]
			if str(g.get("name", "")) == "" or (g.get("mem", []) as Array).size() < 4 or (g.get("fod", []) as Array).is_empty(): gbad.append("%s%s" % [c, d])
	_chk("24 個鬼幫（每關 W/E/S/N 4 個），每幫有名、≥4 成員、雜兵", ng == 24 and G.size() == 6 and gbad.is_empty(), [ng, gbad])
	var ET = J.G.get("ENEMY_T")
	var sb = []
	for x in D.get("subs", []):
		var now = str(x.get("now", ""))
		var EN = AB.data().get("ENEMY", {}).get(now, {})   # [roster2] integ 嘅 abil.gd 冇 enemy()（parse error），改讀 data()
		if not ET.has(now) or str(EN.get("sys", "")) != str(x.get("sys", "")): sb.append(x.get("plan"))
	_chk("頂替表已撤（新鬼、新雜兵全部用真身出場）", (D.get("subs", []) as Array).is_empty(), D.get("subs"))
	var nwin = {}
	for id in D.get("camps", {}):
		for k in D.camps[id].en: if str(k).begins_with("nw_") or str(k).begins_with("zd_") or str(k).begins_with("bm_"): nwin[k] = true
	_chk("新鬼 26、新雜兵 8、魔王 6 喺據點真身出場（≥36 種）", nwin.size() >= 36 and ET.has("nw_shenpi") and ET.has("zd_hengsi") and ET.has("bm_pang"), nwin.size())
	var names = D.get("names", {})
	_chk("新鬼名照定案：狐妖、Teke Teke、陰司審批官、投胎辦事處職員、紙紮跑車", names.get("nw_huli") == "狐妖" and names.get("nw_teketeke") == "Teke Teke" and names.get("nw_shenpi") == "陰司審批官" and names.get("nw_toutai") == "投胎辦事處職員" and names.get("nw_zzcar") == "紙紮跑車")

# ---------------- 90 據點 ----------------
func camp_check() -> void:
	var D = CT.data(); var C: Dictionary = D.get("camps", {})
	var ET = J.G.get("ENEMY_T"); var A = AB.data().ABIL; var E = AB.data().ENEMY
	var reach_bad = []; var en_bad = []; var guard_bad = []; var named_bad = []; var st_bad = []
	var total = 0
	for c in 6:
		var zs = ZD.sorties(c)
		var sc = {}
		for e0 in SO.camps(c): sc[str(e0.id)] = e0
		for z in zs:
			total += 1
			var id = str(z.id)
			var cp = C.get(id)
			if not (cp is Dictionary): reach_bad.append(id + ":冇組合"); continue
			var rt = z.get("route")
			if int(cp.c) != c or int(cp.ring) != int(z.ring) or str(cp.dir) != str(z.get("dir", "")) or not (rt is Array) or rt.size() < 2: reach_bad.append(id)
			var en: Array = cp.en
			if en.size() != SO.ENEMY_N[clampi(int(cp.ring), 1, 4) - 1] or (cp.hm as Array).size() != en.size(): en_bad.append(id)
			for k in en:
				if not ET.has(k) or not E.has(k): en_bad.append("%s:%s" % [id, k])
				if k in SO.NAMED: named_bad.append("%s:%s" % [id, k])
			var gk = str(cp.get("guard", ""))
			var gi = en.size() - (2 if cp.has("bm") else 1)
			if gk == "" or en.is_empty() or en[gi] != gk or not J.t(E.get(gk, {}).get("recruit")): guard_bad.append("%s:%s" % [id, gk])
			if cp.has("bm") and (str(z.get("boss", "")) != str(cp.bm) or en[en.size() - 1] != str(cp.bm)): guard_bad.append(id + ":魔王")
			var e = sc.get(id, {"id": id, "ring": int(z.ring), "c": c, "lv": 5.0, "pos": Vector2.ZERO})
			var st = SO.stage_of(e)
			if st.get("en") != en or str(st.get("guard", "")) != gk: st_bad.append(id)
	var cap_bad = []
	var intro: Dictionary = D.get("mech_intro", {})
	for id in C:
		var cp = C[id]; var cap = [1, 1, 2, 3][clampi(int(cp.ring), 1, 4) - 1]
		var ms: Array = cp.get("mech", [])
		if ms.size() > cap or (cp.get("q", []) as Array).size() > 2: cap_bad.append("%s:%d" % [id, ms.size()])
		for mm in ms: if int(intro.get(mm, 99)) > int(cp.c) and not cp.has("bm"): cap_bad.append("%s 未教 %s" % [id, mm])
		var mk: Array = cp.get("mk", [])
		if mk.size() != (cp.en as Array).size(): cap_bad.append(id + ":mk")
		else:
			for i in mk.size():
				for mm in mk[i]: if not (mm in ms) or not (mm in E.get(cp.en[i], {}).get("mech", [])): cap_bad.append("%s:%s" % [id, mm])
	_chk("每據點機制硬上限（第 1～2 圈 1、第 3 圈 2、第 4 圈 3）、只用已教機制、每隻 mk 合法、主題 ≤2", cap_bad.is_empty(), cap_bad)
	var dirs_bad = []
	for id in C:
		var z = ZD.sortie(id, int(C[id].c))
		if z.is_empty() or str(z.get("dir", "")) != str(C[id].dir) or J.t(z.get("king", false)) != J.t(C[id].get("king", false)): dirs_bad.append(id)
	_chk("鬼幫方向按 zones.json 真實據點方向（含野外王據點）", dirs_bad.is_empty(), dirs_bad)
	var dupc = {}; var dd = []
	for id in C:
		var srt = (C[id].en as Array).duplicate(); srt.sort()
		var key = "%d:%s" % [int(C[id].c), str(srt)]
		if dupc.has(key): dd.append([dupc[key], id])
		dupc[key] = id
	_chk("同一關冇兩個據點敵人組合完全一樣", dd.is_empty(), dd)
	_chk("zones.json 六關據點共 90＋6 魔王據點", total == 96 and C.size() == 96, [total, C.size()])
	_chk("90 據點全部有組合、圈／方向對得上、有行軍路線（可達）", reach_bad.is_empty(), reach_bad)
	_chk("每據點敵人隻數＝ENEMY_N、全部有圖（ENEMY_T）", en_bad.is_empty(), en_bad)
	_chk("據點唔放主線劇情王（NAMED）", named_bad.is_empty(), named_bad)
	_chk("每據點有駐守鬼（最後一隻／魔王據點係副將、可招降）；魔王據點＝zones.json 嘅 bm", guard_bad.is_empty(), guard_bad)
	_chk("so_data.stage_of 改讀 counter.json（敵人＋駐守鬼）", st_bad.is_empty(), st_bad)
	# 同幫同方向：第 1～4 圈都係同一幫
	var gb = []
	for id in C:
		var cp = C[id]
		if cp.has("bm"): continue
		var g = CT.gang(int(cp.c), str(cp.dir))
		if g.is_empty() or str(g.name) != str(cp.gang): gb.append(id)
	_chk("同一方向第 1～4 圈都係同一個鬼幫", gb.is_empty(), gb)
	# 每關至少用到 ≥8 種唔同敵人（以前每關只得 1～3 種雜兵）
	var vb = []
	for c in 6:
		var kinds = {}
		for id in C: if int(C[id].c) == c: for k in C[id].en: kinds[k] = true
		if kinds.size() < 8: vb.append("%d:%d" % [c + 1, kinds.size()])
	_chk("每關據點敵人 ≥ 8 種（形形色色）", vb.is_empty(), vb)
	# 舊回退：counter 關閉 → 行舊算法
	J.G.S["ct_off"] = true
	var e0 = {"id": "so1_r1_1", "ring": 1, "c": 0, "lv": 1.0, "pos": Vector2.ZERO}
	var old = SO.stage_of(e0)
	J.G.S.erase("ct_off")
	_chk("S.ct_off 一鍵回退舊算法", not old.has("ct") and (old.en as Array).size() == 3)

# ---------------- SOFT 步驟 A ----------------
func _snap() -> Dictionary:
	return {"units": [{"side": 0.0, "hp": 100.0, "maxhp": 100.0, "atk": 10.0}, {"side": 1.0, "hp": 1000.0, "maxhp": 1000.0, "atk": 100.0}]}
func soften_check() -> void:
	var s = _snap(); RTS._soften(s, {"kind": "sortie", "c": 4})
	_chk("據點（sortie）第 5 關打折：血 ×0.70、攻 ×0.55（sortie_k；修據點未打折 bug）", is_equal_approx(s.units[1].hp, 700.0) and is_equal_approx(s.units[1].maxhp, 700.0) and is_equal_approx(s.units[1].atk, 55.0) and is_equal_approx(s.units[0].hp, 100.0), s.units[1])
	s = _snap(); RTS._soften(s, {"kind": "stage", "c": 4})
	_chk("主線第 5 關（步驟 A）：血 ×0.70、攻 ×0.55", is_equal_approx(s.units[1].hp, 700.0) and is_equal_approx(s.units[1].atk, 55.0), s.units[1])
	s = _snap(); RTS._soften(s, {"kind": "stage", "c": 5})
	_chk("主線第 6 關：血 ×0.65、攻 ×0.50", is_equal_approx(s.units[1].hp, 650.0) and is_equal_approx(s.units[1].atk, 50.0), s.units[1])
	s = _snap(); RTS._soften(s, {"kind": "sortie", "c": 2})
	_chk("第 1～4 關唔打折", is_equal_approx(s.units[1].hp, 1000.0) and is_equal_approx(s.units[1].atk, 100.0))
	s = _snap(); RTS._soften(s, {"kind": "raid", "c": 4})
	_chk("襲擾等其他戰鬥唔受影響", is_equal_approx(s.units[1].hp, 1000.0))
	J.G.S["ct_off"] = true
	s = _snap(); RTS._soften(s, {"kind": "stage", "c": 4})
	J.G.S.erase("ct_off")
	_chk("counter 關閉 → 用返舊 SOFT（×0.55）", is_equal_approx(s.units[1].hp, 550.0) and is_equal_approx(s.units[1].atk, 55.0), s.units[1])

# ---------------- 文字修正 ----------------
func _txt(p: String) -> String: return FileAccess.get_file_as_string(p) if FileAccess.file_exists(p) else ""
func text_check() -> void:
	var GH = J.G.get("GHOSTS")
	var y = GH.get("n30_yecha", {}); var b = GH.get("n30_baigujing", {}); var pc = GH.get("pocong", {})
	_chk("夜叉 lore 刪「佛教」「梵語」", not str(y.get("lore", "")).contains("佛教") and not str(y.get("lore", "")).contains("梵語") and str(y.get("lore", "")).contains("鋼叉"), y.get("lore"))
	_chk("白骨精 刪「唐僧」台詞／lore", not str(b.get("say", "")).contains("唐僧") and not str(b.get("lore", "")).contains("唐僧"), [b.get("say"), b.get("lore")])
	_chk("Pocong 稱號、trait 改寫（避葬禮解結）", not str(pc.get("title", "")).contains("舉手") and not str(pc.get("trait", "")).contains("結"), [pc.get("title"), pc.get("trait")])
	var files = []
	for d in ["res://data/", "res://data/nat/", "res://jsgen/", "res://native/", "res://game/counter/"]:
		var da = DirAccess.open(d)
		if da == null: continue
		for f in da.get_files():
			if f.ends_with(".json") or f.ends_with(".gd"): files.append(d + f)
	var hits = []
	for f in files:
		var s = _txt(f)
		for w in ["盂蘭", "盂兰", "超度", "狐狸精", "唐僧"]:
			if s.contains(w): hits.append("%s:%s" % [f.get_file(), w])
	_chk("全遊戲數據／腳本冇「盂蘭」「超度」「狐狸精」「唐僧」（%d 個檔）" % files.size(), hits.is_empty(), hits)

# ---------------- 真出擊（all） ----------------
func flow_check(t, m) -> void:
	var S = J.G.S
	if m != null and m.has_method("_hide_title"): m._hide_title(); await _w(t, 1.0)
	S.res["buns"] = 9000.0; S.res["coins"] = 900000.0
	if (S.get("team", []) as Array).is_empty() and (S.get("ghosts", []) as Array).size() > 0: S["team"] = [S.ghosts[0].id]
	SO.force_open = true; SO.test_now = 5000000.0
	var e = SO.camp("so5_r4_1", 4)
	if e.is_empty(): _chk("找到第 5 關第 4 圈據點 so5_r4_1", false); return
	var st = SO.stage_of(e)
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	_chk("第 5 關第 4 圈據點出擊得", r == "ok" and op != null, r)
	if op == null: SO.force_open = false; return
	var ET = J.G.get("ENEMY_T")
	var foes = []
	for u in op.units: if J.num(u.side) == 1 and not J.t(u.get("minion")): foes.append(u)
	var ks = []
	for u in foes: ks.append(str(u.k))
	_chk("出場敵人＝counter.json 組合", ks == st.en, [ks, st.en])
	var p = float(e.lv); var okhp = true; var info = []
	for i in foes.size():
		var u = foes[i]; var T = ET[str(u.k)]
		var exp = (260.0 + 90.0 * p) * float(T[0]) * float(st.ct.hm[i]) * 0.70 * ((1.25 if (str(st.get("guard", "")) != "" or st.has("ct")) else SO.BOSS_HP) if i == foes.size() - 1 else 1.0)   # [整合] 駐守名鬼頭目 ×1.25（soul 規則），無駐守仍 ×1.6
		var expa = (16.0 + 7.5 * p) * float(T[1]) * float(st.ct.am[i]) * 0.55
		info.append("%s %d/%d %d/%d" % [u.k, int(J.num(u.maxhp)), int(exp), int(J.num(u.atk)), int(expa)])
		if absf(J.num(u.maxhp) - exp) > exp * 0.02 or absf(J.num(u.atk) - expa) > expa * 0.02: okhp = false
	_chk("據點敵人血 ×0.70、攻 ×0.55（第 5 關 sortie_k，balance 步驟 A）、頂替雜兵縮細、頭目血 ×1.25（駐守名鬼）／×1.6", okhp, " ".join(info))
	var last = foes[foes.size() - 1] if foes.size() else {}
	_chk("頭目＝駐守鬼、保留真名", J.t(last.get("boss")) and str(last.get("k")) == st.guard and str(last.get("name", "")).contains(str(ET[st.guard][2])), [last.get("name"), st.guard])
	var mok = true
	for i in foes.size(): if foes[i].get("mech") != st.ct.mk[i]: mok = false
	_chk("每隻敵人寫入據點實際機制 u.mech", mok)
	_chk("op 記住駐守鬼（soul 線讀）", str(op.get_meta("guard", "")) == st.guard)
	RTS.recall(op); RTS.ops.erase(op)
	await _w(t, 0.3)
	for x in SO.camps(4): if int(x.ring) == 4 and str(x.get("bm", "")) == "": SO.cst(x)["first"] = true; SO.cst(x)["clr"] = 0.0
	var eb = SO.camp("so5_r4_4", 4)
	var stb = SO.stage_of(eb)
	var rb = SO.dispatch(eb)
	var opb = RTS.op_for(SO.sid_of(eb))
	_chk("第 5 關魔王據點（Krasue）打得：魔王＋嘍囉＋副將", rb == "ok" and opb != null and str(stb.en[stb.en.size() - 1]) == "bm_krasue", [rb, stb.get("en")])
	if opb != null:
		var bmu = null; var gk2 = ""
		for u in opb.units: if J.num(u.side) == 1 and str(u.k) == "bm_krasue": bmu = u
		_chk("魔王有名牌、頭目旗；副將＝駐守鬼（主魂）", bmu != null and J.t(bmu.get("boss")) and str(opb.get_meta("guard", "")) == str(stb.get("guard")) and str(stb.get("guard")) != "", [bmu.get("name") if bmu else null, stb.get("guard")])
		RTS.recall(opb); RTS.ops.erase(opb)
	SO.force_open = false; SO.test_now = -1.0
