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
	_mt = {}
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
	reg_metrics()
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
static var _mt := {}
static func map_tbl(ci: int) -> Dictionary:   # maps[ci] ＋ 已過審新攤（market_goods_live.json maps_add）
	if _mt.has(ci): return _mt[ci]
	var m = D().maps.get(str(ci))
	var o: Dictionary = (m as Dictionary).duplicate(true) if m is Dictionary else {}
	var add = MD.live_maps_add(ci)
	for street in add:
		if not (o.get(street) is Array): o[street] = []
		for sid in add[street]: if not (o[street] as Array).has(sid): o[street].append(sid)
	_mt[ci] = o
	return o
static func street_of(ci: int, sid: String) -> String:   # 本章呢個台喺邊條街
	var m = map_tbl(ci)
	for k in m: if m[k] is Array and (m[k] as Array).has(sid): return str(k)
	return str(D().cat.get(sid, "food"))
static func removed() -> Dictionary:   # 改成系統／降原料：唔再當攤（sid → 去向）
	var o = {}
	for k in ["system", "raw"]:
		var d = D().get(k)
		if d is Dictionary: for sid in d: o[str(sid)] = d[sid]
	return o
static func stall_list(ci: int) -> Array:   # 本章所有攤（maps 表＋招牌＋原版未分街嘅），剔走改系統／原料
	var o = []; var rm = removed()
	var m = map_tbl(ci)
	for k in ids():
		var a = m.get(k)
		if a is Array: for s in a: if not o.has(str(s)) and MD.st_def(str(s)).size(): o.append(str(s))
	var sg = D().get("signature")
	if sg is Dictionary: for k in sg: if not o.has(str(sg[k])) and MD.st_def(str(sg[k])).size(): o.append(str(sg[k]))
	if m.is_empty():   # 冇按章表（例如第 7 章起地圖未做）：照原版
		for s in MD.stations_raw(ci): if not o.has(s): o.append(s)
	var so = OPS().sub_only(ci)   # [M1 營運] 配對表：副貨攤唔再獨立擺攤（佢隻貨變主攤 Lv25 副貨）
	var out = []
	for s in o: if not rm.has(s) and not so.has(s): out.append(s)
	return out
static func base_slots(ci: int) -> Array:   # 本章地圖上有位置嘅台位（次序＝原版）
	var st = MD.layout(ci).get("st", {}); var o = []
	for s in MD.stations_raw(ci): if st is Dictionary and st.has(s): o.append(s)
	if st is Dictionary: for s in st: if not o.has(str(s)): o.append(str(s))
	return o
static func goal_skip(ci: int, g) -> bool:   # 目標指住唔再喺本章擺嘅台：當跳過
	if not active() or not (g is Dictionary): return false
	var k = str(g.get("k", ""))
	if not k.begins_with("st_") or not (str(g.get("t", "")) in ["unlock", "level", "hire", "sell"]): return false
	return not stall_list(ci).has(k)
static func sids_on(ci: int, street: String) -> Array:   # 本章呢條街賣嘅台（次序跟 maps 表，其次本章台次序）
	var o = []; var all = MD.stations(ci)
	var m = map_tbl(ci).get(street)
	if m is Array: for s in m: if all.has(str(s)) and not o.has(str(s)): o.append(str(s))
	for s in all: if not o.has(s) and street_of(ci, s) == street: o.append(s)
	return o
static func cur_ci() -> int:
	var s = S()
	if s == null or not (s.get("mv") is Dictionary): return 0
	return int(J.num(s.mv.get("ci", 0)))
static func lux_ready(ci: int) -> bool: return ci >= int(D().get("lux_from_ci", 2))
const KPI_FLAG := {"cloth": "mk_cloth", "weapon": "mk_weapon", "acc": "mk_acc"}   # 市集 KPI ①②③（甄好賣）開街
const KPI_GATE := {"cloth": "mk1", "weapon": "mk2", "acc": "mk3"}
static func KG(): return load("res://game/kpi/kpi_data.gd")
static func kpi_gate(street: String) -> String: return str(KPI_GATE.get(street, ""))
static func is_open(street: String) -> bool:
	if street == "lux" and not lux_ready(cur_ci()): return false   # 第 1、2 章奢侈品店「裝修中」
	if KPI_FLAG.has(street) and KG().on() and not KG().gate(kpi_gate(street)).is_empty():   # KPI 開咗：照考核
		return KG().is_open(str(KPI_FLAG[street]))
	var f = J.G.get("mk_open_fn")
	if f is Callable and (f as Callable).is_valid():
		var r = f.call(street)
		if r != null: return J.t(r)
	var o = st().get("open", {})
	if o is Dictionary and o.has(street): return J.t(o[street])
	return J.t(street_def(street).get("open", 0))
static func set_open(street: String, v := true) -> void: st().open[street] = 1 if v else 0
static func lock_text(street: String, ci := -1) -> String:
	if street == "lux" and ci >= 0 and not lux_ready(ci) and street_def(street).has("reno"): return T(street_def(street).reno)
	return T(street_def(street).get("lock", ["未開放", "未開放"]))
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
static func slot_map(ci: int) -> Dictionary:   # sid → 佔用邊個台位（當前街排頭幾個位）；未啟用：自己位
	var o = {}; var all = MD.stations(ci)
	for s in all: o[s] = s
	if not active(): return o
	var slots = base_slots(ci)
	if slots.is_empty(): return o
	for s in all: if not slots.has(s): o[s] = slots[0]   # 冇自己位嘅台（移章／新台）：唔顯示時暫借第一個位
	var on = sids_on(ci, cur())
	for i in on.size(): o[on[i]] = slots[i % slots.size()]
	return o

# ---------------- 市集 KPI 指標（M2 有正式數據就 register_metric 覆蓋）----------------
static var _metrics_done := false
static func reg_metrics() -> void:
	if _metrics_done: return
	_metrics_done = true
	var K = KG()
	K.register_metric("mk_food_lv", func(): return street_lv(cur_ci(), "food"))
	K.register_metric("mk_lv25_fc", func(): return float(int(street_max_lv(cur_ci(), "food") >= 25.0) + int(street_max_lv(cur_ci(), "cloth") >= 25.0)))
	K.register_metric("mk_combo", func(): return J.num(st().get("combo_n", 0)) if J.t(st().get("combo_live")) else floor(sold_total() / 6.0))   # M2 未接連單：暫用賣出件數 ÷6
	K.register_metric("mk_renown_lv", func(): return J.num(st().get("renown_lv", 0)) if J.t(st().get("renown_live")) else (2.0 if sold_total() >= 300.0 else (1.0 if sold_total() >= 80.0 else 0.0)))
	K.register_metric("mk_militia", func(): return militia_n())
	K.register_metric("mk_reg_visits", func(): return float(load("res://game/market/mk_fun.gd").reg_visits()))   # [M2] 熟客累計來訪（市集考核 ③ 用；取代遊魂兵）
	K.register_metric("mk_patrol_done", func(): return J.num(st().get("patrol_done", 0)))   # [M1 營運] 巡邏隊成功處理事件次數（mk_ops）
	OPS().reg()
static func _mv():
	var s = S()
	return s.get("mv") if s != null and s.get("mv") is Dictionary else null
static func _lv(sid: String) -> float:
	var m = _mv(); if m == null or not (m.get("st") is Dictionary): return 0.0
	var e = m.st.get(sid)
	return J.num(e.get("lv", 0)) if e is Dictionary else 0.0
static func street_lv(ci: int, street: String) -> float:
	var n = 0.0
	for sid in sids_on(ci, street): n += _lv(sid)
	return n
static func street_max_lv(ci: int, street: String) -> float:
	var n = 0.0
	for sid in sids_on(ci, street): n = maxf(n, _lv(sid))
	return n
static func sold_total() -> float:
	var m = _mv(); if m == null or not (m.get("sold") is Dictionary): return 0.0
	var n = 0.0
	for k in m.sold: n += J.num(m.sold[k])
	return n
static func militia_n() -> float:
	var m = _mv(); if m == null or not (m.get("war") is Dictionary): return 0.0
	var v = m.war.get("vol")
	return float((v as Array).size()) if v is Array else 0.0

# ---------------- 防守簡化 ----------------
static func DEF() -> Dictionary:
	var d = D().get("defense")
	return d if d is Dictionary else {}
static func can_occupy(ci: int, sid: String) -> bool:
	if not active(): return true
	var stt = street_of(ci, sid)
	if not is_open(stt): return false
	var cd = st().get("occ_cd", {})
	return not (cd is Dictionary and float(cd.get(stt, 0.0)) > 0.0)
static func on_occupy(ci: int, sid: String) -> void:
	if not active(): return
	var m = st()
	if not (m.get("occ_cd") is Dictionary): m["occ_cd"] = {}
	m.occ_cd[street_of(ci, sid)] = float(DEF().get("street_cd_s", 1200.0))
	m["occ_t"] = 0.0
static func patrol_clear(dt: float, militia: int) -> bool:   # 霸檔期間：遊魂兵夠數，auto_clear_s 秒後自動打走
	if not active(): return false
	var m = st(); m["occ_t"] = float(m.get("occ_t", 0.0)) + dt
	if militia < int(DEF().get("auto_clear_militia", 12)): return false
	if float(m.occ_t) < float(DEF().get("auto_clear_s", 10.0)): return false
	m.occ_t = 0.0
	return true
static func _tick_cd(dt: float) -> void:
	var cd = st().get("occ_cd")
	if not (cd is Dictionary): return
	for k in cd.keys(): cd[k] = maxf(0.0, float(cd[k]) - dt)

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
	return m * OPS().prod_k(sid)   # [M1 營運] 店員遞減、換貨中、吵架停工、冇櫃檯員去收錢
static func OPS(): return load("res://game/market/mk_ops.gd")
static func ot_mul(sid: String) -> float:   # 只計加班／老員工（唔計店員人數、停工）
	if not active(): return 1.0
	var o2 = ot(sid)
	return (1.0 + otf("rank_bonus", 0.1) * int(o2.get("rank", 0))) * (otf("mul", 2.0) if J.t(o2.get("on")) else 1.0)
static func feed(sid: String) -> String:   # "ok"／"no_bao"／"not_down"
	if not is_down(sid): return "not_down"
	var n = int(otf("feed_cost", 2))
	if not M.take({"m_bao": float(n)}): return "no_bao"
	var o = ot(sid); o.down = 0.0; o.fat = otf("reset_fat", 35.0)
	evq.append({"k": "feed", "sid": sid}); evq.append({"k": "up", "sid": sid})
	return "ok"
static func tick(sids: Array, dt: float, working: Callable = Callable()) -> void:   # sim.step 每格叫（working(sid)＝有冇人做緊）
	if not active() or dt <= 0.0: return
	_tick_cd(dt)
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
