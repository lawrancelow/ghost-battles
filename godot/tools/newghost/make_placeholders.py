# -*- coding: utf-8 -*-
# [newghost] 暫代圖：assets/spr/ng_ph/<ph>.webp（新名鬼 nw_*、大魔王 bm_*、雜兵 zd_*）
# 風格跟 core/art.gd：深褐粗墨線、偏灰病態色、白色無瞳眼；身上寫名（一眼知係暫代）。真圖（assets/spr/<spr>.webp）一到，遊戲自動用真圖。
# 用法：python3 -I tools/newghost/make_placeholders.py（之後要 Godot --import 一次）
import json, os, math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
D = json.load(open(os.path.join(ROOT, "data", "nat", "newghost.json"), encoding="utf-8"))
OUT = os.path.join(ROOT, "assets", "spr", "ng_ph"); os.makedirs(OUT, exist_ok=True)
FONT = "/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc"
INK = (58, 36, 24, 255)
# 系 → 病態底色（偏灰）
PAL = {"屍": (150, 160, 140), "魂": (170, 190, 200), "紙紮": (215, 205, 180), "妖": (130, 150, 120), "厲": (180, 150, 160),
       "使": (150, 140, 120), "官": (140, 150, 170), "橫": (160, 160, 165)}

def name_of(k):
    for sec in ("GHOSTS", "BOSS", "FOD"):
        if k in D[sec]: return D[sec][k]["name"]
    return k
def sys_of(k): return D["ENEMY"].get(k, {}).get("sys", "魂")

def draw(k, ph, boss=False, fod=False, solid=True):
    W, H = (340, 460) if boss else ((260, 360) if fod else (300, 420))
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0)); d = ImageDraw.Draw(im)
    c = PAL.get(sys_of(k), (160, 160, 160)); body = c + (255,); shade = tuple(int(x * 0.78) for x in c) + (255,)
    cx = W / 2; top = H * 0.06; hr = W * 0.30
    # 身：頭圓＋身梯形；實體企地（平底），飄嘅波浪下擺
    pts = []
    n = 40
    for i in range(n + 1):   # 頭頂半圓
        a = math.pi + math.pi * i / n
        pts.append((cx + hr * math.cos(a), top + hr + hr * math.sin(a)))
    bw = W * 0.40; by = H * 0.93
    if solid:
        pts += [(cx + bw, by), (cx - bw, by)]
    else:
        waves = 5
        for i in range(waves * 8 + 1):
            t = i / (waves * 8); x = cx + bw - 2 * bw * t
            pts.append((x, by - 18 + 14 * math.sin(t * waves * 2 * math.pi)))
    d.polygon(pts, fill=body)
    mask = Image.new("L", (W, H), 0); ImageDraw.Draw(mask).polygon(pts, fill=255)   # 陰影只喺身入面
    sh = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(sh).polygon([(cx - bw * 0.15, H * 0.5), (cx + bw * 1.2, H * 0.55), (cx + bw * 1.2, H), (cx + bw * 0.2, H)], fill=shade)
    im.paste(sh, (0, 0), Image.composite(sh, Image.new("RGBA", (W, H), (0, 0, 0, 0)), mask).split()[3])
    d.line(pts + [pts[0]], fill=INK, width=7, joint="curve")
    if boss:   # 魔王：兩隻角
        for s in (-1, 1):
            hx = cx + s * hr * 0.7
            d.polygon([(hx - 14, top + hr * 0.5), (hx + s * 30, top - 6), (hx + 14, top + hr * 0.35)], fill=shade, outline=INK)
    # 白色無瞳眼＋細嘴
    ey = top + hr * 1.0
    for s in (-1, 1):
        ex = cx + s * hr * 0.42
        d.ellipse([ex - 17, ey - 12, ex + 17, ey + 12], fill=(250, 250, 245, 255), outline=INK, width=4)
    d.arc([cx - 18, ey + 18, cx + 18, ey + 40], 200, 340, fill=INK, width=4)
    # 名（直寫）
    nm = name_of(k)
    vertical = all(ord(ch) > 0x2e80 for ch in nm)
    if vertical:
        fs = int(min(64 if not boss else 72, (by - (ey + 60)) / max(1, len(nm)) * 0.9)); ft = ImageFont.truetype(FONT, fs, index=3)
        y = ey + 56
        for ch in nm:
            w = d.textlength(ch, font=ft); d.text((cx - w / 2, y), ch, font=ft, fill=INK); y += fs * 1.02
    else:
        fs = 40; ft = ImageFont.truetype(FONT, fs, index=3)
        while d.textlength(nm, font=ft) > bw * 1.8 and fs > 16: fs -= 2; ft = ImageFont.truetype(FONT, fs, index=3)
        w = d.textlength(nm, font=ft); d.text((cx - w / 2, H * 0.62), nm, font=ft, fill=INK)
    # 「暫代」小印
    ft2 = ImageFont.truetype(FONT, 22, index=3)
    sx, sy = cx + bw * 0.35, by - 44
    d.rectangle([sx, sy, sx + 56, sy + 30], outline=(160, 40, 40, 255), width=3)
    d.text((sx + 6, sy + 1), "暫代", font=ft2, fill=(160, 40, 40, 255))
    im.save(os.path.join(OUT, ph + ".webp"), "WEBP", quality=88, method=6)

n = 0
for k, a in D["ART"].items():
    if os.path.exists(os.path.join(ROOT, "assets", "spr", a["spr"] + ".webp")): continue   # 已有真圖（牛頭馬面等）
    draw(k, a["ph"], boss=k in D["BOSS"], fod=k in D["FOD"], solid=a.get("solid", True)); n += 1
print("placeholders", n, "->", OUT)
