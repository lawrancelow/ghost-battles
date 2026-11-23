# [abcore] 能力引擎測試（ability.md 第 7 節）
# 用法：edtest.sh <godot> <tag> res://tools/tests/abil_test.gd prim|mech|all
#   prim：40 個積木逐個最細場景（狀態真係變）＋舊 SKILLS 自動轉換＋兩層克制倍率＋封頂＋合體技＋ab_off 回舊路
#   mech：13 種機制 ×「冇應對隊」／「有應對隊」×（有機制／冇機制）× N 種子；難度倍數＝(時間×(1+我方失血比)) ÷ 同隊打冇機制
extends RefCounted

const SIM = preload("res://game/rts/rts_sim.gd")
const AB = preload("res://game/rts/abil.gd")
var ok := 0
var bad := 0
func _p(m): print("[abil] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _boot(t) -> void:
	for i in 120:
		await t.get_tree().create_timer(0.5).timeout
		if J.G.get("S") is Dictionary and J.G.get("Rework") != null and J.G.get("SKILLS") is Dictionary: break
	await t.get_tree().create_timer(1.0).timeout

# ---------------- 單位／場地 ----------------
func mk(k: String, side: int, hp := 2000.0, atk := 60.0, rng := 46.0, sk = null, minion := false) -> Dictionary:
	return {"side": float(side), "k": k, "name": k, "hp": hp, "maxhp": hp, "atk": atk, "range": rng, "spd": 38.0 if rng > 60 else 46.0, "energy": 0.0,
		"sk": sk, "st": {}, "cd": randf() * 0.5, "boss": false, "minion": minion}
const PATH := [Vector2(0, 900), Vector2(0, 300)]
func arena(units: Array) -> Object:
	var op = SIM.new()
	op.setup(units, PackedVector2Array(PATH), Vector2(0, 220), Vector2(0, 900))
	return op
# 直接擺好陣（唔行軍）：我方 y=300、敵方 y=240
func placed(ours: Array, foes: Array) -> Object:
	var op = arena(ours + foes)
	op.phase = "fight"; op.t = 0.0
	for i in ours.size():
		var u = ours[i]; u["p"] = Vector2((i - (ours.size() - 1) * 0.5) * 40.0, 300.0); u["out"] = true; u["eng"] = true
	for i in foes.size():
		var u = foes[i]; u["p"] = Vector2((i - (foes.size() - 1) * 0.5) * 40.0, 240.0); u["post"] = u.p
	op._form()
	for u in op.units: u["cd"] = 1e9   # 唔自己出手（隔離積木）
	return op
func steps(op, secs: float, quiet := true) -> void:
	for i in int(secs * 20):
		if quiet: for u in op.units: u["cd"] = 1e9
		op.step(0.05)
func P(op, u, fx: Dictionary, tgs: Array) -> void:
	var ts = []
	for v in tgs: ts.append([v, 1.0])
	AB.prim(op, u, fx, ts, {"sk": true, "kind": "hit"})
func H(op, src, v, mult := 1.0, c = null, sd := 7) -> float:   # 固定亂數嘅一下
	seed(sd)
	var h0 = J.num(v.hp)
	AB.hit(op, src, v, mult, c)
	return h0 - J.num(v.hp)
const SKH := {"name": "測試擊", "kind": "hit", "mult": 1.5}
const N_K := "n30_jiugui"     # 魂系、吹氣
const F_K := "zd_hengsi"      # 橫系、電話：吹氣中性；電話對魂中性

# ================= prim =================
func prim(t) -> void:
	await _boot(t)
	AB.force = 1; AB.reload()
	var B = J.G.get("Battle"); var auto0 = B.get("auto") if B is Dictionary else false
	if B is Dictionary: B["auto"] = false
	await _prims()
	_legacy()
	_layers()
	_combo()
	_off()
	if B is Dictionary: B["auto"] = auto0
	AB.force = -1
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func all(t) -> void:
	await prim(t)
	ok = 0; bad = 0
	await mech(t)

func _fresh(nf := 2, nh := 1) -> Array:
	var hs = []; var fs = []
	for i in nh: hs.append(mk(N_K, 0, 2000, 60, 46, SKH.duplicate()))
	for i in nf: fs.append(mk(F_K, 1, 3000, 40))
	var op = placed(hs, fs)
	for x in hs: x.ab.tags = []
	return [op, hs, fs]
func _prims() -> void:
	var r; var op; var h; var f; var d0; var d1
	var seen = {}
	# 1 dmg
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	d0 = J.num(f.hp); P(op, h, {"p": "dmg", "mult": 2.0, "hits": 2}, [f]); seen["dmg"] = 1
	_chk("積木 dmg：多段傷害扣血", J.num(f.hp) < d0 - 100, d0 - J.num(f.hp))
	# 2 dot
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, h, {"p": "dot", "dps": 0.5, "dur": 3.0}, [f]); d0 = J.num(f.hp); steps(op, 2.0); seen["dot"] = 1
	_chk("積木 dot：持續扣血", J.num(f.hp) < d0 - 40, d0 - J.num(f.hp))
	# 3 execute
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]; var f2 = r[2][1]
	f.hp = 500.0; f2.hp = 2000.0
	d0 = J.num(f.hp); P(op, h, {"p": "execute", "hp_pct": 0.25, "x": 3.0}, [f, f2]); seen["execute"] = 1
	_chk("積木 execute：低血目標 ×3、高血目標唔郁", J.num(f.hp) < d0 - 120 and J.num(f2.hp) == 2000.0, [d0 - J.num(f.hp), f2.hp])
	# 4 chain
	r = _fresh(3); op = r[0]; h = r[1][0]
	AB.prim(op, h, {"p": "chain", "n": 3, "mult": 1.0, "falloff": 0.8, "r": 200}, [], {"sk": true}); seen["chain"] = 1
	var nh = 0
	for v in r[2]: if J.num(v.hp) < 3000: nh += 1
	_chk("積木 chain：彈射 3 個目標", nh == 3, nh)
	# 5 splash
	r = _fresh(3); op = r[0]; h = r[1][0]
	P(op, h, {"p": "splash", "r": 80, "pct": 0.5}, [h]); AB.hit(op, h, r[2][1], 1.0, null); seen["splash"] = 1
	_chk("積木 splash：普攻濺射隔籬", J.num(r[2][0].hp) < 3000 and J.num(r[2][2].hp) < 3000, [r[2][0].hp, r[2][2].hp])
	# 6 mark
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	d0 = H(op, h, f); P(op, h, {"p": "mark", "v": 0.25, "dur": 5}, [f]); d1 = H(op, h, f); seen["mark"] = 1
	_chk("積木 mark：易傷 +25%", d1 > d0 * 1.2, [d0, d1])
	# 7 pierce（對殼）
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f.ab.mech = ["殼"]; f.ab["shell"] = 1000.0; f.ab["shell0"] = 1000.0
	H(op, h, f); var s0 = 1000.0 - J.num(f.ab.shell)
	P(op, h, {"p": "pierce", "v": 1.0}, [h]); f.ab["shell"] = 1000.0; H(op, h, f); var s1 = 1000.0 - J.num(f.ab.shell); seen["pierce"] = 1
	_chk("積木 pierce：普攻對殼 ×2", s1 > s0 * 1.8, [s0, s1])
	# 8–12 控場
	for p in ["down", "air", "push", "pull", "stun"]:
		r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
		var p0: Vector2 = f.p
		P(op, h, {"p": p}, [f]); seen[p] = 1
		var okc = false
		match p:
			"down": okc = J.num(f.st.get("down", 0)) > 0
			"air": okc = J.num(f.st.get("air", 0)) > 0
			"push", "pull":
				steps(op, 0.4)
				var dd = (f.p as Vector2).distance_to(h.p) - p0.distance_to(h.p)
				okc = dd > 10 if p == "push" else dd < -10
			"stun":
				okc = AB.tick_unit(op, f, 0.05)
		_chk("積木 %s：狀態生效" % p, okc, [f.st, f.p])
	# 霸體擋控場、「破」無視霸體
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f.ab.mech = ["霸體"]; P(op, h, {"p": "down"}, [f]); var blk = J.num(f.st.get("down", 0)) <= 0
	h.ab.tags = ["破"]; P(op, h, {"p": "down"}, [f])
	_chk("霸體：腳軟無效；「破」照中", blk and J.num(f.st.get("down", 0)) > 0)
	# 13 silence
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f["casting"] = {"t": 0.0, "dur": 0.45}; P(op, h, {"p": "silence", "dur": 3}, [f]); seen["silence"] = 1
	_chk("積木 silence：打斷＋唔加嚇氣", f.get("casting") == null and AB.emul(op, f) == 0.0)
	# 14 interrupt
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f["casting"] = {"t": 0.0, "dur": 0.45}; f["energy"] = 80.0; P(op, h, {"p": "interrupt"}, [f]); seen["interrupt"] = 1
	_chk("積木 interrupt：讀條清走、嚇氣 −50、定身 1 秒", f.get("casting") == null and J.num(f.energy) == 30.0 and AB.tick_unit(op, f, 0.05))
	# 15 slow
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, h, {"p": "slow", "v": 0.4, "dur": 3}, [f]); AB.tick_unit(op, f, 0.05); seen["slow"] = 1
	_chk("積木 slow：移動 −40%", absf(J.num(f.spd) - 42.0 * 0.6) < 0.5 or absf(J.num(f.spd) - 46.0 * 0.6) < 0.5, f.spd)
	# 16 flee
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	var pf: Vector2 = f.p
	P(op, h, {"p": "flee", "dur": 2}, [f]); for i in 10: AB.tick_unit(op, f, 0.05)
	seen["flee"] = 1
	_chk("積木 flee：背向走", (f.p as Vector2).distance_to(h.p) > pf.distance_to(h.p) + 10)
	# 17 taunt
	r = _fresh(2, 2); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, r[1][1], {"p": "taunt", "r": 300, "dur": 3}, [r[1][1]]); seen["taunt"] = 1
	_chk("積木 taunt：敵人目標鎖定嘲諷者", AB.pick_fix(op, f, h) == r[1][1])
	# 18 heal / 19 hot
	r = _fresh(); op = r[0]; h = r[1][0]
	h.hp = 1000.0; P(op, h, {"p": "heal", "pct": 0.2}, [h]); seen["heal"] = 1
	_chk("積木 heal：回 20%", absf(J.num(h.hp) - 1400.0) < 1)
	h.hp = 1000.0; P(op, h, {"p": "hot", "pct": 0.05, "dur": 4}, [h]); steps(op, 2.0); seen["hot"] = 1
	_chk("積木 hot：持續回血", J.num(h.hp) >= 1140, h.hp)
	# 20 shield
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, h, {"p": "shield", "pct": 0.1, "dur": 6}, [h]); var hp0 = J.num(h.hp); AB.hit(op, f, h, 1.0, null); seen["shield"] = 1
	_chk("積木 shield：盾先食傷害", J.num(h.hp) == hp0 and J.num(h.ab.shd) < 200, h.ab.shd)
	# 21 drain
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	h.hp = 1000.0; P(op, h, {"p": "dmg", "mult": 2.0, "drain": 0.5}, [f]); seen["drain"] = 1
	_chk("積木 drain：吸血", J.num(h.hp) > 1030, h.hp)
	# 22 guard
	var sq = mk("youhun", 0, 600, 20, 38, null, true)
	r = [placed([mk(N_K, 0, 2000, 60, 46, SKH.duplicate()), sq], [mk(F_K, 1, 3000, 60)])]; op = r[0]
	h = op.units[0]; f = op.units[2]
	P(op, h, {"p": "guard", "r": 120, "pct": 0.5}, [h]); var hh = J.num(h.hp); var sq0 = J.num(sq.hp); AB.hit(op, f, sq, 1.0, null); seen["guard"] = 1
	_chk("積木 guard：陰兵受傷一半轉去名鬼", J.num(h.hp) < hh and sq0 - J.num(sq.hp) > 0 and absf((hh - J.num(h.hp)) - (sq0 - J.num(sq.hp))) < 2, [hh - J.num(h.hp), sq0 - J.num(sq.hp)])
	# 23 immune
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, f, {"p": "immune", "tags": ["down"], "dur": 4}, [f]); P(op, h, {"p": "down"}, [f]); seen["immune"] = 1
	_chk("積木 immune：免疫腳軟", J.num(f.st.get("down", 0)) <= 0)
	# 24 cleanse
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, f, {"p": "slow", "v": 0.4, "dur": 5}, [h]); P(op, f, {"p": "mark", "v": 0.2, "dur": 5}, [h]); P(op, h, {"p": "cleanse"}, [h]); seen["cleanse"] = 1
	_chk("積木 cleanse：清走負面", not AB.has_bf(op, h, "slow") and not AB.has_bf(op, h, "mark"))
	# 25 revive
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, f, {"p": "revive", "pct": 0.4}, [f]); AB.raw(op, f, 99999, h); var pend = AB.pending(op, 1); steps(op, 2.0); seen["revive"] = 1
	_chk("積木 revive：倒下 1.5 秒返生 40%", pend == 1 and absf(J.num(f.hp) - 1200.0) < 1, [pend, f.hp])
	# 26 buff
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	d0 = H(op, h, f); P(op, h, {"p": "buff", "stat": "atk", "v": 0.3, "dur": 5}, [h]); d1 = H(op, h, f); seen["buff"] = 1
	_chk("積木 buff：攻 +30%", d1 > d0 * 1.25, [d0, d1])
	# 27 energy
	r = _fresh(); op = r[0]; h = r[1][0]
	P(op, h, {"p": "energy", "v": 40}, [h]); seen["energy"] = 1
	_chk("積木 energy：回嚇氣", J.num(h.energy) >= 40)
	# 28 anti_air（飛）
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f.ab.mech = ["飛"]; f.ab["fly"] = true
	d0 = H(op, h, f); P(op, h, {"p": "anti_air", "x": 1.25}, [h]); d1 = H(op, h, f); seen["anti_air"] = 1
	_chk("飛：近戰 ×0.3；積木 anti_air 對空 ×1.25（相對 ×4.2）", d1 > d0 * 3.8, [d0, d1])
	# 29 reveal
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f.ab.mech = ["隱"]; f.ab["st_on"] = true; h.p = Vector2(0, 500)
	var hid = not AB.targetable(op, h, f)
	P(op, h, {"p": "reveal", "r": 150, "dur": 8}, [f]); seen["reveal"] = 1
	_chk("隱：遠處揀唔到；積木 reveal 現形", hid and AB.targetable(op, h, f))
	# 30 armor_break / 31 shield_break
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f.ab.mech = ["殼"]; f.ab["shell"] = 1000.0; f.ab["shell0"] = 1000.0
	H(op, h, f); s0 = 1000.0 - J.num(f.ab.shell)
	P(op, h, {"p": "armor_break", "v": 1.0, "dur": 6}, [f]); f.ab["shell"] = 1000.0; H(op, h, f); s1 = 1000.0 - J.num(f.ab.shell); seen["armor_break"] = 1
	_chk("積木 armor_break：對殼 ×2", s1 > s0 * 1.8, [s0, s1])
	f.ab["shd"] = 300.0; f.ab["shd_until"] = 99.0; f.ab["shell"] = 1000.0
	P(op, h, {"p": "shield_break", "pct": 0.5}, [f]); seen["shield_break"] = 1
	_chk("積木 shield_break：清盾、殼 −50%", J.num(f.ab.shd) == 0.0 and J.num(f.ab.shell) <= 500.0, [f.ab.shd, f.ab.shell])
	# 32 dispel
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, f, {"p": "buff", "stat": "atk", "v": 0.5, "dur": 9}, [f]); f.ab.mech = ["再生"]
	P(op, h, {"p": "dispel"}, [f]); seen["dispel"] = 1
	_chk("積木 dispel：清正面 buff、停再生", not AB.has_bf(op, f, "buff") and J.num(f.ab.get("regen_stop", 0)) > op.t)
	# 33 banish
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f["sum"] = true; f.ab["sum"] = true; f.hp = 900.0
	P(op, h, {"p": "banish", "hp_pct": 0.4}, [f, r[2][1]]); seen["banish"] = 1
	_chk("積木 banish：召喚物 <40% 血即收、目標唔再返生", J.num(f.hp) <= 0 and J.t(r[2][1].ab.get("no_rev")))
	# 34 sap / 35 wound
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	f["energy"] = 60.0; P(op, h, {"p": "sap", "v": 35}, [f]); seen["sap"] = 1
	_chk("積木 sap：抽嚇氣", J.num(f.energy) == 25.0)
	P(op, h, {"p": "wound", "v": 0.6, "dur": 6}, [f]); seen["wound"] = 1
	_chk("積木 wound：治療 −60%", absf(AB.stat(op, f, "heal_in") - 0.4) < 0.01)
	# 36 dash
	r = _fresh(3); op = r[0]; h = r[1][0]
	r[2][2].p = Vector2(0, 100)
	P(op, h, {"p": "dash", "to": "back"}, []); seen["dash"] = 1
	_chk("積木 dash：瞬移到敵方後排", (h.p as Vector2).distance_to(Vector2(0, 100)) < 60 and h.tg == r[2][2], h.p)
	# 37 stealth
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	h.p = Vector2(0, 600)
	P(op, h, {"p": "stealth", "dur": 3, "first_x": 2.0}, [h]); seen["stealth"] = 1
	var hid2 = not AB.targetable(op, f, h)
	h.p = Vector2(0, 290); d0 = H(op, h, f)
	_chk("積木 stealth：揀唔到、首擊 ×2 後現身", hid2 and AB.targetable(op, f, h) and d0 > 100, d0)
	# 38 summon
	r = _fresh(); op = r[0]; h = r[1][0]
	var n0 = op.units.size(); P(op, h, {"p": "summon", "n": 2, "hp_pct": 0.2}, [h]); AB._flush(op); seen["summon"] = 1
	var ss = op.units.slice(n0)
	_chk("積木 summon：多咗 2 隻（sum:true）", ss.size() == 2 and J.t(ss[0].get("sum")))
	steps(op, 0.1); op.finish(true)
	var left = 0
	for u in op.units: if J.t(u.get("sum")) and J.num(u.side) == 0: left += 1
	_chk("我方召喚物結算前拎走（唔計陰兵戰死）", left == 0)
	# 39 coin
	r = _fresh(); op = r[0]; h = r[1][0]
	P(op, h, {"p": "coin", "v": 25}, [h]); seen["coin"] = 1
	_chk("積木 coin：偷冥幣", op.coins_won == 25.0)
	# 40 zone
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	P(op, h, {"p": "zone", "r": 120, "dur": 3, "fx": [{"p": "slow", "v": 0.5, "dur": 1.0}, {"p": "dmg", "mult": 0.3}]}, [f]); d0 = J.num(f.hp); steps(op, 1.2); seen["zone"] = 1
	_chk("積木 zone：區內敵人減速＋扣血", AB.has_bf(op, f, "slow") and J.num(f.hp) < d0)
	_chk("40 個積木都測過", seen.size() == 40, seen.size())
	# 觸發：被打觸發護盾、殺敵觸發
	r = _fresh(); op = r[0]; h = r[1][0]; f = r[2][0]
	h.ab.pas = [{"tr": "hit_taken", "icd": 0.0, "fx": [{"p": "shield", "pct": 0.05, "dur": 4}]}, {"tr": "kill", "fx": [{"p": "energy", "v": 50}]}]
	AB.hit(op, f, h, 1.0, null); var sh_ok = J.num(h.ab.shd) > 0
	r[2][1].hp = 5.0; AB.hit(op, h, r[2][1], 1.0, null)
	_chk("觸發 hit_taken／kill（depth≤1）", sh_ok and J.num(h.energy) >= 50, [h.ab.shd, h.energy])
	await null

func _legacy() -> void:
	var SK = J.G.get("SKILLS"); var n = 0; var bad_ = []
	for k in SK:
		var a = AB.from_legacy(SK[k])
		if a is Dictionary and (a.fx as Array).size(): n += 1
		else: bad_.append(k)
	_chk("舊 SKILLS 全部自動轉換（%d 條）" % SK.size(), bad_.is_empty(), bad_)
	var ag = AB.from_legacy(SK["xiaozhi"])
	_chk("舊 aoe → 以目標為圓心 130px（唔再全場）", J.str(ag.tg.get("shape")) == "circle" and J.num(ag.tg.r) == 130.0)
	# 真技能放出：aoe 只打 130 內
	var hs = [mk("xiaozhi", 0, 2000, 60, 150, SK["xiaozhi"])]
	var fs = [mk(F_K, 1, 3000, 40), mk(F_K, 1, 3000, 40), mk(F_K, 1, 3000, 40)]
	var op = placed(hs, fs)
	fs[2].p = Vector2(0, -200)
	op.do_skill(hs[0], hs[0].sk)
	_chk("aoe 技：近嘅兩隻中、遠嘅唔中、腳軟", J.num(fs[0].hp) < 3000 and J.num(fs[1].hp) < 3000 and J.num(fs[2].hp) == 3000 and J.num(fs[0].st.get("down", 0)) > 0)
	var hs2 = [mk("mengpo", 0, 2000, 60, 150, SK["mengpo"]), mk(N_K, 0, 2000, 60)]
	hs2[1].hp = 1000.0
	op = placed(hs2, [mk(F_K, 1, 3000, 40)])
	op.do_skill(hs2[0], hs2[0].sk)
	_chk("heal 技：隊友回血", J.num(hs2[1].hp) > 1000)
	var GH = J.G.get("GHOSTS"); var miss = []
	for k in GH: if AB.scares_of(k).is_empty(): miss.append(k)
	_chk("全部名鬼都有嚇法（%d 隻）" % GH.size(), miss.is_empty(), miss)
	var nt = 0
	for k in GH: if AB.tags_of(k).size() > 0: nt += 1
	_p("有應對標籤嘅名鬼 %d/%d；例：%s" % [nt, GH.size(), AB.describe("laojiang")])
	_chk("describe／tags_of／scares_of 接口", AB.describe("xiaozhi") != "" and AB.tags_of("xiaozhi").has("掃") and AB.sys_of("pocong") == "屍")

func _layers() -> void:
	# 普攻：怕 ×1.15、唔怕 ×0.8；技能：怕 ×1.35＋失神、連嚇、追嚇 ×1.3、唔怕 ×0.6；敵人技能打名鬼 ×1.25／×0.75；封頂
	var h = mk("n30_xiaosi", 0, 2000, 100)   # 橫系、怪聲
	var f_fear = mk("zombie", 1, 50000, 40)   # 屍：怕吹氣、怪聲；唔怕凍
	var f_neu = mk("youhun", 1, 50000, 40)    # 魂：怪聲中性
	var f_imm = mk("pontianak", 1, 50000, 40) # 厲：唔怕怪聲
	var op = placed([h], [f_fear, f_neu, f_imm])
	var dn = H(op, h, f_neu); var df = H(op, h, f_fear); var di = H(op, h, f_imm)
	_chk("普攻吃克制：怕 ×1.15、唔怕 ×0.8", absf(df / dn - 1.15) < 0.02 and absf(di / dn - 0.8) < 0.02, [dn, df, di])
	var c = {"sk": true, "kind": "hit", "mult": 1.0, "hits": 1}
	var sn = H(op, h, f_neu, 1.0, c); var sf = H(op, h, f_fear, 1.0, c); var si = H(op, h, f_imm, 1.0, c)
	var drill = 1 + 0.05 * (J.num(J.mc(J.G.Rework, "drillLv", ["n30_xiaosi"])) - 1)
	_chk("技能：怕 ×1.35＋失神、唔怕 ×0.6", absf(sf / sn - 1.35) < 0.02 and absf(si / sn - 0.6) < 0.02 and f_fear.get("fearT") is Dictionary, [sn, sf, si, drill])
	var h2 = mk("n30_danxiao", 0, 2000, 100)   # 魂系、吹氣：屍怕吹氣 → 失神中換吹氣＝連嚇
	op.units.append(h2); AB.compile(op, h2); h2["p"] = Vector2(30, 300)
	var sc_ = H(op, h2, f_fear, 1.0, c)
	var s_ref = H(op, h2, f_neu, 1.0, c)   # 吹氣打魂＝唔怕 ×0.6
	_chk("連嚇：失神中換第二種怕 ×1.35×1.8", absf(sc_ / (s_ref / 0.6) - 1.35 * 1.8) < 0.05, [sc_, s_ref])
	var h3 = mk("n30_yesi", 0, 2000, 100)   # 橫、電話：屍中性 → 追嚇
	op.units.append(h3); AB.compile(op, h3); h3["p"] = Vector2(-30, 300)
	f_fear["fearT"] = {"t": "sound", "until": op.t + 3.0}
	var sz = H(op, h3, f_fear, 1.0, c); f_fear.erase("fearT"); var sz0 = H(op, h3, f_fear, 1.0, c)
	_chk("追嚇：失神中被中性嚇法打 ×1.3", absf(sz / sz0 - 1.3) < 0.02, [sz, sz0])
	# 敵人技能打名鬼：敵方電話 vs 名鬼系（厲怕電話、橫唔怕電話）
	var e = mk("zd_hengsi", 1, 5000, 100)
	var hl = mk("n30_banshee", 0, 50000, 50); var hh = mk("n30_zipai", 0, 50000, 50); var hn = mk(N_K, 0, 50000, 50)
	op = placed([hl, hh, hn], [e])
	var en = H(op, e, hn, 1.0, c); var el = H(op, e, hl, 1.0, c); var eh = H(op, e, hh, 1.0, c); var e_norm = H(op, e, hl)
	_chk("敵人技能打名鬼：怕 ×1.25、唔怕 ×0.75；普攻唔計", absf(el / en - 1.25) < 0.02 and absf(eh / en - 0.75) < 0.02 and absf(e_norm - en) < 2, [en, el, eh, e_norm])
	# 封頂 4.0：連嚇 2.43 × 追擊 1.8 × 易傷 ×2
	op = placed([mk("n30_xiaosi", 0, 2000, 100)], [mk("zombie", 1, 99999, 40)])
	var u = op.units[0]; var v = op.units[1]
	var yh = mk("youhun", 1, 99999, 40); yh["p"] = Vector2(0, 250)
	var base = H(op, u, yh, 1.0, c)
	AB.compile(op, v); v["fearT"] = {"t": "breath", "until": 99.0}; v.st["down"] = 1.0
	AB.add_bf(op, v, {"p": "mark", "stat": "taken", "v": 1.0, "dur": 9})
	var big = H(op, u, v, 1.0, {"sk": true, "kind": "hit", "mult": 1.0, "follow": "down", "fol_x": 1.8})
	_chk("兩層總倍率封頂 ×4.0", absf(big * drill / base - 4.0) < 0.15, [base, big, drill])

func _combo() -> void:
	var S = J.G.S; var lv0 = S.get("lv", 1)
	S["lv"] = 20.0
	var SK = J.G.get("SKILLS")
	var a = mk("baiwu", 0, 3000, 80, 46, SK["baiwu"]); var b = mk("heiwu", 0, 3000, 80, 46, SK["heiwu"])
	var fs = [mk(F_K, 1, 4000, 30), mk(F_K, 1, 4000, 30)]
	var op = placed([a, b], fs)
	_chk("合體技：黑白無常同場 → 有合體技", AB.combo_list(op).size() == 1)
	op.auto = true
	var cb = AB.combo_list(op)[0]; cb["energy"] = 100.0
	var h0 = J.num(fs[0].hp)
	for i in 20: AB.tick(op, 0.05)
	var fired = false
	for e in op.events: if e[0] == "combo": fired = true
	_chk("合體技喺地圖戰鬥放出（全場傷害＋腳軟）", fired and J.num(fs[0].hp) < h0 and J.num(fs[1].st.get("down", 0)) > 0, [h0, fs[0].hp])
	S["lv"] = 3.0
	op = placed([mk("baiwu", 0, 3000, 80), mk("heiwu", 0, 3000, 80)], [mk(F_K, 1, 4000, 30)])
	_chk("合體技：主公 Lv<17 唔開（同舊版）", AB.combo_list(op).is_empty())
	S["lv"] = lv0

func _off() -> void:
	AB.force = -1; AB.OFF = true
	var op = placed([mk(N_K, 0)], [mk(F_K, 1)])
	var off_ok = not op.ab and op.units[0].get("ab") == null
	AB.OFF = false
	op = placed([mk(N_K, 0)], [mk(F_K, 1)])
	_chk("AB.OFF 一鍵回舊路（全域、唔入存檔）；關返就開", off_ok and op.ab and not (J.G.S as Dictionary).has("ab_off"))
	AB.force = 1
	# 同種子：ab 關 ＝ 舊 hit 一模一樣
	AB.force = 0
	seed(3); var o1 = _duel(); seed(3); var o2 = _duel()
	AB.force = 1
	_chk("ab 關：同種子同結果（舊路決定性）", o1 == o2, [o1, o2])
func _duel() -> Array:
	var op = arena([mk(N_K, 0, 2000, 60, 46, SKH.duplicate()), mk("youhun", 0, 400, 20, 38, null, true), mk(F_K, 1, 2500, 50)])
	op.t_skip_march()
	var n = 0
	while op.result == null and n < 20 * 120: op.step(0.05); n += 1
	return [op.result.win if op.result else null, snappedf(op.t, 0.05)]

# ================= mech =================
const MECHS := ["飛", "隱", "殼", "再生", "散骨", "召喚", "反傷", "嚇氣光環", "霸體", "屍變", "突襲", "迷魂", "分身"]
# 每種機制：冇應對隊、有應對隊（按 counter.md 4.1 應對標籤）
const PLANS := {
	"飛": ["melee", "ranged"], "隱": ["ranged", "ranged_reveal"], "殼": ["melee", "break"], "再生": ["melee", "sap"], "散骨": ["melee", "sweep"],
	"召喚": ["melee", "stab"], "反傷": ["melee", "ranged"], "嚇氣光環": ["melee", "steady"], "霸體": ["cc", "break"], "屍變": ["melee", "seal"],
	"突襲": ["ranged_back", "steady_back"], "迷魂": ["melee", "steady"], "分身": ["melee", "reveal"],
}
func _team(kind: String) -> Array:
	var o = []
	for i in 3:
		var rng = 46.0
		var sk = {"name": "測試擊", "kind": "hit", "mult": 1.5}
		match kind:
			"ranged", "ranged_reveal": rng = 150.0
			"sweep": sk = {"name": "測試掃", "kind": "aoe", "mult": 0.9}
			"break": sk = {"name": "測試連擊", "kind": "hit", "mult": 1.6, "hits": 3}
			"sap": sk = {"name": "測試削", "kind": "hit", "mult": 1.4, "sap": 40}
			"cc", "break_cc": sk = {"name": "測試絆", "kind": "hit", "mult": 1.4, "apply": "down", "follow": "down"}
			"stab": sk = {"name": "測試刺", "kind": "hit", "mult": 1.8}
			"ranged_back", "steady_back": rng = 150.0 if i > 0 else 46.0
		var u = mk(N_K, 0, 2400.0 if kind.ends_with("_back") and rng > 60 else 4000.0, 60, rng, sk)
		o.append(u)
	for i in 4: o.append(mk("youhun", 0, 500, 20, 38, null, true))
	return o
func _tags_for(kind: String, i: int) -> Array:
	match kind:
		"ranged": return ["遠"]
		"reveal": return ["照"]
		"ranged_reveal": return ["遠", "照"] if i == 0 else ["遠"]
		"break": return ["破"]
		"sap": return ["削"]
		"sweep": return ["掃"]
		"stab": return ["刺"]
		"steady": return ["定"] if i == 0 else []
		"steady_back": return ["定"] if i == 0 else (["遠"] if i > 0 else [])
		"ranged_back": return ["遠"] if i > 0 else []
		"seal": return ["收"] if i == 0 else []
		"cc": return ["拉"]
	return []
func _fight(kind: String, mech: String, sd: int) -> Dictionary:
	seed(sd)
	var us = _team(kind)
	var fs = []
	for i in 3:
		var f = mk(F_K, 1, 2600, 45)
		if mech != "" and i < 2: f["mech"] = [mech]   # 名鬼型兩隻帶機制、雜兵一隻冇（同據點配置一樣）
		fs.append(f)
	var op = arena(us + fs)
	for i in 3:
		var a = op.units[i].ab
		a["tags"] = _tags_for(kind, i)
		if kind == "break": a.tags = ["破"]
	op.t_skip_march()
	var hp0 = [0.0, 0.0]
	for u in op.units: if J.num(u.side) == 0: hp0[int(J.t(u.get("minion")))] += J.num(u.maxhp)
	var n = 0
	while op.result == null and n < 20 * 100: op.step(0.05); n += 1
	var hp1 = [0.0, 0.0]
	for u in op.units: if J.num(u.side) == 0 and not J.t(u.get("sum")): hp1[int(J.t(u.get("minion")))] += maxf(0.0, J.num(u.hp))
	var win = op.result != null and J.t(op.result.win)
	var loss = (1.0 - hp1[0] / maxf(1.0, hp0[0])) + 0.5 * (1.0 - hp1[1] / maxf(1.0, hp0[1]))   # 名鬼失血全計、陰兵計一半
	var tt = op.t if win else 90.0 + (90.0 * (1.0 - _foe_frac(op)))
	return {"win": win, "t": op.t, "loss": loss, "hl": 1.0 - hp1[0] / maxf(1.0, hp0[0]), "score": tt * (1.0 + loss), "ev": op.ab_log.get("ev", {})}
func _foe_frac(op) -> float:
	var a = 0.0; var b = 0.0
	for u in op.units: if J.num(u.side) == 1 and not J.t(u.get("sum")): a += maxf(0.0, J.num(u.hp)); b += J.num(u.maxhp)
	return a / maxf(1.0, b)
func _avg(kind: String, mech: String, N: int) -> Dictionary:
	var s = 0.0; var w = 0; var tt = 0.0; var ls = 0.0; var evs = {}; var hl = 0.0
	for i in N:
		var r = _fight(kind, mech, 100 + i)
		s += r.score; w += int(r.win); tt += r.t; ls += r.loss; hl += r.hl
		for k in r.ev: evs[k] = int(evs.get(k, 0)) + int(r.ev[k])
	return {"score": s / N, "win": w, "t": tt / N, "loss": ls / N, "hl": hl / N, "ev": evs}
func mech(t) -> void:
	await _boot(t)
	AB.force = 1; AB.reload()
	var B = J.G.get("Battle"); var auto0 = B.get("auto") if B is Dictionary else false
	if B is Dictionary: B["auto"] = true
	var N = 6
	var base = {}
	var rows = []
	for m in MECHS:
		var pl = PLANS[m]
		var nc = pl[0]; var co = pl[1]
		if not base.has(nc): base[nc] = _avg(nc, "", N)
		if not base.has(co): base[co] = _avg(co, "", N)
		var a = _avg(nc, m, N); var b = _avg(co, m, N)
		var dn = a.score / base[nc].score; var dc = b.score / base[co].score
		rows.append([m, dn, dc, a.win, b.win])
		var key_ev = {}
		for k in a.ev: if not (k in ["trig_start"]): key_ev[k] = a.ev[k]
		_p("機制 %-4s 冇應對(%s) 難度 ×%.2f 勝 %d/%d 時 %.1f 失血 %.0f%%｜有應對(%s) ×%.2f 勝 %d/%d 時 %.1f｜事件 %s" % [m, nc, dn, a.win, N, a.t, a.loss * 100, co, dc, b.win, N, b.t, str(key_ev).substr(0, 160)])
		var hr = a.hl / maxf(0.01, base[nc].hl)
		_chk("機制 %s：真係生效（冇應對：難度 > ×1.03 或名鬼失血 ×1.2）" % m, dn > 1.03 or hr >= 1.2, "難度 %.2f 名鬼失血 ×%.2f" % [dn, hr])
		if dn < 1.3 or dn > 3.0: _p("WARN 機制 %s 冇應對難度 ×%.2f 唔喺目標 1.3–3（數值照 counter.md 4.1，交平衡線）" % [m, dn])
		_chk("機制 %s：唔硬鎖（冇應對都贏到 ≥ 1 場、難度 ≤ ×3.5）" % m, a.win >= 1 and dn <= 3.5, [a.win, "%.2f" % dn])
		_chk("機制 %s：帶啱應對明顯易打（有應對 ≤ 冇應對 −0.15，或 ≤ ×1.15）" % m, dc <= dn - 0.15 or dc <= 1.15, ["%.2f" % dc, "%.2f" % dn])
		await t.get_tree().process_frame
	var inr = 0
	for r in rows: if r[1] >= 1.3 and r[1] <= 3.0: inr += 1
	_p("冇應對難度落喺 1.3–3 倍嘅機制：%d/13（其餘見上，交平衡線）" % inr)
	for k in base: _p("基準 %s：勝 %d/%d 平均 %.1f 秒 失血 %.0f%%" % [k, base[k].win, N, base[k].t, base[k].loss * 100])
	if B is Dictionary: B["auto"] = auto0
	AB.force = -1
	_p("RESULT ok=%d bad=%d" % [ok, bad])
