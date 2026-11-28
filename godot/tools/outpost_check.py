#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""移動村（出殯巡遊・過勞鬼市集）資料檢查：godot/data/nat/outpost.json

用法：python3 tools/outpost_check.py [--extra-manifest 另一條線嘅 spr_manifest.json ...] [--sim]
  檢查：格式、引用（sid／gid／cid／boss／圖檔鍵）、重複句、目標做唔做得到、紅線字眼。
  圖檔鍵唔存在唔當錯，會列出嚟畀美術補（--extra-manifest 入面有嘅會標「美術線已有」）。
  --sim：用簡單模型估每張圖幾耐做齊（假設見下面 SIM 註解）。
回傳 0＝全中；1＝有錯。
"""
import json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = lambda *a: os.path.join(ROOT, *a)

errs, warns = [], []
def E(m): errs.append(m)
def W(m): warns.append(m)

def load(p):
    with open(p, encoding="utf-8") as f:
        return json.load(f)

def pair(v):
    return isinstance(v, list) and len(v) == 2 and all(isinstance(s, str) and s.strip() for s in v)

def num(v, lo=0):
    return isinstance(v, (int, float)) and not isinstance(v, bool) and v >= lo

def art_keys(extra):
    have = set()
    for k in load(P("assets", "spr_manifest.json")):
        have.add(k)
    for k in load(P("assets", "img_manifest.json")):
        have.add(k.split(":", 1)[-1])
    ext = set()
    for m in extra:
        for k in load(m):
            ext.add(k.split(":", 1)[-1])
    return have, ext

# 紅線字眼（宗教、兒童、真實品牌）
BANNED = ["閻王", "閻羅", "判官", "城隍", "土地公", "地藏", "盂蘭", "中元", "往生", "天地銀行", "輪迴", "轉世",
          "超度", "打齋", "功德", "業障", "符", "咒", "法器", "搖鈴", "桃木劍", "八卦", "上香", "香燭", "神枱",
          "神主", "牌位", "廟", "寺", "道觀", "道士", "和尚", "喃嘸", "神明", "神仙", "菩薩", "佛", "拜神",
          "小朋友", "細路", "BB", "嬰兒", "兒童", "小孩",
          "iPhone", "Apple", "Rolex", "勞力士", "Ferrari", "法拉利", "Lamborghini", "林寶堅尼", "Porsche",
          "保時捷", "Gucci", "Nike", "7-Up", "七喜"]
CHILD_ART = {"toyol", "xiaogui"}   # 兒童形象：唔做客人／圍欄敵人

def walk_text(o, out):
    if isinstance(o, str):
        out.append(o)
    elif isinstance(o, list):
        for x in o: walk_text(x, out)
    elif isinstance(o, dict):
        for x in o.values(): walk_text(x, out)

def main():
    args = sys.argv[1:]
    extra = []
    sim = "--sim" in args
    for i, a in enumerate(args):
        if a == "--extra-manifest" and i + 1 < len(args):
            extra.append(args[i + 1])
    d = load(P("data", "nat", "outpost.json"))
    CARRY = set(load(P("data", "nat", "chain.json")).get("CARRY", [])) if os.path.exists(P("data", "nat", "chain.json")) else set()   # [chain-data]
    maps_src = load(P("data", "nat", "maps.json"))["MAPS"]
    have, ext = art_keys(extra)
    used_art = {}   # key -> 用途

    def art(k, why):
        if not isinstance(k, str) or not k:
            E("圖檔鍵空：" + why); return
        used_art.setdefault(k, why)

    for top in ["GOODS", "STATIONS", "CUSTOMERS", "MAPS", "FOE_LINES", "STRINGS"]:
        if top not in d: E("缺頂層鍵 " + top)
    G, S, CU, MP = d.get("GOODS", {}), d.get("STATIONS", {}), d.get("CUSTOMERS", []), d.get("MAPS", [])

    # GOODS
    for gid, g in G.items():
        if not pair(g.get("n")): E("GOODS %s n 格式錯" % gid)
        art(g.get("icon"), "貨品圖示 %s %s" % (gid, (g.get("n") or ["?"])[0]))
        if not num(g.get("price"), 1): E("GOODS %s price 錯" % gid)
    # STATIONS
    good_of = {}
    for sid, s in S.items():
        if not pair(s.get("n")): E("STATIONS %s n 格式錯" % sid)
        if not pair(s.get("how")): E("STATIONS %s how 格式錯" % sid)
        art(s.get("art"), "生產台 %s %s" % (sid, (s.get("n") or ["?"])[0]))
        if s.get("good") not in G: E("STATIONS %s good %s 唔存在" % (sid, s.get("good")))
        good_of[sid] = s.get("good")
        for k in ["base_time", "base_out", "up_cost0"]:
            if not num(s.get(k), 1e-9): E("STATIONS %s %s 錯" % (sid, k))
        if not num(s.get("unlock_cost"), 0): E("STATIONS %s unlock_cost 錯" % sid)
        if not (num(s.get("up_mul")) and 1.0 < s["up_mul"] < 1.3): E("STATIONS %s up_mul 唔合理" % sid)
        if not (isinstance(s.get("worker_slots"), int) and s["worker_slots"] >= 1): E("STATIONS %s worker_slots 錯" % sid)
        mi = s.get("miles")
        if not (isinstance(mi, list) and mi and all(isinstance(x, int) for x in mi) and mi == sorted(set(mi))):
            E("STATIONS %s miles 要遞增整數" % sid)
    used_goods = [s.get("good") for s in S.values()]
    for gid in G:
        if used_goods.count(gid) == 0: W("GOODS %s 冇台生產" % gid)
    # CUSTOMERS
    cmap = {}
    for c in CU:
        cid = c.get("id")
        if not cid or cid in cmap: E("CUSTOMERS id 空或重複：%s" % cid)
        cmap[cid] = c
        art(c.get("art"), "客人 %s" % cid)
        if c.get("art") in CHILD_ART: E("客人 %s 用咗兒童形象 %s" % (cid, c.get("art")))
        if not c.get("wants") or any(w not in G for w in c["wants"]): E("客人 %s wants 有唔存在嘅貨" % cid)
        ln = c.get("lines")
        if not (isinstance(ln, list) and 2 <= len(ln) <= 8 and all(pair(x) for x in ln)): E("客人 %s lines 要 2–8 句粵＋中" % cid)   # [story] 劇本線：lines＝say.q＋say.buy，放寬到 8
        sy = c.get("say")   # [story] 分類對白（詳細檢查喺 tools/story_check.py）
        if sy is not None and not (isinstance(sy, dict) and all(isinstance(sy.get(k), list) and all(pair(x) for x in sy[k]) for k in ("q", "buy", "wait", "vol"))): E("客人 %s say 要有 q/buy/wait/vol 粵＋中" % cid)
        if not isinstance(c.get("vip"), bool): E("客人 %s vip 要 true/false" % cid)

    # MAPS
    boss_of = {m["ci"]: m.get("boss", []) for m in maps_src}
    seen_ci, seen_sid, seen_cid = set(), set(), set()
    if len(MP) != 6: E("MAPS 要 6 張，而家 %d" % len(MP))
    for m in MP:
        ci = m.get("ci")
        tag = "MAPS[ci=%s]" % ci
        if ci not in boss_of or ci in seen_ci: E(tag + " ci 唔存在或重複")
        seen_ci.add(ci)
        if not pair(m.get("name")): E(tag + " name 錯")
        art(m.get("bg"), "背景 ci%s" % ci)
        st = m.get("stations", [])
        lo = 3 if ci == 0 else 4
        own = [s for s in st if ci == 0 or s not in CARRY]   # [chain-data] 隨村台（chain.json CARRY）每張圖都有，唔計
        if not (lo <= len(own) <= 7): E(tag + " 生產台數 %d 唔喺 %d–7" % (len(own), lo))   # [chain-data] [idle] 第 5、6 張圖 7 個台
        for sid in st:
            if sid not in S: E(tag + " 台 %s 唔存在" % sid)
            if sid in seen_sid and sid not in CARRY: E(tag + " 台 %s 喺第二張圖用過" % sid)   # [chain-data]
            seen_sid.add(sid)
        made = {S[s]["good"] for s in st if s in S}
        free = [s for s in st if s in S and S[s]["unlock_cost"] == 0]
        if not free: E(tag + " 冇開檔即有嘅台（unlock_cost 0）")
        if ci == 0 and len(free) != 3: E(tag + " 第一張圖要 3 個台起步，而家 %d" % len(free))
        cs = m.get("customers", [])
        if not (6 <= len(cs) <= 11): E(tag + " 客人種數 %d 唔喺 6–11" % len(cs))   # [idle] 新台嘅客：第 1 張圖 11 種
        if not any(cmap.get(c, {}).get("vip") for c in cs): W(tag + " 冇 VIP")
        for c in cs:
            if c not in cmap: E(tag + " 客人 %s 唔存在" % c); continue
            if c in seen_cid: E(tag + " 客人 %s 重複用" % c)
            seen_cid.add(c)
            for w in cmap[c]["wants"]:
                if w not in made: E(tag + " 客人 %s 想要 %s，但呢張圖冇台做" % (c, w))
        arts = [cmap[c]["art"] for c in cs if c in cmap]
        if len(arts) != len(set(arts)): E(tag + " 同一張圖有兩個客人用同一個鬼圖")
        # goals
        gl = m.get("goals", [])
        if not (8 <= len(gl) <= 10): E(tag + " 目標數 %d 唔喺 8–10" % len(gl))
        unlocked = set(free)
        for i, g in enumerate(gl):
            t, k, n = g.get("t"), g.get("k"), g.get("n")
            gt = tag + " 目標%d" % (i + 1)
            if not pair(g.get("txt")): E(gt + " txt 錯")
            if not (isinstance(g.get("reward"), dict) and num(g["reward"].get("coins"), 1)): E(gt + " reward 錯")
            if not (isinstance(n, int) and n >= 1): E(gt + " n 錯")
            if t == "unlock":
                if k not in st: E(gt + " 解鎖嘅台 %s 唔喺呢張圖" % k)
                elif k in unlocked: E(gt + " 台 %s 已經開咗，目標冇意思" % k)
                unlocked.add(k)
            elif t in ("level", "hire"):
                if k not in st: E(gt + " 台 %s 唔喺呢張圖" % k)
                elif k not in unlocked: E(gt + " 台 %s 未解鎖就要求%s" % (k, t))
                if t == "hire" and k in S and n > S[k]["worker_slots"]: E(gt + " 請人數超過 worker_slots")
            elif t == "sell":
                src = [s for s in st if S.get(s, {}).get("good") == k]
                if not src: E(gt + " 貨 %s 呢張圖冇台做" % k)
                elif not any(s in unlocked for s in src): E(gt + " 貨 %s 嘅台未解鎖" % k)
            elif t == "boss":
                if k not in boss_of.get(ci, []): E(gt + " boss %s 唔喺 maps.json 呢張圖嘅 boss" % k)
                if i != len(gl) - 1: E(gt + " boss 要係最後一個目標")
            else:
                E(gt + " 類型 %s 唔識" % t)
        if not gl or gl[-1].get("t") != "boss": E(tag + " 最後一個目標唔係 boss")
        if set(st) - unlocked: W(tag + " 有台冇目標帶玩家去開：%s" % sorted(set(st) - unlocked))
        for f in m.get("fence_foes", []):
            art(f, "圍欄敵人 ci%s" % ci)
            if f in CHILD_ART: E(tag + " 圍欄敵人用咗兒童形象 %s" % f)
            if f in arts: W(tag + " 圍欄敵人 %s 同客人同一個圖" % f)
        ml = m.get("move_line", [])
        if not (2 <= len(ml) <= 3 and all(pair(x) for x in ml)): E(tag + " move_line 要 2–3 句粵＋中")
        # 同一張圖冇兩個角色講同一句
        lines = []
        for c in cs:
            lines += [x for p in cmap.get(c, {}).get("lines", []) for x in p]
        lines += [x for p in ml for x in p]
        dup = {x for x in lines if lines.count(x) > 1}
        if dup: E(tag + " 同一張圖有重複句：%s" % sorted(dup))
    for c in cmap:
        if c not in seen_cid: W("客人 %s 冇圖用" % c)
    for sid in S:
        if sid not in seen_sid: W("台 %s 冇圖用" % sid)

    # 全檔重複句（粵、中各自計；短介面字除外）
    allp = []
    for c in CU: allp += c.get("lines", [])
    for c in CU: allp += [p for k in ("wait", "vol") for p in (c.get("say") or {}).get(k, [])]   # [story]
    for m in MP: allp += m.get("move_line", [])
    allp += d.get("FOE_LINES", [])
    allp += [s.get("how") for s in S.values()]
    for p in d.get("FOE_LINES", []):
        if not pair(p): E("FOE_LINES 格式錯：%s" % p)
    for lang in (0, 1):
        xs = [p[lang] for p in allp if pair(p)]
        dup = {x for x in xs if xs.count(x) > 1}
        if dup: E("全檔重複句（%s）：%s" % ("粵中"[lang], sorted(dup)))
    for k, v in d.get("STRINGS", {}).items():
        if not pair(v): E("STRINGS %s 要粵＋中" % k)

    # 紅線字眼
    txt = []
    walk_text({k: v for k, v in d.items()}, txt)
    for t in txt:
        for b in BANNED:
            if b in t: E("紅線字眼「%s」：%s" % (b, t))

    # 圖檔鍵
    miss_ext, miss = [], []
    for k, why in sorted(used_art.items()):
        if k in have: continue
        (miss_ext if k in ext else miss).append((k, why))

    print("== outpost.json：貨 %d、台 %d、客人 %d、地圖 %d、圍欄對白 %d、介面字 %d" % (
        len(G), len(S), len(CU), len(MP), len(d.get("FOE_LINES", [])), len(d.get("STRINGS", {}))))
    print("== 圖檔鍵：用咗 %d 個；本 branch 已有 %d；美術線已有（未合併）%d；要美術補 %d" % (
        len(used_art), len(used_art) - len(miss) - len(miss_ext), len(miss_ext), len(miss)))
    for k, why in miss_ext: print("   [美術線已有] %-18s %s" % (k, why))
    for k, why in miss: print("   [要補]       %-18s %s" % (k, why))
    for w in warns: print("WARN", w)
    if sim: run_sim(d)
    if errs:
        for e in errs: print("ERR ", e)
        print("== 結果：%d 個錯" % len(errs)); return 1
    print("== 結果：全中（0 錯）"); return 0

# ---------------- SIM ----------------
# 假設（引擎線未定實嘅地方，用呢套估）：
#  每台出貨/秒 = 夥計數 × base_out × 1.1^(lv-1) × 2^(已過里程碑數) ÷ base_time（升級＝做得快），收入＝出貨 × price
#  升級價 = up_cost0 × up_mul^(lv-1)；請第 w+1 個夥計 = up_cost0 × 20 × 4^(w-1)
#  客人需求當無限（排隊永遠有人）；每張圖由 0 冥幣開始（唔計上張圖剩低）；Boss 當打 8 分鐘。
#  玩家策略：跟住目標行；儲錢期間，回本時間短過「儲夠目標錢所需時間」嘅升級就順手買。
BOSS_SEC = 480

def run_sim(d):
    S, G = d["STATIONS"], d["GOODS"]
    print("== SIM（估算，假設見檔頭）")
    for m in d["MAPS"]:
        st = {s: {"lv": 1, "w": 1, "on": S[s]["unlock_cost"] == 0} for s in m["stations"]}
        sold = {}
        cash, t = 0.0, 0
        def rate(s):
            x = S[s]; y = st[s]
            ms = sum(1 for v in x["miles"] if y["lv"] >= v)
            return y["w"] * x["base_out"] * G[x["good"]]["price"] * 1.1 ** (y["lv"] - 1) * 2 ** ms / x["base_time"]
        def upc(s): return S[s]["up_cost0"] * S[s]["up_mul"] ** (st[s]["lv"] - 1)
        def hirec(s): return S[s]["up_cost0"] * 20 * 4 ** (st[s]["w"] - 1)
        def total(): return sum(rate(s) for s in st if st[s]["on"])
        out = []
        for g in m["goals"]:
            t0 = t
            while True:
                tt, k, n = g["t"], g["k"], g["n"]
                if tt == "boss":
                    t += BOSS_SEC; break
                if tt == "unlock" and st[k]["on"]: break
                if tt == "level" and st[k]["lv"] >= n: break
                if tt == "hire" and st[k]["w"] >= n: break
                if tt == "sell" and sold.get(k, 0) >= n: break
                need = None
                if tt == "unlock": need = (S[k]["unlock_cost"], lambda k=k: st[k].update(on=True))
                elif tt == "level": need = (upc(k), lambda k=k: st[k].update(lv=st[k]["lv"] + 1))
                elif tt == "hire": need = (hirec(k), lambda k=k: st[k].update(w=st[k]["w"] + 1))
                if need and cash >= need[0]:
                    cash -= need[0]; need[1](); continue
                # 順手升級
                r = total()
                wait = (need[0] - cash) / r if need and r > 0 else 1e9
                best, bv = None, 1e18
                for s in st:
                    if not st[s]["on"]: continue
                    c = upc(s)
                    if c > cash: continue
                    before = rate(s); st[s]["lv"] += 1; gain = rate(s) - before; st[s]["lv"] -= 1
                    pb = c / gain if gain > 0 else 1e18
                    if pb < bv: best, bv = s, pb
                if best and (bv < wait or not need):
                    cash -= upc(best); st[best]["lv"] += 1; continue
                # 過一秒
                cash += total(); t += 1
                for s in st:
                    if st[s]["on"]:
                        gid = S[s]["good"]
                        sold[gid] = sold.get(gid, 0) + rate(s) / G[gid]["price"]
                if t > 6 * 3600 * 2: break
            cash += g["reward"]["coins"]
            out.append((t - t0, t))
        print("   ci%d %s：" % (m["ci"], m["name"][1]) + "  ".join(
            "%d)%s" % (i + 1, fmt(a)) for i, (a, b) in enumerate(out)) + "  ｜合共 %s" % fmt(out[-1][1]))

def fmt(s):
    s = int(s)
    return "%dh%02dm" % (s // 3600, s % 3600 // 60) if s >= 3600 else "%dm%02ds" % (s // 60, s % 60)

if __name__ == "__main__":
    sys.exit(main())
