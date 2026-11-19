#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""[play] 玩法線數值模擬：詭異事件／委託單／大客／夜潮嘅頻率，同埋三種玩家嘅收入比較。

用法：python3 tools/play_sim.py [--runs 400] [--min 60] [--quiet]

計時規則同引擎一致（game/outpost/mv_plus.gd、mv_event.gd、mv_cust.gd；play.json 每張圖權重）：
  夜潮：每張圖在線 TIDE_FIRST 秒（第 1 張圖 = 新手保護 600 秒）後入夜；之後 夜 120 秒 / 白晝 300 秒循環
  事件：第一件 75 秒；之後 100–160 秒（夜潮間隔 ×0.7）；一件未完唔出下一件（壽命：事件各自）
  委託單：第一張 90 秒；之後 150–270 秒（白晝間隔 ×0.8；夜潮唔出）；同時 1 張；限時 180–600 秒
收入模型（以「冇呢套系統」嘅每秒收入 = 1 做單位，生意受供應限住）：
  客人每 3.1 秒一個（夜潮 ×1.5），每個客人價值 = 3.1 秒收入；脾氣擲骰照 play.json；
  三種玩家：
    off     ＝ 冇呢套系統（基準 1.0）
    idle    ＝ 開住唔撳：講價當唔減、插隊收 ×1.3、走數有守夜／義勇軍 50% 捉到（假設一半時間有守）、
              挑剔一半夠星（×1.8／×0.6）、熟客 ×1.25（熟客度 12 之後 35%）、事件全部用「唔理」結果、委託單過期（影響力 −3 ≈ 5 秒收入）
    active  ＝ 認真撳（反應 3 秒內）：捉晒走數、扮客撳現形、紙錢雨執 6 張、匯率跌囤貨、大客做晒、委託單做晒、招牌菜每 4 分鐘一份
  事件價值（秒收入；n = 呢張圖平均開咗嘅台數）：見 EV_VAL。委託單淨賺 = 1 × 貨值（90 秒單台產量 ÷ n）＋特別獎約 10 秒。
  夜潮：收入 ×1.1（價）× 1.05（客多但受供應限）。羈絆：idle +3%、active +10%（自己揀啱手鬼）。
輸出：每張圖 60 分鐘：事件／大單／大客次數、「值得撳」平均間隔、最長空檔、三種玩家收入比（目標：idle ≥ 0.92、active 1.15–1.30）。
"""
import json, os, random, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TIDE_FIRST, TIDE_DAY, TIDE_NIGHT, NEWBIE = 300.0, 300.0, 120.0, 600.0
EV_FIRST, EV_MIN, EV_MAX, EV_NIGHT = 75.0, 100.0, 160.0, 0.7
ORD_FIRST, ORD_MIN, ORD_MAX, ORD_DAY = 90.0, 180.0, 300.0, 0.8
EV_W = {"self": 16, "rate_up": 10, "rate_down": 10, "fake": 14, "rain": 14, "doze": 12, "parcel": 10, "special": 14}
EV_LIFE = {"self": 30, "rate_up": 45, "rate_down": 15, "fake": 40, "rain": 10, "doze": 40, "parcel": 30, "special": 30}
SPAWN = 3.1
REG_N, REG_P, REG_TIP = 12, 0.3, 1.1
CATCH, RATE_UP, RAIN_SEC, ORD_NET, SIGN_NET = 1.5, 1.3, 3.0, 0.5, 0.8
NIGHT_REV = 1.0 * 1.05

def ev_val(k, n, active):
    """事件對收入嘅影響（單位：秒收入）"""
    if active:
        return {"self": 3 * 6.0 / n * 1.0, "rate_up": 60 * (RATE_UP - 1), "rate_down": 30 * 0.3, "fake": 0.5, "rain": 6 * RAIN_SEC,
                "doze": -2.0, "parcel": 5.0, "special": 8.0}[k]
    return {"self": 1 * 6.0 / n, "rate_up": 45 * (RATE_UP - 1), "rate_down": -45 * 0.25, "fake": -SPAWN, "rain": 0.0,
            "doze": -40.0 / max(1.0, 1.5 * n), "parcel": 0.0, "special": 0.0}[k]

def tide(t, first):
    if t < first: return False
    return (t - first) % (TIDE_DAY + TIDE_NIGHT) < TIDE_NIGHT

def run_map(ci, tempers, n_st, mins, rng, guard_p=0.5):
    first = max(TIDE_FIRST, NEWBIE) if ci == 0 else TIDE_FIRST
    T = int(mins * 60)
    ev_t, ord_t = EV_FIRST, ORD_FIRST
    ev = None; order = None
    taps = []  # 值得撳嘅時刻
    cnt = {"ev": 0, "ord": 0, "special": 0, "night": 0, "cust": 0}
    inc = {"off": 0.0, "idle": 0.0, "active": 0.0}
    fam = 0.0; cids = 10
    spawn = 0.0; was_night = False
    wt = sum(tempers.values())
    for t in range(T):
        night = tide(t, first)
        if night and not was_night: cnt["night"] += 1; taps.append(t)
        was_night = night
        rev = NIGHT_REV if night else 1.0
        inc["off"] += 1.0
        inc["idle"] += rev * 1.03
        inc["active"] += rev * 1.05
        # 客人（只計脾氣差額；每個客人 = 3.1 秒收入）
        spawn -= 1.0 * (1.5 if night else 1.0)
        while spawn <= 0:
            spawn += SPAWN
            cnt["cust"] += 1
            fam += 1.0 / cids
            if fam >= REG_N and rng.random() < REG_P: tp = "reg"
            else:
                r = rng.random() * wt * (1.0 if not night else 1.0)
                tp = "none"
                for k, w in tempers.items():
                    w2 = w * (2 if (night and k == "dash") else 1)
                    r -= w2
                    if r <= 0: tp = k; break
            v = SPAWN
            idle_m = {"none": 1, "haggle": 1, "cut": 1.2, "dash": guard_p * 0.5 * CATCH, "picky": 0.5 * 1.8 + 0.5 * 0.6, "reg": REG_TIP}[tp]
            act_m = {"none": 1, "haggle": 1, "cut": 1.2, "dash": CATCH, "picky": 0.5 * 1.8 + 0.5 * 1.0 - 0.1, "reg": REG_TIP}[tp]
            inc["idle"] += (idle_m - 1.0) * v
            inc["active"] += (act_m - 1.0) * v
            if tp == "dash": taps.append(t)
        # 事件
        if ev:
            ev["t"] += 1
            if ev["t"] >= EV_LIFE[ev["k"]]: ev = None
        else:
            ev_t -= 1.0 / (EV_NIGHT if night else 1.0)
            if ev_t <= 0:
                ev_t = rng.uniform(EV_MIN, EV_MAX)
                tot = sum(EV_W.values()); r = rng.random() * tot; k = "self"
                for kk, w in EV_W.items():
                    r -= w
                    if r <= 0: k = kk; break
                ev = {"k": k, "t": 0}; cnt["ev"] += 1; taps.append(t)
                if k == "special": cnt["special"] += 1
                inc["idle"] += ev_val(k, n_st, False)
                inc["active"] += ev_val(k, n_st, True)
        # 委託單
        if order:
            order["left"] -= 1
            if order["left"] <= 0:
                order = None
        if not night:
            ord_t -= 1.0 / ORD_DAY
            if ord_t <= 0:
                ord_t = rng.uniform(ORD_MIN, ORD_MAX)
                if order is None:
                    order = {"left": rng.uniform(180, 600)}; cnt["ord"] += 1; taps.append(t)
                    goods = 90.0 / n_st
                    inc["active"] += goods * ORD_NET + 10.0
                    inc["idle"] -= 5.0
                    order = None if rng.random() < 0.0 else order
                    order["left"] = min(order["left"], 200)   # active 交完就走；idle 過期
        # 招牌菜（active）
        if t > 900 and t % 240 == 0: inc["active"] += 15.0 * SIGN_NET
    taps = sorted(set(taps))
    worth = [x for x in taps]
    gaps = [b - a for a, b in zip([0] + worth, worth + [T])]
    return cnt, inc, gaps

def main():
    runs = 400
    if "--runs" in sys.argv: runs = int(sys.argv[sys.argv.index("--runs") + 1])
    mins = 60
    if "--min" in sys.argv: mins = int(sys.argv[sys.argv.index("--min") + 1])
    P = json.load(open(os.path.join(ROOT, "data", "nat", "play.json"), encoding="utf-8"))
    O = json.load(open(os.path.join(ROOT, "data", "nat", "outpost.json"), encoding="utf-8"))
    C = json.load(open(os.path.join(ROOT, "data", "nat", "chain.json"), encoding="utf-8"))
    rng = random.Random(20261120)
    ok = True
    print("== 玩法線數值模擬：每張圖在線 %d 分鐘 × %d 次（平均）" % (mins, runs))
    print("圖 | 事件 | 大單 | 大客 | 夜潮 | 走數 | 事件＋大單平均間隔 | 最長空檔(平均/最差) | idle 收入比 | active 收入比")
    for m in P["MAPS"]:
        ci = m["ci"]
        om = next(x for x in O["MAPS"] if x["ci"] == ci)
        n_st = max(2.0, len([s for s in om["stations"] if s not in C.get("CARRY", [])]) * 0.6 + 2)
        agg = {"ev": 0, "ord": 0, "special": 0, "night": 0}
        gi = ga = 0.0; gmax_avg = 0.0; gmax = 0; ri = ra = 0.0; dash = 0.0; mean_gap = 0.0
        for r in range(runs):
            cnt, inc, gaps = run_map(ci, m["tempers"], n_st, mins, rng)
            for k in agg: agg[k] += cnt[k]
            ri += inc["idle"] / inc["off"]; ra += inc["active"] / inc["off"]
            mg = max(gaps); gmax_avg += mg; gmax = max(gmax, mg)
            dash += cnt["cust"] * m["tempers"]["dash"] / sum(m["tempers"].values())
            evs = [g for g in gaps]
            mean_gap += mins * 60.0 / max(1, cnt["ev"] + cnt["ord"])
        n = float(runs)
        ri /= n; ra /= n
        line = "%d %s | %.1f | %.1f | %.1f | %.1f | %.0f | %.0f 秒 | %.0f / %d 秒 | %.3f | %.3f" % (ci + 1, om["name"][1], agg["ev"] / n, agg["ord"] / n, agg["special"] / n,
            agg["night"] / n, dash / n, mean_gap / n, gmax_avg / n, gmax, ri, ra)
        warn = []
        if not (120 <= mins * 60.0 / max(1.0, agg["ev"] / n) <= 240): warn.append("⚠詭異事件間隔唔喺 2–4 分鐘")
        if gmax_avg / n > 300: warn.append("⚠平均最長空檔 > 5 分鐘")
        if not (0.92 <= ri <= 1.08): warn.append("⚠唔撳收入唔喺 0.92–1.08")
        if not (1.15 <= ra <= 1.30): warn.append("⚠認真撳唔喺 +15–30%")
        if warn: ok = False
        print(line + ("  " + " ".join(warn) if warn else ""))
    print("拔營時間影響（收入主導嘅升級節奏，tools/idle_sim.py 基準）：idle 約 ÷ idle 收入比、active 約 ÷ active 收入比（≤ 快 30%）")
    print("結果：" + ("全部達標" if ok else "有唔達標（見 ⚠）"))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
