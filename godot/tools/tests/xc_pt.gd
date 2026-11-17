# L1：patrol（Patrol 規則／存檔／選單資料＋備用 HTML，Gear 全部）原生 vs 轉譯版
extends "res://tools/tests/xc_l1.gd"

var plog: Array = []
static func _cl(o):
	if o is Callable: return "<fn>"
	if o is Array: return o.map(func(x): return _cl(x))
	if o is Dictionary:
		var d = {}
		for k in o: d[k] = _cl(o[k])
		return d
	return o

func _sq(a: Array) -> void:
	plog.append(["queue", _cl(a[0])])
	if a.size() > 1 and a[1] != null: J.cl(a[1], null, [])
func _stubs() -> Dictionary:
	var keep = {}
	for k in ["UI", "Story", "Fx", "Sound", "__nat_patrolMenu", "__nat_patrol", "paintPortraits", "Quest"]: keep[k] = J.G.get(k)
	J.G["UI"] = {"sheet": func(_t, a): plog.append(["sheet", a[0], a[1]]); return null, "close": func(_t, _a): plog.append(["close"]); return null, "refresh": func(_t, _a): plog.append(["refresh"]); return null}
	J.G["Story"] = {"queue": func(_t, a): _sq(a); return null}
	J.G["Fx"] = {"toast": func(_t, a): plog.append(["toast", a[0]]); return null}
	J.G["Sound"] = {"play": func(_t, a): plog.append(["snd", a[0]]); return null, "setMode": func(_t, a): plog.append(["mode", a[0]]); return null}
	J.G["__nat_patrolMenu"] = func(_t, a): plog.append(["menu", a[0]]); return J.str(a[0]) == "prep_yes"
	J.G["__nat_patrol"] = func(_t, a): plog.append(["natrun", a[0], a[1]]); return true
	J.G["paintPortraits"] = func(_t, _a): return null
	J.G["Quest"] = {"check": func(_t, _a): plog.append(["qcheck"]); return null}
	return keep

func app(out: Array, x) -> void: out.append(_cl(x))   # 即刻深拷貝（之後改存檔唔會改到已記低嘅）

func _run(Pm, Gr, S0: Dictionary) -> Array:
	var out = []; plog = []
	J.G["Patrol"] = Pm; J.G["Gear"] = Gr   # 模塊入面經全局寫 _menu，要指返測緊嘅版本
	J.G["S"] = S0.duplicate(true); var S = J.G.S
	J.test_clock = 1.8e12
	var N = J.gp(Pm, "_nat")
	for k in ["CW", "CH", "COLS", "ROWS", "FOG", "VIEW", "GW", "FAC", "FAC_OF", "REG", "CH_FOD", "TLAY", "TGATE", "TLAIR", "TMAIN", "TSECRET", "TNAME", "LM_N", "LMNAME", "TKING", "TTIER", "FACI0", "TEA_CD", "DOWN_T", "MEET", "SOLID", "PROP", "HUE", "TC", "CLOTH", "ACC", "RING", "ATK", "PH"]: out.append(["nat", k, J.gp(N, k)])
	app(out, ["keys", J.keys(N), J.keys(Pm).filter(func(k): return k != "__getters" and k != "_test"), J.keys(Gr)])
	S.erase("pt"); S.erase("gear")
	app(out, ["st", J.mc(Pm, "st", []), J.mc(N, "st", [])])
	for ci in 6:
		app(out, ["reg", ci, J.mc(N, "regSt", [float(ci)]), J.mc(N, "startZ", [float(ci)]), J.mc(N, "sidOf", [float(ci), 2.0]), J.mc(N, "regionOpen", [float(ci)]), J.mc(Pm, "regionOpen", [float(ci)])])
		app(out, ["lists", ci, J.mc(N, "elitesOf", [float(ci)]), J.mc(N, "fodOf", [float(ci)]), J.mc(N, "pageGhosts", [float(ci)]), J.mc(Pm, "landmarks", [float(ci)])])
	S.pt.reg["1"] = {"v": 2.0, "fog": "1101", "sta": {"3": 1.0}, "kings": {"2": 1.0}, "lm": {"0": 1.0, "4": 1.0}}
	app(out, ["reg2", J.mc(N, "regSt", [1.0]), J.mc(Pm, "landmarks", [1.0])])
	app(out, ["cap", J.mc(N, "crewCap", []), J.mc(N, "troopTeams", []), J.mc(N, "crewList", []).map(func(g): return g.id), J.mc(N, "leads", []).map(func(g): return g.id)])
	for g in S.ghosts: if J.str(g.get("q")) in ["藍", "紫"]: g["fat"] = 50.0
	S.pt.restAt = J.test_clock - 600000.0; J.mc(N, "restRecover", [])
	app(out, ["rest", S.ghosts.map(func(g): return g.get("fat")), S.pt.restAt])
	var ks = ["youhun", "zhiren", "afu", "mengpo", "xiaozhi", "n30_qionggui", "pg_tuimo", "baiwu", "unknown_k"]
	for g in S.ghosts: ks.append(g.k)
	app(out, ["fac", ks.map(func(k): return J.mc(N, "facOf", [k])), ks.map(func(k): return J.mc(Pm, "facOf", [k]))])
	app(out, ["phase", [0.0, 239.0, 240.0, 479.0, 480.0, 1079.0, 1080.0, 1439.0].map(func(m): return J.mc(N, "phase", [m]))])
	app(out, ["T", J.mc(N, "T", ["呢度", "這裡"])])
	# _menu（經 openPrep，__nat_patrolMenu 答 false → 備用 HTML）
	S.pt.lead = null
	J.mc(Pm, "openPrep", [])
	var M = J.gp(Pm, "_menu")
	app(out, ["menu", _cl(M)])
	for ci in 6:
		J.mc(M, "setMir", [float(ci)]); J.mc(M, "mkFaci", [])
		app(out, ["faci", ci, J.mc(M, "faci", []), range(63).map(func(z): return J.mc(M, "terOf", [float(z)])), J.mc(M, "startZ", [float(ci)])])
	J.mc(M, "setMir", [0.0]); J.mc(M, "mkFaci", [])
	S.pt.erase("introSeen"); J.mc(Pm, "openPrep", [])
	J.mc(M, "intro", [func(_t, _a): plog.append(["then"]); return null])
	J.mc(M, "start", [0.0, 54.0]); J.mc(M, "start", [1.0, 63.0 - 9.0])
	J.mc(Pm, "close", [])
	var hk = {}
	J.mc(Pm, "on", ["discover", func(_t, a): plog.append(["hook", _cl(a[0])]); return null]); J.mc(N, "emit", ["discover", {"ci": 0.0, "id": 3.0}]); J.mc(N, "emit", ["none", {}])
	J.mc(N, "setActive", [true]); out.append(["active", J.gp(Pm, "active")]); J.mc(N, "setActive", [false]); out.append(["active", J.gp(Pm, "active")])
	app(out, ["R", J.mc(Pm, "_R", []), J.mc(Pm, "spots", [])])
	# ---- Gear ----
	var gh = S.ghosts.filter(func(g): return J.str(g.get("q")) in ["名", "主"])
	var gs = J.mc(Gr, "held", [gh[0] if gh.size() else null])
	app(out, ["held0", gs])
	S.res.coins = 1e7; S.res.planks = 1e6; S.pt.mats = {"yuan": 500.0, "chan": 30.0, "lan": 900.0}
	var GS = {"items": [], "uid": 1.0}; S["gear"] = GS
	var k = 0
	for sl in ["wea", "arm", "acc"]:
		for c in 6:
			for f in ["yuan", "chan", "lan"]:
				k += 1
				GS.items.append({"id": "e%d" % k, "slot": sl, "c": float(c), "f": f, "lv": float(1 + (k % 9)), "who": (gh[k % gh.size()].id if gh.size() and k % 4 else null)})
	GS.uid = float(k + 1)
	for it in GS.items: out.append(["it", it.id, J.mc(Gr, "nameOf", [it]), J.mc(Gr, "pct", [it])])
	for g in gh + [S.ghosts[0]]: out.append(["g", g.id, J.mc(Gr, "weaponOf", [g]), J.mc(Gr, "armorOf", [g]), J.mc(Gr, "badgeOf", [g]), J.mc(Gr, "unitMul", [g]), J.mc(Gr, "gpMul", [g]), J.mc(Gr, "held", [g]).size()])
	app(out, ["buff", J.mc(Gr, "crewBuff", [])]); S.pt.lead = [gh[0].id] if gh.size() else []; out.append(["buff2", J.mc(Gr, "crewBuff", [])])
	app(out, ["consts", J.gp(Gr, "SLOTS"), J.gp(Gr, "STY"), J.gp(Gr, "WIMG")])
	J.mc(Gr, "open", [func(_t, _a): plog.append(["gback"]); return null])
	var GM = J.gp(Gr, "_menu")
	app(out, ["gmenu", _cl(GM)])
	for it in GS.items.slice(0, 20):
		var uc = J.mc(GM, "upCost", [it]); var cc = J.mc(GM, "craftCost", [it.c, it.f])
		app(out, ["cost", it.id, J.mc(GM, "effText", [it]), uc, cc, J.mc(GM, "canPayAll", [uc]), J.mc(GM, "canPayAll", [cc])])
		if J.mc(GM, "canPayAll", [uc]): J.mc(GM, "payAll", [uc])
	app(out, ["after", S.res.coins, S.res.planks, S.pt.mats])
	for tab in ["arm", "acc"]:
		# 備用 HTML（tab 經 data-tab 按鈕，只可以喺 DOM 裡按；直接用 open 重畫）
		J.mc(Gr, "open", [null])
	app(out, ["log", _cl(plog)])
	J.test_clock = -1.0
	return out

func patrol(_t) -> void:
	mod = "patrol"
	var nP = J.G.Patrol; var nG = J.G.Gear
	var tr = load_trans("patrol", ["Patrol", "Gear"])
	var keepS = J.G.S; var S0: Dictionary = keepS.duplicate(true)
	var keep = _stubs()
	var a = _run(nP, nG, S0); var b = _run(tr.Patrol, tr.Gear, S0)
	eq("len", a.size(), b.size())
	for i in mini(a.size(), b.size()): eq("%s %s" % [a[i][0], a[i][1] if a[i].size() > 1 and (a[i][1] is String or a[i][1] is float or a[i][1] is int) else ""], a[i], b[i])
	J.G["Patrol"] = nP; J.G["Gear"] = nG
	for k in keep:
		if keep[k] == null: J.G.erase(k)
		else: J.G[k] = keep[k]
	J.G["S"] = keepS
	_report()
