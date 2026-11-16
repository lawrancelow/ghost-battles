# 原生改寫自 rivals.js：三個死對頭——龐總（察 KPI）、Bryan（偷功勞＋搬弄是非＋最後決鬥）、冼小姐（HR）
# 同陰間日常共用排程（Skits.tick 每秒問 Rivals.tick()）；全部可以跳過；懲罰細、有聰明選擇避開
# 存檔：S.antag（見 st()）。介面同轉譯版一樣：J.G["Rivals"] = { st, tick, credit, hud, demo, taskProg, HR_EV, ABSURD, TASKS, ROUNDS, RUMORS, BRYAN_CLAIM, BOSS_OPEN, BOSS_PASS, BOSS_FAIL, NM, ART }
# 同網頁版唯一分別（2026-11-16 故事聖經 v2）：主線巡陰 beats 已經播過（S.sq.beat_c1_kpi／beat_c1_bryan／beat_c2_hr），首次到訪就用「之前見過」嘅開場
extends RefCounted

const ART := {"boss": "npc_kpiboss", "rival": "npc_rival", "hr": "npc_hr"}
const NM := {"boss": "龐總", "rival": "Bryan", "hr": "冼小姐"}
const GAP := 360.0
const REVIEW_GAP := 45.0
const LOOK := {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}, "Bryan": {"base": "ag:spin", "talk": "ag:dribble"}, "冼小姐": {"base": "ag:clip", "talk": "ag:glasses"}}
const TASK_ORDER := ["chop", "rice", "bun", "plank", "stock", "stage"]
const TASK_INFO := {
	"chop": {"m": 5.0, "unit": "棵", "what": "親手砍槐樹"}, "rice": {"m": 5.0, "unit": "次", "what": "親手收割糯米"},
	"bun": {"m": 6.0, "unit": "次", "what": "親手包壽包"}, "plank": {"m": 6.0, "unit": "次", "what": "親手做棺材板"},
	"stock": {"m": 7.0, "unit": "個", "what": "倉庫存有壽包", "abs": true}, "stage": {"m": 10.0, "unit": "關", "what": "打通新關卡"},
}
const ABSURD := [
	{"ask": "下個月，全村 KPI 要增長三百個巴仙。", "smart": "「龐總，咁上個月嘅 baseline 係幾多？」", "dodge": [["龐總", "（睇平板）落魄村上個月啱啱開張……baseline 係零。"], ["阿福", "零嘅三倍係幾多？"], ["龐總", "……我返去 align 一下。"]]},
	{"ask": "由今日起，全村鬼要朝九晚五返工。", "smart": "「冇問題，朝九晚五：晚上九點到朝早五點。」", "dodge": [["龐總", "……即係同而家一樣？"], ["阿福", "一樣。不過而家有制度。"], ["龐總", "好。我要寫入報告：已落實制度化。"]]},
	{"ask": "每隻鬼每日要交一份手寫日報，一式三份。", "smart": "「要紙，紙要燒落嚟，燒要冥幣。預算批咗未？」", "dodge": [["龐總", "預算……"], ["阿福", "冇預算，就冇紙。冇紙，就冇日報。"], ["龐總", "（收埋平板）呢個 project，下季再議。"]]},
	{"ask": "我要你哋 work harder，同時 work smarter，同時 work-life balance。", "smart": "「三樣揀兩樣。龐總你揀邊兩樣？」", "dodge": [["龐總", "……harder 同 smarter。"], ["阿福", "咁 balance 呢？"], ["龐總", "……smarter 同 balance。"], ["阿福", "咁 harder 呢？"], ["旁白", "龐總站在原地想了一個鐘頭，想到下班。"]]},
	{"ask": "清明之前，我要見到陽間家屬滿意度提升。", "smart": "「好，我叫家屬填問卷。問卷燒落嚟，答案燒返上去，每份手續費你批？」", "dodge": [["龐總", "燒返上去要幾多手續費？"], ["阿福", "陰陽兩界轉賬費，一成半。"], ["龐總", "……滿意度呢個指標，我決定唔追。"]]},
]
const BOSS_OPEN := ["又係我。唔使驚，驚都冇用，數字唔會因為你驚而升。", "突擊巡查。我唔預約，預約咗你哋就會準備，準備咗啲數就唔真。", "我順路經過。通常我順路經過嘅地方，都會順手裁人。", "我今日心情好，所以只係察 KPI，唔係察你。"]
const BOSS_PASS := [[["龐總", "（望住平板好耐）……達標。我唔會讚你，讚咗你下季就鬆懈。"]], [["龐總", "做到。好，下季目標我加倍——呢個係對你嘅肯定。"]], [["龐總", "合格。唔好笑。你一笑，我就覺得目標定得太低。"]], [["龐總", "……過關。（細細聲）點解每個都過關嘅？係咪我太善良？"]]]
const BOSS_FAIL := [[["龐總", "未達標。你知唔知，你嘅效率輸畀殭屍跳？佢哋膝頭都唔識彎㗎。"]], [["龐總", "差少少。我哋公司冇「差少少」呢個欄位，只有「得」同「你」。"]], [["龐總", "你生前過勞死，死咗又唔過勞。你自己諗吓邊樣比較失禮。"]], [["龐總", "我見過好多冇用嘅員工。你係第一個，冇用得咁有規律。"]]]
const BOSS_FIRST := [["旁白", "一隻矮矮胖胖、頭髮梳得發亮的鬼，拿著一部平板飄進村子。平板上，一條紅線一路向下。"], ["龐總", "阿福。我係地府集團營運總監，龐總。我唔係針對你，我係針對你嘅數字。"]]
# 巡陰時已經見過龐總（beat_c1_kpi）
const BOSS_MET := [["旁白", "龐總又飄進村子。平板上那條紅線，比上次又跌深了一截。"], ["龐總", "阿福。上次巡陰定落嘅 KPI，我記住。今日我唔係針對你，我係針對你嘅數字。"]]
const BRYAN_CLAIM := [
	"兄弟！頭先（{w}），好在有我幫你 cover 住。呢球，我入嘅。",
	"Bro～恭喜晒！不過頭先（{w}），其實係我助攻。助攻都計分㗎嘛。",
	"嘩，{w}！我哋做得好呀！我已經同上面報咗，寫我個名先，方便啲嘛。",
	"{w}？呢個 play 係我喺白板度畫嘅。你只係照住跑啫，兄弟。",
]
const ALIBI := ["茶水間度練緊三分波", "廁所度影緊 selfie", "同冼小姐飲緊下午茶", "天台度同龐總影緊合照"]
const BRYAN_LOSE := [["Bryan", "……呢個係假波！我要睇重播！"]]
const BRYAN_RUN := ["好，好，今次當我傳失波。", "你哋玩得咁認真，冇 team spirit 㗎。", "我去熱吓身先，你哋繼續。"]
const BRYAN_FIRST := [["旁白", "一隻高高瘦瘦、留著銀灰色平頭的鬼，一邊拍著籃球一邊飄過來。"], ["阿福", "……Bryan？你點會喺度？"],
	["Bryan", "兄弟！好耐冇見！上個月公司籃球賽，我入咗個 slam dunk，太興奮，就落咗嚟。"], ["Bryan", "而家我喺地府集團做業務拓展。我哋又係同事喇！"],
	["阿福", "（細細聲）生前佢坐我隔籬。我做嘅 report，佢 present。"]]
# 巡陰時已經喺槐林邊見過 Bryan（beat_c1_bryan）
const BRYAN_MET := [["旁白", "籃球拍地的聲音，從村口一路傳進來。"], ["阿福", "……又係你。"],
	["Bryan", "兄弟！上次槐林邊一別，我日日都掛住你——掛住你嘅功勞。"],
	["阿福", "（細細聲）生前佢坐我隔籬。我做嘅 report，佢 present。死咗都冇變。"]]
const RUMORS := [
	"{n}，我唔係想搬弄是非，不過阿福話你做嘢慢過殭屍跳。我淨係轉述，我好中立㗎。",
	"{n}，聽講下季你個位要俾 AI 取代。唔好話我講㗎，我只係 pass 個波俾你。",
	"{n}，你知唔知全村個個都加咗人工？淨係你冇。我都係為你不值啫。",
	"{n}，阿福私底下話，你係全村最易替代嘅鬼。佢原話係：「隨便搵隻都得。」",
]
const HURT := ["……少爺真係咁講？", "（手上啲嘢跌晒落地）", "我……我做咗咁耐……", "原來我喺佢心目中係咁……"]
const ROUNDS := [
	{"tell": "呢球我唔使郁，自然有人傳俾我。", "q": "第一球：Bryan 守在籃下一動不動。", "right": "自己運球上籃，不傳球", "wrong": "傳給隊友", "win": [["旁白", "阿福自己運球上籃。Bryan 在籃下等了整場，沒人傳球給他。"]], "lose": [["旁白", "球一傳出去，就被 Bryan 截走：「多謝助攻！」"]]},
	{"tell": "你掂我一下，我即刻搵冼小姐。", "q": "第二球：Bryan 衝了過來。", "right": "站定不動，等他自己衝過來", "wrong": "貼身防守", "win": [["旁白", "Bryan 衝過來，發現沒人可撞，自己摔在地上。冼小姐舉起印章，無處可蓋。"]], "lose": [["旁白", "阿福一貼身，Bryan 立刻倒地。冼小姐蓋印：「犯規～」"]]},
	{"tell": "龐總望緊，呢球我一定要入。", "q": "最後一球：Bryan 望著場邊的龐總起跳。", "right": "請龐總看看平板上的數據", "wrong": "跳起來封阻", "win": [["旁白", "龐總一低頭看平板，就沒人看著 Bryan 了。他一慌，球連籃框都沒碰到。"]], "lose": [["旁白", "Bryan 比阿福高一個頭，假動作騙阿福起跳，再慢慢把球放進去。"]]},
]
const HR_INTRO := [["旁白", "一隻梳著髮髻、戴著貓眼眼鏡的女鬼飄進村子，手拿文件夾，腰間掛著一個大紅印。她的笑容很標準，標準得像是印上去的。"], ["冼小姐", "親愛嘅同事～我係人力資源部冼小姐。由今日起，落魄村納入集團員工手冊管理。"], ["冼小姐", "溫馨提示：手冊有三千頁。冇睇過，唔係藉口。"]]
# 巡陰時已經見過冼小姐（beat_c2_hr：出差申請表）
const HR_MET := [["旁白", "冼小姐又飄進村子，文件夾比上次厚了一倍。"], ["冼小姐", "親愛嘅同事～上次你話唔知要交出差申請表。今日正式通知：落魄村由今日起，全面納入集團員工手冊管理。"], ["冼小姐", "溫馨提示：手冊仍然係三千頁。上次冇睇，今次都唔係藉口。"]]
const ZH_NEW := {
	"阿福。上次巡陰定落嘅 KPI，我記住。今日我唔係針對你，我係針對你嘅數字。": "阿福。上次巡陰定下的 KPI，我記著。今天我不是針對你，我是針對你的數字。",
	"……又係你。": "……又是你。",
	"兄弟！上次槐林邊一別，我日日都掛住你——掛住你嘅功勞。": "兄弟！上次槐林邊一別，我天天都想著你——想著你的功勞。",
	"（細細聲）生前佢坐我隔籬。我做嘅 report，佢 present。死咗都冇變。": "（小聲）生前他坐我隔壁。我做的 report，他來 present。死了也沒變。",
	"親愛嘅同事～上次你話唔知要交出差申請表。今日正式通知：落魄村由今日起，全面納入集團員工手冊管理。": "親愛的同事～上次你說不知道要交出差申請表。今天正式通知：落魄村從今天起，全面納入集團員工手冊管理。",
	"溫馨提示：手冊仍然係三千頁。上次冇睇，今次都唔係藉口。": "溫馨提示：手冊還是三千頁。上次沒看，這次也不是藉口。",
}

static var HR_EV: Array = []
static var last_cleared := -1.0

static func _g(n: String): return J.G.get(n)
static func _S(): return _g("S")
static var r_override = null   # Callable：對照測試固定隨機數
static func R() -> float: return float(r_override.call()) if r_override is Callable else randf()
static func art(k) -> bool:
	var f = _g("sprOk")
	return f == null or J.t(J.cl(f, null, [k]))
static func seen(id: String) -> bool:
	var S = _S()
	return J.t(S) and J.t(J.gp(S, "seen")) and J.t(J.gp(J.gp(S, "seen"), id))
static func beat_done(id: String) -> bool:   # 主線巡陰 beat 播過未（任務系統 S.sq.beat_<id>）
	var S = _S(); var sq = J.gp(S, "sq") if J.t(S) else null
	return J.t(sq) and J.t(J.gp(sq, "beat_" + id))
static func now() -> float: return J.num(J.S_Date_("now", []))
static func mins(ms: float) -> float: return maxf(1.0, floor(ms / 60000 + 0.5))
static func rwd(n: float) -> float: return J.num(J.cl(_g("rwd"), null, [n]))
static func give(r: Dictionary) -> String: return J.str(J.cl(_g("give"), null, [r]))
static func L(s) -> String: return J.str(J.cl(_g("L"), null, [s]))
static func Lf(s, v: Dictionary) -> String: return J.str(J.cl(_g("Lf"), null, [s, v]))
static func _assign(base: Dictionary, cur) -> Dictionary:
	var r = base.duplicate(true)
	if cur is Dictionary: for k in cur: r[k] = cur[k]
	return r

static func st():
	var S = _S()
	if not J.t(S): return null
	if not J.t(J.gp(S, "antag")): J.sp(S, "antag", {})
	var a = J.gp(S, "antag")
	a["clock"] = J.num(a.get("clock")) if J.t(a.get("clock")) else 0.0
	if not (a.get("gap") is float or a.get("gap") is int): a["gap"] = 200.0
	if not J.t(a.get("n")): a["n"] = {}
	a["boss"] = _assign({"task": null, "visits": 0.0, "pass": 0.0, "fail": 0.0, "slowUntil": 0.0}, a.get("boss"))
	a["rival"] = _assign({"met": false, "arc": 0.0, "pend": null, "rumor": null, "stolen": 0.0, "grudge": 0.0, "peaceUntil": 0.0, "beaten": false, "duels": 0.0}, a.get("rival"))
	a["hr"] = _assign({"met": false, "warn": 0.0, "visits": 0.0, "done": {}}, a.get("hr"))
	return a
# 台詞池：輪住用
static func rot(key: String, pool: Array):
	var a = st(); var i = (J.num(a.n.get(key)) if J.t(a.n.get(key)) else 0.0) + 1; a.n[key] = i
	return pool[int(i - 1) % pool.size()]
static func _has_any(t: String, words: Array) -> bool:
	for w in words: if t.contains(w): return true
	return false
static func deco(lines) -> Array:
	var out = []
	for l in J.iter(lines):
		if not (l is Array) or (l.size() > 2 and J.t(l[2])): out.append(l); continue
		var w = J.str(l[0]); var t = J.str(l[1]); var a = null
		if w == "冼小姐" and _has_any(t, ["蓋印", "批。", "駁回", "警告信"]): a = "ag:stamp"
		elif w == "龐總" and _has_any(t, ["未達標", "差少少", "失禮", "冇用"]): a = "ag:yell"
		elif w == "龐總" and _has_any(t, ["唔達標", "罰"]): a = "ag:sigh"
		elif w == "Bryan" and _has_any(t, ["轉述", "唔好話我講", "不值", "私底下", "細細聲"]): a = "ag:gossip"
		elif w == "Bryan" and _has_any(t, ["假波", "助攻！", "沖茶點計"]): a = "ag:jump"
		elif w == "Bryan" and _has_any(t, ["承讓", "我入嘅", "三分"]): a = "ag:jumpshot"
		if a != null: out.append([l[0], l[1], a] + l.slice(3))
		else: out.append(l)
	return out
static func wrap_c(c):
	if not J.t(c): return c
	for k in ["a", "b", "c"]:
		var o = c.get(k)
		if not J.t(o): continue
		o["lines"] = deco(o.get("lines") if J.t(o.get("lines")) else [])
		if J.t(o.get("on")):
			var on_ = o.on
			o["on"] = func(_t, a): var r = J.cl(on_, null, a); return deco(r) if r is Array else r
		if J.t(o.get("next")):
			var nx = o.next
			if J.typeof_(nx) == "function": o["next"] = func(_t, a): return wrap_c(J.cl(nx, null, a))
			else: o["next"] = wrap_c(nx)
	return c
static func play(sc: Dictionary, cb: Callable) -> void:
	var cast = []
	for c in sc.cast:
		if LOOK.has(J.str(c[0])):
			var opt = LOOK[J.str(c[0])].duplicate()
			if c.size() > 2 and c[2] is Dictionary: for k in c[2]: opt[k] = c[2][k]
			cast.append([c[0], c[1], opt])
		else: cast.append(c)
	sc["cast"] = cast
	sc["lines"] = deco(sc.lines)
	sc["choice"] = wrap_c(sc.get("choice"))
	J.mc(_g("Theater"), "play", [sc, func(_t, a): cb.call(J.arg(a, 0)); return null])
static func toast(h: String) -> void:
	var Fx = _g("Fx")
	if Fx != null: J.mc(Fx, "toast", [h])
static func done() -> void:
	var sv = _g("save"); if sv != null: J.cl(sv, null, [])
	var UI = _g("UI"); if UI != null: J.mc(UI, "refresh", [])

# ---------- 產量影響（包住 ratesPerMin）：龐總罰全村慢 15%；Bryan 謠言令被造謠嗰隻慢一半 ----------
static func install_rates() -> void:
	var orig = _g("ratesPerMin")
	if J.typeof_(orig) != "function": return
	J.G["ratesPerMin"] = func(this_, args):
		var r = J.cl(orig, this_, args); var S = _S(); var a = J.gp(S, "antag") if J.t(S) else null
		if not J.t(a): return r
		var ru = J.gp(J.gp(a, "rival"), "rumor") if J.t(J.gp(a, "rival")) else null
		if J.t(ru) and J.num(J.gp(ru, "until")) > now():
			var g = null
			for x in J.iter(J.gp(S, "ghosts")): if J.seq(J.gp(x, "id"), J.gp(ru, "gid")): g = x; break
			if g != null and J.t(J.gp(g, "post")):
				var p = J.gp(g, "post"); J.sp(g, "post", null); var wo = J.cl(orig, this_, args); J.sp(g, "post", p)
				for k in J.keys(r): J.sp(r, k, J.num(J.gp(wo, k)) + 0.5 * (J.num(J.gp(r, k)) - J.num(J.gp(wo, k))))
		if J.t(J.gp(a, "boss")) and J.num(J.gp(J.gp(a, "boss"), "slowUntil")) > now():
			for k in J.keys(r): J.sp(r, k, J.num(J.gp(r, k)) * 0.85)
		return r

# ===================== 龐總：察 KPI =====================
static func stage_open() -> bool:
	var CH = _g("CHAPTERS"); var B = _g("Battle"); var S = _S()
	if not J.t(CH) or B == null: return false
	var chs = J.iter(CH)
	for ci in chs.size():
		var stages = J.iter(J.gp(chs[ci], "stages"))
		for si in stages.size():
			var sid = J.mc(B, "sidOf", [float(ci), float(si)]); var stg = stages[si]
			if J.t(J.gp(J.gp(S, "cleared"), sid)): continue
			var prev = null
			if si > 0: prev = J.mc(B, "sidOf", [float(ci), float(si - 1)])
			elif ci > 0: prev = J.mc(B, "sidOf", [float(ci - 1), float(J.iter(J.gp(chs[ci - 1], "stages")).size() - 1)])
			var req = J.gp(stg, "req")
			if (prev == null or J.t(J.gp(J.gp(S, "cleared"), prev))) and req != null and J.num(J.gp(S, "lv")) >= J.num(req): return true
			return false
	return false
static func task_ok(k: String) -> bool:
	var S = _S()
	match k:
		"bun", "stock": return J.num(J.gp(J.gp(S, "bld"), "bun")) > 0
		"plank": return J.num(J.gp(J.gp(S, "bld"), "plank")) > 0
		"stage": return stage_open()
	return true
static func task_n(k: String) -> float:
	var S = _S()
	match k:
		"stock":
			var cap = J.num(J.mc(_g("F"), "cap", []))
			var rate = J.num(J.gp(J.cl(_g("ratesPerMin"), null, []), "buns"))
			return minf(floor(cap * 0.9), floor(J.num(J.gp(J.gp(S, "res"), "buns"))) + maxf(12.0, floor(rate * 4 + 0.5)))
		"stage": return 1.0
	return 3.0 + floor(R() * 3)
static func task_val(k: String) -> float:
	var S = _S()
	match k:
		"chop": return J.num(J.gp(J.gp(S, "cnt"), "chop"))
		"rice": return J.num(J.gp(J.gp(S, "cnt"), "rice"))
		"bun": return J.num(J.gp(J.gp(S, "cnt"), "craftBun"))
		"plank": return J.num(J.gp(J.gp(S, "cnt"), "craftPlank"))
		"stock": return floor(J.num(J.gp(J.gp(S, "res"), "buns")))
		"stage": return float(J.keys(J.gp(S, "cleared")).size())
	return 0.0
static func task_lines(k: String, n: float, m: float) -> Array:
	var v = {"n": n, "m": m}
	match k:
		"chop": return [["龐總", Lf("今次 KPI：{m} 分鐘之內，你親手斬 {n} 棵槐樹。唔准叫人幫，我要睇到你把斧頭有熱情。", v)], ["阿福", "斧頭點會有熱情？"], ["龐總", "所以先要你補返。"]]
		"rice": return [["龐總", Lf("{m} 分鐘之內，割 {n} 次糯米。糯米係本季戰略物資：殭屍好驚，投資者好鍾意。", v)], ["阿福", "投資者係邊個？"], ["龐總", "你唔使知。你淨係要知，佢哋唔開心。"]]
		"bun": return [["龐總", Lf("{m} 分鐘之內，你親手包 {n} 次壽包。", v)], ["阿福", "包子鋪有鬼包㗎。"], ["龐總", "佢哋包嘅係佢哋嘅 KPI。你包嘅，先係你嘅。"]]
		"plank": return [["龐總", Lf("{m} 分鐘之內，你親手做 {n} 次棺材板。", v)], ["阿福", "點解要我親手做？"], ["龐總", "棺材係我哋嘅核心產品。客戶一世人只用一次，所以唔准有第二次機會。"]]
		"stock": return [["龐總", Lf("我下次嚟嘅時候，倉入面要有 {n} 個壽包。少一個，我都會知。", {"n": n})], ["阿福", "你點會知？"], ["龐總", "（拍一拍部平板）佢話我知。"]]
		"stage": return [["龐總", "下次我嚟之前，你要打通一關新關卡。市場佔有率，係打返嚟嘅。"], ["阿福", "係真係打仗嚟㗎喎。"], ["龐總", "所以先叫市場。"]]
	return []

static func boss_visit() -> void:
	var a = st(); var b = a.boss; var first = not J.t(b.visits); b.visits = J.num(b.visits) + 1
	var cast = [["阿福", "afu"], ["龐總", ART.boss]]
	var open: Array = (BOSS_MET if beat_done("c1_kpi") else BOSS_FIRST).duplicate(true) if first else [["龐總", rot("bossOpen", BOSS_OPEN)]]
	if not first and R() < 0.3:   # 荒謬要求：揀得聰明就避開，仲有獎
		var d = rot("absurd", ABSURD); var smart_is_a = R() < 0.5
		var smart = {"label": d.smart, "lines": [["阿福", L(d.smart).replace("「", "").replace("」", "")]] + d.dodge.duplicate(true),
			"on": func(_t, _a): var t = give({"coins": rwd(18)}); return [["旁白", "阿福躲過了。" + t]]}
		var dumb = {"label": "「收到。」", "lines": [["阿福", "收到。"], ["龐總", "好。我就鍾意你呢種員工。"]],
			"on": func(_t, _a): b.slowUntil = now() + 5 * 60000; return [["旁白", "阿福一句「收到」，全村陪他加班。懲罰：全村工作速度 −15%（5 分鐘）。"]]}
		play({"tag": "察 KPI", "title": "龐總：要求", "bg": "village", "cast": cast, "lines": open + [["龐總", d.ask]], "choice": {"plain": true, "q": "龐總要求：" + L(d.ask), "a": smart if smart_is_a else dumb, "b": dumb if smart_is_a else smart}}, func(_r): done())
		return
	var kinds = TASK_ORDER.filter(func(k): return task_ok(k))
	var k = kinds[int(floor(R() * kinds.size()))]; var T = TASK_INFO[k]
	var n = task_n(k); var m = T.m
	b.task = {"k": k, "n": n, "base": 0.0 if T.get("abs", false) else task_val(k), "due": J.num(a.clock) + m * 60, "set": a.clock, "what": T.what, "unit": T.unit}
	play({"tag": "察 KPI", "title": "龐總：突擊巡查", "bg": "village", "cast": cast, "lines": open + task_lines(k, n, m) + [["旁白", "KPI：%s 分鐘內%s %s%s。進度見左下角。" % [J.str(m), T.what, J.str(n), T.unit]]]}, func(_r): done(); hud())
# 地府集團優化小組：半夜收到龐總訊息，終於可以已讀不回
static func boss_group() -> void:
	var a = st(); a.boss["group"] = 1.0
	var chat = {"style": "chat", "title": "地府集團優化小組", "group": "龐總、白無常、黑無常、阿福…", "av": ["優", "#6a3a3a"], "lines": [
		["龐總", "23:58|各位，由聽日起，每隻鬼每日要嚇夠三個人，計入 KPI"], ["白無常", "23:58|收到！一見生財！"], ["黑無常", "23:59|知道。"],
		["龐總", "00:01|仲有，聽朝大家提早半個鐘出嚟"], ["白無常", "00:02|龐總，我哋係鬼，朝早出唔到嚟喎"], ["龐總", "00:02|唔好俾藉口我"], ["龐總", "00:03|@阿福 你呢？"]]}
	var choice = {"plain": true, "q": "凌晨十二點零三分。龐總在等你回覆。",
		"a": {"label": "回覆：「收到。」", "lines": [["旁白", "手指比腦袋快，「收到」已經送出。"], ["旁白", "龐總秒回：「好。順便交埋份報告。」"]], "on": func(_t, _a): a.boss.slowUntil = now() + 4 * 60000; return [["旁白", "懲罰：全村陪你熬夜，工作速度 −15%（4 分鐘）"]]},
		"b": {"label": "已讀。不回。把手機放下。", "lines": [["旁白", "已讀，不回。"], ["旁白", "那是阿福做鬼以來，睡得最好的一個晚上。"]], "on": func(_t, _a): return [["旁白", "睡飽了：" + give({"coins": rwd(20), "exp": rwd(8)})]]}}
	if R() < 0.5: var x = choice.a; choice.a = choice.b; choice.b = x
	J.mc(_g("Story"), "queue", [chat, func(_t, _a):
		J.F_setTimeout([func(_t2, _a2): play({"tag": "察 KPI", "title": "已讀不回", "bg": "village", "cast": [["阿福", "afu", {"onstage": true}]], "lines": [["旁白", "阿福看著手機，手指在發抖。三年來，他每晚都是這樣，馬上回覆「收到」。"]], "choice": choice}, func(_r): done()); return null, 80.0])
		return null])
static func task_prog():
	var a = st(); var t = a.boss.task
	if not J.t(t): return null
	var v = task_val(J.str(t.k)) - J.num(t.base)
	return {"v": maxf(0.0, v), "n": t.n, "left": maxf(0.0, J.num(t.due) - J.num(a.clock))}
static func boss_review() -> void:
	var a = st(); var b = a.boss; var p = task_prog(); var passed = p.v >= J.num(p.n); var t = b.task; b.task = null
	var lines = [["龐總", Lf("嚟收數。KPI：{w} {n}{u}。你做到 {v}{u}。", {"w": t.what, "n": t.n, "u": t.unit, "v": minf(p.v, 999.0)})]]
	var S = _S()
	if passed:
		b["pass"] = J.num(b["pass"]) + 1; lines += rot("bossPass", BOSS_PASS).duplicate(true)
		var r = give({"coins": rwd(30), "exp": rwd(6)}); lines.append(["旁白", "達標獎勵：" + r])
	else:
		b.fail = J.num(b.fail) + 1; lines += rot("bossFail", BOSS_FAIL).duplicate(true)
		if int(b.fail) % 2:
			var c = minf(floor(J.num(S.res.coins)), rwd(20)); S.res.coins = J.num(S.res.coins) - c
			lines.append(["旁白", ("懲罰：冥幣 −" + J.str(c)) if c else "懲罰：冥幣——可惜你身上沒有冥幣。龐總在平板上記下：「此員工連罰都罰唔落。」"])
		else:
			b.slowUntil = now() + 5 * 60000; lines.append(["旁白", "懲罰：全村工作速度 −15%（5 分鐘）"])
	play({"tag": "察 KPI", "title": "龐總：收數（達標）" if passed else "龐總：收數（唔達標）", "bg": "village", "cast": [["阿福", "afu"], ["龐總", ART.boss]], "lines": lines}, func(_r): done(); hud())

# ===================== Bryan：偷功勞、搬弄是非、最後決鬥 =====================
static func smartest():
	var best = null; var v = -1.0
	for g in J.iter(J.gp(_S(), "ghosts")):
		if J.str(J.gp(g, "k")) == "afu": continue
		var x = J.num(J.mc(_g("F"), "stat", [g, 1.0]))
		if x > v: v = x; best = g
	return {"g": best, "v": v} if best != null else null
static func rival_intro() -> Array:
	var a = st()
	if J.t(a.rival.met): return []
	a.rival.met = true
	return (BRYAN_MET if beat_done("c1_bryan") else BRYAN_FIRST).duplicate(true)
static func rival_theft() -> void:
	var a = st(); var r = a.rival; var p = r.pend; r.pend = null; var S = _S()
	var amt = minf(floor(J.num(S.res.coins)), rwd(25)); var res = "coins"
	if amt < 8: amt = minf(floor(J.num(S.res.buns)), rwd(20)); res = "buns"
	var amt_txt = J.str(J.gp(_g("RES_NAMES"), res)) + " " + J.str(amt); var need = 60 + 12 * minf(3.0, J.num(r.arc)); var sm = smartest()
	var cast = [["阿福", "afu"], ["Bryan", ART.rival]]
	if sm != null: cast.insert(1, [J.gp(sm.g, "name"), J.gp(sm.g, "k")])
	var lines = rival_intro() + [["Bryan", Lf(rot("claim", BRYAN_CLAIM), {"w": J.gp(p, "what")}), "wave"], ["Bryan", Lf("所以呢份獎勵，我攞返我應得嗰份：{a}。大家隊友，唔好計得咁盡啦。", {"a": amt_txt})]]
	var ok_ev = sm != null and sm.v >= need
	var nm = J.str(J.gp(sm.g, "name")) if sm != null else ""
	var la = ("派%s出示證據（智 %s，需 %s）" % [nm, J.str(sm.v), J.str(need)] if ok_ev else "出示證據（%s智 %s，不足 %s）" % [nm, J.str(sm.v), J.str(need)]) if sm != null else "出示證據（沒有幫手）"
	var choice = {"plain": true, "q": "Bryan 想分走你的獎勵（%s）。" % amt_txt,
		"a": {"label": la, "disabled": not ok_ev,
			"lines": ([[nm, Lf("（攤開一疊紙）記錄喺度：{w}，由頭到尾都係少爺做嘅。嗰陣你喺{a}。", {"w": J.gp(p, "what"), "a": L(rot("alibi", ALIBI))})]] + BRYAN_LOSE.duplicate(true) + [[nm, "重播都喺度。你個波，三次都出界。"]]) if ok_ev else [],
			"on": func(_t, _a):
				r.arc = J.num(r.arc) + 1; r.grudge = maxf(0.0, J.num(r.grudge) - 1); var t = give({res: rwd(15)})
				return [["Bryan", rot("run", BRYAN_RUN)], ["旁白", "證據確鑿，一分也沒被拿走。另外獲得：" + t]]},
		"b": {"label": "跟他爭（不給，但他會記仇）", "lines": [["阿福", "Bryan，嗰陣你喺邊？"], ["Bryan", "我……我喺精神上支持你！"], ["阿福", "精神上支持，冇獎金。"], ["Bryan", "好，好。兄弟，你小心啲。"]], "on": func(_t, _a): r.arc = J.num(r.arc) + 1; r.grudge = J.num(r.grudge) + 1; return []},
		"c": {"label": "給他（%s；他會安靜一陣子）" % amt_txt, "lines": [["阿福", "攞去啦。"], ["Bryan", "爽快！我就話你係好隊友！下次我一定 pass 波俾你。"], ["旁白", "他從來沒有傳過球給任何人。"]],
			"on": func(_t, _a):
				S.res[res] = J.num(S.res[res]) - amt; r.stolen = J.num(r.stolen) + (amt if res == "coins" else 0.0); r.arc = J.num(r.arc) + 1; r.peaceUntil = J.num(a.clock) + 15 * 60
				return []}}
	play({"tag": "死對頭", "title": "Bryan：搶功勞", "bg": "village", "cast": cast, "lines": lines, "choice": choice}, func(res2):
		if J.t(J.gp(res2, "skipped")) and J.iter(J.gp(res2, "picks")).is_empty(): r.grudge = J.num(r.grudge) + 1
		done())
static func rival_gossip() -> bool:
	var a = st(); var r = a.rival; var S = _S()
	var cand = J.iter(J.gp(S, "ghosts")).filter(func(g): return J.t(J.gp(g, "post")) and J.str(J.gp(g, "k")) != "afu" and art(J.gp(g, "k")))
	if cand.is_empty(): return false
	var g = cand[int(floor(R() * cand.size()))]; var cost = rwd(15); var gn = J.str(J.gp(g, "name"))
	var lines = rival_intro() + [["旁白", "Bryan 摟著%s的肩膀，壓低聲音說話。" % gn], ["Bryan", Lf(rot("rumor", RUMORS), {"n": gn})], [gn, rot("hurt", HURT), "look"],
		["阿福", "Bryan，你同佢講咩？"], ["Bryan", "冇呀，打吓氣嘛。我哋要有 team spirit。"]]
	var set_ = func(): r.rumor = {"gid": J.gp(g, "id"), "name": gn, "until": now() + 8 * 60000}; hud()
	var c8 = rwd(8)
	var choice = {"plain": true, "q": "%s聽信謠言，工作速度減半。怎麼處理？" % gn,
		"a": {"label": "請全村吃宵夜澄清（壽包 %s）" % J.str(cost), "disabled": J.num(S.res.buns) < cost, "lines": [["阿福", "今晚宵夜我請，順便講清楚：冇呢回事。"], [gn, "……少爺，我信你。"], ["Bryan", "（揸住個波）宵夜有冇我份？"], ["阿福", "冇。"]],
			"on": func(_t, _a): S.res.buns = J.num(S.res.buns) - cost; r.rumor = null; r.arc = J.num(r.arc) + 1; return [["旁白", "謠言澄清了。"]]},
		"b": {"label": "請冼小姐發澄清通告（行政費：冥幣 %s）" % J.str(c8), "disabled": J.num(S.res.coins) < c8, "lines": [["冼小姐", "澄清通告，一式三份：正本貼公告板，一份副本俾當事人，一份俾造謠者。"], ["Bryan", "點解有我份？"], ["冼小姐", "因為通告上面寫住你個名呀，親愛嘅同事～"]],
			"on": func(_t, _a): S.res.coins = J.num(S.res.coins) - rwd(8); r.rumor = null; r.arc = J.num(r.arc) + 1; return [["旁白", "謠言澄清了。Bryan 收到人生第一封澄清通告。"]]},
		"c": {"label": "不理會（清者自清）", "lines": [["阿福", "清者自清。"]], "on": func(_t, _a): set_.call(); r.arc = J.num(r.arc) + 1; return [["旁白", "%s工作速度減半，持續 8 分鐘。" % gn]]}}
	var cast = [["阿福", "afu"], [gn, J.gp(g, "k")], ["Bryan", ART.rival]]
	play({"tag": "死對頭", "title": "Bryan：搬弄是非", "bg": "village", "cast": cast, "lines": lines, "choice": choice}, func(res):
		if J.iter(J.gp(res, "picks")).is_empty(): set_.call()
		done())
	return true
# 最後決鬥：一對一三球。每球 Bryan 自己會漏口風
static func rival_showdown() -> void:
	var a = st(); var r = a.rival; r.duels = J.num(r.duels) + 1; var S = _S()
	var cast = [["阿福", "afu"], ["Bryan", ART.rival], ["龐總", ART.boss]]
	var intro = [["Bryan", "兄弟，我哋咁樣拗落去都唔係辦法。一對一，三球。你贏，我認晒以前啲功勞係你嘅。"], ["阿福", "我輸呢？"], ["Bryan", "你輸，以後你啲功勞都係我嘅。"], ["阿福", "……同而家有咩分別？"], ["Bryan", "有。以後係正式嘅。"], ["龐總", "我做旁證。Data 唔會呃人。"]]
	var W = {"wins": 0}
	var round_ = func(i: int, self_ref: Callable) -> Dictionary:
		var d = ROUNDS[i]; var ra = R() < 0.5
		var mk = func(right: bool) -> Dictionary:
			var o = {"label": d.right if right else d.wrong, "lines": (d.win if right else d.lose).duplicate(true),
				"on": func(_t, _a):
					if right: W.wins += 1
					var out = [["旁白", "比數：阿福 %d：%d Bryan" % [W.wins, i + 1 - W.wins]]]
					if i < 2: out.append(["Bryan", ROUNDS[i + 1].tell, "wave"])
					return out,
				"next": (func(_t, _a): return self_ref.call(i + 1, self_ref)) if i < 2 else null}
			return o
		return {"plain": true, "q": d.q, "a": mk.call(ra), "b": mk.call(not ra)}
	var tail = func() -> Array:
		if W.wins >= 2:
			r.beaten = true; var back = minf(J.num(r.stolen), rwd(120)); var t = give({"chest": "p", "coins": rwd(60) + back})
			return [["龐總", "（揭開平板）順便講埋：我睇過數據。Bryan 呢三年嘅 KPI，九成係人哋做嘅。"], ["Bryan", "龐總，嗰啲係……助攻！"], ["龐總", "由今日起，你調去落魄村茶水間。職位：茶水間主任。KPI：沖茶。"], ["Bryan", "……沖茶點計 KPI？"], ["龐總", "你沖嘅每一杯，都要寫你自己個名。"], ["旁白", "Bryan 被揭穿。之前被他拿走的冥幣全數追回。獎勵：" + t]]
		return [["Bryan", "承讓承讓！兄弟，下次再嚟過，我隨時候教。"], ["龐總", "（喺平板寫低）Bryan：勝。阿福：仲有改善空間。"], ["旁白", "輸了沒有損失。過一陣子，Bryan 會再來挑戰。"]]
	var lines = intro + [["Bryan", ROUNDS[0].tell, "wave"]]
	var choice = round_.call(0, round_)
	# 最後一球揀完，接埋結局
	var last = func(c: Dictionary, self_ref: Callable) -> Dictionary:
		for k in ["a", "b"]:
			var o = c[k]
			if o.get("next") != null:
				var nx = o.next
				o["next"] = func(_t, a2): return self_ref.call(J.cl(nx, null, a2), self_ref)
			else:
				var on_ = o.on
				o["on"] = func(_t, a2): return J.iter(J.cl(on_, null, a2)) + tail.call()
		return c
	play({"tag": "死對頭", "title": "Bryan：一對一，三球", "bg": "office", "cast": cast, "lines": lines, "choice": last.call(choice, last)}, func(_r): done())

# ===================== 冼小姐：HR =====================
static func warn(lines: Array) -> Array:
	var h = st().hr; h.warn = J.num(h.warn) + 1; var S = _S()
	if h.warn >= 3:
		h.warn = 0.0; var c = minf(floor(J.num(S.res.coins)), rwd(12)); S.res.coins = J.num(S.res.coins) - c
		return lines + [["冼小姐", "恭喜你～集齊三封警告信，可以換一個大過！"], ["旁白", "記大過：冥幣 −%s。警告信歸零。" % J.str(c)]]
	return lines + [["旁白", "警告信 +1（集滿三封記大過）。目前：%s 封。" % J.str(h.warn)]]
static func build_hr_ev() -> Array:
	var G = func(r: Dictionary):   # give:() => ({ x:rwd(n) })
		return func(_t, _a):
			var o = {}
			for k in r: o[k] = rwd(r[k])
			return o
	return [
		{"id": "mc", "title": "冼小姐：病假紙", "lines": [["冼小姐", "親愛嘅同事～上個禮拜三你冇出席晨會。根據手冊第 214 條，缺席要補交病假紙。"], ["阿福", "我死咗喇。"], ["冼小姐", "死亡唔係病，係一種長期狀態。長期狀態，要交長期病假紙，一式三份。"]],
			"q": "冼小姐要你交病假單。", "smart": {"label": "「手冊第一條：員工須在生。我唔在生，手冊唔適用。」", "lines": [["冼小姐", "（揭返去第一頁）……第一條……"], ["冼小姐", "呢條係邊個寫㗎？"], ["阿福", "你。"], ["冼小姐", "（蓋印）批。今次當我冇嚟過。"]], "give": G.call({"coins": 15.0})},
			"dumb": {"label": "「好，我補交。」", "lines": [["冼小姐", "好乖～七個工作天內交到，逾期當自動辭職。"], ["阿福", "辭職可以去邊？"], ["冼小姐", "返陽間囉，親愛嘅同事～"], ["旁白", "沒有醫生肯替鬼開病假單。"]], "warn": true}},
		{"id": "gps", "title": "冼小姐：打卡", "lines": [["冼小姐", "打卡系統顯示：你返工時間，GPS 喺墳場。屬擅離職守。"], ["阿福", "我住喺墳場。"]],
			"q": "冼小姐說你擅離職守。", "smart": {"label": "「我喺屋企返工，即係 WFH。」", "lines": [["冼小姐", "WFH 要預先申請。"], ["阿福", "申請表喺邊？"], ["冼小姐", "喺公司，要返公司攞。"], ["阿福", "咁我返公司攞表嗰陣，係咪就唔算擅離職守？"], ["冼小姐", "（諗咗好耐，蓋印）……批。你好煩。"]], "give": G.call({"exp": 8.0})},
			"dumb": {"label": "「我即刻返去補打卡。」", "lines": [["冼小姐", "打卡時間已過，而家打屬於遲到。"], ["阿福", "咁遲到嘅定義係？"], ["冼小姐", "你出現嘅時候。"]], "warn": true}},
		{"id": "team", "title": "冼小姐：強制 team-building", "lines": [["冼小姐", "強制性 team-building！今日活動：信任跌。一個向後跌，其他人接住。"], ["阿福", "我哋係鬼，會穿過去。"], ["冼小姐", "所以先要練呀～"]],
			"q": "怎麼應付這次 team-building？", "smart": {"label": "「參加。」", "lines": [["旁白", "十二隻鬼輪流往後倒，十二次都穿過地面掉了下去。"], ["冼小姐", "好！大家建立咗「冇人會接住你」嘅共識，非常真實。"]], "give": G.call({"exp": 8.0})},
			"dumb": {"label": "「我今日請病假。」", "lines": [["冼小姐", "病假紙呢？"], ["阿福", "……"]], "warn": true},
			"third": {"label": "「改做宵夜啦，增進感情。」", "lines": [["冼小姐", "好主意～預算你出。"], ["旁白", "全村吃了一頓宵夜，大家都很開心，除了冼小姐的預算表。"]], "give": G.call({"exp": 10.0}), "cost": {"buns": 12.0}}},
		{"id": "forms", "title": "冼小姐：一式三份", "lines": [["阿福", "冼小姐，我想申請一日假。"], ["冼小姐", "當然可以～請填 A 表。A 表要附 B 表副本，B 表要先有 C 表批核，C 表要附 A 表正本。"], ["阿福", "……咁我由邊張開始？"], ["冼小姐", "由你諗清楚嗰陣開始。"]],
			"q": "怎樣才拿得到這一天假？", "smart": {"label": "「我填 D 表：申請豁免填表。」", "lines": [["冼小姐", "D 表？我哋冇 D 表。"], ["阿福", "冇 D 表，即係冇規定唔准。"], ["冼小姐", "（揭咗好耐手冊，蓋印）……批。下年我會加 D 表。"]], "give": G.call({"buns": 15.0})},
			"dumb": {"label": "「我逐張填。」", "lines": [["旁白", "阿福填了三天三夜，填到第三張才發現：需要第一張的正本，而正本附在第三張上。"], ["冼小姐", "表格有錯，駁回～"]], "slow": true}},
		{"id": "happy", "title": "冼小姐：快樂指數", "lines": [["冼小姐", "年度員工快樂指數問卷！一至十分，低過七分要強制參加快樂工作坊。"], ["冼小姐", "溫馨提示：十分屬於異常。異常要寫報告，解釋點解咁開心。"]],
			"q": "你填幾分？", "smart": {"label": "七分", "lines": [["冼小姐", "七分，標準。你係一個非常正常嘅員工。"], ["阿福", "多謝。"], ["冼小姐", "正常員工下年冇加薪，因為你已經夠快樂～"]], "give": G.call({"coins": 12.0})},
			"dumb": {"label": "三分", "lines": [["冼小姐", "好～快樂工作坊逢星期六朝早九點。"], ["阿福", "我哋夜晚先出得嚟。"], ["冼小姐", "所以要早啲出門呀～"]], "warn": true},
			"third": {"label": "十分", "lines": [["冼小姐", "十分？好可疑。請寫一千字報告，解釋你點解咁開心。"], ["阿福", "寫完我就唔開心喇。"], ["冼小姐", "咁就啱喇～"]], "slow": true}},
		{"id": "notice", "title": "冼小姐：病假通告", "lines": [["冼小姐", "溫馨提示～新通告：由今日起，請病假要提早三日通知。"], ["阿福", "我上次請病假，你哋未批，我就直接放咗永久嗰種。"], ["冼小姐", "所以先要提早通知呀，親愛嘅同事～"], ["冼小姐", "另外，你三年前申請嘅年假，今日批咗。請注意：放假期間，請保持電話暢通。"]],
			"q": "冼小姐要大家遵守新通告。", "smart": {"label": "「好。我禮拜五會病，病因未知。」", "lines": [["冼小姐", "……（望住板夾好耐）"], ["冼小姐", "呢份通告，一個鐘之後收回。"]], "give": G.call({"coins": 15.0})},
			"dumb": {"label": "「收到。」", "lines": [["冼小姐", "好乖～三日之後，記得準時病。"], ["旁白", "三天後，阿福忘了病。"]], "warn": true}},
		{"id": "toilet", "title": "冼小姐：廁所計時器", "lines": [["冼小姐", "新政策！村口茅廁裝咗計時器，每次唔准超過十五分鐘，超時自動 email 龐總。"], ["阿福", "我生前加班到半夜，冇人幫我計時。去個廁所，就有人計。"], ["冼小姐", "所以話公司好關心你呀～"]],
			"q": "冼小姐要你簽名確認新政策。", "smart": {"label": "「你哋規定唔准超過十五分鐘，冇規定死喺入面點計。」", "lines": [["冼小姐", "（揭手冊）……死喺入面……"], ["冼小姐", "手冊冇寫。（蓋印）呢條，下年先加。"], ["旁白", "計時器暫停使用。門上貼著：「故障，請勿使用」。其實沒有故障，裡面有人。"]], "give": G.call({"exp": 8.0})},
			"dumb": {"label": "「好，我簽。」", "lines": [["旁白", "計時器每十五分鐘響一次，全村的鬼在茅廁門口排起長龍。"]], "slow": true}},
		{"id": "cctv", "title": "冼小姐 × Bryan：舉報", "team": true, "lines": [["冼小姐", "阿福，有同事舉報你上班時間玩手機，有相為證。"], ["Bryan", "我都唔想㗎，兄弟。不過公司利益行先。"], ["阿福", "張相係邊個影㗎？"], ["Bryan", "……一位熱心同事。"]],
			"q": "冼小姐要發警告信給你。", "smart": {"label": "「調 CCTV 睇吓。」", "lines": [["旁白", "CCTV：Bryan 在辦公室運了一整天球，中途停下來拍了阿福一張照片，然後繼續運球。"], ["冼小姐", "……Bryan，你上班時間打波。"], ["Bryan", "嗰個係 team-building 嚟㗎！"], ["冼小姐", "Team-building 要預先申請～（蓋印）警告信。"], ["Bryan", "……兄弟，呢球算你入。"]], "give": G.call({"coins": 18.0}), "arc": true},
			"dumb": {"label": "「認咗佢，算數。」", "lines": [["Bryan", "好隊友！我會記住你嘅犧牲。"], ["旁白", "他不會。"]], "warn": true}},
	]
static func hr_event(force = null) -> void:
	var a = st(); var h = a.hr; h.visits = J.num(h.visits) + 1; var S = _S()
	var pool = HR_EV.filter(func(e): return not e.get("team", false) or (J.t(a.rival.met) and not J.t(a.rival.beaten) and J.num(a.rival.arc) >= 2 and seen("ch4_end") and art(ART.rival)))
	var e = null
	if J.t(force): for x in HR_EV: if x.id == J.str(force): e = x; break
	if e == null:
		var fresh = pool.filter(func(x): return not J.t(J.gp(h.done, x.id)))
		if fresh.is_empty(): h.done = {}
		var p2 = fresh if fresh.size() > 0 else pool
		e = p2[int(floor(R() * p2.size()))]
	h.done[e.id] = 1.0
	var intro = [] if J.t(h.met) else (HR_MET if beat_done("c2_hr") else HR_INTRO).duplicate(true)
	h.met = true
	var cast = [["阿福", "afu"], ["冼小姐", ART.hr]]
	if e.get("team", false): cast.append(["Bryan", ART.rival])
	var mk = func(o):
		if o == null: return null
		var cost = rwd(o.cost.buns) if o.has("cost") else 0.0
		return {"label": o.label + (("（壽包 %s）" % J.str(cost)) if o.has("cost") else ""), "disabled": (J.num(S.res.buns) < cost) if o.has("cost") else false, "lines": o.lines.duplicate(true),
			"on": func(_t, _a):
				var out = []
				if o.has("cost"): S.res.buns = J.num(S.res.buns) - rwd(o.cost.buns)
				if o.has("give"): out.append(["旁白", "出了一口氣：" + give(J.cl(o.give, null, []))])
				if o.get("warn", false): out = warn(out)
				if o.get("slow", false):
					a.boss.slowUntil = maxf(J.num(a.boss.slowUntil), now() + 4 * 60000); out.append(["旁白", "懲罰：全村陪你處理文件，工作速度 −15%（4 分鐘）"])
				if o.get("arc", false): a.rival.arc = J.num(a.rival.arc) + 1
				return out}
	var sA = R() < 0.5; var opts = [mk.call(e.smart), mk.call(e.dumb)]
	if not sA: opts.reverse()
	var choice = {"plain": true, "q": e.q, "a": opts[0], "b": opts[1]}
	if e.has("third"): choice["c"] = mk.call(e.third)
	play({"tag": "HR", "title": e.title, "bg": "village", "cast": cast, "lines": intro + e.lines.duplicate(true), "choice": choice}, func(_r): done())

# ===================== 排程 =====================
static func _pick(opts: Array) -> Callable:
	var tot = 0.0
	for o in opts: tot += o[0]
	var x = R() * tot; var f: Callable = opts[-1][1]
	for o in opts:
		x -= o[0]
		if x <= 0: f = o[1]; break
	return f
static func tick() -> bool:   # Skits.tick 每秒（安靜＋有操作時）呼叫；true = 今次出咗場
	var a = st()
	if a == null or not seen("ch1_end"): return false
	a.clock = J.num(a.clock) + 1; a.gap = J.num(a.gap) + 1
	var b = a.boss; var r = a.rival
	if J.t(b.task) and a.gap >= REVIEW_GAP and art(ART.boss):
		var p = task_prog()
		if p.v >= J.num(p.n) or p.left <= 0: a.gap = 0.0; boss_review(); return true
	if J.t(r.pend) and not J.t(r.beaten) and a.gap >= 25 and art(ART.rival): a.gap = 0.0; rival_theft(); return true
	if a.gap < GAP or R() > 1.0 / 90: return false
	var opts = []
	if not J.t(b.task) and art(ART.boss): opts.append([3.0, func(): boss_visit()])
	if not J.t(b.get("group")) and J.num(b.visits) >= 2 and seen("gift_phone"): opts.append([3.0, func(): boss_group()])
	if not J.t(r.beaten) and J.t(r.met) and seen("ch2_end") and not (J.t(r.rumor) and J.num(J.gp(r.rumor, "until")) > now()) and J.num(a.clock) > J.num(r.peaceUntil) and art(ART.rival): opts.append([1.5 + J.num(r.grudge), func(): return rival_gossip()])
	if not J.t(r.beaten) and J.num(r.arc) >= 3 and seen("ch5_end") and art(ART.rival): opts.append([4.0, func(): rival_showdown()])
	if seen("ch2_end") and art(ART.hr): opts.append([2.5, func(): hr_event()])
	if opts.is_empty(): return false
	var f = _pick(opts)
	a.gap = 0.0
	if J.seq(f.call(), false): return false
	return true
# 完成任務／首次通關：Bryan 有機會嚟搶功
static func credit(what) -> void:
	var a = st()
	if a == null or not seen("ch1_end"): return
	var r = a.rival
	if J.t(r.beaten) or J.t(r.pend) or J.num(a.clock) < J.num(r.peaceUntil): return
	if R() < (0.3 if J.t(r.met) else 0.6): r.pend = {"what": what}
static func init() -> void:
	var Q = _g("Quest")
	if Q != null and J.t(J.gp(Q, "complete")):
		var oc = J.gp(Q, "complete")
		J.sp(Q, "complete", func(this_, args):
			var cur = J.gp(Q, "cur"); var q = J.mc(Q, "cur", []) if J.t(cur) else null
			var r = J.cl(oc, this_, args)
			if J.t(q): credit(J.gp(q, "text"))
			return r)
	last_cleared = -1.0
	J.F_setInterval([func(_t, _a):   # 首次通關（包括野鬼戰）
		var S = _S()
		if not J.t(S) or not J.t(J.gp(S, "cleared")): return null
		var n = float(J.keys(J.gp(S, "cleared")).size()); var B = _g("Battle"); var act = B != null and J.t(J.gp(B, "active"))
		if last_cleared >= 0 and n > last_cleared and not act: credit("打通新關卡")
		if not act: last_cleared = n
		hud()
		return null, 1000.0])
# ---------- 左下角小牌：KPI 進度、謠言、懲罰剩幾耐（Godot：交俾原生 __nat_chip） ----------
static func hud() -> void:
	var wrap = J.S_document_("getElementById", ["stagewrap"]); var S = _S()
	if not J.t(wrap) or not J.t(S): return
	var el = J.S_document_("getElementById", ["antag-chip"])
	var a = J.gp(S, "antag"); var rows = []
	if J.t(a) and J.t(J.gp(J.gp(a, "boss"), "task")):
		var p = task_prog(); var t = a.boss.task
		rows.append("<b>龐總 KPI</b> %s %s/%s　⏱%d:%02d" % [J.str(t.what), J.str(minf(p.v, J.num(p.n))), J.str(p.n), int(floor(p.left / 60)), int(p.left) % 60])
	if J.t(a) and J.t(J.gp(J.gp(a, "rival"), "rumor")) and J.num(J.gp(a.rival.rumor, "until")) > now(): rows.append("<b>謠言</b> %s工作速度減半　%s 分鐘" % [J.str(a.rival.rumor.name), J.str(mins(J.num(a.rival.rumor.until) - now()))])
	if J.t(a) and J.num(J.gp(J.gp(a, "boss"), "slowUntil")) > now(): rows.append("<b>懲罰</b> 全村工作速度 −15%%　%s 分鐘" % J.str(mins(J.num(a.boss.slowUntil) - now())))
	var chip = _g("__nat_chip")
	if chip != null:
		if J.t(el): J.mc(el, "remove", [])
		J.cl(chip, null, ["antag", "<br>".join(rows), ""]); return
	if rows.is_empty():
		if J.t(el): J.mc(el, "remove", [])
		return
	if not J.t(el):
		el = J.S_document_("createElement", ["div"]); J.sp(el, "id", "antag-chip"); J.mc(wrap, "appendChild", [el])
		J.sp(el, "onclick", func(_t, _a): toast("龐總 KPI：時限內達標有獎勵，未達標有輕微懲罰。時限只計算你在村子裡遊玩的時間。<br>謠言：8 分鐘後自行消散。"); return null)
	var html = "<br>".join(rows)
	if J.str(J.gp(el, "innerHTML")) != html: J.sp(el, "innerHTML", html)
static func css() -> void:
	var s = J.S_document_("createElement", ["style"])
	J.sp(s, "textContent", "#antag-chip{position:absolute;left:8px;bottom:8px;z-index:4;max-width:78%;padding:6px 10px;background:rgba(20,12,22,.86);color:#f3e6c8;font-size:13.5px;line-height:1.5;border-radius:4px;box-shadow:inset 0 0 0 1px rgba(243,214,138,.45)}#antag-chip b{color:#ff8a6a;margin-right:4px}")
	J.mc(J.gp(_g("document"), "head"), "appendChild", [s])
# 示範頁／測試用（JS 版用 Math.random 蓋過但 R 已經攞咗原本嗰個，所以其實冇影響——照跟）
static func demo(kind) -> void:
	var a = st(); var k = J.str(kind)
	# 網頁版 demo 會換 Math.random，但 R 喺載入時已經攞住原本嘅 Math.random，所以冇效果；照網頁版行為
	if k == "boss": a.boss.task = null; a.n["absurd"] = 0.0; boss_visit()
	elif k == "absurd": a.boss.visits = maxf(1.0, J.num(a.boss.visits)); boss_visit()
	elif k == "group": boss_group()
	elif k == "review":
		if not J.t(a.boss.task): a.boss.task = {"k": "chop", "n": 3.0, "base": task_val("chop") - 1, "due": a.clock, "set": a.clock, "what": TASK_INFO.chop.what, "unit": TASK_INFO.chop.unit}
		boss_review()
	elif k == "theft": a.rival.pend = {"what": "砍倒 3 棵槐樹"}; rival_theft()
	elif k == "gossip":
		a.rival.met = true
		if not rival_gossip(): toast("要先派一隻鬼到崗位工作，Bryan 才有造謠對象。")
	elif k == "showdown": a.rival.met = true; rival_showdown()
	elif k.begins_with("hr:"): hr_event(k.substr(3))

static func tasks_export() -> Dictionary:
	var o = {}
	for k in TASK_ORDER:
		var T = TASK_INFO[k]
		var e = {"ok": func(_t, _a): return task_ok(k), "n": func(_t, _a): return task_n(k), "m": T.m, "val": func(_t, _a): return task_val(k), "unit": T.unit, "what": T.what,
			"lines": func(_t, a): return task_lines(k, J.num(J.arg(a, 0)), J.num(J.arg(a, 1)))}
		if T.get("abs", false): e["abs"] = true
		o[k] = e
	return o

func run(_env) -> void:
	var LANG = _g("LANG")
	if LANG != null: J.mc(LANG, "add", [ZH_NEW])
	HR_EV = build_hr_ev()
	install_rates()
	css()
	init()
	J.G["Rivals"] = {
		"st": func(_t, _a): return st(),
		"tick": func(_t, _a): return tick(),
		"credit": func(_t, a): credit(J.arg(a, 0)); return null,
		"hud": func(_t, _a): hud(); return null,
		"demo": func(_t, a): demo(J.arg(a, 0)); return null,
		"taskProg": func(_t, _a): return task_prog(),
		"HR_EV": HR_EV, "ABSURD": ABSURD.duplicate(true), "TASKS": tasks_export(), "ROUNDS": ROUNDS.duplicate(true), "RUMORS": RUMORS.duplicate(), "BRYAN_CLAIM": BRYAN_CLAIM.duplicate(),
		"BOSS_OPEN": BOSS_OPEN.duplicate(), "BOSS_PASS": BOSS_PASS.duplicate(true), "BOSS_FAIL": BOSS_FAIL.duplicate(true), "NM": NM.duplicate(), "ART": ART.duplicate(),
	}
