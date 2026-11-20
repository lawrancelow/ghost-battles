# [zone] 分區地圖測試（第 1 關）
# 用法：/home/claude/setup/edtest.sh <godot目錄> zone res://tools/tests/zone_test.gd logic|all|bake|smoke
#   bake：烘地面圖 assets/img/zone1_ground_a/_b.webp（1.5 倍）
#   logic：布局冇重疊、建築喺所屬區內、路徑可達、攻佔流程、加工廠只可建喺所屬區、舊存檔遷移、拖動縮放邊界、點擊唔誤觸、野外王／拔營
#   all：logic ＋ 截圖（/tmp/zone/shots/）
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/tmp/zone/shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const ZW = preload("res://game/zone/zone_walk.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const CF = preload("res://game/outpost/chain_field.gd")

func _p(m): print("[zone] ", m)
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
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _V(): return J.G.get("Village")

# ================= 烘地面 =================
func bake(t) -> void:
	var m = ZD.mdef(0); var K = 1.5
	var W = float(m.w); var H = float(m.h)
	var key = str(m.ground)
	for half in 2:
		var vp = SubViewport.new()
		vp.size = Vector2i(int(W * K), int(ceil(H / 2.0 * K))); vp.transparent_bg = false
		vp.render_target_update_mode = SubViewport.UPDATE_ONCE
		var pn = Node2D.new(); pn.set_script(load("res://game/zone/zone_ground.gd"))
		pn.M = m; pn.K = K; pn.Y0 = H / 2.0 * half
		vp.add_child(pn); t.get_tree().root.add_child(vp)
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var im = vp.get_texture().get_image()
		var path = ProjectSettings.globalize_path("res://assets/img/%s_%s.webp" % [key, "a" if half == 0 else "b"])
		im.save_webp(path, true, 0.82)
		_p("baked %s %s" % [path, im.get_size()])
		vp.queue_free()
	_p("RESULT ok=1 bad=0")

# ================= 冒煙：開機截幾張 =================
func smoke(t) -> void:
	var m = await _boot(t)
	var nv = m.village
	var c = nv.zone_cam()
	await _w(t, 1.0); await _shot(t, "smoke_home")
	c.z = c.z_min(); c.clamp_all(); c.center_on(Vector2(670, 1200)); await _w(t, 0.6); await _shot(t, "smoke_min")
	c.z = nv.size.x / 390.0; c.center_on(Vector2(670, 760)); await _w(t, 1.5); await _shot(t, "smoke_market")
	c.center_on(Vector2(670, 250)); await _w(t, 0.6); await _shot(t, "smoke_wild")
	c.center_on(Vector2(200, 1500)); await _w(t, 0.6); await _shot(t, "smoke_A")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func logic(t) -> void: await _run(t, false)
func all(t) -> void: await _run(t, true)

# ---------------- 小工具 ----------------
func _spr_rect(key: String, x: float, y: float, w: float) -> Rect2:
	var tx = Spr.get_tex(key) if Spr.ok(key) else null
	var h = w * tx.get_height() / tx.get_width() if tx != null else w
	return Rect2(x - w / 2.0, y + 6.0 - h, w, h)
# 建築佔地（圖下半截＝地基，上半截屋頂可以疊後面嘅嘢）
func _foot(r: Rect2) -> Rect2: return Rect2(r.position.x + r.size.x * 0.1, r.position.y + r.size.y * 0.45, r.size.x * 0.8, r.size.y * 0.55)
func _ev_btn(nv, p: Vector2, down: bool) -> void:
	var e = InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = down; e.position = p; nv._gui_input(e)
func _ev_mv(nv, p: Vector2) -> void:
	var e = InputEventMouseMotion.new(); e.position = p; nv._gui_input(e)
func _touch(nv, i: int, p: Vector2, down: bool) -> void:
	var e = InputEventScreenTouch.new(); e.index = i; e.position = p; e.pressed = down; nv._gui_input(e)
func _tdrag(nv, i: int, p: Vector2) -> void:
	var e = InputEventScreenDrag.new(); e.index = i; e.position = p; nv._gui_input(e)
func _finish_battle(t, win: bool) -> void:
	var B = J.G.get("Battle")
	J.mc(B, "finish", [win])
	await _w(t, 0.6)
	var dl = J.G.get("$")
	var okb = J.cl(dl, null, ["#b-ok"]) if dl != null else null
	if okb != null: J.cl(J.gp(okb, "onclick"), okb, [])
	await _w(t, 1.0)
	await _skip(t, 2)
func _walkable(p: Vector2) -> bool:
	return ZW.region(p) != "" and not ZV.blocked(p)   # 喺可企嘅區、唔撞地形阻隔（樹林帶／石牆／河／木樁／山岩）
func _seg_ok(a: Vector2, b: Vector2, ok_fn: Callable) -> bool:
	var n = int(ceil(a.distance_to(b) / 4.0))
	for i in n + 1:
		if not ok_fn.call(a.lerp(b, float(i) / maxf(1, n))): return false
	return true
func _poly_ok(P, ok_fn: Callable) -> bool:
	for i in range(1, P.size()):
		if not _seg_ok(P[i - 1], P[i], ok_fn): return false
	return true

func _run(t, shots: bool) -> void:
	var m = await _boot(t)
	var nv = m.village; var S = J.G.S; var em = m.mv_embed; var sc = m.mv_view
	var Z = ZD.cur()
	_chk("分區模式開（第 1 關有 zones 定義）", ZD.on() and nv.zone and ZD.applied() == "0")
	_chk("嵌入大排檔跟分區（sc.zone）", sc.zone and sc.embed)
	var POS = J.G.get("POS")
	var same = true
	for k in Z.village.POS: if Vector2(J.num(POS[k][0]), J.num(POS[k][1])) != ZD.v2(Z.village.POS[k]): same = false
	_chk("村子 POS 換咗做分區座標", same, POS.gate)
	_chk("槐樹 6 棵、稻田 4 格", J.G.TREE_POS.size() == 6 and J.G.PADDY_POS.size() == 4)
	_chk("世界大細 1340×2410", J.num(J.G.W) == 1340.0 and J.num(J.G.WH) == 2410.0)
	# 原村子建築（棺材鋪、包子鋪…）喺舊存檔照樣存在、畫喺新位
	var b0 = {}
	for k in ["plank", "bun", "house", "store", "home"]: b0[k] = S.bld.get(k, 0); S.bld[k] = maxf(1.0, J.num(S.bld.get(k, 0)))
	await _w(t, 0.3)
	var drawn = []
	for k in ["plank", "bun", "house", "store", "home"]:
		var st0 = nv.statics.get("b_" + k)
		if st0 != null and st0.node.visible and absf(st0.node.position.y - J.num(POS[k][1])) < 0.5: drawn.append(k)
	_chk("原村子建築（棺材鋪、包子鋪、鬼宅、倉庫、民宅）有畫、喺新位", drawn.size() == 5, drawn)
	for k in b0: S.bld[k] = b0[k]
	# ================= 1. 布局冇重疊／喺所屬區內 =================
	var vr = ZD.zrect("village"); var mr = ZD.zrect("market")
	var items = []   # [名, 佔地, 區]
	for k in Z.village.POS:
		if k == "gate": continue
		var r = _spr_rect(k, J.num(POS[k][0]), J.num(POS[k][1]), float(Art.BW.get(k, 100)))
		items.append([k, _foot(r), "village", r])
	for i in J.G.TREE_POS.size():
		var p = J.G.TREE_POS[i]; items.append(["tree%d" % i, _foot(_spr_rect("tree", p[0], p[1], 62)).grow(-6), "village", null])
	for i in J.G.PADDY_POS.size():
		var p = J.G.PADDY_POS[i]; items.append(["paddy%d" % i, Rect2(p[0] - 36, p[1] - 30, 72, 34), "village", null])
	for e in nv.extras(): items.append([e[0], Rect2(e[1] - e[3] / 2.0, e[2] - 50, e[3], 50), "village", null])
	for sid in MD.stations(0):
		var p = MD.st_xy(0, sid); items.append([sid, Rect2(p.x - 56, p.y - 92, 112, 160), "market", null])
	var cp = MD.v2(MD.layout(0).counter); items.append(["counter", Rect2(cp.x - 92, cp.y - 70, 184, 84), "market", null])
	for z in ZD.of_type("res"):
		for b in z.get("fields", {}):
			for nd in CF.nodes(b): items.append(["%s.%d" % [b, nd.i], Rect2(nd.x - 22, nd.y - 40, 44, 42), str(z.id), null])
			var sp = CF.sign_pos(b); items.append(["%s.sign" % b, Rect2(sp.x - 40, sp.y - 46, 80, 48), str(z.id), null])
		for b in z.get("shops", {}):
			var q = ZD.v2(z.shops[b].pos); items.append([b, Rect2(q.x - 53, q.y - 96, 106, 100), str(z.id), null])
	var ov = []
	for i in items.size():
		for j in range(i + 1, items.size()):
			var a = items[i]; var b = items[j]
			if a[0].begins_with("tree") and b[0].begins_with("tree"): continue
			if a[0].begins_with("paddy") and b[0].begins_with("paddy"): continue
			if a[1].grow(-3).intersects(b[1].grow(-3)): ov.append("%s×%s" % [a[0], b[0]])
	_chk("布局：建築／台／資源點／名牌冇重疊", ov.is_empty(), ov)
	var outz = []
	for it in items:
		if not ZD.zrect(it[2]).grow(2).encloses(it[1]): outz.append("%s→%s %s" % [it[0], it[2], it[1]])
	_chk("所有建築喺所屬區內", outz.is_empty(), outz)
	# 路（彎曲泥石路）：建築地基唔可以壓住主路／小路；擺設唔可以壓住主路、唔可以撞建築
	var ZG = load("res://game/zone/zone_ground.gd")
	var ps = ZG.path_samples(Z, 6.0)
	var on_path = func(r: Rect2, kinds: Array) -> bool:
		for e in ps:
			if not (e[2] in kinds): continue
			var q: Vector2 = e[0]; var hw: float = e[1]
			if Rect2(q.x - hw, q.y - hw * 0.5, hw * 2.0, hw).intersects(r): return true
		return false
	var onroad = []
	for it in items:
		if it[2] != "village" and it[2] != "market": continue
		if it[0].begins_with("paddy") or it[0].begins_with("tree"): continue
		var base = Rect2(it[1].position.x + 6, it[1].end.y - 14, it[1].size.x - 12, 14)
		if on_path.call(base, ["main"]): onroad.append(it[0])
	_chk("建築唔擋主路（彎曲泥石路）", onroad.is_empty(), onroad)
	var pov = []
	for pr in Z.village.get("props", []):
		var pw = maxf(24.0, float(pr[3]) * 0.6)
		var r = Rect2(float(pr[1]) - pw / 2.0, float(pr[2]) - 12, pw, 14)
		if not vr.grow(-4).encloses(r): pov.append("%s 出界" % pr[0])
		if on_path.call(r, ["main"]): pov.append("%s 壓路" % pr[0])
		for it in items: if it[1].grow(-2).intersects(r): pov.append("%s×%s" % [pr[0], it[0]])
	_chk("自然填充（草、石、樹、木桶、晾衫竹）唔壓主路、唔撞建築", pov.is_empty(), pov)
	var gate = ZD.v2(Z.village.POS.gate)
	_chk("出村門喺大排檔同中央村之間（中路上）", gate.y > mr.end.y and gate.y <= vr.position.y + 4 and absf(gate.x - 670) < 1)
	for z in ZD.of_type("wild"):
		_chk("%s 王位喺區內" % z.id, ZD.rect(z.rect).has_point(ZD.v2(z.boss_at)))
	# ================= 2. 路徑 =================
	var sim = sc.sim
	var in_market = func(p): return (mr.grow(2).has_point(p) or Rect2(415, 400, 60, 50).has_point(p) or Rect2(865, 400, 60, 50).has_point(p)) and not ZV.blocked(p)
	_chk("客人路（右門）喺大排檔內、由野外門入", _poly_ok(sim.QP, in_market) and absf(sim.QP[sim.QP.size() - 1].x - 895) < 1)
	_chk("客人路（左門）喺大排檔內、由野外門入", _poly_ok(sim.QP2, in_market) and absf(sim.QP2[sim.QP2.size() - 1].x - 445) < 1)
	var pp_ok = true
	for sid in MD.stations(0): if not _poly_ok(MD.st_path(0, sid), in_market): pp_ok = false
	_chk("搬貨路全部喺大排檔內", pp_ok)
	var corr = Rect2(645, 1070, 50, 100)
	var porter_ok = _poly_ok(em._path(), func(p): return (mr.grow(14).has_point(p) or corr.has_point(p) or vr.has_point(p)) and not ZV.blocked(p))
	_chk("挑夫路：村子 → 出村門 → 櫃台", porter_ok and em._path()[0].y > vr.position.y)
	var gs = sim.L.gates
	_chk("孤魂衝野外門（唔係成條柵欄）", gs.size() == 2 and absf(sim.fence_tgt(300).x - 445) < 20 and absf(sim.fence_tgt(1000).x - 895) < 20)
	var gh_ok = true
	for i in 3: if not mr.has_point(sim.guard_home(i)): gh_ok = false
	_chk("守夜企喺大排檔門口", gh_ok)
	# 阿福：資源區要佔領先入到；經門洞
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	var r0 = ZW.route(Vector2(670, 1650), Vector2(110, 1400))
	_chk("未佔領：阿福入唔到資源區（停喺村子）", vr.has_point(r0[r0.size() - 1]) and r0.size() == 1, r0)
	for zid in ["A", "B", "C"]: ZD.set_owned(zid)
	var reach = true; var dbg = []
	for dst in [Vector2(110, 1400), Vector2(1230, 1420), Vector2(560, 2200)]:
		var rt = ZW.route(Vector2(670, 1650), dst)
		var P = [Vector2(670, 1650)] + rt
		if not _poly_ok(P, _walkable) or rt[rt.size() - 1] != dst: reach = false; dbg.append(rt)
	var rt2 = [Vector2(110, 1400)] + ZW.route(Vector2(110, 1400), Vector2(1230, 1420))
	if not _poly_ok(rt2, _walkable): reach = false; dbg.append(rt2)
	_chk("路徑可達：村子 ↔ A／B／C、A → B（經小徑／拱門／木橋，唔穿樹林帶／石牆／河）", reach, dbg)
	var bl = [Vector2(226, 1400), Vector2(1115, 1400), Vector2(300, 1994), Vector2(670, 200), Vector2(300, 440), Vector2(100, 600)]
	var nb = [Vector2(226, 1576), Vector2(1115, 1576), Vector2(670, 1994), Vector2(445, 436), Vector2(895, 436)]
	var bok = true
	for p in bl: if not ZV.blocked(p): bok = false
	for p in nb: if ZV.blocked(p): bok = false
	_chk("地形阻隔有碰撞（樹林帶／石牆／河／山脊／木樁／山岩），小徑／拱門／橋／野外門通", bok)
	var pz = J.G.PlazaLife; var zok = true
	for zz in [pz.ZA, pz.ZB]:
		for p in [Vector2(zz[0], zz[2]), Vector2(zz[1], zz[3]), Vector2(zz[0], zz[3]), Vector2(zz[1], zz[2])]: if not vr.has_point(p) or ZV.blocked(p): zok = false
	_chk("村鬼（廣場鬼）活動範圍喺村子內", zok)
	# 實際行一次：撳竹叢 → 阿福行入 A
	var V = _V(); var H = V.hero
	H.x = 670.0; H.y = 1650.0; H.tx = 670.0; H.ty = 1650.0; H.act = null; H.target = null
	var nd0 = CF.nodes("b_bamboo")[0]
	CF.tap_node(V, "b_bamboo", 0, nd0.x, nd0.y)
	var thru = false; var maxx = 0.0
	for i in 120:
		await _w(t, 0.1)
		var hp = Vector2(J.num(H.x), J.num(H.y))
		if ZD.rect(ZD.zone("A").door.rect).grow(10).has_point(hp): thru = true
		if not _walkable(hp): maxx += 1
		if hp.x < 220 and H.get("act") is Dictionary: break
	_chk("撳竹叢：阿福經門洞行入 A，開始斬竹", thru and maxx == 0 and J.num(H.x) < 220 and H.get("act") is Dictionary and H.act.get("kind") == "cnode", [J.num(H.x), J.num(H.y), H.get("act"), maxx])
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	H.x = 670.0; H.y = 1650.0; H.tx = 670.0; H.ty = 1650.0; H.act = null; H.target = null; H.erase("zf")
	# ================= 3. 攻佔流程 =================
	S.res.troops = 0.0
	_chk("陰兵戰力 = 陰兵 × 民宅加成", ZD.power() == 0)
	_chk("戰力唔夠：派陰兵攻佔唔得", ZD.capture_auto("A") == "weak" and not ZD.owned("A"))
	_chk("未佔領：竹叢唔採得、破篾棚唔起得", not CF.usable("b_bamboo") and CB.zone_lock("b_strip") != "")
	S.res.troops = 400.0; S.bld.home = 1.0
	_chk("戰力 400 ≥ 300", ZD.power() == 400)
	var r = ZD.capture_auto("A")
	_chk("派陰兵攻佔 A：成功、折損 90 陰兵", r == "ok" and ZD.owned("A") and absf(J.num(S.res.troops) - 310.0) < 0.5, [r, S.res.troops])
	_chk("佔領後：竹叢採得", CF.usable("b_bamboo"))
	S.bld["b_bamboo"] = 0.0; S.bld.house = maxf(J.num(S.bld.get("house", 1)), 5.0)
	S.mat["m_wood"] = 1e4; S.mat["m_plank"] = 1e4; S.res.wood = 1e4; S.res.planks = 1e4; S.res.coins = 1e7
	_chk("開墾竹林", CB.build("b_bamboo") and CB.lv("b_bamboo") == 1)
	_chk("破篾棚：竹林未到 Lv3 唔起得", not CB.build("b_strip") and CB.zone_lock("b_strip").contains("Lv3"), CB.zone_lock("b_strip"))
	CB.upgrade("b_bamboo"); CB.upgrade("b_bamboo")
	_chk("竹林升到 Lv3 → 破篾棚起得", CB.lv("b_bamboo") == 3 and CB.zone_lock("b_strip") == "" and CB.build("b_strip"), CB.lv("b_bamboo"))
	_chk("加工廠只可建喺所屬區：紙寮（B 未佔領）起唔到", not CB.build("b_paper") and CB.zone_lock("b_paper").contains("攻佔"))
	_chk("紙寮固定喺 B 區", ZD.bid_zone("b_paper") == "B" and ZD.zrect("B").has_point(CB.pos("b_paper")))
	# 親自出征（現有戰鬥）
	S["team"] = [S.ghosts[0].id] if (S.team is Array and S.team.is_empty()) else S.team
	var any = false
	for x in J.iter(S.team): if J.t(x): any = true
	if not any: S.team = [S.ghosts[1].id if S.ghosts.size() > 1 else S.ghosts[0].id]
	var rb = ZD.start_battle("cap", "B")
	var B = J.G.get("Battle")
	_chk("親自出征 B：開現有戰鬥", rb == "ok" and J.t(B.get("active")) and str(B.sid) == str(S.zone.exp.sid), [rb, B.get("sid")])
	await _w(t, 1.5)
	if shots: await _shot(t, "z30_capture_battle")
	await _finish_battle(t, true)
	var pr = {"win": ZD.owned("B")}
	for n in ZD.NEWS: pr = n
	ZD.poll()
	_chk("打贏 → B 佔領（戰鬥結算後）", ZD.owned("B") and not J.t(B.get("active")), pr)
	_chk("出征記錄唔污染主線通關", not (S.cleared is Dictionary and S.cleared.has(str(pr.get("sid", "x")))))
	_chk("唔會再失去：已佔領", ZD.capture_auto("B") == "owned")
	# ================= 4. 野外王＋拔營 =================
	var c0 = sim.ci()
	for i in MD.goals(c0).size(): if not sim.goal_claimed(i): sim.st().goals_done.append(float(i))
	var had13 = J.t(S.cleared.get("1-3"))
	S.cleared["1-3"] = true
	_chk("主線王打低但其他野外王未打：唔拔得營", not sim.can_move() and not ZD.all_bosses_done())
	_chk("王要按次序：亂葬崗下一個係 ①", ZD.boss_next("w_graves") == 0)
	_chk("餓鬼坑：主 Boss＝世界地圖 1-3（已打）", ZD.boss_done("w_pit", 1) and ZD.main_boss_done())
	var rb2 = ZD.start_battle("boss", "w_graves")
	await _w(t, 1.0)
	await _finish_battle(t, true); ZD.poll()
	_chk("打低紙人偶頭目 → 輪到守墓鬼", rb2 == "ok" and ZD.boss_done("w_graves", 0) and ZD.boss_next("w_graves") == 1)
	S.zone.boss["0:zb_keeper"] = true; S.zone.boss["0:zb_egui"] = true
	_chk("全部王打低 → 解放、可以拔營", ZD.all_bosses_done() and sim.can_move())
	var MS = load("res://game/outpost/mv_story.gd")
	_chk("劇本 all_done／boss_next 相容", MS.all_done(sim) and MS.boss_next(sim))
	S.zone.boss.erase("0:zb_keeper"); if not had13: S.cleared.erase("1-3")
	sim.st().goals_done = []
	# ================= 5. 舊存檔遷移 =================
	var bak = S.zone.duplicate(true)
	S.erase("zone"); S.bld["b_straw"] = 2.0; S.cleared["1-3"] = true
	ZD.st()
	_chk("舊存檔：已開墾禾稈 → C 已佔領", ZD.owned("C"))
	_chk("舊存檔：已起破篾棚／竹林 → A 已佔領", ZD.owned("A"))
	_chk("舊存檔：主線已過 1-3 → 餓鬼坑兩個王已打", ZD.boss_done("w_pit", 0) and ZD.boss_done("w_pit", 1) and not ZD.boss_done("w_graves", 0))
	_chk("舊存檔：等級／已派鬼保留", CB.lv("b_straw") == 2 and CB.lv("b_strip") == 1)
	S["zone"] = bak; S.bld.erase("b_straw"); if not had13: S.cleared.erase("1-3")
	# ================= 6. 鏡頭：拖動、縮放、邊界、慣性 =================
	var c = nv.zone_cam()
	c.z = 0.01; c.clamp_all()
	var tl = c.s2w(Vector2(0, c.top_px)); var br = c.s2w(c.view)
	_chk("最細縮放：成張圖（闊＋高）喺 HUD 下面、底部導航上面完整顯示", tl.x <= 0.5 and tl.y <= 0.5 and br.x >= 1339.5 and br.y >= 2409.5 and c.top_px > 50.0, [tl, br, c.top_px])
	c.z = 99.0; c.clamp_all()
	_chk("最大縮放有上限（最少睇 300 單位）", absf(c.vw() - 300.0) < 0.5)
	c.z = nv.size.x / 390.0; c.center_on(Vector2(670, 1500)); c.vel = Vector2.ZERO
	var x0 = c.x; var y0 = c.y
	_ev_btn(nv, Vector2(200, 400), true); _ev_mv(nv, Vector2(260, 330)); _ev_mv(nv, Vector2(300, 300)); _ev_btn(nv, Vector2(300, 300), false)
	_chk("拖動：上下左右都郁", c.x < x0 - 50 and c.y > y0 + 50, [c.x - x0, c.y - y0])
	for i in 40: _ev_btn(nv, Vector2(10, 10), true); _ev_mv(nv, Vector2(380, 600)); _ev_btn(nv, Vector2(380, 600), false)
	_chk("邊界夾住（左上）", absf(c.x) < 0.5 and c.y >= -c.top_extra - 0.5, [c.x, c.y])
	for i in 60: _ev_btn(nv, Vector2(380, 600), true); _ev_mv(nv, Vector2(10, 10)); _ev_btn(nv, Vector2(10, 10), false)
	_chk("邊界夾住（右下）", absf(c.x - (1340.0 - c.vw())) < 0.5 and absf(c.y - (2410.0 - c.vh())) < 0.5, [c.x, c.y])
	c.center_on(Vector2(670, 1500)); c.vel = Vector2.ZERO
	var z0 = c.z
	_touch(nv, 0, Vector2(150, 300), true); _touch(nv, 1, Vector2(250, 300), true)
	_tdrag(nv, 0, Vector2(100, 300)); _tdrag(nv, 1, Vector2(300, 300))
	_touch(nv, 1, Vector2(300, 300), false); _touch(nv, 0, Vector2(100, 300), false)
	_chk("兩指縮放（拉開 → 放大，到上限）", c.z > z0 + 0.1 and c.z <= c.z_max() + 1e-6, [z0, c.z])
	var zz = c.z
	_touch(nv, 0, Vector2(100, 300), true); _touch(nv, 1, Vector2(300, 300), true)
	_tdrag(nv, 0, Vector2(190, 300)); _tdrag(nv, 1, Vector2(210, 300))
	_touch(nv, 1, Vector2(210, 300), false); _touch(nv, 0, Vector2(190, 300), false)
	_chk("兩指縮放（捏埋 → 縮細，有下限）", c.z < zz and c.z >= c.z_min() - 1e-6, [zz, c.z])
	c.z = nv.size.x / 390.0; c.center_on(Vector2(670, 1500))
	c._t = 0.0; _ev_btn(nv, Vector2(200, 400), true); c._t = 0.016; _ev_mv(nv, Vector2(200, 380)); c._t = 0.032; _ev_mv(nv, Vector2(200, 340)); c._t = 0.04; _ev_btn(nv, Vector2(200, 340), false)
	var yv = c.y
	await _w(t, 0.4)
	_chk("慣性：放手之後繼續滑、慢慢停", c.y > yv + 5.0 and c.vel.length() < 2000.0, [yv, c.y])
	# ================= 7. 點擊唔誤觸 =================
	c.z = nv.size.x / 390.0; c.center_on(Vector2(670, 1500)); c.vel = Vector2.ZERO
	await _w(t, 0.3)
	var taps = []
	var o_tap = V.get("tap")
	V["tap"] = func(_t0, a): taps.append(Vector2(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))); return null
	_ev_btn(nv, Vector2(200, 400), true); _ev_mv(nv, Vector2(200, 440)); _ev_btn(nv, Vector2(200, 440), false)
	_chk("拖動放手唔當撳", taps.is_empty())
	_ev_btn(nv, Vector2(200, 400), true); _ev_mv(nv, Vector2(204, 403)); _ev_btn(nv, Vector2(204, 403), false)
	var want = c.s2w(Vector2(200, 400))
	_chk("單指撳：撳到村子世界座標", taps.size() == 1 and taps[0].distance_to(want) < 2.0, [taps, want])
	V["tap"] = o_tap
	# 撳建築開卡
	var opened = [""]
	var UI = J.G.get("UI"); var o_ob = UI.get("openBuilding")
	UI["openBuilding"] = func(_t0, a): opened[0] = J.str(J.arg(a, 0)); return null
	var sp = Vector2(800, 1270)   # 倉庫
	c.center_on(sp); await _w(t, 0.2)
	nv.zone_tap(c.w2s(sp))
	_chk("撳倉庫開建築卡", opened[0] == "store", opened[0])
	UI["openBuilding"] = o_ob
	# 撳未佔領資源區 → 攻佔卡
	m.close_sheet()
	c.center_on(Vector2(1230, 1500)); await _w(t, 0.3)
	nv.zone_tap(c.w2s(Vector2(1230, 1500)))
	_chk("撳未佔領資源區（C 已佔領，撳 B…）出攻佔卡", m.sheet.visible and m.sheet_title.text.contains("枯井巷") or ZD.owned("B"), m.sheet_title.text)
	m.close_sheet()
	S.zone.own.erase("0:C")
	c.center_on(Vector2(670, 2200)); await _w(t, 0.3)
	nv.zone_tap(c.w2s(Vector2(670, 2200)))
	_chk("撳未佔領 C 出攻佔卡（建議戰力、你嘅陰兵戰力）", m.sheet.visible and m.sheet_title.text.contains("禾稈"), m.sheet_title.text)
	m.close_sheet()
	# 撳野外王 → 王卡
	var ba = ZD.v2(ZD.zone("w_graves").boss_at)
	c.center_on(ba); await _w(t, 0.3)
	nv.zone_tap(c.w2s(ba + Vector2(0, -30)))
	_chk("撳野外王出挑戰卡", m.sheet.visible and m.sheet_title.text.contains("亂葬崗"), m.sheet_title.text)
	m.close_sheet()
	# 撳大排檔台 → 升級條
	var sid0 = MD.stations(0)[0]; sim.sst(sid0).unlocked = true
	var stp = sim.st_pos(sid0)
	c.center_on(stp); await _w(t, 0.4)
	nv.zone_tap(c.w2s(stp + Vector2(0, -40)))
	_chk("撳大排檔台開資料卡", sc.sheet.visible and sc.sel == sid0, sc.sel)
	sc.close_sheet()
	await _w(t, 0.6)
	# 客人、孤魂
	for sid in MD.stations(0): sim.sst(sid).unlocked = true
	c.center_on(Vector2(670, 700))
	for i in 30: await _w(t, 0.25)
	var cu_ok = sim.custs.size() > 0
	for cu in sim.custs: if not mr.grow(40).has_point(cu.pos): cu_ok = false
	_chk("客人喺大排檔（由野外門入）", cu_ok, sim.custs.size())
	var foe_ok = sim.foes.size() > 0
	for f in sim.foes:
		var inw = false
		for z in ZD.of_type("wild"): if ZD.rect(z.rect).grow(30).has_point(f.pos): inw = true
		if not inw: foe_ok = false
	_chk("孤魂喺野外區", foe_ok, sim.foes.size())
	if shots: await _shots(t, m)
	# ================= 8. 第 2 張圖：舊豎條布局照用 =================
	sim.st().ci = 1.0; sc._after_move(); await _w(t, 1.0)
	_chk("第 2 張圖：冇 zones 定義 → 舊豎條（POS 還原）", not ZD.on() and not nv.zone and J.num(J.G.POS.gate[1]) == 118.0 and J.num(J.G.W) == 390.0)
	_chk("第 2 張圖：大排檔用舊 layout", not sc.zone and float(MD.layout(1).get("w", 390)) == 390.0)
	sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.0)
	_chk("返第 1 張圖：再套分區", ZD.on() and nv.zone and J.num(J.G.POS.gate[1]) == 1152.0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _shots(t, m) -> void:
	var nv = m.village; var c = nv.zone_cam(); var S = J.G.S
	c.vel = Vector2.ZERO
	c.z = c.z_min(); c.center_on(Vector2(670, 1205)); await _w(t, 0.8); await _shot(t, "z01_whole_min")
	c.z = c.z_min() * 1.6; c.center_on(Vector2(670, 700)); await _w(t, 0.6); await _shot(t, "z02_zoom_top")
	c.center_on(Vector2(670, 1700)); await _w(t, 0.6); await _shot(t, "z03_zoom_bottom")
	c.z = nv.size.x / 390.0
	for e in [["z10_wild_graves", 445, 230], ["z11_wild_pit", 895, 230], ["z12_market_l", 440, 760], ["z13_market_r", 900, 760], ["z14_counter_gate", 670, 1060],
			["z15_village_top", 560, 1330], ["z16_village_mid", 760, 1560], ["z17_village_bot", 560, 1850], ["z18_village_br", 900, 1850]]:
		c.center_on(Vector2(e[1], e[2])); await _w(t, 0.8); await _shot(t, e[0])
	# 攻佔前後
	S.zone.own.erase("0:A"); S.zone.own.erase("0:C")
	c.center_on(Vector2(180, 1500)); await _w(t, 0.6); await _shot(t, "z20_A_before")
	ZD.set_owned("A"); await _w(t, 0.6); await _shot(t, "z21_A_after")
	c.center_on(Vector2(670, 2200)); await _w(t, 0.6); await _shot(t, "z22_C_before")
	nv.zone_tap(c.w2s(Vector2(670, 2200))); await _w(t, 0.5); await _shot(t, "z23_C_capture_card")
	m.close_sheet(); ZD.set_owned("C"); await _w(t, 0.6); await _shot(t, "z24_C_after")
	c.center_on(Vector2(1230, 1500)); await _w(t, 0.6); await _shot(t, "z25_B")
	var ba = ZD.v2(ZD.zone("w_pit").boss_at); c.center_on(ba)
	await _w(t, 0.4); nv.zone_tap(c.w2s(ba + Vector2(0, -30))); await _w(t, 0.5); await _shot(t, "z26_boss_card")
	m.close_sheet()
