# 原生改寫自 bonds.js（收服劇情＋冤家）；劇本喺 bonds_data（BOND_RECRUIT、BOND_FEUDS）
# 介面同轉譯版一樣：J.G["Bonds"]（連 patches.js 加嘅 _n.story/rec/feud）；init() 包 joinGhost、Rivals.tick、GhostStreet.battleBuffs、UI.openStory
extends RefCounted

const ART3 := {"阿福": "afu", "冼小姐": "npc_hr", "龐總": "npc_kpiboss", "Bryan": "npc_rival"}
const LOOK := {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}, "Bryan": {"base": "ag:spin", "talk": "ag:dribble"}, "冼小姐": {"base": "ag:clip", "talk": "ag:glasses"}}
const WRITTEN := {"旁白": 1, "系統": 1, "主播": 1}
const XWHO := {"hr": "冼小姐", "boss": "龐總", "bryan": "Bryan"}
const END_ZH := {"friends": "和好", "rivals": "死對頭", "united": "同仇敵愾"}
const GAP_ANY := 150
const GAP_FEUD1 := 260
const GAP_FEUD2 := 420
const TAG := {"stage": "收服劇情", "hr": "入職面試", "boss": "入職 KPI", "chat": "村民群組", "news": "陰間新聞台", "sys": "系統通知"}
const BG := {"stage": "village", "hr": "hq", "boss": "hq"}
const OPENERS := [
	["旁白", "兩隻鬼對望，擺好架勢。", "兩隻鬼對望，擺好架勢。", null, {"A": "pose:strike", "B": "pose:strike"}, "shake"],
	["旁白", "空氣突然靜咗。遠處有隻烏鴉，識趣咁飛走咗。", "空氣突然安靜下來。遠處有一隻烏鴉，識趣地飛走了。", null, {"A": "pose:strike", "B": "pose:strike"}, "shake"],
	["旁白", "兩隻鬼同時出招——停喺半空，邊個都冇打落去。", "兩隻鬼同時出招——停在半空，誰都沒打下去。", null, {"A": "pose:strike", "B": "pose:strike"}, "shake,flash"],
]
const TO_BE := ["旁白", "（兩隻鬼約好：下次再嘈。）", "（兩隻鬼約好了：下次再吵。）"]

static var started := false
static var mo = null

static func _g(n: String): return J.G.get(n)
static func _S(): return _g("S")
static func _rec(): var r = _g("BOND_RECRUIT"); return r if r is Dictionary else {}
static func _feuds() -> Array: var f = _g("BOND_FEUDS"); return f if f is Array else []
static func _later(ms: float, f: Callable) -> void: J.F_setTimeout([func(_t, _a): f.call(); return null, ms])
static func _toast(m: String) -> void: J.mc(_g("Fx"), "toast", [m])
static func _save() -> void: J.cl(_g("save"), null, [])

static func seen(id: String) -> bool:
	var S = _S()
	return J.t(S) and J.t(J.gp(S, "seen")) and J.t(J.gp(J.gp(S, "seen"), id))
static func owned(k) -> bool:
	var S = _S()
	if not J.t(S) or not (J.gp(S, "ghosts") is Array): return false
	for g in S.ghosts: if J.str(J.gp(g, "k")) == J.str(k): return true
	return false
static func gname(k) -> String:
	var G = _g("GHOSTS")
	if G is Dictionary and G.get(J.str(k)) is Dictionary and J.t(G[J.str(k)].get("name")): return J.str(G[J.str(k)].name)
	return J.str(k)
static func zh() -> bool:
	var LANG = _g("LANG")
	return LANG == null or J.str(J.gp(LANG, "cur")) != "yue"
static func T(p):
	if p is Array: return DB.N((p[1] if p.size() > 1 and p[1] != null else p[0]) if zh() else p[0])
	return DB.N(p)
static func art(k) -> bool:
	var f = _g("sprOk")
	return J.typeof_(f) != "function" or J.t(J.cl(f, null, [k]))

static func st():
	var S = _S()
	if not J.t(S): return null
	if not J.t(J.gp(S, "bonds")):
		var nb = {"rec": {}, "pend": [], "feud": {}, "gap": 0.0}
		J.sp(S, "bonds", nb)
		var gs = J.gp(S, "ghosts")
		if gs is Array:
			for g in gs: if J.t(_rec().get(J.str(J.gp(g, "k")))): nb.rec[J.str(g.k)] = 1.0
	var b = J.gp(S, "bonds")
	if not J.t(b.get("rec")): b["rec"] = {}
	if not J.t(b.get("pend")): b["pend"] = []
	if not J.t(b.get("feud")): b["feud"] = {}
	if not (b.get("gap") is float or b.get("gap") is int): b["gap"] = 0.0
	return b
static func fs(id) -> Dictionary:
	var b = st(); var i = J.str(id)
	if not J.t(b.feud.get(i)): b.feud[i] = {}
	var f = b.feud[i]
	if not (f.get("st") is float or f.get("st") is int): f["st"] = 0.0
	if not J.t(f.get("picks")): f["picks"] = []
	if not (f.get("wait") is float or f.get("wait") is int): f["wait"] = 0.0
	if not J.t(f.get("end")): f["end"] = null
	return f

# ---------- 角色 ----------
static func key_of(name):
	var n = J.str(name)
	if ART3.has(n): return ART3[n]
	var G = _g("GHOSTS")
	if G is Dictionary:
		for k in G: if J.str(G[k].get("name")) == n: return k
	return null
static func reactor(k, rl) -> String:
	if rl is Array:
		for r in rl: if J.str(r) != J.str(k) and owned(r): return J.str(r)
	var pool = []
	for g in J.gp(_S(), "ghosts"):
		var x = J.str(g.k)
		if x != J.str(k) and x != "afu" and J.t(_rec().get(x)) and art(x): pool.append(x)
	if pool.size() > 0: return pool[int(floor(randf() * pool.size()))]
	return "xiaozhi" if owned("xiaozhi") and J.str(k) != "xiaozhi" else "afu"
static func _mapn(map: Dictionary, n) -> String: return J.str(map[n]) if map.has(n) and J.t(map[n]) else J.str(n)
# [說話者, 粵, 中, 動作?, {A/B: 動作}?, 特效?] → Theater 格式
static func conv(lines: Array, map: Dictionary) -> Array:
	var out = []
	for l in lines:
		var who = _mapn(map, l[0])
		var text = l[2] if zh() or WRITTEN.has(who) else l[1]
		var act = l[3] if l.size() > 3 and J.t(l[3]) else null
		var re0 = l[4] if l.size() > 4 and J.t(l[4]) else null
		var re = null
		if re0 != null:
			re = {}
			for n in re0: re[_mapn(map, n)] = re0[n]
		var ts = J.str(text)
		if act == null and LOOK.has(who) and (ts.contains("！") or ts.contains("？")) and randf() < 0.5:
			act = "ag:jump" if who == "Bryan" else ("ag:yell" if who == "龐總" else "ag:stamp")
		out.append([who, text, act, re, l[5] if l.size() > 5 and J.t(l[5]) else null])
	return out
static func cast_for(lines: Array, first: Array, map: Dictionary) -> Array:
	var names = []
	var add = func(n):
		if J.t(n) and not names.has(n) and n != "旁白" and n != "系統" and n != "主播" and key_of(n) != null: names.append(n)
	for n in first: add.call(n)
	for l in lines: add.call(_mapn(map, l[0]))
	var out = []
	for n in names.slice(0, 4): out.append([n, key_of(n), LOOK[n].duplicate() if LOOK.has(n) else null])
	return out

# ---------- 收服劇情 ----------
static func play_recruit(k, cb, opt) -> bool:
	var d = _rec().get(J.str(k))
	if not J.t(d):
		if J.t(cb): J.cl(cb, null, [])
		return false
	if not J.t(opt): opt = {}
	var R = J.str(J.gp(opt, "r")) if J.t(J.gp(opt, "r")) else reactor(k, d.get("r"))
	var map = {"新": gname(k), "R": gname(R)}
	var title = "%s入村" % gname(k)
	var fin = func(_t, a): if J.t(cb): J.cl(cb, null, [J.arg(a, 0)]); return null
	var f = J.str(d.get("f"))
	if f == "chat" or f == "news" or f == "sys":
		var hm = {"hh": 21, "mm": 3}
		var lines = []
		for l in d.lines:
			var who = _mapn(map, l[0]); var t = l[2] if zh() or WRITTEN.has(who) else l[1]
			if f != "chat": lines.append([who, t]); continue
			hm.mm += 1 + int(floor(randf() * 2))
			if hm.mm > 59: hm.mm -= 60; hm.hh += 1
			lines.append([who, t if who == "旁白" else "%02d:%02d|%s" % [hm.hh, hm.mm, J.str(t)]])
		var sc
		if f == "chat": sc = {"style": "chat", "title": "落魄村村民群", "group": "%s、%s、阿福…" % [gname(k), gname(R)], "av": ["村", "#3f6a5a"], "lines": lines}
		elif f == "news": sc = {"style": "news", "title": "陰間新聞台", "lines": lines}
		else: sc = {"style": "sys", "title": "陰司系統通知", "lines": lines}
		J.mc(_g("Story"), "queue", [sc, func(_t, _a): J.cl(fin, null, [{"skipped": false}]); return null])
		return true
	var lines2 = conv(d.lines, map)
	var first = ["冼小姐", map["新"]] if f == "hr" else (["龐總", map["新"]] if f == "boss" else [map["新"]])
	var cast = cast_for(d.lines, first, map)
	J.mc(_g("Theater"), "play", [{"tag": TAG.get(f, "收服劇情"), "title": title, "bg": BG.get(f, "village"), "cast": cast, "lines": lines2}, fin])
	return true

static func recruit_now(k) -> bool:
	var b = st(); var ks = J.str(k)
	if not J.t(b) or J.t(b.rec.get(ks)): return false
	var np = []
	for x in b.pend: if J.str(x) != ks: np.append(x)
	b["pend"] = np; b["gap"] = 0.0
	play_recruit(ks, func(_t, _a): b.rec[ks] = 1.0; _save(); return null, null)
	return true

# ---------- 冤家 ----------
static func end_of(picks) -> String:
	if picks.has("c"): return "united"
	return "rivals" if picks[0] == picks[1] else "friends"

static func feud_scene(F: Dictionary, stage: int, picks, cb, _replay) -> void:
	var A = gname(F.a); var Bn = gname(F.b); var X = XWHO[J.str(F.x)]; var map = {"A": A, "B": Bn}
	var s = F["s%d" % stage]
	var lines = conv([OPENERS[(J.str(F.id).length() + stage) % OPENERS.size()]] + s.lines, map)
	var finish = func(picks2):
		if stage == 1: return conv([TO_BE], map)
		var e = end_of(picks2); var out = conv(F.end[e], map)
		var re = {A: "pose:strike", Bn: "pose:strike"} if e == "rivals" else null
		out.append(["旁白", "【冤家結局：%s】" % END_ZH[e], null, re, "joss" if e == "friends" else ("shake" if e == "rivals" else "flash")])
		return out
	var opt = func(k):
		var o = s[k]
		return {"lines": conv(o.lines, map), "on": func(_t, a):
			var p = J.arg(a, 0)
			return finish.call([p] if stage == 1 else (picks if picks is Array else []) + [p])}
	var xl = (s.x.label[1] if s.x.label.size() > 1 and J.t(s.x.label[1]) else s.x.label[0]) if J.t(s.x.get("label")) else "交俾第三方"
	var ca = {"label": "站%s那邊" % A}; ca.merge(opt.call("a"))
	var cb_ = {"label": "站%s那邊" % Bn}; cb_.merge(opt.call("b"))
	var cc = {"label": xl}; cc.merge(opt.call("x"))
	var choice = {"q": "%s和%s吵起來了。阿福站哪一邊？" % [A, Bn], "a": ca, "b": cb_, "c": cc, "plain": true}
	var cast = [[A, F.a], ["阿福", "afu"], [Bn, F.b], [X, ART3[X], LOOK[X].duplicate()]]
	var Th = _g("Theater")
	J.mc(Th, "play", [{"tag": "冤家", "title": "%s（%d／2）" % [J.str(T(F.title)), stage], "bg": "village", "cast": cast, "xs": [0.15, 0.4, 0.85, 0.63], "lines": lines, "choice": choice}, cb])
	# 第三方先唔出場：揀咗 x 先飄入嚟
	var c = J.mc(Th, "cast", [])
	var xa = J.gp(c, 3.0) if J.t(c) else null
	if J.t(xa):
		J.sp(xa, "tx", J.gp(xa, "px"))
		var oc = cc.on
		cc["on"] = func(_t, a):
			J.sp(xa, "tx", J.gp(xa, "home"))
			var af = J.gp(c, 1.0)
			if J.t(af): J.sp(af, "tx", J.num(J.gp(J.mc(Th, "size", []), "W")) * 0.36)
			return J.cl(oc, null, a)

static func play_feud(id, cb, opt) -> bool:
	if not J.t(opt): opt = {}
	var F = null
	for x in _feuds(): if J.str(x.id) == J.str(id): F = x; break
	if F == null: return false
	var replay = J.t(J.gp(opt, "replay"))
	var f
	if replay:
		var pk = J.gp(opt, "picks")
		f = {"st": (J.num(J.gp(opt, "stage")) if J.t(J.gp(opt, "stage")) else 1.0) - 1, "picks": (pk.duplicate() if pk is Array else [])}
	else: f = fs(id)
	var stage = int(J.num(f.st)) + 1
	if stage > 2: return false
	feud_scene(F, stage, f.picks, func(_t, a):
		var res = J.arg(a, 0)
		if replay or not J.t(res) or J.t(J.gp(res, "skipped")) or not J.t(J.gp(res, "choice")):
			if J.t(cb): J.cl(cb, null, [res])
			return null
		var c = J.gp(res, "choice"); f.picks.append(c); f["st"] = float(stage); f["wait"] = 0.0
		if stage == 2: f["end"] = end_of(f.picks); _toast(end_toast(F, f.end))
		_save()
		var UI = _g("UI")
		if J.t(UI) and J.t(J.gp(UI, "refresh")): J.mc(UI, "refresh", [])
		if J.t(cb): J.cl(cb, null, [res])
		return null, replay)
	return true

static func end_toast(F, e) -> String:
	var A = gname(F.a); var Bn = gname(F.b)
	if e == "friends": return "冤家和好：<b>%s＋%s</b>，同隊出陣攻擊、生命 +8%%" % [A, Bn]
	if e == "rivals": return "冤家變死對頭：<b>%s／%s</b>，同隊出陣攻擊 −3%%（還會在戰場上吵架）" % [A, Bn]
	return "同仇敵愾：<b>%s＋%s</b>，同隊出陣開場能量 +25" % [A, Bn]

static func feud_ready(F) -> bool:
	if not owned(F.a) or not owned(F.b) or not art(F.a) or not art(F.b) or not art(ART3[XWHO[J.str(F.x)]]): return false
	var b = st()
	if (J.t(_rec().get(J.str(F.a))) and not J.t(b.rec.get(J.str(F.a)))) or (J.t(_rec().get(J.str(F.b))) and not J.t(b.rec.get(J.str(F.b)))): return false
	var f = fs(F.id)
	if J.num(f.st) >= 2: return false
	return J.num(f.wait) >= (GAP_FEUD1 if J.num(f.st) == 0 else GAP_FEUD2)

# ---------- 排程（Rivals.tick 之前問） ----------
static func tick() -> bool:
	var b = st()
	if not J.t(b) or not seen("prologue_sys"): return false
	b["gap"] = J.num(b.gap) + 1
	for F in _feuds():
		if owned(F.a) and owned(F.b):
			var f = fs(F.id)
			if J.num(f.st) < 2: f["wait"] = J.num(f.wait) + 1
	if b.pend.size() > 0 and J.num(b.gap) >= 3:
		for x in b.pend: if art(x): return recruit_now(x)
	if J.num(b.gap) < GAP_ANY or not seen("ch1_end"): return false
	var ready = []
	for F in _feuds(): if feud_ready(F): ready.append(F)
	if ready.is_empty(): return false
	if randf() > 1.0 / 30: return false
	var F = ready[int(floor(randf() * ready.size()))]; b["gap"] = 0.0
	return play_feud(F.id, null, null)

# ---------- 戰鬥 ----------
static func team_pairs(units) -> Array:
	var ks = {}
	for u in J.iter(units): if J.num(J.gp(u, "side")) == 0 and not J.t(J.gp(u, "minion")): ks[J.str(J.gp(u, "k"))] = true
	var b = st(); var out = []
	if not J.t(b): return out
	for F in _feuds():
		var f = b.feud.get(J.str(F.id))
		if J.t(f) and J.t(f.get("end")) and ks.has(J.str(F.a)) and ks.has(J.str(F.b)): out.append([F, f.end])
	return out

static func battle_fx(units) -> void:
	var pairs = team_pairs(units)
	if pairs.is_empty(): return
	var msgs = []
	for pe in pairs:
		var F = pe[0]; var e = pe[1]
		var us = []
		for u in J.iter(units): if J.num(J.gp(u, "side")) == 0 and (J.str(J.gp(u, "k")) == J.str(F.a) or J.str(J.gp(u, "k")) == J.str(F.b)): us.append(u)
		if e == "friends":
			for u in us: J.sp(u, "atk", J.num(J.gp(u, "atk")) * 1.08); J.sp(u, "maxhp", J.num(J.gp(u, "maxhp")) * 1.08); J.sp(u, "hp", J.num(J.gp(u, "hp")) * 1.08)
			msgs.append("冤家同隊 %s＋%s：攻擊、生命 +8%%" % [gname(F.a), gname(F.b)])
		elif e == "united":
			for u in us: J.sp(u, "energy", minf(100, J.num(J.gp(u, "energy")) + 25))
			msgs.append("同仇敵愾 %s＋%s：開場能量 +25" % [gname(F.a), gname(F.b)])
		else:
			for u in us: J.sp(u, "atk", J.num(J.gp(u, "atk")) * 0.97)
			msgs.append("死對頭同隊 %s／%s：攻擊 −3%%" % [gname(F.a), gname(F.b)])
			var FF = F
			var say = func(n: int):
				var Bt = _g("Battle")
				if Bt == null or not J.t(J.gp(Bt, "active")): return
				var want = J.str(FF.b if n % 2 else FF.a); var uu = null
				for v in J.iter(J.gp(Bt, "units")):
					if J.num(J.gp(v, "side")) == 0 and J.str(J.gp(v, "k")) == want and J.num(J.gp(v, "hp")) > 0: uu = v; break
				if uu == null: return
				J.mc(J.gp(Bt, "fx"), "push", [{"x": J.gp(uu, "x"), "y": J.num(J.mc(Bt, "uy", [uu])) - 125, "text": T(FF.rb), "col": "#ffd0a0", "t": 0.0, "life": 2.2, "skill": true}])
			_later(1800.0, func(): say.call(0)); _later(3600.0, func(): say.call(1)); _later(14000.0, func(): say.call(2))
	_toast("<br>".join(msgs))

# ---------- 名冊：冤家一行 ----------
static func bond_line(k) -> String:
	var b = st()
	if not J.t(b): return ""
	var out = []; var ks = J.str(k)
	for F in _feuds():
		if J.str(F.a) != ks and J.str(F.b) != ks: continue
		var f = b.feud.get(J.str(F.id))
		if not J.t(f) or not J.t(f.get("st")): continue
		var o = F.b if J.str(F.a) == ks else F.a
		out.append("冤家：%s（%s）" % [gname(o), END_ZH[f.end] if J.t(f.get("end")) else "吵架中"])
	return "　".join(out)

static func paint_roster() -> void:
	var doc = _g("document"); var sh = J.S_document_("querySelector", ["#sheet"])
	if not J.t(sh): return
	for c in J.iter(J.mc(sh, "querySelectorAll", [".gcard"])):
		if J.t(J.mc(c, "querySelector", [".bondln"])): continue
		var cv = J.mc(c, "querySelector", ["canvas[data-por]"]); var main = J.mc(c, "querySelector", [".gc-main"])
		if not J.t(cv) or not J.t(main): continue
		var t = bond_line(J.gp(J.gp(cv, "dataset"), "por"))
		if t == "": continue
		var e = J.S_document_("createElement", ["small"]); J.sp(e, "className", "tr bondln"); J.sp(J.gp(e, "style"), "color", "#ffb4a0"); J.sp(e, "textContent", t); J.mc(main, "appendChild", [e])

# ---------- 重溫 ----------
static func _replay_feud(id: String, f) -> void:
	play_feud(id, func(_t, a):
		var r = J.arg(a, 0)
		if J.num(f.st) >= 2 and J.t(r) and not J.t(J.gp(r, "skipped")):
			_later(300.0, func(): play_feud(id, null, {"replay": true, "stage": 2.0, "picks": [f.picks[0]]}))
		return null, {"replay": true, "stage": 1.0})

static func story_hook() -> void:
	var doc = _g("document")
	var body = J.S_document_("querySelector", ["#sheet .sh-body"])
	var hr = J.mc(body, "querySelector", ["hr"]) if J.t(body) else null
	if not J.t(hr): return
	var b = st()
	if not J.t(b): return
	var rec = []
	for k in _rec(): if J.t(b.rec.get(k)) and owned(k): rec.append(k)
	var fds = []
	for F in _feuds():
		var f = b.feud.get(J.str(F.id))
		if J.t(f) and J.num(f.get("st")) >= 1: fds.append(F)
	var div = J.S_document_("createElement", ["div"])
	var h = "<h4 class=\"stand-h\">收服劇情・冤家</h4><p class=\"desc\">收服名鬼後會上演入村劇情；有些鬼天生不和，日後會吵起來（%d/%d）。</p><div class=\"slist\">" % [fds.size(), _feuds().size()]
	for k in rec: h += "<button class=\"btn wide\" data-brec=\"%s\">%s入村</button>" % [k, gname(k)]
	for F in fds:
		var f = b.feud[J.str(F.id)]
		h += "<button class=\"btn wide\" data-bfeud=\"%s\">冤家：%s（%s）</button>" % [J.str(F.id), J.str(T(F.title)), END_ZH[f.end] if J.t(f.get("end")) else "吵架中"]
	h += ("" if rec.size() + fds.size() > 0 else "<p class=\"desc\">還沒有。去收服幾隻名鬼吧。</p>") + "</div>"
	J.sp(div, "innerHTML", h)
	J.mc(J.gp(hr, "parentNode"), "insertBefore", [div, hr])
	for x in J.iter(J.mc(div, "querySelectorAll", ["[data-brec]"])):
		var xx = x
		J.sp(xx, "onclick", func(_t, _a):
			J.mc(_g("UI"), "close", [])
			var kk = J.str(J.gp(J.gp(xx, "dataset"), "brec"))
			_later(60.0, func(): play_recruit(kk, null, null))
			return null)
	for x in J.iter(J.mc(div, "querySelectorAll", ["[data-bfeud]"])):
		var xx = x
		J.sp(xx, "onclick", func(_t, _a):
			J.mc(_g("UI"), "close", [])
			var id = J.str(J.gp(J.gp(xx, "dataset"), "bfeud")); var f = b.feud.get(id)
			_later(60.0, func(): _replay_feud(id, f))
			return null)

# ---------- 接駁 ----------
static func init() -> void:
	if started: return
	started = true
	var oj = _g("joinGhost")
	if J.typeof_(oj) == "function":
		var nj = func(this_, a):
			var k = J.arg(a, 0); var b = st(); var had = owned(k)
			var r = J.cl(oj, this_, a)
			var ks = J.str(k)
			if J.t(b) and not had and owned(k) and J.t(_rec().get(ks)) and not J.t(b.rec.get(ks)) and not b.pend.has(ks):
				b.pend.append(ks); b["gap"] = minf(J.num(b.gap), 0)
			return r
		J.G["joinGhost"] = nj
		var w = _g("window")
		var Gw = J.gp(w, "G") if w != null else null
		if J.t(Gw) and J.t(J.gp(Gw, "joinGhost")): J.sp(Gw, "joinGhost", nj)
	var Rv = _g("Rivals")
	if Rv != null and J.t(J.gp(Rv, "tick")):
		var ot = J.gp(Rv, "tick")
		J.sp(Rv, "tick", func(this_, a):
			if tick(): return true
			return J.cl(ot, this_, a))
	var GS = _g("GhostStreet")
	if GS != null and J.t(J.gp(GS, "battleBuffs")):
		var ob = J.gp(GS, "battleBuffs")
		J.sp(GS, "battleBuffs", func(this_, a):
			var r = J.cl(ob, this_, a)
			var u = J.arg(a, 0)
			battle_fx(u if J.t(u) else [])
			return r)
	var UI = _g("UI")
	if UI != null and J.t(J.gp(UI, "openStory")):
		var os = J.gp(UI, "openStory")
		J.sp(UI, "openStory", func(this_, a):
			var r = J.cl(os, this_, a)
			story_hook()
			return r)
	var sh = J.S_document_("querySelector", ["#sheet"])
	if J.t(sh) and J.typeof_(_g("MutationObserver")) != "undefined":
		mo = J.new_("MutationObserver", [func(_t, _a):
			if J.t(J.mc(sh, "querySelector", [".gcard"])): paint_roster()
			return null])
		J.mc(mo, "observe", [sh, {"childList": true, "subtree": true}])

static func _boot() -> void:
	if not J.t(_S()) and _S() == null or not J.t(J.S_document_("querySelector", ["#sheet"])):
		_later(300.0, func(): _boot()); return
	init()

func run(_env) -> void:
	started = false; mo = null
	var Bd = {
		"_n": {
			"story": func(_t, _a):
				var b = st()
				if not J.t(b): return null
				var rec = []
				for k in _rec(): if J.t(b.rec.get(k)) and owned(k): rec.append({"k": k, "name": gname(k)})
				var fds = []
				for F in _feuds():
					var f = b.feud.get(J.str(F.id))
					if J.t(f) and J.num(f.get("st")) >= 1: fds.append({"id": F.id, "title": T(F.title), "end": END_ZH[f.end] if J.t(f.get("end")) else "吵架中"})
				return {"rec": rec, "fds": fds, "total": float(_feuds().size())},
			"rec": func(_t, a): var k = J.arg(a, 0); _later(60.0, func(): play_recruit(k, null, null)); return null,
			"feud": func(_t, a):
				var id = J.str(J.arg(a, 0)); var f = st().feud.get(id)
				_later(60.0, func(): _replay_feud(id, f)); return null,
		},
		"st": func(_t, _a): return st(),
		"init": func(_t, _a): init(); return null,
		"tick": func(_t, _a): return tick(),
		"playRecruit": func(_t, a): return play_recruit(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"playFeud": func(_t, a): return play_feud(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"recruitNow": func(_t, a): return recruit_now(J.arg(a, 0)),
		"bondLine": func(_t, a): return bond_line(J.arg(a, 0)),
		"battleFx": func(_t, a): battle_fx(J.arg(a, 0)); return null,
		"endOf": func(_t, a): return end_of(J.arg(a, 0)),
		"demo": {
			"recruit": func(_t, a): return play_recruit(J.arg(a, 0), null, {"r": J.arg(a, 1)}),
			"feud": func(_t, a):
				var first = J.arg(a, 2)
				return play_feud(J.arg(a, 0), null, {"replay": true, "stage": J.arg(a, 1) if J.t(J.arg(a, 1)) else 1.0, "picks": [first] if J.t(first) else []}),
		},
		"list": _feuds(), "recruits": _rec(),
	}
	J.G["Bonds"] = Bd
	var w = J.G.get("window")
	if w != null: J.sp(w, "Bonds", Bd)
	_boot()
