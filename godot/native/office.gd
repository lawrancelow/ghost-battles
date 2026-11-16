# 原生改寫自 office.js（回陽間・舊公司二十三樓：會動嘅家具、工位、美美）——介面同轉譯版一樣：J.G["OFFICE"]
# 狀態（init／tick／kenTick／misTick／onScare／onProp）同仍然由 JS Scare.draw 叫嘅畫法（drawBack 電梯門、drawFloor、drawables、drawDark、
# 掉落物、飛紙、字）逐句照搬；家具／椅子／坐住嘅阿Ken／美美喺 Godot 本身已經交俾原生 ScOffice／ScMis（patches.js 嘅 __nat_scItem／__nat_scKen），呢度直接叫佢哋。
# 原碼入面冇人叫嘅 bgCanvas／drawClock／drawAC 冇搬。
extends RefCounted

const PI := 3.141592653589793
const KEN_H := 64.0 / (64.0 * 1.08)
const SIT_H := 0.876

static var SC = null
static var TC := {}
static var STATIONS := {}
static var STN: Dictionary = {}
static var SEAT: Dictionary = {}
static var SEATV: Dictionary = {}
static var K = null
static var DEF: Array = []
static var CLOCK := {}
static var TUBES := []
static var AC := []
static var WIN = null
static var SIT := {}
static var CHAIR := {}
static var EV = null
static var ELEV := {}
static var MIS_ACTS := []
static var MIS_SAY := {}
static var items := {}
static var list: Array = []
static var kids: Array = []
static var flying: Array = []
static var floor_: Array = []
static var drops: Array = []
static var st = null

# ---------------- 小工具 ----------------
static func n_(v) -> float: return J.num(v)
static func t_(v) -> bool: return J.t(v)
static func or0(v) -> float: return J.num(v) if J.t(v) else 0.0
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func ss(t: float) -> float: t = cl(t); return t * t * (3 - 2 * t)
static func bump(t: float, a: float, m: float, b: float) -> float:
	if t <= a or t >= b: return 0.0
	return ss((t - a) / (m - a)) if t < m else 1 - ss((t - m) / (b - m))
static func rnd(s: float) -> float: var x = sin(s * 127.1 + 311.7) * 43758.5453; return x - floor(x)
static func jround(x: float) -> float: return floor(x + 0.5)
static func sgn(x: float) -> float: return 1.0 if x > 0 else (-1.0 if x < 0 else 0.0)
static func hyp(a: float, b: float) -> float: return sqrt(a * a + b * b)
static func ok(k: String) -> bool:
	var f = J.G.get("sprOk")
	return f != null and J.t(J.cl(f, null, [k]))
static func OM(): return J.G.get("OFFMAP")
static func om(f: String, a: Array = []): return J.cl(J.gp(OM(), f), null, a)
static func scm(f: String, a: Array = []): return J.mc(SC, f, a)
static func U(y: float) -> float: return n_(scm("hh", [y])) * KEN_H
static func UW(y: float) -> float: return n_(scm("hhF", [y])) * KEN_H * n_(scm("bgAR"))
static func P(x: float, y: float) -> Array:
	var r = scm("pt", [x, y]); return [n_(r[0]), n_(r[1])]
static func spr(k: String): return J.gp(J.G.get("SPR"), k)
static func nat_w(im) -> float: return n_(J.gp(im, "naturalWidth"))
static func nat_h(im) -> float: return n_(J.gp(im, "naturalHeight"))
static func cw_(c) -> float: return n_(J.gp(c, "width"))
static func ch_(c) -> float: return n_(J.gp(c, "height"))
static func assign(base: Dictionary, src: Dictionary, extra: Dictionary) -> Dictionary:
	for k in src: base[k] = src[k]
	for k in extra: base[k] = extra[k]
	return base
static func rgba(r, g, b, a) -> String: return "rgba(%s,%s,%s,%s)" % [J.str(r), J.str(g), J.str(b), J.str(a)]

# ---------------- 夜色快取（家具壓一層夜）----------------
static func img(k: String, dark := ""):
	if not ok(k): return null
	var key = k + dark
	if J.t(TC.get(key)): return TC[key]
	var im = spr(k); var c = J.S_document_("createElement", ["canvas"])
	J.sp(c, "width", nat_w(im)); J.sp(c, "height", nat_h(im))
	var x: Ctx = J.mc(c, "getContext", ["2d"])
	x.drawImage(im, 0.0, 0.0); x.globalCompositeOperation = "source-atop"
	x.fillStyle = "rgba(14,10,30,.62)" if dark == "off" else "rgba(26,18,58,.30)"; x.fillRect(0.0, 0.0, cw_(c), ch_(c))
	TC[key] = c
	return c

# ---------------- 資料 ----------------
static func _setup() -> void:
	var M = func(x): return n_(om("M", [x]))
	var MY = func(y): return n_(om("MY", [y]))
	STATIONS = {
		"ken": {"k": "ken", "seat": {"x": M.call(0.24), "y": MY.call(0.60)}, "koff": 0.065, "desk": "kdesk", "mon": "kmon", "mug": "kmug", "base": "npc_ken_sit", "stretch": "npc_ken_sit_stretch", "drink": "npc_ken_sit_coffee", "jump": "npc_ken_sit_jump",
			"hand": [0.39, 0.315], "arms": [-0.05, 0.50, 0.67, 0.185], "face": [0.30, 0.28], "drinkSay": null, "stretchSay": "哈～",
			"acts": [["type", 5.0, [4.0, 8.0], 0.0], ["stretch", 1.2, [3.2, 3.2], 11.0], ["drink", 1.3, [3.8, 3.8], 12.0], ["roll", 1.0, [3.0, 3.0], 7.0], ["spin", 0.6, [2.6, 2.6], 14.0]],
			"bones": [["thigh", null, 0.92, 0.74, 0.22, 0.70, 0.13], ["shin", null, 0.30, 0.72, 0.30, 0.99, 0.14], ["body", null, 0.85, 0.72, 0.68, 0.42, 0.20], ["head", "body", 0.64, 0.40, 0.52, 0.06, 0.32], ["armF", "body", 0.62, 0.55, 0.10, 0.63, 0.085]]},
		"it": {"k": "it", "seat": {"x": M.call(0.66), "y": 0.80}, "koff": 0.0, "desk": "idesk", "mon": "imon", "mug": null, "base": "npc_it_sit", "stretch": null, "drink": "npc_it_sit_tea", "jump": "npc_it_sit_jump",
			"hand": [0.385, 0.37], "arms": [-0.03, 0.47, 0.62, 0.16], "face": [0.32, 0.30], "drinkSay": "啜——", "stretchSay": null,
			"acts": [["type", 5.0, [4.0, 8.0], 0.0], ["drink", 1.4, [3.8, 3.8], 11.0], ["neck", 1.1, [3.0, 3.0], 9.0], ["vibe", 1.2, [3.5, 5.0], 8.0], ["roll", 0.8, [3.0, 3.0], 8.0], ["spin", 0.5, [2.6, 2.6], 14.0]],
			"bones": [["thigh", null, 0.80, 0.70, 0.20, 0.70, 0.13], ["shin", null, 0.25, 0.72, 0.22, 0.99, 0.14], ["body", null, 0.72, 0.68, 0.55, 0.45, 0.22], ["hair", "body", 0.62, 0.30, 0.86, 0.55, 0.16], ["head", "body", 0.48, 0.44, 0.42, 0.06, 0.34], ["armF", "body", 0.52, 0.48, 0.06, 0.56, 0.09]]},
	}
	for k in STATIONS:
		var s = STATIONS[k]; s["SEATV"] = {"x": n_(s.seat.x) + n_(s.koff), "y": s.seat.y}
	use(STATIONS.ken); K = null
	DEF = [
		{"id": "cabinet", "spr": "of_cabinet", "x": 0.135, "y": 0.505, "h": 0.70, "shadow": 0.62,
			"kids": [{"id": "binder1", "spr": "op_binder", "u": 0.30, "v": 0.055, "h": 0.19, "fall": 1.0}, {"id": "binder2", "spr": "op_binder", "u": 0.47, "v": 0.05, "h": 0.19, "fall": 1.0, "flip": 1.0}, {"id": "stack", "spr": "op_stack", "u": 0.74, "v": 0.07, "h": 0.13, "fall": 1.0}]},
		{"id": "idesk", "spr": "of_desk_back_empty", "x": 0.0, "y": 0.0, "uy": 0.515, "z": 0.515, "h": 0.90, "ax": 360.0 / 567.0, "ay": 52.0 / 435.0, "shadow": 1.25, "shu": 0.5, "shv": 0.9, "floorV": 0.966, "stn": "it", "back": 1.0,
			"kids": [{"id": "lamp", "spr": "of_lamp", "u": 0.16, "v": 0.31, "h": 0.30, "ax": 0.78, "lamp": 1.0}, {"id": "icactus", "spr": "op_cactus", "u": 0.86, "v": 0.30, "h": 0.11, "fall": 1.0}, {"id": "ipaper", "spr": "op_paper", "u": 0.28, "v": 0.16, "h": 0.075, "paper": 1.0, "rot": 0.2},
				{"id": "imon", "spr": "op_mon_back", "u": 0.45, "v": 0.33, "h": 0.50, "ax": 0.5, "ay": 0.96, "mon": 1.0, "stn": "it", "back": 1.0}]},
		{"id": "achair", "spr": "of_chair_back", "x": 0.45, "y": 0.59, "h": 0.66, "shadow": 0.5, "chair": 1.0},
		{"id": "copier", "spr": "of_copier", "x": 0.705, "y": 0.515, "h": 0.74, "ay": 0.97, "shadow": 0.9, "copier": 1.0},
		{"id": "water", "spr": "of_water", "x": 0.83, "y": 0.51, "h": 0.80, "ay": 0.985, "shadow": 0.42, "water": 1.0},
		{"id": "fan", "spr": "of_fan", "x": 0.03, "y": 0.56, "wx": n_(om("npx", [5180.0])), "wy": 0.74, "h": 0.78, "shadow": 0.42, "fan": 1.0},
		{"id": "bin", "spr": "op_bin", "x": 0.245, "y": 0.522, "h": 0.22, "shadow": 0.3},
		{"id": "kdesk", "spr": "of_desk_back_empty", "x": 0.0, "y": 0.0, "uy": 0.60, "z": 0.60, "h": 0.90, "ax": 360.0 / 567.0, "ay": 52.0 / 435.0, "shadow": 1.25, "shu": 0.5, "shv": 0.9, "floorV": 0.966, "stn": "ken", "back": 1.0,
			"kids": [{"id": "kmug", "spr": "op_mug_back", "u": 0.22, "v": 0.34, "h": 0.12, "mug": 1.0, "fall": 1.0}, {"id": "kpaper", "spr": "op_paper", "u": 0.30, "v": 0.15, "h": 0.075, "paper": 1.0, "rot": 0.25},
				{"id": "kmon", "spr": "op_mon_back", "u": 0.45, "v": 0.33, "h": 0.50, "ax": 0.5, "ay": 0.96, "mon": 1.0, "stn": "ken", "back": 1.0}]},
	]
	var WS = [[5430.0, 0.715, 1.0], [5810.0, 0.715, 0.0], [8790.0, 0.715, 1.0], [9170.0, 0.715, 0.0], [9550.0, 0.715, 1.0], [10330.0, 0.885, 1.0]]
	var PXU = n_(J.gp(OM(), "PXU"))
	for i in WS.size():
		var px = WS[i][0]; var y = WS[i][1]; var on = WS[i][2]
		DEF.append({"id": "wsch" + str(i), "spr": "of_chair_front", "wx": px / PXU + (-0.085 if i % 2 else 0.085), "wy": y - 0.004, "h": 0.6, "ay": 0.98, "shadow": 0.45, "flip": float(i % 2)})
		var kk = [{"id": "wsm" + str(i), "spr": "op_mon_back", "u": 0.47, "v": 0.33, "h": 0.5, "ax": 0.5, "ay": 0.96}, {"id": "wsk" + str(i), "spr": "op_keyboard", "u": 0.5, "v": 0.2, "h": 0.06}]
		if i % 3 == 1: kk.append({"id": "wsg" + str(i), "spr": "op_mug_back", "u": 0.2, "v": 0.34, "h": 0.12})
		DEF.append({"id": "ws" + str(i), "spr": "of_desk_back_empty", "wx": px / PXU, "wy": y, "h": 0.9, "ay": 0.97, "shadow": 1.1, "glow": on, "kids": kk})
	CLOCK = {"x": 0.815, "y": 0.335, "d": 0.42, "depth": 0.48}
	TUBES = [[0.075, 0.042, 0.34, 0.034], [0.59, 0.042, 0.345, 0.038], [0.165, 0.148, 0.24, 0.022], [0.535, 0.148, 0.25, 0.022], [0.215, 0.204, 0.185, 0.012], [0.51, 0.204, 0.18, 0.012]]
	AC = [0.815, 0.148, 0.16, 0.097]; WIN = J.gp(OM(), "WINMAIN")
	SIT = {"npc_ken_sit": [0.982, 0.99, 598.0], "npc_ken_sit_stretch": [0.603, 0.99, 606.0], "npc_ken_sit_coffee": [0.87, 0.992, 621.0], "npc_ken_sit_jump": [0.822, 0.992, 627.0],
		"npc_it_sit": [0.80, 0.99, 598.0], "npc_it_sit_tea": [0.71, 0.99, 606.0], "npc_it_sit_jump": [0.64, 0.99, 618.0]}
	CHAIR = {"spr": "of_chair_front", "back": 0.64, "seat": 0.40, "h": 0.60}
	EV = J.gp(OM(), "ELEV")
	ELEV = {"x0": EV.x0, "x1": EV.x1, "seam": EV.seam, "top": [EV.top, EV.top], "bot": [EV.bot, EV.bot]}
	MIS_ACTS = [["copy", 2.4, [3.0, 5.0], 3.0], ["nails", 2.2, [3.0, 5.0], 0.0], ["selfie", 1.6, [3.2, 3.2], 7.0], ["hair", 1.3, [2.6, 2.6], 6.0], ["stand", 1.0, [1.5, 3.0], 0.0]]
	MIS_SAY = {"selfie": "唔該你哋行開少少，阻住我影相。", "sigh": "陳總～人哋要放假啦～", "roll": "呢啲嘢搵阿Ken做啦。"}

static func use(s: Dictionary) -> Dictionary:
	STN = s; SEAT = s.seat; SEATV = s.SEATV; K = s.get("K"); return s
static func stn_of(n):
	if not (n is Dictionary) or not (n.get("d") is Dictionary): return null
	var k = J.str(n.d.get("k"))
	return STATIONS.get(k)
static func ken_off(n) -> float:
	var s = stn_of(n)
	if s == null: return 0.0
	return n_(s.koff) * maxf(0.0, 1 - hyp(n_(n.x) - n_(s.seat.x), n_(n.y) - n_(s.seat.y)) / 0.07)
static func each_stn(fn: Callable) -> void:
	var keep = STN
	for k in STATIONS:
		if J.t(STATIONS[k].get("K")): use(STATIONS[k]); fn.call(STATIONS[k])
	use(keep)

# ---------------- init ----------------
static func init(S) -> void:
	SC = S; items = {}; list = []; kids = []; flying = []; floor_ = []; drops = []
	var PS = J.gp(OM(), "SPOT")
	for d in DEF:
		var it = assign({"ax": 0.5, "ay": 1.0, "dx": 0.0, "dy": 0.0, "rot": 0.0, "vr": 0.0, "sx": 1.0, "sy": 1.0, "ph": randf() * 6}, d, {"kids": []})
		if d.get("wx") != null: it["x"] = d.wx; it["y"] = d.wy
		elif not J.t(d.get("stn")): it["x"] = n_(om("M", [d.x])); it["y"] = n_(om("MY", [d.y]))
		if J.t(d.get("water")): it["x"] = n_(om("npx", [4050.0]))
		if J.t(d.get("copier")): it["x"] = J.gp(PS, "copier")[0]; it["y"] = J.gp(PS, "copier")[1]; it["h"] = 0.62
		items[d.id] = it; list.append(it)
		for kd in d.get("kids", []):
			var r0 = or0(kd.get("rot"))
			var c = assign({"ax": 0.5, "ay": 1.0, "dx": 0.0, "dy": 0.0, "rot": r0, "base": r0, "vr": 0.0, "sx": 1.0, "sy": 1.0, "hide": 0.0, "ph": randf() * 6}, kd, {"parent": it})
			it.kids.append(c); items[kd.id] = c; kids.append(c)
	st = {"t": 0.0, "fan": {"osc": 0.0, "spin": 0.0, "boost": 0.0}, "clock": {"spin": 0.0, "ang": 0.0}, "lamp": {"flick": 0.0, "sway": 0.0, "vs": 0.0}, "ac": {"blow": 0.0}, "water": {"glug": 0.0}, "copier": {"print": 0.0, "out": 0.0}, "tubes": 0.0, "rustle": 0.0, "flutter": 0.0, "lights": null, "dropQ": [], "clockF": null, "chairSpin": 0.0, "creak": 0.0}
	for k in STATIONS:
		var s = use(STATIONS[k]); s["monSt"] = {"seq": -1.0}; s["offline"] = false; layout_ken(); reset_ken()
	use(STATIONS.ken)

static func persp() -> Dictionary: return scm("persp")
static func ken_uw(y: float) -> float:
	var pp = persp(); return (n_(pp.c) * (y - n_(pp.hz))) * KEN_H * n_(scm("bgAR"))
static func layout_ken() -> void:
	var d = items[STN.desk]; var pp = persp(); var uf = n_(pp.c) * (n_(SEAT.y) - n_(pp.hz)) * KEN_H
	d["x"] = n_(SEATV.x) - n_(STN.hand[0]) * ken_uw(n_(SEAT.y)); d["y"] = n_(SEAT.y) - n_(STN.hand[1]) * uf
	d["z"] = n_(d.y) + (n_(d.floorV) - n_(d.ay)) * n_(d.h) * uf; d["uy"] = SEAT.y

# ---------------- 阿Ken ----------------
static func reset_ken() -> void:
	K = {"mode": "sit", "mt": 0.0, "act": "type", "at": 0.0, "dur": 6.0, "cd": {}, "w": 1.0, "pop": 0.0, "keys": [], "ch": {"dx": 0.0, "dz": 0.0, "vx": 0.0, "vz": 0.0, "sw": 0.0, "vs": 0.0, "lean": 0.0, "occ": true}, "kick": 0.0, "look": 0.0}
	STN["K"] = K
static func pick_act() -> void:
	var opts = []
	for e in STN.acts: if or0(K.cd.get(e[0])) <= 0 and e[0] != K.act: opts.append(e)
	var tot = 0.0
	for e in opts: tot += e[1]
	var r = randf() * tot; var e = opts[0]
	for o in opts:
		r -= o[1]
		if r <= 0: e = o; break
	K["act"] = e[0]; K["at"] = 0.0; K["dur"] = e[2][0] + randf() * (e[2][1] - e[2][0]); K.cd[e[0]] = e[3] + K.dur
	if K.act != "type" or randf() < 0.5: K["pop"] = 0.18
static func at_desk(n) -> bool:
	return not J.t(n.get("fleeing")) and not J.t(n.get("gone")) and J.str(n.get("act")) == "work" and absf(n_(n.x) - n_(SEAT.x)) < 0.002 and absf(n_(n.y) - n_(SEAT.y)) < 0.002
static func seated(n) -> bool:
	var s = stn_of(n)
	if s == null or not J.t(s.get("K")): return false
	var m = J.str(s.K.mode)
	return m == "sit" or m == "jump" or m == "rise" or m == "sitdown"
static func ken_tick(n, dt: float) -> void:
	if n is Dictionary and n.get("d") is Dictionary and J.str(n.d.get("k")) == "mis": mis_tick(n, dt); return
	var s = stn_of(n)
	if s == null or not J.t(s.get("K")): return
	use(s)
	var rx = n.rx if n.get("rx") is Dictionary and n_(n.rx.get("t")) >= 0 else null
	var ch = K.ch
	var big = rx != null and (J.str(rx.k) == "startle" or J.str(rx.k) == "weakjump" or J.str(rx.k) == "burst")
	var fear = n_(n.get("fear"))
	var calm = fear < 25 and (rx == null or J.str(rx.k) == "numb" or J.str(rx.k) == "sip")
	K["mt"] = n_(K.mt) + dt; K["pop"] = maxf(0.0, n_(K.pop) - dt)
	for k in K.cd: K.cd[k] = n_(K.cd[k]) - dt
	match J.str(K.mode):
		"sit":
			ch["occ"] = true
			if not at_desk(n): K["mode"] = "rise"; K["mt"] = 0.0; ch["vx"] = 0.12; ch["vz"] = -0.03
			elif big or fear >= 50:
				K["mode"] = "jump"; K["mt"] = 0.0
				var sg = -1.0 if rx != null and rx.get("src") != null and n_(rx.src) > n_(n.x) else 1.0
				ch["vx"] = 0.16 * sg + 0.1; ch["vz"] = -0.03 - randf() * 0.015; ch["vs"] = (-1.0 if randf() < 0.5 else 1.0) * (6 + randf() * 4); K["kick"] = 1.0
				if J.t(STN.mug): spill(items.get(STN.mug), 0.8)
				on_scare(n_(SEATV.x) - 0.06, n_(SEAT.y), 0.7)
			else:
				K["at"] = n_(K.at) + dt
				if n_(K.at) >= n_(K.dur): pick_act()
		"jump":
			ch["occ"] = false
			if n_(K.mt) > 0.62: K["mode"] = "up"; K["mt"] = 0.0
		"rise":
			ch["occ"] = true
			if n_(K.mt) > 0.34: K["mode"] = "up"; K["mt"] = 0.0; ch["occ"] = false
		"up":
			ch["occ"] = false
			if at_desk(n) and calm and n_(K.mt) > 0.6:
				K["mode"] = "pull"; K["mt"] = 0.0; K["p0"] = {"dx": ch.dx, "dz": ch.dz, "sw": ch.sw}; ch["vx"] = 0.0; ch["vz"] = 0.0; ch["vs"] = 0.0
		"pull":
			ch["occ"] = false
			var kq = ss(n_(K.mt) / 0.7)
			if not at_desk(n) or not calm: K["mode"] = "up"; K["mt"] = 0.0
			else:
				ch["dx"] = lerp_(n_(K.p0.dx), 0.0, kq); ch["dz"] = lerp_(n_(K.p0.dz), 0.0, kq); ch["sw"] = lerp_(n_(K.p0.sw), jround(n_(K.p0.sw) / (2 * PI)) * 2 * PI, kq)
				if n_(K.mt) >= 0.7: ch["sw"] = 0.0; K["mode"] = "sitdown"; K["mt"] = 0.0
		"sitdown":
			ch["occ"] = true
			if n_(K.mt) > 0.32: K["mode"] = "sit"; K["mt"] = 0.0; K["act"] = "type"; K["at"] = 0.0; K["dur"] = 3 + randf() * 3
	var spin_on = st != null and n_(st.chairSpin) > 0
	if not J.t(ch.occ) and J.str(K.mode) != "jump": self_spin(ch, n_(SEATV.x) + n_(ch.dx), n_(SEAT.y) + n_(ch.dz), dt)
	if not J.t(ch.occ) or J.str(K.mode) == "jump":
		ch["dx"] = n_(ch.dx) + n_(ch.vx) * dt; ch["dz"] = n_(ch.dz) + n_(ch.vz) * dt; ch["sw"] = n_(ch.sw) + n_(ch.vs) * dt
		var f = exp(-dt * (0.6 if spin_on else 2.0)); ch["vx"] = n_(ch.vx) * f; ch["vz"] = n_(ch.vz) * f; ch["vs"] = n_(ch.vs) * exp(-dt * (0.2 if spin_on else 1.4))
		if n_(ch.dx) > 0.13: ch["dx"] = 0.13; ch["vx"] = -absf(n_(ch.vx)) * 0.3
		if n_(ch.dx) < -0.01: ch["dx"] = -0.01; ch["vx"] = absf(n_(ch.vx)) * 0.3
		if n_(ch.dz) > 0.05: ch["dz"] = 0.05; ch["vz"] = -absf(n_(ch.vz)) * 0.3
		if n_(ch.dz) < -0.035: ch["dz"] = -0.035; ch["vz"] = 0.0
		if absf(n_(ch.vs)) < 0.6: ch["sw"] = lerp_(n_(ch.sw), jround(n_(ch.sw) / (2 * PI)) * 2 * PI, 1 - exp(-dt * 2)); ch["vs"] = n_(ch.vs) * 0.9
	var want_dx = 0.0; var want_sw = 0.0; var want_lean = 0.0
	if J.str(K.mode) == "sit":
		var a = n_(K.at); var dur = n_(K.dur); var e = ss(a / 0.4) * ss((dur - a) / 0.4); var act = J.str(K.act)
		if fear >= 25 and not big: want_sw = sin(n_(K.mt) * 1.6) * 0.28
		elif act == "roll": want_dx = sin(a * 2.1) * 0.016 * e
		elif act == "spin": want_sw = sin(a * 2.4) * 0.55 * e
		elif act == "stretch" or act == "neck": want_lean = -0.12 * bump(a, 0.2, 0.6, 2.8)
		elif act == "drink" and J.str(STN.k) == "it": want_lean = -0.08 * bump(a, 0.4, 0.9, 3.4)
		ch["dx"] = lerp_(n_(ch.dx), want_dx, 1 - exp(-dt * 8)); ch["sw"] = lerp_(n_(ch.sw), want_sw, 1 - exp(-dt * 6)); ch["dz"] = lerp_(n_(ch.dz), 0.0, 1 - exp(-dt * 6))
	ch["lean"] = lerp_(n_(ch.lean), want_lean, 1 - exp(-dt * 7))
	if J.str(K.mode) == "sit" and J.str(K.act) == "type" and fear < 25 and randf() < dt * 14:
		var a2 = (randf() - 0.5) * 2; var b2 = (randf() - 0.5) * 2
		K.keys.append({"u": (375 + a2 * 80 - b2 * 5) / 567.0, "v": (47 + a2 * 25 + b2 * 15) / 435.0, "life": 0.18})
	var keep = []
	for kk in K.keys:
		kk["life"] = n_(kk.life) - dt
		if n_(kk.life) > 0: keep.append(kk)
	K["keys"] = keep

# ---------------- 每幀：家具 ----------------
static func tick(dt: float) -> void:
	if st == null: return
	st["t"] = n_(st.t) + dt
	var f = st.fan; f["boost"] = maxf(0.0, n_(f.boost) - dt * 0.18); f["osc"] = n_(f.osc) + dt * (0.55 + n_(f.boost) * 1.6); f["spin"] = n_(f.spin) + dt * (9 + n_(f.boost) * 28)
	st.clock["spin"] = maxf(0.0, n_(st.clock.spin) - dt); st.clock["ang"] = n_(st.clock.ang) + dt * n_(st.clock.spin) * 14
	var L = st.lamp; L["flick"] = maxf(0.0, n_(L.flick) - dt); L["vs"] = n_(L.vs) + (-n_(L.sway) * 60 - n_(L.vs) * 4) * dt; L["sway"] = n_(L.sway) + n_(L.vs) * dt
	st.ac["blow"] = maxf(0.0, n_(st.ac.blow) - dt); st.water["glug"] = maxf(0.0, n_(st.water.glug) - dt); st["rustle"] = maxf(0.0, n_(st.rustle) - dt * 0.8); st["flutter"] = maxf(0.0, n_(st.flutter) - dt * 0.7)
	var q2 = []
	for q in st.dropQ:
		q["at"] = n_(q.at) - dt
		if n_(q.at) > 0: q2.append(q); continue
		if J.t(q.get("clock")):
			if not J.t(st.get("clockF")): st["clockF"] = {"t": 0.0, "z": 0.15, "vz": 0.0, "rot": 0.0, "b": 0.0, "rest": 0.0}
		else: start_fall(items.get(q.id), n_(q.dir), 0.15)
	st["dropQ"] = q2
	if J.t(st.get("clockF")):
		var F = st.clockF; F["t"] = n_(F.t) + dt
		if n_(F.t) > 0.3: F["vz"] = n_(F.vz) - 1.3 * dt; F["z"] = n_(F.z) + n_(F.vz) * dt; F["rot"] = n_(F.rot) + dt * 3 * (1.0 if n_(F.z) > 0 else 0.0)
		if n_(F.z) <= 0:
			F["z"] = 0.0
			if F.get("land") == null: F["land"] = F.t
			if absf(n_(F.vz)) > 0.08 and n_(F.b) < 1: F["vz"] = -n_(F.vz) * 0.3; F["b"] = n_(F.b) + 1
			else: F["vz"] = 0.0; F["rest"] = n_(F.rest) + dt; F["rot"] = lerp_(n_(F.rot), 1.35, 1 - exp(-dt * 8))
		if n_(F.rest) > 11: st["clockF"] = null; st["clockBack"] = 0.6
	st["clockBack"] = maxf(0.0, or0(st.get("clockBack")) - dt)
	if J.t(st.get("lights")):
		st.lights["t"] = n_(st.lights.t) + dt
		if n_(st.lights.t) > 3.6: st["lights"] = null
	st["chairSpin"] = maxf(0.0, n_(st.chairSpin) - dt); st["creak"] = maxf(0.0, n_(st.creak) - dt)
	var C = st.copier; C["print"] = maxf(0.0, n_(C.print) - dt); C["idle"] = maxf(0.0, or0(C.get("idle")) - dt); st["door"] = maxf(0.0, or0(st.get("door")) - dt)
	if n_(C.print) > 0.2:
		C["out"] = n_(C.out) - dt
		if n_(C.out) <= 0: C["out"] = 0.12 + randf() * 0.1; copier_paper()
	for k in STATIONS:
		var m = STATIONS[k].get("monSt")
		if J.t(m) and n_(m.seq) >= 0:
			m["seq"] = n_(m.seq) + dt
			if n_(m.seq) > 1.7: m["seq"] = -1.0
	if randf() < dt * 0.25: st["tubes"] = 0.25
	st["tubes"] = maxf(0.0, n_(st.tubes) - dt)
	for c in kids + list:
		var base = or0(c.get("base"))
		if J.t(c.get("vr")) or n_(c.rot) != base:
			var mug = J.t(c.get("mug"))
			c["vr"] = n_(c.vr) + (-(n_(c.rot) - base) * (90.0 if mug else 40.0) - n_(c.vr) * (5.0 if mug else 3.0)) * dt; c["rot"] = n_(c.rot) + n_(c.vr) * dt
			if absf(n_(c.vr)) < 0.001 and absf(n_(c.rot) - base) < 0.001: c["vr"] = 0.0; c["rot"] = base
		if n_(c.get("hide")) > 0: c["hide"] = maxf(0.0, n_(c.hide) - dt)
		if J.t(c.get("falling")): fall_tick(c, dt)
		if J.t(c.get("chair")) and c.get("parent") == null: chair_tick(c, dt)
	for p in flying: paper_tick(p, dt)
	var fl2 = []
	for p in flying: if not J.t(p.get("landed")): fl2.append(p)
	flying = fl2
	var fo2 = []
	for p in floor_:
		p["life"] = n_(p.life) - dt
		if n_(p.life) > 0: fo2.append(p)
	floor_ = fo2
	var dr2 = []
	for p in drops:
		p["life"] = n_(p.life) - dt
		if n_(p.life) > 0: dr2.append(p)
	drops = dr2
	for d in drops:
		if not J.t(d.get("land")):
			d["vz"] = n_(d.vz) - 2.2 * dt; d["z"] = n_(d.z) + n_(d.vz) * dt; d["ox"] = n_(d.ox) + n_(d.vx) * dt
			if n_(d.z) <= 0: d["z"] = 0.0; d["land"] = true

static func nearest_to(x: float, y: float):
	var b = null; var bd = 9.0
	for n in J.iter(J.gp(SC, "npcs")):
		if J.t(n.get("gone")): continue
		var d = hyp(n_(n.x) - x, n_(n.y) - y)
		if d < bd: bd = d; b = n
	return b
static func self_spin(ch: Dictionary, x: float, y: float, dt: float) -> void:
	if n_(st.chairSpin) <= 0: return
	var k = minf(1.0, n_(st.chairSpin) / 0.6); var n = nearest_to(x, y)
	ch["vs"] = (1.0 if or0(ch.get("vs")) >= 0 else -1.0) * maxf(absf(or0(ch.get("vs"))), 7 * k + 1)
	if n != null:
		var dx = n_(n.x) - x; var dy = n_(n.y) - y; var d = hyp(dx, dy)
		if d == 0: d = 1.0
		if d > 0.08: ch["vx"] = or0(ch.get("vx")) + dx / d * 0.09 * k * dt; ch["vz"] = or0(ch.get("vz")) + dy / d * 0.05 * k * dt
static func chair_tick(c: Dictionary, dt: float) -> void:
	for k in ["vx", "vs", "sw", "ox", "oz", "vz"]: c[k] = or0(c.get(k))
	self_spin(c, n_(c.x) + n_(c.ox), n_(c.y) + n_(c.oz), dt)
	var spin_on = n_(st.chairSpin) > 0
	c["ox"] = n_(c.ox) + n_(c.vx) * dt; c["vx"] = n_(c.vx) * exp(-dt * (0.6 if spin_on else 2.2)); c["sw"] = n_(c.sw) + n_(c.vs) * dt; c["vs"] = n_(c.vs) * exp(-dt * (0.2 if spin_on else 1.5))
	c["oz"] = n_(c.oz) + n_(c.vz) * dt; c["vz"] = n_(c.vz) * exp(-dt * 1.2); c["oz"] = cl(n_(c.oz), -0.01, 0.1); c["ox"] = cl(n_(c.ox), -0.12, 0.2)
	if n_(st.chairSpin) <= 0: c["ox"] = n_(c.ox) + -n_(c.ox) * dt * 0.25; c["oz"] = n_(c.oz) + -n_(c.oz) * dt * 0.25
	if absf(n_(c.vs)) < 0.6: c["sw"] = lerp_(n_(c.sw), jround(n_(c.sw) / (2 * PI)) * 2 * PI, 1 - exp(-dt * 2))
static func start_fall(c, dir: float, kick := 0.0) -> void:
	if not (c is Dictionary) or J.t(c.get("falling")) or n_(c.get("hide")) > 0: return
	var p = c.parent; var fv = n_(p.floorV) if p.get("floorV") != null else n_(p.ay)
	var vx = dir * (0.18 + randf() * 0.15)
	c["falling"] = {"t": 0.0, "z": maxf(0.05, (fv - n_(c.v)) * n_(p.h)), "vz": 0.25 + kick, "vx": vx, "x": 0.0, "dir": dir, "b": 0.0, "tip": 0.25 if J.str(c.spr) == "op_binder" else 0.12, "off": false, "land": -1.0}
static func fall_tick(c: Dictionary, dt: float) -> void:
	var F = c.falling; F["t"] = n_(F.t) + dt
	if n_(F.t) < n_(F.tip): c["rot"] = n_(c.base) + n_(F.dir) * ss(n_(F.t) / n_(F.tip)) * 0.5; return
	F["off"] = true; F["vz"] = n_(F.vz) - 6 * dt; F["z"] = n_(F.z) + n_(F.vz) * dt; F["x"] = n_(F.x) + n_(F.vx) * dt; c["rot"] = n_(c.rot) + n_(F.dir) * 7 * dt * (1.0 if n_(F.z) > 0 else 0.0)
	if n_(F.z) <= 0:
		F["z"] = 0.0
		if n_(F.land) < 0: F["land"] = F.t
		if absf(n_(F.vz)) > 0.5 and n_(F.b) < 1: F["vz"] = -n_(F.vz) * 0.3; F["b"] = n_(F.b) + 1
		else:
			F["vz"] = 0.0; F["vx"] = n_(F.vx) * exp(-dt * 8); F["rest"] = or0(F.get("rest")) + dt
			var tgt = n_(F.dir) * (PI / 2 if J.t(c.get("mug")) else (0.15 if J.str(c.spr) == "op_stack" else PI / 2))
			c["rot"] = lerp_(n_(c.rot), tgt, 1 - exp(-dt * 10))
	if or0(F.get("rest")) > 11: c["falling"] = null; c["rot"] = c.base; c["hide"] = 0.6
static func paper_tick(p: Dictionary, dt: float) -> void:
	p["t"] = n_(p.t) + dt; p["vz"] = n_(p.vz) - 1.1 * dt; p["vz"] = maxf(n_(p.vz), -0.25); p["z"] = n_(p.z) + n_(p.vz) * dt
	p["x"] = n_(p.x) + (n_(p.vx) + sin(n_(p.t) * 4 + n_(p.ph)) * 0.05) * dt; p["y"] = n_(p.y) + n_(p.vy) * dt; p["vx"] = n_(p.vx) * exp(-dt * 0.8)
	p["rot"] = n_(p.rot) + n_(p.vr) * dt; p["vr"] = n_(p.vr) * exp(-dt * 0.6)
	if n_(p.z) <= 0: p["landed"] = true; floor_.append({"x": p.x, "y": p.y, "rot": n_(p.rot) * 0.3, "life": 14.0, "max": 14.0, "w": n_(p.w) * 1.3})
static func copier_paper() -> void:
	var c = items.copier; var x0 = n_(c.x) - 0.33 * 0.74 * UW(n_(c.y))
	var vx = -0.05 - randf() * 0.1; var vy = 0.02 + randf() * 0.05; var vz = 0.25 + randf() * 0.3; var rot = randf() * 6; var vr = (randf() - 0.5) * 9; var ph = randf() * 6
	flying.append({"x": x0, "y": n_(c.y) + 0.004, "z": 0.42, "vx": vx, "vy": vy, "vz": vz, "rot": rot, "vr": vr, "t": 0.0, "ph": ph, "w": 0.16})
static func paper_fly(c: Dictionary, pow_: float) -> void:
	if n_(c.get("hide")) > 0 or n_(c.get("flown")) > 0: return
	var p = c.parent; var im = img(J.str(p.spr))
	var x = n_(p.x) + (n_(c.u) - n_(p.ax)) * n_(p.h) * UW(n_(p.y)) * cw_(im) / ch_(im); var y = n_(p.y)
	var vx = (randf() - 0.5) * 0.25 * pow_; var vy = 0.03 + randf() * 0.04; var vz = 0.3 + randf() * 0.4 * pow_; var vr = (randf() - 0.5) * 12; var ph = randf() * 6
	flying.append({"x": x, "y": y + 0.004, "z": 0.47, "vx": vx, "vy": vy, "vz": vz, "rot": c.rot, "vr": vr, "t": 0.0, "ph": ph, "w": 0.15})
	c["hide"] = 16.0
static func spill(m, pow_: float) -> void:
	if not (m is Dictionary) or n_(m.get("hide")) > 0: return
	m["vr"] = n_(m.vr) + (-1.0 if randf() < 0.5 else 1.0) * (4 + pow_ * 8)
	if pow_ < 0.7: return
	var p = m.parent
	for i in 7:
		var vx = (randf() - 0.5) * 0.25; var vz = 0.25 + randf() * 0.3
		drops.append({"u": m.u, "v": m.v, "ox": 0.0, "z": 0.06, "vx": vx, "vz": vz, "life": 2.5, "desk": p})
	m["puddle"] = 6.0

# ---------------- 有人嚇人 ----------------
static func _near(it, x: float, y: float, r: float) -> bool: return hyp(n_(it.x) - x, (n_(it.y) - y) * 1.6) < r
static func on_scare(x: float, y: float, pow_: float) -> void:
	if st == null: return
	pow_ = cl(pow_, 0.0, 1.2)
	st.fan["boost"] = minf(1.5, n_(st.fan.boost) + pow_ * 0.8); st.clock["spin"] = maxf(n_(st.clock.spin), 1.2 + pow_); st["flutter"] = maxf(n_(st.flutter), pow_)
	for c in kids:
		var p = c.parent
		if not _near(p, x, y, 0.42): continue
		if J.t(c.get("paper")):
			if pow_ > 0.55: paper_fly(c, pow_)
			else: c["vr"] = n_(c.vr) + (randf() - 0.5) * 6 * pow_
		if J.t(c.get("mug")): spill(c, pow_)
		if J.t(c.get("mon")) and pow_ > 0.3 and J.t(c.get("stn")): STATIONS[J.str(c.stn)].monSt["seq"] = 0.0
		if J.t(c.get("fall")) and pow_ > 0.5 and not J.t(c.get("falling")) and (J.str(c.id) == "binder1" or J.str(c.id) == "binder2") and randf() < 0.8: start_fall(c, -1.0 if J.str(c.id) == "binder1" else 1.0)
		if J.t(c.get("lamp")): st.lamp["vs"] = n_(st.lamp.vs) + (randf() - 0.5) * 3 * pow_
	var a = items.achair
	if _near(a, x, y, 0.5):
		var sd = sgn(n_(a.x) - x); if sd == 0: sd = 1.0
		a["vx"] = or0(a.get("vx")) + sd * 0.1 * pow_; a["vs"] = or0(a.get("vs")) + (randf() - 0.5) * 9 * pow_
	each_stn(func(_s):
		if not J.t(K.ch.occ):
			var sd2 = sgn(n_(SEATV.x) + n_(K.ch.dx) - x); if sd2 == 0: sd2 = 1.0
			K.ch["vx"] = n_(K.ch.vx) + sd2 * 0.08 * pow_; K.ch["vs"] = n_(K.ch.vs) + (randf() - 0.5) * 8 * pow_)
	if J.t(items.get("plant")) and _near(items.plant, x, y, 0.5): st["rustle"] = maxf(n_(st.rustle), pow_)
	if _near(items.water, x, y, 0.4): items.water["vr"] = n_(items.water.vr) + (randf() - 0.5) * 2 * pow_
static func on_prop(k: String) -> void:
	if st == null: return
	if k == "lamp": st.lamp["flick"] = 2.2; st.lamp["vs"] = n_(st.lamp.vs) + 3.5; st["tubes"] = 2.2; on_scare(n_(items.idesk.x), n_(items.idesk.y), 0.35)
	if k == "ac":
		st.ac["blow"] = 2.6
		for c in kids: if J.t(c.get("paper")): c["vr"] = n_(c.vr) + (randf() - 0.5) * 5
		st["flutter"] = 1.2; st["rustle"] = 1.2
	if k == "water": st.water["glug"] = 2.4; items.water["vr"] = n_(items.water.vr) + 1.6
	if k == "printer": st.copier["print"] = 2.2; st.copier["out"] = 0.0; on_scare(n_(items.copier.x), n_(items.copier.y), 0.6)
	if k == "lights": st["lights"] = {"t": 0.0}; st["tubes"] = 0.0
	if k == "drop":
		var kk = STATIONS.ken.get("K"); var cofe = J.t(kk) and J.str(kk.mode) == "sit" and J.str(kk.act) == "drink"
		var q = []
		for e in [["binder1", -1.0, 0.0], ["binder2", 1.0, 0.22], ["stack", 1.0, 0.45], ["kmug", -1.0, 0.75], ["icactus", 1.0, 1.0]]:
			if e[0] == "kmug" and cofe: continue
			q.append({"id": e[0], "dir": e[1], "at": e[2]})
		st["dropQ"] = q
		on_scare(n_(items.cabinet.x), n_(items.cabinet.y), 0.3)
	if k == "chair":
		st["chairSpin"] = 2.8; st["creak"] = 2.8; var a = items.achair; a["vs"] = or0(a.get("vs")) + 6
		each_stn(func(_s): if not J.t(K.ch.occ): K.ch["vs"] = n_(K.ch.vs) + 6)

# ---------------- 玩電燈：黑幕 ----------------
static func lights_dark() -> Array:
	var L = st.get("lights") if st != null else null
	if not J.t(L): return [0.0, 0.0, 0.0]
	var q = n_(L.t); var fl = 0.55 if sin(q * 37) + sin(q * 23) > 0.6 else 0.08
	if q < 0.9: return [fl, fl, fl]
	if q < 2.7:
		var out = []
		for i in 3:
			var t0 = 0.9 + i * 0.3
			out.append(fl if q < t0 else minf(0.74, 0.2 + (q - t0) * 3))
		return out
	return [0.0, 0.0, 0.0]
static func kid_pos(c: Dictionary) -> Array:
	var p = c.parent; var F = frame_of(p); var sg = -1.0 if J.t(p.get("flip")) else 1.0
	return [F.x + sg * (n_(c.u) - n_(p.ax)) * F.w, F.y + (n_(c.v) - n_(p.ay)) * F.h, F.u]
static func mon_state(c) -> String:
	var m = STATIONS[J.str(c.stn)].get("monSt") if J.t(c.get("stn")) else null
	var q = n_(m.seq) if J.t(m) else -1.0
	if not J.t(m) or J.t(STATIONS[J.str(c.stn)].get("offline")): return "off"
	if q < 0: return "on"
	if q < 0.55: return "static"
	if q < 1.4: return "off"
	return "static" if sin(q * 60) > 0 else "on"
static func draw_dark(ctx: Ctx, t: float) -> void:
	if st == null: return
	var W = n_(J.gp(SC, "W")); var H = n_(J.gp(SC, "H")); var D = lights_dark(); var L = st.get("lights")
	if D[0] > 0 or D[1] > 0 or D[2] > 0:
		ctx.save()
		for i in 3:
			if D[i] > 0: ctx.fillStyle = rgba(4, 3, 14, D[i]); ctx.fillRect(W * i / 3.0 - 1, 0.0, W / 3.0 + 2, H)
		ctx.globalCompositeOperation = "lighter"
		var dk = maxf(D[0], maxf(D[1], D[2]))
		var glow = func(c, col: String, r: float):
			var kp = kid_pos(c); var x = kp[0]; var y = kp[1]; var u = kp[2]; var R = u * r
			var g = ctx.createRadialGradient(x, y - u * 0.25, 0.0, x, y - u * 0.25, R); g.addColorStop(0.0, col); g.addColorStop(1.0, "rgba(0,0,0,0)")
			ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y - u * 0.25, R, 0.0, PI * 2); ctx.fill()
		for k in STATIONS:
			var m = items.get(STATIONS[k].mon)
			if J.t(m) and mon_state(m) == "on": glow.call(m, rgba(110, 180, 255, 0.5 * dk), 0.7)
		glow.call(items.lamp, rgba(255, 190, 100, 0.45 * dk), 0.6)
		ctx.restore()
	if J.t(L) and n_(L.t) >= 2.7 and n_(L.t) < 3.1: ctx.fillStyle = rgba(255, 250, 230, 0.35 * (1 - (n_(L.t) - 2.7) / 0.4)); ctx.fillRect(0.0, 0.0, W, H)
	if J.t(L) and n_(L.t) > 0.95 and n_(L.t) < 2.6: text(ctx, W * (0.15 + 0.35 * minf(2.0, floor((n_(L.t) - 0.9) / 0.3))), H * 0.12, "啪", H * 0.035, 1 - fmod(n_(L.t) - 0.9, 0.3) / 0.3)
	if n_(st.creak) > 0:
		var a = items.achair; var pp = P(n_(a.x) + or0(a.get("ox")), n_(a.y) + or0(a.get("oz"))); var u = U(n_(a.y)); var k = minf(1.0, n_(st.creak)) * (0.6 + 0.4 * sin(t * 9))
		text(ctx, pp[0] + sin(t * 13) * 2, pp[1] - u * 0.78, "吱——", u * 0.14, k)
		each_stn(func(_s):
			if not J.t(K.ch.occ):
				var kp2 = P(n_(SEATV.x) + n_(K.ch.dx), n_(SEAT.y) + n_(K.ch.dz))
				text(ctx, kp2[0], kp2[1] - u * 0.8, "吱——", u * 0.14, k * 0.9))

# ---------------- 畫 ----------------
static func shadow_at(ctx: Ctx, x: float, y: float, w: float, a = null) -> void:
	ctx.save(); ctx.fillStyle = rgba(6, 4, 18, 0.38 if a == null else a); ctx.beginPath(); ctx.ellipse(x, y, w / 2, w * 0.13, 0.0, 0.0, PI * 2); ctx.fill(); ctx.restore()
static func draw_back(ctx, t: float) -> void:
	om("drawBack", [ctx, t])
	if st == null: return
	draw_door(ctx, t)
static func _yt(x: float) -> float: return n_(ELEV.top[0]) + (x - n_(ELEV.x0)) / (n_(ELEV.x1) - n_(ELEV.x0)) * (n_(ELEV.top[1]) - n_(ELEV.top[0]))
static func _yb(x: float) -> float: return n_(ELEV.bot[0]) + (x - n_(ELEV.x0)) / (n_(ELEV.x1) - n_(ELEV.x0)) * (n_(ELEV.bot[1]) - n_(ELEV.bot[0]))
static func draw_door(ctx: Ctx, t: float) -> void:
	var k0 = or0(st.get("door"))
	if k0 <= 0: return
	var tt = 1.8 - k0; var open = ss(tt / 0.35) if tt < 0.35 else (1 - ss((tt - 1.4) / 0.4) if tt > 1.4 else 1.0)
	var seam = n_(ELEV.seam); var x0 = n_(ELEV.x0); var x1 = n_(ELEV.x1)
	var a = seam - open * (seam - x0 - 0.004); var b = seam + open * (x1 - seam - 0.004)
	if open > 0.01:
		var Q = [P(a, _yt(a)), P(b, _yt(b)), P(b, _yb(b)), P(a, _yb(a))]
		ctx.save(); ctx.beginPath()
		for i in Q.size():
			if i: ctx.lineTo(Q[i][0], Q[i][1])
			else: ctx.moveTo(Q[i][0], Q[i][1])
		ctx.closePath()
		var g = ctx.createLinearGradient(0.0, Q[0][1], 0.0, Q[3][1]); g.addColorStop(0.0, "rgba(255,236,180,.95)"); g.addColorStop(1.0, "rgba(190,160,110,.95)"); ctx.fillStyle = g; ctx.fill()
		ctx.strokeStyle = "rgba(40,30,30,.8)"; ctx.lineWidth = 1.5; ctx.stroke(); ctx.restore()
	var bp = P(n_(EV.btn[0]), n_(EV.btn[1]))
	ctx.save(); ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = rgba(255, 220, 120, 0.6 * minf(1.0, k0)); ctx.beginPath(); ctx.arc(bp[0], bp[1], 4.0, 0.0, PI * 2); ctx.fill(); ctx.restore()
	if tt < 0.8:
		var dp = P(seam, n_(EV.top) - 0.04)
		text(ctx, dp[0], dp[1] - tt * 14, "叮！", U(0.65) * 0.16, 1 - tt / 0.8)
static func clip_window(ctx: Ctx) -> Array:
	var W0 = J.gp(OM(), "WINMAIN"); var p1 = P(n_(W0[0]), n_(W0[1])); var p2 = P(n_(W0[0]) + n_(W0[2]), n_(W0[1]) + n_(W0[3]))
	ctx.beginPath(); ctx.rect(p1[0], p1[1], p2[0] - p1[0], p2[1] - p1[1]); ctx.clip(); return [p1[0], p1[1], p2[0], p2[1]]
static func _nat_ok() -> bool: return J.t(J.gp(SC, "_nat")) and J.G.get("__nat_scItem") != null
static func ken_at_desk(s) -> bool:
	var KK = (s if s != null else STN).get("K")
	if not J.t(KK): return false
	var m = J.str(KK.mode); return m == "sit" or m == "jump" or m == "rise" or m == "sitdown"
static func drawables(t: float) -> Array:
	var out = []
	var vw = J.gp(SC, "_vw"); var cam = or0(J.gp(SC, "camX"))
	for it in list:
		if J.t(vw) and it.get("x") != null and (n_(it.x) < cam - 0.7 or n_(it.x) > cam + n_(vw) + 0.7): continue
		var it2 = it
		if J.t(it.get("chair")):
			out.append([n_(it.y) + or0(it.get("oz")), func(_t, a): ScOffice.draw_free_chair(a[0], SC, it2); return null]); continue
		if J.t(it.get("stn")) and ken_at_desk(STATIONS[J.str(it.stn)]): continue
		out.append([n_(it.z) if it.get("z") != null else n_(it.y), func(_t, a): ScOffice.draw_item(a[0], SC, it2, t); return null])
	each_stn(func(s):
		if not J.t(K.ch.occ):
			var s2 = s
			out.append([n_(SEAT.y) + n_(K.ch.dz) - 0.03, func(_t, a): ScOffice.draw_ken_chair(a[0], SC, s2); return null]))
	for c in kids:
		if J.t(c.get("falling")) and J.t(c.falling.get("off")):
			var c2 = c; var p = c.parent
			out.append([(n_(p.z) if p.get("z") != null else n_(p.y)) + 0.006, func(_t, a): draw_fallen(a[0], c2); return null])
	for p in flying:
		var p2 = p
		out.append([n_(p.y), func(_t, a): draw_flying(a[0], p2, t); return null])
	return out
# drawables 嘅函數係 JS 叫（J.cl(f, null, [ctx])）：第一個參數係 this（null），第二個係參數陣列
static func _c(x):
	if x is Array: return x[0]
	return x
static func draw_floor(ctx: Ctx, _t: float) -> void:
	var im = img("op_paper")
	if im == null: return
	for p in floor_:
		var pp = P(n_(p.x), n_(p.y)); var u = U(n_(p.y)); var w = n_(p.w) * u * 1.4; var a = minf(1.0, n_(p.life) / 1.5)
		ctx.save(); ctx.globalAlpha = a; ctx.translate(pp[0], pp[1]); ctx.scale(1.0, 0.55); ctx.rotate(n_(p.rot)); ctx.drawImage(im, -w / 2, -w * ch_(im) / cw_(im) / 2, w, w * ch_(im) / cw_(im)); ctx.restore()
static func frame_of(it: Dictionary) -> Dictionary:
	var im = img(J.str(it.spr)); var iw = cw_(im) if im != null else 1.0; var ih = ch_(im) if im != null else 1.0
	var u = U(n_(it.uy) if it.get("uy") != null else n_(it.y)); var h = n_(it.h) * u; var w = h * iw / ih; var pp = P(n_(it.x), n_(it.y))
	return {"x": pp[0], "y": pp[1], "u": u, "w": w, "h": h, "im": im}
static func draw_fallen(ctx: Ctx, c: Dictionary) -> void:
	var p = c.parent; var F = frame_of(p); var im = img(J.str(c.spr))
	if im == null: return
	var G = c.falling; var fv = n_(p.floorV) if p.get("floorV") != null else n_(p.ay)
	var chh = n_(c.h) * F.u; var cww = chh * cw_(im) / ch_(im); var sg = -1.0 if J.t(p.get("flip")) else 1.0
	var fx = F.x + sg * (n_(c.u) - n_(p.ax)) * F.w + n_(G.x) * F.u; var fy = F.y + (fv - n_(p.ay)) * F.h + F.u * 0.03
	if n_(G.z) < 0.3: shadow_at(ctx, fx, fy, cww * 0.9, 0.25 * (1 - n_(G.z) / 0.3))
	ctx.save(); ctx.translate(fx, fy - n_(G.z) * F.u); ctx.rotate(n_(c.rot))
	if J.t(c.get("flip")): ctx.scale(-1.0, 1.0)
	ctx.drawImage(im, -cww / 2, -chh * (0.6 if J.t(G.off) and n_(G.z) <= 0 else 1.0), cww, chh); ctx.restore()
	if n_(G.land) >= 0:
		var q = (n_(G.t) - n_(G.land)) / 0.5
		if q < 1:
			ctx.save(); ctx.strokeStyle = rgba(220, 210, 190, 0.6 * (1 - q)); ctx.lineWidth = 2.0; ctx.beginPath(); ctx.ellipse(fx, fy, F.u * (0.08 + q * 0.12), F.u * (0.02 + q * 0.03), 0.0, 0.0, PI * 2); ctx.stroke()
			text(ctx, fx, fy - F.u * (0.2 + q * 0.08), "鏘！" if J.t(c.get("mug")) else ("啪！" if J.str(c.spr) == "op_stack" else "哐！"), F.u * 0.13, 1 - q); ctx.restore()
static func draw_flying(ctx: Ctx, p: Dictionary, _t: float) -> void:
	var im = img("op_paper_fly")
	if im == null: return
	var pp = P(n_(p.x), n_(p.y)); var u = U(n_(p.y)); var w = n_(p.w) * u * 1.3; var h = w * ch_(im) / cw_(im)
	shadow_at(ctx, pp[0], pp[1], w * 0.6 * maxf(0.3, 1 - n_(p.z)), 0.18)
	ctx.save(); ctx.translate(pp[0], pp[1] - n_(p.z) * u); ctx.rotate(n_(p.rot)); ctx.scale(cos(n_(p.t) * 5 + n_(p.ph)), 1.0); ctx.drawImage(im, -w / 2, -h / 2, w, h); ctx.restore()
static func text(ctx: Ctx, x: float, y: float, s: String, sz: float, a: float) -> void:
	if a <= 0.01: return
	ctx.save(); ctx.globalAlpha = ctx.globalAlpha * cl(a); ctx.font = "900 %dpx sans-serif" % int(jround(sz)); ctx.textAlign = "center"; ctx.lineWidth = 3.0; ctx.strokeStyle = "#1a1020"; ctx.strokeText(s, x, y); ctx.fillStyle = "#fff3d0"; ctx.fillText(s, x, y); ctx.restore()

# ---------------- 美美 ----------------
static func copy_idle() -> void:
	if st != null: st.copier["idle"] = maxf(or0(st.copier.get("idle")), 0.4)
static func mis_tick(n: Dictionary, dt: float) -> void:
	if not J.t(n.get("mis")): n["mis"] = {"act": "stand", "at": 0.0, "dur": 2.0, "cd": {}, "jumpT": -1.0, "rollT": -9.0}
	var s = n.mis
	var rx = n.rx if n.get("rx") is Dictionary and n_(n.rx.get("t")) >= 0 else null
	var calm = not J.t(n.get("fleeing")) and n_(n.get("fear")) < 25 and (rx == null or J.str(rx.k) == "numb") and J.str(n.get("act")) != "walk"
	for k in s.cd: s.cd[k] = n_(s.cd[k]) - dt
	s["at"] = n_(s.at) + dt
	if not calm:
		if J.str(s.act) != "stand": s["act"] = "stand"; s["at"] = 0.0; s["dur"] = 1.0
	else:
		var pass_ = null
		for m in J.iter(J.gp(SC, "npcs")):
			if not is_same(m, n) and not J.t(m.get("gone")) and (J.str(m.d.get("k")) == "ken" or J.str(m.d.get("k")) == "it") and J.str(m.get("act")) == "walk" and hyp(n_(m.x) - n_(n.x), n_(m.y) - n_(n.y)) < 0.2: pass_ = m; break
		var bub = J.gp(SC, "bubble")
		if pass_ != null and J.str(s.act) != "roll" and or0(s.cd.get("roll")) <= 0:
			s["act"] = "roll"; s["at"] = 0.0; s["dur"] = 1.8; s.cd["roll"] = 9.0; s["rollAt"] = pass_.x
			if randf() < 0.5 and J.t(bub): J.mc(SC, "bubble", [n, MIS_SAY.roll, 2.0])
		elif n_(s.at) >= n_(s.dur):
			var SP = J.gp(J.gp(OM(), "SPOT"), "copier")
			var opts = []
			for e in MIS_ACTS:
				if or0(s.cd.get(e[0])) <= 0 and e[0] != J.str(s.act) and (e[0] != "copy" or hyp(n_(n.x) - (n_(SP[0]) + 0.16), n_(n.y) - (n_(SP[1]) + 0.05)) < 0.06): opts.append(e)
			if opts.is_empty():
				var st0 = null
				for q in MIS_ACTS: if q[0] == "stand": st0 = q; break
				opts.append(st0 if st0 != null else MIS_ACTS[0])
			var tot = 0.0
			for e in opts: tot += e[1]
			var r = randf() * tot; var e = opts[0]
			for q in opts:
				r -= q[1]
				if r <= 0: e = q; break
			s["act"] = e[0]; s["at"] = 0.0; s["dur"] = e[2][0] + randf() * (e[2][1] - e[2][0]); s.cd[e[0]] = e[3] + n_(s.dur)
			if J.t(bub) and randf() < 0.35: J.mc(SC, "bubble", [n, MIS_SAY.selfie if J.str(s.act) == "selfie" else MIS_SAY.sigh, 2.2])
	var big = rx != null and (J.str(rx.k) == "startle" or J.str(rx.k) == "weakjump" or J.str(rx.k) == "burst")
	if big and n_(s.jumpT) < 0: s["jumpT"] = 0.0
	if n_(s.jumpT) >= 0:
		s["jumpT"] = n_(s.jumpT) + dt
		if n_(s.jumpT) > 1.5 and not big: s["jumpT"] = -1.0

# ---------------- 附身家具嘅點擊框 ----------------
static func rect_of(id: String):
	var it = items.get(id)
	if not J.t(it): return null
	var par = it.get("parent")
	if img(J.str(par.spr if par != null else it.spr)) == null: return null
	var p = par if par != null else it; var F = frame_of(p); var b = scm("bgScale")
	var toF = func(px: float, py: float): return [(px - n_(b.ox)) / (n_(b.iw) * n_(b.s)), (py - n_(b.oy)) / (n_(b.ih) * n_(b.s))]
	if par == null:
		var a1 = toF.call(F.x - n_(it.ax) * F.w, F.y - n_(it.ay) * F.h); var a2 = toF.call(F.x + (1 - n_(it.ax)) * F.w, F.y + (1 - n_(it.ay)) * F.h)
		return [a1[0], a1[1], a2[0] - a1[0], a2[1] - a1[1]]
	var im = img(J.str(it.spr)); var chh = n_(it.h) * F.u; var cww = chh * cw_(im) / ch_(im)
	var cx = F.x - n_(p.ax) * F.w + n_(it.u) * F.w; var cy = F.y - n_(p.ay) * F.h + n_(it.v) * F.h
	var ax = 0.5 if it.get("ax") == null else n_(it.ax)
	var b1 = toF.call(cx - ax * cww, cy - chh); var b2 = toF.call(cx + (1 - ax) * cww, cy)
	return [b1[0], b1[1], b2[0] - b1[0], b2[1] - b1[1]]

func run(_env) -> void:
	TC = {}; SC = null; st = null; items = {}; list = []; kids = []; flying = []; floor_ = []; drops = []
	_setup()
	var MA = J.G.get("MeshAnim")
	if MA is Dictionary:
		var RIG = J.gp(MA, "RIG")
		if RIG is Dictionary:
			if not J.t(RIG.get("npc_it")): RIG["npc_it"] = {"legs": true, "bones": [
				["hips", null, 0.52, 0.70, 0.52, 0.52, 0.22], ["legF", "hips", 0.43, 0.72, 0.42, 0.98, 0.10], ["legB", "hips", 0.62, 0.72, 0.62, 0.98, 0.10],
				["body", "hips", 0.52, 0.65, 0.52, 0.37, 0.26], ["head", "body", 0.52, 0.37, 0.50, 0.03, 0.30], ["hairR", "head", 0.80, 0.18, 0.92, 0.48, 0.12],
				["armF", "body", 0.33, 0.44, 0.20, 0.52, 0.13], ["armB", "body", 0.70, 0.44, 0.74, 0.52, 0.11]]}
			if not J.t(RIG.get("npc_mis")): RIG["npc_mis"] = {"legs": true, "bones": [
				["hips", null, 0.45, 0.62, 0.45, 0.48, 0.22], ["legF", "hips", 0.36, 0.66, 0.34, 0.98, 0.10], ["legB", "hips", 0.50, 0.66, 0.52, 0.98, 0.10],
				["body", "hips", 0.45, 0.58, 0.45, 0.32, 0.25], ["head", "body", 0.45, 0.32, 0.40, 0.03, 0.30], ["hairR", "head", 0.72, 0.20, 0.86, 0.52, 0.13],
				["armF", "body", 0.30, 0.38, 0.12, 0.22, 0.12], ["armB", "body", 0.62, 0.40, 0.70, 0.50, 0.10]]}
			if not J.t(RIG.get("npc_mis_walk")): RIG["npc_mis_walk"] = {"legs": true, "bones": [
				["hips", null, 0.48, 0.62, 0.48, 0.48, 0.22], ["legF", "hips", 0.40, 0.66, 0.14, 0.94, 0.11], ["legB", "hips", 0.56, 0.66, 0.62, 0.95, 0.10],
				["body", "hips", 0.48, 0.58, 0.45, 0.30, 0.25], ["head", "body", 0.45, 0.30, 0.42, 0.03, 0.30], ["hairR", "head", 0.75, 0.20, 0.86, 0.55, 0.14],
				["armF", "body", 0.33, 0.40, 0.15, 0.45, 0.10], ["armB", "body", 0.70, 0.42, 0.85, 0.62, 0.15]]}
			if not J.t(RIG.get("npc_mis_selfie")): RIG["npc_mis_selfie"] = {"legs": true, "bones": [
				["hips", null, 0.48, 0.62, 0.48, 0.48, 0.22], ["legF", "hips", 0.40, 0.66, 0.38, 0.98, 0.10], ["legB", "hips", 0.55, 0.66, 0.56, 0.98, 0.10],
				["body", "hips", 0.48, 0.58, 0.48, 0.32, 0.25], ["head", "body", 0.50, 0.32, 0.48, 0.03, 0.30], ["hairR", "head", 0.76, 0.20, 0.88, 0.52, 0.13],
				["armF", "body", 0.30, 0.40, 0.12, 0.18, 0.11], ["armB", "body", 0.68, 0.42, 0.72, 0.25, 0.10]]}
	var O = {
		"_n": {"st": func(_t = null, _a = null): return st, "STATIONS": STATIONS, "items": func(_t = null, _a = null): return items, "drops": func(_t = null, _a = null): return drops},
		"elevator": func(_t, _a): if st != null: st["door"] = 1.8,
		"offline": func(_t, a): var k = J.str(J.arg(a, 0)); if STATIONS.has(k): STATIONS[k]["offline"] = J.t(J.arg(a, 1)),
		"drawMis": func(_t, a): return ScMis.draw(a[0], SC, a[1], a[2], J.num(a[3]), J.t(a[4]), J.num(a[5])),
		"kenOff": func(_t, a): return ken_off(J.arg(a, 0)),
		"init": func(_t, a): init(J.arg(a, 0)); return null,
		"tick": func(_t, a): tick(J.num(J.arg(a, 0))); return null,
		"kenTick": func(_t, a): ken_tick(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"onScare": func(_t, a): on_scare(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.num(J.arg(a, 2))); return null,
		"onProp": func(_t, a): on_prop(J.str(J.arg(a, 0))); return null,
		"drawBack": func(_t, a): draw_back(a[0], J.num(J.arg(a, 1))); return null,
		"drawFloor": func(_t, a): draw_floor(a[0], J.num(J.arg(a, 1))); return null,
		"drawables": func(_t, a): return drawables(J.num(J.arg(a, 0))),
		"drawKen": func(_t, a): return ScOffice.draw_ken(a[0], SC, a[1], J.num(a[2])),
		"drawDark": func(_t, a): draw_dark(a[0], J.num(J.arg(a, 1))); return null,
		"kenZ": func(_t, a):
			var n = J.arg(a, 0); var s = stn_of(n)
			if s != null and J.t(items.get(s.desk)): return items[s.desk].z
			return n.y if J.t(n) else 0.6,
		"STATIONS": STATIONS,
		"seated": func(_t, a): return seated(J.arg(a, 0)),
		"clipWindow": func(_t, a): return clip_window(a[0]),
		"rectOf": func(_t, a): return rect_of(J.str(J.arg(a, 0))),
		"SEAT": STATIONS.ken.seat,
		"items": func(_t = null, _a = null): return items,
		"K": func(_t, a): var k = J.str(J.arg(a, 0)) if J.t(J.arg(a, 0)) else "ken"; return STATIONS[k].get("K"),
		"AC": AC, "WIN": WIN, "CLOCK": CLOCK,
	}
	J.G["OFFICE"] = O
	var w = J.G.get("window")
	if w != null: J.sp(w, "OFFICE", O)
