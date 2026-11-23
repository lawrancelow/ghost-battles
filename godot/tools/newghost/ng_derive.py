# [newghost] 標籤推導：抄自 tools/cdata/build_cdata.py derive()（cdata_test.gd _derive 同一套）；改規則要三處一齊改
import json,sys
MULTI = {"circle", "self_circle", "cone", "line", "chain"}
def prims(e):
    out = []
    def walk(fx):
        for x in fx:
            out.append(x)
            if x["p"] == "zone": walk(x.get("fx", []))
    walk(e["act"]["fx"])
    for p in e.get("pas", []): walk(p["fx"])
    if e.get("aura"): walk(e["aura"]["fx"])
    return out
def derive(e):
    t = set(); ps = prims(e); act = e["act"]; tg = act["tg"]
    ids = {x["p"] for x in ps}
    if e["rng"] >= 150: t.add("遠")
    if ids & {"down", "pull"}: t.add("拉")
    if tg.get("shape") in MULTI or any(x["p"] == "zone" for x in act["fx"]): t.add("掃")
    if any(x["p"] == "dmg" and int(x.get("hits", 1)) >= 2 for x in act["fx"]) or ids & {"shield_break", "armor_break"}: t.add("破")
    single = tg.get("shape") in (None, "single") and tg.get("sel") not in ("allies", "self")
    if (single and any(x["p"] == "dmg" and int(x.get("hits", 1)) < 2 and (x["mult"][0] if isinstance(x["mult"],list) else x["mult"]) >= 1.7 for x in act["fx"])) or ids & {"execute", "dash"}: t.add("刺")
    if ids & {"sap", "wound", "silence", "interrupt"}: t.add("削")
    if ids & {"drain", "heal", "hot"}: t.add("回")
    if "reveal" in ids or "light" in e["sc"]: t.add("照")
    if ids & {"taunt", "guard"} or (e.get("aura") and e["aura"]["side"] == "ally" and any(x["p"] == "immune" and set(x.get("tags", [])) & {"fear_aura", "confuse"} for x in e["aura"]["fx"])): t.add("定")
    if "banish" in ids: t.add("收")
    return t
