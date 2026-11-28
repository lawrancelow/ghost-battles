# [stall_occupy] 補丁 55：告急倒數完 → 孤魂真係行去被霸嘅攤位企住；攤位變暗停產、頭頂「霸」牌；
#   玩家撳孤魂（經 nv_village.zone_tap 同一條撳屏路）打走晒 → 復工、告急解除；讀檔返嚟孤魂直接企返喺檔度；出征打贏 → 孤魂散水
# 用法：/home/claude/setup/edtest.sh <godot目錄> stall_occupy res://tools/tests/stall_occupy_test.gd all 600
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var SHOTS := "/tmp/stall_occupy/shots/"

func _p(m): print("[stall_occupy] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func all(t) -> void:
	var eo = OS.get_environment("UX_OUT")
	if eo != "": SHOTS = eo
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sc = m.mv_view; var sim = sc.sim; var nv = m.village; var cam = nv.zone_cam()
	var w = MVW.ws()
	w.t0 = 99999.0; w.inf[str(sim.ci())] = 10.0; w.wave_t = 9999.0
	# 開幾個檔，等 _occupy_pick 有嘢揀
	var s0 = MD_stations(sim)[0]
	if sim.st().st.get(s0) is Dictionary: sim.st().st[s0]["unlocked"] = true
	w.alarm = {"t": 0.05}
	var sid = ""
	for i in 40:
		await _w(t, 0.1)
		sid = MVW.occ_sid()
		if sid != "": break
	_chk("告急倒數完：有檔畀孤魂霸", sid != "", sid)
	if sid == "": _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	var occ = MVW.occ_foes(sim)
	_chk("霸檔孤魂出現（%d 隻）、由門口行過去" % MVW.occ_n(sim.ci()), occ.size() == MVW.occ_n(sim.ci()) and occ.all(func(f): return f.st == "occ_go"), occ.map(func(f): return f.st))
	var sp = sim.st_pos(sid)
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	cam.center_on(sp + Vector2(0, -40)); await _w(t, 0.3); await _shot(t, "occ_walking")
	Engine.time_scale = 4.0
	for i in 200:
		await _w(t, 0.1)
		if MVW.occ_foes(sim).all(func(f): return f.st == "occ"): break
	Engine.time_scale = 1.0
	occ = MVW.occ_foes(sim)
	var far = []
	for f in occ: if f.pos.distance_to(sp) > 80.0: far.append(f.pos)
	_chk("孤魂行到被霸嘅攤位、企喺檔度（80 內）", occ.size() > 0 and occ.all(func(f): return f.st == "occ") and far.is_empty(), [occ.map(func(f): return f.st), far, sp])
	_chk("被霸攤位停產（blocked）", sim.war.blocked(sim, sid))
	await _w(t, 1.0)
	_chk("守夜／義勇軍唔會走去門口打霸檔孤魂（_near_fence 排除）", occ.all(func(f): return not sim.war._near_fence(sim, f)))
	cam.center_on(sp + Vector2(0, -40)); await _w(t, 0.5); await _shot(t, "occ_at_stall")
	# 撳孤魂打走佢哋（撳個身中間）
	var taps = 0
	for i in 400:
		occ = MVW.occ_foes(sim)
		if occ.is_empty() or MVW.occ_sid() == "": break
		var f = occ[0]
		cam.center_on(f.pos + Vector2(0, -30)); await t.get_tree().process_frame
		nv.zone_tap(nv.zone_w2s(f.pos + Vector2(0, -30))); taps += 1
		await _w(t, 0.06)
	_p("taps=%d" % taps)
	_chk("撳孤魂打走晒 → 攤位復工、告急解除", MVW.occ_sid() == "" and not MVW.alarm_on() and not sim.war.blocked(sim, sid), [MVW.occ_sid(), MVW.alarm_on(), taps])
	_chk("影響力回升到告急線以上", MVW.inf() >= MVW.ALARM_OFF, MVW.inf())
	await _w(t, 0.8)
	cam.center_on(sp + Vector2(0, -40)); await _w(t, 0.3); await _shot(t, "occ_freed")
	# 讀檔／返嚟：仲霸住但冇孤魂 → 直接企返喺檔度
	for f in sim.foes.duplicate(): if f.has("occ"): sim.foes.erase(f)
	w.occ[str(sim.ci())] = sid; w.alarm = {"t": 0.0}; w.inf[str(sim.ci())] = 10.0
	await _w(t, 0.5)
	occ = MVW.occ_foes(sim)
	_chk("讀檔返嚟：孤魂直接企返喺被霸攤位", occ.size() == MVW.occ_n(sim.ci()) and occ.all(func(f): return f.st == "occ" and f.pos.distance_to(sp) < 80.0), occ.size())
	# 出征打贏：霸檔孤魂散水
	w.exp = {"sid": "x", "ci": float(sim.ci()), "had": true}
	MVW.resolve(true)
	await _w(t, 0.4)
	_chk("出征打贏：霸檔解除、孤魂散水", MVW.occ_sid() == "" and MVW.occ_foes(sim).is_empty(), MVW.occ_foes(sim).size())
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func MD_stations(sim) -> Array: return load("res://game/outpost/mv_data.gd").stations(sim.ci())
