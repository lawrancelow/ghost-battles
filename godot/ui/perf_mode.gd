# [perf] 流暢模式（設定頁開關）：
#   1. 村子地圖（地面、建築、角色、霧、暗影）喺內部解像度 0.75 嘅 SubViewport 畫，再放大貼返上畫面（2D 冇 scaling_3d，用 size_2d_override 做）；
#      UI、大排檔 HUD、對白框照舊全解像度，字唔會矇。
#   2. 少霧：村入面飄嘅霧團、亡魂減半。
#   3. 鎖 30 幀（Engine.max_fps）。
#   設定記喺 user://perf_mode.txt（裝置設定，唔跟存檔碼走；重開遊戲記得）。
# 熱更新：冇 class_name；const PM = preload("res://ui/perf_mode.gd")
extends RefCounted

const FILE := "user://perf_mode.txt"
const RES := 0.75
const FPS := 30
static var on := false
static var _loaded := false

static func load_pref() -> void:
	if _loaded: return
	_loaded = true
	on = FileAccess.file_exists(FILE) and FileAccess.get_file_as_string(FILE).strip_edges() == "1"

static func label() -> String:
	return "流暢模式：" + ("開" if on else "關") + "（畫面解像度 0.75、少霧、鎖 30 幀；手機卡就開）"

# m：Main（揾村子畫面）
static func set_on(v: bool, m = null) -> void:
	load_pref()
	on = v
	var f = FileAccess.open(FILE, FileAccess.WRITE)
	if f: f.store_string("1" if v else "0"); f.close()
	var nv = m.get("village") if m != null else null
	if nv != null and is_instance_valid(nv): apply(nv)
	else: Engine.max_fps = FPS if on else _user_fps()

static func lite() -> bool: return on   # 少霧

# [settings] 流暢模式關：用設置入面揀嘅幀率（30／60）
static func _user_fps() -> int:
	var PF = load("res://game/settings/prefs.gd"); PF.load_pref(); return int(PF.fps)

# 村子畫面 _build 尾、切換開關時叫
static func apply(nv) -> void:
	load_pref()
	Engine.max_fps = FPS if on else _user_fps()
	var tr = nv.get_node_or_null("perf_lowres")
	if on and tr == null:
		tr = TextureRect.new(); tr.name = "perf_lowres"
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		var mt = CanvasItemMaterial.new(); mt.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA; tr.material = mt
		var vp = SubViewport.new(); vp.name = "vp"
		vp.transparent_bg = true; vp.disable_3d = true; vp.gui_disable_input = true
		vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		vp.size_2d_override_stretch = true
		tr.add_child(vp)
		var idx = nv.world.get_index()
		nv.add_child(tr); nv.move_child(tr, idx)
		nv.world.reparent(vp, false)
		_size(nv)
		tr.texture = vp.get_texture()
	elif not on and tr != null:
		var vp = tr.get_node("vp")
		var idx = tr.get_index()
		nv.world.reparent(nv, false)
		nv.move_child(nv.world, idx)
		tr.queue_free()
	if nv.has_method("perf_changed"): nv.perf_changed()

# 每格（nv_village._process）：跟畫面大細
static func frame(nv) -> void:
	if not on: return
	_size(nv)

static func _size(nv) -> void:
	var tr = nv.get_node_or_null("perf_lowres")
	if tr == null: return
	var vp: SubViewport = tr.get_node("vp")
	var fs = nv.get_viewport().get_final_transform().get_scale().x
	var lo = Vector2i(maxi(1, int(round(nv.size.x * fs * RES))), maxi(1, int(round(nv.size.y * fs * RES))))
	if vp.size != lo: vp.size = lo
	var ov = Vector2i(maxi(1, int(round(nv.size.x))), maxi(1, int(round(nv.size.y))))
	if vp.size_2d_override != ov: vp.size_2d_override = ov
