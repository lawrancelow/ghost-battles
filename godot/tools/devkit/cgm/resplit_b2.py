#!/usr/bin/env python3
# B2 孟婆遞湯：角色表（_sheet.png）原本用直線框分開兩個角色，阿福條紅頸巾同衫被切直邊、有一截入咗孟婆層，
# 兩個角色各自遊走時會見到切口。呢度改用沿輪廓嘅分界線重分，並按舊 layout 換算返位置。
# 用法：python3 -I resplit_b2.py <layers/b2_soup 資料夾>
import sys, os, json
import numpy as np
from PIL import Image
d = sys.argv[1]
sh = np.array(Image.open(os.path.join(d, "_sheet.png")).convert("RGBA"))
H, W = sh.shape[:2]
ys, xs = np.mgrid[0:H, 0:W]
# 阿福嘅範圍（角色表像素）：分界線跟住孟婆隻手同衫袖外沿
bound = np.select([ys < 400, ys < 462, ys < 500], [560, 574, 595], 682)   # 上段避開湯匙，中段貼住孟婆隻手，下段包埋紅頸巾
afu_m = xs < bound
# 兩層位置係各自配對返嚟（縮放比例差少少），接觸位唔會完全啱縫；孟婆層喺隻手嗰段多留幾像素疊喺阿福層後面，補住條縫
men_bound = np.select([ys < 400, ys < 500], [560, 568], 682)
men_m = xs >= men_bound
old_afu_m = (xs < 600) & ~((xs >= 572) & (xs < 600) & (ys >= 390) & (ys < 480))
old_men_m = xs >= 572
def bbox(a):
    yy, xx = np.where(a > 8); return xx.min(), yy.min(), xx.max() + 1, yy.max() + 1
L = json.load(open(os.path.join(d, "layout.json"), encoding="utf-8"))
for name, new_m, old_m in [("afu", afu_m, old_afu_m), ("mengpo", men_m, old_men_m)]:
    ly = next(l for l in L["layers"] if l["name"] == name)
    ob = bbox(sh[:, :, 3] * old_m); nb = bbox(sh[:, :, 3] * new_m)
    assert abs((ob[2] - ob[0]) - ly["src_size"][0]) <= 3 and abs((ob[3] - ob[1]) - ly["src_size"][1]) <= 3, (name, ob, ly["src_size"])   # 舊圖閾值略有出入（差 1–2 像素）
    im = sh.copy(); im[:, :, 3] = im[:, :, 3] * new_m
    out = Image.fromarray(im).crop(nb)
    old_p = os.path.join(d, ly["file"]); bak = os.path.join(d, "_old_" + ly["file"])
    if not os.path.exists(bak): os.rename(old_p, bak)
    out.save(old_p)
    sx = ly["w"] / ly["src_size"][0]; sy = ly["h"] / ly["src_size"][1]
    ly["x"] = round(ly["x"] + (nb[0] - ob[0]) * sx); ly["y"] = round(ly["y"] + (nb[1] - ob[1]) * sy)
    ly["src_size"] = [int(nb[2] - nb[0]), int(nb[3] - nb[1])]
    ly["w"] = round(ly["src_size"][0] * sx); ly["h"] = round(ly["src_size"][1] * sy)
    print(name, "old", ob, "new", nb, ly["x"], ly["y"], ly["w"], ly["h"])
json.dump(L, open(os.path.join(d, "layout.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
