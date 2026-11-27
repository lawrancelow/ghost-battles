# [uikit] A「辦公室鐵櫃・東方詭異」UI 套件（老闆 2026-11-27 通過）
# 素材：res://assets/ui/kit/*.webp（已縮到 390 寬畫布嘅邏輯尺寸；kit_meta.json 記九宮格邊）
# 用法：KS.box("btn_primary") → StyleBoxTexture；KS.frame(ctrl) 加鐵框；KS.install(tree) 全域自動換紙底面板
# 規矩：唔改任何 Control 嘅大小／點擊範圍；StyleBox 內距照舊（字唔會俾裝飾蓋）
extends RefCounted

const DIR := "res://assets/ui/kit/"
const OFF := false   # 總開關：true = 用返舊扁平款
static var _tex := {}
static var _meta := {}
static var _installed := false

static func meta(n: String) -> Dictionary:
	if _meta.is_empty():
		var f = FileAccess.open(DIR + "kit_meta.json", FileAccess.READ)
		if f != null:
			var d = JSON.parse_string(f.get_as_text())
			if d is Dictionary: _meta = d
	return _meta.get(n, {})

static func tex(n: String) -> Texture2D:
	if _tex.has(n): return _tex[n]
	var p = DIR + n + ".webp"
	var t: Texture2D = load(p) if ResourceLoader.exists(p) else null
	_tex[n] = t
	return t

static func ok() -> bool: return not OFF and tex("paper_fill") != null

# 九宮格 StyleBox；pad = 內容內距（-1 = 用九宮格邊）
static func box(n: String, pad := Vector4(-1, -1, -1, -1), tile := false) -> StyleBox:
	var t = tex(n)
	if t == null: return null
	var s = StyleBoxTexture.new(); s.texture = t
	var m = float(meta(n).get("m", 0))
	s.texture_margin_left = m; s.texture_margin_right = m; s.texture_margin_top = m; s.texture_margin_bottom = m
	if tile: s.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT; s.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
	var p = pad if pad.x >= 0 else Vector4(m, m, m, m)
	s.content_margin_left = p.x; s.content_margin_top = p.y; s.content_margin_right = p.z; s.content_margin_bottom = p.w
	return s

# 紙紋底（平鋪、冇邊）：取代米白紙底 StyleBoxFlat，內距跟原本
static func paper(src: StyleBox = null) -> StyleBox:
	var s = box("paper_fill", Vector4(0, 0, 0, 0), true)
	if s == null: return null
	s.texture_margin_left = 0; s.texture_margin_right = 0; s.texture_margin_top = 0; s.texture_margin_bottom = 0
	if src != null:
		for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]: s.set_content_margin(side, src.get_content_margin(side))
	var a = 1.0
	if src is StyleBoxFlat: a = src.bg_color.a
	s.modulate_color = Color(1, 1, 1, a)
	return s

# 深色底紋（墨綠黑板）：取代大塊深色面板
static func dark(src: StyleBox = null) -> StyleBox:
	var s = box("dark_fill", Vector4(0, 0, 0, 0), true)
	if s == null: return null
	s.texture_margin_left = 0; s.texture_margin_right = 0; s.texture_margin_top = 0; s.texture_margin_bottom = 0
	if src != null:
		for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]: s.set_content_margin(side, src.get_content_margin(side))
	return s

# 鐵櫃框（只畫邊、唔畫中間）：用 ctrl 自己嘅 draw 訊號畫（喺 ctrl 底色之上、子節點之下，唔會阻點擊，容器唔會郁佢）
static func frame(c: Control, n := "panel_large", sc := 0.6) -> void:
	if not ok() or c == null or c.has_meta("ks_frame"): return
	var t = tex(n)
	if t == null: return
	var m = float(meta(n).get("m", 12))
	var outw = not (c is PanelContainer)   # 唔係容器（子節點自己擺位）：框畫喺外面，永遠唔蓋內容
	var th = m * sc
	var info = {"n": n, "sc": sc, "m": m, "out": outw}
	c.set_meta("ks_frame", info)
	c.draw.connect(func():
		if not is_instance_valid(c): return
		var o = Vector2(-th, -th) if outw else Vector2.ZERO
		var sz = c.size + (Vector2(th, th) * 2.0 if outw else Vector2.ZERO)
		c.draw_set_transform(o, 0.0, Vector2(sc, sc))
		RenderingServer.canvas_item_add_nine_patch(c.get_canvas_item(), Rect2(Vector2.ZERO, sz / sc), Rect2(Vector2.ZERO, t.get_size()), t.get_rid(), Vector2(m, m), Vector2(m, m), RenderingServer.NINE_PATCH_STRETCH, RenderingServer.NINE_PATCH_STRETCH, false)
		c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE))
	c.queue_redraw()
	# 字唔可以俾框蓋：內容內距最少 = 框厚 + 6
	if c is PanelContainer and c.has_theme_stylebox_override("panel"):
		var st: StyleBox = c.get_theme_stylebox("panel").duplicate(); var need = m * sc + 6.0
		for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]: st.set_content_margin(side, maxf(st.get_content_margin(side), need))
		c.add_theme_stylebox_override("panel", st)

# 按鈕：kind gold＝主（暗血紅）、''＝次（墨綠）、ghost＝黃紙條（深字）、danger＝裂紋
static func skin_btn(b: Button, kind := "", pad := Vector4(15, 8, 15, 8)) -> void:
	if not ok() or b == null: return
	var nk = {"gold": "btn_primary", "": "btn_secondary", "ghost": "stat_row", "danger": "btn_danger"}.get(kind, "btn_secondary")
	var dk = {"gold": "btn_primary_down", "": "btn_secondary_down"}.get(kind, nk)
	var n = box(nk, pad); var p = box(dk, pad); var d = box("btn_disabled", pad)
	if n == null: return
	var h = n.duplicate(); h.modulate_color = Color(1.12, 1.12, 1.12)
	b.add_theme_stylebox_override("normal", n); b.add_theme_stylebox_override("hover", h); b.add_theme_stylebox_override("pressed", p)
	b.add_theme_stylebox_override("hover_pressed", p); b.add_theme_stylebox_override("disabled", d)
	var fg = Color("#2b1d12") if kind == "ghost" else Color("#fff3e0")
	b.add_theme_color_override("font_color", fg); b.add_theme_color_override("font_hover_color", fg); b.add_theme_color_override("font_pressed_color", fg)
	b.add_theme_color_override("font_disabled_color", Color("#cfc6b8"))
	if kind != "ghost":
		b.add_theme_color_override("font_outline_color", Color(0.08, 0.03, 0.02, 0.9)); b.add_theme_constant_override("outline_size", 4)
	b.set_meta("ks_btn", kind)

# 關閉鈕（✕）：換鐵框交叉牌
static func skin_close(b: Button) -> void:
	if not ok() or b == null: return
	var t = tex("btn_close")
	if t == null: return
	for st in ["normal", "hover", "pressed", "hover_pressed", "disabled", "focus"]:
		var s = StyleBoxTexture.new(); s.texture = t
		if st == "hover": s.modulate_color = Color(1.15, 1.15, 1.15)
		if st == "pressed" or st == "hover_pressed": s.modulate_color = Color(0.8, 0.8, 0.8)
		b.add_theme_stylebox_override(st, s if st != "focus" else StyleBoxEmpty.new())
	b.text = ""; b.custom_minimum_size = Vector2(maxf(b.custom_minimum_size.x, 34), maxf(b.custom_minimum_size.y, 34))
	b.set_meta("ks_btn", "close")

# ---------------- 全域自動換：紙底面板 → 紙紋＋大塊加鐵框；大塊深色面板 → 墨綠底 ----------------
static func _paperish(c: Color) -> bool:
	return c.a > 0.85 and c.get_luminance() > 0.6 and c.r > c.b + 0.08
static func _darkish(c: Color) -> bool:
	return c.a > 0.85 and c.get_luminance() < 0.16

static func install(tree: SceneTree) -> void:
	if _installed or not ok() or tree == null: return
	_installed = true
	tree.node_added.connect(func(n): if n is Control: Callable(_check).call_deferred(n))

static func _skip(c: Control) -> bool:
	var p: Node = c
	var i = 0
	while p != null and i < 40:
		if p.has_meta("ks_skip"): return true
		var sc = p.get_script()
		if sc != null and (str(sc.resource_path).find("/title/") >= 0 or str(sc.resource_path).find("launch.gd") >= 0): return true
		p = p.get_parent(); i += 1
	return false

static func _check(c) -> void:
	if not is_instance_valid(c) or not (c is Control) or c.has_meta("ks_done"): return
	if c is Button and not c.has_meta("ks_btn"): _check_btn(c); return
	if not (c is PanelContainer or c is Panel): return
	var key = "panel"
	if not c.has_theme_stylebox_override(key): return
	var s = c.get_theme_stylebox(key)
	if not (s is StyleBoxFlat): return
	if _skip(c): c.set_meta("ks_done", true); return
	c.set_meta("ks_done", true)
	if _paperish(s.bg_color):
		var ns = paper(s)
		if ns != null: c.add_theme_stylebox_override(key, ns)
		_maybe_frame(c)
	elif _darkish(s.bg_color):
		_maybe_dark(c, s)

static func _in_framed(c: Control) -> bool:   # 上層已經有鐵框：唔再疊框（卡片只換紙紋）
	var p = c.get_parent(); var i = 0
	while p != null and i < 30:
		if p.has_meta("ks_frame"): return true
		p = p.get_parent(); i += 1
	return false

static func _maybe_frame(c: Control) -> void:
	var go = func():
		if not is_instance_valid(c) or c.has_meta("ks_frame"): return
		if c.size.x >= 300 and c.size.y >= 220 and not _in_framed(c): frame(c)
	go.call(); c.resized.connect(go)

static func _maybe_dark(c: Control, s: StyleBoxFlat) -> void:
	var go = func():
		if not is_instance_valid(c) or c.has_meta("ks_frame"): return
		if c.size.x >= 300 and c.size.y >= 220:
			var ns = dark(s)
			if ns != null: c.add_theme_stylebox_override("panel", ns)
			frame(c)
	go.call(); c.resized.connect(go)

# 白／紙色大格按鈕（例：僱用格、頭像格）→ 卡片框；細按鈕唔郁
static func _check_btn(b: Button) -> void:
	b.set_meta("ks_done", true)
	if not b.has_theme_stylebox_override("normal"): return
	var s = b.get_theme_stylebox("normal")
	if not (s is StyleBoxFlat) or s.bg_color.a < 0.85 or s.bg_color.get_luminance() < 0.75 or _skip(b): return
	var go = func():
		if not is_instance_valid(b) or b.has_meta("ks_btn") or b.size.y < 48 or b.size.x < 60: return
		var n = box("card", Vector4(s.content_margin_left, s.content_margin_top, s.content_margin_right, s.content_margin_bottom))
		if n == null: return
		var p = n.duplicate(); p.modulate_color = Color(0.85, 0.85, 0.85)
		var h = n.duplicate(); h.modulate_color = Color(1.08, 1.08, 1.08)
		b.add_theme_stylebox_override("normal", n); b.add_theme_stylebox_override("hover", h); b.add_theme_stylebox_override("pressed", p); b.add_theme_stylebox_override("hover_pressed", p)
		b.set_meta("ks_btn", "card")
	go.call(); b.resized.connect(go)
