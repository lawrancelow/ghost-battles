#!/usr/bin/env python3
# 市集第 3 章已過審美術匯入（2026-11-28 老闆選用）：新攤 8 台 × 三段外觀、商品圖示 8 樣。
# 用法：python3 tools/devkit/art/market_ch3_import.py <art_pending 目錄>   （喺 godot/ 目錄行）
# Tehlah 紙紮電動轎：攤位圖有、商品圖示未畫 → 唔上架。
import sys, json, os
from PIL import Image
AP = sys.argv[1]
IDS = ["zong", "jiuniang", "bangtui", "modou", "taomu", "tongling", "huangfu", "luichar"]
def fit(src, dst, W, H, pad, bottom):
    im = Image.open(src).convert("RGBA"); im = im.crop(im.getbbox())
    k = min((W - 2 * pad) / im.width, (H - 2 * pad) / im.height)
    im = im.resize((max(1, round(im.width * k)), max(1, round(im.height * k))), Image.LANCZOS)
    out = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    out.paste(im, ((W - im.width) // 2, (H - pad - im.height) if bottom else (H - im.height) // 2), im)
    out.save(dst, "WEBP", quality=92, method=6)
man = json.load(open("assets/spr_manifest.json"))
for i in IDS:
    for n in (1, 2, 3):
        key = "mvs_c3_%s%s" % (i, "" if n == 1 else "_%d" % n)
        fit("%s/market_stall/cut_ch3/%s_%d.png" % (AP, i, n), "assets/spr/%s.webp" % key, 240, 200, 3, True)
        man[key] = "res://assets/spr/%s.webp" % key
    key = "mvi_c3_%s" % i
    fit("%s/market_goods/cut_ch3/g_c3_%s.png" % (AP, i), "assets/spr/%s.webp" % key, 160, 160, 6, False)
    man[key] = "res://assets/spr/%s.webp" % key
json.dump(man, open("assets/spr_manifest.json", "w"), ensure_ascii=False, separators=(",", ":"))
print("ok", len(IDS) * 4)
