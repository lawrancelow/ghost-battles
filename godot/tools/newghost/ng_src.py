# -*- coding: utf-8 -*-
# [newghost] 新名鬼 26＋牛頭馬面升名鬼＋大魔王 7＋新雜兵 8＋合體技 25＋魔王據點 —— 數據源頭（唯一要手改嘅地方）
# 生成：python3 -I tools/newghost/build_newghost.py   → data/nat/newghost.json（遊戲讀呢個；唔改 core.json／data.json，因為兩個都係網頁版導出，重新導出會蓋走）
# 依據：/home/claude/docs/PLAN.md 第 6 節、FIXES_review1.md（第 12～14 項）、/home/claude/bs/roster.md 第 4、5、7 節、counter.md 第 6.4、7、11.3 節、
#       ability.md 第 2～4 節（ABIL 格式）、counter_tool/roster_data.py（系、嚇法、機制、章、T）
# id：沿用 cdata／soul 線嘅 nw_ 前綴（counter.json、soul.json 已用）；立繪檔名 assets/spr/<id>.webp（art 線交圖，id 同 cdata 一致：nw_*），大魔王 bm_<短名>，雜兵 zd_<短名>
# 台詞：港式粵語原句＋中文；build 時逐句同遊戲所有現有句子比對，唔准重複。

SC = {"吹氣": "breath", "燈": "light", "凍": "cold", "怪聲": "sound", "紙": "paper", "電話": "phone", "鬼臉": "face", "黑影": "shadow"}
# 8 系（counter.md 3.3，同 cdata build_cdata.py SYS 一樣）：(怕①, 怕②, 不怕, 理由…)
SYS = {
    "屍": ("吹氣", "怪聲", "凍", "生人氣：一啖氣噴埋面就亂", "雞啼：雞一啼就要返棺", "屍體本來就凍"),
    "魂": ("燈", "黑影", "吹氣", "遊魂怕光", "以為聻嚟咗（鬼之畏聻）", "飄慣咗"),
    "紙紮": ("燈", "吹氣", "紙", "紙紮怕火", "紙輕，一吹就飛", "自己就係紙"),
    "妖": ("怪聲", "凍", "黑影", "爆竹嚇走山臊", "山精野獸一凍就要冬眠", "山林夜色係主場"),
    "厲": ("電話", "鬼臉", "怪聲", "「公司走唔開」嗰通電話", "笑佢樣衰", "尖叫係佢哋專利"),
    "使": ("紙", "黑影", "鬼臉", "主人嘅契約字條", "以為主人返嚟", "自己最愛扮鬼臉"),
    "官": ("紙", "電話", "燈", "公文、投訴信", "上頭 call", "24 小時開燈返工"),
    "橫": ("凍", "鬼臉", "電話", "停屍間雪櫃", "扮佢死相", "自己就係因為電話死"),
}
TIER_EN = {1: [1.7, 1.25], 2: [2.3, 1.35], 3: [2.9, 1.5]}      # 同 n30_data N30_TIER en 一樣
RNG = {"近": 46, "中": 100, "遠": 150}
STAR = (1.0, 1.05, 1.1, 1.167, 1.25, 1.35)
def M(x): return [round(x * f, 2) for f in STAR]

# ---------------------------------------------------------------------------------------------
# 名鬼：key → dict
#   name／title／trait／lore（中文書面，出處）／say（[粵, 中]）／sys／sc／fear（覆寫：自己嚇法唔可以喺「怕」）／why
#   tier（敵人強度 T1–T3）／pin（凡靈煞王）／ch（出場章）／mech（做敵人時嘅機制）／tags（應對標籤）／rng（近中遠）／role
#   base（[力, 智, 武]，已按 T 縮放）／skill（舊引擎 SKILLS：kind/mult/apply/follow/hits/drain/sap/steal）／act、pas、aura（ABIL）
#   spr（立繪檔名，冇就＝id）／h（畫面高度 CHAR_H）／solid（實體，唔係飄）
# ---------------------------------------------------------------------------------------------
G = {}
def ghost(k, **kw): G[k] = kw

ghost("nw_guihuo", name="鬼火", title="夜班唯一照明", sys="魂", sc="燈", tier=1, pin="凡", ch=1, mech=["飛", "散骨"], tags=["遠", "照", "掃"],
      rng="遠", role="back", base=[25, 60, 55], h=50, solid=False,
      fear=["吹氣", "凍"], why=["怕吹氣：一啖氣吹散團火", "怕凍：落霜火就熄"],
      trait="全村最慳電：夜班冇人肯開燈，佢自己就係燈。",
      lore="民間把墳地夜間飄浮的磷火叫「鬼火」；西晉張華《博物志》：「鬥戰死亡之處，其人馬血積年化為燐。」",
      say=["我照住你行，你行到邊，我燒到邊。", "我幫你照著路，你走到哪裡，我燒到哪裡。"],
      skill={"name": "三點鬼火", "kind": "aoe", "mult": 0.8, "desc": "分出三粒追蹤鬼火，打三個目標，連飛嘅都打得中，仲照出匿埋嘅。"},
      act={"name": "三點鬼火", "tg": {"sel": "flyer", "shape": "chain", "n": 3, "falloff": 0.1},
           "fx": [{"p": "dmg", "mult": M(0.9)}, {"p": "dot", "dps": 0.12, "dur": 4.0, "kind": "fire", "vs_sys": {"紙紮": 2.0}}, {"p": "reveal", "r": 60, "dur": 5.0}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "anti_air", "x": 1.25, "dur": -1, "tg": "self"}]},
           {"tr": "every", "t": 7.0, "star": 2, "fx": [{"p": "reveal", "r": 150, "dur": 3.0, "tg": "self"}]}])

ghost("nw_huli", name="狐妖", title="千年道行，專拆假面", sys="妖", sc="黑影", tier=2, pin="靈", ch=1, mech=["分身"], tags=["遠", "照"],
      rng="中", role="back", base=[56, 106, 81], h=58,
      trait="一眼睇穿邊個扮嘢；開會時最怕佢坐前排。",
      lore="東晉郭璞《玄中記》：「狐五十歲，能變化為婦人；百歲為美女……千歲即與天通，為天狐。」清代蒲松齡《聊齋志異》亦多狐妖故事。",
      say=["千年道行唔係玩嘢，你嗰塊假面，我一眼就睇穿。", "千年道行不是鬧著玩的，你那張假面具，我一眼就看穿。"],
      skill={"name": "狐火照妖", "kind": "aoe", "mult": 0.9, "follow": "down", "desc": "狐火一照，分身、隱身全部現形，假嘅仲要多食一下。"},
      act={"name": "狐火照妖", "tg": {"sel": "far", "shape": "circle", "r": 110},
           "fx": [{"p": "reveal", "r": 110, "dur": 6.0}, {"p": "dmg", "mult": M(1.1), "vs_mech": {"分身": 2.0, "隱": 1.5}}],
           "ai": {"n_in": 2, "r": 110, "wait": 5}},
      pas=[{"tr": "hit_taken", "star": 0, "chance": 0.25, "icd": 8, "fx": [{"p": "stealth", "dur": 2.0, "first_x": 1.4, "tg": "self"}]}])

ghost("nw_bajang", name="Bajang", title="竹筒入面嘅外判", sys="使", sc="鬼臉", tier=2, pin="靈", ch=2, mech=["隱"], tags=["削", "刺"],
      rng="近", role="flank", base=[63, 81, 100], h=50,
      trait="住慣竹筒，派佢去邊都嫌地方大。",
      lore="馬來民間使魔 Bajang：多化成貓或鼬（musang）的樣子，養在竹筒（tabong）裏，由主人差遣去害人；Skeat《Malay Magic》（1900）有記。",
      say=["竹筒窄過劏房，放我出嚟做嘢，我仲要多謝你。", "竹筒比劏房還窄，放我出來做事，我還要謝謝你。"],
      skill={"name": "出筒咬", "kind": "hit", "mult": 1.6, "sap": 25, "desc": "由竹筒竄出，撲去施法嗰個，咬到佢唔記得自己想放乜。"},
      act={"name": "出筒咬", "tg": {"sel": "caster"},
           "fx": [{"p": "dash", "to": "target", "dist": 260}, {"p": "dmg", "mult": M(1.5)}, {"p": "silence", "dur": 2.5}, {"p": "sap", "v": 25}],
           "ai": {"when": "foe_cast", "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "stealth", "dur": 3.0, "first_x": 1.6, "tg": "self"}]}])

ghost("nw_teketeke", name="Teke Teke", title="得半截都跑贏你", sys="厲", sc="怪聲", tier=2, pin="靈", ch=5, mech=["突襲"], tags=["刺", "拉"],
      rng="近", role="flank", base=[56, 75, 113], h=44,
      trait="用手肘爬，比你行路仲快；冇得同佢比賽跑。",
      lore="日本都市傳說「テケテケ」：被列車撞成兩截的女子，用手肘在地上爬行，發出「テケテケ」聲（1970–80 年代流傳）。本作畫成年女子、腰下以煙霧收口。",
      say=["テケテケ……你行得快，我爬得仲快。", "テケテケ……你走得快，我爬得更快。"],
      skill={"name": "テケテケ", "kind": "hit", "mult": 1.8, "apply": "down", "desc": "爬衝血最少嗰個，扯佢落地；佢夠殘就即斬。"},
      act={"name": "テケテケ", "tg": {"sel": "low"},
           "fx": [{"p": "dash", "to": "target", "dist": 300}, {"p": "dmg", "mult": M(1.6)}, {"p": "execute", "hp_pct": 0.3, "x": 2.0}, {"p": "down", "dur": 1.2}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "buff", "stat": "spd", "v": 0.45, "dur": 6.0, "tg": "self"}]},   # FIXES 13：突襲加速（唔係免疫腳軟）
           {"tr": "kill", "star": 2, "icd": 3, "fx": [{"p": "energy", "v": 30, "tg": "self"}]}])

ghost("nw_baimao", name="白毛殭屍", title="唔係老，係凍親", sys="屍", sc="凍", tier=2, pin="靈", ch=3, mech=["霸體", "再生"], tags=["定", "破"],
      rng="近", role="front", base=[113, 31, 88], h=62,
      trait="全身白毛，冬天唔使著衫；夏天要排隊用冷氣。",
      lore="民間殭屍傳說：屍體久停不葬，生出白毛便成「白殭」，再變綠毛、黑毛，越變越兇；港產殭屍片亦常見「白毛殭屍」。",
      say=["我把毛白咗唔係因為老，係凍親。有冇暖水袋？", "我的毛白了不是因為老，是冷到了。有沒有暖水袋？"],
      skill={"name": "白毛掃", "kind": "aoe", "mult": 0.9, "hits": 2, "desc": "雙爪連掃身邊一圈，順手扒甩對方層殼。"},
      act={"name": "白毛掃", "tg": {"sel": "self", "shape": "self_circle", "r": 120},
           "fx": [{"p": "dmg", "mult": M(0.85), "hits": 2}, {"p": "armor_break", "v": 0.3, "dur": 6.0}, {"p": "taunt", "r": 120, "dur": 3.0}],
           "ai": {"n_in": 2, "r": 120, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["fear_aura", "confuse"], "dur": -1, "tg": "self"}]},
           {"tr": "hit_taken", "star": 2, "chance": 0.3, "icd": 6, "fx": [{"p": "shield", "pct": 0.1, "dur": 4.0, "tg": "self"}]}])

ghost("nw_buhuagu", name="不化骨", title="燒唔化、埋唔爛", sys="屍", sc="凍", tier=3, pin="煞", ch=3, mech=["殼", "屍變"], tags=["定", "收"],
      rng="近", role="front", base=[124, 35, 98], h=60,
      trait="骨頭硬過鐵；跌打師傅見到佢都退錢。",
      lore="粵港民間傳說：人死後屍骨久久不化，叫「不化骨」，相傳年深日久會成精作祟，是民間最兇的屍怪之一。",
      say=["燒唔化、埋唔爛，我塊骨硬過你老細把口。", "燒不化、埋不爛，我的骨頭比你老闆的嘴還硬。"],
      skill={"name": "硬骨頭", "kind": "aoe", "mult": 0.8, "apply": "push", "desc": "企定定吸晒啲攻擊，身邊未死透嘅、召喚出嚟嘅，全部打散。"},
      act={"name": "硬骨頭", "tg": {"sel": "self", "shape": "self_circle", "r": 130},
           "fx": [{"p": "taunt", "r": 130, "dur": 4.0}, {"p": "banish", "hp_pct": 0.35}, {"p": "shield", "pct": 0.2, "dur": 5.0, "tg": "self"}],
           "ai": {"n_in": 2, "r": 130, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["fear_aura", "confuse", "flee"], "dur": -1, "tg": "self"}]},
           {"tr": "low_hp", "pct": 0.35, "star": 2, "fx": [{"p": "shield", "pct": 0.25, "dur": 6.0, "tg": "self"}]}])

ghost("nw_daqiang", name="鬼打牆", title="行極都係呢度", sys="妖", sc="黑影", tier=2, pin="靈", ch=3, mech=["迷魂"], tags=["照", "掃"],
      rng="中", role="flank", base=[75, 88, 81], h=58,
      trait="上班行錯路三十年，一直以為係公司搬咗。",
      lore="民間「鬼打牆」說法：夜行時迷失方向，原地兜圈怎樣都走不出去，舊時多說是精怪作弄行人。",
      say=["行啦行啦，行多十個圈，你都係返到我面前。", "走吧走吧，再走十圈，你還是會回到我面前。"],
      skill={"name": "行極都係呢度", "kind": "aoe", "mult": 0.85, "apply": "down", "desc": "範圍內嘅敵人兜圈撞牆，腳步慢落嚟，地上腳印照出匿埋嘅。"},
      act={"name": "行極都係呢度", "tg": {"sel": "near", "shape": "circle", "r": 130},
           "fx": [{"p": "dmg", "mult": M(0.85)}, {"p": "slow", "v": -0.4, "va": -0.2, "dur": 3.0}, {"p": "reveal", "r": 130, "dur": 5.0}],
           "ai": {"n_in": 3, "r": 130, "wait": 5}},
      aura={"star": 0, "r": 100, "side": "foe", "fx": [{"p": "slow", "v": -0.2}]})

ghost("nw_ganshi", name="趕屍匠", title="走失咗條隊嘅帶隊", sys="魂", sc="怪聲", tier=2, pin="靈", ch=3, mech=[], tags=["收", "遠"],
      rng="遠", role="back", base=[50, 106, 88], h=60,
      trait="一路搖鈴一路數人頭；數極都少一個。",
      lore="湘西趕屍傳說：趕屍匠夜裏搖銅鈴、撒紙錢，帶客死異鄉的屍體走山路返鄉，口喊「陰人上路，陽人迴避」；本作第 3 章「走失的趕屍匠」。",
      say=["陰人上路，陽人迴避——講完收工，邊位跟我行？", "陰人上路，陽人迴避——說完收工，哪位跟我走？"],
      skill={"name": "搖鈴收隊", "kind": "aoe", "mult": 0.85, "desc": "銅鈴一響，屍變嘅、召喚嘅全部企定，殘嘅直接收隊。"},
      act={"name": "搖鈴收隊", "tg": {"sel": "far", "shape": "chain", "n": 4, "falloff": 0.12},
           "fx": [{"p": "dmg", "mult": M(0.9)}, {"p": "banish", "hp_pct": 0.4}, {"p": "stun", "dur": 0.8}],
           "ai": {"n_in": 2, "r": 150, "wait": 5}},
      pas=[{"tr": "every", "t": 8.0, "star": 0, "fx": [{"p": "banish", "hp_pct": 0.25, "tg": "all_r", "r": 150}]}])

ghost("nw_huapi", name="畫皮", title="換皮比換衫快", sys="厲", sc="紙", tier=3, pin="煞", ch=3, mech=["分身"], tags=["削", "照"],
      rng="近", role="flank", base=[75, 98, 109], h=60,
      trait="衣櫃入面一件衫都冇，全部係皮。",
      lore="清代蒲松齡《聊齋志異·畫皮》：青面獠牙的厲鬼把人皮鋪在榻上，執彩筆描畫，披上便化作美女。本作造型與老闆的《畫皮》短劇刻意區分。",
      say=["今日着邊塊皮出街好呢？你呢塊幾襯我。", "今天穿哪張皮出門好呢？你這張挺適合我。"],
      skill={"name": "換皮", "kind": "hit", "mult": 1.8, "sap": 20, "desc": "撕低對手塊皮：佢嘅增益同偽裝打回原形，一陣間開唔到口。"},
      act={"name": "換皮", "tg": {"sel": "strong"},
           "fx": [{"p": "dmg", "mult": M(1.6)}, {"p": "dispel", "n": 2}, {"p": "silence", "dur": 2.5}, {"p": "reveal", "r": 120, "dur": 6.0}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "stealth", "dur": 3.0, "first_x": 2.0, "tg": "self"}]},
           {"tr": "attack", "n": 4, "star": 2, "fx": [{"p": "sap", "v": 15}]}])

ghost("nw_ameonna", name="雨女", title="一出門就落雨", sys="厲", sc="凍", tier=2, pin="靈", ch=4, mech=["嚇氣光環"], tags=["遠", "削"],
      rng="遠", role="back", base=[50, 113, 81], h=60,
      trait="村入面晾衫要先問佢今日出唔出門。",
      lore="鳥山石燕《今昔百鬼拾遺》「雨女」：隨雨而至的女妖，所到之處必然下雨。",
      say=["我行到邊度，邊度就落雨，出門記得帶遮。", "我走到哪裡，哪裡就下雨，出門記得帶傘。"],
      skill={"name": "冷雨", "kind": "aoe", "mult": 0.75, "sap": 15, "desc": "喺敵陣落一場冷雨，淋到嘅行慢、嚇氣一直漏。"},
      act={"name": "冷雨", "tg": {"sel": "near", "shape": "circle", "r": 140},
           "fx": [{"p": "zone", "r": 140, "dur": 6.0, "fx": [{"p": "slow", "v": -0.25, "dur": 0.6}, {"p": "sap", "v": 6}]}, {"p": "dmg", "mult": M(0.7)}],
           "ai": {"n_in": 3, "r": 140, "wait": 5}},
      pas=[{"tr": "attack", "n": 3, "star": 0, "fx": [{"p": "sap", "v": 10}]}])

ghost("nw_shejing", name="蛇精", title="脫一層皮又一條好漢", sys="妖", sc="凍", tier=2, pin="靈", ch=4, mech=["再生"], tags=["掃", "回"],
      rng="近", role="front", base=[100, 69, 94], h=58,
      fear=["怪聲", "燈"], why=["怕怪聲：打草驚蛇", "怕燈：蛇怕火光"],
      trait="每年脫一次皮，脫完當自己新入職。",
      lore="民間蛇妖傳說：蛇修煉成精能化人形，最廣為人知的是明代馮夢龍《警世通言·白娘子永鎮雷峰塔》。",
      say=["脫一層皮又係一條好漢，你哋做人就冇呢個福利。", "脫一層皮又是一條好漢，你們做人就沒有這種福利。"],
      skill={"name": "蛇尾橫掃", "kind": "aoe", "mult": 0.9, "drain": 0.3, "desc": "條尾一掃前面一大片，毒入傷口，吸返啲血補自己。"},
      act={"name": "蛇尾橫掃", "tg": {"sel": "near", "shape": "cone", "r": 150, "deg": 120},
           "fx": [{"p": "dmg", "mult": M(0.95)}, {"p": "dot", "dps": 0.1, "dur": 5.0, "kind": "poison"}, {"p": "drain", "pct": 0.3}],
           "ai": {"n_in": 2, "r": 150, "wait": 5}},
      pas=[{"tr": "low_hp", "pct": 0.4, "star": 0, "fx": [{"p": "hot", "pct": 0.03, "dur": 6.0, "tg": "self"}]}])

ghost("nw_tiangou", name="天狗", title="食月光當宵夜", sys="妖", sc="黑影", tier=2, pin="靈", ch=4, mech=["飛"], tags=["遠", "拉"],
      rng="遠", role="back", base=[63, 81, 106], h=58,
      trait="一見月光就流口水；中秋節要鎖住佢。",
      lore="《山海經·西山經》：「有獸焉，其狀如狸而白首，名曰天狗，其音如榴榴，可以禦凶。」民間又有「天狗食月」之說。",
      say=["個月光俾我咬咗一啖，今晚你哋睇唔清我喺邊。", "月亮被我咬了一口，今晚你們看不清我在哪裡。"],
      skill={"name": "天狗食月", "kind": "hit", "mult": 1.6, "apply": "down", "desc": "撲去咬天上飛嗰隻，一口咬落地。"},
      act={"name": "天狗食月", "tg": {"sel": "flyer"},
           "fx": [{"p": "dmg", "mult": M(1.5)}, {"p": "down", "dur": 1.6}, {"p": "slow", "v": -0.3, "dur": 3.0}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "anti_air", "x": 1.3, "dur": -1, "tg": "self"}]},
           {"tr": "kill", "star": 2, "icd": 6, "fx": [{"p": "stealth", "dur": 2.0, "first_x": 1.3, "tg": "self"}]}])

ghost("nw_tisi", name="替死鬼", title="永遠係佢孭鑊", sys="橫", sc="凍", tier=2, pin="靈", ch=4, mech=["突襲"], tags=["拉", "收"],
      rng="近", role="front", base=[106, 44, 88], h=58,
      fear=["鬼臉", "燈"], why=["怕鬼臉：扮佢死相", "怕燈：水底見唔到光"],
      trait="全身濕晒，因為公司每單衰嘢都係佢落水頂。",
      lore="俗語「替死鬼」源自民間水鬼「找替身」傳說：溺死的鬼要拉一個人落水做替身才可投胎，清代紀昀《閱微草堂筆記》亦多記溺鬼求代。",
      say=["冇問題，個鑊我孭，你哋行先。", "沒問題，這個黑鍋我背，你們先走。"],
      skill={"name": "搵替身", "kind": "hit", "mult": 1.5, "apply": "down", "desc": "伸手由後排扯一個落嚟，夠殘嘅即刻拉佢做替身。"},
      act={"name": "搵替身", "tg": {"sel": "back"},
           "fx": [{"p": "pull", "dist": 140}, {"p": "down", "dur": 1.2}, {"p": "dmg", "mult": M(1.3)}, {"p": "banish", "hp_pct": 0.3}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "guard", "r": 80, "pct": 0.3, "cap": 0.05, "dur": -1}]},
           {"tr": "death", "star": 2, "fx": [{"p": "execute", "hp_pct": 1.0, "x": 1.0, "boss_pct": 0.15, "tg": "near"}]}])

ghost("nw_krahang", name="Phi Krahang", title="用簸箕當翼", sys="妖", sc="黑影", tier=2, pin="靈", ch=4, mech=["飛"], tags=["遠", "拉"],
      rng="遠", role="back", base=[69, 75, 100], h=60,
      trait="簸箕當翼、舂米杵當尾，飛得唔靚但係飛得到。",
      lore="泰國民間 Phi Krahang：男鬼，以兩個簸箕作翼、舂米杵作尾，夜裏飛行，常與 Krasue 並提。",
      say=["簸箕當翼都飛得起，你仲有咩藉口唔做嘢？", "簸箕當翅膀都飛得起來，你還有什麼藉口不做事？"],
      skill={"name": "簸箕翼", "kind": "aoe", "mult": 0.9, "apply": "down", "desc": "升空撞向一群飛行敵人，撞中嘅全部跌落地。"},
      act={"name": "簸箕翼", "tg": {"sel": "flyer", "shape": "circle", "r": 100},
           "fx": [{"p": "dmg", "mult": M(1.0), "vs_mech": {"飛": 1.5}}, {"p": "down", "dur": 2.0}],
           "ai": {"n_in": 2, "r": 100, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "anti_air", "x": 1.3, "dur": -1, "tg": "self"}]},
           {"tr": "attack", "n": 3, "star": 2, "fx": [{"p": "dmg", "mult": 0.5, "vs_mech": {"飛": 2.0}}]}])

ghost("nw_kapre", name="Kapre", title="樹頂食大煙", sys="妖", sc="吹氣", tier=3, pin="煞", ch=4, mech=["隱", "霸體"], tags=["定", "掃"],
      rng="近", role="front", base=[124, 35, 92], h=70,
      trait="成日坐喺樹頂食煙斗，叫佢落嚟要等佢食完。",
      lore="菲律賓民間 Kapre：住在大樹上、渾身黑毛的高大巨怪，愛抽大煙（本作畫成煙斗冒煙，不畫任何品牌）。",
      say=["坐低食口煙先，打交唔使咁趕。", "先坐下抽口煙，打架不用這麼趕。"],
      skill={"name": "大煙圈", "kind": "aoe", "mult": 0.9, "desc": "噴一個大煙圈罩住隊友，入面嘅唔怕迷魂；外面嘅敵人食煙食到咳。"},
      act={"name": "大煙圈", "tg": {"sel": "self", "shape": "self_circle", "r": 150},
           "fx": [{"p": "dmg", "mult": M(0.85)}, {"p": "slow", "v": -0.2, "dur": 3.0}, {"p": "immune", "tags": ["confuse", "fear_aura"], "dur": 6.0, "tg": "allies", "r": 150}],
           "ai": {"n_in": 3, "r": 150, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["down", "push"], "dur": -1, "tg": "self"}]}])

ghost("nw_honeonna", name="骨女", title="提燈夜訪嘅白骨", sys="屍", sc="燈", tier=2, pin="靈", ch=5, mech=["隱"], tags=["遠", "照"],
      rng="遠", role="back", base=[56, 106, 88], h=60,
      trait="夜晚提燈巡村，順手幫大家熄冷氣。",
      lore="鳥山石燕《今昔畫圖續百鬼》「骨女」，取材自怪談《牡丹燈籠》：女子死後化成白骨，每夜提牡丹燈籠來訪舊情人。",
      say=["提住盞燈行咗幾百年，照到你，算你好彩。", "提著這盞燈走了幾百年，照到你，算你好運。"],
      skill={"name": "牡丹燈籠", "kind": "hit", "mult": 1.5, "desc": "燈籠一舉，照住後排一隻打，佢之後食多兩成傷害。"},
      act={"name": "牡丹燈籠", "tg": {"sel": "far"},
           "fx": [{"p": "dmg", "mult": M(1.3)}, {"p": "reveal", "r": 160, "dur": 8.0}, {"p": "mark", "v": 0.2, "dur": 6.0}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "every", "t": 8.0, "star": 0, "fx": [{"p": "reveal", "r": 120, "dur": 3.0, "tg": "self"}]}])

ghost("nw_mummy", name="木乃伊", title="繃帶三千年未拆線", sys="屍", sc="凍", tier=3, pin="煞", ch=5, mech=["殼", "屍變"], tags=["收", "定"],
      rng="近", role="front", base=[115, 40, 98], h=62,
      trait="舊戲院怪獸片出身，行路一跛一跛，係因為繃帶太緊。",
      lore="古埃及以香料、麻布處理遺體的木乃伊；本作取舊戲院怪獸片裏「紮滿繃帶、一跛一跛」的形象。",
      say=["紮咗三千年繃帶都未拆線，你哋醫院排期真係唔得。", "包了三千年繃帶都還沒拆線，你們醫院排期真的不行。"],
      skill={"name": "繃帶纏", "kind": "aoe", "mult": 0.8, "apply": "down", "desc": "甩出繃帶紮住身邊一圈，紮到郁唔到，殘嘅順手打包收走。"},
      act={"name": "繃帶纏", "tg": {"sel": "near", "shape": "circle", "r": 100},
           "fx": [{"p": "dmg", "mult": M(0.8)}, {"p": "stun", "dur": 1.4}, {"p": "banish", "hp_pct": 0.35}],
           "ai": {"n_in": 2, "r": 100, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["fear_aura", "flee"], "dur": -1, "tg": "self"}]},
           {"tr": "ally_down", "star": 2, "icd": 10, "fx": [{"p": "shield", "pct": 0.15, "dur": 5.0, "tg": "self"}]}])

ghost("nw_zzphone", name="紙紮手機", title="得一格電都打得通", sys="紙紮", sc="電話", tier=2, pin="靈", ch=5, mech=["隱"], tags=["遠", "削"],
      rng="遠", role="back", base=[44, 113, 75], h=46,
      trait="清明燒落嚟，冇月費、冇合約，就係訊號時有時冇。",
      lore="港式紙紮祭品：清明、拜山時燒給先人的紙紮手機（本作不寫任何品牌）；第 2 章媽媽燒落嚟的，就是這一部。",
      say=["一格電都夠我打爆你部機，邊個未覆訊息？", "一格電就夠我打爆你的手機，誰還沒回訊息？"],
      skill={"name": "奪命 call", "kind": "aoe", "mult": 0.7, "sap": 20, "desc": "一連打幾個電話過去，接到嘅成個呆咗，技能放唔出。"},
      act={"name": "奪命 call", "tg": {"sel": "caster", "shape": "chain", "n": 4, "falloff": 0.15},
           "fx": [{"p": "dmg", "mult": M(0.7)}, {"p": "silence", "dur": 2.0}, {"p": "sap", "v": 20}],
           "ai": {"when": "foe_cast", "wait": 5}},
      pas=[{"tr": "attack", "n": 3, "star": 0, "fx": [{"p": "interrupt"}]}])

ghost("nw_zzcar", name="紙紮跑車", title="開大燈都要守交通規則", sys="紙紮", sc="燈", tier=2, pin="靈", ch=5, mech=["突襲"], tags=["破", "掃", "照"],
      rng="近", role="flank", base=[81, 56, 100], h=48,
      fear=["吹氣", "凍"], why=["怕吹氣：紙車一吹就反", "怕凍：落霜紙會濕"],
      trait="紙紮嘅，冇牌、冇油、冇保險，最快係落斜。",
      lore="港式紙紮祭品：燒給先人代步的紙紮車（本作不畫真實車款）；第 5 章媽媽燒落嚟的「紙紮跑車」。",
      say=["紙紮嘅都要守交通規則，不過今晚我開大燈。", "紙紮的也要守交通規則，不過今晚我開遠光燈。"],
      skill={"name": "大燈衝", "kind": "aoe", "mult": 0.9, "hits": 2, "apply": "push", "desc": "開大燈直線衝過敵陣，撞兩下、照晒匿埋嘅。"},
      act={"name": "大燈衝", "tg": {"sel": "near", "shape": "line", "len": 260, "w": 50},
           "fx": [{"p": "dmg", "mult": M(0.9), "hits": 2}, {"p": "push", "dist": 40}, {"p": "reveal", "r": 60, "dur": 5.0}],
           "ai": {"n_in": 2, "r": 130, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "buff", "stat": "spd", "v": 0.3, "dur": 5.0, "tg": "self"}]}])

ghost("nw_kuaidi", name="陰司快遞員", title="簽收咗就唔退貨", sys="使", sc="電話", tier=2, pin="靈", ch=5, mech=["突襲"], tags=["遠", "刺"],
      rng="遠", role="back", base=[63, 81, 106], h=58,
      trait="陽間燒落嚟嘅嘢全部經佢手；包裹燒到變灰都照派。",
      lore="本作原創（STORY_BIBLE 支線角色）：地府集團物流部，負責把陽間家屬燒落嚟的紙紮、衣物送到收件鬼手上。",
      say=["簽收咗就唔退貨，派漏咗我自己孭。", "簽收了就不退貨，漏派了我自己負責。"],
      skill={"name": "準時派件", "kind": "hit", "mult": 1.8, "desc": "隔空掟件包裹去後排，對手夠殘就一擊送佢上路。"},
      act={"name": "準時派件", "tg": {"sel": "mech:召喚"},
           "fx": [{"p": "dmg", "mult": M(1.6)}, {"p": "execute", "hp_pct": 0.25, "x": 2.0}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "kill", "star": 0, "icd": 3, "fx": [{"p": "energy", "v": 25, "tg": "self"}]}])

ghost("nw_zzhouse", name="紙紮大屋", title="三層半連天台", sys="紙紮", sc="紙", tier=3, pin="煞", ch=6, mech=["殼", "召喚"], tags=["定", "破"],
      rng="近", role="front", base=[124, 46, 86], h=66,
      trait="有樓收租都唔使做，可惜業權喺陽間。",
      lore="港式紙紮祭品：燒給先人的紙紮大屋（洋樓、別墅），連傭人、汽車、家電一齊燒落去。",
      say=["三層半連天台，燒落嚟冇按揭，夠晒威。", "三層半加天台，燒下來沒有房貸，夠威風。"],
      skill={"name": "加建", "kind": "aoe", "mult": 0.6, "hits": 3, "desc": "就地加建一層：身邊敵人俾磚頭掟三下兼拆殼，隊友有瓦遮頭。"},
      act={"name": "加建", "tg": {"sel": "self", "shape": "self_circle", "r": 130},
           "fx": [{"p": "dmg", "mult": M(0.55), "hits": 3}, {"p": "armor_break", "v": 0.35, "dur": 6.0}, {"p": "immune", "tags": ["fear_aura"], "dur": 6.0, "tg": "allies", "r": 160}],
           "ai": {"n_in": 2, "r": 130, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "shield", "pct": 0.25, "dur": 12.0, "tg": "self"}]}])

ghost("nw_shenpi", name="陰司審批官", title="填錯一格打回頭", sys="官", sc="紙", tier=3, pin="煞", ch=6, mech=["嚇氣光環"], tags=["收", "照"],
      rng="中", role="back", base=[69, 115, 92], h=62,
      fear=["電話", "鬼臉"], why=["怕電話：上頭 call", "怕鬼臉：當面笑佢官腔"],
      trait="一枝筆、一個印，批唔批全睇佢心情。",
      lore="民間地府傳說裏掌簿冊、審案的文官；本作把地府寫成公司，這個位叫「集團審批部・陰司審批官」，只寫成公務員，不寫成神。",
      say=["表格填錯一格，打回頭重新排隊，冇得傾。", "表格填錯一格，退回去重新排隊，沒得商量。"],
      skill={"name": "唔批", "kind": "aoe", "mult": 0.8, "desc": "大印一蓋：召喚出嚟嘅、屍變返生嘅，一律「唔批」；匿埋嘅即刻現形。"},
      act={"name": "唔批", "tg": {"sel": "near", "shape": "circle", "r": 130},
           "fx": [{"p": "dmg", "mult": M(0.8)}, {"p": "banish", "hp_pct": 0.4}, {"p": "reveal", "r": 130, "dur": 6.0}, {"p": "silence", "dur": 1.2}],
           "ai": {"n_in": 2, "r": 130, "wait": 5}},
      pas=[{"tr": "every", "t": 12.0, "star": 0, "fx": [{"p": "dispel", "n": 1, "tg": "all_r", "r": 160}]}])

ghost("nw_toutai", name="投胎辦事處職員", title="前面仲有八百萬人", sys="官", sc="紙", tier=2, pin="靈", ch=6, mech=["召喚"], tags=["削", "回"],
      rng="中", role="back", base=[56, 113, 69], h=58,
      fear=["電話", "怪聲"], why=["怕電話：上頭 call", "怕怪聲：輪候區嘈到佢收工"],
      trait="派籌、蓋印、叫號，一做三百年冇升職。",
      lore="本作原創（STORY_BIBLE 支線角色）：地府「投胎辦事處」的櫃位職員，投胎要攞籌、填表、輪候。",
      say=["攞籌先，前面仲有八百萬人，你慢慢等。", "先拿號碼牌，前面還有八百萬人，你慢慢等。"],
      skill={"name": "攞籌", "kind": "heal", "mult": 0.15, "sap": 20, "desc": "派籌叫號：隊友回血；對面嚇氣俾佢叫到冇晒耐性。"},
      act={"name": "攞籌", "tg": {"sel": "near", "shape": "circle", "r": 150},
           "fx": [{"p": "sap", "v": 25}, {"p": "slow", "v": -0.15, "dur": 3.0}, {"p": "heal", "pct": 0.15, "tg": "allies", "r": 220}],
           "ai": {"ally_hp": 0.6, "wait": 5}},
      pas=[{"tr": "every", "t": 10.0, "star": 0, "fx": [{"p": "hot", "pct": 0.02, "dur": 5.0, "tg": "ally_low"}]}])

ghost("nw_yeleng_guard", name="夜冷村保安", title="未登記一律企定", sys="使", sc="鬼臉", tier=2, pin="靈", ch=6, mech=["殼"], tags=["定", "拉"],
      rng="近", role="front", base=[113, 38, 81], h=60,
      trait="夜冷村閘口一守就幾十年；連 Bryan 村長都要出示證件。",
      lore="本作原創（STORY_BIBLE 夜冷村員工①）：隔籬夜冷村的閘口保安，最緊要係「登記」。",
      say=["登記咗未？未登記嘅，一律喺閘口企定定。", "登記了沒有？沒登記的，一律在閘口站好。"],
      skill={"name": "截停", "kind": "aoe", "mult": 0.7, "apply": "down", "desc": "吹雞截停：身邊敵人全部要佢登記，衝埋嚟嘅即刻腳軟。"},
      act={"name": "截停", "tg": {"sel": "self", "shape": "self_circle", "r": 140},
           "fx": [{"p": "taunt", "r": 140, "dur": 4.0}, {"p": "down", "dur": 1.2}, {"p": "immune", "tags": ["confuse", "fear_aura"], "dur": 6.0, "tg": "self"}],
           "ai": {"n_in": 2, "r": 140, "wait": 5}},
      pas=[{"tr": "hit_taken", "star": 0, "chance": 0.3, "icd": 5, "fx": [{"p": "push", "dist": 40, "tg": "attacker"}]}])

ghost("nw_yeleng_sales", name="夜冷村推銷員", title="阻你一分鐘", sys="使", sc="電話", tier=2, pin="靈", ch=6, mech=["召喚"], tags=["遠", "削"],
      rng="遠", role="back", base=[50, 106, 88], h=58,
      trait="一開口就停唔到；講到對手唔記得自己想做乜。",
      lore="本作原創（STORY_BIBLE 夜冷村員工②）：夜冷村的推銷員，專向新鬼推銷墓地、紙紮套餐。",
      say=["先生，阻你一分鐘：呢個墓地套餐買一送一，限今晚。", "先生，耽誤你一分鐘：這個墓地套餐買一送一，限今晚。"],
      skill={"name": "阻你一分鐘", "kind": "hit", "mult": 1.0, "sap": 30, "desc": "纏住最惡嗰個推銷，佢三秒內乜技能都放唔出。"},
      act={"name": "阻你一分鐘", "tg": {"sel": "strong"},
           "fx": [{"p": "dmg", "mult": M(0.8)}, {"p": "silence", "dur": 3.0}, {"p": "sap", "v": 30}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "attack", "n": 4, "star": 0, "fx": [{"p": "slow", "v": -0.2, "va": -0.2, "dur": 3.0}]}])

ghost("nw_dullahan", name="Dullahan", title="手捧頭嘅速遞員", sys="妖", sc="黑影", tier=3, pin="煞", ch=6, mech=["突襲", "霸體"], tags=["刺", "破"],
      rng="近", role="flank", base=[92, 63, 115], h=64,
      trait="個頭喺手，視野最闊；戴頸巾要另外買。",
      lore="愛爾蘭民間無頭騎士 Dullahan：手捧自己的頭、以人的脊骨作鞭；Thomas Crofton Croker《Fairy Legends and Traditions of the South of Ireland》（1828）有記。",
      say=["我手上個頭啱啱叫咗你個名，你自己小心。", "我手上的頭剛剛叫了你的名字，你自己小心。"],
      skill={"name": "點名", "kind": "hit", "mult": 1.9, "hits": 2, "desc": "叫出最強嗰個嘅名，脊骨鞭連抽兩下，破甲兼斬殺。"},
      act={"name": "點名", "tg": {"sel": "strong"},
           "fx": [{"p": "mark", "v": 0.25, "dur": 8.0}, {"p": "dmg", "mult": M(1.0), "hits": 2}, {"p": "armor_break", "v": 0.3, "dur": 6.0}, {"p": "execute", "hp_pct": 0.4, "x": 1.8}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "attack", "n": 4, "star": 0, "fx": [{"p": "dmg", "mult": 0.6}, {"p": "push", "dist": 30}]}])

# 牛頭馬面升名鬼（現有 SKILLS「牛角頂」「馬蹄踏」、現有敵人圖 niutou／mamian；ABIL 由 cdata 線寫，呢度只補 GHOSTS 同其餘數據）
ghost("niutou", name="牛頭", title="陰間入職處・攞籌組", sys="官", sc="燈", tier=2, pin="靈", ch=6, mech=["殼"], tags=["照", "定", "收"],
      rng="近", role="front", base=[113, 38, 88], h=66, spr="niutou", keep_skill=True,
      trait="喺地府大堂派籌八百年，未搵到個開始；打尖嘅一律頂出去。",
      lore="民間地府傳說的鬼卒「牛頭」，與馬面合稱「牛頭馬面」，負責押解亡魂；本作寫成地府集團大堂職員。",
      say=["鬼差開工，冇預約一律排隊，打尖嘅我頂佢出去。", "鬼差上班，沒預約一律排隊，插隊的我頂他出去。"])
ghost("mamian", name="馬面", title="陰間入職處・審核組", sys="官", sc="燈", tier=2, pin="靈", ch=6, mech=["突襲"], tags=["照", "刺"],
      rng="近", role="flank", base=[81, 75, 100], h=66, spr="mamian", keep_skill=True,
      trait="審新鬼審咗八百年；聽到「打工」兩個字就即刻合埋本簿。",
      lore="民間地府傳說的鬼卒「馬面」，與牛頭合稱「牛頭馬面」，負責押解亡魂；序章就是他審核阿福入職。",
      say=["名單上有你個名，跑得幾快都冇用，我四隻蹄。", "名單上有你的名字，跑多快都沒用，我有四隻蹄。"])

# ---------------------------------------------------------------------------------------------
# 大魔王（不可招降；掉散魂）：ch＝魔王據點喺邊關（0 起）；shuten：六隻章魔王全部打低之後喺第 1 關魔王據點出現
# ---------------------------------------------------------------------------------------------
B = {}
def boss(k, **kw): B[k] = kw
boss("bm_taotie", name="饕餮", title="食極都唔飽", sys="妖", sc="黑影", ch=0, mech=["再生", "召喚", "霸體"], en=[3.2, 1.35], h=96,
     lore="《左傳·文公十八年》：「縉雲氏有不才子，貪于飲食，冒于貨賄……天下之民以比三凶，謂之饕餮。」第 1 章「餓」的盡頭：餓鬼王都係被佢餓壞的員工。",
     say=["你哋村啲包，我一啖就食晒；連個蒸籠都唔留畀你。", "你們村的包子，我一口就吃光；連蒸籠都不留給你。"],
     act={"name": "吞天", "tg": {"sel": "near", "shape": "cone", "r": 170, "deg": 100},
          "fx": [{"p": "dmg", "mult": 1.6}, {"p": "drain", "pct": 0.4}, {"p": "pull", "dist": 60}], "ai": {"n_in": 2, "r": 170, "wait": 6}},
     pas=[{"tr": "every", "t": 9.0, "fx": [{"p": "summon", "k": "egui", "n": 2, "hp_pct": 0.5, "atk_pct": 0.6, "dur": 20}]},
          {"tr": "low_hp", "pct": 0.4, "fx": [{"p": "buff", "stat": "atk", "v": 0.4, "dur": -1, "tg": "self"}]}],
     drop={"first": 30, "win": 6})
boss("bm_jembalang", name="Jembalang", title="甘榜地底嘅大佬", sys="妖", sc="黑影", ch=1, mech=["隱", "分身", "突襲"], en=[3.5, 1.45], h=90,
     lore="馬來民間的地靈 Jembalang（土地鬼），動土、開墾冒犯它就會作祟；Skeat《Malay Magic》（1900）有記。原擬 Orang Minyak，因其傳說核心涉性侵犯，已換掉。",
     say=["你喺我頭頂起樓，有冇問過我？", "你在我頭頂上蓋房子，有沒有問過我？"],
     act={"name": "地底伸手", "tg": {"sel": "back"},
          "fx": [{"p": "dash", "to": "target", "dist": 400}, {"p": "dmg", "mult": 1.8}, {"p": "stun", "dur": 1.2}], "ai": {"when": "asap"}},
     pas=[{"tr": "every", "t": 10.0, "fx": [{"p": "stealth", "dur": 3.0, "first_x": 1.6, "tg": "self"}]},
          {"tr": "low_hp", "pct": 0.5, "fx": [{"p": "summon", "k": "zd_shanjing", "n": 2, "hp_pct": 0.35, "atk_pct": 0.5, "dur": 15, "clone": True}]}],
     drop={"first": 30, "win": 6})
boss("bm_hou", name="犼", title="殭屍分級嘅頂", sys="屍", sc="凍", ch=2, mech=["屍變", "殼", "霸體"], en=[3.9, 1.5], h=96,
     lore="民間殭屍傳說：殭屍再變為旱魃，旱魃再變為「犼」，是屍怪的最高一級；明代陳繼儒《偃曝談餘》亦記東海有獸名犼，能與龍鬥。（出處待美術出圖前再核對原文）",
     say=["老殭得七品，我係一品；見到我，要跪低跳。", "老殭只是七品，我是一品；見到我，要跪著跳。"],
     act={"name": "屍吼", "tg": {"sel": "self", "shape": "self_circle", "r": 170},
          "fx": [{"p": "dmg", "mult": 1.3}, {"p": "flee", "dur": 1.5}, {"p": "taunt", "r": 170, "dur": 3.0}], "ai": {"n_in": 3, "r": 170, "wait": 6}},
     pas=[{"tr": "start", "fx": [{"p": "shield", "pct": 0.35, "dur": -1, "tg": "self"}]},
          {"tr": "death", "fx": [{"p": "revive", "pct": 0.5, "delay": 4.0, "n": 1}]}],
     drop={"first": 32, "win": 7})
boss("bm_langsuir", name="Langsuir", title="指甲長過合約", sys="厲", sc="怪聲", ch=3, mech=["飛", "嚇氣光環", "再生"], en=[4.2, 1.55], h=92,
     lore="馬來民間 Langsuir：產後而死的女子化成的飛行女鬼，指甲極長，是 Pontianak 傳說的源頭；Skeat《Malay Magic》（1900）有記。",
     say=["香蕉樹下嗰個係我後輩；佢學嘢，都係由我度學。", "香蕉樹下那個是我晚輩；她學東西，都是從我這裡學。"],
     act={"name": "夜梟撲", "tg": {"sel": "back", "shape": "circle", "r": 110},
          "fx": [{"p": "dmg", "mult": 1.5}, {"p": "dot", "dps": 0.12, "dur": 5.0, "kind": "bleed"}, {"p": "sap", "v": 25}], "ai": {"when": "asap"}},
     pas=[{"tr": "every", "t": 1.0, "fx": [{"p": "heal", "pct": 0.012, "tg": "self"}]}],
     aura={"r": 160, "side": "foe", "fx": [{"p": "buff", "stat": "energy", "v": -0.5}]},
     drop={"first": 34, "win": 7})
boss("bm_krasue", name="Krasue", title="會飛嘅夜光頭", sys="厲", sc="鬼臉", ch=4, mech=["飛", "反傷", "散骨"], en=[4.6, 1.6], h=90,
     fear=["電話", "燈"], why=["怕電話：「公司走唔開」嗰通電話", "怕燈：天光就要返身"],
     lore="泰國、柬埔寨民間 Krasue：夜間只得頭顱連着發光的長尾飛出覓食的女鬼，與第 5 章 Penanggal 同類而更兇（本作不畫內臟，頸下畫成發光燈籠尾）。",
     say=["你哋嗰個 Penanggal 要浸醋？我唔使，我自己發光。", "你們那個 Penanggal 要泡醋？我不用，我自己會發光。"],
     act={"name": "夜光掃", "tg": {"sel": "near", "shape": "line", "len": 280, "w": 60},
          "fx": [{"p": "dmg", "mult": 1.4, "hits": 2}, {"p": "slow", "v": -0.3, "dur": 3.0}], "ai": {"n_in": 2, "r": 140, "wait": 6}},
     pas=[{"tr": "death", "fx": [{"p": "summon", "k": "zd_bone", "n": 3, "hp_pct": 0.25, "atk_pct": 0.5, "dur": -1, "split": True}]}],
     drop={"first": 36, "win": 8})
boss("bm_pang", name="龐總", title="地府集團區域經理", sys="官", sc="紙", ch=5, mech=["分身", "反傷", "召喚"], en=[5.0, 1.65], h=70, spr="bm_pang",
     fear=["電話", "凍"], why=["怕電話：董事局一 call 就腳軟", "怕凍：「凍結預算」四個字"],
     lore="本作原創（STORY_BIBLE 人物卡）：地府集團區域經理、阿福直屬上司；口頭禪「我哋係一個大家庭」，絕對唔會認錯，所以永遠唔會投降。立繪用老闆原有圖（未定之前用暫代圖）。",
     say=["我哋係一個大家庭；所以今晚，你哋全家一齊 OT。", "我們是一個大家庭；所以今晚，你們全家一起加班。"],
     act={"name": "甩鍋", "tg": {"sel": "strong"},
          "fx": [{"p": "dmg", "mult": 1.7}, {"p": "mark", "v": 0.3, "dur": 8.0}, {"p": "silence", "dur": 2.0}], "ai": {"when": "asap"}},
     pas=[{"tr": "start", "fx": [{"p": "summon", "k": "zd_paotui", "n": 2, "hp_pct": 0.4, "atk_pct": 0.5, "dur": -1, "clone": True}]},
          {"tr": "every", "t": 10.0, "fx": [{"p": "summon", "k": "zd_paotui", "n": 1, "hp_pct": 0.4, "atk_pct": 0.5, "dur": 15}]}],
     drop={"first": 40, "win": 8})
boss("bm_shuten", name="酒吞童子", title="飲完酒就嚟鬧事", sys="妖", sc="黑影", ch=0, hidden=True, mech=["霸體", "再生", "嚇氣光環"], en=[5.4, 1.75], h=98,
     lore="日本大江山「酒吞童子」傳說（《御伽草子》等）：嗜酒的鬼王，被源賴光一行灌醉後討伐。六隻章魔王全部打低之後，佢會喺第 1 關魔王據點出現。",
     say=["你哋村最出名係包？我淨係飲酒，唔食包。", "你們村最出名的是包子？我只喝酒，不吃包子。"],
     act={"name": "醉拳亂打", "tg": {"sel": "near", "shape": "circle", "r": 150},
          "fx": [{"p": "dmg", "mult": 1.3, "hits": 3}, {"p": "push", "dist": 50}], "ai": {"n_in": 2, "r": 150, "wait": 6}},
     pas=[{"tr": "every", "t": 1.0, "fx": [{"p": "heal", "pct": 0.01, "tg": "self"}]},
          {"tr": "low_hp", "pct": 0.3, "fx": [{"p": "buff", "stat": "aspd", "v": 0.5, "dur": -1, "tg": "self"}]}],
     aura={"r": 150, "side": "foe", "fx": [{"p": "buff", "stat": "energy", "v": -0.5}]},
     drop={"first": 50, "win": 10})
BOSS_CAMP = ["bm_taotie", "bm_jembalang", "bm_hou", "bm_langsuir", "bm_krasue", "bm_pang"]   # 每關一個（第 4 圈）
HIDDEN = {"bm_shuten": {"c": 0, "after": BOSS_CAMP}}

# ---------------------------------------------------------------------------------------------
# 新雜兵 8（counter.md 6.4；ENEMY_T [血倍, 攻倍, 名]；mech＝敵人機制；quirk＝雜兵自己嘅小習性，亦用 trigger＋fx 寫）
# ---------------------------------------------------------------------------------------------
F = {}
def fod(k, **kw): F[k] = kw
fod("zd_bone", name="骷髏兵", sys="屍", sc="凍", mech=["散骨"], en=[1.1, 1.15], rng="melee", h=50,
    desc="亂葬崗嘅散骨頭，打散咗會再砌返幾隻細嘅。", quirk=[])
fod("zd_zhima", name="紙馬", sys="紙紮", sc="紙", mech=["突襲"], en=[0.9, 1.4], rng="melee", h=48,
    desc="燒落嚟冇人騎嘅紙馬，一開打就衝去後排。", quirk=[{"tr": "start", "fx": [{"p": "buff", "stat": "spd", "v": 0.5, "dur": 5.0, "tg": "self"}]}])
fod("zd_shanjing", name="山精", sys="妖", sc="黑影", mech=[], en=[1.4, 1.2], rng="melee", h=50,
    desc="山林細精怪，獨腳跳來跳去；最怕爆竹聲。",
    quirk=[{"tr": "hit_taken", "chance": 1.0, "icd": 4, "by_sc": "sound", "fx": [{"p": "flee", "dur": 1.5, "tg": "self"}]}])
fod("zd_shuihou", name="水猴子", sys="妖", sc="黑影", mech=["突襲"], en=[1.2, 1.35], rng="melee", h=46,
    desc="河邊嘅水怪，由水底撲出嚟扯人落水。", quirk=[{"tr": "start", "fx": [{"p": "pull", "dist": 80, "tg": "back"}]}])
fod("zd_hongyi", name="紅衣女鬼", sys="厲", sc="怪聲", mech=["嚇氣光環"], en=[1.3, 1.4], rng="melee", h=56,
    desc="一身紅衫嘅厲鬼，企近佢連嚇氣都提唔起。", quirk=[])
fod("zd_paotui", name="跑腿鬼", sys="使", sc="鬼臉", mech=["召喚"], en=[1.0, 1.2], rng="melee", h=48,
    desc="幫老細跑腿嘅細鬼，一叫就再叫多幾個同事嚟。", quirk=[])
fod("zd_yinchai", name="陰差", sys="官", sc="燈", mech=["殼"], en=[1.7, 1.3], rng="melee", h=60,
    desc="地府集團前線差人，制服厚過盔甲。", quirk=[])
fod("zd_hengsi", name="橫死新鬼", sys="橫", sc="電話", mech=[], en=[1.1, 1.25], rng="melee", h=54,
    desc="啱啱死、未搞清楚狀況嘅新鬼；未識驚，嚇佢頭幾秒冇用。",
    quirk=[{"tr": "start", "fx": [{"p": "immune", "tags": ["fear", "flee"], "dur": 5.0, "tg": "self"}]}])

# ---------------------------------------------------------------------------------------------
# 合體技 25 組（只用 101 隻入面實際存在嘅鬼；避開 BOND_FEUDS 18 對冤家）
#   kind：strike＝合擊（同場時其中一隻放技能觸發，每場冷卻 30 秒，mult＝舊 COMBOS 寫法）；aura＝同場常駐
#   m：成員；need：要幾多隻同場（一隊最多 3 隻名鬼）；must：一定要有嘅成員
# ---------------------------------------------------------------------------------------------
LINKS = [
 dict(id="wuchang", name="勾魂索命", m=["baiwu", "heiwu"], need=2, kind="strike", mult=3.2, old=True,
      lore="民間黑白無常一對勾魂", desc="黑白無常同時在場：全場嚇彈起後重重摔下；被摔嘅唔可以再起身。",
      fx=[{"p": "dmg", "mult": 3.2, "tg": "all_r", "r": 400}, {"p": "air", "dur": 1.0}, {"p": "banish", "hp_pct": 0.2}]),
 dict(id="jump", name="一跳又一跳", m=["laojiang", "pocong"], need=2, kind="strike", mult=2.4, old=True,
      lore="中國殭屍與馬來 Pocong 都只識跳", desc="老殭與 Pocong 同時在場：一齊跳，全場腳軟。",
      fx=[{"p": "dmg", "mult": 2.4, "tg": "all_r", "r": 400}, {"p": "down", "dur": 1.4}]),
 dict(id="naihe", name="奈何橋", m=["mengpo", "baiwu", "heiwu"], need=2, must=["mengpo"], kind="aura",
      lore="地府傳說：無常押魂過奈何橋，孟婆奉湯", desc="孟婆＋任一無常：孟婆治療 +30%；每押走一隻敵人，全隊回 3% 血。",
      fx=[{"p": "buff", "stat": "heal_out", "v": 0.3, "who": "mengpo"}, {"p": "on_kill_heal", "pct": 0.03}]),
 dict(id="niuma", name="牛頭馬面", m=["niutou", "mamian"], need=2, kind="strike", mult=2.6,
      lore="民間地府鬼卒「牛頭馬面」一對押解亡魂", desc="牛頭頂、馬面踏：前排一行敵人嚇彈起再腳軟。",
      fx=[{"p": "dmg", "mult": 2.6, "tg": "near", "shape": "line", "len": 300, "w": 80}, {"p": "air", "dur": 1.0}, {"p": "down", "dur": 1.4}]),
 dict(id="shenpi", name="排隊審批", m=["nw_shenpi", "nw_toutai"], need=2, kind="aura",
      lore="地府流程：審批完先到投胎輪候（STORY_BIBLE 地府公司化）", desc="審批官＋輪候職員同場：敵人召喚出嚟嘅要排隊，召喚間隔 +50%；我方回血 +15%。",
      fx=[{"p": "foe_summon_cd", "v": 0.5}, {"p": "buff", "stat": "heal_in", "v": 0.15, "tg": "allies"}]),
 dict(id="ganshi", name="湘西趕屍", m=["nw_ganshi", "laojiang"], need=2, kind="strike", mult=2.6,
      lore="湘西趕屍：趕屍匠搖鈴，殭屍跟住跳", desc="趕屍匠搖鈴、老殭跟住跳：直線連跳三下，路上全部嚇彈起，跳過嘅屍變唔再起身。",
      fx=[{"p": "dmg", "mult": 2.6, "tg": "near", "shape": "line", "len": 320, "w": 60}, {"p": "air", "dur": 1.0}, {"p": "banish", "hp_pct": 0.3}]),
 dict(id="jiangshi", name="殭屍分級", m=["laojiang", "nw_baimao", "n30_hanba"], need=2, kind="aura",
      lore="民間殭屍分級：白毛殭屍→旱魃，老殭係七品官殭", desc="任 2 隻殭屍同場：霸體加身（腳軟、嚇退無效），受傷 −10%。",
      fx=[{"p": "immune", "tags": ["down", "push"], "dur": -1, "tg": "members"}, {"p": "buff", "stat": "taken", "v": -0.1, "tg": "members"}]),
 dict(id="bela", name="被遺棄的使魔", m=["toyol", "n30_polong", "n30_pelesit", "n30_hanturaya", "nw_bajang"], need=2, kind="aura",
      lore="馬來民間被主人供養、派遣、轉讓的使魔（Skeat《Malay Magic》1900）", desc="任 2 隻使魔：召喚物、分身時間 +50%；任 3 隻：有隊友倒下，使魔攻擊 +20%（主人冇咗）。",
      fx=[{"p": "buff", "stat": "summon_dur", "v": 0.5, "tg": "members"}], fx3=[{"p": "on_ally_down", "stat": "atk", "v": 0.2, "tg": "members"}]),
 dict(id="feitou", name="飛頭會", m=["penanggal", "n30_rokurokubi"], need=2, kind="aura",
      lore="馬來 Penanggal 夜間飛頭；日本轆轤首亦有頭離身飛出的「拔首」", desc="兩隻同場：攻擊 +20%，被打落地時間減半。",
      fx=[{"p": "buff", "stat": "atk", "v": 0.2, "tg": "members"}, {"p": "buff", "stat": "grounded", "v": -0.5, "tg": "members"}]),
 dict(id="kwaidan", name="小泉八雲怪談", m=["n30_yukionna", "n30_nopperabo", "n30_rokurokubi"], need=2, kind="aura",
      lore="小泉八雲《怪談》（1904）收錄〈雪女〉〈貉〉（無臉鬼）〈轆轤首〉", desc="任 2 隻同場：嚇氣增長 +15%；失神時間 +1 秒。",
      fx=[{"p": "buff", "stat": "energy", "v": 0.15, "tg": "members"}, {"p": "buff", "stat": "daze_dur", "v": 1.0, "tg": "members"}]),
 dict(id="wetplug", name="濕手插插蘇", m=["n30_kappa", "n30_diansi"], need=2, kind="strike", mult=2.8,
      lore="電死鬼死因（濕手插插蘇）×河童潑水", desc="河童潑濕、電死鬼放電：全場連鎖電擊，濕咗嘅傷害 ×2。",
      fx=[{"p": "dmg", "mult": 2.8, "tg": "near", "shape": "chain", "n": 8, "falloff": 0.08}, {"p": "stun", "dur": 0.8}]),
 dict(id="xinjiugui", name="新鬼舊鬼", m=["pg_tuimo", "pg_songding"], need=2, kind="aura",
      lore="六朝志怪兩個「新死鬼被呃」故事：《幽明錄·新死鬼》、《搜神記·宋定伯捉鬼》", desc="兩隻同場：免疫迷魂；開戰嚇氣 +20。",
      fx=[{"p": "immune", "tags": ["confuse", "charm"], "dur": -1, "tg": "members"}, {"p": "energy", "v": 20, "tg": "members", "on": "start"}]),
 dict(id="liaozhai", name="聊齋", m=["nw_huapi", "pg_ji", "nw_huli"], need=2, kind="aura",
      lore="蒲松齡《聊齋志異》：〈畫皮〉、〈章阿端〉（聻）、多篇狐妖故事", desc="任 2 隻同場：對「隱」「分身」「屍變」敵人傷害 +25%。",
      fx=[{"p": "buff", "stat": "vs_mech", "v": 0.25, "mech": ["隱", "分身", "屍變"], "tg": "members"}]),
 dict(id="baigu", name="白骨堆", m=["n30_baigujing", "n30_gashadokuro"], need=2, kind="aura",
      lore="白骨精與餓者髑髏都由白骨化成", desc="兩隻同場：每有一隻敵人倒下，兩隻最大血 +3%（最多 5 層）。",
      fx=[{"p": "on_kill_maxhp", "v": 0.03, "cap": 5, "tg": "members"}]),
 dict(id="wutou", name="無頭會", m=["n30_wutou", "nw_dullahan"], need=2, kind="strike", mult=2.6,
      lore="中國無頭鬼、愛爾蘭無頭騎士都手捧自己的頭", desc="兩個頭一齊滾出去：直線打穿，打中嘅自動被 Dullahan 點名（易傷 25%）。",
      fx=[{"p": "dmg", "mult": 2.6, "tg": "near", "shape": "line", "len": 320, "w": 50}, {"p": "down", "dur": 1.0}, {"p": "mark", "v": 0.25, "dur": 8.0}]),
 dict(id="baosang", name="報喪", m=["n30_banshee", "nw_dullahan"], need=2, kind="aura",
      lore="愛爾蘭兩大報死預兆：Banshee 的哭聲與 Dullahan 的點名", desc="兩隻同場：斬殺線 +15%（血少過 55% 就算數）。",
      fx=[{"p": "buff", "stat": "execute", "v": 0.15, "tg": "members"}]),
 dict(id="minghun", name="冥婚", m=["n30_guixinniang", "nw_zzhouse"], need=2, kind="strike", mult=2.5,
      lore="冥婚習俗要燒紙紮大屋做新房", desc="鬼新娘拋繡球、紙紮大屋開門：一圈敵人過門做我方 3 秒（王無效）。",
      fx=[{"p": "dmg", "mult": 2.5, "tg": "near", "shape": "circle", "r": 140}, {"p": "charm", "dur": 3.0}]),
 dict(id="zhizha", name="媽媽燒落嚟", m=["xiaozhi", "nw_zzphone", "nw_zzcar", "nw_zzhouse"], need=2, kind="aura",
      lore="港式紙紮祭品；本作媽媽燒落嚟嘅傭人、手機、跑車", desc="任 2 件紙紮同場：「怕燈（火）」弱點減半；開戰全隊護盾 8%。",
      fx=[{"p": "buff", "stat": "fear_light", "v": -0.5, "tg": "members"}, {"p": "shield", "pct": 0.08, "dur": 10.0, "tg": "allies", "on": "start"}]),
 dict(id="shanlin", name="菲律賓山林", m=["n30_tikbalang", "nw_kapre"], need=2, kind="aura",
      lore="菲律賓山林精怪：Tikbalang 令旅人迷路，Kapre 住大樹", desc="兩隻同場：全隊閃避 +12%；我方迷路、腳軟效果 +1 秒。",
      fx=[{"p": "buff", "stat": "dodge", "v": 0.12, "tg": "allies"}, {"p": "buff", "stat": "cc_dur", "v": 1.0, "tg": "members"}]),
 dict(id="rushan", name="兜圈迷路", m=["nw_daqiang", "n30_tikbalang"], need=2, kind="strike", mult=2.2,
      lore="民間鬼打牆、菲律賓 Tikbalang 都令夜行人原地兜圈", desc="兩隻一齊整蠱：全場敵人兜圈 2.5 秒（亂行唔出手）。",
      fx=[{"p": "dmg", "mult": 2.2, "tg": "all_r", "r": 400}, {"p": "confuse", "dur": 2.5}]),
 dict(id="dushi", name="昭和都市傳說", m=["n30_kuchisake", "nw_teketeke"], need=2, kind="aura",
      lore="日本昭和年代兩大都市傳說：口裂け女（1979）與テケテケ", desc="兩隻同場：移速 +20%；開戰頭 5 秒，敵人嚇氣唔會漲。",
      fx=[{"p": "buff", "stat": "spd", "v": 0.2, "tg": "members"}, {"p": "sap_lock", "dur": 5.0, "tg": "foes", "on": "start"}]),
 dict(id="tisheng", name="找替身", m=["nw_tisi", "n30_diaosi"], need=2, kind="strike", mult=2.4,
      lore="民間溺鬼、縊鬼都要「找替身」才得投胎（紀昀《閱微草堂筆記》多記）", desc="兩隻一齊搵替身：扯最後排兩隻落前面，吊起 2 秒。",
      fx=[{"p": "dmg", "mult": 2.4, "tg": "back", "n": 2}, {"p": "pull", "dist": 160}, {"p": "stun", "dur": 2.0}]),
 dict(id="xueguo", name="雪國", m=["n30_yukionna", "n30_dongsi"], need=2, kind="strike", mult=2.6,
      lore="凍死鬼死因：去日本睇雪著拖鞋，遇着雪女", desc="雪女呵氣、凍死鬼打乞嗤：全場凍住 1.5 秒，凍住嘅停止回血。",
      fx=[{"p": "dmg", "mult": 2.6, "tg": "all_r", "r": 400}, {"p": "stun", "dur": 1.5}, {"p": "wound", "v": 1.0, "dur": 6.0}]),
 dict(id="denglong", name="牡丹燈夜行", m=["nw_honeonna", "nw_guihuo"], need=2, kind="aura",
      lore="《牡丹燈籠》提燈骨女與墳地燐火：夜行都靠一點鬼光", desc="兩隻同場：每 6 秒照亮身邊 180 範圍（隱身現形）；兩隻攻擊 +10%。",
      fx=[{"p": "reveal_pulse", "t": 6.0, "r": 180, "tg": "members"}, {"p": "buff", "stat": "atk", "v": 0.1, "tg": "members"}]),
 dict(id="yusan", name="落雨收遮", m=["nw_ameonna", "n30_kasaobake"], need=2, kind="strike", mult=2.3,
      lore="鳥山石燕畫中的雨女，與付喪神「唐傘お化け」（舊雨遮成精）", desc="雨女落雨、唐傘妖跳出嚟：一圈敵人淋濕行慢，嚇氣漏走 30。",
      fx=[{"p": "dmg", "mult": 2.3, "tg": "near", "shape": "circle", "r": 160}, {"p": "slow", "v": -0.35, "dur": 4.0}, {"p": "sap", "v": 30}]),
]
