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
	"tower": {"png": "res://assets/spr/lm_tower.webp", "w": 100.0, "h": 170.0},
	"zhiqian": {"png": "res://assets/spr/lm_zhiqian.webp", "w": 375.0, "h": 248.2, "flat": true},   # 紙錢陣：平鋪地面（y 排序＝圖頂，企喺上面嘅嘢一律畫喺佢上面）   # 正式圖 378×644：比民宅（104 闊、約 90 高）高一截
}
const ILLUS := {
	"street": ["bg_worldmap2", Rect2(0, 655, 448, 280)],
	"gyard": ["bg_worldmap2", Rect2(600, 985, 424, 265)],
	"station": ["bg_worldmap2", Rect2(650, 700, 374, 234)],
	"back": ["bg_worldmap2", Rect2(352, 470, 320, 200)],
	"scare": ["bg_office", Rect2()],
	"tower": ["bg_worldmap2", Rect2(90, 180, 290, 181)],
	"battle": ["bg_worldmap2", Rect2(0, 900, 420, 262)],
	"yard": ["bg_worldmap2", Rect2(584, 905, 440, 275)],
}
const INK := "#17121a"

#   w：zones.json 個別關可以收窄（紙錢陣第 3、5 關），0＝用 ART 預設
static func size_of(lm: String, w := 0.0) -> Vector2:
	var a = ART.get(lm, {})
	var w0 = float(a.get("w", 120.0)); var h0 = float(a.get("h", 100.0))
	return Vector2(w, h0 * w / w0) if w > 0.0 else Vector2(w0, h0)
# 地標圖嘅範圍（世界座標；撳、黑霧、名牌位都跟佢）
static func rect_of(lm: String, at: Vector2, w := 0.0) -> Rect2:
	var s = size_of(lm, w)
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
static func draw(ctx: Ctx, lm: String, x: float, y: float, w0 := 0.0) -> void:
	var a = ART.get(lm, {})
	var p = str(a.get("png", ""))
	if p != "" and ResourceLoader.exists(p):
		var tx: Texture2D = _tex(p)
		var w = w0 if w0 > 0.0 else float(a.w); var h = w * tx.get_height() / tx.get_width()   # 照原圖比例，唔裁唔壓
		if lm == "tower": Art.seat(ctx, x, y - 2, w * 0.72, 77)
		ctx.drawImage(tx, x - w / 2.0, y - h + 4.0, w, h)
		return
	match lm:
		"hill": _hill(ctx, x, y)
		"tower": _tower(ctx, x, y)
static var _texc := {}
static func _tex(p: String) -> Texture2D:
	if not _texc.has(p): _texc[p] = load(p)
	return _texc[p]
# 撳：圖入面實色嘅位先算（大山四角係透明天空，唔好搶咗隔籬嘅撳）
static var _mask := {}
static func solid(lm: String, at: Vector2, p: Vector2, w0 := 0.0) -> bool:
	var r = rect_of(lm, at, w0)
	if not r.has_point(p): return false
	var a = ART.get(lm, {})
	if lm == "tower" or not ResourceLoader.exists(str(a.get("png", ""))): return true
	if not _mask.has(lm):   # 縮細 1/6 嘅實色表，再向外擴 3 格（約 5 世界像素：枯樹枝之間嘅窿、霧邊都撳得）
		var im: Image = _tex(str(a.png)).get_image()
		var mk = {}
		if im != null:
			im = im.duplicate() as Image
			if im.is_compressed(): im.decompress()
			im.resize(im.get_width() / 6, im.get_height() / 6, Image.INTERPOLATE_BILINEAR)
			var mw = im.get_width(); var mh = im.get_height()
			var raw = PackedByteArray(); raw.resize(mw * mh)
			for yy in mh:
				for xx in mw:
					if im.get_pixel(xx, yy).a > 0.15:
						for dy in range(-3, 4):
							for dx in range(-3, 4):
								var qx = xx + dx; var qy = yy + dy
								if qx >= 0 and qy >= 0 and qx < mw and qy < mh: raw[qy * mw + qx] = 1
			mk = {"w": mw, "h": mh, "b": raw}
		_mask[lm] = mk
	var m: Dictionary = _mask[lm]
	if m.is_empty(): return true
	var w = w0 if w0 > 0.0 else float(a.w); var h = w * float(m.h) / float(m.w)
	var u = (p.x - (at.x - w / 2.0)) / w; var v = (p.y - (at.y - h + 4.0)) / h
	if u < 0.0 or u >= 1.0 or v < 0.0 or v >= 1.0: return false
	return m.b[int(v * m.h) * int(m.w) + int(u * m.w)] == 1

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
	var sv = Art.tint; Art.tint = Color(0.84, 0.8, 0.78) if k.begins_with("zq_") else Color(0.6, 0.55, 0.53)   # 紙錢陣散件原色多啲
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

# ================= 紙錢陣動態（老闆 19:42／19:47／19:59）：鬼魂由黑罈口嘅煙慢慢浮現 → 沿弧線／螺旋飄去木樁圈（擺動、拉伸）
#   → 近圈減速、貼住無形屏障掙扎（press，外側一道直立弧形綠漣漪，似撞玻璃牆）→ 好似燙親咁縮返、化煙散去 → 隔陣再由罈浮現
#   冇任何綁繩；同時 5 隻錯開；半透明（睇得清塊面）、忽明忽暗、偶爾變淡；淡殘影 1 個；絕不出木樁圈（連身闊）
#   前後：鬼魂腳位限制喺「木樁頂連成嘅橢圓」入面 → 前排木樁永遠喺鬼魂前面（唔會疊錯），後排木樁喺鬼魂後面；每隻鬼自己 y 排序
#   鬼魂圖：GHOST_KEYS 由頭揀第一個有嘅（zqg2_* 無繩正式圖 → 東方亡魂 soul_* 後備）；換圖只改呢度
const ZQ_MOUTH := Vector2(0.50, 0.215)   # 黑罈口（主陣圖比例位）
const ZQ_JAR := Vector2(0.505, 0.27)     # 黑罈身（綠光）
const ZQ_FENCE := [Vector2(0.50, 0.405), Vector2(0.425, 0.33)]   # 木樁頂連成嘅橢圓：中心、半徑（圖闊／圖高嘅比例）
const ZQ_KNOTS := [Vector2(0.214, 0.17), Vector2(0.389, 0.098), Vector2(0.617, 0.098), Vector2(0.798, 0.19), Vector2(0.908, 0.333), Vector2(0.916, 0.528),
	Vector2(0.811, 0.689), Vector2(0.606, 0.792), Vector2(0.351, 0.804), Vector2(0.201, 0.706), Vector2(0.076, 0.54), Vector2(0.103, 0.333)]
const GHOST_KEYS := ["zqg2_%s"]
const GHOST_TMP := ["soul_a", "soul_b", "soul_c", "soul_d"]
const ZQ_N := 5          # 同時幾多隻（3～5）
const ZQ_GH := 0.24      # 鬼魂高＝主陣圖高 × 呢個
const ZQ_HALF := 0.56    # 鬼魂半闊＝高 × 呢個（最闊嘅 drift 約 0.51，加拉伸）
static func _gtex(pose: String, i: int) -> Texture2D:
	for f in GHOST_KEYS:
		var k = f % pose
		if Spr.ok(k): return Spr.get_tex(k)
	var k2 = GHOST_TMP[i % GHOST_TMP.size()]
	return Spr.get_tex(k2) if Spr.ok(k2) else null
static func _ease(u: float) -> float: return u * u * (3.0 - 2.0 * u)
static func _geo(x: float, y: float, w: float, h: float) -> Dictionary:
	var top = y - h
	var P = func(v: Vector2) -> Vector2: return Vector2(x - w / 2.0 + v.x * w, top + v.y * h)
	return {"mouth": P.call(ZQ_MOUTH), "jar": P.call(ZQ_JAR), "ctr": P.call(ZQ_FENCE[0]), "RX": ZQ_FENCE[1].x * w, "RY": ZQ_FENCE[1].y * h, "gh": h * ZQ_GH, "top": top}
# 腳位可唔可以企：連身闊都喺木樁頂橢圓入面
static func inside(G: Dictionary, p: Vector2, half: float) -> float:
	var rx = maxf(1.0, float(G.RX) - half)
	return sqrt(pow((p.x - G.ctr.x) / rx, 2.0) + pow((p.y - G.ctr.y) / float(G.RY), 2.0))
# 一隻鬼喺時間 t 嘅狀態（時間嘅純函數，唔使存）：{pos（腳位）, pose, flip, k（大細）, sx/sy（拉伸）, a（透明）, rip（漣漪 0..1）, dir（向外方向）, smoke（化煙 0..1）, u}
static func ghost_state(i: int, t: float, x: float, y: float, w: float, h: float) -> Dictionary:
	var G = _geo(x, y, w, h)
	var per = 6.2 + i * 0.53
	var tt = t + i * 1.37
	var cyc = int(floor(tt / per)); var u = fposmod(tt, per) / per
	var gh: float = G.gh; var half = gh * ZQ_HALF
	var mouth: Vector2 = G.mouth; var ctr: Vector2 = G.ctr
	var ang = _r(91 + i * 13, cyc) * TAU
	var dir = Vector2(cos(ang), sin(ang))
	var edge = ctr + Vector2(dir.x * (float(G.RX) - half), dir.y * float(G.RY)) * 0.93
	var spin = 1.0 if _r(97 + i, cyc) < 0.5 else -1.0
	var hov = _r(103 + i, cyc) < 0.35
	var o = {"pos": mouth, "pose": "emerge", "flip": spin < 0.0, "k": 1.0, "sx": 1.0, "sy": 1.0, "a": 0.0, "rip": 0.0, "dir": dir, "smoke": 0.0, "u": u, "gh": gh}
	var nrm = Vector2(-(edge - mouth).y, (edge - mouth).x).normalized()
	var path = func(e: float) -> Vector2:   # 弧線＋螺旋：由罈口向外，橫向擺一個弧，頭段打個細圈
		var p = mouth.lerp(edge, e) + nrm * sin(e * PI) * 30.0 * spin + Vector2(sin(e * TAU * 1.5) * 7.0, -cos(e * TAU * 1.5) * 4.0) * (1.0 - e)
		var q = inside(G, p, half)
		return ctr + (p - ctr) / q * 0.99 if q > 0.99 else p   # 弧線都唔准出圈
	if u < 0.16:   # 由罈口嘅煙浮現：淡入、由細變大、向上拉長
		var e = _ease(u / 0.16)
		o.pos = mouth + Vector2(0, -e * 10.0); o.k = lerpf(0.3, 1.0, e); o.sx = lerpf(0.55, 1.0, e); o.sy = lerpf(1.55, 1.0, e); o.a = e
	elif u < 0.54:   # 飄：快出、中段（有時）停一停打轉、近圈減速
		var e = (u - 0.16) / 0.38
		var s = e
		if hov: s = e * 0.9 if e < 0.4 else (0.36 + (e - 0.4) * 0.15 if e < 0.6 else 0.39 + (e - 0.6) / 0.4 * 0.61)
		s = sin(clampf(s, 0.0, 1.0) * PI * 0.5)
		o.pos = path.call(s) + Vector2(0, -10.0 * (1.0 - s))
		o.pose = ("hover" if hov and e > 0.4 and e < 0.6 else ("spiral" if spin > 0.0 and e < 0.5 else "drift"))
		o.flip = (path.call(minf(1.0, s + 0.03)) - o.pos).x < 0.0
		o.a = 1.0
	elif u < 0.72:   # 貼住無形屏障掙扎
		var e = (u - 0.54) / 0.18
		o.pos = edge + Vector2(sin(t * 29.0 + i) * 1.6, cos(t * 23.0 + i) * 1.0) * (1.0 - e * 0.3)
		o.pose = "press"; o.flip = dir.x < 0.0; o.a = 1.0
		o.rip = sin(e * PI)
	elif u < 0.88:   # 燙親咁縮返、化煙散去
		var e = (u - 0.72) / 0.16
		o.pos = edge.lerp(mouth, 0.35 * _ease(minf(1.0, e * 1.6))) + Vector2(0, -e * 14.0)
		o.pose = "recoil"; o.flip = dir.x >= 0.0
		o.k = lerpf(1.0, 0.6, e); o.sx = lerpf(1.0, 1.35, e); o.sy = lerpf(1.0, 0.65, e); o.a = 1.0 - e; o.smoke = e
	else:
		o.a = 0.0
	# 保險：連身闊一定喺木樁頂橢圓入面；前排木樁頂嘅前面唔企（木樁永遠喺鬼魂前面）
	var q = inside(G, o.pos, half)
	if q > 0.96: o.pos = ctr + (o.pos - ctr) * 0.96 / q
	for kn in ZQ_KNOTS:
		if kn.y < 0.6: continue
		var fp = Vector2(x - w / 2.0 + kn.x * w, float(G.top) + (kn.y - 0.07) * h)
		if absf(o.pos.x - fp.x) < half + 8.0 and o.pos.y > fp.y - 3.0: o.pos = Vector2(o.pos.x, fp.y - 3.0)
	var st = sin(t * 4.3 + i * 1.9) * 0.06   # 輕微拉伸（x／y 交替）
	o.sx *= 1.0 + st; o.sy *= 1.0 - st
	var fl = 0.88 + 0.12 * sin(t * 13.0 + i * 2.7)   # 忽明忽暗；偶爾成隻變淡幾乎睇唔到
	if sin(t * 0.83 + i * 2.3) > 0.965: fl *= 0.12
	o.a = float(o.a) * 0.86 * fl
	return o
static var FX_LOG := {"frames": 0, "max_out": 0.0, "ripples": 0}   # 測試用：畫咗幾多格、鬼魂（連身闊）最出到圈幾多（≤ 1＝喺圈內）
static func _ghost(c: CanvasItem, T: Transform2D, o: Dictionary, i: int, t: float, alpha: float) -> void:
	var tx = _gtex(str(o.pose), i)
	if tx == null or alpha <= 0.005: return
	var gh = float(o.gh) * float(o.k); var gw = gh * tx.get_width() / tx.get_height()
	var sway = Vector2(sin(t * 1.9 + i) * 2.5, sin(t * 2.6 + i) * 2.5)   # 左右擺、上下浮
	var foot = o.pos + sway
	var sx = (-1.0 if o.flip else 1.0) * float(o.sx)
	var sk = sin(t * 3.1 + i) * 0.06   # 身體隨正弦擺（斜少少）
	c.draw_set_transform_matrix(T * Transform2D(Vector2(sx, 0), Vector2(sk, float(o.sy)), foot))
	# 鬼魂圖本身半透明、又淺色，夜色底下會溶咗：背後一團淡青光，本體畫兩次（提亮）睇得清塊面
	if PtGfx.RAD != null: c.draw_texture_rect(PtGfx.RAD, Rect2(-gw * 0.7, -gh * 1.05, gw * 1.4, gh * 1.0), false, Color(0.7, 1.0, 0.8, 0.12 * alpha))
	var mc = Color(1.12, 1.16, 1.08, alpha)
	c.draw_texture_rect(tx, Rect2(-gw / 2.0, -gh, gw, gh), false, mc)
	c.draw_texture_rect(tx, Rect2(-gw / 2.0, -gh, gw, gh), false, Color(1, 1, 1, alpha * 0.75))
	c.draw_set_transform_matrix(T)
# 底層（y＝圖頂）：黑罈綠光一明一暗、罈口煙、陣上紅線輕震
static func draw_fx(ctx: Ctx, x: float, y: float, w: float, t: float) -> void:
	var h = size_of("zhiqian", w).y
	var c = ctx.ci
	var G = _geo(x, y, w, h)
	var jar: Vector2 = G.jar; var mouth: Vector2 = G.mouth
	FX_LOG.frames += 1
	c.draw_set_transform_matrix(ctx.T)
	var g = 0.5 + 0.5 * sin(t * 2.1)
	if PtGfx.RAD != null:
		var r = w * (0.14 + 0.03 * g)
		c.draw_texture_rect(PtGfx.RAD, Rect2(jar.x - r, jar.y - r * 1.1, r * 2.0, r * 2.0), false, Color(0.45, 1.0, 0.5, 0.14 + 0.2 * g))
		for k in 3:
			var sm = fposmod(t * 0.35 + k / 3.0, 1.0)
			var sr = w * (0.03 + 0.05 * sm)
			c.draw_texture_rect(PtGfx.RAD, Rect2(mouth.x - sr + sin(t + k) * 6.0, mouth.y - 6.0 - sm * 46.0 - sr, sr * 2.0, sr * 2.0), false, Color(0.7, 0.95, 0.7, 0.16 * (1.0 - sm)))
	for j in ZQ_KNOTS.size():   # 陣法本身嘅紅線（唔係綁鬼）
		var kp = Vector2(x - w / 2.0 + ZQ_KNOTS[j].x * w, float(G.top) + ZQ_KNOTS[j].y * h)
		var mid = (jar + kp) * 0.5 + Vector2(0, 4.0 + sin(t * 9.0 + j * 1.7) * 1.3)
		c.draw_polyline(PackedVector2Array([jar, mid, kp]), Color(0.62, 0.08, 0.07, 0.26), 1.1, true)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
# 一隻鬼（自己一個 y 排序節點；y＝腳位）：殘影、本體、屏障漣漪、化煙
static func draw_ghost(ctx: Ctx, i: int, x: float, y: float, w: float, t: float) -> void:
	var h = size_of("zhiqian", w).y
	var c = ctx.ci
	var o = ghost_state(i, t, x, y, w, h)
	c.draw_set_transform_matrix(ctx.T)
	if float(o.smoke) > 0.0 and PtGfx.RAD != null:
		for k in 4:
			var sp = o.pos + Vector2(sin(k * 1.9 + i) * 20.0 * float(o.smoke), -float(o.gh) * 0.5 - float(o.smoke) * 22.0 - k * 6.0)
			var sr = float(o.gh) * (0.18 + 0.14 * float(o.smoke))
			c.draw_texture_rect(PtGfx.RAD, Rect2(sp.x - sr, sp.y - sr, sr * 2.0, sr * 2.0), false, Color(0.78, 0.86, 0.76, 0.24 * (1.0 - float(o.smoke))))
	var ob = ghost_state(i, t - 0.09, x, y, w, h)   # 淡殘影 1 個
	if str(ob.pose) == str(o.pose): _ghost(c, ctx.T, ob, i, t - 0.09, float(ob.a) * 0.3)
	_ghost(c, ctx.T, o, i, t, float(o.a))
	if float(o.rip) > 0.0:   # 外側直立弧形綠漣漪（似撞玻璃牆）
		FX_LOG.ripples += 1
		var d: Vector2 = o.dir
		var tg = Vector2(-d.y, d.x * 0.55).normalized()   # 屏障切線（地面橢圓）
		var base = o.pos + d * Vector2(10.0, 5.0)
		for k in 2:
			var rr = fposmod(t * 1.5 + k * 0.5, 1.0)
			var wr = float(o.gh) * (0.35 + rr * 0.35); var hr = float(o.gh) * (0.55 + rr * 0.45)
			var pts = PackedVector2Array()
			for q in 17:
				var a = PI * q / 16.0
				pts.append(base + tg * cos(a) * wr + Vector2(0, -sin(a) * hr) + d * sin(a) * 3.0)
			c.draw_polyline(pts, Color(0.55, 1.0, 0.62, 0.5 * float(o.rip) * (1.0 - rr)), 1.6, true)
	if float(o.a) > 0.01:
		var G = _geo(x, y, w, h)
		FX_LOG.max_out = maxf(FX_LOG.max_out, inside(G, o.pos, float(o.gh) * ZQ_HALF * 0.999))
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
static func ghost_y(i: int, x: float, y: float, w: float, t: float) -> float:
	return float(ghost_state(i, t, x, y, w, size_of("zhiqian", w).y).pos.y)

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
