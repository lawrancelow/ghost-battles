# 夜班巡陰（原生）：共用圖像工具——貼圖、網格快取、CSS 濾鏡矩陣、漸變貼圖、字型
class_name PtGfx
extends RefCounted

const PT_DIR := "res://assets/img/patrol_assets/"
static var _tex := {}
static var _mesh := {}
static var _mat := {}
static var SH_MESH: Shader
static var SH_SPR: Shader
static var SH_HUE: Shader
static var SH_HUE_MIX: Shader
static var RAD: Texture2D      # 白色放射漸變（中心實、邊透明）
static var RAD_SOFT: Texture2D # 放射漸變（較柔）
static var _font := {}

static func init() -> void:
	if SH_MESH != null: return
	SH_MESH = load("res://game/patrol/pt_mesh.gdshader")
	SH_SPR = load("res://game/patrol/pt_sprite.gdshader")
	SH_HUE = load("res://game/patrol/pt_hue.gdshader")
	SH_HUE_MIX = load("res://game/patrol/pt_hue_mix.gdshader")
	RAD = _radial([[0.0, 1.0], [1.0, 0.0]])
	RAD_SOFT = _radial([[0.0, 1.0], [0.35, 0.55], [1.0, 0.0]])

static func _radial(stops: Array) -> Texture2D:
	var g = Gradient.new(); var offs = PackedFloat32Array(); var cols = PackedColorArray()
	for s in stops: offs.append(s[0]); cols.append(Color(1, 1, 1, s[1]))
	g.offsets = offs; g.colors = cols
	var t = GradientTexture2D.new(); t.gradient = g; t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5); t.fill_to = Vector2(1.0, 0.5); t.width = 128; t.height = 128
	return t

static func font(w := 900) -> Font:
	if not _font.has(w): _font[w] = UIKit.font("sans", w)
	return _font[w]

# 角色／特效貼圖：Spr（蠟筆原畫）→ 巡陰素材（patrol_assets）
static func tex(k: String) -> Texture2D:
	if _tex.has(k): return _tex[k]
	var t: Texture2D = null
	if Spr.ok(k): t = Spr.get_tex(k)
	elif ResourceLoader.exists(PT_DIR + k + ".webp"): t = load(PT_DIR + k + ".webp")
	_tex[k] = t
	return t

# ---------------- CSS 濾鏡 → 3×3 顏色矩陣 ----------------
static func m_sepia(a: float) -> Basis:
	var k = 1.0 - a
	return Basis(Vector3(0.393 + 0.607 * k, 0.349 - 0.349 * k, 0.272 - 0.272 * k), Vector3(0.769 - 0.769 * k, 0.686 + 0.314 * k, 0.534 - 0.534 * k), Vector3(0.189 - 0.189 * k, 0.168 - 0.168 * k, 0.131 + 0.869 * k))
static func m_hue(deg: float) -> Basis:
	var a = deg_to_rad(deg); var c = cos(a); var s = sin(a)
	# 行優先寫法（同 CSS 規範），Basis 用列向量
	var r0 = Vector3(0.213 + c * 0.787 - s * 0.213, 0.715 - c * 0.715 - s * 0.715, 0.072 - c * 0.072 + s * 0.928)
	var r1 = Vector3(0.213 - c * 0.213 + s * 0.143, 0.715 + c * 0.285 + s * 0.140, 0.072 - c * 0.072 - s * 0.283)
	var r2 = Vector3(0.213 - c * 0.213 - s * 0.787, 0.715 - c * 0.715 + s * 0.715, 0.072 + c * 0.928 + s * 0.072)
	return _rows(r0, r1, r2)
static func m_sat(v: float) -> Basis:
	var r0 = Vector3(0.213 + 0.787 * v, 0.715 - 0.715 * v, 0.072 - 0.072 * v)
	var r1 = Vector3(0.213 - 0.213 * v, 0.715 + 0.285 * v, 0.072 - 0.072 * v)
	var r2 = Vector3(0.213 - 0.213 * v, 0.715 - 0.715 * v, 0.072 + 0.928 * v)
	return _rows(r0, r1, r2)
static func m_bright(v: float) -> Basis: return Basis(Vector3(v, 0, 0), Vector3(0, v, 0), Vector3(0, 0, v))
static func m_gray(a: float) -> Basis:
	var k = 1.0 - a
	return _rows(Vector3(0.2126 + 0.7874 * k, 0.7152 - 0.7152 * k, 0.0722 - 0.0722 * k), Vector3(0.2126 - 0.2126 * k, 0.7152 + 0.2848 * k, 0.0722 - 0.0722 * k), Vector3(0.2126 - 0.2126 * k, 0.7152 - 0.7152 * k, 0.0722 + 0.9278 * k))
static func _rows(r0: Vector3, r1: Vector3, r2: Vector3) -> Basis:
	# Basis(x,y,z) 係三條列；shader mat3 * v 用列：結果 = x*v.x + y*v.y + z*v.z → 列 x = (r0.x, r1.x, r2.x)
	return Basis(Vector3(r0.x, r1.x, r2.x), Vector3(r0.y, r1.y, r2.y), Vector3(r0.z, r1.z, r2.z))
static func css_filter(s: String) -> Basis:
	var m = Basis.IDENTITY
	for part in s.split(")", false):
		var p = part.strip_edges()
		if p == "": continue
		var nm = p.get_slice("(", 0).strip_edges(); var arg = p.get_slice("(", 1).strip_edges()
		var v = arg.to_float()
		if arg.ends_with("deg"): v = arg.trim_suffix("deg").to_float()
		elif arg.ends_with("%"): v = arg.trim_suffix("%").to_float() / 100.0
		var f = Basis.IDENTITY
		match nm:
			"sepia": f = m_sepia(v)
			"hue-rotate": f = m_hue(v)
			"saturate": f = m_sat(v)
			"brightness": f = m_bright(v)
			"grayscale": f = m_gray(v)
		m = f * m   # 後面嘅濾鏡後做
	return m

# 特效色相材質（疊光／普通），按 hue 快取
static func hue_mat(hue: float, add: bool) -> Material:
	var key = "%d_%s" % [int(hue), add]
	if _mat.has(key): return _mat[key]
	var m = ShaderMaterial.new(); m.shader = SH_HUE if add else SH_HUE_MIX
	m.set_shader_parameter("cm", m_sat(1.2) * m_hue(hue) if hue != 0.0 else Basis.IDENTITY)
	_mat[key] = m
	return m

# ---------------- 網格（同 meshanim 一樣嘅格仔同權重；只保留最重嘅 4 條骨）----------------
const GX := 14
const GY := 20
static func _seg_dist(px: float, py: float, ax: float, ay: float, bx: float, by: float) -> float:
	var dx = bx - ax; var dy = by - ay; var l = dx * dx + dy * dy
	if l == 0.0: l = 1e-6
	var t = clampf(((px - ax) * dx + (py - ay) * dy) / l, 0.0, 1.0)
	return Vector2(px - ax - t * dx, py - ay - t * dy).length()

static func mesh_for(img_key: String, rig_key: String, bones: Array) -> Dictionary:
	var key = img_key + "|" + rig_key
	if _mesh.has(key): return _mesh[key]
	var tex: Texture2D = tex(img_key)
	if tex == null: _mesh[key] = {}; return {}
	var ar = float(tex.get_height()) / tex.get_width()
	var verts = PackedVector2Array(); var uvs = PackedVector2Array(); var c0 = PackedFloat32Array(); var c1 = PackedFloat32Array()
	var nb = bones.size()
	for j in range(GY + 1):
		for i in range(GX + 1):
			var u = float(i) / GX; var v = float(j) / GY
			var w = []; var sum = 0.0
			for k in nb:
				var b: Array = bones[k]
				var d = _seg_dist(u, v * ar, J.num(b[2]), J.num(b[3]) * ar, J.num(b[4]), J.num(b[5]) * ar) / J.num(b[6])
				var ww = exp(-d * d * 2.2)
				if b[1] == null: ww = maxf(ww, 0.05)
				w.append([ww, k]); sum += ww
			for q in w: q[0] /= sum
			w.sort_custom(func(a, b): return a[0] > b[0])
			var tot = 0.0
			for q in 4: if q < w.size(): tot += w[q][0]
			for q in 4:
				if q < w.size(): c0.append(w[q][0] / tot); c1.append(float(w[q][1]))
				else: c0.append(0.0); c1.append(0.0)
			verts.push_back(Vector2(u, v)); uvs.push_back(Vector2(u, v))
	var img = tex.get_image()
	if img and img.is_compressed(): img.decompress()
	var iw = tex.get_width(); var ih = tex.get_height()
	if img and (img.get_width() != iw): img.resize(iw, ih)
	var idx = PackedInt32Array()
	for j in range(GY):
		for i in range(GX):
			var hit = true
			if img:
				hit = false
				var x0 = maxi(0, int(floor(float(i) / GX * iw)) - 2); var x1 = mini(iw, int(ceil(float(i + 1) / GX * iw)) + 2)
				var y0 = maxi(0, int(floor(float(j) / GY * ih)) - 2); var y1 = mini(ih, int(ceil(float(j + 1) / GY * ih)) + 2)
				var y = y0
				while y < y1 and not hit:
					var x = x0
					while x < x1:
						if img.get_pixel(x, y).a > 4.0 / 255.0: hit = true; break
						x += 2
					y += 2
			if not hit: continue
			var a = j * (GX + 1) + i; var b2 = a + 1; var c = a + GX + 1; var d2 = c + 1
			idx.append_array([a, b2, c, b2, d2, c])
	var arr = []; arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts; arr[Mesh.ARRAY_TEX_UV] = uvs; arr[Mesh.ARRAY_CUSTOM0] = c0; arr[Mesh.ARRAY_CUSTOM1] = c1; arr[Mesh.ARRAY_INDEX] = idx
	var m = ArrayMesh.new()
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr, [], {}, (Mesh.ARRAY_CUSTOM_RGBA_FLOAT << Mesh.ARRAY_FORMAT_CUSTOM0_SHIFT) | (Mesh.ARRAY_CUSTOM_RGBA_FLOAT << Mesh.ARRAY_FORMAT_CUSTOM1_SHIFT))
	m.custom_aabb = AABB(Vector3(-4000, -4000, 0), Vector3(8000, 8000, 0))
	var out = {"mesh": m, "tex": tex, "ar": ar, "bones": bones}
	_mesh[key] = out
	return out

# 骨頭解算（同 meshanim.js solve 一樣）→ 每條骨 [cos, sin, tx, ty]
static func solve(bones: Array, pose: Dictionary) -> Array:
	var T = {}; var out = []
	for b in bones:
		var n = String(b[0]); var par = b[1]; var px: float = J.num(b[2]); var py: float = J.num(b[3])
		var pv = pose.get(n); var a: float = 0.0 if pv == null else J.num(pv)
		if is_nan(a): a = 0.0
		var P: Array = T[par] if par != null and T.has(par) else [0.0, 0.0, 0.0]
		var ppx: float = cos(P[0]) * px - sin(P[0]) * py + P[1]
		var ppy: float = sin(P[0]) * px + cos(P[0]) * py + P[2]
		var A: float = P[0] + a
		var tx = ppx - (cos(A) * px - sin(A) * py); var ty = ppy - (sin(A) * px + cos(A) * py)
		T[n] = [A, tx, ty]
		out.append(Vector4(cos(A), sin(A), tx, ty))
	while out.size() < 12: out.append(Vector4(1, 0, 0, 0))
	return out
