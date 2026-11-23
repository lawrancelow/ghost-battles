# [abui] 地圖戰鬥頭頂字／圖示嘅「唔重疊」排版（畫面 px）
#   每格：rts_view 收集 ① 固定障礙（血條、據點木牌、村子建築字、右邊技能鈕／戰況條）
#                      ② 每隻單位頭頂資訊塊（讀條、狀態圖示、王名、腳軟、失神……）
#                      ③ 飄字（ab 事件、技能名、怕X・失神、連嚇）
#   → solve()：資訊塊由前（畫面下面）至後排，撞到就向上／左右錯開（遠咗畫一條細引線）；再唔得就收埋字只留圖示；
#     飄字按單位左右交替＋向上排隊，冇位就延遲出（唔郁時間），等太耐就唔出；同一隻同一句合併「×2」。
#   全部 static；冇 class_name。
extends RefCounted

const AI = preload("res://game/rts/ab_icon.gd")
const IC := 11.0
const GAP := 3.0

static var obs: Array = []        # Rect2（畫面）
static var blocks: Array = []
static var fls: Array = []
static var placed: Array = []
static var ext := {}              # 其他場景登記嘅字（CanvasItem id → [frame, [Rect2…]]）
static var active := false        # 有仗喺鏡頭內先登記（慳效能）
static var STATS := {"blocks": 0, "moved": 0, "hidden_txt": 0, "fl": 0, "fl_wait": 0}

# ---- 其他場景（例如大排檔 mv_scene._txt「派鬼守夜」）登記自己畫咗嘅字 ----
static func avoid_ci(ci, T: Transform2D, r: Rect2) -> void:
	if not (ci is CanvasItem) or not ci.is_inside_tree() or not ci.is_visible_in_tree(): return
	var id = ci.get_instance_id(); var fr = Engine.get_process_frames()
	var e = ext.get(id)
	if e == null or int(e[0]) != fr: e = [fr, []]; ext[id] = e
	e[1].append((ci.get_global_transform_with_canvas() * T) * r)

static func begin() -> void:
	obs.clear(); blocks.clear(); fls.clear(); placed.clear()
	var fr = Engine.get_process_frames()
	for id in ext.keys():
		if not is_instance_id_valid(id) or not (instance_from_id(id) as CanvasItem).is_visible_in_tree(): ext.erase(id); continue   # 冇重畫＝字仲喺度，照避
		obs.append_array(ext[id][1])

static func add_obs(r: Rect2) -> void: obs.append(r)

# 資訊塊：lines 由下而上，每行 {k:"text"/"icons"/"chant"/"dot", h, w, ...}；opt＝可收埋嘅（文字）
static func add_block(u, S: Vector2, lines: Array) -> void:
	if lines.is_empty(): return
	var w = 0.0; var h = 0.0
	for l in lines: w = maxf(w, float(l.w)); h += float(l.h)
	blocks.append({"u": u, "S": S, "lines": lines, "w": w, "h": h, "pos": S, "show": true})

# 飄字：S＝錨點（畫面）、rise＝已經升咗幾多 px
static func add_float(key, S: Vector2, text: String, px: int, col: Color, rise: float, pop: float, src = null) -> void:
	fls.append({"key": key, "S": S, "text": text, "px": px, "col": col, "rise": rise, "pop": pop, "src": src})

static func _hit(r: Rect2) -> bool:
	for o in obs: if r.intersects(o): return true
	for o in placed: if r.intersects(o): return true
	return false

static func solve(view_r: Rect2, f: Font) -> void:
	STATS.blocks = blocks.size()
	var inner = view_r.grow(-4.0)
	# 資訊塊：前排（畫面越下）優先
	blocks.sort_custom(func(a, b): return a.S.y > b.S.y)
	for b in blocks:
		# 次序：原位附近（全部）→ 原位附近（收埋可選字，例如「失神」字，圖示照有）→ 遠啲（引線）→ 遠啲＋收字 → 唔顯示
		var full = b.lines
		var lite = []
		for l in full: if not J.t(l.get("opt")): lite.append(l)
		var ok = false
		for st in [[full, 4, 1], [lite, 4, 1], [full, 12, 2], [lite, 12, 2]]:
			if (st[0] as Array).is_empty(): continue
			if st[0] != full and lite.size() == full.size(): continue
			_set_lines(b, st[0])
			if _place_block(b, inner, st[1], st[2]):
				ok = true
				if st[0] != full: STATS.hidden_txt += 1
				break
		if not ok: b.show = false
	# 飄字
	for x in fls:
		var k = maxf(1.0, float(x.pop))
		var w = (f.get_string_size(str(x.text), HORIZONTAL_ALIGNMENT_LEFT, -1, int(x.px)).x + 12.0) * k
		var h = (float(x.px) + 6.0) * k
		var base = x.S
		for b in blocks:   # 由佢單位資訊塊頂再上
			if b.show and b.u == x.src: base = Vector2(b.pos.x, b.pos.y - b.h)
		x["show"] = false
		var cands = []
		var kd = x.key if x.key is Dictionary else {}
		if kd.get("slot") is Array: cands.append(kd.slot)   # 上一格用開嘅位優先（唔會左右跳）
		for j in 6:
			for dx in [0.0, 0.62, -0.62, 1.24, -1.24]: cands.append([dx, j])
		for cd in cands:
			var c = base + Vector2(float(cd[0]) * w, -6.0 - x.rise - int(cd[1]) * (h + 2.0))
			var r = Rect2(c.x - w / 2, c.y - h, w, h)
			if not inner.encloses(r) or _hit(r): continue
			placed.append(r); x["pos"] = c; x["show"] = true
			if x.key is Dictionary: x.key["slot"] = cd
			break
	STATS.fl = fls.size()
	for x in fls:
		if x.key is Dictionary: x.key["shown"] = x.show

static func _set_lines(b: Dictionary, ls: Array) -> void:
	b.lines = ls
	var w = 0.0; var h = 0.0
	for l in ls: w = maxf(w, float(l.w)); h += float(l.h)
	b.w = w; b.h = h
static func _place_block(b: Dictionary, inner: Rect2, nj := 12, nd := 2) -> bool:
	var dxs = [0.0, 0.55, -0.55, 1.1, -1.1].slice(0, 1 + nd * 2)
	for j in nj:
		for dx in dxs:
			if j == 0 and dx != 0.0: continue
			var c = b.S + Vector2(dx * (b.w + 6.0), -j * 7.0)
			var r = Rect2(c.x - b.w / 2 - 1, c.y - b.h, b.w + 2, b.h)
			if not inner.encloses(r) or _hit(r): continue
			placed.append(r); b.pos = c
			if c.distance_to(b.S) > 1.0: STATS.moved += 1
			return true
	return false

# ---- 畫 ----
static func _go(n: CanvasItem, xf_inv: Transform2D, P: Vector2, k := 1.0) -> void:
	n.draw_set_transform_matrix(xf_inv * Transform2D(0, Vector2(k, k), 0, P))

static func draw(v, n: CanvasItem, f: Font) -> void:
	var xf_inv = n.get_global_transform_with_canvas().affine_inverse()
	_go(n, xf_inv, Vector2.ZERO)
	for b in blocks:   # 引線先畫（喺字底）：資訊塊錯開咗，指返佢隻鬼
		if b.show and (b.pos as Vector2).distance_to(b.S) > 6.0:
			n.draw_line(b.S + Vector2(0, -1), b.pos + Vector2(0, -1), Color(0, 0, 0, 0.4), 2.6, true)
			n.draw_line(b.S + Vector2(0, -1), b.pos + Vector2(0, -1), Color(1, 0.95, 0.85, 0.55), 1.0, true)
	for b in blocks:
		if not b.show: continue
		var P: Vector2 = b.pos
		_go(n, xf_inv, P)
		var y = 0.0
		for l in b.lines:
			match str(l.k):
				"chant":
					var bw = float(l.w) - 4.0
					n.draw_rect(Rect2(-bw / 2 - 2, y - 11, bw + 4, 9), Color(0, 0, 0, 0.8))
					n.draw_rect(Rect2(-bw / 2, y - 9, bw * float(l.f), 5), l.col)
				"text":
					v._str(n, f, str(l.s), 0, y - 4, int(l.px), l.col)
				"dot":
					var pa = 0.6 + 0.4 * sin(Time.get_ticks_msec() / 1000.0 * 8.0)
					n.draw_circle(Vector2(0, y - 9), 7.0, Color(1, 0.84, 0.3, pa)); n.draw_circle(Vector2(0, y - 9), 3.5, Color(1, 1, 0.9, pa))
				"gap": pass
				"icons":
					var row: Array = l.keys
					var gap = IC * 2.0 + GAP
					var x0 = -(row.size() - 1) * gap * 0.5
					for i in row.size():
						var c = Vector2(x0 + i * gap, y - IC - 2.0)
						AI.draw(n, row[i], c, IC)
						if row[i] == "st_shell" and l.get("shell", -1.0) >= 0:
							n.draw_arc(c, IC + 2.0, -PI / 2, -PI / 2 + TAU * float(l.shell), 24, Color("#ffd27a"), 2.5, true)
			y -= float(l.h)
	for x in fls:
		if not x.get("show", false): continue
		_go(n, xf_inv, x.pos, x.pop)
		v._str(n, f, x.text, 0, -4, x.px, x.col, 5)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)
