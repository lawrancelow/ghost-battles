# 原生改寫自 skits.js：
#  1) Theater：共用小劇場（短劇、棟篤笑、死對頭都用）。角色用 PlazaLife.drawAgent／ART.drawChar，特效程式畫；
#     畫面照轉譯版補丁交俾原生 MiniStage（__nat_mini）每幀叫 _nd，冇就用 requestAnimationFrame
#  2) SKITS：陰間日常短劇資料（data/nat/skits.json；give 記做 {__rwd:{資源:基數}}，發獎時再乘 rwd）
#  3) Skits：觸發、存檔（S.skit）、重溫
extends RefCounted

const ONE := {"wave": 1.4, "bow": 1.2, "startle": 1.3, "eek": 0.8, "laugh": 1.7, "boo": 0.95, "reach": 0.6, "stretch": 2.0, "spin": 2.2, "shake": 1.8, "look": 2.0, "dizzy": 2.2, "backrub": 2.6, "bump": 0.8}
const OVERLAYS := ["#sheet", "#battle", "#scare", "#world", "#gyard", "#gstreet", "#dlg", "#phone", "#title", "#su-pick", "#webov"]

static var CSS := ""
static var SKITS: Array = []
# ---- Theater 狀態 ----
static var el = null
static var cv = null
static var ctx = null
static var W := 390.0
static var H := 700.0
static var dpr := 1.0
static var raf := 0.0
static var last := 0.0
static var T := 0.0
static var sc = null
static var nat = null
# ---- Skits 狀態 ----
static var last_input := 0.0
static var was_battle := false
static var started := false

static func _g(n: String): return J.G.get(n)
static func _S(): return _g("S")
static func _L(s): return J.cl(_g("L"), null, [s]) if _g("L") != null else s
static func _doc(m: String, a: Array): return J.S_document_(m, a)
static func _q(e, s: String): return J.mc(e, "querySelector", [s])
static func _snd(n: String) -> void:
	var Sd = _g("Sound")
	if Sd != null and J.t(J.gp(Sd, "play")): J.mc(Sd, "play", [n])
static func _mode(m: String) -> void:
	var Sd = _g("Sound")
	if Sd != null and J.t(J.gp(Sd, "setMode")): J.mc(Sd, "setMode", [m])
static func _now() -> float: return J.num(J.S_Date_("now", []))
static func _perf() -> float: return J.num(J.S_performance_("now", []))
static func _c(m: String, a: Array = []): return J.mc(ctx, m, a)
static func _cs(k: String, v) -> void: J.sp(ctx, k, v)
static func _stable_sort(arr: Array, key: Callable) -> Array:
	var idx = []
	for i in arr.size(): idx.append([key.call(arr[i]), i, arr[i]])
	idx.sort_custom(func(x, y): return x[0] < y[0] or (x[0] == y[0] and x[1] < y[1]))
	return idx.map(func(x): return x[2])

static func rwd(n) -> float:
	var S = _S()
	var lv = J.num(J.gp(S, "lv")) if J.t(S) else 1.0
	return floor(J.num(n) * (1 + lv * 0.18) + 0.5)

# ====================== Theater ======================
static func css() -> void:
	if J.t(_doc("getElementById", ["th-css"])): return
	var s = _doc("createElement", ["style"]); J.sp(s, "id", "th-css"); J.sp(s, "textContent", CSS)
	J.mc(J.gp(_g("document"), "head"), "appendChild", [s])
static func ensure() -> void:
	css()
	el = _doc("getElementById", ["gtheater"])
	if not J.t(el):
		el = _doc("createElement", ["section"]); J.sp(el, "id", "gtheater")
		var app = _doc("getElementById", ["app"])
		J.mc(app if J.t(app) else J.gp(_g("document"), "body"), "appendChild", [el])
	J.sp(el, "innerHTML", "<canvas></canvas><div class=\"th-top\"><span class=\"th-tag\"></span><b class=\"th-title\"></b><button class=\"th-skip\">跳過 ▸▸</button></div>\n      <div class=\"th-cap\"></div><div class=\"th-bub\"><b class=\"th-nm\"></b><span class=\"th-tx\"></span></div><div class=\"th-choice\"></div><div class=\"th-tap\"></div>")
	cv = _q(el, "canvas"); ctx = J.mc(cv, "getContext", ["2d"])
	J.sp(el, "onclick", func(_t, a):
		var e = J.arg(a, 0); var tg = J.gp(e, "target")
		if J.t(J.mc(tg, "closest", [".th-skip"])): J.mc(e, "stopPropagation", []); close(true); return null
		if J.t(J.mc(tg, "closest", [".th-choice"])): return null
		tap(); return null)
static func resize() -> void:
	var r = J.mc(el, "getBoundingClientRect", [])
	var dp = J.gp(_g("window"), "devicePixelRatio")
	dpr = 1.0 if nat != null else minf(2.0, J.num(dp) if J.t(dp) else 1.0)
	var rw = J.num(J.gp(r, "width")); var rh = J.num(J.gp(r, "height"))
	W = rw if rw != 0 else 390.0; H = rh if rh != 0 else 700.0
	J.sp(cv, "width", W * dpr); J.sp(cv, "height", H * dpr)

# ---------- 角色 ----------
static func SC() -> float:
	var PL = _g("PlazaLife")
	return J.num(J.gp(PL, "SC")) if PL != null else 0.58
static func char_h(k) -> float:
	var ART = _g("ART"); var v = null
	if ART != null and J.t(J.gp(ART, "CHAR_H")): v = J.gp(J.gp(ART, "CHAR_H"), k)
	return (J.num(v) if J.t(v) else 56.0) * SC()
static func can_draw(k) -> bool:
	var f = _g("sprOk")
	return J.t(J.cl(f, null, [k])) if f != null else true
static func mk_actor(name, k, i, x) -> Dictionary:
	var wph = randf() * 9; var seed_ = randf() * 50
	return {"name": name, "k": k, "id": "th" + J.str(i) + "_" + J.str(k), "px": x, "tx": x, "home": x, "face": true, "want": true, "turnT": 9.0, "w": 0.0, "wph": wph, "hp": -1.0, "seed": seed_,
		"act": null, "at": 0.0, "pl": {}, "style": {}, "eatT": 0.0, "icon": null, "iconT": 9.0, "one": 0.0, "base": null, "spk": false, "pose": null, "pt": 0.0, "sc": 1.0, "alpha": 1.0, "aud": false}
static func act_key(a, k):
	if not J.t(a): return null
	var s = J.str(a); var ks = J.str(k)
	var DAILY = _g("DAILY")
	if s.begins_with("n30:"):
		var key = "n30_" + ks.substr(4) + "_" + s.substr(4)
		return key if DAILY != null and J.t(J.gp(DAILY, key)) else "plaza_talk"
	if s.begins_with("pose:"): return s
	if s.begins_with("ag:"):   # 三個死對頭（npc_antag.js）
		var key2 = "ag_" + s.substr(3)
		return key2 if DAILY != null and J.t(J.gp(DAILY, key2)) else "plaza_talk"
	return "plaza_" + s
static func ag_dur(k, st_) -> float:
	var A = _g("Antag")
	if A == null: return 2.0
	var v = J.mc(A, "dur", [k, st_])
	return J.num(v) if J.t(v) else 2.0
static func n30_dur(key: String) -> float:
	var N = _g("N30D"); var acts = J.gp(N, "ACTS") if N != null else null
	if J.t(acts):
		for id in J.keys(acts):
			for r in J.iter(J.gp(acts, id)):
				if J.str(J.gp(r, 0.0)) == key: return J.num(J.gp(r, 2.0))
	return 2.4
# 做一個動作：talk/argue 等會一直做；揮手、鞠躬、嚇一跳等一次性動作做完回到原本的樣子
static func do_act(a, act, hold = null) -> void:
	var key = act_key(act, a.k)
	if key == null: a["act"] = "plaza_talk" if J.t(a.spk) else null; a["pose"] = null; return
	a["at"] = 0.0; a["pose"] = null
	if key.begins_with("pose:"): a["pose"] = key.substr(5); a["act"] = null; a["one"] = 1.2; a["pt"] = 0.0; return
	var nm = key.replace("plaza_", "")
	a["act"] = key
	var d = J.num(hold) if J.t(hold) else (ONE[nm] if ONE.has(nm) else 6.0)
	a["pl"] = {"d": d, "spk": a.spk, "deep": 0.7}
	if ONE.has(nm): a["one"] = ONE[nm]
	elif key.begins_with("n30_"): a["one"] = n30_dur(key) * (99.0 if J.t(hold) else 1.5)
	elif key.begins_with("ag_"): a["one"] = ag_dur(a.k, key.substr(3)) * (99.0 if J.t(hold) else 1.2)
	else: a["one"] = 0.0
static func settle(a) -> void:
	a["pose"] = null
	if J.t(a.spk): a["act"] = act_key(a.talk, a.k) if J.t(a.get("talk")) else "plaza_talk"
	else: a["act"] = act_key(a.base, a.k) if J.t(a.get("base")) else null
	a["pl"] = {"d": 99.0, "spk": a.spk}; a["at"] = 0.0; a["one"] = 0.0
static func step_actor(a, dt: float) -> void:
	a.at = J.num(a.at) + dt; a.iconT = J.num(a.iconT) + dt
	if J.str(a.act) == "plaza_eat" or J.t(J.gp(a.style, "eat")): a.eatT = J.num(a.eatT) + dt
	var dx = J.num(a.tx) - J.num(a.px); var sp = W * 0.42
	var zk = J.str(a.k) == "laojiang" or J.str(a.k) == "zombie"
	if absf(dx) > 1.5:
		a.px = J.num(a.px) + signf(dx) * minf(absf(dx), sp * dt); a.w = minf(1.0, J.num(a.w) + dt * 6); a.wph = J.num(a.wph) + dt * 1.7; a.want = dx > 0
		if zk: a.hp = 0.0 if J.num(a.hp) < 0 else fmod(J.num(a.hp) + dt / 0.5, 1.0)
	else:
		a.w = maxf(0.0, J.num(a.w) - dt * 5)
		if J.num(a.hp) >= 0 and zk:
			a.hp = J.num(a.hp) + dt / 0.5
			if a.hp >= 1: a.hp = -1.0
	if J.t(a.pose): a.pt = minf(1.0, J.num(a.pt) + dt * 1.4)
	if J.num(a.one) > 0:
		a.one = J.num(a.one) - dt
		if a.one <= 0: settle(a)
	if a.want != a.face and J.num(a.turnT) >= 0.22: a.turnT = 0.0
	if J.num(a.turnT) < 0.22:
		a.turnT = J.num(a.turnT) + dt
		if a.turnT >= 0.11 and not J.t(a.get("_fl")): a.face = a.want; a["_fl"] = 1.0
		if a.turnT >= 0.22: a["_fl"] = 0.0
	if J.str(a.act) == "plaza_talk" or J.str(a.act) == "plaza_argue": J.sp(a.pl, "spk", a.spk)
static func draw_actor(a, K: float, gy: float, t: float) -> void:
	var asc = J.num(a.sc) if J.t(a.get("sc")) else 1.0
	if not can_draw(a.k):   # 原圖仲未到：只畫一個影
		var h = char_h(a.k) * K * asc
		_c("save"); _c("setTransform", [dpr, 0.0, 0.0, dpr, 0.0, 0.0]); _cs("globalAlpha", 0.55 * J.num(a.alpha))
		_cs("fillStyle", "rgba(0,0,0,.45)"); _c("beginPath"); _c("ellipse", [a.px, gy, h * 0.22, h * 0.05, 0.0, 0.0, PI * 2]); _c("fill")
		_cs("fillStyle", "rgba(20,14,28,.85)"); _c("beginPath"); _c("ellipse", [a.px, gy - h * 0.82, h * 0.15, h * 0.17, 0.0, 0.0, PI * 2]); _c("fill")
		var px = J.num(a.px)
		_c("beginPath"); _c("moveTo", [px - h * 0.2, gy]); _c("quadraticCurveTo", [px - h * 0.22, gy - h * 0.62, px, gy - h * 0.66]); _c("quadraticCurveTo", [px + h * 0.22, gy - h * 0.62, px + h * 0.2, gy]); _c("fill")
		_c("restore"); return
	var k = K * asc
	_c("save"); _c("setTransform", [dpr * k, 0.0, 0.0, dpr * k, 0.0, 0.0]); _cs("globalAlpha", a.alpha)
	a["x"] = J.num(a.px) / k; a["y"] = gy / k
	var ART = _g("ART"); var PL = _g("PlazaLife"); var A = _g("Antag"); var DAILY = _g("DAILY")
	var glide = J.num(a.w) > 0.3 and A != null and J.t(J.gp(A, "STATES")) and J.t(J.gp(J.gp(A, "STATES"), a.k)) and DAILY != null and J.t(J.gp(DAILY, "ag_walk"))
	if glide: J.mc(ART, "drawChar", [ctx, a.k, a.x, a.y, SC(), {"t": t + J.num(a.seed), "act": "ag_walk", "at": t, "flip": not J.t(a.face), "tamed": true, "untied": true}])
	elif J.t(a.pose): J.mc(ART, "drawChar", [ctx, a.k, a.x, a.y, SC(), {"t": t + J.num(a.seed), "pose": a.pose, "pt": a.pt, "flip": not J.t(a.face), "tamed": true, "untied": true, "tdx": 40.0 if J.t(a.face) else -40.0, "tdy": 0.0}])
	elif PL != null:
		J.sp(a.style, "eat", J.str(a.act) == "plaza_eat")
		J.mc(PL, "drawAgent", [ctx, a, t, {"noIcon": true}])
		if J.str(a.k) == "shuigui": J.mc(PL, "drawDrips", [ctx, a, t + J.num(a.seed)])
	else: J.mc(ART, "drawChar", [ctx, a.k, a.x, a.y, SC(), {"t": t + J.num(a.seed), "walk": J.num(a.w) > 0.3, "flip": not J.t(a.face), "tamed": true, "untied": true}])
	_c("restore")

# ---------- 程式畫的小東西 ----------
static func float_txt(x, y, s, col = null, size = null, life = null) -> void:
	sc.floats.append({"x": J.num(x), "y": J.num(y), "s": _L(s), "col": col if J.t(col) else "#ffe9a8", "size": J.num(size) if J.t(size) else 22.0, "t": 0.0, "life": J.num(life) if J.t(life) else 1.3, "vx": (randf() - 0.5) * 20})
static func joss(n) -> void:
	for i in int(J.num(n)):
		var x = randf() * W; var y = -20 - randf() * H * 0.4; var vy = 40 + randf() * 50; var rot = randf() * 6; var vr = (randf() - 0.5) * 3; var fl = randf() * 6; var vf = 2 + randf() * 3; var ph = randf() * 6
		sc.parts.append({"x": x, "y": y, "vy": vy, "rot": rot, "vr": vr, "flip": fl, "vf": vf, "ph": ph})
static func draw_parts(dt: float) -> void:
	sc.parts = sc.parts.filter(func(p): p.y += p.vy * dt; p.rot += p.vr * dt; p.flip += p.vf * dt; return p.y < H + 20)
	for p in sc.parts:
		var sz = 7.0
		_c("save"); _c("translate", [p.x + sin(T * 1.3 + p.ph) * 10, p.y]); _c("rotate", [p.rot]); _c("scale", [1.0, cos(p.flip)])
		_cs("fillStyle", "#e8c35a"); _cs("strokeStyle", "#6a4a14"); _cs("lineWidth", 1.0); _c("fillRect", [-sz, -sz * 0.7, sz * 2, sz * 1.4]); _c("strokeRect", [-sz, -sz * 0.7, sz * 2, sz * 1.4])
		_cs("fillStyle", "#b8322a"); _c("fillRect", [-sz * 0.35, -sz * 0.35, sz * 0.7, sz * 0.7]); _c("restore")
	sc.floats = sc.floats.filter(func(f): f.t += dt; return f.t < f.life)
	var fam = J.str(J.gp(J.F_getComputedStyle([J.gp(_g("document"), "body")]), "fontFamily"))
	for f in sc.floats:
		var k = f.t / f.life; var a = minf(minf(1.0, (1 - k) * 3), f.t * 8); var s = f.size * (0.7 + 0.3 * minf(1.0, f.t * 6))
		_c("save"); _cs("globalAlpha", a); _cs("font", "900 " + J.str(s) + "px " + fam); _cs("textAlign", "center"); _cs("textBaseline", "middle"); _cs("lineJoin", "round")
		_cs("lineWidth", s * 0.25); _cs("strokeStyle", "rgba(20,12,24,.92)")
		var x = f.x + f.vx * f.t; var y = f.y - k * 36
		_c("strokeText", [f.s, x, y]); _cs("fillStyle", f.col); _c("fillText", [f.s, x, y]); _c("restore")
static func crayon(pts: Array, w: float, col: String) -> void:
	_c("save"); _cs("lineCap", "round"); _cs("lineJoin", "round"); _cs("strokeStyle", col)
	for p in 2:
		_cs("globalAlpha", 0.5 if p else 1.0); _cs("lineWidth", w * (0.5 if p else 1.0)); _c("beginPath")
		for i in pts.size():
			var j = w * 0.35 if p else 0.0
			if i: _c("lineTo", [pts[i][0] + j, pts[i][1] - j * 0.5])
			else: _c("moveTo", [pts[i][0] + j, pts[i][1]])
		_c("stroke")
	_c("restore")
static func draw_mic(x: float, gy: float, h: float, dir: float) -> void:   # 咪高峰架
	var top = gy - h * 0.66
	_c("save"); _cs("fillStyle", "rgba(0,0,0,.35)"); _c("beginPath"); _c("ellipse", [x, gy + 2, h * 0.12, h * 0.025, 0.0, 0.0, PI * 2]); _c("fill"); _c("restore")
	crayon([[x - h * 0.09, gy], [x, gy - h * 0.03], [x + h * 0.09, gy]], h * 0.018, "#1c1820")
	crayon([[x, gy - h * 0.02], [x, top]], h * 0.02, "#2a2630")
	crayon([[x, top], [x + dir * h * 0.13, top - h * 0.06]], h * 0.016, "#2a2630")
	_c("save"); _c("translate", [x + dir * h * 0.15, top - h * 0.07]); _c("rotate", [-dir * 0.45])
	J.mc(_g("ART"), "rr", [ctx, -h * 0.022, -h * 0.05, h * 0.044, h * 0.09, h * 0.02, "#3a3640", "#111", 1.5])
	_cs("fillStyle", "#9a9aa8"); _c("beginPath"); _c("ellipse", [0.0, -h * 0.05, h * 0.03, h * 0.034, 0.0, 0.0, PI * 2]); _c("fill"); _cs("strokeStyle", "#111"); _cs("lineWidth", 1.4); _c("stroke")
	_cs("strokeStyle", "rgba(40,40,50,.6)"); _cs("lineWidth", 0.8)
	for i in range(-2, 3):
		_c("beginPath"); _c("moveTo", [-h * 0.026, -h * 0.05 + i * h * 0.01]); _c("lineTo", [h * 0.026, -h * 0.05 + i * h * 0.01]); _c("stroke")
	_c("restore")
static func draw_stage_floor(gy: float) -> void:   # 小木台
	var top = gy - 6; var x0 = W * 0.08; var x1 = W * 0.92
	_c("save"); _cs("fillStyle", "#3a2418"); _c("beginPath"); _c("moveTo", [x0, top]); _c("lineTo", [x1, top]); _c("lineTo", [x1 + 14, gy + 26]); _c("lineTo", [x0 - 14, gy + 26]); _c("closePath"); _c("fill")
	_cs("strokeStyle", "rgba(255,210,150,.18)"); _cs("lineWidth", 1.2)
	for i in range(1, 4):
		var y = top + i * 7; _c("beginPath"); _c("moveTo", [x0 - i * 3, y]); _c("lineTo", [x1 + i * 3, y]); _c("stroke")
	_cs("fillStyle", "#1e120c"); _c("fillRect", [x0 - 14, gy + 26, x1 - x0 + 28, 40.0]); _c("restore")
	crayon([[x0, top], [x1, top]], 2.4, "#7a5634")
static func draw_banner(text) -> void:   # 台後面掛一塊布
	var w = minf(W * 0.62, 260.0); var x = W / 2 - w / 2; var y = H * 0.17
	_c("save"); _cs("fillStyle", "rgba(130,24,20,.92)"); _c("beginPath"); _c("moveTo", [x, y]); _c("lineTo", [x + w, y]); _c("lineTo", [x + w - 6, y + 44]); _c("lineTo", [x + w / 2, y + 52]); _c("lineTo", [x + 6, y + 44]); _c("closePath"); _c("fill")
	_cs("strokeStyle", "#f3d68a"); _cs("lineWidth", 1.5); _c("stroke")
	var serif = J.mc(J.F_getComputedStyle([J.gp(_g("document"), "documentElement")]), "getPropertyValue", ["--serif"])
	_cs("font", "900 21px " + (J.str(serif) if J.t(serif) else "serif")); _cs("textAlign", "center"); _cs("textBaseline", "middle"); _cs("fillStyle", "#ffe9b8"); _c("fillText", [text, W / 2, y + 23])
	crayon([[x - 8, y - 10], [x + 2, y + 2]], 2.0, "#2a1a10"); crayon([[x + w + 8, y - 10], [x + w - 2, y + 2]], 2.0, "#2a1a10")
	_c("restore")

# ---------- 每一幀 ----------
static func frame(now_) -> void:
	if sc == null: return
	var dt = minf(0.05, (J.num(now_) - last) / 1000.0); last = J.num(now_); T += dt
	var r = J.mc(el, "getBoundingClientRect", [])
	if absf(J.num(J.gp(r, "width")) - W) > 1 or absf(J.num(J.gp(r, "height")) - H) > 1: resize()
	_c("setTransform", [dpr, 0.0, 0.0, dpr, 0.0, 0.0]); _c("clearRect", [0.0, 0.0, W, H])
	var shk = 0.0
	if sc.shake > 0: sc.shake -= dt; shk = sin(T * 70) * 4 * sc.shake
	_c("save"); _c("translate", [shk, 0.0])
	var pb = _g("paintBg")
	if pb != null: J.cl(pb, null, [ctx, W, H, sc.bg if J.t(sc.bg) else "village", T])
	else: _cs("fillStyle", "#16131b"); _c("fillRect", [0.0, 0.0, W, H])
	var Lo = layout()
	if sc.mode == "standup":
		_cs("fillStyle", "rgba(8,6,14,.55)"); _c("fillRect", [0.0, 0.0, W, H])
		var g = _c("createRadialGradient", [W / 2, Lo.gy - Lo.ch * 0.6, 10.0, W / 2, Lo.gy - Lo.ch * 0.4, maxf(W, H) * 0.55])
		J.mc(g, "addColorStop", [0.0, "rgba(255,236,190,.34)"]); J.mc(g, "addColorStop", [0.45, "rgba(255,220,160,.08)"]); J.mc(g, "addColorStop", [1.0, "rgba(0,0,0,.55)"]); _cs("fillStyle", g); _c("fillRect", [0.0, 0.0, W, H])
		draw_banner(sc.banner if J.t(sc.banner) else "棟篤笑・今晚開咪")
		draw_stage_floor(Lo.gy)
	else:
		var g2 = _c("createLinearGradient", [0.0, Lo.gy - 40, 0.0, H]); J.mc(g2, "addColorStop", [0.0, "rgba(10,8,16,0)"]); J.mc(g2, "addColorStop", [1.0, "rgba(10,8,16,.6)"]); _cs("fillStyle", g2); _c("fillRect", [0.0, Lo.gy - 40, W, H - Lo.gy + 40])
	for a in sc.cast: step_actor(a, dt)
	for a in sc.aud: step_actor(a, dt)
	for a in _stable_sort(sc.cast, func(p): return J.num(p.get("z")) if J.t(p.get("z")) else 0.0):
		draw_actor(a, Lo.K, Lo.gy + (J.num(a.get("dy")) if J.t(a.get("dy")) else 0.0), T)
	if sc.mode == "standup" and sc.cast.size() > 0:
		var p0 = sc.cast[0]; var fc = J.t(p0.face)
		draw_mic(J.num(p0.px) + (1.0 if fc else -1.0) * Lo.ch * 0.36, Lo.gy + 2, Lo.ch, -1.0 if fc else 1.0)
	if sc.aud.size() > 0:
		for a in sc.aud: draw_actor(a, Lo.K * 0.78, H - 8 + (J.num(a.get("dy")) if J.t(a.get("dy")) else 0.0), T)
		var g3 = _c("createLinearGradient", [0.0, H - Lo.ch * 0.9, 0.0, H]); J.mc(g3, "addColorStop", [0.0, "rgba(6,4,10,0)"]); J.mc(g3, "addColorStop", [0.5, "rgba(6,4,10,.38)"]); J.mc(g3, "addColorStop", [1.0, "rgba(6,4,10,.7)"]); _cs("fillStyle", g3); _c("fillRect", [0.0, H - Lo.ch * 0.9, W, Lo.ch * 0.9])
	draw_parts(dt)
	_c("restore")
	if sc.flash > 0:
		sc.flash -= dt; _cs("fillStyle", "rgba(255,250,235," + J.str(maxf(0.0, sc.flash) * 1.4) + ")"); _c("fillRect", [0.0, 0.0, W, H])
	tick_flow(dt)
	place_bubble()
	if nat == null: raf = J.F_requestAnimationFrame([func(_t, a): frame(J.arg(a, 0)); return null])
static func layout():
	var stand = sc.mode == "standup"
	var gy = H * 0.70 if stand else H * 0.77
	var ch = minf(H * 0.34, W * 0.52) if stand else minf(H * 0.3, W * (0.31 if sc.cast.size() > 3 else 0.4))
	return {"gy": gy, "ch": ch, "K": ch / (60 * SC())}

# ---------- 劇本流程 ----------
static func actor_of(name):
	for a in sc.cast: if J.seq(a.name, name): return a
	for a in sc.aud: if J.seq(a.name, name): return a
	return null
static func set_speaker(name) -> void:
	for a in sc.cast:
		var on = J.seq(a.name, name)
		if J.t(a.spk) != on:
			a["spk"] = on
			if not J.t(a.one) and not J.t(a.pose): settle(a)
	var sp = actor_of(name)
	if sp != null and not J.t(sp.aud):
		for a in sc.cast: if a != sp and not J.t(a.get("lockFace")): a["want"] = J.num(sp.px) > J.num(a.px)   # 大家望住講嘢嗰個
	if sp != null and not J.t(sp.aud) and sc.cast.size() > 1 and not J.t(sp.get("lockFace")):
		var s = 0.0; var n = 0
		for x in sc.cast: if x != sp: s += J.num(x.px); n += 1
		J.sp(sp, "want", s / n > J.num(sp.px))
static func show(b) -> void:
	var cap = _q(el, ".th-cap"); var bub = _q(el, ".th-bub"); var tx = _q(bub, ".th-tx"); var nm = _q(bub, ".th-nm")
	sc.beat = b; sc.typing = true; sc.shown = 0; sc.full = J.str(_L(J.gp(b, "text"))); sc.ty = 0.0
	if J.t(J.gp(b, "fx")): run_fx(J.gp(b, "fx"))
	var who = J.gp(b, "who")
	if J.str(who) == "旁白":
		set_speaker(null); J.sp(bub, "className", "th-bub"); J.sp(cap, "className", "th-cap on"); J.sp(cap, "textContent", ""); sc.target = cap
	else:
		J.sp(cap, "className", "th-cap"); set_speaker(who)
		var sp = actor_of(who)
		J.sp(bub, "className", "th-bub on" + (" sys" if J.str(who) == "系統" else (" aud" if sp != null and J.t(sp.aud) else "")))
		J.sp(nm, "textContent", who); J.sp(tx, "textContent", ""); sc.target = tx; sc.bubFor = sp
		var act = J.gp(b, "act")
		if sp != null and J.t(act): do_act(sp, act, J.gp(b, "hold"))
		elif sp != null and not J.t(sp.aud): settle(sp)
		if sp != null and J.t(sp.aud) and not J.t(act): do_act(sp, "laugh")
	var re = J.gp(b, "re")
	if J.t(re):
		for n in J.keys(re):
			var a = actor_of(n)
			if a != null: do_act(a, J.gp(re, n), J.gp(b, "hold"))
	J.sp(_q(el, ".th-tap"), "textContent", "")
static func place_bubble() -> void:
	var bub = _q(el, ".th-bub")
	if not J.t(bub) or not J.t(J.mc(J.gp(bub, "classList"), "contains", ["on"])): return
	var st_ = J.gp(bub, "style")
	J.sp(st_, "left", "0px")   # 先放返左邊量闊度，唔係近右邊會被壓窄
	var Lo = layout(); var sp = sc.bubFor; var w = J.num(J.gp(bub, "offsetWidth")); var h = J.num(J.gp(bub, "offsetHeight"))
	var x = W / 2; var y = 0.0
	if sp == null or J.str(J.gp(sc.beat, "who")) == "系統":
		y = maxf(64.0, H * 0.16); J.sp(st_, "left", J.str(maxf(10.0, (W - w) / 2)) + "px"); J.sp(st_, "top", J.str(y) + "px"); return
	if J.t(sp.aud):
		var k = Lo.K * 0.78; x = J.num(sp.px); var top = H - 8 - char_h(sp.k) * k; y = top - h - 14
	else:
		x = J.num(sp.px); var head = Lo.gy - char_h(sp.k) * Lo.K * (J.num(sp.sc) if J.t(sp.get("sc")) else 1.0) - 10; y = head - h - 12
	y = maxf(H * 0.17 + 58 if sc.mode == "standup" else 60.0, y)
	var left = maxf(10.0, minf(W - w - 10, x - w / 2))
	J.sp(st_, "left", J.str(left) + "px"); J.sp(st_, "top", J.str(y) + "px"); J.mc(st_, "setProperty", ["--tx", J.str(maxf(16.0, minf(w - 16, x - left))) + "px"])
static func tick_flow(dt: float) -> void:
	if sc.phase == "enter":
		if sc.cast.all(func(a): return absf(J.num(a.tx) - J.num(a.px)) < 2): sc.phase = "run"; next_beat()
		return
	if sc.phase == "exit":
		sc.exitT -= dt
		if sc.exitT <= 0 or sc.cast.all(func(a): return absf(J.num(a.tx) - J.num(a.px)) < 2): close(false)
		return
	if sc.phase != "run" or not sc.typing:
		if sc.autoT > 0:
			sc.autoT -= dt
			if sc.autoT <= 0: next_beat()
		return
	sc.ty += dt
	var n = mini(sc.full.length(), int(floor(sc.ty / 0.026)))
	if n != sc.shown: sc.shown = n; J.sp(sc.target, "textContent", sc.full.substr(0, n))
	if n >= sc.full.length(): done()
static func done() -> void:
	sc.typing = false; J.sp(sc.target, "textContent", sc.full)
	var b = sc.beat
	if J.t(b) and J.t(J.gp(b, "react")) and sc.react != null: J.cl(sc.react, null, [J.gp(b, "react"), b])
	if J.t(b) and J.t(J.gp(b, "auto")): sc.autoT = J.num(J.gp(b, "auto"))
	J.sp(_q(el, ".th-tap"), "textContent", "點擊繼續")
static func next_beat() -> void:
	sc.autoT = 0.0
	if sc.i >= sc.beats.size():
		if J.t(sc.choice): ask_choice(); return
		exit_(); return
	var b = sc.beats[sc.i]; sc.i += 1
	show(b)
static func tap() -> void:
	if sc == null: return
	_snd("click")
	if sc.phase == "enter":
		for a in sc.cast: a["px"] = a.tx
		return
	if sc.phase == "exit": close(false); return
	if sc.phase == "choice": return
	if sc.typing: done(); return
	next_beat()
# 選項 a / b / c；disabled = 做唔到；next = 再問一條；on() = 揀咗即刻做嘅事
static func ask_choice() -> void:
	sc.phase = "choice"; var c = sc.choice; var box = _q(el, ".th-choice"); var cap = _q(el, ".th-cap")
	J.sp(_q(el, ".th-bub"), "className", "th-bub"); J.sp(cap, "className", "th-cap on"); J.sp(cap, "textContent", _L(J.gp(c, "q"))); set_speaker(null)
	J.sp(_q(el, ".th-tap"), "textContent", "")
	var html = ""
	for k in ["a", "b", "c"]:
		var o = J.gp(c, k)
		if not J.t(o): continue
		html += "<button class=\"btn %s wide\" data-k=\"%s\" %s>%s</button>" % ["gold" if (k == "a" and not J.t(J.gp(c, "plain"))) else "", k, "disabled" if J.t(J.gp(o, "disabled")) else "", J.str(_L(J.gp(o, "label")))]
	J.sp(box, "innerHTML", html)
	J.sp(box, "className", "th-choice on")
	for btn in J.iter(J.mc(box, "querySelectorAll", ["button"])):
		J.sp(btn, "onclick", func(_t, a):
			J.mc(J.arg(a, 0), "stopPropagation", [])
			if J.t(J.gp(btn, "disabled")): return null
			var kk = J.str(J.gp(J.gp(btn, "dataset"), "k")); var o = J.gp(c, kk)
			sc.chosen = kk; sc.picks.append(kk); J.sp(box, "className", "th-choice"); J.sp(box, "innerHTML", "")
			_snd("paper")
			var more: Array = []
			var ol = J.gp(o, "lines")
			if J.t(ol): more = J.iter(ol).duplicate()
			var on_ = J.gp(o, "on")
			if J.t(on_):
				var r = J.cl(on_, null, [sc.picks.duplicate()])
				if r is Array: more = more + r
			sc.beats = sc.beats + parse(more)
			var nx = J.gp(o, "next")
			if J.t(nx):
				sc.choice = J.cl(nx, null, [sc.picks.duplicate()]) if J.typeof_(nx) == "function" else nx
				sc.chosen = null
			else: sc.choice = null
			sc.phase = "run"; next_beat()
			return null)
static func exit_() -> void:
	sc.phase = "exit"; sc.exitT = 1.3; J.sp(_q(el, ".th-bub"), "className", "th-bub"); J.sp(_q(el, ".th-cap"), "className", "th-cap")
	J.sp(_q(el, ".th-tap"), "textContent", "")
	if sc.mode == "standup": sc.exitT = 0.9; return
	for a in sc.cast:
		a["spk"] = false; settle(a); a["tx"] = -W * 0.25 if J.num(a.home) < W / 2 else W * 1.25
static func run_fx(fx) -> void:
	for f in J.str(fx).split(","):
		if f == "joss": joss(26)
		elif f == "shake": sc.shake = 0.5
		elif f == "flash": sc.flash = 0.35
		elif f.begins_with("txt:"): float_txt(W / 2, H * 0.42, f.substr(4), "#ffe9a8", 28.0, 1.6)
# 劇本格式：[說話者, 台詞, 動作?, { 其他角色: 反應動作 }?, 特效?]
static func parse(lines) -> Array:
	var out = []
	for l in J.iter(lines):
		if l is Array: out.append({"who": J.gp(l, 0.0), "text": J.gp(l, 1.0), "act": J.gp(l, 2.0) if J.t(J.gp(l, 2.0)) else null, "re": J.gp(l, 3.0) if J.t(J.gp(l, 3.0)) else null, "fx": J.gp(l, 4.0) if J.t(J.gp(l, 4.0)) else null})
		else: out.append(l)
	return out
static func play(scene, cb = null) -> void:
	if sc != null: close(true)
	ensure(); J.sp(el, "className", "on"); resize()
	var cast = J.iter(J.gp(scene, "cast")) if J.t(J.gp(scene, "cast")) else []
	var n = cast.size()
	var xs = J.gp(scene, "xs")
	if not J.t(xs): xs = [0.5] if n == 1 else ([0.3, 0.7] if n == 2 else ([0.2, 0.5, 0.8] if n == 3 else [0.15, 0.38, 0.62, 0.85]))
	var mode = J.gp(scene, "mode")
	sc = {"mode": J.str(mode) if J.t(mode) else "skit", "bg": J.gp(scene, "bg"), "banner": J.gp(scene, "banner"), "cb": cb, "cast": [], "aud": [], "parts": [], "floats": [],
		"beats": parse(J.gp(scene, "lines") if J.t(J.gp(scene, "lines")) else []), "i": 0, "phase": "enter", "choice": J.gp(scene, "choice") if J.t(J.gp(scene, "choice")) else null,
		"chosen": null, "picks": [], "react": J.gp(scene, "react") if J.t(J.gp(scene, "react")) else null, "shake": 0.0, "flash": 0.0, "autoT": 0.0,
		"beat": null, "typing": false, "shown": 0, "full": "", "ty": 0.0, "target": null, "bubFor": null, "exitT": 0.0}
	for i in n:
		var row = cast[i]; var name = J.gp(row, 0.0); var k = J.gp(row, 1.0); var opt = J.gp(row, 2.0)
		var xi = J.num(J.gp(xs, float(i)))
		var a = mk_actor(name, k, i, W * xi)
		if J.t(opt): for key in J.keys(opt): a[key] = J.gp(opt, key)
		a["home"] = W * xi; a["tx"] = a.home
		a["base"] = J.gp(opt, "base") if J.t(opt) and J.t(J.gp(opt, "base")) else null
		a["talk"] = J.gp(opt, "talk") if J.t(opt) and J.t(J.gp(opt, "talk")) else null
		if J.str(mode) == "standup" or (J.t(opt) and J.t(J.gp(opt, "onstage"))):
			a["px"] = a.tx
			var fc = J.gp(opt, "face") if J.t(opt) else null
			a["face"] = J.t(fc) if (J.t(opt) and fc != null) else a.home < W / 2; a["want"] = a.face
		else:
			var from_l = a.home < W / 2
			a["px"] = -W * 0.18 - i * 40 if from_l else W * 1.18 + (n - i) * 40
			a["face"] = from_l; a["want"] = from_l
		if J.t(a.base): settle(a)
		sc.cast.append(a)
	var aud = J.iter(J.gp(scene, "aud")) if J.t(J.gp(scene, "aud")) else []
	for i in aud.size():
		var x = W * (0.1 + 0.8 * (0.5 if aud.size() == 1 else float(i) / (aud.size() - 1)))
		var a = mk_actor(J.gp(aud[i], 0.0), J.gp(aud[i], 1.0), 50 + i, x)
		a["aud"] = true; a["face"] = x < W / 2; a["want"] = a.face; a["dy"] = float((i % 2) * 6)
		sc.aud.append(a)
	var tag = J.gp(scene, "tag")
	J.sp(_q(el, ".th-tag"), "textContent", tag if J.t(tag) else "陰間日常")
	var ttl = J.gp(scene, "title")
	J.sp(_q(el, ".th-title"), "textContent", _L(ttl if J.t(ttl) else ""))
	_mode("story")
	if J.t(J.gp(scene, "fx")): run_fx(J.gp(scene, "fx"))
	last = _perf(); J.F_cancelAnimationFrame([raf])
	nat = null
	var nm = _g("__nat_mini")
	if nm != null:
		var o = {}
		o["_nd"] = func(_t, _a):
			if sc == null: return null
			var keep = ctx; ctx = o.get("_natCtx")
			frame(_perf())
			ctx = keep
			return null
		if J.t(J.cl(nm, null, [o, "#gtheater", "#gtheater", "_nd"])): nat = o
	if nat == null: raf = J.F_requestAnimationFrame([func(_t, a): frame(J.arg(a, 0)); return null])
	if sc.mode == "standup":
		sc.phase = "run"
		J.F_setTimeout([func(_t, _a):
			if sc != null and sc.i == 0: next_beat()
			return null, 450.0])
static func close(skipped) -> void:
	if sc == null: return
	var s = sc; sc = null; J.F_cancelAnimationFrame([raf])
	if nat != null: nat = null; J.cl(_g("__nat_miniEnd"), null, ["#gtheater"])
	if J.t(el): J.sp(el, "className", ""); J.sp(el, "innerHTML", "")
	var GS = _g("GhostStreet")
	_mode("story" if GS != null and J.t(J.gp(GS, "active")) else "village")
	if s.cb != null:
		var ch = s.chosen if s.chosen != null else (s.picks[-1] if s.picks.size() > 0 else null)
		J.cl(s.cb, null, [{"skipped": J.t(skipped), "choice": ch, "picks": s.picks}])

static func make_theater() -> Dictionary:
	return {
		"play": func(_t, a): play(J.arg(a, 0), J.arg(a, 1)); return null,
		"close": func(_t, a): close(J.arg(a, 0)); return null,
		"__getters": {"on": func(_t, _a): return sc != null},
		"aud": func(_t, _a): return sc.aud if sc != null else [],
		"cast": func(_t, _a): return sc.cast if sc != null else [],
		"act": func(_t, a): do_act(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"float": func(_t, a): float_txt(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.arg(a, 5)); return null,
		"joss": func(_t, a): joss(J.arg(a, 0)); return null,
		"fx": func(_t, a): run_fx(J.arg(a, 0)); return null,
		"size": func(_t, _a): return {"W": W, "H": H},
		"layout": func(_t, _a): return layout() if sc != null else null,
		"insert": func(_t, a):
			if sc != null:
				var p = parse(J.arg(a, 0))
				for j in p.size(): sc.beats.insert(sc.i + j, p[j])
			return null,
		"charH": func(_t, a): return char_h(J.arg(a, 0)),
	}

# ====================== Skits：觸發、存檔、重溫 ======================
static func st():
	var S = _S()
	if not J.t(S): return null
	if not J.t(J.gp(S, "skit")): J.sp(S, "skit", {})
	var s = J.gp(S, "skit")
	if not J.t(J.gp(s, "seen")): J.sp(s, "seen", {})
	if not J.t(J.gp(s, "cyc")): J.sp(s, "cyc", {})
	if not (J.gp(s, "act") is float or J.gp(s, "act") is int): J.sp(s, "act", 0.0)
	if not (J.gp(s, "next") is float or J.gp(s, "next") is int): J.sp(s, "next", 100.0)
	if not J.t(J.gp(s, "n")): J.sp(s, "n", 0.0)
	if not J.t(J.gp(s, "last")): J.sp(s, "last", "")
	return s
static func seen(id) -> bool:
	var S = _S()
	return J.t(S) and J.t(J.gp(S, "seen")) and J.t(J.gp(J.gp(S, "seen"), id))
static func art_ok(sk) -> bool:
	if not J.t(sk.get("cast")): return true
	var f = _g("sprOk")
	for c in sk.cast: if f != null and not J.t(J.cl(f, null, [c[1]])): return false
	return true
static func ok(sk) -> bool:
	var S = _S()
	if not J.t(S): return false
	if J.t(sk.get("need")):
		for id in sk.need: if not seen(id): return false
	if J.t(sk.get("pre")) and J.t(J.gp(S, "ended")): return false
	return art_ok(sk)
static func quiet() -> bool:
	if not J.t(_S()) or not seen("prologue_sys"): return false
	if J.t(J.gp(_g("document"), "hidden")) or sc != null: return false
	var St = _g("Story"); if St != null and J.t(J.mc(St, "busy", [])): return false
	var B = _g("Battle"); if B != null and J.t(J.gp(B, "active")): return false
	var P = _g("Phone"); if P != null and J.t(J.gp(P, "on")): return false
	for q in OVERLAYS:
		var e = _doc("querySelector", [q])
		if J.t(e) and (J.t(J.mc(J.gp(e, "classList"), "contains", ["on"])) or J.str(J.gp(e, "className")) == "on"): return false
	return true
static func pick_next():
	var s = st(); var pool = SKITS.filter(func(k): return ok(k))
	if pool.is_empty(): return null
	var fresh = pool.filter(func(k): return not J.t(J.gp(J.gp(s, "cyc"), k.id)))
	if fresh.is_empty():   # 全部睇晒：新一輪（唔會即刻重播上一段）
		J.sp(s, "cyc", {})
		fresh = pool.filter(func(k): return J.str(k.id) != J.str(J.gp(s, "last")))
		if fresh.is_empty(): fresh = pool
	var unseen = fresh.filter(func(k): return not J.t(J.gp(J.gp(s, "seen"), k.id)))
	var from = unseen if unseen.size() > 0 else fresh   # 未睇過嘅優先
	return from[int(floor(randf() * from.size()))]
static func story_scene(sk) -> Dictionary:
	var base = {"style": sk.get("form"), "title": sk.get("title"), "lines": sk.get("lines")}
	if J.str(sk.get("form")) == "chat": base["group"] = sk.get("group"); base["av"] = sk.get("av")
	return base
static func give_of(o):
	var g = o.get("give") if o is Dictionary else null
	if not (g is Dictionary) or not g.has("__rwd"): return null
	var r = {}
	for k in g.__rwd: r[k] = rwd(g.__rwd[k])
	return r
static func reward(sk, ch) -> String:
	var c = sk.get("choice")
	var o = c.get(J.str(ch)) if c is Dictionary and J.t(ch) else null
	if o == null: return ""
	var r = give_of(o)
	return J.str(J.cl(_g("give"), null, [r])) if r != null else ""
static func play_skit(sk, replay = false) -> bool:
	if sk is String:
		var f = null
		for k in SKITS: if J.str(k.id) == sk: f = k; break
		sk = f
	if sk == null: return false
	var s = st(); var first = s != null and not J.t(J.gp(J.gp(s, "seen"), sk.id))
	var finish = func(res):
		if s != null:
			J.sp(J.gp(s, "seen"), sk.id, 1.0); J.sp(J.gp(s, "cyc"), sk.id, 1.0); J.sp(s, "last", sk.id); J.sp(s, "n", J.num(J.gp(s, "n")) + 1)
		if not replay and first and J.t(res) and not J.t(J.gp(res, "skipped")) and J.t(J.gp(res, "choice")):
			var txt = reward(sk, J.gp(res, "choice"))
			if txt != "": J.mc(_g("Fx"), "toast", ["陰間日常：<b>" + txt + "</b>"])
			var UI = _g("UI"); if UI != null and J.t(J.gp(UI, "refresh")): J.mc(UI, "refresh", [])
		var sv = _g("save"); if sv != null: J.cl(sv, null, [])
	if J.t(sk.get("form")):
		J.mc(_g("Story"), "queue", [story_scene(sk), func(_t, _a): finish.call({"skipped": false}); return null])
		return true
	play({"tag": "陰間日常", "title": sk.get("title"), "bg": sk.get("bg"), "cast": sk.get("cast"), "lines": sk.get("lines"), "choice": sk.get("choice")}, func(_t, a): finish.call(J.arg(a, 0)); return null)
	return true
# 每秒檢查一次：有操作嘅時間先計；夠鐘又安靜就嚟一段
static func tick() -> void:
	var s = st()
	if s == null: return
	var B = _g("Battle"); var bat = B != null and J.t(J.gp(B, "active"))
	if was_battle and not bat: J.sp(s, "act", maxf(J.num(J.gp(s, "act")), J.num(J.gp(s, "next")) - 25))   # 打完仗返到村：一陣就嚟
	was_battle = bat
	if not quiet(): return
	if _now() - last_input > 40000: return   # 放低咗部機：唔計
	J.sp(s, "act", J.num(J.gp(s, "act")) + 1)
	var Rv = _g("Rivals")
	if Rv != null and J.t(J.mc(Rv, "tick", [])):   # 死對頭先問
		J.sp(s, "act", minf(J.num(J.gp(s, "act")), maxf(0.0, J.num(J.gp(s, "next")) - 90))); return
	if J.num(J.gp(s, "act")) >= J.num(J.gp(s, "next")):
		var sk = pick_next(); J.sp(s, "act", 0.0); J.sp(s, "next", 170.0 + floor(randf() * 110))
		if sk != null: play_skit(sk)
static func nudge(sec) -> void:
	var s = st()
	if s != null: J.sp(s, "act", maxf(J.num(J.gp(s, "act")), J.num(J.gp(s, "next")) - J.num(sec)))
static func init() -> void:
	if started: return
	started = true
	var St = _g("Story")
	if St != null and J.t(J.gp(St, "showLine")):   # 對白語言：Story 每顯示一句用 L() 換（保留時間）
		var osl = J.gp(St, "showLine")
		var rx = RegEx.create_from_string("^(\\d\\d:\\d\\d)\\|([\\s\\S]*)$")
		J.sp(St, "showLine", func(this_, a):
			var c = J.gp(this_, "cur")
			if J.t(c) and J.t(J.gp(c, "sc")) and J.t(J.gp(J.gp(c, "sc"), "lines")):
				if not J.t(J.gp(c, "orig")): J.sp(c, "orig", J.gp(c, "sc"))
				var orig = J.gp(c, "orig"); var nsc = {}
				for k in J.keys(orig): nsc[k] = J.gp(orig, k)
				var nl = []
				for l in J.iter(J.gp(orig, "lines")):
					var raw = J.gp(l, 1.0); var m = rx.search(raw) if raw is String else null
					var row = [J.gp(l, 0.0), (m.get_string(1) + "|" + J.str(_L(m.get_string(2)))) if m != null else _L(raw)]
					row.append_array(J.iter(l).slice(2)); nl.append(row)
				nsc["lines"] = nl; J.sp(c, "sc", nsc)
			return J.cl(osl, this_, a))
	var mark = func(_t, _a): last_input = _now(); return null
	for ev in ["pointerdown", "keydown", "wheel"]: _doc("addEventListener", [ev, mark, true])
	J.F_setInterval([func(_t, _a): tick(); return null, 1000.0])
	var Q = _g("Quest")
	if Q != null and J.t(J.gp(Q, "complete")):   # 完成任務：早啲嚟
		var oc = J.gp(Q, "complete")
		J.sp(Q, "complete", func(this_, a): var r = J.cl(oc, this_, a); nudge(35); return r)
	var UI = _g("UI")
	if UI != null and J.t(J.gp(UI, "openStory")):
		var os = J.gp(UI, "openStory")
		J.sp(UI, "openStory", func(this_, a): var r = J.cl(os, this_, a); story_hook(); return r)
static func story_hook() -> void:
	var body = _doc("querySelector", ["#sheet .sh-body"]); var hr = J.mc(body, "querySelector", ["hr"]) if J.t(body) else null
	if not J.t(hr): return
	var s = st(); var list = SKITS.filter(func(k): return J.t(J.gp(J.gp(s, "seen"), k.id)))
	var btns = "".join(list.map(func(k): return "<button class=\"btn wide\" data-skit=\"%s\">%s</button>" % [J.str(k.id), J.str(_L(k.title))]))
	var div = _doc("createElement", ["div"])
	J.sp(div, "innerHTML", "<h4 class=\"stand-h\">陰間日常</h4><p class=\"desc\">在村子裡玩，偶爾會上演一段。看過的可以在這裡重溫（%d/%d）。</p><div class=\"slist\">%s</div>" % [list.size(), SKITS.size(), btns if btns != "" else "<p class=\"desc\">還沒看過。在村子裡多玩一會兒。</p>"])
	J.mc(J.gp(hr, "parentNode"), "insertBefore", [div, hr])
	for b in J.iter(J.mc(div, "querySelectorAll", ["[data-skit]"])):
		J.sp(b, "onclick", func(_t, _a):
			J.mc(_g("UI"), "close", [])
			var id = J.str(J.gp(J.gp(b, "dataset"), "skit"))
			J.F_setTimeout([func(_t2, _a2): play_skit(id, true); return null, 60.0])
			return null)

func run(_env) -> void:
	var f = FileAccess.open("res://data/nat/skits.json", FileAccess.READ)
	var d = JSON.parse_string(f.get_as_text()) if f else {}
	SKITS = d.get("SKITS", []); CSS = d.get("THEATER_CSS", "")
	el = null; cv = null; ctx = null; W = 390.0; H = 700.0; dpr = 1.0; raf = 0.0; last = 0.0; T = 0.0; sc = null; nat = null
	last_input = 0.0; was_battle = false; started = false
	css()
	J.G["Theater"] = make_theater()
	J.G["rwd"] = func(_t, a): return rwd(J.arg(a, 0))
	J.G["SKITS"] = SKITS
	J.G["Skits"] = {
		"st": func(_t, _a): return st(),
		"ok": func(_t, a): return ok(J.arg(a, 0)),
		"play": func(_t, a): return play_skit(J.arg(a, 0), J.t(J.arg(a, 1))),
		"tick": func(_t, _a): tick(); return null,
		"nudge": func(_t, a): nudge(J.arg(a, 0)); return null,
		"init": func(_t, _a): init(); return null,
		"storyHook": func(_t, _a): story_hook(); return null,
		"pickNext": func(_t, _a): return pick_next(),
		"quiet": func(_t, _a): return quiet(),
		"list": SKITS,
	}
	init()
