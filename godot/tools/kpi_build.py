#!/usr/bin/env python3
# [kpi] 由文案組劇本（story_v2.md 三、八、九節）產生 data/nat/kpi.json：考核閘門設定＋考核場景
# 用法：python3 tools/kpi_build.py /home/claude/meeting/vil2/story_v2.md
# 場景格式：lines = [[講者, 粵語句, 中文句, 條件]]；條件 "m"／"f" = 只畀男主／女主；講者「阿福」= 主角（顯示時 DB.N() 換名）
# 粵語版未寫：粵語欄暫時用中文句（文案組之後補）
import json, re, sys, os

SRC = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/meeting/vil2/story_v2.md"
OUT = os.path.join(os.path.dirname(__file__), "..", "data", "nat", "kpi.json")

text = open(SRC, encoding="utf-8").read()

# ---- 抽場景：**kpi_xxx　標題** 之後嘅「- 講者：句子」 ----
scenes = {}
cur = None
for raw in text.splitlines():
    line = raw.strip()
    m = re.match(r"^\*\*(kpi_[a-z_]+)[\s　]+(.+?)\*\*$", line)
    if m:
        cur = m.group(1)
        scenes[cur] = {"title": m.group(2).strip(), "lines": []}
        continue
    if line.startswith("#") or line.startswith("---") or line.startswith(">"):
        cur = None
        continue
    if cur is None:
        continue
    if line.startswith("（") and line.endswith("）"):   # （效果：……）＝給開發看的註，唔入劇本
        continue
    m = re.match(r"^- (.+?)：(.+)$", line)
    if not m:
        continue
    spk, said = m.group(1).strip(), m.group(2).strip()
    cond = ""
    if "若已招到" in spk:   # 名鬼客串（未必招到）：略過
        continue
    g = re.match(r"^\{主角\}（(男|女)）$", spk)
    if g:
        cond = "m" if g.group(1) == "男" else "f"
        spk = "阿福"
    elif spk == "{主角}":
        spk = "阿福"
    said = said.replace("{主角}", "阿福")
    said = said.replace("少爺／大小姐", "{少爺}")
    scenes[cur]["lines"].append([spk, said, said, cond] if cond else [spk, said, said])

# ---- 自己補嘅場景（文案未寫：馬面拍照、Bryan 搶功、撕橫幅、龐總彩蛋）----
extra = {
    "kpi_photo": {"title": "拍照存證", "lines": [
        ["旁白", "馬面收下名錶，戴上，抬手看了看時間。然後拿出一部紙紮手機。", "馬面收下名錶，戴上，抬手看了看時間。然後拿出一部紙紮手機。"],
        ["馬面", "（咔嚓）存證。", "（咔嚓）存證。"],
        ["阿福", "你拍我做什麼？", "你拍我做什麼？"],
        ["馬面", "按規矩，收了禮要留底。下一區的考核，我會記得你。", "按規矩，收了禮要留底。下一區的考核，我會記得你。"],
        ["系統", "提示：下一區 KPI 提高一成哦親～", "提示：下一區 KPI 提高一成哦親～"]]},
    "kpi_bryan": {"title": "本月最佳員工", "lines": [
        ["旁白", "考核期限到了。村口傳來一下一下拍籃球的聲音。", "考核期限到了。村口傳來一下一下拍籃球的聲音。"],
        ["Bryan", "哎喲，新村長，KPI 還沒做完？", "哎喲，新村長，KPI 還沒做完？"],
        ["Bryan", "沒關係，我幫你交了。報告上寫我的名字，比較好看。", "沒關係，我幫你交了。報告上寫我的名字，比較好看。"],
        ["旁白", "他順手從倉庫搬走一大箱東西，又在村口掛起一條橫幅：「本月最佳員工：Bryan」。", "他順手從倉庫搬走一大箱東西，又在村口掛起一條橫幅：「本月最佳員工：Bryan」。"],
        ["阿福", "那是我的！", "那是我的！", "m"],
        ["阿福", "（筆記）「Bryan：搶功一次，取走倉庫物資，待追討。」", "（筆記）「Bryan：搶功一次，取走倉庫物資，待追討。」", "f"],
        ["Bryan", "達標了再來拿啊——三分球！", "達標了再來拿啊——三分球！"]]},
    "kpi_banner_down": {"title": "撕橫幅", "lines": [
        ["旁白", "考核達標的那一刻，村口那條「本月最佳員工：Bryan」的橫幅，被一陣陰風吹得嘩啦嘩啦響。", "考核達標的那一刻，村口那條「本月最佳員工：Bryan」的橫幅，被一陣陰風吹得嘩啦嘩啦響。"],
        ["阿福", "（一把扯下橫幅）功勞還給我，東西也還一半來。", "（一把扯下橫幅）功勞還給我，東西也還一半來。"],
        ["Bryan", "（遠處）一半？我已經吃了一半了！", "（遠處）一半？我已經吃了一半了！"],
        ["系統", "Bryan 搶走的物資，追回一半！", "Bryan 搶走的物資，追回一半！"]]},
    "kpi_pang_egg": {"title": "誠信檔案", "lines": [
        ["龐總", "我聽說你很懂得……建立關係。很好。我們是一個大家庭。", "我聽說你很懂得……建立關係。很好。我們是一個大家庭。"],
        ["旁白", "他在平板上，默默加了一行。", "他在平板上，默默加了一行。"]]},
}
for k, v in extra.items():
    scenes[k] = v

# ---- 考核閘門（第一張圖）：次序＝劇本 3.3；指標＝劇本 KPI 範例 ----
# kind：res（S.res 舊資源）／mat（材料庫 mat.gd）／bld（S.bld 等級）／fn（由其他模組登記嘅計數；冇登記就用 kpi_data 嘅後備）
# opens：zone:<區id>（資源區，直接 set_owned）／flag:<名>（酒館、大排檔等，畀 vil2 查 KG.is_open）
# fail_add／caught：送錯人（賄賂失敗）、被老闆抓包嘅後果，同劇本台詞一致
gates = [
    {"id": "A", "boss": "chen", "boss_n": "陳不辦", "title": "陰間拆遷及重建辦事處", "opens": "zone:A", "time": 1200,
     "need": [{"kind": "fn", "key": "rebuilt", "n": 6, "label": "修好建築"}, {"kind": "bld", "key": "home", "n": 1, "label": "民宅可住"}],
     "fav": {"niu": "food", "ma": "food"}, "fail_add": {}, "fail_mood": True,
     "caught": {"lose": True, "add": {"rebuilt": 2}}},
    {"id": "B", "boss": "he", "boss_n": "何大睡", "title": "竹林管理處", "opens": "zone:B", "time": 1200,
     "need": [{"kind": "mat", "key": "m_bamboo", "n": 30, "label": "竹子"}, {"kind": "mat", "key": "m_strip", "n": 10, "label": "竹篾"}],
     "fav": {"niu": "food", "ma": "brand"}, "fail_add": {"m_bamboo": 10},
     "caught": {"lose": False, "mul_all": 0.5}},
    {"id": "tavern", "boss": "qian", "boss_n": "錢不漏", "title": "水務及財務總管", "opens": "flag:tavern", "time": 1500,
     "need": [{"kind": "mat", "key": "m_wellwater", "n": 20, "label": "井水"}, {"kind": "mat", "key": "m_paper", "n": 10, "label": "竹紙"}, {"kind": "res", "key": "coins", "n": 500, "label": "冥幣存款"}],
     "fav": {"niu": "brand", "ma": "food"}, "fail_add": {"coins": 100},
     "caught": {"lose": True}},
    {"id": "C", "boss": "dato", "boss_n": "Dato' 冥", "title": "陰間酒牌及娛樂局", "opens": "zone:C", "time": 1500,
     "need": [{"kind": "fn", "key": "named_hired", "n": 3, "label": "名鬼簽約"}, {"kind": "fn", "key": "named_working", "n": 3, "label": "名鬼開工"}],
     "fav": {"niu": "brand", "ma": "brand"}, "fail_add": {"named_hired": 1},
     "caught": {"lose": True, "rebribe": True}},
    {"id": "final", "boss": "nuo", "boss_n": "糯婆", "title": "陰間農業局", "opens": "flag:pang", "time": 1500,
     "need": [{"kind": "mat", "key": "m_straw", "n": 30, "label": "禾稈草"}, {"kind": "mat", "key": "m_bao", "n": 50, "label": "普通包子"}],
     "fav": {"niu": "food", "ma": "food"}, "fail_add": {"m_bao": 20},
     "caught": {"lose": True, "add": {"m_bao": 50}}},
    {"id": "market", "boss": "pang", "boss_n": "龐總", "title": "地府集團總考核", "opens": "flag:market", "time": 1800, "nobribe": True,
     "need": [{"kind": "fn", "key": "self_sufficient", "n": 5, "label": "資源穩定產出"}, {"kind": "fn", "key": "named_working", "n": 5, "label": "名鬼排班"}],
     "fav": {}, "fail_add": {}, "caught": {}},
    # [market] 過勞鬼市集 KPI ①②③（design_market_v1 第八、十二節）：考核官固定「市集管理處處長甄好賣」；劇本待文案組（kpi_zhen_*），未有就唔播
    {"id": "mk1", "boss": "zhen", "boss_n": "甄好賣", "title": "市集管理處", "opens": "flag:mk_cloth", "time": 900,
     "need": [{"kind": "fn", "key": "mk_food_lv", "n": 20, "label": "食街總等級"}, {"kind": "res", "key": "coins", "n": 500, "label": "冥幣存款"}],
     "fav": {"niu": "brand", "ma": "food"}, "fail_add": {"coins": 100}, "caught": {"lose": True}, "cost_mul": 2.0},
    {"id": "mk2", "boss": "zhen", "boss_n": "甄好賣", "title": "市集管理處", "opens": "flag:mk_weapon", "time": 1200,
     "need": [{"kind": "fn", "key": "mk_combo", "n": 10, "label": "連單"}, {"kind": "fn", "key": "mk_lv25_fc", "n": 2, "label": "食衣兩街各一攤 Lv25"}],
     "fav": {"niu": "food", "ma": "food"}, "fail_add": {"mk_combo": 3}, "caught": {"lose": True}, "cost_mul": 2.0},
    {"id": "mk3", "boss": "zhen", "boss_n": "甄好賣", "title": "市集管理處", "opens": "flag:mk_acc", "time": 1500,
     "need": [{"kind": "fn", "key": "mk_renown_lv", "n": 2, "label": "名聲等級"}, {"kind": "fn", "key": "mk_reg_visits", "n": 20, "label": "熟客來訪"}, {"kind": "fn", "key": "mk_patrol_done", "n": 5, "label": "巡邏處理事件"}],
     "fav": {"niu": "brand", "ma": "brand"}, "fail_add": {"mk_reg_visits": 5}, "caught": {"lose": True}, "cost_mul": 2.0},
]

# 賄賂三檔（設計 4.2）：效果、成本、風險
bribes = {
    # 價錢對齊設計 v1 第十一節（各組對齊用）
    "snack": {"n": "紙紮點心", "type": "food", "cost": {"coins": 40}, "eff": "cut1", "val": 0.2, "risk": "none", "p": 0.0},
    "watch": {"n": "紙紮名錶", "type": "brand", "cost": {"coins": 120, "m_plank": 20}, "eff": "skip1", "val": 1.0, "risk": "photo", "p": 0.2},
    "car": {"n": "紙紮跑車", "type": "brand", "cost": {"coins": 300, "m_plank": 60}, "eff": "cutall", "val": 0.4, "risk": "caught", "p": 0.3},
}

need_scenes = []
for g in gates:
    if g["boss"] == "zhen": continue   # [market] 甄好賣劇本待文案組
    b = g["boss"]
    for suf in ["open", "pass"] + ([] if g.get("nobribe") else ["bribe_ok", "bribe_fail", "caught"]):
        need_scenes.append("kpi_%s_%s" % (b, suf))
need_scenes.append("kpi_pang_bribe")
# 陳不辦嘅失敗／抓包場景喺範本用通用名（kpi_bribe_fail、kpi_caught、kpi_pass）
alias = {"kpi_chen_bribe_fail": "kpi_bribe_fail", "kpi_chen_caught": "kpi_caught", "kpi_chen_pass": "kpi_pass"}
for k, v in alias.items():
    if k not in scenes and v in scenes:
        scenes[k] = scenes[v]
missing = [k for k in need_scenes if k not in scenes]

# 遊戲流程修正（唔改劇本原意）：
# 1. 陳不辦巡查：「修好了……三棟」改成實際數字（{rebuilt}，顯示時換中文數字）
# 2. Dato' 冥達標＝荒田禾稈場開放（閘門 C 開 zone:C）：系統句補一句，同糯婆考核接得上
def _patch(key, old, new):
    sc = scenes.get(key)
    if not sc: return
    for l in sc["lines"]:
        for i in (1, 2):
            if old in l[i]: l[i] = l[i].replace(old, new)
_patch("kpi_chen_open", "修好了……三棟", "修好了……{rebuilt}棟")
_patch("kpi_dato_pass", "名鬼招募全面開放！", "名鬼招募全面開放，荒田禾稈場也開放了！")

out = {
    "_note": "kpi_build.py 由 story_v2.md 產生；唔好手改，改劇本再跑",
    "maps": {"0": {"gates": gates}},
    "bribes": bribes,
    "scenes": {k: v for k, v in scenes.items() if k.startswith("kpi_")},
}
json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("scenes", len(out["scenes"]), "missing", missing)
for k in sorted(out["scenes"]):
    print(" ", k, len(out["scenes"][k]["lines"]))
