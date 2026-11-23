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
else:
    sc = json.load(open(SC, encoding="utf-8")) if os.path.exists(SC) else {"camps": {}, "ch_k": {}, "sortie_k": {}}
    for f in sorted(glob.glob("/tmp/bal/c*.json") + glob.glob("/tmp/bal/cal_*.json")):
        d = json.load(open(f, encoding="utf-8"))
        c = d["c"]
        if "steps" in d:
            k = d["steps"]["k"]
            sc["ch_k"][str(c)] = {"hp": k[0], "atk": k[1]}
            sc["sortie_k"][str(c)] = {"hp": k[0], "atk": k[1]}
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
for key in ["ch_k", "sortie_k"]:
    for c, v in sc[key].items(): cj[key][c] = v
json.dump(cj, open(CJ, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("camps", len(sc["camps"]), "ch_k", sc["ch_k"], "sortie_k", sc["sortie_k"])
