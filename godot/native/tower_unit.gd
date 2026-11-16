# 原生改寫自 tower.js 第二段：window.UnitSys（樓裡有鬼——入屋模式）
# 規則（入屋、住客作息、睇到鬼、警覺門檻、作怪點、直接嚇、搜嘢、屋內任務）＋室內畫面（drawN）＋觸控（__twUPD/UPM/UPU）＋大樓剖面「入屋」掣
# 隨機數：A.rnd（關卡種子）同 Math.random（對白洗牌；畫面嘅雪花、汗滴）用法、次序同轉譯版一樣
# 冇搬：自己嘅疊層 canvas（Godot 由 tw_run.gd 畫）、WebAudio（Godot 本身靜音）
# 注意：原碼 addRFear 嗰行 // 註解後面嘅 r.jumpT=0.5… 係註解，唔會行（照跟）
extends RefCounted

const LIMIT := 80.0
const BAN := 25.0
const REIN := 6.0
const SEE_LIT := 26.0
const SEE_DARK := 7.0
const RANGE_HOT := 130.0
const RANGE_SCARE := 150.0
const OMEN := 0.6
const HOT := {
	"lamp": {"v": "閃燈熄燈", "f": 14.0, "loud": 0.0, "ln": ["盞燈做咩閃吓閃吓……", "跳掣？黑麻麻咁……", "又停電？"]},
	"tv": {"v": "電視雪花", "f": 24.0, "loud": 1.0, "ln": ["部電視自己轉台？！", "雪花入面……好似有個人影", "我冇撳過遙控㗎！"]},
	"tap": {"v": "水喉自己開", "f": 20.0, "loud": 1.0, "ln": ["邊個開咗水喉？", "水喉自己嘩啦嘩啦咁流……"]},
	"fridge": {"v": "雪櫃門自己開", "f": 20.0, "loud": 0.0, "ln": ["雪櫃門自己彈開咗！", "點解成間屋咁凍……"]},
	"wardrobe": {"v": "衣櫃門自己開", "f": 24.0, "loud": 1.0, "ln": ["衣櫃門……自己慢慢打開……", "入面係咪有人匿埋？"]},
	"mirror": {"v": "鏡入面多個影", "f": 28.0, "loud": 0.0, "ln": ["面鏡……我後面有人？", "頭先鏡入面嗰個唔係我……"]},
	"pc": {"v": "電腦彈鬼臉", "f": 26.0, "loud": 1.0, "ln": ["個 mon 彈咗張臉出嚟！", "我隻角色自己行開咗？！"]},
	"fan": {"v": "風扇狂轉", "f": 18.0, "loud": 0.0, "ln": ["把風扇自己轉到咁大力？！", "啲窗簾吹到飛晒起……"]},
	"shower": {"v": "花灑自己開", "f": 22.0, "loud": 1.0, "ln": ["花灑自己開咗……", "冇人喺度，點解有水聲？"]},
	"radio": {"v": "收音機自己播", "f": 20.0, "loud": 1.0, "ln": ["收音機自己播粵曲……", "邊個開咗收音機？"]},
	"pots": {"v": "鑊鏟自己跌", "f": 22.0, "loud": 1.0, "ln": ["乒乓聲！鑊鏟自己跌落地！", "廚房咩聲呀？！"]},
	"net": {"v": "蚊帳自己郁", "f": 22.0, "loud": 0.0, "ln": ["蚊帳自己郁緊……", "冇風㗎喎，點解蚊帳會郁？"]},
	"jar": {"v": "水缸冒泡", "f": 20.0, "loud": 0.0, "ln": ["水缸咕嚕咕嚕咁冒泡……", "水缸入面……有嘢？"]},
}
const LN := {
	"see": ["嗰度……有嘢！", "頭先係咪有個影？", "邊個喺度？！", "我見到喇！唔好走！", "你……你係邊個？"],
	"lightOn": ["開燈先……", "咁黑，開咗盞燈先", "點解會跳掣嘅？開返先"],
	"go": ["咩聲嚟㗎？去睇睇", "我過去睇下……", "邊度傳嚟嘅聲？"],
	"look": ["冇嘢喎……", "係咪我聽錯？", "奇怪……明明有聲"],
	"wake": ["醒醒呀！屋企有嘢呀！", "起身呀，有怪聲呀！"],
	"phone": ["喂？管理處呀？我屋企有古怪，快啲上嚟！", "喂？保安呀？我哋呢層有嘢呀！"],
	"lights": ["開晒啲燈！開晒佢！", "全部燈開晒，睇佢仲點匿！"],
	"kick": ["出去呀！唔好再嚟！", "開晒燈大嗌：「唔該你出去！」"],
	"leave": ["返工喇，出門口先", "出去行下先"],
}
const WANT := {"gamer": [["pc", 6.0], ["fridge", 1.5], ["sofa", 1.5], ["wash", 1.0]], "ot": [["desk", 4.0], ["tv", 3.0], ["cook", 2.0], ["shower", 1.0]], "gym": [["sofa", 2.0], ["shower", 3.0], ["cook", 3.0], ["tv", 2.0]],
	"nurse": [["cook", 3.0], ["tv", 3.0], ["shower", 3.0], ["desk", 1.0]], "elder": [["radio", 5.0], ["cook", 2.0], ["wash", 1.0], ["desk", 2.0]], "insomnia": [["radio", 5.0], ["cook", 2.0], ["desk", 3.0]],
	"granny": [["tv", 6.0], ["cook", 3.0], ["wash", 1.0]], "couple": [["tv", 5.0], ["cook", 2.5], ["shower", 2.5]], "mahjong": [["table", 1.0]], "shopper": [["sofa", 5.0], ["desk", 2.0], ["cook", 3.0]],
	"taxi": [["tv", 6.0], ["cook", 2.0], ["shower", 2.0]], "cook": [["cook", 7.0], ["tv", 3.0]], "helper": [["cook", 4.0], ["sink", 3.0], ["shower", 1.0], ["wash", 2.0]], "debt": [["sofa", 6.0], ["desk", 4.0]]}
const ACTN := {"pc": "打機", "desk": "坐喺枱前", "sofa": "坐梳化", "tv": "睇電視", "radio": "聽收音機", "table": "打麻雀", "cook": "煮嘢食", "sink": "洗碗", "fridge": "搵嘢食", "shower": "沖涼", "wash": "洗面", "bed": "瞓覺"}
const TASK := {"gamer": {"k": "media"}, "ot": {"k": "steal", "o": "公司門卡", "at": "desk"}, "gym": {"k": "room", "room": "bath", "act": "shower"}, "nurse": {"k": "room", "room": "bath", "act": "shower"},
	"elder": {"k": "media"}, "insomnia": {"k": "media"}, "granny": {"k": "steal", "o": "葵扇", "at": "sofa"}, "couple": {"k": "allout"}, "mahjong": {"k": "steal", "o": "一隻麻雀牌", "at": "table"},
	"shopper": {"k": "steal", "o": "速遞包裹", "at": "door"}, "taxi": {"k": "media"}, "cook": {"k": "room", "room": "kitchen", "act": "cook"}, "helper": {"k": "steal", "o": "熨斗", "at": "cook"}, "debt": {"k": "steal", "o": "門口嗰封追數信", "at": "door"}}

var FB := {"img": null, "W": 1440.0, "H": 420.0, "crop": [20.0, 420.0], "floor": 396.0, "ceil": 40.0, "ph": 230.0, "door": 40.0, "fb": true,
	"rooms": [{"k": "living", "n": "客廳", "x0": 0.0, "x1": 360.0}, {"k": "kitchen", "n": "廚房", "x0": 360.0, "x1": 720.0}, {"k": "bed", "n": "睡房", "x0": 720.0, "x1": 1080.0}, {"k": "bath", "n": "廁所", "x0": 1080.0, "x1": 1440.0}],
	"spots": [{"k": "lamp", "x": 180.0, "y": 70.0}, {"k": "tv", "x": 300.0, "y": 270.0}, {"k": "fridge", "x": 640.0, "y": 270.0}, {"k": "tap", "x": 500.0, "y": 280.0}, {"k": "wardrobe", "x": 1000.0, "y": 260.0}, {"k": "mirror", "x": 1200.0, "y": 220.0}],
	"acts": {"sofa": {"x": 150.0, "pose": "sit", "look": "tv"}, "tv": {"x": 200.0, "pose": "sit", "look": "tv"}, "radio": {"x": 200.0, "pose": "sit", "look": "tv"}, "table": {"x": 180.0, "seats": [100.0, 150.0, 210.0, 260.0], "pose": "sit"}, "cook": {"x": 450.0, "look": "tap"}, "sink": {"x": 520.0, "look": "tap"}, "fridge": {"x": 610.0, "look": "fridge"}, "desk": {"x": 800.0, "pose": "sit", "look": "wardrobe"}, "pc": {"x": 800.0, "pose": "sit", "look": "wardrobe"}, "bed": {"x": 900.0, "pose": "lie", "lift": 60.0}, "shower": {"x": 1300.0}, "wash": {"x": 1200.0, "look": "mirror"}},
	"search": [{"x": 90.0, "y": 360.0, "n": "櫃桶"}, {"x": 560.0, "y": 340.0, "n": "碗櫃"}, {"x": 1040.0, "y": 360.0, "n": "衣櫃底"}, {"x": 1380.0, "y": 370.0, "n": "膠桶"}],
	"steal": {}}

var A
var U: Dictionary = {}
var S = null
var lastG = null
var lnUsed := {}
var vis_on := false
var c = null            # 而家畫緊嘅 Ctx
var W := 390.0
var H := 844.0
var DPR := 1.0
var BTN := []
var PRESS = null
var ptr = null
var last := 0.0

# ---------------- 工具 ----------------
func _a(k: String): return J.gp(A, k)
func G(): return _a("G")
func rnd() -> float:
	var r = _a("rnd")
	return J.num(J.cl(r, null, [])) if J.t(r) else randf()
func pick(a: Array): return a[int(floor(rnd() * a.size()))]
func img(k):
	if not J.t(k): return null
	var IM = _a("IMG"); var im = J.gp(IM, J.str(k)) if J.t(IM) else null
	return im if im != null and J.t(J.gp(im, "width")) else null
static func clamp_(v: float, a: float, b: float) -> float: return a if v < a else (b if v > b else v)
func wpick(a: Array):
	var t = 0.0
	for p in a: t += J.num(p[1])
	var r = rnd() * t
	for i in a.size():
		r -= J.num(a[i][1])
		if r <= 0: return a[i][0]
	return a[0][0]
static func isHH(un) -> bool: return J.t(un) and J.t(un.get("hh")) and J.str(un.get("ot")) != "deity" and J.t(un.get("rs"))
func iu(un) -> Dictionary:
	if not J.t(un.get("iu")):
		var T = TASK.get(J.str(un.hh), {"k": "allout"})
		un["iu"] = {"alert": 0.0, "leftT": 0.0, "ban": 0.0, "cd": 0.0, "task": T.duplicate(true), "done": false, "fled": 0.0, "visits": 0.0, "phoned": false}
	return un.iu
func roomAt(x: float) -> int:
	var R: Array = S.lay.rooms
	for i in R.size():
		if x >= J.num(R[i].x0) - 8 and x <= J.num(R[i].x1) + 8: return i
	return 0 if x < J.num(R[0].x0) else R.size() - 1
static func sayR(r, t) -> void:
	if not J.t(r): return
	r["say"] = t; r["sayT"] = 2.6
func msg(t: String, col = null) -> void:
	if S != null: S["msg"] = t; S["msgT"] = 3.2; S["msgC"] = col if J.t(col) else "#efdcb4"
func wfl(x: float, y: float, t: String, col = null) -> void:
	if S == null: return
	var yy = y
	for k in 4:
		var hit = false
		for f in S.floats: if absf(J.num(f.x) - x) < 140 and absf(J.num(f.y) - yy) < 30: hit = true; break
		if not hit: break
		yy -= 32
	S.floats.append({"x": x, "y": yy, "t": t, "c": col if J.t(col) else "#efe5cf", "life": 1.8})
	if S.floats.size() > 8: S.floats.pop_front()
func part(x: float, y: float, vx: float, vy: float, life: float, type: String) -> void:
	if S != null and S.parts.size() < 220: S.parts.append({"x": x, "y": y, "vx": vx, "vy": vy, "life": life, "max": life, "type": type})
func running() -> bool:
	var g0 = G()
	return J.str(_a("scene")) == "play" and J.t(g0) and not J.t(J.gp(g0, "over")) and not J.t(J.gp(g0, "choice")) and not J.t(J.gp(g0, "showStory")) and not J.t(J.gp(g0, "ult")) and not J.t(_a("paused"))
func visible() -> bool:
	var g0 = G()
	return S != null and J.str(_a("scene")) == "play" and J.t(g0) and not J.t(J.gp(g0, "over")) and not J.t(J.gp(g0, "choice")) and not J.t(J.gp(g0, "showStory"))
func line(k: String):
	var p: Array = LN[k]
	if not lnUsed.has(k) or (lnUsed[k] as Array).is_empty():
		var a = []
		for i in p.size(): a.append(i)
		var i = a.size() - 1
		while i > 0:
			var j = int(floor(randf() * (i + 1))); var t = a[i]; a[i] = a[j]; a[j] = t
			i -= 1
		lnUsed[k] = a
	return p[(lnUsed[k] as Array).pop_back()]
func LAYS():
	var L = J.gp(J.G.get("window"), "UNIT_LAYOUTS")
	return L if J.t(L) else {}
func layFor(un):
	var L = LAYS(); var LV = _a("LV")
	var k = "shop" if (J.t(LV) and J.str(J.gp(LV, "key")) == "shop") else ("gamer" if ["gamer", "ot", "gym"].has(J.str(un.get("hh"))) else "ppr")
	var l = J.gp(L, k)
	if not J.t(l): l = J.gp(L, "ppr")
	if J.t(l) and img(J.gp(l, "img")) != null: J.sp(l, "key", k); return l
	FB["key"] = "fb"; return FB
func _fn(k: String, args: Array):
	var f = _a(k)
	return J.cl(f, null, args) if J.t(f) else null
func _flt(x, y, t, col) -> void: _fn("float", [x, y, t, col])
func _node(id): return J.gp(J.gp(G(), "nodes"), J.str(id))

# ---------------- 入屋／出屋 ----------------
func enterable(g, un):
	if not isHH(un): return "no"
	var b = _fn("doorBlock", [g, un])
	if J.t(b): return b
	var I = iu(un)
	if J.num(I.ban) > 0: return "ban"
	if J.num(I.cd) > 0: return "cd"
	return true
static func _is_true(v) -> bool: return v is bool and v

func enterFromDoor(g, un) -> bool:
	var ok = enterable(g, un)
	if not _is_true(ok): blockedMsg(g, un, ok); return false
	J.sp(g, "to", null); J.sp(g, "auto", null); J.sp(g, "autoS", null); J.sp(g, "p", 0.0); J.sp(g, "node", un.id)
	var n = _node(un.id); J.sp(g, "x", J.gp(n, "x")); J.sp(g, "y", J.gp(n, "y")); _fn("onArrive", [g]); return S != null

func blockedMsg(g, un, why) -> void:
	var I = un.get("iu"); var w = J.str(why); var t
	if w == "deity": t = "呢度有神明鎮宅，要尊重，我哋唔入"
	elif w == "ban": t = "呢戶啱啱被趕出嚟，佢哋開晒燈，" + J.str(ceil(J.num(I.ban))) + " 秒後先好再入"
	elif w == "cd": t = "陰氣未回，" + J.str(ceil(J.num(I.cd))) + " 秒後先入得"
	else:
		var bm = J.gp(_a("BLOCKMSG"), w)
		t = bm if J.t(bm) else "呢戶未入得"
	_flt(un.x, J.num(un.y) - 96, t, "#ffd54a")
	if w == "deity" and J.t(J.gp(G(), "wardFx")): J.mc(J.gp(G(), "wardFx"), "push", [{"x": un.x, "y": un.y, "t": 0.9}])

func arrive_(g, n) -> bool:
	var g0 = G()
	if not J.t(g0) or S != null or J.num(J.gp(g, "i")) != J.num(J.gp(g0, "active")): return false
	var un = _fn("unitOf", [J.gp(n, "id")])
	if not isHH(un): return false
	var I = iu(un)
	if J.num(I.ban) > 0 or J.num(I.cd) > 0:
		J.sp(g, "node", un.did); var d = _node(un.did); J.sp(g, "x", J.gp(d, "x")); J.sp(g, "y", J.gp(d, "y")); J.sp(g, "to", null); J.sp(g, "auto", null)
		blockedMsg(g, un, "ban" if J.num(I.ban) > 0 else "cd"); return true
	open_(g, un); return true

func open_(g, un) -> void:
	var g0 = G(); var lay = layFor(un); var I = iu(un); I["visits"] = J.num(I.visits) + 1
	S = {"un": un, "g": g, "lay": lay, "t": 0.0, "limit": LIMIT, "gx": J.num(J.gp(lay, "door")) + 50, "gdir": 1.0, "gmv": 0.0, "still": 1.0, "goX": null, "pend": null, "joy": null, "sc": null, "scCd": 0.0, "invT": 0.0, "stun": 0.0,
		"alert": maxf(0.0, J.num(I.alert) - (J.num(J.gp(g0, "t")) - J.num(I.leftT)) * 1.0), "calmT": 0.0, "flags": {}, "actors": [], "spots": [], "search": [], "floats": [], "parts": [], "fx": [], "light": [], "dark": [], "cam": {"x": 0.0, "free": null},
		"msg": null, "msgT": 0.0, "task": I.task, "searchP": 0.0, "searchI": -1.0, "stealP": 0.0, "lastSeen": 0.0, "kickT": 0.0, "flash": 0.0}
	for R in J.iter(J.gp(lay, "rooms")): S.light.append(false); S.dark.append(0.0)
	for p in J.iter(J.gp(lay, "spots")):
		if HOT.has(J.str(J.gp(p, "k"))): S.spots.append({"k": J.gp(p, "k"), "x": J.gp(p, "x"), "y": J.gp(p, "y"), "room": 0.0, "cd": 0.0, "t": 0.0})
	for p in S.spots: p["room"] = float(roomAt(J.num(p.x)))
	for p in J.iter(J.gp(lay, "search")): S.search.append({"x": J.gp(p, "x"), "y": J.gp(p, "y"), "n": J.gp(p, "n"), "room": float(roomAt(J.num(J.gp(p, "x"))))})
	var T = S.task
	if J.str(T.k) == "media":
		var mk = null
		for k in ["tv", "pc", "radio"]:
			var has = false
			for p in S.spots: if J.str(p.k) == k: has = true; break
			if has: mk = k; break
		if mk == null: T["k"] = "allout"
		else: T["spot"] = mk
	if J.str(T.k) == "steal":
		var stl = J.gp(lay, "steal"); var sp = J.gp(stl, J.str(T.at)) if J.t(stl) else null
		var ac0 = J.gp(J.gp(lay, "acts"), J.str(T.at))
		T["x"] = J.gp(sp, "x") if J.t(sp) else (J.gp(ac0, "x") if J.t(ac0) else J.num(J.gp(lay, "door")) + 120)
		T["y"] = J.gp(sp, "y") if J.t(sp) else J.num(J.gp(lay, "floor")) - 60
	var rooms = J.gp(lay, "rooms")
	var tk = J.str(T.k)
	if tk == "steal": T["t"] = "偷走" + J.str(T.o)
	elif tk == "allout": T["t"] = "令全屋人走晒（嚇到佢哋奔出屋）"
	elif tk == "room": T["t"] = ("趁住客沖緊涼，喺" + J.str(J.gp(rooms[3], "n")) + "嚇親佢") if J.str(T.room) == "bath" else "趁住客煮緊嘢食，喺廚房嚇親佢"
	else: T["t"] = "趁住客睇緊電視，搞部電視" if J.str(T.get("spot")) == "tv" else ("趁住客打緊機，搞部電腦" if J.str(T.get("spot")) == "pc" else "趁住客聽緊收音機，搞部收音機")
	var rs = J.iter(un.rs)
	for i in rs.size():
		if J.str(rs[i].get("state")) == "home": S.actors.append(mkActor(rs[i], i, true))
	for a in S.actors.duplicate():
		if J.t(a.r.get("awake")): S.light[roomAt(J.num(a.x))] = true
	if J.t(I.get("lights")):
		for i in S.light.size(): S.light[i] = true
	J.sp(g, "inUnit", un); J.sp(g, "to", null); J.sp(g, "auto", null); J.sp(g, "autoS", null); J.sp(g, "taskP", 0.0); J.sp(g, "sc", null); J.sp(g, "still", 1.0)
	S.cam["x"] = clamp_(J.num(S.gx) - 180, 0, J.num(J.gp(lay, "W"))); S["invT"] = 2.0
	vis_on = true
	var hh = J.gp(_a("HH"), J.str(un.hh))
	msg("入咗" + J.str(J.gp(_a("FLN"), un.f)) + (J.str(J.gp(hh, "n")) if J.t(hh) else "住戶") + "：熄咗燈嘅房先好郁手；撳作怪點、撳住客嚇人。屋內任務：" + J.str(T.t), "#efdcb4"); S["msgT"] = 5.5
	if J.str(J.gp(J.gp(g, "d"), "key")) == "toyol" and J.t(un.get("beans")) and not J.t(un.get("beansDone")):
		un["beansDone"] = true; S["stun"] = 2.6; wfl(J.num(S.gx), J.num(J.gp(lay, "floor")) - J.num(J.gp(lay, "ph")) - 30, "地下有綠豆！忍唔住坐低數……", "#b8f0a0")
	if J.t(I.get("done")): S.task["done"] = true

func mkActor(r, i: int, place: bool) -> Dictionary:
	var a = {"r": r, "i": float(i), "x": J.num(J.gp(S.lay, "door")) + 60, "dir": 1.0, "act": null, "actT": 0.0, "st": "walk", "tx": null, "pose": "stand", "seeT": 0.0, "hitT": -9.0, "goT": 0.0, "lightT": 0.0, "ex": false}
	if place: pickAct(a, true); a["x"] = a.tx; a["st"] = "act"; a["pose"] = actPose(a)
	return a
func actPose(a) -> String:
	var d = J.gp(J.gp(S.lay, "acts"), J.str(a.act))
	var p = J.gp(d, "pose") if J.t(d) else null
	return J.str(p) if J.t(p) else "stand"
func pickAct(a, first := false) -> void:
	var r = a.r; var lay = S.lay; var k; var acts = J.gp(lay, "acts")
	if not J.t(r.get("awake")): k = "bed"
	else:
		var wl = WANT.get(J.str(r.get("hh")), [["sofa", 1.0]])
		k = wpick(wl)
		if not J.t(J.gp(acts, k)): k = "sofa"
		if J.str(a.act) == k and not first and k != "table": k = wpick(wl)
	var d = J.gp(acts, k)
	if not J.t(d): d = J.gp(acts, "sofa")
	if not J.t(d): d = {"x": J.num(J.gp(lay, "door")) + 150}
	var x = J.num(J.gp(d, "x"))
	var same = 0
	for o in S.actors: if not is_same(o, a) and J.str(o.act) == k: same += 1
	var seats = J.gp(d, "seats")
	if k == "table" and J.t(seats): x = J.num(seats[int(J.num(a.i)) % seats.size()])
	elif same: x += (-1.0 if same % 2 else 1.0) * ceil(same / 2.0) * (110.0 if k == "bed" else 70.0)
	var rooms = J.gp(lay, "rooms")
	a["act"] = k; a["tx"] = clamp_(x, J.num(rooms[0].x0) + 30, J.num(rooms[rooms.size() - 1].x1) - 30)
	a["actT"] = 1e9 if k == "bed" else (40 + rnd() * 20 if k == "table" else 9 + rnd() * 9); a["st"] = "walk"; a["pose"] = "stand"

func exit_(why) -> bool:
	if S == null: return false
	var un = S.un; var g = S.g; var g0 = G(); var I = iu(un); var w = J.str(why)
	I["alert"] = S.alert; I["leftT"] = J.gp(g0, "t")
	if w == "kick": I["ban"] = BAN; I["alert"] = 55.0
	elif w == "time": I["cd"] = REIN
	else: I["cd"] = 1.5
	J.sp(g, "inUnit", null); J.sp(g, "node", un.did); var d = _node(un.did); J.sp(g, "x", J.gp(d, "x")); J.sp(g, "y", J.gp(d, "y")); J.sp(g, "to", null); J.sp(g, "auto", null); J.sp(g, "autoS", null); J.sp(g, "p", 0.0); J.sp(g, "still", 1.0); J.sp(g, "taskP", 0.0); J.sp(g, "mv", 0.0)
	J.sp(g, "inv", maxf(J.num(J.gp(g, "inv")), 0.8 if w == "kick" else 1.4))
	var t = ("被趕出屋！" + J.str(BAN) + " 秒內呢戶入唔到") if w == "kick" else ("陰氣唔夠，返出走廊透下" if w == "time" else "出咗屋")
	_flt(un.x, J.num(un.y) - 90, t, "#ffb0b0" if w == "kick" else "#9fd6bf")
	if w == "kick":
		J.sp(g0, "alert", J.num(J.gp(g0, "alert")) + 1); _fn("checkAlert", []); _fn("noise", [un.did, 2.0])
		_fn("toast", [J.str(J.gp(_a("FLN"), un.f)) + "嗰戶開晒燈大嗌，鬼被趕返出走廊——全樓警覺 +1，保安聽到聲過嚟睇。"])
	S = null; vis_on = false; ptr = null; return true

# ---------------- 主推進 ----------------
func step(dt: float) -> void:
	var g0 = G()
	if not is_same(g0, lastG): lastG = g0; S = null; vis_on = false; ptr = null
	if J.t(g0):
		for u in J.iter(J.gp(g0, "units")):
			if J.t(u.get("iu")): u.iu["ban"] = maxf(0.0, J.num(u.iu.ban) - dt); u.iu["cd"] = maxf(0.0, J.num(u.iu.cd) - dt)
	if S == null: return
	var g = S.g; var lay = S.lay; var un = S.un
	var ingh = false
	for x in J.iter(J.gp(g0, "gh")): if is_same(x, g): ingh = true; break
	if J.t(J.gp(g, "out")) or J.t(J.gp(g, "home")) or not ingh: S = null; J.sp(g, "inUnit", null); vis_on = false; ptr = null; return
	S["t"] = J.num(S.t) + dt; S["limit"] = J.num(S.limit) - dt; S["msgT"] = maxf(0.0, J.num(S.msgT) - dt); S["scCd"] = maxf(0.0, J.num(S.scCd) - dt); S["invT"] = maxf(0.0, J.num(S.invT) - dt); S["stun"] = maxf(0.0, J.num(S.stun) - dt); S["flash"] = maxf(0.0, J.num(S.flash) - dt)
	J.sp(g, "inv", maxf(J.num(J.gp(g, "inv")), 0.25)); J.sp(g, "node", un.id); J.sp(g, "to", null); J.sp(g, "auto", null); J.sp(g, "autoS", null)
	if J.num(J.gp(g0, "active")) != J.num(J.gp(g, "i")): J.sp(g0, "active", J.gp(g, "i"))
	var spm = J.num(J.gp(g, "spm")) if J.t(J.gp(g, "spm")) else 1.0
	var sp = J.num(J.gp(J.gp(g, "d"), "sp")) * J.num(J.gp(J.gp(g0, "mods"), "spd")) * spm * 2.1; var mv = 0.0
	var joy = S.get("joy"); var jx = (J.num(joy.x) - J.num(joy.ox)) / 58 if J.t(joy) and J.t(joy.get("on")) else 0.0
	if J.num(S.stun) > 0 or (J.t(S.sc) and J.num(S.sc.t) < OMEN + 0.5): jx = 0.0
	var rooms = J.gp(lay, "rooms")
	if absf(jx) > 0.2:
		S["goX"] = null; S["pend"] = null; mv = clamp_(jx, -1, 1) * sp * dt
		if J.t(S.cam.get("free")): S.cam["free"] = null
	elif S.goX != null and J.num(S.stun) <= 0:
		var d = J.num(S.goX) - J.num(S.gx)
		if absf(d) < 4: S["goX"] = null
		else: mv = signf(d) * minf(absf(d), sp * dt)
	if mv:
		var nx = clamp_(J.num(S.gx) + mv, J.num(rooms[0].x0) + 10, J.num(rooms[rooms.size() - 1].x1) - 20); S["gdir"] = 1.0 if mv > 0 else -1.0
		if absf(nx - J.num(S.gx)) > 0.1: S["gmv"] = 0.15; S["still"] = 0.0
		S["gx"] = nx
		if J.num(S.gx) <= J.num(rooms[0].x0) + 12 and jx < -0.5: exit_("door"); return
	else: S["gmv"] = maxf(0.0, J.num(S.gmv) - dt); S["still"] = J.num(S.still) + dt
	var floor_ = J.num(J.gp(lay, "floor")); var ph = J.num(J.gp(lay, "ph"))
	if J.t(S.sc) and J.num(S.sc.t) < OMEN and J.num(S.gmv) > 0: wfl(J.num(S.gx), floor_ - ph - 20, "一郁就破功", "#e6a85a"); S["sc"] = null; S["scCd"] = 0.4
	if J.t(S.pend) and S.goX == null and J.num(S.stun) <= 0:
		var P = S.pend; S["pend"] = null
		if J.str(P.k) == "hot": trigger(P.p, true)
		elif J.str(P.k) == "scare": scareAt(P.a)
	if J.t(S.sc):
		var sc = S.sc; sc["t"] = J.num(sc.t) + dt
		if not J.t(sc.hit) and J.num(sc.t) >= OMEN: sc["hit"] = true; strike(sc)
		if J.num(sc.t) >= OMEN + 0.9: S["sc"] = null
	searchUpdate(dt)
	actorsUpdate(dt)
	lightsUpdate(dt)
	detect(dt)
	thresholds(dt)
	taskCheck()
	for p in S.spots: p["cd"] = maxf(0.0, J.num(p.cd) - dt); p["t"] = maxf(0.0, J.num(p.t) - dt)
	for i in S.dark.size(): S.dark[i] = maxf(0.0, J.num(S.dark[i]) - dt)
	for f in S.floats: f["life"] = J.num(f.life) - dt; f["y"] = J.num(f.y) - dt * 30
	var nf = []
	for f in S.floats: if J.num(f.life) > 0: nf.append(f)
	S["floats"] = nf
	for p in S.parts:
		p["life"] = J.num(p.life) - dt; p["x"] = J.num(p.x) + J.num(p.vx) * dt; p["y"] = J.num(p.y) + J.num(p.vy) * dt
		if p.type == "drop" or p.type == "coin" or p.type == "sweat": p["vy"] = J.num(p.vy) + 500 * dt
	var np = []
	for p in S.parts: if J.num(p.life) > 0: np.append(p)
	S["parts"] = np
	var phase = J.num(J.gp(g0, "phase"))
	if phase >= 3 and not J.t(S.flags.get("dawn")):
		S.flags["dawn"] = 1.0; msg("天光喇！住客陸續起身，開晒燈——快啲做完出屋！", "#e48a78")
		for a in S.actors.duplicate(): a.r["awake"] = true; a.r["woke"] = true
	if phase >= 3: S["alert"] = J.num(S.alert) + 3 * dt
	if J.num(S.alert) >= 100:
		S["alert"] = 100.0; S["kickT"] = J.num(S.kickT) + dt
		if J.num(S.kickT) > 0.01 and not J.t(S.flags.get("kickSaid")):
			S.flags["kickSaid"] = 1.0
			var w = null
			for a in S.actors: if J.str(a.r.get("state")) == "home": w = a; break
			if w != null: sayR(w.r, line("kick"))
		if J.num(S.kickT) >= 1.0: exit_("kick"); return
	if J.num(S.limit) <= 0: exit_("time"); return

func itemsAt(i: int) -> Array:
	var n = S.search.size(); var out = []
	var items = J.iter(S.un.items)
	for j in items.size(): if j % n == i: out.append(items[j])
	return out

func _item(k): return J.gp(_a("ITEM"), J.str(k))

func searchUpdate(dt: float) -> void:
	var g = S.g; var g0 = G(); var lay = S.lay; var un = S.un; var near = -1; var bd = 70.0
	var T = S.task
	if J.str(T.k) == "steal" and not J.t(T.get("done")) and absf(J.num(S.gx) - J.num(T.x)) < bd: near = 99
	else:
		for i in S.search.size():
			var p = S.search[i]
			if absf(J.num(p.x) - J.num(S.gx)) < bd and itemsAt(i).size(): bd = absf(J.num(p.x) - J.num(S.gx)); near = i
	var st = J.num(S.still) >= 0.12 and J.num(S.stun) <= 0 and not J.t(S.sc) and J.num(S.t) > 0.8
	if near < 0 or not st:
		if J.num(S.searchI) != near: S["searchP"] = 0.0
		S["searchI"] = float(near); return
	if J.num(S.searchI) != near: S["searchI"] = float(near); S["searchP"] = 0.0
	var tm = J.num(J.gp(g, "tm")) if J.t(J.gp(g, "tm")) else 1.0
	var mtask = J.num(J.gp(J.gp(g0, "mods"), "task"))
	var floor_ = J.num(J.gp(lay, "floor")); var ph = J.num(J.gp(lay, "ph"))
	if near == 99:
		S["searchP"] = J.num(S.searchP) + dt * mtask * tm / 2.4
		if rnd() < dt * 8: part(J.num(T.x) + (rnd() - 0.5) * 30, J.num(T.y), (rnd() - 0.5) * 60, -80, 0.6, "dust")
		if J.num(S.searchP) >= 1: S["searchP"] = 0.0; T["done"] = true; taskDone()
		return
	var it = null
	for k in itemsAt(near):
		var I = _item(k); var who = J.gp(I, "who")
		if not J.t(who) or J.str(who) == J.str(J.gp(J.gp(g, "d"), "key")): it = k; break
	if it == null:
		if not J.t(S.flags.get("who" + str(near))):
			S.flags["who" + str(near)] = 1.0; var k0 = itemsAt(near)[0]; var w = J.str(J.gp(_item(k0), "who"))
			var nm = {"eking": "餓鬼", "toyol": "Toyol", "tianhua": "天花姐"}.get(w, "其他鬼")
			wfl(J.num(S.search[near].x), J.num(S.search[near].y) - 50, J.str(J.gp(_item(k0), "n")) + "要" + nm + "先拎得", "#e6a85a")
		return
	var its = J.str(it)
	if its != "doll" and its != "key" and its != "key2" and its != "lost" and J.iter(J.gp(g0, "bag")).size() >= J.num(_a("BAGMAX")):
		if not J.t(S.flags.get("full")): S.flags["full"] = 1.0; wfl(J.num(S.gx), floor_ - ph - 20, "收穫格滿咗！", "#e48a78")
		return
	S["searchP"] = J.num(S.searchP) + dt * mtask * tm / J.num(J.gp(_item(it), "t"))
	if J.num(S.searchP) >= 1:
		S["searchP"] = 0.0
		var items = un.items; var ix = -1
		for j in items.size(): if J.seq(items[j], it): ix = j; break
		if ix >= 0:
			items.remove_at(ix); _fn("takeItem", [g, it, un]); wfl(J.num(S.search[near].x), J.num(S.search[near].y) - 60, "搜到" + J.str(J.gp(_item(it), "n")) + "！", "#e6a85a")

func actorsUpdate(dt: float) -> void:
	var lay = S.lay; var un = S.un; var door = J.num(J.gp(lay, "door")); var floor_ = J.num(J.gp(lay, "floor")); var ph = J.num(J.gp(lay, "ph"))
	var rs = J.iter(un.rs)
	for i in rs.size():
		var r = rs[i]
		if J.str(r.get("state")) == "home" and not (J.num(r.get("fleeAfter")) > 0):
			var has = false
			for a in S.actors: if is_same(a.r, r): has = true; break
			if not has:
				var a = mkActor(r, i, false); a["x"] = door + 20; pickAct(a); S.actors.append(a); sayR(r, "返到屋企喇……")
	for a in S.actors.duplicate():
		var r = a.r; a["seeT"] = maxf(0.0, J.num(a.seeT) - dt * 0.5); a["lightT"] = maxf(0.0, J.num(a.lightT) - dt)
		var rst = J.str(r.get("state"))
		if rst != "home" or J.num(r.get("fleeAfter")) > 0:
			var run = rst == "flee" or rst == "gone" or J.num(r.get("fleeAfter")) > 0; a["pose"] = "stand"; a["st"] = "run" if run else "leave"
			var spd = 360.0 if run else 110.0; a["dir"] = -1.0
			if J.num(a.x) > door - 30:
				a["x"] = maxf(door - 30, J.num(a.x) - spd * dt)
				if run and rnd() < dt * 10: part(J.num(a.x) + 20, floor_ - 6, 40, -20, 0.5, "dust")
			else: a["hid"] = true
			if rst != "home" and (J.t(a.get("hid")) or (rst != "flee" and rst != "leave")):
				a["gone"] = true
				if rst == "flee" or rst == "gone": var I = iu(un); I["fled"] = J.num(I.fled) + 1; wfl(door + 60, floor_ - ph - 40, "奔咗出屋！", "#b2d394")
			continue
		if J.t(r.get("react")) and J.str(a.st) != "cower": a["st"] = "cower"; a["cowT"] = 1.4
		if J.str(a.st) == "cower":
			a["cowT"] = J.num(a.cowT) - dt
			if J.num(a.cowT) <= 0:
				a["st"] = "walk"
				if a.tx == null: pickAct(a)
			continue
		if not J.t(r.get("awake")) and J.str(a.act) != "bed": pickAct(a)
		if J.t(r.get("awake")) and J.str(a.act) == "bed": pickAct(a); a["pose"] = "stand"
		var ast = J.str(a.st)
		if ast == "walk" or ast == "go":
			var d = J.num(a.tx) - J.num(a.x); var w = (150.0 if ast == "go" else 95.0) if J.t(r.get("awake")) else 95.0
			if absf(d) < 3:
				a["x"] = a.tx
				if ast == "go": a["st"] = "look"; a["lookT"] = 2.6; a["pose"] = "stand"
				else: a["st"] = "act"; a["pose"] = actPose(a)
			else: a["dir"] = 1.0 if d > 0 else -1.0; a["x"] = J.num(a.x) + signf(d) * minf(absf(d), w * dt); a["pose"] = "stand"
		elif ast == "look":
			a["lookT"] = J.num(a.lookT) - dt; a["dir"] = 1.0 if int(floor(J.num(a.lookT) * 1.3)) % 2 else -1.0
			if J.num(a.lookT) <= 0: sayR(r, line("look")); pickAct(a)
		elif ast == "act":
			a["actT"] = J.num(a.actT) - dt; var d0 = J.gp(J.gp(lay, "acts"), J.str(a.act))
			if J.t(d0) and J.t(J.gp(d0, "look")):
				var spf = null
				for p in S.spots: if J.str(p.k) == J.str(J.gp(d0, "look")): spf = p; break
				if spf != null: a["dir"] = 1.0 if J.num(spf.x) > J.num(a.x) else -1.0
			if J.num(a.actT) <= 0: pickAct(a)
		var ri = roomAt(J.num(a.x))
		if J.t(r.get("awake")) and J.str(a.st) != "run" and not S.light[ri] and J.num(S.dark[ri]) <= 0:
			var sleepers = false
			for o in S.actors: if not is_same(o, a) and not J.t(o.r.get("awake")) and roomAt(J.num(o.x)) == ri: sleepers = true; break
			if not sleepers or J.num(S.alert) >= 35:
				if not J.t(a.lightT): a["lightT"] = 1.4
				elif J.num(a.lightT) <= 0.05: S.light[ri] = true; a["lightT"] = 0.0; sayR(r, line("lightOn"))
	var na = []
	for a in S.actors: if not J.t(a.get("gone")): na.append(a)
	S["actors"] = na

func lightsUpdate(dt: float) -> void:
	var all = J.num(S.alert) >= 85 or J.t(iu(S.un).get("lights"))
	var out = []
	for i in S.light.size():
		var on = S.light[i]; var v
		if J.num(S.dark[i]) > 0: v = false
		elif all: v = true
		else:
			var awake = false
			for a in S.actors: if J.t(a.r.get("awake")) and J.str(a.st) != "run" and roomAt(J.num(a.x)) == i: awake = true; break
			v = on
			if on and not awake and J.num(S.alert) < 35:
				if not (S.get("offT") is Dictionary): S["offT"] = {}
				S.offT[i] = J.num(S.offT.get(i)) + dt
				if J.num(S.offT[i]) > 8: S.offT[i] = 0.0; v = false
			elif S.get("offT") is Dictionary: S.offT[i] = 0.0
		out.append(v)
	S["light"] = out

func facing(a, x: float) -> bool: return signf(x - J.num(a.x)) == J.num(a.dir) or absf(x - J.num(a.x)) < 70

func detect(dt: float) -> void:
	var g0 = G(); var gr = roomAt(J.num(S.gx)); var lit = S.light[gr]; var any = false; var rates = []
	var phase = J.num(J.gp(g0, "phase")); var lay = S.lay
	if J.num(S.invT) <= 0:
		for a in S.actors.duplicate():
			var r = a.r; var act = J.str(a.act); var ast = J.str(a.st)
			if not J.t(r.get("awake")) or ast == "run" or ast == "cower" or (act == "shower" and ast == "act") or act == "bed": continue
			if roomAt(J.num(a.x)) != gr: continue
			var dx = absf(J.num(S.gx) - J.num(a.x)); var f = facing(a, J.num(S.gx))
			if ast == "act" and (act == "tv" or act == "pc" or act == "radio") and dx >= 70: f = false
			var rate = 0.0
			if lit and f: rate = SEE_LIT
			elif not lit and f and dx < 110: rate = SEE_DARK
			if not rate: continue
			rate *= (1 + 0.15 * minf(3.0, phase)) * (1 + J.num(r.get("brave"))); any = true; a["seeT"] = minf(3.0, J.num(a.seeT) + dt * 1.5)
			if J.num(a.seeT) > 0.8 and not J.t(a.get("saw")):
				a["saw"] = true; sayR(r, line("see")); wfl(J.num(a.x), J.num(J.gp(lay, "floor")) - J.num(J.gp(lay, "ph")) * 1.15, "！被睇到", "#e48a78")
			if J.num(a.seeT) > 0.8: rates.append(rate)
	rates.sort(); rates.reverse()
	for i in rates.size(): S["alert"] = J.num(S.alert) + (rates[i] * 0.25 if i else rates[i]) * dt
	S["seenNow"] = any
	if any: S["calmT"] = 0.0
	else:
		S["calmT"] = J.num(S.calmT) + dt
		for a in S.actors.duplicate(): if J.num(a.seeT) < 0.1: a["saw"] = false
	if J.num(S.calmT) > 5 and J.num(S.alert) > 0:
		var I = iu(S.un); S["alert"] = maxf(30.0 if J.t(I.get("lights")) else 0.0, J.num(S.alert) - 2.5 * dt)

func thresholds(_dt: float) -> void:
	var I = iu(S.un); var g0 = G(); var aw = []
	for a in S.actors: if J.t(a.r.get("awake")) and J.str(a.st) != "run": aw.append(a)
	var al = J.num(S.alert)
	if al >= 35 and not J.t(S.flags.get("t35")) and aw.size(): S.flags["t35"] = 1.0; sayR(aw[0].r, "開燈！全部開燈先！"); S.light[roomAt(J.num(aw[0].x))] = true
	if al >= 55 and not J.t(S.flags.get("t55")) and aw.size():
		S.flags["t55"] = 1.0; var sl = []
		for a in S.actors: if not J.t(a.r.get("awake")): sl.append(a)
		if sl.size():
			sayR(aw[0].r, line("wake"))
			for a in sl: a.r["awake"] = true; a.r["woke"] = true; a.r["fear"] = minf(95.0, J.num(a.r.get("fear")) + 8)
			msg("有人叫醒晒全屋人！", "#e48a78")
	if al >= 70 and not J.t(I.get("phoned")) and aw.size():
		I["phoned"] = true; sayR(aw[0].r, line("phone")); J.sp(g0, "alert", J.num(J.gp(g0, "alert")) + 1); _fn("checkAlert", []); _fn("noise", [S.un.did, 2.0]); msg("住客打電話去管理處！全樓警覺 +1，保安會去門口睇", "#e48a78")
	if al >= 85 and not J.t(S.flags.get("t85")):
		S.flags["t85"] = 1.0; I["lights"] = true
		if aw.size(): sayR(aw[0].r, line("lights"))
		msg("佢哋開晒全屋燈！行邊度都會現形", "#e48a78")

# ---------------- 作怪點 ----------------
func trigger(p, auto: bool) -> bool:
	var g = S.g; var Hd = HOT[J.str(p.k)]; var lay = S.lay; var rooms = J.gp(lay, "rooms")
	if J.num(p.cd) > 0:
		if not auto: wfl(J.num(p.x), J.num(p.y) - 40, Hd.v + "冷卻緊 " + J.str(ceil(J.num(p.cd))) + " 秒", "#ddd2bd")
		return false
	var pr = int(J.num(p.room))
	if roomAt(J.num(S.gx)) != pr or absf(J.num(S.gx) - J.num(p.x)) > RANGE_HOT:
		S["goX"] = clamp_(J.num(p.x), J.num(rooms[pr].x0) + 20, J.num(rooms[pr].x1) - 20); S["pend"] = {"k": "hot", "p": p}; return false
	if J.num(S.stun) > 0: return false
	p["cd"] = 14.0; p["t"] = 2.6; S["gdir"] = 1.0 if J.num(p.x) > J.num(S.gx) else -1.0; S["alert"] = J.num(S.alert) + 4; S["calmT"] = 0.0; wfl(J.num(p.x), J.num(p.y) - 50, Hd.v + "！", "#e8a088")
	if J.str(p.k) == "lamp": S.dark[pr] = 15.0; S.light[pr] = false; S["flash"] = 0.4
	var hit = 0; var rm = pr; var T = S.task
	var media = J.str(T.k) == "media" and J.str(p.k) == J.str(T.get("spot")) and not J.t(T.get("done"))
	for a in S.actors.duplicate():
		var r = a.r
		if J.str(r.get("state")) != "home" or J.str(a.st) == "run": continue
		var ar = roomAt(J.num(a.x)); var same = ar == rm; var adj = absi(ar - rm) == 1
		if not same and not (J.t(Hd.loud) and adj): continue
		var amt = Hd.f * (1.0 if same else 0.35)
		var ad = J.gp(J.gp(lay, "acts"), J.str(a.act))
		if media and same and J.str(a.st) == "act" and J.str(J.gp(ad, "look") if J.t(ad) else null) == J.str(p.k): T["done"] = true; taskDone()
		if not J.t(r.get("awake")):
			if not J.t(Hd.loud) and not same: continue
			r["awake"] = true; r["woke"] = true; amt *= 0.6; sayR(r, pick(["咩聲呀……邊個？", "發開夢？"]))
		else: sayR(r, pick(Hd.ln))
		addRFear(a, amt); hit += 1
		if not same and J.str(a.st) != "go" and rnd() < 0.6:
			a["st"] = "go"; a["tx"] = clamp_(J.num(p.x) + (rnd() - 0.5) * 60, J.num(rooms[rm].x0) + 30, J.num(rooms[rm].x1) - 30); sayR(r, line("go"))
		roomTask(a)
	if hit: _fn("addFear", [2.0, S.un.x, J.num(S.un.y) - 100]); J.sp(g, "energy", minf(100.0, J.num(J.gp(g, "energy")) + 6))
	var wet = J.str(p.k) == "tap" or J.str(p.k) == "shower" or J.str(p.k) == "jar"
	for i in 8: part(J.num(p.x) + (rnd() - 0.5) * 40, J.num(p.y) + (rnd() - 0.5) * 30, (rnd() - 0.5) * 120, -60 - rnd() * 60, 0.8, "drop" if wet else "spark")
	return true

func addRFear(a, amt: float) -> void:
	var r = a.r; var g0 = G()
	var gpf = J.num(_fn("gpF", [S.g])) if J.t(_a("gpF")) else 1.0
	r["fear"] = J.num(r.get("fear")) + amt * J.num(J.gp(J.gp(g0, "mods"), "pow")) * gpf * (1 - J.num(r.get("brave")))
	if J.num(r.fear) >= 100 and not (J.num(r.get("fleeAfter")) > 0) and J.str(r.get("state")) == "home": r["fleeAfter"] = 0.9; r["fleeG"] = S.g

func roomTask(a) -> void:
	var T = S.task
	if J.str(T.k) != "room" or J.t(T.get("done")): return
	var R = J.gp(S.lay, "rooms")[roomAt(J.num(a.x))]
	if J.str(J.gp(R, "k")) == J.str(T.room) and (J.str(a.act) == J.str(T.act) or J.str(a.get("prevAct")) == J.str(T.act)) and (J.str(a.st) == "act" or J.str(a.st) == "cower"): T["done"] = true; taskDone()

func taskDone() -> void:
	var g = S.g; var g0 = G(); var I = iu(S.un)
	if J.t(I.get("done")): return
	I["done"] = true; S.task["done"] = true
	_fn("addFear", [J.round(20 * J.num(J.gp(J.gp(g0, "mods"), "fear"))), S.un.x, J.num(S.un.y) - 110]); J.sp(g, "energy", minf(100.0, J.num(J.gp(g, "energy")) + 30))
	J.sp(g0, "unitCoins", J.num(J.gp(g0, "unitCoins")) + 15); J.sp(g0, "unitTasks", J.num(J.gp(g0, "unitTasks")) + 1)
	_fn("takeItem", [g, "doll", S.un]); msg("屋內任務完成：" + J.str(S.task.t) + "——怕意 +20、能量 +30、替身紙人 +1、冥幣 +15", "#b2d394"); S["msgT"] = 4.5
	wfl(J.num(S.gx), J.num(J.gp(S.lay, "floor")) - J.num(J.gp(S.lay, "ph")) - 60, "任務完成！", "#b2d394")

func taskCheck() -> void:
	var T = S.task
	if J.t(T.get("done")): return
	if J.str(T.k) == "allout":
		var rs = J.iter(S.un.rs)
		if rs.size():
			var allg = true
			for r in rs: if not (J.str(r.get("state")) == "flee" or J.str(r.get("state")) == "gone"): allg = false; break
			if allg and J.num(iu(S.un).fled) > 0: T["done"] = true; taskDone()

# ---------------- 直接嚇人 ----------------
func nearestActor(rng: float):
	var gr = roomAt(J.num(S.gx)); var best = null; var bd = rng
	for a in S.actors.duplicate():
		if J.str(a.r.get("state")) != "home" or J.str(a.st) == "run" or J.num(a.r.get("fleeAfter")) > 0: continue
		var d = absf(J.num(a.x) - J.num(S.gx))
		if roomAt(J.num(a.x)) != gr and d > 90: continue
		if d < bd: bd = d; best = a
	return best

func scareAt(a) -> void:
	if not J.t(a) or J.str(a.r.get("state")) != "home": return
	if absf(J.num(a.x) - J.num(S.gx)) > RANGE_SCARE or roomAt(J.num(a.x)) != roomAt(J.num(S.gx)) and absf(J.num(a.x) - J.num(S.gx)) > 90:
		S["goX"] = J.num(a.x) + (-80.0 if J.num(a.x) > J.num(S.gx) else 80.0); S["pend"] = {"k": "scare", "a": a}; return
	scare(a)

func scare(target = null) -> bool:
	if S == null: return false
	var g = S.g; var lay = S.lay; var fy0 = J.num(J.gp(lay, "floor")) - J.num(J.gp(lay, "ph")) - 20
	if J.t(S.sc): return false
	if J.num(S.scCd) > 0: wfl(J.num(S.gx), fy0, "啱啱嚇完，等陣先", "#ddd2bd"); return false
	if J.num(S.stun) > 0: wfl(J.num(S.gx), fy0, "數緊綠豆，數完先嚇得", "#b8f0a0"); return false
	var a = target if J.t(target) else nearestActor(RANGE_SCARE)
	if not J.t(a):
		var far = nearestActor(2000)
		if far != null:
			scareAt(far); var hh = J.gp(_a("HH"), J.str(far.r.get("hh")))
			wfl(J.num(S.gx), fy0, "飄過去嚇" + (J.str(J.gp(hh, "n")) if J.t(hh) else "住客"), "#e8a088"); return false
		wfl(J.num(S.gx), fy0, "屋入面冇人喇", "#ddd2bd"); return false
	S["goX"] = null; S["pend"] = null; S["gdir"] = 1.0 if J.num(a.x) > J.num(S.gx) else -1.0; S["still"] = maxf(J.num(S.still), 0.12); S["gmv"] = 0.0
	var gk = J.gp(J.gp(g, "d"), "key")
	S["sc"] = {"t": 0.0, "a": a, "k": gk, "hit": false}; S["scCd"] = OMEN + 1.4
	var mvd = J.gp(_a("MV"), J.str(gk))
	wfl(J.num(S.gx), J.num(J.gp(lay, "floor")) - J.num(J.gp(lay, "ph")) - 30, J.str(J.gp(mvd, "n")) if J.t(mvd) else "嚇！", "#e8a088"); return true

func strike(sc) -> void:
	var a = sc.a; var r = a.r; var g = S.g; var gr = roomAt(J.num(a.x)); var lit = S.light[gr]; var lay = S.lay
	if J.str(r.get("state")) != "home": return
	var amt = 38.0; var tag = ""
	if not lit: amt *= 1.5; tag = "黑暗中嚇加倍！"
	if J.num(S.t) - J.num(a.hitT) < 5: amt *= 1.3; tag = (tag + " " if tag != "" else "") + "連環嚇！"
	a["prevAct"] = a.act; _fn("scareRes", [r, amt, g]); a["hitT"] = S.t; a["st"] = "cower"; a["cowT"] = 1.6; S["alert"] = J.num(S.alert) + (12.0 if lit else 5.0); S["calmT"] = 0.0; S["flash"] = 0.25
	var floor_ = J.num(J.gp(lay, "floor")); var ph = J.num(J.gp(lay, "ph"))
	if tag != "": wfl(J.num(a.x), floor_ - ph * 1.2, tag, "#e6a85a")
	var tp = "coin" if J.str(sc.k) == "toyol" else ("drop" if J.str(sc.k) == "tianhua" else "crumb")
	for i in 10: part(J.num(a.x), floor_ - ph * 0.7, (rnd() - 0.5) * 200, -100 - rnd() * 80, 0.7, tp)
	roomTask(a)

# ---------------- 畫 ----------------
func layout() -> void:
	var NT = J.gp(J.G.get("window"), "__twNat")
	DPR = J.num(J.gp(NT, "s")) if J.t(NT) else 1.0
	W = J.num(_a("VW")); H = J.num(_a("VH"))
func view() -> Dictionary:
	var lay = S.lay; var top = J.num(_a("TOP")); var ph = H - top - J.num(_a("BOT")); var crop = J.gp(lay, "crop"); var s = ph / (J.num(crop[1]) - J.num(crop[0]))
	return {"top": top, "ph": ph, "s": s, "vw": W / s}
func P(x: float, y: float, V: Dictionary) -> Vector2:
	return Vector2((x - J.num(S.cam.x)) * V.s, V.top + (y - J.num(J.gp(S.lay, "crop")[0])) * V.s)
func Px(x, y, V) -> Dictionary:
	return {"x": (J.num(x) - J.num(S.cam.x)) * V.s, "y": V.top + (J.num(y) - J.num(J.gp(S.lay, "crop")[0])) * V.s}
func sprite(k, x: float, y: float, h: float, o = null) -> void:
	var im = img(k)
	if im == null:
		c.fillStyle = "rgba(30,30,36," + J.str(J.gp(o, "alpha") if J.t(o) and J.t(J.gp(o, "alpha")) else 1.0) + ")"; c.fillRect(x - h * 0.18, y - h, h * 0.36, h); return
	var w = h * J.num(J.gp(im, "width")) / J.num(J.gp(im, "height")); if not J.t(o): o = {}
	c.save(); c.globalAlpha = 1.0 if o.get("alpha") == null else J.num(o.alpha); c.translate(x, y)
	if J.t(o.get("rot")): c.rotate(J.num(o.rot))
	c.scale((-1.0 if J.t(o.get("flip")) else 1.0) * (J.num(o.sx) if J.t(o.get("sx")) else 1.0), J.num(o.sy) if J.t(o.get("sy")) else 1.0)
	c.drawImage(im, -w / 2, -h, w, h); c.restore()
func bubble(x: float, y: float, t) -> void:
	c.font = "bold 13px " + J.str(_a("FONT")); var w = minf(W - 20, J.num(c.measureText(J.str(t)).width) + 18); x = clamp_(x, w / 2 + 6, W - w / 2 - 6)
	_fn("crBlit", [c, _fn("crGet", [w, 24.0, "note", "bar"]), x - w / 2, y - 26]); c.save(); c.fillStyle = "#2a1e1c"; c.textAlign = "center"; c.fillText(J.str(t), x, y - 9, w - 8); c.restore()
func btn(id: String, x: float, y: float, w: float, h: float, label, tone, on = null) -> void:
	BTN.append({"id": id, "x": x, "y": y, "w": w, "h": h})
	var pz = (ptr != null and J.str(ptr.get("btn")) == id) or (PRESS != null and PRESS.id == id and J.S_performance_("now", []) - J.num(PRESS.t) < 220)
	_fn("crBtn", [c, x, y, w, h, label, tone, pz, on is bool and on == false])
func txt(s, x: float, y: float, sz: float, col, al = null, mw = null) -> void: _fn("crText", [c, s, x, y, sz, col, al if J.t(al) else "center", mw])

func drawBG(V: Dictionary) -> void:
	var lay = S.lay; var im = img(J.gp(lay, "img")); var crop = J.gp(lay, "crop")
	if im != null:
		var iw = J.num(J.gp(im, "width")); var ih = J.num(J.gp(im, "height"))
		var k = iw / J.num(J.gp(lay, "W")); var ch = J.num(crop[1]) - J.num(crop[0]); var srcY = (J.num(crop[0]) if ih / k >= J.num(J.gp(lay, "H")) - 4 else 0.0) * k
		c.drawImage(im, J.num(S.cam.x) * k, srcY, V.vw * k, ch * k, 0, V.top, W, V.ph)
	else:
		for R in J.iter(J.gp(lay, "rooms")):
			var a = P(J.num(R.x0), J.num(crop[0]), V); var b = P(J.num(R.x1), J.num(crop[1]), V)
			if b.x < 0 or a.x > W: continue
			var RK = {"living": ["room_mahjong", "room_shopper"], "kitchen": ["room_helper"], "bed": ["room_nurse", "room_gamer"], "bath": []}.get(J.str(R.k), [])
			var key = null
			for kk in RK: if img(kk) != null: key = kk; break
			if key != null: c.drawImage(img(key), a.x, a.y, b.x - a.x, b.y - a.y)
			else:
				var gd = c.createLinearGradient(0, a.y, 0, b.y); gd.addColorStop(0, "#2a3134"); gd.addColorStop(1, "#151a1c"); c.fillStyle = gd; c.fillRect(a.x, a.y, b.x - a.x, b.y - a.y); c.strokeStyle = "rgba(180,200,200,0.12)"
				var tx = a.x
				while tx < b.x: c.beginPath(); c.moveTo(tx, a.y); c.lineTo(tx, b.y); c.stroke(); tx += 22 * V.s
			c.fillStyle = "#0d0b0e"; c.fillRect(b.x - 6 * V.s, a.y, 12 * V.s, (b.y - a.y) * 0.35)

func drawSpot(p, V: Dictionary) -> void:
	var q = P(J.num(p.x), J.num(p.y), V); var act = J.num(p.t) > 0; var T = J.num(S.t); var s = V.s; var k = J.str(p.k); var r = 34 * s + 10; var FONT = J.str(_a("FONT"))
	c.save()
	if act:
		c.globalAlpha = minf(1.0, J.num(p.t))
		if k == "tv" or k == "pc":
			for i in 60: c.fillStyle = "rgba(230,235,240," + J.str(randf() * 0.8) + ")"; c.fillRect(q.x - 40 * s + randf() * 80 * s, q.y - 28 * s + randf() * 50 * s, 3, 2)
			c.fillStyle = "rgba(10,10,10,0.6)"; c.beginPath(); c.ellipse(q.x, q.y, 10 * s, 14 * s, 0, 0, 7); c.fill()
			if k == "pc": c.fillStyle = "#c0302a"; c.fillRect(q.x - 6 * s, q.y - 4 * s, 4 * s, 4 * s); c.fillRect(q.x + 3 * s, q.y - 4 * s, 4 * s, 4 * s)
		elif k == "lamp":
			if int(floor(T * 14)) % 3 == 0:
				var gr = c.createRadialGradient(q.x, q.y, 2, q.x, q.y, 120 * s); gr.addColorStop(0, "rgba(255,240,190,0.55)"); gr.addColorStop(1, "rgba(255,240,190,0)"); c.fillStyle = gr; c.fillRect(q.x - 120 * s, q.y - 120 * s, 240 * s, 240 * s)
		elif k == "tap" or k == "shower":
			c.strokeStyle = "rgba(170,215,240,0.85)"; c.lineWidth = 3
			for j in 4:
				c.beginPath(); var xx = q.x + (j - 1.5) * 4 * s; c.moveTo(xx, q.y); c.lineTo(xx + sin(T * 20 + j) * 2, q.y + (200.0 if k == "shower" else 60.0) * s); c.stroke()
		elif k == "wardrobe" or k == "fridge":
			var o = absf(sin((2.6 - J.num(p.t)) * 1.5)) * 44 * s; c.fillStyle = "rgba(200,240,255,0.35)" if k == "fridge" else "rgba(10,6,8,0.85)"
			c.beginPath(); c.moveTo(q.x + 20 * s, q.y - 70 * s); c.lineTo(q.x + 20 * s + o, q.y - 80 * s); c.lineTo(q.x + 20 * s + o, q.y + 90 * s); c.lineTo(q.x + 20 * s, q.y + 80 * s); c.closePath(); c.fill()
			if k == "wardrobe": c.fillStyle = "rgba(220,40,40,0.8)"; c.beginPath(); c.arc(q.x + 6 * s, q.y - 20 * s, 2.5, 0, 7); c.arc(q.x + 14 * s, q.y - 20 * s, 2.5, 0, 7); c.fill()
		elif k == "mirror":
			c.globalAlpha *= 0.5 + 0.3 * sin(T * 8); sprite(J.gp(J.gp(S.g, "d"), "sprite"), q.x, q.y + 40 * s, 90 * s, {"alpha": 0.55})
		elif k == "fan":
			c.strokeStyle = "rgba(220,230,235,0.5)"; c.lineWidth = 2
			for j2 in 3: c.beginPath(); c.ellipse(q.x, q.y, (50 + j2 * 14) * s, 10 * s, 0, T * 30 + j2, T * 30 + j2 + 2); c.stroke()
		elif k == "radio":
			c.fillStyle = "#e8d2a0"; c.font = "bold " + J.str(J.round(22 * s + 8)) + "px " + FONT; c.textAlign = "center"
			c.fillText("♪", q.x - 20 * s + sin(T * 5) * 8, q.y - 40 * s - fmod(T * 60, 30)); c.fillText("♫", q.x + 20 * s, q.y - 30 * s - fmod(T * 60 + 15, 30))
		elif k == "pots":
			var dy = minf(1.0, (2.6 - J.num(p.t)) * 2) * 160 * s; c.fillStyle = "#3a3a3e"; c.beginPath(); c.ellipse(q.x + 10 * s, q.y + dy, 18 * s, 8 * s, (2.6 - J.num(p.t)) * 6, 0, 7); c.fill()
		elif k == "net":
			c.strokeStyle = "rgba(235,235,230,0.55)"; c.lineWidth = 2
			for j3 in 6:
				c.beginPath(); var bx = q.x - 90 * s + j3 * 36 * s; c.moveTo(bx, q.y - 110 * s); c.quadraticCurveTo(bx + sin(T * 6 + j3) * 24 * s, q.y, bx + sin(T * 4 + j3) * 14 * s, q.y + 110 * s); c.stroke()
		elif k == "jar":
			for j4 in 5: c.strokeStyle = "rgba(180,220,230,0.7)"; c.beginPath(); c.arc(q.x + (j4 - 2) * 10 * s, q.y - 50 * s - fmod(T * 80 + j4 * 13, 40) * s, 4 * s + 2, 0, 7); c.stroke()
		c.globalAlpha = 1
	var ready = J.num(p.cd) <= 0; var inR = roomAt(J.num(S.gx)) == int(J.num(p.room)) and absf(J.num(S.gx) - J.num(p.x)) <= RANGE_HOT
	c.globalAlpha = ((0.85 + 0.15 * sin(T * 6)) if inR else (0.45 + 0.2 * sin(T * 3))) if ready else 0.35
	c.strokeStyle = ("#e6a85a" if inR else "#b2d394") if ready else "#7a6e74"; c.lineWidth = 3 if inR and ready else 2; c.setLineDash([] if ready else [4, 4]); c.beginPath(); c.arc(q.x, q.y, r * 0.62, 0, 7); c.stroke(); c.setLineDash([])
	if not ready: c.strokeStyle = "#e8d2a0"; c.lineWidth = 3; c.beginPath(); c.arc(q.x, q.y, r * 0.62, -PI / 2, -PI / 2 + PI * 2 * (1 - J.num(p.cd) / 14)); c.stroke()
	c.globalAlpha = 1; c.restore()
	if ready and inR: txt(HOT[k].v, q.x, q.y - r * 0.62 - 6, 12, "#e6a85a")

func _fx(): return J.gp(J.G.get("window"), "PPLFX")

func drawActor(a, V: Dictionary) -> void:
	var r = a.r; var lay = S.lay; var FX = _fx(); var run = J.str(a.st) == "run"; var scared = J.t(FX) and ((J.num(r.get("shockT")) > 0) or run)
	var ph = J.num(J.gp(lay, "ph")); var floor_ = J.num(J.gp(lay, "floor"))
	var h0 = ph * (J.num(r.get("h")) if J.t(r.get("h")) else 74.0) / 74 * V.s
	var k2 = J.mc(FX, "key", [r.sprite, scared]) if J.t(FX) else r.sprite
	var h = J.num(J.mc(FX, "hgt", [r.sprite, k2, h0])) if J.t(FX) else h0
	var art = J.str(k2) != J.str(r.sprite)
	var q = P(J.num(a.x), floor_, V); var rot = 0.0; var sy = 1.0; var sx = 0.0; var oy = 0.0; var al = 1.0; var sxs = 1.0; var tint = 0.0; var flip = J.num(a.dir) < 0
	var bed = J.str(a.act) == "bed" and J.str(a.st) == "act"
	if q.x < -80 or q.x > W + 80 or J.t(a.get("hid")): return
	if J.str(a.pose) == "sit" and J.str(a.st) == "act": sy = 0.86
	if bed:
		rot = -1.45; var bd = J.gp(J.gp(lay, "acts"), "bed"); oy = -(J.num(J.gp(bd, "lift")) if J.t(J.gp(bd, "lift")) else 60.0) * V.s; sx = h * 0.45
	if J.str(a.act) == "shower" and J.str(a.st) == "act": al = 0.85
	if J.str(a.st) == "cower" or J.t(r.get("react")): sx += sin(J.num(S.t) * 40) * 2; sy *= 0.94
	if run: oy -= absf(sin(J.num(a.x) * 0.045)) * 10; rot = -J.num(a.dir) * 0.18; tint = 0.12 if art else 0.3
	if J.t(FX) and J.num(r.get("shockT")) > 0 and not run and not bed:
		var S0 = J.mc(FX, "shock", [r.shockT, r.get("shockA") if J.t(r.get("shockA")) else 1.0]); sy *= J.num(J.gp(S0, "sy")); sxs = J.num(J.gp(S0, "sx")); oy += J.num(J.gp(S0, "jy")) * h; sx += J.num(J.gp(S0, "sh")) * h; tint = J.num(J.gp(S0, "tint")) * (0.55 if art else 1.0)
	elif J.t(FX) and J.t(r.get("awake")) and J.num(r.get("fear")) >= 55 and not run and not bed:
		var T0 = J.mc(FX, "tremble", [r, S.t]); sx += J.num(J.gp(T0, "sh")) * h; sy *= J.num(J.gp(T0, "sy"))
		if J.str(a.st) != "walk" and J.str(a.st) != "go" and J.gp(T0, "flip") != null: flip = J.t(J.gp(T0, "flip"))
		tint = J.num(J.gp(T0, "tint"))
	elif not J.t(FX) and J.num(r.get("jumpT")) > 0: oy -= sin((0.5 - J.num(r.jumpT)) / 0.5 * PI) * 16
	if J.t(FX) and J.t(r.get("shockN")) and J.num(a.get("shkN")) != J.num(r.shockN):
		a["shkN"] = r.shockN
		for j in 5: part(J.num(a.x) + (randf() - 0.5) * 30, floor_ - ph * 0.85, (randf() - 0.5) * 220, -120 - randf() * 90, 0.8, "drop")
	c.fillStyle = "rgba(0,0,0,0.45)"; c.beginPath(); c.ellipse(q.x, q.y, 26 * V.s + 6, 6, 0, 0, 7); c.fill()
	if J.t(FX) and run and not art: J.mc(FX, "arms", [c, q.x + sx, q.y + oy, h, a.dir, S.t])
	if J.t(FX): J.mc(FX, "draw", [c, r.sprite, k2, q.x + sx, q.y + oy, h, {"flip": flip, "rot": rot, "sy": sy, "sx": sxs, "alpha": al, "tint": tint}])
	else: sprite(r.sprite, q.x + sx, q.y + oy, h, {"flip": flip, "rot": rot, "sy": sy, "alpha": al})
	if J.str(a.act) == "shower" and J.str(a.st) == "act":
		for i in 3: c.fillStyle = "rgba(220,230,235,0.18)"; c.beginPath(); c.arc(q.x + (i - 1) * 30 * V.s, q.y - h * (0.4 + 0.2 * i) - fmod(J.num(S.t) * 20 + i * 10, 20), 24 * V.s + 8, 0, 7); c.fill()
	if bed and not J.t(r.get("awake")):
		txt("Z", q.x + h * 0.5, q.y + oy - h * 0.25 - fmod(J.num(S.t) * 14, 14), 15, "#c8d8ff"); txt("z", q.x + h * 0.6, q.y + oy - h * 0.35 - fmod(J.num(S.t) * 14 + 7, 14), 11, "#c8d8ff")
	var top = q.y + oy - (h * 0.35 if bed else h * minf(1.0, sy))
	if J.t(FX) and J.num(r.get("shockT")) > 0: J.mc(FX, "bang", [c, q.x + sx, top - 10, 1 - J.num(r.shockT) / 0.9, 1.1])
	elif J.t(FX) and run: J.mc(FX, "bang", [c, q.x, top - 8, 0.5, 0.9])
	if J.num(r.get("fear")) > 0 and not run: _fn("crBar", [c, q.x - 24, top - 12, 48.0, 8.0, J.num(r.fear) / 100, "red"])
	if J.t(a.get("saw")) and J.num(a.seeT) > 0.2 and not (J.num(r.get("shockT")) > 0): txt("！", q.x, top - 18, 26, "#ffe25a")
	if J.t(FX) and J.t(r.get("scream")): J.mc(FX, "scream", [c, clamp_(q.x, 90, W - 90), top - 24, r.scream, 1.15])
	if J.t(r.get("say")): bubble(q.x, top - (18.0 if J.num(r.get("fear")) > 0 else 6.0), r.say)

func drawGhost(V: Dictionary) -> void:
	var g = S.g; var lay = S.lay; var gd = J.gp(g, "d"); var gr = roomAt(J.num(S.gx)); var lit = S.light[gr] and J.num(S.invT) <= 0
	var ph = J.num(J.gp(lay, "ph")); var floor_ = J.num(J.gp(lay, "floor"))
	var h = ph * 0.74 * (J.num(J.gp(gd, "h")) / 76) * V.s; var q = P(J.num(S.gx), floor_, V); var key = J.gp(gd, "sprite"); var by = q.y; var sy = 1.0; var rot = 0.0; var ox = 0.0; var oy = 0.0
	var al = 0.25 if J.num(S.invT) > 0 else (0.92 if lit else 0.5); var gk = J.str(J.gp(gd, "key"))
	if gk == "tianhua" and J.num(S.gmv) <= 0 and img("tianhua_hang") != null: key = "tianhua_hang"; by = P(0, J.num(J.gp(lay, "ceil")) + 20, V).y + h * 1.05
	elif J.num(S.gmv) > 0: oy = -absf(sin(J.num(S.t) * 12)) * 6; rot = J.num(S.gdir) * 0.08
	else: oy = sin(J.num(S.t) * 2.5) * 4 - 4
	if J.t(S.sc):
		var t = J.num(S.sc.t)
		if t < OMEN:
			var k = t / OMEN; c.fillStyle = {"eking": "rgba(210,90,40,", "toyol": "rgba(120,220,140,", "tianhua": "rgba(110,190,255,"}.get(gk, "undefined") + J.str(0.3 * k) + ")"; c.beginPath(); c.arc(q.x, by - h * 0.5, h * 0.6 * (0.6 + 0.4 * k), 0, 7); c.fill(); sy = 1 - 0.08 * k
		else: ox = J.num(S.gdir) * 30 * V.s * sin(minf(1.0, (t - OMEN) / 0.3) * PI)
	if J.num(S.stun) > 0: txt("一、二、三……", q.x, by - h - 10, 14, "#b8f0a0")
	c.save(); c.shadowColor = "rgba(140,255,200,0.85)"; c.shadowBlur = 4 if lit else 14; sprite(key, q.x + ox, by + oy, h, {"flip": J.num(S.gdir) < 0, "alpha": al, "rot": rot, "sy": sy}); c.restore()
	c.fillStyle = "rgba(110,255,190,0.35)"; c.beginPath(); c.ellipse(q.x, q.y, 30 * V.s + 8, 7, 0, 0, 7); c.fill()
	if not lit and J.num(S.invT) <= 0: txt("黑暗中", q.x, q.y + 16, 11, "#a9c79a")
	elif lit and J.num(S.invT) <= 0: txt("現形！燈著咗", q.x, q.y + 16, 12, "#e48a78")
	if J.num(S.searchP) > 0:
		var si = int(J.num(S.searchI)); var sq
		if si == 99: sq = P(J.num(S.task.x), J.num(S.task.y), V)
		elif si >= 0 and si < S.search.size(): sq = P(J.num(S.search[si].x), J.num(S.search[si].y), V)
		else: sq = q
		c.strokeStyle = "#b2d394"; c.lineWidth = 5; c.beginPath(); c.arc(sq.x, sq.y - 30, 16, -PI / 2, -PI / 2 + PI * 2 * J.num(S.searchP)); c.stroke()
	if J.t(S.sc) and J.num(S.sc.t) >= OMEN:
		var a = S.sc.a; var aq = P(J.num(a.x), floor_, V); var u = minf(1.0, (J.num(S.sc.t) - OMEN) / 0.4); var ah = ph * V.s; var T = J.num(S.t)
		if gk == "eking":
			c.save(); c.globalAlpha = 1 - maxf(0.0, (J.num(S.sc.t) - OMEN - 0.5) / 0.4); c.fillStyle = "#120808"; c.beginPath(); c.ellipse(aq.x, aq.y - ah * 0.55, ah * 0.5 * u, ah * 0.38 * u, 0, 0, 7); c.fill()
			c.fillStyle = "#7a0e0e"; c.beginPath(); c.ellipse(aq.x, aq.y - ah * 0.55, ah * 0.4 * u, ah * 0.24 * u * absf(sin(T * 12)), 0, 0, 7); c.fill(); c.fillStyle = "#e8e0cc"
			for i in 7:
				var tx = aq.x - ah * 0.32 * u + i * ah * 0.1 * u; c.beginPath(); c.moveTo(tx, aq.y - ah * 0.55 - ah * 0.2 * u); c.lineTo(tx + ah * 0.05 * u, aq.y - ah * 0.55 - ah * 0.08 * u); c.lineTo(tx + ah * 0.1 * u, aq.y - ah * 0.55 - ah * 0.2 * u); c.fill()
			c.restore()
		if gk == "tianhua":
			c.strokeStyle = "rgba(12,12,14,0.9)"; c.lineWidth = 2.4; var cy = P(0, J.num(J.gp(lay, "ceil")) + 10, V).y
			var hx = -60
			while hx <= 60:
				c.beginPath(); c.moveTo(aq.x + hx * V.s, cy); c.quadraticCurveTo(aq.x + hx * V.s + sin(T * 6 + hx) * 10, cy + (aq.y - cy) * 0.5 * u, aq.x + hx * V.s, cy + (aq.y - cy) * 0.85 * u); c.stroke(); hx += 7
		if gk == "toyol":
			for j in 6: c.fillStyle = "rgba(40,30,20,0.8)"; c.beginPath(); c.ellipse(aq.x - 80 * V.s + j * 28 * V.s, aq.y - 4, 6, 3, 0, 0, 7); c.fill()
			sprite("toyol", aq.x + sin(T * 20) * 20, aq.y - ah * 0.6, ah * 0.45, {"alpha": 0.8})

func draw() -> void:
	layout(); c.setTransform(DPR, 0, 0, DPR, 0, 0); c.fillStyle = "#0b0b0d"; c.fillRect(0, 0, W, H); BTN = []
	var V = view(); var lay = S.lay; var g0 = G(); var crop = J.gp(lay, "crop"); var ph = J.num(J.gp(lay, "ph")); var floor_ = J.num(J.gp(lay, "floor"))
	var fx = J.num(S.gx)
	if J.t(S.sc) and J.t(S.sc.get("a")): fx = (J.num(S.gx) + J.num(S.sc.a.x)) / 2
	var tgt = J.num(S.cam.free) if S.cam.get("free") != null else fx - V.vw / 2; tgt = clamp_(tgt, 0, maxf(0.0, J.num(J.gp(lay, "W")) - V.vw)); S.cam["x"] = J.num(S.cam.x) + (tgt - J.num(S.cam.x)) * 0.18
	if absf(tgt - J.num(S.cam.x)) < 0.5: S.cam["x"] = tgt
	c.save(); c.beginPath(); c.rect(0, V.top, W, V.ph); c.clip()
	if J.num(S.flash) > 0: c.translate((randf() - 0.5) * 8 * J.num(S.flash), 0)
	drawBG(V)
	var rooms = J.iter(J.gp(lay, "rooms"))
	for i in rooms.size():
		var R = rooms[i]; var a = P(J.num(R.x0), J.num(crop[0]), V); var b = P(J.num(R.x1), J.num(crop[1]), V)
		if b.x < 0 or a.x > W: continue
		if not S.light[i]: c.fillStyle = "rgba(4,4,14," + J.str(0.74 if J.num(S.dark[i]) > 0 else 0.6) + ")"; c.fillRect(a.x, a.y, b.x - a.x, b.y - a.y)
		else:
			var gr = c.createRadialGradient((a.x + b.x) / 2, a.y + 30, 10, (a.x + b.x) / 2, a.y + 30, (b.x - a.x) * 0.8); gr.addColorStop(0, "rgba(255,226,160,0.12)"); gr.addColorStop(1, "rgba(255,226,160,0)"); c.fillStyle = gr; c.fillRect(a.x, a.y, b.x - a.x, b.y - a.y)
		txt(J.str(R.n) + ("・燈著" if S.light[i] else "・黑"), (a.x + b.x) / 2, a.y + 20, 12, "#e8d2a0" if S.light[i] else "#8a7e84")
	var dq = P(J.num(J.gp(lay, "door")), floor_, V); c.fillStyle = "rgba(120,255,190," + J.str(0.2 + 0.15 * sin(J.num(S.t) * 4)) + ")"; c.fillRect(dq.x - 16, dq.y - ph * V.s * 1.05, 32, ph * V.s * 1.05); txt("門口", dq.x, dq.y - ph * V.s * 1.05 - 6, 12, "#a9c79a")
	for p in S.spots: drawSpot(p, V)
	for i in S.search.size():
		var p = S.search[i]; var its = itemsAt(i)
		if its.is_empty(): continue
		var q = P(J.num(p.x), J.num(p.y), V); c.fillStyle = "rgba(230,168,90," + J.str(0.5 + 0.3 * sin(J.num(S.t) * 3 + i)) + ")"; c.beginPath(); c.arc(q.x, q.y, 6, 0, 7); c.fill()
		var cnt = {}; var ord = []
		for k in its:
			var ks = J.str(k)
			if not cnt.has(ks): cnt[ks] = 0; ord.append(ks)
			cnt[ks] += 1
		var parts_ = []
		for k in ord: parts_.append(J.str(J.gp(_item(k), "n")) + ("×" + str(cnt[k]) if cnt[k] > 1 else ""))
		txt("✦" + " ".join(parts_), q.x, q.y - 12, 11, "#e6dcc6")
	if J.str(S.task.k) == "steal" and not J.t(S.task.get("done")):
		var tq = P(J.num(S.task.x), J.num(S.task.y), V); c.strokeStyle = "rgba(178,211,148," + J.str(0.6 + 0.3 * sin(J.num(S.t) * 5)) + ")"; c.lineWidth = 3; c.beginPath(); c.arc(tq.x, tq.y, 14, 0, 7); c.stroke(); txt("任務：" + J.str(S.task.o), tq.x, tq.y - 20, 12, "#b2d394")
	var ord2 = []
	for a in S.actors: if J.str(a.act) == "bed": ord2.append(a)
	for a in S.actors: if J.str(a.act) != "bed": ord2.append(a)
	for a in ord2: drawActor(a, V)
	drawGhost(V)
	for p in S.parts:
		var q = P(J.num(p.x), J.num(p.y), V); var al = J.num(p.life) / J.num(p.max); c.globalAlpha = minf(1.0, al * 1.4)
		var tp = J.str(p.type)
		c.fillStyle = "#9fd0f0" if tp == "drop" else ("#e6c25a" if tp == "coin" else ("rgba(180,170,150,0.6)" if tp == "dust" else ("#e8c07a" if tp == "crumb" else "#f0e0b0")))
		c.beginPath(); c.arc(q.x, q.y, 6 * (1 - al) + 2 if tp == "dust" else 3.0, 0, 7); c.fill(); c.globalAlpha = 1
	for f in S.floats:
		var q = P(J.num(f.x), J.num(f.y), V); c.globalAlpha = minf(1.0, J.num(f.life)); txt(f.t, clamp_(q.x, 80, W - 80), q.y, 15, f.c); c.globalAlpha = 1
	if J.num(S.flash) > 0: c.fillStyle = "rgba(255,250,230," + J.str(J.num(S.flash) * 0.5) + ")"; c.fillRect(0, V.top, W, V.ph)
	c.restore()
	if S.cam.get("free") != null: btn("follow", W / 2 - 66, V.top + 8, 132, 46, "◎ 跟返隻鬼", "moss")
	drawHUD(V, g0)
	drawJoy()

func drawHUD(V: Dictionary, g0) -> void:
	var lay = S.lay; var un = S.un; var T = J.num(_a("TOP")); var hh = J.gp(_a("HH"), J.str(un.hh)); var BOT = J.num(_a("BOT"))
	_fn("crPanel", [c, -8.0, -8.0, W + 16, T + 8, "paper"])
	var fr = minf(1.0, J.num(J.gp(g0, "t")) / (J.num(_a("PHT")) * 3)); _fn("crBar", [c, 12.0, 8.0, W - 24, 13.0, fr, "dawn"])
	var phase = J.num(J.gp(g0, "phase"))
	txt(J.str(J.gp(_a("FLN"), un.f)) + "・" + (J.str(J.gp(hh, "n")) if J.t(hh) else "住戶") + "　" + (J.str(J.gp(_a("PH"), phase)) if phase < 3 else "天光") + "　屋內剩 " + J.str(maxf(0.0, ceil(J.num(S.limit)))) + " 秒", 12, 40, 14, "#e48a78" if J.num(S.limit) < 15 else "#efe5cf", "left", W - 120)
	txt("屋企人警覺", 12, 70, 13, "#e48a78" if J.num(S.alert) >= 70 else "#cfc4b0", "left"); _fn("crBar", [c, 98.0, 58.0, W - 216, 15.0, J.num(S.alert) / 100, "red"]); txt(J.str(J.round(J.num(S.alert))), 98 + (W - 216) / 2, 71, 11, "#efe5cf")
	btn("out", W - 108, 32, 98, 52, "出屋", "moss")
	var y0 = H - BOT; _fn("crPanel", [c, -8.0, y0, W + 16, BOT + 8, "paper"])
	if J.num(S.msgT) > 0 and J.t(S.get("msg")):
		var mh = 56.0; _fn("crPanel", [c, 10.0, y0 - mh - 6, W - 20, mh, "sheet"]); c.font = "bold 13px " + J.str(_a("FONT")); wrapT(J.str(S.msg), 20, y0 - mh + 14, W - 40, 17, S.msgC)
	var rooms = J.iter(J.gp(lay, "rooms")); var n = rooms.size(); var tw = (W - 20 - (n - 1) * 6) / n; var gr = roomAt(J.num(S.gx))
	for i in n:
		var R = rooms[i]; var x = 10 + i * (tw + 6); var ppl = 0
		for a in S.actors: if roomAt(J.num(a.x)) == i and J.str(a.st) != "run": ppl += 1
		btn("room" + str(i), x, y0 + 8, tw, 36, "", "moss" if i == gr else ("rust" if S.light[i] else "ink"))
		txt(J.str(R.n) + (" " + str(ppl) + "人" if ppl else ""), x + tw / 2, y0 + 24, 12, "#efe5cf", "center", tw - 6); txt("燈著" if S.light[i] else "黑", x + tw / 2, y0 + 39, 10, "#efdcb4" if S.light[i] else "#9a8e92", "center")
	var T2 = S.task; txt(("✓ 任務完成：" if J.t(T2.get("done")) else "任務：") + J.str(T2.t), 12, y0 + 64, 13, "#b2d394" if J.t(T2.get("done")) else "#e8d2a0", "left", W - 24)
	var g = S.g; var bx = 10.0; var by = y0 + 76
	btn("scare", bx, by, 104, 58, ("嚇！" + J.str(ceil(J.num(S.scCd)))) if J.num(S.scCd) > 0 and not J.t(S.sc) else "嚇！", "red")
	var icd = J.num(J.gp(g, "invCd"))
	btn("inv", bx + 112, by, 84, 58, ("隱身 " + J.str(ceil(icd))) if icd > 0 else "隱身", "violet", icd <= 0)
	var C = ctxBtn()
	if C != null: btn("ctx", bx + 204, by, W - bx - 214, 58, C.t, C.tone, not (C.get("on") is bool and C.on == false))
	else: txt("行近發光圈＝作怪點", bx + 204 + (W - bx - 214) / 2, by + 34, 12, "#9a8e92", "center", W - bx - 220)
	var keys = J.gp(g0, "keys")
	txt("怕意 " + J.str(J.gp(g0, "fear")) + "　收穫 " + str(J.iter(J.gp(g0, "bag")).size()) + "/" + J.str(_a("BAGMAX")) + "　紙人 " + J.str(J.gp(g0, "dolls")) + "/6　匙 紅" + J.str(J.num(J.gp(keys, "key"))) + " 黃" + J.str(J.num(J.gp(keys, "key2"))), 12, y0 + 156, 12, "#cfc4b0", "left", W - 24)
	txt("拖動＝移動；撳作怪點／住客＝飄過去做；企定喺✦先搜得嘢", W / 2, H - 14, 12, "#9a8e92", "center", W - 16)

func ctxBtn():
	var g = S.g; var a = _fn("ctxAction", [g])
	if J.t(a) and J.str(J.gp(a, "k")) == "deliver": return {"k": "deliver", "t": J.gp(a, "t"), "tone": "moss"}
	var gr = roomAt(J.num(S.gx)); var best = null; var bd = RANGE_HOT + 1
	for p in S.spots:
		if int(J.num(p.room)) != gr: continue
		var d = absf(J.num(p.x) - J.num(S.gx))
		if d < bd: bd = d; best = p
	if best != null:
		if J.num(best.cd) > 0: return {"k": "hot", "p": best, "t": HOT[J.str(best.k)].v + " " + J.str(ceil(J.num(best.cd))) + "s", "tone": "ink", "on": false}
		return {"k": "hot", "p": best, "t": "作怪：" + HOT[J.str(best.k)].v, "tone": "rust"}
	if J.num(S.searchI) >= 0: return {"k": "search", "t": "搜緊……企定", "tone": "ink", "on": false}
	return null

func wrapT(t: String, x: float, y: float, w: float, lh: float, col) -> void:
	var ln = ""; var yy = y
	for i in t.length():
		var tt = ln + t[i]
		if J.num(c.measureText(tt).width) > w:
			txt(ln, x, yy, 13, col, "left"); ln = t[i]; yy += lh
			if yy > y + lh * 1.5: ln = ""; break
		else: ln = tt
	if ln != "": txt(ln, x, yy, 13, col, "left")

func drawJoy() -> void:
	if S == null or not J.t(S.get("joy")) or not J.t(S.joy.get("on")): return
	var j = S.joy; var dx = clamp_(J.num(j.x) - J.num(j.ox), -58, 58); c.save(); c.globalAlpha = 0.7
	_fn("crBlit", [c, _fn("crGet", [116.0, 116.0, "paper", "ring"]), J.num(j.ox) - 58, J.num(j.oy) - 58]); c.globalAlpha = 0.92
	_fn("crBlit", [c, _fn("crGet", [48.0, 48.0, "bone", "ring2"]), J.num(j.ox) + dx - 24, J.num(j.oy) - 24]); c.restore()

# ---------------- 輸入 ----------------
func pt(e) -> Vector2:
	if J.gp(e, "nx") != null: return Vector2(J.num(J.gp(e, "nx")), J.num(J.gp(e, "ny")))
	return Vector2(J.num(J.gp(e, "clientX")), J.num(J.gp(e, "clientY")))
func hit_(x: float, y: float):
	var best = null; var bd = 1e9; var PAD = 10.0
	var i = BTN.size() - 1
	while i >= 0:
		var b = BTN[i]
		if x >= b.x - PAD and x <= b.x + b.w + PAD and y >= b.y - PAD and y <= b.y + b.h + PAD:
			var d = -1.0 if (x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h) else Vector2(x - (b.x + b.w / 2), y - (b.y + b.h / 2)).length()
			if d < bd: bd = d; best = b
		i -= 1
	return best
func on_down(e) -> void:
	if S == null: return
	var p = pt(e); var b = hit_(p.x, p.y)
	if b != null:
		PRESS = {"id": b.id, "t": J.S_performance_("now", [])}; ptr = {"id": J.gp(e, "pointerId"), "btn": b.id, "sx": p.x, "sy": p.y}; S["joy"] = null; return
	var inPlay = p.y > J.num(_a("TOP")) and p.y < H - J.num(_a("BOT"))
	ptr = {"id": J.gp(e, "pointerId"), "sx": p.x, "sy": p.y, "drag": false, "hud": not inPlay}
	if inPlay: S["joy"] = {"ox": p.x, "oy": p.y, "x": p.x, "y": p.y, "on": false}
func on_move(e) -> void:
	if S == null or ptr == null or not J.seq(ptr.id, J.gp(e, "pointerId")): return
	var p = pt(e)
	if not J.t(ptr.get("btn")) and Vector2(p.x - ptr.sx, p.y - ptr.sy).length() > 12: ptr["drag"] = true
	if J.t(S.get("joy")):
		S.joy["x"] = p.x; S.joy["y"] = p.y
		if J.t(ptr.get("drag")): S.joy["on"] = true
func on_up(e) -> void:
	if S == null: ptr = null; return
	if ptr != null and not J.seq(ptr.id, J.gp(e, "pointerId")): return
	var p = pt(e); var was = ptr; ptr = null; var j = J.t(S.get("joy")) and J.t(S.joy.get("on")); S["joy"] = null
	if was == null: return
	if J.t(was.get("btn")):
		var b = hit_(p.x, p.y)
		if (b != null and b.id == was.btn) or Vector2(p.x - was.sx, p.y - was.sy).length() < 24: press(J.str(was.btn))
		return
	if not J.t(was.get("drag")) and not j and not J.t(was.get("hud")): worldTap_(p.x, p.y)

func press(id: String) -> void:
	if S == null: return
	var g0 = G(); var g = S.g
	if id == "out": exit_("door"); return
	if id == "follow": S.cam["free"] = null; return
	if id.begins_with("room"):
		var R = J.gp(S.lay, "rooms")[int(id.substr(4))]; var V = view()
		S.cam["free"] = clamp_((J.num(R.x0) + J.num(R.x1)) / 2 - V.vw / 2, 0, maxf(0.0, J.num(J.gp(S.lay, "W")) - V.vw)); return
	if id == "scare": S.cam["free"] = null; scare(); return
	if id == "inv":
		if J.num(J.gp(g, "invCd")) > 0: return
		S["invT"] = J.num(J.gp(J.gp(g0, "mods"), "inv")) * (J.num(J.gp(g, "im")) if J.t(J.gp(g, "im")) else 1.0)
		J.sp(g, "invCd", J.num(S.invT) + 9 * (J.num(J.gp(g, "icd")) if J.t(J.gp(g, "icd")) else 1.0))
		wfl(J.num(S.gx), J.num(J.gp(S.lay, "floor")) - J.num(J.gp(S.lay, "ph")) - 20, "隱身", "#a9a0d8"); return
	if id == "ctx":
		var C = ctxBtn()
		if C == null: return
		if J.str(C.k) == "deliver": _fn("actPress", []); msg("交還咗失物，佢哋好似冇咁驚喇", "#b2d394"); return
		if J.str(C.k) == "hot": trigger(C.p, false)

func worldTap_(x: float, y: float) -> void:
	var V = view(); var lay = S.lay; var wx = x / V.s + J.num(S.cam.x); var wy = (y - V.top) / V.s + J.num(J.gp(lay, "crop")[0])
	S.cam["free"] = null
	var hs = null; var hd = 60 / V.s
	for p in S.spots:
		var d = Vector2(J.num(p.x) - wx, J.num(p.y) - wy).length()
		if d < hd: hd = d; hs = p
	if hs != null: trigger(hs, false); return
	var ta = null; var td = 1e9; var ph = J.num(J.gp(lay, "ph")); var floor_ = J.num(J.gp(lay, "floor"))
	for a in S.actors:
		if J.str(a.st) == "run": continue
		var h = ph * (0.5 if J.str(a.act) == "bed" and J.str(a.st) == "act" else 1.0)
		if absf(wx - J.num(a.x)) < 70 and wy < floor_ + 20 and wy > floor_ - h - 30:
			var d = absf(wx - J.num(a.x))
			if d < td: td = d; ta = a
	if ta != null: scareAt(ta); return
	var door = J.num(J.gp(lay, "door")); var rooms = J.gp(lay, "rooms")
	if absf(wx - door) < 50: S["goX"] = door + 4; S["pend"] = null; wfl(door, floor_ - ph - 10, "行去門口（撳「出屋」就走得）", "#a9c79a"); return
	S["goX"] = clamp_(wx, J.num(rooms[0].x0) + 14, J.num(rooms[rooms.size() - 1].x1) - 20); S["pend"] = null

# ---------------- 大樓剖面 ----------------
func drawWorld(ctx) -> void:
	var g0 = G()
	if not J.t(g0): return
	var gh = J.gp(g0, "gh"); var g = J.gp(gh, J.gp(g0, "active")); var T = J.num(J.gp(g0, "t")); var nearU = null; var nd = 150.0; var gn = _node(J.gp(g, "node")) if J.t(g) else null
	var units = J.iter(J.gp(g0, "units"))
	if J.t(gn) and not J.t(J.gp(g, "inUnit")):
		for un in units:
			if J.num(un.f) != J.num(J.gp(gn, "f")) or not isHH(un): continue
			var d = absf(J.num(un.x) - J.num(J.gp(g, "x")))
			if d < nd and _is_true(enterable(g, un)): nd = d; nearU = un
	var CL = J.gp(J.G.get("window"), "__twCull"); var FONT = J.str(_a("FONT"))
	for un in units:
		var x = J.num(un.x); var y = J.num(un.y); un["_ib"] = null
		if J.t(CL) and (y < J.num(J.gp(CL, "y0")) or y - 120 > J.num(J.gp(CL, "y1"))): continue
		if J.str(un.get("ot")) == "deity":
			var gr = ctx.createRadialGradient(x, y - 60, 2, x, y - 60, 46); gr.addColorStop(0, "rgba(220,60,40," + J.str(0.32 + 0.08 * sin(T * 2)) + ")"); gr.addColorStop(1, "rgba(220,60,40,0)"); ctx.fillStyle = gr; ctx.fillRect(x - 46, y - 106, 92, 92); ctx.fillStyle = "rgba(200,40,30,0.85)"; ctx.fillRect(x - 4, y - 104, 8, 4); continue
		if not isHH(un): continue
		var I = un.get("iu"); var tags = []
		if J.t(I) and J.t(I.get("done")): tags.append("✓任務")
		var rs = J.iter(un.rs)
		if rs.size():
			var allg = true
			for r in rs: if not (J.str(r.get("state")) == "flee" or J.str(r.get("state")) == "gone"): allg = false; break
			if allg: tags.append("走晒")
		if J.t(I) and J.num(I.ban) > 0: tags.append("封 " + J.str(ceil(J.num(I.ban))) + "s")
		if tags.size():
			ctx.font = "bold 11px " + FONT; ctx.textAlign = "center"; ctx.lineWidth = 3; ctx.strokeStyle = "#000"; var tt = " ".join(tags); ctx.strokeText(tt, x, y - 72); ctx.fillStyle = "#e48a78" if J.t(I) and J.num(I.ban) > 0 else "#b2d394"; ctx.fillText(tt, x, y - 72)
		if not J.t(g) or J.t(J.gp(g, "home")) or J.t(J.gp(g, "out")) or J.t(J.gp(g, "inUnit")) or not is_same(un, nearU): continue
		if not _is_true(enterable(g, un)): continue
		ctx.save(); ctx.globalAlpha = 0.35 + 0.25 * sin(T * 5); ctx.fillStyle = "#78ffbe"; ctx.fillRect(x - 13, y - 62, 26, 58); ctx.restore()
		var bw = 70.0; var bh = 34.0; var bxw = x - bw / 2; var byw = y - 112
		_fn("crBlit", [ctx, _fn("crGet", [bw, bh, "moss", "n"]), bxw, byw]); _fn("crText", [ctx, "入屋", x, byw + bh / 2 + 1, 16.0, "#e4ecd2", "center", bw - 8, true])
		un["_ib"] = {"x": bxw, "y": byw, "w": bw, "h": bh}

func worldTap(wx: float, wy: float) -> bool:
	var g0 = G()
	if not J.t(g0): return false
	var g = J.gp(J.gp(g0, "gh"), J.gp(g0, "active"))
	if not J.t(g) or J.t(J.gp(g, "home")) or J.t(J.gp(g, "out")): return false
	var hitU = null
	for un in J.iter(J.gp(g0, "units")):
		if hitU != null: break
		var b = un.get("_ib")
		var onBtn = J.t(b) and wx >= J.num(b.x) - 8 and wx <= J.num(b.x) + J.num(b.w) + 8 and wy >= J.num(b.y) - 8 and wy <= J.num(b.y) + J.num(b.h) + 8
		var onDoor = absf(wx - J.num(un.x)) < 24 and wy > J.num(un.y) - 70 and wy < J.num(un.y) + 6
		if onBtn or onDoor: hitU = un
	var un = hitU
	if un == null: return false
	if J.str(un.get("ot")) == "deity": blockedMsg(g, un, "deity"); return true
	if not isHH(un): return false
	var ok = enterable(g, un)
	if not _is_true(ok): blockedMsg(g, un, ok); return true
	if J.seq(J.gp(g, "node"), un.did) and not J.t(J.gp(g, "to")): enterFromDoor(g, un); return true
	if J.t(_fn("gotoNode", [g, un.id])): J.sp(g, "autoS", null); _flt(un.x, J.num(un.y) - 96, "行去入屋", "#9fd6bf"); return true
	_flt(un.x, J.num(un.y) - 96, "去唔到", "#ffb0b0"); return true

func action(g, n):
	if J.str(J.gp(n, "kind")) != "door": return null
	var un = null; var g0 = G()
	for u in J.iter(J.gp(g0, "units")): if J.seq(u.get("did"), J.gp(n, "id")): un = u
	if un == null: return null
	if J.str(un.get("ot")) == "deity": return {"k": "unitRespect", "t": "（神明鎮宅：要尊重，唔入）"}
	if not isHH(un): return null
	var ok = enterable(g, un); var hh = J.gp(_a("HH"), J.str(un.hh))
	if _is_true(ok): return {"k": "unitIn", "t": "入屋：" + (J.str(J.gp(hh, "n")) if J.t(hh) else "住戶"), "un": un}
	if J.str(ok) == "ban" or J.str(ok) == "cd":
		return {"k": "unitBan", "t": "（" + ("佢哋開晒燈守住" if J.str(ok) == "ban" else "陰氣未回") + "：" + J.str(ceil(J.num(un.iu.ban) if J.str(ok) == "ban" else J.num(un.iu.cd))) + " 秒）", "un": un}
	return null

func act(g, a) -> bool:
	var k = J.str(J.gp(a, "k"))
	if k == "unitIn": enterFromDoor(g, J.gp(a, "un")); return true
	if k == "unitRespect":
		var g0 = G(); var un = null
		for u in J.iter(J.gp(g0, "units")): if J.seq(u.get("did"), J.gp(g, "node")): un = u; break
		if un != null: blockedMsg(g, un, "deity")
		return true
	if k == "unitBan": var un2 = J.gp(a, "un"); blockedMsg(g, un2, "ban" if J.num(un2.iu.ban) > 0 else "cd"); return true
	return false

# ---------------- 迴圈／測試介面 ----------------
func loop(ts: float) -> void:
	J.F_requestAnimationFrame([func(_t, a): loop(J.num(J.arg(a, 0)))])
	var dt = minf(0.1, (ts - last) / 1000.0) if last else 0.0; last = ts
	if not is_same(G(), lastG): lastG = G(); S = null; vis_on = false; ptr = null
	if running() and not J.t(U.get("manual")): step(dt)
	if not visible() and vis_on: vis_on = false; ptr = null; if S != null: S["joy"] = null

func state():
	if S == null: return null
	var actors = []
	for a in S.actors: actors.append({"hh": a.r.get("hh"), "x": J.round(J.num(a.x)), "room": float(roomAt(J.num(a.x))), "act": a.act, "st": a.st, "awake": J.t(a.r.get("awake")), "fear": J.round(J.num(a.r.get("fear"))), "rstate": a.r.get("state")})
	var spots = []
	for p in S.spots: spots.append({"k": p.k, "x": p.x, "y": p.y, "room": p.room, "cd": J.round(J.num(p.cd))})
	var search = []
	for i in S.search.size(): search.append({"x": S.search[i].x, "y": S.search[i].y, "items": itemsAt(i)})
	var dk = []
	for v in S.dark: dk.append(J.round(J.num(v)))
	return {"un": S.un.id, "hh": S.un.hh, "lay": J.gp(S.lay, "key"), "gx": J.round(J.num(S.gx)), "room": float(roomAt(J.num(S.gx))), "alert": J.round(J.num(S.alert) * 10) / 10, "limit": J.round(J.num(S.limit)), "light": S.light.duplicate(), "dark": dk,
		"task": {"k": S.task.k, "t": S.task.get("t"), "done": J.t(S.task.get("done")), "spot": S.task.get("spot"), "x": S.task.get("x")}, "actors": actors, "spots": spots, "search": search, "err": U.get("_err"), "sc": J.t(S.sc), "scCd": S.scCd, "invT": S.invT, "stun": S.stun}

static func make(api, hooks := true) -> Dictionary:
	var o = new()
	o.A = api
	o._build(hooks)
	return o.U

func _build(hooks: bool) -> void:
	U = {
		"_nat": true, "_self": self,
		"canEnter": func(_t, a): return _is_true(enterable(J.arg(a, 0), J.arg(a, 1))),
		"enterFromDoor": func(_t, a): return enterFromDoor(J.arg(a, 0), J.arg(a, 1)),
		"arrive": func(_t, a): return arrive_(J.arg(a, 0), J.arg(a, 1)),
		"exit": func(_t, a): return exit_(J.arg(a, 0)),
		"step": func(_t, a): step(J.num(J.arg(a, 0))); return null,
		"scare": func(_t, a): return scare(J.arg(a, 0)),
		"drawWorld": func(_t, a): drawWorld(J.arg(a, 0)); return null,
		"worldTap": func(_t, a): return worldTap(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))),
		"action": func(_t, a): return action(J.arg(a, 0), J.arg(a, 1)),
		"act": func(_t, a): return act(J.arg(a, 0), J.arg(a, 1)),
		"holds": func(_t, a): return S != null and is_same(S.g, J.arg(a, 0)),
		"covering": func(_t, _a2): return visible(),
		"on": func(_t, _a2): return S != null,
		"drawN": func(_t, a):
			if S == null: return null
			c = J.arg(a, 0); draw(); c = null
			return null,
		"state": func(_t, _a2): return state(),
		"camSnap": func(_t, _a2):
			if S == null: return null
			var V = view(); S.cam["x"] = clamp_(J.num(S.cam.free) if S.cam.get("free") != null else J.num(S.gx) - V.vw / 2, 0, maxf(0.0, J.num(J.gp(S.lay, "W")) - V.vw))
			return null,
		"btns": func(_t, _a2):
			var out = []
			for b in BTN: out.append({"id": b.id, "x": b.x, "y": b.y, "w": b.w, "h": b.h})
			return out,
		"setAlert": func(_t, a):
			if S != null: S["alert"] = J.num(J.arg(a, 0))
			return null,
		"setGX": func(_t, a):
			if S != null: S["gx"] = J.num(J.arg(a, 0)); S["goX"] = null
			return null,
		"trig": func(_t, a): return trigger(S.spots[int(J.num(J.arg(a, 0)))], false) if S != null else false,
		"press": func(_t, a): press(J.str(J.arg(a, 0))); return null,
		"layFor": func(_t, a): return layFor(J.arg(a, 0)),
		"HOT": HOT.duplicate(true),
		"_S": func(_t, _a2): return S,
		"tap": func(_t, a):
			if S != null: worldTap_(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))
			return null,
	}
	if not hooks: return
	var w = J.G.get("window")
	J.sp(w, "__twUPD", func(_t, a): on_down(J.arg(a, 0)); return null)
	J.sp(w, "__twUPM", func(_t, a): on_move(J.arg(a, 0)); return null)
	J.sp(w, "__twUPU", func(_t, a): on_up(J.arg(a, 0)); return null)
	J.F_requestAnimationFrame([func(_t, a): loop(J.num(J.arg(a, 0)))])
