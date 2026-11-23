#!/usr/bin/env python3
# [equip] 生成 data/nat/equip.json（武器裝備數據）。改數值只改呢個檔頂部表，再跑：python3 tools/equip_build.py
# 設計稿：/home/claude/docs/equip_design.md
import json, os

GRADE = {"凡": 0, "良": 1, "精": 2, "名": 3}
GRADE_STAR = [0, 1, 3, 5]            # 兵器檔★解鎖
GRADE_COIN = [200, 1500, 12000, 90000]
RECYCLE = 0.3
CAP = {"atk": 0.25, "hp": 0.25, "taken": -0.10, "energy": 0.20, "aspd": 0.12, "spd": 0.15, "heal_in": 0.25}
SC_BONUS = 0.08                       # 同聲同氣：額外攻
MAX_TAG = 1
MAX_NAMED = 1

# ---- 民用兵器（遊魂兵）：tier、款、攻倍、血倍、外觀(look: hand/head/body)、用料、名、笑位 ----
ML = [
 ("ml_zhugan", 0, "A", 1.0, 1.0, "hand", "pole", {"m_bamboo": 1}, ["晾衫竹", "晾衣竹竿"], ["曬咗一百年衫嘅竹，打鬼之前記得收衫。", "曬了一百年衣服的竹竿，打鬼之前記得收衣服。"]),
 ("ml_jimao", 0, "B", 1.12, 0.9, "hand", "duster", {"m_wood": 1}, ["雞毛掃", "雞毛撢子"], ["掃塵掃到惡鬼打乞嗤。", "撢灰撢到惡鬼打噴嚏。"]),
 ("ml_chaidao", 1, "A", 1.0, 1.0, "hand", "cleaver", {"m_wood": 1, "m_strip": 1}, ["生鏽柴刀", "生鏽柴刀"], ["伐木場報銷落嚟，鏽到要兩隻鬼一齊斬。", "伐木場報廢下來的，鏽到要兩隻鬼一起砍。"]),
 ("ml_wokchan", 1, "B", 1.12, 0.9, "hand", "spatula", {"m_plank": 1, "m_strip": 1}, ["鐵鑊鏟", "鐵鍋鏟"], ["大排檔夜更師傅借出，講明聽朝六點要還。", "大排檔夜班師傅借出來的，說好明早六點要還。"]),
 ("ml_tengpai", 2, "A", 1.0, 1.0, "hand", "shield", {"m_strip": 2, "m_rope": 1}, ["紙紮藤牌", "紙紮藤牌"], ["擋得住一次，第二次靠信念。", "擋得住一次，第二次靠信念。"]),
 ("ml_suogu", 2, "B", 0.9, 1.12, "hand", "umbrella", {"m_paper": 1, "m_strip": 1, "m_rope": 1}, ["縮骨遮", "折疊傘"], ["開遮擋、收遮戳；落雨仲有得用。", "開傘擋、收傘戳；下雨還能用。"]),
 ("ml_kuijia", 3, "A", 1.0, 1.0, "body", "paper_armor", {"m_paper": 2, "m_strip": 1, "m_rope": 1}, ["紙紮盔甲", "紙紮盔甲"], ["長官話量身訂造，其實全部均碼。", "長官說是量身訂做，其實全部均碼。"]),
 ("ml_dituo", 3, "B", 1.12, 0.9, "hand", "mop", {"m_wood": 2, "m_rope": 2}, ["地拖長槍", "拖把長槍"], ["清潔部退役，拖過嘅地比惡鬼仲污糟。", "清潔部退役，拖過的地比惡鬼還髒。"]),
 ("ml_wokhelm", 4, "A", 1.0, 1.0, "head", "wok_helm", {"m_plank": 2, "m_rope": 1}, ["退役鐵鑊頭盔", "退役鐵鍋頭盔"], ["炒咗三十年嘅鑊，戴落去仲有鑊氣。", "炒了三十年的鍋，戴上去還有鍋氣。"]),
 ("ml_gongdi", 4, "B", 0.9, 1.12, "head", "hardhat", {"m_paper": 2, "m_plank": 1, "m_rope": 1}, ["工地安全帽", "工地安全帽"], ["「安全第一」四個字，寫喺一個死人頭上。", "「安全第一」四個字，寫在一個死人頭上。"]),
 ("ml_tietong", 5, "A", 1.0, 1.0, "hand", "pipe", {"m_plank": 3, "m_rope": 2}, ["收數鐵通", "討債鐵管"], ["前任收數佬遺物，敲一下惡鬼會自動還錢。", "前任討債人的遺物，敲一下惡鬼會自動還錢。"]),
 ("ml_huanshou", 5, "B", 1.12, 0.9, "hand", "ring_sword", {"m_plank": 2, "m_strip": 2, "m_rope": 1}, ["生鏽環首刀", "生鏽環首刀"], ["古董舖話係漢朝貨，底下印住「出口加工」。", "古董店說是漢朝貨，底下印著「出口加工」。"]),
 ("ml_jiaban", 6, "A", 1.0, 1.0, "body", "ot_armor", {"m_paper": 3, "m_strip": 2, "m_plank": 2}, ["加班戰甲（附免責聲明）", "加班戰甲（附免責聲明）"], ["地府集團配發：打爛唔賠，打贏唔加薪。", "地府集團配發：打壞不賠，打贏不加薪。"]),
 ("ml_suanpan", 6, "B", 0.9, 1.12, "hand", "abacus", {"m_plank": 3, "m_strip": 2, "m_paper": 1}, ["鐵算盤盾", "鐵算盤盾"], ["每擋一下都幫你計數，月尾一齊找數。", "每擋一下都幫你記帳，月底一起結算。"]),
]

# ---- 名鬼裝備：id、槽、等、數值、標籤、同聲同氣嚇法、外觀、用料、名、笑位 ----
EQ = [
 # 兵器
 ("eq_tuoxie", "wea", "凡", {"atk": 0.06, "aspd": 0.06}, "", "", "slipper", {"m_plank": 2, "m_rope": 1}, ["膠拖鞋", "膠拖鞋"], ["天下武功，唯拖鞋不破；打完仲著得返。", "天下武功，唯拖鞋不破；打完還能穿回去。"]),
 ("eq_jimao", "wea", "凡", {"atk": 0.05}, "掃", "", "duster", {"m_bamboo": 4, "m_rope": 2}, ["雞毛掃", "雞毛撢子"], ["一掃一大片，連蜘蛛網都冇埋。", "一撢一大片，連蜘蛛網都沒了。"]),
 ("eq_wokchan", "wea", "凡", {"atk": 0.08}, "", "", "spatula", {"m_plank": 3, "m_strip": 2}, ["鐵鑊鏟", "鐵鍋鏟"], ["炒得住小炒，炒得住惡鬼。", "炒得了小炒，也炒得了惡鬼。"]),
 ("eq_suanpan", "wea", "良", {"atk": 0.09}, "破", "", "abacus", {"m_plank": 6, "m_strip": 4}, ["鐵算盤", "鐵算盤"], ["一粒一粒計，計到個殼都爆。", "一顆一顆算，算到殼都爆了。"]),
 ("eq_danca", "wea", "良", {"atk": 0.08}, "遠", "", "slingshot", {"m_wood": 6, "m_rope": 4}, ["天台彈叉", "天台彈弓"], ["天台曬鹹魚嗰陣用嚟趕雀，而家趕鬼。", "天台曬鹹魚時用來趕麻雀，現在趕鬼。"]),
 ("eq_suogu", "wea", "良", {"atk": 0.07, "hp": 0.04}, "定", "", "umbrella", {"m_paper": 6, "m_strip": 4}, ["縮骨遮", "折疊傘"], ["開遮企喺度，隔籬啲鬼都覺得安心。", "撐傘站在那裡，旁邊的鬼都覺得安心。"]),
 ("eq_liangcha", "wea", "精", {"atk": 0.11}, "拉", "", "fork_pole", {"m_bamboo": 12, "m_rope": 8, "m_strip": 6}, ["晾衫叉", "晾衣叉"], ["高處啲衫叉得落嚟，飛喺天嗰啲都叉得落嚟。", "高處的衣服叉得下來，飛在天上的也叉得下來。"]),
 ("eq_huanshou", "wea", "精", {"atk": 0.13}, "刺", "", "ring_sword", {"m_plank": 12, "m_strip": 8, "m_rope": 6}, ["生鏽環首刀", "生鏽環首刀"], ["唔知斬過乜，總之好有經驗。", "不知道砍過什麼，總之很有經驗。"]),
 ("eq_huoqi", "wea", "名", {"atk": 0.16, "aspd": 0.05}, "", "breath", "wok_spatula_gold", {"m_plank": 30, "m_strip": 20, "m_rope": 20}, ["三十年鑊氣鏟", "三十年鍋氣鏟"], ["大排檔師傅退休嗰晚交落嚟：「火要猛，手要快，收工要準時。」", "大排檔師傅退休那晚交下來：「火要猛，手要快，下班要準時。」"]),
 # 護身
 ("eq_xizhuang", "arm", "凡", {"hp": 0.06, "energy": 0.05}, "", "", "suit", {"m_paper": 4, "m_rope": 1}, ["紙紮西裝", "紙紮西裝"], ["著住開會，大招都儲得快啲（因為冇人想聽你講）。", "穿著開會，大招也蓄得快一點（因為沒人想聽你講）。"]),
 ("eq_anquan", "arm", "凡", {"hp": 0.07, "taken": -0.03}, "", "", "hardhat", {"m_paper": 3, "m_plank": 2}, ["工地安全帽", "工地安全帽"], ["頭戴式。安全帽係保住咗嘅。", "頭戴式。安全帽倒是保住了。"]),
 ("eq_tengpai", "arm", "凡", {"hp": 0.06, "taken": -0.04}, "", "", "shield", {"m_strip": 4, "m_rope": 2}, ["藤牌", "藤牌"], ["藤織嘅，好透氣，打中都透氣。", "藤編的，很透氣，被打中也透氣。"]),
 ("eq_weiqun", "arm", "良", {"hp": 0.09, "heal_in": 0.10}, "回", "", "apron", {"m_paper": 6, "m_rope": 4}, ["油漬圍裙", "油漬圍裙"], ["抹得手，抹得血，仲抹得返啲元氣。", "擦得了手，擦得了血，還能擦回一點元氣。"]),
 ("eq_tiewok", "arm", "良", {"hp": 0.11, "taken": -0.05}, "", "", "wok_back", {"m_plank": 8, "m_rope": 3}, ["反轉鐵鑊", "反轉鐵鍋"], ["揹喺背脊，龜殼嘅原理，龜嘅尊嚴。", "揹在背上，龜殼的原理，龜的尊嚴。"]),
 ("eq_baoan", "arm", "良", {"hp": 0.10, "taken": -0.03}, "定", "", "guard_uniform", {"m_paper": 6, "m_strip": 3, "m_rope": 2}, ["保安制服", "保全制服"], ["著上身即刻覺得自己守得住成條村，雖然人工冇加。", "一穿上就覺得自己守得住整條村，雖然薪水沒加。"]),
 ("eq_guanban", "arm", "精", {"hp": 0.14, "taken": -0.06}, "", "", "coffin_shield", {"m_plank": 20, "m_rope": 6}, ["二手棺材板盾", "二手棺材板盾"], ["前任用家話好瞓。", "前任用家說很好睡。"]),
 ("eq_yulou", "arm", "精", {"hp": 0.12}, "收", "", "raincoat", {"m_paper": 16, "m_strip": 6, "m_rope": 6}, ["紙紮雨褸", "紙紮雨衣"], ["攤開蓋住倒地嗰隻，佢就翻唔到身。", "攤開蓋住倒地那隻，它就翻不了身。"]),
 ("eq_laogong", "arm", "名", {"hp": 0.18, "taken": -0.06, "energy": 0.05}, "", "", "old_uniform", {"m_paper": 30, "m_plank": 20, "m_rope": 20}, ["三十年老員工制服", "三十年老員工制服"], ["洗到褪晒色，仲係最硬淨嗰件。", "洗到全褪色了，還是最耐穿的那件。"]),
 # 隨身物
 ("eq_staffcard", "acc", "凡", {"energy": 0.08}, "", "", "staff_card", {"m_paper": 2, "m_rope": 1}, ["員工證", "員工證"], ["掛喺心口，拍卡入閘，拍卡出招。", "掛在胸前，刷卡進閘，刷卡出招。"]),
 ("eq_liangchapot", "acc", "凡", {"heal_in": 0.15}, "回", "", "tea_pot", {"m_wood": 2, "m_strip": 2}, ["涼茶壺", "涼茶壺"], ["飲啖涼茶，下火回氣，苦到惡鬼都皺眉。", "喝口涼茶，降火回氣，苦到惡鬼都皺眉。"]),
 ("eq_dianzhan", "acc", "良", {"energy": 0.05}, "照", "light", "flashlight", {"m_paper": 4, "m_plank": 3}, ["保安電筒", "保全手電筒"], ["照一照，匿埋嗰隻即刻現形，跟住問佢攞員工證。", "照一照，躲起來那隻立刻現形，接著問它要員工證。"]),
 ("eq_naozhong", "acc", "良", {"aspd": 0.05}, "削", "", "alarm_clock", {"m_plank": 4, "m_strip": 4}, ["舊鬧鐘", "舊鬧鐘"], ["一響，乜嘢回血都停；包括你嘅午睡。", "一響，什麼回血都停；包括你的午睡。"]),
 ("eq_yinji", "acc", "良", {"energy": 0.06}, "拉", "sound", "whistle", {"m_strip": 5, "m_rope": 3}, ["銀雞（哨子）", "哨子"], ["吹一聲，飛喺天嗰啲都跌落嚟睇下發生咩事。", "吹一聲，飛在天上的都掉下來看看發生什麼事。"]),
 ("eq_paperphone", "acc", "精", {"energy": 0.12}, "", "phone", "paper_phone", {"m_paper": 14, "m_strip": 8}, ["紙紮手提電話", "紙紮手機"], ["打唔通，但係響得好大聲。", "打不通，但是響得很大聲。"]),
 ("eq_fengyou", "acc", "精", {"spd": 0.10, "heal_in": 0.10}, "", "", "oil_bottle", {"m_bamboo": 10, "m_rope": 8, "m_paper": 6}, ["驅風油", "驅風油"], ["搽兩滴，行得快過收工鐘。", "擦兩滴，走得比下班鐘還快。"]),
 ("eq_jinzheng", "acc", "名", {"energy": 0.15, "atk": 0.05, "hp": 0.05}, "", "", "gold_card", {"m_paper": 30, "m_strip": 20, "m_rope": 20}, ["鍍金長期服務證", "鍍金長期服務證"], ["服務滿三十年頒發，鍍金部分已經甩晒。", "服務滿三十年頒發，鍍金部分已經掉光了。"]),
]

# 錨點（以角色高 H＝1、腳底中間為原點、面向右，y 向上為負）；未列＝自動估
ANCHOR = {
 "afu": {"hand": [0.22, -0.42], "head": [0.0, -0.95]},
 "xiaozhi": {"hand": [0.22, -0.40], "head": [0.0, -0.95]},
 "eguiking": {"hand": [0.30, -0.45], "head": [0.02, -0.97]},
 "laojiang": {"hand": [0.34, -0.62], "head": [0.0, -0.97]},
 "pontianak": {"hand": [0.20, -0.48], "head": [0.0, -0.97]},
 "pocong": {"hand": [0.14, -0.50], "head": [0.0, -0.98]},
 "tianhua": {"hand": [0.24, -0.45], "head": [0.0, -0.95]},
 "youhun": {"hand": [0.24, -0.46], "head": [0.0, -0.92]},
}

def main():
    items = {}
    for (i, t, v, ak, hk, look, shape, rec, n, d) in ML:
        items[i] = {"id": i, "kind": "ml", "slot": "ml", "tier": t, "var": v, "atk_k": ak, "hp_k": hk, "look": look, "shape": shape,
                    "rec": rec, "n": n, "d": d, "price": 40, "bld": "st_bingqi"}
    for (i, sl, g, st, tag, sc, shape, rec, n, d) in EQ:
        gi = GRADE[g]
        look = {"wea": "hand", "arm": "body", "acc": "belt"}[sl]
        if shape == "hardhat": look = "head"
        items[i] = {"id": i, "kind": "eq", "slot": sl, "grade": gi, "st": st, "tag": tag, "sc": sc, "look": look, "shape": shape,
                    "rec": rec, "coin": GRADE_COIN[gi], "star": GRADE_STAR[gi], "price": int(GRADE_COIN[gi] * RECYCLE), "n": n, "d": d, "bld": "st_bingqi"}
    out = {"v": 1, "GRADE_N": [["凡", "凡"], ["良", "良"], ["精", "精"], ["名", "名"]], "GRADE_COL": ["#8a8478", "#4e9a4a", "#3f78c0", "#d2a12a"],
           "SLOT_N": {"wea": ["兵器", "兵器"], "arm": ["護身", "護身"], "acc": ["隨身物", "隨身物"]},
           "CAP": CAP, "SC_BONUS": SC_BONUS, "MAX_TAG": MAX_TAG, "MAX_NAMED": MAX_NAMED, "RECYCLE": RECYCLE,
           "ITEMS": items, "ANCHOR": ANCHOR}
    p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data", "nat", "equip.json")
    with open(p, "w", encoding="utf-8") as f: json.dump(out, f, ensure_ascii=False, indent=1)
    print("equip.json", len(items), "items")

if __name__ == "__main__": main()
