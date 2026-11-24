# -*- coding: utf-8 -*-
# [legion] 由 tools/legion/lg_src.py 生成 data/nat/legion.json（＋校驗）—— 八大軍團 54 隻＋每軍團 3 營據點數據結構
# 用法（喺 godot 目錄）：python3 -I tools/legion/build_legion.py
#   之後：python3 -I tools/balance/apply_bal.py --from-scale（bal_scale.json camps 嘅 lg_* 套落 legion.json CAMPS hm／am）
# 遊戲行起身：game/newghost/ng_data.gd install() 尾一行 → game/legion/lg_data.gd install()（GHOSTS／SKILLS／ENEMY_T／LANG／圖）
#   abil.gd data() 讀 legion.json ABIL／ENEMY（只補冇嘅 key）
# 據點：老闆 17:10／17:13：唔放現有 6 張圖；每軍團 3 營掛去新地圖七～十二（ci 6–11），地圖未做好前 CAMP_ON＝false（唔顯示、唔出現喺 SO.camps）
import json, os, sys, re, glob, importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path); m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m
S = load("lg_src", os.path.join(HERE, "lg_src.py"))
OUT = os.path.join(ROOT, "data", "nat", "legion.json")
def J(p): return json.load(open(p, encoding="utf-8"))
ERR = []
def chk(c, *m):
    if not c: ERR.append(" ".join(str(x) for x in m))

_cwd = os.getcwd(); os.chdir(ROOT)
CD = load("build_cdata", os.path.join(ROOT, "tools", "cdata", "build_cdata.py"))
os.chdir(_cwd)

# 所屬地圖（老闆 17:13）：ci 6＝地圖七 … ci 11＝地圖十二
MAP_OF = {"jsj": 6, "egs": 7, "ssg": 7, "sgj": 8, "wkj": 8, "zzj": 9, "dpl": 10, "klj": 11}
MAP_NAME = {6: "地圖七 龍脈十八洞墓園", 7: "地圖八", 8: "地圖九", 9: "地圖十", 10: "地圖十一", 11: "地圖十二（終章）"}
# 難度：沿用 so_data 尺（LV_BASE 每關 +4、LV_RING 圈加成），地圖七起繼續遞增（高過地圖六）
LV_BASE = [1.0, 5.0, 9.0, 13.0, 17.0, 21.0, 25.0, 29.0, 33.0, 37.0, 41.0, 45.0]
LV_RING = [0.0, 1.0, 2.5, 4.0]
SHOW_LV = 10   # 顯示等級：每關 +10（同 zones.json 一樣：第 1 關 Lv1～12）
RING_SHOW = [(0, 2), (3, 5), (6, 8), (9, 11)]

# ---------------- 名單 ----------------
IDS = []
for lg in sorted(S.LEG, key=lambda x: S.LEG[x]["order"]):
    if lg == "jsj": IDS += ["lg_jsj_" + x for x in ("yayi", "guan", "wangye", "wutou", "jiangchen")]
    else: IDS += ["lg_%s_%s" % (lg, s) for s in S.SLOTS]
chk(len(IDS) == 54 and sorted(IDS) == sorted(S.U), "54 隻名單唔對", sorted(set(IDS) ^ set(S.U)))
for k in IDS: chk(os.path.exists(os.path.join(ROOT, "assets", "spr", k + ".webp")), k, "冇圖 assets/spr/%s.webp" % k)

NG1 = J(os.path.join(ROOT, "data", "nat", "newghost.json")); NG2 = J(os.path.join(ROOT, "data", "nat", "newghost2.json"))
chk(not (set(IDS) & set(NG2["ROSTER"])), "同名冊撞 id")

EXIST = set()
def strings(o):
    if isinstance(o, str): EXIST.add(o.strip())
    elif isinstance(o, dict):
        for v in o.values(): strings(v)
    elif isinstance(o, list):
        for v in o: strings(v)
for p in glob.glob(os.path.join(ROOT, "data", "**", "*.json"), recursive=True):
    if os.path.basename(p) == "legion.json": continue
    try: strings(J(p))
    except Exception: pass
STR_RE = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
for p in glob.glob(os.path.join(ROOT, "**", "*.gd"), recursive=True):
    if "/.godot/" in p: continue
    for m in STR_RE.finditer(open(p, encoding="utf-8").read()): EXIST.add(m.group(1).strip())
GH_ALL = {}
for p in ("data/core.json", "data/n30_data.json", "data/nat/patrol_ghosts.json"):
    GH_ALL.update(J(os.path.join(ROOT, p)).get("GHOSTS", {}))
GH_ALL.update(NG1["GHOSTS"]); GH_ALL.update(NG2["GHOSTS"])
NAMES = {v.get("name"): k for k, v in GH_ALL.items()}
ETN = {}
for p in ("data/core.json", "data/nat/newghost.json", "data/nat/newghost2.json"):
    for k, v in J(os.path.join(ROOT, p)).get("ENEMY_T", {}).items(): ETN[v[2]] = k
BANNED = ["盂蘭", "盂兰", "超度", "狐狸精", "唐僧", "佛教", "梵語", "判官", "神父", "和尚", "道士", "佛祖", "真主", "耶穌", "上帝", "小朋友", "細路", "兒童", "小孩", "符", "香爐", "神位", "佛像", "焰口", "14K", "和勝和", "新義安", "日本鬼子", "支那"]
TAGS10 = CD.TAGS; MECH13 = CD.MECHS
PRIMS = set("dmg dot execute chain splash mark pierce down air push pull stun silence interrupt slow flee taunt heal hot shield drain guard immune cleanse revive buff energy anti_air reveal armor_break shield_break dispel banish sap wound dash stealth summon coin zone charm confuse".split())
SEL = {"near", "far", "low", "strong", "back", "caster", "flyer", "stealth", "boss", "self", "ally_low", "allies", "all_r"}
SIGS = {}; ASIG = {}
for k, v in list(CD.AB.items()) + list(NG1.get("ABIL", {}).items()) + list(NG2.get("ABIL", {}).items()):
    if isinstance(v, dict) and isinstance(v.get("act"), dict):
        ASIG.setdefault(json.dumps([v["act"].get("tg", {}), sorted(f["p"] for f in v["act"]["fx"])], sort_keys=True, ensure_ascii=False), k)
        try: SIGS.setdefault(CD.sig(v), k)
        except Exception: pass

def enemy_of(sysn, sc):
    f = S.SYS[sysn]
    fe = [x for x in (f[0], f[1]) if x != sc]
    im = [f[2]] + ([sc] if sc in (f[0], f[1]) else [])
    why = ["怕%s：%s" % (x, f[3] if x == f[0] else f[4]) for x in fe] + ["唔怕%s：%s" % (f[2], f[5])]
    return fe, im, why

out = {"v": 1, "note": "legion 線：八大軍團 54 隻＋每軍團 3 營據點（tools/legion/build_legion.py 由 lg_src.py 生成，唔好手改；hm／am 由 apply_bal.py 套 bal_scale.json）",
       "GHOSTS": {}, "SKILLS": {}, "ENEMY_T": {}, "ABIL": {}, "ENEMY": {}, "PIN": {}, "ART": {}, "LANG_ZH": {}, "WISH": {}, "UNIT": {},
       "LEG": {}, "CAMPS": {}, "ROSTER3": IDS, "CAMP_ON": False, "MAP_OF": MAP_OF}
SAYS = {}; ZHS = {}
WISH_RES = {"egs": "buns", "sgj": "planks", "zzj": "coins", "jsj": "rice", "dpl": "coins", "klj": "planks", "wkj": "wood", "ssg": "buns"}
WISH_SAY = {"egs": ["有壽包就得，飽咗先講其他。", "有壽包就好，吃飽了再說。"], "sgj": ["畀幾塊棺材板我浮吓。", "給我幾塊棺材板浮一浮。"],
            "zzj": ["燒多疊冥幣落嚟，紙紮都要供車。", "多燒一疊冥幣下來，紙紮也要供車。"], "jsj": ["有糯米就最好，唔係我跳唔穩。", "有糯米就最好，不然我跳不穩。"],
            "dpl": ["規矩係咁：先交數，後入會。", "規矩是這樣：先交錢，後入會。"], "klj": ["棺材板啱啱好做藤牌。", "棺材板剛好做藤牌。"],
            "wkj": ["畀啲木頭我補返隻船。", "給我些木頭補回我的船。"], "ssg": ["壽包都得，唔使骨頭。", "壽包也行，不用骨頭。"]}
def lang(y, z):
    if y and z and y != z: out["LANG_ZH"][y] = z

for k in IDS:
    d = S.U[k]; lg = k.split("_")[1]; L = S.LEG[lg]; slot = d["slot"]; SL = S.SLOT[slot]
    sysn = d.get("sys", L["sys"])
    sc = d["sc"]
    chk(sysn in S.SYS and sc in S.SC, k, "系／嚇法")
    fe, im, why = enemy_of(sysn, sc)
    chk(len(fe) == 2 and len(im) == 1, k, "要怕兩種、唔怕一種（嚇法唔可以係本系怕嘅）", sc, fe, im)
    chk(all(m in MECH13 for m in d["mech"]) and len(d["mech"]) <= 3, k, "機制", d["mech"])
    if slot in ("boss", "boss2", "king"): chk(2 <= len(d["mech"]) <= 3, k, "頭目／王要 2–3 個機制", d["mech"])
    say = d["say"]; chk(isinstance(say, list) and len(say) == 2 and say[0] and say[1], k, "台詞 [粵, 中]")
    chk(say[0].strip() not in EXIST, k, "台詞撞現有字串", say[0])
    chk(say[0] not in SAYS, k, "台詞同軍團另一隻撞", SAYS.get(say[0]))
    chk(say[1] not in ZHS or say[1] == say[0], k, "中文台詞同軍團另一隻撞", ZHS.get(say[1]))
    SAYS[say[0]] = k; ZHS[say[1]] = k
    for w in BANNED:
        for txt in (say[0], say[1], d["title"], d["trait"], d["name"], d["skill"]["desc"], L["lore"]): chk(w not in txt, k, "紅線字", w)
    chk(d["name"] not in NAMES and d["name"] not in ETN, k, "名同現有撞", NAMES.get(d["name"]), ETN.get(d["name"]))
    lore = L["lore"]
    out["GHOSTS"][k] = {"name": d["name"], "title": d["title"], "q": "名", "base": SL["base"], "range": "ranged" if d["rng"] != "近" else "melee",
                        "trait": d["trait"], "lore": lore, "say": say[0], "lg": lg, "reg": {"wkj": "日", "ssg": "他"}.get(lg, "中")}
    lang(say[0], say[1])
    out["PIN"][k] = SL["pin"]
    out["ART"][k] = {"spr": k, "h": SL["h"], "solid": bool(d.get("solid", True))}
    act = json.loads(json.dumps(d["act"])); act.setdefault("cost", 100); act.setdefault("cast", 0.45)
    pas = json.loads(json.dumps(d.get("pas", [])))
    for f in act["fx"]: chk(f["p"] in PRIMS, k, "未知積木", f["p"])
    for p in pas:
        for f in p["fx"]: chk(f["p"] in PRIMS, k, "未知積木（被動）", f["p"])
        p.setdefault("star", 0)
    chk(act["tg"]["sel"] in SEL, k, "目標選擇器", act["tg"]["sel"])
    ab = {"sys": sysn, "sc": [S.SC[sc]], "rng": S.RNG[d["rng"]], "role": S.ROLE_TO_AB[slot], "act": act, "pas": pas, "say": say}
    if d.get("aura"): ab["aura"] = json.loads(json.dumps(d["aura"]))
    tags = sorted(CD.derive(ab), key=TAGS10.index)
    chk(2 <= len(tags) <= 3, k, "標籤 2–3 個", tags)
    ab["tags"] = tags
    a1 = json.dumps([act["tg"], sorted(f["p"] for f in act["fx"])], sort_keys=True, ensure_ascii=False)
    chk(a1 not in ASIG, k, "主動技（目標＋積木）同", ASIG.get(a1), "重複"); ASIG[a1] = k
    s2 = CD.sig(ab); chk(s2 not in SIGS, k, "能力簽名（主動＋被動）同", SIGS.get(s2), "重複"); SIGS[s2] = k
    out["ABIL"][k] = ab
    sk = dict(d["skill"]); out["SKILLS"][k] = sk
    out["ENEMY_T"][k] = [SL["et"][0], SL["et"][1], d["name"]]
    en = {"sys": sysn, "sc": [S.SC[sc]], "fear": [S.SC[x] for x in fe], "imm": [S.SC[x] for x in im], "why": why, "mech": d["mech"], "tier": SL["tier"],
          "kind": "named", "recruit": True, "use_abil": True, "ch": MAP_OF[lg] + 1, "lg": lg, "tags": []}
    sm = [f.get("k") for p in pas for f in p["fx"] if f["p"] == "summon"] + [f.get("k") for f in act["fx"] if f["p"] == "summon"]
    if "召喚" in d["mech"]:
        chk(sm and sm[0] in IDS, k, "召喚機制要有同軍團召喚物（sum_k）")
        en["sum_k"] = sm[0] if sm else ""
    out["ENEMY"][k] = en
    out["UNIT"][k] = {"lg": lg, "slot": slot, "role": SL["n"], "rng": S.RNG[d["rng"]]}
    out["WISH"][k] = [WISH_RES[lg]] + WISH_SAY[lg]

# 體型：頭目 ≈ ×1.25、王 ≈ ×1.5（雜兵高度）
for k in IDS:
    s = out["UNIT"][k]["slot"]; h = out["ART"][k]["h"]
    if s in ("boss", "boss2"): chk(h >= S.H0 * 1.2, k, "頭目要大一號", h)
    if s == "king": chk(h >= S.H0 * 1.45, k, "王要再大一號", h)

# ---------------- 軍團＋據點 ----------------
for lg, L in S.LEG.items():
    ks = [k for k in IDS if k.split("_")[1] == lg]
    by = {out["UNIT"][k]["slot"]: k for k in ks}
    ci = MAP_OF[lg]
    out["LEG"][lg] = {"name": L["name"], "sys": L["sys"], "theme": L["theme"], "lore": L["lore"], "hint": L["hint"], "order": L["order"],
                      "units": ks, "ci": ci, "map": MAP_NAME[ci], "camps": ["lg_%s_%d" % (lg, i + 1) for i in range(3)]}
    T = S.CAMP_T_JSJ if lg == "jsj" else S.CAMP_T
    for i, t in enumerate(T):
        cid = "lg_%s_%d" % (lg, i + 1); r = t["ring"]
        en = [by[s] for s in t["en"]]
        chk(all(s in by for s in t["en"]), cid, "兵種位唔齊")
        cap = [1, 1, 2, 3][r - 1]
        mk = [out["ENEMY"][k]["mech"][:cap] for k in en]
        p = LV_BASE[ci] + LV_RING[r - 1] + 0.8
        lo, hi = RING_SHOW[r - 1]
        out["CAMPS"][cid] = {"id": cid, "lg": lg, "tier": i + 1, "n": t["n"], "ci": ci, "ring": r, "p": p, "lv": ci * SHOW_LV + 1 + hi,
                             "en": en, "hm": [1.0] * len(en), "am": [1.0] * len(en), "mk": mk, "guard": by[t["guard"]],
                             "co": [by[s] for s in t["co"]], "need": ("lg_%s_%d" % (lg, i)) if i > 0 else "", "bal": 1.0,
                             "pos": None, "route": None, "dir": ""}
        chk(by[t["guard"]] == en[-1], cid, "駐守（主魂）要係最後一隻")
    got = set()
    for i in range(3):
        c = out["CAMPS"]["lg_%s_%d" % (lg, i + 1)]; got |= {c["guard"]} | set(c["co"])
    chk(got == set(ks), lg, "每隻兵種都要有魂魄來源（主魂）", set(ks) - got)
    chk(out["CAMPS"]["lg_%s_3" % lg]["guard"] == by["king"], lg, "王營駐守＝軍團王")
# 難度遞增：地圖七起每張圖高過上一張；圖內王營最強
ps = sorted({(c["ci"], c["p"]) for c in out["CAMPS"].values()})
chk(min(c["p"] for c in out["CAMPS"].values()) > LV_BASE[5] + LV_RING[3], "軍團據點要難過地圖六最外圈")

if ERR:
    print("校驗失敗：")
    for e in ERR: print("  -", e)
    sys.exit(1)
# 保留 apply_bal.py 已套嘅 hm／am／bal（重跑生成唔洗走平衡）
if os.path.exists(OUT):
    try:
        old = J(OUT).get("CAMPS", {})
        for cid, c in out["CAMPS"].items():
            o = old.get(cid)
            if o and o.get("en") == c["en"]:
                for f in ("hm", "am", "bal", "pos", "route", "dir"): c[f] = o.get(f, c[f])
    except Exception: pass
json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
from collections import Counter
tc = Counter(t for a in out["ABIL"].values() for t in a["tags"])
mc = Counter(m for e in out["ENEMY"].values() for m in e["mech"])
print("wrote", OUT, "units", len(out["GHOSTS"]), "camps", len(out["CAMPS"]), "pin", dict(Counter(out["PIN"].values())))
print("標籤：" + "、".join("%s %d" % (t, tc[t]) for t in TAGS10))
print("機制：", dict(mc))
print("系：", dict(Counter(a["sys"] for a in out["ABIL"].values())))
