# [vfx] 介面上播一次序列幀（升級：融合升品、星級突破、加工、專屬物升王牌技、魔王收服、套裝湊齊）——播完自己消失；唔擋點擊
#   VP.burst("up_fuse") → 喺畫面正中（或者 at）播；用加色混合，純黑底自動透明
extends Control

const VC = preload("res://game/fxkit/vfx_cat.gd")
var key := ""
var t := 0.0
var life := 1.4
var tex: Texture2D
var at := Vector2(-1, -1)
var px := 300.0
var bd: Control = null   # 暗影底（跟住淡出）

static var LOG: Array = []   # 測試用：播過乜
static func burst(k: String, pos := Vector2(-1, -1), size_px := -1.0):
	var E = VC.get_e(k)
	if E == null: return null
	LOG.append(k)
	var root = Engine.get_main_loop().root
	# [vfx 第四批] 放喺最頂嘅 CanvasLayer（110）：彈窗（加工、換裝 60）上面都睇到
	var host = root.get_node_or_null("VfxTop")
	if host == null:
		host = CanvasLayer.new(); host.name = "VfxTop"; host.layer = 110; root.add_child(host)
	var n = load("res://game/fxkit/vfx_play.gd").new()
	n.key = k; n.life = float(E.get("life", 1.4)); n.tex = VC.tex(k); n.at = pos
	var vs = root.get_visible_rect().size
	n.px = size_px if size_px > 0 else minf(vs.x, vs.y) * float(E.get("ui_k", 0.8))   # ui_k：佔畫面闊幾多（魔王收服大型 1.1）
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	n.set_anchors_preset(Control.PRESET_FULL_RECT); n.z_index = 200
	var m = CanvasItemMaterial.new(); m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; n.material = m
	# 底下一塊圓形暗影（正常混合）：淺色紙底上面加色特效先睇得清
	var bd = TextureRect.new(); bd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var gt = GradientTexture2D.new(); gt.fill = GradientTexture2D.FILL_RADIAL; gt.fill_from = Vector2(0.5, 0.5); gt.fill_to = Vector2(1.0, 0.5); gt.width = 128; gt.height = 128
	var gr = Gradient.new(); gr.set_color(0, Color(0.04, 0.03, 0.05, float(E.get("dim", 0.72)))); gr.set_color(1, Color(0.04, 0.03, 0.05, 0.0)); gt.gradient = gr
	bd.texture = gt; bd.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bd.stretch_mode = TextureRect.STRETCH_SCALE
	var c0 = pos if pos.x >= 0 else vs * 0.5; bd.size = Vector2(n.px, n.px) * 1.05; bd.position = c0 - bd.size * 0.5
	bd.modulate.a = 0.0; n.bd = bd; host.add_child(bd)
	host.add_child(n)
	return n

func _process(dt: float) -> void:
	t += dt
	if t >= life:
		if is_instance_valid(bd): bd.queue_free()
		queue_free(); return
	if is_instance_valid(bd):
		var p = t / life; bd.modulate.a = minf(1.0, p / 0.12) * (1.0 if p < 0.7 else (1.0 - p) / 0.3)
	queue_redraw()

func _draw() -> void:
	if tex == null: return
	var g = VC.GRID; var p = t / life
	var fi = mini(g * g - 1, int(p * g * g))
	var cw = tex.get_width() / g; var ch = tex.get_height() / g
	var src = Rect2((fi % g) * cw, (fi / g) * ch, cw, ch)
	var c = at if at.x >= 0 else size * 0.5
	draw_texture_rect_region(tex, Rect2(c - Vector2(px, px) * 0.5, Vector2(px, px)), src)
