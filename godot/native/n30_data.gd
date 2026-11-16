# 原生改寫自 n30_data.js（新鬼 56 隻：資料＋遇到與收服 N30W）
# 資料（N30G 逐行登記嘅結果）由網頁原碼倒出：data/n30_data.json
extends RefCounted

static var SITES: Dictionary = {}
static var TIER: Dictionary = {}
static var NG: Dictionary = {}

static func _g(n: String): return J.G.get(n)
static func S(): return J.G.get("S")
static func s_(v) -> String: return J.str(v)
static func GH(k): return _g("GHOSTS")[k]

static func ids() -> Array: return NG.keys()
static func st() -> Dictionary:
	var s = S()
	if not J.t(s.get("n30")): s["n30"] = {}
	return s.n30
static func owned(k) -> bool:
	for g in S().ghosts: if g is Dictionary and J.str(g.get("k")) == J.str(k): return true
	return false
static func is_open(k) -> bool:
	var g = NG[k]; var site = SITES[g.at]; var cl = S().cleared
	return J.t(cl.get(J.str(TIER[s_(g.t)].gate))) and (not J.t(site.get("gate")) or J.t(cl.get(J.str(site.gate))))
static func where(k) -> String:
	var g = NG[k]; var site = SITES[g.at]; var T = TIER[s_(g.t)]
	var need = []
	for s in [T.get("gate"), site.get("gate")]: if J.t(s): need.append("打完 " + J.str(s))
	var nd = "、".join(need)
	return "%s　%s%s" % [site.name, ["", "前期", "中期", "後期"][int(g.t)], ("（" + nd + "後）") if nd != "" else ""]

static func road_today() -> Array:
	var s = st(); var day = floor(Time.get_unix_time_from_system() * 1000.0 / 864e5)
	var pool = []
	for k in ids(): if J.str(NG[k].at) == "death" and is_open(k): pool.append(k)
	var stale = true
	if J.t(s.get("road")) and J.num(s.road.get("day")) == day:
		stale = false
		for k in s.road.list: if not pool.has(k): stale = true; break
	if stale:
		var un = []
		for k in pool: if not owned(k): un.append(k)
		var src = un if un.size() >= 2 else pool; var lst = []
		var seed = day * 9301 + 49297
		var a = src.duplicate()
		while lst.size() < 2 and a.size() > 0:
			seed = fmod(seed * 9301 + 49297, 233280.0)
			var i = int(floor(seed / 233280.0 * a.size()))
			lst.append(a[i]); a.remove_at(i)
		s["road"] = {"day": day, "list": lst}
	return s.road.list

static func select_html() -> String:
	var Sv = S()
	if not J.t(Sv.cleared.get("1-3")): return "<div class=\"chap\"><div class=\"ch-h\">野鬼出沒</div><p class=\"desc\">打完第一章，各處開始有野鬼出沒，打贏就可以收服。</p></div>"
	var h = "<div class=\"chap\"><div class=\"ch-h\">野鬼出沒・打贏就收服</div><p class=\"desc\">每隻野鬼第一次打贏就會跟你返村。已收服的可以再戰，賺冥幣。日本妖怪喺冥街夜市暗巷出沒。</p>"
	for sid in ["field", "road", "kampung", "banana", "death"]:
		var site = SITES[sid]
		var ks = []
		for k in ids(): if J.str(NG[k].at) == sid: ks.append(k)
		if sid == "death": ks = road_today()
		var op = []
		for k in ks: if is_open(k): op.append(k)
		var locked_n = ks.size() - op.size()
		h += "<div class=\"stg n30-site\"><span class=\"st\"><b>%s</b><small>%s%s</small></span></div>" % [site.name, site.desc, ("　另有 %d 隻未出沒" % locked_n) if sid != "death" and locked_n != 0 else ""]
		for k in op:
			var g = NG[k]; var T = TIER[s_(g.t)]; var own = owned(k); var lv_ok = J.num(Sv.lv) >= J.num(T.req)
			h += "<div class=\"stg boss\"><span class=\"sn\">%s</span><span class=\"st\"><b>%s</b><small>%s需主公 Lv%s　%s</small></span><button class=\"btn sm %s\" data-n30=\"%s\" %s>%s</button>%s</div>" % [
				["", "前", "中", "後"][int(g.t)], GH(k).name, "已收服　" if own else "", s_(T.req), GH(k).title, "" if own else "gold", k, "" if lv_ok else "disabled",
				"再戰" if own else ("收服" if lv_ok else "Lv" + s_(T.req)), "<i class=\"ok\">✓</i>" if own else ""]
	return h + "</div>"

static func bind_select(root) -> void:
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-n30]"])):
		var bb = b
		J.sp(bb, "onclick", func(_t, _a): fight(J.str(J.gp(J.gp(bb, "dataset"), "n30"))); return null)

static func stage_of(k) -> Dictionary:
	var g = NG[k]; var T = TIER[s_(g.t)]; var site = SITES[g.at]
	return {"name": GH(k).name, "req": T.req, "p": T.p, "en": [site.fod[0], k, site.fod[1]], "boss": k, "wild": k}

static func fight(k) -> void:
	var any = false
	for x in S().team: if J.t(x): any = true; break
	if not any: J.mc(_g("Fx"), "toast", ["至少要派一位鬼怪出陣"]); return
	J.mc(_g("UI"), "close", [])
	var g = NG[k]; var first = not owned(k)
	var go = func(_t, _a): return J.mc(_g("Battle"), "start", [-1.0, J.num(g.t) - 1, {"stage": stage_of(k), "bg": SITES[g.at].bg, "sid": "w-" + J.str(g.id)}])
	if first: J.mc(_g("Story"), "queue", [{"style": "narr", "lines": [["旁白", "%s：%s出沒！" % [SITES[g.at].name, GH(k).name]], [GH(k).name, GH(k).say]]}, go])
	else: go.call(null, [])

static func on_win(stg) -> bool:
	if not J.t(stg) or not J.t(stg.get("wild")) or owned(stg.wild): return false
	var k = stg.wild
	J.mc(_g("Story"), "queue", [{"style": "narr", "lines": [[GH(k).name, GH(k).say], ["旁白", "%s決定跟你返落魄村。" % GH(k).name]]}, func(_t, _a): return J.cl(_g("joinGhost"), null, [k])])
	return true

static func _rand() -> float: return randf()

static func alley_event():
	var pool = []
	for k in ids(): if J.str(NG[k].at) == "night" and is_open(k) and not owned(k): pool.append(k)
	if pool.is_empty() or _rand() > 0.45: return null
	var k = pool[int(floor(_rand() * pool.size()))]; var g = NG[k]; var cost = [0, 120, 300, 600][int(g.t)]
	var d = GH(k)
	return {"id": "n30_" + J.str(g.id), "n30": k, "text": "巷口有一隻%s（%s）盯住你：「%s」" % [d.name, d.title, d.say],
		"a": {"label": "請佢食宵夜", "cost": float(cost), "out": "%s食飽之後話：「你呢個人都幾好人。」佢跟你返落魄村。" % d.name, "join": k},
		"b": {"label": "點個頭就走", "out": "%s望住你行遠咗。下次再嚟，可能仲見到佢。" % d.name, "give": {"exp": 15.0}}}

static func grave_visit():
	var pool = []
	for k in ids(): if J.str(NG[k].at) == "death" and is_open(k) and not owned(k): pool.append(k)
	if pool.is_empty() or _rand() > 0.15: return null
	var k = pool[int(floor(_rand() * pool.size()))]
	return {"k": k, "text": "墳後面行出一隻%s：「%s」佢話想跟你返村。" % [GH(k).name, GH(k).say]}

static func open_codex() -> void:
	var nm = _g("__nat_menu")
	if nm != null and J.t(J.cl(nm, null, ["codex"])): return
	var ks = ids(); var got = 0
	for k in ks: if owned(k): got += 1
	var h = "<p class=\"desc\">新鬼圖鑑：已收服 %d/%d。未收服的會寫低喺邊度出沒。</p>" % [got, ks.size()]
	for sid in ["field", "road", "kampung", "banana", "night", "death"]:
		h += "<div class=\"ch-h\">%s</div><div class=\"glist\">" % SITES[sid].name
		for k in ks:
			if J.str(NG[k].at) != sid: continue
			var own = owned(k); var d = GH(k); var sk = _g("SKILLS")[k]
			h += "<div class=\"gi %s\"><canvas data-por=\"%s\" style=\"%s\"></canvas><div><b>%s</b> <small>%s</small><small class=\"tr\">%s</small><small>%s</small></div></div>" % [
				"" if own else "dis", k, "" if own else "filter:brightness(.15)", d.name if own else d.name + "（未收服）", d.title, d.lore,
				"【%s】%s" % [sk.name, sk.desc] if own else "出沒：" + where(k)]
		h += "</div>"
	h += "<button class=\"btn wide\" id=\"cxback\">返回名冊</button>"
	J.mc(_g("UI"), "sheet", ["新鬼圖鑑", h])
	var dq = _g("$")
	J.cl(_g("paintPortraits"), null, [J.cl(dq, null, ["#sheet"])])
	J.sp(J.cl(dq, null, ["#cxback"]), "onclick", func(_t, _a): return J.mc(_g("UI"), "openRoster", []))

static func n30g(a: Array) -> void:   # 保留 N30G(...)：其他人要再加新鬼都用得
	var id = J.str(a[0]); var t = a[1]; var k = "n30_" + id; var T = TIER[s_(t)]
	NG[k] = {"id": id, "t": t, "at": a[2]}
	var base = []
	for v in a[5]: base.append(float(round(J.num(v) * J.num(T.k))))
	_g("GHOSTS")[k] = {"name": a[3], "title": a[4], "q": "名", "base": base, "range": "melee", "trait": a[7], "lore": a[8], "say": a[9], "n30": true}
	_g("SKILLS")[k] = a[6]
	_g("ENEMY_T")[k] = [T.en[0], T.en[1], a[3]]

func run(_env) -> void:
	var d = JSON.parse_string(FileAccess.get_file_as_string("res://data/n30_data.json"))
	SITES = d.N30_SITES; TIER = d.N30_TIER; NG = {}
	J.G["N30G"] = func(_t, a): n30g(a); return null
	J.G["N30_SITES"] = SITES; J.G["N30_TIER"] = TIER; J.G["N30_G"] = NG
	for k in d.N30_G: NG[k] = d.N30_G[k]
	var GHS = _g("GHOSTS"); var SKS = _g("SKILLS"); var EN = _g("ENEMY_T")
	for k in d.GHOSTS: GHS[k] = d.GHOSTS[k]
	for k in d.SKILLS: SKS[k] = d.SKILLS[k]
	for k in d.ENEMY_T: EN[k] = d.ENEMY_T[k]
	J.G["N30W"] = {
		"ids": func(_t, _a): return ids(),
		"st": func(_t, _a): return st(),
		"owned": func(_t, a): return owned(J.arg(a, 0)),
		"open": func(_t, a): return is_open(J.arg(a, 0)),
		"where": func(_t, a): return where(J.arg(a, 0)),
		"roadToday": func(_t, _a): return road_today(),
		"selectHtml": func(_t, _a): return select_html(),
		"bindSelect": func(_t, a): bind_select(J.arg(a, 0)); return null,
		"stageOf": func(_t, a): return stage_of(J.arg(a, 0)),
		"fight": func(_t, a): fight(J.arg(a, 0)); return null,
		"onWin": func(_t, a): return on_win(J.arg(a, 0)),
		"alleyEvent": func(_t, _a): return alley_event(),
		"graveVisit": func(_t, _a): return grave_visit(),
		"openCodex": func(_t, _a): open_codex(); return null,
	}
