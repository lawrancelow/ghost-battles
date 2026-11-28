# [market M2] M1 接口替身（只供測試；M1 合併後整個檔刪走，測試改用真 M1）
#   M1 俾 M2 讀：J.G.mk_counter_n_fn(street) → 該街櫃台員人數
#   M1 叫 M2：  FUN.patrol_ok(who)／FUN.patrol_handled(who, team_n)（巡邏員處理一件）、FUN.extra_slots(sid, lv)（製作店員位）
extends RefCounted
const FUN = preload("res://game/market/mk_fun.gd")
static var counters := {}    # street → 人數
static var patrols := {}     # street → [鬼 id…]（每街 0–FUN.pat_max()）
static func install() -> void:
	counters = {}; patrols = {}
	J.G["mk_counter_n_fn"] = func(s): return int(counters.get(str(s), 1))
static func remove() -> void:
	J.G.erase("mk_counter_n_fn"); counters = {}; patrols = {}
static func set_counter(street: String, n: int) -> void: counters[street] = n
static func assign_patrol(street: String, who: String) -> bool:   # M1 調派：超過上限就拒絕
	var a: Array = patrols.get(street, [])
	if a.size() >= FUN.pat_max() or a.has(who): return false
	a.append(who); patrols[street] = a; return true
static func staff_cap(sid: String, lv: float) -> int: return 1 + FUN.extra_slots(sid, lv)   # 製作店員位（設計 12.2）
static func incident(street: String) -> Dictionary:   # M1 事件結算：搵一個冇趴低嘅巡邏員處理；冇人＝未處理
	var a: Array = patrols.get(street, [])
	for who in a:
		if FUN.patrol_ok(str(who)):
			var r = FUN.patrol_handled(str(who), a.size()); r["who"] = who; r["handled"] = true
			return r
	return {"handled": false}
