# -*- coding: utf-8 -*-
"""產生 godot/data/nat/chain.json（設計線）。格式見 /home/claude/ctx/CHAIN_CONTRACT.md。

用法：python3 tools/chain_build.py [data/nat/outpost.json] [data/nat/chain.json]
  T1／T2（村子後院）喺呢度定義；T3–T5（移動村台出嘅貨）由 outpost.json 嘅 GOODS 抄名、圖示、價錢，
  所以要先跑 tools/outpost_build.py 再跑呢個（tools/chain_check.py 會核對兩邊一致）。

規則（引擎線照用；數字全部喺呢度）：
  RECIPES[sid] = {"in":{mid:qty}, "out":mid, "n":k}：每做 k 件 out 就扣一次 in。
      台每轉做 out(lv) 件（mv_data.gd 公式），扣 in × out(lv) ÷ k（可以有小數，存 S.mat 浮點）。
      開工前 in 唔夠一轉 → 呢個工人等料（斷料），唔扣唔出。
  GATHER[bid].rate：一個鬼喺 1 級建築每分鐘採幾多；建築每升 1 級 +15%（rate × (1 + 0.15 × (lv − 1))）。
  WORKSHOPS[bid].time：一個鬼喺 1 級建築做一批（in → out）要幾多秒；建築每升 1 級快 10%（time ÷ (1 + 0.10 × (lv − 1))）。
  unlock：{"ci":第幾張圖起先起得（移動村 ci ≥ 呢個數）, "cost":{mid:n}}（舊建築 old 有值嘅照舊規則，ci 0、cost 留空）。
"""
import json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPOST = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "data", "nat", "outpost.json")
OUT = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, "data", "nat", "chain.json")
OP = json.load(open(OUTPOST, encoding="utf-8"))

MATS, GATHER, WORKSHOPS, RECIPES, GEAR, BATTLE_ITEMS = {}, {}, {}, {}, {}, {}

def mat(mid, yue, zh, tier, icon, price, how, res="", cap=0):
    MATS[mid] = {"n": [yue, zh], "tier": tier, "icon": icon, "price": price, "res": res, "how": list(how)}
    if cap: MATS[mid]["cap"] = cap

# ================= T1 原料（村子後院採集） =================
# (mid, 名粵, 名中, icon, 價, how粵, how中, cap) ； 建築 (bid, 名粵, 名中, art, rate, ci, cost, old, how粵, how中)
T1 = [
 ("m_wood", "槐木", "槐木", "wood", 0.5, "res:wood",
  "伐木場啲鬼斬落嚟嘅槐樹，年輪數落去會數到自己死嗰年。",
  "伐木場的鬼砍下來的槐樹，年輪數下去會數到自己死的那一年。",
  ("b_wood", "伐木場", "伐木場", "wood", 20, 0, {}, "wood",
   "鬼斧斬樹，樹斬完會自己企返起身——所以呢度永遠有得斬。",
   "鬼斧砍樹，樹砍完會自己站回去——所以這裡永遠有得砍。")),
 ("m_rice", "糯米", "糯米", "rice", 0.5, "res:rice",
  "糯米田收落嚟，粒粒都黐住少少唔肯走嘅嘢。",
  "糯米田收下來的，每一粒都黏著一點不肯走的東西。",
  ("b_rice", "糯米田", "糯米田", "rice", 30, 0, {}, "rice",
   "稻草人負責收割，佢話自己守咗呢塊田一百年，終於有工開。",
   "稻草人負責收割，他說自己守了這塊田一百年，終於有工作了。")),
 ("m_wellwater", "枯井水", "枯井水", "mvs_well", 0.5, "",
  "明明係枯井，桶吊上嚟永遠半桶水；另外半桶係乜，唔好望。",
  "明明是枯井，桶吊上來永遠有半桶水；另外半桶是什麼，別看。",
  ("b_well", "枯井轆轤", "枯井轆轤", "pr_well", 60, 0, {"m_wood": 30},
   "", "搖轆轤嗰陣要數拍子，數漏一下，井底會有把聲幫你數埋。",
   "搖轆轤時要數拍子，漏數一下，井底會有個聲音替你數完。")),
 ("m_bamboo", "後山竹", "後山竹", "mvi_bamboo", 0.5, "",
  "後山啲竹夜晚會自己郁，斬嗰陣要講句「唔好意思」。",
  "後山的竹子夜裡會自己動，砍的時候要說一句「不好意思」。",
  ("b_bamboo", "後山竹林", "後山竹林", "mvs_bamboo", 30, 0, {"m_wood": 40},
   "", "竹林入面成日有人叫你個名，唔好應，應咗佢會叫你幫手斬。",
   "竹林裡老有人叫你的名字，別回應，回應了他會叫你幫忙砍。")),
 ("m_coconut", "椰子", "椰子", "n30_yezi__coconut", 1, "",
  "椰林啲椰子專揀有鬼行過先跌，跌中嗰個會負責拎返嚟。",
  "椰林的椰子專挑有鬼經過時才掉，被砸中的那個負責撿回來。",
  ("b_coco", "椰林", "椰林", "n30_yezi__coconut", 40, 1, {"m_plank": 30},
   "", "派隻鬼企喺椰樹下等就得——佢早就習慣咗。",
   "派一隻鬼站在椰樹下等就行——他早就習慣了。")),
 ("m_latex", "膠汁", "膠汁", "mvs_rubber", 1, "",
  "雞啼前割落嚟嘅白膠汁，聞落有啲似早餐，唔好試。",
  "雞啼前割下來的白色膠汁，聞起來有點像早餐，別試。",
  ("b_latex", "膠園", "膠園", "mvs_rubber", 20, 1, {"m_plank": 40},
   "", "割膠鬼凌晨三點開工，佢話咁先叫有返工嘅感覺。",
   "割膠鬼凌晨三點開工，他說這樣才有上班的感覺。")),
 ("m_tealeaf", "霧谷茶葉", "霧谷茶葉", "mvi_tea", 3, "",
  "霧谷啲茶樹淨係喺最大霧嗰陣先肯出芽，摘嗰個要摸住嚟。",
  "霧谷的茶樹只在霧最大時才肯發芽，採的人得摸著來。",
  ("b_tea", "霧谷茶田", "霧谷茶田", "mvs_teahouse", 20, 2, {"m_plank": 60},
   "", "採茶鬼喺霧入面唱歌，唱錯一句就搵唔返出口。",
   "採茶鬼在霧裡唱歌，唱錯一句就找不到出口。")),
 ("m_straw", "禾稈草", "禾稈草", "mvi_straw", 1, "",
  "古道邊啲禾稈草，曬極都係濕，因為有人成晚喺上面喊。",
  "古道邊的稻草，怎麼曬都是濕的，因為有人整晚在上面哭。",
  ("b_straw", "禾稈草堆", "禾稈草堆", "mvi_straw", 30, 0, {"m_plank": 60},   # [zone] 提前到第 1 張圖（資源區 C）
   "", "稻草人自己拆自己啲草畀你，佢話反正冇雀嚟。",
   "稻草人自己拆身上的草給你，他說反正也沒有鳥來。")),
 ("m_bananaleaf", "蕉葉", "蕉葉", "mvi_leaf", 3, "",
  "香蕉園啲蕉葉，半夜自己捲埋；要趁大樹下嗰位唔喺度先好剪。",
  "香蕉園的蕉葉，半夜會自己捲起來；要趁大樹下那位不在才好剪。",
  ("b_banana", "蕉園", "蕉園", "mvs_banana", 20, 3, {"m_plank": 90},
   "", "剪葉要剪大樹附近嗰啲，因為遠啲嗰啲已經俾人剪晒。",
   "剪葉要剪大樹附近那些，因為遠一點的早就被剪光了。")),
 ("m_fish", "河口魚", "河口魚", "mvi_saltfish", 3, "",
  "河口罾上嚟嘅魚，條條都識講「放我返去」，但冇人學過佢哋講嘢。",
  "河口網上來的魚，每條都會說「放我回去」，但沒人教過牠們說話。",
  ("b_fish", "河口罾棚", "河口罾棚", "mvs_fish", 30, 3, {"m_plank": 90},
   "", "水鬼幫手落罾，佢唔要人工，只係問你可唔可以留低陪佢。",
   "水鬼幫忙下網，他不要工錢，只問你能不能留下來陪他。")),
 ("m_newspaper", "舊報紙", "舊報紙", "furnace__paper", 3, "",
  "橋底執嘅舊報紙，頭條永遠係十年前嗰單意外，體育版就好新。",
  "橋底撿的舊報紙，頭條永遠是十年前那宗意外，體育版倒是很新。",
  ("b_newspaper", "橋底回收站", "橋底回收站", "pr_boxes", 30, 4, {"m_plank": 150},
   "", "收買佬鬼秤報紙用自己個頭做秤砣，所以斤兩永遠啱。",
   "收破爛的鬼秤報紙用自己的頭當秤砣，所以重量永遠準。")),
 ("m_toner", "碳粉", "碳粉", "of_cabinet", 4, "",
  "地庫機房啲影印機吐出嚟嘅碳粉，黑到可以映到你後面企住乜。",
  "地庫機房的影印機吐出來的碳粉，黑到能映出你背後站著什麼。",
  ("b_toner", "地庫碳粉房", "地庫碳粉房", "mvs_copier", 20, 5, {"m_plank": 240},
   "", "影印機每晚自己印一千張白紙，碳粉就係由呢啲白紙度刮返落嚟。",
   "影印機每晚自己印一千張白紙，碳粉就是從這些白紙上刮回來的。")),
]
for mid, y, z, icon, price, res, hy, hz, b in T1:
    mat(mid, y, z, 1, icon, price, (hy, hz), res=res.split(":")[1] if res.startswith("res:") else "",
        cap=0 if res.startswith("res:") else 2000)
    bid, by, bz, art, rate, ci, cost, old, ky, kz = b
    GATHER[bid] = {"n": [by, bz], "art": art, "out": mid, "rate": rate,
                   "unlock": {"ci": ci, "cost": cost}, "old": old, "how": [ky, kz]}

# ================= T2 半成品（村子後院加工） =================
T2 = [
 ("m_plank", "棺材板", "棺材板", "plank", 1.5, "planks",
  "槐木刨成板，刨嗰陣塊板會自己轉身，等你刨埋另一面。",
  "槐木刨成板，刨的時候木板會自己翻身，等你刨另一面。",
  ("b_plank", "棺材鋪", "棺材鋪", "plank", {"m_wood": 2}, {"m_plank": 1}, 3, 0, {}, "plank",
   "棺材佬鬼一邊鋸一邊度你身材，唔使驚，佢職業病。",
   "棺材店的鬼一邊鋸一邊量你身材，別怕，那是職業病。")),
 ("m_bao", "普通包子", "普通包子", "bun", 1.5, "",
  "包子鋪出嘅白麵包，正常到好唔正常——喺陰間，正常就係最怪。",
  "包子鋪做的白麵包，正常得很不正常——在陰間，正常才是最怪的。",
  ("b_bun", "包子鋪", "包子鋪", "bun", {"m_rice": 1}, {"m_bao": 2}, 3, 0, {}, "bun",
   "糯米磨粉搓成包，摺口要摺十八摺，摺少一摺個包會喊。",
   "糯米磨粉揉成包子，收口要捏十八摺，少捏一摺包子會哭。")),
 ("m_paper", "竹紙", "竹紙", "op_paper", 1.5, "",
  "後山竹加枯井水撈出嚟嘅紙，透光睇有個人影，每張都唔同。",
  "後山竹加枯井水撈出來的紙，透光看有一個人影，每張都不一樣。",
  ("b_paper", "紙寮", "紙寮", "op_paper", {"m_bamboo": 1, "m_wellwater": 1}, {"m_paper": 2}, 4, 0, {"m_wood": 60},
   "", "撈紙鬼將竹漿撈上竹簾，佢話撈得多，連自己都撈得返上嚟。",
   "撈紙鬼把竹漿撈上竹簾，他說撈得多了，連自己都能撈回來。")),
 ("m_strip", "竹篾", "竹篾", "mvi_bamboo", 3, "",
  "後山竹破開做篾，係紙紮嘅骨；破得太幼會聽到佢喊痛。",
  "後山竹劈開做篾，是紙紮的骨架；劈得太細會聽到它喊痛。",
  ("b_strip", "破篾棚", "破篾棚", "mvs_bamboo", {"m_bamboo": 1}, {"m_strip": 2}, 3, 0, {"m_plank": 40},   # [zone] 提前到第 1 張圖（資源區 A）
   "", "紮作鬼一刀破四條，佢話以前紮人哋，而家終於紮自己用嘅。",
   "紮作鬼一刀劈四條，他說以前紮給別人，現在終於紮給自己用。")),
 ("m_cocomilk", "椰漿", "椰漿", "mvi_coconutrice", 4, "",
  "椰肉刨絲揸出嚟嘅漿，揸嗰隻手唔係人手，不過好乾淨。",
  "椰肉刨絲擠出來的漿，擠的那隻手不是人手，不過很乾淨。",
  ("b_cocomilk", "刨椰寮", "刨椰寮", "mvs_ricepot", {"m_coconut": 1}, {"m_cocomilk": 2}, 4, 1, {"m_plank": 50},
   "", "刨椰凳坐住一隻好長手嘅鬼，一邊刨一邊伸手去隔籬村偷多個。",
   "刨椰凳上坐著一隻手很長的鬼，一邊刨一邊伸手去隔壁村多偷一顆。")),
 ("m_rubbersheet", "生膠片", "生膠片", "mvi_slipper", 4, "",
  "膠汁壓平曬乾嘅膠片，曬嗰陣會自己捲埋，好似瞓緊覺。",
  "膠汁壓平曬乾的膠片，曬的時候會自己捲起來，像在睡覺。",
  ("b_rubbersheet", "膠片房", "膠片房", "mvs_rubber", {"m_latex": 1}, {"m_rubbersheet": 1}, 4, 1, {"m_plank": 60},
   "", "壓膠機由兩隻吊死鬼一齊吊住拉，佢哋話咁先有啲運動。",
   "壓膠機由兩隻吊死鬼一起吊著拉，他們說這樣才算有點運動。")),
 ("m_rope", "草繩", "草繩", "mvi_straw", 4, "",
  "禾稈草搓成嘅繩，條條都打咗個結，冇人認係自己打。",
  "稻草搓成的繩子，每條都打了一個結，沒人承認是自己打的。",
  ("b_rope", "搓繩棚", "搓繩棚", "mvs_straw", {"m_straw": 2}, {"m_rope": 2}, 3, 0, {"m_plank": 80},   # [zone] 提前到第 1 張圖（資源區 C）
   "", "長頭髮鬼將啲頭髮溝埋落去搓，佢話咁先夠韌。",
   "長髮鬼把自己的頭髮摻進去搓，她說這樣才夠韌。")),
 ("m_pulp", "報紙漿", "報紙漿", "furnace__stack", 5, "",
  "舊報紙浸枯井水打成漿，搓得出任何形狀，頭條字仲睇得到。",
  "舊報紙泡枯井水打成漿，捏得出任何形狀，頭條的字還看得到。",
  ("b_pulp", "紙漿池", "紙漿池", "pr_puddle", {"m_newspaper": 1, "m_wellwater": 1}, {"m_pulp": 2}, 3, 4, {"m_plank": 200},
   "", "打漿嗰個係淹死鬼，佢話成世人終於有一次喺水入面做主。",
   "打漿的是淹死鬼，他說這輩子總算有一次在水裡作主。")),
 ("m_ink", "影印墨", "影印墨", "mvi_form", 6, "",
  "碳粉開枯井水，搞勻就係影印墨；印出嚟嘅字會自己排隊。",
  "碳粉兌枯井水，攪勻就是影印墨；印出來的字會自己排隊。",
  ("b_ink", "碳粉墨房", "碳粉墨房", "mvs_files", {"m_toner": 1, "m_wellwater": 1}, {"m_ink": 2}, 3, 5, {"m_plank": 300},
   "", "攪墨鬼攪咗一千年，佢話唔係為錢，係因為停低會凍。",
   "攪墨鬼攪了一千年，他說不是為了錢，是因為一停下來就會冷。")),
]
for mid, y, z, icon, price, res, hy, hz, b in T2:
    mat(mid, y, z, 2, icon, price, (hy, hz), res=res, cap=0 if res else 2000)
    bid, by, bz, art, i, o, tm, ci, cost, old, ky, kz = b
    WORKSHOPS[bid] = {"n": [by, bz], "art": art, "in": i, "out": o, "time": tm,
                      "unlock": {"ci": ci, "cost": cost}, "old": old, "how": [ky, kz]}

# ================= T3–T5：移動村台（貨嘅名、圖示、價錢由 outpost.json GOODS 抄） =================
# sid: (in, n, tier)
R = {
 # 隨村台（每張圖都有）
 "st_shoubao":       ({"m_bao": 1}, 1, 3),
 "st_zhishan":       ({"m_paper": 1}, 2, 3),
 # ci0 槐林荒村
 "st_douhua":        ({"m_wellwater": 1}, 2, 3),
 "st_nuomici":       ({"m_rice": 1, "m_shoubao": 2}, 2, 4),
 "st_guancaichuang": ({"m_plank": 1, "m_zhishan": 1}, 1, 4),
 "st_denglong":      ({"m_paper": 1, "m_bamboo": 1}, 2, 3),   # [idle] 第 1 張圖新台
 "st_tiaodan":       ({"m_douhua": 1, "m_denglong": 1}, 1, 4),   # [idle] 第 1 張圖新台
 # ci1 甘榜夜路
 "st_yeketan":       ({"m_coconut": 1}, 2, 3),
 "st_tuoxie":        ({"m_rubbersheet": 1}, 2, 3),
 "st_zhulong":       ({"m_strip": 1, "m_yeketan": 1}, 1, 4),
 "st_liulian":       ({"m_tuoxie": 1}, 1, 4),
 "st_yejiangfan":    ({"m_cocomilk": 1, "m_rice": 1, "m_yeketan": 2}, 2, 4),
 # ci2 南下古道
 "st_caoxie":        ({"m_rope": 1}, 2, 3),
 "st_wucha":         ({"m_tealeaf": 1, "m_wellwater": 1}, 2, 3),
 "st_jiuban":        ({"m_plank": 1}, 1, 3),
 "st_huajiao":       ({"m_jiuban": 1, "m_zhishan": 1, "m_rope": 1}, 1, 4),
 "st_xunren":        ({"m_paper": 1, "m_wucha": 2}, 2, 4),
 "st_ganlu":         ({"m_caoxie": 2, "m_wucha": 1}, 1, 4),   # [idle] 第 3 張圖新台
 # ci3 河口蕉園
 "st_jiaoye":        ({"m_bananaleaf": 1, "m_rice": 1}, 2, 3),
 "st_xianyu":        ({"m_fish": 1}, 1, 3),
 "st_ningmeng":      ({"m_tealeaf": 1, "m_wellwater": 1}, 2, 3),
 "st_duihuan":       ({"m_paper": 1, "m_xianyu": 2}, 2, 4),
 "st_jiushengquan":  ({"m_rubbersheet": 1, "m_paper": 1, "m_ningmengcha": 2}, 2, 4),
 "st_chuanpiao":     ({"m_duihuan": 1, "m_jiushengquan": 1}, 1, 5),
 # ci4 橫死路口
 "st_waimai":        ({"m_pulp": 1, "m_bao": 2}, 2, 3),
 "st_ifon":          ({"m_pulp": 1}, 2, 3),
 "st_mingbiao":      ({"m_waimai": 1, "m_strip": 1}, 1, 4),
 "st_paoche":        ({"m_newspaper": 1, "m_pulp": 1, "m_ifon": 2}, 2, 4),
 "st_shougongcu":    ({"m_rice": 1, "m_shoubao": 2}, 2, 4),
 "st_xifei":         ({"m_paoche": 1, "m_mingbiao": 1}, 1, 5),
 "st_baogu":         ({"m_rice": 1, "m_shougongcu": 1, "m_paoche": 1}, 2, 5),   # [idle] 第 5 張圖第 7 台
 # ci5 地府集團
 "st_mengpotang":    ({"m_wellwater": 1, "m_rice": 1}, 2, 3),
 "st_xizhuang":      ({"m_zhishan": 1, "m_ink": 1}, 3, 4),
 "st_zhiku":         ({"m_zhishan": 1, "m_ink": 1}, 3, 4),
 "st_biaoge":        ({"m_paper": 1, "m_ink": 1, "m_mengpotang": 2}, 2, 4),
 "st_jiabandeng":    ({"m_biaoge": 1, "m_strip": 1}, 1, 5),
 "st_tangyi":        ({"m_plank": 1, "m_zhiku": 1, "m_xizhuang": 1}, 1, 5),
 "st_daka":          ({"m_biaoge": 1, "m_xizhuang": 1}, 1, 5),   # [idle] 第 6 張圖第 7 台
}
ST, GO = OP["STATIONS"], OP["GOODS"]
for sid, (i, n, tier) in R.items():
    s = ST[sid]; gid = s["good"]; g = GO[gid]
    RECIPES[sid] = {"in": i, "out": gid, "n": n}
    MATS[gid] = {"n": g["n"], "tier": tier, "icon": g["icon"], "price": g["price"], "res": "buns" if gid == "m_shoubao" else "",
                 "how": s["how"], "sid": sid}

CARRY = [s for s in OP["MAPS"][0]["stations"] if all(s in m["stations"] for m in OP["MAPS"])]

# ================= 裝備（買咗嘅鬼變義勇軍） =================
GEAR = {
 "m_zhishan":       {"slot": "body",   "atk": 0,  "def": 3,  "hp": 20},
 "m_tuoxie":        {"slot": "legs",   "atk": 1,  "def": 2,  "hp": 15},
 "m_zhulong":       {"slot": "head",   "atk": 0,  "def": 6,  "hp": 30},
 "m_caoxie":        {"slot": "legs",   "atk": 2,  "def": 4,  "hp": 30},
 "m_jiuban":        {"slot": "shield", "atk": 0,  "def": 10, "hp": 40},
 "m_jiushengquan":  {"slot": "body",   "atk": 0,  "def": 14, "hp": 90},
 "m_ifon":          {"slot": "hand",   "atk": 12, "def": 0,  "hp": 0},
 "m_mingbiao":      {"slot": "hand",   "atk": 20, "def": 4,  "hp": 20},
 "m_xizhuang":      {"slot": "body",   "atk": 4,  "def": 18, "hp": 120},
 "m_zhiku":         {"slot": "legs",   "atk": 6,  "def": 22, "hp": 160},
 "m_jiabandeng":    {"slot": "head",   "atk": 18, "def": 26, "hp": 220},
}
# ================= 戰鬥道具（eff 效果鍵、v 數值〔百分比或回合〕、turns 持續回合，0＝即時） =================
BATTLE_ITEMS = {
 "m_douhua":      {"eff": "heal", "v": 30, "turns": 0, "desc": ["食碗豆腐花，回 30% 血；井底嗰位話唔使客氣。", "吃一碗豆花，回復 30% 生命；井底那位說不用客氣。"]},
 "m_yeketan":     {"eff": "burn", "v": 8, "turns": 3, "desc": ["掟舊椰殼炭過去，敵人燒足三回合，每回合扣 8% 血。", "扔一塊椰殼炭過去，敵人燒三回合，每回合扣 8% 生命。"]},
 "m_wucha":       {"eff": "miss", "v": 40, "turns": 2, "desc": ["請敵人飲杯霧谷茶，佢唔記得自己瞄緊邊，命中跌 40%（兩回合）。", "請敵人喝杯霧谷茶，他忘了自己在瞄哪裡，命中率降 40%（兩回合）。"]},
 "m_xianyu":      {"eff": "revive", "v": 30, "turns": 0, "desc": ["鹹魚翻身：倒低咗嘅隊友企返起身，帶 30% 血。", "鹹魚翻身：倒下的隊友重新站起，帶 30% 生命。"]},
 "m_shougongcu":  {"eff": "def_down", "v": 30, "turns": 3, "desc": ["淋一身收工醋，敵人酸到縮水，防禦跌 30%（三回合）。", "潑一身收工醋，敵人酸到縮水，防禦降 30%（三回合）。"]},
 "m_mengpotang":  {"eff": "skip_turn", "v": 1, "turns": 1, "desc": ["請佢飲碗孟婆湯（走甜少冰），佢唔記得要出手，停一回合。", "請他喝碗孟婆湯（去糖少冰），他忘了要出手，停一回合。"]},
}

STRINGS = {
 "tier1": ["一級原料", "一級原料"], "tier2": ["二級半成品", "二級半成品"], "tier3": ["三級貨", "三級貨"],
 "tier4": ["四級貨", "四級貨"], "tier5": ["五級貨", "五級貨"],
 "need": ["要料", "所需材料"], "makes": ["出貨", "產出"], "no_mat": ["斷料！等緊：", "缺料！等待："],
 "gather": ["後院採集", "後院採集"], "workshop": ["後院加工", "後院加工"], "carry": ["隨村台", "隨村台"],
 "carry_tip": ["跟住紙紮大屋一齊抬，每張圖都喺度", "跟著紙紮大屋一起抬，每張地圖都在"],
 "unlock_map": ["去到第 %d 張圖先起得", "抵達第 %d 張地圖才能建造"],
 "gear": ["紙紮裝備", "紙紮裝備"], "gear_tip": ["買咗嘅鬼會留低做義勇軍，幫手守村", "買了的鬼會留下當義勇軍，幫忙守村"],
 "battle_item": ["戰鬥道具", "戰鬥道具"],
 "slot_body": ["身", "身體"], "slot_legs": ["腳", "腿腳"], "slot_head": ["頭", "頭部"], "slot_hand": ["手", "手持"], "slot_shield": ["盾", "盾牌"],
}

RULES = {
 "recipe": "每做 n 件 out 扣一次 in；台每轉出 out(lv) 件，扣 in × out(lv) ÷ n；唔夠一轉就等料",
 "gather": "每個鬼每分鐘 rate × (1 + 0.15 × (建築等級 − 1))",
 "workshop": "每個鬼每批 time ÷ (1 + 0.10 × (建築等級 − 1)) 秒",
 "unlock": "ci：移動村去到第幾張圖（0 起）先起得；cost：起建築要嘅材料",
}

data = {"RULES": RULES, "MATS": MATS, "GATHER": GATHER, "WORKSHOPS": WORKSHOPS, "RECIPES": RECIPES, "CARRY": CARRY,
        "GEAR": GEAR, "BATTLE_ITEMS": BATTLE_ITEMS, "STRINGS": STRINGS}

# [art] 主對話補圖（2026-11-19）：新材料圖示＋後院建築專屬圖
ART_ICON = {"m_wellwater":"mvi_wellwater","m_bamboo":"mvi_bamboo_raw","m_coconut":"mvi_coconut","m_latex":"mvi_latex","m_tealeaf":"mvi_tealeaf",
 "m_straw":"mvi_straw_raw","m_bananaleaf":"mvi_bananaleaf","m_fish":"mvi_fish","m_newspaper":"mvi_newspaper","m_toner":"mvi_toner","m_bao":"mvi_baozi",
 "m_paper":"mvi_paper","m_strip":"mvi_strip","m_cocomilk":"mvi_cocomilk","m_rubbersheet":"mvi_rubbersheet","m_rope":"mvi_rope","m_pulp":"mvi_pulp","m_ink":"mvi_ink",
 "m_jiaoye":"mvi_jiaoyejuan","m_jiuban":"mvi_plankshield"}
for _m, _k in ART_ICON.items():
    if _m in data.get("MATS", {}): data["MATS"][_m]["icon"] = _k
for _sec in ("GATHER", "WORKSHOPS"):
    for _b, _d in data.get(_sec, {}).items():
        if _d.get("old"): continue
        _d["art"] = "vb_" + _b[2:]
with open(OUT, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=1)
print("ok mats", len(MATS), "gather", len(GATHER), "ws", len(WORKSHOPS), "recipes", len(RECIPES), "carry", CARRY,
      "gear", len(GEAR), "items", len(BATTLE_ITEMS))
