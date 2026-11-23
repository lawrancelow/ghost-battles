# [balance] 把 balance_test 校準結果（/tmp/bal/c*.json）寫入 tools/balance/bal_scale.json，再套落 data/nat/counter.json
#   每個據點：hm、am 同乘 s（camps[id].bal 記住 s；重跑會先除返舊 s，唔會乘兩次）
#   第 5、6 關：ch_k／sortie_k 用 step_test 揀到嘅一步
# 用法：python3 -I tools/balance/apply_bal.py [--from-scale]   （--from-scale：唔讀 /tmp/bal，直接用 bal_scale.json，build_cdata 之後重套用）
import json, os, sys, glob
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SC = os.path.join(ROOT, "tools/balance/bal_scale.json")
CJ = os.path.join(ROOT, "data/nat/counter.json")
if "--from-scale" in sys.argv:
    sc = json.load(open(SC, encoding="utf-8"))
elif "--touchup" in sys.argv:   # 驗證跑（c<N>.json）之後微調：最佳 <80% ×0.8；隨機 <25% 或 萬能 +3.5 級過唔到 ×0.85
    sc = json.load(open(SC, encoding="utf-8"))
    for f in sorted(glob.glob("/tmp/bal/c[0-9].json")):
        for r in json.load(open(f, encoding="utf-8"))["sites"]:
            if r.get("kind") != "sortie" or "B" not in r: continue
            k = 1.0
            if r["B"]["wr"] < 0.8: k = 0.8
            elif r["R"]["wr"] < 0.25 or r["U35"]["wr"] < 0.5: k = 0.85
            if k < 1.0:
                sc["camps"][r["id"]] = round(float(sc["camps"].get(r["id"], 1.0)) * k, 3); print("touchup", r["id"], k, sc["camps"][r["id"]])
    json.dump(sc, open(SC, "w", encoding="utf-8"), ensure_ascii=False, indent=1, sort_keys=True)
else:
    sc = json.load(open(SC, encoding="utf-8")) if os.path.exists(SC) else {"camps": {}, "ch_k": {}, "sortie_k": {}}
    if "--mech-only" in sys.argv: sys.argv.append("--no-tmp")
    for f in ([] if "--no-tmp" in sys.argv else sorted(glob.glob("/tmp/bal/c[0-9].json") + glob.glob("/tmp/bal/cal_*.json"))):
        d = json.load(open(f, encoding="utf-8"))
        c = d["c"]
        if "steps" in d:
            k = d["steps"]["k"]
            sc["ch_k"][str(c)] = {"hp": k[0], "atk": k[1]}
            sc["sortie_k"][str(c)] = {"hp": 0.70, "atk": 0.55} if c == 4 else {"hp": 0.65, "atk": 0.50}   # 據點固定步驟 A
        for r in d["sites"]:
            if "s" in r:
                old = float(sc["camps"].get(r["id"], 1.0))
                sc["camps"][r["id"]] = round(old * r["s"], 3)   # 校準係喺「已套用舊 s」嘅數據上做 → 累乘
    json.dump(sc, open(SC, "w", encoding="utf-8"), ensure_ascii=False, indent=1, sort_keys=True)
cj = json.load(open(CJ, encoding="utf-8"))
for cid, s in sc["camps"].items():
    cp = cj["camps"].get(cid)
    if cp is None: continue
    prev = float(cp.get("bal", 1.0))
    f = s / prev
    cp["hm"] = [round(x * f, 3) for x in cp["hm"]]
    cp["am"] = [round(x * f, 3) for x in cp["am"]]
    cp["bal"] = s
if "yin_k" in sc: cj["yin_k"] = sc["yin_k"]   # 陰兵血倍率（rts.gd _yin_hp_k 讀）
for key in ["ch_k", "sortie_k"]:
    for c, v in sc[key].items(): cj[key][c] = v
# 機制數值（abil.json MECH＝引擎讀；counter.json mech＝設計表，同步對應 key）
AJ = os.path.join(ROOT, "data/abil.json")
MECH = sc.get("mech", {})
if MECH:
    aj = json.load(open(AJ, encoding="utf-8"))
    for m, kv in MECH.items():
        for k, v in kv.items(): aj["MECH"][m][k] = v
    json.dump(aj, open(AJ, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    CMAP = {"n_sum": "n"}
    for m, kv in MECH.items():
        cm = cj["mech"].get(m)
        if cm is None: continue
        for k, v in kv.items():
            if k == "warn": continue
            ck = CMAP.get(k, k)
            if m == "嚇氣光環" and k in ("energy", "minion_atk"): cm[ck] = round(v - 1.0, 3)   # counter.json 寫增減
            elif ck in cm: cm[ck] = v
json.dump(cj, open(CJ, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("camps", len(sc["camps"]), "ch_k", sc["ch_k"], "sortie_k", sc["sortie_k"])
