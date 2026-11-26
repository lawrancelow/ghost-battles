# [equip-list] 武器裝備清單：用遊戲實際畫法（eq_art.icon／held、eq_view2 漂浮）逐件出圖，畀 tools/eqlist_sheet.py 排版
# 用法：tools/devkit/edtest.sh <godot目錄> eqlist res://tools/tests/eqlist_test.gd all 300
#   出：OUT/icons.png（每件圖示，透明底）、OUT/held.png（手持直立）、OUT/float.png（名鬼漂浮兵器：待機／揮落中左右／命中）
#   OUT/layout.json：每張圖嘅格位
extends RefCounted

const OUT := "/home/claude/art/out/raw/"
const EQ = preload("res://game/equip/eq_data.gd")
const EA = preload("res://game/equip/eq_art.gd")
var ok := 0
var bad := 0
func _p(m): print("[eqlist] ", m)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout

class IconSheet extends Control:
	var ids := []
	var cols := 8
	var cw := 240.0
	var mode := "icon"   # icon / held
	func _draw() -> void:
		var EA2 = load("res://game/equip/eq_art.gd")
		for i in ids.size():
			var id = str(ids[i])
			var x0 = (i % cols) * cw; var y0 = int(i / cols) * cw
			var ctx = Ctx.new(self)
			if mode == "icon": EA2.icon(ctx, id, x0 + cw * 0.5, y0 + cw * 0.5 + 100.0, 200.0, true)
			else: EA2.held(ctx, id, x0 + cw * 0.5, y0 + cw - 18.0, 200.0, 0.0, false)

class FloatSheet extends Control:
	const FLOAT_K2 := "youhun"
	var cells := []   # [id, fd, act, ph]
	var cols := 4
	var cw := 320.0
	func _draw() -> void:
		var EV2 = load("res://game/equip/eq_view2.gd")
		for i in cells.size():
			var c = cells[i]
			var x0 = (i % cols) * cw; var y0 = int(i / cols) * cw
			draw_rect(Rect2(x0 + 2, y0 + 2, cw - 4, cw - 4), Color("#2c2430"))
			var ctx = Ctx.new(self)
			var H = 150.0; var fd = float(c[1])
			var foot = Vector2(x0 + cw * (0.30 if fd > 0 else 0.70), y0 + cw - 22)
			var tgv = Vector2(fd * 0.95 * H, -0.45 * H)
			if str(c[2]) != "idle": draw_circle(foot + tgv, 10, Color("#c8483a"))   # 目標
			var tex = PtGfx.tex(Art.spr_key(FLOAT_K2))
			if tex != null:
				var Wd = H * tex.get_width() / float(tex.get_height())
				if fd < 0: draw_set_transform_matrix(Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(2.0 * foot.x, 0)))
				draw_texture_rect(tex, Rect2(foot.x - Wd * 0.5, foot.y - H, Wd, H), false, Color(1, 1, 1, 0.45))
				draw_set_transform_matrix(Transform2D.IDENTITY)
			EV2.draw(ctx, "float", FLOAT_K2, {"wea": str(c[0])}, foot, H, fd, {"T": 1.0, "act": str(c[2]), "ph": float(c[3]), "tg": tgv}, false, "back")
			EV2.draw(ctx, "float", FLOAT_K2, {"wea": str(c[0])}, foot, H, fd, {"T": 1.0, "act": str(c[2]), "ph": float(c[3]), "tg": tgv}, false, "front")

func _cap(t, ctl: Control, sz: Vector2i, path: String) -> void:
	var sv = SubViewport.new()
	sv.size = sz; sv.transparent_bg = true
	sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	t.get_tree().root.add_child(sv)
	ctl.size = Vector2(sz); sv.add_child(ctl)
	for i in 4:
		ctl.queue_redraw(); await t.get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img = sv.get_texture().get_image()
	img.save_png(path); _p("saved %s %s" % [path, img.get_size()])
	sv.queue_free()

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	for i in 60:
		var m0 = t.get_tree().root.get_node_or_null("Main")
		if m0 and m0.get("loading") == null: break
		await _w(t, 0.5)
	await _w(t, 1.0)
	var ids = []
	for id in EQ.D().ITEMS: ids.append(str(id))
	var lay = {"ids": ids, "cw": 240, "cols": 8}
	var s1 = IconSheet.new(); s1.ids = ids
	var rows = int(ceil(ids.size() / 8.0))
	await _cap(t, s1, Vector2i(8 * 240, rows * 240), OUT + "icons.png")
	var hand = []
	for id in ids: if str(EQ.item(id).get("look")) == "hand": hand.append(id)
	var s2 = IconSheet.new(); s2.ids = hand; s2.mode = "held"
	await _cap(t, s2, Vector2i(8 * 240, int(ceil(hand.size() / 8.0)) * 240), OUT + "held.png")
	lay["held"] = hand
	# 漂浮：只係名鬼兵器（kind eq、slot wea）
	var fl = []
	for id in ids:
		var it = EQ.item(id)
		if str(it.get("kind")) == "eq" and str(it.get("slot")) == "wea": fl.append(id)
	var s3 = FloatSheet.new()
	for id in fl:
		s3.cells += [[id, 1.0, "idle", 0.0], [id, 1.0, "atk", 0.45], [id, -1.0, "atk", 0.45], [id, 1.0, "atk", 0.60]]
	await _cap(t, s3, Vector2i(4 * 320, fl.size() * 320), OUT + "float.png")
	lay["float"] = fl
	var info = {}
	for id in ids:
		info[id] = {"has_img": EA.has_img(id), "has_icon": EA.has_icon(id), "atk": EA.atk_style(id), "edge": EA.edge_side(id), "long": EA.is_long(id), "shape": EA.shape_of(id)}
	lay["info"] = info
	var SD = load("res://game/soul/soul_data.gd"); var RO = load("res://game/rts/roles.gd"); var UP = load("res://game/soul/soul_up.gd")
	var ros = {}
	var ks = SD.GH().keys(); ks.append("afu")
	for k in ks:
		var A = EQ.D().get("ANCHOR", {}).get(str(k), {})
		ros[str(k)] = {"n": SD.gname(str(k)), "pin": SD.pin(str(k)), "ace": UP.born_ace(str(k)), "cls": RO.cls_of(str(k)), "nh": str(A.get("nh", "")) if A is Dictionary else "", "anchor": A is Dictionary and not A.is_empty(), "spr": Spr.ok(Art.spr_key(str(k))), "unsum": SD.unsummonable(str(k))}
	lay["roster"] = ros
	var f = FileAccess.open(OUT + "layout.json", FileAccess.WRITE); f.store_string(JSON.stringify(lay, " ")); f.close()
	_p("RESULT ok=%d bad=%d items=%d hand=%d float=%d" % [ok, bad, ids.size(), hand.size(), fl.size()])
