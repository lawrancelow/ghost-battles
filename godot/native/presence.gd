# 原生改寫自 presence.js（存在感＋試用期合約）；文字喺 presence_data（PRES_*）
# 介面同轉譯版一樣：J.G["Presence"]（連 patches.js 加嘅 _n.panel/offer、__nat_chip 小牌、__nat_menu 面板）
# 存檔：S.presence / S.contract 格式不變
extends RefCounted

const DAY := 864e5
const HOUR := 36e5
const TUNE := {"DECAY": 4.0, "GRACE": 7.0, "FADE": 60.0, "LOWSTAT": 50.0, "WARN": 25.0, "COUNT": 12.0, "CD_DAYS": 3.0, "AFU_FLOOR": 35.0, "OFFLINE_FLOOR": 13.0,
	"RIPPLE": 6.0, "RIPPLE_STAR": 3.0, "SQUAD": 18.0, "SQUAD_SCARE": 4.0, "SQUAD_CAP": 45.0, "LEGEND": 2.0, "DAILY_LEGEND": 4.0, "WIN": 2.0, "STANDUP": 8.0, "SKIT": 3.0}
const WRITTEN := {"旁白": 1, "系統": 1, "寄件人": 1, "主旨": 1}
const ART3 := {"阿福": "afu", "冼小姐": "npc_hr", "龐總": "npc_kpiboss", "Bryan": "npc_rival"}
const LOOK := {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}, "Bryan": {"base": "ag:spin", "talk": "ag:dribble"}, "冼小姐": {"base": "ag:clip", "talk": "ag:glasses"}}
const OFFER := {"buns": 30.0, "add": 12.0}

static var started := false
static var scenes: Array = []
static var playing := false
static var in_plaza := false
static var last_bub = null
static var scene_gap := 0.0
static var cur = null
static var TU: Dictionary = {}

static func _g(n: String): return J.G.get(n)
static func _S():
	var s = _g("S")
	return s if J.t(s) else null
static func _ghosts() -> Array:
	var S = _S()
	return S.ghosts if S != null and S.get("ghosts") is Array else []
static func _isnum(v) -> bool: return v is float or v is int
static func _toast(m: String) -> void: J.mc(_g("Fx"), "toast", [m])
static func _save() -> void: J.cl(_g("save"), null, [])
static func _fix1(x: float) -> String: return JStr.num_call(x, "toFixed", [1.0])
static func _rnd(a: Array): return a[int(floor(randf() * a.size()))]
static func zh() -> bool:
	var LANG = _g("LANG")
	return LANG == null or J.str(J.gp(LANG, "cur")) != "yue"
static func T(l: Array): return DB.N(l[2] if zh() or WRITTEN.has(J.str(l[0])) else l[1])
static func seen(id: String) -> bool:
	var S = _S()
	return S != null and J.t(S.get("seen")) and J.t(S.seen.get(id))
static func _idx(arr: Array, x) -> int:
	for i in arr.size(): if is_same(arr[i], x): return i
	return -1

# ---------- 時間 ----------
static func clock() -> float:
	var S = _S(); var p = S.get("presence") if S != null else null
	return J.now() + (J.num(p.get("skew")) if J.t(p) and J.t(p.get("skew")) else 0.0)
static func gday(ms: float) -> float:
	var tz = Time.get_time_zone_from_system().get("bias", 0)
	return floor((ms - (-tz) * 60000.0) / DAY)

# ---------- 存檔 ----------
static func st():
	var S = _S()
	if S == null: return null
	if not J.t(S.get("presence")):
		var now = J.now()
		S["presence"] = {"v": 1.0, "p": {}, "t": now, "grace": now + TU.GRACE * DAY, "skew": 0.0, "warn": {}, "cd": {}, "gone": [], "haunt": {}, "day": gday(now), "mailed": {}}
	var p = S.presence
	for k in ["p", "warn", "cd", "haunt", "mailed"]: if not J.t(p.get(k)): p[k] = {}
	if not J.t(p.get("gone")): p["gone"] = []
	if not _isnum(p.get("skew")): p["skew"] = 0.0
	if not J.t(p.get("t")): p["t"] = clock()
	if p.get("grace") == null: p["grace"] = clock() + TU.GRACE * DAY
	if p.get("day") == null: p["day"] = gday(clock())
	for g in _ghosts(): if not _isnum(p.p.get(J.str(g.id))): p.p[J.str(g.id)] = 100.0
	return p
static func cst():
	var S = _S()
	if S == null: return null
	if not J.t(S.get("contract")): S["contract"] = {"rank": 0.0, "state": "none", "start": 0.0, "end": 0.0, "kpi": 0.0, "target": 0.0, "taunted": false, "crisis": null, "hist": []}
	var c = S.contract
	if not J.t(c.get("hist")): c["hist"] = []
	return c
static func is_afu(g) -> bool: return J.t(g) and J.str(J.gp(g, "k")) == "afu"
static func val(g) -> float:
	var p = st()
	if not J.t(p) or not J.t(g): return 100.0
	var v = p.p.get(J.str(J.gp(g, "id")))
	return J.num(v) if _isnum(v) else 100.0
static func set_(g, v: float) -> void:
	var p = st(); var id = J.str(g.id)
	p.p[id] = maxf(0, minf(100, v))
	if p.p[id] > TU.WARN + 5: p.warn.erase(id)
	if p.p[id] > TU.COUNT: p.cd.erase(id)
static func add(g, amt: float) -> void:
	if not J.t(g): return
	if is_afu(g) and J.str(cst().state) == "crisis": return
	set_(g, val(g) + amt)

# ---------- 職級好處 ----------
static func perk(name: String) -> float:
	var c = cst(); var r = J.num(c.get("rank")) if J.t(c) else 0.0
	if name == "squad": return (1.0 if r >= 1 else 0.0) + (1.0 if r >= 3 else 0.0)
	if name == "decay": return 0.7 if r >= 4 else (0.85 if r >= 1 else 1.0)
	if name == "ripple": return 3.0 if r >= 2 else 0.0
	if name == "atk": return 1.05 if r >= 4 else (1.03 if r >= 2 else 1.0)
	return 0.0

# ---------- 流失 ----------
static func _afu():
	for g in _ghosts(): if is_afu(g): return g
	return null
static func _has_scene(kind: String, g = null) -> bool:
	for s in scenes: if s.kind == kind and (g == null or is_same(s.get("g"), g)): return true
	return false

static func update() -> void:
	var p = st(); var c = cst()
	if not J.t(p): return
	var now = clock(); var from = maxf(J.num(p.t), J.num(p.grace)); var dt = maxf(0, now - from); var offline = now - J.num(p.t) > 6 * HOUR
	p["t"] = now
	if dt > 0:
		var d = TU.DECAY * perk("decay") * dt / DAY
		for g in _ghosts():
			var v = val(g) - d
			if is_afu(g): v = minf(val(g), 18) if J.str(c.state) == "crisis" else maxf(TU.AFU_FLOOR, v)
			elif offline and not J.t(p.warn.get(J.str(g.id))): v = maxf(minf(val(g), TU.OFFLINE_FLOOR), v)
			p.p[J.str(g.id)] = maxf(0, minf(100, v))
	if J.str(c.state) == "crisis":
		var a = _afu()
		if a != null: p.p[J.str(a.id)] = minf(val(a), 18)
	# 警告 → 倒數 → 魂飛魄散
	var new_warn = []
	for g in _ghosts():
		if is_afu(g): continue
		var v = val(g); var id = J.str(g.id)
		if v <= TU.WARN and not J.t(p.warn.get(id)): p.warn[id] = 1.0; new_warn.append(g)
		if v <= TU.COUNT and J.t(p.warn.get(id)) and not J.t(p.cd.get(id)):
			p.cd[id] = now + TU.CD_DAYS * DAY
			_toast("<b>%s</b> 存在感只剩 %s：魂飛魄散倒數 %s 日" % [J.str(g.name), J.str(J.round(v)), J.str(TU.CD_DAYS)])
		if J.t(p.cd.get(id)) and now >= J.num(p.cd[id]) and v <= TU.COUNT and not _has_scene("farewell", g): scenes.append({"kind": "farewell", "g": g})
	if new_warn.size() > 0: scenes.append({"kind": "mail", "list": new_warn})
	# 新一日：嚇過人嘅地點仲有傳說流傳
	var today = gday(now)
	if today != J.num(p.day):
		p["day"] = today
		for g in _ghosts():
			var locs = p.haunt.get(J.str(g.id))
			if not (locs is Array) or locs.is_empty(): continue
			var s = 0.0
			for l in locs: s += legend_lv(l)
			if s > 0: add(g, minf(TU.DAILY_LEGEND, s))

static func legend_lv(loc) -> float:
	var Sc = _g("Scare")
	if Sc != null and J.t(J.gp(Sc, "legend")):
		var r = J.mc(Sc, "legend", [loc])
		if _isnum(r): return float(r)
		if J.t(r):
			for k in ["lv", "legendLv", "level"]:
				var v = J.gp(r, k)
				if J.t(v): return J.num(v)
	return 0.0
static func days_left(g):
	var p = st(); var cd = p.cd.get(J.str(g.id))
	return maxf(0, ceil((J.num(cd) - clock()) / DAY)) if J.t(cd) else null

# ---------- 回陽間收工 ----------
static func find_g(key):
	var k = J.str(key)
	for g in _ghosts(): if J.str(g.id) == k: return g
	for g in _ghosts(): if J.str(g.k) == k: return g
	return null
static func night_end(d):
	if _S() == null or not J.t(d): return null
	update()
	var p = st(); var c = cst(); var stars = clampi(J.i32(J.gp(d, "stars")), 0, 3); var lv = J.i32(J.gp(d, "legendLv"))
	var ripple = TU.RIPPLE + TU.RIPPLE_STAR * stars + perk("ripple")
	var squad = []
	var dg = J.gp(d, "ghosts")
	for k in (J.iter(dg) if J.t(dg) else []):
		var g = find_g(k)
		if g != null and _idx(squad, g) < 0: squad.append(g)
	var per = J.gp(d, "perGhost"); if not J.t(per): per = {}
	for k in J.keys(per):
		var g = find_g(k)
		if g != null and _idx(squad, g) < 0: squad.append(g)
	var sq = 0.0; var loc = J.gp(d, "loc")
	for g in _ghosts():
		if is_afu(g) and J.str(c.state) == "crisis": continue
		var a = ripple; var id = J.str(g.id)
		if _idx(squad, g) >= 0:
			var pg = J.gp(per, id); if not J.t(pg): pg = J.gp(per, J.str(g.k))
			var sc = J.i32(J.gp(pg, "scares")) if J.t(pg) else 0
			var b = minf(TU.SQUAD_CAP, TU.SQUAD + TU.SQUAD_SCARE * mini(6, sc)); a += b; sq = maxf(sq, b)
			if J.t(loc):
				if not J.t(p.haunt.get(id)): p.haunt[id] = []
				var h = p.haunt[id]
				if not h.has(loc): h.append(loc)
		elif J.t(loc) and J.t(p.haunt.get(id)) and p.haunt[id].has(loc): a += TU.LEGEND * lv
		set_(g, val(g) + a)
	var pts = kpi_of(d)
	if J.str(c.state) == "active": c["kpi"] = J.num(c.kpi) + pts
	if J.str(c.state) == "crisis" and stars >= 1: c.crisis["ok"] = true
	_toast("回陽間收工：全村存在感 +%s%s%s" % [J.str(ripple), ("，出動的鬼再 +%s" % J.str(sq)) if sq != 0 else "", ("；合約 KPI +%s" % J.str(pts)) if J.str(c.state) == "active" else ""])
	_save()
	return {"ripple": ripple, "squad": sq, "pts": pts}
static func kpi_of(d) -> float:
	var stars = clampi(J.i32(J.gp(d, "stars")), 0, 3)
	return 10.0 * stars + minf(25, 5 * J.i32(J.gp(d, "legendLv"))) + (5.0 if J.i32(J.gp(d, "score")) > 0 else 0.0) - (5.0 if J.t(J.gp(d, "exorcised")) else 0.0)

# ---------- 合約 ----------
static func _ranks() -> Array: return _g("PRES_RANKS")
static func rank_of(i: float): var R = _ranks(); return R[mini(int(i), R.size() - 1)]
static func new_period(extra = 0.0) -> void:
	var c = cst(); var r = rank_of(J.num(c.rank)); var now = clock()
	c["state"] = "active"; c["start"] = now; c["end"] = now + (J.num(r.days) + J.num(extra)) * DAY; c["kpi"] = 0.0; c["target"] = r.target; c["taunted"] = false; c["crisis"] = null
static func has(k: String) -> bool: return cur == k or _has_scene(k)
static func contract_tick() -> void:
	var c = cst(); var now = clock(); var a = _afu()
	var state = J.str(c.state)
	if state == "none":
		if seen("ch1_end") and not has("issue"): scenes.append({"kind": "issue"})
		return
	if state == "active":
		if J.num(c.kpi) >= J.num(c.target) and not has("promote"): scenes.append({"kind": "promote"}); return
		if now >= J.num(c.end) and J.num(c.kpi) < J.num(c.target) and not has("crisis"): scenes.append({"kind": "crisis"}); return
		var el = (now - J.num(c.start)) / (J.num(c.end) - J.num(c.start))
		if not J.t(c.get("taunted")) and el > 0.55 and J.num(c.kpi) < J.num(c.target) * 0.5 and not has("taunt"): scenes.append({"kind": "taunt"})
	if state == "crisis":
		if a != null: st().p[J.str(a.id)] = minf(val(a), 18)
		if J.t(c.crisis.get("ok")) and not has("redeem"): scenes.append({"kind": "redeem"})
		elif not J.t(c.crisis.get("ok")) and now >= J.num(c.crisis.end) and not has("more"): scenes.append({"kind": "more"})

# ---------- 劇場 ----------
static func key_of(n):
	var s = J.str(n)
	if ART3.has(s): return ART3[s]
	var G = _g("GHOSTS")
	for k in G: if J.str(G[k].get("name")) == s: return k
	return null
static func reactor(not_g):
	var gs = _ghosts()
	for k in ["xiaozhi", "mengpo", "eguiking", "tianhua", "laojiang", "toyol"]:
		var hasg = false
		for g in gs: if J.str(g.k) == k: hasg = true; break
		if hasg and (not J.t(not_g) or k != J.str(not_g.k)):
			for g in gs: if J.str(g.k) == k: return g
	var G = _g("GHOSTS")
	for g in gs: if not is_afu(g) and not is_same(g, not_g) and G.get(J.str(g.k)) != null: return g
	return null
static func stage(lines: Array, g, title: String, tag: String, cb: Callable) -> void:
	var R = reactor(g)
	var nm = func(w):
		if w == "G": return J.str(g.name) if J.t(g) else "？"
		if w == "R": return J.str(R.name) if R != null else "小紙"
		return w
	var lns = []
	for l in lines: lns.append([nm.call(l[0]), "%s" % J.str(T(l)).replace("{n}", J.str(g.name) if J.t(g) else ""), l[3] if l.size() > 3 and J.t(l[3]) else null])
	var names = []
	for l in lns: if l[0] != "旁白" and l[0] != "系統" and not names.has(l[0]): names.append(l[0])
	var cast = []
	for n in names.slice(0, 4):
		var k = g.k if J.t(g) and n == J.str(g.name) else (R.k if R != null and n == J.str(R.name) else key_of(n))
		cast.append([n, k if J.t(k) else "afu", LOOK[n].duplicate() if LOOK.has(n) else null])
	J.mc(_g("Theater"), "play", [{"tag": tag, "title": title, "bg": "village", "cast": cast, "lines": lns}, func(_t, _a): cb.call(); return null])
static func chat(lines: Array, title: String, cb: Callable) -> void:
	var ls = []
	for l in lines: ls.append([l[0], T(l)])
	J.mc(_g("Story"), "queue", [{"style": "chat", "title": title, "group": "小紙、孟婆、餓鬼王、Toyol…", "av": ["村", "#3f6a5a"], "lines": ls}, func(_t, _a): cb.call(); return null])
static func quiet() -> bool:
	var Th = _g("Theater")
	if playing or (Th != null and J.t(J.gp(Th, "on"))): return false
	var Sk = _g("Skits")
	if Sk != null and J.t(J.gp(Sk, "quiet")): return J.t(J.mc(Sk, "quiet", []))
	var St = _g("Story"); var Bt = _g("Battle")
	return not (St != null and J.t(J.mc(St, "busy", []))) and not (Bt != null and J.t(J.gp(Bt, "active")))

static func _done() -> void:
	playing = false; cur = null; scene_gap = 4.0
	_save()
	var UI = _g("UI")
	if J.t(J.gp(UI, "refresh")): J.mc(UI, "refresh", [])
	hud()

static func run_scene(s: Dictionary) -> void:
	var c = cst(); var TX = _g("PRES_TXT"); var R = _ranks()
	var done = func(): _done()
	playing = true; cur = s.kind
	match J.str(s.kind):
		"issue":
			stage(TX.issue, null, "試用期合約", "合約", func():
				new_period(3); _done()
				_toast("試用期合約：<b>%s 日</b>內 KPI %s。右下角可以查看合約。" % [J.str(J.num(R[0].days) + 3), J.str(R[0].target)]))
		"taunt":
			c["taunted"] = true; stage(_rnd(TX.taunt), null, "Bryan 的冷嘲熱諷", "合約", done)
		"promote":
			var top = J.num(c.rank) >= R.size() - 1; var nr = mini(int(J.num(c.rank)) + 1, R.size() - 1)
			var lines = TX.renew if top else TX.promote[nr]
			stage(lines, null, "年度考核" if top else "升職：%s" % J.str(R[nr].name), "合約", func():
				c.hist.append({"rank": c.rank, "ok": true, "at": clock()})
				if not top:
					c["rank"] = float(nr)
					if nr == 3: J.cl(_g("give"), null, [{"coins": 3000.0}])
				else: J.cl(_g("give"), null, [{"coins": 2000.0}])
				new_period(0); _done()
				_toast("年度考核過關：花紅 冥幣 2000" if top else "升職：<b>%s</b>　解鎖：%s" % [J.str(R[nr].name), J.str(R[nr].unlock)]))
		"crisis":
			c.hist.append({"rank": c.rank, "ok": false, "at": clock()}); c["state"] = "crisis"; c["crisis"] = {"end": clock() + 3 * DAY, "ok": false}
			var a = _afu()
			if a != null: st().p[J.str(a.id)] = 18.0
			stage(TX.crisis, null, "淡化危機", "合約", func(): chat(TX.crisis_chat, "落魄村村民群", done))
		"redeem":
			stage(TX.redeem, null, "被記起", "合約", func():
				var a = _afu(); new_period(0)
				if a != null: set_(a, 100)
				_done(); _toast("阿福被記起了：合約重新計日"))
		"more":
			c.crisis["end"] = clock() + 3 * DAY; stage(TX.crisis_more, null, "延期", "合約", done)
		"mail":
			var names = []
			for g in s.list: if _idx(_ghosts(), g) >= 0 and val(g) <= TU.WARN: names.append(J.str(g.name))
			var list = "、".join(names)
			if list == "": _done(); return
			var ls = []
			for l in TX.warn_mail: ls.append([l[0], J.str(T(l)).replace("{list}", list)])
			J.mc(_g("Story"), "queue", [{"style": "mail", "title": "存在感不足警告", "lines": ls}, func(_t, _a): _done(); return null])
		"farewell":
			var g = s.g
			if _idx(_ghosts(), g) < 0 or val(g) > TU.COUNT: _done(); return
			stage(_rnd(_g("PRES_FAREWELL")), g, "%s・魂飛魄散" % J.str(g.name), "道別", func(): vanish(g); _done())
		"amnesia":
			stage(_rnd(_g("PRES_AMNESIA")), s.g, "%s・失憶回歸" % J.str(s.g.name), "重新招魂", done)
		_: _done()

# ---------- 魂飛魄散／重新招魂 ----------
static func vanish(g) -> void:
	var p = st(); var S = _S(); var id = J.str(g.id)
	p.gone.append({"k": g.k, "name": g.name, "q": g.q, "lv": g.lv, "st": g.get("st"), "arch": g.get("arch") if J.t(g.get("arch")) else null, "at": clock()})
	var ng = []
	for x in S.ghosts: if not is_same(x, g): ng.append(x)
	S["ghosts"] = ng
	var nt = []
	for x in S.team: nt.append(null if J.str(x) == id and x != null else x)
	S["team"] = nt
	if J.str(S.get("adviser")) == id: S["adviser"] = null
	p.p.erase(id); p.warn.erase(id); p.cd.erase(id); p.haunt.erase(id)
	_toast("<b>%s</b> 魂飛魄散了。可以在招魂台重新招魂（會失憶）。" % J.str(g.name))
	_save(); J.mc(_g("UI"), "refresh", [])

static func resummon(i, silent = false):
	var p = st(); var ii = int(J.num(i))
	if ii < 0 or ii >= p.gone.size(): return null
	var o = p.gone[ii]; var S = _S(); var F = _g("F")
	var named = J.str(o.q) == "名"
	var fc = _g("fodderCount")
	if not named and J.typeof_(fc) == "function" and J.num(J.cl(fc, null, [])) >= J.num(J.mc(F, "rosterCap", [])):
		_toast("雜鬼名額已滿"); return null
	var c = J.mc(F, "recruitCost", [])
	if not J.t(silent):
		if not J.t(J.cl(_g("canPay"), null, [c])): _toast("冥幣或壽包不夠"); return null
		J.cl(_g("pay"), null, [c])
	var g = null
	if named:
		J.cl(_g("joinGhost"), null, [o.k])
		for x in _ghosts(): if J.str(x.k) == J.str(o.k): g = x; break
	else:
		var uid = J.num(S.uid); S["uid"] = uid + 1
		g = {"id": "g" + J.str(uid), "k": o.k, "name": o.name, "q": o.q, "lv": 1.0, "st": o.get("st"), "post": null, "spent": 0.0, "arch": o.get("arch")}
		S.ghosts.append(g)
	if g == null: return null
	g["lv"] = maxf(1, J.round((J.num(o.lv) if J.t(o.lv) else 1.0) * 0.5))
	p.gone.remove_at(ii); set_(g, 70)
	var BF = _g("BOND_FEUDS")
	if BF != null and J.t(S.get("bonds")) and J.t(S.bonds.get("feud")):
		for Fd in BF: if J.str(Fd.a) == J.str(g.k) or J.str(Fd.b) == J.str(g.k): S.bonds.feud.erase(J.str(Fd.id))
	scenes.push_front({"kind": "amnesia", "g": g})
	_save(); J.mc(_g("UI"), "refresh", [])
	return g

# ---------- 畫面：透明、閃 ----------
static func alpha_of(g) -> float:
	if not J.t(g): return 1.0
	var v = val(g)
	if v >= TU.FADE: return 1.0
	var a = 0.3 + 0.7 * (v / TU.FADE)
	if v < 15 and randf() < 0.12: a *= 0.25
	return a
static func g_of_key(k):
	if _S() == null or not J.t(_S().get("ghosts")): return null
	if J.str(k) == "afu": return _afu()
	var gs = []
	for g in _ghosts(): if J.str(g.k) == J.str(k): gs.append(g)
	return gs[0] if gs.size() == 1 and J.str(gs[0].q) == "名" else null
static func stat_mult(g) -> float:
	var v = val(g)
	return 1.0 if v >= TU.LOWSTAT else 0.9 + 0.1 * v / TU.LOWSTAT

# ---------- 名冊／招魂台／合約面板 ----------
static func bar(v: float) -> String:
	var col = "#6ec27a" if v > TU.FADE else ("#e0b44a" if v > TU.WARN else "#e0604a")
	return "<span style=\"display:inline-block;vertical-align:middle;width:70px;height:7px;border-radius:4px;background:rgba(0,0,0,.18);overflow:hidden;margin:0 4px\"><i style=\"display:block;height:100%%;width:%s%%;background:%s\"></i></span>" % [J.str(J.round(v)), col]
static func badge(g) -> String:
	var v = val(g); var d = days_left(g)
	if d != null: return "<b style=\"color:#c0392b\">魂飛魄散倒數 %s 日</b>" % J.str(d)
	if v <= TU.WARN: return "<b style=\"color:#c0392b\">⚠ 存在感不足</b>"
	if v < TU.FADE: return "<span style=\"color:#9a7a3a\">變淡中</span>"
	return ""

static func paint_sheet() -> void:
	var doc = _g("document"); var sh = J.S_document_("querySelector", ["#sheet"])
	if not J.t(sh) or _S() == null: return
	for c in J.iter(J.mc(sh, "querySelectorAll", [".gcard"])):
		if J.t(J.mc(c, "querySelector", [".presln"])): continue
		var main = J.mc(c, "querySelector", [".gc-main"])
		if not J.t(main): continue
		var up = J.mc(c, "querySelector", ["[data-up],[data-rel]"]); var g = null
		if J.t(up):
			var ds = J.gp(up, "dataset"); var gid = J.gp(ds, "up"); if not J.t(gid): gid = J.gp(ds, "rel")
			g = find_g_id(gid)
		if g == null:
			var nmb = J.mc(main, "querySelector", ["b"])
			if J.t(nmb):
				for x in _ghosts(): if J.str(x.name) == J.str(J.gp(nmb, "textContent")): g = x; break
		if g == null: continue
		var v = val(g)
		var e = J.S_document_("createElement", ["small"]); J.sp(e, "className", "tr presln"); J.sp(e, "innerHTML", "存在感 %s%s%s" % [J.str(J.round(v)), bar(v), badge(g)]); J.mc(main, "appendChild", [e])
		var cv = J.mc(c, "querySelector", ["canvas"])
		if J.t(cv): J.sp(J.gp(cv, "style"), "opacity", alpha_of(g))
		if is_afu(g) and J.num(cst().rank) >= 5: J.sp(J.gp(c, "style"), "boxShadow", "0 0 0 2px #d9b440, 0 0 10px rgba(217,180,64,.55)"); J.sp(J.gp(c, "style"), "borderRadius", "10px")
	var rc = J.mc(sh, "querySelector", ["[data-act=recruit]"])
	if J.t(rc) and not J.t(J.mc(sh, "querySelector", ["#pres-gone"])):
		var p = st()
		if p.gone.is_empty(): return
		var d = J.S_document_("createElement", ["div"]); J.sp(d, "id", "pres-gone")
		var h = "<h4 class=\"stand-h\">魂飛魄散名單</h4><p class=\"desc\">淡走了的鬼，招魂台上還留著寫有他們名字的黃紙。重新招魂費用跟招魂一樣；回來的會失憶（等級剩一半，冤家關係重新開始）。</p>"
		for i in p.gone.size(): h += "<div class=\"row\"><span>%s　Lv%s</span><button class=\"btn sm gold\" data-regone=\"%d\">重新招魂</button></div>" % [J.str(p.gone[i].name), J.str(p.gone[i].lv), i]
		J.sp(d, "innerHTML", h)
		J.mc(J.gp(J.mc(rc, "closest", [".row"]), "parentNode"), "appendChild", [d])
		for b in J.iter(J.mc(d, "querySelectorAll", ["[data-regone]"])):
			var bb = b
			J.sp(bb, "onclick", func(_t, _a):
				var g = resummon(J.num(J.gp(J.gp(bb, "dataset"), "regone")))
				if g != null: J.mc(_g("UI"), "close", [])
				return null)
static func find_g_id(id):
	for x in _ghosts(): if J.str(x.id) == J.str(id): return x
	return null

static func panel_html() -> String:
	var c = cst(); var now = clock(); var R = _ranks(); var rank = int(J.num(c.rank))
	var h = ""
	if J.str(c.state) == "none": h += "<p class=\"desc\">打完第一章後，龐總會來跟你簽試用期合約。</p>"
	else:
		h += "<p class=\"desc\">職級：<b>%s</b>%s</p>" % [J.str(R[rank].name), "（年度考核）" if rank >= R.size() - 1 else ""]
		if J.str(c.state) == "active":
			var left = maxf(0, (J.num(c.end) - now) / DAY); var pr = minf(1, J.num(c.kpi) / J.num(c.target))
			h += "<p class=\"desc\">KPI %s／%s<span style=\"display:block;height:10px;border-radius:5px;background:rgba(0,0,0,.18);overflow:hidden;margin:4px 0\"><i style=\"display:block;height:100%%;width:%s%%;background:#d9a441\"></i></span>剩下 <b>%s</b> 日</p>" % [J.str(c.kpi), J.str(c.target), J.str(pr * 100), _fix1(left)]
		else: h += "<p class=\"desc\" style=\"color:#c0392b\"><b>淡化危機</b>：%s 日內回陽間完成一晚（一星或以上），阿福就會被記起。不會遊戲結束。</p>" % _fix1(maxf(0, (J.num(c.crisis.end) - now) / DAY))
		var nx = R[rank + 1] if rank + 1 < R.size() else null
		h += "<p class=\"desc\">%s</p>" % (("下一級：<b>%s</b>　解鎖：%s" % [J.str(nx.name), J.str(nx.unlock)]) if nx != null else "已經是最高職級。每期過關有花紅。")
		h += "<p class=\"desc\">KPI 怎樣算：每晚回陽間，每顆星 10 分；傳說熱度每級 5 分（最多 25）；有驚嚇值 5 分；被道士請走扣 5 分。另外陽間地盤每日收租（每 3 個地盤 +1），奪回被搶的地盤 +4。</p>"
	h += "<h4 class=\"stand-h\">村裡的存在感</h4><p class=\"desc\">鬼要有人記得才存在。每天自然流失 %s；回陽間一晚全村 +%s～%s，出動的鬼更多。上台講棟篤笑、打贏仗、在陰間日常出場也有少少。</p>" % [_fix1(TU.DECAY * perk("decay")), J.str(TU.RIPPLE), J.str(TU.RIPPLE + TU.RIPPLE_STAR * 3 + perk("ripple"))]
	var p = st()
	if clock() < J.num(p.grace): h += "<p class=\"desc\">新功能保護期：還有 %s 日不會流失。</p>" % _fix1((J.num(p.grace) - clock()) / DAY)
	h += "<p class=\"desc\">上供品：用 %s 個壽包替一隻鬼上供，存在感 +%s（每隻鬼每日一次）。壽包 %s</p>" % [J.str(OFFER.buns), J.str(OFFER.add), J.str(J.cl(_g("fmt"), null, [_S().res.buns]))]
	var od = p.get("offered") if J.t(p.get("offered")) else {}; var today = gday(clock())
	for g in _sorted_by_val():
		var done = J.num(od.get(J.str(g.id))) == today and od.get(J.str(g.id)) != null
		var btn = (" <button class=\"btn sm %s\" data-offer=\"%s\" %s>%s</button>" % ["" if done else "gold", J.str(g.id), "disabled" if done else "", "已上供" if done else "上供"]) if not is_afu(g) and val(g) < 100 else ""
		h += "<div class=\"row\"><span>%s</span><span>%s%s%s%s</span></div>" % [J.str(g.name), J.str(J.round(val(g))), bar(val(g)), badge(g), btn]
	return h
static func _sorted_by_val() -> Array:
	# JS sort 係穩定排序：同值保持原次序
	var arr = []
	var i = 0
	for g in _ghosts(): arr.append([val(g), i, g]); i += 1
	arr.sort_custom(func(a, b): return a[0] < b[0] or (a[0] == b[0] and a[1] < b[1]))
	var out = []
	for x in arr: out.append(x[2])
	return out

static func offer(id) -> void:
	var g = find_g_id(id); var p = st(); var today = gday(clock()); var S = _S()
	if g == null: return
	if not J.t(p.get("offered")): p["offered"] = {}
	var gid = J.str(g.id)
	if p.offered.get(gid) != null and J.num(p.offered[gid]) == today: return
	if J.num(S.res.get("buns")) < OFFER.buns: _toast("壽包不夠"); return
	S.res["buns"] = J.num(S.res.buns) - OFFER.buns; p.offered[gid] = today; set_(g, val(g) + OFFER.add)
	_toast("替 <b>%s</b> 上供：存在感 +%s" % [J.str(g.name), J.str(OFFER.add)]); _save()

static func open_panel() -> void:
	var nm = _g("__nat_menu")
	if nm != null and J.t(J.cl(nm, null, ["pres"])): return
	J.mc(_g("UI"), "sheet", ["合約與存在感", panel_html()]); bind_panel()
static func bind_panel() -> void:
	var sh = J.S_document_("querySelector", ["#sheet"])
	if not J.t(sh): return
	for b in J.iter(J.mc(sh, "querySelectorAll", ["[data-offer]"])):
		var bb = b
		J.sp(bb, "onclick", func(_t, _a):
			offer(J.gp(J.gp(bb, "dataset"), "offer"))
			var sc = J.mc(sh, "querySelector", [".sh-body"]); var y = J.gp(sc, "scrollTop") if J.t(sc) else 0.0
			if J.t(sc): J.sp(sc, "innerHTML", panel_html()); bind_panel(); J.sp(sc, "scrollTop", y)
			return null)

static func _chip_html(c) -> String:
	var now = clock(); var warn_n = 0
	for g in _ghosts(): if not is_afu(g) and val(g) <= TU.WARN: warn_n += 1
	if J.str(c.state) == "crisis": return "<b>淡化危機</b>　剩 %s 日" % _fix1(maxf(0, (J.num(c.crisis.end) - now) / DAY))
	return "<b>%s</b>　KPI %s/%s　剩 %s 日%s" % [J.str(_ranks()[int(J.num(c.rank))].name), J.str(c.kpi), J.str(c.target), _fix1(maxf(0, (J.num(c.end) - now) / DAY)), ("<br>⚠ %d 隻鬼存在感不足" % warn_n) if warn_n else ""]

static func hud() -> void:
	var doc = _g("document")
	var wrap = J.S_document_("getElementById", ["stagewrap"])
	if not J.t(wrap) or _S() == null: return
	var el = J.S_document_("getElementById", ["pres-chip"]); var c = cst()
	var nc = _g("__nat_chip")
	if nc != null:
		if J.t(el): J.mc(el, "remove", [])
		if J.str(c.state) == "none": J.cl(nc, null, ["pres", "", ""]); return
		J.cl(nc, null, ["pres", _chip_html(c), "cr" if J.str(c.state) == "crisis" else ""]); return
	if J.str(c.state) == "none":
		if J.t(el): J.mc(el, "remove", [])
		return
	if not J.t(el):
		el = J.S_document_("createElement", ["div"]); J.sp(el, "id", "pres-chip"); J.mc(wrap, "appendChild", [el]); J.sp(el, "onclick", func(_t, _a): open_panel(); return null)
		var s = J.S_document_("createElement", ["style"])
		J.sp(s, "textContent", "#pres-chip{position:absolute;right:8px;bottom:8px;z-index:4;padding:6px 10px;background:rgba(20,12,22,.86);color:#f3e6c8;font-size:13px;line-height:1.45;border-radius:4px;box-shadow:inset 0 0 0 1px rgba(243,214,138,.45);cursor:pointer;text-align:right}#pres-chip.cr{box-shadow:inset 0 0 0 1.5px #e0604a;color:#ffb4a0}")
		J.mc(J.gp(doc, "head"), "appendChild", [s])
	var h = _chip_html(c)
	if J.str(J.gp(el, "innerHTML")) != h: J.sp(el, "innerHTML", h)
	J.sp(el, "className", "cr" if J.str(c.state) == "crisis" else "")

# ---------- 主循環 ----------
static func tick() -> void:
	if _S() == null or not J.t(_S().get("ghosts")): return
	update(); contract_tick(); hud()
	if scene_gap > 0: scene_gap -= 2; return
	if scenes.size() > 0 and quiet(): run_scene(scenes.pop_front())

# ---------- 接駁 ----------
static func init() -> void:
	if started: return
	started = true
	st(); cst()
	J.S_window_("addEventListener", ["gb:nightEnd", func(_t, a):
		var e = J.arg(a, 0); var d = J.gp(e, "detail") if J.t(e) else null
		night_end(d if J.t(d) else {})
		return null])
	var ART = _g("ART")
	if ART != null and J.t(J.gp(ART, "drawChar")):
		var od = J.gp(ART, "drawChar")
		J.sp(ART, "drawChar", func(this_, a):
			var S = _S()
			if not in_plaza and S != null and J.t(S.get("presence")):
				var o = J.arg(a, 5); var ctx = J.arg(a, 0)
				var g = null
				if J.t(o) and J.gp(o, "wkey") != null: g = find_g_id(J.gp(o, "wkey"))
				else: g = g_of_key(J.arg(a, 1))
				var m = alpha_of(g) if g != null else 1.0
				if m < 1:
					var no = {}
					if J.t(o): no = J.assign({}, [o])
					var oa = J.gp(no, "alpha")
					no["alpha"] = (J.num(oa) if oa != null else J.num(J.gp(ctx, "globalAlpha"))) * m
					var na = a.duplicate()
					while na.size() < 6: na.append(null)
					na[5] = no
					return J.cl(od, this_, na)
			return J.cl(od, this_, a))
	var PL = _g("PlazaLife")
	if PL != null and J.t(J.gp(PL, "frame")):
		var of_ = J.gp(PL, "frame")
		J.sp(PL, "frame", func(this_, a):
			var items = J.arg(a, 2); var vis = J.arg(a, 3); var ctx = J.arg(a, 4)
			var i0 = J.len(items); var v0 = J.len(vis)
			var r = J.cl(of_, this_, a)
			var nv = J.mc(vis, "slice", [v0]); var nl = J.len(nv)
			var ag = J.mc(items, "slice", [J.len(items) - nl])
			if J.len(items) - i0 >= nl:
				var j = 0
				for it in J.iter(ag):
					var vj = J.gp(nv, float(j)); var g = J.gp(vj, "g") if J.t(vj) else vj
					var f = J.gp(it, "f")
					J.sp(it, "f", func(_t2, _a2):
						var m = alpha_of(g); in_plaza = true
						J.mc(ctx, "save", []); J.sp(ctx, "globalAlpha", J.num(J.gp(ctx, "globalAlpha")) * m)
						J.cl(f, null, [])
						J.mc(ctx, "restore", []); in_plaza = false
						return null)
					j += 1
			return r)
	var V = _g("Village")
	if V != null and J.t(J.gp(V, "update")):
		var ou = J.gp(V, "update")
		J.sp(V, "update", func(this_, a):
			var r = J.cl(ou, this_, a)
			var b = J.gp(this_, "bubble")
			if J.t(b) and not is_same(b, last_bub):
				last_bub = b
				var g = _afu() if J.t(J.gp(b, "hero")) else find_g_id(J.gp(b, "id"))
				if g != null and not is_afu(g) and val(g) <= TU.WARN and J.num(J.gp(b, "t")) < 0.2 and randf() < 0.6:
					var d = days_left(g); var l = _rnd(_g("PRES_COUNT") if d != null else _g("PRES_WORRY"))
					J.sp(b, "text", J.str(l[1] if zh() else l[0]).replace("{n}", J.str(g.name)).replace("{d}", J.str(d) if d != null else ""))
			return r)
	var Bt = _g("Battle")
	if Bt != null:
		if J.t(J.gp(Bt, "mkGhostUnit")):
			var om = J.gp(Bt, "mkGhostUnit")
			J.sp(Bt, "mkGhostUnit", func(this_, a):
				var u = J.cl(om, this_, a); var g = J.arg(a, 0)
				if J.t(u):
					var m = stat_mult(g) * perk("atk"); J.sp(u, "atk", J.num(J.gp(u, "atk")) * m)
					var hm = stat_mult(g); J.sp(u, "hp", J.num(J.gp(u, "hp")) * hm); J.sp(u, "maxhp", J.num(J.gp(u, "maxhp")) * hm)
				return u)
		if J.t(J.gp(Bt, "finish")):
			var ofi = J.gp(Bt, "finish")
			J.sp(Bt, "finish", func(this_, a):
				if J.t(J.arg(a, 0)) and not J.t(J.gp(this_, "result")):
					var us = J.gp(this_, "units")
					for u in (J.iter(us) if J.t(us) else []):
						if J.num(J.gp(u, "side")) == 0 and J.t(J.gp(u, "gid")): add(find_g_id(J.gp(u, "gid")), TU.WIN)
				return J.cl(ofi, this_, a))
	var Su = _g("Standup")
	if Su != null and J.t(J.gp(Su, "play")):
		var op = J.gp(Su, "play")
		J.sp(Su, "play", func(this_, a):
			var id = J.arg(a, 0); var opt = J.arg(a, 1)
			var lst = J.gp(Su, "list"); var b = null
			for x in (J.iter(lst) if J.t(lst) else []): if J.gp(x, "id") == id: b = x; break
			if b != null and not (J.t(opt) and J.t(J.gp(opt, "replay"))):
				for g in _ghosts(): if J.str(g.k) == J.str(J.gp(b, "k")): add(g, TU.STANDUP); break
			return J.cl(op, this_, a))
	var Th = _g("Theater")
	if Th != null and J.t(J.gp(Th, "play")):
		var op2 = J.gp(Th, "play")
		J.sp(Th, "play", func(this_, a):
			var sc = J.arg(a, 0)
			if J.t(sc) and J.str(J.gp(sc, "tag")) == "陰間日常":
				var cs = J.gp(sc, "cast")
				for c in (J.iter(cs) if J.t(cs) else []):
					for x in _ghosts():
						if J.str(x.k) == J.str(J.gp(c, 1.0)) and J.str(x.q) == "名": add(x, TU.SKIT); break
			return J.cl(op2, this_, a))
	var sh = J.S_document_("querySelector", ["#sheet"])
	if J.t(sh) and J.typeof_(_g("MutationObserver")) != "undefined":
		var mo = J.new_("MutationObserver", [func(_t, _a):
			if J.t(J.mc(sh, "querySelector", [".gcard,[data-act=recruit]"])): paint_sheet()
			return null])
		J.mc(mo, "observe", [sh, {"childList": true, "subtree": true}])
	J.F_setInterval([func(_t, _a): tick(); return null, 2000.0])
	tick()

static func _boot() -> void:
	if _S() == null or _g("Village") == null or not J.t(J.S_document_("querySelector", ["#sheet"])):
		J.F_setTimeout([func(_t, _a): _boot(); return null, 300.0]); return
	init()

static func _n_panel():
	var c = cst(); var now = clock(); var o = {"state": c.state}; var R = _ranks()
	if J.str(c.state) != "none":
		var rank = int(J.num(c.rank))
		o["rank"] = R[rank].name; o["top"] = rank >= R.size() - 1
		if J.str(c.state) == "active": o["kpi"] = c.kpi; o["target"] = c.target; o["left"] = maxf(0, (J.num(c.end) - now) / DAY)
		else: o["crisis"] = maxf(0, (J.num(c.crisis.end) - now) / DAY)
		var nx = R[rank + 1] if rank + 1 < R.size() else null
		o["next"] = {"name": nx.name, "unlock": nx.unlock} if nx != null else null
	var p = st()
	o["decay"] = _fix1(TU.DECAY * perk("decay")); o["ripple"] = TU.RIPPLE; o["rippleMax"] = TU.RIPPLE + TU.RIPPLE_STAR * 3 + perk("ripple")
	o["grace"] = _fix1((J.num(p.grace) - clock()) / DAY) if clock() < J.num(p.grace) else null
	o["offer"] = OFFER.duplicate(); o["buns"] = J.cl(_g("fmt"), null, [_S().res.buns])
	var od = p.get("offered") if J.t(p.get("offered")) else {}; var today = gday(clock())
	var lst = []
	for g in _sorted_by_val():
		var ov = od.get(J.str(g.id))
		lst.append({"id": g.id, "name": g.name, "v": J.round(val(g)), "days": days_left(g), "canOffer": not is_afu(g) and val(g) < 100, "done": ov != null and J.num(ov) == today})
	o["list"] = lst
	o["fade"] = TU.FADE; o["warn"] = TU.WARN
	return o

func run(_env) -> void:
	started = false; scenes = []; playing = false; in_plaza = false; last_bub = null; scene_gap = 0.0; cur = null
	TU = TUNE.duplicate()
	var dev = {
		"days": func(_t, a): var p = st(); p["skew"] = J.num(p.skew) + J.num(J.arg(a, 0)) * DAY; update(); contract_tick(); hud(); return null,
		"set": func(_t, a): set_(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"scenes": func(_t, _a): return scenes,
		"run": func(_t, _a): if scenes.size() > 0: run_scene(scenes.pop_front()); return null,
		"play": func(_t, a):
			var s = {"kind": J.arg(a, 0)}
			if J.t(J.arg(a, 1)): s.merge(J.arg(a, 1), true)
			run_scene(s); return null,
		"issue": func(_t, _a): new_period(3); return null,
		"newPeriod": func(_t, a): new_period(J.num(J.arg(a, 0))); return null,
		"vanish": func(_t, a): vanish(J.arg(a, 0)); return null,
		"resummon": func(_t, a): return resummon(J.arg(a, 0), J.arg(a, 1)),
	}
	var P = {
		"_n": {"panel": func(_t, _a): return _n_panel(), "offer": func(_t, a): offer(J.arg(a, 0)); return null},
		"TUNE": TU,
		"st": func(_t, _a): return st(),
		"cst": func(_t, _a): return cst(),
		"val": func(_t, a): return val(J.arg(a, 0)),
		"add": func(_t, a): add(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"perk": func(_t, a): return perk(J.str(J.arg(a, 0))),
		"alphaOf": func(_t, a): return alpha_of(J.arg(a, 0)),
		"statMult": func(_t, a): return stat_mult(J.arg(a, 0)),
		"nightEnd": func(_t, a): return night_end(J.arg(a, 0)),
		"kpiOf": func(_t, a): return kpi_of(J.arg(a, 0)),
		"update": func(_t, _a): update(); return null,
		"contractTick": func(_t, _a): contract_tick(); return null,
		"daysLeft": func(_t, a): return days_left(J.arg(a, 0)),
		"openPanel": func(_t, _a): open_panel(); return null,
		"panelHTML": func(_t, _a): return panel_html(),
		"hud": func(_t, _a): hud(); return null,
		"init": func(_t, _a): init(); return null,
		"tick": func(_t, _a): tick(); return null,
		"dev": dev,
		"__getters": {"playing": func(_t, _a): return playing},
	}
	J.G["Presence"] = P
	var w = J.G.get("window")
	if w != null: J.sp(w, "Presence", P)
	_boot()
