# 過勞鬼市集（市集程序組 M2）：過勞營業補完＋爽點。冇 class_name、冇 autoload（熱更新規矩）。
# 用法：const FUN = preload("res://game/market/mk_fun.gd")；數值全部喺 data/market_fun.json。
# 依賴：M1 嘅 mk_data.gd（街道、過勞值 S.mk.ot）。M2 唔改 M1 嘅結構，只係喺上面加：
#   一、過勞營業補完：加班售價 ×1.2、正常營業都慢慢累（base_rate）、70 以上冒汗慢 10%、趴低 60 秒、
#       餵 1 個包子即起（過勞值回 40）、第 6 章打卡鐘（整攤下班清零，冷卻 10 分鐘）、
#       升職老員工（趴低 5 次或加班 30 分鐘：過勞升得慢 30%、產量 ×1.2；跨章帶到下一張圖同一條街）、
#       在職人數越多加班過勞升得越慢（每多 1 人 −10%，最多 −40%）。
#       櫃台（每條街一個，"_ctr:<街>"）：冇獨立加班掣，該街一半以上攤加班＝繁忙 +0.8/秒、子時高峰 +1.0/秒；
#         每名櫃台員結帳 +40%、3 人連單判定放寬到 14 秒；趴低 60 秒＝當冇櫃台員；可餵包子；升「老收銀」跨章保留。
#       巡邏員（"_pat:<鬼id>"）：每處理一件 +15，滿 100 趴低 60 秒；處理 50 件升「巡邏隊長」（兼顧相鄰一條街），跨章保留。
#       離線一律唔加班、唔趴。
#   二、爽點：里程碑（外觀段數、多店員位、演出）、同街組合、連單、子時高峰＋限時大客、陽間潮流榜、熟客、美食評論家、章事件框架。
#   三、名聲：見 mk_renown.gd。
# 畫面事件：FUN.evq（{"k": ...}），mv_scene 每格 pop_events() 攞嚟畫；爽感包（ui/juice.gd）有就順手叫，冇就照舊。
extends RefCounted

const MK = preload("res://game/market/mk_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
const RN = preload("res://game/market/mk_renown.gd")
const PATH := "res://data/market_fun.json"
static var _D = null
static var evq: Array = []
static var handlers := {}      # 章事件：id → Callable(sim, ev_def)（M3 填）
static var now_s := -1.0       # 測試：覆寫「現實時間」秒（潮流榜日期）

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {}
	for k in ["ot", "mile", "combo", "rush", "trend", "regular", "critic", "combos", "events", "renown"]:
		if not (_D.get(k) is Dictionary): _D[k] = {}
	_apply_core()
static func _apply_core() -> void:   # 設計第 3.1 節數值寫入 M1 嘅 overtime（唔改 M1 檔案；M1 嘅結構照用）
	var core = _D.ot.get("core", {})
	if core is Dictionary: for k in core: MK.OT()[k] = core[k]
	MK.OT()["_m2"] = 1
static func ensure() -> void:
	if _D == null: reload()
	elif not MK.OT().has("_m2"): _apply_core()   # M1 重新載入過 market.json：再寫一次設計數值
static func cf(sec: String, k: String, d: float) -> float: return float(D()[sec].get(k, d))
static func T(a) -> String: return MK.T(a)
static func on() -> bool: return MK.active()
static func st() -> Dictionary:
	var s = MK.S()
	if s == null: return {}
	if not (s.get("mkf") is Dictionary): s["mkf"] = {"v": 1}
	var f: Dictionary = s.mkf
	for k in ["mile", "vets", "rush", "trend", "regs", "critic", "evt", "stars", "punch"]:
		if not (f.get(k) is Dictionary): f[k] = {}
	if not f.has("chain"): f["chain"] = 0
	return f
static func _ev(e: Dictionary) -> void:
	evq.append(e)
	if evq.size() > 200: evq = evq.slice(100)
static func pop_events() -> Array:
	var e = evq; evq = []
	return e
static func _juice(fn: String, args := []) -> void:   # 爽感包有就叫
	if not ResourceLoader.exists("res://ui/juice.gd"): return
	var J2 = load("res://ui/juice.gd")
	if J2 != null and J2.has_method(fn): J2.callv(fn, args)

# ================= 一、過勞營業補完 =================
static func ch() -> int:
	var s = MK.S()
	return int(J.num(s.mv.get("ci", 0))) if s != null and s.get("mv") is Dictionary else 0
static func ot_price(sid: String) -> float: return cf("ot", "price_mul", 1.2) if MK.ot_on(sid) else 1.0
static func warn(sid: String) -> bool: return on() and MK.fat(sid) >= cf("ot", "warn", 70.0) and not MK.is_down(sid)
static func vet(sid: String) -> bool: return on() and MK.rank(sid) > 0   # 老員工＝M1 嘅 rank ≥1（產量加成由 M1 rank_bonus 計）
static func out_mul(sid: String) -> float:   # 疊喺 MK.mul 上：冒汗慢 10%
	if not on(): return 1.0
	return cf("ot", "warn_mul", 0.9) if warn(sid) else 1.0
static func feed(sid: String) -> String:   # 餵 1 個包子：即刻起身，過勞值回 40（取代 M1 預設）
	if not MK.is_down(sid): return "not_down"
	var n = int(cf("ot", "feed_cost", 1))
	if not M.take({"m_bao": float(n)}): return "no_bao"
	var o = MK.ot(sid); o.down = 0.0; o.fat = cf("ot", "feed_fat", 40.0)
	_ev({"k": "feed", "sid": sid}); _ev({"k": "up", "sid": sid})
	return "ok"
static func punch_ok() -> bool: return ch() >= int(cf("ot", "punch_ch", 5))
static func punch_left(sid: String) -> float:
	var t = float(st().punch.get(sid, 0.0))
	return maxf(0.0, t - _clock())
static func punch(sid: String) -> String:   # 打卡鐘：整攤下班，過勞值清零（第 6 章起，冷卻 10 分鐘）
	if not punch_ok(): return "locked"
	if punch_left(sid) > 0.0: return "cd"
	var o = MK.ot(sid); o.on = 0; o.down = 0.0; o.fat = 0.0
	st().punch[sid] = _clock() + cf("ot", "punch_cd_s", 600.0)
	_ev({"k": "punch", "sid": sid})
	return "ok"
# 每格（喺 MK.tick 之後叫）：補 base_rate、老員工減累、趴低計次升職、趴低時間改 60 秒
static func ot_tick(sids: Array, dt: float, working: Callable, sim = null) -> void:
	if not on() or dt <= 0.0: return
	for sid in sids:
		var o = MK.ot(sid)
		if o.is_empty(): continue
		var down = float(o.get("down", 0.0)) > 0.0
		if down and not J.t(o.get("_dn")):   # 啱啱趴低：記次數、趴低時間定 60 秒
			o["_dn"] = 1; o.down = maxf(float(o.down), cf("ot", "down_s", 60.0))
			o["downs"] = int(J.num(o.get("downs", 0))) + 1
			_ev({"k": "down", "sid": sid, "gag": randi() % 4})
			_juice("vib", [60])
		elif not down: o.erase("_dn")
		if down: continue
		var busy = true if not working.is_valid() else J.t(working.call(sid))
		var fr = 1.0
		if vet(sid): fr = cf("ot", "rank_fat_mul", 0.7)
		if sim != null: fr *= staff_fat_mul(sim.nworkers(sid))   # 多人分擔
		if J.t(o.get("on")) and busy:
			if fr < 1.0: o.fat = maxf(0.0, float(o.fat) - MK.otf("fat_rate", 1.6) * (1.0 - fr) * dt)   # 老員工：抵消部分升幅
		elif busy:
			o.fat = minf(MK.otf("fat_max", 100.0) - 0.01, float(o.get("fat", 0.0)) + cf("ot", "base_rate", 0.15) * fr * dt)
		# 升職老員工：加班夠鐘由 M1 rank_s 升；趴低 5 次都升
		if int(o.get("rank", 0)) == 0 and int(J.num(o.get("downs", 0))) >= int(cf("ot", "rank_downs", 5)):
			o.rank = 1; MK.evq.append({"k": "rank", "sid": sid, "rank": 1})
		if int(o.get("rank", 0)) > int(J.num(o.get("_rk", 0))):
			o["_rk"] = int(o.rank)
			if int(o.rank) == 1: _vet_add(sid)
			_ev({"k": "vet", "sid": sid})
# 老員工跨章：記喺 S.mkf.vets[街] 個數；新地圖同一條街嘅台按次序派返
static func _vet_add(sid: String) -> void:
	var s = MK.street_of(ch(), sid)
	var v = st().vets
	v[s] = int(J.num(v.get(s, 0))) + 1
static func carry_vets(ci: int) -> void:   # 拔營後新地圖叫一次
	var v = st().vets
	for s in v:
		if str(s).begins_with("ctr:"):   # 老收銀
			var oc = MK.ot(ctr_key(str(s).substr(4)))
			if not oc.is_empty(): oc.rank = 1
			continue
		var n = int(J.num(v[s]))
		for sid in MK.sids_on(ci, str(s)):
			if n <= 0: break
			var o = MK.ot(sid)
			if not o.is_empty() and int(o.get("rank", 0)) == 0: o.rank = 1; o["_rk"] = 1; n -= 1
# 在職人數越多，加班時過勞升得越慢（每多 1 人 −10%，最多 −40%）
static func staff_fat_mul(n: int) -> float: return 1.0 - minf(cf("ot", "staff_cap", 0.4), cf("ot", "staff_step", 0.1) * maxf(0.0, float(n - 1)))
# ---- 櫃台（每條街一個；冇獨立加班掣，跟整街加班連動）----
static func ctr_key(street: String) -> String: return "_ctr:" + street
static func counter_n(street: String) -> int:   # 櫃台員人數（M1 嘅櫃台資料：J.G.mk_counter_n_fn(street)；未接時當 1 人）
	var f = J.G.get("mk_counter_n_fn")
	if f is Callable and (f as Callable).is_valid(): return clampi(int(J.num(f.call(street))), 0, ctr_max())
	f = J.G.get("mk_counter_staff_fn")
	if f is Callable and (f as Callable).is_valid(): return 1 if J.t(f.call()) else 0
	return 1
static func ctr_max() -> int: return int(cf("ot", "ctr_max", 3))   # 每條街櫃台員上限
static func pat_max() -> int: return int(cf("ot", "pat_max", 4))   # 每條街巡邏位上限（老闆 11-28：0–4 隻）
static func counter_staffed(street := "") -> bool: return counter_n(street if street != "" else MK.cur()) > 0
static func counter_down(street: String) -> bool: return on() and MK.is_down(ctr_key(street))
static func counter_busy(sim, street: String) -> String:   # "peak"／"busy"／""
	if rush_phase() == "peak": return "peak"
	var n = 0; var on_n = 0
	for sid in MK.sids_on(sim.ci(), street):
		if not sim.unlocked(sid): continue
		n += 1
		if MK.ot_on(sid): on_n += 1
	return "busy" if n > 0 and on_n * 2 >= n else ""
static func serve_mul(street := "") -> float:   # 客人攞貨／結帳間隔 ÷ 呢個數（每名櫃台員 +40%；趴低／冇人＝1）
	if not on(): return 1.0
	if street == "": street = MK.cur()
	var n = counter_n(street)
	if n <= 0 or counter_down(street): return 1.0
	var m = 1.0 + cf("ot", "ctr_per", 0.4) * n
	if vet(ctr_key(street)): m *= 1.0 + MK.otf("rank_bonus", 0.2)
	if warn(ctr_key(street)): m *= cf("ot", "warn_mul", 0.9)
	return m
static func chain_win(street := "") -> float:   # 3 名櫃台員：連單判定 10 → 14 秒
	if street == "": street = MK.cur()
	return cf("ot", "ctr_win3", 14.0) if on() and counter_n(street) >= 3 and not counter_down(street) else cf("combo", "win_s", 10.0)
static func _counter_tick(sim, dt: float) -> void:
	for street in MK.ids():
		if not MK.is_open(street): continue
		var k = ctr_key(street); var o = MK.ot(k)
		if o.is_empty(): continue
		var n = counter_n(street)
		if float(o.get("down", 0.0)) > 0.0:
			o.down = maxf(0.0, float(o.down) - dt)
			if o.down <= 0.0: o.fat = MK.otf("reset_fat", 40.0); MK.evq.append({"k": "up", "sid": k})
			continue
		var b = counter_busy(sim, street) if n > 0 else ""
		var fr = staff_fat_mul(n) * (cf("ot", "rank_fat_mul", 0.7) if vet(k) else 1.0)
		if b != "":
			o.fat = minf(MK.otf("fat_max", 100.0), float(o.get("fat", 0.0)) + (cf("ot", "ctr_peak", 1.0) if b == "peak" else cf("ot", "ctr_busy", 0.8)) * fr * dt)
			o.xp = float(o.get("xp", 0.0)) + dt
			if float(o.fat) >= MK.otf("fat_max", 100.0):
				o.down = MK.otf("down_s", 60.0); o["downs"] = int(J.num(o.get("downs", 0))) + 1
				_ev({"k": "down", "sid": k, "gag": randi() % 4})
		else:
			o.fat = maxf(0.0, float(o.get("fat", 0.0)) - MK.otf("rec_rate", 2.0) * dt)
		var ranks: Array = MK.OT().get("rank_s", [1800])
		if int(o.get("rank", 0)) == 0 and (float(o.get("xp", 0.0)) >= float(ranks[0]) or int(J.num(o.get("downs", 0))) >= int(cf("ot", "rank_downs", 5))):
			o.rank = 1; MK.evq.append({"k": "rank", "sid": k, "rank": 1}); _ev({"k": "cashier", "sid": k})
			st().vets["ctr:" + street] = 1
# ---- 巡邏員（每處理一件 +15；滿 100 趴低 60 秒；處理 50 件升巡邏隊長，可兼顧相鄰一條街）----
static func pat_key(who: String) -> String: return "_pat:" + who
static func patrol_ok(who: String) -> bool: return not on() or not MK.is_down(pat_key(who))   # M1 派遣前問：趴低嗰陣當冇巡邏
static func patrol_captain(who: String) -> bool: return on() and int(MK.ot(pat_key(who)).get("rank", 0)) > 0
static func patrol_reach(who: String) -> int: return 1 if patrol_captain(who) else 0   # 可兼顧相鄰幾條街
static func patrol_speed(who: String) -> float: return cf("ot", "cap_slow", 0.7) if patrol_captain(who) else 1.0   # 隊長兼顧相鄰街：處理速度 −30%（M1 按需要用）
static func patrol_handled(who: String, team_n := 1) -> Dictionary:   # M1 結算「巡邏員處理咗一件」時叫；回 {down, captain}
	if not on(): return {}
	var k = pat_key(who); var o = MK.ot(k)
	o["done"] = int(J.num(o.get("done", 0))) + 1
	o.fat = minf(MK.otf("fat_max", 100.0), float(o.get("fat", 0.0)) + cf("ot", "pat_add", 15.0) * staff_fat_mul(team_n))
	var r = {"down": false, "captain": false}
	if float(o.fat) >= MK.otf("fat_max", 100.0):
		o.down = MK.otf("down_s", 60.0); r.down = true
		o["downs"] = int(J.num(o.get("downs", 0))) + 1
		_ev({"k": "down", "sid": k, "gag": randi() % 4})
	if int(o.get("rank", 0)) == 0 and int(o.done) >= int(cf("ot", "cap_n", 50)):
		o.rank = 1; r.captain = true
		_ev({"k": "captain", "sid": k})
		var v = st().get("caps", [])
		if not (v is Array): v = []
		if not v.has(who): v.append(who)
		st()["caps"] = v
	return r
static func _patrol_tick(dt: float) -> void:   # 巡邏員：趴低倒數、閒時回落
	var m = MK.st().get("ot", {})
	for k in m.keys():
		if not str(k).begins_with("_pat:"): continue
		var o = m[k]
		if float(o.get("down", 0.0)) > 0.0:
			o.down = maxf(0.0, float(o.down) - dt)
			if o.down <= 0.0: o.fat = MK.otf("reset_fat", 40.0); MK.evq.append({"k": "up", "sid": str(k)})
		else: o.fat = maxf(0.0, float(o.get("fat", 0.0)) - MK.otf("rec_rate", 2.0) * 0.5 * dt)
static func carry_captains() -> void:   # 拔營後：巡邏隊長跨章保留（同一隻鬼 id）
	for who in st().get("caps", []):
		var o = MK.ot(pat_key(str(who)))
		if not o.is_empty(): o.rank = 1

# ================= 二、爽點 =================
static func _clock() -> float: return float(J.num(st().get("clk", 0.0)))   # 市集遊戲時間（秒，累計）
# ---- 里程碑：外觀段數、多店員位 ----
static func look_stage(sid: String, lv: float) -> int:
	var n = 0
	for x in D().mile.get("look_lv", [25, 100, 200]): if lv >= float(x): n += 1
	return n
static func extra_slots(sid: String, lv: float) -> int:   # 製作店員位＝1＋呢個數；權威表喺 M1（mk_ops.staff_slots），未合併時用自己嘅 slot_lv
	if not on(): return 0
	var MKO = _mko()
	if MKO != null: return int(MKO.extra_slots(sid, lv))
	var n = 0
	for x in D().mile.get("slot_lv", [10, 25, 100, 200]): if lv >= float(x): n += 1
	return n
static func _miles(sim) -> void:
	var seen = st().mile
	for sid in MD.stations(sim.ci()):
		if not sim.unlocked(sid): continue
		var n = MD.nm(sid, sim.lv(sid))
		var k = "%d:%s" % [sim.ci(), sid]
		if not seen.has(k): seen[k] = n; continue
		if n > int(seen[k]):
			seen[k] = n
			var lv = sim.lv(sid)
			_ev({"k": "mile", "sid": sid, "lv": int(lv), "look": look_stage(sid, lv), "slots": extra_slots(sid, lv)})
			_juice("celebrate_banner", [true]); _juice("vib", [40])
# ---- 同街組合 ----
static func combos_of(ci: int) -> Array:
	var a = D().combos.get(str(ci), [])
	return a if a is Array else []
static func combo_on(sim, cb: Dictionary) -> bool:
	for sid in cb.get("need", []):
		if not MD.stations(sim.ci()).has(str(sid)) or not sim.unlocked(str(sid)) or sim.lv(str(sid)) < float(cb.get("lv", 25)): return false
	return true
static func street_bonus(sim, street: String, kind: String) -> float:
	var v = 0.0
	for cb in combos_of(sim.ci()):
		if str(cb.get("street", "")) == street and str(cb.get("kind", "")) == kind and combo_on(sim, cb): v += float(cb.get("v", 0.0))
	return v
static func _combos_tick(sim) -> void:
	var seen = st().get("cbseen", {})
	if not (seen is Dictionary): seen = {}
	for cb in combos_of(sim.ci()):
		var id = str(cb.get("id", ""))
		if not seen.has(id) and combo_on(sim, cb):
			seen[id] = 1
			_ev({"k": "street_combo", "id": id, "street": str(cb.get("street", "")), "n": T(cb.get("n", id))})
			_juice("celebrate_banner", [true])
	st()["cbseen"] = seen
# ---- 每件貨售價倍數（客人計錢時逐件乘）----
static func item_mul(sim, sid: String) -> float:
	if not on(): return 1.0
	var m = ot_price(sid)
	m *= 1.0 + street_bonus(sim, MK.street_of(sim.ci(), sid), "price")
	if is_trend(sim, sid): m *= cf("trend", "mul", 1.5)
	if int(J.num(st().stars.get(sid, 0))) >= 3: m *= 1.0 + cf("critic", "star3_price", 0.1)
	return m
static func _mko():
	return load("res://game/market/mk_ops.gd") if ResourceLoader.exists("res://game/market/mk_ops.gd") else null
static func sub_bonus(sim, c: Dictionary) -> float:   # 副貨（M1 雙貨）：按寄賣攤嘅倍數補差（cust_value 用）
	if not on(): return 0.0
	var MKO = _mko()
	if MKO == null: return 0.0
	var a = 0.0
	for g in c.got:
		var host = str(MKO.host_of(str(g)))
		if host != "": a += float(c.got[g]) * float(MKO.sub_val(sim, str(g))) * (item_mul(sim, host) - 1.0)
	return a
# ---- 連單 ----
static func _mark_first(sim, dt: float) -> void:
	for c in sim.custs:
		if c.st == "out": continue
		if c.got.size() and not c.has("t1"): c["t1"] = _clock()
static func pay_mul(sim, c: Dictionary) -> float:   # 客人俾錢嗰下（_pay）乘
	if not on(): return 1.0
	var f = st(); var m = 1.0
	var full = true
	for g in c.wants: if int(c.got.get(g, 0)) < int(c.wants[g]): full = false
	var multi = c.wants.size() >= 2 or _cnt(c.wants) >= 2
	var fast = c.has("t1") and _clock() - float(c.t1) <= chain_win()
	if J.t(c.get("bigv")):   # 限時大客
		if full and _clock() <= float(c.get("tend", 0.0)):
			m *= cf("rush", "vip_mul", 3.0); RN.add(cf("rush", "vip_renown", 20.0), "vip")
			_ev({"k": "vip_ok", "name": str(c.get("vipn", ""))})
		return m
	if full and multi and fast:
		f.chain = int(f.chain) + 1
		var bonus = minf(cf("combo", "cap", 2.0), cf("combo", "mul", 1.5) + cf("combo", "step_add", 0.1) * floor(float(f.chain) / cf("combo", "step_n", 5.0)))
		m *= bonus
		_ev({"k": "chain", "n": int(f.chain), "mul": bonus, "pos": c.pos + Vector2(0, -80)})
		_juice("chime", ["coin"])
	elif multi:
		if int(f.chain) > 0: _ev({"k": "chain_break", "n": int(f.chain)})
		f.chain = 0
	return m
static func _cnt(w: Dictionary) -> int:
	var n = 0
	for g in w: n += int(w[g])
	return n
static func on_paid(sim, c: Dictionary, amt: float) -> void:   # 名聲、熟客
	if not on(): return
	var n = 0; var lux = 0
	for g in c.got:
		n += int(c.got[g])
		var sid = sim.sid_of(str(g))
		if sid != "" and MK.street_of(sim.ci(), sid) == "lux": lux += int(c.got[g])
	RN.add(cf("renown", "per_item", 1.0) * (n - lux) + RN.cf("per_lux", 10.0) * lux, "sale")
	if c.has("reg"): _reg_visit(int(c.reg))
# ---- 客流倍數（spawn_t ÷ 呢個）----
static func flow_mul() -> float:
	if not on(): return 1.0
	var m = 1.0
	match rush_phase():
		"peak": m *= cf("rush", "peak_flow", 3.0)
		"rest": m *= cf("rush", "rest_flow", 0.5)
	var bad = float(st().critic.get("bad_until", 0.0))
	if _clock() < bad: m *= cf("critic", "star1_flow", 0.8)
	return m
# ---- 子時高峰 ----
static func rush_phase() -> String: return str(st().rush.get("ph", "idle"))
static func rush_left() -> float: return maxf(0.0, float(st().rush.get("end", 0.0)) - _clock())
static func _rush_tick(sim) -> void:
	var r = st().rush
	if not r.has("next"): r["next"] = _clock() + cf("rush", "first_s", 300.0); r["ph"] = "idle"; r["n"] = 0
	var t = _clock()
	match str(r.ph):
		"idle":
			if t >= float(r.next):
				r.ph = "warn"; r["end"] = t + cf("rush", "warn_s", 30.0)
				_ev({"k": "rush_warn", "s": cf("rush", "warn_s", 30.0)})
		"warn":
			if t >= float(r.end):
				var first = int(r.n) == 0
				r.ph = "peak"; r.end = t + (cf("rush", "first_peak_s", 60.0) if first else cf("rush", "peak_s", 90.0))
				_ev({"k": "rush_peak", "first": first})
				if not first: _spawn_vip(sim)
		"peak":
			if t >= float(r.end):
				r.ph = "rest"; r.end = t + cf("rush", "rest_s", 60.0)
				_ev({"k": "rush_rest"})
		"rest":
			for sid in MD.stations(sim.ci()) + MK.ids().map(func(x): return ctr_key(x)):   # 喘息：飲涼茶，過勞值加快回落
				var o = MK.ot(sid)
				if not o.is_empty() and float(o.get("down", 0.0)) <= 0.0: o.fat = maxf(0.0, float(o.get("fat", 0.0)) - cf("rush", "rest_fat", 4.0) * float(r.get("_dt", 0.0)))
			if t >= float(r.end):
				r.ph = "idle"; r.n = int(r.n) + 1; r.next = t + cf("rush", "every_s", 900.0)
				_ev({"k": "rush_end"})
static func _spawn_vip(sim) -> void:
	var av = sim.avail_goods()
	if av.is_empty(): return
	var vips: Array = D().rush.get("vips", [])
	var vd = vips[randi() % vips.size()] if vips.size() else {"id": "rich", "n": ["富豪鬼", "富豪鬼"]}
	var rng_n: Array = D().rush.get("vip_n", [10, 30])
	var total = randi_range(int(rng_n[0]), int(rng_n[1]))
	var goods = av.duplicate(); goods.shuffle()
	goods = goods.slice(0, mini(3, goods.size()))
	var wants = {}
	for i in goods.size(): wants[goods[i]] = maxi(1, total / goods.size() + (total % goods.size() if i == 0 else 0))
	var c = {"cid": "vip_" + str(vd.id), "k": "youhun", "wants": wants, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": sim.QLEN, "pos": MD.poly_at(sim.QP, sim.QLEN), "ph": randf() * 10.0, "flip": true, "lines": [], "vip": true,
		"bigv": true, "vipn": T(vd.n), "tend": _clock() + cf("rush", "vip_s", 90.0)}
	sim.custs.push_front(c)
	_ev({"k": "vip_in", "name": T(vd.n), "n": total, "s": cf("rush", "vip_s", 90.0)})
static func _vip_tick(sim) -> void:   # 超時：搖頭走人，冇罰（已攞到嘅照正價俾）
	for c in sim.custs:
		if J.t(c.get("bigv")) and c.st != "out" and _clock() > float(c.get("tend", 0.0)):
			c["bigv"] = false
			_ev({"k": "vip_fail", "name": str(c.get("vipn", "")), "pos": c.pos + Vector2(0, -80)})
			if sim._got_n(c) > 0: sim._pay(c)
			else: c.st = "out"
# ---- 陽間潮流榜 ----
static func _day() -> int:
	var u = now_s if now_s > 0.0 else Time.get_unix_time_from_system()
	var bias = Time.get_time_zone_from_system().get("bias", 0) * 60.0
	return int(floor((u + bias) / 86400.0))
static func add_trend_source(kind: String, sid: String) -> void:   # 回陽間供品／奢侈品新貨：下次刷新優先上榜
	var tr = st().trend
	if not (tr.get("pin") is Array): tr["pin"] = []
	if not (tr.pin as Array).has(sid): tr.pin.append(sid)
	_ev({"k": "trend_src", "kind": kind, "sid": sid})
static func trend_list(sim) -> Array:
	var tr = st().trend
	var key = "%d:%d" % [_day(), sim.ci()]
	if str(tr.get("key", "")) != key: _trend_roll(sim, key)
	return tr.get("list", [])
static func _trend_roll(sim, key: String) -> void:
	var tr = st().trend
	var pool = []
	for sid in MD.stations(sim.ci()): if sim.unlocked(sid) and MK.is_open(MK.street_of(sim.ci(), sid)): pool.append(sid)
	var out = []
	for sid in tr.get("pin", []): if pool.has(str(sid)) and out.size() < int(cf("trend", "n", 3)): out.append(str(sid))
	var fest = _fest()
	if fest != "":   # 化寶爐節日：該類街嘅貨優先
		for street in D().trend.get("fest", {}).get(fest, []):
			for sid in pool: if out.size() < int(cf("trend", "n", 3)) and not out.has(sid) and MK.street_of(sim.ci(), sid) == str(street): out.append(sid)
	var r = RandomNumberGenerator.new(); r.seed = hash(key)
	var rest = pool.filter(func(x): return not out.has(x))
	while out.size() < int(cf("trend", "n", 3)) and rest.size():
		var i = r.randi() % rest.size(); out.append(rest[i]); rest.remove_at(i)
	tr["key"] = key; tr["list"] = out; tr["fest"] = fest
	tr["pin"] = (tr.get("pin", []) as Array).filter(func(x): return not out.has(x))
	_ev({"k": "trend_new", "list": out, "fest": fest})
static func _fest() -> String:
	if not ResourceLoader.exists("res://game/joss/joss.gd"): return ""
	var JS = load("res://game/joss/joss.gd")
	return str(JS.fest_of(JS._date()))
static func is_trend(sim, sid: String) -> bool: return trend_list(sim).has(sid)
# ---- 熟客（酒館普通鬼生成器）----
static func regs(ci: int) -> Array:
	var R = st().regs
	var k = str(ci)
	if not (R.get(k) is Array):
		var a = []
		var TG = load("res://game/tavern/tv_gen.gd")
		for i in int(cf("regular", "per_ch", 4)):
			var sd = 7000 + ci * 37 + i * 101
			var g = TG.gen(sd) if TG != null else {}
			a.append({"seed": sd, "name": str(g.get("name", "熟客")), "v": 0})
		R[k] = a
	return R[k]
static func on_spawn(sim, c: Dictionary) -> void:   # spawn_cust 之後叫：有機會變熟客
	if not on() or J.t(c.get("bigv")) or randf() >= cf("regular", "p", 0.12): return
	var a = regs(sim.ci())
	if a.is_empty(): return
	var i = randi() % a.size()
	c["reg"] = i; c["regn"] = str(a[i].name) if int(a[i].v) >= int(cf("regular", "name_at", 5)) else ""
static func _reg_visit(i: int) -> void:
	var a = regs(ch())
	if i < 0 or i >= a.size(): return
	a[i].v = int(a[i].v) + 1
	var v = int(a[i].v)
	if v == int(cf("regular", "name_at", 5)): _ev({"k": "reg_name", "i": i, "name": str(a[i].name)})
	if v % int(cf("regular", "arc_every", 10)) == 0:
		RN.add(cf("regular", "arc_renown", 30.0), "reg")
		_ev({"k": "reg_arc", "i": i, "name": str(a[i].name), "n": v / int(cf("regular", "arc_every", 10)), "ch": ch()})
# ---- 美食評論家 ----
static func _critic_tick(sim) -> void:
	var cr = st().critic
	var k = str(sim.ci())
	if not (cr.get(k) is Dictionary): cr[k] = {"n": 0, "next": _clock() + cf("critic", "first_s", 900.0)}
	var c = cr[k]
	if int(c.n) >= int(cf("critic", "per_ch", 2)) or _clock() < float(c.next): return
	var cand = []
	for sid in MD.stations(sim.ci()): if sim.unlocked(sid) and MK.is_open(MK.street_of(sim.ci(), sid)): cand.append(sid)
	if cand.is_empty(): c.next = _clock() + 60.0; return
	cand.shuffle()
	var res = []
	for sid in cand.slice(0, int(cf("critic", "n_try", 3))): res.append([sid, critic_score(sim, sid)])
	var best = res[0]
	for x in res: if int(x[1]) > int(best[1]): best = x
	c.n = int(c.n) + 1
	var gap: Array = D().critic.get("gap_s", [900, 1800])
	c.next = _clock() + randf_range(float(gap[0]), float(gap[1]))
	if int(best[1]) >= 3:
		st().stars[best[0]] = 3; RN.add(cf("critic", "star3_renown", 50.0), "critic")
		_juice("celebrate_banner", [true])
	elif int(best[1]) <= 1:
		cr["bad_until"] = _clock() + cf("critic", "star1_s", 600.0)
	_ev({"k": "critic", "res": res, "best": best})
static func critic_score(sim, sid: String) -> int:   # 等級 → 1–3 星；加班中 −1（味道趕急）；趴低 −1
	var n = MD.nm(sid, sim.lv(sid))   # 里程碑數：0 → 1 星、1–2 個（Lv10 起）→ 2 星、3 個以上（Lv50 起）→ 3 星
	var th: Array = D().critic.get("star_miles", [1, 3])
	var s = 1
	for x in th: if n >= int(x): s += 1
	if MK.ot_on(sid): s -= 1
	if MK.is_down(sid): s -= 1
	return clampi(s, 1, 3)
# ---- 章事件框架 ----
static func _events_tick(sim) -> void:
	var es = D().events.get(str(sim.ci()), [])
	if not (es is Array): return
	var E = st().evt
	for e in es:
		var id = str(e.get("id", ""))
		var k = "%d:%s" % [sim.ci(), id]
		if not E.has(k): E[k] = _clock() + float(e.get("every_s", 600))
		if _clock() >= float(E[k]):
			E[k] = _clock() + float(e.get("every_s", 600))
			var h = handlers.get(id)
			if h is Callable and (h as Callable).is_valid(): h.call(sim, e)
			_ev({"k": "ch_event", "id": id})

# ================= 每格 =================
static func tick(sim, dt: float) -> void:   # sim.step 尾叫（dt 已乘遊戲速度）
	ensure()
	if not on() or dt <= 0.0: return
	var f = st(); f.clk = _clock() + dt
	f.rush["_dt"] = dt
	ot_tick(MD.stations(sim.ci()), dt, func(x): return sim.nworkers(x) > 0, sim)
	_counter_tick(sim, dt); _patrol_tick(dt)
	_mark_first(sim, dt)
	_miles(sim); _combos_tick(sim)
	_rush_tick(sim); _vip_tick(sim)
	_critic_tick(sim); _events_tick(sim)
	RN.tick()
static func _serving(sim) -> bool:
	for c in sim.custs: if c.st == "serve": return true
	return false

# ================= 畫面文字用數值（同計算同一個來源；mk_ui 只准由呢度攞） =================
static func fmt_mul(v: float) -> String:   # 1.5 → "1.5"、3.0 → "3"
	return str(int(round(v))) if is_equal_approx(v, round(v)) else ("%.1f" % v)
static func txt_peak_flow() -> String: return fmt_mul(cf("rush", "peak_flow", 3.0))
static func txt_vip_mul() -> String: return fmt_mul(cf("rush", "vip_mul", 3.0))
static func txt_trend_mul() -> String: return fmt_mul(cf("trend", "mul", 1.5))
static func txt_chain_mul(v: float) -> String: return "%.1f" % v
