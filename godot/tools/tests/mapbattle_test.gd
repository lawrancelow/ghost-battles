# [mapbattle] 大地圖即時戰鬥測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> mb res://tools/tests/mapbattle_test.gd logic|all|smoke
#   logic：唔切畫面、行軍、嚇法卡、失神、連嚇、自動、加速、撤退、鏡頭跟／返戰場、勝負結算同舊 Battle 一致、主 Boss 通關觸發主線、
#          輸咗王留喺門外叫囂（lose／idle／rematch／defeat）、再挑戰、攻佔、告急、第 2–4 關、第 5 關照舊、效能（20 單位）
#   all：logic ＋ 截圖／連續幀（/tmp/mapbattle/shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/mapbattle/shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const TA = preload("res://game/zone/zone_taunt.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
var MB = load("res://game/zone/zone_battle.gd")
var shots := false

func _p(m): print("[mb] ", m)
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
func B(): return J.G.get("Battle")
func _ok_btn(t) -> void:
	var dl = J.G.get("$")
	var okb = J.cl(dl, null, ["#b-ok"]) if dl != null else null
	if okb != null and okb.get("onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])
	await _w(t, 0.3)
func _team3(S) -> void:
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
func _heroes() -> Array:
	var o = []
	for u in B().units: if J.num(u.side) == 0 and not J.t(u.get("minion")): o.append(u)
	return o
func _foes() -> Array:
	var o = []
	for u in B().units: if J.num(u.side) == 1: o.append(u)
	return o
func _has_log(ev: String) -> bool:
	for e in MB.LOG: if e[0] == ev: return true
	return false
func _ta_has(key: String, which: String) -> bool:
	for e in TA.LOG: if e[0] == key and e[1] == which: return true
	return false
func _until(t, cond: Callable, secs: float) -> bool:
	var n = int(secs / 0.1)
	for i in n:
		if cond.call(): return true
		await _w(t, 0.1)
	return cond.call()

func smoke(t) -> void:
	shots = true
	var m = await _boot(t)
	var S = J.G.S
	_team3(S); S.res["troops"] = maxf(200.0, J.num(S.res.get("troops", 0)))
	ZD.unmark_bosses(0)
	var r = ZD.start_battle("boss", "w_graves")
	_p("start " + r)
	for i in 8: await _w(t, 0.5); await _shot(t, "smoke_%02d" % i)
	MB.t_skip_march(); await _w(t, 2.0); await _shot(t, "smoke_fight")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func logic(t) -> void: await _run(t)
func all(t) -> void: shots = true; await _run(t)

func _run(t) -> void:
	var m = await _boot(t)
	var S = J.G.S; var nv = m.village
	_team3(S); S.res["troops"] = maxf(200.0, J.num(S.res.get("troops", 0)))
	var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	_chk("第 1 關分區地圖開住", ZD.on() and MB.usable())
	await boss_flow(t, m)
	await same_as_old(t, m)
	await main_boss(t, m)
	await cap_flow(t, m)
	await raid_flow(t, m)
	await perf(t, m)
	for c in [1, 2, 3, 4, 5]: await map_flow(t, m, c)   # [zone56] 第 5、6 關都分區咗，冇舊豎條圖剩低
	await stage_flow(t, m)   # [outgate] 主線關卡喺大排檔前面打
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 王戰（第 1 關亂葬崗 ①紙人偶頭目） =================
func boss_flow(t, m) -> void:
	var S = J.G.S; var nv = m.vil if false else m.village; var c = nv.zone_cam()
	ZD.unmark_bosses(0); S.zone["taunt"] = {}; TA.LOG.clear(); MB.LOG.clear()
	B()["auto"] = false; B()["speed"] = 1.0
	var bid = str(ZD.bosses("w_graves")[0].id); var key = TA.boss_key(0, bid)
	S.res["troops"] = 200.0
	var r = ZD.start_battle("boss", "w_graves")
	await _f(t, 2)
	var mb = MB.cur
	_chk("撳挑戰：開打（Battle active）", r == "ok" and J.t(B().get("active")) and MB.busy() and mb.kind == "boss", r)
	_chk("唔切畫面：冇舊戰鬥畫面 BtRun、村子照顯示", BtRun.cur == null and m.get_node_or_null("BtRun") == null and nv.visible and nv.is_visible_in_tree())
	_chk("戰場喺野外區入面", ZD.zrect("w_graves").grow(2).encloses(mb.field), mb.field)
	_chk("卡片列：每隻出陣鬼一張卡", mb.card_list.filter(func(x): return x.kind == "hero").size() == _heroes().size() and _heroes().size() >= 1, mb.card_list.size())
	var h0 = _heroes()[0]; var p0 = mb.upos(h0)
	var vill = ZD.zrect("village").grow(40).has_point(mb.path[0]) or ZD.zrect("market").has_point(mb.path[0])
	_chk("行軍路線：由村出發、經野外門入野外區", mb.path.size() >= 4 and vill and ZD.zrect("w_graves").grow(4).has_point(mb.path[mb.path.size() - 1]), mb.path)
	await _shot(t, "mb01_depart")
	await _w(t, 1.0)
	var p1 = mb.upos(h0)
	_chk("行軍中：隊伍喺地圖上行緊、模擬未開始（B.t＝0）", p1.distance_to(p0) > 30.0 and J.num(B().t) == 0.0 and mb.phase == "march", [p0, p1])
	_chk("鏡頭跟住隊伍", c.rect().has_point(p1), [c.rect(), p1])
	await _shot(t, "mb02_march")
	var ok_march = await _until(t, func(): return mb.phase == "fight", 20.0)
	_chk("行到戰場：自動開打", ok_march and _has_log("fight"))
	var hb = mb.upos(_heroes()[0])
	_chk("到位：隊伍喺戰場起始位", mb.field.grow(10).has_point(hb), hb)
	await _w(t, 1.2)
	_chk("開打：模擬行緊（B.t > 0）、Village 照更新", J.num(B().t) > 0.5, B().t)
	await _shot(t, "mb03_fight")
	# 嚇法卡：滿嚇氣 → 撳卡放
	var h = _heroes()[0]; h["energy"] = 100.0
	await _f(t, 2)
	var card = null
	for cc in mb.card_list: if is_same(cc.u, h): card = cc
	_chk("嚇氣滿：卡出「放！」", card != null and card.seal.visible)
	var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true; ev.position = Vector2(5, 5)
	card.box.gui_input.emit(ev)
	_chk("撳卡：放嚇法（開始蓄力、嚇氣清零）", h.get("casting") != null and J.num(h.energy) == 0.0)
	await _w(t, 0.25); await _shot(t, "mb04_cast")
	await _w(t, 0.5)
	# 失神＋連嚇：用 rework 嘅 hit（同舊戰鬥一樣）
	var foe = null
	for f in _foes(): if J.num(f.hp) > 0: foe = f; break
	var RW = J.G.get("Rework")
	var fear = J.mc(RW, "fearOf", [foe.k])
	var SG = J.G.get("SCARE_GHOSTS")
	var k1 = ""; var k2 = ""
	for k in SG:
		var ts = J.mc(RW, "typesOf", [k])
		if not (ts is Array) or ts.is_empty(): continue
		if k1 == "" and str(ts[0]) == str(fear.w[0]): k1 = k
		if k2 == "" and str(ts[0]) == str(fear.w[1]): k2 = k
	var mk = func(k): return {"side": 0.0, "k": k, "atk": 5.0, "x": J.num(foe.x) - 40, "lane": J.num(foe.lane), "hp": 100.0, "maxhp": 100.0, "energy": 0.0, "st": {}}
	var sk = {"name": "測試", "kind": "hit", "mult": 1.0}
	foe["hp"] = maxf(J.num(foe.hp), 5000.0); foe["maxhp"] = maxf(J.num(foe.maxhp), 5000.0)
	J.mc(B(), "hit", [mk.call(k1), foe, 1.0, sk])
	_chk("用敵人怕嘅嚇法 → 失神（fearT）", k1 != "" and foe.get("fearT") is Dictionary and J.num(foe.fearT.until) > J.num(B().t), [k1, fear])
	await _f(t, 3)
	_chk("提示列：失神 → 叫你接另一種＝連嚇", mb.hint_l.text.contains("連嚇") and (mb.hint_l.text.contains("失神")), mb.hint_l.text)
	await _shot(t, "mb05_shishen")
	var c0 = J.num(B().get("combo", 0))
	J.mc(B(), "hit", [mk.call(k2), foe, 1.0, sk])
	var fxs = []
	for f in B().fx: fxs.append(J.str(f.get("text", "")))
	_chk("失神再接另一種佢怕嘅 → 連嚇（combo 加、地圖出「連嚇」字）", k2 != "" and J.num(B().combo) > c0 and " ".join(fxs).contains("連嚇"), fxs)
	await _w(t, 0.15); await _shot(t, "mb06_lianxia")
	# 自動
	mb.auto_b.pressed.emit()
	_chk("自動掣：ON", J.t(B().auto) and mb.auto_b.text.contains("ON"))
	var h2 = _heroes()[min(1, _heroes().size() - 1)]
	if J.num(h2.hp) <= 0: h2["hp"] = 100.0
	h2["energy"] = 100.0; h2["anim"] = null; h2.st.clear()
	await _w(t, 0.3)
	_chk("自動：嚇氣滿自己放", h2.get("casting") != null or J.num(h2.energy) < 100.0, h2.energy)
	mb.auto_b.pressed.emit()
	mb.speed_b.pressed.emit()
	_chk("加速掣：×2", J.num(B().speed) == 2.0 and mb.speed_b.text == "×2")
	mb.speed_b.pressed.emit()
	# 鏡頭：拖走就停跟，返戰場掣
	c.dragging = true; await _f(t, 2); c.dragging = false
	c.center_on(Vector2(670, 1600)); await _f(t, 3)
	_chk("拖走鏡頭：停跟、出「返戰場」掣", not mb.follow and mb.back_b.visible)
	await _shot(t, "mb07_dragged")
	mb.back_b.pressed.emit()
	await _w(t, 1.0)
	_chk("撳返戰場：鏡頭返戰場", mb.follow and c.rect().has_point(mb.field_center()))
	# 撤退 → 王留喺門外叫囂
	mb._on_quit(); mb._on_quit()
	await _f(t, 3)
	_chk("撤退（兩下確認）：結算＝撤退", B().get("result") is Dictionary and not J.t(B().result.win) and mb.phase == "result")
	_chk("輸咗：王記低喺門外叫囂、即講 lose", TA.on(key) and _ta_has(key, "lose"), TA.LOG)
	_chk("結算框（原有 #b-result）喺地圖上面", m.get_node_or_null("MapBattleResult") != null)
	await _w(t, 0.4); await _shot(t, "mb08_lose_result")
	await _ok_btn(t)
	await _f(t, 3)
	_chk("回村子：隊伍行返村、王行去門外", mb.phase == "back" and not J.t(B().active))
	await _w(t, 1.5); await _shot(t, "mb09_walk_back")
	await _until(t, func(): return not MB.busy(), 25.0)
	ZD.poll()
	_chk("行返晒：收場（節點清走、Battle.update 還原）", not MB.busy() and nv.world.get_node_or_null("MapBattleWorld") == null)
	_chk("王未打低（留低）", not ZD.boss_done("w_graves", 0) and ZD.boss_next("w_graves") == 0)
	var sp = TA.spot(key)
	var g = TA.gate_of("w_graves")
	_chk("叫囂位：野外門外面（野外區那邊、近門）", ZD.rect(ZD.zone("w_graves").rect).grow(4).has_point(sp) and sp.distance_to(g[0]) < 90.0, [sp, g])
	# idle：15–30 秒一句
	var nx = float(TA._next.get(key, 0))
	_chk("idle 計時 15–30 秒", nx >= 0.0 and nx <= TA.IDLE_MAX, nx)
	c.center_on(sp + Vector2(0, 40)); await _w(t, 0.5)
	TA._next[key] = 0.05
	await _w(t, 0.5)
	_chk("idle：王喺畫面 → 叫囂一句", _ta_has(key, "idle"))
	var lines = []
	for i in 12: lines.append(TA.pick(key, "idle"))
	TA._order.clear(); lines.clear()
	for i in 12: lines.append(TA.pick(key, "idle"))
	var uniq = {}
	for l in lines.slice(0, TA.lines(key, "idle").size()): uniq[l] = true
	_chk("idle 輪住講（一輪內唔重複）", uniq.size() == TA.lines(key, "idle").size(), uniq.size())
	var vr = Rect2(Vector2.ZERO, nv.size)
	var bok = true
	for b in TA.bubbles:
		var rr = TA.bubble_rect(b, float(nv.sc), nv.view_rect())
		if not vr.encloses(rr): bok = false
	_chk("對白泡泡喺畫面內", TA.bubbles.size() > 0 and bok)
	var esc = m.mv_embed.sc
	_chk("對白泡泡喺世界層（大排檔 HUD 下面，唔遮 UI）", nv.zone_over.get_parent() == nv.world and esc.get_parent() == nv and esc.get_index() > nv.world.get_index(), [esc.get_parent(), esc.get_index(), nv.world.get_index()])
	await _w(t, 0.2); await _shot(t, "mb10_taunt_idle")
	# 撳門外嘅王 → 再挑戰卡
	var hit = TA.hit(sp + Vector2(0, -40))
	_chk("撳叫囂緊嘅王：認到（開挑戰卡）", hit.size() and hit[0] == "w_graves", hit)
	# 再挑戰：rematch；王由門外行返戰場
	TA.LOG.clear()
	ZD.start_battle("boss", "w_graves"); await _f(t, 2)
	mb = MB.cur
	var bu = mb._boss_unit()
	_chk("再挑戰：王講 rematch、由門外行返戰場", _ta_has(key, "rematch") and mb.upos(bu).distance_to(sp) < 60.0, mb.upos(bu))
	await _w(t, 0.3); await _shot(t, "mb11_rematch")
	MB.t_skip_march(); await _f(t, 3)
	# 打贏：敵人剩少少血，等佢自己打
	for f in _foes(): f["hp"] = 1.0; f["maxhp"] = maxf(J.num(f.maxhp), 1.0)
	B()["auto"] = true
	var won = await _until(t, func(): return B().get("result") is Dictionary, 20.0)
	B()["auto"] = false
	_chk("打贏（模擬自然打完）", won and J.t(B().result.win))
	await _f(t, 2)
	_chk("打贏：王認輸 defeat、收聲（清走叫囂）", _ta_has(key, "defeat") and not TA.on(key))
	await _w(t, 0.3); await _shot(t, "mb12_win")
	await _ok_btn(t); ZD.poll()
	_chk("打低①王 → 輪到②", ZD.boss_done("w_graves", 0) and ZD.boss_next("w_graves") == 1)
	await _until(t, func(): return not MB.busy(), 25.0)
	await _skip(t, 3)

# ================= 勝負／傷害同舊 Battle 一致 =================
func _snap_units() -> Array:
	var o = []
	for u in B().units: o.append([J.num(u.side), J.str(u.k), snappedf(J.num(u.hp), 0.01), snappedf(J.num(u.atk), 0.01), J.num(u.range), J.num(u.spd), snappedf(J.num(u.x), 0.01), snappedf(J.num(u.lane), 0.01), J.num(u.energy), J.t(u.get("minion")), J.t(u.get("boss"))])
	return o
func _sim(step_fn: Callable, n: int) -> Array:
	seed(9901)
	var B0 = B(); B0["H"] = 400.0; B0["auto"] = true; B0["speed"] = 1.0
	for i in n:
		step_fn.call(1.0 / 30.0)
		B0["H"] = 400.0
		if B0.get("result") != null: break
	var hp = []
	for u in B0.units: hp.append(snappedf(J.num(u.hp), 0.01))
	return [B0.get("result") != null and J.t(B0.result.get("win")), B0.get("result") != null, snappedf(J.num(B0.t), 0.001), hp, int(J.num(B0.get("combo", 0)))]
func same_as_old(t, m) -> void:
	var S = J.G.S
	S.zone.boss["0:zb_paper"] = true; S.zone.boss.erase("0:zb_keeper")
	# 舊畫面
	MB.force_off = true
	await _skip(t, 2)
	S.res["troops"] = 200.0
	seed(4242)
	ZD.start_battle("boss", "w_graves")
	_chk("對照：舊戰鬥畫面（BtRun）", BtRun.cur != null and not MB.busy())
	var a_units = _snap_units()   # 同一幀：未行過任何一格
	var orig = B().update
	var a = _sim(func(dt): J.cl(orig, B(), [dt]), 900)
	J.mc(B(), "finish", [false, true]); await _f(t, 2); await _ok_btn(t); ZD.poll(); await _f(t, 3)
	MB.force_off = false
	# 大地圖
	S.res["troops"] = 200.0
	seed(4242)
	ZD.start_battle("boss", "w_graves")
	var mb = MB.cur
	MB.t_skip_march()   # 行軍跳到尾：每隻返到 Battle 原本嘅起始位
	var b_units = _snap_units()
	_chk("同一關：大地圖開出嚟嘅單位（血、攻、射程、速度、位、嚇氣）同舊 Battle 一模一樣", a_units == b_units and a_units.size() > 3, [a_units.size(), b_units.size()])
	var ou = mb._orig_update
	var b = _sim(func(dt): J.cl(ou, B(), [dt]), 900)
	_chk("同一隨機種子模擬：勝負、時間、每隻血、連嚇數同舊 Battle 一致", a == b, [a.slice(0, 3), b.slice(0, 3)])
	_p("對照：舊 %s／新 %s" % [str(a.slice(0, 3)), str(b.slice(0, 3))])
	# 包住嘅 update：開打後每格 dt 照傳
	var t0 = J.num(B().t)
	if B().get("result") == null:
		J.mc(B(), "update", [0.1])
		_chk("包住嘅 Battle.update：開打後照行（dt × 速度）", absf(J.num(B().t) - t0 - 0.1) < 1e-6 or J.num(B().get("hitStop", 0)) > 0)
	if B().get("result") == null: J.mc(B(), "finish", [false, true])
	await _f(t, 2); await _ok_btn(t); ZD.poll()
	MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
	S.zone["taunt"] = {}
	_chk("收場後 Battle.update 還原", not MB.busy())

# ================= 主 Boss（餓鬼王＝1-3）：勝利＝原關卡通關 =================
func main_boss(t, m) -> void:
	var S = J.G.S
	var had = J.t(S.cleared.get("1-3")); var had_g = false
	for g in S.ghosts: if J.str(g.k) == "eguiking": had_g = true
	S.cleared.erase("1-3"); S.zone.boss["0:zb_egui"] = true; S.zone.boss.erase("0:zb_eguiking")
	if S.seen is Dictionary: S.seen.erase("ch1_end")
	var r = ZD.start_battle("boss", "w_pit"); await _f(t, 2)
	_chk("主 Boss：喺大地圖打（世界地圖 1-3 原關卡）", r == "ok" and MB.busy() and J.str(B().sid) == "1-3" and BtRun.cur == null, B().sid)
	var hasking = false
	for f in _foes(): if J.str(f.k) == "eguiking" and J.t(f.boss): hasking = true
	_chk("主 Boss：陣容＝原關卡（餓鬼王＋嘍囉）", hasking)
	MB.t_skip_march(); await _w(t, 0.5)
	J.mc(B(), "finish", [true]); await _f(t, 3)
	_chk("主 Boss 打贏：S.cleared 1-3", J.t(S.cleared.get("1-3")))
	await _ok_btn(t); ZD.poll()
	var st = m.get("story")
	var q = J.G.get("Story")
	var queued = J.t(J.mc(q, "busy", [])) or (S.seen is Dictionary and J.t(S.seen.get("ch1_end")))
	_chk("主 Boss：主線劇情（ch1_end）照觸發", queued)
	await _skip(t, 8)
	var got = false
	for g in S.ghosts: if J.str(g.k) == "eguiking": got = true
	_chk("主 Boss：收編餓鬼王照觸發", got)
	_chk("主 Boss：分區王紀錄＝已打", ZD.boss_done("w_pit", 1))
	await _until(t, func(): return not MB.busy(), 25.0)
	if not had: pass

# ================= 攻佔資源區 =================
func cap_flow(t, m) -> void:
	var S = J.G.S
	await _skip(t, 4)
	S.zone.own.erase("0:B"); S.zone["taunt"] = {}; TA.LOG.clear(); S.res["troops"] = 200.0
	var r = ZD.start_battle("cap", "B"); await _f(t, 2)
	var mb = MB.cur
	_chk("攻佔：喺大地圖打（入資源區）", r == "ok" and MB.busy() and mb.kind == "cap" and ZD.zrect("B").grow(2).encloses(mb.field), mb.field if mb else null)
	_chk("攻佔：隊伍經門洞入", mb.path.has(ZD.v2(ZD.zone("B").door.in)) and mb.path.has(ZD.v2(ZD.zone("B").door.out)))
	_chk("攻佔緊：黑霧散開（戰場睇到）", ZV._mb().on_zone("B"))
	await _w(t, 2.0); await _shot(t, "mb13_cap_march")
	MB.t_skip_march(); await _w(t, 1.0); await _shot(t, "mb14_cap_fight")
	mb.quit(); await _f(t, 3)
	var key = TA.cap_key(0, "B")
	_chk("攻佔失敗：頭目喺門口叫囂（cap 台詞）", TA.on(key) and _ta_has(key, "lose"))
	await _ok_btn(t); ZD.poll()
	await _until(t, func(): return not MB.busy(), 25.0)
	_chk("攻佔失敗：冇佔領", not ZD.owned("B"))
	ZD.start_battle("cap", "B"); await _f(t, 2); MB.t_skip_march(); await _f(t, 2)
	J.mc(B(), "finish", [true]); await _f(t, 3); await _ok_btn(t); ZD.poll()
	_chk("攻佔打贏：佔領、頭目收聲", ZD.owned("B") and not TA.on(key) and _ta_has(key, "defeat"))
	await _until(t, func(): return not MB.busy(), 25.0)

# ================= 影響力告急：大排檔即時迎戰 =================
func raid_flow(t, m) -> void:
	await _skip(t, 2)
	var sim = m.mv_view.sim; var w = MVW.ws(); J.G.S.res["troops"] = 200.0
	w["alarm"] = {"t": 120.0}
	var r = sim.war.start_expedition(sim); await _f(t, 2)
	var mb = MB.cur
	_chk("告急：喺大地圖即時迎戰（唔切畫面）", r == "ok" and MB.busy() and mb.kind == "raid" and BtRun.cur == null, r)
	_chk("告急：戰場喺大排檔", ZD.zrect("market").grow(2).encloses(mb.field), mb.field)
	await _w(t, 2.0); await _shot(t, "mb15_raid")
	MB.t_skip_march(); await _f(t, 2)
	var a0 = MVW.inf()
	J.mc(B(), "finish", [true]); await _f(t, 3); await _ok_btn(t)
	var res = MVW.poll()
	_chk("告急打贏：解除告急、影響力回升（照舊結算）", not MVW.alarm_on() and MVW.inf() >= a0, [a0, MVW.inf()])
	await _until(t, func(): return not MB.busy(), 25.0)

# ================= 效能：戰場 20 單位 =================
func perf(t, m) -> void:
	var S = J.G.S
	S.zone.own.erase("0:C")
	var z = ZD.zone("C"); var keep = z.stage.duplicate(true)
	z.stage["en"] = ["youhun", "zhiren", "youhun", "egui", "youhun", "zhiren", "youhun", "egui", "youhun", "zhiren", "youhun"]
	S.res["troops"] = 400.0
	await _skip(t, 2)
	var cam = m.village.zone_cam(); cam.center_on(ZD.zrect("C").get_center())
	var base = await _frames(t, 60)
	ZD.start_battle("cap", "C"); await _f(t, 2)
	var n = B().units.size()
	MB.t_skip_march(); await _w(t, 0.5)
	for u in B().units: u["hp"] = J.num(u.hp) * 20; u["maxhp"] = J.num(u.maxhp) * 20
	B()["auto"] = true
	var mb = MB.cur
	var bt = await _frames(t, 90)
	var us = 0; var nn = 0
	_p("效能：%d 單位　冇戰鬥：幀 %.1fms process %.1fms　戰鬥中：幀 %.1fms（p90 %.1f）process %.1fms　戰鬥自己（模擬＋同步＋畫）%.2fms／幀" % [n, base[0], base[2], bt[0], bt[1], bt[2], bt[3]])
	_chk("效能：20 單位同場，戰鬥本身（模擬＋同步＋畫）每幀 ≤ 12ms（xvfb 軟件渲染機）", n >= 20 and bt[3] <= 12.0, [n, bt[3]])
	await _shot(t, "mb16_perf20")
	B()["auto"] = false
	J.mc(B(), "finish", [false, true]); await _f(t, 2); await _ok_btn(t); ZD.poll()
	await _until(t, func(): return not MB.busy(), 25.0)
	# 對照：舊戰鬥畫面同一陣容
	MB.force_off = true; S.res["troops"] = 400.0
	ZD.start_battle("cap", "C"); await _f(t, 2)
	for u in B().units: u["hp"] = J.num(u.hp) * 20; u["maxhp"] = J.num(u.maxhp) * 20
	B()["auto"] = true
	var old = await _frames(t, 90)
	MB.force_off = false
	_p("效能對照：舊戰鬥畫面 %d 單位：幀 %.1fms（p90 %.1f）process %.1fms" % [B().units.size(), old[0], old[1], old[2]])
	_chk("效能：開戰比同一張地圖冇戰鬥多 ≤ 16.7ms／幀（60fps 一格；xvfb 軟件渲染）", bt[0] - base[0] <= 16.7, [bt[0], base[0], old[0]])
	B()["auto"] = false
	J.mc(B(), "finish", [false, true]); await _f(t, 2); await _ok_btn(t); ZD.poll(); await _f(t, 3)
	z["stage"] = keep; S.zone["taunt"] = {}

# ================= 第 2–4 關 =================
func map_flow(t, m, c: int) -> void:
	var S = J.G.S; var sc = m.mv_view
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2)
	var tag = "第 %d 關：" % (c + 1)
	_chk(tag + "分區＋大地圖戰鬥可用", ZD.on() and ZD.applied() == str(c) and MB.usable())
	ZD.unmark_bosses(c); S.zone["taunt"] = {}
	for wz in ZD.of_type("wild"):
		var zid = str(wz.id)
		var r = ZD.start_battle("boss", zid); await _f(t, 2)
		var mb = MB.cur
		var inside = mb != null and ZD.zrect(zid).grow(2).encloses(mb.field)
		var endp = mb.path[mb.path.size() - 1] if mb != null else Vector2.ZERO
		_chk(tag + "%s 王戰：戰場喺野外區、路線入到野外區" % zid, r == "ok" and inside and ZD.zrect(zid).grow(4).has_point(endp), [mb.field if mb else null, endp])
		var walk_ok = true
		for i in mb.path.size() - 1: if mb.path[i].distance_to(mb.path[i + 1]) > 900.0: walk_ok = false
		_chk(tag + "%s 路線冇飛越（每段 < 900）" % zid, walk_ok, mb.path)
		if zid == str(ZD.of_type("wild")[0].id):
			await _w(t, 2.0); await _shot(t, "mb2%d_m%d_march" % [c, c + 1])
		MB.t_skip_march(); await _w(t, 0.6)
		J.mc(B(), "finish", [false, true]); await _f(t, 2); await _ok_btn(t); ZD.poll()
		MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
		var key = TA.boss_key(c, str(ZD.bosses(zid)[0].id))
		var sp = TA.spot(key)
		_chk(tag + "%s 輸咗：王喺門外（野外區邊）叫囂" % zid, TA.on(key) and ZD.zrect(zid).grow(4).has_point(sp), sp)
		if zid == str(ZD.of_type("wild")[0].id):
			m.village.zone_cam().center_on(sp + Vector2(0, 30)); TA._next[key] = 0.05; await _w(t, 0.8); await _shot(t, "mb2%d_m%d_taunt" % [c, c + 1])
	var rz = str(ZD.of_type("res")[0].id)
	S.zone.own.erase("%d:%s" % [c, rz])
	ZD.start_battle("cap", rz); await _f(t, 2)
	var mb2 = MB.cur
	_chk(tag + "攻佔 %s：戰場喺資源區" % rz, mb2 != null and ZD.zrect(rz).grow(2).encloses(mb2.field), mb2.field if mb2 else null)
	MB.t_skip_march(); await _f(t, 2)
	J.mc(B(), "finish", [false, true]); await _f(t, 2); await _ok_btn(t); ZD.poll()
	MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
	S.zone["taunt"] = {}

# ================= [outgate] 主線關卡（x-1、x-2）喺大排檔前面打 =================
func _qidx_stage(sid: String) -> int:
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == sid: return i
	return -1
func stage_flow(t, m) -> void:
	var S = J.G.S; var sc = m.mv_view
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	var qi0 = S.qi; var cl0 = (S.cleared as Dictionary).duplicate()
	S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
	var tg = ZD.stage_target()
	_chk("主線 1-1：迎戰位喺大排檔入面", tg.has("pos") and ZD.zrect("market").has_point(tg.pos), tg)
	var r = ZD.start_stage(); await _f(t, 2)
	var mb = MB.cur
	_chk("主線 1-1：大地圖開打（stage）、戰場喺大排檔", r == "ok" and mb != null and mb.kind == "stage" and ZD.zrect("market").grow(2).encloses(mb.field) and J.t(B().get("active")), [r, mb.field if mb else null])
	_chk("主線 1-1：唔開舊戰鬥畫面", BtRun.cur == null)
	MB.t_skip_march(); await _w(t, 0.6)
	J.mc(B(), "finish", [true]); await _f(t, 2); await _ok_btn(t); ZD.poll()
	MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
	_chk("主線 1-1：贏咗記通關、隊伍行返村", J.t(S.cleared.get("1-1")) and not MB.busy())
	await _f(t, 3)
	_chk("主線 1-1：通關後迎戰位收返", not ZD.stage_target().has("pos") or str(ZD.stage_target().sid) != "1-1", ZD.stage_target())
	S["qi"] = float(_qidx_stage("1-3")); S.cleared.erase("1-3")
	var tg3 = ZD.stage_target()
	_chk("主線 1-3（餓鬼王）：指去野外王，唔喺大排檔前面", tg3.get("zid", "") == "w_pit" and not tg3.has("pos"), tg3)
	S["qi"] = float(_qidx_stage("2-1"))
	_chk("主線 2-1 喺第 1 關：要拔營先打（later）", J.t(ZD.stage_target().get("later")), ZD.stage_target())
	m._nav("battle"); await _w(t, 0.5)
	_chk("「地盤」掣：唔開舊世界地圖", not J.t(J.gp(J.gp(JSRun.by_id("world"), "classList"), "d").has("on") if JSRun.by_id("world") != null else false))
	var bad_at = []
	for c in 6:
		sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 0.8)
		var fa = ZD.front_anchor()
		if not ZD.zrect("market").grow(-40).has_point(fa): bad_at.append([c, fa, ZD.zrect("market")])
	_chk("六關迎戰位都喺大排檔入面（離邊 ≥40）", bad_at.is_empty(), bad_at)
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 0.8)
	S["qi"] = qi0; S["cleared"] = cl0

# ================= 第 5 關（冇分區）照用舊戰鬥畫面 =================
func old_maps(t, m) -> void:
	var sc = m.mv_view
	sc.sim.st().ci = 4.0; sc._after_move(); await _w(t, 1.2)
	_chk("第 5 關：冇分區 → 唔用大地圖戰鬥", not ZD.on() and not MB.usable())
	MVW.ws()["alarm"] = {"t": 120.0}
	var r = sc.sim.war.start_expedition(sc.sim); await _f(t, 3)
	_chk("第 5 關告急出征：照舊戰鬥畫面（BtRun）", r == "ok" and BtRun.cur != null and not MB.busy(), r)
	J.mc(B(), "finish", [true]); await _f(t, 2); await _ok_btn(t); MVW.poll(); await _f(t, 3)
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.0)

# 量幀：[幀中位, 幀 p90, process 中位, 戰鬥自己（MB 模擬＋同步＋畫）每幀 ms]
func _frames(t, n: int) -> Array:
	var ts = []; var proc = []; var last = Time.get_ticks_usec()
	MB.prof_us = 0; MB.prof_n = 0; PtDraw.prof_tag.clear(); MB.PROF.clear()
	for i in n:
		await t.get_tree().process_frame
		var now = Time.get_ticks_usec(); ts.append((now - last) / 1000.0); last = now
		proc.append(Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0)
	ts.sort(); proc.sort()
	var draw = 0.0
	for k in PtDraw.prof_tag: if str(k).begins_with("mb_") or str(k) in ["back", "mv"]: draw += PtDraw.prof_tag[k]
	var own = (MB.prof_us + draw) / 1000.0 / maxf(1, n)
	var parts = []
	for k in MB.PROF: parts.append("%s=%.2f" % [k, MB.PROF[k] / 1000.0 / n])
	for k in PtDraw.prof_tag: if str(k).begins_with("mb_") or str(k) in ["back", "mv"]: parts.append("%s=%.2f" % [k, PtDraw.prof_tag[k] / 1000.0 / n])
	_p("prof " + " ".join(parts))
	return [ts[ts.size() / 2], ts[int(ts.size() * 0.9)], proc[proc.size() / 2], own]
