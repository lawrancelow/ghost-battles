# [village2] 出村門樓左右嘅柵欄：由地圖左邊去到右邊，完全將大排檔區（上面）同原村子（下面）隔開，只有門口通。
# 熱更新規矩：冇 class_name、冇 autoload；const VF = preload("res://game/village_fence.gd")，全部 static。
#   畫：nv_village._sync_statics（y 排序，出村門畫喺佢前面）
#   擋：任何行路嘅嘢（阿福、廣場鬼、挑夫鬼、客人）由 a 行去 b，如果跨過柵欄線又唔喺門口 → 擋（blocks／clamp）
extends RefCounted

const Y := 112.0              # 柵欄線（村子世界 y；出村門腳 118，門腳前少少）
const GATE_X := 195.0
const GAP := 30.0             # 門口通道半闊（門樓兩條柱入面）
const SPAN_L := [0.0, 140.0]  # 左邊柵欄（去到門柱）
const SPAN_R := [250.0, 390.0]
const KEY := "mvs_fence_n"
const SEG_W := 84.0

static func in_gap(x: float) -> bool: return absf(x - GATE_X) <= GAP

# a → b 有冇穿過柵欄（唔經門口）
static func blocks(a: Vector2, b: Vector2) -> bool:
	if (a.y - Y) * (b.y - Y) > 0.0 or is_equal_approx(a.y, b.y): return false
	var f = (Y - a.y) / (b.y - a.y)
	var x = lerpf(a.x, b.x, f)
	return not in_gap(x)

# 由 a 想行去 b：會撞柵欄就停喺柵欄同一邊（留 6px）
static func clamp_to(a: Vector2, b: Vector2) -> Vector2:
	if not blocks(a, b): return b
	var side = 1.0 if a.y >= Y else -1.0
	return Vector2(b.x, Y + side * 6.0)

# 邊一邊（1 = 村子，-1 = 大排檔區）
static func side(p: Vector2) -> int: return 1 if p.y >= Y else -1

# 柵欄段（畫用）：[中心 x, 闊, 翻轉, y 微調]
static func segments() -> Array:
	var o = []
	for sp in [SPAN_L, SPAN_R]:
		var x0: float = sp[0]; var x1: float = sp[1]
		var n = int(ceil((x1 - x0) / (SEG_W - 6.0)))
		var w = (x1 - x0) / n + 6.0
		for i in n:
			var cx = x0 + (i + 0.5) * (x1 - x0) / n
			o.append([cx, w, (i + int(x0)) % 2 == 1, sin(cx * 0.37) * 1.5])
	return o

static func draw(ctx: Ctx, t: float) -> void:
	var im = Spr.get_tex(KEY) if Spr.ok(KEY) else null
	for s in segments():
		var cx: float = s[0]; var w: float = s[1]; var dy: float = s[3]
		Art.el(ctx, cx, Y + 2 + dy, w * 0.5, 4, "rgba(10,2,8,.30)")
		if im != null:
			var h = w * im.get_height() / im.get_width()
			ctx.save()
			if s[2]: ctx.translate(cx, 0); ctx.scale(-1, 1); ctx.translate(-cx, 0)
			ctx.ci.draw_set_transform_matrix(ctx.T)
			ctx.ci.draw_texture_rect(im, Rect2(cx - w / 2, Y + 4 + dy - h, w, h), false, Color(0.86, 0.78, 0.76))
			ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
			ctx.restore()
		else:   # 後備：木柵
			for k in 4: Art.rr(ctx, cx - w / 2 + 4 + k * (w - 8) / 3.0 - 2, Y - 30 + dy, 5, 32, 1, "#4a3424", "#22160e", 1)
			for yy in [Y - 22, Y - 10]: Art.rr(ctx, cx - w / 2, yy + dy, w, 4, 1, "#5a4030")
	# 兩頭門柱腳：一條實木樁收口（同門樓柱接住，唔見罅）
	for px in [SPAN_L[1] - 2.0, SPAN_R[0] + 2.0]:
		Art.rr(ctx, px - 3.5, Y - 34, 7, 38, 1.5, "#4a3424", "#1a100a", 1.1)
		Art.poly(ctx, [px - 3.5, Y - 34, px + 3.5, Y - 34, px, Y - 39], "#4a3424", "#1a100a", 1)
