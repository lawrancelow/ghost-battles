# L1：station_foes／station 原生對照（同一 seed、同一假 Turf、假時鐘；逐格比狀態、飄字、繪圖指令）
extends "res://tools/tests/xc_l1b.gd"

var flog: Array = []

static func _norm(s: String) -> String:
	var re = RegEx.new(); re.compile("[A-Za-z0-9_]*#-?[0-9]+")
	return re.sub(s, "OBJ", true)

# 假 Turf：地圖座標 0..1；P 轉畫面
func _turf(rdist: bool, rect: bool) -> Dictionary:
	var lay = []; var sd = []
	var roles = ["light", "sound", "cold", "paper", "light", "face"]
	for i in 6:
		lay.append({"x": 0.12 + i * 0.13, "y": 0.5 + (0.04 if i % 2 else -0.03)})
		sd.append({"role": roles[i], "build": 0.0, "staff": (1.0 if i == 2 else null)} if i != 4 else ({"role": "x", "build": 2.0}))
	var W = {"box": {"x": 10.0, "y": 20.0, "w": 840.0, "h": 600.0}, "lay": {"posts": lay}, "sd": {"posts": sd}, "walkers": [], "bosses": [{"id": "b1", "x": 0.55, "y": 0.62, "hid": false}, {"id": "b2", "x": 0.2, "y": 0.4, "hid": true}], "_foeRole": "other"}
	W["wp"] = func(_t, a): var w = a[0]; return [J.num(w.x) + (J.num(a[1]) if a.size() > 1 else 0.0) * J.num(w.dir), J.num(w.y)]
	W["dist"] = func(_t, a): return Vector2(J.num(a[0][0]) - J.num(a[1][0]), J.num(a[0][1]) - J.num(a[1][1])).length()
	if rdist: W["rdist"] = func(_t, a): return Vector2(J.num(a[0][0]) - J.num(J.gp(a[1], "x")), (J.num(a[0][1]) - J.num(J.gp(a[1], "y"))) * 1.2).length()
	if rect: W["rect"] = func(_t, a): var sp = a[0]; return [J.num(sp.x) - 0.05, J.num(sp.y) - 0.06, J.num(sp.x) + 0.05, J.num(sp.y) + 0.02]
	W["alive"] = func(_t, a): var w = a[0]; return J.num(w.hp) > 0 and not J.t(w.get("gone"))
	W["float"] = func(_t, a): flog.append(["float", a[0], a[1], a[2], a[3]]); return null
	W["bpos"] = func(_t, a): return [a[0].x, a[0].y]
	W["P"] = func(_t, a): return [10.0 + J.num(a[0]) * 840.0, 20.0 + J.num(a[1]) * 600.0]
	W["staffMul"] = func(_t, a): return {"named": J.gp(a[0], "staff") == 1.0}
	return W

func _walker(i: int) -> Dictionary:
	return {"x": 0.95 - i * 0.07, "y": 0.5 + (i % 3) * 0.02, "dir": -1.0, "hp": 100.0, "max": 100.0, "spd": 1.0, "seed": i * 1.3, "gone": false, "say": null}

# 把狀態變成可比較嘅樣（物件 key／tgt／by → 位置）
func _snap(S, W) -> String:
	var posts = W.sd.posts; var ws = W.walkers; var bs = W.bosses
	var idx = func(o):
		for i in posts.size(): if is_same(posts[i], o): return "post%d" % i
		for i in ws.size(): if is_same(ws[i], o): return "w%d" % i
		for i in bs.size(): if is_same(bs[i], o): return "b%d" % i
		return str(o)
	var seals = []
	for s in J.gp(S, "seals"): seals.append([idx.call(s.tgt), s.kind, s.i, s.t, s.dur, idx.call(s.by), s.seed])
	var maps = []
	for k in ["pause", "salt"]:
		var e = []
		for kv in J.mc(J.gp(S, k), "entries", []): e.append([idx.call(kv[0]), kv[1]])
		maps.append(e)
	var beams = []
	for b in J.gp(S, "beams"): beams.append([idx.call(b.w), b.dir, b.t, b.dur, b.r, b.x, b.y])
	var wsn = []
	for w in ws:
		var f = w.get("foe")
		var fs = null
		if f is Dictionary:
			fs = f.duplicate(); if fs.get("chant") is Dictionary: fs.chant = fs.chant.duplicate(); fs.chant.tgt = idx.call(fs.chant.tgt)
		wsn.append([w.hp, w.max, w.get("spd"), w.get("block"), w.get("say"), w.get("n"), w.get("award"), fs])
	return JSON.stringify([seals, maps, beams, J.gp(S, "saltFx"), J.gp(S, "brk"), J.gp(S, "wave"), wsn])

func _run_sf(SF, seed_: int, rdist: bool, rect: bool, frames: int) -> Array:
	var out = []
	flog = []
	seed(seed_); J.test_perf = 123456.0; J.test_clock = 1.7e12
	J.mc(SF, "reset", [])
	var W = _turf(rdist, rect)
	var q = {"made": 1.0}
	for lv in [1.0, 3.0, 5.0, 7.0, 12.0, 20.0]:
		out.append(["table", lv, J.mc(SF, "spawnTable", [lv])])
	for i in 9:
		q.made = 1.0 if i % 4 == 0 else q.made + 1
		out.append(["roll", J.mc(SF, "roll", [12.0, q]), q.get("_foeN"), J.gp(J.gp(SF, "state"), "wave")])
	var ids = ["taoist", "hunter", "streamer", "taoist", null, "hunter", null]
	for i in ids.size():
		var w = _walker(i)
		if ids[i] != null: J.mc(SF, "decorate", [w, ids[i]])
		W.walkers.append(w)
	var roles = ["light", "sound", "cold", "other"]
	for fr in frames:
		J.test_perf = 123456.0 + fr * 33.0; J.test_clock = 1.7e12 + fr * 33.0
		for w in W.walkers:
			if not J.t(w.get("gone")) and not (J.num(w.get("block")) > 0): w.x = J.num(w.x) - 0.004 * J.num(w.spd)
			if J.num(w.get("block")) > 0: w.block = maxf(0.0, J.num(w.block) - 1.0 / 30)
			if w.get("say") is Dictionary: w.say.t = J.num(w.say.t) - 1.0 / 30; if J.num(w.say.t) <= 0: w.say = null
		if fr % 7 == 3:
			for k in W.walkers.size():
				var w = W.walkers[k]
				if not J.t(W.alive.call(null, [w])): continue
				W._foeRole = roles[(fr + k) % 4]
				var d = J.mc(SF, "onHit", [w, 3.0 + (fr % 5) * 2.0, {"force": true} if fr % 31 == 3 else {}, W])
				w.hp = J.num(w.hp) - d
				out.append(["hit", fr, k, d])
		if fr == 120: W.walkers[0].gone = true
		if fr == 150: W.sd.posts[1] = {"role": "sound", "build": 0.0}
		if fr == 200: W.bosses.remove_at(0)
		J.mc(SF, "update", [1.0 / 30, W])
		for p in W.sd.posts: out.append(["q", fr, J.mc(SF, "isSealed", [p]), J.mc(SF, "isPaused", [p]), J.mc(SF, "blocks", [p]), J.mc(SF, "devMul", [p])])
		for b in W.bosses: out.append(["qb", fr, J.mc(SF, "isSealed", [b])])
		if fr % 9 == 0:
			out.append(["snap", fr, _snap(J.gp(SF, "state"), W)])
			out.append(["draw", fr, _norm(_rec(func(): return J.mc(SF, "draw", [_ctx(), W])))])
		if fr % 23 == 0:
			for k in W.walkers.size():
				for o in [{"flip": true}, {"flip": false, "cast": true}, {"walk": true}, null]:
					out.append(["body", fr, k, _norm(_rec(func(): return J.mc(SF, "drawBody", [_ctx(), W.walkers[k], 60.0, 1.7 + fr * 0.03, o])))])
	out.append(["fu", _norm(_rec(func(): return J.mc(SF, "drawFu", [_ctx(), 100.0, 50.0, 20.0, 50.0, 2.3, 1.1, 0.7])))])
	out.append(["flog", flog.duplicate(true)])
	J.test_perf = -1.0; J.test_clock = -1.0
	return out

func station_foes(_t) -> void:
	mod = "station_foes"
	var nat = J.G.StnFoes
	var tr = load_trans("station_foes", ["StnFoes"]).StnFoes
	eq("FOES", JSON.stringify(nat.FOES), JSON.stringify(J.gp(tr, "FOES")))
	eq("RES", nat.RES, J.gp(tr, "RES"))
	# 有冇 SPR foe 圖：兩種都試
	var SP = J.G.get("SPR"); var keep = {}
	for k in ["foe_taoist", "foe_hunter", "foe_streamer", "vfx_seal"]: keep[k] = J.gp(SP, k)
	for pass_ in 2:
		if pass_ == 1:
			for k in keep: if SP is Dictionary: SP.erase(k)
		for cfg in [[11, true, true], [12, false, false], [13, true, false], [14, false, true]]:
			var a = _run_sf(nat, cfg[0], cfg[1], cfg[2], 260)
			var b = _run_sf(tr, cfg[0], cfg[1], cfg[2], 260)
			eq("len %s" % [cfg], a.size(), b.size())
			for i in mini(a.size(), b.size()):
				eq("%d/%s %s %s" % [pass_, cfg[0], a[i][0], a[i][1] if a[i].size() > 1 else ""], a[i], b[i])
	for k in keep: if keep[k] != null and SP is Dictionary: SP[k] = keep[k]
	J.mc(nat, "reset", [])
	_report()

# ---------------- station：同一份存檔、同一 seed、假時鐘 ----------------
var slog: Array = []
func _st_stubs() -> Dictionary:
	var keep = {}
	for k in ["Fx", "Story", "Sound", "UI"]: keep[k] = J.G.get(k)
	J.G["Fx"] = {"toast": func(_t, a): slog.append(["toast", J.str(a[0])]); return null}
	J.G["Story"] = {"queue": func(_t, a): slog.append(["queue", a[0]]); return null}
	J.G["Sound"] = {"play": func(_t, _a): return null, "setMode": func(_t, a): slog.append(["mode", a[0]]); return null}
	J.G["UI"] = {"sheet": func(_t, a): slog.append(["sheet", a[0], a[1]]); return null, "close": func(_t, _a): return null}
	return keep
static func _gclean(o):
	if o is Dictionary:
		var d = {}
		for k in o: d[k] = _gclean(o[k]) if k != "def" else "<def>"
		return d
	if o is Array: return o.map(func(x): return _gclean(x))
	if o is Callable: return "<fn>"
	return o
func _run_st(ST, S0: Dictionary, seed_: int, steps: int) -> Array:
	var out = []; slog = []
	J.G["S"] = S0.duplicate(true); var S = J.G.S
	seed(seed_); J.test_clock = 1.79e12; J.test_perf = 5000.0
	if J.gp(S, "seen") is Dictionary: S.seen["ch1_end"] = 1.0
	S.erase("station")
	var gs = []
	for g in S.ghosts:
		if g.k != "afu": g.post = null; g.erase("tiredUntil"); gs.append(g)
	out.append(["maps", ST.MAPS.map(func(m): return J.mc(ST, "open", [m]))])
	out.append(["st", _gclean(J.mc(ST, "st", []))])
	var ids = ["office", "flat", "bus"]
	var k = 0
	for mi in 3:
		for pi in 4:
			if k < gs.size() and (mi == 0 or k % 2 == 0): J.mc(ST, "assign", [ids[mi], float(pi), gs[k].id]); k += 1
	out.append(["free", J.mc(ST, "freeGhosts", []).map(func(g): return g.id)])
	for i in steps:
		J.test_clock += (60000.0 if i % 10 else 3600000.0 * 2.5) if i != 17 else 9 * 3600000.0
		J.mc(ST, "tick", [])
		var m = J.mc(ST, "ms", ["office"])
		if i == 3: J.sp(m.enemy, 2.0, {"k": "egui", "hp": 100.0, "at": J.test_clock}); J.sp(m.enemy, 3.0, {"k": "bryan", "hp": 220.0, "at": J.test_clock})
		if i % 4 == 1:
			for pi in 4: out.append(["hit", i, pi, _gclean(J.mc(ST, "hitRival", ["office", float(pi)]))]); J.test_clock += 1500.0
		if i % 5 == 2: out.append(["boost", i, J.mc(ST, "boost", ["office", float(i % 4)])])
		if i % 6 == 0: out.append(["sim", _gclean(J.mc(ST, "simOne", [ST.MAPS[0], m]))])
		if i == 11: J.mc(ST, "assign", ["office", 1.0, null]); J.mc(ST, "assign", ["office", 0.0, gs[0].id if gs.size() else null])
		out.append(["state", i, _gclean(S.station), [J.mc(ST, "share", [m]), J.mc(ST, "status", [m])]])
		if i % 7 == 0:
			out.append(["panel", J.mc(ST, "panelHTML", [])]); out.append(["entry", J.mc(ST, "entryHTML", [])])
			out.append(["power", gs.map(func(g): return J.mc(ST, "power", [g])), J.mc(ST, "legLv", [m, gs[0].id if gs.size() else 0.0])])
	# 實況：直接設欄位，逐格 step＋draw（唔開 DOM）
	var L = J.gp(ST, "Live"); var def = J.mc(ST, "mapOf", ["office"])
	J.sp(L, "def", def); J.sp(L, "on", true); J.sp(L, "walkers", []); J.sp(L, "fx", []); J.sp(L, "spawnAcc", 6.5); J.sp(L, "t", 0.0)
	J.sp(L, "W", 450.0); J.sp(L, "H", 975.0); J.sp(L, "ctx", _ctx()); J.sp(L, "camX", 0.0); J.sp(L, "_sky", null); J.sp(L, "_it", null)
	J.sp(L, "camX", J.mc(L, "maxCam", []) * 0.6)
	for fr in 400:
		J.test_clock += 33.0
		J.mc(L, "step", [1.0 / 30])
		if fr % 40 == 5:
			out.append(["live", fr, _gclean(J.gp(L, "walkers")), _gclean(J.gp(L, "fx"))])
			out.append(["ldraw", fr, _norm(_rec(func(): J.sp(L, "ctx", _ctx()); J.sp(L, "_sky", null); return J.mc(L, "draw", [])))])
	J.sp(L, "on", false)
	out.append(["slog", _gclean(slog)])
	J.test_clock = -1.0; J.test_perf = -1.0
	return out

func station(_t) -> void:
	mod = "station"
	var nat = J.G.Station
	var tr = load_trans("station", ["Station"]).Station
	var keepS = J.G.S; var S0: Dictionary = keepS.duplicate(true)
	var keep = _st_stubs()
	eq("MAPS", JSON.stringify(nat.MAPS), JSON.stringify(J.gp(tr, "MAPS"))); eq("TUNE", nat.TUNE, J.gp(tr, "TUNE"))
	for sd in [21, 22, 23]:
		var a = _run_st(nat, S0, sd, 40); var b = _run_st(tr, S0, sd, 40)
		eq("len", a.size(), b.size())
		for i in mini(a.size(), b.size()): eq("%d %s %s" % [sd, a[i][0], a[i][1] if a[i].size() > 1 and not (a[i][1] is Dictionary or a[i][1] is Array) else ""], a[i], b[i])
	for k in keep: J.G[k] = keep[k]
	J.G["S"] = keepS
	_report()
