#!/usr/bin/env python3
"""過勞鬼市集詞庫：由文案稿 story_market_v2_add.md 產生 data/market_lines.json（唔好手改，改文案稿再跑）。
用法：python3 tools/market_lines_build.py [文案稿路徑]
檢查：同一章內（連全遊戲共用句）唔准有兩句一樣；過勞抱怨每句 ≤14 字；每類每章 5 條。
第 3 章巡邏鬼不貼符（老闆已定）：出現「黃符」「貼符」「符咒」就報錯。"""
import json, os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/meeting/market/story_market_v2_add.md"
md = open(SRC, encoding="utf8").read().split("\n")
NODE = {"開場": "open", "考核中": "mid", "達標": "pass", "逾期": "overdue", "賄賂·點心": "snack", "賄賂·名錶": "watch", "賄賂·跑車": "car", "賄賂·失敗": "bribe_fail", "被抓包": "caught"}
TYPE = {"偷錢": "steal_cash", "偷貨": "steal_goods", "插隊": "cut_queue", "吵架打鬧": "brawl"}
out = {"_note": "market_lines_build.py 由 story_market_v2_add.md 產生；每句 [粵語, 書面中文]",
       "zhen": {}, "praise": {}, "complain": [], "ev": {}, "pat_n": {}}
sec = 0; ci = -1
def cells(l): return [c.strip() for c in l.strip().strip("|").split("|")]
for l in md:
    if l.startswith("## 一"): sec = 1
    elif l.startswith("## 二"): sec = 2
    elif l.startswith("## 三"): sec = 3
    elif l.startswith("## 四"): sec = 4
    elif l.startswith("## 五"): sec = 5
    m = re.match(r"### 第 (\d) 章", l)
    if m: ci = int(m.group(1)) - 1; continue
    if l.startswith("### 巡邏隊每處理"): ci = -2; continue
    if not l.startswith("|") or set(l) <= set("|-: "): continue
    c = cells(l)
    if sec == 1 and ci >= 0 and c[0] in NODE and len(c) >= 3:
        out["zhen"].setdefault(str(ci), {})[NODE[c[0]]] = [c[2], c[1]]
    elif sec == 1 and ci == -2 and c[0].isdigit() and len(c) >= 3:
        who, zh = c[1].split("：", 1); who2, yue = c[2].split("：", 1)
        out["praise"][str(int(c[0]) - 1)] = {"who": who, "t": [yue, zh]}
    elif sec == 2 and c[0].isdigit() and len(c) >= 3:
        out["complain"].append([c[2], c[1]])
    elif sec == 3 and ci >= 0 and c[0] in TYPE and len(c) >= 6:
        out["ev"].setdefault(str(ci), {}).setdefault(TYPE[c[0]], []).append({"ev": [c[4], c[2]], "pat": [c[5], c[3]]})
    elif sec == 4 and c[0].isdigit() and len(c) >= 4:
        out["pat_n"][c[0]] = {"who": c[1], "t": [c[3], c[2]]}
err = []
if len(out["complain"]) != 20: err.append("過勞抱怨唔係 20 句：%d" % len(out["complain"]))
for a in out["complain"]:
    for s in a:
        if len(s) > 14: err.append("抱怨超過 14 字：" + s)
if sorted(out["pat_n"]) != ["0", "1", "2", "3", "4"]: err.append("巡邏人數台詞要 0–4：%s" % sorted(out["pat_n"]))
for ci in range(6):
    k = str(ci)
    if len(out["zhen"].get(k, {})) != 9: err.append("第 %d 章甄好賣台詞唔齊" % (ci + 1))
    if k not in out["praise"]: err.append("第 %d 章冇誇獎句" % (ci + 1))
    for t in TYPE.values():
        n = len(out["ev"].get(k, {}).get(t, []))
        if n != 5: err.append("第 %d 章 %s 事件 %d 條（要 5）" % (ci + 1, t, n))
    # 同一章內唔准兩句一樣（兩個語言欄各自查；全遊戲共用句都計入每一章）
    for col in (0, 1):
        seen = {}
        def add(s, who):
            if s in seen: err.append("第 %d 章重複句（%s／%s）：%s" % (ci + 1, seen[s], who, s))
            seen[s] = who
        for n, v in out["zhen"].get(k, {}).items(): add(v[col], "甄好賣·" + n)
        if k in out["praise"]: add(out["praise"][k]["t"][col], "誇獎")
        for i, v in enumerate(out["complain"]): add(v[col], "抱怨%d" % (i + 1))
        for n, v in out["pat_n"].items(): add(v["t"][col], "巡邏人數" + n)
        for t, rows in out["ev"].get(k, {}).items():
            for i, r in enumerate(rows): add(r["ev"][col], "%s事件%d" % (t, i + 1)); add(r["pat"][col], "%s巡邏%d" % (t, i + 1))
for t, rows in out["ev"].get("2", {}).items():
    for r in rows:
        for s in r["ev"] + r["pat"]:
            if re.search("黃符|貼符|符咒|貼一張符", s): err.append("第 3 章唔准貼符：" + s)
if err:
    print("\n".join(err)); sys.exit(1)
json.dump(out, open(os.path.join(ROOT, "data", "market_lines.json"), "w", encoding="utf8"), ensure_ascii=False, indent=1)
print("OK 甄好賣 %d 章×9、誇獎 %d、抱怨 %d、事件 %d 條、巡邏人數 %d" % (len(out["zhen"]), len(out["praise"]), len(out["complain"]), sum(len(r) for c in out["ev"].values() for r in c.values()), len(out["pat_n"])))
