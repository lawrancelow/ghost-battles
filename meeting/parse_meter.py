import re, sys
log = open(sys.argv[1], encoding="utf-8", errors="ignore").read().splitlines()
L = [l.split("[meter] ", 1)[1] for l in log if "[meter] " in l]
quests, events, samples, toasts = [], [], [], []
for l in L:
    if l.startswith("QUEST"):
        m = re.match(r"QUEST (\d+) Q(\d+) (.*?)｜(.*)｜(\d+)s", l)
        if m: quests.append((int(m[1]), int(m[2]), m[3], m[4], int(m[5])))
    elif l.startswith("EVENT"):
        p = l.split(" ", 3); t = int(p[1]); k = p[2]; v = p[3] if len(p) > 3 else ""
        (toasts if k == "toast" else events).append((t, k, v))
    elif l.startswith("SAMPLE"):
        d = dict(x.split("=") for x in l.split()[2:]); d["t"] = int(l.split()[1]); samples.append(d)
    elif l.startswith("END"): print("END", l)
print("## 任務時間軸")
print("| 完成時刻 | 任務 | 做法 | 耗時 |")
print("|---|---|---|---|")
for t, qi, tx, how, d in quests: print(f"| {t//60}:{t%60:02d} | Q{qi:02d} {tx} | {how} | {d}s |")
print("\n## 事件（劇情／解鎖／升級／戰鬥）")
for t, k, v in events:
    if k in ("shot",): continue
    print(f"- {t//60}:{t%60:02d} {k} {v}")
print(f"\n## 提示（toast）共 {len(toasts)} 條")
for t, k, v in toasts: print(f"- {t//60}:{t%60:02d} {v[:60]}")
print("\n## 取樣（每 60 秒）")
print("| 時刻 | 任務 | 階段 | 等級 | 木 | 米 | 板 | 壽包 | 幣 | 兵 | 普通包子 | 鬼 | 決策 | 點擊 | 主角閒置累計 s |")
print("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
for s in samples:
    if s["t"] % 60 < 10:
        print(f"| {s['t']//60}:{s['t']%60:02d} | {s['qi']} | {s['stg']} | {s['lv']} | {s['wood']} | {s['rice']} | {s['planks']} | {s['buns']} | {s['coins']} | {s['troops']} | {s['mbao']} | {s['ghosts']} | {s['dec']} | {s['taps']} | {s['idle']} |")
if samples:
    T = samples[-1]["t"]
    print(f"\n總時長 {T}s；決策 {samples[-1]['dec']}（{int(samples[-1]['dec'])/(T/60):.1f}/分）；點擊 {samples[-1]['taps']}（{int(samples[-1]['taps'])/(T/60):.1f}/分）；主角閒置 {samples[-1]['idle']}s（{int(samples[-1]['idle'])/T*100:.0f}%）")
# 閒置最長段
prev = None; runs = []; st = None
for s in samples:
    i = int(s["idle"])
    if prev is not None and i - prev >= 9:
        if st is None: st = s["t"] - 10
    else:
        if st is not None: runs.append((st, s["t"])); st = None
    prev = i
if st is not None: runs.append((st, samples[-1]["t"]))
print("\n## 連續閒置段（主角冇嘢做 ≥ 20 秒）")
for a, b in runs:
    if b - a >= 20: print(f"- {a//60}:{a%60:02d} → {b//60}:{b%60:02d}（{b-a}s）")
