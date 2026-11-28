# [kpi-cg] 測試：KPI 劇情插圖接線（被抓包／何大睡／錢不漏／糯婆／Dato' 金匾／收賄男女）＋牌匾疊字跟鏡頭（靜態慢推、分層鏡頭、後備視差）
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> kpicg res://tools/tests/kpi_cg_test.gd all 600
#   截圖：/home/claude/meeting/vil2/kpi/cg/
extends "res://tools/tests/eqview2_test.gd"

const KG = preload("res://game/kpi/kpi_data.gd")
const KU = preload("res://game/kpi/kpi_ui.gd")
const CG = preload("res://ui/story_cg.gd")
const CGM = preload("res://ui/cg_motion.gd")
const SH := "/home/claude/meeting/vil2/kpi/cg/"

func _p(m): print("[kpicg] ", m)

func all(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH)
	CGM.disabled = false
	_data()
	await _live(t, m)
	await _follow(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _sex(s: String) -> Dictionary:
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate()
	S["hero"] = {"name": "阿明" if s == "m" else "小慧", "full": "李大明" if s == "m" else "林慧", "en": "", "sex": s, "set": true}
	return h0

# ---------------- 資料：邊個場景出邊張圖、由第幾行開始 ----------------
func _data() -> void:
	var S = J.G.S; var h0 = _sex("m")
	var SC = KG.D().get("scenes", {})
	var exp = {"kpi_he_open": "cg_he_wake", "kpi_qian_open": "cg_qian_bite", "kpi_dato_open": "cg_dato_plaque", "kpi_nuo_open": "cg_nuopo_taste", "kpi_ma_food": "cg_c2_bribe", "kpi_caught": "cg_caught"}
	for b in ["chen", "he", "qian", "dato", "nuo"]:
		exp["kpi_%s_bribe_ok" % b] = "cg_c2_bribe"; exp["kpi_%s_caught" % b] = "cg_caught"
	var badk = []; var n := 0
	for k in exp:
		if not SC.has(k): continue
		n += 1
		var sc = KU.scene(k); var cg = sc.get("cg")
		if not (cg is Dictionary) or cg.size() != 1: badk.append(k); continue
		var li = int(str(cg.keys()[0])); var sp = cg.values()[0]
		if str(sp.get("k")) != exp[k] or li < 0 or li >= sc.lines.size(): badk.append(k)
	_chk("KPI 場景帶插圖鍵（何大睡／錢不漏／Dato'／糯婆登場、收賄、被抓包）", badk.is_empty() and n >= 13, [n, badk])
	for k in exp.values():
		if not (Spr.ok(k) or CGM.known(k)): badk.append("miss:" + k)
	_chk("用到嘅插圖全部已入庫", badk.is_empty(), badk)
	var none = []
	for k in SC:
		var has = KU.scene(str(k)).has("cg")
		if has != exp.has(str(k)): none.append(k)
	_chk("其餘場景（陳不辦／龐總登場、達標、送錯被推返、拍照、Bryan 等）冇插圖欄位，行為不變", none.is_empty(), none)
	_chk("龐總收包子（kpi_pang_bribe）唔出收賄圖", KU.cg_rule("kpi_pang_bribe").is_empty() and not KU.scene("kpi_pang_bribe").has("cg"))
	# 開始行：何大睡由「鬧鐘響」嗰句、Dato' 由牛頭報銜頭嗰句
	_chk("何大睡：由第 2 句（牛頭：鬧鐘響）開始出圖", KU.scene("kpi_he_open").cg.has("1") and str(KU.scene("kpi_he_open").lines[1][1]).contains("鐘"))
	# 男女主：收賄圖女主用專屬版（kf），其餘共用
	var sp_m = KU.scene("kpi_chen_bribe_ok").cg.values()[0]
	_chk("收賄圖：男主 C2 公案版、女主專屬版（kf）", str(sp_m.k) == "cg_c2_bribe" and str(sp_m.get("kf", "")) == "cg_f_bribe" and CGM.known("cg_f_bribe"))
	_sex("f")
	var nf = KU.scene("kpi_nuo_open"); var nm_lines = 0
	_sex("m"); nm_lines = KU.scene("kpi_nuo_open").lines.size()
	_chk("男女專句篩走之後，插圖行號仍然喺範圍內", nf.cg.has("0") and nf.lines.size() == nm_lines)
	# 資料自帶 cg：按篩句後行號對位
	var imap = {0: 0, 1: 1, 3: 2}
	var own = KU.cg_of("x", {"cg": {"3": {"k": "cg_caught"}, "2": ""}}, imap, 3)
	_chk("kpi.json 自帶 cg 時以資料為準、行號重新對位（被篩走嗰行唔出）", own.has("2") and str(own["2"].k) == "cg_caught" and own.size() == 1, own)
	# 老闆 19:25：女主版匾字要同男主一樣（同字體、字重、顏色、相對匾面大小）；全遊戲「奈河一杯」
	var PDx = CG.plaque_data(); var same_ok = true; var rr = []
	for pr in [["cg_office", "cg_office_f"], ["cg_exile", "cg_exile_f"]]:
		var a = PDx[pr[0]][0]; var b = PDx[pr[1]][0]
		var ha = (float(a.quad[3][1]) - float(a.quad[0][1])) / float(a.size[1]); var hb = (float(b.quad[3][1]) - float(b.quad[0][1])) / float(b.size[1])
		var wa = (float(a.quad[1][0]) - float(a.quad[0][0])) / float(a.size[0]); var wb = (float(b.quad[1][0]) - float(b.quad[0][0])) / float(b.size[0])
		rr.append([ha, hb, wa, wb])
		if absf(ha - hb) / ha > 0.08 or absf(wa - wb) / wa > 0.08 or str(a.text) != str(b.text) or str(a.get("color")) != str(b.get("color")) or str(a.get("style", "")) != str(b.get("style", "")): same_ok = false
	_chk("女主辦公室／流放匾：字同男主一樣大（匾面框佔圖比例差 ≤8%）、同色同樣式同文字", same_ok, rr)
	var txt_all = FileAccess.get_file_as_string("res://data/story_v2.json") + FileAccess.get_file_as_string("res://data/cg_plaque.json")
	_chk("全遊戲用「奈河一杯」，冇殘留「奈何一杯」", not txt_all.contains("奈何一杯") and txt_all.contains("奈河一杯") and str(PDx.cg_tavern[0].text) == "奈河一杯" and str(PDx.cg_tavern_f[0].text) == "奈河一杯")
	_chk("Dato' 金匾 v3：字雕喺圖上，冇程序疊字資料、唔喺 hold；由第 2 句（牛頭報銜頭）開始出圖", not CG.review_hold("cg_dato_plaque") and not CG.plaque_data().has("cg_dato_plaque") and KU.scene("kpi_dato_open").cg.has("1") and str(KU.scene("kpi_dato_open").lines[1][0]) == "牛頭")
	_chk("hold 機制：退回重做嘅圖唔出（KPI 規則同插圖卡都擋）", not CG.review_hold("") and not CG.review_hold("cg_office"))
	S["hero"] = h0

# ---------------- 實機：經 KU.play 播，睇插圖出現、唔遮對話框、播完收起 ----------------
func _run_scene(t, st, key: String, want: String, tag: String, want_plaque := "") -> void:
	KU.PLAYED.clear()
	var done = [false]
	KU.play(_main(t), key, "系統核實：測試。" if key.contains("bribe") else "", func(): done[0] = true)
	await _f(t, 3)
	var seen = false; var clear_ok = true; var pl_ok = want_plaque == ""; var shot = false; var guard = 0
	while st.cur != null and guard < 80:
		guard += 1
		if st.typing: st.advance(); await _f(t, 2)
		var cgv = st.cg != null and is_instance_valid(st.cg) and st.cg.visible
		if cgv and st.cg.cur_key == want:
			seen = true
			await _w(t, 0.7)   # 等開機動畫＋排版
			if st.talkbox != null and is_instance_valid(st.talkbox) and st.talkbox.visible:
				var a: Rect2 = st.cg.get_global_rect(); var b: Rect2 = st.talkbox.get_global_rect()
				if a.intersects(b) and a.intersection(b).get_area() > 4.0: clear_ok = false
				var vr = Rect2(Vector2.ZERO, t.get_viewport().get_visible_rect().size)
				if not vr.grow(1.0).encloses(a): clear_ok = false
			if want_plaque != "":
				var pn = st.cg.layer.get_node_or_null("Plaque0")
				pl_ok = pn != null and str(pn.get_meta("text")) == want_plaque
			if not shot:
				shot = true
				await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png(SH + tag + ".png")
		st.advance(); await _f(t, 2)
	_chk("%s：出圖 %s、插圖卡喺畫面內且唔遮對話框%s" % [tag, want, "、匾上有「%s」" % want_plaque if want_plaque != "" else ""], seen and clear_ok and pl_ok and KU.PLAYED.has(key), [seen, clear_ok, pl_ok])
	await _f(t, 3)
	_chk("%s：播完收起（劇情層關、回調有叫）" % tag, st.cur == null and not st.visible and done[0])

func _live(t, m) -> void:
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate()
	var st = m.get("story")
	if st == null: _chk("搵到劇情節點", false); return
	KU.play_fn = Callable()
	_sex("m")
	await _run_scene(t, st, "kpi_he_open", "cg_he_wake", "he_wake")
	await _run_scene(t, st, "kpi_qian_open", "cg_qian_bite", "qian_bite")
	await _run_scene(t, st, "kpi_dato_open", "cg_dato_plaque", "dato_plaque")
	await _run_scene(t, st, "kpi_nuo_open", "cg_nuopo_taste", "nuopo_taste")
	await _run_scene(t, st, "kpi_chen_bribe_ok", "cg_c2_bribe", "bribe_m")
	await _run_scene(t, st, "kpi_chen_caught", "cg_caught", "caught")
	_sex("f")
	await _run_scene(t, st, "kpi_qian_bribe_ok", "cg_f_bribe", "bribe_f")
	# 冇圖嘅場景：照舊冇插圖卡
	_sex("m")
	KU.play(_main(t), "kpi_chen_open")
	await _f(t, 4)
	var any = false; var g2 = 0
	while st.cur != null and g2 < 60:
		g2 += 1
		if st.cg != null and is_instance_valid(st.cg) and st.cg.visible: any = true
		st.advance(); await _f(t, 2)
	_chk("陳不辦巡查（冇專屬圖）：全程冇插圖卡", not any)
	S["hero"] = h0

# ---------------- 牌匾疊字跟鏡頭 ----------------
func _xf_same(c) -> bool:   # 疊字層同底圖用同一套變換（中心縮放＋平移）
	return c.layer.scale.is_equal_approx(c.pic.scale) and c.layer.position.is_equal_approx(c.pic.position) and c.layer.pivot_offset.is_equal_approx(c.pic.pivot_offset) and c.layer.size.is_equal_approx(c.pic.size)

func _follow(t, m) -> void:
	var st = m.get("story")
	# 數學：遠景（y0 以上）唔郁；前景按 d² 反方向移
	var z0 = CG.flat_shift(0.2, 0.42, 0.01, 0.004, Vector2(1000, 700))
	var z1 = CG.flat_shift(1.0, 0.42, 0.01, 0.004, Vector2(1000, 700))
	var zm = CG.flat_shift(0.71, 0.42, 0.01, 0.004, Vector2(1000, 700))
	_chk("後備視差位移：y0 以上＝0；最底＝-sh×闊；中間介乎其間", z0 == Vector2.ZERO and absf(z1.x + 10.0) < 0.001 and absf(z1.y) < 0.001 and zm.x < 0.0 and zm.x > -10.0 and zm.y < 0.0, [z0, z1, zm])
	st.queue({"style": "talk", "bg": "village", "title": "測試", "lines": [["旁白", "一"], ["旁白", "二"]]})
	await _f(t, 4)
	var c = st.cg
	if c == null or not is_instance_valid(c): _chk("搵到插圖卡", false); return
	# (1) 靜態慢推（辦公室、Dato' 金匾、便條）
	for k in ["cg_office", "cg_note"]:
		c.show_spec({"k": k}); await _f(t, 2)
		var okx = c.mot == null and c.layer.get_node_or_null("Plaque0") != null
		var s0 = c.pic.scale.x
		for i in 5:
			c._t = 2.5 * (i + 1); c._process(0.0)
			if not _xf_same(c): okx = false
			if i == 2:
				await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png(SH + "follow_%s.png" % k)
		_chk("靜態慢推 %s：疊字層同底圖同一套縮放（推近時字跟住匾）" % k, okx and c.pic.scale.x > s0, [s0, c.pic.scale.x])
	# (2) 後備動態：酒館（匾喺遠景 → 視差唔郁匾；鏡頭推移時疊字層跟底圖）
	c.show_spec({"k": "cg_tavern"}); await _f(t, 2)
	var pn = c.layer.get_node_or_null("Plaque0")
	var flat_ok = c.mot != null and c.mot.warp != null and pn != null and pn.has_meta("pl_v")
	var drift = 0.0; var xf = true; var zs = []
	if flat_ok:
		for i in 8:
			c.mot.t = 2.0 * i; c._process(0.0)
			if not _xf_same(c) or not c.mot.root.scale.is_equal_approx(c.pic.scale) or not c.mot.root.position.is_equal_approx(c.pic.position): xf = false
			drift = maxf(drift, (pn.position - (pn.get_meta("pl_p0") as Vector2)).length())
			zs.append(c.pic.scale.x)
			if i in [0, 4, 7]:
				await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png(SH + "follow_tavern_t%d.png" % i)
	_chk("後備動態 cg_tavern：鏡頭推移時疊字層＝底圖＝動態層同一套變換；「奈河一杯」喺遠景匾上唔漂移", flat_ok and xf and drift < 0.01 and zs[7] > zs[0], [drift, zs])
	# (3) 後備動態＋匾喺前景（合成個案：被抓包圖臨時加一塊低位匾）→ 字要跟視差一齊錯開
	var PD = CG.plaque_data()
	PD["cg_caught"] = [{"quad": [[0.30, 0.72], [0.70, 0.72], [0.70, 0.86], [0.30, 0.86]], "text": "測試匾"}]
	c.show_spec({"k": "cg_caught"}); await _f(t, 2)
	var p2 = c.layer.get_node_or_null("Plaque0")
	var ok3 = c.mot != null and c.mot.warp != null and p2 != null
	var mx = 0.0; var err = 0.0
	if ok3:
		var mt: ShaderMaterial = c.mot.warp.material
		for i in 10:
			c.mot.t = 1.1 * i + 0.7; c._process(0.0)
			var want = CG.flat_shift(float(p2.get_meta("pl_v")), float(mt.get_shader_parameter("y0")), float(mt.get_shader_parameter("sh")), float(mt.get_shader_parameter("bob")), c.mot.warp.size)
			var got = p2.position - (p2.get_meta("pl_p0") as Vector2)
			err = maxf(err, (got - want).length()); mx = maxf(mx, got.length())
			if not _xf_same(c): ok3 = false
	_chk("後備動態＋前景匾：字跟圖嘅視差位移一齊郁（誤差 <0.01px，位移非零）", ok3 and err < 0.01 and mx > 0.5, [err, mx])
	PD.erase("cg_caught")
	# (4) 分層動態（收賄公案版）：合成一塊匾，鏡頭推近時字跟底圖
	PD["cg_c2_bribe"] = [{"quad": [[0.40, 0.08], [0.60, 0.08], [0.60, 0.16], [0.40, 0.16]], "text": "測試"}]
	c.show_spec({"k": "cg_c2_bribe"}); await _f(t, 2)
	var p3 = c.layer.get_node_or_null("Plaque0")
	var ok4 = c.mot != null and c.mot.warp == null and p3 != null; var z4 = []
	if ok4:
		for i in 6:
			c.mot.t = 3.0 * i; c._process(0.0)
			if not _xf_same(c) or not c.mot.root.scale.is_equal_approx(c.pic.scale) or not c.mot.root.position.is_equal_approx(c.pic.position): ok4 = false
			if (p3.position - (p3.get_meta("pl_p0") as Vector2)).length() > 0.001: ok4 = false   # 分層鏡頭靠成層變換，字本身唔使另外郁
			z4.append(c.pic.scale.x)
	_chk("分層動態 cg_c2_bribe：鏡頭推近時疊字層＝底圖＝角色層同一套變換", ok4 and z4.size() == 6 and z4[5] > z4[0], z4)
	PD.erase("cg_c2_bribe")
	# (5) 關動態（流暢模式）：退返靜態圖，匾照貼、照跟慢推
	CGM.disabled = true
	c.show_spec({"k": "cg_tavern"}); await _f(t, 2)
	c._t = 6.0; c._process(0.0)
	_chk("關動態：酒館退返靜態圖，「奈河一杯」照貼、跟慢推", c.mot == null and c.layer.get_node_or_null("Plaque0") != null and _xf_same(c))
	CGM.disabled = false
	st.skip_scene(); await _f(t, 3)
	var g = 0
	while st.cur != null and g < 20: g += 1; st.advance(); await _f(t, 2)
