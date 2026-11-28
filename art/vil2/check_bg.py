#!/usr/bin/env python3
"""檢查圖：每張 sprite 放在亮底（米白）、洋紅、暗底（深紫黑）上並排，另出局部放大。"""
import sys, glob
from PIL import Image
fs = sorted(glob.glob("sprites/*.webp")); out = sys.argv[1]
W, H = 260, 240; BGS = [(245, 240, 232), (255, 0, 255), (22, 18, 28)]
sh = Image.new("RGB", (W * 3 * 3, H * ((len(fs) + 2) // 3)), (0, 0, 0))
for i, f in enumerate(fs):
    im = Image.open(f).convert("RGBA"); im = im.crop(im.getbbox()); im.thumbnail((W - 10, H - 10))
    for j, c in enumerate(BGS):
        t = Image.new("RGBA", (W, H), c + (255,)); t.alpha_composite(im, ((W - im.width) // 2, (H - im.height) // 2))
        sh.paste(t.convert("RGB"), (((i % 3) * 3 + j) * W, (i // 3) * H))
sh.save(out, quality=86)
# 放大：每張取邊緣一塊 2x
zs = []
for f in fs:
    im = Image.open(f).convert("RGBA"); b = im.getbbox()
    box = (b[0], b[1] + (b[3] - b[1]) // 3, b[0] + 200, b[1] + (b[3] - b[1]) // 3 + 200)
    c = im.crop(box).resize((400, 400), Image.NEAREST)
    for col in [(255, 0, 255), (22, 18, 28)]:
        t = Image.new("RGBA", c.size, col + (255,)); t.alpha_composite(c); zs.append(t.convert("RGB"))
Z = Image.new("RGB", (400 * 6, 400 * ((len(zs) + 5) // 6)))
for i, z in enumerate(zs): Z.paste(z, ((i % 6) * 400, (i // 6) * 400))
Z.save(out.replace(".jpg", "_zoom.jpg"), quality=86)
