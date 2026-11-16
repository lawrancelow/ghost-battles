# 原生改寫對照：同一個遊戲狀態下，原生版同轉譯版逐個函數比輸出
# 用法（tester）：["gdrun","res://tools/tests/native_xcheck.gd","gpower"]
#   會叫 _case_<模塊>(nat, tr) 跑測試；結果印 "[xcheck] 模塊 ok=N bad=M"，每個唔同印 "[xcheck-diff] ..."
extends RefCounted

var ok := 0
var bad := 0
var mod := ""

# 載入轉譯版模塊（jsgen），攞佢設嘅全局，之後還原返原生版（模塊實例要留住，唔係入面嘅函數會失效）
static var _keep_alive: Array = []
static func load_trans(module: String, globals: Array) -> Dictionary:
	var keep = {}
	for g in globals: keep[g] = J.G.get(g)
	var scr: GDScript = load("res://jsgen/%s.gd" % module)
	var m = scr.new(); _keep_alive.append(m); m.run(null)
	var out = {}
	for g in globals: out[g] = J.G.get(g); J.G[g] = keep[g]
	var w = J.G.get("window")
	if w != null: for g in globals: J.sp(w, g, keep[g])
	return out

static func same(a, b) -> bool:
	if (a is float or a is int) and (b is float or b is int): return absf(float(a) - float(b)) <= 1e-6 * maxf(1.0, absf(float(a)))
	if a is Dictionary and b is Dictionary: return JSON.stringify(a) == JSON.stringify(b)
	if a is Array and b is Array: return JSON.stringify(a) == JSON.stringify(b)
	return typeof(a) == typeof(b) and a == b or (a == null and b == null) or J.str(a) == J.str(b)

func check(name: String, nat, tr, fname: String, args: Array) -> void:
	var x = J.mc(nat, fname, args.duplicate(true))
	var y = J.mc(tr, fname, args.duplicate(true))
	if same(x, y): ok += 1
	else:
		bad += 1
		if bad <= 30: print("[xcheck-diff] %s.%s(%s) nat=%s tr=%s" % [name, fname, JSON.stringify(args).substr(0, 120), str(x).substr(0, 160), str(y).substr(0, 160)])

func _report() -> void: print("[xcheck] %s ok=%d bad=%d" % [mod, ok, bad])

func gpower(_t) -> void:
	mod = "gpower"
	var tr = load_trans("gpower", ["GP"]).GP; var nat = J.G.GP
	var S = J.G.S
	for g in S.ghosts:
		for f in ["pow", "mul", "grow", "raw"]: check("GP", nat, tr, f, [g])
		for f in ["kindMul", "kindPow", "kindGrow", "best", "drillMul"]: check("GP", nat, tr, f, [g.k])
	for n in [1, 3, 5, 99]: check("GP", nat, tr, "top", [float(n)])
	check("GP", nat, tr, "avg", [S.ghosts]); check("GP", nat, tr, "avg", [[]])
	for sid in ["1-1", "3-3", "6-3", "9-9"]: check("GP", nat, tr, "stageNeed", [{"p": 7.0, "boss": true}, sid])
	check("GP", nat, tr, "stageNeed", [null, null])
	for lv in [0, 1, 10, 24, 40]: check("GP", nat, tr, "turfNeed", [float(lv)])
	for hn in [[500.0, 800.0], [900.0, 800.0], [700.0, null]]: check("GP", nat, tr, "tag", hn)
	for need in [0.0, 800.0]: check("GP", nat, tr, "hint", [need])
	check("GP", nat, tr, "failHTML", [500.0, 800.0, null])
	_report()

# 純數據模塊：原生（JSON）同轉譯版逐個全局比較（JSON 字串，唔排序鍵）
func _datamod(m: String) -> void:
	mod = m
	var src = FileAccess.get_file_as_string("res://jsgen/%s.gd" % m)
	var re = RegEx.new(); re.compile('J\\.G\\["([A-Za-z_0-9]+)"\\] =')
	var names = []
	for r in re.search_all(src): if not names.has(r.get_string(1)): names.append(r.get_string(1))
	var tr = load_trans(m, names)
	var keep = {}
	for n in names: keep[n] = J.G.get(n)
	load("res://native/%s.gd" % m).new().run(null)
	for n in names:
		var a = JSON.stringify(J.G.get(n), "", false, true); var b = JSON.stringify(tr[n], "", false, true)
		if a == b: ok += 1
		else: bad += 1; print("[xcheck-diff] %s.%s len %d vs %d" % [m, n, a.length(), b.length()])
		J.G[n] = keep[n]
	_report()
func data(_t) -> void: _datamod("data")
func presence_data(_t) -> void: _datamod("presence_data")
func bonds_data(_t) -> void: _datamod("bonds_data")

# ---------------- L3：陰間地圖 ----------------
func world(_t) -> void:
	mod = "world"
	var tr = load_trans("world", ["World"]).World; var nat = J.G.World
	for k in ["YARD_READY", "RESERVED", "ICON", "DESC", "RES_SPOTS"]:
		if same(nat.get(k), tr.get(k)): ok += 1
		else: bad += 1; print("[xcheck-diff] World.%s" % k)
	for i in tr.SPOTS.size():
		var a = nat.SPOTS[i]; var b = tr.SPOTS[i]
		for k in ["id", "x", "y", "lx", "ly", "name", "sub", "lock"]:
			if same(a.get(k), b.get(k)): ok += 1
			else: bad += 1; print("[xcheck-diff] World.SPOTS[%d].%s" % [i, k])
		for f in ["ready", "need"]:
			var x = J.cl(a.get(f), null, []) if a.get(f) != null else "none"; var y = J.cl(b.get(f), null, []) if b.get(f) != null else "none"
			if same(x, y): ok += 1
			else: bad += 1; print("[xcheck-diff] World.SPOTS[%d].%s() nat=%s tr=%s" % [i, f, x, y])
	_report()

# ---------------- L3：主線戰鬥（同一存檔、同一種子，整場自動戰鬥比結果） ----------------
func _bt_sim(B: Dictionary, ci: int, si: int, seed_n: int, S0: Dictionary) -> Dictionary:
	J.G["S"] = S0.duplicate(true)
	var keep_nb = J.G.get("__nat_battle"); J.G["__nat_battle"] = null
	seed(seed_n)
	B["auto"] = true; B["speed"] = 1.0; B["cvs"] = J.cl(J.G.get("$"), null, ["#bcvs"])
	J.mc(B, "start", [float(ci), float(si), null])
	B["H"] = 640.0
	var frames = 0
	while not J.t(B.get("result")) and frames < 60 * 100:
		J.mc(B, "update", [1.0 / 60.0]); frames += 1
	J.G["__nat_battle"] = keep_nb
	var us = []
	for u in B.units: us.append([J.str(u.k), snappedf(J.num(u.hp), 0.001), snappedf(J.num(u.x), 0.001), snappedf(J.num(u.energy), 0.001)])
	var S = J.G.S
	var out = {"win": J.t(J.gp(B.result, "win")) if B.get("result") else null, "t": snappedf(J.num(B.t), 0.0001), "frames": frames, "units": us,
		"res": S.res.duplicate(), "cleared": S.cleared.duplicate(), "coinsWon": B.get("coinsWon"), "fx": B.fx.size(), "combo": B.get("combo")}
	B["active"] = false
	var be = J.cl(J.G.get("$"), null, ["#b-result"])
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])
	return out

func battle(_t) -> void:
	mod = "battle"
	var live = J.G.Battle; var nscr = load("res://native/battle.gd"); var old_static = nscr.B
	var keepS = J.G.S; var S0 = keepS.duplicate(true)
	S0["team"] = []
	for g in S0.ghosts:
		if S0.team.size() < 3 and J.str(g.k) != "afu": S0.team.append(g.id)
	var tr = load_trans("battle", ["Battle", "GIFT_REWARD", "__BT_ATK", "__btDC"]).Battle
	var nm = nscr.new(); _keep_alive.append(nm); nm.run(null); var nat = J.G.Battle
	J.G["Battle"] = live
	for cs in [[0, 0, 11], [0, 2, 22], [1, 1, 33], [2, 2, 44], [4, 1, 55], [5, 2, 66]]:
		var a = _bt_sim(nat, cs[0], cs[1], cs[2], S0)
		var b = _bt_sim(tr, cs[0], cs[1], cs[2], S0)
		if same(a, b): ok += 1
		else:
			bad += 1
			for k in a: if not same(a[k], b[k]): print("[xcheck-diff] battle %s.%s nat=%s tr=%s" % [str(cs), k, str(a[k]).substr(0, 300), str(b[k]).substr(0, 300)])
		print("[xcheck-info] battle %s win=%s t=%s frames=%d" % [str(cs), a.win, a.t, a.frames])
	J.G["S"] = keepS; J.G["Battle"] = live; nscr.B = old_static
	_report()

func run_named(t, name: String) -> void: call(name, t)
