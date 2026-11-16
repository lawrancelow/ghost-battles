# skits 原生對照：SKITS 資料（品牌替換後；give 比結果）、rwd、Skits.ok／st／pickNext（同種子）
extends "res://tools/tests/xc_l1.gd"

static func _strip_give(o):
	if o is Dictionary:
		var d = {}
		for k in o: if k != "give": d[k] = _strip_give(o[k])
		return d
	if o is Array: return o.map(func(x): return _strip_give(x))
	return o

func skits(_t) -> void:
	mod = "skits"
	var keys = ["SKITS", "Skits", "rwd"]
	var nat = {}; for k in keys: nat[k] = J.G[k]
	var keepTh = J.G.Theater
	var tr = load_trans("skits", keys + ["Theater"])
	J.G["Theater"] = keepTh
	var b = FileAccess.get_file_as_string("res://tools/jsgd/build.sh")
	var m = RegEx.create_from_string("for\\(const \\[a,b\\] of (\\[\\[.*?\\]\\])\\)").search(b)
	var all = JSON.parse_string(m.get_string(1)) + _subs()
	eq("SKITS (冇 give)", _strip_give(nat.SKITS), _sub(_strip_give(tr.SKITS), all))
	var S0: Dictionary = J.G.S.duplicate(true)
	for lv in [1.0, 7.0, 18.0, 40.0]:
		J.G.S.lv = lv
		for n in [4.0, 6.0, 14.0, 18.0, 20.0, 22.0, 40.0]: eq("rwd %s lv%s" % [n, lv], J.cl(nat.rwd, null, [n]), J.cl(tr.rwd, null, [n]))
		for i in nat.SKITS.size():
			var c = nat.SKITS[i].get("choice"); var tc = tr.SKITS[i].get("choice")
			if not (c is Dictionary): continue
			for k in ["a", "b", "c"]:
				if not c.has(k): continue
				var tg = tc[k].get("give")
				eq("give %s.%s" % [nat.SKITS[i].id, k], JSON.stringify(_give(c[k])), JSON.stringify(J.cl(tg, null, []) if tg != null else null))
	J.G["S"] = S0.duplicate(true)
	for sk in nat.SKITS: eq("ok " + sk.id, J.mc(nat.Skits, "ok", [sk]), J.mc(tr.Skits, "ok", [_find(tr.SKITS, sk.id)]))
	# 唔同進度：清晒／淨係序章
	for variant in ["all", "pro"]:
		for sd in [3, 11, 77]:
			var res = []
			for C in [nat, tr]:
				var S = S0.duplicate(true); J.G["S"] = S
				if variant == "pro": S.seen = {"prologue_sys": true}
				else:
					for sk in nat.SKITS: if sk.get("need") is Array: for id in sk.need: S.seen[id] = true
				seed(sd)
				var picks = []
				for r in 50:
					var p = J.mc(C.Skits, "pickNext", [])
					var id = J.gp(p, "id") if p != null else null
					picks.append(id)
					if id != null: var s = J.mc(C.Skits, "st", []); s.seen[id] = 1.0; s.cyc[id] = 1.0; s.last = id
				res.append([picks, S.skit])
			eq("pickNext %s seed%d" % [variant, sd], res[0], res[1])
	J.G["S"] = S0
	_report()

static func _find(list, id):
	for x in list: if x.id == id: return x
	return null
func _give(o):
	var g = o.get("give")
	if not (g is Dictionary): return null
	var r = {}
	for k in g.__rwd: r[k] = J.cl(J.G.rwd, null, [g.__rwd[k]])
	return r
