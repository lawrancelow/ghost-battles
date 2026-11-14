# 測試：專屬招式 原生 vs JS 對照（每行一隻角色，上原生下 JS；每格一個時間點）
extends RefCounted
static var KS := ["egui", "eguiking", "xiaogui", "laojiang", "zombie"]
const PTS := [["windup", 0.5], ["windup", 1.0], ["strike", 0.42], ["strike", 1.0], ["recover", 0.3], ["recover", 0.7]]
func grid(t) -> void:
	var ks = KS
	if OS.has_environment("GB_MVKS"): ks = OS.get_environment("GB_MVKS").split(",")
	var main = t.get_tree().root.get_node("Main")
	var c = Control.new(); c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); c.z_index = 100
	var bg = ColorRect.new(); bg.color = Color("#3a3440"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); c.add_child(bg)
	var d = Control.new(); d.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); c.add_child(d)
	d.draw.connect(func():
		var ctx = BtCtx.new(d)
		var cw = 75.0; var rh = 950.0 / (ks.size() * 2)
		for r in ks.size():
			for j in PTS.size():
				for v in 2:
					var x = 14 + j * cw; var y = (r * 2 + v + 0.8) * rh
					var o = {"pose": PTS[j][0], "pt": PTS[j][1], "t": 1.0, "tdx": 50.0, "tdy": 0.0, "flip": false, "enemy": false, "alpha": 1.0, "rot": 0.0}
					ctx.save(); ctx.setTransform(0.6, 0, 0, 0.6, x, y)
					if v == 0: BtMoves.draw(ctx, ks[r], 0, 0, 1.32, o)
					else: J.mc(J.G.get("ART"), "drawChar", [ctx, ks[r], 0.0, 0.0, 1.32, o])
					ctx.restore())
	main.add_child(c)
