# A 線：改名＋揀性別（DB.N）各出口實測
# GB_TEST 腳本：[["wait",3],["gdrun","res://tools/tests/xa_name.gd","run"],["quit"]]
# 1) 預設阿福／男（同冇 hero 欄）：所有出口輸出同原本一模一樣
# 2) 測試名／男、測試名／女：各出口抽樣冇殘留「阿福」「陳大福」「Kelvin」，女冇「少爺」
# 3) 內部鍵（SPEAKER_ART、劇本講者、ART3、S.ghosts id）冇被替換，資料冇被改寫
extends RefCounted

var ok := 0
var bad := 0
var main_ = null

func chk(name: String, cond: bool, info = "") -> void:
	if cond: ok += 1; return
	bad += 1
	if bad <= 40: print("[xa] FAIL ", name, " ", str(info).substr(0, 300))

static func _old_L(s, lang: String):
	if not (s is String) or lang != "zh": return s
	var z = DB.D.get("LANG_ZH", {}).get(s)
	return z if z != null and z != "" else s

static func _strings(o, out: Array, depth := 0) -> void:
	if depth > 12 or out.size() > 60000: return
	if o is String:
		if o.contains("少爺xa"): return   # 測試自己加入 LANG 嘅句
		if o.contains("阿福") or o.contains("少爺") or o.contains("陳大福") or o.contains("Kelvin"): out.append(o)
	elif o is Array:
		for x in o: _strings(x, out, depth + 1)
	elif o is Dictionary:
		for k in o: _strings(o[k], out, depth + 1)

const RESIDUE_M := ["阿福", "陳大福", "Kelvin"]
const RESIDUE_F := ["阿福", "陳大福", "Kelvin", "少爺"]

func _clean(s: String, fem: bool) -> bool:
	for w in (RESIDUE_F if fem else RESIDUE_M):
		if s.contains(w): return false
	return true

# 所有出口各出一句，回傳 [出口名, 輸出]
func _exits() -> Array:
	var r = []
	var S0 = "阿福，少爺叫你。陳大福／Kelvin／阿福哥"
	r.append(["DB.L", DB.L(S0)])
	r.append(["DB.Lf", DB.Lf("{n}同阿福：少爺", {"n": "阿福哥"})])
	r.append(["J.G.L", J.str(J.cl(J.G.get("L"), null, [S0]))])
	r.append(["J.G.Lf", J.str(J.cl(J.G.get("Lf"), null, ["{n}／阿福／少爺", {"n": "Kelvin"}]))])
	# DOM
	var d = El.new("div"); d.innerHTML = "<b>阿福</b>：少爺，<i>陳大福</i>"
	r.append(["el.innerHTML", _el_text(d)])
	var d2 = El.new("span"); d2.textContent = "阿福哥同少爺"
	r.append(["el.textContent", _el_text(d2)])
	var d3 = El.new("div"); d3._js_insertAdjacentHTML(["beforeend", "<p>阿福少爺</p>"])
	r.append(["el.insertAdjacentHTML", _el_text(d3)])
	# 本地 T()
	r.append(["Menus.T", Menus.T("阿福少爺", "阿福少爺")])
	r.append(["StDraw.T", StDraw.T("阿福少爺", "阿福少爺")])
	r.append(["StStreet.T", StStreet.T("阿福少爺", "阿福少爺")])
	r.append(["StTurf.T", StTurf.T("阿福少爺", "阿福少爺")])
	r.append(["StHud.T", StHud.T("阿福少爺", "阿福少爺")])
	r.append(["StDomPanel.T", StDomPanel.T("阿福少爺", "阿福少爺")])
	r.append(["QX.T", QX.T(["阿福少爺", "阿福少爺"])])
	var lb = load("res://game/limbo/lb_run.gd").new(); r.append(["LbRun.T", lb.T(["阿福少爺", "阿福少爺"])]); lb.free()
	r.append(["presence.T", J.str(load("res://native/presence.gd").T(["x", "阿福少爺", "阿福少爺"]))])
	r.append(["bonds.T", J.str(load("res://native/bonds.gd").T(["阿福少爺", "阿福少爺"]))])
	r.append(["street.T", J.str(load("res://native/street.gd").T("阿福少爺xa1", "阿福少爺xa1"))])
	r.append(["station_foes.T", J.str(load("res://native/station_foes.gd").T("阿福少爺xa2", "阿福少爺xa2"))])
	# 寫死標籤
	var l = WA.lab("阿福：少爺"); r.append(["WA.lab", l.text]); l.free()
	var b = WA.Bubble.new("them", "阿福", "少爺，阿福", "02:47"); r.append(["WA.Bubble.who", b.who]); r.append(["WA.Bubble.text", b.text]); b.free()
	var ph = PtHud.new(); var pl = ph._lbl("阿福倒下了", 22, Color.WHITE); r.append(["PtHud._lbl", pl.text]); pl.free(); ph.free()
	r.append(["sports.afu_name", J.str(DB.N("阿福"))])
	# 劇情播放器講者名＋對白
	if main_ != null and main_.get("story") != null:
		var st = main_.story
		st.queue({"style": "talk", "bg": "village", "lines": [["阿福", "少爺，我係阿福。"]]})
		await Engine.get_main_loop().process_frame
		if st.cur != null and st.get("nm") != null:
			r.append(["story.nm", st.nm.text]); r.append(["story.text", st.full_text])
			chk("story SPEAKER_ART 用原講者鍵", str(st.cur.sc.lines[0][0]) == "阿福")
		else: chk("story 開到", false, "cur=%s" % st.cur)
		for i in 5:
			if st.cur == null: break
			st.skip_scene(); await Engine.get_main_loop().process_frame
	return r

static func _el_text(e) -> String:
	return J.str(e.textContent)   # El._text()：逐個 #TEXT 子節點砌返

func _set_hero(h) -> void:
	var S = J.G.get("S")
	if h == null: S.erase("hero")
	else: DB.hero_apply(h)

func run(t) -> void:
	main_ = t.main()
	var S = J.G.get("S")
	var save_hero = S.get("hero")
	var save_lang = DB.lang; var LANG = J.G.get("LANG"); var save_cur = J.str(J.gp(LANG, "cur"))
	var LN = load("res://native/lang.gd")
	# ---- 0. 收集全部含主角名嘅句子（core.json + 劇本 + J.G 資料） ----
	var pool = []
	_strings(DB.D, pool)
	var core_n = pool.size(); var core_sig = JSON.stringify(DB.D.get("SCENES", {})).hash()
	for k in ["SCENES", "QUESTS", "SKITS", "STANDUP", "CHAT_DATA", "PRES_TXT", "BOND_RECRUIT", "CHATS_PRE", "XO_SCENES", "SU_BITS"]:
		if J.G.get(k) != null: _strings(J.G.get(k), pool)
	print("[xa] 句子池 ", pool.size())
	chk("句子池夠多", pool.size() > 300, pool.size())
	var keys_before = JSON.stringify(DB.D.get("SPEAKER_ART", {})) + JSON.stringify(J.G.get("SPEAKER_ART"))
	# ---- 1. 預設：冇 hero 欄、阿福／男 → 同原本一模一样 ----
	for hcase in [null, DB.HERO_M.duplicate()]:
		_set_hero(hcase)
		for lg in ["zh", "yue"]:
			DB.lang = lg; LN.cur = lg
			var diff = 0; var first = ""
			for s in pool:
				if DB.L(s) != _old_L(s, lg): diff += 1; if first == "": first = s
				var o2 = s if lg != "zh" else (LN.ZH.get(s) if LN.ZH.get(s) != null and J.str(LN.ZH.get(s)) != "" else s)
				if J.cl(J.G.get("L"), null, [s]) != o2: diff += 1; if first == "": first = "JG:" + s
				if DB.N(s) != s: diff += 1; if first == "": first = "N:" + s
			chk("預設 %s/%s 輸出不變" % ["冇欄" if hcase == null else "阿福男", lg], diff == 0, "%d %s" % [diff, first])
			var ex = await _exits()
			var ref = {"DB.L": _old_L("阿福，少爺叫你。陳大福／Kelvin／阿福哥", lg), "Menus.T": "阿福少爺", "WA.lab": "阿福：少爺", "WA.Bubble.who": "阿福", "PtHud._lbl": "阿福倒下了", "story.nm": "阿福", "el.innerHTML": "阿福：少爺，陳大福", "sports.afu_name": "阿福"}
			for e in ex:
				if ref.has(e[0]): chk("預設出口 %s %s" % [e[0], lg], e[1] == ref[e[0]], e[1])
				else: chk("預設出口 %s %s 保留阿福" % [e[0], lg], str(e[1]).contains("阿福") or str(e[1]).contains("Kelvin"), e[1])
	# ---- 2. 測試名／男、測試名／女 ----
	for sex in ["m", "f"]:
		var fem = sex == "f"
		_set_hero(DB.hero_make("測試名", sex))
		chk("hero_apply 同步名冊 %s" % sex, _afu_name() == "測試名", _afu_name())
		for lg in ["zh", "yue"]:
			DB.lang = lg; LN.cur = lg
			var dirty = 0; var first = ""; var named = 0
			for s in pool:
				var a = DB.L(s); var b2 = J.str(J.cl(J.G.get("L"), null, [s]))
				if not _clean(a, fem) or not _clean(b2, fem): dirty += 1; if first == "": first = a
				if a.contains("測試名"): named += 1
			chk("全部句子 %s/%s 冇殘留" % [sex, lg], dirty == 0, "%d %s" % [dirty, first])
			chk("全部句子 %s/%s 有換名" % [sex, lg], named > 200, named)
			var ex = await _exits()
			for e in ex:
				chk("出口 %s %s/%s 冇殘留" % [e[0], sex, lg], _clean(str(e[1]), fem), e[1])
				if e[0] in ["DB.L", "Menus.T", "WA.lab", "WA.Bubble.who", "PtHud._lbl", "story.nm", "el.innerHTML", "sports.afu_name", "J.G.L"]:
					chk("出口 %s %s/%s 有新名" % [e[0], sex, lg], str(e[1]).contains("測試名"), e[1])
			# 稱呼：阿福哥 → 測試名哥／姐；少爺 → 大小姐（女）
			chk("阿福哥 %s" % sex, DB.N("阿福哥好") == ("測試名姐好" if fem else "測試名哥好"), DB.N("阿福哥好"))
			chk("少爺 %s" % sex, DB.N("少爺早晨") == ("大小姐早晨" if fem else "少爺早晨"), DB.N("少爺早晨"))
			chk("Kelvin→名 %s" % sex, DB.N("Kelvin") == "測試名")
			chk("冼小姐唔受影響 %s" % sex, DB.N("冼小姐") == "冼小姐")
			chk("N 冪等 %s/%s" % [sex, lg], DB.N(DB.N("阿福哥同少爺、陳大福")) == DB.N("阿福哥同少爺、陳大福"))
		# 女版覆寫表（整句換，女先查；長句喺 HTML 入面都換）
		var saveF = DB.FEM.duplicate(); var saveS = DB._fem_sub.duplicate()
		DB.FEM["阿福生前坐喺Bryan隔籬，少爺"] = "阿福生前讀緊大學一年級"
		DB._fem_sub = ["阿福生前坐喺Bryan隔籬，少爺"]; DB._nc.clear(); DB._nsig = ""
		DB.lang = "yue"
		var w = DB.N("阿福生前坐喺Bryan隔籬，少爺")
		chk("fem 整句換 %s" % sex, w == ("測試名生前讀緊大學一年級" if fem else "測試名生前坐喺Bryan隔籬，少爺"), w)
		var dv = El.new("div"); dv.innerHTML = "<p>阿福生前坐喺Bryan隔籬，少爺</p>"
		chk("fem 喺 HTML 入面換 %s" % sex, _el_text(dv) == ("測試名生前讀緊大學一年級" if fem else "測試名生前坐喺Bryan隔籬，少爺"), _el_text(dv))
		DB.FEM = saveF; DB._fem_sub = saveS; DB._nc.clear(); DB._nsig = ""
	# ---- 2b. 真 fem.json（E 線）：先查整句再換名 ----
	if DB.FEM.size() > 0:
		_set_hero(DB.hero_make("", "f")); DB.lang = "yue"
		var hit = 0; var dirty = 0; var first = ""
		for k in DB.FEM:
			var o = DB.N(k)
			var exp = str(DB.FEM[k]).replace("陳大福", "陳嘉慧").replace("阿福哥", "阿慧姐").replace("Kelvin", "阿慧").replace("阿福", "阿慧").replace("少爺", "大小姐")
			if o == exp: hit += 1
			elif first == "": first = k + " => " + o
			if not _clean(o, true): dirty += 1
		print("[xa] fem.json 條數 ", DB.FEM.size(), " 命中 ", hit)
		chk("fem.json 全部整句命中", hit == DB.FEM.size(), first)
		chk("fem.json 輸出冇殘留", dirty == 0, dirty)
		_set_hero(DB.hero_make("測試名", "m"))
		var same = 0
		for k in DB.FEM: if DB.N(k) == str(k).replace("陳大福", "測試名").replace("阿福哥", "測試名哥").replace("Kelvin", "測試名").replace("阿福", "測試名"): same += 1
		chk("男線唔用 fem.json", same == DB.FEM.size(), same)
	# 唔換名標記
	_set_hero(DB.hero_make("測試名", "f"))
	var kp = DB.keep("那個阿Ken，跟阿福一樣，都不回家。")
	chk("keep 唔換名", DB.N(kp) == kp and DB.N(kp).contains("阿" + DB.KEEP_MARK + "福"), DB.N(kp))
	var fnt = UIKit.font("sans", 400)
	chk("keep 零寬顯示", absf(fnt.get_string_size("阿" + DB.KEEP_MARK + "福", HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x - fnt.get_string_size("阿福", HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x) < 0.5)
	# ---- 3. 內部鍵冇被替換、資料冇被改寫 ----
	var keys_after = JSON.stringify(DB.D.get("SPEAKER_ART", {})) + JSON.stringify(J.G.get("SPEAKER_ART"))
	chk("SPEAKER_ART 不變", keys_before == keys_after)
	chk("SPEAKER_ART 仲有阿福鍵", (J.G.get("SPEAKER_ART") is Dictionary and J.G.SPEAKER_ART.has("阿福")) or DB.D.get("SPEAKER_ART", {}).has("阿福"))
	var pool2 = []
	_strings(DB.D, pool2)
	chk("core 資料冇被改寫", pool2.size() == core_n and JSON.stringify(DB.D.get("SCENES", {})).hash() == core_sig, "%d vs %d" % [pool2.size(), core_n])
	chk("ART3 不變", load("res://native/bonds.gd").ART3.has("阿福") and load("res://native/presence.gd").ART3.has("阿福"))
	chk("S.ghosts afu id 不變", _afu_id_ok())
	# ---- 4. 名字驗證 ----
	DB.lang = "yue"
	chk("名 OK", DB.name_ok("測試名") and DB.name_ok("阿慧") and DB.name_ok("Ah Wai") and DB.name_ok("一二三四五六"))
	chk("名太長", not DB.name_ok("一二三四五六七"))
	chk("名留空", not DB.name_ok("  "))
	for bad_ in ["阿{名}", "[b]", "<i>", "阿福仔", "少爺", "Kelvin", "大小姐", "旁白", "我", "50%"]: chk("名拒絕 " + bad_, not DB.name_ok(bad_), DB.name_check(bad_))
	chk("英文名可留空", DB.name_ok("", "en") and not DB.name_ok("阿慧", "en"))
	var hf = DB.hero_make("", "f")
	chk("女預設", hf.name == "阿慧" and hf.full == "陳嘉慧" and hf.en == "" and hf.sex == "f")
	var hm = DB.hero_make("", "m")
	chk("男預設", hm.name == "阿福" and hm.full == "陳大福" and hm.en == "Kelvin")
	# ---- 5. 女主換圖鈎 ----
	chk("Spr.fem_key", Spr.fem_key("afu") == "afuf" and Spr.fem_key("afu_body") == "afuf_body" and Spr.fem_key("rg_afu_head_s") == "rg_afuf_head_s" and Spr.fem_key("afu__axe") == "afuf__axe" and Spr.fem_key("xiaozhi") == "xiaozhi")
	_set_hero(DB.hero_make("", "f"))
	chk("Spr.ok(afuf) 未有圖", Spr.ok("afuf") == Spr.fem_ok())
	if not Spr.fem_ok(): chk("女主冇 afuf 圖照用 afu", Spr.key_for("afu") == "afu" and Spr.get_tex("afu") != null)
	Spr._man["afuf"] = Spr._man["afu_body"]   # 假裝有 afuf 圖
	chk("女主有 afuf 就用", Spr.key_for("afu") == "afuf" and Spr.fem_ok())
	chk("El.src 換路徑", Spr.fem_src("res://assets/spr/afu.webp") == str(Spr._man["afu_body"]))
	_set_hero(DB.hero_make("", "m"))
	chk("男主唔換圖", Spr.key_for("afu") == "afu")
	Spr._man.erase("afuf"); Spr._tex.erase("afuf")
	# ---- 還原 ----
	if save_hero == null: S.erase("hero")
	else: DB.hero_apply(save_hero)
	for g in S.get("ghosts", []): if str(g.get("id", "")) == "afu": g["name"] = "阿福"
	DB.lang = save_lang; LN.cur = save_cur
	print("[xa] RESULT ok=%d bad=%d" % [ok, bad])

func _afu_name() -> String:
	for g in J.G.S.get("ghosts", []): if str(g.get("id", "")) == "afu": return str(g.get("name", ""))
	return ""
func _afu_id_ok() -> bool:
	for g in J.G.S.get("ghosts", []): if str(g.get("id", "")) == "afu": return str(g.get("k", "")) == "afu"
	return false
