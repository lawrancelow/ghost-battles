#!/usr/bin/env python3
# 單張插圖 → 後備動態（未有分層素材）：慢推鏡＋深度漸變視差＋暖色光源位置微光＋鬼火
# 用法：python3 -I flat_import.py <插圖.jpg> <godot目錄> <插圖key> [y0]
import sys, os, json, cv2, numpy as np
from PIL import Image
src, gd, key = sys.argv[1:4]
y0 = float(sys.argv[4]) if len(sys.argv) > 4 else 0.42
od = os.path.join(gd, "assets", "cg_layers", key); os.makedirs(od, exist_ok=True)
im = Image.open(src).convert("RGB")
if max(im.size) > 1600: im.thumbnail((1600, 1600), Image.LANCZOS)
im.save(os.path.join(od, "still.webp"), quality=88, method=4)
W, H = im.size
hsv = cv2.cvtColor(np.array(im)[:, :, ::-1], cv2.COLOR_BGR2HSV)
m = ((hsv[:, :, 0] >= 4) & (hsv[:, :, 0] <= 19) & (hsv[:, :, 1] > 150) & (hsv[:, :, 2] > 238)).astype(np.uint8)   # 橙紅、夠飽和、夠光＝燈籠／火
m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((7, 7), np.uint8))
n, lab, st, cen = cv2.connectedComponentsWithStats(m)
gl = []
for i in range(1, n):
    a = st[i, cv2.CC_STAT_AREA] / float(W * H)
    if a < 0.0008 or a > 0.03: continue
    bw, bh = st[i, cv2.CC_STAT_WIDTH], st[i, cv2.CC_STAT_HEIGHT]
    if not (0.55 <= bw / float(bh) <= 1.8) or st[i, cv2.CC_STAT_AREA] / float(bw * bh) < 0.5: continue   # 燈籠／火口：近圓、實心
    gl.append((a, {"x": round(cen[i][0] / W, 4), "y": round(cen[i][1] / H, 4), "r": round(min(0.09, (a / 3.1416) ** 0.5 * (H / W) ** 0.5 * 2.4), 4), "c": "#ffb060", "a": 0.24}))
gl = [g for _, g in sorted(gl, key=lambda t: -t[0])[:6]]
out = {"flat": True, "bg": "still.webp", "still": "still.webp", "src_canvas": [W, H],
       "cam": {"zoom": [1.03, 1.08], "pan": [0.006, 0.004, -0.008, -0.004], "dur": 16},
       "depth": {"amt": 0.010, "y0": y0, "per": 9.0}, "glow": gl, "layers": [],
       "fx": [{"type": "wisp", "x": 0.5, "y": 0.6, "w": 0.85, "h": 0.5, "n": 8}] + ([{"type": "ember", "x": gl[0]["x"], "y": gl[0]["y"], "w": 0.03, "n": 5}] if gl else [])}
conf_p = os.path.join(gd, "assets", "cg_layers.json")
conf = json.load(open(conf_p, encoding="utf-8")) if os.path.exists(conf_p) else {}
conf[key] = out
json.dump(conf, open(conf_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("ok", key, (W, H), "微光", len(gl))
