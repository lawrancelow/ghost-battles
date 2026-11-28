#!/usr/bin/env python3
"""乾淨去底（v2）：python3 clean_matte.py
從 src/<key>_sheet.png（左廢墟、右修復中，淺灰底）與 furnace_3state_sheet.png（廢墟｜修復中｜完成）
重新去底，輸出 sprites/<key>_{ruin,repair}.webp 與 furnace_{ruin,repair,done}.webp。
做法：
- 以邊框中位數估底色；與外框連通、接近底色的像素才算背景（不誤挖畫內的灰色）。
- 被包住、接近底色、面積 >150px 的洞也挖走（棚架、藤蔓間的灰底）。
- 邊緣 2px 內按色差算軟 alpha，並做「去灰」：反推前景色 C=(I-(1-a)*bg)/a，消除灰邊。
- 刪掉與主體不連、面積 <600px 的碎點；最後 alpha 收 1px＋輕微平滑。
- 對齊同 bld_states.place（原 sprite 物件高度與底部中心）。
"""
import numpy as np
from PIL import Image
from scipy import ndimage
from bld_states import place

BG_T, CORE_T = 14, 48


def matte(a, keep_grey=False, soft_rule=False):
    rgb = a[..., :3].astype(float)
    bg = np.median(np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]]), axis=0)[:3].astype(float)
    diff = np.abs(rgb - bg).sum(-1)
    bglike = diff < BG_T * 2.2
    lab, n = ndimage.label(bglike)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    outside = np.isin(lab, list(border))
    # 被包住的灰底洞
    chroma = rgb.max(-1) - rgb.min(-1)
    # 被包住的灰底（含 AI 畫的灰底漸層、略亮／略暗）：低彩度、平滑（局部標準差小）、成片
    lum = rgb.mean(-1)
    lstd = np.sqrt(np.maximum(ndimage.uniform_filter(lum ** 2, 5) - ndimage.uniform_filter(lum, 5) ** 2, 0))
    if keep_grey or soft_rule:   # 糯米田：灰色水面是畫的一部分，只挖與底色幾乎相同者
        hole = (diff < BG_T * 2.6) & (chroma < 10) & (lstd < 3) & ~outside
    else:
        hole = (lum > 168) & (lum < 250) & (chroma < 11) & ~outside
    hl, hn = ndimage.label(hole)
    if hn:
        hs = ndimage.sum(hole, hl, range(1, hn + 1))
        outside |= np.isin(hl, [i + 1 for i, s in enumerate(hs) if s > 12])
    fg = ~outside
    fg = ndimage.binary_opening(fg, iterations=1)
    # 去碎點：只留大塊（主體或 >600px）
    fl, fn = ndimage.label(fg)
    if fn:
        fs = ndimage.sum(fg, fl, range(1, fn + 1))
        big = max(fs)
        fg = np.isin(fl, [i + 1 for i, s in enumerate(fs) if s > max(600, big * 0.004)])
    # 軟 alpha：只在邊緣帶
    core = ndimage.binary_erosion(fg, iterations=2)
    band = fg & ~core
    al = np.where(core, 1.0, 0.0)
    soft = np.clip((diff - BG_T) / (CORE_T - BG_T), 0, 1)
    al = np.where(band, soft, al)
    # 收 1px，避免最外圈灰
    al = np.where(fg & ~ndimage.binary_erosion(fg, iterations=1), al * 0.55, al)
    al = ndimage.gaussian_filter(al, 0.6) * fg
    al = np.clip(al, 0, 1)
    al[al < 0.08] = 0
    # 去灰（前景色反推）
    a3 = al[..., None]
    col = np.where(a3 > 0.02, (rgb - (1 - a3) * bg) / np.maximum(a3, 0.02), rgb)
    col = np.clip(col, 0, 255)
    out = np.dstack([col, al * 255]).astype("uint8")
    return out


def panels(a, k):
    """依主體之間的空白直線切成 k 塊"""
    bg = np.median(np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]]), axis=0)[:3]
    diff = np.abs(a[..., :3].astype(int) - bg).sum(-1)
    col = (diff > 40).sum(0)
    w = a.shape[1]
    cuts = []
    for i in range(1, k):
        c = w * i // k; lo, hi = c - w // (3 * k), c + w // (3 * k)
        cuts.append(lo + int(np.argmin(col[lo:hi])))
    xs = [0] + cuts + [w]
    return [a[:, xs[i]:xs[i + 1]] for i in range(k)]


def crop(im):
    return im.crop(im.getbbox())


if __name__ == "__main__":
    keys = ["house", "wood", "rice", "plank", "bun", "store", "home", "camp", "altar"]
    for k in keys:
        a = np.asarray(Image.open(f"src/{k}_sheet.png").convert("RGBA"))
        for part, name in zip(panels(a, 2), ["ruin", "repair"]):
            im = crop(Image.fromarray(matte(part, keep_grey=(k == "rice"))))
            _, cv = place(im, k)
            cv.save(f"sprites/{k}_{name}.webp", "WEBP", quality=94)
        print(k, "ok")
    a = np.asarray(Image.open("furnace_3state_sheet.png").convert("RGBA"))
    for part, name in zip(panels(a, 3), ["ruin", "repair", "done"]):
        im = crop(Image.fromarray(matte(part, soft_rule=True)))   # 爐灰、煙、帆布是灰白色，用保守規則
        _, cv = place(im, "furnace")
        cv.save(f"sprites/furnace_{name}.webp", "WEBP", quality=94)
    print("furnace ok")
