# 原生改寫自 rework.js（嚇法相剋、嚇功、舊地盤、回陽間供品／道具箱，接駁戰鬥同回陽間）
# 介面同轉譯版一樣：J.G["Rework"]；init() 照包 Battle.hit／start／finish、Scare.start／useGhost／useProp
extends RefCounted

const DAY := 864e5
const HOUR := 36e5
const W := {"breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
const TYPES := ["breath", "light", "cold", "sound", "paper", "phone", "face", "shadow"]
const EFEAR := {
	"youhun": {"w": ["light", "sound"], "i": ["breath"], "why": "飄慣了，吹氣嚇不到"},
	"egui": {"w": ["face", "cold"], "i": ["sound"], "why": "肚子叫得比你還大聲"},
	"xiaogui": {"w": ["shadow", "sound"], "i": ["face"], "why": "自己最愛扮鬼臉"},
	"zombie": {"w": ["light", "breath"], "i": ["cold"], "why": "屍體本來就是凍的"},
	"shuigui": {"w": ["light", "paper"], "i": ["cold"], "why": "泡在水裡泡慣了"},
	"zhiren": {"w": ["light", "breath"], "i": ["paper"], "why": "自己就是紙"},
	"niutou": {"w": ["phone", "paper"], "i": ["face"], "why": "自己個樣已經夠嚇人"},
	"mamian": {"w": ["phone", "sound"], "i": ["face"], "why": "自己個樣已經夠嚇人"},
	"eguiking": {"w": ["face", "shadow"], "i": ["sound"], "why": "肚子打鼓打了五百年"},
	"toyol": {"w": ["light", "face"], "i": ["sound"], "why": "偷錢從來不怕聲響"},
	"laojiang": {"w": ["light", "breath"], "i": ["cold"], "why": "躺了兩百年棺材"},
	"pontianak": {"w": ["phone", "light"], "i": ["sound"], "why": "笑聲是她的專利"},
	"pocong": {"w": ["shadow", "paper"], "i": ["breath"], "why": "包得密密實實"},
	"penanggal": {"w": ["light", "cold"], "i": ["face"], "why": "飛頭比你更嚇人"},
	"baiwu": {"w": ["phone", "paper"], "i": ["face"], "why": "舌頭比你長"},
	"heiwu": {"w": ["phone", "light"], "i": ["sound"], "why": "整天拖鐵鏈"},
	"huang": {"w": ["phone", "paper"], "i": ["face"], "why": "最怕電話響和新文件"},
}
const DRILL := [0, 300, 1000, 2500, 5000]
const KITS := {
	"offer": {"name": "供品", "cost": {"buns": 40.0}, "desc": "開局陰氣 +30"},
	"props": {"name": "道具箱", "cost": {"planks": 60.0}, "desc": "機關冷卻減半"},
}
static var GANGS: Array = []
static var cache := {}
static var started := false
static var R: Dictionary = {}

static func _g(n: String): return J.G.get(n)
static func _S() -> Dictionary: var s = _g("S"); return s if s is Dictionary else {}
static func D(yue: String, zh: String) -> String:
	var LANG = _g("LANG")
	if LANG != null: J.mc(LANG, "add", [{yue: zh}])
	return yue
static func toast(msg: String) -> void:
	var Fx = _g("Fx")
	if Fx != null: J.mc(Fx, "toast", [msg])

# ---------- 敵鬼的怕／唔怕 ----------
static func hash32(s: String) -> int:
	var h := 2166136261
	for i in s.length():
		h = (h ^ s.unicode_at(i)) & 0xFFFFFFFF
		h = (h * 16777619) & 0xFFFFFFFF
	return h

static func types_of(k):
	var SG = _g("SCARE_GHOSTS")
	if not (SG is Dictionary): return null
	var g = SG.get(J.str(k))
	if not (g is Dictionary): return null
	return g.types if J.t(g.get("types")) else [g.get("type")]

static func fear_of(k) -> Dictionary:
	var ks = J.str(k)
	if EFEAR.has(ks): return EFEAR[ks]
	if cache.has(ks): return cache[ks]
	var h = hash32(ks)
	var own = types_of(ks)
	if own == null: own = [TYPES[h % 8]]
	var rest = []
	for t in TYPES: if not own.has(t): rest.append(t)
	var a = rest[h % rest.size()]
	var r2 = []
	for t in rest: if t != a: r2.append(t)
	var b = r2[(h >> 8) % r2.size()]
	cache[ks] = {"w": [a, b], "i": own.slice(0, 1), "why": "自己識玩的把戲不怕"}
	return cache[ks]

static func word(t) -> String: return W.get(J.str(t), J.str(t))
static func _words(a: Array, sep: String) -> String:
	var o = []
	for t in a: o.append(word(t))
	return sep.join(o)
static func fear_line(k) -> String:
	var f = fear_of(k)
	return "怕%s　不怕%s" % [_words(f.w, "、"), _words(f.i, "、")]
static func enemy_hint(en) -> String:
	var seen = []
	for e in J.iter(en): if not seen.has(e): seen.append(e)
	var ET = _g("ENEMY_T"); var out = ""
	for e in seen:
		var nm = J.str(ET[e][2]) if ET is Dictionary and ET.get(e) != null else J.str(e)
		out += "<span class=\"rw-ef\"><b>%s</b> %s</span>" % [nm, fear_line(e)]
	return out
static func team_hint(g) -> String:
	var ts = types_of(g.get("k"))
	return ("嚇法：%s　嚇功 Lv%d" % [_words(ts, "／"), drill_lv(g.get("k"))]) if J.t(ts) else ""

# ---------- 嚇功 ----------
static func drill_xp(k) -> float:
	var S = _S()
	if S.get("drill") is Dictionary and J.t(S.drill.get(J.str(k))): return J.num(S.drill[J.str(k)])
	return 0.0
static func drill_lv(k) -> int:
	var x = drill_xp(k); var lv = 1
	while lv < 5 and x >= DRILL[lv]: lv += 1
	return lv
static func drill_next(k):
	var lv = drill_lv(k)
	return float(DRILL[lv]) if lv < 5 else null

# ---------- 地盤 ----------
static func turf() -> Dictionary:
	var S = _S()
	if not J.t(S.get("turf")): S["turf"] = {"lost": {}, "gang": {}, "next": 0.0, "day": null, "gain": 0.0}
	var t = S.turf
	if not J.t(t.get("lost")): t["lost"] = {}
	if not J.t(t.get("gang")): t["gang"] = {}
	return t
static func all_sids() -> Array:
	var a = []; var ci = 0
	for ch in _g("CHAPTERS"):
		var si = 0
		for _st in ch.stages: a.append("%d-%d" % [ci + 1, si + 1]); si += 1
		ci += 1
	return a
static func stage_of(sid):
	var p = J.str(sid).split("-"); var C = _g("CHAPTERS")
	var c = int(p[0]) if p.size() > 0 else 0; var s = int(p[1]) if p.size() > 1 else 0
	if c - 1 < 0 or c - 1 >= C.size(): return null
	var stg = C[c - 1].stages
	return stg[s - 1] if s - 1 >= 0 and s - 1 < stg.size() else null
static func held() -> Array:
	var t = turf(); var S = _S(); var o = []
	for s in all_sids():
		if S.get("cleared") is Dictionary and J.t(S.cleared.get(s)) and not J.t(t.lost.get(s)): o.append(s)
	return o
static func is_lost(sid) -> bool: return J.t(turf().lost.get(J.str(sid)))
static func clock() -> float:
	var P = _g("Presence"); var S = _S()
	if P != null and J.t(P.get("st")) and J.t(S.get("presence")): return J.now() + J.num(S.presence.get("skew")) if J.t(S.presence.get("skew")) else J.now()
	return J.now()
static func gday(ms: float) -> float:
	var tz = Time.get_time_zone_from_system().get("bias", 0)
	return floor((ms - (-tz) * 60000.0) / DAY)

static func turf_tick() -> void:
	var S = _S()
	if S.is_empty() or not J.t(S.get("cleared")): return
	var t = turf(); var now = clock(); var h = held()
	if _g("Station") != null: t["lost"] = {}; t["gang"] = {}; return
	var today = gday(now)
	if t.get("day") == null: t["day"] = today
	if today > J.num(t.day):
		var days = minf(7, today - J.num(t.day)); t["day"] = today
		var kpi = minf(8, floor(h.size() / 3.0)) * days; var pres = minf(6, h.size() * 0.4) * days
		if kpi != 0 or pres != 0:
			if J.t(S.get("contract")) and J.str(S.contract.get("state")) == "active" and kpi != 0: S.contract["kpi"] = J.num(S.contract.kpi) + kpi
			var P = _g("Presence")
			if P != null and pres != 0:
				for g in S.ghosts: if J.str(g.k) != "afu": J.mc(P, "add", [g, pres])
			t["gain"] = kpi
			toast("地盤收租：%d 個地盤%s，全村存在感 +%d" % [h.size(), ("，合約 KPI +%s" % J.str(kpi)) if kpi != 0 else "", int(round(pres))])
	if not J.t(t.get("next")): t["next"] = now + (8 + randf() * 6) * HOUR
	if now >= J.num(t.next):
		t["next"] = now + (8 + randf() * 6) * HOUR
		var lost_n = t.lost.size()
		if h.size() >= 3 and lost_n < 2 and J.num(S.lv) >= 6:
			var pool = []
			for s in h:
				var st = stage_of(s)
				if not J.t(st.get("boss")): pool.append(s)
			if pool.size() > 0:
				var sid = pool[int(floor(randf() * pool.size()))]
				var gi = int(floor(randf() * GANGS.size())); t.lost[sid] = now; t.gang[sid] = float(gi)
				toast("<b>%s</b> 被%s搶走了！到「地盤」奪回。" % [J.str(stage_of(sid).name), GANGS[gi].name])

static func turf_tag(sid) -> String:
	var S = _S(); var s = J.str(sid)
	if not (S.get("cleared") is Dictionary) or not J.t(S.cleared.get(s)) or _g("Station") != null: return ""
	var t = turf()
	if J.t(t.lost.get(s)): return "<em class=\"rw-lost\">被%s搶走</em>" % GANGS[int(J.num(t.gang.get(s)))].name
	return "<em class=\"rw-own\">我方地盤</em>"

static func turf_head() -> String:
	var t = turf(); var h = held()
	var s = "<div class=\"rw-turf\"><b>陽間地盤 %d</b><small>每日收租：合約 KPI +%d，全村存在感 +%d。打下一關就多一個地盤；鄰村鬼幫會不時來搶。</small>" % [h.size(), mini(8, h.size() / 3), int(round(minf(6, h.size() * 0.4)))]
	var Lf = _g("L")
	for sid in t.lost:
		var g = GANGS[int(J.num(t.gang.get(sid)))]
		var line = J.str(J.cl(Lf, null, [g.line])) if Lf != null else g.line
		s += "<p class=\"rw-raid\">⚑ <b>%s</b>（%s）被%s搶走：<br><i>%s</i></p>" % [J.str(stage_of(sid).name), sid, g.name, line]
	return s + "</div>"

static func retake(sid) -> void:
	var t = turf(); var s = J.str(sid); var S = _S()
	if not J.t(t.lost.get(s)): return
	t.lost.erase(s); t.gang.erase(s)
	var kp = 0
	if J.t(S.get("contract")) and J.str(S.contract.get("state")) == "active": S.contract["kpi"] = J.num(S.contract.kpi) + 4; kp = 4
	var P = _g("Presence")
	if P != null:
		for id in S.team:
			var g = J.cl(_g("ghostById"), null, [id])
			if J.t(g): J.mc(P, "add", [g, 6.0])
	toast("奪回地盤：<b>%s</b>%s，出陣的鬼存在感 +6" % [J.str(stage_of(s).name), ("　合約 KPI +%d" % kp) if kp else ""])

# ---------- 回陽間的供品與道具 ----------
static func kit_html() -> String:
	var S = _S()
	if not J.t(S.get("scareKit")): S["scareKit"] = {}
	var o = ""
	for k in KITS:
		var K = KITS[k]; var on = J.t(S.scareKit.get(k)); var ok = J.t(J.cl(_g("canPay"), null, [K.cost]))
		o += "<button class=\"rw-kb %s %s\" data-kit=\"%s\"><b>%s</b><small>%s</small><i>%s</i></button>" % ["on" if on else "", "" if ok else "dim", k, K.name, J.str(J.cl(_g("costText"), null, [K.cost])), K.desc]
	return "<div class=\"rw-kit\"><p class=\"desc\"><b>帶上村裡的產出</b>（出發時扣）：</p>%s</div>" % o
static func bind_kit(root) -> void:
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-kit]"])):
		var bb = b
		J.sp(bb, "onclick", func(_t, _a):
			var k = J.str(J.gp(J.gp(bb, "dataset"), "kit")); var S = _S()
			if not J.t(S.get("scareKit")): S["scareKit"] = {}
			if not J.t(S.scareKit.get(k)) and not J.t(J.cl(_g("canPay"), null, [KITS[k].cost])): toast("材料不夠"); return null
			S.scareKit[k] = not J.t(S.scareKit.get(k))
			J.mc(J.gp(bb, "classList"), "toggle", ["on", S.scareKit[k]])
			J.cl(_g("save"), null, [])
			return null)

# ---------- 接駁 ----------
static func init() -> void:
	if started: return
	started = true
	var Battle = _g("Battle"); var Scare = _g("Scare")
	var oh = Battle.hit
	Battle["hit"] = func(this_, a):
		var src = J.arg(a, 0); var v = J.arg(a, 1); var mult = J.num(J.arg(a, 2)); var sk = J.arg(a, 3)
		if not J.t(sk) or not J.t(src) or J.num(src.get("side")) != 0 or not J.t(v) or J.num(v.get("side")) != 1 or J.str(sk.get("kind")) == "heal" or J.t(src.get("minion")): return J.cl(oh, this_, a)
		var ts = types_of(src.k)
		if ts == null: return J.cl(oh, this_, a)
		var f = fear_of(v.k)
		var t = null
		for x in ts: if f.w.has(x): t = x; break
		if t == null:
			for x in ts: if not f.i.has(x): t = x; break
		if t == null: t = ts[0]
		var m = mult * (1 + 0.05 * (drill_lv(src.k) - 1)); var tag = null; var col = "#e8d0ff"; var chain = false
		var bt = J.num(J.gp(this_, "t"))
		var marked = J.t(v.get("fearT")) and J.num(v.fearT.until) > bt
		if f.i.has(t): m *= 0.6; tag = "不怕" + word(t); col = "#9aa"
		elif f.w.has(t):
			m *= 1.35
			if marked and v.fearT.t != t: m *= 1.8; chain = true; tag = "%s＋%s・連嚇" % [word(v.fearT.t), word(t)]; col = "#ffd84a"
			else: tag = "怕%s・失神" % word(t)
			v["fearT"] = {"t": t, "until": bt + 3.2}
		elif marked and v.fearT.t != t: m *= 1.3; tag = "追嚇"; col = "#ffe8a0"
		var dmg = J.cl(oh, this_, [src, v, m, sk])
		if tag != null and v.get("x") != null:
			J.mc(J.gp(this_, "fx"), "push", [{"x": v.x, "y": J.num(J.mc(this_, "uy", [v])) - 100 * J.num(J.mc(this_, "scaleOf", [v])), "text": tag, "col": col, "t": 0.0, "life": 1.1}])
		if chain:
			J.mc(_g("Sound"), "play", ["combo", J.gp(this_, "combo")])
			J.sp(this_, "combo", J.num(J.gp(this_, "combo")) + 1 if J.num(J.gp(this_, "comboT")) > 0 else 1.0)
			J.sp(this_, "comboT", 3.0); J.sp(this_, "comboPop", 1.0)
			var H = J.gp(this_, "H")
			J.mc(J.gp(this_, "fx"), "push", [{"x": 195.0, "y": (J.num(H) if J.t(H) else 640.0) * 0.3, "text": "連嚇 ×%s！" % J.str(J.num(J.gp(this_, "combo")) + 1), "col": "#ffd84a", "t": 0.0, "life": 1.2, "center": true}])
		return dmg
	var os = Battle.start
	Battle["start"] = func(this_, a):
		var r = J.cl(os, this_, a)
		var wild = J.arg(a, 2)
		var rt = not J.t(wild) and is_lost(J.gp(this_, "sid"))
		J.sp(this_, "retake", rt)
		if rt:
			for u in J.iter(J.gp(this_, "units")):
				if J.num(u.get("side")) == 1: u["hp"] = J.num(u.hp) * 1.15; u["maxhp"] = J.num(u.maxhp) * 1.15; u["atk"] = J.num(u.atk) * 1.1
			var tt = J.cl(_g("$"), null, ["#b-title"])
			if tt != null: J.sp(tt, "textContent", "奪回地盤　" + J.str(J.gp(J.gp(this_, "stage"), "name")))
		return r
	var of_ = Battle.finish
	Battle["finish"] = func(this_, a):
		var was = not J.t(J.gp(this_, "result")); var rt = J.t(J.gp(this_, "retake")); var sid = J.gp(this_, "sid")
		var r = J.cl(of_, this_, a)
		if was and J.t(J.arg(a, 0)) and rt: retake(sid)
		J.sp(this_, "retake", false)
		return r
	var ostart = Scare.start
	Scare["start"] = func(this_, a):
		var team = J.arg(a, 1); var headless = J.arg(a, 2); var S = _S()
		var kit = {}
		if not J.t(headless) and J.t(S.get("scareKit")):
			for k in S.scareKit:
				if J.t(S.scareKit[k]) and J.t(J.cl(_g("canPay"), null, [KITS[k].cost])): J.cl(_g("pay"), null, [KITS[k].cost]); kit[k] = true
		J.sp(this_, "kit", kit)
		var r = J.cl(ostart, this_, a)
		if not J.t(headless):
			var dr = {}
			for k in J.iter(team): dr[k] = float(drill_lv(k))
			J.sp(this_, "_drill", dr)
		if kit.get("offer"): J.sp(this_, "mana", J.num(J.gp(this_, "mana")) + 30)
		if kit.size() > 0:
			J.cl(_g("save"), null, [])
			var names = []
			for k in kit: names.append(KITS[k].name)
			J.mc(this_, "toast", ["帶上：" + "、".join(names)])
		return r
	var oug = Scare.useGhost
	Scare["useGhost"] = func(this_, a):
		var k = J.str(J.arg(a, 0)); var SG = _g("SCARE_GHOSTS"); var g = SG.get(k) if SG is Dictionary else null
		var dr = J.gp(this_, "_drill")
		var lv = J.num(J.gp(dr, k)) if J.t(dr) and J.t(J.gp(dr, k)) else 1.0
		if not J.t(g) or lv <= 1: return J.cl(oug, this_, a)
		var b = g.get("base"); var c = g.get("cost")
		g["base"] = round(J.num(b) * (1 + 0.1 * (lv - 1))); g["cost"] = maxf(18, (J.num(c) if J.t(c) else 35.0) - 2 * (lv - 1))
		var r = J.cl(oug, this_, a)
		g["base"] = b; g["cost"] = c
		return r
	var oup = Scare.useProp
	Scare["useProp"] = func(this_, a):
		var k = J.arg(a, 0); var pcd = J.gp(this_, "pcd")
		var before = J.gp(pcd, k) if J.t(pcd) else null
		var r = J.cl(oup, this_, a)
		pcd = J.gp(this_, "pcd"); var kit = J.gp(this_, "kit")
		if J.t(kit) and J.t(J.gp(kit, "props")) and J.t(pcd) and J.num(J.gp(pcd, k)) > 0 and J.gp(pcd, k) != before: J.sp(pcd, k, J.num(J.gp(pcd, k)) * 0.5)
		return r
	J.F_setInterval([func(_t, _a): turf_tick(); return null, 5000.0])
	turf_tick()

static func _boot() -> void:
	var S = _g("S"); var B = _g("Battle"); var Sc = _g("Scare")
	if not J.t(S) or B == null or B.get("hit") == null or Sc == null:
		J.F_setTimeout([func(_t, _a): _boot(); return null, 300.0]); return
	init()

func run(_env) -> void:
	started = false; cache.clear()
	GANGS = [
		{"name": "鄰村・夜冷村", "boss": "Bryan", "line": D("Bryan：「呢度？我哋夜冷村接手喇。你慢慢跑，我哋慢慢嚇。」", "Bryan：「這裡？我們夜冷村接手了。你慢慢跑，我們慢慢嚇。」")},
		{"name": "鄰村・夜冷村", "boss": "Bryan", "line": D("Bryan：「你嗰度啲人怕咩，我全部抄低咗。多謝分享。」", "Bryan：「你那邊的人怕什麼，我全部抄下來了。謝謝分享。」")},
		{"name": "無牌鬼幫", "boss": "", "line": D("一班無牌鬼插咗支旗：「呢度而家我哋話事，KPI 我哋計。」", "一群無牌鬼插了一支旗：「這裡現在我們說了算，KPI 我們來算。」")},
		{"name": "過江鬼聯盟", "boss": "", "line": D("一群過江鬼：「我哋喺第二區冇人驚，過嚟借你地方用下。」", "一群過江鬼：「我們在別區沒人怕，過來借你的地方用一下。」")},
	]
	R = {
		"W": W.duplicate(), "TYPES": TYPES.duplicate(), "DRILL": DRILL.duplicate(), "GANGS": GANGS, "KITS": KITS.duplicate(true),
		"word": func(_t, a): return word(J.arg(a, 0)),
		"fearOf": func(_t, a): return fear_of(J.arg(a, 0)),
		"fearLine": func(_t, a): return fear_line(J.arg(a, 0)),
		"enemyHint": func(_t, a): return enemy_hint(J.arg(a, 0)),
		"teamHint": func(_t, a): return team_hint(J.arg(a, 0)),
		"typesOf": func(_t, a): return types_of(J.arg(a, 0)),
		"drillXp": func(_t, a): return drill_xp(J.arg(a, 0)),
		"drillLv": func(_t, a): return float(drill_lv(J.arg(a, 0))),
		"drillNext": func(_t, a): return drill_next(J.arg(a, 0)),
		"turf": func(_t, _a): return turf(),
		"held": func(_t, _a): return held(),
		"isLost": func(_t, a): return is_lost(J.arg(a, 0)),
		"turfTag": func(_t, a): return turf_tag(J.arg(a, 0)),
		"turfHead": func(_t, _a): return turf_head(),
		"turfTick": func(_t, _a): turf_tick(); return null,
		"retake": func(_t, a): retake(J.arg(a, 0)); return null,
		"kitHTML": func(_t, _a): return kit_html(),
		"bindKit": func(_t, a): bind_kit(J.arg(a, 0)); return null,
		"stageOf": func(_t, a): return stage_of(J.arg(a, 0)),
	}
	J.G["Rework"] = R
	var w = J.G.get("window")
	if w != null: J.sp(w, "Rework", R)
	_boot()
