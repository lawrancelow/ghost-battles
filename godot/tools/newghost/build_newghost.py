# -*- coding: utf-8 -*-
# [newghost] 由 tools/newghost/ng_src.py 生成 data/nat/newghost.json（＋校驗）
# 用法（喺 godot 目錄）：
#   python3 -I tools/newghost/build_newghost.py                 生成 data/nat/newghost.json、校驗
#   python3 -I tools/newghost/build_newghost.py --merge-abil P  （整合用，可選）將 ABIL／ENEMY／LINK 新條目加入 abil.json P（只加冇嘅 key，唔改舊條目）
# 點解唔直接改 core.json／data/nat/data.json：兩個都係網頁版導出（tools/dump_runtime.py、tools/tests/dump_datamod.gd），重新導出會蓋走；
#   遊戲行起身時由 game/newghost/ng_data.gd 讀 newghost.json，登記入 J.G.GHOSTS／SKILLS／ENEMY_T 同 DB.D（掛鈎喺 native/patrol_ghosts.gd 尾）。
import json, os, sys, re, importlib.util, glob

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
spec = importlib.util.spec_from_file_location("ng_src", os.path.join(HERE, "ng_src.py"))
S = importlib.util.module_from_spec(spec); spec.loader.exec_module(S)
OUT = os.path.join(ROOT, "data", "nat", "newghost.json")
CDATA_ABIL = os.path.join(ROOT, "data", "abil.json")   # cdata 線 abil.json（整合後喺本樹）：ENEMY 段係系／嚇法／怕唔怕嘅唯一來源；ABIL.say 比對重複
if not os.path.exists(CDATA_ABIL): CDATA_ABIL = "/home/claude/wt/cdata/godot/data/abil.json"

def J(p): return json.load(open(p, encoding="utf-8"))
ERR = []
def chk(c, *m):
    if not c: ERR.append(" ".join(str(x) for x in m))

# ---------------- 現有名冊（101 隻 = 阿福＋現有 72＋牛頭馬面＋新 26） ----------------
DATA = J(os.path.join(ROOT, "data", "nat", "data.json"))
N30 = J(os.path.join(ROOT, "data", "n30_data.json"))
PG = J(os.path.join(ROOT, "data", "nat", "patrol_ghosts.json"))
OLD = list(DATA["GHOSTS"]) + list(N30["GHOSTS"]) + list(PG["keys"])
chk(len(OLD) == 73, "現有名鬼數（含阿福）應 73", len(OLD))
NEW = [k for k in S.G if k.startswith("nw_")]
chk(len(NEW) == 26, "新名鬼要 26 隻", len(NEW))
PROMO = [k for k in S.G if not k.startswith("nw_")]
chk(sorted(PROMO) == ["mamian", "niutou"], "升名鬼只係牛頭馬面", PROMO)
ROSTER = OLD + PROMO + NEW
chk(len(ROSTER) == 101 and len(set(ROSTER)) == 101, "名冊 101 隻", len(ROSTER))
FEUDS = {frozenset((f["a"], f["b"])) for f in J(os.path.join(ROOT, "data", "nat", "bonds_data.json"))["BOND_FEUDS"]}

# ---------------- 現有台詞（唔准撞） ----------------
def strings(o, out):
    if isinstance(o, str): out.add(o.strip())
    elif isinstance(o, dict):
        for v in o.values(): strings(v, out)
    elif isinstance(o, list):
        for v in o: strings(v, out)
EXIST = set()
for p in glob.glob(os.path.join(ROOT, "data", "*.json")) + glob.glob(os.path.join(ROOT, "data", "nat", "*.json")):
    if os.path.basename(p) in ("newghost.json", "abil.json"): continue   # abil.json 台詞下面逐隻加（牛頭馬面嗰兩句係同一隻鬼）
    try: strings(J(p), EXIST)
    except Exception: pass
CD = J(CDATA_ABIL) if os.path.exists(CDATA_ABIL) else {}
CD_SAY = {k: v.get("say") for k, v in CD.get("ABIL", {}).items() if isinstance(v, dict)}
for k, v in CD_SAY.items():
    if k not in PROMO and v: strings(v, EXIST)

TAGS10 = ["遠", "拉", "掃", "破", "刺", "削", "回", "照", "定", "收"]
MECH13 = ["飛", "隱", "殼", "再生", "散骨", "召喚", "反傷", "嚇氣光環", "霸體", "屍變", "突襲", "迷魂", "分身"]
PRIMS = set("dmg dot execute chain splash mark pierce down air push pull stun silence interrupt slow flee taunt heal hot shield drain guard immune cleanse revive buff energy anti_air reveal armor_break shield_break dispel banish sap wound dash stealth summon coin zone charm confuse".split())
SEL = {"near", "far", "low", "strong", "back", "caster", "flyer", "stealth", "boss", "self", "ally_low", "allies", "all_r"}

CD_EN = CD.get("ENEMY", {})
def fears(d, k=None):
    e = CD_EN.get(k) if k else None
    if isinstance(e, dict) and e.get("fear") is not None:   # 定案：以 cdata abil.json ENEMY（8 系規則）為準，唔自己定
        return list(e["fear"]), list(e["imm"]), list(e.get("why", []))
    ERR.append("%s：abil.json ENEMY 冇呢隻（怕唔怕要由 cdata 定）" % k)
    f0, f1, im, w0, w1, wi = S.SYS[d["sys"]]
    fe = d.get("fear") or [f0, f1]
    why = d.get("why") or ["怕%s：%s" % (f0, w0), "怕%s：%s" % (f1, w1)]
    return [S.SC[x] for x in fe], [S.SC[im]], why + ["唔怕%s：%s" % (im, wi)]

def sig(act):
    fx = act.get("fx", [])
    return (json.dumps(act.get("tg", {}), sort_keys=True), tuple(sorted(f["p"] for f in fx)))

out = {"v": 1, "note": "由 tools/newghost/build_newghost.py 生成（源頭 ng_src.py），唔好手改", "GHOSTS": {}, "SKILLS": {}, "ENEMY_T": {}, "ABIL": {}, "ENEMY": {},
       "PIN": {}, "ART": {}, "LANG_ZH": {}, "BOSS": {}, "BOSS_CAMP": S.BOSS_CAMP, "HIDDEN": S.HIDDEN, "FOD": {}, "LINK": [], "COMBOS_OLD": [],
       "ALIAS": {"nw_panguan": "nw_shenpi", "nx_teketeke": "nw_teketeke", "nw_sundel": "nw_teketeke"}, "ROSTER": ROSTER}
SAYS = {}
SIGS = {}
for k, v in CD.get("ABIL", {}).items():
    if isinstance(v, dict) and isinstance(v.get("act"), dict): SIGS.setdefault(sig(v["act"]), k)

def lang(y, z):
    if y and z and y != z: out["LANG_ZH"][y] = z

SC_R = {v: kk for kk, v in S.SC.items()}
for k in list(S.G) + list(S.B) + list(S.F):
    e = CD_EN.get(k); d = S.G.get(k) or S.B.get(k) or S.F.get(k)
    if isinstance(e, dict):
        chk(e.get("sys") == d["sys"] and e.get("sc", [None])[0] == S.SC[d["sc"]], k, "系／嚇法同 abil.json ENEMY 唔一致", e.get("sys"), e.get("sc"), d["sys"], d["sc"])
        chk(list(e.get("mech", [])) == list(d["mech"]), k, "機制同 abil.json ENEMY 唔一致", e.get("mech"), d["mech"])
for k, d in S.G.items():
    short = k[3:] if k.startswith("nw_") else k
    chk(d["sys"] in S.SYS and d["sc"] in S.SC, k, "系／嚇法")
    fe, im, why = fears(d, k)
    chk(S.SC[d["sc"]] not in fe, k, "自己嚇法唔可以喺「怕」", d["sc"], fe)
    chk(2 <= len(d["tags"]) <= 3 and all(t in TAGS10 for t in d["tags"]), k, "標籤 2–3 個", d["tags"])
    chk(all(m in MECH13 for m in d["mech"]) and len(d["mech"]) <= 3, k, "機制", d["mech"])
    chk(d["pin"] in ("凡", "靈", "煞", "王"), k, "品級")
    say = d["say"]; chk(isinstance(say, list) and len(say) == 2 and say[0], k, "台詞 [粵, 中]")
    chk(say[0].strip() not in EXIST, k, "台詞撞現有句子", say[0])
    chk(say[0] not in SAYS, k, "台詞撞", SAYS.get(say[0]))
    SAYS[say[0]] = k
    chk(d.get("lore") and d.get("trait") and d.get("title"), k, "lore／trait／title")
    tier = d["tier"]
    out["GHOSTS"][k] = {"name": d["name"], "title": d["title"], "q": "名", "base": d["base"], "range": "ranged" if d["rng"] != "近" else "melee",
                        "trait": d["trait"], "lore": d["lore"], "say": say[0], "nw": True}
    lang(say[0], say[1])
    out["PIN"][k] = d["pin"]
    out["ART"][k] = {"spr": d.get("spr") or k, "h": d["h"], "solid": bool(d.get("solid", True)), "ph": k}
    out["ENEMY"][k] = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "fear": fe, "imm": im, "why": why, "mech": d["mech"], "tier": tier,
                       "kind": "named", "recruit": True, "use_abil": True, "ch": d["ch"]}
    if d.get("keep_skill"): continue   # 牛頭馬面：SKILLS／ENEMY_T 已有，ABIL 歸 cdata
    sk = dict(d["skill"]); out["SKILLS"][k] = sk
    out["ENEMY_T"][k] = [S.TIER_EN[tier][0], S.TIER_EN[tier][1], d["name"]]
    act = dict(d["act"]); act.setdefault("cost", 100); act.setdefault("cast", 0.45)
    for f in act["fx"]: chk(f["p"] in PRIMS, k, "未知積木", f["p"])
    for p in d.get("pas", []):
        for f in p["fx"]: chk(f["p"] in PRIMS, k, "未知積木（被動）", f["p"])
        p.setdefault("star", 0)
    chk(act["tg"]["sel"] in SEL or act["tg"]["sel"].startswith("mech:"), k, "目標選擇器", act["tg"]["sel"])
    sg = sig(act); chk(sg not in SIGS, k, "主動技同", SIGS.get(sg), "重複"); SIGS[sg] = k
    ab = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "rng": S.RNG[d["rng"]], "role": d["role"], "tags": d["tags"], "act": act, "pas": d.get("pas", []), "say": say}
    if d.get("aura"): ab["aura"] = d["aura"]
    out["ABIL"][k] = ab

for k, d in S.B.items():
    fe, im, why = fears(d, k)
    chk(S.SC[d["sc"]] not in fe, k, "自己嚇法唔可以喺「怕」")
    chk(len(d["mech"]) == 3 and all(m in MECH13 for m in d["mech"]), k, "魔王 3 個機制")
    say = d["say"]; chk(say[0].strip() not in EXIST and say[0] not in SAYS, k, "台詞撞", say[0]); SAYS[say[0]] = k
    lang(say[0], say[1])
    out["ENEMY_T"][k] = [d["en"][0], d["en"][1], d["name"]]
    out["ENEMY"][k] = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "fear": fe, "imm": im, "why": why, "mech": d["mech"], "tier": 5,
                       "kind": "boss", "recruit": False, "use_abil": True}
    act = dict(d["act"]); act.setdefault("cost", 100); act.setdefault("cast", 0.6)
    out["ABIL"][k] = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "rng": 60, "role": "front", "tags": [], "act": act, "pas": d.get("pas", []), "say": say, "boss": True}
    if d.get("aura"): out["ABIL"][k]["aura"] = d["aura"]
    out["SKILLS"][k] = {"name": act["name"], "kind": "aoe" if act["tg"].get("shape") in ("circle", "self_circle", "cone", "line") else "hit",
                        "mult": float(act["fx"][0].get("mult", 1.4)), "desc": d["title"]}
    out["BOSS"][k] = {"name": d["name"], "title": d["title"], "lore": d["lore"], "say": say[0], "ch": d["ch"], "hidden": bool(d.get("hidden")), "drop": d["drop"]}
    out["ART"][k] = {"spr": d.get("spr") or k, "h": d["h"], "solid": True, "ph": k}

for k, d in S.F.items():
    fe, im, why = fears(d, k)
    out["ENEMY_T"][k] = [d["en"][0], d["en"][1], d["name"]]
    out["ENEMY"][k] = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "fear": fe, "imm": im, "why": why, "mech": d["mech"], "tier": 0,
                       "kind": "fod", "recruit": False, "use_abil": False, "quirk": d["quirk"]}
    out["FOD"][k] = {"name": d["name"], "desc": d["desc"], "range": d["rng"]}
    out["ART"][k] = {"spr": k, "h": d["h"], "solid": d["sys"] in ("屍", "紙紮", "妖", "官"), "ph": k}
    chk(d["sys"] in S.SYS and all(m in MECH13 for m in d["mech"]), k, "雜兵系／機制")
chk(len(S.F) == 8, "新雜兵 8 種", len(S.F))
chk(len(S.B) == 7 and len(S.BOSS_CAMP) == 6, "魔王 7（6 據點＋酒吞）")

# ---------------- 合體技 ----------------
ids = set()
for L in S.LINKS:
    chk(L["id"] not in ids, "合體技 id 重複", L["id"]); ids.add(L["id"])
    chk(all(m in ROSTER for m in L["m"]), L["id"], "成員唔喺 101 隻", [m for m in L["m"] if m not in ROSTER])
    chk(2 <= L["need"] <= 3 and L["need"] <= len(L["m"]), L["id"], "need")
    chk(set(L.get("must", [])) <= set(L["m"]), L["id"], "must")
    if len(L["m"]) == 2: chk(frozenset(L["m"]) not in FEUDS, L["id"], "冤家唔可以做合體技")
    chk(L.get("lore") and L.get("desc"), L["id"], "民俗依據／說明")
    e = {k2: L[k2] for k2 in ("id", "name", "m", "need", "kind", "lore", "desc", "fx") if k2 in L}
    for k2 in ("must", "mult", "fx3"):
        if k2 in L: e[k2] = L[k2]
    if len(L["m"]) == 2: e["a"], e["b"] = L["m"]
    out["LINK"].append(e)
    if L["kind"] == "strike" and len(L["m"]) == 2 and not L.get("old"):
        out["COMBOS_OLD"].append({"id": L["id"], "a": L["m"][0], "b": L["m"][1], "name": L["name"], "mult": L["mult"], "desc": L["desc"]})
chk(len(S.LINKS) == 25, "合體技 25 組", len(S.LINKS))

# ---------------- 台詞後備：主線 12 隻（阿福、小紙、劇情王…）GHOSTS 冇 say，句子由 cdata 線 ABIL.say 寫；呢度抄一份做後備（cdata 合併後以 abil.json 為準） ----------------
ALLG = {**DATA["GHOSTS"], **N30["GHOSTS"], **PG["GHOSTS"]}
out["SAY_FB"] = {}
for k in OLD:
    if not ALLG.get(k, {}).get("say"):
        v = CD_SAY.get(k)
        chk(isinstance(v, list) and v, k, "主線鬼冇台詞（cdata ABIL.say 都冇）")
        if v: out["SAY_FB"][k] = v[0]; lang(v[0], v[1] if len(v) > 1 else v[0])
ALL_SAY = {}
for k in ROSTER:
    sy = out["GHOSTS"].get(k, {}).get("say") or ALLG.get(k, {}).get("say") or out["SAY_FB"].get(k)
    if k == "n30_hantugalah": sy = "唔好抬頭。我話你知，你一望，我就高多截。"   # patrol_ghosts.gd 行起身時覆寫
    chk(sy, k, "冇台詞")
    chk(sy not in ALL_SAY, k, "台詞同", ALL_SAY.get(sy), "重複")
    ALL_SAY[sy] = k

# ---------------- 標籤 ↔ 積木（cdata build_cdata.py derive() 同一套規則；標籤以 counter.json new 為準） ----------------
spec2 = importlib.util.spec_from_file_location("ng_derive", os.path.join(HERE, "ng_derive.py"))
DV = importlib.util.module_from_spec(spec2); spec2.loader.exec_module(DV)
CNEW = J(os.path.join(ROOT, "data", "nat", "counter.json")).get("new", {})
for k in NEW:
    want = CNEW.get(k, {}).get("tags")
    chk(want, k, "counter.json new 冇呢隻")
    if not want: continue
    a = out["ABIL"][k]
    chk(set(a["tags"]) == set(want), k, "標籤同 counter.json new 唔一致", a["tags"], want)
    a["tags"] = list(want)
    d = DV.derive(a)
    chk(d == set(want), k, "標籤同積木唔一致：標 %s、推導 %s" % (sorted(want), sorted(d)))

if ERR:
    print("校驗失敗：")
    for e in ERR: print("  -", e)
    sys.exit(1)

if "--merge-abil" in sys.argv:
    p = sys.argv[sys.argv.index("--merge-abil") + 1]
    A = J(p); n = 0
    for sec in ("ABIL", "ENEMY"):
        A.setdefault(sec, {})
        for k, v in out[sec].items():
            if k not in A[sec]: A[sec][k] = v; n += 1
    L0 = A.setdefault("LINK", []); have = {x.get("id") for x in L0 if isinstance(x, dict)}
    for x in out["LINK"]:
        if x["id"] not in have: L0.append(x); n += 1
    json.dump(A, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print("merged", n, "->", p); sys.exit(0)

json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("wrote", OUT, "ghosts", len(out["GHOSTS"]), "abil", len(out["ABIL"]), "enemy", len(out["ENEMY"]), "links", len(out["LINK"]), "says", len(SAYS))
