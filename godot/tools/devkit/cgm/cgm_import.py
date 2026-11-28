#!/usr/bin/env python3
# 分層動態插圖素材匯入：美術組交嘅 <src>/<圖名>/（bg.* ＋ 角色透明 png ＋ layout.json）
#   → godot/assets/cg_layers/<圖名>/*.webp（無損 alpha、限長邊）＋ 合併 layout 入 godot/assets/cg_layers.json
# 用法：python3 -I cgm_import.py <src_dir> <godot_dir> [圖名…]   （冇圖名＝src 入面全部）
import sys, os, json
from PIL import Image
src, gd = sys.argv[1], sys.argv[2]
names = sys.argv[3:] or sorted(d for d in os.listdir(src) if os.path.isdir(os.path.join(src, d)))
conf_p = os.path.join(gd, "assets", "cg_layers.json")
conf = json.load(open(conf_p, encoding="utf-8")) if os.path.exists(conf_p) else {}
MAXS = 1600   # 底圖長邊上限（SubViewport 最大約 900×800 ×2，夠清又唔食記憶體）
for n in names:
    d = os.path.join(src, n); L = json.load(open(os.path.join(d, "layout.json"), encoding="utf-8"))
    od = os.path.join(gd, "assets", "cg_layers", n); os.makedirs(od, exist_ok=True)
    BGW, BGH = Image.open(os.path.join(d, L.get("bg", "bg.jpg"))).size
    def fit(ly):   # 角色圖裁咗透明邊：按原圖比例調返 x（中心）、y（腳底）、h（高度），位置唔變
        im = Image.open(os.path.join(d, ly["img"])).convert("RGBA"); pw, ph = im.size; bb = im.getbbox()
        if not bb: return
        l, t, r, b = bb; h = float(ly.get("h", 0.2)); px = h * BGH / ph   # 角色圖 1px ＝ 底圖幾多 px
        ly["x"] = round(float(ly.get("x", 0.5)) + ((l + r) / 2 - pw / 2) * px / BGW, 5)
        ly["y"] = round(float(ly.get("y", 0.9)) - (ph - b) * px / BGH, 5)
        ly["h"] = round(h * (b - t) / ph, 5)
    def conv(fn, maxs, box=None):
        base = os.path.splitext(fn)[0]; im = Image.open(os.path.join(d, fn))
        im = im.convert("RGBA") if im.mode in ("RGBA", "LA", "P") else im.convert("RGB")
        if im.mode == "RGBA":   # 裁走透明邊（layout 用腳底＋高度定位，所以要按比例調返 h）
            bb = box or im.getbbox()
            if bb: im = im.crop(bb)
        if max(im.size) > maxs: im.thumbnail((maxs, maxs), Image.LANCZOS)
        if im.mode == "RGBA":
            im.save(os.path.join(od, base + ".webp"), lossless=True, method=4)
        else:
            im.save(os.path.join(od, base + ".webp"), quality=88, method=4)
        return base + ".webp"
    L["bg"] = conv(L.get("bg", "bg.jpg"), MAXS)
    for ly in L.get("layers", []):
        fit(ly)
        mb = Image.open(os.path.join(d, ly["img"])).convert("RGBA").getbbox()   # 換表情圖用主圖嘅裁切框（同一張畫布），唔會錯位
        ly["img"] = conv(ly["img"], 900, mb)
        b = ly.get("fx", {}).get("blink")
        if b and b.get("alt"): b["alt"] = conv(b["alt"], 900, mb)
    conf[n] = L
    print("ok", n, len(L.get("layers", [])), "層", len(L.get("fx", [])), "粒子")
json.dump(conf, open(conf_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
