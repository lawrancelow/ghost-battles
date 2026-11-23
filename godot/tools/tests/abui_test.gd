# [abui] 戰鬥畫面與偵察卡測試
# 用法：bash /home/claude/setup/edtest.sh /home/claude/wt/abui/godot abui res://tools/tests/abui_test.gd logic|shots_ 600
#   logic：stub 介面、應對計算、推薦＋換上、揀軍師、頭頂狀態讀法、長按自動／手動（真係影響模擬）、ab 飄字、偵察卡唔出界
#   shots_：logic ＋ 截圖（/home/claude/docs/shots/abui/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/shots/abui/"
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const RV = preload("res://game/rts/rts_view.gd")
const SO = preload("res://game/sortie/so_data.gd")
const SOV = preload("res://game/sortie/so_view.gd")
const AB = preload("res://game/rts/abil.gd")
const AC = preload("res://game/rts/ab_card.gd")
const AH = preload("res://game/rts/ab_hud.gd")
const AI = preload("res://game/rts/ab_icon.gd")
const AL = preload("res://game/rts/ab_lay.gd")

func _p(m): print("[abui] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	if not shots: return
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	var idle = 0
	for i in maxi(n, 40):
		var m = _main(t); var st = m.get("story") if m else null
		var Sy = J.G.get("Story")
		var busy = (st and st.get("cur") != null) or (Sy != null and J.t(J.mc(Sy, "busy", [])))
		if st and st.get("cur") != null: st.skip_scene()
		if not busy:
			idle += 1
			if idle >= 3 and i >= n - 1: break
		else: idle = 0
		await _w(t, 0.25)
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _cam(m, p: Vector2, z := -1.0) -> void:
	var c = m.village.zone_cam()
	if z > 0: c.z = z; c.clamp_all()
	c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)
func _has_k(k: String) -> bool:
	for g in J.G.S.ghosts: if str(g.k) == k: return true
	return false
func _id_of(k: String):
	for g in J.G.S.ghosts: if str(g.k) == k: return g.id
	return null
func _prep(t, m) -> void:
	var S = J.G.S; var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	for k in ["xiaozhi", "toyol", "laojiang", "heiwu", "mengpo"]:
		if not _has_k(k): J.cl(J.G.get("joinGhost"), null, [k])
	await _skip(t, 8)
	S["team"] = [_id_of("afu"), _id_of("xiaozhi"), _id_of("toyol")]
	S["adviser"] = null
	S.erase("ab_auto")
	S["lv"] = maxf(4.0, J.num(S.lv))
	S.res["troops"] = 100.0
	S.res["buns"] = 5000.0; S.res["coins"] = 100000.0
	J.G.get("Battle")["auto"] = false
	await _f(t, 3)

func logic(t) -> void: await _run(t)
func shots_(t) -> void: shots = true; await _run(t)
func _run(t) -> void:
	var m = await _boot(t)
	await _prep(t, m)
	SO.force_open = true
	data_check()
	await icons_check(t, m)
	calc_check()
	hud_check()
	await sortie_card(t, m)
	await stage_card_and_fight(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---- stub 介面 ----
func data_check() -> void:
	_chk("AB.on() 開（冇 abil.json 用後備表）", AB.on())
	_chk("AB.mechs_of：Pontianak 識飛", AC.enemy_mechs(["pontianak"]).has("fly"), AC.enemy_mechs(["pontianak"]))
	var allc = true
	for m in AI.INFO.keys():
		if m.begins_with("st_") or m in AI.TAGS: continue
		if AC.counters(m).is_empty(): allc = false; _p("  冇應對：" + m)
	_chk("13 個機制全部有應對標籤", allc)
	_chk("AB.tags_of：小紙＝遠（ranged）", AC.tags("xiaozhi").has("ranged"), AC.tags("xiaozhi"))
	_chk("別名：中文「飛」→ fly、「照」→ reveal", AI.canon("飛") == "fly" and AI.canon("照") == "reveal")
	AB.OFF = true
	_chk("ab_off：一鍵關（全域，唔入存檔）", not AB.on())
	AB.OFF = false

# ---- 圖示全部畫得出、唔出格 ----
func icons_check(t, m) -> void:
	var host = Control.new(); host.position = Vector2(4, 300); m.add_child(host)
	var keys = AI.INFO.keys()
	var x = 0.0; var y = 0.0
	for k in keys:
		var ic = AI.Icon.new(k, 44.0); ic.position = Vector2(x, y); host.add_child(ic)
		x += 46.0
		if x > 400: x = 0; y += 46.0
	await _f(t, 3)
	_chk("圖示：%d 個（機制 13＋標籤 10＋狀態 6）全部可畫" % keys.size(), keys.size() >= 29, keys.size())
	await _shot(t, "00_icons")
	host.queue_free()

# ---- 應對、推薦、換上、軍師 ----
func calc_check() -> void:
	var S = J.G.S
	var ks = ["pontianak", "huang", "laojiang"]
	var ms = AC.enemy_mechs(ks)
	_chk("敵人機制合併唔重複", ms.size() == 6 and ms.has("fly") and ms.has("summon"), ms)
	var cv = AC.cover(AC.team_now(), null, ms)
	_chk("✔ 飛行：小紙（遠）", (cv.fly as Array).size() >= 1 and str(cv.fly[0].g.k) == "xiaozhi", cv.fly)
	var has_st = false   # 數據會改（abcore 正式表）：以隊員實際標籤判斷 ✔／✘ 啱唔啱
	for g in AC.team_now():
		for tg in AC.tags(J.str(g.k)): if tg in AC.counters("fear_aura"): has_st = true
	_chk("嚇氣光環：✔／✘ 同隊員標籤一致（隊有「定」＝%s）" % has_st, (cv.fear_aura as Array).is_empty() != has_st, cv.fear_aura)
	var rc = AC.recommend(ms)
	var rk = []
	for r in rc: rk.append(str(r.g.k))
	_chk("推薦最多 2 隻、唔推出陣中／阿福", rc.size() >= 1 and rc.size() <= 2 and not "afu" in rk and not "xiaozhi" in rk, rk)
	_chk("推薦覆蓋最多未應對機制者行先（黑無常：定＋收）", rk.size() and rk[0] == "heiwu", rk)
	var t0 = (S.team as Array).duplicate()
	var sl = AC.swap_in(_id_of("heiwu"), ms)
	_chk("換上：唔換阿福、黑無常入隊", sl > 0 and S.team[0] == _id_of("afu") and (S.team as Array).has(_id_of("heiwu")), [t0, S.team])
	var cv2 = AC.cover(AC.team_now(), null, ms)
	_chk("換上後：光環、屍變都 ✔", (cv2.fear_aura as Array).size() > 0 and (cv2.revive as Array).size() > 0)
	S["team"] = [_id_of("afu"), _id_of("xiaozhi"), _id_of("toyol")]
	AC.set_adviser(_id_of("laojiang"))
	_chk("揀軍師：S.adviser 設好", J.str(S.adviser) == J.str(_id_of("laojiang")))
	AC.set_adviser(_id_of("xiaozhi"))
	_chk("出陣中嘅唔可以做軍師", J.str(S.adviser) == J.str(_id_of("laojiang")))
	S["team"] = [_id_of("afu"), _id_of("xiaozhi"), _id_of("toyol")]
	var cv3 = AC.cover(AC.team_now(), AC.ghost(S.adviser), ms)
	var adv_ok = false
	for w in cv3.fear_aura: if J.t(w.get("adv")): adv_ok = true
	_chk("軍師帶全隊型標籤（老殭「定」→ 光環 ✔・軍師）", adv_ok, cv3.fear_aura)
	S["adviser"] = null

# ---- 頭頂狀態讀法 ----
func hud_check() -> void:
	var op = {"t": 5.0}
	var o2 = RTS.SIM.new(); o2.t = 5.0
	var u = {"side": 1.0, "k": "youhun", "hp": 10.0, "maxhp": 100.0, "shield": 30.0, "shell": 10.0, "shell_max": 40.0}
	var s = AH.status(o2, u)
	_chk("盾、殼（剩 25%）", s.shield > 0 and absf(s.shell - 0.25) < 0.01, s)
	u["hid"] = true
	_chk("隱身：敵人 35% 透明", absf(AH.alpha_of(o2, u) - 0.35) < 0.01)
	u["fly"] = true
	_chk("飛行：抬高 30px", AH.lift_of(o2, u) == 30.0)
	u["grounded_until"] = 9.0
	_chk("擊落：唔再抬高、顯示「落」", AH.lift_of(o2, u) == 0.0 and AH.status(o2, u).ground)
	u["fearT"] = {"t": "light", "until": 8.0}; u["chant"] = {"t": 1.0, "dur": 2.0, "name": "年終考核"}
	var s2 = AH.status(o2, u)
	_chk("失神、讀條 50%", s2.daze and s2.chant != null and absf(float(s2.chant.f) - 0.5) < 0.01)
	_chk("Pontianak（後備機制有飛）冇 fly 欄都會飛", AH.lift_of(o2, {"side": 1.0, "k": "pontianak", "hp": 1.0}) == 30.0)
	# 自動／手動
	var h = {"gid": "g_test", "k": "afu"}
	_chk("冇設定＝跟總掣", AH.auto_of(h, true) and not AH.auto_of(h, false))
	AH.toggle(h, true)
	_chk("長按切換：總掣開，呢隻改手動", not AH.auto_of(h, true) and J.G.S.ab_auto.get("g_test") == false)
	J.G.S.ab_auto.erase("g_test")

# ---- 野外據點出擊卡 ----
func _all_in(root: Control, box: Rect2) -> Array:
	var badl = []
	var st = [root]
	while st.size():
		var c = st.pop_back()
		for x in c.get_children():
			if x is Control and x.visible:
				var r = (x as Control).get_global_rect()
				var clip = box
				var a = x.get_parent()
				while a != null and a != root:   # 喺可捲區入面：以可捲區為界（捲出去嘅本來就睇唔到）
					if a is ScrollContainer: clip = (a as Control).get_global_rect(); break
					a = a.get_parent()
				var chk = r if clip == box else Rect2(r.position.x, box.position.y, r.size.x, 1.0)   # 可捲區入面：只查左右
				if r.size.x > 0 and not box.grow(1.0).encloses(chk): badl.append([x.name, r])
				st.append(x)
	return badl
func _fonts_ok(root: Node) -> Array:
	var small = []
	var st = [root]
	while st.size():
		var c = st.pop_back()
		for x in c.get_children():
			if x is Label:
				var fs = (x as Label).get_theme_font_size("font_size")
				if fs < 13: small.append([x.text, fs])
			st.append(x)
	return small
func sortie_card(t, m) -> void:
	var e = null
	for c in range(0, 6):   # 揀一個有機制嘅據點（Pontianak／小鬼……）
		for x in SO.camps(c):
			var en = SO.stage_of(x).en
			if AC.enemy_mechs(en).size() >= 2: e = x; break
		if e != null: break
	if e == null: e = SO.camps()[0]
	_p("camp %s en=%s mechs=%s" % [SO.key(e), str(SO.stage_of(e).en), str(AC.enemy_mechs(SO.stage_of(e).en))])
	SOV.open_card(e); await _f(t, 8)
	var card = SOV.card
	var box = card.find_child("AbCard", true, false) if card != null else null
	_chk("野外出擊卡：有偵察段", box != null)
	if box == null: return
	var vp = Rect2(Vector2.ZERO, t.get_viewport().get_visible_rect().size)
	var cr = card.get_global_rect()
	_chk("出擊卡完全喺畫面內（唔出界）", vp.encloses(cr), [cr, vp])
	var bl = _all_in(card, cr)
	_chk("卡內所有元件（圖示、頭像、掣）唔超出卡", bl.is_empty(), bl.slice(0, 4))
	_chk("字最細 13", _fonts_ok(card).is_empty(), _fonts_ok(card).slice(0, 4))
	var icons = box.find_children("*", "Control", true, false).filter(func(x): return x.get_script() == null and x.has_method("_draw") and x.get("key") != null)
	await _shot(t, "01_sortie_card")
	# 撳機制圖示 → 說明
	var first = null
	for x in box.find_children("*", "VBoxContainer", true, false):
		if x.mouse_filter == Control.MOUSE_FILTER_STOP: first = x; break
	if first != null:
		var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true
		first.gui_input.emit(ev); await _f(t, 3)
		_chk("撳機制圖示：出說明", str(box.get_meta("open_m", "")) != "")
		await _shot(t, "02_sortie_card_desc")
	# 揀軍師
	box.set_meta("pick_adv", true); AC.render(box); await _f(t, 8)
	cr = SOV.card.get_global_rect()
	_chk("揀軍師清單打開：卡仍然喺畫面內", vp.encloses(cr), cr)
	await _shot(t, "03_sortie_pick_adviser")
	AC.set_adviser(_id_of("laojiang")); SOV.open_card(e); await _f(t, 4)
	await _shot(t, "04_sortie_with_adviser")
	J.G.S["adviser"] = null
	# 推薦＋換上（用有屍變、光環嘅敵人）
	SOV.close_card()

# ---- 主線出擊卡＋地圖戰鬥頭頂狀態 ----
func stage_card_and_fight(t, m) -> void:
	var S = J.G.S
	S["team"] = [_id_of("afu"), _id_of("xiaozhi"), _id_of("toyol")]
	S.cleared.erase("1-1")
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-1": S["qi"] = float(i)
	await _f(t, 3)
	var tg = ZD.stage_target()
	# 偵察卡：用 Pontianak＋黃總＋老殭（機制多）示範推薦＋換上
	var pend = {"kind": "stage", "id": "demo", "ny": 2, "nm": 0, "cb": func(): pass, "opt": {}, "tg": {"en": ["pontianak", "huang", "laojiang"]}, "name": "示範"}
	m.open_sheet(RTS.L("出擊：%s", "出擊：%s") % "示範", func(): pass)
	RTS._card_body(m, pend); await _f(t, 4)
	var box = m.sheet_body.find_child("AbCard", true, false)
	_chk("主線出擊卡：有偵察段", box != null)
	await _w(t, 0.3); await _shot(t, "05_stage_card_recommend")
	var btn = null
	if box != null:
		for b in box.find_children("*", "Button", true, false): if b.text == RTS.L("換上", "換上"): btn = b; break
	_chk("推薦行有「換上」掣", btn != null)
	if btn != null:
		btn.pressed.emit(); await _f(t, 4)
		_chk("撳換上：黑無常入隊、卡即刻更新", (S.team as Array).has(_id_of("heiwu")) and m.sheet_body.find_child("AbCard", true, false) != null, S.team)
		await _w(t, 0.3); await _shot(t, "06_stage_card_after_swap")
	m.close_sheet()
	S["team"] = [_id_of("afu"), _id_of("xiaozhi"), _id_of("toyol")]
	# 真正出擊 1-1
	if not tg.has("pos"): _chk("1-1 迎戰位", false); return
	var r = ZD.start_stage(); await _f(t, 2)
	_chk("真正出擊卡（1-1）有偵察段", m.sheet_body.find_child("AbCard", true, false) != null, r)
	RTS.card_go(); await _f(t, 2)
	var op = RTS.op_for(str(tg.sid))
	if op == null: _chk("出擊 op", false); return
	op.t_skip_march()
	var n = 0
	while op.phase == "march" and n < 300: await _w(t, 0.1); n += 1
	_chk("接觸開打", op.phase == "fight", op.phase)
	for u in op.units:
		if J.num(u.side) == 1: u["hp"] = 1e6; u["maxhp"] = 1e6; u["atk"] = 1.0
	var foes = op.units.filter(func(u): return J.num(u.side) == 1)
	var heroes = op.units.filter(func(u): return J.num(u.side) == 0 and not J.t(u.get("minion")))
	_cam(m, op.anchor + Vector2(0, 60), m.village.size.x / 300.0)
	await _w(t, 2.0)
	# 注入狀態
	if foes.size() >= 1: foes[0]["shell"] = 300.0; foes[0]["shell_max"] = 1000.0; foes[0]["chant"] = {"t": 18.0, "dur": 30.0, "name": "年終考核"}
	if foes.size() >= 2: foes[1]["hid"] = true
	if foes.size() >= 3: foes[2]["fly"] = true
	for f in foes: f["fearT"] = {"t": "light", "until": op.t + 60.0}
	if heroes.size(): heroes[0]["shield"] = 200.0
	await _w(t, 1.2)
	var vis_ok = true; var lift_ok = false; var alpha_ok = false
	for k in RV.inst.vis:
		var v = RV.inst.vis[k]
		if v.u == (foes[2] if foes.size() >= 3 else null) and v.lift > 25.0: lift_ok = true
		if v.u == (foes[1] if foes.size() >= 2 else null) and v.modulate.a < 0.5: alpha_ok = true
	_chk("飛行單位畫高 ~30px（有影）", lift_ok or foes.size() < 3)
	_chk("隱身單位半透明", alpha_ok or foes.size() < 2)
	# ab 事件飄字
	var n0 = AH.FL.size()
	op.events.append(["ab", heroes[0] if heroes.size() else null, "reveal", foes[1] if foes.size() >= 2 else foes[0]])
	op.events.append(["ab", heroes[0] if heroes.size() else null, "shell_break", foes[0]])
	op.events.append(["ab", null, "屍變", foes[0]])
	op.events.append(["ab", null, "not_a_prim_xyz", foes[0]])
	await _f(t, 3)
	var txts = []
	for x in AH.FL: txts.append(x.text)
	_chk("ab 事件飄字：現形！殼破！屍變！（唔識嘅唔飄）", txts.has(RTS.L("現形！", "現形！")) and txts.has(RTS.L("殼破！", "殼破！")) and txts.has(RTS.L("屍變！", "屍變！")) and not str(txts).contains("not_a_prim"), [n0, txts])
	# 節流：光環每格刷新「免疫」→ 同一隻 3 秒（光環型 12 秒）內只飄一次
	var vv = foes[0]; var fl0 = AH.FL.size(); var dr0 = AH.STAT_DROP
	for i in 20: AH.on_event(op, ["ab", null, "immune", vv])
	var nim = 0
	for x in AH.FL: if x.u == vv and x.base == RTS.L("免疫", "免疫"): nim += 1
	_chk("節流：同一隻連發 20 次「免疫」只飄 1 個、唔會變「免疫×20」", nim == 1 and AH.STAT_DROP - dr0 == 19, [nim, AH.STAT_DROP - dr0])
	await _w(t, 0.15); await _shot(t, "07_fight_status_icons")
	await dense(t, m, op, foes, heroes)
	# 長按技能鈕切自動／手動，而且真係影響模擬
	var h = null
	for u in heroes: if J.num(u.hp) > 0 and J.t(u.get("out")): h = u; break
	if h == null: _chk("有名鬼", false); return
	h["energy"] = 40.0
	await _f(t, 3)
	var b = RV.inst.btns.get(J.str(h.get("gid", h.k)))
	_chk("技能鈕存在", b != null)
	if b == null: return
	var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true; ev.position = Vector2(10, 10)
	b._gui_input(ev)
	await _w(t, 0.35); await _shot(t, "08_skill_hold")
	await _w(t, 0.45)
	_chk("長按 0.6 秒：呢隻改做自動（總掣關）", AH.auto_of(h, false), S.get("ab_auto"))
	var ev2 = InputEventMouseButton.new(); ev2.button_index = MOUSE_BUTTON_LEFT; ev2.pressed = false
	b._gui_input(ev2)
	await _w(t, 0.2); await _shot(t, "09_skill_auto_toast")
	J.G.get("Battle")["auto"] = false
	h["energy"] = 100.0; h["anim"] = null; h["casting"] = null; h.st["air"] = 0.0; h.st["down"] = 0.0
	var cast = false
	for i in 20:
		await _f(t, 1)
		if h.get("casting") != null or J.num(h.energy) < 100: cast = true; break
	_chk("模擬：總掣關，但呢隻自動 → 滿嚇氣自己放", cast)
	# 另一隻手動、總掣開 → 唔自己放
	var h2 = null
	for u in heroes: if u != h and J.num(u.hp) > 0 and J.t(u.get("out")): h2 = u; break
	if h2 != null:
		if not (S.get("ab_auto") is Dictionary): S["ab_auto"] = {}
		S.ab_auto[AH.gid_of(h2)] = false
		J.G.get("Battle")["auto"] = true
		h2["energy"] = 100.0; h2["anim"] = null; h2["casting"] = null; h2.st["air"] = 0.0; h2.st["down"] = 0.0
		await _f(t, 10)
		_chk("模擬：總掣開，但呢隻手動 → 唔自己放", h2.get("casting") == null and J.num(h2.energy) >= 100, [h2.get("casting"), h2.energy])
		await _w(t, 0.2); await _shot(t, "10_skill_badges")
		J.G.get("Battle")["auto"] = false
	S.erase("ab_auto")
	RTS.recall(op)

# ---- 密集場面：3／5／8 隻敵人擠埋一齊，頭頂字、飄字、建築字完全唔重疊 ----
func _overlap_check(tag: String) -> void:
	var pl: Array = AL.placed
	var bad_pairs = []
	for i in pl.size():
		for j in range(i + 1, pl.size()):
			if (pl[i] as Rect2).intersects(pl[j]): bad_pairs.append([i, j])
		for o in AL.obs:
			if (pl[i] as Rect2).intersects(o): bad_pairs.append([i, "obs"])
	var ext_bad = []   # 村子字（派鬼守夜等）同血條：撞到就要讓路（唔畫）
	for id in AL.ext:
		for r in AL.ext[id][1]:
			for b in AL.bars: if (r as Rect2).intersects(b): ext_bad.append([r, b])
	_chk("%s：村子字唔撞血條（撞到嗰格讓路）" % tag, ext_bad.is_empty(), ext_bad.slice(0, 3))
	var nb = 0; var nf = 0
	var hid = []
	for b in AL.blocks:
		if b.show: nb += 1
		else: hid.append([str(b.u.get("k")), b.S, b.w, b.h])
	if hid.size(): _p("  %s 收埋嘅塊：%s" % [tag, str(hid)])
	for x in AL.fls: if x.get("show", false): nf += 1
	_chk("%s：頭頂資訊塊、飄字兩兩唔重疊，亦唔蓋血條／木牌／村子字（塊 %d、飄字 %d、障礙 %d、村子字 %d）" % [tag, nb, nf, AL.obs.size(), AL.ext.size()], bad_pairs.is_empty(), bad_pairs.slice(0, 5))
	var ne = 0; var nes = 0
	for b in AL.blocks:
		if b.u is Dictionary and J.num(b.u.get("side", 0)) != 0:
			ne += 1
			if b.show: nes += 1
	_chk("%s：敵人頭頂資訊全部照顯示（唔係靠收埋；擠到冇位只收遊魂兵牌）" % tag, nes == ne, [nes, ne, nb, AL.blocks.size()])
func dense(t, m, op, foes: Array, heroes: Array) -> void:
	var base: Dictionary = foes[0]
	var extra = []
	for i in 5:   # 補夠 8 隻敵人
		var d = base.duplicate(); d["st"] = {}; d["anim"] = null; d["tg"] = null; d["casting"] = null; d["_id"] = "dx%d" % i; d.erase("chant"); d.erase("hid"); d.erase("fly")
		op.units.append(d); extra.append(d)
	var all_f = op.units.filter(func(u): return J.num(u.side) == 1 and J.num(u.hp) > 0)
	var c: Vector2 = op.anchor + Vector2(0, -30)
	for n in [3, 5, 8]:
		for i in all_f.size():
			var u = all_f[i]
			if i < n:
				u["hp"] = 1e6; u["spd"] = 0.0
				u["p"] = c + Vector2((i % 4 - 1.5) * 16.0, (i / 4) * 18.0)
				u["fearT"] = {"t": "light", "until": op.t + 60.0}
				u["shell"] = 300.0; u["shell_max"] = 1000.0
				if i % 3 == 0: u["chant"] = {"t": 9.0, "dur": 20.0, "name": "年終考核"}
				if i % 3 == 1: u["fly"] = true
			else:
				u["p"] = c + Vector2(600, 600)
		for i in n:
			var v = all_f[i]
			op.events.append(["ab", null, ["reveal", "shell_break", "revive", "seal", "interrupt", "summon", "execute", "clone_pop"][(i + n) % 8], v])
			op.text(op.head(v) + Vector2(0, -22), "怕燈・失神", "#e8d0ff")
		_cam(m, c + Vector2(0, 40), m.village.size.x / 300.0)
		await _w(t, 0.5)
		_overlap_check("密集 %d 隻" % n)
		await _shot(t, "11_dense_%d" % n)
		await _w(t, 0.6)
		_overlap_check("密集 %d 隻（0.6 秒後）" % n)
		await _shot(t, "11_dense_%d_b" % n)
	for d in extra: op.units.erase(d)
