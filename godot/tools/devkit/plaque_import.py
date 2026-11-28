#!/usr/bin/env python3
# 把美術線的 plaque.json（art_pending/cg_m/plaque.json）併入 godot/data/cg_plaque.json
#   python3 plaque_import.py <godot目錄> <plaque.json>
# 接受格式：{"cg_office": {"size":[w,h], "quad":[[x,y]*4 左上起順時針], "text":"…", "color":"#…"}} 或同鍵對應陣列（多塊匾）。
# 鍵可帶 _m 後綴（cg_office_m → cg_office）。只覆蓋座標／顏色／size；text 有給才覆蓋。
import json, sys
R, SRC = sys.argv[1], sys.argv[2]
p = R + "/data/cg_plaque.json"; cur = json.load(open(p)); src = json.load(open(SRC))
for k, v in src.items():
    if k.startswith("_"): continue
    key = k[:-2] if k.endswith("_m") else k
    arr = v if isinstance(v, list) else [v]
    old = cur.get(key, [])
    out = []
    for i, e in enumerate(arr):
        o = dict(old[i]) if i < len(old) else {}
        for f in ("size", "quad", "color", "vertical"):
            if f in e: o[f] = e[f]
        if e.get("text"): o["text"] = e["text"]
        o.setdefault("text", ""); out.append(o)
    cur[key] = out; print("更新", key, len(out), "塊")
json.dump(cur, open(p, "w"), ensure_ascii=False, indent=1)
