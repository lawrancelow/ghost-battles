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

var _extra: Array = ["work_shots", "power_tag", "sortie_keep", "story_busy", "hero_story_wpn", "tut_bubble", "bar_layout", "toast_avoid", "home_cost"]

# ---------- 8. 升級曲線 ----------
func econ_curve(_t) -> void:
	_p("===== 8. 升級曲線：成本 vs 產量 =====")
	var S = _S(); var keep = S.bld.duplicate()
	S.bld["boss"] = 0.0
	var c1 = NG.up_cost("wood", 1.0); var c10 = NG.up_cost("wood", 10.0)
	var c2 = NG.up_cost("wood", 2.0)
	_chk("[p56b] 1→2 級板半價（≤12）、冥幣照舊", J.num(c1.planks) <= 12 and J.num(c1.coins) >= 24, str(c1))
	_chk("[p56b] 2 級以上成本冇變（2→3 級 64 板）", int(J.num(c2.planks)) == int(round(25 * pow(2.0, 1.5) * 0.9)), str(c2))
	var cr = J.num(c10.planks) / maxf(1.0, round(25 * 0.9))   # 對比未打折嘅 1 級基數
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

# ---------- 9. 主角做嘢（斬樹／割禾／做板／搓包）：空手＋工具浮喺旁邊（男女主）----------
func work_shots(t) -> void:
	_p("===== 9. 主角做工動畫：空手＋漂浮工具 =====")
	var HV = load("res://game/soul/hero_vil.gd"); var WA = load("res://game/outpost/work_anim.gd")
	var S = _S(); var keep_h = S.get("hero", {}).duplicate() if S.get("hero") is Dictionary else {}
	if not (S.get("hero") is Dictionary): S["hero"] = {}
	DirAccess.make_dir_recursive_absolute("/tmp/p56shots")
	for sex in ["m", "f"]:
		S.hero["sex"] = sex
		_chk("主角（%s）用空手圖" % sex, HV.active())
		var c = Control.new(); c.size = Vector2(720, 260); t.get_tree().root.add_child(c)
		var info = []
		c.draw.connect(func():
			c.draw_rect(Rect2(Vector2.ZERO, c.size), Color(0.35, 0.33, 0.3))
			var i = 0
			for pose in ["chop", "reap", "hammer", "knead"]:
				for pt in [0.15, 0.55]:
					HV.draw(Ctx.new(c), 50.0 + i * 88.0, 220.0, 1.0, {"t": 1.0, "pose": pose, "pt": pt})
					info.append([pose, pt, HV.LAST.duplicate(), WA.LAST.get("afu", {}).get("tools", -1)])
					i += 1)
		c.queue_redraw()
		for k in 4: await t.get_tree().process_frame
		await RenderingServer.frame_post_draw
		var img = t.get_viewport().get_texture().get_image()
		img.get_region(Rect2i(0, 0, 720, 260)).save_png("/tmp/p56shots/work_%s.png" % sex)
		var bad = []
		for x in info: if str(x[2].get("mode", "")) != "work": bad.append(x)
		_chk("主角（%s）做嘢行做工動畫（工具浮喺旁，唔係揸住）" % sex, bad.is_empty() and info.size() >= 8, str(bad))
		c.queue_free()
	S["hero"] = keep_h

# ---------- 10. [p56b] 任務條：最長缺料文案唔出格、唔切字 ----------
func bar_layout(t) -> void:
	_p("===== 10. 任務條最長缺料文案排版 =====")
	var m = t.get_tree().root.get_node_or_null("Main")
	if m == null or m.get("quest_lbl") == null: _chk("有任務條", false); return
	var S = _S(); var keepb = S.bld.duplicate(); var keepr = S.res.duplicate()
	# 最長組合：最長主線句＋缺 5 位數＋最長上游建築名
	var longest = ""
	var QL = J.G.get("QUESTS")
	for q0 in J.iter(QL):
		if q0 is Dictionary and str(q0.get("text", "")).length() > longest.length(): longest = str(q0.get("text", ""))
	if longest.length() < 16: longest = "建造包子鋪（出普通包子）（增加雜鬼名額）"
	var vp = m.get_viewport_rect().size
	for cs in [["home", "planks", "plank"], ["altar", "bao", "bun"]]:
		S.bld[cs[0]] = 0.0; S.bld[cs[2]] = 1.0
		for k in S.res.keys(): S.res[k] = 0.0
		var BLD = J.G.get("BUILDINGS"); var keepc = BLD[cs[0]].get("build")
		BLD[cs[0]]["build"] = {cs[1]: 99999.0}
		var q = {"t": "build", "b": cs[0], "text": longest, "go": cs[0], "r": {}}
		var ql = m.quest_lbl; var qb = m.quest_bar
		var want = longest + m._quest_lack_line(q)   # 同 refresh() 同一條砌字路
		var setter = func():   # 每幀畫之前核對：俾 refresh() 蓋走先寫返（每幀照寫會令 RichTextLabel 不停重排、高度永遠未更新）
			if str(ql.text) != want: ql.text = want
			if str(m.quest_prog.text) != "99999/99999": m.quest_prog.text = "99999/99999"
		RenderingServer.frame_pre_draw.connect(setter)
		for i in 8: await t.get_tree().process_frame
		await RenderingServer.frame_post_draw
		RenderingServer.frame_pre_draw.disconnect(setter)
		setter.call()
		var sh = NEED.quest_short(q)
		var ptxt = ql.get_parsed_text()
		_chk("%s：短句有出（%s）" % [cs[1], sh], sh != "" and ptxt.find(sh.trim_prefix("（").trim_suffix("）").replace("→", " → ")) >= 0, ptxt)
		_chk("%s：內容闊度 ≤ 標籤闊度" % cs[1], ql.get_content_width() <= ql.size.x + 1.0, [ql.get_content_width(), ql.size.x])
		_chk("%s：內容高度 ≤ 標籤高度（冇切行）" % cs[1], ql.get_content_height() <= ql.size.y + 1.0, [ql.get_content_height(), ql.size.y])
		var lr = ql.get_global_rect(); var br = qb.get_global_rect()
		_chk("%s：標籤喺任務條入面、任務條喺畫面入面" % cs[1], br.grow(1.0).encloses(lr) and br.position.x >= 0 and br.end.x <= vp.x + 0.5, [lr, br, vp])
		_chk("%s：冇撞「前往」掣／進度數字" % cs[1], not lr.intersects(m.quest_go.get_global_rect()) and not lr.intersects(m.quest_prog.get_global_rect()))
		_chk("%s：缺料行字號 ≥ 13" % cs[1], str(ql.text).find("[font_size=13]") >= 0)
		if OS.has_environment("P56_SHOTS"):
			await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png("/tmp/p56shots/bar_%s.png" % cs[1])
		BLD[cs[0]]["build"] = keepc
	for k in keepb: S.bld[k] = keepb[k]
	for k in keepr: S.res[k] = keepr[k]
	m.refresh()

# ---------- 11. [p56b] 提示框唔遮「出擊」掣 ----------
func toast_avoid(t) -> void:
	_p("===== 11. 提示框避開出擊掣 =====")
	var m = t.get_tree().root.get_node_or_null("Main")
	if m == null or m.get("toasts") == null: _chk("有提示層", false); return
	var sb = m.find_child("CtlSortie", true, false)
	if sb == null: _chk("有出擊掣", false); return
	var ov = sb.visible
	for vis in [true, false]:
		sb.visible = vis
		for c in m.toasts.get_children(): c.free()
		for i in 3: m.show_toast("還差 冥幣 99999（大排檔賣貨，或化寶爐收陽間包裹），普通包子 99999（包子鋪沒人做工：派鬼去做，或親手包 4 糯米→2 包）第 %d 條" % i)
		for i in 6:
			await t.get_tree().process_frame
			if OS.has_environment("P56_DBG"): _p("  dbg f%d ob=%s sbvis=%s tree=%s proc=%s n=%d" % [i, str(m.toasts.offset_bottom), str(sb.visible), str(sb.is_visible_in_tree()), str(m.is_processing()), m.toasts.get_child_count()])
		var hit = false; var top = 1e9; var n = 0
		for c in m.toasts.get_children():
			var r = c.get_global_rect(); n += 1; top = minf(top, r.position.y)
			if vis and sb.is_visible_in_tree() and r.intersects(sb.get_global_rect()): hit = true
		var on = sb.is_visible_in_tree()
		if vis: _chk("出擊掣顯示得到（測試前提）", on)
		if on:
			_chk("出擊掣顯示：3 條長提示都唔遮掣", n == 3 and not hit, [n, sb.get_global_rect(), m.toasts.get_global_rect()])
			_chk("提示框底邊喺出擊掣上面", m.toasts.get_global_rect().end.y <= sb.get_global_rect().position.y - 4.0, [m.toasts.get_global_rect().end.y, sb.get_global_rect().position.y])
			if vis and OS.has_environment("P56_SHOTS"):
				await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png("/tmp/p56shots/toast_avoid.png")
		else:
			_chk("出擊掣收埋：提示框返原位（底邊 -86）", absf(m.toasts.offset_bottom + 86.0) < 1.0, m.toasts.offset_bottom)
		_chk("提示框冇頂出畫面頂（掣%s）" % ("顯示" if vis else "收埋"), top >= 0.0, top)
	for c in m.toasts.get_children(): c.free()
	sb.visible = ov

# ---------- 12. [p56c] 民宅建造成本 60 → 36 棺材板：數值同顯示一致 ----------
func home_cost(_t) -> void:
	_p("===== 12. 民宅建造成本 36 板 =====")
	var S = _S(); var keepb = S.bld.duplicate(); var keepr = S.res.duplicate()
	var BLD = J.G.get("BUILDINGS")
	var c = BLD["home"].get("build")
	_chk("民宅建造成本＝{planks:36}", c is Dictionary and c.size() == 1 and int(J.num(c.get("planks", 0))) == 36, str(c))
	_chk("data/core.json 同運行時一致", int(J.num(DB.D.BUILDINGS.home.build.planks)) == 36, str(DB.D.BUILDINGS.home.build))
	S.bld["home"] = 0.0; S.bld["plank"] = 1.0; S.res["planks"] = 1.0
	var q = {"t": "build", "b": "home", "text": "建造民宅", "go": "home", "r": {}}
	_chk("任務費用＝36 板", int(J.num(NEED.quest_cost(q).get("planks", 0))) == 36, str(NEED.quest_cost(q)))
	_chk("任務條短句：缺棺材板 35", NEED.quest_short(q).find("缺棺材板 35") >= 0, NEED.quest_short(q))
	_chk("失敗提示：還差 棺材板 35", NEED.bld_why("home", "build").find("棺材板 35") >= 0, NEED.bld_why("home", "build"))
	_chk("村子資料檔（data/nat/data.json）＝36", int(J.num(JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/data.json")).get("BUILDINGS", {}).get("home", {}).get("build", {}).get("planks", 0))) == 36)
	S.res["planks"] = 35.0
	_chk("35 板：付唔起（提示仲差 1）", NEED.hint(c).find("棺材板 1") >= 0, NEED.hint(c))
	S.res["planks"] = 36.0
	_chk("36 板：夠料（冇缺料提示）", NEED.hint(c) == "" and NEED.quest_lack(q).is_empty(), NEED.hint(c))
	for k in keepb: S.bld[k] = keepb[k]
	for k in keepr: S.res[k] = keepr[k]
