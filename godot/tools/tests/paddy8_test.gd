# [paddy8] 補丁 55：村子糯米稻田 6→8 格（六關都係原本 2×3 田下面加多一行 2 格）
#   1. 六關：PADDY_POS 8 格、新 2 格同舊田同一列、行距 60；唔壓建築／槐樹／其他田／村內裝飾／打工企位外移
#   2. 舊存檔 6 格 → 自動補到 8 格（新格係熟嘅、舊格狀態照舊）；新存檔一開就 8 格
#   3. 六關：撳新加嘅第 7、8 格 → 阿福由出生點行過去收割（同玩家一樣經 zone_tap）
# 用法：/home/claude/setup/edtest.sh <godot目錄> paddy8 res://tools/tests/paddy8_test.gd all
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const SHOTS := "/tmp/paddy8/shots/"
const BW := {"house": 150, "gate": 150, "plank": 106, "bun": 106, "wood": 108, "rice": 108, "store": 112, "home": 104, "camp": 108, "altar": 104, "furnace": 62}

func _p(m): print("[paddy8] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	_static()
	_save()
	for c in 6: await _level(t, m, pf, c)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _static() -> void:
	var D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/zones.json"))
	for c in D.maps.keys():
		var v = D.maps[c].village; var P: Array = v.PADDY_POS; var tag = "第 %d 關：" % (int(c) + 1)
		_chk(tag + "稻田 8 格", P.size() == 8, P.size())
		if P.size() != 8: continue
		var gx = [P[0][0], P[1][0]]
		_chk(tag + "新 2 格同舊田同一列、緊接最底一行（行距 60）", P[6][0] == gx[0] and P[7][0] == gx[1] and P[6][1] == P[4][1] + 60 and P[7][1] == P[5][1] + 60, [P[6], P[7]])
		var hit = []
		for i in [6, 7]:
			var r = Rect2(P[i][0] - 40, P[i][1] - 34, 80, 42)
			for k in v.POS:
				var p = v.POS[k]; var w = float(BW.get(k, 100)); var h = w * 0.93
				if Rect2(p[0] - w / 2 + 4, p[1] + 6 - h * 0.75, w - 8, h * 0.75 + 10).intersects(r): hit.append(["bld", k])
			for tp in v.TREE_POS: if Rect2(tp[0] - 28, tp[1] - 58, 56, 68).intersects(r): hit.append(["tree", tp])
			for j in P.size(): if j != i and Rect2(P[j][0] - 40, P[j][1] - 34, 80, 42).intersects(r): hit.append(["paddy", j])
			for pr in v.get("props", []): if absf(pr[1] - P[i][0]) < 40 and pr[2] > P[i][1] - 34 and pr[2] < P[i][1] + 14: hit.append(["prop", pr])
			for d in v.get("DECOR", []): if absf(d[1] - P[i][0]) < 40 and d[2] > P[i][1] - 34 and d[2] < P[i][1] + 14: hit.append(["decor", d])
		_chk(tag + "新 2 格唔壓建築／槐樹／其他田／裝飾", hit.is_empty(), hit)
		var zr = null
		for z in D.maps[c].zones: if str(z.get("type", "")) == "village": zr = z.rect
		if zr != null:
			var inside = true
			for i in [6, 7]: if not Rect2(zr[0], zr[1], zr[2] - zr[0], zr[3] - zr[1]).has_point(Vector2(P[i][0], P[i][1])): inside = false
			_chk(tag + "新 2 格喺村子範圍內", inside, zr)

func _save() -> void:
	var S = J.G.S
	var keep = [S.paddy.duplicate(), S.paddyRegrow.duplicate()]
	S.paddy = [1.0, 0.0, 1.0, 1.0, 0.0, 1.0]; S.paddyRegrow = [0.0, 9.0, 0.0, 0.0, 4.0, 0.0]
	ZD.st()
	_chk("舊存檔 6 格：自動補到 8 格，新格係熟、舊格照舊", S.paddy.size() == 8 and S.paddyRegrow.size() == 8 and not J.t(S.paddy[1]) and not J.t(S.paddy[4]) and J.t(S.paddy[6]) and J.t(S.paddy[7]) and J.num(S.paddyRegrow[1]) == 9.0, [S.paddy, S.paddyRegrow])
	S.paddy = keep[0]; S.paddyRegrow = keep[1]
	var ns = J.mc(J.G, "newState", []) if J.G.get("newState") is Callable else null
	if ns is Dictionary: _chk("新存檔一開就 8 格稻田", (ns.paddy as Array).size() == 8 and (ns.paddyRegrow as Array).size() == 8, (ns.paddy as Array).size())

func _level(t, m, pf, c: int) -> void:
	var sc = m.mv_view
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2); await pf._skip(t)
	var tag = "第 %d 關：" % (c + 1)
	var V = J.G.get("Village"); var S = J.G.S; var nv = m.village; var cam = nv.zone_cam()
	var PP = J.G.PADDY_POS
	_chk(tag + "已套用 8 格稻田、存檔 8 格", ZD.applied() == str(c) and PP.size() == 8 and S.paddy.size() >= 8, [ZD.applied(), PP.size(), S.paddy.size()])
	if PP.size() < 8: return
	for i in PP.size(): S.paddy[i] = 1.0; S.paddyRegrow[i] = 0.0
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	cam.center_on((ZD.v2(PP[0]) + ZD.v2(PP[7])) / 2.0 + Vector2(0, -10)); await _w(t, 0.6); await _shot(t, "L%d_paddy8" % (c + 1))
	# 撳圖 → hitTest 係佢自己
	var hb = []
	for i in [6, 7]:
		var r = pf._paddy_vis(ZD.v2(PP[i]))
		for fx in [0.2, 0.5, 0.8]:
			var h = J.mc(V, "hitTest", [r.position.x + r.size.x * fx, r.get_center().y])
			if not (h is Dictionary) or str(h.kind) != "paddy" or int(J.num(h.i)) != i: hb.append([i, fx, h])
	_chk(tag + "撳新 2 格稻田，hitTest 都係佢自己", hb.is_empty(), hb)
	Engine.time_scale = 4.0
	var got = []
	for i in [6, 7]:
		pf._reset_hero(V)
		var vr = pf._paddy_vis(ZD.v2(PP[i]))
		cam.center_on(vr.get_center()); await _w(t, 0.1)
		pf._unblock(m)
		nv.zone_tap(nv.zone_w2s(vr.get_center()))
		var dl = Time.get_ticks_msec() + 90000
		for k in 100000:
			if Time.get_ticks_msec() > dl: break
			await _w(t, 0.1)
			if not J.t(S.paddy[i]): break
			if k % 10 == 9: pf._unblock(m)
		if not J.t(S.paddy[i]): got.append(i)
		else: _p("diag paddy %d %s" % [i, pf._diag(m, V)])
	Engine.time_scale = 1.0
	_chk(tag + "新 2 格撳得、阿福行得到、割得", got == [6, 7], got)
	# 割咗嘅會生返（regrow 8 格都行）
	var rg = J.num(S.paddyRegrow[7])
	_chk(tag + "第 8 格割完有重生倒數", rg > 0.0, rg)
	for i in PP.size(): S.paddy[i] = 1.0; S.paddyRegrow[i] = 0.0
	pf._reset_hero(V)
