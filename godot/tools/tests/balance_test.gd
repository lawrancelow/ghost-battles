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

var DT := 0.1          # 0.1 同 0.05 結果相近（probe 驗過），快 1.7 倍
const N_SEED := 6          # 最佳隊／萬能隊每場種子
const N_SEED_R := 2        # 隨機隊每隊種子
const N_RAND := 6          # 隨機隊數
const BEST_K := 4          # 最佳隊候選（解析分數前幾名）
const UNI_K := 6           # 萬能隊候選
const UP_LV := 3.5         # 容錯：萬能隊練高幾級
const N_YIN := 4
const PATH := [Vector2(0, 1500), Vector2(0, 800)]
const AT := Vector2(0, 640)
# 主線 p → 主公等級（CHAPTERS.req）；據點用同一把尺內插
const P2L := [[1, 3], [2, 3], [3, 4], [5, 6], [6, 6], [7, 7], [9, 8], [10, 9], [11, 9], [13, 10], [14, 11], [15, 11], [17, 12], [18, 13], [20, 14], [21, 15], [22, 16], [23, 17]]
const RANK_CH := [0, 0, 1, 1, 1, 2]   # soul_rhythm：核心名鬼平均職級（章開始時）
const OUT := "/tmp/bal"
const OWN := [6, 14, 24, 34, 54, 66, 85]

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
	# 擁有數上限：soul_rhythm.md 每日60分玩家（章開始 6／14／24／34／54／66，第 6 章尾 85），章內按圈線性增加；先到先得（早章、內圈先）
	var cap = int(round(OWN[c] + (OWN[c + 1] - OWN[c]) * (ring - 1) / 4.0))
	for cc in range(0, c + 1):
		for x in guards_of(cc):
			if o.size() >= cap: break
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

# 據點題目整體縮放（＝counter.json 該據點 hm、am 同乘 s；遊魂嘍囉 foe_ml 唔受影響）
func scaled(sn: Dictionary, sk: float) -> Dictionary:
	if sk == 1.0: return sn
	var fs = []
	for u in sn.foes:
		var v = u.duplicate(true)
		if v.get("foe_ml") == null:
			v["hp"] = J.num(v.hp) * sk; v["maxhp"] = J.num(v.maxhp) * sk; v["atk"] = J.num(v.atk) * sk
		fs.append(v)
	return {"foes": fs, "sq": sn.sq}

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
const TOPN := 14   # 名鬼池大過呢個數：先用單隻解析分數揀前 TOPN 隻先砌組合（C(90,3) 太多）
func top_pool(pool: Array, sn: Dictionary, pw: Dictionary) -> Array:
	if pool.size() <= TOPN: return pool
	var sc = []
	for k in pool: sc.append([ascore([k], sn, pw), k])
	sc.sort_custom(func(a, b): return a[0] > b[0])
	var o = []
	for x in sc.slice(0, TOPN): o.append(x[1])
	return o
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
func _sub(tm: Array, pool: Array) -> bool:
	for k in tm: if not pool.has(k): return false
	return true
func _better(a: Dictionary, b) -> bool: return b == null or a.wr + 0.1 * a.perf > b.wr + 0.1 * b.perf
func run_ch(t, c: int) -> Dictionary:
	var t0 = Time.get_ticks_msec()
	var sites = sites_of(c)
	var rk = RANK_CH[c]
	var out = {"c": c, "sites": []}
	var snaps = []; var pools = []; var instss = []; var M = []
	if CAL and STEPS.has(c): out["steps"] = await step_test(t, c, sites, rk)
	# 1) 每個場地：敵人快照、名鬼池；解析前 BEST_K 名各跑 1 種子
	var G = []
	for i in sites.size():
		var st = sites[i]
		var pool = pool_of(c, int(st.ring))
		_set_save(c, st.lv, pool, rk)
		var insts = {}
		for k in pool_of(c, 5): insts[k] = ghost_inst(k, st.lv, rk)   # 全章名鬼實例（萬能隊可能用到本場地未有嘅鬼）
		for g in J.G.S.ghosts: insts[str(g.k)] = g
		var sn = site_snap(st)
		var pw = {}
		for k in pool:
			var u = J.mc(J.G.Battle, "mkGhostUnit", [insts[k], 0.0])
			pw[k] = sqrt(J.num(u.maxhp) * J.num(u.atk))
		snaps.append(sn); pools.append(pool); instss.append(insts)
		var m = {}
		if not sn.is_empty():
			var sc = []
			for tm in _combos(top_pool(pool, sn, pw)): sc.append([ascore(tm, sn, pw), tm])
			sc.sort_custom(func(a, b): return a[0] > b[0])
			var scr = []
			for j in mini(BEST_K, sc.size()):
				var tm = sc[j][1]
				var r = batch(sn, tm, best_adv(tm, pool, insts), insts, 1)
				m[",".join(tm)] = r.perf; scr.append([r.perf, tm])
			scr.sort_custom(func(a, b): return a[0] > b[0])
			for x in scr.slice(0, 1): if not G.has(x[1]): G.append(x[1])
		M.append(m)
		await t.get_tree().process_frame
	# 2) 全章候選隊逐個場地跑 1 種子（有齊隊員先跑）
	for i in sites.size():
		if snaps[i].is_empty(): continue
		for tm in G:
			var key = ",".join(tm)
			if M[i].has(key) or not _sub(tm, pools[i]): continue
			M[i][key] = batch(snaps[i], tm, best_adv(tm, pools[i], instss[i]), instss[i], 1).perf
		await t.get_tree().process_frame
	# 3) 萬能隊：隊員喺第 1 圈已經有（全章揀得）；粗篩總分前 2 → 全種子
	var base_pool = pool_of(c, 2)   # 萬能隊：第 2 圈時已擁有嘅鬼（第 1 章第 1 圈得 2 隻，湊唔夠 3 隻）
	var rough = []
	for tm in G:
		if not _sub(tm, base_pool): continue
		var s = 0.0
		for i in sites.size(): s += float(M[i].get(",".join(tm), 0.0))
		rough.append([s, tm])
	if rough.is_empty(): rough.append([0.0, base_pool.slice(0, 3)])
	rough.sort_custom(func(a, b): return a[0] > b[0])
	var uni = null; var unis = []
	for x in rough.slice(0, 2):
		var tm = x[1]; var tot = 0.0; var per = []
		for i in sites.size():
			if snaps[i].is_empty(): per.append(null); continue
			var r = batch(snaps[i], tm, best_adv(tm, base_pool, instss[i]), instss[i], N_SEED)
			per.append(r); tot += r.perf
		var u = {"team": tm, "tot": tot, "per": per}
		unis.append(u)
		if uni == null or tot > uni.tot: uni = u
		await t.get_tree().process_frame
	out["uni"] = uni.team
	# 4) 每個場地：最佳隊（M 前 2 名全種子；萬能隊候選都計）、隨機隊、萬能隊 +3.5 級
	var nto = 0; var nall = 0
	for i in sites.size():
		var st = sites[i]; var sn = snaps[i]; var pool = pools[i]; var insts = instss[i]
		if sn.is_empty(): out.sites.append({"id": st.id, "err": "nobattle"}); continue
		var ks = M[i].keys()
		ks.sort_custom(func(a, b): return M[i][a] > M[i][b])
		var best = null
		for u in unis:
			if u.per[i] != null and _sub(u.team, pool) and _better(u.per[i], null if best == null else best.r): best = {"team": u.team, "adv": best_adv(u.team, pool, insts), "r": u.per[i]}
		for key in ks.slice(0, 2):
			var tm = Array(key.split(","))
			var same = false
			for u in unis: if u.team == tm: same = true
			if same: continue
			var adv = best_adv(tm, pool, insts)
			var r = batch(sn, tm, adv, insts, N_SEED)
			if _better(r, null if best == null else best.r): best = {"team": tm, "adv": adv, "r": r}
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
		var U = uni.per[i]
		var U35 = batch(sn, uni.team, best_adv(uni.team, base_pool, insts), insts, 3, UP_LV)
		var row = {"id": st.id, "kind": st.kind, "ring": st.ring, "p": st.p, "lv": st.lv, "bm": st.get("bm", ""), "pool": pool.size(), "foes": _fk(sn),
			"best": best.team, "badv": best.adv, "B": best.r, "R": rr, "U": U, "U35": U35, "u": U.perf / maxf(0.01, best.r.perf)}
		var cr = {}
		if CAL and st.kind == "sortie":
			cr = cal_site(sn, best, pool, insts, i, c, int(st.ring))
			row["s"] = cr.s; row["cal"] = cr
		out.sites.append(row)
		if row.has("s"): _p("c%d %-9s 校準 s=%.3f（最佳 勝%.0f%%、隨機 勝%.0f%%）" % [c + 1, st.id, row.s, cr.B * 100, cr.R * 100])
		_p("c%d %-9s r%d p%4.1f lv%2d 池%2d｜最佳 勝%3.0f%% %2.0fs 死%.1f 時間到%.0f%% perf%.2f %s+%s｜隨機 勝%3.0f%%｜萬能 勝%3.0f%% u%.2f｜+3.5 勝%3.0f%%" % [c + 1, st.id, st.ring, st.p, st.lv, pool.size(),
			best.r.wr * 100, best.r.t, best.r.dead, best.r.to * 100, best.r.perf, str(best.team), best.adv, rr.wr * 100, U.wr * 100, row.u, U35.wr * 100])
		await t.get_tree().process_frame
	var nm = {}
	for k in pool_of(c, 5): nm[k] = str(DB.N(str(J.G.GHOSTS[k].name)))
	for sn in snaps:
		if sn.is_empty(): continue
		for u in sn.foes: nm[str(u.k)] = str(u.get("name", u.k))
	out["names"] = nm
	if not CAL: judge(out)
	out["sec"] = (Time.get_ticks_msec() - t0) / 1000.0
	var f = FileAccess.open(OUT + "/c%d.json" % c, FileAccess.WRITE)
	f.store_string(JSON.stringify(out)); f.close()
	_p("c%d 完成 %.0f 秒｜萬能隊 %s｜候選 %d 隊" % [c + 1, out.sec, str(uni.team), G.size()])
	return out
func _fk(sn: Dictionary) -> Array:
	var o = []
	for u in sn.foes: o.append(str(u.k))
	return o

# ================= 合格線 =================
func judge(out: Dictionary) -> void:
	var c = int(out.c); var bb = []; var rb = []; var r1 = []; var ub = []; var us = 0.0; var n = 0; var to = 0.0; var tn = 0.0
	for r in out.sites:
		if r.has("err"): bb.append(r.id); continue
		if r.B.wr < 0.8: bb.append("%s %.0f%%" % [r.id, r.B.wr * 100])
		if r.R.wr < 0.25 and r.kind == "sortie": rb.append("%s %.0f%%" % [r.id, r.R.wr * 100])   # 隨機隊 ≥25%：據點合格線（審查修正 11③）；主線關照記錄唔判
		if int(r.ring) == 1 and r.B.wr < 0.95: r1.append("%s %.0f%%" % [r.id, r.B.wr * 100])
		if r.U35.wr < 0.5: ub.append("%s %.0f%%" % [r.id, r.U35.wr * 100])
		us += minf(1.0, r.u); n += 1
		to += r.B.to * r.B.n + r.U.to * r.U.n + r.R.to * N_RAND * N_SEED_R; tn += r.B.n + r.U.n + N_RAND * N_SEED_R
	var U = us / maxf(1.0, n)
	out["Uavg"] = U; out["to_rate"] = to / maxf(1.0, tn)
	_chk("第 %d 章：每個場地最佳隊勝率 ≥80%%" % (c + 1), bb.is_empty(), bb)
	_chk("第 %d 章：每個據點隨機隊勝率 ≥25%%" % (c + 1), rb.is_empty(), rb)
	_chk("第 %d 章：第 1 圈最佳隊勝率 ≥95%%" % (c + 1), r1.is_empty(), r1)
	_chk("第 %d 章：萬能隊練高 %.1f 級過每個場地（勝率 ≥50%%）" % [c + 1, UP_LV], ub.is_empty(), ub)
	_chk("第 %d 章：時間到比率 ≤15%%" % (c + 1), out.to_rate <= 0.15, "%.1f%%" % (out.to_rate * 100))
	if c >= 1: _chk("第 %d 章：萬能度 U ≤ 0.85" % (c + 1), U <= 0.85, "%.3f %s" % [U, str(out.uni)])
	else: _p("（第 1 章教學：萬能度 U=%.3f 唔設線）" % U)

# ================= 校準 =================
var CAL := false
const STEPS := {4: [[0.70, 0.55], [0.85, 0.75], [1.0, 1.0]], 5: [[0.65, 0.50], [0.80, 0.70], [1.0, 1.0]]}   # counter.md 10.2：A／B／C
func _rand_wr(sn: Dictionary, pool: Array, insts: Dictionary, i: int, c: int, nt: int, ns: int) -> float:
	var rng = RandomNumberGenerator.new(); rng.seed = 777 + i * 31 + c * 1000
	var w = 0.0
	for j in nt:
		var p2 = pool.duplicate()
		for q in range(p2.size() - 1, 0, -1):
			var x = rng.randi_range(0, q); var tmp = p2[q]; p2[q] = p2[x]; p2[x] = tmp
		w += batch(sn, p2.slice(0, mini(3, p2.size())), p2[3] if p2.size() > 3 else "", insts, ns, 0.0, 200 + j * 10).wr / nt
	return w
func _cal_ok(sn, best, pool, insts, i, c, ring, sk) -> Dictionary:
	var s2 = scaled(sn, sk)
	var b = batch(s2, best.team, best.adv, insts, 4, 0.0, 50).wr
	var r = _rand_wr(s2, pool, insts, i, c, 4, 2)
	return {"ok": b >= 0.99 and r >= 0.375, "B": b, "R": r}
func cal_site(sn, best, pool, insts, i, c, ring) -> Dictionary:
	var top = _cal_ok(sn, best, pool, insts, i, c, ring, 1.0)
	if top.ok: return {"s": 1.0, "B": top.B, "R": top.R}
	var lo = log(0.15); var hi = 0.0; var lr = null
	for it in 5:
		var mid = (lo + hi) / 2.0
		var r = _cal_ok(sn, best, pool, insts, i, c, ring, exp(mid))
		if r.ok: lo = mid; lr = r
		else: hi = mid
	if lr == null: lr = _cal_ok(sn, best, pool, insts, i, c, ring, exp(lo))
	return {"s": snappedf(exp(lo), 0.001), "B": lr.B, "R": lr.R}
# 第 5、6 關主線：A／B／C 三步逐步試；全部主線關最佳隊 ≥ 5/6、隨機隊 ≥ 25% 先算過；揀最遠過到嘅一步，主線 ch_k、據點 sortie_k 同步
func step_test(t, c: int, sites: Array, rk: int) -> Dictionary:
	var res = {"tried": [], "pick": 0}
	var D = CT.data()
	for si in STEPS[c].size():
		var k = STEPS[c][si]
		D["ch_k"][str(c)] = {"hp": k[0], "atk": k[1]}
		var allok = true; var rows = []
		for st in sites:
			if st.kind != "stage": continue
			var pool = pool_of(c, int(st.ring))
			_set_save(c, st.lv, pool, rk)
			var insts = {}
			for g in J.G.S.ghosts: insts[str(g.k)] = g
			var sn = site_snap(st)
			var pw = {}
			for kk in pool:
				var u = J.mc(J.G.Battle, "mkGhostUnit", [insts[kk], 0.0]); pw[kk] = sqrt(J.num(u.maxhp) * J.num(u.atk))
			var sc = []
			for tm in _combos(top_pool(pool, sn, pw)): sc.append([ascore(tm, sn, pw), tm])
			sc.sort_custom(func(a, b): return a[0] > b[0])
			var best = null
			for j in mini(6, sc.size()):
				var tm = sc[j][1]
				var r = batch(sn, tm, best_adv(tm, pool, insts), insts, N_SEED)
				if _better(r, null if best == null else best.r): best = {"team": tm, "r": r}
			var rw = _rand_wr(sn, pool, insts, 0, c, N_RAND, 2)
			rows.append([st.id, best.r.wr, rw, best.team])
			if best.r.wr < 0.8: allok = false   # 主線只要最佳隊 ≥80%（隨機 ≥25% 係「據點」合格線，審查修正 11③；隨機照記錄）
			await t.get_tree().process_frame
		res.tried.append({"step": "ABC"[si], "k": k, "rows": rows, "ok": allok})
		_p("c%d 主線 SOFT 步驟 %s %s：%s %s" % [c + 1, "ABC"[si], str(k), "過" if allok else "唔過", str(rows)])
		if allok: res.pick = si
		else: break
	var kp = STEPS[c][res.pick]
	D["ch_k"][str(c)] = {"hp": kp[0], "atk": kp[1]}
	D["sortie_k"][str(c)] = {"hp": STEPS[c][0][0], "atk": STEPS[c][0][1]}   # 據點固定步驟 A（據點難度由 hm／am 校準負責）
	res["k"] = kp
	return res

# 輕量校準（每批 ≤ 10 分鐘）：只做指定圈嘅據點；"stage"＝第 5、6 關主線 SOFT 步驟試
func run_cal(t, c: int, rings: Array, tag: String) -> void:
	var t0 = Time.get_ticks_msec()
	CAL = true
	var sites = sites_of(c); var rk = RANK_CH[c]
	var out = {"c": c, "sites": [], "part": tag}
	if rings.has("stage") and STEPS.has(c): out["steps"] = await step_test(t, c, sites, rk)
	elif STEPS.has(c):   # 據點批次：沿用主線批揀到嘅步驟（冇就 A）
		var kp = STEPS[c][0]
		var fp = OUT + "/cal_c%d_stage.json" % c
		if FileAccess.file_exists(fp):
			var j = JSON.parse_string(FileAccess.get_file_as_string(fp))
			if j is Dictionary and j.has("steps"): kp = j.steps.k
		var D = CT.data()
		D["ch_k"][str(c)] = {"hp": kp[0], "atk": kp[1]}; D["sortie_k"][str(c)] = {"hp": STEPS[c][0][0], "atk": STEPS[c][0][1]}
	for i in sites.size():
		var st = sites[i]
		if st.kind != "sortie" or not rings.has(int(st.ring)): continue
		var pool = pool_of(c, int(st.ring))
		_set_save(c, st.lv, pool, rk)
		var insts = {}
		for g in J.G.S.ghosts: insts[str(g.k)] = g
		var sn = site_snap(st)
		if sn.is_empty(): continue
		var pw = {}
		for k in pool:
			var u = J.mc(J.G.Battle, "mkGhostUnit", [insts[k], 0.0]); pw[k] = sqrt(J.num(u.maxhp) * J.num(u.atk))
		var sc = []
		for tm in _combos(top_pool(pool, sn, pw)): sc.append([ascore(tm, sn, pw), tm])
		sc.sort_custom(func(a, b): return a[0] > b[0])
		var scr = []
		for j in mini(6, sc.size()):
			var tm = sc[j][1]
			scr.append([batch(sn, tm, best_adv(tm, pool, insts), insts, 1).perf, tm])
		scr.sort_custom(func(a, b): return a[0] > b[0])
		var best = null
		for x in scr.slice(0, 2):
			var adv = best_adv(x[1], pool, insts)
			var r = batch(sn, x[1], adv, insts, 4)
			if _better(r, null if best == null else best.r): best = {"team": x[1], "adv": adv, "r": r}
		var cr = cal_site(sn, best, pool, insts, i, c, int(st.ring))
		out.sites.append({"id": st.id, "ring": st.ring, "s": cr.s, "cal": cr, "best": best.team})
		_p("c%d %-9s 校準 s=%.3f（最佳 勝%.0f%%、隨機 勝%.0f%%）%s" % [c + 1, st.id, cr.s, cr.B * 100, cr.R * 100, str(best.team)])
		await t.get_tree().process_frame
	var f = FileAccess.open(OUT + "/cal_c%d_%s.json" % [c, tag], FileAccess.WRITE)
	f.store_string(JSON.stringify(out)); f.close()
	_p("c%d 校準批 %s 完成 %.0f 秒" % [c + 1, tag, (Time.get_ticks_msec() - t0) / 1000.0])
func k0a(t) -> void: await _boot(t); await run_cal(t, 0, [1, 2], "r12"); _p("RESULT ok=1 bad=0")
func k0b(t) -> void: await _boot(t); await run_cal(t, 0, [3, 4], "r34"); _p("RESULT ok=1 bad=0")
func k1a(t) -> void: await _boot(t); await run_cal(t, 1, [1, 2], "r12"); _p("RESULT ok=1 bad=0")
func k1b(t) -> void: await _boot(t); await run_cal(t, 1, [3, 4], "r34"); _p("RESULT ok=1 bad=0")
func k2a(t) -> void: await _boot(t); await run_cal(t, 2, [1, 2], "r12"); _p("RESULT ok=1 bad=0")
func k2b(t) -> void: await _boot(t); await run_cal(t, 2, [3, 4], "r34"); _p("RESULT ok=1 bad=0")
func k3a(t) -> void: await _boot(t); await run_cal(t, 3, [1, 2], "r12"); _p("RESULT ok=1 bad=0")
func k3b(t) -> void: await _boot(t); await run_cal(t, 3, [3, 4], "r34"); _p("RESULT ok=1 bad=0")
func k4s(t) -> void: await _boot(t); await run_cal(t, 4, ["stage"], "stage"); _p("RESULT ok=1 bad=0")
func k4a(t) -> void: await _boot(t); await run_cal(t, 4, [1, 2], "r12"); _p("RESULT ok=1 bad=0")
func k4b(t) -> void: await _boot(t); await run_cal(t, 4, [3, 4], "r34"); _p("RESULT ok=1 bad=0")
func k5s(t) -> void: await _boot(t); await run_cal(t, 5, ["stage"], "stage"); _p("RESULT ok=1 bad=0")
func k5a(t) -> void: await _boot(t); await run_cal(t, 5, [1, 2], "r12"); _p("RESULT ok=1 bad=0")
func k5b(t) -> void: await _boot(t); await run_cal(t, 5, [3, 4], "r34"); _p("RESULT ok=1 bad=0")

# ================= 機制強度掃描（abil_test mech 同一套場景；只改記憶體入面 MECH 數值） =================
const MSW := {   # 第 2 輪（第 1 輪結果見報告：飛 0.45、召喚 1/3 已定）
	"隱": [{"dur": 4.5, "cycle": 6.0, "near": 70.0}, {"dur": 4.5, "cycle": 6.0, "near": 60.0}, {"dur": 5.0, "cycle": 6.0, "near": 70.0}, {"dur": 4.0, "cycle": 6.0, "near": 50.0}, {"dur": 4.8, "cycle": 6.0, "near": 65.0}],
	"反傷": [{"pct": 1.1}, {"pct": 1.4}],
	"嚇氣光環": [{"energy": 0.0, "minion_atk": 0.3, "r": 250.0}, {"energy": 0.1, "minion_atk": 0.4, "r": 300.0}, {"energy": 0.0, "minion_atk": 0.2, "r": 300.0}],
}
func msweep(t) -> void:
	await _boot(t)
	var AT = load("res://tools/tests/abil_test.gd").new()
	AB.force = 1; AB.reload()
	var MD = AB.data().get("MECH", {})
	var N = 6
	var base = {}
	for m in AT.MECHS:
		if not MSW.has(m): continue
		var pl = AT.PLANS[m]; var nc = pl[0]; var co = pl[1]
		if not base.has(nc): base[nc] = AT._avg(nc, "", N)
		if not base.has(co): base[co] = AT._avg(co, "", N)
		var vs = MSW.get(m, [{}])
		var keep = MD[m].duplicate()
		for v in vs:
			for k in v: MD[m][k] = v[k]
			var a = AT._avg(nc, m, N); var b = AT._avg(co, m, N)
			_p("掃 %-4s %s：冇應對 ×%.2f 勝 %d/%d｜有應對 ×%.2f 勝 %d/%d" % [m, str(v), a.score / base[nc].score, a.win, N, b.score / base[co].score, b.win, N])
			for k in keep: MD[m][k] = keep[k]
			await t.get_tree().process_frame
	AB.force = -1
	_p("RESULT ok=1 bad=0")

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
	for u in sn.foes: _p("  foe %s hp%.0f atk%.0f minion=%s sum=%s foe_ml=%s mech=%s boss=%s" % [u.k, J.num(u.hp), J.num(u.atk), str(u.get("minion")), str(u.get("sum")), str(u.get("foe_ml")), str(u.get("mech")), str(u.get("boss"))])
	var t0 = Time.get_ticks_msec()
	var r = batch(sn, pool.slice(0, 3), pool[3], insts, 20)
	_p("DT0.05 20 場 %.2f 秒：%s" % [(Time.get_ticks_msec() - t0) / 1000.0, str(r)])
	DT = 0.1
	t0 = Time.get_ticks_msec()
	r = batch(sn, pool.slice(0, 3), pool[3], insts, 20)
	DT = 0.1
	_p("10 場 %.2f 秒：%s" % [(Time.get_ticks_msec() - t0) / 1000.0, str(r)])
	t0 = Time.get_ticks_msec()
	var sn2 = site_snap(sites[0])
	_p("snap 一個 %.3f 秒" % [(Time.get_ticks_msec() - t0) / 1000.0])
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func c0(t) -> void: await _boot(t); await run_ch(t, 0); _p("RESULT ok=%d bad=%d" % [ok, bad])
func c1(t) -> void: await _boot(t); await run_ch(t, 1); _p("RESULT ok=%d bad=%d" % [ok, bad])
func c2(t) -> void: await _boot(t); await run_ch(t, 2); _p("RESULT ok=%d bad=%d" % [ok, bad])
func c3(t) -> void: await _boot(t); await run_ch(t, 3); _p("RESULT ok=%d bad=%d" % [ok, bad])
func c4(t) -> void: await _boot(t); await run_ch(t, 4); _p("RESULT ok=%d bad=%d" % [ok, bad])
func c5(t) -> void: await _boot(t); await run_ch(t, 5); _p("RESULT ok=%d bad=%d" % [ok, bad])
func cal_a(t) -> void:
	await _boot(t); CAL = true
	for c in [0, 1, 4]: await run_ch(t, c)
	_p("RESULT ok=1 bad=0")
func cal_b(t) -> void:
	await _boot(t); CAL = true
	for c in [2, 3, 5]: await run_ch(t, c)
	_p("RESULT ok=1 bad=0")
func ca(t) -> void:
	await _boot(t)
	for c in [0, 1, 4]: await run_ch(t, c)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func cb(t) -> void:
	await _boot(t)
	for c in [2, 3, 5]: await run_ch(t, c)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
