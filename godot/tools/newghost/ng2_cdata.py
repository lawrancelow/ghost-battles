# -*- coding: utf-8 -*-
# [roster2] build_cdata.py 掛鈎：第二批 30 隻新名鬼接入 counter.json／abil.json ENEMY
#   數據：data/nat/newghost2.json（tools/newghost/build_newghost2.py 生成；冇呢個檔＝乜都唔做，cdata 照舊）
#   接入方式＝據點「雙駐守」（guard2）：90 個據點駐守位唔夠 120 隻可招降鬼分，所以每隻新鬼入一個合適鬼幫嘅第 2～4 圈據點，
#   頂替該據點一隻非駐守名鬼（佢喺其他據點仍有出場）或者一隻雜兵；打贏時 guard（原駐守）同 guard2 都掉主魂（soul_data.gd 掛鈎）。
#   唔放野外王據點（king）、魔王據點（bm）；每據點最多一隻 guard2；原駐守（最後一隻＝頭目）唔郁。
import json, os

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
P = os.path.join(ROOT, "data", "nat", "newghost2.json")
D = json.load(open(P, encoding="utf-8")) if os.path.exists(P) else {}
FODS = {"youhun", "egui", "xiaogui", "zombie", "shuigui", "zhiren"}

def on(): return bool(D.get("GHOSTS"))
def enemy_t(): return D.get("ENEMY_T", {})
def rows():   # build_cdata add() 參數：(id, 系, 嚇法, 機制csv, 章, T, 名)
    o = []
    for k in D.get("ROSTER2", []):
        e = D["ENEMY"][k]
        sc = _sc_name(e["sc"][0])
        o.append((k, e["sys"], sc, ",".join(e["mech"]), int(e["ch"]), int(e["tier"]), D["GHOSTS"][k]["name"]))
    return o
_SC = {"breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
def _sc_name(code): return _SC[code]
def is_fod(i): return i in FODS or i.startswith("zd_")

LOG = []
def place(CAMPS, mech_of=lambda i: []):
    """改 CAMPS（build_cdata 嘅據點表，build() 之前）：plan 入面放 guard2；回 [(k, 據點id, 頂替咗邊隻)]"""
    if not on(): return []
    out = []
    for k in D.get("ROSTER2", []):
        c2 = D["CAMP2"][k]; ch = int(c2["ch"]); want = int(c2["ring"])
        cand = [c for c in CAMPS if c["c"] == ch - 1 and c["gang"] == c2["gang"] and not c.get("king") and not c.get("bm") and not c.get("guard2") and c["ring"] >= 2]
        if not cand: raise SystemExit("[roster2] %s 搵唔到據點：第 %d 關 %s" % (k, ch, c2["gang"]))
        c = sorted(cand, key=lambda c: (abs(c["ring"] - want), c["ring"], c["id"]))[0]
        plan = c["plan"]
        cnt = {}
        for x in CAMPS:
            for i in x["plan"]: cnt[i] = cnt.get(i, 0) + 1
        # 揀頂替邊隻（唔准郁最後一隻＝原駐守）：①據點機制唔少（被頂替嗰隻嘅機制，其他成員或新鬼都有）②非駐守名鬼而且其他據點仍有出場 ③雜兵
        def ms(pl): return {m for i in pl for m in mech_of(i)}
        m0 = ms(plan)
        best = None
        for i in range(len(plan) - 1):
            pl2 = plan[:i] + [k] + plan[i + 1:]
            loss = len(m0 - ms(pl2))
            named_ok = (not is_fod(plan[i])) and cnt.get(plan[i], 0) > 1
            sc = (loss, 0 if named_ok else (1 if is_fod(plan[i]) else 2), -i)
            if best is None or sc < best[0]: best = (sc, i)
        j = best[1]
        old = plan[j]
        c["plan"] = plan[:j] + [k] + plan[j + 1:]
        if j < len(c.get("fods", [])):
            c["fods"] = c["fods"][:j] + c["fods"][j + 1:]   # 頂替咗雜兵：fods 少一隻（覆蓋補位邏輯唔再用）
        c["guard2"] = k
        out.append((k, c["id"], old))
    LOG[:] = out
    return out

def mark_src(camps, src):
    """counter.json src：guard2 嗰條標 guard＝True、co＝True（雙駐守主魂）"""
    for cid, c in camps.items():
        g2 = c.get("guard2")
        if not g2: continue
        L = src.setdefault(g2, [])
        hit = [x for x in L if x.get("t") == "camp" and x.get("id") == cid]
        if hit:
            for x in hit: x["guard"] = True; x["co"] = True
        else: L.append({"t": "camp", "id": cid, "guard": True, "co": True})

def new2():
    return {k: {"name": D["GHOSTS"][k]["name"], "sys": D["ENEMY"][k]["sys"], "sc": D["ENEMY"][k]["sc"][0], "mech": D["ENEMY"][k]["mech"],
                "ch": int(D["ENEMY"][k]["ch"]), "tags": D["ABIL"][k]["tags"], "pin": D["PIN"][k],
                "camp": next((cid for (kk, cid, _) in LOG if kk == k), "")} for k in D.get("ROSTER2", [])}
