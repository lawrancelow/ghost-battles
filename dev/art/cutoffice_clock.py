# 從原圖 op_clock 擦掉畫死的指針（用同半徑、轉 45° 的鐘面原圖像素補），之後指針用程式畫，才能轉
import numpy as np, math
from PIL import Image
a = np.array(Image.open('/home/claude/gb/art/cut/op_clock.png').convert('RGBA'))
A = a.astype(int); o = a.copy(); cx, cy = 126, 128
dark = lambda y, x: A[y, x, :3].sum() < 640 or A[y, x, 0] - A[y, x, 2] > 70
for y in range(cy - 66, cy + 67):
    for x in range(cx - 66, cx + 67):
        r = math.hypot(x - cx, y - cy)
        if r > 64 or not any(dark(y + j, x + i) for j in (-1, 0, 1) for i in (-1, 0, 1)): continue
        th = math.atan2(y - cy, x - cx)
        for d in (math.pi / 4, -math.pi / 4, math.pi * 0.75, -math.pi * 0.75):
            sx, sy = round(cx + r * math.cos(th + d)), round(cy + r * math.sin(th + d))
            if not dark(sy, sx) or r < 3: o[y, x] = a[sy, sx] if not dark(sy, sx) else a[cy - 40, cx - 40]; break
Image.fromarray(o).save('/home/claude/gb/art/cut/op_clockface.png')
