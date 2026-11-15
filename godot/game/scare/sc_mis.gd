# 回陽間：美美（office.js drawMis）逐行移植做原生：自拍、整指甲、影印、撥頭髮、反白眼、貓步、嚇到飛晒啲嘢
# 原點 = 腳底，身體縮放已經套咗（ScNpc.draw 叫）。回傳 true = 畫好咗；false = 交返一般網格動作
class_name ScMis
extends RefCounted

static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func ss(t: float) -> float: t = cl(t); return t * t * (3 - 2 * t)
static func bump(t: float, a: float, m: float, b: float) -> float:
	if t <= a or t >= b: return 0.0
	return ss((t - a) / (m - a)) if t < m else 1 - ss((t - m) / (b - m))
static func rnd(s: float) -> float: var x = sin(s * 127.1 + 311.7) * 43758.5453; return x - floor(x)
static func _n(v, d := 0.0) -> float: return J.num(v) if v != null else d

const C_TXT_O := Color("#1a1020")
const C_TXT := Color("#fff3d0")
static func text(ctx: Ctx, x: float, y: float, s: String, sz: float, a: float) -> void:
	if a <= 0.01: return
	ctx.save(); ctx.globalAlpha *= cl(a); ctx.font = "900 %dpx sans-serif" % int(round(sz)); ctx.textAlign = "center"; ctx.textBaseline = "alphabetic"
	ctx.lineWidth = 3; ctx.strokeStyle = C_TXT_O; ctx.strokeText(s, x, y); ctx.fillStyle = C_TXT; ctx.fillText(s, x, y); ctx.restore()

static func _part(ctx: Ctx, key: String, H: float, pose: Dictionary, right: bool) -> bool:
	if not Spr.ok(key) or not Spr.ok("npc_mis"): return false
	var h = H * Spr.h(key) / Spr.h("npc_mis")
	return MeshAnim.draw(ctx, key, 0, 0, h, pose, right)

# office.js 開頭先俾 JS 嗰邊嘅 MeshAnim 加小晴、美美三張圖嘅骨架；原生嗰邊照抄一份（唔使每次經 JS 版畫）
const JS_RIGS := ["npc_it", "npc_mis", "npc_mis_walk", "npc_mis_selfie"]
static var _rigs_ok := false
static func ensure_rigs() -> void:
	if _rigs_ok: return
	var JR = J.gp(J.G.get("MeshAnim"), "RIG")
	if not (JR is Dictionary): return
	_rigs_ok = true
	for id in JS_RIGS:
		var r = JR.get(id)
		if not MeshAnim.RIG.has(id) and r is Dictionary and r.get("bones") is Array: MeshAnim.RIG[id] = {"bones": r.bones}
# 開場前建好網格（第一次畫唔使卡）
static func prewarm() -> void:
	ensure_rigs()
	var ctx = Ctx.new(Recorder.new())
	for id in ["npc_mis", "npc_mis_walk", "npc_mis_selfie"]:
		if MeshAnim.has(id): MeshAnim.draw(ctx, id, 0, 0, 60, MeshAnim.idle(0), true)
	if Spr.ok("npc_mis_jump"): Spr.get_tex("npc_mis_jump")

static func draw(ctx: Ctx, Sc: Dictionary, n: Dictionary, o: Dictionary, hh: float, right: bool, t: float) -> bool:
	ensure_rigs()
	var s = n.get("mis")
	if not (s is Dictionary): return false
	var H = hh * 62 / (64 * 1.08); var fx = 1.0 if right else -1.0
	var phone = null   # 先見到自拍鏡頭入面多咗一張臉（0.8 秒），先至嚇到跳起
	var FX = Sc.get("fx")
	if FX is Array:
		for f in FX:
			if f is Dictionary and J.str(f.get("kind")) == "phone" and f.get("n") == n and _n(f.get("life")) > 0.8: phone = f; break
	var run = J.t(o.get("run"))
	if phone != null and not run:   # 鬼騷擾佢自拍：鏡頭雜訊＋畫面多咗一張臉
		_part(ctx, "npc_mis_selfie", H, MeshAnim.idle(t), right)
		var px = -fx * H * 0.17; var py = -H * 0.83
		ctx.save(); ctx.globalAlpha *= 0.5 + 0.5 * randf()
		var pr := Art.portrait_region("afu")
		if pr.size() == 2:
			var sz = H * 0.16; var r: Rect2 = pr[1]
			ctx.drawImage(pr[0], r.position.x, r.position.y, r.size.x, r.size.y, px - sz / 2 + (randf() - 0.5) * 3, py - sz / 2, sz, sz)
		for i in 5:
			ctx.fillStyle = Color(1, 60 / 255.0, 120 / 255.0, 0.6) if randf() < 0.5 else Color(80 / 255.0, 220 / 255.0, 1, 0.6)
			ctx.fillRect(px - H * 0.08, py - H * 0.08 + randf() * H * 0.16, H * 0.16, 1.5)
		ctx.restore(); return true
	var fage = -1.0   # 嚇跑嗰下（鬼出手 → 衝出去之前）
	if J.t(n.get("fleeing")) and n.get("fleeT") != null: fage = _n(Sc.get("t")) - _n(n.fleeT) - (_n(n.get("fleeHold")) - 0.4)
	var jt = _n(s.get("jumpT"), -1.0)
	var pose = J.str(o.get("pose")); var rxk = J.str(o.get("rxk"))
	if (fage >= 0 and fage < 0.55) or (not J.t(n.get("fleeing")) and jt >= 0 and jt < 1.3 and (pose == "startle" or rxk == "startle" or rxk == "weakjump" or rxk == "burst")):
		var key = "npc_mis_jump"
		if not Spr.ok(key): return false
		var q = fage if fage >= 0 else jt; var up = sin(minf(1, q / 0.6) * PI) * 0.12 * H; var sq = 0.9 if q < 0.08 else 1 + 0.06 * sin(minf(1, q / 0.6) * PI)
		var im := Spr.get_tex(key); var h = H * im.get_height() / Spr.h("npc_mis"); var w = h * im.get_width() / im.get_height()
		ctx.save(); ctx.translate((randf() - 0.5) * 2, -up); ctx.scale(1 / sq, sq); ctx.scale(-fx, 1)   # 原圖面向左
		ctx.drawImage(im, -w * 0.58, -h, w, h)
		var k = minf(1.2, q * 1.3); var cx = -w * 0.58 + w * 0.06; var cy = -h + h * 0.56
		ctx.fillStyle = Color(250 / 255.0, 225 / 255.0, 205 / 255.0, maxf(0, 0.6 - q * 0.45))
		for i in 10:
			var a = PI * (0.75 + rnd(i) * 0.6); var r = H * (0.05 + 0.3 * k * (0.5 + rnd(i + 4)))
			ctx.beginPath(); ctx.arc(cx + cos(a) * r, cy + sin(a) * r + 0.3 * H * k * k * rnd(i + 7), H * (0.02 + 0.03 * k), 0, PI * 2); ctx.fill()
		for i in 8:
			var vx = -(0.1 + rnd(i + 11) * 0.4) * H; var vy = -(0.2 + rnd(i + 13) * 0.35) * H; var px = -w * 0.2 + vx * k; var py = -h * 0.75 + vy * k + 0.8 * H * k * k
			ctx.fillStyle = Color(1, (180 + (i % 3) * 30) / 255.0, 220 / 255.0, maxf(0, 1 - q / 1.3)); ctx.save(); ctx.translate(px, py); ctx.rotate(t * 8 + i); ctx.fillRect(-H * 0.01, -H * 0.01, H * 0.02, H * 0.02); ctx.restore()
		ctx.restore(); return true
	if run or J.t(o.get("walk")):   # 貓步：屁股左右擺、成個人左右晃、細細彈；逃跑時跑到東歪西倒
		var sp = 13.0 if run else 7.0; var ph = t * sp; var bob = absf(sin(ph)) * H * (0.04 if run else 0.015); var sway = sin(ph) * H * (0.01 if run else 0.025)
		var pz = {"hips": sin(ph) * 0.09, "body": -sin(ph) * 0.06 + (0.12 if run else 0.0), "head": sin(ph) * 0.04, "legF": sin(ph) * 0.18, "legB": -sin(ph) * 0.18, "armB": sin(ph - 0.8) * 0.18, "armF": -sin(ph) * 0.08, "hairR": sin(ph - 1.2) * 0.12, "y": 0.0}
		ctx.save(); ctx.translate(sway, -bob); var r2 = _part(ctx, "npc_mis_walk", H, pz, right); ctx.restore(); return r2
	if _n(n.get("fear")) >= 25 or J.t(n.get("rx")): return false   # 驚、震……：交返一般網格動作
	var at = _n(s.get("at")); var dur = _n(s.get("dur")); var e = ss(at / 0.35) * ss((dur - at) / 0.35)
	var pz: Dictionary = MeshAnim.idle(t); pz.armF = 0.0; pz.armB = 0.0
	match J.str(s.get("act")):
		"selfie":
			var p2 = pz.duplicate(); p2.head = 0.05 * sin(at * 2) * e; p2.body = -0.03 * e; p2.armB = 0.06 * sin(at * 7) * e
			_part(ctx, "npc_mis_selfie", H, p2, right)
			if fmod(at, 1.1) < 0.12 and at > 0.6:
				var px = -fx * H * 0.17; var py = -H * 0.83
				ctx.save(); var g = ctx.createRadialGradient(px, py, 0, px, py, H * 0.25); g.addColorStop(0, Color(1, 1, 1, 0.9)); g.addColorStop(1, Color(1, 1, 1, 0))
				ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, H * 0.25, 0, PI * 2); ctx.fill(); ctx.restore()
				text(ctx, px, py - H * 0.12, "咔嚓", H * 0.08, 1)
			return true
		"nails":
			var wig = sin(at * 9) * bump(at, 0.6, 1.0, dur - 0.6)
			pz.head = (0.06 + 0.02 * sin(at * 1.5)) * e; pz.armF = (-0.06 + 0.05 * wig) * e; pz.hips = 0.03 * e; _part(ctx, "npc_mis", H, pz, right)
			if sin(at * 2.5) > 0.6:
				var sx = -fx * H * 0.35; var sy = -H * 0.86
				ctx.save(); ctx.strokeStyle = Color(1, 240 / 255.0, 170 / 255.0, 0.9); ctx.lineWidth = 1.6; ctx.beginPath(); ctx.moveTo(sx - 5, sy); ctx.lineTo(sx + 5, sy); ctx.moveTo(sx, sy - 5); ctx.lineTo(sx, sy + 5); ctx.stroke(); ctx.restore()
			return true
		"copy":   # 喺崗位影印：手伸去撳影印機，影印機亮
			var tap = bump(fmod(at, 1.6), 0.2, 0.4, 0.7); pz.armF = (-0.12 - 0.06 * tap) * e; pz.body = 0.03 * e; pz.head = 0.06 * e; _part(ctx, "npc_mis", H, pz, right)
			if at > 0.5:
				var S = ScOffice.st()
				if S is Dictionary and S.get("copier") is Dictionary: S.copier["idle"] = maxf(_n(S.copier.get("idle")), 0.4)
			return true
		"hair":
			var k = e * bump(at, 0.1, 0.6, 2.2); var sw = sin(at * 8) * bump(at, 0.4, 0.8, 1.8)
			pz.head = -0.12 * k + 0.04 * sw; pz.hairR = -0.3 * k + 0.12 * sw; pz.body = -0.03 * k; pz.armB = -0.1 * k; _part(ctx, "npc_mis", H, pz, right); return true
		"roll":   # 反白眼：頭向後一仰、轉開，「哼」
			var k = bump(at, 0.1, 0.4, 1.6); pz.head = -0.16 * k; pz.body = -0.04 * k; pz.hairR = -0.15 * k; _part(ctx, "npc_mis", H, pz, right)
			text(ctx, -fx * H * 0.3, -H * 1.02, "哼", H * 0.11, bump(at, 0.2, 0.4, 1.4))
			ctx.save(); ctx.strokeStyle = Color(40 / 255.0, 30 / 255.0, 60 / 255.0, 0.8 * k); ctx.lineWidth = 1.5
			for i in 3:
				var bx = fx * H * 0.12 + i * 4; ctx.beginPath(); ctx.moveTo(bx, -H * 0.95); ctx.lineTo(bx, -H * 0.88); ctx.stroke()
			ctx.restore(); return true
	_part(ctx, "npc_mis", H, pz, right); return true
