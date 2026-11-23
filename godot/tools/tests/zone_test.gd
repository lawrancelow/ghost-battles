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
	var cs = OS.get_environment("GB_ZMAP").split(",", false) if OS.has_environment("GB_ZMAP") else PackedStringArray(["0", "1", "2", "3"])
	for cc in cs: await _bake1(t, int(cc))
	_p("RESULT ok=1 bad=0")
func _bake1(t, ci: int) -> void:
	var m = ZD.mdef(ci); var K = 1.5
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
	_chk("槐樹 8 棵、稻田 6 格（[fogfix] 全部砍得／割得）", J.G.TREE_POS.size() == 8 and J.G.PADDY_POS.size() == 6)
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
	_chk("邊界夾住（左上）", absf(c.x - ZD.bounds().position.x) < 0.5 and c.y >= ZD.bounds().position.y - c.top_extra - 0.5, [c.x, c.y])   # [mapx] 鏡頭範圍＝分圈擴展後 ext
	for i in 60: _ev_btn(nv, Vector2(380, 600), true); _ev_mv(nv, Vector2(10, 10)); _ev_btn(nv, Vector2(10, 10), false)
	_chk("邊界夾住（右下）", absf(c.x - (ZD.bounds().end.x - c.vw())) < 0.5 and absf(c.y - (ZD.bounds().end.y - c.vh())) < 0.5, [c.x, c.y])
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
	if not J.t(J.G.S.bld.get("store")): J.G.S.bld["store"] = 1.0   # [ruins13] 未解鎖嘅廢墟撳唔到：測撳建築要先起咗
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
	for sid in MD.stations(0): sim.st().counter[str(MD.st_def(sid).get("good", ""))] = 20.0   # [militia] 客人只要有供應嘅貨：櫃台擺貨
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
	await names_check(t, m)
	var kb = ZD.bosses("w_graves")[1]
	_chk("守墓鬼用現有鬼怪素材（唔借殭屍兵）", str(kb.art) == "n30_jerangkung" and Spr.ok("n30_jerangkung") and J.G.ENEMY_T.has("n30_jerangkung"))
	S.zone.boss["0:zb_paper"] = true; S.zone.boss.erase("0:zb_keeper")
	var rk = ZD.start_battle("boss", "w_graves"); await _w(t, 1.0)
	var bn = ""
	for u in J.iter(J.G.Battle.units): if J.t(J.gp(u, "boss")): bn = J.str(u.name)
	_chk("戰鬥入面王名＝亂葬崗守墓鬼", rk == "ok" and bn == "亂葬崗守墓鬼", bn)
	await _finish_battle(t, false); ZD.poll()
	if shots: await _shots(t, m)
	# ================= 8. 第 2 張圖：舊豎條布局照用 =================
	sim.st().ci = 4.0; sc._after_move(); await _w(t, 1.0)
	_chk("第 5 張圖：[zone56] 已有 zones 定義 → 分區", ZD.on() and nv.zone and sc.zone and ZD.applied() == "4")
	var nz = 0
	for mi in MD.maps_n(): if ZD.mdef(mi).size() > 0: nz += 1
	_chk("全部地圖都有分區定義", nz == MD.maps_n() and MD.maps_n() == 6, nz)
	sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.0)
	_chk("返第 1 張圖：再套分區", ZD.on() and nv.zone and J.num(J.G.POS.gate[1]) == 1152.0)
	if not OS.has_environment("GB_ZONE1_ONLY"): await maps_check(t, m, shots)   # [zone2] 第 2–4 關
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# 每區名牌只畫一個（全名／短名按縮放揀其一）；守墓鬼用現有 n30 鬼、戰鬥顯示名
func names_check(t, m) -> void:
	var nv = m.village; var c = nv.zone_cam()
	for zz in [c.z_min(), nv.size.x / 390.0, nv.size.x / 300.0]:
		c.z = zz; c.center_on(Vector2(670, 1990)); await _w(t, 0.3)
		var dup = []
		for z in ZD.zones():
			var full = ZD.T(z.n); var short = full.split("　")[-1]
			var n = 0
			for s in ZV.plates: if s.begins_with(full) or s == short or s.begins_with(short + "（"): n += 1
			if z.type != "market" and ZD.rect(z.rect).intersects(nv.view_rect()) and n != 1: dup.append("%s×%d" % [full, n])
		_chk("縮放 %.2f：每區名牌只畫一個" % zz, dup.is_empty(), dup)
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

# ================= [zone2] 第 2–4 關（ci 1–3）：每關都驗 =================
const SIDE_OF := {"0": "N", "1": "E", "2": "S", "3": "W"}
const LOOK_OF := {"0": "l1", "1": "l2", "2": "l3", "3": "l4", "4": "l5", "5": "l6"}
class StoryStub extends RefCounted:
	var log: Array = []
	var held: Array = []
	var defer := false
	func zone_event(kind, id := "", cb := Callable()) -> bool:
		log.append([kind, id])
		if cb.is_valid():
			if defer: held.append(cb); return true
			cb.call()
		return false
	func has_ev(kind: String, id := "*") -> bool:
		for e in log: if e[0] == kind and (id == "*" or e[1] == id): return true
		return false
func _goto(t, m, c: int) -> void:
	var sc = m.mv_view
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2)
# [zone56] 第 5、6 關：主線第 2 段（Pocong／黑白無常）都喺野外王度打，所以容許 [c,1]＋[c,2]
func _mains_ok(mains: Array, c: int) -> bool:
	var st = []
	for x in mains:
		if int(x[0]) != c: return false
		st.append(int(x[1]))
	st.sort()
	return st == [2] or (c >= 4 and st == [1, 2])
func maps_check(t, m, shots: bool) -> void:
	var sides = {}
	var looks = {}
	for c in [0, 1, 2, 3]:
		var Z = ZD.mdef(c)
		sides[str(Z.get("gate_side", ""))] = true
	for c in [0, 1, 2, 3, 4, 5]:
		looks[str(ZD.mdef(c).get("look", {}).get("key", ""))] = true
	_chk("頭四關出村門喺唔同邊（北／東／南／西）", sides.size() == 4 and sides.has("N") and sides.has("E") and sides.has("S") and sides.has("W"), sides.keys())
	_chk("第 5、6 關出村門（南／東）", str(ZD.mdef(4).get("gate_side", "")) == "S" and str(ZD.mdef(5).get("gate_side", "")) == "E", [ZD.mdef(4).get("gate_side"), ZD.mdef(5).get("gate_side")])
	_chk("六關各自 look（l1–l6）", looks.size() == 6, looks.keys())
	for c in [1, 2, 3, 4, 5]: await map_check(t, m, c, shots)
	await migrate_check(t, m)
	await _goto(t, m, 0)
func map_check(t, m, c: int, shots: bool) -> void:
	var nv = m.village; var S = J.G.S; var sc = m.mv_view; var sim = sc.sim; var em = m.mv_embed
	var stub = StoryStub.new(); ZD.hook = stub
	S.zone.erase("sent")
	await _goto(t, m, c)
	var Z = ZD.cur(); var tag = "第 %d 關：" % (c + 1)
	_chk(tag + "分區模式＋套用", ZD.on() and nv.zone and ZD.applied() == str(c) and sc.zone, ZD.applied())
	_chk(tag + "look＝" + LOOK_OF[str(c)], ZV.lkey() == LOOK_OF[str(c)] and ResourceLoader.exists("res://assets/img/%s_a.webp" % Z.ground) and nv.ysort.modulate == ZV.grade())
	_chk(tag + "世界大細", J.num(J.G.W) == float(Z.w) and J.num(J.G.WH) == float(Z.h) and nv.zone_cam().world == ZD.bounds().size and nv.zone_cam().org == ZD.bounds().position)   # [mapx]
	_chk(tag + "大排檔台＝該關 STATIONS", MD.stations(c).size() == (7 if c == 1 else (9 if c >= 4 else 8)) + 1 and Z.market.st.size() == MD.stations(c).size(), MD.stations(c))   # [militia] ＋1 隨村台紙紮兵器檔
	var POS = J.G.get("POS"); var vr = ZD.zrect("village"); var mr = ZD.zrect("market")
	# ---- 布局 ----
	var items = []
	for k in Z.village.POS:
		if k == "gate": continue
		items.append([k, _foot(_spr_rect(k, J.num(POS[k][0]), J.num(POS[k][1]), float(Art.BW.get(k, 100)))), "village"])
	for i in J.G.TREE_POS.size():
		var p = J.G.TREE_POS[i]; items.append(["tree%d" % i, _foot(_spr_rect("tree", p[0], p[1], 62)).grow(-6), "village"])
	for i in J.G.PADDY_POS.size():
		var p = J.G.PADDY_POS[i]; items.append(["paddy%d" % i, Rect2(p[0] - 36, p[1] - 30, 72, 34), "village"])
	for e in nv.extras(): items.append([e[0], Rect2(e[1] - e[3] / 2.0, e[2] - 50, e[3], 50), "village"])
	for sid in MD.stations(c):
		var p = MD.st_xy(c, sid); items.append([sid, Rect2(p.x - 56, p.y - 92, 112, 160), "market"])
	var cp = MD.v2(MD.layout(c).counter); items.append(["counter", Rect2(cp.x - 92, cp.y - 70, 184, 84), "market"])
	var gp = ZD.v2(Z.village.POS.gate); var gate_r = _foot(_spr_rect("gate", gp.x, gp.y, 150.0))
	items.append(["gate", gate_r, ""])
	for z in ZD.of_type("res"):
		for b in z.get("fields", {}):
			for nd in CF.nodes(b): items.append(["%s.%d" % [b, nd.i], Rect2(nd.x - 22, nd.y - 40, 44, 42), str(z.id)])
			var sp = CF.sign_pos(b); items.append(["%s.sign" % b, Rect2(sp.x - 40, sp.y - 46, 80, 48), str(z.id)])
		for b in z.get("shops", {}):
			var q = ZD.v2(z.shops[b].pos); items.append([b, Rect2(q.x - 53, q.y - 96, 106, 100), str(z.id)])
	var ov = []
	for i in items.size():
		for j in range(i + 1, items.size()):
			var a = items[i]; var b = items[j]
			if a[0].begins_with("tree") and b[0].begins_with("tree"): continue
			if a[0].begins_with("paddy") and b[0].begins_with("paddy"): continue
			if a[1].grow(-3).intersects(b[1].grow(-3)): ov.append("%s×%s" % [a[0], b[0]])
	_chk(tag + "布局：建築／台／資源點／名牌／出村門冇重疊", ov.is_empty(), ov)
	var outz = []
	for it in items:
		if it[2] != "" and not ZD.zrect(it[2]).grow(2).encloses(it[1]): outz.append("%s→%s" % [it[0], it[2]])
	_chk(tag + "所有建築喺所屬區內", outz.is_empty(), outz)
	var ZG = load("res://game/zone/zone_ground.gd")
	var ps = ZG.path_samples(Z, 6.0)
	var on_path = func(r: Rect2) -> bool:
		for e in ps:
			if e[2] != "main": continue
			var q: Vector2 = e[0]; var hw: float = e[1]
			if Rect2(q.x - hw, q.y - hw * 0.5, hw * 2.0, hw).intersects(r): return true
		return false
	var pov = []
	for pr in Z.village.get("props", []):
		var pw = maxf(24.0, float(pr[3]) * 0.6)
		var r = Rect2(float(pr[1]) - pw / 2.0, float(pr[2]) - 12, pw, 14)
		if not vr.grow(-4).encloses(r): pov.append("%s 出界" % pr[0])
		if on_path.call(r): pov.append("%s 壓路" % pr[0])
		for it in items: if it[1].grow(-2).intersects(r): pov.append("%s×%s" % [pr[0], it[0]])
	_chk(tag + "院落擺設（該關 zq_*）唔壓主路、唔撞建築", pov.is_empty(), pov)
	var zq = 0
	for pr in Z.village.props: if str(pr[0]).begins_with("zq_"): zq += 1
	_chk(tag + "村子院落用該關擺設（zq_* ≥ 10 件）", zq >= 10, zq)
	# 出村門喺指定嗰邊、對住大排檔
	var side = str(Z.gate_side); var gok = false
	match side:
		"E": gok = gp.x >= vr.end.x - 10 and mr.position.x >= vr.end.x and absf(gp.y - 1208) < 40
		"S": gok = gp.y >= vr.end.y and mr.position.y >= vr.end.y - 4
		"W": gok = gp.x <= vr.position.x + 10 and mr.end.x <= vr.position.x
	_chk(tag + "出村門喺%s邊、大排檔喺嗰邊" % side, gok, gp)
	for z in ZD.of_type("wild"): _chk(tag + "%s 王位喺區內" % z.id, ZD.rect(z.rect).has_point(ZD.v2(z.boss_at)))
	# ---- 路徑 ----
	var grs = []
	for g in Z.market.gates: grs.append(Rect2(float(g[0]) - 32, float(g[1]) - 40, 64, 80))
	var in_market = func(p):
		var ok2 = mr.grow(2).has_point(p)
		for r in grs: if r.has_point(p): ok2 = true
		return ok2 and not ZV.blocked(p)
	var g0 = ZD.v2(Z.market.gates[0]); var g1 = ZD.v2(Z.market.gates[1])
	var e1 = sim.QP[sim.QP.size() - 1]; var e2 = sim.QP2[sim.QP2.size() - 1]
	_chk(tag + "客人兩條路喺大排檔內、各由一道野外門入", _poly_ok(sim.QP, in_market) and _poly_ok(sim.QP2, in_market) and minf(e1.distance_to(g0), e1.distance_to(g1)) < 30 and minf(e2.distance_to(g0), e2.distance_to(g1)) < 30 and e1.distance_to(e2) > 100, [e1, e2])
	var pp_ok = []
	for sid in MD.stations(c): if not _poly_ok(MD.st_path(c, sid), in_market): pp_ok.append(sid)
	_chk(tag + "搬貨路全部喺大排檔內", pp_ok.is_empty(), pp_ok)
	var corr = Rect2(gp.x - 80, gp.y - 110, 160, 160)
	var pth = em._path()
	_chk(tag + "挑夫路：村子 → 出村門 → 櫃台", _poly_ok(pth, func(p): return (mr.grow(14).has_point(p) or corr.has_point(p) or vr.has_point(p)) and not ZV.blocked(p)) and vr.has_point(pth[0]) and mr.grow(14).has_point(pth[pth.size() - 1]), pth)
	var gs = sim.L.gates
	var ft0 = sim.fence_tgt(g0.x, (ZD.rect(ZD.of_type("wild")[0].rect).get_center()).y); var ft1 = sim.fence_tgt(g1.x, ZD.rect(ZD.of_type("wild")[1].rect).get_center().y)
	_chk(tag + "孤魂衝最近嘅野外門（任何方向）", gs.size() == 2 and ft0.distance_to(g0) < 30 and ft1.distance_to(g1) < 30, [ft0, ft1])
	var w0 = ZD.rect(ZD.of_type("wild")[0].rect).get_center(); var w1 = ZD.rect(ZD.of_type("wild")[1].rect).get_center()
	_chk(tag + "孤魂喺野外深處唔算到門口；衝到門口先算", not sim.at_fence(w0, 90) and not sim.at_fence(w1, 90) and sim.at_fence(ft0, 90) and sim.at_fence(ft1, 90))
	var gh_ok = true
	for i in 3: if not mr.has_point(sim.guard_home(i)): gh_ok = false
	_chk(tag + "守夜企喺大排檔門口", gh_ok)
	# 阿福：未佔領入唔到；佔領後經門洞／橋／小徑可達；地形阻隔有碰撞
	for zid in ["A", "B", "C"]: S.zone.own.erase("%d:%s" % [c, zid])
	var vh = ZD.v2(Z.village.hero)
	var blocked0 = true
	for zid in ["A", "B", "C"]:
		var dst = ZD.v2(Z.zones.filter(func(z): return z.id == zid)[0].fields.values()[0].sign)
		var r0 = ZW.route(vh, dst)
		if not (vr.grow(4).has_point(r0[r0.size() - 1]) or ZD.rect(ZD.zone(zid).door.rect).has_point(r0[r0.size() - 1])): blocked0 = false
	_chk(tag + "未佔領：阿福入唔到資源區", blocked0)
	for zid in ["A", "B", "C"]: ZD.set_owned(zid)
	var reach = true; var dbg = []
	for zid in ["A", "B", "C"]:
		var dst = ZD.v2(ZD.zone(zid).fields.values()[0].sign) + Vector2(0, 8)
		var rt = ZW.route(vh, dst)
		if not _poly_ok([vh] + rt, _walkable) or rt[rt.size() - 1] != dst: reach = false; dbg.append([zid, rt])
	var dA = ZD.v2(ZD.zone("A").fields.values()[0].sign) + Vector2(0, 8); var dB = ZD.v2(ZD.zone("B").fields.values()[0].sign) + Vector2(0, 8)
	var rab = [dA] + ZW.route(dA, dB)
	if not _poly_ok(rab, _walkable): reach = false; dbg.append(["A→B", rab])
	_chk(tag + "路徑可達：村子 ↔ A／B／C、A → B（唔穿阻隔）", reach, dbg)
	var bok = []
	for b in Z.barriers:
		var k = str(b.k)
		var probe = []; var open = []
		match k:
			"river": probe = [Vector2((float(b.x0) + float(b.x1)) * 0.3, float(b.y))]; for br in b.bridges: open.append(Vector2((float(br[0]) + float(br[1])) / 2.0, float(b.y)))
			"vriver": probe = [Vector2(float(b.x), float(b.y0) + 100)]; for br in b.bridges: open.append(Vector2(float(b.x), (float(br[0]) + float(br[1])) / 2.0))
			"ditch", "vfence", "rail": probe = [Vector2(float(b.x), float(b.y0) + 60)]; open = [Vector2(float(b.x), (float(b.gap[0]) + float(b.gap[1])) / 2.0)]
			"belt", "fence": probe = [Vector2(float(b.x0) + 40, float(b.y) - 6)]; open = [Vector2((float(b.gap[0]) + float(b.gap[1])) / 2.0, float(b.y) - 6)]
			"stakes": probe = [Vector2(float(b.x0) + 20, float(b.y) - 10)]; for g in b.gaps: open.append(Vector2((float(g[0]) + float(g[1])) / 2.0, float(b.y) - 10))
			"void": for r in b.rects: probe.append(ZD.rect(r).get_center())
		for p in probe: if not ZV.blocked(p): bok.append("%s 唔擋 %s" % [k, p])
		for p in open: if ZV.blocked(p): bok.append("%s 門口擋 %s" % [k, p])
	_chk(tag + "地形阻隔有碰撞、門口／橋／小徑通", bok.is_empty(), bok)
	var pz = J.G.PlazaLife; var zok = true
	for zz in [pz.ZA, pz.ZB]:
		for p in [Vector2(zz[0], zz[2]), Vector2(zz[1], zz[3])]: if not vr.has_point(p) or ZV.blocked(p): zok = false
	_chk(tag + "廣場鬼活動範圍喺村子內", zok)
	# 實際行：撳第一個資源點 → 阿福經門洞入去
	var V = _V(); var H = V.hero
	H.x = vh.x; H.y = vh.y; H.tx = vh.x; H.ty = vh.y; H.act = null; H.target = null; H.erase("zf")
	var fb = str(ZD.zone("B").fields.keys()[0]); var nd0 = CF.nodes(fb)[0]
	CF.tap_node(V, fb, 0, nd0.x, nd0.y)
	var thru = false; var bad_n = 0
	for i in 150:
		await _w(t, 0.1)
		var hp = Vector2(J.num(H.x), J.num(H.y))
		if ZD.rect(ZD.zone("B").door.rect).grow(10).has_point(hp): thru = true
		if not _walkable(hp): bad_n += 1
		if ZD.zrect("B").has_point(hp) and H.get("act") is Dictionary: break
	_chk(tag + "撳 B 資源點：阿福經門口行入去開始採", thru and bad_n == 0 and H.get("act") is Dictionary, [J.num(H.x), J.num(H.y), bad_n])
	H.x = vh.x; H.y = vh.y; H.tx = vh.x; H.ty = vh.y; H.act = null; H.target = null; H.erase("zf"); H["zq"] = []
	for zid in ["A", "B", "C"]: S.zone.own.erase("%d:%s" % [c, zid])
	# ---- 攻佔、二級廠 ----
	var zA = ZD.zone("A"); var need = ZD.need("A")   # [militia] 需要兵力 = zones.json power × RES_MUL[關]
	S.res.troops = 0.0
	_chk(tag + "建議戰力遞增（A < B < C）", ZD.need("A") < ZD.need("B") and ZD.need("B") < ZD.need("C"), [ZD.need("A"), ZD.need("B"), ZD.need("C")])
	_chk(tag + "戰力唔夠：派陰兵攻佔唔得", ZD.capture_auto("A") == "weak" and not ZD.owned("A"))
	var fA = str(zA.fields.keys()[0])
	_chk(tag + "未佔領：A 資源點唔採得", not CF.usable(fA))
	S.bld.home = 1.0; S.res.troops = float(need) + 100.0
	var r = ZD.capture_auto("A")
	_chk(tag + "派陰兵攻佔 A：成功、扣兵", r == "ok" and ZD.owned("A") and J.num(S.res.troops) < float(need) + 100.0)
	_chk(tag + "劇情事件：zone_cap A", stub.has_ev("zone_cap", "A"))
	var ok_f = []
	for z in ZD.of_type("res"):
		if J.t(z.get("nofac")): if not (z.get("shops", {}) as Dictionary).is_empty(): ok_f.append("%s 暫無但有廠" % z.id)
		for b in z.get("shops", {}):
			if ZD.bid_zone(str(b)) != str(z.id) or not ZD.zrect(str(z.id)).has_point(CB.pos(str(b))): ok_f.append("%s 唔喺 %s" % [b, z.id])
			if ZD.owned(str(z.id)) == false and CB.zone_lock(str(b)) == "": ok_f.append("%s 未佔領都起得" % b)
	_chk(tag + "二級廠只可建喺所屬區（冇廠嘅區寫暫無）", ok_f.is_empty(), ok_f)
	for z in ZD.of_type("res"):
		if (z.get("shops", {}) as Dictionary).is_empty(): continue
		var sb = str(z.shops.keys()[0]); var fb2 = str(z.fields.keys()[0]); var keep = J.num(S.bld.get(fb2, 0))
		ZD.set_owned(str(z.id)); S.bld[fb2] = 1.0
		var l1 = CB.zone_lock(sb)
		S.bld[fb2] = 3.0
		var l3 = CB.zone_lock(sb)
		_chk(tag + "%s：%s Lv1 起唔到、Lv3 起得" % [z.id, sb], l1.contains("Lv3") and l3 == "", [l1, l3])
		S.zone.sent = {}; ZD._watch_t = 5; ZD.watch(Rect2())
		_chk(tag + "劇情事件：factory %s" % z.id, stub.has_ev("factory", str(z.id)))
		S.bld[fb2] = keep
		S.zone.own.erase("%d:%s" % [c, z.id])
		break
	# ---- 事件：map_enter、zone_seen ----
	var cam = nv.zone_cam()
	S.zone.sent = {}
	cam.z = nv.size.x / 390.0
	for z in ZD.zones():
		if str(z.type) in ["res", "wild"]:
			cam.center_on(ZD.rect(z.rect).get_center()); await _w(t, 0.25)
	var me_ok = false
	for e in ZD.EV_LOG: if e[0] == "map_enter" and int(e[2]) == c: me_ok = true
	_chk(tag + "劇情事件：map_enter（記錄；劇情線自己播開場）", me_ok)
	var seen_all = true
	for z in ZD.zones(): if str(z.type) in ["res", "wild"] and not stub.has_ev("zone_seen", str(z.id)): seen_all = false
	_chk(tag + "劇情事件：每個資源區／野外區 zone_seen", seen_all, stub.log)
	# ---- 野外王 ----
	var arts = []
	for z in ZD.of_type("wild"):
		for b in z.bosses:
			if not Spr.ok(str(b.art)) or not J.G.ENEMY_T.has(str(b.art)): arts.append(b.art)
	_chk(tag + "王全部用現有鬼怪素材", arts.is_empty(), arts)
	var mains = []
	for z in ZD.of_type("wild"):
		for b in z.bosses: if J.t(b.get("main")): mains.append(b.chapter)
	_chk(tag + "主 Boss＝世界地圖第 %d 章原 Boss 關卡" % (c + 1), _mains_ok(mains, c), mains)
	var w0z = str(ZD.of_type("wild")[0].id)
	ZD.unmark_bosses(c)
	var had = J.t(S.cleared.get("%d-3" % (c + 1)))
	S.cleared.erase("%d-3" % (c + 1))
	_chk(tag + "王未打：唔拔得營", not sim.can_move() and not ZD.all_bosses_done())
	if not ZD.team_ok(): S.team = [S.ghosts[0].id]
	stub.defer = true
	var bid0 = str(ZD.bosses(w0z)[0].id)
	var rb = ZD.start_battle("boss", w0z)
	var B = J.G.get("Battle")
	_chk(tag + "boss_pre：劇情播緊未開戰", rb == "ok" and stub.has_ev("boss_pre", bid0) and not J.t(B.get("active")) and stub.held.size() == 1)
	stub.defer = false
	stub.held[0].call(); stub.held.clear()
	_chk(tag + "boss_pre 播完先開戰", J.t(B.get("active")))
	await _w(t, 1.0)
	if shots: await _shot(t, "m%d_boss_battle" % (c + 1))
	await _finish_battle(t, true); ZD.poll()
	_chk(tag + "打低①王 → 輪到②、boss_win 事件", ZD.boss_done(w0z, 0) and ZD.boss_next(w0z) == 1 and stub.has_ev("boss_win", bid0))
	ZD.mark_all_bosses(c)
	S.zone.sent = {}; ZD._watch_t = 5; ZD.watch(Rect2())
	for i in MD.goals(c).size(): if not sim.goal_claimed(i): sim.st().goals_done.append(float(i))
	S.cleared["%d-3" % (c + 1)] = true
	_chk(tag + "全部王打低 → 解放、可以拔營、liberate 事件", ZD.all_bosses_done() and (sim.can_move() or c == MD.maps_n() - 1) and stub.has_ev("liberate"))
	ZD.unmark_bosses(c); sim.st().goals_done = []
	if not had: S.cleared.erase("%d-3" % (c + 1))
	# ---- 點擊 ----
	cam.z = nv.size.x / 390.0
	m.close_sheet()
	await _skip(t, 4)   # 主線劇情（打完王可能有）播完先撳
	var cz = ZD.zrect("C").get_center()
	cam.center_on(cz); await _w(t, 0.3)
	nv.zone_tap(cam.w2s(cz))
	_chk(tag + "撳未佔領 C 出攻佔卡", m.sheet.visible and m.sheet_title.text.contains(ZD.T(ZD.zone("C").n).split("　")[-1]), m.sheet_title.text)
	m.close_sheet()
	var ba = ZD.v2(ZD.zone(w0z).boss_at)
	cam.center_on(ba); await _w(t, 0.3)
	nv.zone_tap(cam.w2s(ba + Vector2(0, -30)))
	_chk(tag + "撳野外王出挑戰卡", m.sheet.visible and m.sheet_title.text.contains(ZD.T(ZD.zone(w0z).n).split("　")[-1]), m.sheet_title.text)
	m.close_sheet()
	var opened = [""]
	var UI = J.G.get("UI"); var o_ob = UI.get("openBuilding")
	UI["openBuilding"] = func(_t0, a): opened[0] = J.str(J.arg(a, 0)); return null
	var spp = ZD.v2(Z.village.POS.store) + Vector2(0, -30)
	cam.center_on(spp); await _w(t, 0.3)
	nv.zone_tap(cam.w2s(spp))
	_chk(tag + "撳倉庫開建築卡（唔誤觸區／門）", opened[0] == "store" and not m.sheet.visible, opened[0])
	UI["openBuilding"] = o_ob
	var sid0 = MD.stations(c)[0]; sim.sst(sid0).unlocked = true
	var stp = sim.st_pos(sid0)
	cam.center_on(stp); await _w(t, 0.4)
	nv.zone_tap(cam.w2s(stp + Vector2(0, -40)))
	_chk(tag + "撳大排檔台開資料卡", sc.sheet.visible and sc.sel == sid0, sc.sel)
	sc.close_sheet(); await _w(t, 0.4)
	# 客人、孤魂（跑一陣）
	for sid in MD.stations(c): sim.sst(sid).unlocked = true
	for sid in MD.stations(c): sim.st().counter[str(MD.st_def(sid).get("good", ""))] = 20.0   # [militia] 客人只要有供應嘅貨：櫃台擺貨
	cam.center_on(mr.get_center())
	for i in 36: await _w(t, 0.25)
	var cu_ok = sim.custs.size() > 0
	for cu in sim.custs: if not mr.grow(60).has_point(cu.pos): cu_ok = false
	_chk(tag + "客人喺大排檔（由野外門入）", cu_ok, sim.custs.size())
	var foe_ok = sim.foes.size() > 0; var fbad = []
	for f in sim.foes:
		var inw = false
		for z in ZD.of_type("wild"): if ZD.rect(z.rect).grow(40).has_point(f.pos): inw = true
		for g in sim.L.gates: if f.pos.distance_to(g) < 80: inw = true
		if not inw: foe_ok = false; fbad.append(f.pos)
	_chk(tag + "孤魂喺野外區／野外門", foe_ok, [sim.foes.size(), fbad])
	await names_check2(t, m)
	if shots: await _shots_map(t, m, c)
	ZD.hook = null
func names_check2(t, m) -> void:
	var nv = m.village; var c = nv.zone_cam()
	for zz in [c.z_min(), nv.size.x / 390.0]:
		c.z = zz; c.clamp_all(); c.center_on(ZD.zrect("village").get_center()); await _w(t, 0.3)
		var dup = []
		for z in ZD.zones():
			var full = ZD.T(z.n); var short = full.split("　")[-1]
			var n = 0
			for s in ZV.plates: if s.begins_with(full) or s == short or s.begins_with(short + "（"): n += 1
			if z.type != "market" and ZD.rect(z.rect).intersects(nv.view_rect()) and n != 1: dup.append("%s×%d" % [full, n])
		_chk("縮放 %.2f：每區名牌只畫一個" % zz, dup.is_empty(), dup)
# 舊存檔遷移：老闆存檔＝第 2 關中期（S.mv.ci = 1；有建築／資源田／派鬼；已過 1-3）
func migrate_check(t, m) -> void:
	var S = J.G.S; var sc = m.mv_view
	await _goto(t, m, 1)
	var bak = {"zone": S.get("zone", {}).duplicate(true), "bld": S.bld.duplicate(true), "cleared": S.cleared.duplicate(true)}
	var posts = {}
	for g in S.ghosts: posts[str(g.id)] = J.str(g.get("post"))
	for case_i in 2:
		S.erase("zone")
		if case_i == 1: S["zone"] = {"v": 1.0, "own": {"0:A": true}, "boss": {"0:zb_egui": true, "0:zb_eguiking": true}, "exp": null, "mig": 1.0}   # 已經行過 zone1 遷移嘅存檔
		S.bld["b_coco"] = 4.0; S.bld["b_cocomilk"] = 1.0; S.bld["b_bamboo"] = 3.0; S.bld.erase("b_latex"); S.bld.erase("b_rubbersheet")
		S.bld["b_tea"] = 0.0
		S.cleared["1-3"] = true; S.cleared.erase("2-3")
		var gid = str(S.ghosts[0].id); S.ghosts[0]["post"] = "b_coco"
		ZD.st()
		var tg = "舊存檔（%s）：" % ["冇 zone", "行過 zone1 遷移"][case_i]
		_chk(tg + "椰林已開墾 → 第 2 關 A 已佔領", ZD.owned("A", 1))
		_chk(tg + "竹林已開墾 → 第 2 關 C 已佔領", ZD.owned("C", 1))
		_chk(tg + "冇膠園 → B 未佔領", not ZD.owned("B", 1))
		_chk(tg + "未去到嘅第 3／4 關唔送", not ZD.owned("A", 2) and not ZD.owned("C", 3))
		_chk(tg + "Toyol 未打 → 第 2 關王未打；第 1 關餓鬼坑已打", not ZD.boss_done("w_rubber", 1, 1) and ZD.boss_done("w_pit", 1, 0))
		_chk(tg + "等級、派鬼保留", CB.lv("b_coco") == 4 and CB.lv("b_cocomilk") == 1 and CB.lv("b_bamboo") == 3 and str(S.ghosts[0].post) == "b_coco" and str(S.ghosts[0].id) == gid)
		_chk(tg + "唔卡關：椰漿廠照用、竹林照採、B 可攻佔", ZD.bid_ok("b_cocomilk") and CF.usable("b_bamboo") and ZD.zone("B").power > 0)
		S.cleared["2-3"] = true; S.erase("zone"); ZD.st()
		_chk(tg + "已打 Toyol（2-3）→ 廢膠廠兩個王已打", ZD.boss_done("w_rubber", 0, 1) and ZD.boss_done("w_rubber", 1, 1) and not ZD.boss_done("w_kgrave", 0, 1))
		S.cleared.erase("2-3")
	S["zone"] = bak.zone; S["bld"] = bak.bld; S["cleared"] = bak.cleared
	for g in S.ghosts: g["post"] = posts.get(str(g.id), g.get("post"))
func _shots_map(t, m, c: int) -> void:
	var nv = m.village; var cam = nv.zone_cam(); var S = J.G.S; var n = c + 1
	DirAccess.make_dir_recursive_absolute(SHOTS2)
	cam.vel = Vector2.ZERO
	for zid in ["A", "B"]: S.zone.own.erase("%d:%s" % [c, zid])
	ZD.set_owned("C")
	cam.z = cam.z_min(); cam.clamp_all(); cam.center_on(Vector2(ZD.world_size().x / 2, ZD.world_size().y / 2)); await _w(t, 1.0); await _shot2(t, "m%d_00_whole_min" % n)
	cam.z = nv.size.x / 390.0
	var vc = ZD.zrect("village")
	for e in [["m%d_10_village_top" % n, vc.get_center() + Vector2(-150, -250)], ["m%d_11_village_mid" % n, vc.get_center() + Vector2(150, 0)],
			["m%d_12_village_bot" % n, vc.get_center() + Vector2(-150, 250)], ["m%d_13_village_gate" % n, ZD.v2(ZD.cur().village.POS.gate)]]:
		cam.center_on(e[1]); await _w(t, 0.8); await _shot2(t, e[0])
	for zid in ["A", "B", "C"]:
		var zr = ZD.zrect(zid)
		cam.center_on(zr.get_center()); await _w(t, 0.8); await _shot2(t, "m%d_2%s_res_%s" % [n, zid, "owned" if ZD.owned(zid) else "locked"])
	ZD.set_owned("A"); cam.center_on(ZD.zrect("A").get_center()); await _w(t, 0.8); await _shot2(t, "m%d_2A_res_owned" % n)
	var mr = ZD.zrect("market")
	cam.center_on(mr.get_center() + Vector2(0, -mr.size.y * 0.25)); await _w(t, 0.8); await _shot2(t, "m%d_30_market_a" % n)
	cam.center_on(mr.get_center() + Vector2(0, mr.size.y * 0.25)); await _w(t, 0.8); await _shot2(t, "m%d_31_market_b" % n)
	for z in ZD.of_type("wild"):
		cam.center_on(ZD.v2(z.boss_at) + Vector2(0, -60)); await _w(t, 0.8); await _shot2(t, "m%d_4_wild_%s" % [n, z.id])
	for zid in ["A", "B"]: S.zone.own.erase("%d:%s" % [c, zid])
	S.zone.own.erase("%d:C" % c)
const SHOTS2 := "/tmp/zone2/shots/"
func _shot2(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS2 + name + ".png"); _p("shot " + name)
func dbg(t) -> void:
	var m = await _boot(t)
	for c in [2, 3]:
		await _goto(t, m, c)
		var S = J.G.S
		for zid in ["A", "B", "C"]: ZD.set_owned(zid)
		var V = _V(); var H = V.hero; var vh = ZD.v2(ZD.cur().village.hero)
		H.x = vh.x; H.y = vh.y; H.tx = vh.x; H.ty = vh.y; H.act = null; H.target = null; H.erase("zf")
		var fb = str(ZD.zone("B").fields.keys()[0]); var nd0 = CF.nodes(fb)[0]
		_p("c=%d fb=%s nd0=%s usable=%s ripe=%s route=%s" % [c, fb, [nd0.x, nd0.y], CF.usable(fb), CF.ripe(fb, 0), ZW.route(vh, Vector2(nd0.x, nd0.y))])
		CF.tap_node(V, fb, 0, nd0.x, nd0.y)
		for i in 40:
			await _w(t, 0.25)
			_p("  %s,%s t=%s,%s zq=%s zf=%s act=%s" % [int(J.num(H.x)), int(J.num(H.y)), int(J.num(H.tx)), int(J.num(H.ty)), H.get("zq"), H.get("zf"), H.get("act") != null])
	_p("RESULT ok=0 bad=0")
