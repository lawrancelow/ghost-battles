# [uxui] 介面流程測試
#   modal：劇情播緊 → 提示／橫幅／誇獎／大排檔對白框／告急橫額全部唔出，劇情完咗再依序出
#   hud  ：出擊交戰＋告急＋玩法掣＋生產鏈＋技能鈕同場 → 各浮動元素矩形兩兩唔重疊、全部喺畫面內
# 用法：edtest.sh <godot目錄> uxm res://tools/tests/uxui_test.gd modal ／ … hud
extends RefCounted
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const T0 = preload("res://tools/tests/sortie_test.gd")
var ok := 0
var bad := 0
func _p(m): print("[uxui] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _boot(t):
	var T = T0.new()
	var m = await T._boot(t)
	await T._prep(t, m)
	return m

func modal(t) -> void:
	var m = await _boot(t)
	var sc = m.mv_view
	for i in 10:
		if not m.story.busy(): break
		m.story.skip_scene(); await _w(t, 0.2)
	await _w(t, 3.5)   # 等之前嘅提示淡走
	var n0 = m.toasts.get_child_count()
	_chk("劇情喺最頂層（CanvasLayer ≥ 120）", m.story.get_parent() is CanvasLayer and m.story.get_parent().layer >= 120, str(m.story.get_parent()))
	G.story_req.emit("gift_xiaozhi", Callable())
	await _w(t, 0.3)
	_chk("劇情開始", m.story.busy())
	G.toast.emit("t1"); G.banner.emit("b1"); G.praise.emit("build")
	if sc != null:
		var nb = sc.bubbles.size()
		sc._bubble(Vector2(100, 100), "客人講嘢", "客人")
		_chk("劇情中大排檔對白框唔出", sc.bubbles.size() == nb, "%d→%d" % [nb, sc.bubbles.size()])
		sc.banner = null; sc._banner_set("告急！", "測試", 2.0)
		_chk("劇情中告急橫額唔出（排隊）", sc.banner == null and sc._banner_pend != null)
	await _w(t, 0.5)
	_chk("劇情中提示唔出", m.toasts.get_child_count() == n0, "%d→%d" % [n0, m.toasts.get_child_count()])
	_chk("提示／橫幅／誇獎排咗隊", m._mq.size() >= 3, m._mq.size())
	for i in 20:
		if not m.story.busy(): break
		m.story.skip_scene(); await _w(t, 0.2)
	_chk("劇情完", not m.story.busy())
	await _w(t, 3.0)
	_chk("劇情完咗佇列出清", m._mq.is_empty(), m._mq.size())
	if sc != null: _chk("劇情完咗告急橫額補出", sc._banner_pend == null)
	# 全螢幕面板開住：提示照出（係撳掣即時回應），橫幅排隊
	m.open_settings()
	await _w(t, 0.3)
	var n1 = m.toasts.get_child_count()
	G.toast.emit("t2"); G.banner.emit("b2")
	await _w(t, 0.2)
	_chk("設置開住：提示照出", m.toasts.get_child_count() > n1)
	_chk("設置開住：橫幅排隊", m._mq.size() == 1, m._mq.size())
	var sp = m.get_node_or_null("SettingsPanel")
	if sp != null: sp.queue_free()
	await _w(t, 1.5)
	_chk("關咗設置橫幅出返", m._mq.is_empty(), m._mq.size())
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _grect(c: Control) -> Rect2: return c.get_global_rect()
func hud(t) -> void:
	var m = await _boot(t)
	SO.force_open = true; SO.test_now = 1000000.0
	T0.new()._rich()
	var S = J.G.S
	var hid = S.ghosts[0].id
	if not S.team.has(hid): S.team[0] = hid
	for g in S.ghosts:
		if S.team.size() < 3 and not S.team.has(g.id): S.team.append(g.id)
	var mk = ZD.zrect("market").get_center() if ZD.zrect("market").size.x > 0 else RTS.gate_pos() + Vector2(0, -260)
	m.village.zone_cam().center_on(mk + Vector2(0, 160)); await _w(t, 0.6)
	var sc = m.mv_view; var sim = sc.sim
	var ws = MVW.ws(); ws.t0 = 99999.0; ws.inf[str(sim.ci())] = 10.0
	var e = SO.camps()[0]; SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	if op != null:
		for i in 400:
			RTS._last_f = -1; RTS.tick(0.1)
			if op.phase == "fight": break
	# 主角企近敵人目標 → 出「挑戰」卡（老闆截圖同場）
	var AT = load("res://game/outpost/act_targets.gd")
	for tg in AT.collect(m):
		if AT.is_enemy(tg):
			var sp: Vector2 = AT.stand_of(tg)
			var H = J.G.Village.hero; H["x"] = sp.x; H["y"] = sp.y; H["tx"] = sp.x; H["ty"] = sp.y; H["walking"] = false
			break
	await _w(t, 4.0)   # 告急大橫額過咗
	var vp = Rect2(Vector2.ZERO, t.get_viewport().get_visible_rect().size)
	var items := {}
	var root = t.get_tree().root
	for nm in ["ChainBtn", "CtlSortie", "CtlAct", "RtsChip"]:
		var n = root.find_child(nm, true, false)
		if n != null and n is Control and n.is_visible_in_tree(): items[nm] = _grect(n)
	var rv = root.find_child("RtsUI", true, false)
	if rv != null:
		var i = 0
		for c in rv.get_children():
			if c is Control and c.visible and c.name != "RtsChip": items["rts:%s#%d" % [c.get_class(), i]] = _grect(c); i += 1
	var xf = sc.get_global_transform()
	var ar = sc.ux_alarm_rect()
	if ar != null: items["告急掣"] = xf * ar
	if sc._pill_rect is Rect2: items["玩法掣"] = xf * (sc._pill_rect as Rect2)
	_p("元素：" + str(items.keys()))
	_chk("有齊主要元素（出擊、告急、技能…）", items.has("CtlSortie") and items.has("告急掣") and items.size() >= 6, items.size())
	var ks = items.keys()
	for a in ks:
		var r: Rect2 = items[a]
		_chk("喺畫面內：" + a, vp.grow(1).encloses(r), str(r))
	for i in ks.size():
		for j in range(i + 1, ks.size()):
			var ra: Rect2 = items[ks[i]]; var rb: Rect2 = items[ks[j]]
			var ov = ra.grow(-1).intersects(rb.grow(-1))
			_chk("唔重疊：%s／%s" % [ks[i], ks[j]], not ov, "%s %s" % [ra, rb] if ov else "")
	var od = OS.get_environment("UX_OUT")
	if od != "":
		DirAccess.make_dir_recursive_absolute(od)
		await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(od + "hud_%dx%d.png" % [int(vp.size.x), int(vp.size.y)])
	_p("RESULT ok=%d bad=%d" % [ok, bad])
