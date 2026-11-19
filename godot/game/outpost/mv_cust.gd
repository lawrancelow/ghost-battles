# [play] 鬼客脾氣（全部 static；P = mv_plus.gd 實例，sim = mv_sim.gd 實例）。規則見 PLAY_PLUS.md 三之 1。
#   客人字典加：tp（脾氣）、star_need {gid:N}、prompt／pr_at／dec（決定）、prepaid、sent_back、cut_by、pat_b、fam_plus、
#              dash／dash_v／run_t／rolled／lost、caught、unmask、flee、friend
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")

const REG_N := 12           # 同一種鬼客收足錢走咗幾多次變熟客（熟客度）
const REG_P := 0.3         # 熟客度夠嘅鬼客，每次嚟有幾大機會係「熟客」身份（其餘照擲脾氣）
const REG_PAT := 5.0
const REG_TIP := 1.1
const FRIEND_P := 0.35
const HAG_MUL := 0.8
const CUT_FEE := 1.2
const CUT_PAT := 4.0
const PICKY_OK := 1.8
const PICKY_BAD := 0.6
const CATCH_MUL := 1.5
const PROMPT_MS := 5000.0
const AUTO_CATCH := 0.5
const AUTO_T := 1.5
const RUN_SPD := 160.0      # 走數鬼：喺 110 之上再加
const CUT_SPD := 110.0
const W0 := {"none": 69, "haggle": 7, "cut": 6, "dash": 5, "picky": 6}

static func TD(P, k: String) -> Dictionary:
	var d = P.D().TEMPERS.get(k)
	return d if d is Dictionary else {}
static func line(P, k: String, f := "lines") -> String:
	var a = TD(P, k).get(f, [])
	var ml = P.map_d(int(P.cur_ci)).get("lines")   # 每張圖自己嘅講法（同通用嗰批一齊抽）
	if f == "lines" and ml is Dictionary and ml.get(k) is Array: a = (a as Array) + ml[k]
	return P.T(a[P.rng.randi() % a.size()]) if a is Array and a.size() else ""
static func fam(P, sim, cid: String) -> float: return J.num(P.ps(sim).fam.get(cid))
static func add_fam(P, sim, cid: String, d: float) -> void:
	var f = P.ps(sim).fam; f[cid] = maxf(0.0, J.num(f.get(cid)) + d)
static func is_reg(P, sim, cid: String) -> bool: return fam(P, sim, cid) >= REG_N

static func weights(P, sim) -> Dictionary:
	var w = P.map_d(sim.ci()).get("tempers")
	var o = (w if w is Dictionary else W0).duplicate()
	if P.is_night(sim): o["dash"] = float(o.get("dash", 0)) * 2.0
	return o
static func roll(P, w: Dictionary) -> String:
	var tot = 0.0
	for k in w: tot += float(w[k])
	var r = P.rng.randf() * tot
	for k in w:
		r -= float(w[k])
		if r <= 0.0: return str(k)
	return "none"

# ---------------- 新客人 ----------------
static func on_spawn(P, sim, c: Dictionary) -> void:
	var waiting = 0
	for x in sim.custs: if x != c and x.st != "out": waiting += 1
	var tp = "none"
	if J.t(P.live.get("fake")):
		tp = "fake"; P.live.fake = false
		var e = P.live.get("ev")
		if e is Dictionary and str(e.k) == "fake": e["c"] = c
	elif is_reg(P, sim, str(c.cid)) and P.rng.randf() < REG_P: tp = "reg"
	else:
		tp = roll(P, weights(P, sim))
		if tp == "cut" and waiting < 2: tp = "none"
		if tp == "dash":
			for g in c.wants: if MVW.is_gear(str(g)): tp = "none"
		if tp == "picky":
			var gs = c.wants.keys(); var g = str(gs[P.rng.randi() % gs.size()]); var sid = sim.sid_of(g)
			if sid == "": tp = "none"
			else:
				var cur = MD.stars(sid, sim.lv(sid))
				var need = clampi(cur + (0 if P.rng.randf() < 0.5 else 1), 1, MD.miles(sid).size())
				c["star_need"] = {g: float(need)}
	c["tp"] = tp
	P.stat_add(sim, "t_" + tp)
	match tp:
		"reg": P.act(c, "wave", 1.4)
		"cut":
			var i0 = -1
			for i in sim.custs.size(): if sim.custs[i] != c and sim.custs[i].st != "out": i0 = i; break
			sim.custs.erase(c)
			sim.custs.insert(i0 + 1, c)
			for i in range(i0 + 2, sim.custs.size()):
				if sim.custs[i].st != "out": sim.custs[i]["cut_by"] = true
			P.act(c, "air", 0.9)
			sim.ev.append({"k": "p_line", "pos": c.pos + Vector2(-40, 0), "line": line(P, "cut"), "who": P.T(TD(P, "cut").get("tag", ["", ""]))})

static func satisfied(sim, c: Dictionary) -> bool:
	var sn = c.get("star_need")
	if not (sn is Dictionary): return true
	for g in sn:
		var sid = sim.sid_of(str(g))
		if sid == "" or MD.stars(sid, sim.lv(sid)) < int(sn[g]): return false
	return true
static func full(c: Dictionary) -> bool:
	for g in c.wants: if int(c.got.get(g, 0)) < int(c.wants[g]): return false
	return true

# 收齊貨：要唔要等玩家決定（講價／挑剔唔夠星）
static func hold_pay(P, sim, c: Dictionary) -> bool:
	var tp = str(c.get("tp", ""))
	var need = (tp == "haggle") or (tp == "picky" and not satisfied(sim, c))
	if not need or c.has("dec"): return false
	if not c.has("pr_at"):
		c["pr_at"] = J.now(); c["prompt"] = true
		sim.ev.append({"k": "p_line", "pos": c.pos, "line": line(P, tp), "who": P.T(TD(P, tp).get("tag", ["", ""]))})
		if tp == "picky": P.act(c, "picky", 1.6)
	if J.now() - J.num(c.pr_at) >= PROMPT_MS:
		c["dec"] = "timeout"; c["prompt"] = false
		return false
	return true

static func pay_mul(P, sim, c: Dictionary) -> float:
	match str(c.get("tp", "")):
		"haggle": return HAG_MUL if str(c.get("dec", "")) == "cut" else 1.0
		"cut": return 1.0 if J.t(c.get("sent_back")) else CUT_FEE
		"dash": return 1.0 if J.t(c.get("prepaid")) else 0.0
		"picky":
			if satisfied(sim, c): return PICKY_OK
			return 1.0 if str(c.get("dec", "")) == "taste" else PICKY_BAD
		"reg": return REG_TIP
		"fake": return 0.0
	return 1.0

static func _drop_pay_ev(sim, c: Dictionary) -> void:
	for i in range(sim.ev.size() - 1, -1, -1):
		var e = sim.ev[i]
		if str(e.get("k")) == "pay" and str(e.get("cid")) == str(c.cid): sim.ev.remove_at(i); return

static func on_paid(P, sim, c: Dictionary, _amt: float) -> void:
	var tp = str(c.get("tp", "")); var cid = str(c.cid)
	var ok = full(c)
	if tp == "fake":
		_drop_pay_ev(sim, c); c["flee"] = true; P.act(c, "run", 3.0)
		var n = 0
		for g in c.got: n += int(c.got[g])
		sim.ev.append({"k": "p_fake_steal", "pos": c.pos + Vector2(0, -60), "n": n}); P.stat_add(sim, "fake_lost")
		var e = P.live.get("ev")
		if e is Dictionary and str(e.k) == "fake": e["done"] = true
		return
	if tp == "dash" and not J.t(c.get("prepaid")):
		_drop_pay_ev(sim, c)
		c["dash"] = true; c["dash_v"] = sim.cust_value(c); c["run_t"] = 0.0
		P.act(c, "run", 4.0)
		sim.ev.append({"k": "p_dash", "pos": c.pos, "line": line(P, "dash")}); P.stat_add(sim, "dash")
		return
	var d = 1.0 if ok else 0.0
	match tp:
		"haggle":
			var dec = str(c.get("dec", ""))
			if dec == "cut": d = 2.0
			elif dec == "no": d = -1.0
		"picky":
			if satisfied(sim, c):
				d += 1.0
				sim.ev.append({"k": "p_line", "pos": c.pos, "line": line(P, "picky", "ok"), "who": P.T(TD(P, "picky").get("tag", ["", ""]))})
			elif str(c.get("dec", "")) != "taste": d = 0.0; P.act(c, "hurt", 1.0)
	if J.t(c.get("cut_by")): d -= 1.0
	d += J.num(c.get("fam_plus"))
	var was = is_reg(P, sim, cid)
	add_fam(P, sim, cid, d)
	if not was and is_reg(P, sim, cid): sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -96), "txt": P.S("new_reg", "變咗熟客！", "成為熟客！"), "col": "#ff9ac0", "sz": 17})
	if not c.has("act") or str(c.act.k) == "wave": P.act(c, "hop", 0.9)
	if tp == "reg" and P.rng.randf() < FRIEND_P:
		if sim.spawn_cust():
			var f = sim.custs[sim.custs.size() - 1]; f["friend"] = true
			sim.ev.append({"k": "p_line", "pos": c.pos, "line": _friend_line(P), "who": P.T(TD(P, "reg").get("tag", ["", ""]))})
			P.stat_add(sim, "friend")

static func catch(P, sim, c: Dictionary, by: String) -> void:
	c["dash"] = false; c["caught"] = true
	var v = J.num(c.get("dash_v")) * CATCH_MUL
	sim.add_coins(v)
	sim.ev.append({"k": "p_coin", "pos": c.pos + Vector2(0, -60), "amt": v})
	sim.ev.append({"k": "p_line", "pos": c.pos, "line": _caught_line(P), "who": P.S("dasher", "走數鬼", "賴帳鬼")})
	sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -100), "txt": P.S("caught_vol", "義勇軍捉住走數鬼！", "義勇軍抓住賴帳鬼！") if by == "vol" else P.S("caught", "捉住！罰兩倍", "抓住！罰兩倍"), "col": "#9fe39a", "sz": 17})
	P.act(c, "down", 1.6)
	P.stat_add(sim, "caught_" + by)
static func _friend_line(P) -> String:
	var a = TD(P, "reg").get("lines", [])
	return P.T(a[a.size() - 1]) if a is Array and a.size() else ""
static func _caught_line(P) -> String:
	var a = P.D().TEMPERS.get("caught", [])
	return P.T(a[P.rng.randi() % a.size()]) if a is Array and a.size() else ""

static func step(P, sim, dt: float) -> void:
	var guarded = sim.guards.size() > 0 or MVW.vol_list().size() > 0
	for c in sim.custs:
		var tp = str(c.get("tp", ""))
		if tp == "cut" and not J.t(c.get("sent_back")) and (c.st == "in" or c.st == "queue"): c.s = maxf(0.0, float(c.s) - CUT_SPD * dt)
		if c.st != "out": continue
		if J.t(c.get("dash")) or J.t(c.get("flee")):
			c.s = float(c.s) + RUN_SPD * dt
			c["run_t"] = float(c.get("run_t", 0.0)) + dt
			if J.t(c.get("dash")) and not J.t(c.get("rolled")) and float(c.run_t) >= AUTO_T:
				c["rolled"] = true
				if guarded and P.rng.randf() < AUTO_CATCH: catch(P, sim, c, "vol"); continue
			if J.t(c.get("dash")) and not J.t(c.get("lost")) and float(c.s) >= sim.QLEN - 12.0:
				c["lost"] = true; sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -80), "txt": P.S("dash_lost", "走咗數！", "賴帳跑了！"), "col": "#ffb0a0"}); P.stat_add(sim, "dash_lost")

static func _hit(c: Dictionary, wp: Vector2) -> bool: return wp.distance_to(c.pos + Vector2(0, -40)) < 36.0
static func tap_world(P, sim, wp: Vector2) -> bool:
	for c in sim.custs:
		if not _hit(c, wp): continue
		var tp = str(c.get("tp", ""))
		if c.st == "out" and J.t(c.get("dash")): catch(P, sim, c, "tap"); return true
		if c.st == "out": continue
		if tp == "fake" and not J.t(c.get("unmask")): unmask(P, sim, c); return true
		if tp == "cut" and c.st != "serve" and not J.t(c.get("sent_back")): send_back(P, sim, c); return true
		if tp == "dash" and not J.t(c.get("prepaid")):
			c["prepaid"] = true; P.act(c, "hurt", 0.8)
			sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -96), "txt": P.S("prepaid", "先收錢！走唔甩", "先收錢！跑不掉"), "col": "#9fe39a"}); P.stat_add(sim, "prepaid")
			return true
	return false
static func send_back(P, sim, c: Dictionary) -> void:
	c["sent_back"] = true
	sim.custs.erase(c); sim.custs.append(c)
	for x in sim.custs:
		if J.t(x.get("cut_by")): x.erase("cut_by"); x["pat_b"] = float(x.get("pat_b", 0.0)) + CUT_PAT; x["fam_plus"] = 1.0
	P.act(c, "hurt", 1.0)
	sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -96), "txt": P.S("sent_back", "排返去尾！", "排回隊尾！"), "col": "#9fe39a"}); P.stat_add(sim, "sent_back")
static func unmask(P, sim, c: Dictionary) -> void:
	c["unmask"] = true; c["flee"] = true; c.st = "out"
	for g in c.got: sim._put_counter(str(g), int(c.got[g]))
	c.got = {}
	var v = MD.foe_coin(sim.ci()) * 3.0
	sim.add_coins(v); MVW.add_inf(1.0)
	P.act(c, "startle", 1.0)
	sim.ev.append({"k": "p_coin", "pos": c.pos + Vector2(0, -60), "amt": v})
	sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -100), "txt": P.S("unmask", "現形！影響力 +1", "現形！影響力 +1"), "col": "#9fe39a", "sz": 17})
	var e = P.live.get("ev")
	if e is Dictionary and str(e.k) == "fake": e["done"] = true
	P.stat_add(sim, "unmask")

static func tap_btn(P, sim, key: String, c) -> bool:
	if not (c is Dictionary) or not key.begins_with("c_"): return false
	var a = key.split(":")[0]
	match a:
		"c_hy": c["dec"] = "cut"; c["prompt"] = false; sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -100), "txt": P.S("hag_y", "減兩成，熟客度 +2", "減兩成，熟客度 +2"), "col": "#ffd27a"}); P.stat_add(sim, "hag_cut")
		"c_hn": c["dec"] = "no"; c["prompt"] = false; P.act(c, "hurt", 0.8); P.stat_add(sim, "hag_no")
		"c_pt":
			var g = str((c.get("star_need", {}) as Dictionary).keys()[0]) if c.get("star_need") is Dictionary and c.star_need.size() else ""
			if g != "" and P.take_goods(sim, g, 1) == 1:
				c["dec"] = "taste"; c["prompt"] = false; P.act(c, "proud", 0.8)
				sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -100), "txt": P.S("taste_ok", "試食咗：收足價", "試吃了：收足價"), "col": "#ffd27a"}); P.stat_add(sim, "taste")
			else: sim.ev.append({"k": "p_float", "pos": c.pos + Vector2(0, -100), "txt": P.S("taste_no", "冇貨請試食", "沒貨請試吃"), "col": "#ffb0a0"})
		_: return false
	return true

static func draw_world(P, sc, ctx, vy0: float, vy1: float) -> void:
	var sim = sc.sim
	for c in sim.custs:
		if c.pos.y < vy0 or c.pos.y - 200.0 > vy1: continue
		if J.t(c.get("prompt")) and c.st == "serve":
			var left = clampf(1.0 - (J.now() - J.num(c.get("pr_at", J.now()))) / PROMPT_MS, 0.0, 1.0)
			var bx = clampf(c.pos.x - 172.0, 4.0, FW() - 92.0); var by = c.pos.y - 150.0
			var opts = [["c_hy", P.S("b_hy", "減兩成", "減兩成"), "#3d7a3a"], ["c_hn", P.S("b_hn", "唔減", "不減"), "#7a3a2a"]] if str(c.tp) == "haggle" else [["c_pt", P.S("b_pt", "請試食", "請試吃"), "#3d7a3a"]]
			for i in opts.size():
				var r = Rect2(bx, by + i * 44.0, 88.0, 38.0)
				Art.rr(ctx, r.position.x, r.position.y, r.size.x, r.size.y, 9, opts[i][2], "#f2e2c0", 2)
				sc._txt(ctx, opts[i][1], r.position.x + 44.0, r.position.y + 19.0, 16, Color("#fff3e0"), "center", 900, 0)
				P._wbtn[opts[i][0] + ":" + str(c.get("ph"))] = [r, c]
			Art.rr(ctx, bx, by - 10.0, 88.0 * left, 5, 2, "#ffd27a")
		if c.st == "out" and J.t(c.get("dash")):
			var pul = 1.0 + 0.1 * sin(sc.t * 12.0)
			sc._txt(ctx, P.S("dash_tag", "走數！撳佢", "賴帳！點他"), c.pos.x, c.pos.y - 92.0, int(16 * pul), Color("#ff8a7a"), "center", 900, 4)
static func FW() -> float: return 390.0

static func draw_tag(P, sc, ctx, c: Dictionary, x: float, y: float, w: float) -> void:
	var tp = str(c.get("tp", ""))
	if tp in ["", "none"] or (tp == "dash" and J.t(c.get("prepaid"))) or (tp == "cut" and J.t(c.get("sent_back"))): return
	var tx = P.T(TD(P, tp).get("tag", ["", ""]))
	if tx == "": return
	var col = {"haggle": "#ffd27a", "cut": "#f2a080", "dash": "#ff8a7a", "picky": "#bfe0ff", "reg": "#ff9ac0", "fake": "#d8b0ff"}.get(tp, "#f0e2c8")
	if tp == "picky" and c.get("star_need") is Dictionary:
		for g in c.star_need: tx += "★%d" % int(c.star_need[g])
	if tp == "reg": tx += "♥"
	if J.t(c.get("friend")) and tp != "reg": tx = P.S("friend", "朋友", "朋友") + "・" + tx
	ctx.font = "900 14px sans-serif"
	var tw = ctx.measureText(tx).width + 12.0
	var tx0 = clampf(x + w / 2.0 - tw / 2.0, 4.0, FW() - tw - 4.0)
	Art.rr(ctx, tx0, y - 22.0, tw, 20.0, 6, "rgba(20,10,16,.88)", col, 1.2)
	sc._txt(ctx, tx, tx0 + tw / 2.0, y - 12.0, 14, Color(col), "center", 900, 0)

static func eat(P, sc) -> void:
	var sim = sc.sim
	for e in sim.ev:
		match str(e.get("k", "")):
			"p_dash":
				sc._bubble(e.pos + Vector2(-60, -70), str(e.line), P.S("dasher", "走數鬼", "賴帳鬼"), 2.0)
				sc._snd("whoosh")
			"p_fake_steal":
				sc._float(e.pos, P.S("fake_steal", "孤魂扮客，拎咗 %d 件走！", "孤魂扮客，拿了 %d 件跑了！") % int(e.n), Color("#ffb0a0"), 16, 1.8)
				sc._snd("scare")
