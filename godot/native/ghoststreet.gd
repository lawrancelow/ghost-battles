# 原生改寫自 ghoststreet.js（冥街夜市：下班後的陰間）
# 規則、存檔（S.street）、隨機數用法同轉譯版一樣；畫面交俾 GsDraw（__nat_gsDraw），面板照舊出 DOM 俾 GsPanel 畫
extends RefCounted

const GS_STALLS := {
	"paper": {"name": "紙紮鋪", "x": 0.13, "sx": 0.15, "face": 1.0, "x0": 0.015, "x1": 0.255, "keeper": "xiaozhi", "kx": 0.232, "ky": 0.745},
	"haggle": {"name": "講價攤", "x": 0.37, "sx": 0.385, "face": -1.0, "x0": 0.275, "x1": 0.47, "keeper": "xiaogui", "kx": 0.300, "ky": 0.742},
	"exch": {"name": "冥幣兌換", "x": 0.58, "sx": 0.605, "face": -1.0, "x0": 0.49, "x1": 0.665, "keeper": "baiwu", "kx": 0.525, "ky": 0.738},
	"food": {"name": "宵夜檔", "x": 0.78, "sx": 0.78, "face": 1.0, "x0": 0.675, "x1": 0.875, "keeper": "eguiking", "kx": 0.805, "ky": 0.745},
	"alley": {"name": "暗巷", "x": 0.945, "sx": 0.93, "face": 1.0, "x0": 0.885, "x1": 1.0},
}
const GS_ORDER := ["paper", "haggle", "exch", "food", "alley"]
const GS_EFFIGY := {
	"phone": {"name": "紙紮手機", "price": 400.0, "eff": "回陽間夜班：開局陰氣 +25", "say": "最新款，五個鏡頭——全部拍不到你。訊號直通陽間，夜班開工前先充好陰氣。"},
	"car": {"name": "紙紮跑車", "price": 600.0, "eff": "村子裡走路速度 +15%", "say": "油門是畫上去的，開不動。不過背著它跑步，不知道為什麼就是快了。"},
	"coffee": {"name": "紙紮咖啡機", "price": 700.0, "eff": "砍樹、割稻、做板、包包子快 10%", "say": "一杯下去，死人也能加班。副作用：凌晨三點會想回覆電郵。"},
	"chair": {"name": "紙紮按摩椅", "price": 900.0, "eff": "出征時我方血量 +5%", "say": "按完腰不痛了。雖然你本來就沒有腰，但是心理上舒服。"},
}
const GS_ITEMS := [
	{"id": "soup", "name": "二手孟婆湯（只喝了一半）", "col": 120.0, "desc": "前主人喝到一半想起前任，不喝了。保證只忘一半。"},
	{"id": "gramo", "name": "只會播《夜上海》的留聲機", "col": 200.0, "desc": "斷了一根弦，所以《夜上海》聽起來像《夜加班》。"},
	{"id": "clock", "name": "永遠慢五分鐘的掛鐘", "col": 90.0, "desc": "從舊公司牆上拆下來的。專門讓員工以為還沒到下班時間。"},
	{"id": "cage", "name": "空鳥籠", "col": 70.0, "desc": "鳥已經投胎了，籠子還在等牠回來辦交接。"},
	{"id": "vase", "name": "青花瓷花瓶", "col": 160.0, "desc": "底部印著「陰間製造」。品質有保障，保到下輩子。"},
	{"id": "chest", "name": "打不開的寶箱", "col": 240.0, "desc": "鑰匙在陽間某個抽屜裡。搖起來有聲音，可能是金子，可能是遙控器電池。"},
	{"id": "promise", "name": "黃總親筆加薪承諾書", "col": 60.0, "desc": "白紙黑字：「明年一定加。」日期是四十年前。"},
	{"id": "punch", "name": "會自己打卡的打卡機", "col": 150.0, "desc": "半夜三點自己「咔嚓」一聲，嚇跑了三任保安。"},
	{"id": "malt", "name": "過期三十年的麥芽沖劑", "col": 50.0, "desc": "結成一塊磚。敲下來可以當武器，也可以當早餐。"},
	{"id": "bell", "name": "牛頭大哥的退休牛鈴", "col": 110.0, "desc": "一搖，整條街的鬼都以為收工了。"},
	{"id": "nails", "name": "Pontianak 美甲店清倉假指甲", "col": 80.0, "desc": "長度可以自己剪，顏色只有一種：血紅。"},
	{"id": "bigbro", "name": "紙紮大哥大", "col": 130.0, "desc": "上世紀燒下來的，訊號只有一格，但是永遠打得通老闆。"},
]
const GS_BANDS := [
	{"max": 0.6, "mood": "翻臉", "col": "#e2483a", "lv": 0.0, "pose": "strike", "lines": ["你當我這裡是陽間的二手群組？出這種價！", "這個價，連一炷香都買不到！再這樣我叫牛頭來收你！", "侮辱我？我做這行三百年，沒見過這麼厚的臉皮！"]},
	{"max": 0.8, "mood": "很臭", "col": "#d07a3a", "lv": 1.0, "pose": "idle", "lines": ["哼，差得遠。我進貨都不止這個價。", "你在跟我講價，還是在講笑話？", "加！多加一點！我也要交租的好嗎！"]},
	{"max": 0.93, "mood": "猶豫", "col": "#d8b84a", "lv": 2.0, "pose": "windup", "lines": ["嗯……開始像話了。再加一點。", "看你黑眼圈這麼重，再加一點我就考慮。", "這個價嘛……我老婆知道會罵我的。再一點。"]},
	{"max": 1.0, "mood": "肉痛", "col": "#9ad05a", "lv": 3.0, "pose": "hurt", "lines": ["哎喲，肉痛……就差一口氣了！", "再加一點點，就當交個朋友。", "我的手在發抖了……再一點點就好！"]},
]
const GS_DEAL_TIGHT := ["……成交。你這隻鬼精，下次別來了。", "好啦好啦，算我今晚倒楣。拿去！", "你這種客人，我做三百年只見過兩個。成交。"]
const GS_DEAL_FAT := ["成交！！（小鬼笑到假牙都掉了出來）", "爽快！你是我今晚最喜歡的客人！", "成交成交！慢走，下次再來啊～（他在偷笑）"]
const GS_MEALS := {
	"mala": {"name": "加班麻辣燙", "price": 30.0, "eff": "下一場出征：攻擊 +15%", "say": "辣到你忘記自己已經死了。湯底熬了九百年，比你的工齡還長。"},
	"bkt": {"name": "通宵肉骨茶", "price": 30.0, "eff": "下一場出征：血量 +15%", "say": "藥材是陽間孝子燒下來的，喝完可以再撐一個通宵。"},
	"teh": {"name": "忘憂拉茶（少甜）", "price": 30.0, "eff": "下一場出征：技能符開局 +40", "say": "孟婆監製。拉得越高，忘得越多——先忘記老闆的電話號碼。"},
}
const GS_NEWS_UP := ["地府科技宣布：「來世訂閱制」下個月上線，首月免費。", "閻羅殿採購地府科技全套考勤系統，打卡從此不用手。", "地府科技新品「免排隊投胎」預購爆滿，伺服器排隊九百年。", "牛頭馬面代言地府科技，粉絲排隊排了三條街。", "地府科技財報：陽間清明節燒來的訂單創新高。"]
const GS_NEWS_DN := ["地府科技 CEO 被拍到回陽間兼職送外賣。", "地府科技伺服器當機，全陰間打不了卡，老闆們很不爽。", "地府科技被揭發用紙紮人當員工，紙紮人工會要求加薪。", "地府科技財報：盈利是燒來的，燒完就沒了。", "用戶投訴：用了地府科技的投胎 App，投胎後才發現是試用版。"]
const GS_FEE := 0.03
const GS_SHARE_CAP := 100.0
const GS_CHATTER := [
	"冥幣又通脹了，一碗粥要三億。", "我死了還在等那份 KPI 審批。", "房東說棺材位下個月起加租兩成。",
	"投胎排隊要等九百年，先打份工吧。", "老闆說加班費可以用功德抵。", "我生前過勞死，死後被派去整理過勞死的檔案。",
	"燒來的跑車被開罰單了——沒有紙紮車牌。", "年終獎金？上次發的是一張紙紮的「謝謝你」。", "女兒燒了一部手機給我，忘記燒充電器。",
	"孟婆湯漲價了，現在忘一個前任要加錢。", "開會開到雞叫，會議記錄：下次再議。", "我當了三百年實習生，還沒轉正。",
	"老闆說我們是一家人——所以不用發薪水。", "冥股又跌了，我的退休金只夠買一根香。", "陽間有四天工作週，我們連週末都沒有，只有週七。",
	"我兼職送宵夜，評分四點九，扣分是因為我太冷。", "打卡機壞了，全部當曠工——死了還要被扣錢。", "我陽間的同事，還在用我的帳號登入系統。",
	"黃總說今年不加薪，每人送一張勵志海報。", "冥幣面額太大，找零要推一輛手推車。", "七月出差回陽間，酒店全滿，只好睡停車場。",
	"我的 MC 被退回：「你已經死了，不算生病。」", "下班了還在群組回「收到」，這是職業病，也是死因。", "隔壁的榴槤是陽間空運的，貴到我的心又死了一次。",
	"投訴信寄去閻羅殿，自動回覆：「請排隊三百年。」", "這條街的租金，貴到連鬼都住不起。", "聽說今年的 OT 費用「心意」計算。",
	"我死後終於有時間睡覺，結果被排了夜班。", "Mamak 檔的師傅說，拉茶要拉到陽間那麼長才夠味。",
]
const GS_WANDER := ["youhun", "egui", "zombie", "shuigui", "pocong"]
const GS_PROPS := {"youhun": {"kind": "lanternW"}, "egui": {"kind": "lanternR"}, "shuigui": {"kind": "bag"}, "zombie": {"kind": "phone", "lines": ["喂？喂？", "聽到嗎？", "我跳緊過嚟"]}}
const GS_WORKFACE := {"paper": -1.0, "haggle": 1.0, "exch": 1.0, "food": -1.0}
const GS_POT := [0.752, 0.588]
const GS_SORRY := ["不好意思", "對不起對不起", "借過借過", "撞到你，抱歉"]
const GS_KEEPER_HI := {
	"paper": ["小紙：歡迎光臨！燒什麼都可以，就是不能燒加班單。", "小紙：今天新到的貨，摺到我手指都快斷了——紙做的手指。"],
	"haggle": ["小鬼：看什麼看？要買就出價，不買別擋著。", "小鬼：我這裡不二價。……好啦，可以講。"],
	"exch": ["白無常：一見生財！今天要換冥幣，還是換人生？", "白無常：一見生財～小道消息免費，虧錢自負。"],
	"food": ["餓鬼王：坐！吃！吃飽才有力氣被老闆罵！", "餓鬼王：一人一碗，不准偷吃隔壁的！（他在偷吃隔壁的）"],
	"alley": ["（巷子裡的霧好像在看你。）"],
}
const GS_ALLEY := [
	{"id": "mlm", "text": "一隻穿西裝的鬼塞給你一張傳單：「地府直銷，三個月月入一億冥幣！講座只收 60。」",
		"a": {"label": "聽講座", "cost": 60.0, "out": "講了三個鐘，重點是：請你也去拉三個人來聽講座。你學到了寶貴的一課。", "give": {"exp": 50.0}},
		"b": {"label": "說「我在趕投胎」", "out": "他在你背後喊：「你會後悔的！」你沒有。", "give": {"exp": 10.0}}},
	{"id": "lost", "text": "一隻剛來報到的新鬼抱著公文袋發抖：「請問……投胎報到處怎麼走？今天是我第一天。」",
		"a": {"label": "親自帶他去", "out": "他一路跟你講他的簡報。報到處說他表格填錯了要重排——至少他少走了冤枉路。", "give": {"exp": 70.0}},
		"b": {"label": "收 20 冥幣畫地圖", "out": "地圖畫得很漂亮。你良心痛了一下，也只痛了一下。", "give": {"coins": 20.0}}},
	{"id": "cash", "text": "地上有一疊整整齊齊的冥幣，旁邊有張字條：「誰撿誰加班」。",
		"a": {"label": "撿起來", "out": "冥幣到手。遠處有人喊：「好，明天早上七點開會。」……應該是巧合。", "give": {"coins": 90.0}},
		"b": {"label": "交給巡夜的黑無常", "out": "黑無常說：「難得。」塞給你一個綠箱，然後把冥幣收進自己口袋。", "give": {"chest": "g"}}},
	{"id": "cry", "text": "一隻加班鬼蹲在牆角哭：「簡報存檔失敗了，明早就要交……」",
		"a": {"label": "幫他重做一份", "out": "你們做到雞叫。老闆看了一眼說：「換回第一版吧。」至少他不哭了，改成笑。", "give": {"exp": 80.0}},
		"b": {"label": "遞一包紙巾", "out": "他擤了鼻涕，說謝謝，繼續哭。有時候陪著就夠了。", "give": {"exp": 15.0}}},
	{"id": "fortune", "text": "巷口擺著一個算命攤：「鐵口直斷，一次 50 冥幣。」",
		"a": {"label": "算一下", "cost": 50.0, "out": "「你下輩子……還是打工仔。」不過他說你今晚有偏財，送你一個藍箱。", "give": {"chest": "b"}},
		"b": {"label": "不信這一套", "out": "他在你背後點點頭：「這個也算準了。」", "give": {"exp": 10.0}}},
	{"id": "troops", "text": "一個戴墨鏡的鬼掀開大衣：「水貨陰兵，80 冥幣三十個，不問來歷。」",
		"a": {"label": "買一批", "cost": 80.0, "out": "三十個陰兵排好隊跟你回家。其中一個問：「有勞工保險嗎？」", "give": {"troops": 30.0}},
		"b": {"label": "向巡夜的牛頭舉報", "out": "牛頭把他帶走了。他臨走前說：「兄弟，我也只是打工的。」", "give": {"exp": 40.0}}},
	{"id": "mahjong", "text": "巷尾的麻將桌三缺一：「來啦，打一圈就好！」",
		"a": {"label": "坐下打一圈", "cost": 40.0, "out": "你被三家清一色，輸了 40 冥幣。散場時他們拍拍你：「你人很好，下次還找你。」", "give": {"exp": 30.0}},
		"b": {"label": "「我老婆在等我」", "out": "三隻鬼齊聲說：「怕老婆好，怕老婆會發達。」", "give": {"exp": 5.0}}},
	{"id": "wifi", "text": "霧裡有個小攤在賣「陽間 WiFi 密碼」，一張 30 冥幣。",
		"a": {"label": "買一張", "cost": 30.0, "out": "密碼是 12345678。你連上了，看到舊同事在群組問：「阿福走了，他的工作誰接？」……沒人回。", "give": {"exp": 40.0}},
		"b": {"label": "算了", "out": "你決定今晚不看群組。這是你死後最健康的決定。", "give": {"exp": 20.0}}},
]
const GS_LANTERNS := [[0.029, 0.322], [0.286, 0.352], [0.496, 0.332], [0.557, 0.355], [0.72, 0.36], [0.872, 0.352], [0.97, 0.322], [0.018, 0.468], [0.228, 0.468], [0.475, 0.46], [0.684, 0.488], [0.866, 0.51], [0.92, 0.44], [0.955, 0.44]]
const DAY := 86400000.0

# ---------- 小工具 ----------
static func gs_day() -> float:
	var ms = J.now()
	var tz = Time.get_time_zone_from_system().get("bias", 0)
	return floor((ms - float(-tz) * 60000) / DAY)

static func _i32(x: int) -> int:
	x = x & 0xFFFFFFFF
	return x - 0x100000000 if x >= 0x80000000 else x
static func _u32(x: int) -> int: return x & 0xFFFFFFFF
static func _imul(a: int, b: int) -> int: return _i32(_i32(a) * _i32(b))
static func _toi32(v: float) -> int:
	if is_nan(v) or is_inf(v): return 0
	return _i32(int(v))

static func gs_rnd(nv: float) -> float:
	var n = _i32(_toi32(nv) ^ 0x5bd1e995)
	n = _imul(n ^ (_u32(n) >> 15), 0x2c1b3c6d)
	n = _imul(n ^ (_u32(n) >> 12), 0x297a2d39)
	n = _i32(n ^ (_u32(n) >> 15))
	return float(_u32(n)) / 4294967296.0

static func _pick(a: Array): return a[int(floor(randf() * a.size()))]
static func _g(n: String): return J.G.get(n)
static func _S(): return J.G.get("S")
static func _el(sel: String):
	var f = _g("$")
	return J.cl(f, null, [sel]) if f != null else null
static func _snd(n) -> void:
	var s = _g("Sound")
	if s != null: J.mc(s, "play", [n])
static func _save() -> void: J.cl(_g("save"), null, [])
static func _fmt(v) -> String: return J.str(J.cl(_g("fmt"), null, [v]))
static func _refresh() -> void: J.mc(_g("UI"), "refresh", [])
static func _on(e, f: Callable) -> void:
	if e != null: J.sp(e, "onclick", func(_t = null, _a = null): f.call())
static func _qall(p, sel: String) -> Array: return J.iter(J.mc(p, "querySelectorAll", [sel]))
static func _ds(b, k: String): return J.gp(J.gp(b, "dataset"), k)

static var Q: Dictionary = {}

# ---------- 存檔 ----------
static func st() -> Dictionary:
	var S = _S()
	if not J.t(S): return {"fx": {}}
	if not J.t(S.get("street")): S["street"] = {}
	var s = S.street
	if not J.t(s.get("fx")): s["fx"] = {}
	if not J.t(s.get("meal")): s["meal"] = null
	if not J.t(s.get("visits")): s["visits"] = 0.0
	if not J.t(s.get("seen")): s["seen"] = {}
	if not J.t(s.get("stock")): s["stock"] = {"n": 0.0, "cost": 0.0}
	if not J.t(s.get("curios")): s["curios"] = []
	if not J.t(s.get("hag")) or J.num(s.hag.get("day")) != gs_day(): s["hag"] = {"day": gs_day(), "done": {}, "tries": {}, "strikes": 0.0, "out": false}
	return s

static func _fx() -> Dictionary:
	var S = _S()
	if J.t(S) and J.t(S.get("street")) and J.t(S.street.get("fx")): return S.street.fx
	return {}

static func mul(kind: String) -> float:
	var fx = _fx()
	if kind == "walk": return 1.15 if J.t(fx.get("car")) else 1.0
	if kind == "work": return 1.1 if J.t(fx.get("coffee")) else 1.0
	if kind == "hp": return 1.05 if J.t(fx.get("chair")) else 1.0
	return 1.0

static func bonus(kind: String) -> float:
	if kind == "mana": return 25.0 if J.t(_fx().get("phone")) else 0.0
	return 0.0

static func battle_buffs(units) -> String:
	var S = _S()
	if not J.t(S) or not J.t(units): return ""
	var own = []
	for u in J.iter(units): if J.num(J.gp(u, "side")) == 0: own.append(u)
	var hpm = mul("hp")
	if hpm != 1:
		for u in own: J.sp(u, "maxhp", J.num(J.gp(u, "maxhp")) * hpm); J.sp(u, "hp", J.num(J.gp(u, "hp")) * hpm)
	var m = S.street.get("meal") if J.t(S.get("street")) else null
	if not J.t(m) or not GS_MEALS.has(J.str(m)): return ""
	m = J.str(m)
	if m == "mala":
		for u in own: J.sp(u, "atk", J.num(J.gp(u, "atk")) * 1.15)
	if m == "bkt":
		for u in own: J.sp(u, "maxhp", J.num(J.gp(u, "maxhp")) * 1.15); J.sp(u, "hp", J.num(J.gp(u, "hp")) * 1.15)
	if m == "teh":
		for u in own: if not J.t(J.gp(u, "minion")): J.sp(u, "energy", minf(100.0, J.num(J.gp(u, "energy")) + 40))
	S.street["meal"] = null; _save()
	var fxo = _g("Fx")
	if fxo != null: J.mc(fxo, "toast", ["宵夜生效：<b>%s</b>（%s）" % [GS_MEALS[m].name, GS_MEALS[m].eff.replace("下一場出征：", "")]])
	return GS_MEALS[m].name

# ---------- 開 / 關 ----------
static func mk_joss(init: bool) -> Dictionary:
	var o = {"kind": "joss"}
	o["x"] = J.num(Q.cam) + randf() * 1.3 - 0.15
	o["y"] = randf() * 0.8 if init else -0.05
	o["bx"] = (randf() - 0.5) * 0.01; o["vx"] = 0.0
	o["vy"] = 0.025 + randf() * 0.025; o["rot"] = randf() * 6; o["vr"] = (randf() - 0.5) * 2; o["flip"] = randf() * 6
	o["vf"] = 2 + randf() * 3; o["sw"] = 0.8 + randf(); o["ph"] = randf() * 6; o["land"] = 0.8 + randf() * 0.17
	o["life"] = 10 + randf() * 10 if init else 24.0; o["max"] = 24.0
	return o

static func open_() -> void:
	var s = st(); s["visits"] = J.num(s.visits) + 1
	Q.merge({"active": true, "t": 0.0, "view": {"k": "idle"}, "parts": [], "floats": [], "ate": false, "alleyDone": null, "alleyEv": null, "vh": 0.0, "cam": 0.0, "pend": null, "drag": null, "kick": 0.0}, true)
	Q["afu"] = {"x": 0.06, "y": 0.84, "tx": 0.06, "ty": 0.84, "dir": 1.0, "walking": false, "dustT": 0.0, "pose": null, "poseT": 0.0}
	var kps = {}
	for k in GS_STALLS:
		var d = GS_STALLS[k]
		if d.has("keeper"): kps[k] = {"k": d.keeper, "x": d.kx, "y": d.ky, "pose": null, "pt": 0.0, "poseT": 0.0, "bub": null, "bubT": 0.0, "ph": randf() * 6}
	Q["keepers"] = kps
	var ws = []
	for i in GS_WANDER.size():
		var w = {"k": GS_WANDER[i]}
		w["x"] = 0.1 + i * 0.19 + randf() * 0.05; w["y"] = 0.79 + randf() * 0.13; w["tx"] = 0.0; w["ty"] = 0.0
		w["wait"] = 1 + randf() * 4; w["dir"] = 1.0 if randf() < 0.5 else -1.0; w["ph"] = randf() * 6; w["bub"] = null; w["bubT"] = 0.0
		w["chatT"] = 2 + i * 2.6 + randf() * 2
		ws.append(w)
	for w in ws:
		w["tx"] = w.x; w["ty"] = w.y
		if GS_PROPS.has(w.k):
			var pr = {"seed": randf()}; pr.merge(GS_PROPS[w.k].duplicate(true), true); w["prop"] = pr
		else: w["prop"] = null
		w["look"] = 0.0; w["bump"] = 0.0
	Q["walkers"] = ws
	Q["bumpCD"] = 10 + randf() * 8
	Q["chatUsed"] = {}
	var fog = []
	for i in 9:
		var f = {}
		f["x"] = randf(); f["y"] = 0.66 + randf() * 0.3; f["r"] = 0.12 + randf() * 0.12; f["v"] = (0.004 + randf() * 0.008) * (1.0 if i % 2 else -1.0); f["a"] = 0.05 + randf() * 0.06
		fog.append(f)
	Q["fog"] = fog
	for i in 14: Q.parts.append(mk_joss(true))
	var el = _el("#gstreet"); J.mc(J.gp(el, "classList"), "add", ["on"])
	J.sp(el, "innerHTML", "<div id=\"gs-top\"><button class=\"btn sm\" id=\"gs-back\">回村</button><b>冥街夜市</b><span id=\"gs-coins\"><svg><use href=\"#i-coins\"/></svg><i></i></span></div>\n      <div id=\"gs-stage\"><canvas id=\"gs-cvs\"></canvas></div><div id=\"gs-panel\"></div>")
	_on(_el("#gs-back"), func(): _snd("click"); close())
	var cv = _el("#gs-cvs")
	J.mc(cv, "addEventListener", ["pointerdown", func(_t, a): down(J.arg(a, 0))])
	J.mc(cv, "addEventListener", ["pointermove", func(_t, a): move(J.arg(a, 0))])
	J.mc(cv, "addEventListener", ["pointerup", func(_t, a): up(J.arg(a, 0))])
	J.mc(cv, "addEventListener", ["pointercancel", func(_t, _a): Q["drag"] = null])
	J.mc(_g("Sound"), "setMode", ["story"])
	resize()
	if not J.t(Q.get("_rs")):
		Q["_rs"] = true
		var w = _g("window")
		if w != null: J.mc(w, "addEventListener", ["resize", func(_t, _a): if J.t(Q.active): resize()])
	render_panel(); Q["vh"] = target_vh()
	var nm = _g("__nat_mini")
	Q["_nat"] = nm != null and J.t(J.cl(nm, null, [Q, "#gs-stage", "#gstreet", "draw", "#gs-cvs"]))
	Q["last"] = J.S_performance_("now", [])
	var tok = {}; Q["_tok"] = tok; _raf(tok)
	if not J.t(s.seen.get("street")):
		s.seen["street"] = 1.0
		J.cl(_g("setTimeout"), null, [func(_t = null, _a = null): say(Q.walkers[0], "新來的？這裡是下班後的陰間，慢慢逛。", 4), 700.0])
	_save()

static func _raf(tok) -> void:
	var raf = _g("requestAnimationFrame")
	if raf != null: J.cl(raf, null, [func(_t, a): frame(J.num(J.arg(a, 0)), tok)])

static func close() -> void:
	if not J.t(Q.get("active")): return
	Q["active"] = false; Q["_tok"] = null
	if J.t(Q.get("_nat")) and _g("__nat_miniEnd") != null: J.cl(_g("__nat_miniEnd"), null, ["#gstreet"]); Q["_nat"] = false
	var el = _el("#gstreet"); J.mc(J.gp(el, "classList"), "remove", ["on"]); J.sp(el, "innerHTML", "")
	J.mc(_g("Sound"), "setMode", ["village"]); _save(); _refresh()

static func resize() -> void:
	var c = _el("#gs-cvs"); var box = _el("#gs-stage")
	if c == null or box == null: return
	var w: float; var h: float
	if J.t(Q.get("_nat")):
		var z = J.cl(_g("__nat_miniSize"), null, ["#gstreet"]); w = J.num(z[0]); h = J.num(z[1])
	else:
		var r = J.mc(box, "getBoundingClientRect", []); w = J.num(J.gp(r, "width")); h = J.num(J.gp(r, "height"))
	var win = _g("window"); var dv = J.num(J.gp(win, "devicePixelRatio")) if win != null else 0.0
	var dpr = minf(2.0, dv if dv > 0 else 1.0)
	J.sp(c, "width", w * dpr); J.sp(c, "height", h * dpr)
	J.sp(J.gp(c, "style"), "width", J.str(w) + "px"); J.sp(J.gp(c, "style"), "height", J.str(h) + "px")
	Q["W"] = w; Q["H"] = h; Q["dpr"] = dpr

static func target_vh() -> float:
	var p = _el("#gs-panel")
	var hh = J.num(Q.get("H")) if J.t(Q.get("H")) else 700.0
	return maxf(260.0, hh - (J.num(J.gp(p, "offsetHeight")) if p != null else 0.0) + 6)

static func geo() -> Array:
	var img = J.gp(_g("SPR"), "bg_street")
	var iw = J.num(J.gp(img, "naturalWidth")) if img != null else 0.0
	var ih = J.num(J.gp(img, "naturalHeight")) if img != null else 0.0
	if iw == 0: iw = 1536.0
	if ih == 0: ih = 1024.0
	var IH = J.num(Q.get("vh")) if J.t(Q.get("vh")) else 500.0
	var IW = IH * iw / ih
	if IW < J.num(Q.get("W")) * 1.15: IW = J.num(Q.W) * 1.15; IH = IW * ih / iw
	return [IW, IH]

static func X(fx: float) -> float: return (fx - J.num(Q.cam)) * geo()[0]
static func Yf(fy: float) -> float: return fy * geo()[1]
static func depth(fy: float) -> float: return 0.84 + 0.36 * maxf(0.0, minf(1.0, (fy - 0.72) / 0.23))
static func char_scale(fy: float) -> float: return geo()[1] * 0.25 / 58 * depth(fy)
static func to_world(e) -> Dictionary:
	var r = J.mc(_el("#gs-cvs"), "getBoundingClientRect", []); var g = geo()
	var sx = J.num(J.gp(e, "clientX")) - J.num(J.gp(r, "left")); var sy = J.num(J.gp(e, "clientY")) - J.num(J.gp(r, "top"))
	return {"fx": sx / g[0] + J.num(Q.cam), "fy": sy / g[1], "sx": sx, "sy": sy}

# ---------- 操作 ----------
static func down(e) -> void:
	if J.num(Q.kick) > 0: return
	var p = to_world(e); Q["drag"] = {"x0": p.sx, "y0": p.sy, "moved": false, "p": p}

static func move(e) -> void:
	var d = Q.get("drag")
	if not J.t(d) or J.num(Q.kick) > 0: return
	var p = to_world(e)
	if not J.t(d.moved) and sqrt(pow(p.sx - J.num(d.x0), 2) + pow(p.sy - J.num(d.y0), 2)) > 10: d["moved"] = true
	if J.t(d.moved): Q["pend"] = null; walk_to(p.fx, p.fy)

static func up(_e) -> void:
	var d = Q.get("drag"); Q["drag"] = null
	if not J.t(d) or J.t(d.moved) or J.num(Q.kick) > 0: return
	var p = d.p
	for w in Q.walkers:
		var sc = char_scale(J.num(w.y)); var h = 58 * sc
		if absf(p.fx - J.num(w.x)) * geo()[0] < 22 * sc and p.fy * geo()[1] < Yf(J.num(w.y)) + 6 and p.fy * geo()[1] > Yf(J.num(w.y)) - h:
			chat(w, true); _snd("click"); return
	if p.fy < 0.74:
		for k in GS_ORDER:
			var s = GS_STALLS[k]
			if p.fx >= s.x0 and p.fx <= s.x1: go_stall(k); return
	Q["pend"] = null; walk_to(p.fx, p.fy)

static func walk_to(fx: float, fy: float) -> void:
	var A = Q.afu; A["tx"] = maxf(0.03, minf(0.97, fx)); A["ty"] = maxf(0.78, minf(0.93, fy))

static func go_stall(k: String) -> void:
	var s = GS_STALLS[k]; _snd("click")
	Q["pend"] = k; walk_to(s.sx, 0.8)
	if J.str(Q.view.k) != "idle" and J.str(Q.view.k) != k: Q["view"] = {"k": "idle"}; render_panel()

static func arrive(k: String) -> void:
	Q["pend"] = null; Q.afu["dir"] = GS_STALLS[k].face
	var kp = Q.keepers.get(k)
	if kp != null:
		var line: String = _pick(GS_KEEPER_HI[k])
		var rx = RegEx.create_from_string("^[^：]+：")
		say(kp, rx.sub(line, ""), 3); kp["pose"] = "cast"; kp["poseT"] = 0.9
	Q["view"] = {"k": k}
	if k == "haggle": Q.view["sub"] = null
	for w in Q.walkers:
		w["bubT"] = 0.0
		if absf(J.num(w.x) - J.num(Q.afu.x)) < 0.16:
			w["tx"] = avoid(J.num(Q.afu.x) + (-0.2 if J.num(w.x) < J.num(Q.afu.x) else 0.2)); w["ty"] = 0.87 + randf() * 0.06; w["wait"] = 3.0
	render_panel(); _snd("paper")

# ---------- 每一幀 ----------
static func frame(now: float, tok) -> void:
	if not J.t(Q.get("active")) or not is_same(tok, Q.get("_tok")): return
	if now - J.num(Q.last) < 1000.0 / 30 - 2: _raf(tok); return
	var dt = minf(0.05, (now - J.num(Q.last)) / 1000.0); Q["last"] = now
	step(dt)
	if not J.t(Q.get("_nat")): draw(now / 1000.0)
	_raf(tok)

static func _dec(o: Dictionary, k: String, dt: float) -> void: o[k] = J.num(o.get(k)) - dt

static func step(dt: float) -> void:
	Q["t"] = J.num(Q.t) + dt; var A = Q.afu; var g = geo()
	var tv = target_vh(); Q["vh"] = J.num(Q.vh) + (tv - J.num(Q.vh)) * minf(1.0, dt * 7)
	if J.num(Q.kick) > 0:
		_dec(Q, "kick", dt); A["x"] = maxf(0.2, J.num(A.x) - dt * 0.12); A["tx"] = A.x; A["ty"] = A.y; A["dir"] = 1.0; A["walking"] = false; A["pose"] = "hurt"; A["poseT"] = 0.2
	else:
		var dx = (J.num(A.tx) - J.num(A.x)) * g[0]; var dy = (J.num(A.ty) - J.num(A.y)) * g[1]; var d = sqrt(dx * dx + dy * dy); var sp = 150 * depth(J.num(A.y)) * dt
		if d > 2:
			A["x"] = J.num(A.x) + dx / d * minf(sp, d) / g[0]; A["y"] = J.num(A.y) + dy / d * minf(sp, d) / g[1]
			if absf(dx) > 1: A["dir"] = 1.0 if dx > 0 else -1.0
			A["walking"] = true
			_dec(A, "dustT", dt)
			if J.num(A.dustT) <= 0:
				A["dustT"] = 0.16
				Q.parts.append({"kind": "dust", "x": J.num(A.x) - J.num(A.dir) * 0.006, "y": A.y, "vx": -J.num(A.dir) * 0.01, "vy": -0.02, "life": 0.55, "max": 0.55, "r": 3 + randf() * 3})
		else:
			if J.t(A.walking) and J.t(Q.get("pend")): arrive(J.str(Q.pend))
			A["walking"] = false
	if J.num(A.poseT) > 0:
		_dec(A, "poseT", dt)
		if J.num(A.poseT) <= 0: A["pose"] = null
	var vw = J.num(Q.W) / g[0]; var want = maxf(0.0, minf(1 - vw, J.num(A.x) - vw / 2)); Q["cam"] = J.num(Q.cam) + (want - J.num(Q.cam)) * minf(1.0, dt * 4)
	Q["cam"] = maxf(0.0, minf(1 - vw, J.num(Q.cam)))
	var TOWN = _g("TOWN")
	for k in Q.keepers:
		var kp = Q.keepers[k]
		if J.num(kp.poseT) > 0:
			_dec(kp, "poseT", dt); kp["pt"] = minf(1.0, J.num(kp.pt) + dt * 1.6)
			if J.num(kp.poseT) <= 0 and not J.t(kp.get("hold")): kp["pose"] = null
		if J.num(kp.bubT) > 0: _dec(kp, "bubT", dt)
		var near = not J.t(A.walking) and absf(J.num(A.x) - GS_STALLS[k].x) < 0.09
		if near and not J.t(kp.get("greeted")) and not J.t(kp.get("pose")):
			kp["greeted"] = true; kp["greet"] = 1.8 if (kp.k == "xiaozhi" or kp.k == "eguiking") else 1.6; kp["gt"] = 0.0
		if absf(J.num(A.x) - GS_STALLS[k].x) > 0.14: kp["greeted"] = false
		if J.num(kp.get("greet")) > 0:
			_dec(kp, "greet", dt); kp["gt"] = J.num(kp.get("gt")) + dt
			if J.t(kp.get("pose")): kp["greet"] = 0.0
		if TOWN != null: kp["st"] = J.mc(TOWN, "tick", [kp.get("st"), kp.k, dt, not J.t(kp.get("pose")) and not (J.num(kp.get("greet")) > 0), false])
	for w in Q.walkers:
		if J.num(w.bubT) > 0: _dec(w, "bubT", dt)
		if J.num(w.bump) > 0: _dec(w, "bump", dt); w["bt"] = J.num(w.get("bt")) + dt; w["walking"] = false; continue
		if J.num(w.look) > 0: _dec(w, "look", dt); w["lt"] = J.num(w.get("lt")) + dt; w["walking"] = false; continue
		var dx = (J.num(w.tx) - J.num(w.x)) * g[0]; var dy = (J.num(w.ty) - J.num(w.y)) * g[1]; var d = sqrt(dx * dx + dy * dy)
		if d > 2:
			var sp = 34 * dt; w["x"] = J.num(w.x) + dx / d * minf(sp, d) / g[0]; w["y"] = J.num(w.y) + dy / d * minf(sp, d) / g[1]
			if absf(dx) > 0.5: w["dir"] = 1.0 if dx > 0 else -1.0
			w["walking"] = true
		else:
			if J.t(w.get("walking")) and w.get("toStall") != null:
				w["look"] = 2.6 + randf() * 1.5; w["lt"] = 0.0; w["dir"] = 1.0 if GS_STALLS[w.toStall].x >= J.num(w.x) else -1.0; w["toStall"] = null
			w["walking"] = false; _dec(w, "wait", dt)
			if J.num(w.wait) <= 0:
				w["wait"] = 2 + randf() * 5
				var stl = GS_ORDER[int(floor(randf() * 4))]
				var idle = J.str(Q.view.k) == "idle"
				# JS 短路：view 唔係 idle 就唔會叫 Math.random()
				if idle and randf() < 0.3 and J.t(w.prop) and absf(GS_STALLS[stl].x - J.num(w.x)) < 0.4:
					w["tx"] = avoid(GS_STALLS[stl].x + (randf() - 0.5) * 0.07); w["ty"] = 0.79 + randf() * 0.03; w["toStall"] = stl
				else:
					w["tx"] = avoid(J.num(w.x) + (randf() - 0.5) * 0.3)
					w["ty"] = 0.86 + randf() * 0.07 if not idle else 0.79 + randf() * 0.13
					w["toStall"] = null
		_dec(w, "chatT", dt)
		if J.num(w.chatT) <= 0:
			w["chatT"] = 7 + randf() * 8
			var vis = X(J.num(w.x)) > 20 and X(J.num(w.x)) < J.num(Q.W) - 20
			var busy = J.str(Q.view.k) != "idle"
			if not busy:
				for kk in Q.keepers: if J.num(Q.keepers[kk].bubT) > 0: busy = true; break
			var other = false
			for o in Q.walkers: if not is_same(o, w) and J.num(o.bubT) > 0: other = true; break
			if vis and not busy and not other: chat(w)
	_dec(Q, "bumpCD", dt)
	var WS = Q.walkers
	for i in WS.size():
		for j in range(i + 1, WS.size()):
			var P = WS[i]; var R = WS[j]
			if J.t(P.get("walking")) and J.t(R.get("walking")) and J.t(P.prop) and J.t(R.prop) and J.num(P.dir) != J.num(R.dir) and absf(J.num(P.x) - J.num(R.x)) < 0.03 and absf(J.num(P.y) - J.num(R.y)) < 0.03 and (J.num(R.x) - J.num(P.x)) * J.num(P.dir) > 0:
				for Wd in [P, R]:
					Wd["bump"] = 1.8; Wd["bt"] = 0.0; Wd["tx"] = Wd.x; Wd["ty"] = Wd.y; Wd["toStall"] = null; Wd["wait"] = 0.5 + randf(); Wd["sorry"] = GS_SORRY[int(floor(randf() * GS_SORRY.size()))]
	if J.num(Q.bumpCD) <= 0 and J.str(Q.view.k) == "idle":
		Q["bumpCD"] = 16 + randf() * 12
		var vis = []
		for w in WS:
			if J.t(w.prop) and not J.t(w.bump) and not J.t(w.look) and X(J.num(w.x)) > 40 and X(J.num(w.x)) < J.num(Q.W) - 40: vis.append(w)
		if vis.size() >= 2:
			var P = vis[0]; var R = vis[1]; var mid = (J.num(P.x) + J.num(R.x)) / 2; var yy = 0.83 + randf() * 0.06; var l = J.num(P.x) < J.num(R.x)
			P["ty"] = yy; R["ty"] = yy; P["tx"] = avoid(mid + (0.07 if l else -0.07)); R["tx"] = avoid(mid + (-0.07 if l else 0.07)); P["wait"] = 8.0; R["wait"] = 8.0; P["toStall"] = null; R["toStall"] = null
	if randf() < dt * 1.6: Q.parts.append(mk_joss(false))
	if randf() < dt * 5:
		var o = {"kind": "steam"}; o["x"] = 0.752 + (randf() - 0.5) * 0.02; o["y"] = 0.515; o["vx"] = (randf() - 0.5) * 0.004; o["vy"] = -0.035 - randf() * 0.02; o["life"] = 2.2; o["max"] = 2.2; o["r"] = 4 + randf() * 4
		Q.parts.append(o)
	if randf() < dt * 1.2:
		var o = {"kind": "mist"}; o["x"] = 0.9 + randf() * 0.08; o["y"] = 0.6 + randf() * 0.2; o["vx"] = -0.006 - randf() * 0.01; o["vy"] = -0.004; o["life"] = 4.0; o["max"] = 4.0; o["r"] = 20 + randf() * 30
		Q.parts.append(o)
	var np = []
	for p in Q.parts:
		p["life"] = J.num(p.life) - dt; p["x"] = J.num(p.x) + J.num(p.vx) * dt; p["y"] = J.num(p.y) + J.num(p.vy) * dt
		if p.kind == "joss":
			p["rot"] = J.num(p.rot) + J.num(p.vr) * dt; p["flip"] = J.num(p.flip) + dt * J.num(p.vf); p["vx"] = J.num(p.bx) + sin(J.num(Q.t) * J.num(p.sw) + J.num(p.ph)) * 0.012
			if J.num(p.y) > J.num(p.land): p["vy"] = 0.0; p["vx"] = 0.0; p["vr"] = 0.0; p["vf"] = 0.0
		if J.num(p.life) > 0: np.append(p)
	Q["parts"] = np
	for f in Q.fog:
		f["x"] = J.num(f.x) + J.num(f.v) * dt
		if J.num(f.x) > 1.2: f["x"] = -0.2
		if J.num(f.x) < -0.2: f["x"] = 1.2
	var nf = []
	for f in Q.floats:
		f["life"] = J.num(f.life) - dt
		if J.num(f.life) > 0: nf.append(f)
	Q["floats"] = nf
	var c = _el("#gs-coins i")
	if c != null:
		var v = _fmt(_S().res.coins)
		if J.str(J.gp(c, "textContent")) != v: J.sp(c, "textContent", v)

static func avoid(nx: float) -> float:
	nx = maxf(0.03, minf(0.9, nx))
	for i in 4:
		var hit = false
		for k in Q.keepers:
			var kx = J.num(Q.keepers[k].x)
			if absf(nx - kx) < 0.05: nx = kx + (-0.06 if nx < kx else 0.06); hit = true
		var ax = J.num(Q.afu.x)
		if J.str(Q.view.k) != "idle" and absf(nx - ax) < 0.15: nx = ax + (-0.17 if nx < ax else 0.17); hit = true
		nx = maxf(0.03, minf(0.9, nx))
		if not hit: break
	return nx

static func chat(w, force := false) -> void:
	var line = ""; var i = 0; var used: Dictionary = Q.chatUsed
	while true:
		line = _pick(GS_CHATTER); i += 1
		if not (used.has(line) and i < 40): break
	if used.size() > GS_CHATTER.size() - 6: used.clear()
	used[line] = true; say(w, line, 3.6 if force else 3.2)

static func say(o, text: String, dur := 3.0) -> void:
	if o == null: return
	o["bub"] = text; o["bubT"] = dur if dur else 3.0

static func float_(fx: float, fy: float, text: String, col = null) -> void:
	var n = 0
	for f in Q.floats: if J.num(f.life) > 0.9: n += 1
	Q.floats.append({"x": fx, "y": fy + n * 0.05, "text": text, "col": col if J.t(col) else "#ffe08a", "life": 1.8, "max": 1.8})

# ---------- 畫面（交俾原生 GsDraw） ----------
static func draw(t: float) -> void:
	var ctx = Q.get("_natCtx")
	if J.t(Q.get("_nat")) and J.t(ctx) and _g("__nat_gsDraw") != null: J.cl(_g("__nat_gsDraw"), null, [ctx, Q, t])

static func near_stall():
	var A = Q.afu; var best = null; var bd = 0.09
	for k in GS_ORDER:
		var d = absf(J.num(A.x) - GS_STALLS[k].x)
		if d < bd: bd = d; best = k
	return best

# ---------- 下面的面板 ----------
static func render_panel() -> void:
	var p = _el("#gs-panel")
	if p == null: return
	var v = Q.view; var s = st(); var h = ""
	if J.str(v.k) == "idle":
		var first = J.num(s.get("visits")) <= 1
		var chips = ""
		for k in GS_ORDER: chips += "<button class=\"gs-chip\" data-k=\"%s\">%s</button>" % [k, GS_STALLS[k].name]
		h = "<p class=\"gs-hint\">%s</p>\n        <div class=\"gs-chips\">%s</div>\n        %s" % ["點地面走路，按住拖著，阿福會跟著走。點攤位直接光顧。" if first else "想去哪一攤？", chips, ("<p class=\"gs-note\">肚子裡：%s（下一場出征生效）</p>" % GS_MEALS[J.str(s.meal)].name) if J.t(s.get("meal")) else ""]
	else:
		h = "<div class=\"gs-ph\"><b>%s</b><button class=\"gs-x\" id=\"gs-x\" aria-label=\"離開\">離開</button></div><div class=\"gs-body\">%s</div>" % [GS_STALLS[J.str(v.k)].name, _html(J.str(v.k))]
	J.sp(p, "innerHTML", h)
	for b in _qall(p, ".gs-chip"):
		var bb = b
		_on(b, func(): go_stall(J.str(_ds(bb, "k"))))
	var x = _el("#gs-x")
	if x != null:
		_on(x, func():
			_snd("click")
			if J.str(v.k) == "haggle" and J.t(v.get("sub")): v["sub"] = null; render_panel(); return
			Q["view"] = {"k": "idle"}; relax(); render_panel())
	if J.str(v.k) != "idle": _bind(J.str(v.k), p)

static func _html(k: String) -> String:
	match k:
		"paper": return html_paper()
		"haggle": return html_haggle()
		"exch": return html_exch()
		"food": return html_food()
		"alley": return html_alley()
	return ""

static func _bind(k: String, p) -> void:
	match k:
		"paper": bind_paper(p)
		"haggle": bind_haggle(p)
		"exch": bind_exch(p)
		"food": bind_food(p)
		"alley": bind_alley(p)

static func relax() -> void:
	for k in Q.keepers: var kp = Q.keepers[k]; kp["hold"] = false; kp["pose"] = null; kp["poseT"] = 0.0

static func keeper_pose(k: String, pose, dur := 0.0, hold := false) -> void:
	var kp = Q.keepers.get(k)
	if kp == null: return
	kp["pose"] = pose; kp["pt"] = 0.0; kp["poseT"] = dur if dur else 1.2; kp["hold"] = hold

static func coins_ok(n: float) -> bool: return J.num(_S().res.get("coins")) >= n
static func spend(n: float) -> void: _S().res["coins"] = J.num(_S().res.coins) - n; _refresh()

# 1. 紙紮鋪
static func html_paper() -> String:
	var fx = st().fx; var li = ""
	for k in GS_EFFIGY:
		var e = GS_EFFIGY[k]; var own = J.t(fx.get(k))
		li += "<div class=\"gs-card %s\"><div class=\"gs-ci\"><b>%s</b><small class=\"gs-eff\">%s</small><small>%s</small></div>\n        <button class=\"btn %s sm gs-buy\" data-k=\"%s\" %s>%s</button></div>" % ["own" if own else "", e.name, e.eff, e.say, "ghost" if own else "gold", k, "disabled" if own or not coins_ok(e.price) else "", "已燒" if own else "燒 %s" % J.str(e.price)]
	return "<p class=\"gs-line\"><b>小紙</b>燒了就是你的，永久有效。不退貨，因為已經燒了。</p><div class=\"gs-list\">%s</div>" % li

static func bind_paper(p) -> void:
	for b in _qall(p, ".gs-buy"):
		var bb = b
		_on(b, func():
			var k = J.str(_ds(bb, "k")); var e = GS_EFFIGY[k]; var s = st()
			if J.t(s.fx.get(k)) or not coins_ok(e.price): return
			spend(e.price); s.fx[k] = true; _save(); _snd("chest")
			burn(GS_STALLS.paper.x); say(Q.keepers.paper, "燒好了！" + e.eff + "。", 3); keeper_pose("paper", "cast", 1.2)
			float_(J.num(Q.afu.x), J.num(Q.afu.y) - 0.16, "%s  到手" % e.name, "#ffe08a"); render_panel())

static func burn(fx: float) -> void:
	for i in 22:
		var o = {"kind": "joss"}
		o["x"] = fx + (randf() - 0.5) * 0.06; o["y"] = 0.62; o["bx"] = (randf() - 0.5) * 0.04; o["vx"] = 0.0; o["vy"] = -0.08 - randf() * 0.06
		o["rot"] = randf() * 6; o["vr"] = (randf() - 0.5) * 8; o["flip"] = 0.0; o["vf"] = 6.0; o["sw"] = 2.0; o["ph"] = randf() * 6; o["land"] = 2.0; o["life"] = 2 + randf(); o["max"] = 3.0
		Q.parts.append(o)

# 2. 講價攤
static func today_items() -> Array:
	var d = gs_day(); var idx = []
	for i in GS_ITEMS.size(): idx.append(i)
	idx.sort_custom(func(a, b): return gs_rnd(d * 31 + a) < gs_rnd(d * 31 + b))
	var out = []
	for i in idx.slice(0, 3): out.append(GS_ITEMS[i])
	return out

static func floor_of(it: Dictionary) -> float: return J.round(J.num(it.col) * (0.5 + 0.35 * gs_rnd(gs_day() * 977 + J.num(it.col) * 13 + J.str(it.id).length())))
static func ask_of(it: Dictionary) -> float: return J.round(J.num(it.col) * 1.15)
static func _item(id) -> Dictionary:
	for i in GS_ITEMS: if i.id == J.str(id): return i
	return {}

static func html_haggle() -> String:
	var h = st().hag; var v = Q.view
	if J.t(h.get("out")): return "<p class=\"gs-line bad\"><b>小鬼</b>還敢回來？今晚不做你生意！明天請早。</p><p class=\"gs-note\">你今晚侮辱了小鬼三次，被轟了出去。明天再來。</p>"
	if not J.t(v.get("sub")):
		var li = ""
		for it in today_items():
			var stt = h.done.get(it.id)
			li += "<button class=\"gs-card gs-item %s\" data-id=\"%s\" %s><div class=\"gs-ci\"><b>%s</b><small>%s</small><small class=\"gs-eff\">標價 %s　收藏家收購 %s</small></div><em>%s</em></button>" % ["own" if J.t(stt) else "", it.id, "disabled" if J.t(stt) else "", it.name, it.desc, J.str(ask_of(it)), J.str(it.col), "已買" if stt == "bought" else ("收起來了" if stt == "shelved" else "講價")]
		return "<p class=\"gs-line\"><b>小鬼</b>%s</p>\n        <p class=\"gs-note\">收藏家會照「收購價」收走你買到的東西。買得越便宜，賺得越多。小鬼心裡有底價，看他臉色推算。每件最多出價三次；侮辱他三次會被轟走。</p>\n        <div class=\"gs-list\">%s</div>\n        <p class=\"gs-note\">侮辱 %s/3</p>" % ["看中哪件就出價。開太低，我會翻臉。" if int(J.num(st().visits)) % 2 else "我的貨都是古董，你的出價最好也是。", li, J.str(h.strikes)]
	var it = _item(v.sub); var tries = J.num(h.tries.get(it.id)); var ask = ask_of(it); var last = v.get("last")
	var offer = J.num(v.get("offer")) if J.t(v.get("offer")) else J.round(J.num(it.col) * 0.6)
	var lv = -1.0; var mood = "打量你"
	if J.t(last):
		lv = J.num(last.band.lv) if J.t(last.get("band")) else 4.0
		mood = J.str(last.band.mood) if J.t(last.get("band")) else "成交"
	var moods = ""; var MN = ["翻臉", "很臭", "猶豫", "肉痛", "成交"]; var MC = ["#e2483a", "#d07a3a", "#d8b84a", "#9ad05a", "#5ad0a0"]
	for i in 5: moods += "<i class=\"%s\" style=\"--c:%s\">%s</i>" % ["on" if float(i) == lv else "", MC[i], MN[i]]
	var closed = J.t(v.get("closed"))
	var offer_h = "" if closed else "<div class=\"gs-offer\"><button class=\"btn sm\" id=\"gs-m\">−5</button><input type=\"range\" id=\"gs-r\" min=\"5\" max=\"%s\" step=\"1\" value=\"%s\"><button class=\"btn sm\" id=\"gs-p\">+5</button></div>\n      <button class=\"btn gold wide\" id=\"gs-go\" %s>出價 <span id=\"gs-ov\">%s</span> 冥幣</button>" % [J.str(ask), J.str(offer), "" if coins_ok(offer) else "disabled", J.str(offer)]
	return "<div class=\"gs-hag\"><b class=\"gs-iname\">%s</b><small>%s</small>\n      <div class=\"gs-prices\"><span>標價 <b>%s</b></span><span>收藏家收購 <b>%s</b></span></div>\n      <p class=\"gs-line %s\"><b>小鬼</b>%s</p>\n      <div class=\"gs-mood\"><span>臉色</span>%s<em>%s</em></div>\n      %s\n      <p class=\"gs-note\">第 %s/3 次出價　侮辱 %s/3%s</p>\n      %s</div>" % [
		it.name, it.desc, J.str(ask), J.str(it.col), "bad" if lv == 0 else "", J.str(last.line) if J.t(last) else "出個價來聽聽。", moods, mood, offer_h,
		J.str(minf(3.0, tries + (0.0 if closed else 1.0))), J.str(h.strikes), "" if closed else ("" if coins_ok(offer) else "　（冥幣不夠）"),
		"<button class=\"btn wide\" id=\"gs-back2\">看別的貨</button>" if closed else ""]

static func bind_haggle(p) -> void:
	var v = Q.view
	for b in _qall(p, ".gs-item"):
		var bb = b
		_on(b, func(): _snd("click"); v["sub"] = _ds(bb, "id"); v["last"] = null; v["closed"] = false; v["offer"] = null; render_panel(); keeper_pose("haggle", null, 0))
	var b2 = _el("#gs-back2")
	if b2 != null: _on(b2, func(): v["sub"] = null; v["closed"] = false; v["last"] = null; render_panel())
	var r = _el("#gs-r")
	if r == null: return
	var set_ = func(n: float):
		var it = _item(v.sub); n = maxf(5.0, minf(ask_of(it), n)); v["offer"] = n; J.sp(r, "value", n); J.sp(_el("#gs-ov"), "textContent", J.str(n)); J.sp(_el("#gs-go"), "disabled", not coins_ok(n))
	J.sp(r, "oninput", func(_t = null, _a = null): set_.call(J.num(J.gp(r, "value"))))
	_on(_el("#gs-m"), func(): set_.call(J.num(J.gp(r, "value")) - 5))
	_on(_el("#gs-p"), func(): set_.call(J.num(J.gp(r, "value")) + 5))
	_on(_el("#gs-go"), func(): offer(J.num(J.gp(r, "value"))))

static func offer(n: float) -> void:
	var v = Q.view; var s = st(); var h = s.hag; var it = _item(v.get("sub"))
	if it.is_empty() or J.t(h.done.get(it.id)) or J.t(h.get("out")) or not coins_ok(n): return
	var S = _S()
	var fl = floor_of(it); var r = n / fl; h.tries[it.id] = J.num(h.tries.get(it.id)) + 1; var tries = J.num(h.tries[it.id])
	v["offer"] = n
	var col = J.num(it.col)
	if r >= 1:
		spend(n); S.res["coins"] = J.num(S.res.coins) + col; h.done[it.id] = "bought"; s.curios.append(it.id)
		if s.curios.size() > 40: s.curios.pop_front()
		var fat = r >= 1.08
		v["last"] = {"band": null, "line": J.str(_pick(GS_DEAL_FAT if fat else GS_DEAL_TIGHT)) + "（收藏家用 %s 收走了，你%s了 %s）" % [J.str(col), "賺" if col - n >= 0 else "虧", J.str(absf(col - n))]}; v["closed"] = true
		keeper_pose("haggle", "cast", 1.6); Q.afu["pose"] = "cast"; Q.afu["poseT"] = 1.0
		float_(J.num(Q.afu.x), J.num(Q.afu.y) - 0.16, "%s%s 冥幣" % ["+" if col - n >= 0 else "−", J.str(absf(col - n))], "#ffe08a" if col - n >= 0 else "#ff9a8a"); _snd("coin")
	else:
		var band = null
		for b in GS_BANDS: if r < b.max: band = b; break
		var bl: Array = band.lines
		v["last"] = {"band": band, "line": bl[int(tries - 1) % bl.size()]}
		keeper_pose("haggle", null if band.pose == "idle" else band.pose, 2.4, true)
		if band.lv == 0: h["strikes"] = J.num(h.strikes) + 1; _snd("hit")
		else: _snd("paper")
		if J.num(h.strikes) >= 3:
			h["out"] = true; v.last["line"] = "三次侮辱我？給我滾！今晚別再來！"; Q["kick"] = 1.1; say(Q.keepers.haggle, "滾！", 2); Q.afu["pose"] = "hurt"; _snd("whoosh")
		elif tries >= 3:
			h.done[it.id] = "shelved"; v.last["line"] = J.str(v.last.line) + "……三次都談不攏，這件我收起來了！"; v["closed"] = true
		var ln = J.str(v.last.line)
		say(Q.keepers.haggle, ln.substr(0, 20) + "……" if ln.length() > 22 else ln, 2.4)
	_save(); render_panel()

# 3. 冥幣兌換
static func price(d: float) -> float:
	var v = 100 * (1 + 0.16 * sin(d * 0.5) + 0.05 * sin(d * 1.9 + 1.3) + 0.06 * (gs_rnd(d * 7 + 3) - 0.5))
	return maxf(30.0, J.round(v))

static func html_exch() -> String:
	var d = gs_day(); var p = price(d); var y = price(d - 1); var ch = (p - y) / y * 100; var upv = price(d + 1) >= p; var sk = st().stock
	var news = (GS_NEWS_UP if upv else GS_NEWS_DN)[int(floor(gs_rnd(d * 5 + 1) * 5))]
	var val = J.num(sk.n) * p; var pl = val - J.num(sk.cost) if J.t(sk.n) else 0.0
	var pls = ("<span class=\"%s\">%s %s</span>" % ["up" if pl >= 0 else "dn", "賺" if pl >= 0 else "虧", _fmt(absf(pl))]) if J.t(sk.n) else ""
	return "<p class=\"gs-line\"><b>白無常</b>一見生財！小道消息：「%s」</p>\n      <div class=\"gs-stock\"><div><small>地府科技（今日）</small><b class=\"gs-px\">%s</b><em class=\"%s\">%s %s%%</em></div><canvas id=\"gs-chart\"></canvas></div>\n      <p class=\"gs-note\">持有 %s 股（上限 %s）　市值 %s　%s　手續費 %s%%（買賣都收）</p>\n      <div class=\"gs-trade\"><button class=\"btn sm gs-t\" data-q=\"1\">買 1</button><button class=\"btn sm gs-t\" data-q=\"10\">買 10</button><button class=\"btn sm gs-t\" data-q=\"-1\">賣 1</button><button class=\"btn sm gs-t\" data-q=\"-10\">賣 10</button><button class=\"btn sm gs-t\" data-q=\"-999\">全賣</button></div>\n      <p class=\"gs-note dim\">價格每天換一次。白無常的小道消息說的是「明天」，他從來沒說錯過——只是不保證漲多少。</p>" % [
		news, J.str(p), "up" if ch >= 0 else "dn", "▲" if ch >= 0 else "▼", J.str(JStr.num_call(absf(ch), "toFixed", [1])),
		J.str(sk.n), J.str(GS_SHARE_CAP), _fmt(val), pls, J.str(GS_FEE * 100)]

static func bind_exch(p) -> void:
	for b in _qall(p, ".gs-t"):
		var q = J.num(_ds(b, "q")); var px = price(gs_day()); var sk = st().stock
		if q > 0: J.sp(b, "disabled", J.num(sk.n) >= GS_SHARE_CAP or not coins_ok(ceil(px * minf(q, GS_SHARE_CAP - J.num(sk.n)) * (1 + GS_FEE))))
		else: J.sp(b, "disabled", J.num(sk.n) <= 0)
		var qq = q
		_on(b, func(): trade(qq))
	draw_chart()

static func trade(q: float) -> void:
	var s = st(); var sk = s.stock; var px = price(gs_day()); var S = _S()
	if q > 0:
		q = minf(q, GS_SHARE_CAP - J.num(sk.n)); var cost = ceil(px * q * (1 + GS_FEE))
		if q <= 0 or not coins_ok(cost): return
		spend(cost); sk["n"] = J.num(sk.n) + q; sk["cost"] = J.num(sk.cost) + cost
		float_(J.num(Q.afu.x), J.num(Q.afu.y) - 0.16, "買入 %s 股" % J.str(q), "#bfe8ff"); say(Q.keepers.exch, _pick(["一見生財！有眼光！", "買定離手～", "恭喜發財，虧了別找我。"]), 2.4)
	else:
		q = minf(-q, J.num(sk.n))
		if q <= 0: return
		var got = floor(px * q * (1 - GS_FEE)); var basis = J.num(sk.cost) * q / J.num(sk.n)
		sk["cost"] = J.num(sk.cost) - basis; sk["n"] = J.num(sk.n) - q; S.res["coins"] = J.num(S.res.coins) + got; _refresh()
		float_(J.num(Q.afu.x), J.num(Q.afu.y) - 0.16, "賣出 +%s" % J.str(got), "#ffe08a" if got >= basis else "#ff9a8a")
		say(Q.keepers.exch, "一見生財！賺到了吧～" if got >= basis else "虧了？陰間也有韭菜的。", 2.4)
	if J.num(sk.n) == 0: sk["cost"] = 0.0
	keeper_pose("exch", "cast", 1); _snd("coin"); _save(); render_panel()

static func draw_chart() -> void:
	var c = _el("#gs-chart")
	if c == null: return
	var r = J.mc(c, "getBoundingClientRect", [])
	var win = _g("window"); var dv = J.num(J.gp(win, "devicePixelRatio")) if win != null else 0.0
	var dpr = minf(2.0, dv if dv > 0 else 1.0)
	var w = J.num(J.gp(r, "width")); if w == 0: w = 200.0
	var h = J.num(J.gp(r, "height")); if h == 0: h = 84.0
	J.sp(c, "width", w * dpr); J.sp(c, "height", h * dpr)
	var ctx = J.mc(c, "getContext", ["2d"])
	if not (ctx is Ctx): return
	var cx: Ctx = ctx
	cx.scale(dpr, dpr)
	var d = gs_day(); var ps = []
	for i in 7: ps.append(price(d - 6 + i))
	var lo = ps.min() * 0.95; var hi = ps.max() * 1.05
	var Xf = func(i): return 10 + i * (w - 20) / 6
	var Yv = func(v): return h - 16 - (v - lo) / (hi - lo) * (h - 28)
	cx.strokeStyle = "rgba(255,255,255,.12)"; cx.lineWidth = 1
	for i in 3:
		var y = 8 + i * (h - 24) / 2; cx.beginPath(); cx.moveTo(4, y); cx.lineTo(w - 4, y); cx.stroke()
	cx.strokeStyle = "#9be8b0"; cx.lineWidth = 2.2; cx.beginPath()
	for i in 7:
		if i: cx.lineTo(Xf.call(i), Yv.call(ps[i]))
		else: cx.moveTo(Xf.call(i), Yv.call(ps[i]))
	cx.stroke()
	for i in 7:
		cx.fillStyle = "#ffcf6a" if i == 6 else "#9be8b0"; cx.beginPath(); cx.arc(Xf.call(i), Yv.call(ps[i]), 4.5 if i == 6 else 2.6, 0, 7); cx.fill()
	cx.fillStyle = "rgba(230,220,255,.7)"; cx.font = "11px sans-serif"
	var L = ["六天前", "", "", "", "", "昨天", "今天"]
	for i in 7:
		if L[i] == "": continue
		cx.textAlign = "left" if i == 0 else ("right" if i == 6 else "center")
		cx.fillText(L[i], 2.0 if i == 0 else (w - 2 if i == 6 else Xf.call(i)), h - 2)

# 4. 宵夜檔
static func html_food() -> String:
	var s = st(); var ate = J.t(Q.get("ate")); var li = ""
	for k in GS_MEALS:
		var m = GS_MEALS[k]
		li += "<div class=\"gs-card %s\"><div class=\"gs-ci\"><b>%s</b><small class=\"gs-eff\">%s</small><small>%s</small></div>\n          <button class=\"btn gold sm gs-eat\" data-k=\"%s\" %s>%s</button></div>" % ["own" if s.get("meal") == k else "", m.name, m.eff, m.say, k, "disabled" if ate or not coins_ok(m.price) else "", "吃飽了" if ate else "吃 %s" % J.str(m.price)]
	return "<p class=\"gs-line\"><b>餓鬼王</b>%s</p>\n      %s\n      <div class=\"gs-list\">%s</div>" % ["吃飽了就走！後面還有鬼在排隊！" if ate else "一次只准點一碗！吃完下一場打架才有力！", ("<p class=\"gs-note\">肚子裡：<b>%s</b>（下一場出征生效，再點會換掉）</p>" % GS_MEALS[J.str(s.meal)].name) if J.t(s.get("meal")) else "", li]

static func bind_food(p) -> void:
	for b in _qall(p, ".gs-eat"):
		var bb = b
		_on(b, func():
			var k = J.str(_ds(bb, "k")); var m = GS_MEALS[k]
			if J.t(Q.get("ate")) or not coins_ok(m.price): return
			spend(m.price); st()["meal"] = k; Q["ate"] = true; _save(); _snd("harvest")
			say(Q.keepers.food, _pick(["吃！吃完去打！", "好吃吧？我也想吃……我可以吃一口嗎？", "湯可以續，碗不能拿走！"]), 2.6); keeper_pose("food", "cast", 1.2)
			Q.afu["pose"] = "cast"; Q.afu["poseT"] = 0.8; float_(J.num(Q.afu.x), J.num(Q.afu.y) - 0.16, m.eff.replace("下一場出征：", ""), "#a8ffcf"); render_panel())

# 5. 暗巷
static func html_alley() -> String:
	var ad = Q.get("alleyDone")
	if J.t(ad): return "<p class=\"gs-line\">%s</p><p class=\"gs-note\">%s</p><p class=\"gs-note dim\">今晚巷子裡已經沒有別的事了。下次再來看看。</p>" % [J.str(ad.out), ("結果：" + J.str(ad.got)) if J.t(ad.get("got")) else ""]
	if not J.t(Q.get("alleyEv")):
		var s = st(); var pool = []
		for e in GS_ALLEY: if e.id != s.get("alleyLast"): pool.append(e)
		var ev = null; var nw = _g("N30W")
		if nw != null:
			var x = J.mc(nw, "alleyEvent", [])
			if J.t(x): ev = x
		if ev == null: ev = pool[int(floor(randf() * pool.size()))]
		Q["alleyEv"] = ev; s["alleyLast"] = J.gp(ev, "id"); _save()
	var e = Q.alleyEv
	return "<p class=\"gs-line\">%s</p>%s%s" % [J.str(J.gp(e, "text")), _opt(J.gp(e, "a"), "a"), _opt(J.gp(e, "b"), "b")]

static func _opt(o, k: String) -> String:
	var cost = J.gp(o, "cost")
	return "<button class=\"btn %s wide gs-al\" data-k=\"%s\" %s>%s%s</button>" % ["gold" if k == "a" else "", k, "disabled" if J.t(cost) and not coins_ok(J.num(cost)) else "", J.str(J.gp(o, "label")), ("（%s 冥幣）" % J.str(cost)) if J.t(cost) else ""]

static func bind_alley(p) -> void:
	for b in _qall(p, ".gs-al"):
		var bb = b
		_on(b, func():
			var o = J.gp(Q.alleyEv, J.str(_ds(bb, "k"))); var cost = J.gp(o, "cost")
			if J.t(cost) and not coins_ok(J.num(cost)): return
			if J.t(cost): spend(J.num(cost))
			var gv = J.gp(o, "give"); var r = (gv as Dictionary).duplicate(true) if gv is Dictionary else {}
			var S = _S()
			if J.t(r.get("troops")): r["troops"] = maxf(0.0, minf(J.num(r.troops), J.num(J.mc(_g("F"), "troopCap", [])) - J.num(S.res.troops)))
			if r.has("troops") and J.num(r.troops) == 0: r.erase("troops")
			var got = J.str(J.cl(_g("give"), null, [r])) if r.size() else ""
			if J.t(cost): got = "冥幣 −%s" % J.str(cost) + (("，" + got) if got != "" else "")
			var jn = J.gp(o, "join")
			if J.t(jn):
				J.cl(_g("joinGhost"), null, [jn]); got += ("，" if got != "" else "") + "%s加入" % J.str(J.gp(J.gp(_g("GHOSTS"), J.str(jn)), "name"))
			Q["alleyDone"] = {"out": J.gp(o, "out"), "got": got}; _snd("chest" if J.t(r.get("chest")) else "paper"); _save(); _refresh()
			var first = got.split("，")[0]
			float_(J.num(Q.afu.x), J.num(Q.afu.y) - 0.16, first if first != "" else "……", "#e6dcff"); render_panel())

# ================= 登記 =================
func run(_env) -> void:
	J.G["GS_STALLS"] = GS_STALLS.duplicate(true)
	J.G["GS_ORDER"] = GS_ORDER.duplicate()
	J.G["GS_EFFIGY"] = GS_EFFIGY.duplicate(true)
	J.G["GS_ITEMS"] = GS_ITEMS.duplicate(true)
	J.G["GS_BANDS"] = GS_BANDS.duplicate(true)
	J.G["GS_DEAL_TIGHT"] = GS_DEAL_TIGHT.duplicate()
	J.G["GS_DEAL_FAT"] = GS_DEAL_FAT.duplicate()
	J.G["GS_MEALS"] = GS_MEALS.duplicate(true)
	J.G["GS_NEWS_UP"] = GS_NEWS_UP.duplicate()
	J.G["GS_NEWS_DN"] = GS_NEWS_DN.duplicate()
	J.G["GS_FEE"] = GS_FEE
	J.G["GS_SHARE_CAP"] = GS_SHARE_CAP
	J.G["GS_CHATTER"] = GS_CHATTER.duplicate()
	J.G["GS_WANDER"] = GS_WANDER.duplicate()
	J.G["GS_PROPS"] = GS_PROPS.duplicate(true)
	J.G["GS_WORKFACE"] = GS_WORKFACE.duplicate()
	J.G["GS_POT"] = GS_POT.duplicate()
	J.G["GS_SORRY"] = GS_SORRY.duplicate()
	J.G["GS_KEEPER_HI"] = GS_KEEPER_HI.duplicate(true)
	J.G["GS_ALLEY"] = GS_ALLEY.duplicate(true)
	J.G["GS_LANTERNS"] = GS_LANTERNS.duplicate(true)
	J.G["gsDay"] = func(_t, _a): return gs_day()
	J.G["gsRnd"] = func(_t, a): return gs_rnd(J.num(J.arg(a, 0)))
	J.G["__gsDC"] = func(_t, a):
		var o = J.arg(a, 5)
		var od = (o as Dictionary).duplicate() if o is Dictionary else {}
		if J.t(Q.get("_nat")) and not J.t(od.get("act")) and _g("__nat_drawChar") != null: return J.cl(_g("__nat_drawChar"), null, [J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), od])
		return J.mc(_g("ART"), "drawChar", [J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), o])
	Q = {
		"active": false,
		"st": func(_t, _a): return st(),
		"mul": func(_t, a): return mul(J.str(J.arg(a, 0))),
		"bonus": func(_t, a): return bonus(J.str(J.arg(a, 0))),
		"battleBuffs": func(_t, a): return battle_buffs(J.arg(a, 0)),
		"open": func(_t, _a): open_(); return null,
		"close": func(_t, _a): close(); return null,
		"resize": func(_t, _a): resize(); return null,
		"targetVH": func(_t, _a): return target_vh(),
		"geo": func(_t, _a): var g = geo(); return {"IW": g[0], "IH": g[1]},
		"X": func(_t, a): return X(J.num(J.arg(a, 0))),
		"Y": func(_t, a): return Yf(J.num(J.arg(a, 0))),
		"depth": func(_t, a): return depth(J.num(J.arg(a, 0))),
		"charScale": func(_t, a): return char_scale(J.num(J.arg(a, 0))),
		"down": func(_t, a): down(J.arg(a, 0)); return null,
		"move": func(_t, a): move(J.arg(a, 0)); return null,
		"up": func(_t, a): up(J.arg(a, 0)); return null,
		"walkTo": func(_t, a): walk_to(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))); return null,
		"goStall": func(_t, a): go_stall(J.str(J.arg(a, 0))); return null,
		"arrive": func(_t, a): arrive(J.str(J.arg(a, 0))); return null,
		"step": func(_t, a): step(J.num(J.arg(a, 0))); return null,
		"mkJoss": func(_t, a): return mk_joss(J.t(J.arg(a, 0))),
		"avoid": func(_t, a): return avoid(J.num(J.arg(a, 0))),
		"chat": func(_t, a): chat(J.arg(a, 0), J.t(J.arg(a, 1))); return null,
		"say": func(_t, a): say(J.arg(a, 0), J.str(J.arg(a, 1)), J.num(J.arg(a, 2))); return null,
		"float": func(_t, a): float_(J.num(J.arg(a, 0)), J.num(J.arg(a, 1)), J.str(J.arg(a, 2)), J.arg(a, 3)); return null,
		"draw": func(_t, a): draw(J.num(J.arg(a, 0))); return null,
		"nearStall": func(_t, _a): return near_stall(),
		"renderPanel": func(_t, _a): render_panel(); return null,
		"relax": func(_t, _a): relax(); return null,
		"keeperPose": func(_t, a): keeper_pose(J.str(J.arg(a, 0)), J.arg(a, 1), J.num(J.arg(a, 2)), J.t(J.arg(a, 3))); return null,
		"coinsOk": func(_t, a): return coins_ok(J.num(J.arg(a, 0))),
		"spend": func(_t, a): spend(J.num(J.arg(a, 0))); return null,
		"html_paper": func(_t, _a): return html_paper(),
		"html_haggle": func(_t, _a): return html_haggle(),
		"html_exch": func(_t, _a): return html_exch(),
		"html_food": func(_t, _a): return html_food(),
		"html_alley": func(_t, _a): return html_alley(),
		"burn": func(_t, a): burn(J.num(J.arg(a, 0))); return null,
		"todayItems": func(_t, _a): return today_items(),
		"floorOf": func(_t, a): return floor_of(J.arg(a, 0)),
		"askOf": func(_t, a): return ask_of(J.arg(a, 0)),
		"offer": func(_t, a): offer(J.num(J.arg(a, 0))); return null,
		"price": func(_t, a): return price(J.num(J.arg(a, 0))),
		"trade": func(_t, a): trade(J.num(J.arg(a, 0))); return null,
		"drawChart": func(_t, _a): draw_chart(); return null,
	}
	J.G["GhostStreet"] = Q
