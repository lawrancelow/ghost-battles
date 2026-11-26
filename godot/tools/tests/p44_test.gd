# [p44] 整合測試：王牌三階晉級立繪、對話用原圖、主角空手三姿勢＋漂浮兵器（刃口方向）
# 用法：bash godot/tools/devkit/edtest.sh <godot目錄> p44 res://tools/tests/p44_test.gd all 900
#   art   ：52 張階段圖（17 隻；酒吞四階）＋主角 6 張姿勢圖全部載入到、有透明底（四角透明、透明比例夠）、輪廓冇白邊
#   map   ：星級 → 階段（★0–2 第一階、★3–4 第二階、★5 第三階；酒吞 ★3/★4/★5 → 二／三／四階）；Spr 取圖自動換
#   dlg   ：對話（dlg_begin）入面黑白無常、牛頭馬面、孟婆用原圖（手持兵器），其餘用階段圖；真劇情畫面頭像檢查
#   hero  ：三個姿勢輪換（入場隨機、到時換另一個）、男女主預設兵器（斧／三角尺）、漂浮兵器刃口方向（面向左右兩邊、待機＋出手）
#   battle：1-1 地圖實戰：主角整張空手圖＋漂浮兵器層、王牌用階段圖（唔行網格）；截圖
#   ui    ：圖鑑詳情（★0／★3／★5）、圖鑑總表、名冊截圖；劇情對話截圖
#   截圖：/home/claude/docs/shots/p44/
extends "res://tools/tests/eqview2_test.gd"

const ACE = preload("res://game/soul/ace_art.gd")
const UPS = preload("res://game/soul/soul_up.gd")
const EA = preload("res://game/equip/eq_art.gd")
const SH44 := "/home/claude/docs/shots/p44/"

func _p(m): print("[p44] ", m)
func _shot44(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SH44 + name + ".png"); _p("shot " + name)

func all(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH44)
	_art(); _map(); _dlg_keys(); _hero_logic()
	await _dlg_story(t, m)
	await _hero_sheet(t, m)
	await _ui(t, m)
	await _solo(t, m)
	await _battle(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func quick(t) -> void:
	await _boot(t)
	_art(); _map(); _dlg_keys(); _hero_logic()
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ---------------- art ----------------
static func _img(key: String) -> Image:
	var tx: Texture2D = Spr.get_tex(key)
	if tx == null: return null
	var im = tx.get_image()
	if im == null: return null
	if im.is_compressed(): im = im.duplicate(); im.decompress()
	return im
static func _alpha_ok(im: Image) -> Array:   # [四角透明, 透明比例, 白邊比例]
	var w = im.get_width(); var h = im.get_height()
	var corners = true
	for p in [Vector2i(1, 1), Vector2i(w - 2, 1), Vector2i(1, h - 2), Vector2i(w - 2, h - 2)]:
		if im.get_pixelv(p).a > 0.02: corners = false
	var s = im.duplicate(); var sc = 256.0 / maxf(w, h)
	s.resize(maxi(8, int(w * sc)), maxi(8, int(h * sc)), Image.INTERPOLATE_BILINEAR)
	var W = s.get_width(); var H = s.get_height(); var tr = 0; var edge = 0; var white = 0
	for y in H:
		for x in W:
			var c = s.get_pixel(x, y)
			if c.a < 0.05: tr += 1; continue
			if c.a < 0.6 or x == 0 or y == 0 or x == W - 1 or y == H - 1: continue
			var nb = s.get_pixel(x - 1, y).a < 0.05 or s.get_pixel(x + 1, y).a < 0.05 or s.get_pixel(x, y - 1).a < 0.05 or s.get_pixel(x, y + 1).a < 0.05
			if not nb: continue
			edge += 1
			if minf(c.r, minf(c.g, c.b)) > 0.93: white += 1
	return [corners, float(tr) / (W * H), float(white) / maxf(1, edge)]
func _art() -> void:
	var miss = []; var badc = []; var lowt = []; var fringe = []; var n = 0
	var keys = []
	for k in ACE.STAGES:
		for s in range(1, ACE.n_stages(k) + 1): keys.append("ace_%s_s%d" % [k, s])
	for k in ACE.POSES: keys.append(k); keys.append(Spr.fem_key(k))
	for key in keys:
		var im = _img(key)
		if im == null or not Spr.ok(key): miss.append(key); continue
		n += 1
		var r = _alpha_ok(im)
		if not r[0]: badc.append(key)
		if r[1] < 0.08: lowt.append([key, snappedf(r[1], 0.01)])
		if r[2] > 0.03: fringe.append([key, snappedf(r[2], 0.001)])
	var ns = 0
	for k in ACE.STAGES: ns += ACE.n_stages(k)
	_chk("王牌階段圖 %d 張（17 隻，酒吞四階）＋主角姿勢 6 張全部載入到" % ns, miss.is_empty() and ns == 52 and n == 58, miss)
	_chk("全部透明底：四角透明", badc.is_empty(), badc)
	_chk("全部透明底：透明範圍 ≥8%", lowt.is_empty(), lowt)
	_chk("輪廓冇白邊（邊緣近白像素 ≤3%）", fringe.is_empty(), fringe)

# ---------------- map ----------------
func _set_star(k: String, s: int) -> void:
	var o = UPS.st()
	o.star[k] = float(s); ACE._cf = -1
func _map() -> void:
	var bad3 = []; var bad4 = []
	for k in ACE.STAGES:
		var exp = [1, 1, 1, 2, 2, 3] if ACE.n_stages(k) == 3 else [1, 1, 1, 2, 3, 4]
		for s in 6:
			_set_star(k, s)
			var st = ACE.stage(k)
			var want = "ace_%s_s%d" % [k, exp[s]]
			if st != exp[s] or Spr.key_for(k) != want or PtGfx.tex(k) != Spr.get_tex(want):
				(bad4 if ACE.n_stages(k) == 4 else bad3).append([k, s, st, Spr.key_for(k)])
		_set_star(k, 0)
	_chk("三階王牌：★0–2 第一階、★3–4 第二階、★5 第三階（Spr／PtGfx 取圖自動換）", bad3.is_empty(), bad3)
	_chk("酒吞童子四階：★0–2／★3／★4／★5 → 一／二／三／四階", bad4.is_empty(), bad4)
	_chk("其他角色唔受影響（afu_body、toyol、xiaogui 照用原圖）", Spr.key_for("toyol") == "toyol" and Spr.key_for("xiaogui") == "xiaogui" and Spr.key_for("afu_body") in ["afu_body", "afuf_body"])
	_chk("第一階＝空手原圖：網格／拆手唔用（active）", ACE.active("heiwu") and ACE.active("bm_shuten"))

# ---------------- dlg ----------------
func _dlg_keys() -> void:
	for k in ["heiwu", "baiwu", "niutou", "mamian", "mengpo", "pontianak", "bm_shuten"]: _set_star(k, 5)
	var keep_ui = []; var keep_dlg = []; var other = []
	for k in ACE.KEEP_DLG:
		if Spr.key_for(k) != "ace_%s_s3" % k: keep_ui.append(k)
	ACE.dlg_begin()
	for k in ACE.KEEP_DLG:
		if Spr.key_for(k) != k or PtGfx.tex(k) == PtGfx.tex("ace_%s_s3" % k): keep_dlg.append(k)
	for k in ["pontianak", "bm_shuten", "nw_huapi"]:
		if Spr.key_for(k) == k: other.append(k)
	ACE.dlg_end()
	_chk("遊戲介面：黑白無常、牛頭馬面、孟婆用空手階段圖", keep_ui.is_empty(), keep_ui)
	_chk("故事對話：黑無常、白無常、牛頭、馬面、孟婆用手持兵器原圖（5 隻）", keep_dlg.is_empty() and ACE.KEEP_DLG.size() == 5, keep_dlg)
	_chk("故事對話：其餘角色用目前階段圖", other.is_empty(), other)
	_chk("對話完結後恢復（dlg＝0）", ACE.dlg == 0 and Spr.key_for("heiwu") == "ace_heiwu_s3")

func _dlg_story(t, m) -> void:
	var st = m.get("story")
	if st == null: _chk("劇情播放器存在", false); return
	var sc = {"id": "p44_dlg", "style": "talk", "bg": "road", "title": "黃泉路（測試）", "lines": [["白無常", "陳大福，男，三十三歲，死因：過勞。"], ["黑無常", "又一個。你哋陽間啲公司，勾魂仲勤力過我哋。"], ["孟婆", "飲碗湯先，慢慢講。"]]}
	st.queue(sc); await _w(t, 0.8)
	var paths = []
	for i in 3:
		var tx = st.pt.texture
		paths.append(tx.atlas.resource_path if tx is AtlasTexture and tx.atlas != null else "")
		if i == 1:
			st.typing = false; st.shown = 999; await _w(t, 0.4)
			await _shot44(t, "dlg_wuchang")
		st.advance(); await _w(t, 0.3)
		if st.typing: st.advance(); await _w(t, 0.3)
	_chk("真劇情畫面：白無常／黑無常／孟婆頭像用原圖", paths.size() == 3 and paths[0].ends_with("/baiwu.webp") and paths[1].ends_with("/heiwu.webp") and paths[2].ends_with("/mengpo.webp"), paths)
	await _skip(t, 3)

# ---------------- hero ----------------
func _edge_world(id: String, fd: float, ang: float) -> Vector2:   # 刃口法線（世界）：EA.held 先 rotate(ang) 再按 mir 鏡像
	var mir = EA.edge_side(id) != (1 if fd >= 0 else -1)
	var e = float(EA.edge_side(id)) * (-1.0 if mir else 1.0)
	return Vector2(cos(ang), sin(ang)) * e
func _hero_logic() -> void:
	ACE.force_pose = -1
	ACE.new_scene(); var p0 = ACE.pose_i()
	ACE._pose_next = 0.0; var p1 = ACE.pose_i()
	var seen = {}
	for i in 30: ACE.new_scene(); seen[ACE.pose_i()] = 1
	_chk("姿勢：入場隨機（30 次見到 %d 種）、到時換另一個（%d→%d）、下次換喺 18–35 秒後" % [seen.size(), p0, p1], seen.size() == 3 and p0 != p1 and ACE._pose_next - ACE._now() >= 17.9 and ACE._pose_next - ACE._now() <= 35.1)
	var S = J.G.S
	var sex0 = str(S.hero.get("sex", "m")) if S.get("hero") is Dictionary else "m"
	if not (S.get("hero") is Dictionary): S["hero"] = {}
	S.hero["sex"] = "m"; EQ.st()
	var wm = str(EQ.worn("afu").get("wea", ""))
	var km = Spr.key_for("afu_pose_b")
	S.hero["sex"] = "f"; EQ.st()
	var wf = str(EQ.worn("afu").get("wea", ""))
	var kf = Spr.key_for("afu_pose_b")
	S.hero["sex"] = sex0; EQ.st()
	_chk("主角預設兵器：男主斧（重）、女主三角尺（巧）；轉性別自動換", wm == "eq_hero_axe" and wf == "eq_hero_ruler" and EQ.cat_of("eq_hero_axe") == "重" and EQ.cat_of("eq_hero_ruler") == "巧", [wm, wf])
	_chk("女主姿勢圖自動換 afuf_pose_*", km == "afu_pose_b" and kf == "afuf_pose_b", [km, kf])
	_chk("主角兵器唔入製作／自動穿戴清單，其他鬼着唔到", not EQ.items("eq", "wea").has("eq_hero_axe") and EQ.why_not(_gid("toyol") if _gid("toyol") != "" else "x", "eq_hero_axe") != "")
	_chk("打法：斧＝揮斬、三角尺＝直刺；兩件都係長兵器、圖示斜放", EA.atk_style("eq_hero_axe") == "swing" and EA.atk_style("eq_hero_ruler") == "thrust" and EA.is_long("eq_hero_axe") and EA.is_long("eq_hero_ruler") and EA.HAND_SHAPES.has("axe") and EA.HAND_SHAPES.has("ruler"))
	_chk("菜刀（cleaver_old）入咗斜放圖示表同長兵器表（同柴刀一致）", EA.HAND_SHAPES.has("cleaver_old") and EA.LONG.has("cleaver_old"))
	# 刃口方向：待機刃口向面向邊；揮斬落刀時刃口行先；直刺時尖向目標
	var badE = []
	for id in ["eq_hero_axe", "eq_hero_ruler"]:
		var kp = "afu_pose_a" if id == "eq_hero_axe" else "afuf_pose_a"
		for fd in [1.0, -1.0]:
			var R = EV2.float_at(kp, id, Vector2.ZERO, 1.0, fd, {"T": 1.0, "act": "idle"}, 0.0)
			if signf(_edge_world(id, fd, R[1]).x) != fd: badE.append([id, fd, "idle"])
			var tg = Vector2(fd * 1.6, -0.5)
			if EA.atk_style(id) == "swing":
				for ph in [0.36, 0.42, 0.48, 0.53]:
					var A = EV2.float_at(kp, id, Vector2.ZERO, 1.0, fd, {"T": 1.0, "act": "atk", "tg": tg}, ph)
					var B = EV2.float_at(kp, id, Vector2.ZERO, 1.0, fd, {"T": 1.0, "act": "atk", "tg": tg}, ph + 0.01)
					var tipA = A[0] + Vector2(sin(A[1]), -cos(A[1])) * A[2] * 0.5; var tipB = B[0] + Vector2(sin(B[1]), -cos(B[1])) * B[2] * 0.5
					if _edge_world(id, fd, A[1]).dot(tipB - tipA) <= 0.0: badE.append([id, fd, "swing", ph])
			else:
				var A2 = EV2.float_at(kp, id, Vector2.ZERO, 1.0, fd, {"T": 1.0, "act": "atk", "tg": tg}, 0.5)
				if Vector2(sin(A2[1]), -cos(A2[1])).dot(tg - A2[0]) <= 0.0: badE.append([id, fd, "thrust"])
	_chk("漂浮兵器刃口方向（斧、三角尺 × 面向左右 × 待機／出手）全部啱", badE.is_empty(), badE)

# ---------------- ui ----------------
func _ui(t, m) -> void:
	var S = J.G.S
	var SD = load("res://game/soul/soul_data.gd")
	SD._bypass = true
	for k in ["heiwu", "baiwu", "niutou", "mamian", "mengpo", "pontianak", "bm_shuten"]:
		if _gid(k) == "": J.cl(J.G.get("joinGhost"), null, [k])
	SD._bypass = false
	await _skip(t, 8)
	var CX = load("res://game/soul/soul_codex.gd")
	for s in [0, 3, 5]:
		for k in ["heiwu", "baiwu", "mengpo", "bm_shuten"]: _set_star(k, s)
		for k in ["heiwu", "baiwu", "mengpo"]:
			CX.open_detail(k); await _w(t, 0.5)
			await _shot44(t, "codex_%s_star%d" % [k, s])
	_set_star("bm_shuten", 4); CX.open_detail("bm_shuten"); await _w(t, 0.5); await _shot44(t, "codex_bm_shuten_star4")
	_set_star("bm_shuten", 5); CX.open_detail("bm_shuten"); await _w(t, 0.5); await _shot44(t, "codex_bm_shuten_star5")
	for k in ["heiwu", "mengpo"]: _set_star(k, 3)
	_set_star("baiwu", 5)
	CX.open(); await _w(t, 0.6); await _shot44(t, "codex_grid")
	Menus.open_roster(); await _w(t, 0.6); await _shot44(t, "roster")
	m.close_sheet()
	await _w(t, 0.4)

# ---------------- battle ----------------
func _bc_of(k: String):
	var RV = load("res://game/rts/rts_view.gd")
	if RV.inst == null: return null
	for key in RV.inst.vis:
		for ch in RV.inst.vis[key].chars:
			if ch.pu.k == k: return ch
	return null
func _solo(t, m) -> void:   # 只派主角：近鏡睇清空手姿勢＋漂浮兵器
	var S = J.G.S
	_stall(150.0)
	S["team"] = [_gid("afu")]
	var op = await _start(t, m, 0.0)
	if op == null: _chk("主角單獨出陣戰鬥開到", false); return
	for u in op.units: u["hp"] = J.num(u.hp) * 20; u["maxhp"] = J.num(u.maxhp) * 20
	var hu = {}
	for u in op.units: if str(u.k) == "afu": hu = u
	_chk("主角單獨出陣（%s）" % [op.units.map(func(x): return str(x.k))], not hu.is_empty())
	if hu.is_empty(): return
	for sex in ["m", "f"]:
		S.hero["sex"] = sex; EQ.st()
		if hu.get("eq") is Dictionary: hu.eq["wea"] = EQ.hero_wea()   # 戰鬥開打時抄咗一份；測試中途轉性別要跟住換
		for i in 3:
			ACE.force_pose = i
			_cam(m, (hu.p as Vector2) + Vector2(10, -25), 80.0)
			await _w(t, 0.5)
			var ci = await _crop_img(t, m, (hu.p as Vector2) + Vector2(15, -30), Vector2(200, 170), 3.0)
			ci.save_png(SH44 + "solo_%s_pose%d.png" % [sex, i])
		for j in 150:
			var a = hu.get("anim")
			if a is Dictionary and str(a.get("name")) == "strike": break
			await _f(t, 1)
		var ci2 = await _crop_img(t, m, (hu.p as Vector2) + Vector2(30, -30), Vector2(220, 170), 3.0)
		ci2.save_png(SH44 + "solo_%s_atk.png" % sex)
	ACE.force_pose = -1; S.hero["sex"] = "m"; EQ.st()
	B_end(op)
	await _w(t, 3.0)
	await _skip(t, 6)
func _battle(t, m) -> void:
	var S = J.G.S
	_stall(150.0)
	S["team"] = [_gid("afu"), _gid("heiwu"), _gid("baiwu")]
	_set_star("heiwu", 3); _set_star("baiwu", 5)
	var op = await _start(t, m, 0.0)
	_chk("1-1 地圖戰鬥開到", op != null, op)
	if op == null: return
	for u in op.units: u["hp"] = J.num(u.hp) * 20; u["maxhp"] = J.num(u.maxhp) * 20
	await _w(t, 0.5)
	var hc = _bc_of("afu"); var hw = _bc_of("heiwu"); var bw = _bc_of("baiwu")
	_chk("戰鬥：主角整張空手圖（plain）＋漂浮兵器層", hc != null and hc.pc.hero and hc.pc.mode == "plain" and hc.get_node_or_null("EqOver") != null, [hc != null, hc.pc.mode if hc else ""])
	_chk("戰鬥：黑無常（★3→第二階）、白無常（★5→第三階）用階段圖整張畫", hw != null and bw != null and hw.pc.ace and bw.pc.ace and hw.pc.tex_plain == Spr.get_tex("ace_heiwu_s2") and bw.pc.tex_plain == Spr.get_tex("ace_baiwu_s3"), [hw != null, bw != null, hw.pc.ace if hw else null, bw.pc.ace if bw else null, hw.pc.tex_plain.resource_path if hw and hw.pc.tex_plain else "", bw.pc.tex_plain.resource_path if bw and bw.pc.tex_plain else "", S.team])
	var hu = {}
	for u in op.units: if str(u.k) == "afu": hu = u
	if hu.is_empty(): return
	var poses = {}
	for sex in ["m", "f"]:
		S.hero["sex"] = sex; EQ.st()
		if hu.get("eq") is Dictionary: hu.eq["wea"] = EQ.hero_wea()   # 戰鬥開打時抄咗一份；測試中途轉性別要跟住換
		for i in 3:
			ACE.force_pose = i
			_cam(m, (hu.p as Vector2) + Vector2(10, -25), 110.0)
			await _w(t, 0.5)
			var kp = ACE.pose_key()
			var lr = EV2.LAST.get(kp)
			poses[sex + str(i)] = lr is Rect2 and lr.size.length() > 0.05
			var ci = await _crop_img(t, m, (hu.p as Vector2) + Vector2(10, -28), Vector2(240, 220), 2.4)
			ci.save_png(SH44 + "battle_%s_pose%d.png" % [sex, i])
		# 出手一刻
		var got = false
		for j in 120:
			var a = hu.get("anim")
			if a is Dictionary and str(a.get("name")) == "strike": got = true; break
			await _f(t, 1)
		_cam(m, (hu.p as Vector2) + Vector2(10, -25), 110.0)
		var ci2 = await _crop_img(t, m, (hu.p as Vector2) + Vector2(25, -28), Vector2(260, 220), 2.4)
		ci2.save_png(SH44 + "battle_%s_atk.png" % sex)
		await _shot44(t, "battle_%s_full" % sex)
	ACE.force_pose = -1; S.hero["sex"] = "m"; EQ.st()
	_chk("戰鬥：男女主三個姿勢都畫到漂浮兵器（%s）" % [poses], poses.size() == 6 and not poses.values().has(false))
	B_end(op)
	await _w(t, 2.0)

# ---------------- 主角漂浮兵器對照表（用遊戲本身嘅畫法：PtGfx 姿勢圖＋EV2 float） ----------------
class HeroSheet extends Control:
	var cells := []   # [sex, pose, fd, act, ph, label]
	func _draw() -> void:
		var f = UIKit.font("sans", 900)
		draw_rect(Rect2(Vector2.ZERO, size), Color("#1e1820"))
		var EV2 = load("res://game/equip/eq_view2.gd"); var ACE2 = load("res://game/soul/ace_art.gd"); var EQ3 = load("res://game/equip/eq_data.gd")
		var cw = size.x / 3.0; var ch = 300.0
		for i in cells.size():
			var c = cells[i]
			var S = J.G.S; S.hero["sex"] = c[0]
			var x0 = (i % 3) * cw; var y0 = 40.0 + int(i / 3) * ch
			draw_rect(Rect2(x0 + 3, y0 + 3, cw - 6, ch - 6), Color("#2c2430"))
			var H = 150.0; var fd: float = c[2]
			var foot = Vector2(x0 + cw * (0.38 if fd > 0 else 0.62), y0 + ch - 34)
			var tgv = Vector2(fd * 1.15 * H, -0.45 * H)
			if c[3] != "idle": draw_circle(foot + tgv, 8, Color("#c8483a"))
			var kp = ACE2.POSES[c[1]]
			var tex = PtGfx.tex(kp)
			var wea = EQ3.hero_wea()
			var ctx = Ctx.new(self)
			EV2.draw(ctx, "float", kp, {"wea": wea}, foot, H, fd, {"T": 1.0, "act": c[3], "ph": c[4], "tg": tgv}, false, "back")
			if tex != null:
				var Wd = H * tex.get_width() / float(tex.get_height())
				if fd > 0: draw_set_transform_matrix(Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(2.0 * foot.x, 0)))
				draw_texture_rect(tex, Rect2(foot.x - Wd * 0.5, foot.y - H, Wd, H), false)
				draw_set_transform_matrix(Transform2D.IDENTITY)
			EV2.draw(ctx, "float", kp, {"wea": wea}, foot, H, fd, {"T": 1.0, "act": c[3], "ph": c[4], "tg": tgv}, false, "front")
			draw_string(f, Vector2(x0 + 10, y0 + 24), str(c[5]), HORIZONTAL_ALIGNMENT_LEFT, cw - 16, 17, Color("#f0e2c8"))
		J.G.S.hero["sex"] = "m"
func solo(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH44)
	await _solo(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func hero_sheet(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH44)
	await _hero_sheet(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func _hero_sheet(t, m) -> void:
	var sex0 = str(J.G.S.hero.get("sex", "m"))
	for sex in ["m", "f"]:
		var sh = HeroSheet.new(); sh.size = Vector2(900, 40 + 300 * 3)
		var nm = "男主" if sex == "m" else "女主"
		var wn = "斧（揮斬）" if sex == "m" else "三角尺（直刺）"
		var PN = ["A 垂手", "B 舉手", "C 手放肚"]
		for p in 3: sh.cells.append([sex, p, 1.0, "idle", 0.0, "姿勢%s・待機・面向右" % PN[p]])
		for p in 3: sh.cells.append([sex, p, -1.0, "idle", 0.0, "姿勢%s・待機・面向左" % PN[p]])
		var ph = 0.45 if sex == "m" else 0.5
		sh.cells.append([sex, 0, 1.0, "atk", ph, "普攻・面向右"])
		sh.cells.append([sex, 0, -1.0, "atk", ph, "普攻・面向左"])
		sh.cells.append([sex, 1, 1.0, "sk", 0.36, "放技能・面向右"])
		var hd = Label.new(); hd.text = "%s空手三姿勢＋漂浮%s（紅點＝目標）" % [nm, wn]; hd.position = Vector2(12, 6); hd.add_theme_font_size_override("font_size", 22); hd.add_theme_color_override("font_color", Color("#f0e2c8")); sh.add_child(hd)
		var sv = SubViewport.new(); sv.size = Vector2i(sh.size); sv.transparent_bg = false; sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		sv.add_child(sh); m.add_child(sv)
		await _f(t, 3); await RenderingServer.frame_post_draw
		sv.get_texture().get_image().save_png(SH44 + "hero_sheet_%s.png" % sex); _p("shot hero_sheet_" + sex)
		sv.queue_free(); await _f(t, 2)
	J.G.S.hero["sex"] = sex0; EQ.st()
