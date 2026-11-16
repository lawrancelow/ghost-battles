# 原生改寫自 game.js（遊戲核心：狀態、經濟、村子、介面）——分段進行
# 做法：先跑轉譯版（jsgen/game.gd）建好全部全局，再逐段換成原生版本；全部段落完成之後先唔再載轉譯版。
#   第一段（呢度）：數值公式 F、存檔 newState/save/load、經濟 ratesPerMin/produce、資源 canPay/pay/costText/give、
#                  升級 gainExp/onLevelUp、收鬼 joinGhost/recruitFodder、任務 Quest、離線收益 offlineGain、雜項（fmt、bldUnlocked…）
#   之後：Village、Story、UI、JossFx、loop/startGame 同 patches.js 嘅補丁部分
# 規矩：其他模塊會包（wrap）嘅函數（ratesPerMin、joinGhost、Quest.complete…）一律經 J.G／J.mc 叫，包裝先會生效
extends RefCounted

const FURNACE_CD := 300.0
const FEAST_CD := 1200.0
const FEAST_NEED := 350.0
static var _trans = null
static var ORIG := {}   # 覆蓋之前嘅轉譯版函數（對照測試用：tools/tests/l2_probe.gd game1）

static func _g(n: String): return J.G.get(n)
static func _S() -> Dictionary: return J.G.get("S")
static func _snd(name: String) -> void: J.mc(_g("Sound"), "play", [name])
static func _fx(m: String, a: Array) -> void: J.mc(_g("Fx"), m, a)
static func _ui_refresh() -> void: J.mc(_g("UI"), "refresh", [])
static func _rnd() -> float: return randf()

# ---------------- 雜項 ----------------
static func fmt(n) -> String:
	var x = floor(J.num(n))
	if x >= 1e6: return JStr.num_call(x / 1e6, "toFixed", [1.0]) + "M"
	if x >= 1e4: return JStr.num_call(x / 1e3, "toFixed", [1.0]) + "K"
	return J.str(x)

static func new_state() -> Dictionary:
	return {
		"v": 1.0, "lv": 1.0, "exp": 0.0,
		"res": {"wood": 0.0, "rice": 0.0, "planks": 0.0, "buns": 0.0, "coins": 0.0, "troops": 0.0},
		"bld": {"house": 1.0, "wood": 1.0, "rice": 1.0, "plank": 0.0, "bun": 0.0, "store": 0.0, "home": 0.0, "camp": 0.0, "altar": 0.0, "furnace": 0.0},
		"ghosts": [{"id": "afu", "k": "afu", "name": "阿福", "q": "主", "lv": 1.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0}],
		"team": ["afu", null, null], "adviser": null,
		"cleared": {}, "qi": 0.0, "cnt": {"chop": 0.0, "rice": 0.0, "craftPlank": 0.0, "craftBun": 0.0, "recruit": 0.0, "feast": 0.0, "chest": 0.0},
		"seen": {}, "chests": {"g": 0.0, "b": 0.0, "p": 0.0}, "furnaceAt": 0.0, "feastAt": 0.0, "last": J.now(), "ended": false,
		"trees": [3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0], "treeRegrow": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], "paddy": [1.0, 1.0, 1.0, 1.0, 1.0, 1.0], "paddyRegrow": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		"uid": 1.0, "prod": {},
	}

static func save() -> void:
	var S = _g("S")
	if not (S is Dictionary) or J.t(J.gp(_g("window"), "__NOSAVE")): return
	S["last"] = J.now()
	var key = J.str(_g("SAVE_KEY"))
	var prev = J.S_localStorage_("getItem", [key])
	if J.t(prev):
		var pv = JSON.parse_string(J.str(prev))
		if pv is Dictionary and (J.num(pv.get("lv")) if J.t(pv.get("lv")) else 1.0) > (J.num(S.get("lv")) if J.t(S.get("lv")) else 1.0) + 2:
			J.S_localStorage_("setItem", [key + "_hi", prev])
	J.S_localStorage_("setItem", [key, J.to_json(S)])

static func load_() :
	var j = J.S_localStorage_("getItem", [J.str(_g("SAVE_KEY"))])
	if J.t(j):
		var v = JSON.parse_string(J.str(j))
		if v != null: return v
	return null

# ---------------- 數值公式 ----------------
static func exp_need(lv: float) -> float: return J.round(30 * pow(lv, 1.75))
static func ghost_cap() -> float:
	var lv = J.num(_S().lv)
	return 40.0 if lv >= 15 else (30.0 if lv >= 7 else 20.0)
static func glv(g) -> float: return minf(ghost_cap(), J.num(_S().lv) * 2) if J.str(g.k) == "afu" else J.num(g.lv)
static func stat(g, i) -> float: return J.round(J.num(g.st[int(J.num(i))]) * (1 + 0.06 * (glv(g) - 1)))
static func lv_cost(lv: float) -> float: return floor(6 * pow(lv, 1.5)) + 4
static func bld_max(id) -> float: return 20.0 if J.str(id) == "house" else J.num(_S().bld.house)
static func builder_discount() -> float:
	var ws = workers_at("boss")
	return minf(0.35, glv(ws[0]) * 0.012) if ws.size() > 0 else 0.0
static func up_cost(id, lv: float) -> Dictionary:
	var k = 1.1 if J.str(id) == "house" else 0.9
	var planks = J.round(25 * pow(lv, 1.72) * k); var coins = J.round(28 * pow(lv, 1.8) * k)
	planks = J.round(planks * (1 - builder_discount()))
	return {"planks": planks, "coins": coins}
static func slots(post) -> float:
	var p = _g("POSTS")[J.str(post)]; var lv = J.num(_S().bld.get(J.str(p.bld)))
	if lv == 0: return 0.0
	if J.str(post) == "boss": return 1.0
	return minf(4, 1 + floor((lv - 1) / 3))
static func mult(bid) -> float: return 1 + 0.3 * (J.num(_S().bld[J.str(bid)]) - 1)
static func cap() -> float:
	var S = _S(); var st = J.num(S.bld.store)
	var c = 400 + (400 * pow(st, 1.5) if st != 0 else 0.0) + (600.0 if J.num(S.lv) >= 9 else 0.0)
	var ws = workers_at("store")
	if ws.size() > 0: c *= 1 + stat(ws[0], 2) / 100
	return J.round(c)
static func troop_cap() -> float: var S = _S(); return 150 + 150 * J.num(S.bld.home) + 50 * J.num(S.bld.camp)
static func roster_cap() -> float: return 5 + 2 * J.num(_S().bld.home)
static func walk() -> float:
	var GS = _g("GhostStreet")
	return (150.0 if J.num(_S().lv) >= 5 else 95.0) * (J.num(J.mc(GS, "mul", ["walk"])) if GS != null else 1.0)
static func chop_time() -> float: return 0.42 if J.num(_S().lv) >= 2 else 0.7
static func furnace_coins() -> float: var S = _S(); return 30 + 15 * J.num(S.bld.furnace) + 6 * J.num(S.lv)
static func chest_gain(c) -> Dictionary:
	var S = _S()
	if J.str(c) == "g": return {"buns": 40 + 30 * J.num(S.bld.bun)}
	if J.str(c) == "b": return {"planks": 30 + 25 * J.num(S.bld.plank)}
	return {"coins": 120 + 60 * J.num(S.bld.house)}

static func fodder_count() -> float:
	var n = 0
	for g in _S().ghosts: if J.str(g.q) == "藍" or J.str(g.q) == "紫": n += 1
	return float(n)
static func workers_at(post) -> Array:
	var o = []; var p = J.str(post)
	for g in _S().ghosts: if g.get("post") != null and J.str(g.post) == p: o.append(g)
	return o
static func ghost_by_id(id):
	for g in _S().ghosts:   # JS 嘅 === ：型別唔同就唔等（GDScript 直接比 String 同 float 會報錯）
		var gi = g.get("id")
		if typeof(gi) == typeof(id) and gi == id: return g
	return null
static func gdef(g):
	var GH = _g("GHOSTS"); var k = J.str(g.k)
	return GH[k] if GH.get(k) != null else _g("FODDER").get(k)

# ---------------- 經濟 ----------------
static func rates_per_min() -> Dictionary:
	var S = _S()
	var r = {"wood": 0.0, "rice": 0.0, "planks": 0.0, "buns": 0.0, "troops": 0.0, "coins": 0.0, "woodUse": 0.0, "riceUse": 0.0, "bunUse": 0.0, "exp": 0.0}
	for g in S.ghosts:
		if not J.t(g.get("post")): continue
		var lv = glv(g)
		match J.str(g.post):
			"wood": r.wood += (9 + 0.7 * lv) * mult("wood")
			"rice": r.rice += (9 + 0.7 * lv) * mult("rice")
			"plank": var o = (2.5 + stat(g, 0) * 0.05) * mult("plank"); r.planks += o; r.woodUse += o * 2
			"bun": var o = (2.5 + stat(g, 1) * 0.05) * mult("bun"); r.buns += o; r.riceUse += o * 2
			"camp":   # 嚇人訓練班：練嚇功（rework）
				var o = (2 + stat(g, 2) * 0.04) * mult("camp")
				r["drill"] = J.num(r.get("drill")) + o; r.bunUse += o * 0.6
				if not r.has("drillBy"): r["drillBy"] = []
				r.drillBy.append([g.k, o])
			"store": if J.str(g.k) == "toyol": r.coins += 2 + lv * 0.25
		r.exp += 0.6
	if J.t(S.bld.get("home")): r.troops += 1.2 + 1.3 * J.num(S.bld.home)   # 村裡的遊魂自願當陰兵（民宅）
	return r

# 推進 dt 秒的產出（含加工鏈，原料不足時按比例）；ratesPerMin 經 J.G 叫（rivals 會包）
static func produce(dt: float) -> void:
	var S = _S(); var r = J.cl(_g("ratesPerMin"), null, []); var m = dt / 60; var cp = cap(); var R = S.res
	var rg = func(k): return J.num(J.gp(r, k))
	if J.num(R.wood) < cp: R["wood"] = minf(cp, J.num(R.wood) + rg.call("wood") * m)
	if J.num(R.rice) < cp: R["rice"] = minf(cp, J.num(R.rice) + rg.call("rice") * m)
	if rg.call("planks") != 0 and J.num(R.planks) < cp:
		var need = rg.call("woodUse") * m; var k = minf(1, J.num(R.wood) / need) if need > 0 else 0.0
		R["wood"] = J.num(R.wood) - need * k; R["planks"] = minf(cp, J.num(R.planks) + rg.call("planks") * m * k)
	if rg.call("buns") != 0 and J.num(R.buns) < cp:
		var need = rg.call("riceUse") * m; var k = minf(1, J.num(R.rice) / need) if need > 0 else 0.0
		R["rice"] = J.num(R.rice) - need * k; R["buns"] = minf(cp, J.num(R.buns) + rg.call("buns") * m * k)
	if rg.call("troops") != 0 and J.num(R.troops) < troop_cap(): R["troops"] = minf(troop_cap(), J.num(R.troops) + rg.call("troops") * m)
	var by = J.gp(r, "drillBy")
	if J.t(by):
		var need = rg.call("bunUse") * m; var k = minf(1, J.num(R.buns) / need) if need > 0 else 0.0
		R["buns"] = J.num(R.buns) - need * k
		if not J.t(S.get("drill")): S["drill"] = {}
		for e in J.iter(by):
			var gk = J.str(e[0]); S.drill[gk] = J.num(S.drill.get(gk)) + J.num(e[1]) * m * k
	R["coins"] = J.num(R.coins) + rg.call("coins") * m
	var acc = J.num(_g("expAcc")) + rg.call("exp") * m
	J.G["expAcc"] = acc
	if acc >= 1:
		var e = floor(acc); J.G["expAcc"] = acc - e; gain_exp(e, true)

# ---------------- 資源操作 ----------------
static func can_pay(c) -> bool:
	var R = _S().res
	for k in J.keys(c): if J.num(R.get(k)) < J.num(J.gp(c, k)) - 1e-6: return false
	return true
static func pay(c) -> void:
	var R = _S().res
	for k in J.keys(c): R[k] = J.num(R.get(k)) - J.num(J.gp(c, k))
static func cost_text(c) -> String:
	var R = _S().res; var RN = _g("RES_NAMES"); var o = []
	for k in J.keys(c):
		var v = J.gp(c, k)
		if not J.t(v): continue
		o.append("<span class=\"%s\">%s %s</span>" % ["" if J.num(R.get(k)) >= J.num(v) else "lack", J.str(RN.get(k)), fmt(v)])
	return "　".join(o)
static func give(r, _src = null) -> String:
	var S = _S(); var parts = []; var RN = _g("RES_NAMES")
	for k in J.keys(r):
		var v = J.gp(r, k)
		if k == "exp": gain_exp(J.num(v)); parts.append("好評 +%s" % J.str(v))
		elif k == "chest":
			var ck = J.str(v); S.chests[ck] = J.num(S.chests.get(ck)) + 1
			parts.append({"g": "綠箱", "b": "藍箱", "p": "紫箱"}.get(ck, "undefined") + " ×1")
		else: S.res[k] = J.num(S.res.get(k)) + J.num(v); parts.append("%s +%s" % [J.str(RN.get(k)), fmt(v)])
	return "，".join(parts)
static func gain_exp(n: float, _silent = false) -> void:
	var S = _S(); S["exp"] = J.num(S.exp) + n; var up = false
	while J.num(S.lv) < 20 and J.num(S.exp) >= exp_need(J.num(S.lv)):
		S["exp"] = J.num(S.exp) - exp_need(J.num(S.lv)); S["lv"] = J.num(S.lv) + 1; up = true; on_level_up(J.num(S.lv))
	if J.num(S.lv) >= 20: S["exp"] = minf(J.num(S.exp), exp_need(20))
	if up: _ui_refresh()
static func on_level_up(lv: float) -> void:
	var S = _S(); var u = J.gp(_g("LEVEL_UNLOCKS"), lv)
	_snd("levelUp"); _fx("banner", ["升級！Lv %s" % J.str(lv) + (("　解鎖【%s】" % J.str(u.name)) if J.t(u) else "")])
	if J.t(u): J.mc(_g("Story"), "queue", [{"style": "sys", "lines": u.lines + [["旁白", "解鎖：" + J.str(u.desc)]]}])
	if lv == 4 and not J.t(S.seen.get("gift_xiaozhi")):
		J.mc(_g("Story"), "queue", ["gift_xiaozhi"])
		J.mc(_g("Story"), "queue", ["gift_xiaozhi2", func(_t, _a): J.cl(_g("joinGhost"), null, ["xiaozhi"]); return null])
static func join_ghost(k) -> void:
	var S = _S(); var ks = J.str(k)
	for g in S.ghosts: if J.str(g.k) == ks: return
	var d = _g("GHOSTS")[ks]
	var uid = J.num(S.uid); S["uid"] = uid + 1
	var g = {"id": "g" + J.str(uid), "k": ks, "name": d.name, "q": "名", "lv": maxf(1, minf(ghost_cap(), floor(J.num(S.lv) * 1.3))), "st": d.base.duplicate(), "post": null, "spent": 0.0}
	S.ghosts.append(g)
	var i = S.team.find(null)   # 自動補上空的出陣位
	if i >= 0: S.team[i] = g.id
	_snd("gong"); _fx("banner", ["【%s】加入了落魄村！" % J.str(d.name)])
	_ui_refresh()
static func recruit_fodder(rare) -> Dictionary:
	var S = _S(); var FO = _g("FODDER"); var NK = _g("NICKS")
	var pool = []
	for k in FO: if not J.t(FO[k].get("unlock")) or J.t(S.cleared.get(J.str(FO[k].unlock))): pool.append(k)
	var k = pool[int(floor(_rnd() * pool.size()))]
	var purple = J.t(rare) or _rnd() < 0.15; var m = 1.45 if purple else 1.0
	var st = []
	for _i in 3: st.append(J.round((15 + _rnd() * 32) * m))
	var used = {}
	for g in S.ghosts: used[J.str(g.name)] = true
	var name = ""
	for _i in 40:
		name = J.str(FO[k].name) + "・" + J.str(NK[int(floor(_rnd() * NK.size()))])
		if not used.has(name): break
	var uid = J.num(S.uid); S["uid"] = uid + 1
	var g = {"id": "g" + J.str(uid), "k": k, "name": name, "q": "紫" if purple else "藍", "lv": 1.0, "st": st, "post": null, "spent": 0.0}
	S.ghosts.append(g)
	return g

# ---------------- 任務 ----------------
static func q_cur():
	var Q = _g("QUESTS"); var i = int(J.num(_S().qi))
	return Q[i] if i >= 0 and i < Q.size() else null
static func q_progress(q) -> Array:
	var S = _S(); var n = J.gp(q, "n")
	match J.str(J.gp(q, "t")):
		"chop": return [S.cnt.chop, n]
		"rice": return [S.cnt.rice, n]
		"craftPlank": return [S.cnt.craftPlank, n]
		"craftBun": return [S.cnt.craftBun, n]
		"level": return [S.lv, n]
		"build": return [1.0 if J.t(S.bld.get(J.str(q.b))) else 0.0, 1.0]
		"bLevel": return [S.bld.get(J.str(q.b)), n]
		"assign":
			var c = 0
			for g in S.ghosts: if J.t(g.get("post")): c += 1
			return [float(c), n]
		"stage": return [1.0 if J.t(S.cleared.get(J.str(q.s))) else 0.0, 1.0]
		"recruit": return [S.cnt.recruit, n]
		"ghostLv":
			var m = 0.0
			for g in S.ghosts: if J.str(g.k) != "afu": m = maxf(m, J.num(g.lv))
			return [m, n]
		"troops": return [floor(J.num(S.res.troops)), n]
		"drill":
			var m = 0.0
			if J.t(S.get("drill")): for v in S.drill.values(): m = maxf(m, J.num(v))
			return [floor(minf(m, J.num(n))), n]
		"feast": return [S.cnt.feast, n]
		"visit": return [1.0 if J.t(S.get("visit")) and J.t(S.visit.get(J.str(q.place))) else 0.0, 1.0]   # guide
	return [0.0, 1.0]
static func q_done(this_, q) -> bool:
	var p = J.mc(this_, "progress", [q])
	return J.num(p[0]) >= J.num(p[1])
static func q_check(this_) -> void:
	var S = _S(); var q = J.mc(this_, "cur", [])
	if not J.t(q): return
	var St = _g("Story")
	if J.t(J.mc(this_, "done", [q])) and not J.t(J.mc(St, "busy", [])): J.mc(this_, "complete", [])
	# 支線：鬼宅天花板上的「哎喲」
	if J.t(S.seen.get("ch2_end")) and J.num(S.bld.house) >= 4 and not J.t(S.seen.get("side_tianhua")) and not J.t(J.mc(St, "busy", [])) and not J.t(J.gp(_g("Battle"), "active")):
		J.mc(St, "queue", ["side_tianhua", func(_t, _a): J.cl(_g("joinGhost"), null, ["tianhua"]); return null])
static func q_complete(this_) -> void:
	var S = _S(); var q = J.mc(this_, "cur", []); S["qi"] = J.num(S.qi) + 1
	var txt = J.str(J.cl(_g("give"), null, [q.r])); _snd("coin")
	_fx("toast", ["任務完成：%s<br><b>%s</b>" % [J.str(q.text), txt] + (("<br>" + J.str(q.note)) if J.t(q.get("note")) else "")])
	var nq = J.mc(this_, "cur", [])
	if J.t(nq) and J.t(nq.get("onStart")):
		for id in nq.onStart: if not J.t(S.seen.get(J.str(id))): J.mc(_g("Story"), "queue", [id])
	J.cl(_g("save"), null, []); _ui_refresh()

# ---------------- 其他 ----------------
static func bld_unlocked(id) -> bool:
	var S = _S(); var b = _g("BUILDINGS")[J.str(id)]
	if J.t(b.get("unlockLv")) and J.num(S.lv) < J.num(b.unlockLv): return false
	if J.t(b.get("unlockStage")) and not J.t(S.cleared.get(J.str(b.unlockStage))): return false
	if J.t(b.get("unlockQuest")):
		var Q = _g("QUESTS"); var qi = -1
		for i in Q.size(): if J.str(Q[i].get("t")) == "build" and J.str(Q[i].get("b")) == J.str(id): qi = i; break
		if qi > J.num(S.qi): return false
	return true
static func furnace_ready():
	var S = _S(); var f = S.bld.get("furnace")
	if not J.t(f): return f
	return J.now() - J.num(S.furnaceAt) >= FURNACE_CD * 1000 / J.num(_g("TIME_SCALE"))
static func stand_ok(st) -> bool: return not J.t(J.gp(st, "need")) or J.t(_S().seen.get(J.str(J.gp(st, "need"))))

static func offline_gain() -> void:
	var S = _S()
	var last = J.num(S.last) if J.t(S.get("last")) else J.now()
	var sec = minf(8 * 3600, maxf(0, (J.now() - last) / 1000))
	if sec < 60: return
	var before = S.res.duplicate()
	var s = 0.0
	var prod = _g("produce")
	while s < sec: J.cl(prod, null, [minf(60, sec - s)]); s += 60
	var parts = []; var RN = _g("RES_NAMES")
	for k in ["wood", "rice", "planks", "buns", "troops", "coins"]:
		var d = floor(J.num(S.res.get(k)) - J.num(before.get(k)))
		if d > 0: parts.append("%s +%s" % [J.str(RN[k]), fmt(d)])
	S["last"] = J.now()
	if parts.size() > 0:
		J.mc(_g("Story"), "queue", [{"style": "sys", "lines": [["系統", "親，你離開了 %d 小時 %d 分鐘。鬼怪們沒有偷懶哦～（最多計 8 小時）" % [int(floor(sec / 3600)), int(floor(fmod(sec, 3600) / 60))]], ["旁白", "離線收益：" + "，".join(parts)]]}])

# ---------------- 安裝 ----------------
static func _fn(f: Callable) -> Callable: return f
func run(env) -> void:
	# 未改寫嘅部分：照用轉譯版（模塊實例要留住）
	_trans = load("res://jsgen/game.gd").new()
	_trans.run(env)
	var G = J.G
	ORIG = {"F": (G["F"] as Dictionary).duplicate(), "Quest": (G["Quest"] as Dictionary).duplicate()}
	for n in ["fmt", "newState", "save", "load", "fodderCount", "workersAt", "ghostById", "gdef", "ratesPerMin", "produce", "canPay", "pay", "costText", "give", "gainExp", "onLevelUp", "joinGhost", "recruitFodder", "bldUnlocked", "furnaceReady", "standOk", "offlineGain"]:
		ORIG[n] = G.get(n)
	G["fmt"] = func(_t, a): return fmt(J.arg(a, 0))
	G["newState"] = func(_t, _a): return new_state()
	G["save"] = func(_t, _a): save(); return null
	G["load"] = func(_t, _a): return load_()
	var F: Dictionary = G["F"]
	F["expNeed"] = func(_t, a): return exp_need(J.num(J.arg(a, 0)))
	F["ghostCap"] = func(_t, _a): return ghost_cap()
	F["stat"] = func(_t, a): return stat(J.arg(a, 0), J.arg(a, 1))
	F["glv"] = func(_t, a): return glv(J.arg(a, 0))
	F["lvCost"] = func(_t, a): return lv_cost(J.num(J.arg(a, 0)))
	F["bldMax"] = func(_t, a): return bld_max(J.arg(a, 0))
	F["upCost"] = func(_t, a): return up_cost(J.arg(a, 0), J.num(J.arg(a, 1)))
	F["builderDiscount"] = func(_t, _a): return builder_discount()
	F["slots"] = func(_t, a): return slots(J.arg(a, 0))
	F["mult"] = func(_t, a): return mult(J.arg(a, 0))
	F["cap"] = func(_t, _a): return cap()
	F["troopCap"] = func(_t, _a): return troop_cap()
	F["rosterCap"] = func(_t, _a): return roster_cap()
	F["walk"] = func(_t, _a): return walk()
	F["chopTime"] = func(_t, _a): return chop_time()
	F["furnaceCD"] = FURNACE_CD; F["feastCD"] = FEAST_CD; F["feastNeed"] = FEAST_NEED
	F["furnaceCoins"] = func(_t, _a): return furnace_coins()
	F["chestGain"] = func(_t, a): return chest_gain(J.arg(a, 0))
	F["recruitCost"] = func(_t, _a): return {"coins": 150.0, "buns": 40.0}
	G["fodderCount"] = func(_t, _a): return fodder_count()
	G["workersAt"] = func(_t, a): return workers_at(J.arg(a, 0))
	G["ghostById"] = func(_t, a): return ghost_by_id(J.arg(a, 0))
	G["gdef"] = func(_t, a): return gdef(J.arg(a, 0))
	G["ratesPerMin"] = func(_t, _a): return rates_per_min()
	G["produce"] = func(_t, a): produce(J.num(J.arg(a, 0))); return null
	G["canPay"] = func(_t, a): return can_pay(J.arg(a, 0))
	G["pay"] = func(_t, a): pay(J.arg(a, 0)); return null
	G["costText"] = func(_t, a): return cost_text(J.arg(a, 0))
	G["give"] = func(_t, a): return give(J.arg(a, 0), J.arg(a, 1))
	G["gainExp"] = func(_t, a): gain_exp(J.num(J.arg(a, 0)), J.arg(a, 1)); return null
	G["onLevelUp"] = func(_t, a): on_level_up(J.num(J.arg(a, 0))); return null
	G["joinGhost"] = func(_t, a): join_ghost(J.arg(a, 0)); return null
	G["recruitFodder"] = func(_t, a): return recruit_fodder(J.arg(a, 0))
	var Q: Dictionary = G["Quest"]
	Q["cur"] = func(_t, _a): return q_cur()
	Q["progress"] = func(_t, a): return q_progress(J.arg(a, 0))
	Q["done"] = func(t, a): return q_done(t if t != null else Q, J.arg(a, 0))
	Q["check"] = func(t, _a): q_check(t if t != null else Q); return null
	Q["complete"] = func(t, _a): q_complete(t if t != null else Q); return null
	G["bldUnlocked"] = func(_t, a): return bld_unlocked(J.arg(a, 0))
	G["furnaceReady"] = func(_t, _a): return furnace_ready()
	G["standOk"] = func(_t, a): return stand_ok(J.arg(a, 0))
	G["offlineGain"] = func(_t, _a): offline_gain(); return null
