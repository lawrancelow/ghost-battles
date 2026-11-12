# 自動轉譯自 phone.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["waAvatar"] = Callable(self, "_f2").bind(env)
	J.G["waStatus"] = Callable(self, "_f3").bind(env)
	J.G["nowHM"] = Callable(self, "_f5").bind(env)
	J.G["chatsPost"] = Callable(self, "_f6").bind(env)
	J.G["ICON"] = {"back": "<svg viewBox=\"0 0 24 24\"><path d=\"M15 5 8 12l7 7\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/></svg>", "video": "<svg viewBox=\"0 0 24 24\"><rect x=\"3\" y=\"7\" width=\"12\" height=\"10\" rx=\"2\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"/><path d=\"m15 11 6-3v8l-6-3\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linejoin=\"round\"/></svg>", "call": "<svg viewBox=\"0 0 24 24\"><path d=\"M6.6 3.5 9 6.8 7.4 9c1 2.5 3 4.5 5.6 5.6l2.2-1.6 3.3 2.4-1 3.1c-.3.8-1.1 1.3-2 1.1C9.3 18.6 5.4 14.7 3.4 8.5c-.2-.9.3-1.7 1.1-2z\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linejoin=\"round\"/></svg>", "dots": "<svg viewBox=\"0 0 24 24\"><circle cx=\"12\" cy=\"5\" r=\"1.8\" fill=\"currentColor\"/><circle cx=\"12\" cy=\"12\" r=\"1.8\" fill=\"currentColor\"/><circle cx=\"12\" cy=\"19\" r=\"1.8\" fill=\"currentColor\"/></svg>", "cam": "<svg viewBox=\"0 0 24 24\"><path d=\"M4 8h3l2-3h6l2 3h3v11H4z\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linejoin=\"round\"/><circle cx=\"12\" cy=\"13\" r=\"3.4\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"/></svg>", "smile": "<svg viewBox=\"0 0 24 24\"><circle cx=\"12\" cy=\"12\" r=\"9\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"/><circle cx=\"9\" cy=\"10\" r=\"1.2\" fill=\"currentColor\"/><circle cx=\"15\" cy=\"10\" r=\"1.2\" fill=\"currentColor\"/><path d=\"M8 14.5c2 2 6 2 8 0\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\"/></svg>", "clip": "<svg viewBox=\"0 0 24 24\"><path d=\"m15.5 7-7 7a2 2 0 0 0 2.8 2.8l7.5-7.5a3.6 3.6 0 0 0-5-5L6.2 11.9a5 5 0 0 0 7.1 7.1l6-6\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\"/></svg>", "mic": "<svg viewBox=\"0 0 24 24\"><rect x=\"9\" y=\"3\" width=\"6\" height=\"11\" rx=\"3\" fill=\"currentColor\"/><path d=\"M5.5 11a6.5 6.5 0 0 0 13 0M12 17.5V21\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\"/></svg>", "send": "<svg viewBox=\"0 0 24 24\"><path d=\"M4 12 20 4l-4 16-4-6.5z\" fill=\"currentColor\"/><path d=\"m12 13.5 8-9.5\" stroke=\"#0b141a\" stroke-width=\"1.4\"/></svg>", "pin": "<svg viewBox=\"0 0 24 24\"><path d=\"M9 3h6l-1 6 3 3H7l3-3zM12 12v9\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linejoin=\"round\"/></svg>", "mute": "<svg viewBox=\"0 0 24 24\"><path d=\"M4 9h4l5-4v14l-5-4H4z\" fill=\"currentColor\"/><path d=\"m16 9 5 6m0-6-5 6\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\"/></svg>", "chat": "<svg viewBox=\"0 0 24 24\"><path d=\"M4 5h16v11H9l-5 4z\" fill=\"currentColor\"/><path d=\"M8 9.5h8M8 12.5h5\" stroke=\"#00a884\" stroke-width=\"1.6\" stroke-linecap=\"round\"/></svg>"}
	J.G["TICK"] = Callable(self, "_f1").bind(env)
	J.G["pad2"] = Callable(self, "_f4").bind(env)
	J.G["CHATS_PRE"] = [{"id": "boss", "name": "黃總", "av": ["黃", "#5a6a7a"], "time": "02:13", "unread": 1.0, "prev": "阿福，明早九點董事會，PPT 要再改。", "main": true}, {"id": "q3", "name": "Q3 衝刺作戰群", "av": ["群", "#6a5a3a"], "time": "02:11", "unread": 47.0, "mute": true, "prev": "Kelvin：收到 👍", "sub": "黃總、Kelvin、Jessica、你", "msgs": [["黃總", "01:58", "誰還沒睡？"], ["Kelvin", "01:59", "我 👋"], ["黃總", "02:01", "很好。有狼性。"], ["Jessica", "02:03", "黃總，我老公在醫院，可以明天再交嗎？"], ["黃總", "02:04", "醫院有 Wi-Fi 嗎？"], ["Jessica", "02:10", "有……"], ["Kelvin", "02:11", "收到 👍"]]}, {"id": "mom", "name": "媽", "av": ["媽", "#b06a5a"], "time": "星期日", "unread": 2.0, "prev": "阿福，那下個月呢？", "msgs": [["媽", "星期三 19:02", "阿福，最近天天下大雨，出門記得帶傘。"], ["我", "星期三 23:40", "嗯"], ["媽", "星期五 20:15", "你爸說想你了。他不會說，但我知道。"], ["媽", "星期五 20:16", "這個月回來吃飯嗎？"], ["我", "星期六 01:22", "下次吧，最近很忙"], ["媽", "星期日 18:30", "媽煲了你最愛的蓮藕湯，給你留了一碗。"], ["媽", "星期日 21:04", "阿福，那下個月呢？"]], "hold": "（你打算明天再回）"}, {"id": "ins", "name": "保險經紀 阿明", "av": ["明", "#3a6a8a"], "time": "上星期", "prev": "不用了，我還年輕。", "mine": true, "msgs": [["阿明", "上星期 14:20", "陳先生您好！人生無常，有沒有興趣看看我們的人壽保險？"], ["阿明", "上星期 14:21", "特別適合常常 OT 的專業人士 😊"], ["我", "上星期 23:58", "不用了，我還年輕。"]]}, {"id": "food", "name": "外賣 Abang Ali", "av": ["A", "#8a6a2a"], "time": "21:47", "prev": "Boss, makanan saya letak depan pintu ya 🙏", "msgs": [["Abang Ali", "21:46", "Boss, dah sampai. Tekan loceng takde orang."], ["Abang Ali", "21:47", "Boss, makanan saya letak depan pintu ya 🙏"]]}, {"id": "land", "name": "房東 Mr. Lim", "av": ["林", "#5a5a5a"], "time": "昨天", "prev": "下個月開始屋租起 RM200，水電費自己 settle 哦。", "msgs": [["Mr. Lim", "昨天 10:02", "阿福，下個月開始屋租起 RM200，水電費自己 settle 哦。"], ["Mr. Lim", "昨天 10:03", "反正你整天在公司，應該沒所謂吧？"]]}, {"id": "gym", "name": "FitLife 健身中心", "av": ["F", "#2a7a5a"], "time": "昨天", "prev": "Hi 陳先生！您已經 3 年沒來了，現在 renew 打 8 折哦！", "msgs": [["FitLife", "昨天 09:00", "Hi 陳先生！您已經 3 年沒來了，現在 renew 打 8 折哦！"], ["FitLife", "昨天 09:01", "健康是最好的投資 💪"]]}, {"id": "clinic", "name": "康健診所", "av": ["診", "#4a7a8a"], "time": "3 星期前", "prev": "您的體檢報告出來了，請盡快回來見醫生。", "msgs": [["康健診所", "3 星期前", "陳先生，您的體檢報告出來了，請盡快回來見醫生。"], ["康健診所", "2 星期前", "提醒：您的報告有幾項指數不太好，請盡快回來見醫生。"]]}]
	J.G["Phone"] = {"on": false, "phase": "pre", "el": Callable(self, "_f9").bind(env), "home": Callable(self, "_f10").bind(env), "openChat": Callable(self, "_f16").bind(env), "enter": Callable(self, "_f18").bind(env), "close": Callable(self, "_f20").bind(env)}
	J.G["Title"] = {"show": Callable(self, "_f21").bind(env), "hide": Callable(self, "_f26").bind(env)}

func _f2(this_, a: Array, env):
	var v_av_15 = null; var v_size_16 = null; var v_c_17 = null
	v_av_15 = J.arg(a, 0)
	v_size_16 = J.arg(a, 1)
	if J.seq(v_av_15, "sys"):
		v_c_17 = J.mc(J.G.get("ART"), "sysIcon", [J.mul(v_size_16, 2.0)])
		return ("<span class=\"av sys\" style=\"width:" + J.str(v_size_16) + "px;height:" + J.str(v_size_16) + "px\"><img src=\"" + J.str(J.mc(v_c_17, "toDataURL", [])) + "\" alt=\"\"></span>")
	return ("<span class=\"av\" style=\"width:" + J.str(v_size_16) + "px;height:" + J.str(v_size_16) + "px;background:" + J.str(J.gp(v_av_15, 1.0)) + ";font-size:" + J.str(J.round(J.num(J.mul(v_size_16, 0.42)))) + "px\">" + J.str(J.gp(v_av_15, 0.0)) + "</span>")

func _f3(this_, a: Array, env):
	var v_time_20 = null; var v_batt_21 = null; var v_low_22 = null
	v_time_20 = J.arg(a, 0)
	v_batt_21 = J.arg(a, 1)
	v_low_22 = J.arg(a, 2)
	return ("<div class=\"wa-status\"><b>" + J.str(v_time_20) + "</b><span class=\"wa-sig\"><i></i><i></i><i></i><i></i></span><span class=\"wa-batt " + ("low" if J.t(v_low_22) else "") + "\"><em style=\"width:" + J.str((8.0 if J.t(v_low_22) else 70.0)) + "%\"></em></span><small>" + J.str(v_batt_21) + "</small></div>")

func _f5(this_, a: Array, env):
	var v_d_26 = null
	v_d_26 = J.new_("Date", [])
	var _t1 = J.G.get("pad2")
	var _t3 = J.add(J.cl(_t1, null, [J.mc(v_d_26, "getHours", [])]), ":")
	var _t2 = J.G.get("pad2")
	return J.add(_t3, J.cl(_t2, null, [J.mc(v_d_26, "getMinutes", [])]))

func _f7(this_, a: Array, env):
	var v_id_35 = null
	v_id_35 = J.arg(a, 0)
	return (not (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_35))))

func _f8(this_, a: Array, env):
	var v_m_36 = null
	v_m_36 = J.arg(a, 0)
	return J.seq(J.gp(v_m_36, 0.0), "媽")

func _f6(this_, a: Array, env):
	var v_sn_29 = null; var v_out_30 = null; var v_mm_31 = null; var v_last_32 = null; var v_bm_33 = null; var v_bl_34 = null; var v_gm_37 = null; var v_gl_38 = null
	v_sn_29 = Callable(self, "_f7").bind(env)
	v_out_30 = []
	J.mc(v_out_30, "push", [{"id": "kpi", "name": ("陰司好好系統" if J.t(J.gp(J.G.get("S"), "ended")) else "陰司 KPI 系統"), "av": "sys", "time": J.cl(J.G.get("nowHM"), null, []), "unread": 1.0, "pin": true, "main": true, "prev": ("親，今天沒有 KPI，想來就來。" if J.t(J.gp(J.G.get("S"), "ended")) else "親，鬼怪們都在等你上班哦～")}])
	v_mm_31 = [["媽", "頭七", "阿福，頭七了。媽給你燒了一個傭人，叫小紙，你別欺負人家。"]]
	if J.t(J.cl(v_sn_29, null, ["gift_phone"])):
		J.mc(v_mm_31, "push", [["媽", "清明前", "手機收到了嗎？店家說下面也能用 WhatsApp。"], ["媽", "清明前", "媽不知道你看不看得到，就當媽自言自語吧。"]])
	if J.t(J.cl(v_sn_29, null, ["ch3_end"])):
		J.mc(v_mm_31, "push", [["媽", "中元前", "媽幫你看了一塊新的地，坐北向南，前面有樹，風水第一流。"], ["媽", "中元前", "負責的人說前面是垃圾場。媽跟他講：那叫聚財。"]])
	if J.t(J.cl(v_sn_29, null, ["gift_car"])):
		J.mc(v_mm_31, "push", [["媽", "中元節", "車也燒給你了，你開慢點。生前你那麼急，現在慢慢來。"]])
	if J.t(J.cl(v_sn_29, null, ["epilogue"])):
		J.mc(v_mm_31, "push", [["媽", "清明", "媽給你燒了一張假條。這次你一定要放。"], ["我", "清明", "媽，我不忙了。"], ["媽", "清明", "……阿福？"]])
	v_last_32 = J.gp(v_mm_31, (J.len(v_mm_31) - 1.0))
	J.mc(v_out_30, "push", [{"id": "mom2", "name": "媽", "av": ["媽", "#b06a5a"], "time": J.gp(v_last_32, 1.0), "unread": (0.0 if J.t(J.cl(v_sn_29, null, ["epilogue"])) else J.len(J.mc(v_mm_31, "filter", [Callable(self, "_f8").bind(env)]))), "prev": J.add(("" if J.seq(J.gp(v_last_32, 0.0), "我") else ""), J.gp(v_last_32, 2.0)), "mine": J.seq(J.gp(v_last_32, 0.0), "我"), "msgs": v_mm_31, "hold": ("" if J.t(J.cl(v_sn_29, null, ["epilogue"])) else "（訊息傳不出去：對方在陽間）")}])
	v_bm_33 = [["黃總", "02:47", "好？句號呢？"], ["黃總", "09:12", "阿福？董事會開始了。"], ["黃總", "09:40", "阿福你人呢？"], ["黃總", "下午 3:03", "HR 說你過世了。節哀。"], ["黃總", "下午 3:04", "PPT 誰接手？密碼是什麼？"]]
	if J.t(J.cl(v_sn_29, null, ["ch6_end"])):
		J.mc(v_bm_33, "push", [["黃總", "最近", "阿福，我在村裡學包包子。"], ["黃總", "最近", "很難。我包了一百個，孟婆說九十九個不合格。"], ["黃總", "最近", "剩下那一個是我自己。"]])
	v_bl_34 = J.gp(v_bm_33, (J.len(v_bm_33) - 1.0))
	J.mc(v_out_30, "push", [{"id": "boss2", "name": "黃總", "av": ["黃", "#5a6a7a"], "time": J.gp(v_bl_34, 1.0), "unread": (3.0 if J.t(J.cl(v_sn_29, null, ["ch6_end"])) else 2.0), "prev": J.gp(v_bl_34, 2.0), "msgs": v_bm_33, "hold": "（你已離職，無法回覆此對話）"}])
	if J.t(J.cl(v_sn_29, null, ["ch2_intro"])):
		v_gm_37 = [["小紙", "早上", "今天的壽包誰偷吃了？少了三個。"], ["餓鬼王", "早上", "不是我，我的喉嚨只能一次吞一粒米。"]]
		if J.t(J.cl(v_sn_29, null, ["ch2_end"])):
			J.mc(v_gm_37, "push", [["Toyol", "早上", "也不是我！我只偷錢，不偷吃的！"], ["小紙", "早上", "……你剛剛承認了什麼？"]])
		if J.t(J.cl(v_sn_29, null, ["ch3_end"])):
			J.mc(v_gm_37, "push", [["老殭", "中午", "本官昨夜跳去人間，看見有人在跳廣場舞。"], ["老殭", "中午", "他們跳得比本官還僵硬。"]])
		if J.t(J.cl(v_sn_29, null, ["ch4_end"])):
			J.mc(v_gm_37, "push", [["Pontianak", "晚上", "誰把我的香蕉拿去做香蕉煎餅了？"], ["餓鬼王", "晚上", "……好吃。"]])
		if J.t(J.cl(v_sn_29, null, ["ch5_end"])):
			J.mc(v_gm_37, "push", [["Penanggal", "半夜", "提醒大家：倉庫那缸醋是我的，不是調味料。誰再拿去沾餃子，我就飛過去。"], ["Pocong", "半夜", "（舉手）"]])
		if J.t(J.cl(v_sn_29, null, ["ch6_mengpo"])):
			J.mc(v_gm_37, "push", [["孟婆", "半夜", "今晚湯底換了，喝了不會忘事，只會忘記熱量。"]])
		v_gl_38 = J.gp(v_gm_37, (J.len(v_gm_37) - 1.0))
		J.mc(v_out_30, "push", [{"id": "vg", "name": "落魄村村民群", "av": ["群", "#3f6a5a"], "time": J.gp(v_gl_38, 1.0), "unread": J.len(v_gm_37), "mute": true, "prev": J.add(J.add(J.gp(v_gl_38, 0.0), "："), J.gp(v_gl_38, 2.0)), "sub": "小紙、餓鬼王、你…", "msgs": v_gm_37}])
	if J.t(J.cl(v_sn_29, null, ["ch6_end"])):
		J.mc(v_out_30, "push", [{"id": "opt", "name": "落魄村優化小組", "av": ["優", "#7a4a3a"], "time": "00:00", "unread": 2.0, "mute": true, "prev": "黃總：不要給我藉口。", "sub": "黃總、你…", "msgs": [["黃總", "23:58", "明天早上，大家提早半個小時出來。"], ["黃總", "23:59", "KPI：每隻鬼每天嚇三個人。"], ["小紙", "00:00", "黃總，我們是鬼，早上不能出來的。"], ["黃總", "00:00", "不要給我藉口。"]], "hold": "（已讀。你決定不回。）"}])
	J.mc(v_out_30, "push", [{"id": "ins2", "name": "保險經紀 阿明", "av": ["明", "#3a6a8a"], "time": "上個月", "unread": 2.0, "prev": "那份人壽保險……現在買還來得及嗎？", "msgs": [["我", "很久以前", "不用了，我還年輕。"], ["阿明", "上個月", "陳先生，聽說您走了，節哀。"], ["阿明", "上個月", "那份人壽保險……現在買還來得及嗎？"]]}])
	J.mc(v_out_30, "push", [{"id": "land2", "name": "房東 Mr. Lim", "av": ["林", "#5a5a5a"], "time": "上個月", "unread": 2.0, "prev": "Deposit 不還了。", "msgs": [["Mr. Lim", "上個月", "阿福，你在屋裡走的，現在變凶宅，租不出了 lah。"], ["Mr. Lim", "上個月", "Deposit 不還了。"], ["Mr. Lim", "上星期", "還有，這個月的屋租你還沒給。"]]}])
	J.mc(v_out_30, "push", [{"id": "gym2", "name": "FitLife 健身中心", "av": ["F", "#2a7a5a"], "time": "今天", "unread": 2.0, "prev": "違約金 RM1,200，可以分期哦 🙏", "msgs": [["FitLife", "昨天", "陳先生，系統顯示您已 3 年 2 個月未到店。"], ["FitLife", "昨天", "請問您還活著嗎？若否，請回覆 0 取消會籍。"], ["FitLife", "今天", "收到您家人的通知，節哀。提早取消會籍的違約金 RM1,200，可以分期哦 🙏"]]}])
	J.mc(v_out_30, "push", [{"id": "food2", "name": "外賣 Abang Ali", "av": ["A", "#8a6a2a"], "time": "上個月", "prev": "Boss, makanan masih depan pintu… dah berkulat 😅", "msgs": [["Abang Ali", "21:47", "Boss, makanan saya letak depan pintu ya 🙏"], ["Abang Ali", "三天後", "Boss, makanan masih depan pintu… dah berkulat 😅"], ["Abang Ali", "三天後", "Tapi tolong bagi 5 bintang ya boss 🙏"]]}])
	J.mc(v_out_30, "push", [{"id": "tel", "name": "地府電訊", "av": ["冥", "#6a3a3a"], "time": "每月一號", "prev": "您的「永生無限」月租計劃已自動續約。", "msgs": [["地府電訊", "每月一號", "您的「永生無限」月租計劃已自動續約：每月 100 億冥幣，請家屬按時焚燒。"], ["地府電訊", "每月一號", "溫馨提示：陽間來電一律轉接至語音信箱。"]]}])
	J.mc(v_out_30, "push", [{"id": "clinic2", "name": "康健診所", "av": ["診", "#4a7a8a"], "time": "上個月", "prev": "建議您多休息。", "msgs": [["康健診所", "3 星期前", "陳先生，您的體檢報告出來了，請盡快回來見醫生。"], ["康健診所", "上個月", "因為您一直沒回來複診，報告已經寄到府上：建議您多休息。"]]}])
	return v_out_30

func _f1(this_, a: Array, env):
	var v_blue_11 = null; var v_two_12 = null
	v_blue_11 = J.arg(a, 0)
	v_two_12 = J.arg(a, 1)
	return ("<span class=\"tk" + (" blue" if J.t(v_blue_11) else "") + "\">" + ("✓✓" if J.t(v_two_12) else "✓") + "</span>")

func _f4(this_, a: Array, env):
	var v_n_23 = null
	v_n_23 = J.arg(a, 0)
	return J.add(("0" if J.cmp(v_n_23, 10.0, "<") else ""), v_n_23)

func _f9(this_, a: Array, env):
	var _t4 = J.G.get("$")
	return J.cl(_t4, null, ["#phone"])

func _f11(this_, a: Array, env):
	var v_c_49 = null
	v_c_49 = J.arg(a, 0)
	return J.gp(v_c_49, "unread")

func _f14(this_, a: Array, env):
	var v_c_52 = null
	v_c_52 = J.arg(a, 0)
	return J.seq(J.gp(v_c_52, "id"), J.gp(J.gp(env["r"], "dataset"), "id"))

func _f13(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	J.mc(env["__p"]["this"], "openChat", [J.mc(env["__p"]["list"], "find", [Callable(self, "_f14").bind(env)])])

func _f12(this_, a: Array, env):
	var _s17 = {"__p": env, "r": null}
	_s17["r"] = J.arg(a, 0)
	var _t21 = _s17["r"]
	var _t22 = Callable(self, "_f13").bind(_s17)
	J.sp(_t21, "onclick", _t22)
	return _t22

func _f15(this_, a: Array, env):
	var v_e_53 = null; var v_on_54 = null
	v_e_53 = J.arg(a, 0)
	J.mc(v_e_53, "stopPropagation", [])
	v_on_54 = J.mc(J.G.get("Sound"), "toggle", [])
	var _t24 = J.gp(v_e_53, "target")
	var _t25 = ("🔊" if J.t(v_on_54) else "🔇")
	J.sp(_t24, "textContent", _t25)

func _f10(this_, a: Array, env):
	var v_phase_43 = null; var v_el_44 = null; var v_pre_45 = null; var v_time_47 = null; var v_h_48 = null; var v_c_50 = null
	var _s13 = {"__p": env, "this": null, "list": null}
	_s13["this"] = this_
	v_phase_43 = J.arg(a, 0)
	var _t5 = _s13["this"]
	J.sp(_t5, "on", true)
	var _t6 = _s13["this"]
	J.sp(_t6, "phase", v_phase_43)
	v_el_44 = J.mc(_s13["this"], "el", [])
	J.sp(v_el_44, "className", "on")
	v_pre_45 = J.seq(v_phase_43, "pre")
	_s13["list"] = (J.G.get("CHATS_PRE") if J.t(v_pre_45) else J.cl(J.G.get("chatsPost"), null, []))
	v_time_47 = ("02:13" if J.t(v_pre_45) else J.cl(J.G.get("nowHM"), null, []))
	var _t7 = J.G.get("waStatus")
	v_h_48 = ("<div class=\"wa\">" + J.str(J.cl(_t7, null, [v_time_47, ("3%" if J.t(v_pre_45) else "∞"), v_pre_45])) + "\n      <div class=\"wa-top\"><b>WhatsApp</b>" + ("" if J.t(v_pre_45) else "<i class=\"hell\">陰間版</i>") + "<button class=\"wa-snd\" aria-label=\"聲音\">" + ("🔊" if J.t(J.mc(J.G.get("Sound"), "isOn", [])) else "🔇") + "</button><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "cam")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "dots")) + "</span></div>\n      <div class=\"wa-search\">在 WhatsApp 中搜尋…</div>\n      <div class=\"wa-chips\"><span class=\"on\">全部</span><span>未讀 " + J.str(J.len(J.mc(_s13["list"], "filter", [Callable(self, "_f11").bind(_s13)]))) + "</span><span>群組</span></div>\n      <div class=\"wa-list\">")
	for _t8 in J.iter(_s13["list"]):
		v_c_50 = _t8
		var _t10 = ("main" if J.t(J.gp(v_c_50, "main")) else "")
		var _t11 = J.gp(v_c_50, "id")
		var _t9 = J.G.get("waAvatar")
		var _t14 = J.cl(_t9, null, [J.gp(v_c_50, "av"), 50.0])
		var _t15 = J.gp(v_c_50, "name")
		var _t16 = ("g" if J.t(J.gp(v_c_50, "unread")) else "")
		var _t17 = J.gp(v_c_50, "time")
		var _t13 = null
		if J.t(J.gp(v_c_50, "mine")):
			var _t12 = J.G.get("TICK")
			_t13 = J.add(J.cl(_t12, null, [true, true]), " ")
		else:
			_t13 = ""
		var _t18 = J.add(v_h_48, ("<div class=\"wa-row " + _t10 + "\" data-id=\"" + J.str(_t11) + "\">" + J.str(_t14) + "\n        <div class=\"wr-mid\"><div class=\"wr-l1\"><b>" + J.str(_t15) + "</b><small class=\"" + _t16 + "\">" + J.str(_t17) + "</small></div>\n        <div class=\"wr-l2\"><span>" + _t13 + J.str(J.gp(v_c_50, "prev")) + "</span>" + (("<i class=\"pin\">" + J.str(J.gp(J.G.get("ICON"), "pin")) + "</i>") if J.t(J.gp(v_c_50, "pin")) else "") + (("<i class=\"mut\">" + J.str(J.gp(J.G.get("ICON"), "mute")) + "</i>") if J.t(J.gp(v_c_50, "mute")) else "") + (("<em>" + J.str(J.gp(v_c_50, "unread")) + "</em>") if J.t(J.gp(v_c_50, "unread")) else "") + "</div></div></div>"))
		v_h_48 = _t18
	var _t19 = J.add(v_h_48, ("<div class=\"wa-lockline\">" + ("🔒 你的個人訊息已受端對端加密保護" if J.t(v_pre_45) else "🔒 訊息已陰陽兩界加密，活人看不到") + "</div></div>\n      <button class=\"wa-fab\" aria-label=\"新對話\">" + J.str(J.gp(J.G.get("ICON"), "chat")) + "</button>\n</div>"))
	v_h_48 = _t19
	J.sp(v_el_44, "innerHTML", v_h_48)
	var _t20 = J.mc(v_el_44, "querySelectorAll", [".wa-row"])
	J.mc(_t20, "forEach", [Callable(self, "_f12").bind(_s13)])
	var _t23 = J.mc(v_el_44, "querySelector", [".wa-snd"])
	var _t26 = Callable(self, "_f15").bind(_s13)
	J.sp(_t23, "onclick", _t26)
	J.mc(J.G.get("Sound"), "setMode", [("office" if J.t(v_pre_45) else "story")])

func _f17(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	J.mc(env["this"], "home", [J.gp(env["this"], "phase")])

func _f16(this_, a: Array, env):
	var v_c_57 = null; var v_pre_58 = null; var v_el_59 = null; var v_h_60 = null; var v_lastDay_61 = null; var v_body_62 = null; var v_who_63 = null; var v_when_64 = null; var v_text_65 = null; var v_day_66 = null; var v_tm_67 = null; var v_me_68 = null
	var _s21 = {"__p": env, "this": null}
	_s21["this"] = this_
	v_c_57 = J.arg(a, 0)
	if J.t(J.gp(v_c_57, "main")):
		J.mc(_s21["this"], "enter", [])
		return null
	v_pre_58 = J.seq(J.gp(_s21["this"], "phase"), "pre")
	v_el_59 = J.mc(_s21["this"], "el", [])
	var _t27 = J.G.get("waStatus")
	var _t29 = J.cl(_t27, null, [("02:13" if J.t(v_pre_58) else J.cl(J.G.get("nowHM"), null, [])), ("3%" if J.t(v_pre_58) else "∞"), v_pre_58])
	var _t30 = J.gp(J.G.get("ICON"), "back")
	var _t28 = J.G.get("waAvatar")
	var _t32 = J.cl(_t28, null, [J.gp(v_c_57, "av"), 38.0])
	var _t33 = J.gp(v_c_57, "name")
	var _t31 = J.gp(v_c_57, "sub")
	v_h_60 = ("<div class=\"wa wa-chat\">" + J.str(_t29) + "\n      <div class=\"wa-head\"><span class=\"wa-back\">" + J.str(_t30) + "</span>" + J.str(_t32) + "<div class=\"wa-who\"><b>" + J.str(_t33) + "</b><small>" + J.str((_t31 if J.t(_t31) else ("最後上線時間：今天" if J.t(v_pre_58) else "最後上線時間：很久以前"))) + "</small></div><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "video")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "call")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "dots")) + "</span></div>\n      <div class=\"wa-body\"><div class=\"wa-lock\">" + ("🔒 訊息和通話皆已端對端加密。" if J.t(v_pre_58) else "🔒 訊息已陰陽兩界加密。") + "</div>")
	v_lastDay_61 = ""
	for _t34 in J.iter(J.gp(v_c_57, "msgs")):
		var _t35 = J.gp(_t34, 0.0)
		v_who_63 = _t35
		var _t36 = J.gp(_t34, 1.0)
		v_when_64 = _t36
		var _t37 = J.gp(_t34, 2.0)
		v_text_65 = _t37
		v_day_66 = J.gp(J.mc(v_when_64, "split", [" "]), 0.0)
		var _t38 = J.mc(v_when_64, "includes", [" "])
		if J.t(((not J.seq(v_day_66, v_lastDay_61)) if J.t(_t38) else _t38)):
			var _t39 = J.add(v_h_60, ("<div class=\"wa-day\">" + J.str(v_day_66) + "</div>"))
			v_h_60 = _t39
			v_lastDay_61 = v_day_66
		v_tm_67 = (J.gp(J.mc(v_when_64, "split", [" "]), 1.0) if J.t(J.mc(v_when_64, "includes", [" "])) else v_when_64)
		v_me_68 = J.seq(v_who_63, "我")
		var _t41 = ("me" if J.t(v_me_68) else "them")
		var _t40 = J.gp(v_c_57, "sub")
		var _t44 = (("<b class=\"nm\">" + J.str(v_who_63) + "</b>") if J.t(((not J.t(v_me_68)) if J.t(_t40) else _t40)) else "")
		var _t43 = null
		if J.t(v_me_68):
			var _t42 = J.G.get("TICK")
			_t43 = J.add(" ", J.cl(_t42, null, [true, true]))
		else:
			_t43 = ""
		var _t45 = J.add(v_h_60, ("<div class=\"bub " + _t41 + "\">" + _t44 + "<span>" + J.str(v_text_65) + "</span><i>" + J.str(v_tm_67) + _t43 + "</i></div>"))
		v_h_60 = _t45
	var _t47 = J.gp(J.G.get("ICON"), "smile")
	var _t46 = J.gp(v_c_57, "hold")
	var _t48 = J.add(v_h_60, ("</div><div class=\"wa-input\"><div class=\"wa-field dim\">" + J.str(_t47) + "<span class=\"wa-txt\">" + J.str((_t46 if J.t(_t46) else "輸入訊息")) + "</span>" + J.str(J.gp(J.G.get("ICON"), "clip")) + "</div><button class=\"wa-send\">" + J.str(J.gp(J.G.get("ICON"), "mic")) + "</button></div></div>"))
	v_h_60 = _t48
	J.sp(v_el_59, "innerHTML", v_h_60)
	v_body_62 = J.mc(v_el_59, "querySelector", [".wa-body"])
	var _t49 = J.gp(v_body_62, "scrollHeight")
	J.sp(v_body_62, "scrollTop", _t49)
	var _t50 = J.mc(v_el_59, "querySelector", [".wa-back"])
	var _t51 = Callable(self, "_f17").bind(_s21)
	J.sp(_t50, "onclick", _t51)

func _f19(this_, a: Array, env):
	var v_id_72 = null
	v_id_72 = J.arg(a, 0)
	return J.mc(J.G.get("Story"), "queue", [v_id_72])

func _f18(this_, a: Array, env):
	var v_pre_71 = null
	v_pre_71 = J.seq(J.gp(this_, "phase"), "pre")
	J.mc(this_, "close", [])
	if J.t(v_pre_71):
		var _t52 = ["prologue_chat", "prologue_narr", "prologue_road", "prologue_sys"]
		J.mc(_t52, "forEach", [Callable(self, "_f19").bind(env)])
	else:
		J.cl(J.G.get("offlineGain"), null, [])
		J.mc(J.G.get("Sound"), "setMode", ["village"])

func _f20(this_, a: Array, env):
	var _t53 = this_
	J.sp(_t53, "on", false)
	var _t54 = J.mc(this_, "el", [])
	J.sp(_t54, "className", "")
	var _t55 = J.mc(this_, "el", [])
	J.sp(_t55, "innerHTML", "")

func _f22(this_, a: Array, env):
	var v_e_83 = null; var v_on_84 = null
	v_e_83 = J.arg(a, 0)
	J.mc(v_e_83, "stopPropagation", [])
	v_on_84 = J.mc(J.G.get("Sound"), "toggle", [])
	var _t62 = J.gp(v_e_83, "target")
	var _t63 = ("🔊" if J.t(v_on_84) else "🔇")
	J.sp(_t62, "textContent", _t63)

func _f23(this_, a: Array, env):
	if (not J.t(env["hasSave"])):
		J.mc(J.G.get("Sound"), "play", ["click"])
		return null
	J.mc(J.G.get("Sound"), "play", ["gong"])
	J.mc(env["this"], "hide", [])
	J.mc(J.G.get("Phone"), "home", ["post"])

func _f25(this_, a: Array, env):
	var _t76 = J.G.get("$")
	J.del(J.gp(J.cl(_t76, null, ["#tt-new"]), "dataset"), "armed")
	var _t77 = J.G.get("$")
	var _t78 = J.cl(_t77, null, ["#tt-hint"])
	J.sp(_t78, "textContent", "")

func _f24(this_, a: Array, env):
	var v_e_85 = null; var v_d_86 = null; var v_er_87 = null; var v_k_88 = null
	v_e_85 = J.arg(a, 0)
	var _t71 = env["hasSave"]
	if J.t(_t71):
		var _t70 = J.G.get("$")
		_t71 = (not J.t(J.gp(J.gp(J.cl(_t70, null, ["#tt-new"]), "dataset"), "armed")))
	if J.t(_t71):
		var _t72 = J.G.get("$")
		var _t73 = J.gp(J.cl(_t72, null, ["#tt-new"]), "dataset")
		J.sp(_t73, "armed", 1.0)
		var _t74 = J.G.get("$")
		var _t75 = J.cl(_t74, null, ["#tt-hint"])
		J.sp(_t75, "textContent", "會刪掉現在的存檔。再點一次「開始新遊戲」確定。")
		J.F_setTimeout([Callable(self, "_f25").bind(env), 3500.0])
		J.mc(J.G.get("Sound"), "play", ["click"])
		return null
	J.mc(J.G.get("Sound"), "play", ["gong"])
	if J.t(env["hasSave"]):
		J.S_localStorage_("removeItem", [J.G.get("SAVE_KEY")])
		var _t79 = J.cl(J.G.get("newState"), null, [])
		J.G["S"] = _t79
		v_d_86 = J.cl(J.G.get("newState"), null, [])
		for _t80 in J.keys(v_d_86):
			v_k_88 = _t80
			var _t81 = J.G.get("S")
			var _t82 = J.gp(v_d_86, v_k_88)
			J.sp(_t81, v_k_88, _t82)
		J.cl(J.G.get("save"), null, [])
	J.mc(env["this"], "hide", [])
	J.mc(J.G.get("Phone"), "home", ["pre"])

func _f21(this_, a: Array, env):
	var v_fresh_77 = null; var v_el_78 = null; var v_cover_79 = null; var v_bNew_80 = null; var v_bCont_81 = null
	var _s32 = {"__p": env, "this": null, "hasSave": null}
	_s32["this"] = this_
	v_fresh_77 = J.arg(a, 0)
	var _t56 = J.G.get("$")
	v_el_78 = J.cl(_t56, null, ["#title"])
	J.sp(v_el_78, "className", "on")
	var _t57 = J.gp(J.G.get("SPR_SRC"), "cover")
	v_cover_79 = (_t57 if J.t(_t57) else "")
	var _t58 = J.gp(J.G.get("SPR_SRC"), "btn_new")
	v_bNew_80 = (_t58 if J.t(_t58) else "")
	var _t59 = J.gp(J.G.get("SPR_SRC"), "btn_cont")
	v_bCont_81 = (_t59 if J.t(_t59) else "")
	_s32["hasSave"] = (not J.t(v_fresh_77))
	var _t60 = ("<div class=\"tt-cover\" style=\"background-image:url(" + J.str(v_cover_79) + ")\"></div>\n      <div class=\"tt-fog\"></div>\n      <div class=\"tt-btns\">\n        <button class=\"tt-btn\" id=\"tt-new\" aria-label=\"開始新遊戲\">" + (("<img src=\"" + J.str(v_bNew_80) + "\" alt=\"\">") if J.t(v_bNew_80) else "<span>開始新遊戲</span>") + "</button>\n        <button class=\"tt-btn " + ("" if J.t(_s32["hasSave"]) else "off") + "\" id=\"tt-cont\" aria-label=\"繼續遊戲\">" + (("<img src=\"" + J.str(v_bCont_81) + "\" alt=\"\">") if J.t(v_bCont_81) else "<span>繼續遊戲</span>") + "</button>\n        <small class=\"tt-hint\" id=\"tt-hint\">" + ("" if J.t(_s32["hasSave"]) else "還沒有存檔") + "</small>\n      </div>\n      <button class=\"tt-snd\" aria-label=\"聲音\">" + ("🔊" if J.t(J.mc(J.G.get("Sound"), "isOn", [])) else "🔇") + "</button>")
	J.sp(v_el_78, "innerHTML", _t60)
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	var _t61 = J.mc(v_el_78, "querySelector", [".tt-snd"])
	var _t64 = Callable(self, "_f22").bind(_s32)
	J.sp(_t61, "onclick", _t64)
	var _t65 = J.G.get("$")
	var _t66 = J.cl(_t65, null, ["#tt-cont"])
	var _t67 = Callable(self, "_f23").bind(_s32)
	J.sp(_t66, "onclick", _t67)
	var _t68 = J.G.get("$")
	var _t69 = J.cl(_t68, null, ["#tt-new"])
	var _t83 = Callable(self, "_f24").bind(_s32)
	J.sp(_t69, "onclick", _t83)

func _f26(this_, a: Array, env):
	var v_el_91 = null
	var _t84 = J.G.get("$")
	v_el_91 = J.cl(_t84, null, ["#title"])
	J.sp(v_el_91, "className", "")
	J.sp(v_el_91, "innerHTML", "")
