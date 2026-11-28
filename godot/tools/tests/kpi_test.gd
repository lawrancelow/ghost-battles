# [kpi] 區域 KPI 閘門：考核牌、賄賂三檔（送啱／送錯）、拍照、抓包（各區後果）、逾期 Bryan 搶功、撕橫幅追回一半、開區（zone_cap 劇情）、龐總唔收賄賂、彩蛋
# 用法：bash tools/devkit/edtest.sh <godot目錄> kpi res://tools/tests/kpi_test.gd all 600
extends RefCounted

var ok := 0
var bad := 0
const KG = preload("res://game/kpi/kpi_data.gd")
const KU = preload("res://game/kpi/kpi_ui.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const M = preload("res://game/outpost/mat.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var SHOTS := "/tmp/kpi/shots/"
var _r := []   # 固定亂數序列

func _p(m): print("[kpi] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _rng(): return _r.pop_front() if _r.size() else 0.99

func _reset_state():
	var S = J.G.S
	S["kpi"] = null
	KG.enable(true)
	var z = ZD.st()
	for k in ["0:A", "0:B", "0:C"]: z.own.erase(k)
	KG.NEWS.clear()
func _fill(gid: String, extra := 0.0):   # 補夠指標
	for p in KG.progress(gid):
		var nd = {}
		for x in KG.gate(gid).need: if str(x.key) == p.key: nd = x
		var lack = float(p.need) - float(p.cur) + extra
		if lack <= 0: continue
		match str(nd.kind):
			"mat": M.add(p.key, lack)
			"res": KG.give(p.key, lack)
			"bld": J.G.S.bld[p.key] = float(p.need)
			"fn": KG.register_metric(p.key, func(): return float(p.need) + extra)
func _rich(): for m in ["m_wood", "m_rice", "m_plank", "m_bao"]: M.add(m, 2000.0); KG.give("coins", 5000.0)

func all(t) -> void:
	var eo = OS.get_environment("UX_OUT")
	if eo != "": SHOTS = eo
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var m = await PF.new()._boot(t)
	ZD.gate_on = false
	KG.rng_fn = func(): return _rng()
	var played = []
	KU.play_fn = func(sc, cb): played.append(sc.get("title", "")); if cb.is_valid(): cb.call()
	_reset_state()
	# ---- 資料 ----
	_chk("kpi.json 6 個閘門（陳不辦→何大睡→錢不漏→Dato'→糯婆→龐總）", KG.gates(0).map(func(g): return str(g.boss)) == ["chen", "he", "qian", "dato", "nuo", "pang"], KG.gates(0).map(func(g): return str(g.boss)))
	var miss = []
	for g in KG.gates(0):
		for suf in ["open", "pass"] + ([] if J.t(g.get("nobribe")) else ["bribe_ok", "bribe_fail", "caught"]):
			if KU.scene("kpi_%s_%s" % [g.boss, suf]).is_empty(): miss.append("%s_%s" % [g.boss, suf])
	_chk("每位考核官場景齊（巡查／賄賂成功／失敗／抓包／達標）", miss.is_empty(), miss)
	# 男女主分句
	J.G.S.hero["sex"] = "m"; var sm = KU.scene("kpi_chen_open").lines.map(func(l): return l[1])
	J.G.S.hero["sex"] = "f"; var sf = KU.scene("kpi_chen_open").lines.map(func(l): return l[1])
	J.G.S.hero["sex"] = "m"
	_chk("男女主台詞分開（陳不辦巡查）", sm.has("我已經三天沒停手了。") and not sm.any(func(x): return x.begins_with("根據施工紀錄")) and sf.any(func(x): return x.begins_with("根據施工紀錄")) and not sf.has("我已經三天沒停手了。"))
	J.G.S.hero["sex"] = "f"
	var nuo = KU.scene("kpi_nuo_bribe_ok").lines.map(func(l): return l[1])
	J.G.S.hero["sex"] = "m"
	_chk("女主版「大小姐」替換", nuo.any(func(x): return x.find("大小姐") >= 0) and not nuo.any(func(x): return x.find("{少爺}") >= 0))
	# ---- 閘門：關咗時舊流程照舊 ----
	J.G.S.kpi.on = false
	_chk("KPI 關：資源區照舊可以攻佔（唔閘）", not KG.gated("A") and KG.is_open("market"))
	J.G.S.kpi.on = true
	_chk("KPI 開：A 區由考核開，攻佔回 kpi", KG.gated("A") and ZD.capture_auto("A") == "kpi" and ZD._start_battle("cap", "A") == "kpi")
	_chk("次序：只有第一個閘門 active", KG.active("A") and not KG.active("B") and KG.active_gate() == "A")
	_chk("酒館／大排檔 flag 未開", not KG.is_open("tavern") and not KG.is_open("market"))
	# ---- 開考核卡：第一次播巡查＋開始倒數 ----
	played.clear()
	KU.open(m, "A")
	_chk("第一次撳考核牌：播巡查、開始倒數、彈考核卡", played.size() == 1 and J.t(KG.gs("A").started) and m.sheet.visible, played)
	await _w(t, 0.3); await _shot(t, "sheet_A")
	m.close_sheet()
	# ---- 指標：陳不辦（修好建築 6、民宅 1）----
	KG.register_metric("rebuilt", func(): return 3.0)
	J.G.S.bld["home"] = 0.0
	var p0 = KG.progress("A")
	_chk("指標進度：修好建築 3/6、民宅 0/1", p0[0].cur == 3.0 and p0[0].need == 6 and p0[1].need == 1 and not KG.all_met("A"), p0)
	_chk("未達標交考核唔得", not KG.submit("A").ok)
	# ---- 賄賂：名牌送馬面＝失敗（退回）----
	_rich()
	var c0 = KG.amt_of("coins")
	var o = KG.bribe("A", "watch", "ma")
	_chk("名錶送馬面：失敗、禮物退回（冥幣冇少）", o.res == "fail" and absf(KG.amt_of("coins") - c0) < 0.5, o)
	_chk("失敗後本區打點機會用咗", KG.can_bribe("A") == "used")
	# ---- 點心送馬面：最差一項 -20% ----
	_reset_state(); _rich(); KG.register_metric("rebuilt", func(): return 3.0); J.G.S.bld["home"] = 0.0; KG.start("A")
	o = KG.bribe("A", "snack", "ma")
	_chk("點心送馬面：最差一項（民宅 0/1 或建築 3/6）-20%", o.res == "ok" and o.eff == "cut1" and absf(J.num(o.val) - 0.2) < 0.001, o)
	var pk = KG.progress("A").filter(func(p): return p.key == o.key)[0]
	_chk("被減嗰項 need = ceil(base × 0.8)", pk.need == int(ceil(pk.base * 0.8 - 0.0001)), pk)
	# ---- 點心送牛頭（送錯）：-10% ----
	_reset_state(); _rich(); KG.register_metric("rebuilt", func(): return 3.0); J.G.S.bld["home"] = 0.0; KG.start("A")
	o = KG.bribe("A", "snack", "niu")
	_chk("點心送牛頭（送錯）：效果減半 -10%", o.res == "ok" and J.t(o.half) and absf(J.num(o.val) - 0.1) < 0.001, o)
	# ---- 名錶送牛頭：免考一項；拍照 → 下一區 +10% ----
	_reset_state(); _rich(); KG.register_metric("rebuilt", func(): return 3.0); J.G.S.bld["home"] = 1.0; KG.start("A")
	_r = [0.1]   # < 0.2 → 拍照
	o = KG.bribe("A", "watch", "niu")
	_chk("名錶送牛頭：最差一項（修好建築）免考", o.res == "ok" and o.eff == "skip1" and o.key == "rebuilt" and KG.all_met("A"), o)
	_chk("馬面拍照存證（20% 抽中）", J.t(o.get("photo")))
	var po = KG.submit("A")
	_chk("交考核：A 區開放（set_owned）＋zone_cap 劇情事件", po.ok and ZD.owned("A") and ZD.EV_LOG.any(func(e): return e[0] == "zone_cap" and e[1] == "A"), po)
	_chk("下一區（何大睡）KPI +10%：竹子 33、竹篾 11", KG.progress("B")[0].need == 33 and KG.progress("B")[1].need == 11, KG.progress("B"))
	_chk("B 區而家 active", KG.active("B") and KG.gated("B"))
	# ---- 跑車：抓包（何大睡反轉：KPI 減半）----
	KG.start("B")
	_r = [0.1]   # < 0.3 → 撞破
	o = KG.bribe("B", "car", "niu")
	_chk("跑車送牛頭被何大睡撞破：反而 KPI 減半（竹子 33→17）", o.res == "caught" and KG.progress("B")[0].need == 17, [o, KG.progress("B")])
	_chk("抓包後下次打點半價", absf(J.num(KG.st().disc) - 0.5) < 0.001 and J.num(KG.bribe_cost("car").coins) == ceilf(650 * 0.5))
	# ---- 逾期：Bryan 搶功 ----
	var before = {}
	for mm in KG.STEAL_POOL: before[mm] = KG.amt_of(mm)
	var best = ""; var bv = 0.0
	for mm in KG.STEAL_POOL: if before[mm] > bv: bv = before[mm]; best = mm
	KG.gs("B")["left"] = 0.5
	KG.tick(1.0)
	var n = KG.NEWS.filter(func(x): return x.kind == "bryan")
	_chk("倒數完：Bryan 搶走最多嗰樣資源 10%（%s）" % best, n.size() == 1 and n[0].mid == best and int(n[0].n) == int(floorf(bv * 0.1)) and absf(KG.amt_of(best) - (bv - floorf(bv * 0.1))) < 0.5, [n, bv])
	_chk("倒數重來、村口掛 Bryan 橫幅", J.num(KG.gs("B").left) == 1200.0 and KG.banner_on())
	m.village.queue_redraw(); await _w(t, 0.5)
	_chk("村口畫咗「本月最佳員工：Bryan」", ZV.fog_log.any(func(e): return e[0] == "bryan"))
	await _shot(t, "bryan_banner")
	# eat_news 第一次 Bryan 播劇情
	played.clear(); KG.gs("B")["left"] = 0.1; KU.eat_news(m); await _w(t, 0.2); KU.eat_news(m)
	_chk("Bryan 第二次搶功：唔再播劇情（淨係提示）", not played.has("本月最佳員工"), played)
	var stolen = J.num(KG.gs("B").stolen.get(best, 0))
	# ---- 達標：撕橫幅、追回一半 ----
	_fill("B")
	var bb = KG.amt_of(best)
	played.clear()
	KU._submit(m, "B")
	_chk("達標：B 區開放、追回被搶一半、橫幅撕走", ZD.owned("B") and absf(KG.amt_of(best) - (bb + floorf(stolen * 0.5))) < 0.5 and not KG.banner_on(), [stolen, bb, KG.amt_of(best)])
	_chk("達標劇情＋撕橫幅劇情", played.has("達標") and played.has("撕橫幅"), played)
	# ---- 錢不漏：巡查扣 42 冥幣、抓包＝禮物充公 ----
	var cb0 = KG.amt_of("coins")
	KG.start("tavern")
	_chk("錢不漏巡查：扣路費茶水費 42 冥幣", absf(cb0 - KG.amt_of("coins") - 42.0) < 0.5)
	_r = [0.1]
	var cc = KG.amt_of("coins")
	o = KG.bribe("tavern", "car", "niu")
	_chk("跑車（半價）被漏哥撞破：禮物充公（冥幣少咗）、KPI 冇變", o.res == "caught" and KG.amt_of("coins") < cc and KG.progress("tavern")[0].need == 20, o)
	_fill("tavern"); KG.submit("tavern")
	_chk("酒館 flag 開咗", KG.is_open("tavern") and not KG.is_open("market"))
	# ---- Dato'：抓包可以再送一次 ----
	KG.start("C"); _r = [0.1]
	o = KG.bribe("C", "car", "niu")
	_chk("Dato' 被龐總撞破：可以再送一次", o.res == "caught" and KG.can_bribe("C") == "" and J.t(KG.gs("C").rebribe))
	_r = [0.1]   # 再送：唔會再撞破
	o = KG.bribe("C", "car", "niu")
	_chk("再送一次：唔會再被撞破、全部 -40%", o.res == "ok" and o.eff == "cutall")
	_fill("C"); KG.submit("C")
	_chk("C 區開放", ZD.owned("C"))
	# ---- 糯婆：抓包 KPI 加 50 包 ----
	KG.start("final"); _r = [0.1]
	var bao0 = KG.progress("final")[1].need
	o = KG.bribe("final", "car", "niu")
	_chk("糯婆抓包：普通包子 KPI +50", KG.progress("final")[1].need == bao0 + 50, [bao0, KG.progress("final")[1].need])
	_fill("final"); KG.submit("final")
	_chk("龐總總考核 flag（pang）開咗", KG.is_open("pang") and KG.active("market"))
	# ---- 龐總：唔收賄賂 ----
	_chk("龐總唔可以賄賂", KG.can_bribe("market") == "nobribe" and not KG.bribe("market", "snack", "ma").ok)
	var g0 = KG.gift_pang("market")
	_chk("送龐總包子：只記誠信檔案（指標冇變）", g0.ok and J.num(KG.st().honest) == 1.0)
	# ---- 彩蛋：五區都賄賂成功過 ----
	for b in ["chen", "he", "qian", "dato", "nuo"]: KG.st().ok_n[b] = true
	_fill("market")
	played.clear()
	KU._submit(m, "market")
	_chk("龐總達標：大排檔 flag 開＋五區都打點成功彩蛋", KG.is_open("market") and played.has("誠信檔案"), played)
	_chk("全部閘門達標", KG.active_gate() == "")
	# ---- 舊存檔遷移：已佔領 B → A、B 當達標 ----
	J.G.S["kpi"] = null
	KG.enable(true)
	_chk("enable 遷移：已佔領 A/B/C → 前面閘門當達標", KG.passed("A") and KG.passed("B") and KG.passed("C") and KG.passed("tavern"))
	# ---- 考核卡截圖（中段狀態）----
	_reset_state(); _rich(); KG.register_metric("rebuilt", func(): return 4.0); J.G.S.bld["home"] = 0.0
	KG.start("A"); KG.gs("A").left = 734.0
	KG.gs("A")["bryan"] = 1.0; KG.gs("A").stolen["m_wood"] = 120.0
	KU._sheet(m, "A"); await _w(t, 0.4); await _shot(t, "sheet_A_mid")
	m.close_sheet()
	# 霧上面嘅考核牌
	var cam = m.village.zone_cam() if m.village.has_method("zone_cam") else null
	var za = ZD.rect(ZD.zone("A").rect)
	if cam != null:
		cam.z = m.village.size.x / 390.0; cam.vel = Vector2.ZERO; cam.center_on(za.get_center())
	m.village.queue_redraw(); await _w(t, 0.6)
	_chk("A 區霧上面畫考核牌（取代建議戰力）", ZV.fog_log.any(func(e): return e[0] == "kpi" and e[1] == "A"))
	await _shot(t, "fog_A_kpi")
	KU.play_fn = Callable(); KG.rng_fn = Callable()
	J.G.S.kpi.on = false
	_p("RESULT ok=%d bad=%d" % [ok, bad])
