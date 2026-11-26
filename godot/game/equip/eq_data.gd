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
		if J.t(it.get("hero")): continue   # [p44] 主角兵器唔入製作／自動穿戴清單
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
	for k in ["inv", "worn", "made", "ml_pick", "ml_look", "plus"]:   # [補丁43] plus＝紙紮師傅加工等級 {id: 0–10}
		if not (e.get(k) is Dictionary): e[k] = {}
	_hero_default(e)
	return e
# [p44] 主角兵器：男主斧、女主三角尺；主角兵器格空咗（或者着住另一個性別嗰件）就自動裝返
const HERO_WEA := {"m": "eq_hero_axe", "f": "eq_hero_ruler"}
static func hero_wea() -> String: return HERO_WEA["f" if DB.hero_female() else "m"]
static func _hero_default(e: Dictionary) -> void:
	if D().ITEMS.get("eq_hero_axe") == null: return
	var w = e.worn.get("afu")
	var cur = str(w.get("wea", "")) if w is Dictionary else ""
	var want = hero_wea()
	if cur == want or (cur != "" and not HERO_WEA.values().has(cur)): return
	if not (w is Dictionary): w = {}; e.worn["afu"] = w
	if cur != "":   # 換咗性別：舊嗰件收返
		e.inv[cur] = J.num(e.inv.get(cur, 0)) - 1.0
		if J.num(e.inv[cur]) <= 0: e.inv.erase(cur)
	e.inv[want] = J.num(e.inv.get(want, 0)) + 1.0
	w["wea"] = want
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
	if not on() or not (r is Dictionary) or str(item(id).get("var", "A")) == "A": return load("res://game/militia/ml_data.gd").recipe_now()   # A 款＝militia 原表（同一份）
	var o = {}
	for k in r: o[str(k)] = int(J.num(r[k]))   # JSON 數字係 float，轉返 int 同原表一致
	return {"in": o, "out": "m_bingqi", "n": 1}
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
	if not can_craft_src(id): return false   # [補丁43] 名／絕／專屬物：唔喺兵器檔造
	return stall_open() and stall_star() >= int(J.num(it.get("star", 0)))
static func can_craft_src(id: String) -> bool:
	var sr = item(id).get("src", ["make"])
	return not (sr is Array) or (sr as Array).has("make")
static func src_txt(id: String) -> String:   # [補丁43] 唔造得嗰啲：邊度嚟
	var sr = item(id).get("src", ["make"])
	if str(item(id).get("kind")) == "ex": return L("專屬物：打魔王掉落，綁定%s", "專屬物：打魔王掉落，綁定%s") % load("res://game/soul/soul_data.gd").gname(str(item(id).get("owner", "")))
	if sr is Array and sr.has("boss"): return L("絕品：只有打魔王先有機會掉", "絕品：只有打魔王才有機會掉落")
	if sr is Array and sr.has("offer"): return L("名品：回陽間嚇人，陽間人燒落嚟先有", "名品：回陽間嚇人，陽間人燒下來才有")
	return ""
static func lock_txt(id: String) -> String:
	var it = item(id)
	if not can_craft_src(id): return src_txt(id)
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
	for sl in SLOTS + ["ex"]:   # [補丁43] 專屬物格
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
	if not (str(it.get("kind")) in ["eq", "ex"]): return L("唔係名鬼裝備", "不是名鬼裝備")
	if ghost(gid) == null: return L("冇呢隻鬼", "沒有這隻鬼")
	if str(it.get("kind")) == "ex" and str(it.get("owner", "")) != k_of(gid): return L("呢件係%s專屬", "這件是%s專屬") % load("res://game/soul/soul_data.gd").gname(str(it.get("owner", "")))
	if J.t(it.get("hero")) and k_of(gid) != "afu": return L("呢件係主角專用", "這件是主角專用")   # [p44]
	var cur = worn(gid)
	if str(cur.get(str(it.slot), "")) == id: return ""
	if n_free(id) <= 0: return L("倉庫冇剩", "倉庫沒有剩")
	if int(J.num(it.get("grade", 0))) >= 3 and str(it.get("kind")) == "eq":   # 名／絕：每隻最多 1 件（專屬物唔計）
		var mx = int(J.num(D().get("MAX_NAMED", 1)))
		var n = 0
		for sl in cur: if sl != str(it.slot) and sl != "ex" and grade_of(cur[sl]) >= 3: n += 1
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
	var cls = load("res://game/rts/roles.gd").cls_of(k)
	for sl in SLOTS + ["ex"]:
		var id = worn(gid).get(sl, "")
		if id == "": continue
		var it = item(id)
		var stv = item_st(id, cls)   # [補丁43] 加工等級＋職業類別加成
		for s in stv: if o.has(s): o[s] += J.num(stv[s])
		var w = str(it.get("sc", ""))
		if w != "" and sc.has(w):
			o.atk += J.num(D().get("SC_BONUS", 0.08)); (o.sc as Array).append(w)
	for si in set_info(gid):   # [補丁43] 套裝
		for b in si.on:
			var stv2 = b.get("st", {})
			if stv2 is Dictionary: for s in stv2: if o.has(s): o[s] += J.num(stv2[s])
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

# ======================= [補丁43] 類別、加工、套裝、專屬物、一鍵穿戴、掉落 =======================
static func cat_of(id: String) -> String: return str(item(id).get("cat", ""))
static func cat_name(c: String) -> String: return T(D().get("CAT_N", {}).get(c, [c, c]))
static func cat_for_cls(cls: String) -> String: return str(D().get("CAT_OF_CLS", {}).get(cls, ""))
static func cat_match(id: String, cls: String) -> bool: return cat_of(id) != "" and cat_of(id) == cat_for_cls(cls)
static func plus(id: String) -> int:
	var e = st()
	return clampi(int(J.num(e.plus.get(id, 0))), 0, 10) if e != null else 0
static func item_st(id: String, cls := "") -> Dictionary:   # 實際數值：基礎 ×（1＋每級 8%×加工）×（啱類別 1.2）
	var it = item(id); var o = {}
	var stv = it.get("st", {})
	if not (stv is Dictionary): return o
	var per = J.num(D().get("PLUS", {}).get("per", 0.08)) if str(it.get("kind")) != "ex" else 0.0
	var k = 1.0 + per * plus(id)
	if cls != "" and cat_match(id, cls): k *= 1.0 + J.num(D().get("CAT_BONUS", 0.2))
	for s0 in stv: o[s0] = J.num(stv[s0]) * k
	return o
# 加工費用：+1–5 二級料（按類別）＋草繩＋冥幣；+6–10 再加三級料
static func plus_cost(id: String) -> Dictionary:
	var it = item(id); var to = plus(id) + 1
	if str(it.get("kind")) == "ex":
		var X = D().get("EX_PLUS", {})
		var c0 = {}
		for m in X.get("mat", {}): c0[str(m)] = int(J.num(X.mat[m]) * to)
		return {"to": to, "mat": c0, "coins": J.num(X.get("coin", 2000)) * to}
	var P = D().get("PLUS", {}); var c = cat_of(id); var g = grade_of(id)
	var mat = {}
	var m2 = str(P.get("mat2", {}).get(c, "m_paper"))
	mat[m2] = 6 * to * (g + 1)
	mat[str(P.get("rope", "m_rope"))] = 3 * to * (g + 1)
	if to > 5: mat[str(P.get("mat3", {}).get(c, "m_zhishan"))] = 2 * (to - 5) * (g + 1)
	return {"to": to, "mat": mat, "coins": J.num(P.get("coin", 300)) * to * (g + 1)}
static func can_plus(id: String) -> String:   # "" = 得
	if n_inv(id) <= 0: return L("倉庫冇呢件", "倉庫沒有這件")
	if plus(id) >= int(J.num(D().get("PLUS", {}).get("max", 10))): return L("已經加工到頂（+10）", "已經加工到頂（+10）")
	var c = plus_cost(id)
	for m in c.mat: if M.amt(str(m)) < J.num(c.mat[m]): return L("%s唔夠（%d/%d）", "%s不夠（%d/%d）") % [M.name(str(m)), int(M.amt(str(m))), int(c.mat[m])]
	if coins() < J.num(c.coins): return L("冥幣唔夠", "冥幣不夠")
	return ""
static func do_plus(id: String) -> bool:
	if can_plus(id) != "": return false
	var c = plus_cost(id)
	if not M.take(c.mat): return false
	S().res["coins"] = coins() - J.num(c.coins)
	st().plus[id] = float(c.to)
	LOG.append(["plus", id, c.to])
	return true
# 專屬物加工：王牌技每級 +5%，+5、+10 各快 2 秒
static func ex_id(k: String) -> String: return "ex_" + k
static func ex_plus_k(k: String) -> int:
	var id = ex_id(k)
	if item(id).is_empty(): return -1
	var s = S()
	if s == null: return -1
	for g in J.iter(s.get("ghosts", [])):
		if g is Dictionary and J.str(g.get("k")) == k and str(worn(g.get("id")).get("ex", "")) == id: return plus(id)
	return -1   # 冇著
static func ace_fx_scale(k: String) -> Dictionary:   # {x 倍數, cut 秒}
	var xp = ex_plus_k(k)
	if xp < 0: return {"x": 1.0, "cut": 0.0}
	var X = D().get("EX_PLUS", {}); var cut = 0.0
	for tc in X.get("t_cut", []): if xp >= int(J.num(tc[0])): cut += J.num(tc[1])
	return {"x": 1.0 + J.num(X.get("per", 0.05)) * xp, "cut": cut}
# [p45] 軍團 8 王（冇王牌技，專屬物標 act_up）：加工改為升「招牌技」——招牌技 fx 數值 ×ace_fx_scale 倍數；
#   每有 1 秒 cut（+5、+10 各 2 秒）就開場能量 +EX_LG.energy_per_cut_s（10）→ +5 開場 +20、+10 開場 +40
static func ex_act_up(k: String, a: Dictionary) -> void:
	if not J.t(item(ex_id(k)).get("act_up")): return
	var xs = ace_fx_scale(k)
	if ex_plus_k(k) < 0: return   # 冇著
	var en = J.num(xs.cut) * J.num(D().get("EX_LG", {}).get("energy_per_cut_s", 10))
	a["ace_x"] = xs; a["act_up"] = {"x": J.num(xs.x), "en": en}
	if J.num(xs.x) > 1.0 and a.get("act") is Dictionary:
		var ac = (a.act as Dictionary).duplicate(true)
		ac["fx"] = load("res://game/rts/abil.gd").scaled_fx(ac.get("fx") if ac.get("fx") is Array else [], J.num(xs.x)); a["act"] = ac
	if en > 0: (a.pas as Array).append({"tr": "start", "fx": [{"p": "energy", "v": en}], "tg": {"sel": "self"}, "ex_up": true})
# 套裝：[{set, name, n, on:[b2,b3...], b2, b3}]
static func set_info(gid) -> Array:
	var o = []
	var w = worn(gid)
	var cnt = {}
	for sl in SLOTS:
		var id = str(w.get(sl, ""))
		var sk = str(item(id).get("set", "")) if id != "" else ""
		if sk != "": cnt[sk] = int(cnt.get(sk, 0)) + 1
	for sk in cnt:
		var S0 = D().get("SETS", {}).get(sk, {})
		if not (S0 is Dictionary): continue
		var on = []
		if cnt[sk] >= 2 and S0.get("b2") is Dictionary: on.append(S0.b2)
		if cnt[sk] >= 3 and S0.get("b3") is Dictionary: on.append(S0.b3)
		o.append({"set": sk, "name": T(S0.get("n", [sk, sk])), "n": cnt[sk], "on": on, "b2": S0.get("b2", {}), "b3": S0.get("b3", {})})
	return o
static func set_pas(gid) -> Array:
	var o = []
	for si in set_info(gid):
		for b in si.on: for pe in b.get("pas", []): o.append((pe as Dictionary).duplicate(true))
	return o
# 一鍵穿戴：每格揀最啱嘅閒置裝備（按職業睇重乜數值；啱類別、套裝加分）；專屬物自動著
const W_CLS := {"重": {"hp": 1.2, "taken": 2.5, "atk": 0.8}, "輕": {"atk": 1.3, "aspd": 1.2, "spd": 0.6}, "巧": {"energy": 1.3, "heal_in": 1.0, "atk": 0.7, "aspd": 0.8}}
static func score(id: String, cls: String) -> float:
	var w0 = W_CLS.get(cat_for_cls(cls), {})
	var sc = 0.0
	var stv = item_st(id, cls)
	for s0 in stv: sc += absf(J.num(stv[s0])) * J.num(w0.get(s0, 0.5))
	return sc
static func auto_wear(gid) -> int:   # 回換咗幾多格
	if not on() or ghost(gid) == null: return 0
	var k = k_of(gid); var cls = load("res://game/rts/roles.gd").cls_of(k)
	var n = 0
	for sl in SLOTS:
		var cur = str(worn(gid).get(sl, ""))
		var best = cur; var bs = score(cur, cls) if cur != "" else -1.0
		for id in items("eq", sl):
			if id == cur or n_free(id) <= 0 or why_not(gid, id) != "": continue
			var sc0 = score(id, cls)
			if sc0 > bs + 1e-6: bs = sc0; best = id
		if best != cur and best != "" and wear(gid, best): n += 1
	var ex = ex_id(k)
	if not item(ex).is_empty() and n_free(ex) > 0 and str(worn(gid).get("ex", "")) != ex and wear(gid, ex): n += 1
	return n
static func auto_wear_team() -> int:
	var s = S(); var n = 0
	if s == null: return 0
	var ids = []
	for x in J.iter(s.get("team", [])): if J.t(x): ids.append(x)
	if J.t(s.get("adviser")): ids.append(s.adviser)
	for gid in ids: n += auto_wear(gid)
	return n
static func give(id: String, n := 1) -> void:
	var e = st()
	if e == null or item(id).is_empty(): return
	e.inv[id] = J.num(e.inv.get(id, 0)) + n
# 回陽間燒貨：星數越高越有機會燒件名鬼裝備落嚟（精／名；三星先有名）
static func drop_offer(stars: int) -> String:
	if not on() or stars <= 0: return ""
	var Dp = D().get("DROP", {}).get("offer", {})
	var p = J.num((Dp.get("p", [0, 0.15, 0.3, 0.55]) as Array)[clampi(stars, 0, 3)])
	if randf() >= p: return ""
	var g = 3 if stars >= 3 and randf() < J.num(Dp.get("name_p3", 0.35)) else 2
	var pool = []
	for id in D().ITEMS:
		var it = D().ITEMS[id]
		if str(it.get("kind")) == "eq" and int(J.num(it.get("grade", 0))) == g and (it.get("src", []) as Array).has("offer"): pool.append(str(id))
	if pool.is_empty(): return ""
	var id = pool[randi() % pool.size()]
	give(id)
	LOG.append(["drop_offer", id, stars])
	return id
# 魔王：絕品 4%；專屬物首殺必掉一件（俾已收、未有專屬物嘅天生王牌），之後 8%
static func drop_boss(first: bool) -> Array:
	var o = []
	if not on(): return o
	var Db = D().get("DROP", {}).get("boss", {})
	if randf() < J.num(Db.get("jue", 0.04)):
		var pool = []
		for id in D().ITEMS: if int(J.num(D().ITEMS[id].get("grade", 0))) == 4 and str(D().ITEMS[id].get("kind")) == "eq": pool.append(str(id))
		if pool.size():
			var id = pool[randi() % pool.size()]
			give(id); o.append(id)
	if randf() < J.num(Db.get("ex_first" if first else "ex", 0.08)):
		var SD = load("res://game/soul/soul_data.gd"); var U = load("res://game/soul/soul_up.gd")
		var cand = []
		for id in D().ITEMS:
			var it = D().ITEMS[id]
			if str(it.get("kind")) == "ex" and n_inv(str(id)) <= 0 and SD.owned(str(it.get("owner", ""))) and U.born_ace(str(it.get("owner", ""))): cand.append(str(id))
		if cand.size():
			var id2 = cand[randi() % cand.size()]
			give(id2); o.append(id2)
	LOG.append(["drop_boss", o])
	return o

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
	if u.get("gid") != null and J.num(u.get("side", 0)) == 0 and not J.t(u.get("minion")):   # [補丁43] 套裝被動
		for pe in set_pas(u.gid): (a.pas as Array).append(pe)
