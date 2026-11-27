# 把 UI 套件縮到遊戲邏輯尺寸（390 寬畫布）→ godot/assets/ui/kit/*.webp；修滑桿／小彈窗；造紙紋底
import json, os, sys
import numpy as np
from PIL import Image
K = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(K, "../../../godot/assets/ui/kit"); os.makedirs(OUT, exist_ok=True)
SC = {"panel_large": .25, "popup_small": .3, "title_plate": .3, "btn_close": .3, "tab_on": .35, "tab_off": .35, "card": .3,
      "avatar_slot": .3, "btn_primary": .25, "btn_primary_down": .25, "btn_secondary": .25, "btn_secondary_down": .25,
      "btn_danger": .25, "btn_disabled": .25, "bar_track": .25, "bar_fill": .25, "toggle_on": .25, "toggle_off": .25,
      "badge_dot": .25, "badge_count": .25, "star_on": .25, "star_off": .25, "stat_row": .25, "nav_bar": .3,
      "res_slot": .3, "lord_plaque": .3, "quest_red": .35, "quest_grey": .35, "fab": .3, "fab_cd": .3, "dialog_box": .35}
for n in ["village", "ghost", "map", "chest", "book"]: SC["nav_" + n] = .4; SC["nav_" + n + "_on"] = .4
meta = {}
def save(name, im, s, m=None):
    w, h = im.size; im2 = im.resize((max(1, round(w * s)), max(1, round(h * s))), Image.LANCZOS)
    im2.save(os.path.join(OUT, name + ".webp"), "WEBP", quality=92, method=6)
    meta[name] = {"w": im2.size[0], "h": im2.size[1], "m": (round(m * s) if m else 0)}
kj = {d["file"][:-4]: d for d in json.load(open(os.path.join(K, "kit.json")))["items"]} if isinstance(json.load(open(os.path.join(K, "kit.json"))), dict) and "items" in json.load(open(os.path.join(K, "kit.json"))) else None
if kj is None:
    d = json.load(open(os.path.join(K, "kit.json"))); kj = {}
    for v in d.values():
        if isinstance(v, list):
            for it in v:
                if isinstance(it, dict) and "file" in it: kj[it["file"][:-4]] = it
for name, s in SC.items():
    im = Image.open(os.path.join(K, name + ".png")).convert("RGBA")
    if name == "popup_small":   # 修掉底部兩個按鈕底板：用上面紙面向下鏡射補
        a = np.array(im); h, w = a.shape[:2]
        y0, y1 = int(h * 0.58), int(h * 0.90); x0, x1 = int(w * 0.12), int(w * 0.88)
        src = a[y0 - (y1 - y0):y0, x0:x1][::-1].copy(); a[y0:y1, x0:x1] = src; im = Image.fromarray(a)
    save(name, im, s, kj.get(name, {}).get("nine_slice_margin"))
# 滑桿：拆軌道＋拖柄
im = Image.open(os.path.join(K, "slider.png")).convert("RGBA"); a = np.array(im); h, w = a.shape[:2]
col = (a[:, :, 3] > 40).sum(0); knob = np.where(col > 70)[0]; k0, k1 = int(knob.min()) - 4, int(knob.max()) + 4
kn = Image.fromarray(a[:, k0:k1].copy()); bb = kn.getbbox(); kn = kn.crop(bb)
tr = a.copy(); ref = a[:, k0 - (k1 - k0):k0]
colx = a[:, k0 - 30:k0 - 29]; tr[:, k0 - 6:k1 + 6] = np.repeat(colx, (k1 + 6) - (k0 - 6), axis=1)
trk = Image.fromarray(tr); trk = trk.crop(trk.getbbox())
save("slider_track", trk, .3, 40); save("slider_knob", kn, .3)
# 紙紋底（卡片框內部，可平鋪）
c = Image.open(os.path.join(K, "card.png")).convert("RGBA"); W, H = c.size
p = c.crop((int(W * .2), int(H * .3), int(W * .8), int(H * .7))).convert("RGB")
save("paper_fill", p, .5)
# 深色底紋（大面板框內部，墨綠黑板）
pl = Image.open(os.path.join(K, "panel_large.png")).convert("RGBA"); W, H = pl.size
save("dark_fill", pl.crop((int(W * .25), int(H * .3), int(W * .75), int(H * .6))).convert("RGB"), .5)
json.dump(meta, open(os.path.join(OUT, "kit_meta.json"), "w"), ensure_ascii=False, indent=0)
print(len(meta), "files ->", OUT)
