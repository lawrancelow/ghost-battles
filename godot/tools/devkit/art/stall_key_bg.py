#!/usr/bin/env python3
# 攤位圖去殘底：整格圖切出嚟之後，攤架入面圍住嘅位仲留住整格圖嘅淺灰底（約 229,229,229）。
# 將中性淺灰、連通面積 ≥ MIN 像素嘅區域變透明。用法：stall_key_bg.py <webp…>
import sys
import numpy as np
from PIL import Image
from scipy import ndimage as ndi
MIN = 14
for path in sys.argv[1:]:
    a = np.asarray(Image.open(path).convert("RGBA")).astype(int).copy()
    r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    br = (r + g + b) / 3
    m = (al > 200) & (abs(r - g) < 6) & (abs(g - b) < 7) & (br > 214) & (br < 246)
    lab, n = ndi.label(m)
    keep = np.zeros_like(m)
    if n:
        sizes = ndi.sum(m, lab, range(1, n + 1))
        for i, s in enumerate(sizes):
            if s >= MIN: keep |= (lab == i + 1)
        keep = ndi.binary_dilation(keep, iterations=1) & (al > 0) & (br > 200) & (abs(r - g) < 12) & (abs(g - b) < 14)
    a[keep, 3] = 0
    Image.fromarray(a.astype("uint8"), "RGBA").save(path, "WEBP", quality=92, method=6)
    print(path.split("/")[-1], int(keep.sum()))
