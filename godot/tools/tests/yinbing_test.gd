# [yinbing] 陰兵兵種（刀盾／長兵／弓弩／醫護）× 階級（雜兵／士兵／衛兵／親兵）測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> yinbing res://tools/tests/yinbing_test.gd logic|shots 900
#   logic：數據、★→階級、編制分隊、戰鬥單位套兵種（射程／行速／血攻）、揀少隊重分、醫護兵回血（只醫陰兵／遊魂兵、唔醫名鬼、射程、間隔）、
#          醫護兵唔出手、弓弩手射飛彈、遊魂兵唔受影響、16 張立繪、兵營面板、真戰鬥打到完冇錯
#   shots：logic ＋ 實機戰鬥截圖（/home/claude/docs/yinbing_shots/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/yinbing_shots/"
const YB = preload("res://game/yinbing/yb_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SIM = preload("res://game/rts/rts_sim.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const BK = preload("res://game/barracks/bk_data.gd")
const ML = preload("res://game/militia/ml_data.gd")

func _p(m): print("[yb] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	if not shots: return
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _team3(S) -> void:
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
func _qidx_stage(sid: String) -> int:
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == sid: return i
	return -1
func _yin(n: int) -> Array:
	var o = []
	for i in n: o.append({"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": 100.0, "maxhp": 100.0, "atk": 10.0, "range": 38.0, "spd": 52.0})
	return o
func _cnt(us: Array) -> Dictionary:
	var c = {}
	for u in us:
		if u.get("yb_c") != null: c[str(u.yb_c)] = int(c.get(str(u.yb_c), 0)) + 1
	return c

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	S.erase("yinbing")
	# ---- 數據 ----
	_chk("數據讀到（yinbing.json）", YB.on())
	_chk("4 兵種", YB.classes().size() == 4)
	_chk("4 階級", YB.ranks().size() == 4)
	var n16 = 0
	for c in YB.classes():
		for r in YB.ranks():
			if not YB.cell(str(c.id), str(r.id)).is_empty(): n16 += 1
	_chk("16 格齊", n16 == 16, n16)
	var mp = ["za", "za", "shi", "shi", "wei", "wei", "qin"]; var good = true
	for s in 7: good = good and YB.rank_of_star(s) == mp[s]
	_chk("兵器檔 ★0–6 → 雜雜士士衛衛親", good)
	_chk("第一期：階級倍率一律 1.0", YB.rank_k("qin") == 1.0 and YB.rank_k("za") == 1.0)
	_chk("兵種倍率生效（刀盾手血 ×1.25、弓弩手血 ×0.65）", is_equal_approx(YB.mul("jin", "za", "hp"), 1.25) and is_equal_approx(YB.mul("yuan", "qin", "hp"), 0.65))
	var tot = 0.0
	for k in YB.mix(): tot += float(YB.mix()[k])
	_chk("預設編制加埋 = 1", absf(tot - 1.0) < 0.001, YB.mix())
	# ---- 分隊 ----
	_chk("0 隊冇、1 隊 → 刀盾手", YB.split(1) == ["jin"] and YB.split(0).is_empty(), YB.split(1))
	_chk("4 隊 → 刀盾 2 長兵 1 弓弩 1", YB.split(4) == ["jin", "jin", "zhong", "yuan"], YB.split(4))
	_chk("8 隊 → 刀盾 3 長兵 2 弓弩 2 醫護 1", YB.split(8) == ["jin", "jin", "jin", "zhong", "zhong", "yuan", "yuan", "yi"], YB.split(8))
	YB.set_preset("bow")
	_chk("編制預設「重弓」：8 隊有 3 隊弓弩以上", YB.split(8).count("yuan") >= 3 and YB.preset() == "bow", YB.split(8))
	YB.set_preset("std")
	# ---- 套落單位 ----
	var hero = {"side": 0.0, "k": "xiaozhi", "name": "小志", "hp": 300.0, "maxhp": 300.0, "atk": 20.0, "range": 46.0, "spd": 50.0}
	var mlu = {"side": 0.0, "k": "youhun", "name": "遊魂兵", "minion": true, "ml": 2.0, "hp": 100.0, "maxhp": 100.0, "atk": 10.0, "range": 38.0, "spd": 52.0}
	var us = _yin(8) + [hero, mlu]
	YB.force_rank = "shi"
	YB.assign(us)
	_chk("陰兵 8 隊全部分咗兵種", _cnt(us) == {"jin": 3, "zhong": 2, "yuan": 2, "yi": 1}, _cnt(us))
	_chk("名鬼、遊魂兵唔受影響", hero.get("yb_c") == null and mlu.get("yb_c") == null and mlu.range == 38.0 and hero.hp == 300.0)
	var nm8 = YB.norm(YB.split(8))
	_chk("刀盾手血 ×1.25、攻 ×0.95（再按今次分隊平均歸一）", is_equal_approx(us[0].maxhp, 125.0 / nm8.hp) and is_equal_approx(us[0].atk, 9.5 / nm8.atk), [us[0].maxhp, us[0].atk, nm8])
	_chk("兵種相對倍率照設計表（刀盾血／弓弩血 = 1.25／0.65）", is_equal_approx(us[0].maxhp / us[5].maxhp, 1.25 / 0.65))
	var th = 0.0; var ta = 0.0
	for i in 8: th += J.num(us[i].maxhp); ta += J.num(us[i].atk)
	_chk("8 隊總血、總攻同未分兵種一樣（800／80）", is_equal_approx(th, 800.0) and is_equal_approx(ta, 80.0), [th, ta])
	var u1 = _yin(1); YB.assign(u1)
	_chk("得 1 隊（只有刀盾手）＝同舊版陰兵一樣數值", is_equal_approx(J.num(u1[0].maxhp), 100.0) and is_equal_approx(J.num(u1[0].atk), 10.0), [u1[0].maxhp, u1[0].atk])
	_chk("弓弩手射程 150（> 60 當遠程）", us[5].range == 150.0 and us[5].yb_c == "yuan")
	var rg = {}
	for u in us: if u.get("yb_c") != null: rg[str(u.yb_c)] = J.num(u.range)
	_chk("射程：刀盾 38／長兵 56／弓弩 150／醫護 110", rg == {"jin": 38.0, "zhong": 56.0, "yuan": 150.0, "yi": 110.0}, rg)
	_chk("醫護兵有回血設定、階級跟 force_rank", us[7].get("yb_heal") is Dictionary and us[7].yb_r == "shi")
	_chk("單位名＝階級・兵種", str(us[0].name) == YB.name_of("jin", "shi") and str(us[0].name) != "陰兵", us[0].name)
	# 揀少隊重分
	var us2 = us.slice(0, 2)
	us2[0]["hp"] = J.num(us2[0].hp) * 1.1; us2[0]["maxhp"] = J.num(us2[0].maxhp) * 1.1   # 之後乘落去嘅血倍率（yin_k）
	YB.reassign(us2)
	_chk("揀少咗隊：2 隊重新分成刀盾＋長兵", _cnt(us2) == {"jin": 1, "zhong": 1}, _cnt(us2))
	var nm2 = YB.norm(["jin", "zhong"])
	_chk("重分：第 2 隊（長兵）先還原舊倍率再乘 ×0.95（歸一）", is_equal_approx(us2[1].maxhp, 95.0 / nm2.hp) and us2[1].range == 56.0, us2[1].maxhp)
	_chk("重分：第 1 隊（刀盾）血 = 100 × 1.1 × 1.25（歸一）", is_equal_approx(us2[0].maxhp, 110.0 * 1.25 / nm2.hp), us2[0].maxhp)
	# ---- 醫護兵 ----
	var sim = SIM.new()
	var med = {"side": 0.0, "minion": true, "hp": 80.0, "maxhp": 80.0, "p": Vector2(0, 0), "out": true, "yb_c": "yi", "yb_r": "wei", "yb_heal": {"t": 3.0, "r": 160.0, "pct": 0.05}, "yb_ht": 0.0}
	var a1 = {"side": 0.0, "minion": true, "k": "youhun", "yb_c": "jin", "hp": 50.0, "maxhp": 200.0, "p": Vector2(60, 0), "out": true}
	var a2 = {"side": 0.0, "minion": true, "k": "youhun", "yb_c": "zhong", "hp": 150.0, "maxhp": 200.0, "p": Vector2(80, 0), "out": true}
	var far = {"side": 0.0, "minion": true, "k": "youhun", "yb_c": "jin", "hp": 10.0, "maxhp": 200.0, "p": Vector2(400, 0), "out": true}
	var mlx = {"side": 0.0, "minion": true, "k": "youhun", "name": "遊魂兵", "ml": 3.0, "hp": 120.0, "maxhp": 200.0, "p": Vector2(40, 10), "out": true}
	var sumx = {"side": 0.0, "minion": true, "sum": true, "k": "zhiren", "hp": 5.0, "maxhp": 200.0, "p": Vector2(30, 10), "out": true}
	var othm = {"side": 0.0, "minion": true, "k": "jiangshi", "name": "殭屍", "hp": 5.0, "maxhp": 200.0, "p": Vector2(35, -10), "out": true}
	var hh = {"side": 0.0, "hp": 10.0, "maxhp": 500.0, "p": Vector2(20, 0), "out": true}
	var foe = {"side": 1.0, "minion": true, "hp": 10.0, "maxhp": 200.0, "p": Vector2(30, 0)}
	sim.units = [med, a1, a2, far, hh, foe, mlx, sumx, othm]
	var r0 = YB.heal_tick(sim, med, 2.0)
	_chk("醫護兵：未夠 3 秒唔醫", r0 == null)
	var r1 = YB.heal_tick(sim, med, 1.1)
	_chk("醫護兵：醫範圍內最傷嗰隊陰兵（唔揀太遠、唔揀名鬼、唔揀敵人）", r1 != null and r1[1] == a1, r1[1] if r1 != null else null)
	_chk("醫護兵：回最大血 5%", r1 != null and is_equal_approx(J.num(a1.hp), 60.0), a1.hp)
	_chk("醫護兵：名鬼、敵人、遠處嘅冇被醫", hh.hp == 10.0 and foe.hp == 10.0 and far.hp == 10.0)
	_chk("醫護兵：召喚物、其他我方嘍囉（非陰兵）唔醫", sumx.hp == 5.0 and othm.hp == 5.0 and not YB.is_troop(sumx) and not YB.is_troop(othm))
	a1["hp"] = 200.0
	var r2 = YB.heal_tick(sim, med, 3.0)
	_chk("醫護兵：遊魂兵都醫（陰兵醫滿之後輪到佢）", r2 != null and r2[1] == mlx and is_equal_approx(J.num(mlx.hp), 130.0), mlx.hp)
	var r3 = YB.heal_tick(sim, med, 3.0)
	_chk("醫護兵：醫唔超過最大血", r3 != null and J.num(a2.hp) <= 200.0 and J.num(mlx.hp) <= 200.0)
	# ---- 立繪 ----
	var ims = 0
	for c in YB.classes():
		for r in YB.ranks():
			if ResourceLoader.exists("res://assets/spr/yb_%s_%s_stand.webp" % [str(c.id), str(r.id)]): ims += 1
	_chk("16 張兵種×階級立繪齊", ims == 16, ims)
	var BA = load("res://game/barracks/bk_art.gd")
	var tq = BA.yb_tex("yb_jin_qin")
	_chk("親兵刀盾手立繪讀到（同一比例：刀盾衛兵高 340）", tq != null and BA.yb_tex("yb_jin_wei").get_height() == 340, tq)
	# ---- 16 款取圖 ＋ 漂浮兵器 ----
	var YBV = load("res://game/yinbing/yb_view.gd"); var EA = load("res://game/equip/eq_art.gd")
	var n_img = 0; var n_w = 0; var hs = {}
	for c in YB.classes():
		for r in YB.ranks():
			var look = YB.key(str(c.id), str(r.id))
			var tx = BA.yb_tex(look)
			if tx != null and tx.get_height() >= 280 and tx.get_height() <= 420 and tx.get_width() <= 260: n_img += 1
			hs[look] = tx.get_height() if tx != null else 0
			var w = YBV.wea_of(str(c.id), str(r.id))
			if w != "" and EA.shape_of(w) == str(YB.cell(str(c.id), str(r.id)).shape) and YBV.pkey(look) != "" and (load("res://game/equip/eq_view2.gd")._prof[YBV.pkey(look)] as Array).size() == 32: n_w += 1
	_chk("16 款立繪逐張取到（新頭盔版 p2；同一比例：刀盾衛兵 340，其餘按纓／翎高低 280–420）", n_img == 16 and hs.yb_jin_wei == 340, hs)
	var md5ok = 0
	for look in hs:
		var src = "/home/claude/art/out/YinBing/cut/%s_stand.webp" % look
		if not FileAccess.file_exists(src) or FileAccess.get_md5(src) == FileAccess.get_md5("res://assets/spr/%s_stand.webp" % look): md5ok += 1
	_chk("遊戲圖＝老闆通過嘅新頭盔版（cut/ 16 張一致）", md5ok == 16, md5ok)
	_chk("16 款漂浮兵器 id／程序圖形狀／輪廓齊", n_w == 16, n_w)
	_chk("長兵入長兵器表、刀類揮斬、長槍直刺", EA.is_long("ybw_spear_std") and not EA.is_long("ybw_saber_yanling") and EA.atk_style("ybw_saber_iron") == "swing" and EA.atk_style("ybw_spear_wax") == "thrust" and EA.atk_style("ybw_glaive_fengzui") == "swing")
	# 刃口方向：面向左右、揮落中同斬中，刃口法線都向住目標；待機兵器喺面向嗰邊；直刺槍頭向目標
	var bad_e = []
	for c in ["jin", "zhong"]:
		for r in YB.ranks():
			var look = YB.key(c, str(r.id)); var w = YBV.wea_of(c, str(r.id)); var H = YBV.h_of(look)
			for fd in [1.0, -1.0]:
				var tgv = Vector2(fd * 0.95 * H, -0.45 * H)
				var I = YBV.pose_of(look, c, w, H, fd, {"T": 1.0, "act": "idle", "ph": 0.0})
				if (I[0] as Vector2).x * fd <= 0.0: bad_e.append([look, fd, "idle 唔喺面向邊"])
				for ph in [0.35, 0.45, 0.58]:
					var P = YBV.pose_of(look, c, w, H, fd, {"T": 1.0, "act": "atk", "ph": ph, "tg": tgv})
					var ang: float = P[1]; var cc: Vector2 = P[0]
					var to_t = (tgv - cc).normalized()
					if EA.YB_BLADE.has(EA.shape_of(w)):
						var e = float(EA.edge_side(w)) * (-1.0 if P[3] else 1.0)
						var nrm = Vector2(cos(ang), sin(ang)) * e   # 刃口喺兵器本身 +x 邊（直企時），轉 ang 之後嘅法線
						var P0 = YBV.pose_of(look, c, w, H, fd, {"T": 1.0, "act": "atk", "ph": ph - 0.03, "tg": tgv})
						var lead = (ang - float(P0[1])) * e   # 揮緊嘅方向 × 刃口邊 > 0 ＝ 刃口行先
						if ph < 0.5 and nrm.dot(to_t) <= 0.0: bad_e.append([look, fd, ph, "揮落中刃口背住目標", nrm, to_t])
						if ph < 0.5 and lead <= 0.0: bad_e.append([look, fd, ph, "揮落時刀背行先", lead])
					elif ph == 0.58:
						var tip = Vector2(sin(ang), -cos(ang))
						if tip.dot(to_t) < 0.8: bad_e.append([look, fd, ph, "槍頭唔向目標", tip.dot(to_t)])
	_chk("漂浮兵器：刀類揮落時刃口向目標兼行先、槍頭向目標、待機喺面向邊（8 款 × 左右）", bad_e.is_empty(), bad_e)
	var bw = []
	for r in ["shi", "wei"]:
		for fd in [1.0, -1.0]:
			var look = YB.key("yuan", r); var H = YBV.h_of(look)
			var P = YBV.pose_of(look, "yuan", YBV.wea_of("yuan", r), H, fd, {"T": 1.0, "act": "idle", "tg": Vector2(fd * 3.0 * H, -0.5 * H)})
			var e = (-1.0 if P[3] else 1.0) * float(EA.edge_side(YBV.wea_of("yuan", r)))
			if Vector2(cos(P[1]), sin(P[1])).x * e * fd <= 0.0: bw.append([r, fd])
	_chk("弓：弓背面向左右都向目標", bw.is_empty(), bw)
	# ---- 階級按兵器檔★切換 ----
	YB.force_rank = ""
	var mv = S.get("mv"); var had = mv is Dictionary and mv.get("st") is Dictionary and mv.st.get(ML.SID) is Dictionary
	var keep = (mv.st[ML.SID] as Dictionary).duplicate() if had else null
	if not (S.get("mv") is Dictionary): S["mv"] = {}
	if not (S.mv.get("st") is Dictionary): S.mv["st"] = {}
	var seen = []
	for lvv in [1, 10, 25, 50, 100, 150, 200]:
		S.mv.st[ML.SID] = {"unlocked": true, "lv": float(lvv)}
		var uu = _yin(4); YB.assign(uu)
		seen.append([ML.tier_now(), YB.rank_now(), str(uu[0].yb_r)])
	var want = [["za"], ["za"], ["shi"], ["shi"], ["wei"], ["wei"], ["qin"]]; var rk_ok = true
	for i in seen.size(): rk_ok = rk_ok and seen[i][0] == i and seen[i][1] == want[i][0] and seen[i][2] == want[i][0]
	_chk("階級按兵器檔★切換：★0–1 雜兵、★2–3 士兵、★4–5 衛兵、★6 親兵（出擊小隊跟住換）", rk_ok, seen)
	S.mv.st[ML.SID] = {"unlocked": false, "lv": 200.0}
	_chk("兵器檔未開＝雜兵", YB.rank_now() == "za")
	if had: S.mv.st[ML.SID] = keep
	else: S.mv.st.erase(ML.SID)
	# ---- 純兵出擊 mk_squads ----
	YB.force_rank = "wei"
	var ms = RTS.mk_squads(8, 0)
	_chk("純兵出擊 mk_squads：8 隊按編制 3/2/2/1", _cnt(ms) == {"jin": 3, "zhong": 2, "yuan": 2, "yi": 1}, _cnt(ms))
	var hsum = 0.0; var asum = 0.0; var h0s = 0.0; var a0s = 0.0
	for u in ms: hsum += J.num(u.maxhp); asum += J.num(u.atk); h0s += J.num(u.maxhp) / J.num(u.yb_b.hk); a0s += J.num(u.atk) / J.num(u.yb_b.ak)
	_chk("mk_squads 加權後總戰力不變（血、攻 ±0.1%）", absf(hsum / h0s - 1.0) < 0.001 and absf(asum / a0s - 1.0) < 0.001, [hsum / h0s, asum / a0s])
	for pid in ["wall", "bow", "med"]:
		YB.set_preset(pid)
		var mp2 = RTS.mk_squads(8, 0); var hs2 = 0.0; var hb2 = 0.0
		for u in mp2: hs2 += J.num(u.maxhp); hb2 += J.num(u.maxhp) / J.num(u.yb_b.hk)
		_chk("編制「%s」總血都唔變" % pid, absf(hs2 / hb2 - 1.0) < 0.001, YB.split(8))
	YB.set_preset("std")
	YB.force_rank = "shi"
	# ---- 兵營面板 ----
	S.bld["barracks"] = maxf(1.0, J.num(S.bld.get("barracks", 0)))
	var vb = VBoxContainer.new(); m.add_child(vb)
	YB.box(vb, func(): pass)
	var txt = ""
	for n in vb.find_children("*", "RichTextLabel", true, false): txt += n.text
	_chk("兵營面板：顯示階級同兵種編制", txt.find(YB.T(YB.rank("shi").n)) >= 0 and txt.find(YB.T(YB.cls("yi").n)) >= 0, txt.substr(0, 80))
	_chk("兵營面板：有人數、下一階要幾多★、四兵種說明", txt.find("隊・") >= 0 and txt.find("★4") >= 0 and txt.find("名鬼") >= 0 and txt.find("射程 150") >= 0, txt.substr(0, 200))
	vb.queue_free()
	# ---- 真戰鬥：1-1 用 Battle.start 生單位 → RTS 模擬打到完 ----
	_team3(S)
	S.res["troops"] = 200.0
	S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
	await _f(t, 3)
	var Bt = J.G.get("Battle"); Bt["auto"] = true
	var snap = RTS._start_battle(func(): J.mc(Bt, "start", [0.0, 0.0]))
	var cc = _cnt(snap.units)
	_chk("真戰鬥：陰兵小隊按編制分兵種（8 隊）", cc.get("jin", 0) == 3 and cc.get("yi", 0) == 1, cc)
	var tg = ZD.stage_target()
	var op = SIM.new()
	op.setup(snap.units, RTS.stage_path(tg.pos + RTS.CAMP_OFF), tg.pos + RTS.CAMP_OFF, RTS.gate_pos())
	var h0 = YB.HEALS
	var fired = false; var healed = false; var med_swing = false; var nstep = 0
	while op.result == null and nstep < 30 * 200:
		op.step(1.0 / 30.0); nstep += 1
		for q in op.proj:
			if q.src is Dictionary and str(q.src.get("yb_c", "")) == "yuan": fired = true
			if q.src is Dictionary and str(q.src.get("yb_c", "")) == "yi": med_swing = true
		for u in op.units:
			if str(u.get("yb_c", "")) == "yi" and u.get("anim") != null: med_swing = true
	_chk("真戰鬥：打得完（有結果）", op.result != null, op.t)
	_chk("真戰鬥：弓弩手射飛彈", fired)
	_chk("真戰鬥：醫護兵從來唔出手", not med_swing)
	healed = YB.HEALS > h0
	_chk("真戰鬥：醫護兵有幫陰兵回血", healed, YB.HEALS - h0)
	var ok_sh = 0
	for k in ["jin", "zhong", "yuan", "yi"]:
		if cc.has(k): ok_sh += 1
	_chk("真戰鬥：四個兵種都有上陣", ok_sh == 4, cc)
	_p("真戰鬥結果 %s 時間 %.1f 秒 healed_ev=%s" % [str(op.result), op.t, str(healed)])
	if shots: await _shots(t, m)
	YB.force_rank = ""
	print("RESULT yinbing ok=%d bad=%d" % [ok, bad])

# ---- 實機截圖：真入口出擊，交戰時影（四個階級各一場，每場影三張：射箭、醫護回血）＋兵營面板 ----
func _shots(t, m) -> void:
	var S = J.G.S; var nv = m.village
	await _sheet(t, m, "idle"); await _sheet(t, m, "atk")
	for rk in ["za", "shi", "wei", "qin"]:
		YB.force_rank = rk
		S.res["troops"] = 200.0
		S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
		await _f(t, 3)
		var tg = ZD.stage_target()
		var c = nv.zone_cam()
		for i in 100:
			if RTS.op_for("1-1") == null: break
			await _w(t, 0.1)
		c.z = nv.size.x / 390.0; c.clamp_all()
		c.tgt = null; c.vel = Vector2.ZERO; c.center_on(tg.pos + Vector2(0, 160))
		await _w(t, 0.4)
		nv.zone_tap(c.w2s(tg.pos + Vector2(0, -60))); await _f(t, 2)
		RTS.card_go(); await _f(t, 2)
		var op = RTS.op_for("1-1")
		if op == null: _p("no op"); continue
		for i in 400:
			if op.phase != "march": break
			await _w(t, 0.1)
		for u in op.units:   # 截圖用：敵人血 ×3，打耐啲先影到射箭同回血（唔影響測試結果）
			if J.num(u.side) == 1: u["hp"] = J.num(u.hp) * 3.0; u["maxhp"] = J.num(u.maxhp) * 3.0
		c.tgt = null; c.vel = Vector2.ZERO; c.z = 3.0; c.x = op.anchor.x - c.vw() / 2.0; c.y = op.anchor.y + 30.0 - c.vh() / 2.0   # 截圖用：放大過遊戲上限（1.5），睇清楚兵種
		var h0 = YB.HEALS
		await _w(t, 1.6); await _shot(t, "fight_%s_a" % rk)
		var got = false
		for i in 120:   # 等有弓弩手飛彈喺天上＋醫護兵啱啱醫完（綠色 +數字）先影
			await _w(t, 0.05)
			var arrow = false
			for q in op.proj: if q.src is Dictionary and str(q.src.get("yb_c", "")) == "yuan": arrow = true
			if arrow and YB.HEALS > h0: got = true; break
			if i == 119: _p("no arrow+heal")
		await _shot(t, "fight_%s_b" % rk)
		_p("shot %s arrow+heal=%s heals=%d" % [rk, str(got), YB.HEALS - h0])
		await _w(t, 1.2); await _shot(t, "fight_%s_c" % rk)
		for i in 600:
			if op.phase in ["back", "done"] or RTS.op_for("1-1") == null: break
			await _w(t, 0.1)
		await _w(t, 0.5)
	# 兵營面板（衛兵階級、8 隊）
	YB.force_rank = ""
	var mv = S.get("mv")
	if mv is Dictionary and mv.get("st") is Dictionary: mv.st[ML.SID] = {"unlocked": true, "lv": 50.0}   # 兵器檔 ★3 → 士兵，下一階 ★4
	S.res["troops"] = 210.0
	S.bld["barracks"] = maxf(2.0, J.num(S.bld.get("barracks", 0)))
	BK.open_panel(); await _w(t, 0.8)
	var sc = m.sheet_scroll
	for n in m.sheet_body.find_children("*", "RichTextLabel", true, false):
		if str(n.text).find("陰兵兵種編制") >= 0: sc.scroll_vertical = int(n.global_position.y - m.sheet_body.global_position.y) - 12; break
	await _w(t, 0.5); await _shot(t, "barracks")
	sc.scroll_vertical += 300; await _w(t, 0.4); await _shot(t, "barracks2")
	m.close_sheet(); await _w(t, 0.3)

# 16 款對照（放大）：idle＝四兵種×四階級待機（面向右）；atk＝刀盾／長兵揮斬直刺中（面向右／左，紅點＝目標）
class Bg extends Control:
	var marks := []
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#3a3f36"))
		for p in marks: draw_circle(p, 7, Color("#c8483a"))
func _sheet(t, m, mode: String) -> void:
	var RV = load("res://game/rts/rts_view.gd")
	var cv = CanvasLayer.new(); cv.layer = 90; m.add_child(cv)
	var bg = Bg.new(); bg.size = Vector2(450, 975); cv.add_child(bg)
	var K = 2.2; var sols = []
	var cls = ["jin", "zhong", "yuan", "yi"]; var rks = ["za", "shi", "wei", "qin"]
	for ci in 4:
		for ri in 4:
			var fd = 1.0; var c = cls[ci]; var r = rks[ri]
			if mode == "atk": c = ["jin", "zhong"][ci % 2]; fd = 1.0 if ci < 2 else -1.0
			var cx = 56.0 + ri * 110.0; var y0 = 175.0 + ci * 205.0
			var x0 = cx - fd * 16.0
			var u = {"p": Vector2(x0, y0), "hp": 1.0, "maxhp": 1.0, "side": 0.0}
			if mode == "atk":
				var rw = Vector2(fd * 30.0, -17.0)   # 目標身體中間（相對腳底，世界 px）
				u["anim"] = {"name": "strike", "t": 0.05, "dur": 0.12, "tg": {"p": Vector2(x0, y0) + rw + Vector2(0, 20), "hp": 1.0, "minion": true}}
				bg.marks.append(Vector2(x0, y0) + rw * K)
			var sr = RV.SolRep.new(); sr.look = "yb_%s_%s" % [c, r]; sr.u = u; sr.dir = fd; sr.ph = 0.7 + ri * 0.3; sr.pose = "attack" if mode == "atk" else "stand"
			var holder = Node2D.new(); holder.position = Vector2(x0, y0); holder.scale = Vector2(K, K); bg.add_child(holder); holder.add_child(sr)
			sols.append(sr)
			var lb = Label.new(); lb.text = YB.name_of(c, r) + ("・向左" if fd < 0 else ""); lb.position = Vector2(cx - 53, y0 + 14); lb.size = Vector2(106, 20)
			lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lb.add_theme_font_size_override("font_size", 13); lb.add_theme_color_override("font_color", Color("#f0e2c8")); bg.add_child(lb)
	var hd = Label.new(); hd.position = Vector2(12, 8); hd.add_theme_font_size_override("font_size", 17); hd.add_theme_color_override("font_color", Color("#f0e2c8"))
	hd.text = "陰兵 16 款＋漂浮兵器（待機）" if mode == "idle" else "揮斬／直刺中：上兩行向右、下兩行向左\n紅點＝目標"
	bg.add_child(hd)
	await _w(t, 0.5)
	for sr in sols: sr.queue_redraw()
	await _f(t, 2)
	await _shot(t, "sheet_" + mode)
	cv.queue_free(); await _f(t, 2)
