# [int] 鏡頭拉遠時市集名牌唔可以變成實心黑塊（mv_bake 細倍率烘圖）
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> mvbz res://tools/tests/mvbake_zoom_test.gd all 600
extends "res://tools/tests/post_test.gd"
func all(t) -> void:
	var m = await _boot(t)
	await _prep(t, m)
	DirAccess.make_dir_recursive_absolute("/tmp/mvbz/")
	var c = Vector2.ZERO; var n = 0
	for x in SO.camps(0): if int(x.ring) <= 1: c += x.pos; n += 1
	var cen = c / maxf(1.0, n)
	for z in [900.0, 700.0, 520.0, 420.0]:
		_cam(m, cen, m.village.size.x / z)
		await _w(t, 2.0); _clean(t)
		await RenderingServer.frame_post_draw
		var img: Image = t.get_viewport().get_texture().get_image()
		img.save_png("/tmp/mvbz/z%d.png" % int(z))
		_chk("鏡頭 %d：畫面冇實心黑塊" % int(z), _black_block(img) == 0, _black_block(img))
	print("[post] RESULT ok=%d bad=%d" % [ok, bad])
# 數「至少 16×16 全黑」嘅格（地圖區 y 190–760）
func _black_block(img: Image) -> int:
	var cnt = 0
	for gy in range(190, 760 - 16, 8):
		for gx in range(0, img.get_width() - 16, 8):
			var allb = true
			for dy in [0, 5, 10, 15]:
				for dx in [0, 5, 10, 15]:
					var px = img.get_pixel(gx + dx, gy + dy)
					if px.r > 0.004 or px.g > 0.004 or px.b > 0.004: allb = false; break
				if not allb: break
			if allb: cnt += 1
	return cnt
