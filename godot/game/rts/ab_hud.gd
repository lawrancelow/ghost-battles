# [abui] 地圖戰鬥頭頂狀態（盾、殼、隱半透明、飛高 30px＋影、失神、讀條）＋ ab 事件飄字＋名鬼自動／手動偏好
#   全部 static；冇 class_name。由 rts_view.gd 掛鈎（搜 `# [abui]`）。
#
#   ★讀單位欄位（約定；abcore 引擎寫，冇就當冇）：
#     u.shield        護盾值（>0 顯示「盾」；另外 u.bf 入面 {p:"shield", v, until} 都計）
#     u.shell／u.shell_max   殼值／殼上限（>0 顯示「殼」＋剩幾多）
#     u.hid 或 u.stealth_until > op.t      隱身中（敵人 35% 透明、我方 55%）
#     u.fly（bool）；冇呢欄時用 AB.mechs_of(k) 有 "fly" 當飛；u.grounded_until > op.t＝擊落（落地）
#     u.fearT.until > op.t                 失神（現有）
#     u.chant {t, dur, name}（敵人讀大招）或 u.casting {t, dur}  讀條
#     u.mech（Array）  頭頂機制細圖（敵人，最多 3 個；冇就用 AB.mechs_of(k)）
#   ★ab 事件：op.events 入面 ["ab", src, prim, v, (可選) 文字] → 喺 v（冇就 src）頭頂飄字
extends RefCounted

const AB = preload("res://game/rts/abil.gd")
const AI = preload("res://game/rts/ab_icon.gd")
const LIFT := 30.0
const IC := 11.0          # 頭頂圖示半徑（畫面 px）→ 直徑 22

static var FL: Array = []          # 飄字 {u, p, text, col, t, life}
static var _mc := {}               # 鬼 k → 機制（快取）

static func L(yue: String, zhs: String) -> String: return str(DB.N(load("res://game/zone/zone_data.gd").L(yue, zhs)))

static func mechs(u: Dictionary) -> Array:
	if u.get("mech") is Array: return u.mech
	var k = J.str(u.get("k"))
	if not _mc.has(k): _mc[k] = AB.mechs_of(k) if AB.on() else []
	return _mc[k]

static func _t(op) -> float: return float(op.t) if op != null else 0.0

static func status(op, u: Dictionary) -> Dictionary:
	var t = _t(op)
	var o = {"shield": 0.0, "shell": -1.0, "stealth": false, "fly": false, "ground": false, "daze": false, "chant": null}
	var sh = J.num(u.get("shield", 0))
	if u.get("bf") is Array:
		for b in u.bf:
			if b is Dictionary and str(b.get("p", "")) == "shield":
				var un = J.num(b.get("until", -1))
				if un < 0 or un > t: sh += J.num(b.get("v", 0))
	o.shield = sh
	if u.get("shell") != null and J.num(u.shell) > 0:
		var mx = J.num(u.get("shell_max", 0))
		if mx <= 0: mx = maxf(1.0, J.num(u.get("maxhp", 1)) * 0.35)
		o.shell = clampf(J.num(u.shell) / mx, 0.0, 1.0)
	o.stealth = J.t(u.get("hid")) or J.num(u.get("stealth_until", -1)) > t
	var gr = J.num(u.get("grounded_until", -1)) > t
	var fl = J.t(u.get("fly")) if u.get("fly") != null else mechs(u).has("fly")
	o.fly = fl and not gr
	o.ground = fl and gr
	var ft = u.get("fearT")
	o.daze = op != null and ft is Dictionary and J.num(ft.get("until", 0)) > t
	var ch = u.get("chant")
	if ch is Dictionary and J.num(ch.get("dur", 0)) > 0: o.chant = {"f": clampf(J.num(ch.get("t", 0)) / J.num(ch.dur), 0, 1), "name": str(ch.get("name", "")), "big": true}
	else:
		var ca = u.get("casting")
		if ca is Dictionary and J.num(ca.get("dur", 0)) > 0: o.chant = {"f": clampf(J.num(ca.get("t", 0)) / J.num(ca.dur), 0, 1), "name": "", "big": false}
	_from_ab(o, u, t)   # [整合] abcore 把狀態放喺 u.ab，對齊
	return o

# [整合] abcore 引擎實際欄位：u.ab = {shd, shd_until, shell, shell0, fly, ground_until, st_on, rev_until, bf:[{p,until,v}]}
static func _from_ab(o: Dictionary, u: Dictionary, t: float) -> void:
	var a = u.get("ab")
	if not (a is Dictionary): return
	if J.num(a.get("shd", 0)) > 0 and J.num(a.get("shd_until", 0)) > t: o.shield = J.num(o.shield) + J.num(a.shd)
	if a.get("shell") != null and J.num(a.get("shell0", 0)) > 0 and J.num(a.shell) > 0:
		o.shell = clampf(J.num(a.shell) / J.num(a.shell0), 0.0, 1.0)
	var st = J.t(a.get("st_on")) and J.num(a.get("rev_until", -1.0)) <= t
	if not st and a.get("bf") is Array:
		for b in a.bf:
			if b is Dictionary and str(b.get("p", "")) == "stealth" and J.num(b.get("until", 0)) > t: st = true
	if st: o.stealth = true
	if J.t(a.get("fly")):
		var gr = J.num(a.get("ground_until", -1.0)) > t
		o.fly = not gr; o.ground = gr

# UnitVis 用：飛行抬高幾多、透明度
static func lift_of(op, u: Dictionary) -> float:
	if J.num(u.get("hp", 1)) <= 0: return 0.0
	return LIFT if status(op, u).fly else 0.0
static func alpha_of(op, u: Dictionary) -> float:
	if not status(op, u).stealth: return 1.0
	return 0.35 if J.num(u.get("side", 0)) != 0 else 0.55

# 頭頂（畫面 px 座標系，原點＝血條左上中間；向上係負）。回傳用咗之後嘅 yy
static func draw_over(v, n: CanvasItem, f: Font, op, u: Dictionary, yy: float) -> float:
	var s = status(op, u)
	var side1 = J.num(u.get("side", 0)) != 0
	# 讀條（血條上面）
	if s.chant != null and op != null and op.phase == "fight":
		var bw = 52.0 if s.chant.big else 40.0
		var col = Color("#ff5a4a") if side1 else Color("#ffd84a")
		var y0 = yy - 6.0
		n.draw_rect(Rect2(-bw / 2 - 2, y0 - 2, bw + 4, 9), Color(0, 0, 0, 0.8))
		n.draw_rect(Rect2(-bw / 2, y0, bw * float(s.chant.f), 5), col)
		yy -= 12.0
		if str(s.chant.name) != "":
			v._str(n, f, str(DB.L(str(s.chant.name))), 0, yy, 15, Color("#ffb0a0") if side1 else Color("#fff0b0")); yy -= 18.0
	# 圖示一行：盾、殼、隱、飛／擊落、失神，敵人再加機制（同一個唔重複）
	var row = []
	if s.shield > 0.5: row.append("st_shield")
	if s.shell >= 0: row.append("st_shell")
	if s.stealth: row.append("st_stealth")
	if s.fly: row.append("st_fly")
	elif s.ground: row.append("st_ground")
	if s.daze: row.append("st_daze")
	if side1:
		var shown = {"shell": s.shell >= 0, "stealth": s.stealth, "fly": s.fly or s.ground}
		var nm = 0
		for m in mechs(u):
			var c = AI.canon(m)
			if shown.get(c, false) or nm >= 3: continue
			row.append(c); nm += 1
	if row.is_empty(): return yy
	var gap = IC * 2.0 + 3.0
	var x0 = -(row.size() - 1) * gap * 0.5
	var cy = yy - IC - 1.0
	for i in row.size():
		var c = Vector2(x0 + i * gap, cy)
		AI.draw(n, row[i], c, IC)
		if row[i] == "st_shell":   # 殼剩幾多：圈外弧
			n.draw_arc(c, IC + 2.0, -PI / 2, -PI / 2 + TAU * float(s.shell), 24, Color("#ffd27a"), 2.5, true)
	return yy - IC * 2.0 - 5.0

# ---------------- ab 事件飄字 ----------------
const EV := {
	"reveal": ["現形！", "現形！", "#ffe680"], "shell_break": ["殼破！", "殼破！", "#ffd27a"], "break": ["殼破！", "殼破！", "#ffd27a"],
	"revive": ["屍變！", "屍變！", "#b8e08a"], "seal": ["收！", "收！", "#a8d8ff"], "banish": ["收！", "收！", "#a8d8ff"],
	"shield": ["護盾", "護盾", "#9ad0ff"], "dispel": ["驅散", "驅散", "#e0c0ff"], "interrupt": ["打斷！", "打斷！", "#ffb070"],
	"summon": ["召喚", "召喚", "#d0a0ff"], "split": ["散骨", "散骨", "#e0d8c8"], "thorns": ["反傷", "反傷", "#ff9a7a"],
	"regen": ["回血", "回血", "#8affb0"], "regen_stop": ["停回血", "停回血", "#9ad0ff"], "ground": ["擊落！", "擊落！", "#ffd27a"],
	"immune": ["免疫", "免疫", "#c0c0c0"], "taunt": ["嘲諷", "嘲諷", "#ffb070"], "execute": ["斬殺！", "斬殺！", "#ff6a5a"],
	"clone": ["分身", "分身", "#c8d0e0"], "clone_pop": ["破分身", "破分身", "#ffe680"], "confuse": ["迷魂", "迷魂", "#c0a8ff"],
	"steady": ["定神", "定神", "#c8d8ff"], "fear_aura": ["嚇氣受壓", "嚇氣受壓", "#e0a0c0"], "rush": ["突襲！", "突襲！", "#ff8a6a"],
	"heal": ["回血", "回血", "#8affb0"], "sap": ["削嚇氣", "削嚇氣", "#9ad0ff"], "cc_immune": ["霸體", "霸體", "#d0b090"],
	"stealth": ["隱身", "隱身", "#b8b0d0"], "fly": ["飛起", "飛起", "#a8d0f0"],
}
const EV_ALIAS := {"現形": "reveal", "殼破": "shell_break", "屍變": "revive", "收": "seal", "驅散": "dispel", "打斷": "interrupt", "擊落": "ground", "反傷": "thorns", "散骨": "split", "召喚": "summon", "斬殺": "execute"}

static func on_event(op, e: Array) -> void:
	if e.size() < 3: return
	var src = e[1]; var prim = str(e[2]); var tg = e[3] if e.size() > 3 else null
	var u = tg if tg is Dictionary and tg.get("p") != null else (src if src is Dictionary and src.get("p") != null else null)
	var key = EV_ALIAS.get(prim, prim)
	var d = EV.get(key)
	var text = ""
	var col = "#fff0d0"
	if e.size() > 4 and e[4] is String and str(e[4]) != "": text = str(e[4])
	elif d != null: text = L(d[0], d[1])
	else: return   # 唔識嘅積木唔飄字（免得一堆英文）
	if d != null: col = d[2]
	if u == null: return
	var stack = 0
	for x in FL: if x.u == u and x.t < 0.6: stack += 1
	if stack >= 3: return   # 同一隻同時最多 3 行，唔好疊爆
	FL.append({"u": u, "op": op, "text": text, "col": col, "t": 0.0, "life": 1.3, "dy": -stack * 28.0})
	if FL.size() > 40: FL.pop_front()

static func tick(dt: float) -> void:
	var keep = []
	for x in FL:
		x.t += dt
		if x.t < x.life: keep.append(x)
	FL = keep

static func draw_floats(v, n: CanvasItem, f: Font, vr: Rect2) -> void:
	for x in FL:
		var u: Dictionary = x.u
		var op = x.op
		var p: Vector2 = (op.head(u) if op != null else (u.p as Vector2) + Vector2(0, -56)) + Vector2(0, -lift_of(op, u))
		if not vr.has_point(p): continue
		var k = x.t / x.life
		var a = 1.0 if k < 0.7 else 1.0 - (k - 0.7) / 0.3
		var pop = 1.2 - 0.2 * clampf(x.t / 0.12, 0, 1)
		var top = minf(-20.0, J.num(u.get("_hud_y", -40.0))) - 4.0   # 由頭頂資訊最高嗰行再上：唔遮血條、狀態圖示、失神字
		v._at(n, p + Vector2(0, -4.0 + (top - x.t * 18.0) / v._z()), pop)
		var c = Color(x.col); c.a = a
		v._str(n, f, str(x.text), 0, x.dy, 18, c, 5)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 名鬼技能：長按切自動／手動（S.ab_auto[gid]；冇＝跟總掣 gb_auto） ----------------
static func gid_of(u: Dictionary) -> String: return J.str(u.get("gid", u.get("k")))
static func pref(u: Dictionary):   # null＝跟總掣
	var S = J.G.get("S")
	if not (S is Dictionary) or not (S.get("ab_auto") is Dictionary): return null
	var x = S.ab_auto.get(gid_of(u))
	return null if x == null else J.t(x)
static func auto_of(u: Dictionary, auto: bool) -> bool:
	var p = pref(u)
	return auto if p == null else bool(p)
static func toggle(u: Dictionary, auto: bool) -> bool:   # 回切換後嘅狀態
	var S = J.G.get("S")
	if not (S is Dictionary): return auto
	if not (S.get("ab_auto") is Dictionary): S["ab_auto"] = {}
	var now = not auto_of(u, auto)
	S.ab_auto[gid_of(u)] = now
	var sv = J.G.get("save")
	if sv != null: J.cl(sv, null, [])
	return now
