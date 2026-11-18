# 原生改寫自 phone.js（仿 ApaKhabar 手機：生前／陰間版聊天列表、聊天畫面、封面）
# 介面同轉譯版一樣：ICON、TICK、waAvatar、waStatus、nowHM、CHATS_PRE、chatsPost、Phone、Title
# 固定數據（ICON、CHATS_PRE）喺 data/nat/phone.json（由原 JS 直接輸出）
# 註：js/bridge.gd connect_ui 之後會將 Title 同 Phone.home/close/enter 換成原生 ui/whatsapp.gd；呢度保留網頁版行為做後備
extends RefCounted

static var ICON: Dictionary = {}
static var CHATS_PRE: Array = []

static func _g(n: String): return J.G.get(n)
static func _snd(m: String, a: Array = []): return J.mc(_g("Sound"), m, a)
static func _q(sel: String): return J.cl(_g("$"), null, [sel])

static func tick(blue, two) -> String: return "<span class=\"tk%s\">%s</span>" % [" blue" if J.t(blue) else "", "✓✓" if J.t(two) else "✓"]
static func wa_avatar(av, size: float) -> String:
	if J.str(av) == "sys" and av is String:
		var cv = J.mc(_g("ART"), "sysIcon", [size * 2])
		return "<span class=\"av sys\" style=\"width:%spx;height:%spx\"><img src=\"%s\" alt=\"\"></span>" % [J.str(size), J.str(size), J.str(J.mc(cv, "toDataURL", []))]
	return "<span class=\"av\" style=\"width:%spx;height:%spx;background:%s;font-size:%spx\">%s</span>" % [J.str(size), J.str(size), J.str(av[1]), J.str(J.round(size * 0.42)), J.str(av[0])]
static func wa_status(time, batt, low) -> String:
	return "<div class=\"wa-status\"><b>%s</b><span class=\"wa-sig\"><i></i><i></i><i></i><i></i></span><span class=\"wa-batt %s\"><em style=\"width:%d%%\"></em></span><small>%s</small></div>" % [J.str(time), "low" if J.t(low) else "", 8 if J.t(low) else 70, J.str(batt)]
static func now_hm() -> String:
	var d = Time.get_datetime_dict_from_system()
	return "%02d:%02d" % [d.hour, d.minute]

# ---------------- 死後：陰間版（內容隨劇情進度改變） ----------------
static func chats_post() -> Array:
	var S = _g("S")
	var sn = func(id): return J.t(J.gp(J.gp(S, "seen"), id))
	var ended = J.t(J.gp(S, "ended"))
	var out = []
	out.append({"id": "kpi", "name": "陰司好好系統" if ended else "陰司 KPI 系統", "av": "sys", "time": now_hm(), "unread": 1.0, "pin": true, "main": true,
		"prev": "親，今天沒有 KPI，想來就來。" if ended else "親，鬼怪們都在等你上班哦～"})
	# 媽
	var mm = [["媽", "頭七", "阿福，頭七了。媽給你燒了一個傭人，叫小紙，你別欺負人家。"]]
	if sn.call("gift_phone"): mm.append_array([["媽", "清明前", "手機收到了嗎？店家說下面也能用 ApaKhabar。"], ["媽", "清明前", "媽不知道你看不看得到，就當媽自言自語吧。"]])
	if sn.call("ch3_end"): mm.append_array([["媽", "中元前", "媽幫你看了一塊新的地，坐北向南，前面有樹，風水第一流。"], ["媽", "中元前", "負責的人說前面是垃圾場。媽跟他講：那叫聚財。"]])
	if sn.call("gift_car"): mm.append(["媽", "中元節", "車也燒給你了，你開慢點。生前你那麼急，現在慢慢來。"])
	if sn.call("epilogue"): mm.append_array([["媽", "清明", "媽給你燒了一張假條。這次你一定要放。"], ["我", "清明", "媽，我不忙了。"], ["媽", "清明", "……阿福？"]])
	var last = mm[mm.size() - 1]
	var mom_n = 0
	for m in mm: if m[0] == "媽": mom_n += 1
	out.append({"id": "mom2", "name": "媽", "av": ["媽", "#b06a5a"], "time": last[1], "unread": 0.0 if sn.call("epilogue") else float(mom_n), "prev": last[2], "mine": last[0] == "我", "msgs": mm, "hold": "" if sn.call("epilogue") else "（訊息傳不出去：對方在陽間）"})
	if is_female(S): return _post_f(out, sn)
	# 黃總
	var bm = [["黃總", "02:47", "好？句號呢？"], ["黃總", "09:12", "阿福？董事會開始了。"], ["黃總", "09:40", "阿福你人呢？"], ["黃總", "下午 3:03", "HR 說你過世了。節哀。"], ["黃總", "下午 3:04", "PPT 誰接手？密碼是什麼？"]]
	if sn.call("ch6_end"): bm.append_array([["黃總", "最近", "阿福，我在村裡學包包子。"], ["黃總", "最近", "很難。我包了一百個，孟婆說九十九個不合格。"], ["黃總", "最近", "剩下那一個是我自己。"]])
	var bl = bm[bm.size() - 1]
	out.append({"id": "boss2", "name": "黃總", "av": ["黃", "#5a6a7a"], "time": bl[1], "unread": 3.0 if sn.call("ch6_end") else 2.0, "prev": bl[2], "msgs": bm, "hold": "（你已離職，無法回覆此對話）"})
	for c in chats_post_village(sn): out.append(c)
	out.append({"id": "ins2", "name": "保險經紀 阿明", "av": ["明", "#3a6a8a"], "time": "上個月", "unread": 2.0, "prev": "那份人壽保險……現在買還來得及嗎？",
		"msgs": [["我", "很久以前", "不用了，我還年輕。"], ["阿明", "上個月", "陳先生，聽說您走了，節哀。"], ["阿明", "上個月", "那份人壽保險……現在買還來得及嗎？"]]})
	out.append({"id": "land2", "name": "房東 Mr. Lim", "av": ["林", "#5a5a5a"], "time": "上個月", "unread": 2.0, "prev": "Deposit 不還了。",
		"msgs": [["Mr. Lim", "上個月", "阿福，你在屋裡走的，現在變凶宅，租不出了 lah。"], ["Mr. Lim", "上個月", "Deposit 不還了。"], ["Mr. Lim", "上星期", "還有，這個月的屋租你還沒給。"]]})
	out.append({"id": "gym2", "name": "FitLife 健身中心", "av": ["F", "#2a7a5a"], "time": "今天", "unread": 2.0, "prev": "違約金 RM1,200，可以分期哦 🙏",
		"msgs": [["FitLife", "昨天", "陳先生，系統顯示您已 3 年 2 個月未到店。"], ["FitLife", "昨天", "請問您還活著嗎？若否，請回覆 0 取消會籍。"], ["FitLife", "今天", "收到您家人的通知，節哀。提早取消會籍的違約金 RM1,200，可以分期哦 🙏"]]})
	out.append({"id": "food2", "name": "外賣 Abang Ali", "av": ["A", "#8a6a2a"], "time": "上個月", "prev": "Boss, makanan masih depan pintu… dah berkulat 😅",
		"msgs": [["Abang Ali", "21:47", "Boss, makanan saya letak depan pintu ya 🙏"], ["Abang Ali", "三天後", "Boss, makanan masih depan pintu… dah berkulat 😅"], ["Abang Ali", "三天後", "Tapi tolong bagi 5 bintang ya boss 🙏"]]})
	out.append({"id": "tel", "name": "地府電訊", "av": ["冥", "#6a3a3a"], "time": "每月一號", "prev": "您的「永生無限」月租計劃已自動續約。",
		"msgs": [["地府電訊", "每月一號", "您的「永生無限」月租計劃已自動續約：每月 100 億冥幣，請家屬按時焚燒。"], ["地府電訊", "每月一號", "溫馨提示：陽間來電一律轉接至語音信箱。"]]})
	out.append({"id": "clinic2", "name": "康健診所", "av": ["診", "#4a7a8a"], "time": "上個月", "prev": "建議您多休息。",
		"msgs": [["康健診所", "3 星期前", "陳先生，您的體檢報告出來了，請盡快回來見醫生。"], ["康健診所", "上個月", "因為您一直沒回來複診，報告已經寄到府上：建議您多休息。"]]})
	return out

static func chats_post_village(sn: Callable) -> Array:
	var vo = []
	# 村民群
	if sn.call("ch2_intro"):
		var gm = [["小紙", "早上", "今天的壽包誰偷吃了？少了三個。"], ["餓鬼王", "早上", "不是我，我的喉嚨只能一次吞一粒米。"]]
		if sn.call("ch2_end"): gm.append_array([["Toyol", "早上", "也不是我！我只偷錢，不偷吃的！"], ["小紙", "早上", "……你剛剛承認了什麼？"]])
		if sn.call("ch3_end"): gm.append_array([["老殭", "中午", "本官昨夜跳去人間，看見有人在跳廣場舞。"], ["老殭", "中午", "他們跳得比本官還僵硬。"]])
		if sn.call("ch4_end"): gm.append_array([["Pontianak", "晚上", "誰把我的香蕉拿去做香蕉煎餅了？"], ["餓鬼王", "晚上", "……好吃。"]])
		if sn.call("ch5_end"): gm.append_array([["Penanggal", "半夜", "提醒大家：倉庫那缸醋是我的，不是調味料。誰再拿去沾餃子，我就飛過去。"], ["Pocong", "半夜", "（舉手）"]])
		if sn.call("ch6_mengpo"): gm.append(["孟婆", "半夜", "今晚湯底換了，喝了不會忘事，只會忘記熱量。"])
		var gl = gm[gm.size() - 1]
		vo.append({"id": "vg", "name": "落魄村村民群", "av": ["群", "#3f6a5a"], "time": gl[1], "unread": float(gm.size()), "mute": true, "prev": gl[0] + "：" + gl[2], "sub": "小紙、餓鬼王、你…", "msgs": gm})
	if sn.call("ch6_end"):
		vo.append({"id": "opt", "name": "落魄村優化小組", "av": ["優", "#7a4a3a"], "time": "00:00", "unread": 2.0, "mute": true, "prev": "黃總：不要給我藉口。", "sub": "黃總、你…",
			"msgs": [["黃總", "23:58", "明天早上，大家提早半個小時出來。"], ["黃總", "23:59", "KPI：每隻鬼每天嚇三個人。"], ["小紙", "00:00", "黃總，我們是鬼，早上不能出來的。"], ["黃總", "00:00", "不要給我藉口。"]], "hold": "（已讀。你決定不回。）"})
	return vo

# ---------------- 女主（四眼妹，第一期鎖住；揀咗女主先用）----------------
# 女主生前同黃總、Bryan 冇交集：生前嘅手機係大學期末分組功課群組，冇公司、房東、健身、保險
static func is_female(S) -> bool:
	var h = J.gp(S, "hero") if S != null else null
	return h is Dictionary and str(h.get("sex", "m")) == "f"

static func chats_pre_f() -> Array:
	return [
		{"id": "grp", "name": "期末 project 死線組", "av": ["組", "#4a6a5a"], "time": "02:13", "unread": 1.0, "prev": "各位，明早九點交 report，做到哪了？", "main": true},
		{"id": "momf", "name": "媽", "av": ["媽", "#b06a5a"], "time": "星期日", "unread": 2.0, "prev": "阿福，那考完呢？",
			"msgs": [["媽", "星期三 19:02", "阿福，最近天天下大雨，出門記得帶傘。"], ["我", "星期三 23:40", "嗯"], ["媽", "星期五 20:15", "你爸說想你了。他不會說，但我知道。"], ["媽", "星期五 20:16", "這個月回來吃飯嗎？"],
				["我", "星期六 01:22", "要溫書，考完試再回來"], ["媽", "星期日 18:30", "媽煲了你最愛的蓮藕湯，給你留了一碗。"], ["媽", "星期日 21:04", "阿福，那考完呢？"]], "hold": "（你打算溫完這一章再回）"},
		{"id": "hall", "name": "宿舍 C 座住客群", "av": ["宿", "#5a5a7a"], "time": "01:30", "unread": 12.0, "mute": true, "prev": "舍監：請把洗衣機裡的衣服拿走。", "sub": "舍監、住客…",
			"msgs": [["舍監", "00:40", "提提大家：考試週自修室通宵開放，回宿舍請刷卡。"], ["舍監", "01:30", "請把洗衣機裡的衣服拿走。"]]},
		{"id": "lib", "name": "大學圖書館", "av": ["圖", "#3a6a5a"], "time": "昨天", "prev": "您借閱的書已逾期 3 天。",
			"msgs": [["大學圖書館", "昨天 09:00", "您借閱的《高等微積分（第三版）》已逾期 3 天，請盡快歸還。"]]},
		{"id": "food", "name": "外賣 Abang Ali", "av": ["A", "#8a6a2a"], "time": "21:47", "prev": "Boss, makanan saya letak depan pintu ya 🙏",
			"msgs": [["Abang Ali", "21:46", "Boss, dah sampai. Tekan loceng takde orang."], ["Abang Ali", "21:47", "Boss, makanan saya letak depan pintu ya 🙏"]]},
		{"id": "clinicf", "name": "大學醫療中心", "av": ["醫", "#4a7a8a"], "time": "3 星期前", "prev": "建議您減少用眼，早點休息。",
			"msgs": [["大學醫療中心", "3 星期前", "陳同學，您的視力檢查結果出來了：近視再加深 150 度。"], ["大學醫療中心", "3 星期前", "建議您減少用眼，早點休息。"]]},
	]

static func _post_f(out: Array, sn: Callable) -> Array:
	# 期末群組：佢個「好。」一直傳送中；之後群組照常交咗份 report
	var gm = [["+60 11-2093 4471", "02:47", "學霸順便排版，謝啦！"], ["+60 12-418 7730", "09:05", "學霸你人呢？要交了"], ["+60 16-552 0913", "下午 3:10", "……聽說學霸走了。"], ["+60 12-418 7730", "下午 3:12", "Report 我們交了，你的名字有寫上去。"]]
	out.append({"id": "grp2", "name": "期末 project 死線組", "av": ["組", "#4a6a5a"], "time": "下午 3:12", "unread": 4.0, "prev": gm[3][2], "sub": "組員 3 人、你", "msgs": gm, "hold": "（你已退出此群組）"})
	if sn.call("ch6_end"):
		var bm = [["黃總", "最近", "阿福，我在村裡學包包子。"], ["黃總", "最近", "很難。我包了一百個，孟婆說九十九個不合格。"], ["黃總", "最近", "剩下那一個是我自己。"]]
		out.append({"id": "boss2", "name": "黃總", "av": ["黃", "#5a6a7a"], "time": "最近", "unread": 3.0, "prev": bm[2][2], "msgs": bm})
	# 村民群、優化小組：同男主一樣（陰間嘅事，同生前身份無關）
	for c in chats_post_village(sn): out.append(c)
	out.append({"id": "food2", "name": "外賣 Abang Ali", "av": ["A", "#8a6a2a"], "time": "上個月", "prev": "Boss, makanan masih depan pintu… dah berkulat 😅",
		"msgs": [["Abang Ali", "21:47", "Boss, makanan saya letak depan pintu ya 🙏"], ["Abang Ali", "三天後", "Boss, makanan masih depan pintu… dah berkulat 😅"], ["Abang Ali", "三天後", "Tapi tolong bagi 5 bintang ya boss 🙏"]]})
	out.append({"id": "tel", "name": "地府電訊", "av": ["冥", "#6a3a3a"], "time": "每月一號", "prev": "您的「永生無限」月租計劃已自動續約。",
		"msgs": [["地府電訊", "每月一號", "您的「永生無限」月租計劃已自動續約：每月 100 億冥幣，請家屬按時焚燒。"], ["地府電訊", "每月一號", "溫馨提示：陽間來電一律轉接至語音信箱。"]]})
	out.append({"id": "lib2", "name": "大學圖書館", "av": ["圖", "#3a6a5a"], "time": "上個月", "prev": "逾期罰款已轉交家屬處理。",
		"msgs": [["大學圖書館", "上個月", "您借閱的《高等微積分（第三版）》已逾期 30 天。"], ["大學圖書館", "上個月", "收到您家人的通知，節哀。逾期罰款已轉交家屬處理。"]]})
	return out

# ---------------- 手機畫面（網頁版後備） ----------------
static var PH: Dictionary = {}
static func ph_home(phase) -> void:
	PH["on"] = true; PH["phase"] = phase
	var el = _q("#phone"); J.sp(el, "className", "on")
	var pre = J.str(phase) == "pre"; var list = (chats_pre_f() if is_female(_g("S")) else CHATS_PRE) if pre else chats_post()
	var time = "02:13" if pre else now_hm()
	var unread = 0
	for c in list: if J.t(c.get("unread")): unread += 1
	var h = "<div class=\"wa\">%s\n      <div class=\"wa-top\"><b>ApaKhabar</b>%s<button class=\"wa-snd\" aria-label=\"聲音\">%s</button><span class=\"ic\">%s</span><span class=\"ic\">%s</span></div>\n      <div class=\"wa-search\">在 ApaKhabar 中搜尋…</div>\n      <div class=\"wa-chips\"><span class=\"on\">全部</span><span>未讀 %d</span><span>群組</span></div>\n      <div class=\"wa-list\">" % [wa_status(time, "3%" if pre else "∞", pre), "" if pre else "<i class=\"hell\">陰間版</i>", "🔊" if J.t(_snd("isOn")) else "🔇", ICON.cam, ICON.dots, unread]
	for c in list:
		h += "<div class=\"wa-row %s\" data-id=\"%s\">%s\n        <div class=\"wr-mid\"><div class=\"wr-l1\"><b>%s</b><small class=\"%s\">%s</small></div>\n        <div class=\"wr-l2\"><span>%s%s</span>%s%s%s</div></div></div>" % ["main" if J.t(c.get("main")) else "", J.str(c.id), wa_avatar(c.av, 50), J.str(c.name), "g" if J.t(c.get("unread")) else "", J.str(c.time),
			(tick(true, true) + " ") if J.t(c.get("mine")) else "", J.str(c.prev), ("<i class=\"pin\">%s</i>" % ICON.pin) if J.t(c.get("pin")) else "", ("<i class=\"mut\">%s</i>" % ICON.mute) if J.t(c.get("mute")) else "", ("<em>%s</em>" % J.str(c.unread)) if J.t(c.get("unread")) else ""]
	h += "<div class=\"wa-lockline\">%s</div></div>\n      <button class=\"wa-fab\" aria-label=\"新對話\">%s</button>\n</div>" % ["🔒 你的個人訊息已受端對端加密保護" if pre else "🔒 訊息已陰陽兩界加密，活人看不到", ICON.chat]
	J.sp(el, "innerHTML", h)
	for r in J.iter(J.mc(el, "querySelectorAll", [".wa-row"])):
		var rr = r
		J.sp(rr, "onclick", func(_t, _a):
			_snd("play", ["click"])
			var id = J.str(J.gp(J.gp(rr, "dataset"), "id"))
			for c in list: if J.str(c.id) == id: ph_open_chat(c); break
			return null)
	J.sp(J.mc(el, "querySelector", [".wa-snd"]), "onclick", func(_t, a):
		var e = J.arg(a, 0); J.mc(e, "stopPropagation", [])
		var on = J.t(_snd("toggle")); J.sp(J.gp(e, "target"), "textContent", "🔊" if on else "🔇"); return null)
	_snd("setMode", ["office" if pre else "story"])

static func ph_open_chat(c) -> void:
	if J.t(J.gp(c, "main")): J.mc(PH, "enter", []); return
	var pre = J.str(PH.get("phase")) == "pre"; var el = _q("#phone")
	var sub = J.gp(c, "sub")
	var h = "<div class=\"wa wa-chat\">%s\n      <div class=\"wa-head\"><span class=\"wa-back\">%s</span>%s<div class=\"wa-who\"><b>%s</b><small>%s</small></div><span class=\"ic\">%s</span><span class=\"ic\">%s</span><span class=\"ic\">%s</span></div>\n      <div class=\"wa-body\"><div class=\"wa-lock\">%s</div>" % [wa_status("02:13" if pre else now_hm(), "3%" if pre else "∞", pre), ICON.back, wa_avatar(c.av, 38), J.str(c.name),
		J.str(sub) if J.t(sub) else ("最後上線時間：今天" if pre else "最後上線時間：很久以前"), ICON.video, ICON.call, ICON.dots, "🔒 訊息和通話皆已端對端加密。" if pre else "🔒 訊息已陰陽兩界加密。"]
	var last_day = ""
	for m in c.msgs:
		var who = J.str(m[0]); var when = J.str(m[1]); var text = J.str(m[2])
		var parts = when.split(" "); var day = parts[0]
		if when.contains(" ") and day != last_day: h += "<div class=\"wa-day\">%s</div>" % day; last_day = day
		var tm = parts[1] if when.contains(" ") else when; var me = who == "我"
		h += "<div class=\"bub %s\">%s<span>%s</span><i>%s%s</i></div>" % ["me" if me else "them", ("<b class=\"nm\">%s</b>" % who) if J.t(sub) and not me else "", text, tm, (" " + tick(true, true)) if me else ""]
	var hold = J.gp(c, "hold")
	h += "</div><div class=\"wa-input\"><div class=\"wa-field dim\">%s<span class=\"wa-txt\">%s</span>%s</div><button class=\"wa-send\">%s</button></div></div>" % [ICON.smile, J.str(hold) if J.t(hold) else "輸入訊息", ICON.clip, ICON.mic]
	J.sp(el, "innerHTML", h)
	var body = J.mc(el, "querySelector", [".wa-body"]); J.sp(body, "scrollTop", J.gp(body, "scrollHeight"))
	J.sp(J.mc(el, "querySelector", [".wa-back"]), "onclick", func(_t, _a): _snd("play", ["click"]); J.mc(PH, "home", [PH.get("phase")]); return null)

static func ph_enter() -> void:
	var pre = J.str(PH.get("phase")) == "pre"
	J.mc(PH, "close", [])
	if pre:
		# 開場列表同原生版共用一份（data/story_v2.json "opening"，經 ui/name_card.gd 讀）
		var S0 = J.G.get("S")
		for id in load("res://ui/name_card.gd").opening(S0 if S0 is Dictionary else null): J.mc(_g("Story"), "queue", [id])
	else: J.cl(_g("offlineGain"), null, []); _snd("setMode", ["village"])

static func ph_close() -> void:
	PH["on"] = false; var el = _q("#phone"); J.sp(el, "className", ""); J.sp(el, "innerHTML", "")

# ===================== 封面（網頁版後備；Godot 版由 bridge 換成原生） =====================
static func title_show(fresh) -> void:
	var el = _q("#title"); J.sp(el, "className", "on")
	var SS = _g("SPR_SRC")
	var cover = J.str(J.gp(SS, "cover")) if J.t(J.gp(SS, "cover")) else ""
	var b_new = J.str(J.gp(SS, "btn_new")) if J.t(J.gp(SS, "btn_new")) else ""
	var b_cont = J.str(J.gp(SS, "btn_cont")) if J.t(J.gp(SS, "btn_cont")) else ""
	var has_save = not J.t(fresh)
	J.sp(el, "innerHTML", "<div class=\"tt-cover\" style=\"background-image:url(%s)\"></div>\n      <div class=\"tt-fog\"></div>\n      <div class=\"tt-btns\">\n        <button class=\"tt-btn\" id=\"tt-new\" aria-label=\"開始新遊戲\">%s</button>\n        <button class=\"tt-btn %s\" id=\"tt-cont\" aria-label=\"繼續遊戲\">%s</button>\n        <small class=\"tt-hint\" id=\"tt-hint\">%s</small>\n      </div>\n      <button class=\"tt-snd\" aria-label=\"聲音\">%s</button>" % [cover,
		("<img src=\"%s\" alt=\"\">" % b_new) if b_new != "" else "<span>開始新遊戲</span>", "" if has_save else "off", ("<img src=\"%s\" alt=\"\">" % b_cont) if b_cont != "" else "<span>繼續遊戲</span>", "" if has_save else "還沒有存檔", "🔊" if J.t(_snd("isOn")) else "🔇"])
	_snd("setMode", ["story"])
	J.sp(J.mc(el, "querySelector", [".tt-snd"]), "onclick", func(_t, a):
		var e = J.arg(a, 0); J.mc(e, "stopPropagation", []); var on = J.t(_snd("toggle")); J.sp(J.gp(e, "target"), "textContent", "🔊" if on else "🔇"); return null)
	J.sp(_q("#tt-cont"), "onclick", func(_t, _a):
		if not has_save: _snd("play", ["click"]); return null
		_snd("play", ["gong"]); title_hide(); J.mc(PH, "home", ["post"]); return null)
	J.sp(_q("#tt-new"), "onclick", func(_t, _a):
		var bn = _q("#tt-new")
		if has_save and not J.t(J.gp(J.gp(bn, "dataset"), "armed")):
			J.sp(J.gp(bn, "dataset"), "armed", 1.0); J.sp(_q("#tt-hint"), "textContent", "會刪掉現在的存檔。再點一次「開始新遊戲」確定。")
			J.F_setTimeout([func(_t2, _a2): J.del(J.gp(_q("#tt-new"), "dataset"), "armed"); J.sp(_q("#tt-hint"), "textContent", ""); return null, 3500.0])
			_snd("play", ["click"]); return null
		_snd("play", ["gong"])
		if has_save:
			J.S_localStorage_("removeItem", [_g("SAVE_KEY")])
			J.G["S"] = J.cl(_g("newState"), null, [])
			var d = J.cl(_g("newState"), null, [])
			for k in J.keys(d): J.sp(J.G["S"], k, J.gp(d, k))
			J.cl(_g("save"), null, [])
		title_hide(); J.mc(PH, "home", ["pre"]); return null)
static func title_hide() -> void:
	var el = _q("#title"); J.sp(el, "className", ""); J.sp(el, "innerHTML", "")

func run(_env) -> void:
	var d = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/phone.json"))
	ICON = d.ICON; CHATS_PRE = d.CHATS_PRE
	J.G["ICON"] = ICON
	J.G["TICK"] = func(_t, a): return tick(J.arg(a, 0), J.arg(a, 1))
	J.G["waAvatar"] = func(_t, a): return wa_avatar(J.arg(a, 0), J.num(J.arg(a, 1)))
	J.G["waStatus"] = func(_t, a): return wa_status(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2))
	J.G["nowHM"] = func(_t, _a): return now_hm()
	J.G["CHATS_PRE"] = CHATS_PRE
	J.G["chatsPost"] = func(_t, _a): return chats_post()
	PH = {"on": false, "phase": "pre",
		"el": func(_t, _a): return _q("#phone"),
		"home": func(_t, a): ph_home(J.arg(a, 0)); return null,
		"openChat": func(_t, a): ph_open_chat(J.arg(a, 0)); return null,
		"enter": func(_t, _a): ph_enter(); return null,
		"close": func(_t, _a): ph_close(); return null,
	}
	J.G["Phone"] = PH
	J.G["Title"] = {"show": func(_t, a): title_show(J.arg(a, 0)); return null, "hide": func(_t, _a): title_hide(); return null}
