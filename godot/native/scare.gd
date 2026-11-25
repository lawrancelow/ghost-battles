# 原生改寫自 scare.js（回陽間・夜班嚇人主體）——分段進行（同 L2 game／L3 street 一樣做法）
# 做法：先跑轉譯版（jsgen/scare.gd）建好全部全局（Scare、SCARE_PROPS、SCARE_SITES…），再逐段將 Scare 嘅方法換成原生版本。
#   第一段（呢度）：鏡頭／座標（viewW、clampCam、camRoom、roomOf、sameRoom、onScreen、bgScale、pt、depth、persp、bgAR、hhF、hh、office）、
#                  星星（migrate、starsOf）、班表隨機數（rng、U、rnd）、位置判斷（exitPt、present、sitting、viaElev、inDoor、walkBlocked、busy、freeSpot）、
#                  視線（tagExt、inBeam、groupRoom、inGroup、propOK、gpq、ghostType、headsDown、watching、sees、witnesses、hearers、workOf）
#   第二段：每幀 step、bubble、走動 moveNpc、班表 shiftInit／planMove／planNext／bossCall…、出入電梯、穿崩 expose／expoTick、道士 daoTick、jumpy
#   第三段：出招 useProp／usePhone／useBreath／useGhost、hit、perceive
#   第四段：tap、renderDock、renderTarget、profile、peek、hud、floatTick／float／floatOld／toast、dust、propParts
#   第五段：react、animNpc、onReact、rigOK、visPos、npcPose
#   第六段：畫 draw、drawEdge、drawBreath、propMarks、drawCue、drawNpc、drawNpcSprite、npcFx、drawTeam、drawGhost、drawBubble
#   第七段：開局／收工 open、start、resize、bindPan、camTick、frame、finish
#   全部方法都改寫咗；轉譯版只係仲負責建全局資料（SCARE_PROPS、SCARE_SITES…）同道士骨架設定
# 規矩：方法一律掛返喺 Scare 物件上面（func(this_, a)），轉譯版其他方法經 J.mc(this, …) 叫到原生版
extends RefCounted

const PI := 3.141592653589793
const PANO_ZOOM := 0.72
const SEE_DIST := 0.7
static var _trans = null
static var ORIG := {}   # 覆蓋之前嘅轉譯版方法（對照測試用）
static var NAT := {}    # 原生方法（未經其他模塊包裝；對照測試用）

static func _g(n: String): return J.G.get(n)
static func n_(v) -> float: return J.num(v)
static func or_(v, d: float) -> float: return J.num(v) if J.t(v) else d
static func gp(o, k): return J.gp(o, k)
static func hyp(a: float, b: float) -> float: return sqrt(a * a + b * b)
static func jround(x: float) -> float: return floor(x + 0.5)
static func OM(): return _g("OFFMAP")
static func room_at(x): return J.cl(J.gp(OM(), "roomAt"), null, [x])
static func A_(o) -> Array: return o if o is Array else J.iter(o)
static func npcs(Sc) -> Array: return A_(gp(Sc, "npcs"))
static func D(n): return gp(n, "d")
static func site(Sc): return gp(Sc, "site")
static func pano(Sc) -> bool: return J.t(gp(site(Sc), "pano"))

# ---------------- 鏡頭／座標 ----------------
static func bg_scale(Sc) -> Dictionary:
	var W = or_(gp(Sc, "W"), 390.0); var H = or_(gp(Sc, "H"), 580.0)
	if J.t(site(Sc)) and pano(Sc):
		var iw = n_(gp(OM(), "PXU")); var ih = n_(gp(OM(), "SH"))
		var s = maxf(H / ih * PANO_ZOOM, W / (n_(gp(OM(), "WW")) * iw))
		return {"s": s, "iw": iw, "ih": ih, "ox": -or_(gp(Sc, "camX"), 0.0) * iw * s, "oy": H - ih * s}
	var img = J.gp(_g("SPR"), "bg_" + J.str(gp(site(Sc), "bg")))
	var iw2 = or_(gp(img, "naturalWidth"), 768.0) if J.t(img) else 768.0
	var ih2 = or_(gp(img, "naturalHeight"), 1152.0) if J.t(img) else 1152.0
	var s2 = maxf(W / iw2, H / ih2)
	return {"s": s2, "iw": iw2, "ih": ih2, "ox": (W - iw2 * s2) / 2, "oy": H - ih2 * s2}
static func view_w(Sc) -> float: var b = bg_scale(Sc); return or_(gp(Sc, "W"), 390.0) / (b.iw * b.s)
static func clamp_cam(Sc, x: float) -> float: return maxf(0.0, minf(n_(gp(OM(), "WW")) - view_w(Sc), x))
static func cam_room(Sc): return room_at(or_(gp(Sc, "camX"), 0.0) + view_w(Sc) / 2)
static func room_of(Sc, n): return gp(room_at(gp(n, "x")), "k")
static func same_room(Sc, a, b) -> bool: return not pano(Sc) or is_same(room_at(gp(a, "x")), room_at(gp(b, "x")))
static func on_screen(Sc, x: float, m = null) -> bool:
	var mm = 0.25 if m == null else n_(m); var cx = or_(gp(Sc, "camX"), 0.0)
	return x > cx - mm and x < cx + view_w(Sc) + mm
static func pt(Sc, fx: float, fy: float) -> Array:
	var b = bg_scale(Sc); return [fx * b.iw * b.s + b.ox, fy * b.ih * b.s + b.oy]
static func persp(Sc): return gp(site(Sc), "persp") if J.t(site(Sc)) else site(Sc)
static func depth(Sc, y: float) -> float:
	if J.t(site(Sc)) and J.t(gp(site(Sc), "persp")): return hh(Sc, y) / (or_(gp(Sc, "H"), 580.0) * 0.165)
	return 0.72 + 0.5 * maxf(0.0, minf(1.0, (y - 0.55) / 0.42))
static func bg_ar(Sc) -> float: var b = bg_scale(Sc); return b.ih / b.iw
static func hh_f(Sc, y: float) -> float: var p = gp(site(Sc), "persp"); return n_(gp(p, "c")) * (y - n_(gp(p, "hz")))
static func hh(Sc, y: float) -> float:
	if not J.t(persp(Sc)): return or_(gp(Sc, "H"), 580.0) * 0.165 * depth(Sc, y)
	var b = bg_scale(Sc); return b.ih * b.s * hh_f(Sc, y)
static func office(Sc) -> bool:
	return not J.t(gp(Sc, "headless")) and J.t(site(Sc)) and J.str(gp(site(Sc), "layout")) == "office" and _g("OFFICE") != null

# ---------------- 星星 ----------------
static func migrate(_Sc) -> void:
	var S = _g("S")
	if not J.t(S) or not J.t(gp(S, "scare")) or n_(gp(gp(S, "scare"), "fv")) >= 3: return
	var sc = gp(S, "scare"); var best = gp(sc, "best")
	if n_(gp(sc, "fv")) == 2:
		J.sp(sc, "fv", 3.0)
		var a = [0.0, 650.0, 1200.0, 1600.0]; var b = [0.0, 1100.0, 1300.0, 1480.0]
		for k in J.keys(best):
			var v = gp(best, k)
			if not J.t(v) or J.str(k) != "office": continue
			v = n_(v); var i = 0
			while i < 2 and v >= a[i + 1]: i += 1
			J.sp(best, k, jround(b[3] + (v - a[3]) * 0.75) if v >= a[3] else jround(b[i] + (v - a[i]) * (b[i + 1] - b[i]) / (a[i + 1] - a[i])))
		var sv = _g("save"); if sv != null: J.cl(sv, null, [])
		return
	J.sp(sc, "fv", 3.0)
	for k in J.keys(best):
		var st = gp(_g("SCARE_SITES"), k); var v = gp(best, k)
		if not J.t(st) or not J.t(gp(st, "oldStars")) or not J.t(v): continue
		v = n_(v)
		var a = [0.0] + J.iter(gp(st, "oldStars")); var b = [0.0] + J.iter(gp(st, "stars"))
		for i2 in a.size(): a[i2] = n_(a[i2])
		for i2 in b.size(): b[i2] = n_(b[i2])
		var i = 0
		while i < 2 and v >= a[i + 1]: i += 1
		J.sp(best, k, jround(b[3] + (v - a[3]) * (b[3] - b[2]) / (a[3] - a[2])) if v >= a[3] else jround(b[i] + (v - a[i]) * (b[i + 1] - b[i]) / (a[i + 1] - a[i])))
	var sv2 = _g("save"); if sv2 != null: J.cl(sv2, null, [])
static func stars_of(Sc, siteId, v) -> float:
	migrate(Sc); var s = J.iter(gp(gp(_g("SCARE_SITES"), siteId), "stars")); var x = n_(v)
	return 3.0 if x >= n_(s[2]) else (2.0 if x >= n_(s[1]) else (1.0 if x >= n_(s[0]) else 0.0))

# ---------------- 隨機數 ----------------
static func _u(a: int) -> int: return a & 0xFFFFFFFF
static func _imul(a: int, b: int) -> int: return J.i32((a * b) & 0xFFFFFFFF)
static func rng(n) -> float:
	var a: int = J.i32(n_(gp(n, "_seed")) + 0x6D2B79F5); J.sp(n, "_seed", float(a))
	var t: int = _imul(a ^ (_u(a) >> 15), 1 | a)
	t = J.i32(t + _imul(t ^ (_u(t) >> 7), 61 | t)) ^ t
	return float(_u(t ^ (_u(t) >> 14))) / 4294967296.0
static func U(n, a: float, b: float) -> float: return a + (b - a) * rng(n)
static func rnd(n) -> float: return rng(n) if gp(n, "_seed") != null else randf()

# ---------------- 位置 ----------------
static func exit_pt(Sc): var e = gp(site(Sc), "exit"); return e if J.t(e) else [0.905, 0.535]
static func present(Sc, ex) -> float:
	var c = 0
	for m in npcs(Sc):
		if not is_same(m, ex) and not J.t(gp(D(m), "guard")) and not J.t(gp(D(m), "daoshi")) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and not J.t(gp(m, "leaving")): c += 1
	return float(c)
static func sitting(Sc, n) -> bool:
	if J.t(gp(n, "gone")) or J.t(gp(n, "out")) or J.t(gp(n, "fleeing")) or J.str(gp(n, "act")) == "walk": return false
	var act = gp(n, "act")
	if J.t(act) and (J.str(act).begins_with("brk_") or J.str(act) == "notes"): return true
	var MP = _g("MIS_POST")
	return pano(Sc) and J.str(gp(D(n), "k")) == "mis" and hyp(n_(gp(n, "x")) - n_(MP[0]), n_(gp(n, "y")) - n_(MP[1])) < 0.012
static func via_elev(_Sc, _n, x: float, y: float) -> Array:
	var p = []
	var M = gp(OM(), "M"); var MY = gp(OM(), "MY")
	if y < n_(J.cl(MY, null, [0.6])) and x > n_(J.cl(M, null, [0.5])) and x < n_(J.cl(M, null, [0.86])): p.append([J.cl(M, null, [0.80]), J.cl(MY, null, [0.60])])
	return p
static func in_door(Sc, x: float) -> bool:
	if not pano(Sc): return false
	var w = n_(gp(OM(), "WALLW"))
	for v in J.iter(gp(OM(), "WALLS")):
		if x >= (n_(v) - 45) / 1165 and x <= (n_(v) + w + 45) / 1165: return true
	return false
static func walk_blocked(Sc, n, tx: float) -> bool:
	if not pano(Sc): return false
	var a = minf(n_(gp(n, "x")), tx); var b = maxf(n_(gp(n, "x")), tx)
	for r in J.iter(gp(OM(), "ROOMS")):
		if n_(gp(r, "x1")) > a and n_(gp(r, "x0")) < b + 1e-6:
			var c = 0
			for m in npcs(Sc):
				if not is_same(m, n) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and (J.str(gp(m, "act")) == "walk" or (not J.t(gp(D(m), "post")) and not J.t(gp(D(m), "daoshi")) and n_(gp(m, "wait")) < 7)) and is_same(room_at(gp(m, "x")), r): c += 1
			if c >= 2: return true
	return false
static func busy(Sc, n, tx: float) -> bool:
	if not pano(Sc): return false
	for r in [room_at(gp(n, "x")), room_at(tx)]:
		var c = 0
		for m in npcs(Sc):
			if not is_same(m, n) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and J.str(gp(m, "act")) == "walk" and is_same(room_at(gp(m, "x")), r): c += 1
		if c >= 2: return true
	return false
static func free_spot(Sc, n, x: float, y: float) -> Array:
	var occ = []
	for m in npcs(Sc):
		if is_same(m, n) or J.t(gp(m, "gone")) or J.t(gp(m, "out")) or J.t(gp(D(m), "daoshi")): continue
		occ.append([n_(gp(m, "x")), n_(gp(m, "y"))])
		var st = gp(m, "step")
		if J.t(st) and not J.t(gp(st, "arrived")): occ.append([n_(gp(st, "x")), n_(gp(st, "y"))])
		var po = gp(D(m), "post")
		if J.t(po) and not J.t(gp(D(m), "guard")): occ.append([n_(po[0]), n_(po[1])])
	var best = [x, y]
	for dx in [0.0, 0.14, -0.14]:
		var xx = x + dx; var hit = false
		for p in occ: if absf(p[0] - xx) < 0.13 and absf(p[1] - y) < 0.3: hit = true; break
		if not hit: best = [xx, y]; break
	return best

# ---------------- 視線 ----------------
static func tag_ext(Sc, n) -> float:
	return 16.0 if is_same(n, gp(Sc, "sel")) or (n_(gp(n, "mocked")) > 0 and not J.t(gp(D(n), "guard"))) else 0.0
static func in_beam(Sc, g, x: float, y: float) -> bool:
	if J.str(gp(g, "act")) == "doze": return false
	if pano(Sc) and not is_same(room_at(gp(g, "x")), room_at(x)): return false
	var dx = x - n_(gp(g, "x")); var dy = y - (n_(gp(g, "y")) - 0.08)
	if signf(dx) != n_(gp(g, "dir")): return false
	var d = absf(dx); return d < 0.4 and absf(dy) < 0.06 + d * 0.35
static func group_room(Sc):
	if not pano(Sc): return null
	if J.t(gp(Sc, "headless")): return room_of(Sc, gp(Sc, "sel")) if J.t(gp(Sc, "sel")) else "main"
	return gp(cam_room(Sc), "k")
static func in_group(Sc, m, room) -> bool: return not J.t(room) or J.seq(room_of(Sc, m), room)
static func prop_ok(Sc, k, n) -> bool:
	var p = gp(_g("SCARE_PROPS"), k)
	if J.t(gp(p, "group")):
		var rm = group_room(Sc); var pcd = gp(Sc, "pcd")
		if J.t(pcd) and n_(gp(pcd, k)) > 0: return false
		for m in npcs(Sc):
			if not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and not J.t(gp(D(m), "guard")) and in_group(Sc, m, rm): return true
		return false
	if not J.t(n) or J.t(gp(n, "gone")) or J.t(gp(n, "out")) or J.t(gp(n, "fleeing")) or J.t(gp(D(n), "guard")): return false
	var fr = gp(p, "front")
	return n_(gp(p, "r")) == 0 or hyp(n_(gp(n, "x")) - n_(fr[0]), (n_(gp(n, "y")) - n_(fr[1])) * 1.4) < n_(gp(p, "r"))
static func gpq(_Sc, k):
	var GP = _g("GP")
	if GP == null: return 1.0
	if J.str(k) == "afu":
		var S = _g("S"); if not J.t(S): return 1.0
		return J.mc(GP, "grow", [J.mc(gp(S, "ghosts"), "find", [func(_t, a): return J.str(gp(a[0], "k")) == "afu"])])
	return J.mc(GP, "kindGrow", [k])
static func ghost_type(_Sc, k, n):
	var g = gp(_g("SCARE_GHOSTS"), k); var ts = J.iter(gp(g, "types")) if J.t(gp(g, "types")) else [gp(g, "type")]
	if not J.t(n) or ts.size() < 2: return ts[0]
	var wk = J.iter(gp(D(n), "weak")); var im = J.iter(gp(D(n), "immune"))
	for t in ts: if wk.has(t): return t
	for t in ts: if not im.has(t): return t
	return ts[0]
static func heads_down(_Sc, m) -> bool:
	var a = J.str(gp(m, "act"))
	if a in ["work", "mop", "doze", "pack", "read", "notes", "present"]: return true
	var p = gp(D(m), "post")
	return J.t(p) and J.seq(gp(m, "act"), p[2]) and hyp(n_(gp(m, "x")) - n_(p[0]), n_(gp(m, "y")) - n_(p[1])) < 0.015
static func watching(Sc, m) -> bool:
	if J.t(gp(m, "gone")) or J.t(gp(m, "out")) or J.t(gp(m, "fleeing")): return false
	if J.t(gp(D(m), "guard")): return J.str(gp(m, "act")) != "doze"
	if J.t(gp(D(m), "influencer")): return true
	return J.str(gp(m, "act")) == "walk" or or_(gp(m, "lookUp"), 0.0) > 0 or n_(gp(m, "fear")) >= 25 or not heads_down(Sc, m)
static func sees(Sc, m, n) -> bool:
	if is_same(m, n) or not watching(Sc, m) or not same_room(Sc, m, n): return false
	var dx = n_(gp(n, "x")) - n_(gp(m, "x"))
	if hyp(dx, (n_(gp(n, "y")) - n_(gp(m, "y"))) * 1.3) > SEE_DIST: return false
	return dx * n_(gp(m, "dir")) >= -0.03 if (J.str(gp(m, "act")) == "walk" or J.t(gp(D(m), "guard"))) else true
static func witnesses(Sc, n) -> Array:
	var out = []
	for m in npcs(Sc): if sees(Sc, m, n): out.append(m)
	return out
static func hearers(Sc, n) -> Array:
	var out = []
	for m in npcs(Sc):
		if not is_same(m, n) and not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and same_room(Sc, m, n) and hyp(n_(gp(m, "x")) - n_(gp(n, "x")), n_(gp(m, "y")) - n_(gp(n, "y"))) < 0.75: out.append(m)
	return out
static func work_of(Sc, n):
	return [12.0, 18.0] if J.t(gp(D(n), "guard")) and J.t(gp(Sc, "alert")) else gp(D(n), "work")

# ================= 第二段：每幀、走動、班表、穿崩、道士 =================
static func F(k: String) -> float: return n_(gp(_g("FEAR"), k))
static func E(k: String) -> float: return n_(gp(_g("EXPO"), k))
static func pick(a):
	if a is Array: return a[int(floor(randf() * a.size()))]
	return a
static func mc(Sc, m: String, a: Array = []): return J.mc(Sc, m, a)
static func t_(Sc) -> float: return n_(gp(Sc, "t"))
static func hl(Sc) -> bool: return J.t(gp(Sc, "headless"))
static func _M(x: float): return J.cl(gp(OM(), "M"), null, [x])
static func _MY(y: float): return J.cl(gp(OM(), "MY"), null, [y])
static func _SP(k: String): return gp(gp(OM(), "SPOT"), k)
static func live(m) -> bool: return not J.t(gp(m, "gone")) and not J.t(gp(m, "out"))

static func bubble(Sc, n, text, dur = null, ghost = null) -> void:
	if not J.t(n) or not J.t(text): return
	if not hl(Sc) and not (J.t(gp(n, "bub")) and n_(gp(n, "bubT")) > 0):
		var c = 0
		for m in npcs(Sc): if not is_same(m, n) and J.t(gp(m, "bub")) and n_(gp(m, "bubT")) > 0 and not J.t(gp(m, "gone")): c += 1
		if c >= 2:
			var bq = []
			for q in (A_(gp(Sc, "bq")) if J.t(gp(Sc, "bq")) else []): if not is_same(gp(q, "n"), n): bq.append(q)
			bq.append({"n": n, "text": text, "dur": dur, "ghost": ghost, "at": gp(Sc, "t")})
			if bq.size() > 3: bq.pop_front()
			J.sp(Sc, "bq", bq); return
	J.sp(n, "bub", text); J.sp(n, "bubT", n_(dur) if J.t(dur) else 2.0); J.sp(n, "bubG", J.t(ghost)); J.sp(n, "bubAt", gp(Sc, "t"))

static func step(Sc, dt: float) -> void:
	J.sp(Sc, "t", t_(Sc) + dt); J.sp(Sc, "mana", minf(100.0, n_(gp(Sc, "mana")) + 7 * dt))
	var cd = gp(Sc, "cd")
	for k in J.keys(cd): J.sp(cd, k, maxf(0.0, n_(gp(cd, k)) - dt))
	var pcd = gp(Sc, "pcd")
	if J.t(pcd): for k in J.keys(pcd): J.sp(pcd, k, maxf(0.0, n_(gp(pcd, k)) - dt))
	var arr = gp(Sc, "npcs"); var i = 0
	while i < A_(arr).size():
		var n = A_(arr)[i]; move_npc(Sc, n, dt)
		if not hl(Sc): mc(Sc, "animNpc", [n, dt])
		i += 1
	if office(Sc):
		J.mc(_g("OFFICE"), "tick", [dt])
		if pano(Sc): J.mc(OM(), "tick", [dt])
	expo_tick(Sc, dt)
	if _g("ScareX") != null: J.mc(_g("ScareX"), "tick", [Sc, dt])
	var g = null
	for m in npcs(Sc): if J.t(gp(D(m), "guard")): g = m; break
	for f in A_(gp(Sc, "fx")):
		if J.t(gp(f, "ghost")) and not J.t(gp(f, "caught")) and g != null and in_beam(Sc, g, n_(gp(f, "gx")), n_(gp(f, "gy"))):
			J.sp(f, "caught", true); J.sp(gp(Sc, "caught"), gp(f, "ghost"), true); J.sp(cd, gp(f, "ghost"), 999.0); bubble(Sc, g, gp(gp(D(g), "say"), "catchG"), 2.6); mc(Sc, "react", [g, "catch"]); J.sp(f, "busted", gp(Sc, "t"))
			mc(Sc, "float", [gp(f, "gx"), n_(gp(f, "gy")) - 0.08, J.str(gp(gp(_g("SCARE_GHOSTS"), gp(f, "ghost")), "name")) + " 被請去喝茶", "#9ad"]); add_karma(Sc, D(g), 0.0, "")
			if not hl(Sc): mc(Sc, "renderDock")
	var fx2 = []
	for f in A_(gp(Sc, "fx")):
		J.sp(f, "life", n_(gp(f, "life")) - dt)
		if n_(gp(f, "life")) > 0: fx2.append(f)
	J.sp(Sc, "fx", fx2)
	var p2 = []
	for p in A_(gp(Sc, "parts")):
		if n_(gp(p, "delay")) > 0: J.sp(p, "delay", n_(gp(p, "delay")) - dt); p2.append(p); continue
		J.sp(p, "life", n_(gp(p, "life")) - dt); J.sp(p, "x", n_(gp(p, "x")) + n_(gp(p, "vx")) * dt); J.sp(p, "y", n_(gp(p, "y")) + n_(gp(p, "vy")) * dt)
		J.sp(p, "vy", n_(gp(p, "vy")) + or_(gp(p, "g"), 0.0) * dt); J.sp(p, "rot", or_(gp(p, "rot"), 0.0) + or_(gp(p, "vr"), 0.0) * dt)
		if n_(gp(p, "life")) > 0: p2.append(p)
	J.sp(Sc, "parts", p2)
	if not hl(Sc):
		var bq = gp(Sc, "bq")
		if J.t(bq) and A_(bq).size():
			var c = 0
			for m in npcs(Sc): if J.t(gp(m, "bub")) and n_(gp(m, "bubT")) > 0 and not J.t(gp(m, "gone")): c += 1
			if c < 2:
				while A_(bq).size():
					var q = A_(bq).pop_front()
					if t_(Sc) - n_(gp(q, "at")) < 4 and not J.t(gp(gp(q, "n"), "gone")) and not J.t(gp(gp(q, "n"), "out")): bubble(Sc, gp(q, "n"), gp(q, "text"), gp(q, "dur"), gp(q, "ghost")); break
	J.sp(Sc, "shake", maxf(0.0, n_(gp(Sc, "shake")) - dt * 2.2)); J.sp(Sc, "vign", maxf(0.0, n_(gp(Sc, "vign")) - dt * 1.2))
	if J.t(gp(Sc, "expelled")):
		if not J.t(gp(Sc, "kpiCut")): J.sp(Sc, "kpiCut", true); J.sp(Sc, "kpi", jround(n_(gp(Sc, "kpi")) * E("expelMul")))
		if hl(Sc): J.sp(Sc, "active", false)
		elif t_(Sc) - n_(gp(Sc, "endAt")) > 2.6: mc(Sc, "finish", [false])
		return
	var all_gone = true
	for n in npcs(Sc):
		if not (J.t(gp(n, "gone")) or J.t(gp(D(n), "guard")) or (J.t(gp(n, "left")) and J.t(gp(n, "out")))): all_gone = false; break
	if t_(Sc) >= n_(_g("NIGHT_SEC")) or all_gone:
		if hl(Sc): J.sp(Sc, "active", false)
		elif t_(Sc) >= n_(_g("NIGHT_SEC")): mc(Sc, "finish", [false])
		else:
			if not J.t(gp(Sc, "endAt")): J.sp(Sc, "endAt", gp(Sc, "t"))
			if t_(Sc) - n_(gp(Sc, "endAt")) > 2.2: mc(Sc, "finish", [false])

static func move_npc(Sc, n, dt: float) -> void:
	J.sp(n, "bounce", maxf(0.0, n_(gp(n, "bounce")) - dt * 2.5)); J.sp(n, "ph", n_(gp(n, "ph")) + dt)
	if n_(gp(n, "bubT")) > 0:
		J.sp(n, "bubT", n_(gp(n, "bubT")) - dt)
		if n_(gp(n, "bubT")) <= 0: J.sp(n, "bub", null)
	if J.t(gp(n, "gone")): return
	if J.t(gp(n, "out")): out_tick(Sc, n, dt); return
	var near = 0
	for m in npcs(Sc):
		if not is_same(m, n) and live(m) and same_room(Sc, m, n) and hyp(n_(gp(m, "x")) - n_(gp(n, "x")), n_(gp(m, "y")) - n_(gp(n, "y"))) < 0.22: near += 1
	var d = D(n)
	if not J.t(gp(d, "guard")):
		J.sp(n, "lookCD", (3 + 8 * rnd(n) if gp(n, "lookCD") == null else n_(gp(n, "lookCD"))) - dt)
		if n_(gp(n, "lookUp")) > 0: J.sp(n, "lookUp", n_(gp(n, "lookUp")) - dt)
		elif n_(gp(n, "lookCD")) <= 0: J.sp(n, "lookUp", 2.5); J.sp(n, "lookCD", 7 + 7 * rnd(n))
	if n_(gp(n, "fear")) >= 50 and not J.t(gp(d, "guard")): J.sp(n, "shaken", F("shaken"))
	J.sp(n, "shaken", maxf(0.0, or_(gp(n, "shaken"), 0.0) - dt))
	if n_(gp(n, "uneasy")) > 0: J.sp(n, "uneasy", n_(gp(n, "uneasy")) - dt)
	var sh = n_(gp(n, "shaken")) > 0
	var cr = (n_(gp(d, "calm")) * F("decay") + near * F("nearCalm")) * (F("shakenDecay") if sh else 1.0)
	var fear = n_(gp(n, "fear"))
	J.sp(n, "fear", maxf(minf(fear, F("shakenFloor")) if sh else 0.0, fear - cr * dt))
	var hab = gp(n, "hab")
	if J.t(hab): for k in J.keys(hab): J.sp(hab, k, maxf(0.0, n_(gp(hab, k)) - dt / F("habForget")))
	if sh and not J.t(gp(n, "fleeing")):
		J.sp(n, "glance", (3.0 if gp(n, "glance") == null else n_(gp(n, "glance"))) - dt)
		if n_(gp(n, "glance")) <= 0:
			J.sp(n, "glance", 3.5 + randf() * 3)
			if not hl(Sc) and not J.t(gp(n, "rx")) and J.str(gp(n, "act")) != "walk":
				mc(Sc, "react", [n, "chill", {"dur": 2.2}])
				if not J.t(gp(n, "bub")) and randf() < 0.45: bubble(Sc, n, pick(A_(_g("SHAKEN_SAY"))), 1.8)
	if n_(gp(n, "fear")) >= 25:
		J.sp(n, "look", n_(gp(n, "look")) - dt)
		if n_(gp(n, "look")) <= 0: J.sp(n, "dir", n_(gp(n, "dir")) * -1); J.sp(n, "look", 0.9 + randf() * 0.8)
	if J.t(gp(n, "fleeing")):
		var ex0 = gp(site(Sc), "exit"); var ex = n_(ex0[0]); var ey = n_(ex0[1])
		if J.t(gp(d, "fleeVia")) and not J.t(gp(n, "viaDone")):
			var b = null
			for m in npcs(Sc): if J.seq(gp(D(m), "k"), gp(d, "fleeVia")) and not J.t(gp(m, "gone")): b = m; break
			if b != null:
				ex = n_(gp(b, "x")); ey = n_(gp(b, "y"))
				if hyp(ex - n_(gp(n, "x")), ey - n_(gp(n, "y"))) < 0.05: J.sp(n, "viaDone", true)
			else: J.sp(n, "viaDone", true)
		var dx = ex - n_(gp(n, "x")); var dy = ey - n_(gp(n, "y")); var dd = hyp(dx, dy)
		J.sp(n, "dir", 1.0 if dx >= 0 else -1.0)
		if dd < 0.02:
			if J.t(gp(d, "fleeVia")) and not J.t(gp(n, "viaDone")): J.sp(n, "viaDone", true); return
			J.sp(n, "gone", true); J.sp(n, "exitT", gp(Sc, "t")); return
		var sp = 0.28 * dt; J.sp(n, "x", n_(gp(n, "x")) + dx / dd * sp); J.sp(n, "y", n_(gp(n, "y")) + dy / dd * sp)
		if randf() < 0.5: mc(Sc, "dust", [n])
		return
	if J.t(gp(d, "daoshi")): dao_tick(Sc, n, dt); return
	if J.t(gp(d, "post")) and J.t(gp(site(Sc), "shift")): plan_move(Sc, n, dt); return
	var route = A_(gp(d, "route"))
	if n_(gp(n, "wait")) > 0:
		J.sp(n, "wait", n_(gp(n, "wait")) - dt * (0.4 if n_(gp(n, "fear")) >= 50 else 1.0)); J.sp(n, "act", route[int(n_(gp(n, "wi")))][3])
		if J.str(gp(n, "act")) == "brk_nap" and n_(gp(n, "fear")) < 25: J.sp(n, "dir", 1.0 if n_(gp(n, "x")) <= n_(_SP("restTable")[0]) + 0.01 else -1.0)
		return
	var nxt = route[(int(n_(gp(n, "wi"))) + 1) % route.size()]
	if J.str(nxt[3]) == "brk_nap" and pano(Sc):
		if not J.t(gp(n, "napAt")): J.sp(n, "napAt", free_seat(Sc, n, nxt))
		var na = gp(n, "napAt"); nxt = [na[0], na[1], nxt[2], nxt[3]]
	else: J.sp(n, "napAt", null)
	var dx2 = n_(nxt[0]) - n_(gp(n, "x")); var dy2 = n_(nxt[1]) - n_(gp(n, "y")); var d2 = hyp(dx2, dy2)
	var sp2 = n_(gp(d, "speed")) * (0.55 if n_(gp(n, "fear")) >= 50 else 1.0) * dt; J.sp(n, "act", "walk")
	if n_(gp(n, "fear")) < 25: J.sp(n, "dir", 1.0 if dx2 >= 0 else -1.0)
	if d2 <= sp2: J.sp(n, "x", nxt[0]); J.sp(n, "y", nxt[1]); J.sp(n, "wi", float((int(n_(gp(n, "wi"))) + 1) % route.size())); J.sp(n, "wait", nxt[2])
	else: J.sp(n, "x", n_(gp(n, "x")) + dx2 / d2 * sp2); J.sp(n, "y", n_(gp(n, "y")) + dy2 / d2 * sp2)

static func shift_init(Sc) -> void:
	var S0 = n_(gp(Sc, "seed")); var arr = npcs(Sc)
	for i in arr.size():
		var n = arr[i]
		J.sp(n, "_seed", float(J.i32(S0 * 7919 + i * 104729))); J.sp(n, "ev", [])
		var d = D(n); var L = gp(d, "lines") if J.t(gp(d, "lines")) else {}
		var ev = gp(n, "ev"); var k = J.str(gp(d, "k"))
		if J.t(gp(d, "post")):
			var po = gp(d, "post"); J.sp(n, "x", po[0]); J.sp(n, "y", po[1]); J.sp(n, "act", po[2]); J.sp(n, "wait", 0.0)
			J.sp(n, "step", {"x": gp(n, "x"), "y": gp(n, "y"), "wait": U(n, 6.0, n_(gp(d, "work")[1]) if J.t(gp(d, "work")) else 6.0), "act": po[2], "arrived": true}); J.sp(n, "wait", gp(gp(n, "step"), "wait")); J.sp(n, "li", 0.0)
		if k == "boss":
			ev.append({"t": U(n, 18, 40), "k": "in", "say": gp(L, "late")}); ev.append({"t": U(n, 42, 56), "k": "callin"}); ev.append({"t": U(n, 70, 84), "k": "meeting"})
			if rng(n) < 0.6: ev.append({"t": U(n, 122, 136), "k": "callin"})
			if rng(n) < 0.5: ev.append({"t": U(n, 150, 165), "k": "leave"})
		if k == "it":
			var t1 = U(n, 100, 145)
			if rng(n) < 0.45: ev.append({"t": t1, "k": "leave", "back": U(n, 12, 20)})
			else: ev.append({"t": t1 + 15, "k": "leave"})
		if k == "mis":
			if rng(n) < 0.35: ev.append({"t": U(n, 25, 60), "k": "in", "say": gp(L, "late")})
			if rng(n) < 0.6: ev.append({"t": U(n, 120, 160), "k": "leave"})
		if k == "auntie":
			if rng(n) < 0.5: ev.append({"t": U(n, 20, 50), "k": "in", "say": gp(L, "late")})
			if rng(n) < 0.5: ev.append({"t": U(n, 135, 168), "k": "leave"})
		J.mc(ev, "sort", [func(_t, a): return n_(gp(a[0], "t")) - n_(gp(a[1], "t"))])
		ev = gp(n, "ev")
		if A_(ev).size() and J.str(gp(A_(ev)[0], "k")) == "in":
			var e = A_(ev).pop_front(); go_out(Sc, n, n_(gp(e, "t")), false, gp(e, "say"), true)

static func go_out(Sc, n, dur: float, leave, backSay, silent) -> void:
	var e = exit_pt(Sc)
	J.sp(n, "out", true); J.sp(n, "leaving", false); J.sp(n, "left", J.t(leave)); J.sp(n, "outT", dur); J.sp(n, "outAt", -9.0 if J.t(silent) else gp(Sc, "t"))
	J.sp(n, "inSay", backSay if J.t(backSay) else null); J.sp(n, "x", e[0]); J.sp(n, "y", e[1]); J.sp(n, "step", null); J.sp(n, "act", "idle")
	if not J.t(silent): elevator(Sc)
	if office(Sc) and J.str(gp(D(n), "k")) == "it": J.mc(_g("OFFICE"), "offline", ["it", J.t(leave)])
static func out_tick(Sc, n, dt: float) -> void:
	if J.t(gp(n, "left")): return
	J.sp(n, "outT", n_(gp(n, "outT")) - dt)
	if n_(gp(n, "outT")) > 0: return
	if pano(Sc):
		J.sp(n, "inWait", or_(gp(n, "inWait"), 0.0) + dt)
		if n_(gp(n, "inWait")) < 8:
			var c = 0
			for m in npcs(Sc): if not is_same(m, n) and live(m) and J.str(gp(m, "act")) == "walk" and J.str(room_of(Sc, m)) == "main": c += 1
			if c >= 2: return
	J.sp(n, "inWait", 0.0)
	J.sp(n, "out", false); J.sp(n, "inAt", gp(Sc, "t")); elevator(Sc)
	if office(Sc) and J.str(gp(D(n), "k")) == "it": J.mc(_g("OFFICE"), "offline", ["it", false])
	var e = exit_pt(Sc); J.sp(n, "x", e[0]); J.sp(n, "y", e[1]); J.sp(n, "dir", -1.0)
	if J.t(gp(n, "inSay")): bubble(Sc, n, gp(n, "inSay"), 2.6)
	J.sp(n, "inSay", null); J.sp(n, "step", null); J.sp(n, "next", null)
static func elevator(Sc) -> void:
	J.sp(Sc, "door", 1.8); jumpy(Sc, null, "lobby")
	if not hl(Sc):
		if _g("Sound") != null: J.mc(_g("Sound"), "play", ["coin"])
		if office(Sc): J.mc(_g("OFFICE"), "elevator", [])

static func plan_move(Sc, n, dt: float) -> void:
	var d = D(n); var L = gp(d, "lines")
	var ev = A_(gp(n, "ev"))
	while ev.size() and t_(Sc) >= n_(gp(ev[0], "t")):
		var e = ev[0]; var k = J.str(gp(e, "k"))
		if k == "leave":
			if present(Sc, n) < 2: J.sp(e, "t", n_(gp(e, "t")) + 3); break
			ev.pop_front(); J.sp(n, "leaving", true); J.sp(n, "step", {"x": gp(n, "x"), "y": gp(n, "y"), "wait": 3.5, "act": "pack", "arrived": true, "cue": true}); J.sp(n, "wait", 3.5)
			bubble(Sc, n, gp(L, "cue") if J.t(L) else null, 3.0)
			J.sp(n, "next", {"out": true, "leave": not J.t(gp(e, "back")), "outDur": gp(e, "back") if J.t(gp(e, "back")) else 0.0, "backSay": gp(L, "back") if J.t(L) else null, "sayStart": gp(L, "bye") if J.t(L) else null})
			continue
		if k == "in": ev.pop_front(); continue
		if k == "callin" or k == "meeting":
			if J.t(gp(n, "leaving")) or J.t(gp(n, "fleeing")) or n_(gp(n, "fear")) >= 50 or not boss_call(Sc, n, k): J.sp(e, "t", n_(gp(e, "t")) + 5); break
			ev.pop_front(); continue
		break
	if J.t(gp(n, "call")) and not J.t(gp(n, "leaving")):
		var c = gp(n, "call"); var cb = gp(c, "boss")
		if J.t(cb) and (J.t(gp(cb, "gone")) or J.t(gp(cb, "out")) or J.t(gp(cb, "fleeing"))): J.sp(n, "call", null)
		elif J.t(cb) and J.str(room_of(Sc, cb)) != "boss" and _inc(c, "hold", dt) < 25: pass
		elif n_(gp(c, "delay")) > 0: J.sp(c, "delay", n_(gp(c, "delay")) - dt)
		else:
			J.sp(n, "call", null); J.sp(n, "next", null)
			J.sp(n, "step", {"x": gp(c, "x"), "y": gp(c, "y"), "wait": gp(c, "wait"), "act": gp(c, "act"), "arrived": false, "path": null, "pi": 0.0, "say": gp(c, "say"), "called": true, "boss": gp(c, "boss") if J.t(gp(c, "boss")) else null})
			if J.t(gp(c, "go")): bubble(Sc, n, gp(c, "go"), 2.2)
	if not J.t(gp(n, "step")):
		J.sp(n, "step", mk_step(Sc, n, gp(n, "next")) if J.t(gp(n, "next")) else plan_next(Sc, n)); J.sp(n, "next", null)
		if J.t(gp(gp(n, "step"), "arrived")): J.sp(n, "wait", gp(gp(n, "step"), "wait"))
	var s = gp(n, "step")
	if not J.t(gp(s, "arrived")) and not J.t(gp(s, "go")):
		_inc(s, "hold", dt)
		if J.str(gp(n, "act")) != "walk" and not in_door(Sc, n_(gp(n, "x"))) and not (J.t(gp(s, "called")) and J.str(gp(d, "k")) == "boss") and walk_blocked(Sc, n, n_(gp(s, "x"))) and n_(gp(s, "hold")) < 6 and not J.t(gp(n, "fleeing")): J.sp(n, "act", "idle"); return
		J.sp(s, "go", true)
	if not J.t(gp(s, "arrived")):
		var path = gp(s, "path"); var pi = int(n_(gp(s, "pi")))
		var tgt = A_(path)[pi] if J.t(path) and pi < A_(path).size() else [gp(s, "x"), gp(s, "y")]
		var dx = n_(tgt[0]) - n_(gp(n, "x")); var dy = n_(tgt[1]) - n_(gp(n, "y")); var dd = hyp(dx, dy); var sp = n_(gp(d, "speed")) * (0.55 if n_(gp(n, "fear")) >= 50 else 1.0) * dt
		J.sp(n, "act", "walk")
		if n_(gp(n, "fear")) < 25: J.sp(n, "dir", 1.0 if dx >= 0 else -1.0)
		if dd <= sp:
			J.sp(n, "x", tgt[0]); J.sp(n, "y", tgt[1])
			if J.t(path) and pi < A_(path).size(): J.sp(s, "pi", float(pi + 1)); return
			J.sp(s, "arrived", true); J.sp(n, "wait", gp(s, "wait"))
			if J.t(gp(s, "say")): bubble(Sc, n, gp(s, "say"), 2.4)
			if J.t(gp(s, "out")): go_out(Sc, n, n_(gp(s, "outDur")), gp(s, "leave"), gp(s, "backSay"), false); return
		else: J.sp(n, "x", n_(gp(n, "x")) + dx / dd * sp); J.sp(n, "y", n_(gp(n, "y")) + dy / dd * sp)
		return
	J.sp(n, "act", gp(s, "act")); J.sp(n, "wait", n_(gp(n, "wait")) - dt * (0.4 if n_(gp(n, "fear")) >= 50 else 1.0))
	if J.t(gp(s, "called")) and J.t(gp(s, "boss")) and n_(gp(n, "fear")) < 50:
		var b = gp(s, "boss")
		if J.t(gp(b, "gone")) or J.t(gp(b, "out")) or J.t(gp(b, "fleeing")) or J.str(room_of(Sc, b)) != "boss":
			_inc(s, "empty", dt); J.sp(n, "wait", n_(gp(n, "wait")) + dt)
			if n_(gp(s, "empty")) > 6:
				var es = _g("EMPTY_SAY"); var t2 = gp(es, gp(d, "k"))
				bubble(Sc, n, t2 if J.t(t2) else gp(es, "it"), 2.6); J.sp(n, "step", null); return
		else: J.sp(s, "empty", 0.0)
	var po = gp(d, "post")
	var atPost = J.t(po) and hyp(n_(gp(n, "x")) - n_(po[0]), n_(gp(n, "y")) - n_(po[1])) < 0.012
	if atPost and A_(po).size() > 3 and J.t(po[3]) and n_(gp(n, "fear")) < 25: J.sp(n, "dir", po[3])
	if J.str(gp(n, "act")) == "present" and n_(gp(n, "fear")) < 25: J.sp(n, "dir", 1.0)
	if J.t(gp(s, "sit")) and J.str(gp(s, "act")) == "brk_nap" and n_(gp(n, "fear")) < 25: J.sp(n, "dir", 1.0 if n_(gp(n, "x")) <= n_(_SP("restTable")[0]) + 0.01 else -1.0)
	if J.t(gp(d, "guard")) and J.str(gp(n, "act")) == "doze" and n_(gp(n, "fear")) > 0: J.sp(n, "act", "look")
	if atPost and J.t(L) and J.t(gp(L, "work")) and n_(gp(n, "fear")) < 25 and not J.t(gp(s, "cue")):
		J.sp(n, "wl", (4 + rng(n) * 6 if gp(n, "wl") == null else n_(gp(n, "wl"))) - dt)
		if n_(gp(n, "wl")) <= 0:
			J.sp(n, "wl", 9 + rng(n) * 8)
			var anyb = false
			for m in npcs(Sc): if J.t(gp(m, "bub")) and n_(gp(m, "bubT")) > 0: anyb = true; break
			if not J.t(gp(n, "bub")) and (hl(Sc) or not anyb):
				var w = A_(gp(L, "work")); bubble(Sc, n, w[int(floor(rng(n) * w.size()))], 2.4)
	if n_(gp(n, "wait")) <= 0:
		if J.t(gp(s, "meet")):
			var i = 0
			for m in npcs(Sc):
				var ms = gp(m, "step")
				if J.t(ms) and J.str(gp(ms, "act")) == "notes" and J.t(gp(ms, "arrived")): J.sp(m, "wait", minf(n_(gp(m, "wait")), 1.5 + 3 * i)); i += 1
				elif J.t(gp(m, "call")) and J.str(gp(gp(m, "call"), "act")) == "notes": J.sp(m, "call", null)
			bubble(Sc, n, "散會！聽朝九點前交。", 2.4)
		J.sp(n, "step", null)
static func _inc(o, k: String, v: float) -> float:
	var x = or_(gp(o, k), 0.0) + v; J.sp(o, k, x); return x

static func _near2(a, p) -> bool: return J.t(a) and hyp(n_(a[0]) - n_(p[0]), n_(a[1]) - n_(p[1])) < 0.02
static func free_seat(Sc, n, pref) -> Array:
	var SS = A_(_SP("restSeats"))
	var busy_ = func(p) -> bool:
		for m in npcs(Sc):
			if is_same(m, n) or not live(m): continue
			var ms = gp(m, "step")
			if _near2([gp(m, "x"), gp(m, "y")], p) or (J.t(ms) and _near2([gp(ms, "x"), gp(ms, "y")], p)) or _near2(gp(m, "napAt"), p): return true
		return false
	if not busy_.call(pref): return [pref[0], pref[1]]
	for p in SS: if not busy_.call(p): return [p[0], p[1]]
	return [pref[0], pref[1]]
static func rest_step(Sc, n, wait, say, acts) -> Dictionary:
	var SS = A_(_SP("restSeats")); var free = []
	for p in SS:
		var b = false
		for m in npcs(Sc):
			if is_same(m, n) or not live(m): continue
			var ms = gp(m, "step"); var na = gp(m, "napAt")
			if (J.t(ms) and hyp(n_(gp(ms, "x")) - n_(p[0]), n_(gp(ms, "y")) - n_(p[1])) < 0.01) or hyp(n_(gp(m, "x")) - n_(p[0]), n_(gp(m, "y")) - n_(p[1])) < 0.01 or (J.t(na) and hyp(n_(na[0]) - n_(p[0]), n_(na[1]) - n_(p[1])) < 0.01): b = true; break
		if not b: free.append(p)
	var po = gp(D(n), "post")
	if free.is_empty() or busy(Sc, n, n_(free[0][0])): return {"x": po[0], "y": po[1], "wait": U(n, 4, 8), "act": po[2], "arrived": true}
	var p2 = free[int(floor(rng(n) * free.size()))]; var a = A_(acts) if J.t(acts) else ["brk_phone", "brk_drink", "brk_nap"]
	if J.t(say): bubble(Sc, n, say, 2.2)
	return {"x": p2[0], "y": p2[1], "wait": wait, "act": a[int(floor(rng(n) * a.size()))], "arrived": false, "path": null, "pi": 0.0, "sit": true}
static func mk_step(Sc, n, o):
	var e = exit_pt(Sc)
	if J.t(gp(o, "out")):
		J.sp(n, "leaving", true)
		if J.t(gp(o, "sayStart")): bubble(Sc, n, gp(o, "sayStart"), 2.4)
		return {"x": e[0], "y": e[1], "path": via_elev(Sc, n, n_(gp(n, "x")), n_(gp(n, "y"))), "pi": 0.0, "out": true, "leave": gp(o, "leave"), "outDur": gp(o, "outDur"), "backSay": gp(o, "backSay")}
	return o
static func _U2(n, r) -> float: var a = A_(r); return U(n, n_(a[0]), n_(a[1]))
static func plan_next(Sc, n) -> Dictionary:
	var d = D(n); var po = gp(d, "post"); var px = po[0]; var py = po[1]; var pact = po[2]
	var atPost = hyp(n_(gp(n, "x")) - n_(px), n_(gp(n, "y")) - n_(py)) < 0.012
	if J.t(gp(d, "lane")):
		var lane = A_(gp(d, "lane"))
		J.sp(n, "li", or_(gp(n, "li"), 0.0) + 1); var li = int(n_(gp(n, "li")))
		if J.t(gp(d, "tripEvery")) and li % (int(n_(gp(d, "tripEvery"))) * lane.size()) == 0 and present(Sc, n) >= 3:
			var tr = A_(gp(d, "trips"))[0]; return mk_step(Sc, n, {"out": true, "outDur": _U2(n, tr[3]), "backSay": tr[5] if tr.size() > 5 else null, "sayStart": tr[4]})
		if li % lane.size() == 4 and J.str(room_of(Sc, n)) == "pantry" and rng(n) < 0.6:
			var st = rest_step(Sc, n, U(n, 8, 12), gp(_g("BRK"), "auntie"), ["brk_drink", "brk_nap"])
			if J.t(gp(st, "sit")): return st
		var p0 = lane[li % lane.size()]; var p = free_spot(Sc, n, n_(p0[0]), n_(p0[1]))
		return {"x": p[0], "y": p[1], "wait": _U2(n, gp(d, "laneWait")), "act": "mop", "arrived": false, "mopWalk": true}
	if J.t(gp(d, "guard")) and J.t(gp(n, "tour")) and A_(gp(n, "tour")).size():
		var p = A_(gp(n, "tour")).pop_front(); return {"x": p[0], "y": p[1], "wait": U(n, 3, 4.5), "act": "look", "arrived": false, "path": null, "pi": 0.0}
	if not atPost:
		return {"x": px, "y": py, "wait": _U2(n, work_of(Sc, n)), "act": pact, "arrived": false, "path": [[_M(0.80), _MY(0.60)]] if (n_(gp(n, "y")) < n_(_MY(0.56)) and n_(gp(n, "x")) > n_(_M(0.85))) else null, "pi": 0.0}
	var tr2 = A_(gp(d, "trips")) if J.t(gp(d, "trips")) else []; var tot = 0.0
	for e0 in tr2: tot += n_(e0[1])
	var r = rng(n) * tot; var e = tr2[0] if tr2.size() else null
	for q in tr2:
		r -= n_(q[1])
		if r <= 0: e = q; break
	if e == null: return {"x": px, "y": py, "wait": _U2(n, work_of(Sc, n)), "act": pact, "arrived": true}
	var e2 = e[2]
	if e2 is String and e2 == "out":
		if present(Sc, n) < 2 or busy(Sc, n, n_(exit_pt(Sc)[0])): return {"x": px, "y": py, "wait": U(n, 4, 8), "act": pact, "arrived": true}
		return mk_step(Sc, n, {"out": true, "outDur": _U2(n, e[3]), "backSay": e[5] if e.size() > 5 else null, "sayStart": e[4]})
	var to = e2
	if to is String and to == "patrol":
		var P = A_(gp(OM(), "PATROL")); J.sp(n, "pt", or_(gp(n, "pt"), 0.0) + 1)
		J.sp(n, "tour", P.slice(3) if int(n_(gp(n, "pt"))) % 2 else [P[2], P[1], P[0]])
		var p = A_(gp(n, "tour")).pop_front()
		if e.size() > 4 and J.t(e[4]): bubble(Sc, n, e[4], 2.2)
		return {"x": p[0], "y": p[1], "wait": U(n, 3, 4.5), "act": "look", "arrived": false, "path": null, "pi": 0.0}
	if to is String and to == "rest": return rest_step(Sc, n, _U2(n, e[3]), e[4] if e.size() > 4 else null, e[6] if e.size() > 6 else null)
	if to is String and to == "boss":
		var b = null
		for m in npcs(Sc): if J.str(gp(D(m), "k")) == "boss" and not J.t(gp(m, "out")) and not J.t(gp(m, "gone")) and not J.t(gp(m, "fleeing")): b = m; break
		if b == null or J.str(room_of(Sc, b)) != "boss": return {"x": px, "y": py, "wait": U(n, 4, 8), "act": pact, "arrived": true}
		to = _SP("bossVisit")
	if busy(Sc, n, n_(to[0])): return {"x": px, "y": py, "wait": U(n, 3, 6), "act": pact, "arrived": true}
	to = free_spot(Sc, n, n_(to[0]), n_(to[1]))
	if e.size() > 4 and J.t(e[4]): bubble(Sc, n, e[4], 2.2)
	return {"x": to[0], "y": to[1], "wait": _U2(n, e[3]), "act": "idle", "arrived": false, "path": null, "pi": 0.0}

static func boss_call(Sc, b, kind: String) -> bool:
	var cand = []
	for m in npcs(Sc):
		var k = J.str(gp(D(m), "k")); var ms = gp(m, "step")
		if (k == "it" or k == "mis") and live(m) and not J.t(gp(m, "fleeing")) and not J.t(gp(m, "leaving")) and not J.t(gp(m, "call")) and not (J.t(ms) and J.t(gp(ms, "called"))) and n_(gp(m, "fear")) < 50: cand.append(m)
	if cand.is_empty(): return false
	var po = gp(D(b), "post")
	if kind == "callin":
		var c = cand[int(floor(rng(b) * cand.size()))]
		bubble(Sc, b, J.str(gp(D(c), "name")) + "，入嚟我房！", 2.6); J.sp(b, "next", null)
		J.sp(b, "step", {"x": po[0], "y": po[1], "wait": 24.0, "act": "read", "arrived": hyp(n_(gp(b, "x")) - n_(po[0]), n_(gp(b, "y")) - n_(po[1])) < 0.012, "path": null, "pi": 0.0, "say": "（睇報告）企喺度等我睇完先。", "called": true})
		if J.t(gp(gp(b, "step"), "arrived")): J.sp(b, "wait", 24.0); bubble(Sc, b, gp(gp(b, "step"), "say"), 2.4)
		var mis = J.str(gp(D(c), "k")) == "mis"; var bf = _SP("bossFront")
		J.sp(c, "call", {"x": bf[0], "y": bf[1], "wait": 14.0, "act": "idle", "delay": 1.2, "go": "嚟緊喇陳總～" if mis else "……係。", "say": "陳總～搵我呀？" if mis else "陳總，搵我？", "boss": b})
		J.sp(Sc, "callT", gp(Sc, "t")); J.sp(Sc, "callWho", c); return true
	var k2 = 2 if cand.size() > 1 and rng(b) < 0.6 else 1
	var sorted = J.mc(cand, "sort", [func(_t, _a2): return rng(b) - 0.5])
	var who = A_(sorted).slice(0, k2)
	var names = PackedStringArray()
	for m in who: names.append(J.str(gp(D(m), "name")))
	bubble(Sc, b, ("、".join(names) + "，入會議室開會！") if who.size() > 1 else (names[0] + "，入會議室！"), 2.8)
	J.sp(b, "next", null); var bd = _SP("board")
	J.sp(b, "step", {"x": bd[0], "y": bd[1], "wait": 22.0, "act": "present", "arrived": false, "path": null, "pi": 0.0, "say": "（指住白板）呢季嘅數……", "called": true, "meet": true})
	var seats = [_SP("seat1"), _SP("seat2"), _SP("seat3")]
	for i in who.size():
		var st = seats[i % 3]
		J.sp(who[i], "call", {"x": st[0], "y": st[1], "wait": 60.0, "act": "notes", "delay": 1.5 + i * 3.5, "go": null if i else "又開會……"})
	J.sp(Sc, "meetT", gp(Sc, "t")); return true

static func wake_guard(Sc, n) -> void:
	var g = null
	for x in npcs(Sc): if J.t(gp(D(x), "guard")) and live(x): g = x; break
	if g == null: return
	if J.str(gp(g, "act")) == "doze": bubble(Sc, g, "（醒咗）咩事？", 2.0)
	if J.t(n):
		var nx = n_(gp(n, "x")); var W = n_(gp(OM(), "WW")) if pano(Sc) else 1.0
		J.sp(g, "tour", null)
		J.sp(g, "step", {"x": maxf(0.1, minf(W - 0.1, nx + (-0.12 if nx > n_(gp(g, "x")) else 0.12))), "y": maxf(0.66, minf(0.93, n_(gp(n, "y")) + 0.02)), "wait": 6.0, "act": "look", "arrived": false, "path": null, "pi": 0.0}); J.sp(g, "next", null)
	elif J.str(gp(g, "act")) == "doze": J.sp(g, "step", null)
static func expose(Sc, v, n) -> void:
	if not J.t(v) or J.t(gp(Sc, "expelled")): return
	var vv = n_(v)
	if J.t(n) and pano(Sc): J.sp(Sc, "expoRoom", room_of(Sc, n))
	J.sp(Sc, "expo", minf(100.0, or_(gp(Sc, "expo"), 0.0) + vv)); J.sp(Sc, "expoT", gp(Sc, "t")); J.sp(Sc, "expoMax", maxf(or_(gp(Sc, "expoMax"), 0.0), n_(gp(Sc, "expo"))))
	if not hl(Sc) and vv >= 5: mc(Sc, "float", [0.2, 0.06, "穿崩度 +" + J.str(jround(vv)), "#ff9a7a", 1.4])
	if n_(gp(Sc, "expo")) >= E("sus") and not J.t(gp(Sc, "alert")):
		J.sp(Sc, "alert", true)
		for x in npcs(Sc):
			if live(x) and not J.t(gp(x, "fleeing")) and not J.t(gp(D(x), "guard")) and not J.t(gp(D(x), "daoshi")): bubble(Sc, x, "呢度……係咪有嘢？", 2.4); break
		for x in npcs(Sc):
			if J.t(gp(D(x), "guard")) and not J.t(gp(x, "gone")): bubble(Sc, x, "我行多幾轉睇睇。", 2.2); wake_guard(Sc, null); break
	var da = gp(Sc, "daoAt")
	if n_(gp(Sc, "expo")) >= (n_(da) if J.t(da) else E("call")) and not J.t(gp(Sc, "daoCall")):
		var c = null
		for x in npcs(Sc):
			var k = J.str(gp(D(x), "k"))
			if (k == "mis" or k == "boss") and live(x) and not J.t(gp(x, "fleeing")): c = x; break
		if c == null:
			for x in npcs(Sc):
				if live(x) and not J.t(gp(x, "fleeing")) and not J.t(gp(D(x), "guard")): c = x; break
		if c != null:
			J.sp(Sc, "daoCall", gp(Sc, "t")); bubble(Sc, c, "喂？林師傅？即刻上嚟二十三樓！" if J.str(gp(D(c), "k")) == "boss" else "喂～林師傅呀？二十三樓好似有嘢……", 3.0)
			if not hl(Sc): mc(Sc, "float", [0.5, 0.3, J.str(gp(D(c), "name")) + "打電話請咗道士！", "#ffcf6a", 2.6])
static func expo_tick(Sc, dt: float) -> void:
	var dao = null
	for x in npcs(Sc): if J.t(gp(D(x), "daoshi")) and live(x) and not J.t(gp(x, "fleeing")): dao = x; break
	var quiet = t_(Sc) - or_(gp(Sc, "expoT"), -99.0) > 5
	J.sp(Sc, "expo", maxf(0.0, or_(gp(Sc, "expo"), 0.0) - (E("lowDecay") if dao != null and quiet else E("decay")) * dt))
	if J.t(gp(Sc, "daoCall")) and not J.t(gp(Sc, "daoIn")) and t_(Sc) - n_(gp(Sc, "daoCall")) > or_(gp(Sc, "daoDelay"), 7.0):
		J.sp(Sc, "daoIn", true); var e = exit_pt(Sc)
		var n = {"d": _g("DAOSHI"), "x": e[0], "y": e[1], "wi": 0.0, "wait": 0.0, "dir": -1.0, "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": "walk", "ph": 0.0, "prog": 0.0, "ds": "in", "inAt": gp(Sc, "t")}
		gp(Sc, "npcs").append(n); elevator(Sc); bubble(Sc, n, "邊度有嘢？等我睇睇。", 2.6)
static func dao_tick(Sc, n, dt: float) -> void:
	var d = D(n)
	if not J.t(gp(n, "spot")):
		var er = gp(Sc, "expoRoom")
		var r = gp(gp(OM(), "RM"), er) if pano(Sc) and J.t(er) and J.str(er) != "main" else null
		J.sp(n, "spot", [gp(r, "cx"), 0.86] if J.t(r) else ([_M(0.66), _MY(0.90)] if pano(Sc) else [0.66, 0.90])); J.sp(n, "spotRoom", gp(r, "name") if J.t(r) else null)
		if J.t(r): bubble(Sc, n, J.str(gp(r, "name")) + "？帶路。", 2.4)
	var spot = gp(n, "spot"); var ds = J.str(gp(n, "ds"))
	if ds == "in":
		var dx = n_(spot[0]) - n_(gp(n, "x")); var dy = n_(spot[1]) - n_(gp(n, "y")); var dd = hyp(dx, dy); var sp = n_(gp(d, "speed")) * dt
		J.sp(n, "act", "walk"); J.sp(n, "dir", 1.0 if dx >= 0 else -1.0)
		if dd <= sp: J.sp(n, "x", spot[0]); J.sp(n, "y", spot[1]); J.sp(n, "ds", "ritual"); J.sp(n, "rT", 0.0); J.sp(n, "act", "ritual"); bubble(Sc, n, "（搖鈴）各位，借個位。", 2.4)
		else: J.sp(n, "x", n_(gp(n, "x")) + dx / dd * sp); J.sp(n, "y", n_(gp(n, "y")) + dy / dd * sp)
		return
	if ds == "ritual":
		J.sp(n, "act", "ritual"); J.sp(n, "rT", n_(gp(n, "rT")) + dt); var startled = n_(gp(n, "fear")) >= 50
		if not startled: J.sp(n, "prog", minf(1.0, or_(gp(n, "prog"), 0.0) + dt / E("ritual") * (1.0 if n_(gp(Sc, "expo")) >= 25 else 0.4)))
		J.sp(n, "lt", (5.0 if gp(n, "lt") == null else n_(gp(n, "lt"))) - dt)
		if n_(gp(n, "lt")) <= 0 and not J.t(gp(n, "bub")): J.sp(n, "lt", 6 + randf() * 4); bubble(Sc, n, "（執返個鈴）冇嘢，冇嘢……" if startled else pick(A_(gp(d, "lines"))), 2.4)
		if n_(gp(n, "prog")) >= 1:
			J.sp(Sc, "expelled", true); bubble(Sc, n, "（鈴一搖）收工！", 2.6)
			if not hl(Sc): mc(Sc, "float", [0.5, 0.35, "阿福被請走了……", "#ffcf6a", 3.0])
			if not J.t(gp(Sc, "endAt")): J.sp(Sc, "endAt", gp(Sc, "t"))
			return
		if n_(gp(Sc, "expo")) < E("giveUp") and n_(gp(n, "rT")) > 10:
			J.sp(n, "ds", "out"); bubble(Sc, n, "冇嘢喎……今晚收你半價。", 2.8)
			if not hl(Sc): mc(Sc, "float", [0.5, 0.35, "道士放棄了", "#9fe0c0", 2.2])
		return
	if ds == "out":
		var e = exit_pt(Sc); var dx = n_(e[0]) - n_(gp(n, "x")); var dy = n_(e[1]) - n_(gp(n, "y")); var dd = hyp(dx, dy); var sp = n_(gp(d, "speed")) * 1.2 * dt
		J.sp(n, "act", "walk"); J.sp(n, "dir", 1.0 if dx >= 0 else -1.0)
		if dd <= sp: go_out(Sc, n, 0.0, true, null, false); J.sp(n, "left", true)
		else: J.sp(n, "x", n_(gp(n, "x")) + dx / dd * sp); J.sp(n, "y", n_(gp(n, "y")) + dy / dd * sp)
static func jumpy(Sc, skip, room) -> void:
	for n in npcs(Sc):
		if J.t(gp(n, "gone")) or J.t(gp(n, "out")) or J.t(gp(n, "fleeing")) or J.t(gp(D(n), "guard")) or not (n_(gp(n, "shaken")) > 0): continue
		if J.t(skip):
			var inn = false
			for x in A_(skip): if is_same(x, n): inn = true
			if inn: continue
		if J.t(room) and pano(Sc) and not J.seq(room_of(Sc, n), room): continue
		var before = minf(100.0, n_(gp(n, "peak"))); J.sp(n, "fear", minf(99.0, n_(gp(n, "fear")) + 5)); J.sp(n, "peak", maxf(n_(gp(n, "peak")), n_(gp(n, "fear"))))
		J.sp(Sc, "kpi", n_(gp(Sc, "kpi")) + jround(minf(100.0, n_(gp(n, "peak"))) - before))
		if not hl(Sc):
			mc(Sc, "react", [n, "flinch"]); J.sp(n, "barHit", 0.6)
			if randf() < 0.5: bubble(Sc, n, pick(A_(_g("JUMPY_SAY"))), 1.4)
static func add_karma(Sc, d, v, why) -> void:
	if J.t(v): gp(Sc, "karma").append({"v": v, "who": gp(d, "name"), "why": why})

# ================= 第三段：出招（附身家具、手機、吹氣、鬼大招）、hit、perceive =================
static func FM(k: String) -> float: return n_(gp(_g("FEAR_MID"), k))
static func snd(name: String) -> void: if _g("Sound") != null: J.mc(_g("Sound"), "play", [name])
static func later(_Sc, f: Callable, sec: float) -> void:
	var cb = func(_t = null, _a2 = null):
		f.call()
		return null
	J.F_setTimeout([cb, sec * 1000])
static func _lat(Sc, f: Callable, sec: float) -> void:
	if hl(Sc):
		f.call(); return
	var cb = func(_t = null, _a2 = null):
		if J.t(gp(Sc, "active")): f.call()
		return null
	J.F_setTimeout([cb, sec * 1000])
static func toast(Sc, t) -> void: mc(Sc, "toast", [t])
static func flt(Sc, x, y, text, col, life = null) -> void:
	if life == null: mc(Sc, "float", [x, y, text, col])
	else: mc(Sc, "float", [x, y, text, col, life])
static func _dl(Sc) -> float: return or_(gp(Sc, "_dl"), 0.0)

static func use_prop(Sc, k, who) -> void:
	var p = gp(_g("SCARE_PROPS"), k); var n = who if J.t(who) else gp(Sc, "sel")
	if not J.t(gp(Sc, "pcd")): J.sp(Sc, "pcd", {})
	var pcd = gp(Sc, "pcd"); var ks = J.str(k)
	if J.t(gp(p, "group")):
		if n_(gp(pcd, k)) > 0: toast(Sc, J.str(gp(p, "name")) + "冷卻中"); return
		if n_(gp(Sc, "mana")) < n_(gp(p, "cost")): toast(Sc, "陰氣不夠，等一下"); return
		var rm = group_room(Sc); var RR = gp(gp(OM(), "RM"), rm) if J.t(rm) else rm
		var anyone = false
		for m in npcs(Sc): if not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and not J.t(gp(D(m), "guard")) and in_group(Sc, m, rm): anyone = true; break
		if not anyone: toast(Sc, (J.str(gp(RR, "name")) if J.t(RR) else "呢度") + "冇人"); return
		if J.t(RR):
			var v = gp(RR, "vent"); J.sp(p, "rect", [n_(J.cl(gp(OM(), "npx"), null, [v[0]])) - 0.06, J.cl(gp(OM(), "py"), null, [v[1]]), 0.12, 0.02])
		J.sp(Sc, "mana", n_(gp(Sc, "mana")) - n_(gp(p, "cost"))); J.sp(pcd, k, gp(p, "cdT"))
		var r = gp(p, "rect"); var cx = n_(r[0]) + n_(r[2]) / 2; var cy = n_(r[1]) + n_(r[3])
		gp(Sc, "fx").append({"kind": k, "life": 2.2, "x": cx, "y": cy, "room": rm})
		if not hl(Sc):
			snd("click" if ks == "lights" else "whoosh"); mc(Sc, "propParts", [k, p])
			if pano(Sc): J.mc(OM(), "onProp", [k, null, rm])
			elif office(Sc): J.mc(_g("OFFICE"), "onProp", [k])
			flt(Sc, 0.5, 0.36, ((J.str(gp(RR, "name")) + "入面") if J.t(RR) else "全場") + "一齊經歷：冇人會話邊個黐線　之後單嚇 ×" + J.str(F("uneasyMul")), "#bcd4ff", 2.2)
		var tg = []
		for m in npcs(Sc): if not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")) and in_group(Sc, m, rm): tg.append(m)
		J.sp(Sc, "_src", cx); J.sp(Sc, "_dl", 0.0); J.sp(Sc, "_group", true)
		for m in tg: hit(Sc, m, gp(p, "type"), n_(gp(p, "base")), n_(gp(p, "tier")))
		J.sp(Sc, "_group", false); J.sp(Sc, "_src", null); expose(Sc, E("group"), null); return
	if not J.t(n) or J.t(gp(n, "gone")) or J.t(gp(n, "out")) or J.t(gp(n, "fleeing")) or J.t(gp(D(n), "guard")): toast(Sc, "先點一個人"); return
	if not prop_ok(Sc, k, n): toast(Sc, J.str(gp(D(n), "name")) + "離" + J.str(gp(p, "name")) + "太遠"); return
	if n_(gp(Sc, "mana")) < n_(gp(p, "cost")): toast(Sc, "陰氣不夠，等一下"); return
	J.sp(Sc, "mana", n_(gp(Sc, "mana")) - n_(gp(p, "cost")))
	var r2 = gp(p, "rect"); var pr = J.t(gp(p, "r"))
	var cx2 = n_(r2[0]) + n_(r2[2]) / 2 if pr else n_(gp(n, "x")); var cy2 = n_(r2[1]) + n_(r2[3]) if pr else n_(gp(n, "y")) - 0.2
	gp(Sc, "fx").append({"kind": k, "life": 2.2, "x": cx2, "y": cy2, "n": n})
	if not hl(Sc):
		snd("paper" if ks in ["printer", "vend"] else ("hit" if ks in ["lamp", "drop", "trophy"] else ("crow" if ks in ["water", "kettle"] else "whoosh"))); mc(Sc, "propParts", [k, p, n])
		if office(Sc):
			if J.t(gp(p, "room")) and J.str(gp(p, "room")) != "main" and ks != "printer": J.mc(OM(), "onProp", [k, n])
			else: J.mc(_g("OFFICE"), "onProp", [k])
	J.sp(Sc, "_src", cx2); J.sp(Sc, "_dl", 0.0); J.sp(Sc, "_vis", J.t(gp(p, "vis"))); hit(Sc, n, gp(p, "type"), n_(gp(p, "base")), n_(gp(p, "tier"))); J.sp(Sc, "_src", null); J.sp(Sc, "_vis", false)
static func use_phone(Sc, n) -> void:
	var cost = 22.0
	if not J.t(n) or J.t(gp(n, "gone")) or not J.t(gp(D(n), "phone")): return
	if J.t(gp(n, "out")): toast(Sc, J.str(gp(D(n), "name")) + "不在"); return
	if n_(gp(Sc, "mana")) < cost: toast(Sc, "陰氣不夠，等一下"); return
	J.sp(Sc, "mana", n_(gp(Sc, "mana")) - cost); gp(Sc, "fx").append({"kind": "phone", "life": 1.6, "n": n})
	if not hl(Sc): snd("click")
	J.sp(Sc, "_src", null); J.sp(Sc, "_dl", 0.0); J.sp(Sc, "_vis", false); hit(Sc, n, "phone", 22.0, 1.0, null, true)
static func use_breath(Sc, n) -> void:
	var cost = 20.0
	if not J.t(n) or J.t(gp(n, "gone")) or J.t(gp(n, "fleeing")): return
	if J.t(gp(n, "out")): toast(Sc, J.str(gp(D(n), "name")) + "不在"); return
	if n_(gp(Sc, "mana")) < cost: toast(Sc, "陰氣不夠，等一下"); return
	J.sp(Sc, "mana", n_(gp(Sc, "mana")) - cost); gp(Sc, "fx").append({"kind": "breath", "life": 2.4, "max": 2.4, "n": n})
	if not hl(Sc): snd("whoosh")
	J.sp(Sc, "_src", null); J.sp(Sc, "_dl", 0.0); J.sp(Sc, "_vis", false)
	hit(Sc, n, "breath" if A_(gp(D(n), "weak")).has("breath") else "cold", 24.0, 1.0, null, true)
	var rx = gp(n, "rx")
	if not hl(Sc) and J.t(rx) and J.str(gp(rx, "k")) != "burst" and not J.t(gp(n, "fleeing")): mc(Sc, "react", [n, "chill", {"dur": 2.4}])
	rx = gp(n, "rx")
	if not hl(Sc) and J.t(rx) and J.str(gp(rx, "k")) == "chill": J.sp(n, "hair", 1.2); J.sp(n, "goose", 2.0)
static func use_ghost(Sc, k, n) -> void:
	var g = gp(_g("SCARE_GHOSTS"), k); var cd = gp(Sc, "cd")
	if not J.t(g) or n_(gp(cd, k)) > 0: return
	var cost = or_(gp(g, "cost"), 35.0); var aoe = J.t(gp(g, "aoe"))
	if n_(gp(Sc, "mana")) < cost: toast(Sc, "陰氣不夠，等一下"); return
	if not aoe and (not J.t(n) or J.t(gp(n, "gone"))): toast(Sc, "先點一個人"); return
	if not aoe and J.t(gp(n, "out")): toast(Sc, J.str(gp(D(n), "name")) + "不在"); return
	var gq = n_(gpq(Sc, k)); J.sp(Sc, "mana", n_(gp(Sc, "mana")) - cost); J.sp(cd, k, jround(22 / (1 + 0.25 * (gq - 1)) * 10) / 10)
	var gx: float; var gy: float
	if aoe: gx = (n_(gp(Sc, "camX")) + view_w(Sc) / 2) if pano(Sc) else 0.5; gy = 0.45
	else:
		var nx = n_(gp(n, "x"))
		gx = nx + ((-0.13 if pt(Sc, nx, 0.0)[0] > n_(gp(Sc, "W")) / 2 else 0.13) if pano(Sc) else (-0.13 if nx > 0.5 else 0.13)); gy = n_(gp(n, "y"))
	gp(Sc, "fx").append({"kind": "ghost", "ghost": k, "life": 2.4, "max": 2.4, "gx": gx, "gy": gy, "n": n, "sig": gp(g, "fx"), "sigText": gp(g, "fxText"), "col": gp(g, "col")})
	if not hl(Sc):
		snd("skill"); J.sp(Sc, "shake", 1.0); J.sp(Sc, "vign", 1.0)
		if office(Sc):
			var fo = func():
				if J.t(gp(Sc, "active")): J.mc(_g("OFFICE"), "onScare", [gx, gy, 0.75 if aoe else 1.0])
			later(Sc, fo, 0.5 if aoe else 0.9)
	var tg = []
	if aoe:
		for m in npcs(Sc): if not J.t(gp(m, "gone")) and not J.t(gp(m, "out")) and not J.t(gp(m, "fleeing")): tg.append(m)
	else: tg = [n]
	if aoe and not hl(Sc): flt(Sc, 0.5, 0.4, gp(g, "line"), "#e8c8ff", 2.2)
	J.sp(Sc, "_src", gx); J.sp(Sc, "_dl", 0.5 if aoe else 0.9)
	J.sp(Sc, "_ghost", k); J.sp(Sc, "_vis", true); J.sp(Sc, "_aoe", aoe)
	var Lf = _g("L")
	for m in tg: hit(Sc, m, ghost_type(Sc, k, m), jround(n_(gp(g, "base")) * (1 + 0.35 * (gq - 1))), 3.0, null if aoe else (J.cl(Lf, null, [gp(g, "line")]) if Lf != null else gp(g, "line")), not aoe)
	J.sp(Sc, "_ghost", null); J.sp(Sc, "_src", null); J.sp(Sc, "_dl", 0.0); J.sp(Sc, "_vis", false); J.sp(Sc, "_aoe", false)
	if aoe:
		wake_guard(Sc, null); expose(Sc, E("aoe"), null)
		if not hl(Sc): flt(Sc, 0.5, 0.33, "全場都見到：冇人會話佢哋黐線", "#c9b8ff", 2.2)

static func _known(Sc, k):
	if not J.t(gp(Sc, "known")): J.sp(Sc, "known", {})
	var K = gp(Sc, "known")
	if not J.t(gp(K, k)): J.sp(K, k, J.new_("Set", []))
	return gp(K, k)
static func hit(Sc, n, type, base: float, tier: float, ghostLine = null, direct = null) -> void:
	var d = D(n); var grp = J.t(gp(Sc, "_group")); var dk = gp(d, "k"); var ty = J.str(type)
	var GI = gp(_g("GROUP_IMMUNE"), dk)
	if grp and J.t(GI):
		var t2 = gp(GI, type); bubble(Sc, n, t2 if J.t(t2) else gp(GI, "light"), 2.4); flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.2, "慣咗，唔怕", "#9ab")
		if not hl(Sc): mc(Sc, "react", [n, "sip" if J.t(gp(d, "guard")) else "numb"])
		return
	if J.t(gp(d, "guard")):
		bubble(Sc, n, gp(gp(d, "say"), "immune"), 2.0); mc(Sc, "react", [n, "sip"])
		if J.t(direct) and not J.t(gp(Sc, "guardKarma")): J.sp(Sc, "guardKarma", true); add_karma(Sc, d, -1.0, "嚇保安阿伯：他倒了一杯茶給你。")
		return
	var bf = gp(d, "backfire")
	if J.t(bf) and J.t(gp(bf, type)):
		J.sp(Sc, "kpi", maxf(0.0, n_(gp(Sc, "kpi")) - 15)); bubble(Sc, n, gp(bf, type), 2.4); flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.2, "好評 -15", "#ff8a7a"); return
	var w = A_(gp(d, "weak")).has(type); var im = A_(gp(d, "immune")).has(type)
	if not J.t(gp(n, "hab")): J.sp(n, "hab", {})
	var habd = gp(n, "hab"); var hab = or_(gp(habd, type), 0.0); J.sp(habd, type, hab + 1)
	var sh = or_(gp(n, "shaken"), 0.0) > 0
	if im:
		J.mc(_known(Sc, dk), "add", [type])
		var imm = gp(d, "imm"); var L = gp(imm, type) if J.t(imm) and J.t(gp(imm, type)) else gp(gp(d, "say"), "immune")
		bubble(Sc, n, L, 2.4); var fw = gp(_g("FEAR_WORD"), type)
		flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.2, (J.str(fw) if J.t(fw) else ty) + "？唔怕！", "#9ab", 1.6)
		if not hl(Sc): mc(Sc, "react", [n, "rational", {"delay": _dl(Sc)}])
		if J.t(gp(Sc, "_vis")) and not J.t(gp(Sc, "_aoe")) and not grp and witnesses(Sc, n).size(): expose(Sc, E("seen") / 2, n)
		return
	var KS = _known(Sc, dk)
	if not J.t(J.mc(KS, "has", [type])):
		J.mc(KS, "add", [type])
		if not hl(Sc) and is_same(n, gp(Sc, "sel")) and w:
			mc(Sc, "renderTarget"); flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.34, "發現：" + J.str(gp(d, "name")) + "怕" + J.str(gp(_g("FEAR_WORD"), type)) + "！", "#ffb070", 1.8)
	var m = ((F("weakSmall") if tier < 3 else 2.0) if w else (FM("small") if tier < 3 else FM("big"))) * maxf(F("habMin"), pow(F("habMul"), hab)) * (F("gain") if tier < 3 else 1.0) * (F("shakenMul") if sh else 1.0) / (1 + F("spread") * maxf(0.0, or_(gp(Sc, "_nt"), 1.0) - 1))
	var rational = false; var burst = false
	var before = n_(gp(n, "fear"))
	if tier == 3:
		if before < 25 and not sh: m *= 0.45; rational = true
		elif before < 50: m *= 1.35
		else: m *= F("burstMul"); burst = true
	var combo = minf(4.0, or_(gp(n, "combo"), 0.0) + 1) if t_(Sc) - (-99.0 if gp(n, "comboT") == null else n_(gp(n, "comboT"))) < F("combo") else 0.0
	if not im and not rational: m *= 1 + minf(F("comboMax"), combo * F("comboStep"))
	var g = null
	for x in npcs(Sc): if J.t(gp(D(x), "guard")) and live(x): g = x; break
	var aoe = J.t(gp(Sc, "_aoe"))
	var wits = [] if aoe or grp else witnesses(Sc, n)
	var seen = not aoe and not grp and J.t(gp(Sc, "_vis")) and wits.size() > 0
	var anyh = false
	for x in hearers(Sc, n): if not J.t(gp(D(x), "guard")): anyh = true; break
	var alone = not aoe and not anyh; var mk = minf(4.0, or_(gp(n, "mocked"), 0.0))
	m *= (F("aoeMul") if aoe else 1.0) * (F("groupMul") if grp else (F("uneasyMul") if n_(gp(n, "uneasy")) > 0 else 1.0)) * (F("seenMul") if seen else 1.0) * (F("alone") if alone and not grp else 1.0) * (1 + (0.0 if grp else F("mockMul") * mk))
	if grp: J.sp(n, "uneasy", F("uneasy"))
	var pts = jround(base * m)
	var cap = F("shakenCap") if sh else (F("smallCap") if w else F("plainCap"))
	if tier < 3: pts = maxf(0.0, jround(minf(pts, cap - before)))
	J.sp(n, "fear", n_(gp(n, "fear")) + pts); J.sp(n, "bounce", 1.0 if pts > 0 else 0.3); J.sp(n, "barHit", 1.0 if pts > 0 else 0.0)
	if pts >= 6 and not rational: J.sp(n, "combo", combo); J.sp(n, "comboT", gp(Sc, "t"))
	else: J.sp(n, "combo", 0.0)
	var oldPeak = minf(100.0, n_(gp(n, "peak"))); J.sp(n, "peak", maxf(n_(gp(n, "peak")), n_(gp(n, "fear")))); var gain = jround(minf(100.0, n_(gp(n, "peak"))) - oldPeak)
	var clean = burst and pts >= 20 and not seen and not aoe and not grp
	if clean: gain += F("burstBonus")
	if clean and combo >= 1: gain += F("comboPts") * 2 * combo
	if clean and mk >= 2:
		var b = F("noBelieve") * mk; gain += b; flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.34, "無人信佢！+" + J.str(b), "#d08cff", 2.0)
	J.sp(Sc, "kpi", n_(gp(Sc, "kpi")) + gain); J.sp(Sc, "_hab", hab)
	if _g("ScareX") != null:
		var gh = gp(Sc, "_ghost")
		J.mc(_g("ScareX"), "onHit", [Sc, n, {"type": type, "pts": pts, "gain": gain, "clean": clean, "mk": mk, "alone": alone, "seen": seen, "burst": burst, "tier": tier, "ghost": gh if J.t(gh) else "afu"}])
	if rational and not J.t(gp(Sc, "_aoe")): expose(Sc, E("blatant"), n)
	if J.t(gp(d, "daoshi")) and pts > 0:
		J.sp(n, "prog", maxf(0.0, or_(gp(n, "prog"), 0.0) - pts / 100 * 0.5))
		if not hl(Sc): flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.34, "做法被打斷！", "#ffd36a", 1.4)
	if not grp: perceive(Sc, n, pts, rational, seen, wits, aoe, alone)
	var say = gp(d, "say"); var line
	if rational: line = pick(A_(gp(say, "rational")))
	elif w and (ty == "phone" or ty == "paper" or tier == 3): line = gp(say, "weak")
	elif n_(gp(n, "fear")) >= 50: line = pick(A_(gp(say, "hit")))
	elif pts > 0: line = pick(A_(gp(say, "prime")))
	else: line = "（習慣了）"
	if J.t(ghostLine) and not rational: bubble(Sc, n, ghostLine, 1.2, true)
	if hl(Sc): bubble(Sc, n, line, 2.2)
	else:
		var fl = func(): bubble(Sc, n, line, 2.2)
		later(Sc, fl, _dl(Sc))
	var tag = "　穿崩！" if seen else ("　（全場都見到）" if burst and pts >= 20 and aoe else ("　爆點！" if burst and pts >= 20 else ("　還沒鋪墊" if rational else ("　小動靜不夠，出大招！" if tier < 3 and before >= cap else ("　有點習慣了" if hab >= 2 else ("　怕！" if w else ("　不怕" if im else ("　餘悸未消" if sh else ""))))))))
	flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.2, ("恐懼 +" + J.str(pts) if pts > 0 else "沒反應") + tag, "#ff9a5a" if burst else ("#ffb070" if w else ("#ffe08a" if gain > 0 else "#9ab")))
	if combo >= 1 and pts >= 6 and not rational: flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.27, "連擊 ×" + J.str(combo + 1), "#ff7ad0", 1.4)
	if not hl(Sc) and pts >= 12:
		var pp = pts; var fs = func(): J.sp(Sc, "shake", maxf(n_(gp(Sc, "shake")), minf(0.7, pp / 60)))
		later(Sc, fs, _dl(Sc))
	if not hl(Sc) and n_(gp(n, "fear")) >= 25:
		for i in 3:
			var px = n_(gp(n, "x")) + (randf() - 0.5) * 0.05; var vx = (randf() - 0.5) * 0.08
			gp(Sc, "parts").append({"kind": "sweat", "x": px, "y": n_(gp(n, "y")) - 0.17, "vx": vx, "vy": -0.1, "g": 0.5, "life": 0.8, "delay": _dl(Sc)})
	if g != null and same_room(Sc, g, n) and hyp(n_(gp(g, "x")) - n_(gp(n, "x")), n_(gp(g, "y")) - n_(gp(n, "y"))) < 0.24 and pts > 15:
		J.sp(n, "fear", maxf(0.0, n_(gp(n, "fear")) - F("guardCalm")))
		var gg = g
		if hl(Sc): bubble(Sc, gg, gp(gp(D(gg), "say"), "calmOther"), 2.0)
		else:
			var fg = func(): bubble(Sc, gg, gp(gp(D(gg), "say"), "calmOther"), 2.0)
			later(Sc, fg, 0.6 + _dl(Sc)); mc(Sc, "react", [gg, "sip", {"delay": 0.6 + _dl(Sc), "dur": 2.8}])
		flt(Sc, gp(g, "x"), n_(gp(g, "y")) - 0.22, "阿伯在旁邊壯膽", "#9ad")
	if not hl(Sc):
		var fr = n_(gp(n, "fear"))
		var kk = "burst" if fr >= 100 or (burst and pts >= 20) else ("numb" if im or pts <= 0 else ("rational" if rational else ("startle" if tier == 3 else ("weakjump" if w else ("startle" if fr >= 50 else "flinch")))))
		if w and pts > 0 and not rational:
			var fsc = func():
				J.sp(n, "scream", maxf(or_(gp(n, "scream"), 0.0), 1.1)); J.sp(Sc, "shake", maxf(n_(gp(Sc, "shake")), 0.5))
			later(Sc, fsc, _dl(Sc))
		mc(Sc, "react", [n, kk, {"delay": _dl(Sc), "src": gp(Sc, "_src"), "big": tier == 3}])
		if kk == "burst":
			var fb = func(): J.sp(Sc, "shake", maxf(n_(gp(Sc, "shake")), 0.9))
			later(Sc, fb, _dl(Sc))
	if n_(gp(n, "fear")) >= 100 and not J.t(gp(n, "fleeing")):
		J.sp(n, "fleeing", true); J.sp(Sc, "kpi", n_(gp(Sc, "kpi")) + 120); flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.3, "嚇跑了！+120", "#ff6a5a", 2.0); add_karma(Sc, d, gp(d, "karma"), gp(say, "flee"))
		if not hl(Sc):
			snd("heartbeat"); J.sp(Sc, "shake", 0.6); J.sp(n, "fleeT", gp(Sc, "t")); J.sp(n, "fleeHold", _dl(Sc) + 0.4); J.sp(n, "trail", [[gp(Sc, "t"), gp(n, "x"), gp(n, "y")]])
			var fsh = func():
				var sx = gp(say, "shout"); bubble(Sc, n, sx if J.t(sx) else "哇啊啊啊——！", 2.0)
			later(Sc, fsh, 1.2)

static func perceive(Sc, n, pts: float, rational: bool, seen: bool, wits: Array, aoe: bool, alone: bool) -> void:
	var dl0 = _dl(Sc)
	if aoe: J.sp(n, "mocked", 0.0); return
	if seen:
		J.sp(n, "mocked", 0.0); J.sp(Sc, "kpi", maxf(0.0, n_(gp(Sc, "kpi")) - F("seenPen"))); var w0 = wits[0] if wits.size() else null
		var N = gp(Sc, "night")
		if J.t(N):
			J.sp(N, "seen", n_(gp(N, "seen")) + 1)
			for w in wits: if J.t(gp(D(w), "influencer")): J.sp(N, "filmed", n_(gp(N, "filmed")) + 1); break
		expose(Sc, E("seen") + E("perWit") * (wits.size() - 1) + (E("repeat") if or_(gp(Sc, "_hab"), 0.0) >= 1 else 0.0), n)
		var names = PackedStringArray()
		for w in wits: names.append(J.str(gp(D(w), "name")))
		flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.3, "穿崩！" + "、".join(names) + "望到 −" + J.str(F("seenPen")), "#ff8a7a", 2.0)
		for w in wits:
			if J.t(gp(D(w), "guard")): continue
			J.sp(w, "fear", maxf(n_(gp(w, "fear")), minf(99.0, n_(gp(w, "fear")) + F("witFear")))); J.sp(w, "peak", maxf(n_(gp(w, "peak")), n_(gp(w, "fear"))))
			var ww = w; var fw2 = func(): bubble(Sc, ww, pick(A_(_g("WIT_SAY"))), 2.0)
			_lat(Sc, fw2, dl0 + 0.5)
			if not hl(Sc): mc(Sc, "react", [w, "startle", {"delay": dl0 + 0.4, "src": gp(n, "x")}])
		if w0 != null: wake_guard(Sc, n)
		return
	if pts < 8 or rational or J.t(gp(n, "fleeing")) or n_(gp(n, "fear")) >= 100: return
	var mk = []
	for m in hearers(Sc, n): if not J.t(gp(D(m), "guard")) and not (n_(gp(m, "fear")) >= 50): mk.append(m)
	var nx = n_(gp(n, "x")); var ny = n_(gp(n, "y"))
	mk = A_(J.mc(mk, "sort", [func(_t, a): return hyp(n_(gp(a[0], "x")) - nx, n_(gp(a[0], "y")) - ny) - hyp(n_(gp(a[1], "x")) - nx, n_(gp(a[1], "y")) - ny)])).slice(0, 2)
	if mk.is_empty():
		if alone: flt(Sc, gp(n, "x"), n_(gp(n, "y")) - 0.27, "冇人喺度 ×1.2", "#9fe0c0", 1.4)
		return
	J.sp(n, "mocked", minf(5.0, or_(gp(n, "mocked"), 0.0) + 1)); J.sp(n, "fear", maxf(n_(gp(n, "fear")), minf(99.0, n_(gp(n, "fear")) + F("mockFear")))); J.sp(n, "peak", maxf(n_(gp(n, "peak")), n_(gp(n, "fear")))); J.sp(Sc, "kpi", n_(gp(Sc, "kpi")) + F("mockPts"))
	for i in mk.size():
		var m = mk[i]
		var fm = func():
			var L = gp(_g("MOCK_SAY"), gp(D(m), "k")); bubble(Sc, m, pick(A_(L)) if J.t(L) else "你又發乜神經？", 2.4)
			if J.t(gp(m, "mis")) and J.str(gp(D(m), "k")) == "mis":
				var mm = gp(m, "mis"); J.sp(mm, "act", "roll"); J.sp(mm, "at", 0.0); J.sp(mm, "dur", 1.8)
			J.sp(m, "dir", 1.0 if n_(gp(n, "x")) > n_(gp(m, "x")) else -1.0)
		_lat(Sc, fm, dl0 + 1 + i * 0.7)
	if n_(gp(n, "mocked")) >= 2:
		var fp = func():
			if not J.t(gp(n, "fleeing")): bubble(Sc, n, pick(A_(_g("PARA_SAY"))), 2.2)
		_lat(Sc, fp, dl0 + 2.6)

# ================= 第四段：點擊、出招列、人物卡、偷看手機、hud、提示字、粒子 =================
static func Q(sel: String): return J.cl(_g("$"), null, [sel])
static func qsa(el, sel: String) -> Array: return J.iter(J.mc(el, "querySelectorAll", [sel])) if el != null else []
static func fw(t) -> String: var w = gp(_g("FEAR_WORD"), t); return J.str(w)

static func tap(Sc, e) -> void:
	if J.t(gp(Sc, "paused")) or J.t(gp(Sc, "endAt")): return
	var r = {"left": 0.0, "top": 0.0} if J.t(gp(Sc, "_nat")) else J.mc(Q("#sc-cvs"), "getBoundingClientRect", [])
	var mx = n_(gp(e, "clientX")) - n_(gp(r, "left")); var my = n_(gp(e, "clientY")) - n_(gp(r, "top"))
	var ed = gp(Sc, "_edge")
	if J.t(ed) and mx > n_(ed[0]) and mx < n_(ed[0]) + n_(ed[2]) and my > n_(ed[1]) and my < n_(ed[1]) + n_(ed[3]):
		var en = ed[4]; J.sp(Sc, "camTo", clamp_cam(Sc, n_(gp(en, "x")) - view_w(Sc) / 2)); J.sp(Sc, "userPan", -99.0); return
	var best = null; var bd = 1e9; var of = office(Sc)
	for n in npcs(Sc):
		if J.t(gp(n, "gone")) or J.t(gp(n, "out")): continue
		var p = pt(Sc, n_(gp(n, "x")) + (n_(J.mc(_g("OFFICE"), "kenOff", [n])) if of else 0.0), n_(gp(n, "y"))); var x = p[0]; var y = p[1]; var h = hh(Sc, n_(gp(n, "y")))
		if mx > x - h * 0.32 and mx < x + h * 0.32 and my > y - h and my < y + 6:
			var dd = absf(mx - x) + absf(my - (y - h / 2)) * 0.3
			if dd < bd: bd = dd; best = n
	if J.t(gp(Sc, "armed")) and best != null:
		var k = gp(Sc, "armed"); J.sp(Sc, "armed", null); mc(Sc, "useGhost", [k, best]); J.sp(Sc, "sel", best); J.sp(Sc, "selAuto", false); mc(Sc, "renderDock"); mc(Sc, "renderTarget"); return
	if best != null: J.sp(Sc, "sel", best); J.sp(Sc, "selAuto", false); mc(Sc, "renderTarget"); return
	var SP = _g("SCARE_PROPS")
	for k in J.keys(SP):
		var p = gp(SP, k)
		if J.t(gp(p, "group")): continue
		var rc = gp(p, "rect"); var a = pt(Sc, n_(rc[0]), n_(rc[1])); var b = pt(Sc, n_(rc[0]) + n_(rc[2]), n_(rc[1]) + n_(rc[3]))
		if mx > a[0] - 10 and mx < b[0] + 10 and my > a[1] - 10 and my < b[1] + 10: mc(Sc, "useProp", [k]); return
	if J.t(gp(Sc, "armed")):
		var g = gp(_g("SCARE_GHOSTS"), gp(Sc, "armed"))
		if J.t(gp(g, "aoe")):
			var k2 = gp(Sc, "armed"); J.sp(Sc, "armed", null); mc(Sc, "useGhost", [k2]); mc(Sc, "renderDock")

static func render_dock(Sc) -> void:
	var SP = _g("SCARE_PROPS"); var SG = _g("SCARE_GHOSTS")
	var room = "<div style=\"display:flex;flex-direction:column;gap:5px;flex:0 0 76px\">"
	for k in ["lights", "ac"]: room += "<button class=\"btn sm sc-room\" data-p=\"%s\" style=\"padding:5px 2px;font-size:12px;line-height:1.25;width:100%%\"><b>%s</b><br><small>%s・%s</small></button>" % [k, J.str(gp(gp(SP, k), "name")), "呢間房" if pano(Sc) else "全場", J.str(gp(gp(SP, k), "cost"))]
	room += "</div>"
	var h = ""
	for k in A_(gp(Sc, "team")):
		var g = gp(SG, k); var c = gp(gp(Sc, "caught"), k)
		var ts = A_(gp(g, "types")) if J.t(gp(g, "types")) else [gp(g, "type")]
		var tw = PackedStringArray()
		for t in ts:
			var w = gp(_g("FEAR_WORD"), t); tw.append(J.str(w).right(2) if J.t(w) else J.str(t))
		h += "<button class=\"sc-gb %s %s\" data-k=\"%s\"><canvas data-por=\"%s\"></canvas><i class=\"cd\"></i><b>%s</b><small>%s</small></button>" % ["arm" if J.seq(gp(Sc, "armed"), k) else "", "caught" if J.t(c) else "", J.str(k), J.str(k), J.str(gp(g, "skill")),
			"喝茶中" if J.t(c) else J.str(gp(g, "name")) + "・" + "／".join(tw) + ("・全場" if J.t(gp(g, "aoe")) else "")]
	var dock = Q("#sc-dock")
	J.sp(dock, "innerHTML", room + h)
	J.cl(_g("paintPortraits"), null, [Q("#sc-dock")])
	for b in qsa(Q("#sc-dock"), ".sc-room"):
		var bb = b
		J.sp(bb, "onclick", func(_t = null, _a2 = null):
			if J.t(gp(Sc, "paused")) or J.t(gp(Sc, "endAt")): return null
			mc(Sc, "useProp", [gp(gp(bb, "dataset"), "p")]); return null)
	for b in qsa(Q("#sc-dock"), ".sc-gb"):
		var bb = b
		J.sp(bb, "onclick", func(_t = null, _a2 = null):
			var k = gp(gp(bb, "dataset"), "k")
			if J.t(gp(gp(Sc, "caught"), k)) or n_(gp(gp(Sc, "cd"), k)) > 0 or J.t(gp(Sc, "paused")) or J.t(gp(Sc, "endAt")): return null
			var g = gp(_g("SCARE_GHOSTS"), k); var sel = gp(Sc, "sel")
			if J.t(gp(g, "aoe")): mc(Sc, "useGhost", [k]); J.sp(Sc, "armed", null)
			elif J.t(sel) and not J.t(gp(sel, "gone")) and not J.t(gp(sel, "out")) and not J.t(gp(D(sel), "guard")): mc(Sc, "useGhost", [k, sel]); J.sp(Sc, "armed", null)
			else:
				J.sp(Sc, "armed", null if J.seq(gp(Sc, "armed"), k) else k); toast(Sc, "點一個人")
			mc(Sc, "renderDock"); return null)

static func render_target(Sc) -> void:
	var s0 = gp(Sc, "sel")
	var n = s0 if J.t(s0) and not J.t(gp(s0, "gone")) and not J.t(gp(s0, "fleeing")) else null
	var off = "disabled" if n != null and J.t(gp(n, "out")) else ""
	J.sp(Sc, "_selOut", n != null and J.t(gp(n, "out")))
	var html = "<div class=\"sc-who\"><small>點場景裡的人，或發光的東西。</small></div>"
	if n != null:
		var d = D(n)
		html = "<div class=\"sc-who\"><b>%s</b><small>%s</small>%s<button class=\"btn sm gold\" id=\"sc-br\" %s>背後呼氣</button></div><div class=\"sc-prof\" style=\"font-size:13px;line-height:1.5;padding:4px 2px 2px;opacity:.95\">%s</div>" % [
			J.str(gp(d, "name")), ("已經走了" if J.t(gp(n, "left")) else "暫時不在") if J.t(gp(n, "out")) else J.str(gp(d, "role")),
			("<button class=\"btn sm\" id=\"sc-peek\">偷看手機</button><button class=\"btn sm gold\" id=\"sc-wa\" %s>傳訊息</button>" % off) if J.t(gp(d, "phone")) else "", off, J.str(mc(Sc, "profile", [n]))]
	J.sp(Q("#sc-target"), "innerHTML", html)
	if n != null and J.t(gp(D(n), "phone")):
		J.sp(Q("#sc-peek"), "onclick", func(_t = null, _a2 = null): mc(Sc, "peek", [n]); return null)
		J.sp(Q("#sc-wa"), "onclick", func(_t = null, _a2 = null): mc(Sc, "usePhone", [n]); return null)
	if n != null: J.sp(Q("#sc-br"), "onclick", func(_t = null, _a2 = null): mc(Sc, "useBreath", [n]); return null)

static func profile(Sc, n) -> String:
	var d = D(n)
	if J.t(gp(d, "guard")): return "怕：<b>乜都唔怕</b>（做咗三十年夜班）"
	var kn = gp(Sc, "known"); var K = gp(kn, gp(d, "k")) if J.t(kn) else null
	if not J.t(K): K = J.new_("Set", [])
	var hid = A_(gp(d, "hide")) if J.t(gp(d, "hide")) else []
	var w = PackedStringArray()
	for t in A_(gp(d, "weak")): w.append("？" if hid.has(t) and not J.t(J.mc(K, "has", [t])) else fw(t))
	var im = PackedStringArray()
	for t in A_(gp(d, "immune")): im.append(fw(t))
	var ims = "、".join(im)
	return "怕：<b style=\"color:#ffb070\">%s</b>　唔怕：<b style=\"color:#9ab\">%s</b>%s" % ["、".join(w), ims if ims != "" else "—", "（全場燈／冷氣都唔怕）" if J.t(gp(_g("GROUP_IMMUNE"), gp(d, "k"))) else ""]

static func peek(Sc, n) -> void:
	var d = D(n); var K = _known(Sc, gp(d, "k"))
	for t in (A_(gp(d, "hide")) if J.t(gp(d, "hide")) else []): J.mc(K, "add", [t])
	mc(Sc, "renderTarget")
	J.sp(Sc, "paused", true)
	var p = Q("#sc-phone"); var ms = ""
	for m in A_(gp(d, "chat")): ms += "<div class=\"sc-m %s\"><i>%s・%s</i>%s</div>" % ["me" if J.seq(m[0], gp(d, "name")) else "", J.str(m[0]), J.str(m[1]), J.str(m[2])]
	J.sp(p, "innerHTML", "<div class=\"sc-ph\"><div class=\"sc-ph-h\">%s 的手機<button id=\"sc-ph-x\">✕</button></div><div class=\"sc-ph-b\">%s</div><div class=\"sc-ph-f\">偷看的時候，時間是停的。</div></div>" % [J.str(gp(d, "name")), ms])
	J.mc(gp(p, "classList"), "add", ["on"])
	J.sp(Q("#sc-ph-x"), "onclick", func(_t = null, _a2 = null):
		J.mc(gp(p, "classList"), "remove", ["on"]); J.sp(Sc, "paused", false); J.sp(Sc, "last", J.S_performance_("now", [])); return null)

static func hud(Sc) -> void:
	var sel = gp(Sc, "sel")
	if J.t(sel) and (J.t(gp(sel, "gone")) or J.t(gp(sel, "fleeing")) or (J.t(gp(sel, "left")) and J.t(gp(sel, "out")))):
		var ok = []
		for n in npcs(Sc): if live(n) and not J.t(gp(n, "fleeing")) and not J.t(gp(D(n), "guard")): ok.append(n)
		var pick_ = null
		for n in ok:
			if on_screen(Sc, n_(gp(n, "vX")) if gp(n, "vX") != null else n_(gp(n, "x")), 0.0): pick_ = n; break
		if pick_ == null: pick_ = ok[0] if ok.size() else null
		J.sp(Sc, "sel", pick_); J.sp(Sc, "selAuto", true); mc(Sc, "renderTarget")
	elif J.t(sel) and J.t(gp(sel, "out")) != J.t(gp(Sc, "_selOut")): mc(Sc, "renderTarget")
	var mins = minf(360.0, floor(t_(Sc) / n_(_g("NIGHT_SEC")) * 360))
	var hs = str(int(floor(mins / 60))).pad_zeros(2); var ms = str(int(floor(fmod(mins, 60.0) / 10) * 10)).pad_zeros(2)
	if J.t(gp(Sc, "_nat")): return
	J.sp(Q("#sc-clock"), "textContent", hs + ":" + ms); J.sp(Q("#sc-kpi"), "textContent", "驚嚇 " + J.str(gp(Sc, "kpi")))
	J.sp(gp(Q("#sc-mana i"), "style"), "width", J.str(gp(Sc, "mana")) + "%")
	if pano(Sc): J.mc(OM(), "mapTick", [Sc])
	var SP = _g("SCARE_PROPS")
	for b in qsa(Q("#sc-dock"), ".sc-room"):
		var k = gp(gp(b, "dataset"), "p"); var pcd = gp(Sc, "pcd"); var c = or_(gp(pcd, k), 0.0) if J.t(pcd) else 0.0
		J.sp(J.mc(b, "querySelector", ["small"]), "textContent", ("冷卻 " + J.str(ceil(c)) + " 秒") if c > 0 else ((J.str(gp(cam_room(Sc), "name")) if pano(Sc) else "全場") + "・" + J.str(gp(gp(SP, k), "cost"))))
		J.sp(gp(b, "style"), "opacity", 0.5 if c > 0 or n_(gp(Sc, "mana")) < n_(gp(gp(SP, k), "cost")) else 1.0)
	for b in qsa(Q("#sc-dock"), ".sc-gb"):
		var k = gp(gp(b, "dataset"), "k"); var c = gp(gp(Sc, "cd"), k); var ca = J.t(gp(gp(Sc, "caught"), k))
		J.mc(gp(b, "classList"), "toggle", ["cool", n_(c) > 0 and not ca])
		J.sp(gp(J.mc(b, "querySelector", [".cd"]), "style"), "height", J.str(100.0 if ca else n_(c) / 22 * 100) + "%")
		var g = gp(_g("SCARE_GHOSTS"), k)
		J.mc(gp(b, "classList"), "toggle", ["low", n_(gp(Sc, "mana")) < (or_(gp(g, "cost"), 35.0) if J.t(g) else 35.0)])

static func float_tick(Sc, dt: float) -> void:
	var fl = []
	for f in A_(gp(Sc, "floats")):
		J.sp(f, "life", n_(gp(f, "life")) - dt)
		if n_(gp(f, "life")) > 0.02: fl.append(f)
	J.sp(Sc, "floats", fl)
	var fq = gp(Sc, "fq")
	if fl.is_empty() and J.t(fq) and A_(fq).size():
		var f = A_(fq).pop_front(); var v = 0.9 if A_(fq).size() else n_(gp(f, "max"))
		J.sp(f, "max", v); J.sp(f, "life", v); fl.append(f)
static func float_(Sc, _x, _y, text, color, life) -> void:
	if hl(Sc): return
	if not J.t(gp(Sc, "fq")): J.sp(Sc, "fq", [])
	var fq = A_(gp(Sc, "fq")); var l = minf(1.6, n_(life) if J.t(life) else 1.3)
	fq.append({"text": text, "color": color, "life": l, "max": l})
	if fq.size() > 3: fq.pop_front()
static func toast_(Sc, t) -> void:
	if not hl(Sc): float_(Sc, 0.5, 0.5, t, "#fff", 1.2)
static func float_old(Sc, x, y, text, color, life) -> void:
	var l = n_(life) if J.t(life) else 1.6
	A_(gp(Sc, "floats")).append({"x": x, "y": y, "text": text, "color": color, "life": l, "max": l})
static func dust(Sc, n) -> void:
	if J.t(gp(n, "fleeT")) and t_(Sc) - n_(gp(n, "fleeT")) < n_(gp(n, "fleeHold")): return
	var x = n_(gp(n, "vX")) if gp(n, "vX") != null else n_(gp(n, "x")); var y = gp(n, "vY") if gp(n, "vY") != null else gp(n, "y"); var dir = n_(gp(n, "dir"))
	A_(gp(Sc, "parts")).append({"kind": "dust", "x": x - dir * 0.03, "y": y, "vx": -dir * 0.05, "vy": -0.03, "life": 0.6})
static func prop_parts(Sc, k, p, n) -> void:
	var rc = gp(p, "rect"); var cx = n_(rc[0]) + n_(rc[2]) / 2; var cy = n_(rc[1]) + n_(rc[3]) / 2; var ks = J.str(k)
	var P = A_(gp(Sc, "parts"))
	if ks == "printer" and not office(Sc):
		for i in 14:
			var vx = (randf() - 0.7) * 0.35; var vy = -0.15 - randf() * 0.25; var vr = (randf() - 0.5) * 9; var life = 1.6 + randf()
			P.append({"kind": "paper", "x": cx, "y": cy, "vx": vx, "vy": vy, "g": 0.35, "vr": vr, "life": life})
	if ks == "ac" and not J.t(n):
		for i in 26:
			var x = n_(rc[0]) + randf() * n_(rc[2]); var vx = (randf() - 0.5) * 0.06; var vy = 0.05 + randf() * 0.12; var life = 2 + randf()
			P.append({"kind": "frost", "x": x, "y": n_(rc[1]) + n_(rc[3]), "vx": vx, "vy": vy, "life": life})
	if ks == "ac" and J.t(n):
		for i in 22:
			var hy = n_(gp(n, "y")) - hh_f(Sc, n_(gp(n, "y"))) * 1.05
			var x = n_(gp(n, "x")) + (randf() - 0.5) * 0.09; var y = hy - randf() * 0.03; var vx = (randf() - 0.5) * 0.04; var vy = 0.03 + randf() * 0.06; var life = 1.6 + randf(); var dl = randf() * 0.6
			P.append({"kind": "frost", "x": x, "y": y, "vx": vx, "vy": vy, "life": life, "delay": dl})
	if ks == "water":
		for i in 10:
			var x = cx + (randf() - 0.5) * 0.04; var vy = -0.04 - randf() * 0.05; var life = 1.2 + randf()
			P.append({"kind": "bubble", "x": x, "y": cy + 0.05, "vx": 0.0, "vy": vy, "life": life})

# ================= 第五段：人嘅動畫狀態（react、animNpc、onReact、rigOK、visPos、npcPose）=================
const RX_DUR := {"flinch": 0.5, "startle": 0.75, "weakjump": 0.95, "burst": 2.6, "rational": 1.6, "numb": 1.3, "sip": 2.6, "catch": 2.4, "chill": 2.4}
static func react(Sc, n, k, o) -> void:
	if hl(Sc) or not J.t(n): return
	if not J.t(o): o = {}
	var rx = gp(n, "rx"); var ks = J.str(k)
	if J.t(rx) and J.str(gp(rx, "k")) == "burst" and n_(gp(rx, "t")) < n_(gp(rx, "dur")) * 0.75 and ks != "burst": return
	var dur = gp(o, "dur")
	J.sp(n, "rx", {"k": k, "t": -or_(gp(o, "delay"), 0.0), "dur": n_(dur) if J.t(dur) else (RX_DUR[ks] if RX_DUR.has(ks) else 1.0), "src": gp(o, "src"), "big": J.t(gp(o, "big"))})
static func _vxy(n) -> Array:
	return [n_(gp(n, "vX")) if gp(n, "vX") != null else n_(gp(n, "x")), n_(gp(n, "vY")) if gp(n, "vY") != null else n_(gp(n, "y"))]
static func anim_npc(Sc, n, dt: float) -> void:
	J.sp(n, "at", or_(gp(n, "at"), 0.0) + dt * or_(gp(n, "spd"), 1.0))
	if _g("TOWN") != null: J.mc(_g("TOWN"), "npcTick", [n, dt])
	if office(Sc): J.mc(_g("OFFICE"), "kenTick", [n, dt])
	if J.t(gp(n, "rx")):
		var rx = gp(n, "rx"); J.sp(rx, "t", n_(gp(rx, "t")) + dt)
		if not J.t(gp(rx, "fired")) and n_(gp(rx, "t")) >= 0: J.sp(rx, "fired", true); on_react(Sc, n)
		rx = gp(n, "rx")
		if J.t(rx) and n_(gp(rx, "t")) >= n_(gp(rx, "dur")): J.sp(n, "rx", null)
	var f = n_(gp(n, "fear"))
	var lv = 3.0 if J.t(gp(n, "fleeing")) else (2.0 if f >= 50 else (1.0 if f >= 25 else 0.0))
	if lv > or_(gp(n, "lv"), 0.0):
		J.sp(n, "markPop", 0.5)
		if lv >= 1: J.sp(n, "goose", maxf(or_(gp(n, "goose"), 0.0), 1.2))
	J.sp(n, "lv", lv); J.sp(n, "markPop", or_(gp(n, "markPop"), 0.0) - dt * 2)
	for key in ["goose", "hair", "shock", "scream"]:
		if n_(gp(n, key)) > 0: J.sp(n, key, maxf(0.0, n_(gp(n, key)) - dt))
	if n_(gp(n, "barHit")) > 0: J.sp(n, "barHit", maxf(0.0, n_(gp(n, "barHit")) - dt * 2))
	if n_(gp(n, "shaken")) > 0 and not J.t(gp(n, "fleeing")) and randf() < dt * 0.9:
		var v0 = _vxy(n); var x = v0[0] + (randf() - 0.5) * 0.05; var vx = (randf() - 0.5) * 0.05
		A_(gp(Sc, "parts")).append({"kind": "sweat", "x": x, "y": v0[1] - 0.16, "vx": vx, "vy": -0.05, "g": 0.45, "life": 0.7})
	if J.t(gp(n, "fleeing")) and not J.t(gp(n, "gone")) and J.t(gp(n, "trail")): A_(gp(n, "trail")).append([gp(Sc, "t"), gp(n, "x"), gp(n, "y")])
	var v = _vxy(n)
	if not J.t(gp(n, "gone")) and f >= 50 and randf() < dt * (5.0 if f >= 80 else 2.2):
		var x2 = v[0] + (randf() - 0.5) * 0.06; var y2 = v[1] - 0.16 - randf() * 0.03; var vx2 = (randf() - 0.5) * 0.06
		A_(gp(Sc, "parts")).append({"kind": "sweat", "x": x2, "y": y2, "vx": vx2, "vy": -0.06, "g": 0.45, "life": 0.7})
static func on_react(Sc, n) -> void:
	var k = J.str(gp(gp(n, "rx"), "k")); var v = _vxy(n)
	if k == "startle" or k == "weakjump" or k == "burst":
		J.sp(n, "hair", 1.6 if k == "burst" else 1.0); J.sp(n, "goose", 1.6); J.sp(n, "shock", 0.5)
		for i in (7 if k == "burst" else 4):
			var a = -PI / 2 + (randf() - 0.5) * 2.2
			A_(gp(Sc, "parts")).append({"kind": "sweat", "x": v[0] + cos(a) * 0.03, "y": v[1] - 0.17, "vx": cos(a) * 0.16, "vy": sin(a) * 0.18, "g": 0.6, "life": 0.75})
	if k == "burst": J.sp(n, "scream", 1.8)
	if k == "flinch": J.sp(n, "shock", 0.28); J.sp(n, "goose", maxf(or_(gp(n, "goose"), 0.0), 0.8))
static func rig_ok(_Sc, type) -> bool:
	var A = _g("ART")
	if A == null: return false
	var P = _g("Puppet")
	if P != null and J.t(J.mc(P, "has", [type])): return true
	return J.t(gp(A, "hasRig")) and J.t(J.mc(A, "hasRig", [type]))
static func vis_pos(Sc, n) -> Array:
	var tr = gp(n, "trail")
	if not J.t(gp(n, "fleeT")) or not J.t(tr) or A_(tr).is_empty(): return [gp(n, "x"), gp(n, "y"), null]
	tr = A_(tr)
	var age = t_(Sc) - n_(gp(n, "fleeT")); var hold = or_(gp(n, "fleeHold"), 0.0)
	var lag = age if age < hold else hold * maxf(0.0, 1 - (age - hold) / 0.7); var ts = t_(Sc) - lag
	var i = tr.size() - 1
	while i > 0 and n_(tr[i][0]) > ts: i -= 1
	var x = n_(tr[i][1]); var y = n_(tr[i][2]); var dir = gp(n, "dir")
	if i < tr.size() - 1:
		var b = tr[i + 1]; var den = n_(b[0]) - n_(tr[i][0])
		var k = maxf(0.0, minf(1.0, (ts - n_(tr[i][0])) / (den if den != 0 else 1.0))); x += (n_(b[1]) - x) * k; y += (n_(b[2]) - y) * k
	elif J.t(gp(n, "gone")):
		var e = ts - n_(gp(n, "exitT"))
		if e > 0: x += e * 0.45; dir = 1.0
	return [x, y, dir]
static func npc_pose(Sc, n) -> Dictionary:
	var d = D(n); var f = n_(gp(n, "fear")); var rx0 = gp(n, "rx"); var rx = rx0 if J.t(rx0) and n_(gp(rx0, "t")) >= 0 else null
	var walking = J.str(gp(n, "act")) == "walk"
	var habit = false; var hb = gp(n, "hab")
	if J.t(hb):
		for k in J.keys(hb): if n_(gp(hb, k)) >= 1.5: habit = true; break
	var dk = J.str(gp(d, "k"))
	var calm = "b" if dk == "ken" or dk == "auntie" else (("q" if sin(or_(gp(n, "at"), 0.0) * 0.9) > 0.55 else "n") if dk == "boss" else "n")
	var o = {"pose": "idle", "face": "b" if habit and f < 25 else calm, "pt": 0.0, "walk": false, "src": null, "sx": 1.0, "sy": 1.0, "lift": 0.0, "jit": 0.0, "rot": 0.0, "spd": 1.0}
	if J.t(gp(n, "fleeing")):
		var age = t_(Sc) - or_(gp(n, "fleeT"), 0.0); var hold = or_(gp(n, "fleeHold"), 0.0)
		if age >= hold or J.t(gp(n, "gone")): return _as(o, {"pose": "run", "face": "t", "walk": true, "jit": 0.35, "spd": 2.2, "run": true})
		if age >= hold - 0.4:
			var p = (age - hold + 0.4) / 0.4
			return _as(o, {"pose": "startle", "pt": p, "face": "t", "lift": sin(p * PI) * 1.3, "sy": 1 + 0.14 * sin(p * PI), "sx": 1 / (1 + 0.14 * sin(p * PI)), "src": gp(rx0, "src") if J.t(rx0) else rx0})
	var act = J.str(gp(n, "act"))
	if walking:
		o["pose"] = "move"; o["walk"] = true
		if f >= 50: _as(o, {"face": "t" if f >= 80 else "f", "jit": 0.45, "spd": 0.75})
		elif f >= 25: o["face"] = "q"
	elif f >= 80: _as(o, {"pose": "cower", "face": "t", "jit": 0.8})
	elif f >= 50: _as(o, {"pose": "tremble", "face": "f", "jit": 0.3})
	elif f >= 25: _as(o, {"pose": "look", "face": "q"})
	elif act == "brk_nap": _as(o, {"pose": "idle", "face": "c", "doze": true})
	elif act == "brk_phone": _as(o, {"pose": "phone", "face": "b"})
	elif act == "brk_drink": _as(o, {"pose": "sip", "face": "c"})
	elif dk == "ken": _as(o, {"pose": "phone", "face": "b"})
	elif act == "mop": _as(o, {"pose": "mop", "face": "b"})
	elif J.t(gp(d, "daoshi")) and act == "ritual": o["pose"] = "ritual"
	elif J.t(gp(d, "guard")) and act == "doze": _as(o, {"pose": "idle", "face": "c", "doze": true})
	elif J.t(gp(d, "guard")): _as(o, {"pose": "look", "face": "n"})
	elif dk == "boss": o["pose"] = "hold"
	if f < 25 and not walking and not J.t(gp(n, "fleeing")) and _g("TOWN") != null and J.t(J.mc(_g("TOWN"), "actAnim", [n])): o["pose"] = gp(n, "act")
	if rx != null:
		var rt = n_(gp(rx, "t")); var rdur = n_(gp(rx, "dur")); var rk = J.str(gp(rx, "k"))
		var p = minf(1.0, rt / rdur); o["src"] = gp(rx, "src")
		var jump = func(A: float, mul: float):
			if rt < A: o["sx"] = 1.09; o["sy"] = 0.88; o["face"] = "s"; return
			var q = minf(1.0, (rt - A) / maxf(0.2, (0.55 if rk == "burst" else rdur) - A)); var up = sin(minf(1.0, q * 1.5) * PI)
			_as(o, {"pose": "startle", "pt": q, "walk": false, "face": "t" if rk == "burst" or (q > 0.4 and f >= 75) else "s", "lift": up * mul, "sy": 1 + 0.13 * up, "sx": 1 / (1 + 0.13 * up), "jit": 0.0})
		match rk:
			"flinch": _as(o, {"pose": "move" if o.walk else "hurt", "pt": p, "face": "s", "sx": 1 + 0.06 * (1 - p), "sy": 1 - 0.06 * (1 - p)})
			"startle": jump.call(0.08, 1.1 if J.t(gp(rx, "big")) else 0.75)
			"weakjump": jump.call(0.09, 1.5)
			"burst":
				if rt < 0.55: jump.call(0.07, 1.4)
				elif o.walk: _as(o, {"face": "t", "jit": 1.0, "spd": 1.6})
				else: _as(o, {"pose": "cower", "face": "t", "jit": 1.0, "pt": minf(1.0, (rt - 0.55) / 0.3)})
			"rational":
				var sh = sin(minf(1.0, rt / 0.55) * PI)
				_as(o, {"face": "q", "sy": 1 + 0.06 * sh, "sx": 1 - 0.02 * sh, "lift": 0.18 * sh, "rot": -0.06 * sh, "shrug": sh})
				if not o.walk: o["pose"] = "shrug"; o["pt"] = minf(1.0, rt / 0.9)
			"numb":
				o["face"] = "b"
				if not o.walk: o["pose"] = "phone" if dk == "ken" else ("mop" if J.t(gp(d, "mop")) else ("hold" if dk == "boss" else "idle"))
			"sip":
				if not o.walk: o["pose"] = "sip"
				o["face"] = "c"
			"catch": o["pose"] = "look"; o["face"] = "q"; o["walk"] = false
			"chill":
				var t2 = rt; var sh2 = 1 - t2 / 0.7 if t2 < 0.7 else 0.0
				var sq = minf(1.0, minf(absf(t2 - 0.9) / 0.12, absf(t2 - 1.9) / 0.12))
				_as(o, {"face": "s" if t2 < 0.7 else "q", "jit": 0.5 * sh2, "sy": 1 - 0.06 * sh2, "sx": (1 + 0.03 * sh2) * (0.45 + 0.55 * sq)})
				if not o.walk: o["pose"] = "tremble" if t2 < 0.7 else "look"
				o["turn"] = t2 > 0.9 and t2 < 1.9
				o["turnK"] = 0.0 if t2 < 0.9 else ((t2 - 0.9) / 0.25 if t2 < 1.15 else (1.0 if t2 < 1.65 else ((1 - (t2 - 1.65) / 0.25) if t2 < 1.9 else 0.0)))
		o["rxk"] = gp(rx, "k")
	return o
static func _as(o: Dictionary, b: Dictionary) -> Dictionary:
	for k in b: o[k] = b[k]
	return o

# ================= 第六段：畫（draw、drawEdge、drawBreath、propMarks、drawCue、drawNpc、drawNpcSprite、npcFx、drawTeam、drawGhost、drawBubble）=================
static func S(v) -> String: return J.str(v)
static func DC(ctx, k, x, y, sc, o) -> void: J.cl(_g("__scDC"), null, [ctx, k, x, y, sc, o])
static func spr_(k): return gp(_g("SPR"), k)
static func cl_(f, ctx) -> void: J.cl(f, null, [ctx])

static func draw(Sc, t: float) -> void:
	var nat = J.t(gp(Sc, "_nat")); var nc = gp(Sc, "_natCtx")
	if nat and not J.t(nc): return
	var c = null if J.t(nc) else Q("#sc-cvs")
	if not J.t(nc) and not J.t(c): return
	var ctx = nc if J.t(nc) else J.mc(c, "getContext", ["2d"])
	var dpr = n_(gp(Sc, "dpr")); ctx.setTransform(dpr, 0.0, 0.0, dpr, 0.0, 0.0)
	var b = bg_scale(Sc); var img = spr_("bg_" + S(gp(site(Sc), "bg"))); var W = n_(gp(Sc, "W")); var H = n_(gp(Sc, "H"))
	ctx.save()
	var shake = n_(gp(Sc, "shake"))
	if shake > 0:
		var tx = (randf() - 0.5) * 10 * shake; var ty = (randf() - 0.5) * 8 * shake; ctx.translate(tx, ty)
	ctx.fillStyle = "#0d0b10"; ctx.fillRect(-20.0, -20.0, W + 40, H + 40)
	var OF = office(Sc); var OFF = _g("OFFICE")
	if OF: J.mc(OFF, "drawBack", [ctx, t])
	elif J.t(img) and J.t(gp(img, "complete")): ctx.drawImage(img, b.ox, b.oy, b.iw * b.s, b.ih * b.s)
	var NS_ = n_(_g("NIGHT_SEC"))
	ctx.fillStyle = "rgba(12,10,34,%s)" % S((0.12 if OF else 0.22) + 0.1 * sin(t_(Sc) / NS_ * PI)); ctx.fillRect(0.0, 0.0, W, H)
	var fxs = A_(gp(Sc, "fx"))
	if OF:
		for f in fxs:
			if J.str(gp(f, "kind")) == "ghost" and J.str(gp(f, "ghost")) == "pontianak": ctx.save(); J.mc(OFF, "clipWindow", [ctx]); draw_ghost(Sc, ctx, f, t); ctx.restore()
	if OF: J.mc(OFF, "drawFloor", [ctx, t])
	if not OF: prop_marks(Sc, ctx, t)
	var g = null
	for n in npcs(Sc): if J.t(gp(D(n), "guard")) and live(n) and J.str(gp(n, "act")) != "doze": g = n; break
	if g != null:
		var gp0 = pt(Sc, n_(gp(g, "x")), n_(gp(g, "y"))); var gx = gp0[0]
		var gy = gp0[1] - hh(Sc, n_(gp(g, "y"))) * 0.5 if J.t(persp(Sc)) else pt(Sc, n_(gp(g, "x")), n_(gp(g, "y")) - 0.08)[1]
		var ex = pt(Sc, n_(gp(g, "x")) + n_(gp(g, "dir")) * 0.4, 0.0)[0]; var ln = absf(ex - gx)
		var grd = ctx.createLinearGradient(gx, 0.0, ex, 0.0); grd.addColorStop(0.0, "rgba(255,240,170,.42)"); grd.addColorStop(1.0, "rgba(255,240,170,0)")
		ctx.fillStyle = grd; ctx.beginPath(); ctx.moveTo(gx, gy); ctx.lineTo(ex, gy - ln * 0.35 - 8); ctx.lineTo(ex, gy + ln * 0.35 + 8); ctx.closePath(); ctx.fill()
	for f in fxs:
		var kind = J.str(gp(f, "kind")); var fn = gp(f, "n")
		if kind == "ac" and not J.t(fn) and not pano(Sc): ctx.fillStyle = "rgba(150,200,255,%s)" % S(0.16 * n_(gp(f, "life")) / 2.2); ctx.fillRect(0.0, 0.0, W, H)
		if (kind == "lamp" or kind == "lights" or kind == "ac") and J.t(fn) and not J.t(gp(fn, "gone")):
			var pp = pt(Sc, n_(gp(fn, "x")), n_(gp(fn, "y"))); var x = pp[0]; var y = pp[1]; var h = hh(Sc, n_(gp(fn, "y"))); var r = h * 0.9
			if kind == "ac":
				var g2 = ctx.createRadialGradient(x, y - h * 0.6, 0.0, x, y - h * 0.6, r); g2.addColorStop(0.0, "rgba(170,215,255,%s)" % S(0.32 * n_(gp(f, "life")) / 2.2)); g2.addColorStop(1.0, "rgba(170,215,255,0)"); ctx.fillStyle = g2; ctx.fillRect(x - r, y - h * 0.6 - r, r * 2, r * 2)
			else:
				var on = sin(t * 38) + sin(t * 17) > 0.4
				var g3 = ctx.createRadialGradient(x, y - h * 0.5, 0.0, x, y - h * 0.5, r * 1.1); g3.addColorStop(0.0, "rgba(255,245,200,.22)" if on else "rgba(0,0,0,.55)"); g3.addColorStop(1.0, "rgba(0,0,0,0)"); ctx.fillStyle = g3; ctx.fillRect(x - r * 1.1, y - h * 0.5 - r * 1.1, r * 2.2, r * 2.2)
				if kind == "lights":
					var c0 = pt(Sc, n_(gp(fn, "x")), 0.17); var cx0 = c0[0]; var cy0 = c0[1]
					ctx.strokeStyle = "rgba(255,250,215,.9)" if on else "rgba(90,90,110,.6)"; ctx.lineWidth = 4.0; ctx.beginPath(); ctx.moveTo(cx0 - h * 0.3, cy0); ctx.lineTo(cx0 + h * 0.3, cy0); ctx.stroke()
					if on:
						var g4 = ctx.createLinearGradient(0.0, cy0, 0.0, y); g4.addColorStop(0.0, "rgba(255,250,215,.18)"); g4.addColorStop(1.0, "rgba(255,250,215,0)"); ctx.fillStyle = g4
						ctx.beginPath(); ctx.moveTo(cx0 - h * 0.3, cy0); ctx.lineTo(cx0 + h * 0.3, cy0); ctx.lineTo(x + h * 0.5, y); ctx.lineTo(x - h * 0.5, y); ctx.closePath(); ctx.fill()
	draw_team(Sc, ctx, t)
	var tags = []; var zs = []
	for n in npcs(Sc):
		var vis = (not J.t(gp(n, "gone")) and not (J.t(gp(n, "out")) and t_(Sc) - or_(gp(n, "outAt"), 0.0) > 0.6)) or (n_(gp(n, "exitT")) > 0 and t_(Sc) - n_(gp(n, "exitT")) < (0.8 if OF else 3.0) and n_(vis_pos(Sc, n)[0]) < 1.15)
		if not (vis and (not pano(Sc) or on_screen(Sc, n_(gp(n, "x")), 0.3))): continue
		var z: float
		if OF and J.t(J.mc(OFF, "seated", [n])): z = n_(J.mc(OFF, "kenZ", [n])) - 1e-4
		elif gp(n, "vY") != null and not J.t(gp(n, "gone")): z = n_(gp(n, "vY"))
		else: z = n_(vis_pos(Sc, n)[1])
		var nn = n
		var fz = func(_t, a):
			var r = draw_npc(Sc, a[0], nn, t)
			if not J.t(gp(nn, "gone")) and n_(gp(r, "x")) > -30 and n_(gp(r, "x")) < n_(gp(Sc, "W")) + 30: tags.append([nn, gp(r, "x"), n_(gp(r, "top")) - 8])
			return null
		zs.append([z, fz])
	if OF:
		zs.append_array(A_(J.mc(OFF, "drawables", [t])))
		if pano(Sc): zs.append_array(A_(J.mc(OM(), "drawables", [])))
	zs = A_(J.mc(zs, "sort", [func(_t, a): return n_(a[0][0]) - n_(a[1][0])]))
	for zz in zs: cl_(zz[1], ctx)
	if OF:
		J.mc(OFF, "drawDark", [ctx, t])
		if pano(Sc): J.mc(OM(), "drawOver", [ctx, t])
		prop_marks(Sc, ctx, t)
	if _g("ScareX") != null: J.mc(_g("ScareX"), "draw", [Sc, ctx, t])
	for f in A_(gp(Sc, "fx")):
		if J.str(gp(f, "kind")) == "ghost" and not (OF and J.str(gp(f, "ghost")) == "pontianak"): draw_ghost(Sc, ctx, f, t)
	for p in A_(gp(Sc, "parts")):
		if n_(gp(p, "delay")) > 0: continue
		var q = pt(Sc, n_(gp(p, "x")), n_(gp(p, "y"))); var px = q[0]; var py = q[1]; var kd = J.str(gp(p, "kind")); var life = n_(gp(p, "life"))
		if kd == "paper": ctx.save(); ctx.translate(px, py); ctx.rotate(n_(gp(p, "rot"))); ctx.fillStyle = "#f4f0e6"; ctx.strokeStyle = "#555"; ctx.lineWidth = 0.8; ctx.fillRect(-7.0, -9.0, 14.0, 18.0); ctx.strokeRect(-7.0, -9.0, 14.0, 18.0); ctx.fillStyle = "#b44"; ctx.fillRect(-4.0, -5.0, 8.0, 1.5); ctx.restore()
		if kd == "frost": ctx.fillStyle = "rgba(220,240,255,%s)" % S(minf(1.0, life)); ctx.beginPath(); ctx.arc(px, py, 2.2, 0.0, PI * 2); ctx.fill()
		if kd == "bubble": ctx.strokeStyle = "rgba(190,230,255,%s)" % S(minf(1.0, life)); ctx.lineWidth = 1.2; ctx.beginPath(); ctx.arc(px, py, 3.0, 0.0, PI * 2); ctx.stroke()
		if kd == "sweat": ctx.fillStyle = "rgba(150,210,255,.9)"; ctx.beginPath(); ctx.ellipse(px, py, 2.5, 4.0, 0.0, 0.0, PI * 2); ctx.fill()
		if kd == "dust": ctx.fillStyle = "rgba(200,190,170,%s)" % S(gp(p, "life")); ctx.beginPath(); ctx.arc(px, py, 6 * (1.2 - life), 0.0, PI * 2); ctx.fill()
		if kd == "drop": ctx.fillStyle = "rgba(170,210,230,%s)" % S(life * 0.4); ctx.beginPath(); ctx.ellipse(px, py, 9.0, 3.0, 0.0, 0.0, PI * 2); ctx.fill()
	for f in A_(gp(Sc, "fx")):
		if J.str(gp(f, "kind")) == "breath" and not J.t(gp(gp(f, "n"), "gone")): draw_breath(Sc, ctx, f, t)
	for f in A_(gp(Sc, "fx")):
		var fn2 = gp(f, "n")
		if J.str(gp(f, "kind")) == "phone" and not J.t(gp(fn2, "gone")):
			var v = _vxy(fn2); var q2 = pt(Sc, v[0], v[1]); var h2 = hh(Sc, n_(gp(fn2, "y"))) * (0.8 if office(Sc) and J.t(J.mc(OFF, "seated", [fn2])) else 1.0)
			var aa = 0.5 + 0.5 * sin(t * 20); ctx.fillStyle = "rgba(120,255,170,%s)" % S(0.35 * aa); ctx.beginPath(); ctx.arc(q2[0] + n_(gp(fn2, "dir")) * h2 * 0.05, q2[1] - h2 * 0.62, h2 * 0.18, 0.0, PI * 2); ctx.fill()
	var placed = []
	var srt = tags.duplicate(); srt = A_(J.mc(srt, "sort", [func(_t, a): return n_(a[1][2]) - n_(a[0][2])]))
	for q in srt:
		if J.t(gp(q[0], "out")): continue
		q[1] = maxf(56.0, minf(or_(gp(Sc, "W"), 390.0) - 58, n_(q[1]))); var ext = tag_ext(Sc, q[0]); var y = n_(q[2])
		for k in 8:
			var o = null
			for r in placed:
				if absf(r[0] - n_(q[1])) < 100 and y - 20 - ext < r[1] + 9 and y + 9 > r[1] - 20 - r[3]: o = r; break
			if o == null: break
			y = o[1] - 20 - o[3] - 9 - 2
		q[2] = y; placed.append([n_(q[1]), y, 8.0, ext])
	J.sp(Sc, "_tagR", placed)
	var s0 = gp(Sc, "sel")
	var sel = s0 if J.t(s0) and not J.t(gp(s0, "gone")) and not J.t(gp(s0, "out")) and not J.t(gp(s0, "fleeing")) and not J.t(gp(D(s0), "guard")) else null
	var sp = null
	if sel != null:
		for q in tags: if is_same(q[0], sel): sp = q; break
	if sp != null:
		ctx.save(); ctx.setLineDash([6.0, 5.0]); J.sp(ctx, "lineDashOffset", -t * 20); ctx.lineWidth = 2.0; ctx.strokeStyle = "rgba(255,90,80,.75)"
		for q in tags:
			var m = q[0]
			if not is_same(m, sel) and not J.t(gp(m, "out")) and sees(Sc, m, sel): ctx.beginPath(); ctx.moveTo(n_(q[1]), n_(q[2]) + 6); ctx.lineTo(n_(sp[1]), n_(sp[2]) - 4); ctx.stroke()
		ctx.restore()
	var br0 = A_(gp(Sc, "_bubR")) if J.t(gp(Sc, "_bubR")) else []
	J.sp(Sc, "_bubLast", br0.slice(int(or_(gp(Sc, "_nTag"), 0.0))))
	var bubR = []
	for r in placed: bubR.append([r[0] - 52, r[1] - 22 - r[3], 104.0, 32 + r[3]])
	J.sp(Sc, "_bubR", bubR); J.sp(Sc, "_nTag", float(bubR.size()))
	var bs = []
	for q in tags: if J.t(gp(q[0], "bub")) and not J.t(gp(q[0], "out")): bs.append(q)
	var selx = gp(Sc, "sel")
	var bcmp = func(_t, a):
		var d1 = (1.0 if is_same(a[1][0], selx) else 0.0) - (1.0 if is_same(a[0][0], selx) else 0.0)
		if d1 != 0: return d1
		return or_(gp(a[1][0], "bubAt"), 0.0) - or_(gp(a[0][0], "bubAt"), 0.0)
	bs = A_(J.mc(bs, "sort", [bcmp]))
	var okl = []
	for q in bs.slice(0, 2): okl.append(q[0])
	var bubOK = J.new_("Set", [okl]); J.sp(Sc, "_bubOK", bubOK)
	var tagf = _g("__nat_scTag")
	for q in tags:
		var n = q[0]; var x = n_(q[1]); var by = n_(q[2])
		if J.t(gp(n, "out")): continue
		var d = D(n)
		if nat and tagf != null:
			J.cl(tagf, null, [ctx, Sc, n, x, by, t, sel])
			if J.t(gp(n, "step")) and J.t(gp(gp(n, "step"), "cue")): draw_cue(Sc, ctx, n, x, by, t)
		else:
			_draw_tag(Sc, ctx, n, x, by, t, sel)
		if J.t(gp(d, "daoshi")) and J.str(gp(n, "ds")) == "ritual":
			var pw = 110.0; var pr = minf(1.0, or_(gp(n, "prog"), 0.0)); var fy = pt(Sc, n_(gp(n, "x")), n_(gp(n, "y")))[1] + 10
			ctx.save(); ctx.fillStyle = "rgba(0,0,0,.72)"; ctx.fillRect(x - pw / 2 - 3, fy, pw + 6, 26.0); ctx.fillStyle = "#4a3a10"; ctx.fillRect(x - pw / 2, fy + 16, pw, 6.0); ctx.fillStyle = "#ffd36a"; ctx.fillRect(x - pw / 2, fy + 16, pw * pr, 6.0)
			ctx.font = "800 11px sans-serif"; ctx.textAlign = "center"; ctx.fillStyle = "#ffe9a8"
			ctx.fillText("做法中 " + S(jround(pr * 100)) + "%" + ("・嚇親停咗" if n_(gp(n, "fear")) >= 50 else ("・冇動靜慢咗" if or_(gp(Sc, "expo"), 0.0) < 25 else "")), x, fy + 12); ctx.restore()
		var mark = "" if (nat and tagf != null) else ("!!!" if J.t(gp(n, "fleeing")) else ("！" if n_(gp(n, "fear")) >= 50 else ("？" if n_(gp(n, "fear")) >= 25 else "")))
		if mark != "":
			ctx.font = "700 11px sans-serif"; ctx.save(); ctx.translate(x + n_(ctx.measureText(S(gp(d, "name"))).width) / 2 + (16.0 if mark.length() > 1 else 10.0), by - 3 - absf(sin(t * 6)) * 2)
			ctx.font = "900 %dpx sans-serif" % (19 if n_(gp(n, "fear")) >= 50 else 16); ctx.textAlign = "center"; ctx.fillStyle = "#ff6a5a" if n_(gp(n, "fear")) >= 50 else "#ffd36a"; ctx.strokeStyle = "#000"; ctx.lineWidth = 3.0; ctx.strokeText(mark, 0.0, 0.0); ctx.fillText(mark, 0.0, 0.0); ctx.restore()
		if J.t(gp(n, "bub")) and J.t(J.mc(bubOK, "has", [n])): draw_bubble(Sc, ctx, gp(n, "bub"), x, by - 20 - tag_ext(Sc, n), gp(n, "bubG"), t_(Sc) - or_(gp(n, "bubAt"), 0.0))
	if pano(Sc): draw_edge(Sc, ctx, t)
	for f in A_(gp(Sc, "floats")):
		var k = 1 - n_(gp(f, "life")) / n_(gp(f, "max")); var x = n_(gp(Sc, "W")) / 2; var y = 64 - minf(1.0, k * 6) * 4; var al = minf(1.0, minf(n_(gp(f, "life")) * 3, k * 8 + 0.2))
		ctx.save(); ctx.globalAlpha = al; ctx.font = "800 15px sans-serif"; ctx.textAlign = "center"; var w = minf(n_(gp(Sc, "W")) - 20, n_(ctx.measureText(S(gp(f, "text"))).width) + 26)
		ctx.fillStyle = "rgba(12,10,20,.82)"; ctx.beginPath(); ctx.roundRect(x - w / 2, y - 17, w, 26.0, 13.0); ctx.fill(); ctx.strokeStyle = gp(f, "color"); ctx.globalAlpha = al * 0.6; ctx.lineWidth = 1.2; ctx.stroke(); ctx.globalAlpha = al; ctx.fillStyle = gp(f, "color"); ctx.fillText(S(gp(f, "text")), x, y + 1); ctx.restore()
	ctx.restore()
	var vign = n_(gp(Sc, "vign"))
	var vg = ctx.createRadialGradient(W / 2, H / 2, H * 0.3, W / 2, H / 2, H * 0.8); vg.addColorStop(0.0, "rgba(0,0,0,0)"); vg.addColorStop(1.0, "rgba(%s,0,0,%s)" % [S(jround(90 * vign)), S(0.45 + 0.3 * vign)])
	ctx.fillStyle = vg; ctx.fillRect(0.0, 0.0, W, H)
	var e = minf(100.0, or_(gp(Sc, "expo"), 0.0)); var bx = 10.0; var by2 = n_(gp(Sc, "H")) - 34 if pano(Sc) else 10.0; var bw = 132.0; var bh = 9.0
	ctx.save(); ctx.fillStyle = "rgba(0,0,0,.62)"; ctx.fillRect(bx - 4, by2 - 4, bw + 8, bh + 22)
	ctx.font = "700 11px sans-serif"; ctx.textAlign = "left"; ctx.fillStyle = "#ff8a6a" if e >= E("call") else ("#ffcf6a" if e >= E("sus") else "#cfe8d8")
	ctx.fillText("穿崩度 " + S(jround(e)) + ("　道士到！" if J.t(gp(Sc, "daoIn")) else ("　請咗道士" if J.t(gp(Sc, "daoCall")) else ("　有人起疑" if J.t(gp(Sc, "alert")) else ""))), bx, by2 + 8)
	ctx.fillStyle = "rgba(255,255,255,.15)"; ctx.fillRect(bx, by2 + 12, bw, bh - 2); ctx.fillStyle = "#ff6a4a" if e >= E("call") else ("#ffb84a" if e >= E("sus") else "#7fd6a0"); ctx.fillRect(bx, by2 + 12, bw * e / 100, bh - 2)
	ctx.fillStyle = "rgba(255,255,255,.7)"
	for qq in [E("sus"), E("call")]: ctx.fillRect(bx + bw * qq / 100, by2 + 10, 1.5, bh + 2)
	ctx.restore()
	if t_(Sc) > NS_ * 0.85: ctx.fillStyle = "rgba(120,150,210,%s)" % S((t_(Sc) / NS_ - 0.85) * 1.2); ctx.fillRect(0.0, 0.0, W, H)

static func _draw_tag(Sc, ctx, n, x: float, by: float, t: float, sel) -> void:
	var d = D(n)
	ctx.font = "700 11px sans-serif"; var nw2 = n_(ctx.measureText(S(gp(d, "name"))).width) / 2
	var ex = x - nw2 - 12; var ey = by - 10; var op = watching(Sc, n); var red = sel != null and not is_same(n, sel) and sees(Sc, n, sel)
	ctx.save(); ctx.fillStyle = "rgba(0,0,0,.6)"; ctx.beginPath(); ctx.arc(ex, ey, 7.5, 0.0, PI * 2); ctx.fill(); ctx.lineWidth = 1.6
	if op: ctx.fillStyle = "#ff6a5a" if red else "#f2f2f2"; ctx.beginPath(); ctx.ellipse(ex, ey, 5.5, 3.5, 0.0, 0.0, PI * 2); ctx.fill(); ctx.fillStyle = "#111"; ctx.beginPath(); ctx.arc(ex + or_(gp(n, "dir"), 1.0) * 1.2, ey, 2.0, 0.0, PI * 2); ctx.fill()
	else: ctx.strokeStyle = "#9aa"; ctx.beginPath(); ctx.arc(ex, ey - 2, 4.5, 0.25 * PI, 0.75 * PI); ctx.stroke()
	ctx.restore()
	if J.t(gp(n, "step")) and J.t(gp(gp(n, "step"), "cue")): draw_cue(Sc, ctx, n, x, by, t)
	var bw = 60.0; var f = minf(1.0, n_(gp(n, "fear")) / 100); var hk = maxf(0.0, or_(gp(n, "barHit"), 0.0)); var shk = n_(gp(n, "shaken")) > 0; var bh = 6 + hk * 3
	ctx.fillStyle = "rgba(0,0,0,.65)"; ctx.fillRect(x - bw / 2 - 2, by - 3 - hk * 1.5, bw + 4, bh + 4)
	if shk: ctx.strokeStyle = "rgba(255,90,80,%s)" % S(0.45 + 0.4 * sin(t * 7)); ctx.lineWidth = 1.6; ctx.strokeRect(x - bw / 2 - 2.5, by - 3.5 - hk * 1.5, bw + 5, bh + 5)
	ctx.fillStyle = "#ff5a4a" if f >= 0.5 else ("#ffb84a" if f >= 0.25 else "#9be8b0"); ctx.fillRect(x - bw / 2, by - 1 - hk * 1.5, bw * f, bh)
	if hk > 0: ctx.fillStyle = "rgba(255,255,255,%s)" % S(hk * 0.75); ctx.fillRect(x - bw / 2, by - 1 - hk * 1.5, bw * f, bh)
	ctx.fillStyle = "rgba(255,255,255,.4)"; ctx.fillRect(x - bw / 2 + bw * 0.25, by - 2, 1.0, bh + 2); ctx.fillRect(x - bw / 2 + bw * 0.5, by - 2, 1.0, bh + 2)
	ctx.font = "700 11px sans-serif"; ctx.textAlign = "center"; ctx.lineWidth = 3.0; ctx.strokeStyle = "rgba(0,0,0,.8)"; ctx.strokeText(S(gp(d, "name")), x, by - 6); ctx.fillStyle = "#a8ffcf" if is_same(n, gp(Sc, "sel")) else "#eee"; ctx.fillText(S(gp(d, "name")), x, by - 6)
	if (sel != null and is_same(n, sel)) or (n_(gp(n, "mocked")) > 0 and not J.t(gp(d, "guard"))):
		var nw = witnesses(Sc, n).size() if (sel != null and is_same(n, sel)) else -1
		var a = "" if nw < 0 else (("%d人望緊" % nw) if nw else "冇人望緊"); var bb = ("冇人信×" + S(minf(4.0, n_(gp(n, "mocked"))))) if n_(gp(n, "mocked")) > 0 else ""
		ctx.font = "800 11px sans-serif"; var parts = PackedStringArray()
		for z in [a, bb]: if z != "": parts.append(z)
		var tx = "・".join(parts); var tw = n_(ctx.measureText(tx).width)
		ctx.fillStyle = "rgba(10,8,18,.72)"; ctx.beginPath(); ctx.roundRect(x - tw / 2 - 6, by - 33, tw + 12, 15.0, 7.5); ctx.fill()
		ctx.fillStyle = "#ff8a7a" if nw > 0 else ("#d6a0ff" if bb != "" and nw < 0 else "#8fe8b0"); ctx.fillText(tx, x, by - 21.5)

static func draw_cue(_Sc, ctx, n, x: float, by: float, _t: float) -> void:
	var k = maxf(0.0, minf(1.0, 1 - n_(gp(n, "wait")) / 3.5)); var cx = x + 46; var cy = by + 1; var r = 9.0
	ctx.save(); ctx.fillStyle = "rgba(0,0,0,.55)"; ctx.beginPath(); ctx.arc(cx, cy, r + 3, 0.0, PI * 2); ctx.fill()
	ctx.strokeStyle = "#ffb34a"; ctx.lineWidth = 3.0; ctx.beginPath(); ctx.arc(cx, cy, r, -PI / 2, -PI / 2 + k * PI * 2); ctx.stroke()
	ctx.font = "900 11px sans-serif"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillStyle = "#ffe2b0"; ctx.fillText("走", cx, cy + 0.5); ctx.restore()

static func draw_edge(Sc, ctx, t: float) -> void:
	var n = gp(Sc, "sel"); J.sp(Sc, "_edge", null)
	if not J.t(n) or J.t(gp(n, "gone")) or J.t(gp(n, "out")): return
	var x = _vxy(n)[0]
	if on_screen(Sc, x, -0.04): return
	var right = x > n_(gp(Sc, "camX")) + view_w(Sc) / 2; var y = 58.0; var ex = n_(gp(Sc, "W")) - 8 if right else 8.0; var bob = sin(t * 5) * 3
	var lab = S(gp(D(n), "name")) + "・" + S(gp(room_at(x), "name")); ctx.save(); ctx.font = "800 12px sans-serif"; var tw = n_(ctx.measureText(lab).width) + 34; var bx = ex - tw - bob if right else ex + bob
	ctx.fillStyle = "rgba(12,10,20,.85)"; ctx.strokeStyle = "#a8ffcf"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(bx, y - 14, tw, 28.0, 14.0); ctx.fill(); ctx.stroke()
	ctx.fillStyle = "#a8ffcf"; ctx.beginPath(); var ax = bx + tw - 12 if right else bx + 12
	ctx.moveTo(ax + (7.0 if right else -7.0), y); ctx.lineTo(ax - (5.0 if right else -5.0), y - 8); ctx.lineTo(ax - (5.0 if right else -5.0), y + 8); ctx.closePath(); ctx.fill()
	ctx.textAlign = "center"; ctx.fillStyle = "#eafff2"; ctx.fillText(lab, bx + tw / 2 + (-6.0 if right else 6.0), y + 4); ctx.restore(); J.sp(Sc, "_edge", [bx, y - 14, tw, 28.0, n])

static func draw_breath(Sc, ctx, f, t: float) -> void:
	var n = gp(f, "n"); var k = 1 - n_(gp(f, "life")) / n_(gp(f, "max")); var seat = office(Sc) and J.t(J.mc(_g("OFFICE"), "seated", [n]))
	var v = _vxy(n); var p = pt(Sc, v[0], v[1]); var x = p[0]; var y = p[1]; var h = hh(Sc, n_(gp(n, "y"))) * (0.8 if seat else 1.0)
	var face = -1.0 if seat else or_(gp(n, "dir"), 1.0); var back = -face; var nx = x + back * h * (0.02 if seat else 0.2); var ny = y - h * (0.62 if seat else 0.72)
	var a = minf(1.0, k * 6) * maxf(0.0, 1 - maxf(0.0, k - 0.45) / 0.4)
	if a <= 0: return
	ctx.save(); ctx.lineCap = "round"
	for i in 4:
		var q = minf(1.0, maxf(0.0, k * 2.2 - i * 0.18))
		if q <= 0: continue
		var px = nx + back * h * (0.28 - 0.22 * q) + sin(t * 3 + i) * 2; var py = ny - h * 0.04 * i + sin(t * 2 + i) * 1.5; var r = h * (0.05 + 0.07 * q)
		var g = ctx.createRadialGradient(px, py, 0.0, px, py, r); g.addColorStop(0.0, "rgba(240,248,255,%s)" % S(0.8 * a)); g.addColorStop(1.0, "rgba(235,245,255,0)")
		ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, r, 0.0, PI * 2); ctx.fill()
		ctx.strokeStyle = "rgba(245,250,255,%s)" % S(0.6 * a); ctx.lineWidth = 1.6; ctx.beginPath(); ctx.arc(px, py, r * 0.6, PI * (0.2 + i * 0.3), PI * (1.3 + i * 0.3)); ctx.stroke()
	ctx.fillStyle = "rgba(220,240,255,%s)" % S(a)
	for i in 6:
		var q = fmod(k * 2 + i / 6.0, 1.0); var sx = nx + back * h * (0.05 + 0.2 * sin(i * 2.1)); var sy = ny + h * (q * 0.2 - 0.08); ctx.beginPath(); ctx.arc(sx, sy, 1.4, 0.0, PI * 2); ctx.fill()
	ctx.restore()

static func prop_marks(Sc, ctx, t: float) -> void:
	var nh = _g("__nat_scMarks")
	if J.t(gp(Sc, "_nat")) and nh != null: J.cl(nh, null, [ctx, Sc, t]); return
	var SP = _g("SCARE_PROPS")
	for k in J.keys(SP):
		var p = gp(SP, k); var rc = gp(p, "rect")
		if pano(Sc) and not on_screen(Sc, n_(rc[0]) + n_(rc[2]) / 2, 0.0): continue
		if J.t(gp(p, "group")) or not prop_ok(Sc, k, gp(Sc, "sel")): continue
		if pano(Sc) and not on_screen(Sc, n_(rc[0]) + n_(rc[2]) / 2, 0.0): continue
		var a1 = pt(Sc, n_(rc[0]), n_(rc[1])); var a2 = pt(Sc, n_(rc[0]) + n_(rc[2]), n_(rc[1]) + n_(rc[3])); var x1 = a1[0]; var y1 = a1[1]; var x2 = a2[0]; var y2 = a2[1]
		var ok = n_(gp(Sc, "mana")) >= n_(gp(p, "cost")) and prop_ok(Sc, k, gp(Sc, "sel")); var a = 0.35 + 0.25 * sin(t * 3 + x1) if ok else 0.1
		ctx.strokeStyle = "rgba(150,255,200,%s)" % S(a); ctx.lineWidth = 2.0; ctx.setLineDash([5.0, 4.0]); ctx.strokeRect(x1, y1, x2 - x1, y2 - y1); ctx.setLineDash([])
		var pcd = gp(Sc, "pcd")
		var cdl = (S(ceil(n_(gp(pcd, k)))) + "秒") if J.t(gp(p, "group")) and J.t(pcd) and n_(gp(pcd, k)) > 0 else S(gp(p, "cost"))
		var lab = S(gp(p, "name")) + ("（全場）" if J.t(gp(p, "group")) else "") + "・" + cdl
		ctx.font = "600 11px sans-serif"; ctx.textAlign = "center"; var tw = n_(ctx.measureText(lab).width) / 2 + 4; var lx = maxf(tw, minf(n_(gp(Sc, "W")) - tw, (x1 + x2) / 2))
		var TR = A_(gp(Sc, "_tagR")) if J.t(gp(Sc, "_tagR")) else []; var BR = A_(gp(Sc, "_bubLast")) if J.t(gp(Sc, "_bubLast")) else []
		var hit_ = func(yy: float) -> bool:
			for r in TR: if absf(n_(r[0]) - lx) < tw + 44 and yy > n_(r[1]) - 22 and yy - 12 < n_(r[1]) + n_(r[2]): return true
			for r in BR: if lx + tw > n_(r[0]) and lx - tw < n_(r[0]) + n_(r[2]) and yy > n_(r[1]) and yy - 12 < n_(r[1]) + n_(r[3]): return true
			return false
		var ly = y1 - 5 if J.str(gp(p, "label")) == "up" else y2 + 13
		for c in [y1 - 5, y2 + 13, y1 + 14]:
			if not hit_.call(ly): break
			ly = c
		if hit_.call(ly): continue
		if office(Sc): ctx.lineWidth = 3.0; ctx.strokeStyle = "rgba(10,8,20,.75)"; ctx.strokeText(lab, lx, ly)
		ctx.fillStyle = ("rgba(190,215,255,%s)" if J.t(gp(p, "group")) else "rgba(190,255,215,%s)") % S(0.9 if ok else 0.4); ctx.fillText(lab, lx, ly)

static func draw_npc(Sc, ctx, n, t: float) -> Dictionary:
	var OFF = _g("OFFICE"); var of = office(Sc)
	var seated = of and J.t(J.mc(OFF, "seated", [n])) and not J.t(gp(n, "out"))
	var nh = _g("__nat_scNpc")
	if J.t(gp(Sc, "_nat")) and nh != null and not seated:
		var r0 = J.cl(nh, null, [ctx, Sc, n, t]); return {"x": gp(r0, "x"), "top": gp(r0, "top")}
	if seated:
		J.sp(n, "vX", n_(gp(n, "x")) + n_(J.mc(OFF, "kenOff", [n]))); J.sp(n, "vY", gp(n, "y")); var sp = pt(Sc, n_(gp(n, "vX")), n_(gp(n, "y"))); var sh = hh(Sc, n_(gp(n, "y")))
		if is_same(n, gp(Sc, "sel")): ctx.fillStyle = "rgba(160,255,200,.28)"; ctx.beginPath(); ctx.ellipse(sp[0] - sh * 0.12, sp[1], sh * 0.4, sh * 0.09, 0.0, 0.0, PI * 2); ctx.fill()
		var r = J.mc(OFF, "drawKen", [ctx, n, t]); var o = npc_pose(Sc, n); o["pose"] = "seat"
		npc_fx(Sc, ctx, n, o, n_(gp(r, "x")), n_(gp(r, "top")) + n_(gp(r, "H")), n_(gp(r, "H")), false, t)
		return {"x": gp(r, "x"), "top": gp(r, "top")}
	if of and J.t(gp(n, "gone")): ctx.globalAlpha = maxf(0.0, 1 - (t_(Sc) - n_(gp(n, "exitT"))) / 0.8)
	elif J.t(gp(n, "out")): ctx.globalAlpha = maxf(0.0, 1 - (t_(Sc) - or_(gp(n, "outAt"), 0.0)) / 0.6)
	elif gp(n, "inAt") != null and t_(Sc) - n_(gp(n, "inAt")) < 0.6: ctx.globalAlpha = minf(1.0, (t_(Sc) - n_(gp(n, "inAt"))) / 0.6)
	var vp = vis_pos(Sc, n)
	if of: vp[0] = n_(vp[0]) + n_(J.mc(OFF, "kenOff", [n]))
	var p = pt(Sc, n_(vp[0]), n_(vp[1])); var x = p[0]; var y = p[1]; var h = hh(Sc, n_(vp[1])); var d = D(n)
	J.sp(n, "vX", vp[0]); J.sp(n, "vY", vp[1])
	var o = npc_pose(Sc, n); J.sp(n, "spd", o.spd)
	var right = n_(vp[2]) > 0 if vp[2] != null else n_(gp(n, "dir")) > 0
	if o.src != null and not J.t(gp(d, "guard")) and not J.t(o.walk) and not J.t(o.get("run")): right = n_(o.src) >= n_(vp[0])
	if J.t(o.get("turn")): right = not right
	var rig = rig_ok(Sc, gp(d, "spr"))
	var jx = (randf() - 0.5) * 3.2 * n_(o.jit) if J.t(o.jit) else 0.0
	var jy = (randf() - 0.5) * 1.2 * n_(o.jit) if J.t(o.jit) else 0.0
	var lift = n_(o.lift) * h * (0.1 if rig else 0.16)
	if is_same(n, gp(Sc, "sel")) and not J.t(gp(n, "gone")) and not J.t(gp(n, "fleeing")): ctx.fillStyle = "rgba(160,255,200,.28)"; ctx.beginPath(); ctx.ellipse(x, y, h * 0.34, h * 0.08, 0.0, 0.0, PI * 2); ctx.fill()
	var shk = 1 - minf(0.5, n_(o.lift) * 0.35); ctx.fillStyle = "rgba(0,0,0,.35)"; ctx.beginPath(); ctx.ellipse(x, y, h * 0.22 * shk * (1.2 if J.str(o.pose) == "cower" else 1.0), h * 0.05 * shk, 0.0, 0.0, PI * 2); ctx.fill()
	var sit = h * 0.22 if sitting(Sc, n) else 0.0
	if sit and J.str(gp(d, "k")) == "mis" and not J.t(o.src): right = true
	ctx.save()
	if sit: ctx.beginPath(); ctx.rect(x - h, y - h * 2, h * 2, h * 2 - h * 0.02); ctx.clip()
	ctx.translate(x + jx, y + jy - lift + sit)
	if J.t(o.rot): ctx.rotate(n_(o.rot) * (1.0 if right else -1.0))
	ctx.scale(n_(o.sx), n_(o.sy))
	if J.t(gp(d, "tint")): ctx.filter = gp(d, "tint")
	var drawn = false
	if J.str(gp(d, "k")) == "mis" and of and J.t(J.mc(OFF, "drawMis", [ctx, n, o, h, right, t])): drawn = true
	if not drawn:
		if rig:
			var oo = {"t": or_(gp(n, "at"), 0.0), "pose": o.pose, "pt": o.pt, "face": o.face, "flip": not right, "walk": o.walk, "shadow": false}
			if _g("TOWN") != null: _as(oo, J.mc(_g("TOWN"), "npcOpts", [n]))
			DC(ctx, gp(d, "spr"), 0.0, 0.0, h / n_(_g("NPC_UNIT")), oo)
		else: draw_npc_sprite(Sc, ctx, n, o, h, right)
	ctx.filter = "none"; ctx.restore()
	if J.t(gp(d, "mop")) and J.str(o.pose) == "mop" and randf() < 0.05: A_(gp(Sc, "parts")).append({"kind": "drop", "x": n_(vp[0]) + (1.0 if right else -1.0) * 0.05, "y": vp[1], "vx": 0.0, "vy": 0.0, "life": 1.4})
	npc_fx(Sc, ctx, n, o, x + jx, y - lift, h, right, t); ctx.globalAlpha = 1.0
	var dl = gp(n, "daily")
	var nap = h * 0.15 if J.str(gp(n, "act")) == "brk_nap" and J.t(dl) and J.t(gp(dl, "forced")) and n_(gp(dl, "w")) > 0.5 else 0.0
	return {"x": x, "top": y - lift + sit + nap - h * (0.8 if J.str(o.pose) == "cower" else 1.0) * n_(o.sy)}

static func draw_npc_sprite(_Sc, ctx, n, o, h: float, right: bool) -> void:
	var sp = spr_(gp(D(n), "spr"))
	if not J.t(sp) or not J.t(gp(sp, "complete")) or not J.t(gp(sp, "naturalWidth")): return
	var w = h * n_(gp(sp, "naturalWidth")) / n_(gp(sp, "naturalHeight")); var a = or_(gp(n, "at"), 0.0)
	var bob = 0.0; var tilt = 0.0; var sx = 1.0; var sy = 1 + sin(a * 2.2) * 0.012
	match J.str(o.pose):
		"move": bob = absf(sin(a * 9)) * h * 0.05; tilt = sin(a * 9) * 0.04
		"run": bob = absf(sin(a * 11)) * h * 0.08; tilt = 0.22 + sin(a * 11) * 0.06; sx = 1.04
		"startle": tilt = -0.25 * sin(minf(1.0, n_(o.pt) * 1.6) * PI)
		"cower": sy = 0.8 + sin(a * 30) * 0.015; sx = 1.1; tilt = 0.12
		"tremble": tilt = sin(a * 40) * 0.025
		"phone": tilt = 0.06 + sin(a * 1.3) * 0.01
		"mop": tilt = sin(a * 4) * 0.06
		"look": tilt = sin(a * 1.6) * 0.05
		"hurt": tilt = -0.2 * (1 - n_(o.pt))
		"sip": tilt = -0.05 + sin(a * 1.2) * 0.03
	ctx.translate(0.0, -bob); ctx.rotate(tilt * (1.0 if right else -1.0)); ctx.scale((1.0 if right else -1.0) * sx, sy); ctx.drawImage(sp, -w / 2, -h, w, h)

static func npc_fx(Sc, ctx, n, o, x: float, y: float, h: float, right: bool, t: float) -> void:
	var side = 1.0 if right else -1.0; var hy = y - h * 0.86; var hx = x + side * h * 0.03; var ph = n_(gp(n, "ph"))
	ctx.save(); ctx.lineCap = "round"
	var rxk = o.get("rxk")
	if J.str(o.pose) == "phone" and not J.t(rxk):
		var gx = x + side * h * 0.14; var gy = y - h * 0.66; var r = h * 0.3; var fl = 0.3 + 0.06 * sin(t * 3 + ph) + (0.15 if sin(t * 0.7 + ph) > 0.92 else 0.0)
		var g = ctx.createRadialGradient(gx, gy, 0.0, gx, gy, r); g.addColorStop(0.0, "rgba(150,220,255,%s)" % S(fl)); g.addColorStop(1.0, "rgba(150,220,255,0)")
		ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(gx, gy, r, 0.0, PI * 2); ctx.fill(); ctx.globalCompositeOperation = "source-over"
	var face = J.str(o.face)
	var goose = maxf(or_(gp(n, "goose"), 0.0), 0.6 if face == "f" or face == "t" else 0.0)
	if goose > 0:
		ctx.strokeStyle = "rgba(255,255,255,%s)" % S(minf(0.85, goose * 0.7)); ctx.lineWidth = 1.4
		for s in [-1.0, 1.0]:
			for i in 3:
				var bx = x + s * h * (0.24 + 0.03 * sin(t * 20 + i)); var by = y - h * (0.62 - i * 0.09)
				ctx.beginPath(); ctx.moveTo(bx, by)
				for j in range(1, 4): ctx.lineTo(bx + s * j * 3, by + (-3.0 if j % 2 else 3.0))
				ctx.stroke()
	if n_(gp(n, "hair")) > 0:
		var k = minf(1.0, n_(gp(n, "hair"))); ctx.strokeStyle = "rgba(30,24,30,%s)" % S(k); ctx.lineWidth = 2.0
		for i in range(-2, 3):
			var bx = hx + i * h * 0.045; var by = hy - h * 0.06; ctx.beginPath(); ctx.moveTo(bx, by); ctx.quadraticCurveTo(bx + sin(t * 50 + i) * 2.5, by - h * 0.07 * k, bx + i * 1.5, by - h * 0.14 * k); ctx.stroke()
	if n_(gp(n, "shock")) > 0:
		var shk = n_(gp(n, "shock")); var k2 = 1 - shk / 0.5; ctx.strokeStyle = "rgba(255,236,150,%s)" % S(minf(1.0, shk * 3)); ctx.lineWidth = 2.2
		for i in 9:
			var a = -PI * 0.95 + i * PI * 0.95 / 8 * 1.0 - 0.05; var r0 = h * (0.2 + k2 * 0.08); var r1 = r0 + h * 0.1
			ctx.beginPath(); ctx.moveTo(hx + cos(a) * r0, hy + sin(a) * r0); ctx.lineTo(hx + cos(a) * r1, hy + sin(a) * r1); ctx.stroke()
	if J.str(rxk) == "rational" or J.str(rxk) == "numb":
		ctx.strokeStyle = "rgba(40,40,90,.75)"; ctx.lineWidth = 1.6
		for i in 3:
			var bx = hx - side * h * 0.02 + (i - 1) * h * 0.035; ctx.beginPath(); ctx.moveTo(bx, hy - h * 0.02); ctx.lineTo(bx, hy + h * (0.06 + (0.02 if i == 1 else 0.0))); ctx.stroke()
		var rx = gp(n, "rx")
		var dx = hx - side * h * 0.13; var dy = hy + h * 0.02 + (minf(1.0, n_(gp(rx, "t"))) * h * 0.05 if J.t(rx) else 0.0)
		ctx.fillStyle = "rgba(160,215,255,.95)"; ctx.beginPath(); ctx.moveTo(dx, dy - 6); ctx.quadraticCurveTo(dx + 4.5, dy + 2, dx, dy + 3.5); ctx.quadraticCurveTo(dx - 4.5, dy + 2, dx, dy - 6); ctx.fill()
		if n_(o.get("shrug")) > 0.2:
			ctx.strokeStyle = "rgba(255,255,255,%s)" % S(n_(o.shrug) * 0.7); ctx.lineWidth = 1.5
			for s in [-1.0, 1.0]: ctx.beginPath(); ctx.arc(x + s * h * 0.26, y - h * 0.62, 5.0, -1.2 if s > 0 else PI + 1.2 - 2.4, 1.2 - 2.4 + 2.4 if s > 0 else PI + 1.2); ctx.stroke()
	if J.str(o.pose) == "tremble" or J.str(o.pose) == "cower" or (n_(o.jit) > 0.5 and not J.t(o.get("run"))):
		ctx.strokeStyle = "rgba(255,200,180,.55)"; ctx.lineWidth = 1.5
		for s in [-1.0, 1.0]:
			for i in 2:
				var r = h * (0.3 + i * 0.06) + sin(t * 30) * 1.5; ctx.beginPath(); ctx.arc(x, y - h * 0.45, r, -0.35 if s > 0 else PI - 0.35, 0.35 if s > 0 else PI + 0.35); ctx.stroke()
	var dl = gp(n, "daily")
	if J.t(o.get("doze")) and not J.t(rxk) and not (J.t(dl) and J.t(gp(dl, "forced")) and n_(gp(dl, "w")) > 0):
		ctx.font = "800 13px sans-serif"; ctx.textAlign = "center"
		for i in 3:
			var q = fmod(t * 0.45 + i / 3.0, 1.0); ctx.fillStyle = "rgba(220,230,255,%s)" % S(0.85 * sin(q * PI)); ctx.fillText("Z", x + side * h * (0.18 + q * 0.15), y - h * (0.95 + q * 0.3))
	if J.t(o.get("run")):
		ctx.strokeStyle = "rgba(255,255,255,.45)"; ctx.lineWidth = 2.0
		for i in 4:
			var ly = y - h * (0.25 + i * 0.17); var lx = x - side * h * (0.3 + fmod(t * 3 + i * 0.37, 1.0) * 0.15); ctx.beginPath(); ctx.moveTo(lx, ly); ctx.lineTo(lx - side * h * 0.25, ly); ctx.stroke()
	if J.t(o.get("run")) and not J.t(gp(n, "bub")):
		var k3 = minf(1.0, n_(gp(n, "scream")) * 2) if n_(gp(n, "scream")) > 0 else 0.75
		var chars = ("哎呀——！" if J.str(gp(D(n), "k")) == "auntie" else "啊——！").split("")
		var fs = jround(14 + h * 0.05); var step = fs * 0.85; var w = step * chars.size()
		var x0 = x + h * 0.3 if side > 0 else x - h * 0.3 - w
		if x0 + w > n_(gp(Sc, "W")) - 6: x0 = x - h * 0.3 - w
		if x0 < 6: x0 = x + h * 0.3
		ctx.font = "900 %spx sans-serif" % S(fs); ctx.textAlign = "left"; ctx.lineWidth = 3.5; ctx.strokeStyle = "rgba(0,0,0,%s)" % S(k3); ctx.fillStyle = "rgba(255,96,80,%s)" % S(k3)
		for i in chars.size():
			var ox = x0 + i * step + (randf() - 0.5) * 3; var oy = y - h * 0.5 + sin(t * 25 + i) * 2.5 - i * 1.5; ctx.strokeText(chars[i], ox, oy); ctx.fillText(chars[i], ox, oy)
	ctx.restore()

static func draw_team(Sc, ctx, t: float) -> void:
	var nh = _g("__nat_scTeam")
	if J.t(gp(Sc, "_nat")) and nh != null: J.cl(nh, null, [ctx, Sc, t]); return
	var busy_ = []
	for f in A_(gp(Sc, "fx")): if J.str(gp(f, "kind")) == "ghost": busy_.append(gp(f, "ghost"))
	var g = null
	for n in npcs(Sc): if J.t(gp(D(n), "guard")) and not J.t(gp(n, "gone")): g = n; break
	var ci = 0; var team = A_(gp(Sc, "team"))
	for i in team.size():
		var k = team[i]
		if busy_.has(k): continue
		if J.t(gp(gp(Sc, "caught"), k)) and g != null:
			ci += 1; var gx = n_(gp(g, "x")) - n_(gp(g, "dir")) * 0.075 * ci; var p = pt(Sc, gx, n_(gp(g, "y")) + 0.004); var x = p[0]; var y = p[1]; var sc = hh(Sc, n_(gp(g, "y"))) / 62
			DC(ctx, k, x, y, sc, {"t": t + i, "pose": "idle", "alpha": 0.5, "flip": n_(gp(g, "x")) < gx, "shadow": false})
			ctx.strokeStyle = "rgba(255,255,255,.35)"; ctx.lineWidth = 1.5
			for j in 2:
				var sx = x + (j - 0.5) * 6; var sy = y - sc * 66; ctx.beginPath(); ctx.moveTo(sx, sy); ctx.bezierCurveTo(sx + 5, sy - 6 - sin(t * 3 + j) * 3, sx - 5, sy - 12, sx + sin(t * 2 + j) * 3, sy - 20); ctx.stroke()
			continue
		var ready = not J.t(gp(gp(Sc, "caught"), k)) and n_(gp(gp(Sc, "cd"), k)) <= 0 and n_(gp(Sc, "mana")) >= 35; var dx = sin(t * 0.35 + i * 2.1)
		var W = n_(gp(Sc, "W"))
		var x2 = W * (0.17 + 0.33 * i) + dx * W * 0.06; var y2 = (pt(Sc, 0.0, 0.36)[1] if pano(Sc) else n_(gp(Sc, "H")) * 0.27) + sin(t * 0.9 + i) * 6
		var a = (0.34 if ready else 0.13) + 0.06 * sin(t * 1.7 + i)
		DC(ctx, k, x2, y2, 0.8, {"t": t + i * 1.3, "pose": "idle", "alpha": a, "flip": cos(t * 0.35 + i * 2.1) < 0, "shadow": false})

static func draw_ghost(Sc, ctx, f, t: float) -> void:
	var fmax = n_(gp(f, "max")); var life = n_(gp(f, "life")); var k = 1 - life / fmax; var H = n_(gp(Sc, "H")); var W = n_(gp(Sc, "W"))
	var gp0 = pt(Sc, n_(gp(f, "gx")), n_(gp(f, "gy"))); var gx = gp0[0]; var gy = gp0[1]
	var a = minf(1.0, minf(k * 6, life * 2.2))
	if k < 0.16: a *= 0.7 + 0.3 * sin(t * 40)
	if J.t(gp(f, "caught")): a *= 0.55
	var n = gp(f, "n"); var tx = _vxy(n)[0] if J.t(n) else 0.5; var faceL = tx < n_(gp(f, "gx")) if J.t(n) else n_(gp(f, "gx")) > 0.5; var side = -1.0 if faceL else 1.0
	var ph = ["idle", 0.0] if k < 0.2 else (["windup", (k - 0.2) / 0.175] if k < 0.375 else (["strike", (k - 0.375) / 0.175] if k < 0.55 else (["recover", (k - 0.55) / 0.27] if k < 0.82 else ["idle", 0.0])))
	var hit_ = sin(minf(1.0, ph[1] * 1.4) * PI / 2) if ph[0] == "strike" else (1 - ph[1] if ph[0] == "recover" else 0.0)
	var wind = ph[1] if ph[0] == "windup" else 0.0
	var sc = 1.25 * depth(Sc, n_(gp(f, "gy")))
	var gh = J.str(gp(f, "ghost"))
	ctx.save()
	var th = spr_("tianhua_hang")
	if gh == "tianhua" and J.t(th) and J.t(gp(th, "complete")):
		var h = hh(Sc, n_(gp(f, "gy"))) * 1.9 if J.t(persp(Sc)) else H * 0.32; var w = h * n_(gp(th, "naturalWidth")) / n_(gp(th, "naturalHeight"))
		var e = minf(1.0, k / 0.375); var back = 1 + 2.4 * pow(e - 1, 3) + 1.4 * pow(e - 1, 2); var up = (k - 0.82) / 0.18 if k > 0.82 else 0.0
		var drop = (back - up * 1.2) * (gy - h * 0.95)
		ctx.globalAlpha = a * 0.92; ctx.translate(gx, maxf(-h, drop - h * 0.2) + sin(t * 3) * 3); ctx.rotate(sin(t * (2.4 + hit_ * 6)) * (0.05 + hit_ * 0.1)); ctx.scale(1 + hit_ * 0.08, 1 + hit_ * 0.08); ctx.drawImage(th, -w / 2, 0.0, w, h)
	elif gh == "pontianak":
		var WIN = gp(_g("OFFICE"), "WIN") if office(Sc) else null
		var wy = pt(Sc, 0.0, n_(WIN[1]) + n_(WIN[3]) * 0.62)[1] if office(Sc) else H * 0.25; var x = -60 + (W + 120) * k; var y = wy + sin(k * 9) * 12
		DC(ctx, "pontianak", x, y, 1.3, {"t": t, "pose": "cast", "pt": minf(1.0, k * 2), "alpha": a * 0.8, "flip": false, "shadow": false, "rot": sin(t * 4) * 0.08})
		ctx.font = "900 18px serif"; ctx.fillStyle = "rgba(255,200,230,%s)" % S(a); ctx.textAlign = "center"; ctx.fillText("嘻——嘻——", x + sin(t * 20) * 2, y - 70)
	elif gh == "eguiking":
		var q = fmod(k * fmax / 0.34, 1.0); var pose = "windup" if q < 0.55 else "strike"; var pq = q / 0.55 if q < 0.55 else (q - 0.55) / 0.45; var bump = sin(pq * PI) if pose == "strike" else 0.0
		DC(ctx, "eguiking", W * 0.86 - bump * 8, H * 0.55, 1.1 * (1 + bump * 0.05), {"t": t, "pose": pose, "pt": pq, "atk": pose == "strike", "alpha": a * 0.8, "flip": true, "shadow": false, "rot": -bump * 0.1})
		ctx.font = "900 20px sans-serif"; ctx.fillStyle = "rgba(255,230,150,%s)" % S(a); ctx.textAlign = "center"; ctx.fillText("叮叮叮叮！", W * 0.8, H * 0.4 - k * 20)
		if bump > 0.6: ctx.font = "900 15px sans-serif"; ctx.fillText("叮！", W * 0.72 + sin(k * 40) * 20, H * 0.47 - bump * 10)
	elif gh == "penanggal":
		var e2 = minf(1.0, k / 0.6); var x = gx + (-side) * W * 0.2 + side * W * 0.38 * (e2 * e2 * (3 - 2 * e2)); var y = gy - H * 0.13 - sin(e2 * PI) * 20 + sin(t * 6) * 4
		for i in range(1, 6): ctx.fillStyle = "rgba(200,40,60,%s)" % S(a * 0.35 * (1 - i / 6.0)); ctx.beginPath(); ctx.arc(x - side * i * 9, y + 8 + sin(t * 8 + i) * 3, 4 - i * 0.5, 0.0, PI * 2); ctx.fill()
		DC(ctx, "penanggal", x, y + H * 0.05, sc, {"t": t, "pose": ph[0], "pt": ph[1], "alpha": a * 0.85, "flip": faceL, "shadow": false, "rot": side * hit_ * 0.15})
	elif gh == "laojiang":
		var x = gx + (-side) * W * 0.22 + side * W * 0.44 * minf(1.0, k * 1.15); var hop = absf(sin(k * PI * 5)); var y = gy - hop * 26
		ctx.fillStyle = "rgba(0,0,0,.25)"; ctx.beginPath(); ctx.ellipse(x, gy + 2, 16 * (1 - hop * 0.4), 4.0, 0.0, 0.0, PI * 2); ctx.fill()
		DC(ctx, "laojiang", x, y, sc, {"t": t, "walk": true, "pose": "move", "alpha": a * 0.88, "flip": faceL, "shadow": false})
	else:
		var rise = (1 - minf(1.0, k * 4)) * 30; var lunge = side * (hit_ * 16 - wind * 8)
		var pose2 = ph[0]; var pt2 = ph[1]
		if gh == "afu" and k < 0.375: pose2 = "knead"; pt2 = fmod(k * fmax * 1.6, 1.0)
		DC(ctx, gp(f, "ghost"), gx + lunge, gy + rise, sc * (1 + hit_ * 0.12), {"t": t, "pose": pose2, "pt": pt2, "atk": hit_ > 0.3, "alpha": a * 0.85, "flip": faceL, "shadow": false, "rot": side * (hit_ * 0.12 - wind * 0.1)})
		if gh == "afu" and k > 0.08 and k < 0.4: ctx.font = "800 12px sans-serif"; ctx.textAlign = "center"; ctx.fillStyle = "rgba(190,255,215,%s)" % S(a * 0.9); ctx.fillText(["噠", "噠噠", "噠噠噠"][int(floor(k * 30)) % 3], gx + side * 18, gy - H * 0.13)
	ctx.restore()
	if J.t(gp(f, "sig")) and _g("ScareX") != null: J.mc(_g("ScareX"), "sigFx", [Sc, ctx, f, t, k])
	if J.t(n) and not J.t(gp(n, "gone")) and k > 0.37 and k < 0.6:
		var q2 = (k - 0.37) / 0.23; var pp = pt(Sc, tx, _vxy(n)[1]); var h2 = hh(Sc, n_(gp(n, "y")))
		ctx.strokeStyle = "rgba(210,150,255,%s)" % S((1 - q2) * 0.8); ctx.lineWidth = 3 * (1 - q2) + 1; ctx.beginPath(); ctx.arc(pp[0], pp[1] - h2 * 0.75, h2 * (0.15 + q2 * 0.5), 0.0, PI * 2); ctx.stroke()

static func draw_bubble(Sc, ctx, text, x: float, y: float, ghost, age) -> void:
	var nh = _g("__nat_scBub")
	if J.t(gp(Sc, "_nat")) and nh != null: J.cl(nh, null, [ctx, Sc, text, x, y, ghost, age]); return
	var pk = 1.0 if age == null else minf(1.0, n_(age) / 0.22); var ps = 1.0 if pk >= 1 else 1 + 2.70158 * pow(pk - 1, 3) + 1.70158 * pow(pk - 1, 2)
	ctx.save(); ctx.translate(x, y); ctx.scale(maxf(0.05, ps), maxf(0.05, ps)); ctx.translate(-x, -y)
	if pk < 1: ctx.globalAlpha = ctx.globalAlpha * minf(1.0, pk * 3)
	ctx.font = "600 13px sans-serif"; var maxW = 200.0; var words = S(text).split(""); var lines = []; var cur = ""
	for ch in words:
		if n_(ctx.measureText(cur + ch).width) > maxW: lines.append(cur); cur = ch
		else: cur += ch
	lines.append(cur)
	if lines.size() > 1 and lines[lines.size() - 1].length() <= 2:
		var pv: String = lines[lines.size() - 2]; lines[lines.size() - 1] = pv.right(2) + lines[lines.size() - 1]; lines[lines.size() - 2] = pv.left(maxi(0, pv.length() - 2))
	var mw = -INF
	for l in lines: mw = maxf(mw, n_(ctx.measureText(l).width))
	var w = minf(maxW, mw) + 16; var h = lines.size() * 17 + 10.0
	var bx = maxf(6.0, minf(n_(gp(Sc, "W")) - w - 6, x - w / 2)); var by = y - h - 10; var by0 = by
	if not J.t(gp(Sc, "_bubR")): J.sp(Sc, "_bubR", [])
	var R = A_(gp(Sc, "_bubR"))
	for k in 6:
		var o = null
		for r in R:
			if bx < n_(r[0]) + n_(r[2]) + 3 and bx + w + 3 > n_(r[0]) and by < n_(r[1]) + n_(r[3]) + 3 and by + h + 3 > n_(r[1]): o = r; break
		if o == null: break
		by = n_(o[1]) - h - 5
	if by < 4: by = 4.0
	R.append([bx, by, w, h])
	var gh = J.t(ghost)
	if by < by0 - 2: ctx.strokeStyle = "rgba(180,138,216,.8)" if gh else "rgba(255,253,245,.8)"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(x, by + h); ctx.lineTo(x, y - 2); ctx.stroke()
	ctx.fillStyle = "rgba(60,30,80,.92)" if gh else "rgba(255,253,245,.95)"; ctx.strokeStyle = "#b48ad8" if gh else "#3a2a1a"; ctx.lineWidth = 1.5
	ctx.beginPath(); ctx.roundRect(bx, by, w, h, 9.0); ctx.fill(); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(x - 6, by + h); ctx.lineTo(x, by + h + 8); ctx.lineTo(x + 6, by + h); ctx.fill()
	ctx.fillStyle = "#f0e0ff" if gh else "#2a1a10"; ctx.textAlign = "left"
	for i in lines.size(): ctx.fillText(lines[i], bx + 8, by + 18 + i * 17)
	ctx.restore()

# ================= 第七段：開局／收工（open、start、resize、bindPan、camTick、frame、finish）=================
static func perf_now() -> float: return n_(J.S_performance_("now", []))
static func raf(Sc) -> void:
	var cb = func(_t = null, a = null):
		frame(Sc, n_(_a(A_(a), 0)) if a != null else perf_now()); return null
	J.F_requestAnimationFrame([cb])

static func open(Sc, siteId) -> void:
	var X = _g("ScareX")
	if X != null and J.t(gp(X, "open")): J.mc(X, "open", [siteId]); return
	migrate(Sc); var st = gp(_g("SCARE_SITES"), siteId); var S0 = _g("S"); var SG = _g("SCARE_GHOSTS")
	var ghosts = []
	for k in J.keys(SG):
		var has = J.str(k) == "afu"
		if not has:
			for g in A_(gp(S0, "ghosts")): if J.seq(gp(g, "k"), k): has = true; break
		if has: ghosts.append(k)
	var ch = ["afu"]
	for k in ghosts: if J.str(k) != "afu" and ch.size() < 3: ch.append(k)
	J.sp(Sc, "pick", {"chosen": ch})
	var render = func() -> String:
		var sc = gp(S0, "scare"); var best = gp(gp(sc, "best"), siteId) if J.t(sc) else null; best = best if J.t(best) else 0.0
		var stars = int(stars_of(Sc, siteId, best))
		var h = "<p class=\"desc\">%s。天亮前三分鐘。<br>先用小動靜讓人起疑，等他頭上冒「！」再出大招。</p>" % S(gp(st, "name"))
		h += "<p class=\"desc\">最高紀錄：%s　%s%s</p>" % [S(best), "★".repeat(stars), "☆".repeat(3 - stars)]
		var bs = ""
		for k in ghosts:
			var g = gp(SG, k); var on = A_(gp(gp(Sc, "pick"), "chosen")).has(k)
			var pw = J.mc(_g("GP"), "pow", [J.mc(gp(S0, "ghosts"), "find", [func(_t, a): return J.str(gp(a[0], "k")) == "afu"])]) if J.str(k) == "afu" else J.mc(_g("GP"), "kindPow", [k])
			bs += "<button class=\"sc-g %s\" data-k=\"%s\" %s><canvas data-por=\"%s\"></canvas><b>%s</b><small>%s・%s・鬼力 %s</small></button>" % ["on" if on else "", S(k), "disabled" if J.str(k) == "afu" else "", S(k), S(gp(g, "name")), S(gp(g, "skill")), S(gp(_g("SCARE_TYPES"), gp(g, "type"))), S(pw)]
		h += "<div class=\"sc-pick\">%s</div>" % bs
		h += "<p class=\"desc\">阿福一定去。另外最多帶兩隻。</p><button class=\"btn gold wide\" id=\"sc-go\">出發，回陽間</button>"
		return h
	var bind = [null]
	bind[0] = func():
		J.cl(_g("paintPortraits"), null, [Q("#sheet")])
		for b in qsa(Q("#sheet"), ".sc-g"):
			var bb = b
			var cb = func(_t = null, _a2 = null):
				var k = gp(gp(bb, "dataset"), "k"); var c = A_(gp(gp(Sc, "pick"), "chosen"))
				if c.has(k): c.remove_at(c.find(k))
				elif c.size() < 3: c.append(k)
				else: J.mc(_g("Fx"), "toast", ["最多帶兩隻"]); return null
				J.sp(Q("#sheet .sh-body"), "innerHTML", render.call()); bind[0].call(); return null
			J.sp(bb, "onclick", cb)
		var go = func(_t = null, _a2 = null):
			J.mc(_g("UI"), "close", []); mc(Sc, "start", [siteId, A_(gp(gp(Sc, "pick"), "chosen")).duplicate()]); return null
		J.sp(Q("#sc-go"), "onclick", go)
	J.mc(_g("UI"), "sheet", ["回陽間・夜班", render.call()]); bind[0].call()

static func start(Sc, siteId, team, headless, seed) -> void:
	var st = gp(_g("SCARE_SITES"), siteId); var hdl = J.t(headless)
	var GS = _g("GhostStreet")
	var vals = {"endAt": 0.0, "expo": 0.0, "expoMax": 0.0, "expoT": -99.0, "alert": false, "daoCall": 0.0, "daoIn": false, "expelled": false, "kpiCut": false, "known": {}, "guardKarma": false, "site": st, "siteId": siteId, "active": true, "headless": hdl, "t": 0.0, "kpi": 0.0,
		"mana": 60 + (n_(J.mc(GS, "bonus", ["mana"])) if GS != null and not hdl else 0.0), "team": team, "fx": [], "parts": [], "floats": [], "fq": [], "bq": [], "karma": [], "shake": 0.0, "vign": 0.0, "paused": not hdl, "sel": null}
	for k in vals: J.sp(Sc, k, vals[k])
	J.sp(Sc, "cd", {}); J.sp(Sc, "pcd", {}); J.sp(Sc, "caught", {})
	for k in A_(team): J.sp(gp(Sc, "cd"), k, 0.0)
	var ns = []; var ds = A_(gp(st, "npcs"))
	for i in ds.size():
		var d = ds[i]; var r0 = A_(gp(d, "route"))[0]
		ns.append({"d": d, "x": r0[0], "y": r0[1], "wi": 0.0, "wait": n_(r0[2]) * (0.3 + i * 0.25), "dir": 1.0, "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": r0[3], "ph": randf() * 6})
	J.sp(Sc, "npcs", ns)
	J.sp(Sc, "seed", seed if seed != null else fmod(n_(J.S_Date_("now", [])), 100000.0)); J.sp(Sc, "door", 0.0)
	if J.t(gp(st, "shift")): shift_init(Sc)
	J.sp(Sc, "sel", ns[0]); J.sp(Sc, "selAuto", false)
	if _g("ScareX") != null: J.mc(_g("ScareX"), "night", [Sc])
	if hdl: return
	var el = Q("#scare"); J.mc(gp(el, "classList"), "add", ["on"])
	J.sp(el, "innerHTML", "<div id=\"sc-top\"><button class=\"btn sm ghost\" id=\"sc-quit\">收工</button><span id=\"sc-clock\"></span><div id=\"sc-mana\"><i></i><b>陰氣</b></div><span id=\"sc-kpi\"></span></div>\n      <div id=\"sc-stage\"><canvas id=\"sc-cvs\"></canvas>%s</div>\n      <div id=\"sc-panel\"><div id=\"sc-target\"></div><div id=\"sc-dock\"></div></div><div id=\"sc-phone\"></div>" % (S(J.mc(OM(), "mapHTML", [])) if J.t(gp(st, "pano")) else ""))
	J.sp(Q("#sc-quit"), "onclick", func(_t = null, _a2 = null):
		if not J.t(J.cl(_g("confirmInline"), null, [Q("#sc-quit"), "確定收工？"])): return null
		mc(Sc, "finish", [true]); return null)
	var cv = Q("#sc-cvs"); J.sp(Sc, "camX", 0.0); J.sp(Sc, "camV", 0.0); J.sp(Sc, "follow", false)
	if J.t(gp(st, "pano")): bind_pan(Sc, cv)
	else:
		var tapf = func(_t = null, a = null):
			mc(Sc, "tap", [_a(A_(a), 0)]); return null
		J.mc(cv, "addEventListener", ["pointerdown", tapf])
	J.mc(_g("Sound"), "setMode", ["story"])
	mc(Sc, "renderDock"); mc(Sc, "renderTarget"); mc(Sc, "resize")
	if J.t(gp(st, "pano")): J.mc(OM(), "init", [Sc]); J.sp(Sc, "camX", clamp_cam(Sc, n_(gp(ns[0], "x")) - view_w(Sc) * 0.5))
	if office(Sc):
		J.mc(_g("OFFICE"), "init", [Sc])
		var SP = _g("SCARE_PROPS")
		for k in J.keys(SP):
			var ob = gp(gp(SP, k), "obj")
			var r = J.mc(_g("OFFICE"), "rectOf", [ob]) if J.t(ob) else null
			if J.t(r): J.sp(gp(SP, k), "rect", r)
	if not J.t(gp(Sc, "_rs")):
		J.sp(Sc, "_rs", true)
		var rsz = func(_t = null, _a2 = null):
			if J.t(gp(Sc, "active")) and not hl(Sc): mc(Sc, "resize")
			return null
		J.S_window_("addEventListener", ["resize", rsz])
	var nh = _g("__nat_scare")
	if nh != null and J.t(J.cl(nh, null, [Sc])):
		mc(Sc, "resize")
		if J.t(gp(st, "pano")): J.sp(Sc, "camX", clamp_cam(Sc, n_(gp(A_(gp(Sc, "npcs"))[0], "x")) - view_w(Sc) * 0.5))
	J.sp(Sc, "last", perf_now()); raf(Sc)
	var qcb = func(_t = null, _a2 = null):
		J.sp(Sc, "paused", false); J.sp(Sc, "last", perf_now()); return null
	J.mc(_g("Story"), "queue", [{"style": "sys", "lines": gp(st, "intro")}, qcb])

static func resize(Sc) -> void:
	if J.t(gp(Sc, "_nat")):
		var r = J.cl(_g("__nat_scSize"), null, []); J.sp(Sc, "W", r[0]); J.sp(Sc, "H", r[1]); J.sp(Sc, "dpr", 1.0); return
	var c = Q("#sc-cvs"); var box = J.mc(Q("#sc-stage"), "getBoundingClientRect", []); var dpr = minf(2.0, or_(J.gp(_g("window"), "devicePixelRatio"), 1.0))
	J.sp(c, "width", n_(gp(box, "width")) * dpr); J.sp(c, "height", n_(gp(box, "height")) * dpr); J.sp(gp(c, "style"), "width", S(gp(box, "width")) + "px"); J.sp(gp(c, "style"), "height", S(gp(box, "height")) + "px")
	J.sp(Sc, "W", gp(box, "width")); J.sp(Sc, "H", gp(box, "height")); J.sp(Sc, "dpr", dpr)

static func bind_pan(Sc, cv) -> void:
	var dd = [null]
	var unit = func() -> float: var b = bg_scale(Sc); return b.iw * b.s
	var pdn = func(_t = null, a = null):
		var e = _a(A_(a), 0)
		dd[0] = {"x0": gp(e, "clientX"), "y0": gp(e, "clientY"), "c0": gp(Sc, "camX"), "moved": false, "lx": gp(e, "clientX"), "lt": perf_now(), "id": gp(e, "pointerId")}; J.sp(Sc, "camV", 0.0)
		J.mc(cv, "setPointerCapture", [gp(e, "pointerId")]); return null
	J.mc(cv, "addEventListener", ["pointerdown", pdn])
	var pmv = func(_t = null, a = null):
		var e = _a(A_(a), 0); var d = dd[0]
		if d == null: return null
		var dx = n_(gp(e, "clientX")) - n_(d.x0)
		if not d.moved and absf(dx) > 9: d["moved"] = true
		if d.moved:
			var now = perf_now(); var dt = maxf(16.0, now - n_(d.lt))
			J.sp(Sc, "camX", clamp_cam(Sc, n_(d.c0) - dx / unit.call()))
			J.sp(Sc, "camV", maxf(-2.5, minf(2.5, 0.7 * n_(gp(Sc, "camV")) + 0.3 * (-(n_(gp(e, "clientX")) - n_(d.lx)) / unit.call()) / (dt / 1000))))
			d["lx"] = gp(e, "clientX"); d["lt"] = now; J.sp(Sc, "userPan", gp(Sc, "t"))
		return null
	J.mc(cv, "addEventListener", ["pointermove", pmv])
	var up = func(_t = null, a = null):
		var e = _a(A_(a), 0)
		if dd[0] == null: return null
		var was = dd[0]; dd[0] = null
		if not was.moved: J.sp(Sc, "camV", 0.0); mc(Sc, "tap", [e])
		else:
			if perf_now() - n_(was.lt) > 90 or absf(n_(gp(e, "clientX")) - n_(was.x0)) < 40: J.sp(Sc, "camV", 0.0)
			J.sp(Sc, "userPan", gp(Sc, "t"))
		return null
	var pcn = func(_t = null, _a2 = null):
		dd[0] = null; return null
	J.mc(cv, "addEventListener", ["pointerup", up]); J.mc(cv, "addEventListener", ["pointercancel", pcn])
	var m = Q("#sc-map")
	if J.t(m):
		var mpd = func(_t = null, a = null):
			var e = _a(A_(a), 0); var r = J.mc(m, "getBoundingClientRect", []); var x = (n_(gp(e, "clientX")) - n_(gp(r, "left"))) / n_(gp(r, "width")) * n_(gp(OM(), "WW"))
			J.sp(Sc, "camV", 0.0); J.sp(Sc, "camTo", clamp_cam(Sc, x - view_w(Sc) / 2)); J.sp(Sc, "userPan", gp(Sc, "t")); return null
		J.mc(m, "addEventListener", ["pointerdown", mpd])
	var f = Q("#sc-follow")
	if J.t(f):
		var fcb = func(_t = null, _a2 = null):
			J.sp(Sc, "follow", not J.t(gp(Sc, "follow"))); J.mc(gp(f, "classList"), "toggle", ["on", J.t(gp(Sc, "follow"))])
			if J.t(gp(Sc, "follow")): J.sp(Sc, "userPan", -99.0)
			return null
		J.sp(f, "onclick", fcb)
	J.sp(Sc, "_panning", func(_t = null, _a2 = null): return dd[0] != null)

static func cam_tick(Sc, rdt: float) -> void:
	if not pano(Sc): return
	var vw = view_w(Sc); var camX = n_(gp(Sc, "camX"))
	if gp(Sc, "camTo") != null:
		var to = n_(gp(Sc, "camTo")); camX += (to - camX) * minf(1.0, rdt * 9); J.sp(Sc, "camX", camX)
		if absf(to - camX) < 0.002: J.sp(Sc, "camX", to); J.sp(Sc, "camTo", null)
	elif not (J.t(gp(Sc, "_panning")) and J.t(J.cl(gp(Sc, "_panning"), null, []))):
		var cv = n_(gp(Sc, "camV"))
		if absf(cv) > 0.01: J.sp(Sc, "camX", camX + cv * rdt); J.sp(Sc, "camV", cv * exp(-rdt * 4.5))
		var n = gp(Sc, "sel")
		if J.t(gp(Sc, "follow")) and J.t(n) and not J.t(gp(n, "gone")) and not J.t(gp(n, "out")) and not J.t(gp(n, "fleeing")) and not J.t(gp(n, "leaving")) and not J.t(gp(Sc, "selAuto")) and t_(Sc) - n_(gp(Sc, "userPan")) > 2.5 and absf(n_(gp(Sc, "camV"))) < 0.05:
			var vx = _vxy(n)[0]; var cx = n_(gp(Sc, "camX")); var l = cx + vw * 0.18; var r = cx + vw * 0.82
			if vx < l or vx > r: J.sp(Sc, "camX", cx + (vx - vw * 0.18 if vx < l else vx - vw * 0.82) * minf(1.0, rdt * 2.2))
	var c = clamp_cam(Sc, n_(gp(Sc, "camX")))
	if c != n_(gp(Sc, "camX")): J.sp(Sc, "camV", 0.0)
	J.sp(Sc, "camX", c)

static func frame(Sc, now: float) -> void:
	if not J.t(gp(Sc, "active")): return
	if now - n_(gp(Sc, "last")) < 1000.0 / 30 - 2: raf(Sc); return
	var rdt = minf(0.05, (now - n_(gp(Sc, "last"))) / 1000); var dt = rdt * or_(gp(Sc, "timeScale"), 1.0); J.sp(Sc, "last", now); cam_tick(Sc, rdt)
	if not J.t(gp(Sc, "paused")) and not J.t(J.mc(_g("Story"), "busy", [])): mc(Sc, "step", [dt])
	if not J.t(gp(Sc, "active")): return
	mc(Sc, "floatTick", [rdt])
	mc(Sc, "draw", [now / 1000])
	if not J.t(gp(Sc, "paused")): mc(Sc, "hud")
	raf(Sc)

static func finish(Sc, quit) -> void:
	if not J.t(gp(Sc, "active")): return
	J.sp(Sc, "active", false)
	var eh = _g("__nat_scEnd")
	if J.t(gp(Sc, "_nat")) and eh != null: J.cl(eh, null, [Sc])
	var S0 = _g("S")
	if not J.t(gp(S0, "scare")): J.sp(S0, "scare", {"best": {}, "runs": 0.0, "fv": 3.0})
	migrate(Sc); var sc = gp(S0, "scare"); J.sp(sc, "runs", n_(gp(sc, "runs")) + 1)
	var sid = gp(Sc, "siteId"); var kpi = n_(gp(Sc, "kpi"))
	var best = or_(gp(gp(sc, "best"), sid), 0.0); var stars = int(stars_of(Sc, sid, kpi)); var first = stars > stars_of(Sc, sid, best)
	if kpi > best: J.sp(gp(sc, "best"), sid, kpi)
	var kar = 0.0
	for k in A_(gp(Sc, "karma")): kar += n_(gp(k, "v"))
	var pay = n_(_g("SCARE_PAY"))
	var rw = {"exp": jround(kpi / 5 * pay), "coins": jround(kpi / 2 * pay)}
	if first: rw["chest"] = ["g", "b", "p"][stars - 1]
	J.sp(Sc, "_legendHTML", J.mc(_g("ScareX"), "finish", [Sc, float(stars), quit]) if _g("ScareX") != null else "")
	var got = J.cl(_g("give"), null, [rw]); J.cl(_g("save"), null, [])
	var rate = ["親，今晚的 KPI 沒達標哦～明晚加油！", "親，一星好評！離退休還有九百九十九顆星～", "親，二星好評！黃總說你很有潛力（並沒有加薪）。", "親，三星好評！全陰司本月最佳嚇人員工！"][stars]
	var kl = ""
	var karma = A_(gp(Sc, "karma"))
	if karma.size():
		for k in karma: kl += "<li class=\"%s\">陰德 %s%s　%s</li>" % ["up" if n_(gp(k, "v")) > 0 else "dn", "+" if n_(gp(k, "v")) > 0 else "", S(gp(k, "v")), S(gp(k, "why"))]
	else: kl = "<li>今晚沒有人因為你改變人生。</li>"
	var kword = "你今晚救了人。系統不會算這個，但是有人會記得。" if kar >= 4 else ("嚇對人了。" if kar > 0 else ("有些人，其實不用嚇。" if kar < 0 else ""))
	var exp_ = J.t(gp(Sc, "expelled"))
	J.sp(Q("#scare"), "innerHTML", "<div class=\"sc-end\"><h3>%s</h3>%s<div class=\"sc-stars\">%s%s</div>\n      <p class=\"sc-big\">驚嚇值 %s</p><p class=\"desc\">【陰司 KPI 系統】%s</p><p class=\"desc\">獎勵：%s</p>\n      %s<h4>陰德（系統沒有算這一欄）</h4><ul class=\"sc-karma\">%s</ul><p class=\"desc\">%s</p><button class=\"btn gold wide\" id=\"sc-back\">回村子</button></div>" % [
		"阿福被道士請走了" if exp_ else ("提早收工" if J.t(quit) else "天亮了，收工"), "<p class=\"desc\">做法完成，今晚 KPI 只計一半。下次低調啲：唔好俾人望到。</p>" if exp_ else "", "★".repeat(stars), "☆".repeat(3 - stars),
		S(gp(Sc, "kpi")), rate, S(got), S(gp(Sc, "_legendHTML")) if J.t(gp(Sc, "_legendHTML")) else "", kl, kword])
	J.sp(Q("#sc-back"), "onclick", func(_t = null, _a2 = null):
		J.mc(gp(Q("#scare"), "classList"), "remove", ["on"]); J.sp(Q("#scare"), "innerHTML", ""); J.mc(_g("Sound"), "setMode", ["village"]); J.mc(_g("UI"), "refresh", []); return null)

static func _a(a: Array, i: int): return a[i] if i < a.size() else null
static func _install() -> void:
	var Sc: Dictionary = J.G["Scare"]
	var M = {
		"viewW": func(t, _a2): return view_w(t),
		"clampCam": func(t, a): return clamp_cam(t, n_(_a(a, 0))),
		"camRoom": func(t, _a2): return cam_room(t),
		"roomOf": func(t, a): return room_of(t, _a(a, 0)),
		"sameRoom": func(t, a): return same_room(t, _a(a, 0), _a(a, 1)),
		"onScreen": func(t, a): return on_screen(t, n_(_a(a, 0)), _a(a, 1)),
		"bgScale": func(t, _a2): return bg_scale(t),
		"pt": func(t, a): return pt(t, n_(_a(a, 0)), n_(_a(a, 1))),
		"depth": func(t, a): return depth(t, n_(_a(a, 0))),
		"persp": func(t, _a2): return persp(t),
		"bgAR": func(t, _a2): return bg_ar(t),
		"hhF": func(t, a): return hh_f(t, n_(_a(a, 0))),
		"hh": func(t, a): return hh(t, n_(_a(a, 0))),
		"office": func(t, _a2): return office(t),
		"migrate": func(t, _a2): migrate(t); return null,
		"starsOf": func(t, a): return stars_of(t, _a(a, 0), _a(a, 1)),
		"rng": func(_t, a): return rng(_a(a, 0)),
		"U": func(_t, a): return U(_a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"rnd": func(_t, a): return rnd(_a(a, 0)),
		"exitPt": func(t, _a2): return exit_pt(t),
		"present": func(t, a): return present(t, _a(a, 0)),
		"sitting": func(t, a): return sitting(t, _a(a, 0)),
		"viaElev": func(t, a): return via_elev(t, _a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"inDoor": func(t, a): return in_door(t, n_(_a(a, 0))),
		"walkBlocked": func(t, a): return walk_blocked(t, _a(a, 0), n_(_a(a, 1))),
		"busy": func(t, a): return busy(t, _a(a, 0), n_(_a(a, 1))),
		"freeSpot": func(t, a): return free_spot(t, _a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"tagExt": func(t, a): return tag_ext(t, _a(a, 0)),
		"inBeam": func(t, a): return in_beam(t, _a(a, 0), n_(_a(a, 1)), n_(_a(a, 2))),
		"groupRoom": func(t, _a2): return group_room(t),
		"inGroup": func(t, a): return in_group(t, _a(a, 0), _a(a, 1)),
		"propOK": func(t, a): return prop_ok(t, _a(a, 0), _a(a, 1)),
		"gpq": func(t, a): return gpq(t, _a(a, 0)),
		"ghostType": func(t, a): return ghost_type(t, _a(a, 0), _a(a, 1)),
		"headsDown": func(t, a): return heads_down(t, _a(a, 0)),
		"watching": func(t, a): return watching(t, _a(a, 0)),
		"sees": func(t, a): return sees(t, _a(a, 0), _a(a, 1)),
		"witnesses": func(t, a): return witnesses(t, _a(a, 0)),
		"hearers": func(t, a): return hearers(t, _a(a, 0)),
		"workOf": func(t, a): return work_of(t, _a(a, 0)),
	}
	for k in M: ORIG[k] = Sc.get(k); Sc[k] = M[k]; NAT[k] = M[k]

	var M2 = {
		"bubble": func(t, a): bubble(t, _a(a, 0), _a(a, 1), _a(a, 2), _a(a, 3)); return null,
		"step": func(t, a): step(t, n_(_a(a, 0))); return null,
		"moveNpc": func(t, a): move_npc(t, _a(a, 0), n_(_a(a, 1))); return null,
		"shiftInit": func(t, _a2): shift_init(t); return null,
		"goOut": func(t, a): go_out(t, _a(a, 0), n_(_a(a, 1)), _a(a, 2), _a(a, 3), _a(a, 4)); return null,
		"outTick": func(t, a): out_tick(t, _a(a, 0), n_(_a(a, 1))); return null,
		"elevator": func(t, _a2): elevator(t); return null,
		"planMove": func(t, a): plan_move(t, _a(a, 0), n_(_a(a, 1))); return null,
		"freeSeat": func(t, a): return free_seat(t, _a(a, 0), _a(a, 1)),
		"restStep": func(t, a): return rest_step(t, _a(a, 0), _a(a, 1), _a(a, 2), _a(a, 3)),
		"mkStep": func(t, a): return mk_step(t, _a(a, 0), _a(a, 1)),
		"planNext": func(t, a): return plan_next(t, _a(a, 0)),
		"bossCall": func(t, a): return boss_call(t, _a(a, 0), J.str(_a(a, 1))),
		"wakeGuard": func(t, a): wake_guard(t, _a(a, 0)); return null,
		"expose": func(t, a): expose(t, _a(a, 0), _a(a, 1)); return null,
		"expoTick": func(t, a): expo_tick(t, n_(_a(a, 0))); return null,
		"daoTick": func(t, a): dao_tick(t, _a(a, 0), n_(_a(a, 1))); return null,
		"jumpy": func(t, a): jumpy(t, _a(a, 0), _a(a, 1)); return null,
		"addKarma": func(t, a): add_karma(t, _a(a, 0), _a(a, 1), _a(a, 2)); return null,
	}
	for k in M2: ORIG[k] = Sc.get(k); Sc[k] = M2[k]; NAT[k] = M2[k]

	var M3 = {
		"useProp": func(t, a): use_prop(t, _a(a, 0), _a(a, 1)); return null,
		"usePhone": func(t, a): use_phone(t, _a(a, 0)); return null,
		"useBreath": func(t, a): use_breath(t, _a(a, 0)); return null,
		"useGhost": func(t, a): use_ghost(t, _a(a, 0), _a(a, 1)); return null,
		"hit": func(t, a): hit(t, _a(a, 0), _a(a, 1), n_(_a(a, 2)), n_(_a(a, 3)), _a(a, 4), _a(a, 5)); return null,
		"perceive": func(t, a): perceive(t, _a(a, 0), n_(_a(a, 1)), J.t(_a(a, 2)), J.t(_a(a, 3)), A_(_a(a, 4)) if J.t(_a(a, 4)) else [], J.t(_a(a, 5)), J.t(_a(a, 6))); return null,
	}
	for k in M3: ORIG[k] = Sc.get(k); Sc[k] = M3[k]; NAT[k] = M3[k]

	var M4 = {
		"tap": func(t, a): tap(t, _a(a, 0)); return null,
		"renderDock": func(t, _a2): render_dock(t); return null,
		"renderTarget": func(t, _a2): render_target(t); return null,
		"profile": func(t, a): return profile(t, _a(a, 0)),
		"peek": func(t, a): peek(t, _a(a, 0)); return null,
		"hud": func(t, _a2): hud(t); return null,
		"floatTick": func(t, a): float_tick(t, n_(_a(a, 0))); return null,
		"float": func(t, a): float_(t, _a(a, 0), _a(a, 1), _a(a, 2), _a(a, 3), _a(a, 4)); return null,
		"floatOld": func(t, a): float_old(t, _a(a, 0), _a(a, 1), _a(a, 2), _a(a, 3), _a(a, 4)); return null,
		"toast": func(t, a): toast_(t, _a(a, 0)); return null,
		"dust": func(t, a): dust(t, _a(a, 0)); return null,
		"propParts": func(t, a): prop_parts(t, _a(a, 0), _a(a, 1), _a(a, 2)); return null,
	}
	for k in M4: ORIG[k] = Sc.get(k); Sc[k] = M4[k]; NAT[k] = M4[k]

	var M5 = {
		"react": func(t, a): react(t, _a(a, 0), _a(a, 1), _a(a, 2)); return null,
		"animNpc": func(t, a): anim_npc(t, _a(a, 0), n_(_a(a, 1))); return null,
		"onReact": func(t, a): on_react(t, _a(a, 0)); return null,
		"rigOK": func(t, a): return rig_ok(t, _a(a, 0)),
		"visPos": func(t, a): return vis_pos(t, _a(a, 0)),
		"npcPose": func(t, a): return npc_pose(t, _a(a, 0)),
	}
	for k in M5: ORIG[k] = Sc.get(k); Sc[k] = M5[k]; NAT[k] = M5[k]

	var M6 = {
		"draw": func(t, a): draw(t, n_(_a(a, 0))); return null,
		"drawEdge": func(t, a): draw_edge(t, _a(a, 0), n_(_a(a, 1))); return null,
		"drawBreath": func(t, a): draw_breath(t, _a(a, 0), _a(a, 1), n_(_a(a, 2))); return null,
		"propMarks": func(t, a): prop_marks(t, _a(a, 0), n_(_a(a, 1))); return null,
		"drawCue": func(t, a): draw_cue(t, _a(a, 0), _a(a, 1), n_(_a(a, 2)), n_(_a(a, 3)), n_(_a(a, 4))); return null,
		"drawNpc": func(t, a): return draw_npc(t, _a(a, 0), _a(a, 1), n_(_a(a, 2))),
		"drawNpcSprite": func(t, a): draw_npc_sprite(t, _a(a, 0), _a(a, 1), _a(a, 2), n_(_a(a, 3)), J.t(_a(a, 4))); return null,
		"npcFx": func(t, a): npc_fx(t, _a(a, 0), _a(a, 1), _a(a, 2), n_(_a(a, 3)), n_(_a(a, 4)), n_(_a(a, 5)), J.t(_a(a, 6)), n_(_a(a, 7))); return null,
		"drawTeam": func(t, a): draw_team(t, _a(a, 0), n_(_a(a, 1))); return null,
		"drawGhost": func(t, a): draw_ghost(t, _a(a, 0), _a(a, 1), n_(_a(a, 2))); return null,
		"drawBubble": func(t, a): draw_bubble(t, _a(a, 0), _a(a, 1), n_(_a(a, 2)), n_(_a(a, 3)), _a(a, 4), _a(a, 5)); return null,
	}
	for k in M6: ORIG[k] = Sc.get(k); Sc[k] = M6[k]; NAT[k] = M6[k]

	var M7 = {
		"open": func(t, a): open(t, _a(a, 0)); return null,
		"start": func(t, a): start(t, _a(a, 0), _a(a, 1), _a(a, 2), _a(a, 3)); return null,
		"resize": func(t, _a2): resize(t); return null,
		"bindPan": func(t, a): bind_pan(t, _a(a, 0)); return null,
		"camTick": func(t, a): cam_tick(t, n_(_a(a, 0))); return null,
		"frame": func(t, a): frame(t, n_(_a(a, 0))); return null,
		"finish": func(t, a): finish(t, _a(a, 0)); return null,
	}
	for k in M7: ORIG[k] = Sc.get(k); Sc[k] = M7[k]; NAT[k] = M7[k]

func run(env) -> void:
	_trans = load("res://jsgen/scare.gd").new()
	_trans.run(env)
	ORIG = {}; NAT = {}
	_install()
