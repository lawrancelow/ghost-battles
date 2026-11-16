# L2 行為探針：同一套步驟，原生同轉譯版各跑一次（GB_NAT_EXTRA 有／冇），印出 [probe] 行再 diff
extends RefCounted

static func _p(tag: String, v) -> void: print("[probe] ", tag, " = ", JSON.stringify(v, "", true).substr(0, 1500))

func pol_first(_t) -> void:
	var S = J.G.S
	S.seen.erase("policy_station"); S.seen.erase("policy_tower")
	J.mc(J.G.Policy, "firstEnter", ["tower"])
	_p("seen_tower", S.seen.get("policy_tower"))
	_p("tips", J.G.Policy.TIPS)

func pol_tip(_t) -> void:
	var el = J.mc(J.G.document, "getElementById", ["pol-tip"])
	_p("tip_html", J.gp(el, "innerHTML") if el != null else null)
	if el != null: J.mc(el, "click", [])
	el = J.mc(J.G.document, "getElementById", ["pol-tip"])
	_p("tip_html2", J.gp(el, "innerHTML") if el != null else null)

func pol_ann(_t) -> void:
	J.mc(J.G.Policy, "announce", [])
	_p("theater_on", J.gp(J.G.Theater, "on"))

func nat(_t) -> void:
	var o = []
	for m in JSRun.modules:
		var pth = m.get_script().resource_path
		if pth.begins_with("res://native/"): o.append(pth.get_file())
	_p("native_used", o)

func bonds_a(_t) -> void:
	var B = J.G.Bonds; var S = J.G.S
	_p("st", J.mc(B, "st", []))
	_p("story0", J.mc(J.gp(B, "_n"), "story", []))
	var fl = J.gp(B, "list")
	# 造幾個冤家狀態
	var ends = ["friends", "rivals", "united"]
	var i = 0
	for F in fl:
		S.bonds.feud[F.id] = {"st": 2.0 if i % 2 == 0 else 1.0, "picks": ["a", "b"], "wait": 0.0, "end": ends[i % 3] if i % 2 == 0 else null}
		i += 1
	_p("story1", J.mc(J.gp(B, "_n"), "story", []))
	var ks = J.G.GHOSTS.keys()
	var lines = {}
	for k in ks: lines[k] = J.mc(B, "bondLine", [k])
	_p("bondLine", lines)
	_p("endOf", [J.mc(B, "endOf", [["a", "a"]]), J.mc(B, "endOf", [["a", "b"]]), J.mc(B, "endOf", [["c", "a"]])])
	# 戰鬥加成：每個冤家兩隻鬼同隊
	var res = []
	for F in fl:
		var units = [{"side": 0.0, "k": F.a, "atk": 100.0, "hp": 500.0, "maxhp": 500.0, "energy": 10.0}, {"side": 0.0, "k": F.b, "atk": 80.0, "hp": 400.0, "maxhp": 400.0}, {"side": 1.0, "k": "youhun", "atk": 50.0, "hp": 100.0, "maxhp": 100.0}]
		J.mc(B, "battleFx", [units])
		res.append(units)
	_p("battleFx", res)
	var fake = [{"side": 0.0, "k": "afu", "atk": 1.0}]
	J.mc(B, "battleFx", [fake]); _p("battleFx0", fake)

func bonds_play(_t) -> void:
	var B = J.G.Bonds
	var recs = J.gp(B, "recruits")
	var kinds = {}
	for k in recs: kinds[J.str(recs[k].get("f"))] = k
	_p("rec_kinds", kinds)
	J.G["_l2_k"] = kinds.get("chat", kinds.values()[0])
	_p("play_chat", J.mc(B, "playRecruit", [J.G._l2_k, null, {"r": "xiaozhi"}]))

func bonds_play2(_t) -> void:
	_p("story_on", J.gp(J.G.Story, "on"))
	var B = J.G.Bonds
	var recs = J.gp(B, "recruits")
	var kk = null
	for k in recs: if J.str(recs[k].get("f")) == "hr": kk = k
	_p("play_hr", J.mc(B, "playRecruit", [kk, null, {"r": "xiaozhi"}]))
	_p("theater_on", J.gp(J.G.Theater, "on"))

# 數字四捨五入到 2 位（兩次運行相差幾十秒，流失會有極細差）
static func _r(v):
	if v is float: return snappedf(v, 0.01)
	if v is Array:
		var o = []
		for x in v: o.append(_r(x))
		return o
	if v is Dictionary:
		var o = {}
		for k in v: if not (v[k] is Callable): o[k] = _r(v[k])
		return o
	return v
static func _q(tag: String, v) -> void: _p(tag, _r(v))

func pres_a(_t) -> void:
	var P = J.G.Presence; var S = J.G.S
	_q("st_keys", J.mc(P, "st", []).keys())
	_q("cst", J.mc(P, "cst", []))
	for f in ["squad", "decay", "ripple", "atk", "zzz"]: _q("perk_" + f, J.mc(P, "perk", [f]))
	var vals = {}
	for g in S.ghosts: vals[g.id] = [J.mc(P, "val", [g]), J.mc(P, "statMult", [g]), J.mc(P, "daysLeft", [g])]
	_q("vals", vals)
	_q("kpi", [J.mc(P, "kpiOf", [{"stars": 3.0, "legendLv": 7.0, "score": 10.0}]), J.mc(P, "kpiOf", [{"stars": 1.7, "exorcised": true}]), J.mc(P, "kpiOf", [{}])])
	_q("panel", J.mc(J.gp(P, "_n"), "panel", []))
	_q("panelHTML", J.mc(P, "panelHTML", []))
	_q("playing", J.gp(P, "playing"))
	_q("tune", J.gp(P, "TUNE"))

func pres_b(_t) -> void:
	var P = J.G.Presence; var S = J.G.S
	# 開合約
	J.mc(J.gp(P, "dev"), "issue", [])
	var gs = S.ghosts
	var r = J.mc(P, "nightEnd", [{"stars": 2.0, "legendLv": 3.0, "score": 50.0, "loc": "office", "ghosts": [gs[1].id, gs[2].k], "perGhost": {gs[1].id: {"scares": 4.0}, gs[3].k: {"scares": 9.0}}}])
	_q("night", r)
	_q("cst2", J.mc(P, "cst", []))
	_q("pres2", J.mc(P, "st", []).p)
	_q("haunt", J.mc(P, "st", []).haunt)
	# 撥快 20 日：流失、警告、倒數、合約危機
	J.mc(J.gp(P, "dev"), "days", [20.0])
	_q("pres3", J.mc(P, "st", []).p)
	_q("warn", J.mc(P, "st", []).warn.keys())
	var sc = []
	for s in J.mc(J.gp(P, "dev"), "scenes", []): sc.append(s.kind)
	_q("scenes", sc)
	J.mc(J.gp(P, "_n"), "offer", [gs[1].id])
	_q("after_offer", [J.mc(P, "val", [gs[1]]), S.res.buns])
	J.mc(J.gp(P, "_n"), "offer", [gs[1].id])
	_q("after_offer2", [J.mc(P, "val", [gs[1]]), S.res.buns])
	_q("panel2", J.mc(J.gp(P, "_n"), "panel", []))
	# 魂飛魄散＋重新招魂
	var g = gs[gs.size() - 1]
	var name = g.name
	J.mc(J.gp(P, "dev"), "vanish", [g])
	_q("gone", J.mc(P, "st", []).gone.size())
	_q("ghosts_n", S.ghosts.size())
	var ng = J.mc(J.gp(P, "dev"), "resummon", [0.0, true])
	_q("resummon", [name, J.gp(ng, "name"), J.gp(ng, "lv"), S.ghosts.size(), J.mc(P, "val", [ng])])
	J.mc(P, "hud", [])
	_q("battle_mk", J.mc(J.G.Battle, "mkGhostUnit", [gs[0]]).atk if J.G.Battle.get("mkGhostUnit") != null else null)

func pres_c(_t) -> void:
	var P = J.G.Presence; var g = J.G.S.ghosts[0]
	var u = J.mc(J.G.Battle, "mkGhostUnit", [g, 0.0])
	_p("mk", [g.k, J.mc(P, "val", [g]), J.mc(P, "statMult", [g]), J.mc(P, "perk", ["atk"]), u.atk, u.hp, J.mc(J.G.GP, "drillMul", [g.k]), J.mc(J.G.F, "stat", [g, 2.0])])
	var c = J.mc(P, "cst", [])
	_p("state", [c.state, c.rank])

func dbg(_t) -> void:
	var cb = J.G.Battle.get("mkGhostUnit")
	_p("mk_cb", [str(cb), str(J.G.Battle.get("finish")), str(J.G.Village.get("update")), str(J.G.Theater.get("play"))])
	var sc = load("res://native/presence.gd")
	_p("started", [sc.started, sc.TU.size()])

func wraps(_t) -> void:
	var o = {}
	o["Battle.mkGhostUnit"] = str(J.G.Battle.get("mkGhostUnit")); o["Battle.finish"] = str(J.G.Battle.get("finish")); o["Battle.hit"] = str(J.G.Battle.get("hit"))
	o["Village.update"] = str(J.G.Village.get("update")); o["Theater.play"] = str(J.G.Theater.get("play")); o["Rivals.tick"] = str(J.G.Rivals.get("tick"))
	o["joinGhost"] = str(J.G.get("joinGhost")); o["UI.openStory"] = str(J.G.UI.get("openStory")); o["GS.battleBuffs"] = str(J.G.GhostStreet.get("battleBuffs"))
	o["Scare.start"] = str(J.G.Scare.get("start")); o["ART.drawChar"] = str(J.G.ART.get("drawChar"))
	_p("wraps", o)
	var res = []
	for m in ["rework", "bonds", "presence"]:
		var sc = load("res://native/%s.gd" % m)
		res.append([m, sc.started])
	_p("started", res)

# ---- 細模塊批次：guide、audio、scene、phone、special ----
static func _rec_ctx():
	var r = Recorder.new()
	return [r, Ctx.new(r, Transform2D.IDENTITY)]
static func _ops(r) -> Array:
	var kinds = {}
	for c in r.cmds: kinds[c[0]] = kinds.get(c[0], 0) + 1
	return [r.cmds.size(), kinds]

func small(_t) -> void:
	var S = J.G.S
	# guide
	var Q = J.G.QUESTS; var qs = []
	for q in Q: qs.append([q.get("t"), q.get("s"), q.get("place")])
	_q("quests", qs)
	_q("scenes_q", [J.G.SCENES.get("q_street"), J.G.SCENES.get("q_yard")])
	_q("guide", [J.mc(J.G.Guide, "anyDot", []), S.get("visit"), S.get("wmSeen"), S.get("qv"), S.get("qi")])
	var dots = {}
	for sp in J.iter(J.gp(J.G.World, "SPOTS")): dots[J.gp(sp, "id")] = J.mc(J.G.Guide, "dot", [J.gp(sp, "id")])
	_q("dots", dots)
	var keep = [S.get("qv"), S.get("qi")]
	S["qv"] = 1.0; S["qi"] = 12.0; J.mc(J.G.Guide, "migrate", [false]); _q("migrate", [S.qv, S.qi])
	S["qv"] = keep[0]; S["qi"] = keep[1]
	var r = _rec_ctx(); J.mc(J.G.Guide, "drawGateDot", [r[1], 10.0, 20.0, 1.5]); _q("gatedot_ops", _ops(r[0]))
	# audio
	_q("sound", [J.G.Sound.keys(), J.mc(J.G.Sound, "isOn", [])])
	# phone
	_q("chats_pre", J.G.CHATS_PRE)
	_q("chats_post", J.cl(J.G.chatsPost, null, []))
	_q("icon", J.G.ICON)
	_q("tick", [J.cl(J.G.TICK, null, [true, true]), J.cl(J.G.TICK, null, [false, false])])
	_q("wastat", [J.cl(J.G.waStatus, null, ["02:13", "3%", true]), J.cl(J.G.waStatus, null, ["11:00", "∞", false])])
	_q("waav", J.cl(J.G.waAvatar, null, [["媽", "#b06a5a"], 50.0]))
	_q("phone_keys", J.G.Phone.keys())
	# scene：每樣嘢畫入錄製器，比指令數
	var A = J.G.ART; var out = {}
	for b in ["house", "gate", "plank", "bun", "wood", "rice", "store", "home", "camp", "altar", "furnace"]:
		r = _rec_ctx(); J.mc(A, "drawBuilding", [r[1], b, 100.0, 200.0, 3.0, 1.2, true]); out["b_" + b] = _ops(r[0])
	r = _rec_ctx(); J.mc(A, "drawGate", [r[1], 100.0, 200.0, 1.0]); out["gate"] = _ops(r[0])
	for hp in [0.0, 5.0]:
		for sh in [false, true]:
			for idx in [0.0, 1.0]:
				r = _rec_ctx(); J.mc(A, "drawTree", [r[1], 100.0, 200.0, hp, 1.3, sh, true, idx]); out["tree_%s_%s_%s" % [hp, sh, idx]] = _ops(r[0])
	for rp in [true, false]:
		r = _rec_ctx(); J.mc(A, "drawPaddy", [r[1], 50.0, 60.0, rp, 1.0, 0.0]); out["paddy_%s" % rp] = _ops(r[0])
	for k in ["scarecrow", "grave", "post", "banana", "zzz"]:
		r = _rec_ctx(); J.mc(A, "drawDecor", [r[1], k, 50.0, 60.0, 1.0]); out["decor_" + k] = _ops(r[0])
	for pc in [true, false]:
		r = _rec_ctx(); J.mc(A, "drawCrow", [r[1], 50.0, 60.0, 1.0, 0.3, -1.0, pc]); out["crow_%s" % pc] = _ops(r[0])
	for bg in ["village", "hq", "field", "nope"]:
		r = _rec_ctx(); out["bg_" + bg] = [J.mc(J.G.SCENE, "drawBg", [r[1], 390.0, 700.0, bg]), _ops(r[0])]
	_q("scene", out)
	# special
	var sp = {}
	for k in ["penanggal", "pocong", "toyol", "afu"]: sp["has_" + k] = J.mc(J.G.SPECIAL, "has", [k])
	for k in ["penanggal", "pocong", "toyol"]:
		for o in [{"t": 1.0}, {"t": 2.0, "walk": true}, {"t": 0.5, "pose": "strike", "pt": 0.5}, {"t": 0.5, "pose": "hurt", "pt": 0.3}]:
			r = _rec_ctx(); J.mc(J.G.SPECIAL, "draw", [r[1], k, 100.0, 200.0, 1.0, o]); sp["%s_%s" % [k, JSON.stringify(o)]] = _ops(r[0])
	_q("special", sp)

# ---- game 第一段：同一進程，原生 vs 轉譯版（native/game.gd 存咗 ORIG）----
var gok := 0
var gbad := 0
func _gcmp(name: String, a, b) -> void:
	var x = JSON.stringify(_r(a)); var y = JSON.stringify(_r(b))
	if x == y: gok += 1
	else:
		gbad += 1
		if gbad <= 25:
			var i = 0
			while i < mini(x.length(), y.length()) and x[i] == y[i]: i += 1
			var st = maxi(0, i - 120)
			print("[gdiff] %s @%d nat=…%s tr=…%s" % [name, i, x.substr(st, 260), y.substr(st, 260)])
# 喺 S 嘅深拷貝上各跑一次，比結果同 S
func _gstate(name: String, f_nat: Callable, f_tr: Callable) -> void:
	var S0 = J.G.S; var acc0 = J.G.get("expAcc")
	var s1 = S0.duplicate(true); J.G["S"] = s1; J.G["expAcc"] = acc0; var r1 = f_nat.call()
	var s2 = S0.duplicate(true); J.G["S"] = s2; J.G["expAcc"] = acc0; var r2 = f_tr.call()
	J.G["S"] = S0; J.G["expAcc"] = acc0
	_gcmp(name + ":ret", r1, r2); _gcmp(name + ":S", s1, s2)

func game1(_t) -> void:
	var NG = load("res://native/game.gd"); var O = NG.ORIG; var G = J.G
	var F = G.F; var OF = O.F; var S = G.S
	for n in [0, 5, 9999, 10000, 12345.6, 999999, 1000000, 2.5e7]: _gcmp("fmt", J.cl(G.fmt, null, [float(n)]), J.cl(O.fmt, null, [float(n)]))
	var ns1 = J.cl(G.newState, null, []); var ns2 = J.cl(O.newState, null, []); ns1.erase("last"); ns2.erase("last"); _gcmp("newState", ns1, ns2)
	for lv in range(1, 22): _gcmp("expNeed", J.cl(F.expNeed, null, [float(lv)]), J.cl(OF.expNeed, null, [float(lv)])); _gcmp("lvCost", J.cl(F.lvCost, null, [float(lv)]), J.cl(OF.lvCost, null, [float(lv)]))
	for f in ["ghostCap", "builderDiscount", "cap", "troopCap", "rosterCap", "walk", "chopTime", "furnaceCoins", "recruitCost"]: _gcmp("F." + f, J.cl(F[f], null, []), J.cl(OF[f], null, []))
	for g in S.ghosts:
		_gcmp("glv", J.cl(F.glv, null, [g]), J.cl(OF.glv, null, [g]))
		for i in 3: _gcmp("stat", J.cl(F.stat, null, [g, float(i)]), J.cl(OF.stat, null, [g, float(i)]))
		_gcmp("gdef", J.cl(G.gdef, null, [g]), J.cl(O.gdef, null, [g]))
		_gcmp("ghostById", J.cl(G.ghostById, null, [g.id]), J.cl(O.ghostById, null, [g.id]))
	_gcmp("ghostById_x", J.cl(G.ghostById, null, ["zz"]), J.cl(O.ghostById, null, ["zz"]))
	for b in J.G.BLD_ORDER:
		_gcmp("bldMax", J.cl(F.bldMax, null, [b]), J.cl(OF.bldMax, null, [b]))
		_gcmp("bldUnlocked", J.cl(G.bldUnlocked, null, [b]), J.cl(O.bldUnlocked, null, [b]))
		for lv in [1.0, 4.0, 13.0]: _gcmp("upCost", J.cl(F.upCost, null, [b, lv]), J.cl(OF.upCost, null, [b, lv]))
		_gcmp("mult", J.cl(F.mult, null, [b]), J.cl(OF.mult, null, [b]))
	for p in J.G.POSTS: _gcmp("slots", J.cl(F.slots, null, [p]), J.cl(OF.slots, null, [p])); _gcmp("workersAt", J.cl(G.workersAt, null, [p]), J.cl(O.workersAt, null, [p]))
	for c in ["g", "b", "p"]: _gcmp("chestGain", J.cl(F.chestGain, null, [c]), J.cl(OF.chestGain, null, [c]))
	_gcmp("fodderCount", J.cl(G.fodderCount, null, []), J.cl(O.fodderCount, null, []))
	_gcmp("furnaceReady", J.cl(G.furnaceReady, null, []), J.cl(O.furnaceReady, null, []))
	_gcmp("rates", J.cl(G.ratesPerMin, null, []), J.cl(O.ratesPerMin, null, []))
	for c in [{"planks": 10.0}, {"planks": 1e9, "coins": 5.0}, {"wood": 0.0, "coins": 123456.0}]:
		_gcmp("canPay", J.cl(G.canPay, null, [c]), J.cl(O.canPay, null, [c])); _gcmp("costText", J.cl(G.costText, null, [c]), J.cl(O.costText, null, [c]))
	for st in J.G.STANDUP: _gcmp("standOk", J.cl(G.standOk, null, [st]), J.cl(O.standOk, null, [st]))
	var Q = G.Quest; var OQ = O.Quest
	for q in J.G.QUESTS: _gcmp("q.progress", J.mc(Q, "progress", [q]), J.cl(OQ.progress, Q, [q]))
	_gcmp("q.cur", J.mc(Q, "cur", []), J.cl(OQ.cur, Q, []))
	# 改 S 嘅函數：深拷貝各跑
	for dt in [1.0, 60.0, 3600.0]:
		_gstate("produce%s" % dt, func(): J.cl(G.produce, null, [dt]); return J.G.expAcc, func(): J.cl(O.produce, null, [dt]); return J.G.expAcc)
	_gstate("produce_loop", func():
		for i in 480: J.cl(G.produce, null, [60.0])
		return J.G.expAcc, func():
		for i in 480: J.cl(O.produce, null, [60.0])
		return J.G.expAcc)
	_gstate("pay", func(): J.cl(G.pay, null, [{"planks": 3.0, "coins": 7.0}]); return null, func(): J.cl(O.pay, null, [{"planks": 3.0, "coins": 7.0}]); return null)
	_gstate("give", func(): return J.cl(G.give, null, [{"exp": 50.0, "coins": 12345.0, "chest": "p", "troops": 3.0}]), func(): return J.cl(O.give, null, [{"exp": 50.0, "coins": 12345.0, "chest": "p", "troops": 3.0}]))
	_gstate("gainExp", func(): J.cl(G.gainExp, null, [50000.0]); return null, func(): J.cl(O.gainExp, null, [50000.0]); return null)
	# joinGhost／recruitFodder／Quest.complete 之後俾其他模塊包咗：直接比原生函數本身
	_gstate("joinGhost", func(): NG.join_ghost("mengpo"); NG.join_ghost("afu"); return null, func(): J.cl(O.joinGhost, null, ["mengpo"]); J.cl(O.joinGhost, null, ["afu"]); return null)
	_gstate("offline", func(): J.G.S["last"] = J.now() - 5 * 3600 * 1000.0; J.cl(G.offlineGain, null, []); J.G.S["last"] = 0.0; return null,
		func(): J.G.S["last"] = J.now() - 5 * 3600 * 1000.0; J.cl(O.offlineGain, null, []); J.G.S["last"] = 0.0; return null)
	# 隨機嘅：固定種子各跑
	_gstate("recruit", func(): seed(42); var g = NG.recruit_fodder(false); return g, func(): seed(42); var g = J.cl(O.recruitFodder, null, [false]); return g)
	# Quest.complete（改 qi、給獎勵）
	_gstate("q.complete", func(): NG.q_complete(Q); return null, func(): J.cl(OQ.complete, Q, []); return null)
	print("[game1] ok=%d bad=%d" % [gok, gbad])

func sp_stage(_t) -> void:
	J.mc(J.G.Theater, "play", [{"tag": "測試", "title": "三隻拆唔開嘅鬼", "bg": "village", "cast": [["Toyol", "toyol"], ["Pocong", "pocong"], ["Penanggal", "penanggal"]], "lines": [["Toyol", "測試網格變形：三隻鬼同台。"], ["Pocong", "跳下跳下。"], ["Penanggal", "飛頭。"]]}])

# ---- game 第二段：Village ----
const VM := ["setCam", "focus", "hitTest", "tap", "walkTo", "craft", "update", "doAct", "heroPose", "impact", "updateParts", "scatterCrows", "pickChatter", "workerSpots", "questTarget", "collect"]
func _vcopy(native: bool) -> Dictionary:
	var NG = load("res://native/game.gd"); var V = J.G.Village
	var c = {}
	# 只深拷貝會變嘅狀態（Village 入面有循環引用，整個 duplicate(true) 會爆）
	for k in V: c[k] = V[k]
	for k in ["hero", "floats", "crows", "feathers", "parts", "bubble", "chatUsed", "workerPhase"]:
		if V.get(k) is Dictionary or V.get(k) is Array: c[k] = V[k].duplicate(true)
	for n in VM:
		if native: c[n] = _bind_nat(n, c)
		else: c[n] = NG.ORIG["V." + n]
	return c
func _bind_nat(n: String, c: Dictionary) -> Callable:
	var NG = load("res://native/game.gd")
	match n:
		"update": return func(t, a): NG.v_update(t, J.num(J.arg(a, 0))); return null
		"doAct": return func(t, a): NG.v_do_act(t, J.num(J.arg(a, 0))); return null
		"updateParts": return func(t, a): NG.v_update_parts(t, J.num(J.arg(a, 0)), J.arg(a, 1)); return null
		"impact": return func(t, a): NG.v_impact(t, J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.str(J.arg(a, 2)), J.arg(a, 3)); return null
		"scatterCrows": return func(t, a): NG.v_scatter_crows(t, int(J.num(J.arg(a, 0)))); return null
		"pickChatter": return func(t, _a): NG.v_pick_chatter(t); return null
		"walkTo": return func(t, a): NG.v_walk_to(t, J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.arg(a, 2)); return null
		"craft": return func(t, a): NG.v_craft(t, J.arg(a, 0), J.arg(a, 1)); return null
		"tap": return func(t, a): NG.v_tap(t, J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); return null
		"hitTest": return func(_t, a): return NG.v_hit_test(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))
		"heroPose": return func(t, _a): return NG.v_hero_pose(t)
		"setCam": return func(t, a): NG.v_set_cam(t, J.num(J.arg(a, 0))); return null
		"focus": return func(t, a): NG.v_focus(t, J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); return null
		"workerSpots": return func(_t, _a): return NG.v_worker_spots()
		"questTarget": return func(_t, _a): return NG.v_quest_target()
		"collect": return func(t, a): return NG.v_collect(t, J.arg(a, 0))
	return Callable()
static func _vstate(v: Dictionary) -> Dictionary:
	var o = {}
	for k in ["hero", "floats", "crows", "feathers", "parts", "t", "camY", "hitstop", "shk", "proudT", "_pp"]: o[k] = v.get(k)
	return o   # 碎碎念（bubble／chatT／chatUsed）受其他模塊冷却狀態影響，另外用 _chat_unit 單獨比
# 同一劇本：S、Village 各一份拷貝，原生／轉譯各跑，比 S 同 Village 狀態
func _vsim(name: String, script: Callable) -> void:
	var S0 = J.G.S; var acc0 = J.G.get("expAcc"); var res = []
	var V0 = J.G.Village; var HD0 = J.G.get("HeroDaily"); var LP0 = (J.G.Fx.lastPraise as Dictionary).duplicate(true)
	var SND0 = J.G.Sound; J.G["Sound"] = {"play": func(_t, _a): return null, "setMode": func(_t, _a): return null}   # 聲音有時間節流同隨機音高，唔比
	# 劇情、介面係全局狀態（任務完成會排劇情；Story.busy／UI.modalOpen 影響碎碎念）：兩邊都用同一個空替身
	var ST0 = J.G.Story; var UI0 = J.G.UI
	var nop = func(_t, _a): return null
	var fal = func(_t, _a): return false
	J.G["Story"] = {"busy": fal, "queue": nop, "play": nop}
	var ui_stub = (UI0 as Dictionary).duplicate(); for k in ["modalOpen"]: ui_stub[k] = fal
	for k in ["refresh", "openBuilding", "open", "close", "toast"]: ui_stub[k] = nop
	J.G["UI"] = ui_stub
	for native in [false, true]:   # 轉譯版行先（同上次相反），排除先後次序影響
		var s = S0.duplicate(true); J.G["S"] = s; J.G["expAcc"] = acc0
		var v = _vcopy(native); seed(7)
		J.G.Fx["lastPraise"] = LP0.duplicate(true)   # Fx.praise 記住上次揀嘅句，會影響隨機數消耗
		J.G["Village"] = v          # Fx.float 等寫入 Village.floats：指向今次嘅拷貝
		J.G["HeroDaily"] = null     # 阿福日常排程有自己嘅狀態同隨機數（L5 模塊），唔喺今次比較範圍
		var r = script.call(v)
		J.G["Village"] = V0
		res.append([r, _vstate(v), s])
	J.G["S"] = S0; J.G["expAcc"] = acc0; J.G["HeroDaily"] = HD0; J.G["Sound"] = SND0; J.G["Story"] = ST0; J.G["UI"] = UI0
	_gcmp(name + ":ret", res[1][0], res[0][0]); _gcmp(name + ":V", res[1][1], res[0][1]); _gcmp(name + ":S", res[1][2], res[0][2])

func game2(_t) -> void:
	gok = 0; gbad = 0
	var NG = load("res://native/game.gd"); var O = NG.ORIG; var Q = J.G.Quest
	# 上次 q.complete 嘅差異：今次轉譯版行先
	var S0 = J.G.S
	var s2 = S0.duplicate(true); J.G["S"] = s2; J.cl(O.Quest.complete, Q, [])
	var s1 = S0.duplicate(true); J.G["S"] = s1; NG.q_complete(Q)
	J.G["S"] = S0; s1.erase("chat"); s2.erase("chat"); _gcmp("q.complete(tr-first,no chat)", s1, s2)
	# 純函數
	var V = J.G.Village
	for x in range(0, 391, 13):
		for y in range(100, 1130, 17): _gcmp("hitTest", NG.v_hit_test(float(x), float(y)), J.cl(O["V.hitTest"], V, [float(x), float(y)]))
	_gcmp("workerSpots", NG.v_worker_spots(), J.cl(O["V.workerSpots"], V, []))
	_gcmp("questTarget", NG.v_quest_target(), J.cl(O["V.questTarget"], V, []))
	_gcmp("heroPose", NG.v_hero_pose(V), J.cl(O["V.heroPose"], V, []))
	# 模擬：砍樹（第一棵）、割稻、批量做棺材板、做壽包、走路
	_vsim("chop", func(v):
		J.G.S.trees[0] = 3.0; J.mc(v, "walkTo", [58.0, 406.0, {"kind": "tree", "i": 0.0}])
		for i in 400: J.mc(v, "update", [0.05])
		return J.mc(v, "heroPose", []))
	_vsim("paddy", func(v):
		J.G.S.paddy[2] = 1.0; J.mc(v, "walkTo", [218.0, 466.0, {"kind": "paddy", "i": 2.0}])
		for i in 300: J.mc(v, "update", [0.033])
		return J.mc(v, "heroPose", []))
	_vsim("craft_plank", func(v):
		J.G.S.res["wood"] = 30.0; J.mc(v, "craft", ["plank", 5.0])
		for i in 600: J.mc(v, "update", [0.05])
		return J.G.S.res.planks)
	_vsim("craft_bun_short", func(v):
		J.G.S.res["rice"] = 9.0; J.mc(v, "craft", ["bun", 4.0])
		for i in 600: J.mc(v, "update", [0.05])
		return J.G.S.res.buns)
	_vsim("craft_none", func(v): J.G.S.res["rice"] = 2.0; J.mc(v, "craft", ["bun", 1.0]); return null)
	_vsim("walk_cam", func(v):
		J.mc(v, "walkTo", [380.0, 1100.0, null]); J.mc(v, "setCam", [5000.0]); var c1 = v.camY; J.mc(v, "focus", [0.0, 200.0])
		for i in 200: J.mc(v, "update", [0.05])
		return [c1, v.camY])
	_vsim("crows", func(v):
		J.mc(v, "scatterCrows", [3.0]); J.mc(v, "impact", [100.0, 200.0, "dough", 0.4]); J.mc(v, "impact", [100.0, 200.0, "rice", null])
		for i in 30: J.mc(v, "update", [0.05])
		return null)
	_vsim("tap", func(v):
		for p in [[60.0, 400.0], [250.0, 410.0], [195.0, 300.0], [200.0, 700.0], [338.0, 250.0]]: J.mc(v, "tap", p)
		return null)
	# 碎碎念單元：同一狀態、同一種子，原生同轉譯各揀 40 次
	var V1 = J.G.Village; var ST0 = J.G.Story; J.G["Story"] = {"busy": func(_t, _a): return false}
	var UI0 = J.G.UI; var uis = (UI0 as Dictionary).duplicate(); uis["modalOpen"] = func(_t, _a): return false; J.G["UI"] = uis
	if not (V1.get("vis") is Array) or V1.vis.is_empty(): V1["vis"] = []
	if V1.vis.is_empty():
		var i = 0
		for g in J.G.S.ghosts: V1.vis.append({"g": g, "x": 100.0 + i * 20, "y": 500.0 + i * 30}); i += 1
	var picks = []
	for native in [false, true]:
		var c = V1.duplicate(); c["chatUsed"] = {}; c["bubble"] = null; seed(11); var out = []
		for i in 40:
			if native: NG.v_pick_chatter(c)
			else: J.cl(O["V.pickChatter"], c, [])
			out.append(c.get("bubble")); c["bubble"] = null
		picks.append(out)
	J.G["Story"] = ST0; J.G["UI"] = UI0
	_gcmp("pickChatter x40", picks[1], picks[0])
	print("[game2] ok=%d bad=%d" % [gok, gbad])
