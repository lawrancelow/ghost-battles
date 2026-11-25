# 黑底／白底兩張截圖 → 精確透明度（difference matting），裁走空白，存 webp
# python3 matte_bw.py black.png white.png out.webp [maxside]
import sys
import numpy as np
from PIL import Image
b = np.asarray(Image.open(sys.argv[1]).convert("RGB")).astype(np.float32)
w = np.asarray(Image.open(sys.argv[2]).convert("RGB")).astype(np.float32)
a = 1.0 - (w - b).mean(axis=2) / 255.0
a = np.clip(a, 0, 1)
a[a < 0.04] = 0
c = np.where(a[..., None] > 0.004, b / np.maximum(a[..., None], 0.004), 0)
c = np.clip(c, 0, 255)
rgba = np.dstack([c, a * 255]).astype(np.uint8)
im = Image.fromarray(rgba, "RGBA")
bb = im.getchannel("A").point(lambda v: 255 if v > 10 else 0).getbbox()
im = im.crop((max(0, bb[0]-6), max(0, bb[1]-6), min(im.width, bb[2]+6), min(im.height, bb[3]+6)))
ms = int(sys.argv[4]) if len(sys.argv) > 4 else 768
if max(im.size) > ms:
    s = ms / max(im.size); im = im.resize((round(im.width*s), round(im.height*s)), Image.LANCZOS)
im.save(sys.argv[3], "WEBP", quality=90, method=6)
print(im.size)
