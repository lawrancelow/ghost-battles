# [camp] 移動村「營地」：原本村子嘅建築（舊 BLD_ORDER 十間＋後院拓展建築）搬入大地圖，喺地圖底（紙紮大屋後面）排好，
#   拔營時跟大屋一齊摺埋抬走；同一張大地圖睇晒全部。冇 class_name、冇 autoload（熱更新規矩）。
# 用法（mv_scene.gd）：camp = load("res://game/outpost/mv_camp.gd").new(); camp.sc = self
#   每格 camp.step(dt)；畫：camp.add_items(ctx, items, vy0, vy1, fk, walking)（同其他嘢一齊按 y 排）；撳：_wbtns 嘅 "campa:<id>"／"campc:<id>" → camp.tap(kind, id)
# 排法：全部位置喺 outpost.json MAPS[].layout.camp（tools/outpost_layout.py 生成；每張圖固定隨機種子，沿營地泥路兩邊散落，唔疊）：
#   {"top", "bottom", "sign":[x,y], "road":[[x,y]...], "slots":{建築鍵:[x,y,s]}}；顯示 = ORDER（舊建築）＋ CB.shown()（已起／已解鎖／下一張圖預告）。
#   冇 slot 嘅建築（資料後加）：自動排喺最底（後備，三欄）。
# 互動同舊村子一樣：
#   伐木場／糯米田 撳建築 = 阿福親手砍樹／割稻（直接用 Village 嘅 hero 動作：doAct 計槐木、好評、讚語、S.cnt、任務）；
#   棺材鋪／包子鋪 撳建築 = 親手做一份（Village.craft）；撳名牌 = 開建築卡。
#   其他建築撳任何位 = 開建築卡（UI.openBuilding：舊建築 menus 卡、拓展建築 chain_bld 卡；化寶爐有包裹就直接開包）。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const M = preload("res://game/outpost/mat.gd")
const ORDER := ["wood", "rice", "plank", "bun", "store", "house", "home", "camp", "altar", "furnace"]
const MANUAL := ["wood", "rice", "plank", "bun"]
const COLS := [72.0, 195.0, 318.0]   # 後備排法（冇 slot）
const ROW_H := 200.0
const FOOT := 110.0        # 最底一間建築底 → 鏡頭可以去到嘅底
const BW := 100.0          # 建築圖闊（× slot 大細倍數 s；同 tools/outpost_layout.py CAMP_W 一致）
const BW_X := {"house": 112.0, "furnace": 66.0}
const IMG_MAXH := 96.0
const WS := 0.84           # 打工鬼大細（移動村員工 0.99）
const SPOT := [[-36.0, 6.0, 0], [36.0, 6.0, 1], [-20.0, 16.0, 0], [20.0, 16.0, 1]]
const SPOT_AFU := [[-36.0, 6.0, 0], [36.0, 6.0, 1], [-46.0, 16.0, 0], [46.0, 16.0, 1]]
const PLATE_DY := 34.0     # 名牌中心（建築底下面）
const FONT := 15

var sc = null              # mv_scene
var t := 0.0
var act = null             # 阿福喺營地做緊嘢：{"id", "t", "end"}
var _items: Array = []
var _items_t := -1.0
var _items_top := -1.0
var _card := {}            # id → UI._n.bld 卡資料（每 0.6 秒更新，畫「可升級／可起」提示）
var _card_t := 0.0
var _ntrees := -1

# ================= 基本 =================
static func zh() -> bool: return DB.lang != "yue"
static func L(yue: String, zhs: String) -> String: return zhs if zh() else yue
func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
func V():
	var v = J.G.get("Village")
	return v if v is Dictionary else null
func is_new(id: String) -> bool: return CB.is_new(id)
func lv(id: String) -> int:
	if is_new(id): return CB.lv(id)
	var s = S()
	return int(J.num(s.bld.get(id, 0))) if s != null and s.get("bld") is Dictionary else 0
func bname(id: String) -> String:
	if is_new(id): return CB.bname(id)
	var B = J.G.get("BUILDINGS")
	return J.str(J.gp(B[id], "name")) if B is Dictionary and B.has(id) else id
func workers(id: String) -> Array:
	if is_new(id): return CB.workers(id)
	var o = []
	var B = J.G.get("BUILDINGS"); var s = S()
	if s == null or not (B is Dictionary) or not B.has(id): return o
	var posts = J.gp(B[id], "posts")
	for g in J.iter(s.get("ghosts")):
		var p = J.gp(g, "post")
		if p != null and J.iter(posts).has(J.str(p)): o.append(g)
	return o
func unlocked(id: String) -> bool:
	if is_new(id): return CB.unlocked(id)
	return J.t(J.cl(J.G.get("bldUnlocked"), null, [id]))

# ================= 版面 =================
func CL() -> Dictionary:
	var c = MD.layout(sc.sim.ci()).get("camp")
	return c if c is Dictionary else {}
func top() -> float: return float(CL().get("top", MD.layout(sc.sim.ci()).h))
func ids() -> Array:
	var o = []
	var B = J.G.get("BUILDINGS")
	for id in ORDER: if not (B is Dictionary) or B.has(id): o.append(id)
	if S() != null: o.append_array(CB.shown())
	return o
func invalidate() -> void: _items_t = -1.0; _card_t = 0.0
func items() -> Array:   # [{id, x, y}]（y = 建築底）
	var tp = top()
	if _items_t >= 0.0 and t - _items_t < 0.5 and is_equal_approx(tp, _items_top): return _items
	_items_t = t; _items_top = tp
	var o = []; var sl = CL().get("slots", {}); var i = 0
	var y0 = float(CL().get("bottom", tp + 400.0)) + 60.0
	for id in ids():
		var e = sl.get(id) if sl is Dictionary else null
		if e is Array and e.size() >= 2:
			o.append({"id": id, "x": float(e[0]), "y": float(e[1]), "s": float(e[2]) if e.size() > 2 else 1.0})
		else:
			o.append({"id": id, "x": COLS[i % 3], "y": y0 + ROW_H * floor(i / 3.0), "s": 1.0}); i += 1
	_items = o
	return o
func item(id: String):
	for it in items(): if it.id == id: return it
	return null
func bottom() -> float:
	var b = top() + 200.0
	for it in items(): b = maxf(b, float(it.y) + FOOT)
	return b
func bw(id: String) -> float: return BW_X.get(id, BW)
func tex(id: String) -> Texture2D:
	if is_new(id): return CB.art_tex(id)
	return Spr.get_tex(id) if Spr.ok(id) else null
func img_size(id: String, s := 1.0) -> Vector2:
	var tx = tex(id); var w = bw(id) * s
	if tx == null: return Vector2(w, w * 0.8)
	var h = w * tx.get_height() / maxf(1.0, tx.get_width())
	if h > IMG_MAXH * s: w = IMG_MAXH * s * tx.get_width() / maxf(1.0, tx.get_height()); h = IMG_MAXH * s
	return Vector2(w, h)
# 矩形（世界座標；測試用嚟驗唔疊）
func body_rect(it: Dictionary) -> Rect2:
	var s = img_size(it.id, float(it.get("s", 1.0)))
	return Rect2(it.x - s.x / 2.0, it.y + 6.0 - s.y, s.x, s.y)
func plate_rect(it: Dictionary) -> Rect2:
	var w = _plate_w(it.id)
	return Rect2(it.x - w / 2.0, it.y + PLATE_DY - 12.0, w, 24.0)
func full_rect(it: Dictionary) -> Rect2:   # 建築＋頂上牌＋打工鬼＋名牌（同 tools/outpost_layout.py camp_fp 一致）
	var b = body_rect(it)
	var top_y = b.position.y - 10.0
	var bot = it.y + PLATE_DY + 14.0
	var hw = maxf(b.size.x / 2.0, maxf(_plate_w(it.id) / 2.0, 52.0))
	return Rect2(it.x - hw, top_y, hw * 2.0, bot - top_y)
func sign_pos() -> Vector2: return MD.v2(CL().get("sign", [195, top() + 40.0]))
func header_y() -> float: return sign_pos().y
func sign_rect() -> Rect2: var p = sign_pos(); return Rect2(p.x - 70, p.y - 76, 140, 106)
func road() -> PackedVector2Array:
	var o = PackedVector2Array()
	for q in CL().get("road", []): o.append(MD.v2(q))
	return o

# ================= 每格 =================
func step(dt: float) -> void:
	t += dt
	_card_t -= dt
	if _card_t <= 0.0: _card_t = 0.6; _refresh_cards()
	var Vv = V()
	if Vv == null: return
	var H = Vv.get("hero")
	if not (H is Dictionary): return
	# 營地開工：阿福即刻去到（舊村子世界座標，畫面唔見），唔使等佢行
	var tg = H.get("target")
	if tg is Dictionary and str(tg.get("kind")) in ["tree", "paddy", "craft"]:
		H["x"] = J.num(H.get("tx")); H["y"] = J.num(H.get("ty"))
		if act == null: act = {"id": _act_bld(tg), "t": 0.0, "end": -1.0}
	var a = H.get("act")
	if a is Dictionary and str(a.get("kind")) in ["tree", "paddy", "craft"]:
		if act == null: act = {"id": _act_bld(a), "t": 0.0, "end": -1.0}
		act.end = -1.0
	if act != null:
		act.t = float(act.t) + dt
		if not (a is Dictionary) and not (tg is Dictionary):
			if float(act.end) < 0.0: act.end = act.t
			if act.t - float(act.end) > 1.0: act = null
	_mirror(Vv)
func _act_bld(a: Dictionary) -> String:
	match str(a.get("kind")):
		"tree": return "wood"
		"paddy": return "rice"
		"craft": return J.str(a.get("bid"))
	return ""
# 舊村子嘅浮字／碰撞碎（喺舊村子座標）搬去營地嗰間建築度出
func _mirror(Vv: Dictionary) -> void:
	if act == null:
		for f in J.iter(Vv.get("floats")): if f is Dictionary: f["_cm"] = true
		for p in J.iter(Vv.get("parts")): if p is Dictionary: p["_cm"] = true
		return
	var it = item(str(act.id))
	if it == null: return
	var b = body_rect(it)
	var n = 0
	for f in J.iter(Vv.get("floats")):
		if not (f is Dictionary) or f.get("_cm"): continue
		f["_cm"] = true
		var col = Color(J.str(f.get("col"))) if Color.html_is_valid(J.str(f.get("col"))) else Color.WHITE
		sc._float(Vector2(it.x, b.position.y - 14.0 - n * 22.0), J.str(f.get("text")), col, 16, 1.5); n += 1
	var hits = 0
	for p in J.iter(Vv.get("parts")):
		if not (p is Dictionary) or p.get("_cm"): continue
		p["_cm"] = true
		if J.str(p.get("k")) == "spark": hits += 1
	for i in hits:
		var c = {"wood": Color("#c8a070"), "rice": Color("#e9cf7a"), "plank": Color("#b08050"), "bun": Color("#f4efe0")}.get(str(act.id), Color("#f3e2bd"))
		sc._burst(Vector2(it.x + (14.0 if str(act.id) == "wood" else 0.0), it.y - 26.0), c, 7)

func _refresh_cards() -> void:
	var UI = J.G.get("UI"); var N = J.gp(UI, "_n") if UI != null else null
	if not (N is Dictionary) or S() == null: return
	CB.install()
	_card.clear()
	for id in ids():
		var d = J.mc(N, "bld", [id])
		if d is Dictionary: _card[id] = {"up": J.t(d.get("canUp")), "build": J.t(d.get("canBuild"))}

# ================= 狀態 =================
# 斷料：有鬼開工但原料唔夠（舊建築照舊公式：棺材鋪食槐木、包子鋪食糯米、嚇人訓練班食壽包）
func starve(id: String) -> Array:
	if lv(id) <= 0 or workers(id).is_empty(): return []
	if is_new(id):
		var ws = CB.work_states()
		return CB.starved(id) if str(ws.get(id, "")) == "starve" else []
	var s = S(); var r = s.res
	match id:
		"plank": return ["m_wood"] if J.num(r.get("wood")) < 2.0 else []
		"bun": return ["m_rice"] if J.num(r.get("rice")) < 1.0 else []
		"camp": return ["m_shoubao"] if J.num(r.get("buns")) < 1.0 else []
	return []
func working(id: String) -> bool:
	if lv(id) <= 0 or workers(id).is_empty(): return false
	if id in ["store", "home", "house", "altar", "furnace"]: return false
	return starve(id).is_empty()
func gather(id: String) -> bool: return id in ["wood", "rice"] or (is_new(id) and CB.kind(id) == "gather")
func joss_n() -> int:
	if lv("furnace") <= 0: return 0
	return int(load("res://game/joss/joss.gd").count())

# ================= 畫 =================
func add_items(ctx: Ctx, out: Array, vy0: float, vy1: float, fk: float, walking: bool) -> void:
	if S() == null: return
	var tp = top()
	if fk > 0.04 and header_y() + 40.0 > vy0 and header_y() - 80.0 < vy1:
		out.append([header_y(), func(): _draw_header(ctx, fk)])
	for it in items():
		if it.y + 70.0 < vy0 or it.y - 160.0 > vy1: continue
		var ii = it
		if fk > 0.04: out.append([it.y - 40.0, func(): _draw_bld(ctx, ii, fk, walking)])
	if tp > vy1: return

func _draw_header(ctx: Ctx, fk: float) -> void:   # 營地木牌（企喺泥路口）
	var p = sign_pos(); var x = p.x; var y = p.y
	ctx.save(); ctx.translate(x, y); ctx.scale(1.0, maxf(0.02, fk)); ctx.translate(-x, -y)
	Art.el(ctx, x, y + 2, 40, 7, "rgba(0,0,0,.3)")
	Art.rr(ctx, x - 44, y - 50, 6, 52, 1, "#3a2818", "#1a100a", 1); Art.rr(ctx, x + 38, y - 50, 6, 52, 1, "#3a2818", "#1a100a", 1)
	var tt = L("營地", "營地")
	Art.rr(ctx, x - 58, y - 72, 116, 32, 3, "#7a5634", "#2a1a0e", 1.6)
	sc._txt(ctx, tt, x, y - 55, 19, Color("#f6e2b0"), "center", 900, 3, "serif")
	Art.rr(ctx, x - 52, y - 30, 104, 22, 3, "#ecd9a4", "#5a4030", 1.2)
	sc._txt(ctx, L("原本條村", "原本的村子"), x, y - 19, 14, Color("#2b1d12"), "center", 900, 0)
	_lantern(ctx, x + 41, y - 52)
	ctx.restore()
func _lantern(ctx: Ctx, x: float, y: float) -> void:
	var fl = 0.75 + 0.25 * sin(t * 7.0 + x) * sin(t * 2.3)
	Art.el(ctx, x + 6, y + 14, 20 * fl, 20 * fl, "rgba(255,150,80,.16)")
	Art.rr(ctx, x, y - 2, 12, 3, 1, "#2a1a10")
	Art.el(ctx, x + 6, y + 12, 6, 8, "#d8452e", "#5a1a10", 1.2)

func _plate_w(id: String) -> float:
	var nm = bname(id)
	var l = lv(id)
	var lw = 0.0 if l <= 0 else 30.0
	return clampf(nm.length() * FONT + 16.0 + lw, 60.0, 120.0)

func _draw_bld(ctx: Ctx, it: Dictionary, fk: float, walking: bool) -> void:
	var id: String = it.id; var x: float = it.x; var y: float = it.y
	var l = lv(id); var r = body_rect(it)
	ctx.save(); ctx.translate(x, y); ctx.scale(lerpf(0.5, 1.0, fk), maxf(0.02, fk)); ctx.translate(-x, -y)
	Art.el(ctx, x, y + 2, r.size.x * 0.46, 9, "rgba(0,0,0,.32)")
	if l <= 0:
		_site(ctx, it)
		sc._wbtns["campc:" + id] = Rect2(x - 56, y - 74, 112, 104)
		ctx.restore(); return
	var tx = tex(id)
	if tx != null: ctx.drawImage(tx, r.position.x, r.position.y, r.size.x, r.size.y)
	else: sc._proc_station(ctx, id, Vector2(x, y + 6), r.size.x)
	if id == "furnace": _furnace(ctx, r)
	if working(id): _work_fx(ctx, id, x, y, r)
	# 打工鬼喺門口做嘢（同舊村子一樣嘅工作動作）＋阿福親手做
	var afu_here = act != null and str(act.id) == id
	if not walking:
		var ws = workers(id); var sp = SPOT_AFU if afu_here else SPOT
		for i in mini(ws.size(), sp.size()):
			var s = sp[i]; var g = ws[i]
			Art.draw_char(ctx, J.str(J.gp(g, "k")), x + s[0], y + s[1], WS, {"t": t + i * 0.7 + x * 0.01, "work": true, "flip": s[2] == 1, "tamed": true})
		if afu_here: _draw_afu(ctx, x, y + 18.0)
	ctx.restore()
	if fk < 0.5: return
	# 名牌＋等級
	var pr = plate_rect(it); var nm = bname(id)
	Art.rr(ctx, pr.position.x, pr.position.y, pr.size.x, pr.size.y, 6, "rgba(30,18,12,.86)", "#b89a52", 1.2)
	var ft = sc._fit(ctx, nm, pr.size.x - 40.0, FONT)
	sc._txt(ctx, ft[0], pr.position.x + 8.0 + (pr.size.x - 38.0) / 2.0, pr.position.y + 12.0, ft[1], Color("#f6e6c0"), "center", 900, 0)
	Art.rr(ctx, pr.end.x - 30.0, pr.position.y + 2.0, 28.0, 20.0, 5, "#c2362b", "#f0c8b4", 1)
	sc._txt(ctx, str(l), pr.end.x - 16.0, pr.position.y + 12.0, 14, Color("#fff3e0"), "center", 900, 0)
	# 頂上牌：斷料（紅）／化寶爐包裹由 _furnace 畫；可升級：綠箭咀
	var sv = starve(id)
	if sv.size():
		var nms = []
		for m in sv: nms.append(M.name(str(m)) if M.has_def(str(m)) else str(m))
		var st = L("斷料：缺%s", "缺料：%s") % "、".join(nms)
		ctx.font = "900 14px sans-serif"; var sw = minf(ctx.measureText(st).width + 14.0, 120.0)
		var a = 0.8 + sin(t * 4.0) * 0.2
		ctx.globalAlpha = a
		Art.rr(ctx, x - sw / 2.0, r.position.y - 4.0, sw, 24, 7, "rgba(120,20,16,.92)", "#ffb0a0", 1.5)
		sc._txt(ctx, sc._fit(ctx, st, sw - 10.0, 14)[0], x, r.position.y + 8.0, 14, Color("#fff0e0"), "center", 900, 0)
		ctx.globalAlpha = 1.0
	elif _card.get(id, {}).get("up", false):
		var bx = r.end.x - 8.0; var by = r.position.y + 6.0 + sin(t * 4.0 + x) * 2.0
		Art.el(ctx, bx, by, 12, 12, "#3d7a3a", "#bff0a0", 1.6)
		Art.poly(ctx, [bx, by - 7, bx + 6, by + 1, bx + 2.5, by + 1, bx + 2.5, by + 6, bx - 2.5, by + 6, bx - 2.5, by + 1, bx - 6, by + 1], "#f4ffe8")
	# 撳位
	var body = Rect2(r.position.x, r.position.y, r.size.x, y + 30.0 - r.position.y).grow_individual(6, 0, 6, 0)
	if id in MANUAL:
		sc._wbtns["campc:" + id] = pr.grow(6)
		sc._wbtns["campa:" + id] = body
		_hint_ring(ctx, id, r)
	else:
		sc._wbtns["campc:" + id] = body.merge(pr.grow(6))

# 手動做嘢提示（同移動村台嘅「做」圈一樣）：伐木場「砍」、糯米田「割」、棺材鋪／包子鋪「做」
func _hint_ring(ctx: Ctx, id: String, r: Rect2) -> void:
	if act != null: return
	var c = Vector2(r.position.x + 14.0, r.position.y + 14.0)
	var tx = {"wood": L("砍", "砍"), "rice": L("割", "割")}.get(id, L("做", "做"))
	var pulse = 0.85 + 0.15 * sin(t * 3.0 + r.position.x)
	Art.el(ctx, c.x, c.y, 15 * pulse, 15 * pulse, "rgba(20,14,24,.82)", "#f3d68a", 2)
	sc._txt(ctx, tx, c.x, c.y + 1, 16, Color("#f3d68a"), "center", 900, 3)

func _draw_afu(ctx: Ctx, x: float, y: float) -> void:
	var Vv = V(); var pose = null; var pt = 0.0
	if Vv != null:
		var hp = J.mc(Vv, "heroPose", [])
		if hp is Array and hp.size() >= 2: pose = hp[0]; pt = J.num(hp[1])
	var o = {"t": t, "work": pose != null, "flip": str(act.id) in ["wood", "plank"], "pose": pose, "pt": pt}
	Art.draw_char(ctx, "afu", x, y, WS * 1.15, o)

func _furnace(ctx: Ctx, r: Rect2) -> void:
	var n = joss_n()
	if n <= 0: return
	var JU = load("res://game/joss/joss_ui.gd")
	var c = ctx.ci
	var fx = r.position.x + r.size.x * 0.5; var fy = r.position.y + r.size.y * 0.62
	Art.el(ctx, fx, fy, 30, 30, "rgba(255,170,60,%.2f)" % (0.22 + sin(t * 7.0) * 0.08))
	c.draw_set_transform_matrix(ctx.T)
	JU.smoke(c, Vector2(fx + 2, r.position.y + 8), t, 1.0, 7)
	JU.badge(c, Vector2(r.end.x + 4, r.position.y + 6), n, t)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# 生產動態：加工 → 屋頂出煙；採集 → 材料粒一粒粒飄起
func _work_fx(ctx: Ctx, id: String, x: float, y: float, r: Rect2) -> void:
	var mid = {"wood": "m_wood", "rice": "m_rice", "plank": "m_plank", "bun": "m_bao"}.get(id, CB.main_out(id) if is_new(id) else "")
	var col = CB.mat_col(mid) if mid != "" else Color("#d8c8a0")
	if not gather(id):
		var sx = r.position.x + r.size.x * 0.72; var sy = r.position.y + 8.0
		for k in 4:
			var ph = fmod(t * 0.6 + k * 0.25, 1.0)
			var rr = 4.0 + ph * 9.0
			ctx.globalAlpha = 0.45 * (1.0 - ph)
			Art.el(ctx, sx + sin(t * 1.5 + k) * 4 + ph * 8, sy - ph * 34, rr, rr * 0.8, "rgba(200,205,215,1)")
		ctx.globalAlpha = 1.0
	else:
		var c2 = "#" + col.lightened(0.25).to_html(false)
		for k in 5:
			var ph = fmod(t * 0.45 + k * 0.2, 1.0)
			ctx.globalAlpha = 0.9 * (1.0 - ph)
			Art.el(ctx, x - 36 + k * 18 + sin(t * 2 + k * 1.7) * 4, y - 14 - ph * 50, 3.0, 3.0, c2)
		ctx.globalAlpha = 1.0

func _site(ctx: Ctx, it: Dictionary) -> void:
	var id: String = it.id; var x: float = it.x; var y: float = it.y
	var un = unlocked(id); var can = _card.get(id, {}).get("build", false)
	Art.el(ctx, x, y - 6, 52, 12, "rgba(60,48,36,.45)")
	ctx.setLineDash([3, 4]); ctx.strokeStyle = "rgba(236,217,164,.45)" if un else "rgba(160,150,140,.3)"; ctx.lineWidth = 1.2
	ctx.beginPath(); ctx.ellipse(x, y - 6, 52, 14, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([])
	# 淡淡嘅建築影（知道將來係乜）
	var tx = tex(id); var r = body_rect(it)
	if tx != null:
		ctx.globalAlpha = 0.28 if un else 0.16
		ctx.drawImage(tx, r.position.x + r.size.x * 0.1, r.position.y + r.size.y * 0.2, r.size.x * 0.8, r.size.y * 0.8)
		ctx.globalAlpha = 1.0
	Art.rr(ctx, x - 1.5, y - 40, 3, 34, 1, "#5a4030")
	var nm = bname(id)
	ctx.font = "900 15px sans-serif"
	var w = clampf(ctx.measureText(nm).width + 22.0, 72.0, 112.0)
	ctx.globalAlpha = 1.0 if un else 0.78
	Art.rr(ctx, x - w / 2.0, y - 68, w, 26, 3, "#ecd9a4", "#5a4030", 1.5)
	sc._txt(ctx, sc._fit(ctx, nm, w - 10.0, 15)[0], x, y - 55, 15, Color("#2b1d12"), "center", 900, 0)
	ctx.globalAlpha = 1.0
	# 「未起」牌
	var pulse = 1.0 + (0.05 * sin(t * 5.0) if can else 0.0)
	var tag = L("未起", "未建")
	var bw2 = 56.0 * pulse
	Art.rr(ctx, x - bw2 / 2.0, y - 34, bw2, 24, 6, "#bb3427" if can else "#4a3a30", "#ffd27a" if can else "#8a7a6a", 1.5)
	sc._txt(ctx, tag, x, y - 22, 15, Color("#fff3e0") if can else Color("#d8ccb8"), "center", 900, 0)
	var sub: String
	if can: sub = L("撳嚟起", "點擊建造")
	elif un: sub = L("料未夠", "材料不足")
	elif is_new(id): sub = L("第 %d 張圖", "第 %d 張地圖") % (CB.need_ci(id) + 1)
	else: sub = L("未解鎖", "未解鎖")
	sc._txt(ctx, sub, x, y + 12, 14, Color("#ffd27a") if can else Color("#c8bca8"), "center", 900, 3)

# ================= 撳 =================
func _busy() -> bool:
	if J.t(J.mc(J.G.get("Story"), "busy", [])): return true
	var UI = J.G.get("UI")
	return UI != null and J.t(J.mc(UI, "modalOpen", []))
func hero_busy() -> bool:
	var Vv = V()
	if Vv == null: return true
	var H = Vv.hero
	for k in ["act", "target"]:
		var a = H.get(k)
		if a is Dictionary and str(a.get("kind")) in ["tree", "paddy", "craft"]: return true
	return false
func tap(kind: String, id: String) -> String:
	if S() == null or _busy(): return ""
	var it = item(id)
	if it == null: return ""
	if kind == "campa" and lv(id) > 0: return do_manual(id)
	return open_card(id)
func open_card(id: String) -> String:
	CB.install()
	if id == "furnace" and joss_n() > 0:
		load("res://game/joss/joss_ui.gd").open_next(); return "joss"
	J.mc(J.G.get("UI"), "openBuilding", [id])
	return "card"
func _say(id: String, s: String, col := Color("#ffb0a0")) -> void:
	var it = item(id)
	if it != null: sc._float(Vector2(it.x, body_rect(it).position.y - 10.0), s, col, 15, 1.4)
func do_manual(id: String) -> String:
	var Vv = V(); var s = S()
	if Vv == null: return ""
	if hero_busy(): _say(id, L("阿福做緊嘢，等陣", "阿福正在忙，等一下")); return "busy"
	var H = Vv.hero
	match id:
		"wood":
			var TP = J.G.get("TREE_POS"); var i = -1
			for k in s.trees.size():
				if J.num(s.trees[k]) > 0: i = k; break
			if i < 0:
				var w = 99.0
				for k in s.treeRegrow.size(): w = minf(w, J.num(s.treeRegrow[k]))
				_say(id, L("啲樹仲未生返（%d 秒）", "樹還沒長回來（%d 秒）") % int(ceil(maxf(1.0, w)))); return "none"
			_goto(H, J.num(TP[i][0]) + 20.0, J.num(TP[i][1]) + 4.0, {"kind": "tree", "i": float(i)})
		"rice":
			var PP = J.G.get("PADDY_POS"); var i2 = -1
			for k in s.paddy.size():
				if J.t(s.paddy[k]): i2 = k; break
			if i2 < 0:
				var w2 = 99.0
				for k in s.paddyRegrow.size(): w2 = minf(w2, J.num(s.paddyRegrow[k]))
				_say(id, L("啲禾仲未熟（%d 秒）", "稻子還沒熟（%d 秒）") % int(ceil(maxf(1.0, w2)))); return "none"
			_goto(H, J.num(PP[i2][0]) - 30.0, J.num(PP[i2][1]) + 4.0, {"kind": "paddy", "i": float(i2)})
		"plank", "bun":
			var src = "wood" if id == "plank" else "rice"
			if J.num(s.res.get(src)) < 4.0:
				_say(id, L("%s唔夠（要 4）", "%s不夠（要 4）") % (M.name("m_" + src) if M.has_def("m_" + src) else src)); return "none"
			J.mc(Vv, "craft", [id, 1.0])
		_: return open_card(id)
	act = {"id": id, "t": 0.0, "end": -1.0}
	H["x"] = J.num(H.get("tx")); H["y"] = J.num(H.get("ty"))
	return "manual"
func _goto(H: Dictionary, x: float, y: float, tg: Dictionary) -> void:
	H["tx"] = x; H["ty"] = y; H["x"] = x; H["y"] = y; H["target"] = tg; H["act"] = null; H["walking"] = false
