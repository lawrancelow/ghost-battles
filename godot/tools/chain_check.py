#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生產鏈資料檢查：godot/data/nat/chain.json ＋ outpost.json 一致性。

用法：python3 tools/chain_check.py [--extra-manifest 另一條線嘅 spr_manifest.json ...] [--list-art]
檢查：
  1. 所有引用嘅 mid 都有 MATS 定義；MATS 格式（n 兩個字串、tier 1–5、price > 0、how 兩句）
  2. RECIPES[sid].out == outpost.STATIONS[sid].good；GOODS 有同名 mid，價錢／圖示一致；33 個台都有 RECIPES
  3. CARRY 每個 sid 喺 STATIONS 有定義，而且喺每張圖 MAPS[].stations 入面
  4. 冇死結：每張圖，每個台嘅每樣料都有來源（已解鎖嘅村子 T1/T2〔unlock.ci ≤ 呢張圖〕、同一張圖嘅台、隨村台）
     WORKSHOPS 嘅料亦要喺解鎖嗰張圖有來源；GATHER／WORKSHOPS 嘅 unlock.cost 用嘅料要喺嗰張圖之前有
  5. 層級遞增：out 層 > 所有 in 層；T1 只由 GATHER 出、T2 只由 WORKSHOPS 出、T3+ 只由台出
  6. 每張圖最少去到 T4，第 5、6 張圖要有 T5
  7. GEAR ≥ 10 件、slot 合法、T3–T5；BATTLE_ITEMS 4–8 件；全部 mid 有定義
  8. 加工增值：每個台嘅單價 ÷ 每件料成本（按料價）—— 列出，低過 1.5 當錯
  9. 紅線字眼（沿用 outpost_check.py 嘅 BANNED）
  10. 圖鍵：列出已有圖／冇圖（冇圖唔當錯，係要生嘅新圖）
回傳 0＝全中；1＝有錯。
"""
import json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from outpost_check import BANNED, walk_text  # noqa: E402

errs, warns = [], []
def E(m): errs.append(m)
def W(m): warns.append(m)
def load(p):
    with open(p, encoding="utf-8") as f: return json.load(f)
def pair(v): return isinstance(v, list) and len(v) == 2 and all(isinstance(s, str) and s.strip() for s in v)

SLOTS = {"body", "legs", "head", "hand", "shield"}

def main():
    args = sys.argv[1:]
    extra = []
    while "--extra-manifest" in args:
        i = args.index("--extra-manifest"); extra.append(args[i + 1]); del args[i:i + 2]
    C = load(P("data", "nat", "chain.json"))
    O = load(P("data", "nat", "outpost.json"))
    M, G, WS, R, CARRY = C["MATS"], C["GATHER"], C["WORKSHOPS"], C["RECIPES"], C["CARRY"]
    ST, GO, MAPS = O["STATIONS"], O["GOODS"], O["MAPS"]
    def tier(m): return M[m]["tier"] if m in M else 0

    # 1. MATS
    for mid, d in M.items():
        if not pair(d.get("n")): E("MATS %s 名唔啱" % mid)
        if not pair(d.get("how")): E("MATS %s how 唔啱" % mid)
        if d.get("tier") not in (1, 2, 3, 4, 5): E("MATS %s tier %r" % (mid, d.get("tier")))
        if not (isinstance(d.get("price"), (int, float)) and d["price"] > 0): E("MATS %s price" % mid)
        if not d.get("icon"): E("MATS %s 冇 icon" % mid)
    for fixed, res in (("m_wood", "wood"), ("m_rice", "rice"), ("m_plank", "planks"), ("m_shoubao", "buns"), ("m_bao", "")):
        if fixed not in M: E("固定 mid %s 冇定義" % fixed)
        elif M[fixed].get("res", "") != res: E("%s.res 應該係 %r" % (fixed, res))
    if M.get("m_shoubao", {}).get("tier") != 3: E("m_shoubao 要係 T3")
    if M.get("m_bao", {}).get("tier") != 2: E("m_bao 要係 T2")
    def ref(mid, why):
        if mid not in M: E("%s 用咗冇定義嘅 mid %s" % (why, mid))
    src = {}   # mid -> 出處
    for bid, b in G.items():
        ref(b["out"], "GATHER " + bid)
        if tier(b["out"]) != 1: E("GATHER %s 出 %s 唔係 T1" % (bid, b["out"]))
        src.setdefault(b["out"], []).append(("g", bid))
        for k in ("n", "how"):
            if not pair(b.get(k)): E("GATHER %s %s 唔啱" % (bid, k))
        if not (b.get("rate", 0) > 0): E("GATHER %s rate" % bid)
    for bid, b in WS.items():
        for m in list(b["in"]) + list(b["out"]): ref(m, "WORKSHOPS " + bid)
        for m in b["out"]:
            if tier(m) != 2: E("WORKSHOPS %s 出 %s 唔係 T2" % (bid, m))
            src.setdefault(m, []).append(("w", bid))
        for m in b["in"]:
            if tier(m) >= 2: E("WORKSHOPS %s 用 %s（T%d）做 T2" % (bid, m, tier(m)))
        for k in ("n", "how"):
            if not pair(b.get(k)): E("WORKSHOPS %s %s 唔啱" % (bid, k))
        if not (b.get("time", 0) > 0): E("WORKSHOPS %s time" % bid)
    for k in ("m_wood", "m_rice"):
        if not any(b.get("old") == k[2:] for b in G.values()): E("舊建築 %s 冇對應 GATHER（old）" % k)
    if not any(b.get("old") == "plank" and "m_plank" in b["out"] for b in WS.values()): E("棺材鋪（old plank）唔係出 m_plank")
    if not any(b.get("old") == "bun" and "m_bao" in b["out"] for b in WS.values()): E("包子鋪（old bun）唔係出 m_bao")
    ext_g = [b for b in G.values() if not b.get("old")]
    if not (6 <= len(ext_g) <= 10): E("拓展採集建築 %d 種（要 6–10）" % len(ext_g))

    # 2. RECIPES vs STATIONS／GOODS
    for sid in ST:
        if sid not in R: E("台 %s 冇 RECIPES" % sid)
    for sid, r in R.items():
        if sid not in ST: E("RECIPES %s 唔係 outpost 台" % sid); continue
        if r["out"] != ST[sid]["good"]: E("RECIPES %s.out %s ≠ STATIONS.good %s" % (sid, r["out"], ST[sid]["good"]))
        if r["out"] not in GO: E("GOODS 冇 %s" % r["out"])
        else:
            g = GO[r["out"]]
            if r["out"] in M and (M[r["out"]]["price"] != g["price"] or M[r["out"]]["icon"] != g["icon"] or M[r["out"]]["n"] != g["n"]):
                E("MATS／GOODS %s 名、價、圖唔一致" % r["out"])
        ref(r["out"], "RECIPES " + sid)
        if tier(r["out"]) < 3: E("台 %s 出 T%d（台要出 T3+）" % (sid, tier(r["out"])))
        src.setdefault(r["out"], []).append(("s", sid))
        if not (r.get("n", 0) >= 1): E("RECIPES %s n" % sid)
        if not r["in"]: E("RECIPES %s 冇料" % sid)
        for m, q in r["in"].items():
            ref(m, "RECIPES %s in" % sid)
            if not (q > 0): E("RECIPES %s in %s 數量" % (sid, m))
            if tier(m) >= tier(r["out"]): E("層級：%s 出 T%d，但用咗 %s（T%d）" % (sid, tier(r["out"]), m, tier(m)))
    for gid in GO:
        if gid not in M: E("GOODS %s 冇 MATS" % gid)
    for mid, ss in src.items():
        if len(ss) > 1: E("%s 有幾個出處 %s（每樣料一個出處）" % (mid, ss))
    for mid in M:
        if mid not in src: E("%s 冇任何建築／台出" % mid)

    # 3. CARRY
    if "st_shoubao" not in CARRY: E("CARRY 要有 st_shoubao")
    for sid in CARRY:
        if sid not in ST: E("CARRY %s 唔喺 STATIONS" % sid)
        for m in MAPS:
            if sid not in m["stations"]: E("CARRY %s 唔喺 ci%d 嘅 stations" % (sid, m["ci"]))

    # 4. 死結 ＋ 6. 最高層
    def unl_ci(kind, bid):
        b = (G if kind == "g" else WS)[bid]
        return b["unlock"]["ci"]
    def village_ok(mid, ci, seen=()):
        for kind, bid in src.get(mid, []):
            if kind in "gw" and unl_ci(kind, bid) <= ci:
                if kind == "w":
                    if all(village_ok(m, ci, seen + (mid,)) for m in WS[bid]["in"] if m not in seen): return True
                else: return True
        return False
    for kind, tab in (("g", G), ("w", WS)):
        for bid, b in tab.items():
            ci = b["unlock"]["ci"]
            for m in b["unlock"].get("cost", {}):
                ref(m, "unlock.cost " + bid)
                if not village_ok(m, ci): E("%s 起建築要 %s，但 ci%d 村子未出到" % (bid, m, ci))
            if kind == "w":
                for m in b["in"]:
                    if not village_ok(m, ci): E("WORKSHOPS %s（ci%d）要 %s，但未有來源" % (bid, ci, m))
    for m in MAPS:
        ci = m["ci"]; sids = m["stations"]
        avail_st = {R[s]["out"]: s for s in sids if s in R}
        top = 0
        for s in sids:
            if s not in R: continue
            top = max(top, tier(R[s]["out"]))
            for mid in R[s]["in"]:
                if mid in avail_st: continue
                if village_ok(mid, ci): continue
                E("死結：ci%d 台 %s 要 %s，冇來源（唔係村子已解鎖、唔係呢張圖／隨村台）" % (ci, s, mid))
        need = 5 if ci >= 4 else 4
        if top < need: E("ci%d 最高只去到 T%d（要 T%d）" % (ci, top, need))
        # 有向環
        for s in sids:
            if s in R and R[s]["out"] in R[s]["in"]: E("%s 自己食自己" % s)

    # 7. GEAR／BATTLE_ITEMS
    gear = C.get("GEAR", {}); bi = C.get("BATTLE_ITEMS", {})
    if len(gear) < 10: E("GEAR 得 %d 件（要 ≥10）" % len(gear))
    for mid, g in gear.items():
        ref(mid, "GEAR")
        if g.get("slot") not in SLOTS: E("GEAR %s slot %r" % (mid, g.get("slot")))
        if not (3 <= tier(mid) <= 5): E("GEAR %s 係 T%d（要 T3–T5）" % (mid, tier(mid)))
        for k in ("atk", "def", "hp"):
            if not isinstance(g.get(k), (int, float)): E("GEAR %s 冇 %s" % (mid, k))
    if not (4 <= len(bi) <= 8): E("BATTLE_ITEMS %d 件（要 4–8）" % len(bi))
    for mid, b in bi.items():
        ref(mid, "BATTLE_ITEMS")
        if not pair(b.get("desc")) or not b.get("eff"): E("BATTLE_ITEMS %s 格式" % mid)
        if mid in gear: E("%s 同時係裝備同道具" % mid)
    gear_maps = set()
    for m in MAPS:
        for s in m["stations"]:
            if s in R and R[s]["out"] in gear and s not in CARRY: gear_maps.add(m["ci"])

    # 8. 加工增值
    print("== 加工增值（單價 ÷ 每件料成本，按 MATS 價）")
    worst = []
    for sid, r in R.items():
        cost = sum(M[m]["price"] * q for m, q in r["in"].items()) / r["n"]
        ratio = M[r["out"]]["price"] / cost if cost else 0
        worst.append((ratio, sid))
        if ratio < 1.5: E("%s 單價 %s 唔夠料錢 %s（×%.2f）" % (sid, M[r["out"]]["price"], cost, ratio))
    worst.sort()
    print("   最低：" + "；".join("%s ×%.1f" % (s, x) for x, s in worst[:5]))
    print("   最高：" + "；".join("%s ×%.1f" % (s, x) for x, s in worst[-3:]))
    # 每張圖每層平均價
    print("== 每張圖各層單價（最低–最高）")
    for m in MAPS:
        by = {}
        for s in m["stations"]:
            if s in CARRY and m["ci"] > 0: continue
            o = R[s]["out"]; by.setdefault(tier(o), []).append(M[o]["price"])
        print("   ci%d " % m["ci"] + "  ".join("T%d:%s–%s" % (t, min(v), max(v)) for t, v in sorted(by.items())))

    # 9. 紅線
    txt = []; walk_text(C, txt)
    for t in txt:
        for b in BANNED:
            if b in t: E("紅線字眼「%s」：%s" % (b, t[:40]))

    # 10. 圖鍵
    have = set(load(P("assets", "spr_manifest.json")))
    have |= {k.split(":", 1)[-1] for k in load(P("assets", "img_manifest.json"))}
    ext = set()
    for mf in extra: ext |= {k.split(":", 1)[-1] for k in load(mf)}
    used = {}
    for mid, d in M.items(): used.setdefault(d["icon"], []).append("材料圖示 %s %s" % (mid, d["n"][1]))
    for bid, b in list(G.items()) + list(WS.items()): used.setdefault(b["art"], []).append("建築 %s %s" % (bid, b["n"][1]))
    ok = sorted(k for k in used if k in have); miss = sorted(k for k in used if k not in have)
    print("== 圖鍵：已有 %d、冇圖 %d" % (len(ok), len(miss)))
    if "--list-art" in sys.argv or miss:
        for k in ok: print("   有  %-22s %s" % (k, "、".join(used[k])))
        for k in miss: print("   冇  %-22s %s%s" % (k, "、".join(used[k]), "（美術線已有）" if k in ext else ""))
    dup = {k: v for k, v in used.items() if len(v) > 1}
    if dup:
        print("== 共用同一個圖鍵（暫用，ART_NEEDS.md 有專屬新圖）：%d 個" % len(dup))
        for k, v in sorted(dup.items()): print("   %-22s %s" % (k, "、".join(v)))

    print("== 統計：MATS %d（T1 %d／T2 %d／T3 %d／T4 %d／T5 %d）、GATHER %d、WORKSHOPS %d、RECIPES %d、CARRY %s、GEAR %d（分佈 ci%s）、道具 %d" % (
        len(M), *[sum(1 for d in M.values() if d["tier"] == t) for t in range(1, 6)], len(G), len(WS), len(R), CARRY,
        len(gear), sorted(gear_maps), len(bi)))
    for w in warns: print("⚠ " + w)
    for e in errs: print("✗ " + e)
    print("== chain_check：%s（錯 %d、警告 %d）" % ("全中" if not errs else "有錯", len(errs), len(warns)))
    return 1 if errs else 0

if __name__ == "__main__":
    sys.exit(main())
