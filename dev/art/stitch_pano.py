# 把辦公室各房間的正面橫向背景拼成一張全景：python3 stitch_pano.py boss main pantry meeting
# 1) 每段縮到同一高度；2) 天花／牆／地毯三個帶，按主辦公室的顏色做均值方差匹配；
# 3) 接縫處交叉淡化，再畫一條牆柱蓋住接縫（蠟筆質感）；輸出 raw/office_pano.webp + /tmp/claude-0/office_pano_layout.json
import sys, json
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
R = '/home/claude/gb/art/raw/'
H = 1024
names = sys.argv[1:] or ['boss', 'main', 'pantry', 'meeting']
segs = []
for n in names:
    im = Image.open(R + f'pano_{n}.webp').convert('RGB')
    im = im.resize((round(im.width * H / im.height), H), Image.LANCZOS)
    segs.append(np.asarray(im).astype(np.float32))
BANDS = [(0, 0.14), (0.14, 0.50), (0.50, 1.0)]
ref = segs[names.index('main')] if 'main' in names else segs[0]
def match(a, b, y0, y1):  # 把 a 的這一帶顏色統計拉向 b
    r0, r1 = int(y0 * H), int(y1 * H)
    A = a[r0:r1]; B = b[r0:r1]
    for c in range(3):
        ma, sa = A[..., c].mean(), A[..., c].std() + 1e-3
        mb, sb = B[..., c].mean(), B[..., c].std() + 1e-3
        A[..., c] = (A[..., c] - ma) * (0.5 + 0.5 * sb / sa) + (0.35 * ma + 0.65 * mb)
for s in segs:
    if s is ref: continue
    for y0, y1 in BANDS[::2]: match(s, ref, y0, y1)  # 只對天花和地毯匹配，牆身保留各房間特色
OV = 60  # 交叉淡化寬度
W = sum(s.shape[1] for s in segs) - OV * (len(segs) - 1)
out = np.zeros((H, W, 3), np.float32); x = 0; layout = []; seams = []
for i, s in enumerate(segs):
    w = s.shape[1]
    if i == 0: out[:, :w] = s
    else:
        ramp = np.linspace(0, 1, OV)[None, :, None]
        out[:, x:x + OV] = out[:, x:x + OV] * (1 - ramp) + s[:, :OV] * ramp
        out[:, x + OV:x + w] = s[:, OV:]
        seams.append(x + OV // 2)
    layout.append({'room': names[i], 'x0': x, 'x1': x + w})
    x += w - OV
# 地毯統一：用主辦公室的地毯（左右鏡像平鋪）取代各段的地板，接縫完全消失
FY = 636; fl = ref[FY:].copy(); tile = np.concatenate([fl, fl[:, ::-1]], axis=1)
reps = W // tile.shape[1] + 1; big = np.tile(tile, (1, reps, 1))[:, :W]
blend = 26
for k in range(blend):
    t = k / blend; out[FY - blend + k] = out[FY - blend + k] * (1 - t) + big[0] * t
out[FY:] = big
img = Image.fromarray(np.clip(out, 0, 255).astype(np.uint8))
# 牆柱：蓋住接縫，從天花到地毯線；地上一條門檻
d = ImageDraw.Draw(img, 'RGBA'); rng = np.random.default_rng(3)
for sx in seams:
    pw = 70; x0, x1 = sx - pw // 2, sx + pw // 2; y1 = FY
    d.rectangle([x0, 0, x1, y1], fill=(232, 222, 206, 255))
    d.rectangle([x0 - 6, y1 - 10, x1 + 6, y1 + 4], fill=(150, 120, 100, 255))  # 踢腳
    for k in range(260):  # 蠟筆紋
        yy = rng.integers(0, y1); xx = rng.integers(x0, x1); l = rng.integers(6, 18)
        c = (205, 192, 175, 120) if rng.random() < .6 else (250, 244, 232, 110)
        d.line([xx, yy, xx + rng.integers(-3, 4), yy + l], fill=c, width=2)
    d.line([x0, 0, x0, y1], fill=(110, 90, 80, 255), width=3); d.line([x1, 0, x1, y1], fill=(110, 90, 80, 255), width=3)
    # 地上門檻（透視：越下越闊）
    d.polygon([(sx - 14, y1 + 4), (sx + 14, y1 + 4), (sx + 46, H), (sx - 46, H)], fill=(90, 70, 110, 55))
    d.rectangle([x0 + 8, 0, x0 + 18, y1], fill=(255, 250, 240, 90)); d.rectangle([x1 - 16, 0, x1 - 6, y1], fill=(140, 120, 110, 70))
img.save(R + 'office_pano.webp', quality=86)
json.dump({'H': H, 'W': W, 'rooms': layout, 'seams': seams, 'floorY': FY / H}, open('/tmp/claude-0/office_pano_layout.json', 'w'), indent=1)
small = img.copy(); small.thumbnail((2400, 400)); small.save('/tmp/claude-0/office_pano_prev.png')
print(W, H, layout, seams)
