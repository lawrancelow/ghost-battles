# 用法：python3 grab.py <tool-result 檔> <sheet 名> [名稱1 名稱2 名稱3 名稱4]
import json, re, base64, sys
from PIL import Image
import numpy as np
from scipy import ndimage
p, sheet = sys.argv[1], sys.argv[2]; names = sys.argv[3:]
d = json.load(open(p)); t = ''.join(x.get('text', '') for x in d)
b = re.search(r'B64START([A-Za-z0-9+/=]+)B64END', t).group(1)
raw = f'/home/claude/gb/art/raw/{sheet}.webp'; open(raw, 'wb').write(base64.b64decode(b))
im = Image.open(raw).convert('RGBA'); W, H = im.size; a = np.array(im)[:, :, 3]
print(sheet, im.size, 'transparent', round((a < 10).mean(), 3))
if names:
    # 依透明區塊找出每個物件，再按格子位置歸類
    mask = a > 24
    lab, n = ndimage.label(mask)
    sizes = ndimage.sum(mask, lab, range(1, n + 1))
    quad = {0: [], 1: [], 2: [], 3: []}
    for i, s in enumerate(sizes, 1):
        if s < 60: continue
        ys, xs = np.where(lab == i); cy, cx = ys.mean(), xs.mean()
        q = (1 if cx > W / 2 else 0) + (2 if cy > H / 2 else 0)
        quad[q].append((ys.min(), ys.max(), xs.min(), xs.max(), s))
    for q, nm in enumerate(names):
        if nm == '-' or not quad[q]: continue
        only = nm.endswith('!'); nm = nm.rstrip('!')
        big = max(r[4] for r in quad[q])
        rs = [r for r in quad[q] if r[4] > (big * 0.999 if only else big * 0.002)]
        y0 = min(r[0] for r in rs); y1 = max(r[1] for r in rs); x0 = min(r[2] for r in rs); x1 = max(r[3] for r in rs)
        crop = im.crop((max(0, x0 - 4), max(0, y0 - 4), min(W, x1 + 5), min(H, y1 + 5)))
        if only:  # 只留最大的那一塊，清掉其餘筆觸
            keep = (lab == [i for i in range(1, n + 1) if sizes[i - 1] == big][0])
            arr = np.array(crop); km = keep[max(0, y0 - 4):min(H, y1 + 5), max(0, x0 - 4):min(W, x1 + 5)]
            km = ndimage.binary_dilation(km, iterations=3); arr[:, :, 3] = np.where(km, arr[:, :, 3], 0); crop = Image.fromarray(arr)
        # 不屬於這一格的雜點清掉
        crop.save(f'/home/claude/gb/art/cut/{nm}.png'); print(' ', nm, crop.size)
    prev = Image.new('RGBA', im.size, (70, 64, 60, 255)); prev.alpha_composite(im); prev.convert('RGB').resize((W // 2, H // 2)).save(f'/home/claude/gb/art/raw/{sheet}_prev.png')
