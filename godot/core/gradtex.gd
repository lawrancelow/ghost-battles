# 漸變貼圖：即時用 CPU 砌 ImageTexture（唔用 GradientTexture1D/2D：佢哋延遲更新，Adreno 手機第一幀畫到會閃退）
class_name GradTex
extends RefCounted

static func linear(gr: Gradient, w := 128, h := 2, vertical := false) -> ImageTexture:
	var img = Image.create(w if not vertical else h, h if not vertical else w, false, Image.FORMAT_RGBA8)
	for i in w:
		var c = gr.sample(float(i) / max(1, w - 1))
		for j in h:
			if vertical: img.set_pixel(j, i, c)
			else: img.set_pixel(i, j, c)
	return ImageTexture.create_from_image(img)

# fill_from/fill_to 用 0..1 UV（同 GradientTexture2D 一樣）
static func radial(gr: Gradient, w := 64, h := 64, from := Vector2(0.5, 0.5), to := Vector2(1.0, 0.5)) -> ImageTexture:
	var img = Image.create(w, h, false, Image.FORMAT_RGBA8)
	var r = from.distance_to(to)
	for y in h:
		for x in w:
			var uv = Vector2((x + 0.5) / w, (y + 0.5) / h)
			img.set_pixel(x, y, gr.sample(clampf(uv.distance_to(from) / max(r, 0.0001), 0.0, 1.0)))
	return ImageTexture.create_from_image(img)

static func vertical(gr: Gradient, w := 4, h := 128) -> ImageTexture:
	var img = Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		var c = gr.sample(float(y) / max(1, h - 1))
		for x in w: img.set_pixel(x, y, c)
	return ImageTexture.create_from_image(img)
