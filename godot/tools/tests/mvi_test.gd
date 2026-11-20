# 移動村整合測試（整合線）
# 用法：GB_TEST=tools/tests/mvi_test.json（全新 user dir）
#   [["wait",3],["gdrun","res://tools/tests/mvi_test.gd","all"],["quit"]]
# 輸出：[mvi] ok/bad 每項；截圖 /tmp/mvi/shots/*.png
extends RefCounted

var ok := 0
var bad := 0
const B := preload("res://game/outpost/mv_bridge.gd")
const SHOTS := "/tmp/mvi/shots/"

func _p(m): print("[mvi] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 8):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.3)
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
func GR(t): return t.get_tree().root.get_node_or_null("Garrison")

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var m = _main(t)
	# ---------- 1. 新存檔：預設開、冇介紹、落第一張圖 ----------
	var S = J.G.S
	_chk("新存檔 mv_on", J.t(S.get("mv_on")))
	_chk("新存檔唔彈介紹", int(J.num(S.get("mv_intro", 0))) == 2)
	_chk("新存檔 ci=0", B.ci() == 0, B.ci())
	m._hide_title(); await _w(t, 1.0)
	_chk("home 分頁 = 合一地圖（村子＋大排檔區）", m.get("mv_embed") != null and m.village.visible)   # [unify]
	_chk("前線 = 移動村所在", GR(t).frontline() == B.ci(), "%d/%d" % [GR(t).frontline(), B.ci()])
	await _shot(t, "01_new_home")

	# ---------- 2. 中期舊存檔匯入 ----------
	var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/selftest_save.json"))
	var d = G.dec(str(o.code))
	d.erase("mv_on"); d.erase("mv"); d.erase("mv_intro")
	d["lv"] = 11.0; d["qi"] = 29.0
	d["cleared"] = {"1-1": true, "1-2": true, "1-3": true, "2-1": true, "2-2": true, "2-3": true, "3-1": true}
	d["bld"] = {"house": 4.0, "wood": 3.0, "rice": 3.0, "plank": 2.0, "bun": 3.0, "store": 2.0, "home": 2.0, "camp": 1.0, "altar": 1.0, "furnace": 1.0}
	d["res"] = {"wood": 300.0, "rice": 300.0, "planks": 200.0, "buns": 200.0, "coins": 5000.0, "troops": 80.0}
	for g in d.ghosts:
		match str(g.k):
			"xiaozhi": g["post"] = "bun"
			"eguiking": g["post"] = "plank"
			"toyol": g["post"] = "store"
	d["seen"]["gift_xiaozhi"] = true
	m.import_save(G.enc(d))
	await _wait_boot(t)
	m = _main(t); S = J.G.S
	_chk("舊存檔 mv_on", J.t(S.get("mv_on")))
	_chk("舊存檔落最前線（第 3 張圖 ci=2）", B.ci() == 2, B.ci())
	_chk("Garrison.frontline()==S.mv.ci", GR(t).frontline() == 2, GR(t).frontline())
	_chk("已打通嘅圖 = 分村（0、1 開；2 未）", GR(t).is_open(0) and GR(t).is_open(1) and not GR(t).is_open(2))
	_chk("舊崗位照保留（後院照做）", B.ghost(_gid(S, "xiaozhi")).get("post") == "bun")
	# 介紹（等標題／手機）
	m._hide_title(); await _w(t, 1.5)
	var st = m.get("story")
	# 其他劇情（例如章節 onStart）播緊就等佢播完先輪到介紹：跳過其他劇情，等介紹出現
	var seen_intro = false
	for i in 30:
		if int(J.num(S.get("mv_intro", 0))) == 2 and st.get("cur") != null and not seen_intro:
			seen_intro = true; await _w(t, 0.8); await _shot(t, "02_old_intro"); break
		if st.get("cur") != null: st.skip_scene()
		await _w(t, 0.5)
	_chk("介紹（等其他劇情播完）有彈", seen_intro and int(J.num(S.get("mv_intro", 0))) == 2, S.get("mv_intro"))
	await _skip(t, 6)
	await _shot(t, "03_old_home")
	# 虛擬建築只升唔跌
	_chk("建築等級冇跌（plank 2）", J.num(S.bld.plank) >= 2 and J.num(S.bld.house) >= 4, str(S.bld))

	# ---------- 3. 資源照有產出（移動村開住、冇舊崗位都有）----------
	var mv = m.mv_view
	_chk("場景 API 齊", mv.has_method("mv_state") and mv.has_method("ci") and mv.has_method("can_move") and mv.has_method("move_next") and mv.has_method("offline_gain") and mv.has_method("on_show") and mv.has_method("on_hide"))
	# [chain] 生產鏈：冇舊「副產出」——冇後院崗位就冇壽包／棺材板；壽包只由嘆氣蒸籠出
	for gh in S.ghosts: if gh.get("post") != null and gh.get("post") != "garrison": gh["post"] = null
	var r1 = J.cl(J.G.get("ratesPerMin"), null, [])
	_chk("冇後院崗位：冇副產出（壽包／棺材板 = 0）", J.num(r1.buns) == 0.0 and J.num(r1.planks) == 0.0, "%.1f/%.1f" % [J.num(r1.buns), J.num(r1.planks)])
	# 後院派鬼（舊建築崗位照用）：伐木、割稻、做板、包包子
	var spare = []
	for gh in S.ghosts: if gh.get("post") == null and str(gh.k) != "afu": spare.append(gh)
	var posts = ["wood", "rice", "plank", "bun"]
	for i in mini(spare.size(), posts.size()):
		if J.num(S.bld.get(posts[i], 0)) <= 0: S.bld[posts[i]] = 1.0
		spare[i]["post"] = posts[i]
	var CM = load("res://game/outpost/mat.gd")
	var before = (S.res as Dictionary).duplicate(); var bao0 = CM.amt("m_bao")
	J.cl(J.G.get("produce"), null, [600.0])
	for k in ["wood", "rice", "planks"]:
		_chk("後院 10 分鐘有產出 " + k, J.num(S.res[k]) > J.num(before[k]), "%d→%d" % [int(before[k]), int(S.res[k])])
	_chk("包子鋪出普通包子（m_bao 有加）", CM.amt("m_bao") > bao0 or spare.size() < 4, "%.1f→%.1f" % [bao0, CM.amt("m_bao")])
	_chk("包子鋪唔再出壽包", J.num(S.res.buns) <= J.num(before.buns) + 0.001, "%.1f→%.1f" % [J.num(before.buns), J.num(S.res.buns)])
	for gh in spare: gh["post"] = null
	# 開台、派鬼（材料塞夠，睇移動村扣料做貨）
	for mid in CM.all_ids():
		if CM.res_key(str(mid)) == "": S.mat[str(mid)] = 500.0
	S.res["coins"] = 100000.0
	for sid in mv.sids():
		var e = mv.ent(sid)
		if not J.t(e.unlocked): mv._pay_unlock(sid, J.num(mv.sdef(sid).get("unlock_cost", 0)))
		for i in 9: mv._pay_up(sid, mv.up_cost(sid))
		mv._hire(sid)
	_chk("員工 post=mv，任務『任命打工』計到", J.num(J.mc(J.G.get("Quest"), "progress", [{"t": "assign", "n": 3}])[0]) >= 3)
	B.sync()
	S.mv["made"] = {"m_shoubao": 12.0}; B.sync()
	_chk("任務計數：包壽包 = 嘆氣蒸籠產出數", J.num(S.cnt.craftBun) >= 12, int(S.cnt.craftBun))
	# 互斥：同一隻鬼派去分村 → 移動村名單自動清走
	var w0 = null
	for sid in mv.sids():
		if mv.ent(sid).workers.size() > 0: w0 = mv.ent(sid).workers[0]; break
	if w0 != null:
		GR(t).assign(0, "bun", 1, w0); B.validate()
		var still = false
		for sid in mv.sids(): if (mv.ent(sid).workers as Array).has(w0): still = true
		_chk("派去分村 → 移動村自動除名（互斥）", not still and J.seq(B.ghost(w0).get("post"), "garrison"))
	await _w(t, 1.0); await _shot(t, "04_stations")

	# ---------- 4. 離線唔重複計（[chain] 後院＋移動村交替按生產鏈計） ----------
	B.sync()
	var ips = mv.income_ps()
	S["last"] = J.now() - 2 * 3600 * 1000.0
	var c0 = J.num(S.res.coins)
	J.cl(J.G.get("offlineGain"), null, [])
	var dc = J.num(S.res.coins) - c0
	_chk("離線有冥幣、唔超過全速估算", dc > 0.0 and dc <= ips * 7200 + 5, "dc=%.0f 全速=%.0f" % [dc, ips * 7200])
	var c1 = J.num(S.res.coins)
	J.cl(J.G.get("offlineGain"), null, [])
	_chk("即刻再叫離線 = 0（唔重複）", absf(J.num(S.res.coins) - c1) < 1.0, J.num(S.res.coins) - c1)
	_chk("場景 check_away 唔再計（S.mv.last 已更新）", mv.sim.check_away().is_empty())
	S["last"] = J.now() - 20 * 3600 * 1000.0
	c1 = J.num(S.res.coins)
	J.cl(J.G.get("offlineGain"), null, [])
	_chk("離線上限 8 小時", J.num(S.res.coins) - c1 <= ips * 8 * 3600 + 5, J.num(S.res.coins) - c1)
	await _skip(t, 4)

	# ---------- 5. 拔營 ----------
	_chk("Boss 未打：唔拔得", not mv.can_move())
	S.cleared["3-2"] = true; S.cleared["3-3"] = true
	var ms = mv.mv_state(); ms["goals_done"] = []   # 真場景：目標要全部領咗先拔得營
	for gi in 20: ms.goals_done.append(gi)
	load("res://game/zone/zone_data.gd").mark_all_bosses(int(J.num(ms.ci)))   # [zone2] 第 3 關都係分區地圖：野外王全部打低先拔得營
	_chk("目標齊＋Boss 打咗：拔得", mv.can_move())
	mv.move_next(true)
	_chk("拔營後 ci=3", B.ci() == 3, B.ci())
	_chk("拔營後前線跟住移動村", GR(t).frontline() == 3 and GR(t).is_open(2) and not GR(t).is_open(3))
	await _w(t, 1.0); await _shot(t, "05_moved")

	# ---------- 6. [unify] 合一地圖：唔再有開關（set_mv(false) 都會開返合一），村子畫面一直顯示 ----------
	m.set_mv(false); await _w(t, 1.0)
	_chk("合一：關唔到（mv_on 照開）", B.on() and m.village.visible and not m.mv_host.visible)
	var wv = 0
	for c in m.village.world.get_children(): if c.visible: wv += 1
	_chk("合一：原村子有畫嘢（world 子節點可見）", wv >= 4, wv)
	await _shot(t, "06_unified_village")
	# 後院
	m.open_backyard(); await _w(t, 1.0); await _shot(t, "07_backyard")
	m.close_sheet()
	# 任務文字
	var qs = J.G.get("QUESTS")
	_chk("任務文字（建造棺材鋪）有移動村版", B.quest_text(qs[2]) != str(qs[2].text), B.quest_text(qs[2]))
	_chk("任務文字（砍樹）指去營地", B.quest_text(qs[0]).contains("營地"), B.quest_text(qs[0]))   # [camp] 後院 → 營地
	_chk("任務文字（包壽包）= 嘆氣蒸籠", B.quest_text(qs[5]).contains("嘆氣蒸籠"), B.quest_text(qs[5]))
	J.cl(J.G.get("save"), null, [])
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _gid(S, k: String):
	for g in S.ghosts: if str(g.k) == k: return g.id
	return null
