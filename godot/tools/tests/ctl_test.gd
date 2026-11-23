# [ctl] 第一期「操作」測試：行動按鈕、出擊清單、手指大小點擊（敵人優先）、村門唔再開舊地圖、地盤掣灰、全圖可走
# 用法：/home/claude/setup/edtest.sh <godot目錄> ctl res://tools/tests/ctl_test.gd logic|all
#   all：logic ＋ 截圖（/home/claude/docs/ctl_shots/）
extends RefCounted

var ok := 0
var bad := 0
var shots := false
const SHOTS := "/home/claude/docs/ctl_shots/"
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const ZW = preload("res://game/zone/zone_walk.gd")
const AT = preload("res://game/outpost/act_targets.gd")
const CW = preload("res://game/outpost/ctl_walk.gd")
var CT = load("res://game/outpost/ctl_ui.gd")
var MB = load("res://game/zone/zone_battle.gd")

func _p(m): print("[ctl] ", m)
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
func _V(): return J.G.get("Village")
func _ok_btn(t) -> void:
	var dl = J.G.get("$")
	var okb = J.cl(dl, null, ["#b-ok"]) if dl != null else null
	if okb != null and okb.get("onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])
	await _w(t, 0.3)
func _until(t, cond: Callable, secs: float) -> bool:
	var n = int(secs / 0.1)
	for i in n:
		if cond.call(): return true
		await _w(t, 0.1)
	return cond.call()
func _team3(S) -> void:
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids
func _qidx_stage(sid: String) -> int:
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == sid: return i
	return -1
func _put_hero(p: Vector2) -> void:
	var H = _V().hero
	H.x = p.x; H.y = p.y; H.tx = p.x; H.ty = p.y; H.act = null; H.target = null; H.erase("zf"); H["zq"] = []
func _find(ts: Array, id: String) -> Dictionary:
	for x in ts: if str(x.id) == id: return x
	return {}
func _walkable(p: Vector2) -> bool: return CW.region(p) != "" and not ZV.blocked(p)
func _poly_ok(P: Array) -> Array:   # 回 [ok, 第一個唔得嘅點]
	for i in P.size() - 1:
		var a: Vector2 = P[i]; var b: Vector2 = P[i + 1]
		var n = maxi(1, int(ceil(a.distance_to(b) / 4.0)))
		for k in n + 1:
			var q = a.lerp(b, float(k) / n)
			if not _walkable(q): return [false, q]
	return [true, null]
func _rect_s(c: Control) -> Rect2: return c.get_global_rect()
# 字有冇爆格：每個 Label 嘅字闊 ≤ 自己闊、而且喺 box 入面
func _fits(box: Control) -> Array:
	var o = []
	var br = box.get_global_rect().grow(1)
	for l in _labels(box):
		if not l.is_visible_in_tree(): continue
		var r = l.get_global_rect()
		if not br.encloses(r): o.append(["出界", l.text if l is Label else l.get_parsed_text(), r, br])
		if l is Label:
			var f = l.get_theme_font("font"); var fs = l.get_theme_font_size("font_size")
			var w = f.get_string_size(l.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			if w > r.size.x + 1: o.append(["截字", l.text, w, r.size.x])
		elif l is RichTextLabel and l.get_content_width() > r.size.x + 1: o.append(["截字", l.get_parsed_text(), l.get_content_width(), r.size.x])
	return o

func logic(t) -> void: await _run(t)
func all(t) -> void: shots = true; await _run(t)

func _run(t) -> void:
	load("res://game/rts/rts.gd").force = 0   # [rts] 呢度測舊大地圖戰鬥（1-1 原型新打法見 rts_test）
	var m = await _boot(t)
	var S = J.G.S; var sc = m.mv_view
	_team3(S)
	if int(J.num(sc.sim.st().ci)) != 0: sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 1.2)
	var ct = CT.inst
	_chk("ctl 已掛上（行動按鈕、出擊掣）", ct != null and ct.act_btn != null and ct.sortie_btn != null)
	_chk("第 1 關分區地圖開住", ZD.on())
	await targets_check(t, m, ct)
	await act_check(t, m, ct)
	await list_check(t, m, ct)
	await tap_check(t, m, ct)
	await nav_gate_check(t, m, ct)
	await walk_check(t, m, ct)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------------- 1. 目標登記 ----------------
func targets_check(t, m, ct) -> void:
	var S = J.G.S
	S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1"))
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	ZD.unmark_bosses(0)
	await _f(t, 3)
	var ts = AT.collect(m)
	var ids = []
	for x in ts: ids.append(str(x.id))
	_chk("collect：主線迎戰位＋兩個野外王＋三個資源區", ids.has("stage:1-1") and ids.has("res:A") and ids.has("res:B") and ids.has("res:C") and ts.filter(func(x): return x.kind == "king").size() == 2, ids)
	var keys_ok = true
	for x in ts:
		for k in ["id", "kind", "name", "pos", "my_pow", "foe_pow", "icon", "go"]: if not x.has(k): keys_ok = false
		if not (x.go is Callable): keys_ok = false
	_chk("每個目標都有約定欄位（id/kind/name/pos/my_pow/foe_pow/icon/go）", keys_ok)
	var st = _find(ts, "stage:1-1")
	_chk("迎戰位喺大排檔、企位都喺大排檔", ZD.zrect("market").has_point(st.pos) and ZD.zrect("market").has_point(AT.stand_of(st)), [st.pos, AT.stand_of(st)])
	_chk("迎戰名：「迎戰：<關名>」", str(st.name).begins_with("迎戰：") and str(st.name).length() > 3, st.name)
	_chk("戰力：敵方＝建議鬼力（1-1＝450）、我方＝出陣隊伍鬼力 > 0", int(st.foe_pow) == 450 and int(st.my_pow) > 0, [st.my_pow, st.foe_pow])
	# 外加 provider（其他線約定）：收得到；壞嘅 provider 唔拖死
	var extra = func(_g): return [{"id": "landmark:test", "kind": "landmark", "name": "測試地標", "pos": Vector2(400, 1300), "my_pow": 0, "foe_pow": 0, "icon": "", "go": func(): pass}]
	var broken = func(_g): return null
	AT.providers.append(extra); AT.providers.append(broken)
	var ts2 = AT.collect(m)
	_chk("其他線 provider 收得到、壞嘅唔拖死", _find(ts2, "landmark:test").size() > 0 and ts2.size() == ts.size() + 1)
	AT.providers.erase(extra); AT.providers.erase(broken)

# ---------------- 2. 行動按鈕 ----------------
func act_check(t, m, ct) -> void:
	var nv = m.village
	var ts = AT.collect(m)
	var st = _find(ts, "stage:1-1")
	_put_hero(ZD.v2(ZD.cur().village.hero)); await _f(t, 4)
	_chk("主角喺村子中間：冇行動按鈕", not ct.act_btn.visible)
	_put_hero(AT.stand_of(st)); nv.zone_cam().center_on(st.pos); await _f(t, 4)
	_chk("走近迎戰位：行動按鈕出現（迎戰）", ct.act_btn.visible and str(ct.cur.get("id")) == "stage:1-1", ct.cur.get("id"))
	_chk("按鈕字：名稱 ≥16px、戰力 ≥16px", ct.act_name.get_theme_font_size("font_size") >= 16 and ct.act_pow.get_theme_font_size("font_size") >= 16 and ct.act_tag.get_theme_font_size("font_size") >= 16)
	_chk("按鈕名稱同戰力字", ct.act_name.text == str(st.name) and ct.act_pow.text.contains("450") and ct.act_tag.text != "", [ct.act_name.text, ct.act_pow.text, ct.act_tag.text])
	var ar = _rect_s(ct.act_btn)
	_chk("按鈕約拇指大小（高 ≥ 60、闊 ≥ 240）、喺底部中間", ar.size.y >= 60 and ar.size.x >= 240 and absf(ar.get_center().x - m.size.x / 2.0) < 2 and ar.end.y > m.size.y * 0.7, ar)
	var nav_top = m.size.y - m.NAV_H
	var hits = []
	if ar.end.y > nav_top: hits.append("底部導航")
	if ar.intersects(_rect_s(ct.sortie_btn)): hits.append("出擊掣")
	var q = m.get_node_or_null("/root/QX")
	if q != null and q.btn != null and ar.intersects(_rect_s(q.btn)): hits.append("任務掣")
	if ar.intersects(_rect_s(m.quest_bar)): hits.append("任務條")
	_chk("唔遮住底部導航、任務掣、出擊掣、任務條", hits.is_empty(), hits)
	ct._process(0.0); await _f(t, 2)
	_chk("行動按鈕字唔爆格", _fits(ct.act_btn).is_empty(), _fits(ct.act_btn))
	await _shot(t, "ctl_01_action_stage")
	# 劇情播放中：收埋
	var Sy = J.G.get("Story")
	J.mc(Sy, "queue", [{"style": "sys", "lines": [["測試", "測試一句"]]}]); await _f(t, 3)
	_chk("劇情播放中：行動按鈕、出擊掣收埋", not ct.act_btn.visible and not ct.sortie_btn.visible, J.mc(Sy, "busy", []))
	await _skip(t, 4); await _f(t, 3)
	_chk("劇情完：行動按鈕返嚟", ct.act_btn.visible)
	m.open_sheet("x", func(): pass); await _f(t, 2)
	_chk("面板開住：行動按鈕收埋", not ct.act_btn.visible)
	m.close_sheet(); await _f(t, 2)
	# 撳 → 開打正確目標
	var n0 = CT.LOG.size()
	ct.act_btn.pressed.emit(); await _f(t, 3)
	var mb = MB.cur
	_chk("撳行動按鈕：開打主線 1-1（大地圖 stage）", CT.LOG.size() > n0 and CT.LOG[CT.LOG.size() - 1] == ["go", "stage:1-1"] and mb != null and mb.kind == "stage", [CT.LOG.slice(n0), mb.kind if mb else null])
	_chk("打緊仗：行動按鈕收埋", not ct.act_btn.visible)
	MB.t_skip_march(); await _w(t, 0.5)
	J.mc(B(), "finish", [false, true]); await _f(t, 2); await _ok_btn(t); ZD.poll()
	MB.t_skip_back(); await _until(t, func(): return not MB.busy(), 25.0)
	await _f(t, 3)
	# 行開：消失
	_put_hero(AT.stand_of(st) + Vector2(0, 400)); await _f(t, 4)
	_chk("行開：行動按鈕消失", not ct.act_btn.visible)
	# 野外王
	var kg = _find(AT.collect(m), "king:" + str(ZD.bosses("w_graves")[0].id))
	_put_hero(AT.stand_of(kg)); nv.zone_cam().center_on(kg.pos); await _f(t, 4)
	_chk("走近野外王：行動按鈕（挑戰）", ct.act_btn.visible and str(ct.cur.get("id")) == str(kg.id) and ct.act_name.text.begins_with("挑戰："), [ct.cur.get("id"), ct.act_name.text])
	await _shot(t, "ctl_02_action_king")
	# 資源區
	var rs = _find(AT.collect(m), "res:A")
	_put_hero(AT.stand_of(rs)); nv.zone_cam().center_on(AT.stand_of(rs)); await _f(t, 4)
	_chk("走近未佔領資源區門口：行動按鈕（攻佔）", ct.act_btn.visible and str(ct.cur.get("id")) == "res:A" and ct.act_name.text.begins_with("攻佔："), [ct.cur.get("id"), ct.act_name.text])
	_chk("行動按鈕（攻佔）字唔爆格", _fits(ct.act_btn).is_empty(), _fits(ct.act_btn))
	await _shot(t, "ctl_03_action_res")
	ct.act_btn.pressed.emit(); await _f(t, 3)
	_chk("撳攻佔：開攻佔卡", m.sheet.visible and m.sheet_title.text == ZD.T(ZD.zone("A").n), m.sheet_title.text)
	m.close_sheet(); await _f(t, 2)
	_put_hero(ZD.v2(ZD.cur().village.hero)); await _f(t, 3)

# ---------------- 3. 出擊清單 ----------------
func list_check(t, m, ct) -> void:
	var nv = m.village
	_put_hero(ZD.v2(ZD.cur().village.hero)); await _f(t, 3)
	_chk("出擊掣喺任務掣旁邊（底部右邊、同一行）", ct.sortie_btn.visible and _rect_s(ct.sortie_btn).end.y <= m.size.y - m.NAV_H and _rect_s(ct.sortie_btn).position.x > m.size.x / 2.0)
	_chk("出擊掣字 ≥16px", ct.sortie_btn.get_theme_font_size("font_size") >= 16)
	ct.sortie_btn.pressed.emit(); await _f(t, 3)
	var rows = []
	for c in m.sheet_body.get_children(): if c.has_meta("tid"): rows.append(c)
	var ids = []
	for r in rows: ids.append(str(r.get_meta("tid")))
	var all_n = AT.collect(m).filter(func(x): return str(x.get("kind", "")) in ["stage", "king", "res", "raid"]).size()   # [integ] 出擊只列可打目標
	_chk("出擊清單：開咗、最多 5 個、數目啱", m.sheet.visible and rows.size() == mini(5, all_n), [rows.size(), all_n, ids])
	_chk("出擊清單：主線關卡排第一", ids.size() > 0 and ids[0] == "stage:1-1", ids)
	var txt_ok = true; var dump = []
	for r in rows:
		var s = _all_text(r)
		dump.append(s)
		if not (s.contains("距離") and (s.contains("鬼力") or s.contains("陰兵"))): txt_ok = false
	_chk("每行寫戰力同距離", txt_ok, dump)
	var fs_ok = true
	for r in rows: for l in _labels(r): if l is Label and l.get_theme_font_size("font_size") < 16: fs_ok = false
	_chk("清單字 ≥16px", fs_ok)
	var fit = []
	for r in rows: fit.append_array(_fits(r))
	_chk("清單每行字唔爆格", fit.is_empty(), fit)
	await _shot(t, "ctl_04_sortie_list")
	# 撳野外王：鏡頭帶過去、主角自動行過去、到咗出行動按鈕
	var kid = ""
	for i in ids: if i.begins_with("king:"): kid = i; break
	var row = rows[ids.find(kid)]
	row.pressed.emit(); await _f(t, 2)
	var tg = _find(AT.collect(m), kid)
	_chk("撳一項：清單收埋、鏡頭向目標移、主角起行", not m.sheet.visible and ct.auto.size() > 0 and nv.zone_cam().tgt != null)
	var badp = []
	var arrived = await _until(t, func():
		var hp = ct.hero_pos()
		if not _walkable(hp) and badp.size() < 5: badp.append(hp)
		return ct.act_btn.visible and str(ct.cur.get("id")) == kid, 40.0)
	_chk("主角自動行到野外王：出行動按鈕", arrived, [ct.hero_pos(), AT.stand_of(tg), ct.cur.get("id")])
	_chk("自動行全程喺可走範圍（唔穿阻隔）", badp.is_empty(), badp)
	_chk("鏡頭睇到目標", nv.zone_cam().rect().has_point(tg.pos))
	await _shot(t, "ctl_05_sortie_arrived")
	_put_hero(ZD.v2(ZD.cur().village.hero)); await _f(t, 3)
func _labels(n: Node) -> Array:
	var o = []
	for c in n.get_children():
		if c is Label or c is RichTextLabel: o.append(c)
		o.append_array(_labels(c))
	return o
func _all_text(n: Node) -> String:
	var s = ""
	for l in _labels(n): s += (l.text if l is Label else l.get_parsed_text()) + " "
	return s

# ---------------- 4. 點擊範圍（手指大小、敵人優先） ----------------
func tap_check(t, m, ct) -> void:
	var nv = m.village; var c = nv.zone_cam()
	var z0 = c.z
	c.z = c.z_min(); c.clamp_all(); await _f(t, 2)
	var z = float(nv.sc)
	var small = []
	for x in AT.collect(m):
		var r = CT.hit_rect(x, z)
		if r.size.x * z < 48.0 or r.size.y * z < 48.0: small.append([x.id, r.size * z])
	_chk("縮到最細：每個目標點擊範圍 ≥ 48 畫面 px", small.is_empty(), [z, small])
	var en = {"id": "e", "kind": "king", "pos": Vector2(500, 500), "hit": Rect2(480, 420, 40, 90), "enemy": true}
	var fr = {"id": "f", "kind": "res", "pos": Vector2(505, 470), "hit": Rect2(400, 400, 300, 300), "enemy": false}
	var p = Vector2(505, 470)
	_chk("重疊時敵人優先（就算友方目標更近）", str(CT.pick_at([fr, en], p, 1.0).get("id")) == "e" and str(CT.pick_at([en, fr], p, 1.0).get("id")) == "e")
	_chk("手指範圍：撳差少少都中（細目標）", str(CT.pick_at([{"id": "s", "pos": Vector2(0, 0), "hit": Rect2(-5, -5, 10, 10)}], Vector2(20, 0), 1.0).get("id")) == "s")
	c.z = z0; c.clamp_all(); await _f(t, 2)
	# 真撳：野外王（開挑戰卡，經 ZV.tap → ctl）
	var kg = {}
	for x in AT.collect(m): if x.kind == "king": kg = x; break
	c.center_on(kg.pos); await _f(t, 3)
	var n0 = CT.LOG.size()
	var hr = CT.hit_rect(kg, float(nv.sc))
	nv.zone_tap(c.w2s(Vector2(hr.end.x - 3.0, hr.get_center().y)))
	await _f(t, 3)
	_chk("撳野外王點擊範圍邊位：開挑戰卡", CT.LOG.size() > n0 and CT.LOG[CT.LOG.size() - 1] == ["tap", str(kg.id)] and m.sheet.visible)
	m.close_sheet(); await _f(t, 2)

# ---------------- 5. 地盤掣、村門 ----------------
func nav_gate_check(t, m, ct) -> void:
	var b: Button = m.nav_btns.battle[0]
	_chk("「地盤」掣變灰", b.modulate.r < 0.6 and b.modulate.g < 0.6)
	var W = J.G.get("World"); var o_open = W.get("open")
	var opened = [false]
	W["open"] = func(_t, _a): opened[0] = true; return null
	var tn = m.toasts.get_child_count()
	m._nav("battle"); await _f(t, 3)
	_chk("撳「地盤」：唔開地圖、提示「之後開放」", not opened[0] and CT.LOG[CT.LOG.size() - 1] == ["nav", "battle"] and m.toasts.get_child_count() > tn)
	await _shot(t, "ctl_06_nav_gray")
	var gp = ZD.v2(ZD.cur().village.POS.gate)
	_chk("村門 hitTest 唔再認「gate」", J.mc(_V(), "hitTest", [gp.x, gp.y - 30.0]) == null)
	_put_hero(ZD.v2(ZD.cur().village.hero)); await _f(t, 2)
	var nv = m.village
	nv.zone_cam().center_on(gp); await _f(t, 3)
	nv.zone_tap(nv.zone_cam().w2s(gp + Vector2(0, -30))); await _f(t, 3)
	var H = _V().hero
	_chk("撳村門：唔開舊地圖（主角行過去）", not opened[0] and not J.t(J.gp(W, "on")), [J.num(H.tx), J.num(H.ty)])
	W["open"] = o_open
	_chk("村門照畫（POS 仲有 gate）", ZD.cur().village.POS.has("gate") and J.G.POS.has("gate"))

# ---------------- 6. 全圖可走 ----------------
func walk_check(t, m, ct) -> void:
	var S = J.G.S; var sc = m.mv_view; var nv = m.village
	var res = []
	for c in 6:
		sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 0.6)
		ZD.apply()
		var Z = ZD.cur()
		var vh = ZD.v2(Z.village.hero)
		for zid in ["A", "B", "C"]: ZD.set_owned(zid)
		var dsts = [["market", ZD.zrect("market").get_center()]]
		for w in ZD.of_type("wild"):
			var r = ZD.zrect(str(w.id))
			dsts.append([str(w.id), ZD.v2(w.get("boss_at", [r.get_center().x, r.get_center().y])) + Vector2(0, 30)])
		for zid in ["A", "B", "C"]: dsts.append([zid, ZD.zrect(zid).get_center()])
		for d in dsts:
			var rt = ZW.route(vh, d[1])
			var pk = _poly_ok([vh] + rt)
			var end_ok = rt[rt.size() - 1].distance_to(d[1]) < 1.0
			if not pk[0] or not end_ok: res.append([c, d[0], pk[1], rt])
		# 野外 → 另一個野外（經大排檔）、資源區 → 野外
		var ws = ZD.of_type("wild")
		if ws.size() >= 2:
			var a = ZD.zrect(str(ws[0].id)).get_center(); var b2 = ZD.zrect(str(ws[1].id)).get_center()
			var rt2 = ZW.route(a, b2)
			if not _poly_ok([a] + rt2)[0]: res.append([c, "wild↔wild", _poly_ok([a] + rt2)[1], rt2])
		var ra = ZD.zrect("A").get_center(); var rw = ZD.zrect(str(ws[0].id)).get_center()
		var rt3 = ZW.route(ra, rw)
		if not _poly_ok([ra] + rt3)[0]: res.append([c, "A→wild", _poly_ok([ra] + rt3)[1], rt3])
		for zid in ["A", "B", "C"]: S.zone.own.erase("%d:%s" % [c, zid])
		# 未佔領資源區：入唔到（停喺村子／門口）
		for zid in ["A", "B", "C"]:
			var r0 = ZW.route(vh, ZD.zrect(zid).get_center())
			var e0 = r0[r0.size() - 1]
			if ZD.zrect(zid).has_point(e0) or CW.region(e0) != "village": res.append([c, "未佔領%s：停錯位" % zid, r0])
	_chk("六關：村子 → 大排檔／每個野外王／已佔領資源區、野外 ↔ 野外、資源區 → 野外，全部行得到又唔穿阻隔；未佔領資源區停喺門口（村子嗰邊）", res.is_empty(), res)
	sc.sim.st().ci = 0.0; sc._after_move(); await _w(t, 0.8); ZD.apply()
	# 黑霧：未解霧嘅大排檔入唔到（擋喺霧邊）
	var g0 = ZD.gate_on
	ZD.gate_on = true
	var rv = ZD._rev(); var had = rv.get("0:market")
	rv.erase("0:market")
	var vh0 = ZD.v2(ZD.cur().village.hero)
	var rm = ZW.route(vh0, ZD.zrect("market").get_center())
	# [qaudit2] dirs4 之後四條出路都由村門 (670,1160) 開始：停喺村門時 region 會報 x_<方向>（出路小路，父＝村子），都算停喺村子
	var rme: Vector2 = rm[rm.size() - 1]; var rmr = CW.region(rme)
	_chk("黑霧未散嘅大排檔：主角擋喺霧邊（停喺村子）", not ZD.zrect("market").has_point(rme) and (rmr == "village" or (rmr.begins_with("x_") and ZD.zrect("village").grow(4).has_point(rme))), [rm, rmr])
	if had != null: rv["0:market"] = had
	rv["0:market"] = 1.0
	var hw = rv.get("0:w_graves"); rv.erase("0:w_graves")
	var rw0 = ZW.route(vh0, ZD.zrect("w_graves").get_center())
	_chk("黑霧未散嘅野外區：主角擋喺霧邊（停喺大排檔野外門前）", CW.region(rw0[rw0.size() - 1]) == "market" and not ZD.zrect("w_graves").has_point(rw0[rw0.size() - 1]), rw0)
	if hw != null: rv["0:w_graves"] = hw
	if had == null: rv.erase("0:market")
	ZD.gate_on = g0
	# 實際行：撳大排檔空地 → 主角行入去，MvScene 上面睇到主角
	_put_hero(vh0); await _f(t, 2)
	var mr = ZD.zrect("market")
	var spot = Vector2(mr.position.x + 60, mr.get_center().y + 60)
	nv.zone_cam().center_on(spot); await _f(t, 3)
	m.mv_embed.zone_world_tap(spot); await _f(t, 2)
	_chk("撳大排檔空地：當空地（tap_free）", J.t(sc.get("tap_free")))
	var badp = []
	var got = await _until(t, func():
		var hp = ct.hero_pos()
		if not _walkable(hp) and badp.size() < 5: badp.append(hp)
		return hp.distance_to(spot) < 6.0, 40.0)
	_chk("主角行入大排檔（經出村門）", got and badp.is_empty(), [ct.hero_pos(), badp])
	await _f(t, 3)
	_chk("主角喺大排檔：MvScene 上面再畫主角", ct.hero_ov != null and ct.hero_ov.visible)
	await _shot(t, "ctl_07_hero_market")
	_put_hero(vh0); await _f(t, 3)
	_chk("主角返村子：唔使再畫", not ct.hero_ov.visible)

# 除錯：主角喺大排檔，關／開 MvScene 上面嗰層，各截一張
func ovchk(t) -> void:
	shots = true
	var m = await _boot(t)
	var ct = CT.inst; var nv = m.village
	var mr = ZD.zrect("market")
	var p = Vector2(mr.position.x + 120, mr.get_center().y + 60)
	_put_hero(p); nv.zone_cam().center_on(p); await _w(t, 1.0)
	ct.set_process(false); ct.hero_ov.visible = false; await _f(t, 3)
	await _shot(t, "dbg_ov_off")
	ct.set_process(true); await _f(t, 3)
	await _shot(t, "dbg_ov_on")
	_p("RESULT ok=1 bad=0")

# 除錯：頭像（每個目標）放大睇有冇出圓框
func faces(t) -> void:
	shots = true
	var m = await _boot(t)
	var ct = CT.inst
	var S = J.G.S; _team3(S)
	S.cleared.erase("1-1"); S["qi"] = float(_qidx_stage("1-1")); ZD.unmark_bosses(0)
	for zid in ["A", "B", "C"]: S.zone.own.erase("0:" + zid)
	await _f(t, 3)
	m.open_sheet("頭像", func(): pass)
	var hb = HFlowContainer.new(); m.sheet_body.add_child(hb)
	var ks = ["youhun"]
	for x in AT.collect(m): ks.append(str(x.icon))
	for w in ZD.of_type("wild"): for b in ZD.bosses(str(w.id)): ks.append(str(b.get("art", "youhun")))
	for k in ks:
		var c = Control.new(); c.custom_minimum_size = Vector2(62, 62)
		var tt = {"id": k, "icon": k, "my_pow": 1, "foe_pow": 1}
		c.draw.connect(func(): ct._draw_face(c, tt))
		hb.add_child(c)
	await _f(t, 4); await _shot(t, "dbg_faces")
	_p("RESULT ok=1 bad=0")
