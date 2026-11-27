# [p47] 測試：軍團頭像框 PCROP、村子主角空手姿勢＋漂浮兵器（做嘢用做工動畫）、巡陰主角空手＋漂浮兵器、敵方同名鬼用第一階
# 用法：bash godot/tools/devkit/edtest.sh <godot目錄> p47 res://tools/tests/p47_test.gd all 900
#   截圖：/home/claude/docs/shots/p47/
extends "res://tools/tests/eqview2_test.gd"

const ACE = preload("res://game/soul/ace_art.gd")
const HV = preload("res://game/soul/hero_vil.gd")
const WA = preload("res://game/outpost/work_anim.gd")
const SH := "/home/claude/docs/shots/p47/"

func _p(m): print("[p47] ", m)

func all(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH)
	_logic()
	await _crops(t, m)
	await _village(t, m)
	await _patrol(t, m)
	await _audit(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func audit(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH)
	await _audit(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _logic() -> void:
	for k in ["lg_wkj_tank", "lg_zzj_king", "lg_wkj_elite"]:
		var r = Art.portrait_region(k)
		_chk("%s 頭像有裁切（PCROP）" % k, load("res://core/art_impl.gd").PCROP.has(k) and r.size() == 2)
		if r.size() == 2:
			var tex: Texture2D = r[0]; var rc: Rect2 = r[1]
			_chk("%s 裁切喺圖內（唔出框）" % k, rc.position.x >= 0 and rc.position.y >= 0 and rc.end.x <= tex.get_width() + 0.5 and rc.end.y <= tex.get_height() + 0.5, str(rc))
	_chk("村子主角用空手（HV.active）", HV.active())
	var S = J.G.S
	for sex in ["m", "f"]:
		S.hero["sex"] = sex; EQ.st()
		var w = HV.hero_wea()
		_chk("村子主角預設兵器（%s）＝%s" % [sex, w], w == ACE.hero_weapon())
	S.hero["sex"] = "m"; EQ.st()
	# 敵方同名鬼：第一階圖存在
	for k in ["niutou", "mamian", "heiwu"]:
		_chk("%s 第一階圖（敵方用）" % k, Spr.ok(ACE.key(k, 1)))

# 頭像框實際畫面：名冊／圖鑑用嘅 UIKit.portrait
func _crops(t, m) -> void:
	var hb = HBoxContainer.new(); hb.position = Vector2(10, 120); hb.add_theme_constant_override("separation", 8)
	var bg = ColorRect.new(); bg.color = Color("#1c1418"); bg.position = Vector2(0, 100); bg.size = Vector2(450, 140)
	m.add_child(bg); m.add_child(hb)
	for k in ["lg_wkj_tank", "lg_zzj_king", "lg_wkj_elite"]:
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color("#3a2c26"), 6, Color("#b89a52"), 2, Vector4(4, 4, 4, 4)))
		pc.add_child(UIKit.portrait(k, 110)); hb.add_child(pc)
	await _w(t, 0.6)
	await RenderingServer.frame_post_draw
	var img = t.get_viewport().get_texture().get_image()
	var k2 = Vector2(img.get_size()) / t.get_viewport().get_visible_rect().size
	img.get_region(Rect2i(Vector2i(0, int(100 * k2.y)), Vector2i(img.get_width(), int(140 * k2.y)))).save_png(SH + "legion_portraits.png")
	_p("shot legion_portraits")
	hb.queue_free(); bg.queue_free()
	await _f(t, 2)

func _hero_world(): return J.G.Village.hero

func _village(t, m) -> void:
	var V = J.G.Village; var S = J.G.S
	for sex in ["m", "f"]:
		S.hero["sex"] = sex; EQ.st()
		var H = V.hero
		# 待機：三個姿勢
		H["act"] = null; H["walking"] = false
		for i in 3:
			ACE.force_pose = i
			_cam(m, Vector2(J.num(H.x), J.num(H.y) - 25), 90.0)
			await _w(t, 0.5)
			_chk("村子主角待機（%s 姿勢%d）用空手圖＋漂浮兵器" % [sex, i], str(HV.LAST.get("mode")) == "idle" and str(HV.LAST.get("pose")) == ACE.POSES[i] and str(HV.LAST.get("wea")) != "", str(HV.LAST))
			var ci = await _crop_img(t, m, Vector2(J.num(H.x), J.num(H.y) - 28), Vector2(160, 140), 3.0)
			ci.save_png(SH + "vil_%s_idle%d.png" % [sex, i])
		ACE.force_pose = -1
		# 斬樹：搵一棵仲有樹嘅
		var TP = J.G.TREE_POS; var ti = -1
		for i in TP.size(): if J.num(S.trees[i]) > 0: ti = i; break
		if ti < 0: S.trees[0] = 3; ti = 0
		var tp = TP[ti]
		J.mc(V, "walkTo", [J.num(tp[0]) + 20, J.num(tp[1]) + 4, {"kind": "tree", "i": float(ti)}])
		var seen_work = false; var hit_ok = false; var shot = false
		for f in 600:
			await _f(t, 1)
			if str(HV.LAST.get("mode")) == "work" and str(HV.LAST.get("verb")) == "chop":
				seen_work = true
				var L = WA.LAST.get("afu", {})
				var ed = L.get("edge", {})
				if bool(ed.get("hit", false)) and ed.get("tools") is Array and (ed.tools as Array).size() > 0 and ed.get("tgt") is Vector2:
					var tl = ed.tools[0]
					var mid = ((tl.a as Vector2) + (tl.b as Vector2)) * 0.5
					hit_ok = (tl.n as Vector2).dot((ed.tgt as Vector2) - mid) > 0.0 or (tl.n as Vector2).x * float(ed.fd) > 0.0
					if not shot:
						_cam(m, Vector2(J.num(H.x), J.num(H.y) - 25), 90.0)
						var ci2 = await _crop_img(t, m, Vector2(J.num(H.x) - 10, J.num(H.y) - 28), Vector2(180, 150), 3.0)
						ci2.save_png(SH + "vil_%s_chop_hit.png" % sex); shot = true
					break
		_chk("村子主角斬樹（%s）用做工動畫（浮斧）" % sex, seen_work, str(HV.LAST))
		_chk("村子主角斬樹（%s）斬中一刻刀口朝樹" % sex, hit_ok)
		if not shot:
			var ci3 = await _crop_img(t, m, Vector2(J.num(H.x) - 10, J.num(H.y) - 28), Vector2(180, 150), 3.0)
			ci3.save_png(SH + "vil_%s_chop.png" % sex)
		H["act"] = null; H["walking"] = false
		await _w(t, 0.5)
	S.hero["sex"] = "m"; EQ.st()

func _patrol(t, m) -> void:
	var S = J.G.S
	for sex in ["m", "f"]:
		S.hero["sex"] = sex; EQ.st()
		var okr = PtRun.start_run(1, 0)
		_chk("巡陰開到（%s）" % sex, okr)
		if not okr: return
		await _w(t, 3.0)
		await _skip(t, 6)
		var r = PtRun.cur
		var lv = null
		for u in r.units:
			if u.leader and u.view != null: lv = u.view
		_chk("巡陰主角（%s）用空手姿勢" % sex, lv != null and lv.hero and lv.mode == "plain")
		_chk("巡陰主角（%s）有漂浮兵器層" % sex, lv != null and lv.hwpn != null)
		if lv != null:
			_chk("巡陰主角（%s）兵器＝%s" % [sex, lv.hero_wea()], lv.hero_wea() == ACE.hero_weapon() or str(EQ.item(lv.hero_wea()).get("look")) == "hand")
		await RenderingServer.frame_post_draw
		var img = t.get_viewport().get_texture().get_image()
		img.save_png(SH + "patrol_%s_full.png" % sex)
		if lv != null:
			var sp = lv.get_global_transform_with_canvas().origin * Vector2(img.get_size()) / t.get_viewport().get_visible_rect().size
			var sz = Vector2i(200, 180)
			var rc = Rect2i(Vector2i(clampi(int(sp.x) - 100, 0, img.get_width() - sz.x), clampi(int(sp.y) - 140, 0, img.get_height() - sz.y)), sz)
			var c = img.get_region(rc); c.resize(600, 540, Image.INTERPOLATE_LANCZOS); c.save_png(SH + "patrol_%s_hero.png" % sex)
			# 出手：等主角揮兵器（最多 25 秒）
			var got = false
			for f in 1500:
				await _f(t, 1)
				if lv.o is Dictionary and str(lv.o.get("pose", "")) == "strike":
					got = true
					await RenderingServer.frame_post_draw
					var img2 = t.get_viewport().get_texture().get_image()
					var sp2 = lv.get_global_transform_with_canvas().origin * Vector2(img2.get_size()) / t.get_viewport().get_visible_rect().size
					var rc2 = Rect2i(Vector2i(clampi(int(sp2.x) - 100, 0, img2.get_width() - sz.x), clampi(int(sp2.y) - 140, 0, img2.get_height() - sz.y)), sz)
					var c2 = img2.get_region(rc2); c2.resize(600, 540, Image.INTERPOLATE_LANCZOS); c2.save_png(SH + "patrol_%s_atk.png" % sex)
					break
			_p("巡陰主角（%s）出手截圖：%s" % [sex, "有" if got else "冇遇到敵人"])
		if is_instance_valid(r): r._cover(false); r.queue_free()
		PtRun.cur = null
		await _w(t, 1.0)
	S.hero["sex"] = "m"; EQ.st()

# ================= 空手稽查（老闆 11-27：所有角色空手、兵器漂浮）=================
#   記低每個場景實際攞過嘅圖鍵（Spr.get_tex／PtGfx.tex／Ctx.drawImage），對照「手持兵器圖」名單：
#   FIX＝有空手版、應該已換走嘅（出現＝程式漏改，要 0）；ART＝仲未有空手圖（要美術補，唔計 bad，列清單）
const AC = preload("res://game/soul/ace_art.gd")
static func fix_set() -> Dictionary:
	var d = {}
	for k in ["afu", "afuf", "afu_body", "afuf_body", "afu__axe", "afu__wpn", "afuf__axe", "afuf__wpn",
			"baiwu__wpn", "heiwu__wpn", "mamian__wpn", "mengpo__wpn", "niutou__wpn", "tool_baiwu", "tool_mamian", "tool_niutou"]: d[k] = 1
	for k in AC.STAGES: if not AC.KEEP_DLG.has(k) or true: d[k] = 1   # 王牌原圖（對話例外另計，稽查唔入對話）
	for k in AC.NWP: d[k] = 1   # 軍團持兵器原圖
	return d
const ART_TODO := {"huang": "黃總（高爾夫球棍）", "huang__body": "黃總身體圖（揸球棍）", "huang__wpn": "黃總球棍分件", "foe_taoist": "敵方道士（劍）",
	"npc_daoshi": "道士 NPC（劍）", "n30_kuchisake": "裂口女（剪刀）", "n30_yecha": "夜叉（三叉戟）", "nw_dullahan": "無頭騎士（脊骨鞭）",
	"zd_bone": "骷髏兵雜兵（矛＋盾）", "lg_ssg_bing": "食屍鬼兵（骨棒）", "n30_vetala": "韋陀羅（杖，疑似）", "n30_chehuo": "車禍鬼（扳手，疑似）",
	"lg_dpl_tank": "地痞坦（坑渠蓋盾）", "lg_egs_tank": "餓死鬼坦（石球）", "lg_sgj_tank": "水鬼坦（門板）", "lg_ssg_tank": "食屍鬼坦（墓碑）", "lg_zzj_tank": "紙紮坦（盾）"}
func _aud_begin() -> void: Spr.audit = {}
func _aud_end(scene: String, fix: Dictionary, todo: Dictionary) -> void:
	var a: Dictionary = Spr.audit if Spr.audit is Dictionary else {}
	Spr.audit = null
	var bad_k = []; var todo_k = []
	for k0 in a:
		var k = str(k0).trim_prefix("@")
		if fix.has(k): bad_k.append(k)
		elif ART_TODO.has(k): todo_k.append(k); todo[k] = true
	_chk("稽查［%s］冇手持兵器圖（用過 %d 個圖鍵）" % [scene, a.size()], bad_k.is_empty(), str(bad_k))
	if todo_k.size(): _p("稽查［%s］未有空手圖（待美術）：%s" % [scene, todo_k])
func _audit(t, m) -> void:
	var fix = fix_set(); var todo = {}
	var S = J.G.S
	for sex in ["m", "f"]:
		S.hero["sex"] = sex; EQ.st(); PtGfx._tex.clear()
		# 村子（主角、廣場鬼、派工鬼）
		_aud_begin()
		var V = J.G.Village; V.hero["act"] = null
		for i in 8:
			_cam(m, Vector2(J.num(V.hero.x), J.num(V.hero.y) - 25), 60.0 + i * 20.0); await _w(t, 0.5)
		_aud_end("村子・%s" % sex, fix, todo)
		# 名冊
		_aud_begin(); m.open_roster(); await _w(t, 1.5); await _shot(t, "aud_roster_" + sex); m.close_sheet(); await _w(t, 0.3)
		_aud_end("名冊・%s" % sex, fix, todo)
		# 圖鑑
		_aud_begin()
		var CX = load("res://game/soul/soul_codex.gd")
		CX.open(); await _w(t, 2.0); await _shot(t, "aud_codex_" + sex)
		CX.open_detail("heiwu"); await _w(t, 1.0)
		Menus.close_hook(); await _w(t, 0.3)
		_aud_end("圖鑑・%s" % sex, fix, todo)
		# 巡陰
		_aud_begin()
		if PtRun.start_run(1, 0):
			await _w(t, 6.0); await _skip(t, 6); await _shot(t, "aud_patrol_" + sex)
			var r = PtRun.cur
			if is_instance_valid(r): r._cover(false); r.queue_free()
			PtRun.cur = null
		await _w(t, 1.0)
		_aud_end("巡陰・%s" % sex, fix, todo)
	S.hero["sex"] = "m"; EQ.st(); PtGfx._tex.clear()
	# 地圖戰鬥：王牌＋軍團（主角＋幾隻王牌出陣，打 1-1）
	_aud_begin()
	await _team(t, ["afu", "heiwu", "baiwu", "niutou", "mamian", "mengpo"])
	var op = await _start(t, m, 200.0)
	if op != null:
		for i in 12: await _w(t, 0.5)
		await _shot(t, "aud_battle")
		B_end(op); await _w(t, 3.0); await _skip(t, 6)
	_aud_end("地圖戰鬥", fix, todo)
	var lst = []
	for k in todo: lst.append("%s＝%s" % [k, ART_TODO[k]])
	_p("待美術補空手圖（實際出現過）：%s" % [lst])
	var all_l = []
	for k in ART_TODO: all_l.append("%s＝%s" % [k, ART_TODO[k]])
	_p("待美術補空手圖（全部清單）：%s" % [all_l])
