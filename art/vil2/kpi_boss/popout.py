# 考核官頭像「探出圈」合成：深紫圓底＋金邊圈；帽／頭頂越出圈上緣，下半身被圈底裁走，金圈前緣蓋住身體
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFilter
from scipy import ndimage
SPR = sys.argv[1]; OUT = sys.argv[2]
# key: (src, 臉中心 y 比例, 頭頂到臉中心想佔幾多 R)
# key: (src, 臉中心 x 比例, 臉中心 y 比例, 要刪嘅漂浮道具框 (x0,y0,x1,y1) 比例或 None)
CH = {"chen": ("kpi_boss_chen_full.webp", 0.435, 0.285, (0.66, 0.17, 1.0, 0.56)),
      "he": ("kpi_boss_he_full.webp", 0.40, 0.27, (0.64, 0.13, 1.0, 0.42)),
      "qian": ("kpi_boss_qian_full.webp", 0.32, 0.31, (0.64, 0.17, 1.0, 0.6)), "dato": ("kpi_boss_dato_full.webp", 0.41, 0.265, (0.72, 0.1, 1.0, 0.58)),
      "nuo": ("kpi_boss_nuo_full.webp", 0.44, 0.25, (0.63, 0.05, 1.0, 0.6)), "pang": ("bm_pang.webp", 0.45, 0.255, None)}
SPAN = 1.45      # 頭頂到臉中心 = 1.5R（帽約 1/3 頭高出圈）
FACE_DY = -0.28 # 臉中心喺圓心上少少
R = 128; CAN = 512; C = CAN // 2
def main_body(im):
    a = np.array(im)[:, :, 3] > 24
    lab, n = ndimage.label(ndimage.binary_dilation(a, iterations=2))
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
    bb = im.getbbox(); top = bb[1]
    face_x = fx * im.width; face_y = fy * im.height
    s = SPAN * R / max(1.0, face_y - top)
    fig = im.resize((int(im.width * s), int(im.height * s)), Image.LANCZOS)
    ox = int(round(C - face_x * s)); oy = int(round(C + FACE_DY * R - face_y * s))
    layer = Image.new("RGBA", (CAN, CAN)); layer.paste(fig, (ox, oy), fig)
    # 遮罩：圈內全顯；圈外只留「帽帶」（頭頂至展腳，全闊）＋「頭部」（下巴以上、離中線 0.8R 內）
    hat_bot = oy + (top + 0.80 * (face_y - top)) * s
    neck = C + FACE_DY * R + 0.45 * SPAN * R
    m = Image.new("L", (CAN, CAN), 0); d = ImageDraw.Draw(m)
    d.ellipse((C - R + 3, C - R + 3, C + R - 3, C + R - 3), fill=255)
    d.rectangle((0, 0, CAN, int(hat_bot)), fill=255)
    fyc = C + FACE_DY * R
    d.ellipse((int(C - 1.22 * R), int(fyc - 1.6 * R), int(C + 1.22 * R), int(fyc + 0.62 * R)), fill=255)   # 頭部（圓角邊，唔再直線切）
    m = m.filter(ImageFilter.GaussianBlur(2.2))
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
outs = [make(k) for k in CH]
# 預覽：暗底＋亮底
pv = Image.new("RGBA", (CAN * len(outs), CAN * 2), (30, 26, 34, 255))
ImageDraw.Draw(pv).rectangle((0, CAN, pv.width, pv.height), fill=(232, 216, 186, 255))
for i, o in enumerate(outs):
    pv.alpha_composite(o, (i * CAN, 0)); pv.alpha_composite(o, (i * CAN, CAN))
pv.convert("RGB").save(sys.argv[3], quality=86)
