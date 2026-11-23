# [qaudit2] 除錯：由存檔快照（edtest_from.sh）比較某場主線王戰：舊 Battle 引擎 vs 地圖模擬，唔同出陣陣容
# 用法：QA_CH=0 QA_SI=2 QA_ZID=w_pit QA_BID=zb_eguiking /home/claude/wt/qaudit2/edtest_from.sh <godot> <tag> /tmp/qa2snap/q13.json res://tools/tests/qaudit2_test.gd cmp 900
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SIM = preload("res://game/rts/rts_sim.gd")
const BK = preload("res://game/barracks/bk_data.gd")

var ok := 0
var bad := 0
func _p(m): print("[qaudit2] ", m)
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _boot(t):
	for i in 120:
		await t.get_tree().create_timer(0.5).timeout
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await t.get_tree().create_timer(1.5).timeout
	var m = _main(t)
	m._hide_title(); await t.get_tree().create_timer(1.0).timeout
	return m

func _old(ch: float, si: float) -> Dictionary:
	var G = J.G; var Bt = G.Battle
	var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
	G["__nat_battle"] = func(_t, _a): return true
	G["__nat_btSize"] = func(_t, _a): return [390.0, 560.0]
	J.mc(Bt, "start", [ch, si])
	G["__nat_battle"] = ob; G["__nat_btSize"] = osz
	var of = Bt.get("finish"); var res = [null]
	Bt["finish"] = func(_t, a): Bt["result"] = {"win": J.arg(a, 0)}; res[0] = J.t(J.arg(a, 0)); return null
	Bt["speed"] = 1.0; Bt["auto"] = true
	var n = 0
	while Bt.get("result") == null and n < 30 * 150:
		J.mc(Bt, "update", [1.0 / 30.0]); n += 1
	Bt["finish"] = of
	var t_ = J.num(Bt.t)
	var left = []
	for u in Bt.units: if J.num(u.side) == 1 and J.num(u.hp) > 0: left.append("%s %d" % [str(u.get("name", u.k)), int(J.num(u.hp))])
	Bt["active"] = false; Bt["result"] = null
	return {"win": res[0] == true, "t": int(t_), "left": left}
var trace := false
func _new(ch: float, si: float, zid: String, bid: String) -> Dictionary:
	var Bt = J.G.Battle
	Bt["auto"] = true
	var snap = RTS._start_battle(func(): J.mc(Bt, "start", [ch, si]))
	var g = RTS.geometry({"kind": "boss", "id": zid, "opt": {"bid": bid}}) if zid != "" else RTS.geometry({"kind": "stage", "opt": {}, "tg": {"pos": ZD.front_anchor()}})
	var op = SIM.new()
	op.setup(snap.units, g.path, g.at, RTS.gate_pos())
	var n = 0
	while op.result == null and n < 30 * 300:
		op.step(1.0 / 30.0); n += 1
		if trace and n % 45 == 0 and op.phase == "fight":
			var ln = []
			for u in op.units:
				if J.num(u.hp) <= 0: continue
				var tg = u.get("tg")
				ln.append("%s%s(%d,%d)%d%s%s" % ["敵" if J.num(u.side) == 1 else "", str(u.get("name", "")).left(3), int(u.p.x), int(u.p.y), int(J.num(u.hp)), ("→" + str(tg.get("name", "")).left(3) + "d%d" % int(op.dist(u, tg))) if tg is Dictionary else "", ("" if J.t(u.get("eng")) or J.num(u.side) == 1 else "未接") + ("" if not J.t(u.get("minion")) else "")])
			_p("    t=%.1f %s" % [op.t, " ".join(ln)])
	var left = []; var mine = []
	for u in op.units:
		if J.num(u.side) == 1 and J.num(u.hp) > 0: left.append("%s %d" % [str(u.get("name", u.k)), int(J.num(u.hp))])
		if J.num(u.side) == 0 and not J.t(u.get("minion")): mine.append("%s hp%d/%d atk%d" % [str(u.get("name")), int(J.num(u.hp)), int(J.num(u.maxhp)), int(J.num(u.atk))])
	var foes = []
	for u in op.units: if J.num(u.side) == 1: foes.append("%s hp%d atk%d rng%d" % [str(u.get("name", u.k)), int(J.num(u.maxhp)), int(J.num(u.atk)), int(J.num(u.range))])
	return {"win": op.result != null and J.t(op.result.win), "res": op.result, "t": int(op.t), "left": left, "mine": mine, "foes": foes}

func cmp(t) -> void:
	await _boot(t)
	var ch = float(OS.get_environment("QA_CH")); var si = float(OS.get_environment("QA_SI"))
	var zid = OS.get_environment("QA_ZID"); var bid = OS.get_environment("QA_BID")
	var S = J.G.S
	var named = []
	for g in S.ghosts: if str(g.k) != "afu": named.append(g)
	_p("team=%s troops=%s lv=%s ghosts=%s" % [str(S.team), str(S.res.troops), str(S.lv), str(named.map(func(g): return [g.k, g.lv, g.get("post")]))])
	if OS.has_environment("QA_MAX"):   # 頂盡：全部名鬼升到上限、軍師、嚇功 Lv5
		var cap = J.num(J.mc(J.G.F, "ghostCap", []))
		for g in named: g["lv"] = cap
		if not S.has("drill") or not (S.drill is Dictionary): S["drill"] = {}
		if OS.has_environment("QA_DRILL"): for g in named: S.drill[str(g.k)] = 6000.0
		_p("頂盡：上限 %d" % int(cap))
	var teams = [J.iter(S.team).filter(func(x): return x != null)]
	var GP = J.G.get("GP")
	named.sort_custom(func(a, b): return J.num(J.mc(GP, "pow", [a])) > J.num(J.mc(GP, "pow", [b])))
	_p("鬼力排名 %s" % str(named.map(func(g): return [g.k, g.lv, int(J.num(J.mc(GP, "pow", [g])))])))
	var t2 = ["afu"]
	for g in named:
		if t2.size() < 3: t2.append(g.id)
	if t2.size() > 1: teams.append(t2)
	if OS.has_environment("QA_ADV") and named.size() > 2: S["adviser"] = named[2].id; _p("軍師 %s" % str(named[2].k))
	for tm in teams:
		var tt = tm.duplicate(); while tt.size() < 3: tt.append(null)
		S["team"] = tt
		var wo = 0; var wn = 0
		for i in 6:
			trace = OS.has_environment("QA_TRACE") and i == 0 and tm.size() > 1 and str(tm[1]) != "g1"
			var r0 = _old(ch, si); var r1 = _new(ch, si, zid, bid)
			wo += int(r0.win); wn += int(r1.win)
			if i == 0: _p("  new 我方 %s｜敵方 %s" % [str(r1.mine), str(r1.foes)])
			_p("  team %s #%d 舊 %s｜新 %s" % [str(tm), i, str(r0), str({"win": r1.win, "res": r1.res, "t": r1.t, "left": r1.left})])
			await t.get_tree().process_frame
		_p("team %s：舊贏 %d/6，新贏 %d/6" % [str(tm), wo, wn])
	_p("RESULT ok=%d bad=%d" % [ok, bad])
