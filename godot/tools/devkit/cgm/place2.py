#!/usr/bin/env python3
# 已切好嘅角色透明 PNG → 喺完整圖度做模板匹配定位 → layout.json（art_import.py 用）
# 用法：python3 -I place2.py <完整圖> <純背景圖> <圖層資料夾> name1.png name2.png …
import sys, os, json, cv2, numpy as np
full, bgp, d = sys.argv[1:4]; names = sys.argv[4:]
A = cv2.imread(full); H, W = A.shape[:2]
B = cv2.imread(bgp)
if B.shape != A.shape: B = cv2.resize(B, (W, H), interpolation=cv2.INTER_AREA)
gA = cv2.cvtColor(A, cv2.COLOR_BGR2GRAY).astype(np.float32)
layers = []
for fn in names:
    T = cv2.imread(os.path.join(d, fn), cv2.IMREAD_UNCHANGED)
    g0 = cv2.cvtColor(T[:, :, :3], cv2.COLOR_BGR2GRAY).astype(np.float32); m0 = (T[:, :, 3] > 128).astype(np.float32)
    best = None
    for rng, n in [((0.3, 1.4), 45), (None, 25)]:   # 先粗後細
        lo, hi = rng if rng else (best[1] * 0.95, best[1] * 1.05)
        for sc in np.linspace(lo, hi, n):
            tw, th = int(T.shape[1] * sc), int(T.shape[0] * sc)
            if tw < 16 or th < 16 or tw > W or th > H: continue
            gT = cv2.resize(g0, (tw, th), interpolation=cv2.INTER_AREA); mk = cv2.resize(m0, (tw, th), interpolation=cv2.INTER_NEAREST)
            r = np.nan_to_num(cv2.matchTemplate(gA, gT, cv2.TM_CCOEFF_NORMED, mask=mk), nan=-1, posinf=-1, neginf=-1)
            _, v, _, loc = cv2.minMaxLoc(r)
            if best is None or v > best[0]: best = (v, sc, loc[0], loc[1], tw, th)
    v, sc, x, y, tw, th = best
    layers.append(dict(name=fn[:-4], file=fn, x=int(x), y=int(y), w=tw, h=th, scale=round(float(sc), 4), src_size=[int(T.shape[1]), int(T.shape[0])], match=round(float(v), 3)))
    print(fn, "match", round(v, 3), "scale", round(sc, 3), "at", x, y, tw, th)
layers.sort(key=lambda L: L["y"] + L["h"])
for z, L in enumerate(layers): L["z"] = 10 + z
cv2.imwrite(os.path.join(d, "bg.png"), B)
json.dump(dict(canvas=[W, H], full=os.path.basename(full), layers=[dict(name="bg", file="bg.png", x=0, y=0, w=W, h=H, scale=1.0, z=0)] + layers), open(os.path.join(d, "layout.json"), "w"), ensure_ascii=False, indent=1)
comp = B.copy()
for L in layers:
    im = cv2.resize(cv2.imread(os.path.join(d, L["file"]), cv2.IMREAD_UNCHANGED), (L["w"], L["h"]), interpolation=cv2.INTER_AREA)
    x, y = L["x"], L["y"]; x1, y1 = min(W, x + L["w"]), min(H, y + L["h"]); im = im[:y1 - y, :x1 - x]; a = im[:, :, 3:4] / 255.
    r = comp[y:y1, x:x1]; r[:] = (im[:, :, :3] * a + r * (1 - a)).astype(np.uint8)
side = np.hstack([A, comp]); cv2.imwrite(os.path.join(d, "_compare.jpg"), cv2.resize(side, (side.shape[1] // 2, side.shape[0] // 2)))
