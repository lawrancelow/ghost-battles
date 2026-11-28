# 原生改寫自 game.js（遊戲核心：狀態、經濟、村子、介面）——分段進行
# 全部原生，唔再載轉譯版（jsgen/game.gd）；只有對照測試（GB_L2_ORIG=1）先載轉譯版做比較。
#   第一段（呢度）：數值公式 F、存檔 newState/save/load、經濟 ratesPerMin/produce、資源 canPay/pay/costText/give、
#                  升級 gainExp/onLevelUp、收鬼 joinGhost/recruitFodder、任務 Quest、離線收益 offlineGain、雜項（fmt、bldUnlocked…）
#   第二段：村子邏輯；第三段：Fx/JossFx/Story/paintBg/groundLayer/drawLily/村子繪畫；第四段：UI＋補丁（__nat_menu、UI._n）；第五段：loop/startGame/全局常數
# 規矩：其他模塊會包（wrap）嘅函數（ratesPerMin、joinGhost、Quest.complete…）一律經 J.G／J.mc 叫，包裝先會生效
extends RefCounted
const WA = preload("res://game/outpost/work_anim.gd")   # [workanim]
const HERO_S := 0.9   # [herobig] 主角喺村／分區地圖嘅大細（舊 0.72）

const CE = preload("res://game/outpost/chain_eco.gd")   # [chain] 拓展建築產量
const CM = preload("res://game/outpost/mat.gd")           # [chain] 材料庫
const FURNACE_CD := 300.0
const JOSS = preload("res://game/joss/joss.gd")
const TAV = preload("res://game/tavern/tavern.gd")   # [tavern] 陰間酒館   # [joss] 化寶爐＝陽間包裹
const RAID = preload("res://game/raid/raid.gd")   # [raid] 惡鬼襲擾：停工／壞咗嘅建築唔產出
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
	if x >= 1e12: return JStr.num_call(x / 1e12, "toFixed", [1.0]) + "T"   # [polish4] B／T 縮寫
	if x >= 1e9: return JStr.num_call(x / 1e9, "toFixed", [1.0]) + "B"
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
		"trees": [3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0], "treeRegrow": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], "paddy": [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0], "paddyRegrow": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		"uid": 1.0, "prod": {},
		"hero": {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": false},   # 主角名／性別（DB.N 顯示時替換）
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
# [ux] 鬼怪升級用料：前期（升到 Lv10 之前）用冥幣＋普通包子（T2，包子鋪出），唔再卡死喺 T3 壽包；
#      Lv10 起先用壽包（數量打七折）＋冥幣。lv_cost 照舊當「價值」記入 spent（投胎退錢用）。
const LV_EARLY := 10.0
static func lv_pay(lv: float) -> Dictionary:
	var c = lv_cost(lv)
	if lv < LV_EARLY: return {"coins": J.round(c * 1.5), "bao": ceil(c * 0.25)}
	return {"buns": ceil(c * 0.7), "coins": J.round(c * 1.0)}
static func bld_max(id) -> float: return 20.0 if J.str(id) == "house" else J.num(_S().bld.house)
static func builder_discount() -> float:
	var ws = workers_at("boss")
	return minf(0.35, glv(ws[0]) * 0.012) if ws.size() > 0 else 0.0
static func up_cost(id, lv: float) -> Dictionary:
	var k = 1.1 if J.str(id) == "house" else 0.9
	# [p56] 會議第 0 批：成本指數 1.72／1.8 → 1.5／1.55，產量由線性改加速（mult），10 級成本÷產量由 ~14 倍降到 ~3.8 倍
	var planks = J.round(25 * pow(lv, 1.5) * k); var coins = J.round(28 * pow(lv, 1.55) * k)
	if lv <= 1.0: planks = J.round(planks * 0.5)   # [p56b] 每棟第一次升級（1→2 級）板半價：新手期「伐木場升 2 級」唔使齋等 3 分鐘；2 級以上成本照舊
	planks = J.round(planks * (1 - builder_discount()))
	return {"planks": planks, "coins": coins}
static func slots(post) -> float:
	var p = _g("POSTS")[J.str(post)]; var lv = J.num(_S().bld.get(J.str(p.bld)))
	if lv == 0: return 0.0
	if J.str(post) == "boss": return 1.0
	return minf(4, 1 + floor((lv - 1) / 3))
static func mult(bid) -> float: return mult_lv(J.num(_S().bld[J.str(bid)]))
static func mult_lv(lv: float) -> float:   # [p56] 1 級 ×1、2 級 ×1.49、5 級 ×3.4、10 級 ×8.3（舊：1.3／2.2／3.7）
	var d = maxf(0.0, lv - 1); return 1 + 0.45 * d + 0.04 * d * d
static func cap() -> float:
	var S = _S(); var st = J.num(S.bld.store)
	var c = 400 + (400 * pow(st, 1.5) if st != 0 else 0.0) + (600.0 if J.num(S.lv) >= 9 else 0.0)
	var ws = workers_at("store")
	if ws.size() > 0: c *= 1 + stat(ws[0], 2) / 100
	return J.round(c)
static func troop_cap() -> float: var S = _S(); return 150 + 150 * J.num(S.bld.home) + 50 * J.num(S.bld.camp) + BK().cap_bonus()   # [barracks] 兵營加上限
static func BK(): return load("res://game/barracks/bk_data.gd")   # [barracks]
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
		if RAID.post_down(J.str(g.post)): continue   # [raid] 被襲擾：停工／壞咗
		var hm = TAV.work_mul(g)   # [tavern] 酒館鬼：肚餓 ×0.5、罷工 0
		if hm <= 0: continue
		var lv = glv(g)
		match J.str(g.post):
			"wood": r.wood += (9 + 0.7 * lv) * hm * mult("wood")
			"rice": r.rice += (9 + 0.7 * lv) * hm * mult("rice")
			"plank": var o = (2.5 + stat(g, 0) * 0.05) * hm * mult("plank"); r.planks += o; r.woodUse += o * 2
			"bun":   # [chain] 包子鋪出普通包子 m_bao（唔再直接出壽包）：速度照舊公式（每分鐘 o 批），每批用料／出貨跟 chain.json（冇就 2 糯米 → 1 包）
				var o = (2.5 + stat(g, 1) * 0.05) * hm * mult("bun"); var bb = CM.bld(CM.bld_of_old("bun"))
				var ri = J.num(J.gp(bb.get("in", {}), "m_rice")) if bb.get("in") is Dictionary and bb["in"].has("m_rice") else 2.0
				var bo = J.num(J.gp(bb.get("out", {}), "m_bao")) if bb.get("out") is Dictionary and bb["out"].has("m_bao") else 1.0
				r["bao"] = J.num(r.get("bao")) + o * bo; r.riceUse += o * ri; r["baoUse"] = J.num(r.get("baoUse")) + o * ri
			"camp":   # 嚇人訓練班：練嚇功（rework）
				var o = (2 + stat(g, 2) * 0.04) * hm * mult("camp")
				r["drill"] = J.num(r.get("drill")) + o; r.bunUse += o * 0.6
				if not r.has("drillBy"): r["drillBy"] = []
				r.drillBy.append([g.k, o])
			"store": if J.str(g.k) == "toyol": r.coins += (2 + lv * 0.25) * hm
		r.exp += 0.6
	if J.t(S.bld.get("home")) and not RAID.post_down("home"): r.troops += (1.2 + 1.3 * J.num(S.bld.home)) * BK().train_mul()   # 村裡的遊魂自願當陰兵（民宅）；[raid] 停工唔出兵；[barracks] 兵營加訓練速度
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
	if rg.call("buns") != 0 and J.num(R.buns) < cp:   # 舊式（其他模塊加嘅壽包產出，食糯米）；包子鋪已改出 m_bao
		var need = (rg.call("riceUse") - rg.call("baoUse")) * m; var k = minf(1, J.num(R.rice) / need) if need > 0 else 0.0
		R["rice"] = J.num(R.rice) - need * k; R["buns"] = minf(cp, J.num(R.buns) + rg.call("buns") * m * k)
	if rg.call("bao") != 0 and CM.amt("m_bao") < CM.cap("m_bao"):   # [chain] 包子鋪：2 糯米 → 1 普通包子
		var need = rg.call("baoUse") * m; var k = minf(1, J.num(R.rice) / need) if need > 0 else 0.0
		R["rice"] = J.num(R.rice) - need * k; CM.add_capped("m_bao", rg.call("bao") * m * k)
	if rg.call("troops") != 0 and J.num(R.troops) < troop_cap(): R["troops"] = minf(troop_cap(), J.num(R.troops) + rg.call("troops") * m)
	var by = J.gp(r, "drillBy")
	if J.t(by):
		var need = rg.call("bunUse") * m; var k = minf(1, CM.amt("m_bao") / need) if need > 0 else 0.0   # [ux] 練嚇功改食普通包子（唔再同升級搶壽包）
		CM.add("m_bao", -need * k)
		if not J.t(S.get("drill")): S["drill"] = {}
		for e in J.iter(by):
			var gk = J.str(e[0]); S.drill[gk] = J.num(S.drill.get(gk)) + J.num(e[1]) * m * k
	R["coins"] = J.num(R.coins) + rg.call("coins") * m
	TAV.tick(dt)   # [tavern] 夜宵／罷工、酒館名單刷新
	CE.produce(dt)   # [chain] 拓展採集／加工建築（chain.json GATHER／WORKSHOPS，崗位鍵 = bid）
	var acc = J.num(_g("expAcc")) + rg.call("exp") * m
	J.G["expAcc"] = acc
	if acc >= 1:
		var e = floor(acc); J.G["expAcc"] = acc - e; gain_exp(e, true)

# ---------------- 資源操作 ----------------
static func res_amt(k) -> float:   # [ux] "bao"（普通包子）存喺材料庫 S.mat.m_bao，其他照舊 S.res
	if J.str(k) == "bao": return CM.amt("m_bao")
	return J.num(_S().res.get(k))
static func can_pay(c) -> bool:
	for k in J.keys(c): if res_amt(k) < J.num(J.gp(c, k)) - 1e-6: return false
	return true
static func pay(c) -> void:
	var R = _S().res
	for k in J.keys(c):
		if J.str(k) == "bao": CM.add("m_bao", -J.num(J.gp(c, k))); continue
		R[k] = J.num(R.get(k)) - J.num(J.gp(c, k))
static func pay_plain(c) -> String:   # [ux] 純文字（按鈕用）：「冥幣 15＋普通包子 3」
	var RN = _g("RES_NAMES"); var o = []
	for k in J.keys(c): if J.t(J.gp(c, k)): o.append("%s %s" % [J.str(RN.get(k)), fmt(J.gp(c, k))])
	return "＋".join(o)
static func cost_text(c) -> String:
	var RN = _g("RES_NAMES"); var o = []
	for k in J.keys(c):
		var v = J.gp(c, k)
		if not J.t(v): continue
		o.append("<span class=\"%s\">%s %s</span>" % ["" if res_amt(k) >= J.num(v) else "lack", J.str(RN.get(k)), fmt(v)])
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
	load("res://ui/juice.gd").celebrate_banner(true)   # [juice] 主公升級
	if J.t(u): J.mc(_g("Story"), "queue", [{"style": "sys", "lines": u.lines + [["旁白", "解鎖：" + J.str(u.desc)]]}])
	if lv == 4 and not J.t(S.seen.get("gift_xiaozhi")) and load("res://game/onboard/ob.gd").xz_due(true): xz_gift()   # [onboard] 舊玩家後備（新流程喺包子鋪起好就到）
static func xz_gift() -> void:
	load("res://game/onboard/ob.gd").xz_queued = true
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
	var rq = load("res://game/rebuild/rb.gd").cur_q()   # [rebuild] 荒村重建虛擬任務（排喺正式主線之前）
	if rq != null: return rq
	var Q = _g("QUESTS"); var i = int(J.num(_S().qi))
	return Q[i] if i >= 0 and i < Q.size() else null
static func q_progress(q) -> Array:
	if J.t(J.gp(q, "rb")): return load("res://game/rebuild/rb.gd").progress(q)   # [rebuild]
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
	var obp = load("res://game/onboard/ob.gd").progress(q)   # [onboard] 大排檔賣貨／第一次守夜
	if obp.size() == 2: return obp
	return [0.0, 1.0]
static func q_done(this_, q) -> bool:
	var p = J.mc(this_, "progress", [q])
	return J.num(p[0]) >= J.num(p[1])
static func q_check(this_) -> void:
	var S = _S()
	var RBm = load("res://game/rebuild/rb.gd")
	RBm.tick()   # [rebuild] 搭棚計時
	if RBm.opening_due() and not J.t(J.mc(_g("Story"), "busy", [])): RBm.queue_opening()   # [rebuild] 地府→孟婆湯→流放→荒村
	var q = J.mc(this_, "cur", [])
	if not J.t(q): return
	var St = _g("Story")
	if J.t(J.mc(this_, "done", [q])) and not J.t(J.mc(St, "busy", [])): J.mc(this_, "complete", [])
	var OB = load("res://game/onboard/ob.gd")
	if OB.arrive_due() and not J.t(J.mc(St, "busy", [])): OB.arrive_q = true; J.mc(St, "queue", ["ob_arrive"])   # [onboard] 序章完：黑無常交村
	if OB.xz_due() and not J.t(J.mc(St, "busy", [])): xz_gift()   # [onboard] 包子鋪起好：小紙即刻到（唔再等主公 4 級）
	# 支線：鬼宅天花板上的「哎喲」
	if J.t(S.seen.get("ch2_end")) and J.num(S.bld.house) >= 4 and not J.t(S.seen.get("side_tianhua")) and not J.t(J.mc(St, "busy", [])) and not J.t(J.gp(_g("Battle"), "active")):
		J.mc(St, "queue", ["side_tianhua", func(_t, _a): J.cl(_g("joinGhost"), null, ["tianhua"]); return null])
static func q_complete(this_) -> void:
	var q0 = J.mc(this_, "cur", [])
	if J.t(J.gp(q0, "rb")): load("res://game/rebuild/rb.gd").complete(q0); return   # [rebuild] 虛擬任務唔郁 S.qi
	var S = _S(); var q = J.mc(this_, "cur", []); S["qi"] = J.num(S.qi) + 1
	var txt = J.str(J.cl(_g("give"), null, [q.r])); _snd("coin")
	var qtx = J.str(q.text)
	if J.str(q.get("t")) == "stage" and qtx.begins_with("夜班巡陰"): qtx = load("res://game/outpost/mv_bridge.gd").quest_text(q)   # [outgate] 新版叫「出村迎戰」
	_fx("toast", ["任務完成：%s<br><b>%s</b>" % [qtx, txt] + (("<br>" + J.str(q.note)) if J.t(q.get("note")) else "")])
	var nq = J.mc(this_, "cur", [])
	if J.t(nq) and J.t(nq.get("onStart")):
		for id in nq.onStart: if not J.t(S.seen.get(J.str(id))): J.mc(_g("Story"), "queue", [id])
	J.cl(_g("save"), null, []); _ui_refresh()

# ---------------- 其他 ----------------
# [ruins13b] 未解鎖嘅建築：講要做咩先開（廢墟牌／撳廢墟提示）
static func bld_req(id) -> String:
	var S = _S(); var b = _g("BUILDINGS").get(J.str(id))
	if b == null: return ""
	if J.t(b.get("unlockLv")) and J.num(S.lv) < J.num(b.unlockLv): return "主公 %d 級開放" % int(J.num(b.unlockLv))
	if J.t(b.get("unlockStage")) and not J.t(S.cleared.get(J.str(b.unlockStage))): return "通關 %s 開放" % J.str(b.unlockStage)
	if J.t(b.get("unlockQuest")): return "跟主線任務開放"
	if J.t(b.get("unlockBld")) and not J.t(S.bld.get(J.str(b.unlockBld))): return "先起好%s" % J.str(_g("BUILDINGS")[J.str(b.unlockBld)].name)   # [barracks]
	return ""
static func bld_unlocked(id) -> bool:
	var S = _S(); var b = _g("BUILDINGS")[J.str(id)]
	if J.str(id) in ["house", "wood", "rice", "furnace"] and load("res://game/rebuild/rb.gd").active(): return true   # [rebuild] 化寶爐排第 4，荒村一開始就修得
	if J.t(b.get("unlockLv")) and J.num(S.lv) < J.num(b.unlockLv): return false
	if J.t(b.get("unlockStage")) and not J.t(S.cleared.get(J.str(b.unlockStage))): return false
	if J.t(b.get("unlockQuest")):
		var Q = _g("QUESTS"); var qi = -1
		for i in Q.size(): if J.str(Q[i].get("t")) == "build" and J.str(Q[i].get("b")) == J.str(id): qi = i; break
		if qi > J.num(S.qi): return false
	if J.t(b.get("unlockBld")) and not J.t(S.bld.get(J.str(b.unlockBld))): return false   # [barracks] 兵營：要先起民宅
	return true
static func furnace_ready():
	var S = _S(); var f = S.bld.get("furnace")
	if not J.t(f): return f
	return JOSS.ready()   # [joss] 有陽間包裹等收（舊：冷卻 5 分鐘燒冥幣）
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
	var SB = _S().get("bld", {}) if _S() is Dictionary else {}
	for id in POS:
		var bx = J.num(POS[id][0]); var by = J.num(POS[id][1])
		var w = 70.0 if id == "house" else (65.0 if id == "gate" else (26.0 if id == "furnace" else 46.0)); var h = 115.0 if id == "house" else (92.0 if id == "gate" else 70.0)
		if id != "gate" and SB is Dictionary and SB.has(id) and not J.t(SB.get(id)):   # [ruins13] 未起嘅地盤（廢墟）
			var on_sign = false   # [rebuild4] 木牌擺咗喺廢墟腳邊：撳牌都計
			if Spr.ok(J.str(id) + "_ruin"):
				var sr: Rect2 = load("res://game/rebuild/rb.gd").sign_rect(J.str(id))
				on_sign = Rect2(sr.position + Vector2(bx, by), sr.size).grow(3.0).has_point(Vector2(x, y))
			if not J.t(_c("bldUnlocked", [id])):   # 未解鎖：唔彈建築卡（之前撳空地都會彈），撳廢墟／木牌淨係講點樣開
				if on_sign or (absf(x - bx) < 40 and y > by - 80 and y < by + 10): return {"kind": "ruin", "id": id}
				continue
			if on_sign: return {"kind": "bld", "id": id}
			w = 40.0; h = 80.0   # 可重建：撳廢墟／木牌
		if absf(x - bx) < w and y > by - h and y < by + 10: return {"kind": "gate" if id == "gate" else "bld", "id": id}
	return null

static func v_tap(this_, x: float, y: float) -> void:
	var S = _S(); var UI = _g("UI")
	if J.t(J.mc(_g("Story"), "busy", [])) or J.t(J.mc(UI, "modalOpen", [])): return
	var HD = _g("HeroDaily")
	if HD != null and J.t(J.mc(HD, "tap", [this_, x, y])): return   # 阿福打瞌睡時點他：驚醒（daily_hero）
	if load("res://game/rebuild/rb.gd").tap(this_, x, y): return   # [rebuild] 撳雜物堆／撳要修嘅廢墟
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
	if k == "ruin":   # [ruins13b] 未解鎖廢墟：講要做咩先開
		_float(x, y - 30, "%s：%s" % [J.str(_g("BUILDINGS")[J.str(h.id)].name), bld_req(h.id)], "#e8d8b0")
		return
	if k == "gate":
		var Wd = _g("World")
		if Wd != null: J.mc(Wd, "open", [])
		else: J.mc(UI, "open", ["battle"])
		return
	if k == "bld" and J.str(h.id) == "furnace" and JOSS.count() > 0: load("res://game/joss/joss_ui.gd").open_next(); return   # [joss] 有包裹：撳爐直接收件
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
			var plank = J.str(a.bid) == "plank"; var src = "wood" if plank else "rice"; var out = "planks" if plank else "bao"   # [chain] 包子鋪親手包 = 普通包子
			if J.num(S.res[src]) < 4:
				H["act"] = null
				_float(H.x, J.num(H.y) - 60, ("%s用完了，做好 %s 份" % [J.str(RN[src]), J.str(a.done)]) if J.t(a.done) else "%s不夠（要 4）" % J.str(RN[src]), "#ff9a9a"); return
			S.res[src] = J.num(S.res[src]) - 4
			if plank: S.res[out] = J.num(S.res[out]) + 2
			else: CM.add("m_bao", 2)   # [chain]
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
			if g.get("sortie") is Dictionary: continue   # [p56] 出擊緊（崗位照開工）：村入面唔畫
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
	var nl = load("res://game/onboard/need.gd").quest_lack(q)   # [p56] 缺料：箭頭／前往指去上游建築（例：民宅缺板 → 棺材鋪）
	if not nl.is_empty() and POS.get(str(nl.up)) != null: return POS[str(nl.up)]
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
			var wa = WA.draw_worker(ctx, ss, t, 0.62)   # [workanim] 生產鏈建築：名鬼做工動畫（工具浮喺面向嗰邊）
			if wa != null: return wa
			if WK != null: return J.mc(WK, "drawWorker", [ctx, ss, t, 0.62, work_info])
			return J.mc(ART, "drawChar", [ctx, J.gp(J.gp(ss, "g"), "k"), J.gp(ss, "x"), J.gp(ss, "y"), 0.62, {"t": t + J.num(J.gp(ss, "ph")), "work": true, "flip": J.gp(ss, "flip"), "tamed": true, "untied": true}])})
	var idle = []
	for g in S.ghosts: if not J.t(g.get("post")) and J.str(g.k) != "afu" and J.str(g.k) != "xiaozhi" and not (g.get("sortie") is Dictionary): idle.append(g)   # [xzfollow] 小紙冇派工就跟住主角；出擊緊嘅鬼唔喺村入面
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
		o["solid"] = true   # [herobig] 主角唔透明（唔做鬼魂下身淡出）、大少少，喺地圖上易認
		return J.mc(ART, "drawChar", [ctx, "afu", H.x, H.y, HERO_S, o])})
	_xz_follow(this_, S, items, vis, ctx, t)
	return items

# [xzfollow] 小紙（媽媽燒落嚟嘅紙紮傭人）冇派去打工嘅時候，一直跟喺主角後面
static func _xz_follow(this_, S, items: Array, vis, ctx, t) -> void:
	var xz = null
	for g in S.ghosts: if J.str(g.k) == "xiaozhi": xz = g; break
	this_["xz_on"] = false
	load("res://game/rts/sortie_post.gd").heal()   # [xzfollow] 中途關遊戲遺留嘅借調：還原
	if xz == null or J.t(xz.get("post")) or xz.get("sortie") is Dictionary: return   # 出擊緊：由出擊隊伍代表
	# [xzfollow] 雙重保險：已經畫喺任何崗位（村子／營地做工位、大排檔員工／領班／守夜）就唔好再跟主角，同一隻鬼唔可以出兩次
	if vis is Array:
		for e in vis: if J.seq(J.gp(J.gp(e, "g"), "id"), xz.id): return
	var em = J.G.get("MV_BUSY")
	if em is Callable and bool(em.call(xz.id)): return
	this_["xz_on"] = true
	var H = this_.hero
	var hx = J.num(H.x); var hy = J.num(H.y); var dir = -1.0 if J.num(H.dir) < 0 else 1.0
	var tx = hx - dir * 30.0; var ty = hy + 4.0
	var f = this_.get("xzf")
	if not (f is Dictionary) or Vector2(J.num(f.x), J.num(f.y)).distance_to(Vector2(hx, hy)) > 400.0: f = {"x": tx, "y": ty, "fl": dir < 0}; this_["xzf"] = f
	var dx = tx - J.num(f.x); var dy = ty - J.num(f.y)
	var d = sqrt(dx * dx + dy * dy)
	var walk = d > 6.0
	if walk:
		var k = 0.09
		f["x"] = J.num(f.x) + dx * k; f["y"] = J.num(f.y) + dy * k
		if absf(dx) > 2.0: f["fl"] = dx < 0
	else: f["fl"] = dir < 0
	if vis is Array: vis.append({"g": xz, "x": f.x, "y": f.y})
	var fx = J.num(f.x); var fy = J.num(f.y); var fl = f.fl
	items.append({"y": fy, "kind": "xz", "f": func(_t, _a): return J.mc(_g("ART"), "drawChar", [ctx, "xiaozhi", fx, fy, HERO_S * 0.92, {"t": t + 1.7, "walk": walk, "flip": fl, "tamed": true, "untied": true}])})

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

# ================= 第三段：特效、劇情、背景、村子繪畫（Fx / JossFx / Story / paintBg / groundLayer / drawLily / Village 畫面）=================
# Godot 入面：Fx.toast/banner/praise 同 JossFx.play 會俾 bridge.connect_ui 換成原生介面；Story 成個俾 ui/story.gd 取代。
# 呢度照樣保留 JS 版本嘅行為（DOM 替身上面做），bench／測試／未接介面時一樣行得。
static func m(o, k: String, a: Array = []): return J.mc(o, k, a)
static func p(o, k: String, v) -> void: J.sp(o, k, v)
static func _c(name: String, a: Array = []): return J.cl(_g(name), null, a)
static func _q(sel: String): return J.S_document_("querySelector", [sel])
static func _qa(sel: String) -> Array: return J.iter(J.S_document_("querySelectorAll", [sel]))
static func _cls(el, op: String, a: Array): return J.mc(J.gp(el, "classList"), op, a)
static func _art(k: String, a: Array): return J.mc(_g("ART"), k, a)
static func _has(n: String) -> bool: return J.G.get(n) != null
const PI2 := PI * 2

# JS Array.prototype.sort（穩定排序）：cmp 回傳數字
static func stable_sort(arr: Array, cmp: Callable) -> Array:
	var idx = []
	for i in arr.size(): idx.append(i)
	idx.sort_custom(func(i, j):
		var c = J.num(cmp.call(arr[i], arr[j]))
		return c < 0 or (c == 0 and i < j))
	var out = []
	for i in idx: out.append(arr[i])
	return out

# ---------------- Fx ----------------
static func fx_float(x, y, text, col) -> void:
	(_V().floats as Array).append({"x": x, "y": y, "text": text, "col": col if J.t(col) else "#fff", "t": 0.0, "life": 1.6})
static func fx_toast(html) -> void:
	var box = _q("#toasts")
	while J.num(J.gp(J.gp(box, "children"), "length")) >= 3: m(J.gp(box, "firstChild"), "remove")
	var d = J.S_document_("createElement", ["div"]); p(d, "className", "toast"); p(d, "innerHTML", html)
	m(_q("#toasts"), "appendChild", [d])
	J.F_setTimeout([func(_t, _a): _cls(d, "add", ["out"]); return null, 2600.0])
	J.F_setTimeout([func(_t, _a): m(d, "remove"); return null, 3200.0])
static func fx_banner(text) -> void:
	var d = _q("#banner"); p(d, "textContent", text); _cls(d, "remove", ["show"]); J.gp(d, "offsetWidth"); _cls(d, "add", ["show"])
static func fx_praise(this_, kind) -> void:
	var S = _S(); var k = J.str(kind)
	var pool = _g("PRAISE_KIND") if J.t(S.get("ended")) else (_g("PRAISE_CHOP") if k == "chop" else (_g("PRAISE_RICE") if k == "rice" else _g("PRAISE_CRAFT")))
	var lp = this_.lastPraise; var i = 0
	while true:
		i = int(floor(randf() * pool.size()))
		if not (pool.size() > 1 and lp.has(k) and float(i) == J.num(lp[k])): break
	lp[k] = float(i)
	var d = _q("#praise"); p(d, "innerHTML", "<canvas></canvas><span>%s</span>" % J.str(pool[i]))
	var c = m(d, "querySelector", ["canvas"]); var ic = _art("sysIcon", [30.0])
	p(c, "width", J.gp(ic, "width")); p(c, "height", J.gp(ic, "height")); p(J.gp(c, "style"), "width", "30px"); p(J.gp(c, "style"), "height", "30px")
	m(m(c, "getContext", ["2d"]), "drawImage", [ic, 0.0, 0.0])
	_cls(d, "remove", ["show"]); J.gp(d, "offsetWidth"); _cls(d, "add", ["show"]); _snd("praise")
	if J.num(S.lv) >= 3 and randf() < 0.04:
		S.chests["g"] = J.num(S.chests.g) + 1; _fx("toast", ["系統太滿意了，掉落一個<b>綠箱</b>！"])

# ---------------- JossFx（化寶爐：金銀紙滿屏）----------------
static func joss_play(this_) -> void:
	if J.t(this_.get("raf")):
		J.F_cancelAnimationFrame([this_.raf])
		if J.t(this_.get("cv")): m(this_.cv, "remove")
	var win = _g("window")
	var dpr = minf(2, J.num(J.gp(win, "devicePixelRatio")) if J.t(J.gp(win, "devicePixelRatio")) else 1.0)
	var vw = J.num(J.gp(win, "innerWidth")); var vh = J.num(J.gp(win, "innerHeight"))
	var cv = J.S_document_("createElement", ["canvas"]); p(cv, "id", "jossfx"); p(cv, "width", J.round(vw * dpr)); p(cv, "height", J.round(vh * dpr))
	p(J.gp(cv, "style"), "cssText", "position:fixed;left:0;top:0;width:%spx;height:%spx;pointer-events:none;z-index:65" % [J.str(vw), J.str(vh)])
	m(J.gp(J.G.get("document"), "body"), "appendChild", [cv]); this_["cv"] = cv; var x = m(cv, "getContext", ["2d"])
	var ox = vw * 0.8; var oy = vh * 0.55
	var V = _V(); var r = m(V.cvs, "getBoundingClientRect") if V.get("cvs") != null else null
	if r != null:
		var fp = _g("POS").furnace
		ox = J.num(J.gp(r, "left")) + J.num(fp[0]) * J.num(V.scale); oy = J.num(J.gp(r, "top")) + (J.num(fp[1]) - 40 - J.num(V.camY)) * J.num(V.scale)
	ox = maxf(30, minf(vw - 30, ox)); oy = maxf(vh * 0.25, minf(vh * 0.8, oy))
	var N = 140 if vw < 500 else 170; var P = []; var sz = maxf(vw, vh) / 844
	for i in N:
		var burst = i < N * 0.55; var gold = randf() < 0.6; var w = (16 + randf() * 12) * sz
		var pp = {"gold": gold, "w": w, "h": w * (0.72 + randf() * 0.14), "rot": randf() * 6.3, "vr": (randf() - 0.5) * 7, "fl": randf() * 6.3, "vf": 4 + randf() * 8, "sw": randf() * 6.3, "vs": 1.5 + randf() * 2.5, "delay": 0.0}
		if burst:
			var ang = -PI / 2 + (randf() - 0.5) * 1.9; var sp = (420 + randf() * 520) * sz
			pp.x = ox; pp.y = oy; pp.vx = cos(ang) * sp; pp.vy = sin(ang) * sp; pp.delay = randf() * 0.3
		else:
			pp.x = randf() * vw; pp.y = -30 - randf() * vh * 0.25; pp.vx = (randf() - 0.5) * 60; pp.vy = 320 + randf() * 160; pp.delay = randf() * 0.5
		pp.term = 300 + randf() * 160
		P.append(pp)
	var S2 = []
	for i in 46: S2.append({"x": ox + (randf() - 0.5) * 60, "y": oy, "vx": (randf() - 0.5) * 500 * sz, "vy": -(200 + randf() * 700) * sz, "life": 0.6 + randf() * 0.9, "t": 0.0, "d": randf() * 0.5})
	var T = 2.8; var now0 = J.num(J.S_performance_("now", [])); var st = {"t0": now0, "last": now0}
	var paper = func(pp, a):
		var w = pp.w; var h = pp.h; var sx = cos(pp.fl)
		m(x, "save"); m(x, "translate", [pp.x, pp.y]); m(x, "rotate", [pp.rot]); m(x, "scale", [sx, 1.0]); p(x, "globalAlpha", a)
		var back = sx < 0; var shade = 0.75 + 0.25 * absf(sx)
		if pp.gold:
			p(x, "fillStyle", "rgb(%d,%d,%d)" % ([int(190 * shade), int(140 * shade), int(50 * shade)] if back else [int(236 * shade), int(188 * shade), int(70 * shade)])); m(x, "fillRect", [-w / 2, -h / 2, w, h])
			p(x, "strokeStyle", "rgba(140,80,10,.7)"); p(x, "lineWidth", 1.0); m(x, "strokeRect", [-w / 2 + 1.5, -h / 2 + 1.5, w - 3, h - 3])
			if not back:
				var q = h * 0.42; p(x, "fillStyle", "#c8281c"); m(x, "fillRect", [-q / 2, -q / 2, q, q]); p(x, "fillStyle", "rgba(255,220,120,.85)"); m(x, "fillRect", [-q / 5, -q / 5, q * 0.4, q * 0.4])
		else:
			p(x, "fillStyle", "rgb(%d,%d,%d)" % ([int(170 * shade), int(172 * shade), int(178 * shade)] if back else [int(226 * shade), int(228 * shade), int(234 * shade)])); m(x, "fillRect", [-w / 2, -h / 2, w, h])
			p(x, "strokeStyle", "rgba(90,95,110,.6)"); p(x, "lineWidth", 1.0); m(x, "strokeRect", [-w / 2 + 1.5, -h / 2 + 1.5, w - 3, h - 3])
			if not back:
				var q = h * 0.42; p(x, "fillStyle", "#7d828f"); m(x, "fillRect", [-q / 2, -q / 2, q, q])
		m(x, "restore")
	var step = {}
	step["f"] = func(_t, a):
		var now = J.num(J.arg(a, 0))
		var el = (now - st.t0) / 1000; var dt = minf(0.05, (now - st.last) / 1000); st.last = now
		m(x, "setTransform", [dpr, 0.0, 0.0, dpr, 0.0, 0.0]); m(x, "clearRect", [0.0, 0.0, vw, vh])
		var fade = maxf(0, (T - el) / 0.6) if el > T - 0.6 else 1.0
		if el < 0.5:
			var g = m(x, "createRadialGradient", [ox, oy, 0.0, ox, oy, 160 * sz]); m(g, "addColorStop", [0.0, "rgba(255,200,90,%s)" % J.str(0.55 * (1 - el / 0.5))]); m(g, "addColorStop", [1.0, "rgba(255,120,30,0)"])
			p(x, "fillStyle", g); m(x, "fillRect", [0.0, 0.0, vw, vh])
		for pp in P:
			if el < pp.delay: continue
			pp.vx *= pow(0.35, dt); pp.vy += 520 * sz * dt; var term = (pp.term if J.t(pp.term) else 250.0) * sz
			if pp.vy > term: pp.vy += (term - pp.vy) * minf(1, dt * 4)
			pp.sw += pp.vs * dt; pp.x += (pp.vx + sin(pp.sw) * 70 * sz) * dt; pp.y += pp.vy * dt; pp.rot += pp.vr * dt; pp.fl += pp.vf * dt
			if pp.y < vh + 40: paper.call(pp, fade)
		p(x, "globalCompositeOperation", "lighter")
		for s in S2:
			if el < s.d: continue
			s.t += dt
			if s.t > s.life: continue
			s.vy += 600 * sz * dt; s.x += s.vx * dt; s.y += s.vy * dt; var k = 1 - s.t / s.life; var rr = 2 + 3 * k
			p(x, "globalAlpha", k); p(x, "fillStyle", "#fff2b0"); m(x, "beginPath"); m(x, "moveTo", [s.x, s.y - rr * 2]); m(x, "lineTo", [s.x + rr * 0.5, s.y]); m(x, "lineTo", [s.x, s.y + rr * 2]); m(x, "lineTo", [s.x - rr * 0.5, s.y]); m(x, "closePath"); m(x, "fill")
			m(x, "fillRect", [s.x - rr * 2, s.y - 0.6, rr * 4, 1.2])
		p(x, "globalCompositeOperation", "source-over"); p(x, "globalAlpha", 1.0)
		if el < T: this_["raf"] = J.F_requestAnimationFrame([step.f])
		else: m(cv, "remove"); this_["cv"] = null; this_["raf"] = 0.0
		return null
	this_["raf"] = J.F_requestAnimationFrame([step.f])

# ---------------- Story（劇情播放器）----------------
# Godot 開機時 bridge.connect_ui 會成個換成 ui/story.gd；呢度只留佇列介面（busy/queue/next/skipScene），未接介面前 queue 落嘅場景會保留
static func make_story() -> Dictionary:
	var st = {"q": [], "cur": null, "li": 0.0, "typing": false, "shown": "", "timer": null, "cb": null, "actors": []}
	st["busy"] = func(t, _a):
		var o = t if t != null else st
		return J.t(o.cur) or (o.q as Array).size() > 0
	st["queue"] = func(t, a):
		var o = t if t != null else st
		(o.q as Array).append({"sc": J.arg(a, 0), "cb": J.arg(a, 1)})
		if not J.t(o.cur): J.mc(o, "next", [])
		return null
	st["next"] = func(t, _a):
		var o = t if t != null else st
		if (o.q as Array).is_empty(): o["cur"] = null; return null
		var it = (o.q as Array).pop_front(); o["cur"] = it.sc; o["cb"] = it.cb; o["li"] = 0.0
		return null
	st["skipScene"] = func(t, _a):
		var o = t if t != null else st
		var cb = o.cb; o["cur"] = null; o["cb"] = null
		if cb != null: J.cl(cb, null, [])
		J.mc(o, "next", [])
		return null
	return st

# ---------------- 背景（劇情／戰鬥共用）----------------
const SKY := {"village": ["#121016", "#24222a"], "road": ["#1a0f22", "#3a1a2a"], "field": ["#0f1a1a", "#26332a"], "kampung": ["#0c1420", "#1f2a33"], "banana": ["#0a140f", "#1c2e22"], "hq": ["#0e0e1a", "#26263c"], "office": ["#141420", "#2c2c3a"]}
static func paint_bg(ctx, w: float, h: float, bg, _t = null) -> void:
	if J.t(J.mc(_g("SCENE"), "drawBg", [ctx, w, h, bg])): return
	var b = J.str(bg)
	var sky = SKY.get(b, ["#120f22", "#2a2440"])
	var g = m(ctx, "createLinearGradient", [0.0, 0.0, 0.0, h]); m(g, "addColorStop", [0.0, sky[0]]); m(g, "addColorStop", [1.0, sky[1]]); p(ctx, "fillStyle", g); m(ctx, "fillRect", [0.0, 0.0, w, h])
	_art("el", [ctx, w * 0.78, h * 0.13, 28.0, 28.0, "rgba(240,230,200,.85)"]); _art("el", [ctx, w * 0.78 + 8, h * 0.13 - 4, 26.0, 26.0, sky[0]])
	var gy = h * 0.66
	p(ctx, "fillStyle", "rgba(0,0,0,.35)")
	if b == "banana":
		for i in 6:
			var x = i * w / 5; m(ctx, "fillRect", [x - 4, gy - 170, 8.0, 170.0])
			for k in 5:
				m(ctx, "save"); m(ctx, "translate", [x, gy - 170]); m(ctx, "rotate", [-1.2 + k * 0.6]); _art("el", [ctx, 40.0, 0.0, 44.0, 10.0, "rgba(10,30,18,.8)"]); m(ctx, "restore")
	elif b == "kampung":
		for i in 4:
			var x = 20 + i * w / 3.6; m(ctx, "fillRect", [x, gy - 90, 90.0, 50.0])
			m(ctx, "beginPath"); m(ctx, "moveTo", [x - 10, gy - 88]); m(ctx, "lineTo", [x + 45, gy - 130]); m(ctx, "lineTo", [x + 100, gy - 88]); m(ctx, "fill")
			for k in 4: m(ctx, "fillRect", [x + k * 28, gy - 40, 5.0, 40.0])
	elif b == "hq" or b == "office":
		for i in 5:
			var x = i * w / 4.5; var hh = 160.0 + (i % 3) * 70
			m(ctx, "fillRect", [x, gy - hh, 70.0, hh]); p(ctx, "fillStyle", "rgba(255,220,120,.18)")
			for a in 6:
				for bb in 3:
					if (a * 3 + bb + i) % 4: m(ctx, "fillRect", [x + 8 + bb * 20, gy - hh + 12 + a * 22, 10.0, 12.0])
			p(ctx, "fillStyle", "rgba(0,0,0,.35)")
		if b == "office": p(ctx, "fillStyle", "rgba(30,24,20,.9)"); m(ctx, "fillRect", [0.0, gy - 10, w, 30.0])
	elif b == "road":
		p(ctx, "fillStyle", "rgba(120,40,60,.25)"); m(ctx, "beginPath"); m(ctx, "moveTo", [w * 0.42, gy - 160]); m(ctx, "lineTo", [w * 0.58, gy - 160]); m(ctx, "lineTo", [w, gy]); m(ctx, "lineTo", [0.0, gy]); m(ctx, "fill")
		for i in 14:
			var x = fmod(i * 71.0, w); var y = gy - 20 - (i * 37) % 120
			p(ctx, "strokeStyle", "rgba(230,50,70,.6)"); p(ctx, "lineWidth", 1.5)
			for k in 6:
				var a = k / 6.0 * PI * 2; m(ctx, "beginPath"); m(ctx, "moveTo", [x, y]); m(ctx, "lineTo", [x + cos(a) * 7, y + sin(a) * 7]); m(ctx, "stroke")
	else:
		for i in 7:
			var x = i * w / 6; _art("el", [ctx, x, gy - 60, 40.0, 50.0, "rgba(10,20,20,.6)"]); p(ctx, "fillStyle", "rgba(10,20,20,.6)"); m(ctx, "fillRect", [x - 4, gy - 30, 8.0, 30.0])
	p(ctx, "fillStyle", "rgba(10,8,18,.55)"); m(ctx, "fillRect", [0.0, gy, w, h - gy])
	var mg = m(ctx, "createLinearGradient", [0.0, gy - 40, 0.0, gy + 20]); m(mg, "addColorStop", [0.0, "rgba(180,170,230,0)"]); m(mg, "addColorStop", [1.0, "rgba(180,170,230,.12)"]); p(ctx, "fillStyle", mg); m(ctx, "fillRect", [0.0, gy - 40, w, 60.0])

# ---------------- 村子地面（靜態圖層，只畫一次）----------------
static func ground_layer():
	if J.G.get("_ground") != null: return J.G["_ground"]
	var W = VW; var WH = VWH
	var k = 2.0; var c = J.S_document_("createElement", ["canvas"]); p(c, "width", W * k); p(c, "height", WH * k); var x = m(c, "getContext", ["2d"]); m(x, "scale", [k, k])
	var sd = {"s": 7}
	var R = func() -> float:
		sd.s = (int(sd.s) * 16807) % 2147483647
		return float(sd.s) / 2147483647.0
	var gr = m(x, "createLinearGradient", [0.0, 0.0, 0.0, WH]); m(gr, "addColorStop", [0.0, "#140f12"]); m(gr, "addColorStop", [0.13, "#211b19"]); m(gr, "addColorStop", [0.5, "#26201b"]); m(gr, "addColorStop", [1.0, "#221d1a"])
	p(x, "fillStyle", gr); m(x, "fillRect", [0.0, 0.0, W, WH])
	var hr = m(x, "createLinearGradient", [0.0, 0.0, 0.0, 160.0]); m(hr, "addColorStop", [0.0, "rgba(110,30,30,.55)"]); m(hr, "addColorStop", [1.0, "rgba(70,30,30,0)"])
	p(x, "fillStyle", hr); m(x, "beginPath"); m(x, "moveTo", [160.0, 0.0]); m(x, "lineTo", [230.0, 0.0]); m(x, "lineTo", [246.0, 160.0]); m(x, "lineTo", [144.0, 160.0]); m(x, "fill")
	for i in 700:
		var px = R.call() * W; var py = 140 + R.call() * (WH - 140); var r = 2 + R.call() * 9
		p(x, "fillStyle", "rgba(255,240,210,.025)" if R.call() < 0.5 else "rgba(0,0,0,.12)"); m(x, "beginPath"); m(x, "ellipse", [px, py, r * 1.6, r, 0.0, 0.0, 6.3]); m(x, "fill")
	p(x, "fillStyle", "rgba(20,30,22,.55)"); m(x, "beginPath"); m(x, "ellipse", [100.0, 455.0, 110.0, 92.0, 0.0, 0.0, 6.3]); m(x, "fill")
	var leaf = ["#3a3a20", "#4a3a1c", "#2e3a26"]
	for i in 90:
		var a = R.call() * 6.3; var d = R.call(); p(x, "fillStyle", leaf[i % 3]); m(x, "beginPath")
		var ex = 100 + cos(a) * 100 * d; var ey = 455 + sin(a) * 80 * d
		m(x, "ellipse", [ex, ey, 2.2, 1.2, R.call() * 3, 0.0, 6.3]); m(x, "fill")
	p(x, "fillStyle", "#18221f"); m(x, "fillRect", [222.0, 388.0, 154.0, 146.0])
	p(x, "fillStyle", "rgba(70,100,95,.18)")
	for i in 3: m(x, "fillRect", [222.0, 388.0 + i * 50 + 34, 154.0, 4.0])
	p(x, "strokeStyle", "#3a3a2c"); p(x, "lineWidth", 3.0); m(x, "strokeRect", [222.0, 388.0, 154.0, 146.0])
	var POS = _g("POS")
	for id in J.keys(POS):
		if J.str(id) == "gate": continue
		var bp = POS[id]; var bw = 80.0 if J.str(id) == "house" else (30.0 if J.str(id) == "furnace" else 56.0)
		p(x, "fillStyle", "rgba(60,48,36,.35)"); m(x, "beginPath"); m(x, "ellipse", [J.num(bp[0]), J.num(bp[1]) - 4, bw, 16.0, 0.0, 0.0, 6.3]); m(x, "fill")
	var slabc = ["#3c3a3e", "#36363a", "#413e40"]
	var slab = func(sx: float, sy: float, w: float, h: float):
		var j = (R.call() - 0.5) * 2; p(x, "fillStyle", slabc[int(floor(R.call() * 3))]); m(x, "beginPath"); m(x, "roundRect", [sx + j, sy, w - 2, h - 2, 3.0]); m(x, "fill")
		p(x, "fillStyle", "rgba(255,255,255,.05)"); m(x, "fillRect", [sx + j + 2, sy + 1, w - 6, 1.5]); p(x, "fillStyle", "rgba(0,0,0,.35)"); m(x, "fillRect", [sx + j, sy + h - 3, w - 2, 1.5])
	var y = 150.0
	while y < WH:
		var off = 0.0 if fmod(y / 18.0, 2.0) != 0.0 else 12.0
		slab.call(172 - off / 2, y, 24 + off / 2, 18.0); slab.call(196 + (0.0 if off else -6.0), y, 24 - (0.0 if off else -6.0), 18.0)
		y += 18
	for ry in [678.0, 932.0]:
		var xx = 0.0
		while xx < W:
			if not (xx > 160 and xx < 222): slab.call(xx, ry, 22.0, 11.0); slab.call(xx + 11, ry + 11, 22.0, 11.0)
			xx += 22
	var tuft = func(tx: float, ty: float):
		p(x, "strokeStyle", "#34463a" if R.call() < 0.5 else "#3e5040"); p(x, "lineWidth", 1.3)
		for kk in range(-2, 3):
			m(x, "beginPath"); m(x, "moveTo", [tx + kk * 1.6, ty])
			var ex = tx + kk * 3 + (R.call() - 0.5) * 2; var ey = ty - 6 - R.call() * 4
			m(x, "quadraticCurveTo", [tx + kk * 2.2, ty - 4, ex, ey]); m(x, "stroke")
	for i in 220:
		var tx = R.call() * W; var ty = 150 + R.call() * (WH - 150)
		if tx > 160 and tx < 230: continue
		if tx > 218 and ty > 384 and ty < 538: continue
		if absf(ty - 690) < 16 or absf(ty - 942) < 16: continue
		tuft.call(tx, ty)
	var vg = m(x, "createLinearGradient", [0.0, 0.0, W, 0.0]); m(vg, "addColorStop", [0.0, "rgba(0,0,0,.35)"]); m(vg, "addColorStop", [0.12, "rgba(0,0,0,0)"]); m(vg, "addColorStop", [0.88, "rgba(0,0,0,0)"]); m(vg, "addColorStop", [1.0, "rgba(0,0,0,.35)"])
	var sc = ["rgba(120,92,62,.16)", "rgba(70,56,40,.22)", "rgba(150,120,80,.10)", "rgba(60,80,58,.14)", "rgba(20,14,10,.22)"]
	p(x, "lineCap", "round")
	for i in 16000:
		var px = R.call() * W; var py = 120 + R.call() * (WH - 120); var ln = 3 + R.call() * 7; var a = -0.6 + (R.call() - 0.5) * 0.35
		p(x, "strokeStyle", sc[int(floor(R.call() * sc.size()))]); p(x, "lineWidth", 0.6 + R.call() * 1.1)
		m(x, "beginPath"); m(x, "moveTo", [px, py]); m(x, "lineTo", [px + cos(a) * ln, py + sin(a) * ln]); m(x, "stroke")
	for i in 5000:
		p(x, "fillStyle", "rgba(235,220,190,.07)" if R.call() < 0.6 else "rgba(0,0,0,.18)")
		var fx = R.call() * W; var fy = R.call() * WH; var fw = 0.5 + R.call() * 0.9; var fh = 0.5 + R.call() * 0.9
		m(x, "fillRect", [fx, fy, fw, fh])
	p(x, "fillStyle", vg); m(x, "fillRect", [0.0, 0.0, W, WH])
	J.G["_ground"] = c; return c

static func draw_lily(ctx, x: float, y: float, t: float) -> void:
	p(ctx, "strokeStyle", "#3a5a32"); p(ctx, "lineWidth", 1.2); m(ctx, "beginPath"); m(ctx, "moveTo", [x, y + 12]); m(ctx, "lineTo", [x, y + 2]); m(ctx, "stroke")
	p(ctx, "strokeStyle", "rgba(214,40,52,.9)"); p(ctx, "lineWidth", 1.5); p(ctx, "lineCap", "round")
	for k in 6:
		var a = k / 6.0 * PI * 2 + sin(t * 0.6) * 0.15
		m(ctx, "beginPath"); m(ctx, "moveTo", [x, y]); m(ctx, "quadraticCurveTo", [x + cos(a) * 4, y + sin(a) * 4 - 3, x + cos(a) * 7, y + sin(a) * 6 - 4]); m(ctx, "stroke")
	p(ctx, "fillStyle", "#ff6060"); m(ctx, "beginPath"); m(ctx, "arc", [x, y, 1.6, 0.0, 6.3]); m(ctx, "fill")

# ---------------- Village：畫布、尺寸、觸控、繪畫 ----------------
static func v_init(this_) -> void:
	this_["cvs"] = _q("#village"); this_["ctx"] = m(this_.cvs, "getContext", ["2d"])
	m(this_, "resize")
	m(_g("window"), "addEventListener", ["resize", func(_t, _a): m(this_, "resize"); return null])
	var c = this_.cvs
	var down = func(_t, a):
		var pt = m(this_, "pt", [J.arg(a, 0)]); this_["drag"] = {"y0": J.gp(pt, "cy"), "cam": this_.camY, "moved": false, "x": J.gp(pt, "cx"), "y": J.gp(pt, "cy")}; return null
	var move = func(_t, a):
		if not J.t(this_.get("drag")): return null
		var e = J.arg(a, 0); var pt = m(this_, "pt", [e]); var dy = J.num(J.gp(pt, "cy")) - J.num(this_.drag.y0)
		if absf(dy) > 8: this_.drag["moved"] = true
		if J.t(this_.drag.moved): m(this_, "setCam", [J.num(this_.drag.cam) - dy])
		m(e, "preventDefault"); return null
	var up = func(_t, _a):
		if not J.t(this_.get("drag")): return null
		var d = this_.drag; this_["drag"] = null
		if not J.t(d.moved): m(this_, "tap", [d.x, J.num(d.y) + J.num(this_.camY)])
		return null
	m(c, "addEventListener", ["pointerdown", down]); m(c, "addEventListener", ["pointermove", move, {"passive": false}]); m(_g("window"), "addEventListener", ["pointerup", up])
	m(c, "addEventListener", ["wheel", func(_t, a):
		var e = J.arg(a, 0); m(this_, "setCam", [J.num(this_.camY) + J.num(J.gp(e, "deltaY")) * 0.6]); m(e, "preventDefault"); return null, {"passive": false}])
	this_["camY"] = 180.0
static func v_resize(this_) -> void:
	var r = m(this_.cvs, "getBoundingClientRect"); var win = _g("window")
	this_["dpr"] = minf(2, J.num(J.gp(win, "devicePixelRatio")) if J.t(J.gp(win, "devicePixelRatio")) else 1.0)
	this_["w"] = J.gp(r, "width"); this_["h"] = J.gp(r, "height"); p(this_.cvs, "width", J.num(J.gp(r, "width")) * this_.dpr); p(this_.cvs, "height", J.num(J.gp(r, "height")) * this_.dpr)
	this_["scale"] = J.num(this_.w) / VW; m(this_, "setCam", [this_.camY])
static func v_pt(this_, e) -> Dictionary:
	var r = m(this_.cvs, "getBoundingClientRect")
	return {"cx": (J.num(J.gp(e, "clientX")) - J.num(J.gp(r, "left"))) / J.num(this_.scale), "cy": (J.num(J.gp(e, "clientY")) - J.num(J.gp(r, "top"))) / J.num(this_.scale)}

const PART_IM := {"spark": "fx_spark", "chip": "fx_chips", "dust": "fx_dust", "dough": "fx_dough", "grain": "fx_dough"}
static func v_draw_parts(this_, ctx) -> void:
	var parts = this_.get("parts")
	if parts == null: parts = []
	for pp in J.iter(parts):
		var f = J.num(pp.t) / J.num(pp.life); m(ctx, "save"); p(ctx, "globalAlpha", maxf(0, 1 - f * f)); m(ctx, "translate", [pp.x, pp.y]); m(ctx, "rotate", [pp.r])
		var k = J.str(pp.k); var im = PART_IM.get(k)
		if k == "grain": p(ctx, "fillStyle", "#e9cf7a"); m(ctx, "fillRect", [-1.5, -3.0, 3.0, 6.0])
		elif im != null and _has("sprOk") and J.t(_c("sprOk", [im])):
			var I = J.gp(_g("SPR"), im); var sc = J.num(pp.s) * ((1 + f * 0.8) if k == "spark" else ((1 + f * 1.5) if k == "dust" else 1.0))
			var nw = J.num(J.gp(I, "naturalWidth")); var nh = J.num(J.gp(I, "naturalHeight"))
			m(ctx, "drawImage", [I, -nw * sc / 2, -nh * sc / 2, nw * sc, nh * sc])
		m(ctx, "restore")

static func v_draw(this_) -> void:
	var ctx = this_.ctx; var t = J.num(this_.t); var S = _S(); var ART = _g("ART"); var POS = _g("POS")
	var sk = J.num(this_.get("shk")) if J.t(this_.get("shk")) else 0.0; var kx = (randf() - 0.5) * sk; var ky = (randf() - 0.5) * sk
	var ds = J.num(this_.dpr) * J.num(this_.scale)
	m(ctx, "setTransform", [ds, 0.0, 0.0, ds, kx * ds, (ky - J.num(this_.camY)) * ds])
	m(ctx, "drawImage", [_c("groundLayer"), 0.0, 0.0, VW, VWH])
	for i in 9:
		var fx = float((i * 47 + 20) % 390); var fy = 24.0 + (i * 31) % 112; _c("drawLily", [ctx, fx, fy, t + i])
	for i in 6:
		var mx = fmod(t * 8 + i * 90, VW + 200) - 100; var my = 160.0 + i * 170
		var mg = m(ctx, "createRadialGradient", [mx, my, 5.0, mx, my, 90.0]); m(mg, "addColorStop", [0.0, "rgba(200,210,200,.06)"]); m(mg, "addColorStop", [1.0, "rgba(200,210,200,0)"]); p(ctx, "fillStyle", mg); m(ctx, "fillRect", [mx - 90, my - 90, 180.0, 180.0])
	var items = []
	var gp_ = POS.gate
	items.append({"y": gp_[1], "f": func(_t, _a): return J.mc(ART, "drawGate", [ctx, gp_[0], gp_[1], t])})
	var BLD = _g("BUILDINGS")
	for id in J.iter(_g("BLD_ORDER")):
		var xy = POS[id]; var lv = S.bld.get(id); var bid = id
		if J.t(lv): items.append({"y": xy[1], "f": func(_t, _a): return J.mc(ART, "drawBuilding", [ctx, bid, xy[0], xy[1], lv, t, _c("furnaceReady") if J.str(bid) == "furnace" else null])})
		elif J.t(_c("bldUnlocked", [id])): items.append({"y": xy[1], "f": func(_t, _a): return J.mc(ART, "drawSite", [ctx, xy[0], xy[1], J.gp(BLD[bid], "name")])})
	for dd in J.iter(_g("DECOR")):
		var d = dd
		items.append({"y": d[2], "f": func(_t, _a): return J.mc(ART, "drawDecor", [ctx, d[0], d[1], d[2], t])})
	var TP = J.iter(_g("TREE_POS"))
	for i in TP.size():
		var xy = TP[i]; var ii = i
		items.append({"y": xy[1], "f": func(_t, _a):
			var act = this_.hero.get("act"); var shake = act
			if J.t(act):
				shake = false
				if J.str(act.get("kind")) == "tree" and J.num(act.get("i")) == ii and J.num(act.get("shake")) > 0:
					act["shake"] = J.num(act.shake) - 1.0 / 60; shake = J.num(act.shake) > 0
			return J.mc(ART, "drawTree", [ctx, xy[0], xy[1], S.trees[ii], t, shake, J.num(S.trees[ii]) == 3, float(ii)])})
	var PP = J.iter(_g("PADDY_POS"))
	for i in PP.size():
		var xy = PP[i]; var ii = i
		items.append({"y": J.num(xy[1]) - 10, "f": func(_t, _a): return J.mc(ART, "drawPaddy", [ctx, xy[0], xy[1], S.paddy[ii], t, float(ii)])})
	var spots = J.iter(J.mc(this_, "workerSpots", [])); var vis = []; this_["vis"] = vis
	for s in spots: vis.append({"g": J.gp(s, "g"), "x": J.gp(s, "x"), "y": J.gp(s, "y")})
	var work_info = {"furnace": [J.num(POS.furnace[0]), J.num(POS.furnace[1]) - 22] if J.t(S.bld.get("furnace")) else null}
	for s in spots:
		var ss = s
		items.append({"y": J.gp(s, "y"), "f": func(_t, _a):
			var WK = _g("WORK")
			var wa = WA.draw_worker(ctx, ss, t, 0.62)   # [workanim] 生產鏈建築：名鬼做工動畫（工具浮喺面向嗰邊）
			if wa != null: return wa
			if WK != null: return J.mc(WK, "drawWorker", [ctx, ss, t, 0.62, work_info])
			return J.mc(ART, "drawChar", [ctx, J.gp(J.gp(ss, "g"), "k"), J.gp(ss, "x"), J.gp(ss, "y"), 0.62, {"t": t + J.num(J.gp(ss, "ph")), "work": true, "flip": J.gp(ss, "flip"), "tamed": true, "untied": true}])})
	var idle = []
	for g in S.ghosts: if not J.t(g.get("post")) and J.str(g.k) != "afu" and J.str(g.k) != "xiaozhi" and not (g.get("sortie") is Dictionary): idle.append(g)   # [xzfollow] 小紙冇派工就跟住主角；出擊緊嘅鬼唔喺村入面
	var PL = _g("PlazaLife")
	if PL != null: J.mc(PL, "frame", [this_, idle, items, vis, ctx, t])
	else:
		for i in idle.size():
			var g = idle[i]; var a = t * 0.25 + i * 1.7; var x = 195 + cos(a) * (60 + (i % 3) * 18); var y = 400 + 130 + sin(a * 1.3) * 18 + (i % 3) * 8; var fl = sin(a) > 0; var ti = t + i
			vis.append({"g": g, "x": x, "y": y})
			items.append({"y": y, "f": func(_t, _a): return J.mc(ART, "drawChar", [ctx, g.k, x, y, 0.58, {"t": ti, "walk": true, "flip": fl, "tamed": true, "untied": true}])})
	var H = this_.hero
	vis.append({"g": S.ghosts[0], "x": H.x, "y": H.y, "hero": true})
	var hp = J.mc(this_, "heroPose", []); var HD = _g("HeroDaily"); var hd = J.mc(HD, "opts", [this_]) if HD != null else null
	items.append({"y": H.y, "f": func(_t, _a):
		var o = {"t": t, "walk": H.get("walking"), "work": J.t(H.get("act")), "flip": J.num(H.dir) < 0, "mood": "happy" if J.t(S.get("ended")) else null, "pose": hp[0], "pt": hp[1]}
		if J.t(hd): J.assign(o, [hd])
		o["solid"] = true   # [herobig] 主角唔透明（唔做鬼魂下身淡出）、大少少，喺地圖上易認
		return J.mc(ART, "drawChar", [ctx, "afu", H.x, H.y, HERO_S, o])})
	_xz_follow(this_, S, items, vis, ctx, t)
	for it in stable_sort(items, func(a, b): return J.num(J.gp(a, "y")) - J.num(J.gp(b, "y"))): J.cl(J.gp(it, "f"), null, [])
	for f in J.iter(this_.feathers):
		m(ctx, "save"); p(ctx, "globalAlpha", maxf(0, 1 - J.num(f.t) / J.num(f.life))); m(ctx, "translate", [f.x, f.y]); m(ctx, "rotate", [sin(J.num(f.rot)) * 0.8])
		J.mc(ART, "el", [ctx, 0.0, 0.0, 1.4, 4.0, "#14111a", "#5a5068", 0.5]); m(ctx, "restore")
	J.mc(this_, "drawParts", [ctx])
	for c in J.iter(this_.crows):
		p(ctx, "globalAlpha", minf(1, (J.num(c.life) - J.num(c.t)) / 0.6)); J.mc(ART, "drawCrow", [ctx, c.x, c.y, c.s, c.ph, c.vx, false]); p(ctx, "globalAlpha", 1.0)
	if J.t(this_.get("bubble")): J.mc(this_, "drawBubble", [ctx])
	J.mc(this_, "drawPointer", [ctx, t])
	for f in J.iter(this_.floats):
		var fy = J.num(f.y) - J.num(f.t) * 26
		p(ctx, "globalAlpha", maxf(0, 1 - J.num(f.t) / J.num(f.life))); p(ctx, "font", "bold 14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"); p(ctx, "textAlign", "center")
		p(ctx, "lineWidth", 3.5); p(ctx, "strokeStyle", "rgba(10,6,20,.9)"); m(ctx, "strokeText", [f.text, f.x, fy]); p(ctx, "fillStyle", f.col); m(ctx, "fillText", [f.text, f.x, fy]); p(ctx, "globalAlpha", 1.0)

static func v_draw_bubble(this_, ctx) -> void:
	var b = this_.bubble; var v = null
	for o in J.iter(this_.vis):
		var ok = J.t(J.gp(o, "hero")) if J.t(J.gp(b, "hero")) else (J.str(J.gp(J.gp(o, "g"), "id")) == J.str(J.gp(b, "id")) and not J.t(J.gp(o, "hero")))
		if ok: v = o; break
	if v == null: this_["bubble"] = null; return
	var bt = J.num(b.t); var a = minf(minf(1, bt * 5), (4.6 - bt) * 3); m(ctx, "save"); p(ctx, "globalAlpha", maxf(0, a))
	p(ctx, "font", "600 12.5px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	var maxW = 168.0; var lines = []; var cur = ""
	for ch in J.str(b.text):
		if J.num(J.gp(m(ctx, "measureText", [cur + ch]), "width")) > maxW: lines.append(cur); cur = ch
		else: cur += ch
	if cur != "": lines.append(cur)
	var mw = -INF
	for l in lines: mw = maxf(mw, J.num(J.gp(m(ctx, "measureText", [l]), "width")))
	var w = mw + 16; var h = lines.size() * 17.0 + 10
	var vx = J.num(v.x); var vy = J.num(v.y)
	var bx = maxf(6, minf(VW - w - 6, vx - w / 2)); var by = vy - 62 - h
	_art("rr", [ctx, bx, by, w, h, 4.0, "#ecd9a4", "#5a4030", 1.2])
	_art("poly", [ctx, [vx - 5, by + h - 0.5, vx + 5, by + h - 0.5, vx, by + h + 7], "#ecd9a4"])
	p(ctx, "strokeStyle", "#5a4030"); p(ctx, "lineWidth", 1.2); m(ctx, "beginPath"); m(ctx, "moveTo", [vx - 5, by + h]); m(ctx, "lineTo", [vx, by + h + 7]); m(ctx, "lineTo", [vx + 5, by + h]); m(ctx, "stroke")
	p(ctx, "fillStyle", "#2b1d12"); p(ctx, "textAlign", "left"); p(ctx, "textBaseline", "top")
	for i in lines.size(): m(ctx, "fillText", [lines[i], bx + 8, by + 6 + i * 17])
	m(ctx, "restore")

static func v_draw_pointer(this_, ctx, t: float) -> void:
	var pq = J.mc(this_, "questTarget", [])
	if not J.t(pq) or J.str(J.gp(_g("UI"), "tab")) != "village": return
	var vh = J.num(this_.h) / J.num(this_.scale); var x = J.num(pq[0]); var y = J.num(pq[1]); var POS = _g("POS")
	var ty = y - (128.0 if J.num(POS.house[0]) == x and J.num(POS.house[1]) == y else 78.0) + sin(t * 5) * 5
	var top = J.num(this_.camY) + 8; var bot = J.num(this_.camY) + vh - 12
	var rot = 0.0
	if ty < top: ty = top + 14; rot = PI
	elif ty > bot: ty = bot - 14; rot = 0.0
	m(ctx, "save"); m(ctx, "translate", [x, ty]); m(ctx, "rotate", [rot])
	_art("poly", [ctx, [-9.0, -14.0, 9.0, -14.0, 9.0, -2.0, 15.0, -2.0, 0.0, 12.0, -15.0, -2.0, -9.0, -2.0], "#ffd84a", "#3a2400", 2.0]); m(ctx, "restore")


# ================= 第四段：介面（UI）＋補丁（__nat_menu 原生面板、UI._n 資料／動作 API）=================
# Godot 入面村子面板全部由 ui/menus 原生畫（__nat_menu），呢度出資料同執行動作，規則同原本 click handler 一模一樣。
# 舊 DOM 面板（建築／派人／名冊／箱子／劇情嘅 HTML）只喺冇原生面板時先用：淨係開返張空白 sheet（Godot 唔會行到）。
static func _ui() -> Dictionary: return J.G.get("UI")
static func _tofix(x) -> String: return JStr.num_call(J.num(x), "toFixed", [1.0])
static func _nat_menu(a: Array) -> bool: return _has("__nat_menu") and J.t(J.cl(_g("__nat_menu"), null, a))
static func _nat_close() -> void: if _has("__nat_menuClose"): J.cl(_g("__nat_menuClose"), null, [])
static func _L(s): return J.cl(_g("L"), null, [s]) if _has("L") else s
static func _left(cd: float, at) -> float: return maxf(0, cd - (J.now() - J.num(at)) * J.num(_g("TIME_SCALE")) / 1000)

static func post_label(pp) -> String:
	var ps = J.str(pp); var P = _g("POSTS")
	if pp != null and P.has(ps): return "打工：" + J.str(P[ps].name)
	if ps == "street" or ps.begins_with("boss:"): return "陽間站崗中"
	if ps.begins_with("tower"): return "樓裡有鬼出更中"
	return "出外工作中"
static func sync_snd() -> void:
	var b = _q("#sndtop")
	if J.t(b):
		var on = J.t(J.mc(_g("Sound"), "isOn", []))
		p(b, "textContent", "🔊" if on else "🔇"); _cls(b, "toggle", ["off", not on])
static func confirm_inline(btn, msg) -> bool:
	var ds = J.gp(btn, "dataset")
	if J.t(J.gp(ds, "armed")): return true
	J.sp(ds, "armed", 1.0); var o = J.gp(btn, "innerHTML"); p(btn, "innerHTML", msg)
	J.F_setTimeout([func(_t, _a): J.del(J.gp(btn, "dataset"), "armed"); p(btn, "innerHTML", o); return null, 2500.0])
	return false
static func paint_portraits(root) -> void:
	for c in J.iter(m(root, "querySelectorAll", ["canvas[data-por]"])):
		var ds = J.gp(c, "dataset")
		if J.t(J.gp(ds, "done")): continue
		J.sp(ds, "done", 1.0); var pr = _art("portrait", [J.gp(ds, "por"), 64.0, {"tamed": true, "untied": true}])
		p(c, "width", J.gp(pr, "width")); p(c, "height", J.gp(pr, "height")); m(m(c, "getContext", ["2d"]), "drawImage", [pr, 0.0, 0.0])

static func ui_modal_open() -> bool: return J.t(_cls(_q("#sheet"), "contains", ["on"])) or J.t(_cls(_q("#battle"), "contains", ["on"]))
static func ui_refresh(this_) -> void:
	var S = _S()
	if not J.t(S): return
	var F = _g("F")
	p(_q("#lv"), "textContent", S.lv)
	var need = J.num(J.mc(F, "expNeed", [S.lv]))
	p(J.gp(_q("#expbar i"), "style"), "width", J.add(100.0 if J.num(S.lv) >= 20 else minf(100, J.num(S.exp) / need * 100), "%"))
	p(_q("#exptxt"), "textContent", "好評 MAX" if J.num(S.lv) >= 20 else "好評 %s/%s" % [_c("fmt", [S.exp]), _c("fmt", [need])])
	var cap = J.num(J.mc(F, "cap", []))
	for k in ["wood", "rice", "planks", "buns"]:
		var e = _q("#r-" + k); p(e, "textContent", _c("fmt", [S.res[k]])); _cls(J.gp(e, "parentElement"), "toggle", ["full", J.num(S.res[k]) >= cap - 0.5])
	p(_q("#r-coins"), "textContent", _c("fmt", [S.res.coins])); p(_q("#r-troops"), "textContent", _c("fmt", [S.res.troops]))
	var Q = _g("Quest"); var q = J.mc(Q, "cur", []); var qb = _q("#quest")
	if J.t(q):
		var ab = J.mc(Q, "progress", [q]); var a = J.num(ab[0]); var b = J.num(ab[1])
		p(qb, "innerHTML", "<b>主線</b><span>%s</span><em>%s/%s</em>" % [J.str(J.gp(q, "text")), J.str(minf(a, b)), J.str(b)]); _cls(qb, "toggle", ["done", a >= b])
	else: p(qb, "innerHTML", "<b>主線</b><span>%s</span>" % ("第一季完。村子由你慢慢經營。" if J.t(S.get("ended")) else "—"))
	var ch = J.num(S.chests.g) + J.num(S.chests.b) + J.num(S.chests.p)
	p(_q("#nav [data-t=chest] i"), "textContent", ch if ch else ""); p(J.gp(_q("#nav [data-t=chest] i"), "style"), "display", "" if ch else "none")
	for b in _qa("#nav button"):
		var on = null
		if J.t(q):
			var bt = J.str(J.gp(J.gp(b, "dataset"), "t")); var go = J.str(J.gp(q, "go"))
			on = (go == "roster" and bt == "roster") or (go == "gate" and bt == "battle")
		_cls(b, "toggle", ["pulse", on])
	if J.t(this_.get("sheetRefresh")) and J.t(_cls(_q("#sheet"), "contains", ["on"])): J.cl(this_.sheetRefresh, this_, [])
static func ui_nav_on(t: String) -> void:
	for b in _qa("#nav button"): _cls(b, "toggle", ["on", J.str(J.gp(J.gp(b, "dataset"), "t")) == t])
static func ui_open(this_, t) -> void:
	var ts = J.str(t)
	if ts == "village": m(this_, "close"); return
	if ts == "roster": m(this_, "openRoster")
	if ts == "battle": m(this_, "openBattleSelect")
	if ts == "chest": m(this_, "openChests")
	if ts == "story": m(this_, "openStory")
	ui_nav_on(ts)
static func ui_sheet(this_, title, html, refresher) -> void:
	_nat_close()
	var sh = _q("#sheet"); _cls(sh, "add", ["on"])
	if not J.t(_cls(sh, "contains", ["was"])): _snd("paper")
	_cls(sh, "add", ["was"])
	p(m(sh, "querySelector", [".sh-title"]), "textContent", title); p(m(sh, "querySelector", [".sh-body"]), "innerHTML", html); this_["sheetRefresh"] = refresher if J.t(refresher) else null
static func ui_close(this_) -> void:
	_nat_close(); _cls(_q("#sheet"), "remove", ["on", "was"]); this_["sheetRefresh"] = null; ui_nav_on("village")

static func ui_bld_effect(id) -> String:
	var S = _S(); var F = _g("F"); var r = _c("ratesPerMin"); var sid = J.str(id)
	var L = func(a: String) -> String: return "<div class=\"eff\">%s</div>" % a
	var fm = func(k): return J.str(J.mc(F, k, []))
	match sid:
		"house": return L.call("其他建築最高可升到 Lv %s" % J.str(S.bld.house))
		"wood": return L.call("每崗產量 ×%s　崗位 %s　目前 槐木 +%s/分" % [_tofix(J.mc(F, "mult", ["wood"])), J.str(J.mc(F, "slots", ["wood"])), _tofix(r.wood)])
		"rice": return L.call("每崗產量 ×%s　崗位 %s　目前 糯米 +%s/分" % [_tofix(J.mc(F, "mult", ["rice"])), J.str(J.mc(F, "slots", ["rice"])), _tofix(r.rice)])
		"plank": return L.call("崗位 %s　目前 棺材板 +%s/分（耗槐木 %s/分）<br>藍箱可開出 棺材板 %s" % [J.str(J.mc(F, "slots", ["plank"])), _tofix(r.planks), _tofix(r.woodUse), J.str(J.gp(J.mc(F, "chestGain", ["b"]), "planks"))])
		"bun": return L.call("崗位 %s　目前 普通包子 +%s/分（耗糯米 %s/分）<br>普通包子送去移動村「嘆氣蒸籠」先蒸得成壽包<br>綠箱可開出 壽包 %s" % [J.str(J.mc(F, "slots", ["bun"])), _tofix(r.get("bao", 0.0)), _tofix(r.riceUse), J.str(J.gp(J.mc(F, "chestGain", ["g"]), "buns"))])   # [chain]
		"store": return L.call("槐木、糯米、棺材板、壽包 存放上限：%s" % _c("fmt", [J.mc(F, "cap", [])]))
		"home": return L.call("雜鬼名額 %s　遊魂自願當陰兵 +%s/分　陰兵上限 %s" % [fm.call("rosterCap"), _tofix(r.troops), _c("fmt", [J.mc(F, "troopCap", [])])])
		"camp":
			var ws = J.iter(_c("workersAt", ["camp"]))
			var h = L.call("練習速度 ×%s　崗位 %s　耗普通包子 %s/分<br>嚇功越高：回陽間招式更嚇人、更省陰氣；戰鬥嚇法更痛。" % [_tofix(J.mc(F, "mult", ["camp"])), J.str(J.mc(F, "slots", ["camp"])), _tofix(r.bunUse)])
			if ws.size():
				var RW = _g("Rework"); var parts = []
				for g in ws:
					var lv = J.mc(RW, "drillLv", [g.k]); var nx = J.mc(RW, "drillNext", [g.k])
					parts.append("%s 嚇功 Lv%s%s" % [J.str(g.name), J.str(lv), ("（%s/%s）" % [J.str(floor(J.num(J.mc(RW, "drillXp", [g.k])))), J.str(nx)]) if J.t(nx) else "（滿）"])
				h += "<br>" + "　".join(parts)
			return h
		"barracks": return L.call(BK().effect_text())   # [barracks]
	return ""
static func ui_post_stat_txt(g, post) -> String:
	var s = J.num(_g("POSTS")[J.str(post)].stat); var F = _g("F")
	return "%s %s" % [J.str(_g("STAT_NAMES")[int(s)]), J.str(J.mc(F, "stat", [g, s]))] if s >= 0 else "等級 %s" % J.str(J.mc(F, "glv", [g]))

static func ui_open_building(this_, id) -> void:
	if _nat_menu(["bld", id]): return
	m(this_, "sheet", [J.gp(_g("BUILDINGS")[J.str(id)], "name"), "<p class=\"desc\">%s</p>" % J.str(J.gp(_g("BUILDINGS")[J.str(id)], "desc")), null])
static func ui_pick_worker(this_, post, back) -> void:
	if _nat_menu(["pick", post, back]): return
	m(this_, "sheet", ["派人：" + J.str(_g("POSTS")[J.str(post)].name), "", null])
static func ui_open_roster(this_) -> void:
	if _nat_menu(["roster"]): return
	m(this_, "sheet", ["鬼怪名冊", "", null]); this_["sheetRefresh"] = null
static func ui_open_chests(this_) -> void:
	if _nat_menu(["chest"]): return
	m(this_, "sheet", ["箱子", "<p class=\"desc\">小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。</p>", null])
static func ui_open_story(this_) -> void:
	if _nat_menu(["story"]):
		var sb = _q("#sheet .sh-body")
		if J.t(sb): p(sb, "innerHTML", "")
		return
	m(this_, "sheet", ["劇情", "<p class=\"desc\">看過的劇情，可以在這裡重溫。</p>", null])
static func ui_open_battle_select() -> void:
	if _has("Patrol"): J.mc(_g("Patrol"), "openPrep", [])
	else: J.mc(_g("Battle"), "openSelect", [])

# ---------------- UI._n：原生面板資料同動作 ----------------
static func _pool_names() -> String:
	var FD = _g("FODDER"); var S = _S(); var out = []
	for k in J.keys(FD):
		var u = J.gp(FD[k], "unlock")
		if not J.t(u) or J.t(S.cleared.get(J.str(u))): out.append(J.str(FD[k].name))
	return "、".join(out)
static func n_bld(id) -> Dictionary:
	var S = _S(); var F = _g("F"); var sid = J.str(id); var b = _g("BUILDINGS")[sid]; var lv = J.num(S.bld.get(sid)) if J.t(S.bld.get(sid)) else 0.0
	var FL = _g("FLAVOR")
	var o = {"id": id, "name": b.name, "flavor": FL[sid] if FL.has(sid) and J.t(FL[sid]) else "", "desc": b.desc, "lv": lv, "house": S.bld.house}
	if not lv:
		o["unlocked"] = J.t(_c("bldUnlocked", [id])); o["cost"] = _c("costText", [b.build]); o["canBuild"] = _c("canPay", [b.build]); return o
	var rx = RegEx.create_from_string("</?div[^>]*>")
	o["effect"] = rx.sub(J.str(J.mc(_ui(), "bldEffect", [id])), "", true)
	o["max"] = J.mc(F, "bldMax", [id])
	if lv < J.num(o.max):
		var c = J.mc(F, "upCost", [id, lv]); o["upCost"] = _c("costText", [c]); o["canUp"] = _c("canPay", [c])
		var bd = J.num(J.mc(F, "builderDiscount", [])); o["disc"] = J.round(bd * 100) if bd else 0.0
	if sid == "plank" or sid == "bun":
		var src = "wood" if sid == "plank" else "rice"
		o["craft"] = {"src": _g("RES_NAMES")[src], "have": S.res[src], "can": floor(J.num(S.res[src]) / 4), "label": "槐木 → 2 棺材板" if sid == "plank" else "糯米 → 2 普通包子"}   # [chain]
	if sid == "furnace": o["furnace"] = JOSS.sig()   # [joss] 面板由 game/joss/joss_ui.gd 畫
	if sid == "altar":
		var c = J.mc(F, "recruitCost", []); var fc = J.num(_c("fodderCount")); var rc = J.num(J.mc(F, "rosterCap", []))
		o["altar"] = {"cost": _c("costText", [c]), "can": J.t(_c("canPay", [c])) and fc < rc, "cnt": fc, "cap": rc, "pool": _pool_names()}
		if _has("Presence"):
			var pst = J.mc(_g("Presence"), "st", [])
			if J.t(pst) and J.t(J.gp(pst, "gone")) and J.iter(J.gp(pst, "gone")).size():
				var gl = []
				for x in J.iter(J.gp(pst, "gone")): gl.append({"name": J.gp(x, "name"), "lv": J.gp(x, "lv")})
				o.altar["gone"] = gl
	if sid == "house" and J.num(S.lv) >= 12:
		var iq = 0.0
		for g in S.ghosts: iq += J.num(J.mc(F, "stat", [g, 1.0]))
		var left = _left(J.num(F.feastCD), S.feastAt)
		o["feast"] = {"iq": iq, "need": F.feastNeed, "left": left, "can": J.num(S.res.buns) >= 300 and iq >= J.num(F.feastNeed) and left <= 0}
	o["posts"] = []
	var P = _g("POSTS")
	for pp in J.iter(b.posts):
		var PD = P[J.str(pp)]; var n = J.num(J.mc(F, "slots", [pp]))
		if not n: continue
		var lock = ["wood", "rice", "plank", "bun", "camp", "store", "boss"].has(J.str(pp)) and J.num(S.lv) < 4
		var ws = J.iter(_c("workersAt", [pp])); var sl = []
		for i in int(n):
			var g = ws[i] if i < ws.size() else null
			sl.append({"id": g.id, "k": g.k, "name": g.name, "lv": J.mc(F, "glv", [g]), "stat": J.mc(_ui(), "postStatTxt", [g, pp])} if g != null else null)
		o.posts.append({"post": pp, "name": PD.name, "desc": PD.desc, "lock": lock, "slots": sl})
	return o
static func _why(txt: String) -> void:   # [p56] 付唔起／做唔到：提示缺乜、去邊攞（唔再無聲無息）
	load("res://game/onboard/need.gd").say(txt)
static func n_bld_act(id, a, arg):
	var S = _S(); var F = _g("F"); var sid = J.str(id); var act = J.str(a); var B = _g("BUILDINGS")[sid]; var UI = _ui()
	if act == "build":
		if load("res://game/rebuild/rb.gd").build_hook(sid): return "close"   # [rebuild] 荒村：清雜物→搭棚→開張
		if not J.t(_c("canPay", [B.build])): _why(load("res://game/onboard/need.gd").bld_why(sid, "build")); return null   # [p56] 缺料講清楚
		_snd("build"); _c("pay", [B.build]); S.bld[sid] = 1.0; _c("gainExp", [15.0]); _fx("banner", ["%s 建好了！" % J.str(B.name)]); J.mc(_g("Quest"), "check", []); BK().on_built(sid)   # [barracks] 兵營第一次建成劇情
		load("res://ui/juice.gd").celebrate_banner(true)   # [juice] 建成：粒子＋彈＋震機
	if act == "up":
		var c = J.mc(F, "upCost", [id, S.bld[sid]])
		if not J.t(_c("canPay", [c])) or J.num(S.bld[sid]) >= J.num(J.mc(F, "bldMax", [id])): _why(load("res://game/onboard/need.gd").bld_why(sid, "up")); return null   # [p56]
		_snd("build"); _c("pay", [c]); S.bld[sid] = J.num(S.bld[sid]) + 1; _c("gainExp", [10 + 8 * J.num(S.bld[sid])]); _fx("banner", ["%s 升到 Lv %s" % [J.str(B.name), J.str(S.bld[sid])]]); J.mc(_g("Quest"), "check", [])
		load("res://ui/juice.gd").celebrate_banner(false)   # [juice] 升級：粒子
	if act == "craft":
		m(UI, "close"); J.mc(_V(), "craft", [id, J.num(arg) if J.t(J.num(arg)) else 1.0]); return "close"
	if act == "burn":   # [joss] 唔再燒冥幣：開陽間包裹
		load("res://game/joss/joss_ui.gd").open_next(); return "close"
	if act == "recruit":
		if not J.t(_c("canPay", [J.mc(F, "recruitCost", [])])) or J.num(_c("fodderCount")) >= J.num(J.mc(F, "rosterCap", [])): _why(load("res://game/onboard/need.gd").recruit_why()); return null   # [p56] 招魂失敗講清楚
		_snd("whoosh"); _c("pay", [J.mc(F, "recruitCost", [])]); var g = _c("recruitFodder", [false]); S.cnt["recruit"] = J.num(S.cnt.recruit) + 1; _fx("toast", ["招來了 <b>%s</b>（%s）" % [J.str(g.name), J.str(g.q)]]); J.mc(_g("Quest"), "check", [])
	if act == "feast":
		_snd("gong"); S.res["buns"] = J.num(S.res.buns) - 300; S["feastAt"] = J.now(); S.cnt["feast"] = J.num(S.cnt.feast) + 1; _c("gainExp", [150.0])
		if J.num(_c("fodderCount")) < J.num(J.mc(F, "rosterCap", [])):
			var g = _c("recruitFodder", [true]); _fx("toast", ["鬼節宴請來了稀客 <b>%s</b>（紫）！好評 +150" % J.str(g.name)])
		else:
			S.chests["p"] = J.num(S.chests.p) + 1; _fx("toast", ["鬼節宴賓客滿座，可惜村裡住不下了。客人留下一個<b>紫箱</b>就走了。好評 +150"])
		J.mc(_g("Quest"), "check", [])
	if act == "unassign":
		var g = _c("ghostById", [arg])
		if J.t(g): g["post"] = null
	if act == "regone":
		var g = J.mc(J.gp(_g("Presence"), "dev"), "resummon", [J.num(arg)]) if _has("Presence") else null
		if J.t(g): _c("save"); m(UI, "close"); m(UI, "refresh"); return "close"
	_c("save"); m(UI, "refresh")
	return null
static func _pick_list(post) -> Array:
	var S = _S(); var F = _g("F"); var ps = J.str(post); var s = J.num(_g("POSTS")[ps].stat); var GH = _g("GHOSTS")
	var val = func(g) -> float: return J.num(J.mc(F, "stat", [g, s])) if s >= 0 else J.num(J.mc(F, "glv", [g]))
	var fbd = func(g) -> float:
		var d = GH.get(J.str(g.k)); var fb = J.gp(d, "forbid") if d != null else null
		return 1.0 if fb != null and J.iter(fb).has(ps) else 0.0
	var list = []
	for g in S.ghosts: if J.str(g.k) != "afu" and not (g.get("post") != null and J.str(g.post) == ps): list.append(g)
	return stable_sort(list, func(a, b):
		var c = fbd.call(a) - fbd.call(b)
		if c: return c
		c = val.call(b) - val.call(a)
		if c: return c
		return J.num(J.mc(F, "glv", [b])) - J.num(J.mc(F, "glv", [a])))
static func n_pick(post) -> Dictionary:
	var F = _g("F"); var ps = J.str(post); var PD = _g("POSTS")[ps]; var s = J.num(PD.stat); var SN = _g("STAT_NAMES"); var GH = _g("GHOSTS")
	var out = []
	for g in _pick_list(post):
		var d = GH.get(J.str(g.k)); var fb = J.gp(d, "forbid") if d != null else null; var isfb = fb != null and J.iter(fb).has(ps)
		var oth = []
		for i in [0, 1, 2]: if float(i) != s: oth.append(J.str(SN[i]) + J.str(J.mc(F, "stat", [g, float(i)])))
		out.append({"id": g.id, "k": g.k, "name": g.name, "q": g.q, "key": J.mc(F, "stat", [g, s]) if s >= 0 else J.mc(F, "glv", [g]), "lv": J.mc(F, "glv", [g]), "other": " ".join(oth), "where": BK().where_txt(g, post_label(g.post).trim_prefix("打工：") if J.t(g.get("post")) else "閒著"), "fb": isfb})   # [barracks]
	return {"name": PD.name, "stat": SN[int(s)] if s >= 0 else "等級", "list": out}
static func n_pick_do(post, gid) -> void:
	var g = _c("ghostById", [gid])
	if not J.t(g): return
	var ws = J.iter(_c("workersAt", [post]))
	if J.num(J.mc(_g("F"), "slots", [post])) <= 0: return   # [village2] 冇崗位（未開墾／未起）：唔派（以前 ws 空會出錯）
	if ws.size() >= J.num(J.mc(_g("F"), "slots", [post])): ws[0]["post"] = null
	g["post"] = post; BK().after_post(g); J.mc(_g("Quest"), "check", []); _c("save"); m(_ui(), "refresh")   # [barracks] 名鬼一職
static func n_roster() -> Dictionary:
	var S = _S(); var F = _g("F"); var GH = _g("GHOSTS"); var SK = _g("SKILLS"); var GP = _g("GP")
	var o = {"cap": J.mc(F, "ghostCap", []), "fcnt": _c("fodderCount"), "rcap": J.mc(F, "rosterCap", []), "buns": _c("fmt", [S.res.buns]), "list": []}
	if _has("N30W"):
		var N = _g("N30W"); var ids = J.iter(J.mc(N, "ids", [])); var n = 0
		for k in ids: if J.t(J.mc(N, "owned", [k])): n += 1
		o["codex"] = "%d/%d" % [n, ids.size()]
	var order = stable_sort(S.ghosts.duplicate(), func(a, b):
		if J.str(a.k) == "afu": return -1.0
		if J.str(b.k) == "afu": return 1.0
		var c = (0.0 if J.str(a.q) == "名" else 1.0) - (0.0 if J.str(b.q) == "名" else 1.0)
		if c: return c
		return J.num(J.mc(F, "glv", [b])) - J.num(J.mc(F, "glv", [a])))
	var cap = J.num(J.mc(F, "ghostCap", []))
	for g in order:
		var lv = J.num(J.mc(F, "glv", [g])); var cost = J.mc(F, "lvCost", [lv]); var d = _c("gdef", [g]); var sk = SK.get(J.str(g.k)); var gd = GH.get(J.str(g.k))
		var gp_now = J.mc(GP, "pow", [g]); var gp_next = null
		if J.str(g.k) != "afu" and lv < cap:
			var o2 = g.lv; g["lv"] = J.num(o2) + 1; gp_next = J.mc(GP, "pow", [g]); g["lv"] = o2
		var tag = "出陣" if J.iter(S.team).has(g.id) else ("軍師" if S.get("adviser") != null and J.str(S.adviser) == J.str(g.id) else "")
		var e = {"id": g.id, "k": g.k, "name": g.name, "q": g.q, "lv": lv, "tag": tag, "title": J.gp(gd, "title") if gd != null else "", "st": [J.mc(F, "stat", [g, 0.0]), J.mc(F, "stat", [g, 1.0]), J.mc(F, "stat", [g, 2.0])], "ranged": J.str(J.gp(d, "range")) == "ranged", "gp": gp_now, "gpNext": gp_next,
			"drill": J.mc(_g("Rework"), "drillLv", [g.k]) if _has("Rework") else null, "sk": J.gp(sk, "name") if J.t(sk) else "", "skd": J.gp(sk, "desc") if J.t(sk) else "", "trait": _L(J.gp(gd, "trait")) if gd != null else "", "lore": J.gp(gd, "lore") if gd != null and J.t(J.gp(gd, "lore")) else "",
			"where": post_label(g.post) if J.t(g.get("post")) else ("主公本人" if J.str(g.k) == "afu" else "閒著"), "afu": J.str(g.k) == "afu", "maxed": lv >= cap, "cost": cost, "pay": lv_pay(lv), "payTxt": pay_plain(lv_pay(lv)), "canUp": can_pay(lv_pay(lv)), "canRel": J.str(g.q) != "名" and J.str(g.q) != "主", "extra": [], "alpha": 1.0, "gold": false}
		if _has("Chatter") and (J.str(g.q) == "藍" or J.str(g.q) == "紫"):
			var CH = _g("Chatter"); var ar = J.mc(CH, "archOf", [g])
			if J.t(ar): e.extra.append(["#7a4a9a", "性格：%s　「%s」" % [J.str(J.gp(ar, "label")), J.str(J.mc(CH, "sample", [g])) if J.t(J.gp(CH, "sample")) else ""]])
		if _has("Presence"):
			var PR = _g("Presence"); var v = J.num(J.mc(PR, "val", [g])); var dl = J.mc(PR, "daysLeft", [g])
			e["pres"] = J.round(v); e["presDays"] = dl; e["alpha"] = J.mc(PR, "alphaOf", [g]); e["gold"] = J.str(g.k) == "afu" and J.num(J.gp(J.mc(PR, "cst", []), "rank")) >= 5
		if _has("Bonds"):
			var bt = J.mc(_g("Bonds"), "bondLine", [g.k])
			if J.t(bt): e.extra.append(["#c0603a", bt])
		BK().roster_entry(g, e)   # [barracks] 名鬼職務
		load("res://game/soul/soul_data.gd").roster_entry(g, e)   # [soul] 品級、職級、等級上限 +3×職級
		o.list.append(e)
	return o
static func n_roster_act(a, id) -> void:
	var S = _S(); var F = _g("F"); var g = _c("ghostById", [id])
	if not J.t(g): return
	if J.str(a) == "up":
		var c = J.num(J.mc(F, "lvCost", [g.lv])); var pp = lv_pay(J.num(g.lv))   # [ux] 前期冥幣＋普通包子，Lv10 起壽包
		if not can_pay(pp) or J.num(J.mc(F, "glv", [g])) >= maxf(J.num(J.mc(F, "ghostCap", [])), load("res://game/soul/soul_data.gd").cap_of(g)): return   # [soul] 職級加上限
		var pw0 = J.num(J.mc(_g("GP"), "pow", [g]))   # [juice] 升級演出：鬼力舊→新
		pay(pp); g["spent"] = J.num(g.spent) + c; g["lv"] = J.num(g.lv) + 1; _c("gainExp", [2.0]); J.mc(_g("Quest"), "check", []); _c("save"); m(_ui(), "refresh")
		load("res://ui/juice.gd").power_show(J.str(g.k), J.str(g.name), pw0, J.num(J.mc(_g("GP"), "pow", [g])), false, "%s　Lv%d" % [J.str(g.name), int(J.num(g.lv))])
	if J.str(a) == "rel":
		var back = floor(J.num(g.spent) * 0.9); S.res["coins"] = J.num(S.res.coins) + back   # [ux] 投胎退冥幣（升級已改用冥幣＋包子，唔再退壽包）
		S["ghosts"] = S.ghosts.filter(func(x): return not is_same(x, g))
		S["team"] = S.team.map(func(x): return null if x != null and J.str(x) == J.str(g.id) else x)
		if S.get("adviser") != null and J.str(S.adviser) == J.str(g.id): S["adviser"] = null
		_fx("toast", ["%s 去投胎了。退回 冥幣 %s" % [J.str(g.name), J.str(back)]]); _c("save"); m(_ui(), "refresh")
static func n_chests() -> Array:
	var S = _S(); var F = _g("F")
	return [{"k": "g", "name": "綠箱", "n": S.chests.g, "d": "開出 壽包 %s（隨包子鋪等級提升）" % J.str(J.gp(J.mc(F, "chestGain", ["g"]), "buns"))},
		{"k": "b", "name": "藍箱", "n": S.chests.b, "d": "開出 棺材板 %s（隨棺材鋪等級提升）" % J.str(J.gp(J.mc(F, "chestGain", ["b"]), "planks"))},
		{"k": "p", "name": "紫箱", "n": S.chests.p, "d": "開出 冥幣 %s（隨鬼宅等級提升）" % J.str(J.gp(J.mc(F, "chestGain", ["p"]), "coins"))}]
static func n_chest_open(k, all) -> void:
	var S = _S(); var ks = J.str(k); var n = J.num(S.chests[ks]) if J.t(all) else minf(1, J.num(S.chests[ks]))
	if not n: return
	var tot = {}
	for i in int(n):
		var g = J.mc(_g("F"), "chestGain", [ks])
		for r in J.keys(g): tot[r] = (J.num(tot[r]) if tot.has(r) else 0.0) + J.num(g[r])
	_snd("chest"); S.chests[ks] = J.num(S.chests[ks]) - n; S.cnt["chest"] = J.num(S.cnt.chest) + n; _fx("toast", ["開箱：" + J.str(_c("give", [tot]))]); _c("save"); m(_ui(), "refresh")
static func _best_backup():
	var S = _S(); var best = null; var key = J.str(_g("SAVE_KEY"))
	for k in ["_hi", "_bak", "_del"]:
		var raw = J.S_localStorage_("getItem", [key + k]); var ob = JSON.parse_string(J.str(raw)) if J.t(raw) else null
		if ob is Dictionary and (J.num(ob.get("lv")) if J.t(ob.get("lv")) else 1.0) > (J.num(S.get("lv")) if J.t(S.get("lv")) else 1.0) and (best == null or J.num(ob.get("lv")) > J.num(best.lv)): best = {"k": k, "lv": ob.get("lv")}
	return best
static func n_story() -> Dictionary:
	var S = _S(); var scenes = []; var su = []; var i = 0
	for e in J.iter(_g("SCENE_ORDER")):
		var ok = false
		for id in J.iter(e[1]): if J.t(S.seen.get(J.str(id))): ok = true; break
		scenes.append({"i": float(i), "name": e[0], "ok": ok}); i += 1
	i = 0
	for st in J.iter(_g("STANDUP")):
		su.append({"i": float(i), "ok": stand_ok(st), "who": J.gp(st, "who"), "title": J.gp(st, "title"), "hint": J.gp(st, "hint")}); i += 1
	var o = {"scenes": scenes, "standup": su, "snd": J.mc(_g("Sound"), "isOn", [])}
	if _has("Bonds") and J.t(J.gp(_g("Bonds"), "_n")): o["bonds"] = J.mc(J.gp(_g("Bonds"), "_n"), "story", [])
	if _has("Skits"):
		var SK = _g("Skits"); var s = J.mc(SK, "st", []); var lst = []; var all = J.iter(J.gp(SK, "list"))
		for k in all: if J.t(J.gp(J.gp(s, "seen"), J.str(J.gp(k, "id")))): lst.append({"id": J.gp(k, "id"), "title": _L(J.gp(k, "title"))})
		o["skits"] = {"list": lst, "total": float(all.size())}
	if _has("Standup"):
		var SU = _g("Standup"); var s = J.mc(SU, "st", [])
		if not J.t(s): s = {"seen": {}}
		var l2 = []
		for b in J.iter(J.gp(SU, "list")): l2.append({"id": J.gp(b, "id"), "seen": J.t(J.gp(J.gp(s, "seen"), J.str(J.gp(b, "id")))), "who": J.gp(b, "who"), "title": _L(J.gp(b, "title")), "hint": "到冥街夜市觀看" if J.t(J.mc(SU, "ok", [b])) else J.gp(b, "hint")})
		o["su"] = l2
	o["restore"] = _best_backup()
	return o
static func n_story_act(a, x):
	var S = _S(); var UI = _ui(); var act = J.str(a)
	if act == "scene":
		m(UI, "close")
		for id in J.iter(_g("SCENE_ORDER")[int(J.num(x))][1]): if J.t(S.seen.get(J.str(id))): J.mc(_g("Story"), "queue", [id])
	if act == "stand":
		m(UI, "close"); var st = _g("STANDUP")[int(J.num(x))]; var lines = J.iter(J.gp(st, "lines")).duplicate(); lines.append(["旁白", J.gp(st, "end")])
		J.mc(_g("Story"), "queue", [{"style": "talk", "bg": J.gp(st, "bg"), "mic": true, "title": J.gp(st, "title"), "lines": lines}])
	if act == "brec": m(UI, "close"); J.mc(J.gp(_g("Bonds"), "_n"), "rec", [x])
	if act == "bfeud": m(UI, "close"); J.mc(J.gp(_g("Bonds"), "_n"), "feud", [x])
	if act == "skit": m(UI, "close"); J.F_setTimeout([func(_t, _a): J.mc(_g("Skits"), "play", [x, true]); return null, 60.0])
	if act == "su": m(UI, "close"); J.F_setTimeout([func(_t, _a): J.mc(_g("Standup"), "play", [x, {"replay": true}]); return null, 60.0])
	if act == "phone": m(UI, "close"); J.mc(_g("Phone"), "home", ["post"])
	if act == "snd":
		var on = J.mc(_g("Sound"), "toggle", []); J.cl(_g("syncSnd"), null, []); return on
	if act == "export": _c("save"); return J.mc(_g("Web"), "enc", [S])
	if act == "restore": return J.S_localStorage_("getItem", [J.str(_g("SAVE_KEY")) + J.str(x)])
	return null
static func n_codex() -> Dictionary:
	var S = _S(); var N = _g("N30W"); var ids = J.iter(J.mc(N, "ids", [])); var road = []
	var rr = J.mc(N, "roadToday", [])
	if rr != null: road = J.iter(rr)
	var got = 0
	for k in ids: if J.t(J.mc(N, "owned", [k])): got += 1
	var wild = J.t(S.cleared.get("1-3"))
	var o = {"got": float(got), "total": float(ids.size()), "wild": wild, "lv": S.lv, "sites": []}
	var SITES = _g("N30_SITES"); var NG = _g("N30_G"); var TIER = _g("N30_TIER"); var GH = _g("GHOSTS"); var SK = _g("SKILLS")
	for sid in ["field", "road", "kampung", "banana", "night", "death"]:
		var lst = []
		for k in ids:
			if J.str(J.gp(NG[J.str(k)], "at")) != sid: continue
			var d = GH[J.str(k)]; var own = J.mc(N, "owned", [k]); var g = NG[J.str(k)]; var T = TIER[J.str(J.gp(g, "t"))]
			var fight = false
			if sid != "night":
				var op = J.mc(N, "open", [k])
				if not J.t(op): fight = op
				elif sid != "death" or road.has(k): fight = wild
			lst.append({"k": k, "own": own, "name": J.gp(d, "name"), "title": J.gp(d, "title"), "lore": J.gp(d, "lore"), "skill": ("【%s】%s" % [J.str(J.gp(SK[J.str(k)], "name")), J.str(J.gp(SK[J.str(k)], "desc"))]) if J.t(own) else "出沒：" + J.str(J.mc(N, "where", [k])), "fight": fight, "req": J.gp(T, "req"), "lvOk": J.num(S.lv) >= J.num(J.gp(T, "req"))})
		o.sites.append({"name": J.gp(SITES[sid], "name"), "list": lst})
	return o

static func make_ui() -> Dictionary:
	var UI = {"tab": "village"}
	UI["modalOpen"] = func(_t, _a): return ui_modal_open()
	UI["refresh"] = func(t, _a): ui_refresh(t if t != null else UI); return null
	UI["open"] = func(t, a): ui_open(t if t != null else UI, J.arg(a, 0)); return null
	UI["sheet"] = func(t, a): ui_sheet(t if t != null else UI, J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null
	UI["close"] = func(t, _a): ui_close(t if t != null else UI); return null
	UI["openBuilding"] = func(t, a): ui_open_building(t if t != null else UI, J.arg(a, 0)); return null
	UI["bldEffect"] = func(_t, a): return ui_bld_effect(J.arg(a, 0))
	UI["postStatTxt"] = func(_t, a): return ui_post_stat_txt(J.arg(a, 0), J.arg(a, 1))
	UI["pickWorker"] = func(t, a): ui_pick_worker(t if t != null else UI, J.arg(a, 0), J.arg(a, 1)); return null
	UI["openRoster"] = func(t, _a): ui_open_roster(t if t != null else UI); return null
	UI["openChests"] = func(t, _a): ui_open_chests(t if t != null else UI); return null
	UI["openStory"] = func(t, _a): ui_open_story(t if t != null else UI); return null
	UI["openBattleSelect"] = func(_t, _a): ui_open_battle_select(); return null
	UI["_n"] = {
		"bld": func(_t, a): return n_bld(J.arg(a, 0)),
		"bldAct": func(_t, a): return n_bld_act(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"pick": func(_t, a): return n_pick(J.arg(a, 0)),
		"pickDo": func(_t, a): n_pick_do(J.arg(a, 0), J.arg(a, 1)); return null,
		"roster": func(_t, _a): return n_roster(),
		"rosterAct": func(_t, a): n_roster_act(J.arg(a, 0), J.arg(a, 1)); return null,
		"chests": func(_t, _a): return n_chests(),
		"_story": func(_t, _a): return n_story(),
		"_storyAct": func(_t, a): return n_story_act(J.arg(a, 0), J.arg(a, 1)),
		"codex": func(_t, _a): return n_codex(),
		"chestOpen": func(_t, a): n_chest_open(J.arg(a, 0), J.arg(a, 1)); return null,
	}
	return UI


# ================= 第五段：主迴圈、開機、全局常數（loop / covered / start / startGame）=================
const FRAME_MS := 1000.0 / 30 - 2
const RES_NAMES := {"wood": "槐木", "rice": "糯米", "planks": "棺材板", "buns": "壽包", "coins": "冥幣", "troops": "陰兵", "bao": "普通包子"}   # [chain] bao 只係顯示用（存喺 S.mat.m_bao）
const SPEAKER_ART := {"阿福": "afu", "小紙": "xiaozhi", "白無常": "baiwu", "黑無常": "heiwu", "黑白無常": "baiwu", "黃總": "huang", "餓鬼王": "eguiking", "餓鬼": "egui", "Toyol": "toyol", "老殭": "laojiang", "Pontianak": "pontianak", "Pocong": "pocong", "Penanggal": "penanggal", "孟婆": "mengpo", "遊魂阿強": "youhun", "天花姐": "tianhua"}
const RES_HELP := {
	"槐木": "槐木：主公親手砍樹，或派鬼怪去<b>伐木場</b>伐木。",
	"糯米": "糯米：主公親手收割，或派鬼怪去<b>糯米田</b>割稻。",
	"棺材板": "棺材板：在<b>棺材鋪</b>把 2 槐木做成 1 板（力量高的鬼做得快）。藍箱也會開出。用來建造和升級建築。",
	"壽包": "壽包：在<b>包子鋪</b>把 2 糯米包成 1 個（智力高的鬼包得快）。綠箱也會開出。用來升級鬼怪、練陰兵。",
	"冥幣": "冥幣：打關卡、開紫箱、燒<b>化寶爐</b>。Toyol 管倉庫時也會「撿到」冥幣。",
	"陰兵": "陰兵：村裡的遊魂見你有地盤，自願加入。<b>民宅</b>越高級來得越快、上限越高。夜班巡陰時每 25 個跟一隊（最多 4 隊），倒下的會扣掉。",
}

static func covered() -> bool:
	for n in ["Patrol", "Scare", "Graveyard", "GhostStreet"]:
		if _has(n) and J.t(J.gp(_g(n), "active")): return true
	if _has("Sports"):
		var SP = _g("Sports")
		if J.t(J.gp(SP, "_g")) and J.t(J.mc(SP, "_g", [])): return true
	return false

static func loop(now: float) -> void:
	J.F_requestAnimationFrame([_g("loop")])
	if now - J.num(_g("lastT")) < FRAME_MS: return
	var dt = minf(0.1, (now - J.num(_g("lastT"))) / 1000); J.G["lastT"] = now
	var ts = J.num(_g("TIME_SCALE")); var B = _g("Battle")
	if not J.t(J.gp(B, "active")):
		_c("produce", [dt * ts]); J.mc(_V(), "update", [dt])
		if not J.t(_c("covered")) and not _has("__nat_village"): J.mc(_V(), "draw", [])
	else:
		_c("produce", [dt * ts]); J.mc(B, "update", [dt]); J.mc(B, "draw", [])
	J.G["uiT"] = J.num(_g("uiT")) + dt
	if J.num(_g("uiT")) > 0.5: J.G["uiT"] = 0.0; m(_ui(), "refresh"); J.mc(_g("Quest"), "check", [])
	J.G["saveT"] = J.num(_g("saveT")) + dt
	if J.num(_g("saveT")) > 5: J.G["saveT"] = 0.0; _c("save")

static func start_game() -> void:
	var S = _c("load")
	var fresh = not J.t(S)
	if not J.t(S): S = _c("newState")
	J.G["S"] = S
	var d = _c("newState")
	for k in d: if not (S as Dictionary).has(k): S[k] = d[k]
	if _has("Guide"): J.mc(_g("Guide"), "migrate", [fresh])
	load("res://game/onboard/ob.gd").migrate(S, fresh)   # [onboard] 第一章新手節奏：主線前段重排＋舊存檔對應
	load("res://game/rebuild/rb.gd").migrate(S, fresh)   # [rebuild] 新存檔：荒村開局
	J.mc(_V(), "init", []); J.mc(_g("Battle"), "init", [])
	for b in _qa("#nav button"):
		var bb = b
		p(b, "onclick", func(_t, _a):
			_snd("click")
			if J.str(J.gp(J.gp(bb, "dataset"), "t")) == "battle" and _has("World"): m(_ui(), "close"); J.mc(_g("World"), "open", []); return null
			m(_ui(), "open", [J.gp(J.gp(bb, "dataset"), "t")]); return null)
	p(_q("#sndtop"), "onclick", func(_t, _a): J.mc(_g("Sound"), "toggle", []); _c("syncSnd"); return null); _c("syncSnd")
	p(_q("#sheet .sh-close"), "onclick", func(_t, _a): m(_ui(), "close"); return null)
	for el in _qa("#resbox .rs"):
		var ee = el
		p(el, "onclick", func(_t, _a):
			var ti = J.str(J.gp(ee, "title"))
			_fx("toast", [J.str(RES_HELP.get(ti)) + ("<br>（建好民宅，遊魂才會來）" if ti == "陰兵" and not J.t(_S().bld.get("home")) else "")]); return null)
	p(_q("#quest"), "onclick", func(_t, _a):
		var pq = J.mc(_V(), "questTarget", []); var q = J.mc(_g("Quest"), "cur", [])
		if J.t(q) and J.str(J.gp(q, "go")) == "roster": m(_ui(), "open", ["roster"]); return null
		if J.t(q) and J.str(J.gp(q, "go")) == "gate" and J.str(J.gp(J.mc(_g("Quest"), "cur", []), "t")) == "stage": m(_ui(), "open", ["battle"]); return null
		if J.t(pq): m(_ui(), "close"); J.mc(_V(), "focus", [pq[0], pq[1]])
		return null)
	var search = J.str(J.gp(_g("location"), "search"))
	if not (J.t(_g("DEBUG")) and search.contains("nophone")): J.mc(_g("Title"), "show", [fresh])
	m(_ui(), "refresh"); J.F_requestAnimationFrame([_g("loop")])
	m(_g("window"), "addEventListener", ["beforeunload", _g("save")])
	J.S_document_("addEventListener", ["visibilitychange", func(_t, _a):
		if J.t(J.gp(J.G.get("document"), "hidden")): _c("save")
		elif J.t(_S()) and not J.t(J.gp(_g("Phone"), "on")): _c("offlineGain")
		return null])

# 村子物件：資料欄位＋方法（第二段邏輯、第三段繪畫）
static func make_village() -> Dictionary:
	return {"cvs": null, "ctx": null, "camY": 0.0, "w": 390.0, "h": 600.0, "dpr": 1.0, "scale": 1.0, "t": 0.0,
		"hero": {"x": 195.0, "y": 350.0, "tx": 195.0, "ty": 350.0, "dir": 1.0, "act": null, "actT": 0.0, "target": null},
		"floats": [], "crows": [], "feathers": [], "drag": null, "workerPhase": {}, "vis": [], "bubble": null, "chatT": 6.0, "chatUsed": {}}

static func install_seg3() -> void:
	var G = J.G
	for n in ["Fx", "JossFx", "Story"]: ORIG[n] = G.get(n)
	for n in ["paintBg", "groundLayer", "drawLily", "postLabel", "syncSnd", "confirmInline", "paintPortraits", "covered", "loop", "start", "startGame"]: ORIG[n] = G.get(n)
	var V: Dictionary = G["Village"]
	for n in ["init", "resize", "pt", "draw", "drawParts", "drawBubble", "drawPointer"]: ORIG["V." + n] = V.get(n)
	V["init"] = func(t, _a): v_init(t if t != null else V); return null
	V["resize"] = func(t, _a): v_resize(t if t != null else V); return null
	V["pt"] = func(t, a): return v_pt(t if t != null else V, J.arg(a, 0))
	V["draw"] = func(t, _a): v_draw(t if t != null else V); return null
	V["drawParts"] = func(t, a): v_draw_parts(t if t != null else V, J.arg(a, 0)); return null
	V["drawBubble"] = func(t, a): v_draw_bubble(t if t != null else V, J.arg(a, 0)); return null
	V["drawPointer"] = func(t, a): v_draw_pointer(t if t != null else V, J.arg(a, 0), J.num(J.arg(a, 1))); return null
	var FX = {"lastPraise": {}}
	FX["float"] = func(_t, a): fx_float(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3)); return null
	FX["toast"] = func(_t, a): fx_toast(J.arg(a, 0)); return null
	FX["banner"] = func(_t, a): fx_banner(J.arg(a, 0)); return null
	FX["praise"] = func(t, a): fx_praise(t if t != null else FX, J.arg(a, 0)); return null
	G["Fx"] = FX
	var JF = {}
	JF["play"] = func(t, _a): joss_play(t if t != null else JF); return null
	G["JossFx"] = JF
	G["Story"] = make_story()
	G["paintBg"] = func(_t, a): paint_bg(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.arg(a, 3), J.arg(a, 4)); return null
	G["groundLayer"] = func(_t, _a): return ground_layer()
	G["drawLily"] = func(_t, a): draw_lily(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3))); return null
	G["postLabel"] = func(_t, a): return post_label(J.arg(a, 0))
	G["syncSnd"] = func(_t, _a): sync_snd(); return null
	G["confirmInline"] = func(_t, a): return confirm_inline(J.arg(a, 0), J.arg(a, 1))
	G["paintPortraits"] = func(_t, a): paint_portraits(J.arg(a, 0)); return null
	ORIG["UI"] = G.get("UI")
	G["UI"] = make_ui()
	G["covered"] = func(_t, _a): return covered()
	G["loop"] = func(_t, a): loop(J.num(J.arg(a, 0))); return null
	G["start"] = func(_t, _a): return null    # 補丁：Godot 由 ui/main.gd 直接叫 startGame
	G["startGame"] = func(_t, _a): start_game(); return null

# ---------------- 安裝 ----------------
# 全部原生；只有對照測試（GB_L2_ORIG=1）先另外載轉譯版，記低 ORIG 嚟比較
static func set_globals() -> void:
	var G = J.G
	G["$"] = func(_t, a): return J.S_document_("querySelector", [J.arg(a, 0)])
	G["RES_NAMES"] = RES_NAMES.duplicate(true); G["SPEAKER_ART"] = SPEAKER_ART.duplicate(true); G["SAVE_KEY"] = "ghostBattles_v1"
	G["DEBUG"] = J.str(J.gp(G.get("location"), "search")).contains("debug")
	G["S"] = null; G["TIME_SCALE"] = 1.0; G["expAcc"] = 0.0
	G["W"] = VW; G["WH"] = VWH
	G["POS"] = {"gate": [195.0, 118.0], "house": [195.0, 300.0], "furnace": [338.0, 258.0], "wood": [92.0, 612.0], "rice": [298.0, 612.0], "plank": [95.0, 752.0], "bun": [295.0, 752.0], "store": [195.0, 872.0], "home": [92.0, 1000.0], "camp": [300.0, 1000.0], "altar": [195.0, 1092.0]}
	var dec = []
	for e in [["webTL", 223, 389], ["webTR", 375, 389], ["scarecrow", 293, 488], ["willo", 258, 438], ["willo", 350, 498], ["willo", 300, 404], ["post", 160, 180], ["post", 230, 180], ["post", 160, 690], ["post", 230, 690], ["post", 160, 945], ["post", 230, 945], ["grave", 26, 840], ["grave", 58, 858], ["grave", 362, 850], ["banana", 372, 560], ["banana", 18, 610], ["banana", 372, 930], ["banana", 20, 1060], ["offer", 150, 320], ["offer", 240, 320], ["grave", 360, 1080], ["offer", 290, 880]]:
		dec.append([e[0], float(e[1]), float(e[2])])
	G["DECOR"] = dec
	G["TREE_POS"] = [[38.0, 402.0], [92.0, 392.0], [146.0, 404.0], [62.0, 452.0], [118.0, 448.0], [168.0, 458.0], [40.0, 506.0], [100.0, 512.0]]
	G["PADDY_POS"] = [[248.0, 412.0], [338.0, 412.0], [248.0, 462.0], [338.0, 462.0], [248.0, 512.0], [338.0, 512.0], [248.0, 562.0], [338.0, 562.0]]
	G["FRAME_MS"] = FRAME_MS; G["lastT"] = J.S_performance_("now", []); G["saveT"] = 0.0; G["uiT"] = 0.0; G["_ground"] = null
	G["F"] = {}; G["Quest"] = {}; G["Village"] = make_village()
	for n in ["fmt", "newState", "save", "load", "fodderCount", "workersAt", "ghostById", "gdef", "ratesPerMin", "produce", "canPay", "pay", "costText", "give", "gainExp", "onLevelUp", "joinGhost", "recruitFodder", "bldUnlocked", "furnaceReady", "standOk", "offlineGain"]:
		G[n] = null

# ---------------- 安裝 ----------------
static func _fn(f: Callable) -> Callable: return f
func run(env) -> void:
	var G = J.G
	if OS.has_environment("GB_L2_ORIG"):
		# 對照測試：先跑轉譯版（jsgen/game.gd），記低原本函數（ORIG），再逐樣換成原生
		_trans = load("res://jsgen/game.gd").new()
		_trans.run(env)
		ORIG = {"F": (G["F"] as Dictionary).duplicate(), "Quest": (G["Quest"] as Dictionary).duplicate()}
	else:
		ORIG = {}
		set_globals()
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
	F["recruitCost"] = func(_t, _a): return {"coins": 150.0, "bao": 20.0}   # [ux] 招魂改用普通包子
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
	install_seg3()
