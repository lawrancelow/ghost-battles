# 考核官頭像「探出圈」合成 v3（頸線法）：深紫圓底＋金邊圈。
# 做法：自動搵「頸線」（臉以下輪廓最窄嗰行），縮放＋擺位令頸線兩端都喺圈內；
#   頸線以上（成個頭、官帽連展腳全長、頭巾、頭髮、面珠）完整保留、可以出圈；
#   頸線以下只留圈內，由金圈前緣蓋住。咁樣圈外冇任何切口、冇淡出，頭部一定完整。
# 用法：python3 popout.py <spr 目錄> <輸出目錄> <預覽 jpg> <meta json>；之後跑 godot/tools/devkit/art/kpi_avatar_check.py
import sys, json, numpy as np
from PIL import Image, ImageDraw, ImageFilter
from scipy import ndimage
SPR = sys.argv[1]; OUT = sys.argv[2]
# key: (src, 臉中心 x 比例, 臉中心 y 比例, 要刪嘅漂浮道具框 (x0,y0,x1,y1) 比例或 None)
CH = {"chen": ("kpi_boss_chen_full.webp", 0.435, 0.285, (0.70, 0.185, 1.0, 0.56)),
      "he": ("kpi_boss_he_full.webp", 0.40, 0.27, (0.675, 0.13, 1.0, 0.42)),
      "qian": ("kpi_boss_qian_full.webp", 0.32, 0.31, None), "dato": ("kpi_boss_dato_full.webp", 0.41, 0.265, None),
      "nuo": ("kpi_boss_nuo_full.webp", 0.44, 0.25, None), "pang": ("bm_pang.webp", 0.45, 0.255, None)}
R = 128; CAN = 768; C = CAN // 2   # 畫布＝圓直徑 3 倍（帽展腳全長都裝得落）
NECK_W = 1.78    # 頸線闊度上限（以 R 計；圈弦長喺頸線高度一定大過佢）
HEAD_H = 1.95    # 頭頂到頸線高度上限（以 R 計）
TOP = 1.62       # 頭頂喺圓心上面幾多 R（即出圈約 0.6R）
MARGIN = 5       # 頸線兩端離圈邊最少幾多 px
def main_body(im):
    a = np.array(im)[:, :, 3] > 24
    lab, n = ndimage.label(a)
    if n <= 1: return im
    sizes = ndimage.sum(np.ones_like(lab), lab, range(1, n + 1))
    keep = lab == (int(np.argmax(sizes)) + 1)
    arr = np.array(im); arr[:, :, 3] = np.where(keep, arr[:, :, 3], 0)
    return Image.fromarray(arr)
def find_neck(im, fy):
    a = np.array(im)[:, :, 3] > 60; H = a.shape[0]; best = None
    for y in range(int(fy * H), int((fy + 0.22) * H)):
        xs = np.nonzero(a[y])[0]; w = int(xs.max() - xs.min())
        if best is None or w < best[0]: best = (w, y, int(xs.min()), int(xs.max()))
    return best
def make(key):
    src, fx, fy, prop = CH[key]
    im = Image.open(f"{SPR}/{src}").convert("RGBA")
    if prop:   # 漂浮道具（印章、竹簡）同底下嗰縷煙：刪走
        a = np.array(im); W0, H0 = im.size
        a[int(prop[1] * H0):int(prop[3] * H0), int(prop[0] * W0):int(prop[2] * W0), 3] = 0
        im = Image.fromarray(a)
    im = main_body(im)
    top = im.getbbox()[1]
    nw, ny, nl, nr = find_neck(im, fy)
    s = min(NECK_W * R / nw, HEAD_H * R / (ny - top))
    hh = (ny - top) * s / R                       # 頭高（R）
    dy = float(np.clip(hh - TOP, -0.30, 0.35))    # 頸線喺圓心下面幾多 R
    Yn = int(round(C + dy * R))
    half = (R * R - (Yn - C) ** 2) ** 0.5 - MARGIN - 3
    fig = im.resize((int(round(im.width * s)), int(round(im.height * s))), Image.LANCZOS)
    ox = C - fx * im.width * s                    # 先以臉中心對圓心，再最少量平移令頸線兩端入圈
    l = ox + nl * s; r = ox + nr * s
    if r - l > 2 * half: ox += C - (l + r) / 2
    elif l < C - half: ox += (C - half) - l
    elif r > C + half: ox -= r - (C + half)
    ox = int(round(ox)); oy = int(round(Yn - ny * s))
    layer = Image.new("RGBA", (CAN, CAN)); layer.paste(fig, (ox, oy), fig)
    # 遮罩：圈內全顯；頸線以上全部保留
    m = Image.new("L", (CAN, CAN), 0); d = ImageDraw.Draw(m)
    d.rectangle((0, 0, CAN, Yn), fill=255)
    d.ellipse((C - R + 3, C - R + 3, C + R - 3, C + R - 3), fill=255)
    la = np.array(layer); ma = np.array(m)
    la[:, :, 3] = np.where(ma > 0, la[:, :, 3], 0)
    fig_m = Image.fromarray(la)
    out = Image.new("RGBA", (CAN, CAN))
    ImageDraw.Draw(out).ellipse((C - R, C - R, C + R, C + R), fill=(58, 36, 64, 245))
    vg = Image.new("L", (CAN, CAN), 0); ImageDraw.Draw(vg).ellipse((C - R + 14, C - R + 14, C + R - 14, C + R - 14), fill=255)
    vg = vg.filter(ImageFilter.GaussianBlur(14)); dark = Image.new("RGBA", (CAN, CAN), (20, 10, 24, 0))
    circ = Image.new("L", (CAN, CAN), 0); ImageDraw.Draw(circ).ellipse((C - R, C - R, C + R, C + R), fill=255)
    dark.putalpha(Image.fromarray((np.array(circ) * (1 - np.array(vg) / 255.0) * 0.55).astype(np.uint8)))
    out.alpha_composite(dark)
    ring = lambda dr, w, col: dr.ellipse((C - R, C - R, C + R, C + R), outline=col, width=w)
    ring(ImageDraw.Draw(out), 9, (122, 78, 26, 255)); ring(ImageDraw.Draw(out), 5, (232, 176, 74, 255))
    # 投影（只做出圈部分）
    sh = Image.new("RGBA", (CAN, CAN), (10, 4, 12, 0)); sa = np.array(fig_m)[:, :, 3]
    sh.putalpha(Image.fromarray((sa * 0.5).astype(np.uint8)))
    sh = sh.filter(ImageFilter.GaussianBlur(4)); sh2 = Image.new("RGBA", (CAN, CAN)); sh2.alpha_composite(sh, (4, 6))
    out.alpha_composite(sh2)
    out.alpha_composite(fig_m)
    # 金圈前緣：頸線以下成段弧蓋住身體
    front = Image.new("RGBA", (CAN, CAN)); fd = ImageDraw.Draw(front)
    ring(fd, 9, (122, 78, 26, 255)); ring(fd, 5, (232, 176, 74, 255))
    fa = np.array(front); fa[:Yn + 1, :, 3] = 0
    out.alpha_composite(Image.fromarray(fa))
    nm = "kpi_boss_" + key
    out.save(f"{OUT}/{nm}.webp", lossless=False, quality=92)
    out.resize((CAN // 2, CAN // 2), Image.LANCZOS).save(f"{OUT}/{nm}_s.webp", quality=92)
    # 檢查用資料：頸線位置、角色層（未加圈／投影）bbox、原圖頭部 bbox 換算到畫布
    hb = Image.fromarray((np.array(im)[:ny, :, 3] > 60).astype(np.uint8) * 255).getbbox()
    META[key] = {"src": src, "prop": prop, "neck_y": Yn, "scale": round(s, 4), "ox": ox, "oy": oy,
                 "head_src_canvas": [int(ox + hb[0] * s), int(oy + hb[1] * s), int(ox + hb[2] * s), int(oy + hb[3] * s)],
                 "neck_x": [int(round(ox + nl * s)), int(round(ox + nr * s))]}
    return out
META = {}
outs = [make(k) for k in CH]
json.dump({"R": R, "CAN": CAN, "bosses": META}, open(sys.argv[4], "w"), indent=1)
print(json.dumps(META))
pv = Image.new("RGBA", (CAN * len(outs), CAN * 2), (30, 26, 34, 255))
ImageDraw.Draw(pv).rectangle((0, CAN, pv.width, pv.height), fill=(232, 216, 186, 255))
for i, o in enumerate(outs):
    pv.alpha_composite(o, (i * CAN, 0)); pv.alpha_composite(o, (i * CAN, CAN))
pv.convert("RGB").save(sys.argv[3], quality=86)
