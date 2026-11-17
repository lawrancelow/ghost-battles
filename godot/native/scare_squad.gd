# 原生改寫自 scare_squad.js（回陽間・帶隊出更：招牌小把戲、都市傳說熱度、靈探 KOL、死對頭 Bryan、收工結算）——介面同轉譯版一樣：J.G["ScareX"]
# 資料（SIG 招式表、所有 T(粵, 中) 譯文）喺 data/nat/scare_squad.json；隨機數次序（Bryan 嘅 rng、spark 嘅 randf）同 JS 一樣
# 補丁照保留：open 先問 __nat_scSel（原生揀隊畫面 ui/scare_select）；對外多出 _n:{ owned, maxSq, CN }
extends RefCounted

const PI := 3.141592653589793
static var SIG := {}
static var CN := ["零", "一", "兩", "三", "四", "五", "六"]
const MAXSQ_BASE := 3.0
const LV := [0.0, 40.0, 110.0, 220.0, 380.0]
const LVNAME := ["二十三樓有鬼", "公司群組傳開", "網上瘋傳", "上咗新聞", "全城都市傳說"]
const LVTWIST := [null, "員工一開工已經心緒不寧", "靈探 KOL 上嚟直播捉鬼", "道士早啲到", "全城注目：熱度加兩成"]
const TIERV := {1: [30.0, 30.0], 2: [34.0, 35.0], 3: [38.0, 40.0]}
static var squad := {}

static func _g(n: String): return J.G.get(n)
static func n_(v) -> float: return J.num(v)
static func t_(v) -> bool: return J.t(v)
static func Lx(s):
	var f = _g("L"); return J.cl(f, null, [s]) if f != null else s
static func Lf(s, v: Dictionary) -> String:
	var r = J.str(Lx(s))
	for k in v: r = r.replace("{" + k + "}", J.str(v[k]))
	return r
static func jround(x: float) -> float: return floor(x + 0.5)
static func hyp(a: float, b: float) -> float: return sqrt(a * a + b * b)
static func OM(): return _g("OFFMAP")
static func S_(): return _g("S")
static func pt(Sc, x, y) -> Array:
	var r = J.mc(Sc, "pt", [x, y]); return [n_(r[0]), n_(r[1])]
static func hh(Sc, y) -> float: return n_(J.mc(Sc, "hh", [y]))
static func on_screen(Sc, x, m) -> bool: return J.t(J.mc(Sc, "onScreen", [x, m]))
static func npcs(Sc) -> Array: return J.iter(J.gp(Sc, "npcs"))
static func set_add(s, v) -> void: J.mc(s, "add", [v])
static func new_set(): return J.new_("Set", [])

# ---------- 帶邊幾隻鬼 ----------
static func max_sq() -> float:
	var P = _g("Presence")
	return MAXSQ_BASE + (n_(J.mc(P, "perk", ["squad"])) if P != null and J.t(J.gp(P, "perk")) else 0.0)
static func owned() -> Array:
	var S = S_()
	if not J.t(S) or not J.t(J.gp(S, "ghosts")): return []
	var ks = []; var SG = _g("SCARE_GHOSTS")
	for g in J.iter(J.gp(S, "ghosts")):
		var k = J.gp(g, "k")
		if J.str(k) != "afu" and J.t(J.gp(SG, k)) and not ks.has(k): ks.append(k)
	return ks
static func sq_get() -> Array:
	var o = owned(); var S = S_()
	var s = J.gp(S, "scareSquad") if J.t(S) and J.t(J.gp(S, "scareSquad")) else null
	if s == null:
		s = []
		for k in ["tianhua", "pontianak"]: if o.has(k): s.append(k)
	var s2 = []
	for k in J.iter(s): if o.has(k): s2.append(k)
	s = s2.slice(0, int(max_sq()))
	if s.is_empty(): s = o.slice(0, 2)
	return s
static func sq_set(ids) -> Array:
	var S = S_()
	if not J.t(S): return []
	var o = owned(); var a = J.iter(ids) if J.t(ids) else []; var out = []
	for i in a.size():
		var k = a[i]
		if J.str(k) != "afu" and o.has(k) and a.find(k) == i: out.append(k)
	J.sp(S, "scareSquad", out.slice(0, int(max_sq())))
	var sv = _g("save")
	if sv != null: J.cl(sv, null, [])
	return J.iter(J.gp(S, "scareSquad")).duplicate()

# ---------- 都市傳說 ----------
static func legend(loc) -> Dictionary:
	if not J.t(loc): loc = "office"
	var S = S_()
	var d = J.gp(J.gp(S, "legend"), loc) if J.t(S) and J.t(J.gp(S, "legend")) and J.t(J.gp(J.gp(S, "legend"), loc)) else {"heat": 0.0, "nights": 0.0}
	var lv = 1
	while lv < 5 and n_(J.gp(d, "heat")) >= LV[lv]: lv += 1
	var h = J.gp(d, "heat"); var ni = J.gp(d, "nights")
	return {"heat": h if J.t(h) else 0.0, "lv": float(lv), "nights": ni if J.t(ni) else 0.0, "name": Lx(LVNAME[lv - 1]), "next": LV[lv] if lv < 5 else null, "prev": LV[lv - 1]}

# 靈探 KOL
static func KOL(weak) -> Dictionary:
	var OMx = OM(); var M = func(x): return J.cl(J.gp(OMx, "M"), null, [x])
	var SP = J.gp(OMx, "SPOT")
	return {"k": "kol", "name": "靈探KOL・Kiki", "role": "追鬼直播主・二十萬訂閱", "spr": "npc_it", "tint": "hue-rotate(155deg) saturate(1.25)", "speed": 0.07, "influencer": true, "phone": true,
		"post": [M.call(0.40), 0.88, "film"], "work": [7.0, 11.0], "trips": [["pantry", 2.0, J.gp(SP, "micro"), [5.0, 8.0], "呢度係茶水間，聽講微波爐會自己叮……"], ["meeting", 2.0, J.gp(SP, "seat2"), [5.0, 8.0], "會議室冇人，我哋入去睇睇。"], ["boss", 1.5, J.gp(SP, "bossVisit"), [5.0, 8.0], "老細房，噓……"]],
		"lines": {"work": ["大家記得 like 同 share！", "（對住手機）你哋聽唔聽到？", "留言話見到嘢？邊度邊度？"]},
		"calm": 4.0, "weak": [weak], "immune": ["light", "cold", "breath"], "karma": 0.0,
		"route": [[M.call(0.40), 0.88, 6.0, "film"]],
		"say": {"immune": "（對住鏡頭）呢啲效果做得唔錯喎。", "rational": ["應該係光暗問題。", "呢條片一定爆！"], "prime": ["等陣……你哋見唔見到？！"], "hit": ["有嘢！真係有嘢！", "（手機都跌埋）"], "weak": "（直播畫面突然雪花）", "shout": "直播完——！走——！", "flee": "Kiki 一路尖叫一路直播衝入電梯，條片一晚三百萬 view。"},
		"chat": [["Kiki", "23:50", "今晚探二十三樓！留言話見到咩就講！"], ["觀眾", "00:12", "後面！後面！"], ["Kiki", "00:13", "邊度？！"]]}

# ---------- 一晚開始 ----------
static func _imul(a: int, b: int) -> int: return J.i32((a * b) & 0xFFFFFFFF)
static func _u(a: int) -> int: return a & 0xFFFFFFFF
static func rng(seed: float) -> Callable:
	var st = [J.i32(seed)]
	return func(_t = null, _a = null) -> float:
		var a: int = J.i32(st[0] + 0x6D2B79F5); st[0] = a
		var t: int = _imul(a ^ (_u(a) >> 15), 1 | a)
		t = J.i32(t + _imul(t ^ (_u(t) >> 7), 61 | t)) ^ t
		return float(_u(t ^ (_u(t) >> 14))) / 4294967296.0
static func night(Sc) -> void:
	var lg = legend(J.gp(Sc, "siteId")); var R = rng(n_(J.gp(Sc, "seed")) * 7 + 991)
	J.sp(Sc, "night", {"seen": 0.0, "nb": 0.0, "alone": 0.0, "types": new_set(), "tricks": new_set(), "inf": 0.0, "infFled": 0.0, "filmed": 0.0, "stole": 0.0, "foiled": 0.0, "bryanOut": 0.0, "per": {}, "best": null, "lv": lg.lv})
	J.sp(Sc, "daoAt", 55.0 if lg.lv >= 4 else 0.0); J.sp(Sc, "daoDelay", 3.0 if lg.lv >= 4 else 0.0)
	if not J.t(J.gp(J.gp(Sc, "site"), "pano")): return
	if lg.lv >= 2:
		for n in npcs(Sc): if not J.t(J.gp(J.gp(n, "d"), "guard")): J.sp(n, "shaken", 15.0); J.sp(n, "fear", 8.0)
	if lg.lv >= 3:
		var d = KOL(["sound", "shadow", "face", "phone"][int(floor(R.call() * 4))])
		var n = {"d": d, "x": d.post[0], "y": d.post[1], "wi": 0.0, "wait": 6.0, "dir": 1.0, "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": "film", "ph": 0.0, "ev": [], "_seed": float(J.i32(n_(J.gp(Sc, "seed")) * 131 + 77))}
		n["step"] = {"x": n.x, "y": n.y, "wait": 8.0, "act": "film", "arrived": true}
		J.gp(Sc, "npcs").append(n)
		J.mc(Sc, "goOut", [n, 12 + R.call() * 15, false, "大家好！今晚帶大家探二十三樓！", true])
	var fb = J.gp(Sc, "forceBryan"); var forced = fb if fb != null else null; var p = 0.25 + 0.08 * (lg.lv - 1)
	var go = J.t(forced) if forced != null else R.call() < p
	J.sp(Sc, "bryan", {"at": 30 + R.call() * 30, "st": "wait", "x": 0.0, "y": 0.8, "cd": 4.0, "t": 0.0, "R": R, "dir": 1.0, "alpha": 0.0} if go else null)

# ---------- 每次嚇到人 ----------
static func on_hit(Sc, n, o) -> void:
	var N = J.gp(Sc, "night")
	if not J.t(N): return
	var pts = n_(J.gp(o, "pts"))
	if pts > 0:
		set_add(N.types, J.gp(o, "type")); set_add(N.tricks, J.gp(o, "ghost"))
		var gk = J.key(J.gp(o, "ghost"))
		if not J.t(N.per.get(gk)): N.per[gk] = {"scares": 0.0, "fear": 0.0}
		var P = N.per[gk]; P["scares"] = n_(P.scares) + 1; P["fear"] = n_(P.fear) + pts
	if J.t(J.gp(o, "clean")) and n_(J.gp(o, "mk")) >= 2: N["nb"] = n_(N.nb) + 1
	if J.t(J.gp(o, "clean")) and J.t(J.gp(o, "alone")): N["alone"] = n_(N.alone) + 1
	if pts > 0 and (not J.t(N.best) or n_(J.gp(n, "fear")) > n_(N.best.fear)):
		N["best"] = {"name": J.gp(J.gp(n, "d"), "name"), "fear": J.gp(n, "fear"), "ghost": J.gp(o, "ghost"), "room": J.gp(J.cl(J.gp(OM(), "roomAt"), null, [J.gp(n, "x")]), "name") if J.t(J.gp(J.gp(Sc, "site"), "pano")) else ""}
	if J.t(J.gp(J.gp(n, "d"), "influencer")) and pts > 0:
		N["inf"] = n_(N.inf) + 3
		if n_(J.gp(n, "fear")) >= 100: N["infFled"] = 1.0
	var B = J.gp(Sc, "bryan")
	if J.t(B) and J.str(B.st) == "stalk" and is_same(B.get("tgt"), n) and pts > 0:
		B["st"] = "roam"; B["cd"] = 8.0; B["tgt"] = null; N["foiled"] = n_(N.foiled) + 1; J.sp(Sc, "kpi", n_(J.gp(Sc, "kpi")) + 10)
		J.mc(Sc, "float", [J.gp(n, "x"), n_(J.gp(n, "y")) - 0.3, Lx("搶先一步！Bryan 冇得搶 +10"), "#c9a0ff", 1.6])
		if J.t(J.gp(Sc, "bubble")): bryan_say(Sc, "喂！搶我生意？！")
	if J.t(B) and (J.str(B.st) == "stalk" or J.str(B.st) == "roam") and J.t(J.mc(Sc, "sameRoom", [n, B])) and hyp(n_(J.gp(n, "x")) - n_(B.x), n_(J.gp(n, "y")) - n_(B.y)) < 0.7:
		for m in npcs(Sc):
			if not is_same(m, n) and not J.t(J.gp(J.gp(m, "d"), "guard")) and J.t(J.mc(Sc, "sameRoom", [m, B])) and not J.t(J.gp(m, "out")) and not J.t(J.gp(m, "gone")):
				var lu = J.gp(m, "lookUp"); J.sp(m, "lookUp", maxf(n_(lu) if J.t(lu) else 0.0, 3.0))
static func bryan_say(Sc, s) -> void:
	var B = J.gp(Sc, "bryan")
	if not J.t(B): return
	B["say"] = Lx(s); B["sayT"] = 2.4

# ---------- Bryan ----------
static func _ok(n) -> bool:
	return J.t(n) and not J.t(J.gp(n, "gone")) and not J.t(J.gp(n, "out")) and not J.t(J.gp(n, "fleeing")) and not J.t(J.gp(J.gp(n, "d"), "guard")) and not J.t(J.gp(J.gp(n, "d"), "daoshi"))
static func _move(B: Dictionary, tx: float, ty: float, sp: float, dt: float) -> bool:
	var dx = tx - n_(B.x); var dy = ty - n_(B.y); var d = hyp(dx, dy)
	if d < sp * dt: B["x"] = tx; B["y"] = ty; return true
	B["x"] = n_(B.x) + dx / d * sp * dt; B["y"] = n_(B.y) + dy / d * sp * dt; B["dir"] = 1.0 if dx >= 0 else -1.0
	return false
static func _R(B) -> float: return n_(J.cl(B.R, null, []))
static func tick(Sc, dt: float) -> void:
	var B = J.gp(Sc, "bryan")
	if not J.t(B) or J.str(B.st) == "gone": return
	B["t"] = n_(B.t) + dt; B["sayT"] = maxf(0.0, (n_(B.sayT) if J.t(B.get("sayT")) else 0.0) - dt)
	var stt = J.str(B.st)
	if stt == "wait":
		if n_(J.gp(Sc, "t")) < n_(B.at): return
		var rs = J.iter(J.gp(OM(), "ROOMS")); var r = rs[int(floor(_R(B) * rs.size()))]
		B["x"] = J.gp(r, "cx"); B["y"] = 0.8; B["st"] = "roam"; B["cd"] = 5.0; B["alpha"] = 0.0
		J.mc(Sc, "float", [0.5, 0.3, Lx("死對頭 Bryan 都嚟咗，佢要搶你嘅 KPI！"), "#c9a0ff", 2.4]); bryan_say(Sc, "今晚呢層樓係我嘅！"); return
	B["alpha"] = minf(0.85, n_(B.alpha) + dt * 1.5)
	if stt == "roam":
		B["cd"] = n_(B.cd) - dt
		if not J.t(B.get("wp")) or _move(B, n_(B.wp[0]), n_(B.wp[1]), 0.08, dt):
			var nx = maxf(0.15, minf(n_(J.gp(OM(), "WW")) - 0.15, n_(B.x) + (_R(B) - 0.5) * 0.6)); B["wp"] = [nx, 0.7 + _R(B) * 0.2]
		if n_(B.cd) <= 0:
			var c = []
			for n in npcs(Sc): if _ok(n): c.append(n)
			if c.size():
				var sel = J.gp(Sc, "sel")
				var sc = func(n) -> float:
					var mk = J.gp(n, "mocked")
					return n_(J.gp(n, "fear")) + (20.0 if is_same(n, sel) else 0.0) + (n_(mk) if J.t(mk) else 0.0) * 6 + _R(B) * 12
				B["tgt"] = J.gp(J.mc(c, "sort", [func(_t, a): return sc.call(a[1]) - sc.call(a[0])]), 0.0); B["st"] = "stalk"; B["t"] = 0.0; B["side"] = -1.0 if _R(B) < 0.5 else 1.0
			else: B["cd"] = 4.0
		return
	if stt == "stalk":
		var n = B.get("tgt")
		if not _ok(n): B["st"] = "roam"; B["cd"] = 3.0; return
		var arrived = _move(B, n_(J.gp(n, "x")) + n_(B.side) * 0.15, n_(J.gp(n, "y")) - 0.01, 0.16, dt)
		if arrived and n_(B.t) > 4: B["st"] = "strike"; B["t"] = 0.0
		return
	if stt == "strike":
		var n = B.get("tgt")
		if n_(B.t) < 0.5: return
		if not J.t(B.get("done")): B["done"] = true; resolve(Sc, B, n)
		if n_(B.t) > 1.1:
			B["done"] = false
			if J.str(B.st) == "strike": B["st"] = "roam"; B["cd"] = 14 + _R(B) * 6; B["tgt"] = null
		return
	if stt == "flee":
		B["alpha"] = maxf(0.0, n_(B.alpha) - dt * 0.8); _move(B, n_(B.x) + n_(B.dir) * 2, n_(B.y), 0.4, dt)
		if n_(B.alpha) <= 0: B["st"] = "gone"
static func resolve(Sc, B: Dictionary, n) -> void:
	if not J.t(n) or J.t(J.gp(n, "gone")) or J.t(J.gp(n, "out")) or J.t(J.gp(n, "fleeing")): return
	var wits = []
	for m in npcs(Sc):
		if not is_same(m, n) and not J.t(J.gp(J.gp(m, "d"), "daoshi")) and J.t(J.mc(Sc, "sees", [m, {"x": B.x, "y": B.y}])): wits.append(m)
	if wits.size():
		B["st"] = "flee"; B["dir"] = -1.0 if n_(B.x) < n_(J.gp(OM(), "WW")) / 2 else 1.0; J.sp(J.gp(Sc, "night"), "bryanOut", 1.0); J.sp(Sc, "kpi", n_(J.gp(Sc, "kpi")) + 40)
		var names = PackedStringArray()
		for w in wits: names.append(J.str(J.gp(J.gp(w, "d"), "name")))
		J.mc(Sc, "float", [B.x, n_(B.y) - 0.3, Lf("Bryan 穿崩！俾{n}望到，走佬 +40", {"n": "、".join(names)}), "#c9a0ff", 2.2])
		bryan_say(Sc, "衰咗……走先！")
		for w in wits:
			if not J.t(J.gp(J.gp(w, "d"), "guard")):
				J.sp(w, "fear", minf(99.0, n_(J.gp(w, "fear")) + 10)); J.sp(w, "peak", maxf(n_(J.gp(w, "peak")), n_(J.gp(w, "fear"))))
				J.mc(Sc, "bubble", [w, Lx("頭先……個著波衫嘅係邊個？！"), 2.2])
		return
	if n_(J.gp(n, "fear")) >= 40:
		J.sp(n, "fear", n_(J.gp(n, "fear")) + 45); J.sp(n, "peak", maxf(n_(J.gp(n, "peak")), minf(100.0, n_(J.gp(n, "fear"))))); J.sp(n, "mocked", 0.0); J.sp(n, "combo", 0.0)
		var N = J.gp(Sc, "night"); J.sp(N, "stole", n_(J.gp(N, "stole")) + 1)
		J.mc(Sc, "float", [J.gp(n, "x"), n_(J.gp(n, "y")) - 0.3, Lx("Bryan 搶咗你嘅爆點！"), "#ff8ad0", 2.2]); bryan_say(Sc, "多謝晒你幫我鋪墊！")
		if not J.t(J.gp(Sc, "headless")): J.mc(Sc, "react", [n, "burst", {"src": B.x}])
		J.mc(Sc, "bubble", [n, Lx("呀——！"), 1.8])
		if n_(J.gp(n, "fear")) >= 100:
			J.sp(n, "fleeing", true)
			if not J.t(J.gp(Sc, "headless")): J.sp(n, "fleeT", J.gp(Sc, "t")); J.sp(n, "fleeHold", 0.4); J.sp(n, "trail", [[J.gp(Sc, "t"), J.gp(n, "x"), J.gp(n, "y")]])
	else:
		J.sp(n, "fear", minf(60.0, n_(J.gp(n, "fear")) + 15)); J.sp(n, "peak", maxf(n_(J.gp(n, "peak")), n_(J.gp(n, "fear"))))
		if not J.t(J.gp(Sc, "headless")): J.mc(Sc, "react", [n, "flinch", {"src": B.x}])
		bryan_say(Sc, "暖下身先。")

# ---------- 畫 ----------
static func _vx(n) -> float: return n_(J.gp(n, "vX")) if J.gp(n, "vX") != null else n_(J.gp(n, "x"))
static func draw(Sc, ctx: Ctx, t: float) -> void:
	for n in npcs(Sc):
		if J.t(J.gp(J.gp(n, "d"), "influencer")) and not J.t(J.gp(n, "gone")) and not J.t(J.gp(n, "out")) and on_screen(Sc, J.gp(n, "x"), 0.2):
			var p0 = pt(Sc, _vx(n), J.gp(n, "y")); var x = p0[0]; var y = p0[1]; var h = hh(Sc, J.gp(n, "y")); var s = n_(J.gp(n, "dir")) if J.t(J.gp(n, "dir")) else 1.0
			var px = x + s * h * 0.2; var py = y - h * 0.72
			ctx.save(); ctx.strokeStyle = "rgba(40,40,50,.9)"; ctx.lineWidth = 3.0; ctx.beginPath(); ctx.moveTo(x + s * h * 0.08, y - h * 0.5); ctx.lineTo(px, py); ctx.stroke()
			ctx.fillStyle = "#222"; ctx.fillRect(px - h * 0.035, py - h * 0.06, h * 0.07, h * 0.11); ctx.globalCompositeOperation = "lighter"; ctx.strokeStyle = "rgba(255,250,230,%s)" % J.str(0.7 + 0.2 * sin(t * 3)); ctx.lineWidth = 2.5; ctx.beginPath(); ctx.arc(px, py, h * 0.085, 0.0, PI * 2); ctx.stroke()
			var g = ctx.createRadialGradient(px, py, 0.0, px, py, h * 0.5); g.addColorStop(0.0, "rgba(255,250,230,.22)"); g.addColorStop(1.0, "rgba(255,250,230,0)"); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, h * 0.5, 0.0, PI * 2); ctx.fill()
			if sin(t * 2) > 0:
				ctx.globalCompositeOperation = "source-over"; ctx.fillStyle = "#ff3a3a"; ctx.beginPath(); ctx.arc(px + s * h * 0.05, py - h * 0.09, 3.0, 0.0, PI * 2); ctx.fill(); ctx.font = "800 9px sans-serif"; ctx.fillText("LIVE", px + s * h * 0.07 - 4, py - h * 0.07)
			ctx.restore()
	var B = J.gp(Sc, "bryan")
	if not J.t(B) or J.str(B.st) == "wait" or J.str(B.st) == "gone" or _g("Antag") == null: return
	var tg = B.get("tgt")
	if J.str(B.st) == "stalk" and J.t(tg) and not J.t(J.gp(tg, "gone")) and on_screen(Sc, J.gp(tg, "x"), 0.1):
		var tp = pt(Sc, _vx(tg), J.gp(tg, "y")); var h2 = hh(Sc, J.gp(tg, "y"))
		ctx.save(); ctx.strokeStyle = "rgba(210,140,255,%s)" % J.str(0.5 + 0.3 * sin(t * 6)); ctx.lineWidth = 2.0; ctx.setLineDash([5.0, 4.0]); ctx.beginPath(); ctx.ellipse(tp[0], tp[1], h2 * 0.3, h2 * 0.08, 0.0, 0.0, PI * 2); ctx.stroke(); ctx.restore()
	if not on_screen(Sc, B.x, 0.3): return
	var p = pt(Sc, B.x, B.y); var x = p[0]; var y = p[1]; var h = hh(Sc, B.y); var fl = sin(t * 2.2) * h * 0.025 - h * 0.04
	var stt = J.str(B.st)
	var st = ("attack" if n_(B.t) < 0.6 else "jumpshot") if stt == "strike" else ("walk" if stt == "stalk" else ("scared" if stt == "flee" else ("spin" if int(floor(t / 4)) % 2 else "dribble")))
	ctx.save(); ctx.globalAlpha = n_(B.alpha); ctx.fillStyle = "rgba(120,60,180,.25)"; ctx.beginPath(); ctx.ellipse(x, y, h * 0.2, h * 0.05, 0.0, 0.0, PI * 2); ctx.fill()
	J.mc(_g("Antag"), "draw", [ctx, "npc_rival", x, y + fl, h * 0.93, st, B.t if stt == "strike" else t, {"faceRight": n_(B.dir) > 0, "alpha": B.alpha, "shadow": false, "time": t}])
	ctx.restore()
	ctx.save(); ctx.font = "800 11px sans-serif"; ctx.textAlign = "center"; ctx.lineWidth = 3.0; ctx.strokeStyle = "rgba(0,0,0,.8)"; var lab = J.str(Lx("Bryan（死對頭）")); var ty = y - h * 1.02 + fl; ctx.strokeText(lab, x, ty); ctx.fillStyle = "#d6a8ff"; ctx.fillText(lab, x, ty)
	if n_(B.get("sayT")) > 0 and J.t(B.get("say")):
		ctx.font = "700 12px sans-serif"; var w = n_(ctx.measureText(J.str(B.say)).width) + 16; var bx = maxf(4.0, minf(n_(J.gp(Sc, "W")) - w - 4, x - w / 2)); ctx.fillStyle = "rgba(50,20,70,.92)"; ctx.strokeStyle = "#b48ad8"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(bx, ty - 38, w, 24.0, 9.0); ctx.fill(); ctx.stroke(); ctx.fillStyle = "#f0e0ff"; ctx.textAlign = "left"; ctx.fillText(J.str(B.say), bx + 8, ty - 21)
	ctx.restore()

static func _R1(i: float) -> float: var v = sin(i * 127.1 + 311.7) * 43758.5; return v - floor(v)
static func _txt(ctx: Ctx, s: String, xx: float, yy: float, sz: float, a: float, c = null) -> void:
	ctx.save(); ctx.globalAlpha = ctx.globalAlpha * a; ctx.font = "900 %spx sans-serif" % J.str(jround(sz)); ctx.textAlign = "center"; ctx.lineWidth = 3.0; ctx.strokeStyle = "#1a1020"; ctx.strokeText(s, xx, yy); ctx.fillStyle = c if J.t(c) else "#fff3d0"; ctx.fillText(s, xx, yy); ctx.restore()
static func _portrait(k, sz: float):
	var A = _g("ART")
	if A == null or not J.t(J.gp(A, "portrait")): return null
	return J.mc(A, "portrait", [k, sz, {"tamed": true}])
static func sig_fx(Sc, ctx: Ctx, f, t: float, k: float) -> void:
	var n = J.gp(f, "n")
	if not J.t(n) or J.t(J.gp(n, "gone")): return
	var vx = _vx(n)
	if J.t(J.gp(J.gp(Sc, "site"), "pano")) and not on_screen(Sc, vx, 0.2): return
	var p = pt(Sc, vx, J.gp(n, "y")); var x = p[0]; var y = p[1]; var h = hh(Sc, J.gp(n, "y")); var hx = x; var hy = y - h * 0.8
	var col = J.gp(f, "col") if J.t(J.gp(f, "col")) else "#fff"; var e = minf(1.0, minf(k * 5, (1 - k) * 4))
	var ghost = J.str(J.gp(f, "ghost")); var dir = n_(J.gp(n, "dir")) if J.t(J.gp(n, "dir")) else 1.0
	ctx.save(); ctx.globalAlpha = e; ctx.lineCap = "round"
	match J.str(J.gp(f, "sig")):
		"frost":
			for i in 14:
				var a = _R1(i) * PI * 2; var r = h * (0.1 + 0.35 * k * _R1(i + 3)); ctx.strokeStyle = "rgba(220,245,255,.9)"; ctx.lineWidth = 1.6; var cx = hx + cos(a) * r; var cy = hy + h * 0.2 + sin(a) * r * 0.6
				for j in 3:
					var b = j * PI / 3; ctx.beginPath(); ctx.moveTo(cx - cos(b) * 4, cy - sin(b) * 4); ctx.lineTo(cx + cos(b) * 4, cy + sin(b) * 4); ctx.stroke()
			ctx.fillStyle = "rgba(200,235,255,.85)"; ctx.fillRect(hx + h * 0.18, hy + h * 0.25, h * 0.08, h * 0.1); ctx.strokeStyle = "#fff"; ctx.strokeRect(hx + h * 0.18, hy + h * 0.25, h * 0.08, h * 0.1); _txt(ctx, "冰", hx + h * 0.22, hy + h * 0.33, h * 0.07, 1.0, "#2a6a9a")
		"copier":
			var w = h * 0.55; var hgt = h * 0.32; var bx = hx - w / 2; var by = hy - h * 0.45; ctx.fillStyle = "rgba(180,255,210,.35)"; ctx.fillRect(bx, by, w, hgt); ctx.strokeStyle = "rgba(200,255,220,.9)"; ctx.lineWidth = 2.0; ctx.strokeRect(bx, by, w, hgt)
			var pc = _portrait(J.gp(f, "ghost"), 96.0)
			if pc != null: ctx.globalAlpha = e * 0.85; ctx.globalCompositeOperation = "luminosity"; ctx.drawImage(pc, hx - hgt * 0.45, by + hgt * 0.05, hgt * 0.9, hgt * 0.9)
			ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = "rgba(150,255,190,.5)"; ctx.fillRect(bx, by + hgt * fmod(t * 1.5, 1.0), w, 3.0)
		"pop":
			for i in 6:
				var q = minf(1.0, k * 2.2 - i * 0.12)
				if q <= 0: continue
				var px = hx + (_R1(i) - 0.5) * h * 0.9 * q; var py = hy - h * 0.2 - sin(q * PI) * h * 0.5 + q * h * 0.2; ctx.fillStyle = col; ctx.strokeStyle = "#776"; ctx.lineWidth = 1.0; ctx.beginPath(); ctx.arc(px, py, h * 0.035, 0.0, PI * 2); ctx.fill(); ctx.stroke()
			_txt(ctx, "噗！", hx, hy - h * 0.5, h * 0.12, 1.0)
		"screen":
			var w = h * 0.6; var hgt = h * 0.38; var bx = hx - w / 2; var by = hy - h * 0.55; ctx.fillStyle = "#101018"; ctx.fillRect(bx, by, w, hgt); ctx.strokeStyle = "#555"; ctx.lineWidth = 3.0; ctx.strokeRect(bx, by, w, hgt)
			var bl = sin(t * 9) > 0; ctx.fillStyle = col; ctx.font = "900 %spx monospace" % J.str(jround(hgt * 0.26)); ctx.textAlign = "center"
			if bl or ghost != "n30_daji": ctx.fillText("GAME OVER" if ghost == "n30_daji" else ("（冇面）" if ghost == "n30_nopperabo" else "+1"), hx, by + hgt * 0.58)
			ctx.globalCompositeOperation = "lighter"; var g = ctx.createRadialGradient(hx, by + hgt / 2, 0.0, hx, by + hgt / 2, w); g.addColorStop(0.0, "rgba(255,90,90,.25)"); g.addColorStop(1.0, "rgba(255,90,90,0)"); ctx.fillStyle = g; ctx.fillRect(bx - w / 2, by - hgt, w * 2, hgt * 3)
		"spark":
			for i in 7:
				if randf() < 0.4: continue
				var a = _R1(i + floor(t * 20)) * PI * 2; var L0 = h * (0.15 + 0.2 * randf()); ctx.strokeStyle = "#fff" if i % 2 else col; ctx.lineWidth = 2.0; ctx.beginPath(); var px = hx; var py = y - h * 0.15; ctx.moveTo(px, py)
				for j in 4:
					px += cos(a) * L0 / 4 + (randf() - 0.5) * 8; py += sin(a) * L0 / 4 + (randf() - 0.5) * 8; ctx.lineTo(px, py)
				ctx.stroke()
			_txt(ctx, "啪！", hx + h * 0.25, y - h * 0.35, h * 0.1, 1.0)
		"snip":
			var sx = hx + h * 0.25; var sy = hy - h * 0.1; var op = absf(sin(t * 12)) * 0.6; ctx.strokeStyle = "#ddd"; ctx.lineWidth = 3.0
			for s in [-1.0, 1.0]:
				ctx.beginPath(); ctx.moveTo(sx, sy); ctx.lineTo(sx + cos(s * op) * h * 0.18, sy + sin(s * op) * h * 0.18); ctx.stroke(); ctx.beginPath(); ctx.arc(sx - cos(-s * op) * h * 0.04, sy - sin(-s * op) * h * 0.04, 4.0, 0.0, PI * 2); ctx.stroke()
			for i in 6:
				var q = fmod(k * 1.5 + _R1(i), 1.0); ctx.fillStyle = col; ctx.save(); ctx.translate(sx + (_R1(i + 1) - 0.5) * h * 0.5, sy + q * h * 0.7); ctx.rotate(t * 3 + i); ctx.fillRect(-4.0, -1.5, 8.0, 3.0); ctx.restore()
			_txt(ctx, "咔嚓", sx, sy - h * 0.15, h * 0.08, 1.0)
		"drip":
			for i in 8:
				var q = fmod(t * 1.3 + _R1(i), 1.0); var dx = hx + (_R1(i + 2) - 0.5) * h * 0.3; ctx.fillStyle = col; ctx.beginPath(); ctx.ellipse(dx, hy - h * 0.9 + q * h * 0.85, 2.5, 4.0, 0.0, 0.0, PI * 2); ctx.fill()
			ctx.fillStyle = "rgba(120,180,230,.35)"; ctx.beginPath(); ctx.ellipse(hx, y, h * 0.25 * minf(1.0, k * 3), h * 0.05, 0.0, 0.0, PI * 2); ctx.fill(); _txt(ctx, "滴……滴……", hx, hy - h * 0.6, h * 0.08, 1.0)
		"laugh":
			for i in 5:
				var q = fmod(k * 1.6 + i / 5.0, 1.0); _txt(ctx, "哈", hx + (_R1(i) - 0.5) * h * 0.9, hy - q * h * 0.6, h * (0.08 + 0.05 * _R1(i + 3)), sin(q * PI), col)
		"smoke":
			for i in 7:
				var q = fmod(k * 1.2 + i / 7.0, 1.0); var px = hx + (_R1(i) - 0.5) * h * 0.4 + sin(t * 2 + i) * 6; var py = hy + h * 0.2 - q * h * 0.5; var r = h * (0.06 + 0.12 * q)
				var g = ctx.createRadialGradient(px, py, 0.0, px, py, r); g.addColorStop(0.0, col); g.addColorStop(1.0, "rgba(0,0,0,0)"); ctx.globalAlpha = e * 0.55 * (1 - q); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, r, 0.0, PI * 2); ctx.fill()
		"shadow":
			ctx.globalAlpha = e * 0.55; var sx = hx - dir * h * 0.3; var H = h * (1.3 + 0.5 * k); ctx.fillStyle = "rgba(230,230,240,.5)" if col == "#e8e8f0" or col == "#e8e0d0" else "rgba(5,3,12,.85)"; ctx.beginPath(); ctx.ellipse(sx, y - H * 0.5, h * 0.22, H * 0.5, 0.0, 0.0, PI * 2); ctx.fill(); ctx.beginPath(); ctx.arc(sx, y - H * 0.98, h * 0.13, 0.0, PI * 2); ctx.fill()
		"coins":
			for i in 9:
				var q = minf(1.0, k * 2 - _R1(i) * 0.4)
				if q <= 0: continue
				var px = hx + (_R1(i) - 0.5) * h * 0.8; var py = hy - h * 0.3 + q * h * 0.9 - sin(q * PI) * h * 0.3; ctx.fillStyle = col; ctx.save(); ctx.translate(px, py); ctx.rotate(t * 5 + i); ctx.scale(cos(t * 8 + i), 1.0); ctx.beginPath(); ctx.ellipse(0.0, 0.0, 5.0, 5.0, 0.0, 0.0, PI * 2); ctx.fill(); ctx.restore()
			_txt(ctx, "叮噹", hx, hy - h * 0.4, h * 0.08, 1.0)
		"hair", "veil", "tongue":
			var L1 = h * (0.2 + 0.8 * minf(1.0, k * 2.5)); var sg = J.str(J.gp(f, "sig"))
			if sg == "tongue":
				ctx.fillStyle = "#e04a5a" if col == "#ffffff" else col; ctx.beginPath(); ctx.moveTo(hx - 5, hy - h * 1.2); ctx.quadraticCurveTo(hx - 8 + sin(t * 3) * 4, hy - h * 1.2 + L1 * 0.6, hx, hy - h * 1.2 + L1); ctx.quadraticCurveTo(hx + 8, hy - h * 1.2 + L1 * 0.6, hx + 5, hy - h * 1.2); ctx.fill()
			elif sg == "veil":
				var vy = hy - h * 0.9 + minf(1.0, k * 2) * h * 0.75; ctx.fillStyle = col; ctx.beginPath(); ctx.moveTo(hx - h * 0.2, vy); ctx.quadraticCurveTo(hx, vy - h * 0.15, hx + h * 0.2, vy); ctx.lineTo(hx + h * 0.17 + sin(t * 4) * 3, vy + h * 0.22); ctx.lineTo(hx - h * 0.17, vy + h * 0.22); ctx.fill(); ctx.fillStyle = "#ffd36a"; ctx.fillRect(hx - h * 0.17, vy + h * 0.2, h * 0.34, 3.0)
			else:
				ctx.strokeStyle = col; ctx.lineWidth = 2.5
				for i in 14:
					var sx = hx + (i - 7) * h * 0.025; ctx.beginPath(); ctx.moveTo(sx, hy - h * 1.1); ctx.quadraticCurveTo(sx + sin(t * 2 + i) * 6, hy - h * 1.1 + L1 * 0.5, sx + sin(t * 1.5 + i) * 10, hy - h * 1.1 + L1); ctx.stroke()
		"bones":
			for i in 4:
				var px = hx + (i - 1.5) * h * 0.16 + sin(t * 20 + i) * 3; var py = hy - h * 0.25 + cos(t * 17 + i) * 3; ctx.fillStyle = col; ctx.save(); ctx.translate(px, py); ctx.rotate(i + sin(t * 10) * 0.4); ctx.fillRect(-h * 0.05, -2.0, h * 0.1, 4.0); ctx.beginPath(); ctx.arc(-h * 0.05, 0.0, 3.5, 0.0, PI * 2); ctx.arc(h * 0.05, 0.0, 3.5, 0.0, PI * 2); ctx.fill(); ctx.restore()
			_txt(ctx, "咔咔咔", hx, hy - h * 0.45, h * 0.08, 1.0)
		"thump":
			var q = fmod(k * 4, 1.0); ctx.strokeStyle = "rgba(255,240,200,.8)"; ctx.lineWidth = 2.0; ctx.beginPath(); ctx.ellipse(hx, hy - h * 0.5, h * (0.1 + q * 0.4), h * (0.03 + q * 0.08), 0.0, 0.0, PI * 2); ctx.stroke(); _txt(ctx, "咚！", hx + (_R1(floor(k * 4)) - 0.5) * h * 0.4, hy - h * 0.55, h * 0.13, 1 - q * 0.5)
		"flash":
			var on = sin(t * 30) > 0.2
			if on: ctx.globalCompositeOperation = "lighter"; var g = ctx.createRadialGradient(hx, hy, 0.0, hx, hy, h * 1.4); g.addColorStop(0.0, J.str(col) + "88"); g.addColorStop(1.0, "rgba(0,0,0,0)"); ctx.fillStyle = g; ctx.fillRect(hx - h * 1.4, hy - h * 1.4, h * 2.8, h * 2.8)
			if k > 0.3 and k < 0.7:
				var pc = _portrait(J.gp(f, "ghost"), 96.0)
				if pc != null: var sz = h * 0.45; ctx.globalCompositeOperation = "source-over"; ctx.globalAlpha = e * 0.6; ctx.drawImage(pc, hx - dir * h * 0.45 - sz / 2, hy - h * 0.45, sz, sz)
		"heat":
			for i in 8:
				var q = fmod(t * 0.9 + i / 8.0, 1.0); var px = hx + (i - 4) * h * 0.07; ctx.strokeStyle = "rgba(255,%s,60,%s)" % [J.str(120 + i * 10), J.str(0.6 * (1 - q))]; ctx.lineWidth = 2.0; ctx.beginPath(); ctx.moveTo(px, y - q * h * 1.1); ctx.quadraticCurveTo(px + sin(t * 6 + i) * 6, y - q * h * 1.1 - 10, px, y - q * h * 1.1 - 20); ctx.stroke()
			_txt(ctx, "熱……", hx, hy - h * 0.45, h * 0.08, 1.0)
		"phone":
			var px = hx + dir * h * 0.25; var py = hy - h * 0.15; var sh = sin(t * 40) * 2; ctx.fillStyle = "#222"; ctx.fillRect(px - 6 + sh, py - 10, 12.0, 20.0); ctx.fillStyle = col; ctx.fillRect(px - 4 + sh, py - 8, 8.0, 13.0)
			for i in range(1, 4):
				ctx.strokeStyle = "rgba(255,255,255,%s)" % J.str(0.7 - i * 0.18); ctx.lineWidth = 1.5; ctx.beginPath(); ctx.arc(px, py, 8 + i * 6, -0.8, 0.8); ctx.stroke(); ctx.beginPath(); ctx.arc(px, py, 8 + i * 6, PI - 0.8, PI + 0.8); ctx.stroke()
			_txt(ctx, "鈴鈴鈴", px, py - 24, h * 0.07, 1.0)
		"whisper":
			for i in 3:
				var q = fmod(k * 1.3 + i / 3.0, 1.0); _txt(ctx, "唧" if ghost == "n30_pelesit" else "……", hx - dir * h * (0.2 + q * 0.3), hy - h * 0.1 - q * h * 0.2, h * 0.07, sin(q * PI) * 0.8, col)
		"scream":
			var s2 = 1 + sin(t * 25) * 0.05; _txt(ctx, "呀——！", hx + sin(t * 30) * 3, hy - h * 0.5, h * 0.13 * s2, 1.0, col)
		"prints":
			for i in 5:
				var q = minf(1.0, k * 3 - i * 0.3)
				if q <= 0: continue
				var px = hx + (i - 2.5) * h * 0.14 * -dir; var py = y + (4.0 if i % 2 else -4.0); ctx.globalAlpha = e * q * 0.8; ctx.fillStyle = col; ctx.beginPath(); ctx.ellipse(px, py, 5.0, 2.5, 0.0, 0.0, PI * 2); ctx.fill()
				for j in 3: ctx.beginPath(); ctx.arc(px + dir * 6, py - 2 + j * 2, 1.2, 0.0, PI * 2); ctx.fill()
		"dark":
			var g = ctx.createRadialGradient(hx, hy, h * 0.2, hx, hy, h * 1.3); g.addColorStop(0.0, "rgba(0,0,0,0)"); g.addColorStop(1.0, "rgba(0,0,10,.75)"); ctx.fillStyle = g; ctx.fillRect(hx - h * 1.5, hy - h * 1.5, h * 3, h * 3); _txt(ctx, "啪", hx, hy - h * 0.6, h * 0.1, 1.0)
	ctx.restore()
	if k > 0.1 and k < 0.8 and J.t(J.gp(f, "sigText")): _txt(ctx, J.str(Lx(J.gp(f, "sigText"))), hx, y + h * 0.12, maxf(12.0, h * 0.075), minf(1.0, minf((k - 0.1) * 6, (0.8 - k) * 6)), "#e8c8ff")

# ---------- 收工 ----------
static func finish(Sc, stars, quit) -> String:
	var N = J.gp(Sc, "night")
	if not J.t(N): N = {"per": {}, "types": new_set(), "seen": 0.0, "nb": 0.0, "alone": 0.0, "inf": 0.0, "infFled": 0.0, "filmed": 0.0, "stole": 0.0, "bryanOut": 0.0, "foiled": 0.0}
	var loc = J.gp(Sc, "siteId")
	var before = legend(loc)
	var tsz = n_(J.gp(N.types, "size"))
	var heat = n_(J.gp(Sc, "kpi")) / 120 + 8 * n_(N.nb) + 4 * n_(N.alone) + 2 * tsz + (-3 * n_(N.seen) if J.t(N.seen) else 6.0) + n_(N.inf) + 20 * n_(N.infFled) + 4 * n_(N.filmed) + 5 * n_(N.bryanOut) - (10.0 if J.t(J.gp(Sc, "expelled")) else 0.0) - (5.0 if J.t(quit) else 0.0)
	heat = maxf(0.0, jround(heat * (1.2 if before.lv >= 5 else 1.0)))
	var S = S_()
	if J.t(S):
		if not J.t(J.gp(S, "legend")): J.sp(S, "legend", {})
		var Lg = J.gp(S, "legend"); var lk = J.key(loc)
		if not J.t(J.gp(Lg, lk)): J.sp(Lg, lk, {"heat": 0.0, "nights": 0.0})
		var d = J.gp(Lg, lk); J.sp(d, "heat", n_(J.gp(d, "heat")) + heat); J.sp(d, "nights", n_(J.gp(d, "nights")) + 1)
	var after = legend(loc); var up = after.lv > before.lv
	var ghosts = J.iter(J.gp(Sc, "team")).duplicate() if J.t(J.gp(Sc, "team")) else []; var perGhost = {}
	for k in N.per: perGhost[k] = {"scares": N.per[k].scares, "fear": jround(n_(N.per[k].fear))}
	J.S_window_("dispatchEvent", [J.new_("CustomEvent", ["gb:nightEnd", {"detail": {"loc": loc, "score": J.gp(Sc, "kpi"), "stars": stars, "heat": heat, "legendLv": after.lv, "ghosts": ghosts, "perGhost": perGhost, "exposed": n_(N.seen) > 0, "exorcised": J.t(J.gp(Sc, "expelled")), "bryanStole": N.stole}}])])
	var b = N.best; var SG = _g("SCARE_GHOSTS")
	var who = b.name if J.t(b) else Lx("一個 OT 員工"); var room = b.room if J.t(b) and J.t(b.room) else Lx("二十三樓")
	var trick = J.gp(J.gp(SG, b.ghost), "skill") if J.t(b) and J.t(J.gp(SG, b.ghost)) else ""
	var views = jround((n_(after.heat) + 20) * (3 + after.lv * 4)) / 10
	var P = [
		["ApaKhabar・公司 OT 群", "{who}話喺{room}見到嘢，冇人信佢（笑）", "三個人已讀"],
		["連登・靈異台", "【真人真事】我公司二十三樓半夜{trick}", "{v} 千人睇過"],
		["Threads・熱門", "#二十三樓有鬼　{who}嘅反應笑死，但係……後面嗰個係咩？", "{v} 萬瀏覽"],
		["晚間新聞", "【獨家】商廈二十三樓夜半怪事頻生　員工：「{trick}，唔係講笑」", "記者現場直擊"],
		["全城熱話", "旅行團排隊參觀「二十三樓」，陳總：「門票收一百蚊」", "{v} 萬人討論"],
	][int(after.lv) - 1]
	var fill = func(s): return Lf(s, {"who": who, "room": room, "trick": trick if J.t(trick) else Lx("有怪聲"), "v": views})
	var ex = [Lf("無人信佢 ×{n}", {"n": N.nb}) if J.t(N.nb) else "", Lf("落單爆點 ×{n}", {"n": N.alone}) if J.t(N.alone) else "", Lf("招式 {n} 種", {"n": tsz}) if tsz else "", Lf("穿崩 ×{n}", {"n": N.seen}) if J.t(N.seen) else J.str(Lx("冇穿崩")),
		J.str(Lx("嚇到靈探 KOL")) if J.t(N.inf) else "", J.str(Lx("俾 KOL 拍到")) if J.t(N.filmed) else "", Lf("Bryan 搶咗 {n} 次", {"n": N.stole}) if J.t(N.stole) else "", J.str(Lx("Bryan 穿崩走佬")) if J.t(N.bryanOut) else ""]
	var ex2 = PackedStringArray()
	for s in ex: if s != "": ex2.append(s)
	var extra = "・".join(ex2)
	var pct = jround((n_(after.heat) - n_(after.prev)) / (n_(after.next) - n_(after.prev)) * 100) if after.next != null else 100.0
	var upt = ""
	if up: upt = "<p class=\"scl-up\">%s%s</p>" % [J.str(Lx("傳說升級！")), J.str(Lx(LVTWIST[int(after.lv) - 1])) if LVTWIST[int(after.lv) - 1] != null else ""]
	return "<div class=\"sc-legend\"><div class=\"scl-h\"><b>%s　Lv%s「%s」</b><span>%s +%s</span></div>\n      <div class=\"scl-bar\"><i style=\"width:%s%%\"></i></div>%s\n      <div class=\"scl-post\"><small>%s</small><p>%s</p><small>%s</small></div><p class=\"scl-x\">%s</p></div>" % [
		J.str(Lx("都市傳說")), J.str(after.lv), J.str(after.name), J.str(Lx("熱度")), J.str(heat), J.str(pct), upt, J.str(Lx(P[0])), fill.call(P[1]), fill.call(P[2]), extra]

# ---------- 揀隊（原生畫面接唔到先用 HTML） ----------
static func open(siteId) -> void:
	var nh = _g("__nat_scSel")
	if nh != null and J.t(J.cl(nh, null, [siteId])): return
	var Scare = _g("Scare"); J.mc(Scare, "migrate", [])
	var site = J.gp(_g("SCARE_SITES"), siteId); var opts = owned(); var chosen = sq_get().duplicate()
	var nps = []
	for d in J.iter(J.gp(site, "npcs")): if not J.t(J.gp(d, "guard")): nps.append(d)
	var weakCount = func(t):
		var c = 0
		for d in nps: if J.iter(J.gp(d, "weak")).has(t): c += 1
		return c
	var immCount = func(t):
		var c = 0
		for d in nps: if J.iter(J.gp(d, "immune")).has(t): c += 1
		return c
	var FW = _g("FEAR_WORD"); var SG = _g("SCARE_GHOSTS"); var GP = _g("GP")
	var render = func() -> String:
		var S = S_()
		var sc0 = J.gp(S, "scare"); var best = J.gp(J.gp(sc0, "best"), siteId) if J.t(sc0) else null; best = best if J.t(best) else 0.0
		var st = int(n_(J.mc(Scare, "starsOf", [siteId, best]))); var lg = legend(siteId)
		var h = "<p class=\"desc\">%s。%s</p>" % [J.str(J.gp(site, "name")), Lf("揀今晚帶邊幾隻鬼：招式啱佢哋怕嘅嘢，先嚇得到人。阿福一定去，另外最多帶{n}隻。", {"n": CN[int(max_sq())]})]
		h += "<p class=\"desc\">最高紀錄：%s　%s%s　｜　%s Lv%s「%s」</p>" % [J.str(best), "★".repeat(st), "☆".repeat(3 - st), J.str(Lx("都市傳說")), J.str(lg.lv), J.str(lg.name)]
		var who = PackedStringArray()
		for d in nps:
			var ws = PackedStringArray()
			for t in J.iter(J.gp(d, "weak")):
				var hide = J.iter(J.gp(d, "hide")) if J.t(J.gp(d, "hide")) else []
				var kn = J.gp(J.gp(Scare, "known") if J.t(J.gp(Scare, "known")) else {}, J.gp(d, "k"))
				ws.append("？" if hide.has(t) and not J.t(J.mc(kn if J.t(kn) else new_set(), "has", [t])) else J.str(J.gp(FW, t)))
			who.append("<span><b>%s</b> 怕 %s</span>" % [J.str(J.gp(d, "name")), "、".join(ws)])
		h += "<div class=\"sq-who\">%s</div>" % "".join(who)
		var card = func(k, fixed: bool) -> String:
			var g = J.gp(SG, k); var ts = J.iter(J.gp(g, "types")) if J.t(J.gp(g, "types")) else [J.gp(g, "type")]
			var w = 0
			for t in ts: w += weakCount.call(t)
			var im = w == 0
			for t in ts: if immCount.call(t) <= 0: im = false
			var pw = J.mc(GP, "pow", [J.mc(J.iter(J.gp(S, "ghosts")), "find", [func(_t, a): return J.str(J.gp(a[0], "k")) == "afu"])]) if J.str(k) == "afu" else J.mc(GP, "kindPow", [k])
			var tw = PackedStringArray()
			for t in ts: tw.append(J.str(J.gp(FW, t)))
			var cost = J.gp(g, "cost")
			return "<button class=\"sq-g %s %s\" data-k=\"%s\" %s><canvas data-por=\"%s\"></canvas><b>%s</b><small>%s</small><small class=\"gp-sub\">%s %s<br>%s ×%s</small><i>%s%s・%s</i>%s</button>" % [
				"on" if fixed or chosen.has(k) else "", "good" if w >= 2 else ("bad" if im else ""), J.str(k), "disabled" if fixed else "", J.str(k), J.str(J.gp(g, "name")), J.str(J.gp(g, "skill")),
				J.str(Lx("鬼力")), J.str(pw), J.str(Lx("驚嚇")), "%.2f" % (1 + 0.35 * (n_(J.mc(Scare, "gpq", [k])) - 1)), "／".join(tw), "・全場" if J.t(J.gp(g, "aoe")) else "", J.str(cost if J.t(cost) else 35.0), "<em>%d人怕</em>" % w if w else ""]
		var cards = card.call("afu", true)
		for k in opts: cards += card.call(k, false)
		h += "<div class=\"sq-grid\">%s</div>" % cards
		var nm = PackedStringArray()
		for k in chosen: nm.append(J.str(J.gp(J.gp(SG, k), "name")))
		var RW = _g("Rework")
		h += "<p class=\"desc\">%s %d/%s：%s</p>%s<button class=\"btn gold wide\" id=\"sc-go\">出發，回陽間</button>" % [J.str(Lx("已揀")), chosen.size(), J.str(max_sq()), "、".join(nm) if nm.size() else "—", J.str(J.mc(RW, "kitHTML", [])) if RW != null else ""]
		return h
	var Q = func(sel): return J.cl(_g("$"), null, [sel])
	var bind = [null]
	bind[0] = func():
		J.cl(_g("paintPortraits"), null, [Q.call("#sheet")])
		var RW = _g("Rework")
		if RW != null: J.mc(RW, "bindKit", [Q.call("#sheet")])
		for b in J.iter(J.mc(Q.call("#sheet"), "querySelectorAll", [".sq-g:not([disabled])"])):
			var bb = b
			J.sp(bb, "onclick", func(_t = null, _a = null):
				var k = J.gp(J.gp(bb, "dataset"), "k")
				if chosen.has(k): chosen.remove_at(chosen.find(k))
				elif chosen.size() < max_sq(): chosen.append(k)
				else: J.mc(_g("Fx"), "toast", [Lf("最多帶{n}隻", {"n": CN[int(max_sq())]})]); return null
				var body = Q.call("#sheet .sh-body"); var scv = J.gp(body, "scrollTop"); J.sp(body, "innerHTML", render.call()); J.sp(body, "scrollTop", scv); bind[0].call()
				return null)
		J.sp(Q.call("#sc-go"), "onclick", func(_t = null, _a = null):
			sq_set(chosen); J.mc(_g("UI"), "close", []); J.mc(Scare, "start", [siteId, ["afu"] + sq_get()]); return null)
	J.mc(_g("UI"), "sheet", ["回陽間・帶隊出更", render.call()]); bind[0].call()

func run(_env) -> void:
	var D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/scare_squad.json"))
	var LANG = _g("LANG")
	if LANG != null:
		for p in D.lang: if p[1] != null and p[1] != "": J.mc(LANG, "add", [{p[0]: p[1]}])
	SIG = D.SIG
	var SG = _g("SCARE_GHOSTS"); var N30 = _g("N30_G"); var FOD = _g("FODDER"); var GH = _g("GHOSTS")
	for k in SIG:
		var e = SIG[k]; var ty = J.str(e[0]); var aoe = e.size() > 6 and J.t(e[6]); var types = ty.split("|")
		var tier = 2
		if k.begins_with("n30_") and N30 != null and J.t(J.gp(N30, k)): tier = int(n_(J.gp(J.gp(N30, k), "t")))
		elif FOD != null and J.gp(FOD, k) != null: tier = 0
		var bc = TIERV[tier] if tier else [26.0, 28.0]
		var name = J.gp(J.gp(GH, k), "name") if GH != null and J.t(J.gp(GH, k)) and J.t(J.gp(J.gp(GH, k), "name")) else (J.gp(J.gp(FOD, k), "name") if FOD != null and J.t(J.gp(FOD, k)) and J.t(J.gp(J.gp(FOD, k), "name")) else k)
		J.sp(SG, k, {"name": name, "skill": e[3], "type": types[0], "types": Array(types) if types.size() > 1 else null, "base": 15.0 if aoe else bc[0], "cost": 34.0 if aoe else bc[1], "line": e[4], "aoe": aoe, "fx": e[1], "col": e[2], "fxText": e[3]})
	squad = {"options": func(_t = null, _a = null): return owned(), "get": func(_t = null, _a = null): return sq_get(), "set": func(_t, a): return sq_set(J.arg(a, 0)),
		"team": func(_t = null, _a = null): return ["afu"] + sq_get()}
	var Scare = _g("Scare")
	if Scare != null: J.sp(Scare, "squad", squad); J.sp(Scare, "legend", func(_t, a): return legend(J.arg(a, 0)))
	var X = {
		"_n": {"owned": func(_t = null, _a = null): return owned(), "maxSq": func(_t = null, _a = null): return max_sq(), "CN": CN},
		"SIG": SIG,
		"open": func(_t, a): open(J.arg(a, 0)); return null,
		"night": func(_t, a): night(J.arg(a, 0)); return null,
		"tick": func(_t, a): tick(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"onHit": func(_t, a): on_hit(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"draw": func(_t, a): draw(J.arg(a, 0), a[1], J.num(J.arg(a, 2))); return null,
		"sigFx": func(_t, a): sig_fx(J.arg(a, 0), a[1], J.arg(a, 2), J.num(J.arg(a, 3)), J.num(J.arg(a, 4))); return null,
		"finish": func(_t, a): return finish(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"legend": func(_t, a): return legend(J.arg(a, 0)),
		"squad": squad,
		"KOL": func(_t, a): return KOL(J.arg(a, 0)),
	}
	J.G["ScareX"] = X
	var w = _g("window")
	if w != null: J.sp(w, "ScareX", X)
