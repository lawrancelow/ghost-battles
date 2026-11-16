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

func run_named(t, name: String) -> void: call(name, t)
