# [p55] 頭像總表：名鬼圖鑑全部鬼（S2.list）逐隻用 UIKit.portrait 砌成一頁頁截圖，人手睇有冇切臉
# 用法：UX_OUT=/tmp/p55/por_after/ edtest.sh <godot目錄> porsheet res://tools/tests/por_sheet.gd all 600
extends RefCounted
var OUT := "/tmp/p55/por/"
func _p(s) -> void: print("[porsheet] ", s)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func all(t) -> void:
	var eo = OS.get_environment("UX_OUT")
	if eo != "": OUT = eo
	DirAccess.make_dir_recursive_absolute(OUT)
	for i in 120:
		await _w(t, 0.5)
		var m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.0)
	var keys = []
	for x in load("res://game/soul/soul2.gd").list(): keys.append(str(x.k))
	for k in ["afu", "xiaozhi", "douhua"]: if not keys.has(k): keys.push_front(k)
	_p("n=%d" % keys.size())
	var layer = CanvasLayer.new(); layer.layer = 120; t.get_tree().root.add_child(layer)
	var per = 32; var pg = 0
	while pg * per < keys.size():
		for c in layer.get_children(): layer.remove_child(c); c.queue_free()
		var bg = ColorRect.new(); bg.color = Color("#d8c4a0"); bg.size = Vector2(450, 975); layer.add_child(bg)
		for i in per:
			var idx = pg * per + i
			if idx >= keys.size(): break
			var k = keys[idx]
			var x = 4 + (i % 4) * 96; var y = 4 + (i / 4) * 104
			var fr = ColorRect.new(); fr.color = Color("#3a2a20"); fr.position = Vector2(x, y); fr.size = Vector2(88, 88); layer.add_child(fr)
			var tr = UIKit.portrait(k, 84); tr.position = Vector2(x + 2, y + 2); tr.size = Vector2(84, 84); layer.add_child(tr)
			var lb = Label.new(); lb.text = k.substr(0, 14); lb.position = Vector2(x, y + 87); lb.add_theme_font_size_override("font_size", 10); lb.add_theme_color_override("font_color", Color.BLACK); layer.add_child(lb)
		await t.get_tree().process_frame; await t.get_tree().process_frame
		await RenderingServer.frame_post_draw
		t.get_viewport().get_texture().get_image().save_png(OUT + "por_%02d.png" % pg); _p("SHOT %d" % pg)
		pg += 1
	_p("RESULT ok=1 bad=0")
