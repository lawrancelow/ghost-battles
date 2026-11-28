#!/usr/bin/env python3
"""普通鬼部件工具。
cut  <sheet.png> <outdir>         ：把淺灰底部件總表按連通區域切成透明 PNG（part_00.png…）
mix  <partsdir> <out.png> [seed]  ：讀 parts.json 錨點，隨機組合 12 隻拼裝測試圖
parts.json 格式：{"body":[{"f":"body_0.png","neck":[x,y]}],"face":[{"f":..,"anchor":[x,y]}],"hair":[...],"outfit":[...],"acc":[...]}
"""
import sys, json, random
from PIL import Image
import numpy as np
from scipy import ndimage


def cut(sheet, outdir, min_px=1500):
    import os
    os.makedirs(outdir, exist_ok=True)
    im = Image.open(sheet).convert("RGBA")
    a = np.asarray(im).astype(int)
    bg = np.median(np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]]), axis=0)[:3]
    diff = np.abs(a[..., :3] - bg).sum(-1)
    fg = diff > 40
    fg = ndimage.binary_closing(fg, iterations=3)
    fg = ndimage.binary_fill_holes(fg)
    lab, n = ndimage.label(fg)
    objs = ndimage.find_objects(lab)
    k = 0
    for i, sl in enumerate(objs):
        m = lab[sl] == i + 1
        if m.sum() < min_px:
            continue
        crop = a[sl].copy()
        # 填實區域全不透明（淺色皮膚不會被當底色挖空），只在外緣做 1px 柔邊
        soft = ndimage.gaussian_filter(m.astype(float), 0.8)
        crop[..., 3] = np.clip(soft * 255, 0, 255) * (soft > 0.35)
        Image.fromarray(crop.astype("uint8")).save(f"{outdir}/part_{k:02d}.png")
        k += 1
    print("parts:", k)


def mix(pdir, out, seed=1):
    rnd = random.Random(seed)
    P = json.load(open(f"{pdir}/parts.json"))
    W, H = 260, 320
    sheet = Image.new("RGBA", (W * 4, H * 3), (40, 34, 38, 255))
    for i in range(12):
        b = rnd.choice(P["body"])
        cv = Image.new("RGBA", (W, H))
        bi = Image.open(f"{pdir}/{b['f']}")
        bx, by = (W - bi.width) // 2, H - bi.height - 10
        cv.alpha_composite(bi, (bx, by))
        nx, ny = bx + b["neck"][0], by + b["neck"][1]
        for layer in ["outfit", "face", "hair", "acc"]:
            if not P.get(layer):
                continue
            p = rnd.choice(P[layer])
            pi = Image.open(f"{pdir}/{p['f']}")
            ax, ay = p["anchor"]
            cv.alpha_composite(pi, (max(0, nx - ax), max(0, ny - ay)))
        sheet.alpha_composite(cv, ((i % 4) * W, (i // 4) * H))
    sheet.save(out)


if __name__ == "__main__":
    c = sys.argv[1]
    if c == "cut":
        cut(sys.argv[2], sys.argv[3])
    else:
        mix(sys.argv[2], sys.argv[3], int(sys.argv[4]) if len(sys.argv) > 4 else 1)
