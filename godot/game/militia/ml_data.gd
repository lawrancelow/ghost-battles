# [militia] 遊魂兵（民兵）＋紙紮兵器檔＋客人需求修正＋野外惡勢力兵力（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const ML = preload("res://game/militia/ml_data.gd")
#   設計稿：/home/claude/docs/militia_design.md。所有可調數值集中喺下面 TUNE／表（測試員試玩後只改呢度）。
#
# 存檔 S.militia（本線擁有；讀一律 .get(key, 預設)）：
#   v:1、n:{"0".."6": 人數}（按兵器級）、join（累計加入）、lost（累計戰死）、story（第一個加入劇情播咗未）
#
# 規則摘要：
#   客人：只要「有供應」嘅貨（已解鎖＋冇停工＋（有貨／做緊／有人做又有料））；冇就退返「料夠手做一轉」；再冇就唔出客。
#         高級客（每張圖最貴 HIGH_TOP 樣貨、或 VIP）按主公等級／關數循序漸進（比例 HS、排隊上限 QH、新貨熟手度 RAMP）。
#   兵器：隨村台 st_bingqi 賣 m_bingqi；賣出嗰級＝兵器檔而家品質星（0–6）；原料按級（TIERS[i].rec）。
#   遊魂兵：買兵器嘅遊魂客（cw_youhun）付錢即加入；上限 CAP0 + CAP_STAR × 兵器檔★；滿咗只收比最弱更好嘅（最弱退休）。
#           只計對外戰鬥（主線關卡、野外王、資源區親自出征／派兵攻佔）；唔守村（襲擾、鬼潮、清剿唔計）。
#   惡勢力：對外戰鬥敵方加「惡鬼嘍囉」小隊，兵力 F = FOE_CURVE(p)；資源區派兵攻佔需要 × RES_MUL[關]。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")
const ZD = preload("res://game/zone/zone_data.gd")

const SID := "st_bingqi"
const GOOD := "m_bingqi"
const CID := "cw_youhun"
const UNLOCK_SID := "st_zhishan"     # 解鎖兵器檔要呢個台……
const UNLOCK_LV := 10                # ……到呢級

# ======================= 可調數值（全部喺度） =======================
const TUNE := {
	# 客人
	"high_top": 3, "hs0": 0.12, "hs_lv": 0.015, "hs_ci": 0.04, "hs_max": 0.45,
	"qh_lv2": 8, "qh_lv3": 15, "ramp_sold": 30.0, "ramp_min": 0.3, "vip_lv": 4, "vip_w": 0.5,
	"q_served": 25.0, "q_max": 5, "q_high_sold": 40.0,
	# 遊魂兵
	"rec_p": 0.2, "cap0": 120, "cap_star": 30, "sq": 25, "sq_max": 6, "hp_k": 0.9, "atk_k": 1.1,
	"cap_loss_share": 1.5, "cap_loss_rate": 0.3,
	# 惡勢力（嘍囉）
	"foe_sq_pow": 60.0, "foe_sq_max": 8, "foe_atk_k": 0.85, "foe_hp_k": 1.0, "lr0": 2.0, "lr_p": 0.8,
}
# 兵器級（＝兵器檔品質星）：名（粵、中）、每人戰力、每件原料、一句
const TIERS := [
	{"n": ["晾衫竹", "晾衣竹竿"], "pw": 0.25, "rec": {"m_bamboo": 1},
		"d": ["曬咗一百年衫嘅竹，打鬼之前記得收衫。", "曬了一百年衣服的竹竿，打鬼之前記得收衣服。"]},
	{"n": ["生鏽柴刀", "生鏽柴刀"], "pw": 0.35, "rec": {"m_wood": 1, "m_strip": 1},
		"d": ["伐木場報銷落嚟，鏽到要兩隻鬼一齊斬。", "伐木場報廢下來的，鏽到要兩隻鬼一起砍。"]},
	{"n": ["紙紮藤牌", "紙紮藤牌"], "pw": 0.45, "rec": {"m_strip": 2, "m_rope": 1},
		"d": ["竹篾織骨、草繩紮邊；擋得住一次，第二次靠信念。", "竹篾編骨、草繩紮邊；擋得住一次，第二次靠信念。"]},
	{"n": ["紙紮盔甲", "紙紮盔甲"], "pw": 0.55, "rec": {"m_paper": 2, "m_strip": 1, "m_rope": 1},
		"d": ["長官話係量身訂造，其實全部均碼。", "長官說是量身訂做，其實全部均碼。"]},
	{"n": ["退役鐵鑊頭盔", "退役鐵鍋頭盔"], "pw": 0.65, "rec": {"m_plank": 2, "m_rope": 1},
		"d": ["大排檔炒咗三十年嘅鑊，戴落去仲有鑊氣。", "大排檔炒了三十年的鍋，戴上去還有鍋氣。"]},
	{"n": ["收數鐵通", "討債鐵管"], "pw": 0.75, "rec": {"m_plank": 3, "m_rope": 2},
		"d": ["前任收數佬嘅遺物，敲一下惡鬼會自動還錢。", "前任討債人的遺物，敲一下惡鬼會自動還錢。"]},
	{"n": ["加班戰甲（附免責聲明）", "加班戰甲（附免責聲明）"], "pw": 0.85, "rec": {"m_paper": 3, "m_strip": 2, "m_plank": 2},
		"d": ["地府集團配發：打爛唔賠，打贏唔加薪。", "地府集團配發：打壞不賠，打贏不加薪。"]},
]
# 敵方兵力曲線：[關卡難度 p, 兵力 F]，中間直線插值；p 以下＝0、以上＝最尾
#   （militia_test balance 兵對兵模擬調過：只靠陰兵第 3 關起輸、陰兵＋預計兵器遊魂兵贏、兵器越好剩血越多）
const FOE_CURVE := [[2.0, 0.0], [3.0, 60.0], [7.0, 180.0], [11.0, 255.0], [15.0, 320.0], [20.0, 360.0], [23.0, 410.0]]
# 資源區「派兵攻佔」需要兵力倍數（按關；第 1 關兵器檔啱啱開，唔加）
const RES_MUL := [1.0, 1.15, 1.25, 1.30, 1.35, 1.40]

static var rng := RandomNumberGenerator.new()
static var off := false            # 測試：關閉本線（行返舊邏輯）
static var LOG: Array = []         # 測試用

# ======================= 共用 =======================
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func zh() -> bool: return DB.lang != "yue"
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(DB.N(str(a[1]) if zh() else str(a[0])))
	return str(a)
static func L(yue: String, zhs: String) -> String: return str(DB.N(zhs if zh() else yue))
static func on() -> bool: return not off

# ======================= 兵器檔 =======================
static func stall_e():
	var s = S()
	if s == null or not (s.get("mv") is Dictionary): return null
	var m = s.mv
	if m.get("st") is Dictionary and m.st.get(SID) is Dictionary: return m.st[SID]
	if m.get("carry_st") is Dictionary and m.carry_st.get(SID) is Dictionary: return m.carry_st[SID]
	return null
static func stall_lv() -> float:
	var e = stall_e()
	return maxf(1.0, J.num(e.get("lv", 1))) if e != null else 1.0
static func stall_open() -> bool:
	var e = stall_e()
	return e != null and J.t(e.get("unlocked"))
static func tier_now() -> int: return clampi(MD.stars(SID, stall_lv()), 0, TIERS.size() - 1)
static func tier_name(t: int) -> String: return T(TIERS[clampi(t, 0, TIERS.size() - 1)].n)
static func tier_desc(t: int) -> String: return T(TIERS[clampi(t, 0, TIERS.size() - 1)].d)
static func plate_name() -> String: return L("兵器・", "兵器・") + tier_name(tier_now())
static func pw(t: int) -> float: return float(TIERS[clampi(t, 0, TIERS.size() - 1)].pw)
# mat.gd recipe() 掛鈎：兵器檔按而家級數用料（n＝1：每件一份）
static func recipe_now() -> Dictionary:
	var t = tier_now()
	return {"in": (TIERS[t].rec as Dictionary).duplicate(), "out": GOOD, "n": 1}
static func recipe_txt(t: int) -> String:
	var a = []
	var r: Dictionary = TIERS[clampi(t, 0, TIERS.size() - 1)].rec
	for k in r: a.append("%s×%d" % [M.name(str(k)), int(r[k])])
	return "＋".join(a)
# mv_idle.gd unlock_req() 掛鈎：要補丁紙衫檔 Lv10
static func unlock_req(sim) -> Array:
	return [sim.lv(UNLOCK_SID) >= UNLOCK_LV and sim.unlocked(UNLOCK_SID), UNLOCK_SID, UNLOCK_LV]

# ======================= 1. 客人：有供應／高級客 =======================
# 供應等級：2＝有（有貨／做緊／有人做又有料）；1＝撳一下就做得（料夠手做）；0＝冇
static func supply(sim, sid: String) -> int:
	if not sim.unlocked(sid) or sim.war.blocked(sim, sid): return 0
	var g = str(MD.st_def(sid).get("good", ""))
	if g == "": return 0
	if sim.counter_n(g) > 0 or sim.pile_n(sid) > 0 or float(sim.mk.get(sid, -1.0)) >= 0.0: return 2
	var ok_mat = sim.missing(sid).is_empty()
	if (sim.nworkers(sid) > 0 or IDL.has_fore(sim, sid)) and ok_mat: return 2
	return 1 if ok_mat else 0
static func supplied(sim) -> Array:   # 而家客人可以要嘅貨
	var act = []; var can = []
	for sid in MD.stations(sim.ci()):
		var g = str(MD.st_def(sid).get("good", ""))
		if g == "" or act.has(g) or can.has(g): continue
		var lv = supply(sim, sid)
		if lv == 2: act.append(g)
		elif lv == 1: can.append(g)
	return act if act.size() else can
# 委託單（mv_event.make_order 掛鈎）：兵器唔入單；其他要有供應（料夠／有貨）
static func order_ok(sim, sid: String) -> bool:
	if not on(): return true
	return sid != SID and supply(sim, sid) > 0
static var _hi := {}
static func high_goods(ci: int) -> Array:   # 每張圖最貴 high_top 樣貨（唔計兵器）
	if _hi.has(ci): return _hi[ci]
	var gs = []
	for sid in MD.stations(ci):
		var g = str(MD.st_def(sid).get("good", ""))
		if g != "" and g != GOOD and not gs.has(g): gs.append(g)
	gs.sort_custom(func(a, b): return float(MD.good_def(a).get("price", 0)) > float(MD.good_def(b).get("price", 0)))
	var o = gs.slice(0, mini(int(TUNE.high_top), gs.size()))
	_hi[ci] = o
	return o
static func lord_lv() -> int:
	var s = S()
	return int(J.num(s.get("lv", 1))) if s != null else 1
static func high_share(ci := -1) -> float:
	if ci < 0: ci = 0
	return clampf(float(TUNE.hs0) + float(TUNE.hs_lv) * lord_lv() + float(TUNE.hs_ci) * ci, float(TUNE.hs0), float(TUNE.hs_max))
static func queue_high_max() -> int:
	var l = lord_lv()
	return 1 + (1 if l >= int(TUNE.qh_lv2) else 0) + (1 if l >= int(TUNE.qh_lv3) else 0)
static func sold(sim, g: String) -> float: return J.num((sim.st().get("sold", {}) as Dictionary).get(g, 0))
static func ramp(sim, g: String) -> float:
	return clampf(float(TUNE.ramp_min) + sold(sim, g) / float(TUNE.ramp_sold), float(TUNE.ramp_min), 1.0)
static func qmax(sim) -> int: return clampi(2 + int(J.num(sim.st().get("served")) / float(TUNE.q_served)), 2, int(TUNE.q_max))
static func q_of(sim, g: String, hi: bool) -> int:
	var m = qmax(sim)
	if hi: m = mini(m, 1 + int(sold(sim, g) / float(TUNE.q_high_sold)))
	return 1 + sim.rng.randi() % maxi(1, m)
static func queue_high(sim) -> int:
	var n = 0
	for c in sim.custs: if c.st != "out" and J.t(c.get("hi")): n += 1
	return n

# mv_sim.spawn_cust() 掛鈎：成個揀客流程（同舊版出嚟嘅客人字典一樣，多 hi／ml 兩個欄）
static func spawn_cust(sim) -> bool:
	var av = supplied(sim)
	if av.is_empty(): LOG.append(["nospawn", "nosupply"]); return false
	var ci = sim.ci()
	# ① 遊魂兵客：兵器有供應＋招得兵
	if av.has(GOOD) and recruit_ok() and sim.rng.randf() < float(TUNE.rec_p):
		return _mk_cust(sim, cust_def_rec(), {GOOD: 1}, false, true)
	av = av.filter(func(x): return x != GOOD)
	if av.is_empty(): return false
	var HG = high_goods(ci)
	var normal = []; var high = []
	for cid in MD.map_def(ci).get("customers", []):
		var cd = MD.cust_def(str(cid)); if cd.is_empty(): continue
		var ok = []
		for g in cd.get("wants", []): if av.has(str(g)) and not ok.has(str(g)): ok.append(str(g))
		if ok.is_empty(): continue
		var vip = J.t(cd.get("vip"))
		var oh = ok.filter(func(x): return HG.has(x)); var ol = ok.filter(func(x): return not HG.has(x))
		if vip:
			if lord_lv() >= int(TUNE.vip_lv): high.append([cd, ok, oh])
			continue
		if ol.size(): normal.append([cd, ol])
		if oh.size(): high.append([cd, ok, oh])
	var allow_hi = high.size() > 0 and queue_high(sim) < queue_high_max()
	var go_hi = allow_hi and (normal.is_empty() or sim.rng.randf() < high_share(ci))
	if not go_hi:
		if normal.is_empty(): LOG.append(["nospawn", "highcap"]); return false
		var pick = normal[sim.rng.randi() % normal.size()]
		pick = sim.war.pick_cust(sim, normal, pick)   # [war] 低影響力：多啲要裝備嘅客
		var ok2: Array = pick[1].duplicate()
		var ng = 2 if ok2.size() >= 2 and sim.rng.randf() < 0.3 else 1
		var wants = {}
		for j in ng:
			var g = ok2[sim.rng.randi() % ok2.size()]; ok2.erase(g)
			wants[g] = q_of(sim, g, false)
		return _mk_cust(sim, pick[0], wants, false, false)
	# 高級客：按熟手度（新貨少啲）＋VIP 權重揀
	var tot = 0.0; var ws = []
	for e in high:
		var w = 0.0
		for g in (e[2] if e[2].size() else e[1]): w = maxf(w, ramp(sim, g))
		if J.t(e[0].get("vip")): w *= float(TUNE.vip_w)
		ws.append(w); tot += w
	var r = sim.rng.randf() * tot; var hp = high[0]
	for i in high.size():
		r -= ws[i]
		if r <= 0.0: hp = high[i]; break
	var hw = {}
	var hg_l: Array = (hp[2] as Array).duplicate() if hp[2].size() else (hp[1] as Array).duplicate()
	var g1 = hg_l[sim.rng.randi() % hg_l.size()]
	hw[g1] = q_of(sim, g1, HG.has(g1))
	var rest: Array = (hp[1] as Array).filter(func(x): return x != g1)
	if rest.size() and sim.rng.randf() < 0.3:
		var g2 = rest[sim.rng.randi() % rest.size()]
		hw[g2] = q_of(sim, g2, HG.has(g2))
	return _mk_cust(sim, hp[0], hw, true, false)
static func cust_def_rec() -> Dictionary:
	var d = MD.cust_def(CID)
	return d if not d.is_empty() else {"id": CID, "art": "youhun", "wants": [GOOD], "vip": false, "lines": []}
static func _mk_cust(sim, cd: Dictionary, wants: Dictionary, hi: bool, rec: bool) -> bool:
	var c = {"cid": str(cd.get("id", "")), "k": str(cd.get("art", "youhun")), "wants": wants, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": sim.QLEN, "pos": MD.poly_at(sim.QP, sim.QLEN), "ph": sim.rng.randf() * 10.0, "flip": true, "lines": cd.get("lines", []), "vip": J.t(cd.get("vip"))}
	if hi: c["hi"] = true
	if rec: c["ml"] = true
	if sim.QP2.size() > 1 and sim.rng.randf() < 0.5:   # [unify] 一半客人由左邊入
		c["side"] = 1; c.s = sim.QLEN2; c.pos = MD.poly_at(sim.QP2, sim.QLEN2); c.flip = false
	sim.custs.append(c)
	if rec: c["tp"] = "none"   # 遊魂兵客：冇脾氣（唔走數、唔打尖）
	else: sim.plus.on_spawn(sim, c)   # [play] 脾氣
	LOG.append(["spawn", c.cid, wants.keys(), hi, rec])
	return true

# ======================= 3. 遊魂兵 =======================
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("militia") is Dictionary): s["militia"] = {}
	var a = s.militia
	if int(J.num(a.get("v", 0))) < 1:
		a["v"] = 1.0
		for k in ["join", "lost"]: if a.get(k) == null: a[k] = 0.0
	if not (a.get("n") is Dictionary): a["n"] = {}
	return a
static func n_of(t: int) -> int:
	var a = st()
	return int(J.num(a.n.get(str(t), 0))) if a != null else 0
static func total() -> int:
	var n = 0
	for t in TIERS.size(): n += n_of(t)
	return n
static func cap() -> int: return int(TUNE.cap0) + int(TUNE.cap_star) * tier_now()
static func weakest() -> int:
	for t in TIERS.size(): if n_of(t) > 0: return t
	return -1
static func recruit_ok() -> bool:
	if not stall_open(): return false
	if total() < cap(): return true
	var w = weakest()
	return w >= 0 and tier_now() > w
static func add(t: int, n := 1) -> void:
	var a = st()
	if a == null: return
	a.n[str(t)] = float(n_of(t) + n)
static func remove(t: int, n: int) -> int:   # 回實際扣咗幾多
	var a = st()
	if a == null: return 0
	var k = mini(n, n_of(t))
	a.n[str(t)] = float(n_of(t) - k)
	if n_of(t) <= 0: a.n.erase(str(t))
	return k
# 由最弱嗰級開始扣 n 個（攻佔折損用）
static func remove_weak(n: int) -> int:
	var left = n
	for t in TIERS.size():
		if left <= 0: break
		left -= remove(t, left)
	return n - left
# 付錢掛鈎（mv_sim._pay）：買咗兵器 → 加入
static func on_paid(sim, c: Dictionary) -> void:
	var n = int(J.num((c.get("got", {}) as Dictionary).get(GOOD, 0)))
	if n <= 0: return
	var t = tier_now()
	var got = 0
	for i in n: if join(t): got += 1
	if got <= 0: return   # 等佢付錢期間滿咗額（又唔好過最弱）：買咗就算，唔入伍
	sim.ev.append({"k": "ml_join", "pos": c.pos + Vector2(0, -70), "t": t, "line": L("遊魂兵 +%d・%s", "遊魂兵 +%d・%s") % [got, tier_name(t)]})
	var a = st()
	if a != null and not J.t(a.get("story")):
		a["story"] = true
		var Sy = J.G.get("Story")
		if Sy != null: J.mc(Sy, "queue", [story_scene()])
static func join(t: int) -> bool:
	var a = st()
	if a == null: return false
	if total() >= cap():
		var w = weakest()
		if w < 0 or w >= t: return false
		remove(w, 1)   # 最弱一個退休，換新
	add(t, 1)
	a["join"] = J.num(a.get("join", 0)) + 1.0
	return true

# 出戰：最好兵器嗰批先，最多 sq × sq_max 人；回 [[級, 人數], …]（好→差）
static func field() -> Array:
	var cap_n = int(TUNE.sq) * int(TUNE.sq_max); var o = []
	var t = TIERS.size() - 1
	while t >= 0 and cap_n > 0:
		var k = mini(n_of(t), cap_n)
		if k > 0: o.append([t, k]); cap_n -= k
		t -= 1
	return o
static func power() -> int:   # 遊魂兵出擊兵力
	if not on(): return 0
	var p = 0.0
	for e in field(): p += float(e[1]) * pw(int(e[0]))
	return int(floor(p))
static func squads() -> Array:   # 戰鬥小隊：[[級, 人數(≤25)], …]，最多 sq_max 隊（只計滿 25 人嘅隊，同陰兵一樣）
	var o = []; var sq = int(TUNE.sq)
	for e in field():
		var k = int(e[1])
		while k >= sq and o.size() < int(TUNE.sq_max): o.append([int(e[0]), sq]); k -= sq
	return o

# ======================= 4. 惡勢力 =======================
static func foe_army(p: float) -> int:
	var C = FOE_CURVE
	if p <= float(C[0][0]): return int(C[0][1])
	for i in range(1, C.size()):
		var a = C[i - 1]; var b = C[i]
		if p <= float(b[0]):
			var k = (p - float(a[0])) / maxf(0.001, float(b[0]) - float(a[0]))
			return int(round(lerpf(float(a[1]), float(b[1]), k)))
	return int(C[C.size() - 1][1])
static func foe_squads(F: int) -> int:
	if F <= 0: return 0
	return clampi(int(ceil(float(F) / float(TUNE.foe_sq_pow))), 1, int(TUNE.foe_sq_max))
static func lr(p: float) -> float: return clampf(float(TUNE.lr0) + float(TUNE.lr_p) * p, 1.0, 20.0)
static func res_mul(c := -1) -> float:
	if c < 0: c = ZD.ci()
	return float(RES_MUL[clampi(c, 0, RES_MUL.size() - 1)])
# 陰兵出擊兵力（同 BK.power 一樣算法）
static func troop_pow() -> int: return int(load("res://game/barracks/bk_data.gd").power())
static func army_pow() -> int: return troop_pow() + power()

# 派兵攻佔折損：[陰兵, 遊魂兵(人)]；總折損兵力 L = 需要 × rate；遊魂兵分擔 min(1, share × 遊魂兵力 ÷ 總兵力)
static func cap_loss(need: int, rate := -1.0) -> Array:
	var Lp = float(need) * (rate if rate >= 0.0 else float(TUNE.cap_loss_rate))
	var mp = float(power()); var tp = float(troop_pow())
	var share = minf(1.0, float(TUNE.cap_loss_share) * mp / maxf(1.0, mp + tp)) if mp > 0.0 else 0.0
	var ml_pow = Lp * share
	# 由最弱兵器開始換算人數
	var heads = 0; var left = ml_pow
	for t in TIERS.size():
		if left <= 0.0: break
		var k = mini(n_of(t), int(ceil(left / pw(t))))
		heads += k; left -= float(k) * pw(t)
	var troop_lp = Lp - ml_pow + maxf(0.0, left)   # 遊魂兵唔夠扣嘅，由陰兵補
	return [int(ceil(troop_lp / ZD.troop_mul())), heads]
static func apply_cap_loss(need: int, rate := -1.0) -> Array:
	var l = cap_loss(need, rate)
	var s = S()
	s.res["troops"] = maxf(0.0, J.num(s.res.get("troops", 0)) - float(l[0]))
	var lost = remove_weak(int(l[1]))
	var a = st()
	if a != null: a["lost"] = J.num(a.get("lost", 0)) + float(lost)
	return [l[0], lost]

# ======================= 戰鬥掛鈎（native/battle.gd） =======================
# 呢場係咪「對外」：主線章節關卡；或者分區出征（S.zone.exp 嘅 sid 同呢場一樣：攻佔資源區／野外王）
static func external(wild) -> bool:
	if not on(): return false
	if not J.t(wild): return true
	var z = ZD.st()
	if z == null or not (z.get("exp") is Dictionary): return false
	return J.str(z.exp.get("sid")) == J.str(wild.get("sid")) if wild is Dictionary else false
# Battle.start 掛鈎：加遊魂兵小隊（我方）＋惡鬼嘍囉小隊（敵方）
static func battle_units(B: Dictionary, stg: Dictionary, wild) -> void:
	B["ml_ext"] = false
	if not external(wild): return
	B["ml_ext"] = true
	var s = S(); var lv = J.num(s.get("lv", 1))
	var sq = squads()
	for i in sq.size():
		var t = int(sq[i][0]); var k = pw(t)
		var hp = (90 + 14 * lv) * k * float(TUNE.hp_k)
		B.units.append({"side": 0.0, "k": "youhun", "name": "遊魂兵", "minion": true, "ml": float(t), "hp": hp, "maxhp": hp, "atk": (9 + 2.2 * lv) * k * float(TUNE.atk_k),
			"range": 38.0, "spd": 52.0, "x": 104.0 - floor(i / 4.0) * 14, "lane": (i % 4) * 0.95 + 0.4, "energy": 0.0, "sk": null, "st": {}, "cd": randf()})
	var p = J.num(stg.get("p", 1)); var F = foe_army(p); var n = foe_squads(F)
	B["ml_foe"] = float(F); B["ml_my"] = float(int(B.get("squads", 0))) * float(TUNE.sq) * ZD.troop_mul() + float(power()); B["ml_sq"] = [float(int(B.get("squads", 0))), float(sq.size()), float(n)]
	if n <= 0: return
	var kk = float(F) / (float(TUNE.sq) * n); var L0 = lr(p)
	var fk = _fodder(stg)
	var ET = J.G.get("ENEMY_T")
	for i in n:
		var hp2 = (90 + 14 * L0) * kk * float(TUNE.foe_hp_k)
		B.units.append({"side": 1.0, "k": fk, "name": "惡鬼嘍囉", "minion": true, "foe_ml": true, "hp": hp2, "maxhp": hp2, "atk": (9 + 2.2 * L0) * kk * float(TUNE.foe_atk_k),
			"range": 38.0, "spd": 46.0, "x": 286.0 - floor(i / 4.0) * 16, "lane": (i % 4) * 0.95 + 0.4, "energy": 0.0, "sk": null, "st": {}, "cd": randf() * 0.6, "boss": false})
	LOG.append(["battle", p, F, n, sq.size()])
static func _fodder(stg: Dictionary) -> String:
	var ET = J.G.get("ENEMY_T")
	var bo = J.str(stg.get("boss", ""))
	for e in J.iter(stg.get("en", [])):
		if J.str(e) != bo and (not (ET is Dictionary) or ET.has(J.str(e))): return J.str(e)
	return "youhun"
# Battle.finish 掛鈎：戰死遊魂兵小隊扣人；回顯示字（冇死就 ""）
static func battle_loss(B: Dictionary) -> String:
	var dead = 0
	for u in J.iter(B.get("units", [])):
		if u is Dictionary and u.get("ml") != null and J.num(u.get("hp", 0)) <= 0:
			dead += remove(int(J.num(u.ml)), int(TUNE.sq))
	if dead > 0:
		var a = st()
		if a != null: a["lost"] = J.num(a.get("lost", 0)) + float(dead)
		return L("遊魂兵戰死 %d", "遊魂兵戰死 %d") % dead
	return ""

# ======================= 5. 遷移／劇情 =======================
static func migrate() -> void:
	if S() == null: return
	st()
const STORY := [
	["遊魂", "惡鬼收咗我三百年保護費，今日我買件嘢，自己保護自己！", "惡鬼收了我三百年保護費，今天我買件傢伙，自己保護自己！"],
	["小紙", "少爺，佢話買完唔走，要跟我哋出去打惡鬼。", "少爺，他說買完不走，要跟我們出去打惡鬼。"],
	["阿福", "唔使訓練？", "不用訓練？"],
	["遊魂", "唔使！死咗咁耐，捱打我最有經驗。", "不用！死了這麼久，挨打我最有經驗。"]]
static func story_scene() -> Dictionary:
	var lines = []; var zhm = {}
	for l in STORY:
		lines.append([l[0], l[1]]); zhm[l[1]] = l[2]
	if J.G.get("LANG") != null: J.mc(J.G.get("LANG"), "add", [zhm])
	if DB.D is Dictionary:
		if not DB.D.has("LANG_ZH"): DB.D["LANG_ZH"] = {}
		DB.D.LANG_ZH.merge(zhm, true)
	return {"style": "talk", "bg": "village", "lines": lines}
