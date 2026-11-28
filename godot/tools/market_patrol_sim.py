#!/usr/bin/env python3
"""過勞鬼市集：巡邏隊 0–4 隻的長時間蒙地卡羅（規則同 mk_ops.gd＋M2 巡邏員過勞）。
輸出每種人數在不同人流下的事件處理率、每 10 分鐘漏網件數、估算事件損失（佔該街收入 %，受 15% 上限）。
用法：python3 tools/market_patrol_sim.py [小時數=50]
規則：每件事件逐個隊員追、每人只追一次、每次 4 秒、成功率 通用 45%／特色 30%（特色佔 40%）；20 秒沒人擺平就結算損失。
      巡邏員每處理一件過勞 +15×(1−0.1×(隊員數−1))，滿 100 趴下 60 秒，閒時每秒 −1（M2 mk_fun 數值）。
      單件損失估算：偷錢 0.5%、偷貨 0.5%、插隊 1.0%、吵架 1.25%（佔該街 10 分鐘收入；4 攤、每 3 秒一位客人）。"""
import json, os, random, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
C = json.load(open(os.path.join(ROOT, "data", "market_ops.json"), encoding="utf8"))
EV, PT = C["events"], C["patrol"]
LOSS = {"steal_cash": 0.5, "steal_goods": 0.5, "cut_queue": 1.0, "brawl": 1.25}
def run(n, flow, hours, seed=1):
    rnd = random.Random(seed); T = hours * 3600.0; dt = 0.5
    t = 0.0; nxt = EV["base_s"] / flow; evs = []; fat = [0.0] * n; down = [0.0] * n; busy = [None] * n
    handled = lost = 0; win_loss = 0.0; win_t = 0.0; tot_loss = 0.0; wins = 0
    while t < T:
        t += dt; nxt -= dt; win_t += dt
        if win_t >= EV["cap_win_s"]: tot_loss += win_loss; win_loss = 0.0; win_t = 0.0; wins += 1
        if nxt <= 0:
            nxt = max(EV["min_s"], EV["base_s"] / flow * rnd.uniform(1 - EV["jitter"], 1 + EV["jitter"]))
            if len(evs) < EV["max_street"]:
                r = rnd.random() * 100; k = "steal_cash" if r < 30 else "steal_goods" if r < 50 else "cut_queue" if r < 75 else "brawl"
                evs.append({"k": k, "sp": rnd.random() >= EV["generic_p"], "t": 0.0, "who": None, "at": 0.0, "tried": set()})
        for i in range(n):
            if down[i] > 0:
                down[i] -= dt
                if down[i] <= 0: fat[i] = 40.0
            elif busy[i] is None: fat[i] = max(0.0, fat[i] - 1.0 * dt)
        for e in evs:
            if e["who"] is None:
                for i in range(n):
                    if i in e["tried"] or busy[i] is not None or down[i] > 0: continue
                    e["who"] = i; e["at"] = PT["handle_s"]; e["tried"].add(i); busy[i] = e; break
        for e in list(evs):
            e["t"] += dt
            if e["who"] is not None:
                e["at"] -= dt
                if e["at"] <= 0:
                    i = e["who"]; busy[i] = None; e["who"] = None
                    if rnd.random() < (PT["catch_p_special"] if e["sp"] else PT["catch_p"]):
                        handled += 1; evs.remove(e)
                        fat[i] += 15.0 * (1 - min(0.4, 0.1 * (n - 1)))
                        if fat[i] >= 100: down[i] = 60.0
                        continue
            if e["who"] is None and e["t"] >= EV["deadline_s"]:
                lost += 1; evs.remove(e)
                win_loss += min(LOSS[e["k"]], max(0.0, EV["cap_pct"] * 100 - win_loss))
    tot = max(1, handled + lost)
    return 100.0 * handled / tot, lost / max(1, wins), tot_loss / max(1, wins), tot / max(1, wins)
if __name__ == "__main__":
    hours = float(sys.argv[1]) if len(sys.argv) > 1 else 50.0
    print("人流｜每 10 分鐘事件｜巡邏 0..4 隻：處理率%／每 10 分鐘漏網件數／事件損失%（佔該街收入）")
    for name, flow in [("冷清 1.0（開張、1 攤）", 1.0), ("一般 1.65（4 攤、名聲 2）", 1.65), ("旺 2.4（7 攤、名聲 5）", 2.4), ("子時高峰 ×2（4.0 封頂 45 秒）", 4.0)]:
        row = []
        per = 0
        for n in range(5):
            h, l, loss, per = run(n, flow, hours, 7 + n)
            row.append("%d隻 %.0f%%／%.1f件／%.2f%%" % (n, h, l, loss))
        print("%s｜%.1f 件｜%s" % (name, per, "　".join(row)))
