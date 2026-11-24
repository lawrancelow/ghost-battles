# -*- coding: utf-8 -*-
# [legion] 八大軍團 54 隻（老闆 2026-11-24 16:59「都過」）—— 數據源頭（唯一要手改嘅地方）
# 生成：python3 -I tools/legion/build_legion.py   → data/nat/legion.json（遊戲讀呢個；唔好手改生成檔）
# 依據：/home/claude/docs/legion_integrate.md（名單、體型、能力克制）、legion_roster.md（兵種描述）、art_pending/legion/jsj/abilities.md（殭屍能力建議）
# 老闆 17:10：軍團之後會一組一組出現喺第 7 張圖起嘅新地圖 → 據點（每軍團 3 營）只做可重用數據結構，map＝None＝未掛圖、唔顯示
# 系／嚇法：嚇法一律唔喺本系「怕」入面（每隻怕兩種、唔怕一種，同 build_cdata.py ENEMY 公式一致）
# 標籤：唔手寫，由 build_cdata.derive() 按積木推導（build 校驗 2–3 個）
import importlib.util, os
_spec = importlib.util.spec_from_file_location("ng_src", os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "newghost", "ng_src.py"))
_S1 = importlib.util.module_from_spec(_spec); _spec.loader.exec_module(_S1)
SC, SYS, RNG, M = _S1.SC, _S1.SYS, _S1.RNG, _S1.M

# 兵種位：品級（魂魄招降）、敵人血攻倍率 ENEMY_T、畫面高度 CHAR_H（雜兵 52；頭目 ×1.25；王 ×1.5）、三圍 base [力, 智, 武]
H0 = 52
SLOT = {
    "bing":  {"pin": "凡", "et": [1.0, 1.05], "h": H0,                "base": [50, 40, 55], "tier": 1, "n": "雜兵"},
    "shoot": {"pin": "凡", "et": [0.9, 1.25], "h": H0,                "base": [35, 60, 60], "tier": 1, "n": "遠程"},
    "tank":  {"pin": "凡", "et": [2.0, 0.8],  "h": 56,                "base": [80, 30, 45], "tier": 1, "n": "肉盾"},
    "elite": {"pin": "靈", "et": [1.8, 1.3],  "h": 56,                "base": [65, 80, 95], "tier": 2, "n": "精英"},
    "boss":  {"pin": "煞", "et": [2.6, 1.45], "h": round(H0 * 1.25), "base": [115, 50, 95], "tier": 3, "n": "頭目"},
    "boss2": {"pin": "煞", "et": [2.5, 1.45], "h": round(H0 * 1.25), "base": [100, 75, 90], "tier": 3, "n": "頭目"},
    "king":  {"pin": "王", "et": [3.4, 1.65], "h": round(H0 * 1.5),  "base": [130, 90, 110], "tier": 4, "n": "軍團王"},
}
ROLE_TO_AB = {"bing": "front", "shoot": "back", "tank": "front", "elite": "flank", "boss": "front", "boss2": "back", "king": "front"}

def DMG(m, **kw): d = {"p": "dmg", "mult": M(m)}; d.update(kw); return d
def F(p, **kw): d = {"p": p}; d.update(kw); return d
def A(name, tg, fx, ai=None): return {"name": name, "tg": tg, "fx": fx, "ai": ai or {"when": "asap"}}
def P(tr, fx, star=0, **kw): d = {"tr": tr, "star": star, "fx": fx}; d.update(kw); return d
def NEAR(**kw): d = {"sel": "near"}; d.update(kw); return d
def AOE(n=3, r=150): return {"n_in": n, "r": r, "wait": 5}

# ============================== 軍團 ==============================
# slots：兵種位 → 兵種代號（殭屍只得 5 種）；sys：主系；theme：主題機制（換陣提示）
LEG = {
 "egs": {"name": "餓死鬼軍團", "sys": "魂", "theme": "再生／吸食", "order": 1,
         "lore": "民間把餓死的人叫「餓死鬼」，俗語「餓死鬼投胎」形容人吃相急。本作設定為歷代饑荒餓死者的亡魂結成的軍團：見食就搶，越食越生猛。",
         "hint": "佢哋識回血兼吸血：帶「削」（削嚇氣、停回血）同爆發快嘅鬼。"},
 "sgj": {"name": "水鬼軍團", "sys": "橫", "theme": "拖拉／突襲", "order": 2,
         "lore": "嶺南民間相傳溺死的人化為水鬼，要拉人落水做「替身」先可以離開（「水鬼搵替身」）。本作設定為河口淹死的亡魂結成的軍團。",
         "hint": "專拉後排落水：帶「定」（企穩）同「拉」嘅鬼守住後排。"},
 "zzj": {"name": "紙紮人軍團", "sys": "紙紮", "theme": "反傷／怕火", "order": 3,
         "lore": "粵港喪葬習俗燒紙紮：竹篾紮骨、糊上彩紙，做成兵馬、轎、官員焚化給先人。本作設定為燒落陰間無人認領、自己成軍的紙紮人。",
         "hint": "近身打佢會反傷：用遠程同「回」頂住；佢哋怕燈（火）同吹氣。"},
 "jsj": {"name": "殭屍軍團", "sys": "屍", "theme": "屍變／霸體", "order": 4,
         "lore": "清代筆記（如紀昀《閱微草堂筆記》、袁枚《子不語》）多記殭屍：屍身不腐、雙手平伸、跳躍而行。民間傳說殭屍怕生人氣同雞啼。本作設定為一隊穿清朝官服的殭屍。",
         "hint": "倒低會再起身：帶「收」嘅鬼收屍；無頭王爺唔受嚇唔怕迷魂，要硬打。"},
 "dpl": {"name": "地痞流氓鬼軍團", "sys": "使", "theme": "嚇氣光環／召喚", "order": 5,
         "lore": "粵語「古惑仔」、「收數佬」、「睇場」都係香港街頭俗語。本作設定為生前橫行街頭、死後照樣成群結黨收陰間保護費的鬼（不涉及任何真實幫會）。",
         "hint": "大佬企喺度你哋嚇氣都谷唔起，仲會叫人：帶「定」同「刺」先斬大佬。"},
 "klj": {"name": "中國古代骷髏軍團", "sys": "屍", "theme": "散骨／殼", "order": 6,
         "lore": "古戰場白骨無人收殮，民間相傳陰雨夜聽到兵馬聲（「陰兵過境」）。本作設定為秦漢至唐歷代戰死、甲冑兵器仍在身的骷髏兵。",
         "hint": "打散會散成細骷髏、藤牌有殼：帶「掃」清骨頭、「破」打殼。"},
 "wkj": {"name": "倭寇鬼軍團", "sys": "厲", "theme": "突襲／遠程爆炸", "order": 7,
         "lore": "明代東南沿海倭寇為患，戚繼光等將領抗倭（《明史·日本傳》）；歷史上倭寇成員混雜。本作設定為戰國時代海賊裝束的亡魂，重點在海盜兵器裝束，不涉民族醜化。",
         "hint": "一開打就衝埋後排，仲有火繩槍同火藥：帶「定」「拉」截住佢哋。"},
 "ssg": {"name": "食屍鬼軍團", "sys": "妖", "theme": "再生／毒霧", "order": 8,
         "lore": "食屍鬼（ghoul，阿拉伯語 ghūl）見於《一千零一夜》等中東民間故事，常在墳場出沒。本作設定為一群在亂葬崗啃白骨的食屍鬼。",
         "hint": "會回血兼放毒霧：帶「削」停佢回血，唔好企埋一堆。"},
}
SLOTS = ["bing", "shoot", "tank", "elite", "boss", "boss2", "king"]
JSJ_SLOTS = {"yayi": "bing", "guan": "elite", "wangye": "boss", "wutou": "boss2", "jiangchen": "king"}

# 據點：每軍團 3 營（雜兵營 → 頭目營 → 軍團王營），map＝None：未掛圖（第 7 張圖起再接；LG.attach() 或 legion.json CAMP_MAP 指定）
#   en：出場兵種位；guard：主魂（駐守）；co：同場一齊掉主魂嘅兵種位；ring：掛圖時放第幾圈（決定等級同出擊消耗）
CAMP_T = [
 {"n": ["雜兵營", "雜兵營"], "ring": 2, "en": ["bing", "bing", "shoot", "tank", "elite"], "guard": "elite", "co": ["bing", "shoot", "tank"]},
 {"n": ["頭目營", "頭目營"], "ring": 3, "en": ["bing", "shoot", "tank", "boss2", "boss"], "guard": "boss", "co": ["boss2"]},
 {"n": ["軍團王營", "軍團王營"], "ring": 4, "en": ["bing", "tank", "elite", "boss2", "boss", "king"], "guard": "king", "co": []},
]
CAMP_T_JSJ = [
 {"n": ["雜兵營", "雜兵營"], "ring": 2, "en": ["bing", "bing", "bing", "bing", "elite"], "guard": "elite", "co": ["bing"]},
 {"n": ["頭目營", "頭目營"], "ring": 3, "en": ["bing", "bing", "elite", "boss2", "boss"], "guard": "boss", "co": ["boss2"]},
 {"n": ["軍團王營", "軍團王營"], "ring": 4, "en": ["bing", "bing", "elite", "boss2", "boss", "king"], "guard": "king", "co": []},
]

U = {}
def unit(k, **kw): U[k] = kw

# ============================== 1. 餓死鬼 egs（魂：怕燈、黑影；唔怕吹氣） ==============================
unit("lg_egs_bing", slot="bing", name="餓死鬼小兵", title="排咗三十年隊", sc="怪聲", mech=["再生"], rng="近", solid=False,
     trait="細頸大肚，一啖飯都吞唔落，但係見到碗就要搶；肚一咕咕響，成隊一齊衝。",
     say=["隊尾嗰個係咪派緊飯？我排咗三十年喇。", "隊尾那個是不是在派飯？我排了三十年了。"],
     skill={"name": "搶一啖", "kind": "hit", "mult": 1.0, "drain": 0.3, "desc": "撲埋去咬一啖，吸返啲血，仲令對方一陣間補唔到血。"},
     act=A("搶一啖", NEAR(), [DMG(0.9), F("drain", pct=0.3), F("wound", dur=3.0)]),
     pas=[P("kill", [F("hot", pct=0.03, dur=4.0, tg="self")], icd=3)])
unit("lg_egs_shoot", slot="shoot", name="吐焰餓鬼", title="一開口就噴火", sc="吹氣", mech=[], rng="遠", solid=False,
     trait="喉嚨幼過針，一開口就噴鬼火；手執破飯勺，噴完仲要刮兩下。",
     say=["唔係我想噴火，係個肚餓到發滾。", "不是我想噴火，是肚子餓到發燙。"],
     skill={"name": "口噴鬼火", "kind": "aoe", "mult": 0.7, "desc": "一條鬼火直噴過去，燒住一排敵人。"},
     act=A("口噴鬼火", {"sel": "far", "shape": "line", "len": 260, "w": 50}, [DMG(0.7), F("dot", dps=0.15, dur=4.0, kind="fire")], AOE(2, 150)),
     pas=[P("attack", [F("dot", dps=0.08, dur=3.0, kind="fire")], n=3)])
unit("lg_egs_tank", slot="tank", name="大肚飯桶鬼", title="個肚就係飯鑊", sc="鬼臉", mech=["殼", "再生"], rng="近", solid=False,
     trait="成個大肚頂住隻飯鑊當盾；打佢等於敲鑊，越敲佢越肚餓。",
     say=["打啦，打大力啲，敲得響我先知幾時開飯。", "打吧，用力點打，敲得響我才知道什麼時候開飯。"],
     skill={"name": "頂住飯鑊", "kind": "heal", "mult": 0.08, "desc": "飯鑊一頂：身邊敵人全部要打佢，自己加厚皮再補啲血。"},
     act=A("頂住飯鑊", {"sel": "self"}, [F("taunt", r=140, dur=4.0), F("shield", pct=0.3, dur=6.0, tg="self"), F("heal", pct=0.08, tg="self")], AOE(2, 140)),
     pas=[P("hit_taken", [F("hot", pct=0.02, dur=4.0, tg="self")], chance=0.2, icd=6)])
unit("lg_egs_elite", slot="elite", name="搶食鬼", title="包子未出籠已經冇咗", sc="鬼臉", mech=["突襲"], rng="近", solid=False,
     trait="手長爪尖，拖住一袋搶返嚟嘅包子；專搶後排，搶完即刻走。",
     say=["你個包我幫你食咗先，唔使多謝。", "你的包子我先幫你吃了，不用謝。"],
     skill={"name": "搶包", "kind": "hit", "mult": 1.2, "drain": 0.4, "desc": "一下撲去後排搶嘢食，邊打邊吸血。"},
     act=A("搶包", {"sel": "back"}, [F("dash", to="target", dist=280), DMG(1.2), F("drain", pct=0.4)]),
     pas=[P("start", [F("buff", stat="spd", v=0.4, dur=5.0, tg="self")])])
unit("lg_egs_boss", slot="boss", name="餓殍將軍", title="倒轉飯鍋當頭盔", sc="吹氣", mech=["再生", "霸體"], rng="近", solid=False,
     trait="頭戴倒轉飯鍋、身穿破甲，揸住長柄大湯勺；一勺掃落去，成隊人個肚都空晒。",
     say=["本將軍今晚開齋，邊個夠膽同我搶飯？", "本將軍今晚開飯，誰敢跟我搶飯？"],
     skill={"name": "大湯勺掃地", "kind": "aoe", "mult": 1.0, "drain": 0.2, "desc": "長柄大湯勺連掃兩下，身邊敵人全中，打中就吸血。"},
     act=A("大湯勺掃地", NEAR(shape="circle", r=140), [DMG(0.55, hits=2), F("drain", pct=0.2)], AOE(3, 140)),
     pas=[P("low_hp", [F("heal", pct=0.15, tg="self")], pct=0.4), P("every", [F("buff", stat="atk", v=0.15, dur=5.0, tg="self")], star=2, t=10.0)])
unit("lg_egs_boss2", slot="boss2", name="飯堂管事鬼", title="一串空飯票", sc="怪聲", mech=["嚇氣光環", "召喚"], rng="中", solid=False,
     trait="頸掛一大串空飯票，揸飯勺敲鑊叫人；佢一敲，四圍啲餓死鬼即刻湧埋嚟。",
     say=["開飯喇！冇飯票嘅企後面，有飯票嘅……都係企後面。", "開飯了！沒飯票的站後面，有飯票的……也站後面。"],
     skill={"name": "敲鑊開飯", "kind": "heal", "mult": 0.08, "desc": "敲鑊叫人：全隊補血、打得狠啲，仲叫多隻餓鬼嚟幫手。"},
     act=A("敲鑊開飯", {"sel": "allies", "r": 200}, [F("heal", pct=0.08), F("buff", stat="atk", v=0.15, dur=6.0), F("summon", k="lg_egs_bing", n=1, hp_pct=0.25, atk_pct=0.35, dur=12.0, name="餓死鬼小兵")], {"ally_hp": 0.75, "wait": 5}),
     pas=[P("every", [F("sap", v=10, tg="all_r", r=140)], t=9.0)])
unit("lg_egs_king", slot="king", name="饑荒鬼王", title="無底大碗", sc="吹氣", mech=["再生", "召喚", "嚇氣光環"], rng="近", solid=False,
     trait="極高極瘦，頭頂一個倒轉米缸當王冠，捧住一隻無底大碗；身邊鬼火一閃，就多一隻搶食嘅。",
     say=["成條村嘅米缸都係我嘅，你個碗都係。", "整條村的米缸都是我的，你的碗也是。"],
     skill={"name": "饑荒", "kind": "aoe", "mult": 0.9, "drain": 0.3, "sap": 20, "desc": "饑荒一到，身邊敵人全部被吸血、嚇氣都冇埋。"},
     act=A("饑荒", NEAR(shape="circle", r=170), [DMG(0.9), F("drain", pct=0.3), F("sap", v=20)], AOE(3, 170)),
     pas=[P("start", [F("summon", k="lg_egs_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=15.0, name="餓死鬼小兵")]),
          P("kill", [F("heal", pct=0.05, tg="self")], icd=2),
          P("every", [F("summon", k="lg_egs_bing", n=1, hp_pct=0.25, atk_pct=0.35, dur=12.0, name="餓死鬼小兵")], star=2, t=12.0)])

# ============================== 2. 水鬼 sgj（橫：怕凍、鬼臉；唔怕電話） ==============================
unit("lg_sgj_bing", slot="bing", name="水鬼小兵", title="搵緊替身", sc="黑影", mech=["突襲"], rng="近", solid=False,
     trait="濕長髮遮面、成身滴水、披住水草；行近你身邊，地下就濕一大灘。",
     say=["落嚟浸吓啦，水溫啱啱好。", "下來泡一泡吧，水溫剛剛好。"],
     skill={"name": "扯落水", "kind": "hit", "mult": 0.8, "desc": "一手扯人埋嚟，嚇到佢嚇氣都散。"},
     act=A("扯落水", NEAR(), [DMG(0.8), F("pull", dist=60), F("sap", v=10)]),
     pas=[P("death", [F("slow", v=0.3, dur=2.0, tg="all_r", r=90)])])
unit("lg_sgj_shoot", slot="shoot", name="噴水鬼", title="鼓埋腮就噴", sc="吹氣", mech=[], rng="遠", solid=False,
     trait="成日鼓住泡腮，一張口就係一條水柱；噴完要吞返兩啖河水先噴得第二輪。",
     say=["唔好意思，飲多咗。", "不好意思，喝多了。"],
     skill={"name": "水柱", "kind": "aoe", "mult": 0.65, "apply": "push", "desc": "一條水柱射穿成排敵人，撞到嘅退後兩步。"},
     act=A("水柱", {"sel": "far", "shape": "line", "len": 300, "w": 40}, [DMG(0.65), F("push", dist=40)], AOE(2, 150)),
     pas=[P("hit_taken", [F("slow", v=0.3, dur=2.0, tg="attacker")], chance=0.25, icd=6)])
unit("lg_sgj_tank", slot="tank", name="浮木盾鬼", title="背住一塊爛門板", sc="怪聲", mech=["殼"], rng="近", solid=False,
     trait="背住塊爛門板，身纏麻繩；門板擋喺前面，麻繩一甩就拉人落水。",
     say=["呢塊門板浮咗我三年，你打唔爛㗎。", "這塊門板讓我浮了三年，你打不爛的。"],
     skill={"name": "門板擋", "kind": "hit", "mult": 0.5, "desc": "門板一擋，身邊隊友受嘅傷佢分擔一份。"},
     act=A("門板擋", {"sel": "self"}, [F("guard", r=100, pct=0.35, dur=6.0), F("shield", pct=0.25, dur=6.0, tg="self"), F("immune", tags=["push"], dur=6.0, tg="self")], AOE(2, 140)),
     pas=[P("every", [F("pull", dist=70, tg="far")], t=10.0)])
unit("lg_sgj_elite", slot="elite", name="拖腳鬼", title="地下嗰灘水", sc="黑影", mech=["突襲", "隱"], rng="近", solid=False,
     trait="下身係一灘黑水，長手由水窪伸出嚟拉腳；你望落地，佢早就喺你後面。",
     say=["企穩呀，唔好望落地。", "站穩啊，別往地上看。"],
     skill={"name": "拖腳", "kind": "hit", "mult": 1.1, "apply": "down", "desc": "由水窪鑽到後排，一手拉腳令人仆低。"},
     act=A("拖腳", {"sel": "back"}, [F("dash", to="target", dist=260), DMG(1.1), F("down", dur=1.5), F("slow", v=0.3, dur=2.0)]),
     pas=[P("start", [F("stealth", dur=2.5, first_x=1.4, tg="self")])])
unit("lg_sgj_boss", slot="boss", name="水鬼統領", title="生鏽鐵錨話事", sc="電話", mech=["突襲", "霸體"], rng="近", solid=False,
     trait="披住破漁網做披風、揸生鏽鐵錨、身上掛滿蜆殼；佢一甩錨，最惡嗰個都要拉埋嚟。",
     say=["拉一個落嚟，我就上去一個；呢單數我計得好清。", "拉一個下來，我就上去一個；這筆帳我算得很清楚。"],
     skill={"name": "鐵錨鈎", "kind": "hit", "mult": 1.8, "desc": "鐵錨甩去最勁嗰個，鈎埋嚟兼打爛佢件甲。"},
     act=A("鐵錨鈎", {"sel": "strong"}, [DMG(1.8), F("pull", dist=120), F("armor_break", v=0.3, dur=5.0)]),
     pas=[P("start", [F("immune", tags=["down", "push", "air"], dur=-1, tg="self")], star=2)])
unit("lg_sgj_boss2", slot="boss2", name="水閘鬼婆", title="一開閘就淹", sc="怪聲", mech=["迷魂", "殼"], rng="中", solid=False,
     trait="濕長髮包住全身，揸住舊水閘輪盤；輪盤一扭，閘門吱吱聲，大水就沖埋嚟。",
     say=["呢度幾時放水，我話事。", "這裡什麼時候放水，我說了算。"],
     skill={"name": "開閘放水", "kind": "aoe", "mult": 0.7, "apply": "push", "desc": "閘門一開，身邊敵人被沖開兼慢晒，一陣間放唔到技。"},
     act=A("開閘放水", NEAR(shape="circle", r=160), [DMG(0.7), F("push", dist=60), F("slow", v=0.4, dur=3.0), F("silence", dur=1.5)], AOE(3, 160)),
     pas=[P("low_hp", [F("shield", pct=0.25, dur=6.0, tg="self")], pct=0.5)])
unit("lg_sgj_king", slot="king", name="黑潭水鬼王", title="下身係個漩渦", sc="黑影", mech=["突襲", "迷魂", "霸體"], rng="近", solid=False,
     trait="下身係一個打轉嘅黑潭，頭戴水草冠、揸巨型魚叉；行近佢嘅，個個都被捲落潭。",
     say=["個潭冇底㗎，你試吓踩落嚟。", "這潭沒底的，你試試踩下來。"],
     skill={"name": "黑潭漩渦", "kind": "aoe", "mult": 1.0, "desc": "黑潭一轉，身邊敵人捲埋一齊，連打兩下。"},
     act=A("黑潭漩渦", NEAR(shape="circle", r=180), [F("pull", dist=80), DMG(0.55, hits=2)], AOE(3, 180)),
     pas=[P("every", [F("confuse", dur=2.0, tg="all_r", r=140)], t=11.0), P("low_hp", [F("stealth", dur=2.0, tg="self")], star=2, pct=0.5)])

# ============================== 3. 紙紮人 zzj（紙紮：怕燈、吹氣；唔怕紙） ==============================
unit("lg_zzj_bing", slot="bing", name="紙紮兵", title="竹篾骨、銀紙刀", sc="紙", mech=["反傷"], rng="近", solid=True,
     trait="竹篾紮骨、彩紙糊身，揸住把銀紙刀；斬人斬得爽，最怕有人點火。",
     say=["收咗你哋陽間一疊銀紙，總要做返啲嘢。", "收了你們陽間一疊銀紙，總得做點事。"],
     skill={"name": "銀紙刀", "kind": "hit", "mult": 0.55, "desc": "銀紙刀連斬兩下，打斷對方放技。"},
     act=A("銀紙刀", NEAR(), [DMG(0.55, hits=2), F("interrupt"), F("mark", v=0.1, dur=3.0)]),
     pas=[P("hit_taken", [DMG(0.3)], chance=0.2, icd=5)])
unit("lg_zzj_shoot", slot="shoot", name="紙紮弓手", title="紅紙箭尾", sc="黑影", mech=[], rng="遠", solid=True,
     trait="紙弓紙箭、箭尾貼紅紙；射得準，但係落雨天就成支箭軟晒。",
     say=["紙箭都係箭，射中一樣痛。", "紙箭也是箭，射中一樣痛。"],
     skill={"name": "紅尾紙箭", "kind": "hit", "mult": 1.1, "desc": "一箭射穿對方件甲，之後受傷加重。"},
     act=A("紅尾紙箭", {"sel": "far"}, [DMG(1.1), F("armor_break", v=0.25, dur=4.0)]),
     pas=[P("every", [F("mark", v=0.15, dur=4.0, tg="far")], t=8.0)])
unit("lg_zzj_tank", slot="tank", name="紙紮大力士", title="虎頭紙盾", sc="鬼臉", mech=["殼", "反傷"], rng="近", solid=True,
     trait="圓碌碌嘅紙糊大隻佬，揸住虎頭紙盾；你一刀斬落去，盾上隻虎就咬返你一啖。",
     say=["打我？我身紙皮好厚㗎，打到你手軟。", "打我？我這身紙皮很厚的，打到你手軟。"],
     skill={"name": "虎頭盾", "kind": "heal", "mult": 0.03, "desc": "虎頭盾一舉，身邊敵人全部要打佢，佢自己慢慢補返血。"},
     act=A("虎頭盾", {"sel": "self"}, [F("taunt", r=150, dur=4.0), F("shield", pct=0.3, dur=6.0, tg="self"), F("hot", pct=0.03, dur=5.0, tg="self")], AOE(2, 150)),
     pas=[P("hit_taken", [DMG(0.4)], chance=0.3, icd=5)])
unit("lg_zzj_elite", slot="elite", name="紙紮馬騎兵", title="紅纓紙槍", sc="怪聲", mech=["突襲"], rng="近", solid=True,
     trait="騎住紙紮馬、揸紅纓紙槍；馬蹄聲一響，佢已經衝咗入你後排。",
     say=["匹馬係新燒落嚟，跑得快過你哋啲車。", "這匹馬是新燒下來的，跑得比你們的車快。"],
     skill={"name": "紅纓衝陣", "kind": "hit", "mult": 1.3, "apply": "down", "desc": "騎馬衝去後排，一槍挑到對方仆低。"},
     act=A("紅纓衝陣", {"sel": "back"}, [F("dash", to="target", dist=300), DMG(1.3), F("down", dur=1.0), F("push", dist=40)]),
     pas=[P("start", [F("buff", stat="spd", v=0.5, dur=4.0, tg="self")])])
unit("lg_zzj_boss", slot="boss", name="紙紮將軍", title="一身紙甲一把紙關刀", sc="紙", mech=["反傷", "霸體"], rng="近", solid=True,
     trait="整套紙紮將軍盔甲、金銀箔貼邊，揸住紙關刀；你近身打佢，刀風就掃返你。",
     say=["紙甲又點？燒落嚟嗰日，我都係將軍。", "紙甲又怎樣？燒下來那天，我也是將軍。"],
     skill={"name": "紙關刀", "kind": "aoe", "mult": 1.1, "desc": "紙關刀連劈兩下，身邊敵人全部中。"},
     act=A("紙關刀", NEAR(shape="circle", r=150), [DMG(0.6, hits=2)], AOE(3, 150)),
     pas=[P("hit_taken", [DMG(0.5)], chance=0.3, icd=6), P("start", [F("shield", pct=0.2, dur=8.0, tg="self")], star=2)])
unit("lg_zzj_boss2", slot="boss2", name="紙紮轎夫頭", title="扛住半頂紙轎", sc="凍", mech=["召喚", "反傷"], rng="中", solid=True,
     trait="扛住半頂紙紮轎、揸住紙燈籠；轎一放低，入面就行出幾個紙紮兵。",
     say=["起轎！大人話今晚要遊夜街。", "起轎！大人說今晚要夜遊街。"],
     skill={"name": "撞轎", "kind": "aoe", "mult": 0.6, "apply": "push", "desc": "紙轎一撞，身邊敵人撞開兼嚇散嚇氣；紙燈籠照出匿埋嘅。"},
     act=A("撞轎", NEAR(shape="circle", r=140), [DMG(0.6), F("push", dist=50), F("sap", v=15)], AOE(3, 140)),
     pas=[P("start", [F("summon", k="lg_zzj_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=14.0, name="紙紮兵")]), P("every", [F("reveal", r=150, dur=3.0, tg="self")], t=10.0)])
unit("lg_zzj_king", slot="king", name="紙紮大官", title="全身金銀箔", sc="紙", mech=["反傷", "殼", "召喚"], rng="中", solid=True,
     trait="紙官帽、紙朝服、全身金銀箔，全軍最華麗；一份紙文書批落嚟，成排人講唔出聲。",
     say=["本官批咗，你哋照做就得。", "本官批了，你們照做就行。"],
     skill={"name": "批紙文書", "kind": "aoe", "mult": 0.8, "desc": "紙文書一路彈過去，打中四個敵人，中嘅一陣間放唔到技。"},
     act=A("批紙文書", {"sel": "far", "shape": "chain", "n": 4, "falloff": 0.85}, [DMG(0.8), F("silence", dur=2.0)], AOE(2, 160)),
     pas=[P("start", [F("summon", k="lg_zzj_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=16.0, name="紙紮兵")]),
          P("hit_taken", [DMG(0.5)], star=2, chance=0.3, icd=5)])

# ============================== 4. 殭屍 jsj（屍：怕吹氣、怪聲；唔怕凍）——只 5 種 ==============================
unit("lg_jsj_yayi", slot="bing", name="普通衙役殭屍", title="涼帽紅纓跳出巡", sc="凍", mech=["屍變"], rng="近", solid=True,
     trait="青黑號衣、清朝涼帽，雙手平伸跳住行；一出就三五隻，跳到你面前咬一啖就散。",
     say=["升堂……升堂……邊位係被告？", "升堂……升堂……哪位是被告？"],
     skill={"name": "跳撲", "kind": "hit", "mult": 0.9, "apply": "down", "desc": "一跳撲埋去，撞到對方仆低。"},
     act=A("跳撲", NEAR(), [F("dash", to="target", dist=120), DMG(0.9), F("down", dur=0.6)]),
     pas=[P("death", [F("buff", stat="atk", v=0.1, dur=4.0, tg="allies")])])
unit("lg_jsj_guan", slot="elite", name="官員殭屍", title="帶隊升堂", sc="紙", mech=["嚇氣光環"], rng="中", solid=True,
     trait="石青補服、頂珠涼帽，自己唔多打得，但一喝「升堂」，身邊衙役殭屍即刻跳快兩倍；斬咗佢，成隊即刻散慢。",
     say=["本官升堂，閒雜人等迴避。", "本官升堂，閒雜人等迴避。"],
     skill={"name": "升堂", "kind": "heal", "mult": 0.0, "desc": "一喝升堂：身邊殭屍打得狠啲、嚇氣儲得快。"},
     act=A("升堂", {"sel": "allies", "r": 180}, [F("buff", stat="atk", v=0.2, dur=6.0), F("buff", stat="spd", v=0.25, dur=6.0), F("energy", v=15)], {"n_in": 2, "r": 160, "wait": 6}),
     pas=[P("every", [F("silence", dur=1.5, tg="near")], t=8.0)],
     aura={"star": 0, "r": 150, "side": "ally", "fx": [{"p": "immune", "tags": ["fear_aura", "confuse"], "dur": -1}]})
unit("lg_jsj_wangye", slot="boss", name="王爺殭屍", title="一跳地都震", sc="黑影", mech=["霸體", "殼"], rng="近", solid=True,
     trait="身形大過常人，一身王爺朝服；佢企喺前面，後排乜都睇唔到。一跳落地，成個地都震。",
     say=["本王跳一下，你哋就要企唔穩。", "本王跳一下，你們就要站不穩。"],
     skill={"name": "落地震", "kind": "aoe", "mult": 0.8, "apply": "down", "desc": "跳起落地一震，身邊敵人全部仆低，仲要對住佢打。"},
     act=A("落地震", {"sel": "self", "shape": "self_circle", "r": 130}, [DMG(0.8), F("down", dur=0.8), F("taunt", r=140, dur=3.0)], AOE(3, 130)),
     pas=[P("start", [F("immune", tags=["push", "air"], dur=-1, tg="self")])])
unit("lg_jsj_wutou", slot="boss2", name="無頭王爺殭屍", title="冇頭唔怕嚇", sc="黑影", mech=["霸體", "屍變"], rng="近", solid=True,
     trait="冇咗個頭，所以唔會被嚇、唔會被迷魂；不過睇唔到路，跳得慢、四圍亂撞，撞到邊個打邊個。",
     say=["……（冇頭，講唔到嘢，淨係用手指住你）", "……（沒有頭，說不了話，只用手指著你）"],
     skill={"name": "亂撞", "kind": "aoe", "mult": 1.2, "desc": "一路亂撞過去，撞到成排人，連撞兩下。"},
     act=A("亂撞", NEAR(shape="line", len=220, w=70), [DMG(0.6, hits=2)], AOE(2, 180)),
     pas=[P("start", [F("immune", tags=["confuse", "charm", "flee", "fear", "fear_aura"], dur=-1, tg="self"), F("buff", stat="spd", v=-0.25, dur=-1, tg="self")])])
unit("lg_jsj_jiangchen", slot="king", name="將臣殭屍", title="殭屍之祖", sc="凍", mech=["召喚", "霸體", "屍變"], rng="近", solid=True,
     trait="傳說中嘅殭屍始祖，清朝親王式華麗朝服、長白髮、利爪；一現身全軍殭屍狂暴，仲會不停叫衙役殭屍出嚟。",
     say=["你哋叫我殭屍？我叫你哋做晚輩。", "你們叫我殭屍？我叫你們做晚輩。"],
     skill={"name": "吸精", "kind": "hit", "mult": 1.8, "drain": 0.35, "desc": "利爪一插，吸走對方大把血補返自己。"},
     act=A("吸精", NEAR(), [DMG(1.8), F("drain", pct=0.35)]),
     pas=[P("start", [F("summon", k="lg_jsj_yayi", n=2, hp_pct=0.25, atk_pct=0.35, dur=15.0, name="普通衙役殭屍"), F("buff", stat="atk", v=0.25, dur=6.0, tg="allies")]),
          P("every", [F("summon", k="lg_jsj_yayi", n=1, hp_pct=0.25, atk_pct=0.35, dur=12.0, name="普通衙役殭屍")], star=2, t=12.0)])

# ============================== 5. 地痞流氓 dpl（使：怕紙、黑影；唔怕鬼臉） ==============================
unit("lg_dpl_bing", slot="bing", name="古惑鬼", title="花恤衫拖鞋揸棍", sc="鬼臉", mech=[], rng="近", solid=False,
     trait="花恤衫、人字拖、揸住條木棍；自己一個唔敢郁，成班人先夠膽企出嚟。",
     say=["呢條街我哋睇㗎，交咗陰間保護費未呀？", "這條街是我們罩的，交了陰間保護費沒有？"],
     skill={"name": "揸棍", "kind": "hit", "mult": 0.6, "desc": "木棍亂揮兩下，嚇到對方嚇氣都散。"},
     act=A("揸棍", NEAR(), [DMG(0.6, hits=2), F("sap", v=8)]),
     pas=[P("start", [F("buff", stat="atk", v=0.1, dur=5.0, tg="self")])])
unit("lg_dpl_shoot", slot="shoot", name="擲樽鬼", title="玻璃樽隨手掟", sc="怪聲", mech=[], rng="遠", solid=False,
     trait="手拎玻璃樽（冇標籤），由後面一路掟過嚟；玻璃碎聲一響，前面啲人都縮一縮。",
     say=["接住！唔好話我唔請你飲嘢。", "接著！別說我沒請你喝東西。"],
     skill={"name": "擲樽", "kind": "aoe", "mult": 0.8, "desc": "一樽掟過去，碎玻璃濺到身邊幾個，行得慢晒。"},
     act=A("擲樽", {"sel": "far", "shape": "circle", "r": 70}, [DMG(0.8), F("slow", v=0.3, dur=2.5)], AOE(2, 70)),
     pas=[P("kill", [F("energy", v=20, tg="self")], icd=3)])
unit("lg_dpl_tank", slot="tank", name="大隻佬鬼", title="背心紋龍虎", sc="怪聲", mech=["霸體"], rng="近", solid=False,
     trait="背心一件、兩臂紋滿龍虎花紋；企喺門口一喝，邊個都要對住佢先。",
     say=["企埋一邊，大佬未開聲，邊個都唔准過。", "站到一邊，老大沒開口，誰都不准過。"],
     skill={"name": "企埋嚟", "kind": "hit", "mult": 0.5, "desc": "一喝企埋嚟：身邊敵人全部要打佢，佢自己受傷少三成。"},
     act=A("企埋嚟", {"sel": "self"}, [F("taunt", r=160, dur=4.0), F("buff", stat="taken", v=-0.3, dur=6.0, tg="self")], AOE(2, 160)),
     pas=[P("kill", [F("heal", pct=0.1, tg="self")], icd=3)])
unit("lg_dpl_elite", slot="elite", name="收數鬼", title="賬簿算盤一齊嚟", sc="電話", mech=["突襲"], rng="近", solid=False,
     trait="皮褸、賬簿、算盤，專搵最殘嗰個追數；佢一撥算盤，你嚇氣就少一截。",
     say=["本金唔緊要，利息今晚要清。", "本金不要緊，利息今晚要還清。"],
     skill={"name": "追數", "kind": "hit", "mult": 1.0, "sap": 25, "desc": "衝去最殘嗰個追數，打完仲刮走佢啲嚇氣同冥幣。"},
     act=A("追數", {"sel": "low"}, [F("dash", to="target", dist=260), DMG(1.0), F("sap", v=25), F("coin", v=15)]),
     pas=[P("kill", [F("energy", v=25, tg="self")], icd=4)])
unit("lg_dpl_boss", slot="boss", name="大佬鬼", title="金鏈墨鏡揸鐵通", sc="鬼臉", mech=["召喚", "嚇氣光環"], rng="近", solid=False,
     trait="金鏈、墨鏡、披住西裝外套揸鐵通；佢企喺度，你哋嚇氣都谷唔起；一個眼色，又多幾個古惑鬼。",
     say=["我唔使郁手，叫一聲就得。", "我不用動手，喊一聲就行。"],
     skill={"name": "叫人", "kind": "aoe", "mult": 0.8, "desc": "鐵通一揮嚇散身邊敵人，仲叫埋細嚟幫手。"},
     act=A("叫人", NEAR(shape="circle", r=150), [DMG(0.8), F("flee", dur=1.5), F("sap", v=15)], AOE(3, 150)),
     pas=[P("start", [F("summon", k="lg_dpl_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=14.0, name="古惑鬼")])])
unit("lg_dpl_boss2", slot="boss2", name="睇場鬼", title="對講機唔離手", sc="電話", mech=["嚇氣光環", "殼"], rng="近", solid=False,
     trait="黑西裝、雙臂交叉、揸住對講機；有人入場佢第一個知，即刻推人出去。",
     say=["場內禁止打交，要打出去打。", "場內禁止打架，要打出去打。"],
     skill={"name": "清場", "kind": "hit", "mult": 0.9, "apply": "push", "desc": "一推清場：撞開最近嗰個，身邊隊友受傷佢分擔。"},
     act=A("清場", NEAR(), [DMG(0.9), F("push", dist=70), F("guard", r=120, pct=0.3, dur=5.0)]),
     pas=[P("every", [F("reveal", r=140, dur=3.0, tg="self")], t=8.0)])
unit("lg_dpl_king", slot="king", name="龍頭鬼", title="玉扳指一轉", sc="燈", mech=["召喚", "嚇氣光環", "霸體"], rng="近", solid=False,
     trait="龍虎花紋唐裝、手戴玉扳指；成條街嘅鬼見到佢都要讓路，佢一聲令下全場打得狠啲。",
     say=["做人要講義氣，做鬼都係。", "做人要講義氣，做鬼也是。"],
     skill={"name": "龍頭話事", "kind": "heal", "mult": 0.06, "desc": "龍頭一開聲：全隊補血、打得狠啲、嚇氣儲得快。"},
     act=A("龍頭話事", {"sel": "allies", "r": 220}, [F("heal", pct=0.06), F("buff", stat="atk", v=0.25, dur=8.0), F("energy", v=20)], {"ally_hp": 0.8, "wait": 5}),
     pas=[P("start", [F("summon", k="lg_dpl_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=15.0, name="古惑鬼")]),
          P("every", [F("summon", k="lg_dpl_tank", n=1, hp_pct=0.3, atk_pct=0.3, dur=14.0, name="大隻佬鬼")], star=2, t=14.0)])

# ============================== 6. 中國古代骷髏 klj（屍；軍師＝官） ==============================
unit("lg_klj_bing", slot="bing", name="骷髏步卒", title="生鏽兜鍪持戈", sc="凍", mech=["散骨"], rng="近", solid=True,
     trait="生鏽兜鍪、破皮札甲、揸住支戈；打散咗都會再砌返幾舊細骨頭。",
     say=["點名……到。仲有冇人記得我個名？", "點名……到。還有人記得我的名字嗎？"],
     skill={"name": "持戈啄", "kind": "hit", "mult": 0.8, "desc": "戈頭連啄兩下，鈎住對方扯埋嚟。"},
     act=A("持戈啄", NEAR(), [DMG(0.45, hits=2), F("pull", dist=40)]),
     pas=[P("death", [F("slow", v=0.25, dur=2.0, tg="killer")])])
unit("lg_klj_shoot", slot="shoot", name="骷髏弩手", title="秦弩上弦", sc="黑影", mech=["散骨"], rng="遠", solid=True,
     trait="揸住秦式弩，一箭射穿成排人；上弦慢，但一箭夠力。",
     say=["一千年前上嘅弦，今晚先射得出。", "一千年前上的弦，今晚才射得出去。"],
     skill={"name": "秦弩", "kind": "aoe", "mult": 1.0, "desc": "一支弩箭直線射穿成排敵人，中嘅受傷加重。"},
     act=A("秦弩", {"sel": "far", "shape": "line", "len": 340, "w": 30}, [DMG(1.0), F("mark", v=0.15, dur=4.0)], AOE(2, 150)),
     pas=[P("start", [F("buff", stat="aspd", v=-0.15, dur=-1, tg="self")])])
unit("lg_klj_tank", slot="tank", name="骷髏藤牌兵", title="藤牌短刀", sc="鬼臉", mech=["殼"], rng="近", solid=True,
     trait="大藤牌加短刀，縮喺牌後面慢慢推前；藤牌硬過殼，打唔穿就只好繞路。",
     say=["藤牌陣，唔好問點破，問就係打唔穿。", "藤牌陣，別問怎麼破，問就是打不穿。"],
     skill={"name": "藤牌陣", "kind": "hit", "mult": 0.5, "desc": "藤牌一立：身邊隊友受傷佢分擔，自己加層厚皮。"},
     act=A("藤牌陣", {"sel": "self"}, [F("guard", r=110, pct=0.4, dur=6.0), F("shield", pct=0.25, dur=6.0, tg="self")], AOE(2, 140)),
     pas=[P("hit_taken", [F("down", dur=0.8, tg="attacker")], chance=0.25, icd=6)])
unit("lg_klj_elite", slot="elite", name="骷髏陌刀手", title="唐代長刀橫劈", sc="凍", mech=["霸體", "散骨"], rng="近", solid=True,
     trait="雙手揸住唐代長柄陌刀向前衝劈，生鏽兜鍪、暗紅腰帶紅纓；一刀落去人馬俱碎。",
     say=["陌刀隊，向前。", "陌刀隊，向前。"],
     skill={"name": "陌刀橫劈", "kind": "aoe", "mult": 1.3, "desc": "陌刀橫劈前方一大片，連斬兩下，殘血嘅直接斬落。"},
     act=A("陌刀橫劈", NEAR(shape="cone", r=150, deg=80), [DMG(0.7, hits=2), F("execute", hp_pct=0.2, x=2.0)], AOE(2, 150)),
     pas=[P("kill", [F("buff", stat="atk", v=0.15, dur=5.0, tg="self")], icd=3)])
unit("lg_klj_boss", slot="boss", name="骷髏大將", title="長戟破披風", sc="黑影", mech=["殼", "霸體"], rng="近", solid=True,
     trait="秦漢至唐式完整將軍甲、破披風、揸長戟；一戟刺出，成排人仆低。",
     say=["本將戰死沙場，仲未收兵。", "本將戰死沙場，還沒收兵。"],
     skill={"name": "長戟突刺", "kind": "aoe", "mult": 1.2, "apply": "down", "desc": "長戟直刺穿成排敵人，中嘅全部仆低。"},
     act=A("長戟突刺", NEAR(shape="line", len=200, w=50), [DMG(1.2), F("down", dur=1.0)], AOE(2, 200)),
     pas=[P("start", [F("shield", pct=0.2, dur=8.0, tg="self")]), P("low_hp", [F("taunt", r=150, dur=3.0)], pct=0.4)])
unit("lg_klj_boss2", slot="boss2", sys="官", name="骷髏軍師", title="羽扇綸巾", sc="吹氣", mech=["迷魂", "分身"], rng="中", solid=True,
     trait="羽扇綸巾、破長袍；羽扇一撥，你哋就分唔清邊個係真、邊個係假，仲行錯方向。",
     say=["兵者，詭道也。你哋行錯路喇。", "兵者，詭道也。你們走錯路了。"],
     skill={"name": "羽扇綸巾", "kind": "aoe", "mult": 0.6, "desc": "羽扇一撥：一堆敵人亂走、放唔到技。"},
     act=A("羽扇綸巾", {"sel": "far", "shape": "circle", "r": 120}, [DMG(0.6), F("confuse", dur=2.0), F("silence", dur=1.5)], AOE(3, 120)),
     pas=[P("hit_taken", [F("stealth", dur=1.5, tg="self")], chance=0.25, icd=8)])
unit("lg_klj_king", slot="king", name="骷髏帝王將", title="冕旒骨旗", sc="鬼臉", mech=["殼", "散骨", "召喚"], rng="近", solid=True,
     trait="巨大骷髏，帝王式甲冑配冕旒頭盔，立於無字骨旗之下；骨旗一揮，地下白骨又企返起身。",
     say=["朕嘅兵，一個都未退。", "朕的兵，一個都還沒退。"],
     skill={"name": "骨旗令", "kind": "aoe", "mult": 1.0, "desc": "骨旗一揮連打兩下，身邊敵人嘅護盾全部打爆。"},
     act=A("骨旗令", NEAR(shape="circle", r=170), [DMG(0.55, hits=2), F("shield_break")], AOE(3, 170)),
     pas=[P("start", [F("summon", k="lg_klj_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=15.0, name="骷髏步卒")]),
          P("every", [F("taunt", r=160, dur=3.0)], star=2, t=12.0)])

# ============================== 7. 倭寇 wkj（厲：怕電話、鬼臉；唔怕怪聲） ==============================
unit("lg_wkj_bing", slot="bing", name="倭刀鬼", title="頭纏布巾持長刀", sc="怪聲", mech=["突襲"], rng="近", solid=False,
     trait="破爛短打、頭纏布巾、揸住長刀；一上岸就喊住衝，斬到人傷口好耐都埋唔到。",
     say=["船泊好未？泊好就上岸。", "船停好了沒？停好就上岸。"],
     skill={"name": "長刀斬", "kind": "hit", "mult": 0.9, "desc": "衝埋去一刀，傷口一陣間補唔到血。"},
     act=A("長刀斬", NEAR(), [F("dash", to="target", dist=160), DMG(0.9), F("wound", dur=4.0)]),
     pas=[P("start", [F("buff", stat="spd", v=0.3, dur=4.0, tg="self")])])
unit("lg_wkj_shoot", slot="shoot", name="火繩槍鬼", title="引信冒鬼火", sc="燈", mech=[], rng="遠", solid=False,
     trait="陣笠、舊式火繩槍，引信冒住鬼火；砰一聲，前面嗰個退後幾步。",
     say=["砰！……再等我裝多陣火藥。", "砰！……再等我裝一會兒火藥。"],
     skill={"name": "鐵砲", "kind": "hit", "mult": 1.4, "apply": "push", "desc": "火繩槍一發，打中嘅退後。"},
     act=A("鐵砲", {"sel": "far"}, [DMG(1.4), F("push", dist=30)]),
     pas=[P("every", [F("dmg", mult=M(0.5), tg="far")], t=9.0)])
unit("lg_wkj_tank", slot="tank", name="船錨力士", title="四爪鐵錨", sc="黑影", mech=["殼"], rng="近", solid=False,
     trait="赤膊大塊頭、扛住四爪鐵錨；錨一甩，最近嗰個就被鈎埋嚟。",
     say=["錨落咗，船唔走，我都唔走。", "錨放下了，船不走，我也不走。"],
     skill={"name": "四爪鐵錨", "kind": "hit", "mult": 1.0, "desc": "鐵錨鈎人埋嚟，身邊敵人都要對住佢打。"},
     act=A("四爪鐵錨", NEAR(), [DMG(1.0), F("pull", dist=100), F("taunt", r=120, dur=3.0)]),
     pas=[P("low_hp", [F("shield", pct=0.25, dur=6.0, tg="self")], pct=0.4)])
unit("lg_wkj_elite", slot="elite", name="縱火鬼", title="火把火藥罐", sc="燈", mech=[], rng="中", solid=False,
     trait="一手火把、一手火藥罐；罐一掟出去，一大片燒住。",
     say=["燒得旺，先睇得清。", "燒得旺，才看得清楚。"],
     skill={"name": "火藥罐", "kind": "aoe", "mult": 1.0, "desc": "火藥罐炸開一大片，中嘅持續燒傷。"},
     act=A("火藥罐", {"sel": "far", "shape": "circle", "r": 110}, [DMG(1.0), F("dot", dps=0.2, dur=4.0, kind="fire")], AOE(2, 110)),
     pas=[P("death", [F("dot", dps=0.15, dur=3.0, kind="fire", tg="all_r", r=90)])])
unit("lg_wkj_boss", slot="boss", name="倭寇首領", title="雙刀蓑衣", sc="怪聲", mech=["突襲", "霸體"], rng="近", solid=False,
     trait="破舊海賊裝束、披蓑衣、揸雙刀，背後一幅破帆；開打即刻殺入你後排。",
     say=["上岸！搶完就走。", "上岸！搶完就走。"],
     skill={"name": "雙刀亂斬", "kind": "hit", "mult": 0.7, "desc": "撲去後排雙刀亂斬三下。"},
     act=A("雙刀亂斬", {"sel": "back"}, [F("dash", to="target", dist=280), DMG(0.45, hits=3)]),
     pas=[P("kill", [F("energy", v=30, tg="self")], icd=3)])
unit("lg_wkj_boss2", slot="boss2", name="鬼船舵手", title="身纏纜繩", sc="凍", mech=["隱", "迷魂"], rng="中", solid=False,
     trait="身纏纜繩、揸住大櫓；佢一搖，海霧就湧上岸，人人行錯方向。",
     say=["霧大，跟實我把櫓。", "霧大，跟緊我的櫓。"],
     skill={"name": "海霧", "kind": "aoe", "mult": 0.5, "desc": "海霧湧過嚟：身邊敵人行慢、亂走、嚇氣散。"},
     act=A("海霧", NEAR(shape="circle", r=160), [DMG(0.5), F("slow", v=0.4, dur=4.0), F("confuse", dur=1.5), F("sap", v=10)], AOE(3, 160)),
     pas=[P("low_hp", [F("stealth", dur=3.0, tg="self")], pct=0.5)])
unit("lg_wkj_king", slot="king", name="倭寇鬼王", title="大薙刀橫掃", sc="黑影", mech=["突襲", "霸體", "隱"], rng="近", solid=False,
     trait="戰國殘破大鎧、無紋鬼角兜、破帆布披風，下身係海霧；雙手大薙刀向前一掃，殘血嘅即刻倒。",
     say=["海霧散之前，冇人走得甩。", "海霧散去之前，沒人走得掉。"],
     skill={"name": "大薙刀橫掃", "kind": "aoe", "mult": 1.3, "apply": "push", "desc": "大薙刀橫掃前方兩下，撞開成排人，殘血即斬。"},
     act=A("大薙刀橫掃", NEAR(shape="cone", r=170, deg=100), [DMG(0.7, hits=2), F("push", dist=60), F("execute", hp_pct=0.2, x=2.0)], AOE(2, 170)),
     pas=[P("start", [F("stealth", dur=2.5, tg="self")]), P("kill", [F("energy", v=25, tg="self")], icd=3)])

# ============================== 8. 食屍鬼 ssg（妖：怕怪聲、凍；唔怕黑影） ==============================
unit("lg_ssg_bing", slot="bing", name="食屍鬼小兵", title="半蹲啃骨", sc="鬼臉", mech=["再生"], rng="近", solid=True,
     trait="灰綠皮膚、佝僂長爪、尖耳；四肢著地撲過嚟，見到殘血嘅就咬到佢唔起身。",
     say=["呢舊骨仲有啲味，你要唔要？", "這根骨頭還有點味道，你要不要？"],
     skill={"name": "啃骨", "kind": "hit", "mult": 0.8, "drain": 0.25, "desc": "撲埋去咬，殘血嘅直接咬死，咬中補返血。"},
     act=A("啃骨", NEAR(), [DMG(0.8), F("execute", hp_pct=0.2, x=2.0), F("drain", pct=0.25), F("slow", v=0.2, dur=2.0)]),
     pas=[P("kill", [F("heal", pct=0.08, tg="self")], icd=3)])
unit("lg_ssg_shoot", slot="shoot", name="腐臭鬼", title="一口毒霧", sc="吹氣", mech=[], rng="遠", solid=True,
     trait="口吐綠色毒霧，臭到幾條街外都聞到；毒霧落地之後，企喺入面嘅慢慢扣血。",
     say=["唔好意思，我成日都係呢陣味。", "不好意思，我一直都是這股味道。"],
     skill={"name": "毒霧", "kind": "aoe", "mult": 0.3, "desc": "噴一團毒霧落地，企喺入面嘅持續中毒。"},
     act=A("毒霧", {"sel": "far"}, [DMG(0.4), F("zone", r=90, dur=5.0, fx=[{"p": "dot", "dps": 0.12, "dur": 2.0, "kind": "poison"}])], AOE(2, 90)),
     pas=[P("every", [F("slow", v=0.2, dur=2.0, tg="far")], t=10.0)])
unit("lg_ssg_tank", slot="tank", name="巨食屍鬼", title="墓碑當盾", sc="黑影", mech=["殼", "再生"], rng="近", solid=True,
     trait="大隻臃腫，拖住塊無字墓碑當盾；擋喺前面，越打越慢慢補返。",
     say=["塊碑冇寫名，借嚟擋吓唔緊要啩。", "這塊碑沒寫名字，借來擋擋不要緊吧。"],
     skill={"name": "墓碑盾", "kind": "heal", "mult": 0.03, "desc": "墓碑一立：身邊隊友受傷佢分擔，自己慢慢回血。"},
     act=A("墓碑盾", {"sel": "self"}, [F("guard", r=100, pct=0.4, dur=6.0), F("hot", pct=0.03, dur=6.0, tg="self")], AOE(2, 140)),
     pas=[P("low_hp", [F("shield", pct=0.3, dur=6.0, tg="self")], pct=0.4)])
unit("lg_ssg_elite", slot="elite", name="掘墓鬼", title="揸鏟一身泥", sc="黑影", mech=["隱"], rng="近", solid=True,
     trait="揸住把鏟、成身濕泥；由地底鑽出嚟搵施法嗰個，殘咗就直接收落土。",
     say=["呢個位唔錯，啱晒埋你。", "這個位置不錯，正好埋你。"],
     skill={"name": "鑽地收屍", "kind": "hit", "mult": 1.1, "desc": "由地底鑽去施法者身邊，殘血嘅一鏟收落土。"},
     act=A("鑽地收屍", {"sel": "caster"}, [F("dash", to="target", dist=280), DMG(1.1), F("banish", hp_pct=0.2)]),
     pas=[P("start", [F("stealth", dur=3.0, tg="self")])])
unit("lg_ssg_boss", slot="boss", name="食屍鬼母", title="指甲長過手臂", sc="鬼臉", mech=["召喚", "再生"], rng="近", solid=True,
     trait="高大瘦長、披破壽衣、長髮、指甲極長；一聲尖叫，地底就爬出幾隻細食屍鬼。",
     say=["仔仔，開餐喇。", "孩子們，開飯了。"],
     skill={"name": "長爪撕", "kind": "aoe", "mult": 0.8, "drain": 0.2, "desc": "長爪一路撕過三個敵人，邊撕邊吸血。"},
     act=A("長爪撕", NEAR(shape="chain", n=3, falloff=0.85), [DMG(0.8), F("drain", pct=0.2)], AOE(2, 140)),
     pas=[P("start", [F("summon", k="lg_ssg_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=15.0, name="食屍鬼小兵")])])
unit("lg_ssg_boss2", slot="boss2", name="墳場守夜鬼", title="提燈揹骨棒", sc="燈", mech=["嚇氣光環", "霸體"], rng="近", solid=True,
     trait="提住盞燈、揹住一支巨型骨頭棒；佢守夜，邊個匿埋都照到。",
     say=["夜晚嚟掃墓？我睇住你。", "晚上來掃墓？我盯著你。"],
     skill={"name": "骨頭棒", "kind": "hit", "mult": 1.0, "desc": "骨頭棒連敲兩下，燈一照，匿埋嘅全部現形。"},
     act=A("骨頭棒", NEAR(), [DMG(0.55, hits=2), F("reveal", r=140, dur=5.0)]),
     pas=[P("every", [F("taunt", r=120, dur=2.0)], star=2, t=12.0)])
unit("lg_ssg_king", slot="king", name="萬骨食屍王", title="白骨王座", sc="吹氣", mech=["再生", "召喚", "殼"], rng="近", solid=True,
     trait="極大臃腫，背上長滿乾淨白骨尖刺；一張口噴出毒霧，身邊即刻爬出細食屍鬼。",
     say=["呢度每一舊骨，我都記得係邊個。", "這裡每一根骨頭，我都記得是誰的。"],
     skill={"name": "白骨毒霧", "kind": "aoe", "mult": 0.9, "drain": 0.25, "desc": "白骨刺一掃兼噴毒霧，身邊敵人中毒，佢吸血回復。"},
     act=A("白骨毒霧", NEAR(shape="circle", r=160), [DMG(0.9), F("drain", pct=0.25), F("zone", r=100, dur=5.0, fx=[{"p": "dot", "dps": 0.12, "dur": 2.0, "kind": "poison"}])], AOE(3, 160)),
     pas=[P("start", [F("summon", k="lg_ssg_bing", n=2, hp_pct=0.25, atk_pct=0.35, dur=15.0, name="食屍鬼小兵")]),
          P("every", [F("hot", pct=0.03, dur=5.0, tg="self")], t=10.0)])
