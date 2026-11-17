# 把冇變化嘅大離屏畫布（例如村子地面一萬幾筆蠟筆紋）拍成貼圖，之後當一張圖畫
class_name Baker
extends RefCounted

static var queue: Array = []
static var host: Node = null
static var busy := false   # 同一時間只烘一張，每張之間隔一幀（手機 GPU 讀返 framebuffer 唔好疊埋做）

static func request(r: Recorder) -> void:
	if r.baking or r.baked != null: return
	if G.gfx_bad.has("bake"): return   # 呢部機 SubViewport 拍照會閃退：照重播
	if r.last_ver_seen != r.version: r.last_ver_seen = r.version; r.used_frames = 0; return
	r.used_frames += 1
	if r.used_frames < 3: return   # 連續幾幀都冇變先拍
	r.baking = true
	if host == null: host = J.host
	_bake(r)

static func _bake(r: Recorder) -> void:
	while busy:
		await host.get_tree().process_frame
	if G.gfx_bad.has("bake"): r.baking = false; return
	busy = true
	var vp = SubViewport.new()
	var w = clampi(int(r.width), 1, 4096); var h = clampi(int(r.height), 1, 4096)
	# 閃退記號：烘緊邊個尺寸；烘完還原（中途冇其他記號先還原）
	var prev = G.crumb_now(); var mine = "bake:%dx%d" % [w, h]
	G.crumb(mine)
	if OS.has_environment("GB_BAKELOG"): print("[bake] %dx%d cmds=%d crumb=%s" % [w, h, r.cmds.size(), G.crumb_now()])
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
	if G.crumb_now() == mine: G.crumb(prev)
	await host.get_tree().process_frame   # 隔一幀先烘下一張
	busy = false
