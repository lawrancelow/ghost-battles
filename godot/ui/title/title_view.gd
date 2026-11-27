# [title] 標題畫面（新版）：封面慢推鏡、飄霧、鬼火、Logo 浮動、按鈕依次淡入
# 素材優先次序（冇就退返舊嘢，唔會爆）：
#   封面：cover2（無字新封面）→ cover（舊，字烤喺圖上）
#   Logo：title_logo（透明底）；用舊 cover 時唔疊（圖上已經有字）
#   主按鈕：btn_main（無字底板，程序疊字）→ btn_new2／btn_cont2（黃牌紅「加班」）→ btn_new／btn_cont
#   次按鈕：btn_sub（無字底板）→ 程序畫木牌
#   齒輪：ico_gear（冇就淨字）
# 熱更新：冇 class_name；main.gd 用 load("res://ui/title/title_view.gd").new()
extends Control

var host: Node          # Main
var fresh := true       # 冇存檔
var btn_new: Control    # 開始新遊戲（full_run 測試會揾第一粒 TextureButton）
var btn_cont: Control
var btn_set: Control
var btn_imp: Control
var hint: Label
var ver_l: Label

var _cover: TextureRect
var _cover_tex: Texture2D
var _new_cover := false
var _logo: TextureRect
var _cfade: TextureRect
var _blur: TextureRect
var _lshade: TextureRect
var _wide_tex: Texture2D
var _vb: VBoxContainer
var land := false
var _mists: Array = []
var _t := 0.0

const CREAM := Color("#f6ead0")
const GOLD := Color("#f3d68a")

static func tex(k: String) -> Texture2D:
	# 先睇檔案喺唔喺包入面（例如 cover2_wide 只入 PC 版）：唔喺就回 null，唔好俾 Spr 報「搵唔到檔」
	var p := ""
	for ext in ["webp", "png"]:
		var q = "res://assets/spr/%s.%s" % [k, ext]
		if ResourceLoader.exists(q): p = q; break
	if p == "": return null
	var sp = Engine.get_main_loop().root.get_node_or_null("Spr") if Engine.get_main_loop() is SceneTree else null
	if sp != null and sp.has_method("ok") and sp.call("ok", k):
		var t = sp.call("get_tex", k); if t is Texture2D: return t
	return load(p)

func _ready() -> void:
	name = "Title"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP
	clip_contents = true
	var bg = ColorRect.new(); bg.color = Color("#17121a"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
	_cover_tex = tex("cover2"); _new_cover = _cover_tex != null
	if not _new_cover: _cover_tex = tex("cover")
	_wide_tex = tex("cover2_wide") if _new_cover else null   # [pc] 橫版封面（美術組出；冇就用 cover2 置中＋模糊延伸背景）
	_blur = TextureRect.new(); _blur.name = "blur_bg"; _blur.texture = _cover_tex; _blur.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; _blur.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_blur.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); _blur.modulate = Color(0.42, 0.4, 0.46); _blur.mouse_filter = Control.MOUSE_FILTER_IGNORE; _blur.visible = false
	var gs0 = get_node_or_null("/root/G")
	if gs0 == null or not bool(gs0.get("safe_gfx")): _blur.material = _blur_mat()
	add_child(_blur)
	_cover = TextureRect.new(); _cover.texture = _cover_tex; _cover.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; _cover.stretch_mode = TextureRect.STRETCH_SCALE
	_cover.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(_cover)
	# 舊封面高度唔夠鋪滿：喺封面底部做一段漸變接返底色（唔好見到硬邊）
	_cfade = TextureRect.new(); _cfade.name = "cover_fade"; _cfade.texture = _grad([[0.0, Color(0.09, 0.07, 0.1, 0)], [1.0, Color("#17121a")]])
	_cfade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; _cfade.stretch_mode = TextureRect.STRETCH_SCALE; _cfade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cfade.visible = false; add_child(_cfade)
	# 底部漸變：舊封面下半係泥地，要接返底色；新封面淨係壓暗按鈕區
	var cf = TextureRect.new(); cf.name = "fade"
	cf.texture = _grad([[0.0, Color(0.09, 0.07, 0.1, 0)], [0.55, Color(0.09, 0.07, 0.1, 0)], [0.78, Color(0.09, 0.07, 0.1, 0.55)], [1.0, Color(0.06, 0.05, 0.07, 0.94)]])
	cf.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cf.stretch_mode = TextureRect.STRETCH_SCALE; cf.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); cf.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(cf)
	var top = TextureRect.new(); top.texture = _grad([[0.0, Color(0.05, 0.04, 0.08, 0.55)], [1.0, Color(0.05, 0.04, 0.08, 0)]])
	top.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; top.stretch_mode = TextureRect.STRETCH_SCALE; top.anchor_right = 1; top.anchor_bottom = 0.22; top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.visible = _new_cover; add_child(top)   # 頂部壓暗：Logo 清楚啲
	_lshade = TextureRect.new(); _lshade.name = "left_shade"; _lshade.mouse_filter = Control.MOUSE_FILTER_IGNORE; _lshade.visible = false
	var lg = Gradient.new(); lg.offsets = PackedFloat32Array([0.0, 0.6, 1.0]); lg.colors = PackedColorArray([Color(0.05, 0.04, 0.07, 0.72), Color(0.05, 0.04, 0.07, 0.35), Color(0.05, 0.04, 0.07, 0)])
	var lgt = GradientTexture2D.new(); lgt.gradient = lg; lgt.fill_from = Vector2(0, 0); lgt.fill_to = Vector2(1, 0); lgt.width = 128; lgt.height = 4
	_lshade.texture = lgt; _lshade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; _lshade.stretch_mode = TextureRect.STRETCH_SCALE
	_lshade.anchor_bottom = 1; add_child(_lshade)
	_build_mist()
	_build_embers()
	# Logo
	var lt = tex("title_logo")
	if lt != null and _new_cover:
		_logo = TextureRect.new(); _logo.name = "Logo"; _logo.texture = lt; _logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; _logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_logo.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(_logo)
	elif _new_cover:   # 新封面但未有 Logo：程序字頂住
		var l = Label.new(); l.name = "LogoText"; l.text = "過勞鬼大作戰"; l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_font_override("font", UIKit.font("serif", 900)); l.add_theme_font_size_override("font_size", 44)
		l.add_theme_color_override("font_color", CREAM); l.add_theme_color_override("font_outline_color", Color("#3a0d0a")); l.add_theme_constant_override("outline_size", 12)
		l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7)); l.add_theme_constant_override("shadow_offset_y", 4)
		l.anchor_right = 1; l.offset_top = 70; l.offset_bottom = 140; l.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(l)
	_build_buttons()
	# 版本號（測試員報問題時用）
	ver_l = UIKit.label("", 11, Color(1, 1, 1, 0.5)); ver_l.name = "Ver"; ver_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ver_l.anchor_left = 1; ver_l.anchor_right = 1; ver_l.anchor_top = 1; ver_l.anchor_bottom = 1; ver_l.offset_left = -420; ver_l.offset_right = -8; ver_l.offset_top = -20; ver_l.offset_bottom = -4
	ver_l.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(ver_l)
	_upd_ver()
	var vt = Timer.new(); vt.wait_time = 1.0; vt.autostart = true; vt.timeout.connect(_upd_ver); add_child(vt)
	resized.connect(_layout); _layout()
	_intro()

func _upd_ver() -> void:
	if host != null and host.has_method("_ver_text"): ver_l.text = str(host.call("_ver_text"))

func _grad(stops: Array) -> Texture2D:
	var gr = Gradient.new()
	gr.offsets = PackedFloat32Array(stops.map(func(x): return x[0])); gr.colors = PackedColorArray(stops.map(func(x): return x[1]))
	var gt = GradientTexture2D.new(); gt.gradient = gr; gt.fill_from = Vector2(0, 0); gt.fill_to = Vector2(0, 1); gt.width = 4; gt.height = 128
	return gt

# ---------------- 版面 ----------------
func _layout() -> void:
	var w = size.x; var h = size.y
	if w <= 0 or _cover_tex == null: return
	land = w > h
	var ct: Texture2D = (_wide_tex if _wide_tex != null else _cover_tex) if land else _cover_tex
	_cover.texture = ct
	var tw = float(ct.get_width()); var th = float(ct.get_height())
	var side := 0.0   # 橫屏：封面兩邊空位（擺 Logo／按鈕）
	var wide_left := false   # 橫版封面：主角喺中間偏右，Logo＋按鈕全部擺左邊一欄
	_blur.visible = false
	if land:
		_cfade.visible = false
		if tw / th >= w / h * 0.85:   # 橫版封面：鋪滿
			var s = maxf(w / tw, h / th) * 1.06
			_cover.size = Vector2(tw * s, th * s); _cover.position = (Vector2(w, h) - _cover.size) / 2
			side = w * 0.32; wide_left = true
		else:                          # 直版封面：高度鋪滿置中，兩邊模糊延伸
			_blur.visible = true
			if _blur.material != null and _cover.material == null: _cover.material = _edge_mat()   # 兩邊羽化入模糊背景
			_cover.size = Vector2(h * 1.04 * tw / th, h * 1.04); _cover.position = (Vector2(w, h) - _cover.size) / 2
			side = maxf((w - h * tw / th) / 2, w * 0.26)
	if not _blur.visible: _cover.material = null
	_lshade.visible = wide_left; _lshade.offset_right = w * 0.42   # 左邊壓暗：Logo、按鈕清楚
	if not land:
		var tall = h / w > th / tw * 1.15   # 手機比封面長好多：闊度鋪滿、靠頂，下面漸變接底色（唔好裁走兩邊嘅鬼）
		if _new_cover and not tall:   # 鋪滿（cover），居中；預留 6% 推鏡空間
			var s = maxf(w / tw, h / th) * 1.06
			_cover.size = Vector2(tw * s, th * s); _cover.position = Vector2((w - _cover.size.x) / 2, (h - _cover.size.y) / 2)
			_cfade.visible = false
		else:            # 闊度鋪滿、靠頂
			_cover.size = Vector2(w * 1.04, w * 1.04 * th / tw); _cover.position = Vector2(-w * 0.02, 0)
			var fh = _cover.size.y * 0.28
			_cfade.visible = true; _cfade.position = Vector2(0, _cover.size.y - fh); _cfade.size = Vector2(w, fh + _cover.size.y * 0.04)
	_cover.pivot_offset = _cover.size / 2
	if _logo:
		var lw: float; var lp: Vector2
		var ar = _logo.texture.get_height() / float(_logo.texture.get_width())
		if land:
			lw = clampf(side * 0.9, 220.0, 560.0); lp = Vector2(maxf((side - lw) / 2, w * 0.02), h * 0.07)
		else:
			lw = minf(w * 0.86, 420.0); lp = Vector2((w - lw) / 2, maxf(h * 0.045, 28.0))
		_logo.size = Vector2(lw, lw * ar); _logo.position = lp; _logo.pivot_offset = _logo.size / 2
		_logo.set_meta("y0", lp.y)
	if _vb:
		if land:   # 按鈕：橫版封面放左下（唔遮主角）；直版封面放右邊空位
			var bw = 380.0; var cx = (side / 2 if wide_left else w - side / 2)
			_vb.anchor_left = 0; _vb.anchor_right = 0; _vb.anchor_top = 1; _vb.anchor_bottom = 1
			_vb.offset_left = clampf(cx - bw / 2, w * 0.02, w - bw - w * 0.02); _vb.offset_right = _vb.offset_left + bw; _vb.offset_bottom = -h * 0.09
		else:
			_vb.anchor_left = 0; _vb.anchor_right = 1; _vb.anchor_top = 1; _vb.anchor_bottom = 1
			_vb.offset_left = 0; _vb.offset_right = 0; _vb.offset_bottom = -30

func _edge_mat() -> ShaderMaterial:
	var sh = Shader.new()
	sh.code = "shader_type canvas_item; void fragment(){ vec4 c = texture(TEXTURE, UV) * COLOR; c.a *= smoothstep(0.0, 0.07, UV.x) * smoothstep(1.0, 0.93, UV.x); COLOR = c; }"
	var m = ShaderMaterial.new(); m.shader = sh; return m

# 模糊背景（橫屏直版封面兩邊延伸用）：13 點高斯，夠用唔使 mipmap
func _blur_mat() -> ShaderMaterial:
	var sh = Shader.new()
	sh.code = """shader_type canvas_item;
uniform float r = 14.0;
void fragment(){
	vec2 px = TEXTURE_PIXEL_SIZE * r;
	vec4 c = texture(TEXTURE, UV) * 0.2;
	c += (texture(TEXTURE, UV + vec2(px.x, 0)) + texture(TEXTURE, UV - vec2(px.x, 0)) + texture(TEXTURE, UV + vec2(0, px.y)) + texture(TEXTURE, UV - vec2(0, px.y))) * 0.1;
	c += (texture(TEXTURE, UV + px) + texture(TEXTURE, UV - px) + texture(TEXTURE, UV + vec2(px.x, -px.y)) + texture(TEXTURE, UV + vec2(-px.x, px.y))) * 0.07;
	c += (texture(TEXTURE, UV + vec2(2.0*px.x, 0)) + texture(TEXTURE, UV - vec2(2.0*px.x, 0)) + texture(TEXTURE, UV + vec2(0, 2.0*px.y)) + texture(TEXTURE, UV - vec2(0, 2.0*px.y))) * 0.03;
	COLOR = c * COLOR;
}"""
	var m = ShaderMaterial.new(); m.shader = sh; return m

func _process(dt: float) -> void:
	_t += dt
	# 封面慢推鏡（14 秒一來回）
	if _cover: var k = 0.5 - 0.5 * cos(_t * TAU / 28.0); _cover.scale = Vector2.ONE * (1.0 + 0.035 * k)
	if _logo and _logo.has_meta("y0"):
		_logo.position.y = float(_logo.get_meta("y0")) + sin(_t * 1.3) * 5.0
		_logo.rotation = deg_to_rad(sin(_t * 0.9) * 0.6)
	for m in _mists:
		var sp: Sprite2D = m[0]; sp.position.x += m[1] * dt
		var w = size.x
		if m[1] > 0 and sp.position.x > w + 260: sp.position.x = -260
		elif m[1] < 0 and sp.position.x < -260: sp.position.x = w + 260

# ---------------- 霧、鬼火 ----------------
static var _mist_tex: Texture2D
func _mist_texture() -> Texture2D:
	if _mist_tex: return _mist_tex
	var gr = Gradient.new(); gr.offsets = PackedFloat32Array([0.0, 0.55, 1.0])
	gr.colors = PackedColorArray([Color(0.86, 0.82, 0.92, 0.55), Color(0.8, 0.76, 0.88, 0.18), Color(0.8, 0.76, 0.88, 0.0)])
	var gt = GradientTexture2D.new(); gt.gradient = gr; gt.fill = GradientTexture2D.FILL_RADIAL; gt.fill_from = Vector2(0.5, 0.5); gt.fill_to = Vector2(1.0, 0.5)
	gt.width = 128; gt.height = 128; _mist_tex = gt; return gt

func _build_mist() -> void:
	var lay = Node2D.new(); lay.name = "Mist"; add_child(lay)
	var rng = RandomNumberGenerator.new(); rng.seed = 7
	for i in 7:
		var sp = Sprite2D.new(); sp.texture = _mist_texture()
		sp.scale = Vector2(rng.randf_range(3.4, 5.2), rng.randf_range(0.9, 1.4))
		sp.position = Vector2(rng.randf_range(-100, 550), rng.randf_range(0.5, 0.95) * 975.0)
		sp.modulate = Color(1, 1, 1, rng.randf_range(0.16, 0.3))
		lay.add_child(sp); _mists.append([sp, rng.randf_range(6.0, 16.0) * (1 if i % 2 == 0 else -1)])

func _build_embers() -> void:
	var gs = get_node_or_null("/root/G")
	if gs != null and bool(gs.get("safe_gfx")): return
	for c in [Color(1.0, 0.45, 0.25, 0.9), Color(0.45, 1.0, 0.85, 0.8)]:
		var p = CPUParticles2D.new(); p.name = "Embers"
		p.amount = 14; p.lifetime = 7.0; p.preprocess = 7.0
		p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE; p.emission_rect_extents = Vector2(260, 10)
		p.position = Vector2(225, 1000); p.direction = Vector2(0, -1); p.spread = 18
		p.initial_velocity_min = 22; p.initial_velocity_max = 48; p.gravity = Vector2(0, -4)
		p.scale_amount_min = 0.6; p.scale_amount_max = 1.4
		var gr = Gradient.new(); gr.offsets = PackedFloat32Array([0.0, 0.2, 0.8, 1.0])
		gr.colors = PackedColorArray([Color(c, 0), c, Color(c, 0.5), Color(c, 0)]); p.color_ramp = gr
		p.texture = _dot(); add_child(p)
		resized.connect(func(): p.position = Vector2(size.x / 2, size.y + 20); p.emission_rect_extents = Vector2(size.x * 0.55, 10))

static var _dot_tex: Texture2D
func _dot() -> Texture2D:
	if _dot_tex: return _dot_tex
	var gr = Gradient.new(); gr.offsets = PackedFloat32Array([0.0, 0.35, 1.0]); gr.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0.5), Color(1, 1, 1, 0)])
	var gt = GradientTexture2D.new(); gt.gradient = gr; gt.fill = GradientTexture2D.FILL_RADIAL; gt.fill_from = Vector2(0.5, 0.5); gt.fill_to = Vector2(1.0, 0.5); gt.width = 16; gt.height = 16
	_dot_tex = gt; return gt

# ---------------- 按鈕 ----------------
func _build_buttons() -> void:
	var vb = VBoxContainer.new(); vb.name = "Btns"; _vb = vb
	vb.anchor_left = 0; vb.anchor_right = 1; vb.anchor_top = 1; vb.anchor_bottom = 1; vb.grow_vertical = Control.GROW_DIRECTION_BEGIN
	vb.offset_bottom = -30; vb.add_theme_constant_override("separation", 10); vb.alignment = BoxContainer.ALIGNMENT_END
	add_child(vb)
	if not fresh:
		btn_cont = _main_btn("繼續遊戲", "btn_cont"); btn_cont.name = "Cont"; vb.add_child(btn_cont)
	btn_new = _main_btn("開始新遊戲", "btn_new"); btn_new.name = "New"; vb.add_child(btn_new)
	hint = UIKit.label("", 14, Color("#f0dcb4"), "sans", 700); hint.name = "Hint"; hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; hint.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	hint.custom_minimum_size = Vector2(0, 20); hint.add_theme_color_override("font_outline_color", Color.BLACK); hint.add_theme_constant_override("outline_size", 4); vb.add_child(hint)
	var hb = HBoxContainer.new(); hb.name = "Sub"; hb.alignment = BoxContainer.ALIGNMENT_CENTER; hb.add_theme_constant_override("separation", 14); vb.add_child(hb)
	btn_set = _sub_btn("設置", true); btn_set.name = "Settings"; hb.add_child(btn_set)
	btn_imp = _sub_btn("導入網頁版存檔", false); btn_imp.name = "Import"; hb.add_child(btn_imp)
	if btn_cont: (btn_cont as BaseButton).pressed.connect(func(): _press(btn_cont, func(): host.call("_title_cont", fresh)))
	(btn_new as BaseButton).pressed.connect(func(): _press(btn_new, func(): host.call("_title_new", fresh, btn_new, hint)))
	(btn_set as BaseButton).pressed.connect(func(): _press(btn_set, func(): host.call("open_settings", true, not fresh)))
	(btn_imp as BaseButton).pressed.connect(func(): _press(btn_imp, func(): host.call("open_import")))

func _press(b: Control, f: Callable) -> void:
	var tw = b.create_tween(); tw.tween_property(b, "scale", Vector2(0.94, 0.94), 0.06); tw.tween_property(b, "scale", Vector2.ONE, 0.1)
	f.call()

# 主按鈕：btn_main 底板＋字 → btn_new2／btn_cont2 → 舊圖
func _main_btn(text: String, old_key: String) -> Control:
	var w = 330.0
	var base = null   # 老闆揀咗 btn_new2／btn_cont2（毛筆「加班」黃牌）；btn_main 未採用
	var t2: Texture2D = base if base != null else tex(old_key + "2")
	if t2 == null: t2 = tex(old_key)
	if t2 == null:
		var b = UIKit.btn(text, "gold"); b.custom_minimum_size = Vector2(w, 72); b.add_theme_font_size_override("font_size", 26); b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.pivot_offset = b.custom_minimum_size / 2; return b
	var tb = TextureButton.new(); tb.texture_normal = t2; tb.ignore_texture_size = true; tb.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	tb.custom_minimum_size = Vector2(w, w * t2.get_height() / t2.get_width()); tb.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	tb.pivot_offset = tb.custom_minimum_size / 2
	if base != null:   # 無字底板：疊字（左邊留位畀黃牌）
		var l = Label.new(); l.text = text; l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.add_theme_font_override("font", UIKit.font("serif", 900)); l.add_theme_font_size_override("font_size", 30)
		l.add_theme_color_override("font_color", CREAM); l.add_theme_color_override("font_outline_color", Color("#2a1810")); l.add_theme_constant_override("outline_size", 8)
		l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); l.offset_left = w * 0.16; l.mouse_filter = Control.MOUSE_FILTER_IGNORE; tb.add_child(l)
	return tb

func _sub_btn(text: String, gear: bool) -> Control:
	var w = 176.0; var h = 52.0
	var base = null   # 老闆揀咗程序畫木框小按鈕（美術組 btn_sub 未採用）
	var b: BaseButton
	if base != null:
		var tb = TextureButton.new(); tb.texture_normal = base; tb.ignore_texture_size = true; tb.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		h = w * base.get_height() / base.get_width(); b = tb
	else:
		var bb = Button.new(); bb.focus_mode = Control.FOCUS_NONE
		var st = UIKit.sb(Color(0.16, 0.11, 0.09, 0.86), 8, Color("#c9a45a"), 2, Vector4(8, 6, 8, 6)); st.shadow_color = Color(0, 0, 0, 0.5); st.shadow_size = 4
		var sh = st.duplicate(); sh.bg_color = Color(0.24, 0.16, 0.12, 0.92)
		bb.add_theme_stylebox_override("normal", st); bb.add_theme_stylebox_override("hover", sh); bb.add_theme_stylebox_override("pressed", sh); bb.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		b = bb
	b.custom_minimum_size = Vector2(w, h); b.pivot_offset = b.custom_minimum_size / 2
	var hb = HBoxContainer.new(); hb.alignment = BoxContainer.ALIGNMENT_CENTER; hb.add_theme_constant_override("separation", 6)
	hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); hb.mouse_filter = Control.MOUSE_FILTER_IGNORE; b.add_child(hb)
	if gear:
		var gt = null   # 齒輪圖未採用
		if gt != null:
			var ic = TextureRect.new(); ic.texture = gt; ic.custom_minimum_size = Vector2(26, 26); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			ic.mouse_filter = Control.MOUSE_FILTER_IGNORE; ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(ic)
	var l = Label.new(); l.text = text; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_font_override("font", UIKit.font("serif", 900)); l.add_theme_font_size_override("font_size", 19)
	l.add_theme_color_override("font_color", GOLD); l.add_theme_color_override("font_outline_color", Color("#1a0f0a")); l.add_theme_constant_override("outline_size", 5)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(l)
	return b

# ---------------- 入場 ----------------
func _intro() -> void:
	modulate.a = 0.0
	var tw = create_tween(); tw.tween_property(self, "modulate:a", 1.0, 0.5)
	var seq: Array = []
	if _logo: seq.append(_logo)
	for b in [btn_cont, btn_new]: if b: seq.append(b)
	seq.append(get_node("Btns/Sub"))
	var d = 0.25
	for n in seq:
		var c: CanvasItem = n; c.modulate.a = 0.0
		var t2 = create_tween(); t2.tween_interval(d); t2.tween_property(c, "modulate:a", 1.0, 0.45).set_trans(Tween.TRANS_SINE)
		d += 0.14
	# 主按鈕輕輕擺（舊版手感）
	for b in [btn_cont, btn_new]:
		if b == null: continue
		var tw2 = b.create_tween().set_loops(); tw2.tween_property(b, "rotation", deg_to_rad(-1.0), 1.6).set_trans(Tween.TRANS_SINE); tw2.tween_property(b, "rotation", deg_to_rad(1.0), 1.6).set_trans(Tween.TRANS_SINE)
