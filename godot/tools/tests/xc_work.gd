# L1 對照：daily_work（崗位打工）原生 vs 轉譯版（同一進程）
# 畫圖：每種角色（有手／冇手網格／拆唔開嘅特別鬼）× 每個動作，逐格錄低全部畫圖指令比；
# 排班：同一個隨機種子行 drawWorker（經 ART.drawChar → DAILY），比畫圖同排班狀態。
# ["gdrun","res://tools/tests/xc_work.gd","run"]
extends RefCounted

var ok := 0
var bad := 0
var keep := []
var tally := {}

static func _ser(r) -> String: return load("res://tools/tests/xc_l4.gd").ser_rec(r)
func _cmp(name: String, x: String, y: String) -> void:
	if x == y: ok += 1; return
	bad += 1; tally[name.get_slice(" ", 0)] = tally.get(name.get_slice(" ", 0), 0) + 1
	if bad <= 8:
		var i = 0
		while i < mini(x.length(), y.length()) and x[i] == y[i]: i += 1
		var st = maxi(0, i - 200)
		print("[wdiff] %s @%d/%d,%d\n nat=…%s\n tr =…%s" % [name, i, x.length(), y.length(), x.substr(st, 420), y.substr(st, 420)])

static func _work_daily() -> Dictionary:
	var o = {}
	for k in J.G.DAILY: if String(k).begins_with("work_"): o[k] = J.G.DAILY[k]
	return o

static func _types() -> Array:
	var LD = J.G.LIMBS_DATA; var RIG = J.gp(J.G.MeshAnim, "RIG"); var so = J.G.sprOk
	var okf = func(k): return J.t(J.cl(so, null, [k]))
	var arm = []; var mesh = []
	var ids = RIG.keys(); ids.sort()
	for id in ids:
		var C = J.gp(J.gp(LD, "chars"), id)
		if J.t(C) and okf.call(id + "__body") and okf.call(id + "__arm") and not (J.t(J.gp(C, "still")) and J.iter(J.gp(C, "still")).has("head")): arm.append(id)
		elif okf.call(id): mesh.append(id)
	var out = []
	for x in ["laojiang", "zhiren", "eguiking", "egui", "toyol", "pocong", "penanggal"]: if not out.has(x): out.append(x)
	for i in mini(4, arm.size()): if not out.has(arm[i]): out.append(arm[i])
	for i in mini(2, mesh.size()): if not out.has(mesh[i]): out.append(mesh[i])
	print("[xcwork] arm=", arm.size(), " mesh=", mesh.size(), " types=", out)
	return out

const NAMES := ["chop", "haul", "crate", "rest", "reap", "plant", "hammer", "sand", "sight", "knead", "steam", "sneak", "coins", "push", "inspect", "burn", "march", "salute", "drill", "boo", "grimace", "blow"]
const SPECIAL_H := {"toyol": 46.0, "pocong": 54.0, "penanggal": 52.0}

func _draw_all(DA: Dictionary, WK, types: Array, step: float) -> Array:
	var out = []
	var SP = J.G.get("SPECIAL")
	for ty in types:
		var spc = J.t(J.mc(SP, "has", [ty]))
		for fi in 2:
			var flip = fi == 1
			for n in NAMES:
				var v = J.mc(WK, "defaults", [n, ty, 3.0 + fi])
				if n == "burn" and fi == 1: v["walk"] = 1.0; v["stand"] = [-40.0, 12.0]
				var D = J.num(J.mc(J.gp(J.gp(WK, "ACT"), n), "dur", [v]))
				var at = 0.0
				while at <= D + 0.05:
					var r = Recorder.new(); var ctx = Ctx.new(r, Transform2D.IDENTITY)
					var sc = 0.62 if fi == 0 else 0.9
					var a = {"type": ty, "x": 180.0, "y": 600.0, "s": sc, "H": (SPECIAL_H.get(ty, 50.0) if spc else 98.0) * sc, "o": {"t": 10.0 + at, "at": at, "wv": v, "wkey": 7.0, "wtarget": [60.0, -20.0] if flip else null}, "faceRight": not flip, "solid": spc}
					ctx.save(); var res = J.cl(DA["work_" + n], null, [ctx, a]); ctx.restore()
					out.append(["%s/%s/%d@%.2f" % [ty, n, fi, at], "%s %s" % [J.str(res), _ser(r)]])
					at += step
	return out

func _sched(WK, types: Array) -> Array:
	var out = []; seed(777)
	var posts = ["wood", "rice", "plank", "bun", "store", "boss", "camp"]
	var spots = []
	for i in types.size():
		spots.append({"g": {"k": types[i], "id": 100.0 + i}, "x": 60.0 + (i % 5) * 70, "y": 300.0 + (i / 5) * 90, "flip": i % 2 == 1, "ph": i * 0.37, "post": posts[i % posts.size()]})
	var info = {"furnace": [200.0, 250.0]}
	var t = 50.0
	for f in 30 * 60:
		for s in spots:
			if f % 6 == (int(s.g.id) % 6):
				var r = Recorder.new(); var ctx = Ctx.new(r, Transform2D.IDENTITY)
				var st = J.mc(WK, "drawWorker", [ctx, s, t, 0.62, info if f > 300 else {}])
				out.append(["sched f%d %s" % [f, s.g.k], "%s %.4f %.4f %s %s" % [J.str(st.act), J.num(st.t0), J.num(st.dur), JSON.stringify(st.v), _ser(r)]])
		t += 1.0 / 30
	return out

func run(_t) -> void:
	ok = 0; bad = 0
	var NW = load("res://native/daily_work.gd"); NW.new().run(null)
	var DN = _work_daily(); var WKn = J.G.WORK
	var tr = load("res://jsgen/daily_work.gd").new(); keep.append(tr); tr.run(null)
	var DT = _work_daily(); var WKt = J.G.WORK
	var types = _types()
	var nat_ok = DN.size() == NAMES.size() and DN["work_chop"] != DT["work_chop"]
	print("[xcwork] nat=%s keys n=%d t=%d" % [nat_ok, DN.size(), DT.size()])
	var step = float(OS.get_environment("GB_XW_STEP")) if OS.get_environment("GB_XW_STEP") != "" else 0.25
	NW.reset(); var A = _draw_all(DN, WKn, types, step)
	var tr2 = load("res://jsgen/daily_work.gd").new(); keep.append(tr2); tr2.run(null); var DT2 = _work_daily(); var WKt2 = J.G.WORK
	var B = _draw_all(DT2, WKt2, types, step)
	if A.size() != B.size(): bad += 1; print("[wdiff] size %d %d" % [A.size(), B.size()])
	for i in mini(A.size(), B.size()): _cmp(A[i][0], A[i][1], B[i][1])
	print("[xcwork] draw frames=%d bad=%d tally=%s" % [A.size(), bad, str(tally)]); tally = {}
	# 排班：DAILY 換成各自嗰套
	var nb = bad
	NW.reset(); NW.new().run(null); var WKn2 = J.G.WORK
	for k in DN: J.G.DAILY[k] = J.G.DAILY[k]
	var SA = _sched(WKn2, types)
	var tr3 = load("res://jsgen/daily_work.gd").new(); keep.append(tr3); tr3.run(null)
	var SB = _sched(J.G.WORK, types)
	if SA.size() != SB.size(): bad += 1; print("[wdiff] sched size %d %d" % [SA.size(), SB.size()])
	for i in mini(SA.size(), SB.size()): _cmp(SA[i][0], SA[i][1], SB[i][1])
	var acts = {}
	for l in SA: acts[l[1].get_slice(" ", 0)] = true
	print("[xcwork] sched lines=%d bad=%d acts=%s" % [SA.size(), bad - nb, str(acts.keys())])
	NW.reset(); NW.new().run(null)
	print("[xcheck] daily_work ok=%d bad=%d" % [ok, bad])
