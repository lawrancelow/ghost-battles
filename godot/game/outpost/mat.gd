# 生產鏈材料庫（共用）：所有線都經呢度攞／加／扣材料。冇 class_name、冇 autoload（熱更新規矩）。
# 用法：const M = preload("res://game/outpost/mat.gd")；M.amt("m_bao")、M.add("m_bao", 3)、M.take({"m_bao": 2})
# 資料：data/nat/chain.json（格式見 /home/claude/ctx/CHAIN_CONTRACT.md）。
# 存放：舊資源（MATS[mid].res 有值，例如 "wood"/"rice"/"planks"/"buns"/"coins"/"troops"）照存 S.res[res]；
#       新材料存 S.mat[mid]。冇定義嘅 mid 一律當新材料（唔報錯）。
extends RefCounted

const PATH := "res://data/nat/chain.json"
static var _D = null

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
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

# 上限：舊資源跟舊倉庫上限由舊代碼管（呢度唔夾）；新材料用 cap()（引擎線可改公式）
static func cap(mid: String) -> float:
	var c = J.num(def(mid).get("cap", 0))
	if c <= 0: c = 999999999.0
	return c

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
