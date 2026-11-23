# [soul2] 名鬼圖鑑資料：data/nat/codex.json（101 格次序、系、嚇法、機制、應對標籤、章、地區、出處備註、品級後備）
# 來源：/home/claude/bs/counter_tool/roster_data.py（定案名冊）、soul 線 soul.json（PIN）、cdata 線 counter.json（新鬼名、sys 表）、abcore abil.json（TAGS）
# 重跑：python3 tools/soul/codex_build.py  （喺 godot 目錄）
import json, os, sys
BS = "/home/claude/bs/counter_tool/roster_data.py"
R = {}
def add(i, s, a, m, ch, rg, t, tg="", note="", name=None, new=False, recruit=True, rng=None):
    R[i] = dict(id=i, sys=s, sc=a.split("+"), mech=[x for x in m.split(",") if x], ch=ch, t=t,
                tags=[x for x in tg.split(",") if x], note=note, name=name or "", new=new)
src = open(BS, encoding="utf-8").read()
src = src.split("# 雜兵")[0]
exec(src, {"add": add})
core = json.load(open("data/core.json", encoding="utf-8"))
GH = core["GHOSTS"]
def jl(p):
    try: return json.load(open(p, encoding="utf-8"))
    except Exception: return {}
SOULJ = jl("/home/claude/wt/soul/godot/data/nat/soul.json") or jl("data/nat/soul.json")
CT = jl("/home/claude/wt/cdata/godot/data/nat/counter.json") or jl("data/nat/counter.json")
AB = jl("/home/claude/wt/abcore/godot/data/abil.json") or jl("data/abil.json")
# 劇情鬼／冇入名冊嘅現有名鬼
extra = {"afu": ("主", "吹氣", 0), "xiaozhi": ("紙紮", "紙", 1), "mengpo": ("官", "紙", 6), "tianhua": ("魂", "鬼臉", 4)}
for k, (s, a, ch) in extra.items():
    if k not in R: R[k] = dict(id=k, sys=s, sc=[a], mech=[], ch=ch, t="T4", tags=[], note="", name="", new=False)
# 新鬼名：counter.json new 優先（例如「狐妖」「紙紮跑車」「陰司審批官」定案名）
for k, v in (CT.get("new") or {}).items():
    if k in R and v.get("name"): R[k]["name"] = v["name"]
# counter.json new 係新鬼定案名單（26）：名單外嘅舊新鬼拿走、名單內冇嘅補入（例如 Teke Teke、陰司審批官 nw_shenpi）
CTN = CT.get("new") or {}
ALIAS = {"nw_shenpi": "nw_panguan"}   # soul 線 PIN 用舊 id
if CTN:
    for k in [k for k in R if R[k]["new"] and k not in CTN]: R.pop(k)
    TSYS = {"T1": 1, "T2": 2, "T3": 3}
    for k, v in CTN.items():
        if k in R: continue
        base = R.get(ALIAS.get(k, ""), {})
        R[k] = dict(id=k, sys=v.get("sys", base.get("sys", "魂")), sc=[CT.get("scares", {}).get(v.get("sc", ""), v.get("sc", "")) or "鬼臉"], mech=v.get("mech", []), ch=int(v.get("ch", 1)),
                    t=base.get("t", "T2"), tags=v.get("tags", []), note=v.get("note", "") or base.get("note", ""), name=v.get("name", k), new=True)
FIX_NAME = {"nw_huli": "狐妖", "nw_zzcar": "紙紮跑車", "nw_panguan": "陰司審批官", "nw_shenpi": "陰司審批官"}
for k, n in FIX_NAME.items():
    if k in R: R[k]["name"] = n
R.pop("nw_sundel", None)   # 老闆 20:24 定案：去掉
# [roster2] 第二批新名鬼 30 隻（data/nat/newghost2.json）：同 101 格一齊按章、品排
N2 = jl("data/nat/newghost2.json")
for k in N2.get("ROSTER2", []):
    e = N2["ENEMY"][k]
    R[k] = dict(id=k, sys=e["sys"], sc=[CT.get("scares", {}).get(e["sc"][0], e["sc"][0])], mech=e["mech"], ch=int(e["ch"]), t="T%d" % int(e["tier"]),
                tags=N2["ABIL"][k]["tags"], note="第二批", name=N2["GHOSTS"][k]["name"], new=True)
REG = {
    "中": "afu xiaozhi eguiking laojiang mengpo baiwu heiwu tianhua niutou mamian n30_qionggui n30_danxiao n30_maoshi n30_yangui n30_jiugui n30_dugui n30_guhangui n30_taozhai n30_diaosi n30_wutou n30_changgui n30_guixinniang n30_baigujing n30_shanxiao n30_hanba pg_tuimo pg_songding pg_ji nw_guihuo nw_huli nw_baimao nw_buhuagu nw_daqiang nw_ganshi nw_huapi nw_shejing nw_tisi nw_panguan nw_toutai nw_zzphone nw_zzcar nw_zzhouse nw_kuaidi nw_yeleng_guard nw_yeleng_sales",
    "馬": "toyol pontianak pocong penanggal n30_pelesit n30_polong n30_jenglot n30_hantugalah n30_jerangkung n30_bunian n30_hanturaya n30_genderuwo nw_bajang",
    "泰": "n30_phiam n30_maenak n30_tikbalang n30_aswang n30_churel n30_vetala nw_krahang nw_kapre",
    "日": "n30_kasaobake n30_chochin n30_kappa n30_nopperabo n30_rokurokubi n30_kuchisake n30_yukionna n30_hannya n30_gashadokuro nw_ameonna nw_honeonna nw_tiangou",
    "意": "n30_zipai n30_xiaosi n30_yesi n30_shidu n30_daji n30_xiasi n30_chehuo n30_yezi n30_liulian n30_zhongshu n30_chengsi n30_shedu n30_diansi n30_dongsi n30_leipi n30_xiangcai pg_ex pg_landlady",
}
REG["中"] += " nw_guisihknai nw_nian nw_wangliang nw_zhizhama nw_paakbok nw_bifang nw_qiongqi nw_mosinna nw_niexiaoqian nw_luotoumin nw_shen nw_guiamngaan nw_dikseigwai"   # [roster2]
REG["馬"] += " nw_harimau nw_banaspati nw_bonceng"
REG["泰"] += " nw_nangtani nw_manananggal nw_nuno"
REG["日"] += " nw_kamaitachi nw_nurikabe nw_akaname nw_makuragaeshi nw_dodomeki nw_ungaikyo nw_jinmenken nw_ushioni nw_nekomata"
reg = {}
for r, ks in REG.items():
    for k in ks.split(): reg[k] = r
PINS = dict(SOULJ.get("PIN", {}))
PINS.update(N2.get("PIN", {}))   # [roster2]
TPIN = {"T1": "凡", "T2": "靈", "T3": "煞", "T4": "王"}
# 次序：阿福 → 劇情鬼 → 按章、按品（凡→王）、名冊次序
order = ["afu"] + [k for k in R if k != "afu"]
ORD0 = list(order)
PO = {"凡": 0, "靈": 1, "煞": 2, "王": 3}
story = SOULJ.get("STORY_JOIN", [])
def key(k):
    d = R[k]
    if k == "afu": return (-1, 0, 0)
    return (d["ch"], PO.get(PINS.get(k, TPIN.get(d["t"], "凡")), 0), ORD0.index(k))
order.sort(key=key)
out = []
for i, k in enumerate(order):
    d = R[k]
    g = GH.get(k, {})
    pin = "主" if k == "afu" else PINS.get(k, PINS.get(ALIAS.get(k, ""), TPIN.get(d["t"], "凡")))
    out.append({"k": k, "no": i, "name": d["name"] or g.get("name", k), "sys": d["sys"], "sc": d["sc"][0], "mech": d["mech"],
                "tags": d["tags"], "ch": d["ch"], "reg": reg.get(k, "他"), "note": d["note"], "pin": pin, "new": bool(d["new"]) or k not in GH})
SYS = {}
for s, v in (CT.get("sys") or {}).items(): SYS[s] = {"fear": v.get("fear", []), "imm": v.get("imm", "")}
SC = {a: b for a, b in (CT.get("scares") or {}).items()} if isinstance(CT.get("scares"), dict) else {}
TAGS = {k: {"n": v.get("n", k), "c": v.get("c", "#888"), "desc": v.get("desc", "")} for k, v in (AB.get("TAGS") or {}).items()}
MECH = {}
for k, v in (AB.get("MECH") or {}).items():
    if isinstance(v, dict): MECH[k] = {"desc": v.get("desc", v.get("d", "")), "counter": v.get("counter", [])}
res = {"v": 1, "note": "soul2 線：名鬼圖鑑 131 格（tools/soul/codex_build.py 產生；roster2 加第二批 30）。pin 只係後備，品級以 soul.json PIN 為準；sys/tags 只係後備，以 abil.json 為準。",
       "LIST": out, "SYS": SYS, "SC": SC, "TAGS": TAGS, "MECH": MECH,
       "REG": {"中": "中國", "馬": "馬來／印尼", "泰": "泰國／菲律賓／印度", "日": "日本", "意": "原創意外鬼", "他": "其他"}}
json.dump(res, open("data/nat/codex.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
from collections import Counter
print(len(out), Counter(x["pin"] for x in out), Counter(x["sys"] for x in out), sum(1 for x in out if x["new"]))
