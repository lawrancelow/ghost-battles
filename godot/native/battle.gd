# 原生改寫自 battle.js（主線戰鬥規則）——畫面由 game/battle（BtRun／BtDraw）原生畫
# J.G["Battle"] 物件欄位同轉譯版一樣（BtRun／BtSelect／rework／presence／chatter／bonds 都讀寫佢）
# 注意：rework／presence／chatter 會包住 hit／start／finish／mkGhostUnit，所以內部叫呢幾個一定要經 B 查表（J.mc）
# 繪圖（draw*／poseOf）交俾 BtDraw；Godot 入面 draw() 唔使做嘢（BtRun 自己畫）
extends RefCounted

const GIFT_REWARD := {"gift_phone": {"coins": 300.0}, "gift_car": {"coins": 800.0, "chest": "p"}}
const WIND := 0.22
const STRIKE := 0.12
const REC := 0.25
const IMPACT := 0.05
const PSPD := 640.0
const CAST := 0.45

static var B: Dictionary = {}

static func _g(n: String): return J.G.get(n)
static func _S() -> Dictionary: return J.G.get("S")
static func _el(sel: String):
	var f = _g("$")
	return J.cl(f, null, [sel]) if f != null else null
static func _snd(n, x = null) -> void:
	var s = _g("Sound")
	if s != null: J.mc(s, "play", [n] if x == null else [n, x])
static func _sign(v: float) -> float: return 1.0 if v > 0 else (-1.0 if v < 0 else 0.0)
static func _nn(u: Dictionary, k: String) -> float:
	var v = u.get(k)
	return J.num(v) if v != null else 0.0
static func _gbi(id): return J.cl(_g("ghostById"), null, [id])
static func _stat(g, i: int) -> float: return J.num(J.mc(_g("F"), "stat", [g, float(i)]))

# ---------------- 小工具 ----------------
static func sid_of(ci, si) -> String: return "%d-%d" % [int(J.num(ci)) + 1, int(J.num(si)) + 1]

static func stage_open(ci, si) -> bool:
	var S = _S(); var c = int(J.num(ci)); var s = int(J.num(si))
	if s > 0 and not J.t(S.cleared.get(sid_of(c, s - 1))): return false
	if s == 0 and c > 0 and not J.t(S.cleared.get(sid_of(c - 1, 2))): return false
	return true

static func uy(u: Dictionary) -> float:
	var H = J.num(B.get("H")) if J.t(B.get("H")) else 640.0
	return H * 0.5 + _nn(u, "lane") * H * 0.1

static func scale_of(u: Dictionary) -> float: return 0.75 if J.t(u.get("minion")) else (1.7 if J.t(u.get("boss")) else 1.32)
static func period(u: Dictionary) -> float: return 1.15 if _nn(u, "range") > 60 else 0.95
static func lead_of(u: Dictionary, tg: Dictionary) -> float:
	if _nn(u, "range") > 60: return WIND + maxf(0.0, absf(_nn(tg, "x") - _nn(u, "x")) - 10) / PSPD
	return WIND + IMPACT
static func lunge_of(u: Dictionary) -> float: return 12.0 if J.t(u.get("boss")) else (6.0 if J.t(u.get("minion")) else 9.0)

static func enemies_of(u: Dictionary) -> Array:
	var out = []; var side = _nn(u, "side")
	for v in B.units: if _nn(v, "side") != side and _nn(v, "hp") > 0: out.append(v)
	return out

static func nearest(u: Dictionary):
	var best = null; var bd = 1e9
	for v in enemies_of(u):
		var d = absf(_nn(v, "x") - _nn(u, "x")) + absf(_nn(v, "lane") - _nn(u, "lane")) * 18
		if d < bd: bd = d; best = v
	return best

static func state_of(v: Dictionary):
	var st = v.st
	if _nn(st, "air") > 0: return "air"
	if _nn(st, "down") > 0: return "down"
	return null

static func hit_stop_for(sec: float, must := false) -> void:
	var b = _nn(B, "hsBank")
	if b < (-0.04 if must else sec): return
	B["hsBank"] = b - sec
	B["hitStop"] = maxf(_nn(B, "hitStop"), sec / J.num(B.speed))

static func kick(amp: float) -> void: B["shakeA"] = maxf(_nn(B, "shakeA"), amp)

# ---------------- 特效產生 ----------------
static func spark(x: float, y: float, k: float, col: String) -> void:
	var n = 7 + int(floor(randf() * 4)); var rays = []
	for i in n: rays.append({"a": (float(i) / n) * PI * 2 + (randf() - 0.5) * 0.5, "len": (14 + randf() * 16) * k, "j": randf() * 1000})
	B.fx.append({"kind": "spark", "x": x, "y": y, "t": 0.0, "life": 0.24, "rays": rays, "col": col, "k": k, "rot": randf() * PI})

static func dust(x: float, y: float, k: float) -> void:
	var puffs = []
	for i in 5: puffs.append({"dx": (randf() - 0.5) * 18 * k, "vx": (randf() - 0.5) * 60 * k, "r": (4 + randf() * 4) * k})
	B.fx.append({"kind": "dust", "x": x, "y": y, "t": 0.0, "life": 0.45, "puffs": puffs})

# ---------------- 受擊 ----------------
static func hit(src: Dictionary, v: Dictionary, mult: float, sk) -> float:
	var m = mult
	var adv = B.get("adviser")
	var bonus = 1 + J.num(adv.bonus) if _nn(src, "side") == 0 and J.t(adv) else 1.0
	var combo_hit = false
	if J.t(sk) and J.t(sk.get("follow")) and state_of(v) == sk.get("follow"): m *= 1.8; combo_hit = true
	var dmg = J.round(_nn(src, "atk") * m * bonus * (0.9 + randf() * 0.2))
	v["hp"] = _nn(v, "hp") - dmg
	if J.t(sk) or _nn(B, "t") - _nn(B, "sndT") > 0.09: B["sndT"] = B.t; _snd("hit")
	var vs = _nn(v, "side")
	var sx = J.num(src.x) if src.get("x") != null else _nn(v, "x") - (1.0 if vs != 0 else -1.0)
	var dir = _sign(_nn(v, "x") - sx)
	if dir == 0: dir = 1.0 if vs != 0 else -1.0
	var s = scale_of(v); var hy = uy(v) - 30 * s
	v["flash"] = 1.0; v["kbDir"] = -dir if J.str(src.get("k")) == "heiwu" else dir; v["kbT"] = 0.0
	if not J.t(v.get("anim")) and not J.t(v.get("casting")): v["hurtT"] = 0.25
	spark(_nn(v, "x") - dir * 6 * s, hy, 1.35 if combo_hit or J.t(sk) else (0.7 if J.t(v.get("minion")) else 1.0), "#ff9a7a" if vs == 0 else ("#ffd84a" if combo_hit else "#fff4c0"))
	var big = combo_hit or J.t(sk)
	B.fx.append({"kind": "num", "x": _nn(v, "x") + (randf() - 0.5) * 14, "y": uy(v) - 70 * s, "vx": dir * (14 + randf() * 18), "text": J.str(dmg),
		"col": "#ffd84a" if combo_hit else ("#ff8a8a" if vs == 0 else "#fff"), "t": 0.0, "life": 0.95, "big": big})
	kick(minf(9.0, (2.5 if J.t(sk) else 0.8) + dmg / _nn(v, "maxhp") * 26) * (0.4 if J.t(v.get("minion")) and J.t(src.get("minion")) else 1.0))
	if J.t(sk): hit_stop_for(0.12, true)
	elif (not J.t(src.get("minion")) or not J.t(v.get("minion"))) and _nn(B, "t") - (J.num(B.lastHS) if J.t(B.get("lastHS")) else -9.0) > 0.4:
		B["lastHS"] = B.t; hit_stop_for(0.08 if dmg > _nn(v, "maxhp") * 0.12 else 0.055)
	if combo_hit and _nn(src, "side") == 0:
		_snd("combo", B.get("combo"))
		B["combo"] = _nn(B, "combo") + 1 if _nn(B, "comboT") > 0 else 1.0
		B["comboT"] = 3.0; B["comboPop"] = 1.0
		B.fx.append({"x": 195.0, "y": (J.num(B.H) if J.t(B.get("H")) else 640.0) * 0.3, "text": "連嚇 ×%s！" % J.str(_nn(B, "combo") + 1), "col": "#ffd84a", "t": 0.0, "life": 1.2, "center": true})
	if J.t(sk) and J.t(sk.get("apply")) and _nn(v, "hp") > 0:
		var ap = J.str(sk.apply)
		if ap == "air": v.st["air"] = 1.0; v.st["airMax"] = 1.0; v.st["down"] = 0.0
		if ap == "down": v.st["down"] = 1.4; v.st["downMax"] = 1.4; v.st["air"] = 0.0; dust(_nn(v, "x"), uy(v), 1.2)
		if ap == "push": v.st["push"] = 0.25
		v["anim"] = null
	if J.t(sk) and J.t(sk.get("drain")): src["hp"] = minf(_nn(src, "maxhp"), _nn(src, "hp") + dmg * J.num(sk.drain))
	if J.t(sk) and J.t(sk.get("sap")): v["energy"] = maxf(0.0, _nn(v, "energy") - J.num(sk.sap))
	if J.t(sk) and J.t(sk.get("steal")) and _nn(src, "side") == 0: B["coinsWon"] = _nn(B, "coinsWon") + J.num(sk.steal)
	if not J.t(sk): src["energy"] = minf(100.0, _nn(src, "energy") + 8)
	v["energy"] = minf(100.0, _nn(v, "energy") + 4)
	if _nn(v, "hp") <= 0:
		v["hp"] = 0.0; v["deadT"] = 0.0; v["dieDir"] = dir; v["anim"] = null; v["casting"] = null
		if not J.t(v.get("minion")): hit_stop_for(0.14 if J.t(sk) else 0.09, true)
		kick(3.0 if J.t(v.get("minion")) else 7.0); spark(_nn(v, "x"), hy, 1.6, "#fff")
	return dmg

static func _hit(src, v, mult: float, sk) -> void: J.mc(B, "hit", [src, v, mult, sk])

static func do_skill(u: Dictionary, sk, extra_mult = null) -> void:
	if not J.t(sk): return
	var mult = J.num(sk.mult) * (J.num(extra_mult) if J.t(extra_mult) else 1.0)
	var kind = J.str(sk.get("kind"))
	if kind == "heal":
		for v in B.units:
			if _nn(v, "side") == _nn(u, "side") and _nn(v, "hp") > 0:
				var h = _nn(v, "maxhp") * J.num(sk.mult); v["hp"] = minf(_nn(v, "maxhp"), _nn(v, "hp") + h)
				B.fx.append({"x": v.x, "y": uy(v) - 90, "text": "+" + J.str(J.round(h)), "col": "#8affb0", "t": 0.0, "life": 0.9})
				B.fx.append({"kind": "ring", "x": v.x, "y": uy(v) - 30, "t": 0.0, "life": 0.5, "col": "#8affb0"})
		if J.t(sk.get("forget")): for v in enemies_of(u): v["energy"] = 0.0
	elif kind == "aoe":
		for v in enemies_of(u): _hit(u, v, mult, sk)
	else:
		var v = nearest(u)
		if v != null:
			if u.get("x") != null:
				var d = _sign(_nn(v, "x") - _nn(u, "x"))
				B.fx.append({"kind": "slash", "x": v.x, "y": uy(v) - 30 * scale_of(v), "dir": d if d != 0 else 1.0, "t": 0.0, "life": 0.22, "r": 34.0, "col": "#bff" if _nn(u, "side") == 0 else "#f9a"})
			var hits = J.num(sk.get("hits")) if J.t(sk.get("hits")) else 0.0
			if hits > 1:
				for i in int(hits):
					if _nn(v, "hp") > 0:
						var s2 = sk
						if i != int(hits) - 1:
							s2 = sk.duplicate(); s2["apply"] = null; s2["drain"] = sk.get("drain"); s2["sap"] = 0.0; s2["steal"] = 0.0
						_hit(u, v, mult / hits, s2)
			else: _hit(u, v, mult, sk)
	var has_x = u.get("x") != null
	B.fx.append({"x": u.x if has_x else 60.0, "y": uy(u) - 115 if has_x else 90.0, "text": sk.name, "col": "#bff" if _nn(u, "side") == 0 else "#f9a", "t": 0.0, "life": 1.1, "skill": true})
	B["flashT"] = 0.12; kick(8.0 if kind == "aoe" else 5.0); _snd("skill")

# ---------------- 施法 ----------------
static func begin_cast(u: Dictionary) -> void:
	u["energy"] = 0.0
	if u.get("x") == null: B["advCast"] = {"u": u, "t": 0.0, "dur": CAST, "slow": false}; return
	u["anim"] = null; u["walking"] = false; u["casting"] = {"t": 0.0, "dur": CAST, "slow": false}

static func tick_cast(c: Dictionary, dt: float, u = null) -> bool:
	c["t"] = J.num(c.t) + dt
	if not J.t(c.get("slow")) and J.num(c.t) >= J.num(c.dur) * 0.5:
		c["slow"] = true
		if u == null or _nn(u, "side") == 0 or J.t(u.get("boss")): B["slowT"] = maxf(_nn(B, "slowT"), 0.25 / J.num(B.speed))
	return J.num(c.t) >= J.num(c.dur)

static func fire_cast(u: Dictionary) -> void: u["casting"] = null; do_skill(u, u.get("sk"))

static func cast(u: Dictionary) -> void:
	if J.t(B.get("result")) or _nn(u, "energy") < 100: return
	if u.get("hp") != null and _nn(u, "hp") <= 0: return
	if u.get("x") != null and (_nn(u.st, "air") > 0 or _nn(u.st, "down") > 0 or J.t(u.get("casting"))): return
	if u.get("x") == null and J.t(B.get("advCast")): return
	begin_cast(u)

static func cast_combo() -> void:
	var c = B.get("comboSkill")
	if not J.t(c) or _nn(c, "energy") < 100 or J.t(B.get("result")) or _nn(c.a, "hp") <= 0 or _nn(c.b, "hp") <= 0 or J.t(B.get("comboCast")): return
	c["energy"] = 0.0; B["comboCast"] = {"t": 0.0, "dur": CAST, "slow": false}

static func fire_combo() -> void:
	var c = B.comboSkill; B["comboCast"] = null
	var src = {"atk": (_nn(c.a, "atk") + _nn(c.b, "atk")) / 2, "side": 0.0, "hp": 1.0, "maxhp": 1.0, "x": (_nn(c.a, "x") + _nn(c.b, "x")) / 2, "lane": 1.0, "energy": 0.0}
	for v in enemies_of(src):
		_hit(src, v, J.num(c.c.mult), {"apply": "air"})
		v.st["down"] = 1.6; v.st["downMax"] = 1.6; v.st["air"] = 0.0; dust(_nn(v, "x"), uy(v), 1.3)
	B.fx.append({"x": 195.0, "y": (J.num(B.H) if J.t(B.get("H")) else 640.0) * 0.34, "text": c.c.name, "col": "#ffb0ff", "t": 0.0, "life": 1.5, "center": true})
	kick(11.0); B["flashT"] = 0.25

# ---------------- 出手節奏 ----------------
static func step_anim(u: Dictionary, dt: float) -> void:
	var a = u.anim; a["t"] = J.num(a.t) + dt; u["cd"] = _nn(u, "cd") - dt
	var ranged = _nn(u, "range") > 60
	var nm = J.str(a.name)
	if nm == "windup" and J.num(a.t) >= WIND:
		u["anim"] = {"name": "strike", "t": J.num(a.t) - WIND, "dur": STRIKE, "tg": a.get("tg")}
		if ranged: fire(u, a.get("tg"))
		else: dust(_nn(u, "x"), uy(u), 0.6)
		return
	if nm == "strike":
		if not ranged and not J.t(a.get("done")) and J.num(a.t) >= IMPACT:
			a["done"] = true
			var tg = a.get("tg")
			if not (J.t(tg) and _nn(tg, "hp") > 0 and absf(_nn(tg, "x") - _nn(u, "x")) <= _nn(u, "range") + 24): tg = null
			if tg == null:
				var n = nearest(u)
				if n != null and absf(_nn(n, "x") - _nn(u, "x")) <= _nn(u, "range") + 24: tg = n
			if tg != null:
				u["cd"] = period(u); var s = scale_of(tg)
				var d = _sign(_nn(tg, "x") - _nn(u, "x"))
				if d == 0: d = -1.0 if _nn(u, "side") != 0 else 1.0
				B.fx.append({"kind": "slash", "x": tg.x, "y": uy(tg) - 30 * s, "dir": d, "t": 0.0, "life": 0.17, "r": (18.0 if J.t(u.get("minion")) else 26.0) * (1.4 if J.t(u.get("boss")) else 1.0), "col": "#e8fbff" if _nn(u, "side") == 0 else "#ffd0c0"})
				_hit(u, tg, 1.0, null)
		if J.num(a.t) >= STRIKE: u["anim"] = {"name": "recover", "t": J.num(a.t) - STRIKE, "dur": REC}
		return
	if nm == "recover" and J.num(a.t) >= REC: u["anim"] = null

static func fire(u: Dictionary, tg) -> void:
	if not J.t(tg) or _nn(tg, "hp") <= 0:
		tg = nearest(u)
		if tg == null: return
	var s = scale_of(u); var y = uy(u) - 34 * s; var dist = maxf(0.0, absf(_nn(tg, "x") - _nn(u, "x")) - 10)
	u["cd"] = period(u) + dist / PSPD
	B.proj.append({"src": u, "tg": tg, "x": _nn(u, "x") + (-14.0 if _nn(u, "side") != 0 else 14.0) * s, "y": y, "trail": [], "col": "#9ff3ff" if _nn(u, "side") == 0 else "#ff9ac0", "side": u.side})

static func step_proj(dt: float) -> void:
	var keep = []
	for p in B.proj:
		if not J.t(p.get("tg")) or _nn(p.tg, "hp") <= 0:
			p["tg"] = nearest(p.src)
			if p.tg == null: continue
		var tx = _nn(p.tg, "x"); var ty = uy(p.tg) - 30 * scale_of(p.tg)
		var dx = tx - J.num(p.x); var dy = ty - J.num(p.y); var d = Vector2(dx, dy).length(); var step = PSPD * dt
		p.trail.append([p.x, p.y])
		if p.trail.size() > 7: p.trail.pop_front()
		if d <= step + 4: _hit(p.src, p.tg, 1.0, null); continue
		p["x"] = J.num(p.x) + dx / d * step; p["y"] = J.num(p.y) + dy / d * step
		keep.append(p)
	B["proj"] = keep

# ---------------- 更新 ----------------
static func vis_tick(u: Dictionary, dt: float) -> void:
	if _nn(u, "hp") <= 0: u["deadT"] = _nn(u, "deadT") + dt
	u["flash"] = maxf(0.0, _nn(u, "flash") - dt / 0.18)
	u["hurtT"] = maxf(0.0, _nn(u, "hurtT") - dt)
	if u.get("kbT") != null:
		u["kbT"] = J.num(u.kbT) + dt
		if J.num(u.kbT) > 0.3: u["kbT"] = null

static func update(dt_real: float) -> void:
	if not J.t(B.get("active")): return
	B["shakeA"] = _nn(B, "shakeA") * exp(-dt_real * 13)
	if J.num(B.shakeA) < 0.15: B["shakeA"] = 0.0
	B["flashT"] = maxf(0.0, _nn(B, "flashT") - dt_real); B["comboPop"] = maxf(0.0, _nn(B, "comboPop") - dt_real * 4)
	var nfx = []
	for f in B.fx:
		f["t"] = J.num(f.t) + dt_real
		if J.num(f.t) < J.num(f.life): nfx.append(f)
	B["fx"] = nfx
	if _nn(B, "hitStop") > 0: B["hitStop"] = J.num(B.hitStop) - dt_real; return
	var ts = 1.0
	if _nn(B, "slowT") > 0: B["slowT"] = J.num(B.slowT) - dt_real; ts = 0.35
	var dt = dt_real * J.num(B.speed) * ts
	if J.t(B.get("result")):
		for u in B.units: vis_tick(u, dt)
		return
	B["t"] = _nn(B, "t") + dt; B["comboT"] = _nn(B, "comboT") - dt; B["hsBank"] = minf(0.16, _nn(B, "hsBank") + dt * 0.07)
	step_proj(dt)
	var auto = J.t(B.get("auto"))
	for u in B.units:
		vis_tick(u, dt)
		if _nn(u, "hp") <= 0: continue
		var st = u.st
		if _nn(st, "air") > 0:
			if J.t(u.get("casting")): fire_cast(u)
			u["anim"] = null; st["air"] = J.num(st.air) - dt
			if J.num(st.air) <= 0: dust(_nn(u, "x"), uy(u), 1.1); kick(5.0 if J.t(u.get("boss")) else 2.5)
			continue
		if _nn(st, "down") > 0:
			if J.t(u.get("casting")): fire_cast(u)
			u["anim"] = null; st["down"] = J.num(st.down) - dt; continue
		if _nn(st, "push") > 0:
			u["anim"] = null; st["push"] = J.num(st.push) - dt
			u["x"] = clampf(_nn(u, "x") + (-1.0 if _nn(u, "side") == 0 else 1.0) * 160 * dt, 16.0, 374.0)
			if randf() < dt * 30: dust(_nn(u, "x"), uy(u), 0.5)
			continue
		if J.t(u.get("sk")): u["energy"] = minf(100.0, _nn(u, "energy") + (11.0 if J.t(u.get("boss")) else 9.0) * dt)
		if J.t(u.get("casting")):
			u["cd"] = _nn(u, "cd") - dt
			if tick_cast(u.casting, dt, u): fire_cast(u)
			continue
		if J.t(u.get("sk")) and _nn(u, "energy") >= 100 and not J.t(u.get("anim")) and (_nn(u, "side") == 1 or (auto and not J.t(u.get("minion")))): begin_cast(u); continue
		if J.t(u.get("anim")): step_anim(u, dt); continue
		var tg = nearest(u)
		if tg == null: continue
		var dx = _nn(tg, "x") - _nn(u, "x"); var dist = absf(dx)
		if dist > _nn(u, "range"): u["x"] = _nn(u, "x") + _sign(dx) * _nn(u, "spd") * dt; u["walking"] = true
		else:
			u["walking"] = false; u["cd"] = _nn(u, "cd") - dt
			if J.num(u.cd) <= lead_of(u, tg): u["anim"] = {"name": "windup", "t": 0.0, "dur": WIND, "tg": tg}
	var adv = B.get("adviser")
	if J.t(adv):
		adv["energy"] = minf(100.0, _nn(adv, "energy") + 7 * dt)
		if auto and J.num(adv.energy) >= 100 and not J.t(B.get("advCast")): J.mc(B, "cast", [adv])
	if J.t(B.get("advCast")) and tick_cast(B.advCast, dt):
		var cu = B.advCast.u; B["advCast"] = null; do_skill(cu, cu.get("sk"))
	var cs = B.get("comboSkill")
	if J.t(cs):
		if _nn(cs.a, "hp") > 0 and _nn(cs.b, "hp") > 0: cs["energy"] = minf(100.0, _nn(cs, "energy") + 5 * dt)
		if auto and J.num(cs.energy) >= 100: cast_combo()
	if J.t(B.get("comboCast")) and tick_cast(B.comboCast, dt):
		var c = B.comboSkill
		if _nn(c.a, "hp") > 0 and _nn(c.b, "hp") > 0: fire_combo()
		else: B["comboCast"] = null
	# 分隔重疊
	var alive = []
	for u in B.units: if _nn(u, "hp") > 0: alive.append(u)
	for i in alive.size():
		for j in range(i + 1, alive.size()):
			var a = alive[i]; var b = alive[j]
			if _nn(a, "side") != _nn(b, "side"): continue
			if absf(_nn(a, "x") - _nn(b, "x")) < 22 and absf(_nn(a, "lane") - _nn(b, "lane")) < 0.6:
				var s = -1.0 if _nn(a, "x") < _nn(b, "x") else 1.0
				a["x"] = _nn(a, "x") + s * 10 * dt; b["x"] = _nn(b, "x") - s * 10 * dt
	if not J.t(B.get("_nat")): _dom_cards()
	var heroes = 0; var foes = 0
	for u in B.units:
		if _nn(u, "hp") <= 0: continue
		if _nn(u, "side") == 0 and not J.t(u.get("minion")): heroes += 1
		elif _nn(u, "side") == 1: foes += 1
	if not J.t(B.get("_nat")):
		var bt = _el("#b-time")
		if bt != null: J.sp(bt, "textContent", J.str(maxf(0.0, ceil(_nn(B, "timeLimit") - _nn(B, "t")))) + "s")
	if foes == 0: J.mc(B, "finish", [true])
	elif heroes == 0: J.mc(B, "finish", [false])
	elif _nn(B, "t") >= _nn(B, "timeLimit"): J.mc(B, "finish", [false, false, true])

# DOM 版技能卡（Godot 唔用：BtRun 有原生卡）
static func _dom_cards() -> void:
	for u in B.units:
		var cd = u.get("card")
		if cd == null: continue
		var s = J.mc(cd, "querySelector", [".en s"])
		if s != null: J.sp(J.gp(s, "style"), "height", J.str(u.energy) + "%")
		J.mc(J.gp(cd, "classList"), "toggle", ["ready", _nn(u, "energy") >= 100 and _nn(u, "hp") > 0 and not J.t(u.get("casting"))])
		J.mc(J.gp(cd, "classList"), "toggle", ["dead", _nn(u, "hp") <= 0])

# ---------------- 開戰 ----------------
static func mk_ghost_unit(g, i) -> Dictionary:
	var F = _g("F")
	var lv = J.mc(F, "glv", [g]); var P = _stat(g, 0); var A = _stat(g, 2); var d = J.cl(_g("gdef"), null, [g])
	var dm = J.num(J.mc(_g("GP"), "drillMul", [g.k])); var hp = (300 + P * 8 + A * 4) * dm
	var ranged = J.str(J.gp(d, "range")) == "ranged"; var ii = J.num(i)
	return {"side": 0.0, "k": g.k, "gid": g.id, "name": g.name, "hp": hp, "maxhp": hp, "atk": (20 + A * 1.4) * dm, "range": 150.0 if ranged else 46.0,
		"spd": 38.0 if ranged else 46.0, "x": 78 - ii * 14, "lane": [0.0, 1.1, 2.2, 0.55, 1.65][int(ii) % 5], "energy": 20.0, "sk": J.gp(_g("SKILLS"), g.k), "st": {}, "cd": randf() * 0.5, "lv": lv}

static func start(ci, si, wild) -> void:
	var S = _S()
	var ch; var st
	if J.t(wild): ch = {"bg": wild.bg}; st = wild.stage
	else: ch = _g("CHAPTERS")[int(J.num(ci))]; st = ch.stages[int(J.num(si))]
	B["ci"] = ci; B["si"] = si; B["stage"] = st; B["sid"] = wild.sid if J.t(wild) else sid_of(ci, si); B["bg"] = ch.get("bg")
	B["units"] = []; B["fx"] = []; B["t"] = 0.0; B["result"] = null; B["combo"] = 0.0; B["comboT"] = 0.0; B["coinsWon"] = 0.0; B["timeLimit"] = 90.0
	B["proj"] = []; B["hitStop"] = 0.0; B["slowT"] = 0.0; B["shakeA"] = 0.0; B["flashT"] = 0.0; B["advCast"] = null; B["comboCast"] = null; B["lastHS"] = -9.0; B["comboPop"] = 0.0; B["hsBank"] = 0.12
	var team = []
	for id in S.team:
		var g = _gbi(id)
		if J.t(g): team.append(g)
	for i in team.size(): B.units.append(J.mc(B, "mkGhostUnit", [team[i], float(i)]))
	var ad = _gbi(S.get("adviser"))
	B["adviser"] = {"k": ad.k, "name": ad.name, "energy": 0.0, "sk": J.gp(_g("SKILLS"), ad.k), "bonus": _stat(ad, 1) / 8 / 100, "atk": 20 + _stat(ad, 2) * 1.4, "side": 0.0} if J.t(ad) else null
	var sq = mini(8, int(floor(float(load("res://game/barracks/bk_data.gd").standby()) / 25))); B["squads"] = float(sq)   # [barracks] 只帶待命陰兵（防衛、清剿嘅留低）
	var tb = load("res://game/zone/zone_data.gd").troop_mul()   # [barracks] 陰兵加成：兵營（舊存檔民宅加成保底）
	var lv = J.num(S.lv)
	for i in sq:
		var hp = (90 + 14 * lv) * tb
		B.units.append({"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": hp, "maxhp": hp, "atk": (9 + 2.2 * lv) * tb, "range": 38.0, "spd": 52.0, "x": 120.0 + floor(i / 4.0) * 18, "lane": (i % 4) * 0.95 + 0.4, "energy": 0.0, "sk": null, "st": {}, "cd": randf()})
	load("res://game/militia/ml_data.gd").battle_units(B, st, wild)   # [militia] 對外戰鬥：遊魂兵小隊＋敵方惡鬼嘍囉
	load("res://game/equip/eq_data.gd").battle_units(B)   # [equip] 名鬼裝備血攻、遊魂兵 A/B 款
	var ET = _g("ENEMY_T"); var SK = _g("SKILLS"); var en: Array = st.en
	for i in en.size():
		var e = en[i]; var T = ET[e]; var hp = (260 + 90 * J.num(st.p)) * J.num(T[0]); var boss = J.str(e) == J.str(st.get("boss"))
		B.units.append({"side": 1.0, "k": e, "name": T[2], "hp": hp, "maxhp": hp, "atk": (16 + 7.5 * J.num(st.p)) * J.num(T[1]), "range": 140.0 if J.str(e) in ["zhiren", "penanggal"] else 46.0,
			"spd": 58.0 if J.str(e) == "xiaogui" else 42.0, "x": 318.0 + (i % 2) * 22, "lane": i * 1.05, "energy": 30.0 if boss else 0.0, "sk": J.gp(SK, e), "st": {}, "cd": randf() * 0.6, "boss": boss})
	if _g("GhostStreet") != null: J.mc(_g("GhostStreet"), "battleBuffs", [B.units])
	B["active"] = true; J.mc(_g("Sound"), "setMode", ["battle"]); B["sndT"] = 0.0
	var be = _el("#battle")
	if be != null: J.mc(J.gp(be, "classList"), "add", ["on"])
	J.mc(B, "resize", []); J.mc(B, "buildCards", []); J.mc(B, "syncBtns", [])
	var bt = _el("#b-title")
	if bt != null: J.sp(bt, "textContent", ("野鬼　%s" % J.str(st.name)) if J.t(st.get("wild")) else ("%s　%s" % [J.str(B.sid), J.str(st.name)]))
	B["_nat"] = false
	var nb = _g("__nat_battle")
	if nb != null and J.t(J.cl(nb, null, [B])): B["_nat"] = true; J.mc(B, "resize", [])

static func resize() -> void:
	if J.t(B.get("_nat")):
		var r = J.cl(_g("__nat_btSize"), null, [])
		B["dpr"] = 1.0; B["w"] = J.num(r[0]); B["h"] = J.num(r[1]); B["sc"] = J.num(B.w) / 390.0
		return
	var cvs = B.get("cvs")
	if cvs == null: return
	var r = J.mc(cvs, "getBoundingClientRect", [])
	B["dpr"] = 1.0; J.sp(cvs, "width", J.gp(r, "width")); J.sp(cvs, "height", J.gp(r, "height"))
	B["w"] = J.num(J.gp(r, "width")); B["h"] = J.num(J.gp(r, "height")); B["sc"] = J.num(B.w) / 390.0

# 技能卡：Godot 用原生卡（BtRun），呢度只定合體技（S.lv ≥ 17 先有）
static func build_cards() -> void:
	var box = _el("#b-cards")
	if box != null: J.sp(box, "innerHTML", "")
	B["comboSkill"] = null
	if J.num(_S().lv) >= 17:
		for c in _g("COMBOS"):
			var a = null; var b = null
			for u in B.units:
				if a == null and _nn(u, "side") == 0 and J.str(u.k) == J.str(c.a): a = u
				if b == null and _nn(u, "side") == 0 and J.str(u.k) == J.str(c.b): b = u
			if a != null and b != null: B["comboSkill"] = {"c": c, "a": a, "b": b, "energy": 0.0}; break

static func sync_btns() -> void:
	var a = _el("#b-auto"); var s = _el("#b-speed")
	if a != null:
		J.mc(J.gp(a, "classList"), "toggle", ["on", J.t(B.auto)]); J.sp(a, "textContent", "自動 ON" if J.t(B.auto) else "自動 OFF")
	if s != null: J.sp(s, "textContent", "×" + J.str(B.speed))

static func _ls(): return _g("localStorage")

static func init() -> void:
	B["cvs"] = _el("#bcvs")
	var ls = _ls()
	if ls != null:
		B["auto"] = J.str(J.mc(ls, "getItem", ["gb_auto"])) == "1"
		var sp = J.mc(ls, "getItem", ["gb_speed"])
		B["speed"] = J.num(sp) if J.t(sp) else 1.0
		if is_nan(J.num(B.speed)): B["speed"] = 1.0
	var a = _el("#b-auto")
	if a != null: J.sp(a, "onclick", func(_t, _a):
		B["auto"] = not J.t(B.auto); J.mc(_ls(), "setItem", ["gb_auto", "1" if J.t(B.auto) else "0"]); sync_btns())
	var s = _el("#b-speed")
	if s != null: J.sp(s, "onclick", func(_t, _a):
		B["speed"] = 2.0 if J.num(B.speed) == 1 else 1.0; J.mc(_ls(), "setItem", ["gb_speed", B.speed]); sync_btns())
	var q = _el("#b-quit")
	if q != null: J.sp(q, "onclick", func(_t, a2):
		if J.t(B.get("result")): return
		var e = J.arg(a2, 0)
		if not J.t(J.cl(_g("confirmInline"), null, [J.gp(e, "target"), "確定撤退？"])): return
		J.mc(B, "finish", [false, true]))
	var w = _g("window")
	if w != null: J.mc(w, "addEventListener", ["resize", func(_t, _a): if J.t(B.get("active")): J.mc(B, "resize", [])])

# ---------------- 選關（Godot 由 BtSelect 原生畫） ----------------
static func open_select() -> void:
	var f = _g("__nat_btSelect")
	if f != null: J.cl(f, null, ["select"])

static func pick_slot(slot) -> void:
	var f = _g("__nat_btSelect")
	if f != null: J.cl(f, null, ["pick", slot])

static func try_start(ci, si) -> void:
	var S = _S()
	var any_team = false
	for id in S.team: if J.t(id): any_team = true
	if not any_team: J.mc(_g("Fx"), "toast", ["至少要派一位鬼怪出陣"]); return
	var ch = _g("CHAPTERS")[int(J.num(ci))]; var st = ch.stages[int(J.num(si))]; var sid = sid_of(ci, si)
	J.mc(_g("UI"), "close", [])
	var go = func(_t = null, _a = null): J.mc(B, "start", [ci, si])
	var any = false; var Story = _g("Story")
	if int(J.num(si)) == 0:
		for id in ch.intro:
			if not J.t(S.seen.get(id)): J.mc(Story, "queue", [id]); any = true
	if J.t(st.get("before")) and not J.t(S.cleared.get(sid)) and not J.t(S.seen.get(st.before)): J.mc(Story, "queue", [st.before]); any = true
	if any: J.mc(Story, "queue", [{"style": "narr", "lines": [["旁白", "%s　%s" % [sid, J.str(st.name)]]]}, go])
	else: go.call()

# ---------------- 結算 ----------------
static func _pick(arr) -> String:
	var a: Array = arr
	return J.str(a[int(floor(randf() * a.size()))])

static func finish(win, quit = null, timeout = null) -> void:
	var S = _S()
	var w = J.t(win); var q = J.t(quit); var to = J.t(timeout)
	B["result"] = {"win": win}; _snd("win" if w else "lose")
	var dead_minions = 0
	for u in B.units: if J.t(u.get("minion")) and _nn(u, "hp") <= 0 and _nn(u, "side") == 0 and u.get("ml") == null: dead_minions += 1   # [militia] 只計陰兵（遊魂兵、敵方嘍囉另計）
	var ml_lost = load("res://game/militia/ml_data.gd").battle_loss(B)   # [militia]
	var lost = minf(J.num(S.res.troops), dead_minions * 25)
	S.res["troops"] = maxf(0.0, J.num(S.res.troops) - lost)
	var st = B.stage; var sid = J.str(B.sid); var first = w and not J.t(S.cleared.get(sid))
	var rew = {}; var txt = ""
	if w:
		var p = J.num(st.p)
		if first: rew = {"coins": 60 * p + 40, "exp": 30 * p + 40, "chest": ["g", "b", "p"][int(J.num(B.si))] if B.get("si") != null and int(J.num(B.si)) < 3 and int(J.num(B.si)) >= 0 else null}
		else: rew = {"coins": 20 * p, "exp": 8 * p}
		if _nn(B, "coinsWon") != 0: rew["coins"] = J.num(rew.coins) + J.num(B.coinsWon)
		S.cleared[sid] = true; txt = J.str(J.cl(_g("give"), null, [rew]))
	var GP = _g("GP")
	var box = _el("#b-result")
	var h = "<div class=\"br %s\"><h2>%s</h2>\n      " % ["win" if w else "lose", ("首次通關！" if first else "勝利") if w else ("撤退" if q else ("時間到" if to else "戰敗"))]
	if w: h += "<p class=\"quip\">%s</p><p>%s</p>" % [_pick(_g("WIN_QUIPS")), txt]
	else:
		h += ("" if q else "<p class=\"quip\">%s</p>" % _pick(_g("LOSE_QUIPS")))
		h += "<p>%s</p>" % ("" if q else "提示：換上嚇法對得上的陣容（看敵人怕什麼）；先嚇到敵人失神，再接另一種他怕的，打出連嚇。")
	h += "\n      " + (("<p class=\"lost\">陰兵戰死 %d</p>" % int(floor(lost))) if lost != 0 else "")
	if ml_lost != "": h += "<p class=\"lost\">%s</p>" % ml_lost   # [militia]
	var team_g = []
	for id in S.team: team_g.append(_gbi(id))
	h += "\n      " + (J.str(J.mc(GP, "failHTML", [J.mc(GP, "avg", [team_g]), J.mc(GP, "stageNeed", [st, sid])])) if not w and not q else "")
	h += "\n      <button class=\"btn %swide\" id=\"b-ok\">%s</button></div>" % ["" if not w and not q else "gold ", "繼續" if w and first and J.t(st.get("after")) else "回村子"]
	J.sp(box, "innerHTML", h)
	J.mc(J.gp(box, "classList"), "add", ["on"])
	J.mc(GP, "bindBack", [box, func(_t, _a):
		var ok = _el("#b-ok")
		if ok != null: J.cl(J.gp(ok, "onclick"), ok, [])])
	var okb = _el("#b-ok")
	J.sp(okb, "onclick", func(_t, _a): _on_ok(box, first, st, sid))
	J.cl(_g("save"), null, [])

static func _on_ok(box, first: bool, st, sid: String) -> void:
	J.mc(J.gp(box, "classList"), "remove", ["on"]); B["active"] = false
	var be = _el("#battle")
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])
	var Story = _g("Story"); var jg = _g("joinGhost")
	if first and J.t(st.get("wild")):
		if _g("N30W") != null: J.mc(_g("N30W"), "onWin", [st])
	elif first:
		var afters: Array = (st.get("after") if st.get("after") is Array else []).duplicate()
		if sid == "6-2":
			J.mc(Story, "queue", ["ch6_wuchang", func(_t = null, _a = null): J.cl(jg, null, ["baiwu"]); J.cl(jg, null, ["heiwu"])])
			J.mc(Story, "queue", ["ch6_mengpo", func(_t = null, _a = null): J.cl(jg, null, ["mengpo"])])
		elif sid == "6-3":
			J.mc(Story, "queue", ["ch6_end"]); J.mc(Story, "queue", ["ch6_reboot", func(_t = null, _a = null): _S()["ended"] = true]); J.mc(Story, "queue", ["epilogue"])
		else:
			for i in afters.size():
				var id = afters[i]; var ii = i
				J.mc(Story, "queue", [id, func(_t = null, _a = null):
					if ii == 0 and st.get("join") is Array:
						for k in st.join: J.cl(jg, null, [k])
					if GIFT_REWARD.has(J.str(id)): J.mc(_g("Fx"), "toast", ["媽媽燒來的禮物：" + J.str(J.cl(_g("give"), null, [GIFT_REWARD[J.str(id)].duplicate()]))])])
	if not J.t(J.mc(Story, "busy", [])): J.mc(_g("Sound"), "setMode", ["village"])
	J.mc(_g("Quest"), "check", []); J.cl(_g("save"), null, []); J.mc(_g("UI"), "refresh", [])

# ---------------- 繪圖（交俾 BtDraw；Godot 戰場由 BtRun 畫） ----------------
static func _col(c) -> Color: return Color(J.str(c)) if c is String else Color.WHITE

func run(_env) -> void:
	B = {
		"active": false, "units": [], "fx": [], "t": 0.0, "speed": 1.0, "auto": false, "stage": null, "sid": "", "result": null,
		"CAST": CAST, "WIND": WIND, "STRIKE": STRIKE, "REC": REC, "IMPACT": IMPACT, "PSPD": PSPD,
		"init": func(_t, _a): init(); return null,
		"syncBtns": func(_t, _a): sync_btns(); return null,
		"sidOf": func(_t, a): return sid_of(J.arg(a, 0), J.arg(a, 1)),
		"stageOpen": func(_t, a): return stage_open(J.arg(a, 0), J.arg(a, 1)),
		"openSelect": func(_t, _a): open_select(); return null,
		"pickSlot": func(_t, a): pick_slot(J.arg(a, 0)); return null,
		"tryStart": func(_t, a): try_start(J.arg(a, 0), J.arg(a, 1)); return null,
		"mkGhostUnit": func(_t, a): return mk_ghost_unit(J.arg(a, 0), J.arg(a, 1)),
		"start": func(_t, a): start(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"resize": func(_t, _a): resize(); return null,
		"buildCards": func(_t, _a): build_cards(); return null,
		"enemiesOf": func(_t, a): return enemies_of(J.arg(a, 0)),
		"nearest": func(_t, a): return nearest(J.arg(a, 0)),
		"stateOf": func(_t, a): return state_of(J.arg(a, 0)),
		"hitStopFor": func(_t, a): hit_stop_for(J.num(J.arg(a, 0)), J.t(J.arg(a, 1))); return null,
		"kick": func(_t, a): kick(J.num(J.arg(a, 0))); return null,
		"hit": func(_t, a): return hit(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.arg(a, 3)),
		"doSkill": func(_t, a): do_skill(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"beginCast": func(_t, a): begin_cast(J.arg(a, 0)); return null,
		"tickCast": func(_t, a): return tick_cast(J.arg(a, 0), J.num(J.arg(a, 1)), J.arg(a, 2)),
		"fireCast": func(_t, a): fire_cast(J.arg(a, 0)); return null,
		"cast": func(_t, a): cast(J.arg(a, 0)); return null,
		"castCombo": func(_t, _a): cast_combo(); return null,
		"fireCombo": func(_t, _a): fire_combo(); return null,
		"uy": func(_t, a): return uy(J.arg(a, 0)),
		"scaleOf": func(_t, a): return scale_of(J.arg(a, 0)),
		"period": func(_t, a): return period(J.arg(a, 0)),
		"leadOf": func(_t, a): return lead_of(J.arg(a, 0), J.arg(a, 1)),
		"lungeOf": func(_t, a): return lunge_of(J.arg(a, 0)),
		"stepAnim": func(_t, a): step_anim(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"fire": func(_t, a): fire(J.arg(a, 0), J.arg(a, 1)); return null,
		"stepProj": func(_t, a): step_proj(J.num(J.arg(a, 0))); return null,
		"spark": func(_t, a): spark(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.str(J.arg(a, 3))); return null,
		"dust": func(_t, a): dust(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.num(J.arg(a, 2))); return null,
		"update": func(_t, a): update(J.num(J.arg(a, 0))); return null,
		"visTick": func(_t, a): vis_tick(J.arg(a, 0), J.num(J.arg(a, 1))); return null,
		"finish": func(_t, a): finish(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"poseOf": func(_t, a): return BtDraw.pose_of(B, J.arg(a, 0)),
		"draw": func(_t, _a): return null,
		"drawText": func(_t, a): BtDraw.draw_text(J.arg(a, 0), J.arg(a, 1)); return null,
		"drawSpark": func(_t, a): BtDraw.draw_spark(J.arg(a, 0), J.arg(a, 1)); return null,
		"drawSlash": func(_t, a): BtDraw.draw_slash(J.arg(a, 0), J.arg(a, 1)); return null,
		"drawDust": func(_t, a): BtDraw.draw_dust(J.arg(a, 0), J.arg(a, 1)); return null,
		"drawProj": func(_t, a): BtDraw.draw_proj(J.arg(a, 0), J.arg(a, 1)); return null,
		"drawCharge": func(_t, a): BtDraw.draw_charge(J.arg(a, 0), _nn(B, "t"), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), _col(J.arg(a, 5)), J.t(J.arg(a, 6))); return null,
	}
	J.G["Battle"] = B
	J.G["GIFT_REWARD"] = GIFT_REWARD.duplicate(true)
	J.G["__BT_ATK"] = {"windup": 1.0, "strike": 1.0, "follow": 1.0, "recover": 1.0}
	J.G["__btDC"] = func(_t, a): BtDraw.draw_char(J.arg(a, 0), J.str(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5) if J.arg(a, 5) is Dictionary else {}); return null
