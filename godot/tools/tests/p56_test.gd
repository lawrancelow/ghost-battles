# [p56] 會議第 0 批順暢修復 專項測試
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/p56_test.gd","logic"],["quit"]]
extends RefCounted

const NG = preload("res://native/game.gd")
const NEED = preload("res://game/onboard/need.gd")
var bad := 0
var rows := 0
var _saved := {}
func _p(s) -> void: print("[p56] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[p56]   %-46s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _S(): return J.G.get("S")

func logic(t) -> void:
	_saved = _S().duplicate(true)
	await econ_curve(t)
	await lack_hints(t)
	await recruit_why(t)
	for f in _extra: await call(f, t)
	var S = _S()
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])

var _extra: Array = ["power_tag", "sortie_keep", "story_busy", "hero_story_wpn", "tut_bubble"]

# ---------- 8. 升級曲線 ----------
func econ_curve(_t) -> void:
	_p("===== 8. 升級曲線：成本 vs 產量 =====")
	var S = _S(); var keep = S.bld.duplicate()
	S.bld["boss"] = 0.0
	var c1 = NG.up_cost("wood", 1.0); var c10 = NG.up_cost("wood", 10.0)
	var cr = J.num(c10.planks) / maxf(1.0, J.num(c1.planks))
	var m10 = NG.mult_lv(10.0)
	_p("  10 級板成本＝1 級 ×%.1f；產量 ×%.2f；成本÷產量 ×%.1f（舊 52÷3.7≈14）" % [cr, m10, cr / m10])
	_chk("10 級成本÷產量 ≤ 5", cr / m10 <= 5.0, "%.2f" % (cr / m10))
	_chk("mult 1 級＝1", absf(NG.mult_lv(1.0) - 1.0) < 1e-6)
	_chk("mult 單調遞增", NG.mult_lv(2.0) > 1.3 and NG.mult_lv(5.0) > NG.mult_lv(4.0))
	_chk("伐木場 1→2 級唔貴過舊", J.num(c1.planks) <= 23 and J.num(c1.coins) <= 26, str(c1))
	for l in [1, 2, 3, 5, 10]: _p("  Lv%d 升級：%s　產量 ×%.2f" % [l, str(NG.up_cost("wood", float(l))), NG.mult_lv(float(l))])
	for k in keep: S.bld[k] = keep[k]

# ---------- 7. 任務缺料指路 ----------
func lack_hints(_t) -> void:
	_p("===== 7. 任務缺料指路 =====")
	var S = _S(); var keepb = S.bld.duplicate(); var keepr = S.res.duplicate()
	var keepg = []
	for g in S.ghosts: keepg.append(g.get("post"))
	S.bld["home"] = 0.0; S.bld["plank"] = 1.0
	for g in S.ghosts: if str(g.get("post")) == "plank": g["post"] = null
	S.res["planks"] = 1.0; S.res["wood"] = 206.0; S.res["coins"] = 9999.0
	var q = {"t": "build", "b": "home", "text": "建造民宅", "go": "home"}
	var c = NEED.quest_cost(q)
	_chk("民宅任務有費用", not c.is_empty(), str(c))
	var nl = NEED.quest_lack(q)
	_chk("缺棺材板", str(nl.get("k", "")) == "planks", str(nl))
	_chk("上游＝棺材鋪", str(nl.get("up", "")) == "plank")
	_chk("提示講冇人做工＋親手做", str(nl.get("text", "")).find("沒人做工") >= 0 or str(nl.get("text", "")).find("冇人做工") >= 0, str(nl.get("text", "")))
	var sh = NEED.quest_short(q)
	_chk("任務條短句有「缺棺材板」", sh.find("缺棺材板") >= 0 and sh.find("棺材鋪") >= 0, sh)
	var QQ = J.G.get("Quest"); var ocur = QQ.get("cur")
	QQ["cur"] = func(_a, _b): return q
	var tgt = J.mc(J.G.get("Village"), "questTarget", [])
	var P = J.G.get("POS")
	_chk("箭頭指去棺材鋪", tgt is Array and J.num(tgt[0]) == J.num(P.plank[0]) and J.num(tgt[1]) == J.num(P.plank[1]), str(tgt))
	QQ["cur"] = ocur
	S.res["planks"] = 9999.0
	_chk("夠料就唔指路", NEED.quest_lack(q).is_empty())
	S.bld["home"] = 2.0
	_chk("已起好就唔計", NEED.quest_cost(q).is_empty())
	# 起建築失敗有提示
	S.bld["home"] = 0.0; S.res["planks"] = 1.0; J.G.erase("_p56_last_why")
	Menus.jn("bldAct", ["home", "build", null])
	_chk("起民宅失敗有提示", str(J.G.get("_p56_last_why", "")).find("棺材板") >= 0, str(J.G.get("_p56_last_why", "")))
	for k in keepb: S.bld[k] = keepb[k]
	for k in keepr: S.res[k] = keepr[k]
	for i in S.ghosts.size(): S.ghosts[i]["post"] = keepg[i]

# ---------- 1. 招魂失敗提示 ----------
func recruit_why(_t) -> void:
	_p("===== 1. 招魂失敗提示 =====")
	var S = _S(); var keepr = S.res.duplicate(); var keepb = S.bld.duplicate()
	S.bld["altar"] = 1.0; S.bld["home"] = 3.0; S.res["coins"] = 40.0; S.res["buns"] = 999.0
	J.G.erase("_p56_last_why")
	Menus.jn("bldAct", ["altar", "recruit", null])
	var w = str(J.G.get("_p56_last_why", ""))
	_chk("冥幣唔夠：講缺冥幣＋去邊攞", w.find("冥幣") >= 0 and w.find("化寶爐") >= 0, w)
	for k in keepr: S.res[k] = keepr[k]
	for k in keepb: S.bld[k] = keepb[k]

# ---------- 2. 建議戰力：穩贏線 ----------
func power_tag(_t) -> void:
	_p("===== 2. 建議戰力 =====")
	var CU = load("res://game/outpost/ctl_ui.gd")
	var i1 = CU.pow_info({"kind": "king", "my_pow": 525, "foe_pow": 500})
	_chk("525 對 500：唔再話勝算高", str(i1[1]) != "勝算高", str(i1))
	_chk("顯示穩贏線 600", str(i1[0]).find("600") >= 0, str(i1[0]))
	var i2 = CU.pow_info({"kind": "king", "my_pow": 610, "foe_pow": 500})
	_chk("610 對 500：勝算高", str(i2[1]) == "勝算高", str(i2))
	var i3 = CU.pow_info({"kind": "res", "my_pow": 100, "foe_pow": 100})
	_chk("資源區照舊（建議值）", str(i3[0]).find("100") >= 0, str(i3))
	var h = load("res://native/gpower.gd").hint(0.0)
	_chk("輸咗提示講出陣隊／陰兵", h.find("陰兵") >= 0, h)

# ---------- 3. 出擊照開工 ----------
func sortie_keep(_t) -> void:
	_p("===== 3. 出擊時產線照開工 =====")
	var S = _S(); var SP = load("res://game/rts/sortie_post.gd")
	var g = {"id": "t_p56x", "k": "xiaozhi", "name": "測試紙", "q": "藍", "lv": 3.0, "st": [30.0, 30.0, 30.0], "post": "bun", "spent": 0.0}
	S.ghosts.append(g)
	var keepb = J.num(S.bld.get("bun", 0)); S.bld["bun"] = maxf(1.0, keepb)
	var names = SP.borrow({"id": 9956}, [{"side": 0.0, "gid": "t_p56x"}])
	_chk("出擊後崗位保留（post=bun）", str(g.get("post")) == "bun", str(g.get("post")))
	_chk("借調訊息標明照開工", names.size() == 1 and names[0].size() > 2 and names[0][2] == true, str(names))
	var ws = J.cl(J.G.get("workersAt"), null, ["bun"])
	var inw = false
	for x in J.iter(ws): if str(x.get("id")) == "t_p56x": inw = true
	_chk("產量照計（workersAt 有佢）", inw)
	var spots = J.mc(J.G.get("Village"), "workerSpots", [])
	var drawn = false
	for sp in J.iter(spots): if sp.get("g") is Dictionary and str(sp.g.get("id")) == "t_p56x": drawn = true
	_chk("村入面唔畫（出擊緊）", not drawn)
	var bl = SP.busy_lines()
	SP.restore(9956)
	_chk("打完：仍喺包子鋪、冇借調記錄", str(g.get("post")) == "bun" and not (g.get("sortie") is Dictionary))
	S.ghosts.erase(g); S.bld["bun"] = keepb

# ---------- 4. 劇場都算劇情 ----------
func story_busy(t) -> void:
	_p("===== 4. 劇場（試用期合約）都算劇情 =====")
	var Th = J.G.get("Theater"); var m = t.get_tree().root.get_node_or_null("Main")
	var st = m.get("story") if m != null else null
	if Th == null or st == null: _chk("有 Theater／Story", false); return
	J.mc(Th, "play", [{"tag": "測試", "title": "測試", "bg": "village", "cast": [["阿福", "afu", null]], "lines": [["阿福", "測試"]]}, null])
	await t.get_tree().create_timer(0.3).timeout
	_chk("劇場播緊：Story.busy() = true", st.busy())
	_chk("G.story_busy 都係 true", G.story_busy.call())
	J.mc(Th, "close", [true])
	await t.get_tree().create_timer(0.2).timeout
	_chk("劇場關咗：唔再 busy", not st.busy())

# ---------- 5. 劇場主角唔畫漂浮兵器 ----------
func hero_story_wpn(t) -> void:
	_p("===== 5. 劇場主角唔畫漂浮兵器（以前似龐總揸斧頭）=====")
	var HV = load("res://game/soul/hero_vil.gd")
	if not HV.active(): _chk("主角空手圖有", false); return
	var c = Control.new(); c.size = Vector2(300, 400); t.get_tree().root.add_child(c)
	var res = []
	c.draw.connect(func():
		HV.story += 1; HV.draw(Ctx.new(c), 150.0, 300.0, 1.0, {"t": 0.0}); HV.story -= 1; res.append(HV.LAST.duplicate())
		HV.draw(Ctx.new(c), 150.0, 300.0, 1.0, {"t": 0.0}); res.append(HV.LAST.duplicate()))
	c.queue_redraw()
	for i in 4: await t.get_tree().process_frame
	_chk("劇場：冇漂浮兵器", res.size() >= 2 and str(res[0].get("wea", "x")) == "", str(res))
	_chk("村子：照有漂浮兵器", res.size() >= 2 and str(res[1].get("wea", "")) != "", str(res))
	_chk("story 計數歸零", HV.story == 0, HV.story)
	var src = FileAccess.get_file_as_string("res://native/skits.gd")
	_chk("劇場 draw_actor 包住 story 計數", src.find("HV.story += 1") >= 0)
	c.queue_free()

# ---------- 6. 教程時閒談泡唔出 ----------
func tut_bubble(t) -> void:
	_p("===== 6. 教程進行緊：閒談泡唔出 =====")
	var m = t.get_tree().root.get_node_or_null("Main")
	var vil = m.get("village") if m != null else null
	var tu = m.get_node_or_null("OnboardTut") if m != null else null
	if vil == null or tu == null or not vil.has_method("_tut_on"): _chk("有村子／教程", false); return
	var ov = tu.visible; var os_ = tu.shown
	tu.visible = true; tu.shown = true
	_chk("教程顯示 → _tut_on", vil._tut_on())
	tu.visible = false; tu.shown = false
	_chk("教程收埋 → 唔擋", not vil._tut_on())
	tu.visible = ov; tu.shown = os_
