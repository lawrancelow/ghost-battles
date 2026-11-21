# [paddyfix] 第 1–4 關中央村：6 格稻田全部割得、8 棵槐樹全部砍得（經玩家同一條撳屏路：nv_village.zone_tap → ZV.tap → Village.tap → hitTest → walkTo（分區排路）→ update 收割）
#   阿福由村子出生點自己行過去（唔瞬移），證明每格／每棵都行得到；撳位＝畫出嚟嘅圖中心（唔係邏輯座標），證明撳中範圍同圖對得上
#   另查：冇任何裝飾（村子 DECOR／props、各區 decor／props／scenery、黑霧外圍 kit）用槐樹／稻田嘅圖
# 用法：/home/claude/setup/edtest.sh <godot目錄> paddyfix res://tools/tests/paddyfix_test.gd logic|all
#   all：logic ＋ 每關收割前／後截圖（/tmp/paddyfix/shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/paddyfix/shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
# 可砍槐樹（Art.draw_tree 畫 tree_bare／tree、砍咗 stump）同可割稻田（paddy／paddy_cut）嘅圖
const ART_KEYS := ["tree", "tree_bare", "stump", "paddy", "paddy_cut", "deco:tree", "deco:paddy"]
const TREE_SHAPED := ["zp_deadtree", "zb_bush", "zt_cliffpine", "zt_banana", "zt_mangrove", "banana", "deco:banana"]   # 同 zone_build.py TREE_SHAPED
var _shots_on := false

func _p(m): print("[paddyfix] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	if not _shots_on: return
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _skip(t, n := 4):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
func _unblock(m) -> void:   # 劇情／彈窗會食咗撳屏（Village.tap 第一行）：收埋
	var st = m.get("story")
	if st and st.get("cur") != null: st.skip_scene()
	var UI = J.G.get("UI")
	if UI != null and J.t(J.mc(UI, "modalOpen", [])) and m.get("sheet") != null: m.sheet.visible = false
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

func logic(t) -> void: await _run(t, false)
func all(t) -> void: _shots_on = true; await _run(t, true)

func _run(t, _shots: bool) -> void:
	var m = await _boot(t)
	ZD.gate_on = false
	for c in [0, 1, 2, 3]: await _level(t, m, c)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# 圖中心（同 Art.draw_tree／draw_paddy 一樣計：底部對齊 y+4／y+9、樹高 80+(i%3)*4、稻田闊 56）
func _tree_vis(p: Vector2, i: int) -> Rect2:
	var H = 80.0 + (i % 3) * 4.0
	var im = Spr.get_tex("tree_bare") if Spr.ok("tree_bare") else Spr.get_tex("tree")
	var w = H * im.get_width() / im.get_height()
	return Rect2(p.x - w / 2.0, p.y + 4.0 - H, w, H)
func _paddy_vis(p: Vector2) -> Rect2:
	var im = Spr.get_tex("paddy"); var h = 56.0 * im.get_height() / im.get_width()
	return Rect2(p.x - 28.0, p.y + 9.0 - h, 56.0, h)

func _diag(m, V) -> String:
	var H = V.hero; var st = J.G.get("Story"); var UI = J.G.get("UI")
	return "hero=(%d,%d) tx=(%d,%d) tg=%s act=%s zq=%d walking=%s story=%s modal=%s cur=%s" % [J.num(H.x), J.num(H.y), J.num(H.get("tx")), J.num(H.get("ty")), H.get("target"), H.get("act"), (H.get("zq") as Array).size() if H.get("zq") is Array else -1, H.get("walking"),
		J.t(J.mc(st, "busy", [])) if st != null else null, J.t(J.mc(UI, "modalOpen", [])) if UI != null else null, m.get("story").get("cur") != null if m.get("story") else null]
func _reset_hero(V) -> void:
	var H = V.hero; var hp = ZD.v2(ZD.cur().village.hero)
	H.x = hp.x; H.y = hp.y; H.tx = hp.x; H.ty = hp.y; H.act = null; H.target = null; H["zq"] = []; H.walking = false

func _level(t, m, c: int) -> void:
	var sc = m.mv_view
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2); await _skip(t)
	var tag = "第 %d 關：" % (c + 1)
	var V = J.G.get("Village"); var S = J.G.S; var nv = m.village; var cam = nv.zone_cam()
	var TP = J.G.TREE_POS; var PP = J.G.PADDY_POS
	var Z = ZD.cur()
	_chk(tag + "已套用呢關村子座標", ZD.applied() == str(c) and TP == ZD._fa(Z.village.TREE_POS) and PP == ZD._fa(Z.village.PADDY_POS), ZD.applied())
	_chk(tag + "槐樹 8 棵、稻田 6 格；存檔 trees／treeRegrow 8 格、paddy／paddyRegrow 6 格",
		TP.size() == 8 and PP.size() == 6 and S.trees.size() == 8 and S.treeRegrow.size() == 8 and S.paddy.size() == 6 and S.paddyRegrow.size() == 6,
		[TP.size(), PP.size(), S.trees.size(), S.paddy.size()])
	# 撳圖中心／圖上半／圖下半：hitTest 都係佢自己
	var hb = []
	for i in TP.size():
		var r = _tree_vis(ZD.v2(TP[i]), i)
		for fy in [0.3, 0.55, 0.85]:
			var q = Vector2(r.get_center().x, r.position.y + r.size.y * fy)
			var h = J.mc(V, "hitTest", [q.x, q.y])
			if not (h is Dictionary) or str(h.kind) != "tree" or int(J.num(h.i)) != i: hb.append(["t", i, fy, h])
	for i in PP.size():
		var r = _paddy_vis(ZD.v2(PP[i]))
		for fx in [0.2, 0.5, 0.8]:
			var q = Vector2(r.position.x + r.size.x * fx, r.get_center().y)
			var h = J.mc(V, "hitTest", [q.x, q.y])
			if not (h is Dictionary) or str(h.kind) != "paddy" or int(J.num(h.i)) != i: hb.append(["p", i, fx, h])
	_chk(tag + "撳每棵槐樹／每格稻田畫出嚟嘅圖，hitTest 都係佢自己", hb.is_empty(), hb)
	# 冇裝飾用槐樹／稻田嘅圖
	var badk = []
	for pr in Z.village.get("props", []): if str(pr[0]) in ART_KEYS: badk.append(["props", pr])
	for d in J.G.DECOR: if str(d[0]) in ART_KEYS: badk.append(["DECOR", d])
	for z in ZD.zones():
		for pr in z.get("props", []) + z.get("decor", []): if str(pr[0]) in ART_KEYS: badk.append([z.id, pr])
	for sc0 in Z.get("scenery", []): if str(sc0[0]) in ART_KEYS: badk.append(["scenery", sc0])
	for b in Z.get("barriers", []): if str(b.get("key", "")) in ART_KEYS: badk.append(["barrier", b.get("key")])
	for kit in ZV.VOID_KIT.values():
		for e in kit: if str(e[0]) in ART_KEYS: badk.append(["void", e[0]])
	for e in ZV._geo.get("forest", []): if str(e[0]) in ART_KEYS: badk.append(["forest", e[0]])
	_chk(tag + "冇裝飾物用槐樹／稻田圖（似樹似田但撳唔到）", badk.is_empty(), badk)
	var near = []
	for pr in Z.village.get("props", []) + J.G.DECOR:
		if not (str(pr[0]) in TREE_SHAPED): continue
		for q in TP: if Vector2(J.num(pr[1]), J.num(pr[2])).distance_to(ZD.v2(q)) < 130.0: near.append([pr[0], pr[1], pr[2]]); break
	_chk(tag + "槐樹林 130 內冇樹形裝飾（枯樹／灌木樹／松／香蕉樹）", near.is_empty(), near)
	# 收割前截圖
	for i in PP.size(): S.paddy[i] = 1.0; S.paddyRegrow[i] = 0.0
	for i in TP.size(): S.trees[i] = 3.0; S.treeRegrow[i] = 0.0
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	var pc = (ZD.v2(PP[0]) + ZD.v2(PP[5])) / 2.0; var tc = (ZD.v2(TP[0]) + ZD.v2(TP[7])) / 2.0
	cam.center_on(pc + Vector2(0, -10)); await _w(t, 0.6); await _shot(t, "L%d_paddy_before" % (c + 1))
	cam.center_on(tc + Vector2(0, -30)); await _w(t, 0.6); await _shot(t, "L%d_trees_before" % (c + 1))
	# 逐格撳（阿福由出生點行過去）
	Engine.time_scale = 4.0
	var got = []
	for i in PP.size():
		_reset_hero(V)
		var vr = _paddy_vis(ZD.v2(PP[i]))
		cam.center_on(vr.get_center()); await _w(t, 0.1)
		_unblock(m)
		var pre = _diag(m, V)
		nv.zone_tap(nv.zone_w2s(vr.get_center()))
		var post = _diag(m, V)
		var dl = Time.get_ticks_msec() + 90000   # 實時 90 秒上限（機慢、幀率低時 dt 被夾，遊戲時間行得慢）
		for k in 100000:
			if Time.get_ticks_msec() > dl: break
			await _w(t, 0.1)
			if not J.t(S.paddy[i]): break
			if k % 10 == 9: _unblock(m)
		if not J.t(S.paddy[i]): got.append(i); S.paddyRegrow[i] = 999.0   # 截圖時唔好生返
		else: _p("diag paddy %d\n  pre  %s\n  post %s\n  end  %s" % [i, pre, post, _diag(m, V)])
	_chk(tag + "6 格稻田全部撳得、行得到、割得", got.size() == 6, got)
	var cut = []
	for i in TP.size():
		_reset_hero(V)
		var vr = _tree_vis(ZD.v2(TP[i]), i)
		cam.center_on(vr.get_center()); await _w(t, 0.1)
		_unblock(m)
		nv.zone_tap(nv.zone_w2s(vr.get_center()))
		var dl = Time.get_ticks_msec() + 120000
		for k in 100000:
			if Time.get_ticks_msec() > dl: break
			await _w(t, 0.1)
			if int(J.num(S.trees[i])) <= 0: break
			if k % 10 == 9: _unblock(m)
		if int(J.num(S.trees[i])) <= 0: cut.append(i); S.treeRegrow[i] = 999.0
		else: _p("diag tree %d %s" % [i, _diag(m, V)])
	_chk(tag + "8 棵槐樹全部撳得、行得到、砍得", cut.size() == 8, cut)
	Engine.time_scale = 1.0
	_reset_hero(V)
	await _skip(t, 3)
	cam.center_on(pc + Vector2(0, -10)); await _w(t, 0.6); await _shot(t, "L%d_paddy_after" % (c + 1))
	cam.center_on(tc + Vector2(0, -30)); await _w(t, 0.6); await _shot(t, "L%d_trees_after" % (c + 1))
	for i in PP.size(): S.paddy[i] = 1.0; S.paddyRegrow[i] = 0.0
	for i in TP.size(): S.trees[i] = 3.0; S.treeRegrow[i] = 0.0
