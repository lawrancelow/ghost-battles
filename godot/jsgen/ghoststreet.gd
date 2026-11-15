# 自動轉譯自 ghoststreet.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["gsDay"] = Callable(self, "_f1").bind(env)
	J.G["gsRnd"] = Callable(self, "_f2").bind(env)
	J.G["GS_STALLS"] = {"paper": {"name": "紙紮鋪", "x": 0.13, "sx": 0.15, "face": 1.0, "x0": 0.015, "x1": 0.255, "keeper": "xiaozhi", "kx": 0.232, "ky": 0.745}, "haggle": {"name": "講價攤", "x": 0.37, "sx": 0.385, "face": (-1.0), "x0": 0.275, "x1": 0.47, "keeper": "xiaogui", "kx": 0.3, "ky": 0.742}, "exch": {"name": "冥幣兌換", "x": 0.58, "sx": 0.605, "face": (-1.0), "x0": 0.49, "x1": 0.665, "keeper": "baiwu", "kx": 0.525, "ky": 0.738}, "food": {"name": "宵夜檔", "x": 0.78, "sx": 0.78, "face": 1.0, "x0": 0.675, "x1": 0.875, "keeper": "eguiking", "kx": 0.805, "ky": 0.745}, "alley": {"name": "暗巷", "x": 0.945, "sx": 0.93, "face": 1.0, "x0": 0.885, "x1": 1.0}}
	J.G["GS_ORDER"] = ["paper", "haggle", "exch", "food", "alley"]
	J.G["GS_EFFIGY"] = {"phone": {"name": "紙紮手機", "price": 400.0, "eff": "回陽間夜班：開局陰氣 +25", "say": "最新款，五個鏡頭——全部拍不到你。訊號直通陽間，夜班開工前先充好陰氣。"}, "car": {"name": "紙紮跑車", "price": 600.0, "eff": "村子裡走路速度 +15%", "say": "油門是畫上去的，開不動。不過背著它跑步，不知道為什麼就是快了。"}, "coffee": {"name": "紙紮咖啡機", "price": 700.0, "eff": "砍樹、割稻、做板、包包子快 10%", "say": "一杯下去，死人也能加班。副作用：凌晨三點會想回覆電郵。"}, "chair": {"name": "紙紮按摩椅", "price": 900.0, "eff": "出征時我方血量 +5%", "say": "按完腰不痛了。雖然你本來就沒有腰，但是心理上舒服。"}}
	J.G["GS_ITEMS"] = [{"id": "soup", "name": "二手孟婆湯（只喝了一半）", "col": 120.0, "desc": "前主人喝到一半想起前任，不喝了。保證只忘一半。"}, {"id": "gramo", "name": "只會播《夜上海》的留聲機", "col": 200.0, "desc": "斷了一根弦，所以《夜上海》聽起來像《夜加班》。"}, {"id": "clock", "name": "永遠慢五分鐘的掛鐘", "col": 90.0, "desc": "從舊公司牆上拆下來的。專門讓員工以為還沒到下班時間。"}, {"id": "cage", "name": "空鳥籠", "col": 70.0, "desc": "鳥已經投胎了，籠子還在等牠回來辦交接。"}, {"id": "vase", "name": "青花瓷花瓶", "col": 160.0, "desc": "底部印著「陰間製造」。品質有保障，保到下輩子。"}, {"id": "chest", "name": "打不開的寶箱", "col": 240.0, "desc": "鑰匙在陽間某個抽屜裡。搖起來有聲音，可能是金子，可能是遙控器電池。"}, {"id": "promise", "name": "黃總親筆加薪承諾書", "col": 60.0, "desc": "白紙黑字：「明年一定加。」日期是四十年前。"}, {"id": "punch", "name": "會自己打卡的打卡機", "col": 150.0, "desc": "半夜三點自己「咔嚓」一聲，嚇跑了三任保安。"}, {"id": "malt", "name": "過期三十年的麥芽沖劑", "col": 50.0, "desc": "結成一塊磚。敲下來可以當武器，也可以當早餐。"}, {"id": "bell", "name": "牛頭大哥的退休牛鈴", "col": 110.0, "desc": "一搖，整條街的鬼都以為收工了。"}, {"id": "nails", "name": "Pontianak 美甲店清倉假指甲", "col": 80.0, "desc": "長度可以自己剪，顏色只有一種：血紅。"}, {"id": "bigbro", "name": "紙紮大哥大", "col": 130.0, "desc": "上世紀燒下來的，訊號只有一格，但是永遠打得通老闆。"}]
	J.G["GS_BANDS"] = [{"max": 0.6, "mood": "翻臉", "col": "#e2483a", "lv": 0.0, "pose": "strike", "lines": ["你當我這裡是陽間的二手群組？出這種價！", "這個價，連一炷香都買不到！再這樣我叫牛頭來收你！", "侮辱我？我做這行三百年，沒見過這麼厚的臉皮！"]}, {"max": 0.8, "mood": "很臭", "col": "#d07a3a", "lv": 1.0, "pose": "idle", "lines": ["哼，差得遠。我進貨都不止這個價。", "你在跟我講價，還是在講笑話？", "加！多加一點！我也要交租的好嗎！"]}, {"max": 0.93, "mood": "猶豫", "col": "#d8b84a", "lv": 2.0, "pose": "windup", "lines": ["嗯……開始像話了。再加一點。", "看你黑眼圈這麼重，再加一點我就考慮。", "這個價嘛……我老婆知道會罵我的。再一點。"]}, {"max": 1.0, "mood": "肉痛", "col": "#9ad05a", "lv": 3.0, "pose": "hurt", "lines": ["哎喲，肉痛……就差一口氣了！", "再加一點點，就當交個朋友。", "我的手在發抖了……再一點點就好！"]}]
	J.G["GS_DEAL_TIGHT"] = ["……成交。你這隻鬼精，下次別來了。", "好啦好啦，算我今晚倒楣。拿去！", "你這種客人，我做三百年只見過兩個。成交。"]
	J.G["GS_DEAL_FAT"] = ["成交！！（小鬼笑到假牙都掉了出來）", "爽快！你是我今晚最喜歡的客人！", "成交成交！慢走，下次再來啊～（他在偷笑）"]
	J.G["GS_MEALS"] = {"mala": {"name": "加班麻辣燙", "price": 30.0, "eff": "下一場出征：攻擊 +15%", "say": "辣到你忘記自己已經死了。湯底熬了九百年，比你的工齡還長。"}, "bkt": {"name": "通宵肉骨茶", "price": 30.0, "eff": "下一場出征：血量 +15%", "say": "藥材是陽間孝子燒下來的，喝完可以再撐一個通宵。"}, "teh": {"name": "忘憂拉茶（少甜）", "price": 30.0, "eff": "下一場出征：技能符開局 +40", "say": "孟婆監製。拉得越高，忘得越多——先忘記老闆的電話號碼。"}}
	J.G["GS_NEWS_UP"] = ["地府科技宣布：「來世訂閱制」下個月上線，首月免費。", "閻羅殿採購地府科技全套考勤系統，打卡從此不用手。", "地府科技新品「免排隊投胎」預購爆滿，伺服器排隊九百年。", "牛頭馬面代言地府科技，粉絲排隊排了三條街。", "地府科技財報：陽間清明節燒來的訂單創新高。"]
	J.G["GS_NEWS_DN"] = ["地府科技 CEO 被拍到回陽間兼職送外賣。", "地府科技伺服器當機，全陰間打不了卡，老闆們很不爽。", "地府科技被揭發用紙紮人當員工，紙紮人工會要求加薪。", "地府科技財報：盈利是燒來的，燒完就沒了。", "用戶投訴：用了地府科技的投胎 App，投胎後才發現是試用版。"]
	J.G["GS_FEE"] = 0.03
	J.G["GS_SHARE_CAP"] = 100.0
	J.G["GS_CHATTER"] = ["冥幣又通脹了，一碗粥要三億。", "我死了還在等那份 KPI 審批。", "房東說棺材位下個月起加租兩成。", "投胎排隊要等九百年，先打份工吧。", "老闆說加班費可以用功德抵。", "我生前過勞死，死後被派去整理過勞死的檔案。", "燒來的跑車被開罰單了——沒有紙紮車牌。", "年終獎金？上次發的是一張紙紮的「謝謝你」。", "女兒燒了一部手機給我，忘記燒充電器。", "孟婆湯漲價了，現在忘一個前任要加錢。", "開會開到雞叫，會議記錄：下次再議。", "我當了三百年實習生，還沒轉正。", "老闆說我們是一家人——所以不用發薪水。", "冥股又跌了，我的退休金只夠買一根香。", "陽間有四天工作週，我們連週末都沒有，只有週七。", "我兼職送宵夜，評分四點九，扣分是因為我太冷。", "打卡機壞了，全部當曠工——死了還要被扣錢。", "我陽間的同事，還在用我的帳號登入系統。", "黃總說今年不加薪，每人送一張勵志海報。", "冥幣面額太大，找零要推一輛手推車。", "七月出差回陽間，酒店全滿，只好睡停車場。", "我的 MC 被退回：「你已經死了，不算生病。」", "下班了還在群組回「收到」，這是職業病，也是死因。", "隔壁的榴槤是陽間空運的，貴到我的心又死了一次。", "投訴信寄去閻羅殿，自動回覆：「請排隊三百年。」", "這條街的租金，貴到連鬼都住不起。", "聽說今年的 OT 費用「心意」計算。", "我死後終於有時間睡覺，結果被排了夜班。", "Mamak 檔的師傅說，拉茶要拉到陽間那麼長才夠味。"]
	J.G["GS_WANDER"] = ["youhun", "egui", "zombie", "shuigui", "pocong"]
	J.G["GS_PROPS"] = {"youhun": {"kind": "lanternW"}, "egui": {"kind": "lanternR"}, "shuigui": {"kind": "bag"}, "zombie": {"kind": "phone", "lines": ["喂？喂？", "聽到嗎？", "我跳緊過嚟"]}}
	J.G["GS_WORKFACE"] = {"paper": (-1.0), "haggle": 1.0, "exch": 1.0, "food": (-1.0)}
	J.G["GS_POT"] = [0.752, 0.588]
	J.G["GS_SORRY"] = ["不好意思", "對不起對不起", "借過借過", "撞到你，抱歉"]
	J.G["GS_KEEPER_HI"] = {"paper": ["小紙：歡迎光臨！燒什麼都可以，就是不能燒加班單。", "小紙：今天新到的貨，摺到我手指都快斷了——紙做的手指。"], "haggle": ["小鬼：看什麼看？要買就出價，不買別擋著。", "小鬼：我這裡不二價。……好啦，可以講。"], "exch": ["白無常：一見生財！今天要換冥幣，還是換人生？", "白無常：一見生財～小道消息免費，虧錢自負。"], "food": ["餓鬼王：坐！吃！吃飽才有力氣被老闆罵！", "餓鬼王：一人一碗，不准偷吃隔壁的！（他在偷吃隔壁的）"], "alley": ["（巷子裡的霧好像在看你。）"]}
	J.G["GS_ALLEY"] = [{"id": "mlm", "text": "一隻穿西裝的鬼塞給你一張傳單：「地府直銷，三個月月入一億冥幣！講座只收 60。」", "a": {"label": "聽講座", "cost": 60.0, "out": "講了三個鐘，重點是：請你也去拉三個人來聽講座。你學到了寶貴的一課。", "give": {"exp": 50.0}}, "b": {"label": "說「我在趕投胎」", "out": "他在你背後喊：「你會後悔的！」你沒有。", "give": {"exp": 10.0}}}, {"id": "lost", "text": "一隻剛來報到的新鬼抱著公文袋發抖：「請問……投胎報到處怎麼走？今天是我第一天。」", "a": {"label": "親自帶他去", "out": "他一路跟你講他的簡報。報到處說他表格填錯了要重排——至少他少走了冤枉路。", "give": {"exp": 70.0}}, "b": {"label": "收 20 冥幣畫地圖", "out": "地圖畫得很漂亮。你良心痛了一下，也只痛了一下。", "give": {"coins": 20.0}}}, {"id": "cash", "text": "地上有一疊整整齊齊的冥幣，旁邊有張字條：「誰撿誰加班」。", "a": {"label": "撿起來", "out": "冥幣到手。遠處有人喊：「好，明天早上七點開會。」……應該是巧合。", "give": {"coins": 90.0}}, "b": {"label": "交給巡夜的黑無常", "out": "黑無常說：「難得。」塞給你一個綠箱，然後把冥幣收進自己口袋。", "give": {"chest": "g"}}}, {"id": "cry", "text": "一隻加班鬼蹲在牆角哭：「簡報存檔失敗了，明早就要交……」", "a": {"label": "幫他重做一份", "out": "你們做到雞叫。老闆看了一眼說：「換回第一版吧。」至少他不哭了，改成笑。", "give": {"exp": 80.0}}, "b": {"label": "遞一包紙巾", "out": "他擤了鼻涕，說謝謝，繼續哭。有時候陪著就夠了。", "give": {"exp": 15.0}}}, {"id": "fortune", "text": "巷口擺著一個算命攤：「鐵口直斷，一次 50 冥幣。」", "a": {"label": "算一下", "cost": 50.0, "out": "「你下輩子……還是打工仔。」不過他說你今晚有偏財，送你一個藍箱。", "give": {"chest": "b"}}, "b": {"label": "不信這一套", "out": "他在你背後點點頭：「這個也算準了。」", "give": {"exp": 10.0}}}, {"id": "troops", "text": "一個戴墨鏡的鬼掀開大衣：「水貨陰兵，80 冥幣三十個，不問來歷。」", "a": {"label": "買一批", "cost": 80.0, "out": "三十個陰兵排好隊跟你回家。其中一個問：「有勞工保險嗎？」", "give": {"troops": 30.0}}, "b": {"label": "向巡夜的牛頭舉報", "out": "牛頭把他帶走了。他臨走前說：「兄弟，我也只是打工的。」", "give": {"exp": 40.0}}}, {"id": "mahjong", "text": "巷尾的麻將桌三缺一：「來啦，打一圈就好！」", "a": {"label": "坐下打一圈", "cost": 40.0, "out": "你被三家清一色，輸了 40 冥幣。散場時他們拍拍你：「你人很好，下次還找你。」", "give": {"exp": 30.0}}, "b": {"label": "「我老婆在等我」", "out": "三隻鬼齊聲說：「怕老婆好，怕老婆會發達。」", "give": {"exp": 5.0}}}, {"id": "wifi", "text": "霧裡有個小攤在賣「陽間 WiFi 密碼」，一張 30 冥幣。", "a": {"label": "買一張", "cost": 30.0, "out": "密碼是 12345678。你連上了，看到舊同事在群組問：「阿福走了，他的工作誰接？」……沒人回。", "give": {"exp": 40.0}}, "b": {"label": "算了", "out": "你決定今晚不看群組。這是你死後最健康的決定。", "give": {"exp": 20.0}}}]
	J.G["GS_LANTERNS"] = [[0.029, 0.322], [0.286, 0.352], [0.496, 0.332], [0.557, 0.355], [0.72, 0.36], [0.872, 0.352], [0.97, 0.322], [0.018, 0.468], [0.228, 0.468], [0.475, 0.46], [0.684, 0.488], [0.866, 0.51], [0.92, 0.44], [0.955, 0.44]]
	J.G["__gsDC"] = Callable(self, "_f3").bind(env)
	J.G["GhostStreet"] = {"active": false, "st": Callable(self, "_f4").bind(env), "mul": Callable(self, "_f5").bind(env), "bonus": Callable(self, "_f6").bind(env), "battleBuffs": Callable(self, "_f7").bind(env), "open": Callable(self, "_f14").bind(env), "close": Callable(self, "_f26").bind(env), "resize": Callable(self, "_f27").bind(env), "targetVH": Callable(self, "_f29").bind(env), "geo": Callable(self, "_f30").bind(env), "X": Callable(self, "_f31").bind(env), "Y": Callable(self, "_f32").bind(env), "depth": Callable(self, "_f33").bind(env), "charScale": Callable(self, "_f34").bind(env), "toWorld": Callable(self, "_f35").bind(env), "down": Callable(self, "_f36").bind(env), "move": Callable(self, "_f37").bind(env), "up": Callable(self, "_f38").bind(env), "walkTo": Callable(self, "_f39").bind(env), "goStall": Callable(self, "_f40").bind(env), "arrive": Callable(self, "_f41").bind(env), "frame": Callable(self, "_f43").bind(env), "step": Callable(self, "_f46").bind(env), "mkJoss": Callable(self, "_f52").bind(env), "avoid": Callable(self, "_f53").bind(env), "chat": Callable(self, "_f54").bind(env), "say": Callable(self, "_f55").bind(env), "float": Callable(self, "_f56").bind(env), "draw": Callable(self, "_f58").bind(env), "glow": Callable(self, "_f65").bind(env), "drawFog": Callable(self, "_f66").bind(env), "drawParts": Callable(self, "_f68").bind(env), "drawLanternString": Callable(self, "_f69").bind(env), "drawSigns": Callable(self, "_f70").bind(env), "nearStall": Callable(self, "_f71").bind(env), "drawAfu": Callable(self, "_f72").bind(env), "drawKeeper": Callable(self, "_f73").bind(env), "drawWalker": Callable(self, "_f74").bind(env), "bubble": Callable(self, "_f75").bind(env), "renderPanel": Callable(self, "_f78").bind(env), "relax": Callable(self, "_f83").bind(env), "keeperPose": Callable(self, "_f84").bind(env), "coinsOk": Callable(self, "_f85").bind(env), "spend": Callable(self, "_f86").bind(env), "html_paper": Callable(self, "_f87").bind(env), "bind_paper": Callable(self, "_f89").bind(env), "burn": Callable(self, "_f92").bind(env), "todayItems": Callable(self, "_f93").bind(env), "floorOf": Callable(self, "_f97").bind(env), "askOf": Callable(self, "_f98").bind(env), "html_haggle": Callable(self, "_f99").bind(env), "bind_haggle": Callable(self, "_f103").bind(env), "offer": Callable(self, "_f113").bind(env), "price": Callable(self, "_f116").bind(env), "html_exch": Callable(self, "_f117").bind(env), "bind_exch": Callable(self, "_f118").bind(env), "trade": Callable(self, "_f121").bind(env), "drawChart": Callable(self, "_f122").bind(env), "html_food": Callable(self, "_f129").bind(env), "bind_food": Callable(self, "_f131").bind(env), "html_alley": Callable(self, "_f134").bind(env), "bind_alley": Callable(self, "_f137").bind(env)}

func _f1(this_, a: Array, env):
	var v_d_28 = null
	v_d_28 = J.new_("Date", [])
	return floor(J.num(J.div(J.sub(J.mc(v_d_28, "getTime", []), J.mul(J.mc(v_d_28, "getTimezoneOffset", []), 60000.0)), 86400000.0)))

func _f2(this_, a: Array, env):
	var v_n_31 = null
	v_n_31 = J.arg(a, 0)
	var _t1 = J.bxor(J.bor(v_n_31, 0.0), 1540483477.0)
	v_n_31 = _t1
	var _t2 = J.math("imul", [J.bxor(v_n_31, J.ushr(v_n_31, 15.0)), 739982445.0])
	v_n_31 = _t2
	var _t3 = J.math("imul", [J.bxor(v_n_31, J.ushr(v_n_31, 12.0)), 695872825.0])
	v_n_31 = _t3
	var _t4 = J.bxor(v_n_31, J.ushr(v_n_31, 15.0))
	v_n_31 = _t4
	return J.div(J.ushr(v_n_31, 0.0), 4294967296.0)

func _f3(this_, a: Array, env):
	var v_c_32 = null; var v_k_33 = null; var v_x_34 = null; var v_y_35 = null; var v_s_36 = null; var v_o_37 = null
	v_c_32 = J.arg(a, 0)
	v_k_33 = J.arg(a, 1)
	v_x_34 = J.arg(a, 2)
	v_y_35 = J.arg(a, 3)
	v_s_36 = J.arg(a, 4)
	v_o_37 = J.arg(a, 5)
	var _t5 = J.gp(J.G.get("GhostStreet"), "_nat")
	var _t6 = ((not J.t((J.gp(v_o_37, "act") if J.t(v_o_37) else v_o_37))) if J.t(_t5) else _t5)
	var _t9 = null
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_drawChar")), "undefined")) if J.t(_t6) else _t6)):
		var _t7 = J.G.get("__nat_drawChar")
		_t9 = J.cl(_t7, null, [v_c_32, v_k_33, v_x_34, v_y_35, v_s_36, (v_o_37 if J.t(v_o_37) else {})])
	else:
		var _t8 = J.G.get("ART")
		_t9 = J.mc(_t8, "drawChar", [v_c_32, v_k_33, v_x_34, v_y_35, v_s_36, v_o_37])
	return _t9

func _f4(this_, a: Array, env):
	var v_s_40 = null
	if (not J.t(J.G.get("S"))):
		return {"fx": {}}
	var _t10 = J.G.get("S")
	var _t11 = J.gp(J.G.get("S"), "street")
	var _t12 = (_t11 if J.t(_t11) else {})
	J.sp(_t10, "street", _t12)
	v_s_40 = _t12
	var _t13 = J.gp(v_s_40, "fx")
	var _t14 = (_t13 if J.t(_t13) else {})
	J.sp(v_s_40, "fx", _t14)
	var _t15 = J.gp(v_s_40, "meal")
	var _t16 = (_t15 if J.t(_t15) else null)
	J.sp(v_s_40, "meal", _t16)
	var _t17 = J.gp(v_s_40, "visits")
	var _t18 = (_t17 if J.t(_t17) else 0.0)
	J.sp(v_s_40, "visits", _t18)
	var _t19 = J.gp(v_s_40, "seen")
	var _t20 = (_t19 if J.t(_t19) else {})
	J.sp(v_s_40, "seen", _t20)
	var _t21 = J.gp(v_s_40, "stock")
	var _t22 = (_t21 if J.t(_t21) else {"n": 0.0, "cost": 0.0})
	J.sp(v_s_40, "stock", _t22)
	var _t23 = J.gp(v_s_40, "curios")
	var _t24 = (_t23 if J.t(_t23) else [])
	J.sp(v_s_40, "curios", _t24)
	var _t25 = (not J.t(J.gp(v_s_40, "hag")))
	if (_t25 if _t25 else (not J.seq(J.gp(J.gp(v_s_40, "hag"), "day"), J.cl(J.G.get("gsDay"), null, [])))):
		var _t26 = {"day": J.cl(J.G.get("gsDay"), null, []), "done": {}, "tries": {}, "strikes": 0.0, "out": false}
		J.sp(v_s_40, "hag", _t26)
	return v_s_40

func _f5(this_, a: Array, env):
	var v_kind_43 = null; var v_fx_44 = null
	v_kind_43 = J.arg(a, 0)
	var _t27 = (J.gp(J.G.get("S"), "street") if J.t(J.G.get("S")) else J.G.get("S"))
	var _t28 = (J.gp(J.gp(J.G.get("S"), "street"), "fx") if J.t(_t27) else _t27)
	v_fx_44 = (_t28 if J.t(_t28) else {})
	if J.seq(v_kind_43, "walk"):
		return (1.15 if J.t(J.gp(v_fx_44, "car")) else 1.0)
	if J.seq(v_kind_43, "work"):
		return (1.1 if J.t(J.gp(v_fx_44, "coffee")) else 1.0)
	if J.seq(v_kind_43, "hp"):
		return (1.05 if J.t(J.gp(v_fx_44, "chair")) else 1.0)
	return 1.0

func _f6(this_, a: Array, env):
	var v_kind_47 = null; var v_fx_48 = null
	v_kind_47 = J.arg(a, 0)
	var _t29 = (J.gp(J.G.get("S"), "street") if J.t(J.G.get("S")) else J.G.get("S"))
	var _t30 = (J.gp(J.gp(J.G.get("S"), "street"), "fx") if J.t(_t29) else _t29)
	v_fx_48 = (_t30 if J.t(_t30) else {})
	if J.seq(v_kind_47, "mana"):
		return (25.0 if J.t(J.gp(v_fx_48, "phone")) else 0.0)
	return 0.0

func _f8(this_, a: Array, env):
	var v_u_55 = null
	v_u_55 = J.arg(a, 0)
	return J.seq(J.gp(v_u_55, "side"), 0.0)

func _f9(this_, a: Array, env):
	var v_u_56 = null
	v_u_56 = J.arg(a, 0)
	var _t32 = J.mul(J.gp(v_u_56, "maxhp"), env["hpm"])
	J.sp(v_u_56, "maxhp", _t32)
	var _t33 = J.mul(J.gp(v_u_56, "hp"), env["hpm"])
	J.sp(v_u_56, "hp", _t33)

func _f10(this_, a: Array, env):
	var v_u_57 = null
	v_u_57 = J.arg(a, 0)
	var _t36 = J.mul(J.gp(v_u_57, "atk"), 1.15)
	J.sp(v_u_57, "atk", _t36)
	return _t36

func _f11(this_, a: Array, env):
	var v_u_58 = null
	v_u_58 = J.arg(a, 0)
	var _t37 = J.mul(J.gp(v_u_58, "maxhp"), 1.15)
	J.sp(v_u_58, "maxhp", _t37)
	var _t38 = J.mul(J.gp(v_u_58, "hp"), 1.15)
	J.sp(v_u_58, "hp", _t38)

func _f12(this_, a: Array, env):
	var v_u_59 = null
	v_u_59 = J.arg(a, 0)
	return (not J.t(J.gp(v_u_59, "minion")))

func _f13(this_, a: Array, env):
	var v_u_60 = null
	v_u_60 = J.arg(a, 0)
	var _t40 = J.gp(v_u_60, "energy")
	var _t41 = J.gp(v_u_60, "energy")
	var _t42 = J.min_([100.0, J.add((_t41 if J.t(_t41) else 0.0), 40.0)])
	J.sp(v_u_60, "energy", _t42)
	return _t42

func _f7(this_, a: Array, env):
	var v_units_51 = null; var v_own_52 = null; var v_m_54 = null; var v_e_61 = null
	var _s8 = {"__p": env, "hpm": null}
	v_units_51 = J.arg(a, 0)
	var _t31 = (not J.t(J.G.get("S")))
	if (_t31 if _t31 else (not J.t(v_units_51))):
		return ""
	v_own_52 = J.mc(v_units_51, "filter", [Callable(self, "_f8").bind(_s8)])
	_s8["hpm"] = J.mc(this_, "mul", ["hp"])
	if (not J.seq(_s8["hpm"], 1.0)):
		J.mc(v_own_52, "forEach", [Callable(self, "_f9").bind(_s8)])
	var _t34 = J.gp(J.G.get("S"), "street")
	v_m_54 = (J.gp(J.gp(J.G.get("S"), "street"), "meal") if J.t(_t34) else _t34)
	var _t35 = (not J.t(v_m_54))
	if (_t35 if _t35 else (not J.t(J.gp(J.G.get("GS_MEALS"), v_m_54)))):
		return ""
	if J.seq(v_m_54, "mala"):
		J.mc(v_own_52, "forEach", [Callable(self, "_f10").bind(_s8)])
	if J.seq(v_m_54, "bkt"):
		J.mc(v_own_52, "forEach", [Callable(self, "_f11").bind(_s8)])
	if J.seq(v_m_54, "teh"):
		var _t39 = J.mc(v_own_52, "filter", [Callable(self, "_f12").bind(_s8)])
		J.mc(_t39, "forEach", [Callable(self, "_f13").bind(_s8)])
	var _t43 = J.gp(J.G.get("S"), "street")
	J.sp(_t43, "meal", null)
	J.cl(J.G.get("save"), null, [])
	var _t45 = J.gp(J.gp(J.G.get("GS_MEALS"), v_m_54), "name")
	var _t44 = J.gp(J.gp(J.G.get("GS_MEALS"), v_m_54), "eff")
	J.mc(J.G.get("Fx"), "toast", [("宵夜生效：<b>" + J.str(_t45) + "</b>（" + J.str(J.mc(_t44, "replace", ["下一場出征：", ""])) + "）")])
	return J.gp(J.gp(J.G.get("GS_MEALS"), v_m_54), "name")

func _f15(this_, a: Array, env):
	var v_k_70 = null; var v_i_71 = null
	v_k_70 = J.arg(a, 0)
	v_i_71 = J.arg(a, 1)
	return {"k": v_k_70, "x": ((0.1 + J.mul(v_i_71, 0.19)) + (randf() * 0.05)), "y": (0.79 + (randf() * 0.13)), "tx": 0.0, "ty": 0.0, "wait": (1.0 + (randf() * 4.0)), "dir": (1.0 if (randf() < 0.5) else (-1.0)), "ph": (randf() * 6.0), "bub": null, "bubT": 0.0, "chatT": ((2.0 + J.mul(v_i_71, 2.6)) + (randf() * 2.0))}

func _f16(this_, a: Array, env):
	var v_w_72 = null
	v_w_72 = J.arg(a, 0)
	var _t56 = J.gp(v_w_72, "x")
	J.sp(v_w_72, "tx", _t56)
	var _t57 = J.gp(v_w_72, "y")
	J.sp(v_w_72, "ty", _t57)
	var _t58 = (J.S_Object_("assign", [{"seed": randf()}, J.gp(J.G.get("GS_PROPS"), J.gp(v_w_72, "k"))]) if J.t(J.gp(J.G.get("GS_PROPS"), J.gp(v_w_72, "k"))) else null)
	J.sp(v_w_72, "prop", _t58)
	J.sp(v_w_72, "look", 0.0)
	J.sp(v_w_72, "bump", 0.0)

func _f17(this_, a: Array, env):
	var v___73 = null; var v_i_74 = null
	v___73 = J.arg(a, 0)
	v_i_74 = J.arg(a, 1)
	return {"x": randf(), "y": (0.66 + (randf() * 0.3)), "r": (0.12 + (randf() * 0.12)), "v": ((0.004 + (randf() * 0.008)) * (1.0 if J.t(J.mod(v_i_74, 2.0)) else (-1.0))), "a": (0.05 + (randf() * 0.06))}

func _f18(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	J.mc(env["this"], "close", [])

func _f19(this_, a: Array, env):
	var v_e_76 = null
	v_e_76 = J.arg(a, 0)
	return J.mc(env["this"], "down", [v_e_76])

func _f20(this_, a: Array, env):
	var v_e_77 = null
	v_e_77 = J.arg(a, 0)
	return J.mc(env["this"], "move", [v_e_77])

func _f21(this_, a: Array, env):
	var v_e_78 = null
	v_e_78 = J.arg(a, 0)
	return J.mc(env["this"], "up", [v_e_78])

func _f22(this_, a: Array, env):
	var _t72 = env["this"]
	J.sp(_t72, "drag", null)

func _f23(this_, a: Array, env):
	if J.t(J.gp(env["this"], "active")):
		J.mc(env["this"], "resize", [])

func _f24(this_, a: Array, env):
	var v_n_79 = null
	v_n_79 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_79])

func _f25(this_, a: Array, env):
	return J.mc(env["this"], "say", [J.gp(J.gp(env["this"], "walkers"), 0.0), "新來的？這裡是下班後的陰間，慢慢逛。", 4.0])

func _f14(this_, a: Array, env):
	var v_s_64 = null; var v_used_65 = null; var v_el_66 = null; var v_cv_67 = null; var v_k_68 = null; var v_d_69 = null; var v_i_75 = null
	var _s18 = {"__p": env, "this": null}
	_s18["this"] = this_
	v_s_64 = J.mc(_s18["this"], "st", [])
	J.sp(v_s_64, "visits", J.num(J.gp(v_s_64, "visits")) + 1.0)
	J.S_Object_("assign", [_s18["this"], {"active": true, "t": 0.0, "view": {"k": "idle"}, "parts": [], "floats": [], "ate": false, "alleyDone": null, "alleyEv": null, "vh": 0.0, "cam": 0.0, "pend": null, "drag": null, "kick": 0.0}])
	var _t46 = _s18["this"]
	var _t47 = {"x": 0.06, "y": 0.84, "tx": 0.06, "ty": 0.84, "dir": 1.0, "walking": false, "dustT": 0.0, "pose": null, "poseT": 0.0}
	J.sp(_t46, "afu", _t47)
	var _t48 = _s18["this"]
	var _t49 = {}
	J.sp(_t48, "keepers", _t49)
	for _t50 in J.keys(J.G.get("GS_STALLS")):
		v_k_68 = _t50
		v_d_69 = J.gp(J.G.get("GS_STALLS"), v_k_68)
		if J.t(J.gp(v_d_69, "keeper")):
			var _t51 = J.gp(_s18["this"], "keepers")
			var _t52 = {"k": J.gp(v_d_69, "keeper"), "x": J.gp(v_d_69, "kx"), "y": J.gp(v_d_69, "ky"), "pose": null, "pt": 0.0, "poseT": 0.0, "bub": null, "bubT": 0.0, "ph": (randf() * 6.0)}
			J.sp(_t51, v_k_68, _t52)
	v_used_65 = J.new_("Set", [])
	var _t53 = _s18["this"]
	var _t54 = J.mc(J.G.get("GS_WANDER"), "map", [Callable(self, "_f15").bind(_s18)])
	J.sp(_t53, "walkers", _t54)
	var _t55 = J.gp(_s18["this"], "walkers")
	J.mc(_t55, "forEach", [Callable(self, "_f16").bind(_s18)])
	var _t59 = _s18["this"]
	var _t60 = (10.0 + (randf() * 8.0))
	J.sp(_t59, "bumpCD", _t60)
	var _t61 = _s18["this"]
	J.sp(_t61, "chatUsed", v_used_65)
	var _t62 = _s18["this"]
	var _t63 = J.S_Array_("from", [{"length": 9.0}, Callable(self, "_f17").bind(_s18)])
	J.sp(_t62, "fog", _t63)
	v_i_75 = 0.0
	while true:
		if not J.cmp(v_i_75, 14.0, "<"): break
		var _t64 = J.gp(_s18["this"], "parts")
		J.mc(_t64, "push", [J.mc(_s18["this"], "mkJoss", [true])])
		v_i_75 = J.num(v_i_75) + 1.0
	var _t65 = J.G.get("$")
	v_el_66 = J.cl(_t65, null, ["#gstreet"])
	var _t66 = J.gp(v_el_66, "classList")
	J.mc(_t66, "add", ["on"])
	var _t67 = ("<div id=\"gs-top\"><button class=\"btn sm\" id=\"gs-back\">回村</button><b>冥街夜市</b><span id=\"gs-coins\"><svg><use href=\"#i-coins\"/></svg><i></i></span></div>\n      <div id=\"gs-stage\"><canvas id=\"gs-cvs\"></canvas></div><div id=\"gs-panel\"></div>")
	J.sp(v_el_66, "innerHTML", _t67)
	var _t68 = J.G.get("$")
	var _t69 = J.cl(_t68, null, ["#gs-back"])
	var _t70 = Callable(self, "_f18").bind(_s18)
	J.sp(_t69, "onclick", _t70)
	var _t71 = J.G.get("$")
	v_cv_67 = J.cl(_t71, null, ["#gs-cvs"])
	J.mc(v_cv_67, "addEventListener", ["pointerdown", Callable(self, "_f19").bind(_s18)])
	J.mc(v_cv_67, "addEventListener", ["pointermove", Callable(self, "_f20").bind(_s18)])
	J.mc(v_cv_67, "addEventListener", ["pointerup", Callable(self, "_f21").bind(_s18)])
	J.mc(v_cv_67, "addEventListener", ["pointercancel", Callable(self, "_f22").bind(_s18)])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	J.mc(_s18["this"], "resize", [])
	if (not J.t(J.gp(_s18["this"], "_rs"))):
		var _t73 = _s18["this"]
		J.sp(_t73, "_rs", true)
		J.S_window_("addEventListener", ["resize", Callable(self, "_f23").bind(_s18)])
	J.mc(_s18["this"], "renderPanel", [])
	var _t74 = _s18["this"]
	var _t75 = J.mc(_s18["this"], "targetVH", [])
	J.sp(_t74, "vh", _t75)
	var _t76 = _s18["this"]
	var _t78 = (not J.seq(J.typeof_(J.G.get("__nat_mini")), "undefined"))
	if J.t(_t78):
		var _t77 = J.G.get("__nat_mini")
		_t78 = J.cl(_t77, null, [_s18["this"], "#gs-stage", "#gstreet", "draw", "#gs-cvs"])
	J.sp(_t76, "_nat", _t78)
	var _t79 = _s18["this"]
	var _t80 = J.S_performance_("now", [])
	J.sp(_t79, "last", _t80)
	J.F_requestAnimationFrame([Callable(self, "_f24").bind(_s18)])
	if (not J.t(J.gp(J.gp(v_s_64, "seen"), "street"))):
		var _t81 = J.gp(v_s_64, "seen")
		J.sp(_t81, "street", 1.0)
		J.F_setTimeout([Callable(self, "_f25").bind(_s18), 700.0])
	J.cl(J.G.get("save"), null, [])

func _f26(this_, a: Array, env):
	if (not J.t(J.gp(this_, "active"))):
		return null
	var _t82 = this_
	J.sp(_t82, "active", false)
	var _t83 = J.gp(this_, "_nat")
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_miniEnd")), "undefined")) if J.t(_t83) else _t83)):
		var _t84 = J.G.get("__nat_miniEnd")
		J.cl(_t84, null, ["#gstreet"])
		var _t85 = this_
		J.sp(_t85, "_nat", false)
	var _t86 = J.G.get("$")
	var _t87 = J.gp(J.cl(_t86, null, ["#gstreet"]), "classList")
	J.mc(_t87, "remove", ["on"])
	var _t88 = J.G.get("$")
	var _t89 = J.cl(_t88, null, ["#gstreet"])
	J.sp(_t89, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f28(this_, a: Array, env):
	var v_z_88 = null
	var _t93 = J.G.get("__nat_miniSize")
	v_z_88 = J.cl(_t93, null, ["#gstreet"])
	return {"width": J.gp(v_z_88, 0.0), "height": J.gp(v_z_88, 1.0)}

func _f27(this_, a: Array, env):
	var v_c_84 = null; var v_box_85 = null; var v_r_86 = null; var v_dpr_87 = null
	var _t90 = J.G.get("$")
	v_c_84 = J.cl(_t90, null, ["#gs-cvs"])
	var _t91 = J.G.get("$")
	v_box_85 = J.cl(_t91, null, ["#gs-stage"])
	var _t92 = (not J.t(v_c_84))
	if (_t92 if _t92 else (not J.t(v_box_85))):
		return null
	v_r_86 = (J.cl(Callable(self, "_f28").bind(env), null, []) if J.t(J.gp(this_, "_nat")) else J.mc(v_box_85, "getBoundingClientRect", []))
	var _t94 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t95 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_87 = J.min_([2.0, (_t95 if J.t(_t95) else 1.0)])
	var _t96 = J.mul(J.gp(v_r_86, "width"), v_dpr_87)
	J.sp(v_c_84, "width", _t96)
	var _t97 = J.mul(J.gp(v_r_86, "height"), v_dpr_87)
	J.sp(v_c_84, "height", _t97)
	var _t98 = J.gp(v_c_84, "style")
	var _t99 = J.add(J.gp(v_r_86, "width"), "px")
	J.sp(_t98, "width", _t99)
	var _t100 = J.gp(v_c_84, "style")
	var _t101 = J.add(J.gp(v_r_86, "height"), "px")
	J.sp(_t100, "height", _t101)
	var _t102 = this_
	var _t103 = J.gp(v_r_86, "width")
	J.sp(_t102, "W", _t103)
	var _t104 = this_
	var _t105 = J.gp(v_r_86, "height")
	J.sp(_t104, "H", _t105)
	var _t106 = this_
	J.sp(_t106, "dpr", v_dpr_87)

func _f29(this_, a: Array, env):
	var v_p_91 = null
	var _t107 = J.G.get("$")
	v_p_91 = J.cl(_t107, null, ["#gs-panel"])
	var _t108 = J.gp(this_, "H")
	var _t109 = J.gp(this_, "H")
	return J.max_([260.0, (J.sub((_t109 if J.t(_t109) else 700.0), (J.gp(v_p_91, "offsetHeight") if J.t(v_p_91) else 0.0)) + 6.0)])

func _f30(this_, a: Array, env):
	var v_img_94 = null; var v_iw_95 = null; var v_ih_96 = null; var v_IH_97 = null; var v_IW_98 = null
	v_img_94 = J.gp(J.G.get("SPR"), "bg_street")
	var _t110 = (J.gp(v_img_94, "naturalWidth") if J.t(v_img_94) else v_img_94)
	v_iw_95 = (_t110 if J.t(_t110) else 1536.0)
	var _t111 = (J.gp(v_img_94, "naturalHeight") if J.t(v_img_94) else v_img_94)
	v_ih_96 = (_t111 if J.t(_t111) else 1024.0)
	var _t112 = J.gp(this_, "vh")
	v_IH_97 = (_t112 if J.t(_t112) else 500.0)
	v_IW_98 = J.div(J.mul(v_IH_97, v_iw_95), v_ih_96)
	if J.cmp(v_IW_98, J.mul(J.gp(this_, "W"), 1.15), "<"):
		var _t113 = J.mul(J.gp(this_, "W"), 1.15)
		v_IW_98 = _t113
		var _t114 = J.div(J.mul(v_IW_98, v_ih_96), v_iw_95)
		v_IH_97 = _t114
	return {"IW": v_IW_98, "IH": v_IH_97}

func _f31(this_, a: Array, env):
	var v_fx_101 = null; var v_g_102 = null
	v_fx_101 = J.arg(a, 0)
	v_g_102 = J.mc(this_, "geo", [])
	return J.mul(J.sub(v_fx_101, J.gp(this_, "cam")), J.gp(v_g_102, "IW"))

func _f32(this_, a: Array, env):
	var v_fy_105 = null
	v_fy_105 = J.arg(a, 0)
	return J.mul(v_fy_105, J.gp(J.mc(this_, "geo", []), "IH"))

func _f33(this_, a: Array, env):
	var v_fy_108 = null
	v_fy_108 = J.arg(a, 0)
	return (0.84 + (0.36 * J.max_([0.0, J.min_([1.0, J.div(J.sub(v_fy_108, 0.72), 0.23)])])))

func _f34(this_, a: Array, env):
	var v_fy_111 = null
	v_fy_111 = J.arg(a, 0)
	return J.mul(J.div(J.mul(J.gp(J.mc(this_, "geo", []), "IH"), 0.25), 58.0), J.mc(this_, "depth", [v_fy_111]))

func _f35(this_, a: Array, env):
	var v_e_114 = null; var v_r_115 = null; var v_g_116 = null
	v_e_114 = J.arg(a, 0)
	var _t115 = J.G.get("$")
	v_r_115 = J.mc(J.cl(_t115, null, ["#gs-cvs"]), "getBoundingClientRect", [])
	v_g_116 = J.mc(this_, "geo", [])
	return {"fx": J.add(J.div(J.sub(J.gp(v_e_114, "clientX"), J.gp(v_r_115, "left")), J.gp(v_g_116, "IW")), J.gp(this_, "cam")), "fy": J.div(J.sub(J.gp(v_e_114, "clientY"), J.gp(v_r_115, "top")), J.gp(v_g_116, "IH")), "sx": J.sub(J.gp(v_e_114, "clientX"), J.gp(v_r_115, "left")), "sy": J.sub(J.gp(v_e_114, "clientY"), J.gp(v_r_115, "top"))}

func _f36(this_, a: Array, env):
	var v_e_119 = null; var v_p_120 = null; var v_er_121 = null
	v_e_119 = J.arg(a, 0)
	if J.cmp(J.gp(this_, "kick"), 0.0, ">"):
		return null
	v_p_120 = J.mc(this_, "toWorld", [v_e_119])
	var _t116 = this_
	var _t117 = {"x0": J.gp(v_p_120, "sx"), "y0": J.gp(v_p_120, "sy"), "moved": false, "p": v_p_120}
	J.sp(_t116, "drag", _t117)
	var _t118 = J.gp(v_e_119, "target")
	J.mc(_t118, "setPointerCapture", [J.gp(v_e_119, "pointerId")])

func _f37(this_, a: Array, env):
	var v_e_124 = null; var v_p_125 = null
	v_e_124 = J.arg(a, 0)
	var _t119 = (not J.t(J.gp(this_, "drag")))
	if (_t119 if _t119 else J.cmp(J.gp(this_, "kick"), 0.0, ">")):
		return null
	v_p_125 = J.mc(this_, "toWorld", [v_e_124])
	var _t120 = (not J.t(J.gp(J.gp(this_, "drag"), "moved")))
	if ((J.hypot_([J.sub(J.gp(v_p_125, "sx"), J.gp(J.gp(this_, "drag"), "x0")), J.sub(J.gp(v_p_125, "sy"), J.gp(J.gp(this_, "drag"), "y0"))]) > 10.0) if _t120 else _t120):
		var _t121 = J.gp(this_, "drag")
		J.sp(_t121, "moved", true)
	if J.t(J.gp(J.gp(this_, "drag"), "moved")):
		var _t122 = this_
		J.sp(_t122, "pend", null)
		J.mc(this_, "walkTo", [J.gp(v_p_125, "fx"), J.gp(v_p_125, "fy")])

func _f38(this_, a: Array, env):
	var v_e_128 = null; var v_d_129 = null; var v_p_130 = null; var v_w_131 = null; var v_sc_132 = null; var v_h_133 = null; var v_k_134 = null; var v_s_135 = null
	v_e_128 = J.arg(a, 0)
	v_d_129 = J.gp(this_, "drag")
	var _t123 = this_
	J.sp(_t123, "drag", null)
	var _t124 = (not J.t(v_d_129))
	var _t125 = (_t124 if _t124 else J.gp(v_d_129, "moved"))
	if J.t((_t125 if J.t(_t125) else J.cmp(J.gp(this_, "kick"), 0.0, ">"))):
		return null
	v_p_130 = J.gp(v_d_129, "p")
	for _t126 in J.iter(J.gp(this_, "walkers")):
		v_w_131 = _t126
		v_sc_132 = J.mc(this_, "charScale", [J.gp(v_w_131, "y")])
		v_h_133 = J.mul(58.0, v_sc_132)
		var _t127 = (J.mul(absf(J.num(J.sub(J.gp(v_p_130, "fx"), J.gp(v_w_131, "x")))), J.gp(J.mc(this_, "geo", []), "IW")) < J.mul(22.0, v_sc_132))
		var _t128 = (J.cmp(J.mul(J.gp(v_p_130, "fy"), J.gp(J.mc(this_, "geo", []), "IH")), J.add(J.mc(this_, "Y", [J.gp(v_w_131, "y")]), 6.0), "<") if _t127 else _t127)
		if ((J.mul(J.gp(v_p_130, "fy"), J.gp(J.mc(this_, "geo", []), "IH")) > J.sub(J.mc(this_, "Y", [J.gp(v_w_131, "y")]), v_h_133)) if _t128 else _t128):
			J.mc(this_, "chat", [v_w_131, true])
			J.mc(J.G.get("Sound"), "play", ["click"])
			return null
	if J.cmp(J.gp(v_p_130, "fy"), 0.74, "<"):
		for _t129 in J.iter(J.G.get("GS_ORDER")):
			v_k_134 = _t129
			v_s_135 = J.gp(J.G.get("GS_STALLS"), v_k_134)
			var _t130 = J.cmp(J.gp(v_p_130, "fx"), J.gp(v_s_135, "x0"), ">=")
			if (J.cmp(J.gp(v_p_130, "fx"), J.gp(v_s_135, "x1"), "<=") if _t130 else _t130):
				J.mc(this_, "goStall", [v_k_134])
				return null
	var _t131 = this_
	J.sp(_t131, "pend", null)
	J.mc(this_, "walkTo", [J.gp(v_p_130, "fx"), J.gp(v_p_130, "fy")])

func _f39(this_, a: Array, env):
	var v_fx_138 = null; var v_fy_139 = null; var v_A_140 = null
	v_fx_138 = J.arg(a, 0)
	v_fy_139 = J.arg(a, 1)
	v_A_140 = J.gp(this_, "afu")
	var _t132 = J.max_([0.03, J.min_([0.97, v_fx_138])])
	J.sp(v_A_140, "tx", _t132)
	var _t133 = J.max_([0.78, J.min_([0.93, v_fy_139])])
	J.sp(v_A_140, "ty", _t133)

func _f40(this_, a: Array, env):
	var v_k_143 = null; var v_s_144 = null
	v_k_143 = J.arg(a, 0)
	v_s_144 = J.gp(J.G.get("GS_STALLS"), v_k_143)
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t134 = this_
	J.sp(_t134, "pend", v_k_143)
	J.mc(this_, "walkTo", [J.gp(v_s_144, "sx"), 0.8])
	var _t135 = (not J.seq(J.gp(J.gp(this_, "view"), "k"), "idle"))
	if ((not J.seq(J.gp(J.gp(this_, "view"), "k"), v_k_143)) if _t135 else _t135):
		var _t136 = this_
		var _t137 = {"k": "idle"}
		J.sp(_t136, "view", _t137)
		J.mc(this_, "renderPanel", [])

func _f42(this_, a: Array, env):
	var v_w_149 = null
	v_w_149 = J.arg(a, 0)
	J.sp(v_w_149, "bubT", 0.0)
	if (absf(J.num(J.sub(J.gp(v_w_149, "x"), J.gp(J.gp(env["this"], "afu"), "x")))) < 0.16):
		var _t147 = J.mc(env["this"], "avoid", [J.add(J.gp(J.gp(env["this"], "afu"), "x"), ((-0.2) if J.cmp(J.gp(v_w_149, "x"), J.gp(J.gp(env["this"], "afu"), "x"), "<") else 0.2))])
		J.sp(v_w_149, "tx", _t147)
		var _t148 = (0.87 + (randf() * 0.06))
		J.sp(v_w_149, "ty", _t148)
		J.sp(v_w_149, "wait", 3.0)

func _f41(this_, a: Array, env):
	var v_k_147 = null; var v_kp_148 = null
	var _s64 = {"__p": env, "this": null}
	_s64["this"] = this_
	v_k_147 = J.arg(a, 0)
	var _t138 = _s64["this"]
	J.sp(_t138, "pend", null)
	var _t139 = J.gp(_s64["this"], "afu")
	var _t140 = J.gp(J.gp(J.G.get("GS_STALLS"), v_k_147), "face")
	J.sp(_t139, "dir", _t140)
	v_kp_148 = J.gp(J.gp(_s64["this"], "keepers"), v_k_147)
	if J.t(v_kp_148):
		var _t141 = J.G.get("pick")
		var _t142 = J.cl(_t141, null, [J.gp(J.G.get("GS_KEEPER_HI"), v_k_147)])
		J.mc(_s64["this"], "say", [v_kp_148, J.mc(_t142, "replace", [J.re("^[^：]+：", ""), ""]), 3.0])
		J.sp(v_kp_148, "pose", "cast")
		J.sp(v_kp_148, "poseT", 0.9)
	var _t143 = _s64["this"]
	var _t144 = {"k": v_k_147}
	J.sp(_t143, "view", _t144)
	if J.seq(v_k_147, "haggle"):
		var _t145 = J.gp(_s64["this"], "view")
		J.sp(_t145, "sub", null)
	var _t146 = J.gp(_s64["this"], "walkers")
	J.mc(_t146, "forEach", [Callable(self, "_f42").bind(_s64)])
	J.mc(_s64["this"], "renderPanel", [])
	J.mc(J.G.get("Sound"), "play", ["paper"])

func _f44(this_, a: Array, env):
	var v_n_154 = null
	v_n_154 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_154])

func _f45(this_, a: Array, env):
	var v_n_155 = null
	v_n_155 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_155])

func _f43(this_, a: Array, env):
	var v_now_152 = null; var v_dt_153 = null
	var _s68 = {"__p": env, "this": null}
	_s68["this"] = this_
	v_now_152 = J.arg(a, 0)
	if (not J.t(J.gp(_s68["this"], "active"))):
		return null
	if (J.sub(v_now_152, J.gp(_s68["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f44").bind(_s68)])
		return null
	v_dt_153 = J.min_([0.05, J.div(J.sub(v_now_152, J.gp(_s68["this"], "last")), 1000.0)])
	var _t149 = _s68["this"]
	J.sp(_t149, "last", v_now_152)
	J.mc(_s68["this"], "step", [v_dt_153])
	if (not J.t(J.gp(_s68["this"], "_nat"))):
		J.mc(_s68["this"], "draw", [J.div(v_now_152, 1000.0)])
	J.F_requestAnimationFrame([Callable(self, "_f45").bind(_s68)])

func _f47(this_, a: Array, env):
	var v_k_180 = null
	v_k_180 = J.arg(a, 0)
	return J.cmp(J.gp(v_k_180, "bubT"), 0.0, ">")

func _f48(this_, a: Array, env):
	var v_o_181 = null
	v_o_181 = J.arg(a, 0)
	var _t239 = (not J.seq(v_o_181, env["w"]))
	return (J.cmp(J.gp(v_o_181, "bubT"), 0.0, ">") if _t239 else _t239)

func _f49(this_, a: Array, env):
	var v_w_188 = null
	v_w_188 = J.arg(a, 0)
	var _t259 = J.gp(v_w_188, "prop")
	var _t260 = ((not J.t(J.gp(v_w_188, "bump"))) if J.t(_t259) else _t259)
	var _t261 = ((not J.t(J.gp(v_w_188, "look"))) if J.t(_t260) else _t260)
	var _t262 = (J.cmp(J.mc(env["this"], "X", [J.gp(v_w_188, "x")]), 40.0, ">") if J.t(_t261) else _t261)
	return (J.cmp(J.mc(env["this"], "X", [J.gp(v_w_188, "x")]), J.sub(J.gp(env["this"], "W"), 40.0), "<") if J.t(_t262) else _t262)

func _f50(this_, a: Array, env):
	var v_p_194 = null
	v_p_194 = J.arg(a, 0)
	var _t270 = J.sub(J.gp(v_p_194, "life"), env["dt"])
	J.sp(v_p_194, "life", _t270)
	var _t271 = J.add(J.gp(v_p_194, "x"), J.mul(J.gp(v_p_194, "vx"), env["dt"]))
	J.sp(v_p_194, "x", _t271)
	var _t272 = J.add(J.gp(v_p_194, "y"), J.mul(J.gp(v_p_194, "vy"), env["dt"]))
	J.sp(v_p_194, "y", _t272)
	if J.seq(J.gp(v_p_194, "kind"), "joss"):
		var _t273 = J.add(J.gp(v_p_194, "rot"), J.mul(J.gp(v_p_194, "vr"), env["dt"]))
		J.sp(v_p_194, "rot", _t273)
		var _t274 = J.add(J.gp(v_p_194, "flip"), J.mul(env["dt"], J.gp(v_p_194, "vf")))
		J.sp(v_p_194, "flip", _t274)
		var _t275 = J.add(J.gp(v_p_194, "bx"), (sin(J.num(J.add(J.mul(J.gp(env["this"], "t"), J.gp(v_p_194, "sw")), J.gp(v_p_194, "ph")))) * 0.012))
		J.sp(v_p_194, "vx", _t275)
		if J.cmp(J.gp(v_p_194, "y"), J.gp(v_p_194, "land"), ">"):
			J.sp(v_p_194, "vy", 0.0)
			J.sp(v_p_194, "vx", 0.0)
			J.sp(v_p_194, "vr", 0.0)
			J.sp(v_p_194, "vf", 0.0)
	return J.cmp(J.gp(v_p_194, "life"), 0.0, ">")

func _f51(this_, a: Array, env):
	var v_f_196 = null
	v_f_196 = J.arg(a, 0)
	var _t282 = J.sub(J.gp(v_f_196, "life"), env["dt"])
	J.sp(v_f_196, "life", _t282)
	return (_t282 > 0.0)

func _f46(this_, a: Array, env):
	var v_A_159 = null; var v_g_160 = null; var v_tv_161 = null; var v_vw_162 = null; var v_want_163 = null; var v_c_164 = null; var v_dx_165 = null; var v_dy_166 = null; var v_d_167 = null; var v_sp_168 = null; var v_k_169 = null; var v_kp_170 = null; var v_near_171 = null; var v_dx_173 = null; var v_dy_174 = null; var v_d_175 = null; var v_sp_176 = null; var v_st_177 = null; var v_vis_178 = null; var v_busy_179 = null; var v_i_182 = null; var v_j_183 = null; var v_P_184 = null; var v_Q_185 = null; var v_W_186 = null; var v_vis_187 = null; var v_P_189 = null; var v_Q_190 = null; var v_mid_191 = null; var v_yy_192 = null; var v_l_193 = null; var v_f_195 = null; var v_v_197 = null
	var _s72 = {"__p": env, "this": null, "dt": null}
	_s72["this"] = this_
	_s72["dt"] = J.arg(a, 0)
	var _t150 = _s72["this"]
	var _t151 = J.add(J.gp(_t150, "t"), _s72["dt"])
	J.sp(_t150, "t", _t151)
	v_A_159 = J.gp(_s72["this"], "afu")
	v_g_160 = J.mc(_s72["this"], "geo", [])
	v_tv_161 = J.mc(_s72["this"], "targetVH", [])
	var _t152 = _s72["this"]
	var _t153 = J.add(J.gp(_t152, "vh"), (J.sub(v_tv_161, J.gp(_s72["this"], "vh")) * J.min_([1.0, J.mul(_s72["dt"], 7.0)])))
	J.sp(_t152, "vh", _t153)
	if J.cmp(J.gp(_s72["this"], "kick"), 0.0, ">"):
		var _t154 = _s72["this"]
		var _t155 = J.sub(J.gp(_t154, "kick"), _s72["dt"])
		J.sp(_t154, "kick", _t155)
		var _t156 = J.max_([0.2, J.sub(J.gp(v_A_159, "x"), J.mul(_s72["dt"], 0.12))])
		J.sp(v_A_159, "x", _t156)
		var _t157 = J.gp(v_A_159, "x")
		J.sp(v_A_159, "tx", _t157)
		var _t158 = J.gp(v_A_159, "y")
		J.sp(v_A_159, "ty", _t158)
		J.sp(v_A_159, "dir", 1.0)
		J.sp(v_A_159, "walking", false)
		J.sp(v_A_159, "pose", "hurt")
		J.sp(v_A_159, "poseT", 0.2)
	else:
		v_dx_165 = J.mul(J.sub(J.gp(v_A_159, "tx"), J.gp(v_A_159, "x")), J.gp(v_g_160, "IW"))
		v_dy_166 = J.mul(J.sub(J.gp(v_A_159, "ty"), J.gp(v_A_159, "y")), J.gp(v_g_160, "IH"))
		v_d_167 = J.hypot_([v_dx_165, v_dy_166])
		v_sp_168 = J.mul(J.mul(150.0, J.mc(_s72["this"], "depth", [J.gp(v_A_159, "y")])), _s72["dt"])
		if J.cmp(v_d_167, 2.0, ">"):
			var _t159 = J.add(J.gp(v_A_159, "x"), J.div((J.div(v_dx_165, v_d_167) * J.min_([v_sp_168, v_d_167])), J.gp(v_g_160, "IW")))
			J.sp(v_A_159, "x", _t159)
			var _t160 = J.add(J.gp(v_A_159, "y"), J.div((J.div(v_dy_166, v_d_167) * J.min_([v_sp_168, v_d_167])), J.gp(v_g_160, "IH")))
			J.sp(v_A_159, "y", _t160)
			if (absf(J.num(v_dx_165)) > 1.0):
				var _t161 = (1.0 if J.cmp(v_dx_165, 0.0, ">") else (-1.0))
				J.sp(v_A_159, "dir", _t161)
			J.sp(v_A_159, "walking", true)
			var _t162 = J.sub(J.gp(v_A_159, "dustT"), _s72["dt"])
			J.sp(v_A_159, "dustT", _t162)
			if J.cmp(J.gp(v_A_159, "dustT"), 0.0, "<="):
				J.sp(v_A_159, "dustT", 0.16)
				var _t163 = J.gp(_s72["this"], "parts")
				J.mc(_t163, "push", [{"kind": "dust", "x": J.sub(J.gp(v_A_159, "x"), J.mul(J.gp(v_A_159, "dir"), 0.006)), "y": J.gp(v_A_159, "y"), "vx": ((-J.num(J.gp(v_A_159, "dir"))) * 0.01), "vy": (-0.02), "life": 0.55, "max": 0.55, "r": (3.0 + (randf() * 3.0))}])
		else:
			var _t164 = J.gp(v_A_159, "walking")
			if J.t((J.gp(_s72["this"], "pend") if J.t(_t164) else _t164)):
				J.mc(_s72["this"], "arrive", [J.gp(_s72["this"], "pend")])
			J.sp(v_A_159, "walking", false)
	if J.cmp(J.gp(v_A_159, "poseT"), 0.0, ">"):
		var _t165 = J.sub(J.gp(v_A_159, "poseT"), _s72["dt"])
		J.sp(v_A_159, "poseT", _t165)
		if J.cmp(J.gp(v_A_159, "poseT"), 0.0, "<="):
			J.sp(v_A_159, "pose", null)
	v_vw_162 = J.div(J.gp(_s72["this"], "W"), J.gp(v_g_160, "IW"))
	v_want_163 = J.max_([0.0, J.min_([J.sub(1.0, v_vw_162), J.sub(J.gp(v_A_159, "x"), J.div(v_vw_162, 2.0))])])
	var _t166 = _s72["this"]
	var _t167 = J.add(J.gp(_t166, "cam"), (J.sub(v_want_163, J.gp(_s72["this"], "cam")) * J.min_([1.0, J.mul(_s72["dt"], 4.0)])))
	J.sp(_t166, "cam", _t167)
	var _t168 = _s72["this"]
	var _t169 = J.max_([0.0, J.min_([J.sub(1.0, v_vw_162), J.gp(_s72["this"], "cam")])])
	J.sp(_t168, "cam", _t169)
	for _t170 in J.keys(J.gp(_s72["this"], "keepers")):
		v_k_169 = _t170
		v_kp_170 = J.gp(J.gp(_s72["this"], "keepers"), v_k_169)
		if J.cmp(J.gp(v_kp_170, "poseT"), 0.0, ">"):
			var _t171 = J.sub(J.gp(v_kp_170, "poseT"), _s72["dt"])
			J.sp(v_kp_170, "poseT", _t171)
			var _t172 = J.min_([1.0, J.add(J.gp(v_kp_170, "pt"), J.mul(_s72["dt"], 1.6))])
			J.sp(v_kp_170, "pt", _t172)
			var _t173 = J.cmp(J.gp(v_kp_170, "poseT"), 0.0, "<=")
			if ((not J.t(J.gp(v_kp_170, "hold"))) if _t173 else _t173):
				J.sp(v_kp_170, "pose", null)
		if J.cmp(J.gp(v_kp_170, "bubT"), 0.0, ">"):
			var _t174 = J.sub(J.gp(v_kp_170, "bubT"), _s72["dt"])
			J.sp(v_kp_170, "bubT", _t174)
		var _t175 = (not J.t(J.gp(v_A_159, "walking")))
		v_near_171 = ((absf(J.num(J.sub(J.gp(v_A_159, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_169), "x")))) < 0.09) if _t175 else _t175)
		var _t176 = ((not J.t(J.gp(v_kp_170, "greeted"))) if J.t(v_near_171) else v_near_171)
		if J.t(((not J.t(J.gp(v_kp_170, "pose"))) if J.t(_t176) else _t176)):
			J.sp(v_kp_170, "greeted", true)
			var _t177 = J.seq(J.gp(v_kp_170, "k"), "xiaozhi")
			var _t178 = (1.8 if (_t177 if _t177 else J.seq(J.gp(v_kp_170, "k"), "eguiking")) else 1.6)
			J.sp(v_kp_170, "greet", _t178)
			J.sp(v_kp_170, "gt", 0.0)
		if (absf(J.num(J.sub(J.gp(v_A_159, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_169), "x")))) > 0.14):
			J.sp(v_kp_170, "greeted", false)
		if J.cmp(J.gp(v_kp_170, "greet"), 0.0, ">"):
			var _t179 = J.sub(J.gp(v_kp_170, "greet"), _s72["dt"])
			J.sp(v_kp_170, "greet", _t179)
			var _t180 = J.add(J.gp(v_kp_170, "gt"), _s72["dt"])
			J.sp(v_kp_170, "gt", _t180)
			if J.t(J.gp(v_kp_170, "pose")):
				J.sp(v_kp_170, "greet", 0.0)
		if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
			var _t182 = J.gp(v_kp_170, "st")
			var _t183 = J.gp(v_kp_170, "k")
			var _t184 = _s72["dt"]
			var _t181 = (not J.t(J.gp(v_kp_170, "pose")))
			var _t185 = J.mc(J.G.get("TOWN"), "tick", [_t182, _t183, _t184, ((not J.cmp(J.gp(v_kp_170, "greet"), 0.0, ">")) if _t181 else _t181), false])
			J.sp(v_kp_170, "st", _t185)
	for _t186 in J.iter(J.gp(_s72["this"], "walkers")):
		var _s84 = {"__p": _s72, "w": null}
		_s84["w"] = _t186
		if J.cmp(J.gp(_s84["w"], "bubT"), 0.0, ">"):
			var _t187 = _s84["w"]
			var _t188 = J.sub(J.gp(_t187, "bubT"), _s84["__p"]["dt"])
			J.sp(_t187, "bubT", _t188)
		if J.cmp(J.gp(_s84["w"], "bump"), 0.0, ">"):
			var _t189 = _s84["w"]
			var _t190 = J.sub(J.gp(_t189, "bump"), _s84["__p"]["dt"])
			J.sp(_t189, "bump", _t190)
			var _t191 = _s84["w"]
			var _t192 = J.add(J.gp(_t191, "bt"), _s84["__p"]["dt"])
			J.sp(_t191, "bt", _t192)
			var _t193 = _s84["w"]
			J.sp(_t193, "walking", false)
			continue
		if J.cmp(J.gp(_s84["w"], "look"), 0.0, ">"):
			var _t194 = _s84["w"]
			var _t195 = J.sub(J.gp(_t194, "look"), _s84["__p"]["dt"])
			J.sp(_t194, "look", _t195)
			var _t196 = _s84["w"]
			var _t197 = J.add(J.gp(_t196, "lt"), _s84["__p"]["dt"])
			J.sp(_t196, "lt", _t197)
			var _t198 = _s84["w"]
			J.sp(_t198, "walking", false)
			continue
		v_dx_173 = J.mul(J.sub(J.gp(_s84["w"], "tx"), J.gp(_s84["w"], "x")), J.gp(v_g_160, "IW"))
		v_dy_174 = J.mul(J.sub(J.gp(_s84["w"], "ty"), J.gp(_s84["w"], "y")), J.gp(v_g_160, "IH"))
		v_d_175 = J.hypot_([v_dx_173, v_dy_174])
		if J.cmp(v_d_175, 2.0, ">"):
			v_sp_176 = J.mul(34.0, _s84["__p"]["dt"])
			var _t199 = _s84["w"]
			var _t200 = J.add(J.gp(_t199, "x"), J.div((J.div(v_dx_173, v_d_175) * J.min_([v_sp_176, v_d_175])), J.gp(v_g_160, "IW")))
			J.sp(_t199, "x", _t200)
			var _t201 = _s84["w"]
			var _t202 = J.add(J.gp(_t201, "y"), J.div((J.div(v_dy_174, v_d_175) * J.min_([v_sp_176, v_d_175])), J.gp(v_g_160, "IH")))
			J.sp(_t201, "y", _t202)
			if (absf(J.num(v_dx_173)) > 0.5):
				var _t203 = _s84["w"]
				var _t204 = (1.0 if J.cmp(v_dx_173, 0.0, ">") else (-1.0))
				J.sp(_t203, "dir", _t204)
			var _t205 = _s84["w"]
			J.sp(_t205, "walking", true)
		else:
			var _t206 = J.gp(_s84["w"], "walking")
			if J.t(((not J.leq(J.gp(_s84["w"], "toStall"), null)) if J.t(_t206) else _t206)):
				var _t207 = _s84["w"]
				var _t208 = (2.6 + (randf() * 1.5))
				J.sp(_t207, "look", _t208)
				var _t209 = _s84["w"]
				J.sp(_t209, "lt", 0.0)
				var _t210 = _s84["w"]
				var _t211 = (1.0 if J.cmp(J.gp(J.gp(J.G.get("GS_STALLS"), J.gp(_s84["w"], "toStall")), "x"), J.gp(_s84["w"], "x"), ">=") else (-1.0))
				J.sp(_t210, "dir", _t211)
				var _t212 = _s84["w"]
				J.sp(_t212, "toStall", null)
			var _t213 = _s84["w"]
			J.sp(_t213, "walking", false)
			var _t214 = _s84["w"]
			var _t215 = J.sub(J.gp(_t214, "wait"), _s84["__p"]["dt"])
			J.sp(_t214, "wait", _t215)
			if J.cmp(J.gp(_s84["w"], "wait"), 0.0, "<="):
				var _t216 = _s84["w"]
				var _t217 = (2.0 + (randf() * 5.0))
				J.sp(_t216, "wait", _t217)
				v_st_177 = J.gp(J.G.get("GS_ORDER"), floor(J.num((randf() * 4.0))))
				var _t218 = J.seq(J.gp(J.gp(_s84["__p"]["this"], "view"), "k"), "idle")
				var _t219 = ((randf() < 0.3) if _t218 else _t218)
				var _t220 = (J.gp(_s84["w"], "prop") if _t219 else _t219)
				if J.t(((absf(J.num(J.sub(J.gp(J.gp(J.G.get("GS_STALLS"), v_st_177), "x"), J.gp(_s84["w"], "x")))) < 0.4) if J.t(_t220) else _t220)):
					var _t221 = _s84["w"]
					var _t222 = J.mc(_s84["__p"]["this"], "avoid", [J.add(J.gp(J.gp(J.G.get("GS_STALLS"), v_st_177), "x"), ((randf() - 0.5) * 0.07))])
					J.sp(_t221, "tx", _t222)
					var _t223 = _s84["w"]
					var _t224 = (0.79 + (randf() * 0.03))
					J.sp(_t223, "ty", _t224)
					var _t225 = _s84["w"]
					J.sp(_t225, "toStall", v_st_177)
				else:
					var _t226 = _s84["w"]
					var _t227 = J.mc(_s84["__p"]["this"], "avoid", [J.add(J.gp(_s84["w"], "x"), ((randf() - 0.5) * 0.3))])
					J.sp(_t226, "tx", _t227)
					var _t228 = _s84["w"]
					var _t229 = ((0.86 + (randf() * 0.07)) if (not J.seq(J.gp(J.gp(_s84["__p"]["this"], "view"), "k"), "idle")) else (0.79 + (randf() * 0.13)))
					J.sp(_t228, "ty", _t229)
					var _t230 = _s84["w"]
					J.sp(_t230, "toStall", null)
		var _t231 = _s84["w"]
		var _t232 = J.sub(J.gp(_t231, "chatT"), _s84["__p"]["dt"])
		J.sp(_t231, "chatT", _t232)
		if J.cmp(J.gp(_s84["w"], "chatT"), 0.0, "<="):
			var _t233 = _s84["w"]
			var _t234 = (7.0 + (randf() * 8.0))
			J.sp(_t233, "chatT", _t234)
			var _t235 = J.cmp(J.mc(_s84["__p"]["this"], "X", [J.gp(_s84["w"], "x")]), 20.0, ">")
			v_vis_178 = (J.cmp(J.mc(_s84["__p"]["this"], "X", [J.gp(_s84["w"], "x")]), J.sub(J.gp(_s84["__p"]["this"], "W"), 20.0), "<") if _t235 else _t235)
			var _t237 = (not J.seq(J.gp(J.gp(_s84["__p"]["this"], "view"), "k"), "idle"))
			if not J.t(_t237):
				var _t236 = J.S_Object_("values", [J.gp(_s84["__p"]["this"], "keepers")])
				_t237 = J.mc(_t236, "some", [Callable(self, "_f47").bind(_s84)])
			v_busy_179 = _t237
			var _t240 = ((not J.t(v_busy_179)) if J.t(v_vis_178) else v_vis_178)
			if J.t(_t240):
				var _t238 = J.gp(_s84["__p"]["this"], "walkers")
				_t240 = (not J.t(J.mc(_t238, "some", [Callable(self, "_f48").bind(_s84)])))
			if J.t(_t240):
				J.mc(_s84["__p"]["this"], "chat", [_s84["w"]])
	var _t241 = _s72["this"]
	var _t242 = J.sub(J.gp(_t241, "bumpCD"), _s72["dt"])
	J.sp(_t241, "bumpCD", _t242)
	v_i_182 = 0.0
	while true:
		if not J.cmp(v_i_182, J.len(J.gp(_s72["this"], "walkers")), "<"): break
		v_j_183 = J.add(v_i_182, 1.0)
		while true:
			if not J.cmp(v_j_183, J.len(J.gp(_s72["this"], "walkers")), "<"): break
			v_P_184 = J.gp(J.gp(_s72["this"], "walkers"), v_i_182)
			v_Q_185 = J.gp(J.gp(_s72["this"], "walkers"), v_j_183)
			var _t243 = J.gp(v_P_184, "walking")
			var _t244 = (J.gp(v_Q_185, "walking") if J.t(_t243) else _t243)
			var _t245 = (J.gp(v_P_184, "prop") if J.t(_t244) else _t244)
			var _t246 = (J.gp(v_Q_185, "prop") if J.t(_t245) else _t245)
			var _t247 = ((not J.seq(J.gp(v_P_184, "dir"), J.gp(v_Q_185, "dir"))) if J.t(_t246) else _t246)
			var _t248 = ((absf(J.num(J.sub(J.gp(v_P_184, "x"), J.gp(v_Q_185, "x")))) < 0.03) if J.t(_t247) else _t247)
			var _t249 = ((absf(J.num(J.sub(J.gp(v_P_184, "y"), J.gp(v_Q_185, "y")))) < 0.03) if J.t(_t248) else _t248)
			if J.t(((J.mul(J.sub(J.gp(v_Q_185, "x"), J.gp(v_P_184, "x")), J.gp(v_P_184, "dir")) > 0.0) if J.t(_t249) else _t249)):
				for _t250 in J.iter([v_P_184, v_Q_185]):
					v_W_186 = _t250
					J.sp(v_W_186, "bump", 1.8)
					J.sp(v_W_186, "bt", 0.0)
					var _t251 = J.gp(v_W_186, "x")
					J.sp(v_W_186, "tx", _t251)
					var _t252 = J.gp(v_W_186, "y")
					J.sp(v_W_186, "ty", _t252)
					J.sp(v_W_186, "toStall", null)
					var _t253 = (0.5 + randf())
					J.sp(v_W_186, "wait", _t253)
					var _t254 = J.gp(J.G.get("GS_SORRY"), floor(J.num((randf() * J.len(J.G.get("GS_SORRY"))))))
					J.sp(v_W_186, "sorry", _t254)
			v_j_183 = J.num(v_j_183) + 1.0
		v_i_182 = J.num(v_i_182) + 1.0
	var _t255 = J.cmp(J.gp(_s72["this"], "bumpCD"), 0.0, "<=")
	if (J.seq(J.gp(J.gp(_s72["this"], "view"), "k"), "idle") if _t255 else _t255):
		var _t256 = _s72["this"]
		var _t257 = (16.0 + (randf() * 12.0))
		J.sp(_t256, "bumpCD", _t257)
		var _t258 = J.gp(_s72["this"], "walkers")
		v_vis_187 = J.mc(_t258, "filter", [Callable(self, "_f49").bind(_s72)])
		if (J.len(v_vis_187) >= 2.0):
			v_P_189 = J.gp(v_vis_187, 0.0)
			v_Q_190 = J.gp(v_vis_187, 1.0)
			v_mid_191 = J.div(J.add(J.gp(v_P_189, "x"), J.gp(v_Q_190, "x")), 2.0)
			v_yy_192 = (0.83 + (randf() * 0.06))
			v_l_193 = J.cmp(J.gp(v_P_189, "x"), J.gp(v_Q_190, "x"), "<")
			J.sp(v_Q_190, "ty", v_yy_192)
			J.sp(v_P_189, "ty", v_yy_192)
			var _t263 = J.mc(_s72["this"], "avoid", [J.add(v_mid_191, (0.07 if J.t(v_l_193) else (-0.07)))])
			J.sp(v_P_189, "tx", _t263)
			var _t264 = J.mc(_s72["this"], "avoid", [J.add(v_mid_191, ((-0.07) if J.t(v_l_193) else 0.07))])
			J.sp(v_Q_190, "tx", _t264)
			J.sp(v_Q_190, "wait", 8.0)
			J.sp(v_P_189, "wait", 8.0)
			J.sp(v_Q_190, "toStall", null)
			J.sp(v_P_189, "toStall", null)
	if (randf() < J.mul(_s72["dt"], 1.6)):
		var _t265 = J.gp(_s72["this"], "parts")
		J.mc(_t265, "push", [J.mc(_s72["this"], "mkJoss", [false])])
	if (randf() < J.mul(_s72["dt"], 5.0)):
		var _t266 = J.gp(_s72["this"], "parts")
		J.mc(_t266, "push", [{"kind": "steam", "x": (0.752 + ((randf() - 0.5) * 0.02)), "y": 0.515, "vx": ((randf() - 0.5) * 0.004), "vy": ((-0.035) - (randf() * 0.02)), "life": 2.2, "max": 2.2, "r": (4.0 + (randf() * 4.0))}])
	if (randf() < J.mul(_s72["dt"], 1.2)):
		var _t267 = J.gp(_s72["this"], "parts")
		J.mc(_t267, "push", [{"kind": "mist", "x": (0.9 + (randf() * 0.08)), "y": (0.6 + (randf() * 0.2)), "vx": ((-0.006) - (randf() * 0.01)), "vy": (-0.004), "life": 4.0, "max": 4.0, "r": (20.0 + (randf() * 30.0))}])
	var _t268 = _s72["this"]
	var _t269 = J.gp(_s72["this"], "parts")
	var _t276 = J.mc(_t269, "filter", [Callable(self, "_f50").bind(_s72)])
	J.sp(_t268, "parts", _t276)
	for _t277 in J.iter(J.gp(_s72["this"], "fog")):
		v_f_195 = _t277
		var _t278 = J.add(J.gp(v_f_195, "x"), J.mul(J.gp(v_f_195, "v"), _s72["dt"]))
		J.sp(v_f_195, "x", _t278)
		if J.cmp(J.gp(v_f_195, "x"), 1.2, ">"):
			var _t279 = (-0.2)
			J.sp(v_f_195, "x", _t279)
		if J.cmp(J.gp(v_f_195, "x"), (-0.2), "<"):
			J.sp(v_f_195, "x", 1.2)
	var _t280 = _s72["this"]
	var _t281 = J.gp(_s72["this"], "floats")
	var _t283 = J.mc(_t281, "filter", [Callable(self, "_f51").bind(_s72)])
	J.sp(_t280, "floats", _t283)
	var _t284 = J.G.get("$")
	v_c_164 = J.cl(_t284, null, ["#gs-coins i"])
	if J.t(v_c_164):
		var _t285 = J.G.get("fmt")
		v_v_197 = J.cl(_t285, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])
		if (not J.seq(J.gp(v_c_164, "textContent"), v_v_197)):
			J.sp(v_c_164, "textContent", v_v_197)

func _f52(this_, a: Array, env):
	var v_init_200 = null
	v_init_200 = J.arg(a, 0)
	return {"kind": "joss", "x": J.sub(J.add(J.gp(this_, "cam"), (randf() * 1.3)), 0.15), "y": ((randf() * 0.8) if J.t(v_init_200) else (-0.05)), "bx": ((randf() - 0.5) * 0.01), "vx": 0.0, "vy": (0.025 + (randf() * 0.025)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 2.0), "flip": (randf() * 6.0), "vf": (2.0 + (randf() * 3.0)), "sw": (0.8 + randf()), "ph": (randf() * 6.0), "land": (0.8 + (randf() * 0.17)), "life": ((10.0 + (randf() * 10.0)) if J.t(v_init_200) else 24.0), "max": 24.0}

func _f53(this_, a: Array, env):
	var v_nx_203 = null; var v_i_204 = null; var v_hit_205 = null; var v_k_206 = null; var v_kx_207 = null
	v_nx_203 = J.arg(a, 0)
	var _t286 = J.max_([0.03, J.min_([0.9, v_nx_203])])
	v_nx_203 = _t286
	v_i_204 = 0.0
	while true:
		if not J.cmp(v_i_204, 4.0, "<"): break
		v_hit_205 = false
		for _t287 in J.keys(J.gp(this_, "keepers")):
			v_k_206 = _t287
			v_kx_207 = J.gp(J.gp(J.gp(this_, "keepers"), v_k_206), "x")
			if (absf(J.num(J.sub(v_nx_203, v_kx_207))) < 0.05):
				var _t288 = J.add(v_kx_207, ((-0.06) if J.cmp(v_nx_203, v_kx_207, "<") else 0.06))
				v_nx_203 = _t288
				v_hit_205 = true
		var _t289 = (not J.seq(J.gp(J.gp(this_, "view"), "k"), "idle"))
		if ((absf(J.num(J.sub(v_nx_203, J.gp(J.gp(this_, "afu"), "x")))) < 0.15) if _t289 else _t289):
			var _t290 = J.add(J.gp(J.gp(this_, "afu"), "x"), ((-0.17) if J.cmp(v_nx_203, J.gp(J.gp(this_, "afu"), "x"), "<") else 0.17))
			v_nx_203 = _t290
			v_hit_205 = true
		var _t291 = J.max_([0.03, J.min_([0.9, v_nx_203])])
		v_nx_203 = _t291
		if (not J.t(v_hit_205)):
			break
		v_i_204 = J.num(v_i_204) + 1.0
	return v_nx_203

func _f54(this_, a: Array, env):
	var v_w_210 = null; var v_force_211 = null; var v_line_212 = null; var v_i_213 = null
	v_w_210 = J.arg(a, 0)
	v_force_211 = J.arg(a, 1)
	v_line_212 = null
	v_i_213 = 0.0
	var _t292 = true
	while true:
		if not _t292:
			var _t293 = J.gp(this_, "chatUsed")
			var _t294 = J.mc(_t293, "has", [v_line_212])
			if not J.t((J.cmp(v_i_213, 40.0, "<") if J.t(_t294) else _t294)): break
		_t292 = false
		var _t295 = J.G.get("pick")
		var _t296 = J.cl(_t295, null, [J.G.get("GS_CHATTER")])
		v_line_212 = _t296
		v_i_213 = J.num(v_i_213) + 1.0
	if J.cmp(J.gp(J.gp(this_, "chatUsed"), "size"), (J.len(J.G.get("GS_CHATTER")) - 6.0), ">"):
		J.mc(J.gp(this_, "chatUsed"), "clear", [])
	var _t297 = J.gp(this_, "chatUsed")
	J.mc(_t297, "add", [v_line_212])
	J.mc(this_, "say", [v_w_210, v_line_212, (3.6 if J.t(v_force_211) else 3.2)])

func _f55(this_, a: Array, env):
	var v_o_216 = null; var v_text_217 = null; var v_dur_218 = null
	v_o_216 = J.arg(a, 0)
	v_text_217 = J.arg(a, 1)
	v_dur_218 = J.arg(a, 2)
	if (not J.t(v_o_216)):
		return null
	J.sp(v_o_216, "bub", v_text_217)
	var _t298 = (v_dur_218 if J.t(v_dur_218) else 3.0)
	J.sp(v_o_216, "bubT", _t298)

func _f57(this_, a: Array, env):
	var v_f_226 = null
	v_f_226 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_226, "life"), 0.9, ">")

func _f56(this_, a: Array, env):
	var v_fx_221 = null; var v_fy_222 = null; var v_text_223 = null; var v_col_224 = null; var v_n_225 = null
	v_fx_221 = J.arg(a, 0)
	v_fy_222 = J.arg(a, 1)
	v_text_223 = J.arg(a, 2)
	v_col_224 = J.arg(a, 3)
	var _t299 = J.gp(this_, "floats")
	v_n_225 = J.len(J.mc(_t299, "filter", [Callable(self, "_f57").bind(env)]))
	var _t300 = J.gp(this_, "floats")
	J.mc(_t300, "push", [{"x": v_fx_221, "y": J.add(v_fy_222, J.mul(v_n_225, 0.05)), "text": v_text_223, "col": (v_col_224 if J.t(v_col_224) else "#ffe08a"), "life": 1.8, "max": 1.8}])

func _f59(this_, a: Array, env):
	var v_lx_239 = null; var v_ly_240 = null; var v_i_241 = null; var v_fl_242 = null
	var _t313 = J.gp(J.arg(a, 0), 0.0)
	v_lx_239 = _t313
	var _t314 = J.gp(J.arg(a, 0), 1.0)
	v_ly_240 = _t314
	v_i_241 = J.arg(a, 1)
	v_fl_242 = ((0.16 + (0.07 * sin(J.num((J.mul(env["t"], 3.1) + J.mul(v_i_241, 1.7)))))) + (0.04 * sin(J.num(J.add(J.mul(env["t"], 7.3), v_i_241)))))
	J.mc(env["this"], "glow", [env["ctx"], J.add(J.mc(env["this"], "X", [v_lx_239]), (sin(J.num(J.add(J.mul(env["t"], 1.3), v_i_241))) * 2.0)), J.mc(env["this"], "Y", [v_ly_240]), J.mul(J.gp(env["g"], "IH"), 0.06), ("rgba(255,120,60," + J.str(v_fl_242) + ")")])

func _f60(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "drawKeeper", [env["__p"]["ctx"], env["k"], env["__p"]["t"]])

func _f61(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "drawWalker", [env["__p"]["ctx"], env["w"], env["__p"]["t"]])

func _f62(this_, a: Array, env):
	return J.mc(env["this"], "drawAfu", [env["ctx"], env["t"]])

func _f63(this_, a: Array, env):
	var v_a_245 = null; var v_b_246 = null
	v_a_245 = J.arg(a, 0)
	v_b_246 = J.arg(a, 1)
	return J.sub(J.gp(v_a_245, "y"), J.gp(v_b_246, "y"))

func _f64(this_, a: Array, env):
	var v_o_247 = null
	v_o_247 = J.arg(a, 0)
	return J.mc(v_o_247, "f", [])

func _f58(this_, a: Array, env):
	var v_c_230 = null; var v_dp_232 = null; var v_W_234 = null; var v_H_235 = null; var v_img_236 = null; var v_bot_237 = null; var v_list_238 = null; var v_k_248 = null; var v_kp_249 = null; var v_w_250 = null; var v_f_251 = null; var v_k_252 = null; var v_x_253 = null; var v_y_254 = null
	var _s126 = {"__p": env, "this": null, "t": null, "ctx": null, "g": null}
	_s126["this"] = this_
	_s126["t"] = J.arg(a, 0)
	var _t301 = J.gp(_s126["this"], "_nat")
	var _t302 = (J.gp(_s126["this"], "_natCtx") if J.t(_t301) else _t301)
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_gsDraw")), "undefined")) if J.t(_t302) else _t302)):
		var _t303 = J.G.get("__nat_gsDraw")
		J.cl(_t303, null, [J.gp(_s126["this"], "_natCtx"), _s126["this"], _s126["t"]])
		return null
	var _t304 = J.gp(_s126["this"], "_nat")
	if J.t(((not J.t(J.gp(_s126["this"], "_natCtx"))) if J.t(_t304) else _t304)):
		return null
	var _t306 = null
	if J.t(J.gp(_s126["this"], "_natCtx")):
		_t306 = null
	else:
		var _t305 = J.G.get("$")
		_t306 = J.cl(_t305, null, ["#gs-cvs"])
	v_c_230 = _t306
	var _t307 = (not J.t(J.gp(_s126["this"], "_natCtx")))
	if ((not J.t(v_c_230)) if _t307 else _t307):
		return null
	var _t308 = J.gp(_s126["this"], "_natCtx")
	_s126["ctx"] = (_t308 if J.t(_t308) else J.mc(v_c_230, "getContext", ["2d"]))
	v_dp_232 = (1.0 if J.t(J.gp(_s126["this"], "_natCtx")) else J.gp(_s126["this"], "dpr"))
	J.mc(_s126["ctx"], "setTransform", [v_dp_232, 0.0, 0.0, v_dp_232, 0.0, 0.0])
	_s126["g"] = J.mc(_s126["this"], "geo", [])
	v_W_234 = J.gp(_s126["this"], "W")
	v_H_235 = J.gp(_s126["this"], "H")
	v_img_236 = J.gp(J.G.get("SPR"), "bg_street")
	var _t309 = _s126["ctx"]
	J.sp(_t309, "fillStyle", "#0c0a12")
	J.mc(_s126["ctx"], "fillRect", [0.0, 0.0, v_W_234, v_H_235])
	var _t310 = (J.gp(v_img_236, "complete") if J.t(v_img_236) else v_img_236)
	if J.t((J.gp(v_img_236, "naturalWidth") if J.t(_t310) else _t310)):
		J.mc(_s126["ctx"], "drawImage", [v_img_236, J.mul((-J.num(J.gp(_s126["this"], "cam"))), J.gp(_s126["g"], "IW")), 0.0, J.gp(_s126["g"], "IW"), J.gp(_s126["g"], "IH")])
	v_bot_237 = J.mc(_s126["ctx"], "createLinearGradient", [0.0, J.sub(J.gp(_s126["g"], "IH"), 30.0), 0.0, J.add(J.gp(_s126["g"], "IH"), 40.0)])
	J.mc(v_bot_237, "addColorStop", [0.0, "rgba(12,10,18,0)"])
	J.mc(v_bot_237, "addColorStop", [1.0, "rgba(12,10,18,1)"])
	var _t311 = _s126["ctx"]
	J.sp(_t311, "fillStyle", v_bot_237)
	J.mc(_s126["ctx"], "fillRect", [0.0, J.sub(J.gp(_s126["g"], "IH"), 30.0), v_W_234, (J.sub(v_H_235, J.gp(_s126["g"], "IH")) + 30.0)])
	J.mc(_s126["ctx"], "save", [])
	var _t312 = _s126["ctx"]
	J.sp(_t312, "globalCompositeOperation", "lighter")
	J.mc(_s126["this"], "glow", [_s126["ctx"], J.mc(_s126["this"], "X", [0.785]), J.mc(_s126["this"], "Y", [0.085]), J.mul(J.gp(_s126["g"], "IH"), 0.16), ("rgba(140,255,170," + J.str((0.1 + (0.04 * sin(J.num(J.mul(_s126["t"], 0.8)))))) + ")")])
	J.mc(J.G.get("GS_LANTERNS"), "forEach", [Callable(self, "_f59").bind(_s126)])
	J.mc(_s126["this"], "glow", [_s126["ctx"], J.mc(_s126["this"], "X", [0.58]), J.mc(_s126["this"], "Y", [0.52]), J.mul(J.gp(_s126["g"], "IH"), 0.12), ("rgba(255,200,110," + J.str((0.08 + (0.03 * sin(J.num(J.mul(_s126["t"], 2.0)))))) + ")")])
	J.mc(_s126["ctx"], "restore", [])
	J.mc(_s126["this"], "drawFog", [_s126["ctx"], _s126["t"], false])
	J.mc(_s126["this"], "drawParts", [_s126["ctx"], "steam"])
	v_list_238 = []
	for _t315 in J.keys(J.gp(_s126["this"], "keepers")):
		var _s129 = {"__p": _s126, "k": null}
		_s129["k"] = _t315
		J.mc(v_list_238, "push", [{"y": J.gp(J.gp(J.gp(_s129["__p"]["this"], "keepers"), _s129["k"]), "y"), "f": Callable(self, "_f60").bind(_s129)}])
	for _t316 in J.iter(J.gp(_s126["this"], "walkers")):
		var _s131 = {"__p": _s126, "w": null}
		_s131["w"] = _t316
		J.mc(v_list_238, "push", [{"y": J.gp(_s131["w"], "y"), "f": Callable(self, "_f61").bind(_s131)}])
	J.mc(v_list_238, "push", [{"y": J.gp(J.gp(_s126["this"], "afu"), "y"), "f": Callable(self, "_f62").bind(_s126)}])
	J.mc(_s126["this"], "drawParts", [_s126["ctx"], "dust"])
	var _t317 = J.mc(v_list_238, "sort", [Callable(self, "_f63").bind(_s126)])
	J.mc(_t317, "forEach", [Callable(self, "_f64").bind(_s126)])
	J.mc(_s126["this"], "drawFog", [_s126["ctx"], _s126["t"], true])
	J.mc(_s126["this"], "drawParts", [_s126["ctx"], "mist"])
	J.mc(_s126["this"], "drawParts", [_s126["ctx"], "joss"])
	J.mc(_s126["this"], "drawLanternString", [_s126["ctx"], _s126["t"]])
	J.mc(_s126["this"], "drawSigns", [_s126["ctx"], _s126["t"]])
	for _t318 in J.keys(J.gp(_s126["this"], "keepers")):
		v_k_248 = _t318
		v_kp_249 = J.gp(J.gp(_s126["this"], "keepers"), v_k_248)
		if J.cmp(J.gp(v_kp_249, "bubT"), 0.0, ">"):
			J.mc(_s126["this"], "bubble", [_s126["ctx"], v_kp_249, J.gp(v_kp_249, "bub"), J.gp(v_kp_249, "bubT")])
	for _t319 in J.iter(J.gp(_s126["this"], "walkers")):
		v_w_250 = _t319
		if J.cmp(J.gp(v_w_250, "bubT"), 0.0, ">"):
			J.mc(_s126["this"], "bubble", [_s126["ctx"], v_w_250, J.gp(v_w_250, "bub"), J.gp(v_w_250, "bubT")])
	var _t320 = _s126["ctx"]
	J.sp(_t320, "textAlign", "center")
	var _t321 = _s126["ctx"]
	var _t322 = J.add("900 17px ", J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily"))
	J.sp(_t321, "font", _t322)
	for _t323 in J.iter(J.gp(_s126["this"], "floats")):
		v_f_251 = _t323
		v_k_252 = J.div(J.gp(v_f_251, "life"), J.gp(v_f_251, "max"))
		v_x_253 = J.mc(_s126["this"], "X", [J.gp(v_f_251, "x")])
		v_y_254 = J.sub(J.mc(_s126["this"], "Y", [J.gp(v_f_251, "y")]), (J.sub(1.0, v_k_252) * 40.0))
		var _t324 = _s126["ctx"]
		var _t325 = J.min_([1.0, J.mul(v_k_252, 2.0)])
		J.sp(_t324, "globalAlpha", _t325)
		var _t326 = _s126["ctx"]
		J.sp(_t326, "lineWidth", 4.0)
		var _t327 = _s126["ctx"]
		J.sp(_t327, "strokeStyle", "rgba(0,0,0,.8)")
		J.mc(_s126["ctx"], "strokeText", [J.gp(v_f_251, "text"), v_x_253, v_y_254])
		var _t328 = _s126["ctx"]
		var _t329 = J.gp(v_f_251, "col")
		J.sp(_t328, "fillStyle", _t329)
		J.mc(_s126["ctx"], "fillText", [J.gp(v_f_251, "text"), v_x_253, v_y_254])
	var _t330 = _s126["ctx"]
	J.sp(_t330, "globalAlpha", 1.0)

func _f65(this_, a: Array, env):
	var v_ctx_257 = null; var v_x_258 = null; var v_y_259 = null; var v_r_260 = null; var v_col_261 = null; var v_gr_262 = null
	v_ctx_257 = J.arg(a, 0)
	v_x_258 = J.arg(a, 1)
	v_y_259 = J.arg(a, 2)
	v_r_260 = J.arg(a, 3)
	v_col_261 = J.arg(a, 4)
	v_gr_262 = J.mc(v_ctx_257, "createRadialGradient", [v_x_258, v_y_259, 0.0, v_x_258, v_y_259, v_r_260])
	J.mc(v_gr_262, "addColorStop", [0.0, v_col_261])
	J.mc(v_gr_262, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_ctx_257, "fillStyle", v_gr_262)
	J.mc(v_ctx_257, "fillRect", [J.sub(v_x_258, v_r_260), J.sub(v_y_259, v_r_260), J.mul(v_r_260, 2.0), J.mul(v_r_260, 2.0)])

func _f67(this_, a: Array, env):
	var v_f_269 = null; var v_i_270 = null; var v_x_271 = null; var v_y_272 = null; var v_r_273 = null; var v_gr_274 = null; var v_a_275 = null
	v_f_269 = J.arg(a, 0)
	v_i_270 = J.arg(a, 1)
	if (not J.seq(J.cmp(J.gp(v_f_269, "y"), 0.84, ">"), env["front"])):
		return null
	v_x_271 = J.mc(env["this"], "X", [(J.mul(J.gp(v_f_269, "x"), 1.0) + J.mul(J.gp(env["this"], "cam"), ((-0.15) if J.t(env["front"]) else 0.0)))])
	v_y_272 = J.mc(env["this"], "Y", [J.gp(v_f_269, "y")])
	v_r_273 = (J.mul(J.gp(v_f_269, "r"), J.gp(env["g"], "IW")) * 0.5)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_271, v_y_272])
	J.mc(env["ctx"], "scale", [1.0, 0.32])
	v_gr_274 = J.mc(env["ctx"], "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, v_r_273])
	v_a_275 = J.mul(J.gp(v_f_269, "a"), (0.8 + (0.2 * sin(J.num(J.add(J.mul(env["t"], 0.7), v_i_270))))))
	J.mc(v_gr_274, "addColorStop", [0.0, ("rgba(200,190,230," + J.str(v_a_275) + ")")])
	J.mc(v_gr_274, "addColorStop", [1.0, "rgba(200,190,230,0)"])
	var _t332 = env["ctx"]
	J.sp(_t332, "fillStyle", v_gr_274)
	J.mc(env["ctx"], "fillRect", [(-J.num(v_r_273)), (-J.num(v_r_273)), J.mul(v_r_273, 2.0), J.mul(v_r_273, 2.0)])
	J.mc(env["ctx"], "restore", [])

func _f66(this_, a: Array, env):
	var _s142 = {"__p": env, "this": null, "ctx": null, "t": null, "front": null, "g": null}
	_s142["this"] = this_
	_s142["ctx"] = J.arg(a, 0)
	_s142["t"] = J.arg(a, 1)
	_s142["front"] = J.arg(a, 2)
	_s142["g"] = J.mc(_s142["this"], "geo", [])
	var _t331 = J.gp(_s142["this"], "fog")
	J.mc(_t331, "forEach", [Callable(self, "_f67").bind(_s142)])

func _f68(this_, a: Array, env):
	var v_ctx_278 = null; var v_kind_279 = null; var v_g_280 = null; var v_p_281 = null; var v_x_282 = null; var v_y_283 = null; var v_k_284 = null; var v_sz_285 = null; var v_r_286 = null; var v_r_287 = null; var v_gr_288 = null; var v_r_289 = null
	v_ctx_278 = J.arg(a, 0)
	v_kind_279 = J.arg(a, 1)
	v_g_280 = J.mc(this_, "geo", [])
	for _t333 in J.iter(J.gp(this_, "parts")):
		v_p_281 = _t333
		if (not J.seq(J.gp(v_p_281, "kind"), v_kind_279)):
			continue
		v_x_282 = J.mc(this_, "X", [J.gp(v_p_281, "x")])
		v_y_283 = J.mc(this_, "Y", [J.gp(v_p_281, "y")])
		v_k_284 = J.div(J.gp(v_p_281, "life"), J.gp(v_p_281, "max"))
		var _t334 = J.cmp(v_x_282, (-60.0), "<")
		if (_t334 if _t334 else J.cmp(v_x_282, J.add(J.gp(this_, "W"), 60.0), ">")):
			continue
		if J.seq(v_kind_279, "joss"):
			v_sz_285 = J.mul(J.gp(v_g_280, "IH"), 0.016)
			J.mc(v_ctx_278, "save", [])
			var _t335 = (J.min_([1.0, J.mul(J.gp(v_p_281, "life"), 0.6)]) * 0.92)
			J.sp(v_ctx_278, "globalAlpha", _t335)
			J.mc(v_ctx_278, "translate", [v_x_282, v_y_283])
			J.mc(v_ctx_278, "rotate", [J.gp(v_p_281, "rot")])
			J.mc(v_ctx_278, "scale", [1.0, cos(J.num(J.gp(v_p_281, "flip")))])
			J.sp(v_ctx_278, "fillStyle", "#e8c35a")
			J.sp(v_ctx_278, "strokeStyle", "#6a4a14")
			J.sp(v_ctx_278, "lineWidth", 0.8)
			J.mc(v_ctx_278, "fillRect", [(-J.num(v_sz_285)), ((-J.num(v_sz_285)) * 0.7), J.mul(v_sz_285, 2.0), J.mul(v_sz_285, 1.4)])
			J.mc(v_ctx_278, "strokeRect", [(-J.num(v_sz_285)), ((-J.num(v_sz_285)) * 0.7), J.mul(v_sz_285, 2.0), J.mul(v_sz_285, 1.4)])
			J.sp(v_ctx_278, "fillStyle", "#b8322a")
			J.mc(v_ctx_278, "fillRect", [((-J.num(v_sz_285)) * 0.35), ((-J.num(v_sz_285)) * 0.35), J.mul(v_sz_285, 0.7), J.mul(v_sz_285, 0.7)])
			J.mc(v_ctx_278, "restore", [])
		else:
			if J.seq(v_kind_279, "steam"):
				v_r_286 = J.div(J.mul(J.mul(J.gp(v_p_281, "r"), J.sub(2.0, v_k_284)), J.gp(v_g_280, "IH")), 500.0)
				var _t336 = ("rgba(240,235,255," + J.str(((J.mul(0.22, v_k_284) * J.sub(1.0, v_k_284)) * 3.0)) + ")")
				J.sp(v_ctx_278, "fillStyle", _t336)
				J.mc(v_ctx_278, "beginPath", [])
				J.mc(v_ctx_278, "arc", [J.add(v_x_282, (sin(J.num(J.add(J.mul(J.gp(v_p_281, "life"), 3.0), J.gp(v_p_281, "r")))) * 4.0)), v_y_283, v_r_286, 0.0, 7.0])
				J.mc(v_ctx_278, "fill", [])
			else:
				if J.seq(v_kind_279, "mist"):
					v_r_287 = (J.div(J.mul(J.gp(v_p_281, "r"), J.gp(v_g_280, "IH")), 500.0) * (1.6 - J.mul(v_k_284, 0.6)))
					v_gr_288 = J.mc(v_ctx_278, "createRadialGradient", [v_x_282, v_y_283, 0.0, v_x_282, v_y_283, v_r_287])
					J.mc(v_gr_288, "addColorStop", [0.0, ("rgba(210,220,240," + J.str((0.16 * sin(J.num(J.mul(v_k_284, PI))))) + ")")])
					J.mc(v_gr_288, "addColorStop", [1.0, "rgba(210,220,240,0)"])
					J.sp(v_ctx_278, "fillStyle", v_gr_288)
					J.mc(v_ctx_278, "fillRect", [J.sub(v_x_282, v_r_287), J.sub(v_y_283, v_r_287), J.mul(v_r_287, 2.0), J.mul(v_r_287, 2.0)])
				else:
					if J.seq(v_kind_279, "dust"):
						v_r_289 = J.div(J.mul(J.mul(J.gp(v_p_281, "r"), J.sub(1.6, v_k_284)), J.gp(v_g_280, "IH")), 600.0)
						var _t337 = ("rgba(190,170,200," + J.str(J.mul(0.4, v_k_284)) + ")")
						J.sp(v_ctx_278, "fillStyle", _t337)
						J.mc(v_ctx_278, "beginPath", [])
						J.mc(v_ctx_278, "ellipse", [v_x_282, v_y_283, J.mul(v_r_289, 1.4), J.mul(v_r_289, 0.8), 0.0, 0.0, 7.0])
						J.mc(v_ctx_278, "fill", [])

func _f69(this_, a: Array, env):
	var v_ctx_292 = null; var v_t_293 = null; var v_g_294 = null; var v_par_295 = null; var v_top_296 = null; var v_sag_297 = null; var v_gap_298 = null; var v_off_299 = null; var v_n0_300 = null; var v_i_301 = null; var v_x0_302 = null; var v_x1_303 = null; var v_mx_304 = null; var v_my_305 = null; var v_sw_306 = null; var v_L_307 = null; var v_r_308 = null
	v_ctx_292 = J.arg(a, 0)
	v_t_293 = J.arg(a, 1)
	v_g_294 = J.mc(this_, "geo", [])
	v_par_295 = 1.25
	v_top_296 = (-4.0)
	v_sag_297 = J.mul(J.gp(v_g_294, "IH"), 0.06)
	v_gap_298 = J.mul(J.gp(v_g_294, "IW"), 0.16)
	v_off_299 = J.mul(J.mul((-J.num(J.gp(this_, "cam"))), J.gp(v_g_294, "IW")), v_par_295)
	v_n0_300 = (floor(J.num(J.div((-J.num(v_off_299)), v_gap_298))) - 1.0)
	J.mc(v_ctx_292, "save", [])
	J.sp(v_ctx_292, "strokeStyle", "rgba(30,18,24,.9)")
	J.sp(v_ctx_292, "lineWidth", 1.6)
	v_i_301 = v_n0_300
	while true:
		if not J.cmp(v_i_301, J.add(J.add(v_n0_300, ceil(J.num(J.div(J.gp(this_, "W"), v_gap_298)))), 3.0), "<"): break
		v_x0_302 = J.add(v_off_299, J.mul(v_i_301, v_gap_298))
		v_x1_303 = J.add(v_x0_302, v_gap_298)
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "moveTo", [v_x0_302, v_top_296])
		J.mc(v_ctx_292, "quadraticCurveTo", [J.div(J.add(v_x0_302, v_x1_303), 2.0), J.add(v_top_296, J.mul(v_sag_297, 2.0)), v_x1_303, v_top_296])
		J.mc(v_ctx_292, "stroke", [])
		v_mx_304 = J.div(J.add(v_x0_302, v_x1_303), 2.0)
		v_my_305 = J.add(v_top_296, v_sag_297)
		v_sw_306 = (sin(J.num((J.mul(v_t_293, 1.6) + J.mul(v_i_301, 1.3)))) * 0.22)
		v_L_307 = J.mul(J.gp(v_g_294, "IH"), 0.035)
		v_r_308 = J.mul(J.gp(v_g_294, "IH"), 0.028)
		J.mc(v_ctx_292, "save", [])
		J.mc(v_ctx_292, "translate", [v_mx_304, v_my_305])
		J.mc(v_ctx_292, "rotate", [v_sw_306])
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "moveTo", [0.0, 0.0])
		J.mc(v_ctx_292, "lineTo", [0.0, v_L_307])
		J.mc(v_ctx_292, "stroke", [])
		J.sp(v_ctx_292, "globalCompositeOperation", "lighter")
		J.mc(this_, "glow", [v_ctx_292, 0.0, J.add(v_L_307, v_r_308), J.mul(v_r_308, 3.0), ("rgba(255,110,60," + J.str((0.22 + (0.06 * sin(J.num(J.add(J.mul(v_t_293, 4.0), v_i_301)))))) + ")")])
		J.sp(v_ctx_292, "globalCompositeOperation", "source-over")
		var _t338 = ("#f2e6c8" if J.seq(J.mod(v_i_301, 3.0), 1.0) else "#c8322a")
		J.sp(v_ctx_292, "fillStyle", _t338)
		J.sp(v_ctx_292, "strokeStyle", "#2a1010")
		J.sp(v_ctx_292, "lineWidth", 1.6)
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "ellipse", [0.0, J.add(v_L_307, v_r_308), J.mul(v_r_308, 0.85), v_r_308, 0.0, 0.0, 7.0])
		J.mc(v_ctx_292, "fill", [])
		J.mc(v_ctx_292, "stroke", [])
		J.sp(v_ctx_292, "strokeStyle", "rgba(40,10,10,.45)")
		J.sp(v_ctx_292, "lineWidth", 1.0)
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "ellipse", [0.0, J.add(v_L_307, v_r_308), J.mul(v_r_308, 0.4), v_r_308, 0.0, 0.0, 7.0])
		J.mc(v_ctx_292, "stroke", [])
		J.sp(v_ctx_292, "fillStyle", "#e2b04a")
		J.mc(v_ctx_292, "fillRect", [((-J.num(v_r_308)) * 0.45), J.sub(v_L_307, 2.0), J.mul(v_r_308, 0.9), 3.0])
		J.mc(v_ctx_292, "fillRect", [((-J.num(v_r_308)) * 0.45), J.sub(J.add(v_L_307, J.mul(v_r_308, 2.0)), 1.0), J.mul(v_r_308, 0.9), 3.0])
		J.sp(v_ctx_292, "strokeStyle", "#c8322a")
		J.sp(v_ctx_292, "lineWidth", 1.4)
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "moveTo", [0.0, J.add(J.add(v_L_307, J.mul(v_r_308, 2.0)), 2.0)])
		J.mc(v_ctx_292, "lineTo", [(sin(J.num(J.add(J.mul(v_t_293, 2.4), v_i_301))) * 2.0), J.add(J.add(v_L_307, J.mul(v_r_308, 2.0)), J.mul(v_r_308, 0.9))])
		J.mc(v_ctx_292, "stroke", [])
		J.mc(v_ctx_292, "restore", [])
		J.sp(v_ctx_292, "strokeStyle", "rgba(30,18,24,.9)")
		J.sp(v_ctx_292, "lineWidth", 1.6)
		v_i_301 = J.num(v_i_301) + 1.0
	J.mc(v_ctx_292, "restore", [])

func _f70(this_, a: Array, env):
	var v_ctx_311 = null; var v_t_312 = null; var v_near_313 = null; var v_fam_314 = null; var v_k_315 = null; var v_s_316 = null; var v_x_317 = null; var v_y_318 = null; var v_w_319 = null; var v_on_320 = null
	v_ctx_311 = J.arg(a, 0)
	v_t_312 = J.arg(a, 1)
	v_near_313 = J.mc(this_, "nearStall", [])
	v_fam_314 = J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily")
	J.mc(v_ctx_311, "save", [])
	var _t339 = J.add("800 14px ", v_fam_314)
	J.sp(v_ctx_311, "font", _t339)
	J.sp(v_ctx_311, "textAlign", "center")
	J.sp(v_ctx_311, "textBaseline", "middle")
	for _t340 in J.iter(J.G.get("GS_ORDER")):
		v_k_315 = _t340
		v_s_316 = J.gp(J.G.get("GS_STALLS"), v_k_315)
		v_x_317 = J.mc(this_, "X", [(0.945 if J.seq(v_k_315, "alley") else J.gp(v_s_316, "x"))])
		v_y_318 = J.add(J.mc(this_, "Y", [(0.3 if J.seq(v_k_315, "alley") else 0.39)]), (sin(J.num((J.mul(v_t_312, 1.5) + J.mul(J.gp(v_s_316, "x"), 9.0)))) * 1.5))
		var _t341 = J.cmp(v_x_317, (-60.0), "<")
		if (_t341 if _t341 else J.cmp(v_x_317, J.add(J.gp(this_, "W"), 60.0), ">")):
			continue
		v_w_319 = J.add(J.gp(J.mc(v_ctx_311, "measureText", [J.gp(v_s_316, "name")]), "width"), 16.0)
		v_on_320 = J.seq(v_near_313, v_k_315)
		var _t342 = ("rgba(194,54,43,.94)" if J.t(v_on_320) else "rgba(20,12,22,.72)")
		J.sp(v_ctx_311, "fillStyle", _t342)
		var _t343 = ("#f3d68a" if J.t(v_on_320) else "rgba(243,214,138,.55)")
		J.sp(v_ctx_311, "strokeStyle", _t343)
		J.sp(v_ctx_311, "lineWidth", 1.2)
		J.mc(J.G.get("ART"), "rr", [v_ctx_311, J.sub(v_x_317, J.div(v_w_319, 2.0)), J.sub(v_y_318, 12.0), v_w_319, 24.0, 4.0, J.gp(v_ctx_311, "fillStyle"), J.gp(v_ctx_311, "strokeStyle"), 1.2])
		var _t344 = ("#fff3e0" if J.t(v_on_320) else "#f3d68a")
		J.sp(v_ctx_311, "fillStyle", _t344)
		J.mc(v_ctx_311, "fillText", [J.gp(v_s_316, "name"), v_x_317, J.add(v_y_318, 1.0)])
	J.mc(v_ctx_311, "restore", [])

func _f71(this_, a: Array, env):
	var v_A_323 = null; var v_best_324 = null; var v_bd_325 = null; var v_k_326 = null; var v_d_327 = null
	v_A_323 = J.gp(this_, "afu")
	v_best_324 = null
	v_bd_325 = 0.09
	for _t345 in J.iter(J.G.get("GS_ORDER")):
		v_k_326 = _t345
		v_d_327 = absf(J.num(J.sub(J.gp(v_A_323, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_326), "x"))))
		if J.cmp(v_d_327, v_bd_325, "<"):
			v_bd_325 = v_d_327
			v_best_324 = v_k_326
	return v_best_324

func _f72(this_, a: Array, env):
	var v_ctx_330 = null; var v_t_331 = null; var v_A_332 = null; var v_sc_333 = null; var v_x_334 = null; var v_y_335 = null
	v_ctx_330 = J.arg(a, 0)
	v_t_331 = J.arg(a, 1)
	v_A_332 = J.gp(this_, "afu")
	v_sc_333 = J.mc(this_, "charScale", [J.gp(v_A_332, "y")])
	v_x_334 = J.mc(this_, "X", [J.gp(v_A_332, "x")])
	v_y_335 = J.mc(this_, "Y", [J.gp(v_A_332, "y")])
	var _t346 = J.G.get("__gsDC")
	var _t349 = J.gp(v_A_332, "walking")
	var _t350 = J.cmp(J.gp(v_A_332, "dir"), 0.0, "<")
	var _t348 = null
	if J.t(J.gp(v_A_332, "walking")):
		_t348 = null
	else:
		var _t347 = J.gp(v_A_332, "pose")
		_t348 = (_t347 if J.t(_t347) else null)
	J.cl(_t346, null, [v_ctx_330, "afu", v_x_334, v_y_335, v_sc_333, {"t": v_t_331, "walk": _t349, "flip": _t350, "pose": _t348, "pt": ((1.0 - J.max_([0.0, J.gp(v_A_332, "poseT")])) if J.t(J.gp(v_A_332, "pose")) else 0.0), "tamed": true, "untied": true}])

func _f73(this_, a: Array, env):
	var v_ctx_338 = null; var v_k_339 = null; var v_t_340 = null; var v_kp_341 = null; var v_sc_342 = null; var v_x_343 = null; var v_y_344 = null; var v_face_345 = null; var v_pt_346 = null; var v_da_347 = null
	v_ctx_338 = J.arg(a, 0)
	v_k_339 = J.arg(a, 1)
	v_t_340 = J.arg(a, 2)
	v_kp_341 = J.gp(J.gp(this_, "keepers"), v_k_339)
	v_sc_342 = J.mul(J.mc(this_, "charScale", [J.gp(v_kp_341, "y")]), (1.05 if J.seq(J.gp(v_kp_341, "k"), "xiaogui") else (0.9 if J.seq(J.gp(v_kp_341, "k"), "baiwu") else 1.0)))
	v_x_343 = J.mc(this_, "X", [J.gp(v_kp_341, "x")])
	v_y_344 = J.mc(this_, "Y", [J.gp(v_kp_341, "y")])
	var _t351 = J.cmp(v_x_343, (-80.0), "<")
	if (_t351 if _t351 else J.cmp(v_x_343, J.add(J.gp(this_, "W"), 80.0), ">")):
		return null
	v_face_345 = J.cmp(J.gp(J.gp(this_, "afu"), "x"), J.gp(v_kp_341, "x"), "<")
	v_pt_346 = J.gp(v_kp_341, "pt")
	if J.seq(J.gp(v_kp_341, "pose"), "strike"):
		var _t352 = J.mod(J.mul(v_t_340, 1.4), 1.0)
		v_pt_346 = _t352
	if J.seq(J.gp(v_kp_341, "pose"), "windup"):
		var _t353 = (0.35 + (sin(J.num(J.mul(v_t_340, 3.0))) * 0.1))
		v_pt_346 = _t353
	if J.seq(J.gp(v_kp_341, "pose"), "hurt"):
		var _t354 = (0.35 + (sin(J.num(J.mul(v_t_340, 9.0))) * 0.05))
		v_pt_346 = _t354
	v_da_347 = {}
	var _t355 = (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined"))
	if ((not J.t(J.gp(v_kp_341, "pose"))) if _t355 else _t355):
		if J.cmp(J.gp(v_kp_341, "greet"), 0.0, ">"):
			var _t356 = {"act": "town_greet", "at": J.gp(v_kp_341, "gt"), "adur": J.add(J.gp(v_kp_341, "gt"), J.gp(v_kp_341, "greet"))}
			v_da_347 = _t356
		else:
			var _t357 = J.mc(J.G.get("TOWN"), "opts", [J.gp(v_kp_341, "st")])
			v_da_347 = _t357
			if J.t(J.gp(v_da_347, "act")):
				var _t358 = J.cmp(J.gp(J.G.get("GS_WORKFACE"), v_k_339), 0.0, "<")
				v_face_345 = _t358
		if J.seq(J.gp(v_kp_341, "k"), "eguiking"):
			var _t359 = {"potDX": J.sub(J.mc(this_, "X", [J.gp(J.G.get("GS_POT"), 0.0)]), v_x_343), "potDY": J.sub(J.mc(this_, "Y", [J.gp(J.G.get("GS_POT"), 1.0)]), v_y_344)}
			J.sp(v_da_347, "prop", _t359)
	var _t360 = J.G.get("__gsDC")
	var _t363 = J.gp(v_kp_341, "k")
	var _t362 = J.add(v_t_340, J.gp(v_kp_341, "ph"))
	var _t361 = J.gp(v_kp_341, "pose")
	J.cl(_t360, null, [v_ctx_338, _t363, v_x_343, v_y_344, v_sc_342, J.S_Object_("assign", [{"t": _t362, "flip": v_face_345, "pose": (_t361 if J.t(_t361) else null), "pt": v_pt_346, "tamed": true, "untied": true}, v_da_347])])

func _f74(this_, a: Array, env):
	var v_ctx_350 = null; var v_w_351 = null; var v_t_352 = null; var v_sc_353 = null; var v_x_354 = null; var v_y_355 = null; var v_da_356 = null
	v_ctx_350 = J.arg(a, 0)
	v_w_351 = J.arg(a, 1)
	v_t_352 = J.arg(a, 2)
	v_sc_353 = J.mul(J.mc(this_, "charScale", [J.gp(v_w_351, "y")]), 0.92)
	v_x_354 = J.mc(this_, "X", [J.gp(v_w_351, "x")])
	v_y_355 = J.mc(this_, "Y", [J.gp(v_w_351, "y")])
	var _t364 = J.cmp(v_x_354, (-80.0), "<")
	if (_t364 if _t364 else J.cmp(v_x_354, J.add(J.gp(this_, "W"), 80.0), ">")):
		return null
	v_da_356 = {}
	if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
		if J.cmp(J.gp(v_w_351, "bump"), 0.0, ">"):
			var _t365 = {"act": "town_bump", "at": J.gp(v_w_351, "bt"), "prop": J.S_Object_("assign", [{}, J.gp(v_w_351, "prop"), {"sorry": J.gp(v_w_351, "sorry")}])}
			v_da_356 = _t365
		else:
			if J.cmp(J.gp(v_w_351, "look"), 0.0, ">"):
				var _t366 = {"act": "town_look", "at": J.gp(v_w_351, "lt"), "adur": J.add(J.gp(v_w_351, "lt"), J.gp(v_w_351, "look")), "prop": J.gp(v_w_351, "prop")}
				v_da_356 = _t366
			else:
				if J.t(J.gp(v_w_351, "prop")):
					var _t367 = {"act": "town_walk", "at": 9.0, "prop": J.gp(v_w_351, "prop")}
					v_da_356 = _t367
	var _t368 = J.G.get("__gsDC")
	J.cl(_t368, null, [v_ctx_350, J.gp(v_w_351, "k"), v_x_354, v_y_355, v_sc_353, J.S_Object_("assign", [{"t": J.add(v_t_352, J.gp(v_w_351, "ph")), "walk": J.gp(v_w_351, "walking"), "flip": J.cmp(J.gp(v_w_351, "dir"), 0.0, "<"), "tamed": true, "untied": true, "alpha": 0.9}, v_da_356])])

func _f76(this_, a: Array, env):
	var v_l_375 = null
	v_l_375 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_375]), "width")

func _f77(this_, a: Array, env):
	var v_l_376 = null; var v_i_377 = null
	v_l_376 = J.arg(a, 0)
	v_i_377 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_376, J.add(env["bx"], 9.0), J.add(J.add(env["by"], 20.0), J.mul(v_i_377, 19.0))])

func _f75(this_, a: Array, env):
	var v_o_360 = null; var v_text_361 = null; var v_life_362 = null; var v_sc_363 = null; var v_h_364 = null; var v_x_365 = null; var v_y_366 = null; var v_maxW_367 = null; var v_lines_368 = null; var v_cur_369 = null; var v_w_370 = null; var v_hh_371 = null; var v_ch_374 = null
	var _s167 = {"__p": env, "ctx": null, "bx": null, "by": null}
	_s167["ctx"] = J.arg(a, 0)
	v_o_360 = J.arg(a, 1)
	v_text_361 = J.arg(a, 2)
	v_life_362 = J.arg(a, 3)
	v_sc_363 = J.mc(this_, "charScale", [J.gp(v_o_360, "y")])
	v_h_364 = (J.mul(58.0, v_sc_363) * (1.25 if J.seq(J.gp(v_o_360, "k"), "baiwu") else (0.85 if J.seq(J.gp(v_o_360, "k"), "xiaogui") else 1.0)))
	v_x_365 = J.mc(this_, "X", [J.gp(v_o_360, "x")])
	v_y_366 = (J.sub(J.mc(this_, "Y", [J.gp(v_o_360, "y")]), v_h_364) - 10.0)
	var _t369 = J.cmp(v_x_365, (-40.0), "<")
	if (_t369 if _t369 else J.cmp(v_x_365, J.add(J.gp(this_, "W"), 40.0), ">")):
		return null
	J.mc(_s167["ctx"], "save", [])
	var _t370 = _s167["ctx"]
	var _t371 = J.add("700 14px ", J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily"))
	J.sp(_t370, "font", _t371)
	v_maxW_367 = 172.0
	v_lines_368 = []
	v_cur_369 = ""
	for _t372 in J.iter(v_text_361):
		v_ch_374 = _t372
		var _t373 = J.cmp(J.gp(J.mc(_s167["ctx"], "measureText", [J.add(v_cur_369, v_ch_374)]), "width"), v_maxW_367, ">")
		if ((not J.t(J.mc("。，、！？；：」）…—", "includes", [v_ch_374]))) if _t373 else _t373):
			J.mc(v_lines_368, "push", [v_cur_369])
			v_cur_369 = v_ch_374
		else:
			var _t374 = J.add(v_cur_369, v_ch_374)
			v_cur_369 = _t374
	if J.t(v_cur_369):
		J.mc(v_lines_368, "push", [v_cur_369])
	v_w_370 = (J.max_(J.spread([J.SP(J.mc(v_lines_368, "map", [Callable(self, "_f76").bind(_s167)]))])) + 18.0)
	v_hh_371 = ((J.len(v_lines_368) * 19.0) + 12.0)
	_s167["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), v_w_370) - 6.0), J.sub(v_x_365, J.div(v_w_370, 2.0))])])
	_s167["by"] = J.max_([6.0, J.sub(v_y_366, v_hh_371)])
	var _t375 = _s167["ctx"]
	var _t376 = J.min_([1.0, J.mul(v_life_362, 3.0)])
	J.sp(_t375, "globalAlpha", _t376)
	J.mc(J.G.get("ART"), "rr", [_s167["ctx"], _s167["bx"], _s167["by"], v_w_370, v_hh_371, 9.0, "rgba(244,236,214,.96)", "#3a2a1a", 1.5])
	var _t377 = _s167["ctx"]
	J.sp(_t377, "fillStyle", "rgba(244,236,214,.96)")
	J.mc(_s167["ctx"], "beginPath", [])
	J.mc(_s167["ctx"], "moveTo", [(J.max_([J.add(_s167["bx"], 10.0), J.min_([J.sub(J.add(_s167["bx"], v_w_370), 10.0), v_x_365])]) - 6.0), J.sub(J.add(_s167["by"], v_hh_371), 1.0)])
	J.mc(_s167["ctx"], "lineTo", [v_x_365, J.add(J.add(_s167["by"], v_hh_371), 8.0)])
	J.mc(_s167["ctx"], "lineTo", [(J.max_([J.add(_s167["bx"], 10.0), J.min_([J.sub(J.add(_s167["bx"], v_w_370), 10.0), v_x_365])]) + 6.0), J.sub(J.add(_s167["by"], v_hh_371), 1.0)])
	J.mc(_s167["ctx"], "fill", [])
	var _t378 = _s167["ctx"]
	J.sp(_t378, "fillStyle", "#2a1a10")
	var _t379 = _s167["ctx"]
	J.sp(_t379, "textAlign", "left")
	var _t380 = _s167["ctx"]
	J.sp(_t380, "textBaseline", "alphabetic")
	J.mc(v_lines_368, "forEach", [Callable(self, "_f77").bind(_s167)])
	J.mc(_s167["ctx"], "restore", [])

func _f79(this_, a: Array, env):
	var v_k_386 = null
	v_k_386 = J.arg(a, 0)
	return ("<button class=\"gs-chip\" data-k=\"" + J.str(v_k_386) + "\">" + J.str(J.gp(J.gp(J.G.get("GS_STALLS"), v_k_386), "name")) + "</button>")

func _f81(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "goStall", [J.gp(J.gp(env["b"], "dataset"), "k")])

func _f80(this_, a: Array, env):
	var _s177 = {"__p": env, "b": null}
	_s177["b"] = J.arg(a, 0)
	var _t391 = _s177["b"]
	var _t392 = Callable(self, "_f81").bind(_s177)
	J.sp(_t391, "onclick", _t392)
	return _t392

func _f82(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t394 = J.seq(J.gp(env["v"], "k"), "haggle")
	if J.t((J.gp(env["v"], "sub") if _t394 else _t394)):
		var _t395 = env["v"]
		J.sp(_t395, "sub", null)
		J.mc(env["this"], "renderPanel", [])
		return null
	var _t396 = env["this"]
	var _t397 = {"k": "idle"}
	J.sp(_t396, "view", _t397)
	J.mc(env["this"], "relax", [])
	J.mc(env["this"], "renderPanel", [])

func _f78(this_, a: Array, env):
	var v_p_380 = null; var v_s_382 = null; var v_h_383 = null; var v_x_384 = null; var v_first_385 = null
	var _s173 = {"__p": env, "this": null, "v": null}
	_s173["this"] = this_
	var _t381 = J.G.get("$")
	v_p_380 = J.cl(_t381, null, ["#gs-panel"])
	if (not J.t(v_p_380)):
		return null
	_s173["v"] = J.gp(_s173["this"], "view")
	v_s_382 = J.mc(_s173["this"], "st", [])
	v_h_383 = ""
	if J.seq(J.gp(_s173["v"], "k"), "idle"):
		var _t382 = J.gp(v_s_382, "visits")
		v_first_385 = J.cmp((_t382 if J.t(_t382) else 0.0), 1.0, "<=")
		var _t384 = ("點地面走路，按住拖著，阿福會跟著走。點攤位直接光顧。" if J.t(v_first_385) else "想去哪一攤？")
		var _t383 = J.mc(J.G.get("GS_ORDER"), "map", [Callable(self, "_f79").bind(_s173)])
		var _t385 = ("<p class=\"gs-hint\">" + _t384 + "</p>\n        <div class=\"gs-chips\">" + J.str(J.mc(_t383, "join", [""])) + "</div>\n        " + (("<p class=\"gs-note\">肚子裡：" + J.str(J.gp(J.gp(J.G.get("GS_MEALS"), J.gp(v_s_382, "meal")), "name")) + "（下一場出征生效）</p>") if J.t(J.gp(v_s_382, "meal")) else ""))
		v_h_383 = _t385
	else:
		var _t388 = J.gp(J.gp(J.G.get("GS_STALLS"), J.gp(_s173["v"], "k")), "name")
		var _t386 = _s173["this"]
		var _t387 = J.add("html_", J.gp(_s173["v"], "k"))
		var _t389 = ("<div class=\"gs-ph\"><b>" + J.str(_t388) + "</b><button class=\"gs-x\" id=\"gs-x\" aria-label=\"離開\">離開</button></div><div class=\"gs-body\">" + J.str(J.mc(_t386, _t387, [])) + "</div>")
		v_h_383 = _t389
	J.sp(v_p_380, "innerHTML", v_h_383)
	var _t390 = J.mc(v_p_380, "querySelectorAll", [".gs-chip"])
	J.mc(_t390, "forEach", [Callable(self, "_f80").bind(_s173)])
	var _t393 = J.G.get("$")
	v_x_384 = J.cl(_t393, null, ["#gs-x"])
	if J.t(v_x_384):
		var _t398 = Callable(self, "_f82").bind(_s173)
		J.sp(v_x_384, "onclick", _t398)
	if (not J.seq(J.gp(_s173["v"], "k"), "idle")):
		var _t399 = _s173["this"]
		var _t400 = J.add("bind_", J.gp(_s173["v"], "k"))
		J.mc(_t399, _t400, [v_p_380])

func _f83(this_, a: Array, env):
	var v_k_390 = null; var v_kp_391 = null
	for _t401 in J.keys(J.gp(this_, "keepers")):
		v_k_390 = _t401
		v_kp_391 = J.gp(J.gp(this_, "keepers"), v_k_390)
		J.sp(v_kp_391, "hold", false)
		J.sp(v_kp_391, "pose", null)
		J.sp(v_kp_391, "poseT", 0.0)

func _f84(this_, a: Array, env):
	var v_k_394 = null; var v_pose_395 = null; var v_dur_396 = null; var v_hold_397 = null; var v_kp_398 = null
	v_k_394 = J.arg(a, 0)
	v_pose_395 = J.arg(a, 1)
	v_dur_396 = J.arg(a, 2)
	v_hold_397 = J.arg(a, 3)
	v_kp_398 = J.gp(J.gp(this_, "keepers"), v_k_394)
	if (not J.t(v_kp_398)):
		return null
	J.sp(v_kp_398, "pose", v_pose_395)
	J.sp(v_kp_398, "pt", 0.0)
	var _t402 = (v_dur_396 if J.t(v_dur_396) else 1.2)
	J.sp(v_kp_398, "poseT", _t402)
	var _t403 = (not (not J.t(v_hold_397)))
	J.sp(v_kp_398, "hold", _t403)

func _f85(this_, a: Array, env):
	var v_n_401 = null
	v_n_401 = J.arg(a, 0)
	var _t404 = J.gp(J.gp(J.G.get("S"), "res"), "coins")
	return J.cmp((_t404 if J.t(_t404) else 0.0), v_n_401, ">=")

func _f86(this_, a: Array, env):
	var v_n_404 = null
	v_n_404 = J.arg(a, 0)
	var _t405 = J.gp(J.G.get("S"), "res")
	var _t406 = J.sub(J.gp(_t405, "coins"), v_n_404)
	J.sp(_t405, "coins", _t406)
	J.mc(J.G.get("UI"), "refresh", [])

func _f88(this_, a: Array, env):
	var v_k_408 = null; var v_e_409 = null; var v_own_410 = null
	v_k_408 = J.arg(a, 0)
	v_e_409 = J.gp(J.G.get("GS_EFFIGY"), v_k_408)
	v_own_410 = J.gp(env["fx"], v_k_408)
	return ("<div class=\"gs-card " + ("own" if J.t(v_own_410) else "") + "\"><div class=\"gs-ci\"><b>" + J.str(J.gp(v_e_409, "name")) + "</b><small class=\"gs-eff\">" + J.str(J.gp(v_e_409, "eff")) + "</small><small>" + J.str(J.gp(v_e_409, "say")) + "</small></div>\n        <button class=\"btn " + ("ghost" if J.t(v_own_410) else "gold") + " sm gs-buy\" data-k=\"" + J.str(v_k_408) + "\" " + ("disabled" if J.t((v_own_410 if J.t(v_own_410) else (not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_e_409, "price")]))))) else "") + ">" + ("已燒" if J.t(v_own_410) else ("燒 " + J.str(J.gp(v_e_409, "price")))) + "</button></div>")

func _f87(this_, a: Array, env):
	var _s187 = {"__p": env, "this": null, "fx": null}
	_s187["this"] = this_
	_s187["fx"] = J.gp(J.mc(_s187["this"], "st", []), "fx")
	var _t407 = J.S_Object_("keys", [J.G.get("GS_EFFIGY")])
	var _t408 = J.mc(_t407, "map", [Callable(self, "_f88").bind(_s187)])
	return ("<p class=\"gs-line\"><b>小紙</b>燒了就是你的，永久有效。不退貨，因為已經燒了。</p><div class=\"gs-list\">" + J.str(J.mc(_t408, "join", [""])) + "</div>")

func _f91(this_, a: Array, env):
	var v_k_415 = null; var v_e_416 = null; var v_s_417 = null
	v_k_415 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_e_416 = J.gp(J.G.get("GS_EFFIGY"), v_k_415)
	v_s_417 = J.mc(env["__p"]["this"], "st", [])
	var _t411 = J.gp(J.gp(v_s_417, "fx"), v_k_415)
	if J.t((_t411 if J.t(_t411) else (not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_e_416, "price")]))))):
		return null
	J.mc(env["__p"]["this"], "spend", [J.gp(v_e_416, "price")])
	var _t412 = J.gp(v_s_417, "fx")
	J.sp(_t412, v_k_415, true)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("Sound"), "play", ["chest"])
	J.mc(env["__p"]["this"], "burn", [J.gp(J.gp(J.G.get("GS_STALLS"), "paper"), "x")])
	J.mc(env["__p"]["this"], "say", [J.gp(J.gp(env["__p"]["this"], "keepers"), "paper"), (J.add("燒好了！", J.gp(v_e_416, "eff")) + "。"), 3.0])
	J.mc(env["__p"]["this"], "keeperPose", ["paper", "cast", 1.2])
	J.mc(env["__p"]["this"], "float", [J.gp(J.gp(env["__p"]["this"], "afu"), "x"), J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16), (J.str(J.gp(v_e_416, "name")) + "  到手"), "#ffe08a"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f90(this_, a: Array, env):
	var _s190 = {"__p": env, "b": null}
	_s190["b"] = J.arg(a, 0)
	var _t410 = _s190["b"]
	var _t413 = Callable(self, "_f91").bind(_s190)
	J.sp(_t410, "onclick", _t413)
	return _t413

func _f89(this_, a: Array, env):
	var v_p_413 = null
	var _s189 = {"__p": env, "this": null}
	_s189["this"] = this_
	v_p_413 = J.arg(a, 0)
	var _t409 = J.mc(v_p_413, "querySelectorAll", [".gs-buy"])
	J.mc(_t409, "forEach", [Callable(self, "_f90").bind(_s189)])

func _f92(this_, a: Array, env):
	var v_fx_420 = null; var v_i_421 = null
	v_fx_420 = J.arg(a, 0)
	v_i_421 = 0.0
	while true:
		if not J.cmp(v_i_421, 22.0, "<"): break
		var _t414 = J.gp(this_, "parts")
		J.mc(_t414, "push", [{"kind": "joss", "x": J.add(v_fx_420, ((randf() - 0.5) * 0.06)), "y": 0.62, "bx": ((randf() - 0.5) * 0.04), "vx": 0.0, "vy": ((-0.08) - (randf() * 0.06)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 8.0), "flip": 0.0, "vf": 6.0, "sw": 2.0, "ph": (randf() * 6.0), "land": 2.0, "life": (2.0 + randf()), "max": 3.0}])
		v_i_421 = J.num(v_i_421) + 1.0

func _f94(this_, a: Array, env):
	var v___426 = null; var v_i_427 = null
	v___426 = J.arg(a, 0)
	v_i_427 = J.arg(a, 1)
	return v_i_427

func _f95(this_, a: Array, env):
	var v_a_428 = null; var v_b_429 = null
	v_a_428 = J.arg(a, 0)
	v_b_429 = J.arg(a, 1)
	var _t416 = J.G.get("gsRnd")
	var _t418 = J.cl(_t416, null, [J.add(J.mul(env["d"], 31.0), v_a_428)])
	var _t417 = J.G.get("gsRnd")
	return J.sub(_t418, J.cl(_t417, null, [J.add(J.mul(env["d"], 31.0), v_b_429)]))

func _f96(this_, a: Array, env):
	var v_i_430 = null
	v_i_430 = J.arg(a, 0)
	return J.gp(J.G.get("GS_ITEMS"), v_i_430)

func _f93(this_, a: Array, env):
	var v_idx_425 = null
	var _s194 = {"__p": env, "d": null}
	_s194["d"] = J.cl(J.G.get("gsDay"), null, [])
	var _t415 = J.mc(J.G.get("GS_ITEMS"), "map", [Callable(self, "_f94").bind(_s194)])
	v_idx_425 = J.mc(_t415, "sort", [Callable(self, "_f95").bind(_s194)])
	var _t419 = J.mc(v_idx_425, "slice", [0.0, 3.0])
	return J.mc(_t419, "map", [Callable(self, "_f96").bind(_s194)])

func _f97(this_, a: Array, env):
	var v_it_433 = null
	v_it_433 = J.arg(a, 0)
	var _t421 = J.gp(v_it_433, "col")
	var _t420 = J.G.get("gsRnd")
	return J.round(J.num(J.mul(_t421, (0.5 + J.mul(0.35, J.cl(_t420, null, [((J.mul(J.cl(J.G.get("gsDay"), null, []), 977.0) + J.mul(J.gp(v_it_433, "col"), 13.0)) + J.len(J.gp(v_it_433, "id")))]))))))

func _f98(this_, a: Array, env):
	var v_it_436 = null
	v_it_436 = J.arg(a, 0)
	return J.round(J.num(J.mul(J.gp(v_it_436, "col"), 1.15)))

func _f100(this_, a: Array, env):
	var v_it_448 = null; var v_st_449 = null
	v_it_448 = J.arg(a, 0)
	v_st_449 = J.gp(J.gp(env["h"], "done"), J.gp(v_it_448, "id"))
	return ("<button class=\"gs-card gs-item " + ("own" if J.t(v_st_449) else "") + "\" data-id=\"" + J.str(J.gp(v_it_448, "id")) + "\" " + ("disabled" if J.t(v_st_449) else "") + "><div class=\"gs-ci\"><b>" + J.str(J.gp(v_it_448, "name")) + "</b><small>" + J.str(J.gp(v_it_448, "desc")) + "</small><small class=\"gs-eff\">標價 " + J.str(J.mc(env["this"], "askOf", [v_it_448])) + "　收藏家收購 " + J.str(J.gp(v_it_448, "col")) + "</small></div><em>" + ("已買" if J.seq(v_st_449, "bought") else ("收起來了" if J.seq(v_st_449, "shelved") else "講價")) + "</em></button>")

func _f101(this_, a: Array, env):
	var v_i_450 = null
	v_i_450 = J.arg(a, 0)
	return J.seq(J.gp(v_i_450, "id"), J.gp(env["v"], "sub"))

func _f102(this_, a: Array, env):
	var v_m_451 = null; var v_i_452 = null
	v_m_451 = J.arg(a, 0)
	v_i_452 = J.arg(a, 1)
	return ("<i class=\"" + ("on" if J.seq(v_i_452, env["lv"]) else "") + "\" style=\"--c:" + J.str(J.gp(["#e2483a", "#d07a3a", "#d8b84a", "#9ad05a", "#5ad0a0"], v_i_452)) + "\">" + J.str(v_m_451) + "</i>")

func _f99(this_, a: Array, env):
	var v_it_441 = null; var v_tries_442 = null; var v_ask_443 = null; var v_last_444 = null; var v_offer_445 = null; var v_mood_447 = null
	var _s200 = {"__p": env, "this": null, "h": null, "v": null, "lv": null}
	_s200["this"] = this_
	_s200["h"] = J.gp(J.mc(_s200["this"], "st", []), "hag")
	_s200["v"] = J.gp(_s200["this"], "view")
	if J.t(J.gp(_s200["h"], "out")):
		return ("<p class=\"gs-line bad\"><b>小鬼</b>還敢回來？今晚不做你生意！明天請早。</p><p class=\"gs-note\">你今晚侮辱了小鬼三次，被轟了出去。明天再來。</p>")
	if (not J.t(J.gp(_s200["v"], "sub"))):
		var _t424 = ("看中哪件就出價。開太低，我會翻臉。" if J.t(J.mod(J.gp(J.mc(_s200["this"], "st", []), "visits"), 2.0)) else "我的貨都是古董，你的出價最好也是。")
		var _t422 = J.mc(_s200["this"], "todayItems", [])
		var _t423 = J.mc(_t422, "map", [Callable(self, "_f100").bind(_s200)])
		return ("<p class=\"gs-line\"><b>小鬼</b>" + _t424 + "</p>\n        <p class=\"gs-note\">收藏家會照「收購價」收走你買到的東西。買得越便宜，賺得越多。小鬼心裡有底價，看他臉色推算。每件最多出價三次；侮辱他三次會被轟走。</p>\n        <div class=\"gs-list\">" + J.str(J.mc(_t423, "join", [""])) + "</div>\n        <p class=\"gs-note\">侮辱 " + J.str(J.gp(_s200["h"], "strikes")) + "/3</p>")
	v_it_441 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f101").bind(_s200)])
	var _t425 = J.gp(J.gp(_s200["h"], "tries"), J.gp(v_it_441, "id"))
	v_tries_442 = (_t425 if J.t(_t425) else 0.0)
	v_ask_443 = J.mc(_s200["this"], "askOf", [v_it_441])
	v_last_444 = J.gp(_s200["v"], "last")
	var _t426 = J.gp(_s200["v"], "offer")
	v_offer_445 = (_t426 if J.t(_t426) else J.round(J.num(J.mul(J.gp(v_it_441, "col"), 0.6))))
	_s200["lv"] = ((J.gp(J.gp(v_last_444, "band"), "lv") if J.t(J.gp(v_last_444, "band")) else 4.0) if J.t(v_last_444) else (-1.0))
	v_mood_447 = ((J.gp(J.gp(v_last_444, "band"), "mood") if J.t(J.gp(v_last_444, "band")) else "成交") if J.t(v_last_444) else "打量你")
	var _t429 = J.gp(v_it_441, "name")
	var _t430 = J.gp(v_it_441, "desc")
	var _t431 = J.gp(v_it_441, "col")
	var _t432 = ("bad" if J.seq(_s200["lv"], 0.0) else "")
	var _t433 = (J.gp(v_last_444, "line") if J.t(v_last_444) else "出個價來聽聽。")
	var _t427 = ["翻臉", "很臭", "猶豫", "肉痛", "成交"]
	var _t428 = J.mc(_t427, "map", [Callable(self, "_f102").bind(_s200)])
	return ("<div class=\"gs-hag\"><b class=\"gs-iname\">" + J.str(_t429) + "</b><small>" + J.str(_t430) + "</small>\n      <div class=\"gs-prices\"><span>標價 <b>" + J.str(v_ask_443) + "</b></span><span>收藏家收購 <b>" + J.str(_t431) + "</b></span></div>\n      <p class=\"gs-line " + _t432 + "\"><b>小鬼</b>" + J.str(_t433) + "</p>\n      <div class=\"gs-mood\"><span>臉色</span>" + J.str(J.mc(_t428, "join", [""])) + "<em>" + J.str(v_mood_447) + "</em></div>\n      " + ("" if J.t(J.gp(_s200["v"], "closed")) else ("<div class=\"gs-offer\"><button class=\"btn sm\" id=\"gs-m\">−5</button><input type=\"range\" id=\"gs-r\" min=\"5\" max=\"" + J.str(v_ask_443) + "\" step=\"1\" value=\"" + J.str(v_offer_445) + "\"><button class=\"btn sm\" id=\"gs-p\">+5</button></div>\n      <button class=\"btn gold wide\" id=\"gs-go\" " + ("" if J.t(J.mc(_s200["this"], "coinsOk", [v_offer_445])) else "disabled") + ">出價 <span id=\"gs-ov\">" + J.str(v_offer_445) + "</span> 冥幣</button>")) + "\n      <p class=\"gs-note\">第 " + J.str(J.min_([3.0, J.add(v_tries_442, (0.0 if J.t(J.gp(_s200["v"], "closed")) else 1.0))])) + "/3 次出價　侮辱 " + J.str(J.gp(_s200["h"], "strikes")) + "/3" + ("" if J.t(J.gp(_s200["v"], "closed")) else ("" if J.t(J.mc(_s200["this"], "coinsOk", [v_offer_445])) else "　（冥幣不夠）")) + "</p>\n      " + (("<button class=\"btn wide\" id=\"gs-back2\">看別的貨</button>") if J.t(J.gp(_s200["v"], "closed")) else "") + "</div>")

func _f105(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t436 = env["__p"]["v"]
	var _t437 = J.gp(J.gp(env["b"], "dataset"), "id")
	J.sp(_t436, "sub", _t437)
	var _t438 = env["__p"]["v"]
	J.sp(_t438, "last", null)
	var _t439 = env["__p"]["v"]
	J.sp(_t439, "closed", false)
	var _t440 = env["__p"]["v"]
	J.sp(_t440, "offer", null)
	J.mc(env["__p"]["this"], "renderPanel", [])
	J.mc(env["__p"]["this"], "keeperPose", ["haggle", null, 0.0])

func _f104(this_, a: Array, env):
	var _s206 = {"__p": env, "b": null}
	_s206["b"] = J.arg(a, 0)
	var _t435 = _s206["b"]
	var _t441 = Callable(self, "_f105").bind(_s206)
	J.sp(_t435, "onclick", _t441)
	return _t441

func _f106(this_, a: Array, env):
	var _t443 = env["v"]
	J.sp(_t443, "sub", null)
	var _t444 = env["v"]
	J.sp(_t444, "closed", false)
	var _t445 = env["v"]
	J.sp(_t445, "last", null)
	J.mc(env["this"], "renderPanel", [])

func _f108(this_, a: Array, env):
	var v_i_464 = null
	v_i_464 = J.arg(a, 0)
	return J.seq(J.gp(v_i_464, "id"), J.gp(env["v"], "sub"))

func _f107(this_, a: Array, env):
	var v_n_462 = null; var v_it_463 = null
	v_n_462 = J.arg(a, 0)
	v_it_463 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f108").bind(env)])
	var _t448 = J.max_([5.0, J.min_([J.mc(env["this"], "askOf", [v_it_463]), v_n_462])])
	v_n_462 = _t448
	var _t449 = env["v"]
	J.sp(_t449, "offer", v_n_462)
	var _t450 = env["r"]
	J.sp(_t450, "value", v_n_462)
	var _t451 = J.G.get("$")
	var _t452 = J.cl(_t451, null, ["#gs-ov"])
	J.sp(_t452, "textContent", v_n_462)
	var _t453 = J.G.get("$")
	var _t454 = J.cl(_t453, null, ["#gs-go"])
	var _t455 = (not J.t(J.mc(env["this"], "coinsOk", [v_n_462])))
	J.sp(_t454, "disabled", _t455)

func _f109(this_, a: Array, env):
	var _t457 = env["set"]
	return J.cl(_t457, null, [J.num(J.gp(env["r"], "value"))])

func _f110(this_, a: Array, env):
	var _t461 = env["set"]
	return J.cl(_t461, null, [(J.num(J.gp(env["r"], "value")) - 5.0)])

func _f111(this_, a: Array, env):
	var _t465 = env["set"]
	return J.cl(_t465, null, [(J.num(J.gp(env["r"], "value")) + 5.0)])

func _f112(this_, a: Array, env):
	return J.mc(env["this"], "offer", [J.num(J.gp(env["r"], "value"))])

func _f103(this_, a: Array, env):
	var v_p_455 = null; var v_h_457 = null; var v_b2_458 = null
	var _s205 = {"__p": env, "this": null, "v": null, "r": null, "set": null}
	_s205["this"] = this_
	v_p_455 = J.arg(a, 0)
	_s205["v"] = J.gp(_s205["this"], "view")
	v_h_457 = J.gp(J.mc(_s205["this"], "st", []), "hag")
	var _t434 = J.mc(v_p_455, "querySelectorAll", [".gs-item"])
	J.mc(_t434, "forEach", [Callable(self, "_f104").bind(_s205)])
	var _t442 = J.G.get("$")
	v_b2_458 = J.cl(_t442, null, ["#gs-back2"])
	if J.t(v_b2_458):
		var _t446 = Callable(self, "_f106").bind(_s205)
		J.sp(v_b2_458, "onclick", _t446)
	var _t447 = J.G.get("$")
	_s205["r"] = J.cl(_t447, null, ["#gs-r"])
	if (not J.t(_s205["r"])):
		return null
	_s205["set"] = Callable(self, "_f107").bind(_s205)
	var _t456 = _s205["r"]
	var _t458 = Callable(self, "_f109").bind(_s205)
	J.sp(_t456, "oninput", _t458)
	var _t459 = J.G.get("$")
	var _t460 = J.cl(_t459, null, ["#gs-m"])
	var _t462 = Callable(self, "_f110").bind(_s205)
	J.sp(_t460, "onclick", _t462)
	var _t463 = J.G.get("$")
	var _t464 = J.cl(_t463, null, ["#gs-p"])
	var _t466 = Callable(self, "_f111").bind(_s205)
	J.sp(_t464, "onclick", _t466)
	var _t467 = J.G.get("$")
	var _t468 = J.cl(_t467, null, ["#gs-go"])
	var _t469 = Callable(self, "_f112").bind(_s205)
	J.sp(_t468, "onclick", _t469)

func _f114(this_, a: Array, env):
	var v_i_475 = null
	v_i_475 = J.arg(a, 0)
	return J.seq(J.gp(v_i_475, "id"), J.gp(env["v"], "sub"))

func _f115(this_, a: Array, env):
	var v_b_478 = null
	v_b_478 = J.arg(a, 0)
	return J.cmp(env["r"], J.gp(v_b_478, "max"), "<")

func _f113(this_, a: Array, env):
	var v_n_467 = null; var v_s_469 = null; var v_h_470 = null; var v_it_471 = null; var v_floor_472 = null; var v_tries_474 = null; var v_fat_476 = null; var v_band_477 = null
	var _s215 = {"__p": env, "v": null, "r": null}
	v_n_467 = J.arg(a, 0)
	_s215["v"] = J.gp(this_, "view")
	v_s_469 = J.mc(this_, "st", [])
	v_h_470 = J.gp(v_s_469, "hag")
	v_it_471 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f114").bind(_s215)])
	var _t470 = (not J.t(v_it_471))
	var _t471 = (_t470 if _t470 else J.gp(J.gp(v_h_470, "done"), J.gp(v_it_471, "id")))
	var _t472 = (_t471 if J.t(_t471) else J.gp(v_h_470, "out"))
	if J.t((_t472 if J.t(_t472) else (not J.t(J.mc(this_, "coinsOk", [v_n_467]))))):
		return null
	v_floor_472 = J.mc(this_, "floorOf", [v_it_471])
	_s215["r"] = J.div(v_n_467, v_floor_472)
	var _t473 = J.gp(v_h_470, "tries")
	var _t474 = J.gp(v_it_471, "id")
	var _t475 = J.gp(J.gp(v_h_470, "tries"), J.gp(v_it_471, "id"))
	var _t476 = J.add((_t475 if J.t(_t475) else 0.0), 1.0)
	J.sp(_t473, _t474, _t476)
	v_tries_474 = J.gp(J.gp(v_h_470, "tries"), J.gp(v_it_471, "id"))
	var _t477 = _s215["v"]
	J.sp(_t477, "offer", v_n_467)
	if J.cmp(_s215["r"], 1.0, ">="):
		J.mc(this_, "spend", [v_n_467])
		var _t478 = J.gp(J.G.get("S"), "res")
		var _t479 = J.add(J.gp(_t478, "coins"), J.gp(v_it_471, "col"))
		J.sp(_t478, "coins", _t479)
		var _t480 = J.gp(v_h_470, "done")
		var _t481 = J.gp(v_it_471, "id")
		J.sp(_t480, _t481, "bought")
		var _t482 = J.gp(v_s_469, "curios")
		J.mc(_t482, "push", [J.gp(v_it_471, "id")])
		if (J.len(J.gp(v_s_469, "curios")) > 40.0):
			J.mc(J.gp(v_s_469, "curios"), "shift", [])
		v_fat_476 = J.cmp(_s215["r"], 1.08, ">=")
		var _t483 = _s215["v"]
		var _t484 = J.G.get("pick")
		var _t485 = {"band": null, "line": J.add(J.cl(_t484, null, [(J.G.get("GS_DEAL_FAT") if J.t(v_fat_476) else J.G.get("GS_DEAL_TIGHT"))]), ("（收藏家用 " + J.str(J.gp(v_it_471, "col")) + " 收走了，你" + ("賺" if (J.sub(J.gp(v_it_471, "col"), v_n_467) >= 0.0) else "虧") + "了 " + J.str(absf(J.num(J.sub(J.gp(v_it_471, "col"), v_n_467)))) + "）"))}
		J.sp(_t483, "last", _t485)
		var _t486 = _s215["v"]
		J.sp(_t486, "closed", true)
		J.mc(this_, "keeperPose", ["haggle", "cast", 1.6])
		var _t487 = J.gp(this_, "afu")
		J.sp(_t487, "pose", "cast")
		var _t488 = J.gp(this_, "afu")
		J.sp(_t488, "poseT", 1.0)
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), (("+" if (J.sub(J.gp(v_it_471, "col"), v_n_467) >= 0.0) else "−") + J.str(absf(J.num(J.sub(J.gp(v_it_471, "col"), v_n_467)))) + " 冥幣"), ("#ffe08a" if (J.sub(J.gp(v_it_471, "col"), v_n_467) >= 0.0) else "#ff9a8a")])
		J.mc(J.G.get("Sound"), "play", ["coin"])
	else:
		v_band_477 = J.mc(J.G.get("GS_BANDS"), "find", [Callable(self, "_f115").bind(_s215)])
		var _t489 = _s215["v"]
		var _t490 = {"band": v_band_477, "line": J.gp(J.gp(v_band_477, "lines"), J.mod(J.sub(v_tries_474, 1.0), J.len(J.gp(v_band_477, "lines"))))}
		J.sp(_t489, "last", _t490)
		J.mc(this_, "keeperPose", ["haggle", (null if J.seq(J.gp(v_band_477, "pose"), "idle") else J.gp(v_band_477, "pose")), 2.4, true])
		if J.seq(J.gp(v_band_477, "lv"), 0.0):
			J.sp(v_h_470, "strikes", J.num(J.gp(v_h_470, "strikes")) + 1.0)
			J.mc(J.G.get("Sound"), "play", ["hit"])
		else:
			J.mc(J.G.get("Sound"), "play", ["paper"])
		if J.cmp(J.gp(v_h_470, "strikes"), 3.0, ">="):
			J.sp(v_h_470, "out", true)
			var _t491 = J.gp(_s215["v"], "last")
			J.sp(_t491, "line", "三次侮辱我？給我滾！今晚別再來！")
			var _t492 = this_
			J.sp(_t492, "kick", 1.1)
			J.mc(this_, "say", [J.gp(J.gp(this_, "keepers"), "haggle"), "滾！", 2.0])
			var _t493 = J.gp(this_, "afu")
			J.sp(_t493, "pose", "hurt")
			J.mc(J.G.get("Sound"), "play", ["whoosh"])
		else:
			if J.cmp(v_tries_474, 3.0, ">="):
				var _t494 = J.gp(v_h_470, "done")
				var _t495 = J.gp(v_it_471, "id")
				J.sp(_t494, _t495, "shelved")
				var _t496 = J.gp(_s215["v"], "last")
				var _t497 = J.add(J.gp(_t496, "line"), "……三次都談不攏，這件我收起來了！")
				J.sp(_t496, "line", _t497)
				var _t498 = _s215["v"]
				J.sp(_t498, "closed", true)
		var _t501 = J.gp(J.gp(this_, "keepers"), "haggle")
		var _t500 = null
		if (J.len(J.gp(J.gp(_s215["v"], "last"), "line")) > 22.0):
			var _t499 = J.gp(J.gp(_s215["v"], "last"), "line")
			_t500 = J.add(J.mc(_t499, "slice", [0.0, 20.0]), "……")
		else:
			_t500 = J.gp(J.gp(_s215["v"], "last"), "line")
		J.mc(this_, "say", [_t501, _t500, 2.4])
	J.cl(J.G.get("save"), null, [])
	J.mc(this_, "renderPanel", [])

func _f116(this_, a: Array, env):
	var v_d_481 = null; var v_v_482 = null
	v_d_481 = J.arg(a, 0)
	var _t503 = ((1.0 + (0.16 * sin(J.num(J.mul(v_d_481, 0.5))))) + (0.05 * sin(J.num((J.mul(v_d_481, 1.9) + 1.3)))))
	var _t502 = J.G.get("gsRnd")
	v_v_482 = (100.0 * (_t503 + (0.06 * J.sub(J.cl(_t502, null, [(J.mul(v_d_481, 7.0) + 3.0)]), 0.5))))
	return J.max_([30.0, J.round(J.num(v_v_482))])

func _f117(this_, a: Array, env):
	var v_d_485 = null; var v_p_486 = null; var v_y_487 = null; var v_ch_488 = null; var v_up_489 = null; var v_st_490 = null; var v_news_491 = null; var v_val_492 = null; var v_pl_493 = null
	v_d_485 = J.cl(J.G.get("gsDay"), null, [])
	v_p_486 = J.mc(this_, "price", [v_d_485])
	v_y_487 = J.mc(this_, "price", [J.sub(v_d_485, 1.0)])
	v_ch_488 = (J.div(J.sub(v_p_486, v_y_487), v_y_487) * 100.0)
	v_up_489 = J.cmp(J.mc(this_, "price", [J.add(v_d_485, 1.0)]), v_p_486, ">=")
	v_st_490 = J.gp(J.mc(this_, "st", []), "stock")
	var _t505 = (J.G.get("GS_NEWS_UP") if J.t(v_up_489) else J.G.get("GS_NEWS_DN"))
	var _t504 = J.G.get("gsRnd")
	v_news_491 = J.gp(_t505, floor(J.num(J.mul(J.cl(_t504, null, [(J.mul(v_d_485, 5.0) + 1.0)]), 5.0))))
	v_val_492 = J.mul(J.gp(v_st_490, "n"), v_p_486)
	v_pl_493 = (J.sub(v_val_492, J.gp(v_st_490, "cost")) if J.t(J.gp(v_st_490, "n")) else 0.0)
	var _t507 = ("up" if J.cmp(v_ch_488, 0.0, ">=") else "dn")
	var _t508 = ("▲" if J.cmp(v_ch_488, 0.0, ">=") else "▼")
	var _t506 = absf(J.num(v_ch_488))
	var _t510 = J.mc(_t506, "toFixed", [1.0])
	var _t511 = J.gp(v_st_490, "n")
	var _t512 = J.G.get("GS_SHARE_CAP")
	var _t509 = J.G.get("fmt")
	var _t517 = J.cl(_t509, null, [v_val_492])
	var _t516 = null
	if J.t(J.gp(v_st_490, "n")):
		var _t514 = ("up" if J.cmp(v_pl_493, 0.0, ">=") else "dn")
		var _t515 = ("賺" if J.cmp(v_pl_493, 0.0, ">=") else "虧")
		var _t513 = J.G.get("fmt")
		_t516 = ("<span class=\"" + _t514 + "\">" + _t515 + " " + J.str(J.cl(_t513, null, [absf(J.num(v_pl_493))])) + "</span>")
	else:
		_t516 = ""
	return ("<p class=\"gs-line\"><b>白無常</b>一見生財！小道消息：「" + J.str(v_news_491) + "」</p>\n      <div class=\"gs-stock\"><div><small>地府科技（今日）</small><b class=\"gs-px\">" + J.str(v_p_486) + "</b><em class=\"" + _t507 + "\">" + _t508 + " " + J.str(_t510) + "%</em></div><canvas id=\"gs-chart\"></canvas></div>\n      <p class=\"gs-note\">持有 " + J.str(_t511) + " 股（上限 " + J.str(_t512) + "）　市值 " + J.str(_t517) + "　" + _t516 + "　手續費 " + J.str(J.mul(J.G.get("GS_FEE"), 100.0)) + "%（買賣都收）</p>\n      <div class=\"gs-trade\"><button class=\"btn sm gs-t\" data-q=\"1\">買 1</button><button class=\"btn sm gs-t\" data-q=\"10\">買 10</button><button class=\"btn sm gs-t\" data-q=\"-1\">賣 1</button><button class=\"btn sm gs-t\" data-q=\"-10\">賣 10</button><button class=\"btn sm gs-t\" data-q=\"-999\">全賣</button></div>\n      <p class=\"gs-note dim\">價格每天換一次。白無常的小道消息說的是「明天」，他從來沒說錯過——只是不保證漲多少。</p>")

func _f120(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "trade", [env["q"]])

func _f119(this_, a: Array, env):
	var v_b_497 = null; var v_px_499 = null; var v_st_500 = null
	var _s226 = {"__p": env, "q": null}
	v_b_497 = J.arg(a, 0)
	_s226["q"] = J.num(J.gp(J.gp(v_b_497, "dataset"), "q"))
	v_px_499 = J.mc(_s226["__p"]["this"], "price", [J.cl(J.G.get("gsDay"), null, [])])
	v_st_500 = J.gp(J.mc(_s226["__p"]["this"], "st", []), "stock")
	if J.cmp(_s226["q"], 0.0, ">"):
		var _t519 = J.cmp(J.gp(v_st_500, "n"), J.G.get("GS_SHARE_CAP"), ">=")
		var _t520 = (_t519 if _t519 else (not J.t(J.mc(_s226["__p"]["this"], "coinsOk", [ceil(J.num(J.mul(J.mul(v_px_499, J.min_([_s226["q"], J.sub(J.G.get("GS_SHARE_CAP"), J.gp(v_st_500, "n"))])), J.add(1.0, J.G.get("GS_FEE")))))]))))
		J.sp(v_b_497, "disabled", _t520)
	else:
		var _t521 = J.cmp(J.gp(v_st_500, "n"), 0.0, "<=")
		J.sp(v_b_497, "disabled", _t521)
	var _t522 = Callable(self, "_f120").bind(_s226)
	J.sp(v_b_497, "onclick", _t522)

func _f118(this_, a: Array, env):
	var v_p_496 = null
	var _s225 = {"__p": env, "this": null}
	_s225["this"] = this_
	v_p_496 = J.arg(a, 0)
	var _t518 = J.mc(v_p_496, "querySelectorAll", [".gs-t"])
	J.mc(_t518, "forEach", [Callable(self, "_f119").bind(_s225)])
	J.mc(_s225["this"], "drawChart", [])

func _f121(this_, a: Array, env):
	var v_q_503 = null; var v_s_504 = null; var v_st_505 = null; var v_px_506 = null; var v_cost_507 = null; var v_got_508 = null; var v_basis_509 = null
	v_q_503 = J.arg(a, 0)
	v_s_504 = J.mc(this_, "st", [])
	v_st_505 = J.gp(v_s_504, "stock")
	v_px_506 = J.mc(this_, "price", [J.cl(J.G.get("gsDay"), null, [])])
	if J.cmp(v_q_503, 0.0, ">"):
		var _t523 = J.min_([v_q_503, J.sub(J.G.get("GS_SHARE_CAP"), J.gp(v_st_505, "n"))])
		v_q_503 = _t523
		v_cost_507 = ceil(J.num(J.mul(J.mul(v_px_506, v_q_503), J.add(1.0, J.G.get("GS_FEE")))))
		var _t524 = J.cmp(v_q_503, 0.0, "<=")
		if (_t524 if _t524 else (not J.t(J.mc(this_, "coinsOk", [v_cost_507])))):
			return null
		J.mc(this_, "spend", [v_cost_507])
		var _t525 = J.add(J.gp(v_st_505, "n"), v_q_503)
		J.sp(v_st_505, "n", _t525)
		var _t526 = J.add(J.gp(v_st_505, "cost"), v_cost_507)
		J.sp(v_st_505, "cost", _t526)
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), ("買入 " + J.str(v_q_503) + " 股"), "#bfe8ff"])
		var _t528 = J.gp(J.gp(this_, "keepers"), "exch")
		var _t527 = J.G.get("pick")
		J.mc(this_, "say", [_t528, J.cl(_t527, null, [["一見生財！有眼光！", "買定離手～", "恭喜發財，虧了別找我。"]]), 2.4])
	else:
		var _t529 = J.min_([(-J.num(v_q_503)), J.gp(v_st_505, "n")])
		v_q_503 = _t529
		if J.cmp(v_q_503, 0.0, "<="):
			return null
		v_got_508 = floor(J.num((J.mul(v_px_506, v_q_503) * J.sub(1.0, J.G.get("GS_FEE")))))
		v_basis_509 = J.div(J.mul(J.gp(v_st_505, "cost"), v_q_503), J.gp(v_st_505, "n"))
		var _t530 = J.sub(J.gp(v_st_505, "cost"), v_basis_509)
		J.sp(v_st_505, "cost", _t530)
		var _t531 = J.sub(J.gp(v_st_505, "n"), v_q_503)
		J.sp(v_st_505, "n", _t531)
		var _t532 = J.gp(J.G.get("S"), "res")
		var _t533 = J.add(J.gp(_t532, "coins"), v_got_508)
		J.sp(_t532, "coins", _t533)
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), ("賣出 +" + J.str(v_got_508)), ("#ffe08a" if J.cmp(v_got_508, v_basis_509, ">=") else "#ff9a8a")])
		J.mc(this_, "say", [J.gp(J.gp(this_, "keepers"), "exch"), ("一見生財！賺到了吧～" if J.cmp(v_got_508, v_basis_509, ">=") else "虧了？陰間也有韭菜的。"), 2.4])
	if J.seq(J.gp(v_st_505, "n"), 0.0):
		J.sp(v_st_505, "cost", 0.0)
	J.mc(this_, "keeperPose", ["exch", "cast", 1.0])
	J.mc(J.G.get("Sound"), "play", ["coin"])
	J.cl(J.G.get("save"), null, [])
	J.mc(this_, "renderPanel", [])

func _f123(this_, a: Array, env):
	var v___524 = null; var v_i_525 = null
	v___524 = J.arg(a, 0)
	v_i_525 = J.arg(a, 1)
	return J.mc(env["this"], "price", [J.add(J.sub(env["d"], 6.0), v_i_525)])

func _f124(this_, a: Array, env):
	var v_i_526 = null
	v_i_526 = J.arg(a, 0)
	return (10.0 + J.div(J.mul(v_i_526, J.sub(env["w"], 20.0)), 6.0))

func _f125(this_, a: Array, env):
	var v_v_527 = null
	v_v_527 = J.arg(a, 0)
	return (J.sub(env["h"], 16.0) - (J.div(J.sub(v_v_527, env["lo"]), J.sub(env["hi"], env["lo"])) * J.sub(env["h"], 28.0)))

func _f126(this_, a: Array, env):
	var v_v_530 = null; var v_i_531 = null
	v_v_530 = J.arg(a, 0)
	v_i_531 = J.arg(a, 1)
	var _t551 = null
	if J.t(v_i_531):
		var _t545 = env["X"]
		var _t547 = J.cl(_t545, null, [v_i_531])
		var _t546 = env["Y"]
		_t551 = J.mc(env["ctx"], "lineTo", [_t547, J.cl(_t546, null, [v_v_530])])
	else:
		var _t548 = env["X"]
		var _t550 = J.cl(_t548, null, [v_i_531])
		var _t549 = env["Y"]
		_t551 = J.mc(env["ctx"], "moveTo", [_t550, J.cl(_t549, null, [v_v_530])])
	return _t551

func _f127(this_, a: Array, env):
	var v_v_532 = null; var v_i_533 = null
	v_v_532 = J.arg(a, 0)
	v_i_533 = J.arg(a, 1)
	var _t552 = env["ctx"]
	var _t553 = ("#ffcf6a" if J.seq(v_i_533, 6.0) else "#9be8b0")
	J.sp(_t552, "fillStyle", _t553)
	J.mc(env["ctx"], "beginPath", [])
	var _t554 = env["X"]
	var _t556 = J.cl(_t554, null, [v_i_533])
	var _t555 = env["Y"]
	J.mc(env["ctx"], "arc", [_t556, J.cl(_t555, null, [v_v_532]), (4.5 if J.seq(v_i_533, 6.0) else 2.6), 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])

func _f128(this_, a: Array, env):
	var v_l_534 = null; var v_i_535 = null
	v_l_534 = J.arg(a, 0)
	v_i_535 = J.arg(a, 1)
	if (not J.t(v_l_534)):
		return null
	var _t560 = env["ctx"]
	var _t561 = ("left" if J.seq(v_i_535, 0.0) else ("right" if J.seq(v_i_535, 6.0) else "center"))
	J.sp(_t560, "textAlign", _t561)
	var _t564 = null
	if J.seq(v_i_535, 0.0):
		_t564 = 2.0
	else:
		var _t563 = null
		if J.seq(v_i_535, 6.0):
			_t563 = J.sub(env["w"], 2.0)
		else:
			var _t562 = env["X"]
			_t563 = J.cl(_t562, null, [v_i_535])
		_t564 = _t563
	J.mc(env["ctx"], "fillText", [v_l_534, _t564, J.sub(env["h"], 2.0)])

func _f122(this_, a: Array, env):
	var v_c_512 = null; var v_r_513 = null; var v_dpr_514 = null; var v_ps_519 = null; var v_i_528 = null; var v_y_529 = null
	var _s231 = {"__p": env, "this": null, "w": null, "h": null, "ctx": null, "d": null, "lo": null, "hi": null, "X": null, "Y": null}
	_s231["this"] = this_
	var _t534 = J.G.get("$")
	v_c_512 = J.cl(_t534, null, ["#gs-chart"])
	if (not J.t(v_c_512)):
		return null
	v_r_513 = J.mc(v_c_512, "getBoundingClientRect", [])
	var _t535 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t536 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_514 = J.min_([2.0, (_t536 if J.t(_t536) else 1.0)])
	var _t537 = J.gp(v_r_513, "width")
	_s231["w"] = (_t537 if J.t(_t537) else 200.0)
	var _t538 = J.gp(v_r_513, "height")
	_s231["h"] = (_t538 if J.t(_t538) else 84.0)
	var _t539 = J.mul(_s231["w"], v_dpr_514)
	J.sp(v_c_512, "width", _t539)
	var _t540 = J.mul(_s231["h"], v_dpr_514)
	J.sp(v_c_512, "height", _t540)
	_s231["ctx"] = J.mc(v_c_512, "getContext", ["2d"])
	J.mc(_s231["ctx"], "scale", [v_dpr_514, v_dpr_514])
	_s231["d"] = J.cl(J.G.get("gsDay"), null, [])
	v_ps_519 = J.S_Array_("from", [{"length": 7.0}, Callable(self, "_f123").bind(_s231)])
	_s231["lo"] = (J.min_(J.spread([J.SP(v_ps_519)])) * 0.95)
	_s231["hi"] = (J.max_(J.spread([J.SP(v_ps_519)])) * 1.05)
	_s231["X"] = Callable(self, "_f124").bind(_s231)
	_s231["Y"] = Callable(self, "_f125").bind(_s231)
	var _t541 = _s231["ctx"]
	J.sp(_t541, "strokeStyle", "rgba(255,255,255,.12)")
	var _t542 = _s231["ctx"]
	J.sp(_t542, "lineWidth", 1.0)
	v_i_528 = 0.0
	while true:
		if not J.cmp(v_i_528, 3.0, "<"): break
		v_y_529 = (8.0 + J.div(J.mul(v_i_528, J.sub(_s231["h"], 24.0)), 2.0))
		J.mc(_s231["ctx"], "beginPath", [])
		J.mc(_s231["ctx"], "moveTo", [4.0, v_y_529])
		J.mc(_s231["ctx"], "lineTo", [J.sub(_s231["w"], 4.0), v_y_529])
		J.mc(_s231["ctx"], "stroke", [])
		v_i_528 = J.num(v_i_528) + 1.0
	var _t543 = _s231["ctx"]
	J.sp(_t543, "strokeStyle", "#9be8b0")
	var _t544 = _s231["ctx"]
	J.sp(_t544, "lineWidth", 2.2)
	J.mc(_s231["ctx"], "beginPath", [])
	J.mc(v_ps_519, "forEach", [Callable(self, "_f126").bind(_s231)])
	J.mc(_s231["ctx"], "stroke", [])
	J.mc(v_ps_519, "forEach", [Callable(self, "_f127").bind(_s231)])
	var _t557 = _s231["ctx"]
	J.sp(_t557, "fillStyle", "rgba(230,220,255,.7)")
	var _t558 = _s231["ctx"]
	J.sp(_t558, "font", "11px sans-serif")
	var _t559 = ["六天前", "", "", "", "", "昨天", "今天"]
	J.mc(_t559, "forEach", [Callable(self, "_f128").bind(_s231)])

func _f130(this_, a: Array, env):
	var v_k_539 = null; var v_m_540 = null
	v_k_539 = J.arg(a, 0)
	v_m_540 = J.gp(J.G.get("GS_MEALS"), v_k_539)
	var _t567 = ("own" if J.seq(J.gp(env["s"], "meal"), v_k_539) else "")
	var _t568 = J.gp(v_m_540, "name")
	var _t569 = J.gp(v_m_540, "eff")
	var _t570 = J.gp(v_m_540, "say")
	var _t566 = J.gp(env["this"], "ate")
	return ("<div class=\"gs-card " + _t567 + "\"><div class=\"gs-ci\"><b>" + J.str(_t568) + "</b><small class=\"gs-eff\">" + J.str(_t569) + "</small><small>" + J.str(_t570) + "</small></div>\n          <button class=\"btn gold sm gs-eat\" data-k=\"" + J.str(v_k_539) + "\" " + ("disabled" if J.t((_t566 if J.t(_t566) else (not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_m_540, "price")]))))) else "") + ">" + ("吃飽了" if J.t(J.gp(env["this"], "ate")) else ("吃 " + J.str(J.gp(v_m_540, "price")))) + "</button></div>")

func _f129(this_, a: Array, env):
	var _s240 = {"__p": env, "this": null, "s": null}
	_s240["this"] = this_
	_s240["s"] = J.mc(_s240["this"], "st", [])
	var _t572 = ("吃飽了就走！後面還有鬼在排隊！" if J.t(J.gp(_s240["this"], "ate")) else "一次只准點一碗！吃完下一場打架才有力！")
	var _t573 = (("<p class=\"gs-note\">肚子裡：<b>" + J.str(J.gp(J.gp(J.G.get("GS_MEALS"), J.gp(_s240["s"], "meal")), "name")) + "</b>（下一場出征生效，再點會換掉）</p>") if J.t(J.gp(_s240["s"], "meal")) else "")
	var _t565 = J.S_Object_("keys", [J.G.get("GS_MEALS")])
	var _t571 = J.mc(_t565, "map", [Callable(self, "_f130").bind(_s240)])
	return ("<p class=\"gs-line\"><b>餓鬼王</b>" + _t572 + "</p>\n      " + _t573 + "\n      <div class=\"gs-list\">" + J.str(J.mc(_t571, "join", [""])) + "</div>")

func _f133(this_, a: Array, env):
	var v_k_545 = null; var v_m_546 = null
	v_k_545 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_m_546 = J.gp(J.G.get("GS_MEALS"), v_k_545)
	var _t576 = J.gp(env["__p"]["this"], "ate")
	if J.t((_t576 if J.t(_t576) else (not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_m_546, "price")]))))):
		return null
	J.mc(env["__p"]["this"], "spend", [J.gp(v_m_546, "price")])
	var _t577 = J.mc(env["__p"]["this"], "st", [])
	J.sp(_t577, "meal", v_k_545)
	var _t578 = env["__p"]["this"]
	J.sp(_t578, "ate", true)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("Sound"), "play", ["harvest"])
	var _t580 = J.gp(J.gp(env["__p"]["this"], "keepers"), "food")
	var _t579 = J.G.get("pick")
	J.mc(env["__p"]["this"], "say", [_t580, J.cl(_t579, null, [["吃！吃完去打！", "好吃吧？我也想吃……我可以吃一口嗎？", "湯可以續，碗不能拿走！"]]), 2.6])
	J.mc(env["__p"]["this"], "keeperPose", ["food", "cast", 1.2])
	var _t581 = J.gp(env["__p"]["this"], "afu")
	J.sp(_t581, "pose", "cast")
	var _t582 = J.gp(env["__p"]["this"], "afu")
	J.sp(_t582, "poseT", 0.8)
	var _t584 = J.gp(J.gp(env["__p"]["this"], "afu"), "x")
	var _t585 = J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16)
	var _t583 = J.gp(v_m_546, "eff")
	J.mc(env["__p"]["this"], "float", [_t584, _t585, J.mc(_t583, "replace", ["下一場出征：", ""]), "#a8ffcf"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f132(this_, a: Array, env):
	var _s243 = {"__p": env, "b": null}
	_s243["b"] = J.arg(a, 0)
	var _t575 = _s243["b"]
	var _t586 = Callable(self, "_f133").bind(_s243)
	J.sp(_t575, "onclick", _t586)
	return _t586

func _f131(this_, a: Array, env):
	var v_p_543 = null
	var _s242 = {"__p": env, "this": null}
	_s242["this"] = this_
	v_p_543 = J.arg(a, 0)
	var _t574 = J.mc(v_p_543, "querySelectorAll", [".gs-eat"])
	J.mc(_t574, "forEach", [Callable(self, "_f132").bind(_s242)])

func _f135(this_, a: Array, env):
	var v_e_553 = null
	v_e_553 = J.arg(a, 0)
	return (not J.seq(J.gp(v_e_553, "id"), J.gp(env["s"], "alleyLast")))

func _f136(this_, a: Array, env):
	var v_o_554 = null; var v_k_555 = null
	v_o_554 = J.arg(a, 0)
	v_k_555 = J.arg(a, 1)
	var _t594 = ("gold" if J.seq(v_k_555, "a") else "")
	var _t593 = J.gp(v_o_554, "cost")
	return ("<button class=\"btn " + _t594 + " wide gs-al\" data-k=\"" + J.str(v_k_555) + "\" " + ("disabled" if J.t(((not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_o_554, "cost")]))) if J.t(_t593) else _t593)) else "") + ">" + J.str(J.gp(v_o_554, "label")) + (("（" + J.str(J.gp(v_o_554, "cost")) + " 冥幣）") if J.t(J.gp(v_o_554, "cost")) else "") + "</button>")

func _f134(this_, a: Array, env):
	var v_e_549 = null; var v_opt_550 = null; var v_pool_552 = null
	var _s245 = {"__p": env, "this": null}
	_s245["this"] = this_
	if J.t(J.gp(_s245["this"], "alleyDone")):
		return ("<p class=\"gs-line\">" + J.str(J.gp(J.gp(_s245["this"], "alleyDone"), "out")) + "</p><p class=\"gs-note\">" + (J.add("結果：", J.gp(J.gp(_s245["this"], "alleyDone"), "got")) if J.t(J.gp(J.gp(_s245["this"], "alleyDone"), "got")) else "") + "</p><p class=\"gs-note dim\">今晚巷子裡已經沒有別的事了。下次再來看看。</p>")
	if (not J.t(J.gp(_s245["this"], "alleyEv"))):
		var _s246 = {"__p": _s245, "s": null}
		_s246["s"] = J.mc(_s246["__p"]["this"], "st", [])
		v_pool_552 = J.mc(J.G.get("GS_ALLEY"), "filter", [Callable(self, "_f135").bind(_s246)])
		var _t587 = _s246["__p"]["this"]
		var _t588 = (not J.seq(J.typeof_(J.G.get("N30W")), "undefined"))
		var _t589 = (J.mc(J.G.get("N30W"), "alleyEvent", []) if _t588 else _t588)
		var _t590 = (_t589 if J.t(_t589) else J.gp(v_pool_552, floor(J.num((randf() * J.len(v_pool_552))))))
		J.sp(_t587, "alleyEv", _t590)
		var _t591 = _s246["s"]
		var _t592 = J.gp(J.gp(_s246["__p"]["this"], "alleyEv"), "id")
		J.sp(_t591, "alleyLast", _t592)
		J.cl(J.G.get("save"), null, [])
	v_e_549 = J.gp(_s245["this"], "alleyEv")
	v_opt_550 = Callable(self, "_f136").bind(_s245)
	return ("<p class=\"gs-line\">" + J.str(J.gp(v_e_549, "text")) + "</p>" + J.str(J.cl(v_opt_550, null, [J.gp(v_e_549, "a"), "a"])) + J.str(J.cl(v_opt_550, null, [J.gp(v_e_549, "b"), "b"])))

func _f139(this_, a: Array, env):
	var v_o_560 = null; var v_r_561 = null; var v_got_562 = null
	v_o_560 = J.gp(J.gp(env["__p"]["this"], "alleyEv"), J.gp(J.gp(env["b"], "dataset"), "k"))
	var _t597 = J.gp(v_o_560, "cost")
	if J.t(((not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_o_560, "cost")]))) if J.t(_t597) else _t597)):
		return null
	if J.t(J.gp(v_o_560, "cost")):
		J.mc(env["__p"]["this"], "spend", [J.gp(v_o_560, "cost")])
	var _t599 = {}
	var _t598 = J.gp(v_o_560, "give")
	v_r_561 = J.S_Object_("assign", [_t599, (_t598 if J.t(_t598) else {})])
	if J.t(J.gp(v_r_561, "troops")):
		var _t600 = J.max_([0.0, J.min_([J.gp(v_r_561, "troops"), J.sub(J.mc(J.G.get("F"), "troopCap", []), J.gp(J.gp(J.G.get("S"), "res"), "troops"))])])
		J.sp(v_r_561, "troops", _t600)
	if J.seq(J.gp(v_r_561, "troops"), 0.0):
		J.del(v_r_561, "troops")
	var _t602 = null
	if J.t(J.len(J.S_Object_("keys", [v_r_561]))):
		var _t601 = J.G.get("give")
		_t602 = J.cl(_t601, null, [v_r_561])
	else:
		_t602 = ""
	v_got_562 = _t602
	if J.t(J.gp(v_o_560, "cost")):
		var _t603 = (("冥幣 −" + J.str(J.gp(v_o_560, "cost"))) + (J.add("，", v_got_562) if J.t(v_got_562) else ""))
		v_got_562 = _t603
	if J.t(J.gp(v_o_560, "join")):
		var _t604 = J.G.get("joinGhost")
		J.cl(_t604, null, [J.gp(v_o_560, "join")])
		var _t605 = J.add(v_got_562, (("，" if J.t(v_got_562) else "") + (J.str(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_o_560, "join")), "name")) + "加入")))
		v_got_562 = _t605
	var _t606 = env["__p"]["this"]
	var _t607 = {"out": J.gp(v_o_560, "out"), "got": v_got_562}
	J.sp(_t606, "alleyDone", _t607)
	J.mc(J.G.get("Sound"), "play", [("chest" if J.t(J.gp(v_r_561, "chest")) else "paper")])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	var _t609 = J.gp(J.gp(env["__p"]["this"], "afu"), "x")
	var _t610 = J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16)
	var _t608 = J.gp(J.mc(v_got_562, "split", ["，"]), 0.0)
	J.mc(env["__p"]["this"], "float", [_t609, _t610, (_t608 if J.t(_t608) else "……"), "#e6dcff"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f138(this_, a: Array, env):
	var _s250 = {"__p": env, "b": null}
	_s250["b"] = J.arg(a, 0)
	var _t596 = _s250["b"]
	var _t611 = Callable(self, "_f139").bind(_s250)
	J.sp(_t596, "onclick", _t611)
	return _t611

func _f137(this_, a: Array, env):
	var v_p_558 = null
	var _s249 = {"__p": env, "this": null}
	_s249["this"] = this_
	v_p_558 = J.arg(a, 0)
	var _t595 = J.mc(v_p_558, "querySelectorAll", [".gs-al"])
	J.mc(_t595, "forEach", [Callable(self, "_f138").bind(_s249)])
