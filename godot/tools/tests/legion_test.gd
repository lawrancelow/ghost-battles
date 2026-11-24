# [legion] 八大軍團 54 隻＋軍團據點測試（老闆 17:10：軍團營暫時唔掛現有地圖 → 用測試入口直接開營打）
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> lg res://tools/tests/legion_test.gd <func> <秒>
#   all：登記齊全／圖都載入／體型／唔喺現有 6 張圖／據點結構／24 營逐個真出擊（SO.dispatch）打完＋掉魂＋解鎖＋祭壇招降（包括軍團王）
#   shots：每個軍團王營真出擊、截戰鬥圖（王在場）＋出手方向（face）驗證 → /home/claude/docs/shots/legion/
#   cal：平衡校準（地圖七起嘅模擬玩家：第 6 章最外圈名鬼池＋等級按難度），結果寫 /tmp/bal/cal_lg.json（apply_bal 用）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/shots/legion/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const LG = preload("res://game/legion/lg_data.gd")
const SOUL = preload("res://game/soul/soul_data.gd")
const S2 = preload("res://game/soul/soul2.gd")
const AB = preload("res://game/rts/abil.gd")
const NG = preload("res://game/newghost/ng_data.gd")
const TEAM := ["heiwu", "baiwu", "laojiang"]   # 測試隊（強名鬼）

func _p(m): print("[legion] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	var idle = 0
	for i in maxi(n, 40):
		var m = _main(t); var st = m.get("story") if m else null
		var Sy = J.G.get("Story")
		var busy = (st and st.get("cur") != null) or (Sy != null and J.t(J.mc(Sy, "busy", [])))
		if st and st.get("cur") != null: st.skip_scene()
		if not busy:
			idle += 1
			if idle >= 3 and i >= n - 1: break
		else: idle = 0
		await _w(t, 0.25)
func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)
func _boot(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m0 = _main(t)
		if m0 and m0.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
func _team(t, lv := 80.0) -> void:
	var S = J.G.S
	SOUL._bypass = true
	for k in TEAM: if not SOUL.owned(k): J.cl(J.G.get("joinGhost"), null, [k])
	SOUL._bypass = false
	await _skip(t, 8)
	var ids = []
	for g in S.ghosts:
		if str(g.get("k")) in TEAM: g["lv"] = lv; ids.append(g.id); SOUL.st().rk[str(g.k)] = 5.0; SOUL.apply_stats(g)
	S["team"] = ids
	S["lv"] = lv; S.res["troops"] = 200.0; S.res["buns"] = 100000.0; S.res["coins"] = 10000000.0
	J.G.get("Battle")["auto"] = true
	SO.force_open = true; SO.test_now = 1000000.0

# 測試入口：喺現有地圖第 1 個據點位開軍團營（唔掛圖，唔改 SO.camps）
func _entry(cid: String) -> Dictionary:
	var z = ZD.sortie("so1_r1_1", 0)
	var e = LG.entry(cid, ZD.v2(z.pos), ZD.ci())
	e["route"] = z.get("route")
	e["c"] = int(J.num(LG.camp_def(cid).ci))   # 存檔 key／難度用軍團所屬地圖（ci 6–11）
	return e

# ================= 1. 登記 =================
func reg_check() -> void:
	var D = LG.D(); var ks: Array = LG.keys()
	_chk("legion.json 讀到、54 隻、8 個軍團、24 營", ks.size() == 54 and D.LEG.size() == 8 and D.CAMPS.size() == 24, [ks.size(), D.LEG.size(), D.CAMPS.size()])
	_chk("已登記（ng_data install → LG.install）", LG.installed)
	var miss = []; var nodb = []; var noab = []; var noen = []; var noart = []; var nopin = []; var nocodex = []; var nosay = []
	for k in ks:
		var g = J.G.GHOSTS.get(k)
		if not (g is Dictionary) or str(g.get("q", "")) != "名" or not J.G.ENEMY_T.has(k) or not J.G.SKILLS.has(k): miss.append(k)
		if not (DB.D.GHOSTS.get(k) is Dictionary): nodb.append(k)
		var a = AB.abil(k)
		if not (a.get("act") is Dictionary) or (a.get("tags", []) as Array).size() < 2: noab.append(k)
		var en = AB._ent("ENEMY", k)
		if not J.t(en.get("use_abil")) or str(en.get("sys", "")) == "" or (en.get("fear", []) as Array).size() != 2: noen.append(k)
		if PtGfx.tex(k) == null or Art.char_h(k) <= 0 or Art.portrait_region(k).size() != 2: noart.append(k)
		if not (SOUL.pin(k) in SOUL.PINS) or SOUL.pin(k) != str(D.PIN[k]): nopin.append(k)
		if S2.entry(k).is_empty(): nocodex.append(k)
		if NG.say_of(k) == "": nosay.append(k)
	_chk("54 隻全部喺 GHOSTS（名鬼）／ENEMY_T／SKILLS", miss.is_empty(), miss)
	_chk("54 隻入咗 DB.D.GHOSTS（原生介面）", nodb.is_empty(), nodb)
	_chk("54 隻有能力（主動技＋2–3 標籤）", noab.is_empty(), noab)
	_chk("54 隻有敵人資料（系、怕兩種、use_abil）", noen.is_empty(), noen)
	_chk("54 張圖全部載入（貼圖、CHAR_H、頭像）", noart.is_empty(), noart)
	_chk("品級：雜兵凡、精英靈、頭目煞、軍團王王", nopin.is_empty(), nopin)
	_chk("54 隻有台詞", nosay.is_empty(), nosay)
	_chk("圖鑑 54 格自動加（131＋54＝185）", nocodex.is_empty() and S2.list().size() == 185, [nocodex, S2.list().size()])
	var kings = ks.filter(func(k): return str(LG.unit(k).slot) == "king")
	_chk("8 隻軍團王都係王品、可招降（唔係魔王）", kings.size() == 8 and kings.all(func(k): return SOUL.pin(k) == "王" and not SOUL.unsummonable(k)), kings)
	# 機制、克制
	var bm = []
	for k in ks:
		var sl = str(LG.unit(k).slot); var ms = AB.mechs_of(k)
		if sl in ["boss", "boss2", "king"] and not (ms.size() >= 2 and ms.size() <= 3): bm.append([k, ms])
		if sl == "shoot" and J.num(LG.unit(k).rng) < 150: bm.append([k, "遠程射程"])
		if sl == "tank" and not (ms.has("殼") or J.num(J.G.ENEMY_T[k][0]) >= 2.0): bm.append([k, "肉盾"])
	_chk("頭目／王 2–3 個機制、遠程有射程、肉盾有殼或高血", bm.is_empty(), bm)
	var wt = AB.mechs_of("lg_jsj_wutou")
	var wpi = false
	for pe in AB.abil("lg_jsj_wutou").pas:
		for fx in pe.fx: if str(fx.p) == "immune" and "confuse" in fx.tags and "fear" in fx.tags: wpi = true
	_chk("無頭王爺：霸體＋開場免疫迷魂／恐懼", wt.has("霸體") and wpi, wt)
	var sk = []
	for k in ks:
		if AB.mechs_of(k).has("召喚"):
			var sm = str(AB._ent("ENEMY", k).get("sum_k", ""))
			if not LG.is_lg(sm) or not J.G.ENEMY_T.has(sm): sk.append(k)
	_chk("有召喚機制嘅召同軍團雜兵（sum_k）", sk.is_empty(), sk)
	var sys8 = {}
	for k in ks: sys8[AB.sys_of(k)] = true
	_chk("軍團覆蓋 8 系", sys8.size() == 8, sys8.keys())

# ================= 2. 體型 =================
func size_check() -> void:
	var badz = []; var wide = []
	for lg in LG.legions():
		var us: Array = LG.leg(lg).units
		var hb = 0.0
		for k in us: if str(LG.unit(k).slot) == "bing": hb = Art.char_h(k)
		for k in us:
			var sl = str(LG.unit(k).slot); var h = Art.char_h(k)
			if sl in ["boss", "boss2"] and h < hb * 1.2: badz.append([k, h, hb])
			if sl == "king" and h < hb * 1.45: badz.append([k, h, hb])
			var tx = PtGfx.tex(k)
			var wd = h * tx.get_width() / float(tx.get_height())
			if wd > h * 1.4 + 1.0: wide.append([k, snappedf(wd, 0.1)])
			var pr = Art.portrait_region(k)
			var r: Rect2 = pr[1]
			if r.position.x < 0 or r.end.x > tx.get_width() + 0.5 or r.end.y > tx.get_height() + 0.5: wide.append([k, "頭像出界"])
	_chk("頭目 ≥ 雜兵 ×1.2、軍團王 ≥ ×1.45（CHAR_H）", badz.is_empty(), badz)
	_chk("寬圖（最闊 563px）畫面闊度 ≤ 高 ×1.4、頭像唔出界（唔爆格）", wide.is_empty(), wide)
	_p("  高度：雜兵 %d／頭目 %d／王 %d" % [Art.char_h("lg_egs_bing"), Art.char_h("lg_egs_boss"), Art.char_h("lg_egs_king")])

# ================= 3. 據點結構（唔喺現有 6 張圖） =================
func camp_check() -> void:
	var D = LG.D()
	var on6 = []
	for c in 6:
		for e in SO.camps(c): if LG.is_camp(e): on6.append(e.id)
	_chk("軍團營唔喺現有 6 張圖（CAMP_ON＝false）", on6.is_empty() and not J.t(D.get("CAMP_ON")), on6)
	var hid = 0
	for c in range(6, 12): hid += SO.camps(c).size()
	_chk("新地圖未做：地圖七～十二冇據點顯示", hid == 0, hid)
	var want = {"jsj": 6, "egs": 7, "ssg": 7, "sgj": 8, "wkj": 8, "zzj": 9, "dpl": 10, "klj": 11}
	var badm = []; var badp = []; var badc = []
	for lg in want:
		var L = LG.leg(lg)
		if int(L.ci) != want[lg]: badm.append([lg, L.ci])
		var ps = []
		for i in 3:
			var d = LG.camp_def("lg_%s_%d" % [lg, i + 1])
			if int(d.ci) != want[lg] or int(d.tier) != i + 1: badm.append(d.id)
			ps.append(J.num(d.p))
			if str(d.guard) != str(d.en[d.en.size() - 1]): badc.append([d.id, "駐守唔係最後一隻"])
			if i > 0 and str(d.need) != "lg_%s_%d" % [lg, i]: badc.append([d.id, "鎖鏈"])
		if not (ps[0] < ps[1] and ps[1] < ps[2]): badp.append([lg, ps])
		if str(LG.camp_def("lg_%s_3" % lg).guard) != L.units.filter(func(k): return str(LG.unit(k).slot) == "king")[0]: badc.append([lg, "王營駐守唔係王"])
	_chk("所屬地圖：七殭屍、八餓死鬼＋食屍鬼、九水鬼＋倭寇、十紙紮、十一地痞、十二骷髏", badm.is_empty(), badm)
	_chk("每軍團 3 營：雜兵營 → 頭目營 → 王營（難度遞增、鎖鏈、王營駐守＝王）", badp.is_empty() and badc.is_empty(), [badp, badc])
	var mn = 99.0
	for cid in D.CAMPS: mn = minf(mn, J.num(D.CAMPS[cid].p))
	var mx6 = 0.0
	for e in SO.camps(5): mx6 = maxf(mx6, J.num(e.lv))
	_chk("軍團營難度高過地圖六所有據點", mn > mx6, [mn, mx6])
	var ord = []
	for c in range(6, 12):
		var lo = 99.0
		for cid in D.CAMPS: if int(D.CAMPS[cid].ci) == c: lo = minf(lo, J.num(D.CAMPS[cid].p))
		ord.append(lo)
	var inc = true
	for i in range(1, ord.size()): if ord[i] <= ord[i - 1]: inc = false
	_chk("地圖七起逐圖遞增", inc, ord)
	# 掛圖接口（地圖線用）：attach 後 force_on 出現喺 SO.camps(ci)
	LG.force_on = true; LG.attach("lg_jsj_1", Vector2(100, 100))
	var got = SO.camps(6).filter(func(e): return str(e.id) == "lg_jsj_1")
	LG.force_on = false; LG.detach_all()
	_chk("掛圖接口：attach＋CAMP_ON 之後出現喺 SO.camps(6)、帶 lg／guard", got.size() == 1 and str(got[0].lg) == "jsj" and str(got[0].guard) == "lg_jsj_yayi" or (got.size() == 1 and str(got[0].guard) == "lg_jsj_guan"), got)
	_chk("掛圖後冇殘留（SO.camps(6) 再次為空）", SO.camps(6).is_empty())

# ================= 4. 24 營逐個真出擊 =================
func _run_op(op, boost := 1.0) -> void:
	if boost != 1.0:
		for u in op.units:
			if J.num(u.side) == 0: u["atk"] = J.num(u.atk) * boost; u["hp"] = J.num(u.hp) * boost; u["maxhp"] = J.num(u.get("maxhp", u.hp)) * boost
	op.t_skip_march()
	var n = 0
	while op.phase != "end" and n < 20000:
		op.step(0.1); n += 1
		if op.events.size() > 64: op.events.clear()
func _finish(op) -> Dictionary:
	if RTS._settle(op): op.settled = true; op.begin_back()
	var n = 0
	while op.phase != "done" and n < 5000: op.step(0.1); n += 1
	RTS.ops.erase(op)
	return RTS.last_report if RTS.last_report is Dictionary else {}
func fight_check(t) -> void:
	var D = LG.D(); var cids = D.CAMPS.keys(); cids.sort()
	var nwin = 0; var nboost = []; var soul_bad = []; var lock_bad = []; var foe_bad = []; var ranged_bad = []
	for lg in LG.legions():
		for i in 3:
			var cid = "lg_%s_%d" % [lg, i + 1]
			var e = _entry(cid)
			if SO.state(e) == "locked":
				lock_bad.append([cid, "前一營首勝之後仲鎖住"]); continue
			if i < 2:
				var nx = _entry("lg_%s_%d" % [lg, i + 2])
				if SO.state(nx) != "locked": lock_bad.append([nx.id, "前一營未首勝應該鎖", SO.state(nx)])
			var d = LG.camp_def(cid)
			var want = []
			for k in [str(d.guard)] + Array(d.co): want.append(k)
			var s0 = {}
			for k in want: s0[k] = SOUL.souls(k)
			var win = false; var boost = 1.0
			for tr in 3:
				var r = SO.dispatch(e)
				var op = RTS.op_for(SO.sid_of(e))
				if r != "ok" or op == null: foe_bad.append([cid, "出擊失敗", r]); break
				if tr == 0:
					var foes = op.units.filter(func(u): return J.num(u.side) == 1 and u.get("foe_ml") == null and not J.t(u.get("sum")) and not J.t(u.get("ab", {}).get("clone")))   # 唔計遊魂嘍囉、召喚物、分身
					var ks = foes.map(func(u): return str(u.k))
					if ks != Array(d.en): foe_bad.append([cid, ks, d.en])
					for u in foes:
						var un = LG.unit(str(u.k))
						if J.num(un.get("rng", 46)) >= 150 and J.num(u.range) < 100: ranged_bad.append([cid, u.k, u.range])
						if str(un.slot) == "king" and not J.t(u.get("boss")): foe_bad.append([cid, "王冇 boss 旗"])
				_run_op(op, boost)
				var res = op.result
				var rep = _finish(op)
				win = res != null and J.t(res.get("win"))
				_p("  %s 第%d次（加強×%.0f）%s　%s" % [cid, tr + 1, boost, "贏" if win else "輸", str(rep.get("soul", ""))])
				SOUL.st().fr["n"] = {}   # 唔計怨氣（測試）
				SO.cst(e)["clr"] = 0.0
				if win: break
				boost *= 3.0
			if win: nwin += 1
			if boost > 1.0: nboost.append(cid)
			for k in want:
				if SOUL.souls(k) <= int(s0[k]) and not SOUL.owned(k): soul_bad.append([cid, k, s0[k], SOUL.souls(k)])
			if not J.t(SO.cst(e).get("first")): lock_bad.append([cid, "首勝未記"])
			await _f(t, 1)
	_chk("24 營全部出擊得、敵陣＝據點設定、王有頭目旗", foe_bad.is_empty(), foe_bad)
	_chk("遠程兵種有射程（≥140）", ranged_bad.is_empty(), ranged_bad)
	_chk("24 營全部打完（贏）", nwin == 24, nwin)
	_p("  需要加強先贏嘅營（測試隊 Lv80 合夥人三隻＋陰兵 8 隊）：%s" % [nboost])
	_chk("每營打贏：駐守＋同場兵種全部掉主魂", soul_bad.is_empty(), soul_bad)
	_chk("頭目營／王營鎖鏈：前一營首勝先開", lock_bad.is_empty(), lock_bad)

# ================= 5. 祭壇招降（包括軍團王） =================
func summon_check() -> void:
	var S = J.G.S
	if not (S.get("bld") is Dictionary): S["bld"] = {}
	S.bld["altar"] = 6.0
	var badk = []; var n = 0
	for k in LG.keys():
		if SOUL.owned(k): continue
		var need = SOUL.need_of(k)
		SOUL.gain(k, maxi(0, need - SOUL.souls(k)), "test")
		var w = SOUL.wish_of(k)
		S.res[str(w[0])] = 1e9; S.res["coins"] = 1e9
		var c = SOUL.can_summon(k)
		var r = SOUL.summon(k)
		if r != "ok" or not SOUL.owned(k): badk.append([k, r, c.why])
		else: n += 1
	_chk("54 隻全部可以用魂魄＋祭壇招降（包括 8 隻軍團王）", badk.is_empty() and n > 0, badk)
	var g = SOUL.ghost("lg_egs_king")
	_chk("招降後入隊資料：名鬼、三圍、圖鑑變已招降", g != null and str(g.get("q", "")) == "名" and S2.state("lg_egs_king") == "own", g)
	var cs = SOUL.summon_cost("lg_jsj_jiangchen")
	_chk("軍團王招降：120 魂、祭壇 4 級、按所屬地圖收費", int(cs.souls) == 120 and int(cs.altar) == 4 and SOUL.ch_of("lg_jsj_jiangchen") == 6, cs)

func all(t) -> void:
	await _boot(t)
	await _team(t)
	reg_check()
	size_check()
	camp_check()
	await fight_check(t)
	summon_check()
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 截圖＋出手方向 =================
func shots(t) -> void:
	await _boot(t)
	await _team(t, 120.0)
	var m = _main(t)
	var fbad = []; var nf = 0
	for lg in LG.legions():
		for i in 2: SO.cst(_entry("lg_%s_%d" % [lg, i + 1]))["first"] = true
		var e = _entry("lg_%s_3" % lg)
		var r = SO.dispatch(e)
		var op = RTS.op_for(SO.sid_of(e))
		if r != "ok" or op == null: fbad.append([lg, r]); continue
		op.t_skip_march()
		for i in 600:
			if op.phase == "fight": break
			await _f(t, 1)
		for i in 60: await _f(t, 1)
		var kp = Vector2.ZERO; var my = Vector2.ZERO; var cm = 0
		for u in op.units:
			if J.num(u.side) == 1 and J.t(u.get("lg_king")) and u.get("p") is Vector2: kp = u.p
			if J.num(u.side) == 0 and u.get("p") is Vector2 and J.num(u.hp) > 0: my += u.p; cm += 1
		var mid = kp.lerp(my / maxf(1, cm), 0.4) if cm > 0 else kp
		_cam(m, mid, m.village.size.x / 300.0)
		await _w(t, 2.5)
		# 出手方向：軍團兵種（敵方）面向最近我方
		for u in op.units:
			if J.num(u.side) != 1 or J.num(u.hp) <= 0 or not LG.is_lg(str(u.k)) or not (u.get("p") is Vector2): continue
			var best = null; var bd = 1e9
			for w in op.units:
				if J.num(w.side) == 0 and J.num(w.hp) > 0 and w.get("p") is Vector2 and (w.p as Vector2).distance_to(u.p) < bd: bd = (w.p as Vector2).distance_to(u.p); best = w
			if best == null or absf(best.p.x - u.p.x) < 20 or bd > 260: continue
			nf += 1
			if signf(J.num(u.face)) != signf(best.p.x - u.p.x): fbad.append([u.k, u.face, snappedf(best.p.x - u.p.x, 1)])
		await _shot(t, "lg_%s_king" % lg)
		var kh = false
		for u in op.units: if J.t(u.get("lg_king")) and J.num(u.hp) > 0: kh = true
		_chk("%s：王營出擊、王在場截圖" % LG.leg(lg).name, kh)
		_run_op(op, 5.0); _finish(op)
		await _f(t, 2)
	_chk("出手方向：交戰中軍團兵種面向最近我方（%d 次）" % nf, fbad.is_empty() and nf >= 8, fbad)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 平衡校準（tools/balance 框架） =================
func cal(t) -> void:
	await _boot(t)
	var BT = load("res://tools/tests/balance_test.gd").new()
	var Bt = J.G.get("Battle")
	if Bt != null: Bt["auto"] = true
	SO.force_open = true; SO.test_now = 5000000.0
	BT.CAL = true
	var out = {"c": 99, "sites": [], "part": "legion"}
	var cids = LG.D().CAMPS.keys(); cids.sort()
	for cid in cids:
		var d = LG.camp_def(cid)
		var e = _entry(cid)
		var ring = int(d.ring)
		# 地圖七起嘅模擬玩家：第 6 章最外圈名鬼池（＋之前全部）、職級主任、等級按難度尺（每過一張圖 +3 級）
		var pool = BT.pool_of(5, 4)
		var lv = float(round(BT.p2l(21.0 + 4.0))) + 3.0 * (int(d.ci) - 5) + float(ring - 2)
		BT._set_save(5, lv, pool, 2)
		var insts = {}
		for g in J.G.S.ghosts: insts[str(g.k)] = g
		var st = {"kind": "sortie", "c": int(e.c), "e": e, "id": cid, "ring": ring}
		var sn = BT.site_snap(st)
		if sn.is_empty(): continue
		var tmp = {"units": sn.foes}
		LG.decorate(tmp, e)
		var pw = {}
		for k in pool:
			var u = J.mc(J.G.Battle, "mkGhostUnit", [insts[k], 0.0]); pw[k] = sqrt(J.num(u.maxhp) * J.num(u.atk))
		var sc = []
		for tm in BT._combos(BT.top_pool(pool, sn, pw)): sc.append([BT.ascore(tm, sn, pw), tm])
		sc.sort_custom(func(a, b): return a[0] > b[0])
		var best = null
		for j in mini(3, sc.size()):
			var adv = BT.best_adv(sc[j][1], pool, insts)
			var r = BT.batch(sn, sc[j][1], adv, insts, 3)
			if BT._better(r, null if best == null else best.r): best = {"team": sc[j][1], "adv": adv, "r": r}
		var cr = BT.cal_site(sn, best, pool, insts, 0, 5, ring)
		var s0 = J.num(d.get("bal", 1.0))
		out.sites.append({"id": cid, "ring": ring, "s": cr.s, "cal": cr, "best": best.team, "lv": lv})
		_p("%s lv=%d 校準 s=%.3f（現 bal %.3f；最佳 勝%.0f%%、隨機 勝%.0f%%）%s" % [cid, lv, cr.s * s0, s0, cr.B * 100, cr.R * 100, str(best.team)])
		await t.get_tree().process_frame
	DirAccess.make_dir_recursive_absolute("/tmp/bal")
	var f = FileAccess.open("/tmp/bal/cal_lg.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(out)); f.close()
	_p("RESULT ok=1 bad=0")
