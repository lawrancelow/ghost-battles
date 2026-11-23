# -*- coding: utf-8 -*-
# [roster2] 第二批新名鬼 30 隻（roster.md 後備池；老闆 23:15）＋合體技 5 組 —— 數據源頭（唯一要手改嘅地方）
# 生成：python3 -I tools/newghost/build_newghost2.py   → data/nat/newghost2.json（遊戲讀呢個；第一批 ng_src.py／newghost.json 唔郁）
# 依據：/home/claude/bs/roster.md 第 4（候選、出處）、5（羈絆）、7（紅線）、8.1（建議階）節；counter.md 第 3、4 節（8 系、嚇法、13 機制、10 標籤）
# 系／嚇法：嚇法一律唔喺本系「怕」入面 → 每隻怕兩種、唔怕一種（同 build_cdata.py ENEMY 公式一致）
# 標籤：必須等於 build_cdata.py derive() 由積木推出嚟嘅結果（build_newghost2.py 校驗）；優先補偏少嘅「收」「回」「照」「定」
# camp：據點「雙駐守」（guard2）位置 = (鬼幫名, 圈)；build_cdata.py 掛鈎讀 newghost2.json CAMP2 → counter.json camps[id].guard2
# 台詞：港式粵語原句＋中文；build 時同遊戲所有現有字串（data/**.json、*.gd 字串、第一批）逐句比對，唔准重複。
import importlib.util, os
_spec = importlib.util.spec_from_file_location("ng_src", os.path.join(os.path.dirname(os.path.abspath(__file__)), "ng_src.py"))
_S1 = importlib.util.module_from_spec(_spec); _spec.loader.exec_module(_S1)
SC, SYS, TIER_EN, RNG, M = _S1.SC, _S1.SYS, _S1.TIER_EN, _S1.RNG, _S1.M

G = {}
def ghost(k, **kw): G[k] = kw
def ST(**kw): d = {"p": "stealth", "tg": "self"}; d.update(kw); return d

# ============================== 第 1 關（荒村） ==============================
ghost("nw_guisihknai", name="鬼食泥", title="講咩都冇人聽得明", sys="魂", sc="電話", tier=1, pin="凡", ch=1, mech=[], tags=["掃", "削"],
      rng="中", role="back", base=[30, 65, 45], h=50, solid=False, camp=("餓鬼坑幫", 2),
      trait="開會講足一個鐘，冇一個人聽得明；佢自己都唔明。",
      lore="粵語俗語「講嘢好似鬼食泥」：形容說話含糊不清、令人聽不明白。",
      say=["嗚嚕嗚嚕……我話「多謝收留」呀，你聽唔明咩？", "嗚嚕嗚嚕……我說「謝謝收留」啊，你聽不懂嗎？"],
      skill={"name": "鬼食泥", "kind": "aoe", "mult": 0.6, "sap": 15, "desc": "一啖泥噴過去，身邊敵人一陣間講唔出技能名。"},
      act={"name": "鬼食泥", "tg": {"sel": "near", "shape": "circle", "r": 150},
           "fx": [{"p": "dmg", "mult": M(0.6)}, {"p": "silence", "dur": 2.5}], "ai": {"n_in": 3, "r": 150, "wait": 5}},
      pas=[{"tr": "every", "t": 10.0, "star": 2, "fx": [{"p": "sap", "v": 10, "tg": "all_r", "r": 120}]}])

ghost("nw_nian", name="年獸", title="一年只返一日工", sys="妖", sc="黑影", tier=3, pin="煞", ch=1, mech=["霸體", "殼"], tags=["回", "定"],
      rng="近", role="front", base=[125, 40, 95], h=66, camp=("餓鬼坑幫", 4),
      trait="成年瞓喺海底，除夕先起身返工；最怕人哋燒炮仗、貼紅紙。",
      lore="民間過年傳說：「年」是頭生獨角的猛獸，每到除夕出來害人畜，怕紅色、火光和爆竹聲，於是有貼揮春、燒爆竹「過年」的習俗。此說屬近代流行版本，古籍未見，本作如實註明。",
      say=["一年返一日工，今日就係嗰日，快啲搞掂佢。", "一年只上一天班，今天就是那天，快點搞定他們。"],
      skill={"name": "除夕", "kind": "hit", "mult": 1.2, "desc": "除夕一到全場睇住佢：嘲諷身邊敵人，自己加層厚皮。"},
      act={"name": "除夕", "tg": {"sel": "self"},
           "fx": [{"p": "taunt", "r": 150, "dur": 4.0}, {"p": "shield", "pct": 0.3, "dur": 6.0, "tg": "self"}, {"p": "buff", "stat": "taken", "v": -0.3, "dur": 6.0, "tg": "self"}],
           "ai": {"n_in": 2, "r": 150, "wait": 5}},
      pas=[{"tr": "kill", "star": 0, "icd": 3, "fx": [{"p": "heal", "pct": 0.08, "tg": "self"}]},
           {"tr": "start", "star": 2, "fx": [{"p": "immune", "tags": ["down", "push", "air"], "dur": -1, "tg": "self"}]}])

ghost("nw_wangliang", name="魍魎", title="墳場清潔部", sys="妖", sc="黑影", tier=1, pin="凡", ch=1, mech=["再生"], tags=["回", "收"],
      rng="近", role="flank", base=[50, 40, 55], h=46, camp=("亂葬崗骷髏", 2),
      trait="專執戰場手尾，執完仲要食埋；清潔費從來唔收。",
      lore="《國語·魯語下》：「木石之怪曰夔、蝄蜽。」《周禮·夏官·方相氏》記方相氏入墓壙「毆方良」，鄭玄注「方良，罔兩也」，故民間說魍魎專在墳墓間作怪；後世與魑魅並稱「魑魅魍魎」。",
      say=["打完我嚟執手尾，地下嗰啲我包晒。", "打完我來收拾殘局，地上那些我全包了。"],
      skill={"name": "掘墳", "kind": "hit", "mult": 1.2, "drain": 0.25, "desc": "撲去最殘嗰個，殘到一定程度直接收走，仲補返自己啲血。"},
      act={"name": "掘墳", "tg": {"sel": "low"},
           "fx": [{"p": "dmg", "mult": M(1.2)}, {"p": "banish", "hp_pct": 0.3}, {"p": "drain", "pct": 0.25}], "ai": {"when": "asap"}},
      pas=[{"tr": "kill", "star": 0, "icd": 2, "fx": [{"p": "hot", "pct": 0.03, "dur": 5.0, "tg": "self"}]}])

ghost("nw_zhizhama", name="紙紮馬", title="冇油費嘅坐騎", sys="紙紮", sc="紙", tier=1, pin="凡", ch=1, mech=["突襲"], tags=["拉", "掃"],
      rng="近", role="front", base=[55, 30, 60], h=56, camp=("紙錢陣", 2),
      trait="燒落嚟嗰日就係新車，唔使牌費唔使入油，最怕落雨。",
      lore="民間喪葬「燒紙紮」習俗：以竹篾紮骨、糊上彩紙做成車馬，焚化給先人在陰間代步；粵港一帶至今仍有紙紮舖製作。",
      say=["燒得落嚟就係新車，唔使牌費，唔使入油。", "燒下來就是新車，不用牌照費，不用加油。"],
      skill={"name": "燒馬", "kind": "aoe", "mult": 0.9, "apply": "down", "desc": "兩匹紙馬直線衝過敵陣，撞到嘅全部腳軟。"},
      act={"name": "燒馬", "tg": {"sel": "near", "shape": "line", "len": 300, "w": 60},
           "fx": [{"p": "dmg", "mult": M(0.9)}, {"p": "down", "dur": 1.0}, {"p": "push", "dist": 40}], "ai": {"n_in": 2, "r": 150, "wait": 5}},
      pas=[{"tr": "death", "star": 0, "fx": [{"p": "confuse", "dur": 1.5, "tg": "all_r", "r": 100}]}])

ghost("nw_paakbok", name="拍膊頭鬼", title="夜晚最鍾意同你打招呼", sys="魂", sc="凍", tier=1, pin="凡", ch=1, mech=["突襲"], tags=["破", "收"],
      rng="近", role="flank", base=[45, 45, 60], h=58, solid=False, camp=("荒田橫死組", 2),
      trait="見人就拍膊頭；拍完你一回頭，佢已經唔喺度。",
      lore="民間說法：人頭頂和兩肩各有一盞「陽火」（俗稱「三盞燈」），夜行時被人拍肩或叫名而回頭，肩上的火就會熄，容易撞邪；所以老人家教夜晚唔好隨便拍人膊頭。",
      say=["喂，兄弟。（拍）……咦，你盞燈熄咗喎。", "喂，兄弟。（拍）……咦，你的燈滅了喔。"],
      skill={"name": "拍膊頭", "kind": "hit", "mult": 1.1, "desc": "拍熄對手膊頭盞燈：增益、護盾一齊冇咗，殘嘅直接收走。"},
      act={"name": "拍膊頭", "tg": {"sel": "near"},
           "fx": [{"p": "dmg", "mult": M(1.1)}, {"p": "dispel", "n": 3}, {"p": "shield_break", "pct": 0.6}, {"p": "banish", "hp_pct": 0.3}], "ai": {"when": "asap"}},
      pas=[{"tr": "attack", "n": 3, "star": 0, "fx": [{"p": "stun", "dur": 0.6}]}])

# ============================== 第 2 關（甘榜） ==============================
ghost("nw_harimau", name="Harimau Jadian", title="放工就變老虎", sys="妖", sc="吹氣", tier=3, pin="煞", ch=2, mech=["霸體"], tags=["破", "回"],
      rng="近", role="front", base=[115, 45, 110], h=62, camp=("廢膠廠山精", 3),
      trait="日頭係普通打工仔，一到收工時間就變老虎；老細從來唔敢叫佢 OT。",
      lore="馬來半島民間的「人虎」（harimau jadian，意為「變成的老虎」）：相傳有人能化身為虎；W. W. Skeat《Malay Magic》（1900）有記載。",
      say=["收工時間一到，我就唔係人，係老虎。", "下班時間一到，我就不是人，是老虎。"],
      skill={"name": "變虎", "kind": "hit", "mult": 1.2, "hits": 2, "desc": "變做老虎連抓兩下，抓到流血，自己越打越兇。"},
      act={"name": "變虎", "tg": {"sel": "near"},
           "fx": [{"p": "dmg", "mult": M(1.2), "hits": 2}, {"p": "dot", "dps": 0.1, "dur": 4.0, "kind": "bleed"}, {"p": "buff", "stat": "atk", "v": 0.4, "dur": 10.0, "tg": "self"}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "kill", "star": 0, "icd": 3, "fx": [{"p": "heal", "pct": 0.1, "tg": "self"}]},
           {"tr": "start", "star": 2, "fx": [{"p": "immune", "tags": ["down", "push"], "dur": -1, "tg": "self"}]}])

ghost("nw_banaspati", name="Banaspati", title="倒立行嘅火球", sys="妖", sc="燈", tier=2, pin="靈", ch=2, mech=["散骨"], tags=["遠", "掃", "照"],
      rng="遠", role="back", base=[45, 100, 95], h=50, solid=False, camp=("廢膠廠山精", 2),
      trait="用雙手倒立行路，對腳朝天；行過嘅地方個個以為係放煙花。",
      lore="爪哇民間的「Banaspati」：由火焰形成的鬼怪，用雙手倒立行走，所經之處會起火。",
      say=["我倒住行唔係扮型，係我隻腳真係喺上面。", "我倒立走路不是耍帥，是我的腳真的在上面。"],
      skill={"name": "火球翻筋斗", "kind": "aoe", "mult": 0.9, "desc": "縮做一個火球滾過敵陣，一路燒過去，紙紮嘅燒得特別快。"},
      act={"name": "火球翻筋斗", "tg": {"sel": "near", "shape": "line", "len": 320, "w": 70},
           "fx": [{"p": "dmg", "mult": M(0.9), "vs_sys": {"紙紮": 2.0}}, {"p": "dot", "dps": 0.12, "dur": 4.0, "kind": "fire"}], "ai": {"n_in": 2, "r": 160, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["push", "flee"], "dur": -1, "tg": "self"}]}])

ghost("nw_bonceng", name="Hantu Bonceng", title="搭順風車唔畀錢", sys="魂", sc="凍", tier=1, pin="凡", ch=2, mech=["隱"], tags=["拉", "削"],
      rng="近", role="flank", base=[40, 55, 55], h=54, solid=False, camp=("椰林膠園橫死組", 2),
      trait="深夜專坐人電單車後座；你覺得架車突然重咗，即係佢上咗車。",
      lore="馬來西亞民間傳說「Hantu Bonceng」（bonceng＝搭順風車、坐後座）：深夜騎電單車時，後座忽然多了一個看不見的乘客。",
      say=["車我啦，順路之嘛，我好輕㗎……真㗎。", "載我吧，順路而已，我很輕的……真的。"],
      skill={"name": "搭順風車", "kind": "hit", "mult": 0.9, "apply": "down", "desc": "跳上最勁嗰個背脊坐住：佢行得慢、易受傷、回唔到血。"},
      act={"name": "搭順風車", "tg": {"sel": "strong"},
           "fx": [{"p": "dmg", "mult": M(0.9)}, {"p": "slow", "v": -0.5, "dur": 6.0}, {"p": "mark", "v": 0.2, "dur": 6.0}, {"p": "wound", "v": 0.5, "dur": 6.0}, {"p": "down", "dur": 0.8}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [ST(dur=2.5, first_x=1.3)]}])

ghost("nw_guiamngaan", name="鬼揞眼", title="明明喺你面前", sys="魂", sc="凍", tier=2, pin="靈", ch=2, mech=["隱"], tags=["拉", "削"],
      rng="中", role="flank", base=[60, 100, 80], h=56, solid=False, camp=("竹林賭檔", 2),
      trait="你搵鎖匙搵足半個鐘、其實就喺枱面——嗰陣佢就企喺你後面。",
      lore="粵語民間說法「鬼揞眼」：明明就在眼前的東西卻看不見，舊時人說是有鬼用手掩住了眼睛。",
      say=["你明明望住我，點解會睇唔到？係咪好奇怪？", "你明明看著我，為什麼會看不到？是不是很奇怪？"],
      skill={"name": "揞眼", "kind": "hit", "mult": 1.0, "apply": "down", "desc": "揞住最勁嗰個對手對眼：亂咁行、出手斷咗，仲跌一跤。"},
      act={"name": "揞眼", "tg": {"sel": "strong"},
           "fx": [{"p": "dmg", "mult": M(1.0)}, {"p": "confuse", "dur": 3.0}, {"p": "interrupt"}, {"p": "down", "dur": 0.8}], "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [ST(dur=3.0, first_x=1.3)]}])

# ============================== 第 3 關（古道） ==============================
ghost("nw_bifang", name="畢方", title="一隻腳嘅消防隱患", sys="妖", sc="燈", tier=2, pin="靈", ch=3, mech=["飛"], tags=["遠", "掃", "照"],
      rng="遠", role="back", base=[50, 100, 90], h=58, solid=False, camp=("亂石峽山妖", 2),
      trait="企一隻腳都企得穩；飛到邊度，邊度就要搵消防。",
      lore="《山海經·西山經》：章莪之山「有鳥焉，其狀如鶴，一足，赤文青質而白喙，名曰畢方，其鳴自叫也，見則其邑有譌火」。",
      say=["我企一隻腳都企得穩，你啲陣型就未必。", "我單腳站都站得穩，你們的陣型就不一定了。"],
      skill={"name": "譌火", "kind": "aoe", "mult": 0.85, "desc": "喺敵陣點起怪火，企喺火入面嘅慢慢燒；紙紮嘅燒得特別快。"},
      act={"name": "譌火", "tg": {"sel": "far", "shape": "circle", "r": 120},
           "fx": [{"p": "dmg", "mult": M(0.8), "vs_sys": {"紙紮": 2.0}}, {"p": "zone", "r": 120, "dur": 5.0, "fx": [{"p": "dot", "dps": 0.1, "dur": 1.0, "kind": "fire"}]}],
           "ai": {"n_in": 2, "r": 120, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["down"], "dur": -1, "tg": "self"}]}])

ghost("nw_qiongqi", name="窮奇", title="專咬講道理嗰個", sys="妖", sc="吹氣", tier=3, pin="煞", ch=3, mech=["突襲", "霸體"], tags=["破", "刺", "回"],
      rng="近", role="flank", base=[110, 60, 105], h=64, camp=("亂石峽山妖", 3),
      trait="邊個喺度講道理，佢就撲邊個；吵交嗰陣千祈唔好做最啱嗰個。",
      lore="《山海經·西山經》邽山「有獸焉，其狀如牛，蝟毛，名曰窮奇」；舊題東方朔《神異經·西北荒經》：窮奇「似虎，有翼能飛……聞人鬥，輒食直者；聞人忠信，輒食其鼻」。",
      say=["邊個話自己啱？企出嚟，我先咬佢。", "誰說自己對？站出來，我先咬他。"],
      skill={"name": "食直者", "kind": "hit", "mult": 1.6, "drain": 0.3, "desc": "撲去最勁嗰個，咬穿佢層盾，順便補返自己。"},
      act={"name": "食直者", "tg": {"sel": "strong"},
           "fx": [{"p": "dash", "to": "target", "dist": 260}, {"p": "dmg", "mult": M(1.5)}, {"p": "shield_break", "pct": 1.0}, {"p": "drain", "pct": 0.3}], "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "immune", "tags": ["down", "push"], "dur": -1, "tg": "self"}]},
           {"tr": "kill", "star": 2, "icd": 4, "fx": [{"p": "buff", "stat": "atk", "v": 0.1, "dur": 8.0, "tg": "self"}]}])

ghost("nw_mosinna", name="魔神仔", title="請你食雞髀（其實係草蜢）", sys="妖", sc="電話", tier=2, pin="靈", ch=3, mech=["迷魂"], tags=["拉", "削"],
      rng="中", role="flank", base=[60, 95, 85], h=48, camp=("古道收數佬", 2),
      trait="好客到極，請人入山食雞髀；食完先知係草蜢。",
      lore="台灣、閩南民間的「魔神仔」：山林裏矮小的精怪，會引人入山迷路，餵人吃草蜢、牛糞，被尋回的人常說自己吃過「雞腿」。",
      say=["嚟，請你食雞髀，食完我帶你入山行吓。", "來，請你吃雞腿，吃完我帶你進山走走。"],
      skill={"name": "請食雞髀", "kind": "hit", "mult": 0.9, "apply": "down", "sap": 20, "desc": "塞隻「雞髀」入敵人口：佢企定食，食完腳軟，嚇氣都冇埋。"},
      act={"name": "請食雞髀", "tg": {"sel": "near"},
           "fx": [{"p": "dmg", "mult": M(0.9)}, {"p": "stun", "dur": 2.5}, {"p": "down", "dur": 1.0}, {"p": "sap", "v": 20}], "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [ST(dur=3.0, first_x=1.2)]}])

ghost("nw_niexiaoqian", name="聶小倩", title="骨灰想返鄉", sys="魂", sc="凍", tier=3, pin="煞", ch=3, mech=["隱"], tags=["回", "定"],
      rng="中", role="back", base=[60, 120, 85], h=60, solid=False, camp=("霧谷吊頸林", 2),
      trait="被人逼住做嘢做咗好多年，最大心願係有人幫手執骨返鄉。",
      lore="清代蒲松齡《聊齋志異·聶小倩》：女鬼聶小倩被妖物脅迫害人，得書生寧采臣相助，把她的骸骨遷葬，終得脫身。",
      say=["幫我搵返啲骨頭歸鄉，我就幫你搵返啲人返嚟。", "幫我把骨頭送回家鄉，我就幫你把人找回來。"],
      skill={"name": "歸骨", "kind": "heal", "mult": 0.25, "desc": "幫最傷嗰個隊友補血，仲幫佢預留一次返魂。"},
      act={"name": "歸骨", "tg": {"sel": "ally_low"},
           "fx": [{"p": "heal", "pct": 0.22}, {"p": "revive", "pct": 0.3}, {"p": "cleanse", "n": 2}], "ai": {"ally_hp": 0.5, "wait": 5}},
      pas=[{"tr": "start", "star": 2, "fx": [{"p": "shield", "pct": 0.1, "dur": 8.0, "tg": "allies"}]}],
      aura={"star": 0, "r": 140, "side": "ally", "fx": [{"p": "immune", "tags": ["fear_aura", "confuse"], "dur": -1}]})

ghost("nw_luotoumin", name="落頭民", title="個頭夜晚自己去散步", sys="妖", sc="黑影", tier=2, pin="靈", ch=3, mech=["飛", "突襲"], tags=["刺", "定"],
      rng="中", role="flank", base=[70, 85, 95], h=58, camp=("義莊屍隊", 2),
      trait="夜晚個頭自己出去行街，朝早先返嚟；最怕有人好心幫佢冚被冚過頸。",
      lore="東晉干寶《搜神記》卷十二：吳將朱桓有一婢，每夜睡後頭便飛去，以耳為翼，天將亮時飛回；一次被子蓋住頸項，頭回不了身，幾乎氣絕。書中稱南方有「落頭民」。",
      say=["我個頭出去行吓街，身體留低幫你睇住。", "我的頭出去逛逛街，身體留下來幫你看著。"],
      skill={"name": "頭飛出去", "kind": "hit", "mult": 1.75, "desc": "個頭飛去咬最遠嗰個，身體留喺原地引開敵人。"},
      act={"name": "頭飛出去", "tg": {"sel": "far"},
           "fx": [{"p": "dmg", "mult": M(1.75)}, {"p": "taunt", "r": 120, "dur": 3.0}], "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 2, "fx": [{"p": "anti_air", "x": 1.2, "dur": -1, "tg": "self"}]}])

# ============================== 第 4 關（河口） ==============================
ghost("nw_shen", name="蜃", title="吐一啖氣就有樓", sys="妖", sc="吹氣", tier=2, pin="靈", ch=4, mech=["分身", "隱"], tags=["遠", "掃", "削"],
      rng="遠", role="back", base=[45, 110, 85], h=52, camp=("沉船灘水妖", 2),
      trait="吐一啖氣就變出成排樓，可惜冇一間攞得到入伙紙。",
      lore="《史記·天官書》：「海旁蜄氣象樓臺，廣野氣成宮闕然。」古人以為海上幻景是大蜃（大蛤）吐氣而成，故稱「海市蜃樓」。",
      say=["我吐啖氣你就有樓住，不過唔包業權。", "我吐口氣你就有樓住，不過不包產權。"],
      skill={"name": "海市蜃樓", "kind": "aoe", "mult": 0.75, "sap": 20, "desc": "吐出一片幻景：敵人睇到樓就行錯路，嚇氣都散咗。"},
      act={"name": "海市蜃樓", "tg": {"sel": "far", "shape": "circle", "r": 130},
           "fx": [{"p": "dmg", "mult": M(0.7)}, {"p": "confuse", "dur": 2.0}, {"p": "sap", "v": 20}], "ai": {"n_in": 2, "r": 130, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [ST(dur=2.0, first_x=1.3)]}])

ghost("nw_ushioni", name="牛鬼", title="牛頭蜘蛛身", sys="妖", sc="吹氣", tier=3, pin="煞", ch=4, mech=["殼", "反傷"], tags=["破", "回"],
      rng="近", role="front", base=[120, 40, 100], h=62, camp=("沉船灘水妖", 3),
      trait="牛頭加六隻蜘蛛腳，行路好快，買褲好難。",
      lore="西日本沿海傳說的「牛鬼」：牛頭、蜘蛛般的身體，在海邊襲擊人；鳥山石燕《畫圖百鬼夜行》亦有繪畫。",
      say=["牛頭係我，蜘蛛腳都係我，唔好問我點揀褲。", "牛頭是我，蜘蛛腳也是我，別問我怎麼挑褲子。"],
      skill={"name": "牛角毒", "kind": "hit", "mult": 1.3, "follow": "air", "drain": 0.2, "desc": "牛角一頂再噴毒：對方甲殼鬆咗，自己補返啖血。"},
      act={"name": "牛角毒", "tg": {"sel": "near"},
           "fx": [{"p": "dmg", "mult": M(1.3)}, {"p": "air", "dur": 0.8}, {"p": "dot", "dps": 0.12, "dur": 5.0, "kind": "poison"}, {"p": "armor_break", "v": 0.3, "dur": 6.0}, {"p": "drain", "pct": 0.2}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "shield", "pct": 0.25, "dur": 10.0, "tg": "self"}]}])

ghost("nw_manananggal", name="Manananggal", title="上半身返夜更", sys="厲", sc="凍", tier=2, pin="靈", ch=4, mech=["飛", "突襲"], tags=["拉", "掃"],
      rng="近", role="flank", base=[65, 80, 100], h=60, solid=False, camp=("蕉園夜叫", 2),
      trait="上半身返夜更、下半身留喺屋企睇門口；放工要準時返去駁返。",
      lore="菲律賓民間的「Manananggal」（意為「自行分離者」）：夜間上半身長出蝙蝠般的翼飛走，下半身留在地上；民間說在下半身撒鹽、蒜或灰，她便接不回身。本作斷口以煙霧收口。",
      say=["下半身留喺度睇位，上半身去做嘢，分工合作。", "下半身留在這裡看位置，上半身去幹活，分工合作。"],
      skill={"name": "夜空俯衝", "kind": "aoe", "mult": 1.0, "apply": "down", "desc": "由半空俯衝落敵人後排，落點一圈全部腳軟。"},
      act={"name": "夜空俯衝", "tg": {"sel": "back", "shape": "circle", "r": 110},
           "fx": [{"p": "dmg", "mult": M(1.0)}, {"p": "down", "dur": 1.0}], "ai": {"when": "asap"}},
      pas=[{"tr": "low_hp", "pct": 0.4, "star": 0, "fx": [{"p": "buff", "stat": "spd", "v": 0.3, "dur": 6.0, "tg": "self"}]}])

ghost("nw_nangtani", name="Nang Tani", title="香蕉樹下派飯", sys="妖", sc="紙", tier=2, pin="靈", ch=4, mech=["隱"], tags=["回", "定"],
      rng="中", role="back", base=[45, 110, 80], h=58, camp=("紅樹林新娘", 2),
      trait="住喺野生香蕉樹，肚餓嘅就嚟樹下坐；不過千祈唔好斬佢棵樹。",
      lore="泰國民間的「Nang Tani」（นางตานี）：住在野生香蕉樹（芭蕉）裏的女精靈，常穿綠色傳統衣裙，在月夜現身；民間會在樹下供奉。",
      say=["肚餓就嚟樹下坐，香蕉有排都食唔晒。", "肚子餓就來樹下坐，香蕉多到吃不完。"],
      skill={"name": "香蕉樹蔭", "kind": "heal", "mult": 0.2, "desc": "種棵香蕉樹：樹蔭下嘅隊友慢慢回血，仲有層護盾。"},
      act={"name": "香蕉樹蔭", "tg": {"sel": "allies", "r": 180},
           "fx": [{"p": "hot", "pct": 0.03, "dur": 8.0}, {"p": "shield", "pct": 0.1, "dur": 6.0}], "ai": {"ally_hp": 0.6, "wait": 5}},
      pas=[{"tr": "low_hp", "pct": 0.35, "star": 0, "fx": [ST(dur=3.0, first_x=1.0)]}],
      aura={"star": 0, "r": 150, "side": "ally", "fx": [{"p": "immune", "tags": ["fear_aura"], "dur": -1}]})

ghost("nw_nuno", name="Nuno sa Punso", title="行過要講借借", sys="妖", sc="電話", tier=1, pin="凡", ch=4, mech=["反傷"], tags=["掃", "定"],
      rng="近", role="front", base=[55, 45, 50], h=40, camp=("紅樹林新娘", 3),
      trait="住喺蟻丘嘅小老人；你行過唔講句借借，佢就記住你。",
      lore="菲律賓民間的「Nuno sa Punso」（蟻丘裏的老人）：住在蟻丘的小精靈；經過蟻丘要先說「Tabi tabi po」（借過、打擾了）以示尊重，否則會被他作弄生病。",
      say=["Tabi tabi po？好，有禮貌，行啦。唔講嗰個，企住。", "Tabi tabi po？好，有禮貌，走吧。沒說的那個，站住。"],
      skill={"name": "蟻丘", "kind": "aoe", "mult": 0.5, "desc": "立起蟻丘：行近嘅敵人要同佢計數，行慢、出手軟、慢慢扣血。"},
      act={"name": "蟻丘", "tg": {"sel": "near", "shape": "circle", "r": 110},
           "fx": [{"p": "dmg", "mult": M(0.5)}, {"p": "taunt", "r": 110, "dur": 3.0}, {"p": "slow", "v": -0.25, "va": 0.25, "dur": 5.0}, {"p": "dot", "dps": 0.06, "dur": 5.0, "kind": "poison"}],
           "ai": {"n_in": 2, "r": 110, "wait": 5}},
      pas=[{"tr": "hit_taken", "star": 0, "chance": 0.2, "icd": 4, "fx": [{"p": "dmg", "mult": M(0.5)}]}])

ghost("nw_akaname", name="垢嘗", title="浴室清潔專家", sys="妖", sc="鬼臉", tier=1, pin="凡", ch=4, mech=["再生"], tags=["削", "回"],
      rng="近", role="back", base=[40, 60, 45], h=46, camp=("河口替身組", 2),
      trait="越污糟越開心；全村最受歡迎嘅員工，因為佢肯洗廁所。",
      lore="鳥山石燕《畫圖百鬼夜行》（1776）所繪的「垢嘗」：夜裏潛入浴室，舔食浴桶和地上污垢的妖怪。",
      say=["越污糟我越開心，你哋盡情搞亂佢。", "越髒我越開心，你們盡情把它弄亂。"],
      skill={"name": "舔乾淨", "kind": "heal", "mult": 0.08, "desc": "成隊舔一舔：負面效果清走，順便補少少血。"},
      act={"name": "舔乾淨", "tg": {"sel": "allies", "r": 200},
           "fx": [{"p": "cleanse", "n": 3}, {"p": "heal", "pct": 0.08}], "ai": {"ally_hp": 0.7, "wait": 5}},
      pas=[{"tr": "attack", "n": 2, "star": 0, "fx": [{"p": "sap", "v": 12}]}])

# ============================== 第 5 關（舊區） ==============================
ghost("nw_jinmenken", name="人面犬", title="唔好理我", sys="妖", sc="電話", tier=1, pin="凡", ch=5, mech=["突襲"], tags=["刺", "削"],
      rng="近", role="flank", base=[40, 50, 65], h=44, camp=("巴士站怪談", 2),
      trait="唐狗身、中年打工仔塊面；你望佢，佢叫你唔好理佢。",
      lore="1989–1990 年日本流行的都市傳說「人面犬」：長着人臉的狗，在街上被人看見時會說「放っておいてくれ」（別管我）。",
      say=["唔好理我，我自己識搵位企。", "別管我，我自己會找位置站。"],
      skill={"name": "唔好理我", "kind": "hit", "mult": 1.3, "desc": "衝去後排咬一啖，對方即刻無語，講唔出技能。"},
      act={"name": "唔好理我", "tg": {"sel": "back"},
           "fx": [{"p": "dash", "to": "target", "dist": 320}, {"p": "dmg", "mult": M(1.3)}, {"p": "silence", "dur": 2.0}], "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "buff", "stat": "spd", "v": 0.6, "dur": -1, "tg": "self"}]},
           {"tr": "hit_taken", "star": 2, "chance": 0.3, "icd": 5, "fx": [{"p": "buff", "stat": "taken", "v": -0.2, "dur": 3.0, "tg": "self"}]}])

ghost("nw_kamaitachi", name="鎌鼬", title="三兄弟一條龍服務", sys="妖", sc="吹氣", tier=1, pin="凡", ch=5, mech=["突襲"], tags=["拉", "掃", "回"],
      rng="近", role="flank", base=[40, 45, 65], h=44, camp=("巴士站怪談", 3),
      trait="一隻推、一隻斬、一隻搽藥，分工清楚過好多公司。",
      lore="日本甲信越等地傳說：旋風中的「鎌鼬」三隻一組，一隻推倒人、一隻用鐮刀般的爪割開皮肉、一隻敷藥，所以傷口很深卻不痛也不流血。",
      say=["我哋三兄弟，推、斬、搽藥，一條龍。", "我們三兄弟，推、砍、擦藥，一條龍服務。"],
      skill={"name": "三連風", "kind": "aoe", "mult": 0.8, "apply": "down", "desc": "三兄弟一陣風：推低、斬一刀，跟住搽藥（搽畀自己友）。"},
      act={"name": "三連風", "tg": {"sel": "near", "shape": "chain", "n": 3, "falloff": 0.1},
           "fx": [{"p": "dmg", "mult": M(0.8)}, {"p": "down", "dur": 0.8}, {"p": "dot", "dps": 0.1, "dur": 4.0, "kind": "bleed"}], "ai": {"n_in": 2, "r": 140, "wait": 5}},
      pas=[{"tr": "every", "t": 8.0, "star": 0, "fx": [{"p": "hot", "pct": 0.03, "dur": 4.0, "tg": "ally_low"}]},
           {"tr": "start", "star": 2, "fx": [{"p": "buff", "stat": "spd", "v": 0.4, "dur": -1, "tg": "self"}]}])

ghost("nw_dikseigwai", name="搭的士鬼", title="車資用冥鏹找", sys="橫", sc="紙", tier=1, pin="凡", ch=5, mech=["突襲"], tags=["刺", "削"],
      rng="中", role="flank", base=[45, 60, 55], h=60, camp=("停車場橫死組", 2),
      trait="半夜截車，上車只講「前面嗰度」；落車之後司機先發現收咗冥鏹。",
      lore="香港都市傳說：的士司機深夜載客往墳場一帶，翌日點算車資，才發現收到的鈔票變成了冥鏹。（本作不畫任何真實車款、車行標誌或車牌。）",
      say=["師傅，去前面嗰度，唔使找。", "師傅，去前面那裡，不用找錢。"],
      skill={"name": "去邊度", "kind": "hit", "mult": 1.2, "desc": "截架車直飛去敵人後排，打斷佢出手，車資照收。"},
      act={"name": "去邊度", "tg": {"sel": "back"},
           "fx": [{"p": "dash", "to": "target", "dist": 300}, {"p": "dmg", "mult": M(1.2)}, {"p": "coin", "v": 15}, {"p": "interrupt"}], "ai": {"when": "asap"}},
      pas=[{"tr": "kill", "star": 0, "icd": 4, "fx": [{"p": "energy", "v": 25, "tg": "self"}]}])

ghost("nw_dodomeki", name="百々目鬼", title="手臂長滿眼嘅扒手", sys="妖", sc="燈", tier=2, pin="靈", ch=5, mech=["隱"], tags=["遠", "照"],
      rng="遠", role="back", base=[45, 105, 90], h=58, camp=("停車場橫死組", 3),
      trait="手臂上百幾對眼，邊個匿埋佢都睇到；可惜睇得太多，晚晚瞓唔着。",
      lore="鳥山石燕《今昔畫圖續百鬼》（1779）所繪的「百々目鬼」：一名手長的女子慣偷錢財，偷得多了，手臂上長出無數鳥目（舊時銅錢俗稱「鳥目」）。",
      say=["我呢百幾對眼，邊個匿埋我都睇到。", "我這一百多對眼睛，誰躲起來我都看得到。"],
      skill={"name": "百眼", "kind": "aoe", "mult": 0.7, "desc": "百幾對眼一齊打開：全場匿埋嘅即刻現形，自己友打得準啲。"},
      act={"name": "百眼", "tg": {"sel": "self"},
           "fx": [{"p": "reveal", "r": 400, "dur": 6.0}, {"p": "buff", "stat": "atk", "v": 0.15, "dur": 6.0, "tg": "allies"}], "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "coin", "v": 10}]}])

ghost("nw_makuragaeshi", name="枕返", title="瞓醒你喺另一邊", sys="妖", sc="電話", tier=1, pin="凡", ch=5, mech=["迷魂"], tags=["拉", "收"],
      rng="中", role="flank", base=[35, 65, 50], h=44, camp=("舊戲院女鬼", 2),
      trait="專幫人反轉個枕頭；你瞓醒發覺頭腳掉轉，就係佢返過工。",
      lore="鳥山石燕《畫圖百鬼夜行》所繪的「枕返」：夜裏把睡着的人的枕頭翻轉或移到腳邊的妖怪；日本舊俗認為睡時魂魄離身，枕頭被翻轉，魂魄便回不了身。",
      say=["瞓醒唔知自己喺邊？唔使多謝，係我搞嘅。", "睡醒不知道自己在哪？不用謝，是我弄的。"],
      skill={"name": "反枕頭", "kind": "hit", "mult": 0.9, "desc": "將後排一個敵人「反」過嚟前面，佢瞓醒唔知身在何方；殘嘅魂都返唔到身。"},
      act={"name": "反枕頭", "tg": {"sel": "back"},
           "fx": [{"p": "dmg", "mult": M(0.9)}, {"p": "pull", "dist": 140}, {"p": "confuse", "dur": 1.5}, {"p": "banish", "hp_pct": 0.3}], "ai": {"when": "asap"}},
      pas=[{"tr": "every", "t": 10.0, "star": 2, "fx": [{"p": "confuse", "dur": 1.0, "tg": "near"}]}])

ghost("nw_nekomata", name="貓又", title="老貓唔死就分叉", sys="妖", sc="燈", tier=2, pin="靈", ch=5, mech=["召喚"], tags=["照", "收"],
      rng="近", role="flank", base=[60, 90, 95], h=52, camp=("舊村古井", 2),
      trait="養到好老嘅貓，條尾開咗叉；叫佢做嘢佢照瞓，叫啲倒咗地嘅做嘢就得。",
      lore="吉田兼好《徒然草》第 89 段：「奧山に猫またといふものありて、人を食ふ」；江戶時代民間又說家貓活得太老，尾巴分成兩叉，便成「貓又」，能操縱屍體。",
      say=["喵。倒低嘅，我叫佢哋起身再做多轉。", "喵。倒下的，我叫他們起來再做一輪。"],
      skill={"name": "操屍", "kind": "hit", "mult": 1.1, "desc": "殘嘅敵人收走，再叫具骷髏起身幫手打。"},
      act={"name": "操屍", "tg": {"sel": "low"},
           "fx": [{"p": "dmg", "mult": M(1.1)}, {"p": "banish", "hp_pct": 0.35}, {"p": "summon", "k": "zd_bone", "name": "骷髏", "n": 1, "hp_pct": 0.3, "atk_pct": 0.4, "dur": 10}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "kill", "star": 0, "icd": 2, "fx": [{"p": "energy", "v": 25, "tg": "self"}]}])

# ============================== 第 6 關（地府集團） ==============================
ghost("nw_nurikabe", name="塗壁", title="人形路障", sys="妖", sc="黑影", tier=3, pin="煞", ch=6, mech=["殼", "霸體"], tags=["拉", "定"],
      rng="近", role="front", base=[130, 30, 90], h=64, camp=("集團保安部", 3),
      trait="企喺路中間唔郁；你要過，就要識敲佢隻腳。",
      lore="日本九州（筑前、豐前一帶）傳說：夜行時前面忽然出現一道看不見的牆，左右都繞不過；柳田國男《妖怪談義》記載，用棍子敲牆腳，牆就會消失。",
      say=["前面冇路喇，要過就敲吓我隻腳，敲啱位先得。", "前面沒路了，要過就敲一下我的腳，敲對位置才行。"],
      skill={"name": "一幅牆", "kind": "hit", "mult": 0.8, "apply": "down", "desc": "立起一幅牆：衝埋嚟嗰個撞到跌低，身邊敵人全部要對住佢。"},
      act={"name": "一幅牆", "tg": {"sel": "near"},
           "fx": [{"p": "dmg", "mult": M(0.8)}, {"p": "down", "dur": 1.2}, {"p": "taunt", "r": 140, "dur": 4.0}, {"p": "guard", "r": 90, "pct": 0.35, "dur": 6.0}],
           "ai": {"when": "asap"}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "shield", "pct": 0.2, "dur": 8.0, "tg": "self"}]},
           {"tr": "low_hp", "pct": 0.4, "star": 2, "fx": [{"p": "taunt", "r": 160, "dur": 3.0}]}])

ghost("nw_ungaikyo", name="雲外鏡", title="照完你唔敢再照", sys="妖", sc="燈", tier=2, pin="靈", ch=6, mech=["反傷"], tags=["照", "定"],
      rng="中", role="back", base=[50, 100, 85], h=54, camp=("董事會審批部", 2),
      trait="一面舊銅鏡，照得出你真身；全村冇人肯同佢影相。",
      lore="鳥山石燕《百器徒然袋》（1784）所繪的「雲外鏡」：舊鏡子化成的付喪神，據說能照出妖怪的真身。",
      say=["照吓先啦，照完你就知自己係乜嘢嚟。", "先照一下吧，照完你就知道自己是什麼東西。"],
      skill={"name": "照真身", "kind": "hit", "mult": 1.0, "desc": "鏡面一照：最勁嗰個敵人現形、增益打回原形，身邊匿埋嘅都照埋出嚟。"},
      act={"name": "照真身", "tg": {"sel": "strong"},
           "fx": [{"p": "dmg", "mult": M(1.0)}, {"p": "reveal", "r": 150, "dur": 6.0}, {"p": "dispel", "n": 2}], "ai": {"when": "asap"}},
      pas=[{"tr": "hit_taken", "star": 0, "chance": 0.3, "icd": 6, "fx": [{"p": "dmg", "mult": M(0.6)}]}],
      aura={"star": 0, "r": 130, "side": "ally", "fx": [{"p": "immune", "tags": ["confuse"], "dur": -1}]})

ghost("nw_poltergeist", name="Poltergeist", title="搬屋唔使請人", sys="魂", sc="怪聲", tier=2, pin="靈", ch=6, mech=["隱"], tags=["遠", "掃"],
      rng="遠", role="back", base=[45, 105, 90], h=54, solid=False, camp=("頂樓機房", 2),
      trait="碗碟椅子自己飛，佢就喺隔籬攤開雙手扮無辜。",
      lore="德國及歐洲民間的「Poltergeist」：德文 poltern（吵鬧、敲打）加 Geist（鬼），指會敲牆、搬動和投擲物件的吵鬧鬼。",
      say=["唔係我掟㗎，係啲嘢自己飛過去。", "不是我扔的，是那些東西自己飛過去的。"],
      skill={"name": "飛碗飛碟", "kind": "aoe", "mult": 0.6, "desc": "碗碟椅子一路飛過去，彈中五個敵人，中嘅退後兩步。"},
      act={"name": "飛碗飛碟", "tg": {"sel": "far", "shape": "chain", "n": 5, "falloff": 0.08},
           "fx": [{"p": "dmg", "mult": M(0.6)}, {"p": "push", "dist": 30}], "ai": {"n_in": 2, "r": 150, "wait": 5}},
      pas=[{"tr": "every", "t": 9.0, "star": 0, "fx": [{"p": "flee", "dur": 1.0, "tg": "near"}]}])

ghost("nw_dokkaebi", name="Dokkaebi", title="一棍敲出金", sys="妖", sc="紙", tier=3, pin="煞", ch=6, mech=["霸體"], tags=["回", "定"],
      rng="近", role="front", base=[115, 70, 95], h=64, camp=("地庫紙紮部", 3),
      trait="揸住支如意棒，一敲就變嘢出嚟；最鍾意搵人摔跤，輸咗唔認數。",
      lore="韓國民間的「도깨비」（Dokkaebi）：手持「도깨비방망이」（鬼棒），敲一下就能變出金銀財物；民間故事常說他愛找人摔跤（씨름），亦會獎善懲惡。",
      say=["敲一棍出金，敲兩棍出飯，敲三棍你就要同我摔跤。", "敲一棍出金子，敲兩棍出飯，敲三棍你就要跟我摔跤。"],
      skill={"name": "金棒", "kind": "heal", "mult": 0.1, "desc": "一棍敲落地：全隊回血、打得狠啲，仲跌出啲冥幣。"},
      act={"name": "金棒", "tg": {"sel": "allies", "r": 200},
           "fx": [{"p": "heal", "pct": 0.1}, {"p": "buff", "stat": "atk", "v": 0.15, "dur": 8.0}, {"p": "coin", "v": 20}], "ai": {"ally_hp": 0.7, "wait": 5}},
      pas=[{"tr": "start", "star": 0, "fx": [{"p": "taunt", "r": 120, "dur": 5.0}]},
           {"tr": "every", "t": 12.0, "star": 2, "fx": [{"p": "taunt", "r": 120, "dur": 3.0}]}])

# ---------------------------------------------------------------------------------------------
# 合體技 5 組（roster.md 第 5 節有民俗依據；避開 BOND_FEUDS 冤家；兩人組 strike 同步入舊 COMBOS）
# ---------------------------------------------------------------------------------------------
LINKS = [
 dict(id="shanhai", name="山海經", m=["nw_bifang", "nw_qiongqi"], need=2, kind="aura",
      lore="畢方、窮奇同載《山海經·西山經》", desc="兩隻同場：攻擊、受傷減免各 +10%；我方免疫燒傷。",
      fx=[{"p": "buff", "stat": "atk", "v": 0.1, "tg": "members"}, {"p": "buff", "stat": "taken", "v": -0.1, "tg": "members"}, {"p": "immune", "tags": ["dot_fire"], "dur": -1, "tg": "allies"}]),
 dict(id="weihu", name="為虎作倀", m=["n30_changgui", "nw_harimau"], need=2, kind="strike", mult=2.6,
      lore="成語「為虎作倀」（倀鬼替老虎引路）＋馬來半島的人虎 Harimau Jadian", desc="倀鬼引路、人虎撲出：直線撲穿敵陣，撞到嘅腳軟兼流血。",
      fx=[{"p": "dmg", "mult": 2.6, "tg": "near", "shape": "line", "len": 320, "w": 70}, {"p": "down", "dur": 1.2}, {"p": "dot", "dps": 0.1, "dur": 4.0, "kind": "bleed"}]),
 dict(id="jiaoshu", name="香蕉樹下", m=["pontianak", "nw_nangtani"], need=2, kind="aura",
      lore="馬來 Pontianak、泰國 Nang Tani 傳說都住在香蕉樹", desc="兩隻同場：香蕉樹蔭回血 +30%；Pontianak 喺樹蔭入面匿埋（開戰隱身 3 秒）。",
      fx=[{"p": "buff", "stat": "heal_out", "v": 0.3, "who": "nw_nangtani"}, {"p": "stealth", "dur": 3.0, "tg": "members", "on": "start", "who": "pontianak"}]),
 dict(id="tsukumo", name="付喪神", m=["n30_kasaobake", "n30_chochin", "nw_ungaikyo"], need=3, kind="aura",
      lore="日本器物用久成妖的「付喪神」：唐傘、提燈、舊鏡（鳥山石燕《百器徒然袋》）", desc="三件舊器物齊集：唐傘妖、提燈妖「怕燈（火）」弱點減半；雲外鏡現形範圍 +50%。",
      fx=[{"p": "buff", "stat": "fear_light", "v": -0.5, "tg": "members"}, {"p": "buff", "stat": "reveal_r", "v": 0.5, "who": "nw_ungaikyo"}]),
 dict(id="yueyu", name="粵語俗語會", m=["nw_guiamngaan", "nw_guisihknai", "nw_paakbok", "nw_tisi"], need=3, kind="aura",
      lore="四句廣東話民間說法：鬼揞眼、講嘢好似鬼食泥、拍膊頭熄燈、替死鬼", desc="任 3 隻同場：我方控制效果 +1 秒；開戰全場敵人嚇氣 −20。",
      fx=[{"p": "buff", "stat": "cc_dur", "v": 1.0, "tg": "members"}, {"p": "sap", "v": 20, "tg": "foes", "on": "start"}]),
]
