# 過勞鬼市集（市集程序組 M2）：名聲。冇 class_name、冇 autoload（熱更新規矩）。
#   S.mkr = {pts, lv_seen, ex_day, ex_n}；跨章保留（唔跟地圖重置）。
#   等級（1 起）：無名小檔 → 街坊口碑 → 陰間打卡點 → 地府米其林 → 傳說老字號（門檻 data/market_fun.json renown.lv）
#   用途：
#     1. 酒館名鬼機率（tavern.gd 讀 named_p()）；等級 4 起名單必有 1 格名鬼（named_pin()）
#     2. 回陽間通行證：第 3 章（ci≥2）起要等級 ≥2（back_ok()；landmark.gd 回陽間入口讀）
#     3. 拔營條件：每章要等級達 move_lv[ci]（move_ok()；mv_sim.can_move 讀）
#     4. 市集管理處匯兌：每日 3 次，名聲 → 冥幣（exchange()）
extends RefCounted

const PATH := "res://data/market_fun.json"
static var _D = null
static var evq: Array = []
static var now_s := -1.0   # 測試：覆寫現實時間（匯兌日期）

static func D() -> Dictionary:
	if _D == null:
		var f = FileAccess.open(PATH, FileAccess.READ)
		var o = JSON.parse_string(f.get_as_text()) if f != null else null
		_D = o.get("renown", {}) if o is Dictionary else {}
	return _D
static func cf(k: String, d: float) -> float: return float(D().get(k, d))
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func st() -> Dictionary:
	var s = S()
	if s == null: return {}
	if not (s.get("mkr") is Dictionary): s["mkr"] = {"v": 1, "pts": 0.0, "lv_seen": 1, "ex_day": -1, "ex_n": 0}
	return s.mkr
# M1 接口：巡邏處理成功／玩家親自處理時 M1 叫 J.G.mk_renown_add_fn(pts, why)；人流係數讀 S.mk.renown_lv
static func reg() -> void:
	var f = J.G.get("mk_renown_add_fn")
	if not (f is Callable and (f as Callable).is_valid()): J.G["mk_renown_add_fn"] = func(p, why = ""): add(float(J.num(p)), str(why))
	var s = S()
	if s == null: return
	if s.get("mk") is Dictionary:
		var m: Dictionary = s.mk
		var pend = float(J.num(m.get("renown_pts", 0.0)))   # M2 未登記前 M1 暫存嘅分：收返
		if pend > 0.0: m["renown_pts"] = 0.0; add(pend, "m1")
		m["renown_lv"] = level(); m["renown_live"] = 1   # KPI 指標 mk_renown_lv 讀真等級
static func pts() -> float: return float(J.num(st().get("pts", 0.0)))
static func level() -> int:   # 1–5
	var L: Array = D().get("lv", [0, 200, 800, 3000, 10000])
	var p = pts(); var n = 0
	for x in L: if p >= float(x): n += 1
	return maxi(1, n)
static func level_name(lv := -1) -> String:
	if lv < 0: lv = level()
	var N: Array = D().get("names", [])
	if N.is_empty(): return str(lv)
	var a = N[clampi(lv - 1, 0, N.size() - 1)]
	return str(a[0]) if DB.lang == "yue" else str(a[1])
static func next_at() -> float:   # 下一級要幾多（滿級回 -1）
	var L: Array = D().get("lv", [0, 200, 800, 3000, 10000])
	var lv = level()
	return float(L[lv]) if lv < L.size() else -1.0
static func add(n: float, why := "") -> void:
	var s = st()
	if s.is_empty() or n <= 0.0: return
	s.pts = pts() + n
	var lv = level()
	if lv > int(J.num(s.get("lv_seen", 1))):
		s.lv_seen = lv
		evq.append({"k": "renown_up", "lv": lv, "name": level_name(lv), "why": why})
static func tick() -> void: reg()
static func pop_events() -> Array:
	var e = evq; evq = []
	return e
# 1. 酒館名鬼
static func named_p() -> float:
	var a: Array = D().get("named_p", [0.03, 0.06, 0.10, 0.10, 0.10])
	return float(a[clampi(level() - 1, 0, a.size() - 1)]) if S() != null else 0.03
static func named_pin() -> bool: return S() != null and level() >= int(cf("named_pin_lv", 4))
# 2. 回陽間通行證
static func back_ok(ci: int) -> bool: return ci < int(cf("back_ch", 2)) or level() >= int(cf("back_lv", 2))
static func back_lock_text() -> String:
	var lv = int(cf("back_lv", 2))
	return ("回陽間要市集名聲達到「%s」（地府官員批文）" if DB.lang != "yue" else "回陽間要市集名聲去到「%s」（地府官員批文）") % level_name(lv)
# 3. 拔營
static func move_need(ci: int) -> int:
	var a: Array = D().get("move_lv", [2, 2, 3, 3, 4, 4])
	return int(a[clampi(ci, 0, a.size() - 1)]) if a.size() else 1
static func move_ok(ci: int) -> bool: return level() >= move_need(ci)
# 4. 匯兌
static func _day() -> int:
	var u = now_s if now_s > 0.0 else Time.get_unix_time_from_system()
	var bias = Time.get_time_zone_from_system().get("bias", 0) * 60.0
	return int(floor((u + bias) / 86400.0))
static func exch_left() -> int:
	var s = st()
	if s.is_empty(): return 0
	if int(J.num(s.get("ex_day", -1))) != _day(): return int(cf("exch_day", 3))
	return maxi(0, int(cf("exch_day", 3)) - int(J.num(s.get("ex_n", 0))))
static func exch_coins(ci: int) -> float: return cf("exch_coin", 100.0) * pow(cf("exch_scale", 5.0), ci)
static func exchange(ci: int) -> Dictionary:   # {"ok":bool, "why", "coins"}；只扣「未用嚟升級」嘅名聲點數，唔會跌級（等級按最高記錄 lv_seen 計門檻用途）
	var s = st()
	if s.is_empty(): return {"ok": false, "why": "no_save"}
	if exch_left() <= 0: return {"ok": false, "why": "limit"}
	var cost = cf("exch_cost", 50.0)
	var floor_pts = 0.0
	var L: Array = D().get("lv", [0, 200, 800, 3000, 10000])
	floor_pts = float(L[clampi(level() - 1, 0, L.size() - 1)])
	if pts() - cost < floor_pts: return {"ok": false, "why": "pts"}   # 換咗會跌級就唔俾換
	if int(J.num(s.get("ex_day", -1))) != _day(): s.ex_day = _day(); s.ex_n = 0
	s.ex_n = int(J.num(s.get("ex_n", 0))) + 1
	s.pts = pts() - cost
	var c = exch_coins(ci)
	var SS = S(); SS.res["coins"] = float(J.num(SS.res.get("coins", 0.0))) + c
	return {"ok": true, "coins": c}
