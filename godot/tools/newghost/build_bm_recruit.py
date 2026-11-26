# [補丁43] 魔王收服：7 個魔王做成可招降名鬼 → data/nat/bm_recruit.json
# 用法：python3 -I tools/newghost/build_bm_recruit.py   （喺 godot 目錄跑）
#   GHOSTS（三圍 力智武、range）由呢度定；名、稱號、出處、台詞照抄 newghost.json BOSS；ENEMY／ABIL 只抄 sys、sc、mech 俾圖鑑用。
#   魂魄：首殺 15，之後每次 2–4；招降要 120 魂魄（王品）、祭壇 4 級（soul_data 王品規則）。
import json, os
NG = json.load(open(os.path.join("data", "nat", "newghost.json"), encoding="utf-8"))
RO = json.load(open(os.path.join("data", "nat", "roles.json"), encoding="utf-8"))
BASE = {   # 力 智 武；range（職業見 roles.json CLS）
 "bm_taotie": ([125, 55, 120], "melee"), "bm_jembalang": ([95, 70, 125], "melee"), "bm_hou": ([130, 45, 120], "melee"),
 "bm_langsuir": ([85, 80, 125], "melee"), "bm_krasue": ([60, 130, 95], "ranged"), "bm_pang": ([70, 120, 100], "ranged"),
 "bm_shuten": ([135, 50, 120], "melee"),
}
G = {}; EN = {}; AB = {}; PIN = {}
for k, (b, rg) in BASE.items():
    B = NG["BOSS"][k]
    assert RO["CLS"][k] and RO["TIER"][k] == "王牌", k
    G[k] = {"name": B["name"], "title": B["title"], "q": "名", "base": b, "range": rg, "trait": B["title"], "lore": B["lore"], "say": B["say"], "nw": True, "bm": True}
    e = NG["ENEMY"][k]; EN[k] = {"sys": e["sys"], "sc": e["sc"], "mech": e.get("mech", []), "ch": int(B["ch"]) + 1}
    AB[k] = {"sys": e["sys"], "sc": e["sc"], "tags": []}
    PIN[k] = "王"
out = {"v": 1, "note": "補丁43 魔王收服（tools/newghost/build_bm_recruit.py 生成）", "GHOSTS": G, "ENEMY": EN, "ABIL": AB, "PIN": PIN,
       "ROSTER": list(BASE), "SOUL": {"first": 15, "win": [2, 4]}, "CH": {k: int(NG["BOSS"][k]["ch"]) for k in BASE}}
p = os.path.join("data", "nat", "bm_recruit.json")
json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("wrote", p, len(G))
