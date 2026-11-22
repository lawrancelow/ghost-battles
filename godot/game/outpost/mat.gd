# 生產鏈材料庫（共用）：所有線都經呢度攞／加／扣材料。冇 class_name、冇 autoload（熱更新規矩）。
# 用法：const M = preload("res://game/outpost/mat.gd")；M.amt("m_bao")、M.add("m_bao", 3)、M.take({"m_bao": 2})
# 資料：data/nat/chain.json（格式見 /home/claude/ctx/CHAIN_CONTRACT.md）。
# 存放：舊資源（MATS[mid].res 有值，例如 "wood"/"rice"/"planks"/"buns"/"coins"/"troops"）照存 S.res[res]；
#       新材料存 S.mat[mid]。冇定義嘅 mid 一律當新材料（唔報錯）。
extends RefCounted

const PATH := "res://data/nat/chain.json"
static var _D = null
static var _path := PATH      # [chain] 測試可以換資料檔（use_file）
static var _IX = null         # [chain] 索引快取：邊個台／建築用乜、出乜

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func use_file(p: String) -> void:   # [chain] 測試用：換資料檔（"" = 返正式檔）
	_path = p if p != "" else PATH
	reload()
static func reload() -> void:
	_IX = null
	var f = FileAccess.open(_path, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {}
	for k in ["MATS", "GATHER", "WORKSHOPS", "RECIPES", "GEAR", "BATTLE_ITEMS", "STRINGS"]:
		if not (_D.get(k) is Dictionary): _D[k] = {}
	for k in ["CARRY"]:
		if not (_D.get(k) is Array): _D[k] = []

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func def(mid: String) -> Dictionary: return D().MATS.get(mid, {})
static func has_def(mid: String) -> bool: return D().MATS.has(mid)
static func res_key(mid: String) -> String: return str(def(mid).get("res", ""))
static func tier(mid: String) -> int: return int(J.num(def(mid).get("tier", 1)))
static func icon(mid: String) -> String: return str(def(mid).get("icon", mid))
static func price(mid: String) -> float: return J.num(def(mid).get("price", 0))
static func name(mid: String) -> String:
	var n = def(mid).get("n")
	if n is Array and n.size() >= 2: return str(n[0]) if DB.lang == "yue" else str(n[1])
	return mid
static func all_ids() -> Array: return D().MATS.keys()
static func ids_of_tier(t: int) -> Array:
	var o = []
	for k in D().MATS: if tier(str(k)) == t: o.append(str(k))
	return o

static func _store(s: Dictionary) -> Dictionary:
	if not (s.get("mat") is Dictionary): s["mat"] = {}
	return s.mat

static func amt(mid: String) -> float:
	var s = S()
	if s == null: return 0.0
	var rk = res_key(mid)
	if rk != "": return J.num((s.get("res", {}) as Dictionary).get(rk, 0)) if s.get("res") is Dictionary else 0.0
	return J.num(_store(s).get(mid, 0))

# 上限：舊資源跟舊倉庫上限由舊代碼管（add 唔夾）；新材料用 cap()：
#   MATS.cap 有填 → 用佢；冇填 → 跟後院倉庫上限 F.cap()（同槐木／糯米一樣）；連 F 都冇（純測試）→ 無限
static func cap(mid: String) -> float:
	var c = J.num(def(mid).get("cap", 0))
	if c > 0: return c
	return wh_cap(mid)
static func wh_cap(mid := "") -> float:   # [chain] 後院倉庫上限（陰兵跟陰兵上限）
	var F = J.G.get("F")
	if F == null: return 999999999.0
	if res_key(mid) == "troops": return J.num(J.mc(F, "troopCap", []))
	var c = J.num(J.mc(F, "cap", []))
	return c if c > 0 else 999999999.0
# [chain] 生產用：連舊資源都夾上限（舊 produce 一樣唔會超過倉庫）；回實際加咗幾多
static func add_capped(mid: String, n: float) -> float:
	if n <= 0: return add(mid, n)
	var room = maxf(0.0, cap(mid) - amt(mid))
	return add(mid, minf(n, room))
static func room(mid: String) -> float: return maxf(0.0, cap(mid) - amt(mid))

static func add(mid: String, n: float) -> float:   # 回實際加咗幾多
	var s = S()
	if s == null or n == 0: return 0.0
	var rk = res_key(mid)
	if rk != "":
		if not (s.get("res") is Dictionary): s["res"] = {}
		var before = J.num(s.res.get(rk, 0))
		s.res[rk] = maxf(0.0, before + n)
		return J.num(s.res[rk]) - before
	var st = _store(s)
	var b = J.num(st.get(mid, 0))
	var v = clampf(b + n, 0.0, maxf(b, cap(mid)))
	st[mid] = v
	return v - b

static func can(cost: Dictionary) -> bool:
	for k in cost:
		if amt(str(k)) < J.num(cost[k]) - 1e-6: return false
	return true
static func take(cost: Dictionary) -> bool:
	if not can(cost): return false
	for k in cost: add(str(k), -J.num(cost[k]))
	return true
static func give(gain: Dictionary) -> void:
	for k in gain: add(str(k), J.num(gain[k]))

# ================= [chain] 生產鏈索引（引擎線） =================
static func recipe(sid: String) -> Dictionary:
	if sid == "st_bingqi": return load("res://game/militia/ml_data.gd").recipe_now()   # [militia] 兵器檔按級數用料
	var r = D().RECIPES.get(sid)
	return r if r is Dictionary else {}
static func rin(sid: String) -> Dictionary:
	var r = recipe(sid).get("in")
	return r if r is Dictionary else {}
static func rout(sid: String) -> String: return str(recipe(sid).get("out", ""))
static func rn(sid: String) -> float: return maxf(1.0, J.num(recipe(sid).get("n", 1)))
static func carry() -> Array:
	var o = []
	for s in D().CARRY: o.append(str(s))
	return o
static func is_gear(mid: String) -> bool: return D().GEAR.has(mid)
static func is_item(mid: String) -> bool: return D().BATTLE_ITEMS.has(mid)
# 後院建築：GATHER＋WORKSHOPS（bid → def，加 kind 欄 "gather"／"shop"）
static func blds() -> Dictionary:
	_ix()
	return _IX.blds
static func bld(bid: String) -> Dictionary: return blds().get(bid, {})
static func bld_of_old(old: String) -> String:   # 舊建築鍵（wood/rice/plank/bun）→ chain bid
	_ix()
	return str(_IX.old.get(old, ""))
static func new_blds() -> Array:   # 拓展建築（唔係舊建築）
	var o = []
	for b in blds():
		if str(blds()[b].get("old", "")) == "": o.append(b)
	return o
static func bout(bid: String) -> Dictionary:   # 建築出乜：{mid: 每次件數}（採集：{out: rate}）
	var d = bld(bid)
	if d.get("kind") == "gather": return {str(d.get("out", "")): J.num(d.get("rate", 0))}
	var o = d.get("out")
	return o if o is Dictionary else {}
static func bin(bid: String) -> Dictionary:
	var o = bld(bid).get("in")
	return o if o is Dictionary else {}
# 邊個做 mid：[{"k":"gather"|"shop"|"st", "id":...}]
static func makers(mid: String) -> Array:
	_ix()
	return _IX.makers.get(mid, [])
# 邊個用 mid 做嘢：移動村台 sid（RECIPES）／後院加工建築 bid
static func users(mid: String) -> Array:
	_ix()
	return _IX.users.get(mid, [])
static func st_users(mid: String) -> Array:
	var o = []
	for u in users(mid): if u.k == "st": o.append(u.id)
	return o
static func _ix() -> void:
	if _IX != null: return
	var d = D(); var ix = {"blds": {}, "old": {}, "makers": {}, "users": {}}
	for k in d.GATHER:
		var e = d.GATHER[k]
		if not (e is Dictionary): continue
		var c = e.duplicate(); c["kind"] = "gather"; ix.blds[str(k)] = c
		if str(e.get("old", "")) != "": ix.old[str(e.old)] = str(k)
		_push(ix.makers, str(e.get("out", "")), {"k": "gather", "id": str(k)})
	for k in d.WORKSHOPS:
		var e = d.WORKSHOPS[k]
		if not (e is Dictionary): continue
		var c = e.duplicate(); c["kind"] = "shop"; ix.blds[str(k)] = c
		if str(e.get("old", "")) != "": ix.old[str(e.old)] = str(k)
		for m in (e.get("out", {}) if e.get("out") is Dictionary else {}): _push(ix.makers, str(m), {"k": "shop", "id": str(k)})
		for m in (e.get("in", {}) if e.get("in") is Dictionary else {}): _push(ix.users, str(m), {"k": "shop", "id": str(k)})
	for sid in d.RECIPES:
		var r = d.RECIPES[sid]
		if not (r is Dictionary): continue
		_push(ix.makers, str(r.get("out", "")), {"k": "st", "id": str(sid)})
		for m in (r.get("in", {}) if r.get("in") is Dictionary else {}): _push(ix.users, str(m), {"k": "st", "id": str(sid)})
	_IX = ix
static func _push(dct: Dictionary, k: String, v: Dictionary) -> void:
	if k == "": return
	if not dct.has(k): dct[k] = []
	dct[k].append(v)
# 數量字：整數就唔要小數
static func qty(v: float) -> String:
	if absf(v) >= 1e4: return load("res://game/outpost/mv_data.gd").fmt(v)   # [polish4] 大數統一縮寫（K／M／B／T，同 HUD）
	if absf(v - round(v)) < 0.001: return str(int(round(v)))
	return ("%.1f" % v)
