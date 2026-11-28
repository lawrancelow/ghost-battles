# [cgm] 動態劇情插圖（分層＋動態），由 ui/story_cg.gd 用；熱更新：冇 class_name，story_cg.gd 用 preload
#   素材：res://assets/cg_layers/<圖名>/ 底圖＋每個角色透明圖（webp）
#   設定：res://assets/cg_layers.json  {"<圖名>": layout}（一個檔，符合匯出 assets/*.json 規則）
#   layout：
#     "bg": "bg.webp"                    背景（已挖走角色、補好洞）
#     "cam": {"zoom":[1.0,1.06], "pan":[0,0,-0.01,0.005], "dur":14}   慢推鏡：zoom 起→止，pan＝起 x,y → 止 x,y（畫面比例）
#     "layers": [ {
#        "img": "wood.webp",  "x": 0.44, "y": 0.47, "h": 0.11,     x＝中心、y＝腳底（底圖比例），h＝高度（底圖高度比例）
#        "z": 1,  "par": 0.4,                                       z 序；視差（慢推鏡時比背景多郁幾多）
#        "flip": false,
#        "fx": { "float":  {"amp":0.006, "per":2.6},                上下飄（鬼）
#                "breathe":{"amp":0.018, "per":3.2},                呼吸（腳底為軸輕微縮放）
#                "sway":   {"deg":2.5, "per":4.0},                  左右晃（腳底為軸）
#                "shake":  {"amp":0.004, "every":4.0, "dur":0.45},  抖（驚嚇）：每 every 秒抖 dur 秒；every=0 一直抖
#                "blink":  {"alt":"wood_b.webp", "every":3.2, "dur":0.14} } }  換表情／眨眼：第二張圖
#     ],
#     "fx": [ {"type":"smoke|steam|wisp|ember", "x":0.93, "y":0.33, "w":0.03, "h":0.0, "n":10} ]   粒子；x,y＝發射中心，w,h＝範圍
#   另一種定位（美術組分層產線用）：  "rect": [x, y, w, h]（左上＋闊高，底圖比例）, "pivot": [0.5, 0.0]（軸心，層內比例；預設腳底 [0.5,1]）
#   多兩種動作：  "flicker": {"min":0.88, "max":1.12, "glow":0.55, "c":"#ffb060"}   燈籠閃（光暈用加色疊）
#                 "drift":   {"dy":0.014, "per":4.0}                               炊煙：向上飄＋淡出，兩份錯開循環
#   冇 layout 或者停用就返 null，story_cg 照舊用靜態圖。
extends RefCounted

const ROOT := "res://assets/cg_layers/"
const CONF := "res://assets/cg_layers.json"
static var _conf = null
static var disabled := false   # 設定／低效能可以關（關咗退返靜態）

static func conf() -> Dictionary:
	if _conf == null:
		_conf = {}
		if FileAccess.file_exists(CONF):
			var d = JSON.parse_string(FileAccess.get_file_as_string(CONF))
			if d is Dictionary: _conf = d
	return _conf

static func has(k: String) -> bool:
	return not disabled and conf().get(k) is Dictionary

static func _tex(k: String, f: String) -> Texture2D:
	var p = ROOT + k + "/" + f
	if not ResourceLoader.exists(p): return null
	return load(p) as Texture2D

static func bg(k: String) -> Texture2D:
	if not has(k): return null
	return _tex(k, str(conf()[k].get("bg", "bg.webp")))

# ---- 一張動態插圖嘅實例 ----
var k := ""
var L: Dictionary
var root: Control        # 掛喺 SubViewport 入面（pic 之上、疊字之下）
var vs := Vector2.ONE    # SubViewport 尺寸
var tsz := Vector2.ONE   # 底圖原尺寸
var cover_s := 1.0       # 底圖鋪滿（cover）嘅縮放
var cover_o := Vector2.ZERO
var items: Array = []    # [{node, base_pos, base_size, fx, alt, main, par, ph}]
var parts: Array = []
var t := 0.0

static func make(key: String, parent: Node, view_size: Vector2, bg_tex: Texture2D):
	if not has(key) or bg_tex == null: return null
	var m = new()
	m.k = key; m.L = conf()[key]; m.vs = view_size
	m.tsz = Vector2(bg_tex.get_width(), bg_tex.get_height())
	m.cover_s = maxf(view_size.x / m.tsz.x, view_size.y / m.tsz.y)
	m.cover_o = (view_size - m.tsz * m.cover_s) / 2.0
	m.root = Control.new(); m.root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.root.size = view_size; m.root.name = "cgm"
	parent.add_child(m.root)
	m._build()
	return m

func img2view(p: Vector2) -> Vector2:   # 底圖比例座標 → SubViewport 像素
	return cover_o + Vector2(p.x * tsz.x, p.y * tsz.y) * cover_s

func _build() -> void:
	var ls: Array = (L.get("layers", []) as Array).duplicate()
	ls.sort_custom(func(a, b): return J.num(a.get("z", 0)) < J.num(b.get("z", 0)))
	var i := 0
	for o in ls:
		if not (o is Dictionary): continue
		var tx = _tex(k, str(o.get("img", "")))
		if tx == null: continue
		var tr = TextureRect.new(); tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tr.texture = tx; tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_SCALE
		var pv: Array = o.get("pivot", [0.5, 1.0]) if o.get("pivot") is Array else [0.5, 1.0]
		if o.get("rect") is Array and (o.rect as Array).size() >= 4:   # 美術產線：左上＋闊高
			var r: Array = o.rect
			tr.position = img2view(Vector2(J.num(r[0]), J.num(r[1])))
			tr.size = Vector2(J.num(r[2]) * tsz.x, J.num(r[3]) * tsz.y) * cover_s
		else:   # 腳底＋高度
			var hh = J.num(o.get("h", 0.2)) * tsz.y * cover_s
			var ww = hh * float(tx.get_width()) / float(tx.get_height())
			var foot = img2view(Vector2(J.num(o.get("x", 0.5)), J.num(o.get("y", 0.9))))
			tr.size = Vector2(ww, hh); tr.position = foot - Vector2(ww / 2.0, hh)
		tr.pivot_offset = Vector2(tr.size.x * J.num(pv[0]), tr.size.y * J.num(pv[1]))   # 軸心：人＝腳底（唔離地），燈籠＝頂（吊住擺）
		tr.flip_h = J.t(o.get("flip"))
		root.add_child(tr)
		var fx: Dictionary = o.get("fx", {}) if o.get("fx") is Dictionary else {}
		var alt = null
		if fx.get("blink") is Dictionary: alt = _tex(k, str(fx.blink.get("alt", "")))
		var glow = null
		if fx.get("flicker") is Dictionary and J.num(fx.flicker.get("glow", 0.0)) > 0.0:   # 燈籠光暈：層後面一個加色柔光點
			glow = TextureRect.new(); glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
			glow.texture = _dot_tex(64, 1.0); glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			var gs = maxf(tr.size.x, tr.size.y) * 2.2
			glow.size = Vector2(gs, gs); glow.pivot_offset = glow.size / 2.0
			glow.modulate = Color(str(fx.flicker.get("c", "#ffb060")))
			var gm = CanvasItemMaterial.new(); gm.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; glow.material = gm
			root.add_child(glow); root.move_child(glow, tr.get_index())
		var twin = null
		if fx.get("drift") is Dictionary:   # 炊煙：第二份錯開半個周期，循環時唔會一下閃走
			twin = tr.duplicate(); root.add_child(twin)
		items.append({"n": tr, "pos": tr.position, "fx": fx, "main": tx, "alt": alt, "glow": glow, "twin": twin,
			"par": J.num(o.get("par", 0.0)), "ph": float(i) * 1.37})
		i += 1
	for f in L.get("fx", []):
		if f is Dictionary: _particles(f)

static func _dot_tex(sz: int, soft: float) -> Texture2D:   # 程式畫嘅柔邊圓點，唔使多一張圖
	var im = Image.create(sz, sz, false, Image.FORMAT_RGBA8)
	var c = (sz - 1) / 2.0
	for y in sz:
		for x in sz:
			var d = Vector2(x - c, y - c).length() / c
			var a = clampf((1.0 - d) / maxf(soft, 0.01), 0.0, 1.0)
			im.set_pixel(x, y, Color(1, 1, 1, a * a))
	return ImageTexture.create_from_image(im)

func _particles(f: Dictionary) -> void:
	var p = CPUParticles2D.new()
	var ty = str(f.get("type", "smoke"))
	var at = img2view(Vector2(J.num(f.get("x", 0.5)), J.num(f.get("y", 0.5))))
	var ew = J.num(f.get("w", 0.03)) * tsz.x * cover_s
	var eh = J.num(f.get("h", 0.0)) * tsz.y * cover_s
	var u = tsz.y * cover_s / 1000.0   # 1 單位＝底圖高 1/1000（唔同解像度一樣大細）
	p.position = at
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(maxf(ew / 2.0, 1.0), maxf(eh / 2.0, 1.0))
	p.amount = clampi(int(J.num(f.get("n", 10))), 1, 40)   # 手機：每組最多 40 粒
	p.local_coords = false
	var g = Gradient.new()
	match ty:
		"smoke":
			p.texture = _dot_tex(32, 0.9); p.lifetime = 3.2
			p.direction = Vector2(0.15, -1); p.spread = 12; p.gravity = Vector2(6 * u, -4 * u)
			p.initial_velocity_min = 14 * u; p.initial_velocity_max = 24 * u
			p.scale_amount_min = 0.6 * u * 10; p.scale_amount_max = 1.0 * u * 10
			var cv = Curve.new(); cv.add_point(Vector2(0, 0.4)); cv.add_point(Vector2(1, 1.6)); p.scale_amount_curve = cv
			g.set_color(0, Color(0.78, 0.74, 0.8, 0.0)); g.add_point(0.15, Color(0.78, 0.74, 0.8, 0.38)); g.set_color(g.get_point_count() - 1, Color(0.7, 0.66, 0.74, 0.0))
		"steam":
			p.texture = _dot_tex(24, 0.9); p.lifetime = 1.6
			p.direction = Vector2(0, -1); p.spread = 18; p.gravity = Vector2(0, -6 * u)
			p.initial_velocity_min = 18 * u; p.initial_velocity_max = 30 * u
			p.scale_amount_min = 0.4 * u * 10; p.scale_amount_max = 0.7 * u * 10
			var cv2 = Curve.new(); cv2.add_point(Vector2(0, 0.5)); cv2.add_point(Vector2(1, 1.8)); p.scale_amount_curve = cv2
			g.set_color(0, Color(1, 1, 1, 0.0)); g.add_point(0.2, Color(1, 1, 1, 0.45)); g.set_color(g.get_point_count() - 1, Color(1, 1, 1, 0.0))
		"wisp":   # 鬼火：青綠、慢飄、閃爍
			p.texture = _dot_tex(32, 0.6); p.lifetime = 4.5
			p.direction = Vector2(0, -1); p.spread = 180; p.gravity = Vector2(0, -2 * u)
			p.initial_velocity_min = 3 * u; p.initial_velocity_max = 9 * u
			p.scale_amount_min = 0.3 * u * 10; p.scale_amount_max = 0.6 * u * 10
			g.set_color(0, Color(0.45, 1.0, 0.75, 0.0)); g.add_point(0.25, Color(0.5, 1.0, 0.8, 0.85))
			g.add_point(0.5, Color(0.4, 0.9, 0.7, 0.4)); g.add_point(0.7, Color(0.5, 1.0, 0.8, 0.8)); g.set_color(g.get_point_count() - 1, Color(0.4, 0.9, 0.7, 0.0))
			var mat = CanvasItemMaterial.new(); mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; p.material = mat
		_:   # ember：火星
			p.texture = _dot_tex(16, 0.5); p.lifetime = 1.8
			p.direction = Vector2(0, -1); p.spread = 25; p.gravity = Vector2(0, -10 * u)
			p.initial_velocity_min = 10 * u; p.initial_velocity_max = 22 * u
			p.scale_amount_min = 0.15 * u * 10; p.scale_amount_max = 0.3 * u * 10
			g.set_color(0, Color(1.0, 0.75, 0.35, 0.0)); g.add_point(0.1, Color(1.0, 0.7, 0.3, 0.9)); g.set_color(g.get_point_count() - 1, Color(1.0, 0.35, 0.1, 0.0))
			var mat2 = CanvasItemMaterial.new(); mat2.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; p.material = mat2
	p.color_ramp = g
	p.preprocess = p.lifetime   # 一出場已經有煙，唔會由零開始
	root.add_child(p)
	parts.append(p)

# 鏡頭：返 [zoom, pan(像素)]；story_cg 用嚟郁底圖，同一套變換套落 root
func cam() -> Array:
	var c: Dictionary = L.get("cam", {}) if L.get("cam") is Dictionary else {}
	var dur = maxf(J.num(c.get("dur", 14.0)), 0.1)
	var a = clampf(t / dur, 0.0, 1.0); a = a * a * (3.0 - 2.0 * a)
	var zz: Array = c.get("zoom", [1.0, 1.05]) if c.get("zoom") is Array else [1.0, 1.05]
	var pp: Array = c.get("pan", [0, 0, 0, 0]) if c.get("pan") is Array else [0, 0, 0, 0]
	while pp.size() < 4: pp.append(0)
	var z = lerpf(J.num(zz[0]), J.num(zz[min(1, zz.size() - 1)]), a)
	var pan = Vector2(lerpf(J.num(pp[0]), J.num(pp[2]), a), lerpf(J.num(pp[1]), J.num(pp[3]), a)) * vs
	return [z, pan]

func tick(dt: float) -> Array:
	t += dt
	var cz = cam()
	root.pivot_offset = vs / 2.0
	root.scale = Vector2(cz[0], cz[0]); root.position = cz[1]
	for it in items:
		var n: TextureRect = it.n
		var fx: Dictionary = it.fx
		var off = cz[1] * float(it.par) / maxf(cz[0], 0.01)   # 視差：近景比背景多郁
		var sc = 1.0; var rot = 0.0
		var hh = n.size.y
		var ph = float(it.ph)
		if fx.get("float") is Dictionary:
			var f = fx.float
			off.y += sin((t + ph) * TAU / maxf(J.num(f.get("per", 2.6)), 0.1)) * J.num(f.get("amp", 0.006)) * tsz.y * cover_s
		if fx.get("breathe") is Dictionary:
			var b = fx.breathe
			sc += sin((t + ph * 0.7) * TAU / maxf(J.num(b.get("per", 3.2)), 0.1)) * J.num(b.get("amp", 0.018))
		if fx.get("sway") is Dictionary:
			var s = fx.sway
			rot = deg_to_rad(sin((t + ph) * TAU / maxf(J.num(s.get("per", 4.0)), 0.1)) * J.num(s.get("deg", 2.5)))
		if fx.get("shake") is Dictionary:
			var sh = fx.shake
			var ev = J.num(sh.get("every", 4.0)); var du = J.num(sh.get("dur", 0.45))
			var on = ev <= 0.0 or fmod(t + ph, ev) < du
			if on:
				var am = J.num(sh.get("amp", 0.004)) * tsz.y * cover_s
				off += Vector2(sin(t * 71.0 + ph) * am, cos(t * 53.0 + ph) * am * 0.6)
		if it.alt != null and fx.get("blink") is Dictionary:
			var bl = fx.blink
			var ev2 = maxf(J.num(bl.get("every", 3.2)), 0.2)
			var want = it.alt if fmod(t + ph * 1.9, ev2) < J.num(bl.get("dur", 0.14)) else it.main
			if n.texture != want: n.texture = want
		if fx.get("flicker") is Dictionary:   # 燈籠閃：幾條唔同頻率嘅正弦疊埋，似火光唔規則
			var fl = fx.flicker
			var nz = 0.5 + 0.5 * (0.5 * sin(t * 7.3 + ph * 3.1) + 0.3 * sin(t * 13.7 + ph) + 0.2 * sin(t * 2.1 + ph * 5.0))
			var v = lerpf(J.num(fl.get("min", 0.88)), J.num(fl.get("max", 1.12)), nz)
			n.modulate = Color(v, v, v, 1.0)
			if it.glow != null:
				var g: TextureRect = it.glow
				g.position = it.pos + off + n.size / 2.0 - g.size / 2.0 + Vector2(0, n.size.y * 0.1)
				g.modulate.a = J.num(fl.get("glow", 0.55)) * (0.6 + 0.4 * nz)
				g.scale = Vector2.ONE * (0.92 + 0.12 * nz)
		if fx.get("drift") is Dictionary:   # 炊煙：向上飄、淡入淡出，兩份錯開
			var dr = fx.drift
			var per = maxf(J.num(dr.get("per", 4.0)), 0.2); var dy = J.num(dr.get("dy", 0.014)) * tsz.y * cover_s
			var pa = fmod(t + ph, per) / per
			n.modulate.a = sin(pa * PI)
			off.y -= dy * pa
			if it.twin != null:
				var pb = fmod(t + ph + per / 2.0, per) / per
				it.twin.position = it.pos + off + Vector2(0, dy * pa - dy * pb)
				it.twin.modulate.a = sin(pb * PI)
		n.position = it.pos + off
		n.scale = Vector2(sc, sc); n.rotation = rot
	return cz

func free_all() -> void:
	if root != null and is_instance_valid(root): root.queue_free()
	items.clear(); parts.clear()
