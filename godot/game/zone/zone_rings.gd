# [mapx] 野外分圈擴展：畫面（地面色調、地貌散件、據點空地、圈名牌、分圈黑霧）
#   資料：zones.json rings／ring_props／sorties（tools/zone_build.py）；狀態／規則：zone_data.gd ring_open／open_ring
#   效能：全部只畫鏡頭入面（vr）；散件按 y 排好（zone_build 已排），逐件剔走鏡頭外
#   地面：瓦片烘圖 assets/img/mapx_ground_<ci>.webp（tools/mapx_ground.py；瓦片換圖接口喺嗰度 RING_TILES）；冇烘圖就用 ground 色＋斑駁暫代
#   冇 class_name（熱更新規矩）
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const MOT := 120.0   # 斑駁格
static var log: Array = []   # 測試：今格畫咗乜 [kind, ring, n]

static func _h(i: int, k: int) -> float: return fmod(absf(sin(float(i) * 12.9898 + float(k) * 78.233) * 43758.5453), 1.0)
# 瓦片地面烘圖（tools/mapx_ground.py）：assets/img/mapx_ground_<ci>.webp，蓋住成個 ext（核心地圖透明），每像素＝1/GSCALE 世界 px
const GSCALE := 0.5
static var _gt = null
static var _gt_ci := -2
static func ground_tex():
	var c = ZD.ci()
	if c != _gt_ci:
		_gt_ci = c
		var p = "res://assets/img/mapx_ground_%d.webp" % c
		_gt = load(p) if ResourceLoader.exists(p) else null
	return _gt

# 底層（zone_view.draw_under 開頭叫：喺山岩／河之前）
static func draw_under(c: CanvasItem, ctx: Ctx, vr: Rect2, t: float) -> void:
	log.clear()
	var rs = ZD.rings()
	if rs.is_empty(): return
	var ext = ZD.bounds()
	var gt = ground_tex()
	if gt != null:   # 只畫鏡頭入面嗰塊（一次 draw call）
		var r = ext.intersection(vr)
		if r.size.x > 0 and r.size.y > 0:
			var sr = Rect2((r.position - ext.position) * GSCALE, r.size * GSCALE)
			c.draw_texture_rect_region(gt, r, sr)
			log.append(["ground", 0, 1])
	else:   # 冇烘圖：地面色調程序暫代
		for rg in rs:
			var col = Color(str(rg.get("ground", "#2e3824")))
			var k = int(rg.ring)
			for a in rg.rects:
				var r = ZD.rect(a).intersection(vr)
				if r.size.x <= 0 or r.size.y <= 0: continue
				c.draw_rect(r, col)
				var i0 = int(floor(r.position.x / MOT)); var i1 = int(ceil(r.end.x / MOT))
				var j0 = int(floor(r.position.y / MOT)); var j1 = int(ceil(r.end.y / MOT))
				for j in range(j0, j1):
					for i in range(i0, i1):
						var hx = _h(i * 31 + k, j)
						var p = Vector2((i + 0.2 + hx * 0.6) * MOT, (j + 0.2 + _h(j * 17 + k, i) * 0.6) * MOT)
						if not r.has_point(p): continue
						var cc = col.lightened(0.10) if _h(i, j * 7 + k) > 0.5 else col.darkened(0.25)
						c.draw_circle(p, 30.0 + hx * 34.0, Color(cc.r, cc.g, cc.b, 0.35))
			log.append(["ground", k, 0])
	# 地貌散件（唔可撳、唔擋路）
	var n = 0
	for e in ZD.ring_props():
		var x = float(e[1]); var y = float(e[2]); var w = float(e[3])
		if y < vr.position.y - 10.0 or y > vr.end.y + w: continue
		if x < vr.position.x - w or x > vr.end.x + w: continue
		var key = str(e[0]); var fl = e.size() > 4 and J.t(e[4])
		match key:
			"proc:bones":
				for q in 4: Art.rr(ctx, x - 10 + q * 5, y - 3 - fmod(q * 3.0, 5.0), 9, 2.4, 1, "#c8c0b0", "#3a3430", 0.6)
				Art.el(ctx, x + 8, y - 4, 4, 3.5, "#d0c8b8", "#3a3430", 0.8)
			"proc:pool":   # 沼澤水氹
				Art.el(ctx, x, y - 8, 46, 16, "rgba(22,38,34,.9)", "rgba(10,16,14,.8)", 1.4)
				Art.el(ctx, x - 8, y - 11, 22, 5, "rgba(120,150,130,.18)")
			"proc:grass":
				for j in 7:
					var gx = x + (j - 3) * 4.0; var hh = 9.0 + fmod(j * 3.7, 8.0)
					ctx.strokeStyle = ["#2c3628", "#3a4630", "#46523a"][j % 3]; ctx.lineWidth = 1.6
					ctx.beginPath(); ctx.moveTo(gx, y); ctx.quadraticCurveTo(gx + 2, y - hh * 0.6, gx + 4 + sin(t * 1.3 + j) * 1.5, y - hh); ctx.stroke()
			"proc:flowers":
				for j in 6: Art.el(ctx, x - 10 + fmod(j * 5.3, 20.0), y - fmod(j * 4.1, 9.0), 2, 2, ["#8a2a2a", "#c8c0b0", "#6a2a4a"][j % 3])
			_:
				if Spr.ok(key):
					var tint = Color(0.84, 0.81, 0.82) if key.begins_with("tr_") else Color(0.78, 0.76, 0.78)
					load("res://game/zone/zone_view.gd")._sp(c, key, x, y, w, fl, tint)
		n += 1
	log.append(["props", 0, n])

# 上層（zone_view.draw_over）：未開嘅圈＝黑霧（散霧時漸淡）＋圈名牌
static func draw_over(c: CanvasItem, ctx: Ctx, nv, vr: Rect2, t: float) -> void:
	var rs = ZD.rings()
	if rs.is_empty(): return
	var ZV = load("res://game/zone/zone_view.gd")
	var FC: Color = ZV.FOG_COL
	var core_a = ZV.fog_core_alpha()
	var last = ZD.rect(rs[rs.size() - 1].outer)
	for rg in rs:
		var k = int(rg.ring)
		var op = ZD.ring_open(k)
		var m = 1.0 - ZD.reveal_k("ring%d" % k) if op else 1.0
		if m <= 0.001: continue
		var inner = ZD.rect(rg.inner); var outer = ZD.rect(rg.outer)
		var a = core_a * m
		for q in rg.rects:
			var r = ZD.rect(q).intersection(vr)
			if r.size.x > 0 and r.size.y > 0: c.draw_rect(r, Color(FC.r, FC.g, FC.b, a))
		if k > 1 and ZD.ring_open(k - 1):   # 柔邊：霧邊向入（已開嗰圈）淡出 4 層，每層 16px
			for L in 4:
				var g = inner.grow(-float(L + 1) * 16.0); var al = a * 0.22 * float(4 - L) / 4.0
				for q in [Rect2(inner.position.x, inner.position.y, inner.size.x, g.position.y - inner.position.y), Rect2(inner.position.x, g.end.y, inner.size.x, inner.end.y - g.end.y),
						Rect2(inner.position.x, g.position.y, g.position.x - inner.position.x, g.size.y), Rect2(g.end.x, g.position.y, inner.end.x - g.end.x, g.size.y)]:
					var r2 = q.intersection(vr)
					if r2.size.x > 0 and r2.size.y > 0: c.draw_rect(r2, Color(FC.r, FC.g, FC.b, al))
		log.append(["fog", k, 0])
	# 圈名牌：每圈上下左右四邊中間（喺鏡頭入面先畫）
	var rel = float(nv.sc) / maxf(0.01, float(nv.size.x) / 390.0)
	var far = rel < 0.45   # 縮到好細（全景）：只畫上下兩個名牌、字細啲，唔好疊埋一齊
	var px = int(clampf((11.0 if far else 16.0) / maxf(0.02, rel), 16.0, 160.0))
	var vin = vr.grow(-40.0)
	for rg in rs:
		var k = int(rg.ring)
		var inner = ZD.rect(rg.inner); var outer = ZD.rect(rg.outer)
		var mid_t = (inner.position.y + outer.position.y) * 0.5; var mid_b = (inner.end.y + outer.end.y) * 0.5
		var mid_l = (inner.position.x + outer.position.x) * 0.5; var mid_r = (inner.end.x + outer.end.x) * 0.5
		var lv = rg.get("lv", [1, 1])
		var s = "%s　Lv%d–%d" % [ZD.T(rg.n), int(lv[0]), int(lv[1])]
		var op = ZD.ring_open(k)
		if not op: s += ZD.L("（未散霧）", "（未散霧）")
		var spots = [Vector2(inner.get_center().x, mid_t), Vector2(inner.get_center().x, mid_b)]
		if not far: spots += [Vector2(mid_l, inner.get_center().y), Vector2(mid_r, inner.get_center().y)]
		for p in spots:
			if not vin.has_point(p): continue
			ctx.font = "900 %dpx %s" % [px, Art.SERIF]
			var w = ctx.measureText(s).width + px * 1.1; var h = px * 1.55
			p.x = clampf(p.x, vin.position.x + w / 2 + 6, maxf(vin.position.x + w / 2 + 6, vin.end.x - w / 2 - 6))   # 名牌唔好畀畫面邊裁走
			Art.rr(ctx, p.x - w / 2, p.y - h / 2, w, h, px * 0.35, "rgba(30,20,24,.78)" if op else "rgba(10,6,12,.6)", "rgba(255,230,190,.45)", maxf(1.2, px * 0.08))
			ZV._txt(ctx, s, p.x, p.y + 1, px, "#f6e2b0" if op else "#a89a90")
			log.append(["plate", k, 0])
