# [ux] 前期節奏（冇 class_name、冇 autoload；熱更新規矩）
# 目標：第一章前期完全安全，之後逐步加壓。鬼潮／告急／村子襲擾都問呢度。
#   階段 0「安頓期」：第 1 張圖、主公 Lv1–3 → 冇鬼潮、冇告急、冇襲擾。
#   階段 1「練手期」：第 1 張圖、主公 Lv4–5 → 鬼潮每 8 分鐘、告急倒數 5 分鐘、襲擾間隔 ×1.8。
#   階段 2「正常」：其他 → 原本數值。
# 功能開關（策劃組之後按章節／任務解鎖用）：S.pace_lock = {"wave": true, "alarm": true, "raid": true, ...}
#   設 true＝鎖住（唔出現）。冇設＝跟上面階段。
extends RefCounted

const P1_LV := 4          # 主公到幾級入練手期
const P2_LV := 6          # 主公到幾級入正常
const NEWBIE_S := 1200.0  # 新手保護（第一張圖在線秒數，原本 600）
const P1 := {"wave_gap": 480.0, "wave_first": 300.0, "alarm_t": 300.0, "raid_mul": 1.8, "raid_first": 360.0}
const P2 := {"wave_gap": 240.0, "wave_first": 180.0, "alarm_t": 180.0, "raid_mul": 1.0, "raid_first": 180.0}

static var force := -1    # 測試用：強制階段

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func ci() -> int:
	var s = S()
	if s != null and s.get("mv") is Dictionary: return int(J.num(s.mv.get("ci", 0)))
	return 0
static func lv() -> int:
	var s = S()
	return int(J.num(s.get("lv", 1))) if s != null else 1

static func phase() -> int:
	if force >= 0: return force
	if ci() > 0: return 2
	var l = lv()
	if l < P1_LV: return 0
	if l < P2_LV: return 1
	return 2
static func locked(k: String) -> bool:
	var s = S()
	if s == null or not (s.get("pace_lock") is Dictionary): return false
	return J.t(s.pace_lock.get(k))
static func _tab() -> Dictionary: return P1 if phase() == 1 else P2

static func wave_on() -> bool: return not locked("wave") and phase() >= 1
static func alarm_on() -> bool: return not locked("alarm") and phase() >= 1
static func raid_on() -> bool: return not locked("raid") and phase() >= 1
static func wave_gap() -> float: return float(_tab().wave_gap)
static func wave_first() -> float: return float(_tab().wave_first)
static func alarm_t() -> float: return float(_tab().alarm_t)
static func raid_mul() -> float: return float(_tab().raid_mul)
static func raid_first() -> float: return float(_tab().raid_first)
static func newbie_s() -> float: return NEWBIE_S
static func label() -> String:
	match phase():
		0: return "安頓期：主公 Lv%d 前沒有鬼潮、告急和襲擾，先把村子打理好" % P1_LV
		1: return "練手期：鬼潮較少（每 %d 分鐘一波），主公 Lv%d 後恢復正常" % [int(P1.wave_gap / 60.0), P2_LV]
	return ""
