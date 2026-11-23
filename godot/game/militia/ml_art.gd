# [militia] 暫代圖（全部集中喺呢度；美術到咗換圖只改呢個檔）
#   兵器圖示：有 assets/spr/mvi_bingqi_<級>.webp 就用圖，冇就程序畫（墨線、偏灰病態色）
#   紙紮兵器檔：有 mvs_bingqi 就用圖（mv_scene 自己處理），冇就 draw_stall 程序畫兵器架
extends RefCounted

const INK := "#2a1a10"

static func icon_key(t: int) -> String: return "mvi_bingqi_%d" % t
static func has_img(key: String) -> bool: return Spr.ok(key) and Spr.get_tex(key) != null

# 圖示：(x, y)＝底部中間；sz＝闊高（同 mv_scene._icon 一樣）
static func draw_icon(ctx: Ctx, t: int, x: float, y: float, sz: float) -> void:
	var key = icon_key(t)
	if has_img(key): Art.put(ctx, key, x, y, sz, sz); return
	var EQ = load("res://game/equip/eq_data.gd")   # [equip] 冇圖：按今期款畫（A 款＝原本嗰件）
	if EQ.on() and EQ.ml_pick(t) != "": load("res://game/equip/eq_art.gd").icon(ctx, EQ.ml_pick(t), x, y, sz); return
	var c = Vector2(x, y - sz * 0.5); var s = sz / 24.0
	Art.el(ctx, c.x, c.y, sz * 0.5, sz * 0.5, "rgba(236,226,200,.92)", INK, maxf(1.0, 1.2 * s))
	ctx.save(); ctx.translate(c.x, c.y); ctx.scale(s, s)
	match t:
		0:   # 晾衫竹：斜竹竿＋竹節＋一個衫夾
			_line(ctx, -9, 8, 9, -8, "#8a9a58", 3.2); _line(ctx, -9, 8, 9, -8, INK, 0.8)
			for k in [-0.4, 0.15, 0.6]: _line(ctx, -9 + 18 * (k + 0.5) - 1.5, 8 - 16 * (k + 0.5) - 1.5, -9 + 18 * (k + 0.5) + 1.5, 8 - 16 * (k + 0.5) + 1.5, INK, 1.0)
			Art.rr(ctx, 1, -4, 3, 6, 1, "#c8b080", INK, 0.8)
		1:   # 生鏽柴刀
			Art.poly(ctx, [-6, -9, 6, -9, 8, -2, 7, 3, -3, 3, -6, -2], "#8c7a6a", INK, 1.0)
			Art.el(ctx, 2, -4, 2.2, 1.6, "#9a5a32")
			Art.el(ctx, -2, -1, 1.6, 1.1, "#9a5a32")
			Art.rr(ctx, -2.5, 3, 5, 8, 1.5, "#6a4428", INK, 1.0)
		2:   # 紙紮藤牌：圓盾、織紋
			Art.el(ctx, 0, 0, 9.5, 9.5, "#c8a868", INK, 1.2)
			Art.el(ctx, 0, 0, 6.5, 6.5, null, "#7a5a30", 1.0)
			Art.el(ctx, 0, 0, 3.4, 3.4, "#a8442e", INK, 0.8)
			for k in 6:
				var a = k * PI / 3.0
				_line(ctx, cos(a) * 3.6, sin(a) * 3.6, cos(a) * 9.0, sin(a) * 9.0, "#7a5a30", 0.8)
		3:   # 紙紮盔甲：胸甲、紅白紙鱗
			Art.poly(ctx, [-8, -8, -3, -10, 3, -10, 8, -8, 7, 8, -7, 8], "#d8cfc0", INK, 1.1)
			for r in 3:
				for k in 4: Art.el(ctx, -5 + k * 3.4, -4 + r * 4.0, 1.8, 1.4, "#b8483a" if (r + k) % 2 == 0 else "#ece2cc", INK, 0.5)
		4:   # 退役鐵鑊頭盔：反轉鐵鑊＋兩隻耳
			Art.poly(ctx, [-10, 3, -8, -3, -4, -7, 4, -7, 8, -3, 10, 3], "#4a4a52", INK, 1.1)
			Art.el(ctx, -11, 2, 2, 1.6, null, INK, 1.0); Art.el(ctx, 11, 2, 2, 1.6, null, INK, 1.0)
			_line(ctx, -5, -4, 3, -5, "#8a8a92", 1.0)
			Art.rr(ctx, -6, 4, 12, 3, 1, "#7a5a30", INK, 0.8)
		5:   # 收數鐵通：斜鐵管＋膠布
			_line(ctx, -8, 9, 8, -9, INK, 5.2); _line(ctx, -8, 9, 8, -9, "#7a7e86", 3.6)
			_line(ctx, -6, 6.8, -2.5, 2.8, "#c8b048", 4.0)
			Art.el(ctx, 8, -9, 2.4, 2.4, "#5a5e66", INK, 0.8)
		_:   # 加班戰甲：深灰藍甲＋白紙免責牌
			Art.poly(ctx, [-9, -7, -4, -10, 4, -10, 9, -7, 8, 9, -8, 9], "#3e4658", INK, 1.1)
			_line(ctx, 0, -9, 0, 8, "#6a7488", 1.0)
			Art.rr(ctx, 1, 0, 8, 6, 1, "#f2ecd8", INK, 0.8)
			_line(ctx, 2.5, 2, 7.5, 2, "#8a7a6a", 0.6); _line(ctx, 2.5, 4, 6, 4, "#8a7a6a", 0.6)
	ctx.restore()

static func _line(ctx: Ctx, x0: float, y0: float, x1: float, y1: float, col: String, w: float) -> void:
	ctx.strokeStyle = col; ctx.lineWidth = w
	ctx.beginPath(); ctx.moveTo(x0, y0); ctx.lineTo(x1, y1); ctx.stroke()

# 紙紮兵器檔（冇圖時）：紅篷、木架、掛住而家同前兩級兵器；回畫咗嘅範圍
static func draw_stall(ctx: Ctx, p: Vector2, w: float, tier: int) -> Rect2:
	var h = w * 0.82
	var x = p.x - w / 2; var y = p.y - h
	Art.rr(ctx, x + 8, y + h * 0.40, w - 16, h * 0.60, 4, "#6e4a30", INK, 2)          # 架身
	for i in 4: Art.rr(ctx, x + 12 + i * (w - 24) / 3.0 - 2, y + h * 0.40, 4, h * 0.60, 1, "#4a3020")
	Art.poly(ctx, [x, y + h * 0.42, x + 12, y + 6, x + w - 12, y + 6, x + w, y + h * 0.42], "#8e2a20", "#3a1008", 2)   # 篷
	for i in 5: Art.rr(ctx, x + 10 + i * (w - 20) / 5.0, y + h * 0.34, (w - 20) / 10.0, 7, 2, "#e8d8b0")
	Art.rr(ctx, x + w * 0.30, y + 10, w * 0.40, 18, 3, "#f2e6c8", INK, 1.2)            # 招牌
	ctx.fillStyle = INK
	# 架上掛三件兵器（而家級數同前兩級）
	for k in 3:
		var tt = clampi(tier - k, 0, 6)
		draw_icon(ctx, tt, x + w * (0.25 + 0.25 * k), y + h * 0.40 + 30, 26.0)
	Art.rr(ctx, x + 2, y + h * 0.86, w - 4, 8, 2, "#c8a878", "#5a3a1a", 1)               # 檯面
	return Rect2(x, y, w, h)

# 戰場：遊魂兵頭頂細兵器牌（畫面 px；k＝世界→畫面縮放倒數）；畫完還原 _at 嘅變換
static func tag(n: CanvasItem, wp: Vector2, k: float, t: int) -> void:
	var ctx = Ctx.new(n, Transform2D(0.0, Vector2(k, k), 0.0, wp))
	draw_icon(ctx, t, 0.0, -4.0, 20.0)
	n.draw_set_transform(wp, 0, Vector2(k, k))
