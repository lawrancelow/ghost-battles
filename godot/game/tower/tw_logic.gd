# 樓裡有鬼：每幀邏輯熱點原生版（逐行照 tower.js；隨機數照用 JS 嘅 rnd()，次序一樣，結果一樣）
#  - res_tick：update() 入面「住客」迴圈＋pplResTick
#  - res2：resUpdate2 嘅住客作息、單位／走廊機關／防煙門計時（questUpdate、reliefUpdate 仍喺 JS）
#  - lit：寅時後住戶自己開燈
# 對拍：TwRun.t_ab() 用同一個種子分別跑 JS 原版同原生版 N 幀，比較狀態雜湊
class_name TwLogic
extends RefCounted

static func F(): return J.G.get("TWX").fn
static func n0(v) -> float: return 0.0 if v == null else J.num(v)
static func rnd(f) -> float: return J.num(J.cl(f.rnd, null, []))

static var PT := {}
static func pt(k: String, t0: int) -> void: PT[k] = PT.get(k, 0) + Time.get_ticks_usec() - t0
static func res_tick(G, dt: float, SX: float, LX: float) -> bool:
	var _t0 = Time.get_ticks_usec()
	var f = F()
	for r in G.res:
		# pplResTick
		var jt = n0(r.get("jumpT"))
		if jt > n0(r.get("_pj")) + 0.001: J.cl(f.startShock, null, [r, 1.0 if jt >= 0.5 else 0.65])
		r["shockT"] = maxf(0.0, n0(r.get("shockT")) - dt)
		var sc = r.get("scream")
		if sc is Dictionary:
			sc["T"] = J.num(sc.get("T")) - dt
			if J.num(sc["T"]) <= 0: r["scream"] = null
		if J.str(r.get("state")) == "home" and J.t(r.get("awake")) and n0(r.get("fear")) >= 55 and randf() < dt * 1.1: J.cl(f.sweat, null, [r])
		# update() 住客段
		jt = maxf(0.0, n0(r.get("jumpT")) - dt); r["jumpT"] = jt; r["_pj"] = jt
		r["tangle"] = maxf(0.0, n0(r.get("tangle")) - dt)
		if J.str(r.get("state")) == "flee":
			var vx = J.num(r.vx)
			if n0(r.get("tripT")) > 0: r["tripT"] = J.num(r.tripT) - dt; r["x"] = J.num(r.x) + vx * 0.18 * dt
			else: r["x"] = J.num(r.x) + vx * dt
			var x = J.num(r.x)
			if x < SX or x > LX: r["state"] = "gone"
			if rnd(f) < dt * 8: J.cl(f.part, null, [x - signf(vx) * 10, J.num(r.y) - 4, -vx * 0.1, -10.0, 0.5, "dust"])
		var un = r.unit
		if J.str(r.get("state")) == "home" and J.t(un.get("door")):
			r["doorT"] = J.num(r.doorT) - dt
			if J.num(r.doorT) <= 0:
				un["doorOpen"] = 2.6; r["doorT"] = 12 + rnd(f) * 8
				J.cl(f.say, null, [r, J.cl(f.pick, null, [["出去倒杯水先", "邊個喺門口？", "開門透下氣"]])])
		var dop = un.get("doorOpen")
		if dop != null and J.num(dop) > 0: un["doorOpen"] = J.num(dop) - dt
	pt("res_tick", _t0)
	return true

static func res2(G, dt: float, PHT: float, SX: float, FYS) -> bool:
	var _t0 = Time.get_ticks_usec()
	var f = F(); var HH = f.HH
	var ph = mini(2, int(J.num(G.phase))); var tt = J.num(G.t) / PHT
	for r in G.res:
		var hh = HH.get(J.str(r.get("hh")))
		if hh == null: continue
		var un = r.unit
		if J.str(r.state) == "home":
			var aw = hh.awake
			var want = aw is Array and ph < aw.size() and J.num(aw[ph]) == 1
			if want and not J.t(r.get("awake")):
				r["awake"] = true; J.cl(f.say, null, [r, J.cl(f.pick, null, [["又醒咗……", "咩鐘數呀而家？"]])])
			if not want and J.t(r.get("awake")) and not J.t(r.get("woke")) and J.num(r.fear) < 20 and rnd(f) < dt * 0.05: r["awake"] = false
			r["idleT"] = J.num(r.idleT) - dt
			if J.num(r.idleT) <= 0:
				r["idleT"] = 10 + rnd(f) * 14
				if J.t(r.get("awake")) and not J.t(r.get("say")): J.cl(f.say, null, [r, J.cl(f.pick, null, [hh.idle])])
			var lv = hh.get("leave")
			if J.t(lv) and not J.t(r.get("left")) and tt >= J.num(lv):
				r["left"] = true; r["state"] = "leave"; r["awake"] = true
				J.cl(f.say, null, [r, "返工喇，出門口先" if J.str(r.hh) == "nurse" else "去晨運先"]); un["doorOpen"] = 4.0; r["vx"] = -70.0
		var aw2 = hh.get("away")
		if J.str(r.state) == "away" and J.t(aw2) and tt >= J.num(aw2):
			r["state"] = "back"; r["x"] = SX; r["y"] = J.num(FYS[int(J.num(un.f))]) - 16; r["vx"] = 70.0; r["awake"] = true
			J.cl(f.say, null, [r, "收工返屋企喇……"])
		if J.str(r.state) == "leave":
			r["x"] = J.num(r.x) + J.num(r.vx) * dt
			if J.num(r.x) <= SX: r["state"] = "gone"
		if J.str(r.state) == "back":
			var tx = J.num(un.rx[0]) + 30
			r["x"] = J.num(r.x) + signf(tx - J.num(r.x)) * 70 * dt
			if absf(tx - J.num(r.x)) < 4: r["state"] = "home"; un["doorOpen"] = 3.0
	for u in G.units:
		var rs = u.get("rs")
		if rs == null: continue
		var pick = null
		for r in rs:
			if J.str(r.state) == "home": pick = r; break
		if pick == null and rs.size(): pick = rs[0]
		u["res"] = pick
		for p in u.props:
			p["t"] = maxf(0.0, J.num(p.t) - dt); p["cd"] = maxf(0.0, J.num(p.cd) - dt)
	var cps = G.get("cprops")
	if cps is Array:
		for p in cps:
			p["t"] = maxf(0.0, J.num(p.t) - dt); p["cd"] = maxf(0.0, J.num(p.cd) - dt)
	if not G.has("_fe"):
		var fe = []
		for e in G.edges: if e.get("fire") != null: fe.append(e)
		G["_fe"] = fe
	for e in G._fe:
		var fr = e.fire; fr["shut"] = maxf(0.0, J.num(fr.shut) - dt); fr["cd"] = maxf(0.0, J.num(fr.cd) - dt)
	pt("res2", _t0)
	return true

static func lit(G, dt: float) -> bool:
	var f = F()
	for un in G.units:
		un["litT"] = J.num(un.litT) - dt
		var r = un.get("res")
		if r != null and J.str(r.state) == "home" and not J.t(un.get("lit")) and rnd(f) < dt * 0.04:
			un["lit"] = true; un["litT"] = 7.0; J.cl(f.say, null, [r, J.cl(f.line, null, ["wake"])])
		if J.t(un.get("lit")) and J.num(un.litT) <= 0: un["lit"] = false
	return true
