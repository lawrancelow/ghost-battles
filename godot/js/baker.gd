# 把冇變化嘅大離屏畫布（例如村子地面一萬幾筆蠟筆紋）拍成貼圖，之後當一張圖畫
class_name Baker
extends RefCounted

static var queue: Array = []
static var host: Node = null

static func request(r: Recorder) -> void:
	if r.baking or r.baked != null: return
	if r.last_ver_seen != r.version: r.last_ver_seen = r.version; r.used_frames = 0; return
	r.used_frames += 1
	if r.used_frames < 3: return   # 連續幾幀都冇變先拍
	r.baking = true
	if host == null: host = J.host
	_bake(r)

static func _bake(r: Recorder) -> void:
	var vp = SubViewport.new()
	var w = clampi(int(r.width), 1, 4096); var h = clampi(int(r.height), 1, 4096)
	vp.size = Vector2i(w, h); vp.transparent_bg = true; vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	var n = Node2D.new()
	var ver = r.version
	n.draw.connect(func(): r.replay(n))
	vp.add_child(n); host.add_child(vp)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	if r.version == ver:
		var img = vp.get_texture().get_image()
		if img: r.baked = ImageTexture.create_from_image(img)
	r.baking = false
	vp.queue_free()
