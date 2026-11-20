# [village2] 村子線 2：一級資源點（親手採／派鬼自動採／再生／舊存檔遷移）、柵欄、地面無縫、稻田／出村門暗塊
# 用法：/home/claude/setup/edtest.sh godot v2 res://tools/tests/village2_test.gd logic|all|shots
#   logic：邏輯（唔截圖）
#   shots：截圖（完整長圖＋稻田＋出村門柵欄＋親手採／自動採連續幀），輸出 /tmp/v2/shots/
#   all：logic ＋ shots
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const CB = preload("res://game/outpost/chain_bld.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const CF = preload("res://game/outpost/chain_field.gd")
const VF = preload("res://game/village_fence.gd")
const SHOTS := "/tmp/v2/shots/"
var ok := 0
var bad := 0

func _p(m): print("[v2] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _img(t) -> Image:
	await RenderingServer.frame_post_draw
	return t.get_viewport().get_texture().get_image()
func _shot(t, name: String):
	var im = await _img(t)
	im.save_png(SHOTS + name + ".png"); _p("shot " + name)
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
func _calm(t, fade := true):
	for i in 40:
		var m = _main(t); var st = m.get("story") if m else null
		if st == null or not st.busy(): break
		if st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
	if fade: await _w(t, 3.4)
func _V(): return J.G.get("Village")
func _cam(y: float) -> void: J.mc(_V(), "setCam", [y])
func _camY() -> float: return J.num(_V().get("camY"))
func N(): return J.gp(J.G.get("UI"), "_n")

func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.6)
	CB.install()
	return m

# 完整長圖：鏡頭由最頂（柵欄外）拖到最底（拓展區底），每次截村子畫面中間一段，拼成一張
func long_shot(t, m, name: String) -> Image:
	var vr0: Rect2 = m.village.get_global_rect()
	var vh = vr0.size.y / (vr0.size.x / 390.0)
	var f = 450.0 / t.get_viewport().get_visible_rect().size.x   # 畫布座標 → 截圖像素（視窗 450 闊，有拉伸）
	var vr = Rect2(vr0.position * f, vr0.size * f)
	var k = vr.size.x / 390.0
	var top = -m.mv_embed.eh() - m.mv_embed.top_extra() if m.mv_embed != null else 0.0
	var bot = maxf(1130.0, CB.world_h()) - vh
	var band0 = vh * 0.30; var band1 = vh * 0.70   # 每張只要中間一段（避開 HUD、任務條）
	var cbtn = m.find_child("ChainBtn", true, false)   # 浮喺畫面嘅掣：長圖收埋（唔好每段都出）
	if cbtn: cbtn.modulate.a = 0.0
	var total_h = int(ceil((bot + vh - top) * k))
	var out = Image.create(int(vr.size.x), total_h, false, Image.FORMAT_RGB8)
	out.fill(Color(1, 0, 1))
	var cy = top
	var first = true
	while true:
		_cam(cy); await _w(t, 0.25)
		var real = _camY()
		var im = await _img(t)
		im.convert(Image.FORMAT_RGB8)
		var a = 0.0 if first else band0
		var b = vh if real >= bot - 0.5 else band1
		var src = Rect2i(int(vr.position.x), int(vr.position.y + a * k), int(vr.size.x), mini(int((b - a) * k) + 3, int(vr.end.y - (vr.position.y + a * k))))
		out.blit_rect(im, src, Vector2i(0, int((real - top + a) * k)))
		first = false
		if real >= bot - 0.5: break
		cy = real + (band1 - band0)
	if cbtn: cbtn.modulate.a = 1.0
	out.save_png(SHOTS + name + ".png"); _p("long shot %s %dx%d" % [name, out.get_width(), out.get_height()])
	return out

func _ghost() -> Dictionary: return J.cl(J.G.get("recruitFodder"), null, [false])
func _setup_fields(ci: int, workers := true) -> void:
	var S = J.G.S
	S.mv["ci"] = float(ci)
	S.bld["house"] = 10.0
	for b in CB.CF.fields():
		if CB.unlocked(b) and CB.lv(b) == 0: S.bld[b] = 2.0
		if workers and CB.lv(b) > 0 and CB.workers(b).is_empty():
			var g = _ghost(); J.mc(N(), "pickDo", [b, g.id])
	for b in CB.new_blds():
		if not CB.CF.is_field(b) and CB.unlocked(b) and CB.lv(b) == 0: S.bld[b] = 1.0
	_close()
func _close() -> void:
	Menus.close_hook()
	var m = J.G.get("UI")
	var mm = Engine.get_main_loop().root.get_node_or_null("Main")
	if mm and mm.has_method("close_sheet"): mm.close_sheet()
func _near(V, x: float, y: float) -> void:   # 截圖用：阿福先企近啲（唔使行成條村）
	V.hero["x"] = x + 60.0; V.hero["y"] = y + 30.0; V.hero["tx"] = x + 60.0; V.hero["ty"] = y + 30.0

func quick(t) -> void:
	var m = await _boot(t)
	_setup_fields(5)
	CB.CF.st("b_bamboo").hp[1] = 0.0; CB.CF.st("b_bamboo").rg[1] = 12.0
	CB.CF.st("b_well").hp[0] = 0.0; CB.CF.st("b_well").rg[0] = 12.0
	await _calm(t)
	var i = 0
	for cy in [1100.0, 1450.0, 1800.0, 2150.0, 2500.0]:
		_cam(cy); await _w(t, 1.2); await _shot(t, "q_%d" % i); i += 1
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func shots0(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	S.mv["ci"] = 2.0
	await _calm(t)
	_p("viewport %s village %s" % [t.get_viewport().get_texture().get_image().get_size(), m.village.get_global_rect()])
	_cam(-220.0); await _w(t, 1.0); await _shot(t, "q_gate")
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# 重烘地面：村子（780×2260）＋拓展區（780×3200，ext 模式，世界 y 1130 起）
func bake(t) -> void:
	await _wait_boot(t)
	for which in ["main", "ext"]:
		var hh = 1130.0 if which == "main" else 1600.0
		var vp = SubViewport.new()
		vp.size = Vector2i(780, int(hh * 2)); vp.transparent_bg = false
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		var painter = Node2D.new(); painter.set_script(load("res://game/ground_painter.gd"))
		var P = {}
		for k in J.G.POS: P[k] = [J.num(J.G.POS[k][0]), J.num(J.G.POS[k][1])]
		painter.set("POS", P)
		if which == "ext":
			painter.set("ext", true); painter.set("HH", hh); painter.set("Y0", 1130.0)
			painter.set("join_tex", ImageTexture.create_from_image(Image.load_from_file(ProjectSettings.globalize_path("res://assets/img/village_ground.webp"))))
		vp.add_child(painter); t.get_tree().root.add_child(vp)
		for i in 8: await RenderingServer.frame_post_draw
		var img = vp.get_texture().get_image()
		var path = ProjectSettings.globalize_path("res://assets/img/village_ground%s.webp" % ("" if which == "main" else "_ext"))
		img.save_webp(path, false, 0.9)
		_p("baked %s %s" % [path, img.get_size()])
		vp.queue_free()
	_p("RESULT ok=1 bad=0")

# ================= 邏輯 =================
func all(t) -> void:
	await logic(t, false)
	await shots(t, true)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _hero_go(t, V, secs := 8.0) -> void:   # 等阿福行到、做完
	var t0 = Time.get_ticks_msec()
	while Time.get_ticks_msec() - t0 < secs * 1000.0:
		await _w(t, 0.1)
		var H = V.hero
		if H.get("act") == null and H.get("target") == null and not J.t(H.get("walking")): break

func logic(t, report := true) -> void:
	var m = await _boot(t)
	var S = J.G.S; var V = _V()
	await _calm(t, false)
	# ---------- 資料 ----------
	var fs = CF.fields()
	var want = []
	for b in M.D().GATHER: if str(M.D().GATHER[b].get("old", "")) == "": want.append(str(b))
	_chk("資源田＝chain.json 全部新 T1 採集（%d 個）" % want.size(), fs.size() == want.size() and want.size() == 10, fs)
	var shops = []
	for b in CB.new_blds(): if not CF.is_field(b): shops.append(b)
	_chk("T2 加工建築維持建築（7 間）", shops.size() == 7 and shops.all(func(b): return CB.kind(b) == "shop"), shops)
	var ncfg = true; var cnt = {}
	for b in fs:
		if not CF.NODE.has(b): ncfg = false
		cnt[b] = CF.nodes(b).size()
		if CF.nodes(b).size() != int(CF.cfg(b).n): ncfg = false
	_chk("每個資源田都有資源點樣式、點數啱", ncfg, cnt)
	# ---------- 擺位 ----------
	S.mv["ci"] = 5.0
	var in_b = true; var on_road = []; var ov = []; var rects = []
	for b in fs:
		for nd in CF.nodes(b):
			var r = CF.node_rect(b, nd)
			if r.position.x < 0 or r.end.x > 390 or r.position.y < CB.FENCE_Y: in_b = false
			if float(nd.x) > 156 and float(nd.x) < 236: on_road.append(b)
			rects.append([b, r.grow(-6)])
		rects.append(["牌" + b, CF.sign_rect(b).grow(-4)])
	for b in shops:
		var p = CB.pos(b); rects.append([b, Rect2(p.x - 50, p.y - 92, 100, 120)])
	for i in rects.size():
		for j in range(i + 1, rects.size()):
			if str(rects[i][0]).substr(0, 6) == str(rects[j][0]).substr(0, 6): continue
			if rects[i][1].intersects(rects[j][1]): ov.append("%s×%s" % [rects[i][0], rects[j][0]])
	_chk("資源點喺拓展區、390 闊內", in_b)
	_chk("資源點唔踩石板路", on_road.is_empty(), on_road)
	_chk("資源田／名牌／加工建築互相唔疊", ov.is_empty(), ov)
	var irr = 0; var tot = 0
	for b in fs:
		var ns = CF.nodes(b); var my = 0.0; var mx = 0.0
		for nd in ns: my += float(nd.y) / ns.size(); mx += float(nd.x) / ns.size()
		var sy = 0.0; var sx = 0.0
		for nd in ns: sy += pow(float(nd.y) - my, 2) / ns.size(); sx += pow(float(nd.x) - mx, 2) / ns.size()
		tot += 1
		if sqrt(sy) > 6.0 and sqrt(sx) > 15.0: irr += 1
	_chk("資源點唔排到好整齊（每塊田 x、y 都散）", irr == tot, "%d/%d" % [irr, tot])
	_chk("世界加長到最後一個", CB.world_h() >= CF.anchor("b_ink").y + 60, CB.world_h())
	# ---------- 親手採：斬（竹）----------
	S.mv["ci"] = 0.0
	for g in J.iter(S.ghosts): if J.seq(J.gp(g, "post"), "b_bamboo"): g["post"] = null
	S.bld["b_bamboo"] = 0.0
	var e = CF.st("b_bamboo"); var nd0 = CF.nodes("b_bamboo")[0]
	e.hp[0] = float(CF.hits("b_bamboo")); e.rg[0] = 0.0
	var mid = CF.out_mid("b_bamboo"); M.add(mid, -M.amt(mid))
	_cam(float(nd0.y) - 300.0); _near(V, float(nd0.x), float(nd0.y)); await _w(t, 0.3)
	J.mc(V, "tap", [float(nd0.x), float(nd0.y) - 20.0])
	_chk("撳竹叢 → 阿福行過去", V.hero.get("target") is Dictionary and V.hero.target.get("kind") == "cnode", V.hero.get("target"))
	var ti = int(J.num(V.hero.target.get("i", 0))) if V.hero.get("target") is Dictionary else 0
	if ti != 0: nd0 = CF.nodes("b_bamboo")[ti]
	var ii0 = ti
	var saw_pose = [""]
	var t0 = Time.get_ticks_msec()
	while Time.get_ticks_msec() - t0 < 12000:
		await _w(t, 0.05)
		var hp = J.mc(V, "heroPose", [])
		if hp is Array and hp[0] != null and str(hp[0]) != "proud": saw_pose[0] = str(hp[0])
		if CF.hp("b_bamboo", ii0) <= 0: break
	_chk("親手採有動作（斬）", saw_pose[0] == "chop", saw_pose[0])
	_chk("斬三下採完 → 資源點冇咗", CF.hp("b_bamboo", ii0) == 0)
	_chk("採到料（未開墾都得）", absf(M.amt(mid) - CF.yield_n("b_bamboo")) < 0.01, "%s %.1f" % [mid, M.amt(mid)])
	var ft = false
	for f in V.get("floats", []): if str(f.get("text", "")).contains(M.name(mid)): ft = true
	_chk("彈出數字", ft)
	J.mc(V, "tap", [float(nd0.x), float(nd0.y) - 20.0]); await _w(t, 0.2)
	_chk("未長返撳唔到", V.hero.get("target") == null or V.hero.target.get("kind") != "cnode")
	# ---------- 再生 ----------
	_chk("再生倒數 = %d 秒" % int(CF.REGROW), absf(J.num(e.rg[ii0]) - CF.REGROW) < 1.5, J.num(e.rg[ii0]))
	e.rg[ii0] = 0.6
	await _w(t, 1.2)
	_chk("再生：時間到長返", CF.hp("b_bamboo", ii0) == CF.hits("b_bamboo"))
	# ---------- 親手採：搖（枯井）----------
	var ndw = CF.nodes("b_well")[1]; CF.st("b_well").hp[1] = 1.0; _near(V, float(ndw.x), float(ndw.y))
	var mw = CF.out_mid("b_well"); M.add(mw, -M.amt(mw))
	J.mc(V, "tap", [float(ndw.x), float(ndw.y) - 20.0])
	saw_pose[0] = ""
	t0 = Time.get_ticks_msec()
	while Time.get_ticks_msec() - t0 < 12000:
		await _w(t, 0.05)
		var hp2 = J.mc(V, "heroPose", [])
		if hp2 is Array and hp2[0] != null and str(hp2[0]) != "proud": saw_pose[0] = str(hp2[0])
		if CF.hp("b_well", 1) <= 0: break
	_chk("枯井：吊水動作＋採到", saw_pose[0] == "knead" and M.amt(mw) >= CF.yield_n("b_well") - 0.01, "%s %.1f" % [saw_pose[0], M.amt(mw)])
	# ---------- 冇鬼唔自動 ----------
	var r0 = CE.rates()
	_chk("未開墾、冇鬼 → 冇自動產出", not r0.has("b_bamboo"))
	M.add(mid, -M.amt(mid))
	J.cl(J.G.get("produce"), null, [60.0])
	_chk("冇鬼 produce 一分鐘唔多料", M.amt(mid) < 0.01, M.amt(mid))
	var g1 = _ghost()
	J.mc(N(), "pickDo", ["b_bamboo", g1.id])
	_chk("未開墾派唔到鬼（冇崗位）", g1.get("post") == null)
	# 開墾
	for k in CB.build_cost("b_bamboo"): M.add(k, J.num(CB.build_cost("b_bamboo")[k]) + 5)
	var card = J.mc(N(), "bld", ["b_bamboo"])
	_chk("資源田卡：開墾掣、寫住親手採", J.str(card.get("buildLbl")) == CB.L("開墾", "開墾") and J.str(card.desc).contains(CB.L("親手", "親手")), J.str(card.desc).substr(0, 60))
	J.mc(N(), "bldAct", ["b_bamboo", "build", null])
	_chk("開墾 → Lv1", CB.lv("b_bamboo") == 1)
	J.cl(J.G.get("produce"), null, [60.0])
	_chk("開墾咗但冇派鬼 → 都冇自動產出", M.amt(mid) < 0.01)
	J.mc(N(), "pickDo", ["b_bamboo", g1.id])
	_chk("派鬼", J.seq(g1.get("post"), "b_bamboo"))
	var rr = J.num(CE.rates().get("b_bamboo", {}).get("out", {}).get(mid, 0))
	var expect = CE.worker_f(g1, "b_bamboo") * J.num(M.bld("b_bamboo").rate)
	_chk("自動速度 = 鬼對應能力值 ÷ 30 × 基本產量", rr > 0 and absf(rr - expect) < 0.01, "%.2f／%.2f（%s）" % [rr, expect, ["力", "智", "武"][CE.stat_i("b_bamboo")]])
	J.cl(J.G.get("produce"), null, [60.0])
	_chk("派鬼 produce 一分鐘入倉", absf(M.amt(mid) - rr) < 0.05 * rr + 0.01, "%.2f" % M.amt(mid))
	var ws = CB.worker_spots().filter(func(w): return str(w.post) == "b_bamboo")
	var near = ws.size() == 1
	for w in ws:
		var dmin = 1e9
		for nd in CF.nodes("b_bamboo"): dmin = minf(dmin, Vector2(w.x, w.y).distance_to(Vector2(nd.x, nd.y)))
		near = near and dmin < 34.0
	_chk("自動採：鬼企喺資源點旁邊", near, ws.size())
	V["floats"] = []
	CF.acc["b_bamboo"] = 0.0
	for i in 12: CF.tick(1.0)
	var pop = false
	for f in V.get("floats", []): if str(f.get("text", "")).contains(M.name(mid) + " +"): pop = true
	_chk("自動採：資源點彈「+n」", pop)
	# 親手採永遠得（派咗鬼都得）
	e.hp[2] = float(CF.hits("b_bamboo"))
	var before = M.amt(mid); var nd2 = CF.nodes("b_bamboo")[2]
	_near(V, float(nd2.x), float(nd2.y)); await _w(t, 0.1)
	J.mc(V, "tap", [float(nd2.x), float(nd2.y) - 20.0]); await _hero_go(t, V, 12.0)
	_chk("派咗鬼都可以親手採", M.amt(mid) >= before + CF.yield_n("b_bamboo") - 0.01, "%.1f→%.1f" % [before, M.amt(mid)])
	# 未解鎖嘅田（下一張圖）
	var nb = ""
	for b in fs: if CF.CE.need_ci(b) == 1: nb = b
	var ndl = CF.nodes(nb)[0]
	J.mc(V, "tap", [float(ndl.x), float(ndl.y) - 20.0]); await _w(t, 0.2)
	_chk("下一張圖嘅田：撳唔採（預告）", not (V.hero.get("target") is Dictionary and V.hero.target.get("kind") == "cnode"), nb)
	# 撳田名牌開卡
	var spn = CF.sign_pos("b_bamboo")
	var bo = [""]; var UI = J.G.get("UI"); var o_ob = UI.get("openBuilding")
	UI["openBuilding"] = func(_t, a): bo[0] = J.str(J.arg(a, 0)); return null
	J.mc(V, "tap", [spn.x, spn.y - 30.0]); await _w(t, 0.2)
	UI["openBuilding"] = o_ob
	_chk("撳田名牌開資源田卡", bo[0] == "b_bamboo", bo[0])
	# T2 加工建築照舊（撳開卡）
	var pp = CB.pos("b_paper"); bo[0] = ""
	UI["openBuilding"] = func(_t, a): bo[0] = J.str(J.arg(a, 0)); return null
	J.mc(V, "tap", [pp.x, pp.y - 40.0]); await _w(t, 0.2)
	UI["openBuilding"] = o_ob
	_chk("T2 加工建築撳開建築卡（形式不變）", bo[0] == "b_paper", bo[0])
	# ---------- 柵欄 ----------
	_chk("柵欄擋：門外 → 村子（唔經門口）", VF.blocks(Vector2(60, 60), Vector2(60, 300)) and VF.blocks(Vector2(330, 200), Vector2(300, 20)))
	_chk("柵欄唔擋：經門口", not VF.blocks(Vector2(195, 40), Vector2(195, 300)))
	var segs = VF.segments(); var cov = true
	for x in range(0, 391, 2):
		if VF.in_gap(float(x)): continue
		var hit = false
		for sg in segs: if absf(float(x) - float(sg[0])) <= float(sg[1]) / 2.0 + 0.5: hit = true
		if not hit and not (x > VF.SPAN_L[1] and x < VF.SPAN_R[0]): cov = false
	_chk("柵欄由左邊去到右邊（門柱之間係門樓）", cov and VF.SPAN_L[0] <= 0.0 and VF.SPAN_R[1] >= 390.0)
	J.mc(V, "walkTo", [60.0, 40.0, null])
	_chk("阿福行唔出柵欄", J.num(V.hero.ty) >= VF.Y + 20, J.num(V.hero.ty))
	var em = m.mv_embed; var E = em.eh()
	var P = em._path(); var cross_ok = true
	for i in range(1, P.size()):
		var a = P[i - 1] - Vector2(0, E); var b2 = P[i] - Vector2(0, E)
		if VF.blocks(a, b2): cross_ok = false
	_chk("挑夫鬼路線經門口", cross_ok)
	# 實際跑一陣：所有會行嘅嘢（阿福、廣場鬼、挑夫、客人）唔穿柵欄
	for sid in load("res://game/outpost/mv_data.gd").stations(em.sc.sim.ci()): em.sc.sim.sst(sid).unlocked = true
	M.add("m_bao", 50); em._pt = 0.0
	var last = {}; var viol = []; var wrong = []
	_cam(-200.0)
	for k in 90:
		await _w(t, 0.12)
		var cur = {}
		cur["hero"] = Vector2(J.num(V.hero.x), J.num(V.hero.y))
		var vi = 0
		for o in V.get("vis", []):
			if J.t(o.get("hero")): continue
			cur["v%d_%s" % [vi, str(J.gp(o.get("g"), "id"))]] = Vector2(J.num(o.x), J.num(o.y)); vi += 1
		var pi = 0
		for p2 in em.porters: cur["p%d" % pi] = em.porter_pos(p2) - Vector2(0, E); pi += 1
		var ci2 = 0
		for cu in em.sc.sim.custs: cur["c%d" % ci2] = Vector2(cu.pos) - Vector2(0, E); ci2 += 1
		for key in cur:
			if last.has(key) and last[key].distance_to(cur[key]) < 40 and VF.blocks(last[key], cur[key]): viol.append(key)
			if str(key).begins_with("c") and cur[key].y > VF.Y: wrong.append(key)
			if (key == "hero" or str(key).begins_with("v")) and cur[key].y < VF.Y: wrong.append(key)
		last = cur
	_chk("跑 11 秒：冇嘢穿柵欄（客 %d、挑夫 %d）" % [em.sc.sim.custs.size(), em.porters.size()], viol.is_empty(), viol)
	_chk("村子嘅鬼喺柵欄內、客人喺柵欄外", wrong.is_empty(), wrong.slice(0, 5))
	# ---------- 地面冇黑區 ----------
	var gimg = m.village.ground_tex.get_image()
	var lum = func(img: Image, r: Rect2i) -> float:
		var acc2 = 0.0; var n = 0
		for yy in range(r.position.y, r.end.y, 3):
			for xx in range(r.position.x, r.end.x, 3):
				var c = img.get_pixel(xx, yy); acc2 += c.get_luminance(); n += 1
		return acc2 / maxf(1, n)
	var k2 = gimg.get_height() / 1130.0
	var top_l = lum.call(gimg, Rect2i(0, 0, gimg.get_width(), int(150 * k2)))
	var mid_l = lum.call(gimg, Rect2i(0, int(600 * k2), gimg.get_width(), int(300 * k2)))
	var pad_l = lum.call(gimg, Rect2i(int(230 * k2), int(395 * k2), int(140 * k2), int(130 * k2)))
	var side_l = lum.call(gimg, Rect2i(int(230 * k2), int(560 * k2), int(140 * k2), int(130 * k2)))
	_chk("地面：出村門前一段唔再暗（同村中相若）", top_l > mid_l * 0.85, "%.3f／%.3f" % [top_l, mid_l])
	_chk("地面：稻田區唔再一整塊深色", pad_l > side_l * 0.8, "%.3f／%.3f" % [pad_l, side_l])
	var ext = m.village.ext_tex
	_chk("拓展區用同一套地面（預烘圖）", ext != null)
	if ext != null:
		var ei = ext.get_image(); var ke = ei.get_height() / 1600.0
		var row_d = func(a: Image, ya: int, b: Image, yb: int) -> float:
			var d = 0.0
			for xx in range(0, 300, 2): d += absf(a.get_pixel(xx, ya).get_luminance() - b.get_pixel(xx, yb).get_luminance())
			return d / 150.0
		var seam = row_d.call(gimg, gimg.get_height() - 1, ei, 0)
		var normal = row_d.call(ei, 40, ei, 41)
		_chk("拓展區接縫：差異同普通相鄰行一樣", seam < normal * 1.6 + 0.01, "%.4f／%.4f" % [seam, normal])
	# 截圖取樣：各段暗像素比例（luma < 0.07）
	var dark = {}
	var vr0: Rect2 = m.village.get_global_rect(); var f = 450.0 / t.get_viewport().get_visible_rect().size.x
	for pt in [[-160.0, "出村門"], [300.0, "稻田"], [1200.0, "拓展區頂"], [1700.0, "拓展區中"]]:
		_cam(pt[0]); await _w(t, 0.5)
		var im = await _img(t); var n = 0; var d2 = 0
		for yy in range(int((vr0.position.y + vr0.size.y * 0.35) * f), int((vr0.position.y + vr0.size.y * 0.9) * f), 4):
			for xx in range(0, im.get_width(), 4):
				n += 1
				if im.get_pixel(xx, yy).get_luminance() < 0.07: d2 += 1
		dark[pt[1]] = float(d2) / n
	var dk_ok = true
	for kk in dark: if dark[kk] > 0.25: dk_ok = false
	_chk("截圖取樣：冇大片黑區（暗像素 < 25%）", dk_ok, dark)
	# ---------- 舊存檔遷移 ----------
	var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/selftest_save.json"))
	var d = G.dec(str(o.code))
	d.erase("cfield"); d.erase("cfield_v")
	if not (d.get("mv") is Dictionary): d["mv"] = {"ci": 1.0}
	d.mv["ci"] = 1.0
	d.bld["b_coco"] = 3.0; d.bld["b_bamboo"] = 2.0
	d["ghosts"][1]["post"] = "b_coco"
	var gid = str(d["ghosts"][1]["id"])
	if not (d.get("mat") is Dictionary): d["mat"] = {}
	d.mat["m_coconut"] = 77.0
	m.import_save(G.enc(d))
	await _wait_boot(t)
	m = _main(t); S = J.G.S; CB.install(); CF.reset()
	_chk("舊存檔：椰林等級保留 = 資源田 Lv3", CB.lv("b_coco") == 3)
	var kept = false
	for g in J.iter(S.ghosts): if str(g.id) == gid and J.seq(g.get("post"), "b_coco"): kept = true
	_chk("舊存檔：派咗嘅鬼照留喺資源田", kept)
	_chk("舊存檔：材料照留（＋離線產出）", M.amt("m_coconut") >= 77.0 - 0.01, M.amt("m_coconut"))
	_chk("舊存檔：自動產出照有", J.num(CE.rates().get("b_coco", {}).get("out", {}).get("m_coconut", 0)) > 0)
	_chk("舊存檔：資源點全部長好", CF.nodes("b_coco").all(func(nd): return CF.ripe("b_coco", int(nd.i))) and J.num(S.get("cfield_v", 0)) >= 1)
	m._hide_title(); await _w(t, 0.5)
	if report: _p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= 截圖 =================
func shots(t, booted := false) -> void:
	var m = _main(t) if booted else await _boot(t)
	var S = J.G.S; var V = _V()
	_setup_fields(5)
	CF.st("b_bamboo").hp[1] = 0.0; CF.st("b_bamboo").rg[1] = 12.0
	CF.st("b_well").hp[0] = 0.0; CF.st("b_well").rg[0] = 18.0
	CF.st("b_tea").hp[2] = 0.0; CF.st("b_tea").rg[2] = 8.0
	await _calm(t)
	var nb = m.get("prod_btn")
	await long_shot(t, m, "01_long_full")
	m.mv_embed.porters.clear(); m.mv_embed._pt = 999.0
	_cam(-120.0); await _w(t, 1.0); await _shot(t, "02_gate_fence")
	m.mv_embed._pt = 3.0
	_cam(250.0); await _w(t, 1.0); await _shot(t, "03_paddy")
	_cam(1130.0 - 200.0); await _w(t, 1.0); await _shot(t, "04_ext_join")
	# 親手採：竹（斬三下）連續幀
	var nd = CF.nodes("b_bamboo")[3]; CF.st("b_bamboo").hp[3] = 3.0
	for g in J.iter(S.ghosts): if J.seq(J.gp(g, "post"), "b_bamboo"): g["post"] = null
	_cam(float(nd.y) - 330.0); _near(V, float(nd.x), float(nd.y)); await _w(t, 0.5)
	J.mc(V, "tap", [float(nd.x), float(nd.y) - 20.0])
	var t0 = Time.get_ticks_msec(); var i = 0
	while Time.get_ticks_msec() - t0 < 9000 and i < 14:
		await _w(t, 0.12)
		if V.hero.get("act") is Dictionary or J.num(V.get("proudT", 0)) > 0 or i > 0:
			await _shot(t, "05_hand_bamboo_%02d" % i); i += 1
	# 親手採：茶（割）
	var nt = CF.nodes("b_tea")[0]; CF.st("b_tea").hp[0] = 1.0
	_cam(float(nt.y) - 330.0); _near(V, float(nt.x), float(nt.y)); await _w(t, 0.4)
	J.mc(V, "tap", [float(nt.x), float(nt.y) - 12.0])
	t0 = Time.get_ticks_msec(); i = 0
	while Time.get_ticks_msec() - t0 < 9000 and i < 10:
		await _w(t, 0.15)
		if V.hero.get("act") is Dictionary or J.num(V.get("proudT", 0)) > 0 or i > 0:
			await _shot(t, "06_hand_tea_%02d" % i); i += 1
	# 自動採：派鬼、連續幀（數字彈出）
	var g = _ghost(); J.mc(N(), "pickDo", ["b_bamboo", g.id])
	var g2 = _ghost(); S.bld["b_bamboo"] = 4.0; J.mc(N(), "pickDo", ["b_bamboo", g2.id])
	_close(); await _calm(t)
	_cam(float(nd.y) - 330.0)
	CF.acc["b_bamboo"] = 2.6
	for k in 8:
		await _w(t, 0.5); await _shot(t, "07_auto_bamboo_%02d" % k)
	_cam(CF.anchor("b_fish").y - 330.0); await _w(t, 1.0); await _shot(t, "08_fields_fish_news")
	_cam(CF.anchor("b_toner").y - 330.0); await _w(t, 1.0); await _shot(t, "09_fields_toner")
	var b0 = "b_bamboo"
	Menus.open_bld(b0); await _w(t, 0.6); await _shot(t, "10_card_field")
	Menus.close_hook(); await _w(t, 0.3)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
