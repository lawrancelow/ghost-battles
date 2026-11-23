# [equip] 武器裝備系統：數據＋邏輯（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const EQ = preload("res://game/equip/eq_data.gd")
#   設計稿：/home/claude/docs/equip_design.md；數據 data/nat/equip.json（tools/equip_build.py 生成）
#
# 存檔 S.equip（本線擁有；讀一律 .get(key, 預設)）：
#   {v:1, inv:{id:數量}, worn:{gid:{wea,arm,acc}}, made:{id:累計}, ml_pick:{"級":id}, ml_look:{"級":{id:人數}}}
# 兩類：
#   ml＝民用兵器（紙紮兵器檔賣俾遊魂；級＝兵器檔★；每級 A／B 款，倍率乘積≈1，唔改 militia 平衡）
#   eq＝名鬼可穿戴（兵器／護身／隨身物三格；凡良精名＝兵器檔★0/1/3/5；兵器檔「訂製」入倉）
extends RefCounted

const PATH := "res://data/nat/equip.json"
const SID := "st_bingqi"
const SLOTS := ["wea", "arm", "acc"]
const STATS := ["atk", "hp", "taken", "energy", "aspd", "spd", "heal_in"]
const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")

static var _D = null
static var off := false            # 測試：關閉本線（全部回舊數值）
static var LOG: Array = []

static func D() -> Dictionary:
	if _D == null:
		var o = JSON.parse_string(FileAccess.get_file_as_string(PATH)) if FileAccess.file_exists(PATH) else null
		_D = o if o is Dictionary else {}
		if not (_D.get("ITEMS") is Dictionary): _D["ITEMS"] = {}
	return _D
static func reload() -> void: _D = null; _ml_cache = {}
static func on() -> bool: return not off and not D().ITEMS.is_empty()
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func zh() -> bool: return DB.lang != "yue"
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(DB.N(str(a[1]) if zh() else str(a[0])))
	return str(a)
static func L(yue: String, zhs: String) -> String: return str(DB.N(zhs if zh() else yue))

# ======================= 物品 =======================
static func item(id) -> Dictionary:
	var x = D().ITEMS.get(str(id))
	return x if x is Dictionary else {}
static func name_of(id) -> String: return T(item(id).get("n", [str(id), str(id)]))
static func desc_of(id) -> String: return T(item(id).get("d", ["", ""]))
static func grade_of(id) -> int: return int(J.num(item(id).get("grade", 0)))
static func grade_name(g: int) -> String:
	var a = D().get("GRADE_N", [])
	return T(a[clampi(g, 0, a.size() - 1)]) if a is Array and a.size() else ""
static func grade_col(g: int) -> Color:
	var a = D().get("GRADE_COL", [])
	return Color(str(a[clampi(g, 0, a.size() - 1)])) if a is Array and a.size() else Color.GRAY
static func slot_name(sl: String) -> String: return T(D().get("SLOT_N", {}).get(sl, [sl, sl]))
static func items(kind: String, slot := "") -> Array:   # 按等級、id 排
	var o = []
	for k in D().ITEMS:
		var it = D().ITEMS[k]
		if str(it.get("kind")) != kind: continue
		if slot != "" and str(it.get("slot")) != slot: continue
		o.append(str(k))
	o.sort_custom(func(a, b):
		var ia = item(a); var ib = item(b)
		var ka = int(J.num(ia.get("grade", ia.get("tier", 0)))); var kb = int(J.num(ib.get("grade", ib.get("tier", 0))))
		if ka != kb: return ka < kb
		return str(ia.get("var", "")) + a < str(ib.get("var", "")) + b)
	return o
static func cap(stat: String) -> float: return J.num(D().get("CAP", {}).get(stat, 1.0))

# ======================= 存檔 =======================
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("equip") is Dictionary): s["equip"] = {}
	var e = s.equip
	if int(J.num(e.get("v", 0))) < 1: e["v"] = 1.0
	for k in ["inv", "worn", "made", "ml_pick", "ml_look"]:
		if not (e.get(k) is Dictionary): e[k] = {}
	return e
static func migrate() -> void:
	if S() != null: st(); _clean()
static func _clean() -> void:   # 名鬼已經唔喺度：穿住嘅退返倉
	var e = st(); var s = S()
	if e == null or not (s.get("ghosts") is Array): return
	var ids = {}
	for g in s.ghosts: if g is Dictionary: ids[J.str(g.get("id"))] = true
	for gid in e.worn.keys():
		if not ids.has(str(gid)): e.worn.erase(gid)

# ======================= 兵器檔 =======================
static func stall_e():
	return load("res://game/militia/ml_data.gd").stall_e()
static func stall_star() -> int:
	return load("res://game/militia/ml_data.gd").tier_now()
static func stall_open() -> bool: return load("res://game/militia/ml_data.gd").stall_open()

# ======================= ① 民用兵器 =======================
static var _ml_cache := {}
static func ml_items(t: int) -> Array:   # 呢一級嘅款（A 先）
	if _ml_cache.has(t): return _ml_cache[t]
	var o = []
	for id in items("ml"):
		if int(J.num(item(id).get("tier", -1))) == t: o.append(id)
	o.sort_custom(func(a, b): return str(item(a).get("var")) < str(item(b).get("var")))
	_ml_cache[t] = o
	return o
static func ml_pick(t: int) -> String:   # 今期賣邊款（預設 A）
	var l = ml_items(t)
	if l.is_empty(): return ""
	var e = st()
	var p = str(e.ml_pick.get(str(t), "")) if e != null else ""
	return p if l.has(p) else str(l[0])
static func set_ml_pick(t: int, id: String) -> bool:
	if not ml_items(t).has(id): return false
	var e = st()
	if e == null: return false
	e.ml_pick[str(t)] = id
	return true
static func ml_now() -> String: return ml_pick(stall_star())
static func recipe_now() -> Dictionary:   # mat.gd 掛鈎：兵器檔今期款用料
	var id = ml_now()
	var r = item(id).get("rec")
	if not on() or not (r is Dictionary): return load("res://game/militia/ml_data.gd").recipe_now()
	return {"in": (r as Dictionary).duplicate(), "out": "m_bingqi", "n": 1}
static func ml_join(t: int) -> void:   # ml_data.join 掛鈎：入伍嗰個揸嘅款
	var e = st()
	if e == null: return
	var id = ml_pick(t)
	if id == "": return
	if not (e.ml_look.get(str(t)) is Dictionary): e.ml_look[str(t)] = {}
	var m = e.ml_look[str(t)]
	m[id] = J.num(m.get(id, 0)) + 1.0
static func ml_look(t: int) -> String:   # 呢級最多人揸嘅款（冇記錄＝A）
	var l = ml_items(t)
	if l.is_empty(): return ""
	var e = st(); var best = str(l[0]); var bn = -1.0
	var m = e.ml_look.get(str(t), {}) if e != null else {}
	if m is Dictionary:
		for id in m:
			if l.has(str(id)) and J.num(m[id]) > bn: bn = J.num(m[id]); best = str(id)
	return best

# ======================= ② 名鬼裝備：製作／倉庫 =======================
static func unlocked(id: String) -> bool:
	var it = item(id)
	if str(it.get("kind")) != "eq": return false
	return stall_open() and stall_star() >= int(J.num(it.get("star", 0)))
static func lock_txt(id: String) -> String:
	var it = item(id)
	if not stall_open(): return L("要先開紙紮兵器檔", "要先開紙紮兵器攤")
	return L("兵器檔要 ★%d", "兵器攤要 ★%d") % int(J.num(it.get("star", 0)))
static func coins() -> float:
	var s = S()
	return J.num(s.get("res", {}).get("coins", 0)) if s != null and s.get("res") is Dictionary else 0.0
static func missing(id: String) -> Dictionary:   # 欠乜：{mid: 差幾多, "coins": 差幾多}
	var it = item(id); var o = {}
	var r = it.get("rec", {})
	if r is Dictionary:
		for m in r:
			var need = J.num(r[m]); var have = M.amt(str(m))
			if have < need: o[str(m)] = need - have
	var c = J.num(it.get("coin", 0))
	if coins() < c: o["coins"] = c - coins()
	return o
static func can_make(id: String) -> bool: return on() and unlocked(id) and missing(id).is_empty()
static func make(id: String) -> bool:
	if not can_make(id): return false
	var it = item(id); var s = S(); var e = st()
	var r = it.get("rec", {})
	if r is Dictionary:
		if not M.take(r): return false
	s.res["coins"] = coins() - J.num(it.get("coin", 0))
	e.inv[id] = J.num(e.inv.get(id, 0)) + 1.0
	e.made[id] = J.num(e.made.get(id, 0)) + 1.0
	LOG.append(["make", id])
	return true
static func n_inv(id: String) -> int:
	var e = st()
	return int(J.num(e.inv.get(id, 0))) if e != null else 0
static func n_worn(id: String) -> int:
	var e = st(); var n = 0
	if e == null: return 0
	for gid in e.worn:
		var w = e.worn[gid]
		if w is Dictionary:
			for sl in w: if str(w[sl]) == id: n += 1
	return n
static func n_free(id: String) -> int: return n_inv(id) - n_worn(id)
static func recycle(id: String) -> bool:   # 多出嚟（冇人穿）嘅回收，退 price 冥幣
	if n_free(id) <= 0: return false
	var e = st(); var s = S()
	e.inv[id] = J.num(e.inv.get(id, 0)) - 1.0
	if J.num(e.inv[id]) <= 0: e.inv.erase(id)
	s.res["coins"] = coins() + J.num(item(id).get("price", 0))
	return true

# ======================= ② 名鬼裝備：穿脫 =======================
static func ghost(gid):
	var s = S()
	if s == null or not (s.get("ghosts") is Array): return null
	for g in s.ghosts: if g is Dictionary and J.str(g.get("id")) == J.str(gid): return g
	return null
static func worn(gid) -> Dictionary:   # {slot: id}
	var e = st()
	if e == null: return {}
	var w = e.worn.get(J.str(gid))
	if not (w is Dictionary): return {}
	var o = {}
	for sl in SLOTS:
		var id = str(w.get(sl, ""))
		if id != "" and not item(id).is_empty(): o[sl] = id
	return o
static func worn_of_k(k: String) -> Dictionary:   # 村子廣場用：按 k 搵（名鬼一 k 一隻）
	var s = S()
	if s == null or not (s.get("ghosts") is Array): return {}
	for g in s.ghosts:
		if g is Dictionary and J.str(g.get("k")) == k:
			var w = worn(g.get("id"))
			if w.size(): return w
	return {}
static func why_not(gid, id: String) -> String:   # "" = 穿得
	var it = item(id)
	if str(it.get("kind")) != "eq": return L("唔係名鬼裝備", "不是名鬼裝備")
	if ghost(gid) == null: return L("冇呢隻鬼", "沒有這隻鬼")
	var cur = worn(gid)
	if str(cur.get(str(it.slot), "")) == id: return ""
	if n_free(id) <= 0: return L("倉庫冇剩", "倉庫沒有剩")
	if int(J.num(it.get("grade", 0))) >= 3:
		var mx = int(J.num(D().get("MAX_NAMED", 1)))
		var n = 0
		for sl in cur: if sl != str(it.slot) and grade_of(cur[sl]) >= 3: n += 1
		if n >= mx: return L("名品每隻鬼最多 %d 件", "名品每隻鬼最多 %d 件") % mx
	return ""
static func wear(gid, id: String) -> bool:
	if not on() or why_not(gid, id) != "": return false
	var e = st()
	var k = J.str(gid)
	if not (e.worn.get(k) is Dictionary): e.worn[k] = {}
	e.worn[k][str(item(id).slot)] = id
	LOG.append(["wear", k, id])
	return true
static func unwear(gid, slot: String) -> bool:
	var e = st()
	if e == null: return false
	var w = e.worn.get(J.str(gid))
	if not (w is Dictionary) or not w.has(slot): return false
	w.erase(slot)
	if w.is_empty(): e.worn.erase(J.str(gid))
	return true

# ======================= ② 加成（合計＋封頂） =======================
static func k_of(gid) -> String:
	var g = ghost(gid)
	return J.str(g.get("k")) if g != null else ""
static func _ab(): return load("res://game/rts/abil.gd")
static func own_tags(k: String) -> Array:
	if k == "": return []
	return _ab().tags_of(k)
static func own_scares(k: String) -> Array:
	if k == "": return []
	return _ab().scares_of(k)
static func bonus(gid, k := "") -> Dictionary:   # {atk,hp,taken,energy,aspd,spd,heal_in, sc:[同聲同氣嚇法]}
	var o = {}
	for s in STATS: o[s] = 0.0
	o["sc"] = []
	if not on(): return o
	if k == "": k = k_of(gid)
	var sc = own_scares(k)
	for sl in SLOTS:
		var id = worn(gid).get(sl, "")
		if id == "": continue
		var it = item(id)
		var stv = it.get("st", {})
		if stv is Dictionary:
			for s in stv: if o.has(s): o[s] += J.num(stv[s])
		var w = str(it.get("sc", ""))
		if w != "" and sc.has(w):
			o.atk += J.num(D().get("SC_BONUS", 0.08)); (o.sc as Array).append(w)
	for s in STATS:
		var c = cap(s)
		o[s] = maxf(o[s], c) if c < 0 else minf(o[s], c)
	return o
# 生效嘅裝備標籤：{tag, id, why}（why："" 生效／"own" 本身已有／"full" 本領已滿）
static func tag_info(gid, k := "") -> Dictionary:
	if not on(): return {"tag": "", "id": "", "why": ""}
	if k == "": k = k_of(gid)
	var best = ""; var bg = -1
	var w = worn(gid)
	for sl in SLOTS:   # 同級：兵器→護身→隨身物
		var id = str(w.get(sl, ""))
		if id == "" or str(item(id).get("tag", "")) == "": continue
		if grade_of(id) > bg: bg = grade_of(id); best = id
	if best == "": return {"tag": "", "id": "", "why": ""}
	var t = str(item(best).tag)
	var own = own_tags(k)
	if own.has(t): return {"tag": t, "id": best, "why": "own"}
	if own.size() >= 3: return {"tag": t, "id": best, "why": "full"}
	return {"tag": t, "id": best, "why": ""}
static func tag_of(gid, k := "") -> String:
	var ti = tag_info(gid, k)
	return str(ti.tag) if str(ti.why) == "" else ""

# ======================= 戰鬥掛鈎 =======================
# native/battle.gd start()（militia 掛鈎之後）：名鬼血／攻、遊魂兵 A/B 款倍率＋外觀
static func battle_units(B: Dictionary) -> void:
	if not on(): return
	for u in J.iter(B.get("units", [])):
		if not (u is Dictionary) or J.num(u.get("side", 0)) != 0: continue
		if u.get("ml") != null:
			var t = int(J.num(u.ml)); var id = ml_look(t)
			if id == "": continue
			var it = item(id)
			var hk = J.num(it.get("hp_k", 1.0)); var ak = J.num(it.get("atk_k", 1.0))
			u["hp"] = J.num(u.hp) * hk; u["maxhp"] = J.num(u.maxhp) * hk; u["atk"] = J.num(u.atk) * ak
			u["eq_ml"] = id
			continue
		if J.t(u.get("minion")) or u.get("gid") == null: continue
		var gid = u.gid
		var w = worn(gid)
		if w.is_empty(): continue
		var b = bonus(gid, J.str(u.get("k")))
		u["hp"] = J.num(u.hp) * (1.0 + b.hp); u["maxhp"] = J.num(u.maxhp) * (1.0 + b.hp); u["atk"] = J.num(u.atk) * (1.0 + b.atk)
		u["eq"] = w.duplicate()
		u["eq_b"] = b
		var tg = tag_of(gid, J.str(u.get("k")))
		if tg != "": u["eq_tag"] = tg
		LOG.append(["bu", J.str(gid), b.atk, b.hp, tg])
# game/rts/abil.gd compile() 尾：永久 buff（aspd／spd／taken／heal_in／energy）＋裝備標籤
static func ab_compile(sim, u: Dictionary) -> void:
	if not on() or not (u.get("ab") is Dictionary): return
	var b = u.get("eq_b")
	var a = u.ab
	if b is Dictionary:
		for s in ["aspd", "spd", "taken", "heal_in", "energy"]:
			var v = J.num(b.get(s, 0))
			if absf(v) > 0.0001: (a.bf as Array).append({"p": "eq", "id": "eq_" + s, "stat": s, "v": v, "until": 1e12, "neg": false, "tags": []})
	var tg = str(u.get("eq_tag", ""))
	if tg != "" and not (a.tags as Array).has(tg): (a.tags as Array).append(tg)
