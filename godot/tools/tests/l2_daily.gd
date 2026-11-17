# L2 對照：daily_plaza／daily_town 原生 vs 轉譯版（同一進程；轉譯版另外載一份，畫圖指令用錄製器逐條比）
# ["gdrun","res://tools/tests/l2_daily.gd","plaza"] / "town"
extends RefCounted

var ok := 0
var bad := 0
var keep := []

static func _rec_ctx():
	var r = Recorder.new()
	return [r, Ctx.new(r, Transform2D.IDENTITY)]
static func _ser(r) -> String: return load("res://tools/tests/xc_l4.gd").ser_rec(r)
func _cmp(name: String, x: String, y: String) -> void:
	if x == y: ok += 1; return
	bad += 1
	if bad <= 20:
		var i = 0
		while i < mini(x.length(), y.length()) and x[i] == y[i]: i += 1
		var st = maxi(0, i - 160)
		print("[ddiff] %s @%d/%d,%d\n nat=…%s\n tr =…%s" % [name, i, x.length(), y.length(), x.substr(st, 360), y.substr(st, 360)])

# 換 DAILY 入面某啲動作（原生／轉譯）
static func _daily_set(names: Array, src: Dictionary) -> void:
	var DA = J.G.DAILY
	for n in names: DA[n] = src[n]
static func _daily_get(prefix: String) -> Dictionary:
	var o = {}
	for k in J.G.DAILY: if String(k).begins_with(prefix): o[k] = J.G.DAILY[k]
	return o

# ---------------- 廣場 ----------------
static func _ser_ag(ag: Dictionary) -> Dictionary:
	var o = {}
	for k in ag:
		var v = ag[k]
		if k in ["W", "g"]: continue
		if k == "lock": o[k] = J.gp(v, "kind") if v is Dictionary else null; continue
		if k == "cur" or k == "_bkC":
			o[k] = [J.gp(v, "act"), J.gp(v, "d"), J.gp(v, "go")] if v is Dictionary else null; continue
		if k == "q":
			var qa = []
			for s in v: qa.append([J.gp(s, "act"), J.gp(s, "d"), J.gp(s, "go"), J.gp(s, "fn") != null])
			o[k] = qa; continue
		if k == "style" or k == "pl":
			var so = {}
			for kk in v: so[kk] = J.gp(v[kk], "id") if v[kk] is Dictionary else v[kk]
			o[k] = so; continue
		if k == "face" or k == "want": o[k] = J.t(v); continue
		o[k] = v
	return o
static func _ser_w(W: Dictionary) -> String:
	var L = []
	for a in W.list: L.append(_ser_ag(a))
	var G = []
	for g in W.games:
		var go = {}
		for k in g: go[k] = J.gp(g[k], "id") if g[k] is Dictionary else g[k]
		G.append(go)
	return JSON.stringify({"L": L, "G": G, "wet": W.wet, "socT": W.socT, "heroT": W.heroT})

func plaza(_t) -> void:
	ok = 0; bad = 0
	var NP = load("res://native/daily_plaza.gd")
	var dn = _daily_get("plaza_"); var PLn = J.G.PlazaLife
	var tr = load("res://jsgen/daily_plaza.gd").new(); keep.append(tr); tr.run(null)
	var PLt = J.G.PlazaLife; var dt_ = _daily_get("plaza_")
	_daily_set(dn.keys(), dn)
	J.G["PlazaLife"] = PLn
	var kinds = ["xiaozhi", "egui", "eguiking", "xiaogui", "toyol", "laojiang", "zombie", "shuigui", "pontianak", "pocong", "penanggal", "mengpo", "youhun", "baiwu", "heiwu", "niutou", "mamian", "huang", "zhiren", "tianhua", "xiaozhi", "egui"]
	var ghosts = []
	for i in kinds.size(): ghosts.append({"id": "pz%d" % i, "k": kinds[i], "name": kinds[i], "q": "藍", "lv": 1.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	var S0 = J.G.S; var saveS = {"bld": {"wood": 1.0}}
	var NF = int(OS.get_environment("GB_L2_PF")) if OS.has_environment("GB_L2_PF") else 900
	var outs = []
	for native in [true, false]:
		_daily_set(dn.keys(), dn if native else dt_)
		var SPn = load("res://native/special.gd")   # 特別鬼（Toyol 等）有按 key 嘅狀態，兩邊各自由零開始
		SPn.states.clear(); SPn.uid = 0; SPn.epoch = 0; SPn.last_call = 0.0; SPn.last_clean = 0.0; SPn.frame_id += 1000   # GC 係固定 40 格暫存，唔好清；frame_id 跳號令舊格失效
		NP.test_r0 = true   # 轉譯版 R = Math.random 係空值（轉譯錯誤），原生對照時都用 0
		J.G["S"] = saveS
		seed(42)
		var V = {"plaza": null, "hero": {"x": 195.0, "y": 640.0, "walking": true}, "bubble": null}
		var st_h = []; var dr_h = []; var t = 100.0
		for f in NF:
			t += 1.0 / 30
			V.hero["x"] = 195 + sin(t * 0.3) * 150; V.hero["walking"] = (f / 60) % 2 == 0
			if f == 300: ghosts.remove_at(3)   # 有鬼被派去打工：離開廣場
			if f == 500: ghosts.append({"id": "pzN", "k": "heiwu", "name": "heiwu", "q": "藍", "lv": 1.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
			if f == 420: V["bubble"] = {"id": "pz5", "hero": false}
			var rc = _rec_ctx(); var items = []; var vis = []
			if native: NP.frame(V, ghosts, items, vis, rc[1], t)
			else: J.cl(J.gp(PLt, "frame"), null, [V, ghosts, items, vis, rc[1], t])
			for it in items: J.cl(it.f, null, [])
			if f % 3 == 0:
				var s1 = _ser(rc[0]); dr_h.append([s1.md5_text(), s1.length(), s1 if f % 30 == 0 else ""])
				st_h.append(_ser_w(V.plaza))
		outs.append([st_h, dr_h])
	J.G["S"] = S0
	NP.test_r0 = false
	_daily_set(dn.keys(), dn)
	var nst = outs[0][0]; var tst = outs[1][0]; var ndr = outs[0][1]; var tdr = outs[1][1]
	for side in [0, 1]:
		var js = JSON.parse_string(outs[side][0][0]); var ids = []
		if js is Dictionary and js.get("L") is Array:
			for a in js.L: ids.append("%s:%s:%s" % [a.id, a.k, "z" if a.has("_zpos") else ""])
		print("[l2ids] side%d n=%d %s" % [side, ids.size(), " ".join(ids)])
	var first_s = -1; var first_d = -1
	for i in nst.size():
		if nst[i] != tst[i]:
			if first_s < 0: first_s = i; _cmp("plaza state f%d" % (i * 3), nst[i], tst[i])
			else: bad += 1
		else: ok += 1
		if ndr[i][0] != tdr[i][0]:
			if first_d < 0:
				first_d = i
				var j = i
				while j < ndr.size() and ndr[j][2] == "": j += 1
				if j < ndr.size(): _cmp("plaza draw f%d (detail f%d)" % [i * 3, j * 3], ndr[j][2], tdr[j][2])
				else: bad += 1
			else: bad += 1
		else: ok += 1
	print("[l2daily] plaza frames=%d agents=%d ok=%d bad=%d firstState=%d firstDraw=%d" % [NF, ghosts.size(), ok, bad, first_s * 3, first_d * 3])

# ---------------- 小鎮 ----------------
const TYPES := {"town_ken_": ["npc_ken"], "town_boss_": ["npc_boss"], "town_guard_": ["npc_guard"], "town_auntie_": ["npc_auntie"], "office_boss_": ["npc_boss"], "office_ken_": ["npc_ken"], "office_it_": ["npc_it"], "office_auntie_": ["npc_auntie"],
	"town_paper_": ["xiaozhi"], "town_haggle_": ["xiaogui"], "town_exch_": ["baiwu"], "town_food_": ["eguiking"], "town_greet": ["xiaozhi", "xiaogui", "baiwu", "eguiking", "egui"], "town_walk": ["youhun", "egui", "zombie", "shuigui", "baiwu"], "town_bump": ["youhun", "egui", "zombie", "shuigui"], "town_look": ["youhun", "egui", "zombie", "shuigui"]}
static func _types(act: String) -> Array:
	for p in TYPES: if act.begins_with(p): return TYPES[p]
	return ["npc_ken"]
func town(_t) -> void:
	ok = 0; bad = 0
	var dn = _daily_get("town_"); dn.merge(_daily_get("office_"))
	var TN = J.G.TOWN
	var tr = load("res://jsgen/daily_town.gd").new(); keep.append(tr); tr.run(null)
	var TT = J.G.TOWN; var dt_ = _daily_get("town_"); dt_.merge(_daily_get("office_"))
	J.G["TOWN"] = TN; _daily_set(dn.keys(), dn)
	var names = dn.keys(); names.sort()
	var ats = [0.0, 0.17, 0.5, 0.83, 1.12, 1.33, 1.6, 1.95, 2.3, 2.55, 2.85, 3.1, 3.37, 3.8, 4.6, 5.05, 6.2, 6.25, 7.4]
	var props = [null, {"kind": "lanternW"}, {"kind": "lanternR", "big": 1.3}, {"kind": "bag"}, {"kind": "phone", "seed": 0.4, "lines": ["喂？", "好", "得"]}, {"potDX": 22.0, "potDY": -30.0, "sorry": "唔好意思"}]
	var n = 0
	for act in names:
		for type in _types(act):
			for fr in [true, false]:
				for pi in props.size():
					if pi > 0 and not (act in ["town_walk", "town_bump", "town_look", "town_food_stir", "town_food_ladle", "town_food_taste"]): continue
					for walk in ([false, true] if act in ["town_guard_patrol", "town_auntie_mop", "town_walk", "town_greet"] else [false]):
						for at in ats:
							var res = []
							for src in [dn, dt_]:
								var rc = _rec_ctx(); var c = rc[1]
								var o = {"t": 3.7 + at * 0.9, "act": act, "at": at, "adur": 4.4 if at < 4.5 else 0.0, "walk": walk, "prop": props[pi], "quiet": at > 6.0}
								if at > 3.0 and at < 3.5: o["aw"] = 0.6
								var a = {"type": type, "x": 120.0, "y": 300.0, "s": 1.1, "H": 66.0, "o": o, "faceRight": fr, "solid": type.begins_with("npc_"),
									"shadow": func(_tt, aa): c.fillRect(J.num(aa[0]), 300.0, 2.0, 1.0); return null}
								var r = J.cl(src[act], null, [c, a])
								res.append(J.str(r) + "|" + _ser(rc[0]) + "|" + JSON.stringify(o))
							_cmp("%s/%s/fr%s/p%d/w%s/at%s" % [act, type, fr, pi, walk, at], res[0], res[1]); n += 1
	# 排程（tick／opts／npcTick／npcOpts）
	for id in ["npc_ken", "npc_boss", "npc_guard", "npc_auntie", "xiaozhi", "xiaogui", "baiwu", "eguiking", "nobody"]:
		var res = []
		for T in [TN, TT]:
			seed(77); var st = null; var lg = []
			for i in 1500:
				var el = (i / 97) % 4 != 3; var wk = (i / 211) % 3 == 1; var force = ["town_guard_sip", 3.3] if (i > 900 and i < 1000 and id == "npc_guard") else null
				st = J.cl(J.gp(T, "tick"), null, [st, id, 1.0 / 30, el, wk, force])
				if i % 5 == 0: lg.append(JSON.stringify(st) + JSON.stringify(J.cl(J.gp(T, "opts"), null, [st])))
			res.append("\n".join(lg))
		_cmp("tick:" + id, res[0], res[1])
	var res2 = []
	for T in [TN, TT]:
		seed(5); var lg = []
		var ns = []
		for spr in ["npc_boss", "npc_guard", "npc_ken", "npc_it", "npc_auntie"]: ns.append({"d": {"spr": spr}, "act": "idle", "fear": 0.0, "rx": null, "daily": null})
		for i in 1200:
			for nn in ns:
				nn["act"] = ["idle", "walk", "present", "read", "call", "pack", "doze", "brk_nap", "notes"][(i / 90 + ns.find(nn)) % 9]
				nn["fear"] = 40.0 if (i / 150) % 5 == 4 else 0.0
				nn["rx"] = {"t": 0.2, "k": ["sip", "numb", "jump"][(i / 70) % 3], "dur": 3.0} if (i / 40) % 4 == 1 else null
				nn["bub"] = (i / 33) % 2 == 0; nn["bubT"] = 1.0
				J.cl(J.gp(T, "npcTick"), null, [nn, 1.0 / 30, null])
				if i % 7 == 0: lg.append(JSON.stringify(nn.daily) + JSON.stringify(J.cl(J.gp(T, "npcOpts"), null, [nn])) + J.str(J.cl(J.gp(T, "actAnim"), null, [nn])))
		res2.append("\n".join(lg))
	_cmp("npcTick", res2[0], res2[1])
	_cmp("LIST", JSON.stringify(J.gp(TN, "LIST")), JSON.stringify(J.gp(TT, "LIST")))
	_cmp("ACT", JSON.stringify(J.gp(TN, "ACT")), JSON.stringify(J.gp(TT, "ACT")))
	J.G["TOWN"] = TN; _daily_set(dn.keys(), dn)
	print("[l2daily] town draws=%d ok=%d bad=%d" % [n, ok, bad])

# ---- 實玩 ----
func p_gs(_t) -> void: J.mc(J.G.GhostStreet, "open", [])
func p_gs_close(_t) -> void: J.mc(J.G.GhostStreet, "close", [])
func p_joss(_t) -> void: J.mc(J.G.JossFx, "play", [])
func p_plaza(_t) -> void:
	var W = J.gp(J.G.Village, "plaza")
	var o = []
	if W is Dictionary:
		for a in W.list: o.append([a.k, int(a.x), int(a.y), a.st, a.get("act")])
	print("[l2daily] plaza agents=", o.size(), " ", JSON.stringify(o).substr(0, 900))
func p_cam(_t) -> void: J.mc(J.G.Village, "setCam", [470.0])

# 廣場：每個動作 × 每隻鬼直接畫（DAILY plaza_* 身體、drawAgent 頭頂嘢、冇網格嘅特別畫法）
func plaza_body(_t) -> void:
	ok = 0; bad = 0
	var NP = load("res://native/daily_plaza.gd")
	var dn = _daily_get("plaza_"); var PLn = J.G.PlazaLife
	var tr = load("res://jsgen/daily_plaza.gd").new(); keep.append(tr); tr.run(null)
	var PLt = J.G.PlazaLife; var dt_ = _daily_get("plaza_")
	J.G["PlazaLife"] = PLn; _daily_set(dn.keys(), dn)
	var kinds = ["xiaozhi", "egui", "eguiking", "xiaogui", "toyol", "laojiang", "zombie", "shuigui", "pontianak", "pocong", "penanggal", "mengpo", "youhun", "baiwu", "heiwu", "niutou", "mamian", "huang", "zhiren", "tianhua"]
	var n = 0
	for nm in NP.NAMES + ["hop", "coins"]:
		var act = "plaza_" + nm
		for k in kinds:
			for at in [0.05, 0.2, 0.45, 0.7, 1.0, 1.4, 1.9, 2.5, 3.3, 4.2, 5.5, 7.3, 9.0]:
				for fr in [true, false]:
					var res = []
					for side in [0, 1]:
						_daily_set(dn.keys(), dn if side == 0 else dt_)
						var rc = _rec_ctx()
						var ag = {"id": "b" + k, "k": k, "x": 150.0, "y": 640.0, "face": fr, "want": fr, "turnT": 0.05 if at < 0.3 else 9.0, "sp": 3.0, "w": 0.6 if nm == "walk" else 0.0, "wph": at * 3, "hp": fmod(at, 1.0) if nm == "walk" else -1.0, "seed": 3.3,
							"st": "act", "at": at, "dur": 9.0, "act": null if nm == "walk" else act, "pl": {"d": 9.6 if nm == "golf" else 2.6, "spk": int(at * 10) % 2 == 0, "deep": 0.7, "eh": 84.0, "hd": 5.0}, "style": {"run": 1.0 if at > 3 else null, "sniff": 1.0 if nm == "sniff" else null, "sneak": 1.0 if at > 5 else null, "eat": 1.0 if nm == "eat" else null},
							"eatT": at, "iconT": fmod(at, 1.3), "icon": ["!", "?", "♪", "…"][int(at * 7) % 4], "fxTxt": {"s": "抓到！", "t": fmod(at, 1.1)}}
						if side == 0: NP.draw_agent(rc[1], ag, 50.0 + at, {"noIcon": at > 8})
						else: J.cl(J.gp(PLt, "drawAgent"), null, [rc[1], ag, 50.0 + at, {"noIcon": at > 8}])
						if k == "shuigui":
							if side == 0: NP.draw_drips(rc[1], ag, 50.0 + at)
							else: J.cl(J.gp(PLt, "drawDrips"), null, [rc[1], ag, 50.0 + at])
						var w = {"x": 120.0, "y": 600.0, "t": fmod(at, 0.5), "life": 4.0, "r": 2.5, "d": 0.0}
						if side == 0: NP.draw_wet(rc[1], w)
						else: J.cl(J.gp(PLt, "drawWet"), null, [rc[1], w])
						ag.erase("pl"); ag.erase("style")
						res.append(_ser(rc[0]) + JSON.stringify(ag))
					_cmp("%s/%s/at%s/fr%s" % [act, k, at, fr], res[0], res[1]); n += 1
	_daily_set(dn.keys(), dn)
	print("[l2daily] plaza_body draws=%d ok=%d bad=%d" % [n, ok, bad])
