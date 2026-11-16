# 原生改寫自 tower.js 第一段：window.LiftSys（樓裡有鬼——電梯系統）
# 規則（調度、搭𨋢嘅人、作怪招、鬼入出𨋢）＋世界剖面層（drawWorld）＋𨋢廂內景（drawCab）＋原生面板用嘅 ui()/layoutN()
# 隨機數：A.rnd（關卡種子）同 Math.random（對白洗牌、畫面震）用法、次序同轉譯版一樣
# DOM 疊層／蠟筆框 dataURL／WebAudio 冇搬：Godot 版面板由 tw_run.gd 原生畫，聲喺 Godot 本身就係靜音（冇 AudioContext）
# 陣列迭代跟轉譯版：forEach 迭代副本、filter/some/find 迭代原陣列
extends RefCounted

const CAP := 4
const VMAX := 0.75
const ACC := 1.4
const DOOR_T := 0.5
const HOLD := 2.6
const TR := {
	"dark": {"n": "熄燈", "cd": 14.0, "f": 34.0, "d": "閃兩下熄晒，黑暗中有人唞氣"},
	"btns": {"n": "亂按", "cd": 18.0, "f": 22.0, "d": "全部樓層掣自己亮，層層都停"},
	"mirror": {"n": "鏡中影", "cd": 16.0, "f": 38.0, "d": "𨋢鏡多咗個人影"},
	"over": {"n": "超重", "cd": 20.0, "f": 26.0, "d": "超重警報響，但得佢一個"},
	"stuck": {"n": "卡𨋢", "cd": 26.0, "f": 45.0, "d": "停喺兩層中間，門開一半見到牆"},
	"door": {"n": "嚇門口", "cd": 10.0, "f": 40.0, "d": "開門嚇喺門口等𨋢嘅人"},
}
const TRK := ["dark", "btns", "mirror", "over", "stuck", "door"]
const LN := {
	"wait": ["部𨋢又停咗喺頂樓……", "撳咗好耐都未嚟", "快啲啦，好肚餓", "呢部𨋢慢到死", "等𨋢等到頸都長", "係咪又有人㩒住度門？"],
	"board": ["唔該等等！", "唔該借借", "唔該撳埋我嗰層", "入面仲有位嘛？", "唔該，等埋我"],
	"full": ["滿咗？等下一轉啦", "咁多人，我等陣先"],
	"snack": ["落樓下打包碗雲吞麵先", "去士多買支維他奶", "茶餐廳仲開，去買個菠蘿油", "肚餓，落去買宵夜"],
	"back": ["買到宵夜喇，返上去食", "好彩仲有得買", "返屋企食住睇劇先"],
	"work": ["返通宵更喇，遲到就死", "的士要交更，走先"],
	"dark": ["嘩！做咩黑晒呀？！", "邊個喺度唞氣……？", "唔好玩啦，開返盞燈啦！", "我好似聽到有人喺我耳邊抖氣……"],
	"btns": ["邊個撳晒啲掣呀？！", "我冇撳過㗎……", "層層停，停到幾時呀？", "啲掣自己亮㗎？！"],
	"mirror": ["面鏡……我後面多咗個人……", "頭先係咪有人企喺我後面？", "我唔敢再望面鏡喇", "鏡入面嗰個唔係我……"],
	"over": ["超重？得我一個人咋喎！", "響乜嘢呀，我好重咩……", "咪嚇我啦，入面冇其他人㗎", "超重……咁即係仲有邊個喺度？"],
	"stuck": ["卡住咗？！開門呀！", "得半度門，出面係牆呀！", "救命呀，有冇人聽到呀？", "唔好喺度停呀，求下你郁啦"],
	"bolt": ["我行樓梯好過！", "唔搭喇唔搭喇！", "走呀——！", "俾我出去！"],
	"cower": ["我唔郁……我乜都冇見到……", "快啲到啦，快啲到啦……", "唔關我事，唔好搵我……"],
	"land": ["嘩！部𨋢入面黑麻麻冇人㗎……", "做咩自己開門嘅？！", "入面……入面有嘢呀！", "我唔搭喇，行樓梯！"],
	"gReport": ["管理處，管理處，部𨋢有啲古怪，我落機房睇睇。", "Over，𨋢又壞，我去機房check吓。", "對講機：𨋢有問題，我而家去機房。"],
	"gLand": ["咦？部𨋢自己開門？", "冇人㗎喎……奇怪", "邊個喺度玩部𨋢？"],
	"gBack": ["機房搞掂，冇事喎……奇怪。", "電掣冇跳過，鬼知咩事。", "檢查完，部𨋢冇壞……"],
	"gRide": ["搭𨋢巡上去睇睇", "行樓梯行到腳軟，搭𨋢啦", "上去巡下先"],
}

var A                       # 樓裡有鬼交過嚟嘅 api（有 __getters）
var L: Dictionary = {}      # 對外（window.LIFT）
var S = null                # 電梯狀態（Dictionary）
var lastG = null
var lnUsed := {}
var ui_on := false
var ui_show := false
var built := -1
var tex = null
var last := 0.0

# ---------------- 工具 ----------------
func _a(k: String): return J.gp(A, k)
func G(): return _a("G")
func FL() -> float: return J.num(_a("FL"))
func top() -> float: return FL() - 1
func fy(f) -> float: return J.num(J.cl(_a("fy"), null, [f]))
static func lab(f) -> String:
	var n = J.num(f)
	return "B" if n == 0 else ("G" if n == 1 else J.str(n - 1))
static func K(f) -> String: return J.str(J.num(f))     # 物件 key（同轉譯版一樣用字串）
func fyf(p: float) -> float:
	var a = floor(p); var b = minf(top(), a + 1); var fr = p - a
	return fy(a) + (fy(b) - fy(a)) * fr
func col() -> Dictionary:
	var LV = _a("LV"); var xs = J.gp(LV, "xs")
	if J.t(xs):
		for q in J.iter(xs):
			if J.str(J.gp(q, 2)) == "lift":
				var x0 = J.num(J.gp(q, 0)); var x1 = J.num(J.gp(q, 1))
				return {"x0": x0, "x1": x1, "cx": (x0 + x1) / 2}
	var MX = J.num(J.gp(LV, "MX"))
	return {"x0": MX - 42, "x1": MX + 42, "cx": MX}
func FH() -> float: return absf(fy(0) - fy(1))
func rnd() -> float:
	var r = _a("rnd")
	return J.num(J.cl(r, null, [])) if J.t(r) else randf()
func pick(a: Array): return a[int(floor(rnd() * a.size()))]
func cabF() -> float: return J.round(J.num(S.pos))
func atFloor() -> bool: return absf(J.num(S.pos) - J.round(J.num(S.pos))) < 0.002
func ghost():
	if S != null and S.gi != null: return J.gp(J.gp(G(), "gh"), S.gi)
	return null
func gpm() -> float:
	var TW = J.gp(J.G.get("window"), "TW")
	if TW != null and J.t(J.gp(TW, "gpF")) and S != null and S.gi != null:
		var v = J.cl(J.gp(TW, "gpF"), null, [S.gi])
		return J.num(v) if J.t(v) else 1.0
	return 1.0
static func sayR(o, t) -> void: o["say"] = t; o["sayT"] = 2.8
func fl(x, y, t, c) -> void:
	var f = _a("float")
	if f != null: J.cl(f, null, [x, y, t, c])
func riderSpr(o):
	if J.str(o.kind) == "guard":
		var HUM = _a("HUM"); var hk = J.gp(HUM, J.str(J.gp(o.ref, "kind"))) if HUM != null else null
		var sp = J.gp(hk, "spr") if hk != null else null
		return sp if J.t(sp) else "res_guard"
	return J.gp(o.ref, "sprite")
func _pplfx(): return J.gp(J.G.get("window"), "PPLFX")
func rKey(o):
	var k = riderSpr(o); var F = _pplfx()
	return J.mc(F, "key", [k, J.str(o.mood) == "bolt" or J.str(o.mood) == "cower"]) if J.t(F) else k
func rH(o, k, h):
	var F = _pplfx()
	return J.mc(F, "hgt", [riderSpr(o), k, h]) if J.t(F) else h
func inCab() -> Array:
	var r = []
	for o in S.riders: if J.str(o.ph) == "ride": r.append(o)
	return r
func resIn() -> Array:
	var r = []
	for o in inCab(): if J.str(o.kind) == "res": r.append(o)
	return r
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
static func _rm(arr: Array, o) -> void:
	# arr.splice(arr.indexOf(o),1)：搵唔到就剷最後一個（同 JS／轉譯版一樣）
	var i = -1
	for k in arr.size(): if is_same(arr[k], o): i = k; break
	if i < 0: i = arr.size() - 1
	if i >= 0 and arr.size(): arr.remove_at(i)
func _push(arr_owner, key: String, v) -> void: J.mc(J.gp(arr_owner, key), "push", [v])

func reset() -> void:
	lastG = G(); lnUsed = {}
	var LV = _a("LV")
	S = {"on": J.t(LV) and J.t(J.gp(LV, "lift")), "pos": 1.0, "v": 0.0, "dir": 0.0, "st": "idle", "door": 0.0, "hold": 0.0, "target": null, "stops": {}, "lit": {}, "riders": [], "away": [], "mroom": [],
		"gi": null, "gCall": null, "dfx": {}, "prevSt": "idle", "cd": {}, "fx": {"dark": 0.0, "mirror": 0.0, "over": 0.0, "flick": 0.0, "btnAll": 0.0}, "stuckT": 0.0, "stuckTo": null, "spawnT": 6.0, "gSpawnT": 14.0, "t": 0.0, "log": [], "shake": 0.0, "ext": null}
	for k in TRK: S.cd[k] = 0.0
	hideUI()

# ---------------- 調度 ----------------
func wanted() -> Dictionary:
	var w = {}
	for k in S.stops: w[k] = 1.0
	var room = CAP - inCab().size()
	for o in S.riders.duplicate():
		if J.str(o.ph) == "ride": w[K(o.dest)] = 1.0
		if J.str(o.ph) == "wait" and room > 0: w[K(o.f)] = 1.0
	if S.gCall != null: w[K(S.gCall)] = 1.0
	return w

func chooseTarget():
	var w = wanted(); var p = J.num(S.pos); var keys = []
	for k in w:
		var f = J.num(k)
		if f >= 0 and f <= top(): keys.append(f)
	var k2 = []
	for f in keys: if absf(f - p) > 0.01 or J.str(S.st) == "idle": k2.append(f)
	keys = k2
	if keys.is_empty(): return null
	var up = []; var dn = []; var here = []
	for f in keys:
		if f > p + 0.01: up.append(f)
		if f < p - 0.01: dn.append(f)
		if absf(f - p) <= 0.01: here.append(f)
	up.sort(); dn.sort(); dn.reverse()
	if here.size() and J.str(S.st) == "idle": return here[0]
	if J.num(S.dir) >= 0 and up.size(): return up[0]
	if J.num(S.dir) <= 0 and dn.size(): return dn[0]
	return up[0] if up.size() else (dn[0] if dn.size() else null)

func startMove(t) -> void: S["target"] = t; S["dir"] = 1.0 if J.num(t) > J.num(S.pos) else -1.0; S["st"] = "move"

func arrive() -> void:
	var f = cabF(); S["pos"] = f; S["v"] = 0.0; S.stops.erase(K(f)); S.lit.erase(K(f))
	if S.gCall != null and J.num(S.gCall) == f: S["gCall"] = null
	S["st"] = "opening"; S["target"] = null
	var c = col(); var y = fy(f)
	var g = ghost(); var hasPeople = inCab().size() > 0
	if not hasPeople:
		for o in S.riders: if J.str(o.ph) == "wait" and J.num(o.f) == f: hasPeople = true; break
	if g == null and not hasPeople:
		var nz = _a("noise")
		if nz != null: J.cl(nz, null, ["f" + J.str(f) + "_l", 2.0])
		fl(c.cx, y - 90, "叮——（" + lab(f) + " 樓𨋢門自己開咗）", "#ffd54a")

func boardAndExit(dt: float) -> void:
	var f = cabF(); var c = col()
	S["xT"] = J.num(S.get("xT")) - dt
	if J.num(S.xT) > 0: return
	S["xT"] = 0.35
	var out = null
	for o in inCab():
		if J.num(o.dest) == f or J.str(o.mood) == "bolt" or J.str(o.mood) == "mroom": out = o; break
	if out != null: exitRider(out, f); dingFx(f, true); S["hold"] = maxf(J.num(S.hold), 1.0); return
	var w = null
	for o in S.riders: if J.str(o.ph) == "wait" and J.num(o.f) == f: w = o; break
	if w != null:
		if inCab().size() >= CAP:
			if not J.t(w.get("fullSaid")): w["fullSaid"] = 1.0; sayR(w, line("full"))
			return
		w["ph"] = "ride"; dingFx(f, true); w["x"] = c.cx + (inCab().size() - 1.5) * 10
		sayR(w, line("board") if rnd() < 0.5 else lab(w.dest) + "樓，唔該"); S["hold"] = maxf(J.num(S.hold), 1.2)

func exitRider(o, f: float) -> void:
	var c = col(); var y = fy(f); var g0 = G(); _rm(S.riders, o)
	if J.str(o.kind) == "guard":
		var h = o.ref; h["to"] = null; h["path"] = null; h["p"] = 0.0; h["node"] = "f" + J.str(f) + "_l"; h["x"] = c.cx; h["y"] = y; h["wait"] = 0.8
		if J.str(o.mood) == "mroom":
			S.mroom.append({"h": h, "t": 22.0}); fl(c.cx, y - 110, "保安去咗機房（離開巡邏 22 秒）", "#9fd6bf"); log_("mroom"); return
		h["state"] = "patrol"; _push(g0, "guards", h); return
	var r = o.ref; r["y"] = y - 16
	if J.str(o.mood) == "bolt":
		r["state"] = "flee"; r["vx"] = (-1.0 if rnd() < 0.5 else 1.0) * 150; r["x"] = c.cx; _push(g0, "res", r)
		var F = _pplfx()
		if J.t(F): J.mc(F, "screamOn", [r])
		else: sayR(r, line("bolt"))
		r["sayT"] = 2.4; log_("bolt"); return
	if J.str(o.get("trip")) == "back": o["ph"] = "walkHome"; o["f"] = f; o["x"] = c.cx; S.riders.append(o); return
	if J.str(o.get("trip")) == "snack": S.away.append({"o": o, "t": 16 + rnd() * 12})

# ---------------- 搭𨋢嘅人 ----------------
func spawnResident():
	var g0 = G(); var cand = []
	for r in J.iter(J.gp(g0, "res")):
		var un = r.get("unit")
		if J.str(r.get("state")) == "home" and not (r.get("awake") is bool and r.get("awake") == false) and not (J.num(r.get("fear")) > 40) and J.t(un) and J.num(un.f) >= 2 and J.num(un.f) <= top() and not J.t(r.get("liftUsed")) and J.str(un.get("ot")) != "deity": cand.append(r)
	if cand.is_empty(): return null
	var r = pick(cand); return addResRider(r, "snack")

func addResRider(r, trip, dest = null):
	var g0 = G(); var arr = J.gp(g0, "res"); var i = -1
	for k in arr.size(): if is_same(arr[k], r): i = k; break
	if i >= 0: arr.remove_at(i)
	r["state"] = "lift"; r["liftUsed"] = 1.0
	var o = {"kind": "res", "ref": r, "f": r.unit.f, "dest": dest if dest != null else 1.0, "ph": "walk", "x": r.x, "trip": trip if J.t(trip) else "snack", "fear": 0.0, "mood": "ok", "say": null, "sayT": 0.0}
	sayR(o, line("work" if J.str(o.trip) == "work" else "snack")); S.riders.append(o); return o

func spawnGuard():
	var g0 = G(); var c = col(); var cand = []
	for h in J.iter(J.gp(g0, "guards")):
		var n = J.gp(J.gp(g0, "nodes"), J.str(h.get("node")))
		if J.str(h.get("kind")) == "guard" and J.str(h.get("state")) == "patrol" and J.t(n) and J.num(J.gp(n, "f")) <= top() and absf(J.num(h.x) - c.cx) < 240 and not J.t(h.get("liftCd")): cand.append(h)
	if cand.is_empty(): return null
	var h = pick(cand); return addGuardRider(h)

func addGuardRider(h, dest = null):
	var g0 = G(); var n = J.gp(J.gp(g0, "nodes"), J.str(h.get("node"))); var arr = J.gp(g0, "guards"); var i = -1
	for k in arr.size(): if is_same(arr[k], h): i = k; break
	if i >= 0: arr.remove_at(i)
	var f = J.num(J.gp(n, "f")) if J.t(n) else 1.0; var d = dest
	if d == null:
		while true:
			d = floor(rnd() * (top() + 1))
			if not (d == f and top() > 0): break
	var o = {"kind": "guard", "ref": h, "f": f, "dest": d, "ph": "walk", "x": h.x, "trip": "patrol", "mood": "ok", "say": null, "sayT": 0.0}
	sayR(o, line("gRide")); S.riders.append(o); return o

# ---------------- 鬼 ----------------
func _node(g): return J.gp(J.gp(G(), "nodes"), J.str(J.gp(g, "node")))

func action(g, n):
	if S == null or not J.t(S.on) or not J.t(g) or J.t(J.gp(g, "home")) or J.t(J.gp(g, "out")): return null
	if not J.t(n): n = _node(g)
	if not J.t(n) or J.str(J.gp(n, "kind")) != "lift" or J.num(J.gp(n, "f")) > top(): return null
	if S.gi != null: return null
	return {"k": "liftIn", "t": "等緊𨋢……（再撳取消）" if S.gCall != null and J.num(S.gCall) == J.num(J.gp(n, "f")) else "入𨋢（撳掣叫𨋢）"}

func enter(g):
	if S == null or not J.t(S.on): return false
	var n = _node(g)
	if not J.t(n) or J.str(J.gp(n, "kind")) != "lift": return false
	var f = J.num(J.gp(n, "f"))
	if S.gCall != null and J.num(S.gCall) == f:
		S["gCall"] = null; S["gWait"] = null; fl(J.gp(g, "x"), J.num(J.gp(g, "y")) - 80, "唔等喇", "#ffd54a"); return false
	if atFloor() and cabF() == f and (J.str(S.st) == "open" or J.str(S.st) == "opening" or J.str(S.st) == "idle"): doEnter(g, f); return true
	S["gCall"] = f; S["gWait"] = J.gp(g, "i"); fl(J.gp(g, "x"), J.num(J.gp(g, "y")) - 80, "撳咗𨋢掣，等緊𨋢……", "#ffd54a"); return "called"

func doEnter(g, f) -> void:
	S["gi"] = J.gp(g, "i"); S["gCall"] = null; S["gWait"] = null; J.sp(g, "to", null); J.sp(g, "auto", null); J.sp(g, "autoS", null)
	if J.str(S.st) == "idle": S["st"] = "opening"
	S["hold"] = maxf(J.num(S.hold), 3.5); dingFx(f); log_("enter"); showUI()
	var ts = _a("toast")
	if J.t(ts): J.cl(ts, null, ["入咗𨋢：揀樓層、撳開關門。有人一齊搭嘅時候，上面會出「𨋢內嚇人」。"])

func exit_() -> bool:
	var g = ghost()
	if g == null: return false
	if not (J.str(S.st) == "open" and J.num(S.door) > 0.8 and atFloor()): flash("門未開，出唔到"); return false
	var f = cabF(); var c = col(); S["gi"] = null
	J.sp(g, "node", "f" + J.str(f) + "_l"); J.sp(g, "to", null); J.sp(g, "x", c.cx); J.sp(g, "y", fy(f)); J.sp(g, "inv", 0.0); J.sp(g, "still", 1.0)
	dingFx(f)
	if J.str(S.st) == "open": S["hold"] = maxf(J.num(S.hold), 0.8)
	hideUI(); log_("exit"); return true

func press(f0) -> void:
	if S == null or S.gi == null: return
	var f = J.num(f0)
	if atFloor() and cabF() == f and J.str(S.st) != "move": open_(); return
	if J.str(S.st) == "stuck" or J.str(S.st) == "stuckMove": flash("卡住咗，掣冇反應"); return
	S.stops[K(f)] = 1.0; S.lit[K(f)] = 1.0
	if J.str(S.st) == "open": S["hold"] = minf(J.num(S.hold), 0.9)
	log_("press" + J.str(f))

func open_() -> void:
	if S == null or S.gi == null: return
	var st = J.str(S.st)
	if st == "move" or st == "stuckMove" or st == "stuck": flash("行緊，開唔到門" if st == "move" else "卡住咗，門開唔到"); return
	if st == "closing" or st == "idle": S["st"] = "opening"
	S["hold"] = maxf(J.num(S.hold), 3.0)

func close_() -> void:
	if S == null or S.gi == null: return
	if J.num(S.fx.over) > 0: flash("超重！門閂唔到"); return
	if J.str(S.st) == "open" or J.str(S.st) == "opening": S["st"] = "closing"; S["hold"] = 0.0

func _waitAt(f: float) -> bool:
	for o in S.riders: if J.str(o.ph) == "wait" and J.num(o.f) == f: return true
	return false

func canTrick(k: String):
	if S == null or S.gi == null: return "out"
	if J.num(S.cd[k]) > 0: return "cd"
	if k == "door":
		var f = cabF()
		if not atFloor() or J.str(S.st) == "move" or J.str(S.st).find("stuck") == 0: return "nolanding"
		return true if _waitAt(f) else "nolanding"
	if inCab().is_empty(): return "empty"
	if k == "stuck" and (J.str(S.st) == "stuck" or J.str(S.st) == "stuckMove"): return "busy"
	return true

func trick(k: String) -> bool:
	var ok = canTrick(k)
	if not (ok is bool and ok):
		if J.str(ok) == "cd": flash(TR[k].n + "冷卻中")
		elif J.str(ok) == "empty": flash("𨋢入面冇人")
		elif J.str(ok) == "nolanding": flash("門口冇人等𨋢")
		return false
	var T = TR[k]; var g = ghost(); var c = col(); S.cd[k] = T.cd; log_("trick:" + k)
	if k == "dark": S.fx["dark"] = 4.2
	if k == "btns":
		if not J.t(S.get("btnsSet")): S["btnsSet"] = {}
		var f = 0.0
		while f <= top():
			if (f != cabF() or not atFloor()) and not J.t(S.stops.get(K(f))): S.stops[K(f)] = 1.0; S.lit[K(f)] = 1.0; S.btnsSet[K(f)] = 1.0
			f += 1
		S["btnsUntil"] = J.num(S.t) + 30; S.fx["btnAll"] = 3.0
	if k == "mirror": S.fx["mirror"] = 3.6
	if k == "over":
		S.fx["over"] = 3.6
		if J.str(S.st) == "closing": S["st"] = "opening"
	if k == "stuck":
		var mid = minf(top() - 0.5, maxf(0.5, floor(J.num(S.pos)) + 0.5))
		if J.num(S.dir) < 0 and not atFloor(): mid = maxf(0.5, ceil(J.num(S.pos)) - 0.5)
		S["stuckTo"] = mid; S["st"] = "stuckMove"; S["stuckT"] = 5.5
		if J.num(S.door) > 0: S["door"] = 0.0
	if k == "door":
		S.fx["dark"] = maxf(J.num(S.fx.dark), 2.2); scareLanding()
		var af = _a("addFear")
		if J.t(af): J.cl(af, null, [J.round(T.f * 0.4 * gpm()), c.cx, fyf(J.num(S.pos)) - 120])
		return true
	var tot = 0.0
	for o in inCab():
		if J.str(o.kind) == "guard":
			sayR(o, line("gReport")); o["mood"] = "mroom"; tot += 8; fl(c.cx, fyf(J.num(S.pos)) - 130, "保安用對講機報𨋢故障", "#ffb0b0"); continue
		var r = o.ref; var amt = T.f * (1 - J.num(r.get("brave"))) * gpm(); o["fear"] = J.num(o.fear) + amt; r["fear"] = J.num(r.get("fear")) + amt * 0.3; tot += amt
		if J.num(o.fear) >= 60 or k == "stuck" and J.num(o.fear) >= 45: o["mood"] = "bolt"; sayR(o, line(k))
		else: o["mood"] = "cower"; sayR(o, line(k))
	var add = maxf(4.0, J.round(tot * 0.35))
	var af2 = _a("addFear")
	if J.t(af2): J.cl(af2, null, [add, c.cx, fyf(J.num(S.pos)) - 110])
	if g != null: J.sp(g, "energy", minf(100.0, J.num(J.gp(g, "energy")) + 6))
	S["shake"] = 0.35; return true

func _spook(h, t) -> void:
	var sp = _a("spook")
	if sp != null: J.cl(sp, null, [h, t])

func scareLanding() -> void:
	var f = cabF(); var c = col(); var y = fy(f); var g0 = G()
	var lst = []
	for o in S.riders: if J.str(o.ph) == "wait" and J.num(o.f) == f: lst.append(o)
	for o in lst:
		_rm(S.riders, o)
		if J.str(o.kind) == "guard":
			var h = o.ref; h["node"] = "f" + J.str(f) + "_l"; h["to"] = null; h["p"] = 0.0; h["x"] = c.cx - 30; h["y"] = y; h["state"] = "patrol"; _push(g0, "guards", h); _spook(h, line("gLand")); continue
		var r = o.ref; r["state"] = "flee"; r["vx"] = (-1.0 if J.num(o.x) < c.cx else 1.0) * 160; r["x"] = o.x; r["y"] = y - 16; _push(g0, "res", r); sayR(r, line("land")); r["sayT"] = 2.4

func dingFx(f, quiet := false) -> void:
	if S == null: return
	var d = S.dfx.get(K(f))
	if d != null and J.num(d.t) < 0.8: return
	S.dfx[K(f)] = {"t": 0.0}

func scareWaiting(g) -> float:
	if S == null or not J.t(S.on) or not J.t(g): return 0.0
	var n = _node(g)
	if not J.t(n): return 0.0
	var f = J.num(J.gp(n, "f")); var y = fy(f); var g0 = G(); var c = col(); var got = 0
	var gx = J.num(J.gp(g, "x")); var lst = []
	for o in S.riders:
		var ph = J.str(o.ph)
		if (ph == "wait" or ph == "walk" or ph == "walkHome") and J.num(o.f) == f and absf(J.num(o.x) - gx) < 150: lst.append(o)
	for o in lst:
		_rm(S.riders, o); got += 1
		if J.str(o.kind) == "guard":
			var h = o.ref; h["node"] = "f" + J.str(f) + "_l"; h["to"] = null; h["p"] = 0.0; h["x"] = o.x; h["y"] = y; h["state"] = "patrol"; _push(g0, "guards", h); _spook(h, line("gLand")); continue
		var r = o.ref; r["state"] = "flee"; r["vx"] = (-1.0 if J.num(o.x) < gx else 1.0) * 160; r["x"] = o.x; r["y"] = y - 16; _push(g0, "res", r)
		var F = _pplfx()
		if J.t(F): J.mc(F, "screamOn", [r])
		else: sayR(r, line("bolt"))
		r["sayT"] = 2.4
	if got:
		var af = _a("addFear")
		if J.t(af): J.cl(af, null, [10.0 * got, gx, y - 110])
		J.sp(g, "dir", 1.0); log_("scareWait")
	return float(got)

func flash(m: String) -> void:
	S["msg"] = m; S["msgT"] = 1.6
	var g = ghost()
	if g != null: fl(J.gp(g, "x"), J.num(J.gp(g, "y")) - 120, m, "#ffd54a")
func log_(e: String) -> void:
	S.log.append(e)
	if S.log.size() > 80: S.log.pop_front()

# ---------------- 主推進 ----------------
func step(dt: float) -> void:
	if not is_same(G(), lastG): reset()
	if S == null or not J.t(S.on) or not J.t(G()): return
	var g0 = G(); S["t"] = J.num(S.t) + dt
	for k in S.cd: S.cd[k] = maxf(0.0, J.num(S.cd[k]) - dt)
	if J.t(S.get("btnsUntil")) and J.num(S.t) >= J.num(S.btnsUntil):
		S["btnsUntil"] = 0.0
		var bs = S.get("btnsSet") if S.get("btnsSet") is Dictionary else {}
		for bf in bs.keys(): S.stops.erase(bf); S.lit.erase(bf)
		S["btnsSet"] = {}; log_("btnsReset")
	for q in S.fx: S.fx[q] = maxf(0.0, J.num(S.fx[q]) - dt)
	S["shake"] = maxf(0.0, J.num(S.shake) - dt); S["msgT"] = maxf(0.0, J.num(S.get("msgT")) - dt)
	S["spawnT"] = J.num(S.spawnT) - dt
	if J.num(S.spawnT) <= 0:
		S["spawnT"] = 11 + rnd() * 9
		var nres = 0
		for o in S.riders: if J.str(o.kind) == "res": nres += 1
		if nres < 5: spawnResident()
	S["gSpawnT"] = J.num(S.gSpawnT) - dt
	if J.num(S.gSpawnT) <= 0: S["gSpawnT"] = 18 + rnd() * 10; spawnGuard()
	var na = []; var aw: Array = S.away
	var i = 0
	while i < aw.size():
		var a = aw[i]; a["t"] = J.num(a.t) - dt
		if J.num(a.t) > 0: na.append(a)
		else:
			var o = a.o; o["ph"] = "wait"; o["f"] = 1.0; o["dest"] = J.gp(J.gp(o.ref, "unit"), "f"); o["trip"] = "back"; o["x"] = col().cx - 46; o["mood"] = "ok"; o["fear"] = 0.0; sayR(o, line("back")); S.riders.append(o)
		i += 1
	S["away"] = na
	var nm = []; var mr: Array = S.mroom
	i = 0
	while i < mr.size():
		var m = mr[i]; m["t"] = J.num(m.t) - dt
		if J.num(m.t) > 0: nm.append(m)
		else:
			var h = m.h; var nodes = J.gp(g0, "nodes"); var nid = "f1_s" if J.t(J.gp(nodes, "f1_s")) else "f0_s"; var n = J.gp(nodes, nid)
			h["node"] = nid; h["to"] = null; h["p"] = 0.0; h["x"] = J.gp(n, "x"); h["y"] = J.gp(n, "y"); h["state"] = "patrol"; h["wait"] = 1.0; h["say"] = line("gBack"); h["sayT"] = 2.6; h["liftCd"] = 1.0; _push(g0, "guards", h)
		i += 1
	S["mroom"] = nm
	var c = col()
	for o in S.riders.duplicate():
		o["sayT"] = maxf(0.0, J.num(o.get("sayT")) - dt)
		if J.num(o.sayT) <= 0: o["say"] = null
		var ph = J.str(o.ph)
		if ph == "walk":
			var slot = 0
			for p in S.riders: if J.str(p.ph) == "wait" and J.num(p.f) == J.num(o.f): slot += 1
			var tx = c.cx - 44 - slot * 16; var ox = J.num(o.x)
			o["x"] = ox + signf(tx - ox) * minf(absf(tx - ox), (36.0 if J.str(o.kind) == "guard" else 62.0) * dt)
			if absf(tx - J.num(o.x)) < 1: o["ph"] = "wait"; o["waitT"] = 0.0
		elif ph == "wait":
			o["waitT"] = J.num(o.get("waitT")) + dt
			if J.num(o.waitT) > 7 and not J.t(o.get("said")): o["said"] = 1.0; sayR(o, line("wait"))
		elif ph == "walkHome":
			var r = o.ref; var rx = J.gp(r.unit, "rx"); var hx = J.num(rx[0]) + (J.num(rx[1]) - J.num(rx[0])) * 0.42; var ox2 = J.num(o.x)
			o["x"] = ox2 + signf(hx - ox2) * minf(absf(hx - ox2), 62 * dt)
			if absf(hx - J.num(o.x)) < 1:
				_rm(S.riders, o); r["x"] = hx; r["y"] = fy(J.gp(r.unit, "f")) - 16; r["state"] = "home"; r["fear"] = maxf(0.0, J.num(r.get("fear"))); _push(g0, "res", r)
				if J.t(r.get("unit")): J.sp(r.unit, "doorOpen", 2.0)
	var g = ghost()
	if g != null and (J.t(J.gp(g, "out")) or J.t(J.gp(g, "home"))): S["gi"] = null; g = null; hideUI()
	if S.get("gWait") != null:
		var gw = J.gp(J.gp(g0, "gh"), S.gWait); var nw = _node(gw) if J.t(gw) else null
		if not J.t(gw) or J.t(J.gp(gw, "to")) or not J.t(nw) or J.str(J.gp(nw, "kind")) != "lift" or S.gCall == null or J.num(J.gp(nw, "f")) != J.num(S.gCall): S["gCall"] = null; S["gWait"] = null
	match J.str(S.st):
		"idle":
			var t = chooseTarget()
			if t != null:
				if absf(J.num(t) - J.num(S.pos)) < 0.01: arrive()
				else: startMove(t)
		"move":
			var t2 = chooseTarget()
			if t2 != null and J.num(S.dir) > 0 and J.num(t2) > J.num(S.pos) and J.num(t2) < J.num(S.target): S["target"] = t2
			if t2 != null and J.num(S.dir) < 0 and J.num(t2) < J.num(S.pos) and J.num(t2) > J.num(S.target): S["target"] = t2
			var d = J.num(S.target) - J.num(S.pos); var ad = absf(d); var vm = minf(VMAX, sqrt(2 * ACC * ad) + 0.05)
			S["v"] = minf(vm, J.num(S.v) + ACC * dt); var mv = minf(ad, J.num(S.v) * dt); S["pos"] = J.num(S.pos) + signf(d) * mv
			if rnd() < dt * 0.5: S.fx["flick"] = 0.18
			if ad - mv <= 0.002: S["pos"] = S.target; arrive()
		"opening":
			S["door"] = minf(1.0, J.num(S.door) + dt / DOOR_T)
			if J.num(S.door) >= 1: S["st"] = "open"; S["hold"] = maxf(J.num(S.hold), HOLD)
		"open":
			boardAndExit(dt)
			S["hold"] = J.num(S.hold) - dt
			if J.num(S.fx.over) > 0: S["hold"] = maxf(J.num(S.hold), 0.3)
			if J.num(S.hold) <= 0: S["st"] = "closing"
		"closing":
			S["door"] = maxf(0.0, J.num(S.door) - dt / DOOR_T)
			if J.num(S.door) <= 0: S["st"] = "closed"
		"closed":
			var t3 = chooseTarget()
			if t3 != null and absf(J.num(t3) - J.num(S.pos)) > 0.01: startMove(t3)
			elif t3 != null: S["st"] = "opening"
			else: S["st"] = "idle"
		"stuckMove":
			var dd = J.num(S.stuckTo) - J.num(S.pos); var stp = minf(absf(dd), 1.3 * dt); S["pos"] = J.num(S.pos) + signf(dd) * stp
			if absf(dd) <= 0.003: S["pos"] = S.stuckTo; S["st"] = "stuck"; S["shake"] = 0.6
		"stuck":
			S["door"] = minf(0.45, J.num(S.door) + dt / DOOR_T); S["stuckT"] = J.num(S.stuckT) - dt
			if J.num(S.stuckT) <= 0: S["st"] = "unstick"
		"unstick":
			S["door"] = maxf(0.0, J.num(S.door) - dt / DOOR_T)
			if J.num(S.door) <= 0:
				var nf = ceil(J.num(S.pos)) if J.num(S.dir) >= 0 else floor(J.num(S.pos)); nf = maxf(0.0, minf(top(), nf))
				S.stops[K(nf)] = 1.0; startMove(nf); S["target"] = nf
	if S.get("gWait") != null and S.gCall == null:
		var gw2 = J.gp(J.gp(g0, "gh"), S.gWait)
		if J.t(gw2) and atFloor() and (J.str(S.st) == "opening" or J.str(S.st) == "open") and J.num(J.gp(_node(gw2), "f")) == cabF(): doEnter(gw2, cabF())
	if S.get("gWait") != null and S.gCall != null and atFloor() and cabF() == J.num(S.gCall) and (J.str(S.st) == "opening" or J.str(S.st) == "open"):
		var gw3 = J.gp(J.gp(g0, "gh"), S.gWait); doEnter(gw3, cabF())
	g = ghost()
	if g != null:
		J.sp(g, "to", null); J.sp(g, "auto", null); J.sp(g, "autoS", null)
		var fN = maxf(0.0, minf(top(), J.round(J.num(S.pos))))
		J.sp(g, "node", "f" + J.str(fN) + "_l"); J.sp(g, "x", c.cx); J.sp(g, "y", fyf(J.num(S.pos)))
		if J.num(S.door) < 0.5 or not atFloor(): J.sp(g, "inv", maxf(J.num(J.gp(g, "inv")), 0.15))
		J.sp(g, "taskP", 0.0)
	for df in S.dfx.keys():
		S.dfx[df]["t"] = J.num(S.dfx[df].t) + dt
		if J.num(S.dfx[df].t) > 1.6: S.dfx.erase(df)
	if J.str(S.st) != J.str(S.prevSt):
		if J.str(S.st) == "opening" and atFloor(): dingFx(cabF(), true)
		S["prevSt"] = S.st
	if J.str(S.st) == "stuck" or J.str(S.st) == "stuckMove":
		for o in S.riders.duplicate():
			if J.str(o.ph) == "ride" and J.str(o.mood) == "bolt" and not J.t(o.get("boltSaid")): o["boltSaid"] = 1.0

# ---------------- 面板狀態（原生面板讀） ----------------
func showUI() -> void: ui_on = true; ui_show = true
func hideUI() -> void: ui_on = false; ui_show = false

func layout() -> Dictionary:
	var W = J.num(_a("VW")); var H = J.num(_a("VH"))
	var NT = J.gp(J.G.get("window"), "__twNat")
	var D = J.num(J.gp(NT, "s")) if J.t(NT) else 1.0
	var TOP = J.num(_a("TOP")); var bot = maxf(J.num(_a("BOT")), 200.0)
	var cabH = J.round(minf(330.0, maxf(200.0, (H - TOP - bot) * 0.62)))
	L["_band"] = {"y0": TOP + cabH, "y1": H - bot}
	return {"W": W, "H": cabH, "D": D}

func ui_state():
	if S == null or S.gi == null or not ui_on: return null
	var f = cabF(); var inn = inCab(); var lit = []
	for k in S.lit: if J.t(S.lit[k]): lit.append(J.num(k))
	var stops = []
	for k in S.stops: stops.append(J.num(k))
	stops.sort()
	return {"top": top(), "f": f, "at": atFloor(), "lit": lit, "all": J.num(S.fx.btnAll) > 0, "st": S.st, "door": S.door, "dir": S.dir, "msg": S.msg if J.num(S.get("msgT")) > 0 else "", "stops": stops, "inn": float(inn.size()), "waitHere": _waitAt(f), "cd": S.cd}

func state():
	if S == null: return null
	var rs = []
	for o in S.riders: rs.append({"kind": o.kind, "ph": o.ph, "f": o.f, "dest": o.dest, "mood": o.mood, "fear": J.round(J.num(o.get("fear"))), "say": o.get("say")})
	var dk = []
	for k in S.dfx: dk.append(J.num(k))
	var sk = []
	for k in S.stops: sk.append(J.num(k))
	return {"dfx": dk, "on": S.on, "pos": S.pos, "st": S.st, "door": S.door, "dir": S.dir, "stops": sk, "gi": S.gi, "gCall": S.gCall, "cd": S.cd.duplicate(true), "fx": S.fx.duplicate(true), "riders": rs, "mroom": float(S.mroom.size()), "away": float(S.away.size()), "log": S.log.slice(maxi(0, S.log.size() - 30)), "err": L.get("_err"), "top": top()}

# ---------------- 畫面：世界剖面層 ----------------
func img(k):
	var IM = _a("IMG"); var im = J.gp(IM, J.str(k)) if IM != null else null
	return im if im != null and J.t(J.gp(im, "width")) else null

func sprAt(c: Ctx, k, x: float, y: float, h: float, alpha = null, flip = false, sy = null) -> void:
	var im = img(k)
	if im == null:
		c.fillStyle = "rgba(30,30,36," + J.str(1.0 if alpha == null else alpha) + ")"; c.fillRect(x - h * 0.18, y - h, h * 0.36, h); return
	var w = h * J.num(J.gp(im, "width")) / J.num(J.gp(im, "height"))
	c.save(); c.globalAlpha = 1.0 if alpha == null else J.num(alpha); c.translate(x, y)
	if J.t(flip): c.scale(-1, 1)
	if J.t(sy): c.scale(1, J.num(sy))
	c.drawImage(im, -w / 2, -h, w, h); c.restore()

func bub(c: Ctx, x: float, y: float, t, sc: float) -> void:
	c.save(); c.font = "bold " + J.str(J.round(12 / sc)) + "px " + J.str(_a("FONT"))
	var w = minf(220 / sc, J.num(c.measureText(J.str(t)).width) + 14 / sc); var h = 22 / sc
	c.fillStyle = "rgba(255,250,240,0.95)"; c.strokeStyle = "#1a1a1e"; c.lineWidth = 1.5 / sc; c.beginPath(); c.rect(x - w / 2, y - h, w, h); c.fill(); c.stroke()
	c.fillStyle = "#1a1a1e"; c.textAlign = "center"; c.fillText(J.str(t), x, y - h * 0.3, w - 6 / sc); c.restore()

static func ease_(x: float) -> float: return 2 * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 2) / 2

func steel(wx: Ctx, x: float, y: float, w: float, h: float, side: int) -> void:
	var gr = wx.createLinearGradient(x, 0, x + w, 0); gr.addColorStop(0, "#7f8387"); gr.addColorStop(0.45, "#c9ccd0"); gr.addColorStop(1, "#8a8e92"); wx.fillStyle = gr; wx.fillRect(x, y, w, h)
	wx.fillStyle = "rgba(255,255,255,0.10)"
	for i in range(1, 4): wx.fillRect(x, y + h * i / 4, w, 0.8)
	var ex = x + w - 1.6 if side > 0 else x; wx.fillStyle = "#4a4d52"; wx.fillRect(ex, y, 1.6, h)
	if w > 6: wx.fillStyle = "rgba(40,42,46,0.7)"; wx.fillRect(x + w - 5 if side > 0 else x + 3.4, y + h * 0.42, 1.6, h * 0.16)

func gapLight(wx: Ctx, cx: float, y: float, half: float, ch: float, a: float) -> void:
	wx.save()
	if half < 4:
		var gs = wx.createLinearGradient(cx - 10, 0, cx + 10, 0); gs.addColorStop(0, "rgba(255,226,150,0)"); gs.addColorStop(0.5, "rgba(255,244,200," + J.str(0.95 * a) + ")"); gs.addColorStop(1, "rgba(255,226,150,0)"); wx.fillStyle = gs; wx.fillRect(cx - 10, y - ch, 20, ch)
	else:
		for sd in [-1.0, 1.0]:
			var ex = cx + sd * half; var gr = wx.createLinearGradient(ex, 0, ex + sd * 9, 0); gr.addColorStop(0, "rgba(255,236,170," + J.str(0.75 * a) + ")"); gr.addColorStop(1, "rgba(255,236,170,0)"); wx.fillStyle = gr; wx.fillRect(minf(ex, ex + sd * 9), y - ch, 9, ch)
	var w = maxf(3.0, half * 2); wx.fillStyle = "rgba(255,220,140," + J.str(0.30 * a) + ")"; wx.beginPath(); wx.moveTo(cx - w / 2, y); wx.lineTo(cx + w / 2, y); wx.lineTo(cx + w / 2 + 26, y + 9); wx.lineTo(cx - w / 2 - 26, y + 9); wx.closePath(); wx.fill(); wx.restore()

func lightLevel() -> float:
	var d = J.num(S.fx.dark)
	if d > 0:
		var e = 4.2 - d
		if e < 0.7: return 0.15 if int(floor(e / 0.175)) % 2 else 1.0
		return 0.04
	if J.num(S.fx.flick) > 0: return 0.55
	if J.str(S.st) == "stuck": return 0.6 + 0.3 * absf(sin(J.num(S.t) * 9))
	return 1.0

func drawWorld() -> void:
	var NT = J.gp(J.G.get("window"), "__twNat")
	if not J.t(NT) or not J.t(J.gp(NT, "ctx")): return
	var wx: Ctx = J.gp(NT, "ctx"); var D = J.num(J.gp(NT, "s"))
	var g0 = G()
	if S == null or not J.t(S.on) or J.str(_a("scene")) != "play" or not J.t(g0) or J.t(J.gp(g0, "choice")) or J.t(J.gp(g0, "over")) or J.t(J.gp(g0, "showStory")): return
	var W2S = _a("W2S"); var p0 = J.cl(W2S, null, [0.0, 0.0]); var p1 = J.cl(W2S, null, [100.0, 0.0]); var sc = (J.num(J.gp(p1, "x")) - J.num(J.gp(p0, "x"))) / 100
	if not (sc > 0): return
	var VW = J.num(_a("VW")); var VH = J.num(_a("VH")); var TOP = J.num(_a("TOP")); var BOT = J.num(_a("BOT")); var FONT = J.str(_a("FONT"))
	wx.setTransform(D, 0, 0, D, 0, 0); wx.save(); wx.beginPath()
	var cb = 62.0 if J.num(J.gp(g0, "toastT")) > 0 and J.t(J.gp(g0, "toast")) else 0.0
	wx.rect(0, TOP, VW, VH - TOP - BOT - cb)
	var BT = _a("BTNS")
	if J.t(BT):
		for b in J.iter(BT):
			var by = J.num(J.gp(b, "y")); var bh = J.num(J.gp(b, "h"))
			if by < VH - BOT and by + bh > TOP: wx.rect(J.num(J.gp(b, "x")) + J.num(J.gp(b, "w")) + 2, by - 2, -(J.num(J.gp(b, "w")) + 4), bh + 4)
	wx.clip()
	wx.setTransform(D * sc, 0, 0, D * sc, D * J.num(J.gp(p0, "x")), D * J.num(J.gp(p0, "y")))
	var c = col(); var fh = FH(); var cw = (c.x1 - c.x0) * 0.66; var ch = fh * 0.6; var t = J.num(S.t)
	var cy = fyf(J.num(S.pos)); var sh = (sin(t * 41) * 0.8 if J.str(S.st) == "move" else 0.0) + ((randf() - 0.5) * 4 if J.num(S.shake) > 0 else 0.0)
	wx.strokeStyle = "rgba(180,180,170,0.7)"; wx.lineWidth = 1.2; wx.beginPath(); wx.moveTo(c.cx - 6, fy(FL()) - 40); wx.lineTo(c.cx - 6, cy - ch - 2); wx.moveTo(c.cx + 6, fy(FL()) - 40); wx.lineTo(c.cx + 6, cy - ch - 2); wx.stroke()
	wx.save(); wx.translate(sh, 0)
	var lit = lightLevel(); wx.fillStyle = "#3a3a36"; wx.fillRect(c.cx - cw / 2 - 3, cy - ch - 3, cw + 6, ch + 3)
	var ig = wx.createLinearGradient(0, cy - ch, 0, cy); ig.addColorStop(0, "rgba(255,228,150," + J.str(0.95 * lit) + ")"); ig.addColorStop(1, "rgba(150,120,70," + J.str(0.9 * lit) + ")"); wx.fillStyle = "#0a0a0a"; wx.fillRect(c.cx - cw / 2, cy - ch, cw, ch); wx.fillStyle = ig; wx.fillRect(c.cx - cw / 2, cy - ch, cw, ch)
	var inn = inCab(); var g = ghost(); var n = inn.size() + (1 if g != null else 0); var k = 0
	for o in inn:
		var px = c.cx - cw / 2 + cw * (0.5 if n == 1 else 0.18 + 0.64 * k / maxf(1.0, n - 1)); k += 1
		sprAt(wx, riderSpr(o), px, cy - 1, ch * 0.82 * (0.7 if J.str(o.mood) == "cower" else 1.0), 1.0, k % 2 == 0, null)
	if g != null:
		var px2 = c.cx - cw / 2 + cw * (0.5 if n == 1 else 0.18 + 0.64 * k / maxf(1.0, n - 1))
		sprAt(wx, J.gp(J.gp(g, "d"), "sprite"), px2, cy - 2 + sin(t * 3) * 1.5, ch * 0.82, 0.75, false)
	if lit < 0.3: wx.fillStyle = "rgba(0,0,0,0.75)"; wx.fillRect(c.cx - cw / 2, cy - ch, cw, ch)
	if not atFloor():
		var pw2 = cw / 2 * (1 - J.num(S.door))
		if pw2 > 0.5: steel(wx, c.cx - cw / 2, cy - ch, pw2, ch, 1); steel(wx, c.cx + cw / 2 - pw2, cy - ch, pw2, ch, -1)
		if J.num(S.door) > 0.02: gapLight(wx, c.cx, cy, cw * J.num(S.door) / 2, ch, minf(1.0, J.num(S.door) * 3))
	if J.num(S.fx.over) > 0 and int(floor(t * 6)) % 2: wx.fillStyle = "rgba(255,40,30,0.35)"; wx.fillRect(c.cx - cw / 2, cy - ch, cw, ch)
	wx.restore()
	var CLW = J.gp(J.G.get("window"), "__twCull")
	var f = 0.0
	while f <= top():
		var y = fy(f)
		if J.t(CLW) and (y < J.num(J.gp(CLW, "y0")) or y - ch - 60 > J.num(J.gp(CLW, "y1"))): f += 1; continue
		var here = atFloor() and cabF() == f; var op = ease_(J.num(S.door)) if here else 0.0; var dfx = S.dfx.get(K(f))
		wx.fillStyle = "#2a2b2e"; wx.fillRect(c.cx - cw / 2 - 5, y - ch - 5, cw + 10, 5); wx.fillRect(c.cx - cw / 2 - 5, y - ch, 5, ch); wx.fillRect(c.cx + cw / 2, y - ch, 5, ch); wx.fillStyle = "#4a4c50"; wx.fillRect(c.cx - cw / 2 - 5, y - ch - 5, cw + 10, 2)
		if not here: wx.fillStyle = "#121214"; wx.fillRect(c.cx - cw / 2, y - ch, cw, ch)
		var pw = cw / 2 * (1 - op)
		if pw > 0.5: steel(wx, c.cx - cw / 2, y - ch, pw, ch, 1); steel(wx, c.cx + cw / 2 - pw, y - ch, pw, ch, -1)
		if here and J.num(S.door) > 0.001: gapLight(wx, c.cx, y, cw * op / 2, ch, 1.0 if J.num(S.door) < 1 else 0.55)
		var fl2 = dfx != null and J.num(dfx.t) < 1.2 and int(floor(J.num(dfx.t) / 0.15)) % 2 == 0; var lampOn = absf(J.num(S.pos) - f) < 0.5
		if fl2:
			var hg = wx.createRadialGradient(c.cx, y - ch - 12, 2, c.cx, y - ch - 12, 26); hg.addColorStop(0, "rgba(255,214,120,0.85)"); hg.addColorStop(1, "rgba(255,214,120,0)"); wx.fillStyle = hg; wx.fillRect(c.cx - 28, y - ch - 40, 56, 56)
		wx.fillStyle = "#000"; wx.fillRect(c.cx - 14, y - ch - 19, 28, 13); wx.fillStyle = "#fff3c0" if fl2 else ("#ffb347" if lampOn else "#7a4a20"); wx.font = "bold 10px " + FONT; wx.textAlign = "center"
		wx.fillText((("▲" if J.num(S.dir) > 0 else "▼") if J.str(S.st) == "move" else "") + lab(cabF()), c.cx, y - ch - 9)
		var wn = _waitAt(f) or (S.gCall != null and J.num(S.gCall) == f); wx.fillStyle = "#ffd54a" if wn or fl2 else "#444"; wx.beginPath(); wx.arc(c.cx + cw / 2 + 9, y - ch * 0.5, 3.2, 0, 7); wx.fill()
		if dfx != null and J.num(dfx.t) < 1.4:
			var u = J.num(dfx.t) / 1.4; var pop = 1 + 0.5 * maxf(0.0, 1 - J.num(dfx.t) / 0.18)
			wx.save(); wx.globalAlpha = minf(1.0, (1 - u) * 1.6); wx.translate(c.cx + cw / 2 + 16, y - ch - 14 - u * 34); wx.scale(pop, pop); wx.font = "bold 20px " + FONT; wx.lineWidth = 4; wx.strokeStyle = "#1a1205"; wx.strokeText("叮", 0, 0); wx.fillStyle = "#ffd54a"; wx.fillText("叮", 0, 0); wx.restore()
		f += 1
	var gh = J.gp(g0, "gh")
	if J.t(gh):
		var qi = 0
		for q in J.iter(gh):
			var skip = J.t(J.gp(q, "home")) or J.t(J.gp(q, "out")) or (S.gi != null and float(qi) == J.num(S.gi))
			var nq = null if skip else _node(q)
			if not skip and J.t(nq) and J.str(J.gp(nq, "kind")) == "lift" and absf(J.num(J.gp(q, "x")) - c.cx) <= cw * 0.7:
				var al = 0.35 if J.num(J.gp(q, "inv")) > 0 else 0.92; var qd = J.gp(q, "d")
				if J.str(J.gp(qd, "key")) == "tianhua" and not J.t(J.gp(q, "to")) and not (J.num(J.gp(q, "dropT")) > 0): sprAt(wx, J.gp(qd, "sprite"), J.num(J.gp(q, "x")), fy(minf(FL(), J.num(J.gp(nq, "f")) + 1)) + 14, J.num(J.gp(qd, "h")), al, J.num(J.gp(q, "dir")) < 0, -1)
				else: sprAt(wx, J.gp(qd, "sprite"), J.num(J.gp(q, "x")), J.num(J.gp(q, "y")), J.num(J.gp(qd, "h")), al, J.num(J.gp(q, "dir")) < 0)
				if float(qi) == J.num(J.gp(g0, "active")):
					wx.strokeStyle = "rgba(138,255,200,0.55)"; wx.setLineDash([4, 4]); wx.lineWidth = 1.5; wx.beginPath(); wx.ellipse(J.num(J.gp(q, "x")), J.num(J.gp(q, "y")) - 2, 30, 8, 0, 0, 7); wx.stroke(); wx.setLineDash([])
			qi += 1
	for o in S.riders.duplicate():
		if J.str(o.ph) == "ride": continue
		var y = fy(o.f); var rk = rKey(o)
		var hh = (64.0 if J.str(o.kind) == "guard" else (J.num(J.gp(o.ref, "h")) if J.t(J.gp(o.ref, "h")) else 66.0)) * 0.9
		var un = J.gp(o.ref, "unit"); var ux = J.num(J.gp(J.gp(un, "rx"), 0)) if J.t(un) else 0.0
		sprAt(wx, rk, J.num(o.x), y - 2, J.num(rH(o, rk, hh)), 1.0, J.num(o.x) > ux if J.str(o.ph) == "walkHome" else J.num(o.x) > c.cx)
	for o in S.riders.duplicate():
		if not J.t(o.get("say")): continue
		if J.str(o.ph) == "ride": bub(wx, c.cx, cy - ch - 8, o.say, 1)
		else: bub(wx, J.num(o.x), fy(o.f) - 80, o.say, 1)
	wx.restore()

# ---------------- 畫面：𨋢廂內景 ----------------
func crayonTex():
	if tex != null: return tex
	tex = J.S_document_("createElement", ["canvas"]); J.sp(tex, "width", 256.0); J.sp(tex, "height", 256.0)
	var c = J.mc(tex, "getContext", ["2d"])
	var s = [7]
	var r = func() -> float:
		s[0] = (s[0] * 16807) % 2147483647; return float(s[0]) / 2147483647.0
	J.sp(c, "strokeStyle", "rgba(0,0,0,0.5)"); J.sp(c, "lineWidth", 1.0)
	for i in 900:
		var x = r.call() * 256; var y = r.call() * 256; var l = 3 + r.call() * 9
		J.sp(c, "globalAlpha", 0.25 + r.call() * 0.4); J.mc(c, "beginPath", []); J.mc(c, "moveTo", [x, y]); J.mc(c, "lineTo", [x + l, y - l * 0.35]); J.mc(c, "stroke", [])
	J.sp(c, "strokeStyle", "rgba(255,255,255,0.6)")
	for j in 300:
		var x2 = r.call() * 256; var y2 = r.call() * 256
		J.sp(c, "globalAlpha", 0.15 + r.call() * 0.3); J.mc(c, "beginPath", []); J.mc(c, "moveTo", [x2, y2]); J.mc(c, "lineTo", [x2 + 4 + r.call() * 6, y2 + r.call() * 2]); J.mc(c, "stroke", [])
	return tex

static func poly(c: Ctx, pts: Array, fill) -> void:
	c.beginPath(); c.moveTo(pts[0], pts[1])
	var i = 2
	while i < pts.size(): c.lineTo(pts[i], pts[i + 1]); i += 2
	c.closePath(); c.fillStyle = fill; c.fill()

func texFill(c: Ctx, pts: Array, a = null) -> void:
	c.save(); c.beginPath(); c.moveTo(pts[0], pts[1])
	var i = 2
	while i < pts.size(): c.lineTo(pts[i], pts[i + 1]); i += 2
	c.closePath(); c.clip(); c.globalAlpha = J.num(a) if J.t(a) else 0.18
	c.fillStyle = c.createPattern(crayonTex(), "repeat"); c.fillRect(0, 0, 4000, 4000); c.restore()

func drawCab() -> void:
	if S == null or S.gi == null: return
	var NT = J.gp(J.G.get("window"), "__twNat")
	if not J.t(NT) or not J.t(J.gp(NT, "cab")): return
	var Lo = layout(); var W = J.num(Lo.W); var H = J.num(Lo.H); var c: Ctx = J.gp(NT, "cab"); var t = J.num(S.t); var FONT = J.str(_a("FONT"))
	c.setTransform(Lo.D, 0, 0, Lo.D, 0, 0)
	var mv = J.str(S.st) == "move" or J.str(S.st) == "stuckMove"
	var sx = (sin(t * 37) * 1.1 + sin(t * 53) * 0.6 if mv else 0.0) + ((randf() - 0.5) * 8 * J.num(S.shake) if J.num(S.shake) > 0 else 0.0); var sy = sin(t * 29) * 0.9 if mv else 0.0
	c.save(); c.translate(sx, sy)
	var bx0 = W * 0.25; var bx1 = W * 0.75; var by0 = H * 0.2; var by1 = H * 0.84
	poly(c, [-10, -10, W + 10, -10, bx1, by0, bx0, by0], "#5d5847"); texFill(c, [-10, -10, W + 10, -10, bx1, by0, bx0, by0], 0.2)
	var lit = lightLevel(); var lg = c.createRadialGradient(W / 2, H * 0.06, 4, W / 2, H * 0.06, W * 0.55); lg.addColorStop(0, "rgba(255,232,160," + J.str(0.95 * lit) + ")"); lg.addColorStop(1, "rgba(255,232,160,0)"); c.fillStyle = lg; c.fillRect(0, 0, W, H * 0.5)
	c.fillStyle = "rgba(255,240,190," + J.str(0.9 * lit) + ")"; c.fillRect(W * 0.36, H * 0.05, W * 0.28, H * 0.05)
	poly(c, [-10, H + 10, W + 10, H + 10, bx1, by1, bx0, by1], "#4b4034"); texFill(c, [-10, H + 10, W + 10, H + 10, bx1, by1, bx0, by1], 0.25)
	c.strokeStyle = "rgba(0,0,0,0.25)"; c.lineWidth = 1
	for i in range(1, 6):
		var q = i / 6.0; c.beginPath(); c.moveTo(bx0 + (bx1 - bx0) * q, by1); c.lineTo(-10 + (W + 20) * q, H + 10); c.stroke()
	var lw = [-10, -10, bx0, by0, bx0, by1, -10, H + 10]; var rw = [W + 10, -10, bx1, by0, bx1, by1, W + 10, H + 10]
	var gl = c.createLinearGradient(0, 0, bx0, 0); gl.addColorStop(0, "#7c8084"); gl.addColorStop(1, "#a9adb1"); poly(c, lw, gl); texFill(c, lw, 0.22)
	var gr = c.createLinearGradient(W, 0, bx1, 0); gr.addColorStop(0, "#74787c"); gr.addColorStop(1, "#a3a7ab"); poly(c, rw, gr); texFill(c, rw, 0.22)
	c.strokeStyle = "rgba(255,255,255,0.12)"
	for j in 9:
		var xx = bx0 * j / 9; c.beginPath(); c.moveTo(xx, -10 + (by0 + 10) * j / 9); c.lineTo(xx, H + 10 - (H + 10 - by1) * j / 9); c.stroke()
	c.strokeStyle = "#d8c690"; c.lineWidth = 6; c.lineCap = "round"; c.beginPath(); c.moveTo(6, H * 0.66); c.lineTo(bx0 - 4, by0 + (by1 - by0) * 0.62); c.stroke(); c.beginPath(); c.moveTo(W - 6, H * 0.66); c.lineTo(bx1 + 4, by0 + (by1 - by0) * 0.62); c.stroke()
	c.strokeStyle = "#6a5a30"; c.lineWidth = 2; c.beginPath(); c.moveTo(6, H * 0.66 + 3); c.lineTo(bx0 - 4, by0 + (by1 - by0) * 0.62 + 2); c.stroke()
	var mr = [W - 16, H * 0.12, bx1 + 8, by0 + 10, bx1 + 8, by0 + (by1 - by0) * 0.56, W - 16, H * 0.6]
	var mg = c.createLinearGradient(W, 0, bx1, H); mg.addColorStop(0, "#6f8894"); mg.addColorStop(0.5, "#a8c0c8"); mg.addColorStop(1, "#56707c"); poly(c, mr, mg)
	c.save(); c.beginPath(); c.moveTo(mr[0], mr[1])
	for m in [2, 4, 6]: c.lineTo(mr[m], mr[m + 1])
	c.closePath(); c.clip()
	var inn = inCab()
	for i in inn.size(): sprAt(c, riderSpr(inn[i]), W - 40 - i * 18, H * 0.6, H * 0.4, 0.35, true)
	if J.num(S.fx.mirror) > 0:
		var a = minf(1.0, minf(J.num(S.fx.mirror) / 0.6, (3.6 - J.num(S.fx.mirror)) / 0.4)); c.globalAlpha = 0.85 * a; c.fillStyle = "#0c0f12"; var hx = W - 58; var hy = H * 0.26
		c.beginPath(); c.ellipse(hx, hy, 11, 14, 0, 0, 7); c.fill(); c.beginPath(); c.moveTo(hx - 14, hy + 4); c.quadraticCurveTo(hx - 20, hy + 60, hx - 16, H * 0.6); c.lineTo(hx + 16, H * 0.6); c.quadraticCurveTo(hx + 20, hy + 60, hx + 14, hy + 4); c.closePath(); c.fill()
		c.fillStyle = "rgba(255,255,255," + J.str(0.7 * a) + ")"; c.fillRect(hx - 5, hy - 2, 2, 2); c.fillRect(hx + 3, hy - 2, 2, 2); c.globalAlpha = 1
	c.fillStyle = "rgba(255,255,255,0.25)"; c.beginPath(); c.moveTo(W - 30, H * 0.15); c.lineTo(W - 24, H * 0.15); c.lineTo(bx1 + 30, by0 + 60); c.lineTo(bx1 + 24, by0 + 60); c.fill(); c.restore()
	c.strokeStyle = "#c8b878"; c.lineWidth = 3; c.beginPath(); c.moveTo(mr[0], mr[1])
	for m in [2, 4, 6]: c.lineTo(mr[m], mr[m + 1])
	c.closePath(); c.stroke()
	c.fillStyle = "#3a3c40"; c.fillRect(bx0 - 38, by0 + 28, 22, 58)
	for b in 6:
		var onB = (int(floor(t * 10 + b)) % 2 == 0) if J.num(S.fx.btnAll) > 0 else J.t(S.lit.get(K(top() - b)))
		c.fillStyle = "#ffb347" if onB else "#8a8d90"; c.beginPath(); c.arc(bx0 - 27, by0 + 36 + b * 9, 3, 0, 7); c.fill()
	var dw = (bx1 - bx0) * 0.8; var dx0 = W / 2 - dw / 2; var dy0 = by0 + (by1 - by0) * 0.14; var dh = by1 - dy0
	c.fillStyle = "#8e9296"; c.fillRect(bx0, by0, bx1 - bx0, by1 - by0); texFill(c, [bx0, by0, bx1, by0, bx1, by1, bx0, by1], 0.15)
	var op = J.num(S.door); c.save(); c.beginPath(); c.rect(dx0, dy0, dw, dh); c.clip()
	if atFloor() or J.str(S.st) != "stuck" and J.str(S.st) != "unstick":
		c.fillStyle = "#2c2b24"; c.fillRect(dx0, dy0, dw, dh); c.fillStyle = "#4a4535"; c.fillRect(dx0, dy0 + dh * 0.82, dw, dh * 0.18); c.fillStyle = "rgba(255,214,140,0.25)"; c.beginPath(); c.arc(W / 2, dy0 + 10, 40, 0, 7); c.fill()
		var f = cabF(); var wl = []
		for o in S.riders: if J.str(o.ph) == "wait" and J.num(o.f) == f: wl.append(o)
		for i in wl.size(): sprAt(c, riderSpr(wl[i]), dx0 + dw * (0.78 if i % 2 else 0.22), dy0 + dh, dh * 0.85, 1.0, i % 2 == 0)
	else:
		c.fillStyle = "#5e594d"; c.fillRect(dx0, dy0, dw, dh); texFill(c, [dx0, dy0, dx0 + dw, dy0, dx0 + dw, dy0 + dh, dx0, dy0 + dh], 0.35); c.fillStyle = "#3a362e"; var sl = dy0 + dh * (0.35 + 0.1 * sin(1)); c.fillRect(dx0, sl, dw, dh * 0.16); c.fillStyle = "rgba(0,0,0,0.5)"; c.fillRect(dx0, sl + dh * 0.16, dw, 4)
	c.restore()
	var pw = dw / 2 * (1 - op)
	for s in [0, 1]:
		var x = dx0 + dw - pw if s else dx0; var dg = c.createLinearGradient(x, 0, x + pw, 0); dg.addColorStop(0, "#9da1a5"); dg.addColorStop(0.5, "#cfd2d5"); dg.addColorStop(1, "#8a8e92"); c.fillStyle = dg; c.fillRect(x, dy0, pw, dh); texFill(c, [x, dy0, x + pw, dy0, x + pw, dy0 + dh, x, dy0 + dh], 0.12)
	c.fillStyle = "#1d1e20"; c.fillRect(W / 2 - 1, dy0, 2, dh * (1.0 if op < 0.02 else 0.0))
	if mv and op < 0.02:
		for k in 4:
			var yy = dy0 + fmod(fmod(t * (260.0 if J.num(S.dir) > 0 else -260.0) + k * dh / 4, dh) + dh, dh); c.fillStyle = "rgba(255,240,200,0.55)"; c.fillRect(W / 2 - 1.5, yy, 3, 10)
	c.strokeStyle = "#5c5f63"; c.lineWidth = 4; c.strokeRect(dx0 - 2, dy0 - 2, dw + 4, dh + 4)
	var ix = W / 2 - 38; var iy = by0 - 2; var ih = dy0 - iy - 6 if dy0 - iy - 6 > 18 else 22.0
	c.fillStyle = "#111"; c.fillRect(ix, iy, 76, ih); c.strokeStyle = "#777"; c.lineWidth = 1.5; c.strokeRect(ix, iy, 76, ih)
	var stuck = J.str(S.st) == "stuck" or J.str(S.st) == "stuckMove" or J.str(S.st) == "unstick"; var ovr = J.num(S.fx.over) > 0
	c.font = "bold 20px \"Courier New\",monospace"; c.textAlign = "center"; c.fillStyle = ("#ff3b2f" if int(floor(t * 6)) % 2 else "#5a1410") if ovr else "#ffa030"
	# 網頁 canvas 嘅 shadow 光暈：Ctx 冇呢樣（轉譯版經 J.sp 都係冇效果），唔畫
	var dirc = "▲" if J.num(S.dir) > 0 and mv else ("▼" if J.num(S.dir) < 0 and mv else " ")
	c.fillText("OVER" if ovr else ("- -" if stuck else dirc + lab(cabF())), W / 2, iy + 19)
	var g = ghost(); var slots = [W * 0.13, W * 0.87, W * 0.3, W * 0.7]
	for i in inn.size():
		var o = inn[i]; var x = slots[i % 4]; var cower = J.str(o.mood) == "cower"; var hh = H * (0.5 if cower else 0.78); var shk = sin(t * 40 + i) * 1.8 if cower or J.str(o.mood) == "bolt" else 0.0
		var rk = rKey(o); sprAt(c, rk, x + shk, H + 4, minf(H * 0.9, J.num(rH(o, rk, hh))), 1.0, x > W / 2)
		if J.t(o.get("say")):
			c.font = "bold 13px " + FONT; var tw = minf(W * 0.46, J.num(c.measureText(J.str(o.say)).width) + 14); var bx = maxf(4.0, minf(W - tw - 4, x - tw / 2)); var byy = H * 0.2 + i * 28
			c.fillStyle = "rgba(255,250,240,0.96)"; c.fillRect(bx, byy, tw, 24); c.strokeStyle = "#1a1a1e"; c.lineWidth = 1.5; c.strokeRect(bx, byy, tw, 24); c.fillStyle = "#1a1a1e"; c.textAlign = "center"; c.fillText(J.str(o.say), bx + tw / 2, byy + 17, tw - 6)
	if g != null: sprAt(c, J.gp(J.gp(g, "d"), "sprite"), W * 0.5, H * 1.04 + sin(t * 2.6) * 3, H * 0.5, 0.5, false)
	var dk = 1 - lit
	if dk > 0:
		c.fillStyle = "rgba(0,0,0," + J.str(0.92 * dk) + ")"; c.fillRect(-20, -20, W + 40, H + 40)
		if J.num(S.fx.dark) > 0 and lit < 0.1:
			c.fillStyle = "rgba(220,235,255,0.5)"; var ey = H * 0.45 + sin(t * 1.3) * 4; c.fillRect(W * 0.62, ey, 4, 2); c.fillRect(W * 0.62 + 12, ey, 4, 2); c.font = "14px " + FONT; c.fillStyle = "rgba(200,210,220,0.55)"; c.textAlign = "center"; c.fillText("……呼……呼……", W / 2, H * 0.35)
	if ovr: c.fillStyle = "rgba(255,30,20," + J.str(0.18 if int(floor(t * 6)) % 2 else 0.05) + ")"; c.fillRect(-20, -20, W + 40, H + 40)
	var vg = c.createRadialGradient(W / 2, H / 2, H * 0.3, W / 2, H / 2, W * 0.75); vg.addColorStop(0, "rgba(0,0,0,0)"); vg.addColorStop(1, "rgba(20,14,0,0.55)"); c.fillStyle = vg; c.fillRect(-20, -20, W + 40, H + 40)
	c.restore()

# ---------------- 自己嘅迴圈 ----------------
func running() -> bool:
	var g0 = G()
	return J.str(_a("scene")) == "play" and J.t(g0) and not J.t(J.gp(g0, "over")) and not J.t(J.gp(g0, "choice")) and not J.t(J.gp(g0, "showStory")) and not J.t(J.gp(g0, "ult")) and not J.t(_a("paused"))

func loop(ts: float) -> void:
	_raf()
	var dt = minf(0.1, (ts - last) / 1000.0) if last else 0.0; last = ts
	if not is_same(G(), lastG): reset()
	if S != null and running() and not J.t(L.get("manual")): step(dt)
	var g0 = G()
	var vis = S != null and S.gi != null and J.str(_a("scene")) == "play" and J.t(g0) and not J.t(J.gp(g0, "over")) and not J.t(J.gp(g0, "choice")) and not J.t(J.gp(g0, "showStory"))
	if vis:
		if not ui_on: showUI()
	elif ui_on: ui_on = false

func _raf() -> void:
	J.F_requestAnimationFrame([func(_t, a): loop(J.num(J.arg(a, 0)))])

# ---------------- 建立 ----------------
static func make(api) -> Dictionary:
	var o = new()
	o.A = api
	o._build()
	return o.L

func _build() -> void:
	L = {
		"_nat": true,
		"_self": self,   # 留住實例（lambda 唔會自己留）
		"action": func(_t, a): return action(J.arg(a, 0), J.arg(a, 1)),
		"enter": func(_t, a): return enter(J.arg(a, 0)),
		"exit": func(_t, _a2): return exit_(),
		"press": func(_t, a): press(J.arg(a, 0)); return null,
		"open": func(_t, _a2): open_(); return null,
		"close": func(_t, _a2): close_(); return null,
		"canTrick": func(_t, a): return canTrick(J.str(J.arg(a, 0))),
		"trick": func(_t, a): return trick(J.str(J.arg(a, 0))),
		"scareWaiting": func(_t, a): return scareWaiting(J.arg(a, 0)),
		"step": func(_t, a): step(J.num(J.arg(a, 0))); return null,
		"band": func(_t, _a2): return L.get("_band") if (S != null and S.gi != null and ui_on and L.get("_band") != null) else null,
		"drawW": func(_t, _a2): drawWorld(); return null,
		"drawCabN": func(_t, _a2): drawCab(); return null,
		"layoutN": func(_t, _a2): return layout(),
		"lab": func(_t, a): return lab(J.arg(a, 0)),
		"TR": TR.duplicate(true),
		"TRK": TRK.duplicate(),
		"ui": func(_t, _a2): return ui_state(),
		"state": func(_t, _a2): return state(),
		"debugRider": func(_t, a): return debugRider(J.str(J.arg(a, 0)), J.arg(a, 1), J.arg(a, 2)),
		"setPos": func(_t, a):
			if not is_same(G(), lastG): reset()
			S["pos"] = J.num(J.arg(a, 0)); S["st"] = "idle"; S["door"] = 0.0; S["v"] = 0.0
			return null,
		"noSpawn": func(_t, _a2):
			if not is_same(G(), lastG): reset()
			S["spawnT"] = 1e9; S["gSpawnT"] = 1e9
			return null,
		"_S": func(_t, _a2): return S,
	}
	_raf()

func debugRider(kind: String, f, dest):
	if not is_same(G(), lastG): reset()
	var g0 = G(); var o
	if kind == "guard":
		var h = null
		for x in J.iter(J.gp(g0, "guards")): if J.str(x.get("kind")) == "guard" and J.str(x.get("state")) != "gone": h = x; break
		if h == null: return null
		o = addGuardRider(h, dest)
	else:
		var r = null
		for x in J.iter(J.gp(g0, "res")):
			if J.str(x.get("state")) == "home" and J.t(x.get("unit")) and J.num(x.unit.f) == J.num(f): r = x; break
		if r == null:
			for x in J.iter(J.gp(g0, "res")):
				if J.str(x.get("state")) == "home" and J.t(x.get("unit")) and J.num(x.unit.f) >= 2: r = x; break
		if r == null: return null
		o = addResRider(r, "snack", dest); r["brave"] = 0.0
	o["f"] = f; o["ph"] = "wait"; o["x"] = col().cx - 44; return true
