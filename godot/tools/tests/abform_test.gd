# [abform] 陣型與戰鬥 AI 測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> abform res://tools/tests/abform_test.gd form|regress|all
#   form：同一批種子，舊陣型（AF.force=0）vs 新陣型（AF.force=1）對打 4 個場景，量：
#         陰兵小隊第一隊陣亡時間、戰死隊數；名鬼被 ≥3 近戰圍住嘅時間比率；陣線分散度（沿軸標準差）、同邊貼埋（<20px）對數；
#         另逐項驗：AoE 半徑 130、每隻目標最多 3 個近戰、前排名鬼企中間、護衛、自動施放 6 條件＋5 秒保底、敵人 AI、王開場 3 秒
#   regress：關咗（AF.force=0，或者存檔 ab_off=true）同改動前原裝 rts_sim（abform_ref_sim.gd）同種子結果一模一樣
#   （rts_test logic、mapbattle_test、sortie_test 用返佢哋自己嘅指令另外跑）
extends RefCounted

var ok := 0
var bad := 0
const SIM = preload("res://game/rts/rts_sim.gd")
const REF = preload("res://tools/tests/abform_ref_sim.gd")
const AF = preload("res://game/rts/abform.gd")
const N_SEED := 6
const DT := 1.0 / 30.0

func _p(m): print("[abform] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _boot(t) -> void:
	for i in 120:
		await _w(t, 0.5)
		var m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.0)
	var Bt = J.G.get("Battle")
	if Bt != null: Bt["auto"] = true

# ================= 單位（照 battle.gd 公式直接生，唔受存檔影響） =================
func mk_hero(k: String, lv: int) -> Dictionary:
	var g = J.G.GHOSTS[k]; var m = 1.0 + 0.06 * (lv - 1)
	var P = round(J.num(g.base[0]) * m); var A = round(J.num(g.base[2]) * m)
	var hp = 300 + P * 8 + A * 4
	var rg = str(g.get("range")) == "ranged"
	return {"side": 0.0, "k": k, "gid": "t_" + k, "name": str(g.name), "hp": hp, "maxhp": hp, "atk": 20 + A * 1.4, "range": 150.0 if rg else 46.0,
		"spd": 38.0 if rg else 46.0, "energy": 20.0, "sk": J.G.SKILLS.get(k), "st": {}, "cd": randf() * 0.5, "lv": float(lv)}
func mk_sq(lv: int) -> Dictionary:
	var hp = 90 + 14 * lv
	return {"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": hp, "maxhp": hp, "atk": 9 + 2.2 * lv, "range": 38.0, "spd": 52.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf()}
func mk_foe(e: String, p: float, boss := false) -> Dictionary:
	var T = J.G.ENEMY_T[e]; var hp = (260 + 90 * p) * J.num(T[0])
	return {"side": 1.0, "k": e, "name": str(T[2]), "hp": hp, "maxhp": hp, "atk": (16 + 7.5 * p) * J.num(T[1]), "range": 140.0 if e in ["zhiren", "penanggal"] else 46.0,
		"spd": 58.0 if e == "xiaogui" else 42.0, "energy": 30.0 if boss else 0.0, "sk": J.G.SKILLS.get(e), "st": {}, "cd": randf() * 0.6, "boss": boss}
# 場景：[名, 主公lv, 名鬼lv, 名鬼, 小隊數, 敵人, p, 王]
const SCN := [
	["A 早期 p3（4 隊）", 3, 6, ["afu", "n30_danxiao", "n30_maoshi"], 4, ["egui", "egui", "youhun", "egui", "youhun"], 3.0, ""],
	["B 中期 p7（8 隊）", 8, 20, ["afu", "laojiang", "n30_jiugui"], 8, ["zombie", "shuigui", "egui", "egui", "niutou", "pocong"], 7.0, ""],
	["C 王 AoE p9（8 隊＋遠程）", 10, 24, ["afu", "heiwu", "xiaozhi"], 8, ["pocong", "shuigui", "zombie", "egui", "mamian", "egui"], 9.0, "pocong"],
	["D 寬陣 p4（對面 9 隻）", 6, 14, ["afu", "laojiang", "n30_jiugui"], 2, ["egui", "zombie", "youhun", "egui", "zombie", "youhun", "egui", "shuigui", "youhun"], 4.0, ""],
]
func mk_units(sc: Array) -> Array:
	var o = []
	for k in sc[3]: o.append(mk_hero(k, int(sc[2])))
	for i in int(sc[4]): o.append(mk_sq(int(sc[1])))
	for e in sc[5]: o.append(mk_foe(e, float(sc[6]), e == sc[7]))
	return o
const PATH := [Vector2(0, 1500), Vector2(0, 800)]
const AT := Vector2(0, 640)
func new_op(units: Array, ref := false):
	var op = REF.new() if ref else SIM.new()
	op.setup(units, PackedVector2Array(PATH), AT, PATH[0])
	return op

# ================= 一場：量度 =================
func _attackers(op, h: Dictionary) -> int:
	var n = 0
	for v in op.units:
		if J.num(v.side) == 1 and op.alive(v) and J.num(v.range) <= 60 and op.dist(v, h) <= J.num(v.range) + 40.0:
			var a = v.get("anim"); var at = a.get("tg") if a is Dictionary else null
			if v.get("tg") == h or at == h: n += 1
	return n
func _spacing(op) -> Array:   # [沿軸標準差（近身前行）, 同邊貼埋 <20px 對數, 最大每目標近戰數, 可以守到上限嗎]
	var xs = []; var al = []
	for u in op.units:
		if J.num(u.side) == 0 and op.alive(u) and J.t(u.get("eng")): al.append(u)
	for u in al:
		if J.num(u.range) <= 60 and int(J.num(u.get("row", 0))) == 0: xs.append(op._axl(u.p))
	var sd = 0.0
	if xs.size() > 1:
		var mu = 0.0
		for x in xs: mu += x
		mu /= xs.size()
		for x in xs: sd += (x - mu) * (x - mu)
		sd = sqrt(sd / xs.size())
	var close = 0
	for i in al.size():
		for j in range(i + 1, al.size()):
			if op.dist(al[i], al[j]) < 20.0: close += 1
	var ld = {}; var mel = 0
	for u in al:
		if J.num(u.range) > 60: continue
		mel += 1
		var tg = u.get("tg")
		if tg is Dictionary and op.alive(tg) and op.dist(u, tg) <= J.num(u.range) + 30: ld[int(J.num(tg._id))] = int(ld.get(int(J.num(tg._id)), 0)) + 1
	var mx = 0
	for k in ld: mx = maxi(mx, ld[k])
	return [sd, close, mx, op.foes_alive() * AF.MEL_CAP >= mel]
func run(sc: Array, s: int, mode: int, ref := false) -> Dictionary:
	AF.force = mode
	seed(7000 + s * 131)
	var op = new_op(mk_units(sc), ref)
	var r = {"win": false, "t": 0.0, "dead": 0, "first": -1.0, "sur": 0.0, "hs": 0.0, "sd5": 0.0, "cl5": 0, "sd15": 0.0, "cl15": 0, "cap_bad": 0, "hp": []}
	var smp = [5.0, 15.0]
	var n = 0
	while op.result == null and n < 30 * 200:
		var was = op.phase == "fight"
		var t0 = op.t
		op.step(DT); n += 1
		if op.phase != "fight" and not (was and op.result != null): continue
		for u in op.units:
			if J.num(u.side) != 0: continue
			if J.t(u.get("minion")):
				if J.num(u.hp) <= 0 and r.first < 0: r.first = op.t
			elif op.alive(u):
				r.hs += DT
				if _attackers(op, u) >= 3: r.sur += DT
		for x in smp:
			if t0 < x and op.t >= x:
				var spc = _spacing(op)
				r["sd%d" % int(x)] = spc[0]; r["cl%d" % int(x)] = spc[1]
		if int(op.t / 0.5) != int(t0 / 0.5) and op.t > 3.0:
			var sp2 = _spacing(op)
			if sp2[3] and sp2[2] > AF.MEL_CAP: r.cap_bad += 1
	r.win = op.result != null and J.t(op.result.win); r.t = op.t
	for u in op.units:
		if J.num(u.side) == 0 and J.t(u.get("minion")) and J.num(u.hp) <= 0: r.dead += 1
		r.hp.append(snappedf(J.num(u.hp), 0.01))
	if r.first < 0: r.first = op.t   # 一隊都冇死：當捱到完場
	r["op"] = op
	AF.force = -1
	return r

# ================= form =================
func form(t) -> void:
	await _boot(t)
	await units_checks(t)
	await battle_checks(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
# 調校：每個變體 [前排威脅, 小隊威脅, 護衛比例, 小隊企後, 名鬼近戰上限]，同舊版對比
const VARS := [[60.0, 30.0, 0.35, 0.0, 3], [60.0, 30.0, 0.35, 0.0, 2], [120.0, 30.0, 0.45, 18.0, 2], [30.0, 30.0, 0.35, 0.0, 2], [0.0, 0.0, 0.45, 0.0, 2], [60.0, 30.0, 0.6, 18.0, 2], [200.0, 30.0, 0.45, 18.0, 3]]
func sweep(t) -> void:
	await _boot(t)
	for sc in SCN.slice(1):
		var line = []
		for vi in range(-1, VARS.size()):
			var R = {"win": 0, "dead": 0, "first": 0.0, "sur": 0.0, "hs": 0.0, "t": 0.0}
			if vi >= 0:
				var v = VARS[vi]; AF.T_FRONT = v[0]; AF.T_SQ = v[1]; AF.GUARD_PCT = v[2]; AF.SQ_BACK = v[3]; AF.MEL_CAP_HERO = v[4]
			for s in N_SEED:
				var r = run(sc, s, 0 if vi < 0 else 1)
				R.win += int(r.win); R.dead += r.dead; R.first += r.first; R.sur += r.sur; R.hs += r.hs; R.t += r.t
			line.append("%s 贏%d 死%.1f 首%.1f 圍%.0f%% %.0fs" % ["舊" if vi < 0 else str(VARS[vi]), R.win, R.dead / float(N_SEED), R.first / N_SEED, 100 * R.sur / maxf(0.01, R.hs), R.t / N_SEED])
			await t.get_tree().process_frame
		_p("== " + str(sc[0]))
		for x in line: _p("   " + x)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func regress(t) -> void:
	await _boot(t)
	await regress_checks(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func all(t) -> void:
	await _boot(t)
	await regress_checks(t)
	await units_checks(t)
	await battle_checks(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func battle_checks(t) -> void:
	var tot = {"o": [0, 0], "n": [0, 0]}
	for sc in SCN:
		var O = {"win": 0, "t": 0.0, "dead": 0, "first": 0.0, "sur": 0.0, "hs": 0.0, "sd5": 0.0, "cl5": 0.0, "sd15": 0.0, "cl15": 0.0, "cap_bad": 0}
		var Nw = O.duplicate()
		var t0 = Time.get_ticks_msec()
		for s in N_SEED:
			var a = run(sc, s, 0); var b = run(sc, s, 1)
			for k in O.keys():
				O[k] += float(a[k]) if not (a[k] is bool) else float(int(a[k]))
				Nw[k] += float(b[k]) if not (b[k] is bool) else float(int(b[k]))
			await t.get_tree().process_frame
		var N = float(N_SEED)
		var nsq = float(sc[4])
		_p("== %s（%d 種子，%.1f 秒）" % [sc[0], N_SEED, (Time.get_ticks_msec() - t0) / 1000.0])
		_p("   舊：贏 %d/%d｜交戰 %.1f 秒｜小隊戰死 %.2f/%d 隊｜第一隊陣亡 %.1f 秒｜名鬼被圍 %.1f%%｜分散度 5秒 %.1f px／15秒 %.1f px｜貼埋 %.1f／%.1f 對" % [
			O.win, N_SEED, O.t / N, O.dead / N, nsq, O.first / N, 100.0 * O.sur / maxf(0.01, O.hs), O.sd5 / N, O.sd15 / N, O.cl5 / N, O.cl15 / N])
		_p("   新：贏 %d/%d｜交戰 %.1f 秒｜小隊戰死 %.2f/%d 隊｜第一隊陣亡 %.1f 秒｜名鬼被圍 %.1f%%｜分散度 5秒 %.1f px／15秒 %.1f px｜貼埋 %.1f／%.1f 對｜超上限 %d 次" % [
			Nw.win, N_SEED, Nw.t / N, Nw.dead / N, nsq, Nw.first / N, 100.0 * Nw.sur / maxf(0.01, Nw.hs), Nw.sd5 / N, Nw.sd15 / N, Nw.cl5 / N, Nw.cl15 / N, Nw.cap_bad])
		var nm = str(sc[0]).substr(0, 1)
		_chk(nm + "：勝場唔少過舊版（±1）", Nw.win >= O.win - 1, [O.win, Nw.win])
		# 合格線（硬性）：小隊唔可以死得早過／多過舊版；名鬼被圍時間減半或者 ≤10%（D 係「對面多一倍、小隊死晒後名鬼必然被圍」嘅極端場：只要唔差過舊版 5 個百分點）
		var slack = 1.0 if nm == "D" else 0.2   # D 得 2 隊：名鬼近戰上限 2 → 多出嚟嘅敵人改打小隊，小隊早少少死、換名鬼唔被圍（勝場 1→3）
		_chk(nm + "：陰兵第一隊陣亡唔早過舊版（D 容許 1 秒；目標 ≥ 6 秒，見報告）", Nw.first >= O.first - slack * N, [snappedf(O.first / N, 0.1), snappedf(Nw.first / N, 0.1)])
		_chk(nm + "：陰兵戰死隊數唔多過舊版", Nw.dead <= O.dead, [O.dead / N, Nw.dead / N])
		var so = O.sur / maxf(0.01, O.hs); var sn = Nw.sur / maxf(0.01, Nw.hs)
		if nm == "D": _chk(nm + "：名鬼被 ≥3 近戰圍住時間唔差過舊版 5 個百分點", sn <= so + 0.05, ["%.1f%%" % (so * 100), "%.1f%%" % (sn * 100)])
		else: _chk(nm + "：名鬼被 ≥3 近戰圍住時間 −50%（或者 ≤ 10%）", sn <= so * 0.5 or sn <= 0.10, ["%.1f%%" % (so * 100), "%.1f%%" % (sn * 100)])
		_chk(nm + "：陣線分散度（沿軸標準差）5／15 秒 < 35px", Nw.sd5 / N < 35.0 and Nw.sd15 / N < 35.0, [snappedf(Nw.sd5 / N, 0.1), snappedf(Nw.sd15 / N, 0.1)])
		_chk(nm + "：同邊貼埋（<20px）平均 ≤ 2 對", Nw.cl5 / N <= 2.0 and Nw.cl15 / N <= 2.0, [Nw.cl5 / N, Nw.cl15 / N])
		_chk(nm + "：每隻目標最多 3 個近戰（敵人夠多時）", Nw.cap_bad == 0, Nw.cap_bad)
		tot.o[0] += O.dead; tot.n[0] += Nw.dead
	_p("合計小隊戰死：舊 %d → 新 %d" % [tot.o[0], tot.n[0]])

# ================= 逐項 =================
func _to_fight(op) -> void:
	var n = 0
	while op.phase == "march" and n < 30 * 60: op.step(DT); n += 1
func units_checks(t) -> void:
	AF.force = 1
	# 1) 陣型次序：前排名鬼企中間三分一，兩頭係小隊
	seed(11)
	var sc = SCN[1]
	var op = new_op(mk_units(sc))
	_to_fight(op)
	_chk("接觸開打", op.phase == "fight", op.phase)
	var ls = []; var hl = []
	for u in op.units:
		if J.num(u.side) == 0 and J.num(u.range) <= 60: ls.append(float(u.ls))
		if J.num(u.side) == 0 and not J.t(u.get("minion")) and J.num(u.range) <= 60: hl.append(float(u.ls))
	ls.sort()
	var lo = ls[0]; var hi = ls[ls.size() - 1]; var w = hi - lo
	var mid = true
	for x in hl: if x < lo + w / 3.0 - 1.0 or x > hi - w / 3.0 + 1.0: mid = false
	_chk("前排名鬼企陣線中間三分一（唔再企兩頭）", mid, [hl, lo, hi])
	var ends = []
	for u in op.units: if J.num(u.side) == 0 and J.num(u.range) <= 60 and (float(u.ls) == lo or float(u.ls) == hi): ends.append(J.t(u.get("minion")))
	_chk("陣線兩頭係陰兵小隊", ends.size() == 2 and ends[0] and ends[1], ends)
	var r0 = true
	for u in op.units: if J.num(u.side) == 0 and not J.t(u.get("minion")) and J.num(u.range) <= 60 and int(J.num(u.get("row", 0))) != 0: r0 = false
	_chk("壓成兩行時前排名鬼一定喺前行", r0)
	# 行軍展開都係同一次序（接觸前後唔會交叉）
	seed(11)
	var op2 = new_op(mk_units(sc))
	var dl_h = []; var dl_all = []
	for u in op2.units:
		if J.num(u.side) == 0 and J.num(u.range) <= 60 and u.has("dl"):
			dl_all.append(float(u.dl))
			if not J.t(u.get("minion")): dl_h.append(float(u.dl))
	dl_all.sort()
	var wd = dl_all[dl_all.size() - 1] - dl_all[0]
	var mid2 = true
	for x in dl_h: if absf(x - (dl_all[0] + wd / 2.0)) > wd / 3.0 + 1.0: mid2 = false
	_chk("行軍展開橫隊：名鬼都喺中間（同接觸排法一致）", mid2, dl_h)
	# 2) AoE 半徑 130
	seed(12)
	var us = [mk_hero("afu", 10)]
	for i in 6: us.append(mk_sq(5))
	var boss = mk_foe("huang", 6.0, true)
	us.append(boss)
	var op3 = new_op(us)
	_to_fight(op3)
	var sqs = op3.units.filter(func(x): return J.t(x.get("minion")))
	for i in sqs.size():
		sqs[i]["p"] = (boss.p as Vector2) + Vector2(-60 + 40 * i, 50) if i < 3 else (boss.p as Vector2) + Vector2(-400 - 60 * i, 380)
	op3.units[0]["p"] = (boss.p as Vector2) + Vector2(500, 500)
	var hp0 = []
	for u in sqs: hp0.append(J.num(u.hp))
	op3.do_skill(boss, boss.sk)
	var hitn = 0; var far_hit = 0
	for i in sqs.size():
		if J.num(sqs[i].hp) < hp0[i]:
			hitn += 1
			if i >= 3: far_hit += 1
	_chk("AoE 半徑 130：圈內 3 隊中招、圈外 3 隊冇事（唔再打全場）", hitn == 3 and far_hit == 0, [hitn, far_hit])
	AF.force = 0
	seed(12)
	var us0 = [mk_hero("afu", 10)]
	for i in 6: us0.append(mk_sq(5))
	var boss0 = mk_foe("huang", 6.0, true); us0.append(boss0)
	var op4 = new_op(us0); _to_fight(op4)
	var sq0 = op4.units.filter(func(x): return J.t(x.get("minion")))
	for i in sq0.size(): sq0[i]["p"] = (boss0.p as Vector2) + (Vector2(-60 + 40 * i, 50) if i < 3 else Vector2(-400 - 60 * i, 380))
	var h0 = []
	for u in sq0: h0.append(J.num(u.hp))
	op4.do_skill(boss0, boss0.sk)
	var hn0 = 0
	for i in sq0.size(): if J.num(sq0[i].hp) < h0[i]: hn0 += 1
	_chk("對照：舊版 AoE 打全場（6 隊全中）", hn0 == 6, hn0)
	AF.force = 1
	# 3) 威脅值：敵人揀前排名鬼多過小隊、後排名鬼最少
	seed(13)
	var op5 = new_op(mk_units(SCN[2])); _to_fight(op5)
	var e = null
	for u in op5.units: if J.num(u.side) == 1: e = u; break
	var hf = null; var hb = null; var sq1 = null
	for u in op5.units:
		if J.num(u.side) != 0: continue
		if J.t(u.get("minion")): sq1 = u
		elif AF.role_of(u) == "back": hb = u
		elif hf == null: hf = u
	_chk("威脅值：前排 %d > 小隊 %d > 後排 %d" % [AF.threat(hf), AF.threat(sq1), AF.threat(hb)], AF.threat(hf) > AF.threat(sq1) and AF.threat(sq1) > AF.threat(hb))
	# 同一橫位：敵人揀前排名鬼唔揀小隊；嘲諷一定揀
	for u in op5.units: if J.num(u.side) == 0: u["p"] = Vector2(5000, 5000)
	hf["p"] = (e.p as Vector2) + op5.ax * -80.0 + op5.perp * 20.0
	sq1["p"] = (e.p as Vector2) + op5.ax * -80.0 - op5.perp * 20.0
	e["tg"] = null; e["ls"] = op5._lat(e.p)
	var pk = op5._line_tg(e)
	_chk("同樣距離：敵人揀前排名鬼（唔再專打小隊）", pk == hf, pk.get("name") if pk is Dictionary else null)
	sq1.st["taunt"] = 2.0; e["tg"] = null
	pk = op5._line_tg(e)
	_chk("嘲諷（st.taunt）：敵人一定揀佢", pk == sq1)
	sq1.st.erase("taunt")
	# 4) 每隻目標最多 3 個近戰
	seed(14)
	var us6 = [mk_hero("afu", 10)]
	for i in 6: us6.append(mk_sq(5))
	us6.append(mk_foe("egui", 3.0)); us6.append(mk_foe("egui", 3.0))
	var op6 = new_op(us6); _to_fight(op6)
	var cnt = {}
	for k in 40:
		op6.step(DT)
	for u in op6.units:
		if J.num(u.side) == 0 and op6.alive(u) and u.get("tg") is Dictionary: var key = int(J.num(u.tg._id)); cnt[key] = int(cnt.get(key, 0)) + 1
	var mx = 0
	for k in cnt: mx = maxi(mx, cnt[k])
	var mn = 99
	for k in cnt: mn = mini(mn, cnt[k])
	_chk("7 個近戰打 2 隻：平均分開（最多 4、兩邊差 ≤ 1；舊版會全部圍一隻）", op6.foes_alive() < 2 or (mx <= 4 and mx - mn <= 1 and cnt.size() == 2), cnt)
	# 5) 前排護衛
	seed(15)
	var op7 = new_op(mk_units(SCN[1])); _to_fight(op7)
	op7.step(DT)
	var fr = null; var sq7 = null
	for u in op7.units:
		if J.num(u.side) == 0 and not J.t(u.get("minion")) and AF.role_of(u) == "front" and fr == null: fr = u
	for u in op7.units:
		if J.num(u.side) == 0 and J.t(u.get("minion")) and op7.alive(u): sq7 = u; break
	for u in op7.units: if J.num(u.side) == 0 and u != fr and u != sq7: u["p"] = (fr.p as Vector2) + Vector2(0, 900)   # 其他人企遠啲
	sq7["p"] = (fr.p as Vector2) + Vector2(30, 0)
	fr["gbud"] = 1000.0
	var fh = J.num(fr.hp); var sh = J.num(sq7.hp)
	sq7["af_ph"] = sh; sq7["hp"] = sh - 40.0
	AF.guard_tick(op7, 0.0)
	var gs = 40.0 * AF.GUARD_PCT
	_chk("護衛：身邊小隊食 40 → 名鬼分擔 %d%%（%.0f）" % [int(AF.GUARD_PCT * 100), gs], absf(J.num(sq7.hp) - (sh - 40.0 + gs)) < 0.6 and absf(fh - J.num(fr.hp) - gs) < 0.6, [J.num(sq7.hp) - sh, fh - J.num(fr.hp)])
	sq7["p"] = (fr.p as Vector2) + Vector2(200, 0)
	sh = J.num(sq7.hp); sq7["af_ph"] = sh; sq7["hp"] = sh - 40.0; fh = J.num(fr.hp)
	AF.guard_tick(op7, 0.0)
	_chk("護衛：離遠（>70px）唔擋", absf(J.num(sq7.hp) - (sh - 40.0)) < 0.01 and absf(fh - J.num(fr.hp)) < 0.01)
	fr["gbud"] = 0.0; sq7["p"] = (fr.p as Vector2) + Vector2(30, 0)
	sh = J.num(sq7.hp); sq7["af_ph"] = sh; sq7["hp"] = sh - 40.0
	AF.guard_tick(op7, 1.0 / 30.0)
	_chk("護衛：每秒上限 6% maxhp", sh - J.num(sq7.hp) >= 40.0 - J.num(fr.maxhp) * AF.GUARD_CAP / 30.0 - 0.6, sh - J.num(sq7.hp))
	# 6) 自動施放 AI
	await ai_checks(t)
	AF.force = -1

func _ai_op():
	seed(16)
	var us = [mk_hero("afu", 10), mk_hero("mengpo", 10), mk_hero("xiaozhi", 10), mk_hero("eguiking", 10), mk_hero("toyol", 10)]
	for i in 2: us.append(mk_sq(5))
	us.append(mk_foe("huang", 5.0, true)); us.append(mk_foe("egui", 5.0)); us.append(mk_foe("heiwu", 5.0))
	var op = new_op(us); _to_fight(op)
	op.auto = true
	for u in op.units: u["full_t"] = 0.0
	return op
func _u(op, k: String, side := 0) -> Dictionary:
	for u in op.units: if str(u.k) == k and int(J.num(u.side)) == side: return u
	return {}
func ai_checks(t) -> void:
	var op = _ai_op()
	var afu = _u(op, "afu"); var mp = _u(op, "mengpo"); var xz = _u(op, "xiaozhi"); var eg = _u(op, "eguiking"); var ty = _u(op, "toyol")
	var hu = _u(op, "huang", 1); var eg1 = _u(op, "egui", 1); var hw = _u(op, "heiwu", 1)
	_chk("AI 由舊技能推：單體 asap、治療 ally_hp、群攻 n_in、吸血 self_hp、抽嚇氣 foe_cast", AF.ai_of(afu).when == "asap" and AF.ai_of(mp).when == "ally_hp" and AF.ai_of(xz).when == "n_in" and AF.ai_of(eg).when == "self_hp" and AF.ai_of(ty).when == "foe_cast",
		[AF.ai_of(afu).when, AF.ai_of(mp).when, AF.ai_of(xz).when, AF.ai_of(eg).when, AF.ai_of(ty).when])
	for u in op.units: u["energy"] = 100.0
	# asap：目標入射程先放
	for v in op.units: if J.num(v.side) == 1: v["p"] = (afu.p as Vector2) + Vector2(0, -400)
	_chk("asap：最近敵人太遠 → 唔放", not AF.want_cast(op, afu, DT))
	eg1["p"] = (afu.p as Vector2) + Vector2(0, -40)
	_chk("asap：敵人入射程 → 即放", AF.want_cast(op, afu, DT))
	# ally_hp
	for v in op.units: if J.num(v.side) == 0: v["hp"] = J.num(v.maxhp)
	mp["full_t"] = 0.0
	_chk("ally_hp：全隊滿血 → 唔放治療", not AF.want_cast(op, mp, DT))
	var sq = null
	for v in op.units: if J.t(v.get("minion")): sq = v; break
	sq["hp"] = J.num(sq.maxhp) * 0.4
	_chk("ally_hp：陰兵小隊 < 50% → 放", AF.want_cast(op, mp, DT))
	sq["hp"] = J.num(sq.maxhp)
	# 5 秒保底
	mp["full_t"] = 0.0
	var fired_at = -1.0
	for i in 200:
		if AF.want_cast(op, mp, 0.05): fired_at = (i + 1) * 0.05; break
	_chk("保底：條件一直唔成立，滿咗 5 秒照放（唔會儲住唔用）", fired_at >= 4.95 and fired_at <= 5.1, fired_at)
	# n_in
	for v in op.units: if J.num(v.side) == 1: v["p"] = (xz.p as Vector2) + Vector2(0, -150)
	xz["full_t"] = 0.0
	hu["p"] = (xz.p as Vector2) + Vector2(0, -150); eg1["p"] = (xz.p as Vector2) + Vector2(400, -150); hw["p"] = (xz.p as Vector2) + Vector2(-400, -150)
	_chk("n_in：圈內得 1 隻（場上 3 隻）→ 唔放群攻", not AF.want_cast(op, xz, DT))
	eg1["p"] = (hu.p as Vector2) + Vector2(60, 0); hw["p"] = (hu.p as Vector2) + Vector2(-60, 20)
	_chk("n_in：3 隻聚埋（130 內）→ 放", AF.want_cast(op, xz, DT))
	# self_hp
	eg["full_t"] = 0.0; eg["hp"] = J.num(eg.maxhp)
	_chk("self_hp：自己血多 → 唔放吸血技", not AF.want_cast(op, eg, DT))
	eg["hp"] = J.num(eg.maxhp) * 0.3
	_chk("self_hp：自己低血 → 放", AF.want_cast(op, eg, DT))
	# foe_cast
	ty["full_t"] = 0.0
	hu["p"] = (ty.p as Vector2) + Vector2(0, -120)
	_chk("foe_cast：冇敵人讀條 → 唔放抽嚇氣", not AF.want_cast(op, ty, DT))
	hu["casting"] = {"t": 0.0, "dur": 0.45}
	_chk("foe_cast：附近敵人讀緊條 → 放（打斷）", AF.want_cast(op, ty, DT))
	hu["casting"] = null
	# tg_mech
	afu["ai_"] = {"when": "tg_mech", "tg_mech": "summon", "wait": 5.0}; afu["full_t"] = 0.0
	_chk("tg_mech：場上冇召喚者 → 唔放", not AF.want_cast(op, afu, DT))
	hw["mech"] = ["summon"]
	_chk("tg_mech：見到召喚者 → 放", AF.want_cast(op, afu, DT))
	# 手動：自動掣關 → 我方唔自動放；S.ab_auto 逐隻開
	op.auto = false; afu.erase("ai_"); afu["full_t"] = 0.0
	eg1["p"] = (afu.p as Vector2) + Vector2(0, -40)
	_chk("自動掣關：我方名鬼唔會自己放", not AF.want_cast(op, afu, DT))
	var S = J.G.S; var had = S.get("ab_auto")
	S["ab_auto"] = {str(afu.gid): true}
	_chk("S.ab_auto[gid]＝true：呢隻照自動放", AF.want_cast(op, afu, DT))
	if had == null: S.erase("ab_auto")
	else: S["ab_auto"] = had
	# 敵人 AI：AoE 要 ≥2 隻入圈；王開場 3 秒先放
	op.t = 1.0; hu["full_t"] = 0.0
	for v in op.units: if J.num(v.side) == 0: v["p"] = (hu.p as Vector2) + Vector2(0, 60)
	_chk("敵人王：接觸後 3 秒內唔放技", not AF.want_cast(op, hu, DT))
	op.t = 4.0
	_chk("敵人王：3 秒後、我方聚埋 → 放", AF.want_cast(op, hu, DT))
	hw["full_t"] = 0.0
	var k = 0
	for v in op.units: if J.num(v.side) == 0: v["p"] = (hw.p as Vector2) + Vector2(-500 + 260 * k, 300); k += 1
	_chk("敵人 AoE：我方散開（圈內 < 2）→ 唔放", not AF.want_cast(op, hw, DT))
	var q = 0
	for v in op.units:
		if J.num(v.side) == 0 and q < 2: v["p"] = (hw.p as Vector2) + Vector2(20 * q, 50); q += 1
	_chk("敵人 AoE：2 隻入圈 → 放", AF.want_cast(op, hw, DT))
	# 整場跑：自動模式下名鬼真係會放技（唔會因為條件卡死）
	var op2 = _ai_op()
	var casts = 0; var n = 0
	while op2.result == null and n < 30 * 90:
		op2.step(DT); n += 1
		for ev in op2.events: if ev[0] == "skill" and J.num(ev[1].side) == 0: casts += 1
		op2.events.clear()
	_chk("整場自動：我方名鬼有放技（%d 次）" % casts, casts >= 3, casts)

# ================= regress =================
func regress_checks(t) -> void:
	var same = true; var n = 0
	for sc in SCN:
		for s in 3:
			var a = run(sc, s, 0, true)   # 改動前原裝
			var b = run(sc, s, 0)         # 新檔、AF 關
			n += 1
			if str([a.win, snappedf(a.t, 0.001), a.dead, a.hp]) != str([b.win, snappedf(b.t, 0.001), b.dead, b.hp]):
				same = false; _p("差異 %s #%d 舊 %s 新 %s" % [sc[0], s, str([a.win, a.t, a.dead]), str([b.win, b.t, b.dead])])
		await t.get_tree().process_frame
	_chk("AF 關（force=0）：%d 場同改動前 rts_sim 一模一樣（勝負、時間、每隻血）" % n, same)
	# 總開關（全域 static，唔入存檔）：用 stub 模擬 abil.gd 嘅 OFF
	var keys0 = (J.G.S as Dictionary).keys().size()
	var STUB = load("res://tools/tests/abform_abstub.gd")
	var op0 = AF.AB_PATH
	AF.AB_PATH = "res://tools/tests/abform_abstub.gd"
	STUB.OFF = true
	var a2 = run(SCN[1], 5, 0, true); var b2 = run(SCN[1], 5, -1)
	_chk("總開關 OFF＝true：一鍵退回舊路（同原裝一樣）", str(a2.hp) == str(b2.hp) and a2.t == b2.t, [a2.t, b2.t])
	STUB.OFF = false
	var c2 = run(SCN[1], 5, -1)
	_chk("總開關 OFF＝false：行新陣型（結果唔同舊）", str(c2.hp) != str(a2.hp))
	AF.AB_PATH = op0
	_chk("開關唔寫入玩家存檔", (J.G.S as Dictionary).keys().size() == keys0 and not (J.G.S as Dictionary).has("ab_off"))
