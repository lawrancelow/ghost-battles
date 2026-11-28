# [opening] 測試：大排檔前大更新劇情（新開場男女各一遍、名字替換、舊存檔唔觸發、第 6 章孟婆呼應、掛鈎事件）
# 用法：bash godot/tools/devkit/edtest.sh <godot目錄> opening res://tools/tests/opening_test.gd all 600
#   截圖：/home/claude/docs/shots/opening/
extends "res://tools/tests/eqview2_test.gd"

const NC = preload("res://ui/name_card.gd")
const PS = preload("res://game/onboard/prestall_story.gd")
const STG = preload("res://ui/story.gd")
const SH := "/home/claude/docs/shots/opening/"
const OM := ["op2_road", "op2_lobby", "op2_office", "op2_soup", "op2_exile", "op2_arrive"]
const OF := ["opf2_road", "opf2_lobby", "opf2_office", "opf2_soup", "opf2_exile", "opf2_arrive"]

func _p(m): print("[op] ", m)

func all(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH)
	_data()
	_names()
	_oldsave()
	_mengpo()
	_hooks()
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
	_chk("第一章開場最前係 stall_hook", ch1 is Array and ch1.size() > 0 and str(ch1[0].intro[0]) == "stall_hook", ch1[0].intro if ch1 is Array and ch1.size() > 0 else "")

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
func _hooks() -> void:
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
	var played = {}; var names_ok = true; var guard = 0
	while st.cur != null and guard < 400:
		guard += 1
		var cid = str(st.cur.get("id", ""))
		if not played.has(cid):
			played[cid] = true
			await _w(t, 0.9)
			await RenderingServer.frame_post_draw
			t.get_viewport().get_texture().get_image().save_png(SH + "%s_%s.png" % [sex, cid])
		var who = str(st.speaker())
		if who == "阿福" and st.get("nm") != null and str(st.nm.text) == "阿福": names_ok = false
		st.advance(); await _f(t, 2)
		if st.get("typing"): st.advance(); await _f(t, 2)
	var all_seen = true
	for id in ids: if not (played.has(id) and S.seen.has(id)): all_seen = false
	_chk("實機播完開場（%s）" % sex, all_seen and st.cur == null, played.keys())
	_chk("實機名牌顯示玩家名（%s）" % sex, names_ok)
	S["hero"] = h0; S["seen"] = seen0
