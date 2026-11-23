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
	obs.clear(); blocks.clear(); fls.clear(); placed.clear(); bars.clear()
	var fr = Engine.get_process_frames()
	for id in ext.keys():
		if not is_instance_id_valid(id) or not (instance_from_id(id) as CanvasItem).is_visible_in_tree(): ext.erase(id); continue   # 冇重畫＝字仲喺度，照避
		obs.append_array(ext[id][1])

static func add_obs(r: Rect2) -> void: obs.append(r)
static var bars: Array = []       # 單位血條（畫面）：郁唔到，村子字撞到就讓路
static var busy: Array = []       # 上一格戰鬥字＋血條佔咗嘅位（畫面）
static func add_bar(r: Rect2) -> void: obs.append(r); bars.append(r)
# 村子字（例如「派鬼守夜」）撞到戰鬥字／血條：嗰格唔畫（打完自己返嚟），避免字疊字
static func busy_hit(ci, T: Transform2D, r: Rect2) -> bool:
	if not active or busy.is_empty() or not (ci is CanvasItem) or not ci.is_inside_tree(): return false
	var R = (ci.get_global_transform_with_canvas() * T) * r
	for b in busy: if R.intersects(b): return true
	return false

# 資訊塊：lines 由下而上，每行 {k:"text"/"icons"/"chant"/"dot", h, w, ...}；opt＝可收埋嘅（文字）
static func add_block(u, S: Vector2, lines: Array) -> void:
	if lines.is_empty(): return
	var w = 0.0; var h = 0.0
	for l in lines: w = maxf(w, float(l.w)); h += float(l.h)
	var pr = 2   # 排位先後：王 → 敵人 → 名鬼 → 小兵／遊魂兵（擠到冇位時，最唔重要嘅先收）
	if u is Dictionary:
		if J.num(u.get("side", 0)) != 0: pr = 0 if J.t(u.get("boss")) else 1
		elif J.t(u.get("minion")): pr = 3
	blocks.append({"u": u, "S": S, "lines": lines, "w": w, "h": h, "pos": S, "show": true, "pr": pr})

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
	blocks.sort_custom(func(a, b): return a.pr < b.pr if a.pr != b.pr else a.S.y > b.S.y)
	for b in blocks:
		# 次序：原位附近（全部）→ 原位附近（收埋可選字，例如「失神」字，圖示照有）→ 遠啲（引線）→ 遠啲＋收字 → 唔顯示
		var full = b.lines
		var lite = []
		for l in full: if not J.t(l.get("opt")): lite.append(l)
		var ok = false
		var mini = []   # 最後一招：圖示行只留頭 2 個（最緊要嘅盾／殼先排前），文字收埋
		for l in lite:
			if str(l.k) == "icons" and (l.keys as Array).size() > 2:
				var l2 = l.duplicate(); l2.keys = (l.keys as Array).slice(0, 2); l2.w = 2 * (IC * 2.0 + GAP) + 2.0; mini.append(l2)
			else: mini.append(l)
		for st in [[full, 4, 1], [lite, 4, 1], [full, 12, 2], [lite, 12, 2], [full, 16, 4], [lite, 16, 4], [full, 14, 4, true], [lite, 14, 4, true], [mini, 16, 4], [mini, 14, 4, true]]:   # 最後兩級：擠到頂 HUD 都仲搵到位（打橫錯開更遠，引線指返）
			if (st[0] as Array).is_empty(): continue
			if st[0] == lite and lite.size() == full.size(): continue
			if st[0] == mini and mini == lite: continue
			_set_lines(b, st[0])
			if _place_block(b, inner, st[1], st[2], st.size() > 3):
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
		for j in range(6, 10):   # 上面擠滿：再高啲、再闊啲
			for dx in [0.0, 0.62, -0.62, 1.24, -1.24, 1.86, -1.86]: cands.append([dx, j])
		for j in range(-1, -9, -1):   # 仲係冇位：排去下面（貼住頂 HUD 嗰陣）
			for dx in [0.0, 0.62, -0.62, 1.24, -1.24, 1.86, -1.86]: cands.append([dx, j])
		for cd in cands:
			var c = base + Vector2(float(cd[0]) * w, -6.0 - x.rise - int(cd[1]) * (h + 2.0))
			var r = Rect2(c.x - w / 2, c.y - h, w, h)
			if not inner.encloses(r) or _hit(r): continue
			placed.append(r); x["pos"] = c; x["show"] = true
			if x.key is Dictionary: x.key["slot"] = cd
			break
	STATS.fl = fls.size()
	busy = bars + placed
	for x in fls:
		if x.key is Dictionary: x.key["shown"] = x.show

static func _set_lines(b: Dictionary, ls: Array) -> void:
	b.lines = ls
	var w = 0.0; var h = 0.0
	for l in ls: w = maxf(w, float(l.w)); h += float(l.h)
	b.w = w; b.h = h
static func _place_block(b: Dictionary, inner: Rect2, nj := 12, nd := 2, down := false) -> bool:
	var dxs = [0.0, 0.55, -0.55, 1.1, -1.1, 1.65, -1.65, 2.2, -2.2].slice(0, 1 + nd * 2)
	for j in nj:
		for dx in dxs:
			if j == 0 and dx != 0.0 and not down: continue
			var c = b.S + Vector2(dx * (b.w + 6.0), -j * 7.0)
			if down: c = b.S + Vector2(dx * (b.w + 6.0), 16.0 + b.h + j * 8.0)   # 上面擠滿（例如貼住頂部 HUD）：排去血條下面，引線指返
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
				"ml":   # 遊魂兵兵器牌（ml_art 用世界座標畫）
					n.draw_set_transform_matrix(Transform2D.IDENTITY)
					load("res://game/militia/ml_art.gd").tag(n, xf_inv * (P + Vector2(0, y - 8.0)), xf_inv.get_scale().x, int(l.t))
					_go(n, xf_inv, P)
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
