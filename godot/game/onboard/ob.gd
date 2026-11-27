# [onboard] 第一章新手節奏（策劃組方案 claude/HC_GhostBattles_Ch1_Onboarding_Plan_20261127.md，老闆 11-27 拍板）
# 冇 class_name、冇 autoload（熱更新規矩）：用 load("res://game/onboard/ob.gd") 叫 static func。
#
# 做咩：
#  1. 主線前段重排（apply）：先站穩村子再拓展——
#     砍樹→割稻→棺材鋪→做板→包子鋪（小紙到埗）→包普通包子→派小紙打工→伐木場 2 級→升 3 級（大排檔解霧）
#     →大排檔賣 10 件貨→擊退第一次搗亂（固定劇本小波）→出村迎戰 1-1 → 之後照舊。
#     J.G.QUESTS（任務進度用）同 DB.D.QUESTS 兩份一齊改；冪等（已有 "sell" 任務＝已改）。
#  2. 舊存檔（S.qv < 4）：按舊清單位置對應新位置（已過嘅唔重播、唔重新上鎖），S.ob.old = 1 唔出教程。
#  3. 階段 stage()：0 序章、1 接手、2 棺材鋪、3 包子鋪＋小紙、4 站穩、5 大排檔、6 第一次守夜、7 出村、8 之後。
#  4. 功能鎖：底部導航「鬼怪」（階段 3 前）、「箱子」（階段 4 前）、「地盤」（階段 7 前）；
#     告急／惡鬼襲擾／偷嘢＝打低餓鬼王（1-3）之前都當新手保護；鬼潮 1-3 之前溫和（間隔長、隻數少、冇頭目）。
#  5. 固定劇本小波（guard）：三隻弱孤魂，打低先過關；輸咗冇懲罰（新手保護唔偷唔嚇）。
#  6. 新劇情（粵語原句＋LANG_ZH 中文）：ob_arrive／ob_coffin／ob_village／ob_market／ob_guard。
extends RefCounted

const QV := 4
const GUARD_N := 3
const GENTLE_GAP := 480.0   # 1-3 之前鬼潮間隔（秒）
const GENTLE_SIZE := 2      # 1-3 之前鬼潮隻數（冇頭目）

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func yue() -> bool: return DB.lang == "yue"
static func T(y: String, z: String) -> String: return DB.N(y if yue() else z)

static func _ob(s = null) -> Dictionary:
	if s == null: s = S()
	if s == null: return {}
	if not (s.get("ob") is Dictionary): s["ob"] = {}
	return s.ob
static func _cnt(k: String) -> float:
	var s = S()
	if s == null or not (s.get("cnt") is Dictionary): return 0.0
	return J.num(s.cnt.get(k, 0))
static func bump(k: String, n := 1.0) -> void:
	var s = S()
	if s == null: return
	if not (s.get("cnt") is Dictionary): s["cnt"] = {}
	s.cnt[k] = J.num(s.cnt.get(k, 0)) + n

# ================= 1. 主線重排 =================
static func _key(q) -> String:
	if not (q is Dictionary): return ""
	var t = str(q.get("t", ""))
	if q.get("b") != null: return t + ":" + str(q.b)
	if q.get("s") != null: return t + ":" + str(q.s)
	if q.get("n") != null: return t + ":" + str(int(J.num(q.n)))
	return t

const EARLY := ["chop:3", "rice:3", "build:plank", "craftPlank:3", "build:bun", "craftBun:3", "assign:1", "bLevel:wood", "level:3", "sell:10", "guard:3", "stage:1-1"]
const MOVED := ["assign:1", "bLevel:wood"]

static func _new_q(k: String) -> Dictionary:
	match k:
		"sell:10": return {"t": "sell", "n": 10.0, "text": "大排檔賣出 10 件貨、賺 40 冥幣", "go": "market", "r": {"exp": 40.0, "coins": 60.0}, "onStart": ["ob_market"],
			"note": "遊魂食飽會再嚟，記得櫃台要有貨"}
		"guard:3": return {"t": "guard", "n": float(GUARD_N), "text": "擊退第一次嚟搗亂嘅孤魂", "go": "market", "r": {"exp": 40.0, "troops": 30.0}, "onStart": ["ob_guard"],
			"note": "之後鬼會不定時嚟，派鬼守夜同陰兵會自動幫你守"}
	return {}

static func _patch_list(Q) -> void:
	if not (Q is Array) or Q.is_empty(): return
	for q in Q: if q is Dictionary and str(q.get("t", "")) == "sell": return   # 已改
	var by := {}
	for q in Q:
		var k = _key(q)
		if k in EARLY and not by.has(k): by[k] = q
	for k in EARLY:
		if not by.has(k): by[k] = _new_q(k)
		if (by[k] as Dictionary).is_empty(): return   # 清單唔似預期：唔郁（安全）
	var rest = []
	for q in Q:
		var k = _key(q)
		if k in EARLY and by.get(k) == q: continue
		rest.append(q)
	# 文字＋獎勵（只改前段）
	by["craftBun:3"]["text"] = "在包子鋪親手包 3 次普通包子"
	by["assign:1"]["text"] = "派小紙去包子鋪打工"; by["assign:1"]["go"] = "bun"
	by["bLevel:wood"]["onStart"] = ["ob_village"]
	by["build:plank"]["onStart"] = ["ob_coffin"]
	by["level:3"]["note"] = "村裡的遊魂自願當陰兵（陰兵 +60）；出村門外的大排檔開放了"
	Q.clear()
	for k in EARLY: Q.append(by[k])
	for q in rest: Q.append(q)

static var _done := false
static func apply() -> void:
	var a = J.G.get("QUESTS"); var b = DB.D.get("QUESTS")
	_patch_list(a)
	if b != null and b != a: _patch_list(b)
	if _done: return
	_done = true
	_add_scenes()

# 舊清單（未重排，冇 visit）位置 → 新位置
static func map_old_qi(old: int) -> int:
	if old <= 5: return old
	if old == 6: return 6        # 升 3 級中 → 先做派工（小紙已到）
	if old == 7: return 11       # 出村 1-1 中（大排檔已開）
	if old == 8: return 12       # 升 4 級
	if old == 9: return 13       # 派 1 隻鬼（已搬去前段）→ 1-2
	if old == 10: return 13      # 1-2
	if old == 11: return 14      # 伐木場 2 級（已搬去前段）→ 鬼怪 6 級
	return old + 2

static func migrate(s, fresh: bool) -> void:
	if s == null: return
	apply()
	var ob = _ob(s)
	if fresh:
		s["qv"] = QV; return
	if int(J.num(s.get("qv", 1))) >= QV: return
	var old = int(J.num(s.get("qi", 0)))
	s["qi"] = map_old_qi(old)
	s["qv"] = QV
	if old > 0 or J.t(s.get("seen", {}).get("prologue_sys")): ob["old"] = 1   # 舊玩家：唔出教程、唔重播

# ================= 2. 階段 =================
static func qi() -> int:
	var s = S(); return int(J.num(s.get("qi", 0))) if s != null else 0
static func stage() -> int:
	var s = S()
	if s == null: return 8
	if J.t(J.gp(s.get("cleared", {}), "1-1")): return 8
	if not J.t(J.gp(s.get("seen", {}), "prologue_sys")) and qi() == 0: return 0
	var i = qi()
	if i < 2: return 1
	if i < 4: return 2
	if i < 7: return 3
	if i < 9: return 4
	if i == 9: return 5
	if i == 10: return 6
	if i == 11: return 7
	return 8
static func old_save() -> bool: return J.t(_ob().get("old"))
# 其他測試（GB_TEST）唔受新手鎖影響；onboard_test 設 S.ob.test = 1 先開
static func active() -> bool: return not OS.has_environment("GB_TEST") or J.t(_ob().get("test"))
static func boss_done() -> bool:
	var s = S(); return s == null or J.t(J.gp(s.get("cleared", {}), "1-3"))

# 底部導航鎖：回 "" ＝ 開咗
static func tab_lock(t: String) -> String:
	if not active() or old_save(): return ""
	var st = stage()
	if t == "roster" and st < 3: return T("重建包子鋪、小紙到咗之後開放", "重建包子鋪、小紙到了之後開放")
	if t == "chest" and st < 4: return T("村子派工上手之後開放", "村子派工上手之後開放")
	if t == "battle" and st < 7: return T("大排檔開張、守過第一夜之後開放", "大排檔開張、守過第一夜之後開放")
	return ""

# 告急／惡鬼襲擾／偷嘢：打低餓鬼王之前當新手保護
static func calm() -> bool: return active() and not boss_done()

# ================= 3. 任務進度（新類型） =================
static func progress(q) -> Array:
	var t = str(J.gp(q, "t")); var n = J.num(J.gp(q, "n"))
	if t == "sell": _starter()
	if t == "sell": return [minf(minf(n, _cnt("ob_sold")), floor(n * _cnt("ob_earn") / SELL_COINS)), n]   # 件數同冥幣兩樣都要夠
	if t == "guard": return [minf(n, _cnt("ob_guard")), n]
	return []

# 開張第一籠：做緊賣貨任務、新流程（唔係舊存檔）就送一次 10 個普通包子落倉（ob_market 小紙講明），唔使等包子鋪慢慢出
const STARTER_BAO := 10.0
static func _starter() -> void:
	var ob = _ob()
	if ob.is_empty() or J.t(ob.get("starter")) or old_save() or not active(): return
	ob["starter"] = 1.0
	load("res://game/outpost/mat.gd").add("m_bao", STARTER_BAO)
const SELL_COINS := 40.0   # 前期貨價約 4 冥幣：10 件≈40，唔使磨
static func on_sold(n: int, amt := 0.0) -> void:
	if not guard_on() and _sell_on():
		if n > 0: bump("ob_sold", float(n))
		if amt > 0: bump("ob_earn", amt)
static func _sell_on() -> bool:   # 只計做緊「賣貨」任務期間（之前大排檔未開；之後唔使計）
	var Q = J.G.get("QUESTS"); var i = qi()
	return Q is Array and i < Q.size() and str(J.gp(Q[i], "t")) == "sell"

# 小紙提前到：包子鋪起好就送（唔再等主公 4 級）；lv4＝舊玩家後備（any=true：唔理包子鋪）
static var xz_queued := false
static func xz_due(any := false) -> bool:
	var s = S()
	if s == null or xz_queued or J.t(J.gp(s.get("seen", {}), "gift_xiaozhi")): return false
	for g in J.iter(s.get("ghosts", [])):
		if J.str(J.gp(g, "k")) == "xiaozhi": return false
	if any: return true
	return J.num(J.gp(s.get("bld", {}), "bun")) > 0 and stage() >= 3

# ================= 4. 固定劇本小波 =================
static func guard_on() -> bool:
	var s = S()
	if s == null: return false
	var Q = J.G.get("QUESTS"); var i = qi()
	return Q is Array and i < Q.size() and str(J.gp(Q[i], "t")) == "guard"
# mv_sim._step_foes 每格叫：未出就出三隻弱孤魂（喺大排檔圍欄外）
static func guard_step(sim, dt := 0.016) -> void:
	if not guard_on(): return
	var ob = _ob()
	var alive = 0
	for f in sim.foes: if f.get("ob") and f.st != "die": alive += 1
	var need = GUARD_N - int(_cnt("ob_guard")) - alive
	if need <= 0: return
	var cd = float(ob.get("gcd", 0.0))
	if cd > 0.0: ob["gcd"] = cd - dt; return
	if sim.spawn_foe():
		var f = sim.foes[sim.foes.size() - 1]
		f["ob"] = true; f["k"] = "youhun"
		var hp = maxf(8.0, MD().foe_hp(sim.ci()) * 0.45); f.hp = hp; f.mx = hp
		f["calm"] = 1.0
		ob["gcd"] = 1.2
static func guard_kill(f: Dictionary) -> void:
	if f.get("ob"): bump("ob_guard")
static func MD(): return load("res://game/outpost/mv_data.gd")

# ================= 5. 新劇情 =================
const SC := {
	"ob_arrive": {"style": "talk", "bg": "village", "title": "落魄村", "lines": [
		["黑無常", "就係呢度。落魄村，由今晚起歸你管。", "就是這裡。落魄村，從今晚起歸你管。"],
		["白無常", "村長個位冇人坐，你坐。冇人工嘅。", "村長的位子沒人坐，你來坐。沒有薪水的。"],
		["阿福", "……成條村，得一片槐樹林同兩塊荒田？", "……整條村，只有一片槐樹林和兩塊荒田？"],
		["黑無常", "仲有你。", "還有你。"],
		["旁白", "黑白無常一轉身，就消失喺霧入面。", "黑白無常一轉身，就消失在霧裡。"],
		["系統", "親，新官上任，先睇吓家當～斬三棵槐樹熱吓身啦！", "親，新官上任，先看看家當～砍三棵槐樹熱熱身吧！"]]},
	"ob_coffin": {"style": "talk", "bg": "village", "lines": [
		["系統", "親，睇吓嗰塊木牌——「棺材鋪，可重建」！有木就有板，有板就有屋。", "親，看看那塊木牌——「棺材鋪，可重建」！有木就有板，有板就有房子。"],
		["阿福", "我上世連張摺櫈都裝唔好。", "我上輩子連一張摺凳都組不好。"],
		["系統", "唔緊要，死咗之後隻手穩好多～做好嘅板會自動入倉，頂欄睇得到。", "沒關係，死了之後手穩多了～做好的板會自動入倉，頂欄看得到。"]]},
	"ob_village": {"style": "talk", "bg": "village", "lines": [
		["遊魂", "咦？呢度又有人開工？上一任村長做到散咗喎。", "咦？這裡又有人開工？上一任村長做到散掉了喔。"],
		["阿福", "咁我盡量唔好散。", "那我盡量不要散。"],
		["遊魂", "你派咗隻紙公仔去包包？佢包得幾靚喎。", "你派了個紙娃娃去包包子？她包得挺好看的。"],
		["系統", "親，派咗鬼嘅建築，你行開都照做～下一步：升級伐木場，斬樹唔使你親自落手！", "親，派了鬼的建築，你走開也照樣做～下一步：升級伐木場，砍樹不用你親自動手！"]]},
	"ob_market": {"style": "talk", "bg": "village", "title": "村口有鬼排隊", "lines": [
		["旁白", "包子鋪嘅煙飄出村口。一班遊魂喺門口排起隊。", "包子鋪的煙飄出村口。一群遊魂在門口排起了隊。"],
		["遊魂", "聽講你哋有包食？我哋好耐冇食過熱嘢喇。", "聽說你們有包子吃？我們很久沒吃過熱的東西了。"],
		["阿福", "……我死咗都要做生意？", "……我死了還要做生意？"],
		["小紙", "出村口嗰個大排檔，嘆氣蒸籠可以將普通包子蒸成壽包，佢哋最鍾意。", "出村口那個大排檔，嘆氣蒸籠可以把普通包子蒸成壽包，他們最喜歡。"],
		["小紙", "我包咗一籠普通包子攞咗過去，夠你開張先。", "我包了一籠普通包子拿過去了，夠你先開張。"],
		["系統", "親，有需求就有市場！客人頭上個泡泡就係佢要嘅貨，櫃台有貨佢就會攞，俾錢就有冥幣～", "親，有需求就有市場！客人頭上的泡泡就是他要的貨，櫃台有貨他就會拿，付錢就有冥幣～"]]},
	"ob_guard": {"style": "talk", "bg": "village", "title": "第一夜", "lines": [
		["旁白", "大排檔收檔前，圍欄外面有三隻瘦孤魂聞到包子香，搖住欄杆。", "大排檔收攤前，圍欄外面有三隻瘦孤魂聞到包子香，搖著欄杆。"],
		["小紙", "佢哋……好似好肚餓。", "他們……好像很餓。"],
		["阿福", "肚餓就排隊買嘛，搖欄杆做咩？", "餓了就排隊買嘛，搖欄杆幹嘛？"],
		["系統", "偵測到外敵！保護資產就係保護 KPI！撳佢哋，打走佢哋！", "偵測到外敵！保護資產就是保護 KPI！點牠們，把牠們打走！"]]},
}

static func _add_scenes() -> void:
	var SCN = DB.D.get("SCENES")
	var JS = J.G.get("SCENES")
	var ZH = DB.D.get("LANG_ZH")
	if not (ZH is Dictionary): ZH = {}; DB.D["LANG_ZH"] = ZH
	var add = {}
	for id in SC:
		var src: Dictionary = SC[id]
		var lines = []
		for l in src.lines:
			lines.append([l[0], l[1]])
			add[l[1]] = l[2]
			if not ZH.has(l[1]): ZH[l[1]] = l[2]
		var sc = {"style": src.style, "bg": src.get("bg", "village"), "lines": lines}
		if src.has("title"): sc["title"] = src.title
		if SCN is Dictionary and not SCN.has(id): SCN[id] = sc
		if JS is Dictionary and JS != SCN and not JS.has(id): JS[id] = sc.duplicate(true)
	var LANG = J.G.get("LANG")
	if LANG != null: J.mc(LANG, "add", [add])
	# 劇情回顧：加入序章之後
	var SO = DB.D.get("SCENE_ORDER")
	if SO is Array:
		var has = false
		for e in SO: if e is Array and str(e[0]).begins_with("第一夜"): has = true
		if not has:
			var at = mini(1, SO.size())
			SO.insert(at, ["第一夜・接手落魄村", ["ob_arrive", "ob_coffin", "ob_village", "ob_market", "ob_guard"]])

# 序章完：接手落魄村劇情（只播一次；舊玩家唔播）
static var arrive_q := false
static func arrive_due() -> bool:
	var s = S()
	if s == null or arrive_q or old_save(): return false
	var seen = s.get("seen", {})
	return J.t(J.gp(seen, "prologue_sys")) and not J.t(J.gp(seen, "ob_arrive")) and qi() == 0

# ================= 6. 教程步驟（每個任務一步；說明 ≤ 2 行） =================
const TIPS := {   # 每行 ≤ 18 個字（手機闊度＋「跳過此步」掣）
	"chop": ["撳槐樹，斬 3 棵", "點槐樹，砍 3 棵"],
	"rice": ["撳糯米田，割 3 次", "點糯米田，收割 3 次"],
	"build:plank": ["撳「棺材鋪」木牌，重建", "點「棺材鋪」木牌，重建"],
	"craftPlank": ["撳棺材鋪 →「親手做」\n4 槐木做 2 塊棺材板", "點棺材鋪 →「親手做」\n4 槐木做 2 塊棺材板"],
	"build:bun": ["撳「包子鋪」木牌，重建", "點「包子鋪」木牌，重建"],
	"craftBun": ["撳包子鋪 →「親手做」\n4 糯米包 2 個普通包子", "點包子鋪 →「親手做」\n4 糯米包 2 個普通包子"],
	"assign": ["撳包子鋪 →「派人」→ 揀小紙\n員工親手做；領班只幫手開工", "點包子鋪 →「派人」→ 選小紙\n員工親手做；領班只幫忙開工"],
	"bLevel:wood": ["撳伐木場 →「升級」\n派咗鬼，你行開都照做", "點伐木場 →「升級」\n派了鬼，你走開也照做"],
	"level": ["繼續斬樹、割稻、做貨\n好評滿就升級", "繼續砍樹、割稻、做貨\n好評滿就升級"],
	"sell": ["撳嘆氣蒸籠蒸壽包\n客人頭上泡泡＝要嘅貨", "點嘆氣蒸籠蒸壽包\n客人頭上泡泡＝要的貨"],
	"guard": ["撳圍欄外嘅孤魂，打走佢哋", "點圍欄外的孤魂，把牠們打走"],
	"stage:1-1": ["撳「出擊」，出村迎戰 1-1", "點「出擊」，出村迎戰 1-1"],
}
static func tip_of(q) -> String:
	if not (q is Dictionary): return ""
	var t = str(q.get("t", "")); var k = _key(q)
	for kk in [k, t + ":" + str(q.get("b", "")), t]:
		if TIPS.has(kk): return T(TIPS[kk][0], TIPS[kk][1])
	return ""
static func tut_on() -> bool:
	if not active(): return false
	if old_save() or stage() < 1 or stage() > 7: return false
	var Q = J.G.get("QUESTS"); var i = qi()
	if not (Q is Array) or i >= Q.size(): return false
	return not J.t(J.gp(_ob().get("skip", {}), _key(Q[i])))
static func tut_skip() -> void:
	var Q = J.G.get("QUESTS"); var i = qi()
	if not (Q is Array) or i >= Q.size(): return
	var ob = _ob()
	if not (ob.get("skip") is Dictionary): ob["skip"] = {}
	ob.skip[_key(Q[i])] = 1
