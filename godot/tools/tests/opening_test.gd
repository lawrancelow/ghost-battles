# [opening] 測試：大排檔前大更新劇情（新開場男女各一遍、名字替換、舊存檔唔觸發、第 6 章孟婆呼應、掛鈎事件）
# 用法：bash godot/tools/devkit/edtest.sh <godot目錄> opening res://tools/tests/opening_test.gd all 600
#   截圖：/home/claude/docs/shots/opening/
extends "res://tools/tests/eqview2_test.gd"

const NC = preload("res://ui/name_card.gd")
const PS = preload("res://game/onboard/prestall_story.gd")
const STG = preload("res://ui/story.gd")
const SH := "/home/claude/meeting/vil2/opening/"
const OM := ["op2_road", "op2_lobby", "op2_office", "op2_soup", "op2_exile", "op2_arrive"]
const OF := ["opf2_road", "opf2_lobby", "opf2_office", "opf2_soup", "opf2_exile", "opf2_arrive"]

func _p(m): print("[op] ", m)

func all(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH)
	_data()
	_no_braces()
	_names()
	_oldsave()
	_mengpo()
	_hooks(m)
	await _surfaces(t, m)
	await _plaque(t, m)
	await _play(t, m, "m")
	await _play(t, m, "f")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _scenes() -> Dictionary: return DB.D.SCENES

# 數據：場景齊、開場列表換咗、粵語欄留空、插圖佔位存在
func _data() -> void:
	var SC = _scenes()
	for id in OM + OF + ["joss_reopen", "joss_reopen_f", "joss_shift", "tav_open", "stall_hook"]:
		_chk("場景 " + id, SC.has(id) and (SC[id].lines as Array).size() > 0)
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate()
	S["hero"] = {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": true}
	var a = NC.opening(S)
	_chk("男開場：黃泉路改新版", not a.has("prologue_road") and a.slice(a.find("op2_road"), a.find("op2_road") + 6) == OM and a[-1] == "prologue_sys", a)
	S["hero"] = {"name": "阿慧", "full": "陳嘉慧", "en": "", "sex": "f", "set": true}
	a = NC.opening(S)
	_chk("女開場：用女主自己嘅場景", not a.has("prologue_road") and not a.has("op2_road") and a.slice(a.find("opf2_road"), a.find("opf2_road") + 6) == OF, a)
	S["hero"] = h0
	var Y = DB.D.get("LANG_YUE", {})
	_chk("粵語欄：新句已登記、留空", Y is Dictionary and Y.has(SC.op2_soup.lines[0][1]) and str(Y[SC.op2_soup.lines[0][1]]) == "")
	var nph = 0; var nbad = 0
	for id in OM + OF + ["joss_reopen", "joss_reopen_f", "tav_open", "stall_hook"]:
		var cg = SC[id].get("cg", {})
		for k in cg:
			var sp = cg[k]
			if sp is Dictionary and sp.has("ph"):
				nph += 1
				if not Spr.ok(str(sp.ph)): nbad += 1
	_chk("插圖佔位圖都存在", nph >= 10 and nbad == 0, "ph=%d 缺=%d" % [nph, nbad])
	var ch1 = DB.D.get("CHAPTERS", [])
	if not (ch1 is Array) or ch1.is_empty(): ch1 = J.G.get("CHAPTERS", [])
	_chk("stall_hook 唔放章節開場（改由大排檔開張 tick 播）", ch1 is Array and ch1.size() > 0 and not (ch1[0].intro as Array).has("stall_hook"), ch1[0].intro if ch1 is Array and ch1.size() > 0 else "")

# 數據：新場景（講者／對白／中文對照）一律唔准有 {xxx} 佔位
func _no_braces() -> void:
	var bad: Array = []
	var re = RegEx.new(); re.compile("[{}]")
	for id in OM + OF + ["joss_reopen", "joss_reopen_f", "joss_shift", "tav_open", "stall_hook", "ch6_mengpo"]:
		var sc = _scenes().get(id)
		if not (sc is Dictionary): continue
		for ln in sc.lines:
			for i in mini(2, (ln as Array).size()):
				if ln[i] is String and re.search(ln[i]) != null: bad.append("%s:%s" % [id, ln[i]])
	_chk("新場景冇 {xxx} 佔位", bad.is_empty(), bad.slice(0, 5))
	var miss: Array = []
	for k in ["cg_ruins", "cg_b2_soup", "cg_lobby_f", "cg_office_f", "cg_exile_f", "cg_soup_f", "cg_joss_flood_f", "cg_joss_note_f", "cg_stall_hook_f", "cg_tavern_f", "cg_c1_bribe", "cg_c2_bribe", "cg_bribe_f", "cg_lobby", "cg_stall_hook", "cg_pang_visit", "cg_joss_flood", "cg_joss_note_m", "cg_caught", "cg_he_wake", "cg_qian_bite", "cg_office", "cg_exile", "cg_tavern", "cg_road", "cg_road_f", "cg_joss_ruin", "cg_note", "cg_dato_plaque", "cg_nuopo_taste"]:
		if not Spr.ok(k): miss.append(k)
	_chk("美術新圖已入 manifest", miss.is_empty(), miss)
	# 全部場景（唔止新場景）：講者、對白都唔准有花括號佔位
	var bad2: Array = []
	for id in _scenes():
		var sc2 = _scenes()[id]
		if not (sc2 is Dictionary) or not (sc2.get("lines") is Array): continue
		for ln in sc2.lines:
			if not (ln is Array): continue
			for i in mini(2, ln.size()):
				if ln[i] is String and (ln[i].contains("{主角") or ln[i].contains("｛主角")): bad2.append("%s:%s" % [id, ln[i]])
	_chk("全部場景冇 {主角} 佔位", bad2.is_empty(), bad2.slice(0, 5))
	# 防呆：就算文案再寫 {主角}，出口（名牌、對白、任務欄、提示都經 DB.N）一樣換成玩家名
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate()
	S["hero"] = {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": true}
	_chk("防呆：預設男主 {主角}→阿福", str(DB.N("{主角}")) == "阿福" and str(DB.N("{主角}，你來了。")) == "阿福，你來了。", DB.N("{主角}"))
	S["hero"] = {"name": "阿明", "full": "李大明", "en": "Ming", "sex": "m", "set": true}
	_chk("防呆：改名男主 {主角}→阿明", str(DB.N("{主角}")) == "阿明" and str(DB.N("{主角全名}")) == "李大明", DB.N("{主角}"))
	S["hero"] = {"name": "小慧", "full": "林慧", "en": "", "sex": "f", "set": true}
	_chk("防呆：女主 {主角}→小慧", str(DB.N("{主角}")) == "小慧" and not str(DB.N("找{主角}談談")).contains("{"), DB.N("{主角}"))
	S["hero"] = h0
	# 待審：未選定嘅插圖有 rv 欄；已選用（A1 荒村廢墟 cg_ruins）冇
	var nrv = 0; var ruins_rv = false
	for id in OM + OF + ["joss_reopen", "joss_reopen_f", "tav_open", "stall_hook"]:
		var cg = _scenes()[id].get("cg", {})
		for k in cg:
			if cg[k] is Dictionary and str(cg[k].get("rv", "")) != "":
				nrv += 1
				if str(cg[k].get("k", "")) == "cg_ruins": ruins_rv = true
	_chk("待審清零：全部開場／化寶爐／酒館／大排檔插圖都係定稿（冇 rv）", nrv == 0, nrv)

# 名字替換：改名、女主版
func _names() -> void:
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate(); var l0 = DB.lang
	DB.lang = "zh"
	S["hero"] = {"name": "阿明", "full": "李大明", "en": "Ming", "sex": "m", "set": true}
	var txt = ""
	for id in OM: for l in _scenes()[id].lines: txt += str(DB.N(l[0])) + str(DB.L(l[1]))
	_chk("男主改名：對白同名牌都換晒", txt.contains("李大明") and txt.contains("阿明") and not txt.contains("阿福") and not txt.contains("陳大福"))
	S["hero"] = {"name": "小慧", "full": "林慧", "en": "", "sex": "f", "set": true}
	txt = ""
	for id in OF: for l in _scenes()[id].lines: txt += str(DB.N(l[0])) + str(DB.L(l[1]))
	_chk("女主改名", txt.contains("林慧") and txt.contains("小慧") and not txt.contains("阿福") and not txt.contains("陳大福"))
	var t1 = str(DB.L("那碗東西像茶水間的杯底。"))
	_chk("女主整句換（酒館）", t1 == "那碗東西沒有成分表。", t1)
	var t2 = str(DB.L(_scenes().joss_reopen.lines[13][1]))
	_chk("女主：小紙叫大小姐", t2.contains("大小姐") and not t2.contains("少爺"), t2)
	DB.lang = "yue"
	var t3 = str(DB.L(_scenes().op2_soup.lines[0][1]))
	_chk("粵語未補：照出中文", t3 == "它在冒泡。", t3)
	var t4 = str(DB.L("取號。"))
	_chk("粵語欄有填：出粵語", t4 == "攞籌。", t4)
	DB.lang = "zh"
	var t5 = ""
	for l in _scenes().joss_reopen.lines: t5 += str(l[1])
	_chk("原文係書面中文（信件冇粵語口語）", not (t5.contains("唔") or t5.contains("喺") or t5.contains("啲")))
	DB.lang = l0; S["hero"] = h0

# 舊存檔：睇過 prologue_sys／有進度 → 唔觸發新開場；舊流程睇到黃泉路（未改名）都當完
func _oldsave() -> void:
	var S0 = {"lv": 5, "res": {"wood": 10}, "seen": {"prologue_road": true, "prologue_sys": true}}
	_chk("舊存檔（有進度）唔重播開場", not NC.opening_unfinished(S0))
	var S1 = {"lv": 1, "res": {}, "seen": {"prologue_road": true}, "hero": {"name": "阿福", "sex": "m", "set": false}}
	_chk("舊流程睇完黃泉路（未改名）唔重播", not NC.opening_unfinished(S1))
	var S2 = {"lv": 1, "res": {}, "seen": {"prologue_chat": true, "op_wake": true, "op2_lobby": true}, "hero": {"name": "阿明", "sex": "m", "set": true}}
	_chk("新開場播到一半：會接續", NC.opening_unfinished(S2) and NC.opening(S2)[NC.resume_index(S2)] == "op2_lobby")
	var S3 = {"lv": 1, "res": {}, "seen": {}, "hero": {"name": "阿明", "sex": "m", "set": true}}
	_chk("新存檔：要播新開場", NC.opening_unfinished(S3) and NC.resume_index(S3) == 0)
	# 荒村開局（vil2 rb.gd）：正式開場睇完就唔再播佔位四段 rb_op_*
	var RBm = load("res://game/rebuild/rb.gd"); var S = J.G.S; var rb0 = S.get("rb"); var se0 = S.seen.duplicate()
	S["rb"] = {"on": 1, "test": 1}; S.seen["prologue_sys"] = true; S.seen.erase("op2_arrive"); S.seen.erase("opf2_arrive")
	var due0 = RBm.opening_due()
	S.seen["op2_arrive"] = true
	_chk("荒村：睇完正式開場唔播佔位", not RBm.opening_due(), "未睇時 due=%s" % due0)
	S["seen"] = se0
	if rb0 == null: S.erase("rb")
	else: S["rb"] = rb0

# 第 6 章孟婆：睇過新開場拒湯先有「又是你」
func _mengpo() -> void:
	var sc = _scenes().ch6_mengpo
	var n = (sc.lines as Array).size()
	var a = STG.filter_lines(sc, {"seen": {}})
	var b = STG.filter_lines(sc, {"seen": {"op2_soup": true}})
	var c = STG.filter_lines(sc, {"seen": {"opf2_soup": true}})
	_chk("孟婆呼應：舊玩家冇呢句", (a.lines as Array).size() == n - 1)
	_chk("孟婆呼應：男主拒過湯有", (b.lines as Array).size() == n)
	_chk("孟婆呼應：女主拒過湯有", (c.lines as Array).size() == n)
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate(); var l0 = DB.lang
	DB.lang = "zh"; S["hero"] = {"name": "阿慧", "full": "陳嘉慧", "en": "", "sex": "f", "set": true}
	var t = str(DB.L(b.lines[4][1]))
	_chk("孟婆呼應：女主講成分表", t.contains("成分表"), t)
	DB.lang = l0; S["hero"] = h0

# 掛鈎：只播一次、女主揀 _f、大排檔前唔轉祭品
func _hooks(m = null) -> void:
	var Sm = {"seen": {}, "hero": {"sex": "m"}}
	var Sf = {"seen": {}, "hero": {"sex": "f"}}
	_chk("化寶爐重開：男", PS.scene_for("joss_repaired", Sm) == "joss_reopen")
	_chk("化寶爐重開：女", PS.scene_for("joss_repaired", Sf) == "joss_reopen_f")
	_chk("化寶爐重開：只一次", PS.scene_for("joss_repaired", {"seen": {"joss_reopen_f": true}, "hero": {"sex": "f"}}) == "")
	_chk("酒館開張", PS.scene_for("tavern_open", Sm) == "tav_open")
	_chk("大排檔前：化寶爐唔轉祭品", PS.scene_for("joss_open", Sm) == "" and PS.joss_mode(Sm) == "cash")
	var S5 = {"seen": {"stall_hook": true}, "hero": {"sex": "m"}}
	_chk("大排檔後：第一次開爐轉祭品", PS.scene_for("joss_open", S5) == "joss_shift" and PS.joss_mode(S5) == "offer")
	_chk("化寶爐結果：冇旗唔播", not PS.on_joss_result({"coins": 10.0}))
	_chk("轉祭品只一次", PS.scene_for("joss_open", {"seen": {"stall_hook": true, "joss_shift": true}}) == "")
	# 開箱畫面收起先播：defer 唔即播，flush 先排
	PS._pend = null
	PS.defer_joss({"coins": 5.0})
	_chk("普通收件唔留待播", PS._pend == null)
	PS.defer_joss({"backlog": true})
	_chk("積壓包裹留待開箱收起後播", PS._pend is Dictionary)
	PS._pend = null
	# 荒村開張招魂台（酒館）→ 有註冊監聽
	PS.hook()
	_chk("荒村開張監聽已註冊", PS._hooked)
	# 大排檔開張 stall_hook：舊存檔（冇睇過新開場）唔觸發
	var st = J.G.get("Story"); var sv = J.G.S.seen.duplicate()
	var node = m.get("story") if m != null else null
	var bz = func(): return node.busy() if node != null else false
	J.G.S.seen.erase("stall_hook"); J.G.S.seen.erase("op2_arrive"); J.G.S.seen.erase("opf2_arrive")
	J.G["stall_open_fn"] = func(): return true
	var b0 = bz.call()
	PS.tick()
	_chk("舊存檔：大排檔開張唔播 stall_hook", b0 or not bz.call())
	J.G.S.seen["op2_arrive"] = true
	if st != null and not bz.call():
		PS.tick()
		_chk("新開場存檔：大排檔開張排 stall_hook", bz.call())
		if node != null: node.q.clear(); node.cur = null; node.visible = false
	J.G.erase("stall_open_fn")
	J.G.S["seen"] = sv

# 實機：男女各走一遍新開場（劇情框逐句播，每場截一張）
func _play(t, m, sex: String) -> void:
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate(); var seen0 = S.seen.duplicate()
	S["hero"] = {"name": "阿明" if sex == "m" else "小慧", "full": "李大明" if sex == "m" else "林慧", "en": "", "sex": sex, "set": true}
	DB.lang = "zh"
	var ids = OM if sex == "m" else OF
	var st = m.get("story")
	_chk("劇情框存在（%s）" % sex, st != null)
	if st == null: return
	for id in ids: S.seen.erase(id)
	for id in ids: st.queue(id)
	var played = {}; var names_ok = true; var guard = 0; var brace_bad: Array = []; var rv_bad: Array = []; var rv_seen = 0; var rv_n = 0
	while st.cur != null and guard < 400:
		guard += 1
		var cid = str(st.cur.get("id", ""))
		if not played.has(cid):
			played[cid] = true
			await _w(t, 0.9)
			await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png(SH + "%s_%s.png" % [sex, cid])
		var cgspec = st.cur.sc.get("cg", {}).get(str(st.li)) if st.cur.sc.get("cg") is Dictionary else null
		if cgspec is Dictionary and st.get("cg") != null and is_instance_valid(st.cg):
			if st.cg.layer.get_node_or_null("RvBadge") != null: rv_bad.append("角標 %s:%d" % [cid, st.li])
			var rk = str(cgspec.get("k", ""))
			if sex == "f" and str(cgspec.get("kf", "")) != "" and Spr.ok(str(cgspec.kf)): rk = str(cgspec.kf)
			var pend = (str(cgspec.get("rv", "")) != "" and rk == str(cgspec.get("k", ""))) or not Spr.ok(rk)
			if pend and st.cg.cur_key != "": rv_bad.append("未有圖但顯示咗 %s:%d %s" % [cid, st.li, st.cg.cur_key]); 
			if not pend and st.cg.cur_key != rk: rv_bad.append("應顯示 %s:%d %s≠%s" % [cid, st.li, st.cg.cur_key, rk])
			if pend: rv_n += 1
			rv_seen += 1
			if st.li > 0:   # 插圖唔喺第一句先出嘅場景：出圖嗰句再截一張（總覽圖用）
				await _w(t, 0.9)
				await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png(SH + "%s_%s_cg%d.png" % [sex, cid, st.li])
		var shown_nm = str(st.nm.text) if st.get("nm") != null else ""
		var shown_tx = str(st.full_text)
		if shown_nm.contains("{") or shown_nm.contains("}") or shown_tx.contains("{") or shown_tx.contains("}"): brace_bad.append("%s:%s|%s" % [cid, shown_nm, shown_tx.left(20)])
		if shown_nm.contains("阿福") and sex == "f": brace_bad.append("女主名牌顯示阿福 %s" % cid)
		var who = str(st.speaker())
		if who == "阿福" and st.get("nm") != null and str(st.nm.text) == "阿福": names_ok = false
		st.advance(); await _f(t, 2)
		if st.get("typing"): st.advance(); await _f(t, 2)
	var all_seen = true
	for id in ids: if not (played.has(id) and S.seen.has(id)): all_seen = false
	_chk("實機播完開場（%s）" % sex, all_seen and st.cur == null, played.keys())
	_chk("實機名牌顯示玩家名（%s）" % sex, names_ok)
	_chk("實機畫面冇「{」「}」佔位、名牌唔出阿福（%s）" % sex, brace_bad.is_empty(), brace_bad.slice(0, 5))
	_chk("實機：冇「待審」角標、冇佔位圖；未有圖嘅幕只有對話、有圖嘅幕顯示正確嗰張（%s）" % sex, rv_bad.is_empty() and rv_seen >= 6 and rv_n == 0, [rv_seen, rv_n, rv_bad.slice(0, 5)])
	S["hero"] = h0; S["seen"] = seen0

# 實機：{主角} 防呆喺「選項（按鈕）／任務欄／提示」三個出口都換成玩家名（男主預設名、改名、女主）
func _surfaces(t, m) -> void:
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate()
	for hv in [["男主預設", {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": true}, "阿福"], ["男主改名", {"name": "阿明", "full": "李大明", "en": "Ming", "sex": "m", "set": true}, "阿明"], ["女主", {"name": "小慧", "full": "林慧", "en": "", "sex": "f", "set": true}, "小慧"]]:
		S["hero"] = hv[1]; var nm_ = str(hv[2])
		# 選項：UIKit.btn
		var b = UIKit.btn("叫{主角}過來"); m.add_child(b); await _f(t, 1)
		_chk("選項按鈕（%s）" % hv[0], b.text == "叫%s過來" % nm_, b.text); b.queue_free()
		# 提示：show_toast → 畫面上嗰個提示框
		for c in m.toasts.get_children(): c.free()
		m.show_toast("{主角}，倉庫滿了")
		await _f(t, 2)
		var tt = ""
		if m.toasts.get_child_count() > 0: tt = str(m.toasts.get_child(m.toasts.get_child_count() - 1).get_child(0).text)
		_chk("提示（%s）" % hv[0], tt == "%s，倉庫滿了" % nm_, tt)
		# 任務欄：當前任務文字臨時寫入佔位符 → refresh → 讀任務欄
		var q = G.quest_cur()
		if q is Dictionary:
			var t0 = q.get("text"); var ty0 = q.get("t"); var b0 = q.get("b")
			q["text"] = "{主角}：去砍樹"; q["t"] = "__ph"; q.erase("b")
			m.refresh(); await _f(t, 1)
			var qt = str(m.quest_lbl.text)
			_chk("任務欄（%s）" % hv[0], qt.contains(nm_ + "：去砍樹") and not qt.contains("{") and not qt.contains("}"), qt)
			q["text"] = t0; q["t"] = ty0
			if b0 != null: q["b"] = b0
		else: _chk("任務欄（%s）：有當前任務" % hv[0], false)
	S["hero"] = h0; m.refresh()

# 牌匾疊字：透視變換數學、實機貼字（男主辦公室／流放同一塊匾同樣嘅字、酒館另一塊）、參數覆蓋、女主圖唔受影響
func _plaque(t, m) -> void:
	const CG = preload("res://ui/story_cg.gd")
	var q = [Vector2(10, 20), Vector2(210, 5), Vector2(200, 90), Vector2(15, 110)]
	var hm = CG.homography(q)
	var okc = true
	for i in 4:
		var uv = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)][i]
		if CG.hmap(hm, uv.x, uv.y).distance_to(q[i]) > 0.01: okc = false
	_chk("牌匾：透視變換四角對準", okc)
	var mid = CG.hmap(hm, 0.5, 0.5)
	_chk("牌匾：中心點喺兩條對角線交點（係透視唔係平均）", Geometry2D.segment_intersects_segment(q[0], q[2], q[1], q[3]).distance_to(mid) < 0.05, mid)
	_chk("牌匾：原圖座標 → 畫面（鋪滿置中裁切）", CG.img_to_layer(Vector2(0.5, 0.5), Vector2(1024, 768), 700, 400).distance_to(Vector2(350, 200)) < 0.01 and absf(CG.img_to_layer(Vector2(0, 0), Vector2(1024, 768), 700, 400).y - (400 - 525) / 2.0) < 0.01)
	var PD = CG.plaque_data()
	_chk("牌匾文字（老闆定）：辦公室／流放「加班是福」、酒館「奈何一杯」，男女一致、由左至右", str(PD.cg_office[0].text) == "加班是福" and str(PD.cg_office_f[0].text) == "加班是福" and str(PD.cg_exile_f[0].text) == "加班是福" and str(PD.cg_tavern[0].text) == "奈何一杯" and str(PD.cg_tavern_f[0].text) == "奈何一杯")
	_chk("牌匾資料：辦公室同流放係同一塊匾、同樣嘅字", PD.has("cg_office") and PD.has("cg_exile") and str(PD.cg_office[0].text) == str(PD.cg_exile[0].text) and str(PD.cg_office[0].quad) == str(PD.cg_exile[0].quad) and PD.has("cg_tavern"))
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate(); var seen0 = S.seen.duplicate()
	var st = m.get("story")
	for sex in ["m", "f"]:
		S["hero"] = {"name": "阿明" if sex == "m" else "小慧", "full": "李大明" if sex == "m" else "林慧", "en": "", "sex": sex, "set": true}
		var KM = {"op2_office": "cg_office", "op2_exile": "cg_exile", "tav_open": "cg_tavern" if sex == "m" else "cg_tavern_f", "opf2_office": "cg_office_f", "opf2_exile": "cg_exile_f"}
		for sid in (["op2_office", "op2_exile", "tav_open"] if sex == "m" else ["opf2_office", "opf2_exile", "tav_open"]):
			st.queue(sid)
			var found = null; var guard = 0
			while st.cur != null and str(st.cur.get("id", "")) == sid and guard < 60:
				guard += 1
				if st.cg != null and is_instance_valid(st.cg) and st.cg.visible and st.cg.cur_key == KM[sid]:
					found = st.cg.layer.get_node_or_null("Plaque0")
					if found != null: break
				st.advance(); await _f(t, 2)
			var want = str(PD[KM[sid]][0].text)
			var inb = false
			if found != null:
				inb = true
				for p in found.get_meta("quad"): if p.x < 0 or p.y < 0 or p.x > st.cg.layer.size.x or p.y > st.cg.layer.size.y: inb = false
			_chk("牌匾實機（%s %s）：有貼字「%s」、四角喺畫面內、字夠大" % [sex, sid, want], found != null and str(found.get_meta("text")) == want and inb and int(found.get_meta("font_size")) >= 40, found.get_meta("font_size") if found != null else "冇")
			if found != null: _chk("牌匾跟插圖一齊推近（同一個 layer）", found.get_parent() == st.cg.layer)
			await _w(t, 1.0); await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png(SH + "plaque_%s_%s.png" % [sex, sid])
			st.q.clear(); st.skip_scene(); await _f(t, 3)
	# 參數覆蓋／關閉
	st.queue("tav_open"); await _f(t, 2)
	S["hero"] = {"name": "阿明", "full": "李大明", "en": "", "sex": "m", "set": true}
	if st.cg != null:
		st.cg.show_spec({"k": "cg_tavern", "plaque": {"t": "三更酒館"}}); await _f(t, 2)
		var pn = st.cg.layer.get_node_or_null("Plaque0")
		_chk("牌匾：場景參數覆蓋文字", pn != null and str(pn.get_meta("text")) == "三更酒館")
		st.cg.show_spec({"k": "cg_dato_plaque"}); await _f(t, 2)
		var dn = st.cg.layer.get_node_or_null("Plaque0")
		_chk("Dato' 金匾：疊「拿督」浮雕字（三層）、冇角標", st.cg.cur_key == "cg_dato_plaque" and dn != null and str(dn.get_meta("text")) == "拿督" and str(dn.get_meta("style")) == "emboss" and int(dn.get_meta("layers")) == 3 and st.cg.layer.get_node_or_null("RvBadge") == null)
		await _w(t, 1.0); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SH + "plaque_dato.png")
		st.cg.show_spec({"k": "cg_note"}); await _f(t, 2)
		var nn = st.cg.layer.get_node_or_null("Plaque0")
		var ntxt = str(_scenes().op2_arrive.lines[6][1]).trim_prefix("「").trim_suffix("」")
		_chk("交接便條：疊劇本原句、多行、字夠大（>=44）", nn != null and str(nn.get_meta("text")) == str(DB.L(ntxt)) and str(nn.get_meta("style")) == "note" and int(nn.get_meta("font_size")) >= 44, nn.get_meta("font_size") if nn != null else "冇")
		if nn != null:
			var nl: Label = nn.get_child(0).get_child(nn.get_child(0).get_child_count() - 1)
			await _f(t, 2)
			var nh = nl.get_line_count() * nl.get_line_height() + maxi(0, nl.get_line_count() - 1) * nl.get_theme_constant("line_spacing")
			_chk("交接便條：成段字喺紙面內（唔出紙）", nh <= nl.size.y + 1.0 and nl.get_line_count() >= 3, "%d 行、高 %.0f／%.0f" % [nl.get_line_count(), nh, nl.size.y])
		await _w(t, 1.0); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SH + "plaque_note.png")
		st.cg.show_spec({"k": "cg_road"}); await _f(t, 2)
		_chk("男主黃泉路（3:2）：插圖框跟圖比例、唔超出畫面", st.cg.cur_key == "cg_road" and absf(st.cg.size.x / st.cg.size.y - 1.5) < 0.08 and st.cg.size.x <= st.size.x and st.cg.size.y <= st.size.y * 0.47, st.cg.size)
		await _w(t, 1.0); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SH + "cg_road_m_frame.png")
		var keys0 = CG._rv_keys
		CG.review_pending(""); CG._rv_keys = ["cg_he_wake"]
		st.cg.show_spec({"k": "cg_he_wake"}); await _f(t, 2)
		_chk("未選定素材（cg_review.json pending）正式版唔顯示、冇角標", st.cg.cur_key == "" and st.cg.layer.get_node_or_null("RvBadge") == null)
		CG._rv_keys = keys0
		st.cg.show_spec({"k": "cg_road", "ph": "cg1_queue", "rv": "待審"}); await _f(t, 2)
		_chk("未有圖（黃泉路）正式版唔用佔位圖", st.cg.cur_key == "")
		st.cg.show_spec({"k": "cg_nuopo_taste"}); await _f(t, 2)
		_chk("已選用（糯婆試食）照顯示、冇角標", st.cg.cur_key == "cg_nuopo_taste" and st.cg.layer.get_node_or_null("RvBadge") == null)
		var en = st.cg._plaque_node("拿督", [Vector2(100, 40), Vector2(500, 40), Vector2(500, 160), Vector2(100, 160)], Color("#e9b949"), false, 9, "emboss")
		st.cg.layer.add_child(en)
		_chk("牌匾浮雕樣式：三層（內陰影＋高光＋面層）", str(en.get_meta("style")) == "emboss" and int(en.get_meta("layers")) == 3 and str(CG.plaque_data().cg_dato_plaque[0].style) == "emboss" and str(CG.plaque_data().cg_dato_plaque[0].text) == "拿督")
		await _w(t, 0.6); await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(SH + "plaque_emboss_demo.png")
		st.cg.show_spec({"k": "cg_tavern", "plaque": {"t": "三更酒館"}}); await _f(t, 2)
		st.cg.show_spec({"k": "cg_tavern", "plaque": false}); await _f(t, 2)
		_chk("牌匾：plaque=false 唔貼", st.cg.layer.get_node_or_null("Plaque0") == null)
	st.q.clear(); st.skip_scene(); await _f(t, 3)
	S["hero"] = h0; S["seen"] = seen0
