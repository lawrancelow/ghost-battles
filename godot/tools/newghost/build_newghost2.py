# -*- coding: utf-8 -*-
# [roster2] 由 tools/newghost/ng_src2.py 生成 data/nat/newghost2.json（＋校驗）—— 第二批 30 隻新名鬼＋合體技 5 組
# 用法（喺 godot 目錄）：python3 -I tools/newghost/build_newghost2.py
# 跟住要重跑：python3 -I tools/cdata/build_cdata.py（counter.json 雙駐守＋ENEMY）、python3 -I tools/soul/soul_build.py（PIN）、python3 -I tools/soul/codex_build.py（圖鑑）
# 遊戲行起身：game/newghost/ng_data.gd install() 尾一行 install2() 讀 newghost2.json 登記（第一批 newghost.json／ng_src.py 唔郁）
import json, os, sys, re, glob, importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path); m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m
S = load("ng_src2", os.path.join(HERE, "ng_src2.py"))
S1 = load("ng_src", os.path.join(HERE, "ng_src.py"))
OUT = os.path.join(ROOT, "data", "nat", "newghost2.json")
def J(p): return json.load(open(p, encoding="utf-8"))
ERR = []
def chk(c, *m):
    if not c: ERR.append(" ".join(str(x) for x in m))

# ---------------- cdata 推導規則（標籤↔積木）：直接用 build_cdata.py 嘅 derive()／sig() ----------------
_cwd = os.getcwd(); os.chdir(ROOT)
CD = load("build_cdata", os.path.join(ROOT, "tools", "cdata", "build_cdata.py"))
os.chdir(_cwd)

# ---------------- 名單（同 /home/claude/docs/roster2_ids.md 一致） ----------------
IDS = ("nw_bifang nw_qiongqi nw_nian nw_shen nw_wangliang nw_niexiaoqian nw_zhizhama nw_luotoumin nw_guiamngaan nw_guisihknai "
       "nw_paakbok nw_dikseigwai nw_mosinna nw_kamaitachi nw_nurikabe nw_akaname nw_makuragaeshi nw_dodomeki nw_ungaikyo nw_jinmenken "
       "nw_ushioni nw_nekomata nw_harimau nw_banaspati nw_bonceng nw_nangtani nw_manananggal nw_nuno nw_dokkaebi nw_poltergeist").split()
chk(len(IDS) == 30 and sorted(IDS) == sorted(S.G), "30 隻名單唔對", sorted(set(IDS) ^ set(S.G)))
NG1 = J(os.path.join(ROOT, "data", "nat", "newghost.json"))
ROSTER1 = NG1["ROSTER"]
chk(len(ROSTER1) == 101, "第一批名冊應 101", len(ROSTER1))
chk(not (set(IDS) & set(ROSTER1)), "同第一批撞 id", set(IDS) & set(ROSTER1))
ROSTER = ROSTER1 + IDS
FEUDS = {frozenset((f["a"], f["b"])) for f in J(os.path.join(ROOT, "data", "nat", "bonds_data.json"))["BOND_FEUDS"]}

# ---------------- 現有字串（台詞唔准撞）：data/**.json（唔計 newghost2.json）＋ *.gd 字串常量 ----------------
EXIST = set()
def strings(o):
    if isinstance(o, str): EXIST.add(o.strip())
    elif isinstance(o, dict):
        for v in o.values(): strings(v)
    elif isinstance(o, list):
        for v in o: strings(v)
for p in glob.glob(os.path.join(ROOT, "data", "**", "*.json"), recursive=True):
    if os.path.basename(p) == "newghost2.json": continue
    try: strings(J(p))
    except Exception: pass
STR_RE = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
for p in glob.glob(os.path.join(ROOT, "**", "*.gd"), recursive=True):
    if "/.godot/" in p: continue
    for m in STR_RE.finditer(open(p, encoding="utf-8").read()): EXIST.add(m.group(1).strip())
GH_ALL = {}
for p in ("data/core.json", "data/n30_data.json", "data/nat/patrol_ghosts.json"):
    GH_ALL.update(J(os.path.join(ROOT, p)).get("GHOSTS", {}))
GH_ALL.update(NG1["GHOSTS"])
NAMES = {v.get("name"): k for k, v in GH_ALL.items()}
TITLES = {v.get("title"): k for k, v in GH_ALL.items() if v.get("title")}
BANNED = ["盂蘭", "盂兰", "超度", "狐狸精", "唐僧", "佛教", "梵語", "判官", "神父", "和尚", "道士", "佛祖", "真主", "耶穌", "上帝", "小朋友", "細路", "兒童", "小孩"]

TAGS10 = CD.TAGS
MECH13 = CD.MECHS
PRIMS = set("dmg dot execute chain splash mark pierce down air push pull stun silence interrupt slow flee taunt heal hot shield drain guard immune cleanse revive buff energy anti_air reveal armor_break shield_break dispel banish sap wound dash stealth summon coin zone charm confuse".split())
SEL = {"near", "far", "low", "strong", "back", "caster", "flyer", "stealth", "boss", "self", "ally_low", "allies", "all_r"}
TIERPIN = {1: "凡", 2: "靈", 3: "煞"}

# 現有能力簽名（cdata ABIL＋第一批 ABIL）
SIGS = {}; ASIG = {}
for k, v in list(CD.AB.items()) + list(NG1.get("ABIL", {}).items()):
    if isinstance(v, dict) and isinstance(v.get("act"), dict):
        ASIG.setdefault(json.dumps([v["act"].get("tg", {}), sorted(f["p"] for f in v["act"]["fx"])], sort_keys=True, ensure_ascii=False), k)
        try: SIGS.setdefault(CD.sig(v), k)
        except Exception: pass

def enemy_of(d):   # 同 build_cdata.py build() ENEMY 公式一字不改
    f = S.SYS[d["sys"]]
    fe = [x for x in (f[0], f[1]) if x != d["sc"]]
    im = [f[2]] + ([d["sc"]] if d["sc"] in (f[0], f[1]) else [])
    why = ["怕%s：%s" % (x, f[3] if x == f[0] else f[4]) for x in fe] + ["唔怕%s：%s" % (f[2], f[5])]
    return fe, im, why

out = {"v": 1, "note": "roster2 線：第二批新名鬼 30 隻（tools/newghost/build_newghost2.py 由 ng_src2.py 生成，唔好手改）",
       "GHOSTS": {}, "SKILLS": {}, "ENEMY_T": {}, "ABIL": {}, "ENEMY": {}, "PIN": {}, "ART": {}, "LANG_ZH": {}, "LINK": [], "COMBOS_OLD": [],
       "CAMP2": {}, "ROSTER2": IDS, "ROSTER": ROSTER}
SAYS = {}; ZHS = {}
def lang(y, z):
    if y and z and y != z: out["LANG_ZH"][y] = z

for k in IDS:
    d = S.G[k]
    chk(d["sys"] in S.SYS and d["sc"] in S.SC, k, "系／嚇法")
    fe, im, why = enemy_of(d)
    chk(len(fe) == 2 and len(im) == 1, k, "要怕兩種、唔怕一種（嚇法唔可以係本系怕嘅）", d["sc"], fe, im)
    chk(2 <= len(d["tags"]) <= 3 and all(t in TAGS10 for t in d["tags"]), k, "標籤 2–3 個", d["tags"])
    chk(all(m in MECH13 for m in d["mech"]) and len(d["mech"]) <= 3, k, "機制", d["mech"])
    chk(d["pin"] == TIERPIN[d["tier"]], k, "品級要跟 T（凡＝T1、靈＝T2、煞＝T3）", d["pin"], d["tier"])
    chk(1 <= d["ch"] <= 6, k, "出場章")
    say = d["say"]; chk(isinstance(say, list) and len(say) == 2 and say[0] and say[1], k, "台詞 [粵, 中]")
    chk(say[0].strip() not in EXIST, k, "台詞撞現有字串", say[0])
    chk(say[1].strip() not in EXIST, k, "中文台詞撞現有字串", say[1])
    chk(say[0] not in SAYS and say[1] not in ZHS, k, "台詞同第二批另一隻撞", SAYS.get(say[0]) or ZHS.get(say[1]))
    SAYS[say[0]] = k; ZHS[say[1]] = k
    for w in BANNED:
        for txt in (say[0], say[1], d["title"], d["trait"], d["name"]): chk(w not in txt, k, "紅線字", w)
    chk(d["name"] not in NAMES, k, "名同現有名鬼撞", NAMES.get(d["name"]))
    chk(d["title"] not in TITLES, k, "稱號同現有撞", TITLES.get(d["title"]))
    chk(d.get("lore") and d.get("trait") and d.get("title"), k, "lore／trait／title")
    chk(isinstance(d.get("camp"), tuple) and len(d["camp"]) == 2, k, "camp（鬼幫, 圈）")
    tier = d["tier"]
    out["GHOSTS"][k] = {"name": d["name"], "title": d["title"], "q": "名", "base": d["base"], "range": "ranged" if d["rng"] != "近" else "melee",
                        "trait": d["trait"], "lore": d["lore"], "say": say[0], "nw": True, "nw2": True}
    lang(say[0], say[1])
    out["PIN"][k] = d["pin"]
    out["ART"][k] = {"spr": d.get("spr") or k, "h": d["h"], "solid": bool(d.get("solid", True)), "ph": k}
    out["ENEMY"][k] = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "fear": [S.SC[x] for x in fe], "imm": [S.SC[x] for x in im], "why": why, "mech": d["mech"], "tier": tier,
                       "kind": "named", "recruit": True, "use_abil": True, "ch": d["ch"]}
    out["SKILLS"][k] = dict(d["skill"])
    out["ENEMY_T"][k] = [S.TIER_EN[tier][0], S.TIER_EN[tier][1], d["name"]]
    act = json.loads(json.dumps(d["act"])); act.setdefault("cost", 100); act.setdefault("cast", 0.45)
    pas = json.loads(json.dumps(d.get("pas", [])))
    for f in act["fx"]: chk(f["p"] in PRIMS, k, "未知積木", f["p"])
    for p in pas:
        for f in p["fx"]: chk(f["p"] in PRIMS, k, "未知積木（被動）", f["p"])
        p.setdefault("star", 0)
    chk(act["tg"]["sel"] in SEL, k, "目標選擇器", act["tg"]["sel"])
    ab = {"sys": d["sys"], "sc": [S.SC[d["sc"]]], "rng": S.RNG[d["rng"]], "role": d["role"], "tags": sorted(d["tags"], key=TAGS10.index), "act": act, "pas": pas, "say": say}
    if d.get("aura"): ab["aura"] = json.loads(json.dumps(d["aura"]))
    dv = CD.derive(ab)
    chk(set(d["tags"]) == dv, k, "標籤 ≠ cdata 推導", d["tags"], sorted(dv, key=TAGS10.index))
    a1 = json.dumps([act["tg"], sorted(f["p"] for f in act["fx"])], sort_keys=True, ensure_ascii=False)
    chk(a1 not in ASIG, k, "主動技（目標＋積木）同", ASIG.get(a1), "重複"); ASIG[a1] = k
    s2 = CD.sig(ab); chk(s2 not in SIGS, k, "能力簽名（主動＋被動）同", SIGS.get(s2), "重複"); SIGS[s2] = k
    out["ABIL"][k] = ab
    out["CAMP2"][k] = {"gang": d["camp"][0], "ring": int(d["camp"][1]), "ch": d["ch"]}

# 鬼幫名要喺 build_cdata.GANGS 嗰章存在
for k, c in out["CAMP2"].items():
    names = [v[0] for v in CD.GANGS[c["ch"]].values()]
    chk(c["gang"] in names, k, "第 %d 關冇鬼幫" % c["ch"], c["gang"], names)
    chk(c["ring"] in (2, 3, 4), k, "雙駐守只放第 2～4 圈", c["ring"])

# ---------------- 合體技 ----------------
ids = {L["id"] for L in NG1.get("LINK", [])}
A0 = J(os.path.join(ROOT, "data", "abil.json"))
ids |= {x.get("id") for x in A0.get("LINK", []) if isinstance(x, dict)}
for L in S.LINKS:
    chk(L["id"] not in ids, "合體技 id 重複", L["id"]); ids.add(L["id"])
    chk(all(m in ROSTER for m in L["m"]), L["id"], "成員唔喺 131 隻", [m for m in L["m"] if m not in ROSTER])
    chk(any(m in IDS for m in L["m"]), L["id"], "要有第二批新鬼")
    chk(2 <= L["need"] <= 3 and L["need"] <= len(L["m"]), L["id"], "need")
    if len(L["m"]) == 2: chk(frozenset(L["m"]) not in FEUDS, L["id"], "冤家唔可以做合體技")
    chk(L.get("lore") and L.get("desc"), L["id"], "民俗依據／說明")
    e = {k2: L[k2] for k2 in ("id", "name", "m", "need", "kind", "lore", "desc", "fx") if k2 in L}
    for k2 in ("must", "mult", "fx3"):
        if k2 in L: e[k2] = L[k2]
    if len(L["m"]) == 2: e["a"], e["b"] = L["m"]
    out["LINK"].append(e)
    if L["kind"] == "strike" and len(L["m"]) == 2:
        out["COMBOS_OLD"].append({"id": L["id"], "a": L["m"][0], "b": L["m"][1], "name": L["name"], "mult": L["mult"], "desc": L["desc"]})
chk(3 <= len(S.LINKS) <= 5, "合體技 3–5 組", len(S.LINKS))

if ERR:
    print("校驗失敗：")
    for e in ERR: print("  -", e)
    sys.exit(1)
json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
from collections import Counter
tc = Counter(t for a in out["ABIL"].values() for t in a["tags"])
print("wrote", OUT, "ghosts", len(out["GHOSTS"]), "links", len(out["LINK"]), "pin", dict(Counter(out["PIN"].values())))
print("標籤：" + "、".join("%s %d" % (t, tc[t]) for t in TAGS10))
print("系：", dict(Counter(a["sys"] for a in out["ABIL"].values())), "章：", dict(Counter(d["ch"] for d in S.G.values())))
