# [soul] 產生 data/nat/soul.json（品級 pin、臨時據點駐守表、心願供品）
# 用法：python3 -I tools/soul/soul_build.py   （喺 godot 目錄跑）
# 數據來源：/home/claude/bs/soul.md 第 2、3、4 節；據點表 = /home/claude/bs/soul_sim/camp_table.md
# 第一階段：〔新〕鬼位未有圖 → 暫用現有同品級鬼頂（TMP_SUB），counter.json 有 guard 時以 counter 為準
import json, os
# 品級定案（FIXES_review1 第 15 項）：按定案名冊 /home/claude/bs/counter_tool/roster_data.py 的 T 值
#   T1＝凡、T2＝靈、T3＝煞；劇情王（T4）按 soul.md：餓鬼王／Toyol／Pocong 煞，其餘王；小紙靈、孟婆王、天花姐按 T。
#   Sundel Bolong 已去掉（老闆 20:24），空位 Teke Teke（第 5 關、厲、突襲，T2）。冇 k1／k2。
import re
ROSTER = "/home/claude/bs/counter_tool/roster_data.py"
TPIN = {"T1": "凡", "T2": "靈", "T3": "煞"}
STORY_PIN = {"eguiking": "煞", "toyol": "煞", "pocong": "煞", "laojiang": "王", "pontianak": "王", "penanggal": "王", "baiwu": "王", "heiwu": "王", "mengpo": "王", "xiaozhi": "靈"}
PIN = {}; NEWG = {}
for ln in open(ROSTER, encoding="utf-8"):
    m = re.match(r'add\("([a-z0-9_]+)",\s*"[^"]*",\s*"[^"]*",\s*"[^"]*",\s*(\d),\s*"[^"]*",\s*"(T\d)"', ln)
    if not m: continue
    k, ch, t = m.group(1), int(m.group(2)), m.group(3)
    if k == "nw_sundel": k, ch = "nw_teketeke", 5
    PIN[k] = STORY_PIN.get(k, TPIN.get(t, "王"))
    if "new=True" in ln or k == "nw_teketeke": NEWG[k] = ch - 1
for k, v in STORY_PIN.items(): PIN.setdefault(k, v)
assert len(PIN) == 100, len(PIN)

# 每章 15 據點主魂（次序＝zones.json sorties：r1_1..r4_3）；new_* ＝〔新〕位
CH = [
 "n30_qionggui n30_danxiao n30_maoshi n30_yangui n30_jiugui pg_tuimo n30_dugui n30_guhangui n30_taozhai n30_diaosi n30_jerangkung xiaozhi new_s2 new_s1 eguiking",
 "n30_pelesit n30_polong n30_jenglot new_f1 new_f2 new_f3 n30_hantugalah n30_bunian new_l1 new_l2 new_l3 pg_ex toyol n30_genderuwo n30_hanturaya",
 "n30_wutou n30_changgui new_f4 new_f5 new_f6 new_f7 n30_guixinniang n30_baigujing n30_shanxiao pg_songding new_l4 new_l5 laojiang n30_hanba n30_yecha",
 "n30_phiam new_f8 new_f9 new_f10 new_f11 new_f12 n30_churel n30_tikbalang n30_maenak new_l6 new_l7 new_l8 n30_banshee n30_vetala n30_aswang",
 "n30_zipai n30_xiaosi n30_yesi n30_shidu n30_daji n30_xiasi n30_chehuo n30_yezi n30_liulian n30_zhongshu n30_chengsi n30_shedu n30_xiangcai n30_dongsi n30_diansi",
 "n30_kasaobake n30_chochin n30_kappa new_f13 new_f14 new_f15 n30_nopperabo n30_rokurokubi n30_kuchisake new_l9 n30_yukionna n30_hannya pg_ji n30_leipi n30_gashadokuro",
]
# 〔新〕位暫代（同品級現有鬼；令佢哋多一個來源）
TMP_SUB = {
 "new_s1": "pg_landlady", "new_s2": "pg_ji",
 "new_f1": "n30_yangui", "new_f2": "n30_jiugui", "new_f3": "n30_maoshi",
 "new_l1": "n30_churel", "new_l2": "n30_tikbalang", "new_l3": "n30_maenak",
 "new_f4": "n30_danxiao", "new_f5": "n30_qionggui", "new_f6": "pg_tuimo", "new_f7": "n30_phiam",
 "new_l4": "n30_diaosi", "new_l5": "n30_taozhai",
 "new_f8": "n30_pelesit", "new_f9": "n30_polong", "new_f10": "n30_jenglot", "new_f11": "n30_kappa", "new_f12": "n30_chochin",
 "new_l6": "n30_hantugalah", "new_l7": "n30_bunian", "new_l8": "pg_ex",
 "new_f13": "n30_xiaosi", "new_f14": "n30_yesi", "new_f15": "n30_xiasi", "new_l9": "n30_guixinniang",
}
IDS = ["r1_1", "r1_2", "r1_3", "r1_4", "r2_1", "r2_2", "r2_3", "r2_4", "r3_1", "r3_2", "r3_3", "r3_4", "r4_1", "r4_2", "r4_3"]
CAMP = {}
for c, row in enumerate(CH):
    ks = row.split(); assert len(ks) == 15
    ks = [TMP_SUB.get(k, k) for k in ks]
    for i, k in enumerate(ks):
        assert k in PIN, k
        CAMP["%d:so%d_%s" % (c, c + 1, IDS[i])] = k

# 第一階段臨時表＝cdata 線 counter.json 據點 guard 嘅快照（cdata 合併後遊戲直接讀 counter.json，呢度只係後備）
CT = "/home/claude/wt/cdata/godot/data/nat/counter.json"
CAMP_PLAN = {}; CAMP_EN = {}; CAMP_EN_PLAN = {}
if os.path.exists(CT):
    ct = json.load(open(CT, encoding="utf-8"))
    CAMP = {}
    for cid, d in ct["camps"].items():
        CAMP["%d:%s" % (d["c"], cid)] = d["guard"]
        CAMP_PLAN["%d:%s" % (d["c"], cid)] = d.get("guard_plan", d["guard"])
        CAMP_EN["%d:%s" % (d["c"], cid)] = [x for x in d.get("en", []) if x in PIN]
        CAMP_EN_PLAN["%d:%s" % (d["c"], cid)] = [x for x in d.get("plan", d.get("en", [])) if x in PIN]
for k in CAMP.values(): assert k in PIN, k

# 心願供品：[資源, 粵語原句, 中文]（冇寫就用壽包）
WISH = {
 "n30_qionggui": ["coins", "借住先，有錢即刻還……應該。", "先借著，有錢馬上還……應該吧。"],
 "n30_guhangui": ["coins", "冥幣放低，我數完先簽。", "冥幣放下，我數完再簽。"],
 "n30_dugui": ["coins", "本錢夠就入職，唔夠我照借。", "本錢夠就入職，不夠我照樣借。"],
 "n30_taozhai": ["coins", "人哋欠我嘅，你先幫佢還咗。", "別人欠我的，你先幫他還了。"],
 "n30_chengsi": ["buns", "壽包呢？我只係食少少……一籠。", "壽包呢？我只吃一點點……一籠。"],
 "n30_gashadokuro": ["buns", "餓咗幾百年，壽包先嚟。", "餓了幾百年，壽包先來。"],
 "n30_shidu": ["buns", "要新鮮嘅，過期嗰啲我食過喇。", "要新鮮的，過期的我吃過了。"],
 "n30_yesi": ["buns", "切細粒啲，我驚。", "切小塊一點，我怕。"],
 "laojiang": ["planks", "棺材板要厚，我瞓開實木。", "棺材板要厚，我睡慣實木。"],
 "pg_landlady": ["planks", "棺材板夠我間多兩間劏房。", "棺材板夠我多隔兩間劏房。"],
 "n30_kappa": ["rice", "冇青瓜，糯米頂住先。", "沒有黃瓜，糯米先頂著。"],
 "pg_tuimo": ["rice", "有米先有磨推，有錢都要有米。", "有米才有磨推，有錢也要有米。"],
 "tianhua": ["wood", "槐木畀我，我搭個棚先。", "槐木給我，我先搭個棚。"],
 "n30_yangui": ["wood", "槐木唔係用嚟燒嘅……係嘅，係用嚟燒嘅。", "槐木不是用來燒的……是的，就是用來燒的。"],
 "n30_jiugui": ["rice", "糯米釀酒，先釀先簽。", "糯米釀酒，先釀再簽。"],
 "n30_diaosi": ["wood", "槐樹要粗，枝要穩。", "槐樹要粗，樹枝要穩。"],
 "n30_hanba": ["rice", "我行過嘅田冇收成，糯米你哋自己帶。", "我走過的田沒有收成，糯米你們自己帶。"],
 "n30_zipai": ["coins", "冥幣買部新手機，舊嗰部跌咗落山。", "冥幣買部新手機，舊的那部摔下山了。"],
 "n30_daji": ["coins", "充值先，打完呢鋪就返工。", "先充值，打完這局就上班。"],
 "eguiking": ["buns", "壽包，越多越好，唔好問點解。", "壽包，越多越好，別問為什麼。"],
 "toyol": ["coins", "冥幣交畀我保管，好安全㗎。", "冥幣交給我保管，很安全的。"],
 "xiaozhi": ["planks", "棺材板？唔使……都係要啲。", "棺材板？不用……還是要一點。"],
 "n30_phiam": ["rice", "坐喺你心口嗰陣，有糯米食就最好。", "壓在你胸口的時候，有糯米吃就最好。"],
 "n30_xiangcai": ["planks", "棺材板要加大碼，我扁咗好闊。", "棺材板要加大碼，我被踩扁了很寬。"],
}
STORY_JOIN = ["afu", "xiaozhi", "eguiking", "toyol", "laojiang", "pontianak", "pocong", "penanggal", "baiwu", "heiwu", "mengpo", "tianhua"]
# 劇情鬼所屬章（0 起計，用嚟計招降費）
STORY_CH = {"xiaozhi": 0, "eguiking": 0, "toyol": 1, "tianhua": 1, "laojiang": 2, "pontianak": 3, "pocong": 4, "penanggal": 4, "baiwu": 5, "heiwu": 5, "mengpo": 5, "pg_landlady": 5}

out = {"v": 2, "note": "soul 線：品級、據點駐守臨時表（counter.json guard 優先）、心願供品；數值見 soul_data.gd 頂部",
       "PIN": PIN, "CAMP": CAMP, "WISH": WISH, "STORY_JOIN": STORY_JOIN, "STORY_CH": STORY_CH, "TMP_SUB": TMP_SUB, "CAMP_PLAN": CAMP_PLAN, "CAMP_EN": CAMP_EN, "CAMP_EN_PLAN": CAMP_EN_PLAN, "NEW": NEWG}
p = os.path.join("data", "nat", "soul.json")
with open(p, "w", encoding="utf-8") as f: json.dump(out, f, ensure_ascii=False, indent=1)
# 驗：每隻非劇情鬼起碼 1 個主魂據點
src = {}
for k, g in CAMP.items(): src.setdefault(g, []).append(k)
import collections
print("pin", dict(collections.Counter(PIN.values())))
miss = [k for k in PIN if k not in src and k not in STORY_JOIN and k not in NEWG]
print("wrote", p, "camps", len(CAMP), "ghosts with camp", len(src), "missing", miss)
