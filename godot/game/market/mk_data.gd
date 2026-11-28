# 過勞鬼市集（市集程序組 M1）：街道框架＋過勞營業。冇 class_name、冇 autoload（熱更新規矩）。
# 用法：const MK = preload("res://game/market/mk_data.gd")
#
# 一、街道（data/market.json）
#   市集分五條街：食街 food／衣街 cloth／兵器街 weapon／飾品街 acc／奢侈品店 lux。一次只顯示一條（cur）。
#   【老闆鐵則】每章（地圖 ci）賣嘅嘢唔同：maps[ci][街] 列出該章該街嘅台；冇列到嘅台用 cat 自動歸街。
#   台嘅「位」：當前街嘅台輪流佔用本章所有台位（第 i 個台 → 本章第 i 個台嘅位置／搬貨路線），其他街嘅台照生產、唔畫。
#   開街：J.G["mk_open_fn"]（Callable(street_id) -> bool，KPI 組接）＞ S.mk.open[街]＞ streets[].open。
# 二、過勞營業（overtime）
#   每台可開「加班」：產量 ×mul；全台店員過勞值 fat 上升（fat_rate／秒），唔加班就回落（rec_rate）。
#   fat 到 fat_max：店員趴低（down_s 秒停工，口吐白煙、魂飛出去被扯返），可「餵普通包子」（feed_cost 個 m_bao）即刻復工。
#   加班累積秒數到 rank_s[i]：老員工升職（rank +1），該台永久 +rank_bonus 產速。
# 三、測試：GB_TEST 下要 S.mk.test＝1 先開（其他測試照舊：唔分街、唔加班）。
extends RefCounted

const ON := true
const PATH := "res://data/market.json"
const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
static var _D = null
static var evq: Array = []    # 畫面用事件：{"k": "down"/"up"/"rank"/"feed", "sid", ...}

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {}
	for k in ["cat", "maps", "overtime"]: if not (_D.get(k) is Dictionary): _D[k] = {}
	if not (_D.get("streets") is Array): _D["streets"] = []

static func yue() -> bool: return DB.lang == "yue"
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[0]) if yue() else str(a[1])
	return str(a)
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func st() -> Dictionary:
	var s = S()
	if s == null: return {}
	if not (s.get("mk") is Dictionary): s["mk"] = {"v": 1, "cur": "food", "open": {}, "ot": {}}
	var m: Dictionary = s.mk
	for k in ["open", "ot"]: if not (m.get(k) is Dictionary): m[k] = {}
	if not m.has("cur"): m["cur"] = "food"
	return m
static func active() -> bool:
	if not ON or S() == null: return false
	if OS.has_environment("GB_TEST") and not J.t(st().get("test")): return false
	return true

# ---------------- 街 ----------------
static func streets() -> Array: return D().streets
static func ids() -> Array:
	var o = []
	for s in streets(): o.append(str(s.get("id", "")))
	return o
static func street_def(id: String) -> Dictionary:
	for s in streets(): if str(s.get("id", "")) == id: return s
	return {}
static func name(id: String) -> String: return T(street_def(id).get("n", id))
static func map_tbl(ci: int) -> Dictionary:
	var m = D().maps.get(str(ci))
	return m if m is Dictionary else {}
static func street_of(ci: int, sid: String) -> String:   # 本章呢個台喺邊條街
	var m = map_tbl(ci)
	for k in m: if m[k] is Array and (m[k] as Array).has(sid): return str(k)
	return str(D().cat.get(sid, "food"))
static func sids_on(ci: int, street: String) -> Array:   # 本章呢條街賣嘅台（次序跟 maps 表，其次本章台次序）
	var o = []; var all = MD.stations(ci)
	var m = map_tbl(ci).get(street)
	if m is Array: for s in m: if all.has(str(s)) and not o.has(str(s)): o.append(str(s))
	for s in all: if not o.has(s) and street_of(ci, s) == street: o.append(s)
	return o
static func is_open(street: String) -> bool:
	var f = J.G.get("mk_open_fn")
	if f is Callable and (f as Callable).is_valid():
		var r = f.call(street)
		if r != null: return J.t(r)
	var o = st().get("open", {})
	if o is Dictionary and o.has(street): return J.t(o[street])
	return J.t(street_def(street).get("open", 0))
static func set_open(street: String, v := true) -> void: st().open[street] = 1 if v else 0
static func lock_text(street: String) -> String: return T(street_def(street).get("lock", ["未開放", "未開放"]))
static func cur() -> String:
	var c = str(st().get("cur", "food"))
	return c if ids().has(c) else (ids()[0] if ids().size() else "food")
static func set_cur(id: String) -> bool:
	if not ids().has(id) or id == cur(): return false
	st()["cur"] = id
	return true
static func step_cur(dir: int) -> String:   # 左右滑：順序切街（鎖住嘅街都可以睇，會顯示開放條件）
	var L = ids(); if L.is_empty(): return ""
	var i = (L.find(cur()) + dir + L.size()) % L.size()
	set_cur(L[i]); return L[i]
static func shown(ci: int, sid: String) -> bool:   # 呢個台而家畫唔畫
	if not active(): return true
	return street_of(ci, sid) == cur() and is_open(cur())
static func slot_map(ci: int) -> Dictionary:   # sid → 佔用邊個台嘅位（當前街）；未啟用：自己位
	var o = {}; var all = MD.stations(ci)
	for s in all: o[s] = s
	if not active(): return o
	var on = sids_on(ci, cur())
	for i in on.size(): if i < all.size(): o[on[i]] = all[i]
	return o

# ---------------- 過勞營業 ----------------
static func OT() -> Dictionary: return D().overtime
static func otf(k: String, dflt: float) -> float: return float(OT().get(k, dflt))
static func ot(sid: String) -> Dictionary:
	var m = st()
	if m.is_empty(): return {}
	if not (m.ot.get(sid) is Dictionary): m.ot[sid] = {"on": 0, "fat": 0.0, "down": 0.0, "xp": 0.0, "rank": 0}
	return m.ot[sid]
static func ot_on(sid: String) -> bool: return active() and J.t(ot(sid).get("on"))
static func is_down(sid: String) -> bool: return active() and float(ot(sid).get("down", 0.0)) > 0.0
static func fat(sid: String) -> float: return float(ot(sid).get("fat", 0.0)) if active() else 0.0
static func fat_k(sid: String) -> float: return clampf(fat(sid) / maxf(1.0, otf("fat_max", 100.0)), 0.0, 1.0)
static func rank(sid: String) -> int: return int(ot(sid).get("rank", 0)) if active() else 0
static func toggle_ot(sid: String) -> bool:   # 回新狀態
	if not active() or is_down(sid): return false
	var o = ot(sid); o["on"] = 0 if J.t(o.get("on")) else 1
	return J.t(o.on)
static func mul(sid: String) -> float:   # 生產速度倍數（加班、趴低、老員工）
	if not active(): return 1.0
	var o = ot(sid)
	if float(o.get("down", 0.0)) > 0.0: return 0.0
	var m = 1.0 + otf("rank_bonus", 0.1) * int(o.get("rank", 0))
	if J.t(o.get("on")): m *= otf("mul", 2.0)
	return m
static func feed(sid: String) -> String:   # "ok"／"no_bao"／"not_down"
	if not is_down(sid): return "not_down"
	var n = int(otf("feed_cost", 2))
	if not M.take({"m_bao": float(n)}): return "no_bao"
	var o = ot(sid); o.down = 0.0; o.fat = otf("reset_fat", 35.0)
	evq.append({"k": "feed", "sid": sid}); evq.append({"k": "up", "sid": sid})
	return "ok"
static func tick(sids: Array, dt: float, working: Callable = Callable()) -> void:   # sim.step 每格叫（working(sid)＝有冇人做緊）
	if not active() or dt <= 0.0: return
	var fmax = otf("fat_max", 100.0); var ranks: Array = OT().get("rank_s", [180, 600, 1500])
	for sid in sids:
		var o = ot(sid)
		if float(o.get("down", 0.0)) > 0.0:
			o.down = maxf(0.0, float(o.down) - dt)
			if o.down <= 0.0: o.fat = otf("reset_fat", 35.0); evq.append({"k": "up", "sid": sid})
			continue
		var busy = true if not working.is_valid() else J.t(working.call(sid))
		if J.t(o.get("on")) and busy:
			o.fat = minf(fmax, float(o.get("fat", 0.0)) + otf("fat_rate", 1.6) * dt)
			o.xp = float(o.get("xp", 0.0)) + dt
			var rk = int(o.get("rank", 0))
			if rk < ranks.size() and float(o.xp) >= float(ranks[rk]):
				o.rank = rk + 1; evq.append({"k": "rank", "sid": sid, "rank": rk + 1})
			if o.fat >= fmax:
				o.on = 0; o.down = otf("down_s", 45.0); evq.append({"k": "down", "sid": sid})
		else:
			o.fat = maxf(0.0, float(o.get("fat", 0.0)) - otf("rec_rate", 2.5) * dt)
static func pop_events() -> Array:
	var e = evq; evq = []
	return e
