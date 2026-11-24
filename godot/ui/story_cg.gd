# [cg] 劇情插圖卡：特殊報導／情節播放時，喺畫面上半部顯示一張插圖（淡入＋慢慢推近）
#   數據（寫喺 SCENES 某場）：
#     "cg": {"<行號>": spec}   由第幾行開始換圖（之後一直顯示，直到下一個 spec；spec 係 "" 就收起）
#     或者行本身第三個元素：["旁白", "……", spec]
#   spec："cg7_box" 或 {"k": "cg7_box", "over": [{"spr": "afu", "x": 0.2, "y": 0.95, "h": 0.55, "flip": false}],
#                       "txt": [{"t": "…", "x": 0.5, "y": 0.2, "s": 22, "c": "#3a2a1a"}]}
#     over＝喺插圖上疊遊戲現有立繪（老闆原創角色唔交 AI 重畫，一律用程式疊）；x、y 係腳底位置（0–1），h 係高度（插圖高度的比例）
#     txt＝喺插圖上疊文字（插圖本身冇字）
#   插圖冇入 manifest（未批／未到）就自動唔顯示，劇情照播。
# 熱更新：冇 class_name；story.gd 用 preload
extends Control

var frame: Panel
var pic: TextureRect
var layer: Control
var cur_key := ""
var _t := 0.0
var _anim := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anchor_left = 0.0; anchor_right = 1.0; anchor_top = 0.0; anchor_bottom = 0.0
	offset_left = 10; offset_right = -10; offset_top = 56
	frame = Panel.new(); frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb = StyleBoxFlat.new(); sb.bg_color = Color(0.06, 0.05, 0.06, 1); sb.border_color = Color("#c9a46a"); sb.set_border_width_all(3)
	sb.set_corner_radius_all(6); sb.shadow_color = Color(0, 0, 0, 0.6); sb.shadow_size = 14
	frame.add_theme_stylebox_override("panel", sb); frame.clip_contents = true
	add_child(frame)
	pic = TextureRect.new(); pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	frame.add_child(pic)
	layer = Control.new(); layer.mouse_filter = Control.MOUSE_FILTER_IGNORE; frame.add_child(layer)
	visible = false

static func spec_of(sc: Dictionary, li: int, line: Array):
	if line.size() >= 3 and (line[2] is String or line[2] is Dictionary): return line[2]
	var m = sc.get("cg")
	if m is Dictionary and m.has(str(li)): return m[str(li)]
	return null

func show_spec(spec) -> void:
	if spec == null: return
	var d: Dictionary = spec if spec is Dictionary else {"k": str(spec)}
	var k = str(d.get("k", ""))
	if k == "" or not Spr.ok(k):
		visible = false; cur_key = ""; return
	var tex: Texture2D = Spr.get_tex(k)
	if tex == null: visible = false; return
	cur_key = k
	var W = maxf(200.0, get_parent().size.x - 20.0)
	var H = W * float(tex.get_height()) / float(tex.get_width())
	H = minf(H, get_parent().size.y * 0.46)
	size = Vector2(W, H); custom_minimum_size = size
	frame.position = Vector2.ZERO; frame.size = size
	var B = 4.0   # 金框闊度：圖縮入框內
	pic.texture = tex; pic.position = Vector2(B, B); pic.size = size - Vector2(B, B) * 2; pic.pivot_offset = pic.size / 2
	layer.position = Vector2(B, B); layer.size = size - Vector2(B, B) * 2
	W = layer.size.x; H = layer.size.y
	for c in layer.get_children(): c.queue_free()
	for o in d.get("over", []):
		if not (o is Dictionary): continue
		var sk = str(o.get("spr", ""))
		var st: Texture2D = Spr.get_tex(Art.spr_key(sk)) if Spr.ok(Art.spr_key(sk)) else (Spr.get_tex(sk) if Spr.ok(sk) else null)
		if st == null: continue
		var tr = TextureRect.new(); tr.mouse_filter = Control.MOUSE_FILTER_IGNORE; tr.texture = st
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		var hh = H * J.num(o.get("h", 0.5)); var ww = hh * float(st.get_width()) / float(st.get_height())
		tr.size = Vector2(ww, hh); tr.position = Vector2(W * J.num(o.get("x", 0.5)) - ww / 2, H * J.num(o.get("y", 0.95)) - hh)
		tr.flip_h = J.t(o.get("flip"))
		var sh = Panel.new(); sh.mouse_filter = Control.MOUSE_FILTER_IGNORE   # 腳底影，令疊上去嘅立繪企得穩
		var ss = StyleBoxFlat.new(); ss.bg_color = Color(0, 0, 0, 0.38); ss.set_corner_radius_all(int(ww * 0.25))
		sh.add_theme_stylebox_override("panel", ss)
		sh.size = Vector2(ww * 0.62, ww * 0.12); sh.position = Vector2(tr.position.x + ww * 0.19, tr.position.y + hh - ww * 0.07)
		layer.add_child(sh); layer.add_child(tr)
	for t in d.get("txt", []):
		if not (t is Dictionary): continue
		var lb = Label.new(); lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lb.text = DB.L(str(t.get("t", ""))); lb.add_theme_font_size_override("font_size", int(J.num(t.get("s", 20))))
		lb.add_theme_color_override("font_color", Color(str(t.get("c", "#3a2a1a"))))
		lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; lb.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		var bw = W * J.num(t.get("w", 0.8)); lb.size = Vector2(bw, 10)
		lb.position = Vector2(W * J.num(t.get("x", 0.5)) - bw / 2, H * J.num(t.get("y", 0.2)))
		layer.add_child(lb)
	visible = true; modulate.a = 0.0; _t = 0.0; _anim = true
	var st = get_parent().get("stage")   # 插圖出現時，舞台上嘅角色收起，唔好同插圖入面嘅角色重複
	if st != null and is_instance_valid(st): st.visible = false

func hide_cg() -> void:
	visible = false; cur_key = ""
	var st = get_parent().get("stage")
	if st != null and is_instance_valid(st): st.visible = true

func _process(dt: float) -> void:
	if not visible or not _anim: return
	_t += dt
	modulate.a = clampf(_t / 0.35, 0.0, 1.0)
	var z = 1.0 + minf(_t, 12.0) * 0.004   # 慢慢推近
	pic.scale = Vector2(z, z)
	if _t > 12.0: _anim = false
