# [workanim] 名鬼做工動畫測試＋樣本圖
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> wk_anim res://tools/tests/wk_anim_test.gd all|sheet|check|game <秒>
#   check：資料覆蓋（每個採集／加工建築、大排檔每個台都有動作）、25 個動作 × 多隻鬼 × 兩個面向 × 整個循環逐格：
#          工具揸位喺面向嗰邊、工具唔高過頭頂資訊線（−0.98H）、砍樹同主角同步（每下長度＝F.chopTime()、斬中喺 80%）
#   sheet：全部動作逐格圖 /home/claude/docs/shots/work/HC_WorkAnim_All_*.png；
#          樣本 /home/claude/art/out/HC_WorkAnim_Sample.png（主角砍樹 vs 名鬼砍樹並排、一級／二級／三級各幾個）
#   game ：真遊戲畫面：派名鬼去伐木場、棺材鋪、資源田，截圖（村子＋近鏡）
extends RefCounted

var ok := 0
var bad := 0
const WA = preload("res://game/outpost/work_anim.gd")
const SHOTS := "/home/claude/docs/shots/work/"
const OUT := "/home/claude/art/out/"
const KS := ["n30_kappa", "n30_jiugui", "egui", "laojiang", "nw_niexiaoqian", "pocong", "toyol", "zhiren", "n30_nopperabo", "afu"]

func _p(m): print("[wka] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS); DirAccess.make_dir_recursive_absolute(OUT)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	return m

func all(t) -> void:
	var m = await _boot(t)
	_check()
	await _sheets(t)
	await _game(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func check(t) -> void:
	await _boot(t); _check(); _p("RESULT ok=%d bad=%d" % [ok, bad])
func sheet(t) -> void:
	await _boot(t); await _sheets(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func game(t) -> void:
	var m = await _boot(t); await _game(t, m); _p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= check =================
class Probe extends Control:
	var fn: Callable
	func _draw() -> void: fn.call(Ctx.new(self))
func _check() -> void:
	# 資料覆蓋
	var C = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/chain.json"))
	for sec in ["GATHER", "WORKSHOPS"]:
		for bid in C[sec]: _chk("建築有動作 " + bid, WA.verb_of_post(bid) != "", bid)
	for p in ["wood", "rice", "plank", "bun"]: _chk("舊崗位有動作 " + p, WA.verb_of_post(p) != "")
	var O = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/outpost.json"))
	for sid in O.STATIONS:
		var art = str(O.STATIONS[sid].get("art", ""))
		_chk("大排檔台有動作 " + sid, WA.verb_of_stall(art) != "", art)
	for v in WA.POST.values() + WA.STALL.values(): _chk("動作有實作 " + str(v), WA.VERBS.has(v) and WA.TOOL_OF.has(v))
	# 逐格：用錄低指令嘅 Ctx 畫（唔使上畫面）
	var nfr = 0; var worst_top = 0.0; var worst_x = 9.0; var cnt = {}
	for v in WA.VERBS:
		for k in KS:
			if not Art.has_spr(k) and WA._h(k) <= 0: continue
			for fl in [false, true]:
				for i in 48:
					var T = 3.0 + i * 0.061
					var r = Recorder.new(); var ctx = Ctx.new(r, Transform2D.IDENTITY)
					WA.draw(ctx, k, 200.0, 400.0, 1.0, fl, T, v, 3.0, {"piece": "", "icon": "mvi_paper"})
					var L = WA.LAST[k]; nfr += 1
					for j in range(0, L.pts.size(), 2):
						var g: Vector2 = L.pts[j]; var tp: Vector2 = L.pts[j + 1]
						worst_top = minf(worst_top, minf(g.y, tp.y)); worst_x = minf(worst_x, g.x)
						if minf(g.y, tp.y) < WA.TOP: cnt["top|" + v] = cnt.get("top|" + v, 0) + 1
						if g.x < 0.12: cnt["side|" + v] = cnt.get("side|" + v, 0) + 1
	for key in cnt: _chk("工具範圍 " + key, false, cnt[key])
	_chk("逐格畫完冇死", nfr > 1000, nfr)
	_p("check 幀數 %d　工具最高 %.2fH　揸位最近 %.2fH" % [nfr, worst_top, worst_x])
	# 砍樹同主角同步：每下 = chopTime、斬中喺 80%；姿勢曲線同主角一樣（Limbs.state_of afu chop）
	var Th = WA.chop_time()
	var hits = []
	var last = false
	for i in 4000:
		var T = i * 0.001
		var r = Recorder.new(); var ctx = Ctx.new(r, Transform2D.IDENTITY)
		var res = WA.draw(ctx, "egui", 0.0, 0.0, 1.0, false, T, "chop")
		if res.hit and not last: hits.append(T)
		last = res.hit
	_p("chopTime %.3f　斬中時間 %s" % [Th, str(hits.slice(0, 4))])
	_chk("砍樹第一下喺 0.8×chopTime 斬中", hits.size() > 0 and absf(hits[0] - 0.8 * Th) < 0.003, hits)
	_chk("砍樹每下相隔 chopTime", hits.size() >= 3 and absf(hits[1] - hits[0] - Th) < 0.003 and absf(hits[2] - hits[1] - Th) < 0.003, hits)
	for q in [0.0, 0.3, 0.62, 0.7, 0.8, 0.9]:
		var P = WA.chop_pose(q, 0.3, 1.0); var S = Limbs.state_of("afu", "chop", q)
		_chk("砍樹姿勢＝主角 q=%.2f" % q, absf(float(P.th) - float(S.th)) < 0.001 and absf(P.body.sy - float(S.sy)) < 0.001)

# ================= sheets =================
const VNAME := {"chop": "伐木場：砍樹（同主角）", "hack": "後山竹林：劈竹", "split": "破篾棚：破篾", "poke": "椰林：竹竿打椰", "reap": "糯米田：割禾",
	"crank": "枯井轆轤：搖轆轤", "score": "膠園：割膠", "net": "河口罾棚：起罾", "pick": "霧谷茶田：採茶", "scoop": "地庫碳粉房：舀碳粉",
	"saw": "棺材鋪：鋸板", "knead": "包子鋪：擀皮搓包", "dip": "紙寮：撈紙", "grate": "刨椰寮：刨椰絲", "press": "膠片房：壓膠片",
	"twist": "搓繩棚：搓繩", "pound": "紙漿池：舂漿", "stir": "碳粉墨房：攪墨", "wok": "大排檔車頭蓋爆谷：兜鑊", "ladle": "大排檔枯井豆腐花：舀豆花",
	"fold": "大排檔補丁紙衫檔：摺紙衫", "forge": "紙紮兵器檔：錘兵器", "steam": "大排檔嘆氣蒸籠：揭蒸籠", "stamp": "結霜表格室：蓋印", "fan": "椰殼炭爐：撥火", "mill": "大排檔自轉石磨：推磨"}
const VPIECE := {"hack": "bamboo", "pick": "m_tealeaf", "reap": "rice"}
const VICON := {"fold": "mvi_shirt"}
const VK := {"chop": "n30_kappa", "hack": "n30_jiugui", "split": "laojiang", "poke": "egui", "reap": "n30_nopperabo", "crank": "nw_niexiaoqian",
	"score": "n30_kappa", "net": "egui", "pick": "zhiren", "scoop": "toyol", "saw": "laojiang", "knead": "n30_jiugui", "dip": "nw_niexiaoqian",
	"grate": "n30_nopperabo", "press": "egui", "twist": "nw_niexiaoqian", "pound": "pocong", "stir": "n30_kappa", "wok": "n30_jiugui", "ladle": "zhiren",
	"fold": "nw_niexiaoqian", "forge": "laojiang", "steam": "egui", "stamp": "n30_nopperabo", "fan": "toyol", "mill": "egui"}

class Sheet extends Control:
	var rows: Array = []    # {label, cells:[{fn: Callable(ctx, x, y), cap}]}
	var cw := 170.0; var ch := 190.0; var title := ""; var top := 56.0
	func _draw() -> void:
		var f = UIKit.font("sans", 900); var f2 = UIKit.font("sans", 500)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1c1a20"))
		draw_string(f, Vector2(14, 36), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("#f4e2b8"))
		for r in rows.size():
			var y0 = top + r * (ch + 34)
			draw_string(f, Vector2(14, y0 + 22), rows[r].label, HORIZONTAL_ALIGNMENT_LEFT, -1, 19, Color("#f3d68a"))
			for i in rows[r].cells.size():
				var cell = rows[r].cells[i]
				var rc = Rect2(10 + i * cw, y0 + 30, cw - 8, ch)
				draw_rect(rc, Color("#2a2730"))
				draw_line(Vector2(rc.position.x + 6, rc.end.y - 30), Vector2(rc.end.x - 6, rc.end.y - 30), Color(0.4, 0.36, 0.3), 1.0)
				var ctx = Ctx.new(self)
				ctx.save(); ctx.beginPath(); ctx.rect(rc.position.x, rc.position.y, rc.size.x, rc.size.y); ctx.clip()
				cell.fn.call(ctx, rc.position.x + rc.size.x * 0.27, rc.end.y - 30)
				ctx.restore()
				draw_string(f2, Vector2(rc.position.x + 6, rc.end.y - 8), str(cell.cap), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("#d8d0c0"))

func _render(t, sh: Sheet, path: String) -> void:
	var root = t.get_tree().root
	var sv = SubViewport.new(); sv.size = Vector2i(sh.size); sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sv.transparent_bg = false
	root.add_child(sv); sv.add_child(sh)
	await _f(t, 3); await RenderingServer.frame_post_draw
	sv.get_texture().get_image().save_png(path); _p("shot " + path)
	sv.queue_free()

static func _sc(k: String, H := 104.0) -> float: return H / WA._h(k)
func _wa_cell(k: String, v: String, T: float, cap: String) -> Dictionary:
	var opt = {"piece": VPIECE.get(v, ""), "icon": VICON.get(v, "mvi_paper")}
	return {"fn": func(ctx, x, y): WA.draw(ctx, k, x, y, _sc(k), false, T, v, 3.0, opt), "cap": cap}
func _cyc(v: String) -> float:
	var Th = WA.chop_time()
	match v:
		"chop", "hack", "split": return Th * 3 + 0.6
		"reap": return Th * 1.4
		"saw": return 2.5
		"knead": return 2.68
		"crank": return 1.1 * 4 + 0.8
		"stamp": return 2.6
	return {"poke": 1.6, "score": 1.5, "net": 3.0, "pick": 0.9, "scoop": 1.5, "dip": 2.6, "grate": 0.5, "press": 1.4, "twist": 2.6, "pound": 0.9,
		"stir": 1.6, "mill": 1.6, "wok": 1.0, "ladle": 1.8, "fold": 2.2, "forge": 0.9, "steam": 2.0, "fan": 0.55}.get(v, 1.0)

func _sheets(t) -> void:
	# 全部動作：每個 7 格（一個循環）
	var vs: Array = WA.VERBS
	for part in 3:
		var sh = Sheet.new(); sh.cw = 205.0; sh.ch = 190.0
		var lst = vs.slice(part * 9, mini(vs.size(), part * 9 + 9))
		sh.title = "名鬼做工動畫（工具浮喺面向嗰邊）全部動作 %d/3" % (part + 1)
		for v in lst:
			var k = VK[v]; var cells = []; var cy = _cyc(v)
			for i in 7:
				var T = cy * i / 7.0
				cells.append(_wa_cell(k, v, T, "%.2f 秒" % T))
			sh.rows.append({"label": "%s　（%s，工具：%s）" % [VNAME[v], k, WA.TOOL_OF[v]], "cells": cells})
		sh.size = Vector2(14 + 7 * sh.cw, sh.top + lst.size() * (sh.ch + 34) + 10)
		await _render(t, sh, SHOTS + "HC_WorkAnim_All_%d.png" % (part + 1))
	# 樣本：主角砍樹 vs 名鬼砍樹（同一刻）、一級／二級／三級
	var S = Sheet.new(); S.cw = 205.0; S.ch = 200.0
	var Th = WA.chop_time()
	S.title = "做工動畫樣本：主角砍樹節奏 = 名鬼砍樹節奏（每下 %.2f 秒；62%% 舉高、80%% 斬中）" % Th
	var qs = [0.0, 0.3, 0.55, 0.62, 0.7, 0.8, 0.9, 1.0]
	var hero = []; var gh = []; var gh2 = []
	for q in qs:
		var qq = q
		hero.append({"fn": func(ctx, x, y): Art.draw_char(ctx, "afu", x, y, _sc("afu"), {"t": 1.0, "work": true, "pose": "chop", "pt": minf(qq, 0.999), "solid": true}), "cap": "%.2f 秒 %s" % [q * Th, "斬中" if q == 0.8 else ""]})
		gh.append(_wa_cell("n30_kappa", "chop", Th + q * Th, "%.2f 秒 %s" % [q * Th, "斬中" if q == 0.8 else ""]))
		gh2.append(_wa_cell("egui", "chop", Th * 2 + q * Th, "%.2f 秒 %s" % [q * Th, "斬中" if q == 0.8 else ""]))
	S.rows.append({"label": "主角阿福砍樹（現行遊戲畫面，一下）", "cells": hero})
	S.rows.append({"label": "名鬼河童放入伐木場（同一下、同一刻）：斧頭浮喺面向嗰邊揮斬", "cells": gh})
	S.rows.append({"label": "名鬼餓鬼放入伐木場（同一節奏；第三下斬開條木）", "cells": gh2})
	var tier = [["一級採集　枯井轆轤：搖轆轤吊水", "nw_niexiaoqian", "crank"], ["一級採集　糯米田：鐮刀割禾", "n30_nopperabo", "reap"],
		["二級加工　包子鋪：擀麵棍碌皮、變包", "n30_jiugui", "knead"], ["二級加工　棺材鋪：鋸板", "laojiang", "saw"], ["二級加工　紙寮：竹簾撈紙", "nw_niexiaoqian", "dip"],
		["三級　大排檔車頭蓋爆谷：兜鑊", "n30_jiugui", "wok"], ["三級　紙紮兵器檔：木槌錘兵器", "laojiang", "forge"]]
	for e in tier:
		var cells = []; var cy = _cyc(e[2])
		for i in 8: cells.append(_wa_cell(e[1], e[2], cy * i / 8.0, "%.2f 秒" % (cy * i / 8.0)))
		S.rows.append({"label": e[0] + "（%s）" % e[1], "cells": cells})
	S.size = Vector2(14 + 8 * S.cw, S.top + S.rows.size() * (S.ch + 34) + 10)
	await _render(t, S, OUT + "HC_WorkAnim_Sample.png")

# ================= game：真遊戲畫面 =================
func _cam(m, p: Vector2, z: float) -> void:
	var c = m.village.zone_cam()
	c.z = m.village.size.x / z; c.clamp_all(); c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)
func _shot(t, name: String) -> Image:
	await RenderingServer.frame_post_draw
	var img = t.get_viewport().get_texture().get_image(); img.save_png(SHOTS + name + ".png"); _p("shot " + name)
	return img
func _crop(t, m, img: Image, wp: Vector2, sz := Vector2(200, 170), k := 2.2) -> Image:
	var sp = (m.village.get_global_rect().position + m.village.zone_cam().w2s(wp)) * Vector2(img.get_size()) / t.get_viewport().get_visible_rect().size
	var r = Rect2i(Vector2i(clampi(int(sp.x - sz.x / 2), 0, img.get_width() - int(sz.x)), clampi(int(sp.y - sz.y / 2), 0, img.get_height() - int(sz.y))), Vector2i(sz))
	var c = img.get_region(r); c.resize(int(sz.x * k), int(sz.y * k), Image.INTERPOLATE_LANCZOS)
	return c
const GAME := [["n30_kappa", "wood"], ["egui", "wood"], ["laojiang", "plank"], ["n30_jiugui", "bun"], ["n30_nopperabo", "rice"],
	["nw_niexiaoqian", "b_well"], ["zhiren", "b_bamboo"], ["toyol", "b_paper"]]
func _game(t, m) -> void:
	var S = J.G.S
	var base: Dictionary = S.ghosts[0]
	var ZD = load("res://game/zone/zone_data.gd")
	for b in ["b_well", "b_bamboo", "b_paper"]:
		S.bld[b] = 1
		var zid = ZD.bid_zone(b)
		if zid != "": ZD.set_owned(zid)
	for i in GAME.size():
		var g = base.duplicate(true); g["k"] = GAME[i][0]; g["id"] = 9100 + i; g["post"] = GAME[i][1]
		S.ghosts.append(g)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 1.5)
	var V = J.G.Village
	var spots = J.mc(V, "workerSpots", [])
	var by = {}
	for sp in spots:
		var post = str(J.gp(sp, "post"))
		if WA.verb_of_post(post) != "" and not by.has(post): by[post] = Vector2(J.num(sp.x), J.num(sp.y))
	_p("spots " + str(by))
	for e in GAME: _chk("派工位有企位 " + e[1], by.has(e[1]), by.keys())
	var n = 0
	var row = []
	for post in by:
		var wp: Vector2 = by[post]
		_cam(m, wp + Vector2(20, -30), 150.0)
		await _w(t, 0.9)
		var img = await _shot(t, "HC_WorkAnim_Game_%s" % post)
		var c = _crop(t, m, img, wp + Vector2(16, -22), Vector2(150, 120), 3.0)
		c.save_png(SHOTS + "HC_WorkAnim_Game_%s_zoom.png" % post); row.append(c); n += 1
		var L = WA.LAST.get(_k_of(post), {})
		_chk("遊戲入面畫到做工動畫 " + post, str(L.get("verb", "")) == WA.verb_of_post(post), L.get("verb"))
	# 拼一張
	if row.size() > 0:
		var cw = row[0].get_width(); var chh = row[0].get_height(); var cols = 4
		var out = Image.create(cw * cols, chh * int(ceil(row.size() / float(cols))), false, Image.FORMAT_RGBA8)
		for i in row.size(): out.blit_rect(row[i], Rect2i(0, 0, cw, chh), Vector2i((i % cols) * cw, (i / cols) * chh))
		out.save_png(SHOTS + "HC_WorkAnim_Game_all.png")
	_chk("遊戲截圖數", n >= 6, n)
	# 大排檔員工
	await _stall(t, m)
func _k_of(post: String) -> String:
	for e in GAME: if e[1] == post: return e[0]
	return ""
const MD = preload("res://game/outpost/mv_data.gd")
func _scr(m, wp: Vector2) -> Vector2:
	var k = m.village.size.x / 390.0
	var cy = J.num(J.G.Village.get("camY"))
	var vp = m.get_viewport(); var f = float(vp.get_texture().get_width()) / vp.get_visible_rect().size.x
	return (m.village.get_global_rect().position + Vector2(wp.x * k, (wp.y - m.mv_embed.eh() - cy) * k)) * f
func _look(t, m, wy: float) -> void:
	var vh = m.village.size.y / (m.village.size.x / 390.0)
	J.mc(J.G.Village, "setCam", [wy - m.mv_embed.eh() - vh * 0.5]); await _w(t, 0.3)
func _strip2(t, m, name: String, pts: Array, n := 8, dt := 0.12, cw := 110, ch := 110) -> void:
	var out = Image.create(cw * n * 2, ch * pts.size() * 2, false, Image.FORMAT_RGBA8)
	for i in n:
		await RenderingServer.frame_post_draw
		var img = t.get_viewport().get_texture().get_image()
		for j in pts.size():
			var sp = _scr(m, pts[j])
			var r = Rect2i(int(sp.x - cw * 0.35), int(sp.y - ch * 0.8), cw, ch)
			r.position.x = clampi(r.position.x, 0, img.get_width() - cw); r.position.y = clampi(r.position.y, 0, img.get_height() - ch)
			var sub = img.get_region(r); sub.resize(cw * 2, ch * 2, Image.INTERPOLATE_BILINEAR)
			out.blit_rect(sub, Rect2i(0, 0, cw * 2, ch * 2), Vector2i(i * cw * 2, j * ch * 2))
		await _w(t, dt)
	out.save_png(SHOTS + name + ".png"); _p("strip " + name)
func _stall(t, m) -> void:
	if m.get("mv_view") == null or m.get("mv_embed") == null: _p("冇大排檔畫面，跳過"); return
	var sc = m.mv_view; var sim = sc.sim
	for sid in MD.stations(0): sim.sst(sid).unlocked = true
	await _w(t, 0.3)
	sim.paused = true; sim.custs.clear(); sim.foes.clear(); sim.workers.clear(); sim._sync_key = "x"
	var kinds = ["n30_jiugui", "laojiang", "zhiren", "egui", "n30_kappa", "nw_niexiaoqian", "n30_nopperabo", "toyol"]
	var sids = MD.stations(0)
	var pts = []; var want = {}
	for i in sids.size():
		var p = sim.slot_pos(sids[i], 1)
		var k = kinds[i % kinds.size()]
		sim.workers.append({"gid": "g_wk%d" % i, "k": k, "name": k, "sid": sids[i], "slot": 0, "st": "work", "prog": 0.2, "pos": p, "home": p, "carry": 0, "t": 0.0, "s": 0.0, "ph": i * 1.3, "paid": {}})
		pts.append(p); want[k + "|" + sids[i]] = WA.verb_of_stall(str(MD.st_def(sids[i]).get("art", "")))
	_p("大排檔台 %s" % str(sids))
	# 經遊戲真正嘅員工畫法（mv_scene._draw_worker → mv_motion.worker → WA）逐格畫，放大 2.2 倍
	var sh = Sheet.new(); sh.cw = 205.0; sh.ch = 190.0
	sh.title = "大排檔員工（遊戲真畫法 mv_motion.worker，放大 2.2 倍）"
	var t0 = float(sc.t)
	for i in sids.size():
		var w = sim.workers[i]; var v = WA.verb_of_stall(str(MD.st_def(sids[i]).get("art", "")))
		var cells = []
		var cy = _cyc(v)
		for f in 7:
			var tt = t0 + 5.0 + cy * f / 7.0 - float(w.ph)
			var ww = w
			cells.append({"fn": func(ctx, x, y):
				sc.t = tt; ww["pos"] = Vector2(0, 0)
				ctx.save(); ctx.translate(x + 14, y); ctx.scale(2.2, 2.2)
				sc.mot.worker(sc, ctx, ww)
				ctx.restore(), "cap": "%.2f 秒" % (cy * f / 7.0)})
		sh.rows.append({"label": "%s（%s）　%s：工具 %s" % [MD.T(MD.st_def(sids[i]).get("n", ["?", "?"])), w.k, v, WA.TOOL_OF.get(v, "")], "cells": cells})
	sh.size = Vector2(14 + 7 * sh.cw, sh.top + sh.rows.size() * (sh.ch + 34) + 10)
	await _render(t, sh, SHOTS + "HC_WorkAnim_Stalls.png")
	sc.t = t0
	var seen = sc.mot.seen
	for key in want:
		var k = key.get_slice("|", 0)
		_chk("大排檔員工用做工動畫 " + key, seen.get(k, {}).has("wa_" + want[key]), seen.get(k, {}).keys())
	sim.workers.clear(); sim.paused = false
