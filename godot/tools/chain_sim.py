#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生產鏈獨立驗算：每張圖模擬 30 分鐘，報告每個台嘅開工率、斷料比例、每分鐘收入。

用法：python3 tools/chain_sim.py [--min 30] [--stock 0] [--quiet]

讀 data/nat/chain.json（配方、村子建築）＋ data/nat/outpost.json（台時間、價錢、版面、客人）。
公式同引擎一致（game/outpost/mv_data.gd）：
  台每轉 tm(lv) = base_time ÷ (1 + 0.02(lv−1))；每轉出 out(lv) = base_out + floor((lv−1)/10) 件；
  搬貨 carry_s = 2 × 路線長 ÷ 240 + 0.6（路線由 layout 計）；單價 val = price × (1 + 0.1(lv−1)) × 2^里程碑
  配方（chain.json RULES）：每轉開工前扣 in × out(lv) ÷ n；唔夠就等（斷料）；出咗嘅貨放返共用倉（櫃台），
  上層台由倉攞料，客人亦由倉買。倉每種貨最多 COUNTER_CAP 件（滿咗台就停：「滿倉」，唔當斷料）。
  村子：GATHER 每鬼每分鐘 rate × (1 + 0.15(lv−1))；WORKSHOPS 每鬼每批 time ÷ (1 + 0.10(lv−1)) 秒；新材料上限 cap。
假設（ASSUME，「合理」中段玩家；全部寫明喺報告頭）：
  - 村子：已解鎖（unlock.ci ≤ 呢張圖）嘅每間建築派 VIL_W 隻鬼、等級 VIL_LV[ci]；開局倉 --stock（預設 0，最嚴）
  - 移動村：每個台 ST_W 個員工；等級按台喺本圖嘅次序 ST_LV[ci][j]（越後開越低級），隨村台 CARRY_LV[ci]
  - 客人：每 SPAWN 秒一個（排隊最多 4 個），喺本圖客人入面揀「倉有貨或者有人做緊」嘅；每種要 1..QMAX 件，30% 要兩種；
    等 PATIENCE 秒，買到幾多付幾多就走
  - 次序：每一步先畀台攞料（生產鏈優先），再畀客人買
"""
import json, math, os, random, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = lambda *a: os.path.join(ROOT, *a)

VIL_W = 1
VIL_W_OLD = 2          # 舊建築（伐木場、糯米田、棺材鋪、包子鋪）本身有幾個崗位：當 2 隻鬼
VIL_LV = [3, 5, 7, 9, 11, 13]
ST_W = 3
ST_LV = [[30, 28, 25, 22, 20, 18], [32, 30, 27, 25, 22, 20], [34, 32, 30, 27, 25, 22],
         [36, 34, 32, 30, 27, 25], [38, 36, 34, 32, 30, 27], [40, 38, 36, 34, 32, 30]]
CARRY_LV = [30, 30, 32, 34, 36, 38]
SPAWN = 3.1
QMAX = 4
PATIENCE = 15.0
QUEUE_MAX = 4
COUNTER_CAP = 40
WALK_W, PICK_S = 240.0, 0.6
DT = 0.25

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

def fmt(v):
    for u, x in (("T", 1e12), ("B", 1e9), ("M", 1e6), ("K", 1e3)):
        if abs(v) >= x: return "%.1f%s" % (v / x, u)
    return "%.0f" % v

def sim_map(C, O, m, minutes, stock0, quiet):
    ci = m["ci"]
    ST, GO, CU = O["STATIONS"], O["GOODS"], {c["id"]: c for c in O["CUSTOMERS"]}
    R, M, CARRY = C["RECIPES"], C["MATS"], C["CARRY"]
    rnd = random.Random(1000 + ci)
    sids = m["stations"]
    own = [s for s in sids if ci == 0 or s not in CARRY]
    lv = {}
    for j, s in enumerate(own): lv[s] = ST_LV[ci][min(j, len(ST_LV[ci]) - 1)]
    for s in sids:
        if s in CARRY and s not in lv: lv[s] = CARRY_LV[ci]
    car = {s: carry_s(m["layout"], s) for s in sids}
    def tm(s): return ST[s]["base_time"] / (1 + 0.02 * (lv[s] - 1))
    def out(s): return ST[s]["base_out"] + (lv[s] - 1) // 10
    def val(s):
        n = sum(1 for x in ST[s]["miles"] if lv[s] >= x)
        return GO[ST[s]["good"]]["price"] * (1 + 0.1 * (lv[s] - 1)) * 2 ** n
    good_st = {ST[s]["good"]: s for s in sids}
    pool = {k: float(stock0) for k in M}
    for k in good_st: pool[k] = 0.0
    cap = {k: (M[k].get("cap") or 1e12) for k in M}
    for k in good_st: cap[k] = COUNTER_CAP
    # 村子
    vil = []
    for bid, b in C["GATHER"].items():
        if b["unlock"]["ci"] <= ci:
            vil.append({"id": bid, "k": "g", "out": b["out"], "rate": b["rate"] * (1 + 0.15 * (VIL_LV[ci] - 1)) * (VIL_W_OLD if b.get("old") else VIL_W) / 60.0,
                        "made": 0.0, "full": 0.0, "t": 0.0})
    for bid, b in C["WORKSHOPS"].items():
        if b["unlock"]["ci"] <= ci:
            vil.append({"id": bid, "k": "w", "in": b["in"], "out": b["out"], "time": b["time"] / (1 + 0.10 * (VIL_LV[ci] - 1)),
                        "w": [{"st": "idle", "t": 0.0} for _ in range(VIL_W_OLD if b.get("old") else VIL_W)], "made": 0.0, "wait": 0.0, "full": 0.0, "work": 0.0})
    # 台員工
    W = []
    for s in sids:
        for i in range(ST_W):
            W.append({"s": s, "st": "idle", "t": rnd.random() * 0.5, "carry": 0})
    stat = {s: {"work": 0.0, "wait": 0.0, "full": 0.0, "made": 0.0, "sold": 0.0, "used": 0.0, "rev": 0.0, "lack": {}} for s in sids}
    custs = []
    spawn_t = 1.0
    T = minutes * 60.0
    t = 0.0
    served = 0
    lost = 0.0
    while t < T:
        # 村子採集
        for v in vil:
            if v["k"] != "g": continue
            o = v["out"]
            if pool[o] < cap[o]:
                pool[o] = min(cap[o], pool[o] + v["rate"] * DT); v["made"] += v["rate"] * DT
            else: v["full"] += DT
        # 攞料：村子加工鬼同台員工每一步亂序（唔偏幫邊個）
        order = [("v", v, w) for v in vil if v["k"] == "w" for w in v["w"]] + [("s", None, w) for w in W]
        rnd.shuffle(order)
        for kind, v, w in order:
            if kind == "v":
                if True:
                    if w["st"] == "work":
                        w["t"] -= DT; v["work"] += DT
                        if w["t"] <= 0:
                            for k, q in v["out"].items():
                                pool[k] = min(cap[k], pool[k] + q); v["made"] += q
                            w["st"] = "idle"
                    if w["st"] == "idle":
                        if any(pool[k] >= cap[k] for k in v["out"]): v["full"] += DT; continue
                        if all(pool[k] >= q for k, q in v["in"].items()):
                            for k, q in v["in"].items(): pool[k] -= q
                            w["st"] = "work"; w["t"] = v["time"]
                        else: v["wait"] += DT
                continue
            s = w["s"]; S = stat[s]
            if w["st"] == "work":
                w["t"] -= DT; S["work"] += DT
                if w["t"] <= 0: w["st"] = "carry"; w["t"] = car[s]
                continue
            if w["st"] == "carry":
                w["t"] -= DT; S["work"] += DT
                if w["t"] <= 0:
                    g = ST[s]["good"]; pool[g] = min(cap[g], pool[g] + w["carry"]); S["made"] += w["carry"]
                    w["st"] = "idle"
                continue
            g = ST[s]["good"]
            if pool[g] >= cap[g]: S["full"] += DT; continue
            k = out(s); r = R[s]
            need = {mid: q * k / r["n"] for mid, q in r["in"].items()}
            short = [mid for mid, q in need.items() if pool[mid] + 1e-9 < q]
            if short:
                S["wait"] += DT
                for mid in short: S["lack"][mid] = S["lack"].get(mid, 0) + DT
                continue
            for mid, q in need.items():
                pool[mid] -= q
                if mid in good_st: stat[good_st[mid]]["used"] += q
            w["st"] = "work"; w["t"] = tm(s); w["carry"] = k
        # 客人
        spawn_t -= DT
        if spawn_t <= 0:
            spawn_t = rnd.uniform(2.2, 4.0)
            if len(custs) < QUEUE_MAX:
                active = {ST[w["s"]]["good"] for w in W if w["st"] != "idle"} | {g for g in good_st if pool[g] >= 1}
                cands = []
                for cid in m["customers"]:
                    ok = [g for g in CU[cid]["wants"] if g in active]
                    if ok: cands.append(ok)
                if cands:
                    ok = list(rnd.choice(cands))
                    ng = 2 if len(ok) >= 2 and rnd.random() < 0.3 else 1
                    want = {}
                    for _ in range(ng):
                        g = rnd.choice(ok); ok.remove(g); want[g] = 1 + rnd.randrange(QMAX)
                    custs.append({"want": want, "got": {}, "t": 0.0})
        if custs:
            c = custs[0]
            c["t"] += DT
            for g, q in c["want"].items():
                h = c["got"].get(g, 0)
                if h < q and pool[g] >= 1:
                    n = min(q - h, int(pool[g])); pool[g] -= n; c["got"][g] = h + n
            done = all(c["got"].get(g, 0) >= q for g, q in c["want"].items())
            if done or c["t"] >= PATIENCE:
                for g, n in c["got"].items():
                    s = good_st[g]; stat[s]["sold"] += n; stat[s]["rev"] += n * val(s)
                lost += sum(q - c["got"].get(g, 0) for g, q in c["want"].items())
                served += 1
                custs.pop(0)
        t += DT
    tot_rev = sum(x["rev"] for x in stat.values())
    res = {"ci": ci, "rev_min": tot_rev / minutes, "rows": [], "vil": [], "served": served, "lost": lost}
    for s in sids:
        S = stat[s]; tt = T * ST_W
        res["rows"].append({"s": s, "lv": lv[s], "busy": S["work"] / tt, "wait": S["wait"] / tt, "full": S["full"] / tt,
                            "made": S["made"], "sold": S["sold"], "used": S["used"], "rev_min": S["rev"] / minutes,
                            "lack": sorted(S["lack"].items(), key=lambda x: -x[1])[:2], "carry": car[s], "tm": tm(s)})
    for v in vil:
        tt = T * (len(v["w"]) if v["k"] == "w" else 1)
        res["vil"].append({"id": v["id"], "made": v["made"], "wait": v.get("wait", 0) / tt, "full": v["full"] / tt})
    res["pool"] = {k: pool[k] for k in pool if pool[k] >= 1}
    return res

def main():
    args = sys.argv[1:]
    minutes = float(args[args.index("--min") + 1]) if "--min" in args else 30.0
    stock0 = float(args[args.index("--stock") + 1]) if "--stock" in args else 0.0
    quiet = "--quiet" in args
    C = json.load(open(P("data", "nat", "chain.json"), encoding="utf-8"))
    O = json.load(open(P("data", "nat", "outpost.json"), encoding="utf-8"))
    names = {sid: s["n"][1] for sid, s in O["STATIONS"].items()}
    bn = {k: v["n"][1] for k, v in list(C["GATHER"].items()) + list(C["WORKSHOPS"].items())}
    mn = {k: v["n"][1] for k, v in C["MATS"].items()}
    print("== 生產鏈驗算：每張圖 %d 分鐘；村子新建築每間 %d 鬼、舊建築 %d 鬼（等級 %s）；每台 %d 員工；開局倉 %d" % (minutes, VIL_W, VIL_W_OLD, VIL_LV, ST_W, stock0))
    bad = 0
    for m in O["MAPS"]:
        r = sim_map(C, O, m, minutes, stock0, quiet)
        print("\n-- ci%d %s：每分鐘收入 %s；服務客人 %d；客人買唔到 %.0f 件" % (r["ci"], m["name"][1], fmt(r["rev_min"]), r["served"], r["lost"]))
        print("   %-14s %3s %6s %6s %6s %7s %7s %7s %9s  %s" % ("台", "級", "開工", "斷料", "滿倉", "出貨", "賣出", "畀上層", "收入/分", "最缺"))
        for x in r["rows"]:
            flag = ""
            # 斷料超過 25% 當要調；隨村台喺後面張圖主要做料（滿倉正常）
            if x["wait"] > 0.25: flag = " ⚠斷料"; bad += 1
            elif x["busy"] < 0.35 and x["full"] < 0.3: flag = " ⚠開工低"; bad += 1
            lack = "、".join("%s %.0f%%" % (mn[k], 100 * v / (minutes * 60 * ST_W)) for k, v in x["lack"])
            print("   %-14s %3d %5.0f%% %5.0f%% %5.0f%% %7.0f %7.0f %7.0f %9s  %s%s" % (
                names[x["s"]], x["lv"], 100 * x["busy"], 100 * x["wait"], 100 * x["full"], x["made"], x["sold"], x["used"],
                fmt(x["rev_min"]), lack, flag))
        if not quiet:
            print("   村子：" + "；".join("%s 出 %.0f%s" % (bn[v["id"]], v["made"],
                  ("（等料 %.0f%%）" % (100 * v["wait"]) if v["wait"] > 0.05 else "") + ("（滿倉 %.0f%%）" % (100 * v["full"]) if v["full"] > 0.05 else ""))
                  for v in r["vil"]))
    print("\n== 結果：%s" % ("全部台斷料 ≤25%、開工率合理" if not bad else "%d 個台要調" % bad))
    return 1 if bad else 0

if __name__ == "__main__":
    sys.exit(main())
