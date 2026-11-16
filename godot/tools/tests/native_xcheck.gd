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
	var icon = nat.ICON.duplicate(); icon.erase("tower")   # tower.js 載入後會加 World.ICON.tower
	if same(icon, tr.ICON): ok += 1
	else: bad += 1; print("[xcheck-diff] World.ICON")
	for k in ["YARD_READY", "RESERVED", "DESC", "RES_SPOTS"]:
		if same(nat.get(k), tr.get(k)): ok += 1
		else: bad += 1; print("[xcheck-diff] World.%s" % k)
	for i in tr.SPOTS.size():
		var a = nat.SPOTS[i]; var b = tr.SPOTS[i]
		for k in ["id", "x", "y", "lx", "ly", "name", "sub", "lock"]:
			if same(a.get(k), b.get(k)): ok += 1
			else: bad += 1; print("[xcheck-diff] World.SPOTS[%d].%s" % [i, k])
		for f in ["ready", "need"]:
			var x = J.t(J.cl(a.get(f), null, [])) if a.get(f) != null else "none"; var y = J.t(J.cl(b.get(f), null, [])) if b.get(f) != null else "none"
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

func rework(_t) -> void:
	mod = "rework"
	var tr = load_trans("rework", ["Rework"]).Rework; var nat = J.G.Rework
	var keys = J.G.ENEMY_T.keys() + (J.G.SCARE_GHOSTS.keys() if J.G.get("SCARE_GHOSTS") is Dictionary else []) + ["abc", "n30_liulian", "x", "阿福"]
	for k in keys:
		for f in ["fearOf", "fearLine", "typesOf", "drillXp", "drillLv", "drillNext"]: check("Rework", nat, tr, f, [k])
	for w in J.G.Rework.TYPES + ["zzz"]: check("Rework", nat, tr, "word", [w])
	check("Rework", nat, tr, "enemyHint", [["youhun", "egui", "youhun", "huang"]])
	for g in J.G.S.ghosts: check("Rework", nat, tr, "teamHint", [g])
	for f in ["held", "turfHead", "kitHTML", "turf"]: check("Rework", nat, tr, f, [])
	for sid in ["1-1", "3-3", "6-3", "7-1", "0-0"]:
		for f in ["isLost", "turfTag", "stageOf"]: check("Rework", nat, tr, f, [sid])
	# 有被搶嘅地盤
	J.G.S.turf.lost["1-2"] = 1.0; J.G.S.turf.gang["1-2"] = 2.0
	for sid in ["1-2", "1-1"]:
		for f in ["isLost", "turfTag"]: check("Rework", nat, tr, f, [sid])
	check("Rework", nat, tr, "turfHead", [])
	J.G.S.turf.lost.erase("1-2"); J.G.S.turf.gang.erase("1-2")
	_report()

# ---------------- L3：運動會（同一存檔、同一種子，模擬玩家操作打完一場） ----------------
func _sp_sim(SP: Dictionary, id: String, seed_n: int, S0: Dictionary) -> Dictionary:
	J.G["S"] = S0.duplicate(true)
	var keep = {}
	for k in ["__nat_mini", "__nat_menu", "requestAnimationFrame"]: keep[k] = J.G.get(k); J.G[k] = null
	seed(seed_n)
	J.mc(SP, "start", [id])
	var G = J.mc(SP, "_g", [])
	G["phase"] = "play"; G["H"] = 600.0
	var dt = 1.0 / 60.0; var f = 0
	if id == "hang": J.cl(G.down, null, [{"x": 195.0, "y": 300.0}])
	while not J.t(G.get("done")) and f < 60 * 70:
		G["t"] = J.num(G.t) + dt
		if J.num(G.msgT) > 0: G["msgT"] = J.num(G.msgT) - dt
		J.cl(G.tick, null, [dt])
		match id:
			"jump": if f % 34 == 20 or (J.num(G.hop) >= 6 and f % 7 == 0): J.cl(G.down, null, [])
			"tug": if f % 6 == 0: J.cl(G.down, null, [])
			"hang": if f % 5 == 0 and G.get("move") != null: J.cl(G.move, null, [{"x": 195.0 - J.num(G.sw) * 140, "y": 300.0}])
			"swim": if f % 20 == 0: J.cl(G.stroke_, null, [-1.0 if (f / 20) % 2 == 0 else 1.0])
		f += 1
	for k in keep: J.G[k] = keep[k]
	var out = {"frames": f, "done": G.get("done"), "phase": G.get("phase"), "S_sports": J.G.S.get("sports"), "coins": J.G.S.res.get("coins")}
	for k in ["x", "hop", "hopT", "acc", "speed", "fly", "p", "taut", "tautT", "time", "slip", "sw", "v", "ev", "fall", "dist", "vel", "water", "slosh", "sv", "msg"]:
		if G.has(k): out[k] = G[k]
	var e = J.cl(J.G.get("$"), null, ["#sports"])
	if e != null: J.mc(J.gp(e, "classList"), "remove", ["on"]); J.sp(e, "innerHTML", "")
	return out

func sports(_t) -> void:
	mod = "sports"
	var live = J.G.Sports
	var keepS = J.G.S; var S0 = keepS.duplicate(true)
	var tr = load_trans("sports", ["Sports"]).Sports
	var nm = load("res://native/sports.gd").new(); _keep_alive.append(nm); nm.run(null); var nat = J.G.Sports
	J.G["Sports"] = live
	for f in ["target", "athlete"]:
		for id in ["jump", "tug", "hang", "swim"]: check("Sports", nat, tr, f, [id])
	check("Sports", nat, tr, "st", [])
	if same(J.mc(J.gp(nat, "_n"), "panel", []), J.mc(J.gp(tr, "_n"), "panel", [])): ok += 1
	else: bad += 1; print("[xcheck-diff] Sports._n.panel")
	for cs in [["jump", 7], ["tug", 8], ["hang", 9], ["swim", 10]]:
		var a = _sp_sim(nat, cs[0], cs[1], S0); var b = _sp_sim(tr, cs[0], cs[1], S0)
		if same(a, b): ok += 1
		else:
			bad += 1
			for k in a: if not same(a[k], b.get(k)): print("[xcheck-diff] sports %s.%s nat=%s tr=%s" % [cs[0], k, str(a[k]).substr(0, 300), str(b.get(k)).substr(0, 300)])
		print("[xcheck-info] sports %s frames=%d phase=%s" % [cs[0], a.frames, a.phase])
	J.G["S"] = keepS; J.G["Sports"] = live
	_report()

func run_named(t, name: String) -> void: call(name, t)

# ---- L4：資料模塊指紋（GB_NONAT=1 同原生各跑一次，比 /tmp/L4/fp_*.json）----
func l4_fp(_t) -> void:
	var G = J.G; var fp = {}
	fp["STN_FG"] = G.STN_FG; fp["STN_FG_W"] = G.STN_FG_W; fp["STN_FG_H"] = G.STN_FG_H
	fp["STN_PROPS"] = G.STN_PROPS; fp["STN_AB_SRC"] = G.STN_AB_SRC; fp["STN_AB_NOLEG"] = G.STN_AB_NOLEG; fp["PT_IMG_SRC"] = G.PT_IMG_SRC
	var keys = J.gp(G.PG_GHOSTS, "keys"); fp["PG_keys"] = keys
	for k in keys + ["n30_hantugalah"]:
		fp["GH_" + k] = G.GHOSTS.get(k); fp["SK_" + k] = G.SKILLS.get(k); fp["EN_" + k] = G.ENEMY_T.get(k)
		fp["CH_" + k] = J.gp(J.gp(G.ART, "CHAR_H"), k); fp["SPR_" + k] = J.t(J.gp(G.SPR, k))
		var L = G.get("L"); var g = G.GHOSTS.get(k)
		if g != null: for f in ["name", "title", "lore", "say", "trait"]: fp["L_%s_%s" % [k, f]] = J.str(J.cl(L, null, [g.get(f)]))
	for k in G.STN_AB_SRC: fp["SPRAB_" + k] = J.t(J.gp(G.SPR, k)); fp["SRCAB_" + k] = J.gp(G.get("SPR_SRC"), k)
	# STN_FG 函數
	var sites = G.STN_FG.keys(); var out = []
	for s in sites:
		for i in range(-1, 6):
			out.append(J.cl(G.STN_FG_list, null, [s, float(i)]).size())
			out.append(J.cl(G.STN_FG_list, null, [s, float(i), 700.0]).size())
	fp["fg_list"] = out
	var it = G.STN_FG[sites[0]][0][0]
	var im1 = J.cl(G.STN_FG_img, null, [it]); var im2 = J.cl(G.STN_FG_img, null, [it])
	fp["fg_img_same"] = im1 == im2; fp["fg_img_src"] = J.gp(im1, "src")
	var mode = "nonat" if OS.has_environment("GB_NONAT") else "nat"
	var f = FileAccess.open("/tmp/L4/fp_%s.json" % mode, FileAccess.WRITE); f.store_string(JSON.stringify(fp, " ", true)); f.close()
	print("[xcheck] l4_fp written ", mode, " natives=", JSRun.native_used)
