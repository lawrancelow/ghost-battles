# L1 第三批原生對照：puppet、npc_antag（畫入錄製器畫布，比錄低嘅繪圖指令）
extends "res://tools/tests/xc_l1.gd"

var cv = null
var ctx = null

func _ctx():
	if ctx == null:
		cv = J.S_document_("createElement", ["canvas"]); J.sp(cv, "width", 400.0); J.sp(cv, "height", 400.0)
		ctx = J.mc(cv, "getContext", ["2d"])
	return ctx
func _rec(f: Callable) -> String:
	var c = _ctx(); c.ci.clear(); J.mc(c, "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]); J.sp(c, "globalAlpha", 1.0)
	var r = f.call()
	return str(c.ci.cmds.size()) + "|" + str(c.ci.cmds) + "|" + str(r)

func puppet(_t) -> void:
	mod = "puppet"
	var nat = J.G.Puppet
	var keepON = J.G.PUPPET_ON
	var tr = load_trans("puppet", ["Puppet", "PUPPET_ON"]).Puppet
	# 轉譯版冇 rigs.js 嘅角色：同樣加入（深拷貝，兩邊各自 mirror）
	var extra = {}
	for id in nat.RIGS: if id != "afu": extra[id] = nat.RIGS[id].duplicate(true)
	J.mc(tr, "addRigs", [extra])
	eq("RIGS keys", nat.RIGS.keys(), J.gp(tr, "RIGS").keys())
	for name in nat.ANIMS:
		for p in [0.0, 0.07, 0.3, 0.5, 0.81, 1.0, 1.3]:
			for t in [0.0, 0.4, 2.7]:
				eq("ANIM %s %s %s" % [name, p, t], J.cl(nat.ANIMS[name], null, [p, t]), J.cl(J.gp(J.gp(tr, "ANIMS"), name), null, [p, t]))
	for id in nat.RIGS.keys() + ["nobody", "egui"]:
		eq("armed " + id, J.mc(nat, "armed", [id]), J.mc(tr, "armed", [id]))
		eq("has(off) " + id, J.mc(nat, "has", [id]), J.mc(tr, "has", [id]))
	J.mc(nat, "addTool", ["wpn_test", "tool_axe", 40.0, 90.0, null]); J.mc(tr, "addTool", ["wpn_test", "tool_axe", 40.0, 90.0, null])
	eq("TOOLS", JSON.stringify(nat.TOOLS), JSON.stringify(J.gp(tr, "TOOLS")))
	# 開木偶：mirror 之後比 RIGS 同畫法
	J.G["PUPPET_ON"] = true
	for id in nat.RIGS.keys():
		eq("has(on) " + id, J.mc(nat, "has", [id]), J.mc(tr, "has", [id]))
	eq("RIGS mirrored", JSON.stringify(nat.RIGS), JSON.stringify(J.gp(tr, "RIGS")))
	for id in nat.RIGS.keys():
		for name in ["idle", "chop", "hammer", "windup", "strike", "phone", "run", "die", "mop"]:
			for flip in [false, true]:
				var pz = J.cl(nat.ANIMS[name], null, [0.37, 1.3])
				pz["wpn"] = "wpn_test" if name == "strike" else null
				var a = _rec(func(): return J.mc(nat, "draw", [_ctx(), id, 120.0, 300.0, 90.0, pz.duplicate(), flip]))
				var b = _rec(func(): return J.mc(tr, "draw", [_ctx(), id, 120.0, 300.0, 90.0, pz.duplicate(), flip]))
				eq("draw %s %s %s" % [id, name, flip], a, b)
				for al in [null, 30.0]: eq("tip %s %s %s %s" % [id, name, flip, al], J.mc(nat, "tipWorld", [id, 120.0, 300.0, 90.0, pz, flip, al]), J.mc(tr, "tipWorld", [id, 120.0, 300.0, 90.0, pz, flip, al]))
	J.G["PUPPET_ON"] = keepON
	_report()

func _handles() -> Dictionary:
	var MA = J.G.MeshAnim; var h = {}
	for id in ["npc_rival", "npc_hr", "npc_kpiboss"]:
		h["c:" + id] = J.gp(J.gp(J.gp(MA, "RIG"), id), "custom"); h["m:" + id] = J.gp(J.G.MOVES, id)
	for st in ["spin", "dribble", "jumpshot", "gossip", "clip", "glasses", "stamp", "inspect", "tap", "sigh", "yell", "jump", "walk", "idle"]: h["d:" + st] = J.gp(J.G.DAILY, "ag_" + st)
	return h
func _use(h: Dictionary) -> void:
	var MA = J.G.MeshAnim
	for k in h:
		var p = k.split(":")
		if p[0] == "c": J.sp(J.gp(J.gp(MA, "RIG"), p[1]), "custom", h[k])
		elif p[0] == "m": J.sp(J.G.MOVES, p[1], h[k])
		else: J.sp(J.G.DAILY, "ag_" + p[1], h[k])

func npc_antag(_t) -> void:
	mod = "npc_antag"
	var nat = J.G.Antag; var hn = _handles()
	var tr = load_trans("npc_antag", ["Antag"]).Antag; var ht = _handles()
	_use(hn)
	eq("STATES", nat.STATES, J.gp(tr, "STATES")); eq("ZH", nat.ZH, J.gp(tr, "ZH")); eq("P", JSON.stringify(nat.P), JSON.stringify(J.gp(tr, "P")))
	for id in nat.STATES:
		for st in nat.STATES[id] + ["idle", "bogus"]:
			eq("dur %s %s" % [id, st], J.cl(nat.dur, null, [id, st]), J.cl(J.gp(tr, "dur"), null, [id, st]))
			var ts = [0.05, 0.2, 0.28, 0.33, 0.41, 0.56, 0.9] if st == "attack" else [0.0, 0.31, 1.07, 2.7]
			for t in ts:
				for fr in [true, false]:
					var opt = {"faceRight": fr, "time": 1.7}
					_use(hn); var a = _rec(func(): return J.cl(nat.draw, null, [_ctx(), id, 150.0, 300.0, 80.0, st, t, opt.duplicate()]))
					_use(ht); var b = _rec(func(): return J.cl(J.gp(tr, "draw"), null, [_ctx(), id, 150.0, 300.0, 80.0, st, t, opt.duplicate()]))
					eq("draw %s %s %s %s" % [id, st, t, fr], a, b)
	_use(hn)
	_report()

# ---------------- rivals：截住 Theater／Story／toast，兩邊同一組固定隨機數、同一份存檔，逐個事件比 ----------------
var _rq: Array = []
var _ri := 0
var _log: Array = []
func _rv() -> float:
	if _rq.is_empty(): return 0.5
	var v = _rq[_ri % _rq.size()]; _ri += 1; return v
static func _clean(o):
	if o is Callable: return "<fn>"
	if o is Array: return o.map(func(x): return _clean(x))
	if o is Dictionary:
		var d = {}
		for k in o: d[k] = _clean(o[k])
		return d
	return o
func _stubs() -> Dictionary:
	var keep = {"Theater": J.G.get("Theater"), "Story": J.G.get("Story"), "Fx": J.G.get("Fx"), "save": J.G.get("save")}
	J.G["Theater"] = {"play": func(_t, a): _log.append(["play", _clean(a[0])]); return null}
	J.G["Story"] = {"queue": func(_t, a): _log.append(["queue", _clean(a[0])]); return null}
	J.G["Fx"] = {"toast": func(_t, a): _log.append(["toast", J.str(a[0])]); return null}
	J.G["save"] = func(_t, _a): return null
	return keep
func _seq(R, S0: Dictionary, steps: Array) -> Array:
	J.G["S"] = S0.duplicate(true); _log = []
	for st in steps:
		_rq = st[2] if st.size() > 2 else []; _ri = 0
		match st[0]:
			"demo": J.mc(R, "demo", [st[1]])
			"tick":
				var a = J.mc(R, "st", []); a["clock"] = st[1]
				_log.append(["tick", J.mc(R, "tick", [])])
			"credit": J.mc(R, "credit", [st[1]])
			"prog": _log.append(["prog", _clean(J.mc(R, "taskProg", []))])
		_log.append(["antag", _clean(J.gp(J.G.S, "antag"))])
	return _log.duplicate(true)
func rivals(_t) -> void:
	mod = "rivals"
	var NR = load("res://native/rivals.gd")
	var keepS = J.G.S; var keepMath = J.G.get("Math")
	J.G["Math"] = {"random": func(_t2 = null, _a2 = null): return _rv()}
	var tr = load_trans("rivals", ["Rivals"]).Rivals
	var nat = J.G.Rivals
	NR.r_override = func(): return _rv()
	var keep = _stubs()
	eq("HR_EV ids", nat.HR_EV.map(func(e): return J.gp(e, "id")), J.gp(tr, "HR_EV").map(func(e): return J.gp(e, "id")))
	for k in ["ABSURD", "ROUNDS", "RUMORS", "BRYAN_CLAIM", "BOSS_OPEN", "BOSS_PASS", "BOSS_FAIL", "NM", "ART"]: eq(k, _clean(nat[k]), _clean(J.gp(tr, k)))
	eq("TASKS keys", nat.TASKS.keys(), J.gp(tr, "TASKS").keys())
	var steps = [["prog", null], ["demo", "boss"], ["demo", "absurd"], ["demo", "group"], ["demo", "review"], ["demo", "theft"], ["demo", "gossip"], ["demo", "showdown"]]
	for e in nat.HR_EV: steps.append(["demo", "hr:" + J.str(J.gp(e, "id"))])
	for c in [100.0, 400.0, 800.0, 1300.0, 2000.0]:
		for rq in [[0.05, 0.2, 0.4], [0.6, 0.9, 0.3], [0.95, 0.1, 0.7]]: steps.append(["tick", c, rq])
	steps += [["credit", "砍倒 3 棵槐樹"], ["credit", "打通新關卡"], ["prog", null]]
	# 三種存檔：原本、beats 已播（初見改版只喺原生，轉譯版冇 → 只比原本存檔）、已見過
	var S0: Dictionary = keepS.duplicate(true)
	var a = _seq(nat, S0, steps); var b = _seq(tr, S0, steps)
	for i in mini(a.size(), b.size()): eq("step %d %s" % [i, J.str(a[i][0])], a[i], b[i])
	eq("steps len", a.size(), b.size())
	# beats 已播：檢查原生用咗「之前見過」開場（同轉譯版唔同係刻意）
	var S1: Dictionary = keepS.duplicate(true); S1["sq"] = {"beat_c1_kpi": 1.0, "beat_c1_bryan": 1.0, "beat_c2_hr": 1.0}
	if S1.get("antag") is Dictionary: S1.erase("antag")
	var c = _seq(nat, S1, [["demo", "boss"], ["demo", "theft"], ["demo", "hr:" + J.str(J.gp(nat.HR_EV[0], "id"))]])
	var txt = JSON.stringify(c)
	eq("met: boss", txt.contains("比上次又跌深了一截"), true); eq("met: bryan", txt.contains("上次槐林邊一別") or not txt.contains("slam dunk"), true)
	print("[l1b] met-sample ", txt.substr(0, 600))
	for k in keep: J.G[k] = keep[k]
	J.G["S"] = keepS; J.G["Math"] = keepMath; NR.r_override = null
	_report()
