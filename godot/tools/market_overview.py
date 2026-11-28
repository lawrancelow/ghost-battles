#!/usr/bin/env python3
"""把 market_ui_shots 的實機截圖砌成一張總覽圖（給老闆看）。
用法：python3 tools/market_overview.py [截圖目錄] [輸出.jpg]"""
import os, sys
from PIL import Image, ImageDraw, ImageFont
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/meeting/market/shots_ui"
OUT = sys.argv[2] if len(sys.argv) > 2 else "/home/claude/meeting/market/m1_ui_overview.jpg"
ITEMS = [("s01_normal", "1. 食街正常營業"), ("s04_shelf_dual", "2. 攤位雙貨：貨架面板"),
         ("s06_panel_counter", "3. 櫃檯面板"), ("s05_panel_patrol", "4. 巡邏面板（救回 vs 村子少了）"),
         ("s07_steal_cash_chase", "5. 偷錢：巡邏鬼去追"), ("s08_steal_goods", "6. 偷貨"),
         ("s09_cut_queue", "7. 插隊"), ("s10_brawl", "8. 吵架打鬧"),
         ("s11_caught", "9. 抓到"), ("s12_lost", "10. 沒人管：漏網損失"),
         ("s13_overwork", "11. 過勞：硬撐／趴下"), ("s02_title", "12. 切街標題卡（牌坊 A）")]
fp = None
for f in ["sans_b.otf", "sans_r.otf", "serif_b.otf"]:
    if os.path.exists(os.path.join(ROOT, "fonts", f)): fp = os.path.join(ROOT, "fonts", f); break
font = ImageFont.truetype(fp, 24) if fp else ImageFont.load_default()
COLS = 4; TW = 450; cap = 44; pad = 14
ims = []
for k, t in ITEMS:
    p = os.path.join(SRC, k + ".png")
    if not os.path.exists(p): print("缺", k); continue
    im = Image.open(p).convert("RGB"); im = im.resize((TW, int(im.size[1] * TW / im.size[0])), Image.LANCZOS)
    ims.append((im, t))
if not ims: sys.exit("沒有截圖")
TH = ims[0][0].size[1]
rows = (len(ims) + COLS - 1) // COLS
cv = Image.new("RGB", (COLS * (TW + pad) + pad, rows * (TH + cap + pad) + pad), (27, 22, 32))
d = ImageDraw.Draw(cv)
for i, (im, t) in enumerate(ims):
    x = pad + (i % COLS) * (TW + pad); y = pad + (i // COLS) * (TH + cap + pad)
    d.text((x + 2, y + 6), t, fill=(243, 214, 138), font=font)
    cv.paste(im, (x, y + cap))
cv.save(OUT, quality=86)
print(OUT, cv.size)
