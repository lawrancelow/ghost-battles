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


# ================= 第二段：村子邏輯（Village）=================
# 只換邏輯同狀態更新；畫面喺 Godot 由原生 ui/nv_village.gd 畫（補丁令 Village.draw 唔再叫），draw/drawParts/drawBubble/drawPointer 等第四段
const VW := 390.0
const VWH := 1130.0
static func _V() -> Dictionary: return J.G.get("Village")
static func _pos(arr_name: String, i: int) -> Array: return _g(arr_name)[i]
static func _float(x, y, txt: String, col: String) -> void: _fx("float", [x, y, txt, col])

static func v_set_cam(this_, y: float) -> void:
	var vh = J.num(this_.h) / J.num(this_.scale)
	this_["camY"] = maxf(0, minf(VWH - vh, y))
static func v_focus(this_, x: float, y: float) -> void: J.mc(this_, "setCam", [y - (J.num(this_.h) / J.num(this_.scale)) / 2])

static func v_hit_test(x: float, y: float):
	var TP = _g("TREE_POS"); var PP = _g("PADDY_POS"); var POS = _g("POS")
	for i in TP.size():
		var tx = J.num(TP[i][0]); var ty = J.num(TP[i][1])
		if absf(x - tx) < 24 and y > ty - 72 and y < ty + 8: return {"kind": "tree", "i": float(i)}
	for i in PP.size():
		var px = J.num(PP[i][0]); var py = J.num(PP[i][1])
		if absf(x - px) < 26 and absf(y - py + 4) < 16: return {"kind": "paddy", "i": float(i)}
	for id in POS:
		var bx = J.num(POS[id][0]); var by = J.num(POS[id][1])
		var w = 70.0 if id == "house" else (65.0 if id == "gate" else (26.0 if id == "furnace" else 46.0)); var h = 115.0 if id == "house" else (92.0 if id == "gate" else 70.0)
		if absf(x - bx) < w and y > by - h and y < by + 10: return {"kind": "gate" if id == "gate" else "bld", "id": id}
	return null

static func v_tap(this_, x: float, y: float) -> void:
	var S = _S(); var UI = _g("UI")
	if J.t(J.mc(_g("Story"), "busy", [])) or J.t(J.mc(UI, "modalOpen", [])): return
	var HD = _g("HeroDaily")
	if HD != null and J.t(J.mc(HD, "tap", [this_, x, y])): return   # 阿福打瞌睡時點他：驚醒（daily_hero）
	var h = J.mc(this_, "hitTest", [x, y])
	if not J.t(h): J.mc(this_, "walkTo", [x, y, null]); return
	var k = J.str(h.kind)
	if k == "tree":
		var i = int(J.num(h.i)); var tp = _pos("TREE_POS", i)
		if J.num(S.trees[i]) > 0: J.mc(this_, "walkTo", [J.num(tp[0]) + 20, J.num(tp[1]) + 4, {"kind": "tree", "i": float(i)}])
		else: _float(x, y - 30, "樹樁還在長…", "#ccc")
		return
	if k == "paddy":
		var i = int(J.num(h.i)); var pp = _pos("PADDY_POS", i)
		if J.t(S.paddy[i]): J.mc(this_, "walkTo", [J.num(pp[0]) - 30, J.num(pp[1]) + 4, {"kind": "paddy", "i": float(i)}])
		else: _float(x, y - 20, "稻子還沒熟", "#ccc")
		return
	if k == "gate":
		var Wd = _g("World")
		if Wd != null: J.mc(Wd, "open", [])
		else: J.mc(UI, "open", ["battle"])
		return
	if k == "bld": J.mc(UI, "openBuilding", [h.id])

static func v_walk_to(this_, x: float, y: float, target) -> void:
	var H = this_.hero
	H["tx"] = maxf(14, minf(VW - 14, x)); H["ty"] = maxf(150, minf(VWH - 10, y)); H["target"] = target; H["act"] = null

static func v_craft(this_, bid, n) -> void:
	var S = _S(); var b = J.str(bid); var nn = J.i32(n); if nn == 0: nn = 1
	nn = maxi(1, nn)
	var src = "wood" if b == "plank" else "rice"; var can = floor(J.num(S.res[src]) / 4); var RN = _g("RES_NAMES"); var H = this_.hero
	if can < 1: _float(H.x, J.num(H.y) - 60, "%s不夠（要 4）" % J.str(RN[src]), "#ff9a9a"); return
	if can < nn: _float(H.x, J.num(H.y) - 60, "材料只夠做 %s 份" % J.str(can), "#ffb37a")
	var p = _g("POS")[b]
	J.mc(this_, "walkTo", [J.num(p[0]) + (40.0 if b == "plank" else -40.0), J.num(p[1]) + 14, {"kind": "craft", "bid": b, "n": float(nn), "want": float(nn), "done": 0.0, "short": can < nn, "dur": 0.9}])

static func v_update(this_, dt: float) -> void:
	var S = _S()
	if J.num(this_.get("hitstop")) > 0: this_["hitstop"] = J.num(this_.hitstop) - dt; J.mc(this_, "updateParts", [dt * 0.3, true]); return
	this_["t"] = J.num(this_.t) + dt; var H = this_.hero
	# 樹與稻子再生
	for i in S.trees.size():
		if J.num(S.trees[i]) <= 0:
			S.treeRegrow[i] = J.num(S.treeRegrow[i]) - dt
			if J.num(S.treeRegrow[i]) <= 0: S.trees[i] = 3.0
	for i in S.paddy.size():
		if not J.t(S.paddy[i]):
			S.paddyRegrow[i] = J.num(S.paddyRegrow[i]) - dt
			if J.num(S.paddyRegrow[i]) <= 0: S.paddy[i] = 1.0
	var dx = J.num(H.tx) - J.num(H.x); var dy = J.num(H.ty) - J.num(H.y); var d = sqrt(dx * dx + dy * dy)
	if d > 2:
		var sp = J.num(J.mc(_g("F"), "walk", [])) * dt
		H["x"] = J.num(H.x) + dx / d * minf(sp, d); H["y"] = J.num(H.y) + dy / d * minf(sp, d)
		if absf(dx) > 1: H["dir"] = 1.0 if dx > 0 else -1.0
		H["walking"] = true
	else:
		H["walking"] = false
		if J.t(H.get("target")):
			H["act"] = H.target; H["target"] = null; H["actT"] = 0.0
			var ak = J.str(H.act.get("kind"))
			if ak == "tree": H["dir"] = -1.0
			if ak == "paddy": H["dir"] = 1.0
			if ak == "craft": H["dir"] = -1.0 if J.str(H.act.bid) == "plank" else 1.0
		if J.t(H.get("act")):
			var GS = _g("GhostStreet")
			J.mc(this_, "doAct", [dt * (J.num(J.mc(GS, "mul", ["work"])) if GS != null else 1.0)])
	J.mc(this_, "updateParts", [dt])
	var HD = _g("HeroDaily")
	if HD != null: J.mc(HD, "update", [this_, dt])   # 阿福平日動作排程
	var fl = []
	for f in J.iter(this_.floats):
		J.sp(f, "t", J.num(J.gp(f, "t")) + dt)
		if J.num(J.gp(f, "t")) < J.num(J.gp(f, "life")): fl.append(f)
	this_["floats"] = fl
	var fe = []
	for f in this_.feathers:
		f["t"] = J.num(f.t) + dt; f["x"] = J.num(f.x) + J.num(f.vx) * dt + sin(J.num(f.t) * 4) * 0.4; f["y"] = J.num(f.y) + 14 * dt; f["rot"] = J.num(f.rot) + dt * 2
		if J.num(f.t) < J.num(f.life): fe.append(f)
	this_["feathers"] = fe
	var cr = []
	for c in this_.crows:
		c["t"] = J.num(c.t) + dt; c["x"] = J.num(c.x) + J.num(c.vx) * dt; c["y"] = J.num(c.y) + J.num(c.vy) * dt; c["vy"] = J.num(c.vy) - 30 * dt; c["ph"] = J.num(c.ph) + dt * 22
		if J.num(c.t) < J.num(c.life): cr.append(c)
	this_["crows"] = cr
	# 村民碎碎念
	var b = this_.get("bubble")
	if J.t(b):
		J.sp(b, "t", J.num(J.gp(b, "t")) + dt)
		if J.num(J.gp(b, "t")) > 4.6: this_["bubble"] = null
	this_["chatT"] = J.num(this_.chatT) - dt
	if J.num(this_.chatT) <= 0 and not J.t(this_.get("bubble")): this_["chatT"] = 6 + randf() * 5; J.mc(this_, "pickChatter", [])

static func v_do_act(this_, dt: float) -> void:
	var S = _S(); var H = this_.hero; var a = H.act; var RN = _g("RES_NAMES"); var F = _g("F")
	H["actT"] = J.num(H.actT) + dt
	var gain = func(n): J.cl(_g("gainExp"), null, [n])
	var qcheck = func(): J.mc(_g("Quest"), "check", [])
	var kind = J.str(a.get("kind"))
	if kind == "tree":
		var i = int(J.num(a.i))
		if J.num(S.trees[i]) <= 0: H["act"] = null; return
		if J.num(H.actT) >= J.num(J.mc(F, "chopTime", [])):
			H["actT"] = 0.0; var first_hit = J.num(S.trees[i]) == 3; S.trees[i] = J.num(S.trees[i]) - 1; a["shake"] = 0.15; _snd("chop")
			var tp = _pos("TREE_POS", i); var tx = J.num(tp[0]); var ty = J.num(tp[1])
			J.mc(this_, "impact", [tx + 6, ty - 22, "wood", 1.2 if first_hit else 1.0])
			if first_hit: J.mc(this_, "scatterCrows", [float(i)])
			_float(tx, ty - 50, "咚！", "#ffe9a8")
			if J.num(S.trees[i]) <= 0:
				S.treeRegrow[i] = 25.0; S.cnt["chop"] = J.num(S.cnt.chop) + 1; S.res["wood"] = J.num(S.res.wood) + 4; gain.call(2.0); _snd("treeFall")
				_float(tx, ty - 70, "槐木 +4　好評 +2", "#a8ffcf"); _fx("praise", ["chop"]); H["act"] = null; this_["proudT"] = 0.9; this_["shk"] = 5.0; qcheck.call()
	elif kind == "paddy":
		if J.num(H.actT) >= J.num(J.mc(F, "chopTime", [])) * 1.4:
			var i = int(J.num(a.i))
			S.paddy[i] = 0.0; S.paddyRegrow[i] = 20.0; this_["proudT"] = 0.8; S.cnt["rice"] = J.num(S.cnt.rice) + 1; S.res["rice"] = J.num(S.res.rice) + 3; gain.call(1.0); _snd("harvest")
			var pp = _pos("PADDY_POS", i); _float(pp[0], J.num(pp[1]) - 30, "糯米 +3　好評 +1", "#a8ffcf"); _fx("praise", ["rice"]); H["act"] = null; qcheck.call()
	elif kind == "craft":
		# 批量製作：每份照舊計算（材料、產出、S.cnt、好評、任務），第一份 0.9 秒，之後每份 0.6 秒
		if a.get("n") == null: a["n"] = 1.0; a["want"] = 1.0; a["done"] = 0.0
		if a.get("dur") == null: a["dur"] = 0.9
		if J.num(H.actT) >= J.num(a.dur):
			var plank = J.str(a.bid) == "plank"; var src = "wood" if plank else "rice"; var out = "planks" if plank else "buns"
			if J.num(S.res[src]) < 4:
				H["act"] = null
				_float(H.x, J.num(H.y) - 60, ("%s用完了，做好 %s 份" % [J.str(RN[src]), J.str(a.done)]) if J.t(a.done) else "%s不夠（要 4）" % J.str(RN[src]), "#ff9a9a"); return
			S.res[src] = J.num(S.res[src]) - 4; S.res[out] = J.num(S.res[out]) + 2
			var ck = "craftPlank" if plank else "craftBun"; S.cnt[ck] = J.num(S.cnt.get(ck)) + 1; gain.call(1.0); _snd("craft")
			a["done"] = J.num(a.done) + 1; a["n"] = J.num(a.n) - 1; qcheck.call()
			var more = J.num(a.n) > 0 and J.num(S.res[src]) >= 4
			if J.num(a.want) == 1: _float(H.x, J.num(H.y) - 60, "%s +2　好評 +1" % J.str(RN[out]), "#a8ffcf"); _fx("praise", ["craft"])
			elif more:
				var tot = J.num(a.done) + minf(J.num(a.n), floor(J.num(S.res[src]) / 4)) if J.t(a.get("short")) else J.num(a.want)
				_float(J.num(H.x) + 26, J.num(H.y) - 44, "%s %s/%s" % [J.str(RN[out]), J.str(a.done), J.str(tot)], "#ffe9a8")
			if more: H["actT"] = 0.0; a["dur"] = 0.6; return
			H["act"] = null
			if J.num(a.want) > 1:
				_float(H.x, J.num(H.y) - 66, "%s +%s　好評 +%s" % [J.str(RN[out]), J.str(J.num(a.done) * 2), J.str(a.done)], "#a8ffcf")
				_fx("praise", ["craft"])

static func v_hero_pose(this_) -> Array:
	var H = this_.hero; var a = H.get("act"); var F = _g("F")
	if J.num(this_.get("proudT")) > 0: return ["proud", 0.0]
	if not J.t(a) or J.t(H.get("walking")): return [null, 0.0]
	match J.str(a.get("kind")):
		"tree": return ["chop", minf(1, J.num(H.actT) / J.num(J.mc(F, "chopTime", [])))]
		"paddy": return ["reap", minf(1, J.num(H.actT) / (J.num(J.mc(F, "chopTime", [])) * 1.4))]
		"craft": return ["hammer" if J.str(a.bid) == "plank" else "knead", minf(1, J.num(H.actT) / (J.num(a.dur) if J.t(a.get("dur")) else 0.9))]
	return [null, 0.0]

static func v_impact(this_, x: float, y: float, kind: String, power) -> void:
	if not J.t(this_.get("parts")): this_["parts"] = []
	var P = this_.parts; var pw = J.num(power) if J.t(power) else 1.0
	this_["hitstop"] = maxf(J.num(this_.get("hitstop")), 0.05 * pw); this_["shk"] = maxf(J.num(this_.get("shk")), 2.5 * pw)
	P.append({"k": "spark", "x": x, "y": y, "t": 0.0, "life": 0.16, "s": 0.07 * pw, "r": randf() * 6})
	var n = 6 if kind == "wood" else (9 if kind == "rice" else (2 if kind == "dough" else 3))
	for i in n:
		var pk = "chip" if kind == "wood" else ("grain" if kind == "rice" else ("dough" if kind == "dough" else "dust"))
		var vx = (randf() - 0.5) * 120 + (50.0 if kind == "wood" else 0.0); var vy = -60 - randf() * 90
		var life = 0.5 + randf() * 0.4; var r = randf() * 6; var vr = (randf() - 0.5) * 18
		var sc = 0.022 if kind == "dough" else (0.035 if kind == "dust" else 0.04 + randf() * 0.03)
		P.append({"k": pk, "x": x, "y": y, "vx": vx, "vy": vy, "g": -10.0 if kind == "dust" else 320.0, "t": 0.0, "life": life, "r": r, "vr": vr, "s": sc})
	if kind != "rice": P.append({"k": "dust", "x": x, "y": y + 4, "vx": 0.0, "vy": -12.0, "g": 0.0, "t": 0.0, "life": 0.45, "r": 0.0, "vr": 0.0, "s": 0.05})

static func v_update_parts(this_, dt: float, frozen) -> void:
	var P = this_.get("parts") if J.t(this_.get("parts")) else []; var np = []
	for p in P:
		p["t"] = J.num(p.t) + dt; p["x"] = J.num(p.x) + J.num(p.get("vx")) * dt; p["y"] = J.num(p.y) + J.num(p.get("vy")) * dt
		p["vy"] = J.num(p.get("vy")) + J.num(p.get("g")) * dt; p["r"] = J.num(p.r) + J.num(p.get("vr")) * dt
		if J.num(p.t) < J.num(p.life): np.append(p)
	this_["parts"] = np
	if J.num(this_.get("shk")) > 0: this_["shk"] = maxf(0, J.num(this_.shk) - dt * 18)
	if J.num(this_.get("proudT")) > 0: this_["proudT"] = J.num(this_.proudT) - dt
	if J.t(frozen): return
	# 錘子、揉麵：每一下落下的瞬間出特效
	var H = this_.hero; var a = H.get("act"); var walking = J.t(H.get("walking"))
	if J.t(a) and J.str(a.get("kind")) == "craft" and not walking:
		var p = minf(1, J.num(H.actT) / (J.num(a.dur) if J.t(a.get("dur")) else 0.9))
		var hits = [0.5, 0.999] if J.str(a.bid) == "plank" else [0.125, 0.375, 0.625, 0.875]
		var prev = p if this_.get("_pp") == null else J.num(this_._pp)
		for h in hits:
			if prev < h and p >= h: J.mc(this_, "impact", [J.num(H.x) + (-16.0 if J.num(H.dir) < 0 else 16.0), J.num(H.y) - 4, "wood" if J.str(a.bid) == "plank" else "dough", 0.8 if J.str(a.bid) == "plank" else 0.4])
		this_["_pp"] = 0.0 if p >= 0.999 else p
	elif J.t(a) and J.str(a.get("kind")) == "paddy" and not walking:
		var p = minf(1, J.num(H.actT) / (J.num(J.mc(_g("F"), "chopTime", [])) * 1.4)); var prev = p if this_.get("_pp") == null else J.num(this_._pp)
		for h in [1.0 / 12, 5.0 / 12, 9.0 / 12]:
			if prev < h and p >= h:
				var pp = _pos("PADDY_POS", int(J.num(a.i))); J.mc(this_, "impact", [J.num(pp[0]) - 6 + randf() * 12, J.num(pp[1]) - 8, "rice", 0.5])
		this_["_pp"] = p
	else: this_["_pp"] = null

static func v_scatter_crows(this_, i: int) -> void:
	var tp = _pos("TREE_POS", i); var tx = J.num(tp[0]); var ty = J.num(tp[1]); var n = 3 + int(floor(randf() * 3))
	for k in n:
		var dir = 1.0 if k % 2 else -1.0; var sx = tx + (randf() - 0.5) * 40; var sy = ty - 48 - randf() * 18
		var vx = dir * (50 + randf() * 90); var vy = -(50 + randf() * 60); var life = 2 + randf() * 0.8; var ph = randf() * 6; var s = 1.1 + randf() * 0.4
		this_.crows.append({"x": sx, "y": sy, "vx": vx, "vy": vy, "t": 0.0, "life": life, "ph": ph, "s": s})
		this_.feathers.append({"x": sx, "y": sy, "t": 0.0, "life": 2.4, "vx": (randf() - 0.5) * 20, "rot": randf() * 6})
	J.mc(_g("Sound"), "play", ["crow", (tx - 195) / 195])

static func v_pick_chatter(this_) -> void:
	var S = _S(); var CH = _g("CHATTER")
	var top = J.num(this_.camY) + 60; var bot = J.num(this_.camY) + J.num(this_.h) / J.num(this_.scale) - 20
	var cand = []
	for v in J.iter(this_.vis):
		var vy = J.num(J.gp(v, "y")); var gk = J.str(J.gp(J.gp(v, "g"), "k"))
		if vy > top + 120 and vy < bot and J.t(J.gp(CH, gk)) and (not J.t(J.gp(v, "hero")) or J.num(S.qi) > 3): cand.append(v)
	if cand.is_empty() or J.t(J.mc(_g("Story"), "busy", [])) or J.t(J.mc(_g("UI"), "modalOpen", [])): return
	var v = cand[int(floor(randf() * cand.size()))]; var k = J.str(J.gp(J.gp(v, "g"), "k"))
	if not J.t(this_.chatUsed.get(k)): this_.chatUsed[k] = []
	var used = this_.chatUsed[k]; var pool = []
	for l in CH[k]: if not used.has(l): pool.append(l)
	if pool.is_empty(): used.clear(); pool = CH[k]
	var line = pool[int(floor(randf() * pool.size()))]; used.append(line)
	this_["bubble"] = {"id": J.gp(J.gp(v, "g"), "id"), "hero": J.t(J.gp(v, "hero")), "text": line, "t": 0.0}

static func v_worker_spots() -> Array:
	var out = []
	var add = func(post: String, pts: Array):
		var i = 0
		for g in workers_at(post):
			var p = pts[i % pts.size()]
			out.append({"g": g, "x": p[0], "y": p[1], "flip": p[2], "ph": i * 0.7, "post": post}); i += 1
	add.call("wood", [[130.0, 520.0, 1.0], [178.0, 430.0, 1.0], [70.0, 540.0, 0.0], [24.0, 460.0, 0.0]])
	add.call("rice", [[290.0, 437.0, 0.0], [290.0, 487.0, 0.0], [290.0, 537.0, 1.0], [372.0, 487.0, 1.0]])
	add.call("plank", [[45.0, 770.0, 0.0], [140.0, 772.0, 1.0], [60.0, 790.0, 0.0], [128.0, 794.0, 1.0]])
	add.call("bun", [[250.0, 772.0, 0.0], [345.0, 770.0, 1.0], [262.0, 794.0, 0.0], [332.0, 794.0, 1.0]])
	add.call("store", [[150.0, 890.0, 0.0]]); add.call("boss", [[260.0, 320.0, 1.0]])
	add.call("camp", [[250.0, 1018.0, 0.0], [350.0, 1018.0, 1.0], [270.0, 1036.0, 0.0], [330.0, 1036.0, 1.0]])
	return out

static func v_quest_target():
	var S = _S(); var q = J.mc(_g("Quest"), "cur", [])
	if not J.t(q): return null
	var go = J.str(q.get("go")); var POS = _g("POS")
	if go == "tree":
		var i = -1
		for j in S.trees.size(): if J.num(S.trees[j]) > 0: i = j; break
		return _pos("TREE_POS", i if i >= 0 else 0)
	if go == "paddy":
		var i = -1
		for j in S.paddy.size(): if J.t(S.paddy[j]): i = j; break
		return _pos("PADDY_POS", i if i >= 0 else 0)
	if go == "gate": return POS.gate
	if POS.get(go) != null: return POS[go]
	return null

# 補丁版 collect：原生村子畫面每幀攞「物件清單」（打工鬼、廣場鬼、阿福）；畫法閉包照網頁版
static func v_collect(this_, ctx) -> Array:
	var S = _S(); var t = J.num(this_.t); var items = []; var ART = _g("ART")
	var spots = J.mc(this_, "workerSpots", []); var vis = []; this_["vis"] = vis
	for s in J.iter(spots): vis.append({"g": J.gp(s, "g"), "x": J.gp(s, "x"), "y": J.gp(s, "y")})
	var work_info = {"furnace": [J.num(_g("POS").furnace[0]), J.num(_g("POS").furnace[1]) - 22] if J.t(S.bld.get("furnace")) else null}
	for s in J.iter(spots):
		var ss = s
		items.append({"y": J.gp(s, "y"), "kind": "work", "s": s, "f": func(_t, _a):
			var WK = _g("WORK")
			if WK != null: return J.mc(WK, "drawWorker", [ctx, ss, t, 0.62, work_info])
			return J.mc(ART, "drawChar", [ctx, J.gp(J.gp(ss, "g"), "k"), J.gp(ss, "x"), J.gp(ss, "y"), 0.62, {"t": t + J.num(J.gp(ss, "ph")), "work": true, "flip": J.gp(ss, "flip"), "tamed": true, "untied": true}])})
	var idle = []
	for g in S.ghosts: if not J.t(g.get("post")) and J.str(g.k) != "afu": idle.append(g)
	var n0 = items.size()
	var PL = _g("PlazaLife")
	if PL != null: J.mc(PL, "frame", [this_, idle, items, vis, ctx, t])
	for i in range(n0, items.size()):
		if not J.t(J.gp(items[i], "kind")): J.sp(items[i], "kind", "plaza")
	var H = this_.hero
	vis.append({"g": S.ghosts[0], "x": H.x, "y": H.y, "hero": true})
	var hp = J.mc(this_, "heroPose", []); var HD = _g("HeroDaily"); var hd = J.mc(HD, "opts", [this_]) if HD != null else null
	items.append({"y": H.y, "kind": "hero", "f": func(_t, _a):
		var o = {"t": t, "walk": H.get("walking"), "work": J.t(H.get("act")), "flip": J.num(H.dir) < 0, "mood": "happy" if J.t(S.get("ended")) else null, "pose": hp[0], "pt": hp[1]}
		if J.t(hd): J.assign(o, [hd])
		return J.mc(ART, "drawChar", [ctx, "afu", H.x, H.y, 0.72, o])})
	return items

static func install_seg2() -> void:
	var V: Dictionary = J.G["Village"]
	for n in ["setCam", "focus", "hitTest", "tap", "walkTo", "craft", "update", "doAct", "heroPose", "impact", "updateParts", "scatterCrows", "pickChatter", "workerSpots", "questTarget", "collect"]:
		ORIG["V." + n] = V.get(n)
	V["setCam"] = func(t, a): v_set_cam(t if t != null else V, J.num(J.arg(a, 0))); return null
	V["focus"] = func(t, a): v_focus(t if t != null else V, J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); return null
	V["hitTest"] = func(_t, a): return v_hit_test(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))
	V["tap"] = func(t, a): v_tap(t if t != null else V, J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); return null
	V["walkTo"] = func(t, a): v_walk_to(t if t != null else V, J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.arg(a, 2)); return null
	V["craft"] = func(t, a): v_craft(t if t != null else V, J.arg(a, 0), J.arg(a, 1)); return null
	V["update"] = func(t, a): v_update(t if t != null else V, J.num(J.arg(a, 0))); return null
	V["doAct"] = func(t, a): v_do_act(t if t != null else V, J.num(J.arg(a, 0))); return null
	V["heroPose"] = func(t, _a): return v_hero_pose(t if t != null else V)
	V["impact"] = func(t, a): v_impact(t if t != null else V, J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.str(J.arg(a, 2)), J.arg(a, 3)); return null
	V["updateParts"] = func(t, a): v_update_parts(t if t != null else V, J.num(J.arg(a, 0)), J.arg(a, 1)); return null
	V["scatterCrows"] = func(t, a): v_scatter_crows(t if t != null else V, int(J.num(J.arg(a, 0)))); return null
	V["pickChatter"] = func(t, _a): v_pick_chatter(t if t != null else V); return null
	V["workerSpots"] = func(_t, _a): return v_worker_spots()
	V["questTarget"] = func(_t, _a): return v_quest_target()
	V["collect"] = func(t, a): return v_collect(t if t != null else V, J.arg(a, 0))

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
	install_seg2()
