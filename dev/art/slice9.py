# 用法：python3 slice9.py <raw webp> <名稱1..9>  —— 3x3 分件圖，依透明區塊歸到格子，裁出每一件（'-' 跳過）
import sys
from PIL import Image
import numpy as np
from scipy import ndimage
src, names = sys.argv[1], sys.argv[2:]
im = Image.open(src).convert('RGBA'); W, H = im.size; arr = np.array(im); a = arr[:, :, 3]
mask = a > 24
lab, n = ndimage.label(mask)
sizes = ndimage.sum(mask, lab, range(1, n + 1))
cells = {i: [] for i in range(9)}
for i, s in enumerate(sizes, 1):
    if s < 80: continue
    ys, xs = np.where(lab == i)
    c = min(2, int(xs.mean() / (W / 3))) + 3 * min(2, int(ys.mean() / (H / 3)))
    cells[c].append(i)
for c, nm in enumerate(names):
    if nm == '-' or not cells[c]: continue
    big = max(sizes[i - 1] for i in cells[c])
    keep = [i for i in cells[c] if sizes[i - 1] > big * 0.01]
    km = np.isin(lab, keep); km = ndimage.binary_dilation(km, iterations=2)
    ys, xs = np.where(km); y0, y1, x0, x1 = ys.min(), ys.max(), xs.min(), xs.max()
    out = arr[y0:y1 + 1, x0:x1 + 1].copy(); out[:, :, 3] = np.where(km[y0:y1 + 1, x0:x1 + 1], out[:, :, 3], 0)
    Image.fromarray(out).save(f'/home/claude/gb/art/cut/{nm}.png'); print(nm, out.shape[1], out.shape[0])
