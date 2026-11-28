# 考核官頭像「探出圈」合成：深紫圓底＋金邊圈；帽／頭頂越出圈上緣，下半身被圈底裁走，金圈前緣蓋住身體
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFilter
from scipy import ndimage
SPR = sys.argv[1]; OUT = sys.argv[2]
# key: (src, 臉中心 y 比例, 頭頂到臉中心想佔幾多 R)
# key: (src, 臉中心 x 比例, 臉中心 y 比例, 要刪嘅漂浮道具框 (x0,y0,x1,y1) 比例或 None)
CH = {"chen": ("kpi_boss_chen_full.webp", 0.435, 0.285, (0.70, 0.185, 1.0, 0.56)),
      "he": ("kpi_boss_he_full.webp", 0.40, 0.27, (0.675, 0.13, 1.0, 0.42)),
      "qian": ("kpi_boss_qian_full.webp", 0.32, 0.31, None), "dato": ("kpi_boss_dato_full.webp", 0.41, 0.265, None),
      "nuo": ("kpi_boss_nuo_full.webp", 0.44, 0.25, None), "pang": ("bm_pang.webp", 0.45, 0.255, None)}
SPAN = 1.45      # 頭頂到臉中心 = 1.5R（帽約 1/3 頭高出圈）
FACE_DY = -0.28 # 臉中心喺圓心上少少
R = 128; CAN = 768; C = CAN // 2   # 畫布＝圓直徑 3 倍（帽展腳全長都裝得落）
def main_body(im):
    a = np.array(im)[:, :, 3] > 24
    lab, n = ndimage.label(a)
    if n <= 1: return im
    sizes = ndimage.sum(np.ones_like(lab), lab, range(1, n + 1))
    keep = lab == (int(np.argmax(sizes)) + 1)
    arr = np.array(im); arr[:, :, 3] = np.where(keep, arr[:, :, 3], 0)
    return Image.fromarray(arr)
def make(key):
    src, fx, fy, prop = CH[key]
    im = Image.open(f"{SPR}/{src}").convert("RGBA")
    if prop:   # 漂浮道具（印章、竹簡）同底下嗰縷煙：刪走
        a = np.array(im); W0, H0 = im.size
        a[int(prop[1] * H0):int(prop[3] * H0), int(prop[0] * W0):int(prop[2] * W0), 3] = 0
        im = Image.fromarray(a)
    im = main_body(im)
    if prop:
        a2 = np.array(im)[:, :, 3]; W0, H0 = im.size
        x0 = int(prop[0] * W0); y0 = int(prop[1] * H0); y1 = int(prop[3] * H0)
        PROPCUT[key] = int(np.sum(a2[max(0, y0):min(y1, int(fy * H0)), max(0, x0 - 1)] > 120)) + int(np.sum(a2[max(0, y0 - 1), x0:] > 120))
    bb = im.getbbox(); top = bb[1]
    face_x = fx * im.width; face_y = fy * im.height
    s = SPAN * R / max(1.0, face_y - top)
    fig = im.resize((int(im.width * s), int(im.height * s)), Image.LANCZOS)
    ox = int(round(C - face_x * s)); oy = int(round(C + FACE_DY * R - face_y * s))
    layer = Image.new("RGBA", (CAN, CAN)); layer.paste(fig, (ox, oy), fig)
    # 遮罩：圈內全顯；臉中心以上（帽＋展腳全長＋頭頂）全闊保留；臉中心至下巴只留頭部橢圓；以下只留圈內
    fyc = C + FACE_DY * R
    m = Image.new("L", (CAN, CAN), 0); d = ImageDraw.Draw(m)
    d.ellipse((C - R + 3, C - R + 3, C + R - 3, C + R - 3), fill=255)
    d.rectangle((0, 0, CAN, int(fyc)), fill=255)
    d.ellipse((int(C - 1.22 * R), int(fyc - 1.6 * R), int(C + 1.22 * R), int(fyc + 0.62 * R)), fill=255)
    # 圈外、連住頭頂嘅整塊（斜展腳、頭巾尾、頭髮）：按連通塊整塊保留，唔用直線切
    al0 = np.array(layer)[:, :, 3]
    yy0, xx0 = np.mgrid[0:CAN, 0:CAN]
    outc0 = (xx0 - C) ** 2 + (yy0 - C) ** 2 > (R - 2) ** 2
    zone = outc0 & (yy0 < fyc + 0.9 * R) & (al0 > 6)
    lab, n = ndimage.label(zone)
    if n:
        hit = np.unique(lab[(yy0 < fyc) & zone])
        keep = np.isin(lab, hit[hit > 0])
        keep = ndimage.binary_dilation(keep, iterations=3).astype(np.float32)
        # 連住頭嘅膊頭：由耳仔高度向下慢慢淡出（長漸變，唔係硬切）
        wy = np.clip((fyc + 0.7 * R - yy0) / (0.45 * R), 0.0, 1.0)
        ma0 = np.maximum(np.array(m).astype(np.float32), keep * wy * 255.0).astype(np.uint8)
        m = Image.fromarray(ma0)
    m = m.filter(ImageFilter.GaussianBlur(2.2))
    # 硬切口檢查：圈外、遮罩半透明而角色實心嘅像素
    ma = np.array(m).astype(np.float32); al = np.array(layer)[:, :, 3].astype(np.float32)
    yy, xx = np.mgrid[0:CAN, 0:CAN]; outc = (xx - C) ** 2 + (yy - C) ** 2 > (R + 6) ** 2
    gy, gx = np.gradient(ma); gm = np.hypot(gx, gy)
    hard = outc & (al > 160) & (gm > 255.0 / 10.0)   # 10 px 內由實變透＝硬切口
    cuts = int(np.sum(hard))
    edge = int(np.sum(al[0, :] > 10) + np.sum(al[:, 0] > 10) + np.sum(al[:, -1] > 10))
    CUTS[key] = (cuts, edge)
    ys, xs = np.nonzero(hard)
    if len(ys): CUTS[key] = (cuts, edge, int(ys.min()-C), int(ys.max()-C), int(xs.min()-C), int(xs.max()-C))
    la = np.array(layer); la[:, :, 3] = (la[:, :, 3].astype(np.float32) * np.array(m) / 255.0).astype(np.uint8)
    fig_m = Image.fromarray(la)
    out = Image.new("RGBA", (CAN, CAN))
    d2 = ImageDraw.Draw(out)
    d2.ellipse((C - R, C - R, C + R, C + R), fill=(58, 36, 64, 245))
    # 圈內暗角
    vg = Image.new("L", (CAN, CAN), 0); ImageDraw.Draw(vg).ellipse((C - R + 14, C - R + 14, C + R - 14, C + R - 14), fill=255)
    vg = vg.filter(ImageFilter.GaussianBlur(14)); dark = Image.new("RGBA", (CAN, CAN), (20, 10, 24, 0))
    circ = Image.new("L", (CAN, CAN), 0); ImageDraw.Draw(circ).ellipse((C - R, C - R, C + R, C + R), fill=255)
    dark.putalpha(Image.fromarray((np.array(circ) * (1 - np.array(vg) / 255.0) * 0.55).astype(np.uint8)))
    out.alpha_composite(dark)
    # 金圈（後）
    ring = lambda dr, w, col: dr.ellipse((C - R, C - R, C + R, C + R), outline=col, width=w)
    ring(ImageDraw.Draw(out), 9, (122, 78, 26, 255)); ring(ImageDraw.Draw(out), 5, (232, 176, 74, 255))
    # 投影（出圈部分最明顯）
    sh = Image.new("RGBA", (CAN, CAN), (10, 4, 12, 0)); sa = np.array(fig_m)[:, :, 3]
    sh.putalpha(Image.fromarray((sa * 0.55).astype(np.uint8)))
    sh = sh.filter(ImageFilter.GaussianBlur(5)); sh2 = Image.new("RGBA", (CAN, CAN)); sh2.alpha_composite(sh, (5, 7))
    out.alpha_composite(sh2)
    out.alpha_composite(fig_m)
    # 金圈前緣：蓋住下半身（切線以下嗰段弧）
    front = Image.new("RGBA", (CAN, CAN)); fd = ImageDraw.Draw(front)
    ring(fd, 9, (122, 78, 26, 255)); ring(fd, 5, (232, 176, 74, 255))
    fm = Image.new("L", (CAN, CAN), 0); ImageDraw.Draw(fm).rectangle((0, int(C + 0.05 * R), CAN, CAN), fill=255)
    fa = np.array(front); fa[:, :, 3] = (fa[:, :, 3].astype(np.float32) * np.array(fm.filter(ImageFilter.GaussianBlur(3))) / 255.0).astype(np.uint8)
    out.alpha_composite(Image.fromarray(fa))
    nm = "kpi_boss_" + key
    out.save(f"{OUT}/{nm}.webp", lossless=False, quality=92)
    out.resize((CAN // 2, CAN // 2), Image.LANCZOS).save(f"{OUT}/{nm}_s.webp", quality=92)
    return out
CUTS = {}
PROPCUT = {}
outs = [make(k) for k in CH]
print('硬切口像素（圈外）／貼邊像素：', CUTS)
print('道具框切到主體像素：', PROPCUT)
# 預覽：暗底＋亮底
pv = Image.new("RGBA", (CAN * len(outs), CAN * 2), (30, 26, 34, 255))
ImageDraw.Draw(pv).rectangle((0, CAN, pv.width, pv.height), fill=(232, 216, 186, 255))
for i, o in enumerate(outs):
    pv.alpha_composite(o, (i * CAN, 0)); pv.alpha_composite(o, (i * CAN, CAN))
pv.convert("RGB").save(sys.argv[3], quality=86)
