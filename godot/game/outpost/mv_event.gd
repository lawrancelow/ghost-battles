# [play] 詭異事件＋委託單（全部 static；P = mv_plus.gd 實例，sim = mv_sim.gd 實例）。規則見 PLAY_PLUS.md 三之 2、3。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const JS = preload("res://game/joss/joss.gd")

# ---------------- 詭異事件 ----------------
const EV_FIRST := 75.0
const EV_MIN := 100.0
const EV_MAX := 160.0
const EV_LIFE := 30.0
const EV_NIGHT := 0.7          # 夜潮：間隔 ×0.7
const EV_W := {"self": 16, "rate_up": 10, "rate_down": 10, "fake": 14, "rain": 14, "doze": 12, "parcel": 10, "special": 14}
const SELF_TAP := 3
const RATE_UP := 1.3
const RATE_UP_S := 45.0
const RATE_EXT := 15.0
const RATE_DOWN := 0.75
const RATE_DOWN_S := 45.0
const DECIDE_S := 15.0
const HOLD_S := 20.0
const RATE_AFTER := 1.3
const RATE_AFTER_S := 30.0
const RAIN_N := 8
const RAIN_S := 10.0
const RAIN_SEC := 3.0
const RAIN_MIN := 10.0
const DOZE_S := 40.0
const FAKE_FORCE := 12.0
const FAKE_LIFE := 60.0
# ---------------- 委託單 ----------------
const ORD_FIRST := 90.0
const ORD_MIN := 180.0
const ORD_MAX := 300.0
const ORD_DAY := 0.8           # 白晝：間隔 ×0.8；夜潮唔出單
const ORD_SECS := 90.0         # 數量 ≈ 呢個台 90 秒產量
const ORD_T_MIN := 180.0
const ORD_T_MAX := 600.0
const ORD_COIN := 1.5
const ORD_GOLD := 1.5
const ORD_FAIL_INF := 3.0
const ORD_INF := 8.0
const ORD_MAT := 40.0
const FW_ := 390.0

static func ev_def(P, k: String) -> Dictionary:
	var d = P.D().EVENTS.get(k)
	return d if d is Dictionary else {}
static func ev_name(P, sim, e: Dictionary) -> String:
	if str(e.k) == "special": return P.T(P.map_d(sim.ci()).get("special", {}).get("n", ["", ""]))
	return P.T(ev_def(P, str(e.k)).get("n", ["", ""]))
static func ev_tap(P, sim, e: Dictionary) -> String:
	if str(e.k) == "special": return P.T(P.map_d(sim.ci()).get("special", {}).get("tap", ["", ""]))
	return P.T(ev_def(P, str(e.k)).get("tap", ["", ""]))

# ================= 每格 =================
static func step(P, sim, dt: float) -> void:
	var p = P.ps(sim)
	var night = P.is_night(sim)
	var e = P.live.get("ev")
	if e is Dictionary:
		e.t = float(e.t) + dt
		_step_ev(P, sim, e, dt)
		if J.t(e.get("done")) or float(e.t) >= float(e.life):
			if not J.t(e.get("done")): _default(P, sim, e)
			P.live.ev = null
	else:
		p.ev_t = J.num(p.ev_t) - dt / (EV_NIGHT if night else 1.0)
		if J.num(p.ev_t) <= 0.0:
			p.ev_t = P.rng.randf_range(EV_MIN, EV_MAX)
			start_ev(P, sim, "")
	# 委託單
	for o in p.orders.duplicate():
		o.left = J.num(o.left) - dt
		if J.num(o.left) <= 0.0: _fail(P, sim, o)
	if not night:
		p.ord_t = J.num(p.ord_t) - dt / ORD_DAY
		if J.num(p.ord_t) <= 0.0:
			p.ord_t = P.rng.randf_range(ORD_MIN, ORD_MAX)
			if p.orders.size() < ord_max(P, sim): make_order(P, sim)

static func _unl(sim) -> Array:
	var o = []
	for sid in MD.stations(sim.ci()):
		if sim.unlocked(sid) and not sim.war.blocked(sim, sid): o.append(sid)
	return o
static func _ok(P, sim, k: String) -> bool:
	match k:
		"doze":
			for w in sim.workers: if w.st == "work" and not J.t(w.get("walk")): return true
			return false
		"special": return _spec_good(P, sim) != ""
		"rate_up", "rate_down": return not (P.live.rate is Dictionary) and float(P.live.hold) <= 0.0
	return true
static func _spec_good(P, sim) -> String:
	for g in P.map_d(sim.ci()).get("special", {}).get("goods", []):
		if sim.counter_n(str(g)) > 0: return str(g)
	return ""

static func start_ev(P, sim, k: String) -> bool:
	var u = _unl(sim)
	if u.is_empty(): return false
	if k == "":
		var w = {}
		for x in EV_W: if _ok(P, sim, x): w[x] = EV_W[x]
		if w.is_empty(): return false
		var tot = 0.0
		for x in w: tot += float(w[x])
		var r = P.rng.randf() * tot
		for x in w:
			r -= float(w[x])
			if r <= 0.0: k = x; break
		if k == "": k = w.keys()[0]
	elif not _ok(P, sim, k): return false
	var e = {"k": k, "t": 0.0, "life": EV_LIFE}
	match k:
		"self":
			var sid = str(u[P.rng.randi() % u.size()]); e["sid"] = sid; e["pos"] = sim.st_pos(sid)
		"rate_up":
			P.live.rate = {"mul": RATE_UP, "left": RATE_UP_S}; e.life = RATE_UP_S
		"rate_down": e.life = DECIDE_S
		"fake": P.live.fake = true; e.life = FAKE_LIFE
		"rain":
			e.life = RAIN_S; e["v"] = maxf(RAIN_MIN, RAIN_SEC * P.earn_rate(sim))
			var cs = []
			for i in RAIN_N: cs.append({"x": P.rng.randf_range(40.0, 350.0), "y": -P.rng.randf_range(0.0, 260.0), "vy": P.rng.randf_range(45.0, 75.0), "ph": P.rng.randf() * TAU, "got": false})
			e["coins"] = cs
		"doze":
			var ws = []
			for w in sim.workers: if w.st == "work" and not J.t(w.get("walk")): ws.append(w)
			var w2 = ws[P.rng.randi() % ws.size()]; w2["doze"] = true; e["w"] = w2; e.life = DOZE_S
		"parcel": e["pos"] = sim.L.counter + Vector2(70.0, 6.0)
		"special":
			var sp = P.map_d(sim.ci()).get("special", {})
			e["g"] = _spec_good(P, sim); e["x"] = FW_ + 40.0
			e["pos"] = Vector2(clampf(sim.L.counter.x + 180.0, 220.0, 340.0), sim.L.counter.y + 70.0)
			e["n"] = int(sp.get("group", 1))
	P.live.ev = e
	sim.ev.append({"k": "p_ev", "name": ev_name(P, sim, e), "tap": ev_tap(P, sim, e), "pos": e.get("pos", sim.L.counter + Vector2(0, -120)), "kind": k})
	P.stat_add(sim, "ev_" + k)
	return true

static func _step_ev(P, sim, e: Dictionary, dt: float) -> void:
	match str(e.k):
		"fake":
			if not e.has("c") and float(e.t) >= FAKE_FORCE and J.t(P.live.fake): sim.spawn_cust()
			var c = e.get("c")
			if c is Dictionary and not (c in sim.custs): e["done"] = true
		"rain":
			for c in e.coins: c.y = float(c.y) + float(c.vy) * dt
		"doze":
			var w = e.get("w")
			if not (w is Dictionary) or not (w in sim.workers): e["done"] = true
		"special":
			e.x = maxf(float(e.pos.x), float(e.x) - 90.0 * dt)
		"rate_up":
			if not (P.live.rate is Dictionary): e["done"] = true

static func _default(P, sim, e: Dictionary) -> void:   # 唔理佢嘅結果
	match str(e.k):
		"self": _self_make(P, sim, str(e.sid), 1)
		"rate_down":
			P.live.rate = {"mul": RATE_DOWN, "left": RATE_DOWN_S}
			sim.ev.append({"k": "p_float", "pos": sim.L.counter + Vector2(0, -150), "txt": P.S("rate_dn", "冥鏹貶值：收錢 ×%.2f" , "冥鏹貶值：收入 ×%.2f") % RATE_DOWN, "col": "#ff8a7a", "sz": 17})
		"doze":
			var w = e.get("w")
			if w is Dictionary: w.erase("doze"); P.act(w, "startle", 0.8)
		"fake": P.live.fake = false
		"parcel": sim.ev.append({"k": "p_float", "pos": e.pos + Vector2(0, -40), "txt": P.S("parcel_lost", "包裹畀野鬼執咗", "包裹被野鬼撿走了"), "col": "#ffb0a0"})

static func _self_make(P, sim, sid: String, cycles: int) -> void:
	if not sim.unlocked(sid): return
	var n = MD.out(sid, sim.lv(sid)) * cycles
	sim._made(sid, n)
	var sp = sim.split(sid, n)
	sim._stock(sid, sp[0], sim.st_pos(sid))
	var gid = str(MD.st_def(sid).get("good", ""))
	var put = sim._put_counter(gid, int(sp[1]))
	if int(sp[1]) - put > 0: sim.st().pile[sid] = float(sim.pile_n(sid) + int(sp[1]) - put)
	sim.ev.append({"k": "made", "sid": sid, "n": n, "pos": sim.st_pos(sid)})

# 撳世界記認
static func tap_btn(P, sim, key: String, e) -> bool:
	if not key.begins_with("e_") or not (e is Dictionary) or P.live.ev != e: return false
	resolve(P, sim, e)
	return true
static func resolve(P, sim, e: Dictionary) -> void:
	if J.t(e.get("done")): return
	match str(e.k):
		"self":
			_self_make(P, sim, str(e.sid), SELF_TAP)
			sim.ev.append({"k": "p_float", "pos": e.pos + Vector2(0, -130), "txt": P.S("self_ok", "自己做咗 %d 轉！" , "自己做了 %d 輪！") % SELF_TAP, "col": "#9fe39a", "sz": 17})
		"rate_up":
			if P.live.rate is Dictionary: P.live.rate.left = float(P.live.rate.left) + RATE_EXT
			sim.ev.append({"k": "p_float", "pos": sim.L.counter + Vector2(0, -150), "txt": P.S("rate_ext", "加價！匯率延長 %d 秒", "加價！匯率延長 %d 秒") % int(RATE_EXT), "col": "#9fe39a", "sz": 17})
		"rate_down":
			P.live.hold = HOLD_S
			sim.ev.append({"k": "p_float", "pos": sim.L.counter + Vector2(0, -150), "txt": P.S("hold_on", "囤貨：%d 秒唔賣", "囤貨：%d 秒不賣") % int(HOLD_S), "col": "#9fd8ff", "sz": 17})
		"doze":
			var w = e.get("w")
			if w is Dictionary:
				w.erase("doze"); P.act(w, "startle", 0.9)
				if w.get("paid") is Dictionary: w.prog = maxf(float(w.prog), 0.999)
				sim.ev.append({"k": "p_float", "pos": w.pos + Vector2(0, -90), "txt": P.S("woke", "醒晒！", "醒了！"), "col": "#9fe39a"})
		"parcel":
			var j = JS.st() if sim.SS() != null else null
			if j != null and JS.lv() > 0 and JS.count() < JS.CAP:
				j.q.append({"k": "n", "t": JS.now()})
				sim.ev.append({"k": "p_banner", "a": P.S("parcel_a", "陽間包裹", "陽間包裹"), "b": P.S("parcel_b", "放咗入化寶爐", "放進了化寶爐")})
			else:
				var got = give_mats(P, sim, 0.5)
				sim.ev.append({"k": "p_float", "pos": e.pos + Vector2(0, -60), "txt": P.S("parcel_mat", "包裹入面有材料：%s", "包裹裡有材料：%s") % got, "col": "#9fe39a"})
			P.stat_add(sim, "parcel")
		"special":
			var sp = P.map_d(sim.ci()).get("special", {})
			var g = str(e.get("g", ""))
			if sim.counter_n(g) <= 0: g = _spec_good(P, sim)
			var n = mini(int(sp.get("qty", 5)), sim.counter_n(g)) if g != "" else 0
			if n > 0:
				sim.st().counter[g] = float(sim.counter_n(g) - n)
				var v = float(n) * P.gval(sim, g) * float(sp.get("mul", 1.5)) * sim.inc_mul()
				sim.add_coins(v); sim.st().sold[g] = J.num(sim.st().sold.get(g)) + n
				sim.ev.append({"k": "p_coin", "pos": e.pos + Vector2(0, -60), "amt": v})
				sim.ev.append({"k": "p_line", "pos": e.pos, "line": P.T(sp.get("line", ["", ""])), "who": ev_name(P, sim, e)})
				e["sold"] = true
			P.stat_add(sim, "special")
		"fake":
			var c = e.get("c")
			if c is Dictionary: preload("res://game/outpost/mv_cust.gd").unmask(P, sim, c)
	e["done"] = true
	P.stat_add(sim, "res_" + str(e.k))

static func give_mats(P, sim, k := 1.0) -> String:
	var pool = []
	for sid in MD.stations(sim.ci()):
		if not sim.unlocked(sid): continue
		for mid in M.rin(sid):
			if M.tier(str(mid)) <= 2 and not pool.has(str(mid)): pool.append(str(mid))
	if pool.is_empty(): pool = ["m_wood", "m_rice"]
	var o = []
	for i in mini(2, pool.size()):
		var mid = pool[P.rng.randi() % pool.size()]; pool.erase(mid)
		var n = round(ORD_MAT * k * (1.0 + 0.5 * sim.ci()))
		M.add(mid, n); o.append("%s +%d" % [M.name(mid), int(n)])
	return "、".join(o)

# ================= 委託單 =================
static func ord_max(P, sim) -> int: return 2 if P.sign_tier(sim, sim.ci()) >= 3 else 1
static func prod_rate(P, sim, sid: String) -> float:   # 每秒件數（估算）
	var l = sim.lv(sid); var out = float(MD.out(sid, l)); var tm = MD.tm(sid, l)
	var w = sim.nworkers(sid); var r = 0.0
	if w > 0: r = float(w) * IDL.eff(sim, sid) * P.off_mul(sim, sid) * out / (tm + MD.carry_s(sim.ci(), sid))
	elif IDL.has_fore(sim, sid): r = IDL.FORE_SPD * out / tm
	else: r = 0.5 * out / tm
	if sim.missing(sid).size() > 0: r *= 0.3
	return r
static func make_order(P, sim) -> Dictionary:
	var cands = []
	for sid in _unl(sim):
		var r = prod_rate(P, sim, sid)
		if r > 0.0: cands.append([sid, r])
	if cands.is_empty(): return {}
	cands.sort_custom(func(a, b): return MD.val(a[0], sim.lv(a[0]), sim.ci()) * a[1] > MD.val(b[0], sim.lv(b[0]), sim.ci()) * b[1])
	var pick = cands[P.rng.randi() % mini(3, cands.size())]
	var roll = P.rng.randf()
	var need = {}; var star = {}; var T = 0.0
	var g0 = str(MD.st_def(pick[0]).get("good", ""))
	if roll >= 0.5 and roll < 0.8 and cands.size() >= 2:
		var other = cands[(cands.find(pick) + 1) % cands.size()]
		for e in [pick, other]:
			var q = clampi(int(round(e[1] * ORD_SECS * 0.5)), 2, 30)
			need[str(MD.st_def(e[0]).get("good", ""))] = float(q); T += float(q) / e[1]
	else:
		var q = clampi(int(round(pick[1] * ORD_SECS)), 3, 60)
		need[g0] = float(q); T = float(q) / pick[1]
		if roll >= 0.8 and _star_ok(P, sim, pick[0], pick[1]):
			star[g0] = float(MD.stars(pick[0], sim.lv(pick[0])) + 1); T = ORD_T_MAX / 3.0
	var p = P.ps(sim)
	var rws = P.map_d(sim.ci()).get("order_rw", ["mat", "inf"])
	var rw = str(rws[int(J.num(p.ord_i)) % rws.size()])
	if rw == "gear" and _gear_goods(sim).is_empty(): rw = "mat"
	p.ord_i = J.num(p.ord_i) + 1.0
	var cs = MD.map_def(sim.ci()).get("customers", [])
	var cid = ""
	for x in cs: if J.t(MD.cust_def(str(x)).get("vip")) and P.rng.randf() < 0.4: cid = str(x)
	if cid == "" and cs.size(): cid = str(cs[P.rng.randi() % cs.size()])
	var cd = MD.cust_def(cid); var ls = cd.get("lines", [])
	var o = {"id": "o%d" % int(J.num(p.ord_i)), "cid": cid, "k": str(cd.get("art", "youhun")), "vip": J.t(cd.get("vip")),
		"line": ls[P.rng.randi() % ls.size()] if ls is Array and ls.size() else ["", ""], "need": need, "got": {}, "star": star,
		"left": clampf(3.0 * T, ORD_T_MIN, ORD_T_MAX), "rw": rw}
	o["T"] = o.left
	p.orders.append(o)
	sim.ev.append({"k": "p_banner", "a": P.S("ord_new_a", "有大單！", "有大單！"), "b": who_name(o), "snd": "click"})
	P.stat_add(sim, "ord_new")
	return o
static func _star_ok(P, sim, sid: String, r: float) -> bool:   # 品質單：5 分鐘內升得到下個里程碑先出
	var l = sim.lv(sid); var nm = MD.next_mile(sid, l)
	if nm <= 0: return false
	if MD.cost_n(sid, l, nm - int(l)) > sim.coins() + 300.0 * P.earn_rate(sim): return false
	return float(MD.gate(sid, nm)) - IDL.made_n(sim, sid) <= 300.0 * r
static func _gear_goods(sim) -> Array:
	var o = []
	for sid in MD.stations(sim.ci()):
		var g = str(MD.st_def(sid).get("good", ""))
		if sim.unlocked(sid) and MVW.is_gear(g) and not o.has(g): o.append(g)
	return o
static func who_name(o: Dictionary) -> String:
	var k = str(o.get("k", "")); var nm = ""
	var ET = J.G.get("ENEMY_T")
	if ET is Dictionary and ET.get(k) is Array and ET[k].size() > 2: nm = J.str(ET[k][2])
	for tb in ["GHOSTS", "FODDER"]:
		var G = J.G.get(tb)
		if nm == "" and G is Dictionary and G.get(k) is Dictionary: nm = J.str(G[k].get("name", ""))
	if nm == "": nm = MD.S("guest", "鬼客", "鬼客")
	return ("VIP " if J.t(o.get("vip")) else "") + nm
static func rw_name(k: String) -> String:
	match k:
		"mat": return MD.S("rw_mat", "稀有材料", "稀有材料")
		"gear": return MD.S("rw_gear", "紙紮裝備（直接招一個義勇軍）", "紙紮裝備（直接招一個義勇軍）")
		"fore": return MD.S("rw_fore", "借領班鬼 8 分鐘", "借領班鬼 8 分鐘")
		"tix": return MD.S("rw_tix", "陽間包裹券", "陽間包裹券")
		"inf": return MD.S("rw_inf", "影響力 +%d", "影響力 +%d") % int(ORD_INF)
	return k
static func prog_txt(_P, _sim, o: Dictionary) -> String:
	var a = 0; var b = 0
	for g in o.need: a += int(J.num(o.got.get(g))); b += int(J.num(o.need[g]))
	return "%d/%d" % [a, b]
static func _star_met(sim, o: Dictionary, g: String) -> bool:
	var st = int(J.num((o.get("star", {}) as Dictionary).get(g)))
	if st <= 0: return true
	var sid = sim.sid_of(g)
	return sid != "" and MD.stars(sid, sim.lv(sid)) >= st
static func can_finish(P, sim, o: Dictionary) -> bool:
	for g in o.need:
		var left = J.num(o.need[g]) - J.num(o.got.get(g))
		if left > 0.0 and (P.have(sim, str(g)) < left or not _star_met(sim, o, str(g))): return false
	return true
static func order_coins(P, sim, o: Dictionary) -> float:
	var v = 0.0
	for g in o.need: v += J.num(o.need[g]) * P.gval(sim, str(g))
	return floor(v * ORD_COIN * (ORD_GOLD if P.sign_tier(sim, sim.ci()) >= 3 else 1.0))
# 撥貨：回 "done"／"part"／"none"
static func give(P, sim, i: int) -> String:
	var od = P.ps(sim).orders
	if i < 0 or i >= od.size(): return "none"
	var o = od[i]; var moved = 0
	for g in o.need:
		var left = int(J.num(o.need[g]) - J.num(o.got.get(g)))
		if left <= 0 or not _star_met(sim, o, str(g)): continue
		var n = P.take_goods(sim, str(g), left)
		if n > 0: o.got[g] = J.num(o.got.get(g)) + n; moved += n
	if moved > 0: sim.ev.append({"k": "p_float", "pos": sim.L.counter + Vector2(0, -120), "txt": P.S("given", "撥咗 %d 件入大單", "撥了 %d 件進大單") % moved, "col": "#ffd27a"})
	for g in o.need: if J.num(o.got.get(g)) < J.num(o.need[g]): return "part" if moved > 0 else "none"
	_complete(P, sim, o)
	return "done"
static func _complete(P, sim, o: Dictionary) -> void:
	var v = order_coins(P, sim, o)
	sim.add_coins(v)
	P.ps(sim).orders.erase(o)
	var extra = ""
	match str(o.rw):
		"mat": extra = give_mats(P, sim, 1.0)
		"gear":
			var gs = _gear_goods(sim)
			if gs.size():
				var g = str(gs[P.rng.randi() % gs.size()])
				var c = {"cid": str(o.cid), "k": str(o.k), "got": {g: 3.0}, "wants": {g: 3}, "vip": J.t(o.get("vip")), "pos": sim.L.counter + Vector2(30, 0), "st": "out", "s": 0.0}
				sim.war.on_paid(sim, c)
				extra = MD.S("rw_gear_ok", "%s 著住 %s 做咗義勇軍", "%s 穿著 %s 當了義勇軍") % [who_name(o), M.name(g)]
			else: extra = give_mats(P, sim, 1.0)
		"fore":
			var best = ""; var bv = -1.0
			for sid in _unl(sim):
				if IDL.has_fore(sim, sid): continue
				var vv = MD.val(sid, sim.lv(sid), sim.ci()) * MD.out(sid, sim.lv(sid)) / MD.tm(sid, sim.lv(sid))
				if vv > bv: bv = vv; best = sid
			if best != "":
				P.ps(sim).help = {"sid": best, "left": P.HELP_S}
				extra = MD.S("rw_fore_ok", "%s 借咗領班鬼", "%s 借了領班鬼") % MD.T(MD.st_def(best).get("n"))
		"tix":
			var j = JS.st()
			var k = "spd" if int(J.num(P.ps(sim).ord_i)) % 2 == 0 else "inc"
			if j != null: j.tix[k] = J.num(j.tix.get(k)) + 1.0; extra = JS.tix_name(k) + " +1"
		"inf": MVW.add_inf(ORD_INF); extra = rw_name("inf")
	sim.ev.append({"k": "p_banner", "a": MD.S("ord_done", "大單完成 +%s", "大單完成 +%s") % MD.fmt(v), "b": extra if extra != "" else who_name(o)})
	P.stat_add(sim, "ord_done")
static func drop(P, sim, i: int) -> void:
	var od = P.ps(sim).orders
	if i < 0 or i >= od.size(): return
	var o = od[i]
	for g in o.got: sim._put_counter(str(g), int(J.num(o.got[g])))   # 撥咗嘅貨退返櫃台
	od.remove_at(i)
	P.stat_add(sim, "ord_drop")
static func _fail(P, sim, o: Dictionary) -> void:
	for g in o.got: sim._put_counter(str(g), int(J.num(o.got[g])))
	P.ps(sim).orders.erase(o)
	MVW.add_inf(-ORD_FAIL_INF)
	sim.ev.append({"k": "p_float", "pos": sim.L.counter + Vector2(0, -150), "txt": MD.S("ord_fail", "大單過咗時：%s 嬲咗，影響力 −%d", "大單過時：%s 生氣了，影響力 −%d") % [who_name(o), int(ORD_FAIL_INF)], "col": "#ff8a7a", "sz": 16})
	P.stat_add(sim, "ord_fail")

# ================= 畫面 =================
static func draw_hud(P, sc, ctx, y: float) -> void:
	var sim = sc.sim
	var e = P.live.get("ev")
	if not (e is Dictionary) or J.t(e.get("done")): return
	var k = str(e.k)
	if k in ["rate_up", "rate_down"]:
		var left = maxf(0.0, float(e.life) - float(e.t))
		P._chip(sc, ctx, y, "%s %s %d" % [ev_name(P, sim, e), ev_tap(P, sim, e), int(ceil(left))], "#9fe39a" if k == "rate_up" else "#ff8a7a", "ev", true, 290.0)
	if k == "rain":
		for c in e.coins:
			if J.t(c.got): continue
			var sy = sc.top_pad + 90.0 + float(c.y)
			if sy < sc.top_pad + 90.0 or sy > sc.top_pad + sc.view_h(): continue
			var sx = float(c.x) + sin(sc.t * 2.0 + float(c.ph)) * 14.0
			ctx.save(); ctx.translate(sx, sy); ctx.rotate(sin(sc.t * 3.0 + float(c.ph)) * 0.5)
			Art.rr(ctx, -15, -9, 30, 18, 3, "#e8c86a", "#7a5a20", 1.5)
			Art.rr(ctx, -6, -5, 12, 10, 2, "rgba(150,40,30,.85)")
			ctx.restore()
static func tap_hud(P, sim, key: String) -> bool:
	if key != "ev": return false
	var e = P.live.get("ev")
	if e is Dictionary and str(e.k) in ["rate_up", "rate_down"]: resolve(P, sim, e); return true
	return false
static func tap_screen(P, sc, p: Vector2) -> bool:
	var e = P.live.get("ev")
	if not (e is Dictionary) or str(e.k) != "rain": return false
	for c in e.coins:
		if J.t(c.got): continue
		var sp = Vector2(float(c.x) + sin(sc.t * 2.0 + float(c.ph)) * 14.0, sc.top_pad + 90.0 + float(c.y))
		if sp.distance_to(p) < 30.0:
			c.got = true
			sc.sim.add_coins(float(e.v))
			sc.sim.ev.append({"k": "p_coin", "pos": sc.s2w(sp), "amt": float(e.v)})
			P.stat_add(sc.sim, "rain")
			return true
	return false
static func rain_tap_n(P, sim, n: int) -> int:   # 測試／模擬用：直接執 n 張
	var e = P.live.get("ev"); var k = 0
	if not (e is Dictionary) or str(e.k) != "rain": return 0
	for c in e.coins:
		if k >= n or J.t(c.got): continue
		c.got = true; sim.add_coins(float(e.v)); k += 1
	return k

static func draw_world(P, sc, ctx, vy0: float, vy1: float) -> void:
	var sim = sc.sim
	var e = P.live.get("ev")
	if not (e is Dictionary) or J.t(e.get("done")): return
	var k = str(e.k); var p = Vector2.ZERO
	match k:
		"self": p = sim.st_pos(str(e.sid)) + Vector2(0, -60)
		"doze": p = (e.w.pos as Vector2) + Vector2(0, -40) if e.get("w") is Dictionary else Vector2.ZERO
		"parcel": p = e.pos
		"special": p = Vector2(float(e.x), float(e.pos.y))
		_: return
	if p.y < vy0 - 60.0 or p.y - 140.0 > vy1: return
	var tt = sc.t
	if k == "special":
		var sp = P.map_d(sim.ci()).get("special", {})
		for i in int(e.get("n", 1)):
			var q = p + Vector2(30.0 * i, 6.0 * (i % 2))
			var hop = absf(sin(tt * 5.0 + i * 0.7)) * (14.0 if str(sp.get("art")) == "zombie" else 4.0)
			Art.draw_char(ctx, str(sp.get("art", "youhun")), q.x, q.y - hop, 1.0, {"t": tt + i, "walk": float(e.x) > float(e.pos.x), "flip": true, "alpha": 0.95})
		p += Vector2(0, -70)
	if k == "parcel":
		var dy = sin(tt * 3.0) * 2.0
		Art.rr(ctx, p.x - 18, p.y - 30 + dy, 36, 28, 4, "#c8a060", "#5a3a18", 2)
		ctx.fillStyle = "#9c2219"; ctx.fillRect(p.x - 3, p.y - 30 + dy, 6, 28); ctx.fillRect(p.x - 18, p.y - 19 + dy, 36, 5)
		p += Vector2(0, -36)
	# 脈動光圈＋名＋撳嘅字
	var r = 26.0 + 6.0 * sin(tt * 5.0)
	ctx.save(); ctx.globalAlpha = 0.55 + 0.25 * sin(tt * 5.0)
	ctx.strokeStyle = "#ffd27a"; ctx.lineWidth = 3.0
	ctx.beginPath(); ctx.arc(p.x, p.y, r, 0, TAU); ctx.stroke()
	ctx.restore()
	var nm = ev_name(P, sim, e); var tp = ev_tap(P, sim, e)
	sc._txt(ctx, nm, p.x, p.y - r - 26.0, 15, Color("#ffd27a"), "center", 900, 4)
	ctx.font = "900 15px sans-serif"; var nw = maxf(ctx.measureText(nm).width, ctx.measureText(tp).width + 30.0) + 12.0
	P.label_rects.append(Rect2(clampf(p.x - nw / 2.0, 0.0, 390.0 - nw), p.y - r - 38.0, nw, 42.0))   # 對白框要避開
	sc._txt(ctx, tp + " %d" % int(ceil(maxf(0.0, float(e.life) - float(e.t)))), p.x, p.y - r - 8.0, 14, Color("#fff3e0"), "center", 900, 4)
	P._wbtn["e_" + k] = [Rect2(p.x - 46.0, p.y - r - 40.0, 92.0, r * 2.0 + 44.0), e]

static func eat(P, sc) -> void:
	var sim = sc.sim
	for e in sim.ev:
		if str(e.get("k", "")) == "p_ev":
			sc._float(sc.s2w(Vector2(195, sc.top_pad + 230)), str(e.name), Color("#ffd27a"), 18, 2.0)
			sc._snd("whoosh")
