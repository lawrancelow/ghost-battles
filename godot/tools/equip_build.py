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

# 錨點人工表（[anchor] 線逐隻睇全身圖＋10% 格網定；蓋過 tools/equip_anchor.json 自動估）
#   座標：角色高 H＝1、腳底中間＝原點、x 向右（圖右）、y 向上為負
#   hand＝揸兵器嗰隻手（揀空手；hand.x < 0＝圖左邊嗰隻手，兵器向左外斜）
#   head＝[頭中線 x, 頭頂 y]；hw＝帽闊；帽邊落喺 head.y + 0.36×hw（貼住頭髮）；黑白無常戴喺高帽頂
#   nh＝"side"：無手／兩手都冇空 → 兵器底企喺 hand 位（輪廓外側，由 alpha 計）、斜倚身側；"back"：本身已揸兵器 → 斜揹身後（hand＝膊頭位）；"top"：打橫頂喺頭上
#   fr＝1：手喺身前（兵器後面大半俾身體遮住會似浮喺膊頭後）→ 兵器畫喺前層、由拳頭起
#   第二批 30 隻（art_pending/b2，未入 assets）都已經定好，圖一入庫即生效
ANCHOR = {
 "afu": {"hand": [0.18, -0.60], "head": [-0.03, -0.959], "hw": 0.40, "nh": "back"},
 "baiwu": {"hand": [0.19, -0.33], "head": [0.00, -1.038], "hw": 0.30},
 "bm_hou": {"hand": [0.51, -0.04], "head": [0.00, -0.939], "hw": 0.40, "nh": "side"},
 "bm_jembalang": {"hand": [0.40, -0.40], "head": [0.00, -0.892], "hw": 0.38},
 "bm_krasue": {"hand": [0.40, -0.04], "head": [0.00, -0.817], "hw": 0.34, "nh": "side"},
 "bm_langsuir": {"hand": [-0.26, -0.62], "head": [-0.02, -0.923], "hw": 0.30, "fr": 1},
 "bm_pang": {"hand": [0.30, -0.36], "head": [0.00, -0.935], "hw": 0.36},
 "bm_shuten": {"hand": [0.51, -0.04], "head": [0.00, -0.899], "hw": 0.40, "nh": "side"},
 "bm_taotie": {"hand": [0.46, -0.04], "head": [0.00, -1.041], "hw": 0.46, "nh": "side"},
 "egui": {"hand": [0.15, -0.33], "head": [-0.05, -1.022], "hw": 0.38},
 "eguiking": {"hand": [0.10, -0.58], "head": [0.00, -0.939], "hw": 0.40, "fr": 1},
 "heiwu": {"hand": [0.25, -0.27], "head": [0.00, -1.028], "hw": 0.30},
 "huang": {"hand": [-0.25, -0.62], "head": [-0.05, -0.922], "hw": 0.38, "nh": "back"},
 "laojiang": {"hand": [-0.29, -0.47], "head": [0.00, -0.875], "hw": 0.50},
 "mamian": {"hand": [-0.28, -0.58], "head": [-0.05, -0.921], "hw": 0.35, "nh": "back"},
 "mengpo": {"hand": [0.27, -0.04], "head": [0.00, -0.882], "hw": 0.38, "nh": "side"},
 "n30_aswang": {"hand": [-0.27, -0.35], "head": [-0.08, -0.947], "hw": 0.34},
 "n30_baigujing": {"hand": [0.20, -0.35], "head": [0.00, -0.937], "hw": 0.34},
 "n30_banshee": {"hand": [0.25, -0.38], "head": [0.00, -0.965], "hw": 0.36, "fr": 1},
 "n30_bunian": {"hand": [0.20, -0.52], "head": [0.00, -0.903], "hw": 0.30},
 "n30_changgui": {"hand": [-0.36, -0.53], "head": [-0.18, -0.930], "hw": 0.32},
 "n30_chehuo": {"hand": [0.25, -0.36], "head": [0.02, -0.961], "hw": 0.46},
 "n30_chengsi": {"hand": [0.30, -0.04], "head": [-0.12, -0.925], "hw": 0.36, "nh": "side"},
 "n30_chochin": {"hand": [0.35, -0.04], "head": [0.08, -0.964], "hw": 0.40, "nh": "side"},
 "n30_churel": {"hand": [0.25, -0.36], "head": [-0.05, -0.930], "hw": 0.32},
 "n30_daji": {"hand": [0.26, -0.04], "head": [-0.02, -0.909], "hw": 0.40, "nh": "side"},
 "n30_danxiao": {"hand": [0.28, -0.04], "head": [0.00, -0.965], "hw": 0.36, "nh": "side"},
 "n30_diansi": {"hand": [0.20, -0.33], "head": [0.00, -0.892], "hw": 0.38},
 "n30_diaosi": {"hand": [0.22, -0.40], "head": [-0.02, -0.917], "hw": 0.34},
 "n30_dongsi": {"hand": [0.36, -0.04], "head": [0.00, -0.912], "hw": 0.38, "nh": "side"},
 "n30_dugui": {"hand": [0.35, -0.04], "head": [-0.05, -0.899], "hw": 0.40, "nh": "side"},
 "n30_gashadokuro": {"hand": [-0.25, -0.15], "head": [-0.12, -0.937], "hw": 0.34, "fr": 1},
 "n30_genderuwo": {"hand": [0.30, -0.22], "head": [0.03, -0.949], "hw": 0.40},
 "n30_guhangui": {"hand": [0.37, -0.04], "head": [0.00, -0.897], "hw": 0.34, "nh": "side"},
 "n30_guixinniang": {"hand": [0.36, -0.04], "head": [-0.02, -0.926], "hw": 0.42, "nh": "side"},
 "n30_hanba": {"hand": [0.28, -0.44], "head": [0.00, -0.962], "hw": 0.38},
 "n30_hannya": {"hand": [0.22, -0.38], "head": [-0.10, -0.903], "hw": 0.30},
 "n30_hantugalah": {"hand": [0.17, -0.73], "head": [-0.05, -0.994], "hw": 0.22},
 "n30_hanturaya": {"hand": [0.28, -0.32], "head": [-0.05, -0.963], "hw": 0.30, "fr": 1},
 "n30_jenglot": {"hand": [0.13, -0.33], "head": [0.00, -0.873], "hw": 0.30, "fr": 1},
 "n30_jerangkung": {"hand": [0.25, -0.58], "head": [0.05, -0.939], "hw": 0.26},
 "n30_jiugui": {"hand": [-0.33, -0.04], "head": [-0.05, -0.946], "hw": 0.42, "nh": "side"},
 "n30_kappa": {"hand": [0.39, -0.04], "head": [0.00, -0.966], "hw": 0.42, "nh": "side"},
 "n30_kasaobake": {"hand": [0.36, -0.04], "head": [0.02, -0.968], "hw": 0.30, "nh": "side"},
 "n30_kuchisake": {"hand": [0.20, -0.64], "head": [-0.02, -0.910], "hw": 0.32, "nh": "back"},
 "n30_leipi": {"hand": [-0.27, -0.38], "head": [-0.05, -0.872], "hw": 0.38, "fr": 1},
 "n30_liulian": {"hand": [0.16, -0.04], "head": [0.00, -0.919], "hw": 0.40, "nh": "side"},
 "n30_maenak": {"hand": [0.22, -0.32], "head": [0.00, -0.883], "hw": 0.30, "fr": 1},
 "n30_maoshi": {"hand": [-0.42, -0.47], "head": [-0.15, -0.912], "hw": 0.38},
 "n30_nopperabo": {"hand": [0.22, -0.35], "head": [-0.02, -0.910], "hw": 0.32},
 "n30_pelesit": {"hand": [0.52, -0.04], "head": [-0.12, -0.683], "hw": 0.30, "nh": "side"},
 "n30_phiam": {"hand": [0.17, -0.25], "head": [-0.05, -0.872], "hw": 0.38, "fr": 1},
 "n30_polong": {"hand": [-0.24, -0.60], "head": [-0.08, -0.916], "hw": 0.28},
 "n30_qionggui": {"hand": [0.15, -0.33], "head": [0.00, -0.952], "hw": 0.38},
 "n30_rokurokubi": {"hand": [0.13, -0.32], "head": [-0.18, -0.913], "hw": 0.30},
 "n30_shanxiao": {"hand": [0.35, -0.25], "head": [0.00, -0.925], "hw": 0.36},
 "n30_shedu": {"hand": [-0.40, -0.62], "head": [-0.05, -0.952], "hw": 0.38},
 "n30_shidu": {"hand": [0.34, -0.04], "head": [0.00, -0.952], "hw": 0.38, "nh": "side"},
 "n30_taozhai": {"hand": [-0.45, -0.04], "head": [-0.05, -0.959], "hw": 0.40, "nh": "side"},
 "n30_tikbalang": {"hand": [0.20, -0.43], "head": [-0.05, -0.933], "hw": 0.30, "fr": 1},
 "n30_vetala": {"hand": [0.18, -0.66], "head": [-0.08, -0.923], "hw": 0.30, "nh": "back"},
 "n30_wutou": {"hand": [-0.25, -0.40], "head": [0.22, -0.626], "hw": 0.28},
 "n30_xiangcai": {"hand": [0.38, -0.55], "head": [-0.05, -0.651], "hw": 0.35, "fr": 1},
 "n30_xiaosi": {"hand": [0.35, -0.04], "head": [-0.05, -0.962], "hw": 0.38, "nh": "side"},
 "n30_xiasi": {"hand": [0.18, -0.55], "head": [0.00, -0.925], "hw": 0.36},
 "n30_yangui": {"hand": [0.21, -0.04], "head": [-0.10, -0.927], "hw": 0.34, "nh": "side"},
 "n30_yecha": {"hand": [0.22, -0.60], "head": [0.00, -0.932], "hw": 0.38, "nh": "back"},
 "n30_yesi": {"hand": [0.30, -0.04], "head": [0.00, -0.985], "hw": 0.36, "nh": "side"},
 "n30_yezi": {"hand": [0.24, -0.04], "head": [-0.05, -0.905], "hw": 0.36, "nh": "side"},
 "n30_yukionna": {"hand": [0.17, -0.50], "head": [0.00, -0.923], "hw": 0.30, "fr": 1},
 "n30_zhongshu": {"hand": [0.39, -0.04], "head": [-0.05, -0.932], "hw": 0.38, "nh": "side"},
 "n30_zipai": {"hand": [-0.30, -0.47], "head": [-0.05, -0.946], "hw": 0.42, "fr": 1},
 "niutou": {"hand": [0.22, -0.58], "head": [0.00, -0.925], "hw": 0.36, "nh": "back"},
 "nw_akaname": {"hand": [-0.25, -0.35], "head": [-0.05, -0.995], "hw": 0.32},
 "nw_ameonna": {"hand": [0.08, -0.35], "head": [0.00, -0.803], "hw": 0.30, "fr": 1},
 "nw_baimao": {"hand": [-0.33, -0.52], "head": [-0.02, -0.899], "hw": 0.40},
 "nw_bajang": {"hand": [-0.22, -0.40], "head": [-0.18, -0.763], "hw": 0.30, "fr": 1},
 "nw_banaspati": {"hand": [0.28, -0.04], "head": [-0.02, -0.925], "hw": 0.36, "nh": "side"},
 "nw_bifang": {"hand": [0.32, -0.04], "head": [-0.10, -0.861], "hw": 0.24, "nh": "side"},
 "nw_bonceng": {"hand": [-0.32, -0.55], "head": [-0.05, -0.928], "hw": 0.30},
 "nw_buhuagu": {"hand": [0.12, -0.35], "head": [-0.06, -0.970], "hw": 0.36, "fr": 1},
 "nw_daqiang": {"hand": [0.51, -0.04], "head": [0.00, -1.004], "hw": 0.40, "nh": "side"},
 "nw_dikseigwai": {"hand": [-0.28, -0.76], "head": [0.00, -0.971], "hw": 0.42},
 "nw_dodomeki": {"hand": [0.39, -0.04], "head": [-0.05, -0.968], "hw": 0.30, "nh": "side"},
 "nw_dokkaebi": {"hand": [-0.25, -0.62], "head": [-0.05, -0.945], "hw": 0.36, "nh": "back"},
 "nw_dullahan": {"hand": [0.49, -0.04], "head": [0.12, -0.671], "hw": 0.24, "nh": "side"},
 "nw_ganshi": {"hand": [0.36, -0.04], "head": [-0.10, -0.925], "hw": 0.36, "nh": "side"},
 "nw_guiamngaan": {"hand": [0.35, -0.48], "head": [0.00, -0.790], "hw": 0.36},
 "nw_guihuo": {"hand": [0.34, -0.04], "head": [-0.05, -0.744], "hw": 0.40, "nh": "side"},
 "nw_guisihknai": {"hand": [0.32, -0.04], "head": [-0.02, -0.980], "hw": 0.36, "nh": "side"},
 "nw_harimau": {"hand": [-0.33, -0.55], "head": [-0.10, -0.955], "hw": 0.32},
 "nw_honeonna": {"hand": [0.38, -0.04], "head": [0.05, -0.923], "hw": 0.30, "nh": "side"},
 "nw_huapi": {"hand": [0.36, -0.04], "head": [0.05, -0.848], "hw": 0.30, "nh": "side"},
 "nw_huli": {"hand": [0.38, -0.04], "head": [-0.05, -0.898], "hw": 0.30, "nh": "side"},
 "nw_jinmenken": {"hand": [0.47, -0.04], "head": [-0.22, -0.822], "hw": 0.34, "nh": "side"},
 "nw_kamaitachi": {"hand": [0.51, -0.04], "head": [-0.05, -0.686], "hw": 0.24, "nh": "side"},
 "nw_kapre": {"hand": [-0.12, -0.50], "head": [0.00, -0.985], "hw": 0.36, "fr": 1},
 "nw_krahang": {"hand": [0.50, -0.04], "head": [0.00, -0.910], "hw": 0.32, "nh": "side"},
 "nw_kuaidi": {"hand": [0.39, -0.04], "head": [-0.05, -0.939], "hw": 0.40, "nh": "side"},
 "nw_luotoumin": {"hand": [0.38, -0.04], "head": [-0.20, -0.923], "hw": 0.30, "nh": "side"},
 "nw_makuragaeshi": {"hand": [0.34, -0.04], "head": [-0.05, -1.050], "hw": 0.36, "nh": "side"},
 "nw_manananggal": {"hand": [0.15, -0.42], "head": [-0.02, -0.816], "hw": 0.28, "fr": 1},
 "nw_mosinna": {"hand": [0.42, -0.04], "head": [0.00, -0.904], "hw": 0.40, "nh": "side"},
 "nw_mummy": {"hand": [-0.33, -0.50], "head": [0.00, -0.930], "hw": 0.32},
 "nw_nangtani": {"hand": [0.42, -0.04], "head": [0.12, -0.963], "hw": 0.30, "nh": "side"},
 "nw_nekomata": {"hand": [-0.30, -0.60], "head": [-0.10, -0.958], "hw": 0.30},
 "nw_nian": {"hand": [0.51, -0.04], "head": [-0.08, -0.886], "hw": 0.42, "nh": "side"},
 "nw_niexiaoqian": {"hand": [0.38, -0.04], "head": [-0.05, -0.948], "hw": 0.30, "nh": "side"},
 "nw_nuno": {"hand": [0.43, -0.04], "head": [0.00, -0.902], "hw": 0.38, "nh": "side"},
 "nw_nurikabe": {"hand": [0.42, -0.40], "head": [-0.02, -1.091], "hw": 0.42},
 "nw_paakbok": {"hand": [0.21, -0.32], "head": [-0.02, -0.888], "hw": 0.30, "fr": 1},
 "nw_poltergeist": {"hand": [-0.33, -0.60], "head": [-0.05, -0.900], "hw": 0.36},
 "nw_qiongqi": {"hand": [0.51, -0.04], "head": [-0.12, -0.760], "hw": 0.32, "nh": "side"},
 "nw_shejing": {"hand": [0.44, -0.04], "head": [-0.05, -0.935], "hw": 0.32, "nh": "side"},
 "nw_shen": {"hand": [0.50, -0.04], "head": [0.00, -0.764], "hw": 0.40, "nh": "side"},
 "nw_shenpi": {"hand": [-0.34, -0.04], "head": [-0.02, -1.037], "hw": 0.38, "nh": "side"},
 "nw_teketeke": {"hand": [-0.33, -0.12], "head": [-0.12, -0.782], "hw": 0.34},
 "nw_tiangou": {"hand": [0.37, -0.04], "head": [-0.05, -0.988], "hw": 0.30, "nh": "side"},
 "nw_tisi": {"hand": [0.15, -0.38], "head": [-0.05, -0.964], "hw": 0.40},
 "nw_toutai": {"hand": [0.26, -0.04], "head": [0.00, -0.948], "hw": 0.30, "nh": "side"},
 "nw_ungaikyo": {"hand": [0.38, -0.48], "head": [0.00, -0.970], "hw": 0.36},
 "nw_ushioni": {"hand": [0.51, -0.04], "head": [-0.12, -0.670], "hw": 0.32, "nh": "side"},
 "nw_wangliang": {"hand": [0.39, -0.04], "head": [-0.05, -0.890], "hw": 0.32, "nh": "side"},
 "nw_yeleng_guard": {"hand": [0.27, -0.04], "head": [-0.05, -0.957], "hw": 0.38, "nh": "side"},
 "nw_yeleng_sales": {"hand": [0.33, -0.04], "head": [0.05, -1.002], "hw": 0.34, "nh": "side"},
 "nw_zhizhama": {"hand": [0.50, -0.04], "head": [-0.30, -0.889], "hw": 0.26, "nh": "side"},
 "nw_zzcar": {"hand": [0.49, -0.04], "head": [0.05, -0.690], "hw": 0.36, "nh": "side"},
 "nw_zzhouse": {"hand": [0.48, -0.04], "head": [0.00, -1.010], "hw": 0.36, "nh": "side"},
 "nw_zzphone": {"hand": [0.32, -0.48], "head": [0.08, -1.024], "hw": 0.40},
 "penanggal": {"hand": [0.49, -0.04], "head": [0.00, -0.867], "hw": 0.34, "nh": "side"},
 "pg_ex": {"hand": [0.27, -0.04], "head": [0.00, -0.890], "hw": 0.32, "nh": "side"},
 "pg_ji": {"hand": [0.24, -0.04], "head": [0.00, -0.901], "hw": 0.35, "nh": "side"},
 "pg_landlady": {"hand": [-0.30, -0.65], "head": [-0.03, -0.939], "hw": 0.40},
 "pg_songding": {"hand": [0.25, -0.52], "head": [0.00, -0.873], "hw": 0.30},
 "pg_tuimo": {"hand": [0.12, -0.50], "head": [-0.05, -0.905], "hw": 0.36},
 "pocong": {"hand": [0.19, -0.04], "head": [0.00, -0.777], "hw": 0.34, "nh": "side"},
 "pontianak": {"hand": [0.12, -0.50], "head": [0.00, -0.873], "hw": 0.30, "fr": 1},
 "shuigui": {"hand": [0.25, -0.45], "head": [0.00, -0.903], "hw": 0.30},
 "tianhua": {"hand": [-0.15, -0.40], "head": [-0.12, -0.820], "hw": 0.32, "fr": 1},
 "toyol": {"hand": [0.30, -0.04], "head": [0.00, -0.953], "hw": 0.44, "nh": "side"},
 "xiaogui": {"hand": [0.25, -0.48], "head": [-0.05, -0.875], "hw": 0.36},
 "xiaozhi": {"hand": [0.20, -0.33], "head": [0.00, -0.866], "hw": 0.42},
 "youhun": {"hand": [0.25, -0.47], "head": [0.00, -1.021], "hw": 0.46},
 "zd_bone": {"hand": [0.18, -0.62], "head": [-0.03, -0.956], "hw": 0.42, "nh": "back"},
 "zd_hengsi": {"hand": [-0.20, -0.60], "head": [-0.05, -0.890], "hw": 0.32},
 "zd_hongyi": {"hand": [0.10, -0.42], "head": [0.00, -0.883], "hw": 0.30, "fr": 1},
 "zd_paotui": {"hand": [0.18, -0.50], "head": [-0.03, -0.927], "hw": 0.34},
 "zd_shanjing": {"hand": [0.28, -0.42], "head": [0.00, -0.865], "hw": 0.36},
 "zd_shuihou": {"hand": [0.25, -0.22], "head": [-0.05, -0.887], "hw": 0.34},
 "zd_yinchai": {"hand": [0.15, -0.42], "head": [0.00, -0.932], "hw": 0.38},
 "zd_zhima": {"hand": [0.49, -0.04], "head": [-0.27, -0.826], "hw": 0.28, "nh": "side"},
 "zhiren": {"hand": [0.20, -0.32], "head": [0.00, -0.833], "hw": 0.44},
 "zombie": {"hand": [-0.25, -0.48], "head": [0.00, -0.885], "hw": 0.50},
}

def anchors():
    # 自動錨點表（tools/equip_anchor.json：equip_test anchors 用全身圖不透明輪廓生成），再用上面 ANCHOR 人工表蓋
    p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "equip_anchor.json")
    o = {}
    if os.path.exists(p):
        for k, v in json.load(open(p, encoding="utf-8")).items():
            o[k] = {"hand": v["hand"], "head": v["head"], "src": "auto"}
    for k, v in ANCHOR.items(): o[k] = dict(v, src="manual")
    return o

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
           "ITEMS": items, "ANCHOR": anchors()}
    p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data", "nat", "equip.json")
    with open(p, "w", encoding="utf-8") as f: json.dump(out, f, ensure_ascii=False, indent=1)
    print("equip.json", len(items), "items")

if __name__ == "__main__": main()
