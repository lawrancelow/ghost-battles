# 燒嘢線（joss）測試：化寶爐＝陽間包裹
# 用法：GB_TEST=tools/tests/joss_test.json（全新 user dir）
#   [["wait",3],["gdrun","res://tools/tests/joss_test.gd","all"],["quit"]]
# 輸出：[joss] ok/BAD 每項；截圖 /tmp/joss/shots/*.png
extends RefCounted

var ok := 0
var bad := 0
const JS := preload("res://game/joss/joss.gd")
const JU := preload("res://game/joss/joss_ui.gd")
const SHOTS := "/tmp/joss/shots/"
const MIN_PER := 60000.0

func _p(m): print("[joss] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
func _skip(t, n := 8):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func S() -> Dictionary: return J.G.S
func _reset(lv := 1) -> void:
	S().erase("joss"); S().bld["furnace"] = float(lv); S()["furnaceAt"] = 0.0
	JS.now_override = 1.0e12; JS.date_override = "2026-11-19"
func _fresh(lv := 1) -> Dictionary:   # 已經初始化、冇件、計時由而家開始
	_reset(lv); var j = JS.st(); j.q.clear(); j["next"] = JS.now() + JS.interval_ms(lv); j["lvseen"] = float(lv); j.seen["ma00"] = 1.0
	return j
func _bad_words(s: String) -> Array:
	var o = []
	for w in ["神明", "神仙", "菩薩", "佛", "廟", "符", "咒", "香燭", "上香", "燒香", "拜神", "閻王", "盂蘭", "中元", "蠟燭", "道士",
			"WhatsApp", "Lazada", "Shopee", "Google", "iPhone", "Netflix", "TikTok", "Facebook", "Instagram", "Grab", "Microsoft", "Office", "Outlook", "Excel", "PowerPoint", "Starbucks", "McDonald", "KFC", "Samsung", "Toyota", "Proton", "Perodua", "Magnum", "Toto"]:
		if s.contains(w): o.append(w)
	return o

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var m = _main(t)
	var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/selftest_save.json"))
	var d = G.dec(str(o.code))
	d["lv"] = 11.0; d["bld"]["furnace"] = 2.0; d["bld"]["house"] = maxf(4.0, J.num(d.bld.get("house", 4)))
	d["cleared"] = {"1-1": true, "1-2": true, "1-3": true, "2-1": true, "2-2": true, "2-3": true}
	d["furnaceAt"] = G.now_ms() - 3600000.0   # 舊 CD 早已夠鐘
	d.erase("joss")
	d["seen"]["gift_car"] = true
	m.import_save(G.enc(d))
	await _wait_boot(t)
	m = _main(t); m._hide_title(); await _w(t, 1.0); await _skip(t, 10)

	# ---------- 0. 舊存檔兼容 ----------
	var s = S()
	_chk("舊存檔：第一次查詢即建立 S.joss", s.get("joss") is Dictionary)
	_chk("舊存檔：舊 CD 已夠鐘 → 即刻有 1 件包裹", JS.count() >= 1, JS.count())
	_chk("furnaceReady() = 有包裹", J.t(J.cl(J.G.get("furnaceReady"), null, [])))
	# 舊 CD 未夠鐘：第一件喺舊 CD 完嗰刻到
	s.erase("joss"); JS.now_override = 1.0e12; s["furnaceAt"] = JS.now() - 100000.0   # 舊 CD 300 秒，過咗 100 秒
	var j0 = JS.st()
	_chk("舊 CD 未夠鐘：冇件", JS.count() == 0, JS.count())
	_chk("舊 CD 未夠鐘：下一件 = 舊 CD 完", absf(J.num(j0.next) - (JS.now() + 200000.0)) < 2.0, J.num(j0.next) - JS.now())
	JS.now_override = 1.0e12 + 201000.0
	_chk("舊 CD 完咗 → 1 件", JS.count() == 1, JS.count())
	# 化寶爐冇起：唔派件
	_reset(0); JS.st()
	JS.now_override = 1.0e12 + 99 * 3600000.0
	_chk("未起化寶爐：唔派件", JS.count() == 0 and not JS.ready(), JS.count())
	# 啱啱起好：90 秒後第一件，係媽嘅第一封
	s.bld["furnace"] = 1.0; JS.now_override = 2.0e12
	JS.count()
	JS.now_override = 2.0e12 + 91000.0
	_chk("啱起好爐：90 秒後第一件", JS.count() == 1, JS.count())
	var r0 = JS.collect()
	_chk("第一封係媽（ma00）", r0.ok and r0.id == "ma00", r0.get("id"))
	_chk("主線任務『建造化寶爐』照完成得到", J.mc(J.G.get("Quest"), "progress", [{"t": "build", "b": "furnace"}])[0] >= 1)

	# ---------- 1. 計時派件 ----------
	var j = _fresh(1)
	var iv = JS.interval_ms(1)
	_chk("1 級每件 40 分鐘", absf(iv - 40 * MIN_PER / JS.tscale()) < 1.0, iv / MIN_PER)
	JS.now_override = 1.0e12 + iv - 1000.0
	_chk("未夠鐘：0 件", JS.count() == 0)
	JS.now_override = 1.0e12 + iv + 1000.0
	_chk("夠鐘：1 件", JS.count() == 1)
	JS.now_override = 1.0e12 + 2 * iv + 1000.0
	_chk("兩個鐘頭位：2 件", JS.count() == 2)

	# ---------- 2. 離線儲 3 件上限 ----------
	j = _fresh(1)
	JS.now_override = 1.0e12 + 10 * 3600000.0
	_chk("離線 10 個鐘：最多 3 件", JS.count() == 3, JS.count())
	_chk("儲滿：停表（下一件喺而家之後）", J.num(j.next) > JS.now(), (J.num(j.next) - JS.now()) / MIN_PER)
	_chk("儲滿：面板顯示 -1（滿）", JS.next_left_s() < 0)
	JS.collect()
	_chk("收咗一件：剩 2 件，唔會即刻補返", JS.count() == 2, JS.count())
	JS.now_override += iv + 1000.0
	_chk("再過一個間隔：補返到 3 件", JS.count() == 3, JS.count())

	# ---------- 3. 收件入材料 ----------
	j = _fresh(3); JS.now_override += JS.interval_ms(3) + 1000.0
	var before = {}
	for k in ["m_wood", "m_rice", "m_plank", "m_shoubao", "m_bao"]: before[k] = JS.mat_amt(k)
	var r = JS.collect()
	var matok = r.ok and r.rw.size() > 0
	var gotmat = false
	for x in r.get("rw", []):
		if x.k == "mat":
			gotmat = true
			var dlt = JS.mat_amt(x.mid) - J.num(before.get(x.mid, 0))
			if absf(dlt - J.num(x.n)) > 0.01 and x.mid in before: matok = false; _p("  mat mismatch %s %s %s" % [x.mid, dlt, x.n])
	_chk("收件：有材料、數量真係入咗庫（舊資源入 S.res）", matok and gotmat, r.get("rw"))
	_chk("收件：寫入舊信紀錄", j.log.size() >= 1 and str(j.log[0].id) == str(r.id))
	_chk("收件：S.cnt.joss +1", J.num(s.cnt.get("joss", 0)) >= 1)

	# ---------- 4. 升級效果 ----------
	_chk("升級：間隔 1 級 > 5 級 > 10 級（40→20 分鐘）", JS.interval_min(1) > JS.interval_min(5) and JS.interval_min(5) > JS.interval_min(10) and absf(JS.interval_min(10) - 20.0) < 0.01, "%.1f/%.1f/%.1f" % [JS.interval_min(1), JS.interval_min(5), JS.interval_min(10)])
	_chk("升級：數量倍數 1 級 < 10 級", JS.qmul(1) < JS.qmul(10), "%.1f→%.1f" % [JS.qmul(1), JS.qmul(10)])
	_chk("升級：稀有權重 1 級 < 10 級", JS.rare_mul(1) < JS.rare_mul(10))
	var tiers = {1: {}, 10: {}}
	for L in [1, 10]:
		var tot = 0.0
		for i in 300:
			var b = JS.base_bundle(L, false)
			for k in b:
				tiers[L][k] = 1
				tot += b[k] * {"m_wood": 1.0, "m_rice": 1.0, "m_plank": 2.5, "m_bao": 2.5, "m_shoubao": 6.0}.get(k, 1.0)
		tiers[L]["v"] = tot
	_chk("升級：基本材料價值 10 級 > 1 級", tiers[10].v > tiers[1].v * 2, "%d vs %d" % [int(tiers[1].v), int(tiers[10].v)])
	_chk("升級：1 級只出原料，10 級有壽包", not tiers[1].has("m_shoubao") and not tiers[1].has("m_plank") and tiers[10].has("m_shoubao"))
	_chk("升級：稀有信（紙紮員工／裝飾）低級唔出", JS.pool_of("n", 1).filter(func(x): return x.id in ["ma04", "ma10", "sh04", "wr02"]).is_empty() and JS.pool_of("n", 10).filter(func(x): return x.id in ["ma04", "ma10", "sh04", "wr02"]).size() == 4)

	# ---------- 5. 紙條唔重複 ----------
	var ids = {}; var texts = {}; var dup = []
	var LET: Array = JS.D().LETTERS
	for x in LET:
		if ids.has(x.id): dup.append(x.id)
		ids[x.id] = 1
		for key in ["t", "f"]:
			if x.get(key) is Array:
				for i in 2:
					var tx = str(x[key][i])
					if texts.has(tx) and not (i == 1 and tx == str(x[key][0])): dup.append(x.id + ":" + key)
					texts[tx] = 1
	_chk("紙條：最少 40 封唔同", LET.size() >= 40, LET.size())
	_chk("紙條：id／內文冇重複", dup.is_empty(), dup)
	var nn = LET.filter(func(x): return x.pool == "n").size()
	j = _fresh(10); j.seen.clear(); j.seen["ma00"] = 1.0
	var got = {}; var rep = []
	for i in nn:
		j.q.append({"k": "n", "t": JS.now()})
		var rr = JS.collect()
		if got.has(rr.id): rep.append(rr.id)
		got[rr.id] = 1
	_chk("紙條：連收 %d 件普通包裹，一封都冇重複" % nn, rep.is_empty() and got.size() == nn, "%d 封；重複 %s" % [got.size(), rep])
	j.q.append({"k": "n", "t": JS.now()}); var rr2 = JS.collect()
	_chk("紙條：全部睇晒先再輪（揀返最少睇嗰批）", rr2.ok and got.has(rr2.id))
	# 每種寄件人都有
	var whos = {}
	for x in LET: whos[x.who] = 1
	_chk("寄件人齊：媽、阿爸、舊同事、HR、寄錯地址、網購、鄰居、表姐", whos.has("ma") and whos.has("ba") and whos.has("col") and whos.has("hr") and whos.has("wr") and whos.has("sh") and whos.has("cz") and whos.has("bj"), whos.keys())
	var pools = {}
	for x in LET: pools[x.pool] = 1
	_chk("特別日子都有：清明、七月、冬至、新年、生日", pools.has("qingming") and pools.has("ghost") and pools.has("dongzhi") and pools.has("cny") and pools.has("bday"))
	# 字型：所有會顯示嘅字都要喺遊戲字型入面（字型係子集，缺字會變豆腐）
	var miss = {}
	var fnts = [UIKit.font("serif", 400), UIKit.font("serif", 900), UIKit.font("sans", 400), UIKit.font("sans", 700), UIKit.font("sans", 900)]
	var lang1 = DB.lang; var hero1 = (s.hero as Dictionary).duplicate() if s.get("hero") is Dictionary else {}
	var all_txt = ""
	for hx in [["阿福", "m"], ["阿慧", "f"]]:
		DB.hero_apply(DB.hero_make(hx[0], hx[1]))
		for lg in ["yue", "zh"]:
			DB.lang = lg
			for x in LET: all_txt += JS.text_of(x) + JS.sender_of(x) + JS.item_of(x) + JS.note_of(x) + JS.fest_name(str(x.pool))
			for k in JS.D().STRINGS: all_txt += JS.STR(k)
			for k in JS.D().DECO: all_txt += JS.P(JS.D().DECO[k].n) + JS.P(JS.D().DECO[k].d)
			all_txt += JS.tix_name("spd") + JS.tix_name("inc") + JS.quality_text(1) + JS.quality_text(4) + JS.quality_text(6) + JS.quality_text(9)
	DB.lang = lang1
	if hero1.size(): DB.hero_apply(hero1)
	for ch in all_txt:
		var u = ch.unicode_at(0)
		if u < 0x2e80: continue
		for f in fnts:
			if not f.has_char(u): miss[ch] = 1
	_chk("字型：信、寄件人、紙紮名、裝飾全部有字（冇豆腐）", miss.is_empty(), "".join(miss.keys()))
	# 紅線字
	var badw = _bad_words(FileAccess.get_file_as_string("res://data/nat/joss.json"))
	_chk("紅線：冇神明／符咒／廟／香燭／閻王／盂蘭／真實品牌", badw.is_empty(), badw)

	# ---------- 6. 節日大包裹 ----------
	_chk("節日：2026-08-20 = 七月", JS.fest_of({"year": 2026, "month": 8, "day": 20}) == "ghost")
	_chk("節日：2026-09-11 已經八月 = 普通", JS.fest_of({"year": 2026, "month": 9, "day": 11}) == "")
	_chk("節日：2026-04-05 = 清明", JS.fest_of({"year": 2026, "month": 4, "day": 5}) == "qingming")
	_chk("節日：2027-02-07 = 新年", JS.fest_of({"year": 2027, "month": 2, "day": 7}) == "cny")
	_chk("節日：12-21 = 冬至", JS.fest_of({"year": 2026, "month": 12, "day": 21}) == "dongzhi")
	j = _fresh(2); JS.date_override = "2026-08-20"; j.fest.clear()
	JS.now_override += 2 * JS.interval_ms(2) + 1000.0
	JS.count()
	_chk("節日：七月第一件係大包裹，第二件係普通（每年一次）", j.q.size() == 2 and j.q[0].k == "ghost" and j.q[1].k == "n", j.q)
	var rf = JS.collect()
	_chk("節日：大包裹用七月信", rf.ok and str(rf.id).begins_with("gh") and rf.fest != "", rf.get("id"))
	JS.date_override = "2026-11-19"

	# ---------- 7. 兩個主角稱呼 ----------
	var keep_hero = (s.hero as Dictionary).duplicate() if s.get("hero") is Dictionary else {}
	var lang0 = DB.lang
	var co = JS.letter("co01"); var ma = JS.letter("ma01"); var hr = JS.letter("hr01")
	DB.hero_apply(DB.hero_make("阿福", "m"))
	for lg in ["yue", "zh"]:
		DB.lang = lg
		_chk("男主（%s）：媽信叫阿福" % lg, JS.text_of(ma).begins_with("阿福："))
		_chk("男主（%s）：舊同事叫 Kelvin、寄件人舊同事" % lg, JS.text_of(co).begins_with("Kelvin") and JS.sender_of(co).contains("舊同事"))
		_chk("男主（%s）：HR 叫陳大福先生" % lg, JS.text_of(hr).begins_with("陳大福先生"))
	DB.hero_apply(DB.hero_make("阿慧", "f"))
	var leak = []
	for lg in ["yue", "zh"]:
		DB.lang = lg
		_chk("女主（%s）：媽信叫阿慧、用女版內容" % lg, JS.text_of(ma).begins_with("阿慧：") and JS.text_of(ma).contains("自修室"))
		_chk("女主（%s）：組員、寄件人分組組員" % lg, JS.text_of(co).begins_with("阿慧") and JS.sender_of(co).contains("組員"))
		_chk("女主（%s）：學生事務處叫阿慧同學" % lg, JS.text_of(hr).begins_with("阿慧同學") and JS.sender_of(hr).contains("學生事務處"))
		for x in LET:
			var tx = JS.text_of(x) + JS.sender_of(x)
			for w in ["阿福", "陳大福", "Kelvin", "黃總", "PPT", "OT", "返工", "老細", "老闆", "西裝", "上班", "公司"]:
				if tx.replace("店老闆", "").replace("舖老闆", "").contains(w): leak.append("%s:%s" % [x.id, w])
	_chk("女主：所有信都冇男主職場字（阿福、黃總、PPT、返工…）", leak.is_empty(), leak)
	DB.hero_apply(DB.hero_make("小明", "m"))
	DB.lang = "yue"
	_chk("改名（小明）：媽信叫小明", JS.text_of(ma).begins_with("小明："))
	_chk("改名（小明）：HR 冇陳大福", not JS.text_of(hr).contains("陳大福"), JS.text_of(hr).substr(0, 12))
	DB.lang = lang0
	if keep_hero.size(): DB.hero_apply(keep_hero)
	else: DB.hero_apply(DB.hero_make("阿福", "m"))

	# ---------- 8. 加速卡 ----------
	j = _fresh(2)
	j.tix["spd"] = 1.0
	if not (s.get("mv") is Dictionary): s["mv"] = {}
	if not (s.mv.get("boost") is Dictionary): s.mv["boost"] = {}
	var cd0 = J.now() + 500000.0
	s.mv.boost["spd_cd"] = cd0; s.mv.boost["spd_end"] = 0.0
	var used = JS.use_tix("spd")
	_chk("加速卡：冷卻緊都用得、即刻生效、唔改冷卻", used and J.num(s.mv.boost.spd_end) > J.now() + 60000 and J.num(s.mv.boost.spd_cd) == cd0 and JS.tix("spd") == 0)
	_chk("加速卡：冇券就用唔到", not JS.use_tix("spd"))

	# ---------- 9. 稀有：紙紮員工、裝飾、裝備 ----------
	var ng = s.ghosts.size()
	var rg = JS.give_ghost(["紙紮面談員", "紙紮面談員"])
	_chk("紙紮員工：新雜鬼（紙人、紫）或者名額滿就紫箱", (rg.k == "ghost" and s.ghosts.size() == ng + 1 and s.ghosts[-1].k == "zhiren") or rg.k == "chest", rg.label)
	var rd = JS.give_deco("d_cat", 3)
	_chk("限定裝飾：入收藏櫃", rd.k == "deco" and J.t(JS.st().deco.get("d_cat")))
	var rd2 = JS.give_deco("d_cat", 3)
	_chk("限定裝飾：重複就變壽包", rd2.k == "mat")
	var ni = (s.gear.items as Array).size() if s.get("gear") is Dictionary else 0
	var ge = JS.give_gear("arm", false)
	_chk("紙紮裝備：入裝備房（S.gear.items）", s.gear.items.size() == ni + 1 and str(ge.name).begins_with("紙紮"), ge)

	# ---------- 10. 介面截圖 ----------
	JS.now_override = -1.0; JS.date_override = ""
	s.bld["furnace"] = 3.0
	j = JS.st(); j.q.clear(); j.q.append({"k": "n", "t": J.now()}); j.q.append({"k": "n", "t": J.now()}); j["next"] = J.now() + 600000.0
	j.tix["spd"] = 2.0; j.tix["inc"] = 1.0
	# 移動村：後院掣角標
	if m.mv_on():
		m._nav_on("village"); await _w(t, 1.5)
		await _shot(t, "01_mv_backyard_badge")
		var bd = m.mv_back.get_node_or_null("JossBadge")
		_chk("移動村：後院掣有青煙＋數字角標", bd != null and bd.visible and bd.n == 2, bd.n if bd else "冇")
		m.open_backyard(); await _w(t, 0.6)
		await _shot(t, "02_backyard_list")
		m.open_building("furnace"); await _w(t, 0.8)
		await _shot(t, "03_furnace_panel_mv")
		m.close_sheet()
	# 舊村子：化寶爐青煙＋數字
	m.set_mv(false); await _w(t, 2.0); await _skip(t, 12)
	var POS = J.G.get("POS"); var fp = POS.furnace
	J.mc(J.G.get("Village"), "focus", [J.num(fp[0]), J.num(fp[1])]); await _w(t, 2.0)
	await _shot(t, "04_village_furnace_hint")
	J.mc(J.G.get("UI"), "openBuilding", ["furnace"]); await _w(t, 1.0)
	await _shot(t, "05_furnace_panel_old")
	_chk("面板：有收件掣", _find_btn(m, "收件") != null)
	J.mc(J.G.get("UI"), "close", []); await _w(t, 1.2)
	await _skip(t, 12)
	# 撳爐 → 直接開包
	_p("  modalOpen=%s busy=%s" % [J.mc(J.G.get("UI"), "modalOpen", []), J.mc(J.G.get("Story"), "busy", [])])
	J.mc(J.G.get("Village"), "tap", [J.num(fp[0]), J.num(fp[1]) - 30.0]); await _w(t, 0.25)
	var u = m.get_node_or_null("JossUnbox")
	_chk("撳化寶爐（有包裹）→ 直接開包畫面", u != null)
	if u == null: JU.open_next(); await _w(t, 0.1); u = m.get_node_or_null("JossUnbox")
	await _w(t, 0.5); await _shot(t, "06_unbox_smoke")
	await _w(t, 0.9); await _shot(t, "07_unbox_form")
	await _w(t, 1.6); await _shot(t, "08_unbox_letter")
	_chk("開包：八行箋紙條出咗", u != null and is_instance_valid(u) and u.card != null)
	_chk("開包：字最細 14px", _min_font(u) >= 14, _min_font(u))
	_chk("開包：紙條冇爆出畫面", _inside(u), "")
	# 下一件
	var nb = _find_btn(u, "下一件")
	_chk("開包：有『下一件』", nb != null)
	if nb: nb.emit_signal("pressed"); await _w(t, 3.2); await _shot(t, "09_unbox_next")
	var cb = _find_btn(u, "收好")
	if cb: cb.emit_signal("pressed")
	await _w(t, 0.5)
	_chk("收好：開包畫面收埋", m.get_node_or_null("JossUnbox") == null or not is_instance_valid(u))
	# 女主＋粵語版紙條
	DB.hero_apply(DB.hero_make("阿慧", "f")); DB.lang = "yue"
	j.q.append({"k": "ghost", "t": J.now()})
	JU.open_next(); await _w(t, 3.0)
	await _shot(t, "10_unbox_female_yue_fest")
	var u2 = m.get_node_or_null("JossUnbox")
	if u2: _chk("開包（女主粵語節日）：字最細 14px", _min_font(u2) >= 14, _min_font(u2))
	# 舊信重溫
	JU.open_entry(JS.st().log[1]); await _w(t, 0.8)
	await _shot(t, "11_reread")
	var u3 = m.get_node_or_null("JossUnbox")
	_chk("同一時間得一個開包畫面", u3 != null and u3 != u2 and (u2 == null or not is_instance_valid(u2) or u2.is_queued_for_deletion()))
	if u3: u3._close()
	DB.lang = lang0
	if keep_hero.size(): DB.hero_apply(keep_hero)
	# 長獎勵字（紙紮員工＋民宅滿咗紫箱）唔爆格
	var fake = {"ok": true, "id": "hr02", "kind": "n", "fest": "", "item": "紙紮面談員", "sender": "黃總公司人事部", "text": JS.text_of(JS.letter("hr02")), "note": "", "shape": "figure", "art": "",
		"rw": [{"k": "mat", "mid": "m_plank", "n": 24, "label": "棺材板 +24", "icon": JS.mat_icon("m_plank")}, {"k": "ghost", "label": "紙紮員工：紙紮面談員・Ah Boy（紫，雜鬼）"}, {"k": "chest", "label": JS.T("%s想入村，但係冇位住（民宅滿咗）→ 留低紫箱 ×1", "%s想入村，但沒地方住（民宅滿了）→ 留下紫箱 ×1") % "紙紮面談員"}, {"k": "tix", "label": "加速卡 ×1"}], "more": 0}
	var u4 = load("res://game/joss/joss_ui.gd").Unbox.new(); m.add_child(u4); u4.setup(fake); await _w(t, 3.0)
	await _shot(t, "13_unbox_long_rewards")
	_chk("開包：長獎勵字唔爆格", _inside(u4))
	u4.queue_free()
	# 面板（多券、收藏、舊信）
	J.mc(J.G.get("UI"), "openBuilding", ["furnace"]); await _w(t, 1.0)
	await _shot(t, "12_furnace_panel_full")
	_chk("面板：字最細 14px（燒嘢線部分）", _min_font_joss(m.sheet_body) >= 14, _min_font_joss(m.sheet_body))
	J.mc(J.G.get("UI"), "close", [])
	m.set_mv(true); await _w(t, 1.0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _find_btn(n: Node, sub: String):
	if n == null: return null
	for c in n.get_children():
		if c is Button and str(c.text).contains(sub) and c.is_visible_in_tree(): return c
		var r = _find_btn(c, sub)
		if r != null: return r
	return null
func _min_font(n: Node) -> int:
	var mn = 999
	if n == null: return mn
	for c in n.get_children():
		if c is Control and c.is_visible_in_tree():
			for key in ["font_size", "normal_font_size"]:
				if c.has_theme_font_size_override(key): mn = mini(mn, c.get_theme_font_size(key))
		mn = mini(mn, _min_font(c))
	return mn
func _min_font_joss(body: Node) -> int:   # 面板入面：由第一個燒嘢線 PanelContainer 開始計
	for c in body.get_children():
		if c is PanelContainer and (_find_btn(c, "收件") != null or _find_btn(c, "包裹") != null): return _min_font(c)
	return -1
func _inside(u) -> bool:
	if u == null or not is_instance_valid(u) or u.card == null: return false
	var r = u.card.get_global_rect(); var vs = u.get_viewport_rect().size
	if not (r.position.x >= 0 and r.end.x <= vs.x + 0.5 and r.position.y >= 0): return false
	return _kids_inside(u.card, r)
func _kids_inside(n: Node, r: Rect2) -> bool:
	for c in n.get_children():
		if c is Control and c.is_visible_in_tree():
			var cr = c.get_global_rect()
			if cr.end.x > r.end.x + 0.5 or cr.position.x < r.position.x - 0.5: _p("  爆格：%s %s" % [c, cr]); return false
		if not _kids_inside(c, r): return false
	return true
