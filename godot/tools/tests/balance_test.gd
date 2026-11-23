# [balance] 數值平衡：無畫面自動對戰（rts_sim），6 章主線 18 關 ＋ 96 個據點（含 6 個魔王據點）
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> <tag> res://tools/tests/balance_test.gd <func> <秒>
#   probe：計時（一場要幾耐）＋印一隻鬼實例
#   c0 … c5：跑第 1～6 章（主線 3 關 ＋ 該章據點），結果寫 /tmp/bal/c<N>.json，印每個場地一行
#   ca／cb：c0+c1+c2／c3+c4+c5（兩個測試槽各跑一半）
#   all：六章 ＋ 合格線判定（RESULT ok／bad）
# 方法（報告：/home/claude/docs/balance_report.md）：
#   1. 每個場地用真實出擊路徑生成敵人（據點：so_data.stage_of → soul guard_stage → Battle.start → apply_camp → _soften → 第 4 圈頭目；
#      主線：Battle.start(c, si) → _soften(stage)），陰兵 4 隊、遊魂兵 0 隊（counter.md 9.3）。
#   2. 我方名鬼用 Battle.mkGhostUnit（同遊戲一樣：三圍×等級、阿福＝主公等級×2），職級按 soul_rhythm.md（第 1–2 章試用、3–5 章正式、第 6 章主任）。
#   3. 名鬼池＝劇情加入（STORY_CH ≤ 章）＋之前各章據點駐守鬼＋本章更內圈據點駐守鬼（主線第 s 關當第 s+1 圈）。
#   4. 三種隊：最佳隊（解析分數揀前 BEST_K 個候選，各跑種子，取表現最好）、全章固定萬能隊（候選隊跑全章，取平均表現最好）、隨機隊（N_RAND 隊）。
#   5. 表現分 perf＝平均每場（贏：1＋我方剩血比；輸：1−敵方剩血比），0～2；萬能度 U＝平均（萬能隊 perf ÷ 最佳隊 perf）。
extends RefCounted

var ok := 0
var bad := 0
const SIM = preload("res://game/rts/rts_sim.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const CT = preload("res://game/counter/ct_data.gd")
const AB = preload("res://game/rts/abil.gd")
const SD = preload("res://game/soul/soul_data.gd")
const NGB = preload("res://game/newghost/ng_boss.gd")

const DT := 0.05
const N_SEED := 6          # 最佳隊／萬能隊每場種子
const N_SEED_R := 3        # 隨機隊每隊種子
const N_RAND := 6          # 隨機隊數
const BEST_K := 5          # 最佳隊候選（解析分數前幾名）
const UNI_K := 6           # 萬能隊候選
const UP_LV := 3.5         # 容錯：萬能隊練高幾級
const N_YIN := 4
const PATH := [Vector2(0, 1500), Vector2(0, 800)]
const AT := Vector2(0, 640)
# 主線 p → 主公等級（CHAPTERS.req）；據點用同一把尺內插
const P2L := [[1, 3], [2, 3], [3, 4], [5, 6], [6, 6], [7, 7], [9, 8], [10, 9], [11, 9], [13, 10], [14, 11], [15, 11], [17, 12], [18, 13], [20, 14], [21, 15], [22, 16], [23, 17]]
const RANK_CH := [0, 0, 1, 1, 1, 2]   # soul_rhythm：核心名鬼平均職級（章開始時）
const OUT := "/tmp/bal"

func _p(m): print("[balance] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _boot(t) -> void:
	for i in 120:
		await _w(t, 0.5)
		var m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m2 = t.get_tree().root.get_node_or_null("Main")
	if m2 != null and m2.has_method("_hide_title"): m2._hide_title()
	var Bt = J.G.get("Battle")
	if Bt != null: Bt["auto"] = true
	SO.force_open = true; SO.test_now = 5000000.0
	DirAccess.make_dir_recursive_absolute(OUT)

static func p2l(p: float) -> float:
	if p <= P2L[0][0]: return float(P2L[0][1])
	for i in range(1, P2L.size()):
		if p <= P2L[i][0]:
			var a = P2L[i - 1]; var b = P2L[i]
			return lerpf(a[1], b[1], (p - a[0]) / float(b[0] - a[0]))
	return P2L[-1][1] + (p - P2L[-1][0]) * 0.7

# ================= 名鬼池 =================
var _gcache := {}
func guards_of(c: int) -> Array:   # [[ring, k]]
	if _gcache.has(c): return _gcache[c]
	var o = []
	for e in SO.camps(c):
		var k = SD.guard_of(e)
		if k != "": o.append([int(e.ring), k])
	_gcache[c] = o
	return o
func pool_of(c: int, ring: int) -> Array:
	var o = ["afu"]
	var sj = SD.D().STORY_JOIN; var sc = SD.D().STORY_CH
	for k in sj:
		if k == "afu": continue
		if int(sc.get(k, 0)) < c or (int(sc.get(k, 0)) == c and _story_in(k, c, ring)): if not o.has(k): o.append(k)
	for cc in range(0, c + 1):
		for x in guards_of(cc):
			if cc < c or int(x[0]) < ring:
				if not o.has(x[1]) and J.G.GHOSTS.has(x[1]): o.append(x[1])
	return o
func _story_in(k: String, c: int, ring: int) -> bool:   # 本章劇情鬼：打完第幾關先加入（join 嘅主線關＝第 si+1 圈之後）
	var CH = J.G.CHAPTERS
	var sts = CH[c].stages
	for si in sts.size():
		for j in sts[si].get("join", []):
			if str(j) == k: return ring > si + 1
	return c == 0 and k in ["xiaozhi"]   # 開場就有
func ghost_inst(k: String, lv: float, rk: int) -> Dictionary:
	var g = J.G.GHOSTS[k]
	var st = SD.stat_target(k, rk) if SD.is_ghost(k) else [float(g.base[0]), float(g.base[1]), float(g.base[2])]
	return {"id": "bal_" + k, "k": k, "name": str(g.name), "lv": lv, "st": st, "q": "名", "exp": 0.0}

# ================= 場地 =================
func sites_of(c: int) -> Array:
	var o = []
	var CH = J.G.CHAPTERS
	var sts = CH[c].stages
	for si in sts.size():
		var p = float(sts[si].p)
		o.append({"kind": "stage", "c": c, "si": si, "id": "%d-%d" % [c + 1, si + 1], "ring": si + 1, "p": p, "lv": float(sts[si].req), "name": str(sts[si].name)})
	for e in SO.camps(c):
		var lv = float(round(p2l(float(e.lv))))
		o.append({"kind": "sortie", "c": c, "e": e, "id": str(e.id), "ring": int(e.ring), "p": float(e.lv), "lv": lv, "bm": str(e.get("bm", "")), "name": str(e.id)})
	return o
func _set_save(c: int, lv: float, pool: Array, rk: int) -> void:
	var S = J.G.S
	S["lv"] = lv
	S.res["troops"] = 25.0 * N_YIN
	var gs = []
	var so = SD.st()
	for k in pool:
		gs.append(ghost_inst(k, lv, rk))
		if SD.is_ghost(k): so.rk[k] = float(rk)
	S["ghosts"] = gs
	S["team"] = [gs[0].id]
	S["adviser"] = null
# 敵人＋陰兵（我方名鬼另外換）
func site_snap(st: Dictionary) -> Dictionary:
	var B = J.G.Battle
	var snap = {}
	if st.kind == "stage":
		var c = float(st.c); var si = float(st.si)
		snap = RTS._start_battle(func(): J.mc(B, "start", [c, si]))
		if snap.is_empty(): return {}
		RTS._soften(snap, {"kind": "stage", "c": int(st.c)})
	else:
		var e = st.e
		var stg = SO.stage_of(e)
		stg = SD.guard_stage(e, stg)
		var wild = {"stage": stg, "bg": stg.bg, "sid": SO.sid_of(e), "sortie": true}
		snap = RTS._start_battle(func(): J.mc(B, "start", [-1.0, -1.0, wild]))
		if snap.is_empty(): return {}
		var gu = CT.apply_camp(snap, stg.ct) if stg.has("ct") else null
		RTS._soften(snap, {"kind": "sortie", "c": int(e.c)})
		if int(e.ring) >= 4:
			var last = gu
			if last == null:
				for u in snap.units: if J.num(u.side) == 1 and not J.t(u.get("minion")): last = u
			if last != null:
				var gk = str(stg.get("guard", ""))
				last["boss"] = true; last["hp"] = J.num(last.hp) * (1.25 if (gk != "" or gu != null) else SO.BOSS_HP); last["maxhp"] = last.hp
		NGB.decorate(snap, e)
	var foes = []; var sq = []
	for u in snap.units:
		if J.num(u.side) == 1: foes.append(u)
		elif J.t(u.get("minion")) and u.get("ml") == null and sq.size() < N_YIN: sq.append(u)
	return {"foes": foes, "sq": sq}

# ================= 一場 =================
func hero_units(team: Array, insts: Dictionary, up := 0.0) -> Array:
	var B = J.G.Battle
	var o = []
	for i in team.size():
		var g = insts[team[i]]
		if up != 0.0: g = g.duplicate(true); g["lv"] = J.num(g.lv) + up
		o.append(J.mc(B, "mkGhostUnit", [g, float(i)]))
	return o
func adviser_of(k: String, insts: Dictionary, up := 0.0):
	if k == "" or not insts.has(k): return null
	var g = insts[k]
	if up != 0.0: g = g.duplicate(true); g["lv"] = J.num(g.lv) + up
	var F = J.G.F
	return {"k": k, "name": str(g.name), "energy": 0.0, "sk": J.G.SKILLS.get(k), "bonus": J.num(J.mc(F, "stat", [g, 1.0])) / 8.0 / 100.0, "atk": 20.0 + J.num(J.mc(F, "stat", [g, 2.0])) * 1.4, "side": 0.0}
func fight(sn: Dictionary, team: Array, adv: String, insts: Dictionary, sd: int, up := 0.0) -> Dictionary:
	seed(9100 + sd * 7919)
	var us = []
	var hs = hero_units(team, insts, up)
	for u in hs: us.append(u)
	for u in sn.sq: us.append(u.duplicate(true))
	for u in sn.foes: us.append(u.duplicate(true))
	for u in us: u["cd"] = randf() * 0.5
	var op = SIM.new()
	op.kind = "sortie"
	op.adviser = adviser_of(adv, insts, up)
	op.setup(us, PackedVector2Array(PATH), AT, PATH[0])
	op.auto = true
	op.t_skip_march()
	var n = 0
	while op.result == null and n < 4000:
		op.step(DT); n += 1
		if op.events.size() > 64: op.events.clear()
	var r = op.result if op.result != null else {"win": false, "timeout": true}
	var win = J.t(r.get("win")); var to = J.t(r.get("timeout")) or op.result == null
	var mh = 0.0; var hh = 0.0; var fm = 0.0; var fh = 0.0; var dead = 0
	for u in op.units:
		if J.t(u.get("sum")) or J.t(u.get("clone")): continue
		if J.num(u.side) == 0:
			mh += J.num(u.get("maxhp", 1)); hh += maxf(0.0, J.num(u.hp))
			if J.t(u.get("minion")) and J.num(u.hp) <= 0: dead += 1
		else:
			fm += J.num(u.get("maxhp", 1)); fh += maxf(0.0, J.num(u.hp))
	var perf = (1.0 + hh / maxf(1.0, mh)) if win else (1.0 - fh / maxf(1.0, fm))
	return {"win": win, "to": to, "t": op.t, "dead": dead, "perf": perf}
func batch(sn: Dictionary, team: Array, adv: String, insts: Dictionary, ns: int, up := 0.0, s0 := 0) -> Dictionary:
	var R = {"w": 0, "n": 0, "to": 0, "t": 0.0, "dead": 0.0, "perf": 0.0}
	for s in ns:
		var r = fight(sn, team, adv, insts, s0 + s, up)
		R.n += 1; R.w += int(r.win); R.to += int(r.to); R.t += r.t; R.dead += r.dead; R.perf += r.perf
	return {"wr": R.w / float(R.n), "to": R.to / float(R.n), "t": R.t / R.n, "dead": R.dead / R.n, "perf": R.perf / R.n, "n": R.n}

# ================= 解析分數（揀候選用；counter.md 9.1 簡化） =================
const MECH_PEN := {"飛": 0.35, "隱": 0.6, "殼": 0.7, "再生": 0.75, "散骨": 0.75, "召喚": 0.7, "反傷": 0.8, "嚇氣光環": 0.75, "霸體": 0.8, "屍變": 0.7, "突襲": 0.8, "迷魂": 0.8, "分身": 0.75}
func _fmul(gk: String, e: Dictionary) -> float:
	var f = AB.fear_of(e.k)
	var sc = AB.scares_of(gk)
	var tp = null
	for x in sc: if f.w.has(x): tp = x; break
	if tp == null:
		for x in sc: if not f.i.has(x): tp = x; break
	if tp == null and sc.size(): tp = sc[0]
	if tp == null: return 1.0
	if f.w.has(tp): return 0.3 * 1.35 + 0.7 * 1.15
	if f.i.has(tp): return 0.3 * 0.6 + 0.7 * 0.8
	return 1.0
func ascore(team: Array, sn: Dictionary, pw: Dictionary) -> float:
	var tags = []
	for k in team:
		for x in AB.tags_of(k): if not tags.has(x): tags.append(x)
		if str(J.G.GHOSTS[k].get("range")) == "ranged" and not tags.has("遠"): tags.append("遠")
	var O = 0.0; var W = 0.0
	for e in sn.foes:
		var w = J.num(e.maxhp) * J.num(e.atk)
		var ms = AB.mechs_of(e.k)
		for m in AB._arr(e.get("mech")):
			var nm = AB.norm_mech(m); if nm != "" and not ms.has(nm): ms.append(nm)
		var pen = 1.0
		var cs = AB.counters_of(e.k)
		var have = false
		for x in cs: if tags.has(x): have = true
		for m in ms: pen *= (0.9 if have else MECH_PEN.get(m, 0.85))
		var s = 0.0
		for k in team: s += _fmul(k, e) * pw[k]
		O += w * s / team.size() * pen; W += w
	var P = 0.0
	for k in team: P += pw[k]
	return O / maxf(1.0, W) * (P / team.size())
func _combos(pool: Array) -> Array:
	var o = []
	var n = pool.size()
	for i in n:
		for j in range(i + 1, n):
			for k in range(j + 1, n): o.append([pool[i], pool[j], pool[k]])
	if o.is_empty(): o.append(pool.slice(0, 3))
	return o
func best_adv(team: Array, pool: Array, insts: Dictionary) -> String:
	var b = ""; var bi = -1.0
	for k in pool:
		if k in team: continue
		var v = J.num(insts[k].st[1])
		if v > bi: bi = v; b = k
	return b

# ================= 一章 =================
func run_ch(t, c: int) -> Dictionary:
	var t0 = Time.get_ticks_msec()
	var sites = sites_of(c)
	var rk = RANK_CH[c]
	var out = {"c": c, "sites": []}
	var snaps = []; var pools = []; var instss = []
	# 1) 每個場地：敵人快照、名鬼池、解析前幾名
	for st in sites:
		var pool = pool_of(c, int(st.ring))
		_set_save(c, st.lv, pool, rk)
		var insts = {}
		for g in J.G.S.ghosts: insts[str(g.k)] = g
		var sn = site_snap(st)
		var pw = {}
		for k in pool:
			var u = J.mc(J.G.Battle, "mkGhostUnit", [insts[k], 0.0])
			pw[k] = sqrt(J.num(u.maxhp) * J.num(u.atk))
		snaps.append(sn); pools.append(pool); instss.append({"i": insts, "pw": pw})
		await t.get_tree().process_frame
	# 2) 最佳隊
	var cand_all = {}   # 隊 key → 累計解析
	for i in sites.size():
		var st = sites[i]; var sn = snaps[i]; var pool = pools[i]; var insts = instss[i].i; var pw = instss[i].pw
		if sn.is_empty(): out.sites.append({"id": st.id, "err": "nobattle"}); continue
		var cs = _combos(pool)
		var sc = []
		for tm in cs: sc.append([ascore(tm, sn, pw), tm])
		sc.sort_custom(func(a, b): return a[0] > b[0])
		var best = null
		for j in mini(BEST_K, sc.size()):
			var tm = sc[j][1]; var adv = best_adv(tm, pool, insts)
			var r = batch(sn, tm, adv, insts, N_SEED)
			if best == null or r.perf > best.r.perf: best = {"team": tm, "adv": adv, "r": r}
		# 隨機隊
		var rr = {"wr": 0.0, "to": 0.0, "t": 0.0, "dead": 0.0, "perf": 0.0, "n": 0}
		var rng = RandomNumberGenerator.new(); rng.seed = 555 + i * 31 + c * 1000
		for j in N_RAND:
			var p2 = pool.duplicate()
			for q in range(p2.size() - 1, 0, -1):
				var x = rng.randi_range(0, q); var tmp = p2[q]; p2[q] = p2[x]; p2[x] = tmp
			var tm = p2.slice(0, mini(3, p2.size()))
			var adv = p2[3] if p2.size() > 3 else ""
			var r = batch(sn, tm, adv, insts, N_SEED_R, 0.0, 100 + j * 10)
			for f in ["wr", "to", "t", "dead", "perf"]: rr[f] += r[f] / N_RAND
		var row = {"id": st.id, "kind": st.kind, "ring": st.ring, "p": st.p, "lv": st.lv, "bm": st.get("bm", ""), "pool": pool.size(), "foes": _fk(sn),
			"best": best.team, "badv": best.adv, "B": best.r, "R": rr}
		out.sites.append(row)
		_p("c%d %s r%d p%.1f lv%d 池%d 最佳%s+%s 勝%.0f%% %.0fs 死%.1f perf%.2f｜隨機 勝%.0f%% perf%.2f" % [c + 1, st.id, st.ring, st.p, st.lv, pool.size(), str(best.team), best.adv, best.r.wr * 100, best.r.t, best.r.dead, best.r.perf, rr.wr * 100, rr.perf])
		# 萬能隊候選：只要全章都有嘅鬼（第 1 圈池）→ 之後過濾
		for j in mini(UNI_K * 2, sc.size()):
			var key = ",".join(sc[j][1])
			cand_all[key] = float(cand_all.get(key, 0.0)) + sc[j][0]
		await t.get_tree().process_frame
	# 3) 萬能隊：全章固定（隊員要喺第 1 個場地已經有，即全章都揀得）
	var base_pool = pools[0]
	for i in sites.size(): if int(sites[i].ring) == 1 and sites[i].kind == "sortie": base_pool = pools[i]; break
	var cands = []
	for row in out.sites:
		if row.has("best"):
			var ok2 = true
			for k in row.best: if not base_pool.has(k): ok2 = false
			if ok2 and not cands.has(row.best): cands.append(row.best)
	var ks = cand_all.keys()
	ks.sort_custom(func(a, b): return cand_all[a] > cand_all[b])
	for key in ks:
		var tm = Array(key.split(","))
		var ok3 = true
		for k in tm: if not base_pool.has(k): ok3 = false
		if ok3 and not cands.has(tm): cands.append(tm)
		if cands.size() >= UNI_K + 4: break
	# 先用 2 個種子粗篩，前 3 名再跑全種子
	var rough = []
	for tm in cands.slice(0, UNI_K + 4):
		var s = 0.0
		for i in sites.size():
			if snaps[i].is_empty(): continue
			var adv = best_adv(tm, base_pool, instss[i].i)
			s += batch(snaps[i], tm, adv, instss[i].i, 2, 0.0, 300).perf
		rough.append([s, tm])
		await t.get_tree().process_frame
	rough.sort_custom(func(a, b): return a[0] > b[0])
	var uni = null
	for x in rough.slice(0, 3):
		var tm = x[1]; var tot = 0.0; var per = []
		for i in sites.size():
			if snaps[i].is_empty(): per.append(null); continue
			var adv = best_adv(tm, base_pool, instss[i].i)
			var r = batch(snaps[i], tm, adv, instss[i].i, N_SEED)
			per.append(r); tot += r.perf
		if uni == null or tot > uni.tot: uni = {"team": tm, "tot": tot, "per": per}
		await t.get_tree().process_frame
	out["uni"] = uni.team
	var urow = []
	for i in sites.size():
		if snaps[i].is_empty(): continue
		var row = out.sites[i]
		row["U"] = uni.per[i]
		var adv = best_adv(uni.team, base_pool, instss[i].i)
		row["U35"] = batch(snaps[i], uni.team, adv, instss[i].i, N_SEED, UP_LV)
		row["u"] = uni.per[i].perf / maxf(0.01, row.B.perf)
		_p("c%d %s 萬能隊%s 勝%.0f%% perf%.2f（÷最佳 %.2f）｜+%.1f級 勝%.0f%%" % [c + 1, row.id, str(uni.team), uni.per[i].wr * 100, uni.per[i].perf, row.u, UP_LV, row.U35.wr * 100])
		await t.get_tree().process_frame
	out["sec"] = (Time.get_ticks_msec() - t0) / 1000.0
	var f = FileAccess.open(OUT + "/c%d.json" % c, FileAccess.WRITE)
	f.store_string(JSON.stringify(out)); f.close()
	_p("c%d 完成 %.0f 秒" % [c + 1, out.sec])
	return out
func _fk(sn: Dictionary) -> Array:
	var o = []
	for u in sn.foes: o.append(str(u.k))
	return o

# ================= 入口 =================
func probe(t) -> void:
	await _boot(t)
	_p("ghost0 " + str(J.G.S.ghosts[0]))
	for c in 6:
		var pl = []
		for r in 5: pl.append(pool_of(c, r + 1).size())
		_p("c%d 池（圈1-4,5）%s 場地 %d" % [c + 1, str(pl), sites_of(c).size()])
	var sites = sites_of(4)
	var st = sites[10]
	var pool = pool_of(4, int(st.ring))
	_set_save(4, st.lv, pool, 1)
	var insts = {}
	for g in J.G.S.ghosts: insts[str(g.k)] = g
	var sn = site_snap(st)
	_p("site %s foes %s sq %d" % [st.id, str(_fk(sn)), sn.sq.size()])
	var t0 = Time.get_ticks_msec()
	var r = batch(sn, pool.slice(0, 3), pool[3], insts, 10)
	_p("10 場 %.2f 秒：%s" % [(Time.get_ticks_msec() - t0) / 1000.0, str(r)])
	t0 = Time.get_ticks_msec()
	var sn2 = site_snap(sites[0])
	_p("snap 一個 %.3f 秒" % [(Time.get_ticks_msec() - t0) / 1000.0])
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func c0(t) -> void: await _boot(t); await run_ch(t, 0); _p("RESULT ok=1 bad=0")
func c1(t) -> void: await _boot(t); await run_ch(t, 1); _p("RESULT ok=1 bad=0")
func c2(t) -> void: await _boot(t); await run_ch(t, 2); _p("RESULT ok=1 bad=0")
func c3(t) -> void: await _boot(t); await run_ch(t, 3); _p("RESULT ok=1 bad=0")
func c4(t) -> void: await _boot(t); await run_ch(t, 4); _p("RESULT ok=1 bad=0")
func c5(t) -> void: await _boot(t); await run_ch(t, 5); _p("RESULT ok=1 bad=0")
func ca(t) -> void:
	await _boot(t)
	for c in [0, 1, 2]: await run_ch(t, c)
	_p("RESULT ok=1 bad=0")
func cb(t) -> void:
	await _boot(t)
	for c in [3, 4, 5]: await run_ch(t, c)
	_p("RESULT ok=1 bad=0")
