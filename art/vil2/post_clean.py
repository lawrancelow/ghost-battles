#!/usr/bin/env python3
"""縮放後收尾：清除 alpha<14 的殘影與與主體不連的碎點（<300px），輸出覆蓋。"""
import sys, glob
import numpy as np
from PIL import Image
from scipy import ndimage
for f in sys.argv[1:]:
    keep_grey = "rice_" in f
    a = np.asarray(Image.open(f).convert("RGBA")).copy()
    al = a[..., 3].astype(int); al[al < 14] = 0
    rgb = a[..., :3].astype(int)
    # 殘留灰底（原圖底色約 #D2D2D2）：成片（>=6px）、低彩度、接近底色 → 挖走
    bgc = np.array([210, 209, 209])
    cand = (not keep_grey) & (np.abs(rgb - bgc).sum(-1) < 26) & ((rgb.max(-1) - rgb.min(-1)) < 10) & (al > 0)
    cl, cn = ndimage.label(cand)
    if cn:
        cs = ndimage.sum(cand, cl, range(1, cn + 1))
        kill = np.isin(cl, [i + 1 for i, v in enumerate(cs) if v >= 6])
        kill = ndimage.binary_dilation(kill, iterations=1) & (al > 0) & (np.abs(rgb - bgc).sum(-1) < 60)
        al[kill] = 0
    m = al > 0
    lab, n = ndimage.label(m, structure=np.ones((3, 3)))
    if n:
        s = ndimage.sum(m, lab, range(1, n + 1))
        keep = np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= max(300, s.max() * 0.003)])
        al[~keep] = 0
    a[..., 3] = al.astype("uint8"); a[al == 0, :3] = 0
    Image.fromarray(a).save(f, "WEBP", quality=94)
    lab2, n2 = ndimage.label(al > 0, structure=np.ones((3, 3)))
    print(f, "islands", n2)
