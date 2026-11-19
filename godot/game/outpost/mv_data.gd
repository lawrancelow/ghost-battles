# 移動村（出殯巡遊大排檔）：資料＋公式（全部 static，冇 class_name；用 load("res://game/outpost/mv_data.gd") 叫）
# 資料：data/nat/outpost.json（格式見 MV_CONTRACT.md）。公式全部喺呢度，畫面／模擬／測試共用。
#
# 公式（lv = 生產台等級，sd = STATIONS[sid]）：
#   里程碑數   nm(lv)      = sd.miles 入面 ≤ lv 嘅個數
#   里程碑倍數 mile(lv)    = 2 ^ nm(lv)                                 （每過一個 miles ×2 收益）
#   每次產量   out(lv)     = base_out + floor((lv − 1) / 10)            （每 10 級多 1 件）
#   做貨時間   tm(lv)      = base_time ÷ (1 + 0.02 × (lv − 1))          （加速中再 ÷ 2）
#   單價       val(lv)     = GOODS[good].price × (1 + 0.1 × (lv − 1)) × mile(lv) × 地圖倍數(MAPS.mul，預設 1)
#   升一級     cost1(lv)   = ceil(up_cost0 × up_mul ^ (lv − 1))          （lv → lv+1）
#   升 n 級    cost_n      = Σ cost1(lv … lv+n−1)；最高級 = miles 最大值
#   客人付錢   = Σ 件數 × val(嗰種貨個台嘅等級) × 收益倍數（收益掣開咗 ×2）
#   離線       每秒 = Σ有員工嘅台 員工數 × out × val ÷ (tm + CARRY_S)；最多 OFFLINE_H 小時；唔計加速／收益掣
#   圍欄       孤魂血 = FOE_HP × (1 + 0.6 × ci)；守夜每秒傷害 = 10 + 2 × 鬼等級；撳一下 = TAP_DMG；打走 = 10 × (ci + 1) 冥幣
extends RefCounted

const PATH := "res://data/nat/outpost.json"
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
	return o
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
static func miles(sid: String) -> Array:
	var m = st_def(sid).get("miles", [10, 25, 50, 75, 100])
	return m if m is Array and m.size() > 0 else [100]
static func max_lv(sid: String) -> int:
	var mx = 1
	for x in miles(sid): mx = maxi(mx, int(x))
	return mx
static func nm(sid: String, lv: float) -> int:
	var n = 0
	for x in miles(sid): if lv >= float(x): n += 1
	return n
static func mile_mul(sid: String, lv: float) -> float: return pow(2.0, nm(sid, lv))
static func next_mile(sid: String, lv: float) -> int:
	var best = -1
	for x in miles(sid):
		if float(x) > lv and (best < 0 or int(x) < best): best = int(x)
	return best
static func out(sid: String, lv: float) -> int: return int(st_def(sid).get("base_out", 1)) + int(floor((lv - 1.0) / 10.0))
static func tm(sid: String, lv: float) -> float: return float(st_def(sid).get("base_time", 5.0)) / (1.0 + 0.02 * (lv - 1.0))
static func val(sid: String, lv: float, ci: int) -> float:
	var g = good_def(str(st_def(sid).get("good", "")))
	return float(g.get("price", 1.0)) * (1.0 + 0.1 * (lv - 1.0)) * mile_mul(sid, lv) * map_mul(ci)
static func cost1(sid: String, lv: float) -> float:
	var sd = st_def(sid)
	return ceil(float(sd.get("up_cost0", 10.0)) * pow(float(sd.get("up_mul", 1.12)), lv - 1.0))
static func cost_n(sid: String, lv: float, n: int) -> float:
	var c = 0.0
	for i in n: c += cost1(sid, lv + i)
	return c
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
