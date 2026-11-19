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
	_chk("home 分頁 = 移動村", m.mv_host.visible and not m.village.visible)
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
	for gh in S.ghosts: if gh.get("post") != null and gh.get("post") != "garrison": gh["post"] = null   # 清走舊崗位：淨係靠移動村
	var r0 = J.cl(J.G.get("__mv_rates_orig"), null, [])
	var r1 = J.cl(J.G.get("ratesPerMin"), null, [])
	_chk("冇舊崗位：舊公式冇壽包", J.num(r0.buns) == 0.0, r0.buns)
	_chk("移動村保底：壽包／棺材板／陰兵 > 0", J.num(r1.buns) > 0 and J.num(r1.planks) > 0 and J.num(r1.troops) > 0, "%.1f/%.1f/%.1f" % [J.num(r1.buns), J.num(r1.planks), J.num(r1.troops)])
	var before = (S.res as Dictionary).duplicate()
	J.cl(J.G.get("produce"), null, [600.0])
	for k in ["wood", "rice", "planks", "buns", "troops"]:
		_chk("10 分鐘有產出 " + k, J.num(S.res[k]) > J.num(before[k]), "%d→%d" % [int(before[k]), int(S.res[k])])
	# 開台、派鬼：產出要升
	S.res["coins"] = 100000.0
	for sid in mv.sids():
		var e = mv.ent(sid)
		if not J.t(e.unlocked): mv._pay_unlock(sid, J.num(mv.sdef(sid).get("unlock_cost", 0)))
		for i in 9: mv._pay_up(sid, mv.up_cost(sid))
		mv._hire(sid)
	var r2 = J.cl(J.G.get("ratesPerMin"), null, [])
	_chk("開台＋升級＋派鬼後產出更多", J.num(r2.buns) > J.num(r1.buns) and J.num(r2.planks) > J.num(r1.planks) and J.num(r2.troops) > J.num(r1.troops), "%.1f/%.1f/%.1f" % [J.num(r2.buns), J.num(r2.planks), J.num(r2.troops)])
	_chk("員工 post=mv，任務『任命打工』計到", J.num(J.mc(J.G.get("Quest"), "progress", [{"t": "assign", "n": 3}])[0]) >= 3)
	B.sync()
	_chk("任務計數：做板／包包跟台等級", J.num(S.cnt.craftPlank) >= 10 and J.num(S.cnt.craftBun) >= 10, "%d/%d" % [int(S.cnt.craftPlank), int(S.cnt.craftBun)])
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

	# ---------- 4. 離線唔重複計 ----------
	B.sync()
	var ips = mv.income_ps()
	S["last"] = J.now() - 2 * 3600 * 1000.0
	var c0 = J.num(S.res.coins); var b0 = J.num(S.res.buns)
	J.cl(J.G.get("offlineGain"), null, [])
	var dc = J.num(S.res.coins) - c0
	var exp_mv = ips * 7200 * 0.5
	_chk("離線冥幣 ≈ 移動村 offline_gain（一次）", absf(dc - exp_mv) < maxf(5.0, exp_mv * 0.05), "dc=%.0f mv=%.0f" % [dc, exp_mv])
	_chk("離線壽包有加（produce 鏈）", J.num(S.res.buns) > b0)
	var c1 = J.num(S.res.coins)
	J.cl(J.G.get("offlineGain"), null, [])
	_chk("即刻再叫離線 = 0（唔重複）", absf(J.num(S.res.coins) - c1) < 1.0, J.num(S.res.coins) - c1)
	S["last"] = J.now() - 20 * 3600 * 1000.0
	c1 = J.num(S.res.coins)
	J.cl(J.G.get("offlineGain"), null, [])
	_chk("離線上限 8 小時", J.num(S.res.coins) - c1 <= ips * 8 * 3600 * 0.5 + 5, J.num(S.res.coins) - c1)
	await _skip(t, 4)

	# ---------- 5. 拔營 ----------
	_chk("Boss 未打：唔拔得", not mv.can_move())
	S.cleared["3-2"] = true; S.cleared["3-3"] = true
	_chk("目標齊＋Boss 打咗：拔得", mv.can_move())
	mv.move_next()
	_chk("拔營後 ci=3", B.ci() == 3, B.ci())
	_chk("拔營後前線跟住移動村", GR(t).frontline() == 3 and GR(t).is_open(2) and not GR(t).is_open(3))
	await _w(t, 1.0); await _shot(t, "05_moved")

	# ---------- 6. 開關關咗用返舊村子 ----------
	m.set_mv(false); await _w(t, 2.0)
	_chk("開關關：舊村子畫面", m.village.visible and not m.mv_host.visible)
	var wv = 0
	for c in m.village.world.get_children(): if c.visible: wv += 1
	_chk("開關關：舊村子有畫嘢（world 子節點可見）", wv >= 4, wv)
	_chk("開關關：前線用返舊算法", GR(t).frontline() == B.front_by_progress(), GR(t).frontline())
	var r3 = J.cl(J.G.get("ratesPerMin"), null, [])
	_chk("開關關：冇移動村副產出", absf(J.num(r3.buns) - J.num(J.cl(J.G.get("__mv_rates_orig"), null, []).buns)) < 0.001)
	await _shot(t, "06_old_village")
	m.set_mv(true); await _w(t, 1.5)
	_chk("開關開返", m.mv_host.visible and not m.village.visible)
	# 後院
	m.open_backyard(); await _w(t, 1.0); await _shot(t, "07_backyard")
	m.close_sheet()
	# 任務文字
	var qs = J.G.get("QUESTS")
	_chk("任務文字（建造棺材鋪）有移動村版", B.quest_text(qs[2]) != str(qs[2].text), B.quest_text(qs[2]))
	_chk("任務文字（砍樹）有移動村版", B.quest_text(qs[0]).contains("棺材板工場"), B.quest_text(qs[0]))
	J.cl(J.G.get("save"), null, [])
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _gid(S, k: String):
	for g in S.ghosts: if str(g.k) == k: return g.id
	return null
