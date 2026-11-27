# [account] 遊戲中自動同步：每 AUTO_SYNC_SEC 秒、切出去（暫停）時，本機有改就上傳
#   雲端被另一部裝置改過（中途開咗第二部機）→ 唔覆蓋，提示返標題畫面再揀
extends Node

const ACC = preload("res://game/account/acct.gd")
const AC = preload("res://game/account/acct_cfg.gd")
var host: Node
var _t := 0.0
var busy := false
static var pending := false   # 有衝突等返標題畫面處理

func _ready() -> void:
	name = "AcctSync"; process_mode = Node.PROCESS_MODE_ALWAYS

func _process(dt: float) -> void:
	_t += dt
	if _t >= AC.AUTO_SYNC_SEC: _t = 0.0; run()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_CLOSE_REQUEST: run()

func _playing() -> bool:
	if host == null or host.get("title_ov") != null: return false
	var g = get_node_or_null("/root/G")
	return g != null and g.get("S") is Dictionary and not (g.get("S") as Dictionary).is_empty()

# 回傳同步狀態（測試用）；只喺有改動先打伺服器，慳免費額度
func run(force := false) -> String:
	if busy or not ACC.logged_in() or (not force and not _playing()): return "skip"
	var loc = ACC.local_data()
	if not force and ACC.data_ts(loc) == ACC.synced_ts: return "nochange"
	busy = true
	var r = await ACC.sync()
	busy = false
	var st = str(r.get("state", ""))
	if st in ["download", "conflict", "conflict_late"]:
		if not pending and host != null and host.has_method("show_toast"):
			host.call("show_toast", "另一部裝置有較新的進度。回到標題畫面時會讓你選用哪一份。")
		pending = true
	return st
