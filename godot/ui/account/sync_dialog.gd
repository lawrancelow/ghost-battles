# [account] 進度衝突對話框：雲端同這部裝置都有進度又唔一樣 → 玩家揀用邊份（冇揀嗰份留備份）
#   info：ACC.sync() 回傳（local／cloud 摘要、data、rev）
extends Control

const ACC = preload("res://game/account/acct.gd")
var info: Dictionary = {}
var on_done: Callable = Callable()   # 參數："cloud"／"local"
var _win: PanelContainer
var busy := false
var btn_cloud: Button
var btn_local: Button
var _msg: Label
var _desc: Label

func _ready() -> void:
	name = "SyncDialog"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP; z_index = 70
	var dim = ColorRect.new(); dim.color = Color(0.02, 0.01, 0.03, 0.78); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(dim)
	_win = PanelContainer.new(); _win.name = "Win"
	var ps = UIKit.sb(Color("#f1e3bd"), 14, Color("#6b4a2b"), 3, Vector4(20, 18, 20, 20)); ps.shadow_color = Color(0, 0, 0, 0.6); ps.shadow_size = 18
	_win.add_theme_stylebox_override("panel", ps); add_child(_win)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 12); _win.add_child(vb)
	var t = UIKit.label("有兩份不同的進度", 23, Color("#2b1d12"), "serif", 900); t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(t)
	_desc = UIKit.label("帳號雲端和這部裝置的進度不一樣。選一份繼續玩，另一份會自動留一份備份。", 14, Color("#6e5838")); _desc.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; vb.add_child(_desc)
	var cards = HBoxContainer.new(); cards.add_theme_constant_override("separation", 10); vb.add_child(cards)
	var c1 = _card("雲端進度", info.get("cloud", {})); cards.add_child(c1)
	var c2 = _card("這部裝置", info.get("local", {})); cards.add_child(c2)
	btn_cloud = c1.get_meta("btn"); btn_local = c2.get_meta("btn")
	btn_cloud.name = "UseCloud"; btn_local.name = "UseLocal"
	btn_cloud.pressed.connect(_use_cloud); btn_local.pressed.connect(_use_local)
	_msg = UIKit.label("", 14, Color("#9a2a1e"), "sans", 700); _msg.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; _msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(_msg)
	resized.connect(_fit); _fit(); call_deferred("_fit")

func _fit() -> void:
	var ww = minf(560.0, size.x - 24)
	_win.anchor_left = 0.5; _win.anchor_right = 0.5; _win.anchor_top = 0.5; _win.anchor_bottom = 0.5
	_win.offset_left = -ww / 2; _win.offset_right = ww / 2
	# 自動換行嘅字：先俾返實際闊度，否則最小高度會當一個字一行咁計（對話框高到出畫面）
	for l in [_desc, _msg]:
		if l: l.custom_minimum_size.x = ww - 44
	var ch = _win.get_combined_minimum_size().y
	_win.offset_top = -ch / 2; _win.offset_bottom = ch / 2

static func _when(ms: int) -> String:
	if ms <= 0: return "—"
	var t = Time.get_datetime_dict_from_unix_time(ms / 1000 + 8 * 3600)
	return "%d/%d %02d:%02d" % [t.month, t.day, t.hour, t.minute]

func _card(title: String, s: Dictionary) -> PanelContainer:
	var pc = PanelContainer.new(); pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pc.add_theme_stylebox_override("panel", UIKit.sb(Color("#fbf3dc"), 10, Color("#b89a52"), 2, Vector4(12, 12, 12, 12)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 6); pc.add_child(vb)
	var h = UIKit.label(title, 17, Color("#8a3a1e"), "serif", 900); h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(h)
	var lv = UIKit.label("主公 %d 級" % int(s.get("lv", 0)), 22, Color("#2b1d12"), "sans", 900); lv.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(lv)
	for line in ["主角：" + (str(s.get("name", "")) if str(s.get("name", "")) != "" else "—"), "名鬼：%d 隻" % int(s.get("ghosts", 0)), "最後遊玩：" + _when(int(s.get("ts", 0)))]:
		var l = UIKit.label(line, 14, Color("#6e5838")); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(l)
	var b = UIKit.btn("用這份", "gold"); b.custom_minimum_size.y = 48; b.add_theme_font_size_override("font_size", 17); b.focus_mode = Control.FOCUS_NONE; vb.add_child(b)
	pc.set_meta("btn", b)
	return pc

func _use_cloud() -> void:
	if busy: return
	busy = true
	if on_done.is_valid(): on_done.call("cloud")
	ACC.apply_cloud(str(info.get("data", "")), int(info.get("rev", 0)))   # 本機舊進度留 _bak，重新載入

func _use_local() -> void:
	if busy: return
	busy = true; _msg.add_theme_color_override("font_color", Color("#6e5838")); _msg.text = "上傳中…"
	var ls = ACC._ls()
	if ls is Dictionary: ls[ACC.SAVE_KEY + "_cloudbak"] = str(info.get("data", "")); ACC._flush()   # 雲端嗰份留備份
	var r = await ACC.keep_local()
	busy = false
	if str(r.get("state", "")) != "uploaded":
		_msg.add_theme_color_override("font_color", Color("#9a2a1e"))
		_msg.text = ACC.msg(str(r.get("state", ""))) + "（之後連上網會再問你）"
		if str(r.get("state", "")) != "offline": return
	var cb = on_done
	queue_free()
	if cb.is_valid(): cb.call("local")
