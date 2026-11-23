# [soul] 魂魄招降節奏模擬（FIXES_review1 第 17 項重跑版；原稿 /home/claude/bs/soul_sim/soul_sim.py）
# 用法（godot 目錄）：python3 -I tools/soul/soul_rhythm.py
# 據點：data/nat/soul.json CAMP_PLAN（cdata counter.json 嘅 guard_plan＝定案名冊鬼幫成員，按 zones.json 真實方向）；
# 品級：soul.json PIN（定案名冊 100 隻）；冇主魂據點嘅鬼：counter.json src 嘅野外王首殺 +15；劇情王：王座重遊每日 3。
# 參數同 game/soul/soul_data.gd 一致（打得好 +1 假設 70% 場次做到；升職散魂頂替封頂一半）。
# 用法：python3 -I soul_sim.py   → 印出分配表、節奏表、敏感度
import random, statistics, json, sys, os

# ---------------- 品級 ----------------
PIN = ["凡", "靈", "煞", "王"]
SUMMON = {"凡": 30, "靈": 60, "煞": 90, "王": 120}          # 招降所需本鬼魂魄
RANK_NAME = ["試用", "正式", "主任", "經理", "總監", "合夥人"]
RANK_COST = {"凡": [5, 10, 20, 30, 45], "靈": [10, 15, 25, 40, 55], "煞": [10, 20, 30, 45, 70], "王": [15, 25, 40, 60, 80]}
def rank_cost(pin, r):  # r = 目標級 1..5
    return RANK_COST[pin][r - 1]
SAN_VAL = {"凡": 1, "靈": 2, "煞": 3, "王": 4}                 # 1 隻魂魄化成幾多散魂
SAN_BUY = 2                                                   # 散魂頂替：每 1 隻魂魄要 SAN_VAL×2 散魂
SAN_SUMMON_MAX = 0.5                                          # 招降最多一半用散魂
ALTAR_PIN = {"凡": 1, "靈": 2, "煞": 3, "王": 4}              # 招降要祭壇等級
ALTAR_RANK = [0, 2, 3, 4, 5, 6]                               # 升到第 r 級要祭壇等級

# ---------------- 掉落 ----------------
PRI = [3, 4, 5, 6]          # 每次打贏主魂（第 1～4 圈）
PRI_BONUS_P = 0.30          # 有 30% 多 1
FIRST = [10, 8, 6, 6]   # 首勝見面禮（第 1～4 圈）
TUTOR = ("n30_changgui", 30)   # 招魂台落成（1-3 後）劇情 xo_ch1 倀鬼送齊一份魂魄＝新手第一次招降
#                 # 首勝見面禮（主魂）
SEC_P = 0.25; SEC_N = 2; SEC_PITY = 4   # 副魂：25% 掉 2 隻，連續 3 次冇 → 第 4 次必掉
SAN = [1, 1, 2, 2]          # 每次打贏散魂
GOOD_P = 0.7; GOOD = 1      # 打得好：主魂 +1（假設 70% 場次用啱應對）
RANK_SUB_MAX = 0.5          # 升職散魂最多頂一半
FRESH = [1.0, 1.0, 0.5, 0.25]   # 同一據點當日第 1、2、3、4+ 次贏的魂魄倍率（怨氣）
MAXRUN = [6, 4, 3, 2]       # 一節遊戲（30～60 分）內同一據點最多打幾次（重生 5/10/20/40 分鐘）
RAID_SAN = 3; RAIDS = 2     # 每日襲擾擊退次數 × 散魂
KING_REPLAY = 3             # 王座重遊：每日每個已打低嘅王 3 隻本鬼魂魄

# ---------------- 章節／據點 ----------------
CH_DAY = [1, 2, 4, 7, 11, 16]   # 第幾日開始第 c 章（主線推進，假設）
END_DAY = 21                    # 打完第 6 章
RINGS = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4]   # 每章 15 個據點

# 每章駐守名鬼（主魂）：圈 1 凡×4、圈 2 凡×2＋靈×2、圈 3 靈×4（第 6 章 靈×2＋煞×2）、圈 4 煞×3
# 名字後綴 *＝劇情鬼（劇情直接加入；據點只供升職魂魄）；new_xx＝待補新鬼
CH = [
 # 第 1 章 餓鬼搶包（槐林荒村、墳場）
 dict(凡=["n30_qionggui","n30_danxiao","n30_maoshi","n30_yangui","n30_jiugui","pg_tuimo"],
      靈=["n30_dugui","n30_guhangui","n30_taozhai","n30_diaosi","n30_jerangkung","xiaozhi*"],
      煞=["eguiking*","new_s1","new_s2"]),
 # 第 2 章 小鬼當家（甘榜）
 dict(凡=["n30_pelesit","n30_polong","n30_jenglot","new_f1","new_f2","new_f3"],
      靈=["n30_hantugalah","n30_bunian","new_l1","new_l2","new_l3","pg_ex"],
      煞=["n30_hanturaya","n30_genderuwo","toyol*"]),
 # 第 3 章 湘西來的乘客（古道、義莊、峽谷）
 dict(凡=["n30_wutou","n30_changgui","new_f4","new_f5","new_f6","new_f7"],
      靈=["n30_guixinniang","n30_baigujing","n30_shanxiao","pg_songding","new_l4","new_l5"],
      煞=["n30_yecha","n30_hanba","laojiang*"]),
 # 第 4 章 香蕉樹下（香蕉園、紅樹林、沉船）
 dict(凡=["n30_phiam","new_f8","new_f9","new_f10","new_f11","new_f12"],
      靈=["n30_churel","n30_tikbalang","n30_maenak","new_l6","new_l7","new_l8"],
      煞=["n30_aswang","n30_vetala","n30_banshee"]),
 # 第 5 章 飛頭與裹屍布（停車場、戲院：橫死路口意外鬼）
 dict(凡=["n30_zipai","n30_xiaosi","n30_yesi","n30_shidu","n30_daji","n30_xiasi"],
      靈=["n30_chehuo","n30_yezi","n30_liulian","n30_zhongshu","n30_chengsi","n30_shedu"],
      煞=["n30_diansi","n30_dongsi","n30_xiangcai"]),
 # 第 6 章 地府集團（冥街暗巷日本妖怪、總部）
 dict(凡=["n30_kasaobake","n30_chochin","n30_kappa","new_f13","new_f14","new_f15"],
      靈=["n30_nopperabo","n30_rokurokubi","n30_kuchisake","new_l9"],
      煞=["n30_yukionna","n30_hannya","n30_gashadokuro","n30_leipi","pg_ji"]),
]
# 第 6 章 圈 3 放 靈×4 → 改 靈×4、圈 4 煞 3；多出嘅 煞 2 隻（雷劈鬼、聻）放「王座」以外嘅第 6 章圈 3 → 圈 3 = 靈 2＋煞 2
# 不在據點做主魂、靠其他途徑嘅：
OTHER = {
 "tianhua*": "煞",   # 劇情（第 2 章後支線）
 "pocong*": "煞", "penanggal*": "王", "pontianak*": "王", "laojiang*": "王",
 "baiwu*": "王", "heiwu*": "王", "mengpo*": "王",
 "pg_landlady": "煞",   # 第 6 章野外王位（王座）首殺 → 之後王座重遊
 "new_k1": "王", "new_k2": "王",   # 待補：兩隻可招降嘅「王」級（建議放第 6 章後的終局王座）
}
STORY_JOIN = {  # 劇情加入日（章末）
 "xiaozhi*": 1, "eguiking*": CH_DAY[1], "toyol*": CH_DAY[2], "tianhua*": CH_DAY[2] + 1, "laojiang*": CH_DAY[3],
 "pontianak*": CH_DAY[4], "pocong*": CH_DAY[4] + 2, "penanggal*": CH_DAY[5], "baiwu*": END_DAY, "heiwu*": END_DAY, "mengpo*": END_DAY,
}

_SJ = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "data", "nat", "soul.json"), encoding="utf-8"))
_CT = None
_ctp = "/home/claude/wt/cdata/godot/data/nat/counter.json"
if os.path.exists(_ctp): _CT = json.load(open(_ctp, encoding="utf-8"))
STORY = set(_SJ["STORY_JOIN"]) - {"afu"}
def S_(k): return k + "*" if k in STORY else k
def pin_of():
    return {S_(k): v for k, v in _SJ["PIN"].items()}
def _sec(c, cid, g, lst, i):   # 同 soul_data.sec_of：同場另一隻名鬼（冇主魂據點優先）
    gs = set(S_(x) for x in _SJ["CAMP_PLAN"].values())
    best = ""
    for k in _SJ.get("CAMP_EN_PLAN", {}).get("%d:%s" % (c, cid), []):
        k = S_(k)
        if k == g: continue
        if k not in gs: return k
        if not best: best = k
    return best or lst[(i + 5) % len(lst)][2]
def camps():
    by = {}
    for key, g in _SJ["CAMP_PLAN"].items():
        c, cid = key.split(":"); c = int(c)
        r = int(cid.split("_r")[1].split("_")[0])
        by.setdefault(c, []).append((cid, r, S_(g)))
    res = []
    for c in sorted(by):
        lst = by[c]
        for i, (cid, r, g) in enumerate(lst):
            res.append({"c": c, "i": i, "ring": r, "pri": g, "sec": _sec(c, cid, g, lst, i)})
    return res
WILD = {}
if _CT:
    for k, src in _CT.get("src", {}).items():
        for x in src:
            if x.get("t") == "wildboss": WILD.setdefault(S_(k), int(x.get("c", 0)) + 1)

def simulate(runs_per_day, days=60, seed=1, verbose=False, ch_day=None, end_day=None, core_n=12):
    global CH_DAY, END_DAY
    if ch_day: CH_DAY = ch_day
    if end_day: END_DAY = end_day
    STORY_JOIN.update({"eguiking*": CH_DAY[1], "toyol*": CH_DAY[2], "tianhua*": CH_DAY[2] + 1, "laojiang*": CH_DAY[3], "pontianak*": CH_DAY[4], "pocong*": CH_DAY[4] + 2, "penanggal*": CH_DAY[5], "baiwu*": END_DAY, "heiwu*": END_DAY, "mengpo*": END_DAY})
    rnd = random.Random(seed)
    P = pin_of(); C = camps()
    shard = {}; owned = {"afu": 0}; rank = {}; san = 0
    first = set(); pity = {}; kings = set()
    hist = []
    for d in range(1, days + 1):
        ch = max([i for i, x in enumerate(CH_DAY) if x <= d])
        # 劇情加入
        for g, dd in STORY_JOIN.items():
            if dd <= d and g not in owned: owned[g] = 0
        altar = 1 + ch if d < END_DAY else 6 + (d - END_DAY) // 10
        altar = min(altar, 9)
        # 開放據點：當前章 圈1-2 第一日、圈3-4 第二日起（或已過嘅章全開）
        avail = []
        for cp in C:
            if cp["c"] < ch or (cp["c"] == ch and (cp["ring"] <= 2 or d > CH_DAY[ch] or ch == 0 and d >= 1 and cp["ring"] <= 3)):
                avail.append(cp)
        if d >= END_DAY: avail = C
        wins = {}
        PV = {"凡": 1, "靈": 2, "煞": 3, "王": 4}
        core = set(sorted([g for g in owned if g != "afu"], key=lambda x: (-PV[P.get(x, "凡")], -owned[x]))[:core_n])
        def value(cp):
            k = (cp["c"], cp["i"]); n = wins.get(k, 0)
            if n >= MAXRUN[cp["ring"] - 1]: return -1
            g = cp["pri"]; p = P.get(g, "凡")
            if g not in owned:
                need = 2.0 + 2.0 * min(1.0, shard.get(g, 0) / SUMMON[p])   # 專心追就快到手嘅
            elif owned[g] < 5: need = 1.6 if g in core else 0.4
            else: need = 0.1
            fr = FRESH[min(n, 3)]
            v = need * fr * PRI[cp["ring"] - 1] + (FIRST[cp["ring"] - 1] if k not in first else 0)
            v += 0.3 * (1 if cp["sec"] not in owned else 0.3)
            v *= 1.0 + 0.1 * cp["c"]
            return v
        for _ in range(runs_per_day):
            best = max(avail, key=value)
            if value(best) <= 0: break
            k = (best["c"], best["i"]); n = wins.get(k, 0); wins[k] = n + 1
            fr = FRESH[min(n, 3)]
            g = best["pri"]; r = best["ring"]
            amt = PRI[r - 1] + (1 if rnd.random() < PRI_BONUS_P else 0)
            amt = int(round(amt * fr))
            if rnd.random() < GOOD_P: amt += GOOD
            if k not in first: first.add(k); amt += FIRST[r - 1]
            shard[g] = shard.get(g, 0) + amt
            pk = best["sec"]; pc = pity.get(k, 0)
            if rnd.random() < SEC_P or pc + 1 >= SEC_PITY:
                shard[pk] = shard.get(pk, 0) + int(round(SEC_N * max(fr, 0.5))); pity[k] = 0
            else: pity[k] = pc + 1
            san += SAN[r - 1]
        san += RAIDS * RAID_SAN
        if d == CH_DAY[1]: shard[TUTOR[0]] = shard.get(TUTOR[0], 0) + TUTOR[1]
        # 王座重遊：已打低的劇情王（加入後）每日 KING_REPLAY
        for g in owned:
            if g.endswith("*") and P.get(g) in ("王", "煞"): shard[g] = shard.get(g, 0) + KING_REPLAY
        for g, wc in WILD.items():   # 野外王首殺 +15（章開放第二日）
            if ("w", g) not in first and (ch + 1 > wc or (ch + 1 == wc and d > CH_DAY[ch])):
                first.add(("w", g)); shard[g] = shard.get(g, 0) + 15
        # 招降
        for g in sorted(shard, key=lambda x: -shard[x]):
            if g in owned: continue
            p = P.get(g, "凡")
            if altar < ALTAR_PIN[p]: continue
            need = SUMMON[p]; have = shard[g]
            if have >= need: shard[g] -= need; owned[g] = 0; continue
            short = need - have
            if short <= need * SAN_SUMMON_MAX and san >= short * SAN_VAL[p] * SAN_BUY:
                san -= short * SAN_VAL[p] * SAN_BUY; shard[g] = 0; owned[g] = 0
        # 升職（本鬼魂魄先，散魂補）
        changed = True
        while changed:
            changed = False
            for g in sorted(owned, key=lambda x: x not in core):
                if g == "afu": continue
                rk = owned[g]
                if rk >= 5 or altar < ALTAR_RANK[rk + 1]: continue
                p = P.get(g, "凡"); c = rank_cost(p, rk + 1)
                have = shard.get(g, 0)
                if have >= c: shard[g] -= c; owned[g] = rk + 1; changed = True
                elif c - have <= c * RANK_SUB_MAX and g in core and san >= (c - have) * SAN_VAL[p] * SAN_BUY:
                    san -= (c - have) * SAN_VAL[p] * SAN_BUY; shard[g] = 0; owned[g] = rk + 1; changed = True
        # 滿級多出嘅 → 散魂
        for g in list(shard):
            if g in owned and owned[g] >= 5 and shard[g] > 0:
                san += shard[g] * SAN_VAL[P.get(g, "凡")]; shard[g] = 0
        rank = owned
        n = len(owned)
        byp = {k: 0 for k in PIN}
        for g in owned:
            if g != "afu": byp[P.get(g, "凡")] += 1
        rk = [owned[g] for g in owned if g != "afu"]
        hist.append({"day": d, "ch": ch + 1, "owned": n, "pins": byp, "avg_rank": round(statistics.mean(rk), 2) if rk else 0,
                     "r3": sum(1 for x in rk if x >= 3), "core_rank": round(statistics.mean(sorted(rk, reverse=True)[:core_n]), 2) if rk else 0, "r5": sum(1 for x in rk if x >= 5), "san": san, "altar": altar})
    return hist

PROF = {"30分": (18, [1, 3, 6, 10, 15, 21], 28), "60分": (36, [1, 2, 4, 7, 11, 16], 21)}
NEED = [1, 4, 8, 12, 16, 20]   # 每章開始時「夠換配搭」最少要幾隻名鬼（不計阿福）

def table(N=20):
    for lab, (R, cd, ed) in PROF.items():
        hs = [simulate(R, days=120, seed=k, ch_day=list(cd), end_day=ed) for k in range(N)]
        print("\n### 每日%s（每日 %d 場，主線第 1～6 章開始日 %s，第 %d 日打完）" % (lab, R, cd, ed))
        print("| 日 | 章 | 擁有名鬼 | 凡/靈/煞/王 | 核心12隻平均職級 | ≥經理 | 合夥人 | 祭壇 |")
        print("|---|---|---|---|---|---|---|---|")
        for d in (1, 2, 3, 4, 6, 7, 10, 11, 15, 16, 21, 28, 35, 45, 60, 90, 120):
            h = hs[0][d - 1]
            m = lambda f: statistics.mean(f(x[d - 1]) for x in hs)
            pins = "/".join("%.0f" % m(lambda y, k=k: y["pins"][k]) for k in PIN)
            print("| %d | %d | %.1f | %s | %.1f（%s） | %.1f | %.1f | %d |" % (d, h["ch"], m(lambda y: y["owned"] - 1), pins, m(lambda y: y["core_rank"]),
                  RANK_NAME[int(round(m(lambda y: y["core_rank"])))] , m(lambda y: y["r3"]), m(lambda y: y["r5"]), h["altar"]))
        print("\n章開始時擁有 vs 需要：")
        for c, dd in enumerate(cd):
            j = max(0, dd - 2)   # 章開始＝前一日收工時
            own = statistics.mean(x[j]["owned"] - 1 for x in hs); mn = min(x[j]["owned"] - 1 for x in hs)
            print("  第%d章（第%d日）：平均 %.1f、最少 %d、需要 %d → %s" % (c + 1, dd, own, mn, NEED[c], "夠" if mn >= NEED[c] else "唔夠"))
        def first_day(f):
            return statistics.mean(next((x["day"] for x in h if f(x)), 999) for h in hs)
        print("  擁有 50 隻：第 %.0f 日；90 隻：第 %.0f 日；100 隻：第 %.0f 日；核心 12 隻全合夥人：第 %.0f 日；全部合夥人：第 %.0f 日" % (
            first_day(lambda x: x["owned"] - 1 >= 50), first_day(lambda x: x["owned"] - 1 >= 90), first_day(lambda x: x["owned"] - 1 >= 100),
            first_day(lambda x: x["core_rank"] >= 5), first_day(lambda x: x["r5"] >= 100)))

if __name__ == "__main__":
    P = pin_of(); C = camps()
    from collections import Counter
    print("總名鬼（不計阿福）:", len(P), dict(Counter(P.values())))
    for p in PIN:
        print("  %s：招降 %d，升職 %s（合計 %d），全滿 %d 隻魂魄" % (p, SUMMON[p], RANK_COST[p], sum(RANK_COST[p]), SUMMON[p] + sum(RANK_COST[p])))
    table()
