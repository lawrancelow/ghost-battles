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
