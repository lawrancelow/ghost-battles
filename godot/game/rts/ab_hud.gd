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
	if u.get("mech") is Array: return (u.mech as Array).map(func(m): return AI.canon(AB.norm_mech(m)))   # [abui] 中文／英文一律轉英文正名
	var k = J.str(u.get("k"))
	if not _mc.has(k): _mc[k] = (AB.mechs_of(k) if AB.on() else []).map(func(m): return AI.canon(m))
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

# [補丁43] buff／debuff 目錄：回 [{k, n（層數）, neg, left（剩秒，-1＝成場）}]，控場先、dot、負面、正面
const ST_MAX := 4
const ST_ORDER := ["st_stun", "st_silence", "st_charm", "st_confuse", "st_flee", "st_air", "st_down", "st_taunted", "st_burn", "st_poison", "st_claw", "st_curse",
	"st_mark", "st_abreak", "st_wound", "st_slow", "st_aslow", "st_atkd", "st_saplock",
	"st_revive", "st_immune", "st_steady", "st_guard", "st_taunt", "st_def", "st_atk", "st_aspd", "st_spd", "st_hot", "st_healup"]
const DOT_K := {"burn": "st_burn", "fire": "st_burn", "poison": "st_poison", "claw": "st_claw"}
static func _bf_key(b: Dictionary) -> String:
	var p = str(b.get("p", "")); var v = J.num(b.get("v", 0)); var stt = str(b.get("stat", ""))
	match p:
		"buff":
			match stt:
				"atk": return "st_atk" if v >= 0 else "st_atkd"
				"aspd": return "st_aspd" if v >= 0 else "st_aslow"
				"spd": return "st_spd" if v >= 0 else "st_slow"
				"taken": return "st_def" if v < 0 else "st_mark"
				"heal_out": return "st_healup" if v >= 0 else "st_wound"
				"heal_in": return "st_healup" if v >= 0 else "st_wound"
			return ""
		"slow": return "st_aslow" if stt == "aspd" else "st_slow"
		"mark": return "st_mark"
		"armor_break": return "st_abreak"
		"wound": return "st_wound"
		"silence": return "st_silence"
		"hot": return "st_hot"
		"immune": return "st_immune"
		"steady": return "st_taunt" if str(b.get("id", "")) == "steady_t" else "st_steady"
		"dot": return DOT_K.get(str(b.get("kind", "burn")), "st_curse")
		"sap_lock": return "st_saplock"
	return ""
static func effects(op, u: Dictionary) -> Array:
	var t = _t(op)
	var a = u.get("ab")
	var acc = {}
	var add = func(k: String, left: float):
		if k == "": return
		if not acc.has(k): acc[k] = {"k": k, "n": 0, "left": left}
		acc[k].n += 1
		if left < 0 or (J.num(acc[k].left) >= 0 and left > J.num(acc[k].left)): acc[k].left = left
	if a is Dictionary:
		for b in a.get("bf", []):
			if not (b is Dictionary): continue
			var un = J.num(b.get("until", 0))
			if un <= t: continue
			add.call(_bf_key(b), -1.0 if un > 1e8 else un - t)
		if J.num(a.get("stun_until", 0)) > t: add.call("st_stun", J.num(a.stun_until) - t)
		if J.num(a.get("flee_until", 0)) > t: add.call("st_flee", J.num(a.flee_until) - t)
		if J.num(a.get("conf_until", 0)) > t: add.call("st_confuse", J.num(a.conf_until) - t)
		if J.num(a.get("charm_until", 0)) > t: add.call("st_charm", J.num(a.charm_until) - t)
		if J.num(a.get("taunt_until", 0)) > t and a.get("taunt_by") is Dictionary and J.num(a.taunt_by.get("hp", 0)) > 0: add.call("st_taunted", J.num(a.taunt_until) - t)
		if J.num(a.get("revive", 0)) > 0: add.call("st_revive", -1.0)
		if a.get("guard") is Dictionary and J.num(a.guard.get("until", 0)) > t: add.call("st_guard", -1.0 if J.num(a.guard.until) > 1e8 else J.num(a.guard.until) - t)
	var st = u.get("st")
	if st is Dictionary:
		if J.num(st.get("air", 0)) > 0: add.call("st_air", J.num(st.air))
		elif J.num(st.get("down", 0)) > 0: add.call("st_down", J.num(st.down))
	var o = []
	for k in ST_ORDER: if acc.has(k): var e = acc[k]; e["neg"] = J.t(AI.info(k).get("neg")); o.append(e)
	return o

# 頭頂資訊行（由下而上；交 ab_lay 排版，唔重疊）：讀條、狀態圖示（盾殼隱飛失神＋敵人機制）
static func lines_of(op, u: Dictionary, f: Font) -> Array:
	var o = []
	var s = status(op, u)
	var side1 = J.num(u.get("side", 0)) != 0
	if s.chant != null and op != null and op.phase == "fight":
		var bw = 52.0 if s.chant.big else 40.0
		o.append({"k": "chant", "w": bw + 4.0, "h": 12.0, "f": float(s.chant.f), "col": Color("#ff5a4a") if side1 else Color("#ffd84a")})
		if str(s.chant.name) != "":
			var nm = str(DB.L(str(s.chant.name)))
			o.append({"k": "text", "s": nm, "px": 15, "w": f.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 10.0, "h": 19.0, "col": Color("#ffb0a0") if side1 else Color("#fff0b0")})
	var row = []
	if s.shield > 0.5: row.append("st_shield")
	if s.shell >= 0: row.append("st_shell")
	if s.stealth: row.append("st_stealth")
	if s.fly: row.append("st_fly")
	elif s.ground: row.append("st_ground")
	if s.daze: row.append("st_daze")
	if side1:
		var shown = {"shell": s.shell >= 0, "stealth": s.stealth, "fly": s.fly or s.ground}
		var nm2 = 0
		for m in mechs(u):
			var c = AI.canon(m)
			if shown.get(c, false) or nm2 >= 3: continue
			row.append(c); nm2 += 1
	if row.size():
		o.append({"k": "icons", "keys": row, "shell": s.shell, "w": row.size() * (IC * 2.0 + 3.0) + 2.0, "h": IC * 2.0 + 5.0})
	# [補丁43] buff／debuff 一排：最多 4 個（控場先），多出顯示「+N」，層數 ≥2 顯示細數字
	var ef = effects(op, u)
	if ef.size():
		var ks = []; var nn = []; var ng = []
		for i in mini(ST_MAX, ef.size()): ks.append(ef[i].k); nn.append(int(ef[i].n)); ng.append(bool(ef[i].neg))
		var more = ef.size() - ks.size()
		o.append({"k": "icons", "keys": ks, "stk": nn, "neg": ng, "more": more, "w": ks.size() * (IC * 2.0 + 3.0) + (22.0 if more > 0 else 0.0) + 2.0, "h": IC * 2.0 + 5.0})
	return o

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
	# [補丁43] 狀態目錄新增（封口／打斷／嘲諷／迷魂／迷惑引擎本身已有飄字，唔重複）
	"stun": ["定身", "定身", "#ffd27a"], "slow": ["減速", "減速", "#9ad0ff"], "mark": ["易傷", "易傷", "#ff9a7a"],
	"armor_break": ["破甲", "破甲", "#ffb070"], "wound": ["重創", "重創", "#ff8aa0"], "flee": ["驚走", "驚走", "#d8e08a"],
	"hot": ["回血", "回血", "#8affb0"], "revive_set": ["返生", "返生", "#d8f0a0"], "guard": ["護衛", "護衛", "#9ad0ff"],
	"sap_lock": ["鎖嚇氣", "鎖嚇氣", "#9ab0ff"], "dot_burn": ["燒傷", "燒傷", "#ffa060"], "dot_poison": ["中毒", "中毒", "#a0e080"],
	"dot_claw": ["抓傷", "抓傷", "#ff9a8a"], "dot_curse": ["陰氣", "陰氣", "#c0a0e0"],
}
const ST_FL := ["stun", "slow", "mark", "armor_break", "wound", "flee", "hot", "revive_set", "guard", "sap_lock", "dot_burn", "dot_poison", "dot_claw", "dot_curse"]
const FL_CD_ST := 1.5       # [補丁43] 狀態飄字：同一隻同一狀態 1.5 秒內唔重複
const EV_ALIAS := {"現形": "reveal", "殼破": "shell_break", "屍變": "revive", "收": "seal", "驅散": "dispel", "打斷": "interrupt", "擊落": "ground", "反傷": "thorns", "散骨": "split", "召喚": "summon", "斬殺": "execute"}

const FL_CD := 3.0          # [abui] 同一隻同一句最短間隔（秒）
const FL_CD_LONG := 12.0    # 持續／光環型狀態（引擎每次刷新都會發事件）
const FL_LONG := ["immune", "steady", "cc_immune", "fear_aura", "shield", "regen", "stealth", "fly"]
static var STAT_DROP := 0   # 測試用：節流食咗幾多個
static func on_event(op, e: Array) -> void:
	if e.size() < 3: return
	var src = e[1]; var prim = str(e[2]); var tg = e[3] if e.size() > 3 else null
	var u = tg if tg is Dictionary and tg.get("p") != null else (src if src is Dictionary and src.get("p") != null else null)
	var key = EV_ALIAS.get(prim, prim)
	if key == "dot" and tg is Dictionary:   # [補丁43] dot 按種類飄字
		var dk = "curse"
		var ta = tg.get("ab")
		if ta is Dictionary:
			for b in ta.get("bf", []): if b is Dictionary and str(b.get("p", "")) == "dot": dk = str(b.get("kind", "burn"))
		key = "dot_" + {"burn": "burn", "fire": "burn", "poison": "poison", "claw": "claw"}.get(dk, "curse")
	var d = EV.get(key)
	var text = ""
	var col = "#fff0d0"
	if e.size() > 4 and e[4] is String and str(e[4]) != "": text = str(e[4])
	elif d != null: text = L(d[0], d[1])
	else: return   # 唔識嘅積木唔飄字（免得一堆英文）
	if d != null: col = d[2]
	if u == null: return
	# 節流：同一隻、同一句 3 秒內只飄一次（光環型持續狀態，例如無頭鬼光環每格重新上「免疫」，12 秒先再提一次）
	var now = float(op.t) if op != null and op.get("t") != null else Time.get_ticks_msec() / 1000.0
	var cdm = u.get("_flcd")
	if not (cdm is Dictionary): cdm = {}; u["_flcd"] = cdm
	if cdm.has(text) and now - float(cdm[text]) < (FL_CD_LONG if key in FL_LONG else (FL_CD_ST if key in ST_FL else FL_CD)):
		STAT_DROP += 1; return
	cdm[text] = now
	for x in FL:   # 同一隻、同一句仲喺度：合併做「×2」
		if x.u == u and x.base == text and x.t < 0.9:
			x.n += 1; x.text = "%s×%d" % [text, x.n]; x.t = minf(x.t, 0.2); return
	FL.append({"u": u, "op": op, "base": text, "text": text, "n": 1, "col": col, "t": 0.0, "life": 1.3, "wait": 0.0, "shown": false})
	if FL.size() > 40: FL.pop_front()

static func tick(dt: float) -> void:   # 排唔到位＝延遲出（時間唔郁）；等超過 2 秒就唔出
	var keep = []
	for x in FL:
		if J.t(x.get("shown")): x.t += dt
		else: x.wait += dt
		if x.t < x.life and x.wait < 2.0: keep.append(x)
	FL = keep

static func gather_floats(v, AL) -> void:
	for x in FL:
		var u: Dictionary = x.u
		var op = x.op
		if op == null: continue
		var wp: Vector2 = op.head(u) + Vector2(0, -4 - lift_of(op, u))
		var k = x.t / x.life
		var a = 1.0 if k < 0.7 else 1.0 - (k - 0.7) / 0.3
		var c = Color(x.col); c.a = a
		AL.add_float(x, v._scr(wp), str(x.text), 18, c, x.t * 18.0, 1.12 - 0.12 * clampf(x.t / 0.12, 0, 1), u)

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
