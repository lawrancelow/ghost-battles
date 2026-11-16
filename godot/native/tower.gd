# 原生改寫自 tower.js（樓裡有鬼）——第三段：Tower 本體（生成大樓、主迴圈、保安、嚇人、大招、畫面、觸控）
# 第一段 LiftSys（native/tower_lift.gd）、第二段 UnitSys（native/tower_unit.gd）由呢度登記做 window.LiftSys／window.UnitSys
# 資料（LEVELS、HH、BLD、對白…）由 tower.js 原文抽出：data/nat/tower_data.json（tools：node 抽取，數值、字串一字不改）
# 隨機數：關卡種子 rnd()（16807）同 Math.random 用法、次序同轉譯版一樣；陣列 forEach 照轉譯版迭代副本、sort 用穩定排序
# 原生畫面輔助（TwDraw／TwDraw2／TwLogic，game/tower/）照用；冇 Recorder 嘅情況下 JS 後備畫法唔使
extends RefCounted

var D: Dictionary = {}        # 抽出嚟嘅資料
var OPEN := false
var RAF := 0.0
var ROOT = null
var _cv = null
var cv = null
var ctx = null                # 而家畫緊嘅 Ctx
var FONT := "\"PingFang HK\",\"PingFang TC\",\"Noto Sans CJK TC\",\"Noto Sans TC\",\"Microsoft JhengHei\",sans-serif"
var DPR := 1.0
var VW := 390.0
var VH := 844.0
var TOP := 96.0
var BOT := 240.0
var IMG: Dictionary = {}
var WW := 600.0
var WH := 900.0
var BOTX := 0.0
var FL := 5.0
var FYS = null
var SX := 0.0
var LX := 0.0
var GLX := 0.0
var PX0 := 0.0
var LV = null
var STORY = null
var TRUTH = null
var FLN = null
var LV0 = null
var LEVELS: Dictionary
var NIGHT := 150.0
var PH: Array
var seed_ := 1
var LINES: Dictionary
var used: Dictionary = {}
var GH: Array
var WARD: Dictionary
var CARDS: Array
const GP_TRAINEE_POW := 250.0
const GP_BASE := {"flat": 1100.0, "shop": 1500.0}
const GP_TIER_MAX := 8.0
const GP_TRAINEE_MSG := "村入面未有呢隻鬼，只係見習水平。返村招募／升級先會變強！"
var G = null
var scene := "title"
var paused := false
var PHT := 60.0
var HUM: Dictionary
var ITEM: Dictionary
var BAGMAX := 10.0
var curLv := "flat"
var BLOCKMSG: Dictionary
var PPL_META: Dictionary
var SAFE = null
const SAFE_R := 150.0
var SCREAM: Array
var SPOOKL: Array
var BALKL: Array
var DROPK: Dictionary
var BLD: Dictionary
var HH: Dictionary
var HHW: Array
var PROP: Dictionary
var PROPLINE: Dictionary

# ---------------- 小工具 ----------------
static func n0(v) -> float: return 0.0 if v == null else J.num(v)
static func T(v) -> bool: return J.t(v)
func rnd() -> float:
	seed_ = (seed_ * 16807) % 2147483647
	return float(seed_ - 1) / 2147483646.0
func pick(a: Array): return a[int(floor(rnd() * a.size()))]
func shuffle(a0: Array) -> Array:
	var a = a0.duplicate()
	var i = a.size() - 1
	while i > 0:
		var j = int(floor(rnd() * (i + 1))); var t = a[i]; a[i] = a[j]; a[j] = t
		i -= 1
	return a
static func clamp_(v: float, a: float, b: float) -> float: return a if v < a else (b if v > b else v)
# 穩定排序（同轉譯版 _stable_sort 一樣：cmp(a,b) < 0 先排前）
static func ssort(arr: Array, cmp: Callable) -> Array:
	if arr.size() < 2: return arr
	var mid = arr.size() / 2
	var l = ssort(arr.slice(0, mid), cmp); var r = ssort(arr.slice(mid), cmp)
	var out = []; var i = 0; var j = 0
	while i < l.size() and j < r.size():
		if J.num(cmp.call(r[j], l[i])) < 0: out.append(r[j]); j += 1
		else: out.append(l[i]); i += 1
	while i < l.size(): out.append(l[i]); i += 1
	while j < r.size(): out.append(r[j]); j += 1
	for k in out.size(): arr[k] = out[k]
	return arr
static func idx_of(arr: Array, o) -> int:
	for k in arr.size(): if J.seq(arr[k], o): return k
	return -1
static func rm(arr: Array, o) -> void:
	# arr.splice(arr.indexOf(o),1)：搵唔到就剷最後一個（同 JS 一樣）
	var i = idx_of(arr, o)
	if i < 0: i = arr.size() - 1
	if i >= 0 and arr.size(): arr.remove_at(i)
static func hyp(x: float, y: float) -> float: return sqrt(x * x + y * y)
func fy(f) -> float: return J.num(FYS[int(J.num(f))])
func line(k: String):
	var p: Array = LINES[k]
	if not used.has(k):
		var ix = []
		for i in p.size(): ix.append(i)
		used[k] = shuffle(ix)
	if (used[k] as Array).is_empty():
		var ix2 = []
		for i in p.size(): ix2.append(i)
		used[k] = shuffle(ix2)
	return p[(used[k] as Array).pop_back()]
static func _w(): return J.G.get("window")
static func _S(): return J.G.get("S")
func TS() -> Dictionary:
	var S = _S()
	if not T(S.get("tower")): S["tower"] = {"unlocked": true, "cleared": {}, "best": 0.0, "nights": 0.0}
	if not T(S.tower.get("cleared")): S.tower["cleared"] = {}
	return S.tower

# ---------------- 關卡 ----------------
func useLevel(k: String) -> void:
	var Tl = LEVELS[k]; LV = genLevel(k); LV["story"] = Tl.story; LV["truth"] = Tl.truth
	var hint = []
	for i in (Tl.story as Array).size(): hint.append("第 " + str(i + 1) + " 段")
	LV["hint"] = hint
	FL = J.num(LV.FL); FYS = LV.FYS; SX = J.num(LV.SX); LX = J.num(LV.LX); GLX = J.num(LV.GLX); PX0 = J.num(LV.PX0); STORY = LV.story; TRUTH = LV.truth; FLN = LV.fln; WW = J.num(LV.WW); WH = J.num(LV.WH)

# ---------------- GP（村入面嘅鬼力） ----------------
func gpRead(d) -> Dictionary:
	var P = J.G.get("GP")
	if not T(P) or not T(d.get("gpk")): return {"mul": 1.0, "pow": 0.0, "tr": false, "na": true}
	var pw = J.mc(P, "kindPow", [d.gpk]); pw = J.num(pw) if T(pw) else 0.0
	var m = J.num(J.mc(P, "kindMul", [d.gpk]))
	if is_nan(m) or is_inf(m) or m <= 0: m = 1.0
	return {"mul": m, "pow": pw, "tr": pw <= 0, "na": false}
func gpApply(g) -> void:
	var r = gpRead(g.d); var m = r.mul; g["mul"] = m; g["pow"] = r.pow; g["trainee"] = r.tr; g["gpNA"] = r.na
	g["spm"] = minf(1.12, 1 + 0.08 * (m - 1)); g["em"] = 1 + 0.2 * (m - 1); g["tm"] = minf(1.3, 1 + 0.1 * (m - 1))
	g["im"] = maxf(0.85, minf(1.35, 1 + 0.15 * (m - 1))); g["icd"] = maxf(0.7, minf(1.1, 1 - 0.15 * (m - 1))); g["um"] = maxf(0.9, minf(1.3, 1 + 0.15 * (m - 1)))
	g["_eL"] = n0(g.get("energy"))
func gpSv(): return TS()
func gpTier(lv: String) -> float:
	if not T(J.G.get("GP")): return 0.0
	var sv = gpSv()
	return minf(GP_TIER_MAX, J.num(sv.get("win_" + lv)) if T(sv.get("win_" + lv)) else 0.0)
func gpNeed(lv: String) -> float: return J.round(J.num(GP_BASE.get(lv, 1100.0)) * (1 + 0.18 * gpTier(lv)) / 10) * 10
func gpDiff(lv: String) -> float: return pow(1 + 0.18 * gpTier(lv), 0.6)
func gpPowOf(d) -> float:
	var r = gpRead(d)
	return 0.0 if r.na else (GP_TRAINEE_POW if r.tr else r.pow)
func gpTeam() -> float:
	var s = 0.0
	for d in GH: s += gpPowOf(d)
	return s
func gpF(g) -> float:
	var m = J.num(g.get("mul")) if T(g) and T(g.get("mul")) else 1.0
	var d = J.num(G.get("gpD")) if T(G) and T(G.get("gpD")) else 1.0
	return m / d
func gpE(g) -> void:
	var e = n0(g.get("energy")); var Lg = g.get("_eL")
	if Lg != null and e > J.num(Lg) and T(g.get("em")) and J.num(g.em) != 1: g["energy"] = minf(100.0, J.num(Lg) + (e - J.num(Lg)) * J.num(g.em))
	g["_eL"] = g.energy
func gpStart() -> void:
	for g in G.gh.duplicate(): gpApply(g)
	G["gpHas"] = T(J.G.get("GP")); G["gpTier"] = gpTier(curLv); G["gpD"] = gpDiff(curLv); G["gpNeed"] = gpNeed(curLv); G["gpTeam"] = gpTeam()
	if T(G.gpHas):
		var tr = false
		for g in G.gh: if T(g.get("trainee")): tr = true; break
		G["gpMsg"] = "今晚" + J.str(LV.name) + "第 " + J.str(J.num(G.gpTier) + 1) + " 級：建議鬼力 " + J.str(G.gpNeed) + "，我哋三隻合共 " + J.str(G.gpTeam) + ("——唔夠喎，小心啲！打唔過就返村升級。" if J.num(G.gpTeam) < J.num(G.gpNeed) else "，夠晒膽！") + ("（有見習鬼）" if tr else "")
	else: G["gpMsg"] = null
func gpTick() -> void:
	if T(G.get("gpMsg")) and J.num(G.t) >= 5.6: toast(G.gpMsg); G["gpMsg"] = null
func gpOnEnd(why: String) -> void:
	var o = G.over; o["gpHas"] = T(G.get("gpHas")); o["gpNeed"] = G.get("gpNeed"); o["gpTeam"] = G.get("gpTeam"); o["gpTier"] = G.get("gpTier")
	if why != "fail" and T(G.get("gpHas")):
		var sv = gpSv(); sv["win_" + curLv] = (J.num(sv.get("win_" + curLv)) if T(sv.get("win_" + curLv)) else 0.0) + 1
		o["gpUp"] = gpTier(curLv) > J.num(G.gpTier)
func gpGoVillage() -> void:
	var o = G.over if T(G) else null
	var need = J.num(o.gpNeed) if T(o) and J.num(o.gpTeam) < J.num(o.gpNeed) else 0.0
	close()
	if T(J.G.get("World")): J.mc(J.G.World, "close", [])
	var ok = false
	var UI = J.G.get("UI")
	if T(UI) and T(J.gp(UI, "openRoster")): J.mc(UI, "openRoster", []); ok = true
	var GP = J.G.get("GP")
	var fx = J.G.get("Fx")
	if T(fx): J.mc(fx, "toast", [("" if ok else "返到村喇！") + (J.str(J.mc(GP, "hint", [need])) if T(GP) else "返村幫隻鬼升級再嚟過！")])

# ---------------- 新一局 ----------------
func newGame(s, lv) -> void:
	if T(lv): curLv = J.str(lv)
	seed_ = int(J.num(s)) if T(s) else (int(fmod(J.now(), 100000.0)) + 7); used = {}; useLevel(curLv)
	G = {"t": 0.0, "phase": 0.0, "nodes": {}, "edges": [], "units": [], "res": [], "guards": [], "floats": [], "fear": 0.0, "fearNext": 30.0, "fearTotal": 0.0,
		"mods": {"spd": 1.0, "pow": 1.0, "inv": 3.0, "task": 1.0, "arm": 1.0, "fear": 1.0}, "story": [], "active": 0.0, "over": null, "choice": null, "toast": null, "toastT": 0.0, "alarm": [],
		"alert": 0.0, "alertLv": 0.0, "bag": [], "dolls": 0.0, "keys": {}, "wave": 0.0, "waveT": 20.0, "gate": null, "gateCharge": 0.0, "captured": 0.0}
	buildMap2(); placeUnits2()
	var gh = []
	for i in GH.size():
		gh.append({"d": GH[i], "i": float(i), "node": "f0_e", "to": null, "p": 0.0, "x": 0.0, "y": 0.0, "dir": 1.0, "loot": 0.0, "taskP": 0.0, "inv": 0.0, "invCd": 0.0, "stun": 0.0, "scareCd": 0.0, "home": false, "energy": 0.0, "actT": 0.0, "hitT": 0.0, "bounceT": 0.0, "mv": 0.0, "ph": randf() * 6, "still": 1.0, "caught": 0.0, "out": false, "mirrored": 0.0})
	G["gh"] = gh
	for g in gh: var n = G.nodes[g.node]; g["x"] = n.x; g["y"] = n.y
	gpStart()
	cam["z"] = 1.0; cam["free"] = null; cam["s"] = VW / (J.num(LV.camW) if T(LV) and T(LV.get("camW")) else 600.0)
	G["parts"] = []; G["ult"] = null; G["wardFx"] = []; G["dark"] = {}
	spawnZoneGuards(); initSafe(); G["pdrops"] = []
	scene = "play"; paused = false
	toast(J.str(LV.name) + "（" + J.str(FL - 1) + " 層＋地庫＋天台）：鬆手企定先嚇得人、搜得嘢。保安唔係捉鬼師傅——附身電器、敲水管、叫𨋢可以引開佢哋。左上細地圖撳一下睇全棟。")

# ---------------- 地圖 ----------------
func node(id: String, x: float, y: float, f: float, kind: String) -> void: G.nodes[id] = {"id": id, "x": x, "y": y, "f": f, "kind": kind, "links": []}
func link(a: String, b: String, ward = null) -> Dictionary:
	var e = {"a": a, "b": b, "ward": ward}; G.edges.append(e); G.nodes[a].links.append({"to": b, "e": e}); G.nodes[b].links.append({"to": a, "e": e}); return e

func genLevel(k: String) -> Dictionary:
	var B = BLD[k]; var NL = (B.levels as Array).size(); var FLn = NL - 1; var FH = J.num(B.FH)
	var W = 0.0
	for c in B.cols: W += J.num(c[1])
	var H = 30 + FLn * FH + J.num(B.ROOF) + 40
	var ys = []
	for f in FLn + 1: ys.append(H - 30 - f * FH)
	var xs = []; var x = 0.0
	for c in B.cols: xs.append([x, x + J.num(c[1]), c[0]]); x += J.num(c[1])
	var colX = func(kind: String):
		for q in xs: if J.str(q[2]) == kind: return (q[0] + q[1]) / 2
		return null
	var ucols = []
	for q in xs: if J.str(q[2]) == "u": ucols.append(q)
	var LVg = {"camW": B.camW, "name": B.name, "key": k, "bg": null, "B": B, "FL": float(FLn), "FYS": ys, "WW": W, "WH": H, "SX": colX.call("stair"), "LX": colX.call("back"), "GLX": colX.call("lift"), "MX": colX.call("lift"), "PX0": ucols[0][0] + 30, "fln": B.levels, "xs": xs, "ucols": ucols, "units": [], "pipes": B.pipes, "lift": B.lift}
	var si = 0
	for f in FLn:
		var wardsF = {}; var nU = ucols.size()
		if f >= 2:
			var ix = []
			for i in nU: ix.append(i)
			var idx = shuffle(ix)
			wardsF[idx[0]] = pick(["fu", "menshen", "datuk"]); wardsF[idx[1]] = "zha"; wardsF[idx[2]] = "nuomi"
			if f % 2 == 0: wardsF[idx[3]] = pick(["zha", "nuomi"])
			if nU >= 8 and f % 3 == 1: wardsF[idx[4]] = "zha"
		if f == 1: wardsF[2] = "datuk"; wardsF[5] = "zha"
		if f == 0: wardsF[1] = "zha"
		for u in ucols.size():
			var c = ucols[u]
			var w = wardsF.get(u, null); var deity = w == "fu" or w == "menshen" or w == "datuk"; var nm; var hh = null
			if f == 0: nm = B.base[u % (B.base as Array).size()]; hh = null
			elif f == 1:
				nm = B.ground[u % (B.ground as Array).size()]
				hh = null if (u == 0 or deity) else (pick(["insomnia", "cook", "gamer"]) if rnd() < 0.5 else null)
			else:
				hh = null if deity else (wpick(HHW) if rnd() < 0.96 else null)
				nm = HH[hh].n if hh != null else "空置單位"
			var doorX = J.round(c[0] + (c[1] - c[0]) * (0.24 if u % 2 else 0.78))
			LVg.units.append([float(f), float(u), w, null, hh, -1.0, nm, doorX, [c[0], c[1]]])
	var cands = []
	for L in LVg.units: if L[4] != null and L[0] >= 3 and L[2] == null: cands.append(L)
	if cands.size(): var d = pick(cands); d[4] = "debt"; d[6] = HH.debt.n
	var STN = (LV0[k].story as Array).size()
	var f2 = 1
	while f2 < FLn and si < STN:
		var lst = []
		for L in LVg.units: if J.num(L[0]) == f2 and L[4] != null and L[2] == null: lst.append(L)
		var sh = shuffle(lst)
		if sh.size(): sh[0][5] = float(si); si += 1
		f2 += 1
	while si < STN:
		var lst2 = []
		for L in LVg.units: if L[4] != null and J.num(L[5]) < 0 and L[2] == null: lst2.append(L)
		var sh2 = shuffle(lst2)
		if sh2.is_empty(): break
		sh2[0][5] = float(si); si += 1
	return LVg

func wpick(a: Array):
	var t = 0.0
	for p in a: t += J.num(p[1])
	var r = rnd() * t
	for i in a.size():
		r -= J.num(a[i][1])
		if r <= 0: return a[i][0]
	return a[0][0]

func buildMap2() -> void:
	var B = LV.B; var FLi = int(FL)
	for f in FLi + 1:
		var y = fy(f); var stops = []
		node("f%d_s" % f, SX, y, f, "stair")
		if f >= 1 or not T(B.lift): node("f%d_b" % f, LX, y, f, "stair")
		node("f%d_l" % f, J.num(LV.MX), y, f, "lift" if T(B.lift) else "stair")
		if f < FLi:
			for L in LV.units: if J.num(L[0]) == f: stops.append({"x": J.num(L[7]), "u": L[1]})
			if f == 0: stops.append({"x": PX0, "p": 1.0})
			var pi = 0
			for P in LV.pipes:
				if J.num(P[0]) == f or J.num(P[1]) == f: var c = LV.ucols[int(J.num(P[2]))]; stops.append({"x": c[1] - 6, "pipe": float(pi)})
				pi += 1
		else:
			stops.append({"x": J.round(WW * 0.5) + 40, "p": 2.0})
			var pi2 = 0
			for P in LV.pipes:
				if J.num(P[1]) == f: var c = LV.ucols[int(J.num(P[2]))]; stops.append({"x": c[1] - 6, "pipe": float(pi2)})
				pi2 += 1
		stops.append({"x": J.num(LV.MX), "lift": 1.0})
		if G.nodes.has("f%d_b" % f): stops.append({"x": LX, "back": 1.0})
		ssort(stops, func(a, b): return J.num(a.x) - J.num(b.x))
		var prev = "f%d_s" % f; var first = true
		for st in stops:
			var id
			if J.num(st.get("p")) == 1: id = "f0_e"; node(id, J.num(st.x), y, 0, "portal")
			elif J.num(st.get("p")) == 2: id = "f%d_p" % FLi; node(id, J.num(st.x), y, f, "portal")
			elif T(st.get("lift")): id = "f%d_l" % f
			elif T(st.get("back")): id = "f%d_b" % f
			elif st.get("pipe") != null: id = "f%d_q%d" % [f, int(st.pipe)]; node(id, J.num(st.x), y, f, "pipe")
			else:
				id = "f%d_d%d" % [f, int(J.num(st.u))]; node(id, J.num(st.x), y, f, "door"); node("f%d_i%d" % [f, int(J.num(st.u))], J.num(st.x) - 14, y - 34, f, "in")
				var e = link(id, "f%d_i%d" % [f, int(J.num(st.u))]); e["door"] = true
			var le = link(prev, id)
			if first: le["fire"] = {"shut": 0.0, "cd": 0.0, "x": (J.num(G.nodes[prev].x) + J.num(G.nodes[id].x)) / 2, "f": float(f)}; first = false
			prev = id
		if prev == "f%d_b" % f:
			var lk: Array = G.nodes[prev].links; var lastE = lk[lk.size() - 1].e
			lastE["fire"] = {"shut": 0.0, "cd": 0.0, "x": (J.num(G.nodes[lastE.a].x) + J.num(G.nodes[lastE.b].x)) / 2, "f": float(f)}
		if f > 0:
			link("f%d_s" % (f - 1), "f%d_s" % f)["vert"] = true
			var le2 = link("f%d_l" % (f - 1), "f%d_l" % f); le2["vert"] = true
			if T(B.lift): le2["lift"] = true
			if G.nodes.has("f%d_b" % (f - 1)) and G.nodes.has("f%d_b" % f): link("f%d_b" % (f - 1), "f%d_b" % f)["vert"] = true
	var i = 0
	for P in LV.pipes:
		var e2 = link("f%d_q%d" % [int(J.num(P[0])), i], "f%d_q%d" % [int(J.num(P[1])), i]); e2["vert"] = true; e2["pipe"] = true
		i += 1

func _find_link(n, to: String):
	for l in n.links: if J.str(l.to) == to: return l
	return null

func placeUnits2() -> void:
	G["traces"] = []
	for L in LV.units:
		var f = J.num(L[0]); var u = J.num(L[1]); var w = L[2]; var hh = HH[L[4]] if L[4] != null else null
		var id = "f%d_i%d" % [int(f), int(u)]; var did = "f%d_d%d" % [int(f), int(u)]; var e = _find_link(G.nodes[did], id).e; e["ward"] = w
		var un = {"f": f, "u": u, "id": id, "did": did, "ward": w, "task": null, "story": J.num(L[5]) >= 0, "si": L[5], "name": L[6], "x": G.nodes[did].x, "y": fy(f), "rx": L[8], "lit": false, "litT": 0.0, "hh": L[4],
			"open": true, "ot": 0.0, "cost": 0.0, "paid": 0.0, "seen": false, "entered": false, "plus": 2.0 if J.num(L[5]) >= 0 else 1.0, "items": [], "door": false, "doorOpen": 0.0, "ambush": null, "dep": null, "keyNeed": null, "rs": [], "props": []}
		if w == "fu" or w == "menshen" or w == "datuk": un["open"] = false; un["ot"] = "deity"
		elif w == "zha": un["open"] = false; un["ot"] = 2.0; un["cost"] = 4 + f
		elif w == "nuomi": un["open"] = false; un["ot"] = 2.0; un["cost"] = 3 + f
		if hh != null:
			for it in hh.items: un.items.append(it)
		elif f == 1 and J.str(un.ot) != "deity": un.items.append(pick(["food", "money", "comb"]))
		if hh != null and J.str(un.ot) != "deity":
			var n = (hh.sp as Array).size(); var w0 = J.num(un.rx[1]) - J.num(un.rx[0])
			for i in n:
				var sp = hh.sp[i]
				var hw0 = ((60.0 if i % 2 else 66.0) if n >= 3 else 74.0) * 0.47 + 4
				var px = J.num(un.rx[0]) + w0 * (0.42 if n == 1 else (0.18 + 0.64 * i / (n - 1) if n >= 3 else 0.28 + 0.44 * i / (n - 1)))
				if n < 3 and absf(px - J.num(un.x)) < 22: px += -24.0 if px < J.num(un.x) else 24.0
				px = maxf(J.num(un.rx[0]) + hw0, minf(J.num(un.rx[1]) - hw0, px))
				var r = {"h": (60.0 if i % 2 else 66.0) if n >= 3 else 74.0, "dy": -8.0 if n >= 3 and i % 2 else 0.0, "unit": un, "sprite": sp, "x": px, "y": fy(f) - 16, "fear": 0.0, "brave": J.num(hh.get("brave")) if T(hh.get("brave")) else 0.0, "state": "home", "vx": 0.0, "doorT": 8 + rnd() * 10, "hh": L[4], "awake": J.num(hh.awake[0]) == 1, "idleT": 4 + rnd() * 10}
				if T(hh.get("away")): r["state"] = "away"
				G.res.append(r); un.rs.append(r)
			un["res"] = un.rs[0]
			var i2 = 0
			for p in hh.props:
				un.props.append({"k": p, "x": J.num(un.rx[0]) + w0 * (0.3 + 0.4 * i2) + (8.0 if i2 else -8.0), "t": 0.0, "cd": 0.0}); i2 += 1
		G.units.append(un); e["unit"] = un
	for u in G.units.duplicate():
		if not (J.str(u.ot) == "0" or (u.ot is float and u.ot == 0)) or J.num(u.f) < 2: continue
		var nb = null
		for v in G.units:
			if J.num(v.f) == J.num(u.f) and not is_same(v, u) and (v.rs as Array).size() and J.str(v.ot) != "deity" and absf(J.num(v.u) - J.num(u.u)) == 1: nb = v; break
		if nb != null and (T(u.story) or rnd() < 0.22): u["open"] = false; u["ot"] = 1.0; u["dep"] = nb
	var keyNames = ["key", "key2"]; var tops = []
	for u in G.units: if _ot0(u) and J.num(u.f) >= FL - 3 and (u.rs as Array).size(): tops.append(u)
	ssort(tops, func(a, b): return J.num(b.f) - J.num(a.f))
	var keyUnits = []
	for i in keyNames.size():
		if i * 2 < tops.size(): var t = tops[i * 2]; t["open"] = false; t["ot"] = 11.0; t["keyNeed"] = keyNames[i]; keyUnits.append(t)
	var cand = []
	for u in G.units: if J.str(u.ot) != "deity" and idx_of(keyUnits, u) < 0: cand.append(u)
	for i in keyNames.size():
		if i >= keyUnits.size(): continue
		var lst = []
		for u in cand: if J.num(u.f) < J.num(keyUnits[i].f) - 1: lst.append(u)
		var sh = shuffle(lst)
		if sh.size(): sh[0].items.append(keyNames[i])
	var dolls = 0
	for u in shuffle(cand):
		if dolls < 12: u.items.append("doll"); dolls += 1
	var dl = []
	for u in G.units: if (u.rs as Array).size() and _ot0(u) and J.num(u.f) >= 2: dl.append(u)
	for u in shuffle(dl).slice(0, 6): u["door"] = true
	var am = []
	for u in G.units: if (u.rs as Array).is_empty() and J.str(u.ot) != "deity" and J.num(u.f) >= 1: am.append(u)
	for u in shuffle(am).slice(0, 3): u["ambush"] = "dog"
	for u in G.units.duplicate():
		u["seen"] = (_ot0(u) or J.str(u.ot) == "deity") and not T(u.ambush) and J.num(u.f) <= 1
		if _ot0(u) and not T(u.ambush) and J.num(u.f) > 1 and rnd() < 0.5: u["seen"] = true
	G["cprops"] = []
	var f3 = 1
	while f3 < FL:
		var lst3 = []
		for u in G.units: if J.num(u.f) == f3: lst3.append(u)
		var ds = shuffle(lst3)
		if ds.size() > 0: G.cprops.append({"k": "pipeK", "node": ds[0].did, "f": float(f3), "t": 0.0, "cd": 0.0})
		if ds.size() > 1: G.cprops.append({"k": "light", "node": ds[1].did, "f": float(f3), "t": 0.0, "cd": 0.0})
		f3 += 1
	G["quests"] = []
	var olds = []
	for u in G.units: if (J.str(u.hh) == "elder" or J.str(u.hh) == "granny") and J.num(u.f) >= 2 and T(u.open): olds.append(u)
	if olds.is_empty():
		for u in G.units: if J.str(u.hh) == "elder" or J.str(u.hh) == "granny": olds.append(u)
	if olds.size():
		var ow = pick(olds); var thing = pick(["老花鏡", "假牙", "結婚戒指", "錢罌"])
		var lst4 = []
		for u in cand: if not is_same(u, ow) and absf(J.num(u.f) - J.num(ow.f)) >= 2: lst4.append(u)
		var sh4 = shuffle(lst4)
		var hid = sh4[0] if sh4.size() else null
		if hid != null:
			hid.items.push_front("lost")
			G.quests.append({"id": "lost", "t": "搵返" + J.str(FLN[int(J.num(ow.f))]) + ("伯伯" if J.str(ow.hh) == "elder" else "婆婆") + "嘅" + thing, "thing": thing, "owner": ow, "hid": hid, "state": 0.0}); ow["questMark"] = 1.0
	var dbt = null
	for u in G.units: if J.str(u.hh) == "debt": dbt = u; break
	if dbt != null: G.quests.append({"id": "debt", "t": "嚇走" + J.str(FLN[int(J.num(dbt.f))]) + "拍門嘅收數佬", "unit": dbt, "state": 0.0, "at": 30 + rnd() * 25})
	var mj = null
	for u in G.units: if J.str(u.hh) == "mahjong": mj = u; break
	if mj != null: G.quests.append({"id": "mj", "t": "散咗" + J.str(FLN[int(J.num(mj.f))]) + "嘅麻雀局（四個都嚇走）", "unit": mj, "state": 0.0})
	G["relief"] = []; G["alertAcc"] = 0.0

static func _ot0(u) -> bool: return (u.ot is float or u.ot is int) and J.num(u.ot) == 0

func unitByDoor(did) -> Variant:
	for u in G.units: if J.str(u.did) == J.str(did): return u
	return null
func unitOf(id) -> Variant:
	for u in G.units: if J.str(u.id) == J.str(id): return u
	return null
func mkHuman(kind: String, nodeId: String, extra = null) -> Dictionary:
	var n = G.nodes[nodeId]
	var h = {"kind": kind, "node": nodeId, "to": null, "p": 0.0, "x": n.x, "y": n.y, "dir": 1.0, "wait": 1.0, "talkT": 3 + rnd() * 5, "courage": 5.0 if kind == "compass" else (2.0 if kind == "decoy" else 1.0), "path": null, "repath": 0.0, "chase": null, "alertT": 0.0, "state": "patrol"}
	if extra is Dictionary:
		for k in extra: h[k] = extra[k]
	return h
func spawnZoneGuards() -> void:
	var nz = maxf(2.0, J.round((FL - 1) / 3)); var span = (FL - 1) / nz
	for i in int(nz):
		var a = 1 + J.round(i * span); var b = minf(FL - 1, J.round((i + 1) * span))
		var h = mkHuman("guard", "f%d_%s" % [int(a), "b" if i % 2 else "s"]); h["zone"] = [a, b]; G.guards.append(h)
func inZone(h, f: float, pad := 0.0) -> bool: return not T(h.get("zone")) or (f >= J.num(h.zone[0]) - pad and f <= J.num(h.zone[1]) + pad)
func toast(m) -> void: G["toast"] = m; G["toastT"] = 5.5
func float_(x: float, y: float, t, c = null) -> void:
	if not T(G): return
	var now = J.S_performance_("now", [])
	if not T(G.get("fcd")): G["fcd"] = {}
	var fc = G.fcd; var ts = J.str(t); var L0 = fc.get(ts)
	if T(L0) and now - J.num(L0.t) < 1500 and absf(J.num(L0.x) - x) < 260 and absf(J.num(L0.y) - y) < 200: return
	for f in G.floats: if J.str(f.t) == ts and absf(J.num(f.x) - x) < 260 and absf(J.num(f.y0) - y) < 200: return
	fc[ts] = {"t": now, "x": x, "y": y}
	var yy = y; var k = 0
	while k < 4:
		var hit = false
		for f in G.floats: if absf(J.num(f.x) - x) < 120 and absf(J.num(f.y) - yy) < 17: hit = true; break
		if not hit: break
		yy -= 18; k += 1
	G.floats.append({"x": x, "y": yy, "y0": y, "t": t, "c": c if T(c) else "#fff", "life": 1.6})
	if G.floats.size() > 10: G.floats.pop_front()

func shortcut(g, e) -> bool: return T(e.get("ward")) and T(g.d.cross.get(J.str(e.ward)))
func canPass(g, e):
	var gate = G.get("gate")
	if T(gate) and T(e.get("vert")) and (J.num(G.nodes[e.a].f) == J.num(gate.f) or J.num(G.nodes[e.b].f) == J.num(gate.f)): return "stairSeal"
	if not T(e.get("door")): return true
	var un = e.unit
	if J.str(un.ot) == "deity": return "deity"
	if not T(un.open) and not shortcut(g, e): return "breach" if J.num(un.ot) == 2 else ("key" if J.num(un.ot) == 11 else "chain")
	if T(un.door) and J.num(un.doorOpen) <= 0 and not shortcut(g, e): return "door"
	return true
func humanPass(h, e) -> bool:
	if T(e.get("pipe")): return false
	if T(e.get("fire")) and J.num(e.fire.shut) > 0: return false
	if J.str(h.kind) == "dog" and T(e.get("door")) and T(e.unit.door) and J.num(e.unit.doorOpen) <= 0: return false
	if T(e.get("door")) and J.str(e.unit.ot) == "deity": return false
	return true

# ---------------- 鬼移動 ----------------
func joyMove(g, jx: float, jy: float, dt: float) -> void:
	if J.num(g.stun) > 0 or T(g.home) or T(g.out): return
	var Lh = hyp(jx, jy)
	if Lh < 0.25: return
	jx /= Lh; jy /= Lh
	var mt = mirrorOn(g)
	if mt != null and signf(J.num(mt.x) - J.num(g.x)) == signf(jx) and absf(jx) > 0.3:
		if not T(g.get("blockT")) or J.num(g.blockT) <= 0: float_(J.num(g.x), J.num(g.y) - 80, "被鏡照住！轉身先走得", "#ffe9a0"); g["blockT"] = 1.0
		return
	var sp = J.num(g.d.sp) * J.num(G.mods.spd) * (J.num(g.spm) if T(g.get("spm")) else 1.0)
	if not T(g.to):
		var n = G.nodes[g.node]; var best = null; var bd = 0.55
		for l in n.links:
			var m = G.nodes[l.to]; var dx = J.num(m.x) - J.num(n.x); var dy = J.num(m.y) - J.num(n.y); var D2 = hyp(dx, dy); var dot = (dx * jx + dy * jy) / D2
			if absf(dy) > absf(dx): dot += 0.12
			if dot > bd: bd = dot; best = l
		if best == null: return
		var ok = canPass(g, best.e)
		if not (ok is bool and ok):
			if not T(g.get("blockT")) or J.num(g.blockT) <= 0:
				float_(J.num(n.x), J.num(n.y) - 80, BLOCKMSG[ok], "#ffd54a"); g["blockT"] = 1.4; g["bounceT"] = 0.45
				if J.str(ok) == "deity": G.wardFx.append({"x": n.x, "y": n.y, "t": 0.9})
			return
		g["to"] = best.to; g["p"] = 0.0
	var a = G.nodes[g.node]; var b = G.nodes[g.to]; var dx2 = J.num(b.x) - J.num(a.x); var dy2 = J.num(b.y) - J.num(a.y); var D = hyp(dx2, dy2); var dot2 = (dx2 * jx + dy2 * jy) / D
	if dot2 < -0.3: var t = g.node; g["node"] = g.to; g["to"] = t; g["p"] = 1 - J.num(g.p); return
	g["p"] = J.num(g.p) + sp * dt / D
	if dx2: g["dir"] = 1.0 if dx2 > 0 else -1.0
	g["still"] = 0.0; g["taskP"] = 0.0
	if J.num(g.p) >= 1: g["node"] = g.to; g["to"] = null; g["p"] = 0.0; onArrive(g)

func posOf(o) -> Vector2:
	var a = G.nodes[o.node]
	if not T(o.get("to")): return Vector2(J.num(a.x), J.num(a.y))
	var b = G.nodes[o.to]
	return Vector2(J.num(a.x) + (J.num(b.x) - J.num(a.x)) * J.num(o.p), J.num(a.y) + (J.num(b.y) - J.num(a.y)) * J.num(o.p))
# posOf 用 Vector2 會失精度（float32）——邏輯用呢個
func posOfD(o) -> Array:
	var a = G.nodes[o.node]
	if not T(o.get("to")): return [J.num(a.x), J.num(a.y)]
	var b = G.nodes[o.to]
	return [J.num(a.x) + (J.num(b.x) - J.num(a.x)) * J.num(o.p), J.num(a.y) + (J.num(b.y) - J.num(a.y)) * J.num(o.p)]

func onArrive(g) -> void:
	var n = G.nodes[g.node]
	if J.str(n.kind) == "in":
		var un = unitOf(n.id)
		if not T(un.entered):
			un["entered"] = true; un["seen"] = true; G["alert"] = J.num(G.alert) + J.num(un.plus); float_(J.num(n.x), J.num(n.y) - 90, "全樓警覺 +" + J.str(un.plus), "#ff9a9a"); checkAlert()
			if J.str(un.ambush) == "dog":
				un["ambush"] = null; var d = mkHuman("dog", J.str(un.did), {"state": "chase"}); d["alertT"] = 1.4; G.guards.append(d); G["shake"] = 0.4; float_(J.num(n.x), J.num(n.y) - 110, "黑屋有隻狗醒咗！", "#ffb0b0"); G["alert"] = J.num(G.alert) + 1
	if J.str(n.kind) == "portal" and J.num(g.i) == J.num(G.active): float_(J.num(n.x), J.num(n.y) - 70, "陰門：企定按「開陰門」", "#9fd6bf")
	if UNIT != null and J.str(n.kind) == "in": J.mc(UNIT, "arrive", [g, n])

func gotoNode(g, target) -> bool:
	var tgt = J.str(target); var prev = {}; var q = [J.str(g.node)]; var seen = {}; seen[J.str(g.node)] = 1
	while q.size():
		var c = q.pop_front()
		if c == tgt: break
		for l in G.nodes[c].links:
			var lt = J.str(l.to)
			if not seen.has(lt):
				var ok = canPass(g, l.e)
				if ok is bool and ok: seen[lt] = 1; prev[lt] = c; q.append(lt)
	if not seen.has(tgt): return false
	var path = [tgt]
	while path[0] != J.str(g.node): path.push_front(prev[path[0]])
	g["auto"] = path.slice(1); return true

func dijkstra(h, src: String, dst: String):
	var dist = {}; var prev = {}; var Q = G.nodes.keys()
	for k in Q: dist[k] = 1e9
	dist[src] = 0.0
	while Q.size():
		var bi = 0
		for i in range(1, Q.size()): if dist[Q[i]] < dist[Q[bi]]: bi = i
		var u = Q[bi]; Q.remove_at(bi)
		if u == dst or dist[u] >= 1e9: break
		for l in G.nodes[u].links:
			if not humanPass(h, l.e): continue
			if safeNode(l.to) and not safeNode(src): continue
			var a = G.nodes[u]; var b = G.nodes[l.to]; var w = hyp(J.num(a.x) - J.num(b.x), J.num(a.y) - J.num(b.y))
			if dist[u] + w < dist[l.to]: dist[l.to] = dist[u] + w; prev[l.to] = u
	if dist[dst] >= 1e9: return null
	var p = [dst]
	while p[0] != src: p.push_front(prev[p[0]])
	return p.slice(1)
func humanPassTo(h, a, b) -> bool:
	var l = _find_link(a, J.str(b.id))
	return l == null or humanPass(h, l.e)
func nearNode(o):
	var best = null; var bd = 1e9
	for k in G.nodes:
		var n = G.nodes[k]
		if J.str(n.kind) == "in": continue
		var d = absf(J.num(n.x) - J.num(o.x)) + absf(J.num(n.y) - J.num(o.y)) * 3
		if d < bd: bd = d; best = k
	return best
func mirrorOn(g):
	if inSafe(g): return null
	var m = null
	for h in G.guards.duplicate():
		if J.str(h.kind) != "mirror" or J.str(h.state) == "gone": continue
		if absf(J.num(h.y) - J.num(g.y)) > 40: continue
		var dx = J.num(g.x) - J.num(h.x)
		if absf(dx) > 220: continue
		if signf(dx) == J.num(h.dir) and J.num(g.dir) == -J.num(h.dir): m = h
	return m

# ---------------- 主更新 ----------------
func update(dt: float) -> void:
	if T(G.over) or T(G.choice) or paused: return
	if T(G.get("ult")):
		G.ult["t"] = J.num(G.ult.t) + dt
		if J.num(G.ult.t) < 1.3: stepFx(dt); return
		if not T(G.ult.get("done")): G.ult["done"] = true; applyUlt(G.ult)
		if J.num(G.ult.t) > 4: G["ult"] = null; G["ultCool"] = 1.5
	G["t"] = J.num(G.t) + dt; var np = minf(3.0, floor(J.num(G.t) / PHT))
	if np != J.num(G.phase): G["phase"] = np; toast(J.str(PH[int(np)]) + "到喇——巡邏加派，越近天光人越精。" if np < 3 else "天光喇！樓下開始有人起身，追兵越嚟越快，快啲走！")
	G["toastT"] = J.num(G.toastT) - dt; gpTick()
	if not T(G.get("traces")): G["traces"] = []
	setupBeans()
	G["waveT"] = J.num(G.waveT) - dt
	if J.num(G.waveT) <= 0 and not T(G.gate):
		G["wave"] = J.num(G.wave) + 1; G["waveT"] = (18.0 if J.num(G.phase) >= 3 else 30.0) / (1 + 0.06 * n0(G.get("gpTier")))
		var f = 1 + floor(rnd() * (FL - 1)); var h = mkHuman("guard", "f%d_%s" % [int(f), "s" if rnd() < 0.5 else "l"]); h["zone"] = [maxf(1.0, f - 1), minf(FL - 1, f + 1)]
		h["boost"] = pow(1.15, J.num(G.wave)) if J.num(G.phase) >= 3 else 1.0; G.guards.append(h); float_(J.num(h.x), J.num(h.y) - 80, "加派保安", "#ffb0b0")
	for g in G.gh.duplicate(): _ghost_tick(g, dt)
	if T(J.G.get("__twNatL")): TwLogic.res_tick(G, dt, SX, LX)
	else:
		for r in G.res.duplicate():
			pplResTick(r, dt); r["jumpT"] = maxf(0.0, n0(r.get("jumpT")) - dt); r["_pj"] = r.jumpT; r["tangle"] = maxf(0.0, n0(r.get("tangle")) - dt)
			if J.str(r.state) == "flee":
				if n0(r.get("tripT")) > 0: r["tripT"] = J.num(r.tripT) - dt; r["x"] = J.num(r.x) + J.num(r.vx) * 0.18 * dt
				else: r["x"] = J.num(r.x) + J.num(r.vx) * dt
				if J.num(r.x) < SX or J.num(r.x) > LX: r["state"] = "gone"
				if rnd() < dt * 8: part(J.num(r.x) - signf(J.num(r.vx)) * 10, J.num(r.y) - 4, -J.num(r.vx) * 0.1, -10, 0.5, "dust")
			if J.str(r.state) == "home" and T(r.unit.door):
				r["doorT"] = J.num(r.doorT) - dt
				if J.num(r.doorT) <= 0: r.unit["doorOpen"] = 2.6; r["doorT"] = 12 + rnd() * 8; say(r, pick(["出去倒杯水先", "邊個喺門口？", "開門透下氣"]))
			if J.num(r.unit.doorOpen) > 0: r.unit["doorOpen"] = J.num(r.unit.doorOpen) - dt
	if J.num(G.phase) >= 2 and T(J.G.get("__twNatL")): TwLogic.lit(G, dt)
	elif J.num(G.phase) >= 2:
		for un in G.units.duplicate():
			un["litT"] = J.num(un.litT) - dt
			if T(un.get("res")) and J.str(un.res.state) == "home" and not T(un.lit) and rnd() < dt * 0.04: un["lit"] = true; un["litT"] = 7.0; say(un.res, line("wake"))
			if T(un.lit) and J.num(un.litT) <= 0: un["lit"] = false
	traceUpdate(dt); G["phoneCd"] = maxf(0.0, n0(G.get("phoneCd")) - dt)
	resUpdate2(dt); pplTick(dt)
	for h in G.guards.duplicate(): humanUpdate(h, dt)
	var ng = []
	for h in G.guards: if J.str(h.state) != "gone": ng.append(h)
	G["guards"] = ng
	G["ultCool"] = maxf(0.0, n0(G.get("ultCool")) - dt)
	if n0(G.get("choiceQ")) > 0 and not T(G.get("ult")) and J.num(G.ultCool) <= 0: G["choiceQ"] = J.num(G.choiceQ) - 1; G["choice"] = shuffle(CARDS).slice(0, 3)
	checkAlert(); taoUpdate(dt); gateUpdate(dt)
	stepFx(dt)
	for f in G.floats: f["life"] = J.num(f.life) - dt; f["y"] = J.num(f.y) - dt * 22
	var nf = []
	for f in G.floats: if J.num(f.life) > 0: nf.append(f)
	G["floats"] = nf
	for r in G.res.duplicate():
		if T(r.get("say")):
			r["sayT"] = J.num(r.sayT) - dt
			if J.num(r.sayT) <= 0: r["say"] = null
	var allout = true
	for g in G.gh: if not T(g.out): allout = false; break
	if allout: endNight("fail")

func _ghost_tick(g, dt: float) -> void:
	gpE(g)
	if T(g.home) or T(g.out): return
	g["blockT"] = n0(g.get("blockT")) - dt; g["inv"] = maxf(0.0, J.num(g.inv) - dt); g["invCd"] = maxf(0.0, J.num(g.invCd) - dt); g["stun"] = maxf(0.0, J.num(g.stun) - dt); g["scareCd"] = maxf(0.0, J.num(g.scareCd) - dt)
	g["actT"] = maxf(0.0, J.num(g.actT) - dt); g["hitT"] = maxf(0.0, J.num(g.hitT) - dt); g["bounceT"] = maxf(0.0, J.num(g.bounceT) - dt); g["sealT"] = maxf(0.0, n0(g.get("sealT")) - dt); g["dropT"] = maxf(0.0, n0(g.get("dropT")) - dt)
	if T(g.get("inUnit")): return
	moveUpdate(g, dt); beansCheck(g, dt)
	if J.str(g.d.key) == "toyol":
		g["flipT"] = maxf(0.0, n0(g.get("flipT")) - dt)
		if J.num(g.mv) > 0:
			g["flipCd"] = (1.2 if g.get("flipCd") == null else J.num(g.flipCd)) - dt
			if J.num(g.flipCd) <= 0: g["flipT"] = 0.55; g["flipCd"] = 2.2 + rnd() * 1.5
	var auto = g.get("auto")
	if T(auto) and (auto as Array).size():
		var nx = J.str(auto[0])
		if not T(g.to):
			if J.str(g.node) == nx: auto.pop_front()
			else:
				var ln = _find_link(G.nodes[g.node], nx)
				var ok = canPass(g, ln.e) if ln != null else false
				if ln != null and ok is bool and ok: g["to"] = nx; g["p"] = 0.0
				else: g["auto"] = null
		if T(g.to):
			var a = G.nodes[g.node]; var b = G.nodes[g.to]; var D = hyp(J.num(b.x) - J.num(a.x), J.num(b.y) - J.num(a.y))
			g["p"] = J.num(g.p) + J.num(g.d.sp) * J.num(G.mods.spd) * (J.num(g.spm) if T(g.get("spm")) else 1.0) * dt / D; g["still"] = 0.0; g["taskP"] = 0.0
			if J.num(b.x) != J.num(a.x): g["dir"] = 1.0 if J.num(b.x) > J.num(a.x) else -1.0
			if J.num(g.p) >= 1:
				g["node"] = g.to; g["to"] = null; g["p"] = 0.0
				if T(g.get("auto")) and (g.auto as Array).size() and J.str(g.auto[0]) == J.str(g.node): g.auto.pop_front()
				onArrive(g)
	var p = posOfD(g); g["mv"] = maxf(0.0, J.num(g.mv) - dt)
	if absf(p[0] - J.num(g.x)) + absf(p[1] - J.num(g.y)) > 0.2: g["mv"] = 0.18; g["still"] = 0.0
	else: g["still"] = J.num(g.still) + dt
	g["x"] = p[0]; g["y"] = p[1]
	if T(g.get("autoS")) and not T(g.to) and not (T(g.get("auto")) and (g.auto as Array).size()) and J.num(g.still) >= 0.12 and J.num(g.stun) <= 0 and J.num(g.scareCd) <= 0:
		g["autoS"] = null
		if J.num(G.active) == J.num(g.i) and J.num(g.scareCd) <= 0: scarePress()
	var n = G.nodes[g.node]; var st = not T(g.to) and J.num(g.still) >= 0.1 and J.num(g.stun) <= 0 and mirrorOn(g) == null
	if st and J.str(n.kind) == "in":
		var un = unitOf(n.id)
		if T(un.lit): float_(J.num(g.x), J.num(g.y) - 70, "開咗燈！被逼返出去", "#ffb0b0"); g["node"] = un.did; g["stun"] = 0.6; loseLoot(g, 0.3)
		else:
			var it = null
			for k in un.items:
				var I = ITEM[J.str(k)]
				if not T(I.get("who")) or J.str(I.who) == J.str(g.d.key): it = k; break
			if it != null:
				var its = J.str(it)
				if its != "doll" and its != "key" and its != "key2" and its != "lost" and G.bag.size() >= BAGMAX:
					if not T(g.get("fullT")) or J.num(g.fullT) <= 0: float_(J.num(g.x), J.num(g.y) - 80, "收穫格滿咗！", "#ffb0b0"); g["fullT"] = 2.0
					g["fullT"] = J.num(g.fullT) - dt
				else:
					g["taskP"] = J.num(g.taskP) + dt * J.num(G.mods.task) * (J.num(g.tm) if T(g.get("tm")) else 1.0) / J.num(ITEM[its].t)
					if rnd() < dt * 14:
						if J.str(g.d.key) == "toyol":
							var pn = {"x": J.num(g.x) + J.num(g.dir) * 30, "y": J.num(g.y) - 36, "vx": rnd(), "vy": 0.0, "life": 0.7, "max": 0.7, "type": "note"}; pn["tx"] = g.x; pn["ty"] = J.num(g.y) - J.num(g.d.h) * 0.45; G.parts.append(pn)
						elif J.str(g.d.key) == "tianhua": part(J.num(g.x) + (rnd() - 0.5) * 20, J.num(g.y) - J.num(g.d.h) * 0.5, (rnd() - 0.5) * 60, -40 - rnd() * 40, 0.7, "hair")
					if J.num(g.taskP) >= 1: g["taskP"] = 0.0; rm(un.items, it); takeItem(g, it, un)
			if T(un.get("res")) and J.str(un.res.state) == "home":
				un.res["fear"] = J.num(un.res.fear) + dt * 3 * J.num(G.mods.pow) * gpF(g)
				if J.num(un.res.fear) >= 100: flee(un.res, g)
	elif not st: g["taskP"] = 0.0
	if not T(g.to) and J.str(n.kind) == "door":
		var du = unitByDoor(n.id); g["injT"] = n0(g.get("injT")) + dt if st else 0.0
		if du != null and not T(du.open) and J.num(du.ot) == 2 and J.num(g.injT) >= 0.5:
			g["injAcc"] = n0(g.get("injAcc")) + dt
			while J.num(g.injAcc) >= 0.1 and J.num(G.fear) > 0 and J.num(du.paid) < J.num(du.cost):
				g["injAcc"] = J.num(g.injAcc) - 0.1; G["fear"] = J.num(G.fear) - 1; du["paid"] = J.num(du.paid) + 1
				if rnd() < 0.6: part(J.num(g.x), J.num(g.y) - 40, (J.num(du.x) - J.num(g.x)) * 2, -20, 0.5, "suck")
			if J.num(du.paid) >= J.num(du.cost): unlockUnit(du, "鎮宅破咗！")
			elif J.num(G.fear) <= 0 and (not T(g.get("blockT")) or J.num(g.blockT) <= 0): float_(J.num(g.x), J.num(g.y) - 80, "怕意唔夠，去嚇多啲人", "#ffd54a"); g["blockT"] = 6.0
		if du != null and not T(du.open) and J.num(du.ot) == 11 and st and n0(G.keys.get(J.str(du.keyNeed))) > 0:
			G.keys[J.str(du.keyNeed)] = J.num(G.keys[J.str(du.keyNeed)]) - 1; unlockUnit(du, "用" + J.str(ITEM[J.str(du.keyNeed)].n) + "開咗門")
	else: g["injT"] = 0.0

func takeItem(g, it, un) -> void:
	var its = J.str(it)
	if its == "doll":
		G["dolls"] = J.num(G.dolls) + 1; float_(J.num(g.x), J.num(g.y) - 90, "替身紙人 " + J.str(G.dolls) + "/6", "#e8d8b0")
		if J.num(G.dolls) == 6: toast("替身紙人夠 6 個！隨時可以按「替身遁走」，但係故事碎片同部分收穫會留低。")
		return
	if its == "key" or its == "key2": G.keys[its] = n0(G.keys.get(its)) + 1; float_(J.num(g.x), J.num(g.y) - 90, "偷到" + J.str(ITEM[its].n) + "！", "#ffd54a"); return
	if its == "lost":
		G["carry"] = "lost"; var q = null
		for x in (G.quests if T(G.get("quests")) else []): if J.str(x.id) == "lost": q = x; break
		float_(J.num(g.x), J.num(g.y) - 90, "搵到" + (J.str(q.thing) if q != null else "失物") + "！帶返去俾" + (J.str(FLN[int(J.num(q.owner.f))]) if q != null else "") + "嘅主人", "#8affc8"); return
	if its == "food" and J.str(g.d.key) == "eking": g["fat"] = minf(0.3, n0(g.get("fat")) + 0.06); float_(J.num(g.x), J.num(g.y) - J.num(g.d.h) - 30, "越食越餓……", "#ffb7a0")
	G.bag.append({"t": it, "o": g.i}); g["loot"] = J.num(g.loot) + 1; g["energy"] = minf(100.0, J.num(g.energy) + 12); float_(J.num(g.x), J.num(g.y) - 90, "收到" + J.str(ITEM[its].n) + "（" + str(G.bag.size()) + "/" + J.str(BAGMAX) + "）", "#ffd54a")
func unlockUnit(u, msg) -> void:
	if T(u.open): return
	u["open"] = true; float_(J.num(u.x), J.num(u.y) - 90, msg, "#9fd6bf"); G.wardFx.append({"x": u.x, "y": u.y, "t": 0.9}); u["unlockFx"] = 1.2
func checkAlert() -> void:
	var al = J.num(G.alert); var lv = 3.0 if al >= 10 else (2.0 if al >= 6 else (1.0 if al >= 3 else 0.0))
	while J.num(G.alertLv) < lv:
		G["alertLv"] = J.num(G.alertLv) + 1
		var fr = 1 + floor(rnd() * (FL - 1))
		if J.num(G.alertLv) == 1: G.guards.append(mkHuman("compass", "f%d_s" % int(fr))); toast("全樓警覺 3：管理處加派「羅盤保安」——每次只嚇得走佢一點膽，靠閂門同繞路避開佢。")
		if J.num(G.alertLv) == 2: var m = mkHuman("mirror", "f%d_l" % int(fr)); m["dir"] = -1.0; G.guards.append(m); toast("全樓警覺 6：「鏡子道士」到——唔好正面對住佢面鏡，要兜去佢背後先嚇得到。")
		if J.num(G.alertLv) == 3:
			G["taoWant"] = true; var real = floor(rnd() * 3)
			for k in 3:
				# 原碼：'f'+fr+'_d'+k in G.nodes ? … ——運算次序係 ('f'+fr+'_d'+k) in G.nodes
				var nid = "f%d_d%d" % [int(fr), k]
				var d = mkHuman("decoy", nid if G.nodes.has(nid) else "f%d_s" % int(fr), {"real": k == real}); G.guards.append(d)
			toast("全樓警覺 10：天師同「紙人替身陣」上樓——三個道士得一個係真身，試下嚇邊個。")
		G["shake"] = 0.4

# ---------------- 安全區／人物共用 ----------------
func initSafe() -> void:
	var n = G.nodes.get("f0_e"); SAFE = null
	if not T(n): return
	SAFE = {"node": "f0_e", "x": n.x, "y": n.y, "f": n.f, "r": SAFE_R, "nodes": {}, "a": 1.0, "was": true}
	for k in G.nodes:
		var m = G.nodes[k]
		if J.num(m.f) == J.num(n.f) and absf(J.num(m.x) - J.num(n.x)) <= SAFE_R: SAFE.nodes[k] = 1
func safeOn() -> bool: return T(G) and SAFE != null and not (T(G.get("gate")) and J.str(G.gate.node) == J.str(SAFE.node))
func inSafeXY(x: float, y: float) -> bool: return safeOn() and absf(y - J.num(SAFE.y)) < 30 and absf(x - J.num(SAFE.x)) <= J.num(SAFE.r)
func inSafe(g) -> bool:
	if not T(g) or T(g.get("home")) or T(g.get("out")): return false
	if inSafeXY(J.num(g.x), J.num(g.y)): g["_sgT"] = G.t; return true
	return safeOn() and g.get("_sgT") != null and (J.num(G.t) - J.num(g._sgT)) < 2 and absf(J.num(g.y) - J.num(SAFE.y)) < 30 and absf(J.num(g.x) - J.num(SAFE.x)) <= J.num(SAFE.r) + 110
func safeNode(id) -> bool: return safeOn() and SAFE.nodes.has(J.str(id))
func nearSafe(h) -> bool: return SAFE != null and absf(J.num(h.y) - J.num(SAFE.y)) < 200 and absf(J.num(h.x) - J.num(SAFE.x)) < J.num(SAFE.r) + 340
func nearestAny(h):
	var best = null; var bd = 1e9
	for g in G.gh.duplicate():
		if T(g.home) or T(g.out) or J.num(g.inv) > 0: continue
		var d = absf(J.num(g.x) - J.num(h.x)) + absf(J.num(g.y) - J.num(h.y)) * 1.5
		if d < bd: bd = d; best = g
	return best
func nearNodeH(h):
	var best = null; var bd = 1e9
	for k in G.nodes:
		var n = G.nodes[k]
		if J.str(n.kind) == "in" or safeNode(k): continue
		var d = absf(J.num(n.x) - J.num(h.x)) + absf(J.num(n.y) - J.num(h.y)) * 3
		if d < bd: bd = d; best = k
	return best
func uniq(pool: Array):
	if not T(G.get("_uq")): G["_uq"] = {}
	var U = G._uq; var free = []
	for t in pool: if T(t) and not U.has(J.str(t)): free.append(t)
	if free.is_empty(): return null
	var t2 = free[int(floor(randf() * free.size()))]; U[J.str(t2)] = 1; return t2
func pplScream(o) -> void:
	var t = uniq(SCREAM); o["scream"] = {"t": t, "T": 1.9} if t != null else null
	if t != null: o["say"] = null; o["sayT"] = 0.0
func balk(h, talk) -> void:
	h["state"] = "balk"; h["balkT"] = 2.6; h["balkTurn"] = 0.0; h["path"] = null; h["lostT"] = 0.0; h["alertT"] = 0.0; h["dir"] = 1.0 if SAFE != null and J.num(SAFE.x) > J.num(h.x) else -1.0
	if T(talk):
		var t = uniq(BALKL)
		if t != null: h["say"] = t; h["sayT"] = 2.6
func startShock(r, amp: float) -> void:
	r["shockT"] = 0.9; r["shockA"] = amp; r["shockN"] = n0(r.get("shockN")) + 1; var Hh = (J.num(r.h) if T(r.get("h")) else 66.0) * 1.12
	for k in (5 if amp >= 1 else 3): part(J.num(r.x) + (randf() - 0.5) * 24, J.num(r.y) - Hh * 0.82, (randf() - 0.5) * 150, -90 - randf() * 70, 0.75, "tear" if k % 2 else "sweat")
	if amp >= 1 and not T(r.get("dropped")) and J.str(r.state) == "home" and not pplfx_hasScared(r.sprite) and DROPK.has(J.str(r.get("hh"))):
		r["dropped"] = 1.0
		if not T(G.get("pdrops")): G["pdrops"] = []
		G.pdrops.append({"k": DROPK[J.str(r.hh)], "x": J.num(r.x) + (-10.0 if n0(r.get("vx")) < 0 else 10.0), "y": J.num(r.y) - Hh * 0.5, "fy": r.y, "vx": (-1.0 if randf() < 0.5 else 1.0) * (40 + randf() * 50), "vy": -140.0, "rot": 0.0, "vr": (randf() - 0.5) * 14, "life": 3.2})
func pplResTick(r, dt: float) -> void:
	if n0(r.get("jumpT")) > n0(r.get("_pj")) + 0.001: startShock(r, 1.0 if J.num(r.jumpT) >= 0.5 else 0.65)
	r["shockT"] = maxf(0.0, n0(r.get("shockT")) - dt)
	if T(r.get("scream")):
		r.scream["T"] = J.num(r.scream.T) - dt
		if J.num(r.scream.T) <= 0: r["scream"] = null
	if J.str(r.state) == "home" and T(r.get("awake")) and n0(r.get("fear")) >= 55 and randf() < dt * 1.1: part(J.num(r.x) + (-12.0 if randf() < 0.5 else 12.0), J.num(r.y) - (J.num(r.h) if T(r.get("h")) else 66.0) * 0.95, (randf() - 0.5) * 30, -20, 0.6, "sweat")
func pplTick(dt: float) -> void:
	for d in (G.pdrops if T(G.get("pdrops")) else []).duplicate():
		d["life"] = J.num(d.life) - dt; d["vy"] = J.num(d.vy) + 520 * dt; d["x"] = J.num(d.x) + J.num(d.vx) * dt; d["y"] = J.num(d.y) + J.num(d.vy) * dt; d["rot"] = J.num(d.rot) + J.num(d.vr) * dt
		if J.num(d.y) >= J.num(d.fy) - 3:
			d["y"] = J.num(d.fy) - 3; d["vy"] = -absf(J.num(d.vy)) * 0.28; d["vx"] = J.num(d.vx) * 0.55; d["vr"] = J.num(d.vr) * 0.4
			if absf(J.num(d.vy)) < 20: d["vy"] = 0.0
	if T(G.get("pdrops")):
		var nd = []
		for d in G.pdrops: if J.num(d.life) > 0: nd.append(d)
		G["pdrops"] = nd
	if SAFE != null:
		var on = safeOn()
		if T(SAFE.was) and not on: float_(J.num(SAFE.x), J.num(SAFE.y) - 110, "陰門一開，陰氣散晒——保安殺到！", "#d8b8ff")
		SAFE["was"] = on

# ---- PPLFX（window.PPLFX：大樓、入屋、電梯共用人物畫法） ----
const CHIBI_K := 1.12
var TC := {}
func pplfx_im(k):
	if not T(k): return null
	var i = IMG.get(J.str(k))
	return i if i != null and T(J.gp(i, "width")) else null
func pplfx_hasScared(k) -> bool: return T(k) and J.str(k).begins_with("res_") and pplfx_im(J.str(k) + "_scared") != null
func pplfx_key(k, scared): return J.str(k) + "_scared" if T(scared) and pplfx_hasScared(k) else k
func pplfx_chibi(k) -> bool:
	var i = pplfx_im(k)
	return i != null and J.num(J.gp(i, "width")) / J.num(J.gp(i, "height")) >= 0.42
func pplfx_hgt(base, k2, h) -> float:
	var m = PPL_META.get(J.str(base))
	return J.num(h) * (CHIBI_K if pplfx_chibi(base) else 1.0) * (J.num(m.s.k) if J.str(k2) != J.str(base) and m != null and T(m.get("s")) else 1.0)
func pplfx_foot(base, k2) -> float:
	var m = PPL_META.get(J.str(base))
	if m == null: return 0.0
	if J.str(k2) != J.str(base): return n0(m.s.get("foot")) if T(m.get("s")) else 0.0
	return n0(m.n.get("foot")) if T(m.get("n")) else 0.0
func pplfx_tint(k):
	var i = pplfx_im(k)
	if i == null: return null
	var c = TC.get(J.str(k))
	if c != null and is_same(J.gp(c, "_src"), i): return c
	c = J.S_document_("createElement", ["canvas"]); var s = minf(1.0, 220 / J.num(J.gp(i, "height")))
	J.sp(c, "width", maxf(1.0, J.round(J.num(J.gp(i, "width")) * s))); J.sp(c, "height", maxf(1.0, J.round(J.num(J.gp(i, "height")) * s)))
	var x = J.mc(c, "getContext", ["2d"]); J.mc(x, "drawImage", [i, 0.0, 0.0, J.gp(c, "width"), J.gp(c, "height")]); J.sp(x, "globalCompositeOperation", "source-atop"); J.sp(x, "fillStyle", "rgb(178,222,236)"); J.mc(x, "fillRect", [0.0, 0.0, J.gp(c, "width"), J.gp(c, "height")])
	J.sp(c, "_src", i); TC[J.str(k)] = c; return c
func pplfx_blit(c2, i, x: float, y: float, h: float, o: Dictionary) -> void:
	var w = h * J.num(J.gp(i, "width")) / J.num(J.gp(i, "height"))
	J.mc(c2, "save", []); J.sp(c2, "globalAlpha", 1.0 if o.get("alpha") == null else J.num(o.alpha)); J.mc(c2, "translate", [x, y])
	if T(o.get("rot")): J.mc(c2, "rotate", [J.num(o.rot)])
	J.mc(c2, "scale", [(-1.0 if T(o.get("flip")) else 1.0) * (J.num(o.sx) if T(o.get("sx")) else 1.0), J.num(o.sy) if T(o.get("sy")) else 1.0]); J.mc(c2, "drawImage", [i, -w / 2, -h, w, h]); J.mc(c2, "restore", [])
func pplfx_draw(c2, base, k2, x: float, y: float, h: float, o) -> void:
	if not (o is Dictionary): o = {}
	var i = pplfx_im(k2)
	if i == null: return
	var fy0 = y + pplfx_foot(base, k2) * h; pplfx_blit(c2, i, x, fy0, h, o)
	if n0(o.get("tint")) > 0.02:
		var t = pplfx_tint(k2)
		if t != null:
			var sb = J.gp(c2, "shadowBlur"); J.sp(c2, "shadowBlur", 0.0)
			pplfx_blit(c2, t, x, fy0, h, {"flip": o.get("flip"), "rot": o.get("rot"), "sx": o.get("sx"), "sy": o.get("sy"), "alpha": (1.0 if o.get("alpha") == null else J.num(o.alpha)) * minf(0.4, J.num(o.tint) * 0.45)}); J.sp(c2, "shadowBlur", sb)
func pplfx_shock(t: float, amp) -> Dictionary:
	var q = 1 - t / 0.9; var a = J.num(amp) if T(amp) else 1.0; var o = {"sx": 1.0, "sy": 1.0, "jy": 0.0, "sh": 0.0, "tint": 0.95 * (1 - q * 0.55)}
	if q < 0.12: var c = q / 0.12; o["sy"] = 1 - 0.22 * c * a; o["sx"] = 1 + 0.16 * c * a
	elif q < 0.5: var c2 = (q - 0.12) / 0.38; o["jy"] = -sin(c2 * PI) * 0.3 * a; o["sy"] = 1 + (0.17 * (1 - c2)) * a; o["sx"] = 1 - (0.11 * (1 - c2)) * a
	else:
		var c3 = (q - 0.5) / 0.5; o["sy"] = 1 - 0.07 * sin(c3 * PI) * (1 - c3) * a; o["sx"] = 1 + 0.05 * sin(c3 * PI) * (1 - c3) * a
		o["sh"] = sin(J.S_performance_("now", []) / 1000 * 62) * 0.032 * (1 - c3)
	return o
func pplfx_tremble(r, t: float) -> Dictionary:
	var rx = n0(r.get("x")); var ph = int(floor((t + fmod(rx, 5)) * 1.15))
	return {"sh": sin(t * 47 + rx) * 0.018, "sy": 0.93, "flip": null if ph % 3 == 2 else ph % 3 == 1, "tint": 0.16}
func pplfx_bang(c2, x: float, y: float, q: float, s = null) -> void:
	var sc = J.num(s) if T(s) else 1.0; var pop = 1 + 0.7 * maxf(0.0, 1 - q / 0.16); var al = maxf(0.0, (1 - q) / 0.2) if q > 0.8 else 1.0
	J.mc(c2, "save", []); J.sp(c2, "globalAlpha", al); J.mc(c2, "translate", [x, y]); J.mc(c2, "rotate", [-0.12]); J.mc(c2, "scale", [pop * sc, pop * sc]); J.sp(c2, "font", "900 22px " + FONT); J.sp(c2, "textAlign", "center"); J.sp(c2, "lineJoin", "round"); J.sp(c2, "lineWidth", 5.0); J.sp(c2, "strokeStyle", "#160c10"); J.mc(c2, "strokeText", ["!!", 0.0, 0.0]); J.sp(c2, "fillStyle", "#ffe25a"); J.mc(c2, "fillText", ["!!", 0.0, 0.0])
	J.sp(c2, "strokeStyle", "#ffe25a"); J.sp(c2, "lineWidth", 2.0)
	for i in 3:
		var an = -2.5 + i * 0.5; J.mc(c2, "beginPath", []); J.mc(c2, "moveTo", [cos(an) * 15 - 2, sin(an) * 15 - 8]); J.mc(c2, "lineTo", [cos(an) * 22 - 2, sin(an) * 22 - 8]); J.mc(c2, "stroke", [])
		var an2 = -0.65 - i * 0.5; J.mc(c2, "beginPath", []); J.mc(c2, "moveTo", [cos(an2) * 15 + 2, sin(an2) * 15 - 8]); J.mc(c2, "lineTo", [cos(an2) * 22 + 2, sin(an2) * 22 - 8]); J.mc(c2, "stroke", [])
	J.mc(c2, "restore", [])
func pplfx_arms(c2, x: float, y: float, h: float, dir: float, t: float) -> void:
	var sh = y - h * 0.5; J.mc(c2, "save", []); J.sp(c2, "lineCap", "round")
	for s in [-1.0, 1.0]:
		var w = sin(t * 19 + s) * h * 0.035; var hx = x + s * h * 0.3 + w; var hy = y - h * 0.97 + cos(t * 19 + s) * h * 0.02; var sx0 = x + s * h * 0.12
		J.sp(c2, "strokeStyle", "#1a1214"); J.sp(c2, "lineWidth", maxf(3.0, h * 0.075)); J.mc(c2, "beginPath", []); J.mc(c2, "moveTo", [sx0, sh]); J.mc(c2, "lineTo", [hx, hy]); J.mc(c2, "stroke", [])
		J.sp(c2, "strokeStyle", "#f0c8a4"); J.sp(c2, "lineWidth", maxf(1.6, h * 0.045)); J.mc(c2, "beginPath", []); J.mc(c2, "moveTo", [sx0, sh]); J.mc(c2, "lineTo", [hx, hy]); J.mc(c2, "stroke", [])
		J.sp(c2, "fillStyle", "#f0c8a4"); J.sp(c2, "strokeStyle", "#1a1214"); J.sp(c2, "lineWidth", 1.5); J.mc(c2, "beginPath", []); J.mc(c2, "arc", [hx, hy, maxf(2.5, h * 0.05), 0.0, 7.0]); J.mc(c2, "fill", []); J.mc(c2, "stroke", [])
	J.mc(c2, "restore", [])
func pplfx_scream(c2, x: float, y: float, sc, s = null) -> void:
	if not T(sc): return
	var k = J.num(s) if T(s) else 1.0; var u = 1 - J.num(sc.T) / 1.9
	J.mc(c2, "save", []); J.sp(c2, "globalAlpha", minf(1.0, J.num(sc.T) / 0.45)); J.sp(c2, "font", "900 " + J.str(J.round(14 * k)) + "px " + FONT); J.sp(c2, "textAlign", "center"); J.sp(c2, "lineJoin", "round"); J.sp(c2, "lineWidth", 4.0); J.sp(c2, "strokeStyle", "#14080a")
	var yy = y - u * 22 * k; J.mc(c2, "strokeText", [J.str(sc.t), x, yy]); J.sp(c2, "fillStyle", "#ff9a86"); J.mc(c2, "fillText", [J.str(sc.t), x, yy]); J.mc(c2, "restore", [])
func _mk_pplfx() -> Dictionary:
	return {
		"key": func(_t, a): return pplfx_key(J.arg(a, 0), J.arg(a, 1)),
		"hasScared": func(_t, a): return pplfx_hasScared(J.arg(a, 0)),
		"chibi": func(_t, a): return pplfx_chibi(J.arg(a, 0)),
		"hgt": func(_t, a): return pplfx_hgt(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"foot": func(_t, a): return pplfx_foot(J.arg(a, 0), J.arg(a, 1)),
		"draw": func(_t, a): pplfx_draw(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.arg(a, 6)); return null,
		"shock": func(_t, a): return pplfx_shock(J.num(J.arg(a, 0)), J.arg(a, 1)),
		"tremble": func(_t, a): return pplfx_tremble(J.arg(a, 0), J.num(J.arg(a, 1))),
		"bang": func(_t, a): pplfx_bang(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4)); return null,
		"arms": func(_t, a): pplfx_arms(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5))); return null,
		"scream": func(_t, a): pplfx_scream(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.arg(a, 3), J.arg(a, 4)); return null,
		"screamOn": func(_t, a): pplScream(J.arg(a, 0)); return null,
		"tint": func(_t, a): return pplfx_tint(J.arg(a, 0)),
		"CHIBI_K": CHIBI_K,
		"uniqScream": func(_t, _a): return uniq(SCREAM),
	}

# ---------------- 人類 ----------------
func pplStep(s) -> float:
	var d = 0.0 if s.get("_lx") == null else hyp(J.num(s.x) - J.num(s._lx), J.num(s.y) - J.num(s._ly))
	s["_lx"] = s.x; s["_ly"] = s.y
	if d > 40: d = 0.0
	var run = J.str(s.state) == "flee" or (J.str(s.state) == "scared" and n0(s.get("scT")) < 1.7)
	s["stepPh"] = n0(s.get("stepPh")) + d * PI / (26.0 if run else 17.0)
	if d > 0.05: s["mvT"] = 0.15
	else: s["mvT"] = maxf(0.0, n0(s.get("mvT")) - 1.0 / 60)
	if J.num(s.mvT) > 0: s["_sway"] = sin(J.num(s.stepPh)) * 0.035; return -absf(sin(J.num(s.stepPh))) * (4.0 if run else 2.4)
	s["_sway"] = 0.0; return sin(J.num(G.t) * 1.8 + J.num(s.x)) * 0.6 - 0.6
func nearestGhost(h):
	var best = null; var bd = 1e9
	for g in G.gh.duplicate():
		if T(g.home) or T(g.out) or J.num(g.inv) > 0 or inSafe(g): continue
		var d = absf(J.num(g.x) - J.num(h.x)) + absf(J.num(g.y) - J.num(h.y)) * 1.5
		if d < bd: bd = d; best = g
	return best
func _sees(h, tg, rng: float) -> bool: return tg != null and absf(J.num(tg.y) - J.num(h.y)) < 40 and (J.num(tg.x) - J.num(h.x)) * J.num(h.dir) > 0 and absf(J.num(tg.x) - J.num(h.x)) < rng
func humanUpdate(h, dt: float) -> void:
	var H = HUM[J.str(h.kind)]; h["alertT"] = maxf(0.0, J.num(h.alertT) - dt); h["shockT"] = maxf(0.0, n0(h.get("shockT")) - dt)
	if T(h.get("scream")):
		h.scream["T"] = J.num(h.scream.T) - dt
		if J.num(h.scream.T) <= 0: h["scream"] = null
	h["talkT"] = J.num(h.talkT) - dt
	if n0(h.get("sayT")) > 0: h["sayT"] = J.num(h.sayT) - dt
	else: h["say"] = null
	var st = J.str(h.state)
	if st == "flee":
		if inSafeXY(J.num(h.x) + J.num(h.vx) * dt, J.num(h.y)): h["vx"] = -J.num(h.vx)
		if randf() < dt * 8: part(J.num(h.x) - signf(J.num(h.vx)) * 10, J.num(h.y) - 4, -J.num(h.vx) * 0.1, -10, 0.5, "dust")
		h["x"] = J.num(h.x) + J.num(h.vx) * dt
		if J.num(h.x) < SX - 20 or J.num(h.x) > LX + 20: h["state"] = "gone"
		return
	if st == "scared":
		h["scT"] = J.num(h.scT) - dt; var bk = J.num(h.scT) > 1.7
		if T(h.get("scAway")): h["vx"] = J.num(h.scAway) * (55.0 if bk else 95.0); h["dir"] = -J.num(h.scAway) if bk else J.num(h.scAway)
		var nx = J.num(h.x) + J.num(h.vx) * dt
		if nx < SX or nx > LX or inSafeXY(nx, J.num(h.y)):
			h["vx"] = -J.num(h.vx)
			if T(h.get("scAway")): h["scAway"] = -J.num(h.scAway)
		else: h["x"] = nx
		if J.num(h.scT) <= 0:
			h["state"] = "patrol"; var nn = nearNodeH(h); h["node"] = nn; h["to"] = null; h["p"] = 0.0; var q0 = G.nodes[nn]; h["x"] = q0.x; h["y"] = q0.y
		return
	if st == "shift" or st == "inv":
		if not T(h.to):
			if not T(h.get("path")) or (h.path as Array).is_empty():
				if st == "shift": h["state"] = "gone"; return
				h["state"] = "puzzle"; h["puzzleT"] = 3.5; h["say"] = pick(["咩都冇喎……", "係咪我聽錯？", "奇怪……啱啱明明有聲"]); h["sayT"] = 2.4; return
			h["to"] = h.path.pop_front(); h["p"] = 0.0
		var a0 = G.nodes[h.node]; var b0 = G.nodes[h.to]
		if not humanPassTo(h, a0, b0):
			h["to"] = null; h["path"] = dijkstra(h, J.str(h.node), "f1_s" if st == "shift" else J.str(h.invNode))
			if h.path == null: h["state"] = "patrol"
			return
		var D0 = maxf(1.0, hyp(J.num(b0.x) - J.num(a0.x), J.num(b0.y) - J.num(a0.y))); h["p"] = J.num(h.p) + J.num(H.sp) * 0.7 * dt / D0
		if J.num(b0.x) != J.num(a0.x): h["dir"] = 1.0 if J.num(b0.x) > J.num(a0.x) else -1.0
		if J.num(h.p) >= 1: h["node"] = h.to; h["to"] = null; h["p"] = 0.0
		var p0 = posOfD(h); h["x"] = p0[0]; h["y"] = p0[1]
		if J.str(h.state) == "inv":
			var tg0 = nearestGhost(h)
			if _sees(h, tg0, 150): h["state"] = "chase"; h["alertT"] = 1.2; h["say"] = line("guardHit"); h["sayT"] = 2.0
		return
	if st == "balk":
		h["balkT"] = J.num(h.balkT) - dt
		if J.num(h.balkT) < 1.3 and not T(h.get("balkTurn")): h["balkTurn"] = 1.0; h["dir"] = -J.num(h.dir)
		if J.num(h.balkT) <= 0: h["state"] = "patrol"; h["wait"] = 0.2; h["repath"] = 0.0; h["path"] = null; h["balkCd"] = 6.0
		return
	if st == "puzzle":
		h["puzzleT"] = J.num(h.puzzleT) - dt; h["dir"] = 1.0 if int(floor(J.num(h.puzzleT) * 1.2)) % 2 else -1.0
		var tg1 = nearestGhost(h)
		if _sees(h, tg1, 130): h["state"] = "chase"; h["alertT"] = 1.2; h["say"] = line("guardHit"); h["sayT"] = 2.0
		elif J.num(h.puzzleT) <= 0: h["state"] = "patrol"; h["wait"] = 0.5
		return
	if J.str(h.kind) == "collector": return
	var tgS = nearestAny(h); h["balkCd"] = maxf(0.0, n0(h.get("balkCd")) - dt)
	var kind = J.str(h.kind)
	if tgS != null and inSafe(tgS) and not (n0(h.get("balkCd")) > 0) and nearSafe(h) and (J.str(h.state) == "chase" or (kind != "guard" and kind != "collector" and not (kind == "decoy" and not T(h.get("real"))))): balk(h, kind != "dog"); return
	if J.str(h.state) == "chase" and tgS != null and inSafe(tgS): balk(h, false); return
	if J.str(h.state) == "chase":
		var tg2 = nearestGhost(h)
		var far = tg2 == null or absf(J.num(G.nodes[tg2.node].f) - J.num(G.nodes[h.node].f)) >= 2 or absf(J.num(tg2.x) - J.num(h.x)) > 460
		if tg2 != null and not inZone(h, J.num(G.nodes[tg2.node].f), 1): h["lostT"] = n0(h.get("lostT")) + dt * 3
		h["lostT"] = n0(h.get("lostT")) + dt if far else 0.0
		if J.num(h.lostT) > 8: h["state"] = "patrol"; h["lostT"] = 0.0; h["path"] = null; h["say"] = pick(["走甩咗……", "跑得咁快？算數", "嗰樣嘢去咗邊？"]); h["sayT"] = 2.2
	if J.num(h.talkT) <= 0 and kind != "dog":
		h["say"] = line("guard") if kind == "guard" else (pick(["羅盤指住呢邊……", "針震緊，有嘢喺附近"]) if kind == "compass" else pick(["照妖鏡在此，莫要亂來", "鏡光到處，邪靈退後"])); h["sayT"] = 2.4; h["talkT"] = 8 + rnd() * 8
	var tg = nearestGhost(h); var chaser = kind != "guard" or J.str(h.state) == "chase"
	if kind == "guard" and _sees(h, tg, 150) and J.str(h.state) != "chase": h["state"] = "chase"; h["alertT"] = 1.2; h["say"] = line("guardHit"); h["sayT"] = 2.0
	if kind == "decoy" and not T(h.get("real")): chaser = false
	if not T(h.to):
		h["wait"] = J.num(h.wait) - dt
		if J.num(h.wait) > 0: return
		h["repath"] = J.num(h.repath) - dt
		if chaser and tg != null:
			var tn = (J.str(tg.node) if absf(J.num(G.nodes[tg.node].x) - J.num(tg.x)) < absf(J.num(G.nodes[tg.to].x) - J.num(tg.x)) else J.str(tg.to)) if T(tg.to) else J.str(tg.node)
			if safeNode(tn): balk(h, kind != "dog" and nearSafe(h) and not (n0(h.get("balkCd")) > 0)); return
			if J.num(h.repath) <= 0 or not T(h.get("path")): h["path"] = dijkstra(h, J.str(h.node), tn); h["repath"] = 0.5
			if T(h.get("path")) and (h.path as Array).size(): h["to"] = h.path.pop_front(); h["p"] = 0.0
		if not T(h.to):
			var n = G.nodes[h.node]; var zm = (J.num(h.zone[0]) + J.num(h.zone[1])) / 2 if T(h.get("zone")) else 0.0; var opts = []
			for l in n.links:
				var m = G.nodes[l.to]
				if J.str(m.kind) != "in" and J.str(m.kind) != "portal" and not safeNode(l.to) and humanPass(h, l.e) and (inZone(h, J.num(m.f)) or (not inZone(h, J.num(n.f)) and absf(J.num(m.f) - zm) < absf(J.num(n.f) - zm))): opts.append(l)
			if opts.size(): h["to"] = pick(opts).to; h["p"] = 0.0
	var a = G.nodes[h.node]; var b = G.nodes.get(J.str(h.to)) if T(h.to) else null
	if b == null: h["to"] = null; return
	var D = maxf(1.0, hyp(J.num(b.x) - J.num(a.x), J.num(b.y) - J.num(a.y)))
	var gate = G.get("gate")
	var sp = J.num(H.sp) * (J.num(h.boost) if T(h.get("boost")) else 1.0) * ((1.4 if J.num(gate.t) > 20 else 1.2) if T(gate) else 1.0) * (1 + 0.08 * J.num(G.phase))
	if tg != null and chaser:
		sp *= 1.05 * pow(1.15, absf(J.num(G.nodes[tg.node].f) - J.num(a.f))); sp = minf(sp, J.num(tg.d.sp) * J.num(G.mods.spd) * 0.85)
	else: sp *= 0.45
	h["walkSp"] = sp
	h["p"] = J.num(h.p) + sp * dt / D
	if J.num(b.x) != J.num(a.x): h["dir"] = 1.0 if J.num(b.x) > J.num(a.x) else -1.0
	if J.num(h.p) >= 1: h["node"] = h.to; h["to"] = null; h["p"] = 0.0; h["wait"] = 0.0 if chaser else 0.3 + rnd() * 0.8
	var p = posOfD(h); h["x"] = p[0]; h["y"] = p[1]
	for g in G.gh.duplicate():
		if T(g.home) or T(g.out) or J.num(g.inv) > 0 or J.num(g.stun) > 0 or n0(h.get("catchCd")) > 0 or inSafe(g): continue
		if absf(J.num(g.y) - J.num(h.y)) > 30 or absf(J.num(g.x) - J.num(h.x)) > 18: continue
		if kind == "dog": g["stun"] = 1.0; G["alert"] = J.num(G.alert) + 1; checkAlert(); float_(J.num(g.x), J.num(g.y) - 80, "狗吠到成棟樓醒晒！", "#ffb0b0"); h["catchCd"] = 2.0; continue
		if kind == "decoy" and not T(h.get("real")): continue
		if kind == "guard" and J.str(h.state) != "chase": continue
		catchGhost(g, h); h["catchCd"] = 2.2
	h["catchCd"] = maxf(0.0, n0(h.get("catchCd")) - dt)
func catchGhost(g, h) -> void:
	if inSafe(g): return
	var near = 0
	for o in G.guards:
		if J.str(o.state) != "flee" and J.str(o.kind) != "dog" and not (J.str(o.kind) == "decoy" and not T(o.get("real"))) and absf(J.num(o.y) - J.num(g.y)) < 30 and absf(J.num(o.x) - J.num(g.x)) < 90: near += 1
	g["caught"] = J.num(g.caught) + (3.0 if near >= 2 else 1.0)
	if near >= 2: float_(J.num(g.x), J.num(g.y) - 110, "被圍！", "#ff5a4a")
	g["hitT"] = 0.8; g["hitDir"] = h.dir; g["stun"] = 1.5; g["to"] = null; g["auto"] = null; h["alertT"] = 1.3; h["say"] = line("guardHit"); h["sayT"] = 2.0; G["shake"] = 0.35
	for k in 10: part(J.num(g.x), J.num(g.y) - J.num(g.d.h) * 0.5, (rnd() - 0.5) * 50 + J.num(h.dir) * 40, -30 - rnd() * 40, 0.9, "smoke")
	if J.num(g.caught) >= 3:
		g["out"] = true; var lost = 0; var nb = []
		for b in G.bag:
			if J.num(b.o) == J.num(g.i): lost += 1
			else: nb.append(b)
		G["bag"] = nb; g["loot"] = 0.0; float_(J.num(g.x), J.num(g.y) - 100, J.str(g.d.name) + "被收服！", "#ff7a5a")
		var any = false
		for o in G.gh: if not T(o.out): any = true; break
		toast(J.str(g.d.name) + "畀人收服咗，佢身上 " + str(lost) + " 件收穫冇埋。" + ("快啲切去其他鬼！" if any else ""))
		if J.num(G.active) == J.num(g.i):
			for o in G.gh: if not T(o.out) and not T(o.home): G["active"] = o.i; break
	else:
		loseLoot(g, 0.34); float_(J.num(g.x), J.num(g.y) - 80, "被捉住！（" + J.str(g.caught) + "/3）", "#ffb0b0")
		for l in G.nodes[g.node].links:
			var m = G.nodes[l.to]
			if J.str(m.kind) != "in" and (J.num(m.x) - J.num(h.x)) * J.num(h.dir) > 0: g["node"] = m.id; break
func loseLoot(g, frac: float) -> void:
	var mine = []
	for b in G.bag: if J.num(b.o) == J.num(g.i): mine.append(b)
	var l = int(ceil(mine.size() * frac * (0.5 if J.num(G.mods.arm) < 1 else 1.0)))
	for k in l:
		var i = idx_of(G.bag, mine[k] if k < mine.size() else null)
		if i < 0: i = G.bag.size() - 1
		if G.bag.size(): G.bag.remove_at(i)
	g["loot"] = maxf(0.0, J.num(g.loot) - l)
	if l > 0: float_(J.num(g.x), J.num(g.y) - 95, "跌咗收穫 -" + str(l), "#ff9a9a")

# ---------------- 天師／陰門／結束 ----------------
const TAOL := ["鈴……鈴……各位街坊安心瞓", "天師巡樓，邪氣退散", "聽住鈴聲，唔好亂走", "鈴聲到處，夜路平安"]
func spawnTao(f: float, x: float) -> void:
	G["tao"] = {"x": x, "f": f, "dir": 1.0 if x < WW / 2 else -1.0, "ringT": 2.2, "life": 26.0, "waves": [], "say": pick(TAOL), "sayT": 2.6}; float_(x, fy(f) - 90, "天師嚟咗！", "#ffd54a")
func taoUpdate(dt: float) -> void:
	if T(G.get("taoWant")) and not T(G.get("tao")) and not T(G.gate):
		G["taoCd"] = (2.0 if G.get("taoCd") == null else J.num(G.taoCd)) - dt
		if J.num(G.taoCd) <= 0: var f = 1 + floor(rnd() * (FL - 1)); spawnTao(f, SX if rnd() < 0.5 else LX)
	var Tt = G.get("tao")
	if not T(Tt): return
	Tt["life"] = J.num(Tt.life) - dt; Tt["x"] = J.num(Tt.x) + J.num(Tt.dir) * 36 * dt
	if J.num(Tt.x) > LX - 10 or J.num(Tt.x) < SX + 10: Tt["dir"] = -J.num(Tt.dir)
	Tt["sayT"] = J.num(Tt.sayT) - dt; Tt["ringT"] = J.num(Tt.ringT) - dt
	if J.num(Tt.ringT) <= 0:
		Tt["ringT"] = 4.0; Tt.waves.append({"r": 10.0, "t": 1.0}); Tt["say"] = pick(TAOL); Tt["sayT"] = 2.4
		for g in G.gh.duplicate():
			if T(g.home) or T(g.out) or T(g.get("inUnit")) or inSafe(g): continue
			if J.num(G.nodes[g.node].f) != J.num(Tt.f): continue
			if absf(J.num(g.x) - J.num(Tt.x)) > 140: continue
			g["sealT"] = 3.0; g["hitT"] = 0.8; g["hitDir"] = 1.0 if J.num(g.x) > J.num(Tt.x) else -1.0; g["to"] = null; g["auto"] = null; g["taskP"] = 0.0
			var n = G.nodes[g.node]; var away = null
			for l in n.links:
				var m = G.nodes[l.to]
				if J.str(m.kind) != "in" and (J.num(m.x) - J.num(Tt.x)) * (J.num(g.x) - J.num(Tt.x)) >= 0 and absf(J.num(m.x) - J.num(Tt.x)) > absf(J.num(n.x) - J.num(Tt.x)): away = m; break
			if J.str(n.kind) == "in": g["node"] = J.str(n.id).replace("_i", "_d")
			elif away != null: g["node"] = away.id
			float_(J.num(g.x), J.num(g.y) - 90, "鈴聲逼退，暫時嚇唔到人", "#ffe9a0")
			for k in 8: part(J.num(g.x), J.num(g.y) - 30, (rnd() - 0.5) * 60, -30 - rnd() * 40, 0.9, "smoke")
	for w in Tt.waves.duplicate(): w["t"] = J.num(w.t) - dt; w["r"] = J.num(w.r) + 180 * dt
	var nw = []
	for w in Tt.waves: if J.num(w.t) > 0: nw.append(w)
	Tt["waves"] = nw
	if J.num(Tt.life) <= 0: G["tao"] = null; G["taoCd"] = 16 + rnd() * 10
func gatePress() -> void:
	var g = G.gh[int(J.num(G.active))]; var n = G.nodes[g.node]
	if T(G.gate) or T(g.to) or J.str(n.kind) != "portal": return
	standStill(g); calm(g); G["gateCharge"] = 0.001; G["gateG"] = g.i
func gateUpdate(dt: float) -> void:
	if J.num(G.gateCharge) > 0 and not T(G.gate):
		var g = G.gh[int(J.num(G.gateG))]
		if T(g.to) or J.num(g.still) < 0.1 or J.str(G.nodes[g.node].kind) != "portal": G["gateCharge"] = 0.0; float_(J.num(g.x), J.num(g.y) - 80, "郁咗，陰門開唔到", "#ffb0b0")
		else:
			G["gateCharge"] = J.num(G.gateCharge) + dt
			if J.num(G.gateCharge) >= 1:
				G["gateCharge"] = 0.0; G["gate"] = {"t": 0.0, "f": G.nodes[g.node].f, "node": g.node, "sp": 1.2, "fin": false}; G["tao"] = null
				toast("陰門開咗！企穩 30 秒——樓梯封住，追兵會越嚟越快，最後 8 秒天師會喺你兩邊出現。"); G["shake"] = 0.5
	var Gt = G.get("gate")
	if not T(Gt): return
	Gt["t"] = J.num(Gt.t) + dt; Gt["sp"] = J.num(Gt.sp) - dt
	if J.num(Gt.sp) <= 0:
		Gt["sp"] = 2.6 if J.num(Gt.t) < 20 else 1.4; var side = rnd() < 0.5
		G.guards.append(mkHuman("guard", "f%d_%s" % [int(J.num(Gt.f)), "s" if side else "l"], {"state": "chase"}))
	if J.num(Gt.t) >= 22 and not T(Gt.fin):
		Gt["fin"] = true; var g2 = G.gh[int(J.num(G.active))]; spawnTao(J.num(Gt.f), maxf(SX + 10, J.num(g2.x) - 120)); G.tao["ringT"] = 1.5
		var d = mkHuman("mirror", "f%d_l" % int(J.num(Gt.f))); d["dir"] = -1.0; G.guards.append(d); toast("最後 8 秒！天師同道士喺兩邊殺到，頂住！")
	if J.num(Gt.t) >= 30:
		for g3 in G.gh: if not T(g3.out): g3["home"] = true
		endNight("gate")
func dollEscape() -> void:
	if J.num(G.dolls) < 6 or T(G.gate): return
	for g in G.gh: if not T(g.out): g["home"] = true
	endNight("doll")
func endNight(why: String) -> void:
	if T(G.over): return
	var bl = G.bag.size(); var kept = float(bl) if why == "gate" else (floor(bl / 2.0) if why == "doll" else 0.0); var story = float(G.story.size()) if why == "gate" else 0.0
	var home = 0
	for g in G.gh: if not T(g.out): home += 1
	G["over"] = {"ok": why != "fail", "why": why, "kept": kept, "lost": bl - kept, "home": float(home), "fear": G.fearTotal, "story": story, "storyLost": float(G.story.size()) if why == "doll" else 0.0, "alert": G.alert}
	gpOnEnd(why)
	var sv = TS(); var first = why == "gate" and not T(sv.get("gate_" + curLv))
	if first: sv["gate_" + curLv] = 1.0
	sv["nights"] = n0(sv.get("nights")) + 1
	var rw = ((40 + 15 * kept + 25 * story) if why == "gate" else ((20 + 8 * kept) if why == "doll" else 0.0)) + (n0(G.get("unitCoins")) if why != "fail" else 0.0)
	if first: rw += 100
	if why != "fail": sv["best"] = maxf(n0(sv.get("best")), kept); sv.cleared[curLv] = 1.0
	G.over["reward"] = rw; var S = _S(); S.res["coins"] = J.num(S.res.coins) + rw; J.cl(J.G.get("save"), null, [])

# ---------------- 嚇人 ----------------
func say(r, t) -> void: r["say"] = t; r["sayT"] = 2.6
func scareRes(r, amt: float, g) -> void:
	if J.str(r.state) != "home": return
	if not T(r.get("awake")): r["awake"] = true; r["woke"] = true; amt *= 0.6
	r["fear"] = J.num(r.fear) + amt * J.num(G.mods.pow) * gpF(g) * (1 - J.num(r.brave))
	if T(r.get("unit")) and T(r.unit.get("rs")):
		for o in r.unit.rs.duplicate():
			if not is_same(o, r) and J.str(o.state) == "home":
				o["awake"] = true; o["woke"] = true; o["fear"] = J.num(o.fear) + amt * 0.35 * gpF(g) * (1 - J.num(o.brave)); o["jumpT"] = 0.4
				if J.num(o.fear) >= 100 and not (n0(o.get("fleeAfter")) > 0): o["fleeAfter"] = 1.0; o["fleeG"] = g
	r["jumpT"] = 0.5
	if T(g): g["energy"] = minf(100.0, J.num(g.energy) + (8.0 if T(r.brave) else 18.0))
	for k in 5: part(J.num(r.x), J.num(r.y) - 48, (rnd() - 0.5) * 90, -60 - rnd() * 40, 0.6, "sweat")
	doReact(r, g)
	if J.num(r.fear) >= 100 and not (n0(r.get("fleeAfter")) > 0): r["fleeAfter"] = 0.9; r["fleeG"] = g
func flee(r, g) -> void:
	r["state"] = "flee"; r["y"] = fy(r.unit.f); r["vx"] = (-1.0 if J.num(r.x) < WW / 2 else 1.0) * 150; chain(r.unit, 16, n0(r.get("chainD"))); r["tripT"] = 0.9 if rnd() < 0.35 else 0.0; pplScream(r)
	if T(g): g["energy"] = minf(100.0, J.num(g.energy) + 20)
	addFear(J.round(15 * J.num(G.mods.fear)), J.num(r.x), J.num(r.y) - 80)
	for u in G.units.duplicate():
		if J.num(u.ot) == 1 and is_same(u.get("dep"), r.unit) and not T(u.open): unlockUnit(u, "隔籬人心惶惶，入得喇（黑屋）")
	if T(r.unit.story) and idx_of(G.story, r.unit.si) < 0:
		G.story.append(r.unit.si); G.story.sort_custom(func(x, y): return J.str(x) < J.str(y))
		toast("收集到故事碎片——" + J.str(STORY[int(J.num(r.unit.si))]) + "（要正規經陰門返去先帶得走）")
func addFear(a: float, x: float, y: float) -> void:
	G["fear"] = J.num(G.fear) + a; G["fearTotal"] = J.num(G.fearTotal) + a; float_(x, y, "怕意 +" + J.str(a), "#9fd6bf")
	if J.num(G.fearTotal) >= J.num(G.fearNext): G["fearNext"] = J.num(G.fearNext) + 30; G["choiceQ"] = n0(G.get("choiceQ")) + 1
func standStill(g) -> void:
	g["auto"] = null; g["autoS"] = null
	if joy != null: joy = null
func calm(g) -> void: g["still"] = maxf(n0(g.get("still")), 0.12); g["mv"] = 0.0
func _plen(st: String, arr) -> float:
	var Lx = 0.0; var c = G.nodes[st]
	for k in (arr if arr is Array else []):
		var m = G.nodes[k]; Lx += hyp(J.num(m.x) - J.num(c.x), J.num(m.y) - J.num(c.y)); c = m
	return Lx
func approach(g, target) -> bool:
	if not T(g.to):
		if J.str(g.node) == J.str(target): return true
		return gotoNode(g, target)
	var a = J.str(g.node); var b = J.str(g.to); var p = J.num(g.p); var na = G.nodes[a]; var nb = G.nodes[b]; var E = hyp(J.num(nb.x) - J.num(na.x), J.num(nb.y) - J.num(na.y))
	g["to"] = null; g["node"] = b; var okB = gotoNode(g, target); var pB = g.get("auto"); g["node"] = a; var okA = gotoNode(g, target); var pA = g.get("auto"); g["auto"] = null; g["node"] = a; g["to"] = b; g["p"] = p
	var cB = E * (1 - p) + _plen(b, pB) if okB else 1e9; var cA = E * p + _plen(a, pA) if okA else 1e9
	if not okA and not okB: return false
	if cA < cB: g["node"] = b; g["to"] = a; g["p"] = 1 - p; g["auto"] = [a] + (pA if pA is Array else [])
	else: g["auto"] = [b] + (pB if pB is Array else [])
	return true
func nearRes(g, R: float):
	var f = J.num(G.nodes[g.node].f); var best = null; var bd = R
	for r in G.res.duplicate():
		if J.str(r.state) != "home" or not T(r.get("unit")) or J.num(r.unit.f) != f: continue
		var d = absf(J.num(r.x) - J.num(g.x))
		if d < bd: bd = d; best = r
	return best
func doorBlock(g, un):
	var dn = G.nodes.get(J.str(un.did)); var l = _find_link(dn, J.str(un.id)) if T(dn) else null
	if l == null: return "door"
	var ok = canPass(g, l.e)
	return null if (ok is bool and ok) else ok
func scarePress() -> void:
	var g = G.gh[int(J.num(G.active))]
	if not T(g) or T(g.home) or T(g.out): return
	if LIFT != null and T(J.gp(LIFT, "state")):
		var ls = J.mc(LIFT, "state", [])
		if T(ls) and J.gp(ls, "gi") != null and J.num(J.gp(ls, "gi")) == J.num(g.i): return
	if T(g.get("sc")): return
	if J.num(g.scareCd) > 0: float_(J.num(g.x), J.num(g.y) - 80, "啱啱嚇完，等陣先", "#dddddd"); return
	if J.num(g.stun) > 0: float_(J.num(g.x), J.num(g.y) - 80, "跌咗落嚟，等陣先嚇得" if n0(g.get("dropT")) > 0 else ("數緊綠豆，數完先嚇得" if n0(g.get("countT")) > 0 else "暈緊，等陣先嚇得"), "#ffd54a"); return
	standStill(g)
	if n0(g.get("sealT")) > 0: float_(J.num(g.x), J.num(g.y) - 80, "鈴聲未散，暫時嚇唔到人", "#ffe9a0"); return
	if mirrorOn(g) != null: float_(J.num(g.x), J.num(g.y) - 80, "被鏡照住，嚇唔出", "#ffe9a0"); return
	var n = G.nodes[g.node]
	if not T(g.to) and J.str(n.kind) == "in":
		var un0 = unitOf(n.id)
		if T(un0.get("res")) and J.str(un0.res.state) == "home": calm(g); startMove(g, un0.res, un0); return
	var h = null; var bd = 90.0
	for o in G.guards.duplicate():
		if J.str(o.state) == "flee" or J.str(o.state) == "gone": continue
		if absf(J.num(o.y) - J.num(g.y)) > 30: continue
		var d = absf(J.num(o.x) - J.num(g.x))
		if d < bd: bd = d; h = o
	var f0 = J.num(n.f); var cands = []
	for q in G.res: if J.str(q.state) == "home" and T(q.get("unit")) and J.num(q.unit.f) == f0 and absf(J.num(q.x) - J.num(g.x)) < 260: cands.append(q)
	ssort(cands, func(a, b): return absf(J.num(a.x) - J.num(g.x)) - absf(J.num(b.x) - J.num(g.x)))
	var r = null; var blocked = null
	for cq in cands:
		var wq = doorBlock(g, cq.unit)
		if not T(wq): r = cq; break
		if blocked == null and absf(J.num(cq.x) - J.num(g.x)) < 190: blocked = {"r": cq, "why": wq}
	if h != null and (r == null or absf(J.num(h.x) - J.num(g.x)) <= absf(J.num(r.x) - J.num(g.x)) + 20): calm(g); scareGuard(g, h); return
	if LIFT != null and T(J.gp(LIFT, "scareWaiting")):
		var lw = J.mc(LIFT, "scareWaiting", [g])
		if T(lw): calm(g); g["scareCd"] = 1.2; g["actT"] = 0.9; G["shake"] = 0.25; return
	if r != null:
		var un = r.unit; var tr = un.res if T(un.get("res")) and J.str(un.res.state) == "home" else r
		if approach(g, un.id):
			g["autoS"] = {"r": tr}
			if not T(g.to) and not (T(g.get("auto")) and (g.auto as Array).size()): calm(g); g["autoS"] = null; startMove(g, tr, un); return
			float_(J.num(tr.x), J.num(tr.y) - 86, "飄埋去嚇" + (J.str(HH[J.str(tr.hh)].n) if HH.has(J.str(tr.get("hh"))) else "住戶"), "#ffb7a0"); return
		float_(J.num(r.x), J.num(r.y) - 80, "嚇唔到：行唔到入呢戶", "#ffb0b0"); return
	if blocked != null: float_(J.num(g.x), J.num(g.y) - 80, "嚇唔到——" + (J.str(BLOCKMSG[J.str(blocked.why)]) if BLOCKMSG.has(J.str(blocked.why)) else "呢戶未入得"), "#ffb0b0"); return
	var f = J.num(n.f); var some = false; var out = false
	for q in G.res:
		if J.str(q.state) == "home" and T(q.get("unit")) and J.num(q.unit.f) == f: some = true
		if T(q.get("unit")) and J.num(q.unit.f) == f and absf(J.num(q.x) - J.num(g.x)) < 190 and (J.str(q.state) == "away" or J.str(q.state) == "leave" or J.str(q.state) == "back"): out = true
	float_(J.num(g.x), J.num(g.y) - 80, "佢出咗門，唔喺屋企" if out else ("附近冇人：行近住戶（或者撳住戶）先嚇" if some else "呢層冇人喺屋企"), "#dddddd")
func scareGuard(g, h) -> void:
	g["scareCd"] = 1.2; g["actT"] = 0.9; g["dir"] = 1.0 if J.num(h.x) > J.num(g.x) else -1.0; G["shake"] = 0.25
	var kind = J.str(h.kind)
	if kind == "mirror" and signf(J.num(g.x) - J.num(h.x)) == J.num(h.dir): float_(J.num(h.x), J.num(h.y) - 90, "正面對住面鏡，嚇唔到！兜去背後", "#ffe9a0"); return
	if kind == "decoy" and not T(h.get("real")):
		h["state"] = "gone"
		for k in 12: part(J.num(h.x), J.num(h.y) - 30, (rnd() - 0.5) * 120, -60 - rnd() * 60, 0.9, "paper")
		float_(J.num(h.x), J.num(h.y) - 80, "紙人替身！", "#e8d8b0"); return
	if kind == "guard": spook(h, pick(["嘩！有嘢喺我後面！", "乜……乜嘢嚟㗎？！"])); g["energy"] = minf(100.0, J.num(g.energy) + 15); return
	h["courage"] = J.num(h.courage) - 1; h["alertT"] = 0.8; h["shockT"] = 0.9
	float_(J.num(h.x), J.num(h.y) - 90, ("羅盤保安膽量 -1（剩 " + J.str(maxf(0.0, J.num(h.courage))) + "）") if kind == "compass" else "嚇！", "#ff7a5a")
	if J.num(h.courage) <= 0:
		h["state"] = "flee"; h["vx"] = (-1.0 if J.num(h.x) < WW / 2 else 1.0) * 170; pplScream(h); addFear(6.0 if kind == "dog" else 12.0, J.num(h.x), J.num(h.y) - 80); g["energy"] = minf(100.0, J.num(g.energy) + 20)
func part(x: float, y: float, vx: float, vy: float, life: float, type: String) -> void:
	if G.parts.size() < 260: G.parts.append({"x": x, "y": y, "vx": vx, "vy": vy, "life": life, "max": life, "type": type})
const GRAV_T := ["coin", "crumb", "sweat", "tear", "paper", "drip"]
func stepFx(dt: float) -> void:
	for p in G.parts.duplicate():
		p["life"] = J.num(p.life) - dt; p["x"] = J.num(p.x) + J.num(p.vx) * dt; p["y"] = J.num(p.y) + J.num(p.vy) * dt
		if GRAV_T.has(J.str(p.type)): p["vy"] = J.num(p.vy) + 220 * dt
		if J.str(p.type) == "smoke": p["vx"] = J.num(p.vx) * 0.96; p["vy"] = J.num(p.vy) * 0.96
		if p.get("tx") != null: p["x"] = J.num(p.x) + (J.num(p.tx) - J.num(p.x)) * dt * 3; p["y"] = J.num(p.y) + (J.num(p.ty) - J.num(p.y)) * dt * 3
	var np = []
	for p in G.parts: if J.num(p.life) > 0: np.append(p)
	G["parts"] = np
	for w in G.wardFx.duplicate(): w["t"] = J.num(w.t) - dt
	var nw = []
	for w in G.wardFx: if J.num(w.t) > 0: nw.append(w)
	G["wardFx"] = nw; G["shake"] = maxf(0.0, n0(G.get("shake")) - dt)
	for u in G.units.duplicate():
		if n0(u.get("unlockFx")) > 0: u["unlockFx"] = J.num(u.unlockFx) - dt
	for k in G.dark.keys():
		G.dark[k] = J.num(G.dark[k]) - dt
		if J.num(G.dark[k]) <= 0: G.dark.erase(k)
var ULT: Dictionary
func ultPress(i) -> bool:
	var g = G.gh[int(J.num(i))]
	if J.num(g.energy) < 100 or T(g.home) or T(g.out) or T(G.get("ult")): return false
	g["energy"] = 0.0; G["ult"] = {"g": g, "t": 0.0, "f": G.nodes[g.node].f, "done": false}; return true
func applyUlt(Uu) -> void:
	var g = Uu.g; var f = J.num(Uu.f); var k = J.str(g.d.key); var um = J.num(g.um) if T(g.get("um")) else 1.0
	var rs = []
	for r in G.res: if J.num(r.unit.f) == f and J.str(r.state) == "home": rs.append(r)
	var hs = []
	for h in G.guards: if J.num(G.nodes[h.node].f) == f and J.str(h.state) != "flee": hs.append(h)
	if k == "eking":
		G.dark[J.str(f)] = 3.2 * um
		for r in rs:
			scareRes(r, 130, g)
			for q in 6: var p = {"x": r.x, "y": J.num(r.y) - 30, "vx": 0.0, "vy": 0.0, "life": 1.4, "max": 1.4, "type": "suck"}; p["tx"] = g.x; p["ty"] = J.num(g.y) - 30; G.parts.append(p)
		for h in hs: h["wait"] = 3 * um
	if k == "toyol":
		var cl = []
		for j in 5: cl.append({"x": maxf(60.0, J.num(G.gh[0].x) - 260) + j * 110, "v": (1.0 if j % 2 else -1.0) * (220 + j * 30)})
		Uu["clones"] = cl; var got = 0
		for u in G.units.duplicate():
			if J.num(u.f) == f and T(u.open):
				var q = (u.items as Array).size() - 1
				while q >= 0:
					var it = J.str(u.items[q])
					if (it == "money" or it == "key" or it == "doll") and (it != "money" or G.bag.size() < BAGMAX): u.items.remove_at(q); takeItem(g, it, u); got += 1
					q -= 1
		float_(J.num(g.x), J.num(g.y) - 100, "一掃光！攞到 " + str(got) + " 件", "#ffd54a")
		for r in rs: scareRes(r, 85, g)
	if k == "tianhua":
		for r in rs: r["tangle"] = 3.2 * um; scareRes(r, 105, g)
		for h in hs: h["wait"] = 3.2 * um; h["to"] = null
	G["shake"] = 0.5
func invPress() -> void:
	var g = G.gh[int(J.num(G.active))]
	if J.num(g.invCd) > 0 or T(g.out): return
	g["inv"] = J.num(G.mods.inv) * (J.num(g.im) if T(g.get("im")) else 1.0); g["invCd"] = J.num(g.inv) + 9 * (J.num(g.icd) if T(g.get("icd")) else 1.0); float_(J.num(g.x), J.num(g.y) - 90, "隱身", "#9fe0ff")
func chooseCard(i) -> void:
	var c = G.choice[int(J.num(i))] if T(G.get("choice")) and int(J.num(i)) < (G.choice as Array).size() else null
	if not T(c): return
	var m = G.mods; var id = J.str(c.id)
	if id == "spd": m["spd"] = J.num(m.spd) * 1.2
	if id == "pow": m["pow"] = J.num(m.pow) * 1.4
	if id == "inv": m["inv"] = J.num(m.inv) + 2
	if id == "task": m["task"] = J.num(m.task) * 1.35
	if id == "arm": m["arm"] = 0.5
	if id == "fear": m["fear"] = J.num(m.fear) * 1.3
	G["choice"] = null; toast("揀咗「" + J.str(c.t) + "」：" + J.str(c.d))
var MV: Dictionary
const OMEN := 0.75
const STRIKE := 0.65
const AFTER := 0.6
var REACT: Dictionary

# ---------------- 三隻鬼嘅招式 ----------------
func startMove(g, r, un) -> void:
	g["scareCd"] = OMEN + STRIKE + AFTER + 0.3; g["dir"] = 1.0 if J.num(r.x) > J.num(g.x) else -1.0
	var ceil_ = fy(J.num(un.f) + 1) + 16; var side = 1.0 if (J.num(r.x) - J.num(un.rx[0]) < (J.num(un.rx[1]) - J.num(un.rx[0])) / 2) else -1.0
	g["sc"] = {"t": 0.0, "r": r, "un": un, "k": g.d.key, "hit": false, "tr": false, "ceil": ceil_, "side": side, "sx": J.num(r.x) + side * 42}
	float_(J.num(g.x), J.num(g.y) - J.num(g.d.h) - 18, MV[J.str(g.d.key)].n, "#ffb7a0")
func moveUpdate(g, dt: float) -> void:
	var S = g.get("sc")
	if not T(S): return
	if J.num(S.t) < OMEN and (T(g.to) or J.num(g.mv) > 0.05): float_(J.num(g.x), J.num(g.y) - 80, "一郁就破功", "#ffd54a"); g["sc"] = null; g["scareCd"] = 0.4; return
	var t0 = J.num(S.t); S["t"] = t0 + dt; var r = S.r; var k = J.str(S.k)
	if J.num(S.t) < OMEN:
		if k == "tianhua" and rnd() < dt * 9: part(J.num(r.x) + (rnd() - 0.5) * 30, J.num(S.ceil) + 4, 0, 30, 0.8, "drip")
		if k == "toyol" and floor(J.num(S.t) * 8) != floor(t0 * 8):
			var q = floor(J.num(S.t) * 8)
			if not T(S.get("prints")): S["prints"] = []
			S.prints.append({"x": J.num(S.sx) + (J.num(r.x) - J.num(S.sx)) * q / 6 + (4.0 if int(q) % 2 else -4.0), "y": J.num(r.y) - 2})
	if not T(S.hit) and J.num(S.t) >= OMEN:
		S["hit"] = true; G["shake"] = 0.35; g["actT"] = 0.0
		if k == "toyol":
			for q in 6: var p = {"x": r.x, "y": J.num(r.y) - 34, "vx": 0.0, "vy": 0.0, "life": 0.9, "max": 0.9, "type": "note"}; p["tx"] = S.sx; p["ty"] = J.num(r.y) - 14; G.parts.append(p)
		if k == "eking":
			for q in 8: part(J.num(S.sx), J.num(r.y) - 30, (rnd() - 0.5) * 160, -80 - rnd() * 60, 0.8, "crumb")
		if k == "tianhua":
			for q in 10: part(J.num(r.x), J.num(r.y) - 50, (rnd() - 0.5) * 80, -20, 0.7, "drip")
		scareRes(r, 38, g)
	if not T(S.tr) and J.num(S.t) >= OMEN + STRIKE:
		S["tr"] = true; addTrace(MV[k].tr, S, g)
		if k == "tianhua": g["dropT"] = 2.3; g["stun"] = maxf(J.num(g.stun), 2.3); g["to"] = null; g["auto"] = null; float_(J.num(g.x), J.num(g.y) - 70, "哎吔……腰骨痛", "#e8d8b0")
	if J.num(S.t) >= OMEN + STRIKE + AFTER: g["sc"] = null
func addTrace(kind, S, g) -> void:
	var un = S.un; var kd = J.str(kind)
	var Tt = {"k": kind, "f": un.f, "un": un, "x": un.x if kd == "hair" else S.r.x, "y": fy(un.f), "life": 40.0 if kd == "hair" else 22.0, "used": false, "t": 0.0}
	G.traces.append(Tt)
	if kd == "mess":
		G["alert"] = J.num(G.alert) + 1; float_(J.num(un.x), J.num(un.y) - 96, "翻箱倒櫃好嘈！全樓警覺 +1", "#ffb0b0"); checkAlert()
		var best = null; var bd = 1e9
		for h in G.guards.duplicate():
			if J.str(h.kind) != "guard" or J.str(h.state) == "flee": continue
			var hf = J.num(G.nodes[h.node].f); var d = absf(hf - J.num(un.f)) * 400 + absf(J.num(h.x) - J.num(un.x))
			if d < bd: bd = d; best = h
		if best != null: best["state"] = "chase"; best["alertT"] = 1.2; best["say"] = "邊度咁嘈？上去睇睇！"; best["sayT"] = 2.4
		if J.str(S.r.state) == "home": S.r["hunt"] = 4.0; say(S.r, pick(["我啲錢呢？！", "銀包去咗邊呀？！", "邊個翻亂晒啲嘢？"]))
	if kd == "food": Tt["wait"] = 3.2
	if kd == "hair": float_(J.num(un.x), J.num(un.y) - 96, "門框留低濕頭髮……", "#9fe0ff")
func traceUpdate(dt: float) -> void:
	for Tt in G.traces.duplicate():
		Tt["life"] = J.num(Tt.life) - dt; Tt["t"] = J.num(Tt.t) + dt
		if J.str(Tt.k) == "food" and not T(Tt.used):
			var r = Tt.un.get("res")
			if T(r) and J.str(r.state) == "home":
				Tt["wait"] = J.num(Tt.wait) - dt
				if J.num(Tt.wait) <= 0:
					Tt["used"] = true; say(r, "邊個搞到成地都係飯……"); r["tidy"] = 1.2
					var rr_ = r
					r["tidyCb"] = func(_t = null, _a = null):
						rr_["jumpT"] = 0.5; say(rr_, "嘩！碗入面有隻眼！"); scareRes(rr_, 30, null); addFear(6, J.num(rr_.x), J.num(rr_.y) - 90); float_(J.num(rr_.x), J.num(rr_.y) - 110, "二次嚇！", "#ff7a5a")
			else:
				for h in G.guards.duplicate():
					if T(Tt.used) or J.str(h.state) == "flee" or J.str(h.kind) == "dog": continue
					if J.num(G.nodes[h.node].f) != J.num(Tt.f) or absf(J.num(h.x) - J.num(Tt.x)) > 26: continue
					Tt["used"] = true; h["wait"] = 1.6; h["to"] = null; h["say"] = "成地都係飯……咦？碗郁咗！"; h["sayT"] = 2.2; h["alertT"] = 1.0; addFear(6, J.num(h.x), J.num(h.y) - 90); float_(J.num(h.x), J.num(h.y) - 110, "二次嚇！", "#ff7a5a")
		if J.str(Tt.k) == "hair" and not T(Tt.used):
			var vic = null
			for h in G.guards.duplicate():
				if vic == null and J.str(h.state) != "flee" and J.str(h.kind) != "dog" and absf(J.num(h.y) - J.num(Tt.y)) < 30 and absf(J.num(h.x) - J.num(Tt.x)) < 18: vic = h
			for r in G.res.duplicate():
				if vic == null and J.str(r.state) == "flee" and absf(J.num(r.y) - J.num(Tt.y)) < 30 and absf(J.num(r.x) - J.num(Tt.x)) < 18: vic = r
			if vic != null:
				Tt["used"] = true; Tt["life"] = minf(J.num(Tt.life), 2.5); vic["tangle"] = 2.2
				if J.str(vic.state) == "flee": vic["tripT"] = 1.2
				else: vic["wait"] = 2.2; vic["to"] = null; vic["path"] = null
				vic["say"] = "咩嘢纏住我隻腳呀？！濕㗎！"; vic["sayT"] = 2.2; addFear(6, J.num(vic.x), J.num(vic.y) - 90); float_(J.num(vic.x), J.num(vic.y) - 112, "濕髮纏腳！", "#9fe0ff")
	var nt = []
	for Tt in G.traces: if J.num(Tt.life) > 0: nt.append(Tt)
	G["traces"] = nt
	for r in G.res.duplicate():
		if n0(r.get("hunt")) > 0:
			r["hunt"] = J.num(r.hunt) - dt
			if J.str(r.state) == "home":
				r["fear"] = J.num(r.fear) + dt * 5
				if J.num(r.fear) >= 100: flee(r, null)
		if n0(r.get("tidy")) > 0:
			r["tidy"] = J.num(r.tidy) - dt
			if J.num(r.tidy) <= 0 and r.get("tidyCb") != null: var cb = r.tidyCb; r["tidyCb"] = null; (cb as Callable).call()
		if T(r.get("react")):
			r.react["t"] = J.num(r.react.t) - dt
			if J.num(r.react.t) <= 0: r["react"] = null
		if n0(r.get("fleeAfter")) > 0:
			r["fleeAfter"] = J.num(r.fleeAfter) - dt
			if J.num(r.fleeAfter) <= 0 and J.str(r.state) == "home": r["fleeAfter"] = 0.0; flee(r, r.get("fleeG"))
	for h in G.guards.duplicate():
		if n0(h.get("tangle")) > 0: h["tangle"] = J.num(h.tangle) - dt
func _near_other(r, q) -> bool: return not is_same(q, r) and J.str(q.state) != "flee" and J.str(q.state) != "gone" and absf(J.num(q.y) - J.num(r.y)) < 30 and absf(J.num(q.x) - J.num(r.x)) < 130
func pickReact(r, _g):
	if T(r.get("brave")): return "slipper"
	var opts = ["scream", "kneel", "cover", "fall", "phone"]; var near = false
	for o in G.guards + G.res: if _near_other(r, o): near = true; break
	if near: opts.append("push"); opts.append("push")
	var k = pick(opts)
	if k == J.str(r.get("lastReact")): k = pick(opts)
	r["lastReact"] = k; return k
func doReact(r, g) -> void:
	var k = pickReact(r, g); r["react"] = {"k": k, "t": 1.7}; say(r, pick(REACT[k]))
	if k == "phone":
		var ok = n0(G.get("phoneCd")) <= 0 and not (T(G.get("ult")) and T(G.ult.get("phoned")))
		if ok:
			G["alert"] = J.num(G.alert) + 1; G["phoneCd"] = 8.0
			if T(G.get("ult")): G.ult["phoned"] = true
			float_(J.num(r.x), J.num(r.y) - 100, "打電話求救！警覺 +1", "#ffb0b0")
		else: float_(J.num(r.x), J.num(r.y) - 100, "電話打唔通……", "#e8d8b0")
	if k == "slipper" and T(g): g["bounceT"] = 0.45; float_(J.num(g.x), J.num(g.y) - J.num(g.d.h) - 6, "拖鞋打空氣", "#e8d8b0")
	if k == "push":
		var o = null
		for q in G.guards + G.res: if o == null and _near_other(r, q): o = q
		if o != null:
			r["pushTo"] = 1.0 if J.num(o.x) > J.num(r.x) else -1.0; o["jumpT"] = 0.5
			if T(o.get("unit")): o["fear"] = J.num(o.fear) + 10
			else: o["wait"] = maxf(n0(o.get("wait")), 0.9)
func setupBeans() -> void:
	if T(G.get("beansInit")): return
	G["beansInit"] = true; var c = 0
	for u in G.units.duplicate():
		if c < 2 and T(u.get("res")) and J.str(u.ot) != "deity" and J.num(u.f) > 0 and int(J.num(u.f) + J.num(u.u)) % 2 == 1: u["beans"] = true; c += 1
	if not c:
		for u in G.units: if T(u.get("res")) and J.str(u.ot) != "deity": u["beans"] = true; break
const COUNT := ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
func beansCheck(g, dt: float) -> void:
	if J.str(g.d.key) != "toyol": return
	var n = G.nodes[g.node]
	if n0(g.get("countT")) > 0:
		g["countT"] = J.num(g.countT) - dt; g["cntAcc"] = n0(g.get("cntAcc")) + dt
		if J.num(g.cntAcc) > 0.32: g["cntAcc"] = 0.0; g["cntN"] = n0(g.get("cntN")) + 1
		return
	if J.str(n.kind) == "in" and not T(g.to):
		var un = unitOf(n.id)
		if T(un.get("beans")) and not T(un.get("beansDone")): un["beansDone"] = true; g["countT"] = 2.6; g["stun"] = 2.6; g["cntN"] = 0.0; g["taskP"] = 0.0; g["sc"] = null; float_(J.num(g.x), J.num(g.y) - J.num(g.d.h) - 20, "地下有綠豆！忍唔住坐低數……", "#b8f0a0")

# ---------------- 畫招式／痕跡／反應（ctx = 原生 Ctx） ----------------
func drawBowl(x: float, y: float, fill: float) -> void:
	ctx.fillStyle = "#d8d0c0"; ctx.beginPath(); ctx.moveTo(x - 9, y - 6); ctx.quadraticCurveTo(x, y + 5, x + 9, y - 6); ctx.closePath(); ctx.fill(); ctx.strokeStyle = "#6a4a2a"; ctx.lineWidth = 1; ctx.stroke()
	if fill > 0: ctx.fillStyle = "#f0e6c8"; ctx.beginPath(); ctx.ellipse(x, y - 6, 8 * fill, 2.6, 0, 0, 7); ctx.fill()
func drawMouth(x: float, y: float, R: float, open: float, dir: float) -> void:
	ctx.save(); ctx.translate(x, y); ctx.scale(dir, 1)
	ctx.fillStyle = "#120808"; ctx.beginPath(); ctx.ellipse(0, 0, R * 1.1, R * 0.85, 0, 0, 7); ctx.fill()
	ctx.fillStyle = "#7a0e0e"; ctx.beginPath(); ctx.ellipse(R * 0.15, 0, R * 0.85, R * 0.62 * open + 2, 0, 0, 7); ctx.fill()
	ctx.fillStyle = "#e8e0cc"; var n = 7
	for i in n:
		var tx = -R * 0.65 + i * R * 1.6 / n
		ctx.beginPath(); ctx.moveTo(tx, -R * 0.62 * open); ctx.lineTo(tx + R * 0.11, -R * 0.62 * open + R * 0.28); ctx.lineTo(tx + R * 0.22, -R * 0.62 * open); ctx.fill()
		ctx.beginPath(); ctx.moveTo(tx, R * 0.62 * open); ctx.lineTo(tx + R * 0.11, R * 0.62 * open - R * 0.26); ctx.lineTo(tx + R * 0.22, R * 0.62 * open); ctx.fill()
	ctx.fillStyle = "#d0c060"; ctx.beginPath(); ctx.arc(-R * 0.55, -R * 0.9, R * 0.12, 0, 7); ctx.arc(R * 0.35, -R * 0.95, R * 0.12, 0, 7); ctx.fill(); ctx.restore()
func txt(s, x: float, y: float, c, sz = null) -> void: crText(ctx, s, x, y, J.num(sz) if T(sz) else 12.0, c, "center")
func drawMoves() -> void:
	var Gt = J.num(G.t)
	for g in G.gh.duplicate():
		var S = g.get("sc")
		if not T(S) or T(g.home) or T(g.out): continue
		var r = S.r; var un = S.un; var top = fy(J.num(un.f) + 1) + 10; var flo = fy(un.f); var k = J.str(S.k); var t = J.num(S.t); var sx = J.num(S.sx); var rx = J.num(r.x); var ry = J.num(r.y)
		ctx.save(); ctx.beginPath(); ctx.rect(J.num(un.rx[0]) - 40, top, J.num(un.rx[1]) - J.num(un.rx[0]) + 80, flo - top + 2); ctx.clip()
		if t < OMEN:
			var o = t / OMEN
			if k == "eking":
				for i in 3:
					var bx = rx - J.num(S.side) * (14 + i * 14); var by = ry - 22 - absf(sin(Gt * 18 + i * 2)) * 7 * o
					ctx.save(); ctx.translate(bx, by); ctx.rotate(sin(Gt * 22 + i) * 0.35 * o); drawBowl(0, 0, 1); ctx.restore()
					ctx.strokeStyle = "#c8a050"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(bx + 6, by - 8 - sin(Gt * 30 + i) * 4); ctx.lineTo(bx + 14, by - 18); ctx.stroke()
				txt(MV.eking.omen, rx - J.num(S.side) * 28, ry - 72 - o * 6, "#ffe9a0", 11)
			if k == "toyol":
				for p in (S.prints if T(S.get("prints")) else []):
					ctx.fillStyle = "rgba(120,200,150,0.55)"; ctx.beginPath(); ctx.ellipse(J.num(p.x), J.num(p.y), 2.6, 1.5, 0, 0, 7); ctx.fill(); ctx.beginPath(); ctx.ellipse(J.num(p.x) + 3, J.num(p.y) - 3, 1, 1, 0, 0, 7); ctx.fill()
				ctx.fillStyle = "#3a2a1e"; ctx.fillRect(sx - 26, flo - 18, 52, 10); ctx.fillStyle = "#7a6a5a"; ctx.fillRect(sx - 28, flo - 24, 56, 7)
				txt(MV.toyol.omen, sx, flo - 36 - sin(Gt * 9) * 3, "#b8f0a0", 11)
			if k == "tianhua":
				ctx.fillStyle = "rgba(60,90,110," + J.str(0.55 * o) + ")"; ctx.beginPath(); ctx.ellipse(rx, J.num(S.ceil) + 2, 10 + o * 26, 4 + o * 4, 0, 0, 7); ctx.fill()
				txt(MV.tianhua.omen, rx + 22, J.num(S.ceil) + 22, "#9fe0ff", 11)
		elif t < OMEN + STRIKE:
			var s = (t - OMEN) / STRIKE; var e = s / 0.35 if s < 0.35 else 1.0
			if k == "eking":
				ctx.fillStyle = "#2a2e32"; ctx.fillRect(sx - 15, flo - 60, 30, 58); ctx.strokeStyle = "#8a9aa0"; ctx.lineWidth = 1.5; ctx.strokeRect(sx - 15, flo - 60, 30, 58); ctx.beginPath(); ctx.moveTo(sx - 15, flo - 38); ctx.lineTo(sx + 15, flo - 38); ctx.stroke()
				ctx.fillStyle = "rgba(255,240,200," + J.str(0.5 * e) + ")"; ctx.fillRect(sx - 15, flo - 60, 4, 58)
				drawMouth(sx + (rx - sx) * 0.45 * e, flo - 40, 10 + 28 * e, 0.35 + 0.65 * absf(sin(s * PI * 3)), 1.0 if rx > sx else -1.0)
			if k == "toyol":
				ctx.fillStyle = "#3a2a1e"; ctx.fillRect(sx - 26, flo - 18, 52, 10); spr("toyol", sx + (rx - sx) * 0.4 * e, flo - 6 + 18 * (1 - e), 40, {"flip": rx < sx, "rot": (1.0 if rx > sx else -1.0) * 0.3 * (1 - e)}); ctx.fillStyle = "#7a6a5a"; ctx.fillRect(sx - 28, flo - 24, 56, 7)
				if s > 0.3: txt("搶咗！", sx, flo - 62, "#ffd54a", 13)
			if k == "tianhua":
				var yb = J.num(S.ceil) + 8 + (ry - 30 - J.num(S.ceil) - 8) * e; var hx = rx + (-14.0 if rx > J.num(g.x) else 14.0)
				ctx.strokeStyle = "rgba(14,14,18,0.9)"; ctx.lineWidth = 1.6
				for i in 10: ctx.beginPath(); ctx.moveTo(hx - 12 + i * 2.6, J.num(S.ceil)); ctx.quadraticCurveTo(hx - 12 + i * 2.6 + sin(Gt * 6 + i) * 3, (J.num(S.ceil) + yb) / 2, hx - 14 + i * 3, yb - 20); ctx.stroke()
				spr("tianhua_hang", hx, yb, 74, {"flip": rx < J.num(g.x), "rot": sin(Gt * 4) * 0.05})
				for i in 3: ctx.fillStyle = "#9fe0ff"; ctx.beginPath(); ctx.arc(hx - 8 + i * 8, yb + 4 + fmod(Gt * 60 + i * 9, 22), 1.8, 0, 7); ctx.fill()
		else:
			var a = 1 - (t - OMEN - STRIKE) / AFTER
			if k == "eking": ctx.globalAlpha = a; ctx.fillStyle = "#2a2e32"; ctx.fillRect(sx - 15, flo - 60, 30, 58); ctx.globalAlpha = 1
			if k == "toyol": ctx.globalAlpha = a; ctx.fillStyle = "#3a2a1e"; ctx.fillRect(sx - 26, flo - 18, 52, 10); ctx.globalAlpha = 1
		ctx.restore()
func drawTraces() -> void:
	var Gt = J.num(G.t)
	for Tt in G.traces.duplicate():
		var a = minf(1.0, J.num(Tt.life) / 2); ctx.globalAlpha = a; var tx_ = J.num(Tt.x); var ty_ = J.num(Tt.y)
		if J.str(Tt.k) == "food":
			for i in 9:
				var px = tx_ - 26 + ((i * 37) % 52); var py = ty_ - 3 - (i % 3); ctx.fillStyle = "#e8d8a0" if i % 3 else "#c8784a"; ctx.beginPath(); ctx.ellipse(px, py, 3 + (i % 2) * 2, 1.6, 0, 0, 7); ctx.fill()
			ctx.save(); ctx.translate(tx_ + 10, ty_ - 6); ctx.rotate(1.3); drawBowl(0, 0, 0); ctx.restore(); ctx.save(); ctx.translate(tx_ - 18, ty_ - 5); ctx.rotate(-2.2); drawBowl(0, 0, 0); ctx.restore()
			ctx.strokeStyle = "#c8a050"; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.moveTo(tx_ - 4, ty_ - 2); ctx.lineTo(tx_ + 14, ty_ - 5); ctx.moveTo(tx_ - 2, ty_ - 1); ctx.lineTo(tx_ + 12, ty_ + 1); ctx.stroke()
			var r = Tt.un.get("res")
			if T(r) and n0(r.get("tidy")) > 0: txt("執緊……", J.num(r.x), J.num(r.y) - 80, "#e8d8b0", 11)
		if J.str(Tt.k) == "mess":
			for i in 10:
				var px = tx_ - 34 + ((i * 29) % 68); var py = ty_ - 3 - (i % 2) * 2; ctx.save(); ctx.translate(px, py); ctx.rotate(i * 0.7); ctx.fillStyle = "#e8e2d0" if i % 2 else "#9cc89c"; ctx.fillRect(-4, -2.5, 8, 5); ctx.restore()
			ctx.fillStyle = "#4a3424"; ctx.save(); ctx.translate(tx_ + 24, ty_ - 8); ctx.rotate(0.5); ctx.fillRect(-10, -5, 20, 10); ctx.restore()
			if J.num(Tt.t) < 4: txt("乒乒乓乓", tx_, ty_ - 84 - sin(Gt * 14) * 2, "#ffb0b0", 11)
		if J.str(Tt.k) == "hair":
			var top = fy(J.num(Tt.f) + 1) + 16; ctx.strokeStyle = "rgba(30,30,36,0.5)" if T(Tt.used) else "rgba(20,22,28,0.92)"; ctx.lineWidth = 1.4
			for i in 8:
				var hx = tx_ - 14 + i * 1.6 + (24.0 if i > 3 else 0.0); ctx.beginPath(); ctx.moveTo(hx, top + 4); ctx.quadraticCurveTo(hx + sin(Gt * 2 + i) * 4, top + 30, hx + sin(Gt * 1.5 + i) * 3, top + 44 + i % 3 * 8); ctx.stroke()
			if not T(Tt.used): ctx.fillStyle = "rgba(159,224,255,0.7)"; ctx.beginPath(); ctx.arc(tx_ - 10, top + 50 + fmod(Gt * 40, 24), 1.6, 0, 7); ctx.fill()
		ctx.globalAlpha = 1
	for u in G.units.duplicate():
		if not T(u.get("beans")) or not T(u.open): continue
		var cx = (J.num(u.rx[0]) + J.num(u.rx[1])) / 2 + 18; var y = J.num(u.y) - 3
		for i in 16: ctx.fillStyle = "#5a7a3a" if T(u.get("beansDone")) else "#7ac04a"; ctx.beginPath(); ctx.arc(cx - 16 + ((i * 13) % 32), y - (i % 3) * 1.4, 1.7, 0, 7); ctx.fill()
		ctx.fillStyle = "#d24a3a"; ctx.beginPath(); ctx.arc(cx + 20, y - 4, 4, 0, 7); ctx.fill(); ctx.fillStyle = "#ffd54a"; ctx.fillRect(cx + 24, y - 8, 6, 6)
		if T(u.seen): txt("綠豆（數過）" if T(u.get("beansDone")) else "綠豆・玩具", cx, y - 14, "#b8f0a0", 10)
func reactPose(r, P) -> void:
	var R = r.get("react")
	if not T(R) or J.str(r.state) != "home": return
	var q = 1 - J.num(R.t) / 1.7; var Gt = J.num(G.t); var k = J.str(R.k)
	if k == "scream": P["sh"] = sin(Gt * 50) * 2.4; P["jy"] = -absf(sin(q * PI * 2)) * 8
	if k == "kneel": P["sy"] = 0.66; P["jy"] = 2.0; P["ro"] = sin(Gt * 6) * 0.05
	if k == "cover": P["sy"] = 0.86; P["sh"] = sin(Gt * 30) * 1.4; P["hands"] = true
	if k == "fall": P["ro"] = (-1.0 if J.num(r.x) < WW / 2 else 1.0) * minf(1.35, q * 5); P["jy"] = minf(1.0, q * 5) * 10
	if k == "phone": P["phone"] = true; P["sh"] = sin(Gt * 20) * 1
	if k == "slipper": P["slip"] = true; P["ro"] = sin(Gt * 16) * 0.12
	if k == "push": var pt0 = J.num(r.pushTo) if T(r.get("pushTo")) else 1.0; P["ro"] = pt0 * 0.3 * absf(sin(Gt * 10)); P["sh"] = pt0 * absf(sin(Gt * 10)) * 8
	if n0(r.get("tidy")) > 0: P["sy"] = 0.78; P["ro"] = 0.25
func reactProps(r, P) -> void:
	var R = r.get("react")
	if not T(R) or J.str(r.state) != "home": return
	var rx = J.num(r.x); var ry = J.num(r.y); var Gt = J.num(G.t)
	if T(P.get("hands")): ctx.fillStyle = "#e8c0a0"; ctx.beginPath(); ctx.arc(rx - 8, ry - 46, 5, 0, 7); ctx.arc(rx + 8, ry - 46, 5, 0, 7); ctx.fill()
	if T(P.get("phone")):
		ctx.fillStyle = "#202428"; ctx.fillRect(rx + 9, ry - 50, 6, 11); ctx.fillStyle = "#9fe0ff"; ctx.fillRect(rx + 10, ry - 49, 4, 7)
		for i in 2: ctx.strokeStyle = "rgba(159,224,255," + J.str(0.8 - i * 0.3) + ")"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.arc(rx + 12, ry - 45, 9 + i * 6 + fmod(Gt * 20, 5), -0.8, 0.8); ctx.stroke()
	if T(P.get("slip")):
		var a = sin(Gt * 16) * 1.2; ctx.save(); ctx.translate(rx, ry - 42); ctx.rotate(a); ctx.fillStyle = "#3a6ad0"; ctx.fillRect(14, -4, 16, 7); ctx.restore(); ctx.strokeStyle = "rgba(255,255,255,0.5)"; ctx.lineWidth = 2; ctx.beginPath(); ctx.arc(rx, ry - 42, 26, -1.2, 1.2); ctx.stroke()
	if J.str(R.k) == "scream":
		ctx.strokeStyle = "rgba(255,255,255,0.75)"; ctx.lineWidth = 2
		for i in 3:
			var an = -2.2 + i * 0.6; ctx.beginPath(); ctx.moveTo(rx + cos(an) * 24, ry - 46 + sin(an) * 24); ctx.lineTo(rx + cos(an) * 34, ry - 46 + sin(an) * 34); ctx.stroke()
			var an2 = -0.95 + i * 0.6; ctx.beginPath(); ctx.moveTo(rx + cos(an2) * 24, ry - 46 + sin(an2) * 24); ctx.lineTo(rx + cos(an2) * 34, ry - 46 + sin(an2) * 34); ctx.stroke()
func drawTaskProps(o, by: float) -> void:
	if not (n0(o.get("taskP")) > 0): return
	var n = G.nodes[o.node]
	if J.str(n.kind) != "in": return
	var k = J.str(o.d.key); var d = J.num(o.dir); var p = J.num(o.taskP); var ox = J.num(o.x); var oy = J.num(o.y); var oh = J.num(o.d.h); var Gt = J.num(G.t)
	if k == "eking":
		var bx = ox + d * 36; var byy = oy - 14; drawBowl(bx, byy, 1 - p); var mx = ox + d * 6; var my = by - oh * 0.6
		ctx.strokeStyle = "#5a3a2c"; ctx.lineWidth = 3.2; ctx.beginPath(); ctx.moveTo(mx, my); ctx.quadraticCurveTo(ox + d * 30, my - 16 + sin(Gt * 6) * 3, bx, byy - 6); ctx.stroke(); ctx.strokeStyle = "#8a5a44"; ctx.lineWidth = 1.4; ctx.stroke()
		var q = fmod(Gt * 2.2, 1); var qx = bx + (mx - bx) * q; var qy = (byy - 6) + (my - byy + 6) * q - sin(q * PI) * 14; ctx.fillStyle = "#f0e6c8"; ctx.beginPath(); ctx.arc(qx, qy, 3.2, 0, 7); ctx.fill()
	if k == "toyol":
		var dx = ox + d * 30; var dy = oy - 34; var out = 6 + absf(sin(Gt * 7)) * 8; ctx.fillStyle = "#4a3424"; ctx.fillRect(dx - 16, dy - 10, 32, 26); ctx.fillStyle = "#6a4a30"; ctx.fillRect(dx - 14 + d * out, dy - 6, 28, 10); ctx.fillStyle = "#c8a050"; ctx.fillRect(dx - 2 + d * out, dy - 2, 4, 2)
	if k == "tianhua":
		var mx2 = ox + d * 34; var my2 = oy - 62; ctx.fillStyle = "#c8a050"; ctx.fillRect(mx2 - 13, my2 - 20, 26, 40); ctx.fillStyle = "#1a2a30"; ctx.fillRect(mx2 - 10, my2 - 17, 20, 34)
		ctx.save(); ctx.beginPath(); ctx.rect(mx2 - 10, my2 - 17, 20, 34); ctx.clip(); spr("tianhua", mx2, my2 + 20, 40, {"flip": d > 0, "alpha": minf(0.9, p * 2.6)}); ctx.restore(); ctx.fillStyle = "rgba(220,245,255,0.25)"; ctx.fillRect(mx2 - 10, my2 - 17, 5, 34)
		var cy = by - oh * 0.8 + fmod(Gt * 40, oh * 0.5); ctx.fillStyle = "#d8b878"; ctx.fillRect(ox - d * 10 - 5, cy, 10, 3)

# ---------------- 背景：逐格剪貼重砌（離屏畫布） ----------------
var staticCv = null
static func _i32(x: int) -> int:
	x = x & 0xFFFFFFFF
	return x - 0x100000000 if x >= 0x80000000 else x
static func _imul(a: int, b: int) -> int: return _i32(_i32(a) * _i32(b))
static func _hs(a: int, b: int, d: int) -> int:
	var h = _i32(_imul(a + 1, 73856093) ^ _imul(b + 7, 19349663) ^ _imul(d + 3, 83492791))
	h = _imul(h ^ ((h & 0xFFFFFFFF) >> 13), 1274126177)
	return (h ^ ((h & 0xFFFFFFFF) >> 16)) & 0xFFFFFFFF
static func _iw(im) -> float:
	var w = J.gp(im, "naturalWidth")
	return J.num(w) if T(w) else J.num(J.gp(im, "width"))
func bake2() -> void:
	var SC = minf(1.4, sqrt(6.5e6 / (WW * WH))); var B = LV.B
	staticCv = J.S_document_("createElement", ["canvas"]); J.sp(staticCv, "width", J.round(WW * SC)); J.sp(staticCv, "height", J.round(WH * SC))
	var c = J.mc(staticCv, "getContext", ["2d"]); c.scale(SC, SC)
	var img = IMG.get(J.str(B.skin)); var k = J.num(J.gp(img, "width")) / 600 if img != null and T(J.gp(img, "width")) else 1.0
	var sky = c.createLinearGradient(0, 0, 0, WH); sky.addColorStop(0, "#0b0d16"); sky.addColorStop(0.5, "#141622"); sky.addColorStop(1, "#0c0c10"); c.fillStyle = sky; c.fillRect(0, 0, WW, WH)
	for i in 60: c.fillStyle = "rgba(230,230,255," + J.str(0.2 + float((i * 37) % 10) / 20) + ")"; c.fillRect(fmod(i * 197, WW), fmod(i * 61, maxf(40.0, fy(FL) - 60)), 1.5, 1.5)
	var put = func(r, dx: float, dy: float, dw: float, dh: float, flip, dark):
		if img == null or not T(J.gp(img, "width")): c.fillStyle = "#222"; c.fillRect(dx, dy, dw, dh); return
		c.save()
		var fl = T(flip) or (r.size() > 4 and T(r[4]))
		if fl: c.translate(dx + dw, dy); c.scale(-1, 1); dx = 0.0; dy = 0.0
		c.drawImage(img, J.num(r[0]) * k, J.num(r[2]) * k, (J.num(r[1]) - J.num(r[0])) * k, (J.num(r[3]) - J.num(r[2])) * k, dx, dy, dw, dh); c.restore()
		if T(dark): c.fillStyle = dark; c.fillRect(dx, dy, dw, dh)
	if not _bakeTiles(c, SC, B):
		var resPool = B.src.res; var gPool = B.src.ground; var ui = 0
		var RM = {"mahjong": "room_mahjong", "gamer": "room_gamer", "nurse": "room_nurse", "helper": "room_helper", "gym": "room_gym", "shopper": "room_shopper"}
		for f in int(FL):
			var top = fy(f + 1); var bot = fy(f) + 12; var hgt = bot - top; var dark = "rgba(10,20,40,0.45)" if f == 0 else null
			var ci = 0
			for col in LV.xs:
				var x0 = J.num(col[0]); var w = J.num(col[1]) - x0
				if J.str(col[2]) == "stair": put.call(B.src.gstair if f <= 1 else B.src.stair, x0, top, w, hgt, false, dark)
				elif J.str(col[2]) == "lift": put.call(B.src.glift if f <= 1 else B.src.lift, x0, top, w, hgt, false, dark)
				elif J.str(col[2]) == "back": put.call(B.src.back, x0, top, w, hgt, not ((B.src.back as Array).size() > 4 and T(B.src.back[4])) and J.str(LV.key) == "flat", dark)
				else:
					var un = null
					for q in G.units: if J.num(q.f) == f and J.num(q.rx[0]) == x0: un = q; break
					var rk = null
					if un != null and J.str(un.ot) != "deity": rk = "room_carpark" if f == 0 else ("room_lobby" if f == 1 and J.num(un.u) == 0 else RM.get(J.str(un.hh)))
					var ri = IMG.get(rk) if rk != null else null
					if ri != null and T(J.gp(ri, "width")):
						c.save()
						if (ci + f) % 2 == 1: c.translate(x0 + w, top); c.scale(-1, 1); c.drawImage(ri, 0, 0, w, hgt)
						else: c.drawImage(ri, x0, top, w, hgt)
						c.restore()
						if T(dark): c.fillStyle = "rgba(10,20,40,0.25)"; c.fillRect(x0, top, w, hgt)
						c.strokeStyle = "rgba(0,0,0,0.6)"; c.lineWidth = 3; c.strokeRect(x0 + 1, top + 1, w - 2, hgt - 2)
					else:
						var r
						if un != null and J.str(un.ot) == "deity": r = B.src.deity[0]
						elif f <= 1: r = gPool[(ci + f) % (gPool as Array).size()]
						else: r = resPool[(ui * 5 + f) % (resPool as Array).size()]; ui += 1
						put.call(r, x0, top, w, hgt, (ci + f) % 2 == 1, dark)
				ci += 1
			c.fillStyle = "rgba(0,0,0,0.55)"; c.fillRect(0, bot - 4, WW, 6)
		var rt = B.src.roof; var rh = J.num(rt[3]) - J.num(rt[2]); var rw = J.num(rt[1]) - J.num(rt[0]); var x = 0.0
		while x < WW: put.call(rt, x, fy(FL) - rh, rw, rh + 8, int(x / rw) % 2 == 1, null); x += rw
		c.strokeStyle = "rgba(120,140,150,0.5)"; c.lineWidth = 4; c.beginPath(); c.moveTo(0, fy(1) + 30); c.lineTo(WW, fy(1) + 30); c.stroke()
		c.fillStyle = "rgba(220,220,160,0.25)"; var x2 = 120.0
		while x2 < WW - 100: c.fillRect(x2, fy(0) - 4, 60, 3); x2 += 110
	for P in LV.pipes:
		var px = J.num(LV.ucols[int(J.num(P[2]))][1]) - 6; c.strokeStyle = "#5a6a68"; c.lineWidth = 5; c.beginPath(); c.moveTo(px, fy(P[1]) - 110); c.lineTo(px, fy(P[0])); c.stroke(); c.strokeStyle = "#8a9a96"; c.lineWidth = 1.5; c.stroke()
		var y = fy(P[1]) - 100
		while y < fy(P[0]): c.fillStyle = "#3a4442"; c.fillRect(px - 5, y, 10, 4); y += 40
	c.font = "bold 13px " + FONT; c.textAlign = "left"
	for f in int(FL) + 1:
		var yy = fy(f) - J.num(LV.B.FH) + 44 + (60.0 if f == int(FL) else 0.0)
		c.lineWidth = 3; c.strokeStyle = "#000"; c.strokeText(J.str(FLN[f]), 6, yy); c.fillStyle = "#e8d8b0"; c.fillText(J.str(FLN[f]), 6, yy)

func _bakeTiles(c, SC: float, B) -> bool:
	var Tm = {}
	for kk in ["corr1", "corr2", "stairR", "stairL", "lift", "roof", "lobby", "carpark"]:
		var im = IMG.get("twt_" + kk)
		if im == null:
			var SPR = J.G.get("SPR")
			im = J.gp(SPR, "twt_" + kk) if SPR != null else null
		if im == null or not (_iw(im) > 0): return false
		Tm[kk] = im
	var N = 416.0; var FLY = {"corr1": 400.0, "corr2": 400.0, "stairR": 398.0, "stairL": 398.0, "lift": 403.0, "roof": 402.0, "lobby": 405.0, "carpark": 405.0}
	var KK = 2 if J.str(LV.key) == "shop" else 1; var SHOP = J.str(LV.key) == "shop"; var BT = "rgba(10,20,40,0.34)"
	var tile = func(kk: String, sx0: float, sx1: float, sy0: float, x0: float, w: float, top: float, floor_: float, flip, tint):
		var im = Tm[kk]; var q = _iw(im) / N; var s = (floor_ - top) / (FLY[kk] - sy0); var h = (N - sy0) * s
		c.save()
		if T(flip): c.translate(x0 + w, 0); c.scale(-1, 1); c.drawImage(im, sx0 * q, sy0 * q, (sx1 - sx0) * q, (N - sy0) * q, 0, top, w, h)
		else: c.drawImage(im, sx0 * q, sy0 * q, (sx1 - sx0) * q, (N - sy0) * q, x0, top, w, h)
		c.restore()
		if T(tint): c.fillStyle = tint; c.fillRect(x0, top, w, h)
	var RM = {"mahjong": "room_mahjong", "gamer": "room_gamer", "nurse": "room_nurse", "helper": "room_helper", "gym": "room_gym", "shopper": "room_shopper"}
	var resPool = B.src.res; var gPool = B.src.ground; var ui = 0
	for f in int(FL):
		var top = fy(f + 1); var floor_ = fy(f) + 3; var bot = fy(f) + 12; var hgt = bot - top; var c2prev = false
		var ci = -1
		for col in LV.xs:
			ci += 1
			var x0 = J.num(col[0]); var w = J.num(col[1]) - x0; var kd = J.str(col[2]); var h0 = _hs(KK, f, ci); var tn = BT if f == 0 else null
			if kd == "stair" or kd == "back" or (kd == "lift" and not T(LV.lift)):
				if kd == "back" and f == 0 and not G.nodes.has("f0_b"): tile.call("carpark", 296.0, N, 0.0, x0, w, top, floor_, false, "rgba(10,20,40,0.16)"); continue
				var up = "R" if kd == "stair" else ("L" if kd == "back" else ("L" if f % 2 else "R"))
				if up == "R": tile.call("stairR", 62.0, N, 0.0, x0, w, top, floor_, false, tn)
				else: tile.call("stairL", 0.0, 354.0, 0.0, x0, w, top, floor_, false, tn)
				continue
			if kd == "lift": tile.call("lift", 58.0, 360.0, 0.0 if f == int(FL) - 1 else 46.0, x0, w, top, floor_, false, tn); continue
			var un = null
			for q in G.units: if J.num(q.f) == f and J.num(q.rx[0]) == x0: un = q; break
			var deity = un != null and J.str(un.ot) == "deity"; var rk = RM.get(J.str(un.hh)) if un != null and not deity and f >= 1 else null; var ri = IMG.get(rk) if rk != null else null
			if f == 0: tile.call("carpark", 0.0, N, 0.0, x0, w, top, floor_, (h0 >> 5) & 1, "rgba(10,20,40,0.16)"); c2prev = false; continue
			if ri != null and T(J.gp(ri, "width")):
				c.save()
				if (ci + f) % 2 == 1: c.translate(x0 + w, top); c.scale(-1, 1); c.drawImage(ri, 0, 0, w, hgt)
				else: c.drawImage(ri, x0, top, w, hgt)
				c.restore(); c.strokeStyle = "rgba(0,0,0,0.6)"; c.lineWidth = 3; c.strokeRect(x0 + 1, top + 1, w - 2, hgt - 2); c2prev = false; continue
			if SHOP:
				var r = B.src.deity[0] if deity else (gPool[(ci + f) % (gPool as Array).size()] if f == 1 else resPool[(ui * 5 + f) % (resPool as Array).size()])
				if not deity and f != 1: ui += 1
				_put_shop(c, r, x0, top, w, hgt, (ci + f) % 2 == 1, B); continue
			if f == 1: tile.call("lobby", 0.0, N, 0.0, x0, w, top, floor_, ci % 2 == 1, null); continue
			var two = not deity and not c2prev and (h0 % 100) < 40; c2prev = two
			if two: tile.call("corr2", 0.0, N, 0.0, x0, w, top, floor_, (h0 >> 7) & 1, null)
			else:
				tile.call("corr1", 0.0, N, 0.0, x0, w, top, floor_, (int(J.num(un.u)) % 2 == 0) if un != null else ((h0 >> 7) & 1), null)
				if deity:
					c.fillStyle = "rgba(110,8,8,0.20)"; c.fillRect(x0, top, w, floor_ - top); var dx = J.num(un.x)
					for p in 7:
						var px = dx - 15 + ((h0 >> (p * 3)) & 7) * 4.3; var py = fy(f) - 92 + ((h0 >> (p * 2 + 5)) & 7) * 9 + p * 3
						c.save(); c.translate(px, py); c.rotate((((h0 >> (p + 9)) & 7) - 3.5) * 0.05); c.fillStyle = "#c0281f" if p % 3 == 0 else "#9e1e1a"; c.fillRect(-4.5, -10, 9, 20); c.fillStyle = "rgba(30,0,0,0.35)"; c.fillRect(2.5, -10, 2, 20)
						c.fillStyle = "rgba(240,200,90,0.6)"; c.fillRect(-2, -6, 4, 1.4); c.fillRect(-2, -1, 4, 1.4); c.fillRect(-2, 4, 4, 1.4); c.restore()
	var rs = (fy(FL) + 3 + 8) / FLY.roof; var rh = N * rs; var rtop = fy(FL) + 3 - FLY.roof * rs; var x = 0.0; var i = 0; var F = 30.0; var im = Tm.roof; var q = _iw(im) / N
	while x < WW:
		var A = i % 2 == 1; var sx1 = 196.0 if A else N; var w = sx1 * rs; var flip = ((_hs(KK, 99, i) >> 3) & 1) == 1 if A else ((i >> 1) % 2 == 1)
		var oc = J.S_document_("createElement", ["canvas"]); J.sp(oc, "width", maxf(1.0, ceil(w * SC))); J.sp(oc, "height", maxf(1.0, ceil(rh * SC))); var ox = J.mc(oc, "getContext", ["2d"])
		if flip: ox.translate(J.num(J.gp(oc, "width")), 0); ox.scale(-1, 1)
		ox.drawImage(im, 0, 0, sx1 * q, N * q, 0, 0, J.num(J.gp(oc, "width")), J.num(J.gp(oc, "height"))); ox.setTransform(1, 0, 0, 1, 0, 0)
		if i > 0:
			ox.globalCompositeOperation = "destination-in"; var gr = ox.createLinearGradient(0, 0, F * SC, 0); gr.addColorStop(0, "rgba(0,0,0,0)"); gr.addColorStop(1, "rgba(0,0,0,1)"); ox.fillStyle = gr; ox.fillRect(0, 0, J.num(J.gp(oc, "width")), J.num(J.gp(oc, "height")))
		c.drawImage(oc, x, rtop, w, rh); x += w - F; i += 1
	for f in int(FL):
		var top = fy(f + 1); var floor_ = fy(f) + 10; var ci2 = 0
		for col in LV.xs:
			if ci2:
				var xb = J.num(col[0]); var g = c.createLinearGradient(xb - 8, 0, xb + 8, 0); g.addColorStop(0, "rgba(0,0,0,0)"); g.addColorStop(0.5, "rgba(0,0,0,0.58)"); g.addColorStop(1, "rgba(0,0,0,0)"); c.fillStyle = g; c.fillRect(xb - 8, top, 16, floor_ - top)
			ci2 += 1
	for f in int(FL) + 1:
		var yb = fy(f) + 3; var g = c.createLinearGradient(0, yb, 0, yb + 26); g.addColorStop(0, "rgba(0,0,0,0)"); g.addColorStop(0.28, "rgba(0,0,0,0.5)"); g.addColorStop(1, "rgba(0,0,0,0)")
		if f > 0: c.fillStyle = g; c.fillRect(0, yb, WW, 26)
	for e in [[0.0, 1.0], [WW, -1.0]]:
		var g = c.createLinearGradient(e[0], 0, e[0] + e[1] * 28, 0); g.addColorStop(0, "rgba(0,0,0,0.55)"); g.addColorStop(1, "rgba(0,0,0,0)"); c.fillStyle = g; c.fillRect(0.0 if e[1] > 0 else WW - 28, 0, 28, WH)
	return true
func _put_shop(c, r, dx: float, dy: float, dw: float, dh: float, flip: bool, B) -> void:
	var img = IMG.get(J.str(B.skin)); var k = J.num(J.gp(img, "width")) / 600 if img != null and T(J.gp(img, "width")) else 1.0
	if img == null or not T(J.gp(img, "width")): c.fillStyle = "#222"; c.fillRect(dx, dy, dw, dh); return
	c.save()
	if flip or ((r as Array).size() > 4 and T(r[4])): c.translate(dx + dw, dy); c.scale(-1, 1); dx = 0.0; dy = 0.0
	c.drawImage(img, J.num(r[0]) * k, J.num(r[2]) * k, (J.num(r[1]) - J.num(r[0])) * k, (J.num(r[3]) - J.num(r[2])) * k, dx, dy, dw, dh); c.restore()

# ---------------- 住戶作息、連鎖、響聲 ----------------
func resUpdate2(dt: float) -> void:
	if T(J.G.get("__twNatL")) and TwLogic.res2(G, dt, PHT, SX, FYS):
		G["lureCd"] = maxf(0.0, n0(G.get("lureCd")) - dt); questUpdate(dt); reliefUpdate(dt); return
	var ph = int(minf(2.0, J.num(G.phase))); var tt = J.num(G.t) / PHT
	for r in G.res.duplicate():
		var hh = HH.get(J.str(r.get("hh")))
		if hh == null: continue
		if J.str(r.state) == "home":
			var want = J.num(hh.awake[ph]) == 1
			if want and not T(r.get("awake")): r["awake"] = true; say(r, pick(["又醒咗……", "咩鐘數呀而家？"]))
			if not want and T(r.get("awake")) and not T(r.get("woke")) and J.num(r.fear) < 20 and rnd() < dt * 0.05: r["awake"] = false
			r["idleT"] = J.num(r.idleT) - dt
			if J.num(r.idleT) <= 0:
				r["idleT"] = 10 + rnd() * 14
				if T(r.get("awake")) and not T(r.get("say")): say(r, pick(hh.idle))
			if T(hh.get("leave")) and not T(r.get("left")) and tt >= J.num(hh.leave):
				r["left"] = true; r["state"] = "leave"; r["awake"] = true; say(r, "返工喇，出門口先" if J.str(r.hh) == "nurse" else "去晨運先"); r.unit["doorOpen"] = 4.0; r["vx"] = -70.0
		if J.str(r.state) == "away" and T(hh.get("away")) and tt >= J.num(hh.away): r["state"] = "back"; r["x"] = SX; r["y"] = fy(r.unit.f) - 16; r["vx"] = 70.0; r["awake"] = true; say(r, "收工返屋企喇……")
		if J.str(r.state) == "leave":
			r["x"] = J.num(r.x) + J.num(r.vx) * dt
			if J.num(r.x) <= SX: r["state"] = "gone"
		if J.str(r.state) == "back":
			var tx = J.num(r.unit.rx[0]) + 30; r["x"] = J.num(r.x) + signf(tx - J.num(r.x)) * 70 * dt
			if absf(tx - J.num(r.x)) < 4: r["state"] = "home"; r.unit["doorOpen"] = 3.0
	for u in G.units.duplicate():
		if not T(u.get("rs")): continue
		var hr = null
		for r in u.rs: if J.str(r.state) == "home": hr = r; break
		u["res"] = hr if hr != null else (u.rs[0] if (u.rs as Array).size() else null)
		for p in u.props: p["t"] = maxf(0.0, J.num(p.t) - dt); p["cd"] = maxf(0.0, J.num(p.cd) - dt)
	for p in (G.cprops if T(G.get("cprops")) else []): p["t"] = maxf(0.0, J.num(p.t) - dt); p["cd"] = maxf(0.0, J.num(p.cd) - dt)
	for e in G.edges:
		if T(e.get("fire")): e.fire["shut"] = maxf(0.0, J.num(e.fire.shut) - dt); e.fire["cd"] = maxf(0.0, J.num(e.fire.cd) - dt)
	G["lureCd"] = maxf(0.0, n0(G.get("lureCd")) - dt)
	questUpdate(dt); reliefUpdate(dt)
func chain(un, amt: float, depth := 0.0) -> void:
	if depth > 1: return
	var hit = 0
	for v in G.units.duplicate():
		if is_same(v, un) or (v.rs as Array).is_empty() or J.str(v.ot) == "deity": continue
		var adj = (J.num(v.f) == J.num(un.f) and absf(J.num(v.u) - J.num(un.u)) == 1) or (absf(J.num(v.f) - J.num(un.f)) == 1 and J.num(v.rx[0]) < J.num(un.rx[1]) and J.num(v.rx[1]) > J.num(un.rx[0]))
		if not adj: continue
		for r in v.rs.duplicate():
			if J.str(r.state) != "home": continue
			r["awake"] = true; r["woke"] = true; r["fear"] = J.num(r.fear) + amt; r["jumpT"] = 0.4; hit += 1
			if rnd() < 0.5: say(r, pick(["隔籬做咩嗌成咁？", "樓上咩聲呀？！", "咩事咩事？！"]))
			if J.num(r.fear) >= 100 and not (n0(r.get("fleeAfter")) > 0): r["fleeAfter"] = 1.2; r["chainD"] = depth + 1
	if hit: float_(J.num(un.x), J.num(un.y) - 120, "連鎖！隔籬 " + str(hit) + " 個醒晒", "#ffb7a0"); addFear(minf(12.0, hit * 2), J.num(un.x), J.num(un.y) - 140)
func noise(nodeId, lvl: float, _why = null) -> void:
	var nid = J.str(nodeId); var n = G.nodes.get(nid)
	if not T(n): return
	if not T(G.get("noiseFx")): G["noiseFx"] = []
	G.noiseFx.append({"x": n.x, "y": J.num(n.y) - 40, "t": 1.2, "lvl": lvl})
	for h in G.guards.duplicate():
		var st = J.str(h.state)
		if J.str(h.kind) != "guard" or st == "chase" or st == "scared" or st == "shift" or st == "flee" or st == "gone": continue
		var p = dijkstra(h, J.str(h.node), nid)
		if p == null: continue
		var d = 0.0; var a = G.nodes[h.node]
		for id in p: var b = G.nodes[id]; d += absf(J.num(a.x) - J.num(b.x)) + absf(J.num(a.y) - J.num(b.y)); a = b
		if d > 700 * lvl or not inZone(h, J.num(n.f), 1): continue
		if st == "puzzle" and J.str(h.get("invNode")) == nid: spook(h, "同一個位又有怪聲！"); continue
		h["state"] = "inv"; h["invNode"] = nid; h["path"] = p; h["to"] = null; h["wait"] = 0.0; h["alertT"] = 0.8; h["say"] = pick(["咩聲嚟㗎？過去睇睇", "邊度傳嚟嘅？", "又係" + J.str(FLN[int(J.num(n.f))]) + "？"]); h["sayT"] = 2.2
func spook(h, txt0) -> void:
	if J.str(h.state) == "shift" or J.str(h.state) == "gone": return
	h["nerve"] = (3.0 if h.get("nerve") == null else J.num(h.nerve)) - 1; h["state"] = "scared"; h["scT"] = 2.6; h["to"] = null; h["path"] = null
	var gS = null; var dS = 1e9
	for g in G.gh.duplicate():
		if T(g.home) or T(g.out): continue
		var d = absf(J.num(g.x) - J.num(h.x)) + absf(J.num(g.y) - J.num(h.y)) * 3
		if d < dS: dS = d; gS = g
	h["scAway"] = ((1.0 if J.num(h.x) >= J.num(gS.x) else -1.0) if gS != null and dS < 400 else (-1.0 if rnd() < 0.5 else 1.0))
	h["vx"] = J.num(h.scAway) * 55; h["dir"] = -J.num(h.scAway); h["shockT"] = 0.9
	var s1 = uniq([txt0]); h["say"] = s1 if s1 != null else uniq(SPOOKL); h["sayT"] = 2.0; h["alertT"] = 0.6
	addFear(6, J.num(h.x), J.num(h.y) - 90); float_(J.num(h.x), J.num(h.y) - 110, "保安嚇親！", "#ffd54a")
	if rnd() < 0.3: G["alert"] = J.num(G.alert) + 1; checkAlert(); float_(J.num(h.x), J.num(h.y) - 130, "對講機：「管理處！" + J.str(FLN[int(J.num(G.nodes[h.node].f))]) + "有怪事！」警覺 +1", "#ffb0b0")
	if J.num(h.nerve) <= 0:
		h["state"] = "shift"; h["say"] = "唔做喇！交更！"; h["sayT"] = 2.5; float_(J.num(h.x), J.num(h.y) - 130, "保安頂唔順，落樓交更", "#9fd6bf"); G.relief.append({"t": 26.0, "zone": h.get("zone")}); h["path"] = dijkstra(h, J.str(h.node), "f1_s")
func reliefUpdate(dt: float) -> void:
	var rl = G.relief if T(G.get("relief")) else []
	for r in rl.duplicate():
		r["t"] = J.num(r.t) - dt
		if J.num(r.t) <= 0 and not T(r.get("done")):
			r["done"] = true; var zn = r.zone if T(r.get("zone")) else [1.0, 3.0]; var h = mkHuman("guard", "f%d_s" % int(J.num(zn[0]))); h["zone"] = zn; h["nerve"] = 3.0; G.guards.append(h); float_(J.num(h.x), J.num(h.y) - 80, "新一更保安上班", "#ffb0b0")
	var nr = []
	for r in rl: if not T(r.get("done")): nr.append(r)
	G["relief"] = nr
func lureCost() -> void:
	G["alertAcc"] = n0(G.get("alertAcc")) + 0.34
	if J.num(G.alertAcc) >= 1: G["alertAcc"] = J.num(G.alertAcc) - 1; G["alert"] = J.num(G.alert) + 1; checkAlert()

# ---------------- 互動掣 ----------------
func ctxAction(g):
	if not T(g) or T(g.to) or T(g.home) or T(g.out): return null
	var n = G.nodes[g.node]
	if J.str(n.kind) == "in":
		var un = unitOf(n.id)
		for q in (G.quests if T(G.get("quests")) else []):
			if J.str(q.id) == "lost" and J.num(q.state) == 1 and is_same(q.owner, un): return {"k": "deliver", "t": "交還" + J.str(q.thing), "q": q}
		for p in un.props:
			if T(PROP[J.str(p.k)].get("v")) and J.num(p.cd) <= 0: return {"k": "prop", "t": PROP[J.str(p.k)].v, "p": p, "un": un}
		for p in un.props:
			if J.str(p.k) == "ancestor": return {"k": "respect", "t": "（祖先牌位：唔好郁）"}
		return null
	for p in (G.cprops if T(G.get("cprops")) else []):
		if J.str(p.node) == J.str(n.id) and J.num(p.cd) <= 0: return {"k": "cprop", "t": "敲水管" if J.str(p.k) == "pipeK" else "整閃走廊燈", "p": p}
	if UNIT != null:
		var ua = J.mc(UNIT, "action", [g, n])
		if T(ua): return ua
	if LIFT != null:
		var la = J.mc(LIFT, "action", [g, n])
		if T(la): return la
	if J.str(n.kind) == "lift" and T(LV.lift) and n0(G.get("liftCd")) <= 0: return {"k": "lift", "t": "叫𨋢自己上落"}
	if J.str(n.kind) == "pipe": return {"k": "pipeN", "t": "敲雨水喉（另一層都聽到）"}
	var nid = J.str(n.id)
	if nid.ends_with("_s") or nid.ends_with("_b"):
		var fe = null
		for l in n.links: if T(l.e.get("fire")): fe = l.e; break
		if fe != null and J.num(fe.fire.cd) <= 0 and J.num(fe.fire.shut) <= 0: return {"k": "fire", "t": "閂防煙門（保安要兜路）", "e": fe}
	return null
func actPress() -> void:
	var g = G.gh[int(J.num(G.active))]; var a = ctxAction(g)
	if not T(a): return
	standStill(g)
	if T(g.to): float_(J.num(g.x), J.num(g.y) - 80, "行到位先做得", "#ffd54a"); return
	calm(g)
	var k = J.str(J.gp(a, "k"))
	if k == "liftIn": J.mc(LIFT, "enter", [g]); return
	if UNIT != null and T(J.mc(UNIT, "act", [g, a])): return
	if k == "respect": float_(J.num(g.x), J.num(g.y) - 90, "祖先牌位要尊重，我哋唔郁", "#e8d8b0"); return
	if k == "deliver":
		var q = a.q; q["state"] = 2.0; G["carry"] = null; var ow = q.owner.get("res")
		if T(ow): say(ow, "咦？我副" + J.str(q.thing) + "點解會喺張枱度嘅？多謝晒……"); ow["fear"] = 0.0
		addFear(25, J.num(g.x), J.num(g.y) - 90)
		for x in G.gh: x["energy"] = minf(100.0, J.num(x.energy) + 30)
		float_(J.num(g.x), J.num(g.y) - 120, "支線完成：" + J.str(q.t), "#8affc8"); giveStory(); toast("支線完成！" + J.str(q.t) + "——怕意 +25、三隻鬼能量 +30。"); return
	if k == "prop":
		var p = a.p; var un = a.un; var P = PROP[J.str(p.k)]
		if n0(G.get("lureCd")) > 0: return
		p["t"] = 3.0; p["cd"] = 18.0; G["lureCd"] = 1.5; g["actT"] = 0.9; g["dir"] = 1.0 if J.num(p.x) > J.num(g.x) else -1.0
		for r in un.rs.duplicate():
			if J.str(r.state) != "home": continue
			if not T(r.get("awake")):
				r["awake"] = true; r["woke"] = true; r["fear"] = J.num(r.fear) + J.num(P.f) * 0.6 * J.num(G.mods.pow) * gpF(g) * (1 - J.num(r.brave)); r["jumpT"] = 0.5; say(r, pick(["咩聲呀……邊個？", "發開夢？"]))
			else:
				scareRes(r, J.num(P.f), g)
				if rnd() < 0.6: say(r, pick(PROPLINE[J.str(p.k)]))
		if J.str(p.k) == "mahjong":
			for q2 in 10: part(J.num(p.x), J.num(un.y) - 40, (rnd() - 0.5) * 90, -60 - rnd() * 40, 0.8, "paper")
		float_(J.num(p.x), J.num(un.y) - 96, J.str(P.v) + "！", "#ffb7a0"); noise(un.did, J.num(P.lv), P.n); lureCost(); g["energy"] = minf(100.0, J.num(g.energy) + 8); return
	if k == "cprop":
		var cp = a.p; cp["t"] = 3.0; cp["cd"] = 20.0; lureCost(); var nn = G.nodes[cp.node]
		if J.str(cp.k) == "pipeK": float_(J.num(nn.x), J.num(nn.y) - 90, "噹！噹！噹！", "#ffd54a"); noise(cp.node, 2)
		else:
			float_(J.num(nn.x), J.num(nn.y) - 90, "走廊燈閃閃吓……", "#ffd54a")
			for h in G.guards.duplicate():
				if J.str(h.kind) == "guard" and J.num(G.nodes[h.node].f) == J.num(nn.f) and absf(J.num(h.x) - J.num(nn.x)) < 260 and J.str(h.state) != "chase": spook(h, "盞燈……盞燈做咩閃成咁？！")
			noise(cp.node, 1)
		return
	if k == "lift":
		G["liftCd"] = 16.0; lureCost(); var fs = []
		for f in int(FL): if absf(f - J.num(G.nodes[g.node].f)) >= 2: fs.append(float(f))
		var tf = pick(fs if fs.size() else [0.0]); var ln = "f%d_l" % int(tf)
		G["liftFx"] = {"f": tf, "t": 2.5}; float_(J.num(g.x), J.num(g.y) - 90, "部𨋢自己落咗去" + J.str(FLN[int(tf)]) + "……", "#ffd54a"); noise(ln, 3); return
	if k == "pipeN":
		if n0(G.get("lureCd")) > 0: return
		G["lureCd"] = 6.0; lureCost(); var e = null
		for l in G.nodes[g.node].links: if T(l.e.get("pipe")): e = l.e; break
		var other = e.b if J.str(e.a) == J.str(g.node) else e.a
		float_(J.num(g.x), J.num(g.y) - 90, "噹……（" + J.str(FLN[int(J.num(G.nodes[other].f))]) + "都聽到）", "#ffd54a"); noise(other, 2); return
	if k == "fire":
		var fe = a.e; fe.fire["shut"] = 14.0; fe.fire["cd"] = 26.0; float_(J.num(g.x), J.num(g.y) - 90, "防煙門閂咗！保安要兜路", "#9fd6bf")
		for h in G.guards.duplicate(): h["path"] = null; h["repath"] = 0.0
		return
func giveStory() -> void:
	for i in (STORY as Array).size():
		if idx_of(G.story, float(i)) < 0:
			G.story.append(float(i)); G.story.sort_custom(func(x, y): return J.str(x) < J.str(y)); toast("收集到故事碎片——" + J.str(STORY[i])); return
func questUpdate(dt: float) -> void:
	for q in (G.quests if T(G.get("quests")) else []).duplicate():
		var id = J.str(q.id)
		if id == "debt":
			if J.num(q.state) == 0 and J.num(G.t) >= J.num(q.at):
				q["state"] = 1.0; var h = mkHuman("collector", J.str(q.unit.did), {"courage": 3.0, "real": true}); h["wait"] = 1e9; G.guards.append(h); q["h"] = h
				toast(J.str(FLN[int(J.num(q.unit.f))]) + "有個收數佬拍門大嗌，屋企人嚇到唔敢出聲……嚇走佢！")
			if J.num(q.state) == 1:
				var h2 = q.h; h2["bangT"] = n0(h2.get("bangT")) - dt
				if J.num(h2.bangT) <= 0 and J.str(h2.state) != "flee":
					h2["bangT"] = 3.2; h2["say"] = pick(["開門呀！還錢呀！", "我知你喺入面！", "唔還錢就淋紅油！"]); h2["sayT"] = 2.4; G["shake"] = maxf(n0(G.get("shake")), 0.12)
					for r in q.unit.rs.duplicate(): if J.str(r.state) == "home": r["fear"] = minf(90.0, J.num(r.fear) + 4)
				if J.str(h2.state) == "flee" or J.str(h2.state) == "gone":
					q["state"] = 2.0; q.unit.items.append("money"); q.unit.items.append("money")
					for r in q.unit.rs.duplicate(): if J.str(r.state) == "home": r["fear"] = 0.0; say(r, "佢……佢走咗？好似有人幫緊我哋……")
					addFear(30, J.num(q.unit.x), J.num(q.unit.y) - 100); float_(J.num(q.unit.x), J.num(q.unit.y) - 130, "支線完成：" + J.str(q.t), "#8affc8"); giveStory(); toast("收數佬嚇到碌落樓梯！佢跌低咗個銀包喺門口。")
		if id == "mj" and J.num(q.state) == 0:
			var all = true
			for r in q.unit.rs: if J.str(r.state) == "home": all = false; break
			if all: q["state"] = 2.0; addFear(20, J.num(q.unit.x), J.num(q.unit.y) - 100); q.unit.items.append("money"); float_(J.num(q.unit.x), J.num(q.unit.y) - 130, "支線完成：" + J.str(q.t), "#8affc8"); giveStory()
		if id == "lost" and J.num(q.state) == 0 and J.str(G.get("carry")) == "lost": q["state"] = 1.0

# ---------------- 畫：單位物件（原生 TwDraw.props）、𨋢叮、響聲、支線標記、細地圖 ----------------
var cam := {"x": 0.0, "y": 0.0, "s": 1.0, "z": 1.0, "free": null}
var LASTP = null
var CULL := {"y0": -1e9, "y1": 1e9}
func drawProps2() -> void:
	if T(J.G.get("__twNat")) and ctx is Ctx: TwDraw.props(ctx, G, CULL, FYS)   # 原生畫單位物件、走廊機關、防煙門（JS 後備畫法只用喺錄製器）
	var lf = G.get("liftFx")
	if T(lf) and J.num(lf.t) > 0:
		var ln = G.nodes["f%d_l" % int(J.num(lf.f))]; lf["t"] = J.num(lf.t) - 0.033
		ctx.fillStyle = "rgba(255,230,140," + J.str(0.5 + 0.4 * sin(J.num(G.t) * 20)) + ")"; ctx.fillRect(J.num(ln.x) - 14, J.num(ln.y) - 80, 28, 74); ctx.fillStyle = "#000"; ctx.font = "bold 14px " + FONT; ctx.textAlign = "center"; ctx.fillText("叮！", J.num(ln.x), J.num(ln.y) - 86)
	for z in (G.noiseFx if T(G.get("noiseFx")) else []).duplicate():
		z["t"] = J.num(z.t) - 0.033; ctx.strokeStyle = "rgba(255,213,74," + J.str(maxf(0.0, J.num(z.t))) + ")"; ctx.lineWidth = 2
		for i in int(J.num(z.lvl)): ctx.beginPath(); ctx.arc(J.num(z.x), J.num(z.y), (1.2 - J.num(z.t)) * 90 + i * 16, 0, 7); ctx.stroke()
	var nz = []
	for z in (G.noiseFx if T(G.get("noiseFx")) else []): if J.num(z.t) > 0: nz.append(z)
	G["noiseFx"] = nz
	for q in (G.quests if T(G.get("quests")) else []):
		if J.str(q.id) == "lost" and J.num(q.state) < 2:
			var u = q.owner
			if T(u.seen) or T(u.entered): txt(("交還" + J.str(q.thing)) if J.num(q.state) == 1 else "？", (J.num(u.rx[0]) + J.num(u.rx[1])) / 2, J.num(u.y) - 112, "#8affc8", 13)
			if J.num(q.state) == 0 and (T(q.hid.seen) or T(q.hid.entered)): txt("✦" + J.str(q.thing), (J.num(q.hid.rx[0]) + J.num(q.hid.rx[1])) / 2, J.num(q.hid.y) - 100, "#8affc8", 11)
func miniJump() -> void:
	var b = null
	for q in buttons: if J.str(q.id) == "mini": b = q; break
	if b == null or LASTP == null: return
	var wx = (J.num(LASTP.x) - J.num(b.x)) / J.num(b.w) * WW; var wy = (J.num(LASTP.y) - J.num(b.y)) / J.num(b.h) * WH; cam["free"] = {"x": clamp_(wx, 0, WW), "y": clamp_(wy, 0, WH)}
func drawMini() -> void:
	var mw = 74.0; var mh = minf(110.0, J.round(74 * WH / WW)); var mx = 10.0; var my = TOP + 60; var sx = mw / WW; var sy = mh / WH; buttons.append({"id": "mini", "x": mx, "y": my, "w": mw, "h": mh})
	crPanel(ctx, mx - 5, my - 5, mw + 10, mh + 10, "ink")
	if ctx is Ctx and TwDraw.mini(ctx, G, FYS, mx, my, mw, mh, WW, WH, J.num(cam.x), J.num(cam.y), VW / (J.num(cam.s) * J.num(cam.z)), (VH - TOP - BOT) / (J.num(cam.s) * J.num(cam.z)), int(FL)): return
	for u in G.units:
		var top = fy(J.num(u.f) + 1) + 16; ctx.fillStyle = "#5a2420" if J.str(u.ot) == "deity" else ("#2a2430" if not T(u.open) else ("#3a4632" if T(u.seen) or T(u.entered) else "#1c1820"))
		ctx.fillRect(mx + J.num(u.rx[0]) * sx + 0.5, my + top * sy, (J.num(u.rx[1]) - J.num(u.rx[0])) * sx - 1, (J.num(u.y) - top) * sy)
	ctx.fillStyle = "#8aac6c"
	for id in ["f0_e", "f%d_p" % int(FL)]: var n = G.nodes[id]; ctx.fillRect(mx + J.num(n.x) * sx - 2, my + J.num(n.y) * sy - 3, 4, 3)
	for h in G.guards:
		if J.str(h.state) == "gone": continue
		ctx.fillStyle = "#d87e3c" if J.str(h.kind) == "collector" else ("#e0483a" if J.str(h.state) == "chase" else "#b8786a"); ctx.fillRect(mx + J.num(h.x) * sx - 1.5, my + J.num(h.y) * sy - 3, 3, 3)
	for i in G.gh.size():
		var g = G.gh[i]
		if T(g.home) or T(g.out): continue
		ctx.fillStyle = "#efe5cf" if i == int(J.num(G.active)) else "#9c88cc"; ctx.beginPath(); ctx.arc(mx + J.num(g.x) * sx, my + J.num(g.y) * sy - 2, 3.0 if i == int(J.num(G.active)) else 2.0, 0, 7); ctx.fill()
	var S = J.num(cam.s) * J.num(cam.z); ctx.strokeStyle = "rgba(216,204,176,0.6)"; ctx.lineWidth = 1.2; ctx.strokeRect(mx + J.num(cam.x) * sx, my + J.num(cam.y) * sy, (VW / S) * sx, ((VH - TOP - BOT) / S) * sy)

# ---------------- 畫面基本 ----------------
func resize() -> void:
	var NT = J.G.get("__twNat")
	VW = J.num(J.gp(NT, "w")) if T(NT) else minf(J.num(J.gp(_w(), "innerWidth")), 520.0)
	VH = J.num(J.gp(NT, "h")) if T(NT) else J.num(J.gp(_w(), "innerHeight"))
	if T(NT): DPR = J.num(J.gp(NT, "s"))
	if cv != null:
		J.sp(J.gp(cv, "style"), "width", J.str(VW) + "px"); J.sp(J.gp(cv, "style"), "height", J.str(VH) + "px"); J.sp(cv, "width", J.round(VW * DPR)); J.sp(cv, "height", J.round(VH * DPR))
	cam["s"] = VW / (J.num(LV.camW) if T(LV) and T(LV.get("camW")) else 600.0); BOTX = VW / WW
func crayon(c2, x: float, y: float, w: float, h: float, col, dens = null) -> void:
	c2.fillStyle = col; c2.fillRect(x, y, w, h); c2.save(); c2.beginPath(); c2.rect(x, y, w, h); c2.clip(); c2.globalAlpha = 0.16; c2.strokeStyle = "#000"; c2.lineWidth = 1
	var n = int(floor(w * h / (J.num(dens) if T(dens) else 140.0)))
	for i in n:
		var px = x + randf() * w; var py = y + randf() * h; var L = 4 + randf() * 9; c2.beginPath(); c2.moveTo(px, py); c2.lineTo(px + L, py - L * 0.35); c2.stroke()
	c2.globalAlpha = 0.10; c2.strokeStyle = "#fff"
	var i2 = 0
	while i2 < n / 2.0:
		var px = x + randf() * w; var py = y + randf() * h; c2.beginPath(); c2.moveTo(px, py); c2.lineTo(px + 5, py - 2); c2.stroke(); i2 += 1
	c2.restore()
func bake() -> void:
	if T(LV.get("B")): bake2(); return
	staticCv = J.S_document_("createElement", ["canvas"]); J.sp(staticCv, "width", WW * 2); J.sp(staticCv, "height", WH * 2); var c = J.mc(staticCv, "getContext", ["2d"])
	var bgi = IMG.get(J.str(LV.get("bg")))
	if bgi != null and T(J.gp(bgi, "width")): c.drawImage(bgi, 0, 0, WW * 2, WH * 2)
	else: c.fillStyle = "#1a1a1e"; c.fillRect(0, 0, WW * 2, WH * 2)
func W2S(x: float, y: float) -> Dictionary:
	var S = J.num(cam.s) * J.num(cam.z); return {"x": (x - J.num(cam.x)) * S, "y": (y - J.num(cam.y)) * S + TOP}
func spr(k, x: float, y: float, h: float, o = null) -> void:
	var im = IMG.get(J.str(k))
	if im == null or not T(J.gp(im, "width")): return
	var w = h * J.num(J.gp(im, "width")) / J.num(J.gp(im, "height")); if not (o is Dictionary): o = {}
	ctx.save(); ctx.globalAlpha = 1.0 if o.get("alpha") == null else J.num(o.alpha); ctx.translate(x + n0(o.get("ox")), y + n0(o.get("oy")))
	if T(o.get("rot")): ctx.rotate(J.num(o.rot))
	ctx.scale((-1.0 if T(o.get("flip")) else 1.0) * (J.num(o.sx) if T(o.get("sx")) else 1.0), J.num(o.sy) if T(o.get("sy")) else 1.0); ctx.drawImage(im, -w / 2, -h, w, h); ctx.restore()
func sprite(k, x: float, y: float, h: float, flip = false, alpha = null) -> void:
	var im = IMG.get(J.str(k))
	if im == null or not T(J.gp(im, "width")): return
	var w = h * J.num(J.gp(im, "width")) / J.num(J.gp(im, "height")); ctx.globalAlpha = 1.0 if alpha == null else J.num(alpha)
	if T(flip): ctx.save(); ctx.translate(x, 0); ctx.scale(-1, 1); ctx.drawImage(im, -w / 2, y - h, w, h); ctx.restore()
	else: ctx.drawImage(im, x - w / 2, y - h, w, h)
	ctx.globalAlpha = 1
func drawWard(e) -> void:
	var n = G.nodes[J.str(e.a)] if J.str(G.nodes[J.str(e.a)].kind) == "door" else G.nodes[J.str(e.b)]; var x = J.num(n.x); var y = J.num(n.y); var w = e.get("ward")
	if not T(w): return
	if y < J.num(CULL.y0) or y - 100 > J.num(CULL.y1): return
	if w == "fu": ctx.fillStyle = "#d42a2a"; ctx.fillRect(x - 6, y - 92, 12, 16); ctx.strokeStyle = "#ffd54a"; ctx.lineWidth = 1.5; ctx.strokeRect(x - 6, y - 92, 12, 16)
	if w == "menshen":
		ctx.fillStyle = "#b7302a"; ctx.fillRect(x - 14, y - 70, 13, 46); ctx.fillRect(x + 1, y - 70, 13, 46); ctx.strokeStyle = "#ffd54a"; ctx.lineWidth = 2; ctx.strokeRect(x - 14, y - 70, 13, 46); ctx.strokeRect(x + 1, y - 70, 13, 46)
		ctx.fillStyle = "#ffd54a"; ctx.beginPath(); ctx.arc(x - 7.5, y - 56, 4, 0, 7); ctx.arc(x + 7.5, y - 56, 4, 0, 7); ctx.fill()
	if w == "zha": ctx.fillStyle = "#c8ccd8"; ctx.fillRect(x + 8, y - 44, 8, 6); ctx.strokeStyle = "#2a2030"; ctx.lineWidth = 1; ctx.strokeRect(x + 8, y - 44, 8, 6); ctx.beginPath(); ctx.arc(x + 12, y - 46, 3, PI, 0); ctx.stroke()
	if w == "nuomi":
		ctx.fillStyle = "#fffbe8"
		for k in 20: ctx.fillRect(x - 24 + k * 2.5, y - 6 + (k % 3) * 1.5, 2, 2)
	if w == "datuk":
		ctx.globalAlpha = 0.3 + 0.15 * sin(J.num(G.t) * 3); ctx.fillStyle = "#ffcc66"; ctx.beginPath(); ctx.arc(x + 22, y - 14, 14, 0, 7); ctx.fill(); ctx.globalAlpha = 1
		ctx.fillStyle = "#c4202a"; ctx.fillRect(x + 13, y - 24, 18, 20); ctx.strokeStyle = "#ffd54a"; ctx.lineWidth = 1.5; ctx.strokeRect(x + 13, y - 24, 18, 20); ctx.fillStyle = "#ffd54a"; ctx.fillRect(x + 16, y - 20, 12, 3)
func bubble(x: float, y: float, t, col = null) -> void: crBubble(x, y, t, col)
func rr(x: float, y: float, w: float, h: float, r: float) -> void:
	ctx.beginPath(); ctx.moveTo(x + r, y); ctx.arcTo(x + w, y, x + w, y + h, r); ctx.arcTo(x + w, y + h, x, y + h, r); ctx.arcTo(x, y + h, x, y, r); ctx.arcTo(x, y, x + w, y, r); ctx.closePath()
var buttons: Array = []

# ---------------- v7 蠟筆 UI ----------------
var CR: Dictionary = {"cache": {}, "n": 0, "M": 8, "tones": {}}
var CRC: Dictionary = {}
func crCol(c):
	if typeof(c) != TYPE_STRING: return c
	var k = (c as String).to_lower()
	if k == "#fff": k = "#ffffff"
	return CRC.get(k, c)
func crRnd(seed_v: float) -> Callable:
	var st = {"s": int(fmod(seed_v, 2147483646.0)) + 1}
	return func():
		st.s = (st.s * 16807) % 2147483647; return float(st.s - 1) / 2147483646.0
func crHash(s: String) -> int:
	var h = 2166136261
	for i in s.length(): h = h ^ s.unicode_at(i); h = _imul(h, 16777619)
	return (h & 0xFFFFFFFF) % 2147483646 + 1
func crGrain():
	if CR.get("grain") != null: return CR.grain
	var c = J.S_document_("createElement", ["canvas"]); J.sp(c, "width", 128); J.sp(c, "height", 128); var x = J.mc(c, "getContext", ["2d"]); var r = crRnd(99)
	for i in 2600:
		var v = r.call(); x.fillStyle = ("rgba(0,0,0," + J.str(0.10 + r.call() * 0.25) + ")") if v < 0.55 else ("rgba(255,240,220," + J.str(0.03 + r.call() * 0.07) + ")")
		var a1 = r.call() * 128; var a2 = r.call() * 128; var a3 = 1 + r.call() * 1.6; var a4 = 1 + r.call() * 1.2; x.fillRect(a1, a2, a3, a4)
	x.strokeStyle = "rgba(0,0,0,0.2)"; x.lineWidth = 0.7
	for j in 70:
		var px = r.call() * 128; var py = r.call() * 128; x.beginPath(); x.moveTo(px, py); var b1 = px + 4 + r.call() * 10; var b2 = py + (r.call() - 0.5) * 3; x.lineTo(b1, b2); x.stroke()
	CR["grain"] = c; return c
func crShape(r: Callable, w: float, h: float, j: float, ring: bool) -> Array:
	var P = []
	if ring:
		var R = w / 2; var n = maxi(18, int(J.round(R * 0.6)))
		for i in n:
			var a = float(i) / n * PI * 2; var p0 = R + cos(a) * (R + (r.call() - 0.5) * j); var p1 = R + sin(a) * (R + (r.call() - 0.5) * j); P.append([p0, p1])
		return P
	var seg = func(x0: float, y0: float, x1: float, y1: float):
		var L = hyp(x1 - x0, y1 - y0); var n = maxi(2, int(J.round(L / 16)))
		for i in n:
			var t = float(i) / n; var p0 = x0 + (x1 - x0) * t + (r.call() - 0.5) * j; var p1 = y0 + (y1 - y0) * t + (r.call() - 0.5) * j; P.append([p0, p1])
	seg.call(0.0, 0.0, w, 0.0); seg.call(w, 0.0, w, h); seg.call(w, h, 0.0, h); seg.call(0.0, h, 0.0, 0.0); return P
func crTrace(c, P: Array) -> void:
	c.beginPath(); c.moveTo(P[0][0], P[0][1])
	for i in range(1, P.size()): c.lineTo(P[i][0], P[i][1])
	c.closePath()
func crBuild(w: float, h: float, tone, mode: String):
	var TN = CR.tones.get(J.str(tone), CR.tones.ink); var M = float(CR.M); var Dp = DPR; var o = J.S_document_("createElement", ["canvas"]); J.sp(o, "width", ceil((w + M * 2) * Dp)); J.sp(o, "height", ceil((h + M * 2) * Dp))
	var c = J.mc(o, "getContext", ["2d"]); c.scale(Dp, Dp); c.translate(M, M)
	var r = crRnd(crHash(J.str(w) + "x" + J.str(h) + J.str(tone) + mode)); var pr = mode == "p"; var off = mode == "off"; var pan = mode == "panel"; var bar = mode == "bar" or mode == "fill"; var ring = mode.begins_with("ring"); var Jt = 2.4 if pan else (1.0 if bar else 1.7)
	var P = crShape(r, w, h, Jt, ring)
	if not pr and not pan and not bar: c.save(); c.translate(2, 3); crTrace(c, P); c.fillStyle = "rgba(0,0,0,0.55)"; c.fill(); c.restore()
	crTrace(c, P)
	if mode == "fill" and J.str(tone) == "dawn": var gd = c.createLinearGradient(0, 0, w, 0); gd.addColorStop(0, "#24361f"); gd.addColorStop(0.62, "#6a2220"); gd.addColorStop(1, "#b8642c"); c.fillStyle = gd
	else: c.fillStyle = TN.m if mode == "fill" else TN.b
	c.fill()
	c.save(); crTrace(c, P); c.clip()
	var g = c.createLinearGradient(0, 0, 0, h); g.addColorStop(0, "rgba(255,240,220,0.06)"); g.addColorStop(1, "rgba(0,0,0,0.34)"); c.fillStyle = g; c.fillRect(0, 0, w, h)
	c.strokeStyle = TN.h if mode == "fill" else TN.m; c.lineCap = "round"; var step = 7.0 if pan else (3.5 if bar else 5.0)
	var k = -h - 4
	while k < w + h:
		c.globalAlpha = (0.22 if pan else (0.28 if mode == "fill" else 0.36)) + r.call() * 0.25; c.lineWidth = 0.8 + r.call() * 1.4; c.beginPath(); var a0 = k + (r.call() - 0.5) * 3; c.moveTo(a0, h + 2); var e1 = a0 + h * 0.9 + (r.call() - 0.5) * 4; c.lineTo(e1, -2); c.stroke()
		k += step + r.call() * 2
	c.strokeStyle = TN.e; var nq = minf(260.0, w * h / 900) if pan else w / 6
	var q = 0
	while q < nq:
		c.globalAlpha = 0.05 + r.call() * 0.08; c.lineWidth = 0.6 + r.call(); var qx = r.call() * w; var qy = r.call() * h; c.beginPath(); c.moveTo(qx, qy); var f1 = qx + 6 + r.call() * 14; var f2 = qy - 3 - r.call() * 5; c.lineTo(f1, f2); c.stroke(); q += 1
	c.globalAlpha = 1; c.fillStyle = c.createPattern(crGrain(), "repeat"); c.fillRect(-2, -2, w + 4, h + 4)
	if not pan and not bar and not ring:
		c.strokeStyle = TN.h
		for s2 in 3:
			c.globalAlpha = 0.08 + r.call() * 0.12; c.lineWidth = 2 + r.call() * 2; c.beginPath(); var yy = 3 + s2 * 2.2 + r.call(); var m1 = 6 + r.call() * 6; c.moveTo(m1, yy); var l1 = w - 6 - r.call() * 10; var l2 = yy + (r.call() - 0.5) * 2; c.lineTo(l1, l2); c.stroke()
	c.restore()
	var passes = 4 if pr else (2 if bar else 3); var jj = 2.6 if pan else (1.0 if bar else 2.0)
	if mode != "fill":
		for p in passes:
			var Q = []
			for v in P: var q0 = v[0] + (r.call() - 0.5) * jj; var q1 = v[1] + (r.call() - 0.5) * jj; Q.append([q0, q1])
			c.globalAlpha = 0.95 if p == 0 else 0.42 + r.call() * 0.3; c.strokeStyle = "rgba(0,0,0,0.55)" if (p == passes - 1 and not bar) else TN.e; c.lineWidth = (3.4 if pr else (2.1 if pan else (1.3 if bar else 2.2))) - p * 0.35 + r.call() * 0.5; c.lineJoin = "round"; crTrace(c, Q); c.stroke()
	if not bar and not ring:
		c.fillStyle = TN.e
		for o2 in [[0.0, 0.0], [w, 0.0], [w, h], [0.0, h]]:
			c.globalAlpha = 0.6; c.beginPath(); var z0 = o2[0] + (r.call() - 0.5) * 2; var z1 = o2[1] + (r.call() - 0.5) * 2; var z2 = 1.3 + r.call() * 1.2; c.arc(z0, z1, z2, 0, 7); c.fill()
	c.globalAlpha = 1
	if off: c.globalCompositeOperation = "source-atop"; c.fillStyle = "rgba(16,13,18,0.58)"; c.fillRect(-M, -M, w + 2 * M, h + 2 * M); c.globalCompositeOperation = "source-over"
	return o
func crGet(w: float, h: float, tone, mode: String):
	w = maxf(4.0, J.round(w)); h = maxf(4.0, J.round(h)); var k = J.str(w) + "|" + J.str(h) + "|" + J.str(tone) + "|" + mode + "|" + J.str(DPR); var v = CR.cache.get(k)
	if v == null:
		if int(CR.n) > 220: CR["cache"] = {}; CR["n"] = 0
		v = crBuild(w, h, tone, mode); CR.cache[k] = v; CR["n"] = int(CR.n) + 1
	return v
func crBlit(c, im, x: float, y: float) -> void:
	var M = float(CR.M); c.drawImage(im, x - M, y - M, J.num(J.gp(im, "width")) / DPR, J.num(J.gp(im, "height")) / DPR)
func crPanel(c, x: float, y: float, w: float, h: float, tone = null) -> void: crBlit(c, crGet(w, h, tone if T(tone) else "paper", "panel"), x, y)
func crText(c, s, x: float, y: float, sz: float, col = null, al = null, mw = null, mid = null, wt = null) -> void:
	s = J.str(s)
	if T(J.gp(_w(), "__twNat")): TwRun.cr_text(c, s, x, y, sz, crCol(col if T(col) else "#efe5cf"), J.str(al) if T(al) else "left", J.num(mw) if T(mw) else 0.0, T(mid), J.str(wt) if T(wt) else "bold"); return
	c.save(); c.font = (J.str(wt) if T(wt) else "bold") + " " + J.str(sz) + "px " + FONT; c.textAlign = al if T(al) else "left"; c.textBaseline = "middle" if T(mid) else "alphabetic"; c.lineJoin = "round"
	var F = func(dx: float, dy: float):
		if T(mw): c.fillText(s, x + dx, y + dy, mw)
		else: c.fillText(s, x + dx, y + dy)
	c.fillStyle = "rgba(6,3,8,0.88)"; F.call(1.4, 2.0); c.lineWidth = maxf(2.4, sz * 0.2); c.strokeStyle = "rgba(8,5,10,0.82)"
	if T(mw): c.strokeText(s, x, y, mw)
	else: c.strokeText(s, x, y)
	c.fillStyle = crCol(col if T(col) else "#efe5cf"); F.call(0.0, 0.0); c.globalAlpha *= 0.35; F.call(0.6, -0.4); c.restore()
var _rx_px = RegEx.create_from_string("(\\d+(?:\\.\\d+)?)px")
func crFill(s, x: float, y: float, mw = null) -> void:
	var m = _rx_px.search(J.str(ctx.font)); var sz = float(m.get_string(1)) if m != null else 13.0; var bold = J.str(ctx.font).contains("bold")
	crText(ctx, s, x, y, sz, ctx.fillStyle, ctx.textAlign, mw, false, "bold" if bold else "normal")
func crBar(c, x: float, y: float, w: float, h: float, f, tone = null) -> void:
	crBlit(c, crGet(w, h, "ink", "bar"), x, y); var fv = maxf(0.0, minf(1.0, n0(f)))
	if fv <= 0: return
	c.save(); c.beginPath(); c.rect(x - 2, y - 3, w * fv + 2, h + 6); c.clip(); crBlit(c, crGet(w, h, tone if T(tone) else "red", "fill"), x, y); c.restore()
	if fv < 1: c.strokeStyle = CR.tones.get(J.str(tone), CR.tones.red).e; c.globalAlpha = 0.8; c.lineWidth = 2; c.beginPath(); c.moveTo(x + w * fv, y - 1); c.lineTo(x + w * fv + 1, y + h + 1); c.stroke(); c.globalAlpha = 1
const CRTONE := {"#6e1c1c": "red", "#5a1c1c": "red", "#2a4a7a": "violet", "#2f5a4a": "moss", "#3a5a2a": "moss", "#2e3a34": "moss", "#8a5a14": "rust", "#3a3a40": "ink", "#2c2c33": "ink", "#24242a": "ink", "#26262c": "ink"}
func crTone(col) -> String: return CRTONE.get((J.str(col) if T(col) else "").to_lower(), "ink")
func crBtn(c, x: float, y: float, w: float, h: float, label, tone, pressed = false, off = false) -> void:
	var dy = 2.0 if T(pressed) else 0.0; crBlit(c, crGet(w, h, tone, "p" if T(pressed) else ("off" if T(off) else "n")), x, y + dy)
	if T(label): crText(c, label, x + w / 2, y + h / 2 + dy + 1, 17.0 if h >= 50 else 16.0, "#8a7e84" if T(off) else CR.tones.get(J.str(tone), CR.tones.ink).t, "center", w - 10, true)
func crBubble(x: float, y: float, t, col = null) -> void:
	ctx.font = "bold 12px " + FONT; var w = ceil((minf(190.0, J.num(ctx.measureText(J.str(t)).width) + 16)) / 8) * 8; crBlit(ctx, crGet(w, 22, "note", "bar"), x - w / 2, y - 24)
	ctx.save(); ctx.fillStyle = col if T(col) else "#2a1e1c"; ctx.textAlign = "center"; ctx.fillText(J.str(t), x, y - 9, w - 8); ctx.restore()

# ======================================================================
# 第四段：GP 介面、地上掉落／陰氣地、主畫面 draw、HUD、面板、標題、輸入、主迴圈、open/close、run
# （JS 後備畫法：原生 TwRun 畫嘅時候 ctx 一定係真 CanvasItem，__nat_tw* 一定成功；錄製器先用得着嘅後備唔搬）
# ======================================================================
var LIFT = null
var UNIT = null
var PPLFX = null
var TWX = null
var TWo = null
var joy = null
var ptr = null
const JR := 58.0
var pts: Dictionary = {}
var pinch = null
var PRESS = null
const PAD := 10.0
var last := 0.0
var HUDC := false
var HUDB: Array = []
var HUDX := false

static func _now() -> float: return Time.get_ticks_usec() / 1000.0
func _gi() -> int: return int(J.num(G.active))

func gpSvPut(_sv) -> void: pass
func gpPill(x: float, y: float, w: float, t, bg, fg) -> void:
	ctx.save(); ctx.fillStyle = bg; ctx.strokeStyle = "rgba(0,0,0,0.55)"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(x, y, w, 16, 8); ctx.fill(); ctx.stroke(); ctx.restore()
	crText(ctx, t, x + w / 2, y + 12.5, 11, fg, "center", w - 4)
func gpBadge(o, x: float, y: float) -> void:
	if not T(G.get("gpHas")): return
	if T(o.get("trainee")): gpPill(x + 8, y - 12, 48, "見習", "#7a2522", "#ffd9c8")
	else: gpPill(x + 2, y - 12, 60, "鬼力 " + J.str(o.get("pow")), "#26331f", "#d8f0b8")
func gpTitle() -> void:
	if not T(J.G.get("GP")): return
	var team = gpTeam()
	for i in GH.size():
		var r = gpRead(GH[i]); var cx = VW / 2 + (i - 1) * 100
		crText(ctx, "見習（未招募）" if T(r.tr) else "鬼力 " + J.str(r.pow), cx, VH * 0.52 + 18, 13, "#ff8a72" if T(r.tr) else "#c8e6a8", "center", 96)
	crText(ctx, "三隻合共鬼力 " + J.str(team), VW / 2, VH * 0.52 + 40, 15, "#efe5cf", "center", VW - 30)
	var lvs = ["flat", "shop"]
	for i in 2:
		var lv = lvs[i]; var need = gpNeed(lv); var cx = (34 + (VW - 56) / 2 + (VW - 56) / 4) if i else (22 + (VW - 56) / 4); var ok = J.num(team) >= J.num(need)
		crText(ctx, "建議鬼力 " + J.str(need) + ("" if ok else "（唔夠）"), cx, VH * 0.80 + 76, 13, "#b2d394" if ok else "#ff6a5a", "center", (VW - 56) / 2)
func gpOver(o, y: float) -> void:
	if not T(o.get("gpHas")): return
	var ok = J.num(o.gpTeam) >= J.num(o.gpNeed)
	ctx.textAlign = "center"; ctx.fillStyle = "#d8f0b8" if ok else "#ff7a64"; ctx.font = "bold 16px " + FONT; crFill("你嘅鬼力 " + J.str(o.gpTeam) + "／建議 " + J.str(o.gpNeed), VW / 2, y + 204, VW - 50)
	ctx.fillStyle = "#efdcb4"; ctx.font = "bold 13px " + FONT; ctx.textAlign = "left"
	var P = J.G.get("GP"); var tx = J.str(J.mc(P, "hint", [0.0 if ok else o.gpNeed])) if T(P) and T(J.gp(P, "hint")) else ""
	wrapT(tx, 36, y + 230, VW - 72, 18); ctx.textAlign = "center"
	btn("toVillage", VW / 2 - 125, y + 268, 250, 44, "返村升級", "#8a5a14")

func drawDrops() -> void:
	for d in (G.pdrops if T(G.get("pdrops")) else []):
		ctx.save(); ctx.globalAlpha = minf(1.0, J.num(d.life) / 0.6); ctx.translate(J.num(d.x), J.num(d.y)); ctx.rotate(J.num(d.rot)); ctx.lineWidth = 1.5; ctx.strokeStyle = "#1a1418"
		var k = J.str(d.k)
		if k == "cup": ctx.fillStyle = "#e8e2d4"; ctx.fillRect(-4, -5, 8, 9); ctx.strokeRect(-4, -5, 8, 9); ctx.beginPath(); ctx.arc(5, -1, 3, -1.4, 1.4); ctx.stroke()
		elif k == "tile": ctx.fillStyle = "#f2efe2"; ctx.fillRect(-4, -6, 8, 11); ctx.strokeRect(-4, -6, 8, 11); ctx.fillStyle = "#3a8a5a"; ctx.fillRect(-2, -3, 4, 4)
		elif k == "bowl": ctx.fillStyle = "#f0e8d8"; ctx.beginPath(); ctx.arc(0, -2, 6, 0, PI); ctx.closePath(); ctx.fill(); ctx.stroke()
		elif k == "pad": ctx.fillStyle = "#2a2a34"; ctx.fillRect(-7, -3, 14, 7); ctx.strokeRect(-7, -3, 14, 7)
		elif k == "fan": ctx.fillStyle = "#d8c08a"; ctx.beginPath(); ctx.moveTo(0, 4); ctx.arc(0, 4, 10, -2.6, -0.5); ctx.closePath(); ctx.fill(); ctx.stroke()
		else: ctx.fillStyle = "#c89a5a"; ctx.fillRect(-6, -5, 12, 10); ctx.strokeRect(-6, -5, 12, 10)
		ctx.restore()
func drawSafe() -> void:
	if SAFE == null: return
	var on = safeOn(); SAFE["a"] = J.num(SAFE.a) + ((1.0 if on else 0.0) - J.num(SAFE.a)) * 0.06; var A0 = J.num(SAFE.a)
	if A0 < 0.02: return
	var x = J.num(SAFE.x); var y = J.num(SAFE.y); var R = J.num(SAFE.r); var t = J.num(G.t)
	ctx.save(); var gr = ctx.createRadialGradient(x, y - 6, 6, x, y - 6, R)
	gr.addColorStop(0, "rgba(150,95,205," + J.str(0.24 * A0) + ")"); gr.addColorStop(0.65, "rgba(125,75,185," + J.str(0.11 * A0) + ")"); gr.addColorStop(1, "rgba(110,60,170,0)")
	ctx.fillStyle = gr; ctx.beginPath(); ctx.ellipse(x, y - 5, R, 20, 0, 0, 7); ctx.fill()
	for k in 7:
		var u = fmod(t * 8 + k * 13, 46.0) / 46.0; var px = x + sin(t * 0.45 + k * 2.1) * R * 0.78; var py = y - 8 - u * 46
		ctx.fillStyle = "rgba(190,150,235," + J.str((1 - u) * 0.15 * A0) + ")"; ctx.beginPath(); ctx.ellipse(px, py, 18 + (k % 3) * 7, 4.5, 0, 0, 7); ctx.fill()
	ctx.strokeStyle = "rgba(195,160,240," + J.str(0.2 * A0) + ")"; ctx.setLineDash([5, 7]); ctx.lineWidth = 1.5; ctx.beginPath(); ctx.ellipse(x, y - 5, R, 13, 0, 0.08, PI - 0.08); ctx.stroke(); ctx.setLineDash([])
	ctx.globalAlpha = 0.5 * A0; ctx.font = "bold 10px " + FONT; ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = "#120c16"; ctx.strokeText("陰氣地・保安止步", x, y + 14); ctx.fillStyle = "#d6c0f2"; ctx.fillText("陰氣地・保安止步", x, y + 14); ctx.restore()

func crBg() -> void: crPanel(ctx, -8, -8, VW + 16, VH + 16, "paper")
func crPressed(id) -> bool:
	return (ptr != null and J.str(ptr.get("btn")) == J.str(id) and ptr.get("btn") != null) or (PRESS != null and J.str(PRESS.id) == J.str(id) and _now() - J.num(PRESS.t) < 200)
func btn(id, x: float, y: float, w: float, h: float, label, col, on = null) -> void:
	buttons.append({"id": id, "x": x, "y": y, "w": w, "h": h}); crBtn(ctx, x, y, w, h, label, crTone(col), crPressed(id), on is bool and on == false)

func _we() -> Array:
	if not T(G.get("_we")):
		var a = []
		for e in G.edges: if T(e.get("ward")): a.append(e)
		G["_we"] = a
	return G._we

func draw() -> void:
	ctx.setTransform(DPR, 0, 0, DPR, 0, 0); ctx.fillStyle = "#0b0b0d"; ctx.fillRect(0, 0, VW, VH); buttons = []
	if scene == "title": drawTitle(); return
	var nat = T(J.G.get("__twNat")) and ctx is Ctx
	var g = G.gh[_gi()]; var S = J.num(cam.s) * J.num(cam.z); var viewH = (VH - TOP - BOT) / S; var viewW = VW / S
	var fxc = J.num(cam.free.x) if T(cam.free) else J.num(g.x); var fyc = J.num(cam.free.y) if T(cam.free) else J.num(g.y)
	var LB = J.mc(LIFT, "band", []) if (not T(cam.free) and LIFT != null and T(J.gp(LIFT, "band"))) else null
	var ty = (fyc - (J.num(LB.y1) - 14 - TOP) / S) if T(LB) else clamp_(fyc - viewH * 0.55, 0, maxf(0.0, WH - viewH + 70)); var tx = clamp_(fxc - viewW / 2, 0, maxf(0.0, WW - viewW))
	cam["y"] = J.num(cam.y) + (ty - J.num(cam.y)) * 0.15; cam["x"] = J.num(cam.x) + (tx - J.num(cam.x)) * 0.15
	var shk = (randf() - 0.5) * J.num(G.shake) * 16 if n0(G.get("shake")) > 0 else 0.0
	ctx.save(); ctx.translate(shk, TOP); ctx.beginPath(); ctx.rect(0, 0, VW, VH - TOP - BOT); ctx.clip(); ctx.scale(S, S); ctx.translate(-J.num(cam.x), -J.num(cam.y))
	ctx.drawImage(staticCv, 0, 0, WW, WH); CULL["y0"] = J.num(cam.y) - 80; CULL["y1"] = J.num(cam.y) + viewH + 80
	var t = J.num(G.t)
	if nat: TwDraw.units1(ctx, G, CULL, FYS)
	for e in _we(): drawWard(e)
	drawProps2()
	# 回陰間點
	for id in ["f0_e", "f%d_p" % int(FL)]:
		if T(G.get("gate")) and J.str(G.gate.node) != id: continue
		var n = G.nodes[id]; ctx.globalAlpha = 0.5 + 0.3 * sin(t * 2.5); ctx.fillStyle = "#3fbf8f"; ctx.beginPath(); ctx.ellipse(J.num(n.x), J.num(n.y) - 4, 26, 9, 0, 0, 7); ctx.fill(); ctx.globalAlpha = 1
		ctx.fillStyle = "#e2e6e0"; ctx.font = "bold 12px " + FONT; ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = "#0c0c0e"; ctx.strokeText("回陰間", J.num(n.x), J.num(n.y) - 14); ctx.fillText("回陰間", J.num(n.x), J.num(n.y) - 14)
	# 燈泡閃＋冷霧
	if nat: TwDraw.lamps(ctx, G, FYS, int(FL), J.num(cam.y), viewH, WW)
	for w in G.wardFx:
		var a = J.num(w.t) / 0.9; var wx = J.num(w.x); var wy = J.num(w.y); var gr = ctx.createRadialGradient(wx, wy - 30, 4, wx, wy - 30, 60)
		gr.addColorStop(0, "rgba(255,220,140," + J.str(0.7 * a) + ")"); gr.addColorStop(1, "rgba(255,220,140,0)"); ctx.fillStyle = gr; ctx.fillRect(wx - 60, wy - 90, 120, 120)
		ctx.strokeStyle = "rgba(255,230,160," + J.str(a) + ")"; ctx.lineWidth = 2; ctx.beginPath(); ctx.arc(wx, wy - 30, 30 + (1 - a) * 30, 0, 7); ctx.stroke()
	drawTraces(); drawSafe(); drawDrops()
	if nat: TwDraw2.res_all(ctx, G, viewW, viewH, J.num(cam.x), J.num(cam.y))
	if T(G.get("tao")):
		var Tt = G.tao; var tyy = fy(Tt.f); var Tx = J.num(Tt.x)
		for w in Tt.waves:
			ctx.strokeStyle = "rgba(255,215,90," + J.str(J.num(w.t) * 0.85) + ")"; ctx.lineWidth = 4; ctx.beginPath(); ctx.ellipse(Tx, tyy - 30, J.num(w.r), J.num(w.r) * 0.45, 0, 0, 7); ctx.stroke()
		ctx.fillStyle = "rgba(0,0,0,0.45)"; ctx.beginPath(); ctx.ellipse(Tx, tyy - 1, 16, 4, 0, 0, 7); ctx.fill()
		spr("npc_boss", Tx, tyy, 62, {"flip": J.num(Tt.dir) < 0, "oy": -absf(sin(t * 6)) * 2})
		var bx = Tx + J.num(Tt.dir) * 16; var byy = tyy - 40 + sin(t * 14) * 2
		ctx.fillStyle = "#e8b830"; ctx.beginPath(); ctx.moveTo(bx - 6, byy + 8); ctx.quadraticCurveTo(bx, byy - 10, bx + 6, byy + 8); ctx.closePath(); ctx.fill(); ctx.strokeStyle = "#5a3a10"; ctx.lineWidth = 1; ctx.stroke()
		ctx.fillStyle = "#ffe9a0"; ctx.font = "bold 12px " + FONT; ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = "#000"; ctx.strokeText("天師", Tx, tyy - 70); ctx.fillText("天師", Tx, tyy - 70)
		if J.num(Tt.sayT) > 0: bubble(Tx, tyy - 78, Tt.say)
	for o in G.gh:
		if n0(o.get("sealT")) > 0 and not T(o.home):
			ctx.strokeStyle = "rgba(255,215,90,0.7)"; ctx.lineWidth = 2; ctx.beginPath(); ctx.arc(J.num(o.x), J.num(o.y) - J.num(o.d.h) * 0.5, J.num(o.d.h) * 0.55, 0, 7); ctx.stroke()
	if nat: TwDraw2.guards_all(ctx, G, CULL)
	# 房間遮罩
	if nat: TwDraw.mask(ctx, G, CULL, FYS, ITEM)
	if T(G.get("gate")) or J.num(G.gateCharge) > 0:
		var gn = G.nodes[J.str(G.gate.node) if T(G.get("gate")) else J.str(G.gh[int(J.num(G.gateG))].node)]
		var rr2 = (40 + sin(t * 4) * 6) if T(G.get("gate")) else 20 * J.num(G.gateCharge); var gx = J.num(gn.x); var gy = J.num(gn.y)
		var gg = ctx.createRadialGradient(gx, gy - 40, 4, gx, gy - 40, rr2 * 1.8); gg.addColorStop(0, "rgba(120,255,200,0.75)"); gg.addColorStop(1, "rgba(40,120,90,0)")
		ctx.fillStyle = gg; ctx.beginPath(); ctx.arc(gx, gy - 40, rr2 * 1.8, 0, 7); ctx.fill(); ctx.strokeStyle = "rgba(160,255,210,0.8)"; ctx.lineWidth = 3
		for q in 3: ctx.beginPath(); ctx.arc(gx, gy - 40, rr2 * (0.5 + q * 0.3), t * (2 + q), t * (2 + q) + 4); ctx.stroke()
	drawMoves()
	if UNIT != null: J.mc(UNIT, "drawWorld", [ctx])
	_draw_ghosts(t)
	_draw_parts(t)
	if T(G.get("ult")) and J.num(G.ult.t) >= 1.3: _draw_ult_world(t)
	for f in G.floats:
		ctx.globalAlpha = minf(1.0, J.num(f.life)); crText(ctx, f.t, J.num(f.x), J.num(f.y), 14, f.c, "center"); ctx.globalAlpha = 1
	ctx.restore()
	if T(G.get("ult")) and J.num(G.ult.t) < 1.3: _draw_ult_intro()
	if T(J.G.get("__twNat")) and LIFT != null and T(J.gp(LIFT, "drawW")): J.mc(LIFT, "drawW", [])
	var hn = J.G.get("__twHudN")
	if hn != null and T(J.cl(hn, null, [])): drawMini(); hudBtns()
	else: drawHUD()

func _draw_ghosts(t: float) -> void:
	for i in G.gh.size():
		var o = G.gh[i]
		if T(o.home) or T(o.out): continue
		var n = G.nodes[J.str(o.node)]; var inside = J.str(n.kind) == "in" and not T(o.to); var hang = J.str(o.d.key) == "tianhua" and inside
		var a = 0.35 if J.num(o.inv) > 0 else (1.0 if i == _gi() else 0.75)
		if J.num(o.stun) > 0 and not (n0(o.get("countT")) > 0) and not (n0(o.get("dropT")) > 0): a *= 0.6 + 0.4 * sin(t * 30)
		var ox = J.num(o.x); var oyy = J.num(o.y); var dh = J.num(o.d.h); var dir = J.num(o.dir)
		if i == _gi(): ctx.fillStyle = "rgba(110,255,190,0.40)"; ctx.beginPath(); ctx.ellipse(ox, oyy - 2, 24, 6, 0, 0, 7); ctx.fill()
		var TT = t + J.num(o.ph); var k = J.str(o.d.key); var dx = 0.0; var dy = 0.0; var ro = 0.0; var sx = 1.0; var sy = 1.0
		var key = "tianhua_hang" if hang else o.d.sprite; var by = oyy - 50 if hang else oyy
		if n0(o.get("countT")) > 0: sy = 0.8; dy = 3; ro = sin(t * 9) * 0.1
		elif T(o.get("sc")):
			var st = J.num(o.sc.t)
			if st < OMEN:
				var c = st / OMEN; sx = 1 - 0.08 * c + 0.03 * sin(t * 20); sy = sx
				ctx.fillStyle = {"eking": "rgba(210,90,40,", "toyol": "rgba(120,220,140,", "tianhua": "rgba(110,190,255,"}[k] + J.str(0.25 * c) + ")"; ctx.beginPath(); ctx.arc(ox, by - dh * 0.5, dh * 0.6 * (0.6 + 0.4 * c), 0, 7); ctx.fill()
			elif st < OMEN + STRIKE:
				if k == "eking": sx = 1.18 + 0.06 * sin(t * 30); sy = 0.92; ro = dir * 0.1
				else: a *= 0.25
			else: a *= 1.0 if k == "eking" else minf(1.0, 0.25 + (st - OMEN - STRIKE) / AFTER)
		elif J.num(o.hitT) > 0:
			var h = J.num(o.hitT) / 0.8; var hd = J.num(o.get("hitDir")) if T(o.get("hitDir")) else 1.0
			dx = -hd * (1 - h) * 0 + hd * h * 14; ro = hd * 0.25 * h; a *= 0.5 + 0.5 * absf(sin(t * 35))
		elif J.num(o.actT) > 0:
			var q = 1 - J.num(o.actT) / 0.9
			if q < 0.3:
				var c = q / 0.3; sx = 1 - 0.12 * c; sy = sx; dy = 2 * c; ro = -dir * 0.12 * c
				ctx.fillStyle = "rgba(200,30,30," + J.str(0.35 * c) + ")"; ctx.beginPath(); ctx.arc(ox, by - dh * 0.5, dh * 0.7, 0, 7); ctx.fill()
			elif q < 0.6:
				var c = (q - 0.3) / 0.3; sx = 0.88 + 0.55 * c; sy = sx; dx = dir * 26 * c; ro = dir * 0.15 * c
				if k == "tianhua": dy = -6 * c
			else:
				var c = (q - 0.6) / 0.4; sx = 1.43 - 0.43 * c; sy = sx; dx = dir * 26 * (1 - c)
			if q > 0.3 and q < 0.75 and k == "tianhua":
				ctx.strokeStyle = "rgba(20,20,24,0.85)"; ctx.lineWidth = 2
				for hs in 9:
					var hx = ox + dir * (10 + hs * 5); ctx.beginPath(); ctx.moveTo(hx, by - dh); ctx.quadraticCurveTo(hx + sin(t * 9 + hs) * 6, by - dh * 0.4, hx + sin(t * 7 + hs) * 4, by + 4); ctx.stroke()
		elif J.num(o.taskP) > 0:
			if k == "eking": sy = 1 + 0.09 * sin(t * 18); sx = 1 - 0.05 * sin(t * 18)
			elif k == "toyol": ro = sin(t * 20) * 0.14; dy = -absf(sin(t * 10)) * 3
			else: ro = sin(t * 5) * 0.08
			if k == "tianhua":
				ctx.strokeStyle = "rgba(30,30,34,0.8)"; ctx.lineWidth = 1.5
				for hs in 6:
					var hx = ox - 8 + hs * 3; ctx.beginPath(); ctx.moveTo(hx, by - dh * 0.2); ctx.lineTo(hx + sin(t * 4 + hs) * 3, by + 16 + hs % 2 * 6); ctx.stroke()
		elif J.num(o.mv) > 0:
			if k == "eking": ro = sin(TT * 8) * 0.08; dy = -absf(sin(TT * 8)) * 2; var bp = sin(TT * 9); sx = 1 + 0.08 * bp; sy = 1 - 0.035 * bp
			elif k == "toyol":
				dy = -absf(sin(TT * 15)) * 7; ro = sin(TT * 15) * 0.13
				if n0(o.get("flipT")) > 0:
					var fq = 1 - J.num(o.flipT) / 0.55; ro = dir * PI * 2 * fq; dy = -sin(fq * PI) * 22 - dh * 0.3 * sin(fq * PI)
			else:
				var na = G.nodes[J.str(o.node)]; var nb = G.nodes[J.str(o.to)] if T(o.to) else na
				if J.num(na.f) == J.num(nb.f) and J.str(na.kind) != "in" and J.str(nb.kind) != "in": by = fy(J.num(na.f) + 1) + 14; sy = -1; ro = sin(TT * 10) * 0.06; dx = sin(TT * 10) * 2
				else: ro = dir * 0.12; dy = -4 + sin(TT * 6) * 3
		else:
			dy = sin(TT * 2.5) * 3 - (0.0 if k == "eking" else 3.0); sy = 1 + 0.025 * sin(TT * 2.5)
		if J.num(o.bounceT) > 0: dx += -dir * sin(J.num(o.bounceT) / 0.45 * PI) * 12
		if k == "tianhua":
			var na2 = G.nodes[J.str(o.node)]; var nb2 = G.nodes[J.str(o.to)] if T(o.to) else na2; var ceil2 = fy(minf(FL, J.num(na2.f) + 1)) + 14; var flo2 = oyy
			if n0(o.get("dropT")) > 0:
				key = o.d.sprite; var dq = J.num(o.dropT)
				if dq > 2.05: var u2 = (2.3 - dq) / 0.25; by = ceil2 + (flo2 - ceil2) * u2; sy = 1; sx = 1; ro = PI * (1 - u2); dy = 0; dx = 0
				elif dq < 0.5: var u3 = 1 - dq / 0.5; by = flo2 - (flo2 - ceil2) * u3; sy = 1; sx = 1; ro = 0; dx = sin(t * 30) * 1.5
				else:
					by = flo2; sy = 1; sx = 1; ro = dir * 0.24 + sin(t * 3) * 0.03; dx = 0; dy = 0
					if dq > 0.8:
						ctx.strokeStyle = "rgba(255,230,160,0.8)"; ctx.lineWidth = 2
						for w2 in 3: ctx.beginPath(); ctx.arc(ox - dir * 10, flo2 - dh * 0.42, 6 + w2 * 5 + fmod(t * 16, 5.0), PI * 0.6, PI * 1.4); ctx.stroke()
			elif not hang:
				if J.num(na2.f) != J.num(nb2.f):
					var down = J.num(nb2.f) < J.num(na2.f); by = oyy - (0.0 if down else 6.0); ro = PI if down else 0.0; dx = dir * 14 + sin(t * 14) * 2
					if down: by = oyy - dh * 0.9
					sx = sx * 0.95; sy = absf(sy)
				else: by = ceil2; sy = -absf(sy if sy != 0 else 1.0); dy = dy * 0.4
		if k == "eking": sx *= 1 + n0(o.get("fat"))
		drawTaskProps(o, by)
		if n0(o.get("countT")) > 0:
			var cy0 = oyy - dh - 8; var fa = minf(1.0, n0(o.get("cntAcc")) / 0.32); var cn = int(n0(o.get("cntN")))
			if cn > 0: ctx.globalAlpha = 1 - fa; txt(COUNT[(cn - 1) % 10], ox + 10, cy0 - fa * 14, "#b8f0a0", 13); ctx.globalAlpha = 1
			ctx.globalAlpha = fa; txt(COUNT[cn % 10] + "……", ox + 10, cy0 + 6 - fa * 6, "#d8ffc0", 16); ctx.globalAlpha = 1
		spr(key, ox, by, dh, {"flip": dir < 0, "alpha": a, "ox": dx, "oy": dy, "rot": ro, "sx": sx, "sy": sy})
		if i == _gi() and not T(o.to) and J.num(o.still) >= 0.1 and J.num(o.mv) <= 0:
			ctx.strokeStyle = "rgba(138,255,200,0.55)"; ctx.setLineDash([4, 4]); ctx.beginPath(); ctx.ellipse(ox, oyy - 2, 30, 8, 0, 0, 7); ctx.stroke(); ctx.setLineDash([])
		if J.num(o.taskP) > 0:
			ctx.strokeStyle = "#8affc8"; ctx.lineWidth = 4; ctx.beginPath(); ctx.arc(ox, oyy - dh - 14, 10, -PI / 2, -PI / 2 + PI * 2 * J.num(o.taskP)); ctx.stroke()

func _draw_parts(t: float) -> void:
	for p in G.parts:
		var a = J.num(p.life) / J.num(p.max); ctx.globalAlpha = minf(1.0, a * 1.4); var px = J.num(p.x); var py = J.num(p.y); var ty = J.str(p.type)
		if ty == "coin": ctx.fillStyle = "#ffd54a"; ctx.beginPath(); ctx.ellipse(px, py, 4, 4 * absf(sin(t * 12 + px)), 0, 0, 7); ctx.fill()
		elif ty == "crumb": ctx.fillStyle = "#e8c07a"; ctx.fillRect(px, py, 3, 3)
		elif ty == "sweat": ctx.fillStyle = "#9fe0ff"; ctx.beginPath(); ctx.arc(px, py, 2.5, 0, 7); ctx.fill()
		elif ty == "tear": ctx.fillStyle = "#bfeaff"; ctx.strokeStyle = "#2a4a5a"; ctx.lineWidth = 0.8; ctx.beginPath(); ctx.moveTo(px, py - 4.5); ctx.quadraticCurveTo(px + 3.2, py, px, py + 2.6); ctx.quadraticCurveTo(px - 3.2, py, px, py - 4.5); ctx.fill(); ctx.stroke()
		elif ty == "hair": ctx.strokeStyle = "#222"; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(px, py); ctx.lineTo(px + 3, py + 9); ctx.stroke()
		elif ty == "smoke": ctx.fillStyle = "rgba(200,210,205,0.5)"; ctx.beginPath(); ctx.arc(px, py, 4 + (1 - a) * 10, 0, 7); ctx.fill()
		elif ty == "dust": ctx.fillStyle = "rgba(180,170,150,0.5)"; ctx.beginPath(); ctx.arc(px, py, 3 + (1 - a) * 5, 0, 7); ctx.fill()
		elif ty == "drip": ctx.fillStyle = "#9fe0ff"; ctx.beginPath(); ctx.ellipse(px, py, 1.6, 3, 0, 0, 7); ctx.fill()
		elif ty == "note": ctx.fillStyle = "#9cc89c"; ctx.save(); ctx.translate(px, py); ctx.rotate(t * 8 + J.num(p.vx)); ctx.fillRect(-5, -3, 10, 6); ctx.restore()
		elif ty == "suck": ctx.fillStyle = "#d24a3a"; ctx.beginPath(); ctx.arc(px, py, 3, 0, 7); ctx.fill()
		ctx.globalAlpha = 1

func _draw_ult_world(t: float) -> void:
	var U = G.ult; var uf = J.num(U.f); var ut = J.num(U.t) - 1.3; var top = fy(minf(FL, uf + 1)) + 8; var bot = fy(uf); var gk = J.str(U.g.d.key); var gx = J.num(U.g.x)
	if gk == "toyol" and T(U.get("clones")):
		for j in U.clones.size():
			var c = U.clones[j]; c["x"] = J.num(c.x) + J.num(c.v) * 0.033
			if J.num(c.x) < 60 or J.num(c.x) > WW - 60: c["v"] = J.num(c.v) * -1
			spr("toyol", J.num(c.x), bot, 40, {"flip": J.num(c.v) < 0, "alpha": 0.75, "oy": -absf(sin(t * 14 + j)) * 8})
			if randf() < 0.3: part(J.num(c.x), bot - 20, (randf() - 0.5) * 60, -80, 0.6, "coin")
	if gk == "tianhua":
		ctx.strokeStyle = "rgba(12,12,14,0.9)"; ctx.lineWidth = 2.2; var len = minf(1.0, ut * 1.6) * (bot - top); var spread = minf(300.0, ut * 190)
		if spread < 300: txt("頭髮沿走廊爬去隔籬屋……", gx, top + 18, "#9fe0ff", 13)
		var hx = maxf(60.0, gx - spread)
		while hx < minf(WW - 55, gx + spread):
			ctx.beginPath(); ctx.moveTo(hx, top); ctx.quadraticCurveTo(hx + sin(t * 3 + hx) * 10, top + len * 0.5, hx + sin(t * 2 + hx * 0.3) * 8, top + len); ctx.stroke(); hx += 7
	if gk == "eking":
		var R0 = minf(1.0, ut * 1.5) * ((bot - top) * 0.46); var cy = (top + bot) / 2 + 6
		ctx.save(); ctx.beginPath(); ctx.rect(0, top, WW, bot - top); ctx.clip(); ctx.fillStyle = "rgba(0,0,0,0.55)"; ctx.fillRect(0, top, WW, bot - top); drawMouth(gx, cy, R0, 0.3 + 0.7 * absf(sin(ut * 5)), 1); ctx.restore()
		if ut < 1.6: txt("開飯喇……", gx, top + 16, "#ffb7a0", 13)

func _draw_ult_intro() -> void:
	var t = J.num(G.ult.t); var gk = G.ult.g.d; var ea = minf(1.0, t * 4) * (((1.3 - t) / 0.2) if t > 1.1 else 1.0)
	ctx.fillStyle = "rgba(0,0,0," + J.str(0.7 * ea) + ")"; ctx.fillRect(0, 0, VW, VH)
	var bx = VW * (1 - t / 0.25) if t < 0.25 else 0.0; var by = VH * 0.36
	ctx.save(); ctx.translate(bx, 0); ctx.fillStyle = "rgba(110,20,20,0.92)"; ctx.beginPath(); ctx.moveTo(0, by); ctx.lineTo(VW, by - 30); ctx.lineTo(VW, by + 120); ctx.lineTo(0, by + 150); ctx.closePath(); ctx.fill()
	ctx.strokeStyle = "#e8d0a0"; ctx.lineWidth = 3; ctx.stroke()
	for q in 14:
		ctx.strokeStyle = "rgba(255,220,180,0.25)"; ctx.beginPath(); var yy = by + fmod(q * 37 + t * 900, 150.0); ctx.moveTo(0, yy); ctx.lineTo(VW, yy - 30); ctx.stroke()
	spr(gk.sprite, VW * 0.27 + sin(t * 20) * 2, by + 148, 190, {"sx": 1 + 0.04 * sin(t * 12)})
	var U = ULT[J.str(gk.key)]
	ctx.fillStyle = "#ffe9c0"; ctx.strokeStyle = "#000"; ctx.lineWidth = 5; ctx.font = "bold 40px " + FONT; ctx.textAlign = "left"; ctx.strokeText(U.n, VW * 0.5, by + 58); ctx.fillText(U.n, VW * 0.5, by + 58)
	ctx.font = "bold 14px " + FONT; ctx.lineWidth = 3; ctx.strokeText(U.d, VW * 0.5 - 20, by + 92, VW * 0.52); ctx.fillText(U.d, VW * 0.5 - 20, by + 92, VW * 0.52); ctx.restore()

func drawHUD() -> void:
	crPanel(ctx, -8, -8, VW + 16, TOP + 8, "paper")
	var fr = minf(1.0, J.num(G.t) / (PHT * 3))
	crBar(ctx, 12, 8, VW - 24, 15, fr, "dawn")
	var ph = int(J.num(G.phase))
	var s1 = ("陰門死守 " + J.str(ceil(30 - J.num(G.gate.t))) + " 秒　") if T(G.get("gate")) else ""
	s1 += (J.str(PH[ph]) + "　天光 " + J.str(floor(fr * 100)) + "%") if ph < 3 else ("天光後・追兵第 " + J.str(G.wave) + " 輪")
	crText(ctx, s1 + "　警覺 " + J.str(G.alert), 14, 44, 15, "#e8b4a0" if J.num(G.alert) >= 3 else "#efe5cf", "left", VW - 110)
	crText(ctx, "怕意 " + J.str(G.fear), VW - 14, 44, 15, "#b2d394", "right")
	crText(ctx, "收穫 " + J.str(G.bag.size()) + "/" + J.str(BAGMAX) + "　紙人 " + J.str(G.dolls) + "/6　匙 紅" + J.str(n0(G.keys.get("key"))) + " 黃" + J.str(n0(G.keys.get("key2"))) + ("　帶住失物" if T(G.get("carry")) else ""), 14, 68, 13, "#cfc4b0", "left", VW - 118)
	btn("story", VW - 100, 48, 90, 44, "故事 " + J.str(G.story.size()) + "/" + J.str(STORY.size()), "#2e3a34")
	if not HUDC: drawMini()
	if T(cam.free): btn("follow", VW / 2 - 66, TOP + 8, 132, 46, "◎ 跟返隻鬼", "#2f5a4a")
	btn("quit", 10, TOP + 8, 62, 46, "離開", "#2c2c33"); btn("zin", VW - 56, TOP + 8, 46, 46, "＋", "#24242a"); btn("zout", VW - 56, TOP + 60, 46, 46, "－", "#24242a")
	var y0 = VH - BOT; crPanel(ctx, -8, y0, VW + 16, BOT + 8, "paper")
	if J.num(G.toastT) > 0 and T(G.get("toast")):
		crPanel(ctx, 10, y0 - 58, VW - 20, 52, "sheet"); ctx.fillStyle = "#efdcb4"; ctx.font = "bold 13px " + FONT; ctx.textAlign = "left"; wrapT(J.str(G.toast), 20, y0 - 37, VW - 40, 17)
	for i in G.gh.size():
		var o = G.gh[i]; var x = 10.0 + i * 72; var y = y0 + 12; var full = J.num(o.energy) >= 100 and not T(o.home); var act = i == _gi()
		buttons.append({"id": "gh" + str(i), "x": x, "y": y, "w": 64.0, "h": 74.0}); var pz = crPressed("gh" + str(i)); var dy = 2.0 if pz else 0.0
		if full: ctx.save(); ctx.globalAlpha = 0.45 + 0.35 * sin(J.num(G.t) * 8); crBlit(ctx, crGet(72, 82, "rust", "panel"), x - 4, y - 4 + dy); ctx.restore()
		crBlit(ctx, crGet(64, 74, "rust" if full else ("moss" if act else "ink"), "p" if pz else "n"), x, y + dy)
		sprite(o.d.sprite, x + 32, y + 58 + dy, 46, false, 0.3 if (T(o.home) or T(o.out)) else 1.0)
		crBar(ctx, x + 6, y + 5 + dy, 52, 6, J.num(o.energy) / 100, "rust" if full else "red")
		if full: crText(ctx, "點我放大招", x + 32, y + 24 + dy, 11, "#f6dcb6", "center", 60)
		var nm = "被收服" if T(o.out) else ("已返" if T(o.home) else J.str(o.d.name) + ((" " + J.str(o.caught) + "/3") if T(o.get("caught")) else ""))
		crText(ctx, nm, x + 32, y + 69 + dy, 12, "#e4ecd2" if act else "#ebe3d6", "center", 60); gpBadge(o, x, y + dy)
	var g = G.gh[_gi()]; var n = G.nodes[J.str(g.node)]; var atP = not T(g.to) and J.str(n.kind) == "portal" and not T(g.home)
	btn("scare", VW - 170, y0 + 12, 74, 52, "嚇！", "#6e1c1c")
	btn("inv", VW - 88, y0 + 12, 76, 52, ("隱身 " + J.str(ceil(J.num(g.invCd)))) if J.num(g.invCd) > 0 else "隱身", "#2a4a7a", J.num(g.invCd) <= 0)
	var A = ctxAction(g); var U = J.num(g.energy) >= 100 and not T(g.home) and not T(g.out) and not T(G.get("ult")); var aw = (VW - 30) / 2 if U else VW - 20
	if T(A): btn("act", 10, y0 + 92, aw, 46, A.t, "#3a3a40" if J.str(A.k) == "respect" else "#3a5a2a", J.str(A.k) != "respect")
	elif not U: crText(ctx, "撳住戶＝行過去嚇；企喺電器、水管、𨋢口、樓梯口出「互動」", VW / 2, y0 + 120, 12, "#9a8e92", "center", VW - 20, false, "normal")
	if U: btn("ult", (20 + aw) if T(A) else 10.0, y0 + 92, aw if T(A) else VW - 20, 46, "放大招：" + J.str(ULT[J.str(g.d.key)].n), "#8a5a14")
	var hw = (VW - 30) / 2
	btn("gate", 10, y0 + 146, hw, 44, ("陰門 " + J.str(ceil(30 - J.num(G.gate.t))) + "s") if T(G.get("gate")) else ("開陰門（企定）" if atP else "陰門：天台/地庫"), "#2f5a4a", atP and not T(G.get("gate")))
	btn("doll", 20 + hw, y0 + 146, hw, 44, "替身遁走 " + J.str(G.dolls) + "/6", "#5a1c1c", J.num(G.dolls) >= 6 and not T(G.get("gate")))
	crText(ctx, "拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅", VW / 2, VH - 12, 12, "#9a8e92", "center", VW - 16, false, "normal")
	if T(G.get("choice")): drawChoice()
	if T(G.get("showStory")): drawStory()
	if T(G.get("over")): drawOver()

func wrapT(t, x: float, y: float, w: float, lh: float) -> float:
	var s = J.str(t); var ln = ""; var yy = y
	for i in s.length():
		var tt = ln + s[i]
		if J.num(ctx.measureText(tt).width) > w: crFill(ln, x, yy); ln = s[i]; yy += lh
		else: ln = tt
	crFill(ln, x, yy); return yy
func panel(h: float) -> float:
	ctx.fillStyle = "rgba(6,3,8,0.78)"; ctx.fillRect(0, 0, VW, VH); var y = (VH - h) / 2; crPanel(ctx, 16, y, VW - 32, h, "sheet"); buttons = []; return y
func drawChoice() -> void:
	var h = 330.0; var y = VH - h - 8; ctx.fillStyle = "rgba(6,3,8,0.45)"; ctx.fillRect(0, 0, VW, VH); crPanel(ctx, 10, y, VW - 20, h, "sheet"); buttons = []
	ctx.fillStyle = "#fff"; ctx.font = "bold 19px " + FONT; ctx.textAlign = "center"; crFill("怕意滿咗！揀一樣強化", VW / 2, y + 36)
	for i in G.choice.size():
		var c = G.choice[i]; var by = y + 52 + i * 88; btn("card" + str(i), 26, by, VW - 52, 78, "", "#26262c")
		ctx.fillStyle = "#ffd54a"; ctx.font = "bold 18px " + FONT; crFill(c.t, VW / 2, by + 32, VW - 70); ctx.fillStyle = "#d6dad2"; ctx.font = "bold 14px " + FONT; crFill(c.d, VW / 2, by + 58, VW - 70)
func drawStory() -> void:
	var H0 = minf(VH - 40, 620.0); var y = panel(H0); ctx.fillStyle = "#fff"; ctx.font = "bold 18px " + FONT; ctx.textAlign = "center"
	crFill(J.str(LV.name) + "嘅故事（" + J.str(G.story.size()) + "/" + J.str(STORY.size()) + "）", VW / 2, y + 34); ctx.textAlign = "left"; ctx.font = "13px " + FONT; var yy = y + 60
	for f in STORY.size():
		var got = idx_of(G.story, float(f)) >= 0
		ctx.fillStyle = "#ecece6" if got else "#5a5e58"; yy = wrapT(STORY[f] if got else J.str(LV.hint[f]) + "：？？？（嚇走「✦故事」戶或者完成支線）", 28, yy, VW - 56, 16) + 22
	if G.story.size() == STORY.size(): ctx.fillStyle = "#ffd54a"; yy = wrapT(TRUTH, 28, yy, VW - 56, 16) + 24
	ctx.fillStyle = "#9fd6bf"; ctx.font = "bold 13px " + FONT; crFill("支線", 28, yy); yy += 20; ctx.font = "12px " + FONT
	for q in (G.quests if T(G.get("quests")) else []):
		var stt = J.num(q.state); ctx.fillStyle = "#8affc8" if stt == 2 else "#d8d8d0"
		yy = wrapT(("✓ " if stt == 2 else "・") + J.str(q.t) + ("（遲啲先出現）" if J.str(q.id) == "debt" and stt == 0 else ""), 28, yy, VW - 56, 16) + 20
	btn("closeStory", VW / 2 - 60, y + H0 - 56, 120, 46, "返去", "#5a1c1c")
func drawOver() -> void:
	var o = G.over; var y = panel(420); ctx.textAlign = "center"; ctx.fillStyle = "#8affc8" if T(o.ok) else "#ff9a9a"; ctx.font = "bold 26px " + FONT
	var why = J.str(o.why)
	crFill("陰門撤離成功！" if why == "gate" else ("替身遁走！" if why == "doll" else "被圍收服……"), VW / 2, y + 44); ctx.fillStyle = "#fff"; ctx.font = "bold 15px " + FONT
	var msg
	if why == "gate": msg = ["返到陰間嘅鬼：" + J.str(o.home) + " 隻", "帶走全部收穫：" + J.str(o.kept) + " 件", "收服故事碎片：" + J.str(o.story) + "/" + J.str(STORY.size()), "今晚怕意總共：" + J.str(o.fear), "全樓警覺：" + J.str(o.alert)]
	elif why == "doll": msg = ["用替身紙人遁走：" + J.str(o.home) + " 隻鬼", "帶走一半收穫：" + J.str(o.kept) + " 件（留低 " + J.str(o.lost) + " 件）", "故事碎片冇得帶走（" + J.str(o.storyLost) + " 塊留咗喺樓入面）", "今晚怕意總共：" + J.str(o.fear)]
	else: msg = ["三隻鬼全部畀人收服", "收穫全部冇晒：" + J.str(o.lost) + " 件", "今晚怕意總共：" + J.str(o.fear), "全樓警覺：" + J.str(o.alert)]
	for i in msg.size(): crFill(msg[i], VW / 2, y + 90 + i * 30, VW - 50)
	if J.num(o.story) == STORY.size(): ctx.fillStyle = "#ffd54a"; ctx.font = "bold 13px " + FONT; ctx.textAlign = "left"; wrapT(TRUTH, 36, y + 250, VW - 72, 18)
	if not T(o.ok): gpOver(o, y)
	btn("again", VW / 2 - 130, y + 420 - 60, 120, 44, "再嚟一晚", "#5a1c1c"); btn("toMap", VW / 2 + 10, y + 420 - 60, 120, 44, "返地圖", "#2c2c33")
	if o.get("reward") != null: crText(ctx, "收到冥幣 +" + J.str(o.reward), VW / 2, y + 420 - 76, 17, "#e6a85a", "center")
func crTitleDeco() -> void:
	var r = crRnd(5); var y = VH * 0.24 + 52; ctx.save(); ctx.strokeStyle = "#7a2522"; ctx.lineCap = "round"
	for p in 3:
		ctx.globalAlpha = 0.5 + r.call() * 0.4; ctx.lineWidth = 2.4 - p * 0.5; ctx.beginPath(); ctx.moveTo(VW * 0.2 + r.call() * 6, y + r.call() * 3)
		for k in range(1, 9): ctx.lineTo(VW * 0.2 + VW * 0.6 * k / 8, y + (r.call() - 0.5) * 4)
		ctx.stroke()
	ctx.restore(); crPanel(ctx, 14, VH * 0.62 - 24, VW - 28, 5 * 24 + 14, "ink")
func drawTitle() -> void:
	crBg(); crTitleDeco(); btn("exit", 12, 14, 104, 46, "◀ 返地圖", "#2c2c33"); ctx.textAlign = "center"; ctx.fillStyle = "#c4493c"; ctx.font = "bold 40px " + FONT; crFill("樓裡有鬼", VW / 2, VH * 0.24)
	ctx.font = "bold 16px " + FONT; ctx.fillStyle = "#d8ccb0"; crFill("揀一棟樓・天光前返陰間", VW / 2, VH * 0.24 + 36)
	for i in GH.size(): sprite(GH[i].sprite, VW / 2 + (i - 1) * 100, VH * 0.52, J.num(GH[i].h) * 1.5)
	ctx.fillStyle = "#c8ccc4"; ctx.font = "bold 14px " + FONT
	var tl = ["三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。", "成棟樓幾十戶人：打機、返夜更、打麻雀、網購……", "保安唔係捉鬼師傅：附身電器、敲水管、叫𨋢引開佢。", "有紅紙符、門神、拿督公、祖先牌位要尊重，繞路行。", "子時→丑時→寅時，天光前由地庫或天台陰門返陰間。"]
	for i in tl.size(): crFill(tl[i], VW / 2, VH * 0.62 + i * 24, VW - 30)
	var sv = TS(); var shopOpen = T(sv.cleared.get("flat")) or T(J.gp(_w(), "STN_TEST"))
	btn("lv_flat", 22, VH * 0.80, (VW - 56) / 2, 58, "組屋" + (" ✓" if T(sv.cleared.get("flat")) else ""), "#5a1c1c")
	btn("lv_shop", 34 + (VW - 56) / 2, VH * 0.80, (VW - 56) / 2, 58, ("老店屋" + (" ✓" if T(sv.cleared.get("shop")) else "")) if shopOpen else "老店屋（未解鎖）", "#2f5a4a", shopOpen)
	ctx.fillStyle = "#7a7f78"; ctx.font = "bold 13px " + FONT; ctx.textAlign = "center"
	crFill("揀一棟樓開始今晚" if shopOpen else "組屋過關（安全返陰間）就解鎖老店屋", VW / 2, VH * 0.80 + (100.0 if T(J.G.get("GP")) else 78.0)); gpTitle()

# ---------------- 輸入 ----------------
func settleNear(g, R0: float) -> void:
	if not T(g) or not T(g.to) or T(g.home) or T(g.out): return
	var a = G.nodes[J.str(g.node)]; var b = G.nodes[J.str(g.to)]; var E = hyp(J.num(b.x) - J.num(a.x), J.num(b.y) - J.num(a.y))
	if E * (1 - J.num(g.p)) <= R0: g["auto"] = [g.to]
	elif E * J.num(g.p) <= R0: var t = g.node; g["node"] = g.to; g["to"] = t; g["p"] = 1 - J.num(g.p); g["auto"] = [t]
func pt(e) -> Dictionary:
	if J.gp(e, "nx") != null: return {"x": J.num(J.gp(e, "nx")), "y": J.num(J.gp(e, "ny"))}
	var r = J.mc(cv, "getBoundingClientRect", []); return {"x": J.num(J.gp(e, "clientX")) - J.num(J.gp(r, "left")), "y": J.num(J.gp(e, "clientY")) - J.num(J.gp(r, "top"))}
func joyVec():
	if joy == null or not T(joy.on): return null
	var dx = J.num(joy.x) - J.num(joy.ox); var dy = J.num(joy.y) - J.num(joy.oy); var L = hyp(dx, dy)
	if L > JR: dx *= JR / L; dy *= JR / L
	return {"x": dx / JR, "y": dy / JR}
func drawJoy() -> void:
	if joy == null or not T(joy.on): return
	var v = joyVec(); ctx.setTransform(DPR, 0, 0, DPR, 0, 0); ctx.save(); ctx.globalAlpha = 0.7; crBlit(ctx, crGet(JR * 2, JR * 2, "paper", "ring"), J.num(joy.ox) - JR, J.num(joy.oy) - JR)
	ctx.globalAlpha = 0.92; crBlit(ctx, crGet(48, 48, "bone", "ring2"), J.num(joy.ox) + v.x * JR - 24, J.num(joy.oy) + v.y * JR - 24); ctx.restore()
func hitBtn(x: float, y: float):
	var best = null; var bd = 1e9
	var i = buttons.size() - 1
	while i >= 0:
		var b = buttons[i]; var bx = J.num(b.x); var by = J.num(b.y); var bw = J.num(b.w); var bh = J.num(b.h)
		if x >= bx - PAD and x <= bx + bw + PAD and y >= by - PAD and y <= by + bh + PAD:
			var d = -1.0 if (x >= bx and x <= bx + bw and y >= by and y <= by + bh) else hyp(x - (bx + bw / 2), y - (by + bh / 2))
			if d < bd: bd = d; best = b
		i -= 1
	return best
func tap(x: float, y: float) -> void:
	LASTP = {"x": x, "y": y}; var b = hitBtn(x, y)
	if b != null: press(J.str(b.id)); return
	if scene == "play" and T(G) and not T(G.over) and not T(G.choice) and not T(G.get("showStory")) and y > TOP and y < VH - BOT: worldTap(x, y)
func worldTap(x: float, y: float) -> void:
	var S = J.num(cam.s) * J.num(cam.z); var wx = x / S + J.num(cam.x); var wy = (y - TOP) / S + J.num(cam.y); var best = null; var bd = 40.0
	if UNIT != null and T(J.mc(UNIT, "worldTap", [wx, wy])): return
	var gb = null; var gbd = 26.0
	for i in G.gh.size():
		var g0 = G.gh[i]
		if T(g0.home) or T(g0.out) or i == _gi(): continue
		var d = hyp(J.num(g0.x) - wx, (J.num(g0.y) - J.num(g0.d.h) * 0.5) - wy)
		if d < gbd: gbd = d; gb = {"g": i}
	for r in G.res:
		if J.str(r.state) != "home": continue
		var d = hyp(J.num(r.x) - wx, (J.num(r.y) - 26) - wy)
		if d < bd: bd = d; best = {"r": r}
	for h in G.guards:
		if J.str(h.state) == "gone" or J.str(h.state) == "flee": continue
		var d = hyp(J.num(h.x) - wx, (J.num(h.y) - 30) - wy)
		if d < bd: bd = d; best = {"h": h}
	if best == null and gb != null: best = gb
	var g = G.gh[_gi()]
	if best == null:
		var nn = null; var nd = 1e9
		for k in G.nodes:
			var n = G.nodes[k]; var d = absf(J.num(n.x) - wx) + absf((J.num(n.y) - 30) - wy) * 1.6
			if d < nd: nd = d; nn = k
		if nn != null and nd < 120:
			if T(gotoNode(g, nn)): g["autoS"] = null; float_(J.num(G.nodes[nn].x), J.num(G.nodes[nn].y) - 70, "去呢度", "#9fd6bf")
			else: float_(wx, wy, "去唔到", "#ffb0b0")
		return
	if best.has("g"): G["active"] = float(best.g); cam["free"] = null; return
	if best.has("r"):
		var br = best.r; var un = br.unit
		if not T(un.open) and J.num(un.get("ot")) != 1: float_(J.num(br.x), J.num(br.y) - 80, "呢戶未入得", "#ffd54a"); return
		if J.str(g.node) == J.str(un.id) and not T(g.to): g["still"] = maxf(J.num(g.still), 0.11); scarePress(); return
		if T(gotoNode(g, un.id)): g["autoS"] = {"r": br}; float_(J.num(br.x), J.num(br.y) - 86, "目標：" + (J.str(HH[J.str(br.hh)].n) if HH.has(J.str(br.hh)) else "住戶"), "#ffb7a0")
		else: float_(J.num(br.x), J.num(br.y) - 80, "去唔到（要先開門／破鎮宅）", "#ffb0b0")
		return
	if best.has("h"):
		var bh = best.h; var hn = bh.to if (T(bh.to) and absf(J.num(G.nodes[J.str(bh.to)].x) - J.num(bh.x)) < absf(J.num(G.nodes[J.str(bh.node)].x) - J.num(bh.x))) else bh.node
		if T(gotoNode(g, hn)): g["autoS"] = {"h": bh}; float_(J.num(bh.x), J.num(bh.y) - 90, "目標：" + J.str(HUM[J.str(bh.kind)].n), "#ffb7a0")
func press(id: String) -> void:
	if id == "lv_flat" or id == "start": newGame(null, "flat"); bake(); return
	if id == "exit": close(); return
	if id == "quit": scene = "title"; return
	if id == "lv_shop":
		var sv = TS()
		if T(sv.cleared.get("flat")) or T(J.gp(_w(), "STN_TEST")): newGame(null, "shop"); bake()
		return
	if id == "again": newGame(null, null); bake(); return
	if id == "toVillage": gpGoVillage(); return
	if id == "title": scene = "title"; return
	if id == "toMap": close(); return
	if scene != "play": return
	if id.begins_with("card"): chooseCard(int(id.substr(4))); return
	if id == "zin": cam["z"] = minf(1.5, J.num(cam.z) * 1.25); return
	if id == "zout": cam["z"] = maxf(0.5, J.num(cam.z) / 1.25); return
	if id == "mini": miniJump(); return
	if id == "follow": cam["free"] = null; return
	if id == "act": actPress(); return
	if id == "ult": ultPress(G.active); return
	if id == "story": G["showStory"] = true; return
	if id == "closeStory": G["showStory"] = false; return
	if T(G.over) or T(G.choice) or T(G.get("showStory")): return
	if id.begins_with("gh"):
		cam["free"] = null; var i = int(id.substr(2))
		if T(G.gh[i].home): return
		if i == _gi() and J.num(G.gh[i].energy) >= 100: ultPress(i); return
		G["active"] = float(i); toast(GP_TRAINEE_MSG if T(G.gh[i].get("trainee")) else J.str(GH[i].tip) + ("（能量滿！再點頭像放大招）" if J.num(G.gh[i].energy) >= 100 else "")); return
	if id == "scare": scarePress()
	if id == "inv": invPress()
	if id == "gate": gatePress()
	if id == "doll": dollEscape()

func on_pd(e) -> void:
	if T(J.gp(e, "isPrimary")): pts = {}
	var p = pt(e); var pid = J.str(J.gp(e, "pointerId")); pts[pid] = p; var hb = hitBtn(p.x, p.y)
	if hb != null:
		PRESS = {"id": hb.id, "t": _now()}; ptr = {"sx": p.x, "sy": p.y, "drag": false, "btn": hb.id, "id": pid}; joy = null; return
	var ids = pts.keys()
	if ids.size() == 2:
		var a = pts[ids[0]]; var b = pts[ids[1]]; pinch = {"d": hyp(a.x - b.x, a.y - b.y), "z": J.num(cam.z)}; joy = null; ptr = null; return
	ptr = {"sx": p.x, "sy": p.y, "drag": false, "id": pid, "hud": p.y >= VH - BOT or p.y <= TOP}
	if scene == "play" and not T(G.over) and not T(G.choice) and not T(G.get("showStory")) and p.y > TOP and p.y < VH - BOT: joy = {"ox": p.x, "oy": p.y, "x": p.x, "y": p.y, "on": false}
func on_pm(e) -> void:
	var p = pt(e); var pid = J.str(J.gp(e, "pointerId"))
	if pts.has(pid): pts[pid] = p
	if pinch != null:
		var ids = pts.keys()
		if ids.size() == 2:
			var a = pts[ids[0]]; var b = pts[ids[1]]; cam["z"] = clamp_(J.num(pinch.z) * hyp(a.x - b.x, a.y - b.y) / J.num(pinch.d), 0.5, 1.5)
			var S9 = J.num(cam.s) * J.num(cam.z); var mxp = (a.x + b.x) / 2; var myp = (a.y + b.y) / 2
			if pinch.get("mx") != null:
				var c0 = cam.free if T(cam.free) else {"x": J.num(cam.x) + VW / S9 / 2, "y": J.num(cam.y) + (VH - TOP - BOT) / S9 * 0.55}
				cam["free"] = {"x": J.num(c0.x) - (mxp - J.num(pinch.mx)) / S9, "y": J.num(c0.y) - (myp - J.num(pinch.my)) / S9}
			pinch["mx"] = mxp; pinch["my"] = myp
		return
	if ptr == null or J.str(ptr.id) != pid: return
	if ptr.get("btn") == null and hyp(p.x - J.num(ptr.sx), p.y - J.num(ptr.sy)) > 12: ptr["drag"] = true
	if joy != null:
		joy["x"] = p.x; joy["y"] = p.y
		if T(ptr.drag): joy["on"] = true
func on_pu(e) -> void:
	var pid = J.str(J.gp(e, "pointerId")); pts.erase(pid)
	if pinch != null:
		if pts.is_empty(): pinch = null
		return
	if ptr != null and ptr.get("id") != null and J.str(ptr.id) != pid: return
	var p = pt(e); var was = ptr; ptr = null; var j = joy != null and T(joy.on); joy = null
	if j and scene == "play" and T(G) and not T(G.over): settleNear(G.gh[_gi()], 44)
	if was != null and was.get("btn") != null:
		LASTP = p; var hb = hitBtn(p.x, p.y)
		if hb != null and J.str(hb.id) == J.str(was.btn): press(J.str(hb.id))
		elif hyp(p.x - J.num(was.sx), p.y - J.num(was.sy)) < 24: press(J.str(was.btn))
		return
	if was != null and not T(was.drag) and not j: tap(p.x, p.y)
func on_pc(e) -> void:
	pts.erase(J.str(J.gp(e, "pointerId"))); pinch = null; ptr = null; joy = null

# ---------------- 主迴圈、開關 ----------------
func frame(ts: float) -> void:
	if not OPEN: RAF = 0.0; return
	RAF = J.F_requestAnimationFrame([func(_t = null, a = []): frame(J.num(J.arg(a, 0)))])
	if last == 0.0: last = ts
	var dt = (ts - last) / 1000.0
	if dt < 1.0 / 31: return
	last = ts; dt = minf(dt, 0.1)
	if scene == "play" and not T(G.get("showStory")):
		var v = joyVec()
		if v != null and not T(G.choice) and not T(G.over):
			var g = G.gh[_gi()]; g["auto"] = null; g["autoS"] = null; cam["free"] = null; joyMove(g, v.x, v.y, dt)
		update(dt)
	if not T(J.G.get("__twNat")) and not (UNIT != null and T(J.mc(UNIT, "covering", []))): draw(); drawJoy()
func loadImgs() -> void:
	var M = {"flatbg": "bg_tw_flat", "shopbg": "bg_tw_shop"}; var SPR = J.G.get("SPR")
	for k in ["res_gamer_scared", "res_uncle_scared", "res_granny_scared", "res_helper_scared", "res_mjaunty_scared", "res_shopper_scared", "res_collector_scared", "res_guard_scared", "res_ot_scared", "res_gym_scared", "eguiking", "toyol", "tianhua", "tianhua_hang", "npc_ken", "npc_auntie", "npc_guard", "npc_it", "npc_mis", "npc_boss", "npc_it_sit", "npc_ken_sit", "res_gamer", "res_uncle", "res_granny", "res_helper", "res_mjaunty", "res_shopper", "res_collector", "res_guard", "res_ot", "res_gym", "room_mahjong", "room_gamer", "room_nurse", "room_helper", "room_gym", "room_shopper", "room_carpark", "room_lobby", "flatbg", "shopbg", "gb_unit_ppr", "gb_unit_gamer", "gb_unit_shop"]:
		IMG[k] = J.gp(SPR, M.get(k, k))
func open() -> void:
	loadImgs(); TS(); J.mc(J.gp(ROOT, "classList"), "add", ["on"]); OPEN = true
	var nt = J.G.get("__nat_tower")
	if nt != null: J.cl(nt, null, [true])
	scene = "title"; resize(); last = 0.0
	if not T(RAF): RAF = J.F_requestAnimationFrame([func(_t = null, a = []): frame(J.num(J.arg(a, 0)))])
	var Snd_ = J.G.get("Sound")
	if T(Snd_) and T(J.gp(Snd_, "setMode")): J.mc(Snd_, "setMode", ["story"])
	var Pol = J.gp(_w(), "Policy")
	if T(Pol) and T(J.gp(Pol, "firstEnter")): J.mc(Pol, "firstEnter", ["tower"])
func close() -> void:
	OPEN = false
	var nt = J.G.get("__nat_tower")
	if nt != null: J.cl(nt, null, [false])
	J.mc(J.gp(ROOT, "classList"), "remove", ["on"]); joy = null; ptr = null
	J.cl(J.G.get("save"), null, [])
	var Snd_ = J.G.get("Sound")
	if T(Snd_) and T(J.gp(Snd_, "setMode")): J.mc(Snd_, "setMode", ["village"])
	var W = J.G.get("World")
	if T(W): J.mc(W, "open", [])

# ---------------- TWX／TW／A（閉包變數交俾電梯同入屋模組） ----------------
func hudBtns() -> void:
	if HUDX: buttons = []
	for b in HUDB: buttons.append(b)
func hudDraw(c) -> void:
	var o = ctx; ctx = c; HUDC = true; var b0 = buttons; buttons = []; HUDX = T(G.get("choice")) or T(G.get("showStory")) or T(G.get("over"))
	ctx.setTransform(DPR, 0, 0, DPR, 0, 0); drawHUD()
	HUDB = buttons; buttons = b0; HUDC = false; ctx = o
func hudV() -> Array:
	var g = G.gh[_gi()]; var now = _now(); var A = ctxAction(g)
	return [PHT, VW, VH, TOP, BOT, 1.0 if T(cam.free) else 0.0, (ptr.get("btn") if ptr != null and ptr.get("btn") != null else ""), (PRESS.id if (PRESS != null and now - J.num(PRESS.t) < 200) else ""), (J.str(A.k) + J.str(A.t)) if T(A) else "", 1.0 if (not T(g.to) and J.str(G.nodes[J.str(g.node)].kind) == "portal" and not T(g.home)) else 0.0]
func _fx(v, n: int) -> String: return J.str(J.mc(float(v), "toFixed", [float(n)]))
func twHash() -> String:
	var a = [_fx(J.num(G.t), 3), J.str(G.fear), J.str(G.alert), J.str(G.phase), J.str(seed_)]
	for r in G.res:
		a.append_array([J.str(r.state), _fx(J.num(r.x), 2), J.str(round(n0(r.get("fear")))), "1" if T(r.get("awake")) else "0", _fx(J.num(r.idleT), 3), _fx(n0(r.get("doorT")), 3), _fx(n0(r.get("jumpT")), 3), J.str(r.say) if T(r.get("say")) else ""])
	for u in G.units:
		a.append_array(["1" if T(u.get("lit")) else "0", _fx(n0(u.get("doorOpen")), 3), _fx(J.num(u.litT), 3), str(idx_of(G.res, u.res)) if T(u.get("res")) else "-1"])
		for q in u.props: a.append_array([_fx(J.num(q.t), 3), _fx(J.num(q.cd), 3)])
	for h in G.guards: a.append_array([J.str(h.state), _fx(J.num(h.x), 2)])
	return "|".join(a)
func _dog_draw(s, bob, fl) -> void:
	var t = J.num(G.t); ctx.save(); ctx.translate(J.num(s.x), J.num(s.y) + J.num(bob)); ctx.scale(-1.0 if T(fl) else 1.0, 1); ctx.fillStyle = "#3a2e24"; ctx.strokeStyle = "#e8d8b0"; ctx.lineWidth = 1.5
	ctx.beginPath(); ctx.ellipse(0, -14, 20, 9, 0, 0, 7); ctx.fill(); ctx.stroke(); ctx.beginPath(); ctx.ellipse(18, -22, 9, 7, 0, 0, 7); ctx.fill(); ctx.stroke(); ctx.fillStyle = "#ff4a3a"; ctx.fillRect(21, -25, 3, 3); ctx.strokeStyle = "#3a2e24"; ctx.lineWidth = 3
	var lxs = [-12, -4, 6, 12]
	for k in 4: ctx.beginPath(); ctx.moveTo(lxs[k], -8); ctx.lineTo(lxs[k] + sin(t * 20 + k) * 4, 0); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(-19, -16); ctx.lineTo(-28, -24 + sin(t * 25) * 3); ctx.stroke(); ctx.restore()

func _getters(names: Dictionary) -> Dictionary:
	var gt = {}
	for k in names: var f: Callable = names[k]; gt[k] = func(_t = null, _a = []): return f.call()
	return gt
func _api(extra: Dictionary) -> Dictionary:
	var A = {"FONT": FONT, "HUM": HUM, "HH": HH, "cv": cv,
		"fy": func(_t, a): return fy(J.arg(a, 0)),
		"rnd": func(_t, _a2): return rnd(),
		"float": func(_t, a): float_(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.arg(a, 2), J.arg(a, 3)); return null,
		"toast": func(_t, a): toast(J.arg(a, 0)); return null,
		"say": func(_t, a): say(J.arg(a, 0), J.arg(a, 1)); return null,
		"addFear": func(_t, a): addFear(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.num(J.arg(a, 2))); return null,
		"noise": func(_t, a): noise(J.arg(a, 0), J.num(J.arg(a, 1)), J.arg(a, 2)); return null,
	}
	A.merge(extra, true)
	A["__getters"] = _getters({"G": func(): return G, "LV": func(): return LV, "FL": func(): return FL, "FLN": func(): return FLN, "IMG": func(): return IMG,
		"scene": func(): return scene if OPEN else "closed", "paused": func(): return paused, "VW": func(): return VW, "VH": func(): return VH, "TOP": func(): return TOP, "BOT": func(): return BOT, "BTNS": func(): return buttons})
	return A

func run(_env) -> void:
	var f = FileAccess.open("res://data/nat/tower_data.json", FileAccess.READ)
	D = JSON.parse_string(f.get_as_text()) if f else {}
	LEVELS = D.LEVELS; PH = D.PH; LINES = D.LINES; used = {}; GH = D.GH; WARD = D.WARD; CARDS = D.CARDS; HUM = D.HUM; ITEM = D.ITEM; BLOCKMSG = D.BLOCKMSG; PPL_META = D.PPL_META
	SCREAM = D.SCREAM; SPOOKL = D.SPOOKL; BALKL = D.BALKL; DROPK = D.DROPK; ULT = D.ULT; MV = D.MV; REACT = D.REACT; BLD = D.BLD; HH = D.HH; HHW = D.HHW; PROP = D.PROP; PROPLINE = D.PROPLINE
	CR = D.CR; CRC = D.CRC; LV0 = LEVELS
	ROOT = J.S_document_("createElement", ["section"]); J.sp(ROOT, "id", "tw-root"); J.sp(ROOT, "className", "tw-root")
	_cv = J.S_document_("createElement", ["canvas"]); J.sp(_cv, "className", "tw-cv"); J.mc(ROOT, "appendChild", [_cv]); J.mc(J.gp(J.G.get("document"), "body"), "appendChild", [ROOT])
	var W = J.G.get("World")
	if T(W) and T(J.gp(W, "ICON")): J.sp(J.gp(W, "ICON"), "tower", "樓")
	cv = _cv; ctx = J.mc(cv, "getContext", ["2d"])
	var dpr = J.gp(_w(), "devicePixelRatio"); DPR = minf(2.0, J.num(dpr) if T(dpr) else 1.0)
	var w = _w()
	J.sp(w, "__twCull", CULL)
	PPLFX = _mk_pplfx(); J.sp(w, "PPLFX", PPLFX)
	# 輸入：TwRun 直接叫 window.__twPD/PM/PU
	var pd = func(_t, a): on_pd(J.arg(a, 0)); return null
	var pm = func(_t, a): on_pm(J.arg(a, 0)); return null
	var pu = func(_t, a): on_pu(J.arg(a, 0)); return null
	J.sp(w, "__twPD", pd); J.sp(w, "__twPM", pm); J.sp(w, "__twPU", pu)
	J.mc(cv, "addEventListener", ["pointerdown", pd]); J.mc(cv, "addEventListener", ["pointermove", pm]); J.mc(cv, "addEventListener", ["pointerup", pu])
	J.mc(cv, "addEventListener", ["pointercancel", func(_t, a): on_pc(J.arg(a, 0)); return null])
	# 電梯（LiftSys）、入屋（UnitSys）：原生模組，閉包變數用 A 交過去
	var LiftN = load("res://native/tower_lift.gd"); var UnitN = load("res://native/tower_unit.gd")
	J.sp(w, "LiftSys", func(_t, a): return LiftN.make(J.arg(a, 0)))
	J.sp(w, "UnitSys", func(_t, a): return UnitN.make(J.arg(a, 0)))
	LIFT = LiftN.make(_api({"spook": func(_t, a): spook(J.arg(a, 0), J.arg(a, 1)); return null, "W2S": func(_t, a): return W2S(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))}))
	J.sp(w, "LIFT", LIFT)
	UNIT = UnitN.make(_api({"ITEM": ITEM, "BAGMAX": BAGMAX, "MV": MV, "BLOCKMSG": BLOCKMSG, "PH": PH, "PHT": PHT,
		"scareRes": func(_t, a): scareRes(J.arg(a, 0), J.num(J.arg(a, 1)), J.arg(a, 2)); return null,
		"gpF": func(_t, a): return gpF(J.arg(a, 0)),
		"takeItem": func(_t, a): takeItem(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"onArrive": func(_t, a): onArrive(J.arg(a, 0)); return null,
		"unitOf": func(_t, a): return unitOf(J.arg(a, 0)),
		"doorBlock": func(_t, a): return doorBlock(J.arg(a, 0), J.arg(a, 1)),
		"ctxAction": func(_t, a): return ctxAction(J.arg(a, 0)),
		"actPress": func(_t, _a2): actPress(); return null,
		"gotoNode": func(_t, a): return gotoNode(J.arg(a, 0), J.arg(a, 1)),
		"checkAlert": func(_t, _a2): checkAlert(); return null,
		"crPanel": func(_t, a): crPanel(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5)); return null,
		"crText": func(_t, a): crText(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6), J.arg(a, 7), J.arg(a, 8), J.arg(a, 9)); return null,
		"crBtn": func(_t, a): crBtn(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6), J.arg(a, 7), J.arg(a, 8)); return null,
		"crBar": func(_t, a): crBar(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6)); return null,
		"crGet": func(_t, a): return crGet(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.arg(a, 2), J.arg(a, 3)),
		"crBlit": func(_t, a): crBlit(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3))); return null,
	}))
	J.sp(w, "UNIT", UNIT)
	TWo = {
		"gp": func(_t, _a2): return null if not T(G) else {"has": G.gpHas, "need": G.gpNeed, "team": G.gpTeam, "D": G.gpD, "tier": G.gpTier, "gh": G.gh.map(func(g): return {"k": g.d.key, "mul": g.mul, "pow": g.pow, "trainee": g.trainee, "spm": g.spm, "em": g.em, "tm": g.tm, "im": g.im, "icd": g.icd, "um": g.um})},
		"gpRe": func(_t, _a2): gpStart(); return null,
		"gpF": func(_t, a): return gpF(G.gh[int(J.num(J.arg(a, 0)))]),
		"end": func(_t, a): endNight(J.str(J.arg(a, 0))); return null,
		"sr": func(_t, a): scareRes(J.arg(a, 0), J.arg(a, 1), null if J.arg(a, 2) == null else G.gh[int(J.num(J.arg(a, 2)))]); return null,
		"ng": func(_t, a): newGame(J.arg(a, 0), J.arg(a, 1)); bake(); return null,
		"safe": func(_t, _a2): return {"x": SAFE.x, "y": SAFE.y, "r": SAFE.r, "f": SAFE.f, "nodes": SAFE.nodes.keys(), "on": safeOn()} if SAFE != null else null,
		"inSafe": func(_t, a): return inSafe(G.gh[int(J.num(J.arg(a, 0)))]),
		"inSafeXY": func(_t, a): return inSafeXY(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))),
		"uq": func(_t, _a2): return (G.get("_uq", {}) as Dictionary).keys(),
		"cam": func(_t, _a2): return {"z": cam.z, "free": T(cam.free), "x": cam.x, "y": cam.y},
		"btns": func(_t, _a2): return buttons.map(func(b): return {"id": b.id, "x": b.x, "y": b.y, "w": b.w, "h": b.h}),
		"act": func(_t, _a2): actPress(); return null,
		"ctx": func(_t, _a2): return ctxAction(G.gh[_gi()]),
		"noise": func(_t, a): noise(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"zoom": func(_t, a): cam["z"] = J.num(J.arg(a, 0)); return null,
		"pause": func(_t, a): paused = T(J.arg(a, 0)); return null,
		"step": func(_t, a):
			var pp = paused; paused = false
			for i in int(J.num(J.arg(a, 1))) if J.arg(a, 1) != null else 1: update(J.num(J.arg(a, 0)))
			paused = pp; draw(); return null,
		"gate": func(_t, _a2): gatePress(); return null,
		"doll": func(_t, _a2): dollEscape(); return null,
		"catchG": func(_t, a): catchGhost(G.gh[int(J.num(J.arg(a, 0)))], G.guards[0] if G.guards.size() else {"dir": 1.0}); return null,
		"ult": func(_t, a): return ultPress(J.arg(a, 0)),
		"press": func(_t, a): press(J.str(J.arg(a, 0))); return null,
		"tap": func(_t, a): tap(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); return null,
		"goto": func(_t, a): return gotoNode(G.gh[int(J.num(J.arg(a, 0)))], J.arg(a, 1)),
		"choose": func(_t, a): chooseCard(int(J.num(J.arg(a, 0)))); return null,
		"skip": func(_t, a): G["t"] = J.num(G.t) + J.num(J.arg(a, 0)); return null,
		"w2s": func(_t, a): return W2S(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))),
	}
	TWo["__getters"] = _getters({"G": func(): return G})
	J.sp(w, "TW", TWo)
	TWX = {
		"step": func(_t, a):
			for k in int(J.num(J.arg(a, 0))):
				if T(G.over): break
				update(J.num(J.arg(a, 1)))
			return G.t,
		"endN": func(_t, a): endNight(J.str(J.arg(a, 0))); return null,
		"camz": func(_t, _a2): return cam.z,
		"hudDraw": func(_t, a): hudDraw(J.arg(a, 0)); return null,
		"hudBtns": func(_t, _a2): hudBtns(); return null,
		"hudV": func(_t, _a2): return hudV(),
		"draw": func(_t, a):
			var o = ctx; ctx = J.arg(a, 0); draw(); drawJoy(); ctx = o; return null,
		"scene": func(_t, _a2): return scene,
		"open": func(_t, _a2): return OPEN,
		"top": func(_t, _a2): return TOP,
		"bot": func(_t, _a2): return BOT,
		"resize": func(_t, _a2): resize(); return null,
		"unit": UNIT, "lift": LIFT,
		"joy": func(_t, _a2): return joy != null and T(joy.on),
		"cr": {"btn": func(_t, a): crBtn(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6), J.arg(a, 7), J.arg(a, 8)); return null,
			"panel": func(_t, a): crPanel(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5)); return null,
			"text": func(_t, a): crText(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6), J.arg(a, 7), J.arg(a, 8), J.arg(a, 9)); return null},
		"press": func(_t, a): press(J.str(J.arg(a, 0))); return null,
		"G": func(_t, _a2): return G,
		"fn": {"IMG": IMG, "META": PPL_META, "PPL": PPLFX, "HUM": HUM,
			"crBar": func(_t, a): crBar(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.arg(a, 6)); return null,
			"bubble": func(_t, a): bubble(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.arg(a, 2), J.arg(a, 3)); return null,
			"reactPose": func(_t, a): reactPose(J.arg(a, 0), J.arg(a, 1)); return null,
			"reactProps": func(_t, a): reactProps(J.arg(a, 0), J.arg(a, 1)); return null,
			"pplStep": func(_t, a): return pplStep(J.arg(a, 0)),
			"dogDraw": func(_t, a): _dog_draw(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
			"rnd": func(_t, _a2): return rnd(),
			"pick": func(_t, a): return pick(J.arg(a, 0)),
			"say": func(_t, a): say(J.arg(a, 0), J.arg(a, 1)); return null,
			"part": func(_t, a): part(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5)); return null,
			"startShock": func(_t, a): startShock(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
			"line": func(_t, a): return line(J.str(J.arg(a, 0))),
			"HH": HH,
			"sweat": func(_t, a):
				var r = J.arg(a, 0); part(J.num(r.x) + (-12.0 if randf() < 0.5 else 12.0), J.num(r.y) - (J.num(r.h) if T(r.get("h")) else 66.0) * 0.95, (randf() - 0.5) * 30, -20, 0.6, "sweat"); return null},
		"hash": func(_t, _a2): return twHash(),
		"sim": func(_t, a):
			newGame(J.arg(a, 0), "flat"); var t0 = Time.get_ticks_msec()
			for i in int(J.num(J.arg(a, 1))): update(J.num(J.arg(a, 2)))
			return float(Time.get_ticks_msec() - t0),
	}
	J.sp(w, "TWX", TWX)
	J.mc(w, "addEventListener", ["resize", func(_t, _a2):
		if OPEN: resize()
		return null])
	var Tower = {"open": func(_t, _a2): open(); return null, "close": func(_t, _a2): close(); return null, "_self": self}
	Tower["__getters"] = _getters({"on": func(): return OPEN})
	J.G["Tower"] = Tower
