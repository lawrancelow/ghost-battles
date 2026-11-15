# 安全畫面模式用嘅骨架網格：CPU 蒙皮，唔用自訂 shader（pt_mesh.gdshader 嘅 CPU 版）
# 介面扮 MeshInstance2D＋ShaderMaterial：mesh、texture、set_shader_parameter()/get_shader_parameter()
# 參數同 shader 一樣：bone[12]（cos,sin,tx,ty）、dims(W,h,ar)、aff_a、aff_o、flash、mode（1＝衣服換色）、cm、clip_y、cloth_a
# 畫法：RenderingServer.canvas_item_add_triangle_array（即係 draw_polygon 嗰條路）＋ 頂點色做閃白／衣服剪裁
# 衣服換色：CPU 預先將原圖乘顏色矩陣，造一張染色貼圖（按 圖＋矩陣 快取）
class_name CpuSkin
extends Node2D

static var _geo := {}          # mesh instance id → {uv, idx, sv, so, sk, sw}
static var _tint := {}         # 貼圖 id＋矩陣 → 染色貼圖
static var stat_ms := 0.0      # 累計蒙皮時間（量效能用）
static var stat_n := 0

var mesh: ArrayMesh = null
var texture: Texture2D = null
var src: CpuSkin = null        # 衣服層：用返身體層今幀嘅蒙皮結果
var P := {"bone": [], "dims": Vector3(100, 100, 1), "aff_a": Vector4(1, 0, 0, 1), "aff_o": Vector2.ZERO, "flash": 0.0, "mode": 0.0, "cm": Basis.IDENTITY, "clip_y": Vector2(-1e6, 1e6), "cloth_a": 0.72}
var pts := PackedVector2Array()   # 今幀蒙皮結果（本地座標）
var _key = null

func set_shader_parameter(n: String, v) -> void:
	P[n] = v; queue_redraw()

func get_shader_parameter(n: String):
	return P.get(n)

static func _geo_of(m: ArrayMesh) -> Dictionary:
	var id = m.get_instance_id()
	if _geo.has(id): return _geo[id]
	var a = m.surface_get_arrays(0)
	var uv: PackedVector2Array = a[Mesh.ARRAY_TEX_UV]
	var idx: PackedInt32Array = a[Mesh.ARRAY_INDEX]
	var c0: PackedFloat32Array = a[Mesh.ARRAY_CUSTOM0]; var c1: PackedFloat32Array = a[Mesh.ARRAY_CUSTOM1]
	# 稀疏：只計有三角形用到嘅頂點、只計權重 ≥ 0.002 嘅骨
	var used = {}
	for i in idx: used[i] = true
	var vs = used.keys(); vs.sort()
	var sv = PackedInt32Array(); var so = PackedInt32Array(); var sk = PackedInt32Array(); var sw = PackedFloat32Array()
	for i in vs:
		sv.push_back(i); so.push_back(sk.size())
		for q in 4:
			var w = c0[i * 4 + q]
			if w >= 0.002: sk.push_back(int(c1[i * 4 + q] + 0.5)); sw.push_back(w)
	so.push_back(sk.size())
	var g = {"uv": uv, "idx": idx, "sv": sv, "so": so, "sk": sk, "sw": sw}
	_geo[id] = g
	return g

func _skin(g: Dictionary) -> void:
	var bone: Array = P.bone
	var dims: Vector3 = P.dims; var aa: Vector4 = P.aff_a; var ao: Vector2 = P.aff_o
	var key = [mesh.get_instance_id(), bone, dims, aa, ao]
	if _key == key and pts.size() > 0: return
	_key = key
	var t0 = Time.get_ticks_usec()
	var nb = bone.size()
	var b0 = PackedFloat32Array(); b0.resize(12); var b1 = b0.duplicate(); var b2 = b0.duplicate(); var b3 = b0.duplicate()
	for k in 12:
		var q: Vector4 = bone[k] if k < nb else Vector4(1, 0, 0, 0)
		b0[k] = q.x; b1[k] = q.y; b2[k] = q.z; b3[k] = q.w
	var uv: PackedVector2Array = g.uv
	var sv: PackedInt32Array = g.sv; var so: PackedInt32Array = g.so; var sk: PackedInt32Array = g.sk; var sw: PackedFloat32Array = g.sw
	if pts.size() != uv.size(): pts.resize(uv.size())
	var ar = dims.z; var W = dims.x; var hy = dims.y / ar
	for n in sv.size():
		var i = sv[n]
		var u = uv[i].x; var vy = uv[i].y * ar; var X = 0.0; var Y = 0.0
		for j in range(so[n], so[n + 1]):
			var k = sk[j]; var wk = sw[j]
			X += wk * (b0[k] * u - b1[k] * vy + b2[k]); Y += wk * (b1[k] * u + b0[k] * vy + b3[k])
		var lx = X * W; var ly = Y * hy
		pts[i] = Vector2(aa.x * lx + aa.z * ly + ao.x, aa.y * lx + aa.w * ly + ao.y)
	stat_ms += (Time.get_ticks_usec() - t0) / 1000.0; stat_n += 1

static var _first := true
func _draw() -> void:
	if mesh == null or texture == null: return
	if _first:   # 第一次 CPU 蒙皮落畫面：留記號，閃退下次會自動轉安全畫面
		_first = false; G.crumb("draw:cpuskin")
		RenderingServer.frame_post_draw.connect(func(): G.crumb("draw:cpuskin_ok"), CONNECT_ONE_SHOT)
	var g = _geo_of(mesh)
	var idx: PackedInt32Array = g.idx
	if idx.is_empty(): return
	if src != null and src.mesh == mesh and src._key != null and src.pts.size() == g.uv.size() and src.P.bone == P.bone and src.P.aff_o == P.aff_o:
		pts = src.pts
	else: _skin(g)
	var fl = 1.0 + float(P.flash) * 0.8
	var tex = texture
	var cols = PackedColorArray()
	var ii = idx
	if float(P.mode) > 0.5:
		tex = tint_tex(texture, P.cm)
		var cy: Vector2 = P.clip_y; var ca = float(P.cloth_a)
		cols.resize(pts.size())
		for i in pts.size():
			var y = pts[i].y
			cols[i] = Color(fl, fl, fl, ca if y >= cy.x and y <= cy.y else 0.0)
		# 剪裁：三個頂點都喺範圍外嘅三角形唔畫；跨界嘅用頂點透明度漸變
		ii = PackedInt32Array()
		for t in range(0, idx.size(), 3):
			if cols[idx[t]].a > 0.0 or cols[idx[t + 1]].a > 0.0 or cols[idx[t + 2]].a > 0.0:
				ii.push_back(idx[t]); ii.push_back(idx[t + 1]); ii.push_back(idx[t + 2])
		if ii.is_empty(): return
	else:   # 每個頂點一個顏色（同 Ctx.drawTriangles 一樣；單一顏色嘅寫法喺部分 Adreno 會閃退）
		cols.resize(pts.size()); cols.fill(Color(fl, fl, fl, 1.0))
	RenderingServer.canvas_item_add_triangle_array(get_canvas_item(), ii, pts, cols, g.uv, PackedInt32Array(), PackedFloat32Array(), tex.get_rid())

# 衣服換色：CPU 將原圖每點 rgb 乘顏色矩陣（同 shader：clamp(cm * rgb)），結果快取
static func tint_tex(tex: Texture2D, cm: Basis) -> Texture2D:
	var key = "%d|%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f" % [tex.get_instance_id(), cm.x.x, cm.x.y, cm.x.z, cm.y.x, cm.y.y, cm.y.z, cm.z.x, cm.z.y, cm.z.z]
	if _tint.has(key): return _tint[key]
	var img = tex.get_image()
	if img == null: _tint[key] = tex; return tex
	img = img.duplicate()
	if img.is_compressed(): img.decompress()
	img.convert(Image.FORMAT_RGBA8)
	# 大圖先縮細（衣服層本身係 72% 半透明疊上去，細少少睇唔出）
	var mx = 512
	if img.get_height() > mx: img.resize(maxi(1, img.get_width() * mx / img.get_height()), mx, Image.INTERPOLATE_BILINEAR)
	var d: PackedByteArray = img.get_data()
	var m00 = cm.x.x; var m10 = cm.x.y; var m20 = cm.x.z
	var m01 = cm.y.x; var m11 = cm.y.y; var m21 = cm.y.z
	var m02 = cm.z.x; var m12 = cm.z.y; var m22 = cm.z.z
	var i = 0; var n = d.size()
	while i < n:
		if d[i + 3] != 0:
			var r = d[i]; var g = d[i + 1]; var b = d[i + 2]
			d[i] = clampi(int(m00 * r + m01 * g + m02 * b + 0.5), 0, 255)
			d[i + 1] = clampi(int(m10 * r + m11 * g + m12 * b + 0.5), 0, 255)
			d[i + 2] = clampi(int(m20 * r + m21 * g + m22 * b + 0.5), 0, 255)
		i += 4
	var out = ImageTexture.create_from_image(Image.create_from_data(img.get_width(), img.get_height(), false, Image.FORMAT_RGBA8, d))
	_tint[key] = out
	return out
