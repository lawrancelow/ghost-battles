# 原生改寫自 n30_rigs.js（新鬼原圖變形骨架＋走路／待機方式＋拆件身體）
# DEF 資料由補丁後原碼倒出：data/n30_rigs_def.json；拆件（cutBody）用原生 BtN30.cut_body
extends RefCounted

static var DEF: Dictionary = {}

static func S(x: float) -> float: return sin(x)
static func n(pz: Dictionary, k: String, d := 0.0) -> float: return J.num(pz[k]) if pz.get(k) != null and J.t(pz[k]) else d

# 走路／待機方式：喺 MeshAnim 嘅姿勢上加料（改 pz 本身）
static func tweak(d: Dictionary, pz: Dictionary, o: Dictionary) -> void:
	var loco = J.str(d.get("loco")) if J.t(d.get("loco")) else "walk"
	var sec = d.get("sec") if d.get("sec") is Dictionary else {}
	var t = J.num(o.get("t")) if J.t(o.get("t")) else 0.0
	var ps = o.get("pose")
	var walking = J.t(o.get("walk")) or J.str(ps) in ["move", "walk", "run"]
	var idle = not walking and (not J.t(ps) or J.str(ps) == "idle")
	if not walking and not idle: return
	var A = J.gp(J.G.get("MeshAnim"), "ANIM")   # 同 JS 一樣用全局 MeshAnim.ANIM
	var walkf = func(x: float) -> Dictionary: return J.cl(A.walk, null, [x])
	for b in sec:
		var s = sec[b]
		pz[b] = n(pz, b) + S(t * J.num(s[1]) + J.num(s[2])) * J.num(s[0]) * (1.6 if walking else 1.0)
	match loco:
		"float":
			pz.legF = 0.0; pz.legB = 0.0
			if walking: pz.body = 0.14; pz.armF = S(t * 3) * 0.08; pz.armB = -S(t * 3) * 0.08; pz.y = -0.03 - S(t * 3) * 0.02; pz.tail1 = -0.25 + S(t * 4) * 0.12; pz.tail2 = -0.35 + S(t * 4 - 1) * 0.2; pz.rot = 0.04
			else: pz.x = S(t * 0.8) * 0.012; pz.rot = S(t * 1.1) * 0.025
		"onefoot", "bottle":
			var f = 4.5 if loco == "bottle" else 5.5; var ph = fmod(t * f, PI); var up = S(ph); var land = 1 - ph / 0.35 if ph < 0.35 else 0.0
			if walking: pz.y = -0.02 - up * 0.10; pz.sy = 1 - land * 0.08 + up * 0.03; pz.sx = 1 + land * 0.06; pz.body = 0.05; pz.legB = 0.0; pz.legF = 0.1; pz.armF = up * 0.25; pz.armB = -up * 0.25
			else:
				var b2 = absf(S(t * 2.2)); pz.y = -0.01 - b2 * 0.02; pz.sy = 1 + b2 * 0.015; pz.legB = 0.0; pz.legF = 0.0
		"stride":
			if walking:
				var w = walkf.call(t * 0.62)
				pz.legF = w.legF * 0.42; pz.legB = w.legB * 0.42; pz.armF = w.armF * 1.2; pz.armB = w.armB * 1.2; pz.body = 0.06; pz.head = S(t * 4.34) * 0.05; pz.y = -absf(S(t * 4.34)) * 0.03; pz.rot = S(t * 4.34) * 0.03
			else: pz.body = S(t * 0.9) * 0.03
		"neck":
			pz.neck1 = S(t * 1.1) * 0.10 * (1.6 if walking else 1.0); pz.neck2 = S(t * 1.1 - 0.9) * 0.18 * (1.5 if walking else 1.0); pz.head = n(pz, "head") - S(t * 1.1 - 1.6) * 0.10
			if walking: pz.legF = 0.0; pz.legB = 0.0; pz.y = -absf(S(t * 6)) * 0.012
		"heavy":
			if walking:
				var w = walkf.call(t * 0.6)
				pz.legF = w.legF * 1.1; pz.legB = w.legB * 1.1; pz.armF = w.armF * 0.8; pz.armB = w.armB * 0.8; pz.rot = S(t * 4.2) * 0.05; pz.y = -absf(S(t * 4.2)) * 0.03; pz.body = 0.06
			else: pz.rot = S(t * 0.9) * 0.015; pz.sy = n(pz, "sy", 1.0) + S(t * 1.2) * 0.012
		"skitter":
			if walking: pz.legF = S(t * 22) * 0.18; pz.legB = S(t * 11) * 0.10; pz.y = -absf(S(t * 11)) * 0.05; pz.body = 0.0
			else: pz.legF = S(t * 9) * 0.03; pz.hairL = S(t * 3) * 0.12; pz.hairR = S(t * 3 + 1) * 0.12
		"creep":
			if walking:
				var w = walkf.call(t * 0.8)
				pz.legF = w.legF; pz.legB = w.legB; pz.body = 0.16; pz.head = 0.06 + S(t * 5.6) * 0.04; pz.y = -absf(S(t * 5.6)) * 0.015
		"drunk":
			pz.rot = S(t * 1.3) * 0.07 + S(t * 2.9) * 0.03; pz.x = S(t * 0.9) * 0.02; pz.head = n(pz, "head") + S(t * 1.7) * 0.08
			if walking: pz.rot += S(t * 3.5) * 0.08
		"shiver":
			pz.x = n(pz, "x") + S(t * 47) * 0.005; pz.head = n(pz, "head") + S(t * 39) * 0.02
			if walking: pz.body = -0.04; pz.y = -absf(S(t * 9)) * 0.02
		"twitch":
			var q = fmod(t * 0.9, 1.0); var j = S(q * 120) if q > 0.85 else 0.0
			pz.x = n(pz, "x") + j * 0.012; pz.head = n(pz, "head") + j * 0.08; pz.armF = n(pz, "armF") + j * 0.15; pz.armB = n(pz, "armB") - j * 0.15
			if walking:
				var w = walkf.call(t)
				pz.legF = w.legF * 0.8; pz.legB = w.legB * 0.8
		"laugh":
			pz.body = n(pz, "body") + 0.05 + absf(S(t * 9)) * 0.05; pz.head = n(pz, "head") + absf(S(t * 9)) * 0.08; pz.y = n(pz, "y") - absf(S(t * 9)) * 0.01
		"paper":
			pz.legF = 0.0; pz.legB = 0.0; var k = 1.0 if walking else 0.35
			pz.sy = 1 + S(t * (6.0 if walking else 2.0)) * 0.08 * k; pz.rot = S(t * (6.0 if walking else 2.0) + 1) * 0.08 * k; pz.y = -0.02 - (absf(S(t * 6)) * 0.06 if walking else 0.0); pz.armF = S(t * 3) * 0.15 * k; pz.armB = -S(t * 3) * 0.15 * k
		"flee":
			if walking:
				var w = walkf.call(t * 1.6)
				pz.legF = w.legF * 1.2; pz.legB = w.legB * 1.2; pz.armF = w.armF * 1.4; pz.armB = w.armB * 1.4; pz.y = -absf(S(t * 11)) * 0.03
			else: pz.y = n(pz, "y") - absf(S(t * 4)) * 0.01; pz.armF = n(pz, "armF") + S(t * 4) * 0.05
		"stumble":
			if walking:
				var q = fmod(t * 0.7, 1.0); var lurch = S((q - 0.8) / 0.2 * PI) if q > 0.8 else 0.0
				pz.rot = 0.04 + lurch * 0.18; pz.body = n(pz, "body") + lurch * 0.2; pz.armF = n(pz, "armF") - lurch * 0.6; pz.armB = n(pz, "armB") + lurch * 0.5

static func ids() -> Array:
	var o = []
	for k in DEF: o.append("n30_" + k)
	return o

# 拆件身體：原生 BtN30.cut_body 砌貼圖；同時擺入 JS 嘅 SPR（同 n30_rigs.js 一樣）
static func cut_body(id: String, pieces: Array, key: String):
	var r = BtN30.cut_body(id, pieces, key)
	if r == null: return null
	var SP = J.G.get("SPR")
	if SP is Object: SP.set(key, Spr._tex.get(key, Spr.get_tex(key)))
	var JR = J.gp(J.G.get("MeshAnim"), "RIG")
	if JR is Dictionary and JR.has(id): JR[key] = JR[id]
	return key

static func body(id: String):
	var d = DEF.get(id.substr(4))
	if not (d is Dictionary) or not J.t(d.get("cut")): return null
	return cut_body(id, d.cut, id + "__nb")

func run(_env) -> void:
	DEF = JSON.parse_string(FileAccess.get_file_as_string("res://data/n30_rigs_def.json"))
	var MAg = J.G.get("MeshAnim"); var RIG = J.gp(MAg, "RIG"); var NR = J.gp(MAg, "NATIVE_R")
	var ART = J.G.get("ART"); var CH = J.gp(ART, "CHAR_H"); var SO = J.gp(ART, "SOLID")
	for k in DEF:
		var d = DEF[k]; var id = "n30_" + k; var r = d.rig
		var R
		if J.t(r.get("bones")):
			var legs = false
			for b in r.bones: if J.str(b[0]) == "legF": legs = true; break
			R = {"bones": r.bones, "legs": legs}
		else: R = J.mc(MAg, "mk", [r])
		if J.t(r.get("x")): R["bones"] = (R.bones as Array) + (r.x as Array)
		var dd = d
		R["tweak"] = func(_t, a): tweak(dd, a[0], a[1] if a.size() > 1 and a[1] is Dictionary else {}); return null
		RIG[id] = R
		if J.t(d.get("nr")): NR[id] = 1.0
		CH[id] = d.h
		if J.t(d.get("solid")): SO[id] = 1.0
	J.G["N30"] = {
		"DEF": DEF, "IDS": ids(),
		"body": func(_t, a): return body(J.str(J.arg(a, 0))),
		"cutBody": func(_t, a): return cut_body(J.str(a[0]), a[1], J.str(a[2])),
		"name": func(_t, a):
			var d = DEF.get(J.str(J.arg(a, 0)).trim_prefix("n30_"))
			return d.get("zh") if d is Dictionary else null,
	}
