# 原生改寫自 station_foes.js：陽間站崗・強敵＋封禁（StnFoes）
# 三款強敵（茅山道士／現代捉鬼師／靈異直播主）由 Street.Turf 生路人時 decorate；佢哋封禁設備、暫停、灑鹽米、光環加膽。
# 介面同轉譯版一樣：J.G["StnFoes"] = { FOES, RES, reset, spawnTable, roll, decorate, update, draw, drawBody, drawFu, onHit, isSealed, isPaused, blocks, devMul, state(getter) }
# W（Turf）、路人 w 都係 JS 物件：經 J.gp／J.mc 存取。隨機數用 randf()，次序同 JS 一樣（對照用 seed）。
extends RefCounted

const PX := 1.0 / 2160.0
const CELL := 150.0 * PX
const FOES_JSON := """{
 "taoist":{"n":["茅山道士","茅山道士"],"tag":"#ffd45a","minLv":6,"w":1.0,"hp":3.6,"spd":0.8,"award":4,"res":true,
  "range":240,"chant":1.6,"seal":[6,10],"maxSeal":2,"cd":3.5,"retreat":0.45,
  "chantL":[["孽障，乖乖返去！","孽障，乖乖回去！"],["呢度唔到你放肆！","這裡輪不到你放肆！"],["貧道今晚當值，咪搞事。","貧道今晚值班，別搗亂。"],["陰陽有別，退！","陰陽有別，退！"],["定！","定！"]],
  "retreatL":[["好重陰氣……撤符先！","陰氣好重……先撤符！"],["今晚算你哋叻。","今晚算你們厲害。"]],
  "re":[["嗯？有啲門道。","嗯？有點門道。"],["穩住，唔好亂。","穩住，不要亂。"],["小把戲。","小把戲。"]],
  "big":[["改日再嚟會你！","改天再來會你！"],["道行唔夠，收工！","道行不夠，收工！"]]},
 "hunter":{"n":["現代捉鬼師","現代捉鬼師"],"tag":"#7fd0ff","minLv":4,"w":1.2,"hp":3.0,"spd":0.95,"award":3.5,"res":true,
  "beam":{"r":300,"half":0.75,"dur":4,"cd":[5,7],"scan":1.1},"salt":{"r":1.3,"reach":300,"dur":6,"mul":0.6,"cd":[9,13]},
  "beamL":[["照住你，咪郁！","照住你，別動！"],["羅盤轉到癲咗，就喺度！","羅盤轉瘋了，就在這！"],["讀數爆錶！","讀數爆表！"]],
  "saltL":[["鹽米開路！","鹽米開路！"],["灑啲鹽米先，穩陣啲。","先撒點鹽米，穩妥點。"]],
  "re":[["數據有異動……","數據有異動……"],["冇事，計我嘅。","沒事，交給我。"]],
  "big":[["數據唔對路，撤！","數據不對勁，撤！"],["器材頂唔順喇！","器材撐不住了！"]]},
 "streamer":{"n":["靈異直播主","靈異直播主"],"tag":"#ff7ab8","minLv":2,"w":1.4,"hp":0.7,"spd":0.9,"award":2.5,"res":false,"take":1.3,
  "aura":{"r":170,"mul":1.3},"talkCd":[6,9],
  "talkL":[["家人們，入嚟睇吓！","家人們，進來看看！"],["打賞夠一千我就行入去！","打賞滿一千我就走進去！"],["唔使驚，有我喺度！","不用怕，有我在！"],["燈開大啲，畀大家睇清楚！","燈開大點，讓大家看清楚！"]],
  "re":[["啊！你哋見唔見到？","啊！你們看到沒有？"],["冇事冇事……","沒事沒事……"]],
  "big":[["哇！斷咗線先！","哇！先斷線！"],["今晚唔播喇！","今晚不播了！"]]}
}"""

static var FOES: Dictionary = {}
static var IDS: Array = []
static var RES := {"cap": 0.4, "tail": 0.2}
static var S = null
static var FU = null
static var _added := {}

# ---------- 小工具 ----------
static func g(o, k): return J.gp(o, k)
static func n(v) -> float: return J.num(v)
static func t_(v) -> bool: return J.t(v)
static func R(a: float, b: float) -> float: return a + randf() * (b - a)
static func pick(a: Array): return a[int(floor(randf() * a.size()))]
static func rnd(x: float) -> float: return floor(x + 0.5)
static func T(yue: String, zh: String) -> String:
	if not _added.has(yue):
		var LG = J.G.get("LANG")
		if J.typeof_(LG) != "undefined" and J.t(J.gp(LG, "add")): J.mc(LG, "add", [{yue: zh}])
		_added[yue] = true
	var Wn = J.G.get("window")
	if J.typeof_(Wn) != "undefined" and J.t(J.gp(Wn, "L")): return J.str(DB.N(J.str(J.S_window_("L", [yue]))))
	return DB.N(yue)
static func now() -> float:
	return n(J.S_performance_("now", []) if J.typeof_(J.G.get("performance")) != "undefined" else J.S_Date_("now", [])) / 1000.0
static func has_same(arr, x) -> bool:
	for e in J.iter(arr): if is_same(e, x): return true
	return false
static func mget(M, k): return J.mc(M, "get", [k])
static func s_str(v) -> String: return J.str(v)

# ---------- 狀態 ----------
static func reset() -> void:
	S = {"seals": [], "brk": [], "pause": J.new_("Map", []), "salt": J.new_("Map", []), "saltFx": [], "beams": [], "wave": 0.0, "warned": J.new_("Set", []), "lines": J.new_("Set", [])}
static func brk_add(s, W) -> void:
	if not t_(S.get("brk")): S["brk"] = []
	var p = spot_of(s, W)
	if p != null: S.brk.append({"kind": s.kind, "i": s.i, "x": p[0], "y": p[1], "t": 0.0, "dur": 1.0, "seed": s.seed if t_(s.get("seed")) else 0.0})
static func seal_im():
	var SP = J.G.get("SPR")
	var im = J.gp(SP, "vfx_seal") if J.typeof_(SP) != "undefined" else null
	return im if t_(im) and t_(J.gp(im, "naturalWidth")) else null

static func line(w, pool: Array, dur = null) -> void:
	var free = pool.filter(func(q): return not J.t(J.mc(S.lines, "has", [q[0]])))
	var q = pick(free if free.size() else pool)
	var sy = g(w, "say")
	if t_(sy) and t_(g(sy, "_foe")): J.mc(S.lines, "delete", [g(sy, "_foe")])
	J.mc(S.lines, "add", [q[0]])
	var d = n(dur) if t_(dur) else 1.6
	J.sp(w, "say", {"s": T(q[0], q[1]), "t": d, "_foe": q[0]})
	var k = q[0]
	J.F_setTimeout([func(_t, _a):
		if S != null: J.mc(S.lines, "delete", [k])
		return null, d * 1000.0 + 200.0])

# ---------- 生成 ----------
static func slot_chance(lv: float) -> float:
	return minf(0.3, maxf(0.0, 0.03 + 0.012 * (lv - 2)) * (1 + minf(1.0, n(S.wave) / 20.0)))
static func spawn_table(lv: float) -> Array:
	var ok = IDS.filter(func(id): return lv >= n(FOES[id].minLv))
	var tw = 0.0
	for id in ok: tw += n(FOES[id].w)
	var pc = slot_chance(lv) if ok.size() else 0.0
	return ok.map(func(id): return {"id": id, "name": T(FOES[id].n[0], FOES[id].n[1]), "weight": FOES[id].w, "chance": pc * n(FOES[id].w) / tw, "hpMul": FOES[id].hp})
static func wave_cap(lv: float) -> float: return 1.0 if lv < 8 else (2.0 if lv < 18 else 3.0)
static func roll(lv: float, q):
	if t_(q):
		if n(g(q, "made")) <= 1 or not is_same(g(q, "_foeWave"), q): J.sp(q, "_foeN", 0.0); J.sp(q, "_foeWave", q)
		if n(g(q, "made")) <= 1: S["wave"] = n(S.wave) + 1
		if n(g(q, "_foeN")) >= wave_cap(lv): return null
	var tb = spawn_table(lv)
	if not tb.size(): return null
	var r = randf()
	for e in tb:
		if r < e.chance:
			if t_(q): J.sp(q, "_foeN", (n(g(q, "_foeN")) if t_(g(q, "_foeN")) else 0.0) + 1)
			return e.id
		r -= e.chance
	return null
static func decorate(w, id):
	var C = FOES.get(J.str(id))
	if C == null or not t_(w): return w
	var cd = R(1, 2); var bcd = R(1.5, 3); var scd = R(4, 6); var lt = R(1, 3)
	J.sp(w, "foe", {"id": id, "by": {}, "cd": cd, "bcd": bcd, "scd": scd, "lt": lt, "chant": null, "scan": 0.0, "retreated": false})
	J.sp(w, "tr", null); J.sp(w, "mate", null); J.sp(w, "tint", null); J.sp(w, "el", null); J.sp(w, "tT", 99.0)
	J.sp(w, "p", {"id": "foe_" + id, "n": C.n[0], "zh": C.n[1], "re": C.re, "big": C.big, "hp": 1.0, "spd": 1.0, "w": 0.0})
	J.sp(w, "n", T(C.n[0], C.n[1])); J.sp(w, "spr", "foe_" + id)
	var mx = rnd(n(g(w, "max")) * n(C.hp)); J.sp(w, "max", mx); J.sp(w, "hp", mx)
	J.sp(w, "spd", n(g(w, "spd")) * n(C.spd)); J.sp(w, "award", rnd(13 * n(C.award)))
	return w

# ---------- 查詢 ----------
static func seal_of(o):
	for s in S.seals: if is_same(s.tgt, o): return s
	return null
static func is_sealed(o) -> float:
	var s = seal_of(o) if t_(o) else null
	return maxf(0.0, n(s.dur) - n(s.t)) if s != null else 0.0
static func is_paused(p) -> float:
	var s = mget(S.pause, p) if t_(p) else null
	return maxf(0.0, n(g(s, "dur")) - n(g(s, "t"))) if t_(s) else 0.0
static func blocks(o) -> bool: return is_sealed(o) > 0 or is_paused(o) > 0
static func dev_mul(p) -> float:
	var s = mget(S.salt, p) if t_(p) else null
	return n(FOES.hunter.salt.mul) if t_(s) else 1.0

# ---------- 受驚 ----------
static func on_hit(w, dmg: float, o, W) -> float:
	if not t_(o): o = {}
	var role = J.gp(W, "_foeRole") if t_(W) else null
	if not t_(role): role = "other"
	var wf = g(w, "foe")
	if t_(W) and (not t_(wf) or J.str(g(wf, "id")) != "streamer"):
		var pos = J.mc(W, "wp", [w]); var A = FOES.streamer.aura
		for q in J.iter(g(W, "walkers")):
			var qf = g(q, "foe")
			if not is_same(q, w) and t_(qf) and J.str(g(qf, "id")) == "streamer" and t_(J.mc(W, "alive", [q])) and n(J.mc(W, "dist", [J.mc(W, "wp", [q]), pos])) < n(A.r) * PX:
				dmg /= n(A.mul); break
	if not t_(wf): return dmg
	var F = wf; var C = FOES[J.str(F.id)]
	if t_(C.get("take")): dmg *= n(C.take)
	if t_(C.res) and not t_(g(o, "force")):
		var cap_amt = RES.cap * n(g(w, "max")); var done = n(F.by.get(role)) if t_(F.by.get(role)) else 0.0
		var full = minf(dmg, maxf(0.0, cap_amt - done))
		var eff = full + (dmg - full) * RES.tail; F.by[role] = done + eff
		if dmg - full > 0 and not t_(J.mc(S.warned, "has", [w])) and t_(W):
			J.mc(S.warned, "add", [w]); var xy = J.mc(W, "wp", [w])
			J.mc(W, "float", [xy[0], n(xy[1]) - 0.12, T("同一招唔夠嚇佢，夾埋第二類設備！", "同一招嚇不倒他，搭配其他類設備！"), "#ffcf7a"])
		dmg = eff
	else: F.by[role] = (n(F.by.get(role)) if t_(F.by.get(role)) else 0.0) + dmg
	if t_(F.get("chant")) and dmg >= 0.06 * n(g(w, "max")):
		F.chant.t = maxf(0.0, n(F.chant.t) - 0.5); F.chant.jolt = 0.4
	return dmg

# ---------- 更新 ----------
static func release(by, W, quiet := false) -> void:
	var keep = []
	for s in S.seals:
		if not is_same(s.by, by): keep.append(s); continue
		if t_(W): brk_add(s, W)
		if not quiet and t_(W):
			var p = spot_of(s, W)
			if p != null: J.mc(W, "float", [p[0], n(p[1]) - 0.06, T("黃符撤走", "黃符撤走"), "#ffe9a0"])
	S["seals"] = keep
static func spot_of(s, W):
	if J.str(s.kind) == "boss": return J.mc(W, "bpos", [s.tgt]) if t_(g(W, "bpos")) else null
	var sp = J.gp(g(g(W, "lay"), "posts"), s.i)
	return [g(sp, "x"), g(sp, "y")] if t_(sp) else null
static func dev_list(W) -> Array:
	var out = []; var ps = g(g(W, "sd"), "posts"); var lp = g(g(W, "lay"), "posts")
	if not t_(ps): return out
	var i = 0
	for p in J.iter(ps):
		var sp = J.gp(lp, float(i))
		if t_(p) and t_(g(p, "role")) and not (n(g(p, "build")) > 0) and t_(sp): out.append({"p": p, "i": float(i), "sp": sp})
		i += 1
	return out
static func bosses(W) -> Array:
	var b = g(W, "bosses")
	return b if b is Array else []

static func update(dt: float, W) -> void:
	for s in S.seals: s.t = n(s.t) + dt
	var keep = []
	for s in S.seals:
		var gone = (not has_same(bosses(W), s.tgt)) if J.str(s.kind) == "boss" else not is_same(J.gp(g(g(W, "sd"), "posts"), s.i), s.tgt)
		if gone: continue
		if n(s.t) < n(s.dur): keep.append(s); continue
		brk_add(s, W); var p = spot_of(s, W)
		if p != null: J.mc(W, "float", [p[0], n(p[1]) - 0.06, T("解封！", "解封！"), "#9ef0b0"])
	S["seals"] = keep
	for M in [S.pause, S.salt]:
		for kv in J.mc(M, "entries", []):
			var v = kv[1]; v.t = n(v.t) + dt
			if n(v.t) >= n(v.dur): J.mc(M, "delete", [kv[0]])
	S["saltFx"] = S.saltFx.filter(func(f): f.t = n(f.t) + dt; return n(f.t) < n(f.dur))
	S["brk"] = (S.brk if t_(S.get("brk")) else []).filter(func(f): f.t = n(f.t) + dt; return n(f.t) < n(f.dur))
	S["beams"] = S.beams.filter(func(f): f.t = n(f.t) + dt; return n(f.t) < n(f.dur))
	var ws = g(W, "walkers"); var i = 0
	while i < J.len(ws):
		var w = J.gp(ws, float(i)); i += 1
		var F = g(w, "foe")
		if not t_(F): continue
		if t_(g(w, "gone")):
			if J.str(F.id) == "taoist" and not t_(F.get("released")): F["released"] = true; release(w, W)
			continue
		if not t_(J.mc(W, "alive", [w])): continue
		var id = J.str(F.id)
		if id == "taoist": tao_tick(w, F, dt, W)
		elif id == "hunter": hunt_tick(w, F, dt, W)
		else: stream_tick(w, F, dt)
static func block(w) -> void: J.sp(w, "block", maxf(n(g(w, "block")) if t_(g(w, "block")) else 0.0, 0.15))
static func tao_tick(w, F, dt: float, W) -> void:
	var C = FOES.taoist; var pos = J.mc(W, "wp", [w]); F.cd = n(F.cd) - dt
	if not t_(F.retreated) and n(g(w, "hp")) / n(g(w, "max")) < n(C.retreat):
		F.retreated = true; F.chant = null; release(w, W); line(w, C.retreatL, 1.8); return
	if t_(F.chant):
		var ch = F.chant
		if n(ch.jolt) > 0: ch.jolt = n(ch.jolt) - dt
		var tgt_ok
		if J.str(ch.kind) == "boss": tgt_ok = has_same(bosses(W), ch.tgt) and not is_sealed(ch.tgt) > 0
		else: tgt_ok = is_same(J.gp(g(g(W, "sd"), "posts"), ch.i), ch.tgt) and not is_sealed(ch.tgt) > 0
		if not tgt_ok: F.chant = null; F.cd = 1.0; return
		block(w); ch.t = n(ch.t) + dt
		if n(ch.t) >= n(ch.dur):
			var dur = R(n(C.seal[0]), n(C.seal[1]))
			S.seals.append({"tgt": ch.tgt, "kind": ch.kind, "i": ch.i, "t": 0.0, "dur": dur, "by": w, "seed": randf() * 9})
			F.chant = null; F.cd = C.cd
			var p = spot_of(S.seals[-1], W)
			if p != null: J.mc(W, "float", [p[0], n(p[1]) - 0.08, T("名鬼被封印！", "名鬼被封印！") if J.str(ch.kind) == "boss" else T("設備被封！", "設備被封！"), "#ffd45a"])
		return
	var mine = 0
	for s in S.seals: if is_same(s.by, w): mine += 1
	if t_(F.retreated) or n(F.cd) > 0 or mine >= n(C.maxSeal): return
	var best = null; var bd = n(C.range) * PX
	for d in dev_list(W):
		if is_sealed(d.p) > 0: continue
		var sp = d.sp
		var r = n(J.mc(W, "rdist", [pos, sp])) if t_(g(W, "rdist")) else n(J.mc(W, "dist", [pos, [g(sp, "x"), g(sp, "y")]]))
		if r <= bd: bd = r; best = {"tgt": d.p, "kind": "dev", "i": d.i}
	for B in bosses(W):
		if t_(g(B, "hid")) or is_sealed(B) > 0 or not t_(g(W, "bpos")): continue
		var r2 = n(J.mc(W, "dist", [pos, J.mc(W, "bpos", [B])]))
		if r2 <= bd: bd = r2; best = {"tgt": B, "kind": "boss", "i": -1.0}
	if best == null: F.cd = 0.4; return
	best["t"] = 0.0; best["dur"] = C.chant; best["jolt"] = 0.0
	F.chant = best; block(w); line(w, C.chantL, 1.8)
static func hunt_tick(w, F, dt: float, W) -> void:
	var C = FOES.hunter; var pos = J.mc(W, "wp", [w]); F.bcd = n(F.bcd) - dt; F.scd = n(F.scd) - dt
	if n(F.scan) > 0: F.scan = n(F.scan) - dt; block(w); return
	var p0 = n(pos[0]); var p1 = n(pos[1])
	if n(F.bcd) <= 0:
		var ah = J.mc(W, "wp", [w, CELL * 0.6]); var dir = atan2((n(ah[1]) - p1) * 1.5, n(ah[0]) - p0); var B = C.beam
		var hit_l = dev_list(W).filter(func(d):
			var dx = n(g(d.sp, "x")) - p0; var dy = (n(g(d.sp, "y")) - p1) * 1.5; var r = sqrt(dx * dx + dy * dy)
			if r > n(B.r) * PX: return false
			var da = atan2(dy, dx) - dir; da = atan2(sin(da), cos(da)); return absf(da) <= n(B.half))
		if hit_l.size():
			for d in hit_l:
				var o = mget(S.pause, d.p)
				if not t_(o) or n(g(o, "dur")) - n(g(o, "t")) < n(B.dur): J.mc(S.pause, "set", [d.p, {"t": 0.0, "dur": B.dur, "i": d.i}])
			S.beams.append({"w": w, "dir": dir, "t": 0.0, "dur": n(B.scan) + 0.3, "r": n(B.r) * PX, "half": B.half, "x": pos[0], "y": pos[1]})
			F.scan = B.scan; F.bcd = R(n(B.cd[0]), n(B.cd[1])); block(w); line(w, C.beamL, 1.5); return
		F.bcd = 0.6
	if n(F.scd) <= 0:
		var Sa = C.salt
		var ds = dev_list(W).filter(func(d): return n(J.mc(W, "dist", [pos, [g(d.sp, "x"), g(d.sp, "y")]])) <= n(Sa.reach) * PX)
		if not ds.size(): F.scd = 1.0; return
		var rr = n(Sa.r) * CELL
		var score = func(d):
			var c = 0
			for e in ds: if n(J.mc(W, "dist", [[g(d.sp, "x"), g(d.sp, "y")], [g(e.sp, "x"), g(e.sp, "y")]])) <= rr: c += 1
			return c - n(J.mc(W, "dist", [pos, [g(d.sp, "x"), g(d.sp, "y")]]))
		var srt = J.mc(ds.duplicate(), "sort", [func(_t, a): return score.call(a[1]) - score.call(a[0])])
		var c0 = J.gp(srt, 0.0); var cx = g(c0.sp, "x"); var cy = g(c0.sp, "y")
		for d in dev_list(W):
			if n(J.mc(W, "dist", [[cx, cy], [g(d.sp, "x"), g(d.sp, "y")]])) <= rr: J.mc(S.salt, "set", [d.p, {"t": 0.0, "dur": Sa.dur, "i": d.i}])
		var gr = []
		for j in 46:
			var a = randf() * 6.283; var k = sqrt(randf())
			gr.append([cos(a) * k * rr, sin(a) * k * rr / 1.5, randf()])
		S.saltFx.append({"x": cx, "y": cy, "fx": pos[0], "fy": pos[1], "r": rr, "t": 0.0, "dur": Sa.dur, "gr": gr})
		F.scd = R(n(Sa.cd[0]), n(Sa.cd[1])); line(w, C.saltL, 1.4)
static func stream_tick(w, F, dt: float) -> void:
	var C = FOES.streamer; F.lt = n(F.lt) - dt
	if n(F.lt) <= 0 and not t_(g(w, "say")): F.lt = R(n(C.talkCd[0]), n(C.talkCd[1])); line(w, C.talkL, 1.6)

# ---------- 畫圖（ctx 經 J） ----------
static func cm(c, f: String, a := []): return J.mc(c, f, a)
static func cs(c, k: String, v) -> void: J.sp(c, k, v)
static func fu_canvas():
	if FU != null: return FU
	var cv = J.S_document_("createElement", ["canvas"]); J.sp(cv, "width", 64.0); J.sp(cv, "height", 160.0); var gg = J.mc(cv, "getContext", ["2d"])
	cs(gg, "fillStyle", "#f2cf45"); cm(gg, "fillRect", [0.0, 0.0, 64.0, 160.0]); var gr = cm(gg, "createLinearGradient", [0.0, 0.0, 64.0, 0.0])
	cm(gr, "addColorStop", [0.0, "rgba(160,100,10,0.25)"]); cm(gr, "addColorStop", [0.5, "rgba(255,255,255,0)"]); cm(gr, "addColorStop", [1.0, "rgba(160,100,10,0.25)"]); cs(gg, "fillStyle", gr); cm(gg, "fillRect", [0.0, 0.0, 64.0, 160.0])
	cs(gg, "strokeStyle", "#b8261c"); cs(gg, "fillStyle", "#b8261c"); cs(gg, "lineCap", "round"); cs(gg, "lineJoin", "round")
	cs(gg, "lineWidth", 2.0); cm(gg, "strokeRect", [4.0, 4.0, 56.0, 152.0])
	for j in 3: cm(gg, "beginPath"); cm(gg, "arc", [18.0 + j * 14, 18.0, 4.5, 0.0, 7.0]); cm(gg, "fill")
	cs(gg, "lineWidth", 3.2); cm(gg, "beginPath"); cm(gg, "moveTo", [10.0, 30.0]); cm(gg, "lineTo", [54.0, 30.0]); cm(gg, "stroke")
	cm(gg, "beginPath"); cm(gg, "moveTo", [32.0, 30.0])
	var y = 30.0
	while y <= 120: cm(gg, "lineTo", [32 + sin(y * 0.16) * 9, y]); y += 3
	cm(gg, "stroke")
	cs(gg, "lineWidth", 2.4)
	for v in [[17.0, 56.0, 1.0], [47.0, 74.0, -1.0], [17.0, 94.0, 1.0]]:
		cm(gg, "beginPath"); var a = 0.0
		while a < 12: var r = 1 + a * 0.75; cm(gg, "lineTo", [v[0] + cos(a * v[2]) * r, v[1] + sin(a * v[2]) * r]); a += 0.25
		cm(gg, "stroke")
	cs(gg, "lineWidth", 2.6)
	for yy in [44.0, 84.0, 108.0]:
		cm(gg, "beginPath"); cm(gg, "moveTo", [40.0, yy]); cm(gg, "lineTo", [54.0, yy - 4]); cm(gg, "stroke"); cm(gg, "beginPath"); cm(gg, "moveTo", [10.0, yy + 6]); cm(gg, "lineTo", [22.0, yy + 10]); cm(gg, "stroke")
	cs(gg, "lineWidth", 3.0); cm(gg, "beginPath"); cm(gg, "moveTo", [18.0, 126.0]); cm(gg, "lineTo", [46.0, 126.0]); cm(gg, "lineTo", [46.0, 146.0]); cm(gg, "lineTo", [18.0, 146.0]); cm(gg, "closePath"); cm(gg, "stroke")
	cm(gg, "beginPath"); cm(gg, "moveTo", [18.0, 126.0]); cm(gg, "lineTo", [46.0, 146.0]); cm(gg, "moveTo", [46.0, 126.0]); cm(gg, "lineTo", [18.0, 146.0]); cm(gg, "stroke")
	FU = cv; return FU
static func draw_fu(c, x: float, y: float, w: float, h: float, t: float, seed: float, alpha) -> void:
	var im = fu_canvas(); cm(c, "save"); cs(c, "globalAlpha", n(J.gp(c, "globalAlpha")) * (1.0 if alpha == null else n(alpha)))
	var nn = 18; var sh = h / nn
	for k in nn:
		var e = float(k) / (nn - 1); var off = sin(t * 5.5 + seed - k * 0.32) * w * 0.13 * e * e; var sk = 1 - 0.06 * e * absf(sin(t * 3 + seed + k * 0.3))
		if im != null: cm(c, "drawImage", [im, 0.0, k * 160.0 / nn, 64.0, 160.0 / nn + 0.5, x - w * sk / 2 + off, y + k * sh, w * sk, sh + 0.8])
		else: cs(c, "fillStyle", "#f2cf45"); cm(c, "fillRect", [x - w * sk / 2 + off, y + k * sh, w * sk, sh + 0.8])
	cm(c, "restore")
static func chain_line(c, ax: float, ay: float, bx: float, by: float, U: float, t: float) -> void:
	var L = sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay)); var nn = maxi(3, int(floor(L / (9 * U)))); var ang = atan2(by - ay, bx - ax)
	for j in nn + 1:
		var k = float(j) / nn; var x = ax + (bx - ax) * k; var y = ay + (by - ay) * k + sin(k * PI) * 4 * U
		cm(c, "save"); cm(c, "translate", [x, y]); cm(c, "rotate", [ang])
		cs(c, "lineWidth", 2.6 * U); cs(c, "strokeStyle", "#5a3c08"); cm(c, "beginPath")
		if j % 2: cm(c, "ellipse", [0.0, 0.0, 5.5 * U, 1.6 * U, 0.0, 0.0, 7.0])
		else: cm(c, "ellipse", [0.0, 0.0, 5.5 * U, 3.4 * U, 0.0, 0.0, 7.0])
		cm(c, "stroke")
		cs(c, "lineWidth", 1.6 * U); cs(c, "strokeStyle", "hsl(45,95%," + s_str(58 + 12 * sin(t * 4 + j)) + "%)"); cm(c, "stroke"); cm(c, "restore")
static func big_txt(c, s: String, x: float, y: float, px: float, fill: String, stroke = null) -> void:
	cs(c, "font", "900 " + s_str(px) + "px sans-serif"); cs(c, "textAlign", "center"); cs(c, "lineJoin", "round"); cs(c, "lineWidth", maxf(3.0, px * 0.22))
	cs(c, "strokeStyle", stroke if t_(stroke) else "#1a0f04"); cm(c, "strokeText", [s, x, y]); cs(c, "fillStyle", fill); cm(c, "fillText", [s, x, y])
static func dev_rect(W, i):
	var sp = J.gp(g(g(W, "lay"), "posts"), i); var b = g(W, "box")
	if not t_(sp): return null
	var sx = n(g(sp, "x")); var sy = n(g(sp, "y"))
	var q = J.mc(W, "rect", [sp]) if t_(g(W, "rect")) else [sx - CELL / 2, sy - CELL / 3, sx + CELL / 2, sy + CELL / 3]
	var bw = n(g(b, "w")); var bh = n(g(b, "h"))
	return [n(g(b, "x")) + n(q[0]) * bw, n(g(b, "y")) + n(q[1]) * bh, (n(q[2]) - n(q[0])) * bw, (n(q[3]) - n(q[1])) * bh]
static func P(W, xy) -> Array:
	var r = J.mc(W, "P", [xy[0], xy[1]]); return [n(r[0]), n(r[1])]
static func rgba(s: String, a: float) -> String: return "rgba(" + s + "," + s_str(a) + ")"

static func draw(c, W) -> void:
	var b = g(W, "box"); var bw = n(g(b, "w")); var U = bw / 840; var hh = n(g(b, "h")) * 0.042; var t = now()
	cm(c, "save")
	# 鹽米
	for f in S.saltFx:
		var cxy = P(W, [f.x, f.y]); var cx = cxy[0]; var cy = cxy[1]; var fade = minf(1.0, (n(f.dur) - n(f.t)) / 0.8); var land = minf(1.0, n(f.t) / 0.35)
		if land < 1:
			var a2 = P(W, [f.fx, f.fy])
			for gq in f.gr:
				var k = minf(1.0, land * (0.8 + n(gq[2]) * 0.4)); var x = a2[0] + (cx + n(gq[0]) * bw - a2[0]) * k; var y = a2[1] + (cy + n(gq[1]) * bw - a2[1]) * k - sin(k * PI) * 40 * U
				cs(c, "fillStyle", "rgba(255,255,255,0.95)"); cm(c, "fillRect", [x - 1.5 * U, y - 1.5 * U, 3 * U, 3 * U])
			continue
		cs(c, "fillStyle", rgba("230,240,255", 0.10 * fade)); cm(c, "beginPath"); cm(c, "ellipse", [cx, cy, n(f.r) * bw, n(f.r) * bw / 1.5, 0.0, 0.0, 7.0]); cm(c, "fill")
		cs(c, "strokeStyle", rgba("240,248,255", 0.35 * fade)); cm(c, "setLineDash", [[2 * U, 5 * U]]); cs(c, "lineWidth", 1.5 * U); cm(c, "stroke"); cm(c, "setLineDash", [[]])
		for gq in f.gr:
			var tw = 0.55 + 0.45 * sin(t * 6 + n(gq[2]) * 20)
			cs(c, "fillStyle", rgba("240,220,170", 0.9 * fade * tw) if n(gq[2]) < 0.35 else rgba("255,255,255", 0.95 * fade * tw))
			cm(c, "beginPath"); cm(c, "arc", [cx + n(gq[0]) * bw, cy + n(gq[1]) * bw, (2.2 if n(gq[2]) < 0.35 else 1.7) * U, 0.0, 7.0]); cm(c, "fill")
	# 強光電筒
	for B in S.beams:
		var w = B.w; var pos = J.mc(W, "wp", [w]) if t_(w) and not t_(g(w, "gone")) else [B.x, B.y]
		var xy = P(W, [pos[0], n(pos[1]) - 0.012]); var x = xy[0]; var y = xy[1]; var k = n(B.t) / n(B.dur)
		var al = (k / 0.15 if k < 0.15 else 1 - maxf(0.0, k - 0.6) / 0.4) * (0.85 + 0.15 * sin(t * 30)); var r = n(B.r) * bw
		cm(c, "save"); cm(c, "translate", [x, y]); cm(c, "scale", [1.0, 1 / 1.5]); var gg = cm(c, "createRadialGradient", [0.0, 0.0, 4 * U, 0.0, 0.0, r])
		cm(gg, "addColorStop", [0.0, rgba("255,252,215", 0.75 * al)]); cm(gg, "addColorStop", [0.6, rgba("255,248,190", 0.32 * al)]); cm(gg, "addColorStop", [1.0, "rgba(255,245,180,0)"])
		var dir = n(B.dir); var half = n(B.half)
		cs(c, "fillStyle", gg); cm(c, "beginPath"); cm(c, "moveTo", [0.0, 0.0]); cm(c, "arc", [0.0, 0.0, r, dir - half, dir + half]); cm(c, "closePath"); cm(c, "fill")
		cs(c, "strokeStyle", rgba("255,250,210", 0.5 * al)); cs(c, "lineWidth", 2 * U); cm(c, "beginPath"); cm(c, "moveTo", [0.0, 0.0]); cm(c, "lineTo", [cos(dir - half) * r, sin(dir - half) * r]); cm(c, "moveTo", [0.0, 0.0]); cm(c, "lineTo", [cos(dir + half) * r, sin(dir + half) * r]); cm(c, "stroke"); cm(c, "restore")
	# 直播主光環
	var walkers = g(W, "walkers")
	for w in J.iter(walkers):
		var F = g(w, "foe")
		if not t_(F) or J.str(g(F, "id")) != "streamer" or not t_(J.mc(W, "alive", [w])): continue
		var xy = P(W, J.mc(W, "wp", [w])); var x = xy[0]; var y = xy[1]; var r = n(FOES.streamer.aura.r) * PX * bw; var pu = 0.8 + 0.2 * sin(t * 3)
		var gg = cm(c, "createRadialGradient", [x, y, r * 0.2, x, y, r]); cm(gg, "addColorStop", [0.0, "rgba(255,150,210,0)"]); cm(gg, "addColorStop", [0.75, rgba("255,150,210", 0.12 * pu)]); cm(gg, "addColorStop", [1.0, "rgba(255,150,210,0)"])
		cs(c, "fillStyle", gg); cm(c, "beginPath"); cm(c, "ellipse", [x, y, r, r / 1.5, 0.0, 0.0, 7.0]); cm(c, "fill")
		cs(c, "strokeStyle", rgba("255,170,220", 0.55 * pu)); cs(c, "lineWidth", 2 * U); cm(c, "setLineDash", [[6 * U, 5 * U]]); cs(c, "lineDashOffset", -t * 20); cm(c, "beginPath"); cm(c, "ellipse", [x, y, r, r / 1.5, 0.0, 0.0, 7.0]); cm(c, "stroke"); cm(c, "setLineDash", [[]])
		for q in J.iter(walkers):
			if is_same(q, w) or t_(g(q, "foe")) or not t_(J.mc(W, "alive", [q])) or n(J.mc(W, "dist", [J.mc(W, "wp", [q]), J.mc(W, "wp", [w])])) >= n(FOES.streamer.aura.r) * PX: continue
			var qxy = P(W, J.mc(W, "wp", [q])); big_txt(c, "膽+30%", qxy[0], qxy[1] - hh - 20 * U, 9 * U, "#ffb0dc")
	# 設備：暫停／減益
	for kv in J.mc(S.pause, "entries", []):
		var p = kv[0]; var v = kv[1]; var rc = dev_rect(W, v.i)
		if rc == null or is_sealed(p) > 0: continue
		var x0 = rc[0]; var y0 = rc[1]; var cw = rc[2]; var ch = rc[3]; var left = n(v.dur) - n(v.t)
		cs(c, "fillStyle", rgba("255,250,205", 0.38 + 0.1 * sin(t * 12))); cm(c, "fillRect", [x0, y0, cw, ch]); cs(c, "strokeStyle", "#fff6c0"); cs(c, "lineWidth", 2.5 * U); cm(c, "strokeRect", [x0, y0, cw, ch])
		big_txt(c, T("暫停", "暫停") + " " + s_str(ceil(left)), x0 + cw / 2, y0 + ch * 0.62, 12 * U, "#fff3a0")
	for kv in J.mc(S.salt, "entries", []):
		var p = kv[0]; var v = kv[1]; var rc = dev_rect(W, v.i)
		if rc == null: continue
		var x0 = rc[0]; var y0 = rc[1]; var cw = rc[2]; var ch = rc[3]; var left = n(v.dur) - n(v.t)
		cs(c, "strokeStyle", rgba("255,255,255", 0.6 + 0.3 * sin(t * 8))); cm(c, "setLineDash", [[3 * U, 3 * U]]); cs(c, "lineWidth", 2 * U); cm(c, "strokeRect", [x0 - 3 * U, y0 - 3 * U, cw + 6 * U, ch + 6 * U]); cm(c, "setLineDash", [[]])
		var oy = 18 * U if is_sealed(p) > 0 else 0.0; cs(c, "fillStyle", "rgba(20,24,36,0.82)"); var bw2 = 52 * U; cm(c, "fillRect", [x0 + cw / 2 - bw2 / 2, y0 + ch + 2 * U + oy, bw2, 13 * U])
		cs(c, "font", "bold " + s_str(9.5 * U) + "px sans-serif"); cs(c, "textAlign", "center"); cs(c, "fillStyle", "#f4f8ff"); cm(c, "fillText", [T("鹽米", "鹽米") + " −40% " + s_str(ceil(left)), x0 + cw / 2, y0 + ch + 12 * U + oy])
	# 封禁
	for s in S.seals:
		var left = n(s.dur) - n(s.t); var pop = minf(1.0, n(s.t) / 0.25); var end_blink = 0.6 + 0.4 * sin(t * 18) if left < 1.5 else 1.0
		var seed = n(s.seed)
		if J.str(s.kind) == "dev":
			var rc = dev_rect(W, s.i)
			if rc == null: continue
			var x0 = rc[0]; var y0 = rc[1]; var cw = rc[2]; var ch = rc[3]; var cx = x0 + cw / 2
			cs(c, "fillStyle", "rgba(40,24,0,0.5)"); cm(c, "fillRect", [x0, y0, cw, ch])
			var SI = seal_im()
			if SI != null:
				var H0 = maxf(ch * 1.25, cw * 0.95) * minf(1.3, maxf(0.9, 1.0)); var sc = 1.5 - 0.5 * pop + sin(pop * PI) * 0.12 if pop < 1 else 1 + sin(t * 2.2 + seed) * 0.025; var hW = H0 * n(g(SI, "naturalWidth")) / n(g(SI, "naturalHeight"))
				cm(c, "save"); cs(c, "globalAlpha", minf(1.0, pop * 1.5) * end_blink); cm(c, "translate", [cx, y0 + ch * 0.5]); cm(c, "rotate", [sin(t * 1.6 + seed) * 0.04]); cm(c, "scale", [sc, sc])
				var gg = cm(c, "createRadialGradient", [0.0, 0.0, 4 * U, 0.0, 0.0, H0 * 0.62]); cm(gg, "addColorStop", [0.0, rgba("255,215,90", 0.32 + 0.12 * sin(t * 4))]); cm(gg, "addColorStop", [1.0, "rgba(255,215,90,0)"]); cs(c, "fillStyle", gg); cm(c, "beginPath"); cm(c, "arc", [0.0, 0.0, H0 * 0.62, 0.0, 7.0]); cm(c, "fill")
				cm(c, "drawImage", [SI, -hW / 2, -H0 / 2, hW, H0]); cm(c, "restore")
			else:
				cm(c, "save"); cs(c, "globalAlpha", end_blink); chain_line(c, x0 - 4 * U, y0 + 4 * U, x0 + cw + 4 * U, y0 + ch - 4 * U, U, t); chain_line(c, x0 + cw + 4 * U, y0 + 4 * U, x0 - 4 * U, y0 + ch - 4 * U, U, t + 1); cm(c, "restore")
				var fw = minf(cw * 0.42, 30 * U) * pop; var fh = fw * 2.5; draw_fu(c, cx, y0 - fh * 0.32, fw, fh, t, seed, end_blink)
			var named = false
			if t_(s.tgt) and g(s.tgt, "staff") != null and t_(g(W, "staffMul")): named = t_(g(J.mc(W, "staffMul", [s.tgt]), "named"))
			var bx = x0 + cw + 2 * U; var by = y0 + 2 * U; var br = 12 * U
			cs(c, "fillStyle", "rgba(40,20,0,0.9)"); cm(c, "beginPath"); cm(c, "arc", [bx, by, br, 0.0, 7.0]); cm(c, "fill"); cs(c, "strokeStyle", "#ffd45a"); cs(c, "lineWidth", 2.5 * U); cm(c, "beginPath"); cm(c, "arc", [bx, by, br, -PI / 2, -PI / 2 + 6.283 * left / n(s.dur)]); cm(c, "stroke")
			big_txt(c, s_str(ceil(left)), bx, by + 6 * U, 17 * U, "#ffd45a", "#2a1600")
			var lbl = T("名鬼被封印 " + s_str(ceil(left)) + " 秒", "名鬼被封印 " + s_str(ceil(left)) + " 秒") if named else T("封禁中", "封禁中")
			big_txt(c, lbl, cx, y0 + ch + 14 * U, 10 * U, "#ffe9a0")
		elif t_(g(W, "bpos")):
			var xy = P(W, J.mc(W, "bpos", [s.tgt])); var x = xy[0]; var y = xy[1]; var top = y - hh * 1.55
			cs(c, "strokeStyle", rgba("255,212,90", 0.5 * end_blink)); cs(c, "lineWidth", 3 * U); cm(c, "beginPath"); cm(c, "ellipse", [x, y, hh * 0.8, hh * 0.26, 0.0, t * 2, t * 2 + 5.2]); cm(c, "stroke")
			var fw = 18 * U * pop; var SI = seal_im()
			if SI != null:
				var H0 = fw * 3.2; var hW = H0 * n(g(SI, "naturalWidth")) / n(g(SI, "naturalHeight")); cm(c, "save"); cs(c, "globalAlpha", end_blink); cm(c, "translate", [x, top - H0 * 0.42]); cm(c, "rotate", [sin(t * 1.8 + seed) * 0.06]); cm(c, "drawImage", [SI, -hW / 2, -H0 / 2, hW, H0]); cm(c, "restore")
			else: draw_fu(c, x, top - fw * 2.4, fw, fw * 2.4, t, seed, end_blink)
			var lb = "被封印 " + s_str(ceil(left)) + " 秒"
			big_txt(c, T(lb, lb), x, top - fw * 2.6, 12 * U, "#ffd45a")
	# 解封
	for f in (S.brk if t_(S.get("brk")) else []):
		var SI = seal_im(); var k = n(f.t) / n(f.dur); var e = 1 - pow(1 - k, 2); var pxy = P(W, [f.x, f.y]); var rc = dev_rect(W, f.i) if J.str(f.kind) == "dev" else null
		var cx = rc[0] + rc[2] / 2 if rc != null else pxy[0]; var cy = rc[1] + rc[3] / 2 if rc != null else pxy[1] - hh * 1.9; var H0 = maxf(rc[3] * 1.25, rc[2] * 0.95) if rc != null else 18 * U * 3.2
		cm(c, "save"); cs(c, "globalAlpha", 1 - k)
		if SI != null:
			var iw = n(g(SI, "naturalWidth")); var ih = n(g(SI, "naturalHeight")); var hW = H0 * iw / ih
			for sd in [-1.0, 1.0]:
				cm(c, "save"); cm(c, "translate", [cx + sd * e * H0 * 0.55, cy - sin(k * PI) * H0 * 0.25 + e * H0 * 0.2]); cm(c, "rotate", [sd * e * 0.9]); var sx = 0.0 if sd < 0 else iw / 2
				cm(c, "drawImage", [SI, sx, 0.0, iw / 2, ih, -hW / 2 if sd < 0 else 0.0, -H0 / 2, hW / 2, H0]); cm(c, "restore")
		for j in 14:
			var a = j * 0.449 + n(f.seed); var d = e * H0 * (0.4 + (j % 4) * 0.15)
			cs(c, "fillStyle", rgba("255,214,90", 1 - k) if j % 3 else rgba("255,250,220", 1 - k)); cm(c, "beginPath"); cm(c, "arc", [cx + cos(a) * d, cy + sin(a) * d * 0.7 + k * k * 20 * U, (2.6 - k * 1.5) * U, 0.0, 7.0]); cm(c, "fill")
		cm(c, "restore")
	# 唸咒進度圈＋強敵標記
	for w in J.iter(walkers):
		var F = g(w, "foe")
		if not t_(F) or t_(g(w, "gone")) or not t_(J.mc(W, "alive", [w])): continue
		var C = FOES[J.str(F.id)]; var xy = P(W, J.mc(W, "wp", [w])); var x = xy[0]; var y = xy[1]
		var chn = F.get("chant")
		if t_(chn):
			var k = minf(1.0, n(chn.t) / n(chn.dur)); var cy = y - hh * 1.55; var r = 13 * U; var jx = (randf() - 0.5) * 5 * U if n(chn.jolt) > 0 else 0.0
			cs(c, "fillStyle", "rgba(30,18,0,0.7)"); cm(c, "beginPath"); cm(c, "arc", [x + jx, cy, r + 3 * U, 0.0, 7.0]); cm(c, "fill")
			cs(c, "strokeStyle", "rgba(255,212,90,0.25)"); cs(c, "lineWidth", 4 * U); cm(c, "beginPath"); cm(c, "arc", [x + jx, cy, r, 0.0, 7.0]); cm(c, "stroke")
			cs(c, "strokeStyle", "#ff8a6a" if n(chn.jolt) > 0 else "#ffd45a"); cm(c, "beginPath"); cm(c, "arc", [x + jx, cy, r, -PI / 2, -PI / 2 + k * 6.283]); cm(c, "stroke")
			cm(c, "save"); cm(c, "translate", [x + jx, cy]); cm(c, "rotate", [t * 2]); cs(c, "strokeStyle", "#ffe9a0"); cs(c, "lineWidth", 1.4 * U)
			for j in 3: cm(c, "rotate", [2.094]); cm(c, "beginPath"); cm(c, "arc", [0.0, -r * 0.42, r * 0.28, 0.0, 4.4]); cm(c, "stroke")
			cm(c, "restore")
			var tg = null
			if J.str(chn.kind) == "boss": tg = P(W, J.mc(W, "bpos", [chn.tgt])) if t_(g(W, "bpos")) else null
			else:
				var sp = J.gp(g(g(W, "lay"), "posts"), chn.i)
				if t_(sp): tg = P(W, [g(sp, "x"), g(sp, "y")])
			if tg != null:
				cs(c, "strokeStyle", rgba("255,212,90", 0.35 + 0.3 * k)); cm(c, "setLineDash", [[4 * U, 4 * U]]); cs(c, "lineDashOffset", -t * 30); cs(c, "lineWidth", 2 * U); cm(c, "beginPath"); cm(c, "moveTo", [x, y - hh * 0.7]); cm(c, "lineTo", [tg[0], tg[1]]); cm(c, "stroke"); cm(c, "setLineDash", [[]])
		var used = 0
		for kk in F.by: if kk != "other" and n(F.by[kk]) > 0: used += 1
		if t_(C.res) and F.by.size():
			var px = x + hh * 0.31 + 7 * U; var py = y - hh - 6.5 * U
			for j in 3:
				cm(c, "beginPath"); cm(c, "arc", [px + j * 8 * U, py, 3 * U, 0.0, 7.0]); cs(c, "fillStyle", C.tag if j < used else "rgba(30,24,40,0.85)"); cm(c, "fill"); cs(c, "strokeStyle", "#1a1208" if j < used else "rgba(255,233,176,0.7)"); cs(c, "lineWidth", 1.3 * U); cm(c, "stroke")
		if t_(F.retreated): big_txt(c, T("撤符", "撤符"), x, y - hh - 26 * U, 10 * U, "#ffe9a0")
	cm(c, "restore")

# ---------- Q 版角色 ----------
static func draw_body(c, w, hh: float, t: float, o) -> bool:
	if not t_(w) or not t_(g(w, "foe")): return false
	if not t_(o): o = {}
	var id = J.str(g(g(w, "foe"), "id"))
	var SP = J.G.get("SPR"); var im = J.gp(SP, "foe_" + id) if J.typeof_(SP) != "undefined" else null
	var wseed = n(g(w, "seed")) if t_(g(w, "seed")) else 0.0
	if t_(im) and t_(J.gp(im, "naturalWidth")):
		var H = hh * 1.0; var Wd = H * n(g(im, "naturalWidth")) / n(g(im, "naturalHeight")); cm(c, "save")
		var still = n(g(w, "stay")) > 0 or n(g(w, "block")) > 0
		cm(c, "translate", [0.0, -absf(sin(t * 5 + wseed)) * hh * (0.0 if still else 0.035)])
		if t_(g(o, "flip")): cm(c, "scale", [-1.0, 1.0])
		cm(c, "drawImage", [im, -Wd / 2, -H, Wd, H]); cm(c, "restore"); return true
	var F = g(w, "foe")
	var cast = t_(g(o, "cast")) if g(o, "cast") != null else (t_(g(F, "chant")) or n(g(F, "scan")) > 0)
	var walk = t_(g(o, "walk")) if g(o, "walk") != null else (not cast and not (n(g(w, "block")) > 0) and not (n(g(w, "stay")) > 0))
	draw_q(c, id, hh * 1.12, t + wseed, t_(g(o, "flip")), walk, cast); return true

const QP := {"taoist": {"body": "#e9bd3a", "trim": "#8a5a12", "leg": "#2b2320", "shoe": "#141010"}, "hunter": {"body": "#3f5a4a", "trim": "#24342b", "leg": "#2c3a5c", "shoe": "#1a1a1a"}, "streamer": {"body": "#e45a9a", "trim": "#a83470", "leg": "#2a2a3a", "shoe": "#f4f4f4"}}
static func _arm(c, H: float, P_: Dictionary, SK: String, x: float, y: float, rot: float, hand := true) -> void:
	cm(c, "save"); cm(c, "translate", [x, y]); cm(c, "rotate", [rot]); cs(c, "fillStyle", P_.body); cm(c, "beginPath"); cm(c, "rect", [-H * 0.03, 0.0, H * 0.06, H * 0.13]); cm(c, "fill"); cm(c, "stroke")
	if hand: cs(c, "fillStyle", SK); cm(c, "beginPath"); cm(c, "arc", [0.0, H * 0.15, H * 0.032, 0.0, 7.0]); cm(c, "fill"); cm(c, "stroke")
static func draw_q(c, id: String, H: float, t: float, flip: bool, walk: bool, cast: bool) -> void:
	var r = H * 0.25; var hy = -H + r; var body_top = hy + r * 0.85; var lw = maxf(1.4, H * 0.028); var bob = absf(sin(t * 8)) * H * 0.03 if walk else 0.0; var sw = sin(t * 8) if walk else 0.0
	var OL = "#1a1208"; var SK = "#f3d2a8"
	cm(c, "save")
	if flip: cm(c, "scale", [-1.0, 1.0])
	cm(c, "translate", [0.0, -bob]); cs(c, "lineJoin", "round"); cs(c, "lineCap", "round"); cs(c, "lineWidth", lw); cs(c, "strokeStyle", OL)
	var P_ = QP[id]
	for s in [-1.0, 1.0]:
		var lx = s * H * 0.07 + sw * s * H * 0.04
		cs(c, "fillStyle", P_.leg); cm(c, "beginPath"); cm(c, "rect", [lx - H * 0.035, -H * 0.16, H * 0.07, H * 0.14]); cm(c, "fill"); cm(c, "stroke")
		cs(c, "fillStyle", P_.shoe); cm(c, "beginPath"); cm(c, "ellipse", [lx + H * 0.015, -H * 0.02, H * 0.055, H * 0.03, 0.0, 0.0, 7.0]); cm(c, "fill"); cm(c, "stroke")
	cs(c, "fillStyle", P_.body); cm(c, "beginPath")
	if id == "taoist": cm(c, "moveTo", [-H * 0.12, body_top]); cm(c, "lineTo", [H * 0.12, body_top]); cm(c, "lineTo", [H * 0.19, -H * 0.12]); cm(c, "quadraticCurveTo", [0.0, -H * 0.09, -H * 0.19, -H * 0.12]); cm(c, "closePath")
	else: cm(c, "moveTo", [-H * 0.12, body_top]); cm(c, "lineTo", [H * 0.12, body_top]); cm(c, "lineTo", [H * 0.14, -H * 0.15]); cm(c, "lineTo", [-H * 0.14, -H * 0.15]); cm(c, "closePath")
	cm(c, "fill"); cm(c, "stroke")
	if id == "taoist":
		cs(c, "strokeStyle", P_.trim); cs(c, "lineWidth", lw * 1.4); cm(c, "beginPath"); cm(c, "moveTo", [-H * 0.07, body_top + H * 0.01]); cm(c, "lineTo", [H * 0.03, body_top + H * 0.13]); cm(c, "moveTo", [H * 0.07, body_top + H * 0.01]); cm(c, "lineTo", [H * 0.0, body_top + H * 0.09]); cm(c, "stroke")
		cs(c, "fillStyle", "#7a2a1a"); cm(c, "fillRect", [-H * 0.15, body_top + H * 0.17, H * 0.3, H * 0.035]); cs(c, "strokeStyle", OL); cs(c, "lineWidth", lw)
	elif id == "hunter":
		cs(c, "strokeStyle", P_.trim); cm(c, "beginPath"); cm(c, "moveTo", [0.0, body_top + H * 0.02]); cm(c, "lineTo", [0.0, -H * 0.16]); cm(c, "stroke"); cs(c, "fillStyle", "#6a4a2a"); cm(c, "fillRect", [-H * 0.16, body_top + H * 0.02, H * 0.05, H * 0.2]); cs(c, "strokeStyle", OL); cm(c, "strokeRect", [-H * 0.16, body_top + H * 0.02, H * 0.05, H * 0.2])
		cs(c, "fillStyle", "#d8a83a"); cm(c, "beginPath"); cm(c, "arc", [-H * 0.07, body_top + H * 0.17, H * 0.035, 0.0, 7.0]); cm(c, "fill"); cm(c, "stroke"); cs(c, "strokeStyle", "#a02020"); cm(c, "beginPath"); cm(c, "moveTo", [-H * 0.07, body_top + H * 0.17]); cm(c, "lineTo", [-H * 0.07 + cos(t * 7) * H * 0.028, body_top + H * 0.17 + sin(t * 7) * H * 0.028]); cm(c, "stroke"); cs(c, "strokeStyle", OL)
	else: cs(c, "fillStyle", P_.trim); cm(c, "beginPath"); cm(c, "ellipse", [0.0, body_top + H * 0.15, H * 0.07, H * 0.03, 0.0, 0.0, 7.0]); cm(c, "fill")
	var arm_y = body_top + H * 0.05
	if id == "taoist":
		_arm(c, H, P_, SK, H * 0.11, arm_y, -1.9 + sin(t * 6) * 0.08 if cast else 0.5 + sw * 0.15)
		cm(c, "translate", [0.0, H * 0.15]); cm(c, "rotate", [2.0 if cast else 0.3]); cs(c, "fillStyle", "#a5652e"); cm(c, "beginPath"); cm(c, "moveTo", [-H * 0.022, -H * 0.02]); cm(c, "lineTo", [-H * 0.02, -H * 0.36]); cm(c, "lineTo", [0.0, -H * 0.4]); cm(c, "lineTo", [H * 0.02, -H * 0.36]); cm(c, "lineTo", [H * 0.022, -H * 0.02]); cm(c, "closePath"); cm(c, "fill"); cm(c, "stroke")
		cs(c, "strokeStyle", "#d99a58"); cm(c, "beginPath"); cm(c, "moveTo", [0.0, -H * 0.05]); cm(c, "lineTo", [0.0, -H * 0.33]); cm(c, "stroke"); cs(c, "strokeStyle", OL); cs(c, "fillStyle", "#6a3a1a"); cm(c, "fillRect", [-H * 0.05, -H * 0.04, H * 0.1, H * 0.025]); cm(c, "strokeRect", [-H * 0.05, -H * 0.04, H * 0.1, H * 0.025])
		cs(c, "strokeStyle", "#c8281e"); cs(c, "lineWidth", lw * 1.5); cm(c, "beginPath"); cm(c, "moveTo", [0.0, 0.0]); cm(c, "quadraticCurveTo", [H * 0.03 + sin(t * 5) * H * 0.02, H * 0.06, sin(t * 4) * H * 0.03, H * 0.1]); cm(c, "stroke"); cm(c, "restore"); cs(c, "lineWidth", lw); cs(c, "strokeStyle", OL)
		_arm(c, H, P_, SK, -H * 0.11, arm_y, 0.9 if cast else -0.4 - sw * 0.15); cm(c, "restore")
	elif id == "hunter":
		_arm(c, H, P_, SK, H * 0.11, arm_y, -1.45 if cast else 0.35 + sw * 0.15)
		cm(c, "translate", [0.0, H * 0.15]); cm(c, "rotate", [-PI / 2 + (0.0 if cast else 0.3)]); cs(c, "fillStyle", "#5a5e66"); cm(c, "fillRect", [-H * 0.02, -H * 0.03, H * 0.15, H * 0.06]); cm(c, "strokeRect", [-H * 0.02, -H * 0.03, H * 0.15, H * 0.06]); cs(c, "fillStyle", "#fffbd0" if cast else "#e8e0a0"); cm(c, "beginPath"); cm(c, "ellipse", [H * 0.135, 0.0, H * 0.018, H * 0.04, 0.0, 0.0, 7.0]); cm(c, "fill"); cm(c, "stroke")
		if cast:
			var gg = cm(c, "createRadialGradient", [H * 0.14, 0.0, 1.0, H * 0.14, 0.0, H * 0.12]); cm(gg, "addColorStop", [0.0, "rgba(255,255,220,0.9)"]); cm(gg, "addColorStop", [1.0, "rgba(255,255,220,0)"]); cs(c, "fillStyle", gg); cm(c, "beginPath"); cm(c, "arc", [H * 0.14, 0.0, H * 0.12, 0.0, 7.0]); cm(c, "fill")
		cm(c, "restore")
		_arm(c, H, P_, SK, -H * 0.11, arm_y, -0.35 - sw * 0.15); cm(c, "restore")
	else:
		_arm(c, H, P_, SK, H * 0.11, arm_y, -2.3 + sin(t * 2) * 0.1, false)
		cs(c, "strokeStyle", "#888"); cs(c, "lineWidth", lw * 1.2); cm(c, "beginPath"); cm(c, "moveTo", [0.0, H * 0.13]); cm(c, "lineTo", [0.0, H * 0.36]); cm(c, "stroke"); cs(c, "strokeStyle", OL); cs(c, "lineWidth", lw)
		cm(c, "translate", [0.0, H * 0.4]); cs(c, "fillStyle", "#222"); cm(c, "fillRect", [-H * 0.035, -H * 0.05, H * 0.07, H * 0.1]); cs(c, "lineWidth", H * 0.02); cs(c, "strokeStyle", rgba("255,250,250", 0.85 + 0.15 * sin(t * 9))); cm(c, "beginPath"); cm(c, "arc", [0.0, 0.0, H * 0.085, 0.0, 7.0]); cm(c, "stroke")
		var gg = cm(c, "createRadialGradient", [0.0, 0.0, H * 0.05, 0.0, 0.0, H * 0.16]); cm(gg, "addColorStop", [0.0, "rgba(255,240,250,0.5)"]); cm(gg, "addColorStop", [1.0, "rgba(255,240,250,0)"]); cs(c, "fillStyle", gg); cm(c, "beginPath"); cm(c, "arc", [0.0, 0.0, H * 0.16, 0.0, 7.0]); cm(c, "fill"); cm(c, "restore"); cs(c, "lineWidth", lw); cs(c, "strokeStyle", OL)
		_arm(c, H, P_, SK, -H * 0.11, arm_y, -0.3 - sw * 0.15); cm(c, "restore")
	# 大頭
	cs(c, "fillStyle", SK); cm(c, "beginPath"); cm(c, "arc", [0.0, hy, r, 0.0, 7.0]); cm(c, "fill"); cm(c, "stroke")
	if id == "taoist":
		cs(c, "fillStyle", "#1c1a1a"); cm(c, "beginPath"); cm(c, "arc", [0.0, hy, r, PI * 1.05, PI * 1.95]); cm(c, "quadraticCurveTo", [0.0, hy - r * 0.45, -r * 0.98, hy - r * 0.2]); cm(c, "fill"); cm(c, "stroke")
		cs(c, "fillStyle", "#1c1a1a"); cm(c, "beginPath"); cm(c, "arc", [0.0, hy - r * 1.02, r * 0.3, 0.0, 7.0]); cm(c, "fill"); cm(c, "stroke"); cs(c, "fillStyle", "#2a2a2a"); cm(c, "fillRect", [-r * 0.36, hy - r * 1.32, r * 0.72, r * 0.22]); cm(c, "strokeRect", [-r * 0.36, hy - r * 1.32, r * 0.72, r * 0.22])
		cs(c, "fillStyle", "#d9b23a"); cm(c, "beginPath"); cm(c, "arc", [0.0, hy - r * 1.21, r * 0.07, 0.0, 7.0]); cm(c, "fill")
	elif id == "hunter":
		cs(c, "fillStyle", "#26303a"); cm(c, "beginPath"); cm(c, "arc", [0.0, hy - r * 0.08, r * 1.02, PI * 1.02, PI * 1.98]); cm(c, "closePath"); cm(c, "fill"); cm(c, "stroke"); cm(c, "beginPath"); cm(c, "moveTo", [r * 0.5, hy - r * 0.18]); cm(c, "lineTo", [r * 1.35, hy - r * 0.12]); cm(c, "lineTo", [r * 0.95, hy - r * 0.02]); cm(c, "closePath"); cm(c, "fill"); cm(c, "stroke")
	else:
		cs(c, "fillStyle", "#5a2a4a"); cm(c, "beginPath"); cm(c, "arc", [0.0, hy, r * 1.04, PI * 0.95, PI * 2.05]); cm(c, "quadraticCurveTo", [r * 0.3, hy - r * 0.35, -r * 1.0, hy + r * 0.15]); cm(c, "fill"); cm(c, "stroke")
		cs(c, "fillStyle", P_.body); cm(c, "beginPath"); cm(c, "arc", [0.0, hy + r * 0.1, r * 1.12, PI * 0.08, PI * 0.92]); cm(c, "lineTo", [-r * 0.9, hy + r * 0.75]); cm(c, "lineTo", [r * 0.9, hy + r * 0.75]); cm(c, "closePath"); cm(c, "fill"); cm(c, "stroke")
	var ex = r * 0.38; var ey = hy + r * 0.12; cs(c, "fillStyle", OL)
	for s in [-1.0, 1.0]: cm(c, "beginPath"); cm(c, "ellipse", [s * ex + r * 0.12, ey, r * 0.09, r * (0.04 if cast and id != "streamer" else 0.13), 0.0, 0.0, 7.0]); cm(c, "fill")
	cs(c, "lineWidth", lw * 0.9); cm(c, "beginPath")
	if id == "streamer": cm(c, "arc", [r * 0.12, ey + r * 0.32, r * 0.16, 0.2, PI - 0.2])
	else: cm(c, "moveTo", [r * 0.0, ey + r * 0.4]); cm(c, "lineTo", [r * 0.24, ey + r * 0.38])
	cm(c, "stroke")
	if id != "streamer": cm(c, "beginPath"); cm(c, "moveTo", [-ex + r * 0.0, ey - r * 0.24]); cm(c, "lineTo", [-ex + r * 0.24, ey - r * 0.18]); cm(c, "moveTo", [ex + r * 0.0, ey - r * 0.18]); cm(c, "lineTo", [ex + r * 0.24, ey - r * 0.24]); cm(c, "stroke")
	cm(c, "restore")

func run(_env) -> void:
	FOES = JSON.parse_string(FOES_JSON); IDS = FOES.keys()
	reset()
	J.G["StnFoes"] = {
		"FOES": FOES, "RES": RES,
		"reset": func(_t, _a): reset(); return null,
		"spawnTable": func(_t, a): return spawn_table(J.num(J.arg(a, 0))),
		"roll": func(_t, a): return roll(J.num(J.arg(a, 0)), J.arg(a, 1)),
		"decorate": func(_t, a): return decorate(J.arg(a, 0), J.arg(a, 1)),
		"update": func(_t, a): update(J.num(J.arg(a, 0)), J.arg(a, 1)); return null,
		"draw": func(_t, a): draw(J.arg(a, 0), J.arg(a, 1)); return null,
		"drawBody": func(_t, a): return draw_body(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4)),
		"drawFu": func(_t, a): draw_fu(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.num(J.arg(a, 6)), J.arg(a, 7)); return null,
		"onHit": func(_t, a): return on_hit(J.arg(a, 0), J.num(J.arg(a, 1)), J.arg(a, 2), J.arg(a, 3)),
		"isSealed": func(_t, a): return is_sealed(J.arg(a, 0)),
		"isPaused": func(_t, a): return is_paused(J.arg(a, 0)),
		"blocks": func(_t, a): return blocks(J.arg(a, 0)),
		"devMul": func(_t, a): return dev_mul(J.arg(a, 0)),
		"__getters": {"state": func(_t = null, _a = null): return S},
	}
