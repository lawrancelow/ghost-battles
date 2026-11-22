# 原生改寫自 guide.js（冥街夜市、亂葬崗兩個任務＋「新地方」紅點）
# 介面同轉譯版一樣：J.G["Guide"] = { migrate, dot, anyDot, visit, drawGateDot }；載入時插入 SCENES.q_street/q_yard 同 QUESTS 兩個任務
extends RefCounted

const QV := 3.0   # [outgate] 3：拎走冥街夜市、陰陽交界兩個主線插入任務
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
	var qv = J.num(S.get("qv")) if J.t(S.get("qv")) else 1.0
	if qv >= QV: return
	# [outgate] 第 3 版：冥街夜市、陰陽交界兩個插入任務拎走（舊出村玩法暫時唔開）
	#   第 2 版清單：兩個任務喺 at[0]、at[1]+1；做過咗嘅（位置 < qi）要減返；啱啱做緊嗰個＝直接跳去下一個
	if qv >= 2.0 and at.size() == 2:
		var old = J.num(S.get("qi")); var sub = 0
		for pos in [at[0], at[1] + 1.0]: if old > pos: sub += 1
		S["qi"] = old - sub
	S["qv"] = QV
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
	if load("res://game/zone/zone_data.gd").on(): return false   # [outgate] 舊世界地圖唔開：出村門唔出「新地方」紅點
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
	# 亂葬崗暫時封存：同一個位改做「陰陽交界」
	var qy = [
		["小紙", ["少爺，村口雜貨店伯搵你。佢話條村有啲人，卡咗喺嗰一晚。", "少爺，村口雜貨店伯找你。他說村裡有些人，卡在了那一晚。"]],
		["阿福", ["邊一晚？", "哪一晚？"]],
		["小紙", ["發大水嗰晚。佢哋唔知自己出咗事，仲喺度做緊嗰晚做緊嘅嘢。", "發大水那晚。他們不知道自己出了事，還在做那晚正在做的事。"]],
		["小紙", ["仲有啲嘢想捉佢哋落去。出村口，地圖上嗰個「陰陽交界」。", "還有些東西想抓他們下去。出村口，地圖上那個「陰陽交界」。"]],
	]
	var qz = {}; var ql = []
	for l in qy: qz[l[1][0]] = l[1][1]; ql.append([l[0], l[1][0]])
	if J.G.get("LANG") != null: J.mc(J.G.get("LANG"), "add", [qz])
	if not DB.D.has("LANG_ZH"): DB.D.LANG_ZH = {}
	DB.D.LANG_ZH.merge(qz, true)
	SC["q_yard"] = {"style": "talk", "bg": "village", "title": "陰陽交界", "lines": ql}
	var ADD = [
		{"after": "1-2", "q": {"t": "visit", "place": "street", "text": "下班後去冥街夜市逛逛", "go": "gate", "r": {"exp": 40.0, "coins": 60.0}, "onStart": ["q_street"]}},
		{"after": "1-3", "q": {"t": "visit", "place": "yard", "text": "去陰陽交界救人", "go": "gate", "r": {"exp": 60.0, "coins": 80.0}, "onStart": ["q_yard"]}},
	]
	var Q: Array = _g("QUESTS")
	at = []
	for a in ADD:
		var i = _find_stage(Q, a.after)
		if i >= 0: at.append(float(i + 1))
	# [outgate] 唔再插入（舊出村玩法暫時唔開）；at 留住俾舊存檔對位
	# [outgate] 第一章節奏：出村門一開淨係播「村口」（分區開場）；舊 1-1 開頭兩段（新聞＋餓鬼搶包）搬去 1-2 開頭（1-2 先係餓鬼）
	var i11 = _find_stage(Q, "1-1"); var i12 = _find_stage(Q, "1-2")
	if i11 >= 0 and i12 >= 0 and Q[i11].get("onStart") is Array and Q[i11].onStart.has("ch1_intro"):
		Q[i12]["onStart"] = Q[i11].onStart.duplicate(); Q[i11]["onStart"] = []
	var Gd = {
		"migrate": func(_t, a): migrate(J.arg(a, 0)); return null,
		"dot": func(_t, a): return dot(J.arg(a, 0)),
		"anyDot": func(_t, _a): return any_dot(),
		"visit": func(_t, a): visit(J.arg(a, 0)); return null,
		"drawGateDot": func(_t, a): draw_gate_dot(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3)); return null,
	}
	J.G["Guide"] = Gd
