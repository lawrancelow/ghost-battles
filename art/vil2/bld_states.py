#!/usr/bin/env python3
"""建築三態處理：python3 bld_states.py <sheet.png> <key> <outdir>
sheet 為左（廢墟）右（修復中）兩張並排、淺灰底。按中間最空的一條直線切開，
每半邊去底做透明，再按原 sprite（godot/assets/spr/<key>.webp）的物件高度與底部中心對齊，
輸出 <key>_ruin.webp、<key>_repair.webp（同原圖畫布尺寸）。"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

SPR = "/home/claude/wt/artb/godot/assets/spr"


def fgmask(a):
    bg = np.median(np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]]), axis=0)[:3]
    diff = np.abs(a[..., :3].astype(int) - bg).sum(-1)
    m = ndimage.binary_closing(diff > 40, iterations=3)
    m = ndimage.binary_fill_holes(m)
    lab, n = ndimage.label(m)
    sizes = ndimage.sum(m, lab, range(1, n + 1))
    keep = np.isin(lab, [i + 1 for i, s in enumerate(sizes) if s > 400])
    # 藤蔓／棚架之間被包住的灰底洞：顏色接近底色且成片（>120px）就挖走
    hole = diff < 28
    hl, hn = ndimage.label(hole)
    hs = ndimage.sum(hole, hl, range(1, hn + 1))
    keep &= ~np.isin(hl, [i + 1 for i, s in enumerate(hs) if s > 120])
    return keep


def split(sheet):
    a = np.asarray(Image.open(sheet).convert("RGBA"))
    m = fgmask(a)
    col = m.sum(0); w = a.shape[1]
    lo, hi = int(w * 0.3), int(w * 0.7)
    cut = lo + int(np.argmin(col[lo:hi]))
    outs = []
    for x0, x1 in [(0, cut), (cut, w)]:
        sub = a[:, x0:x1].copy(); mm = m[:, x0:x1]
        soft = ndimage.gaussian_filter(mm.astype(float), 0.8)
        sub[..., 3] = (np.clip(soft * 255, 0, 255) * (soft > 0.35)).astype("uint8")
        im = Image.fromarray(sub); outs.append(im.crop(im.getbbox()))
    return outs


def place(im, key):
    ref = Image.open(f"{SPR}/{key}.webp").convert("RGBA"); rb = ref.getbbox()
    s = (rb[3] - rb[1]) / im.height
    s = min(s, (rb[2] - rb[0]) * 1.08 / im.width)
    im = im.resize((max(1, int(im.width * s)), max(1, int(im.height * s))), Image.LANCZOS)
    cv = Image.new("RGBA", ref.size); cx = (rb[0] + rb[2]) // 2
    cv.alpha_composite(im, (cx - im.width // 2, rb[3] - im.height))
    return ref, cv


if __name__ == "__main__":
    sheet, key, out = sys.argv[1:4]
    ruin, rep = split(sheet)
    ref, r1 = place(ruin, key); _, r2 = place(rep, key)
    r1.save(f"{out}/{key}_ruin.webp", "WEBP", quality=92)
    r2.save(f"{out}/{key}_repair.webp", "WEBP", quality=92)
    pv = Image.new("RGBA", (3 * 520, 480), (60, 55, 60, 255))
    for i, im in enumerate([r1, r2, ref]):
        pv.alpha_composite(im.resize((520, 480)), (i * 520, 0))
    pv.convert("RGB").save(f"/home/claude/meeting/vil2/art_b/{key}_3state_preview.jpg", quality=86)
    print(key, "ok")
