# [int] 走查總覽補圖：陰間酒館面板、化寶爐面板（整合版實機）
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> xshots res://tools/tests/int_extra_shots.gd all 600
extends "res://tools/tests/post_test.gd"
func all(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	DirAccess.make_dir_recursive_absolute("/tmp/xshots/")
	var MN = load("res://ui/menus/menus.gd")
	for id in ["altar", "furnace"]:
		if int(J.num(S.bld.get(id, 0))) < 1: S.bld[id] = 1.0
	S.res["coins"] = maxf(J.num(S.res.get("coins", 0)), 5000.0)
	for id in ["altar", "furnace"]:
		MN.open_bld(id); await _w(t, 1.5); _clean(t)
		await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png("/tmp/xshots/%s.png" % id); _p("shot " + id)
		if id == "altar":   # 祭壇「招雜鬼」頁＝陰間酒館
			var tb = null
			for b in m.find_children("*", "Button", true, false):
				if is_instance_valid(b) and b.is_visible_in_tree() and str(b.text).find("招雜鬼") >= 0: tb = b; break
			if tb != null:
				tb.pressed.emit(); await _w(t, 1.2); _clean(t)
				await RenderingServer.frame_post_draw
				t.get_viewport().get_texture().get_image().save_png("/tmp/xshots/tavern.png"); _p("shot tavern")
		if m.has_method("close_sheet"): m.close_sheet()
		await _w(t, 0.6)
	print("[post] RESULT ok=1 bad=0")
