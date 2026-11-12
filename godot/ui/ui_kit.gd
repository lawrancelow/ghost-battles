# UI 小工具：顏色、字體、框、按鈕（對應網頁版 style.css 嘅變數同 .btn 款式）
class_name UIKit
extends RefCounted

const INK := Color("#16131b")
const PAPER := Color("#ecd9a4")
const PAPERLINE := Color("#b89a52")
const INKTXT := Color("#2b1d12")
const INKDIM := Color("#6e5838")
const CINNABAR := Color("#c2362b")
const CINNABAR2 := Color("#9c2219")
const GOLD2 := Color("#f3d68a")
const DIM := Color("#a99fb4")

static func font(kind := "sans", weight := 400) -> Font:
	return Ctx.font_res("serif" if kind == "serif" else "sans-serif", weight)

static func sb(bg: Color, radius := 0, border := Color(0, 0, 0, 0), bw := 0, pad := Vector4(0, 0, 0, 0)) -> StyleBoxFlat:
	var s = StyleBoxFlat.new(); s.bg_color = bg
	s.set_corner_radius_all(radius)
	if bw > 0: s.border_color = border; s.set_border_width_all(bw)
	s.content_margin_left = pad.x; s.content_margin_top = pad.y; s.content_margin_right = pad.z; s.content_margin_bottom = pad.w
	s.anti_aliasing = true
	return s

static func label(text: String, size := 15, col := INKTXT, kind := "sans", weight := 400) -> Label:
	var l = Label.new(); l.text = text
	l.add_theme_font_override("font", font(kind, weight)); l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l

static func rich(bb: String, size := 14, col := INKTXT, kind := "sans") -> RichTextLabel:
	var r = RichTextLabel.new(); r.bbcode_enabled = true; r.fit_content = true; r.scroll_active = false
	r.text = bb; r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	r.add_theme_font_override("normal_font", font(kind, 400)); r.add_theme_font_override("bold_font", font(kind, 900))
	r.add_theme_font_size_override("normal_font_size", size); r.add_theme_font_size_override("bold_font_size", size)
	r.add_theme_color_override("default_color", col)
	r.mouse_filter = Control.MOUSE_FILTER_PASS
	return r

# kind: '' 普通（深色）| 'gold'（朱紅）| 'ghost'（淡）
static func btn(text: String, kind := "", small := false) -> Button:
	var b = Button.new(); b.text = text
	b.add_theme_font_override("font", font("sans", 900)); b.add_theme_font_size_override("font_size", 13 if small else 15)
	var pad = Vector4(11, 6, 11, 6) if small else Vector4(15, 8, 15, 8)
	var bg = Color("#3a2c26"); var fg = Color("#f0e2c8"); var bd = Color("#6a5040")
	if kind == "gold": bg = Color("#bb3427"); fg = Color("#fff3e0"); bd = Color("#f2a080")
	elif kind == "ghost": bg = Color(0.23, 0.17, 0.15, 0.35); fg = Color("#5a4632"); bd = Color("#b89a52")
	var n = sb(bg, 4, bd, 1, pad); n.shadow_color = Color("#140c08"); n.shadow_size = 0; n.shadow_offset = Vector2(0, 2)
	var h = sb(bg.lightened(0.08), 4, bd, 1, pad)
	var p = sb(bg.darkened(0.15), 4, bd, 1, pad)
	var d = sb(Color(bg, 0.45), 4, Color(bd, 0.5), 1, pad)
	b.add_theme_stylebox_override("normal", n); b.add_theme_stylebox_override("hover", h); b.add_theme_stylebox_override("pressed", p)
	b.add_theme_stylebox_override("disabled", d); b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.add_theme_color_override("font_color", fg); b.add_theme_color_override("font_hover_color", fg); b.add_theme_color_override("font_pressed_color", fg)
	b.add_theme_color_override("font_disabled_color", Color(fg, 0.45))
	return b

static func portrait(k: String, size := 64) -> TextureRect:
	var tr = TextureRect.new(); tr.custom_minimum_size = Vector2(size, size)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var r = Art.portrait_region(k)
	if r.size():
		var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; tr.texture = at
	return tr

static func hsep() -> Control:
	var c = ColorRect.new(); c.color = Color(PAPERLINE, 0.7); c.custom_minimum_size = Vector2(0, 1); return c
