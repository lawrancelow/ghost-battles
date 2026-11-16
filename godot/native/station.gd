# 原生改寫自 station.js：站崗嚇人・陽間地盤（Station）
# 模擬層（路人、崗位出手、夜冷村、穩定、收益、怪談）＋面板 HTML＋實況畫面（Live）。Godot 入口係 Street.open（street 用 Station.power），
# 面板／Live 照 JS 保留（battle.js 冇 Street 時會用）。資料：data/nat/station.json（由網頁原碼抽出：MAPS、TUNE、SKIT、LEGEND、中文對照）
# 介面同轉譯版一樣：J.G["Station"] = { MAPS, TUNE, st, ms, tick, simOne, assign, hitRival, boost, share, status, openPanel, entryHTML, panelHTML, Live, init, power, freeGhosts, legLv, mapOf, open }
extends RefCounted

const W_ := {"steal": "偷錢", "breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
const TYPES := ["breath", "light", "cold", "sound", "paper", "phone", "face", "shadow"]
const RIVALS := ["youhun", "egui", "xiaogui", "zombie", "zhiren", "shuigui", "niutou", "mamian"]
const RNAME := {"youhun": "遊魂", "egui": "餓鬼", "xiaogui": "小鬼", "zombie": "殭屍", "zhiren": "紙人", "shuigui": "水鬼", "niutou": "牛頭", "mamian": "馬面", "bryan": "Bryan"}
const BRYAN_LINES := ["Bryan：「呢個客係我嚇走嘅，你哋唔好亂講。」", "Bryan：「你嗰度啲人怕咩，我全部抄低咗。多謝分享。」", "Bryan：「籃球拍一下，成條走廊都靜晒。學下啦。」", "Bryan：「功勞唔使分，我攞晒就得。」"]
const LEG_N := [50.0, 200.0, 600.0]
const LEG_T := ["", "傳聞", "都市傳說", "經典"]

static var MAPS: Array = []
static var TUNE: Dictionary = {}
static var SKIT: Dictionary = {}
static var LEGEND: Dictionary = {}
static var LIVE: Dictionary = {}

# ---------- 小工具 ----------
static func has(name: String) -> bool: return J.typeof_(J.G.get(name)) != "undefined"
static func G(name: String): return J.G.get(name)
static func g(o, k): return J.gp(o, k)
static func n(v) -> float: return J.num(v)
static func t_(v) -> bool: return J.t(v)
static func s_(v) -> String: return J.str(v)
static func R(a: float, b: float) -> float: return a + randf() * (b - a)
static func pick(a: Array): return a[int(floor(randf() * a.size()))]
static func now() -> float: return n(J.S_Date_("now", []))
static func S_(): return G("S")
static func L(s: String) -> String:
	var w = G("window")
	if J.typeof_(w) != "undefined" and t_(g(w, "L")): return s_(J.S_window_("L", [s]))
	return s
static func D_(o, k): return J.gp(o, k)
static func nz(v, d := 0.0) -> float: return n(v) if t_(v) else d
static func q(sel: String): return J.cl(G("$"), null, [sel])
static func pct(x: float) -> String: return s_(J.round(x * 100)) + "%"
static func fixed1(x: float) -> String: return s_(J.mc(x, "toFixed", [1.0]))

static func map_of(id):
	for m in MAPS: if J.seq(m.id, id): return m
	return null
static func open_(m) -> bool:
	if t_(m.get("soon")): return false
	var S = S_()
	if t_(m.get("need")) and not (has("S") and t_(g(S, "seen")) and t_(g(g(S, "seen"), m.need))): return false
	if t_(m.get("bg")) and not (has("SPR") and t_(g(G("SPR"), m.bg))): return false
	return true
static func legend_name(k, gh) -> String:
	var v = LEGEND.get(s_(k))
	if t_(v): return v
	return (s_(g(gh, "name")) if t_(gh) else s_(k)) + "的怪談"
static func skit_for(gh, def) -> Dictionary:
	var lines = SKIT.get(s_(g(gh, "k")))
	if not t_(lines): lines = [["旁白", s_(def.short) + "附近開始有人講起「" + legend_name(g(gh, "k"), gh) + "」。"], [g(gh, "name"), "終於有人記得我了。"]]
	return {"style": "talk", "title": "怪談成形：" + legend_name(g(gh, "k"), gh), "lines": lines}

# ---------- 狀態 ----------
static func st():
	var S = S_()
	if not t_(g(S, "station")): J.sp(S, "station", {"maps": {}, "t": now(), "log": []})
	var s = g(S, "station")
	J.sp(s, "maps", g(s, "maps") if t_(g(s, "maps")) else {}); J.sp(s, "log", g(s, "log") if t_(g(s, "log")) else [])
	var maps = g(s, "maps")
	for m in MAPS:
		if not t_(g(maps, m.id)):
			J.sp(maps, m.id, {"posts": m.posts.map(func(_x): return null), "habit": 1.0, "hist": [], "used": {}, "stableAt": 0.0, "stable": false, "enemy": m.posts.map(func(_x): return null), "morale": {}, "leg": {}, "nextRaid": 0.0, "nextBryan": 0.0, "bank": 0.0, "cd": {}, "boost": {}})
	for m in MAPS:
		var mm = g(maps, m.id)
		while J.len(g(mm, "posts")) < m.posts.size(): J.mc(g(mm, "posts"), "push", [null])
		while J.len(g(mm, "enemy")) < m.posts.size(): J.mc(g(mm, "enemy"), "push", [null])
	return s
static func ms(id): return g(g(st(), "maps"), id)
static func ghost(id):
	for gh in J.iter(g(S_(), "ghosts")): if J.seq(g(gh, "id"), id): return gh
	return null
static func types_of(k) -> Array:
	if has("Rework"):
		var t = J.mc(G("Rework"), "typesOf", [k])
		if t_(t): return t
	var gh = g(G("SCARE_GHOSTS"), k) if has("SCARE_GHOSTS") else false
	if t_(gh): return g(gh, "types") if t_(g(gh, "types")) else [g(gh, "type")]
	return [TYPES[int(s_(k).length() * 7) % 8]]
static func drill_lv(k): return J.mc(G("Rework"), "drillLv", [k]) if has("Rework") else 1.0
static func rival_type(k) -> String:
	if J.seq(k, "bryan"): return "sound"
	var f = J.mc(G("Rework"), "fearOf", [k]) if has("Rework") else null
	return s_(J.gp(g(f, "i"), 0.0)) if t_(f) else "shadow"
static func power(gh) -> float: return 34.0 * (n(J.mc(G("GP"), "mul", [gh])) if has("GP") else 1.0)
static func rival_power(k, m) -> float: return 70.0 if J.seq(k, "bryan") else 30 + n(g(m, "habit")) * 2.2
static func share(m) -> Dictionary:
	var h = g(m, "hist")
	if not J.len(h): return {"me": 0.0, "en": 0.0, "n": 0.0}
	var a = 0.0; var b = 0.0
	for x in J.iter(h):
		if J.seq(x, 1.0): a += 1
		elif J.seq(x, 2.0): b += 1
	var ln = float(J.len(h))
	return {"me": a / ln, "en": b / ln, "n": ln}
static func status(m) -> Dictionary:
	var s = share(m)
	if s.n < 10: return {"k": "new", "t": "剛開始"}
	if s.me >= 0.6: return {"k": "own", "t": "佔領"}
	if s.me >= 0.4: return {"k": "war", "t": "爭奪中"}
	return {"k": "lost", "t": "失守"}
static func adapt(m, type) -> float:
	var u = g(m, "used"); var tot = 0.0
	for v in _values(u): tot += n(v)
	if not t_(tot): tot = 1.0
	var f = nz(J.gp(u, type)) / tot
	return 1 - maxf(0.0, minf(0.4, (f - 0.34) * 0.6))
static func _values(o) -> Array:
	var r = []
	for k in J.keys(o): r.append(J.gp(o, k))
	return r
static func leg_lv(m, gid) -> float:
	var c = nz(J.gp(g(m, "leg"), gid))
	return 3.0 if c >= LEG_N[2] else (2.0 if c >= LEG_N[1] else (1.0 if c >= LEG_N[0] else 0.0))

# 生一個路人
static func make_person(def, m) -> Dictionary:
	var p = def.people[int(floor(randf() * def.people.size()))]; var hb = n(g(m, "habit"))
	var weak = J.mc(p.weak.duplicate(), "sort", [func(_t, _a): return randf() - 0.5])
	var n_weak = 2 if hb < 4 else ((2 if randf() < 0.5 else 1) if hb < 7 else 1)
	weak = weak.slice(0, n_weak)
	var tough = 3.0 if hb >= 10 else (2.0 if hb >= 7 else 1.0)
	return {"def": p, "spr": p.spr, "name": p.name, "weak": weak, "imm": p.imm, "hp": (n(TUNE.hp0) + minf(10.0, hb) * n(TUNE.hpLv)) * (n(def.easy) if t_(def.get("easy")) else 1.0), "fear": 0.0, "dazed": null, "hits": 0.0, "tough": tough, "done": false, "by": 0.0, "x": 0.0, "i": 0.0, "t": 0.0, "react": 0.0, "say": null}
# 一個崗位對一個路人出手
static func strike(def, m, pi: float, P, who: int):
	var post = def.posts[int(pi)]
	var type; var pw; var gh = null; var legend = 0.0
	if who == 1:
		gh = ghost(J.gp(g(m, "posts"), pi))
		if not t_(gh): return null
		type = s_(types_of(g(gh, "k"))[0]); pw = power(gh); legend = leg_lv(m, g(gh, "id"))
		if J.seq(g(gh, "k"), "toyol"):
			var coin = 1 + floor(n(g(m, "habit")) / 3)
			var S = S_()
			if has("S") and t_(g(S, "res")): J.sp(g(S, "res"), "coins", n(g(g(S, "res"), "coins")) + coin)
			J.sp(m, "stolen", nz(g(m, "stolen")) + coin); P["dazed"] = "steal"; P["stolen"] = true
			var lg = g(m, "leg"); J.sp(lg, g(gh, "id"), nz(J.gp(lg, g(gh, "id"))) + 0.34)
			return {"dmg": n(P.hp) * 0.25, "combo": false, "tag": "偷了 " + s_(coin) + " 冥幣", "type": "steal", "g": gh}
	else:
		var e = J.gp(g(m, "enemy"), pi)
		if not t_(e): return null
		type = rival_type(g(e, "k")); pw = rival_power(g(e, "k"), m)
	var mul = 1.0; var tag = ""
	if P.imm.has(type) and not (legend >= 3): mul *= 0.5; tag = "不怕"
	elif P.weak.has(type) or legend >= 3: mul *= 1.5; tag = "怕"
	if post.fit == type: mul *= 1.3
	var combo = false
	if t_(P.dazed) and s_(P.dazed) != type and (not P.imm.has(type) or legend >= 3): mul *= 1.5; combo = true
	mul *= adapt(m, type)
	if n(P.tough) > 1 and n(P.hits) == 0: mul *= 0.5
	if who == 1 and t_(J.gp(g(m, "boost"), pi)): mul *= 2.5; J.sp(g(m, "boost"), pi, 0.0); tag = "大招"
	if who == 1 and legend >= 1: mul *= 1 + 0.08 * legend
	if who == 2 and t_(g(m, "stable")): mul *= 0.8
	var dmg = pw * mul * R(0.85, 1.15)
	var u = g(m, "used"); J.sp(u, type, nz(J.gp(u, type)) * 0.98 + 1)
	return {"dmg": dmg, "combo": combo, "tag": tag, "type": type, "g": gh}
static func pass_post(def, m, pi: float, P) -> Array:
	var res = []
	for who in [2, 1]:
		if t_(P.done): break
		var r = strike(def, m, pi, P, who)
		if r == null: continue
		P.fear = n(P.fear) + r.dmg; P.hits = n(P.hits) + 1
		if r.combo: P["combos"] = nz(P.get("combos")) + 1
		var broke = n(P.fear) >= n(P.hp) and (n(P.tough) <= 1 or nz(P.get("combos")) >= n(P.tough) - 1)
		if n(P.fear) >= n(P.hp) * 0.5: P.dazed = r.type
		var o = {"who": float(who)}
		for k in r: o[k] = r[k]
		o["broke"] = broke
		res.append(o)
		if broke: P.done = true; P.by = float(who)
	return res
static func finish(def, m, P) -> void:
	var hist = g(m, "hist"); J.mc(hist, "push", [P.by if t_(P.by) else 0.0])
	if J.len(hist) > 100: J.mc(hist, "shift", [])
	var slow = 1.0
	for v in _values(g(m, "leg")): if n(v) >= LEG_N[0]: slow = 0.8; break
	J.sp(m, "habit", minf(10.0, n(g(m, "habit")) + (n(TUNE.habitSeen) + (0.0 if t_(P.by) else n(TUNE.habitUp))) * slow))
	if not t_(P.by): return
	if J.seq(P.by, 1.0):
		var pts = 1 + n(g(m, "habit")) * 0.3; J.sp(m, "bank", n(g(m, "bank")) + pts)
		var gid = J.gp(g(m, "posts"), P.get("atPost"))
		if gid != null: var lg = g(m, "leg"); J.sp(lg, gid, nz(J.gp(lg, gid)) + 1)
static func sim_one(def, m) -> Dictionary:
	var P = make_person(def, m)
	for i in def.posts.size():
		var reps = n(def.wait) if t_(def.get("wait")) and i == 1 else 1.0
		var r = 0
		while r < reps and not t_(P.done):
			pass_post(def, m, float(i), P)
			if t_(P.done): P["atPost"] = float(i)
			r += 1
	finish(def, m, P); return P
static func log_(html: String) -> void:
	var s = st(); J.mc(g(s, "log"), "unshift", [{"t": now(), "h": html}])
	if J.len(g(s, "log")) > 30: J.sp(g(s, "log"), "length", 30.0)
	if has("Fx") and not t_(LIVE.on) and not t_(LIVE.get("_quiet")): J.mc(G("Fx"), "toast", [html])
static func rival_step(def, m, mins: float) -> void:
	var t0 = now(); var held_n = 0
	for d in MAPS: if open_(d) and status(ms(d.id)).k == "own": held_n += 1
	if not t_(g(m, "nextRaid")): J.sp(m, "nextRaid", t0 + R(n(TUNE.raidMin), n(TUNE.raidMax)) * 60000 / (1 + held_n * 0.3))
	var posts = g(m, "posts"); var enemy = g(m, "enemy")
	if t0 >= n(g(m, "nextRaid")):
		J.sp(m, "nextRaid", t0 + R(n(TUNE.raidMin), n(TUNE.raidMax)) * 60000 / (1 + held_n * 0.3))
		var empty = []; var mine = []
		for i in J.len(enemy):
			var e = J.gp(enemy, float(i)); var p = J.gp(posts, float(i))
			if not t_(e) and p == null: empty.append(float(i))
			if not t_(e) and p != null: mine.append(float(i))
		var i2 = -1.0
		if empty.size(): i2 = J.gp(J.mc(empty, "sort", [func(_t, a): return n(a[0]) - n(a[1])]), 0.0)
		elif mine.size(): i2 = pick(mine)
		if i2 >= 0:
			J.sp(enemy, i2, {"k": pick(RIVALS), "hp": 100.0, "at": t0})
			log_("夜冷村派了" + RNAME[s_(g(J.gp(enemy, i2), "k"))] + "到<b>" + s_(def.short) + "・" + s_(def.posts[int(i2)].name) + "</b>" + ("，正在騷擾我方的鬼" if J.gp(posts, i2) != null else ""))
	if not t_(g(m, "nextBryan")): J.sp(m, "nextBryan", t0 + n(TUNE.bryanH) * 3600000 * R(0.6, 1.2))
	if t0 >= n(g(m, "nextBryan")) and status(m).k != "new":
		J.sp(m, "nextBryan", t0 + n(TUNE.bryanH) * 3600000 * R(0.8, 1.3))
		var free = []
		for i in J.len(enemy): if not t_(J.gp(enemy, float(i))): free.append(float(i))
		var i3 = free[0] if free.size() else 0.0
		J.sp(enemy, i3, {"k": "bryan", "hp": 220.0, "at": t0})
		log_("<b>Bryan 親自站崗</b>：" + s_(def.short) + "・" + s_(def.posts[int(i3)].name) + "。" + L(pick(BRYAN_LINES)))
	var mor_d = g(m, "morale")
	for i in J.len(enemy):
		var e = J.gp(enemy, float(i))
		if not t_(e) or J.gp(posts, float(i)) == null: continue
		var gid = J.gp(posts, float(i))
		var mor = (n(TUNE.morale) if J.gp(mor_d, gid) == null else n(J.gp(mor_d, gid))) - n(TUNE.harass) * mins * (2.0 if J.seq(g(e, "k"), "bryan") else 1.0)
		J.sp(mor_d, gid, maxf(0.0, mor))
		if n(J.gp(mor_d, gid)) <= 0:
			var gh = ghost(gid); J.sp(posts, float(i), null)
			if t_(gh): J.sp(gh, "post", null); J.sp(gh, "tiredUntil", t0 + 30 * 60000)
			J.sp(mor_d, gid, TUNE.morale)
			log_("<b>" + (s_(g(gh, "name")) if t_(gh) else "我方的鬼") + "</b>在" + s_(def.short) + "・" + s_(def.posts[i].name) + "被" + RNAME[s_(g(e, "k"))] + "趕走了，崗位被搶。")
	for i in J.len(posts):
		var gid = J.gp(posts, float(i))
		if gid != null and not t_(J.gp(enemy, float(i))): J.sp(mor_d, gid, minf(n(TUNE.morale), (n(TUNE.morale) if J.gp(mor_d, gid) == null else n(J.gp(mor_d, gid))) + 6 * mins))
static func stable_step(def, m) -> void:
	var s = share(m); var ok = n(g(m, "habit")) >= 10 and s.n >= 50 and s.me >= n(TUNE.stableRatio)
	if ok:
		if not t_(g(m, "stableAt")): J.sp(m, "stableAt", now())
		if not t_(g(m, "stable")) and now() - n(g(m, "stableAt")) >= n(TUNE.stableHours) * 3600000:
			J.sp(m, "stable", true); log_("<b>" + s_(def.name) + "</b> 地盤穩定了！見慣度封頂也頂得住，之後固定產出，離線照算。")
	else:
		J.sp(m, "stableAt", 0.0)
		if t_(g(m, "stable")) and s.me < n(TUNE.failRatio): J.sp(m, "stable", false); log_("<b>" + s_(def.name) + "</b> 撐不住，不再穩定。")
static func pay_step(_def, m) -> void:
	while n(g(m, "bank")) >= 40:
		J.sp(m, "bank", n(g(m, "bank")) - 40)
		var S = S_(); var ct = g(S, "contract")
		if t_(ct) and J.seq(g(ct, "state"), "active"): J.sp(ct, "kpi", n(g(ct, "kpi")) + 1)
		if has("Presence"):
			for gid in J.iter(g(m, "posts")):
				var gh = ghost(gid) if gid != null else false
				if t_(gh): J.mc(G("Presence"), "add", [gh, 1.5])
		var s = st(); J.sp(s, "earned", nz(g(s, "earned")) + 1)
static func legend_step(def, m) -> void:
	if not t_(g(m, "legSeen")): J.sp(m, "legSeen", {})
	var seen = g(m, "legSeen")
	for gid in J.keys(g(m, "leg")):
		var lv = leg_lv(m, gid)
		if lv > nz(J.gp(seen, gid)):
			J.sp(seen, gid, lv)
			var gh = ghost(J.num(gid))
			if not t_(gh): gh = ghost(gid)
			if t_(gh):
				log_("<b>" + s_(g(gh, "name")) + "</b> 在" + s_(def.short) + "的怪談升級為「" + LEG_T[int(lv)] + "」：" + legend_name(g(gh, "k"), gh))
				if lv == 2 and has("Story"):
					if not t_(g(m, "skit")): J.sp(m, "skit", {})
					if not t_(J.gp(g(m, "skit"), g(gh, "k"))):
						J.sp(g(m, "skit"), g(gh, "k"), 1.0); J.mc(G("Story"), "queue", [skit_for(gh, def)])
static func validate() -> void:
	for d in MAPS:
		var m = ms(d.id); var posts = g(m, "posts")
		for i in J.len(posts):
			var gid = J.gp(posts, float(i))
			if gid == null: continue
			var gh = ghost(gid)
			if not t_(gh) or not J.seq(g(gh, "post"), "station"): J.sp(posts, float(i), null)
static func tick() -> void:
	var S = S_()
	if not has("S") or not t_(g(S, "ghosts")): return
	var s = st(); var t0 = now(); validate()
	var dt = maxf(0.0, minf(n(TUNE.offlineCap) * 3600, (t0 - (n(g(s, "t")) if t_(g(s, "t")) else t0)) / 1000)); J.sp(s, "t", t0)
	var rep = null
	if dt > 600:
		var lg = g(s, "log")
		rep = {"mins": J.round(dt / 60), "n": 0.0, "me": 0.0, "en": 0.0, "kpi0": nz(g(s, "earned")), "log0": g(J.gp(lg, 0.0), "t") if J.len(lg) else 0.0}
	if rep != null: LIVE["_quiet"] = true
	for def in MAPS:
		if not open_(def): continue
		var m = ms(def.id)
		var mine = false; var anyone = false
		for x in J.iter(g(m, "posts")): if x != null: mine = true
		var en_any = false
		for e in J.iter(g(m, "enemy")): if t_(e): en_any = true
		anyone = mine or en_any
		if anyone and not (t_(LIVE.on) and is_same(LIVE.def, def)):
			J.sp(m, "acc", nz(g(m, "acc")) + dt)
			while n(g(m, "acc")) >= n(TUNE.every):
				J.sp(m, "acc", n(g(m, "acc")) - n(TUNE.every)); var P = sim_one(def, m)
				if rep != null:
					rep.n += 1
					if J.seq(P.by, 1.0): rep.me += 1
					elif J.seq(P.by, 2.0): rep.en += 1
		if mine or en_any: rival_step(def, m, dt / 60)
		stable_step(def, m); pay_step(def, m); legend_step(def, m)
	if rep != null:
		LIVE["_quiet"] = false
		if t_(rep.n):
			rep["kpi"] = nz(g(s, "earned")) - rep.kpi0
			var ev = []
			for x in J.iter(g(s, "log")):
				if n(g(x, "t")) > n(rep.log0): ev.append(g(x, "h"))
			rep["events"] = ev.slice(0, 6); J.sp(s, "report", rep)

# ---------- 派鬼 ----------
static func assign(map_id, pi: float, gid) -> void:
	var m = ms(map_id); var posts = g(m, "posts"); var old = J.gp(posts, pi)
	if old != null:
		var og = ghost(old)
		if t_(og) and J.seq(g(og, "post"), "station"): J.sp(og, "post", null)
	if gid == null: J.sp(posts, pi, null); return
	var gh = ghost(gid)
	if not t_(gh): return
	for d in MAPS:
		var mp = g(ms(d.id), "posts")
		for i in J.len(mp): if J.seq(J.gp(mp, float(i)), gid): J.sp(mp, float(i), null)
	J.sp(gh, "post", "station"); J.sp(posts, pi, gid)
	if J.gp(g(m, "morale"), gid) == null: J.sp(g(m, "morale"), gid, TUNE.morale)
static func free_ghosts() -> Array:
	var t0 = now(); var out = []
	for gh in J.iter(g(S_(), "ghosts")):
		if not J.seq(g(gh, "k"), "afu") and not t_(g(gh, "post")) and not (n(g(gh, "tiredUntil")) > t0): out.append(gh)
	return out
static func hit_rival(map_id, pi: float):
	var def = map_of(map_id); var m = ms(map_id); var e = J.gp(g(m, "enemy"), pi)
	if not t_(e): return null
	var t0 = now()
	if nz(g(m, "hitCd")) > t0: return {"msg": "喘口氣……", "cd": true}
	J.sp(m, "hitCd", t0 + 1400)
	var posts = g(m, "posts"); var gi = J.gp(posts, pi)
	if gi == null:
		var near = []
		for i in J.len(posts): if J.gp(posts, float(i)) != null: near.append(float(i))
		near = J.mc(near, "sort", [func(_t, a): return absf(n(a[0]) - pi) - absf(n(a[1]) - pi)])
		gi = J.gp(posts, near[0]) if near.size() else null
	var gh = ghost(gi) if gi != null else null
	if not t_(gh): return {"msg": "這張地圖沒有我方的鬼可以出手"}
	var type = s_(types_of(g(gh, "k"))[0])
	var f = {"w": ["light", "face"], "i": ["sound"]} if J.seq(g(e, "k"), "bryan") else (J.mc(G("Rework"), "fearOf", [g(e, "k")]) if has("Rework") else {"w": [], "i": []})
	var fw = g(f, "w"); var fi = g(f, "i")
	var mul = 1.6 if J.mc(fw, "includes", [type]) else (0.4 if J.mc(fi, "includes", [type]) else 1.0)
	var tag = "怕" if J.mc(fw, "includes", [type]) else ("不怕" if J.mc(fi, "includes", [type]) else "")
	var dmg = J.round(power(gh) * 0.55 * mul * R(0.85, 1.15)); J.sp(e, "hp", n(g(e, "hp")) - dmg)
	var gone = false
	if n(g(e, "hp")) <= 0:
		gone = true; J.sp(g(m, "enemy"), pi, null); log_("把" + RNAME[s_(g(e, "k"))] + "從" + s_(def.short) + "・" + s_(def.posts[int(pi)].name) + "趕走了！")
		var ct = g(S_(), "contract")
		if J.seq(g(e, "k"), "bryan") and t_(ct) and J.seq(g(ct, "state"), "active"): J.sp(ct, "kpi", n(g(ct, "kpi")) + 3)
	return {"dmg": dmg, "tag": tag, "gone": gone, "g": gh, "type": type}
static func boost(map_id, pi: float) -> float:
	var m = ms(map_id); var t0 = now()
	if nz(J.gp(g(m, "cd"), pi)) > t0: return ceil((n(J.gp(g(m, "cd"), pi)) - t0) / 1000)
	J.sp(g(m, "boost"), pi, 1.0); J.sp(g(m, "cd"), pi, t0 + 20000); return 0.0

# ---------- 面板 ----------
static func stable_hours_left(m) -> String: return s_(maxf(0.0, ceil((n(TUNE.stableHours) * 3600000 - (now() - n(g(m, "stableAt")))) / 3600000)))
static func map_card(def) -> String:
	if not open_(def): return "<div class=\"stn-card soon\"><div class=\"stn-h\"><b>" + s_(def.name) + "</b><em>" + ("即將開放" if t_(def.get("soon")) else "未解鎖") + "</em></div><small>" + s_(def.desc) + "</small></div>"
	var m = ms(def.id); var s = share(m); var sta = status(m); var stbl = "<em class=\"stn-stable\">地盤穩定</em>" if t_(g(m, "stable")) else ""
	var hab = n(g(m, "habit"))
	var st_prog = "" if t_(g(m, "stable")) else ("穩定倒數 " + stable_hours_left(m) + " 小時" if t_(g(m, "stableAt")) else ("嚇破膽要 ≥" + pct(n(TUNE.stableRatio)) + " 才開始計穩定" if hab >= 10 else "見慣度到 10 才能穩定"))
	var h = "<div class=\"stn-card\"><div class=\"stn-h\"><b>" + s_(def.name) + "</b><em class=\"stn-" + sta.k + "\">" + sta.t + "</em>" + stbl + "</div>"
	h += "<div class=\"stn-bar\"><i class=\"me\" style=\"width:" + pct(s.me) + "\"></i><i class=\"en\" style=\"width:" + pct(s.en) + "\"></i></div><small class=\"stn-sub\">我方 " + pct(s.me) + "　夜冷村 " + pct(s.en) + "　沒嚇到 " + pct(maxf(0.0, 1 - s.me - s.en)) + "（最近 " + s_(s.n) + " 個路人）</small>"
	h += "<small class=\"stn-sub\">見慣度 <b>" + fixed1(hab) + "</b> / 10　" + st_prog + "</small><div class=\"stn-posts\">"
	for i in def.posts.size():
		var p = def.posts[i]; var gid = J.gp(g(m, "posts"), float(i)); var gh = ghost(gid) if gid != null else null; var e = J.gp(g(m, "enemy"), float(i))
		var mor = J.round(100.0 if J.gp(g(m, "morale"), g(gh, "id")) == null else n(J.gp(g(m, "morale"), g(gh, "id")))) if t_(gh) else 0.0
		var lv = leg_lv(m, g(gh, "id")) if t_(gh) else 0.0
		h += "<div class=\"stn-post " + ("raid" if t_(e) else "") + "\"><div class=\"stn-pn\">" + s_(i + 1) + ". " + s_(p.name) + "<small>適合：" + W_[s_(p.fit)] + "</small></div>"
		if t_(gh):
			var tn = []
			for tt in J.iter(types_of(g(gh, "k"))): tn.append(s_(W_.get(s_(tt))))
			h += "<div class=\"stn-g\"><canvas data-por=\"" + s_(g(gh, "k")) + "\"></canvas><span><b>" + s_(g(gh, "name")) + "</b><small>" + "／".join(tn) + "　氣勢 " + s_(mor) + (("　<i class=\"stn-leg\">" + LEG_T[int(lv)] + "</i>") if lv > 0 else "") + "</small></span></div>"
		else: h += "<div class=\"stn-g empty\">空崗</div>"
		if t_(e): h += "<div class=\"stn-en\">⚑ " + RNAME[s_(g(e, "k"))] + "（" + W_[rival_type(g(e, "k"))] + "）" + ("騷擾中" if t_(gh) else "佔了這個崗位") + "</div>"
		h += "<div class=\"stn-btns\"><button class=\"btn sm\" data-st-as=\"" + s_(def.id) + ":" + s_(i) + "\">" + ("換鬼" if t_(gh) else "派鬼") + "</button>" + ("<button class=\"btn sm ghost\" data-st-un=\"" + s_(def.id) + ":" + s_(i) + "\">撤回</button>" if t_(gh) else "") + ("<button class=\"btn sm red\" data-st-hit=\"" + s_(def.id) + ":" + s_(i) + "\">出手驅趕</button>" if t_(e) else "") + "</div></div>"
	h += "</div><div class=\"stn-acts\"><button class=\"btn gold\" data-st-live=\"" + s_(def.id) + "\">看實況</button></div></div>"
	return h
static func panel_html() -> String:
	var s = st(); var h = ""
	if t_(g(s, "report")):
		var r = g(s, "report"); var mins = n(g(r, "mins"))
		h += "<div class=\"stn-report\"><b>你不在的 " + (s_(floor(mins / 60)) + " 小時" if mins >= 60 else "") + (s_(fmod(mins, 60)) + " 分鐘" if t_(fmod(mins, 60)) else "") + "裡</b><p>經過 " + s_(g(r, "n")) + " 個路人：我方嚇破膽 " + s_(g(r, "me")) + " 個，夜冷村搶走 " + s_(g(r, "en")) + " 個。合約 KPI +" + s_(g(r, "kpi") if t_(g(r, "kpi")) else 0.0) + "。</p>"
		for x in J.iter(g(r, "events") if t_(g(r, "events")) else []): h += "<p class=\"ev\">" + s_(x) + "</p>"
		h += "</div>"; J.sp(s, "report", null)
	h += "<div class=\"stn-top\"><p>派鬼到陽間各張地圖站崗，嚇路過的人。路人會越來越難嚇，但見慣度最高 10；在 10 也頂得住、而且連續 " + s_(TUNE.stableHours) + " 小時嚇破膽 ≥" + pct(n(TUNE.stableRatio)) + "，地盤就穩定。夜冷村的 Bryan 會來搶崗位、搶功、騷擾你的鬼。</p><small>站崗的鬼不能同時在村裡幹活。站崗累積的業績已換成合約 KPI <b>" + s_(nz(g(s, "earned"))) + "</b> 點。</small></div>"
	for def in MAPS: h += map_card(def)
	var lg = g(s, "log")
	if J.len(lg):
		h += "<div class=\"stn-log\"><b>最近發生</b>"
		var k = 0
		for x in J.iter(lg):
			if k >= 8: break
			h += "<p>" + s_(g(x, "h")) + "</p>"; k += 1
		h += "</div>"
	return h
static func pick_html(map_id, pi: float) -> String:
	var def = map_of(map_id); var p = def.posts[int(pi)]; var list = free_ghosts()
	var pn = []
	for x in def.people: pn.append(s_(x.name))
	var h = "<p class=\"desc\">派一隻鬼到 <b>" + s_(def.short) + "・" + s_(p.name) + "</b>。這個崗位適合「" + W_[s_(p.fit)] + "」。路人：" + "、".join(pn) + "。</p>"
	h += "<div class=\"stn-pick\">"
	for gh in list:
		var ts = types_of(g(gh, "k")); var fit = J.mc(ts, "includes", [p.fit]); var tn = []
		for tt in J.iter(ts): tn.append(s_(W_.get(s_(tt))))
		h += "<div class=\"gi\" data-st-pick=\"" + s_(g(gh, "id")) + "\"><canvas data-por=\"" + s_(g(gh, "k")) + "\"></canvas><div><b>" + s_(g(gh, "name")) + "</b> <i class=\"q q" + s_(g(gh, "q")) + "\">" + s_(g(gh, "q")) + "</i><small>嚇法：" + "／".join(tn) + ("　<em class=\"stn-fit\">啱這個崗位</em>" if t_(fit) else "") + "　嚇功 Lv" + s_(drill_lv(g(gh, "k"))) + "　鬼力 " + (s_(J.mc(G("GP"), "pow", [gh])) if has("GP") else "-") + "　威力 " + s_(J.round(power(gh))) + "</small></div></div>"
	h += "</div>"
	if not list.size(): h += "<p class=\"desc\">沒有空閒的鬼。先把村裡幹活的鬼撤下來，或等被趕走的鬼休息好。</p>"
	h += "<button class=\"btn\" data-st-back=\"1\">返回</button>"
	return h
static func open_panel() -> void:
	tick()
	J.mc(G("UI"), "sheet", ["陽間地盤・站崗", panel_html(), func(_t, _a):
		var b = q("#sheet .sh-body")
		if t_(b) and not t_(g(g(b, "dataset"), "picking")): J.sp(b, "innerHTML", panel_html()); bind(); draw_pors()
		return null])
	bind(); draw_pors()
static func draw_pors() -> void:
	var f = G("paintPortraits")
	if f != null: J.cl(f, null, [q("#sheet")])
static func _split(x, key: String) -> Array:
	return s_(g(g(x, "dataset"), key)).split(":")
static func bind() -> void:
	var b = q("#sheet .sh-body")
	if not t_(b): return
	J.del(g(b, "dataset"), "picking")
	for x in J.iter(J.mc(b, "querySelectorAll", ["[data-st-as]"])):
		J.sp(x, "onclick", func(_t, _a):
			var pr = _split(x, "stAs"); var id = pr[0]; var i = J.num(pr[1])
			J.sp(g(b, "dataset"), "picking", 1.0); J.sp(b, "innerHTML", pick_html(id, i)); draw_pors()
			for y in J.iter(J.mc(b, "querySelectorAll", ["[data-st-pick]"])):
				J.sp(y, "onclick", func(_t2, _a2):
					var sp = g(g(y, "dataset"), "stPick"); var nv = J.num(sp)
					assign(id, i, nv if t_(nv) else sp)
					var Snd = G("Sound")
					if t_(g(Snd, "play")): J.mc(Snd, "play", ["click"])
					open_panel(); return null)
			J.sp(J.mc(b, "querySelector", ["[data-st-back]"]), "onclick", func(_t3, _a3): open_panel(); return null)
			return null)
	for x in J.iter(J.mc(b, "querySelectorAll", ["[data-st-un]"])):
		J.sp(x, "onclick", func(_t, _a):
			var pr = _split(x, "stUn"); assign(pr[0], J.num(pr[1]), null); open_panel(); return null)
	for x in J.iter(J.mc(b, "querySelectorAll", ["[data-st-hit]"])):
		J.sp(x, "onclick", func(_t, _a):
			var pr = _split(x, "stHit"); var r = hit_rival(pr[0], J.num(pr[1]))
			if t_(r) and t_(g(r, "msg")): J.mc(G("Fx"), "toast", [g(r, "msg")])
			elif t_(r): J.mc(G("Fx"), "toast", [s_(g(g(r, "g"), "name")) + "出手（" + W_[s_(g(r, "type"))] + "）" + ("，對方" + s_(g(r, "tag")) if t_(g(r, "tag")) else "") + "：−" + s_(g(r, "dmg")) + ("，趕走了！" if t_(g(r, "gone")) else "")])
			open_panel(); return null)
	for x in J.iter(J.mc(b, "querySelectorAll", ["[data-st-live]"])):
		J.sp(x, "onclick", func(_t, _a): J.mc(G("UI"), "close", []); live_open(g(g(x, "dataset"), "stLive")); return null)
static func entry_html() -> String:
	var cnt = 0
	for d in MAPS: if open_(d): cnt += 1
	if not cnt: return ""
	var _s = st(); var own = 0; var raid = false
	for d in MAPS:
		if open_(d) and status(ms(d.id)).k == "own": own += 1
	for d in MAPS:
		if open_(d):
			for e in J.iter(g(ms(d.id), "enemy")): if t_(e): raid = true
	return "<div class=\"sc-entry stn-entry\"><div><b>陽間地盤・站崗</b><small>佔領 " + s_(own) + " 張地圖" + ("　<em class=\"stn-alert\">⚑ 夜冷村在搶</em>" if raid else "") + "　派鬼站崗嚇路人</small></div><button class=\"btn gold\" id=\"stn-open\">打開</button></div>"

# ---------- 實況畫面（Live） ----------
static func lv(): return LIVE
static func live_open(id) -> void:
	var def = map_of(id)
	if def == null or not open_(def): return
	tick()
	var V = LIVE
	V.def = def; V.on = true; V.walkers = []; V.fx = []; V.spawnAcc = n(TUNE.every) - 1.5; V["t"] = 0.0
	var el = q("#stn-live")
	if not t_(el):
		el = J.S_document_("createElement", ["div"]); J.sp(el, "id", "stn-live"); J.mc(J.gp(G("document"), "body"), "appendChild", [el])
	J.sp(el, "innerHTML", "<canvas id=\"stn-cv\"></canvas><div class=\"stn-hud\"><button class=\"btn sm\" id=\"stn-x\">返回</button><div class=\"stn-hh\"><b>" + s_(def.name) + "</b><span id=\"stn-info\"></span></div></div><div class=\"stn-board\" id=\"stn-board\"></div><div class=\"stn-tip\" id=\"stn-tip\">點站崗的鬼放大招（下一個路人 ×2.5，冷卻 20 秒）。點夜冷村的鬼出手驅趕。左右拖動看整條路。</div>")
	J.mc(g(el, "classList"), "add", ["on"]); V.cv = q("#stn-cv")
	var tb = J.S_document_("getElementById", ["stn-testbtn"])
	if t_(tb): J.sp(g(tb, "style"), "display", "none")
	V.ctx = J.mc(V.cv, "getContext", ["2d"])
	live_resize(); V.camX = live_max_cam()
	J.sp(q("#stn-x"), "onclick", func(_t, _a): live_close(); return null)
	live_bind_pan(); V.last = n(J.S_performance_("now", [])); J.F_cancelAnimationFrame([V.raf])
	V.raf = J.F_requestAnimationFrame([func(_t, a): live_frame(J.num(J.arg(a, 0))); return null])
	if has("Sound") and t_(g(G("Sound"), "setMode")): J.mc(G("Sound"), "setMode", ["scare"])
static func live_close() -> void:
	var V = LIVE
	V.on = false; J.F_cancelAnimationFrame([V.raf])
	var el = q("#stn-live")
	if t_(el): J.mc(g(el, "classList"), "remove", ["on"])
	var tb = J.S_document_("getElementById", ["stn-testbtn"])
	if t_(tb): J.sp(g(tb, "style"), "display", "")
	J.sp(st(), "t", now())
	if has("Sound") and t_(g(G("Sound"), "setMode")): J.mc(G("Sound"), "setMode", ["village"])
	open_panel()
static func live_resize() -> void:
	var V = LIVE
	var dp = J.gp(G("window"), "devicePixelRatio"); var dpr = minf(2.0, n(dp) if t_(dp) else 1.0); var r = J.mc(V.cv, "getBoundingClientRect", [])
	V["W"] = g(r, "width") if t_(g(r, "width")) else G("innerWidth"); V["H"] = g(r, "height") if t_(g(r, "height")) else G("innerHeight")
	J.sp(V.cv, "width", J.round(n(V.W) * dpr)); J.sp(V.cv, "height", J.round(n(V.H) * dpr)); J.mc(V.ctx, "setTransform", [dpr, 0.0, 0.0, dpr, 0.0, 0.0]); V["dpr"] = dpr
static func live_img():
	var V = LIVE
	if J.seq(V.def.id, "office") and has("OFFMAP") and t_(g(G("OFFMAP"), "pano")):
		var c = J.mc(G("OFFMAP"), "pano", [])
		if t_(c): return c
	return g(G("SPR"), V.def.bg)
static func live_bg_h() -> float: return minf(n(LIVE.H) * 0.56, n(LIVE.W) * 1.25)
static func live_top() -> float: return maxf(270.0, n(LIVE.H) - live_bg_h() - n(LIVE.H) * 0.15)
static func live_sc() -> float: return live_bg_h() / n(g(live_img(), "height"))
static func live_max_cam() -> float:
	var sg = LIVE.def.seg; return maxf(0.0, (n(sg[1]) - n(sg[0])) * live_sc() - n(LIVE.W))
static func live_sx(px: float) -> float: return (px - n(LIVE.def.seg[0])) * live_sc() - n(LIVE.camX)
static func live_person_h() -> float: return live_bg_h() * 0.40
static func live_bind_pan() -> void:
	var cv = LIVE.cv; var d = [null]
	J.sp(cv, "onpointerdown", func(_t, a):
		var e = J.arg(a, 0); d[0] = {"x0": g(e, "clientX"), "c0": LIVE.camX, "moved": false}
		J.mc(cv, "setPointerCapture", [g(e, "pointerId")]); return null)
	J.sp(cv, "onpointermove", func(_t, a):
		var e = J.arg(a, 0)
		if d[0] == null: return null
		var dx = n(g(e, "clientX")) - n(d[0].x0)
		if absf(dx) > 8: d[0].moved = true
		if d[0].moved: LIVE.camX = maxf(0.0, minf(live_max_cam(), n(d[0].c0) - dx))
		return null)
	J.sp(cv, "onpointerup", func(_t, a):
		var was = d[0]; d[0] = null
		if was != null and not was.moved: live_tap(J.arg(a, 0))
		return null)
	J.sp(cv, "onpointercancel", func(_t, _a): d[0] = null; return null)
static func live_post_xy(i: int) -> Array:
	var p = LIVE.def.posts[i]; return [live_sx(n(p.x)), live_top() + live_bg_h() * n(LIVE.def.walkY)]
static func live_tap(e) -> void:
	var V = LIVE; var r = J.mc(V.cv, "getBoundingClientRect", []); var x = n(g(e, "clientX")) - n(g(r, "left")); var y = n(g(e, "clientY")) - n(g(r, "top")); var m = ms(V.def.id); var h = live_person_h()
	for i in V.def.posts.size():
		var pxy = live_post_xy(i); var px = pxy[0]; var py = pxy[1]
		if t_(J.gp(g(m, "enemy"), float(i))) and absf(x - (px + h * 0.32)) < h * 0.28 and y > py - h * 1.1 and y < py + 10:
			var res = hit_rival(V.def.id, float(i))
			if not t_(res): return
			if t_(g(res, "msg")): live_float(px, py - h, g(res, "msg"), "#ffd")
			else:
				var tg = s_(g(res, "tag"))
				live_float(px + h * 0.32, py - h * 1.05, W_[s_(g(res, "type"))] + ("・" + tg if tg != "" else "") + " −" + s_(g(res, "dmg")), "#ff8" if tg == "怕" else ("#aab" if tg == "不怕" else "#fff"))
				if t_(g(res, "gone")): live_float(px + h * 0.32, py - h * 1.3, "趕走了！", "#7f7")
			return
		if J.gp(g(m, "posts"), float(i)) != null and absf(x - (px - h * 0.18)) < h * 0.3 and y > py - h * 1.1 and y < py + 10:
			var left = boost(V.def.id, float(i))
			live_float(px - h * 0.18, py - h * 1.1, "冷卻中 " + s_(left) + " 秒" if left > 0 else "大招準備好！下一個路人 ×2.5", "#aab" if left > 0 else "#ffb347")
			return
static func live_float(x: float, y: float, t, c: String) -> void:
	var k = 0
	for f in LIVE.fx: if n(f.a) < 0.9 and absf(n(f.x) - x) < 120 and absf(n(f.y0) - y) < 40: k += 1
	LIVE.fx.append({"x": x, "y": y - k * 26, "y0": y, "t": t, "c": c, "a": 0.0})
static func live_frame(t_now: float) -> void:
	var V = LIVE
	if not t_(V.on): return
	V.raf = J.F_requestAnimationFrame([func(_t, a): live_frame(J.num(J.arg(a, 0))); return null])
	if t_now - n(V.last) < 1000.0 / 30 - 2: return
	var dt = minf(0.1, (t_now - n(V.last)) / 1000); V.last = t_now; V.t = n(V.t) + dt
	live_step(dt); live_draw()
static func live_step(dt: float) -> void:
	var V = LIVE; var def = V.def; var m = ms(def.id); var dir = n(def.dir); var seg0 = n(def.seg[0]); var seg1 = n(def.seg[1])
	J.sp(st(), "t", now()); rival_step(def, m, dt / 60); stable_step(def, m); pay_step(def, m); legend_step(def, m)
	V.spawnAcc = n(V.spawnAcc) + dt
	if n(V.spawnAcc) >= n(TUNE.every):
		V.spawnAcc = n(V.spawnAcc) - n(TUNE.every); var P = make_person(def, m)
		P.x = seg1 - 40 if dir < 0 else seg0 + 40; P["next"] = 0.0; P["speed"] = R(150, 190); V.walkers.append(P)
	for P in V.walkers:
		if n(P.react) > 0: P.react = n(P.react) - dt; continue
		if t_(P.done) and t_(P.by):
			P.x = n(P.x) + dir * n(P.speed) * 2.2 * dt; P["flee"] = true
			if (dir < 0 and n(P.x) < seg0 - 200) or (dir > 0 and n(P.x) > seg1 + 200): P["gone"] = true
			continue
		P.x = n(P.x) + dir * n(P.speed) * dt
		var i = int(n(P.next))
		if i < def.posts.size() and ((dir < 0 and n(P.x) <= n(def.posts[i].x)) or (dir > 0 and n(P.x) >= n(def.posts[i].x))):
			var stay = false
			if t_(def.get("wait")) and i == 1:
				P["wt"] = nz(P.get("wt")) + 1; stay = n(P.wt) < n(def.wait)
			if not stay: P.next = n(P.next) + 1
			var res = pass_post(def, m, float(i), P)
			if stay and not t_(P.done): P.react = maxf(nz(P.react), 2.4)
			if t_(P.done): P["atPost"] = float(i)
			var pxy = live_post_xy(i); var px = pxy[0]; var py = pxy[1]; var h = live_person_h()
			for k in res.size():
				var r = res[k]; var who = "" if n(r.who) == 1 else "夜冷村　"
				var txt = who + W_[s_(r.type)] + ("・連嚇" if r.combo else "") + ("・" + s_(r.tag) if s_(r.tag) != "" else "") + ("　嚇破膽！" if r.broke else "")
				live_float(px, py - h * (1.15 + k * 0.18), txt, "#ff7b7b" if n(r.who) == 2 else ("#ffe066" if r.broke else ("#aab" if s_(r.tag) == "不怕" else "#e8f4ff")))
				if n(r.who) == 1 and t_(r.g): J.sp(r.g, "_act", V.t)
			if res.size(): P.react = maxf(nz(P.react), 0.7); P["scaredT"] = V.t
			if t_(P.done) and J.seq(P.by, 2.0) and res.size() and n(res[-1].who) == 2:
				var before = false
				for j in J.len(g(m, "posts")): if j < i and J.gp(g(m, "posts"), float(j)) != null: before = true
				if before and randf() < 0.35: live_float(px, py - h * 1.6, _bryan_line(), "#ff9a9a")
		if (dir < 0 and n(P.x) < seg0 - 100) or (dir > 0 and n(P.x) > seg1 + 100):
			if not t_(P.done): P.done = true; P.by = 0.0
			P["gone"] = true
		if t_(P.get("gone")) and not t_(P.get("fin")): P["fin"] = true; finish(def, m, P)
	V.walkers = V.walkers.filter(func(P): return not t_(P.get("gone")))
	for f in V.fx: f.a = n(f.a) + dt
	V.fx = V.fx.filter(func(f): return n(f.a) < 2.2)
	var s = share(m); var sta = status(m)
	var info = q("#stn-info")
	if t_(info) and (not t_(V.get("_it")) or n(V.t) - n(V._it) > 0.5):
		V["_it"] = V.t; J.sp(info, "innerHTML", sta.t + ("　<em>地盤穩定</em>" if t_(g(m, "stable")) else ""))
		var bd = q("#stn-board")
		if t_(bd):
			var stp = "已穩定：固定產出，離線照算" if t_(g(m, "stable")) else ("穩定倒數 " + stable_hours_left(m) + " 小時" if t_(g(m, "stableAt")) else ("嚇破膽要 ≥" + pct(n(TUNE.stableRatio)) + " 才開始計穩定（現在 " + pct(s.me) + "）" if n(g(m, "habit")) >= 10 else "見慣度到 10 才能穩定"))
			var hh = "<div class=\"stn-bar\"><i class=\"me\" style=\"width:" + pct(s.me) + "\"></i><i class=\"en\" style=\"width:" + pct(s.en) + "\"></i></div><div class=\"stn-bl\"><span class=\"me\">我方 " + pct(s.me) + "</span><span class=\"en\">夜冷村 " + pct(s.en) + "</span><span>最近 " + s_(s.n) + " 人</span></div>"
			hh += "<div class=\"stn-hab\"><span>見慣度</span><div class=\"stn-hm\"><i style=\"width:" + s_(n(g(m, "habit")) * 10) + "%\"></i></div><b>" + fixed1(n(g(m, "habit"))) + "</b></div><small>" + stp + "</small>"
			var k2 = 0
			for x in J.iter(g(st(), "log")):
				if k2 >= 3: break
				if s_(g(x, "h")).contains(s_(def.short)): hh += "<p>" + s_(g(x, "h")) + "</p>"; k2 += 1
			J.sp(bd, "innerHTML", hh)
# JS：L(pick(BRYAN_LINES)).replace(/^Bryan：/, 'Bryan：')——等於原句
static func _bryan_line() -> String: return L(pick(BRYAN_LINES))
static func live_draw_char(ctx, id, x: float, y: float, h: float, pose, right: bool, alpha = null) -> void:
	J.mc(ctx, "save", [])
	if alpha != null: J.sp(ctx, "globalAlpha", alpha)
	var ok = false
	var MA = G("MeshAnim")
	if has("MeshAnim") and t_(J.gp(g(MA, "RIG"), id)): ok = t_(J.mc(MA, "draw", [ctx, id, x, y, h, pose, right]))
	if not ok:
		var img = g(G("SPR"), id)
		if t_(img):
			var w = h * n(g(img, "width")) / n(g(img, "height")); var bob = nz(g(pose, "_bob")) if t_(pose) else 0.0
			J.mc(ctx, "translate", [x, y + bob])
			if not right: J.mc(ctx, "scale", [-1.0, 1.0])
			J.mc(ctx, "drawImage", [img, -w / 2, -h, w, h])
	J.mc(ctx, "restore", [])
static func _anim(name: String, v: float): return J.mc(J.gp(G("MeshAnim"), "ANIM"), name, [v])
static func live_draw() -> void:
	var V = LIVE; var ctx = V.ctx; var def = V.def; var m = ms(def.id); var W0 = n(V.W); var H0 = n(V.H); var img = live_img(); var sc = live_sc()
	var T = live_top(); var BH = live_bg_h()
	if not t_(V.get("_sky")) or n(V._sky.h) != H0:
		var gg = J.mc(ctx, "createLinearGradient", [0.0, 0.0, 0.0, H0]); J.mc(gg, "addColorStop", [0.0, "#0b0818"]); J.mc(gg, "addColorStop", [0.5, "#1c1430"]); J.mc(gg, "addColorStop", [1.0, "#100b1c"]); V["_sky"] = {"g": gg, "h": H0}
	J.sp(ctx, "fillStyle", V._sky.g); J.mc(ctx, "fillRect", [0.0, 0.0, W0, H0])
	if t_(img):
		var sx = n(def.seg[0]) + n(V.camX) / sc; var sw = W0 / sc; J.mc(ctx, "drawImage", [img, sx, 0.0, sw, g(img, "height"), 0.0, T, W0, BH])
	J.sp(ctx, "fillStyle", "rgba(40,20,80,0.22)"); J.mc(ctx, "fillRect", [0.0, T, W0, BH])
	J.sp(ctx, "fillStyle", "#2a1f3d"); J.mc(ctx, "fillRect", [0.0, T + BH, W0, H0 - T - BH]); J.sp(ctx, "fillStyle", "rgba(0,0,0,.35)"); J.mc(ctx, "fillRect", [0.0, T + BH, W0, 3.0])
	var h = live_person_h(); var y0 = T + BH * n(def.walkY); var t = n(V.t)
	for i in def.posts.size():
		var p = def.posts[i]; var pxy = live_post_xy(i); var px = pxy[0]; var py = pxy[1]
		if px < -h or px > W0 + h: continue
		J.sp(ctx, "fillStyle", "rgba(160,120,255,0.18)"); J.mc(ctx, "beginPath", []); J.mc(ctx, "ellipse", [px, py + 4, h * 0.42, h * 0.07, 0.0, 0.0, PI * 2]); J.mc(ctx, "fill", [])
		J.sp(ctx, "font", "bold " + s_(J.round(h * 0.075)) + "px sans-serif"); J.sp(ctx, "textAlign", "center"); J.sp(ctx, "fillStyle", "#d9ccff"); J.sp(ctx, "strokeStyle", "rgba(0,0,0,.7)"); J.sp(ctx, "lineWidth", 3.0)
		var lb = s_(i + 1) + ". " + s_(p.name)
		J.mc(ctx, "strokeText", [lb, px, py + h * 0.17]); J.mc(ctx, "fillText", [lb, px, py + h * 0.17])
		var gid = J.gp(g(m, "posts"), float(i)); var gh = ghost(gid) if gid != null else null
		if t_(gh):
			var act = t_(g(gh, "_act")) and t - n(g(gh, "_act")) < 0.8
			var pose = _anim("attack", (t - n(g(gh, "_act"))) * 1.4 + 0.5) if act else _anim("idle", t + i)
			live_draw_char(ctx, g(gh, "k"), px - h * 0.18, py - h * 0.05 + sin(t * 2 + i) * 3, h * 0.82, pose, true, 0.85)
			var mor = 100.0 if J.gp(g(m, "morale"), gid) == null else n(J.gp(g(m, "morale"), gid))
			J.sp(ctx, "fillStyle", "rgba(0,0,0,.55)"); J.mc(ctx, "fillRect", [px - h * 0.4, py - h * 1.02, h * 0.44, 6.0]); J.sp(ctx, "fillStyle", "#7be08a" if mor > 40 else "#ff7070"); J.mc(ctx, "fillRect", [px - h * 0.4, py - h * 1.02, h * 0.44 * mor / 100, 6.0])
			if t_(J.gp(g(m, "boost"), float(i))): J.sp(ctx, "fillStyle", "#ffb347"); J.mc(ctx, "fillText", ["大招", px - h * 0.18, py - h * 1.08])
		var e = J.gp(g(m, "enemy"), float(i))
		if t_(e):
			var ek = s_(g(e, "k")); var br = ek == "bryan"; var id = "npc_rival" if br else ek; var eh = h * 0.95 if br else h * 0.72
			live_draw_char(ctx, id, px + h * 0.32, py - h * 0.04 + sin(t * 2.4 + i * 2) * 3, eh, _anim("idle", t * 1.2 + i), false, 1.0 if br else 0.85)
			J.sp(ctx, "fillStyle", "rgba(0,0,0,.55)"); J.mc(ctx, "fillRect", [px + h * 0.12, py - h * 1.02, h * 0.4, 6.0]); J.sp(ctx, "fillStyle", "#ff6a6a"); J.mc(ctx, "fillRect", [px + h * 0.12, py - h * 1.02, h * 0.4 * maxf(0.0, n(g(e, "hp"))) / (220.0 if br else 100.0), 6.0])
			J.sp(ctx, "fillStyle", "#ffb0b0"); J.mc(ctx, "strokeText", ["夜冷村・" + RNAME[ek], px + h * 0.32, py - h * 1.08]); J.mc(ctx, "fillText", ["夜冷村・" + RNAME[ek], px + h * 0.32, py - h * 1.08])
	var sorted = J.mc(V.walkers.duplicate(), "sort", [func(_t, a): return n(a[0].x) - n(a[1].x)])
	for P in sorted:
		var x = live_sx(n(P.x))
		if x < -h or x > W0 + h: continue
		var scared = P.get("scaredT") != null and t - n(P.scaredT) < 0.8; var right = n(def.dir) > 0
		var pose = _anim("scared", t - n(P.scaredT)) if scared else _anim("walk", t * (1.8 if t_(P.get("flee")) else 1.0) + n(P.hp))
		J.sp(pose, "_bob", -8.0 if scared else absf(sin(t * 7 + n(P.hp))) * -3)
		live_draw_char(ctx, P.spr, x, y0 + 6, h, pose, right)
		var fw = h * 0.5; var fy = y0 - h * 1.08
		J.sp(ctx, "fillStyle", "rgba(0,0,0,.55)"); J.mc(ctx, "fillRect", [x - fw / 2, fy, fw, 7.0]); J.sp(ctx, "fillStyle", "#ffe066" if n(P.fear) >= n(P.hp) else "#c58bff"); J.mc(ctx, "fillRect", [x - fw / 2, fy, fw * minf(1.0, n(P.fear) / n(P.hp)), 7.0])
		J.sp(ctx, "font", s_(J.round(h * 0.07)) + "px sans-serif"); J.sp(ctx, "textAlign", "center"); J.sp(ctx, "lineWidth", 3.0); J.sp(ctx, "strokeStyle", "rgba(0,0,0,.75)")
		var wk = []
		for k in P.weak: wk.append(W_[s_(k)])
		var lab = ("被夜冷村嚇走" if J.seq(P.by, 2.0) else "嚇破膽！") if t_(P.get("flee")) else s_(P.name) + "　怕" + "、".join(wk) + ("　要" + s_(P.tough) + "連嚇" if n(P.tough) > 1 else "")
		J.sp(ctx, "fillStyle", ("#ff8a8a" if J.seq(P.by, 2.0) else "#ffe066") if t_(P.get("flee")) else "#fff"); J.mc(ctx, "strokeText", [lab, x, fy - 6]); J.mc(ctx, "fillText", [lab, x, fy - 6])
	for f in V.fx:
		var a = maxf(0.0, 1 - n(f.a) / 2.2); J.sp(ctx, "globalAlpha", a); J.sp(ctx, "font", "bold " + s_(J.round(h * 0.085)) + "px sans-serif"); J.sp(ctx, "textAlign", "center"); J.sp(ctx, "lineWidth", 4.0); J.sp(ctx, "strokeStyle", "rgba(0,0,0,.8)"); J.sp(ctx, "fillStyle", f.c)
		var y = n(f.y) - n(f.a) * 28; J.mc(ctx, "strokeText", [f.t, f.x, y]); J.mc(ctx, "fillText", [f.t, f.x, y])
	J.sp(ctx, "globalAlpha", 1.0)

static func init() -> void:
	# testHook：只喺 window.STN_TEST 先做（Godot 冇），略
	var Wn = G("window")
	if t_(g(Wn, "STN_TEST")): push_warning("Station: STN_TEST not supported natively")
	var PO = G("POSTS")
	if has("POSTS") and not t_(g(PO, "station")): J.sp(PO, "station", {"name": "陽間站崗", "bld": null, "stat": 2.0, "desc": "在陽間地盤站崗嚇路人"})
	st()
	J.F_setInterval([func(_t, _a):
		if not t_(LIVE.on): tick()
		return null, 5000.0])
	J.S_window_("addEventListener", ["resize", func(_t, _a):
		if t_(LIVE.on): live_resize()
		return null])

static func _boot() -> void:
	var S = S_()
	if not has("S") or not t_(S) or not t_(g(S, "ghosts")) or not has("UI"):
		J.F_setTimeout([func(_t, _a): _boot(); return null, 300.0]); return
	init()

func run(_env) -> void:
	var f = FileAccess.open("res://data/nat/station.json", FileAccess.READ)
	var d = JSON.parse_string(f.get_as_text())
	MAPS = d.MAPS; TUNE = d.TUNE; SKIT = d.SKIT; LEGEND = d.LEGEND
	if has("LANG"): J.mc(G("LANG"), "add", [d.ZH])
	LIVE = {"on": false, "def": null, "cv": null, "ctx": null, "camX": 0.0, "last": 0.0, "walkers": [], "fx": [], "spawnAcc": 0.0, "raf": 0.0,
		"open": func(_t, a): live_open(J.arg(a, 0)); return null,
		"close": func(_t, _a): live_close(); return null,
		"resize": func(_t, _a): live_resize(); return null,
		"img": func(_t, _a): return live_img(),
		"bgH": func(_t, _a): return live_bg_h(),
		"top": func(_t, _a): return live_top(),
		"sc": func(_t, _a): return live_sc(),
		"maxCam": func(_t, _a): return live_max_cam(),
		"sx": func(_t, a): return live_sx(J.num(J.arg(a, 0))),
		"personH": func(_t, _a): return live_person_h(),
		"bindPan": func(_t, _a): live_bind_pan(); return null,
		"postXY": func(_t, a): return live_post_xy(int(J.num(J.arg(a, 0)))),
		"tap": func(_t, a): live_tap(J.arg(a, 0)); return null,
		"float": func(_t, a): live_float(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.arg(a, 2), J.str(J.arg(a, 3))); return null,
		"frame": func(_t, a): live_frame(J.num(J.arg(a, 0))); return null,
		"step": func(_t, a): live_step(J.num(J.arg(a, 0))); return null,
		"drawChar": func(_t, a): live_draw_char(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5), J.t(J.arg(a, 6)), J.arg(a, 7)); return null,
		"draw": func(_t, _a): live_draw(); return null,
	}
	J.G["Station"] = {
		"MAPS": MAPS, "TUNE": TUNE,
		"st": func(_t, _a): return st(),
		"ms": func(_t, a): return ms(J.arg(a, 0)),
		"tick": func(_t, _a): tick(); return null,
		"simOne": func(_t, a): return sim_one(J.arg(a, 0), J.arg(a, 1)),
		"assign": func(_t, a): assign(J.arg(a, 0), J.num(J.arg(a, 1)), J.arg(a, 2)); return null,
		"hitRival": func(_t, a): return hit_rival(J.arg(a, 0), J.num(J.arg(a, 1))),
		"boost": func(_t, a): return boost(J.arg(a, 0), J.num(J.arg(a, 1))),
		"share": func(_t, a): return share(J.arg(a, 0)),
		"status": func(_t, a): return status(J.arg(a, 0)),
		"openPanel": func(_t, _a): open_panel(); return null,
		"entryHTML": func(_t, _a): return entry_html(),
		"panelHTML": func(_t, _a): return panel_html(),
		"Live": LIVE,
		"init": func(_t, _a): init(); return null,
		"power": func(_t, a): return power(J.arg(a, 0)),
		"freeGhosts": func(_t, _a): return free_ghosts(),
		"legLv": func(_t, a): return leg_lv(J.arg(a, 0), J.arg(a, 1)),
		"mapOf": func(_t, a): return map_of(J.arg(a, 0)),
		"open": func(_t, a): return open_(J.arg(a, 0)),
	}
	_boot()
