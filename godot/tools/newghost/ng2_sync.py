# -*- coding: utf-8 -*-
# [roster2] 第二批新名鬼接入 counter.json／abil.json（唔會蓋走 abcore 喺 abil.json 嘅 SCARE／TAGS／MECH／LINK 等段）
# 用法（喺 godot 目錄）：python3 -I tools/newghost/ng2_sync.py
#   1. 行 build_cdata.build()（佢經 tools/newghost/ng2_cdata.py 掛鈎讀 newghost2.json：雙駐守 guard2、ENEMY、src）
#   2. 寫 data/nat/counter.json（同直接跑 build_cdata.py 一樣）
#   3. data/abil.json：淨係將第二批 30 隻嘅 ENEMY 條目加入／更新（其餘一字不改；直接跑 build_cdata.py 會重寫成 cdata 最小 stub）
import json, os, sys, importlib.util

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
os.chdir(ROOT)
sp = importlib.util.spec_from_file_location("build_cdata", os.path.join(ROOT, "tools", "cdata", "build_cdata.py"))
CD = importlib.util.module_from_spec(sp); sp.loader.exec_module(CD)
errs, abil, counter = CD.build()
for e in errs: print("ERR", e)
if errs: sys.exit(1)
json.dump(counter, open("data/nat/counter.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
N2 = json.load(open("data/nat/newghost2.json", encoding="utf-8"))
A = json.load(open("data/abil.json", encoding="utf-8"))
n = 0
for k in N2["ROSTER2"]:
    if A["ENEMY"].get(k) != abil["ENEMY"][k]: A["ENEMY"][k] = abil["ENEMY"][k]; n += 1
json.dump(A, open("data/abil.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
g2 = {c["guard2"]: cid for cid, c in counter["camps"].items() if c.get("guard2")}
miss = [k for k in N2["ROSTER2"] if k not in g2]
print("counter.json：雙駐守 %d 隻、據點 %d；abil.json ENEMY 更新 %d 隻；冇位：%s" % (len(g2), len(counter["camps"]), n, miss or "冇"))
if miss: sys.exit(1)
