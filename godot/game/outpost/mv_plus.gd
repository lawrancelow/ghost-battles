# [play] 玩法線：「比 Idle Outpost 更好玩」總掣（冇 class_name、冇 autoload；熱更新規矩）
# 用法：mv_sim.gd 有 `var plus = MVP.new()`（掛鈎行標 # [play]）；mv_scene.gd 叫 sim.plus.eat／draw_world／draw_hud／tap／act_draw／draw_tag／sheet_rows。
# 設計同數值：PLAY_PLUS.md。資料：data/nat/play.json。
#   本檔：狀態、夜潮、鬼員工羈絆、招牌菜、借嚟領班、人物特別動作（act）、畫面（小卡、彈出卡、記認、夜色）
#   mv_cust.gd：鬼客脾氣（講價／插隊／走數／挑剔／熟客／孤魂扮客）
#   mv_event.gd：詭異事件＋委託單
# 狀態 S.mv.plus（JSON 安全）：{v, fam:{cid:n}, sign:{"ci":{n}}, weak:{"ci":1}, ach:[], orders:[...], ord_t, ord_i, ev_t, tide_t, help, stats:{}}
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
const IDL = preload("res://game/outpost/mv_idle.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const CU = preload("res://game/outpost/mv_cust.gd")
const EV = preload("res://game/outpost/mv_event.gd")
const PATH := "res://data/nat/play.json"
const FW := 390.0

# ---------------- 夜潮 ----------------
const TIDE_FIRST := 300.0    # 每張圖第一次入夜（在線秒）；第 1 張圖新手保護期（600 秒）之後先入夜
const TIDE_DAY := 300.0
const TIDE_NIGHT := 120.0
const TIDE_WARN := 10.0
const NIGHT_CUST := 1.5
const NIGHT_PAY := 1.0
const NIGHT_FOE := 1.8
const NIGHT_KILL := 1.5
# ---------------- 羈絆 ----------------
const FIT_MUL := 1.2
const BAD_MUL := 0.7
const NIGHT_OFF := 0.5       # Pontianak 唔上夜班
# ---------------- 招牌菜 ----------------
const SIGN_MUL := 1.8
const SIGN_NIGHT := 1.3
const SIGN_TIERS := [3, 10, 30]
const SILVER_PAY := 1.1
const HELP_S := 480.0
const HELP_MUL := 1.5

static var _D = null
static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var o = JSON.parse_string(FileAccess.get_file_as_string(PATH)) if FileAccess.file_exists(PATH) else null
	_D = o if o is Dictionary else {}
	for k in ["STATIONS", "TEMPERS", "EVENTS", "STRINGS", "BOND_LINES"]: if not (_D.get(k) is Dictionary): _D[k] = {}
	for k in ["PAIRS", "CLASH", "MAPS"]: if not (_D.get(k) is Array): _D[k] = []
static func T(a) -> String: return MD.T(a)
static func S(key: String, yue: String, zh: String) -> String:
	var a = D().STRINGS.get(key)
	if a is Array: return T(a)
	return yue if DB.lang == "yue" else zh
static func map_d(ci: int) -> Dictionary:
	for m in D().MAPS: if int(m.get("ci", -1)) == ci: return m
	return {}
static func st_d(sid: String) -> Dictionary:
	var d = D().STATIONS.get(sid)
	return d if d is Dictionary else {}

var rng := RandomNumberGenerator.new()
var live := {"rate": null, "hold": 0.0, "ev": null, "rain": [], "fake": false, "earn": 0.0, "night": false, "warned": false}
var _bc := {}          # 羈絆快取：sid → [key, {gid: {mul, tags:[], line}}]
var _seen := {}        # 已經飄過羈絆字嘅 gid@sid
var _btn := {}         # 畫面掣（畫面座標）
var _wbtn := {}        # 世界掣（世界座標）：key → [Rect2, 物件]
var card = null        # 彈出卡：{"k":"order","i":n} 或 {"k":"sign"}
var _clash_t := {}     # 嗌交計時
var _sc = null         # 畫面（只係攞鏡頭範圍畫紙錢雨用）
var off := false       # 測試用：成套關咗（所有掛鈎回中性值）
static var test_off := false   # 測試用：所有 sim 實例一齊關（例如 mv_bridge 自己開嘅 sim）

func _init() -> void:
	rng.seed = 20261120

# ================= 狀態 =================
func SS():
	var s = J.G.get("S")
	return s if s is Dictionary else null
func ps(sim) -> Dictionary:
	var m = sim.st()
	if m == null: return {}
	if not (m.get("plus") is Dictionary):
		m["plus"] = {"v": 1.0, "fam": {}, "sign": {}, "weak": {}, "ach": [], "orders": [], "ord_t": EV.ORD_FIRST, "ord_i": 0.0, "ev_t": EV.EV_FIRST, "tide_t": 0.0, "help": null, "stats": {}}
	var p = m.plus
	for k in ["fam", "sign", "weak", "stats"]: if not (p.get(k) is Dictionary): p[k] = {}
	for k in ["ach", "orders"]: if not (p.get(k) is Array): p[k] = []
	for k in ["ord_t", "ev_t"]: if p.get(k) == null: p[k] = EV.ORD_FIRST if k == "ord_t" else EV.EV_FIRST
	if p.get("tide_t") == null: p["tide_t"] = 0.0
	return p
func stat_add(sim, k: String, n := 1.0) -> void:
	var p = ps(sim); p.stats[k] = J.num(p.stats.get(k)) + n

# ================= 夜潮 =================
func tide_first(sim) -> float: return maxf(TIDE_FIRST, MVW.NEWBIE) if sim.ci() == 0 else TIDE_FIRST
# [是否夜潮, 呢段仲有幾多秒]
func tide(sim) -> Array:
	var t = J.num(ps(sim).get("tide_t")); var f = tide_first(sim)
	if t < f: return [false, f - t]
	var p = fmod(t - f, TIDE_DAY + TIDE_NIGHT)
	if p < TIDE_NIGHT: return [true, TIDE_NIGHT - p]
	return [false, TIDE_DAY + TIDE_NIGHT - p]
func is_night(sim) -> bool: return bool(tide(sim)[0])

# ================= 掛鈎（mv_sim 叫） =================
func freq_mul(sim) -> float:
	if off or test_off: return 1.0
	return NIGHT_CUST if is_night(sim) else 1.0
func foe_mul(sim) -> float:
	if off or test_off: return 1.0
	return NIGHT_FOE if is_night(sim) else 1.0
func kill_mul(sim) -> float:
	if off or test_off: return 1.0
	return NIGHT_KILL if is_night(sim) else 1.0
func dmg_mul(sim, f: Dictionary) -> float:
	if off or test_off: return 1.0
	return 2.0 if J.t(f.get("boss")) and J.t(ps(sim).weak.get(str(sim.ci()))) else 1.0
func rate_mul() -> float: return float(live.rate.mul) if live.rate is Dictionary else 1.0
func hold_take(_sim) -> bool:
	if off or test_off: return false
	return float(live.hold) > 0.0
func pat_add(c: Dictionary) -> float:
	if off or test_off: return 0.0
	var a = float(c.get("pat_b", 0.0))
	if str(c.get("tp", "")) == "reg": a += CU.REG_PAT
	if float(live.hold) > 0.0: a += 20.0
	return a
func hold_pay(sim, c: Dictionary) -> bool:
	if off or test_off: return false
	return CU.hold_pay(self, sim, c)
func pay_mul(sim, c: Dictionary) -> float:
	if off or test_off: return 1.0
	var k = CU.pay_mul(self, sim, c) * rate_mul()
	if is_night(sim): k *= NIGHT_PAY
	if sign_tier(sim, sim.ci()) >= 2:
		var parts = sign_def(sim.ci()).get("parts", {})
		for g in c.got: if parts.has(str(g)): k *= SILVER_PAY; break
	return k
func on_spawn(sim, c: Dictionary) -> void:
	if off or test_off: return
	CU.on_spawn(self, sim, c)
func on_paid(sim, c: Dictionary, amt: float) -> void:
	if off or test_off: return
	live.earn = float(live.earn) + amt
	CU.on_paid(self, sim, c, amt)
func smul(sim, sid: String) -> float:
	if off or test_off: return 1.0
	# 台嘅倍數（借嚟領班）
	var h = ps(sim).get("help")
	return HELP_MUL if h is Dictionary and str(h.get("sid")) == sid and J.num(h.get("left")) > 0.0 else 1.0
func wmul(sim, w: Dictionary) -> float:
	if off or test_off: return 1.0
	# 員工倍數：羈絆 × 台倍數；瞌眼瞓 = 0
	if J.t(w.get("doze")): return 0.0
	var b = bond(sim, str(w.sid)).get(str(w.gid))
	return (float(b.mul) if b is Dictionary else 1.0) * smul(sim, str(w.sid))
func off_mul(sim, sid: String) -> float:
	if off or test_off: return 1.0
	# 離線：台入面員工嘅平均羈絆倍數（唔計夜潮）
	var bs = bond(sim, sid, false); if bs.is_empty(): return 1.0
	var t = 0.0
	for g in bs: t += float(bs[g].mul)
	return t / bs.size()
func on_move(sim, _from_ci: int) -> void:
	var p = ps(sim)
	p.orders = []; p.ord_t = EV.ORD_FIRST; p.ev_t = EV.EV_FIRST; p.tide_t = 0.0; p.help = null
	reset_live()
func reset_live() -> void:
	live = {"rate": null, "hold": 0.0, "ev": null, "rain": [], "fake": false, "earn": 0.0, "night": false, "warned": false}
	_bc.clear(); _seen.clear(); card = null; _clash_t.clear()

# ================= 每格 =================
func step(sim, dt: float) -> void:
	if off or test_off: return
	var p = ps(sim); if p.is_empty(): return
	var was = is_night(sim)
	p.tide_t = J.num(p.tide_t) + dt
	var tn = tide(sim)
	if tn[0] != was:
		sim.ev.append({"k": "p_night" if tn[0] else "p_day"}); live.warned = false
		_bc.clear()
	elif not tn[0] and float(tn[1]) <= TIDE_WARN and not live.warned and J.num(p.tide_t) >= tide_first(sim) - TIDE_WARN:
		live.warned = true; sim.ev.append({"k": "p_night_warn"})
	live.night = tn[0]
	if live.rate is Dictionary:
		live.rate.left = float(live.rate.left) - dt
		if live.rate.left <= 0.0: live.rate = null; sim.ev.append({"k": "p_rate_end"})
	if float(live.hold) > 0.0:
		live.hold = float(live.hold) - dt
		if live.hold <= 0.0: live.hold = 0.0; live.rate = {"mul": EV.RATE_AFTER, "left": EV.RATE_AFTER_S}; sim.ev.append({"k": "p_rate_after"})
	live.earn = float(live.earn) * exp(-dt / 60.0)   # 最近大約 1 分鐘收入
	var h = p.get("help")
	if h is Dictionary:
		h.left = J.num(h.left) - dt
		if h.left <= 0.0: p.help = null; sim.ev.append({"k": "p_help_end", "sid": str(h.sid)})
		else: _help_auto(sim, str(h.sid), dt)
	CU.step(self, sim, dt)
	EV.step(self, sim, dt)
	_step_acts(sim, dt)
	_bond_news(sim)
func earn_rate(sim) -> float:   # 每秒收入（估算）：最近收入同離線估算取大
	return maxf(float(live.earn) / 60.0, sim.offline_rate())

var _help_t := 0.0
func _help_auto(sim, sid: String, dt: float) -> void:   # 借嚟領班：自動收錢＋自動開工（同 mv_idle 領班一樣）
	_help_t -= dt
	if _help_t > 0.0 or not sim.unlocked(sid) or IDL.has_fore(sim, sid): return
	_help_t = IDL.AUTO_DT
	if sim.war.blocked(sim, sid): return
	if sim.pile_n(sid) > 0: sim.tap_station(sid)
	if sim.nworkers(sid) == 0 and float(sim.mk.get(sid, -1.0)) < 0.0 and sim.pile_n(sid) < sim.pile_cap(sid) and sim.missing(sid).is_empty(): sim.tap_station(sid)

# ================= 鬼員工羈絆 =================
static func kname(k: String) -> String:
	for tb in ["GHOSTS", "FODDER"]:
		var G = J.G.get(tb)
		if G is Dictionary and G.get(k) is Dictionary: return J.str(G[k].get("name", k))
	return k
func _gstat(gh, i: int) -> float:
	var F = J.G.get("F")
	if F != null and gh is Dictionary and gh.get("st") is Array: return J.num(J.mc(F, "stat", [gh, i]))
	var a = J.gp(gh, "st")
	return J.num(a[i]) if a is Array and a.size() > i else 30.0
# sid 每個員工嘅羈絆：{gid: {mul, tags:["fit"|"bad"|"pair"|"clash"|"night"], line, k}}
func bond(sim, sid: String, night_on := true) -> Dictionary:
	var ws = sim.sst(sid).workers
	var key = str(ws) + str(is_night(sim) and night_on)
	var c = _bc.get(sid + ("" if night_on else "#off"))
	if c is Array and c[0] == key: return c[1]
	var sd = st_d(sid); var o = {}
	var ks = {}
	for gid in ws:
		if gid == null: continue
		var gh = sim.ghost(gid); if gh == null: continue
		ks[str(gid)] = J.str(J.gp(gh, "k"))
	var food = str(sd.get("work", "")) == "knead"
	for gid in ks:
		var k = ks[gid]; var gh = sim.ghost(gid)
		var mul = clampf(1.0 + (_gstat(gh, int(sd.get("stat", 1))) - 30.0) / 400.0, 0.9, 1.35)
		var tags = []; var line = ""
		if k in sd.get("fit", []): mul *= FIT_MUL; tags.append("fit")
		for b in sd.get("bad", []):
			if b is Array and str(b[0]) == k: mul *= BAD_MUL; tags.append("bad"); line = T(b[1])
		if k == "pontianak" and night_on and is_night(sim): mul *= NIGHT_OFF; tags.append("night")
		for g2 in ks:
			if g2 == gid: continue
			var k2 = ks[g2]
			for pr in D().PAIRS:
				if (str(pr.a) == k and str(pr.b) == k2) or (str(pr.b) == k and str(pr.a) == k2):
					if not ("pair" in tags): mul *= float(pr.get("mul", 1.15)); tags.append("pair"); line = T(pr.line)
			for cl in D().CLASH:
				if J.t(cl.get("food")) and not food: continue
				if (str(cl.a) == k and str(cl.b) == k2) or (str(cl.b) == k and str(cl.a) == k2):
					if not ("clash" in tags): mul *= float(cl.get("mul", 0.75)); tags.append("clash"); line = T(cl.line)
		o[gid] = {"mul": mul, "tags": tags, "line": line, "k": k}
	_bc[sid + ("" if night_on else "#off")] = [key, o]
	return o
func _bond_news(sim) -> void:   # 啱啱派落台嘅鬼：飄字＋動作
	var now_k = {}
	for w in sim.workers:
		var key = str(w.gid) + "@" + str(w.sid); now_k[key] = true
		if _seen.has(key): continue
		_seen[key] = true
		var b = bond(sim, str(w.sid)).get(str(w.gid))
		if not (b is Dictionary) or b.tags.is_empty(): continue
		var L = D().BOND_LINES
		var tx = ""
		for tg in b.tags: tx += ("　" if tx != "" else "") + T(L.get(tg, ["", ""]))
		sim.ev.append({"k": "p_bond", "pos": w.pos, "txt": tx, "line": b.line, "good": not ("bad" in b.tags or "clash" in b.tags or "night" in b.tags)})
		act(w, "cheer" if not ("bad" in b.tags or "clash" in b.tags) else "hurt", 1.0)
	for k in _seen.keys(): if not now_k.has(k): _seen.erase(k)

# ================= 招牌菜 =================
func sign_def(ci: int) -> Dictionary:
	var s = map_d(ci).get("sign")
	return s if s is Dictionary else {}
func sign_n(sim, ci: int) -> int: return int(J.num((ps(sim).sign.get(str(ci), {}) as Dictionary).get("n"))) if ps(sim).sign.get(str(ci)) is Dictionary else 0
func sign_tier(sim, ci: int) -> int:
	var n = sign_n(sim, ci); var t = 0
	for x in SIGN_TIERS: if n >= x: t += 1
	return t
func have(sim, gid: String) -> float: return float(sim.counter_n(gid)) + floor(M.amt(gid) + 1e-6)
func take_goods(sim, gid: String, n: int) -> int:   # 先櫃台、後材料庫
	var a = mini(n, sim.counter_n(gid))
	if a > 0: sim.st().counter[gid] = float(sim.counter_n(gid) - a)
	var b = mini(n - a, int(floor(M.amt(gid) + 1e-6)))
	if b > 0: M.add(gid, -float(b))
	return a + b
func gval(sim, gid: String) -> float:
	var sid = sim.sid_of(gid)
	return MD.val(sid, sim.lv(sid), sim.ci()) if sid != "" else 0.0
func sign_ok(sim) -> bool:
	var sd = sign_def(sim.ci()); if sd.is_empty(): return false
	for g in sd.parts:
		if not sim.unlocked(sim.sid_of(str(g))): return false
		if have(sim, str(g)) < float(sd.parts[g]): return false
	return true
func sign_value(sim) -> float:
	var sd = sign_def(sim.ci()); var v = 0.0
	for g in sd.get("parts", {}): v += float(sd.parts[g]) * gval(sim, str(g))
	return v * SIGN_MUL * (SIGN_NIGHT if is_night(sim) else 1.0) * sim.inc_mul()
func make_sign(sim) -> float:
	if not sign_ok(sim): return 0.0
	var v = sign_value(sim)
	var sd = sign_def(sim.ci())
	for g in sd.parts: take_goods(sim, str(g), int(sd.parts[g]))
	sim.add_coins(v)
	var p = ps(sim); var ck = str(sim.ci())
	if not (p.sign.get(ck) is Dictionary): p.sign[ck] = {"n": 0.0}
	var t0 = sign_tier(sim, sim.ci())
	p.sign[ck].n = J.num(p.sign[ck].n) + 1.0
	var t1 = sign_tier(sim, sim.ci())
	sim.ev.append({"k": "p_sign", "amt": v, "pos": sim.L.counter + Vector2(0, -80)})
	if t1 > t0:
		var a = "sign%d_%d" % [sim.ci(), t1]
		if not (a in p.ach): p.ach.append(a)
		if t1 >= 1: p.weak[ck] = 1.0
		sim.ev.append({"k": "p_sign_tier", "tier": t1})
	stat_add(sim, "sign")
	return v
static func boss_weak(ci: int) -> bool:   # 主線 Boss 戰可以讀（銅牌招牌菜）
	var s = J.G.get("S")
	if not (s is Dictionary) or not (s.get("mv") is Dictionary) or not (s.mv.get("plus") is Dictionary): return false
	return J.t((s.mv.plus.get("weak", {}) as Dictionary).get(str(ci)))

# ================= 人物特別動作 =================
func act(e: Dictionary, k: String, life: float) -> void: e["act"] = {"k": k, "t": 0.0, "life": life}
func _step_acts(sim, dt: float) -> void:
	for c in sim.custs:
		if c.get("act") is Dictionary:
			c.act.t = float(c.act.t) + dt
			if c.act.t >= float(c.act.life): c.erase("act")
	var food_pairs = {}
	for w in sim.workers:
		if w.get("act") is Dictionary:
			w.act.t = float(w.act.t) + dt
			if w.act.t >= float(w.act.life): w.erase("act")
		if J.t(w.get("doze")):
			var de = live.get("ev")
			if not (de is Dictionary) or str(de.k) != "doze" or de.get("w") != w: w.erase("doze")
			else: continue
		if w.st != "work" or J.t(w.get("walk")): continue
		w["act_cd"] = float(w.get("act_cd", rng.randf_range(3.0, 9.0))) - dt
		if float(w.act_cd) <= 0.0 and not w.has("act"):
			w.act_cd = rng.randf_range(6.0, 12.0)
			var sd = st_d(str(w.sid)); var wk = str(sd.get("work", "knead"))
			if str(w.k) in ["egui", "eguiking"] and wk == "knead" and rng.randf() < 0.35:
				act(w, "munch", 1.6); sim.ev.append({"k": "p_munch", "pos": w.pos})
			else: act(w, wk, 1.4)
		var b = bond(sim, str(w.sid)).get(str(w.gid))
		if b is Dictionary and "clash" in b.tags: food_pairs[str(w.sid)] = true
	for sid in food_pairs:   # 嗌交：每 6–9 秒互打＋對白
		_clash_t[sid] = float(_clash_t.get(sid, rng.randf_range(2.0, 5.0))) - dt
		if _clash_t[sid] > 0.0: continue
		_clash_t[sid] = rng.randf_range(6.0, 9.0)
		var line = ""
		for w in sim.workers:
			if str(w.sid) != sid: continue
			var b = bond(sim, sid).get(str(w.gid))
			if b is Dictionary and "clash" in b.tags: act(w, "strike", 0.9); line = b.line
		sim.ev.append({"k": "p_clash", "pos": sim.st_pos(sid), "line": line})
	for e in sim.ev:   # 里程碑：全台員工一齊跳
		if str(e.get("k")) == "mile":
			for w in sim.workers: if str(w.sid) == str(e.sid): act(w, "air", 1.0)

# 畫角色（有動作／特別狀態先接手）；回 true = 已經畫咗
func act_draw(sc, ctx, e: Dictionary, s: float, o: Dictionary) -> bool:
	var a = e.get("act")
	var tp = str(e.get("tp", ""))
	var special = tp == "fake" or J.t(e.get("doze")) or J.t(e.get("dash")) or (tp == "haggle" and J.t(e.get("prompt")))
	if not (a is Dictionary) and not special: return false
	var k = str(a.k) if a is Dictionary else ""
	var u = clampf(float(a.t) / maxf(0.01, float(a.life)), 0.0, 1.0) if a is Dictionary else 0.0
	var tt = sc.t
	var dx = 0.0; var dy = 0.0; var rot = 0.0; var sx = 1.0; var sy = 1.0
	if J.t(e.get("dash")) and k == "": k = "run"
	if tp == "haggle" and J.t(e.get("prompt")) and k == "": k = "haggle"
	match k:
		"hop", "cheer":
			o["pose"] = "proud"; dy = -absf(sin(u * PI * 2.0)) * 16.0
			var q = absf(sin(u * PI * 2.0)); sx = 1.0 - 0.08 * (1.0 - q); sy = 1.0 + 0.08 * (1.0 - q) - 0.05
		"air": o["pose"] = "air"; o["pt"] = u; dy = -sin(u * PI) * 42.0; rot = sin(u * PI * 2.0) * 0.25
		"hurt": o["pose"] = "hurt"; o["pt"] = u; o["hurt"] = true; dx = sin(tt * 40.0) * 3.0 * (1.0 - u)
		"haggle": o["pose"] = "cast"; o["pt"] = 0.5; dx = sin(tt * 8.0) * 4.0; rot = sin(tt * 8.0) * 0.06
		"run": o["pose"] = "run"; o["walk"] = true; rot = -0.18 if not J.t(o.get("flip")) else 0.18
		"down": o["pose"] = "down"; o["pt"] = minf(1.0, u * 2.0); sy = 1.0 - 0.25 * minf(1.0, u * 3.0)
		"picky": o["pose"] = "cast"; o["pt"] = 0.6; rot = 0.08; dx = 6.0 * sin(tt * 3.0)
		"wave": o["pose"] = "cast"; o["pt"] = 0.5 + 0.5 * sin(tt * 10.0)
		"startle": o["pose"] = "startle"; dy = -sin(u * PI) * 26.0; sx = 1.0 + 0.12 * sin(u * PI); sy = 1.0 - 0.06 * sin(u * PI)
		"knead", "hammer", "chop", "reap":
			o["pose"] = k; o["pt"] = fmod(u * 2.0, 1.0)
			var q2 = sin(u * PI * 4.0)
			if k == "hammer": dy = -absf(q2) * 6.0; rot = q2 * 0.08
			elif k == "knead": sx = 1.0 + 0.06 * q2; sy = 1.0 - 0.06 * q2
			else: rot = q2 * 0.12
		"munch": o["pose"] = "knead"; o["pt"] = fmod(u * 3.0, 1.0); sy = 1.0 + 0.05 * sin(tt * 30.0)
		"strike": o["pose"] = "strike"; o["pt"] = u; dx = sin(u * PI) * 10.0 * (-1.0 if J.t(o.get("flip")) else 1.0)
		"proud": o["pose"] = "proud"
	if J.t(e.get("doze")): o["pose"] = "faint"; o["pt"] = 0.3; rot = 0.12; sy *= 0.96
	if tp == "fake" and not J.t(e.get("unmask")): o["alpha"] = 0.5 + 0.3 * sin(tt * 9.0)
	var p: Vector2 = e.pos
	ctx.save()
	ctx.translate(p.x + dx, p.y + dy); ctx.rotate(rot); ctx.scale(sx, sy)
	Art.draw_char(ctx, str(e.k), 0.0, 0.0, s, o)
	ctx.restore()
	# 附加：速度線、星星、放大鏡、Zzz
	if k == "run":
		ctx.save(); ctx.strokeStyle = "rgba(255,240,210,.75)"; ctx.lineWidth = 2.0
		var dirx = 1.0 if J.t(o.get("flip")) else -1.0
		for i in 3:
			var yy = p.y - 20.0 - i * 14.0; var ln = 18.0 + 8.0 * sin(tt * 20.0 + i)
			ctx.beginPath(); ctx.moveTo(p.x + dirx * 18.0, yy); ctx.lineTo(p.x + dirx * (18.0 + ln), yy); ctx.stroke()
		ctx.restore()
	if k == "down":
		for i in 3:
			var an = tt * 4.0 + i * TAU / 3.0
			sc._txt(ctx, "★", p.x + cos(an) * 16.0, p.y - 46.0 + sin(an) * 5.0, 14, Color("#ffd27a"), "center", 900, 3)
	if k == "picky": sc._txt(ctx, "◎", p.x + 20.0, p.y - 44.0, 18, Color("#f0e2c8"), "center", 900, 3)
	if k == "munch": sc._txt(ctx, S("munch", "嚼嚼", "嚼嚼"), p.x + 22.0, p.y - 58.0, 14, Color("#ffd27a"), "center", 900, 3)
	if J.t(e.get("doze")): sc._txt(ctx, "Zzz", p.x + 18.0 + sin(tt * 2.0) * 3.0, p.y - 62.0 - fmod(tt * 8.0, 10.0), 16, Color("#bfe0ff"), "center", 900, 3)
	return true

# ================= 畫面：事件（mv_scene._eat_events 開頭叫） =================
func eat(sc) -> void:
	_sc = sc
	var sim = sc.sim
	for e in sim.ev:
		var k = str(e.get("k", ""))
		if not k.begins_with("p_"): continue
		match k:
			"p_night":
				sc._banner_set(S("night_a", "陰潮入夜", "陰潮入夜"), S("night_b", "客多、孤魂都多", "客多、孤魂也多"), 2.4); sc._snd("whoosh")
			"p_day": sc._float(sc.s2w(Vector2(195, sc.top_pad + 200)), S("day", "天光喇：夜潮過咗", "天亮了：夜潮過了"), Color("#f3e6c8"), 17, 1.8)
			"p_night_warn": sc._float(sc.s2w(Vector2(195, sc.top_pad + 200)), S("night_warn", "陰風起……就入夜", "陰風起……快入夜了"), Color("#d8b0ff"), 17, 2.2)
			"p_bond":
				sc._float(e.pos + Vector2(0, -84), str(e.txt), Color("#bff0a0") if e.good else Color("#ffb0a0"), 15, 1.8)
				if str(e.line) != "": sc._bubble(e.pos + Vector2(-60, -60), str(e.line), S("staff", "夥計", "夥計"), 2.4)
			"p_clash":
				if str(e.line) != "": sc._bubble(e.pos + Vector2(-60, -100), str(e.line), S("quarrel", "嗌交", "吵架"), 2.2)
				sc._burst(e.pos + Vector2(0, -60), Color("#ff8a7a"), 6)
			"p_munch": sc._float(e.pos + Vector2(0, -90), S("munch_f", "偷食！", "偷吃！"), Color("#ffd27a"), 14, 1.0)
			"p_line": sc._bubble(e.pos + Vector2(-60, -70), str(e.line), str(e.get("who", "")), 2.4)
			"p_float": sc._float(e.pos, str(e.txt), Color(str(e.get("col", "#f3d68a"))), int(e.get("sz", 16)), 1.6)
			"p_coin":
				var n = clampi(3 + int(log(maxf(1.0, float(e.amt))) / log(10.0)), 3, 8)
				for i in n: sc._coin(sc.w2s(e.pos), Vector2(FW - 70, sc.top_pad + 68), 0.6 + i * 0.06, float(e.amt) / n)
				sc._float(e.pos + Vector2(0, -6), "+" + MD.fmt(e.amt), Color("#f3d68a"), 22, 1.6)
				sc._snd("coin")
			"p_banner": sc._banner_set(str(e.a), str(e.b), 2.4); sc._snd(str(e.get("snd", "chest")))
			"p_sign":
				sc._banner_set(T(sign_def(sim.ci()).get("n")), "+" + MD.fmt(e.amt), 2.2)
				for i in 6: sc._coin(sc.w2s(e.pos), Vector2(FW - 70, sc.top_pad + 68), 0.5 + i * 0.07, float(e.amt) / 6.0)
				sc._snd("chest")
			"p_sign_tier":
				var nm = [S("t1", "銅牌", "銅牌"), S("t2", "銀牌", "銀牌"), S("t3", "金牌", "金牌")][clampi(int(e.tier) - 1, 0, 2)]
				var fx = [S("t1b", "解鎖 Boss 弱點", "解鎖 Boss 弱點"), S("t2b", "招牌用料賣多一成", "招牌用料售價 +10%"), S("t3b", "大單兩張、獎勵 ×1.5", "大單兩張、獎勵 ×1.5")][clampi(int(e.tier) - 1, 0, 2)]
				sc._banner_set(S("sign_t", "招牌菜%s", "招牌菜%s") % nm, fx, 3.0); sc._snd("levelUp")
			"p_help_end": sc._float(sim.st_pos(str(e.sid)) + Vector2(0, -110), S("help_end", "借嚟嘅領班返咗去", "借來的領班回去了"), Color("#e8dcc4"), 15, 1.6)
			"p_rate_end": sc._float(sc.s2w(Vector2(195, sc.top_pad + 200)), S("rate_end", "匯率返正常", "匯率回復正常"), Color("#f3e6c8"), 16, 1.6)
			"p_rate_after": sc._banner_set(S("rate_after_a", "囤得啱！", "囤得對！"), S("rate_after_b", "匯率反彈 ×%.1f" , "匯率反彈 ×%.1f") % EV.RATE_AFTER, 2.2)
	CU.eat(self, sc)
	EV.eat(self, sc)

# ================= 畫面：世界（夜色、記認、要決定嘅掣、羈絆頭牌） =================
func draw_world(sc, ctx, vy0: float, vy1: float) -> void:
	_sc = sc
	var sim = sc.sim
	_wbtn.clear()
	var tn = tide(sim)
	if tn[0]:   # 夜潮：暗紫紅
		var a = 0.24 * clampf(minf(TIDE_NIGHT - float(tn[1]), float(tn[1])) / 4.0, 0.0, 1.0)
		ctx.fillStyle = "rgba(46,4,34,%.3f)" % a; ctx.fillRect(0, vy0, FW, vy1 - vy0)
	# 羈絆頭牌
	for w in sim.workers:
		if w.pos.y < vy0 or w.pos.y - 100.0 > vy1: continue
		var b = bond(sim, str(w.sid)).get(str(w.gid))
		if not (b is Dictionary) or b.tags.is_empty(): continue
		var tg = ""; var col = Color("#bff0a0")
		if "clash" in b.tags: tg = S("tag_clash", "嘈", "吵"); col = Color("#ff8a7a")
		elif "bad" in b.tags or "night" in b.tags: tg = S("tag_bad", "攰", "累"); col = Color("#ffb0a0")
		elif "pair" in b.tags: tg = "♥"; col = Color("#ff9ac0")
		elif "fit" in b.tags: tg = S("tag_fit", "合", "合"); col = Color("#ffd27a")
		sc._txt(ctx, tg, w.pos.x - 16.0, w.pos.y - 70.0, 14, col, "center", 900, 3)
	CU.draw_world(self, sc, ctx, vy0, vy1)
	EV.draw_world(self, sc, ctx, vy0, vy1)

# 客人要貨氣泡上面嘅脾氣牌（mv_scene._draw_want 尾叫）
func draw_tag(sc, ctx, c: Dictionary, x: float, y: float, w: float, _h: float) -> void: CU.draw_tag(self, sc, ctx, c, x, y, w)

# ================= 畫面：左下小卡＋彈出卡 =================
func _chip(sc, ctx, y: float, txt: String, col: String, key: String, pulse := false, w := 168.0) -> float:
	var h = 34.0; var x = 8.0
	var sz = 1.0 + (0.03 * sin(sc.t * 6.0) if pulse else 0.0)
	Art.rr(ctx, x, y, w * sz, h, 9, "rgba(14,8,18,.82)", col, 1.6)
	var tx = txt
	ctx.font = "900 15px sans-serif"
	while tx.length() > 3 and ctx.measureText(tx).width > w - 16.0: tx = tx.substr(0, tx.length() - 2) + "…"
	sc._txt(ctx, tx, x + 10.0, y + h / 2.0, 15, Color(col), "left", 900, 0)
	if key != "": _btn[key] = Rect2(x, y, w, h)
	return y - h - 6.0
func draw_hud(sc, ctx) -> void:
	_sc = sc
	_btn.clear()
	var sim = sc.sim
	if sc.anim != null or sc.card != null: return
	var hide = sc.sheet != null and sc.sheet.visible or sc.picker != null
	if not hide:
		var y = sc.top_pad + sc.view_h() - 8.0 - 34.0
		var tn = tide(sim)
		y = _chip(sc, ctx, y, (S("chip_night", "夜潮 %s", "夜潮 %s") if tn[0] else S("chip_day", "白晝 %s 後入夜", "白晝 %s 後入夜")) % sc._mmss(float(tn[1])), "#d8b0ff" if tn[0] else "#e8dcc4", "")
		var od = ps(sim).orders
		for i in od.size():
			var o = od[i]
			y = _chip(sc, ctx, y, S("chip_ord", "大單 %s %s", "大單 %s %s") % [EV.prog_txt(self, sim, o), sc._mmss(J.num(o.left))], "#ffd27a" if EV.can_finish(self, sim, o) else "#f2a080", "ord:%d" % i, EV.can_finish(self, sim, o))
		var sd = sign_def(sim.ci())
		if not sd.is_empty() and _sign_seen(sim):
			var tier = sign_tier(sim, sim.ci())
			y = _chip(sc, ctx, y, S("chip_sign", "招牌 %s%d份", "招牌 %s%d份") % ["★".repeat(tier), sign_n(sim, sim.ci())], "#9fe39a" if sign_ok(sim) else "#c8b898", "sign", sign_ok(sim))
		if live.rate is Dictionary:
			var r = float(live.rate.mul)
			y = _chip(sc, ctx, y, S("chip_rate", "匯率 ×%.2f %s", "匯率 ×%.2f %s") % [r, sc._mmss(float(live.rate.left))], "#9fe39a" if r >= 1.0 else "#ff8a7a", "")
		if float(live.hold) > 0.0:
			y = _chip(sc, ctx, y, S("chip_hold", "囤貨中 %s", "囤貨中 %s") % sc._mmss(float(live.hold)), "#9fd8ff", "")
		EV.draw_hud(self, sc, ctx, y)
	if card != null: _draw_card(sc, ctx)
func _sign_seen(sim) -> bool:   # 招牌菜用料最少有一樣開咗先出卡
	for g in sign_def(sim.ci()).get("parts", {}): if sim.unlocked(sim.sid_of(str(g))): return true
	return false

func _draw_card(sc, ctx) -> void:
	var sim = sc.sim
	ctx.fillStyle = "rgba(0,0,0,.55)"; ctx.fillRect(0, sc.top_pad, FW, sc.view_h())
	var x = 24.0; var w = FW - 48.0; var y = sc.top_pad + 196.0   # 避開右上「生產鏈」掣
	var rows = []   # [文字, 顏色, 大細]
	var btns = []   # [key, 文字, 底色]
	var title = ""
	if card.k == "order":
		var od = ps(sim).orders
		if int(card.i) >= od.size(): card = null; return
		var o = od[int(card.i)]
		title = S("ord_t", "%s 落大單", "%s 下大單") % EV.who_name(o)
		rows.append([T(o.get("line", ["", ""])), "#2b1d12", 15])
		for g in o.need:
			var nm = M.name(str(g)) if M.has_def(str(g)) else T(MD.good_def(str(g)).get("n"))
			var st = int(J.num((o.get("star", {}) as Dictionary).get(g)))
			var stx = (" ★%d" % st) if st > 0 else ""
			var ok_st = st <= 0 or MD.stars(sim.sid_of(str(g)), sim.lv(sim.sid_of(str(g)))) >= st
			rows.append(["%s%s　%d／%d　（%s %d）" % [nm, stx, int(J.num(o.got.get(g))), int(J.num(o.need[g])), S("have", "有", "有"), int(have(sim, str(g)))], "#3d7a3a" if ok_st else "#9c2219", 15])
			if not ok_st: rows.append([S("ord_star", "要先升到 ★%d 先交得", "要先升到 ★%d 才能交") % st, "#9c2219", 14])
		rows.append([S("ord_rw", "獎勵：%s 冥幣＋%s", "獎勵：%s 冥幣＋%s") % [MD.fmt(EV.order_coins(self, sim, o)), EV.rw_name(str(o.rw))], "#9c2219", 15])
		rows.append([S("ord_left", "限時 %s（過咗影響力 −%d）", "限時 %s（過時影響力 −%d）") % [sc._mmss(J.num(o.left)), int(EV.ORD_FAIL_INF)], "#5e4a30", 14])
		btns = [["give", S("give", "撥貨", "撥貨"), "#3d7a3a"], ["drop", S("drop", "推咗佢", "推掉"), "#7a5a3a"], ["close", S("close", "關", "關"), "#5e4a30"]]
	else:
		var sd = sign_def(sim.ci())
		title = S("sign_title", "招牌菜：%s", "招牌菜：%s") % T(sd.get("n"))
		for g in sd.get("parts", {}):
			var ok = have(sim, str(g)) >= float(sd.parts[g])
			rows.append(["%s ×%d　（%s %d）" % [M.name(str(g)) if M.has_def(str(g)) else str(g), int(sd.parts[g]), S("have", "有", "有"), int(have(sim, str(g)))], "#3d7a3a" if ok else "#9c2219", 15])
		rows.append([S("sign_v", "出一份收 %s 冥幣（用料價 ×%.1f%s）", "出一份收 %s 冥幣（用料價 ×%.1f%s）") % [MD.fmt(sign_value(sim)), SIGN_MUL, S("sign_vn", "，夜潮再 ×1.3", "，夜潮再 ×1.3") if is_night(sim) else ""], "#9c2219", 15])
		var tn = sign_tier(sim, sim.ci()); var nx = SIGN_TIERS[mini(tn, 2)]
		rows.append([S("sign_n", "已出 %d 份；%s", "已出 %d 份；%s") % [sign_n(sim, sim.ci()), (S("sign_nx", "出夠 %d 份升%s", "出滿 %d 份升%s") % [nx, [S("t1", "銅牌", "銅牌"), S("t2", "銀牌", "銀牌"), S("t3", "金牌", "金牌")][mini(tn, 2)]]) if tn < 3 else S("sign_max", "金牌招牌！", "金牌招牌！")], "#5e4a30", 14])
		rows.append([S("sign_w", "銅牌：Boss 弱點——%s", "銅牌：Boss 弱點——%s") % T(sd.get("weak")), "#3d7a3a" if tn >= 1 else "#5e4a30", 14])
		rows.append([S("sign_tip", "用料由櫃台同材料庫扣（分流揀「全部入倉」可以儲料）", "用料從櫃台和材料庫扣（分流選「全部入倉」可以存料）"), "#5e4a30", 14])
		btns = [["make", S("make", "出招牌", "出招牌"), "#3d7a3a" if sign_ok(sim) else "#8a8070"], ["close", S("close", "關", "關"), "#5e4a30"]]
	# 量高度
	ctx.font = "700 15px sans-serif"
	var lines = []
	for r in rows:
		for l in sc._wrap(ctx, str(r[0]), w - 28.0): lines.append([l, r[1], r[2]])
	var h = 56.0 + lines.size() * 22.0 + 66.0
	Art.rr(ctx, x, y, w, h, 14, "rgba(250,244,228,.98)", "#b89a52", 3)
	sc._txt(ctx, title, x + w / 2.0, y + 26.0, 19, Color("#2b1d12"), "center", 900, 0, "serif")
	var yy = y + 54.0
	for l in lines:
		sc._txt(ctx, str(l[0]), x + 14.0, yy + 9.0, int(l[2]), Color(str(l[1])), "left", 800, 0); yy += 22.0
	var bw = (w - 28.0 - (btns.size() - 1) * 8.0) / btns.size(); var bx = x + 14.0; var by = y + h - 56.0
	for b in btns:
		Art.rr(ctx, bx, by, bw, 44, 10, str(b[2]), "#f2e2c0", 2)
		sc._txt(ctx, str(b[1]), bx + bw / 2.0, by + 22.0, 17, Color("#fff3e0"), "center", 900, 0)
		_btn["card:" + str(b[0])] = Rect2(bx, by, bw, 44)
		bx += bw + 8.0

# ================= 撳（mv_scene.tap：war.tap 之前叫；p = 畫面座標） =================
func tap(sc, p: Vector2) -> bool:
	_sc = sc
	var sim = sc.sim
	if card != null:
		for k in _btn.keys():
			if not k.begins_with("card:") or not _btn[k].has_point(p): continue
			var a = k.substr(5)
			match a:
				"close": card = null
				"give":
					var r = EV.give(self, sim, int(card.i))
					if r == "done": card = null
					elif r == "none": sim.ev.append({"k": "p_float", "pos": sc.s2w(p + Vector2(0, -40)), "txt": S("give_none", "冇貨可以撥", "沒貨可撥"), "col": "#ffb0a0"})
				"drop": EV.drop(self, sim, int(card.i)); card = null
				"make":
					if make_sign(sim) <= 0.0: sim.ev.append({"k": "p_float", "pos": sc.s2w(p + Vector2(0, -40)), "txt": S("sign_no", "用料未夠", "用料不夠"), "col": "#ffb0a0"})
			sc._snd("click")
			return true
		card = null; return true   # 撳卡外面：關卡
	for k in _btn.keys():
		if not _btn[k].grow(2).has_point(p): continue
		if k.begins_with("ord:"): card = {"k": "order", "i": int(k.substr(4))}; sc._snd("click"); return true
		if k == "sign": card = {"k": "sign"}; sc._snd("click"); return true
		if EV.tap_hud(self, sim, k): sc._snd("click"); return true
	if EV.tap_screen(self, sc, p): return true
	if p.y < sc.top_pad + 90.0: return false
	var wp = sc.s2w(p)
	for key in _wbtn.keys():
		var e = _wbtn[key]
		if (e[0] as Rect2).grow(4).has_point(wp):
			if CU.tap_btn(self, sim, key, e[1]) or EV.tap_btn(self, sim, key, e[1]): sc._snd("click"); return true
	if CU.tap_world(self, sim, wp): sc._snd("click"); return true
	return false

# ================= 資料卡（升級條）：夥計羈絆一行 =================
func sheet_rows(sc, sid: String) -> void:
	var sim = sc.sim
	var sd = st_d(sid)
	var fit = []
	for k in sd.get("fit", []): fit.append(kname(str(k)))
	var bs = bond(sim, sid)
	var parts = []
	for gid in bs:
		var b = bs[gid]
		var nm = J.str(J.gp(sim.ghost(gid), "name"))
		var tg = []
		for t0 in b.tags: tg.append(T(D().BOND_LINES.get(t0, ["", ""])))
		parts.append("%s ×%.2f%s" % [nm, float(b.mul), ("（" + "、".join(tg) + "）") if tg.size() else ""])
	var tx = S("sh_bond", "夥計：%s", "夥計：%s") % ("；".join(parts) if parts.size() else S("sh_none", "未派", "未派"))
	if fit.size(): tx += "　" + S("sh_fit", "啱手：%s", "上手：%s") % "、".join(fit)
	sc.sheet_box.add_child(sc._wl(tx, 14, Color("#3d5a2a")))
	var h = ps(sim).get("help")
	if h is Dictionary and str(h.get("sid")) == sid:
		sc.sheet_box.add_child(sc._wl(S("sh_help", "借咗領班：做貨 ×%.1f、自動收錢，仲有 %s", "借了領班：製作 ×%.1f、自動收錢，還有 %s") % [HELP_MUL, sc._mmss(J.num(h.left))], 14, Color("#9c2219")))
