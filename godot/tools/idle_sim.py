#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""[idle] Idle Outpost 式升級節奏模擬：每張圖首 60 分鐘（之後繼續跑到拔營，最多 MAX_T）。

用法：python3 tools/idle_sim.py [outpost.json] [--min 60] [--zero] [--quiet]

公式同引擎一致（game/outpost/mv_data.gd、mv_idle.gd）：
  里程碑 MILES（STATIONS.miles，預設 10/25/50/100/150/200）：第 i 個雙數 = 速度 ×2、單數 = 售價 ×2；每個 +1 ★
  val = price × (1 + 0.1(lv−1)) × 2^售價里程碑 × (1 + 0.2★) × mul
  tm  = base_time ÷ (1 + 0.02(lv−1)) ÷ 2^速度里程碑 ÷ (1.25 有領班)
  out = base_out + floor((lv−1)/10)；cost1 = ceil(up_cost0 × up_mul^(lv−1))
  門檻 gate(第 i 個里程碑) = max(5, round5(GATE[i] × 4 ÷ base_time))：升過嗰級要累計產量夠數
  解鎖鏈：第 N 個台（唔計隨村台）要第 N−1 個台到 Lv10 先可以花 unlock_cost 解鎖
  供應：員工每秒 out ÷ (tm + carry)；只得領班 = 1.25 × out ÷ tm（唔使搬貨）；冇人嘅台 = 0（假設玩家唔撳）
  需求：同 tools/outpost_sim.py（客人每 3.1 秒一個、qmax 隨已服務升）；賣出 = min(供應, 需求份額)；累計產量按賣出計（保守）
  假設：材料（T1/T2）夠用（生產鏈斷料另見 tools/chain_sim.py）；鬼數 GHOSTS[ci]，先派員工（每台最多 3），有剩先做領班
  玩法：跟目標順序；目標要解鎖就先將上一個台升到 Lv10；儲錢期間如果有升級回本快過等錢就順手升
輸出：每張圖首 60 分鐘升級次數、平均幾耐升一次、最長冇得升嘅空檔、門檻等待時間、每個台幾時解鎖、拔營時間；
     「最長冇升級」包括玩家自己儲錢等解鎖；⚠卡死 = 首 60 分鐘連續超過 STALL 秒乜都買唔起（冇任何升級／解鎖負擔得起）；
     ⚠拔營唔喺 1–3.5 小時。
"""
import json, math, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MILES = [10, 25, 50, 100, 150, 200]
GATE = [10, 120, 500, 2000, 6000, 15000]
Q_VAL = 0.2
FORE = 1.25
UNLOCK_LV = 10
WALK_W, PICK_S = 240.0, 0.6
SPAWN = 3.1
BOSS_SEC = 480
GHOSTS = [3, 5, 7, 9, 11, 13]
MAX_T = 5 * 3600
STALL = 600

def carry_s(L, sid):
    e = L["st"][sid]; rd = L["road"]; j = L["j"]; ri = e[2]
    pts = [(e[0], e[1] + 30)]
    i = ri
    while True:
        pts.append(tuple(rd[i]))
        if i == j: break
        i += -1 if ri >= j else 1
    pts.append((L["counter"][0], L["counter"][1] - 30))
    d = sum(math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in zip(pts, pts[1:]))
    return 2.0 * d / WALK_W + PICK_S

def fmt(s):
    s = int(s)
    return "%dh%02dm" % (s // 3600, s % 3600 // 60) if s >= 3600 else "%dm%02ds" % (s // 60, s % 60)
def big(v):
    for u, x in (("T", 1e12), ("B", 1e9), ("M", 1e6), ("K", 1e3)):
        if v >= x: return "%.1f%s" % (v / x, u)
    return "%d" % v

def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    zero = "--zero" in sys.argv
    quiet = "--quiet" in sys.argv
    mins = 60
    if "--min" in sys.argv: mins = int(sys.argv[sys.argv.index("--min") + 1])
    path = args[0] if args else os.path.join(ROOT, "data", "nat", "outpost.json")
    d = json.load(open(path, encoding="utf-8"))
    C = json.load(open(os.path.join(ROOT, "data", "nat", "chain.json"), encoding="utf-8"))
    CARRY = C.get("CARRY", [])
    S, G = d["STATIONS"], d["GOODS"]
    cash = 0.0; ok = True; tot_all = 0
    print("== Idle Outpost 式升級節奏（首 %d 分鐘＋跑到拔營）%s" % (mins, "，每張圖由 0 開始" if zero else "，帶上張圖剩錢"))
    for m in d["MAPS"]:
        ci = m["ci"]; mul = m.get("mul", 1.0)
        if zero: cash = 0.0
        sids = m["stations"]
        chain = [s for s in sids if s not in CARRY]
        CAR = {s: carry_s(m["layout"], s) for s in sids}
        st = {s: {"lv": 1, "w": 0, "f": 0, "made": 0.0, "on": S[s]["unlock_cost"] <= 0} for s in sids}
        if chain: st[chain[0]]["on"] = True
        sold = {}; served = [0.0]; t = 0
        log = {"up": [], "unl": {}, "gate_wait": 0.0, "events": [0], "poor": 0, "poor_max": 0}
        def miles(s): return sorted(S[s].get("miles", MILES))
        def kind(s, i): return "spd" if i % 2 == 0 else "val"
        def nk(s, lv, k): return sum(1 for i, v in enumerate(miles(s)) if lv >= v and kind(s, i) == k)
        def stars(s, lv): return sum(1 for v in miles(s) if lv >= v)
        def val(s, lv=None):
            lv = st[s]["lv"] if lv is None else lv
            return G[S[s]["good"]]["price"] * (1 + 0.1 * (lv - 1)) * 2 ** nk(s, lv, "val") * (1 + Q_VAL * stars(s, lv)) * mul
        def out(s, lv=None):
            lv = st[s]["lv"] if lv is None else lv
            return S[s]["base_out"] + (lv - 1) // 10
        def tm(s, lv=None):
            lv = st[s]["lv"] if lv is None else lv
            return S[s]["base_time"] / (1 + 0.02 * (lv - 1)) / 2 ** nk(s, lv, "spd") / (FORE if st[s]["f"] else 1.0)
        def gate(s, mi):
            i = miles(s).index(mi)
            return max(5, int(round(GATE[min(i, len(GATE) - 1)] * 4.0 / max(0.5, S[s]["base_time"]) / 5.0)) * 5)
        def cap(s):
            for v in miles(s):
                if v > st[s]["lv"] and st[s]["made"] < gate(s, v): return v - 1
            return max(miles(s))
        def cost1(s): return math.ceil(S[s]["up_cost0"] * S[s]["up_mul"] ** (st[s]["lv"] - 1))
        def chain_ok(s):
            if s not in chain or chain.index(s) == 0: return True
            p = chain[chain.index(s) - 1]
            return st[p]["on"] and st[p]["lv"] >= UNLOCK_LV
        def assign(force=None):
            for s in st: st[s]["w"] = 0; st[s]["f"] = 0
            left = GHOSTS[min(ci, len(GHOSTS) - 1)]
            if force:
                k, n = force
                if st[k]["on"]: st[k]["w"] = min(n, left, 3); left -= st[k]["w"]
            on = sorted([s for s in st if st[s]["on"]], key=lambda s: -val(s))
            for rnd in range(3):
                for s in on:
                    if left > 0 and st[s]["w"] <= rnd and st[s]["w"] < 3:
                        st[s]["w"] += 1; left -= 1
            for s in on:   # 有剩：做領班
                if left > 0: st[s]["f"] = 1; left -= 1
        def income(lvchg=None):
            act = [s for s in st if st[s]["on"] and (st[s]["w"] > 0 or st[s]["f"])]
            if not act: return 0.0, {}
            qmax = max(2, min(6, 2 + int(served[0] / 10)))
            per_c = (1.3 if len(act) >= 2 else 1.0) * (1 + qmax) / 2.0
            dem = per_c / SPAWN
            r = 0.0; sale = {}
            for s in act:
                lv = st[s]["lv"] + (1 if lvchg == s else 0)
                if st[s]["w"] > 0: sup = st[s]["w"] * out(s, lv) / (tm(s, lv) + CAR[s])
                else: sup = out(s, lv) / tm(s, lv)
                q = min(sup, dem / len(act))
                sale[s] = q
                r += q * val(s, lv)
            return r, sale
        def ev(kind_, s=None):
            log["events"].append(t)
            if kind_ == "up": log["up"].append(t)
            if kind_ == "unl": log["unl"][s] = t
        force = None; res = []
        assign()
        for gi, g in enumerate(m["goals"]):
            t0 = t
            tt, k, n = g["t"], g["k"], g["n"]
            if tt == "hire": force = (k, n)
            if tt == "sell": force = ([s for s in st if S[s]["good"] == k][0], 1)
            assign(force)
            while True:
                if tt == "boss": t += BOSS_SEC; ev("goal"); break
                if tt == "unlock" and st[k]["on"]: break
                if tt == "level" and st[k]["lv"] >= n: break
                if tt == "hire" and st[k]["w"] >= n: break
                if tt == "sell" and sold.get(k, 0) >= n: break
                need = None; gated = False
                tgt = k if tt in ("unlock", "level", "hire") else None
                if tgt and not st[tgt]["on"]:
                    if chain_ok(tgt):
                        need = (S[tgt]["unlock_cost"], lambda s=tgt: (st[s].update(on=True), ev("unl", s)))
                    else:
                        # 解鎖鏈：先將鏈上最早一個未夠 Lv10 嘅台升級（或者解鎖）
                        for p in chain[:chain.index(tgt)]:
                            if not st[p]["on"]:
                                if chain_ok(p): need = (S[p]["unlock_cost"], lambda s=p: (st[s].update(on=True), ev("unl", s)))
                                break
                            if st[p]["lv"] < UNLOCK_LV:
                                if cap(p) > st[p]["lv"]: need = (cost1(p), lambda s=p: (st[s].update(lv=st[s]["lv"] + 1), ev("up")))
                                else: gated = True
                                break
                elif tt == "level":
                    if cap(k) > st[k]["lv"]: need = (cost1(k), lambda k=k: (st[k].update(lv=st[k]["lv"] + 1), ev("up")))
                    else: gated = True
                if need and cash >= need[0]:
                    cash -= need[0]; need[1](); assign(force); continue
                r, sale = income()
                wait = (need[0] - cash) / r if need and r > 0 else 1e9
                best, bv = None, 1e18
                for s in st:
                    if not st[s]["on"] or (st[s]["w"] == 0 and not st[s]["f"]) or st[s]["lv"] >= cap(s): continue
                    c = cost1(s)
                    if c > cash: continue
                    gain = income(s)[0] - r
                    pb = c / gain if gain > 0 else 1e18
                    if pb < bv: best, bv = s, pb
                if best and (bv < wait * 0.5 or not need):
                    cash -= cost1(best); st[best]["lv"] += 1; ev("up"); continue
                # 冇嘢可以升又冇收入 → 卡死
                if r <= 0 and (not need or need[0] > cash) and tt != "sell":
                    print("   ci%d 目標 %d（%s %s）：冇收入，卡死" % (ci, gi + 1, tt, k)); ok = False; t = t0 + MAX_T; break
                cash += r; t += 1
                if gated: log["gate_wait"] += 1
                # 「冇嘢買得起」：所有開咗嘅台（未封頂／未卡門檻）升 1 級都唔夠錢，亦冇台解鎖得 → 真係只可以等
                cands = [cost1(s) for s in st if st[s]["on"] and st[s]["lv"] < cap(s)] + \
                        [S[s]["unlock_cost"] for s in st if not st[s]["on"] and chain_ok(s)]
                if t <= mins * 60:
                    if not cands or cash < min(cands): log["poor"] += 1; log["poor_max"] = max(log["poor_max"], log["poor"])
                    else: log["poor"] = 0
                for s, q in sale.items():
                    sold[S[s]["good"]] = sold.get(S[s]["good"], 0) + q
                    st[s]["made"] += q
                served[0] += sum(sale.values()) / max(1.0, (1 + max(2, min(6, 2 + int(served[0] / 10)))) / 2.0)
                if t - t0 > MAX_T: print("   ci%d 目標 %d 超過 %d 小時" % (ci, gi + 1, MAX_T // 3600)); ok = False; break
            cash += g["reward"]["coins"]; ev("goal")
            force = None
            res.append(t - t0)
        # 冇目標帶去開嘅台（例如第 5、6 張圖第 7 台）：目標做齊之後，按最後收入估要再等幾耐先解鎖到
        r_end = income()[0]; extra = []
        for s_ in chain:
            if not st[s_]["on"]:
                extra.append("%s 要再等 %s" % (S[s_]["n"][1], fmt(max(0.0, S[s_]["unlock_cost"] - cash) / r_end) if r_end > 0 else "∞"))
        tot = sum(res); tot_all += tot
        T = mins * 60
        ups = [x for x in log["up"] if x <= T]
        evs = sorted(set([x for x in log["events"] if x <= T] + [T]))
        gap = max(b - a for a, b in zip(evs, evs[1:])) if len(evs) > 1 else T
        flag = ""
        if log["poor_max"] > STALL: flag += " ⚠首 %d 分鐘有 %s 乜都買唔起（卡死）" % (mins, fmt(log["poor_max"]))
        if tot < 3600 or tot > 3.5 * 3600: flag += " ⚠拔營唔喺 1–3.5 小時"
        if flag: ok = False
        unl = "、".join("%s@%s" % (S[s]["n"][1], fmt(log["unl"][s])) for s in chain if s in log["unl"])
        lv10 = []
        print("   ci%d %s（%d 台＋隨村 %d）：首 %d 分鐘升 %d 次（平均 %s 一次）、最長冇升級 %s（其中乜都買唔起最長 %s）、門檻等待 %s｜拔營 %s｜剩 %s%s" % (
            ci, m["name"][1], len(chain), len(sids) - len(chain), mins, len(ups), fmt(T / max(1, len(ups))), fmt(gap), fmt(log["poor_max"]),
            fmt(log["gate_wait"]), fmt(tot), big(cash), flag))
        if not quiet:
            print("      解鎖：" + (unl or "（全部開局已開）") + ("；目標做齊後：" + "、".join(extra) if extra else ""))
            print("      目標用時：" + "  ".join("%d)%s" % (i + 1, fmt(a)) for i, a in enumerate(res)))
            print("      等級：" + "  ".join("%s Lv%d★%d 累計%s" % (S[s]["n"][1], st[s]["lv"], stars(s, st[s]["lv"]), big(st[s]["made"])) for s in sids if st[s]["on"]))
    print("== 全部拔營合共 %s；%s" % (fmt(tot_all), "全部喺目標範圍" if ok else "有唔啱"))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
