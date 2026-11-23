# [balance] 由 /tmp/bal/c*.json（balance_test ca／cb 驗證跑）生成 /home/claude/docs/balance_report.md 嘅每章表
# 用法：python3 -I tools/balance/report.py <輸出.md> [前言.md]
import json, glob, sys, os
out = sys.argv[1]
pre = open(sys.argv[2], encoding="utf-8").read() if len(sys.argv) > 2 else ""
scale = {}
sp = os.path.join(os.path.dirname(os.path.abspath(__file__)), "bal_scale.json")
if os.path.exists(sp): scale = json.load(open(sp, encoding="utf-8")).get("camps", {})
L = [pre]
summ = []
for f in sorted(glob.glob("/tmp/bal/c*.json")):
    d = json.load(open(f, encoding="utf-8"))
    c = d["c"]; nm = d.get("names", {})
    n = lambda k: nm.get(k, k)
    rows = [r for r in d["sites"] if "B" in r]
    bad = {"best": [], "rand": [], "r1": [], "up": []}
    for r in rows:
        if r["B"]["wr"] < 0.8: bad["best"].append(r["id"])
        if r["R"]["wr"] < 0.25: bad["rand"].append(r["id"])
        if r["ring"] == 1 and r["B"]["wr"] < 0.95: bad["r1"].append(r["id"])
        if r["U35"]["wr"] < 0.5: bad["up"].append(r["id"])
    U = d.get("Uavg", sum(min(1, r["u"]) for r in rows) / max(1, len(rows)))
    to = d.get("to_rate", 0)
    L.append("\n## 第 %d 章\n" % (c + 1))
    L.append("全章固定萬能隊：**%s**　萬能度 U＝**%.3f**%s　時間到比率 %.1f%%　（%d 個場地，跑 %.0f 秒）\n" % (
        "＋".join(n(k) for k in d["uni"]), U, "（第 1 章教學，唔設線）" if c == 0 else ("（≤0.85 ✔）" if U <= 0.85 else "（>0.85 ✘）"), to * 100, len(rows), d.get("sec", 0)))
    if "steps" in d:
        st = d["steps"]
        L.append("主線 SOFT：試到 %s，採用血 ×%.2f、攻 ×%.2f（主線 ch_k、據點 sortie_k 同步）。\n" % ("、".join("%s%s" % (x["step"], "過" if x["ok"] else "唔過") for x in st["tried"]), st["k"][0], st["k"][1]))
    L.append("| 場地 | 圈 | p | 等級 | 池 | 最佳隊（＋軍師） | 最佳勝率 | 秒 | 陰兵戰死 | 時間到 | 隨機勝率 | 萬能勝率 | 萬能÷最佳 | 萬能+3.5級 | 據點縮放 |")
    L.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        B = r["B"]; R = r["R"]; Uu = r["U"]; U3 = r["U35"]
        nmid = r["id"] + ("（魔王）" if r.get("bm") else "") + ("（主線）" if r["kind"] == "stage" else "")
        L.append("| %s | %d | %.1f | %d | %d | %s＋%s | %.0f%% | %.0f | %.1f | %.0f%% | %.0f%% | %.0f%% | %.2f | %.0f%% | %s |" % (
            nmid, r["ring"], r["p"], r["lv"], r["pool"], "、".join(n(k) for k in r["best"]), n(r["badv"]) if r["badv"] else "—",
            B["wr"] * 100, B["t"], B["dead"], B["to"] * 100, R["wr"] * 100, Uu["wr"] * 100, r["u"], U3["wr"] * 100,
            ("%.2f" % scale[r["id"]]) if r["id"] in scale else ("—" if r["kind"] == "stage" else "1.00")))
    fails = []
    if bad["best"]: fails.append("最佳隊 <80%%：%s" % "、".join(bad["best"]))
    if bad["rand"]: fails.append("隨機隊 <25%%：%s" % "、".join(bad["rand"]))
    if bad["r1"]: fails.append("第 1 圈最佳 <95%%：%s" % "、".join(bad["r1"]))
    if bad["up"]: fails.append("萬能隊 +3.5 級過唔到：%s" % "、".join(bad["up"]))
    if c >= 1 and U > 0.85: fails.append("萬能度 %.3f > 0.85" % U)
    if to > 0.15: fails.append("時間到 %.1f%% > 15%%" % (to * 100))
    L.append("\n合格線：" + ("全部過。" if not fails else "；".join(fails) + "。"))
    summ.append((c, U, to, fails))
L.append("\n## 總結\n")
L.append("| 章 | 萬能度 U | 時間到 | 唔合格項 |")
L.append("|---|---|---|---|")
for c, U, to, fails in summ:
    L.append("| %d | %.3f | %.1f%% | %s |" % (c + 1, U, to * 100, "；".join(fails) if fails else "冇"))
open(out, "w", encoding="utf-8").write("\n".join(L) + "\n")
print("wrote", out)
