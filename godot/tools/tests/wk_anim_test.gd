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
	_edge_check()
	await _sheets(t)
	await _edge_sheets(t)
	await _game(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func check(t) -> void:
	await _boot(t); _check(); _edge_check(); _p("RESULT ok=%d bad=%d" % [ok, bad])
func edge(t) -> void:
	await _boot(t); _edge_check(); await _edge_sheets(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
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
	"fold": "大排檔補丁紙衫檔：摺紙衫", "forge": "紙紮兵器檔：錘兵器", "steam": "大排檔嘆氣蒸籠：揭蒸籠", "stamp": "結霜表格室：蓋印", "fan": "椰殼炭爐：撥火", "mill": "大排檔自轉石磨：推磨",
	"fork": "禾稈草堆：叉禾稈上堆", "tongs": "橋底回收站：夾報紙", "sew": "補丁紙衫檔：縫紙衫", "brush": "怕黑燈籠：掃漿糊糊紙", "paint": "紙紮電器檯：油掃上色",
	"catch": "樹下等榴槤：竹籮接榴槤", "pump": "水底吹救生圈：打氣", "slice": "割膠拖鞋廠：切鞋底", "pull": "長臂凍檸茶：拉茶", "salt": "碟頂鹹魚：抖鹽",
	"plane": "頂樓棺材板躺椅：刨板", "screw": "停咗錶檔：扭螺絲"}
const VPIECE := {"hack": "bamboo", "pick": "m_tealeaf", "reap": "rice"}
const VICON := {"fold": "mvi_shirt"}
const VK := {"chop": "n30_kappa", "hack": "n30_jiugui", "split": "laojiang", "poke": "egui", "reap": "n30_nopperabo", "crank": "nw_niexiaoqian",
	"score": "n30_kappa", "net": "egui", "pick": "zhiren", "scoop": "toyol", "saw": "laojiang", "knead": "n30_jiugui", "dip": "nw_niexiaoqian",
	"grate": "n30_nopperabo", "press": "egui", "twist": "nw_niexiaoqian", "pound": "pocong", "stir": "n30_kappa", "wok": "n30_jiugui", "ladle": "zhiren",
	"fold": "nw_niexiaoqian", "forge": "laojiang", "steam": "egui", "stamp": "n30_nopperabo", "fan": "toyol", "mill": "egui",
	"fork": "laojiang", "tongs": "toyol", "sew": "nw_niexiaoqian", "brush": "zhiren", "paint": "n30_kappa", "catch": "n30_jiugui", "pump": "egui",
	"slice": "n30_kappa", "pull": "zhiren", "salt": "toyol", "plane": "laojiang", "screw": "n30_nopperabo"}

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
				cell.fn.call(ctx, rc.position.x + rc.size.x * float(cell.get("ax", 0.27)), rc.end.y - 30)
				ctx.restore()
				draw_string(f2, Vector2(rc.position.x + 6, rc.end.y - 8), str(cell.cap), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("#a8ffcf") if cell.get("good", false) else Color("#d8d0c0"))
				if cell.has("top"):
					draw_rect(Rect2(rc.position + Vector2(4, 4), Vector2(rc.size.x - 8, 24)), Color(0.08, 0.06, 0.08, 0.8))
					draw_string(f, rc.position + Vector2(10, 22), str(cell.top), HORIZONTAL_ALIGNMENT_LEFT, rc.size.x - 16, 15, Color("#f4e2b8"))

func _render(t, sh: Control, path: String) -> void:
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
	return {"poke": 1.6, "score": 1.5, "net": 3.0, "pick": 0.9, "scoop": 1.8, "dip": 2.6, "grate": 0.5, "press": 1.4, "twist": 2.6, "pound": 0.9,
		"stir": 1.6, "mill": 1.6, "wok": 1.0, "ladle": 1.8, "fold": 2.2, "forge": 0.9, "steam": 2.0, "fan": 0.55,
		"fork": 1.6, "tongs": 1.5, "sew": 1.2, "brush": 1.4, "paint": 1.4, "catch": 2.2, "pump": 0.8, "slice": 0.9, "pull": 1.8, "salt": 0.5, "plane": 1.1, "screw": 1.6}.get(v, 1.0)

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
# 近鏡（超過玩家最大縮放，純粹為咗睇清楚；同一個遊戲畫法）：u＝畫面闊睇到幾多世界單位
func _cam_close(m, p: Vector2, u: float) -> void:
	var c = m.village.zone_cam()
	c.tgt = null; c.vel = Vector2.ZERO; c.z = m.village.size.x / u
	c.x = p.x - c.vw() / 2.0; c.y = p.y - c.vh() / 2.0
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

# ================= props：資源田「保留工作物」vs「去掉、只留工具動作」實機對照 =================
const FIELDS := [[0, "wood", "伐木場（槐樹林）", "n30_kappa"], [0, "rice", "糯米田", "n30_nopperabo"], [0, "b_well", "枯井轆轤", "nw_niexiaoqian"],
	[0, "b_bamboo", "後山竹林", "zhiren"], [0, "b_straw", "禾稈草堆", "laojiang"], [1, "b_coco", "椰林", "egui"], [1, "b_latex", "膠園", "n30_kappa"],
	[2, "b_tea", "霧谷茶田", "zhiren"], [3, "b_banana", "蕉園", "n30_jiugui"], [3, "b_fish", "河口罾棚", "egui"],
	[4, "b_newspaper", "橋底回收站", "toyol"], [5, "b_toner", "地庫碳粉房", "laojiang"]]
func props(t) -> void:
	var m = await _boot(t)
	var S = J.G.S; var ZD = load("res://game/zone/zone_data.gd")
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 1.0)
	var base: Dictionary = S.ghosts[0]
	var rows = []   # [名, 有, 冇]
	var sc = m.mv_view
	for c in 6:
		if c > 0:
			sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.5)
			if m.has_method("_nav_on"): m._nav_on("village")
			await _w(t, 1.0)
		var todo = FIELDS.filter(func(e): return e[0] == c)
		var gs = []
		for e in todo:
			if e[1].begins_with("b_"):
				S.bld[e[1]] = 1
				var zid = ZD.bid_zone(e[1])
				if zid != "": ZD.set_owned(zid)
			var g = base.duplicate(true); g["k"] = e[3]; g["id"] = 9300 + FIELDS.find(e); g["post"] = e[1]
			S.ghosts.append(g); gs.append(g)
		await _w(t, 0.8)
		var spots = J.mc(J.G.Village, "workerSpots", [])
		for e in todo:
			var wp = null
			for sp in spots: if str(J.gp(sp, "post")) == e[1]: wp = Vector2(J.num(sp.x), J.num(sp.y)); break
			_chk("對照：%s 有企位（第 %d 張圖）" % [e[2], c + 1], wp != null)
			if wp == null: continue
			var fl = false
			for sp in spots: if str(J.gp(sp, "post")) == e[1]: fl = J.t(J.gp(sp, "flip")); break
			var cxw = wp + Vector2(-14.0 if fl else 14.0, -28)
			_cam_close(m, cxw, 112.0); await _w(t, 0.6)
			var pair = []
			var old_fp = WA.FIELD_PROPS.get(e[1])
			for on in [true, false]:
				WA.FIELD_PROPS[e[1]] = on
				await _f(t, 3)
				var img = await _shot(t, "HC_WorkAnim_Props_%s_%s" % [e[1], "on" if on else "off"])
				pair.append(_crop(t, m, img, cxw, Vector2(420, 330), 0.95))
				var L = WA.LAST.get(e[3], {})
				_chk("對照：%s 畫到做工動畫（%s）" % [e[2], "有工作物" if on else "冇工作物"], str(L.get("verb", "")) == WA.verb_of_post(e[1]))
			if old_fp == null: WA.FIELD_PROPS.erase(e[1])
			else: WA.FIELD_PROPS[e[1]] = old_fp
			rows.append([e[2] + "（%s）" % WA.TOOL_OF.get(WA.verb_of_post(e[1]), ""), pair[0], pair[1]])
		for g in gs: S.ghosts.erase(g)
	# 拼圖：每行 建築名 ｜ 保留 ｜ 去掉
	var cw = rows[0][1].get_width() if rows.size() > 0 else 390; var chh = rows[0][1].get_height() if rows.size() > 0 else 312
	var head = 64; var lab = 38
	var sh = PropSheet.new(); sh.rows = rows
	for r in rows: sh.texs.append([ImageTexture.create_from_image(r[1]), ImageTexture.create_from_image(r[2])])   # 貼圖要留住（喺 _draw 入面臨時建會被釋放 → 白格）
	sh.cw = cw; sh.chh = chh; sh.head = head; sh.lab = lab
	sh.size = Vector2(16 + cw * 2 + 16, head + rows.size() * (chh + lab + 10))
	await _render(t, sh, OUT + "HC_WorkAnim_Props_Compare.png")
	_chk("對照行數", rows.size() >= 10, rows.size())
	_p("RESULT ok=%d bad=%d" % [ok, bad])
class PropSheet extends Control:
	var rows: Array = []; var texs: Array = []; var cw := 390; var chh := 312; var head := 64; var lab := 38
	func _draw() -> void:
		var f = UIKit.font("sans", 900)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1c1a20"))
		draw_string(f, Vector2(16, 30), "資源田對照（真遊戲村子近鏡）", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("#f4e2b8"))
		draw_string(f, Vector2(16, 56), "左：保留名鬼面前工作物　　右：去掉、只留工具動作（靠地圖原本嘅井／竹叢／樹）", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("#d8d0c0"))
		for i in rows.size():
			var y = head + i * (chh + lab + 10)
			draw_string(f, Vector2(16, y + 27), str(rows[i][0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("#f3d68a"))
			for j in 2:
				var tex = texs[i][j]
				var r = Rect2(16 + j * (cw + 8 - 8), y + lab, cw - 4, chh)
				draw_texture_rect(tex, r, false)
				draw_rect(r, Color(0.5, 0.44, 0.3), false, 2.0)
				var tag = "保留工作物" if j == 0 else "去掉工作物"
				draw_rect(Rect2(r.position + Vector2(6, 6), Vector2(118, 28)), Color(0.08, 0.06, 0.08, 0.85))
				draw_string(f, r.position + Vector2(14, 27), tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("#f4e2b8") if j == 0 else Color("#a8ffcf"))


# ================= 刀口／工作面朝向（老闆 11-26：「目標喺邊，刀鋒就向邊」）=================
# 每個動作逐格（兩個面向）：有「hit」（斬中／工作嗰刻）嘅格，
#   工作面法向量 vs 「工作面 → 目標」方向夾角 < 45°；有 surf 嘅（斬／鋸／錘／蓋印）刀口要壓住目標面（距離 < 0.05H）；
#   「touch」類（搖柄、推柄）工作點要喺軸／柄上（< 0.03H）；面向左＝面向右嘅正確鏡像；
#   斧頭／柴刀舉起同揮落途中刀口唔可以向返自己（面向方向分量 > −0.25）。
const EK := ["n30_kappa", "egui", "laojiang"]
var EDGE_HIT := {}    # verb → {T, ang, dist}（面向右第一下斬中）
static func _seg_cp(a: Vector2, b: Vector2, p: Vector2) -> Vector2:
	var d = b - a; var l2 = d.length_squared()
	if l2 < 1e-9: return a
	return a + d * clampf((p - a).dot(d) / l2, 0, 1)
static func _eval(ed: Dictionary) -> Dictionary:
	var tls: Array = ed.get("tools", [])
	if tls.is_empty() or not ed.has("tgt"): return {}
	var ti = int(ed.ti); var T = tls[ti if ti >= 0 else tls.size() + ti]
	var cp = _seg_cp(T.a, T.b, ed.tgt)
	var mid = cp if ed.get("near", false) else (T.a + T.b) * 0.5   # 夾角用工作面中點量（唔用最近點，免得斜邊自動變 0°）
	var dir: Vector2 = ed.tdir if ed.has("tdir") else (ed.tgt - mid).normalized()
	var r = {"id": T.id, "cp": cp, "n": T.n, "dir": dir, "ang": rad_to_deg(absf(T.n.angle_to(dir))), "touch": (ed.tgt - cp).length() / float(ed.H)}
	if ed.has("surf"): r["dist"] = (_seg_cp(T.a, T.b, ed.surf) - ed.surf).length() / float(ed.H)
	return r
func _edge_draw(k: String, v: String, T: float, fl: bool, x := 200.0, y := 400.0, sc := 1.0, ctx = null) -> Dictionary:
	if ctx == null: ctx = Ctx.new(Recorder.new(), Transform2D.IDENTITY)
	var pc = {"hack": "bamboo", "reap": "rice"}.get(v, "")
	WA.draw(ctx, k, x, y, sc, fl, T, v, 3.0, {"piece": pc, "icon": "mvi_paper"})
	return WA.LAST[k].edge
func _edge_check() -> void:
	var tot = 0; var worst = {}
	for v in WA.VERBS:
		var cy = _cyc(v); var n = int(ceil(cy * 2.0 / 0.005))
		var hits = 0; var wa = 0.0; var wd = 0.0; var bad_ang = 0; var bad_d = 0; var bad_mir = 0; var bad_raise = 0; var none = false
		for k in EK:
			for i in n:
				var T = 3.0 + i * 0.005
				var eR = _edge_draw(k, v, T, false); var eL = _edge_draw(k, v, T, true)
				if eR.ck == "none": none = true; break
				# 鏡像：面向左嘅工作面法向量＝面向右嘅左右對調
				for j in mini(eR.tools.size(), eL.tools.size()):
					var nR: Vector2 = eR.tools[j].n; var nL: Vector2 = eL.tools[j].n
					if absf(nR.x + nL.x) > 1e-3 or absf(nR.y - nL.y) > 1e-3: bad_mir += 1
				if v in ["chop", "hack", "split"]:
					for e in [eR, eL]:
						var ph = float(e.ph)
						if ph > 0.0 and ph < 0.8 and e.tools.size() > 0 and float(e.fd) * e.tools[0].n.x < -0.25: bad_raise += 1
				for e in [eR, eL]:
					if not e.hit: continue
					var r = _eval(e)
					if r.is_empty(): continue
					hits += 1; tot += 1
					if e.ck == "touch":
						wd = maxf(wd, r.touch)
						if r.touch > 0.03: bad_d += 1
					else:
						wa = maxf(wa, r.ang)
						if r.ang >= 45.0: bad_ang += 1
						if r.has("dist"):
							wd = maxf(wd, r.dist)
							if r.dist > 0.05: bad_d += 1
					if k == EK[0] and e.fd > 0 and not EDGE_HIT.has(v): EDGE_HIT[v] = {"T": T, "ang": r.ang, "dist": r.get("dist", r.touch), "ck": e.ck, "id": r.id}
			if none: break
		if none:
			_p("edge %-6s （%s）冇刃：唔適用" % [v, WA.TOOL_OF[v]]); EDGE_HIT[v] = {"T": 3.0, "ang": 0.0, "dist": 0.0, "ck": "none", "id": ""}
			continue
		_p("edge %-6s （%s）工作格 %d　最大夾角 %.1f°　最遠 %.3fH　壞：角 %d 距 %d 鏡像 %d 舉刀向自己 %d" % [v, WA.TOOL_OF[v], hits, wa, wd, bad_ang, bad_d, bad_mir, bad_raise])
		_chk("刀口朝目標有工作格 " + v, hits > 0, hits)
		_chk("刀口朝目標 < 45° " + v, bad_ang == 0, "%d 格，最大 %.1f°" % [bad_ang, wa])
		_chk("刀口壓住目標 " + v, bad_d == 0, "%d 格，最遠 %.3fH" % [bad_d, wd])
		_chk("面向左正確鏡像 " + v, bad_mir == 0, bad_mir)
		_chk("舉起時刀口唔向自己 " + v, bad_raise == 0, bad_raise)
	_p("edge 總工作格 %d" % tot)
	# 斧頭：原圖刀口喺右（+u），唔准再鏡像
	_chk("斧頭原圖唔鏡像（刀口喺 +x）", not WA.SPR_TOOL.axe[5])
	# 音效掛點：每個動作都有事件名，兩個循環內至少觸發一次
	for v in WA.VERBS:
		_chk("音效事件名 " + v, str(WA.SFX.get(v, "")).begins_with("wk_"), v)
		WA.SFX_LOG.clear(); WA._beat.clear()
		var cy = _cyc(v)
		for i in int(cy * 2.0 / 0.01): _edge_draw("egui", v, 3.0 + i * 0.01, false)
		var nb = WA.SFX_LOG.size()
		_chk("音效掛點會觸發 " + v, nb >= 1, nb)
		_p("sfx %-6s %-18s 兩個循環觸發 %d 次" % [v, WA.SFX[v], nb])
	# 資源田預設：6 塊唔畫工作物
	for b in ["b_well", "b_bamboo", "b_banana", "b_coco", "b_latex", "b_straw"]: _chk("預設去掉工作物 " + b, not WA.props_for(b))
	for b in ["wood", "b_wood", "rice", "b_tea", "b_fish", "b_newspaper", "b_toner"]: _chk("預設保留工作物 " + b, WA.props_for(b))
	var n0 = WA.edge_n("axe", deg_to_rad(90.0))
	_chk("斧頭打橫向前時刀口向落", n0.y > 0.95, n0)

func _edge_sheets(t) -> void:
	# 特寫：每種工具斬中／工作嗰刻，以工作面為中心放大 2 倍；綠箭＝刀口／工作面朝向，紅圈＝目標
	var sh = Sheet.new(); sh.cw = 250.0; sh.ch = 250.0; sh.top = 60.0
	sh.title = "刀口／工作面朝向特寫（斬中／工作嗰一刻，以工作面為中心放大 2 倍）　綠箭＝刀口朝向　紅圈＝目標"
	var list = []
	for v in WA.VERBS: list.append([v, false])
	for v in ["chop", "hack", "split", "reap", "score", "saw", "forge"]: list.append([v, true])
	var cells = []
	for e in list:
		var v: String = e[0]; var fl: bool = e[1]
		var H0 = EDGE_HIT.get(v, {"T": 3.0, "ang": 0.0, "ck": "none"})
		var k = EK[0]; var T = float(H0.T)
		var cap = "刀口朝目標：已檢查（夾角 %d°）" % int(round(H0.ang))
		if H0.ck == "none": cap = "摺紙冇刃：唔適用"
		elif H0.ck == "touch": cap = "工作點貼住軸／柄：已檢查"
		cells.append({"top": "%s %s・%s" % ["◀面向左" if fl else "▶", VNAME[v].get_slice("：", 1), WA.TOOL_OF[v]], "cap": cap, "good": H0.ck != "none", "ax": 0.5,
			"fn": func(ctx, x, y): _edge_cell(ctx, k, v, T, fl, x, y - 100)})
	var per = 7; var nv = WA.VERBS.size()
	for i in range(0, nv, per): sh.rows.append({"label": "面向右　%d–%d" % [i + 1, mini(i + per, nv)], "cells": cells.slice(i, mini(i + per, nv))})
	var lefts = cells.slice(nv)
	for i in range(0, lefts.size(), per): sh.rows.append({"label": "面向左（正確鏡像）", "cells": lefts.slice(i, mini(i + per, lefts.size()))})
	sh.size = Vector2(14 + per * sh.cw, sh.top + sh.rows.size() * (sh.ch + 34) + 10)
	await _render(t, sh, OUT + "HC_WorkAnim_Edge_Check.png")
	await _sample2(t)
func _sample2(t) -> void:
	# 樣本 v2：砍樹／劈竹／破篾放大（面向右、面向左各一行），其他工具一行一個
	var Th = WA.chop_time()
	var S = Sheet.new(); S.cw = 290.0; S.ch = 250.0; S.top = 60.0
	S.title = "做工動畫樣本 v2（刀口修正）：刀口＝領先嗰邊，斬中嗰刻刀口斜斜咬入目標；面向左右都啱"
	var qs = [0.0, 0.3, 0.62, 0.7, 0.76, 0.8, 0.84, 0.95]
	for e in [["chop", "n30_kappa", "伐木場：斧頭砍樹（放大）"], ["hack", "n30_jiugui", "後山竹林：柴刀劈竹（放大）"], ["split", "laojiang", "破篾棚：柴刀破篾（放大）"]]:
		for fl in [false, true]:
			var cells = []
			for q in qs:
				var v: String = e[0]; var k: String = e[1]; var T = Th * 2 + q * Th; var ffl = fl
				var cap = "%.2f 秒%s" % [q * Th, "　斬中" if q == 0.8 else ("　舉高" if q == 0.62 else "")]
				cells.append({"cap": cap, "good": q == 0.8, "ax": 0.74 if fl else 0.26,
					"fn": func(ctx, x, y): WA.draw(ctx, k, x, y + 4, _sc(k, 135.0), ffl, T, v, 3.0, {"piece": "bamboo" if v == "hack" else "", "icon": "mvi_paper"})})
			S.rows.append({"label": "%s　%s（%s）" % [e[2], "◀ 面向左" if fl else "▶ 面向右", e[1]], "cells": cells})
	for e in [["reap", "n30_nopperabo"], ["score", "n30_kappa"], ["saw", "laojiang"], ["forge", "laojiang"], ["wok", "n30_jiugui"], ["ladle", "zhiren"], ["scoop", "toyol"], ["fan", "toyol"], ["grate", "n30_nopperabo"]]:
		var v: String = e[0]; var k: String = e[1]; var cells = []; var cy = _cyc(v)
		for i in 8:
			var T = 3.0 + cy * i / 8.0
			cells.append({"cap": "%.2f 秒" % (cy * i / 8.0), "fn": func(ctx, x, y): WA.draw(ctx, k, x, y, _sc(k, 110.0), false, T, v, 3.0, {"piece": VPIECE.get(v, ""), "icon": "mvi_paper"})})
		S.rows.append({"label": "%s（%s，工具：%s）" % [VNAME[v], k, WA.TOOL_OF[v]], "cells": cells})
	S.size = Vector2(14 + 8 * S.cw, S.top + S.rows.size() * (S.ch + 34) + 10)
	await _render(t, S, OUT + "HC_WorkAnim_Sample_v2.png")
func _edge_cell(ctx, k: String, v: String, T: float, fl: bool, cxp: float, cyp: float) -> void:
	var sc = _sc(k, 104.0)
	var e0 = _edge_draw(k, v, T, fl, 0.0, 0.0, sc)
	var r = _eval(e0)
	var c0: Vector2 = r.cp if not r.is_empty() else Vector2(0, -50)
	if r.is_empty() and e0.tools.size() > 0: c0 = e0.tools[0].a
	var Z = {"catch": 1.2, "pull": 1.3, "fork": 1.6}.get(v, 2.0)   # 大件／高嘅動作少放大啲，唔好爆格
	ctx.save(); ctx.translate(cxp, cyp); ctx.scale(Z, Z); ctx.translate(-c0.x, -c0.y)
	var e = _edge_draw(k, v, T, fl, 0.0, 0.0, sc, ctx)
	ctx.restore()
	if r.is_empty(): return
	var p = Vector2(cxp, cyp)
	var tg = p + (e0.tgt - c0) * Z
	ctx.lineCap = "round"
	ctx.strokeStyle = "#ff5a4a"; ctx.lineWidth = 2.0; ctx.beginPath(); ctx.arc(tg.x, tg.y, 6, 0, TAU); ctx.stroke()
	var n: Vector2 = r.n; var q = p + n * 34.0
	ctx.strokeStyle = "#2a1a10"; ctx.lineWidth = 5.0; ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.lineTo(q.x, q.y); ctx.stroke()
	ctx.strokeStyle = "#6aff9a"; ctx.lineWidth = 2.6; ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.lineTo(q.x, q.y)
	var hd = n.rotated(2.6) * 9.0; var hd2 = n.rotated(-2.6) * 9.0
	ctx.moveTo(q.x, q.y); ctx.lineTo(q.x + hd.x, q.y + hd.y); ctx.moveTo(q.x, q.y); ctx.lineTo(q.x + hd2.x, q.y + hd2.y); ctx.stroke()
	ctx.fillStyle = "#6aff9a"; ctx.beginPath(); ctx.arc(p.x, p.y, 3.0, 0, TAU); ctx.fill()

# ================= 體型：各種鬼做工時工具位置 =================
const BODY := [["n30_kappa", "一般（兩腳企）"], ["egui", "冇腳飄浮"], ["pocong", "包住跳（冇手）"], ["nw_dokkaebi", "單腳 Dokkaebi"], ["nw_nian", "四腳獸：年獸"],
	["bm_taotie", "四腳獸：饕餮"], ["toyol", "矮細：toyol"], ["bm_shuten", "巨大：酒吞"]]
func bodies(t) -> void:
	await _boot(t); await _bodies(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func _bodies(t) -> void:
	var S = Sheet.new(); S.cw = 230.0; S.ch = 230.0; S.top = 60.0
	S.title = "各種體型做工：工具浮喺面向嗰邊（斬中／工作嗰刻）"
	var vs = ["chop", "reap", "saw", "forge", "ladle", "pick"]
	var Th = WA.chop_time()
	for b in BODY:
		var k: String = b[0]
		if not Art.has_spr(k) and WA._h(k) <= 0: _p("冇體型 " + k); continue
		var cells = []
		for v in vs:
			var H0 = EDGE_HIT.get(v, {"T": Th * 0.8 + 3.0 * 0 + Th * 2})
			var T = float(H0.T) if EDGE_HIT.has(v) else (Th * 2.8 if v == "chop" else 3.0)
			cells.append({"cap": "%s・%s" % [VNAME[v].get_slice("：", 1), WA.TOOL_OF[v]], "fn": func(ctx, x, y): WA.draw(ctx, k, x, y, _sc(k, 120.0), false, T, v, 3.0, {"piece": VPIECE.get(v, ""), "icon": "mvi_paper"})})
		S.rows.append({"label": "%s（%s，H=%.0f）" % [b[1], k, WA._h(k)], "cells": cells})
	S.size = Vector2(14 + vs.size() * S.cw, S.top + S.rows.size() * (S.ch + 34) + 10)
	await _render(t, S, SHOTS + "HC_WorkAnim_Bodies.png")

# ================= 批次2 審批圖 =================
const NEWV := ["fork", "tongs", "sew", "brush", "paint", "catch", "pump", "slice", "pull", "salt", "plane", "screw"]
func _first_hit(v: String) -> Dictionary:
	if EDGE_HIT.has(v): return EDGE_HIT[v]
	var cy = _cyc(v)
	for i in int(cy * 2.0 / 0.005):
		var T = 3.0 + i * 0.005
		var e = _edge_draw(EK[0], v, T, false)
		if e.ck == "none": return {"T": 3.0, "ang": 0.0, "ck": "none"}
		if e.hit:
			var r = _eval(e)
			if not r.is_empty(): return {"T": T, "ang": r.ang, "ck": e.ck}
	return {"T": 3.0, "ang": 0.0, "ck": "none"}
func batch2(t) -> void:
	await _boot(t)
	var OUT2 = "/tmp/wk_b2/"; DirAccess.make_dir_recursive_absolute(OUT2)
	# p1/p2：新動作逐格（每行 6 格，一個循環）
	for part in 2:
		var sh = Sheet.new(); sh.cw = 228.0; sh.ch = 220.0; sh.top = 60.0
		sh.title = "批次2 新做工動作 %d/2（工具浮喺面向嗰邊；一行＝一個循環）" % (part + 1)
		for v in NEWV.slice(part * 6, part * 6 + 6):
			var k = VK[v]; var cells = []; var cy = _cyc(v)
			for i in 6:
				var T = 3.0 + cy * i / 6.0
				cells.append({"cap": "%.2f 秒" % (cy * i / 6.0), "fn": func(ctx, x, y): WA.draw(ctx, k, x, y, _sc(k, 120.0), false, T, v, 3.0, {"piece": "", "icon": _icon_of(v)})})
			sh.rows.append({"label": "%s（工具：%s，音效：%s）" % [VNAME[v], WA.TOOL_OF[v], WA.SFX[v]], "cells": cells})
		sh.size = Vector2(14 + 6 * sh.cw, sh.top + sh.rows.size() * (sh.ch + 34) + 10)
		await _render(t, sh, OUT2 + "p%d.png" % (part + 1))
	# p3：新動作刀口特寫（面向右 12 格＋面向左 6 格）
	var sh3 = Sheet.new(); sh3.cw = 228.0; sh3.ch = 228.0; sh3.top = 60.0
	sh3.title = "批次2 工作面朝向特寫（工作嗰刻放大 2 倍）　綠箭＝工作面朝向　紅圈＝目標"
	var cells3 = []
	for e in NEWV.map(func(v): return [v, false]) + ["fork", "tongs", "sew", "slice", "plane", "screw"].map(func(v): return [v, true]):
		var v: String = e[0]; var fl: bool = e[1]; var H0 = _first_hit(v); var T = float(H0.T)
		var cap = "工作面朝目標：已檢查（%d°）" % int(round(H0.ang))
		cells3.append({"top": "%s %s・%s" % ["◀面向左" if fl else "▶", VNAME[v].get_slice("：", 1), WA.TOOL_OF[v]], "cap": cap, "good": true, "ax": 0.5,
			"fn": func(ctx, x, y): _edge_cell(ctx, EK[0], v, T, fl, x, y - 98)})
	for i in range(0, cells3.size(), 6): sh3.rows.append({"label": "面向右" if i < 12 else "面向左（正確鏡像）", "cells": cells3.slice(i, i + 6)})
	sh3.size = Vector2(14 + 6 * sh3.cw, sh3.top + sh3.rows.size() * (sh3.ch + 34) + 10)
	await _render(t, sh3, OUT2 + "p3.png")
	# p4：體型
	await _bodies2(t, OUT2 + "p4.png")
	# p5：整條生產鏈清單
	var L = ChainList.new(); L.build(); L.size = Vector2(1400, 70 + L.lines.size() * 27 + 20)
	await _render(t, L, OUT2 + "p5.png")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func _icon_of(v: String) -> String:
	return {"sew": "mvi_shirt", "brush": "mvi_denglong", "paint": "mvi_phone"}.get(v, "mvi_paper")
func _bodies2(t, path: String) -> void:
	var S = Sheet.new(); S.cw = 228.0; S.ch = 222.0; S.top = 60.0
	S.title = "各種體型做工（同一比例：以 H 縮放；工具浮喺面向嗰邊、離開身體最闊處）"
	var vs = ["chop", "reap", "saw", "ladle", "sew", "pull"]
	for b in BODY:
		var k: String = b[0]
		var cells = []
		for v in vs:
			var T = float(_first_hit(v).T)
			cells.append({"cap": "%s・%s" % [VNAME[v].get_slice("：", 1), WA.TOOL_OF[v]], "fn": func(ctx, x, y): WA.draw(ctx, k, x, y, _sc(k, 118.0), false, T, v, 3.0, {"piece": VPIECE.get(v, ""), "icon": _icon_of(v)})})
		S.rows.append({"label": "%s（%s）" % [b[1], k], "cells": cells})
	S.size = Vector2(14 + vs.size() * S.cw, S.top + S.rows.size() * (S.ch + 34) + 10)
	await _render(t, S, path)
class ChainList extends Control:
	var lines: Array = []   # [級, 建築, 動作, 工具, 音效, 新?]
	func build() -> void:
		var WA2 = load("res://game/outpost/work_anim.gd")
		var C = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/chain.json"))
		var O = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/outpost.json"))
		var NV = ["fork", "tongs", "sew", "brush", "paint", "catch", "pump", "slice", "pull", "salt", "plane", "screw"]
		for sec in [["GATHER", "一級採集"], ["WORKSHOPS", "二級加工"]]:
			for bid in C[sec[0]]:
				var v = WA2.verb_of_post(bid)
				lines.append([sec[1], str(C[sec[0]][bid].n[0]), v, WA2.TOOL_OF.get(v, ""), WA2.SFX.get(v, ""), v in NV, bid in WA2.FIELD_PROPS and not WA2.FIELD_PROPS[bid]])
		for sid in O.STATIONS:
			var v = WA2.verb_of_stall(str(O.STATIONS[sid].art))
			lines.append(["三級（大排檔）", str(O.STATIONS[sid].n[0]), v, WA2.TOOL_OF.get(v, ""), WA2.SFX.get(v, ""), v in NV, false])
	func _draw() -> void:
		var f = UIKit.font("sans", 900); var f2 = UIKit.font("sans", 500)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1c1a20"))
		draw_string(f, Vector2(14, 34), "生產鏈派工動作清單（建築 → 動作 → 工具 → 音效事件）　綠＝批次2 新加　＊＝預設去掉工作物", HORIZONTAL_ALIGNMENT_LEFT, -1, 21, Color("#f4e2b8"))
		var xs = [14, 170, 420, 560, 760]
		var hd = ["級別", "建築", "動作", "工具", "音效事件名"]
		for i in 5: draw_string(f, Vector2(xs[i], 62), hd[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("#f3d68a"))
		for r in lines.size():
			var L = lines[r]; var y = 70 + r * 27
			if r % 2 == 0: draw_rect(Rect2(8, y + 2, size.x - 16, 26), Color(1, 1, 1, 0.04))
			var col = Color("#a8ffcf") if L[5] else Color("#d8d0c0")
			var vals = [L[0], L[1] + ("＊" if L[6] else ""), L[2], L[3], L[4]]
			for i in 5: draw_string(f2, Vector2(xs[i], y + 22), str(vals[i]), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, col)

# ================= 實機：新動作＋空手版（王牌階段圖／NoWeapon 名單）=================
const LIVEK := ["nw_dokkaebi", "nw_nian", "bm_taotie", "bm_shuten", "huang", "n30_yecha", "n30_kuchisake", "n30_vetala", "nw_dullahan", "zd_bone", "mamian", "niutou", "heiwu", "baiwu", "mengpo", "pontianak"]
const LIVE_POST := [[0, "b_straw"], [4, "b_newspaper"], [0, "wood"], [0, "rice"], [0, "b_well"], [0, "b_bamboo"]]
static func _bare(k: String) -> String:   # 呢隻做工時用咩空手圖
	if WA.nwp_key(k) != "": return "空手圖 " + WA.nwp_key(k)
	if WA._ace_active(k): return "王牌階段圖 " + Spr.key_for(k)
	return ""
func live2(t) -> void:
	var m = await _boot(t)
	var S = J.G.S; var ZD = load("res://game/zone/zone_data.gd")
	var sc = m.mv_view; var sim = sc.sim
	var cells = []   # [img, 標題]
	var ki = 0
	var NEWSTALL = {}
	for sid in MD.D().STATIONS: if NEWV.has(WA.verb_of_stall(str(MD.st_def(sid).get("art", "")))) or ["st_shoubao", "st_bingqi"].has(sid): NEWSTALL[sid] = true
	var base: Dictionary = S.ghosts[0]
	for c in 6:
		if c > 0:
			sim.st().ci = float(c); sc._after_move(); await _w(t, 1.5)
		if m.has_method("_nav_on"): m._nav_on("village")
		await _w(t, 1.0)
		# 村子派工
		var gs = []; var todo = []
		for e in LIVE_POST:
			if e[0] != c: continue
			if e[1].begins_with("b_"):
				S.bld[e[1]] = 1
				var zid = ZD.bid_zone(e[1])
				if zid != "": ZD.set_owned(zid)
			var k = LIVEK[ki % LIVEK.size()]; ki += 1
			var g = base.duplicate(true); g["k"] = k; g["id"] = 9500 + ki; g["post"] = e[1]
			S.ghosts.append(g); gs.append(g); todo.append([e[1], k])
		await _w(t, 0.8)
		var spots = J.mc(J.G.Village, "workerSpots", [])
		for e in todo:
			var wp = null; var fl = false
			for sp in spots: if str(J.gp(sp, "post")) == e[0]: wp = Vector2(J.num(sp.x), J.num(sp.y)); fl = J.t(J.gp(sp, "flip")); break
			_chk("實機村子企位 " + e[0], wp != null)
			if wp == null: continue
			var cxw = wp + Vector2(-14.0 if fl else 14.0, -28)
			_cam_close(m, cxw, 112.0); await _w(t, 0.7)
			var img = await _shot(t, "HC_WorkAnim_Live_%s" % e[0])
			var L = WA.LAST.get(e[1], {})
			_chk("實機村子做工動畫 %s（%s）" % [e[0], e[1]], str(L.get("verb", "")) == WA.verb_of_post(e[0]), L.get("verb"))
			_chk("實機村子空手 %s" % e[1], _bare(e[1]) != "", e[1])
			cells.append([_crop(t, m, img, cxw, Vector2(420, 330), 0.95), "村子・%s：%s（%s）" % [VNAME.get(WA.verb_of_post(e[0]), e[0]).get_slice("：", 0), WA.TOOL_OF[WA.verb_of_post(e[0])], e[1]], _bare(e[1])])
		for g in gs: S.ghosts.erase(g)
		# 大排檔：呢張圖嘅新動作台
		var sids = MD.stations(c).filter(func(sid): return NEWSTALL.has(sid))
		if sids.is_empty(): continue
		for sid in sids: sim.sst(sid).unlocked = true
		await _w(t, 0.3)
		sim.paused = true; sim.custs.clear(); sim.foes.clear(); sim.workers.clear(); sim._sync_key = "x"
		var ws = []
		for i in sids.size():
			var p = sim.slot_pos(sids[i], 1)
			var k = LIVEK[ki % LIVEK.size()]; ki += 1
			var w = {"gid": "g_lv%d" % i, "k": k, "name": k, "sid": sids[i], "slot": 0, "st": "work", "prog": 0.2, "pos": p, "home": p, "carry": 0, "t": 0.0, "s": 0.0, "ph": i * 1.3, "paid": {}}
			sim.workers.append(w); ws.append(w)
		for w in ws:
			await _look(t, m, w.pos.y); await _w(t, 0.5)
			await RenderingServer.frame_post_draw
			var img = t.get_viewport().get_texture().get_image()
			var sp = _scr(m, w.pos)
			var r = Rect2i(Vector2i(clampi(int(sp.x - 120), 0, img.get_width() - 260), clampi(int(sp.y - 190), 0, img.get_height() - 230)), Vector2i(260, 230))
			var sub = img.get_region(r); sub.resize(int(260 * 1.5), int(230 * 1.5), Image.INTERPOLATE_LANCZOS)
			var v = WA.verb_of_stall(str(MD.st_def(w.sid).get("art", "")))
			var seen = sc.mot.seen.get(w.k, {})
			_chk("實機大排檔做工動畫 %s（%s）" % [w.sid, w.k], seen.has("wa_" + v), seen.keys())
			_chk("實機大排檔空手 %s" % w.k, _bare(w.k) != "", w.k)
			cells.append([sub, "大排檔・%s：%s（%s）" % [MD.T(MD.st_def(w.sid).get("n", ["?", "?"])), WA.TOOL_OF[v], w.k], _bare(w.k)])
		sim.workers.clear(); sim.paused = false
	# 拼圖（每頁 ≤ 1400×2200）
	var per = 6; var pg = 0
	for i in range(0, cells.size(), per):
		pg += 1
		var sh = LiveSheet.new(); sh.cells = cells.slice(i, i + per); sh.title = "實機截圖（真遊戲畫法，近鏡）：新做工動作＋空手版　第 %d 頁" % pg
		for cc in sh.cells: sh.texs.append(ImageTexture.create_from_image(cc[0]))
		sh.size = Vector2(1400, 70 + 3 * (sh.cw_h() + 70))
		await _render(t, sh, "/tmp/wk_b2/live_%d.png" % pg)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
class LiveSheet extends Control:
	var cells: Array = []; var texs: Array = []; var title := ""
	func cw_h() -> int: return 520
	func _draw() -> void:
		var f = UIKit.font("sans", 900); var f2 = UIKit.font("sans", 500)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1c1a20"))
		draw_string(f, Vector2(14, 36), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("#f4e2b8"))
		for i in cells.size():
			var col = i % 2; var row = i / 2
			var tex: Texture2D = texs[i]
			var bw = 680.0; var bh = 520.0
			var k = minf(bw / tex.get_width(), bh / tex.get_height())
			var sz = Vector2(tex.get_width(), tex.get_height()) * k
			var p = Vector2(14 + col * 694, 70 + row * (bh + 70))
			draw_string(f, p + Vector2(0, 22), str(cells[i][1]), HORIZONTAL_ALIGNMENT_LEFT, bw, 18, Color("#f3d68a"))
			draw_string(f2, p + Vector2(0, 46), str(cells[i][2]), HORIZONTAL_ALIGNMENT_LEFT, bw, 15, Color("#a8ffcf"))
			draw_texture_rect(tex, Rect2(p + Vector2(0, 56), sz), false)
			draw_rect(Rect2(p + Vector2(0, 56), sz), Color(0.5, 0.44, 0.3), false, 2.0)
