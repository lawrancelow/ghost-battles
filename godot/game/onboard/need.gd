# [p56] 缺料指路（通用）：任何「起／升建築、招魂」付唔起，都講清楚缺乜、差幾多、去邊度攞。
# 會議第 0 批（dev_metrics.md 悶點 1、3）：民宅要 60 棺材板但棺材鋪冇人做工，任務條淨係寫「建造民宅」卡 10 分鐘；
# 招魂冥幣唔夠，撳完冇任何提示。
# 冇 class_name（熱更新規矩）：load("res://game/onboard/need.gd") 叫 static func。
# 用法：
#   lack(cost)            → [{k, name, need, have, short}]（只列唔夠嘅）
#   hint(cost)            → 「還差 棺材板 59（棺材鋪沒人做工：派鬼去做，或親手做 4 槐木→2 板）」；夠就 ""
#   up_of(k)              → 上游建築 id（任務條「前往」／指示箭頭用）
#   quest_cost(q)         → 任務（build／bLevel）而家要付嘅費用；唔係建築任務回 {}
#   quest_lack(q)         → {k, up, text}：任務卡喺缺料；冇缺回 {}
extends RefCounted

const UP := {"planks": "plank", "bao": "bun", "wood": "wood", "rice": "rice", "coins": "furnace", "troops": "home"}

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func yue() -> bool: return DB.lang == "yue"
static func T(y: String, z: String) -> String: return DB.N(y if yue() else z)
static func NG(): return load("res://native/game.gd")

static func rname(k: String) -> String:
	if k == "bao": return T("普通包子", "普通包子")
	var RN = J.G.get("RES_NAMES")
	return str(RN.get(k, k)) if RN is Dictionary else k

static func lack(cost) -> Array:
	var o = []
	if not (cost is Dictionary): return o
	for k in cost.keys():
		var need = J.num(cost[k]); var have = NG().res_amt(k)
		if need > 0 and have < need - 1e-6:
			o.append({"k": str(k), "name": rname(str(k)), "need": need, "have": have, "short": ceil(need - have)})
	return o

static func up_of(k: String) -> String: return str(UP.get(k, ""))

static func _workers(bid: String) -> int:
	var f = J.G.get("workersAt")
	if f == null: return -1
	return J.iter(J.cl(f, null, [bid])).size()

static func _bld_lv(bid: String) -> float:
	var s = S()
	if s == null or not (s.get("bld") is Dictionary): return 0.0
	return J.num(s.bld.get(bid, 0))

static func _mv_open() -> bool:
	var s = S()
	return s != null and J.t(s.get("mv_on")) and load("res://game/zone/zone_data.gd").on() and load("res://game/zone/zone_data.gd").revealed("market")

# 去邊度攞（每種資源一句）
static func how(k: String) -> String:
	match k:
		"planks":
			if _bld_lv("plank") <= 0: return T("先起棺材鋪（槐木做板）", "先建棺材鋪（用槐木做板）")
			if _workers("plank") == 0: return T("棺材鋪冇人做工：派鬼去做，或親手做 4 槐木→2 板", "棺材鋪沒人做工：派鬼去做，或親手做 4 槐木→2 板")
			return T("棺材鋪做緊，可以升級棺材鋪或者多派鬼", "棺材鋪正在做，可以升級棺材鋪或多派鬼")
		"bao":
			if _bld_lv("bun") <= 0: return T("先起包子鋪（糯米包包子）", "先建包子鋪（用糯米包包子）")
			if _workers("bun") == 0: return T("包子鋪冇人做工：派鬼去做，或親手包 4 糯米→2 包", "包子鋪沒人做工：派鬼去做，或親手包 4 糯米→2 包")
			return T("包子鋪做緊，可以升級包子鋪或者多派鬼", "包子鋪正在做，可以升級包子鋪或多派鬼")
		"wood": return T("去砍樹，或者派鬼去伐木場", "去砍樹，或派鬼去伐木場")
		"rice": return T("去割稻，或者派鬼去糯米田", "去割稻，或派鬼去糯米田")
		"coins":
			if _mv_open(): return T("大排檔賣貨，或者化寶爐收陽間包裹", "大排檔賣貨，或化寶爐收陽間包裹")
			return T("化寶爐收陽間包裹、開箱、完成任務", "化寶爐收陽間包裹、開箱、完成任務")
		"buns": return T("大排檔嘆氣蒸籠出壽包", "大排檔嘆氣蒸籠出壽包")
		"troops": return T("民宅住多啲遊魂，會自願當陰兵", "民宅越大，遊魂越多自願當陰兵")
	return ""

static func hint(cost) -> String:
	var ls = lack(cost)
	if ls.is_empty(): return ""
	var parts = []
	for x in ls:
		var h = how(x.k)
		parts.append(("%s %d" % [x.name, int(x.short)]) + (("（%s）" % h) if h != "" else ""))
	return T("還差 ", "還差 ") + "，".join(parts)

# ---------------- 任務 ----------------
static func quest_cost(q) -> Dictionary:
	if not (q is Dictionary): return {}
	var t = str(q.get("t", "")); var b = str(q.get("b", ""))
	if not (t in ["build", "bLevel"]) or b == "": return {}
	var BLD = J.G.get("BUILDINGS")
	if not (BLD is Dictionary) or not BLD.has(b): return {}
	var lv = _bld_lv(b)
	if t == "build" and lv >= 1: return {}
	if lv <= 0:
		var c = BLD[b].get("build")
		return c if c is Dictionary else {}
	if t == "bLevel" and lv >= J.num(q.get("n", 1)): return {}
	var F = J.G.get("F")
	if F == null: return {}
	if lv >= J.num(J.mc(F, "bldMax", [b])): return {}   # 受鬼宅等級限：交返原本指引
	var c2 = J.mc(F, "upCost", [b, lv])
	return c2 if c2 is Dictionary else {}

static func quest_lack(q) -> Dictionary:
	var c = quest_cost(q)
	if c.is_empty(): return {}
	var ls = lack(c)
	if ls.is_empty(): return {}
	var k = str(ls[0].k)
	for x in ls:   # 優先指向「有建築可以做」嘅（板／包），冥幣排後
		if UP.has(str(x.k)) and str(x.k) != "coins": k = str(x.k); break
	return {"k": k, "up": up_of(k), "text": hint(c)}

# 招魂失敗原因（招魂台）
static func recruit_why() -> String:
	var F = J.G.get("F")
	if F == null: return ""
	var fc = J.num(J.cl(J.G.get("fodderCount"), null, [])) if J.G.get("fodderCount") != null else 0.0
	if fc >= J.num(J.mc(F, "rosterCap", [])): return T("雜鬼名額滿咗：升級民宅加名額", "雜鬼名額已滿：升級民宅增加名額")
	var h = hint(J.mc(F, "recruitCost", []))
	return h

# 起／升建築失敗原因
static func bld_why(id: String, act: String) -> String:
	var F = J.G.get("F"); var BLD = J.G.get("BUILDINGS")
	if F == null or not (BLD is Dictionary) or not BLD.has(id): return ""
	if act == "build": return hint(BLD[id].get("build"))
	if act == "up":
		var lv = _bld_lv(id)
		if lv >= J.num(J.mc(F, "bldMax", [id])): return T("等級到頂：先升級鬼宅", "已達上限：先升級鬼宅")
		return hint(J.mc(F, "upCost", [id, lv]))
	return ""

# ---------------- 拓展建築（新材料 mid）----------------
static func chain_hint(cost: Dictionary) -> String:
	var M = load("res://game/outpost/mat.gd"); var CB = load("res://game/outpost/chain_bld.gd")
	var parts = []
	for k in cost.keys():
		var kk = str(k); var need = J.num(cost[k])
		var have = J.num(M.amt(kk)) if M.has_def(kk) else NG().res_amt(kk)
		if have >= need - 1e-6: continue
		var nm = str(M.name(kk)) if M.has_def(kk) else rname(kk)
		var h = ""
		if M.has_def(kk):
			for mk in M.makers(kk):
				var mid = str(mk.get("id", ""))
				if mid != "" and str(mk.get("k", "")) != "st": h = T("去%s派鬼做", "去%s派鬼做") % str(CB.bname(mid)); break
			if h == "" and str(kk) == "m_plank": h = how("planks")
			if h == "" and str(kk) == "m_bao": h = how("bao")
		else: h = how(kk)
		parts.append("%s %d" % [nm, int(ceil(need - have))] + (("（%s）" % h) if h != "" else ""))
	return "" if parts.is_empty() else T("還差 ", "還差 ") + "，".join(parts)

# 任務條短句：「（缺棺材板 59→棺材鋪）」
static func quest_short(q) -> String:
	var nl = quest_lack(q)
	if nl.is_empty(): return ""
	var BLD = J.G.get("BUILDINGS"); var up = str(nl.up)
	var ls = lack(quest_cost(q)); var sh = 0
	for x in ls: if str(x.k) == str(nl.k): sh = int(x.short)
	var where = str(BLD[up].get("name", "")) if BLD is Dictionary and BLD.has(up) else ""
	return T("（缺%s %d%s）", "（缺%s %d%s）") % [rname(str(nl.k)), sh, ("→" + where) if where != "" else ""]

# 出提示（同一句 2.5 秒內唔重複，撳多幾下唔會洗版）
static var _last_t := ""
static var _last_ms := -100000
static func say(t: String) -> void:
	if t == "": return
	J.G["_p56_last_why"] = t
	var now = Time.get_ticks_msec()
	if t == _last_t and now - _last_ms < 2500: return
	_last_t = t; _last_ms = now
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, "toast", [t])
