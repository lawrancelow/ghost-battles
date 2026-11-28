# 過勞鬼市集 M1 營運層：製作店員位、攤位雙貨、櫃檯（收銀箱）、巡邏隊、常態治安事件。
# 冇 class_name、冇 autoload（熱更新規矩）。用法：const MKO = preload("res://game/market/mk_ops.gd")
# 數值：data/market_ops.json。狀態：S.mk.ops（跟存檔）。接口說明：repo 根目錄 MARKET_API.md。
#
# 一、製作店員位：按攤位等級 Lv1/10/25/50/100/200 → 1/2/3/3/4/5 位（奢侈品店最多 2）；
#     產能倍數 staff_mul(n)＝1／1.35／1.70／1.95／2.20（遞減），每名店員實際速度＝staff_mul(n)÷n（prod_k）。
# 二、雙貨：Lv25 解鎖副貨（同章同街、未被其他已開攤佔用嘅商品）；每轉做完按比例／智能補貨決定做主貨定副貨；
#     換貨免費，換完 10 秒「換貨中」唔產出。
# 三、櫃檯：每條街一個收銀箱 till。客人俾錢先入收銀箱；有櫃檯員 → 每 6÷人數 秒自動入帳；
#     冇櫃檯員 → 每 20 秒由製作店員去收一次（全街停產 3 秒），或者玩家撳收銀箱即收。
# 四、巡邏隊：每條街 0–4 隻鬼（由村子調，post＝"mk_pat"，唔再喺村打工）。
#     每件事件逐個隊員追：每人只追一次、每次 handle_s 秒、成功率 catch_p（該章特色版 catch_p_special）。
#     → 處理率 ≈ 1−(1−p)^n：1 人 45%、2 人 70%、3 人 83%、4 人 91%（特色版 30/51/66/76%），滿編都壓唔到 0。
# 五、常態事件：偷錢／偷貨／插隊／吵架打鬧，通用版 60%／該章特色版 40%；每街獨立計時；
#     每條街每 10 分鐘事件損失 ≤ 該街呢 10 分鐘收入 15%，到頂之後只演出唔扣。離線唔生成。
extends RefCounted

const PATH := "res://data/market_ops.json"
const MK = preload("res://game/market/mk_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const POST_CTR := "mk_ctr"
const POST_PAT := "mk_pat"
const FUN_PATH := "res://game/market/mk_fun.gd"   # M2（有先用）
static var _D = null
static var _FUN = null
static var _fun_chk := false
static var _fun_m := {}
static var rng := RandomNumberGenerator.new()

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {}
	for k in ["staff", "goods2", "counter", "patrol", "events", "variants", "goods"]: if not (_D.get(k) is Dictionary): _D[k] = {}
static func cf(sec: String, k: String, dflt: float) -> float:
	var d = D().get(sec)
	return float(d.get(k, dflt)) if d is Dictionary else dflt
static func FUN():   # M2 嘅 mk_fun.gd（未合併時係 null）
	if not _fun_chk:
		_fun_chk = true
		_FUN = load(FUN_PATH) if ResourceLoader.exists(FUN_PATH) else null
	return _FUN
static func _fun(method: String, args: Array, dflt):
	var F = FUN()
	if F == null: return dflt
	if _fun_m.is_empty(): for d in F.get_script_method_list(): _fun_m[str(d.name)] = 1
	if not _fun_m.has(method): return dflt
	var r = F.callv(method, args)
	return dflt if r == null else r

static func on() -> bool: return MK.active()
static func st() -> Dictionary:
	var m = MK.st()
	if m.is_empty(): return {}
	if not (m.get("ops") is Dictionary): m["ops"] = {"v": 1}
	var o: Dictionary = m.ops
	for k in ["sub", "ratio", "smart", "swap", "ctr", "pat", "till", "evt", "win", "rate", "brawl", "ctr_t"]: if not (o.get(k) is Dictionary): o[k] = {}
	if not (o.get("ev") is Array): o["ev"] = []
	if not o.has("clk"): o["clk"] = 0.0
	if not o.has("seq"): o["seq"] = 0
	return o
static func clk() -> float: return float(st().get("clk", 0.0))
static func _mv():
	var s = MK.S()
	return s.get("mv") if s != null and s.get("mv") is Dictionary else null
static func _sst(sid: String):
	var m = _mv()
	if m == null or not (m.get("st") is Dictionary): return null
	var e = m.st.get(sid)
	return e if e is Dictionary else null
static func _lv(sid: String) -> float:
	var e = _sst(sid)
	return J.num(e.get("lv", 1)) if e != null else 1.0
static func _unlocked(sid: String) -> bool:
	var e = _sst(sid)
	return e != null and J.t(e.get("unlocked"))
static func _nworkers(sid: String) -> int:
	var e = _sst(sid)
	if e == null or not (e.get("workers") is Array): return 0
	var n = 0
	for g in e.workers: if g != null: n += 1
	return n
static func reg() -> void:   # 登記畀 M2／KPI 用嘅接口（可重複叫）
	if not (J.G.get("mk_counter_n_fn") is Callable): J.G["mk_counter_n_fn"] = func(street): return counter_n(str(street))

# ================= 一、製作店員位 =================
static func staff_slots(sid: String, lv: float) -> int:   # 呢個攤而家有幾多個製作店員位
	var n = 1
	for row in D().staff.get("lv", [[1, 1], [10, 2], [25, 3], [50, 3], [100, 4], [200, 5]]):
		if row is Array and row.size() >= 2 and lv >= float(row[0]): n = maxi(n, int(row[1]))
	if MK.street_of(MK.cur_ci(), sid) == "lux": n = mini(n, int(cf("staff", "lux_max", 2)))
	return n
static func extra_slots(sid: String, lv: float) -> int: return staff_slots(sid, lv) - 1   # M2 里程碑演出用（多咗幾多個位）
static func staff_mul(n: int) -> float:   # n 名店員嘅總產能倍數（遞減）
	if n <= 0: return 0.0
	var t = D().staff.get("mul", [1.0, 1.35, 1.7, 1.95, 2.2])
	return float(t[mini(n, t.size()) - 1]) if t is Array and t.size() else float(n)
static func prod_k(sid: String) -> float:   # 每名店員／手做嘅速度倍數（MK.mul 內用）：店員遞減、換貨中、吵架停工
	if not on(): return 1.0
	var o = st()
	if float(o.swap.get(sid, 0.0)) > 0.0: return 0.0
	if float(o.brawl.get(sid, 0.0)) > clk(): return 0.0
	if float(o.get("ctr_stop", 0.0)) > clk() and str(o.get("ctr_stop_st", "")) == MK.street_of(MK.cur_ci(), sid): return 0.0
	var n = _nworkers(sid)
	return staff_mul(n) / float(n) if n > 0 else 1.0
static func _fit_staff(sim) -> void:   # 位數跟等級：唔夠位就補陣列，超出嘅店員放返村
	var m = _mv(); if m == null: return
	for sid in MD.stations(sim.ci()):
		var e = _sst(sid); if e == null or not (e.get("workers") is Array): continue
		var cap = staff_slots(sid, _lv(sid))
		while e.workers.size() < cap: e.workers.append(null)
		for i in range(cap, e.workers.size()):
			if e.workers[i] == null: continue
			var gh = sim.ghost(e.workers[i])
			if gh != null and J.seq(J.gp(gh, "post"), "mv"): J.sp(gh, "post", null)
			e.workers[i] = null; sim._sync_key = ""

# ================= 二、雙貨 =================
static func good_of(sid: String) -> String: return str(MD.st_def(sid).get("good", ""))
static func sub_open(sid: String) -> bool: return on() and _unlocked(sid) and _lv(sid) >= cf("goods2", "lv", 25.0)
static func sub_of(sid: String) -> String:   # 副貨（冇＝""）
	if not on(): return ""
	var g = str(st().sub.get(sid, ""))
	return g if g != "" and sub_open(sid) else ""
static func sub_choices(ci: int, sid: String) -> Array:   # 可揀副貨：同章同街、唔係已開攤主貨、未被其他攤揀咗
	var o = []
	if not sub_open(sid): return o
	var street = MK.street_of(ci, sid)
	var taken = {}
	for k in st().sub: if str(k) != sid and str(st().sub[k]) != "": taken[str(st().sub[k])] = 1
	for s2 in MK.sids_on(ci, street):
		if s2 == sid or _unlocked(s2): continue
		var g = good_of(s2)
		if g != "" and not taken.has(g) and not o.has(g): o.append(g)
	var gl = D().goods.get(str(ci))
	if gl is Dictionary and gl.get(street) is Array:   # 只有貨、冇攤嘅商品（goods_final「副貨」欄）
		for row in gl[street]:
			if not (row is Dictionary) or not J.t(row.get("sub_only")): continue
			var g = str(row.get("good", ""))
			if g != "" and not MD.good_def(g).is_empty() and not taken.has(g) and not o.has(g): o.append(g)
	return o
static func set_sub(ci: int, sid: String, gid: String) -> String:   # "ok"／"locked"／"bad"；換貨後 swap_s 秒唔產出
	if not sub_open(sid): return "locked"
	if gid != "" and not sub_choices(ci, sid).has(gid): return "bad"
	var o = st()
	if str(o.sub.get(sid, "")) == gid: return "ok"
	if gid == "": o.sub.erase(sid)
	else: o.sub[sid] = gid
	o.swap[sid] = cf("goods2", "swap_s", 10.0)
	MK.evq.append({"k": "swap", "sid": sid, "gid": gid})
	return "ok"
static func ratio(sid: String) -> float: return clampf(float(st().ratio.get(sid, cf("goods2", "ratio", 0.5))), 0.0, 1.0)   # 副貨佔產能比例
static func set_ratio(sid: String, v: float) -> void: st().ratio[sid] = clampf(v, 0.0, 1.0)
static func smart(sid: String) -> bool: return J.t(st().smart.get(sid, 1))
static func set_smart(sid: String, v: bool) -> void: st().smart[sid] = 1 if v else 0
static func host_of(gid: String) -> String:   # 邊個攤用副貨格賣緊呢樣貨
	if not on(): return ""
	var o = st().sub
	for sid in o: if str(o[sid]) == gid and sub_open(str(sid)): return str(sid)
	return ""
static func sub_goods() -> Array:
	var o = []
	if not on(): return o
	for sid in st().sub:
		var g = sub_of(str(sid))
		if g != "" and not o.has(g): o.append(g)
	return o
static func wgood(w: Dictionary, dflt: String) -> String: return str(w.get("cg", dflt)) if w.has("cg") else dflt   # 店員手上嗰轉係邊樣貨
static func pick_sub(sim, sid: String) -> bool:   # 呢一轉做唔做副貨
	var g2 = sub_of(sid)
	if g2 == "": return false
	var g1 = good_of(sid)
	if smart(sid):   # 智能補貨：櫃台邊格缺貨就先做邊格
		var low = int(cf("goods2", "low_n", 3))
		var n1 = sim.counter_n(g1); var n2 = sim.counter_n(g2)
		if n2 < low and n1 >= low: return true
		if n1 < low and n2 >= low: return false
	var o = st()
	var acc = float(o.get("acc_" + sid, 0.0)) + ratio(sid)   # 誤差累積（唔用隨機，比例穩定）
	var sub = acc >= 1.0 - 1e-6
	if sub: acc -= 1.0
	o["acc_" + sid] = acc
	return sub
static func batch_sub(sim, sid: String, w: Dictionary, n: int) -> bool:   # mv_sim 做完一轉叫：true＝呢轉係副貨（全數搬去櫃台）
	w.erase("cg")
	if not on() or not pick_sub(sim, sid): return false
	w["cg"] = sub_of(sid); w.carry = n
	sim.ev.append({"k": "made", "sid": sid, "n": n, "pos": w.home, "gid": w.cg})
	sim._go(w)
	return true
static func sub_val(sim, gid: String) -> float:   # 副貨單價：副貨底價 × 寄賣攤等級倍數
	var h = host_of(gid)
	if h == "": return 0.0
	var base = float(MD.good_def(good_of(h)).get("price", 1.0))
	var p = float(MD.good_def(gid).get("price", base))
	return MD.val(h, sim.lv(h), sim.ci()) * (p / maxf(1.0, base))
static func sub_adj(sim, c: Dictionary) -> float:   # cust_value 補差：副貨按自己底價計（sid_of 冇攤時當 0，呢度補返）
	if not on(): return 0.0
	var a = 0.0
	for g in c.got:
		var gid = str(g)
		if host_of(gid) == "": continue
		var own = sim.sid_of(gid)
		var had = float(c.got[g]) * MD.val(own, sim.lv(own), sim.ci()) if own != "" else 0.0
		a += float(c.got[g]) * sub_val(sim, gid) - had
	return a
static func _tick_swap(dt: float) -> void:
	var sw = st().swap
	for k in sw.keys():
		sw[k] = float(sw[k]) - dt
		if float(sw[k]) <= 0.0: sw.erase(k)

# ================= 人手（櫃檯員／巡邏員，由村子調） =================
static func _list(kind: String, street: String) -> Array:
	var d = st().ctr if kind == "ctr" else st().pat
	if not (d.get(street) is Array): d[street] = []
	return d[street]
static func cap(kind: String) -> int: return int(cf("counter", "max", 3)) if kind == "ctr" else int(cf("patrol", "max", 4))
static func staff_of(kind: String, street: String) -> Array: return _list(kind, street).duplicate() if on() else []
static func assign(sim, kind: String, street: String, gid) -> String:   # "ok"／"full"／"bad"／"closed"；鬼由原崗位調走
	if not on() or not MK.ids().has(street): return "bad"
	if not MK.is_open(street): return "closed"
	var L = _list(kind, street)
	if L.size() >= cap(kind): return "full"
	var gh = sim.ghost(gid)
	if gh == null or J.seq(J.gp(gh, "k"), "afu"): return "bad"
	var p = J.gp(gh, "post")
	if J.t(p) and not (J.str(p) in sim.MOVABLE_POSTS) and not (J.str(p) in [POST_CTR, POST_PAT]): return "bad"
	unassign(sim, gid)
	sim._release(gid)
	J.sp(gh, "post", POST_CTR if kind == "ctr" else POST_PAT)
	L.append(J.gp(gh, "id")); sim._sync_key = ""
	MK.evq.append({"k": "staff", "kind": kind, "street": street, "n": L.size()})
	return "ok"
static func unassign(sim, gid) -> bool:
	var hit = false
	for d in [st().ctr, st().pat]:
		for street in d:
			var L = d[street]
			if not (L is Array): continue
			for i in range(L.size() - 1, -1, -1):
				if J.seq(L[i], gid): L.remove_at(i); hit = true
	if hit:
		var gh = sim.ghost(gid)
		if gh != null and (J.str(J.gp(gh, "post")) in [POST_CTR, POST_PAT]): J.sp(gh, "post", null)
	return hit
static func _validate(sim) -> void:   # 鬼冇咗／被調走：由名單剔走
	for pair in [[st().ctr, POST_CTR], [st().pat, POST_PAT]]:
		var d = pair[0]
		for street in d:
			var L = d[street]
			if not (L is Array): continue
			for i in range(L.size() - 1, -1, -1):
				var gh = sim.ghost(L[i])
				if gh == null or not J.seq(J.gp(gh, "post"), pair[1]): L.remove_at(i)
static func counter_n(street: String) -> int: return _list("ctr", street).size() if on() else 0
static func patrol_n(street: String) -> int: return _list("pat", street).size() if on() else 0
static func village_cost() -> int:   # 市集佔用咗幾多隻村鬼（櫃檯＋巡邏）
	var n = 0
	if not on(): return 0
	for s in MK.ids(): n += counter_n(s) + patrol_n(s)
	return n

# ================= 三、櫃檯（收銀箱） =================
static func till(street: String) -> float: return float(st().till.get(street, 0.0)) if on() else 0.0
static func on_pay(sim, c: Dictionary, amt: float) -> void:   # mv_sim._pay 喺 add_coins(amt) 之後叫：錢先入收銀箱（未入帳）
	if not on() or amt <= 0.0: return
	var street = _cust_street(sim, c)
	sim.add_coins(-amt)
	var o = st()
	o.till[street] = float(o.till.get(street, 0.0)) + amt
	_income(street, amt)
static func _cust_street(sim, c: Dictionary) -> String:
	for g in c.get("got", {}):
		var sid = sim.sid_of(str(g))
		if sid == "": sid = host_of(str(g))
		if sid != "": return MK.street_of(sim.ci(), sid)
	return MK.cur()
static func collect(sim, street: String, by := "tap") -> float:   # 收銀箱入帳（玩家撳／櫃檯員／製作店員去收）
	var o = st(); var v = float(o.till.get(street, 0.0))
	if v <= 0.0: return 0.0
	o.till[street] = 0.0
	sim.add_coins(v)
	MK.evq.append({"k": "till", "street": street, "amt": v, "by": by})
	return v
static func _tick_counter(sim, dt: float) -> void:
	var o = st()
	for street in MK.ids():
		if float(o.till.get(street, 0.0)) <= 0.0: o.ctr_t[street] = 0.0; continue
		var n = counter_n(street)
		if n > 0 and J.t(_fun("counter_down", [street], false)): n = 0   # M2：櫃檯趴低＝當冇人
		var t = float(o.ctr_t.get(street, 0.0)) + dt
		var every = cf("counter", "staff_s", 6.0) / float(n) if n > 0 else cf("counter", "auto_s", 20.0)
		if t >= every:
			t = 0.0
			collect(sim, street, "ctr" if n > 0 else "worker")
			if n <= 0:   # 冇櫃檯員：製作店員放低手上嘢去收錢，全街停產幾秒
				o["ctr_stop"] = clk() + cf("counter", "stop_s", 3.0); o["ctr_stop_st"] = street
		o.ctr_t[street] = t

# ================= 收入視窗（15% 損失上限用） =================
static func _win(street: String) -> Dictionary:
	var w = st().win
	if not (w.get(street) is Dictionary): w[street] = {"t0": clk(), "inc": 0.0, "loss": 0.0, "pinc": 0.0, "ploss": 0.0}
	var e: Dictionary = w[street]
	var L = cf("events", "cap_win_s", 600.0)
	while clk() - float(e.t0) >= L:
		e.pinc = e.inc if clk() - float(e.t0) < 2.0 * L else 0.0
		e.ploss = e.loss if clk() - float(e.t0) < 2.0 * L else 0.0
		e.inc = 0.0; e.loss = 0.0; e.t0 = float(e.t0) + L
	return e
static func _income(street: String, amt: float) -> void:
	var e = _win(street); e.inc = float(e.inc) + amt
	var o = st()
	o["inc_all"] = float(o.get("inc_all", 0.0)) + amt
static func win_income(street: String) -> float:   # 滑動 10 分鐘收入（上一個視窗按剩餘比例計）
	var e = _win(street); var f = clampf((clk() - float(e.t0)) / cf("events", "cap_win_s", 600.0), 0.0, 1.0)
	return float(e.inc) + float(e.pinc) * (1.0 - f)
static func win_loss(street: String) -> float:
	var e = _win(street); var f = clampf((clk() - float(e.t0)) / cf("events", "cap_win_s", 600.0), 0.0, 1.0)
	return float(e.loss) + float(e.ploss) * (1.0 - f)
static func loss_room(street: String) -> float: return maxf(0.0, cf("events", "cap_pct", 0.15) * win_income(street) - win_loss(street))
static func _add_loss(street: String, v: float) -> void:
	var e = _win(street); e.loss = float(e.loss) + v
	var o = st()
	o["loss_all"] = float(o.get("loss_all", 0.0)) + v
static func rate60(street: String) -> float: return win_income(street) / 10.0   # 該街 1 分鐘收入（由 10 分鐘視窗推）

# ================= 四、五：常態事件＋巡邏 =================
const TYPES := ["steal_cash", "steal_goods", "cut_queue", "brawl"]
static func events(street := "") -> Array:   # 未完嘅事件（畫面用）
	var o = []
	if not on(): return o
	for e in st().ev: if street == "" or str(e.street) == street: o.append(e)
	return o
static func open_stalls(ci: int, street: String) -> Array:
	var o = []
	for sid in MK.sids_on(ci, street): if _unlocked(sid): o.append(sid)
	return o
static func flow(ci: int, street: String) -> float:   # 人流係數
	var n = open_stalls(ci, street).size()
	var rn = J.num(MK.st().get("renown_lv", 0))
	var k = 1.0 + cf("events", "per_stall", 0.15) * maxf(0.0, float(n - 1)) + cf("events", "per_renown", 0.1) * rn
	var ph = str(_fun("rush_phase", [], ""))
	if ph == "peak": k *= cf("events", "peak_mul", 2.0)
	elif ph == "rest": k *= cf("events", "rest_mul", 0.5)
	return k
static func next_gap(ci: int, street: String) -> float:
	var j = cf("events", "jitter", 0.4)
	return maxf(cf("events", "min_s", 45.0), cf("events", "base_s", 180.0) / flow(ci, street) * rng.randf_range(1.0 - j, 1.0 + j))
static func _pick_type() -> String:
	var W = D().events.get("types", {"steal_cash": 30, "steal_goods": 20, "cut_queue": 25, "brawl": 25})
	var tot = 0.0
	for k in TYPES: tot += float(W.get(k, 0))
	var r = rng.randf() * tot
	for k in TYPES:
		r -= float(W.get(k, 0))
		if r <= 0.0: return k
	return TYPES[0]
static func variant(ci: int, type: String, special: bool) -> Dictionary:   # {"n": [粵, 中], "sp": 0/1, "id"}
	var v = D().variants.get(type)
	if not (v is Dictionary): return {"n": [type, type], "sp": 0, "id": type}
	if special and v.get("ch") is Array and ci >= 0 and ci < v.ch.size() and v.ch[ci] is Dictionary:
		var d: Dictionary = (v.ch[ci] as Dictionary).duplicate(); d["sp"] = 1; d["id"] = "%s_c%d" % [type, ci + 1]
		return d
	var g = v.get("gen", {})
	var d2: Dictionary = (g as Dictionary).duplicate() if g is Dictionary else {}
	d2["sp"] = 0; d2["id"] = type
	return d2
static func spawn_event(sim, street: String, type := "", special := -1) -> Dictionary:   # 生成一件（超上限／冇攤：回 {}）
	var o = st(); var ci = sim.ci()
	var stalls = open_stalls(ci, street)
	if stalls.is_empty(): return {}
	if events(street).size() >= int(cf("events", "max_street", 2)) or o.ev.size() >= int(cf("events", "max_total", 5)): return {}
	if type == "": type = _pick_type()
	var sp = (rng.randf() >= cf("events", "generic_p", 0.6)) if special < 0 else special > 0
	var vr = variant(ci, type, sp)
	o.seq = int(o.seq) + 1
	var e = {"id": int(o.seq), "k": type, "street": street, "sid": stalls[rng.randi() % stalls.size()], "sp": int(vr.get("sp", 0)), "var": str(vr.get("id", type)),
		"n": vr.get("n", [type, type]), "t": 0.0, "st": "open", "who": null, "at": 0.0, "tried": []}
	o.ev.append(e)
	MK.evq.append({"k": "ev_new", "ev": e})
	return e
static func _team(street: String) -> Array:   # 可以處理呢條街事件嘅巡邏員：本街＋相鄰街嘅隊長（M2）
	var o = []
	for g in _list("pat", street): o.append({"gid": g, "slow": 1.0})
	var ids = MK.ids(); var i = ids.find(street)
	for j in [i - 1, i + 1]:
		if j < 0 or j >= ids.size(): continue
		for g in _list("pat", ids[j]):
			if int(_fun("patrol_reach", [J.str(g)], 0)) >= 1: o.append({"gid": g, "slow": float(_fun("patrol_speed", [J.str(g)], 0.7))})
	return o
static func _busy(gid) -> bool:
	for e in st().ev: if str(e.st) == "chase" and J.seq(e.who, gid): return true
	return false
static func _dispatch(street: String) -> void:
	var team = _team(street)
	if team.is_empty(): return
	for e in st().ev:
		if str(e.street) != street or str(e.st) != "open": continue
		for m in team:
			var key = J.str(m.gid)
			if (e.tried as Array).has(key) or _busy(m.gid): continue
			if not J.t(_fun("patrol_ok", [key], true)): continue   # M2：趴低嘅巡邏員當冇
			e.st = "chase"; e.who = m.gid; e.at = cf("patrol", "handle_s", 4.0) / maxf(0.1, float(m.slow)); (e.tried as Array).append(key)
			MK.evq.append({"k": "ev_chase", "id": e.id, "who": m.gid})
			break
static func _done(sim, e: Dictionary, by: String) -> void:   # 處理成功
	var o = st(); o.ev.erase(e)
	var m = MK.st()
	m["patrol_live"] = 1
	if by == "patrol":
		m["patrol_done"] = int(J.num(m.get("patrol_done", 0))) + 1
		_fun("patrol_handled", [J.str(e.who), maxi(1, patrol_n(str(e.street)))], {})
	var rn = int(cf("patrol", "renown_tap", 2)) if by == "tap" else int(cf("patrol", "renown", 1))
	var f = J.G.get("mk_renown_add_fn")
	if f is Callable and (f as Callable).is_valid(): f.call(rn, "patrol")
	else: m["renown_pts"] = J.num(m.get("renown_pts", 0)) + rn
	o["handled"] = int(o.get("handled", 0)) + 1
	MK.evq.append({"k": "ev_done", "ev": e, "by": by, "renown": rn, "praise": int(o.handled) % int(cf("patrol", "praise_n", 10)) == 0})
static func handle_event(sim, id: int) -> bool:   # 玩家親自撳事件：即刻處理、名聲 +2
	if not on(): return false
	for e in st().ev:
		if int(e.id) == id: _done(sim, e, "tap"); return true
	return false
static func _lost(sim, e: Dictionary) -> void:   # 冇人理：結算損失（有 15% 上限；到頂只演出）
	var o = st(); o.ev.erase(e)
	var street = str(e.street); var room = loss_room(street); var loss = 0.0; var info = {}
	match str(e.k):
		"steal_cash":
			var want = minf(cf("events", "cash_pct", 0.15) * till(street), rate60(street))
			loss = minf(want, room)
			if loss > 0.0: o.till[street] = maxf(0.0, till(street) - loss)
		"steal_goods":
			var sid = str(e.sid); var gid = good_of(sid); var have = sim.counter_n(gid)
			var g2 = sub_of(sid)
			if g2 != "" and sim.counter_n(g2) > have: gid = g2; have = sim.counter_n(g2)
			if have >= int(cf("events", "goods_min", 5)):
				var each = sub_val(sim, gid) if host_of(gid) != "" else MD.val(sid, sim.lv(sid), sim.ci())
				var n = mini(int(ceil(have * cf("events", "goods_pct", 0.1))), int(cf("events", "goods_cap", 20)))
				if each > 0.0: n = mini(n, int(floor(room / each)))
				if n > 0:
					sim.st().counter[gid] = float(have - n); loss = float(n) * each; info = {"gid": gid, "n": n}
		"cut_queue":
			var left = 0
			for c in sim.custs.duplicate():
				if left >= int(cf("events", "cut_n", 2)): break
				if str(c.st) != "queue": continue
				var v = _cust_expect(sim, c)
				if loss + v > room: break
				c.st = "out"; loss += v; left += 1
				sim.ev.append({"k": "leave", "pos": c.pos + Vector2(0, -60), "cid": c.cid})
			info = {"n": left}
		"brawl":
			var hit = []; var stop = cf("events", "brawl_s", 15.0)
			for sid in _near(sim, str(e.sid)):
				if float(o.brawl.get(sid + ":im", 0.0)) > clk(): continue
				var v = _stall_rate(sim, sid) * stop
				if loss + v > room: continue
				o.brawl[sid] = clk() + stop; o.brawl[sid + ":im"] = clk() + cf("events", "brawl_immune_s", 60.0)
				loss += v; hit.append(sid)
			info = {"sids": hit}
	if loss > 0.0: _add_loss(street, loss)
	o["lost"] = int(o.get("lost", 0)) + 1
	MK.evq.append({"k": "ev_lost", "ev": e, "loss": loss, "capped": loss <= 0.0, "info": info})
static func _near(sim, sid: String) -> Array:   # 事發攤＋隔籬一個已開攤
	var L = open_stalls(sim.ci(), MK.street_of(sim.ci(), sid))
	var i = L.find(sid)
	if i < 0: return [sid]
	var o = [sid]
	if L.size() > 1: o.append(L[(i + 1) % L.size()])
	return o
static func _stall_rate(sim, sid: String) -> float:   # 呢個攤每秒大約賺幾多
	var n = _nworkers(sid); if n <= 0: return 0.0
	return staff_mul(n) * MK.ot_mul(sid) * float(MD.out(sid, sim.lv(sid))) * MD.val(sid, sim.lv(sid), sim.ci()) / maxf(0.1, MD.tm(sid, sim.lv(sid)))
static func _cust_expect(sim, c: Dictionary) -> float:
	var a = 0.0
	for g in c.wants:
		var sid = sim.sid_of(str(g))
		if sid != "": a += float(c.wants[g]) * MD.val(sid, sim.lv(sid), sim.ci())
		elif host_of(str(g)) != "": a += float(c.wants[g]) * sub_val(sim, str(g))
	return a
static func _tick_events(sim, dt: float) -> void:
	var o = st(); var ci = sim.ci()
	var grace = cf("events", "grace_s", 180.0)
	if not J.t(o.get("tut")) and clk() >= grace and J.t(cf("events", "tutorial", 1.0)):   # 開張第 3 分鐘：固定第一件插隊（教學）
		var s0 = MK.cur() if MK.is_open(MK.cur()) else "food"
		var e0 = spawn_event(sim, s0, "cut_queue", 0)
		if not e0.is_empty(): o["tut"] = 1; e0["tut"] = 1; MK.evq.append({"k": "ev_tut", "ev": e0})
	if clk() >= grace:
		for street in MK.ids():
			if not MK.is_open(street) or open_stalls(ci, street).is_empty(): continue
			if not o.evt.has(street): o.evt[street] = next_gap(ci, street); continue
			o.evt[street] = float(o.evt[street]) - dt
			if float(o.evt[street]) <= 0.0:
				o.evt[street] = next_gap(ci, street)
				spawn_event(sim, street)
	for street in MK.ids(): _dispatch(street)
	var dl = cf("events", "deadline_s", 20.0)
	for e in o.ev.duplicate():
		e.t = float(e.t) + dt
		if str(e.st) == "chase":
			e.at = float(e.at) - dt
			if float(e.at) <= 0.0:
				var p = cf("patrol", "catch_p_special", 0.3) if int(e.sp) == 1 else cf("patrol", "catch_p", 0.45)
				if rng.randf() < p: _done(sim, e, "patrol"); continue
				e.st = "open"; MK.evq.append({"k": "ev_miss", "id": e.id, "who": e.who}); e.who = null
		if str(e.st) == "open" and float(e.t) >= dl: _lost(sim, e)

# ================= 每格 =================
static func tick(sim, dt: float) -> void:   # mv_sim.step 叫（離線唔叫 → 離線冇事件、冇損失）
	if not on() or dt <= 0.0: return
	reg()
	var o = st()
	o.clk = float(o.clk) + dt
	_fit_staff(sim); _validate(sim)
	_tick_swap(dt)
	_tick_counter(sim, dt)
	_tick_events(sim, dt)
static func summary() -> Dictionary:   # 模擬／KPI 用
	var o = st()
	return {"clk": clk(), "income": float(o.get("inc_all", 0.0)), "loss": float(o.get("loss_all", 0.0)), "handled": int(o.get("handled", 0)), "lost": int(o.get("lost", 0)), "village_cost": village_cost()}
