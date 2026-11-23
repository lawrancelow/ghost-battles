# [eqview2] 裝備顯示方案比較（A 現行 pin／B 鬼物飄浮 float／C 出手才現形 strike）
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> eqv2 res://tools/tests/eqview2_test.gd cmp|game|perf|all <秒>
#   cmp ：6 隻唔同體型名鬼 × 3 方案 × 3 狀態（待機／普攻中／放技能中）比較圖 → /home/claude/docs/shots/eqview2/compare_*.png
#         檢查：B／C 待機喺 1.25H 框內、任何狀態唔高過頭頂資訊線、兵器／徽章唔遮臉
#   game：地圖戰鬥（1-1）實戰：三方案各一張近鏡；B 方案連續截幀（/tmp/eqv2_frames → b_anim.mp4＋b_anim.png 八格）
#   perf：同一場大戰（8 隊）分別用 pin／float／strike 量幀時間
#   正式裝備圖 eqi_*（未批准、唔入 repo）：由 assets/spr 直接載入，只用嚟截圖
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/shots/eqview2/"
const FR := "/tmp/eqv2_frames/"
const EQ = preload("res://game/equip/eq_data.gd")
const EV = preload("res://game/equip/eq_view.gd")
const EV2 = preload("res://game/equip/eq_view2.gd")
const ML = preload("res://game/militia/ml_data.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SIX := ["afu", "nw_zzhouse", "nw_guihuo", "n30_kappa", "bm_langsuir", "nw_niexiaoqian"]
const SIX_N := ["阿福（人形）", "紙紮大屋（物件・闊）", "鬼火（飄浮・無手）", "河童（獸形）", "Langsuir 大魔王（闊翼）", "聶小倩（暫代圖）"]
# 每隻一套：單數用安全帽（頭戴）、雙數用身甲（描邊色：凡灰／良綠／精藍／名金）
const SETS := [
	{"wea": "eq_huoqi", "arm": "eq_anquan", "acc": "eq_dianzhan"},
	{"wea": "eq_liangcha", "arm": "eq_baoan", "acc": "eq_yinji"},
	{"wea": "eq_huanshou", "arm": "eq_anquan", "acc": "eq_fengyou"},
	{"wea": "eq_wokchan", "arm": "eq_guanban", "acc": "eq_staffcard"},
	{"wea": "eq_suanpan", "arm": "eq_laogong", "acc": "eq_naozhong"},
	{"wea": "eq_danca", "arm": "eq_xizhuang", "acc": "eq_paperphone"},
]

func _p(m): print("[eqv2] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _f(t, n := 1):
	for i in n: await t.get_tree().process_frame
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
# 近鏡：截全畫面再按世界座標裁一塊放大（鏡頭最近都只係遊戲本身嘅最大縮放）
func _crop_img(t, m, wp: Vector2, sz := Vector2(240, 250), k := 2.4) -> Image:
	await RenderingServer.frame_post_draw
	var img = t.get_viewport().get_texture().get_image()
	var RV = load("res://game/rts/rts_view.gd")
	var sp = RV.inst._scr(wp) if RV.inst != null else m.village.zone_cam().w2s(wp)
	sp *= Vector2(img.get_size()) / t.get_viewport().get_visible_rect().size
	var r = Rect2i(Vector2i(clampi(int(sp.x - sz.x / 2), 0, img.get_width() - int(sz.x)), clampi(int(sp.y - sz.y / 2), 0, img.get_height() - int(sz.y))), Vector2i(sz))
	var c = img.get_region(r)
	c.resize(int(sz.x * k), int(sz.y * k), Image.INTERPOLATE_LANCZOS)
	return c
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.2)
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
	_load_eqi()
	return m
# 未入庫嘅正式裝備圖：直接由檔案載入（Spr 登記），唔使 import、唔改 manifest
func _load_eqi() -> void:
	var d = DirAccess.open("res://assets/spr")
	var n = 0
	for f in d.get_files():
		if not (f.begins_with("eqi_") and f.ends_with(".webp")): continue
		var key = f.get_basename()
		var im = Image.load_from_file(ProjectSettings.globalize_path("res://assets/spr/" + f))
		if im == null: continue
		Spr._man[key] = "res://assets/spr/" + f; Spr._tex[key] = ImageTexture.create_from_image(im); n += 1
	if Spr._man.has("eqi_eq_liangchapot") and not Spr._man.has("eqi_eq_liangcha_pot"):   # 檔名少咗底線
		Spr._man["eqi_eq_liangcha_pot"] = Spr._man["eqi_eq_liangchapot"]; Spr._tex["eqi_eq_liangcha_pot"] = Spr._tex["eqi_eq_liangchapot"]
	_p("eqi 圖載入 %d 張" % n)

func all(t) -> void:
	var m = await _boot(t)
	await _cmp(t, m)
	await _game(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func cmp(t) -> void:
	var m = await _boot(t)
	await _cmp(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func game(t) -> void:
	var m = await _boot(t)
	await _game(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func perf(t) -> void:
	var m = await _boot(t)
	await _perf(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= cmp：比較圖 =================
const COLS := ["待機", "普攻中", "放技能中"]
const ROWS := [["pin", "A 現行：貼手／背掛"], ["float", "B 鬼物飄浮（推薦）"], ["strike", "C 出手才現形"]]
const CW := 500.0
const CH := 520.0
const TOPB := 70.0
const LEFTB := 0.0
static func _st(sch: String, col: int) -> Dictionary:   # 每格嘅動態狀態（定格）
	match col:
		0: return {"T": 1.3, "act": "idle", "ph": 0.0}
		1: return {"T": 1.3, "act": "atk", "ph": 0.5 if sch == "strike" else 0.56}
		_: return {"T": 1.3, "act": "sk", "ph": 0.45 if sch == "strike" else 0.36}
class Cell:
	var r: Rect2; var foot: Vector2; var H: float; var tg: Vector2; var sch: String; var col: int
class GlowL extends Control:   # 描邊層（flat 色 shader），喺角色後面
	var k := ""; var w := {}; var cells: Array = []
	func _draw() -> void:
		var E2 = load("res://game/equip/eq_view2.gd")
		for c in cells:
			if c.sch == "pin": continue
			var arm = str(w.get("arm", ""))
			if arm == "" or str(EQ.item(arm).get("look")) != "body": continue
			E2.glow(self, Transform2D.IDENTITY, k, c.foot, c.H, 1.0, EQ.grade_col(EQ.grade_of(arm)), 1.3, 0.45 if c.col > 0 else 1.0)
class Sheet extends Control:
	var k := ""; var title := ""; var w := {}; var cells: Array = []
	var res := {}     # sch|col → Rect2（以 H 為 1）
	func _draw() -> void:
		var f = UIKit.font("sans", 900)
		var E1 = load("res://game/equip/eq_view.gd"); var E2 = load("res://game/equip/eq_view2.gd")
		draw_string(f, Vector2(16, 44), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("#f4e2b8"))
		for c in cells:
			var r: Rect2 = c.r
			var ctx = Ctx.new(self)
			# 敵人（目標）
			var et = PtGfx.tex(Art.spr_key("egui"))
			if et != null:
				var eh = c.H * 0.8; var ew = eh * et.get_width() / float(et.get_height())
				var ef = c.foot + c.tg + Vector2(0, eh * 0.5)
				draw_set_transform(ef, 0, Vector2(-1, 1))
				draw_texture_rect(et, Rect2(-ew * 0.5, -eh, ew, eh), false, Color(1, 0.8, 0.8, 0.8))
				draw_set_transform_matrix(Transform2D.IDENTITY)
			# 腳底影
			draw_set_transform(c.foot + Vector2(0, 3), 0, Vector2(1, 0.3)); draw_circle(Vector2.ZERO, c.H * 0.25, Color(0, 0, 0, 0.35)); draw_set_transform_matrix(Transform2D.IDENTITY)
			var tex = PtGfx.tex(Art.spr_key(k))
			var Wd = c.H * tex.get_width() / float(tex.get_height()) if tex != null else 0.0
			var rr = Rect2(c.foot, Vector2.ZERO)
			var st: Dictionary = c.get_meta("st")
			st["tg"] = c.tg
			if c.sch == "pin":
				var pose = "" if c.col == 0 else "strike"
				var pt = 0.0 if c.col == 0 else (0.45 if c.col == 1 else 0.85)
				rr = E1.draw_on(ctx, k, w, c.foot, c.H, 1.0, pose, pt, false, "back")
				if tex != null: draw_texture_rect(tex, Rect2(c.foot.x - Wd * 0.5, c.foot.y - c.H, Wd, c.H), false)
				rr = rr.merge(E1.draw_on(ctx, k, w, c.foot, c.H, 1.0, pose, pt, false, "front"))
			else:
				var rb = E2.draw(ctx, c.sch, k, w, c.foot, c.H, 1.0, st, false, "back")   # 飛過身後嘅兵器
				if tex != null: draw_texture_rect(tex, Rect2(c.foot.x - Wd * 0.5, c.foot.y - c.H, Wd, c.H), false)
				rr = E2.draw(ctx, c.sch, k, w, c.foot, c.H, 1.0, st)
				if rb.size.x > 0: rr = rr.merge(rb)
			res["%s|%d" % [c.sch, c.col]] = Rect2((rr.position - c.foot) / c.H, rr.size / c.H)
			# 頭頂血條＋技能條（同地圖戰鬥一樣嘅位：op.head ≈ 腳底上 1.0H 再高 4px）
			var hd = c.foot + Vector2(0, -1.02 * c.H - 6)
			var bw = c.H * 0.62
			draw_rect(Rect2(hd.x - bw / 2 - 2, hd.y - 2, bw + 4, 14), Color(0, 0, 0, 0.7))
			draw_rect(Rect2(hd.x - bw / 2, hd.y, bw * 0.8, 8), Color("#4ade80"))
			draw_rect(Rect2(hd.x - bw / 2, hd.y + 8, bw * (1.0 if c.col == 2 else 0.5), 3), Color("#ffd84a") if c.col == 2 else Color("#7dd3fc"))
			# 格框＋標籤
			draw_rect(r, Color("#8a6a50"), false, 2.0)
			var lab = "%s｜%s" % [c.get_meta("rowname"), COLS[c.col]]
			draw_rect(Rect2(r.position + Vector2(2, 2), Vector2(r.size.x - 4, 34)), Color(0, 0, 0, 0.55))
			draw_string(f, r.position + Vector2(10, 28), lab, HORIZONTAL_ALIGNMENT_LEFT, r.size.x - 20, 22, Color("#ffe6a8") if c.sch == "float" else Color("#e8dcc8"))
func _cells(k: String) -> Array:
	var o = []
	for ri in ROWS.size():
		for ci in 3:
			var c = Cell.new()
			c.r = Rect2(Vector2(LEFTB + ci * CW + 4, TOPB + ri * CH + 4), Vector2(CW - 8, CH - 8))
			c.H = 300.0
			c.foot = Vector2(c.r.position.x + CW * 0.36, c.r.end.y - 34)
			c.tg = Vector2(CW * 0.52, -c.H * 0.4)
			c.sch = ROWS[ri][0]; c.col = ci
			c.set_meta("st", _st(c.sch, ci)); c.set_meta("rowname", ROWS[ri][1])
			o.append(c)
	return o
func _face(k: String) -> Rect2:   # 臉（以 H 為 1、圖本身方向）：頭頂錨點下 0.1–0.42H、闊 0.8×帽闊
	var A = EV.anchor(k)
	var hw = J.num(A.get("hw", 0.4))
	return Rect2(Vector2(A.head.x - hw * 0.4, A.head.y + 0.10), Vector2(hw * 0.8, 0.32))
func _seg_rect(a: Vector2, b: Vector2, m: float) -> Rect2: return Rect2(a, Vector2.ZERO).expand(b).grow(m)
func _cmp(t, m) -> void:
	var root = t.get_tree().root
	var oob = []; var high = []; var face = []
	for i in SIX.size():
		var k = SIX[i]; var w = SETS[i]
		if PtGfx.tex(Art.spr_key(k)) == null: _chk("%s 有全身圖" % k, false); continue
		var sv = SubViewport.new(); sv.size = Vector2i(int(CW * 3), int(TOPB + CH * 3)); sv.transparent_bg = false
		sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(sv)
		var bg = ColorRect.new(); bg.color = Color(0.17, 0.16, 0.19); bg.size = Vector2(sv.size); sv.add_child(bg)
		var cells = _cells(k)
		var gl = GlowL.new(); gl.k = k; gl.w = w; gl.cells = cells; gl.size = Vector2(sv.size); gl.material = EV2.glow_mat(); sv.add_child(gl)
		var sh = Sheet.new(); sh.k = k; sh.w = w; sh.cells = cells; sh.size = Vector2(sv.size)
		sh.title = "%s　%s　兵器：%s　護身：%s　隨身：%s" % [k, SIX_N[i], EQ.name_of(w.wea), EQ.name_of(w.arm), EQ.name_of(w.acc)]
		sv.add_child(sh)
		await _f(t, 3); await RenderingServer.frame_post_draw
		sv.get_texture().get_image().save_png(SHOTS + "compare_%d_%s.png" % [i + 1, k]); _p("shot compare_%d_%s" % [i + 1, k])
		for key in sh.res:
			var rn: Rect2 = sh.res[key]
			if key.ends_with("|0") and not key.begins_with("pin") and not EV.in_box(rn): oob.append([k, key, rn])
			if not key.begins_with("pin") and rn.position.y < EV2.TOP - 0.06: high.append([k, key, snappedf(rn.position.y, 0.01)])
		# 唔遮臉：B 待機兵器、C 待機徽章
		var fr = _face(k)
		var R = EV2.rest_of(k, w.wea, Vector2.ZERO, 1.0, 1.0, 1.3)
		var dv = Vector2(sin(R[1]), -cos(R[1]))
		var wr = _seg_rect(R[0] - dv * R[2] * 0.5, R[0] + dv * R[2] * 0.5, 0.03)
		if wr.intersects(fr): face.append([k, "B", wr, fr])
		for act in ["atk", "cast", "sk"]:   # B 蓄力、飛出／飛返全程唔掠過臉（目標喺身前）
			for q in 21:
				var F = EV2.float_at(k, w.wea, Vector2.ZERO, 1.0, 1.0, {"T": 1.3, "act": act, "tg": Vector2(CW * 0.52 / 300.0, -0.4)}, q / 20.0)
				if EV2.float_back(k, F[0], Vector2.ZERO, 1.0, 1.0, act, F[1], F[2]): continue   # 喺身後飛過：俾身體遮住，唔會遮臉
				var dvf = Vector2(sin(F[1]), -cos(F[1]))
				if _seg_rect(F[0] - dvf * F[2] * 0.5, F[0] + dvf * F[2] * 0.5, 0.0).intersects(fr.grow(-0.02)): face.append([k, "B-" + act, q]); break
		var bp = EV2.badge_pos(k, Vector2.ZERO, 1.0, 1.0)
		var br = Rect2(bp + Vector2(-0.065, -0.13), Vector2(0.13, 0.13))
		if br.intersects(fr): face.append([k, "C", br, fr])
		sv.queue_free(); await _f(t, 2)
	_chk("B／C 待機：6 隻名鬼全部喺 1.25H 框內（唔爆格）", oob.is_empty(), oob)
	_chk("B／C 任何狀態：兵器唔高過頭頂資訊線（血條、ab_lay 頭頂字唔遮）", high.is_empty(), high)
	_chk("B 飄浮兵器（待機＋飛出飛返全程）、C 徽章唔遮臉", face.is_empty(), face)

# ================= game：地圖戰鬥實戰 =================
func _stall(lv: float) -> void:
	var mv = J.G.S.mv
	if not (mv.st.get(ML.SID) is Dictionary): mv.st[ML.SID] = {"unlocked": true, "lv": lv}
	mv.st[ML.SID].unlocked = true; mv.st[ML.SID].lv = lv
func _gid(k: String) -> String:
	for g in J.G.S.ghosts: if str(g.k) == k: return str(g.id)
	return ""
func _team(t, ks: Array) -> Array:
	var S = J.G.S
	_stall(150.0)
	var SD = load("res://game/soul/soul_data.gd")
	SD._bypass = true   # 唔經祭壇魂魄，直接入隊（測試）
	for k in ks:
		if _gid(k) == "": J.cl(J.G.get("joinGhost"), null, [k])
	SD._bypass = false
	var miss = []
	for k in ks: if _gid(k) == "": miss.append(k)
	if miss.size(): _p("入唔到隊：%s" % [miss])
	await _skip(t, 8)
	var ids = []
	var e = EQ.st()
	for i in ks.size():
		var g = _gid(ks[i])
		if g == "": continue
		ids.append(g)
		var w = SETS[i % SETS.size()]
		for sl in w:
			e.inv[w[sl]] = J.num(e.inv.get(w[sl], 0)) + 1.0
			EQ.wear(g, w[sl])
	S["team"] = ids
	return ids
func _start(t, m, troops: float):
	var S = J.G.S
	S.res["troops"] = troops
	if int(J.num(m.mv_view.sim.st().ci)) != 0: m.mv_view.sim.st().ci = 0.0; m.mv_view._after_move(); await _w(t, 1.2)
	S.cleared.erase("1-1")
	var Q = J.G.get("QUESTS")
	for i in Q.size(): if str(Q[i].get("t")) == "stage" and str(Q[i].get("s")) == "1-1": S["qi"] = float(i)
	J.G.get("Battle")["auto"] = true
	ZD.start_stage()
	if RTS.pending != null: RTS.card_go()
	await _f(t, 3)
	var op = RTS.op_for("1-1")
	if op == null: return null
	var c = m.village.zone_cam()
	var t0 = 0
	while t0 < 700 and op.phase == "march":
		if t0 % 5 == 0: c.glide_to(op.center() + Vector2(0, -40))
		await _w(t, 0.1); t0 += 1
	return op
func _cam(m, p: Vector2, z: float) -> void:
	var c = m.village.zone_cam()
	c.z = m.village.size.x / z; c.clamp_all(); c.tgt = null; c.vel = Vector2.ZERO; c.center_on(p)
func _hero(op, k := "") -> Dictionary:
	for u in op.units:
		if J.num(u.side) == 0 and u.get("eq") is Dictionary and J.num(u.hp) > 0 and (k == "" or str(u.k) == k): return u
	return {}
func _game(t, m) -> void:
	var ids = await _team(t, ["afu", "n30_kappa", "nw_guihuo"])
	_chk("出陣名鬼 3 隻穿好裝備", ids.size() >= 3, ids)
	var op = await _start(t, m, 60.0)
	_chk("1-1 地圖戰鬥開到並交戰", op != null and op.phase == "fight", op.phase if op else null)
	if op == null: return
	for u in op.units:   # 拉長打鬥（截圖時唔好太快打完）
		u["hp"] = J.num(u.hp) * 15; u["maxhp"] = J.num(u.maxhp) * 15
	var RV = load("res://game/rts/rts_view.gd")
	var ng = 0
	if RV.inst != null:
		for key in RV.inst.vis:
			for ch in RV.inst.vis[key].chars: if ch.get_node_or_null("EqGlow") != null: ng += 1
	_chk("名鬼掛咗描邊層 EqGlow（%d）" % ng, ng >= 1)
	# 三方案各一張近鏡
	var h: Dictionary = _hero(op)
	for sv in [["pin", "A"], ["float", "B"], ["strike", "C"]]:
		EV.view_test = sv[0]
		h = _hero(op)
		if h.is_empty(): break
		_cam(m, (h.p as Vector2) + Vector2(20, -30), 95.0)
		await _w(t, 0.6); await _shot(t, "ingame_%s_%s" % [sv[1], sv[0]])
		var ci = await _crop_img(t, m, (h.p as Vector2) + Vector2(25, -28))
		ci.save_png(SHOTS + "ingame_%s_%s_zoom.png" % [sv[1], sv[0]])
	EV.view_test = ""
	B_end(op)
	await _w(t, 3.0)
	await _video(t, m)
func _video(t, m) -> void:
	# 乾淨示範：只派阿福一隻（冇陰兵、冇隊友技能特效遮住），由開打前行近敵人開始錄
	await _team(t, ["afu"])
	var op = await _start(t, m, 0.0)
	if op == null: _chk("示範戰開到", false); return
	for u in op.units: u["hp"] = J.num(u.hp) * 15; u["maxhp"] = J.num(u.maxhp) * 15
	var h: Dictionary = {}
	# B 方案：連續截幀（遊戲放慢到 0.35 倍、每幀都截，之後 13fps 合成 ≈ 真實速度），鏡頭跟鬼火（企得開，睇得清），中途放技能
	EV.view_test = "float"
	DirAccess.make_dir_recursive_absolute(FR)
	for f in DirAccess.get_files_at(FR): DirAccess.remove_absolute(FR + f)
	var n = 0; var fired = false
	var times = []
	h = _hero(op, "afu")
	Engine.time_scale = 0.35
	var gt = 0.0
	var top_min = 0.0
	while n < 185 and not h.is_empty():
		if J.num(h.hp) <= 0: break
		if n % 2 == 0: _cam(m, (h.p as Vector2) + Vector2(10, -25), 130.0)
		if not fired and n >= 70:
			h["energy"] = 100.0
			fired = op.cast(h)
		var ci2 = await _crop_img(t, m, (h.p as Vector2) + Vector2(10, -28), Vector2(250, 210), 2.2)
		ci2.save_png(FR + "f%03d.png" % n)
		var lr = EV2.LAST.get("afu")
		if lr is Rect2: top_min = minf(top_min, lr.position.y)
		gt += t.get_tree().root.get_process_delta_time()
		times.append(snappedf(gt, 0.001))
		n += 1
	Engine.time_scale = 1.0
	_chk("B 方案連續截幀 %d 幀（放咗技能：%s）" % [n, fired], n >= 120 and fired)
	_chk("實戰 B：飛出攻擊／技能全程唔高過自己頭頂資訊線（最高 %.2fH）" % top_min, top_min >= EV2.TOP - 0.06)
	var fa = FileAccess.open(FR + "times.txt", FileAccess.WRITE); fa.store_string(" ".join(times.map(func(x): return str(x)))); fa.close()
	EV.view_test = ""
	B_end(op)
func video(t) -> void:
	var m = await _boot(t)
	await _video(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func B_end(op) -> void:
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 0.0

# ================= perf：8 隊大戰 =================
func _frames(t, n: int) -> Array:
	var ts = []; var last = Time.get_ticks_usec()
	for i in n:
		await t.get_tree().process_frame
		var now = Time.get_ticks_usec(); ts.append((now - last) / 1000.0); last = now
	ts.sort()
	var sum = 0.0
	for x in ts: sum += x
	return [ts[ts.size() / 2], ts[int(ts.size() * 0.9)], sum / ts.size()]
func _perf(t, m) -> void:
	var ks = ["afu", "n30_kappa", "nw_guihuo", "xiaozhi", "laojiang", "toyol", "nw_zzhouse", "nw_niexiaoqian"]
	var ids = await _team(t, ks)
	var op = await _start(t, m, 400.0)
	_chk("大戰開到", op != null and op.phase == "fight")
	if op == null: return
	for u in op.units: u["hp"] = J.num(u.hp) * 40; u["maxhp"] = J.num(u.maxhp) * 40
	var nh = 0; var nsq = 0; var ne = 0
	for u in op.units:
		if J.num(u.side) == 1: ne += 1
		elif J.t(u.get("minion")): nsq += 1
		else: nh += 1
	_p("戰場：我方名鬼 %d、陰兵／遊魂兵小隊 %d、敵 %d（共 %d 隊）" % [nh, nsq, ne, nh + nsq + ne])
	_cam(m, op.center() + Vector2(0, -30), 300.0)
	await _w(t, 1.0)
	var R = {}
	for rep in 3:
		for sch in ["pin", "float", "strike"]:
			EV.view_test = sch
			await _f(t, 10)
			var r = await _frames(t, 120)
			if not R.has(sch): R[sch] = []
			R[sch].append(r)
	var med = {}
	for sch in R:
		var a = R[sch]
		med[sch] = [0.0, 0.0, 0.0]
		for x in a:
			for j in 3: med[sch][j] += x[j] / a.size()
		_p("效能 %s：幀 中位 %.1fms（p90 %.1f、平均 %.1f）≈ %.1f fps" % [sch, med[sch][0], med[sch][1], med[sch][2], 1000.0 / maxf(1.0, med[sch][2])])
	await _shot(t, "perf_bigfight_float")
	_chk("效能：B 方案（飄浮）平均幀時間 ≤ 現行 ×1.08＋1ms（fps 唔明顯跌）", med.float[2] <= med.pin[2] * 1.08 + 1.0, [med.pin, med.float])
	_chk("效能：C 方案平均幀時間 ≤ 現行 ×1.08＋1ms", med.strike[2] <= med.pin[2] * 1.08 + 1.0, [med.pin, med.strike])
	EV.view_test = ""
	B_end(op)

func dbg(t) -> void:
	var m = await _boot(t)
	var ids = await _team(t, ["afu", "n30_kappa", "nw_guihuo"])
	EV.view_test = "float"
	var op = await _start(t, m, 60.0)
	await _w(t, 0.5)
	for u in op.units:
		if u.get("eq") is Dictionary: _p("unit %s eq=%s" % [u.k, u.eq])
	var RV = load("res://game/rts/rts_view.gd")
	for key in RV.inst.vis:
		var vv = RV.inst.vis[key]
		for ch in vv.chars:
			var o = ch.get_node_or_null("EqOver")
			if o != null: _p("over %s st.s=%s x=%s y=%s side1=%s vis=%s" % [o.u.k, ch.st.get("s"), ch.st.get("x"), ch.st.get("y"), ch.st.get("side1"), ch.visible])
	_p("LAST %s" % [EV2.LAST])
	_p("RESULT ok=%d bad=%d" % [ok, bad])
