# [landmark] 地標美術：全部集中喺呢一個檔（換圖只改呢度）
#   const LA = preload("res://game/zone/landmark_art.gd")
#   地圖上嘅地標：ART[lm].png 有檔就貼圖（底邊中心對準 zones.json 嘅 at，闊 ART[lm].w），冇就用下面程序畫嘅暫代圖
#   選地點卡插圖：ILLUS[地點] ＝ [圖鍵或 res 路徑, 裁切 Rect2（像素）]；而家暫用舊世界地圖 bg_worldmap2（1024×1536）嘅局部
#   正式圖（2026-11-22 已到）：無名義山 res://assets/spr/lm_hill_big.webp（1314×867，19:00 老闆要大山：已含山腳亂葬崗、墳、破牌坊、斷牆、霧）、
#     破塔樓 res://assets/spr/lm_tower.webp（378×644），透明底、圖底＝地面
#   無名義山顯示闊 375（約 3.6 棟民宅 104 闊並排）；山腳外圍再加一圈「亂葬崗／廢墟」道具（zones.json lm_hill.ring，tools/zone_build.py 生成）
#     換圖：覆蓋呢兩個檔（同比例最好）；比例唔同就改 ART 嘅 w／h（h ＝ w × 圖高 ÷ 圖闊）。下面程序畫只係冇圖時後備
#     卡插圖   → 每張 512×320（橫），放 res://assets/img/lm_card_<地點>.webp，再改 ILLUS 對應一行做 ["res://assets/img/lm_card_xxx.webp", Rect2()]
# 畫風（Style D）：墨線、排線、蠟筆質感、偏灰病態色；冇宗教符號（墳只係冇字石碑同土包）
extends RefCounted

const ART := {
	"hill": {"png": "res://assets/spr/lm_hill_big.webp", "w": 375.0, "h": 247.4, "sort": -30.0},   # 大山：y 排序用山腳橢圓中間（企喺山前腳嘅人畫喺山上面）
	"tower": {"png": "res://assets/spr/lm_tower.webp", "w": 100.0, "h": 170.0},   # 正式圖 378×644：比民宅（104 闊、約 90 高）高一截
}
const ILLUS := {
	"street": ["bg_worldmap2", Rect2(0, 655, 448, 280)],
	"gyard": ["bg_worldmap2", Rect2(600, 985, 424, 265)],
	"station": ["bg_worldmap2", Rect2(650, 700, 374, 234)],
	"back": ["bg_worldmap2", Rect2(352, 470, 320, 200)],
	"scare": ["bg_office", Rect2()],
	"tower": ["bg_worldmap2", Rect2(90, 180, 290, 181)],
}
const INK := "#17121a"

static func size_of(lm: String) -> Vector2:
	var a = ART.get(lm, {})
	return Vector2(float(a.get("w", 120.0)), float(a.get("h", 100.0)))
# 地標圖嘅範圍（世界座標；撳、黑霧、名牌位都跟佢）
static func rect_of(lm: String, at: Vector2) -> Rect2:
	var s = size_of(lm)
	return Rect2(at.x - s.x / 2.0, at.y - s.y, s.x, s.y + 10.0)

# 卡插圖：回 Texture2D（裁好）；冇圖回 null
static func illus(pid: String) -> Texture2D:
	var e = ILLUS.get(pid)
	if not (e is Array): return null
	var tx: Texture2D = null
	var k = str(e[0])
	if k.begins_with("res://"): tx = load(k) if ResourceLoader.exists(k) else null
	elif Spr.ok(k): tx = Spr.get_tex(k)
	if tx == null: return null
	var r: Rect2 = e[1]
	if not r.has_area(): return tx
	var at = AtlasTexture.new(); at.atlas = tx; at.region = r
	return at

# ---------------- 地圖上畫（nv_village 靜態層，ctx 係世界座標） ----------------
static func sort_dy(lm: String) -> float: return float(ART.get(lm, {}).get("sort", 0.0))
static func draw(ctx: Ctx, lm: String, x: float, y: float) -> void:
	var a = ART.get(lm, {})
	var p = str(a.get("png", ""))
	if p != "" and ResourceLoader.exists(p):
		var tx: Texture2D = _tex(p)
		var w = float(a.w); var h = w * tx.get_height() / tx.get_width()   # 照原圖比例，唔裁唔壓
		if lm != "hill": Art.seat(ctx, x, y - 2, w * 0.72, 77)
		ctx.drawImage(tx, x - w / 2.0, y - h + 4.0, w, h)
		return
	match lm:
		"hill": _hill(ctx, x, y)
		"tower": _tower(ctx, x, y)
static var _tx := {}
static func _tex(p: String) -> Texture2D:
	if not _tx.has(p): _tx[p] = load(p)
	return _tx[p]
# 撳：圖入面實色嘅位先算（大山四角係透明天空，唔好搶咗隔籬嘅撳）
static var _mask := {}
static func solid(lm: String, at: Vector2, p: Vector2) -> bool:
	var r = rect_of(lm, at)
	if not r.has_point(p): return false
	var a = ART.get(lm, {})
	if lm != "hill" or not ResourceLoader.exists(str(a.get("png", ""))): return true
	if not _mask.has(lm):
		var im: Image = _tex(str(a.png)).get_image()
		if im != null:
			im = im.duplicate() as Image
			if im.is_compressed(): im.decompress()
			im.resize(im.get_width() / 6, im.get_height() / 6, Image.INTERPOLATE_BILINEAR)
		_mask[lm] = im
	var m: Image = _mask[lm]
	if m == null: return true
	var w = float(a.w); var h = w * m.get_height() / m.get_width()
	var u = (p.x - (at.x - w / 2.0)) / w; var v = (p.y - (at.y - h + 4.0)) / h
	if u < 0.0 or u >= 1.0 or v < 0.0 or v >= 1.0: return false
	var ix = int(u * m.get_width()); var iy = int(v * m.get_height())
	for dy in range(-1, 2):   # 邊位寬鬆少少（手指大細）
		for dx in range(-1, 2):
			var qx = clampi(ix + dx * 2, 0, m.get_width() - 1); var qy = clampi(iy + dy * 2, 0, m.get_height() - 1)
			if m.get_pixel(qx, qy).a > 0.3: return true
	return false

# 山腳地面：一塊唔規則嘅泥地（墨線排線、偏灰），將山圖同四周地面接埋（唔好方塊感）；靜態，畫一次
static func draw_patch(ctx: Ctx, x: float, y: float) -> void:
	var s = size_of("hill")
	var cx = x; var cy = y - s.y * 0.15
	var rx = s.x * 0.6; var ry = s.y * 0.3
	for i in 5:   # 由外到內：淡 → 實
		var k = 1.0 - i * 0.12
		Art.el(ctx, cx, cy, rx * k, ry * k, "rgba(40,32,28,%.2f)" % (0.10 + i * 0.05))
	for i in 18:   # 邊位泥塊（打散橢圓邊）
		var a = TAU * _r(61, i); var rr = 0.78 + 0.22 * _r(62, i)
		Art.el(ctx, cx + cos(a) * rx * rr, cy + sin(a) * ry * rr, 22.0 + _r(63, i) * 26.0, 7.0 + _r(64, i) * 7.0, "rgba(46,36,30,%.2f)" % (0.16 + _r(65, i) * 0.14))
	ctx.strokeStyle = "rgba(14,10,10,.28)"; ctx.lineWidth = 1.0; ctx.lineCap = "round"
	for i in 60:   # 排線
		var a = TAU * _r(71, i); var rr = sqrt(_r(72, i)) * 0.95
		var px = cx + cos(a) * rx * rr; var py = cy + sin(a) * ry * rr
		ctx.beginPath(); ctx.moveTo(px - 4, py + 2); ctx.lineTo(px + 4, py - 2); ctx.stroke()
	ctx.lineCap = "butt"
# 山腳外圍一件道具（墳、碑、亂石、枯樹、破罐、斷牆、木樁、骨頭…），偏灰同 draw_ruin 一樣
static func draw_ring(ctx: Ctx, e: Array) -> void:
	var k = str(e[0]); var x = float(e[1]); var y = float(e[2]); var w = float(e[3]); var flip = J.t(e[4]) if e.size() > 4 else false
	if k == "proc:bones": _bones(ctx, x, y, w, int(x * 7 + y)); return
	if k.begins_with("fg_"): Art.fg(ctx, k.substr(3), x, y + 2, w, flip, Color(0.62, 0.56, 0.54)); return
	if not Spr.ok(k): return
	var h = 0.0
	var im = Spr.get_tex(k)
	if im != null: h = w * im.get_height() / im.get_width()
	Art.el(ctx, x, y - 1, w * 0.42, maxf(2.0, h * 0.12), "rgba(12,6,5,.35)")   # 貼地暗影
	var sv = Art.tint; Art.tint = Color(0.6, 0.55, 0.53)
	if flip:
		ctx.save(); ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
		Art.put(ctx, k, x, y + 4, w); ctx.restore()
	else: Art.put(ctx, k, x, y + 4, w)
	Art.tint = sv
static func _bones(ctx: Ctx, x: float, y: float, w: float, sd: int) -> void:
	Art.el(ctx, x, y + 1, w * 0.55, 3.0, "rgba(12,6,5,.3)")
	for i in 2 + sd % 2:
		var a = (_r(sd, i) - 0.5) * 1.4; var l = w * (0.35 + 0.2 * _r(sd, i + 5))
		var ox = (i - 0.5) * w * 0.25; var oy = (_r(sd, i + 9) - 0.5) * 4.0
		var p0 = Vector2(x + ox - cos(a) * l, y + oy - sin(a) * l * 0.4); var p1 = Vector2(x + ox + cos(a) * l, y + oy + sin(a) * l * 0.4)
		_ln(ctx, [p0, p1], "#2a2220", 3.6)
		_ln(ctx, [p0, p1], "#cfc6b0", 2.2)
		for q in [p0, p1]: Art.el(ctx, q.x, q.y, 2.4, 1.8, "#d8cfba", "#2a2220", 0.8)

static func _r(seed: int, k: int) -> float:
	var v = sin(float(seed) * 12.9898 + float(k) * 78.233) * 43758.5453
	return v - floor(v)
static func _ln(ctx: Ctx, pts: Array, col: String, w: float) -> void:
	ctx.strokeStyle = col; ctx.lineWidth = w; ctx.lineCap = "round"; ctx.lineJoin = "round"
	ctx.beginPath(); ctx.moveTo(pts[0].x, pts[0].y)
	for i in range(1, pts.size()): ctx.lineTo(pts[i].x, pts[i].y)
	ctx.stroke(); ctx.lineCap = "butt"

# 無名義山：一座矮山丘（前後兩層坡），坡上幾塊冇字石碑同土包，一條踩出嚟嘅小路，山頂一棵枯樹
const HW := 70.0   # 半闊
const HH := 84.0   # 高
static func _hill_h(u: float) -> float:   # u：-1..1 → 山高（略向左偏，左緩右斜）
	var v = 1.0 - pow(absf(u + 0.12) / (1.12 if u < -0.12 else 0.88), 2.0)
	return HH * pow(maxf(0.0, v), 0.75)
static func _hill_poly(x: float, y: float, k: float, sd: int, dy := 0.0) -> Array:
	var pts = []
	for i in 25:
		var u = -1.0 + i / 12.0
		pts.append(x + u * HW * k); pts.append(y + dy - _hill_h(u) * k + (_r(sd, i) - 0.5) * 3.0)
	return pts
static func _hill(ctx: Ctx, x: float, y: float) -> void:
	Art.seat(ctx, x, y + 2, HW * 2.0, 41)
	Art.seat_back(ctx, x, y, HW * 1.7, 43)
	# 後坡（暗）＋前坡（亮少少）
	Art.poly(ctx, _hill_poly(x + 6, y, 1.0, 5), "#4b4636", INK, 2.4)
	Art.poly(ctx, _hill_poly(x - 8, y, 0.78, 6, 2.0), "#6e6650", "rgba(23,18,26,.8)", 1.4)
	# 蠟筆質感：淺色短筆觸（左上受光）＋右邊陰影排線
	ctx.lineCap = "round"
	for i in 70:
		var u = -0.95 + 1.9 * _r(9, i); var hh = _hill_h(u)
		if hh < 10.0: continue
		var px = x + 6 + u * HW; var py = y - hh * (0.12 + 0.78 * _r(10, i))
		var lit = u < 0.1
		ctx.strokeStyle = "rgba(176,164,120,.30)" if lit else "rgba(20,16,12,.32)"; ctx.lineWidth = 1.6 if lit else 1.2
		ctx.beginPath(); ctx.moveTo(px - 4, py + 2); ctx.lineTo(px + 4, py - 2 + (_r(11, i) - 0.5) * 2.0); ctx.stroke()
	ctx.strokeStyle = "rgba(16,12,18,.6)"; ctx.lineWidth = 1.0
	for i in 46:
		var u = 0.12 + 0.86 * _r(21, i); var hh = _hill_h(u)
		if hh < 6.0: continue
		var px = x + 6 + u * HW; var py = y - hh * (0.05 + 0.85 * _r(22, i))
		ctx.beginPath(); ctx.moveTo(px - 3, py + 4); ctx.lineTo(px + 4, py - 5); ctx.stroke()
	ctx.lineCap = "butt"
	# 小路：由山腳左前方彎上山頂（踩實嘅泥、兩邊墨線）
	var path = [Vector2(x - 40, y + 4), Vector2(x - 26, y - 16), Vector2(x - 34, y - 36), Vector2(x - 18, y - 56), Vector2(x - 14, y - 74)]
	_ln(ctx, path, "rgba(24,16,12,.7)", 8.0)
	_ln(ctx, path, "#9a8a66", 5.5)
	# 土包＋冇字石碑（後面嘅先畫）
	var graves = [[22, -66, 0.75, -0.10], [-8, -56, 0.7, -0.2], [-46, -40, 0.85, 0.12], [34, -42, 0.85, -0.05], [4, -26, 0.95, 0.18], [52, -16, 0.85, 0.08], [-58, -12, 0.85, -0.1]]
	for g in graves:
		var gx = x + float(g[0]); var gy = y + float(g[1]); var s = float(g[2])
		Art.el(ctx, gx + 4 * s, gy + 1, 13 * s, 5 * s, "#3a3528", INK, 1.1)
		Art.el(ctx, gx + 2 * s, gy - 0.5, 8 * s, 2.2 * s, "rgba(150,140,104,.35)")
		ctx.save(); ctx.translate(gx, gy); ctx.rotate(float(g[3]))
		Art.poly(ctx, [-6 * s, 0, -6 * s, -13 * s, -4 * s, -17 * s, 4 * s, -17 * s, 6 * s, -13 * s, 6 * s, 0], "#77736a", INK, 1.4)
		Art.poly(ctx, [-6 * s, -13 * s, -4 * s, -17 * s, 4 * s, -17 * s, 2 * s, -14 * s], "#a29c8c")   # 頂邊受光
		ctx.strokeStyle = "rgba(14,10,16,.65)"; ctx.lineWidth = 0.9
		ctx.beginPath(); ctx.moveTo(1 * s, -1 * s); ctx.lineTo(5 * s, -5 * s); ctx.moveTo(1 * s, -6 * s); ctx.lineTo(5 * s, -10 * s); ctx.moveTo(-3 * s, -8 * s); ctx.lineTo(-1 * s, -11 * s); ctx.stroke()
		ctx.restore()
	for i in 7: Art.tuft(ctx, x - 50 + _r(41, i) * 100.0, y - 10 - _r(42, i) * 50.0, 6.0 + _r(43, i) * 4.0, 90 + i)
	# 山頂枯樹
	var tx = x - 10.0; var ty = y - _hill_h(-0.14) + 2.0
	_ln(ctx, [Vector2(tx, ty), Vector2(tx + 2, ty - 18), Vector2(tx - 2, ty - 30)], INK, 3.0)
	_ln(ctx, [Vector2(tx + 1, ty - 16), Vector2(tx + 12, ty - 26), Vector2(tx + 17, ty - 25)], INK, 1.8)
	_ln(ctx, [Vector2(tx - 1, ty - 24), Vector2(tx - 11, ty - 33)], INK, 1.5)
	_ln(ctx, [Vector2(tx + 8, ty - 22), Vector2(tx + 10, ty - 31)], INK, 1.2)
	# 山腳歪木牌（冇字，墨線劃痕）
	var sx = x - 60.0; var sy = y + 8.0
	_ln(ctx, [Vector2(sx, sy), Vector2(sx + 2, sy - 30)], "#2e2016", 3.2)
	ctx.save(); ctx.translate(sx + 2, sy - 30); ctx.rotate(-0.12)
	Art.rr(ctx, -15, -11, 30, 14, 1.5, "#7d6c50", INK, 1.4)
	ctx.strokeStyle = "rgba(24,16,10,.8)"; ctx.lineWidth = 1.0
	ctx.beginPath(); ctx.moveTo(-10, -6); ctx.lineTo(-2, -6); ctx.moveTo(1, -6); ctx.lineTo(10, -6); ctx.moveTo(-9, -1); ctx.lineTo(7, -1); ctx.stroke()
	ctx.restore()
	Art.seat_front(ctx, x, y + 2, HW * 1.6, 47)

# 破塔樓：一棟歪咗少少嘅舊磚塔樓，窗口黑晒，頂樓崩咗一角、得一格有暗黃燈；塔腳一堆碎磚
const TW := 118.0
const TH := 262.0
const LEAN := 9.0
static func _tx(x: float, y: float, yy: float, f: float) -> float:   # 塔身某高度嘅 x（f：-1 左邊 … 1 右邊）
	var k = (y - yy) / TH
	return lerpf(x, x + LEAN, k) + f * lerpf(TW / 2.0, TW * 0.42, k)
static func _tower(ctx: Ctx, x: float, y: float) -> void:
	Art.seat(ctx, x, y + 2, 156.0, 53)
	Art.seat_back(ctx, x, y, 140.0, 55)
	var top = y - TH
	var bl = _tx(x, y, y, -1); var br = _tx(x, y, y, 1); var tl = _tx(x, y, top, -1); var tr = _tx(x, y, top, 1)
	# 塔身（頂部右上角崩咗一嚿）
	var body = [bl, y, br, y, tr, top + 34, tr - 10, top + 22, tr - 22, top + 30, tr - 30, top + 12, tl + 26, top, tl, top + 6]
	Art.poly(ctx, body, "#58545e", null)
	# 右邊三分一陰影面
	var sm = 0.36
	Art.poly(ctx, [_tx(x, y, y, sm), y, br, y, tr, top + 34, tr - 10, top + 22, _tx(x, y, top + 22, sm), top + 22], "#3c3944")
	# 蠟筆色斑（病態灰綠、灰紫）＋水漬（窗下向下流）
	for i in 30:
		var fy = _r(3, i); var yy = y - 8.0 - (TH - 30.0) * fy
		var cx = _tx(x, y, yy, (_r(4, i) - 0.5) * 1.6)
		Art.el(ctx, cx, yy, 7.0 + _r(5, i) * 11.0, 2.5 + _r(6, i) * 3.0, ["rgba(96,108,90,.30)", "rgba(40,34,48,.30)", "rgba(140,132,120,.22)"][i % 3])
	# 磚紋：一行行短墨線
	ctx.strokeStyle = "rgba(20,16,24,.45)"; ctx.lineWidth = 0.9
	var row = 0
	var yb = y - 6.0
	while yb > top + 20:
		var x0 = _tx(x, y, yb, -0.9); var x1 = _tx(x, y, yb, 0.9)
		var xx = x0 + (7.0 if row % 2 == 0 else 0.0) + _r(17, row) * 6.0
		while xx < x1 - 8:
			if _r(18, int(xx) + row * 31) < 0.55: ctx.beginPath(); ctx.moveTo(xx, yb); ctx.lineTo(xx + 8 + _r(19, int(xx)) * 5.0, yb); ctx.stroke()
			xx += 16.0
		yb -= 9.0; row += 1
	# 右邊陰影排線
	ctx.strokeStyle = "rgba(10,8,14,.55)"; ctx.lineWidth = 1.0
	var k = 0
	var yy2 = y - 4.0
	while yy2 > top + 40:
		var rx = _tx(x, y, yy2, 1)
		ctx.beginPath(); ctx.moveTo(rx - 26 + _r(7, k) * 6.0, yy2 + 5); ctx.lineTo(rx - 3, yy2 - 9); ctx.stroke()
		yy2 -= 6.0; k += 1
	# 每層：樓板線＋兩個窗（黑；有啲交叉木板封住、有啲爛玻璃；頂樓左邊一格暗黃燈）
	var floors = 6
	for i in floors:
		var fy = y - 30.0 - i * 38.0
		ctx.strokeStyle = "rgba(14,10,18,.85)"; ctx.lineWidth = 1.6
		ctx.beginPath(); ctx.moveTo(_tx(x, y, fy + 13, -0.97), fy + 13); ctx.lineTo(_tx(x, y, fy + 12, 0.97), fy + 12 + (_r(8, i) - 0.5) * 3.0); ctx.stroke()
		for j in 2:
			if i == floors - 1 and j == 1: continue   # 崩咗嗰角冇窗
			var wx = _tx(x, y, fy, -0.44 if j == 0 else 0.44)
			var lit = i == floors - 1 and j == 0
			var ww = 17.0; var wh = 21.0
			if lit: Art.el(ctx, wx, fy - 4, 22, 18, "rgba(210,180,96,.18)")
			Art.poly(ctx, [wx - ww / 2 - 2, fy + 8, wx + ww / 2 + 2, fy + 8, wx + ww / 2 + 1, fy - wh + 6, wx - ww / 2 - 1, fy - wh + 6], "#7a7266", INK, 1.3)   # 窗框
			Art.poly(ctx, [wx - ww / 2 + 1, fy + 5, wx + ww / 2 - 1, fy + 5, wx + ww / 2 - 1, fy - wh + 9, wx - ww / 2 + 1, fy - wh + 9], "#c8aa58" if lit else "#0d0a10")
			if lit:
				_ln(ctx, [Vector2(wx, fy + 5), Vector2(wx, fy - wh + 9)], "rgba(60,40,20,.8)", 1.0)
				continue
			var kind = (i * 3 + j) % 4
			if kind == 1:   # 交叉木板封住
				_ln(ctx, [Vector2(wx - 9, fy + 4), Vector2(wx + 9, fy - wh + 10)], "#6a5238", 3.0)
				_ln(ctx, [Vector2(wx - 9, fy - wh + 10), Vector2(wx + 9, fy + 4)], "#5a4430", 3.0)
			elif kind == 2:   # 爛玻璃尖角
				Art.poly(ctx, [wx - 7, fy - wh + 9, wx - 1, fy - wh + 9, wx - 6, fy - 4], "rgba(150,156,160,.55)")
				Art.poly(ctx, [wx + 7, fy + 5, wx + 7, fy - 3, wx + 2, fy + 5], "rgba(150,156,160,.45)")
			# 窗下水漬
			_ln(ctx, [Vector2(wx - 3, fy + 9), Vector2(wx - 2, fy + 18 + _r(30, i * 2 + j) * 10.0)], "rgba(30,36,28,.35)", 2.5)
	# 大裂縫（墨線之字）＋崩口
	_ln(ctx, [Vector2(x + 18, y - 4), Vector2(x + 10, y - 40), Vector2(x + 22, y - 70), Vector2(x + 14, y - 104), Vector2(x + 24, y - 130)], INK, 1.8)
	_ln(ctx, [Vector2(x + 10, y - 40), Vector2(x + 2, y - 52)], INK, 1.1)
	_ln(ctx, [Vector2(x - 30, top + 60), Vector2(x - 22, top + 86), Vector2(x - 34, top + 110)], INK, 1.4)
	Art.poly(ctx, [x - 40, y - 120, x - 28, y - 128, x - 22, y - 114, x - 32, y - 106], "#0d0a10", INK, 1.2)   # 牆身穿咗個窿
	# 崩口露出嘅鋼筋
	for i in 4:
		var rx0 = tr - 26.0 + i * 6.0
		_ln(ctx, [Vector2(rx0, top + 24 + _r(9, i) * 6.0), Vector2(rx0 + 2 + _r(10, i) * 4.0, top + 6 + _r(11, i) * 6.0)], "#5a4038", 1.3)
	# 外框墨線（兩次，似蠟筆描邊）
	ctx.lineJoin = "round"
	Art.poly(ctx, body, null, INK, 2.6)
	ctx.save(); ctx.translate(0.8, -0.6); Art.poly(ctx, body, null, "rgba(23,18,26,.45)", 1.2); ctx.restore()
	# 天台：歪咗嘅舊天線
	var ax = tl + 18.0; var ay = top + 2.0
	_ln(ctx, [Vector2(ax, ay), Vector2(ax - 4, ay - 26)], INK, 1.8)
	_ln(ctx, [Vector2(ax - 12, ay - 18), Vector2(ax + 6, ay - 22)], INK, 1.3)
	_ln(ctx, [Vector2(ax - 9, ay - 11), Vector2(ax + 4, ay - 14)], INK, 1.2)
	# 地下：爛木門（黑門洞）
	Art.poly(ctx, [x - 15, y, x - 15, y - 32, x - 8, y - 38, x + 8, y - 38, x + 15, y - 32, x + 15, y], "#0b080d", INK, 1.8)
	Art.poly(ctx, [x - 13, y, x - 13, y - 28, x - 3, y - 32, x - 3, y], "#4a3a2a", INK, 1.1)
	# 枯藤
	_ln(ctx, [Vector2(bl + 6, y - 2), Vector2(bl + 10, y - 40), Vector2(bl + 4, y - 70), Vector2(bl + 12, y - 96), Vector2(bl + 8, y - 120)], "rgba(44,54,32,.9)", 2.0)
	_ln(ctx, [Vector2(bl + 10, y - 40), Vector2(bl + 22, y - 52)], "rgba(44,54,32,.9)", 1.4)
	_ln(ctx, [Vector2(bl + 4, y - 70), Vector2(bl + 18, y - 82)], "rgba(44,54,32,.9)", 1.2)
	# 塔腳碎磚
	for i in 10:
		Art.pebble(ctx, x - 66 + i * 14.0 + _r(12, i) * 6.0, y + 4 + _r(13, i) * 6.0, 3.0 + _r(14, i) * 3.5, i)
	Art.seat_front(ctx, x, y + 2, 136.0, 59)
