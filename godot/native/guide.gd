# 原生改寫自 guide.js（冥街夜市、亂葬崗兩個任務＋「新地方」紅點）
# 介面同轉譯版一樣：J.G["Guide"] = { migrate, dot, anyDot, visit, drawGateDot }；載入時插入 SCENES.q_street/q_yard 同 QUESTS 兩個任務
extends RefCounted

const QV := 2.0
static var at: Array = []

static func _g(n: String): return J.G.get(n)
static func _S(): return _g("S")

static func _find_stage(Q: Array, sid: String) -> int:
	for i in Q.size():
		if J.str(Q[i].get("t")) == "stage" and J.str(Q[i].get("s")) == sid: return i
	return -1

static func open_(s) -> bool:
	var ready = J.gp(s, "ready"); var need = J.gp(s, "need")
	return (not J.t(ready) or J.t(J.cl(ready, s, []))) and (not J.t(need) or J.t(J.cl(need, s, [])))

static func migrate(fresh) -> void:
	var S = _S()
	if not J.t(S.get("visit")): S["visit"] = {}
	if not J.t(S.get("wmSeen")): S["wmSeen"] = {}
	if J.t(fresh): S["qv"] = QV
	if (J.num(S.get("qv")) if J.t(S.get("qv")) else 1.0) >= QV: return
	var old = J.num(S.get("qi")); var add = 0
	for pos in at: if old >= pos: add += 1
	S["qi"] = old + add; S["qv"] = QV
	var W = _g("World")
	if W != null:
		for s in J.iter(J.gp(W, "SPOTS")): if open_(s): S.wmSeen[J.str(J.gp(s, "id"))] = 1.0

static func dot(id) -> bool:
	var S = _S()
	if not J.t(S.get("visit")): return false
	var s = null
	for x in J.iter(J.gp(_g("World"), "SPOTS")): if J.str(J.gp(x, "id")) == J.str(id): s = x; break
	var ws = S.get("wmSeen") if J.t(S.get("wmSeen")) else {}
	return s != null and open_(s) and not J.t(S.visit.get(J.str(id))) and not J.t(ws.get(J.str(id))) and J.str(id) != "battle"

static func any_dot() -> bool:
	var W = _g("World")
	if W == null: return false
	for s in J.iter(J.gp(W, "SPOTS")): if dot(J.gp(s, "id")): return true
	return false

static func visit(id) -> void:
	var S = _S()
	if not J.t(S.get("visit")): S["visit"] = {}
	S.visit[J.str(id)] = 1.0
	J.mc(_g("Quest"), "check", []); J.cl(_g("save"), null, [])

static func draw_gate_dot(ctx, x, y, t) -> void:
	if not any_dot(): return
	var r = 7 + sin(J.num(t) * 5) * 1.2
	J.mc(ctx, "save", []); J.sp(ctx, "fillStyle", "#e8303a"); J.sp(ctx, "strokeStyle", "#fff3e0"); J.sp(ctx, "lineWidth", 2.0)
	J.mc(ctx, "beginPath", []); J.mc(ctx, "arc", [x, y, r, 0.0, 7.0]); J.mc(ctx, "fill", []); J.mc(ctx, "stroke", []); J.mc(ctx, "restore", [])

func run(_env) -> void:
	var SC = _g("SCENES")
	SC["q_street"] = {"style": "talk", "bg": "village", "title": "下班後", "lines": [
		["小紙", "少爺，你做到成隻鬼咁殘喇。"],
		["阿福", "我本來就係鬼。"],
		["小紙", "咁更加要放工啦！出村口行過去，有條冥街夜市，成晚都開。宵夜、講價、燒紙紮，乜都有。"],
		["阿福", "……有冇得加班？"],
		["小紙", "冇！今晚唔准加班。行，我帶你去。"],
	]}
	SC["q_yard"] = {"style": "talk", "bg": "village", "title": "無名墳", "lines": [
		["小紙", "少爺，打贏餓鬼王之後，村外面多咗啲鬼喺度徘徊。"],
		["阿福", "又係搶包？"],
		["小紙", "唔係。佢哋喺亂葬崗搵唔返自己個墳，瞓唔到。"],
		["阿福", "搵唔返自己個墳……咁點算？"],
		["小紙", "睇墓碑、聽佢哋講，幫佢哋一個個對返落去。出村口，地圖上嗰個「亂葬崗」。"],
	]}
	var ADD = [
		{"after": "1-2", "q": {"t": "visit", "place": "street", "text": "下班後去冥街夜市逛逛", "go": "gate", "r": {"exp": 40.0, "coins": 60.0}, "onStart": ["q_street"]}},
		{"after": "1-3", "q": {"t": "visit", "place": "yard", "text": "去亂葬崗找無名墳", "go": "gate", "r": {"exp": 60.0, "coins": 80.0}, "onStart": ["q_yard"]}},
	]
	var Q: Array = _g("QUESTS")
	at = []
	for a in ADD:
		var i = _find_stage(Q, a.after)
		if i >= 0: at.append(float(i + 1))
	var rev = ADD.duplicate(); rev.reverse()
	for a in rev:
		var i = _find_stage(Q, a.after)
		if i >= 0: Q.insert(i + 1, a.q)
	var Gd = {
		"migrate": func(_t, a): migrate(J.arg(a, 0)); return null,
		"dot": func(_t, a): return dot(J.arg(a, 0)),
		"anyDot": func(_t, _a): return any_dot(),
		"visit": func(_t, a): visit(J.arg(a, 0)); return null,
		"drawGateDot": func(_t, a): draw_gate_dot(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3)); return null,
	}
	J.G["Guide"] = Gd
