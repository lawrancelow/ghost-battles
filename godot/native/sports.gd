# 原生改寫自 sports.js（陰間運動會：殭屍跳遠、舌頭對脖子拔河、天花板倒掛耐力、河童游泳）
# 介面同轉譯版一樣：J.G["Sports"] = {open, start, EV, target, st, athlete, _n, _g}；比賽物件 G（Dictionary）欄位同 JS 一樣
# 畫面：MiniStage 每幀叫 G._nd（原生 Ctx 喺 G._natCtx）；頂欄／面板由 SpPanel 原生畫（讀 #sp-panel DOM）
extends RefCounted

const DAY := 864e5
const ORDER := ["jump", "tug", "hang", "swim"]
static var EV: Dictionary = {}
static var BRYAN: Dictionary = {}
static var TAUT := "繃緊！唔好拉！"
static var G = null   # 而家嘅比賽（Dictionary）或者 null

static func _g(n: String): return J.G.get(n)
static func _S() -> Dictionary: return J.G.get("S")
static func _el(sel: String):
	var f = _g("$")
	return J.cl(f, null, [sel]) if f != null else null
static func D(yue: String, zh: String) -> String:
	var LANG = _g("LANG")
	if LANG != null: J.mc(LANG, "add", [{yue: zh}])
	return yue
static func Lx(x) -> String:
	var Lf = _g("L")
	return J.str(J.cl(Lf, null, [x])) if Lf != null else J.str(x)
static func fixed(x: float, d: int) -> String: return J.str(JStr.num_call(x, "toFixed", [float(d)]))
static func _snd_mode(m: String) -> void:
	var s = _g("Sound")
	if s != null: J.mc(s, "setMode", [m])

# ---------------- 資料 ----------------
static func st() -> Dictionary:
	var S = _S()
	if not J.t(S.get("sports")): S["sports"] = {"best": {}, "won": {}, "plays": 0.0}
	var sp = S.sports
	if not J.t(sp.get("best")): sp["best"] = {}
	if not J.t(sp.get("won")): sp["won"] = {}
	return sp

static func gday() -> float:
	var ms = J.now()
	var tz = Time.get_time_zone_from_system().get("bias", 0)
	return floor((ms - float(-tz) * 60000) / DAY)

static func _i32(x: int) -> int:
	x = x & 0xFFFFFFFF
	return x - 0x100000000 if x >= 0x80000000 else x
static func _u32(x: int) -> int: return x & 0xFFFFFFFF
static func _imul(a: int, b: int) -> int: return _i32(_i32(a) * _i32(b))
static func rnd(seed: float) -> float:
	var a = _i32(int(seed))
	a = _i32(a + 0x6D2B79F5)
	var t = _imul(a ^ (_u32(a) >> 15), 1 | a)
	t = _i32(t + _imul(t ^ (_u32(t) >> 7), 61 | t)) ^ t
	return float(_u32(t ^ (_u32(t) >> 14))) / 4294967296.0

static func target(id: String) -> float:
	var r = rnd(gday() * 7 + ORDER.find(id) * 131)
	if id == "jump": return J.num(fixed(5.6 + r * 1.0, 2))
	if id == "hang": return J.round(22 + r * 14)
	if id == "swim": return J.num(fixed(17.5 + r * 4, 1))
	return 0.0

static func gpf(a) -> float:
	if a is Dictionary and J.t(a.get("g")): return 1 + 0.12 * (J.num(J.mc(_g("GP"), "grow", [a.g])) - 1)
	return 1.0

static func owned(k: String):
	for g in _S().ghosts: if J.str(g.k) == k: return g
	return null

static func athlete(id: String) -> Dictionary:
	var E = EV[id]; var g = owned(E.who)
	if g != null: return {"k": E.who, "g": g, "name": g.name, "sub": false}
	return {"k": "afu", "g": owned("afu"), "name": DB.N("阿福"), "sub": true}

static func fmt_v(id: String, v) -> String:
	if id == "tug": return ""
	var x = J.num(v)
	if id == "jump": return fixed(x, 2) + " 米"
	if id == "swim": return fixed(x, 1) + " 秒"
	return J.str(floor(x)) + " 秒"

static func better(id: String, a: float, b: float) -> bool: return a > b if J.t(EV[id].hi) else a < b

# ---------------- 選項目 ----------------
static func open_() -> void:
	var nm = _g("__nat_menu")
	if nm != null and J.t(J.cl(nm, null, ["sports"])): return
	var s = st(); var today = gday()
	var h = "<p class=\"desc\">陰間運動會：靠鬼自己的怪癖比賽。每項每日第一次贏過 Bryan 的紀錄，出賽的鬼存在感 +12、全村 +3、合約 KPI +2、冥幣 60。</p>"
	var GH = _g("GHOSTS")
	for id in ORDER:
		var E = EV[id]; var a = athlete(id); var won = J.num(s.won.get(id, -1)) == today and s.won.get(id) != null; var best = s.best.get(id)
		var goal = ("對手：%s" % (J.str(GH[E.foe].name) if GH.get(E.foe) else "轆轤首")) if id == "tug" else ("Bryan 今日紀錄：" + fmt_v(id, target(id)))
		var bs = (("你的最佳：" + (J.str(best) + " 勝" if id == "tug" else fmt_v(id, best))) if best != null else "未參賽") + ("　<em>今日已贏</em>" if won else "")
		h += "<div class=\"sp-ev %s\"><canvas data-por=\"%s\"></canvas><div><b>%s</b><small>出賽：%s%s　%s</small><small>%s</small></div><button class=\"btn sm %s\" data-sp=\"%s\">%s</button></div>" % ["won" if won else "", a.k, E.name, a.name, "（替補）" if a.sub else "", goal, bs, "" if won else "gold", id, "再玩" if won else "參賽"]
	J.mc(_g("UI"), "sheet", ["陰間運動會", h])
	J.cl(_g("paintPortraits"), null, [_el("#sheet")])
	for b in J.iter(J.mc(_el("#sheet"), "querySelectorAll", ["[data-sp]"])):
		var bb = b
		J.sp(b, "onclick", func(_t, _a): J.mc(_g("UI"), "close", []); start(J.str(J.gp(J.gp(bb, "dataset"), "sp"))))

# ---------------- 比賽 ----------------
static func el():
	var e = _el("#sports")
	if e != null: return e
	var doc = _g("document")
	e = J.S_document_("createElement", ["div"]); J.sp(e, "id", "sports"); J.mc(J.gp(doc, "body"), "appendChild", [e])
	return e

static func start(id: String) -> void:
	var E = EV[id]; var a = athlete(id); var root = el()
	G = {"id": id, "E": E, "a": a, "t": 0.0, "phase": "intro", "introT": 2.6, "done": false, "fx": [], "score": null, "msg": "", "msgT": 0.0, "gpf": gpf(a)}
	var sub = ("<br><i>%s</i>" % J.str(E.sub)) if a.sub else ""
	var gp = ""
	if id != "hang" and J.t(a.get("g")):
		gp = "<br><small class=\"gp-sub\">%s %s・%s ×%s</small>" % [Lx(D("鬼力", "鬼力")), J.str(J.mc(_g("GP"), "pow", [a.g])), Lx(D("體能", "體能")), fixed(J.num(G.gpf), 2)]
	J.sp(root, "innerHTML", "<div id=\"sp-top\"><button class=\"btn sm ghost\" id=\"sp-quit\">收場</button><b>%s</b><span id=\"sp-hud\"></span></div>\n      <canvas id=\"sp-cvs\"></canvas><div id=\"sp-panel\"><p id=\"sp-rule\">%s%s%s</p><div id=\"sp-btns\"></div></div>" % [E.name, E.rule, sub, gp])
	J.mc(J.gp(root, "classList"), "add", ["on"])
	J.sp(_el("#sp-quit"), "onclick", func(_t, _a): close())
	var cv = _el("#sp-cvs"); G["cv"] = cv; G["ctx"] = J.mc(cv, "getContext", ["2d"])
	G["_nd"] = func(_t, _a): if G != null: draw()
	var nm = _g("__nat_mini")
	G["_nat"] = nm != null and J.t(J.cl(nm, null, [G, "#sp-cvs", "#sports", "_nd"]))
	match id:
		"jump": init_jump()
		"tug": init_tug()
		"hang": init_hang()
		"swim": init_swim()
	resize()
	var w = _g("window")
	if w != null: J.mc(w, "addEventListener", ["resize", func(_t, _a): resize()])
	J.mc(cv, "addEventListener", ["pointerdown", func(_t, a2):
		var e = J.arg(a2, 0)
		if e is Dictionary and e.get("preventDefault") != null: J.cl(e.preventDefault, e, [])
		if G != null and G.get("down") != null: J.cl(G.down, null, [pt(e)])])
	J.mc(cv, "addEventListener", ["pointermove", func(_t, a2): if G != null and G.get("move") != null: J.cl(G.move, null, [pt(J.arg(a2, 0))])])
	var up = func(_t, a2): if G != null and G.get("up") != null: J.cl(G.up, null, [pt(J.arg(a2, 0))])
	for ev in ["pointerup", "pointercancel", "pointerleave"]: J.mc(cv, "addEventListener", [ev, up])
	_snd_mode("story")
	G["last"] = J.S_performance_("now", [])
	var raf = _g("requestAnimationFrame")
	if raf != null: J.cl(raf, null, [func(_t, a2): frame(J.num(J.arg(a2, 0)))])

static func pt(e) -> Dictionary:
	var r = J.mc(G.cv, "getBoundingClientRect", [])
	var w = J.num(J.gp(r, "width"))
	return {"x": (J.num(J.gp(e, "clientX")) - J.num(J.gp(r, "left"))) / w * 390, "y": (J.num(J.gp(e, "clientY")) - J.num(J.gp(r, "top"))) / w * 390}

static func resize() -> void:
	if G == null: return
	var r = J.mc(G.cv, "getBoundingClientRect", [])
	var d = 1.0
	var rw = J.num(J.gp(r, "width")); var rh = J.num(J.gp(r, "height"))
	J.sp(G.cv, "width", rw * d); J.sp(G.cv, "height", rh * d)
	G["k"] = rw * d / 390.0; G["H"] = rh / rw * 390.0 if rw != 0 else 0.0

static func close() -> void:
	if G != null and J.t(G.get("_nat")):
		var me = _g("__nat_miniEnd")
		if me != null: J.cl(me, null, ["#sports"])
	G = null
	var e = _el("#sports")
	if e != null: J.mc(J.gp(e, "classList"), "remove", ["on"]); J.sp(e, "innerHTML", "")
	_snd_mode("village")
	open_()

static func btns(list: Array) -> void:
	var b = _el("#sp-btns")
	var h = ""
	for i in list.size(): h += "<button class=\"btn %s sp-b\" data-i=\"%d\">%s</button>" % [list[i][2] if list[i].size() > 2 else "gold", i, list[i][0]]
	J.sp(b, "innerHTML", h)
	for x in J.iter(J.mc(b, "querySelectorAll", [".sp-b"])):
		var xx = x
		J.mc(x, "addEventListener", ["pointerdown", func(_t, a2):
			var e = J.arg(a2, 0)
			if e is Dictionary and e.get("preventDefault") != null: J.cl(e.preventDefault, e, [])
			var f: Callable = list[int(J.num(J.gp(J.gp(xx, "dataset"), "i")))][1]
			if G != null and J.str(G.phase) == "play": f.call()])

static func say(m: String, t := 1.2) -> void: G["msg"] = m; G["msgT"] = t

static func frame(now: float) -> void:
	if G == null: return
	var dt = minf(0.05, (now - J.num(G.last)) / 1000.0); G["last"] = now
	step(dt)
	if G == null: return
	if not J.t(G.get("_nat")): draw()
	J.cl(_g("requestAnimationFrame"), null, [func(_t, a2): frame(J.num(J.arg(a2, 0)))])

# 一格（frame 入面除咗畫之外嘅嘢）——測試會直接叫
static func step(dt: float) -> void:
	G["t"] = J.num(G.t) + dt
	if J.num(G.msgT) > 0: G["msgT"] = J.num(G.msgT) - dt
	if J.str(G.phase) == "intro":
		G["introT"] = J.num(G.introT) - dt
		if J.num(G.introT) <= 0: G["phase"] = "play"
	if J.str(G.phase) == "play" and G.get("tick") != null: J.cl(G.tick, null, [dt])
	if G == null: return
	var keep = []
	for f in G.fx:
		f["t"] = J.num(f.t) + dt
		if J.num(f.t) < J.num(f.life): keep.append(f)
	G["fx"] = keep

static func draw() -> void:
	if J.t(G.get("_nat")) and not J.t(G.get("_natCtx")): return
	var c: Ctx = G._natCtx if J.t(G.get("_natCtx")) else G.ctx
	var H = J.num(G.H)
	c.setTransform(J.num(G.k), 0, 0, J.num(G.k), 0, 0); c.clearRect(0, 0, 390, H)
	var SC = _g("SCENE")
	if not (SC != null and J.t(J.mc(SC, "drawBg", [c, 390.0, H, G.E.bg]))): c.fillStyle = "#1c1820"; c.fillRect(0, 0, 390, H)
	c.fillStyle = "rgba(10,8,16,.35)"; c.fillRect(0, 0, 390, H)
	match J.str(G.id):
		"jump": draw_jump(c, H)
		"tug": draw_tug(c, H)
		"hang": draw_hang(c, H)
		"swim": draw_swim(c, H)
	for f in G.fx:
		var q = J.num(f.t) / J.num(f.life)
		c.save(); c.globalAlpha = 1 - q; c.font = "bold %spx \"PingFang TC\",\"Noto Sans TC\",sans-serif" % J.str(f.size if J.t(f.get("size")) else 18.0); c.textAlign = "center"; c.lineWidth = 4; c.strokeStyle = "rgba(0,0,0,.75)"; c.fillStyle = f.col if J.t(f.get("col")) else "#fff"
		c.strokeText(f.text, J.num(f.x), J.num(f.y) - q * 26); c.fillText(f.text, J.num(f.x), J.num(f.y) - q * 26); c.restore()
	if J.str(G.phase) == "intro": banner(c, H, G.E.name, Lx(BRYAN[G.id]))
	if J.num(G.msgT) > 0 and J.t(G.msg):
		c.save(); c.font = "bold 22px \"PingFang TC\",\"Noto Sans TC\",sans-serif"; c.textAlign = "center"; c.lineWidth = 5; c.strokeStyle = "rgba(0,0,0,.8)"; c.fillStyle = "#ffd84a"
		c.strokeText(G.msg, 195, H * 0.2); c.fillText(G.msg, 195, H * 0.2); c.restore()
	var hud = _el("#sp-hud")
	if hud != null and G.get("hud") != null: J.sp(hud, "textContent", J.cl(G.hud, null, []))

static func banner(c: Ctx, H: float, a, b) -> void:
	c.save(); c.fillStyle = "rgba(0,0,0,.6)"; c.fillRect(0, H * 0.32, 390, 92)
	c.textAlign = "center"; c.fillStyle = "#ffd84a"; c.font = "bold 26px \"PingFang TC\",\"Noto Sans TC\",sans-serif"; c.fillText(a, 195, H * 0.32 + 38)
	c.fillStyle = "#eee"; c.font = "14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"; wrap_text(c, J.str(b), 195, H * 0.32 + 66, 350, 18); c.restore()

static func wrap_text(c: Ctx, s: String, x: float, y: float, w: float, lh: float) -> void:
	var line = ""; var yy = y
	for ch in s:
		if J.num(c.measureText(line + ch).get("width", 0.0)) > w: c.fillText(line, x, yy); line = ch; yy += lh
		else: line += ch
	c.fillText(line, x, yy)

static func pop(text: String, x: float, y: float, col: String, size: float) -> void:
	G.fx.append({"text": text, "x": x, "y": y, "col": col, "size": size, "t": 0.0, "life": 0.9})

static func chr_(c: Ctx, k, x: float, y: float, s: float, o := {}) -> void:
	var oo = {"t": G.t}; oo.merge(o, true)
	Art.draw_char(c, J.str(k), x, y, s, oo)

static func bryan(c: Ctx, x: float, y: float, h: float, state: String, o := {}) -> void:
	var oo = {"shadow": false, "time": G.t}; oo.merge(o, true)
	var A = _g("Antag")
	if A != null: J.mc(A, "draw", [c, "npc_rival", x, y, h, state if state != "" else "idle", G.t, oo])

static func _char_h(k) -> float:
	var CH = _g("CHAR_H")
	var v = J.gp(CH, J.str(k)) if CH != null else null
	return J.num(v) if J.t(v) else 56.0

# ---------------- 結算 ----------------
static func finish(v, line) -> void:
	if J.t(G.done): return
	G["done"] = true; G["phase"] = "end"
	var S = _S(); var s = st(); var id = J.str(G.id); var today = gday()
	s["plays"] = (J.num(s.plays) if J.t(s.get("plays")) else 0.0) + 1
	var win = false; var rec = ""
	if id == "tug":
		win = J.num(v) > 0
		s.best["tug"] = (J.num(s.best.tug) if J.t(s.best.get("tug")) else 0.0) + (1.0 if win else 0.0)
	else:
		win = v != null and better(id, J.num(v), target(id))
		if v != null and (s.best.get(id) == null or better(id, J.num(v), J.num(s.best[id]))): s.best[id] = v; rec = "　<b>個人新紀錄！</b>"
	var rw = ""
	var won_today = s.won.get(id) != null and J.num(s.won[id]) == today
	if win and not won_today:
		s.won[id] = today
		var P = _g("Presence")
		if P != null:
			if J.t(G.a.get("g")): J.mc(P, "add", [G.a.g, 12.0])
			for g in S.ghosts: if not is_same(g, G.a.get("g")): J.mc(P, "add", [g, 3.0])
		var ct = S.get("contract")
		if J.t(ct) and J.str(ct.get("state")) == "active": ct["kpi"] = J.num(ct.kpi) + 2
		var got = J.str(J.cl(_g("give"), null, [{"coins": 60.0}]))
		rw = "<p class=\"desc\">%s 存在感 +12，全村 +3%s，%s</p>" % [J.str(G.a.name), "，合約 KPI +2" if J.t(ct) and J.str(ct.get("state")) == "active" else "", got]
	elif win: rw = "<p class=\"desc\">今日已經領過獎，這場算練習。</p>"
	J.cl(_g("save"), null, [])
	var res = ("贏了！" if win else "輸了") if id == "tug" else ("犯規" if v == null else fmt_v(id, v))
	var vs = "" if id == "tug" else "<p class=\"desc\">Bryan 今日紀錄：%s%s</p>" % [fmt_v(id, target(id)), rec]
	var p = _el("#sp-panel")
	if p == null: return
	var ttl = "贏了 Bryan！" if win else ("被轆轤首拉過去了" if id == "tug" else "輸給 Bryan")
	J.sp(p, "innerHTML", "<div class=\"sp-end\"><h3>%s</h3><p class=\"sp-big\">%s</p>%s%s%s<div class=\"sp-endb\"><button class=\"btn\" id=\"sp-again\">再來一次</button><button class=\"btn gold\" id=\"sp-back\">回運動會</button></div></div>" % [ttl, res, ("<p class=\"desc\"><i>%s</i></p>" % Lx(line)) if J.t(line) else "", vs, rw])
	var iid = id
	J.sp(_el("#sp-again"), "onclick", func(_t, _a): start(iid))
	J.sp(_el("#sp-back"), "onclick", func(_t, _a): close())

# ===================== 各項目 =====================
# ---------- 殭屍跳遠 ----------
const JT := 0.56
const HOPS := 6
const PX := 30.0

static func _avg() -> float:
	var a: Array = G.acc
	if a.is_empty(): return 0.0
	var s = 0.0
	for v in a: s += J.num(v)
	return s / a.size()

static func init_jump() -> void:
	G.merge({"x": 40.0, "hop": 0.0, "hopT": 0.0, "acc": [], "speed": 0.6, "line": 0.0, "fly": null, "tapped": {}, "lineX": 0.0, "cam": 0.0}, true)
	G["lineX"] = 40.0 + HOPS * 48 + 40
	G["hud"] = func(_t = null, _a = null): return "" if J.t(G.fly) else "節奏 %s%%" % J.str(J.round((0.6 + 0.4 * _avg()) * 100))
	btns([["跳", func(): _tap_hop()]])
	G["down"] = func(_t = null, _a = null): if J.str(G.phase) == "play": _tap_hop()
	G["tick"] = func(_t, a): _tick_jump(J.num(J.arg(a, 0)))
	G["draw"] = func(_t, a): draw_jump(J.arg(a, 0), J.num(J.arg(a, 1)))

static func _tap_hop() -> void:
	if J.t(G.fly) or J.num(G.hop) >= HOPS: _takeoff(); return
	var land = JT - J.num(G.hopT); var early = J.num(G.hopT); var d = minf(land, early)
	var i = int(J.num(G.hop)) if land < early else int(J.num(G.hop)) - 1
	if i < 0 or J.t(G.tapped.get(str(i))): return
	G.tapped[str(i)] = 1.0
	var q = 1.0 if d < 0.09 else (0.7 if d < 0.17 else 0.15)
	G.acc.append(q)
	pop("好節奏！" if q == 1 else ("還可以" if q > 0.5 else "亂跳"), J.num(G.x) - J.num(G.cam), J.num(G.H) * 0.42, "#ffd84a" if q == 1 else "#ddd", 16)

static func _takeoff() -> void:
	if J.t(G.fly) or J.num(G.hop) < HOPS: return
	var gap = (J.num(G.lineX) - J.num(G.x)) / PX; var sp = 0.6 + 0.4 * _avg()
	if gap < 0: G["fly"] = {"t": 0.0, "dist": 0.0, "foul": true}; say("踩線犯規！", 1.6); return
	var dist = maxf(0.5, sp * 7.6 * J.num(G.gpf) - gap * 1.2)
	G["fly"] = {"t": 0.0, "dist": dist, "x0": G.x, "foul": false}

static func _tick_jump(dt: float) -> void:
	if J.t(G.fly):
		var f = G.fly; f["t"] = J.num(f.t) + dt
		if J.num(f.t) > (1.2 if J.t(f.foul) else 1.4) and not J.t(G.done):
			var line
			if J.t(f.foul): line = D("殭屍跳過咗龍，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。", "殭屍跳過了頭，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。")
			elif J.num(f.dist) > target("jump"): line = D("落地姿勢：成條棍咁插落沙池。裁判俾滿分。", "落地姿勢：直挺挺插進沙池。裁判給滿分。")
			else: line = D("膝頭太直，起跳差少少。", "膝蓋太直，起跳時差一點點。")
			finish(null if J.t(f.foul) else J.num(fixed(J.num(f.dist), 2)), line)
		return
	if J.num(G.hop) < HOPS:
		G["hopT"] = J.num(G.hopT) + dt * (0.85 + 0.3 * J.num(G.speed))
		if J.num(G.hopT) >= JT:
			G["hopT"] = J.num(G.hopT) - JT; G["hop"] = J.num(G.hop) + 1
			if not J.t(G.tapped.get(str(int(J.num(G.hop)) - 1))): G.acc.append(0.0)
			G["speed"] = 0.6 + 0.4 * _avg()
		G["x"] = 40 + (J.num(G.hop) + J.num(G.hopT) / JT) * 48
	else:
		G["x"] = J.num(G.x) + dt * 70 * (0.8 + 0.5 * J.num(G.speed))
		if J.num(G.x) > J.num(G.lineX) + 40 and not J.t(G.fly): G["fly"] = {"t": 0.0, "dist": 0.0, "foul": true}; say("踩線犯規！", 1.6)

static func draw_jump(c: Ctx, H: float) -> void:
	var gy = H * 0.66; var SC = 1.6; var lineX = J.num(G.lineX); var fly = G.fly
	var fx = lineX + J.num(fly.dist) * PX * minf(1.0, J.num(fly.t) / 0.9) if J.t(fly) and not J.t(fly.foul) else J.num(G.x)
	var cam = maxf(0.0, minf(lineX + 9.5 * PX - 390, fx - 150)); G["cam"] = cam
	c.save(); c.translate(-cam, 0)
	c.fillStyle = "rgba(140,90,60,.6)"; c.fillRect(0, gy - 8, lineX + 12 * PX, 26)
	c.fillStyle = "rgba(225,195,125,.6)"; c.fillRect(lineX, gy - 8, 10 * PX, 26)
	c.fillStyle = "#f4f0e0"; c.fillRect(lineX - 2, gy - 10, 5, 30)
	c.font = "bold 11px sans-serif"; c.textAlign = "center"
	for m in range(1, 10):
		var x = lineX + m * PX; c.fillStyle = "rgba(255,255,255,.6)"; c.fillRect(x, gy + 18, 1.5, 7); c.fillText(str(m) + "米", x, gy + 38)
	var bx = lineX + target("jump") * PX
	c.fillStyle = "#c0392b"; c.fillRect(bx, gy - 44, 3, 44); c.fillRect(bx + 3, gy - 44, 30, 16); c.fillStyle = "#fff"; c.font = "bold 10px sans-serif"; c.textAlign = "left"; c.fillText("Bryan", bx + 4, gy - 32)
	var x = J.num(G.x); var y = gy; var pose = null; var ptv = 0.0
	if J.t(fly) and not J.t(fly.foul):
		var p = minf(1.0, J.num(fly.t) / 0.9); x = fx; y = gy - sin(p * PI) * 110; pose = "air" if p < 1 else null; ptv = p
	elif not J.t(fly) and J.num(G.hop) < HOPS:
		var p = J.num(G.hopT) / JT; y = gy - sin(p * PI) * 34
	if not J.t(fly) and J.num(G.hop) < HOPS:
		var p = J.num(G.hopT) / JT; var r = 10 + (1 - p) * 34
		c.strokeStyle = "#ffd84a" if p > 0.75 else "rgba(255,255,255,.55)"; c.lineWidth = 3; c.beginPath(); c.ellipse(J.num(G.x), gy + 4, r, r * 0.32, 0, 0, PI * 2); c.stroke()
	chr_(c, G.a.k, x, y, SC, {"pose": pose, "pt": ptv, "shadow": false})
	if J.t(fly) and not J.t(fly.foul) and J.num(fly.t) > 0.9: c.fillStyle = "#ffd84a"; c.fillRect(fx - 1, gy - 6, 3, 22)
	c.restore()
	if not J.t(fly) and J.num(G.hop) >= HOPS:
		c.save(); c.font = "bold 24px sans-serif"; c.textAlign = "center"; c.lineWidth = 5; c.strokeStyle = "#000"; c.fillStyle = "#ffd84a"; c.strokeText("起跳！", 195, H * 0.3); c.fillText("起跳！", 195, H * 0.3); c.restore()
	if J.t(fly) and not J.t(fly.foul) and J.num(fly.t) > 0.9:
		c.save(); c.font = "bold 30px sans-serif"; c.textAlign = "center"; c.lineWidth = 6; c.strokeStyle = "#000"; c.fillStyle = "#fff"
		var t = fixed(J.num(fly.dist), 2) + " 米"; c.strokeText(t, 195, H * 0.3); c.fillText(t, 195, H * 0.3); c.restore()

# ---------- 舌頭對脖子拔河 ----------
static func init_tug() -> void:
	G.merge({"p": 0.0, "ai": 0.12, "taut": 0.0, "tautT": 2.2, "time": 30.0, "slip": 0.0}, true)
	G["hud"] = func(_t = null, _a = null): return "剩 %s 秒" % J.str(maxf(0.0, ceil(J.num(G.time))))
	btns([["拉", func(): _pull()]])
	G["down"] = func(_t = null, _a = null): if J.str(G.phase) == "play": _pull()
	G["tick"] = func(_t, a): _tick_tug(J.num(J.arg(a, 0)))
	G["draw"] = func(_t, a): draw_tug(J.arg(a, 0), J.num(J.arg(a, 1)))

static func _pull() -> void:
	if J.t(G.done): return
	if J.num(G.taut) > 0: G["p"] = J.num(G.p) - 0.07; G["slip"] = 0.5; pop("舌頭打滑！", 120, J.num(G.H) * 0.42, "#ff8080", 16); return
	G["p"] = J.num(G.p) + 0.032 * J.num(G.gpf)
	if randf() < 0.25: pop("拉！", 90 + randf() * 40, J.num(G.H) * 0.46, "#ffe8a0", 14)

static func _tick_tug(dt: float) -> void:
	if J.t(G.done): return
	G["time"] = J.num(G.time) - dt; G["slip"] = maxf(0.0, J.num(G.slip) - dt)
	var surge = 0.22 if sin(J.num(G.t) * 1.3) > 0.85 else 0.0
	G["p"] = J.num(G.p) - dt * (J.num(G.ai) + surge + maxf(0.0, J.num(G.t) - 8) * 0.004)
	G["tautT"] = J.num(G.tautT) - dt
	if J.num(G.tautT) <= 0: G["taut"] = 0.85; G["tautT"] = 1.8 + randf() * 1.8
	if J.num(G.taut) > 0: G["taut"] = J.num(G.taut) - dt
	if J.num(G.p) >= 1: finish(1.0, D("轆轤首條頸拉到打咗個結。佢話下年再嚟。", "轆轤首的脖子被拉到打了個結。她說明年再來。"))
	elif J.num(G.p) <= -1: finish(0.0, D("條脷被拉咗過對面，要行過去執返。", "舌頭被拉到對面，要走過去撿回來。"))
	elif J.num(G.time) <= 0:
		var w = J.num(G.p) > 0
		finish(1.0 if w else 0.0, D("夠鐘，面旗喺你嗰邊。險勝。", "時間到，旗子在你這邊。險勝。") if w else D("夠鐘，面旗喺對面。差少少。", "時間到，旗子在對面。差一點。"))

static func draw_tug(c: Ctx, H: float) -> void:
	var gy = H * 0.68; var cx = 195 + J.num(G.p) * 100; var ry = gy - 66; var LH = _char_h(G.a.k) * 1.6; var RH = _char_h(G.E.foe) * 1.6
	var taut = J.num(G.taut) > 0
	c.fillStyle = "rgba(255,255,255,.75)"; c.fillRect(94, ry - 24, 3, 40); c.fillRect(293, ry - 24, 3, 40)
	c.fillStyle = "rgba(255,255,255,.3)"; c.fillRect(194, ry - 18, 2, 34)
	var rope = "#ff4040" if taut else ("#c0392b" if J.str(G.a.k) == "afu" else "#d86a7a")
	c.strokeStyle = rope; c.lineWidth = 6 if taut else 5; c.beginPath(); c.moveTo(70, gy - LH * 0.62); c.quadraticCurveTo(cx - 50, ry + 8 + sin(J.num(G.t) * 9) * (1.0 if taut else 4.0), cx, ry); c.stroke()
	c.strokeStyle = "#e8dcc8"; c.lineWidth = 7; c.beginPath(); c.moveTo(cx, ry); c.quadraticCurveTo(cx + 60, ry - 4, 326, gy - RH * 0.82); c.stroke()
	c.fillStyle = "#ffd84a"; c.beginPath(); c.moveTo(cx, ry); c.lineTo(cx, ry - 32); c.lineTo(cx + 20, ry - 24); c.lineTo(cx, ry - 16); c.fill(); c.fillStyle = "#5a3a1a"; c.fillRect(cx - 1, ry - 32, 2, 32)
	chr_(c, G.a.k, 58, gy, 1.6, {"pose": "hurt" if J.num(G.slip) > 0 else null, "pt": 0.5, "shadow": false, "rot": -0.15 - (0.0 if taut else 0.05)})
	chr_(c, G.E.foe, 338, gy, 1.6, {"flip": true, "shadow": false, "rot": 0.15})
	if taut:
		c.save(); c.font = "bold 20px sans-serif"; c.textAlign = "center"; c.fillStyle = "#ff6060"; c.lineWidth = 4; c.strokeStyle = "#000"
		var tx = Lx(TAUT); c.strokeText(tx, 195, H * 0.3); c.fillText(tx, 195, H * 0.3); c.restore()

# ---------- 天花板倒掛耐力 ----------
static func init_hang() -> void:
	G.merge({"hold": false, "sw": 0.0, "v": 0.0, "fx0": null, "time": 0.0, "push": 0.0, "evT": 4.0, "ev": null, "fall": null}, true)
	G["hud"] = func(_t = null, _a = null): return "%s 秒" % J.str(floor(J.num(G.time)))
	btns([]); J.sp(_el("#sp-btns"), "innerHTML", "<p class=\"sp-tip\">按住畫面開始，左右拖動保持平衡</p>")
	G["down"] = func(_t, a):
		if J.str(G.phase) != "play" or J.t(G.fall): return
		G["hold"] = true; G["fx0"] = J.gp(J.arg(a, 0), "x"); G["dx"] = 0.0
	G["move"] = func(_t, a):
		if J.t(G.hold) and G.get("fx0") != null: G["dx"] = (J.num(J.gp(J.arg(a, 0), "x")) - J.num(G.fx0)) / 90.0
	G["up"] = func(_t = null, _a = null):
		if J.t(G.hold) and not J.t(G.done) and not J.t(G.fall) and J.num(G.time) > 0.3: G["fall"] = {"t": 0.0}; say("放手了！", 1.4)
		G["hold"] = false
	G["tick"] = func(_t, a): _tick_hang(J.num(J.arg(a, 0)))
	G["draw"] = func(_t, a): draw_hang(J.arg(a, 0), J.num(J.arg(a, 1)))

static func _tick_hang(dt: float) -> void:
	if J.t(G.fall):
		G.fall["t"] = J.num(G.fall.t) + dt
		if J.num(G.fall.t) > 1 and not J.t(G.done):
			finish(J.num(fixed(J.num(G.time), 1)), D("跌落嚟嗰陣，啱啱壓住 Bryan 塊紀錄牌。", "掉下來的時候，剛好壓住 Bryan 的紀錄牌。") if J.num(G.time) > target("hang") else D("落地。清潔安娣：「又係你，日日都跌落嚟。」", "落地。清潔安娣：「又是你，每天都掉下來。」"))
		return
	if not J.t(G.hold): return
	G["time"] = J.num(G.time) + dt
	var lv = 1 + J.num(G.time) / 20
	G["evT"] = J.num(G.evT) - dt
	if J.num(G.evT) <= 0:
		var k = "fan" if randf() < 0.5 else "broom"
		G["ev"] = {"k": k, "t": 0.0, "dir": -1.0 if randf() < 0.5 else 1.0}
		G["evT"] = 3 + randf() * 3 / lv
		pop("風扇開了！" if k == "fan" else "安娣的掃把！", 195, J.num(G.H) * 0.62, "#ffe8a0", 16)
	var t = J.num(G.t)
	var f = sin(t * 1.7) * 0.35 * lv + sin(t * 0.63 + 1) * 0.25 * lv
	if J.t(G.ev):
		var ev = G.ev; ev["t"] = J.num(ev.t) + dt
		var fan = J.str(ev.k) == "fan"
		f += J.num(ev.dir) * (1.1 if fan else 2.2) * lv * (1.0 if fan else maxf(0.0, 1 - absf(J.num(ev.t) - 0.4) * 3))
		if J.num(ev.t) > (1.8 if fan else 0.9): G["ev"] = null
	G["v"] = J.num(G.v) + (f - J.num(G.get("dx", 0.0)) * 2.6 - J.num(G.sw) * 0.6) * dt; G["v"] = J.num(G.v) * 0.985; G["sw"] = J.num(G.sw) + J.num(G.v) * dt * 1.6
	if absf(J.num(G.sw)) > 1: G["fall"] = {"t": 0.0}; say("甩下來了！", 1.4)

static func draw_hang(c: Ctx, H: float) -> void:
	var cy = H * 0.18; var sw = J.num(G.sw)
	c.fillStyle = "rgba(60,50,70,.9)"; c.fillRect(0, 0, 390, cy); c.fillStyle = "rgba(255,255,255,.08)"
	for x in range(0, 390, 48): c.fillRect(x, cy - 2, 46, 2)
	c.fillStyle = "rgba(0,0,0,.5)"; c.fillRect(95, H * 0.84, 200, 10); c.fillStyle = "rgba(120,220,120,.6)"; c.fillRect(165, H * 0.84, 60, 10)
	c.fillStyle = "#ff5050" if absf(sw) > 0.7 else "#ffd84a"; c.fillRect(195 + sw * 100 - 3, H * 0.84 - 4, 6, 18)
	var ang = sw * 0.6; var fy = minf(H * 0.72, cy + J.num(G.fall.t) * J.num(G.fall.t) * 900) if J.t(G.fall) else cy
	c.save(); c.translate(195, fy); c.rotate(PI + ang); chr_(c, G.a.k, 0, 0, 2.0, {"shadow": false, "pose": "hurt" if J.t(G.fall) else null, "pt": 0.5}); c.restore()
	if not J.t(G.hold) and not J.t(G.fall) and J.str(G.phase) == "play":
		c.save(); c.font = "bold 18px sans-serif"; c.textAlign = "center"; c.fillStyle = "#fff"; c.fillText("按住畫面抓實天花板", 195, H * 0.55); c.restore()
	var ev = G.ev
	if J.t(ev) and J.str(ev.k) == "fan":
		c.save(); c.translate(370 if J.num(ev.dir) < 0 else 20, H * 0.4); c.rotate(J.num(G.t) * 20); c.strokeStyle = "rgba(255,255,255,.6)"; c.lineWidth = 4
		for i in 3: c.rotate(PI * 2 / 3); c.beginPath(); c.moveTo(0, 0); c.lineTo(22, 0); c.stroke()
		c.restore()
	if J.t(ev) and J.str(ev.k) == "broom":
		var d = J.num(ev.dir); var x = 195 - d * (160 - J.num(ev.t) * 300)
		c.save(); c.strokeStyle = "#8a6a3a"; c.lineWidth = 5; c.beginPath(); c.moveTo(x, H * 0.75); c.lineTo(x + d * 20, H * 0.32); c.stroke(); c.fillStyle = "#c8a860"; c.fillRect(x + d * 20 - 14, H * 0.28, 28, 10); c.restore()
	c.save(); c.font = "12px sans-serif"; c.textAlign = "right"; c.fillStyle = "#ffd0c0"; c.fillText("Bryan：%s 秒" % J.str(target("hang")), 380, H * 0.82); c.restore()

# ---------- 河童游泳 ----------
static func init_swim() -> void:
	G.merge({"dist": 0.0, "vel": 0.0, "water": 1.0, "slosh": 0.0, "sv": 0.0, "lastSide": 0.0, "lastT": -9.0, "time": 0.0, "finished": false, "stroke": 0.0}, true)
	G["hud"] = func(_t = null, _a = null): return "%s／50 米　%s 秒" % [J.str(minf(50.0, floor(J.num(G.dist)))), fixed(J.num(G.time), 1)]
	btns([["左划", func(): _stroke(-1.0), ""], ["右划", func(): _stroke(1.0), ""]])
	G["stroke_"] = func(_t, a): _stroke(J.num(J.arg(a, 0)))
	G["tick"] = func(_t, a): _tick_swim(J.num(J.arg(a, 0)))
	G["draw"] = func(_t, a): draw_swim(J.arg(a, 0), J.num(J.arg(a, 1)))

static func _stroke(side: float) -> void:
	if J.t(G.finished): return
	var gap = J.num(G.t) - J.num(G.lastT); G["lastT"] = G.t
	var same = side == J.num(G.lastSide); G["lastSide"] = side; G["stroke"] = 0.35
	var power = 1.0 if J.num(G.water) > 0.25 else 0.45
	G["vel"] = J.num(G.vel) + (0.5 if same else 2.1) * power * (0.6 if gap < 0.22 else 1.0) * J.num(G.gpf)
	var kick = 0.9 if same else 0.35
	if gap < 0.22: kick += 0.6
	G["sv"] = J.num(G.sv) + side * kick
	if same: pop("同一邊！", 195 + side * 70, J.num(G.H) * 0.38, "#ffb0a0", 14)

static func _tick_swim(dt: float) -> void:
	if J.t(G.finished): return
	G["time"] = J.num(G.time) + dt; G["stroke"] = maxf(0.0, J.num(G.stroke) - dt)
	G["vel"] = J.num(G.vel) * pow(0.35, dt); G["dist"] = J.num(G.dist) + J.num(G.vel) * dt * 0.5
	G["sv"] = J.num(G.sv) + (-J.num(G.slosh) * 14 * dt); G["sv"] = J.num(G.sv) * pow(0.4, dt); G["slosh"] = J.num(G.slosh) + J.num(G.sv) * dt * 3
	if absf(J.num(G.slosh)) > 0.55:
		var loss = (absf(J.num(G.slosh)) - 0.55) * dt * 0.9; G["water"] = maxf(0.0, J.num(G.water) - loss)
		if randf() < dt * 6: pop("水灑了！", 195, J.num(G.H) * 0.33, "#9fd8ff", 13)
	if J.num(G.dist) >= 50:
		G["finished"] = true
		var w = J.num(G.water)
		finish(J.num(fixed(J.num(G.time), 1)), D("游完，頭頂碟水仲有大半。河童協會頒發「穩陣獎」。", "游完，頭頂碟水還有大半。河童協會頒發「穩健獎」。") if w > 0.6 else (D("游完，碟水剩返一半，個頭有啲暈。", "游完了，碟裡的水剩一半，頭有點暈。") if w > 0.25 else D("碟水乾晒，最後幾米係爬上岸。", "碟水全乾了，最後幾米是爬上岸的。")))
	if G != null and J.num(G.time) > 60 and not J.t(G.finished):
		G["finished"] = true; finish(null, D("一分鐘都未游完。救生員（一隻水鬼）將你撈咗上岸。", "一分鐘都沒游完。救生員（一隻水鬼）把你撈上岸。"))

static func draw_swim(c: Ctx, H: float) -> void:
	var top = H * 0.4; var bot = H * 0.78; var t = J.num(G.t); var dist = J.num(G.dist)
	c.fillStyle = "rgba(40,90,120,.75)"; c.fillRect(0, top, 390, bot - top)
	for i in 6:
		c.strokeStyle = "rgba(255,255,255,.12)"; c.beginPath(); var y = top + 12 + i * (bot - top) / 6
		for x in range(0, 391, 12): c.lineTo(x, y + sin(x * 0.05 + t * 2 + i) * 2)
		c.stroke()
	var off = fmod(dist * 24, 48.0); c.fillStyle = "#e05050"
	var xx = -off
	while xx < 400:
		c.beginPath(); c.arc(xx, top + 4, 4, 0, PI * 2); c.arc(xx + 24, bot - 4, 4, 0, PI * 2); c.fill(); xx += 48
	var bd = minf(50.0, J.num(G.time) / target("swim") * 50); var bx = 150 + (bd - dist) * 24
	if bx > -40 and bx < 430:
		c.save(); c.globalAlpha = 0.5; c.beginPath(); c.rect(0, 0, 390, top + 30); c.clip(); bryan(c, bx, top + 60, 96, "walk", {"faceRight": true}); c.restore()
		c.save(); c.font = "bold 11px sans-serif"; c.textAlign = "center"; c.fillStyle = "#ffd0c0"; c.fillText("Bryan", bx, top - 46); c.restore()
	var vel = J.num(G.vel)
	var y = (top + bot) / 2 + 40 + sin(t * 7) * (3.0 if vel > 0.5 else 1.5); var lean = minf(0.35, vel * 0.05); var SC = 1.5; var HH = _char_h(G.a.k) * SC + 4 * SC - 7
	c.save(); c.beginPath(); c.rect(0, 0, 390, y - 22); c.clip()
	c.save(); c.translate(150, y); c.rotate(lean); chr_(c, G.a.k, 0, 0, SC, {"shadow": false, "walk": vel > 0.5})
	var slosh = J.num(G.slosh); var water = J.num(G.water)
	c.translate(0, -HH); c.rotate(slosh * 0.6); c.fillStyle = "#c8c0a8"; c.strokeStyle = "rgba(0,0,0,.4)"; c.lineWidth = 1.5; c.beginPath(); c.ellipse(0, 0, 22, 6.5, 0, 0, PI * 2); c.fill(); c.stroke()
	if water > 0: c.fillStyle = "rgba(120,200,255,.9)"; c.beginPath(); c.ellipse(slosh * 6, -1.5, 18 * sqrt(water), 4.2 * sqrt(water), 0, 0, PI * 2); c.fill()
	c.restore(); c.restore()
	c.fillStyle = "rgba(40,90,120,.55)"; c.fillRect(0, y - 22, 390, bot - y + 22)
	if J.num(G.stroke) > 0:
		var q = 1 - J.num(G.stroke) / 0.35
		c.strokeStyle = "rgba(255,255,255,%s)" % J.str(0.7 * (1 - q)); c.lineWidth = 2; c.beginPath(); c.ellipse(150 + J.num(G.lastSide) * 30, y - 20, 12 + q * 22, 4 + q * 6, 0, 0, PI * 2); c.stroke()
	c.fillStyle = "rgba(0,0,0,.5)"; c.fillRect(20, H * 0.86, 120, 9); c.fillStyle = "#7fd0ff" if water > 0.25 else "#ff7070"; c.fillRect(20, H * 0.86, 120 * water, 9)
	c.fillStyle = "#fff"; c.font = "11px sans-serif"; c.textAlign = "left"; c.fillText("頭頂碟水", 20, H * 0.86 - 4)
	var fxx = 150 + (50 - dist) * 24
	if fxx < 400: c.fillStyle = "#fff"; c.fillRect(fxx, top, 4, bot - top)

# ---------------- 選項目面板資料（Menus.open_sports） ----------------
static func panel() -> Dictionary:
	var s = st(); var today = gday(); var list = []
	var GH = _g("GHOSTS")
	for id in ORDER:
		var E = EV[id]; var a = athlete(id); var best = s.best.get(id)
		list.append({"id": id, "name": E.name, "k": a.k, "who": a.name, "sub": J.t(a.sub),
			"goal": ("對手：%s" % (J.str(GH[E.foe].name) if J.t(J.gp(GH, E.foe)) else "轆轤首")) if id == "tug" else "Bryan 今日紀錄：" + fmt_v(id, target(id)),
			"best": ((J.str(best) + " 勝") if id == "tug" else fmt_v(id, best)) if best != null else null,
			"won": s.won.get(id) != null and J.num(s.won[id]) == today})
	return {"list": list}

func run(_env) -> void:
	EV = {
		"jump": {"name": "殭屍跳遠", "who": "laojiang", "bg": "field", "unit": "米", "hi": true,
			"rule": "膝蓋不能彎，只能一跳一跳助跑。著地那一下點「跳」，節奏越準越快；最後在白線前點「起跳」，越貼線越遠，踩線犯規。",
			"sub": "阿福頂上：他膝蓋可以彎，所以要自己忍住。"},
		"tug": {"name": "舌頭對脖子拔河", "who": "n30_diaosi", "foe": "n30_rokurokubi", "bg": "kampung", "unit": "", "hi": true,
			"rule": "狂點「拉」把繩拉過來。繩子變紅就是繃緊了，這時候還拉，舌頭會打滑倒退。把旗拉到你這邊的線就贏。",
			"sub": "吊死鬼不在，阿福用領帶頂上。"},
		"hang": {"name": "天花板倒掛耐力賽", "who": "tianhua", "bg": "hq", "unit": "秒", "hi": true,
			"rule": "按住畫面才抓得住天花板，放手就掉下來。左右拖動手指，把搖擺拉回中間；風扇和掃把會來搞你。",
			"sub": "天花姐不在，阿福倒掛（領帶垂下來了）。"},
		"swim": {"name": "河童游泳", "who": "n30_kappa", "bg": "banana", "unit": "秒", "hi": false,
			"rule": "左右輪流划水向前游。划得太急、同一邊連划，頭頂碟裡的水會晃出去；水乾了河童就沒力。游完 50 米，越快越好。",
			"sub": "河童不在，阿福頂著一碟水游。"},
	}
	var LANG = _g("LANG")
	if LANG != null: J.mc(LANG, "add", [{"繃緊！唔好拉！": "繃緊了！不要拉！"}])
	BRYAN = {
		"jump": D("Bryan：「我籃球跳投出身，跳遠？小意思。」", "Bryan：「我打籃球跳投出身，跳遠？小意思。」"),
		"tug": D("轆轤首：「我條頸三米長，你有幾長？」", "轆轤首：「我的脖子三米長，你有多長？」"),
		"hang": D("Bryan：「倒掛？我喺公司掛名都掛咗三年。」", "Bryan：「倒掛？我在公司掛名都掛了三年。」"),
		"swim": D("Bryan：「我游水唔使碟，因為我頭頂冇嘢。等陣，唔係咁講……」", "Bryan：「我游泳不用碟子，因為我頭上沒東西。等等，不是這樣說……」"),
	}
	G = null
	J.G["Sports"] = {
		"open": func(_t, _a): open_(); return null,
		"start": func(_t, a): start(J.str(J.arg(a, 0))); return null,
		"EV": EV,
		"target": func(_t, a): return target(J.str(J.arg(a, 0))),
		"st": func(_t, _a): return st(),
		"athlete": func(_t, a): return athlete(J.str(J.arg(a, 0))),
		"_n": {"panel": func(_t, _a): return panel(), "go": func(_t, a): J.mc(_g("UI"), "close", []); start(J.str(J.arg(a, 0))); return null},
		"_g": func(_t, _a): return G,
		"_step": func(_t, a): if G != null: step(J.num(J.arg(a, 0))),
	}
