#!/usr/bin/env python3
# [yinbing] 陰兵組：生成 data/nat/yinbing.json（陰兵 4 兵種 × 4 階級 = 16 款外觀＋數值）。
# 改數值只改呢個檔頂部表，再跑：python3 tools/yinbing_build.py
# 設計稿：/home/claude/art/out/HC_YinBing_Design.md
#
# 規矩（本檔自己檢查，唔過就唔寫檔）：
#   1. 16 格齊（兵種 × 階級），每格有外觀、標誌兵器、圖鍵
#   2. 階級 ↔ 兵器檔★ 覆蓋 ★0–6，冇空、冇重疊
#   3. 兵器名唔可以同裝備表（equip.json 名鬼裝 eq＋遊魂兵裝 ml）同名，亦唔可以互相包含（設計組正喺 equip-list 改同名問題）
#   4. 16 個兵器名互相唔重複
#   5. 卫兵＝現版外觀：衛兵四格嘅圖鍵 fallback 一律係現有 soldier_*
#   6. 預設編制比例加埋 = 1；兵種數值按預設編制加權平均 ≈ 1（第一期唔郁平衡）
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
OUT = os.path.join(ROOT, "data", "nat", "yinbing.json")
# 讀裝備名嚟查撞名：先讀設計組 equip-list 分支最新（唔改佢），冇就讀本分支
EQ_PATHS = ["/home/claude/wt/equiplist/godot/data/nat/equip.json", os.path.join(ROOT, "data", "nat", "equip.json")]

# ======================= 階級 =======================
# star：兵器檔★範圍（含頭尾）；k：階級倍率（第一期 phase1＝只換外觀，倍率唔生效；第二期平衡線調好先開）
RANKS = [
    {"id": "za",   "n": ["雜兵", "雜兵"], "star": [0, 1], "k": 0.85, "look": "簡陋：冇頭盔或者頂住個鍋蓋，補丁破布衫，草繩做腰帶"},
    {"id": "shi",  "n": ["士兵", "士兵"], "star": [2, 3], "k": 0.95, "look": "同樣簡陋但整齊：統一布軍服、布頭巾、棉夾背心釘幾塊皮"},
    {"id": "wei",  "n": ["衛兵", "衛兵"], "star": [4, 5], "k": 1.00, "look": "現版陰兵：鉚釘鐵盔紅纓、紙紮札甲、紅腰帶"},
    {"id": "qin",  "n": ["親兵", "親兵"], "star": [6, 6], "k": 1.12, "look": "精幹、裝備精良：黑鐵札甲包銅邊、大披膊、護頸盔高紅纓、深紅披風"},
]

# ======================= 兵種 =======================
# hp/atk：對現有陰兵公式（hp=(90+14·lv)·tb、atk=(9+2.2·lv)·tb）嘅倍率
# range：戰場射程（rts_sim：>60 就當遠程，排後行、射飛彈）；spd：行速；row：排位（0 前、1 中、2 後）
# heal：醫療兵每 heal.t 秒醫身邊 heal.r 內血最少嘅一隊我方陰兵，回佢最大血 heal.pct（× 階級倍率）；只醫陰兵／遊魂兵，唔醫名鬼
CLASSES = [
    {"id": "jin",  "n": ["刀盾手", "刀盾手"], "role": ["近戰", "近戰"], "hp": 1.25, "atk": 0.95, "range": 38.0, "spd": 50.0, "row": 0, "mix": 0.40,
     "d": "頂正面，盾擋傷害；敵人優先打佢", "gear_slot": "盾（穿戴，顯示喺手臂）＋單手刀（漂浮）"},
    {"id": "zhong", "n": ["長兵手", "長兵手"], "role": ["中距", "中距"], "hp": 0.95, "atk": 1.20, "range": 56.0, "spd": 52.0, "row": 1, "mix": 0.30,
     "d": "企喺刀盾手後面，長兵越過前排戳", "gear_slot": "長兵（漂浮）"},
    {"id": "yuan", "n": ["弓弩手", "弓弩手"], "role": ["遠程", "遠程"], "hp": 0.65, "atk": 1.10, "range": 150.0, "spd": 52.0, "row": 2, "mix": 0.20,
     "d": "後排放箭，血薄；要前排保住", "gear_slot": "弓／弩（漂浮）＋箭袋（穿戴，背脊）"},
    {"id": "yi",   "n": ["醫護兵", "醫護兵"], "role": ["醫療", "醫療"], "hp": 0.80, "atk": 0.30, "range": 110.0, "spd": 52.0, "row": 2, "mix": 0.10,
     "heal": {"t": 3.0, "r": 160.0, "pct": 0.05},
     "d": "唔打架，幫前排補血；冇醫護兵就冇回血", "gear_slot": "藥具（穿戴：藥箱揹喺背脊／葫蘆掛腰）"},
]

# ======================= 16 格：每兵種每階級嘅標誌兵器＋外觀重點 =======================
# w：兵器名（粵、中）；shape：漂浮兵器形狀鍵（eq_art 之後加圖）；worn：穿戴件（盾／箭袋／藥具，跟圖畫）；look：外觀重點（交美術）
GEAR = {
 "jin": {
  "za":  {"w": ["崩口短刀", "崩口短刀"], "worn": ["砧板盾", "砧板盾"], "shape": "knife_chip",
          "look": "頭頂綁個凹咗嘅鐵鍋蓋；補丁灰啡破布衫、草繩腰帶、一隻手纏爛布；舊血漬"},
  "shi": {"w": ["粗鐵腰刀", "粗鐵腰刀"], "worn": ["竹編圓盾", "竹編圓盾"], "shape": "saber_iron",
          "look": "藍黑布軍服、布頭巾、棉夾背心釘幾塊皮、紅布腰帶綁整齊"},
  "wei": {"w": ["制式雁翎刀", "制式雁翎刀"], "worn": ["包鐵木盾", "包鐵木盾"], "shape": "saber_yanling",
          "look": "現版：鉚釘鐵盔紅纓、啡色札甲、披膊、紅腰帶、八字鬚"},
  "qin": {"w": ["精鋼橫刀", "精鋼橫刀"], "worn": ["銅釘獸面盾", "銅釘獸面盾"], "shape": "saber_hengdao",
          "look": "黑鐵札甲包銅邊、大披膊、護腕、護頸盔高紅纓、深紅披風"},
 },
 "zhong": {
  "za":  {"w": ["削尖竹竿", "削尖竹竿"], "worn": None, "shape": "bamboo_pike",
          "look": "鍋蓋或者亂髮髻；破布衫捲起衫袖、赤膊手臂纏布"},
  "shi": {"w": ["白蠟木槍", "白蠟木槍"], "worn": None, "shape": "spear_wax",
          "look": "藍黑布軍服、布頭巾、皮護臂、綁腿布（煙尾上方）"},
  "wei": {"w": ["制式長矛", "制式長矛"], "worn": None, "shape": "spear_std",
          "look": "現版：鉚釘鐵盔紅纓、啡色札甲（現版陰兵本身就係揸矛）"},
  "qin": {"w": ["鳳嘴長刀", "鳳嘴長刀"], "worn": None, "shape": "glaive_fengzui",
          "look": "黑鐵札甲包銅邊、護臂、護頸盔高紅纓、深紅披風；體格最壯"},
 },
 "yuan": {
  "za":  {"w": ["投石索", "投石索"], "worn": ["石仔布袋", "石仔布袋"], "shape": "sling",
          "look": "冇頭盔、頭綁爛布條；破布衫、腰掛一袋石仔"},
  "shi": {"w": ["竹片短弓", "竹片短弓"], "worn": ["竹箭筒", "竹箭筒"], "shape": "bow_bamboo",
          "look": "藍黑布軍服、斗笠形布帽、單邊皮護臂、背竹箭筒"},
  "wei": {"w": ["木胎角弓", "木胎角弓"], "worn": ["皮箭囊", "皮箭囊"], "shape": "bow_horn",
          "look": "現版鐵盔紅纓＋札甲（輕一級：冇披膊）、背皮箭囊"},
  "qin": {"w": ["鐵臂強弩", "鐵臂強弩"], "worn": ["銅扣箭匣", "銅扣箭匣"], "shape": "xbow_iron",
          "look": "黑鐵輕札甲包銅邊、護頸盔紅纓、深紅短披風、腰掛銅扣箭匣"},
 },
 "yi": {
  "za":  {"w": ["舊布繃帶捲", "舊布繃帶捲"], "worn": ["爛布藥包", "爛布藥包"], "shape": "bandage_roll",
          "look": "頭頂鍋蓋、破布衫、斜孭一個補丁布包、頸掛幾條繃帶"},
  "shi": {"w": ["草藥葫蘆", "草藥葫蘆"], "worn": ["腰間葫蘆", "腰間葫蘆"], "shape": "herb_gourd",
          "look": "藍黑布軍服、白布頭巾、白布圍裙、腰掛葫蘆"},
  "wei": {"w": ["木製藥箱", "木製藥箱"], "worn": ["揹式木藥箱", "揹式木藥箱"], "shape": "medbox_wood",
          "look": "現版鐵盔紅纓＋札甲、白布袖套、背木藥箱（冇紅十字、冇任何符號）"},
  "qin": {"w": ["銅角藥箱", "銅角藥箱"], "worn": ["銅角揹箱", "銅角揹箱"], "shape": "medbox_brass",
          "look": "黑鐵輕札甲包銅邊、護頸盔紅纓、深紅披風、背銅角藥箱、腰掛針包"},
 },
}

# ======================= 檢查 =======================
def fail(msg):
    print("❌ " + msg); sys.exit(1)

def eq_names():
    for p in EQ_PATHS:
        if os.path.exists(p):
            d = json.load(open(p, encoding="utf-8"))
            items = d.get("ITEMS", {})
            out = set()
            it = items.values() if isinstance(items, dict) else items
            for v in it:
                n = v.get("n") if isinstance(v, dict) else None
                if isinstance(n, list):
                    for x in n: out.add(str(x))
                elif isinstance(n, str): out.add(n)
            return p, out
    return None, set()

def check():
    # 1. 16 格
    for c in CLASSES:
        for r in RANKS:
            g = GEAR.get(c["id"], {}).get(r["id"])
            if not g or not g.get("w") or not g.get("look") or not g.get("shape"): fail("缺格 %s/%s" % (c["id"], r["id"]))
    # 2. ★0–6 覆蓋
    cov = []
    for r in RANKS: cov += list(range(r["star"][0], r["star"][1] + 1))
    if sorted(cov) != list(range(7)): fail("階級★覆蓋唔啱：%s" % cov)
    # 4. 互相唔重複（兵器＋穿戴件）
    names = []
    for c in CLASSES:
        for r in RANKS:
            g = GEAR[c["id"]][r["id"]]
            names.append(g["w"][1])
            if g.get("worn"): names.append(g["worn"][1])
    if len(set(names)) != len(names): fail("陰兵兵器／穿戴名重複")
    # 3. 唔撞裝備表
    p, eqn = eq_names()
    if not eqn: fail("讀唔到 equip.json 嚟查撞名")
    bad = []
    for n in names:
        for e in eqn:
            if n == e or (len(e) >= 2 and e in n) or (len(n) >= 2 and n in e): bad.append((n, e))
    if bad: fail("同裝備表撞名／互相包含：%s" % bad)
    # 6. 編制
    mix = sum(c["mix"] for c in CLASSES)
    if abs(mix - 1.0) > 1e-6: fail("編制比例加埋唔係 1：%s" % mix)
    hp = sum(c["mix"] * c["hp"] for c in CLASSES); atk = sum(c["mix"] * c["atk"] for c in CLASSES)
    if abs(hp - 1.0) > 0.03 or abs(atk - 1.0) > 0.03: fail("預設編制加權唔接近 1：血 %.3f 攻 %.3f" % (hp, atk))
    return p, len(eqn), names, hp, atk

def build():
    p, neq, names, hp, atk = check()
    cells = {}
    for c in CLASSES:
        for r in RANKS:
            g = GEAR[c["id"]][r["id"]]
            key = "yb_%s_%s" % (c["id"], r["id"])
            cells[key] = {
                "cls": c["id"], "rank": r["id"],
                "n": [r["n"][0] + "・" + c["n"][0], r["n"][1] + "・" + c["n"][1]],
                "w": g["w"], "worn": g.get("worn"), "shape": g["shape"], "look": g["look"],
                # 圖鍵：assets/spr/<key>_<pose>.webp（stand/walk/salute/attack）；冇圖就用 fb（衛兵＝現版 soldier）
                "spr": key, "fb": "soldier",
            }
    out = {
        "v": 1,
        "phase": 1,   # 1＝只換外觀（數值倍率唔生效）；2＝兵種／階級數值生效
        "RANKS": RANKS,
        "CLASSES": CLASSES,
        "CELLS": cells,
        "POSES": ["stand", "walk", "salute", "attack"],
        "MIX_DEFAULT": {c["id"]: c["mix"] for c in CLASSES},
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f: json.dump(out, f, ensure_ascii=False, indent=1)
    print("✅ 寫咗 %s：%d 格；撞名檢查對 %s（%d 個名）通過；兵器＋穿戴 %d 個名互不重複" % (OUT, len(cells), p, neq, len(names)))
    print("   預設編制加權：血 ×%.3f、攻 ×%.3f（第一期唔生效；第二期交平衡線用 sim 調）" % (hp, atk))

if __name__ == "__main__":
    build()
