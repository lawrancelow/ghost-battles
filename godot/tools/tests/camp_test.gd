# [camp] 營地測試：原本村子嘅建築搬入移動村大地圖（game/outpost/mv_camp.gd）
# 用法：/home/claude/setup/edtest.sh <godot目錄> camp res://tools/tests/camp_test.gd all   （全新 user dir）
#   logic：每張圖營地建築齊、唔疊（建築之間、同台／搬貨路線／櫃台／紙紮大屋／排隊線／營地泥路）、撳建築開啱嘅卡、
#          撳伐木場加槐木＋任務計數、糯米田、棺材鋪親手做、化寶爐包裹提示＋開包、拔營後營地喺新圖、後院面板「去營地」
#   all：logic ＋ 每張圖截圖（/tmp/camp/shots/*.png）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/camp/shots/"
const MD = preload("res://game/outpost/mv_data.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const JZ = preload("res://game/joss/joss.gd")

func _p(m): print("[camp] ", m)
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

func all(t) -> void: await _run(t, true)
func logic(t) -> void: await _run(t, false)

func _goto_ci(sc, c: int) -> void:
	sc.sim.st().ci = float(c); sc._after_move()

func _rects_static(sc, c: int) -> Dictionary:   # 唔准撞嘅嘢（世界座標）
	var Ly = MD.layout(c); var o = {"rect": [], "poly": []}
	for sid in MD.stations(c):
		var p = MD.st_xy(c, sid)
		o.rect.append(["台 " + sid, Rect2(p.x - 64, p.y - 130, 128, 196)])
		o.poly.append(["搬貨路線 " + sid, MD.st_path(c, sid), 0.0])
	var cp = MD.v2(Ly.counter)
	o.rect.append(["櫃台", Rect2(cp.x - 98, cp.y - 60, 196, 80)])
	var hp = MD.v2(Ly.house)
	o.rect.append(["紙紮大屋", Rect2(hp.x - 84, hp.y - 140, 168, 140)])
	o.poly.append(["排隊線", MD.queue_poly(c), 90.0])   # 客人企喺線上，身高約 90
	return o
func _seg_hit(r: Rect2, P: PackedVector2Array, up: float) -> bool:
	for i in range(1, P.size()):
		for k in 17:
			var q = P[i - 1].lerp(P[i], k / 16.0)
			for dy in [0.0, up * 0.5, up]:
				if r.has_point(q - Vector2(0, dy)): return true
	return false

func _run(t, shots: bool) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var S = J.G.S
	_chk("移動村開住", J.t(S.get("mv_on")) and m.mv_view != null and m.mv_host.visible)
	var sc = m.mv_view
	_chk("場景有營地", sc.camp != null)
	var camp = sc.camp
	# 全部建築起晒（截圖睇齊）：舊十間 Lv1 以上，拓展建築全部起好
	S.lv = 12.0
	for id in camp.ORDER: S.bld[id] = maxf(1.0, J.num(S.bld.get(id, 0)))
	var all_new = CB.new_blds()
	# ---------- 1. 每張圖：營地資料齊、唔疊 ----------
	var ids_all = camp.ORDER.duplicate(); ids_all.append_array(all_new)
	for c in MD.maps_n():
		var Ly = MD.layout(c); var cl = Ly.get("camp", {})
		var sl = cl.get("slots", {})
		var miss = []
		for id in ids_all: if not sl.has(id): miss.append(id)
		_chk("圖%d：layout.camp.slots 有齊 %d 間" % [c, ids_all.size()], miss.is_empty(), miss)
		_chk("圖%d：營地木牌／泥路有數據" % c, cl.get("sign") is Array and (cl.get("road", []) as Array).size() >= 3)
		_goto_ci(sc, c)
		var its = []
		for id in ids_all:
			var e = sl.get(id, [195, 0, 1])
			its.append({"id": id, "x": float(e[0]), "y": float(e[1]), "s": float(e[2]) if e.size() > 2 else 1.0})
		var ov = []
		for i in its.size():
			var a = camp.full_rect(its[i])
			if a.position.x < 0 or a.end.x > 390: ov.append("爆格:" + its[i].id)
			for j in range(i + 1, its.size()):
				if a.intersects(camp.full_rect(its[j])): ov.append(its[i].id + "×" + its[j].id)
			if a.intersects(camp.sign_rect()): ov.append(its[i].id + "×木牌")
		_chk("圖%d：營地建築之間唔疊、唔爆格" % c, ov.is_empty(), ov)
		var X = _rects_static(sc, c); var ov2 = []
		for it in its:
			var a = camp.full_rect(it)
			for r in X.rect: if a.intersects(r[1]): ov2.append(it.id + "×" + r[0])
			for pl in X.poly: if _seg_hit(a, pl[1], pl[2]): ov2.append(it.id + "×" + pl[0])
			var b = camp.body_rect(it).grow_individual(0, 0, 0, 40)
			if _seg_hit(b, camp.road(), 0.0): ov2.append(it.id + "×營地泥路")
		_chk("圖%d：營地唔撞台／搬貨路線／櫃台／大屋／排隊線／營地泥路" % c, ov2.is_empty(), ov2)
		# 裝飾唔遮建築（樹由腳向上畫）
		var ov3 = []
		for d in Ly.get("decor", []):
			if not (d is Dictionary) or str(d.k) in ["stream", "bridge", "fogbank"]: continue
			var dp = Vector2(float(d.x), float(d.y))
			for it in its:
				if camp.full_rect(it).has_point(dp): ov3.append("%s@%d,%d×%s" % [d.k, int(dp.x), int(dp.y), it.id])
		_chk("圖%d：營地裝飾唔企喺建築度" % c, ov3.is_empty(), ov3)
	_goto_ci(sc, 0)
	# 顯示：舊十間＋shown 拓展建築
	var shown = camp.items().map(func(x): return x.id)
	var need = camp.ORDER.duplicate(); need.append_array(CB.shown())
	_chk("畫面顯示舊建築＋已起／已解鎖／預告拓展建築", shown == need, "%d/%d" % [shown.size(), need.size()])
	_chk("地圖加長到營地底", sc.world_h() >= camp.bottom() - 1.0 and sc.cam_max() > float(MD.layout(0).h) - sc.view_h(), "%d" % int(sc.world_h()))

	# ---------- 2. 撳建築開啱嘅卡 ----------
	await _w(t, 0.6)
	sc.cam_camp(); await _w(t, 1.2)
	_chk("鏡頭去到營地", sc.cam >= camp.top() - sc.HUD_H - 40.0, "%d/%d" % [int(sc.cam), int(camp.top())])
	for id in ["store", "house", "altar"]:
		var r = camp.tap("campc", id); await _w(t, 0.3)
		_chk("撳 %s 開建築卡" % id, r == "card" and Menus.cur == "bld:" + id and m.sheet.visible, Menus.cur)
		Menus.close_hook(); m.close_sheet(); await _w(t, 0.2)
	var nb = CB.shown()[0]
	camp.tap("campc", nb); await _w(t, 0.3)
	_chk("撳拓展建築 %s 開 chain_bld 卡" % nb, Menus.cur == "bld:" + nb and m.sheet.visible and m.sheet_title.text == CB.bname(nb), m.sheet_title.text)
	Menus.close_hook(); m.close_sheet(); await _w(t, 0.2)
	# 未起：開建造卡
	var unb = ""
	for b in CB.shown(): if CB.lv(b) <= 0: unb = b; break
	if unb != "":
		var d = J.mc(J.gp(J.G.UI, "_n"), "bld", [unb])
		camp.tap("campa", unb); await _w(t, 0.3)
		_chk("未起嘅 %s 撳開建造卡" % unb, Menus.cur == "bld:" + unb and d is Dictionary and J.num(d.get("lv")) == 0.0)
		Menus.close_hook(); m.close_sheet(); await _w(t, 0.2)
	# 經真撳（畫面座標）：撳名牌開卡
	sc.focus_camp("store"); await _w(t, 1.2)
	var itx = camp.item("store")
	var sp = sc.w2s(camp.plate_rect(itx).get_center())
	sc.tap(sp); await _w(t, 0.3)
	_chk("畫面撳倉庫名牌開卡（經 mv_scene.tap）", Menus.cur == "bld:store" and m.sheet.visible, "%s @%s" % [Menus.cur, str(sp)])
	Menus.close_hook(); m.close_sheet(); await _w(t, 0.2)

	# ---------- 3. 撳伐木場＝砍樹（同舊村子一樣：槐木、好評、S.cnt.chop、任務） ----------
	var q0 = int(J.num(S.qi))
	var wood0 = J.num(S.res.wood); var chop0 = J.num(S.cnt.chop); var exp0 = J.num(S.exp) + J.num(S.lv) * 1000.0
	sc.focus_camp("wood"); await _w(t, 1.0)
	var wit = camp.item("wood")
	sc.tap(sc.w2s(camp.body_rect(wit).get_center()))   # 經畫面撳
	await _w(t, 0.5)
	_chk("撳伐木場：阿福開工", camp.act != null and str(camp.act.id) == "wood")
	if shots: await _w(t, 0.3); await _shot(t, "20_chop")
	for i in 40:
		await _w(t, 0.2)
		if J.num(S.cnt.chop) > chop0: break
	_chk("砍樹：槐木 +4", J.num(S.res.wood) >= wood0 + 4.0, "%d→%d" % [int(wood0), int(J.num(S.res.wood))])
	_chk("砍樹：S.cnt.chop +1", J.num(S.cnt.chop) == chop0 + 1.0)
	var fl = false
	for f in sc.floats: if str(f.text).contains("+4"): fl = true
	_chk("砍樹：浮字喺營地出", fl)
	await _w(t, 1.2)
	for k in 2:   # 再砍兩棵：新手任務「砍 3 棵樹」喺大地圖做得到
		var c0 = J.num(S.cnt.chop)
		camp.tap("campa", "wood")
		for i in 40:
			await _w(t, 0.2)
			if J.num(S.cnt.chop) > c0: break
		await _w(t, 1.2)
	_chk("砍 3 棵：計數 3", J.num(S.cnt.chop) >= chop0 + 3.0, J.num(S.cnt.chop))
	var Q = DB.D.QUESTS
	_chk("新手任務「砍 3 棵樹」完成（任務推進）", q0 > 0 or int(J.num(S.qi)) > q0 or str(Q[q0].t) != "chop", "qi %d→%d" % [q0, int(J.num(S.qi))])
	await _skip(t, 4)
	# 糯米田
	var rice0 = J.num(S.res.rice); var rc0 = J.num(S.cnt.rice)
	camp.tap("campa", "rice")
	for i in 40:
		await _w(t, 0.2)
		if J.num(S.cnt.rice) > rc0: break
	_chk("撳糯米田：糯米 +3、S.cnt.rice +1", J.num(S.res.rice) >= rice0 + 3.0 and J.num(S.cnt.rice) == rc0 + 1.0, "%d→%d" % [int(rice0), int(J.num(S.res.rice))])
	await _w(t, 1.2); await _skip(t, 4)
	# 棺材鋪親手做
	S.res.wood = maxf(20.0, J.num(S.res.wood))
	var pl0 = J.num(S.res.planks); var cp0 = J.num(S.cnt.get("craftPlank", 0))
	camp.tap("campa", "plank")
	for i in 30:
		await _w(t, 0.2)
		if J.num(S.res.planks) > pl0: break
	_chk("撳棺材鋪：親手做一份（棺材板 +2、craftPlank +1）", J.num(S.res.planks) >= pl0 + 2.0 and J.num(S.cnt.get("craftPlank", 0)) == cp0 + 1.0)
	await _w(t, 1.0); await _skip(t, 4)
	S.res.wood = 0.0
	_chk("冇料：棺材鋪唔開工", camp.tap("campa", "plank") == "none")
	S.res.wood = 200.0

	# ---------- 4. 派鬼：喺建築前做嘢；斷料牌 ----------
	for i in 6: J.cl(J.G.get("recruitFodder"), null, [false])
	var gs = []
	for g in S.ghosts: if str(g.k) != "afu": gs.append(g)
	if gs.size() >= 2:
		gs[0]["post"] = "wood"; gs[1]["post"] = "plank"
	_chk("伐木場有鬼開工（working）", camp.working("wood"))
	S.res.wood = 0.0
	_chk("棺材鋪冇槐木：斷料", camp.starve("plank").size() > 0)
	S.res.wood = 200.0
	# ---------- 5. 化寶爐包裹提示 ----------
	S.bld.furnace = maxf(1.0, J.num(S.bld.furnace))
	var jst = JZ.st(); jst.q.append({"k": "n", "t": JZ.now()})
	_chk("化寶爐有包裹（camp.joss_n）", camp.joss_n() > 0, camp.joss_n())
	if shots:
		sc.focus_camp("furnace"); await _w(t, 1.2); await _shot(t, "21_furnace_joss")
	var jr = camp.tap("campc", "furnace"); await _w(t, 0.5)
	_chk("撳化寶爐（有包裹）直接開包", jr == "joss" and m.get_node_or_null("JossUnbox") != null)
	var ub = m.get_node_or_null("JossUnbox")
	if ub != null: ub.queue_free()
	await _w(t, 0.3)

	# ---------- 6. 後院面板：「去營地」 ----------
	sc.cam_home(); await _w(t, 0.3)
	m.open_backyard(); await _w(t, 0.4)
	CB.show_yard(m); await _w(t, 1.2)
	_chk("後院面板「去營地」：留喺移動村，鏡頭去營地", m.mv_host.visible and not m.village.visible and sc.cam >= camp.top() - 400.0, int(sc.cam))

	# ---------- 7. 截圖：每張圖 ----------
	if shots:
		for g in S.ghosts:
			if str(g.k) == "afu": continue
		for b in all_new: S.bld[b] = 1.0
		var gi = 2
		for b in ["rice", "bun", "camp"] + all_new.slice(0, 4):
			if gi < gs.size(): gs[gi]["post"] = b; gi += 1
		for c in MD.maps_n():
			_goto_ci(sc, c); camp.invalidate(); await _w(t, 0.6)
			# 營地頂（同台、櫃台一齊）
			sc.cam = camp.top() - 420.0; sc.cam_tgt = null; await _w(t, 0.5)
			await _shot(t, "%d_a_bazaar_camp" % c)
			var y = camp.top() - 120.0; var k2 = 0
			while y < sc.world_h() - 200.0 and k2 < 6:
				sc.cam = y; sc.cam_tgt = null; await _w(t, 0.45)
				await _shot(t, "%d_b_camp_%d" % [c, k2]); y += 620.0; k2 += 1
		_goto_ci(sc, 0)

	# ---------- 8. 拔營：營地跟大屋摺埋，去到新圖 ----------
	_goto_ci(sc, 0); await _w(t, 0.5)
	var st = sc.sim.st()
	st.goals_done = []
	for i in MD.goals(0).size(): st.goals_done.append(float(i))
	S.cleared["1-3"] = true
	_chk("可以拔營", sc.can_move())
	sc.cam = camp.top() - 500.0; sc.cam_tgt = null; await _w(t, 0.3)
	sc.move_next(); await _w(t, 0.7)
	_chk("拔營中：營地摺緊（fold < 1）", sc._fold_k() < 0.9, sc._fold_k())
	if shots: await _shot(t, "30_fold")
	for i in 40:
		await _w(t, 0.25)
		if sc.anim == null: break
	_chk("拔營完：去到圖 1", sc.ci() == 1)
	var Ly1 = MD.layout(1)
	_chk("營地喺新圖（頂 = 新圖 layout.camp.top）", is_equal_approx(camp.top(), float(Ly1.camp.top)), "%d/%d" % [int(camp.top()), int(Ly1.camp.top)])
	var itw = camp.item("wood")
	_chk("營地建築位置跟新圖 layout", itw != null and is_equal_approx(itw.x, float(Ly1.camp.slots.wood[0])) and is_equal_approx(itw.y, float(Ly1.camp.slots.wood[1])))
	_chk("拔營後舊建築等級照舊", J.num(S.bld.wood) >= 1.0 and J.num(S.bld.furnace) >= 1.0)
	if shots:
		sc.cam = camp.top() - 120.0; sc.cam_tgt = null; await _w(t, 0.5); await _shot(t, "31_after_move_camp")
	# ---------- 9. 舊村子畫面（移動村熄咗）照用得 ----------
	m.set_mv(false); await _w(t, 0.8)
	_chk("熄移動村：舊村子畫面出返", m.village.visible and not m.mv_host.visible)
	await _skip(t, 8)
	var c1 = J.num(S.cnt.chop)
	J.mc(J.G.Village, "tap", [100.0, 500.0])   # 撳舊村子嘅樹（第 8 棵，營地砍咗頭三棵）
	for i in 40:
		await _w(t, 0.25)
		if J.num(S.cnt.chop) > c1: break
	_chk("舊村子照砍得樹", J.num(S.cnt.chop) > c1, "busy=%s modal=%s hero=%s" % [str(J.mc(J.G.Story, "busy", [])), str(J.mc(J.G.UI, "modalOpen", [])), str(J.G.Village.hero)])
	if shots: await _shot(t, "40_old_village")
	m.set_mv(true); await _w(t, 0.5)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# 新背景預留（MAPS[ci].bg_tiles／layout.fence_art）：用現有背景圖扮三塊，睇接縫淡入、柵欄唔畫、營地照疊喺上面
func tiles(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	var sc = m.mv_view
	MD.map_def(0)["bg_tiles"] = ["bg_field", "bg_kampung", "bg_banana"]
	MD.layout(0)["fence_art"] = true
	sc._tiles_ci = -1
	var R = sc.tile_rects()
	_chk("bg_tiles：鋪到地圖底", R.size() >= 3 and float(R[R.size() - 1][1]) + float(R[R.size() - 1][2]) >= sc.world_h(), "%d 塊" % R.size())
	_chk("bg_tiles：第二塊疊 60px", R.size() >= 2 and is_equal_approx(float(R[1][1]), float(R[0][2]) - 60.0))
	_chk("fence_art：唔畫柵欄", sc.fence_art())
	sc.cam = -40.0; sc.cam_tgt = null; await _w(t, 0.6); await _shot(t, "50_tiles_top")
	sc.cam = float(R[1][1]) - 300.0; sc.cam_tgt = null; await _w(t, 0.5); await _shot(t, "51_tiles_seam")
	sc.cam = sc.camp.top() - 100.0; sc.cam_tgt = null; await _w(t, 0.5); await _shot(t, "52_tiles_camp")
	MD.map_def(0).erase("bg_tiles"); MD.layout(0)["fence_art"] = false; sc._tiles_ci = -1
	_p("RESULT ok=%d bad=%d" % [ok, bad])
