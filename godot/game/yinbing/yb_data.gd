# [yinbing] 陰兵兵種（近戰／中距／遠程／醫療）× 階級（雜兵／士兵／衛兵／親兵）＝16 款（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const YB = preload("res://game/yinbing/yb_data.gd")
#   數據 data/nat/yinbing.json（tools/yinbing_build.py 生成；改數值改 build 腳本）；設計稿 /home/claude/art/out/HC_YinBing_Design.md
#   第一期（phase 1）：只提供查表＋圖鍵（未接戰鬥，未改任何現有行為）；數值倍率要 phase ≥ 2 先生效
extends RefCounted

const PATH := "res://data/nat/yinbing.json"
static var _d = null
static var off := false   # 測試：關閉

static func D() -> Dictionary:
	if _d == null:
		var o = JSON.parse_string(FileAccess.get_file_as_string(PATH)) if FileAccess.file_exists(PATH) else null
		_d = o if o is Dictionary else {}
	return _d
static func on() -> bool: return not off and not D().is_empty()
static func phase() -> int: return int(D().get("phase", 1))
static func stats_on() -> bool: return on() and phase() >= 2

static func ranks() -> Array: return D().get("RANKS", [])
static func classes() -> Array: return D().get("CLASSES", [])
static func cls(id: String) -> Dictionary:
	for c in classes():
		if str(c.id) == id: return c
	return {}
static func rank(id: String) -> Dictionary:
	for r in ranks():
		if str(r.id) == id: return r
	return {}
# 兵器檔★（0–6）→ 階級 id
static func rank_of_star(t: int) -> String:
	for r in ranks():
		if t >= int(r.star[0]) and t <= int(r.star[1]): return str(r.id)
	return "wei"
static func key(c: String, r: String) -> String: return "yb_%s_%s" % [c, r]
static func cell(c: String, r: String) -> Dictionary: return (D().get("CELLS", {}) as Dictionary).get(key(c, r), {})
static func name_of(c: String, r: String) -> String:
	var n = cell(c, r).get("n", [])
	return str(DB.N(str(n[1]) if DB.lang != "yue" else str(n[0]))) if n is Array and n.size() >= 2 else ""
# 圖鍵：有 yb_<兵種>_<階級>_<pose> 就用；冇就退返現版 soldier_<pose>
static func spr_key(c: String, r: String, pose: String) -> String:
	var k = key(c, r) + "_" + pose
	if Spr.ok(k): return k
	return "soldier_" + pose
# 數值倍率（phase 1 一律 1.0，唔郁平衡）
static func mul(c: String, r: String, stat: String) -> float:
	if not stats_on(): return 1.0
	var a = float(cls(c).get(stat, 1.0)) if stat in ["hp", "atk"] else 1.0
	return a * float(rank(r).get("k", 1.0))
static func mix_default() -> Dictionary: return D().get("MIX_DEFAULT", {})
