# [cdata] 最小 stub：abcore 線未合併前，俾 cdata 測試同其他線讀 data/abil.json 用。整合時以 abcore 版本為準（直接覆蓋本檔）。
#   const AB = preload("res://game/rts/abil.gd")
extends RefCounted

static var D = null
static func data() -> Dictionary:
	if D == null:
		D = {}
		var f = FileAccess.open("res://data/abil.json", FileAccess.READ)
		if f:
			var j = JSON.parse_string(f.get_as_text())
			if j is Dictionary: D = j
	return D
static func on() -> bool:
	var s = J.G.get("S")
	return not data().is_empty() and not (s is Dictionary and J.t(s.get("ab_off", false)))
static func abil(k) -> Dictionary:
	var a = data().get("ABIL", {}).get(str(k))
	return a if a is Dictionary else {}
static func enemy(k) -> Dictionary:
	var e = data().get("ENEMY", {}).get(str(k))
	return e if e is Dictionary else {}
static func mechs_of(k) -> Array: return enemy(k).get("mech", [])
static func tags_of(k) -> Array: return abil(k).get("tags", [])
static func counters_of(k) -> Array:   # 呢隻敵人嘅機制要乜標籤應對
	var o = []
	var M = data().get("MECH", {})
	for m in mechs_of(k):
		for t in M.get(m, {}).get("counter", []):
			if not t in o: o.append(t)
	return o
static func describe(k) -> String:
	var a = abil(k)
	if a.is_empty(): return ""
	var act = a.get("act", {})
	return "%s（%s）" % [str(act.get("name", "")), "、".join(PackedStringArray(tags_of(k)))]
