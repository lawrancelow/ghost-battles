# 劇情舞台（移植 Story.drawStage ＋ paintBg / SCENE.drawBg）
extends Control

var player

func _draw() -> void:
	if player == null or player.cur == null: return
	var ctx = Ctx.new(self)
	var w = size.x; var h = size.y; var sc: Dictionary = player.cur.sc
	paint_bg(ctx, w, h, sc.get("bg", "village"))
	if sc.get("mic", false):
		var g = ctx.createRadialGradient(w * 0.5, h * 0.62, 10, w * 0.5, h * 0.62, w * 0.55); g.addColorStop(0, "rgba(255,236,190,.28)"); g.addColorStop(1, "rgba(0,0,0,.55)"); ctx.fillStyle = g; ctx.fillRect(0, 0, w, h)
	var acts: Array = player.actors; var n = acts.size(); var spk: String = player.speaker()
	for i in n:
		var a: String = acts[i]
		var x = w * (0.5 if n == 1 else 0.16 + 0.68 * i / maxf(1, n - 1)); var y = h * 0.66 + ((i % 2) * 18.0 if n > 3 else 0.0)
		var base = 3.1 if n <= 2 else (2.7 if n == 3 else (2.3 if n == 4 else 1.9))
		var on = a == spk or (spk == "黑白無常" and (a == "白無常" or a == "黑無常"))
		Art.draw_char(ctx, DB.D.SPEAKER_ART[a], x, y + (0.0 if on else 6.0), base if on else base * 0.9, {"t": 0.3, "flip": x > w / 2, "alpha": 1.0 if on else 0.45})

static func paint_bg(ctx: Ctx, w: float, h: float, bg: String) -> void:
	var im = Spr.get_tex("bg_" + bg)
	if im:
		var s = maxf(w / im.get_width(), h / im.get_height()); var iw = im.get_width() * s; var ih = im.get_height() * s
		ctx.drawImage(im, (w - iw) / 2, (h - ih) / 2, iw, ih)
		var v = ctx.createLinearGradient(0, 0, 0, h); v.addColorStop(0, "rgba(10,8,14,.18)"); v.addColorStop(0.5, "rgba(10,8,14,0)"); v.addColorStop(1, "rgba(10,8,14,.32)")
		ctx.fillStyle = v; ctx.fillRect(0, 0, w, h); return
	var g = ctx.createLinearGradient(0, 0, 0, h); g.addColorStop(0, "#120f22"); g.addColorStop(1, "#2a2440"); ctx.fillStyle = g; ctx.fillRect(0, 0, w, h)
