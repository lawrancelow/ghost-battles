#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""移動村節奏模擬（按引擎實際公式：game/outpost/mv_data.gd／mv_sim.gd）

用法：python3 tools/outpost_sim.py [outpost.json] [--zero]   （--zero：每張圖由 0 冥幣開始，唔帶上張圖剩錢）

模型（每秒一步，流體近似）：
  單價   val = price × (1 + 0.1×(lv−1)) × 2^里程碑數       （引擎 MD.val）
  產量   out = base_out + floor((lv−1)/10)；時間 tm = base_time ÷ (1 + 0.02×(lv−1))
  升級   cost1 = ceil(up_cost0 × up_mul^(lv−1))；解鎖 = unlock_cost；請夥計 = 免費（派自己嘅鬼），但鬼數有限 GHOSTS[ci]
  供應   每個員工每秒 out ÷ (tm + CARRY)；冇員工嘅台當 0（假設玩家唔撳）
  需求   客人每 SPAWN 秒一個；要 1 種貨（30% 要 2 種），由「有人做緊」嘅貨平均揀；每種要 1..qmax 件，qmax = clamp(2 + 已服務/10, 2, 6)
         每種貨賣出 = min(供應, 需求份額)；等太耐（15 秒）會走 → 冇貨嘅份額當冇咗
  玩法   跟目標順序做：要解鎖／升級就儲錢；儲緊錢嗰陣如果某個升級回本快過「等夠錢」就順手升
  Boss   BOSS_SEC 秒（去巡陰打）
"""
import json, os, sys, math

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CARRY = 3.0
SPAWN = 3.1
BOSS_SEC = 480
GHOSTS = [3, 5, 7, 9, 11, 13]      # 去到第 ci 張圖時，玩家大約有幾多隻鬼可以派
MAX_T = 6 * 3600

def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    zero = "--zero" in sys.argv
    path = args[0] if args else os.path.join(ROOT, "data", "nat", "outpost.json")
    d = json.load(open(path, encoding="utf-8"))
    S, G = d["STATIONS"], d["GOODS"]
    cash = 0.0
    tot_all = 0
    ok = True
    print("== 移動村節奏（引擎公式）%s" % ("，每張圖由 0 開始" if zero else "，帶上張圖剩錢"))
    for m in d["MAPS"]:
        ci = m["ci"]
        if zero: cash = 0.0
        sids = m["stations"]
        st = {s: {"lv": 1, "w": 0, "on": S[s]["unlock_cost"] <= 0} for s in sids}
        sold = {}
        served = [0.0]
        t = 0
        def nm(s): return sum(1 for v in S[s]["miles"] if st[s]["lv"] >= v)
        def val(s, lv=None):
            lv = st[s]["lv"] if lv is None else lv
            n = sum(1 for v in S[s]["miles"] if lv >= v)
            return G[S[s]["good"]]["price"] * (1 + 0.1 * (lv - 1)) * 2 ** n
        def out(s, lv=None):
            lv = st[s]["lv"] if lv is None else lv
            return S[s]["base_out"] + (lv - 1) // 10
        def tm(s, lv=None):
            lv = st[s]["lv"] if lv is None else lv
            return S[s]["base_time"] / (1 + 0.02 * (lv - 1))
        def cost1(s): return math.ceil(S[s]["up_cost0"] * S[s]["up_mul"] ** (st[s]["lv"] - 1))
        def maxlv(s): return max(S[s]["miles"])
        def assign(force=None):
            # 鬼：force 台先滿足，其餘按單價高到低每台 1 隻，再補第 2、3 隻
            for s in st: st[s]["w"] = 0
            left = GHOSTS[min(ci, len(GHOSTS) - 1)]
            if force:
                k, n = force
                st[k]["w"] = min(n, left, 3); left -= st[k]["w"]
            on = sorted([s for s in st if st[s]["on"]], key=lambda s: -val(s))
            for rnd in range(3):
                for s in on:
                    if left > 0 and st[s]["w"] <= rnd and st[s]["w"] < 3:
                        st[s]["w"] += 1; left -= 1
        def income(lvchg=None):
            # 回傳 (每秒收入, 每種貨每秒賣出)
            act = [s for s in st if st[s]["on"] and st[s]["w"] > 0]
            if not act: return 0.0, {}
            qmax = max(2, min(6, 2 + int(served[0] / 10)))
            per_c = (1.3 if len(act) >= 2 else 1.0) * (1 + qmax) / 2.0
            dem = per_c / SPAWN
            r = 0.0; sale = {}
            for s in act:
                lv = st[s]["lv"] + (1 if lvchg == s else 0)
                sup = st[s]["w"] * out(s, lv) / (tm(s, lv) + CARRY)
                q = min(sup, dem / len(act))
                sale[S[s]["good"]] = q
                r += q * val(s, lv)
            return r, sale
        force = None
        res = []
        assign()
        for gi, g in enumerate(m["goals"]):
            t0 = t
            tt, k, n = g["t"], g["k"], g["n"]
            if tt == "hire": force = (k, n)
            if tt == "sell":
                # 要賣某種貨：確保嗰個台有人
                sk = [s for s in st if S[s]["good"] == k][0]
                force = (sk, 1)
            assign(force)
            while True:
                if tt == "boss": t += BOSS_SEC; break
                if tt == "unlock" and st[k]["on"]: break
                if tt == "level" and st[k]["lv"] >= n: break
                if tt == "hire" and st[k]["w"] >= n: break
                if tt == "sell" and sold.get(k, 0) >= n: break
                need = None
                if tt == "unlock": need = (S[k]["unlock_cost"], lambda k=k: st[k].update(on=True))
                elif tt == "level":
                    if not st[k]["on"]: need = (S[k]["unlock_cost"], lambda k=k: st[k].update(on=True))
                    else: need = (cost1(k), lambda k=k: st[k].update(lv=st[k]["lv"] + 1))
                elif tt == "hire" and not st[k]["on"]: need = (S[k]["unlock_cost"], lambda k=k: st[k].update(on=True))
                if need and cash >= need[0]:
                    cash -= need[0]; need[1](); assign(force); continue
                r, sale = income()
                wait = (need[0] - cash) / r if need and r > 0 else 1e9
                best, bv = None, 1e18
                for s in st:
                    if not st[s]["on"] or st[s]["w"] == 0 or st[s]["lv"] >= maxlv(s): continue
                    c = cost1(s)
                    if c > cash: continue
                    gain = income(s)[0] - r
                    pb = c / gain if gain > 0 else 1e18
                    if pb < bv: best, bv = s, pb
                if best and (bv < wait * 0.5 or not need):
                    cash -= cost1(best); st[best]["lv"] += 1; continue
                if r <= 0 and (not need or need[0] > cash) and tt != "sell":
                    print("   ci%d 目標 %d（%s %s）：冇收入，卡死" % (ci, gi + 1, tt, k)); ok = False; t = t0 + MAX_T; break
                cash += r; t += 1
                for gk, q in sale.items():
                    sold[gk] = sold.get(gk, 0) + q
                served[0] += sum(sale.values()) / max(1.0, (1 + max(2, min(6, 2 + int(served[0] / 10)))) / 2.0)
                if t - t0 > MAX_T: print("   ci%d 目標 %d 超過 %d 小時" % (ci, gi + 1, MAX_T // 3600)); ok = False; break
            cash += g["reward"]["coins"]
            force = None
            res.append(t - t0)
        tot = sum(res)
        tot_all += tot
        flag = ""
        if ci == 0 and res[0] > 300: flag += " ⚠第一個目標超過 5 分鐘"
        if tot < 3600 or tot > 3 * 3600: flag += " ⚠唔喺 1–3 小時"
        if flag: ok = False
        print("   ci%d %s：" % (ci, m["name"][1]) + "  ".join("%d)%s" % (i + 1, fmt(a)) for i, a in enumerate(res)) +
              "  ｜合共 %s｜剩 %s 冥幣%s" % (fmt(tot), big(cash), flag))
    print("== 全部 %s；%s" % (fmt(tot_all), "全部喺目標範圍" if ok else "有唔啱"))
    return 0 if ok else 1

def fmt(s):
    s = int(s)
    return "%dh%02dm" % (s // 3600, s % 3600 // 60) if s >= 3600 else "%dm%02ds" % (s // 60, s % 60)
def big(v):
    for u, x in (("T", 1e12), ("B", 1e9), ("M", 1e6), ("K", 1e3)):
        if v >= x: return "%.1f%s" % (v / x, u)
    return "%d" % v

if __name__ == "__main__":
    sys.exit(main())
