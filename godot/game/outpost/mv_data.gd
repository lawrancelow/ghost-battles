# 移動村（出殯巡遊大排檔）：資料＋公式（全部 static，冇 class_name；用 load("res://game/outpost/mv_data.gd") 叫）
# 資料：data/nat/outpost.json（格式見 MV_CONTRACT.md）。公式全部喺呢度，畫面／模擬／測試共用。
#
# 公式（lv = 生產台等級，sd = STATIONS[sid]）：
#   里程碑數   nm(lv)      = sd.miles 入面 ≤ lv 嘅個數 ＝ 品質星 ★ 數（# [idle]）
#   [idle] 里程碑（Idle Outpost 式）：預設 miles = 10／25／50／100／150／200（最高 200 級）；第 i 個（0 起）效果輪流：
#          i 雙數 = 「生產速度 ×2」、i 單數 = 「售價 ×2」；每過一個 +1 品質星（★，最多 6 粒）
#          ns(lv) = 過咗幾多個「速度」里程碑；nv(lv) = 過咗幾多個「售價」里程碑
#   每次產量   out(lv)     = base_out + floor((lv − 1) / 10)            （每 10 級多 1 件）
#   做貨時間   tm(lv)      = base_time ÷ (1 + 0.02 × (lv − 1)) ÷ 2^ns(lv)    （加速中再 ÷ 2；有領班嘅員工再 ÷ 1.25，見 mv_idle.gd）
#   單價       val(lv)     = GOODS[good].price × (1 + 0.1 × (lv − 1)) × 2^nv(lv) × (1 + 0.2 × 品質星) × 地圖倍數(MAPS.mul，預設 1)
#   [idle] 累計產量門檻 gate(第 i 個里程碑) = 升到嗰級之前，呢個台（本圖＋隨村台跟住走）要累計做夠幾多件：
#          round5( GATE[i] × 4 ÷ base_time )，最少 5（做貨慢嘅台要少啲）；台資料可以用 STATIONS[sid].gates 蓋過
#   升一級     cost1(lv)   = ceil(up_cost0 × up_mul ^ (lv − 1))          （lv → lv+1）
#   升 n 級    cost_n      = Σ cost1(lv … lv+n−1)；最高級 = miles 最大值
#   客人付錢   = Σ 件數 × val(嗰種貨個台嘅等級) × 收益倍數（收益掣開咗 ×2）
#   離線       每秒 = Σ有員工嘅台 員工數 × out × val ÷ (tm + carry_s)；最多 OFFLINE_H 小時；唔計加速／收益掣
#              carry_s(台) = 2 × 搬貨路線長度 ÷ WALK_W + PICK_S（路線由 layout 計，同即時模擬行嘅路一樣）
#   圍欄       孤魂血 = FOE_HP × (1 + 0.6 × ci)；守夜每秒傷害 = 10 + 2 × 鬼等級；撳一下 = TAP_DMG；打走 = 10 × (ci + 1) 冥幣
extends RefCounted

const PATH := "res://data/nat/outpost.json"
const CM = preload("res://game/outpost/mat.gd")   # [chain] 隨村台（CARRY）
const CARRY_S := 3.0        # 離線計：每轉搬貨來回大約秒數
const OFFLINE_H := 8.0
const COUNTER_CAP := 40     # 櫃台每種貨最多疊幾件
const QUEUE_MAX := 4
const FOE_HP := 40.0
const TAP_DMG := 15.0
const GUARD_SLOTS := 3
const BOOST_INC := {"dur": 300.0, "cd": 1200.0}   # 收益 ×2：5 分鐘，冷卻 20 分鐘
const BOOST_SPD := {"dur": 120.0, "cd": 600.0}    # 加速 ×2：2 分鐘，冷卻 10 分鐘

static var _D = null

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	_LC = {}
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {"GOODS": {}, "STATIONS": {}, "CUSTOMERS": [], "MAPS": [], "FOE_LINES": [], "STRINGS": {}}
	for k in ["GOODS", "STATIONS", "STRINGS"]: if not (_D.get(k) is Dictionary): _D[k] = {}
	for k in ["CUSTOMERS", "MAPS", "FOE_LINES"]: if not (_D.get(k) is Array): _D[k] = []

static func maps_n() -> int: return D().MAPS.size()
static func map_def(ci: int) -> Dictionary:
	for m in D().MAPS: if int(m.get("ci", -1)) == ci: return m
	return D().MAPS[clampi(ci, 0, maps_n() - 1)] if maps_n() > 0 else {}
static func st_def(sid: String) -> Dictionary: return D().STATIONS.get(sid, {})
static func good_def(gid: String) -> Dictionary: return D().GOODS.get(gid, {})
static func cust_def(cid: String) -> Dictionary:
	for c in D().CUSTOMERS: if str(c.get("id")) == cid: return c
	return {}
static func stations(ci: int) -> Array:
	var o = []
	for s in map_def(ci).get("stations", []): if D().STATIONS.has(str(s)): o.append(str(s))
	for s in CM.carry():   # [chain] 隨村台：每張圖都有（資料冇列入呢張圖都補返）
		if D().STATIONS.has(s) and not o.has(s): o.append(s)
	return o
static func is_carry(sid: String) -> bool: return CM.carry().has(sid)   # [chain]
static func goals(ci: int) -> Array: return map_def(ci).get("goals", [])
static func map_mul(ci: int) -> float: return float(map_def(ci).get("mul", 1.0))

static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[0]) if DB.lang == "yue" else str(a[1])
	return str(a) if a != null else ""
static func S(key: String, yue: String, zh: String) -> String:
	var dflt = yue if DB.lang == "yue" else zh
	var a = D().STRINGS.get(key)
	if not (a is Array): return dflt
	var s = T(a)
	# 有格式位（%s／%d）嘅句：資料版格式位唔同就用預設，免得 % 報錯
	if _fmt_sig(s) != _fmt_sig(dflt): return dflt
	return s
static func _fmt_sig(s: String) -> String:
	var o = ""
	var i = s.find("%")
	while i >= 0 and i + 1 < s.length():
		o += s[i + 1]; i = s.find("%", i + 2)
	return o

# ---------------- 公式 ----------------
const MILES := [10, 25, 50, 100, 150, 200]   # [idle]
const GATE := [10, 120, 500, 2000, 6000, 15000]   # [idle] 第 i 個里程碑嘅累計產量（base_time 4 秒嘅台；其他按 4 ÷ base_time 縮放）
const Q_VAL := 0.2   # [idle] 每粒品質星售價 +20%（tools/idle_sim.py 調過）
static func miles(sid: String) -> Array:
	var m = st_def(sid).get("miles", MILES)
	return m if m is Array and m.size() > 0 else [100]
static func max_lv(sid: String) -> int:
	var mx = 1
	for x in miles(sid): mx = maxi(mx, int(x))
	return mx
static func nm(sid: String, lv: float) -> int:
	var n = 0
	for x in miles(sid): if lv >= float(x): n += 1
	return n
static func mile_mul(sid: String, lv: float) -> float: return pow(2.0, nv(sid, lv))   # [idle] 只計「售價」里程碑
# [idle] 里程碑效果：第 i 個（按等級排）雙數 = 速度、單數 = 售價
static func sorted_miles(sid: String) -> Array:
	var a = []
	for x in miles(sid): a.append(int(x))
	a.sort()
	return a
static func mile_kind(sid: String, i: int) -> String:
	var fx = st_def(sid).get("mile_fx")
	if fx is Array and i < fx.size(): return str(fx[i])
	return "spd" if i % 2 == 0 else "val"
static func mile_idx(sid: String, m: int) -> int: return sorted_miles(sid).find(m)
static func _n_kind(sid: String, lv: float, kind: String) -> int:
	var a = sorted_miles(sid); var n = 0
	for i in a.size(): if lv >= float(a[i]) and mile_kind(sid, i) == kind: n += 1
	return n
static func ns(sid: String, lv: float) -> int: return _n_kind(sid, lv, "spd")
static func nv(sid: String, lv: float) -> int: return _n_kind(sid, lv, "val")
static func stars(sid: String, lv: float) -> int: return nm(sid, lv)
static func gate(sid: String, m: int) -> int:   # 升到里程碑 m（等級）要嘅累計產量
	var i = mile_idx(sid, m)
	if i < 0: return 0
	var gs = st_def(sid).get("gates")
	if gs is Array and i < gs.size(): return int(gs[i])
	var bt = maxf(0.5, float(st_def(sid).get("base_time", 4.0)))
	return maxi(5, int(round(float(GATE[mini(i, GATE.size() - 1)]) * 4.0 / bt / 5.0)) * 5)
static func next_mile(sid: String, lv: float) -> int:
	var best = -1
	for x in miles(sid):
		if float(x) > lv and (best < 0 or int(x) < best): best = int(x)
	return best
static func out(sid: String, lv: float) -> int: return int(st_def(sid).get("base_out", 1)) + int(floor((lv - 1.0) / 10.0))
static func tm(sid: String, lv: float) -> float: return float(st_def(sid).get("base_time", 5.0)) / (1.0 + 0.02 * (lv - 1.0)) / pow(2.0, ns(sid, lv))   # [idle] ÷ 2^速度里程碑
static func val(sid: String, lv: float, ci: int) -> float:
	var g = good_def(str(st_def(sid).get("good", "")))
	return float(g.get("price", 1.0)) * (1.0 + 0.1 * (lv - 1.0)) * mile_mul(sid, lv) * (1.0 + Q_VAL * stars(sid, lv)) * map_mul(ci)   # [idle] 品質星
static func cost1(sid: String, lv: float) -> float:
	var sd = st_def(sid)
	return ceil(float(sd.get("up_cost0", 10.0)) * pow(float(sd.get("up_mul", 1.12)), lv - 1.0))
static func cost_n(sid: String, lv: float, n: int) -> float:
	var c = 0.0
	for i in n: c += cost1(sid, lv + i)
	return c
# ---------------- 大地圖版面（MAPS[].layout；冇就自動排） ----------------
const WALK_W := 240.0       # 員工搬貨行路速度（px/秒；鬼係飄嘅）
const PICK_S := 0.6         # 每轉放貨／攞貨嘅停頓
static var _LC := {}
static func layout(ci: int) -> Dictionary:
	if _LC.has(ci): return _LC[ci]
	var L = map_def(ci).get("layout")
	if not (L is Dictionary): L = _auto_layout(ci)
	else: L = _fit_missing(L, ci)   # [chain]
	_LC[ci] = L
	return L
# [chain] 版面冇預留位嘅台（例如隨村台）：喺圍欄下面開一條新帶，所有圍欄以下嘅嘢（台、路、櫃台、大屋、擺設）向下移，
# 新台排喺新帶入面（左右交替），搬貨路線接去最頂嗰個路點。圍欄、最頂路點唔郁。
static func _fit_missing(L0: Dictionary, ci: int) -> Dictionary:
	var miss = []
	for sid in stations(ci): if not (L0.get("st", {}) as Dictionary).has(sid): miss.append(sid)
	if miss.is_empty(): return L0
	var L = L0.duplicate(true)
	var fy = float(L.get("fence_y", 230)); var cut = fy + 30.0; var dy = 270.0 * miss.size()
	var sh = func(a): return [a[0], float(a[1]) + dy] + (a.slice(2) if a.size() > 2 else []) if float(a[1]) > cut else a
	L.h = float(L.h) + dy
	for k in ["counter", "house", "serve"]: if L.get(k) is Array: L[k] = sh.call(L[k])
	var rd = []
	for q in L.road: rd.append(sh.call(q))
	L.road = rd
	var st = {}
	for sid in L.st: st[sid] = sh.call(L.st[sid])
	var top = rd.size() - 1
	for i in miss.size():
		var y = cut + 230.0 + i * 270.0
		st[miss[i]] = [298.0 if i % 2 == 0 else 92.0, y, float(top)]
	L.st = st
	var dc = []
	for d in L.get("decor", []):
		if d is Dictionary and float(d.get("y", 0)) > cut:
			var d2 = d.duplicate(); d2.y = float(d.y) + dy; dc.append(d2)
		else: dc.append(d)
	L.decor = dc
	return L
static func _auto_layout(ci: int) -> Dictionary:   # 資料冇 layout：照 tools/outpost_layout.py 嘅排法
	var ids = stations(ci); var n = ids.size()
	var h = 430.0 + 270.0 * maxf(0, n - 1) + 570.0
	var road = [[292, h + 30], [262, h - 140], [240, h - 268]]
	var st = {}
	for i in n:
		var y = h - 570 - i * 270.0; var rx = 195.0 + 55.0 * sin(i * 1.25 + ci * 0.9)
		road.append([round(rx), round(y + 36)])
		var side = 1.0 if i % 2 == 0 else -1.0
		st[ids[i]] = [round(clampf(rx + side * 112.0, 92, 298)), round(y), 3 + i]
	road.append([195, 250])
	return {"w": 390, "h": h, "fence_y": 230, "counter": [118, h - 250], "house": [104, h - 318], "serve": [236, h - 232], "road": road, "j": 2, "st": st, "decor": []}
static func v2(a) -> Vector2: return Vector2(float(a[0]), float(a[1])) if a is Array and a.size() >= 2 else Vector2.ZERO
static func st_xy(ci: int, sid: String) -> Vector2:
	var e = layout(ci).st.get(sid)
	return v2(e) if e != null else Vector2(195, 600)
static func drop_xy(ci: int) -> Vector2: return v2(layout(ci).counter) + Vector2(0, -30)   # 櫃台後面（員工放貨位）
# 員工搬貨路線：台前 → road[ri] → … → road[j] → 櫃台後
static func st_path(ci: int, sid: String) -> PackedVector2Array:
	var Ly = layout(ci); var e = Ly.st.get(sid); var o = PackedVector2Array()
	if e == null: return o
	var road = Ly.road; var j = int(Ly.j); var ri = int(e[2]) if e.size() > 2 else j
	o.append(v2(e) + Vector2(0, 30))
	var step = -1 if ri >= j else 1
	var i = ri
	while true:
		o.append(v2(road[i]))
		if i == j: break
		i += step
	o.append(drop_xy(ci))
	return o
static func poly_len(p: PackedVector2Array) -> float:
	var d = 0.0
	for i in range(1, p.size()): d += p[i - 1].distance_to(p[i])
	return d
static func poly_at(p: PackedVector2Array, s: float) -> Vector2:
	if p.is_empty(): return Vector2.ZERO
	if s <= 0.0: return p[0]
	for i in range(1, p.size()):
		var d = p[i - 1].distance_to(p[i])
		if s <= d: return p[i - 1].lerp(p[i], s / maxf(0.001, d))
		s -= d
	return p[p.size() - 1]
static func carry_s(ci: int, sid: String) -> float: return 2.0 * poly_len(st_path(ci, sid)) / WALK_W + PICK_S
# 客人排隊線：收貨位 → road[j-1] → … → road[0]（入口）
static func queue_poly(ci: int) -> PackedVector2Array:
	var Ly = layout(ci); var o = PackedVector2Array()
	o.append(v2(Ly.serve))
	var i = int(Ly.j) - 1
	while i >= 0: o.append(v2(Ly.road[i])); i -= 1
	return o

static func foe_hp(ci: int) -> float: return FOE_HP * (1.0 + 0.6 * ci)
static func foe_coin(ci: int) -> float: return 10.0 * (ci + 1)
static func guard_dps(glv: float) -> float: return 10.0 + 2.0 * glv
static func slots(sid: String) -> int: return int(st_def(sid).get("worker_slots", 3))

# 冥幣縮寫：K／M／B／T
static func fmt(v) -> String:
	var x = floor(float(v))
	var neg = x < 0.0; x = absf(x)
	var s = ""
	if x >= 1e12: s = _f1(x / 1e12) + "T"
	elif x >= 1e9: s = _f1(x / 1e9) + "B"
	elif x >= 1e6: s = _f1(x / 1e6) + "M"
	elif x >= 1e4: s = _f1(x / 1e3) + "K"
	else: s = str(int(x))
	return ("-" if neg else "") + s
static func _f1(v: float) -> String:
	var r = floor(v * 10.0) / 10.0
	return str(int(r)) if r >= 100.0 or r == floor(r) else "%.1f" % r
