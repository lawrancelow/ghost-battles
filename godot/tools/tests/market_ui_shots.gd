# [market] 過勞鬼市集 M1 正式畫面：實機截圖（畀老闆睇嘅總覽用）。唔計 ok／bad，只出圖。
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> mkshots res://tools/tests/market_ui_shots.gd all 600
# 出圖：/home/claude/meeting/market/shots_ui/s01…；之後用 tools/market_overview.py 砌成 m1_ui_overview.jpg
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const MK = preload("res://game/market/mk_data.gd")
const MKO = preload("res://game/market/mk_ops.gd")
const MKOU = preload("res://game/market/mk_ops_ui.gd")
const M = preload("res://game/outpost/mat.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
var SHOTS := "/home/claude/meeting/market/shots_ui/"
var _view := Callable()
var NAMES := ["阿土", "小紙", "三更", "阿蓮", "大頭", "阿旺", "細妹", "老陳", "阿福仔", "小滿", "阿貴", "秋姐"]

func _p(m): print("[mkshots] ", m)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _feed(sim, stalls: Array) -> void:
	for sid in stalls: for mid in sim.need(sid): M.add(str(mid), 99999.0)
	M.add("m_bao", 50.0)
	var w = MVW.ws()
	if w != null and w.get("occ") is Dictionary: w.occ.erase(str(sim.ci()))
	sim.foes.clear()
func _run(t, sim, stalls: Array, secs: float) -> void:   # 畀模擬行一陣（客人、員工郁起嚟）
	var n = int(secs / 0.5)
	for i in n: _feed(sim, stalls); await _w(t, 0.5)
func _ev(t, sim, sc, stalls: Array, type: String, sp: int, wait: float, name: String) -> Dictionary:
	MKO.st().ev.clear(); MKO.st().evt["food"] = 9999.0
	var e = MKO.spawn_event(sim, "food", type, sp)
	await _run(t, sim, stalls, wait)
	MKO.st().evt["food"] = 9999.0
	await _shot(t, name)
	return e

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	ZD.gate_on = false
	var sc = m.mv_view; var sim = sc.sim; var nv = m.village; var cam = nv.zone_cam()
	var S = J.G.S
	MK.st()["test"] = 1
	load("res://game/kpi/kpi_data.gd").enable(false)
	var kinds = []
	for g in S.ghosts: if not kinds.has(str(J.gp(g, "k"))) and str(J.gp(g, "k")) != "afu": kinds.append(str(J.gp(g, "k")))
	if kinds.is_empty(): kinds = ["youhun"]
	for i in 12:
		var id = "t_u%d" % i; var has = false
		for g in S.ghosts: if str(J.gp(g, "id")) == id: has = true
		if not has: S.ghosts.append({"id": id, "k": kinds[i % kinds.size()], "name": NAMES[i], "lv": 1.0, "post": null})
	sim.market_street("food")
	var c = sim.ci()
	var stalls = MK.sids_on(c, "food")
	MK.st().erase("ops"); MK.st()["ot"] = {}
	sim.st()["served"] = 30.0
	var g = 0
	for sid in stalls:
		sim.sst(sid)["unlocked"] = true; sim.sst(sid).lv = 30.0; sim.set_route(sid, "sell")
	MKO.tick(sim, 0.05); MKO.st()["tut"] = 1; MKO.st().evt["food"] = 9999.0
	for sid in stalls:
		for i in 2: sim.assign(sid, i, "t_u%d" % g); g += 1
	S.res["coins"] = 52000.0
	MKO.assign(sim, "ctr", "food", "t_u8")
	MKO.assign(sim, "pat", "food", "t_u9"); MKO.assign(sim, "pat", "food", "t_u10")
	MKO._income("food", 180000.0)
	MKO.pop_say(); MKOU._says.clear()
	sc.hud_k = 1.0
	var mid = Vector2((sim.st_pos(stalls[0]).x - 70.0 + float(sim.L.counter_x1) + 30.0) / 2.0, sim.st_pos(stalls[0]).y + 40.0)
	_view = func(): cam.z = nv.size.x / 390.0 * 0.66; cam.vel = Vector2.ZERO; cam.center_on(mid)
	_view.call()
	_p("stalls %s pos %s counter (%s..%s, %s) q1 %s" % [stalls, sim.st_pos(stalls[0]), sim.L.counter_x0, sim.L.counter_x1, sim.L.counter_y, sim.queue_pos(1)])
	sim.paused = false
	MKOU._title = {"st": "food", "t0": -99.0}
	await _run(t, sim, stalls, 9.0)
	await _shot(t, "s01_normal")
	# 切街標題卡（牌坊 A）
	MKOU._title = {"st": "", "t0": -99.0}
	await _w(t, 0.5); await _shot(t, "s02_title")
	await _w(t, 1.8)
	# 雙貨：貨架卡
	sim.sst(stalls[1])["unlocked"] = false; MKO.tick(sim, 0.05)
	sc.open_sheet(stalls[0]); await _w(t, 0.6)
	await _shot(t, "s03_station_sheet")
	MKO.set_sub(c, stalls[0], MKO.good_of(stalls[1])); MKO.st().swap.clear()
	MKOU.open_shelf(sc, stalls[0]); await _w(t, 0.6)
	await _shot(t, "s04_shelf_dual")
	sc.close_sheet(); _view.call()
	MKO.set_sub(c, stalls[0], ""); MKO.st().swap.clear(); sim.sst(stalls[1])["unlocked"] = true; MKO.tick(sim, 0.05)
	# 人手面板
	MKOU.open_panel(sc, "pat"); await _w(t, 0.6); await _shot(t, "s05_panel_patrol")
	sc.close_sheet(); _view.call()
	MKOU.open_panel(sc, "ctr"); await _w(t, 0.6); await _shot(t, "s06_panel_counter")
	sc.close_sheet(); _view.call(); await _w(t, 0.3)
	# 四類事件各一（特色版帶描述）；偷錢影「巡邏鬼去追」
	MKO.rng.seed = 7
	MKO.st().till["food"] = 8600.0; MKO.st().ctr_t["food"] = -999.0
	await _ev(t, sim, sc, stalls, "steal_cash", 1, 2.2, "s07_steal_cash_chase")
	for x in MKO.staff_of("pat", "food"): MKO.unassign(sim, x)
	MKO.pop_say(); MKOU._says.clear()
	await _ev(t, sim, sc, stalls, "steal_goods", 1, 1.5, "s08_steal_goods")
	await _ev(t, sim, sc, stalls, "cut_queue", 1, 1.5, "s09_cut_queue")
	var eb = await _ev(t, sim, sc, stalls, "brawl", 1, 1.5, "s10_brawl")
	# 抓到（主角出手）
	MKO.handle_event(sim, int(eb.id)); await _w(t, 0.5); await _shot(t, "s11_caught")
	# 漏網：偷貨冇人理 → 結算
	MKO.st().ev.clear()
	sim.st().counter[MKO.good_of(stalls[0])] = 30.0
	var el = MKO.spawn_event(sim, "food", "steal_goods", 0); el.t = 19.6
	await _w(t, 0.9); await _shot(t, "s12_lost")
	await _w(t, 1.5)
	MKO.st().ev.clear(); MKOU._fx.clear()
	MKO.assign(sim, "pat", "food", "t_u9"); MKO.assign(sim, "pat", "food", "t_u10")
	await _w(t, 0.5); MKO.pop_say(); MKOU._says.clear()
	# 過勞：一攤死頂（第 1 段）、一攤趴低（第 3 段）
	MK.ot(stalls[0]).fat = 78.0; MK.ot(stalls[0]).on = 1
	MK.ot(stalls[1]).down = 40.0; MK.ot(stalls[1]).fat = 100.0
	await _w(t, 1.0); await _shot(t, "s13_overwork")
	MK.ot(stalls[1]).down = 0.0; MK.ot(stalls[1]).fat = 40.0; MK.ot(stalls[0]).fat = 93.0
	await _w(t, 0.6); await _shot(t, "s14_overwork_revive")
	MK.st()["ot"] = {}
	MK.st().erase("ops"); MK.st().erase("test")
	_p("RESULT ok=1 bad=0")
