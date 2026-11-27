# [uilayer] 面板層級測試：打開台面板／派鬼揀人時，地圖角色、關卡提示、浮動掣全部喺遮罩下面、撳唔到；提示字喺最上；關咗恢復
# 用法：/home/claude/setup/edtest.sh <godot目錄> uil res://tools/tests/ui_layer_test.gd logic
extends RefCounted

var ok := 0
var bad := 0
const SHOTS := "/home/claude/docs/ui_layer_shots/"
const T0 = preload("res://tools/tests/sortie_test.gd")
const MD = preload("res://game/outpost/mv_data.gd")

func _p(m): print("[uil] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String) -> void:
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _max_layer(root: Node, skip: Node) -> int:   # 除咗 skip 之外，所有可見 CanvasLayer 最高層數（扣除 Toast／Vfx／EqPopup）
	var mx = -999
	for n in root.find_children("*", "CanvasLayer", true, false):
		if n == skip or not n.visible: continue
		if str(n.name) in ["ToastLayer", "VfxTop", "EqPopup"]: continue
		if n.is_ancestor_of(skip) or skip.is_ancestor_of(n): continue
		mx = maxi(mx, n.layer)
	return mx
func _hit(t, p: Vector2) -> Control:   # 撳 p 會落喺邊個 Control
	var vp = t.get_viewport()
	vp.warp_mouse(p)
	await t.get_tree().process_frame
	return vp.gui_get_hovered_control()

func logic(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var T = T0.new()
	var m = await T._boot(t)
	await T._prep(t, m)
	var sc = m.mv_view
	var sid = ""
	for s in MD.stations(sc.sim.ci()):
		if sc.sim.unlocked(s): sid = s; if s == "st_shoubao": break
	_chk("有已解鎖嘅台", sid != "", sid)
	sc.focus_station(sid); await _w(t, 0.6)
	sc.open_sheet(sid); await _w(t, 0.6)
	var root = t.get_tree().root
	_chk("台面板喺獨立高層", sc.ui_cl != null and sc.ui_cl.visible and sc.ui_cl.is_ancestor_of(sc.sheet), sc.ui_cl.layer if sc.ui_cl else -1)
	_chk("台面板層數高過地圖其他層", sc.ui_cl.layer > _max_layer(root, sc.ui_cl), "%d > %d" % [sc.ui_cl.layer, _max_layer(root, sc.ui_cl)])
	var psb = sc.sheet.get_theme_stylebox("panel")   # [uikit] 套件：紙紋 StyleBoxTexture（不透明紙圖）亦算
	_chk("面板底色唔透明", (psb is StyleBoxFlat and psb.bg_color.a >= 0.999) or (psb is StyleBoxTexture and psb.texture != null and psb.modulate_color.a >= 0.999), psb)
	var srect: Rect2 = sc.sheet.get_global_rect()
	var vsz = root.get_visible_rect().size
	_chk("面板喺畫面入面", srect.size.y > 200 and srect.position.y >= 0 and srect.end.y <= vsz.y + 1, srect)
	var c = await _hit(t, srect.get_center())
	_chk("撳面板中間：落喺面板（唔俾外層搶）", c != null and (c == sc.sheet or sc.sheet.is_ancestor_of(c)), c)
	var c2 = await _hit(t, Vector2(vsz.x * 0.5, maxf(4.0, srect.position.y - 30.0)))
	_chk("撳面板外面：俾遮罩擋住（地圖撳唔到）", c2 == sc.ui_mask, c2)
	var chain_btn = sc.find_child("ChainBtn", true, false)
	await _shot(t, "a_sheet_portrait")
	# 派鬼揀人
	sc._open_picker(sid, 0); await _w(t, 0.4)
	_chk("派鬼揀人都喺高層", sc.picker != null and sc.ui_cl.is_ancestor_of(sc.picker))
	await _shot(t, "b_picker_portrait")
	sc._close_picker(); await _w(t, 0.2)
	_chk("關揀人：面板仲喺度", sc.ui_cl.visible and sc.sheet.visible)
	# 提示字喺面板上面
	m.show_toast("測試提示：面板上面都睇到"); await _w(t, 0.4)
	var tl = m.find_child("ToastLayer", false, false)
	_chk("提示字層高過面板", tl is CanvasLayer and tl.layer > sc.ui_cl.layer)
	await _shot(t, "c_toast_over_sheet")
	sc.close_sheet(); await _w(t, 0.3)
	_chk("關面板：高層收埋", not sc.ui_cl.visible)
	var c3 = await _hit(t, Vector2(vsz.x * 0.5, vsz.y * 0.5))
	_chk("關面板：遮罩唔再擋", c3 != sc.ui_mask)
	# 營地／通用面板（main.sheet）
	m.open_sheet("測試面板", func(): pass); await _w(t, 0.4)
	await _shot(t, "d_main_sheet_portrait")
	m.close_sheet()
	# 1920×1080
	root.size = Vector2i(1920, 1080); await _w(t, 1.2)
	sc.open_sheet(sid); await _w(t, 0.8)
	var xf = sc.sheet.get_global_transform_with_canvas()
	srect = Rect2(xf.origin, sc.sheet.size * xf.get_scale()); vsz = root.get_visible_rect().size
	_chk("寬螢幕：面板喺畫面入面", srect.position.x >= -1 and srect.end.x <= vsz.x + 1 and srect.position.y >= 0 and srect.end.y <= vsz.y + 1, srect)
	_chk("寬螢幕：面板置中、唔爆大（闊 ≤ 畫面一半）", absf(srect.get_center().x - vsz.x * 0.5) < 4.0 and srect.size.x <= vsz.x * 0.5, srect)
	_chk("寬螢幕：遮罩照擋", sc.ui_cl.visible and sc.ui_mask.mouse_filter == Control.MOUSE_FILTER_STOP)
	await _shot(t, "e_sheet_wide")
	sc.close_sheet()
	_p("RESULT ok=%d bad=%d" % [ok, bad])
