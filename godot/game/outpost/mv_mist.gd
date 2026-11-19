# [mapart] 通用「血霧」：建築底由地面滲出嚟嘅極暗紅霧，蓋住建築底同地面接縫，等新畫風建築同背景地圖融合。
#   老闆原話：「我想要讓建築物底部都加血霧的效果，以便更輕易和背景地圖融合」「更有陰森感，筆觸感且暗紅一點的」
#   色板（老闆畀）：#200201 → #070000（「這種程度的暗紅啊」）。主體 #1d0202（濃處）漸變到 #070000（薄邊），
#   筆觸 #200201／#2a0405／#180101，極少量 #3a0607。
# 做法：每種 (key, 闊級, 高級) 預先畫成 ImageTexture 快取（後層＋前層＋3–5 縷細絲）；每幀只做位移／透明度／斜切。
#   每層 = 柔和霧團（低解像計再放大，橢圓收邊）＋ 大量 1–3px 短蠟筆筆觸 ＋ 紙紋顆粒。
#   動態：霧團慢慢左右飄（前層兩份反方向）、濃淡呼吸、細絲由地面向上爬兼搖曳。
#   畫面外唔畫（用 CanvasItem 嘅全域變換對比 viewport）；未整嘅貼圖每幀最多整 GEN_PER_FRAME 份（唔會一入場卡死）。
#   純畫面：唔加 Node、唔登記撳位、唔改 mouse_filter → 唔擋點擊。
# ===== API（冇 class_name、冇 autoload；全部 static，全遊戲共用一份快取）=====
#   const MIST = preload("res://game/outpost/mv_mist.gd")
#   喺 _draw()（或者 draw 信號）入面：
#     MIST.draw(self, key, base, w, h, t, false)   # 後層：畫建築「之前」叫
#     （畫建築）
#     MIST.draw(self, key, base, w, h, t, true)    # 前層：畫建築「之後」叫
#   或者一句搞掂（後層 → 建築貼圖 → 前層）：
#     MIST.draw_both(self, key, base, w, h, t, tex, tex_rect)
#   key：種子（同 key 永遠同一個形狀，例如 "vil:house"、"pd:stall3"）；base：建築底中心（同 ci 本地座標）；
#   w、h：建築圖闊高；t：秒（例如 Time.get_ticks_msec() / 1000.0）；front：true 前層／false 後層。
#   回傳 true = 有畫；畫面外／貼圖今幀未輪到整 → false（要持續 queue_redraw，下一幀就有）。
#   場景載入時可以 MIST.prewarm(key, w, h) 預先整定；MIST.enabled = false 全部熄。
extends RefCounted

const SC := 1.0             # 貼圖解像（每個世界 px 幾多貼圖 px）
const LO := 4               # 霧團低解像格
const GEN_PER_FRAME := 2
const BODY := Color("#1d0202")    # 濃處
const DEEP := Color("#070000")    # 薄邊（色板尾）
const TOP := Color("#200201")     # 色板頭
const STROKES := [Color("#200201"), Color("#2a0405"), Color("#180101")]
const HI := Color("#3a0607")      # 極少量
const BACK_A := 0.55        # 後層主體最濃（較淡）
const FRONT_A := 0.75       # 前層主體最濃（較濃）
const STROKE_A := 0.85      # 筆觸最濃
const GRAIN_N := 65536

static var enabled := true
static var cache := {}      # "key|闊級|高級" → {seed, back, front, wisps:[{tex,u,ph,sp,h}]}
static var gen_n := 0       # 累計整咗幾多份（測試：快取生效 → 唔再加）
static var gen_ms := 0.0
static var draw_n := 0      # 累計有畫嘅層數
static var culled := 0      # 累計因畫面外而唔畫嘅層數
static var _budget := GEN_PER_FRAME
static var _bud_frame := -1
static var _G := PackedFloat32Array()
static var _UV_FLIP := PackedVector2Array([Vector2(0.85, 0.2), Vector2(0.15, 0.2), Vector2(0.15, 1), Vector2(0.85, 1)])
static var _UV := PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)])
static var _vf := -1            # 每幀每個 CanvasItem 只攞一次全域變換
static var _vci := 0
static var _vxf := Transform2D.IDENTITY
static var _vrect := Rect2()

static func bucket(v: float) -> int: return maxi(16, int(round(v / 16.0)) * 16)
static func seed_of(key: String) -> int: return absi(hash("mist:" + key)) % 2147483000
static func cache_key(key: String, w: float, h: float) -> String: return "%s|%d|%d" % [key, bucket(w), bucket(h)]
static func clear_cache() -> void: cache.clear()

# 兩層喺 ci 本地座標嘅範圍（base = 建築底中心）
static func back_rect(base: Vector2, w: float, h: float) -> Rect2:
	var bw = w * 1.75
	var bh = clampf(h * 0.30 + w * 0.22, w * 0.30, w * 0.60)
	return Rect2(base.x - bw * 0.5, base.y - bh * 0.62, bw, bh)
static func front_rect(base: Vector2, w: float, h: float) -> Rect2:
	var fw = w * 1.45
	var fh = clampf(h * 0.24 + w * 0.16, w * 0.26, w * 0.46)
	return Rect2(base.x - fw * 0.5, base.y - fh * 0.62, fw, fh)

static func _on_screen(ci: CanvasItem, r: Rect2) -> bool:
	if not ci.is_inside_tree(): return true
	var f = Engine.get_frames_drawn(); var id = ci.get_instance_id()
	if f != _vf or id != _vci:
		_vf = f; _vci = id; _vxf = ci.get_global_transform_with_canvas(); _vrect = ci.get_viewport_rect().grow(24.0)
	return _vrect.intersects(_vxf * r)

static func prewarm(key: String, w: float, h: float) -> void: entry(key, w, h, true)

static func entry(key: String, w: float, h: float, force := false):
	var ck = cache_key(key, w, h)
	if cache.has(ck): return cache[ck]
	var pf = Engine.get_process_frames()
	if pf != _bud_frame: _bud_frame = pf; _budget = GEN_PER_FRAME
	if not force and _budget <= 0: return null
	_budget -= 1
	var t0 = Time.get_ticks_usec()
	var bw = float(bucket(w)); var bh = float(bucket(h))
	var sd = seed_of(key)
	var rng = RandomNumberGenerator.new(); rng.seed = sd
	var br = back_rect(Vector2.ZERO, bw, bh); var fr = front_rect(Vector2.ZERO, bw, bh)
	var e = {"seed": sd,
		"back": _layer(rng, br.size, BACK_A, 0.58, 0.55),
		"front": _layer(rng, fr.size, FRONT_A, 0.56, 1.0),
		"wisps": []}
	for i in rng.randi_range(3, 5):
		var wh = fr.size.y * rng.randf_range(0.9, 1.4)
		e.wisps.append({"tex": _wisp(rng, wh), "u": rng.randf_range(-0.5, 0.5), "ph": rng.randf(), "sp": rng.randf_range(0.06, 0.11), "h": wh})
	# 每幀用嘅數值攤平（慳字典查找）：wf = [u, ph, sp, h, 闊高比] × n；wt = 貼圖
	var wf = PackedFloat32Array(); var wt = []
	for wi in e.wisps:
		wf.append_array([wi.u, wi.ph, wi.sp, wi.h, float(wi.tex.get_width()) / maxf(1.0, wi.tex.get_height())]); wt.append(wi.tex)
	e["wf"] = wf; e["wt"] = wt; e["ph"] = float(sd % 1000) * 0.0067
	cache[ck] = e
	gen_n += 1
	gen_ms += (Time.get_ticks_usec() - t0) / 1000.0
	return e

# ---------------- 畫 ----------------
static func draw(ci: CanvasItem, key: String, base: Vector2, w: float, h: float, t: float, front: bool) -> bool:
	if not enabled or ci == null or w < 4.0: return false
	var r = front_rect(base, w, h) if front else back_rect(base, w, h)
	var vis = r
	if front: vis = vis.expand(Vector2(r.get_center().x, r.position.y - r.size.y * 1.2))   # 細絲向上爬
	if not _on_screen(ci, vis): culled += 1; return false
	var e = entry(key, w, h)
	if e == null: return false
	var ph: float = e.ph
	if not front:
		var dx = sin(t * 0.21 + ph) * w * 0.03
		var a = 0.86 + 0.14 * sin(t * 0.55 + ph)
		ci.draw_texture_rect(e.back, Rect2(r.position + Vector2(dx, 0), r.size), false, Color(1, 1, 1, a))
	else:
		var dx = sin(t * 0.27 + ph) * w * 0.035
		var dy = sin(t * 0.19 + ph * 2.0) * 1.2
		ci.draw_texture_rect(e.front, Rect2(r.position + Vector2(dx, dy), r.size), false, Color(1, 1, 1, 0.82 + 0.16 * sin(t * 0.6 + ph)))
		# 第二份：左右反轉、反方向飄，只取中間一截 → 霧團互相穿插，似喺度翻湧
		var p = r.position + Vector2(r.size.x * 0.15 - dx * 0.8, r.size.y * 0.2 - dy)
		var s = Vector2(r.size.x * 0.7, r.size.y * 0.8)
		_quad(ci, e.front, p, s, 0.0, Color(1, 1, 1, 0.42 + 0.14 * sin(t * 0.47 + ph + 1.7)), _UV_FLIP)
		# 細絲：由地面慢慢向上爬，搖曳，到頂淡出
		var sy = h / maxf(1.0, float(bucket(h)))
		var wf: PackedFloat32Array = e.wf; var wt: Array = e.wt
		var y0 = base.y + r.size.y * 0.3; var yr = r.size.y * 1.1
		for i in wt.size():
			var o = i * 5; var wph = wf[o + 1]
			var u = fmod(t * wf[o + 2] + wph, 1.0)
			var wh = wf[o + 3] * sy; var ww = wh * wf[o + 4]
			var cx = base.x + wf[o] * w + sin(t * 1.1 + wph * 9.0) * 2.5 - ww * 0.5
			var by = y0 - u * yr - wh
			var sk = sin(t * 0.9 + wph * 7.0) * wh * 0.2
			ci.draw_colored_polygon(PackedVector2Array([Vector2(cx + sk, by), Vector2(cx + ww + sk, by), Vector2(cx + ww, by + wh), Vector2(cx, by + wh)]),
				Color(1, 1, 1, 0.8 * sin(PI * u)), _UV, wt[i])
	draw_n += 1
	return true

# 便利：後層 →（有 tex 就畫建築貼圖喺 tex_rect）→ 前層
static func draw_both(ci: CanvasItem, key: String, base: Vector2, w: float, h: float, t: float, tex: Texture2D = null, tex_rect := Rect2()) -> bool:
	var a = draw(ci, key, base, w, h, t, false)
	if tex != null: ci.draw_texture_rect(tex, tex_rect if tex_rect.size != Vector2.ZERO else Rect2(base.x - w * 0.5, base.y - h, w, h), false)
	var b = draw(ci, key, base, w, h, t, true)
	return a or b

# 一個貼圖四邊形（頂邊向右斜 sk px；uv 0–1）
static func _quad(ci: CanvasItem, tex: Texture2D, p: Vector2, s: Vector2, sk: float, col: Color, uv: PackedVector2Array) -> void:
	var pts = PackedVector2Array([p + Vector2(sk, 0), p + Vector2(s.x + sk, 0), p + s, p + Vector2(0, s.y)])
	ci.draw_colored_polygon(pts, col, uv, tex)

# ---------------- 整貼圖 ----------------
static func _grain() -> PackedFloat32Array:   # 紙紋顆粒（全部共用，固定種子）
	if _G.size() == GRAIN_N: return _G
	var r = RandomNumberGenerator.new(); r.seed = 20261119
	_G.resize(GRAIN_N)
	for i in GRAIN_N: _G[i] = 0.6 + 0.4 * r.randf()
	return _G

# 一層霧：size（世界 px）；amax 主體最濃；cy 霧團中心（由頂計 0–1）；dens 筆觸密度
static func _layer(rng: RandomNumberGenerator, size: Vector2, amax: float, cy: float, dens: float) -> ImageTexture:
	var W = maxi(8, int(size.x * SC)); var H = maxi(8, int(size.y * SC))
	# 1) 霧團（低解像）
	var lw = W / LO + 2; var lh = H / LO + 2
	var A = PackedFloat32Array(); A.resize(lw * lh)
	var nb = 14 + rng.randi_range(0, 8)
	for i in nb:
		var bx = rng.randf_range(0.1, 0.9) * lw
		var byy = (cy + rng.randf_range(-0.16, 0.18)) * lh
		var rx = rng.randf_range(0.10, 0.24) * lw; var ry = rng.randf_range(0.18, 0.34) * lh
		var amp = rng.randf_range(0.45, 0.9)
		var x0 = maxi(0, int(bx - rx * 1.6)); var x1 = mini(lw - 1, int(bx + rx * 1.6))
		var y0 = maxi(0, int(byy - ry * 1.6)); var y1 = mini(lh - 1, int(byy + ry * 1.6))
		for yy in range(y0, y1 + 1):
			var dy = (yy - byy) / ry
			for xx in range(x0, x1 + 1):
				var dx = (xx - bx) / rx
				var d = dx * dx + dy * dy
				if d < 2.6:
					var j = yy * lw + xx
					A[j] = A[j] + amp * exp(-d * 1.6) * (1.0 - A[j])
	# 橢圓收邊（唔見方邊），再正規化到最濃 = 1
	var mx = 0.001
	for yy in lh:
		var vy = (float(yy) / (lh - 1) - 0.5) / 0.5
		for xx in lw:
			var vx = (float(xx) / (lw - 1) - 0.5) / 0.5
			var x2 = vx * vx
			var d = x2 * x2 * 0.6 + x2 * 0.4 + vy * vy      # 扁闊嘅超橢圓：中間大片濃，邊位先散
			var m = clampf((1.0 - d) / 0.6, 0.0, 1.0)
			var j = yy * lw + xx
			A[j] *= m * m * (3.0 - 2.0 * m)
			mx = maxf(mx, A[j])
	for j in A.size(): A[j] = minf(1.0, A[j] / mx * 1.2)
	var li = Image.create_from_data(lw, lh, false, Image.FORMAT_RF, A.to_byte_array())
	li.resize(W, H, Image.INTERPOLATE_BILINEAR)
	var AF = li.get_data().to_float32_array()
	# 2) 短蠟筆筆觸（1–3px，橫掃為主，兩頭尖）
	var SA = PackedFloat32Array(); SA.resize(W * H)
	var SI = PackedByteArray(); SI.resize(W * H)
	var ns = int(W * H / 55.0 * dens)
	var n = 0; var guard = 0
	while n < ns and guard < ns * 5:
		guard += 1
		var px = rng.randf() * W; var py = rng.randf() * H
		var base = AF[mini(H - 1, int(py)) * W + mini(W - 1, int(px))]
		if base < 0.12 or rng.randf() > base * 1.4: continue
		n += 1
		var ci = rng.randi_range(0, STROKES.size() - 1)
		if rng.randf() < 0.03: ci = STROKES.size()      # 極少量 #3a0607
		var ln = rng.randf_range(4.0, 13.0) * SC
		var ang = rng.randf_range(-0.35, 0.35) + (PI if rng.randf() < 0.5 else 0.0)
		var bend = rng.randf_range(-0.06, 0.06)
		var wd = 1 if rng.randf() < 0.5 else (2 if rng.randf() < 0.8 else 3)
		var sa = rng.randf_range(0.45, 1.0) * clampf(base * 1.5, 0.3, 1.0) * STROKE_A
		var steps = int(ln * 2.0)
		var cx = px; var cyy = py
		for s in steps:
			var u = float(s) / steps
			var a = ang + bend * s
			cx += cos(a) * 0.5; cyy += sin(a) * 0.5
			var aa = sa * (0.5 + 0.5 * sin(PI * clampf(u, 0.05, 0.95)))
			if rng.randf() < 0.18: continue                  # 蠟筆斷續（紙齒）
			for k in wd:
				var ix = int(cx); var iy = int(cyy) + k - wd / 2
				if ix < 0 or iy < 0 or ix >= W or iy >= H: continue
				var j = iy * W + ix
				if aa > SA[j]: SA[j] = aa; SI[j] = ci + 1
	# 3) 合成：主體顏色由密度決定（薄 #070000 → 濃 #1d0202），alpha × 紙紋；筆觸疊上
	var data = PackedByteArray(); data.resize(W * H * 4)
	var G = _grain()
	var go = rng.randi_range(0, GRAIN_N - 1)
	var sc_cols = STROKES + [HI]
	var br = BODY.r8; var bg = BODY.g8; var bb = BODY.b8
	var dr = DEEP.r8; var dg = DEEP.g8; var db = DEEP.b8
	for y in H:
		var row = y * W
		for x in W:
			var j = row + x
			var g = G[(x * 7 + y * 9973 + go) & (GRAIN_N - 1)]
			var d = AF[j]
			var ab = d * g * amax
			var o = j * 4
			var r8 = dr + (br - dr) * d; var g8 = dg + (bg - dg) * d; var b8 = db + (bb - db) * d
			var sa2 = SA[j]
			if sa2 > 0.0:
				var c: Color = sc_cols[SI[j] - 1]
				var k = clampf(sa2 / maxf(0.01, ab + sa2), 0.0, 1.0)
				r8 = lerpf(r8, c.r8, k); g8 = lerpf(g8, c.g8, k); b8 = lerpf(b8, c.b8, k)
				ab = maxf(ab, sa2 * (0.7 + 0.3 * g))
			data[o] = int(r8); data[o + 1] = int(g8); data[o + 2] = int(b8)
			data[o + 3] = int(clampf(ab, 0.0, STROKE_A) * 255.0)
	return ImageTexture.create_from_image(Image.create_from_data(W, H, false, Image.FORMAT_RGBA8, data))

# 一縷上升細絲：幼、彎、兩頭淡（#200201／#2a0405，偶爾 #3a0607）
static func _wisp(rng: RandomNumberGenerator, h: float) -> ImageTexture:
	var H = maxi(12, int(h * SC)); var W = maxi(8, int(h * SC * 0.3))
	var data = PackedByteArray(); data.resize(W * H * 4)
	var c: Color = [TOP, STROKES[1]][rng.randi_range(0, 1)] if rng.randf() < 0.85 else HI
	var ph = rng.randf() * TAU; var fq = rng.randf_range(0.8, 1.6); var amp = W * 0.3
	for strand in 2:
		var off = (strand - 0.5) * 1.5
		for yy in H:
			var v = float(yy) / (H - 1)
			var xc = W * 0.5 + sin(v * fq * TAU + ph + strand * 0.9) * amp * (0.4 + v * 0.6) + off
			var a = sin(PI * v) * (0.75 if strand == 0 else 0.4) * (0.6 + 0.4 * rng.randf())
			for dx in 2:
				var ix = int(xc) + dx
				if ix < 0 or ix >= W: continue
				var o = (yy * W + ix) * 4
				var aa = a * (1.0 if dx == 0 else 0.45)
				if aa * 255.0 > data[o + 3]:
					data[o] = c.r8; data[o + 1] = c.g8; data[o + 2] = c.b8; data[o + 3] = int(aa * 255.0)
	return ImageTexture.create_from_image(Image.create_from_data(W, H, false, Image.FORMAT_RGBA8, data))
