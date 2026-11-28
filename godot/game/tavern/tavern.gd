# [tavern] 陰間酒館：普通鬼名單（定時刷新＋付冥幣手動刷新）、招募、派工餵夜宵（唔餵會肚餓→罷工）。
# 冇 class_name、冇 autoload（熱更新規矩）：用 load("res://game/tavern/tavern.gd") 叫 static func。
#
# 狀態 S.tav = {v, list:[gen…], next(ms 下次自動刷新), man(自上次自動刷新後手動刷新次數), dry(幾多次刷新冇出眾，保底用),
#               first(1＝已出過首次保底), seed, hunger:{ghost_id: 0 飽／1 肚餓／2 罷工}, fed(ms 上次開餐), named:{id:1 已招}, stall(1＝大排檔已開，可由 vil2 設)}
# 規則：
#  - 名單 SLOTS 格；每 REFRESH_S 秒（跟 TIME_SCALE）自動換一批；手動刷新收冥幣 base+step×次數（封頂 max），自動刷新後重計。
#  - 稀有度：普通／好／出眾（RAR.p）；每格另有 RAR.named 機率出 15 隻有名字稀有鬼（未招過、未喺名單先出）。
#  - 保底：第一次刷新必有一隻「好」以上；連續 RAR.pity 次刷新冇「出眾」→ 下一次必出一隻。
#  - 招募：收冥幣（按稀有度）、佔雜鬼名額（roster_cap）；招到嘅鬼記錄 gen（外觀、名、台詞固定）。
#  - 夜宵：每 FEED_S 秒（遊戲時間，一更）一餐：每隻「有崗位」嘅酒館鬼食 FEED_BAO 個普通包子（m_bao）。
#    冇得食：第一餐肚餓（產量 ×0.5），再冇得食罷工（產量 0）；有包子即刻復工。舊鬼（冇 gen）唔使食。
#  - 大排檔開咗之前化寶爐係冥幣來源（見 joss.gd early()）。
extends RefCounted

const GEN := preload("res://game/tavern/tv_gen.gd")
const M := preload("res://game/outpost/mat.gd")
const ON := true   # 總開關（合入 vil2 前可關）

static var now_override := -1.0
static var rng := RandomNumberGenerator.new()

static func D() -> Dictionary: return GEN.D()
static func yue() -> bool: return DB.lang == "yue"
static func T(y: String, z: String) -> String: return y if yue() else z
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func now() -> float: return now_override if now_override > 0 else Time.get_unix_time_from_system() * 1000.0
static func tscale() -> float:
	var t = J.num(J.G.get("TIME_SCALE")) if J.G.get("TIME_SCALE") != null else 1.0
	return t if t > 0 else 1.0
static func on() -> bool: return ON and S() != null

static func st():
	var s = S()
	if s == null: return null
	if not (s.get("tav") is Dictionary):
		rng.randomize()
		s["tav"] = {"v": 1, "list": [], "next": 0.0, "man": 0, "dry": 0, "first": 0, "seed": rng.randi(), "hunger": {}, "fed": 0.0, "named": {}, "stall": 0}
	var t = s.tav
	for k in ["list"]: if not (t.get(k) is Array): t[k] = []
	for k in ["hunger", "named"]: if not (t.get(k) is Dictionary): t[k] = {}
	return t

# ================= 大排檔開咗未（化寶爐轉模式用）=================
static func stall_open() -> bool:
	var f = J.G.get("stall_open_fn")   # vil2：KPI 達標開大排檔時可以掛自己嘅判斷
	if f is Callable: return bool(f.call())
	var t = st()
	if t != null and J.num(t.get("stall", 0)) > 0: return true
	var ob = load("res://game/onboard/ob.gd")
	return ob.stage() >= 5 if S() != null else false

# ================= 名單 =================
static func _next_seed() -> int:
	var t = st(); t["seed"] = (int(J.num(t.seed)) * 1103515245 + 12345) & 0x7fffffff
	return int(t.seed)
static func _owned_named() -> Dictionary:
	var o = {}
	var s = S()
	if s == null: return o
	for g in s.ghosts:
		if g.get("gen") is Dictionary and g.gen.get("named") != null: o[str(g.gen.named)] = true
	return o
static func avoid_of(list: Array) -> Dictionary:
	var names = {}; var cps = {}
	var s = S()
	if s != null:
		for g in s.ghosts: names[str(g.get("name", ""))] = true
	for x in list: names[str(x.name)] = true; cps[int(x.cp)] = true
	return {"names": names, "cps": cps}

static func refresh(manual := false) -> Array:
	var t = st()
	if t == null: return []
	var R = D().RAR; var n = int(D().SLOTS)
	var list = []
	var has_top = false
	var owned = _owned_named()
	var r = RandomNumberGenerator.new(); r.seed = _next_seed()
	for i in n:
		var g: Dictionary
		var named_ok = []
		for x in D().get("NAMED", []):
			if not owned.has(str(x.id)) and not J.t(t.named.get(str(x.id))):
				var dup = false
				for y in list: if str(y.get("named", "")) == str(x.id): dup = true
				if not dup: named_ok.append(str(x.id))
		if named_ok.size() and r.randf() < float(R.named):
			g = GEN.named(named_ok[r.randi_range(0, named_ok.size() - 1)], _next_seed())
		else:
			g = GEN.gen(_next_seed(), -1, avoid_of(list))
		if int(g.rar) >= 2: has_top = true
		list.append(g)
	# 保底
	if J.num(t.first) <= 0:
		t["first"] = 1
		var best = 0
		for x in list: best = maxi(best, int(x.rar))
		if best < 1: list[0] = GEN.gen(_next_seed(), 1, avoid_of(list.slice(1)))
	if has_top: t["dry"] = 0
	else:
		t["dry"] = int(J.num(t.dry)) + 1
		if int(t.dry) >= int(R.pity):
			list[list.size() - 1] = GEN.gen(_next_seed(), 2, avoid_of(list.slice(0, list.size() - 1))); t["dry"] = 0
	# 同一畫面口頭禪唔重複（名鬼／保底替換嗰格都要過一次）：撞就揀下一個未用
	var used = {}; var ncp = D().CP.size()
	for g in list:
		var c = int(g.cp)
		var k = 0
		while used.has(c) and k < ncp: c = (c + 1) % ncp; k += 1
		g["cp"] = c; used[c] = true
	t["list"] = list
	if not manual:
		t["man"] = 0
		t["next"] = now() + float(D().REFRESH_S) * 1000.0 / tscale()
	return list

static func tick_list() -> void:
	var t = st()
	if t == null: return
	if t.list.is_empty() or now() >= J.num(t.next): refresh(false)
static func next_left_s() -> float:
	var t = st()
	return maxf(0.0, (J.num(t.next) - now()) / 1000.0) if t != null else 0.0
static func manual_cost() -> float:
	var t = st(); var m = D().MANUAL
	return minf(float(m.max), float(m.base) + float(m.step) * J.num(t.man if t != null else 0))
static func manual_refresh() -> Dictionary:
	var t = st(); var s = S()
	if t == null: return {"ok": false}
	var c = manual_cost()
	if J.num(s.res.get("coins", 0)) < c: return {"ok": false, "why": "coins", "need": c}
	s.res["coins"] = J.num(s.res.coins) - c
	t["man"] = int(J.num(t.man)) + 1
	refresh(true)
	return {"ok": true, "cost": c}

# ================= 招募 =================
static func cost_of(g: Dictionary) -> float:
	if g.get("named") != null: return float(D().RAR.named_cost)
	return float(D().RAR.cost[clampi(int(g.rar), 0, 2)])
static func roster_full() -> bool:
	var G = J.G
	var cnt = J.num(J.cl(G.get("fodderCount"), null, [])) if G.get("fodderCount") != null else 0.0
	var F = G.get("F")
	var cap = J.num(J.mc(F, "rosterCap", [])) if F != null else 99.0
	return cnt >= cap
static func can_recruit(i: int) -> Dictionary:
	var t = st(); var s = S()
	if t == null or i < 0 or i >= t.list.size(): return {"ok": false, "why": "none"}
	var g = t.list[i]
	if g.get("taken"): return {"ok": false, "why": "taken"}
	if roster_full(): return {"ok": false, "why": "cap"}
	var c = cost_of(g)
	if J.num(s.res.get("coins", 0)) < c: return {"ok": false, "why": "coins", "need": c, "have": J.num(s.res.get("coins", 0))}
	return {"ok": true, "cost": c}
static func recruit(i: int) -> Dictionary:
	var ck = can_recruit(i)
	if not ck.ok: return ck
	var t = st(); var s = S(); var g = t.list[i]
	s.res["coins"] = J.num(s.res.coins) - float(ck.cost)
	var uid = J.num(s.get("uid", 1)); s["uid"] = uid + 1
	var gen = g.duplicate(true)
	var rec = {"id": "g" + J.str(uid), "k": str(g.k), "name": str(g.name), "q": str(D().RAR.q[clampi(int(g.rar), 0, 2)]), "lv": 1.0, "st": g.st.duplicate(), "post": null, "spent": 0.0, "gen": gen}
	s.ghosts.append(rec)
	g["taken"] = true
	if g.get("named") != null: t.named[str(g.named)] = 1
	if s.get("cnt") is Dictionary: s.cnt["recruit"] = J.num(s.cnt.get("recruit", 0)) + 1
	return {"ok": true, "g": rec, "line": GEN.line(gen, "sign"), "cost": ck.cost}

# ================= 夜宵／罷工 =================
static func eaters() -> Array:
	var s = S(); var o = []
	if s == null: return o
	for g in s.ghosts:
		if g.get("gen") is Dictionary and J.t(g.get("post")): o.append(g)
	return o
static func hunger_of(g) -> int:
	var t = st()
	if t == null or not (g is Dictionary): return 0
	return int(J.num(t.hunger.get(str(g.get("id")), 0)))
static func work_mul(g) -> float:   # rates_per_min 用：飽 1、肚餓 0.5、罷工 0
	if not ON or not (g is Dictionary) or not (g.get("gen") is Dictionary): return 1.0
	match hunger_of(g):
		1: return 0.5
		2: return 0.0
	return 1.0
static func meal_cost() -> float: return float(eaters().size()) * float(D().FEED_BAO)
static func per_hour_bao() -> float: return meal_cost() * 3600.0 / float(D().FEED_S)
# 開一餐：有包子就食（餓／罷工即刻復工），冇就加一級肚餓。回 {ate, hungry:[名], strike:[名]}
static func meal() -> Dictionary:
	var t = st(); var out = {"ate": 0, "hungry": [], "strike": []}
	if t == null: return out
	var need = float(D().FEED_BAO)
	for g in eaters():
		var id = str(g.id)
		if M.amt("m_bao") >= need:
			M.add("m_bao", -need); t.hunger.erase(id); out.ate += 1
		else:
			var h = mini(2, hunger_of(g) + 1); t.hunger[id] = h
			(out.strike if h >= 2 else out.hungry).append(str(g.name))
	return out
# 玩家撳「派夜宵」：只餵肚餓／罷工嗰啲（唔重計更）
static func feed_now() -> Dictionary:
	var t = st(); var out = {"fed": 0, "left": 0}
	if t == null: return out
	var need = float(D().FEED_BAO)
	for g in eaters():
		if hunger_of(g) <= 0: continue
		if M.amt("m_bao") >= need: M.add("m_bao", -need); t.hunger.erase(str(g.id)); out.fed += 1
		else: out.left += 1
	return out
# produce(dt) 每格叫：夠一更就開餐，出提示
static var _acc := 0.0
static func tick(dt: float) -> void:
	if not on(): return
	var t = st()
	_acc += dt
	var fs = float(D().FEED_S)
	var n = 0
	while _acc >= fs and n < 6:
		_acc -= fs; n += 1
		var r = meal()
		if r.strike.size(): _toast(T("【罷工】%s：今晚唔做喇，除非有包子！", "【罷工】%s：今晚不幹了，除非有包子！") % "、".join(r.strike))
		elif r.hungry.size(): _toast(T("%s 肚餓，產量減半——普通包子唔夠夜宵", "%s 肚子餓，產量減半——普通包子不夠當宵夜") % "、".join(r.hungry))
	# 有包子就自動幫罷工／肚餓嗰啲補返（唔使等下一更）
	if t != null and not t.hunger.is_empty() and M.amt("m_bao") >= float(D().FEED_BAO): feed_now()
	tick_list()
static func _toast(bb: String) -> void:
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, "toast", [bb])

static func bubble(g) -> String:   # 頭頂氣泡（村子畫鬼時可用）
	if not (g is Dictionary) or not (g.get("gen") is Dictionary): return ""
	match hunger_of(g):
		1: return GEN.line(g.gen, "hungry")
		2: return GEN.line(g.gen, "strike")
	return ""
