# [cdata] 生成 data/abil.json（ABIL／ENEMY／CAMP_MOD 段＋TAGS／MECH 最小 stub）同 data/nat/counter.json
# 用法（喺 godot 目錄）：python3 -I tools/cdata/build_cdata.py
# 依據：/home/claude/bs/counter.md（第 3、4、6、8、10、11 節）、roster.md（第 3 節能力概念、第 7.1 節）、ability.md（第 2 節結構）
#       counter_tool/counter_sim.py 的名冊與鬼幫（PLAN 第 6 節定案：狐狸精→狐妖、Sundel Bolong→Teke Teke、判官→陰司審批主任、投胎辦事處職員→輪候處職員）
# 第一階段：新鬼（nw_*）、新雜兵（zd_*）、天花姐（未入 ENEMY_T）冇敵人圖 → 用同系現有鬼頂替（SUB 表），counter.json 記住原定（plan）同實際（en）。
import json, os, sys, itertools

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CORE = json.load(open(os.path.join(ROOT, "data/core.json"), encoding="utf-8"))
ET = CORE["ENEMY_T"]; GH = CORE["GHOSTS"]; SK = CORE["SKILLS"]

# ======================= 第一層：8 系 × 8 嚇法（counter.md 3.3） =======================
SC = {"吹氣": "breath", "燈": "light", "凍": "cold", "怪聲": "sound", "紙": "paper", "電話": "phone", "鬼臉": "face", "黑影": "shadow"}
SYS = {  # 系: (怕①, 怕②, 不怕, 怕①理由, 怕②理由, 不怕理由)
    "屍": ("吹氣", "怪聲", "凍", "生人氣：一啖氣噴埋面就亂", "雞啼：雞一啼就要返棺", "屍體本來就凍"),
    "魂": ("燈", "黑影", "吹氣", "遊魂怕光", "以為聻嚟咗（鬼之畏聻）", "飄慣咗"),
    "紙紮": ("燈", "吹氣", "紙", "紙紮怕火", "紙輕，一吹就飛", "自己就係紙"),
    "妖": ("怪聲", "凍", "黑影", "爆竹嚇走山臊", "山精野獸一凍就要冬眠", "山林夜色係主場"),
    "厲": ("電話", "鬼臉", "怪聲", "「公司走唔開」嗰通電話", "笑佢樣衰", "尖叫係佢哋專利"),
    "使": ("紙", "黑影", "鬼臉", "主人嘅契約字條", "以為主人返嚟", "自己最愛扮鬼臉"),
    "官": ("紙", "電話", "燈", "公文、投訴信", "上頭 call", "24 小時開燈返工"),
    "橫": ("凍", "鬼臉", "電話", "停屍間雪櫃", "扮佢死相", "自己就係因為電話死"),
}
TAGS = ["遠", "拉", "掃", "破", "刺", "削", "回", "照", "定", "收"]
TAG_DEF = {
    "遠": ("ranged", "遠程", "#7dd3fc", "企後面打，飛嘅都打得到；近戰反傷唔痛"),
    "拉": ("ground", "拉落地", "#a3e635", "腳軟／扯近：飛嘅拉落地，突襲者截停"),
    "掃": ("sweep", "群攻", "#fbbf24", "範圍技一次過清散骨、分身"),
    "破": ("breaker", "破殼", "#f97316", "多段／破甲：破殼、無視霸體"),
    "刺": ("burst", "單點爆發", "#ef4444", "斬召喚者、打霸體"),
    "削": ("sapper", "削氣", "#c084fc", "削嚇氣／封口：停回血、延遲召喚"),
    "回": ("sustain", "回血", "#4ade80", "吸血治療：抵銷反傷"),
    "照": ("reveal", "現形", "#fde047", "隱身現形、破分身"),
    "定": ("steady", "定神", "#94a3b8", "免疫並保護身邊免疫光環／迷魂，吸引突襲"),
    "收": ("seal", "收屍", "#e2e8f0", "阻止屍變、收走召喚物"),
}
MECHS = ["飛", "隱", "殼", "再生", "散骨", "召喚", "反傷", "嚇氣光環", "霸體", "屍變", "突襲", "迷魂", "分身"]
# counter.md 4.1（數值以此為準）＋應對標籤
MECH_DEF = {
    "飛": ("fly", ["遠", "拉"], {"melee": 0.3, "aoe": 0.7, "pull_s": 4.0}, "近戰打佢只有三成傷害"),
    "隱": ("stealth", ["照"], {"cycle": 6.0, "dur": 4.0, "near": 80, "aoe": 0.5, "reveal_s": 8.0, "reveal_r": 150}, "每 6 秒隱身 4 秒，揀唔到做目標"),
    "殼": ("shell", ["破"], {"pct": 0.35, "taken": 0.5, "hits_x": 3.0, "heavy_x": 2.0, "heavy_m": 1.8}, "殼未破前受傷減半"),
    "再生": ("regen", ["削"], {"pct": 0.025, "boss_pct": 0.015, "stop_s": 6.0, "stop_sc": "cold"}, "每秒回血 2.5%"),
    "散骨": ("split", ["掃"], {"n": 3, "hp": 0.25}, "死咗散做 3 隻細骨"),
    "召喚": ("summon", ["刺", "削"], {"n": 2, "cap": 6, "burst_m": 1.7}, "越打越多"),
    "反傷": ("thorns", ["遠", "回"], {"pct": 0.2}, "近戰打佢反彈兩成傷害"),
    "嚇氣光環": ("fear_aura", ["定"], {"r": 150, "energy": -0.5, "minion_atk": -0.2, "dispel_sc": "face", "dispel_s": 5.0}, "身邊嚇氣減半，技能放唔出"),
    "霸體": ("cc_immune", ["破", "刺"], {"immune": ["down", "air", "push"]}, "腳軟、嚇退無效"),
    "屍變": ("revive", ["收"], {"delay": 4.0, "hp": 0.5}, "倒低 4 秒後半血再起"),
    "突襲": ("rush", ["定", "拉"], {"to": "back"}, "開打即繞過陰兵衝後排"),
    "迷魂": ("confuse", ["定"], {"cycle": 8.0, "r": 150, "n": 3, "dur": 2.5}, "每 8 秒令 3 隻我方亂走"),
    "分身": ("clone", ["照", "掃"], {"n": 2, "absorb": 0.3}, "開打放兩個分身"),
}

# ======================= 名冊（counter.md 6.3／6.4；counter_sim.py） =======================
# id: (名, 系, 嚇法, 機制, 章, 強度, 新?)
R = {}
def add(i, s, a, m, ch, t, name=None, new=False):
    R[i] = dict(id=i, sys=s, sc=a, mech=[x for x in m.split(",") if x], ch=ch, t=t, new=new,
                name=name or (GH[i]["name"] if i in GH else ET[i][2]))
for row in [
    ("eguiking", "魂", "怪聲", "再生,霸體", 1, 4), ("toyol", "使", "鬼臉", "隱,召喚", 2, 4), ("laojiang", "屍", "凍", "霸體,屍變", 3, 4),
    ("pontianak", "厲", "怪聲", "飛,嚇氣光環", 4, 4), ("pocong", "屍", "凍", "殼,屍變", 5, 4), ("penanggal", "厲", "鬼臉", "飛,突襲", 5, 4),
    ("baiwu", "官", "紙", "嚇氣光環,分身", 6, 4), ("heiwu", "官", "黑影", "殼,霸體", 6, 4),
    ("n30_qionggui", "魂", "吹氣", "", 1, 1), ("n30_danxiao", "魂", "吹氣", "", 1, 1), ("n30_jiugui", "魂", "吹氣", "霸體", 1, 1),
    ("pg_tuimo", "魂", "怪聲", "霸體", 1, 1), ("n30_jerangkung", "屍", "凍", "散骨", 1, 2), ("n30_wutou", "橫", "鬼臉", "散骨", 1, 1),
    ("n30_kasaobake", "紙紮", "紙", "突襲", 1, 1), ("n30_chochin", "紙紮", "燈", "反傷", 1, 1), ("n30_yesi", "橫", "電話", "", 1, 1),
    ("n30_maoshi", "魂", "吹氣", "", 1, 1),
    ("n30_pelesit", "使", "怪聲", "飛", 2, 1), ("n30_polong", "使", "鬼臉", "再生", 2, 1), ("n30_hanturaya", "使", "黑影", "分身,召喚", 2, 3),
    ("n30_bunian", "妖", "黑影", "隱", 2, 2), ("n30_genderuwo", "妖", "黑影", "霸體", 2, 3), ("n30_jenglot", "屍", "凍", "再生", 2, 1),
    ("n30_yezi", "橫", "電話", "殼", 2, 2), ("n30_liulian", "橫", "電話", "反傷", 2, 2), ("n30_shidu", "橫", "吹氣", "反傷", 2, 1),
    ("n30_yangui", "魂", "吹氣", "隱", 2, 1), ("n30_dugui", "魂", "紙", "分身", 2, 2), ("n30_guhangui", "魂", "紙", "殼", 2, 2),
    ("n30_hantugalah", "魂", "黑影", "嚇氣光環", 2, 2),
    ("n30_hanba", "屍", "燈", "嚇氣光環,再生", 3, 3), ("n30_shanxiao", "妖", "黑影", "突襲", 3, 2), ("n30_tikbalang", "妖", "黑影", "迷魂", 3, 2),
    ("n30_baigujing", "妖", "黑影", "分身,再生", 3, 2), ("n30_taozhai", "使", "紙", "屍變", 3, 2), ("n30_changgui", "使", "鬼臉", "召喚", 3, 1),
    ("pg_songding", "魂", "鬼臉", "分身", 3, 2), ("n30_diaosi", "厲", "鬼臉", "突襲", 3, 2), ("n30_shedu", "橫", "電話", "反傷", 3, 2),
    ("n30_churel", "厲", "怪聲", "迷魂", 4, 2), ("n30_maenak", "厲", "怪聲", "突襲", 4, 2), ("n30_guixinniang", "厲", "怪聲", "召喚", 4, 2),
    ("n30_kappa", "妖", "凍", "殼", 4, 1), ("n30_aswang", "妖", "黑影", "再生,分身", 4, 3), ("n30_zhongshu", "橫", "燈", "嚇氣光環", 4, 2),
    ("n30_xiangcai", "紙紮", "紙", "隱", 4, 3), ("tianhua", "魂", "鬼臉", "突襲", 4, 2), ("n30_phiam", "魂", "黑影", "嚇氣光環", 4, 1),
    ("n30_xiasi", "魂", "鬼臉", "嚇氣光環", 4, 1),
    ("n30_kuchisake", "厲", "鬼臉", "突襲", 5, 2), ("n30_banshee", "厲", "怪聲", "嚇氣光環", 5, 3), ("n30_yukionna", "厲", "凍", "嚇氣光環", 5, 3),
    ("n30_hannya", "厲", "鬼臉", "反傷,霸體", 5, 3), ("n30_zipai", "橫", "電話", "分身", 5, 1), ("n30_chehuo", "橫", "燈", "突襲", 5, 2),
    ("n30_daji", "橫", "電話", "", 5, 1), ("n30_xiaosi", "橫", "怪聲", "嚇氣光環", 5, 1), ("n30_chengsi", "橫", "吹氣", "再生", 5, 2),
    ("n30_nopperabo", "妖", "鬼臉", "隱", 5, 2), ("n30_rokurokubi", "妖", "黑影", "突襲", 5, 2), ("n30_gashadokuro", "屍", "凍", "散骨,霸體", 5, 3),
    ("n30_vetala", "屍", "鬼臉", "迷魂", 5, 3),
    ("niutou", "官", "燈", "殼", 6, 2), ("mamian", "官", "燈", "突襲", 6, 2), ("n30_yecha", "官", "燈", "殼", 6, 3),
    ("pg_ex", "厲", "電話", "嚇氣光環", 6, 2), ("pg_landlady", "橫", "紙", "召喚,殼", 6, 3), ("n30_diansi", "橫", "電話", "反傷", 6, 3),
    ("n30_leipi", "橫", "燈", "嚇氣光環", 6, 3), ("n30_dongsi", "屍", "凍", "殼", 6, 3), ("pg_ji", "魂", "黑影", "隱,屍變", 6, 3),
]:
    add(*row)
# 新鬼 26（第二階段出圖；PLAN 第 6 節定案名）
for row in [
    ("nw_guihuo", "魂", "燈", "飛,散骨", 1, 1, "鬼火"), ("nw_huli", "妖", "黑影", "分身", 1, 2, "狐妖"),
    ("nw_bajang", "使", "鬼臉", "隱", 2, 2, "Bajang"), ("nw_teketeke", "厲", "怪聲", "突襲", 5, 2, "Teke Teke"),
    ("nw_baimao", "屍", "凍", "霸體,再生", 3, 2, "白毛殭屍"), ("nw_buhuagu", "屍", "凍", "殼,屍變", 3, 3, "不化骨"),
    ("nw_daqiang", "妖", "黑影", "迷魂", 3, 2, "鬼打牆"), ("nw_ganshi", "魂", "怪聲", "", 3, 2, "趕屍匠"),
    ("nw_huapi", "厲", "紙", "分身", 3, 3, "畫皮"),
    ("nw_ameonna", "厲", "凍", "嚇氣光環", 4, 2, "雨女"), ("nw_shejing", "妖", "凍", "再生", 4, 2, "蛇精"),
    ("nw_tiangou", "妖", "黑影", "飛", 4, 2, "天狗"), ("nw_tisi", "橫", "凍", "突襲", 4, 2, "替死鬼"),
    ("nw_krahang", "妖", "黑影", "飛", 4, 2, "Krahang"), ("nw_kapre", "妖", "吹氣", "隱,霸體", 4, 3, "Kapre"),
    ("nw_honeonna", "屍", "燈", "隱", 5, 2, "骨女"), ("nw_mummy", "屍", "凍", "殼,屍變", 5, 3, "木乃伊"),
    ("nw_zzphone", "紙紮", "電話", "隱", 5, 2, "紙紮手機"), ("nw_zzcar", "紙紮", "燈", "突襲", 5, 2, "紙紮跑車"),
    ("nw_kuaidi", "使", "電話", "突襲", 5, 2, "陰司快遞員"),
    ("nw_zzhouse", "紙紮", "紙", "殼,召喚", 6, 3, "紙紮大屋"), ("nw_shenpi", "官", "紙", "嚇氣光環", 6, 3, "陰司審批官"),
    ("nw_toutai", "官", "紙", "召喚", 6, 2, "投胎辦事處職員"), ("nw_yeleng_guard", "使", "鬼臉", "殼", 6, 2, "夜冷村保安"),
    ("nw_yeleng_sales", "使", "電話", "召喚", 6, 2, "夜冷村推銷員"), ("nw_dullahan", "妖", "黑影", "突襲,霸體", 6, 3, "Dullahan"),
]:
    i, s, a, m, ch, t, nm = row
    add(i, s, a, m, ch, t, name=nm, new=True)
FOD = {  # 雜兵 14（counter.md 6.4）
    "youhun": ("遊魂", "魂", "吹氣", ""), "egui": ("餓鬼", "魂", "吹氣", "再生"), "shuigui": ("水鬼", "橫", "凍", "突襲"),
    "zombie": ("殭屍兵", "屍", "凍", "屍變"), "zhiren": ("紙人偶", "紙紮", "紙", ""), "xiaogui": ("小鬼", "使", "鬼臉", "隱"),
    "zd_bone": ("骷髏兵", "屍", "凍", "散骨"), "zd_zhima": ("紙馬", "紙紮", "紙", "突襲"), "zd_shanjing": ("山精", "妖", "黑影", ""),
    "zd_shuihou": ("水猴子", "妖", "黑影", "突襲"), "zd_hongyi": ("紅衣女鬼", "厲", "怪聲", "嚇氣光環"), "zd_paotui": ("跑腿鬼", "使", "鬼臉", "召喚"),
    "zd_yinchai": ("陰差", "官", "燈", "殼"), "zd_hengsi": ("橫死新鬼", "橫", "電話", ""),
}
BOSS = {"huang": ("黃總", "官", "電話", "召喚,殼,嚇氣光環")}   # 第一階段只有黃總有圖（其餘 7 隻魔王第二階段）

# 頂替表（第一階段）：原定 id → (現有有圖嘅同系鬼, 血倍, 攻倍)；倍數令頂替雜兵嘅名鬼唔會強過原定雜兵
SUB = {
    "nw_guihuo": ("n30_xiasi", 1, 1), "nw_huli": ("n30_baigujing", 1, 1), "nw_bajang": ("n30_taozhai", 1, 1),
    "nw_teketeke": ("n30_maenak", 1, 1), "nw_baimao": ("n30_jerangkung", 1, 1), "nw_buhuagu": ("n30_dongsi", 1, 1),
    "nw_daqiang": ("n30_tikbalang", 1, 1), "nw_ganshi": ("n30_guhangui", 1, 1), "nw_huapi": ("n30_yukionna", 1, 1),
    "nw_ameonna": ("n30_yukionna", 1, 1), "nw_shejing": ("n30_baigujing", 1, 1), "nw_tiangou": ("n30_rokurokubi", 1, 1),
    "nw_tisi": ("n30_chehuo", 1, 1), "nw_krahang": ("n30_shanxiao", 1, 1), "nw_kapre": ("n30_genderuwo", 1, 1),
    "nw_honeonna": ("n30_jerangkung", 1, 1), "nw_mummy": ("n30_dongsi", 1, 1), "nw_zzphone": ("n30_xiangcai", 1, 1),
    "nw_zzcar": ("n30_kasaobake", 1, 1), "nw_kuaidi": ("n30_taozhai", 1, 1), "nw_zzhouse": ("n30_xiangcai", 1, 1),
    "nw_shenpi": ("n30_yecha", 1, 1), "nw_toutai": ("mamian", 1, 1), "nw_yeleng_guard": ("n30_taozhai", 1, 1),
    "nw_yeleng_sales": ("n30_changgui", 1, 1), "nw_dullahan": ("n30_genderuwo", 1, 1), "tianhua": ("n30_hantugalah", 1, 1),
    "zd_bone": ("zombie", 1, 1), "zd_zhima": ("zhiren", 1, 1), "zd_shanjing": ("n30_kappa", 0.7, 0.9),
    "zd_shuihou": ("n30_kappa", 0.7, 0.9), "zd_hongyi": ("pg_ex", 0.5, 0.85), "zd_paotui": ("xiaogui", 1, 1),
    "zd_yinchai": ("niutou", 1, 1), "zd_hengsi": ("shuigui", 1, 1),
}

# ======================= 鬼幫 24＋據點 90（counter.md 5.1、8；counter_sim.py） =======================
GANGS = {
 1: {"W": ("餓鬼坑幫", ["n30_qionggui", "n30_danxiao", "n30_jiugui", "pg_tuimo"], ["egui", "youhun"]),
     "E": ("亂葬崗骷髏", ["n30_wutou", "nw_guihuo", "n30_jerangkung", "n30_jerangkung"], ["zd_bone", "youhun"]),
     "S": ("紙錢陣", ["n30_kasaobake", "n30_chochin", "n30_kasaobake", "n30_chochin"], ["zhiren"]),
     "N": ("荒田橫死組", ["n30_yesi", "n30_maoshi", "nw_huli", "nw_huli"], ["zd_hengsi", "egui"])},
 2: {"W": ("甘榜使魔", ["n30_pelesit", "n30_polong", "nw_bajang", "n30_hanturaya"], ["xiaogui"]),
     "E": ("廢膠廠山精", ["n30_bunian", "n30_bunian", "n30_genderuwo", "n30_genderuwo"], ["zd_shanjing"]),
     "S": ("椰林膠園橫死組", ["n30_shidu", "n30_yezi", "n30_liulian", "n30_liulian"], ["zd_hengsi"]),
     "N": ("竹林賭檔", ["n30_yangui", "n30_dugui", "n30_guhangui", "n30_hantugalah"], ["youhun", "zd_hongyi"])},
 3: {"W": ("義莊屍隊", ["n30_jenglot", "nw_baimao", "nw_buhuagu", "n30_hanba"], ["zombie"]),
     "E": ("亂石峽山妖", ["nw_daqiang", "n30_tikbalang", "n30_shanxiao", "n30_baigujing"], ["zd_shanjing"]),
     "S": ("古道收數佬", ["n30_changgui", "n30_taozhai", "nw_ganshi", "pg_songding"], ["xiaogui", "egui"]),
     "N": ("霧谷吊頸林", ["n30_shedu", "n30_diaosi", "nw_huapi", "nw_huapi"], ["zd_hongyi", "zombie"])},
 4: {"W": ("紅樹林新娘", ["n30_churel", "n30_maenak", "n30_guixinniang", "nw_ameonna"], ["zd_hongyi"]),
     "E": ("沉船灘水妖", ["n30_kappa", "nw_tiangou", "nw_shejing", "n30_aswang"], ["zd_shuihou"]),
     "S": ("河口替身組", ["nw_tisi", "n30_zhongshu", "n30_xiangcai", "n30_xiangcai"], ["shuigui"]),
     "N": ("蕉園夜叫", ["n30_phiam", "n30_xiasi", "tianhua", "nw_krahang", "nw_kapre"], ["zd_hongyi", "zd_shuihou"])},
 5: {"W": ("舊戲院女鬼", ["n30_kuchisake", "nw_teketeke", "n30_yukionna", "n30_banshee", "n30_hannya"], ["zd_hongyi"]),
     "E": ("停車場橫死組", ["n30_daji", "n30_xiaosi", "n30_chehuo", "n30_chengsi"], ["zd_hengsi"]),
     "S": ("巴士站怪談", ["n30_nopperabo", "n30_rokurokubi", "nw_honeonna", "nw_kuaidi"], ["zd_shanjing", "zd_bone"]),
     "N": ("舊村古井", ["nw_zzphone", "nw_zzcar", "n30_vetala", "nw_mummy", "n30_gashadokuro"], ["zd_bone", "zd_zhima"])},
 6: {"W": ("集團保安部", ["niutou", "mamian", "nw_yeleng_guard", "n30_yecha"], ["zd_yinchai"]),
     "E": ("董事會審批部", ["pg_ex", "nw_toutai", "pg_ex", "nw_shenpi"], ["zd_hongyi", "zd_yinchai"]),
     "S": ("地庫紙紮部", ["nw_zzhouse", "nw_yeleng_sales", "nw_zzhouse", "pg_landlady"], ["zhiren", "zd_zhima"]),
     "N": ("頂樓機房", ["n30_diansi", "n30_dongsi", "n30_leipi", "pg_ji", "nw_dullahan"], ["zd_hengsi", "zd_paotui"])},
}
EN_N = [3, 4, 5, 5]; NAMED_N = [1, 2, 2, 3]
RING_MECH = [[0, 1], [0, 1], [1, 2], [2, 3]]   # 每圈機制數 [最少, 最多]（審查修正 8 硬上限）
# 新鬼 26 第二階段要做到嘅應對標籤（counter.md 11.3＋審查修正 12～14）
NEW_TAGS = {
    "nw_guihuo": ["遠", "照", "掃"], "nw_huli": ["遠", "照"], "nw_bajang": ["削", "刺"], "nw_teketeke": ["刺", "拉"],
    "nw_baimao": ["定", "破"], "nw_buhuagu": ["定", "收"], "nw_daqiang": ["照", "掃"], "nw_ganshi": ["收", "遠"],
    "nw_huapi": ["削", "照"], "nw_ameonna": ["遠", "削"], "nw_shejing": ["掃", "回"], "nw_tiangou": ["遠", "拉"],
    "nw_tisi": ["拉", "收"], "nw_krahang": ["遠", "拉"], "nw_kapre": ["定", "掃"], "nw_honeonna": ["遠", "照"],
    "nw_mummy": ["收", "定"], "nw_zzphone": ["遠", "削"], "nw_zzcar": ["破", "掃", "照"], "nw_kuaidi": ["遠", "刺"],
    "nw_zzhouse": ["定", "破"], "nw_shenpi": ["收", "照"], "nw_toutai": ["削", "回"], "nw_yeleng_guard": ["定", "拉"],
    "nw_yeleng_sales": ["遠", "削"], "nw_dullahan": ["刺", "破"],
}
NEW_NOTE = {"nw_teketeke": "第 5 關；被動唔好寫免疫腳軟（改突襲加速），免得偵察卡應對寫錯", "nw_shenpi": "原判官位，名「陰司審批官」，必須有「收」",
            "nw_zzcar": "紙紮跑車（唔畫真實車款）", "nw_toutai": "投胎辦事處職員（STORY_BIBLE 世界觀，維持原名）"}

def ent(i):
    if i in R: return dict(R[i], fod=False)
    if i in FOD:
        f = FOD[i]; return dict(id=i, name=f[0], sys=f[1], sc=f[2], mech=[x for x in f[3].split(",") if x], fod=True, t=0)
    if i in BOSS:
        f = BOSS[i]; return dict(id=i, name=f[0], sys=f[1], sc=f[2], mech=f[3].split(","), fod=False, t=5)
    raise KeyError(i)
def real(i):   # 第一階段實際出場嘅 key（有 ENEMY_T、有圖）
    if i in ET: return (i, 1, 1)
    return SUB[i]

# 鬼幫方向：按 zones.json 每章真實據點方向（審查修正 7）。counter_sim 嘅「N」幫＝野外王（king）路線幫，
# 搬去該章 king 所在方向；原本喺嗰個方向嘅幫搬去 N。
ZONES = json.load(open(os.path.join(ROOT, "data/nat/zones.json"), encoding="utf-8"))["maps"]
def gang_dirs(ch):
    so = ZONES[str(ch - 1)]["sorties"]
    kd = [e["dir"] for e in so if e.get("king")][0]
    m = {d: d for d in "WESN"}
    m["N"], m[kd] = kd, "N"          # counter 幫標籤 → 真實方向
    return {m[d]: GANGS[ch][d] for d in "WESN"}
REAL_GANGS = {ch: gang_dirs(ch) for ch in GANGS}
CAMPS = []
for ch in range(1, 7):
    seen = {}
    for e in ZONES[str(ch - 1)]["sorties"]:
        r = int(e["ring"]); d = e["dir"]
        gname, mem, fod = REAL_GANGS[ch][d]
        n = EN_N[r - 1]; nn = NAMED_N[r - 1]
        j0 = seen.get((d, r), 0); seen[(d, r)] = j0 + 1   # 同幫同圈多過一個據點（例：第 5 關第 4 圈三個都喺南）→ 名鬼往前推
        st = {1: 0, 2: 0, 3: 1, 4: len(mem) - 3}[r]
        pick = [mem[min(len(mem) - 1, st + j)] for j in range(nn)]
        if j0 > 0:   # 同幫同圈第 2、3 個據點：揀下一個（由強到弱）唔同組合，駐守鬼照舊係最強嗰隻
            cb = sorted(itertools.combinations(range(len(mem)), nn), key=lambda t: (-t[-1], -sum(t)))
            pick = [mem[x] for x in cb[min(j0, len(cb) - 1)]]
        if e.get("king"): pick = mem[-2:]
        fods = [fod[(j + j0) % len(fod)] for j in range(n - nn)]
        plan = fods + pick              # 雜兵先、名鬼後：最後一隻＝駐守鬼（第 4 圈／野外王即頭目）
        CAMPS.append(dict(id=e["id"], c=ch - 1, ring=r, dir=d, gang=gname, plan=plan, king=bool(e.get("king")), nn=nn, n=n, fods=fods))
    # 覆蓋：每幫每個成員最少出現喺一個據點（第 5 關第 4 圈全部喺南，西／北幫冇第 4 圈 → 名鬼順序推前）
    for d in "WESN":
        gname, mem, fod = REAL_GANGS[ch][d]
        cs = sorted([c for c in CAMPS if c["c"] == ch - 1 and c["dir"] == d], key=lambda c: (c["ring"], c["id"]))
        used = {i for c in cs for i in c["plan"][-c["nn"]:]}
        if set(mem) <= used: continue
        nk = [c for c in cs if not c["king"]]
        m2 = len(mem) - (2 if any(c["king"] for c in cs) else 0)
        left = sum(c["nn"] for c in nk)
        for c in nk:
            st = max(0, min(len(mem) - c["nn"], m2 - left))
            left -= c["nn"]
            c["plan"] = c["fods"] + mem[st:st + c["nn"]]

# 機制教學節奏（審查修正 8）：第 1 章最多 3 種，之後每章新加 2 種；每據點上限 第 1～2 圈 1、第 3 圈 2、第 4 圈 3
RING_CAP = [1, 1, 2, 3]
NEW_PER_CH = [3, 2, 2, 2, 2, 2]

# ======================= 能力（roster.md 第 3 節；ability.md 第 2 節結構） =======================
# 積木縮寫
def F(p, **kw): d = {"p": p}; d.update(kw); return d
def dmg(m, **kw): return F("dmg", mult=m, **kw)
def stars(m): return [round(m * x, 2) for x in (1, 1.05, 1.1, 1.17, 1.25, 1.35)]
def A(name, tg, fx, ai=None, cost=100, cast=0.45):
    for x in fx:
        if x["p"] == "dmg" and not isinstance(x["mult"], list): x["mult"] = stars(x["mult"])
    return {"name": name, "cost": cost, "cast": cast, "tg": tg, "fx": fx, "ai": ai or {"when": "asap"}}
NEAR = {"sel": "near"}
def CIR(r=130, sel="near"): return {"sel": sel, "shape": "circle", "r": r}
def P(tr, fx, star=0, **kw): d = {"tr": tr, "star": star, "fx": fx}; d.update(kw); return d
AOE_AI = {"n_in": 3, "r": 130, "wait": 5}
def AU(r, side, fx, star=3): return {"star": star, "r": r, "side": side, "fx": fx}
STEADY = lambda r=150, star=0: AU(r, "ally", [F("immune", tags=["fear_aura", "confuse"], dur=-1)], star)

N, M_, F_ = 46, 100, 150   # 射程：近、中、遠（roster.md 1.1）
AB = {}
def G(k, rng, role, tags, act, pas=None, aura=None, say=None, old_name=None):
    g = R.get(k)
    sysv = g["sys"] if g else {"xiaozhi": "紙紮", "mengpo": "官", "afu": "魂"}[k]
    scv = g["sc"] if g else {"xiaozhi": "紙", "mengpo": "吹氣", "afu": "鬼臉"}[k]
    AB[k] = {"sys": sysv, "sc": [SC[scv]], "rng": rng, "role": role, "tags": tags, "act": act, "pas": pas or []}
    if aura: AB[k]["aura"] = aura
    if say: AB[k]["say"] = say
    if old_name: AB[k]["old_name"] = old_name

G("afu", N, "front", ["刺", "定"],
  A("通宵斧", NEAR, [dmg(1.7, vs_state="down", x=1.8), F("push", dist=40)]),
  [P("kill", [F("energy", v=20, tg="self")], icd=3)], STEADY(150, 2),
  ["收工？未得，仲有一場。", "收工？還沒，還有一場。"])
G("xiaozhi", F_, "back", ["遠", "拉", "掃"],
  A("紙錢漫天", CIR(130), [dmg(0.8), F("down", dur=1.2), F("energy", v=15, tg="allies")], AOE_AI),
  [P("death", [F("revive", pct=0.5, delay=8.0, n=1)])], None,
  ["少爺，紙紮嘅都要開工，你話打邊個，我就打邊個。", "少爺，紙紮的也要上班，你說打誰，我就打誰。"])
G("eguiking", N, "front", ["刺", "回", "收"],
  A("大胃一口", NEAR, [dmg(2.1, vs_state="down", x=1.8), F("drain", pct=0.4), F("banish", hp_pct=0.35)]),
  [P("start", [F("buff", stat="heal_in", v=-0.5, dur=-1, tg="self")]),
   P("kill", [F("buff", stat="maxhp", v=0.05, dur=-1, stack=6, tg="self")], star=2)], None,
  ["包！有包就跟你！冇包……都照跟住先！", "包子！有包子就跟你！沒有包子……也先跟著！"])
G("toyol", N, "flank", ["刺", "削"],
  A("順手牽羊", NEAR, [dmg(1.3), F("push", dist=40), F("dispel", n=1, to="self"), F("coin", v=25), F("sap", v=35)]),
  [P("start", [F("stealth", dur=4.0, first_x=1.0), F("dash", to="back")])], None,
  ["老闆，摸一下，就摸一下咋，村入面啲嘢我保證唔郁。", "老闆，摸一下，就摸一下而已，村裡的東西我保證不碰。"])
G("laojiang", N, "front", ["掃", "定"],
  A("跳屍撞", {"sel": "near", "shape": "line", "len": 220, "w": 44}, [dmg(1.5), F("air", dur=1.0)], {"n_in": 2, "r": 130, "wait": 5}),
  [P("start", [F("immune", tags=["down", "push"], dur=-1, tg="self")])], STEADY(150, 3),
  ["本官跳咗兩百年，今日准你跟住本官一齊跳。", "本官跳了兩百年，今天准你跟著本官一起跳。"])
G("pontianak", M_, "flank", ["拉", "刺"],
  A("長髮纏", {"sel": "back"}, [dmg(1.7, vs_state="air", x=1.8), F("pull", dist=120), F("down", dur=1.4)]),
  [P("start", [F("stealth", dur=-1, first_x=2.0, until="attack")])], None,
  ["呵呵呵……公司走唔開？咁我過嚟搵你囉。", "呵呵呵……公司走不開？那我過來找你吧。"])
G("pocong", N, "front", ["拉", "掃", "收"],
  A("裹屍壓", {"sel": "dense", "shape": "circle", "r": 130}, [dmg(1.0, vs_state="down", x=1.8), F("down", dur=1.4), F("banish", hp_pct=0.3)], AOE_AI),
  [P("every", [F("buff", stat="dodge", v=0.3, dur=0.6, tg="self")], t=3.0), P("start", [F("buff", stat="taken_melee", v=-0.2, dur=-1, tg="self"), F("immune", tags=["confuse", "slow"], dur=-1, tg="self")], star=2)], None,
  ["有冇請人呀？我跳得好快㗎，唔信你望住！", "有沒有請人？我跳得很快的，不信你看著！"])
G("penanggal", F_, "back", ["遠", "回"],
  A("飛頭咬", {"sel": "back"}, [dmg(1.6, vs_state="air", x=1.8), F("drain", pct=0.5)]),
  [P("low_hp", [F("stealth", dur=3.0, untarget=True), F("heal", pct=0.3, tg="self")], pct=0.3)], None,
  ["快啲快啲，咬完呢啖我仲要返去浸醋！", "快點快點，咬完這口我還要回去泡醋！"])
G("mengpo", F_, "back", ["遠", "削", "回"],
  A("一碗湯", {"sel": "allies", "r": 220}, [F("heal", pct=0.3), F("cleanse", n=9), F("sap", v=100, tg="all_r", r=220)], {"ally_hp": 0.5, "wait": 5}),
  [P("every", [F("heal", pct=0.08, tg="ally_low")], t=10.0)], None,
  ["後生仔，打完先至飲，飲完就唔記得痛㗎喇。", "年輕人，打完才喝，喝完就不記得痛了。"])
G("baiwu", M_, "flank", ["掃", "收"],
  A("一見生財", CIR(130), [dmg(0.9), F("air", dur=1.0), F("coin", v=30), F("banish", hp_pct=0.4)], AOE_AI),
  [P("start", [F("slow", v=-0.3, dur=10.0, tg="foes")])], None,
  ["本月第三百二十一個，請出示證件，多謝合作。", "本月第三百二十一個，請出示證件，謝謝合作。"])
G("tianhua", F_, "back", ["遠", "拉", "刺"],
  A("從天而降", {"sel": "back"}, [F("dash", to="target"), dmg(1.7, vs_state="air", x=1.8), F("down", dur=1.4)]),
  [P("kill", [F("energy", v=15, tg="self")], icd=3)], None,
  ["哎喲……我條腰呀，你哋企開少少，我要落嚟喇。", "哎喲……我的腰啊，你們站開一點，我要下來了。"])
G("heiwu", N, "front", ["掃", "定", "收"],
  A("天下太平", CIR(130), [dmg(1.3, vs_state="air", x=1.8), F("stun", dur=1.5), F("banish", hp_pct=0.3)], AOE_AI),
  [P("start", [F("taunt", r=120, dur=4.0)])], None,
  ["又一個。行啦。", "又一個。走吧。"])
G("n30_qionggui", N, "front", ["掃", "削"],
  A("空袋飛蛾", CIR(130), [dmg(0.7), F("sap", v=20), F("energy", v=8, tg="allies")], AOE_AI),
  [P("death", [F("buff", stat="atk", v=-0.3, dur=6.0, tg="killer")])], None,
  ["你請我入隊就當係投資，回報率……我遲啲先話你知。", "你請我入隊就當是投資，回報率……我晚點再告訴你。"])
G("n30_danxiao", N, "front", ["破", "拉"],
  A("閉眼亂揮", NEAR, [dmg(1.3, hits=3), F("push", dist=30), F("down", dur=0.8, on="last")]),
  [P("hit_taken", [F("buff", stat="dodge", v=0.04, dur=-1, stack=9, tg="self")], icd=2)], None,
  ["我、我唔係驚呀，我係……熱緊身咋！", "我、我不是怕啊，我是……在熱身而已！"])
G("n30_maoshi", N, "front", ["拉", "掃", "破"],
  A("跌倒頭槌", {"sel": "near", "shape": "line", "len": 200, "w": 40}, [dmg(1.5), F("down", dur=1.4), F("stun", dur=1.0, tg="self")], {"n_in": 2, "r": 130, "wait": 5}),
  [P("attack", [F("shield_break", pct=0.25), F("armor_break", v=0.15, dur=5.0)], n=4)], None,
  ["睇住睇住——哎呀！又撞到嘢，對唔住對唔住！", "小心小心——哎呀！又撞到東西，對不起對不起！"])
G("n30_yangui", M_, "back", ["掃", "削"],
  A("煙圈套頭", CIR(90), [dmg(1.2), F("sap", v=60), F("silence", dur=2.0)], AOE_AI),
  [], AU(90, "foe", [F("buff", stat="hit", v=-0.15)], 2),
  ["放心，食完呢支我就戒……呢句我講咗第五百次。", "放心，抽完這支我就戒……這句我說了第五百次。"])
G("n30_jiugui", N, "flank", ["掃", "刺"],
  A("醉漢撲撞", {"sel": "near", "shape": "line", "len": 180, "w": 44}, [F("dash", to="target", n=3), dmg(1.6), F("push", dist=40)], {"n_in": 2, "r": 130, "wait": 5}),
  [P("hit_taken", [F("buff", stat="dodge", v=1.0, dur=0.5, tg="self")], chance=0.25, icd=3), P("low_hp", [F("buff", stat="atk", v=0.3, dur=-1, tg="self")], pct=0.4)], None,
  ["飲杯先！飲完呢杯我先話你知我幫邊個。", "先喝一杯！喝完這杯我再告訴你我幫誰。"])
G("n30_dugui", F_, "back", ["遠", "破"],
  A("梭哈", NEAR, [dmg(1.6, hits=3), F("coin", v=25)]),
  [P("attack", [F("energy", v=10, tg="self")], n=6)], None,
  ["買定離手！跟我呢鋪，包你連本帶利攞返。", "買定離手！跟我這一局，保證你連本帶利拿回來。"])
G("n30_guhangui", N, "front", ["破", "削"],
  A("算盤摑", NEAR, [dmg(1.5), F("shield_break", pct=1.0), F("coin", v=40), F("sap", v=25)]),
  [P("start", [F("buff", stat="taken", v=-0.25, dur=-1, tg="self"), F("buff", stat="heal_in", v=-0.5, dur=-1, tg="self")])], None,
  ["入你隊？包食包住先講，交通津貼另計。", "入你的隊？包吃包住再說，交通津貼另計。"])
G("n30_taozhai", N, "front", ["拉", "刺", "削"],
  A("紅油潑門", NEAR, [F("mark", v=0.2, dur=8.0), dmg(1.7), F("down", dur=1.4), F("sap", v=20)]),
  [P("start", [F("buff", stat="spd_vs_mark", v=0.4, dur=-1, tg="self")])], None,
  ["欠落嘅數，做咗鬼都要還，我幫你逐個追。", "欠下的債，做了鬼也要還，我幫你一個一個追。"])
G("n30_diaosi", M_, "front", ["刺", "收"],
  A("長舌鞭", NEAR, [dmg(1.7), F("stun", dur=2.5), F("mark", v=0.25, dur=2.5), F("banish", hp_pct=0.3)]),
  [P("start", [F("immune", tags=["pull", "air"], dur=-1, tg="self"), F("anti_air", x=1.25)])], None,
  ["我條脷長咗少少，你唔介意嘛？介意都冇計。", "我的舌頭長了一點，你不介意吧？介意也沒辦法。"])
G("n30_wutou", N, "front", ["拉", "掃", "照"],
  A("人頭保齡球", {"sel": "near", "shape": "line", "len": 240, "w": 40}, [dmg(1.0), F("down", dur=1.2)], {"n_in": 2, "r": 130, "wait": 5}),
  [P("start", [F("immune", tags=["confuse", "blind"], dur=-1, tg="self"), F("reveal", r=80, dur=-1)])], None,
  ["你搵我個頭？轉個彎就見到，佢識自己滾返嚟。", "你找我的頭？轉個彎就看到，它會自己滾回來。"])
G("n30_changgui", N, "front", ["刺", "拉"],
  A("喚虎撲", NEAR, [F("summon", k="tiger", n=1, hp_pct=0.5, atk_pct=0.8, dur=12.0), dmg(1.7), F("down", dur=1.0)]),
  [P("ally_down", [F("energy", v=20, tg="self")], icd=6)], None,
  ["我負責帶路，咬人嗰啲交畀阿虎，分工好清楚。", "我負責帶路，咬人的交給老虎，分工很清楚。"])
G("n30_guixinniang", F_, "back", ["遠", "掃"],
  A("拋繡球", CIR(130), [dmg(0.9), F("air", dur=1.0)], AOE_AI),
  [P("every", [F("buff", stat="atk", v=0.2, dur=10.0, tg="allies")], t=60.0)], None,
  ["繡球拋咗出去，接唔接都好，你都要負責。", "繡球拋了出去，接不接都好，你都要負責。"])
G("n30_baigujing", N, "flank", ["刺", "回"],
  A("飛吻骷髏", NEAR, [F("stealth", dur=3.0, first_x=1.0), dmg(1.7), F("drain", pct=0.35)]),
  [P("death", [F("revive", pct=0.3, delay=3.0, n=2)])], None,
  ["三次，你要打足三次先算數，少一次都唔得。", "三次，你要打足三次才算數，少一次都不行。"])
G("n30_shanxiao", N, "front", ["破", "掃"],
  A("單腳長臂掃", CIR(120), [dmg(1.6, hits=2, vs_state="air", x=1.8)], AOE_AI),
  [P("kill", [F("energy", v=20, tg="self")], icd=3)], None,
  ["千祈唔好燒爆竹！你一燒我就上樹，成場冇得打。", "千萬不要放鞭炮！你一放我就上樹，整場沒得打。"])
G("n30_yecha", M_, "front", ["破", "刺", "照"],
  A("鋼叉突刺", NEAR, [dmg(1.8, vs_state="down", x=1.8), F("push", dist=40), F("armor_break", v=0.3, dur=6.0)]),
  [P("kill", [F("energy", v=30, tg="self")], icd=2)], None,
  ["把叉擦到發光先出得門，你等多陣。", "把叉擦到發亮才能出門，你多等一會。"])
G("n30_hanba", N, "front", ["掃", "削", "照"],
  A("熱浪", CIR(130), [dmg(1.1), F("sap", v=15), F("dot", dps=0.15, dur=4.0, kind="fire")], AOE_AI),
  [], AU(120, "foe", [F("wound", v=0.5)], 0),
  ["我行過嘅地方，連你啲眼淚都乾埋。", "我走過的地方，連你的眼淚都乾掉。"])
G("n30_pelesit", N, "flank", ["刺", "削"],
  A("跳咬", NEAR, [dmg(1.7, vs_state="air", x=1.8), F("sap", v=20), F("summon", k="cricket", n=3, hp_pct=0.1, atk_pct=0.2, dur=8.0)]),
  [], AU(140, "foe", [F("buff", stat="energy", v=-0.2)], 2),
  ["唧唧！我叫大聲啲，佢哋成晚都瞓唔著。", "唧唧！我叫大聲一點，他們整晚都睡不著。"])
G("n30_polong", M_, "flank", ["刺", "回", "收"],
  A("出瓶竄咬", {"sel": "far"}, [dmg(1.7), F("drain", pct=0.3), F("banish", hp_pct=0.3, note="收入樽")]),
  [P("ally_down", [F("buff", stat="atk", v=0.05, dur=-1, stack=6, tg="self")])], None,
  ["捧穩個樽，我出去咬完就返嚟，唔使等門。", "捧穩瓶子，我出去咬完就回來，不用等門。"])
G("n30_jenglot", N, "front", ["掃", "回"],
  A("轉身甩髮", CIR(120), [dmg(0.8), F("push", dist=30), F("slow", v=-0.4, dur=4.0)], AOE_AI),
  [P("attack", [F("drain", pct=0.06)], n=1), P("start", [F("buff", stat="heal_in", v=-1.0, dur=-1, tg="self")])], None,
  ["我細細隻，但係頭髮長，一甩就成片。", "我個子小，但頭髮長，一甩就一大片。"])
G("n30_hantugalah", M_, "front", ["拉", "刺"],
  A("高處彈額頭", {"sel": "flyer"}, [dmg(1.7), F("down", dur=1.4), F("anti_air", x=1.3)]),
  [P("hit_taken", [F("buff", stat="atk", v=0.05, dur=-1, stack=5, tg="self")], icd=2)], None,
  ["唔使抬頭，我自己彎低身同你講。", "不用抬頭，我自己彎下身跟你說。"])
G("n30_jerangkung", F_, "back", ["遠", "破"],
  A("骨頭迴旋鏢", NEAR, [dmg(1.6, hits=2)]),
  [P("death", [F("revive", pct=0.4, delay=3.0, n=1)])], None,
  ["骨頭拆得出嚟就掟得出去，環保。", "骨頭拆得下來就丟得出去，環保。"])
G("n30_bunian", N, "flank", ["刺", "削", "照"],
  A("隱身繞後", {"sel": "back"}, [F("dash", to="back"), dmg(1.7), F("sap", v=30)]),
  [P("every", [F("stealth", dur=3.0, first_x=1.0)], t=12.0), P("start", [F("reveal", r=90, dur=-1)])], None,
  ["出陣名單記得寫埋我個名，唔係又當我曠工。", "出陣名單記得寫上我的名字，不然又當我曠工。"])
G("n30_hanturaya", N, "front", ["拉", "掃"],
  A("黑影壓頂", CIR(130), [dmg(1.1), F("down", dur=1.4), F("summon", k="copy", n=1, hp_pct=0.6, atk_pct=0.6, dur=10.0)], AOE_AI),
  [P("death", [F("buff", stat="atk", v=0.3, dur=-1, tg="ally_top")])], None,
  ["你係我新主人？好，你講乜我做乜，連你個樣我都扮埋。", "你是我的新主人？好，你說什麼我做什麼，連你的樣子我都扮。"])
G("n30_genderuwo", N, "front", ["刺", "定"],
  A("跳起搥地", NEAR, [dmg(1.9), F("air", dur=1.0), F("taunt", r=120, dur=4.0)]),
  [P("attack", [F("slow", v=-0.15, dur=5.0)], n=1)], None,
  ["嚟呀！望住我呀！你隻拖鞋喺我度，想要就過嚟攞。", "來啊！看著我！你的拖鞋在我這裡，想要就過來拿。"])
G("n30_phiam", N, "front", ["拉", "削"],
  A("鬼壓床", NEAR, [dmg(1.4), F("down", dur=3.0, boss_x=0.5), F("sap", v=15), F("buff", stat="taken", v=-0.5, dur=3.0, tg="self")]),
  [], None,
  ["坐一陣啫，你瞓你嘅，我坐我嘅。", "坐一會而已，你睡你的，我坐我的。"])
G("n30_churel", M_, "flank", ["拉", "掃"],
  A("反腳倒衝", {"sel": "near", "shape": "line", "len": 200, "w": 44}, [dmg(1.3), F("pull", dist=80)], {"n_in": 2, "r": 130, "wait": 5}),
  [P("hit_taken", [F("flee", dur=1.5, tg="attacker")], chance=0.3, icd=4)], None,
  ["我隻腳指住嗰邊，其實我係行緊過嚟呢邊。", "我的腳指著那邊，其實我是在走過來這邊。"])
G("n30_tikbalang", N, "flank", ["刺", "拉"],
  A("轉身馬後踢", NEAR, [dmg(1.7), F("air", dur=1.0), F("down", dur=1.0, on="land"), F("flee", dur=3.0)]),
  [P("start", [F("buff", stat="spd", v=0.3, dur=-1, tg="self")])], None,
  ["跟我行，條路我好熟，熟到行十轉都係返嚟呢度。", "跟我走，這條路我很熟，熟到走十次都回到這裡。"])
G("n30_maenak", M_, "front", ["拉", "回"],
  A("長臂抓", {"sel": "far"}, [F("pull", dist=160), dmg(1.5, vs_state="down", x=1.8), F("drain", pct=0.25), F("anti_air", x=1.25)]),
  [P("every", [F("buff", stat="atk", v=0.04, dur=-1, stack=5, tg="self", still=True)], t=5.0)], None,
  ["Mak 未返，我照喺度等，等埋你一齊打。", "Mak 還沒回來，我照樣在這裡等，等你一起打。"])
G("n30_aswang", N, "flank", ["刺", "回"],
  A("長舌吸血", NEAR, [dmg(1.8), F("drain", pct=0.45), F("execute", hp_pct=0.25, x=2.0)]),
  [P("start", [F("buff", stat="atk", v=-0.2, dur=30.0, tg="self"), F("buff", stat="taken", v=-0.2, dur=30.0, tg="self")]),
   P("every", [F("buff", stat="atk", v=0.35, dur=-1, tg="self")], t=30.0, n=1)], None,
  ["日頭見到我，你會以為我係街市賣菜嗰個。", "白天看到我，你會以為我是菜市場賣菜的那個。"])
G("n30_vetala", N, "front", ["拉", "刺", "削"],
  A("倒吊驚嚇", NEAR, [dmg(1.7), F("down", dur=1.4), F("sap", v=30), F("buff", stat="self_hurt", v=0.05, dur=4.0, tg="target")]),
  [P("death", [F("revive", pct=0.35, delay=2.0, n=1)])], None,
  ["估吓：乜嘢打極都唔死？……答案就喺你面前。", "猜猜看：什麼東西怎麼打都不死？……答案就在你面前。"])
G("n30_banshee", F_, "back", ["遠", "掃", "削"],
  A("報喪尖叫", {"sel": "near", "shape": "cone", "r": 160, "deg": 90}, [dmg(1.0, vs_state="down", x=1.8), F("push", dist=40), F("sap", v=20)], AOE_AI),
  [P("start", [F("mark", v=0.5, dur=-1, tg="first_low", hp_pct=0.2)], star=2)], None,
  ["我一叫，就有人要執包袱，今次係邊個你自己估。", "我一叫，就有人要收拾包袱，這次是誰你自己猜。"])
G("n30_kasaobake", N, "front", ["定", "拉"],
  A("開遮", {"sel": "allies", "r": 120}, [F("shield", pct=0.15, dur=6.0, vs="ranged"), F("taunt", r=100, dur=3.0)], {"ally_hp": 0.6, "wait": 5}),
  [P("attack", [F("down", dur=0.8)], n=4)], None,
  ["落雨唔帶遮？唔緊要，有我喺度，你淋唔濕。", "下雨沒帶傘？沒關係，有我在，你淋不濕。"], old_name="跳過去舔")
G("n30_chochin", F_, "back", ["遠", "破", "照"],
  A("噴火咬", NEAR, [dmg(1.4, hits=2), F("dot", dps=0.15, dur=4.0, kind="fire", vs_sys={"紙紮": 2.0}), F("reveal", r=200, dur=8.0)]),
  [], AU(150, "ally", [F("buff", stat="hit", v=0.1)], 3),
  ["黑麻麻點打？我照住你，你專心打就得。", "黑漆漆怎麼打？我幫你照著，你專心打就行。"])
G("n30_kappa", N, "front", ["拉", "掃"],
  A("鞠躬潑水", {"sel": "near", "shape": "cone", "r": 120, "deg": 90}, [dmg(1.2), F("down", dur=1.2), F("mark", v=0.1, dur=8.0, kind="wet")], AOE_AI),
  [P("start", [F("shield", pct=0.2, dur=-1, tg="self")])], None,
  ["多多指教。（鞠躬）……碟水倒咗少少，唔緊要。", "請多指教。（鞠躬）……碟子的水灑了一點，沒關係。"])
G("n30_nopperabo", N, "front", ["定", "削"],
  A("公事包上勾", NEAR, [dmg(1.6), F("air", dur=1.0), F("interrupt")]),
  [P("start", [F("buff", stat="threat", v=-0.8, dur=-1, tg="self")])], STEADY(150, 0),
  ["我個樣你記唔記得都冇所謂，反正老闆都唔記得。", "我的樣子你記不記得都無所謂，反正老闆也不記得。"])
G("n30_rokurokubi", M_, "flank", ["刺", "拉"],
  A("伸頸頭槌", {"sel": "back"}, [dmg(1.7, vs_state="air", x=1.8), F("down", dur=1.0), F("anti_air", x=1.3)]),
  [P("start", [F("immune", tags=["taunt"], dur=-1, tg="self")])], None,
  ["條頸伸出去睇吓先，你哋喺度等我。", "脖子先伸出去看看，你們在這裡等我。"])
G("n30_kuchisake", N, "flank", ["破", "刺"],
  A("剪刀咔嚓", NEAR, [dmg(1.7, hits=2), F("execute", hp_pct=0.5, x=1.6)]),
  [P("start", [F("buff", stat="spd", v=0.25, dur=-1, tg="self")])], None,
  ["今次唔問你喇，你自己講：我靚定唔靚？", "這次不問你了，你自己說：我漂不漂亮？"])
G("n30_yukionna", M_, "back", ["拉", "掃", "削"],
  A("吐冰霜", {"sel": "near", "shape": "cone", "r": 160, "deg": 90}, [dmg(1.0), F("down", dur=2.0), F("sap", v=20)], AOE_AI),
  [P("attack", [F("slow", va=-0.2, dur=4.0)], n=1)], None,
  ["唔使驚，凍住咗就唔痛，我試過。", "不用怕，凍住了就不痛，我試過。"])
G("n30_hannya", N, "flank", ["破", "刺"],
  A("妒火暴衝", NEAR, [F("dash", to="target"), dmg(1.9, hits=2), F("push", dist=40), F("dot", dps=0.1, dur=4.0, kind="fire")]),
  [P("start", [F("buff", stat="atk_per_foe_buff", v=0.1, dur=-1, stack=5, tg="self")])], None,
  ["點解佢哋有護盾我冇？好，我自己過去攞。", "為什麼他們有護盾我沒有？好，我自己過去拿。"])
G("n30_gashadokuro", N, "front", ["掃", "回", "收"],
  A("巨手一拍", CIR(200), [dmg(1.1, vs_state="air", x=1.8), F("air", dur=0.8), F("banish", hp_pct=0.25, note="執埋啲骨")], AOE_AI),
  [P("kill", [F("hot", pct=0.05, dur=3.0, tg="self")]), P("ally_down", [F("buff", stat="maxhp", v=0.04, dur=-1, stack=10, tg="self")], star=2)], None,
  ["越多人倒低，我就越大隻，你哋自己小心。", "越多人倒下，我就越大隻，你們自己小心。"])
G("n30_zipai", M_, "front", ["拉", "掃"],
  A("閃光滑鏟", {"sel": "near", "shape": "cone", "r": 140, "deg": 80}, [dmg(1.2), F("buff", stat="hit", v=-0.5, dur=3.0, tg="target"), F("down", dur=1.2)], AOE_AI),
  [P("kill", [F("energy", v=5, tg="allies")], icd=1)], None,
  ["等等，呢個角度靚，打完先影一張……唔好郁！", "等等，這個角度好看，打完先拍一張……不要動！"])
G("n30_xiaosi", N, "front", ["掃", "削"],
  A("傳染的笑", CIR(130), [dmg(0.7), F("stun", dur=2.0, boss_x=0.5), F("sap", v=30)], AOE_AI),
  [P("death", [F("recast", x=0.5)])], None,
  ["我盡量唔笑……噗，唔得，你個陣型太好笑。", "我盡量不笑……噗，不行，你的陣型太好笑。"])
G("n30_yesi", F_, "back", ["遠", "刺"],
  A("湯圓子彈", NEAR, [dmg(1.7), F("stun", dur=2.0), F("push", dist=30)]),
  [P("start", [F("energy", v=100, tg="self")])], None,
  ["（咳）……好嘢，終於吐咗出嚟，下一粒畀你。", "（咳）……好啊，終於吐出來了，下一顆給你。"])
G("n30_shidu", N, "front", ["掃", "削"],
  A("綠色臭屁", NEAR, [F("zone", r=110, dur=6.0, fx=[F("dot", dps=0.08, dur=1.0, kind="poison"), F("wound", v=0.4, dur=1.0)]), F("push", dist=40)], {"n_in": 2, "r": 110, "wait": 5}),
  [P("every", [F("stealth", dur=2.0, untarget=True)], t=15.0)], None,
  ["放心，我已經清空咗個肚，今次應該……應該頂得住。", "放心，我已經清空了肚子，這次應該……應該撐得住。"])
G("n30_daji", N, "front", ["破", "削"],
  A("手掣連段", NEAR, [dmg(1.4, hits=4, ramp=0.15), F("interrupt")]),
  [P("death", [F("revive", pct=0.01, n=1, if_ally_kill=5.0)])], None,
  ["上次打到最尾一關先斷氣，今次我一定要睇到片尾名單。", "上次打到最後一關才斷氣，這次我一定要看到片尾名單。"])
G("n30_xiasi", N, "front", ["掃", "削"],
  A("突然嚇你", CIR(130), [dmg(0.75), F("push", dist=40), F("sap", v=10), F("mark", v=0, dur=3.0, kind="dazed")], AOE_AI),
  [P("start", [F("stun", dur=3.0, tg="self")])], None,
  ["我一出聲佢哋就驚，不過通常係我自己驚先。", "我一出聲他們就怕，不過通常是我自己先怕。"])
G("n30_chehuo", N, "flank", ["刺", "照"],
  A("催油門撞", NEAR, [F("dash", to="target", dist=200), dmg(1.7), F("push", dist=60), F("dmg_self", pct=0.1)]),
  [P("low_hp", [F("shield", pct=0.15, dur=4.0, tg="self")], pct=0.15)], None,
  ["借借！我趕緊單，撞完呢轉先同你傾。", "借過借過！我趕單，撞完這趟再跟你聊。"])
G("n30_yezi", F_, "back", ["遠", "拉", "掃"],
  A("小心頭頂", {"sel": "dense", "shape": "circle", "r": 100, "delay": 2.0}, [dmg(1.6), F("down", dur=1.4)], AOE_AI),
  [P("start", [F("immune", tags=["delayed"], dur=-1, tg="self")])], None,
  ["我一指上天，你哋最好識得走。", "我一指天上，你們最好懂得逃。"])
G("n30_liulian", F_, "back", ["遠", "刺", "破"],
  A("丟榴槤", NEAR, [dmg(1.7, vs_state="down", x=1.8), F("armor_break", v=0.4, dur=6.0), F("push", dist=30)]),
  [P("hit_taken", [F("buff", stat="hit", v=-0.1, dur=3.0, tg="attacker")], melee=True)], None,
  ["榴槤一開，敵我不分，個個都要掩住個鼻。", "榴槤一開，敵我不分，每個人都要捂住鼻子。"])
G("n30_zhongshu", M_, "back", ["掃", "削", "照"],
  A("烈日曬", CIR(130), [dmg(0.9), F("slow", va=-0.25, dur=5.0), F("dot", dps=0.06, dur=5.0, kind="fire"), F("sap", v=20)], AOE_AI),
  [P("hit_taken", [F("energy", v=15, tg="self")], by_sc="cold", icd=4)], None,
  ["排咗成朝隊，終於輪到我出場。", "排了一整個早上的隊，終於輪到我出場。"])
G("n30_chengsi", N, "front", ["回", "定"],
  A("再嚟一碟", {"sel": "self"}, [F("heal", pct=0.25, tg="self"), F("buff", stat="size", v=0.3, dur=6.0, tg="self"), F("taunt", r=120, dur=4.0)], {"self_hp": 0.6, "wait": 5}),
  [P("start", [F("buff", stat="heal_in", v=0.5, dur=-1, tg="self")])], None,
  ["自助餐嚟㗎，唔食夠本點對得住自己？", "這是自助餐，不吃夠本怎麼對得起自己？"], old_name="大肚腩一頂")
G("n30_shedu", N, "flank", ["回", "削"],
  A("蛇撲出去", NEAR, [dmg(1.6), F("drain", pct=0.3), F("dot", dps=0.03, dur=6.0, kind="poison", pct_hp=True), F("wound", v=0.5, dur=6.0)]),
  [P("hit_taken", [F("dmg", mult=0.3, tg="attacker")], icd=2)], None,
  ["條蛇同我已經好熟，佢淨係咬其他人。", "那條蛇跟我已經很熟，牠只咬別人。"])
G("n30_diansi", F_, "back", ["遠", "拉", "掃"],
  A("插頭放電", {"sel": "near", "shape": "chain", "n": 5, "falloff": 0.15}, [dmg(1.05, vs_mark={"wet": 1.5}), F("down", dur=1.0)], AOE_AI),
  [P("hit_taken", [F("dmg", pct_hp=0.08, tg="attacker")], melee=True, icd=1)], None,
  ["唔好掂我，我成身仲有電。", "不要碰我，我全身還有電。"])
G("n30_dongsi", N, "front", ["定", "拉"],
  A("披毯", {"sel": "allies", "r": 100, "n": 3}, [F("shield", pct=0.2, dur=6.0), F("guard", r=70, pct=0.35, cap=0.06, dur=6.0)], {"ally_hp": 0.6, "wait": 5}),
  [P("attack", [F("down", dur=0.8)], n=3), P("start", [F("immune", tags=["freeze"], dur=-1, tg="self")])], None,
  ["我凍到冇感覺，所以你打我，我都冇感覺。", "我冷到沒感覺，所以你打我，我也沒感覺。"], old_name="噴嚏冰柱")
G("n30_leipi", F_, "back", ["遠", "掃", "照"],
  A("舉傘招雷", {"sel": "strong", "shape": "chain", "n": 3, "falloff": 0.0}, [dmg(1.1), F("air", dur=1.0), F("anti_air", x=1.4)], AOE_AI),
  [P("hit_taken", [F("energy", v=10, tg="self")], by_el="elec")], None,
  ["行雷嗰陣你企遠啲，我負責吸晒佢。", "打雷的時候你站遠一點，我負責全部吸走。"])
G("n30_xiangcai", N, "flank", ["破", "刺", "掃"],
  A("紙片刀", {"sel": "back", "shape": "line", "len": 220, "w": 30}, [F("dash", to="back"), dmg(1.8, hits=2, vs_state="air", x=1.8)], {"n_in": 2, "r": 130, "wait": 5}),
  [P("start", [F("buff", stat="dodge_ranged", v=0.4, dur=-1, tg="self")])], None,
  ["我而家薄過張紙，門罅都入得，你個陣型更加入得。", "我現在比紙還薄，門縫都進得去，你的陣型更進得去。"])
G("pg_tuimo", N, "front", ["掃", "定"],
  A("推磨轉轉轉", {"sel": "self", "shape": "self_circle", "r": 100}, [dmg(0.8), F("push", dist=30), F("energy", v=24, tg="allies")], AOE_AI),
  [P("ally_cast", [F("buff", stat="atk", v=0.05, dur=-1, stack=6, tg="self")])], STEADY(150, 0),
  ["磨我推，功勞你攞，我早就習慣咗。", "磨我推，功勞你拿，我早就習慣了。"])
G("pg_songding", N, "front", ["拉", "刺"],
  A("變羊回馬槍", NEAR, [dmg(1.7), F("down", dur=1.4), F("buff", stat="taken", v=-0.5, dur=4.0, tg="self")]),
  [P("death", [F("coin", v=30)])], None,
  ["你話我係鬼我就係鬼，你話我係羊……等我諗吓先。", "你說我是鬼我就是鬼，你說我是羊……讓我想想先。"])
G("pg_ji", N, "flank", ["掃", "削", "收"],
  A("死多一次", CIR(130), [dmg(0.7), F("sap", v=25), F("banish", hp_pct=0.4)], {"tg_mech": "屍變", "wait": 5}),
  [P("start", [F("stealth", dur=6.0, untarget=True)])], None,
  ["鬼都怕我，你點解唔怕？……哦，原來你未死。", "鬼都怕我，你為什麼不怕？……哦，原來你還沒死。"])
G("pg_ex", N, "front", ["拉", "掃", "削"],
  A("我有講錯嗎", CIR(130), [dmg(0.75), F("down", dur=1.4), F("silence", dur=2.5)], AOE_AI),
  [P("start", [F("buff", stat="cc_taken", v=-0.5, dur=-1, tg="self")])], None,
  ["七年喇，今次係你叫我入隊，唔好又淨係覆我一個「哦」。", "七年了，這次是你叫我入隊，不要又只回我一個「哦」。"])
G("pg_landlady", N, "front", ["掃", "削"],
  A("我講第二次", CIR(130), [dmg(0.85), F("coin", v=20), F("push", dist=30), F("slow", v=-0.6, dur=5.0), F("silence", dur=1.5), F("dispel", n=2)], AOE_AI),
  [P("every", [F("buff", stat="cast_cost", v=0.1, dur=-1, stack=3, tg="foes")], t=20.0)], None,
  ["入得我間屋就要守我嘅規矩，我唔想講第二次。", "進了我的屋就要守我的規矩，我不想說第二次。"])
G("niutou", N, "front", ["照", "定", "收"],
  A("牛角頂", NEAR, [dmg(1.6), F("air", dur=1.0), F("taunt", r=120, dur=3.0), F("banish", hp_pct=0.3)]),
  [P("start", [F("guard", r=70, pct=0.35, cap=0.06, dur=-1)])], None,
  ["鬼差開工，冇預約一律排隊，打尖嘅我頂佢出去。", "鬼差上班，沒預約一律排隊，插隊的我頂他出去。"])
G("mamian", N, "front", ["照", "收"],
  A("馬蹄踏", NEAR, [dmg(1.6, vs_state="down", x=1.8), F("banish", hp_pct=0.3)]),
  [P("start", [F("buff", stat="spd", v=0.2, dur=-1, tg="self")])], None,
  ["名單上有你個名，跑得幾快都冇用，我四隻蹄。", "名單上有你的名字，跑多快都沒用，我有四隻蹄。"])

# ======================= 標籤推導（同 cdata_test.gd 同一套規則） =======================
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
    if (single and any(x["p"] == "dmg" and int(x.get("hits", 1)) < 2 and x["mult"][0] >= 1.7 for x in act["fx"])) or ids & {"execute", "dash"}: t.add("刺")
    if ids & {"sap", "wound", "silence", "interrupt"}: t.add("削")
    if ids & {"drain", "heal", "hot"}: t.add("回")
    if "reveal" in ids or "light" in e["sc"]: t.add("照")
    if ids & {"taunt", "guard"} or (e.get("aura") and e["aura"]["side"] == "ally" and any(x["p"] == "immune" and set(x.get("tags", [])) & {"fear_aura", "confuse"} for x in e["aura"]["fx"])): t.add("定")
    if "banish" in ids: t.add("收")
    return t

def sig(e):   # 能力簽名：主動技積木＋形狀＋被動觸發／積木（查重複用）
    a = e["act"]
    s = [a["tg"].get("sel"), a["tg"].get("shape", "single")] + sorted(x["p"] for x in a["fx"])
    s += sorted("%s:%s" % (p["tr"], ",".join(sorted(x["p"] for x in p["fx"]))) for p in e.get("pas", []))
    if e.get("aura"): s.append("aura:" + ",".join(sorted(x["p"] for x in e["aura"]["fx"])))
    return "|".join(map(str, s))

def describe_mech(ms): return "、".join(ms)

# ======================= 輸出 =======================
def build():
    errs = []
    for k, e in AB.items():
        d = derive(e)
        if set(e["tags"]) != d: errs.append("%s 標籤 %s ≠ 推導 %s" % (k, e["tags"], sorted(d, key=TAGS.index)))
        if not (2 <= len(e["tags"]) <= 3): errs.append("%s 標籤數 %d" % (k, len(e["tags"])))
        e["tags"] = sorted(e["tags"], key=TAGS.index)
    sigs = {}
    for k, e in AB.items(): sigs.setdefault(sig(e), []).append(k)
    for s, ks in sigs.items():
        if len(ks) > 1: errs.append("能力重複：%s" % ks)
    says = {}
    for k, e in AB.items():
        y = e.get("say", ["", ""])[0]
        if not y: errs.append("%s 冇台詞" % k)
        says.setdefault(y, []).append(k)
    for y, ks in says.items():
        if len(ks) > 1: errs.append("台詞重複：%s" % ks)
    # 敵人
    ENEMY = {}
    for k in ET:
        if k in ("youhun", "egui", "xiaogui", "zombie", "shuigui", "zhiren"): e = ent(k); kind = "fod"
        elif k == "huang": e = ent(k); kind = "boss"
        else: e = ent(k); kind = "named"
        f = SYS[e["sys"]]
        # 例外嚇法（約三成名鬼用非本系嚇法，例如提燈妖＝燈）：自己識嘅嘢唔怕 → 由「怕」搬去「唔怕」
        fe = [x for x in (f[0], f[1]) if x != e["sc"]]
        im = [f[2]] + ([e["sc"]] if e["sc"] in (f[0], f[1]) else [])
        why = ["怕%s：%s" % (x, f[3] if x == f[0] else f[4]) for x in fe] + ["唔怕%s：%s" % (f[2], f[5])]
        if len(im) > 1: why.append("唔怕%s：自己識玩嘅把戲唔怕" % e["sc"])
        ENEMY[k] = {"sys": e["sys"], "sc": [SC[e["sc"]]], "fear": [SC[x] for x in fe], "imm": [SC[x] for x in im], "why": why,
                    "mech": e["mech"], "tier": e.get("t", 0), "kind": kind, "recruit": kind == "named", "use_abil": k in AB}
    # 頂替表合法
    for a, (b, hm, am) in SUB.items():
        ea = ent(a); eb = ent(b)
        if b not in ET: errs.append("頂替 %s→%s 冇 ENEMY_T" % (a, b))
        if ea["sys"] != eb["sys"]: errs.append("頂替 %s→%s 唔同系 %s/%s" % (a, b, ea["sys"], eb["sys"]))
    # 據點
    camps = {}; subs_used = {}
    # 每章開放嘅機制（累積）：按該章實際出場敵人嘅機制出現次數揀新嘅
    allowed = []; intro = {}
    for ch in range(6):
        cnt = {}
        for c in CAMPS:
            if c["c"] != ch: continue
            for i in c["plan"]:
                for m in ENEMY[real(i)[0]]["mech"]: cnt[m] = cnt.get(m, 0) + 1
        later = {m for c in CAMPS if c["c"] > ch for i in c["plan"] for m in ENEMY[real(i)[0]]["mech"]}
        new = sorted([m for m in cnt if m not in allowed], key=lambda m: (m in later, -cnt[m], MECHS.index(m)))[:NEW_PER_CH[ch]]   # 之後再冇機會出嘅先教
        if ch == 0: new = ["再生", "突襲", "散骨"]   # counter.md 13：第 1 關只教最直觀三個
        for m in new: intro[m] = ch
        allowed = allowed + new
        for c in CAMPS:
            if c["c"] != ch: continue
            c["allow"] = list(allowed)
    for c in CAMPS:
        en = []; hm = []; am = []
        for i in c["plan"]:
            k, h, a = real(i); en.append(k); hm.append(h); am.append(a)
            if k != i: subs_used.setdefault(i, set()).add(c["id"])
        raw = {}
        for k in en:
            for m in ENEMY[k]["mech"]:
                if m in c["allow"]: raw[m] = raw.get(m, 0) + (2 if k == en[-1] else 1)   # 駐守鬼嘅機制優先
        keep = sorted(raw, key=lambda m: (-raw[m], MECHS.index(m)))[:RING_CAP[c["ring"] - 1]]
        mech = sorted(keep, key=MECHS.index)
        mk = [[m for m in ENEMY[k]["mech"] if m in keep] for k in en]
        pmech = sorted({m for i in c["plan"] for m in ent(i)["mech"]}, key=MECHS.index)
        guard = en[-1]; gp = c["plan"][-1]
        if not ENEMY[guard]["recruit"]: errs.append("%s 駐守鬼 %s 唔可招降" % (c["id"], guard))
        sy = {}
        for k in en: sy[ENEMY[k]["sys"]] = sy.get(ENEMY[k]["sys"], 0) + 1
        camps[c["id"]] = {"c": c["c"], "ring": c["ring"], "dir": c["dir"], "gang": c["gang"], "en": en, "plan": c["plan"],
                          "hm": hm, "am": am, "mk": mk, "guard": guard, "guard_plan": gp, "mech": mech, "q": mech[:2], "mech_plan": pmech,
                          "sys": sorted(sy, key=lambda s: -sy[s]), "king": c["king"]}
    gangs = {}
    for ch, ds in REAL_GANGS.items():
        gangs[str(ch - 1)] = {}
        for d, (nm, mem, fod) in ds.items():
            ms = sorted({m for i in mem + fod for m in ent(i)["mech"]}, key=MECHS.index)
            sy = []
            for i in mem:
                s = ent(i)["sys"]
                if s not in sy: sy.append(s)
            gangs[str(ch - 1)][d] = {"name": nm, "sys": sy, "mech_plan": ms, "mem": mem, "fod": fod,
                                     "mem_now": [real(i)[0] for i in mem], "fod_now": [real(i)[0] for i in fod]}
    # 魂魄來源（審查修正 9）：據點駐守／野外王／王座重遊（劇情王）
    src = {}
    for cid, c in camps.items():
        for k in sorted(set(c["en"])):
            if ENEMY[k]["recruit"]: src.setdefault(k, []).append({"t": "camp", "id": cid, "guard": k == c["guard"]})
    for ci, m in ZONES.items():
        for z in m["zones"]:
            for b in z.get("bosses") or []:
                stg = b.get("stage") or {}
                k = stg.get("boss")
                if k and k in ENEMY and ENEMY[k]["recruit"]: src.setdefault(k, []).append({"t": "wildboss", "id": b["id"], "c": int(ci)})
    for ci, chp in enumerate(CORE["CHAPTERS"]):
        for si, stg in enumerate(chp["stages"]):
            for k in sorted(set(stg.get("en", []))):
                if k in ("eguiking", "toyol", "laojiang", "pontianak", "pocong", "penanggal", "baiwu", "heiwu"):
                    src.setdefault(k, []).append({"t": "throne", "stage": "%d-%d" % (ci + 1, si + 1)})
    recruit = sorted(k for k in AB if k not in ("afu", "xiaozhi", "mengpo") and (ENEMY.get(k, {}).get("recruit")))
    for k in recruit:
        if not src.get(k): errs.append("%s 冇魂魄來源" % k)
    plan_names = {i: ent(i)["name"] for i in sorted(set(i for c in CAMPS for i in c["plan"]))}
    sub_tab = [{"plan": a, "plan_name": ent(a)["name"], "sys": ent(a)["sys"], "now": SUB[a][0], "now_name": ET[SUB[a][0]][2],
                "hm": SUB[a][1], "am": SUB[a][2], "camps": sorted(subs_used.get(a, []))} for a in SUB]
    counter = {
        "v": 1,
        "note": "cdata 線生成（tools/cdata/build_cdata.py）。第一階段：新鬼／新雜兵用同系現有鬼頂替（subs）；plan＝原定組合（第二階段出圖後換返）。",
        "scares": {v: k for k, v in SC.items()},
        "sys": {s: {"fear": [SC[f[0]], SC[f[1]]], "imm": SC[f[2]], "why": {SC[f[0]]: f[3], SC[f[1]]: f[4], SC[f[2]]: f[5]}} for s, f in SYS.items()},
        "mult": {"skill_fear": 1.35, "skill_imm": 0.6, "combo": 1.8, "chase": 1.3, "atk_fear": 1.15, "atk_imm": 0.8, "foe_fear": 1.25, "foe_imm": 0.75, "daze_s": 3.2, "clamp": [0.2, 4.0]},
        "mech": {m: dict(MECH_DEF[m][2], id=MECH_DEF[m][0], tags=MECH_DEF[m][1]) for m in MECHS},
        "ch_k": {"4": {"hp": 0.70, "atk": 0.55}, "5": {"hp": 0.65, "atk": 0.50}},          # 主線（步驟 A）
        "sortie_k": {"4": {"hp": 0.55, "atk": 0.55}, "5": {"hp": 0.50, "atk": 0.50}},      # 據點（審查修正 10：同舊主線同級起步，之後平衡線調）
        "mech_intro": intro, "ring_cap": RING_CAP,
        "src": src, "src_note": "t：camp＝據點（guard＝駐守鬼主魂）、wildboss＝野外王重打、throne＝王座重遊（主線劇情王重打）",
        "new": {k: {"name": R[k]["name"], "sys": R[k]["sys"], "sc": SC[R[k]["sc"]], "mech": R[k]["mech"], "ch": R[k]["ch"], "tags": v, "sub": SUB[k][0], "note": NEW_NOTE.get(k, "")} for k, v in NEW_TAGS.items()},
        "ring_mech": RING_MECH,
        "boss_hp": 1.6,
        "gangs": gangs,
        "camps": camps,
        "subs": sub_tab,
        "names": plan_names,
    }
    abil = {
        "ver": 1,
        "_stub": "TAGS／MECH 係 cdata 線最小 stub（abcore 擁有結構，整合以 abcore 為準）；ABIL／ENEMY／CAMP_MOD 由 cdata 線擁有。",
        "TAGS": {t: {"id": TAG_DEF[t][0], "n": TAG_DEF[t][1], "icon": "ab_" + TAG_DEF[t][0], "c": TAG_DEF[t][2], "desc": TAG_DEF[t][3]} for t in TAGS},
        "MECH": {m: {"id": MECH_DEF[m][0], "n": m, "icon": "mc_" + MECH_DEF[m][0], "counter": MECH_DEF[m][1], "warn": MECH_DEF[m][3]} for m in MECHS},
        "ABIL": AB,
        "ENEMY": ENEMY,
        "CAMP_MOD": {"ring": RING_MECH, "cap": RING_CAP, "note": "每據點實際機制見 counter.json camps[id].mech／mk（每隻敵人嘅機制＝ENEMY.mech ∩ 據點 mech）"},
    }
    return errs, abil, counter

if __name__ == "__main__":
    errs, abil, counter = build()
    for e in errs: print("ERR", e)
    if errs and "--force" not in sys.argv: sys.exit(1)
    json.dump(abil, open(os.path.join(ROOT, "data/abil.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    json.dump(counter, open(os.path.join(ROOT, "data/nat/counter.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    # 報告
    from collections import Counter
    tc = Counter(t for e in AB.values() for t in e["tags"])
    print("ABIL %d 隻；標籤分佈：" % len(AB) + "、".join("%s %d" % (t, tc[t]) for t in TAGS))
    for m in MECHS:
        cs = [k for k, e in AB.items() if set(e["tags"]) & set(MECH_DEF[m][1])]
        print("  機制 %s 應對 %d 隻" % (m, len(cs)))
    rc = Counter("遠" if e["rng"] >= 150 else ("中" if e["rng"] >= 90 else "近") for e in AB.values())
    print("射程：", dict(rc))
    print("ENEMY %d；據點 %d；鬼幫 %d" % (len(abil["ENEMY"]), len(counter["camps"]), sum(len(v) for v in counter["gangs"].values())))
