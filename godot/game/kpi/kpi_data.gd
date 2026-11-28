# [kpi] 區域 KPI 閘門（大排檔前大更新）：資料＋狀態＋規則。全部 static；冇 class_name、冇 autoload（熱更新規矩）
#   const KG = preload("res://game/kpi/kpi_data.gd")
# 資料：data/nat/kpi.json（tools/kpi_build.py 由文案劇本產生）。maps["<ci>"].gates = 按次序嘅考核閘門。
# 狀態：S.kpi = {"v":1, "on":bool, "g":{"<ci>:<gid>":{st,left,mods,skip,add,bribed,ok,stolen,bryan,rebribe,started}},
#               "carry_plus":0.0（拍照：下一區 +10%）, "disc":0.0, "ok_n":{boss:true}, "honest":n}
#
# 規則（設計 4.1–4.3，懲罰定「中」）：
#   閘門按次序：上一個達標，下一個先 active。資源區閘門要該區已介紹（ZD.revealed）先 active。
#   開考核（第一次撳考核牌，播「巡查」）先開始倒數 left 秒；倒數只計遊戲開住嘅時間。
#   全部指標達標 → 交考核 → 播「達標」→ 開區（zone:X → ZD.set_owned＋zone_cap 劇情；flag:X → is_open）
#   賄賂（每區一次）：牛頭收名牌（名錶／跑車）、馬面收食物（點心）
#     點心→馬面：最差嗰項指標 -20%；點心→牛頭：-10%（送錯減半）
#     名錶→牛頭：最差嗰項免考；風險 20% 馬面拍照存證 → 下一區 KPI +10%
#     跑車→牛頭：全部指標 -40%；風險 30% 老闆撞破 → 禮物充公、該區抓包後果（kpi.json caught）、下次賄賂半價
#     名牌（名錶／跑車）→馬面：失敗，禮物退回，該區 fail_add 加 KPI（同劇本台詞一致）
#     龐總（nobribe）：唔收賄賂，送包子只會記入誠信檔案
#   逾期（中）：Bryan 搶功 —— 拎走倉庫最多嗰樣資源 10%、村口掛「本月最佳員工：Bryan」橫幅、倒數重來；
#              達標時撕橫幅、追回被搶總數一半
#   開關：預設關（舊流程照舊）；vil2 新開局叫 enable()。GB_NOKPI 環境變數強制關。
#   後備指標（其他模組未登記時）：rebuilt＝村子建築 Lv≥1 數；named_hired／named_working＝名鬼數／有崗位名鬼數；
#     self_sufficient＝五種一級資源存量 ≥ 50 嘅種數
extends RefCounted

const PATH := "res://data/nat/kpi.json"
const VILLAGE_BLDS := ["house", "wood", "rice", "plank", "bun", "store", "home", "camp", "altar", "furnace"]
const STEAL_POOL := ["m_wood", "m_rice", "m_plank", "m_bamboo", "m_wellwater", "m_straw", "m_bao", "coins"]
const SELF_RES := ["m_wood", "m_rice", "m_bamboo", "m_wellwater", "m_straw"]
static var _D = null
static var _fns := {}        # 指標提供者：key → Callable() -> float（vil2／酒館登記）
static var _opens := []       # 開區回調：Callable(gid, opens)（vil2 登記：開酒館、開大排檔等）
static var rng_fn := Callable()   # 測試用：Callable() -> float（0..1）
static var _last_ms := -1
static var NEWS: Array = []   # 結果（UI 讀）：{kind, gid, ...}

static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {"maps": {}, "bribes": {}, "scenes": {}}
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func ZD(): return load("res://game/zone/zone_data.gd")
static func M(): return load("res://game/outpost/mat.gd")
static func ci() -> int: return ZD().ci()
static func zh() -> bool: return DB.lang != "yue"
static func _rand() -> float: return float(rng_fn.call()) if rng_fn.is_valid() else randf()

# ---------------- 開關／登記 ----------------
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("kpi") is Dictionary): s["kpi"] = {"v": 1.0, "on": false, "g": {}, "carry_plus": 0.0, "disc": 0.0, "ok_n": {}, "honest": 0.0}
	var k = s.kpi
	for f in ["g", "ok_n"]: if not (k.get(f) is Dictionary): k[f] = {}
	return k
static func enable(on := true) -> void:
	var k = st()
	if k == null: return
	k["on"] = on
	if on: _migrate()
static func on_for(c: int) -> bool:
	if OS.has_environment("GB_NOKPI"): return false
	var k = st()
	return k != null and J.t(k.get("on")) and not gates(c).is_empty()
static func on() -> bool: return on_for(ci())
static func register_metric(key: String, fn: Callable) -> void: _fns[key] = fn
static func on_open(fn: Callable) -> void: if not _opens.has(fn): _opens.append(fn)

# ---------------- 資料 ----------------
static func gates(c := -1) -> Array:
	var m = D().get("maps", {}).get(str(ci() if c < 0 else c))
	return m.get("gates", []) if m is Dictionary else []
static func gate(gid: String, c := -1) -> Dictionary:
	for g in gates(c): if str(g.id) == gid: return g
	return {}
static func gate_for_zone(zid: String, c := -1) -> String:
	for g in gates(c): if str(g.get("opens", "")) == "zone:" + zid: return str(g.id)
	return ""
static func bribe_def(tier: String) -> Dictionary: return D().get("bribes", {}).get(tier, {})
static func _k(gid: String, c := -1) -> String: return "%d:%s" % [ci() if c < 0 else c, gid]
static func gs(gid: String, c := -1) -> Dictionary:
	var k = st()
	if k == null: return {}
	var key = _k(gid, c)
	if not (k.g.get(key) is Dictionary):
		k.g[key] = {"ok": false, "started": false, "left": float(gate(gid, c).get("time", 1200)), "mods": {}, "skip": {}, "add": {}, "bribed": false, "stolen": {}, "bryan": 0.0, "rebribe": false, "plus": 0.0}
	var g = k.g[key]
	for f in ["mods", "skip", "add", "stolen"]: if not (g.get(f) is Dictionary): g[f] = {}
	return g

# ---------------- 狀態查詢（vil2／UI 用） ----------------
static func passed(gid: String, c := -1) -> bool: return J.t(gs(gid, c).get("ok"))
static func is_open(flag: String, c := -1) -> bool:   # flag:tavern／market／pang → 嗰個閘門達標未（KPI 關咗＝當開咗，舊流程照舊）
	if not on_for(ci() if c < 0 else c): return true
	for g in gates(c): if str(g.get("opens", "")) == "flag:" + flag: return passed(str(g.id), c)
	return true
static func active_gate(c := -1) -> String:   # 而家輪到邊個閘門（"" = 全部達標）
	for g in gates(c):
		if not passed(str(g.id), c): return str(g.id)
	return ""
static func active(gid: String, c := -1) -> bool:
	if not on_for(ci() if c < 0 else c) or passed(gid, c) or active_gate(c) != gid: return false
	var op = str(gate(gid, c).get("opens", ""))
	if op.begins_with("zone:") and not ZD().revealed(op.substr(5), c): return false
	return true
static func gated(zid: String, c := -1) -> bool:   # 資源區由考核開（攻佔／親征都唔得）
	if not on_for(ci() if c < 0 else c): return false
	var gid = gate_for_zone(zid, c)
	return gid != "" and not passed(gid, c)

# ---------------- 指標 ----------------
static func _metric(key: String, kind: String) -> float:
	var s = S()
	if s == null: return 0.0
	match kind:
		"res": return J.num(s.get("res", {}).get(key, 0)) if s.get("res") is Dictionary else 0.0
		"mat": return M().amt(key)
		"bld": return J.num(s.get("bld", {}).get(key, 0)) if s.get("bld") is Dictionary else 0.0
	if _fns.has(key) and (_fns[key] as Callable).is_valid(): return float(_fns[key].call())
	match key:
		"rebuilt":
			var n = 0
			var b = s.get("bld") if s.get("bld") is Dictionary else {}
			for k in VILLAGE_BLDS: if J.num(b.get(k, 0)) >= 1: n += 1
			return float(n)
		"named_hired", "named_working":
			var GH = J.G.get("GHOSTS"); var n2 = 0
			for g in J.iter(s.get("ghosts")):
				if not (g is Dictionary) or not (GH is Dictionary) or not GH.has(str(g.get("k", ""))): continue
				if key == "named_working" and (g.get("post") == null or str(g.post) == ""): continue
				n2 += 1
			return float(n2)
		"self_sufficient":
			var n3 = 0
			for m in SELF_RES: if M().amt(m) >= 50.0: n3 += 1
			return float(n3)
	return 0.0
static func amt_of(key: String) -> float:   # 被搶／追回用：coins 係 S.res，其餘經 mat.gd
	if key == "coins": return _metric("coins", "res")
	return M().amt(key)
static func give(key: String, n: float) -> void:
	var s = S()
	if s == null or n == 0.0: return
	if key == "coins":
		if not (s.get("res") is Dictionary): s["res"] = {}
		s.res["coins"] = maxf(0.0, J.num(s.res.get("coins", 0)) + n)
	else:
		if n > 0: M().add(key, n)
		else: M().take({key: -n})
# 每項指標：[{key,label,cur,need,base,skip,met}]（need 已計賄賂、抓包、拍照）
static func progress(gid: String, c := -1) -> Array:
	var g = gate(gid, c); var st0 = gs(gid, c); var o = []
	var plus = J.num(st0.get("plus", 0.0))
	for i in g.get("need", []).size():
		var nd = g.need[i]; var key = str(nd.key)
		var base = float(nd.n)
		var mul = J.num(st0.mods.get(key, 1.0))
		var need = int(ceil(base * mul * (1.0 + plus) - 0.0001)) + int(J.num(st0.add.get(key, 0)))
		need = maxi(1, need)
		var sk = J.t(st0.skip.get(key))
		var cur = _metric(key, str(nd.kind))
		o.append({"key": key, "label": str(nd.label), "cur": cur, "need": need, "base": base, "skip": sk, "met": sk or cur >= need})
	return o
static func all_met(gid: String, c := -1) -> bool:
	for p in progress(gid, c): if not p.met: return false
	return true
static func met_count(gid: String, c := -1) -> Array:
	var p = progress(gid, c); var n = 0
	for x in p: if x.met: n += 1
	return [n, p.size()]
static func _worst(gid: String) -> String:   # 進度最差（未達標、未免考）嗰項
	var best = ""; var r0 = 9.0
	for p in progress(gid):
		if p.skip or p.met: continue
		var r = p.cur / maxf(1.0, p.need)
		if r < r0: r0 = r; best = p.key
	if best == "":
		for p in progress(gid): if not p.skip: return p.key
	return best

# ---------------- 開考核／倒數／逾期（Bryan 搶功） ----------------
static func start(gid: String) -> bool:   # 播完「巡查」叫；回 true＝第一次
	var g = gs(gid)
	if J.t(g.get("started")): return false
	g["started"] = true; g["left"] = float(gate(gid).get("time", 1200))
	if gid == "tavern" and not J.t(g.get("fee")):   # 錢不漏巡查：路費茶水費等四十二冥幣（劇本 kpi_qian_open）
		g["fee"] = minf(42.0, amt_of("coins")); give("coins", -J.num(g.fee))
	_save()
	return true
static func tick(dt := -1.0) -> void:
	if dt < 0.0:
		var now = Time.get_ticks_msec()
		dt = 0.0 if _last_ms < 0 else clampf(float(now - _last_ms) / 1000.0, 0.0, 1.0)
		_last_ms = now
	if not on(): return
	var gid = active_gate()
	if gid == "" or not active(gid): return
	var g = gs(gid)
	if not J.t(g.get("started")): return
	g["left"] = J.num(g.left) - dt
	if J.num(g.left) <= 0.0: overdue(gid)
static func overdue(gid: String) -> Dictionary:
	var g = gs(gid)
	g["left"] = float(gate(gid).get("time", 1200))   # 倒數重來
	var best = ""; var bv = 0.0
	for m in STEAL_POOL:
		var v = amt_of(m)
		if v > bv: bv = v; best = m
	var take = floorf(bv * 0.1)
	var out = {"kind": "bryan", "gid": gid, "mid": best, "n": take, "first": J.num(g.get("bryan", 0)) < 1}
	g["bryan"] = J.num(g.get("bryan", 0)) + 1.0
	if best != "" and take > 0:
		give(best, -take)
		g.stolen[best] = J.num(g.stolen.get(best, 0)) + take
	NEWS.append(out); _save()
	return out
static func banner_on(c := -1) -> bool:   # 村口「本月最佳員工：Bryan」橫幅
	if not on_for(ci() if c < 0 else c): return false
	for g in gates(c):
		var s0 = gs(str(g.id), c)
		if not J.t(s0.get("ok")) and J.num(s0.get("bryan", 0)) > 0: return true
	return false
static func stolen_txt(gid: String) -> String:
	var a = []
	for m in gs(gid).stolen: a.append("%s ×%d" % [mname(m), int(J.num(gs(gid).stolen[m]))])
	return "、".join(a)
static func mname(m: String) -> String:
	if m == "coins": return "冥幣"
	return M().name(m)

# ---------------- 交考核 ----------------
static func submit(gid: String) -> Dictionary:
	if not active(gid): return {"ok": false, "why": "inactive"}
	if not all_met(gid): return {"ok": false, "why": "unmet"}
	var g = gs(gid)
	g["ok"] = true
	var back = {}
	for m in g.stolen:   # 撕橫幅：追回一半
		var h = floorf(J.num(g.stolen[m]) * 0.5)
		if h > 0: give(m, h); back[m] = h
	var had_banner = J.num(g.get("bryan", 0)) > 0
	var gd = gate(gid)
	var k = st()
	var nx = _next_gid(gid)
	if nx != "" and J.num(k.get("carry_plus", 0.0)) > 0.0:
		gs(nx)["plus"] = J.num(k.carry_plus); k["carry_plus"] = 0.0
	var op = str(gd.get("opens", ""))
	if op.begins_with("zone:"):
		var zid = op.substr(5)
		if not ZD().owned(zid):
			ZD().set_owned(zid)
			ZD().ev("zone_cap", zid)   # 原本攻佔劇情（zs0_zone_cap_*）改由考核達標觸發
	for f in _opens: if (f as Callable).is_valid(): f.call(gid, op)
	var egg = gid == "market" and _all_bribed_ok()
	var out = {"ok": true, "kind": "pass", "gid": gid, "opens": op, "back": back, "banner": had_banner, "egg": egg}
	NEWS.append(out); _save()
	return out
static func _next_gid(gid: String) -> String:
	var gl = gates(); var hit = false
	for g in gl:
		if hit: return str(g.id)
		if str(g.id) == gid: hit = true
	return ""
static func _all_bribed_ok() -> bool:
	var k = st()
	for b in ["chen", "he", "qian", "dato", "nuo"]: if not J.t(k.ok_n.get(b)): return false
	return true

# ---------------- 賄賂 ----------------
# tier：snack／watch／car；to：niu（牛頭）／ma（馬面）
static func bribe_cost(tier: String) -> Dictionary:
	var c = (bribe_def(tier).get("cost", {}) as Dictionary).duplicate()
	var d = J.num(st().get("disc", 0.0)) if st() != null else 0.0
	if d > 0.0: for k in c: c[k] = ceilf(J.num(c[k]) * (1.0 - d))
	return c
static func can_pay(cost: Dictionary) -> bool:
	for k in cost: if amt_of(str(k)) < J.num(cost[k]): return false
	return true
static func _pay(cost: Dictionary, sign := -1.0) -> void:
	for k in cost: give(str(k), sign * J.num(cost[k]))
static func can_bribe(gid: String) -> String:   # "" = 得；否則講原因
	if not active(gid): return "inactive"
	var gd = gate(gid)
	if J.t(gd.get("nobribe")): return "nobribe"
	var g = gs(gid)
	if J.t(g.get("bribed")) and not J.t(g.get("rebribe")): return "used"
	return ""
static func bribe(gid: String, tier: String, to: String) -> Dictionary:
	var why = can_bribe(gid)
	if why != "": return {"ok": false, "why": why}
	var bd = bribe_def(tier)
	if bd.is_empty(): return {"ok": false, "why": "tier"}
	var cost = bribe_cost(tier)
	if not can_pay(cost): return {"ok": false, "why": "poor"}
	var g = gs(gid); var gd = gate(gid); var k = st()
	var rebribe = J.t(g.get("rebribe"))
	g["bribed"] = true; g["rebribe"] = false
	_pay(cost)
	if J.num(k.get("disc", 0.0)) > 0.0: k["disc"] = 0.0   # 半價用咗一次
	var typ = str(bd.get("type", "food"))
	var out = {"ok": true, "kind": "bribe", "gid": gid, "tier": tier, "to": to, "boss": str(gd.boss), "res": "ok", "eff": "", "key": ""}
	# 名牌送馬面：失敗（退回、加 KPI）
	if to == "ma" and typ == "brand":
		_pay(cost, 1.0)
		for key in gd.get("fail_add", {}): g.add[key] = J.num(g.add.get(key, 0)) + J.num(gd.fail_add[key])
		out["res"] = "fail"; out["add"] = gd.get("fail_add", {})
		NEWS.append(out); _save(); return out
	var half = (to == "niu" and typ == "food")   # 送錯：效果減半
	var risk = str(bd.get("risk", "none")); var p = J.num(bd.get("p", 0.0))
	if risk == "caught" and not rebribe and _rand() < p:
		var cg = gd.get("caught", {})
		if not J.t(cg.get("lose", true)): out["kept"] = true   # 何大睡：禮物照收（反而 KPI 減半）
		for key in cg.get("add", {}): g.add[key] = J.num(g.add.get(key, 0)) + J.num(cg.add[key])
		if cg.get("mul_all") != null:
			for nd in gd.need: g.mods[str(nd.key)] = J.num(g.mods.get(str(nd.key), 1.0)) * J.num(cg.mul_all)
		if J.t(cg.get("rebribe")): g["rebribe"] = true
		k["disc"] = 0.5   # 心虛：下次賄賂半價
		out["res"] = "caught"; out["caught"] = cg
		NEWS.append(out); _save(); return out
	var v = J.num(bd.get("val", 0.2)) * (0.5 if half else 1.0)
	match str(bd.get("eff", "")):
		"cut1":
			var key1 = _worst(gid)
			g.mods[key1] = J.num(g.mods.get(key1, 1.0)) * (1.0 - v)
			out["eff"] = "cut1"; out["key"] = key1; out["val"] = v
		"skip1":
			var key2 = _worst(gid)
			if half: g.mods[key2] = J.num(g.mods.get(key2, 1.0)) * 0.5; out["eff"] = "cut1"; out["val"] = 0.5
			else: g.skip[key2] = true; out["eff"] = "skip1"
			out["key"] = key2
		"cutall":
			for nd in gd.need: g.mods[str(nd.key)] = J.num(g.mods.get(str(nd.key), 1.0)) * (1.0 - v)
			out["eff"] = "cutall"; out["val"] = v
	out["half"] = half
	k.ok_n[str(gd.boss)] = true
	if risk == "photo" and _rand() < p:
		k["carry_plus"] = 0.1   # 下一區 KPI +10%
		out["photo"] = true
	NEWS.append(out); _save()
	return out
static func gift_pang(gid: String) -> Dictionary:   # 龐總唔收賄賂：送一籠包子＝記入誠信檔案
	if not active(gid) or not J.t(gate(gid).get("nobribe")): return {"ok": false}
	if M().amt("m_bao") < 10.0: return {"ok": false, "why": "poor"}
	M().take({"m_bao": 10.0})
	var k = st(); k["honest"] = J.num(k.get("honest", 0)) + 1.0
	_save()
	return {"ok": true, "kind": "pang_gift"}

# ---------------- 舊存檔／開局遷移 ----------------
# 已佔領嘅資源區＝嗰個閘門（同之前全部）當達標（enable() 只係 vil2 新開局叫，舊存檔唔會開 KPI）
static func _migrate() -> void:
	var gl = gates()
	var last = -1
	for i in gl.size():
		var op = str(gl[i].get("opens", ""))
		if op.begins_with("zone:") and ZD().owned(op.substr(5)): last = i
	for i in last + 1: gs(str(gl[i].id))["ok"] = true

static func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])
