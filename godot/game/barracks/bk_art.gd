# [barracks] 兵營建築圖＋陰兵畫法——全部集中喺呢個檔，之後換圖只改呢度
#
# 1) 兵營建築 draw_building(ctx, x, y, lv, t)：正式圖 assets/spr/barracks.webp（518×552 透明底，spr_manifest 鍵 "barracks"），
#    闊 BW＝100 世界 px（同民宅、倉庫等可見大細協調；支旗令佢高少少）。冇圖先用拼湊暫代（尖木柵＋草棚＋兵器架＋軍旗）。
#    未起／可重建：照其他建築用 Art.draw_ruin（廢墟＋木牌），唔使另外處理。
# 2) 陰兵 draw_soldier(ci, pose, ph, dir, seed, base)：
#    pose：stand（企）／walk（行）／salute（敬禮）／attack（打）；ph＝動畫相位（秒）；dir＝1 向右／-1 向左；原點＝腳底（煙尾尖）
#    【換圖接口：只改呢度】每姿勢一張透明圖，spr_manifest 鍵 soldier_stand / soldier_walk / soldier_salute / soldier_attack
#      （assets/spr/soldier_*.webp；而家用老闆揀嘅預設款＝教官款 opt3，煙尾已經喺圖入面）。
#      規格：全部面向右（向左程式自動左右翻轉）；煙尾尖喺圖底；四張要同一比例畫（程式按「企」嗰張嘅高度統一縮放到 H）。
#      腳底對位自動計：每張圖底部 15% 嘅不透明位置重心＝落腳點，換圖唔使手調。
#      動畫：行＝輕微上下浮動＋輕微擺；企＝呼吸；敬禮＝定住；打＝向前衝。冇齊四張圖就用下面嘅程序暫代。
#      （可選）一張圖入面橫排幾格動畫：喺 FRAMES 填格數，例如 {"walk": 4}。
extends RefCounted

const POSES := ["stand", "walk", "salute", "attack"]
const FRAMES := {}                  # 例：{"walk": 4} → soldier_walk 係橫排 4 格
const FPS := 8.0
const H := 46.0                      # 陰兵（企）連頭盔紅纓嘅高（世界 px；村內亡魂約 41–47、主角約 58）
const BW := 100.0

static var _img := {}
static var _ax := {}                 # 每姿勢落腳點 x（圖 px）
static var _sc := 1.0                # 統一縮放（H ÷ 企圖高）
static var _img_chk := false
static func pose_tex(pose: String) -> Texture2D:
	if not _img_chk:
		_img_chk = true
		for p in POSES:
			var k = "soldier_" + p
			if Spr.ok(k): _img[p] = Spr.get_tex(k); continue
			for ext in ["png", "webp"]:
				var path = "res://assets/spr/%s.%s" % [k, ext]
				if ResourceLoader.exists(path): _img[p] = load(path); break
		if _img.size() < POSES.size(): _img.clear()   # 要四張齊先用
		else:
			_sc = H / float(_img.stand.get_height())
			for p in POSES: _ax[p] = _foot_x(_img[p], int(FRAMES.get(p, 1)))
	return _img.get(pose)
# 圖底 15% 不透明像素嘅 x 重心（煙尾位置）＝落腳點
static func _foot_x(tx: Texture2D, nf: int) -> float:
	var fw = float(tx.get_width()) / nf
	var im = tx.get_image()
	if im == null: return fw / 2
	if im.is_compressed(): im.decompress()
	var h = im.get_height(); var sx = 0.0; var n = 0.0
	for y in range(int(h * 0.85), h, 2):
		for x in range(0, int(fw), 2):
			var a = im.get_pixel(x, y).a
			if a > 0.15: sx += x * a; n += a
	return sx / n if n > 0 else fw / 2

# ================= 兵營建築 =================
static func draw_building(ctx: Ctx, x: float, y: float, lv, t: float) -> void:
	var sd = 431
	Art.seat(ctx, x, y + 1, BW, sd)
	Art.seat_back(ctx, x, y + 1, BW, sd)
	var nm = str(DB.D.BUILDINGS.get("barracks", {}).get("name", "陰兵兵營"))
	if Spr.ok("barracks"):   # 正式圖
		var iw = Art.ink_w; Art.ink_w = 0.0; Art.cast(ctx, "barracks", x, y + 2, BW); Art.ink_w = iw
		Art.put(ctx, "barracks", x, y + 6, BW)
		Art.seat_front(ctx, x, y + 1, BW, sd)
		Art.sign_board(ctx, x + 46, y + 12, nm, lv)
		return
	var sv = Art.tint; Art.tint = Color(0.86, 0.80, 0.78)
	Art.put(ctx, "zb_stakes", x + 10, y - 12, 122)      # 後面：尖木柵（營牆）
	Art.tint = sv
	_flag(ctx, x + 44, y - 4, t)                         # 軍旗（喺木柵前、草棚後）
	Art.put(ctx, "zt_pavilion", x - 18, y + 6, 92)       # 草棚（營房）
	_rack(ctx, x + 34, y + 2)                            # 兵器架＋紙紮頭盔
	Art.seat_front(ctx, x, y + 1, BW, sd)
	Art.sign_board(ctx, x + 46, y + 12, nm, lv)

static func _flag(ctx: Ctx, x: float, y: float, t: float) -> void:
	ctx.save()
	ctx.fillStyle = "#3a2618"; ctx.fillRect(x - 1.6, y - 104, 3.2, 104)
	ctx.fillStyle = "#c9a24a"; ctx.beginPath(); ctx.arc(x, y - 106, 2.6, 0, TAU); ctx.fill()
	var w = 30.0; var h = 22.0; var top = y - 100
	ctx.beginPath(); ctx.moveTo(x + 1.5, top)
	for i in 7:
		var u = float(i) / 6.0
		ctx.lineTo(x + 1.5 + w * u, top + sin(t * 3.2 + u * 4.0) * 2.4 * u)
	for i in range(6, -1, -1):
		var u = float(i) / 6.0
		ctx.lineTo(x + 1.5 + w * u, top + h + sin(t * 3.2 + u * 4.0 + 0.6) * 2.4 * u - (3.0 if i == 6 else 0.0))
	ctx.closePath()
	ctx.fillStyle = "#7a2620"; ctx.fill()
	ctx.strokeStyle = "rgba(20,8,6,.9)"; ctx.lineWidth = 1.1; ctx.stroke()
	ctx.font = "900 13px " + Art.SERIF; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.fillStyle = "#e9d6a8"; ctx.fillText("兵", x + 15, top + h * 0.52 + sin(t * 3.2 + 2.0) * 1.2)
	ctx.restore()

static func _rack(ctx: Ctx, x: float, y: float) -> void:
	ctx.save()
	ctx.strokeStyle = "#2a1a10"; ctx.lineWidth = 2.2
	ctx.beginPath(); ctx.moveTo(x - 10, y); ctx.lineTo(x - 10, y - 26); ctx.moveTo(x + 14, y); ctx.lineTo(x + 14, y - 26)
	ctx.moveTo(x - 13, y - 22); ctx.lineTo(x + 17, y - 22); ctx.stroke()
	for i in 4:
		var sx = x - 8 + i * 6.5
		ctx.strokeStyle = "#5a3a22"; ctx.lineWidth = 1.6
		ctx.beginPath(); ctx.moveTo(sx - 3, y + 1); ctx.lineTo(sx + 2, y - 46); ctx.stroke()
		ctx.fillStyle = "#9aa1a6"; ctx.beginPath(); ctx.moveTo(sx + 2, y - 52); ctx.lineTo(sx + 4.2, y - 44); ctx.lineTo(sx - 0.2, y - 44.6); ctx.closePath(); ctx.fill()
		ctx.fillStyle = "#8a2a22"; ctx.fillRect(sx + 0.6, y - 44, 2.6, 3)
	for i in 2:
		var hx = x - 4 + i * 13; var hy = y - 18
		ctx.fillStyle = "#4b4c54"; ctx.beginPath(); ctx.arc(hx, hy, 5.2, PI, TAU); ctx.closePath(); ctx.fill()
		ctx.strokeStyle = "#16120e"; ctx.lineWidth = 0.9; ctx.stroke()
		ctx.fillStyle = "#a8332b"; ctx.beginPath(); ctx.arc(hx, hy - 6, 1.6, 0, TAU); ctx.fill()
	ctx.restore()
const TAU := PI * 2

# ================= 陰兵（冇圖時程序暫代：紙紮盔甲小兵剪影＋頭盔遮眼＋下半身煙尾） =================
const INK := Color(0.09, 0.06, 0.05, 0.92)
const ARMOR := Color("#8b5b3a")
const ARMOR_D := Color("#5e3a26")
const BELT := Color("#6e2a22")
const SKIN := Color("#c9c2b0")
const HELM := Color("#4a4b53")
const HELM_L := Color("#6a6b73")
const TASSEL := Color("#a8332b")
const SMOKE := Color(0.60, 0.65, 0.70, 0.55)
const SMOKE_L := Color(0.80, 0.84, 0.88, 0.35)
const IRON := Color("#a3a9ae")
const SHAFT := Color("#4f3420")

static func _xf(ci: CanvasItem, base: Transform2D, pos: Vector2, sc: Vector2) -> void: ci.draw_set_transform_matrix(base * Transform2D(0.0, sc, 0.0, pos))
static func draw_soldier(ci: CanvasItem, pose: String, ph: float, dir: float, seed: int, base := Transform2D.IDENTITY) -> void:
	var tx = pose_tex(pose)
	if tx != null:   # 正式圖：每姿勢一張（每格 2 個 draw：地影＋圖，8 隻都好平）
		var nf = int(FRAMES.get(pose, 1)); var fw = float(tx.get_width()) / nf; var fh = float(tx.get_height())
		var f = int(floor(ph * FPS)) % nf
		var y0 = 0.0; var rot = 0.0; var dx = 0.0
		match pose:
			"walk": y0 = -absf(sin(ph * 6.0)) * 2.0; rot = sin(ph * 6.0) * 0.04
			"stand": y0 = -sin(ph * 2.2 + seed) * 0.6
			"attack": dx = clampf(sin(ph * 10.0) * 0.5 + 0.5, 0.0, 1.0) * 4.0
		_xf(ci, base, Vector2(0, -1), Vector2(1.0, 0.32)); ci.draw_circle(Vector2.ZERO, 9.0, Color(0, 0, 0, 0.28))
		ci.draw_set_transform_matrix(base * Transform2D(rot * dir, Vector2(dir * _sc, _sc), 0.0, Vector2(dx * dir, y0)))
		var ax = float(_ax.get(pose, fw / 2))
		ci.draw_texture_rect_region(tx, Rect2(-ax, -fh, fw, fh), Rect2(f * fw, 0, fw, fh))
		ci.draw_set_transform_matrix(base)
		return
	var vr = float(seed % 5) * 0.03   # 每隻少少唔同（肥瘦）
	var bob = 0.0; var sw = 0.0
	match pose:
		"walk": bob = absf(sin(ph * 7.0)) * 1.6; sw = sin(ph * 7.0)
		"stand": bob = sin(ph * 2.2 + seed) * 0.7
		"salute": bob = 0.0
		"attack": bob = 0.4
	# 地影
	_xf(ci, base, Vector2(0, -1), Vector2(1.0, 0.32))
	ci.draw_circle(Vector2.ZERO, 9.0, Color(0, 0, 0, 0.28))
	_xf(ci, base, Vector2(0, -bob), Vector2(dir * (1.0 + vr), 1.0))
	# 煙尾（下半身）
	var w1 = sin(ph * 3.1 + seed) * 2.2; var w2 = sin(ph * 3.1 + seed + 1.4) * 2.6
	var tail = PackedVector2Array([Vector2(-7.5, -19), Vector2(-6 + w1 * 0.4, -13), Vector2(-4 + w1, -8), Vector2(-1.5 + w2, -3.5), Vector2(1.0 + w2 * 1.2, 0.5),
		Vector2(2.6 + w2, -3.5), Vector2(3.6 + w1, -8.5), Vector2(6 + w1 * 0.4, -13.5), Vector2(7.5, -19)])
	ci.draw_colored_polygon(tail, SMOKE)
	ci.draw_polyline(PackedVector2Array([Vector2(-2, -16), Vector2(-1 + w1 * 0.6, -10), Vector2(0.5 + w2, -4)]), SMOKE_L, 1.6)
	# 後手
	var sh_b = Vector2(-6, -29); var sh_f = Vector2(6, -29)
	var hb = Vector2(-7 - sw * 2.0, -20); var hf = Vector2(7 + sw * 2.0, -20)
	var spear_a = Vector2(10, -4); var spear_b = Vector2(10, -52)
	match pose:
		"walk": spear_a = Vector2(9 + sw, -6); spear_b = Vector2(14 + sw, -52); hf = Vector2(10 + sw * 0.6, -21)
		"stand": hf = Vector2(10, -21)
		"salute": hb = Vector2(-9, -21); spear_a = Vector2(-9, -4); spear_b = Vector2(-9, -52); hf = Vector2(7.5, -38.0)
		"attack":
			var k = clampf(sin(ph * 10.0) * 0.5 + 0.5, 0.0, 1.0)
			hb = Vector2(-1 + k * 6, -24); hf = Vector2(8 + k * 8, -25); spear_a = Vector2(-10 + k * 8, -24); spear_b = Vector2(26 + k * 10, -26)
	ci.draw_line(sh_b, hb, ARMOR_D, 3.0)
	ci.draw_circle(hb, 1.8, SKIN)
	# 長矛
	ci.draw_line(spear_a, spear_b, SHAFT, 1.6)
	var dv = (spear_b - spear_a).normalized(); var nv = Vector2(-dv.y, dv.x)
	ci.draw_colored_polygon(PackedVector2Array([spear_b + dv * 6.0, spear_b + nv * 2.0, spear_b - nv * 2.0]), IRON)
	ci.draw_line(spear_b - dv * 0.5 + nv * 1.5, spear_b - dv * 3.5 + nv * 3.0, TASSEL, 1.4)
	# 身（紙紮盔甲）
	var body = PackedVector2Array([Vector2(-8.5, -19), Vector2(8.5, -19), Vector2(7.5, -31), Vector2(-7.5, -31)])
	ci.draw_colored_polygon(body, ARMOR)
	ci.draw_line(Vector2(-8, -23), Vector2(8, -23), BELT, 2.2)
	ci.draw_line(Vector2(-7.6, -27), Vector2(7.6, -27), ARMOR_D, 0.9)
	ci.draw_line(Vector2(-3, -30.5), Vector2(-3.5, -19.5), ARMOR_D, 0.7)
	ci.draw_line(Vector2(3, -30.5), Vector2(3.5, -19.5), ARMOR_D, 0.7)
	ci.draw_polyline(PackedVector2Array([body[0], body[1], body[2], body[3], body[0]]), INK, 1.1)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-9.5, -31.5), Vector2(-4, -31.5), Vector2(-5, -27.5), Vector2(-10, -28)]), ARMOR_D)   # 披膊
	ci.draw_colored_polygon(PackedVector2Array([Vector2(9.5, -31.5), Vector2(4, -31.5), Vector2(5, -27.5), Vector2(10, -28)]), ARMOR_D)
	# 頭（面色灰白）＋頭盔（遮住眼）
	var hc = Vector2(0.5, -36.5)
	ci.draw_circle(hc, 6.4, SKIN)
	ci.draw_arc(hc, 6.4, 0.2, PI - 0.2, 10, INK, 0.9)
	ci.draw_line(Vector2(2.2, -32.4), Vector2(4.6, -32.8), INK, 0.9)   # 嘴（一條線，好認真）
	var helm = PackedVector2Array([Vector2(-8.2, -35.2), Vector2(-7.4, -40.5), Vector2(-4.2, -44.2), Vector2(0.5, -45.6), Vector2(5.2, -44.2), Vector2(8.4, -40.5), Vector2(9.4, -35.0), Vector2(9.8, -34.2), Vector2(-8.6, -34.4)])
	ci.draw_colored_polygon(helm, HELM)
	ci.draw_line(Vector2(-6.4, -40.2), Vector2(-1.5, -43.8), HELM_L, 1.2)
	ci.draw_polyline(helm, INK, 1.0)
	ci.draw_line(Vector2(-8.8, -34.4), Vector2(10.4, -34.2), INK, 1.6)   # 帽簷壓住眼
	ci.draw_line(Vector2(0.5, -45.6), Vector2(0.5, -48.6), INK, 1.0)
	ci.draw_circle(Vector2(0.5, -49.6), 2.1, TASSEL)
	# 前手
	if pose == "salute":   # 敬禮：手臂屈起，手掌斜斜貼住帽簷（向外 15 度），旁邊兩條「嚓」動作線
		var el = Vector2(13.5, -31.5)
		ci.draw_line(sh_f, el, ARMOR_D, 3.2); ci.draw_line(el, hf, ARMOR_D, 3.0)
		ci.draw_colored_polygon(PackedVector2Array([hf + Vector2(-1.5, 1.2), hf + Vector2(-4.5, -2.6), hf + Vector2(-2.8, -3.6), hf + Vector2(1.6, -0.2)]), SKIN)
		ci.draw_polyline(PackedVector2Array([hf + Vector2(-1.5, 1.2), hf + Vector2(-4.5, -2.6), hf + Vector2(-2.8, -3.6), hf + Vector2(1.6, -0.2)]), INK, 0.7)
		var k = fmod(ph, 1.0)
		if k < 0.45:
			var a = 1.0 - k / 0.45
			ci.draw_line(hf + Vector2(4.5, -5.5), hf + Vector2(8.0, -8.5), Color(1, 0.95, 0.8, a), 1.1)
			ci.draw_line(hf + Vector2(5.5, -1.5), hf + Vector2(9.5, -2.5), Color(1, 0.95, 0.8, a), 1.1)
	else:
		ci.draw_line(sh_f, hf, ARMOR_D, 3.0)
		ci.draw_circle(hf, 1.9, SKIN)
	ci.draw_set_transform_matrix(base)
