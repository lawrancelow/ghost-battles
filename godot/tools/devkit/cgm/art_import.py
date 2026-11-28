#!/usr/bin/env python3
# 美術組分層產線 → 動態插圖素材（支援多份 layout 疊加）
# 用法：python3 -I art_import.py <圖層資料夾> <godot目錄> <插圖key> <preset.json> [extra_layout.json …]
#   圖層資料夾：layout.json（canvas、layers[x,y,w,h 像素、z]）＋ bg.png ＋ 角色 png
#   extra_layout.json（可多份，按次序疊）：{"use_bg": "…", "add_layers": [ {name,file,x,y,w,h,z,pivot,motion} ]}
#     use_bg：用咗呢份附加層就要換嘅底圖（已補走被切出嚟嘅嘢）；最後一份有 use_bg 嘅為準
#   preset.json：鏡頭、粒子、每層動作（按 name），以及 motion 名 → 動作參數嘅對照
import sys, os, json
from PIL import Image
src, gd, key, preset_p = sys.argv[1:5]
extras = sys.argv[5:]
base = json.load(open(os.path.join(src, "layout.json"), encoding="utf-8"))
P = json.load(open(preset_p, encoding="utf-8"))
CW, CH = base["canvas"]
bg_file = next((l["file"] for l in base["layers"] if l.get("name") == "bg"), "bg.png")
layers = [dict(l, _dir=src) for l in base["layers"] if l.get("name") != "bg"]
for ep in extras:
    E = json.load(open(ep, encoding="utf-8"))
    if E.get("use_bg"): bg_file = E["use_bg"]
    for l in E.get("add_layers", []): layers.append(dict(l, _dir=src))
od = os.path.join(gd, "assets", "cg_layers", key); os.makedirs(od, exist_ok=True)
for f in os.listdir(od):
    if f.endswith(".webp") or f.endswith(".webp.import"): os.remove(os.path.join(od, f))
bg = Image.open(os.path.join(src, bg_file)).convert("RGB")
if max(bg.size) > 1600: bg.thumbnail((1600, 1600), Image.LANCZOS)
bg.save(os.path.join(od, "bg.webp"), quality=88, method=4)
out = {"bg": "bg.webp", "src_canvas": [CW, CH]}
if "cam" in P: out["cam"] = P["cam"]
out["fx"] = P.get("fx", [])
MM = P.get("motion_map", {}); LF = P.get("layer_fx", {})
res = []
for l in sorted(layers, key=lambda l: l.get("z", 0)):
    im = Image.open(os.path.join(l["_dir"], l["file"])).convert("RGBA")
    w, h = int(l["w"]), int(l["h"])
    lim = max(2 * w, 2 * h, 64)   # 原圖最多留 2 倍顯示尺寸（SubViewport 2 倍解像度），慳記憶體
    if max(im.size) > lim: im.thumbnail((lim, lim), Image.LANCZOS)
    fn = l["name"] + ".webp"; im.save(os.path.join(od, fn), lossless=True, method=4)
    fx = {}
    for m in l.get("motion", []): fx.update(json.loads(json.dumps(MM.get(m, {}))))
    lf = LF.get(l["name"], {})
    fx.update(lf.get("fx", {}))
    ent = {"name": l["name"], "img": fn, "rect": [round(l["x"] / CW, 5), round(l["y"] / CH, 5), round(w / CW, 5), round(h / CH, 5)],
           "z": l.get("z", 0), "pivot": lf.get("pivot", l.get("pivot", [0.5, 1.0])), "par": lf.get("par", 0.0), "fx": fx}
    res.append(ent)
out["layers"] = res
conf_p = os.path.join(gd, "assets", "cg_layers.json")
conf = json.load(open(conf_p, encoding="utf-8")) if os.path.exists(conf_p) else {}
conf[key] = out
json.dump(conf, open(conf_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("ok", key, len(res), "層", len(out["fx"]), "粒子", "底圖", bg_file)
