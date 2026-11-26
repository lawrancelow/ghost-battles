# [p44] 最高階立繪「撐爆畫框」（老闆 11-26：所有第三階級嘅圖鑑名冊都要有啲撐爆畫框嘅感覺）
#   全部 static；冇 class_name（熱更新規矩）。
#   邊啲算最高階（lvl）：三階王牌第三階（★5）＝1；酒吞童子第三階（★4）＝1、第四階（★5）＝2（更強烈）。其餘＝0，照舊縮入框。
#   畫法（唔加光效、唔加粒子）：
#     1. 框背景＋成個框先畫（上緣會俾立繪遮住）；框頂一條好淡嘅高光線。
#     2. 立繪投影（只喺框入面，偏右下）→ 立繪本身：放大，頭／角／帽越過框上緣（框高 15%／20%），
#        上半身左右少少越界（sd px，向下收窄，出框部分向外淡出）；下半身喺框內、喺框底（yc）裁走。
#     3. 框底緣＋下半段左右框邊＋框底內陰影畫喺立絵前面 → 似「由框入面衝出嚟」。
#     4. 文字（名、星、品級）一律唔畫喺越界範圍；格頂嘅編號／品級牌喺立繪之後畫、墊紙底，永遠睇得清。
#   越界部分全部留喺控件自己範圍內（預留頂部空位、左右留邊），ScrollContainer 裁切唔會切到、亦唔會蓋住隔籬卡嘅字。
#   測試掛鈎：每個控件記低 brk（[框, 立繪實際畫咗嘅範圍, 唔可以遮嘅文字範圍...]，本地座標）
extends RefCounted

const ACE = preload("res://game/soul/ace_art.gd")
const OVER := [0.0, 0.15, 0.20]   # 上緣超出（框高比例）
const SIDE_K := [0.0, 1.0, 1.35]  # 左右越界倍數
static var force := -1            # 測試：強制 lvl

static func lvl(k: String) -> int:
	if force >= 0: return force
	if not ACE.has(k): return 0
	var s = ACE.stage(k)
	if ACE.map(k) != ACE.key(k, s): return 0   # 冇階段圖／對話中
	if ACE.n_stages(k) >= 4: return 2 if s >= 4 else (1 if s == 3 else 0)
	return 1 if s >= 3 else 0
static func over(l: int) -> float: return OVER[clampi(l, 0, 2)]
static func pad(l: int, frame_h: float) -> float: return ceilf(over(l) * frame_h) + 2.0 if l > 0 else 0.0

# 立繪擺位：頂＝框頂 − over×框高；高度令「框頂越界位 → yc」佔立繪 v；闊最多 框闊×wkmax
static func place(tex: Texture2D, F: Rect2, yc: float, l: int, v: float, wkmax: float) -> Rect2:
	var tw = maxf(1.0, tex.get_width()); var th = maxf(1.0, tex.get_height())
	var T = F.position.y - over(l) * F.size.y
	var h = (yc - T) / v
	var w = h * tw / th
	var wm = F.size.x * wkmax * (1.06 if l >= 2 else 1.0)
	if w > wm: w = wm; h = w * th / tw
	return Rect2(F.get_center().x - w / 2, T, w, h)

# 畫立繪（連投影）；返回實際畫咗嘅範圍
#   F：畫框外框；yc：框內底（以下裁走）；ins：框邊厚；sd：左右越界上限 px；ymin：控件頂（唔畫出控件）
#   做法：立繪切成網格（一次 triangle array），每個頂點按遮罩給 alpha：框內＝1；框頂以上可以出框 sd，
#         框頂以下 tap 範圍內越界闊度逐漸收窄到 0；出框部分向外線性淡出（冇硬切邊）。
static func draw_art(ci: CanvasItem, tex: Texture2D, F: Rect2, yc: float, l: int, v: float, wkmax: float, sd: float, mod := Color.WHITE, ins := 2.0, ymin := -INF) -> Rect2:
	if tex == null: return Rect2()
	var A = place(tex, F, yc, l, v, wkmax)
	sd *= SIDE_K[clampi(l, 0, 2)]
	var inner = Rect2(F.position.x + ins, F.position.y + ins, F.size.x - ins * 2, yc - F.position.y - ins)
	# 投影：只喺框入面
	var sh = A; sh.position += Vector2(3, 4)
	_blit(ci, tex, sh, inner, Color(0, 0, 0, 0.22 * mod.a))
	var ext = sd + ins
	var ty = F.position.y + ins; var tap = F.size.y * 0.24
	var y_top = maxf(A.position.y, ymin); var y_bot = minf(A.end.y, yc)
	if y_bot <= y_top: return Rect2()
	# 網格線
	var xs = []
	var NX = 5
	for i in NX: xs.append(inner.position.x - ext + ext * i / NX)
	xs.append(inner.position.x); xs.append(inner.end.x)
	for i in NX: xs.append(inner.end.x + ext * (i + 1) / NX)
	var ys = [y_top]
	if ty > y_top:
		for i in 3: ys.append(y_top + (minf(ty, y_bot) - y_top) * (i + 1) / 3.0)
	var NY = 10
	for i in NY:
		var y = ty + tap * (i + 1) / NY
		if y > ys[-1] + 0.01 and y < y_bot: ys.append(y)
	if y_bot > ys[-1] + 0.01: ys.append(y_bot)
	var xa = []
	for x in xs: xa.append(clampf(x, A.position.x, A.end.x))
	var pts = PackedVector2Array(); var cols = PackedColorArray(); var uvs = PackedVector2Array(); var idx = PackedInt32Array()
	var got = Rect2()
	var nx = xa.size(); var ny = ys.size()
	for yi in ny:
		for xi in nx:
			var p = Vector2(xa[xi], ys[yi])
			pts.append(p)
			uvs.append((p - A.position) / A.size)
			cols.append(Color(mod, mod.a * _mask(p, inner, ext, ty, tap)))
	for yi in ny - 1:
		for xi in nx - 1:
			var a = yi * nx + xi; var b = a + 1; var c = a + nx; var d = c + 1
			if xa[xi + 1] - xa[xi] < 0.01: continue
			var mx = maxf(maxf(cols[a].a, cols[b].a), maxf(cols[c].a, cols[d].a))
			if mx <= 0.001: continue
			idx.append_array([a, b, d, a, d, c])
			got = _acc(got, Rect2(pts[a], pts[d] - pts[a]))
	if idx.size() > 0:
		var rid = tex.get_rid()
		if tex is AtlasTexture and tex.atlas != null:   # 圖集：UV 換算去原圖
			var asz = Vector2(tex.atlas.get_size()); var rg: Rect2 = tex.region
			for i in uvs.size(): uvs[i] = (rg.position + uvs[i] * rg.size) / asz
			rid = tex.atlas.get_rid()
		RenderingServer.canvas_item_add_triangle_array(ci.get_canvas_item(), idx, pts, cols, uvs, PackedInt32Array(), PackedFloat32Array(), rid)
	return got
# 遮罩：框內 1；框外按越界闊度 e(y) 向外淡出
static func _mask(p: Vector2, inner: Rect2, ext: float, ty: float, tap: float) -> float:
	if p.x >= inner.position.x - 0.01 and p.x <= inner.end.x + 0.01: return 1.0
	var d = (inner.position.x - p.x) if p.x < inner.position.x else (p.x - inner.end.x)
	var e = ext if p.y <= ty else ext * (1.0 - (p.y - ty) / tap)
	if e <= 0.01: return 0.0
	var a = clampf(1.0 - d / e, 0.0, 1.0)
	return a * a * (3.0 - 2.0 * a) * 0.95   # smoothstep
static func _acc(a: Rect2, b: Rect2) -> Rect2:
	if b.size.x <= 0 or b.size.y <= 0: return a
	if a.size.x <= 0: return b
	return a.merge(b)
# 將立繪 A 喺 clip 範圍入面嗰部分畫出嚟（按比例裁原圖）
static func _blit(ci: CanvasItem, tex: Texture2D, A: Rect2, clip: Rect2, col: Color) -> Rect2:
	var R = A.intersection(clip)
	if R.size.x <= 0.01 or R.size.y <= 0.01: return Rect2()
	var tw = float(tex.get_width()); var th = float(tex.get_height())
	var src = Rect2((R.position.x - A.position.x) / A.size.x * tw, (R.position.y - A.position.y) / A.size.y * th, R.size.x / A.size.x * tw, R.size.y / A.size.y * th)
	ci.draw_texture_rect_region(tex, R, src, col)
	return R
# 框頂淡高光（畫喺立繪後面）
static func top_light(ci: CanvasItem, F: Rect2, ins := 2.0) -> void:
	ci.draw_line(Vector2(F.position.x + ins + 1, F.position.y + ins + 1.5), Vector2(F.end.x - ins - 1, F.position.y + ins + 1.5), Color(1, 0.96, 0.82, 0.55), 1.2)
# 框底內陰影（畫喺立繪前面）：yc 對上一截由透明漸變到淡黑
static func bottom_shade(ci: CanvasItem, F: Rect2, yc: float, ins := 2.0, hk := 0.1) -> void:
	var x0 = F.position.x + ins; var x1 = F.end.x - ins; var y0 = yc - F.size.y * hk
	ci.draw_polygon(PackedVector2Array([Vector2(x0, y0), Vector2(x1, y0), Vector2(x1, yc), Vector2(x0, yc)]),
		PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 0.26), Color(0, 0, 0, 0.26)]))

# ---------------- 名冊／招降／升職／突破 頭像框（取代 PanelContainer＋TextureRect） ----------------
static func por(k: String, size: int, alpha := 1.0) -> Control:
	var p = Por.new(); p.k = k; p.S = float(size + 4); p.l = lvl(k); p.alpha = alpha
	p.tex = load("res://game/soul/soul_fx.gd").tex_of(k)
	p.setup()
	return p

class Por extends Control:
	const AF = preload("res://game/soul/ace_frame.gd")
	var k := ""
	var S := 64.0        # 框邊長（同舊 PanelContainer 一樣：size+4）
	var l := 1
	var alpha := 1.0
	var tex: Texture2D = null
	var F := Rect2()
	var brk := []        # [框, 立繪範圍]
	const SD := 4.0
	func setup() -> void:
		var pd = AF.pad(l, S)
		var sd = SD * AF.SIDE_K[clampi(l, 0, 2)]
		F = Rect2(sd + 1, pd, S, S)
		custom_minimum_size = Vector2(S + sd * 2 + 2, S + pd)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	func _draw() -> void:
		var ins = 1.5
		var bg = UIKit.sb(Color(0.17, 0.12, 0.1, 0.9), 6, Color("#6a5040"), 1)
		draw_style_box(bg, F)
		AF.top_light(self, F, ins)
		var yc = F.end.y - ins
		var A = AF.draw_art(self, tex, F, yc, l, 0.6, 2.1, SD, Color(1, 1, 1, alpha), ins, 0.0)
		AF.bottom_shade(self, F, yc, ins, 0.16)
		# 框底緣＋下半段框邊（喺立繪前面）
		var ec = Color("#6a5040"); var y1 = F.position.y + F.size.y * 0.3
		draw_line(Vector2(F.position.x + 3, F.end.y - 0.5), Vector2(F.end.x - 3, F.end.y - 0.5), ec, 1.5)
		draw_line(Vector2(F.position.x + 0.5, y1), Vector2(F.position.x + 0.5, F.end.y - 3), ec, 1.2)
		draw_line(Vector2(F.end.x - 0.5, y1), Vector2(F.end.x - 0.5, F.end.y - 3), ec, 1.2)
		brk = [F, A]
