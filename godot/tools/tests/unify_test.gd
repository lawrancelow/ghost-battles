# [unify] 合一地圖測試：村子分頁＝村外惡鬼區＋柵欄＋大排檔區 → 出村門 → 原版村子（唔變）→ 村尾拓展地
# 用法：/home/claude/setup/edtest.sh <godot目錄> unify res://tools/tests/unify_test.gd all|logic|shots0|fps
#   logic：原村 POS 冇變、鏡頭範圍、預設鏡頭、台數、台唔重疊、唔遮出村門、撳台開卡、撳出村門照舊、客人兩邊入、
#          圍欄孤魂、挑夫鬼、拔營只換上半、舊存檔、移動村全屏／後院掣／營地取消
#   all：logic ＋ 每張圖由頂拖到底分段截圖（/tmp/unify/shots/）＋幀率
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/unify/shots/"
const MD = preload("res://game/outpost/mv_data.gd")
const ORIG_POS := {"gate": [195, 118], "house": [195, 300], "furnace": [338, 258], "wood": [92, 612], "rice": [298, 612], "plank": [95, 752], "bun": [295, 752], "store": [195, 872], "home": [92, 1000], "camp": [300, 1000], "altar": [195, 1092]}
const TARGET := [5, 5, 6, 6, 7, 7]

func _p(m): print("[unify] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
func _V(): return J.G.get("Village")
func _cam(y: float) -> void: J.mc(_V(), "setCam", [y])
func _camY() -> float: return J.num(_V().get("camY"))

func all(t) -> void: await _run(t, true, true)
func logic(t) -> void: await _run(t, false, false)
func shots0(t) -> void: await _run(t, true, false, true)

func _boot(t):
	# [zone] 呢個測試驗舊豎條布局（第 2–6 張圖照用、zones.json 冇定義嘅圖）；第 1 張圖分區地圖由 zone_test.gd 測
	load("res://game/zone/zone_data.gd").force_off = true
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.6)
	return m

# 一張圖由頂拖到底分段截圖
func _shots_map(t, m, c: int, tag := "") -> void:
	var sc = m.mv_view
	var vh = m.village.size.y / (m.village.size.x / 390.0)
	var E = m.mv_embed.eh()
	var y = -E - m.mv_embed.top_extra(); var i = 0
	while y < 1130.0 - vh + 1.0 and i < 12:
		_cam(y); await _w(t, 0.35)
		await _shot(t, "m%d%s_%02d" % [c, tag, i])
		y += vh * 0.8; i += 1
	_cam(1130.0 - vh); await _w(t, 0.35); await _shot(t, "m%d%s_%02d" % [c, tag, i])

func _goto_ci(sc, c: int) -> void:
	sc.sim.st().ci = float(c); sc._after_move()

func _run(t, shots: bool, full: bool, only0 := false) -> void:
	var m = await _boot(t)
	var S = J.G.S; var sc = m.mv_view; var em = m.mv_embed
	_chk("合一：嵌入場景", em != null and sc != null and sc.embed and sc.get_parent() == m.village)
	_chk("移動村全屏畫面收埋", not m.mv_host.visible and not m.mv_back.is_inside_tree() or not m.mv_back.visible)
	_chk("營地取消", sc.camp == null)
	_chk("mv_on 開", J.t(S.get("mv_on")))
	# 預設鏡頭對住原村子
	_chk("預設鏡頭喺原村子", _camY() >= 0.0, _camY())
	if only0:
		S.res.coins = 1e7
		for sid in MD.stations(0): sc.sim.sst(sid).unlocked = true
		await _w(t, 4.0)
		await _shots_map(t, m, 0)
		return
	# ---------- 原村 POS 冇變 ----------
	var POS = J.G.get("POS"); var same = true
	for k in ORIG_POS:
		if int(J.num(POS[k][0])) != ORIG_POS[k][0] or int(J.num(POS[k][1])) != ORIG_POS[k][1]: same = false
	_chk("原村 POS 冇變", same)
	# ---------- 鏡頭範圍 ----------
	_cam(-99999.0); await _w(t, 0.2)
	var E = em.eh()
	var top = -E - em.top_extra()
	_chk("鏡頭可以拖到最頂（-EH，再加 HUD 高度）", absf(_camY() - top) < 0.5, "%.1f / %.1f" % [_camY(), top])
	_cam(99999.0); await _w(t, 0.2)
	var vh = m.village.size.y / (m.village.size.x / 390.0)
	_chk("鏡頭可以拖到村尾", _camY() >= 1130.0 - vh - 0.5, _camY())
	# 拖動（JS pointer）
	_cam(180.0); await _w(t, 0.2)
	var el = m.village.el
	var p0 = Vector2(200, 300)
	el.fire("pointerdown", m.village._ev(p0, {"type": "pointerdown"}))
	el.fire("pointermove", m.village._ev(p0 + Vector2(0, 260), {"type": "pointermove"}))
	JSRun.win_fire("pointerup", m.village._ev(p0 + Vector2(0, 260), {"type": "pointerup"}))
	await _w(t, 0.1)
	_chk("向下拖 → 鏡頭向上（入大排檔區）", _camY() < 180.0 - 200.0, _camY())
	# ---------- 每張圖版面 ----------
	var gp = Vector2(195, 118 + E)   # 出村門（大排檔世界座標）
	var gate_r = Rect2(gp.x - 70, gp.y - 100, 140, 110)
	for c in MD.maps_n():
		var Ly = MD.layout(c)
		var sids = MD.stations(c); var reg = []
		for s in sids: if not MD.is_carry(s): reg.append(s)
		var spare = Ly.get("spare", [])
		var ncarry = load("res://game/outpost/mat.gd").carry().size()   # [militia] 隨村台多咗紙紮兵器檔（3 個）
		_chk("圖%d 台數（固定 %d＋%d 隨村）" % [c + 1, TARGET[c], ncarry], reg.size() + spare.size() == TARGET[c] and sids.size() - reg.size() == ncarry, "已有 %d、留位 %d" % [reg.size(), spare.size()])
		var rs = []
		for s in sids:
			var p = MD.st_xy(c, s); rs.append([s, Rect2(p.x - 56, p.y - 92, 112, 160)])
		for q in spare: rs.append(["留位", Rect2(float(q[0]) - 56, float(q[1]) - 92, 112, 160)])
		var ov = []
		for i in rs.size():
			for j in range(i + 1, rs.size()):
				if rs[i][1].grow(-2).intersects(rs[j][1].grow(-2)): ov.append("%s×%s" % [rs[i][0], rs[j][0]])
		_chk("圖%d 台唔重疊" % (c + 1), ov.is_empty(), ov)
		var cp = MD.v2(Ly.counter); var cr = Rect2(cp.x - 92, cp.y - 70, 184, 84)
		var co = []
		for r in rs: if r[1].grow(-4).intersects(cr): co.append(r[0])
		_chk("圖%d 台唔撞櫃台" % (c + 1), co.is_empty(), co)
		var go = []
		for r in rs: if r[1].intersects(gate_r): go.append(r[0])
		if cr.intersects(gate_r): go.append("櫃台")
		_chk("圖%d 唔遮出村門" % (c + 1), go.is_empty(), go)
		var inb = true
		for r in rs: if r[1].position.x < -2 or r[1].end.x > 392 or r[1].position.y < float(Ly.fence_y) or r[1].end.y > E: inb = false
		_chk("圖%d 台喺柵欄同出村門之間" % (c + 1), inb)
		_chk("圖%d 背景兩塊＋柵欄畫入背景" % (c + 1), MD.map_def(c).get("bg_tiles", []).size() == 3 and J.t(Ly.get("fence_art")))
		var q2 = Ly.get("q2", []); var qp = MD.queue_poly(c)
		_chk("圖%d 客人由左右兩邊入" % (c + 1), q2.size() >= 2 and float(q2[q2.size() - 1][0]) < 0 and qp[qp.size() - 1].x > 390)
	# ---------- 撳台開卡、撳出村門 ----------
	S.res.coins = maxf(J.num(S.res.coins), 1e6)
	var c0 = sc.sim.ci(); var sid0 = MD.stations(c0)[0]
	sc.sim.sst(sid0).unlocked = true
	var sp = sc.sim.st_pos(sid0)
	_cam(sp.y - E - 300.0); await _w(t, 0.4)
	J.mc(_V(), "tap", [sp.x, sp.y - E - 40.0]); await _w(t, 0.3)
	_chk("撳台開資料卡", sc.sheet.visible and sc.sel == sid0, sc.sel)
	sc.close_sheet()
	var opened = [false]
	var cb = func(): opened[0] = true
	var W = J.G.get("World"); var o_open = W.get("open")
	W["open"] = func(_t, _a): opened[0] = true; return null
	_cam(0.0); await _w(t, 0.3)
	J.mc(_V(), "tap", [195.0, 90.0]); await _w(t, 0.3)
	W["open"] = o_open
	var gate_ok = opened[0]
	if not gate_ok:   # 出村門由 village signal／JS 開世界地圖：睇 UI 狀態
		gate_ok = J.t(J.gp(W, "on")) or J.t(J.gp(W, "visible"))
	_chk("撳出村門照舊（開世界地圖）", gate_ok)
	if J.G.get("World") != null and J.t(J.gp(J.G.get("World"), "on")): J.mc(J.G.get("World"), "close", [])
	await _w(t, 0.3)
	# 原村子撳建築照舊
	if not J.t(J.G.S.bld.get("store")): J.G.S.bld["store"] = 1.0   # [ruins13] 未解鎖嘅廢墟撳唔到：測撳建築要先起咗
	var bo = [""]
	var UI = J.G.get("UI"); var o_ob = UI.get("openBuilding")
	UI["openBuilding"] = func(_t, a): bo[0] = J.str(J.arg(a, 0)); return null
	_cam(600.0); await _w(t, 0.3)
	J.mc(_V(), "tap", [195.0, 860.0]); await _w(t, 0.2)
	UI["openBuilding"] = o_ob
	_chk("原村子撳建築照舊（倉庫）", bo[0] == "store", bo[0])
	m.close_sheet()
	# ---------- 客人、孤魂、挑夫鬼 ----------
	for sid in MD.stations(c0): sc.sim.sst(sid).unlocked = true
	for sid in MD.stations(c0): sc.sim.st().counter[str(MD.st_def(sid).get("good", ""))] = 30.0   # [militia] 客人只要有供應嘅貨：櫃台擺貨
	_cam(-E + 300.0)
	var sides = {}
	for i in 40:
		await _w(t, 0.25)
		for cu in sc.sim.custs: sides[int(cu.get("side", 0))] = true   # 十秒內出現過嘅客人（隨機左右，唔好只睇最後一刻）
	if sides.size() < 2:   # 隊排滿咗冇新客：直接再出 16 個客睇左右（一半由左邊入，隨機）
		var keep = sc.sim.custs.duplicate()
		for i in 16:
			sc.sim.custs.clear()
			if sc.sim.spawn_cust(): sides[int(sc.sim.custs[0].get("side", 0))] = true
		sc.sim.custs = keep
	_chk("客人行排隊線（兩邊都有）", sc.sim.custs.size() > 0 and sides.size() == 2, "客 %d 邊 %s" % [sc.sim.custs.size(), sides.keys()])
	var on_path = true
	for cu in sc.sim.custs:
		if cu.pos.y < 1000.0 or cu.pos.y > E + 5.0: on_path = false
	_chk("客人喺櫃台前排隊（唔經柵欄）", on_path)
	var foes_ok = sc.sim.foes.size() > 0
	for f in sc.sim.foes: if f.pos.y > float(sc.sim.L.fence_y) + 4.0: foes_ok = false
	_chk("圍欄孤魂喺柵欄外", foes_ok, sc.sim.foes.size())
	M_add_stock()
	em._pt = 0.0
	await _w(t, 0.5)
	_chk("有料 → 挑夫鬼出發", em.porters.size() > 0)
	# ---------- 拔營只換上半 ----------
	var pos_before = J.G.get("POS").duplicate(true)
	var tr_before = S.trees.duplicate(true); var pd_before = S.paddy.duplicate(true)
	var ci_a = sc.sim.ci()
	_goto_ci(sc, ci_a + 1); await _w(t, 0.5)   # 拔營（move_next 要目標做齊；呢度直接換圖）
	_chk("拔營換圖（新背景 a＋b＋b）", sc.sim.ci() == ci_a + 1 and sc._bg_tiles().size() == 3 and sc._bg_tiles()[0] == Spr.get_tex("bgm%d_a" % (ci_a + 1)))
	sc.anim = {"t": 4.0, "from": ci_a + 1, "done": true, "line": ""}; await _w(t, 0.2)
	_chk("拔營動畫：大排檔區淡出（嵌入）", sc.embed and sc.hud_on)
	sc.anim = null
	_chk("拔營：原村子唔變（位置、樹、稻田）", str(J.G.get("POS")) == str(pos_before) and str(S.trees) == str(tr_before) and str(S.paddy) == str(pd_before))
	_chk("拔營：唔郁鏡頭範圍", absf(em.eh() - E) < 1.0)
	_goto_ci(sc, ci_a); await _w(t, 0.3)
	# ---------- [polish4] 合一地圖：玩法線小卡 → 開卡 → 撥貨 → 關卡 ----------
	await _plus_embed(t, m, sc, em)
	# ---------- 舊存檔（mv_on 未設） ----------
	var S2 = S.duplicate(true); S2.erase("mv_on"); S2.erase("mv")
	J.G["S"] = S2
	m._mv_apply(); await _w(t, 0.3)
	_chk("舊存檔：自動開合一", J.t(J.G.S.get("mv_on")) and J.G.S.get("mv") is Dictionary and m.mv_embed == em)
	J.G["S"] = S; m._mv_apply()
	if shots:
		S.res.coins = 1e7
		for c in MD.maps_n():
			_goto_ci(sc, c)
			for sid in MD.stations(c): sc.sim.sst(sid).unlocked = true
			sc._prefill(); await _w(t, 3.0)
			await _shots_map(t, m, c)
		_goto_ci(sc, c0)
	if full: await _fps(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _tap_btn(sc, em, key: String) -> bool:   # 用村子世界座標撳（同真玩一樣經 mv_embed.on_tap）
	if not sc._btns.has(key): return false
	var c: Vector2 = sc._btns[key].get_center()
	return em.on_tap(c.x, c.y + em.vcam())
func _plus_embed(t, m, sc, em) -> void:
	var EVc = load("res://game/outpost/mv_event.gd"); var Mc = load("res://game/outpost/mat.gd")
	var sim = sc.sim; var P = sim.plus
	for sid in MD.stations(sim.ci()): sim.sst(sid).unlocked = true
	P.ps(sim).orders.clear(); P.ps(sim).ord_t = 9999.0; P.card = null
	var vh = m.village.size.y / (m.village.size.x / 390.0)
	# 鏡頭喺原村子：唔出小卡、撳唔到
	_cam(300.0); await _w(t, 0.6)
	var o = EVc.make_order(P, sim)
	_chk("合一：有大單", o is Dictionary and not o.is_empty())
	if not (o is Dictionary) or o.is_empty(): return
	o["star"] = {}
	await _w(t, 0.4)
	_chk("合一：鏡頭喺原村子唔出玩法掣", not sc._btns.has("plus_pill") and not sc._btns.has("plus:ord:0"))
	# 鏡頭去大排檔區：出玩法掣（收埋），撳一下展開
	_cam(-em.eh() * 0.5 - vh * 0.5); await _w(t, 0.8)
	_chk("合一：大排檔區出玩法掣（預設收埋）", sc._btns.has("plus_pill") and not sc._btns.has("plus:ord:0"))
	if not sc._btns.has("plus_pill"): return
	var pr: Rect2 = sc._btns["plus_pill"]
	_chk("合一：玩法掣喺精簡 HUD 下面、唔撞「拔營！」", pr.position.y >= sc.top_pad + sc.EHUD_H and (not sc.sim.can_move() or pr.position.x >= 176.0), pr)
	if sc._cb_pos is Vector2 and sc._cb_sz != Vector2.ZERO: _chk("合一：玩法掣唔撞「生產鏈」掣", not Rect2(sc._cb_pos, sc._cb_sz).intersects(pr), [sc._cb_pos, pr])
	_tap_btn(sc, em, "plus_pill"); await _w(t, 0.3)
	_chk("合一：撳玩法掣 → 展開小卡", sc._btns.has("plus:ord:0"), sc._btns.keys().filter(func(k): return str(k).begins_with("plus")))
	if not sc._btns.has("plus:ord:0"): return
	var r: Rect2 = sc._btns["plus:ord:0"]
	_chk("合一：小卡喺玩法掣下面、唔落到原村子", r.position.y > pr.end.y - 4.0 and r.end.y <= sc.w2s(Vector2(0, sc.world_h())).y + 0.5, [pr, r])
	# 一半貨：撥貨 → 部分，卡仲開住 → 關
	for g in o.need:
		sim.st().counter[str(g)] = 0.0
		Mc.add(str(g), -Mc.amt(str(g))); Mc.add(str(g), floor(J.num(o.need[g]) / 2.0))
	_chk("合一：撳大單小卡（經 mv_embed.on_tap）", _tap_btn(sc, em, "plus:ord:0"))
	await _w(t, 0.3)
	_chk("合一：開大單卡", P.card is Dictionary and str(P.card.k) == "order")
	_chk("合一：卡開住有撥貨／關掣", sc._btns.has("plus:card:give") and sc._btns.has("plus:card:close"))
	var got0 = 0.0
	for g in o.got: got0 += J.num(o.got[g])
	_tap_btn(sc, em, "plus:card:give"); await _w(t, 0.3)
	var got1 = 0.0
	for g in o.got: got1 += J.num(o.got[g])
	_chk("合一：撥貨（一半）→ 已撥數增加、卡仲開", got1 > got0 and P.card != null, [got0, got1])
	_tap_btn(sc, em, "plus:card:close"); await _w(t, 0.3)
	_chk("合一：撳「關」→ 卡關", P.card == null)
	# 夠貨：開卡 → 撥貨 → 完成（卡自動關、收錢）
	for g in o.need: Mc.add(str(g), J.num(o.need[g]) * 2.0)
	await _w(t, 0.2)
	if not sc._btns.has("plus:ord:0"): _tap_btn(sc, em, "plus_pill"); await _w(t, 0.3)
	_tap_btn(sc, em, "plus:ord:0"); await _w(t, 0.3)
	_chk("合一：再開大單卡", P.card != null)
	var c_before = sim.coins()
	_tap_btn(sc, em, "plus:card:give"); await _w(t, 0.3)
	_chk("合一：撥夠貨 → 大單完成、卡關、收錢", P.card == null and P.ps(sim).orders.is_empty() and sim.coins() > c_before, [sim.coins() - c_before])
	# 招牌卡：撳卡外面＝關
	if not sc._btns.has("plus:sign"): _tap_btn(sc, em, "plus_pill"); await _w(t, 0.3)
	if sc._btns.has("plus:sign"):
		_tap_btn(sc, em, "plus:sign"); await _w(t, 0.3)
		_chk("合一：開招牌卡", P.card is Dictionary and str(P.card.k) == "sign")
		var vy = sc.top_pad + 150.0
		em.on_tap(195.0, vy + em.vcam()); await _w(t, 0.3)
		_chk("合一：撳卡外 → 招牌卡關", P.card == null)
	P.card = null
	await _w(t, 9.0)
	_chk("合一：玩法掣 8 秒冇撳自動收埋", not sc._btns.has("plus:sign") and not sc._btns.has("plus:ord:0"))

func M_add_stock() -> void:
	var M = load("res://game/outpost/mat.gd")
	M.add("m_bao", 50); M.add("m_bamboo", 50); M.add("m_paper", 50)

func fps(t) -> void:
	var m = await _boot(t)
	await _fps(t, m)
func _fps(t, m) -> void:
	var E = m.mv_embed.eh()
	for pt in [[-E, "大排檔頂"], [-E * 0.5, "大排檔中"], [180.0, "原村子"]]:
		_cam(pt[0]); await _w(t, 1.0)
		var f0 = Engine.get_frames_drawn(); var t0 = Time.get_ticks_msec()
		await _w(t, 3.0)
		var fps_v = (Engine.get_frames_drawn() - f0) * 1000.0 / maxf(1.0, Time.get_ticks_msec() - t0)
		_p("FPS %s %.1f" % [pt[1], fps_v])
