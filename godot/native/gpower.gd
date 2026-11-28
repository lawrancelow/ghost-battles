# 原生改寫自 gpower.js（鬼力）——介面同轉譯版一樣：J.G["GP"] 一個 Dictionary，函數係 Callable(this, args)
# 範本：其他模塊照呢個做法改寫（見 native/README.md）
extends RefCounted

const REF := 45.0
const NONE := 0.7
const MIN := 0.6
const MAX := 3.2
const STAGE_NEED := {"1-1": 450, "1-2": 470, "1-3": 500, "2-1": 520, "2-2": 540, "2-3": 560, "3-1": 580, "3-2": 680, "3-3": 920,
	"4-1": 870, "4-2": 1070, "4-3": 1300, "5-1": 870, "5-2": 1160, "5-3": 1300, "6-1": 1500, "6-2": 1560, "6-3": 1900}

static func _g(n: String): return J.G.get(n)

static func T(yue: String, zh := "") -> String:
	var LANG = _g("LANG")
	if LANG != null and zh != "": J.mc(LANG, "add", [{yue: zh}])
	var Lf = _g("L")
	return J.str(J.cl(Lf, null, [yue])) if Lf != null else yue

static func drill(k) -> float:
	var R = _g("Rework")
	if R is Dictionary and R.get("drillLv") != null:
		var v = J.mc(R, "drillLv", [k])
		return J.num(v) if J.t(v) else 1.0
	return 1.0

static func _def(k):
	var GH = _g("GHOSTS"); var FO = _g("FODDER")
	if GH is Dictionary and GH.get(k) != null: return GH[k]
	if FO is Dictionary and FO.get(k) != null: return FO[k]
	return null

static func stats(g) -> Array:
	var F = _g("F")
	if F != null and g is Dictionary and J.t(g.get("st")):
		return [J.num(J.mc(F, "stat", [g, 0.0])), J.num(J.mc(F, "stat", [g, 1.0])), J.num(J.mc(F, "stat", [g, 2.0]))]
	var d = _def(g.get("k")) if g is Dictionary else null
	if d is Dictionary and d.get("base") != null:
		var lv = J.num(J.mc(F, "glv", [g])) if F != null else J.num(g.get("lv"))
		if lv == 0: lv = 1
		var out = []
		for v in d.base: out.append(round(J.num(v) * (1 + 0.06 * (lv - 1))))
		return out
	return [30.0, 30.0, 30.0]

static func base(g) -> float:
	var s = g.get("st") if g is Dictionary else null
	if not J.t(s):
		var d = _def(g.get("k")) if g is Dictionary else null
		s = d.get("base") if d is Dictionary else null
	if s is Array and s.size() > 0: return (J.num(s[0]) + J.num(s[1]) + J.num(s[2])) / 3.0
	return 30.0

static func gear_mul(g) -> float:
	var Gr = _g("Gear")
	if Gr is Dictionary and Gr.get("gpMul") != null: return J.num(J.mc(Gr, "gpMul", [g]))
	return 1.0

static func raw(g) -> float:
	if not J.t(g): return 0.0
	var s = stats(g)
	return ((J.num(s[0]) + J.num(s[1]) + J.num(s[2])) / 3.0) * (1 + 0.2 * (drill(g.get("k")) - 1)) * gear_mul(g)

static func pow_(g) -> float: return round(raw(g) * 10)

static func mul(g) -> float:
	if not J.t(g): return NONE
	var m = pow(raw(g) / REF, 0.6)
	return maxf(MIN, minf(MAX, m if is_finite(m) else 1.0))

static func grow(g) -> float:
	if not J.t(g): return 1.0
	var m = pow(raw(g) / maxf(1.0, base(g)), 0.6)
	return maxf(1.0, minf(MAX, m if is_finite(m) else 1.0))

static func drill_mul(k) -> float: return pow(1 + 0.2 * (drill(k) - 1), 0.6)

static func best(k):
	var S = _g("S")
	if not (S is Dictionary) or not (S.get("ghosts") is Array): return null
	var b = null; var bv = -1.0
	for g in S.ghosts:
		if g is Dictionary and J.str(g.get("k")) == J.str(k):
			var v = raw(g)
			if v > bv: bv = v; b = g
	return b

static func avg(list) -> float:
	var a = []
	if list is Array: for g in list: if J.t(g): a.append(g)
	if a.is_empty(): return 0.0
	var s = 0.0
	for g in a: s += pow_(g)
	return round(s / a.size())

static func top(n) -> float:
	var S = _g("S")
	if not (S is Dictionary) or not (S.get("ghosts") is Array): return 0.0
	var a = []
	for g in S.ghosts: if g is Dictionary and J.str(g.get("k")) != "afu": a.append(pow_(g))
	a.sort(); a.reverse()
	a = a.slice(0, int(J.num(n)) if J.t(n) else 3)
	if a.is_empty(): return 0.0
	var s = 0.0
	for v in a: s += v
	return round(s / a.size())

static func stage_need(st, sid) -> float:
	if J.t(sid) and STAGE_NEED.has(J.str(sid)): return float(STAGE_NEED[J.str(sid)])
	var p = J.num(st.get("p")) if st is Dictionary and J.t(st.get("p")) else 1.0
	var boss = st is Dictionary and J.t(st.get("boss"))
	return round((420 + 50 * maxf(0, p - 3) * (1.15 if boss else 1.0)) / 10.0) * 10

static func turf_need(lv) -> float:
	var d = maxf(1.0, J.num(lv) if J.t(lv) else 1.0)
	return round(450 * pow(1 + 0.05 * (d - 1), 1 / 0.6) / 10.0) * 10

static func _n(v) -> String: return J.str(v)

static func tag(have, need) -> String:
	var low = J.t(need) and J.num(have) < J.num(need)
	return "<span class=\"gp-tag %s\">%s <b>%s</b>%s</span>" % ["gp-low" if low else "gp-ok", T("鬼力", "鬼力"), _n(have), ("／%s %s" % [T("建議", "建議"), _n(need)]) if J.t(need) else ""]

static func hint(need) -> String:
	if J.t(need): return T("鬼力唔夠（建議 %s）。返村幫隻鬼升級、落訓練班練嚇功，再嚟過！" % _n(need), "鬼力不足（建議 %s）。回村幫鬼升級、去訓練班練嚇功，再來一次！" % _n(need))
	return T("打唔過？鬼力只係隊員平均：出陣隊少過 3 隻、陰兵唔夠都會輸。多帶隻鬼、補陰兵，或者返村升級、練嚇功再嚟。", "打不過？鬼力只是隊員平均：出陣隊少於 3 隻、陰兵不夠都會輸。多帶一隻鬼、補陰兵，或回村升級、練嚇功再來。")   # [p56] 夠建議值都輸：講清楚點解

static func fail_html(have, need, extra) -> String:
	var h = J.str(extra) if J.t(extra) else hint(need if J.t(need) and J.num(have) < J.num(need) else 0.0)
	return "<div class=\"gp-fail\"><p>%s</p><p class=\"gp-hint\">%s</p><button class=\"btn gold wide gp-back\">%s</button></div>" % [tag(have, need), h, T("返村升級", "回村升級")]

static func go_village(before) -> void:
	if before != null: J.cl(before, null, [])
	var St = _g("Street")
	if St is Dictionary:
		var Tf = St.get("Turf")
		if Tf is Dictionary and J.t(Tf.get("on")): J.mc(Tf, "close", [])
		if St.get("close") != null: J.mc(St, "close", [])
	var W = _g("World")
	var doc = _g("document")
	if W is Dictionary and W.get("close") != null and J.t(J.S_document_("querySelector", ["#world.on"])): J.mc(W, "close", [])
	var UI = _g("UI")
	if UI is Dictionary:
		J.mc(UI, "close", [])
		if UI.get("refresh") != null: J.mc(UI, "refresh", [])
		J.F_setTimeout([func(_t, _a): J.mc(UI, "openRoster", []), 60.0])

static func bind_back(root, before) -> void:
	var els = J.mc(root, "querySelectorAll", [".gp-back"]) if J.t(root) else J.S_document_("querySelectorAll", [".gp-back"])
	for b in J.iter(els):
		J.sp(b, "onclick", func(_t, a):
			if a.size() > 0 and a[0] is Dictionary and a[0].get("stopPropagation") != null: J.cl(a[0].stopPropagation, a[0], [])
			go_village(before))

func run(_env) -> void:
	var GP = {
		"REF": REF, "NONE": NONE, "STAGE_NEED": STAGE_NEED.duplicate(),
		"pow": func(_t, a): return pow_(J.arg(a, 0)),
		"mul": func(_t, a): return mul(J.arg(a, 0)),
		"best": func(_t, a): return best(J.arg(a, 0)),
		"kindMul": func(_t, a): var g = best(J.arg(a, 0)); return mul(g) if g != null else NONE,
		"kindPow": func(_t, a): var g = best(J.arg(a, 0)); return pow_(g) if g != null else 0.0,
		"kindGrow": func(_t, a): var g = best(J.arg(a, 0)); return grow(g) if g != null else 1.0,
		"hint": func(_t, a): return hint(J.arg(a, 0)),
		"raw": func(_t, a): return raw(J.arg(a, 0)),
		"grow": func(_t, a): return grow(J.arg(a, 0)),
		"drillMul": func(_t, a): return drill_mul(J.arg(a, 0)),
		"avg": func(_t, a): return avg(J.arg(a, 0)),
		"top": func(_t, a): return top(J.arg(a, 0)),
		"stageNeed": func(_t, a): return stage_need(J.arg(a, 0), J.arg(a, 1)),
		"turfNeed": func(_t, a): return turf_need(J.arg(a, 0)),
		"tag": func(_t, a): return tag(J.arg(a, 0), J.arg(a, 1)),
		"failHTML": func(_t, a): return fail_html(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"goVillage": func(_t, a): go_village(J.arg(a, 0)); return null,
		"bindBack": func(_t, a): bind_back(J.arg(a, 0), J.arg(a, 1)); return null,
		"T": func(_t, a): return T(J.str(J.arg(a, 0)), J.str(J.arg(a, 1)) if J.arg(a, 1) != null else ""),
	}
	J.G["GP"] = GP
	var w = J.G.get("window")
	if w != null: J.sp(w, "GP", GP)
