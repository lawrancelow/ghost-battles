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
	J.G["GhostStreet"] = {"active": false, "st": Callable(self, "_f4").bind(env), "mul": Callable(self, "_f5").bind(env), "bonus": Callable(self, "_f6").bind(env), "battleBuffs": Callable(self, "_f7").bind(env), "open": Callable(self, "_f14").bind(env), "close": Callable(self, "_f26").bind(env), "resize": Callable(self, "_f27").bind(env), "targetVH": Callable(self, "_f28").bind(env), "geo": Callable(self, "_f29").bind(env), "X": Callable(self, "_f30").bind(env), "Y": Callable(self, "_f31").bind(env), "depth": Callable(self, "_f32").bind(env), "charScale": Callable(self, "_f33").bind(env), "toWorld": Callable(self, "_f34").bind(env), "down": Callable(self, "_f35").bind(env), "move": Callable(self, "_f36").bind(env), "up": Callable(self, "_f37").bind(env), "walkTo": Callable(self, "_f38").bind(env), "goStall": Callable(self, "_f39").bind(env), "arrive": Callable(self, "_f40").bind(env), "frame": Callable(self, "_f42").bind(env), "step": Callable(self, "_f45").bind(env), "mkJoss": Callable(self, "_f51").bind(env), "avoid": Callable(self, "_f52").bind(env), "chat": Callable(self, "_f53").bind(env), "say": Callable(self, "_f54").bind(env), "float": Callable(self, "_f55").bind(env), "draw": Callable(self, "_f57").bind(env), "glow": Callable(self, "_f64").bind(env), "drawFog": Callable(self, "_f65").bind(env), "drawParts": Callable(self, "_f67").bind(env), "drawLanternString": Callable(self, "_f68").bind(env), "drawSigns": Callable(self, "_f69").bind(env), "nearStall": Callable(self, "_f70").bind(env), "drawAfu": Callable(self, "_f71").bind(env), "drawKeeper": Callable(self, "_f72").bind(env), "drawWalker": Callable(self, "_f73").bind(env), "bubble": Callable(self, "_f74").bind(env), "renderPanel": Callable(self, "_f77").bind(env), "relax": Callable(self, "_f82").bind(env), "keeperPose": Callable(self, "_f83").bind(env), "coinsOk": Callable(self, "_f84").bind(env), "spend": Callable(self, "_f85").bind(env), "html_paper": Callable(self, "_f86").bind(env), "bind_paper": Callable(self, "_f88").bind(env), "burn": Callable(self, "_f91").bind(env), "todayItems": Callable(self, "_f92").bind(env), "floorOf": Callable(self, "_f96").bind(env), "askOf": Callable(self, "_f97").bind(env), "html_haggle": Callable(self, "_f98").bind(env), "bind_haggle": Callable(self, "_f102").bind(env), "offer": Callable(self, "_f112").bind(env), "price": Callable(self, "_f115").bind(env), "html_exch": Callable(self, "_f116").bind(env), "bind_exch": Callable(self, "_f117").bind(env), "trade": Callable(self, "_f120").bind(env), "drawChart": Callable(self, "_f121").bind(env), "html_food": Callable(self, "_f128").bind(env), "bind_food": Callable(self, "_f130").bind(env), "html_alley": Callable(self, "_f133").bind(env), "bind_alley": Callable(self, "_f136").bind(env)}

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
		J.cl(J.G.get("__nat_miniEnd"), null, [])
		var _t84 = this_
		J.sp(_t84, "_nat", false)
	var _t85 = J.G.get("$")
	var _t86 = J.gp(J.cl(_t85, null, ["#gstreet"]), "classList")
	J.mc(_t86, "remove", ["on"])
	var _t87 = J.G.get("$")
	var _t88 = J.cl(_t87, null, ["#gstreet"])
	J.sp(_t88, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f27(this_, a: Array, env):
	var v_c_84 = null; var v_box_85 = null; var v_r_86 = null; var v_dpr_87 = null
	var _t89 = J.G.get("$")
	v_c_84 = J.cl(_t89, null, ["#gs-cvs"])
	var _t90 = J.G.get("$")
	v_box_85 = J.cl(_t90, null, ["#gs-stage"])
	var _t91 = (not J.t(v_c_84))
	if (_t91 if _t91 else (not J.t(v_box_85))):
		return null
	v_r_86 = J.mc(v_box_85, "getBoundingClientRect", [])
	var _t92 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t93 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_87 = J.min_([2.0, (_t93 if J.t(_t93) else 1.0)])
	var _t94 = J.mul(J.gp(v_r_86, "width"), v_dpr_87)
	J.sp(v_c_84, "width", _t94)
	var _t95 = J.mul(J.gp(v_r_86, "height"), v_dpr_87)
	J.sp(v_c_84, "height", _t95)
	var _t96 = J.gp(v_c_84, "style")
	var _t97 = J.add(J.gp(v_r_86, "width"), "px")
	J.sp(_t96, "width", _t97)
	var _t98 = J.gp(v_c_84, "style")
	var _t99 = J.add(J.gp(v_r_86, "height"), "px")
	J.sp(_t98, "height", _t99)
	var _t100 = this_
	var _t101 = J.gp(v_r_86, "width")
	J.sp(_t100, "W", _t101)
	var _t102 = this_
	var _t103 = J.gp(v_r_86, "height")
	J.sp(_t102, "H", _t103)
	var _t104 = this_
	J.sp(_t104, "dpr", v_dpr_87)

func _f28(this_, a: Array, env):
	var v_p_90 = null
	var _t105 = J.G.get("$")
	v_p_90 = J.cl(_t105, null, ["#gs-panel"])
	var _t106 = J.gp(this_, "H")
	var _t107 = J.gp(this_, "H")
	return J.max_([260.0, (J.sub((_t107 if J.t(_t107) else 700.0), (J.gp(v_p_90, "offsetHeight") if J.t(v_p_90) else 0.0)) + 6.0)])

func _f29(this_, a: Array, env):
	var v_img_93 = null; var v_iw_94 = null; var v_ih_95 = null; var v_IH_96 = null; var v_IW_97 = null
	v_img_93 = J.gp(J.G.get("SPR"), "bg_street")
	var _t108 = (J.gp(v_img_93, "naturalWidth") if J.t(v_img_93) else v_img_93)
	v_iw_94 = (_t108 if J.t(_t108) else 1536.0)
	var _t109 = (J.gp(v_img_93, "naturalHeight") if J.t(v_img_93) else v_img_93)
	v_ih_95 = (_t109 if J.t(_t109) else 1024.0)
	var _t110 = J.gp(this_, "vh")
	v_IH_96 = (_t110 if J.t(_t110) else 500.0)
	v_IW_97 = J.div(J.mul(v_IH_96, v_iw_94), v_ih_95)
	if J.cmp(v_IW_97, J.mul(J.gp(this_, "W"), 1.15), "<"):
		var _t111 = J.mul(J.gp(this_, "W"), 1.15)
		v_IW_97 = _t111
		var _t112 = J.div(J.mul(v_IW_97, v_ih_95), v_iw_94)
		v_IH_96 = _t112
	return {"IW": v_IW_97, "IH": v_IH_96}

func _f30(this_, a: Array, env):
	var v_fx_100 = null; var v_g_101 = null
	v_fx_100 = J.arg(a, 0)
	v_g_101 = J.mc(this_, "geo", [])
	return J.mul(J.sub(v_fx_100, J.gp(this_, "cam")), J.gp(v_g_101, "IW"))

func _f31(this_, a: Array, env):
	var v_fy_104 = null
	v_fy_104 = J.arg(a, 0)
	return J.mul(v_fy_104, J.gp(J.mc(this_, "geo", []), "IH"))

func _f32(this_, a: Array, env):
	var v_fy_107 = null
	v_fy_107 = J.arg(a, 0)
	return (0.84 + (0.36 * J.max_([0.0, J.min_([1.0, J.div(J.sub(v_fy_107, 0.72), 0.23)])])))

func _f33(this_, a: Array, env):
	var v_fy_110 = null
	v_fy_110 = J.arg(a, 0)
	return J.mul(J.div(J.mul(J.gp(J.mc(this_, "geo", []), "IH"), 0.25), 58.0), J.mc(this_, "depth", [v_fy_110]))

func _f34(this_, a: Array, env):
	var v_e_113 = null; var v_r_114 = null; var v_g_115 = null
	v_e_113 = J.arg(a, 0)
	var _t113 = J.G.get("$")
	v_r_114 = J.mc(J.cl(_t113, null, ["#gs-cvs"]), "getBoundingClientRect", [])
	v_g_115 = J.mc(this_, "geo", [])
	return {"fx": J.add(J.div(J.sub(J.gp(v_e_113, "clientX"), J.gp(v_r_114, "left")), J.gp(v_g_115, "IW")), J.gp(this_, "cam")), "fy": J.div(J.sub(J.gp(v_e_113, "clientY"), J.gp(v_r_114, "top")), J.gp(v_g_115, "IH")), "sx": J.sub(J.gp(v_e_113, "clientX"), J.gp(v_r_114, "left")), "sy": J.sub(J.gp(v_e_113, "clientY"), J.gp(v_r_114, "top"))}

func _f35(this_, a: Array, env):
	var v_e_118 = null; var v_p_119 = null; var v_er_120 = null
	v_e_118 = J.arg(a, 0)
	if J.cmp(J.gp(this_, "kick"), 0.0, ">"):
		return null
	v_p_119 = J.mc(this_, "toWorld", [v_e_118])
	var _t114 = this_
	var _t115 = {"x0": J.gp(v_p_119, "sx"), "y0": J.gp(v_p_119, "sy"), "moved": false, "p": v_p_119}
	J.sp(_t114, "drag", _t115)
	var _t116 = J.gp(v_e_118, "target")
	J.mc(_t116, "setPointerCapture", [J.gp(v_e_118, "pointerId")])

func _f36(this_, a: Array, env):
	var v_e_123 = null; var v_p_124 = null
	v_e_123 = J.arg(a, 0)
	var _t117 = (not J.t(J.gp(this_, "drag")))
	if (_t117 if _t117 else J.cmp(J.gp(this_, "kick"), 0.0, ">")):
		return null
	v_p_124 = J.mc(this_, "toWorld", [v_e_123])
	var _t118 = (not J.t(J.gp(J.gp(this_, "drag"), "moved")))
	if ((J.hypot_([J.sub(J.gp(v_p_124, "sx"), J.gp(J.gp(this_, "drag"), "x0")), J.sub(J.gp(v_p_124, "sy"), J.gp(J.gp(this_, "drag"), "y0"))]) > 10.0) if _t118 else _t118):
		var _t119 = J.gp(this_, "drag")
		J.sp(_t119, "moved", true)
	if J.t(J.gp(J.gp(this_, "drag"), "moved")):
		var _t120 = this_
		J.sp(_t120, "pend", null)
		J.mc(this_, "walkTo", [J.gp(v_p_124, "fx"), J.gp(v_p_124, "fy")])

func _f37(this_, a: Array, env):
	var v_e_127 = null; var v_d_128 = null; var v_p_129 = null; var v_w_130 = null; var v_sc_131 = null; var v_h_132 = null; var v_k_133 = null; var v_s_134 = null
	v_e_127 = J.arg(a, 0)
	v_d_128 = J.gp(this_, "drag")
	var _t121 = this_
	J.sp(_t121, "drag", null)
	var _t122 = (not J.t(v_d_128))
	var _t123 = (_t122 if _t122 else J.gp(v_d_128, "moved"))
	if J.t((_t123 if J.t(_t123) else J.cmp(J.gp(this_, "kick"), 0.0, ">"))):
		return null
	v_p_129 = J.gp(v_d_128, "p")
	for _t124 in J.iter(J.gp(this_, "walkers")):
		v_w_130 = _t124
		v_sc_131 = J.mc(this_, "charScale", [J.gp(v_w_130, "y")])
		v_h_132 = J.mul(58.0, v_sc_131)
		var _t125 = (J.mul(absf(J.num(J.sub(J.gp(v_p_129, "fx"), J.gp(v_w_130, "x")))), J.gp(J.mc(this_, "geo", []), "IW")) < J.mul(22.0, v_sc_131))
		var _t126 = (J.cmp(J.mul(J.gp(v_p_129, "fy"), J.gp(J.mc(this_, "geo", []), "IH")), J.add(J.mc(this_, "Y", [J.gp(v_w_130, "y")]), 6.0), "<") if _t125 else _t125)
		if ((J.mul(J.gp(v_p_129, "fy"), J.gp(J.mc(this_, "geo", []), "IH")) > J.sub(J.mc(this_, "Y", [J.gp(v_w_130, "y")]), v_h_132)) if _t126 else _t126):
			J.mc(this_, "chat", [v_w_130, true])
			J.mc(J.G.get("Sound"), "play", ["click"])
			return null
	if J.cmp(J.gp(v_p_129, "fy"), 0.74, "<"):
		for _t127 in J.iter(J.G.get("GS_ORDER")):
			v_k_133 = _t127
			v_s_134 = J.gp(J.G.get("GS_STALLS"), v_k_133)
			var _t128 = J.cmp(J.gp(v_p_129, "fx"), J.gp(v_s_134, "x0"), ">=")
			if (J.cmp(J.gp(v_p_129, "fx"), J.gp(v_s_134, "x1"), "<=") if _t128 else _t128):
				J.mc(this_, "goStall", [v_k_133])
				return null
	var _t129 = this_
	J.sp(_t129, "pend", null)
	J.mc(this_, "walkTo", [J.gp(v_p_129, "fx"), J.gp(v_p_129, "fy")])

func _f38(this_, a: Array, env):
	var v_fx_137 = null; var v_fy_138 = null; var v_A_139 = null
	v_fx_137 = J.arg(a, 0)
	v_fy_138 = J.arg(a, 1)
	v_A_139 = J.gp(this_, "afu")
	var _t130 = J.max_([0.03, J.min_([0.97, v_fx_137])])
	J.sp(v_A_139, "tx", _t130)
	var _t131 = J.max_([0.78, J.min_([0.93, v_fy_138])])
	J.sp(v_A_139, "ty", _t131)

func _f39(this_, a: Array, env):
	var v_k_142 = null; var v_s_143 = null
	v_k_142 = J.arg(a, 0)
	v_s_143 = J.gp(J.G.get("GS_STALLS"), v_k_142)
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t132 = this_
	J.sp(_t132, "pend", v_k_142)
	J.mc(this_, "walkTo", [J.gp(v_s_143, "sx"), 0.8])
	var _t133 = (not J.seq(J.gp(J.gp(this_, "view"), "k"), "idle"))
	if ((not J.seq(J.gp(J.gp(this_, "view"), "k"), v_k_142)) if _t133 else _t133):
		var _t134 = this_
		var _t135 = {"k": "idle"}
		J.sp(_t134, "view", _t135)
		J.mc(this_, "renderPanel", [])

func _f41(this_, a: Array, env):
	var v_w_148 = null
	v_w_148 = J.arg(a, 0)
	J.sp(v_w_148, "bubT", 0.0)
	if (absf(J.num(J.sub(J.gp(v_w_148, "x"), J.gp(J.gp(env["this"], "afu"), "x")))) < 0.16):
		var _t145 = J.mc(env["this"], "avoid", [J.add(J.gp(J.gp(env["this"], "afu"), "x"), ((-0.2) if J.cmp(J.gp(v_w_148, "x"), J.gp(J.gp(env["this"], "afu"), "x"), "<") else 0.2))])
		J.sp(v_w_148, "tx", _t145)
		var _t146 = (0.87 + (randf() * 0.06))
		J.sp(v_w_148, "ty", _t146)
		J.sp(v_w_148, "wait", 3.0)

func _f40(this_, a: Array, env):
	var v_k_146 = null; var v_kp_147 = null
	var _s63 = {"__p": env, "this": null}
	_s63["this"] = this_
	v_k_146 = J.arg(a, 0)
	var _t136 = _s63["this"]
	J.sp(_t136, "pend", null)
	var _t137 = J.gp(_s63["this"], "afu")
	var _t138 = J.gp(J.gp(J.G.get("GS_STALLS"), v_k_146), "face")
	J.sp(_t137, "dir", _t138)
	v_kp_147 = J.gp(J.gp(_s63["this"], "keepers"), v_k_146)
	if J.t(v_kp_147):
		var _t139 = J.G.get("pick")
		var _t140 = J.cl(_t139, null, [J.gp(J.G.get("GS_KEEPER_HI"), v_k_146)])
		J.mc(_s63["this"], "say", [v_kp_147, J.mc(_t140, "replace", [J.re("^[^：]+：", ""), ""]), 3.0])
		J.sp(v_kp_147, "pose", "cast")
		J.sp(v_kp_147, "poseT", 0.9)
	var _t141 = _s63["this"]
	var _t142 = {"k": v_k_146}
	J.sp(_t141, "view", _t142)
	if J.seq(v_k_146, "haggle"):
		var _t143 = J.gp(_s63["this"], "view")
		J.sp(_t143, "sub", null)
	var _t144 = J.gp(_s63["this"], "walkers")
	J.mc(_t144, "forEach", [Callable(self, "_f41").bind(_s63)])
	J.mc(_s63["this"], "renderPanel", [])
	J.mc(J.G.get("Sound"), "play", ["paper"])

func _f43(this_, a: Array, env):
	var v_n_153 = null
	v_n_153 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_153])

func _f44(this_, a: Array, env):
	var v_n_154 = null
	v_n_154 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_154])

func _f42(this_, a: Array, env):
	var v_now_151 = null; var v_dt_152 = null
	var _s67 = {"__p": env, "this": null}
	_s67["this"] = this_
	v_now_151 = J.arg(a, 0)
	if (not J.t(J.gp(_s67["this"], "active"))):
		return null
	if (J.sub(v_now_151, J.gp(_s67["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f43").bind(_s67)])
		return null
	v_dt_152 = J.min_([0.05, J.div(J.sub(v_now_151, J.gp(_s67["this"], "last")), 1000.0)])
	var _t147 = _s67["this"]
	J.sp(_t147, "last", v_now_151)
	J.mc(_s67["this"], "step", [v_dt_152])
	if (not J.t(J.gp(_s67["this"], "_nat"))):
		J.mc(_s67["this"], "draw", [J.div(v_now_151, 1000.0)])
	J.F_requestAnimationFrame([Callable(self, "_f44").bind(_s67)])

func _f46(this_, a: Array, env):
	var v_k_179 = null
	v_k_179 = J.arg(a, 0)
	return J.cmp(J.gp(v_k_179, "bubT"), 0.0, ">")

func _f47(this_, a: Array, env):
	var v_o_180 = null
	v_o_180 = J.arg(a, 0)
	var _t237 = (not J.seq(v_o_180, env["w"]))
	return (J.cmp(J.gp(v_o_180, "bubT"), 0.0, ">") if _t237 else _t237)

func _f48(this_, a: Array, env):
	var v_w_187 = null
	v_w_187 = J.arg(a, 0)
	var _t257 = J.gp(v_w_187, "prop")
	var _t258 = ((not J.t(J.gp(v_w_187, "bump"))) if J.t(_t257) else _t257)
	var _t259 = ((not J.t(J.gp(v_w_187, "look"))) if J.t(_t258) else _t258)
	var _t260 = (J.cmp(J.mc(env["this"], "X", [J.gp(v_w_187, "x")]), 40.0, ">") if J.t(_t259) else _t259)
	return (J.cmp(J.mc(env["this"], "X", [J.gp(v_w_187, "x")]), J.sub(J.gp(env["this"], "W"), 40.0), "<") if J.t(_t260) else _t260)

func _f49(this_, a: Array, env):
	var v_p_193 = null
	v_p_193 = J.arg(a, 0)
	var _t268 = J.sub(J.gp(v_p_193, "life"), env["dt"])
	J.sp(v_p_193, "life", _t268)
	var _t269 = J.add(J.gp(v_p_193, "x"), J.mul(J.gp(v_p_193, "vx"), env["dt"]))
	J.sp(v_p_193, "x", _t269)
	var _t270 = J.add(J.gp(v_p_193, "y"), J.mul(J.gp(v_p_193, "vy"), env["dt"]))
	J.sp(v_p_193, "y", _t270)
	if J.seq(J.gp(v_p_193, "kind"), "joss"):
		var _t271 = J.add(J.gp(v_p_193, "rot"), J.mul(J.gp(v_p_193, "vr"), env["dt"]))
		J.sp(v_p_193, "rot", _t271)
		var _t272 = J.add(J.gp(v_p_193, "flip"), J.mul(env["dt"], J.gp(v_p_193, "vf")))
		J.sp(v_p_193, "flip", _t272)
		var _t273 = J.add(J.gp(v_p_193, "bx"), (sin(J.num(J.add(J.mul(J.gp(env["this"], "t"), J.gp(v_p_193, "sw")), J.gp(v_p_193, "ph")))) * 0.012))
		J.sp(v_p_193, "vx", _t273)
		if J.cmp(J.gp(v_p_193, "y"), J.gp(v_p_193, "land"), ">"):
			J.sp(v_p_193, "vy", 0.0)
			J.sp(v_p_193, "vx", 0.0)
			J.sp(v_p_193, "vr", 0.0)
			J.sp(v_p_193, "vf", 0.0)
	return J.cmp(J.gp(v_p_193, "life"), 0.0, ">")

func _f50(this_, a: Array, env):
	var v_f_195 = null
	v_f_195 = J.arg(a, 0)
	var _t280 = J.sub(J.gp(v_f_195, "life"), env["dt"])
	J.sp(v_f_195, "life", _t280)
	return (_t280 > 0.0)

func _f45(this_, a: Array, env):
	var v_A_158 = null; var v_g_159 = null; var v_tv_160 = null; var v_vw_161 = null; var v_want_162 = null; var v_c_163 = null; var v_dx_164 = null; var v_dy_165 = null; var v_d_166 = null; var v_sp_167 = null; var v_k_168 = null; var v_kp_169 = null; var v_near_170 = null; var v_dx_172 = null; var v_dy_173 = null; var v_d_174 = null; var v_sp_175 = null; var v_st_176 = null; var v_vis_177 = null; var v_busy_178 = null; var v_i_181 = null; var v_j_182 = null; var v_P_183 = null; var v_Q_184 = null; var v_W_185 = null; var v_vis_186 = null; var v_P_188 = null; var v_Q_189 = null; var v_mid_190 = null; var v_yy_191 = null; var v_l_192 = null; var v_f_194 = null; var v_v_196 = null
	var _s71 = {"__p": env, "this": null, "dt": null}
	_s71["this"] = this_
	_s71["dt"] = J.arg(a, 0)
	var _t148 = _s71["this"]
	var _t149 = J.add(J.gp(_t148, "t"), _s71["dt"])
	J.sp(_t148, "t", _t149)
	v_A_158 = J.gp(_s71["this"], "afu")
	v_g_159 = J.mc(_s71["this"], "geo", [])
	v_tv_160 = J.mc(_s71["this"], "targetVH", [])
	var _t150 = _s71["this"]
	var _t151 = J.add(J.gp(_t150, "vh"), (J.sub(v_tv_160, J.gp(_s71["this"], "vh")) * J.min_([1.0, J.mul(_s71["dt"], 7.0)])))
	J.sp(_t150, "vh", _t151)
	if J.cmp(J.gp(_s71["this"], "kick"), 0.0, ">"):
		var _t152 = _s71["this"]
		var _t153 = J.sub(J.gp(_t152, "kick"), _s71["dt"])
		J.sp(_t152, "kick", _t153)
		var _t154 = J.max_([0.2, J.sub(J.gp(v_A_158, "x"), J.mul(_s71["dt"], 0.12))])
		J.sp(v_A_158, "x", _t154)
		var _t155 = J.gp(v_A_158, "x")
		J.sp(v_A_158, "tx", _t155)
		var _t156 = J.gp(v_A_158, "y")
		J.sp(v_A_158, "ty", _t156)
		J.sp(v_A_158, "dir", 1.0)
		J.sp(v_A_158, "walking", false)
		J.sp(v_A_158, "pose", "hurt")
		J.sp(v_A_158, "poseT", 0.2)
	else:
		v_dx_164 = J.mul(J.sub(J.gp(v_A_158, "tx"), J.gp(v_A_158, "x")), J.gp(v_g_159, "IW"))
		v_dy_165 = J.mul(J.sub(J.gp(v_A_158, "ty"), J.gp(v_A_158, "y")), J.gp(v_g_159, "IH"))
		v_d_166 = J.hypot_([v_dx_164, v_dy_165])
		v_sp_167 = J.mul(J.mul(150.0, J.mc(_s71["this"], "depth", [J.gp(v_A_158, "y")])), _s71["dt"])
		if J.cmp(v_d_166, 2.0, ">"):
			var _t157 = J.add(J.gp(v_A_158, "x"), J.div((J.div(v_dx_164, v_d_166) * J.min_([v_sp_167, v_d_166])), J.gp(v_g_159, "IW")))
			J.sp(v_A_158, "x", _t157)
			var _t158 = J.add(J.gp(v_A_158, "y"), J.div((J.div(v_dy_165, v_d_166) * J.min_([v_sp_167, v_d_166])), J.gp(v_g_159, "IH")))
			J.sp(v_A_158, "y", _t158)
			if (absf(J.num(v_dx_164)) > 1.0):
				var _t159 = (1.0 if J.cmp(v_dx_164, 0.0, ">") else (-1.0))
				J.sp(v_A_158, "dir", _t159)
			J.sp(v_A_158, "walking", true)
			var _t160 = J.sub(J.gp(v_A_158, "dustT"), _s71["dt"])
			J.sp(v_A_158, "dustT", _t160)
			if J.cmp(J.gp(v_A_158, "dustT"), 0.0, "<="):
				J.sp(v_A_158, "dustT", 0.16)
				var _t161 = J.gp(_s71["this"], "parts")
				J.mc(_t161, "push", [{"kind": "dust", "x": J.sub(J.gp(v_A_158, "x"), J.mul(J.gp(v_A_158, "dir"), 0.006)), "y": J.gp(v_A_158, "y"), "vx": ((-J.num(J.gp(v_A_158, "dir"))) * 0.01), "vy": (-0.02), "life": 0.55, "max": 0.55, "r": (3.0 + (randf() * 3.0))}])
		else:
			var _t162 = J.gp(v_A_158, "walking")
			if J.t((J.gp(_s71["this"], "pend") if J.t(_t162) else _t162)):
				J.mc(_s71["this"], "arrive", [J.gp(_s71["this"], "pend")])
			J.sp(v_A_158, "walking", false)
	if J.cmp(J.gp(v_A_158, "poseT"), 0.0, ">"):
		var _t163 = J.sub(J.gp(v_A_158, "poseT"), _s71["dt"])
		J.sp(v_A_158, "poseT", _t163)
		if J.cmp(J.gp(v_A_158, "poseT"), 0.0, "<="):
			J.sp(v_A_158, "pose", null)
	v_vw_161 = J.div(J.gp(_s71["this"], "W"), J.gp(v_g_159, "IW"))
	v_want_162 = J.max_([0.0, J.min_([J.sub(1.0, v_vw_161), J.sub(J.gp(v_A_158, "x"), J.div(v_vw_161, 2.0))])])
	var _t164 = _s71["this"]
	var _t165 = J.add(J.gp(_t164, "cam"), (J.sub(v_want_162, J.gp(_s71["this"], "cam")) * J.min_([1.0, J.mul(_s71["dt"], 4.0)])))
	J.sp(_t164, "cam", _t165)
	var _t166 = _s71["this"]
	var _t167 = J.max_([0.0, J.min_([J.sub(1.0, v_vw_161), J.gp(_s71["this"], "cam")])])
	J.sp(_t166, "cam", _t167)
	for _t168 in J.keys(J.gp(_s71["this"], "keepers")):
		v_k_168 = _t168
		v_kp_169 = J.gp(J.gp(_s71["this"], "keepers"), v_k_168)
		if J.cmp(J.gp(v_kp_169, "poseT"), 0.0, ">"):
			var _t169 = J.sub(J.gp(v_kp_169, "poseT"), _s71["dt"])
			J.sp(v_kp_169, "poseT", _t169)
			var _t170 = J.min_([1.0, J.add(J.gp(v_kp_169, "pt"), J.mul(_s71["dt"], 1.6))])
			J.sp(v_kp_169, "pt", _t170)
			var _t171 = J.cmp(J.gp(v_kp_169, "poseT"), 0.0, "<=")
			if ((not J.t(J.gp(v_kp_169, "hold"))) if _t171 else _t171):
				J.sp(v_kp_169, "pose", null)
		if J.cmp(J.gp(v_kp_169, "bubT"), 0.0, ">"):
			var _t172 = J.sub(J.gp(v_kp_169, "bubT"), _s71["dt"])
			J.sp(v_kp_169, "bubT", _t172)
		var _t173 = (not J.t(J.gp(v_A_158, "walking")))
		v_near_170 = ((absf(J.num(J.sub(J.gp(v_A_158, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_168), "x")))) < 0.09) if _t173 else _t173)
		var _t174 = ((not J.t(J.gp(v_kp_169, "greeted"))) if J.t(v_near_170) else v_near_170)
		if J.t(((not J.t(J.gp(v_kp_169, "pose"))) if J.t(_t174) else _t174)):
			J.sp(v_kp_169, "greeted", true)
			var _t175 = J.seq(J.gp(v_kp_169, "k"), "xiaozhi")
			var _t176 = (1.8 if (_t175 if _t175 else J.seq(J.gp(v_kp_169, "k"), "eguiking")) else 1.6)
			J.sp(v_kp_169, "greet", _t176)
			J.sp(v_kp_169, "gt", 0.0)
		if (absf(J.num(J.sub(J.gp(v_A_158, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_168), "x")))) > 0.14):
			J.sp(v_kp_169, "greeted", false)
		if J.cmp(J.gp(v_kp_169, "greet"), 0.0, ">"):
			var _t177 = J.sub(J.gp(v_kp_169, "greet"), _s71["dt"])
			J.sp(v_kp_169, "greet", _t177)
			var _t178 = J.add(J.gp(v_kp_169, "gt"), _s71["dt"])
			J.sp(v_kp_169, "gt", _t178)
			if J.t(J.gp(v_kp_169, "pose")):
				J.sp(v_kp_169, "greet", 0.0)
		if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
			var _t180 = J.gp(v_kp_169, "st")
			var _t181 = J.gp(v_kp_169, "k")
			var _t182 = _s71["dt"]
			var _t179 = (not J.t(J.gp(v_kp_169, "pose")))
			var _t183 = J.mc(J.G.get("TOWN"), "tick", [_t180, _t181, _t182, ((not J.cmp(J.gp(v_kp_169, "greet"), 0.0, ">")) if _t179 else _t179), false])
			J.sp(v_kp_169, "st", _t183)
	for _t184 in J.iter(J.gp(_s71["this"], "walkers")):
		var _s83 = {"__p": _s71, "w": null}
		_s83["w"] = _t184
		if J.cmp(J.gp(_s83["w"], "bubT"), 0.0, ">"):
			var _t185 = _s83["w"]
			var _t186 = J.sub(J.gp(_t185, "bubT"), _s83["__p"]["dt"])
			J.sp(_t185, "bubT", _t186)
		if J.cmp(J.gp(_s83["w"], "bump"), 0.0, ">"):
			var _t187 = _s83["w"]
			var _t188 = J.sub(J.gp(_t187, "bump"), _s83["__p"]["dt"])
			J.sp(_t187, "bump", _t188)
			var _t189 = _s83["w"]
			var _t190 = J.add(J.gp(_t189, "bt"), _s83["__p"]["dt"])
			J.sp(_t189, "bt", _t190)
			var _t191 = _s83["w"]
			J.sp(_t191, "walking", false)
			continue
		if J.cmp(J.gp(_s83["w"], "look"), 0.0, ">"):
			var _t192 = _s83["w"]
			var _t193 = J.sub(J.gp(_t192, "look"), _s83["__p"]["dt"])
			J.sp(_t192, "look", _t193)
			var _t194 = _s83["w"]
			var _t195 = J.add(J.gp(_t194, "lt"), _s83["__p"]["dt"])
			J.sp(_t194, "lt", _t195)
			var _t196 = _s83["w"]
			J.sp(_t196, "walking", false)
			continue
		v_dx_172 = J.mul(J.sub(J.gp(_s83["w"], "tx"), J.gp(_s83["w"], "x")), J.gp(v_g_159, "IW"))
		v_dy_173 = J.mul(J.sub(J.gp(_s83["w"], "ty"), J.gp(_s83["w"], "y")), J.gp(v_g_159, "IH"))
		v_d_174 = J.hypot_([v_dx_172, v_dy_173])
		if J.cmp(v_d_174, 2.0, ">"):
			v_sp_175 = J.mul(34.0, _s83["__p"]["dt"])
			var _t197 = _s83["w"]
			var _t198 = J.add(J.gp(_t197, "x"), J.div((J.div(v_dx_172, v_d_174) * J.min_([v_sp_175, v_d_174])), J.gp(v_g_159, "IW")))
			J.sp(_t197, "x", _t198)
			var _t199 = _s83["w"]
			var _t200 = J.add(J.gp(_t199, "y"), J.div((J.div(v_dy_173, v_d_174) * J.min_([v_sp_175, v_d_174])), J.gp(v_g_159, "IH")))
			J.sp(_t199, "y", _t200)
			if (absf(J.num(v_dx_172)) > 0.5):
				var _t201 = _s83["w"]
				var _t202 = (1.0 if J.cmp(v_dx_172, 0.0, ">") else (-1.0))
				J.sp(_t201, "dir", _t202)
			var _t203 = _s83["w"]
			J.sp(_t203, "walking", true)
		else:
			var _t204 = J.gp(_s83["w"], "walking")
			if J.t(((not J.leq(J.gp(_s83["w"], "toStall"), null)) if J.t(_t204) else _t204)):
				var _t205 = _s83["w"]
				var _t206 = (2.6 + (randf() * 1.5))
				J.sp(_t205, "look", _t206)
				var _t207 = _s83["w"]
				J.sp(_t207, "lt", 0.0)
				var _t208 = _s83["w"]
				var _t209 = (1.0 if J.cmp(J.gp(J.gp(J.G.get("GS_STALLS"), J.gp(_s83["w"], "toStall")), "x"), J.gp(_s83["w"], "x"), ">=") else (-1.0))
				J.sp(_t208, "dir", _t209)
				var _t210 = _s83["w"]
				J.sp(_t210, "toStall", null)
			var _t211 = _s83["w"]
			J.sp(_t211, "walking", false)
			var _t212 = _s83["w"]
			var _t213 = J.sub(J.gp(_t212, "wait"), _s83["__p"]["dt"])
			J.sp(_t212, "wait", _t213)
			if J.cmp(J.gp(_s83["w"], "wait"), 0.0, "<="):
				var _t214 = _s83["w"]
				var _t215 = (2.0 + (randf() * 5.0))
				J.sp(_t214, "wait", _t215)
				v_st_176 = J.gp(J.G.get("GS_ORDER"), floor(J.num((randf() * 4.0))))
				var _t216 = J.seq(J.gp(J.gp(_s83["__p"]["this"], "view"), "k"), "idle")
				var _t217 = ((randf() < 0.3) if _t216 else _t216)
				var _t218 = (J.gp(_s83["w"], "prop") if _t217 else _t217)
				if J.t(((absf(J.num(J.sub(J.gp(J.gp(J.G.get("GS_STALLS"), v_st_176), "x"), J.gp(_s83["w"], "x")))) < 0.4) if J.t(_t218) else _t218)):
					var _t219 = _s83["w"]
					var _t220 = J.mc(_s83["__p"]["this"], "avoid", [J.add(J.gp(J.gp(J.G.get("GS_STALLS"), v_st_176), "x"), ((randf() - 0.5) * 0.07))])
					J.sp(_t219, "tx", _t220)
					var _t221 = _s83["w"]
					var _t222 = (0.79 + (randf() * 0.03))
					J.sp(_t221, "ty", _t222)
					var _t223 = _s83["w"]
					J.sp(_t223, "toStall", v_st_176)
				else:
					var _t224 = _s83["w"]
					var _t225 = J.mc(_s83["__p"]["this"], "avoid", [J.add(J.gp(_s83["w"], "x"), ((randf() - 0.5) * 0.3))])
					J.sp(_t224, "tx", _t225)
					var _t226 = _s83["w"]
					var _t227 = ((0.86 + (randf() * 0.07)) if (not J.seq(J.gp(J.gp(_s83["__p"]["this"], "view"), "k"), "idle")) else (0.79 + (randf() * 0.13)))
					J.sp(_t226, "ty", _t227)
					var _t228 = _s83["w"]
					J.sp(_t228, "toStall", null)
		var _t229 = _s83["w"]
		var _t230 = J.sub(J.gp(_t229, "chatT"), _s83["__p"]["dt"])
		J.sp(_t229, "chatT", _t230)
		if J.cmp(J.gp(_s83["w"], "chatT"), 0.0, "<="):
			var _t231 = _s83["w"]
			var _t232 = (7.0 + (randf() * 8.0))
			J.sp(_t231, "chatT", _t232)
			var _t233 = J.cmp(J.mc(_s83["__p"]["this"], "X", [J.gp(_s83["w"], "x")]), 20.0, ">")
			v_vis_177 = (J.cmp(J.mc(_s83["__p"]["this"], "X", [J.gp(_s83["w"], "x")]), J.sub(J.gp(_s83["__p"]["this"], "W"), 20.0), "<") if _t233 else _t233)
			var _t235 = (not J.seq(J.gp(J.gp(_s83["__p"]["this"], "view"), "k"), "idle"))
			if not J.t(_t235):
				var _t234 = J.S_Object_("values", [J.gp(_s83["__p"]["this"], "keepers")])
				_t235 = J.mc(_t234, "some", [Callable(self, "_f46").bind(_s83)])
			v_busy_178 = _t235
			var _t238 = ((not J.t(v_busy_178)) if J.t(v_vis_177) else v_vis_177)
			if J.t(_t238):
				var _t236 = J.gp(_s83["__p"]["this"], "walkers")
				_t238 = (not J.t(J.mc(_t236, "some", [Callable(self, "_f47").bind(_s83)])))
			if J.t(_t238):
				J.mc(_s83["__p"]["this"], "chat", [_s83["w"]])
	var _t239 = _s71["this"]
	var _t240 = J.sub(J.gp(_t239, "bumpCD"), _s71["dt"])
	J.sp(_t239, "bumpCD", _t240)
	v_i_181 = 0.0
	while true:
		if not J.cmp(v_i_181, J.len(J.gp(_s71["this"], "walkers")), "<"): break
		v_j_182 = J.add(v_i_181, 1.0)
		while true:
			if not J.cmp(v_j_182, J.len(J.gp(_s71["this"], "walkers")), "<"): break
			v_P_183 = J.gp(J.gp(_s71["this"], "walkers"), v_i_181)
			v_Q_184 = J.gp(J.gp(_s71["this"], "walkers"), v_j_182)
			var _t241 = J.gp(v_P_183, "walking")
			var _t242 = (J.gp(v_Q_184, "walking") if J.t(_t241) else _t241)
			var _t243 = (J.gp(v_P_183, "prop") if J.t(_t242) else _t242)
			var _t244 = (J.gp(v_Q_184, "prop") if J.t(_t243) else _t243)
			var _t245 = ((not J.seq(J.gp(v_P_183, "dir"), J.gp(v_Q_184, "dir"))) if J.t(_t244) else _t244)
			var _t246 = ((absf(J.num(J.sub(J.gp(v_P_183, "x"), J.gp(v_Q_184, "x")))) < 0.03) if J.t(_t245) else _t245)
			var _t247 = ((absf(J.num(J.sub(J.gp(v_P_183, "y"), J.gp(v_Q_184, "y")))) < 0.03) if J.t(_t246) else _t246)
			if J.t(((J.mul(J.sub(J.gp(v_Q_184, "x"), J.gp(v_P_183, "x")), J.gp(v_P_183, "dir")) > 0.0) if J.t(_t247) else _t247)):
				for _t248 in J.iter([v_P_183, v_Q_184]):
					v_W_185 = _t248
					J.sp(v_W_185, "bump", 1.8)
					J.sp(v_W_185, "bt", 0.0)
					var _t249 = J.gp(v_W_185, "x")
					J.sp(v_W_185, "tx", _t249)
					var _t250 = J.gp(v_W_185, "y")
					J.sp(v_W_185, "ty", _t250)
					J.sp(v_W_185, "toStall", null)
					var _t251 = (0.5 + randf())
					J.sp(v_W_185, "wait", _t251)
					var _t252 = J.gp(J.G.get("GS_SORRY"), floor(J.num((randf() * J.len(J.G.get("GS_SORRY"))))))
					J.sp(v_W_185, "sorry", _t252)
			v_j_182 = J.num(v_j_182) + 1.0
		v_i_181 = J.num(v_i_181) + 1.0
	var _t253 = J.cmp(J.gp(_s71["this"], "bumpCD"), 0.0, "<=")
	if (J.seq(J.gp(J.gp(_s71["this"], "view"), "k"), "idle") if _t253 else _t253):
		var _t254 = _s71["this"]
		var _t255 = (16.0 + (randf() * 12.0))
		J.sp(_t254, "bumpCD", _t255)
		var _t256 = J.gp(_s71["this"], "walkers")
		v_vis_186 = J.mc(_t256, "filter", [Callable(self, "_f48").bind(_s71)])
		if (J.len(v_vis_186) >= 2.0):
			v_P_188 = J.gp(v_vis_186, 0.0)
			v_Q_189 = J.gp(v_vis_186, 1.0)
			v_mid_190 = J.div(J.add(J.gp(v_P_188, "x"), J.gp(v_Q_189, "x")), 2.0)
			v_yy_191 = (0.83 + (randf() * 0.06))
			v_l_192 = J.cmp(J.gp(v_P_188, "x"), J.gp(v_Q_189, "x"), "<")
			J.sp(v_Q_189, "ty", v_yy_191)
			J.sp(v_P_188, "ty", v_yy_191)
			var _t261 = J.mc(_s71["this"], "avoid", [J.add(v_mid_190, (0.07 if J.t(v_l_192) else (-0.07)))])
			J.sp(v_P_188, "tx", _t261)
			var _t262 = J.mc(_s71["this"], "avoid", [J.add(v_mid_190, ((-0.07) if J.t(v_l_192) else 0.07))])
			J.sp(v_Q_189, "tx", _t262)
			J.sp(v_Q_189, "wait", 8.0)
			J.sp(v_P_188, "wait", 8.0)
			J.sp(v_Q_189, "toStall", null)
			J.sp(v_P_188, "toStall", null)
	if (randf() < J.mul(_s71["dt"], 1.6)):
		var _t263 = J.gp(_s71["this"], "parts")
		J.mc(_t263, "push", [J.mc(_s71["this"], "mkJoss", [false])])
	if (randf() < J.mul(_s71["dt"], 5.0)):
		var _t264 = J.gp(_s71["this"], "parts")
		J.mc(_t264, "push", [{"kind": "steam", "x": (0.752 + ((randf() - 0.5) * 0.02)), "y": 0.515, "vx": ((randf() - 0.5) * 0.004), "vy": ((-0.035) - (randf() * 0.02)), "life": 2.2, "max": 2.2, "r": (4.0 + (randf() * 4.0))}])
	if (randf() < J.mul(_s71["dt"], 1.2)):
		var _t265 = J.gp(_s71["this"], "parts")
		J.mc(_t265, "push", [{"kind": "mist", "x": (0.9 + (randf() * 0.08)), "y": (0.6 + (randf() * 0.2)), "vx": ((-0.006) - (randf() * 0.01)), "vy": (-0.004), "life": 4.0, "max": 4.0, "r": (20.0 + (randf() * 30.0))}])
	var _t266 = _s71["this"]
	var _t267 = J.gp(_s71["this"], "parts")
	var _t274 = J.mc(_t267, "filter", [Callable(self, "_f49").bind(_s71)])
	J.sp(_t266, "parts", _t274)
	for _t275 in J.iter(J.gp(_s71["this"], "fog")):
		v_f_194 = _t275
		var _t276 = J.add(J.gp(v_f_194, "x"), J.mul(J.gp(v_f_194, "v"), _s71["dt"]))
		J.sp(v_f_194, "x", _t276)
		if J.cmp(J.gp(v_f_194, "x"), 1.2, ">"):
			var _t277 = (-0.2)
			J.sp(v_f_194, "x", _t277)
		if J.cmp(J.gp(v_f_194, "x"), (-0.2), "<"):
			J.sp(v_f_194, "x", 1.2)
	var _t278 = _s71["this"]
	var _t279 = J.gp(_s71["this"], "floats")
	var _t281 = J.mc(_t279, "filter", [Callable(self, "_f50").bind(_s71)])
	J.sp(_t278, "floats", _t281)
	var _t282 = J.G.get("$")
	v_c_163 = J.cl(_t282, null, ["#gs-coins i"])
	if J.t(v_c_163):
		var _t283 = J.G.get("fmt")
		v_v_196 = J.cl(_t283, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])
		if (not J.seq(J.gp(v_c_163, "textContent"), v_v_196)):
			J.sp(v_c_163, "textContent", v_v_196)

func _f51(this_, a: Array, env):
	var v_init_199 = null
	v_init_199 = J.arg(a, 0)
	return {"kind": "joss", "x": J.sub(J.add(J.gp(this_, "cam"), (randf() * 1.3)), 0.15), "y": ((randf() * 0.8) if J.t(v_init_199) else (-0.05)), "bx": ((randf() - 0.5) * 0.01), "vx": 0.0, "vy": (0.025 + (randf() * 0.025)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 2.0), "flip": (randf() * 6.0), "vf": (2.0 + (randf() * 3.0)), "sw": (0.8 + randf()), "ph": (randf() * 6.0), "land": (0.8 + (randf() * 0.17)), "life": ((10.0 + (randf() * 10.0)) if J.t(v_init_199) else 24.0), "max": 24.0}

func _f52(this_, a: Array, env):
	var v_nx_202 = null; var v_i_203 = null; var v_hit_204 = null; var v_k_205 = null; var v_kx_206 = null
	v_nx_202 = J.arg(a, 0)
	var _t284 = J.max_([0.03, J.min_([0.9, v_nx_202])])
	v_nx_202 = _t284
	v_i_203 = 0.0
	while true:
		if not J.cmp(v_i_203, 4.0, "<"): break
		v_hit_204 = false
		for _t285 in J.keys(J.gp(this_, "keepers")):
			v_k_205 = _t285
			v_kx_206 = J.gp(J.gp(J.gp(this_, "keepers"), v_k_205), "x")
			if (absf(J.num(J.sub(v_nx_202, v_kx_206))) < 0.05):
				var _t286 = J.add(v_kx_206, ((-0.06) if J.cmp(v_nx_202, v_kx_206, "<") else 0.06))
				v_nx_202 = _t286
				v_hit_204 = true
		var _t287 = (not J.seq(J.gp(J.gp(this_, "view"), "k"), "idle"))
		if ((absf(J.num(J.sub(v_nx_202, J.gp(J.gp(this_, "afu"), "x")))) < 0.15) if _t287 else _t287):
			var _t288 = J.add(J.gp(J.gp(this_, "afu"), "x"), ((-0.17) if J.cmp(v_nx_202, J.gp(J.gp(this_, "afu"), "x"), "<") else 0.17))
			v_nx_202 = _t288
			v_hit_204 = true
		var _t289 = J.max_([0.03, J.min_([0.9, v_nx_202])])
		v_nx_202 = _t289
		if (not J.t(v_hit_204)):
			break
		v_i_203 = J.num(v_i_203) + 1.0
	return v_nx_202

func _f53(this_, a: Array, env):
	var v_w_209 = null; var v_force_210 = null; var v_line_211 = null; var v_i_212 = null
	v_w_209 = J.arg(a, 0)
	v_force_210 = J.arg(a, 1)
	v_line_211 = null
	v_i_212 = 0.0
	var _t290 = true
	while true:
		if not _t290:
			var _t291 = J.gp(this_, "chatUsed")
			var _t292 = J.mc(_t291, "has", [v_line_211])
			if not J.t((J.cmp(v_i_212, 40.0, "<") if J.t(_t292) else _t292)): break
		_t290 = false
		var _t293 = J.G.get("pick")
		var _t294 = J.cl(_t293, null, [J.G.get("GS_CHATTER")])
		v_line_211 = _t294
		v_i_212 = J.num(v_i_212) + 1.0
	if J.cmp(J.gp(J.gp(this_, "chatUsed"), "size"), (J.len(J.G.get("GS_CHATTER")) - 6.0), ">"):
		J.mc(J.gp(this_, "chatUsed"), "clear", [])
	var _t295 = J.gp(this_, "chatUsed")
	J.mc(_t295, "add", [v_line_211])
	J.mc(this_, "say", [v_w_209, v_line_211, (3.6 if J.t(v_force_210) else 3.2)])

func _f54(this_, a: Array, env):
	var v_o_215 = null; var v_text_216 = null; var v_dur_217 = null
	v_o_215 = J.arg(a, 0)
	v_text_216 = J.arg(a, 1)
	v_dur_217 = J.arg(a, 2)
	if (not J.t(v_o_215)):
		return null
	J.sp(v_o_215, "bub", v_text_216)
	var _t296 = (v_dur_217 if J.t(v_dur_217) else 3.0)
	J.sp(v_o_215, "bubT", _t296)

func _f56(this_, a: Array, env):
	var v_f_225 = null
	v_f_225 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_225, "life"), 0.9, ">")

func _f55(this_, a: Array, env):
	var v_fx_220 = null; var v_fy_221 = null; var v_text_222 = null; var v_col_223 = null; var v_n_224 = null
	v_fx_220 = J.arg(a, 0)
	v_fy_221 = J.arg(a, 1)
	v_text_222 = J.arg(a, 2)
	v_col_223 = J.arg(a, 3)
	var _t297 = J.gp(this_, "floats")
	v_n_224 = J.len(J.mc(_t297, "filter", [Callable(self, "_f56").bind(env)]))
	var _t298 = J.gp(this_, "floats")
	J.mc(_t298, "push", [{"x": v_fx_220, "y": J.add(v_fy_221, J.mul(v_n_224, 0.05)), "text": v_text_222, "col": (v_col_223 if J.t(v_col_223) else "#ffe08a"), "life": 1.8, "max": 1.8}])

func _f58(this_, a: Array, env):
	var v_lx_238 = null; var v_ly_239 = null; var v_i_240 = null; var v_fl_241 = null
	var _t311 = J.gp(J.arg(a, 0), 0.0)
	v_lx_238 = _t311
	var _t312 = J.gp(J.arg(a, 0), 1.0)
	v_ly_239 = _t312
	v_i_240 = J.arg(a, 1)
	v_fl_241 = ((0.16 + (0.07 * sin(J.num((J.mul(env["t"], 3.1) + J.mul(v_i_240, 1.7)))))) + (0.04 * sin(J.num(J.add(J.mul(env["t"], 7.3), v_i_240)))))
	J.mc(env["this"], "glow", [env["ctx"], J.add(J.mc(env["this"], "X", [v_lx_238]), (sin(J.num(J.add(J.mul(env["t"], 1.3), v_i_240))) * 2.0)), J.mc(env["this"], "Y", [v_ly_239]), J.mul(J.gp(env["g"], "IH"), 0.06), ("rgba(255,120,60," + J.str(v_fl_241) + ")")])

func _f59(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "drawKeeper", [env["__p"]["ctx"], env["k"], env["__p"]["t"]])

func _f60(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "drawWalker", [env["__p"]["ctx"], env["w"], env["__p"]["t"]])

func _f61(this_, a: Array, env):
	return J.mc(env["this"], "drawAfu", [env["ctx"], env["t"]])

func _f62(this_, a: Array, env):
	var v_a_244 = null; var v_b_245 = null
	v_a_244 = J.arg(a, 0)
	v_b_245 = J.arg(a, 1)
	return J.sub(J.gp(v_a_244, "y"), J.gp(v_b_245, "y"))

func _f63(this_, a: Array, env):
	var v_o_246 = null
	v_o_246 = J.arg(a, 0)
	return J.mc(v_o_246, "f", [])

func _f57(this_, a: Array, env):
	var v_c_229 = null; var v_dp_231 = null; var v_W_233 = null; var v_H_234 = null; var v_img_235 = null; var v_bot_236 = null; var v_list_237 = null; var v_k_247 = null; var v_kp_248 = null; var v_w_249 = null; var v_f_250 = null; var v_k_251 = null; var v_x_252 = null; var v_y_253 = null
	var _s125 = {"__p": env, "this": null, "t": null, "ctx": null, "g": null}
	_s125["this"] = this_
	_s125["t"] = J.arg(a, 0)
	var _t299 = J.gp(_s125["this"], "_nat")
	var _t300 = (J.gp(_s125["this"], "_natCtx") if J.t(_t299) else _t299)
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_gsDraw")), "undefined")) if J.t(_t300) else _t300)):
		var _t301 = J.G.get("__nat_gsDraw")
		J.cl(_t301, null, [J.gp(_s125["this"], "_natCtx"), _s125["this"], _s125["t"]])
		return null
	var _t302 = J.gp(_s125["this"], "_nat")
	if J.t(((not J.t(J.gp(_s125["this"], "_natCtx"))) if J.t(_t302) else _t302)):
		return null
	var _t304 = null
	if J.t(J.gp(_s125["this"], "_natCtx")):
		_t304 = null
	else:
		var _t303 = J.G.get("$")
		_t304 = J.cl(_t303, null, ["#gs-cvs"])
	v_c_229 = _t304
	var _t305 = (not J.t(J.gp(_s125["this"], "_natCtx")))
	if ((not J.t(v_c_229)) if _t305 else _t305):
		return null
	var _t306 = J.gp(_s125["this"], "_natCtx")
	_s125["ctx"] = (_t306 if J.t(_t306) else J.mc(v_c_229, "getContext", ["2d"]))
	v_dp_231 = (1.0 if J.t(J.gp(_s125["this"], "_natCtx")) else J.gp(_s125["this"], "dpr"))
	J.mc(_s125["ctx"], "setTransform", [v_dp_231, 0.0, 0.0, v_dp_231, 0.0, 0.0])
	_s125["g"] = J.mc(_s125["this"], "geo", [])
	v_W_233 = J.gp(_s125["this"], "W")
	v_H_234 = J.gp(_s125["this"], "H")
	v_img_235 = J.gp(J.G.get("SPR"), "bg_street")
	var _t307 = _s125["ctx"]
	J.sp(_t307, "fillStyle", "#0c0a12")
	J.mc(_s125["ctx"], "fillRect", [0.0, 0.0, v_W_233, v_H_234])
	var _t308 = (J.gp(v_img_235, "complete") if J.t(v_img_235) else v_img_235)
	if J.t((J.gp(v_img_235, "naturalWidth") if J.t(_t308) else _t308)):
		J.mc(_s125["ctx"], "drawImage", [v_img_235, J.mul((-J.num(J.gp(_s125["this"], "cam"))), J.gp(_s125["g"], "IW")), 0.0, J.gp(_s125["g"], "IW"), J.gp(_s125["g"], "IH")])
	v_bot_236 = J.mc(_s125["ctx"], "createLinearGradient", [0.0, J.sub(J.gp(_s125["g"], "IH"), 30.0), 0.0, J.add(J.gp(_s125["g"], "IH"), 40.0)])
	J.mc(v_bot_236, "addColorStop", [0.0, "rgba(12,10,18,0)"])
	J.mc(v_bot_236, "addColorStop", [1.0, "rgba(12,10,18,1)"])
	var _t309 = _s125["ctx"]
	J.sp(_t309, "fillStyle", v_bot_236)
	J.mc(_s125["ctx"], "fillRect", [0.0, J.sub(J.gp(_s125["g"], "IH"), 30.0), v_W_233, (J.sub(v_H_234, J.gp(_s125["g"], "IH")) + 30.0)])
	J.mc(_s125["ctx"], "save", [])
	var _t310 = _s125["ctx"]
	J.sp(_t310, "globalCompositeOperation", "lighter")
	J.mc(_s125["this"], "glow", [_s125["ctx"], J.mc(_s125["this"], "X", [0.785]), J.mc(_s125["this"], "Y", [0.085]), J.mul(J.gp(_s125["g"], "IH"), 0.16), ("rgba(140,255,170," + J.str((0.1 + (0.04 * sin(J.num(J.mul(_s125["t"], 0.8)))))) + ")")])
	J.mc(J.G.get("GS_LANTERNS"), "forEach", [Callable(self, "_f58").bind(_s125)])
	J.mc(_s125["this"], "glow", [_s125["ctx"], J.mc(_s125["this"], "X", [0.58]), J.mc(_s125["this"], "Y", [0.52]), J.mul(J.gp(_s125["g"], "IH"), 0.12), ("rgba(255,200,110," + J.str((0.08 + (0.03 * sin(J.num(J.mul(_s125["t"], 2.0)))))) + ")")])
	J.mc(_s125["ctx"], "restore", [])
	J.mc(_s125["this"], "drawFog", [_s125["ctx"], _s125["t"], false])
	J.mc(_s125["this"], "drawParts", [_s125["ctx"], "steam"])
	v_list_237 = []
	for _t313 in J.keys(J.gp(_s125["this"], "keepers")):
		var _s128 = {"__p": _s125, "k": null}
		_s128["k"] = _t313
		J.mc(v_list_237, "push", [{"y": J.gp(J.gp(J.gp(_s128["__p"]["this"], "keepers"), _s128["k"]), "y"), "f": Callable(self, "_f59").bind(_s128)}])
	for _t314 in J.iter(J.gp(_s125["this"], "walkers")):
		var _s130 = {"__p": _s125, "w": null}
		_s130["w"] = _t314
		J.mc(v_list_237, "push", [{"y": J.gp(_s130["w"], "y"), "f": Callable(self, "_f60").bind(_s130)}])
	J.mc(v_list_237, "push", [{"y": J.gp(J.gp(_s125["this"], "afu"), "y"), "f": Callable(self, "_f61").bind(_s125)}])
	J.mc(_s125["this"], "drawParts", [_s125["ctx"], "dust"])
	var _t315 = J.mc(v_list_237, "sort", [Callable(self, "_f62").bind(_s125)])
	J.mc(_t315, "forEach", [Callable(self, "_f63").bind(_s125)])
	J.mc(_s125["this"], "drawFog", [_s125["ctx"], _s125["t"], true])
	J.mc(_s125["this"], "drawParts", [_s125["ctx"], "mist"])
	J.mc(_s125["this"], "drawParts", [_s125["ctx"], "joss"])
	J.mc(_s125["this"], "drawLanternString", [_s125["ctx"], _s125["t"]])
	J.mc(_s125["this"], "drawSigns", [_s125["ctx"], _s125["t"]])
	for _t316 in J.keys(J.gp(_s125["this"], "keepers")):
		v_k_247 = _t316
		v_kp_248 = J.gp(J.gp(_s125["this"], "keepers"), v_k_247)
		if J.cmp(J.gp(v_kp_248, "bubT"), 0.0, ">"):
			J.mc(_s125["this"], "bubble", [_s125["ctx"], v_kp_248, J.gp(v_kp_248, "bub"), J.gp(v_kp_248, "bubT")])
	for _t317 in J.iter(J.gp(_s125["this"], "walkers")):
		v_w_249 = _t317
		if J.cmp(J.gp(v_w_249, "bubT"), 0.0, ">"):
			J.mc(_s125["this"], "bubble", [_s125["ctx"], v_w_249, J.gp(v_w_249, "bub"), J.gp(v_w_249, "bubT")])
	var _t318 = _s125["ctx"]
	J.sp(_t318, "textAlign", "center")
	var _t319 = _s125["ctx"]
	var _t320 = J.add("900 17px ", J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily"))
	J.sp(_t319, "font", _t320)
	for _t321 in J.iter(J.gp(_s125["this"], "floats")):
		v_f_250 = _t321
		v_k_251 = J.div(J.gp(v_f_250, "life"), J.gp(v_f_250, "max"))
		v_x_252 = J.mc(_s125["this"], "X", [J.gp(v_f_250, "x")])
		v_y_253 = J.sub(J.mc(_s125["this"], "Y", [J.gp(v_f_250, "y")]), (J.sub(1.0, v_k_251) * 40.0))
		var _t322 = _s125["ctx"]
		var _t323 = J.min_([1.0, J.mul(v_k_251, 2.0)])
		J.sp(_t322, "globalAlpha", _t323)
		var _t324 = _s125["ctx"]
		J.sp(_t324, "lineWidth", 4.0)
		var _t325 = _s125["ctx"]
		J.sp(_t325, "strokeStyle", "rgba(0,0,0,.8)")
		J.mc(_s125["ctx"], "strokeText", [J.gp(v_f_250, "text"), v_x_252, v_y_253])
		var _t326 = _s125["ctx"]
		var _t327 = J.gp(v_f_250, "col")
		J.sp(_t326, "fillStyle", _t327)
		J.mc(_s125["ctx"], "fillText", [J.gp(v_f_250, "text"), v_x_252, v_y_253])
	var _t328 = _s125["ctx"]
	J.sp(_t328, "globalAlpha", 1.0)

func _f64(this_, a: Array, env):
	var v_ctx_256 = null; var v_x_257 = null; var v_y_258 = null; var v_r_259 = null; var v_col_260 = null; var v_gr_261 = null
	v_ctx_256 = J.arg(a, 0)
	v_x_257 = J.arg(a, 1)
	v_y_258 = J.arg(a, 2)
	v_r_259 = J.arg(a, 3)
	v_col_260 = J.arg(a, 4)
	v_gr_261 = J.mc(v_ctx_256, "createRadialGradient", [v_x_257, v_y_258, 0.0, v_x_257, v_y_258, v_r_259])
	J.mc(v_gr_261, "addColorStop", [0.0, v_col_260])
	J.mc(v_gr_261, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_ctx_256, "fillStyle", v_gr_261)
	J.mc(v_ctx_256, "fillRect", [J.sub(v_x_257, v_r_259), J.sub(v_y_258, v_r_259), J.mul(v_r_259, 2.0), J.mul(v_r_259, 2.0)])

func _f66(this_, a: Array, env):
	var v_f_268 = null; var v_i_269 = null; var v_x_270 = null; var v_y_271 = null; var v_r_272 = null; var v_gr_273 = null; var v_a_274 = null
	v_f_268 = J.arg(a, 0)
	v_i_269 = J.arg(a, 1)
	if (not J.seq(J.cmp(J.gp(v_f_268, "y"), 0.84, ">"), env["front"])):
		return null
	v_x_270 = J.mc(env["this"], "X", [(J.mul(J.gp(v_f_268, "x"), 1.0) + J.mul(J.gp(env["this"], "cam"), ((-0.15) if J.t(env["front"]) else 0.0)))])
	v_y_271 = J.mc(env["this"], "Y", [J.gp(v_f_268, "y")])
	v_r_272 = (J.mul(J.gp(v_f_268, "r"), J.gp(env["g"], "IW")) * 0.5)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_270, v_y_271])
	J.mc(env["ctx"], "scale", [1.0, 0.32])
	v_gr_273 = J.mc(env["ctx"], "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, v_r_272])
	v_a_274 = J.mul(J.gp(v_f_268, "a"), (0.8 + (0.2 * sin(J.num(J.add(J.mul(env["t"], 0.7), v_i_269))))))
	J.mc(v_gr_273, "addColorStop", [0.0, ("rgba(200,190,230," + J.str(v_a_274) + ")")])
	J.mc(v_gr_273, "addColorStop", [1.0, "rgba(200,190,230,0)"])
	var _t330 = env["ctx"]
	J.sp(_t330, "fillStyle", v_gr_273)
	J.mc(env["ctx"], "fillRect", [(-J.num(v_r_272)), (-J.num(v_r_272)), J.mul(v_r_272, 2.0), J.mul(v_r_272, 2.0)])
	J.mc(env["ctx"], "restore", [])

func _f65(this_, a: Array, env):
	var _s141 = {"__p": env, "this": null, "ctx": null, "t": null, "front": null, "g": null}
	_s141["this"] = this_
	_s141["ctx"] = J.arg(a, 0)
	_s141["t"] = J.arg(a, 1)
	_s141["front"] = J.arg(a, 2)
	_s141["g"] = J.mc(_s141["this"], "geo", [])
	var _t329 = J.gp(_s141["this"], "fog")
	J.mc(_t329, "forEach", [Callable(self, "_f66").bind(_s141)])

func _f67(this_, a: Array, env):
	var v_ctx_277 = null; var v_kind_278 = null; var v_g_279 = null; var v_p_280 = null; var v_x_281 = null; var v_y_282 = null; var v_k_283 = null; var v_sz_284 = null; var v_r_285 = null; var v_r_286 = null; var v_gr_287 = null; var v_r_288 = null
	v_ctx_277 = J.arg(a, 0)
	v_kind_278 = J.arg(a, 1)
	v_g_279 = J.mc(this_, "geo", [])
	for _t331 in J.iter(J.gp(this_, "parts")):
		v_p_280 = _t331
		if (not J.seq(J.gp(v_p_280, "kind"), v_kind_278)):
			continue
		v_x_281 = J.mc(this_, "X", [J.gp(v_p_280, "x")])
		v_y_282 = J.mc(this_, "Y", [J.gp(v_p_280, "y")])
		v_k_283 = J.div(J.gp(v_p_280, "life"), J.gp(v_p_280, "max"))
		var _t332 = J.cmp(v_x_281, (-60.0), "<")
		if (_t332 if _t332 else J.cmp(v_x_281, J.add(J.gp(this_, "W"), 60.0), ">")):
			continue
		if J.seq(v_kind_278, "joss"):
			v_sz_284 = J.mul(J.gp(v_g_279, "IH"), 0.016)
			J.mc(v_ctx_277, "save", [])
			var _t333 = (J.min_([1.0, J.mul(J.gp(v_p_280, "life"), 0.6)]) * 0.92)
			J.sp(v_ctx_277, "globalAlpha", _t333)
			J.mc(v_ctx_277, "translate", [v_x_281, v_y_282])
			J.mc(v_ctx_277, "rotate", [J.gp(v_p_280, "rot")])
			J.mc(v_ctx_277, "scale", [1.0, cos(J.num(J.gp(v_p_280, "flip")))])
			J.sp(v_ctx_277, "fillStyle", "#e8c35a")
			J.sp(v_ctx_277, "strokeStyle", "#6a4a14")
			J.sp(v_ctx_277, "lineWidth", 0.8)
			J.mc(v_ctx_277, "fillRect", [(-J.num(v_sz_284)), ((-J.num(v_sz_284)) * 0.7), J.mul(v_sz_284, 2.0), J.mul(v_sz_284, 1.4)])
			J.mc(v_ctx_277, "strokeRect", [(-J.num(v_sz_284)), ((-J.num(v_sz_284)) * 0.7), J.mul(v_sz_284, 2.0), J.mul(v_sz_284, 1.4)])
			J.sp(v_ctx_277, "fillStyle", "#b8322a")
			J.mc(v_ctx_277, "fillRect", [((-J.num(v_sz_284)) * 0.35), ((-J.num(v_sz_284)) * 0.35), J.mul(v_sz_284, 0.7), J.mul(v_sz_284, 0.7)])
			J.mc(v_ctx_277, "restore", [])
		else:
			if J.seq(v_kind_278, "steam"):
				v_r_285 = J.div(J.mul(J.mul(J.gp(v_p_280, "r"), J.sub(2.0, v_k_283)), J.gp(v_g_279, "IH")), 500.0)
				var _t334 = ("rgba(240,235,255," + J.str(((J.mul(0.22, v_k_283) * J.sub(1.0, v_k_283)) * 3.0)) + ")")
				J.sp(v_ctx_277, "fillStyle", _t334)
				J.mc(v_ctx_277, "beginPath", [])
				J.mc(v_ctx_277, "arc", [J.add(v_x_281, (sin(J.num(J.add(J.mul(J.gp(v_p_280, "life"), 3.0), J.gp(v_p_280, "r")))) * 4.0)), v_y_282, v_r_285, 0.0, 7.0])
				J.mc(v_ctx_277, "fill", [])
			else:
				if J.seq(v_kind_278, "mist"):
					v_r_286 = (J.div(J.mul(J.gp(v_p_280, "r"), J.gp(v_g_279, "IH")), 500.0) * (1.6 - J.mul(v_k_283, 0.6)))
					v_gr_287 = J.mc(v_ctx_277, "createRadialGradient", [v_x_281, v_y_282, 0.0, v_x_281, v_y_282, v_r_286])
					J.mc(v_gr_287, "addColorStop", [0.0, ("rgba(210,220,240," + J.str((0.16 * sin(J.num(J.mul(v_k_283, PI))))) + ")")])
					J.mc(v_gr_287, "addColorStop", [1.0, "rgba(210,220,240,0)"])
					J.sp(v_ctx_277, "fillStyle", v_gr_287)
					J.mc(v_ctx_277, "fillRect", [J.sub(v_x_281, v_r_286), J.sub(v_y_282, v_r_286), J.mul(v_r_286, 2.0), J.mul(v_r_286, 2.0)])
				else:
					if J.seq(v_kind_278, "dust"):
						v_r_288 = J.div(J.mul(J.mul(J.gp(v_p_280, "r"), J.sub(1.6, v_k_283)), J.gp(v_g_279, "IH")), 600.0)
						var _t335 = ("rgba(190,170,200," + J.str(J.mul(0.4, v_k_283)) + ")")
						J.sp(v_ctx_277, "fillStyle", _t335)
						J.mc(v_ctx_277, "beginPath", [])
						J.mc(v_ctx_277, "ellipse", [v_x_281, v_y_282, J.mul(v_r_288, 1.4), J.mul(v_r_288, 0.8), 0.0, 0.0, 7.0])
						J.mc(v_ctx_277, "fill", [])

func _f68(this_, a: Array, env):
	var v_ctx_291 = null; var v_t_292 = null; var v_g_293 = null; var v_par_294 = null; var v_top_295 = null; var v_sag_296 = null; var v_gap_297 = null; var v_off_298 = null; var v_n0_299 = null; var v_i_300 = null; var v_x0_301 = null; var v_x1_302 = null; var v_mx_303 = null; var v_my_304 = null; var v_sw_305 = null; var v_L_306 = null; var v_r_307 = null
	v_ctx_291 = J.arg(a, 0)
	v_t_292 = J.arg(a, 1)
	v_g_293 = J.mc(this_, "geo", [])
	v_par_294 = 1.25
	v_top_295 = (-4.0)
	v_sag_296 = J.mul(J.gp(v_g_293, "IH"), 0.06)
	v_gap_297 = J.mul(J.gp(v_g_293, "IW"), 0.16)
	v_off_298 = J.mul(J.mul((-J.num(J.gp(this_, "cam"))), J.gp(v_g_293, "IW")), v_par_294)
	v_n0_299 = (floor(J.num(J.div((-J.num(v_off_298)), v_gap_297))) - 1.0)
	J.mc(v_ctx_291, "save", [])
	J.sp(v_ctx_291, "strokeStyle", "rgba(30,18,24,.9)")
	J.sp(v_ctx_291, "lineWidth", 1.6)
	v_i_300 = v_n0_299
	while true:
		if not J.cmp(v_i_300, J.add(J.add(v_n0_299, ceil(J.num(J.div(J.gp(this_, "W"), v_gap_297)))), 3.0), "<"): break
		v_x0_301 = J.add(v_off_298, J.mul(v_i_300, v_gap_297))
		v_x1_302 = J.add(v_x0_301, v_gap_297)
		J.mc(v_ctx_291, "beginPath", [])
		J.mc(v_ctx_291, "moveTo", [v_x0_301, v_top_295])
		J.mc(v_ctx_291, "quadraticCurveTo", [J.div(J.add(v_x0_301, v_x1_302), 2.0), J.add(v_top_295, J.mul(v_sag_296, 2.0)), v_x1_302, v_top_295])
		J.mc(v_ctx_291, "stroke", [])
		v_mx_303 = J.div(J.add(v_x0_301, v_x1_302), 2.0)
		v_my_304 = J.add(v_top_295, v_sag_296)
		v_sw_305 = (sin(J.num((J.mul(v_t_292, 1.6) + J.mul(v_i_300, 1.3)))) * 0.22)
		v_L_306 = J.mul(J.gp(v_g_293, "IH"), 0.035)
		v_r_307 = J.mul(J.gp(v_g_293, "IH"), 0.028)
		J.mc(v_ctx_291, "save", [])
		J.mc(v_ctx_291, "translate", [v_mx_303, v_my_304])
		J.mc(v_ctx_291, "rotate", [v_sw_305])
		J.mc(v_ctx_291, "beginPath", [])
		J.mc(v_ctx_291, "moveTo", [0.0, 0.0])
		J.mc(v_ctx_291, "lineTo", [0.0, v_L_306])
		J.mc(v_ctx_291, "stroke", [])
		J.sp(v_ctx_291, "globalCompositeOperation", "lighter")
		J.mc(this_, "glow", [v_ctx_291, 0.0, J.add(v_L_306, v_r_307), J.mul(v_r_307, 3.0), ("rgba(255,110,60," + J.str((0.22 + (0.06 * sin(J.num(J.add(J.mul(v_t_292, 4.0), v_i_300)))))) + ")")])
		J.sp(v_ctx_291, "globalCompositeOperation", "source-over")
		var _t336 = ("#f2e6c8" if J.seq(J.mod(v_i_300, 3.0), 1.0) else "#c8322a")
		J.sp(v_ctx_291, "fillStyle", _t336)
		J.sp(v_ctx_291, "strokeStyle", "#2a1010")
		J.sp(v_ctx_291, "lineWidth", 1.6)
		J.mc(v_ctx_291, "beginPath", [])
		J.mc(v_ctx_291, "ellipse", [0.0, J.add(v_L_306, v_r_307), J.mul(v_r_307, 0.85), v_r_307, 0.0, 0.0, 7.0])
		J.mc(v_ctx_291, "fill", [])
		J.mc(v_ctx_291, "stroke", [])
		J.sp(v_ctx_291, "strokeStyle", "rgba(40,10,10,.45)")
		J.sp(v_ctx_291, "lineWidth", 1.0)
		J.mc(v_ctx_291, "beginPath", [])
		J.mc(v_ctx_291, "ellipse", [0.0, J.add(v_L_306, v_r_307), J.mul(v_r_307, 0.4), v_r_307, 0.0, 0.0, 7.0])
		J.mc(v_ctx_291, "stroke", [])
		J.sp(v_ctx_291, "fillStyle", "#e2b04a")
		J.mc(v_ctx_291, "fillRect", [((-J.num(v_r_307)) * 0.45), J.sub(v_L_306, 2.0), J.mul(v_r_307, 0.9), 3.0])
		J.mc(v_ctx_291, "fillRect", [((-J.num(v_r_307)) * 0.45), J.sub(J.add(v_L_306, J.mul(v_r_307, 2.0)), 1.0), J.mul(v_r_307, 0.9), 3.0])
		J.sp(v_ctx_291, "strokeStyle", "#c8322a")
		J.sp(v_ctx_291, "lineWidth", 1.4)
		J.mc(v_ctx_291, "beginPath", [])
		J.mc(v_ctx_291, "moveTo", [0.0, J.add(J.add(v_L_306, J.mul(v_r_307, 2.0)), 2.0)])
		J.mc(v_ctx_291, "lineTo", [(sin(J.num(J.add(J.mul(v_t_292, 2.4), v_i_300))) * 2.0), J.add(J.add(v_L_306, J.mul(v_r_307, 2.0)), J.mul(v_r_307, 0.9))])
		J.mc(v_ctx_291, "stroke", [])
		J.mc(v_ctx_291, "restore", [])
		J.sp(v_ctx_291, "strokeStyle", "rgba(30,18,24,.9)")
		J.sp(v_ctx_291, "lineWidth", 1.6)
		v_i_300 = J.num(v_i_300) + 1.0
	J.mc(v_ctx_291, "restore", [])

func _f69(this_, a: Array, env):
	var v_ctx_310 = null; var v_t_311 = null; var v_near_312 = null; var v_fam_313 = null; var v_k_314 = null; var v_s_315 = null; var v_x_316 = null; var v_y_317 = null; var v_w_318 = null; var v_on_319 = null
	v_ctx_310 = J.arg(a, 0)
	v_t_311 = J.arg(a, 1)
	v_near_312 = J.mc(this_, "nearStall", [])
	v_fam_313 = J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily")
	J.mc(v_ctx_310, "save", [])
	var _t337 = J.add("800 14px ", v_fam_313)
	J.sp(v_ctx_310, "font", _t337)
	J.sp(v_ctx_310, "textAlign", "center")
	J.sp(v_ctx_310, "textBaseline", "middle")
	for _t338 in J.iter(J.G.get("GS_ORDER")):
		v_k_314 = _t338
		v_s_315 = J.gp(J.G.get("GS_STALLS"), v_k_314)
		v_x_316 = J.mc(this_, "X", [(0.945 if J.seq(v_k_314, "alley") else J.gp(v_s_315, "x"))])
		v_y_317 = J.add(J.mc(this_, "Y", [(0.3 if J.seq(v_k_314, "alley") else 0.39)]), (sin(J.num((J.mul(v_t_311, 1.5) + J.mul(J.gp(v_s_315, "x"), 9.0)))) * 1.5))
		var _t339 = J.cmp(v_x_316, (-60.0), "<")
		if (_t339 if _t339 else J.cmp(v_x_316, J.add(J.gp(this_, "W"), 60.0), ">")):
			continue
		v_w_318 = J.add(J.gp(J.mc(v_ctx_310, "measureText", [J.gp(v_s_315, "name")]), "width"), 16.0)
		v_on_319 = J.seq(v_near_312, v_k_314)
		var _t340 = ("rgba(194,54,43,.94)" if J.t(v_on_319) else "rgba(20,12,22,.72)")
		J.sp(v_ctx_310, "fillStyle", _t340)
		var _t341 = ("#f3d68a" if J.t(v_on_319) else "rgba(243,214,138,.55)")
		J.sp(v_ctx_310, "strokeStyle", _t341)
		J.sp(v_ctx_310, "lineWidth", 1.2)
		J.mc(J.G.get("ART"), "rr", [v_ctx_310, J.sub(v_x_316, J.div(v_w_318, 2.0)), J.sub(v_y_317, 12.0), v_w_318, 24.0, 4.0, J.gp(v_ctx_310, "fillStyle"), J.gp(v_ctx_310, "strokeStyle"), 1.2])
		var _t342 = ("#fff3e0" if J.t(v_on_319) else "#f3d68a")
		J.sp(v_ctx_310, "fillStyle", _t342)
		J.mc(v_ctx_310, "fillText", [J.gp(v_s_315, "name"), v_x_316, J.add(v_y_317, 1.0)])
	J.mc(v_ctx_310, "restore", [])

func _f70(this_, a: Array, env):
	var v_A_322 = null; var v_best_323 = null; var v_bd_324 = null; var v_k_325 = null; var v_d_326 = null
	v_A_322 = J.gp(this_, "afu")
	v_best_323 = null
	v_bd_324 = 0.09
	for _t343 in J.iter(J.G.get("GS_ORDER")):
		v_k_325 = _t343
		v_d_326 = absf(J.num(J.sub(J.gp(v_A_322, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_325), "x"))))
		if J.cmp(v_d_326, v_bd_324, "<"):
			v_bd_324 = v_d_326
			v_best_323 = v_k_325
	return v_best_323

func _f71(this_, a: Array, env):
	var v_ctx_329 = null; var v_t_330 = null; var v_A_331 = null; var v_sc_332 = null; var v_x_333 = null; var v_y_334 = null
	v_ctx_329 = J.arg(a, 0)
	v_t_330 = J.arg(a, 1)
	v_A_331 = J.gp(this_, "afu")
	v_sc_332 = J.mc(this_, "charScale", [J.gp(v_A_331, "y")])
	v_x_333 = J.mc(this_, "X", [J.gp(v_A_331, "x")])
	v_y_334 = J.mc(this_, "Y", [J.gp(v_A_331, "y")])
	var _t344 = J.G.get("__gsDC")
	var _t347 = J.gp(v_A_331, "walking")
	var _t348 = J.cmp(J.gp(v_A_331, "dir"), 0.0, "<")
	var _t346 = null
	if J.t(J.gp(v_A_331, "walking")):
		_t346 = null
	else:
		var _t345 = J.gp(v_A_331, "pose")
		_t346 = (_t345 if J.t(_t345) else null)
	J.cl(_t344, null, [v_ctx_329, "afu", v_x_333, v_y_334, v_sc_332, {"t": v_t_330, "walk": _t347, "flip": _t348, "pose": _t346, "pt": ((1.0 - J.max_([0.0, J.gp(v_A_331, "poseT")])) if J.t(J.gp(v_A_331, "pose")) else 0.0), "tamed": true, "untied": true}])

func _f72(this_, a: Array, env):
	var v_ctx_337 = null; var v_k_338 = null; var v_t_339 = null; var v_kp_340 = null; var v_sc_341 = null; var v_x_342 = null; var v_y_343 = null; var v_face_344 = null; var v_pt_345 = null; var v_da_346 = null
	v_ctx_337 = J.arg(a, 0)
	v_k_338 = J.arg(a, 1)
	v_t_339 = J.arg(a, 2)
	v_kp_340 = J.gp(J.gp(this_, "keepers"), v_k_338)
	v_sc_341 = J.mul(J.mc(this_, "charScale", [J.gp(v_kp_340, "y")]), (1.05 if J.seq(J.gp(v_kp_340, "k"), "xiaogui") else (0.9 if J.seq(J.gp(v_kp_340, "k"), "baiwu") else 1.0)))
	v_x_342 = J.mc(this_, "X", [J.gp(v_kp_340, "x")])
	v_y_343 = J.mc(this_, "Y", [J.gp(v_kp_340, "y")])
	var _t349 = J.cmp(v_x_342, (-80.0), "<")
	if (_t349 if _t349 else J.cmp(v_x_342, J.add(J.gp(this_, "W"), 80.0), ">")):
		return null
	v_face_344 = J.cmp(J.gp(J.gp(this_, "afu"), "x"), J.gp(v_kp_340, "x"), "<")
	v_pt_345 = J.gp(v_kp_340, "pt")
	if J.seq(J.gp(v_kp_340, "pose"), "strike"):
		var _t350 = J.mod(J.mul(v_t_339, 1.4), 1.0)
		v_pt_345 = _t350
	if J.seq(J.gp(v_kp_340, "pose"), "windup"):
		var _t351 = (0.35 + (sin(J.num(J.mul(v_t_339, 3.0))) * 0.1))
		v_pt_345 = _t351
	if J.seq(J.gp(v_kp_340, "pose"), "hurt"):
		var _t352 = (0.35 + (sin(J.num(J.mul(v_t_339, 9.0))) * 0.05))
		v_pt_345 = _t352
	v_da_346 = {}
	var _t353 = (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined"))
	if ((not J.t(J.gp(v_kp_340, "pose"))) if _t353 else _t353):
		if J.cmp(J.gp(v_kp_340, "greet"), 0.0, ">"):
			var _t354 = {"act": "town_greet", "at": J.gp(v_kp_340, "gt"), "adur": J.add(J.gp(v_kp_340, "gt"), J.gp(v_kp_340, "greet"))}
			v_da_346 = _t354
		else:
			var _t355 = J.mc(J.G.get("TOWN"), "opts", [J.gp(v_kp_340, "st")])
			v_da_346 = _t355
			if J.t(J.gp(v_da_346, "act")):
				var _t356 = J.cmp(J.gp(J.G.get("GS_WORKFACE"), v_k_338), 0.0, "<")
				v_face_344 = _t356
		if J.seq(J.gp(v_kp_340, "k"), "eguiking"):
			var _t357 = {"potDX": J.sub(J.mc(this_, "X", [J.gp(J.G.get("GS_POT"), 0.0)]), v_x_342), "potDY": J.sub(J.mc(this_, "Y", [J.gp(J.G.get("GS_POT"), 1.0)]), v_y_343)}
			J.sp(v_da_346, "prop", _t357)
	var _t358 = J.G.get("__gsDC")
	var _t361 = J.gp(v_kp_340, "k")
	var _t360 = J.add(v_t_339, J.gp(v_kp_340, "ph"))
	var _t359 = J.gp(v_kp_340, "pose")
	J.cl(_t358, null, [v_ctx_337, _t361, v_x_342, v_y_343, v_sc_341, J.S_Object_("assign", [{"t": _t360, "flip": v_face_344, "pose": (_t359 if J.t(_t359) else null), "pt": v_pt_345, "tamed": true, "untied": true}, v_da_346])])

func _f73(this_, a: Array, env):
	var v_ctx_349 = null; var v_w_350 = null; var v_t_351 = null; var v_sc_352 = null; var v_x_353 = null; var v_y_354 = null; var v_da_355 = null
	v_ctx_349 = J.arg(a, 0)
	v_w_350 = J.arg(a, 1)
	v_t_351 = J.arg(a, 2)
	v_sc_352 = J.mul(J.mc(this_, "charScale", [J.gp(v_w_350, "y")]), 0.92)
	v_x_353 = J.mc(this_, "X", [J.gp(v_w_350, "x")])
	v_y_354 = J.mc(this_, "Y", [J.gp(v_w_350, "y")])
	var _t362 = J.cmp(v_x_353, (-80.0), "<")
	if (_t362 if _t362 else J.cmp(v_x_353, J.add(J.gp(this_, "W"), 80.0), ">")):
		return null
	v_da_355 = {}
	if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
		if J.cmp(J.gp(v_w_350, "bump"), 0.0, ">"):
			var _t363 = {"act": "town_bump", "at": J.gp(v_w_350, "bt"), "prop": J.S_Object_("assign", [{}, J.gp(v_w_350, "prop"), {"sorry": J.gp(v_w_350, "sorry")}])}
			v_da_355 = _t363
		else:
			if J.cmp(J.gp(v_w_350, "look"), 0.0, ">"):
				var _t364 = {"act": "town_look", "at": J.gp(v_w_350, "lt"), "adur": J.add(J.gp(v_w_350, "lt"), J.gp(v_w_350, "look")), "prop": J.gp(v_w_350, "prop")}
				v_da_355 = _t364
			else:
				if J.t(J.gp(v_w_350, "prop")):
					var _t365 = {"act": "town_walk", "at": 9.0, "prop": J.gp(v_w_350, "prop")}
					v_da_355 = _t365
	var _t366 = J.G.get("__gsDC")
	J.cl(_t366, null, [v_ctx_349, J.gp(v_w_350, "k"), v_x_353, v_y_354, v_sc_352, J.S_Object_("assign", [{"t": J.add(v_t_351, J.gp(v_w_350, "ph")), "walk": J.gp(v_w_350, "walking"), "flip": J.cmp(J.gp(v_w_350, "dir"), 0.0, "<"), "tamed": true, "untied": true, "alpha": 0.9}, v_da_355])])

func _f75(this_, a: Array, env):
	var v_l_374 = null
	v_l_374 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_374]), "width")

func _f76(this_, a: Array, env):
	var v_l_375 = null; var v_i_376 = null
	v_l_375 = J.arg(a, 0)
	v_i_376 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_375, J.add(env["bx"], 9.0), J.add(J.add(env["by"], 20.0), J.mul(v_i_376, 19.0))])

func _f74(this_, a: Array, env):
	var v_o_359 = null; var v_text_360 = null; var v_life_361 = null; var v_sc_362 = null; var v_h_363 = null; var v_x_364 = null; var v_y_365 = null; var v_maxW_366 = null; var v_lines_367 = null; var v_cur_368 = null; var v_w_369 = null; var v_hh_370 = null; var v_ch_373 = null
	var _s166 = {"__p": env, "ctx": null, "bx": null, "by": null}
	_s166["ctx"] = J.arg(a, 0)
	v_o_359 = J.arg(a, 1)
	v_text_360 = J.arg(a, 2)
	v_life_361 = J.arg(a, 3)
	v_sc_362 = J.mc(this_, "charScale", [J.gp(v_o_359, "y")])
	v_h_363 = (J.mul(58.0, v_sc_362) * (1.25 if J.seq(J.gp(v_o_359, "k"), "baiwu") else (0.85 if J.seq(J.gp(v_o_359, "k"), "xiaogui") else 1.0)))
	v_x_364 = J.mc(this_, "X", [J.gp(v_o_359, "x")])
	v_y_365 = (J.sub(J.mc(this_, "Y", [J.gp(v_o_359, "y")]), v_h_363) - 10.0)
	var _t367 = J.cmp(v_x_364, (-40.0), "<")
	if (_t367 if _t367 else J.cmp(v_x_364, J.add(J.gp(this_, "W"), 40.0), ">")):
		return null
	J.mc(_s166["ctx"], "save", [])
	var _t368 = _s166["ctx"]
	var _t369 = J.add("700 14px ", J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily"))
	J.sp(_t368, "font", _t369)
	v_maxW_366 = 172.0
	v_lines_367 = []
	v_cur_368 = ""
	for _t370 in J.iter(v_text_360):
		v_ch_373 = _t370
		var _t371 = J.cmp(J.gp(J.mc(_s166["ctx"], "measureText", [J.add(v_cur_368, v_ch_373)]), "width"), v_maxW_366, ">")
		if ((not J.t(J.mc("。，、！？；：」）…—", "includes", [v_ch_373]))) if _t371 else _t371):
			J.mc(v_lines_367, "push", [v_cur_368])
			v_cur_368 = v_ch_373
		else:
			var _t372 = J.add(v_cur_368, v_ch_373)
			v_cur_368 = _t372
	if J.t(v_cur_368):
		J.mc(v_lines_367, "push", [v_cur_368])
	v_w_369 = (J.max_(J.spread([J.SP(J.mc(v_lines_367, "map", [Callable(self, "_f75").bind(_s166)]))])) + 18.0)
	v_hh_370 = ((J.len(v_lines_367) * 19.0) + 12.0)
	_s166["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), v_w_369) - 6.0), J.sub(v_x_364, J.div(v_w_369, 2.0))])])
	_s166["by"] = J.max_([6.0, J.sub(v_y_365, v_hh_370)])
	var _t373 = _s166["ctx"]
	var _t374 = J.min_([1.0, J.mul(v_life_361, 3.0)])
	J.sp(_t373, "globalAlpha", _t374)
	J.mc(J.G.get("ART"), "rr", [_s166["ctx"], _s166["bx"], _s166["by"], v_w_369, v_hh_370, 9.0, "rgba(244,236,214,.96)", "#3a2a1a", 1.5])
	var _t375 = _s166["ctx"]
	J.sp(_t375, "fillStyle", "rgba(244,236,214,.96)")
	J.mc(_s166["ctx"], "beginPath", [])
	J.mc(_s166["ctx"], "moveTo", [(J.max_([J.add(_s166["bx"], 10.0), J.min_([J.sub(J.add(_s166["bx"], v_w_369), 10.0), v_x_364])]) - 6.0), J.sub(J.add(_s166["by"], v_hh_370), 1.0)])
	J.mc(_s166["ctx"], "lineTo", [v_x_364, J.add(J.add(_s166["by"], v_hh_370), 8.0)])
	J.mc(_s166["ctx"], "lineTo", [(J.max_([J.add(_s166["bx"], 10.0), J.min_([J.sub(J.add(_s166["bx"], v_w_369), 10.0), v_x_364])]) + 6.0), J.sub(J.add(_s166["by"], v_hh_370), 1.0)])
	J.mc(_s166["ctx"], "fill", [])
	var _t376 = _s166["ctx"]
	J.sp(_t376, "fillStyle", "#2a1a10")
	var _t377 = _s166["ctx"]
	J.sp(_t377, "textAlign", "left")
	var _t378 = _s166["ctx"]
	J.sp(_t378, "textBaseline", "alphabetic")
	J.mc(v_lines_367, "forEach", [Callable(self, "_f76").bind(_s166)])
	J.mc(_s166["ctx"], "restore", [])

func _f78(this_, a: Array, env):
	var v_k_385 = null
	v_k_385 = J.arg(a, 0)
	return ("<button class=\"gs-chip\" data-k=\"" + J.str(v_k_385) + "\">" + J.str(J.gp(J.gp(J.G.get("GS_STALLS"), v_k_385), "name")) + "</button>")

func _f80(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "goStall", [J.gp(J.gp(env["b"], "dataset"), "k")])

func _f79(this_, a: Array, env):
	var _s176 = {"__p": env, "b": null}
	_s176["b"] = J.arg(a, 0)
	var _t389 = _s176["b"]
	var _t390 = Callable(self, "_f80").bind(_s176)
	J.sp(_t389, "onclick", _t390)
	return _t390

func _f81(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t392 = J.seq(J.gp(env["v"], "k"), "haggle")
	if J.t((J.gp(env["v"], "sub") if _t392 else _t392)):
		var _t393 = env["v"]
		J.sp(_t393, "sub", null)
		J.mc(env["this"], "renderPanel", [])
		return null
	var _t394 = env["this"]
	var _t395 = {"k": "idle"}
	J.sp(_t394, "view", _t395)
	J.mc(env["this"], "relax", [])
	J.mc(env["this"], "renderPanel", [])

func _f77(this_, a: Array, env):
	var v_p_379 = null; var v_s_381 = null; var v_h_382 = null; var v_x_383 = null; var v_first_384 = null
	var _s172 = {"__p": env, "this": null, "v": null}
	_s172["this"] = this_
	var _t379 = J.G.get("$")
	v_p_379 = J.cl(_t379, null, ["#gs-panel"])
	if (not J.t(v_p_379)):
		return null
	_s172["v"] = J.gp(_s172["this"], "view")
	v_s_381 = J.mc(_s172["this"], "st", [])
	v_h_382 = ""
	if J.seq(J.gp(_s172["v"], "k"), "idle"):
		var _t380 = J.gp(v_s_381, "visits")
		v_first_384 = J.cmp((_t380 if J.t(_t380) else 0.0), 1.0, "<=")
		var _t382 = ("點地面走路，按住拖著，阿福會跟著走。點攤位直接光顧。" if J.t(v_first_384) else "想去哪一攤？")
		var _t381 = J.mc(J.G.get("GS_ORDER"), "map", [Callable(self, "_f78").bind(_s172)])
		var _t383 = ("<p class=\"gs-hint\">" + _t382 + "</p>\n        <div class=\"gs-chips\">" + J.str(J.mc(_t381, "join", [""])) + "</div>\n        " + (("<p class=\"gs-note\">肚子裡：" + J.str(J.gp(J.gp(J.G.get("GS_MEALS"), J.gp(v_s_381, "meal")), "name")) + "（下一場出征生效）</p>") if J.t(J.gp(v_s_381, "meal")) else ""))
		v_h_382 = _t383
	else:
		var _t386 = J.gp(J.gp(J.G.get("GS_STALLS"), J.gp(_s172["v"], "k")), "name")
		var _t384 = _s172["this"]
		var _t385 = J.add("html_", J.gp(_s172["v"], "k"))
		var _t387 = ("<div class=\"gs-ph\"><b>" + J.str(_t386) + "</b><button class=\"gs-x\" id=\"gs-x\" aria-label=\"離開\">離開</button></div><div class=\"gs-body\">" + J.str(J.mc(_t384, _t385, [])) + "</div>")
		v_h_382 = _t387
	J.sp(v_p_379, "innerHTML", v_h_382)
	var _t388 = J.mc(v_p_379, "querySelectorAll", [".gs-chip"])
	J.mc(_t388, "forEach", [Callable(self, "_f79").bind(_s172)])
	var _t391 = J.G.get("$")
	v_x_383 = J.cl(_t391, null, ["#gs-x"])
	if J.t(v_x_383):
		var _t396 = Callable(self, "_f81").bind(_s172)
		J.sp(v_x_383, "onclick", _t396)
	if (not J.seq(J.gp(_s172["v"], "k"), "idle")):
		var _t397 = _s172["this"]
		var _t398 = J.add("bind_", J.gp(_s172["v"], "k"))
		J.mc(_t397, _t398, [v_p_379])

func _f82(this_, a: Array, env):
	var v_k_389 = null; var v_kp_390 = null
	for _t399 in J.keys(J.gp(this_, "keepers")):
		v_k_389 = _t399
		v_kp_390 = J.gp(J.gp(this_, "keepers"), v_k_389)
		J.sp(v_kp_390, "hold", false)
		J.sp(v_kp_390, "pose", null)
		J.sp(v_kp_390, "poseT", 0.0)

func _f83(this_, a: Array, env):
	var v_k_393 = null; var v_pose_394 = null; var v_dur_395 = null; var v_hold_396 = null; var v_kp_397 = null
	v_k_393 = J.arg(a, 0)
	v_pose_394 = J.arg(a, 1)
	v_dur_395 = J.arg(a, 2)
	v_hold_396 = J.arg(a, 3)
	v_kp_397 = J.gp(J.gp(this_, "keepers"), v_k_393)
	if (not J.t(v_kp_397)):
		return null
	J.sp(v_kp_397, "pose", v_pose_394)
	J.sp(v_kp_397, "pt", 0.0)
	var _t400 = (v_dur_395 if J.t(v_dur_395) else 1.2)
	J.sp(v_kp_397, "poseT", _t400)
	var _t401 = (not (not J.t(v_hold_396)))
	J.sp(v_kp_397, "hold", _t401)

func _f84(this_, a: Array, env):
	var v_n_400 = null
	v_n_400 = J.arg(a, 0)
	var _t402 = J.gp(J.gp(J.G.get("S"), "res"), "coins")
	return J.cmp((_t402 if J.t(_t402) else 0.0), v_n_400, ">=")

func _f85(this_, a: Array, env):
	var v_n_403 = null
	v_n_403 = J.arg(a, 0)
	var _t403 = J.gp(J.G.get("S"), "res")
	var _t404 = J.sub(J.gp(_t403, "coins"), v_n_403)
	J.sp(_t403, "coins", _t404)
	J.mc(J.G.get("UI"), "refresh", [])

func _f87(this_, a: Array, env):
	var v_k_407 = null; var v_e_408 = null; var v_own_409 = null
	v_k_407 = J.arg(a, 0)
	v_e_408 = J.gp(J.G.get("GS_EFFIGY"), v_k_407)
	v_own_409 = J.gp(env["fx"], v_k_407)
	return ("<div class=\"gs-card " + ("own" if J.t(v_own_409) else "") + "\"><div class=\"gs-ci\"><b>" + J.str(J.gp(v_e_408, "name")) + "</b><small class=\"gs-eff\">" + J.str(J.gp(v_e_408, "eff")) + "</small><small>" + J.str(J.gp(v_e_408, "say")) + "</small></div>\n        <button class=\"btn " + ("ghost" if J.t(v_own_409) else "gold") + " sm gs-buy\" data-k=\"" + J.str(v_k_407) + "\" " + ("disabled" if J.t((v_own_409 if J.t(v_own_409) else (not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_e_408, "price")]))))) else "") + ">" + ("已燒" if J.t(v_own_409) else ("燒 " + J.str(J.gp(v_e_408, "price")))) + "</button></div>")

func _f86(this_, a: Array, env):
	var _s186 = {"__p": env, "this": null, "fx": null}
	_s186["this"] = this_
	_s186["fx"] = J.gp(J.mc(_s186["this"], "st", []), "fx")
	var _t405 = J.S_Object_("keys", [J.G.get("GS_EFFIGY")])
	var _t406 = J.mc(_t405, "map", [Callable(self, "_f87").bind(_s186)])
	return ("<p class=\"gs-line\"><b>小紙</b>燒了就是你的，永久有效。不退貨，因為已經燒了。</p><div class=\"gs-list\">" + J.str(J.mc(_t406, "join", [""])) + "</div>")

func _f90(this_, a: Array, env):
	var v_k_414 = null; var v_e_415 = null; var v_s_416 = null
	v_k_414 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_e_415 = J.gp(J.G.get("GS_EFFIGY"), v_k_414)
	v_s_416 = J.mc(env["__p"]["this"], "st", [])
	var _t409 = J.gp(J.gp(v_s_416, "fx"), v_k_414)
	if J.t((_t409 if J.t(_t409) else (not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_e_415, "price")]))))):
		return null
	J.mc(env["__p"]["this"], "spend", [J.gp(v_e_415, "price")])
	var _t410 = J.gp(v_s_416, "fx")
	J.sp(_t410, v_k_414, true)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("Sound"), "play", ["chest"])
	J.mc(env["__p"]["this"], "burn", [J.gp(J.gp(J.G.get("GS_STALLS"), "paper"), "x")])
	J.mc(env["__p"]["this"], "say", [J.gp(J.gp(env["__p"]["this"], "keepers"), "paper"), (J.add("燒好了！", J.gp(v_e_415, "eff")) + "。"), 3.0])
	J.mc(env["__p"]["this"], "keeperPose", ["paper", "cast", 1.2])
	J.mc(env["__p"]["this"], "float", [J.gp(J.gp(env["__p"]["this"], "afu"), "x"), J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16), (J.str(J.gp(v_e_415, "name")) + "  到手"), "#ffe08a"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f89(this_, a: Array, env):
	var _s189 = {"__p": env, "b": null}
	_s189["b"] = J.arg(a, 0)
	var _t408 = _s189["b"]
	var _t411 = Callable(self, "_f90").bind(_s189)
	J.sp(_t408, "onclick", _t411)
	return _t411

func _f88(this_, a: Array, env):
	var v_p_412 = null
	var _s188 = {"__p": env, "this": null}
	_s188["this"] = this_
	v_p_412 = J.arg(a, 0)
	var _t407 = J.mc(v_p_412, "querySelectorAll", [".gs-buy"])
	J.mc(_t407, "forEach", [Callable(self, "_f89").bind(_s188)])

func _f91(this_, a: Array, env):
	var v_fx_419 = null; var v_i_420 = null
	v_fx_419 = J.arg(a, 0)
	v_i_420 = 0.0
	while true:
		if not J.cmp(v_i_420, 22.0, "<"): break
		var _t412 = J.gp(this_, "parts")
		J.mc(_t412, "push", [{"kind": "joss", "x": J.add(v_fx_419, ((randf() - 0.5) * 0.06)), "y": 0.62, "bx": ((randf() - 0.5) * 0.04), "vx": 0.0, "vy": ((-0.08) - (randf() * 0.06)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 8.0), "flip": 0.0, "vf": 6.0, "sw": 2.0, "ph": (randf() * 6.0), "land": 2.0, "life": (2.0 + randf()), "max": 3.0}])
		v_i_420 = J.num(v_i_420) + 1.0

func _f93(this_, a: Array, env):
	var v___425 = null; var v_i_426 = null
	v___425 = J.arg(a, 0)
	v_i_426 = J.arg(a, 1)
	return v_i_426

func _f94(this_, a: Array, env):
	var v_a_427 = null; var v_b_428 = null
	v_a_427 = J.arg(a, 0)
	v_b_428 = J.arg(a, 1)
	var _t414 = J.G.get("gsRnd")
	var _t416 = J.cl(_t414, null, [J.add(J.mul(env["d"], 31.0), v_a_427)])
	var _t415 = J.G.get("gsRnd")
	return J.sub(_t416, J.cl(_t415, null, [J.add(J.mul(env["d"], 31.0), v_b_428)]))

func _f95(this_, a: Array, env):
	var v_i_429 = null
	v_i_429 = J.arg(a, 0)
	return J.gp(J.G.get("GS_ITEMS"), v_i_429)

func _f92(this_, a: Array, env):
	var v_idx_424 = null
	var _s193 = {"__p": env, "d": null}
	_s193["d"] = J.cl(J.G.get("gsDay"), null, [])
	var _t413 = J.mc(J.G.get("GS_ITEMS"), "map", [Callable(self, "_f93").bind(_s193)])
	v_idx_424 = J.mc(_t413, "sort", [Callable(self, "_f94").bind(_s193)])
	var _t417 = J.mc(v_idx_424, "slice", [0.0, 3.0])
	return J.mc(_t417, "map", [Callable(self, "_f95").bind(_s193)])

func _f96(this_, a: Array, env):
	var v_it_432 = null
	v_it_432 = J.arg(a, 0)
	var _t419 = J.gp(v_it_432, "col")
	var _t418 = J.G.get("gsRnd")
	return J.round(J.num(J.mul(_t419, (0.5 + J.mul(0.35, J.cl(_t418, null, [((J.mul(J.cl(J.G.get("gsDay"), null, []), 977.0) + J.mul(J.gp(v_it_432, "col"), 13.0)) + J.len(J.gp(v_it_432, "id")))]))))))

func _f97(this_, a: Array, env):
	var v_it_435 = null
	v_it_435 = J.arg(a, 0)
	return J.round(J.num(J.mul(J.gp(v_it_435, "col"), 1.15)))

func _f99(this_, a: Array, env):
	var v_it_447 = null; var v_st_448 = null
	v_it_447 = J.arg(a, 0)
	v_st_448 = J.gp(J.gp(env["h"], "done"), J.gp(v_it_447, "id"))
	return ("<button class=\"gs-card gs-item " + ("own" if J.t(v_st_448) else "") + "\" data-id=\"" + J.str(J.gp(v_it_447, "id")) + "\" " + ("disabled" if J.t(v_st_448) else "") + "><div class=\"gs-ci\"><b>" + J.str(J.gp(v_it_447, "name")) + "</b><small>" + J.str(J.gp(v_it_447, "desc")) + "</small><small class=\"gs-eff\">標價 " + J.str(J.mc(env["this"], "askOf", [v_it_447])) + "　收藏家收購 " + J.str(J.gp(v_it_447, "col")) + "</small></div><em>" + ("已買" if J.seq(v_st_448, "bought") else ("收起來了" if J.seq(v_st_448, "shelved") else "講價")) + "</em></button>")

func _f100(this_, a: Array, env):
	var v_i_449 = null
	v_i_449 = J.arg(a, 0)
	return J.seq(J.gp(v_i_449, "id"), J.gp(env["v"], "sub"))

func _f101(this_, a: Array, env):
	var v_m_450 = null; var v_i_451 = null
	v_m_450 = J.arg(a, 0)
	v_i_451 = J.arg(a, 1)
	return ("<i class=\"" + ("on" if J.seq(v_i_451, env["lv"]) else "") + "\" style=\"--c:" + J.str(J.gp(["#e2483a", "#d07a3a", "#d8b84a", "#9ad05a", "#5ad0a0"], v_i_451)) + "\">" + J.str(v_m_450) + "</i>")

func _f98(this_, a: Array, env):
	var v_it_440 = null; var v_tries_441 = null; var v_ask_442 = null; var v_last_443 = null; var v_offer_444 = null; var v_mood_446 = null
	var _s199 = {"__p": env, "this": null, "h": null, "v": null, "lv": null}
	_s199["this"] = this_
	_s199["h"] = J.gp(J.mc(_s199["this"], "st", []), "hag")
	_s199["v"] = J.gp(_s199["this"], "view")
	if J.t(J.gp(_s199["h"], "out")):
		return ("<p class=\"gs-line bad\"><b>小鬼</b>還敢回來？今晚不做你生意！明天請早。</p><p class=\"gs-note\">你今晚侮辱了小鬼三次，被轟了出去。明天再來。</p>")
	if (not J.t(J.gp(_s199["v"], "sub"))):
		var _t422 = ("看中哪件就出價。開太低，我會翻臉。" if J.t(J.mod(J.gp(J.mc(_s199["this"], "st", []), "visits"), 2.0)) else "我的貨都是古董，你的出價最好也是。")
		var _t420 = J.mc(_s199["this"], "todayItems", [])
		var _t421 = J.mc(_t420, "map", [Callable(self, "_f99").bind(_s199)])
		return ("<p class=\"gs-line\"><b>小鬼</b>" + _t422 + "</p>\n        <p class=\"gs-note\">收藏家會照「收購價」收走你買到的東西。買得越便宜，賺得越多。小鬼心裡有底價，看他臉色推算。每件最多出價三次；侮辱他三次會被轟走。</p>\n        <div class=\"gs-list\">" + J.str(J.mc(_t421, "join", [""])) + "</div>\n        <p class=\"gs-note\">侮辱 " + J.str(J.gp(_s199["h"], "strikes")) + "/3</p>")
	v_it_440 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f100").bind(_s199)])
	var _t423 = J.gp(J.gp(_s199["h"], "tries"), J.gp(v_it_440, "id"))
	v_tries_441 = (_t423 if J.t(_t423) else 0.0)
	v_ask_442 = J.mc(_s199["this"], "askOf", [v_it_440])
	v_last_443 = J.gp(_s199["v"], "last")
	var _t424 = J.gp(_s199["v"], "offer")
	v_offer_444 = (_t424 if J.t(_t424) else J.round(J.num(J.mul(J.gp(v_it_440, "col"), 0.6))))
	_s199["lv"] = ((J.gp(J.gp(v_last_443, "band"), "lv") if J.t(J.gp(v_last_443, "band")) else 4.0) if J.t(v_last_443) else (-1.0))
	v_mood_446 = ((J.gp(J.gp(v_last_443, "band"), "mood") if J.t(J.gp(v_last_443, "band")) else "成交") if J.t(v_last_443) else "打量你")
	var _t427 = J.gp(v_it_440, "name")
	var _t428 = J.gp(v_it_440, "desc")
	var _t429 = J.gp(v_it_440, "col")
	var _t430 = ("bad" if J.seq(_s199["lv"], 0.0) else "")
	var _t431 = (J.gp(v_last_443, "line") if J.t(v_last_443) else "出個價來聽聽。")
	var _t425 = ["翻臉", "很臭", "猶豫", "肉痛", "成交"]
	var _t426 = J.mc(_t425, "map", [Callable(self, "_f101").bind(_s199)])
	return ("<div class=\"gs-hag\"><b class=\"gs-iname\">" + J.str(_t427) + "</b><small>" + J.str(_t428) + "</small>\n      <div class=\"gs-prices\"><span>標價 <b>" + J.str(v_ask_442) + "</b></span><span>收藏家收購 <b>" + J.str(_t429) + "</b></span></div>\n      <p class=\"gs-line " + _t430 + "\"><b>小鬼</b>" + J.str(_t431) + "</p>\n      <div class=\"gs-mood\"><span>臉色</span>" + J.str(J.mc(_t426, "join", [""])) + "<em>" + J.str(v_mood_446) + "</em></div>\n      " + ("" if J.t(J.gp(_s199["v"], "closed")) else ("<div class=\"gs-offer\"><button class=\"btn sm\" id=\"gs-m\">−5</button><input type=\"range\" id=\"gs-r\" min=\"5\" max=\"" + J.str(v_ask_442) + "\" step=\"1\" value=\"" + J.str(v_offer_444) + "\"><button class=\"btn sm\" id=\"gs-p\">+5</button></div>\n      <button class=\"btn gold wide\" id=\"gs-go\" " + ("" if J.t(J.mc(_s199["this"], "coinsOk", [v_offer_444])) else "disabled") + ">出價 <span id=\"gs-ov\">" + J.str(v_offer_444) + "</span> 冥幣</button>")) + "\n      <p class=\"gs-note\">第 " + J.str(J.min_([3.0, J.add(v_tries_441, (0.0 if J.t(J.gp(_s199["v"], "closed")) else 1.0))])) + "/3 次出價　侮辱 " + J.str(J.gp(_s199["h"], "strikes")) + "/3" + ("" if J.t(J.gp(_s199["v"], "closed")) else ("" if J.t(J.mc(_s199["this"], "coinsOk", [v_offer_444])) else "　（冥幣不夠）")) + "</p>\n      " + (("<button class=\"btn wide\" id=\"gs-back2\">看別的貨</button>") if J.t(J.gp(_s199["v"], "closed")) else "") + "</div>")

func _f104(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t434 = env["__p"]["v"]
	var _t435 = J.gp(J.gp(env["b"], "dataset"), "id")
	J.sp(_t434, "sub", _t435)
	var _t436 = env["__p"]["v"]
	J.sp(_t436, "last", null)
	var _t437 = env["__p"]["v"]
	J.sp(_t437, "closed", false)
	var _t438 = env["__p"]["v"]
	J.sp(_t438, "offer", null)
	J.mc(env["__p"]["this"], "renderPanel", [])
	J.mc(env["__p"]["this"], "keeperPose", ["haggle", null, 0.0])

func _f103(this_, a: Array, env):
	var _s205 = {"__p": env, "b": null}
	_s205["b"] = J.arg(a, 0)
	var _t433 = _s205["b"]
	var _t439 = Callable(self, "_f104").bind(_s205)
	J.sp(_t433, "onclick", _t439)
	return _t439

func _f105(this_, a: Array, env):
	var _t441 = env["v"]
	J.sp(_t441, "sub", null)
	var _t442 = env["v"]
	J.sp(_t442, "closed", false)
	var _t443 = env["v"]
	J.sp(_t443, "last", null)
	J.mc(env["this"], "renderPanel", [])

func _f107(this_, a: Array, env):
	var v_i_463 = null
	v_i_463 = J.arg(a, 0)
	return J.seq(J.gp(v_i_463, "id"), J.gp(env["v"], "sub"))

func _f106(this_, a: Array, env):
	var v_n_461 = null; var v_it_462 = null
	v_n_461 = J.arg(a, 0)
	v_it_462 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f107").bind(env)])
	var _t446 = J.max_([5.0, J.min_([J.mc(env["this"], "askOf", [v_it_462]), v_n_461])])
	v_n_461 = _t446
	var _t447 = env["v"]
	J.sp(_t447, "offer", v_n_461)
	var _t448 = env["r"]
	J.sp(_t448, "value", v_n_461)
	var _t449 = J.G.get("$")
	var _t450 = J.cl(_t449, null, ["#gs-ov"])
	J.sp(_t450, "textContent", v_n_461)
	var _t451 = J.G.get("$")
	var _t452 = J.cl(_t451, null, ["#gs-go"])
	var _t453 = (not J.t(J.mc(env["this"], "coinsOk", [v_n_461])))
	J.sp(_t452, "disabled", _t453)

func _f108(this_, a: Array, env):
	var _t455 = env["set"]
	return J.cl(_t455, null, [J.num(J.gp(env["r"], "value"))])

func _f109(this_, a: Array, env):
	var _t459 = env["set"]
	return J.cl(_t459, null, [(J.num(J.gp(env["r"], "value")) - 5.0)])

func _f110(this_, a: Array, env):
	var _t463 = env["set"]
	return J.cl(_t463, null, [(J.num(J.gp(env["r"], "value")) + 5.0)])

func _f111(this_, a: Array, env):
	return J.mc(env["this"], "offer", [J.num(J.gp(env["r"], "value"))])

func _f102(this_, a: Array, env):
	var v_p_454 = null; var v_h_456 = null; var v_b2_457 = null
	var _s204 = {"__p": env, "this": null, "v": null, "r": null, "set": null}
	_s204["this"] = this_
	v_p_454 = J.arg(a, 0)
	_s204["v"] = J.gp(_s204["this"], "view")
	v_h_456 = J.gp(J.mc(_s204["this"], "st", []), "hag")
	var _t432 = J.mc(v_p_454, "querySelectorAll", [".gs-item"])
	J.mc(_t432, "forEach", [Callable(self, "_f103").bind(_s204)])
	var _t440 = J.G.get("$")
	v_b2_457 = J.cl(_t440, null, ["#gs-back2"])
	if J.t(v_b2_457):
		var _t444 = Callable(self, "_f105").bind(_s204)
		J.sp(v_b2_457, "onclick", _t444)
	var _t445 = J.G.get("$")
	_s204["r"] = J.cl(_t445, null, ["#gs-r"])
	if (not J.t(_s204["r"])):
		return null
	_s204["set"] = Callable(self, "_f106").bind(_s204)
	var _t454 = _s204["r"]
	var _t456 = Callable(self, "_f108").bind(_s204)
	J.sp(_t454, "oninput", _t456)
	var _t457 = J.G.get("$")
	var _t458 = J.cl(_t457, null, ["#gs-m"])
	var _t460 = Callable(self, "_f109").bind(_s204)
	J.sp(_t458, "onclick", _t460)
	var _t461 = J.G.get("$")
	var _t462 = J.cl(_t461, null, ["#gs-p"])
	var _t464 = Callable(self, "_f110").bind(_s204)
	J.sp(_t462, "onclick", _t464)
	var _t465 = J.G.get("$")
	var _t466 = J.cl(_t465, null, ["#gs-go"])
	var _t467 = Callable(self, "_f111").bind(_s204)
	J.sp(_t466, "onclick", _t467)

func _f113(this_, a: Array, env):
	var v_i_474 = null
	v_i_474 = J.arg(a, 0)
	return J.seq(J.gp(v_i_474, "id"), J.gp(env["v"], "sub"))

func _f114(this_, a: Array, env):
	var v_b_477 = null
	v_b_477 = J.arg(a, 0)
	return J.cmp(env["r"], J.gp(v_b_477, "max"), "<")

func _f112(this_, a: Array, env):
	var v_n_466 = null; var v_s_468 = null; var v_h_469 = null; var v_it_470 = null; var v_floor_471 = null; var v_tries_473 = null; var v_fat_475 = null; var v_band_476 = null
	var _s214 = {"__p": env, "v": null, "r": null}
	v_n_466 = J.arg(a, 0)
	_s214["v"] = J.gp(this_, "view")
	v_s_468 = J.mc(this_, "st", [])
	v_h_469 = J.gp(v_s_468, "hag")
	v_it_470 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f113").bind(_s214)])
	var _t468 = (not J.t(v_it_470))
	var _t469 = (_t468 if _t468 else J.gp(J.gp(v_h_469, "done"), J.gp(v_it_470, "id")))
	var _t470 = (_t469 if J.t(_t469) else J.gp(v_h_469, "out"))
	if J.t((_t470 if J.t(_t470) else (not J.t(J.mc(this_, "coinsOk", [v_n_466]))))):
		return null
	v_floor_471 = J.mc(this_, "floorOf", [v_it_470])
	_s214["r"] = J.div(v_n_466, v_floor_471)
	var _t471 = J.gp(v_h_469, "tries")
	var _t472 = J.gp(v_it_470, "id")
	var _t473 = J.gp(J.gp(v_h_469, "tries"), J.gp(v_it_470, "id"))
	var _t474 = J.add((_t473 if J.t(_t473) else 0.0), 1.0)
	J.sp(_t471, _t472, _t474)
	v_tries_473 = J.gp(J.gp(v_h_469, "tries"), J.gp(v_it_470, "id"))
	var _t475 = _s214["v"]
	J.sp(_t475, "offer", v_n_466)
	if J.cmp(_s214["r"], 1.0, ">="):
		J.mc(this_, "spend", [v_n_466])
		var _t476 = J.gp(J.G.get("S"), "res")
		var _t477 = J.add(J.gp(_t476, "coins"), J.gp(v_it_470, "col"))
		J.sp(_t476, "coins", _t477)
		var _t478 = J.gp(v_h_469, "done")
		var _t479 = J.gp(v_it_470, "id")
		J.sp(_t478, _t479, "bought")
		var _t480 = J.gp(v_s_468, "curios")
		J.mc(_t480, "push", [J.gp(v_it_470, "id")])
		if (J.len(J.gp(v_s_468, "curios")) > 40.0):
			J.mc(J.gp(v_s_468, "curios"), "shift", [])
		v_fat_475 = J.cmp(_s214["r"], 1.08, ">=")
		var _t481 = _s214["v"]
		var _t482 = J.G.get("pick")
		var _t483 = {"band": null, "line": J.add(J.cl(_t482, null, [(J.G.get("GS_DEAL_FAT") if J.t(v_fat_475) else J.G.get("GS_DEAL_TIGHT"))]), ("（收藏家用 " + J.str(J.gp(v_it_470, "col")) + " 收走了，你" + ("賺" if (J.sub(J.gp(v_it_470, "col"), v_n_466) >= 0.0) else "虧") + "了 " + J.str(absf(J.num(J.sub(J.gp(v_it_470, "col"), v_n_466)))) + "）"))}
		J.sp(_t481, "last", _t483)
		var _t484 = _s214["v"]
		J.sp(_t484, "closed", true)
		J.mc(this_, "keeperPose", ["haggle", "cast", 1.6])
		var _t485 = J.gp(this_, "afu")
		J.sp(_t485, "pose", "cast")
		var _t486 = J.gp(this_, "afu")
		J.sp(_t486, "poseT", 1.0)
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), (("+" if (J.sub(J.gp(v_it_470, "col"), v_n_466) >= 0.0) else "−") + J.str(absf(J.num(J.sub(J.gp(v_it_470, "col"), v_n_466)))) + " 冥幣"), ("#ffe08a" if (J.sub(J.gp(v_it_470, "col"), v_n_466) >= 0.0) else "#ff9a8a")])
		J.mc(J.G.get("Sound"), "play", ["coin"])
	else:
		v_band_476 = J.mc(J.G.get("GS_BANDS"), "find", [Callable(self, "_f114").bind(_s214)])
		var _t487 = _s214["v"]
		var _t488 = {"band": v_band_476, "line": J.gp(J.gp(v_band_476, "lines"), J.mod(J.sub(v_tries_473, 1.0), J.len(J.gp(v_band_476, "lines"))))}
		J.sp(_t487, "last", _t488)
		J.mc(this_, "keeperPose", ["haggle", (null if J.seq(J.gp(v_band_476, "pose"), "idle") else J.gp(v_band_476, "pose")), 2.4, true])
		if J.seq(J.gp(v_band_476, "lv"), 0.0):
			J.sp(v_h_469, "strikes", J.num(J.gp(v_h_469, "strikes")) + 1.0)
			J.mc(J.G.get("Sound"), "play", ["hit"])
		else:
			J.mc(J.G.get("Sound"), "play", ["paper"])
		if J.cmp(J.gp(v_h_469, "strikes"), 3.0, ">="):
			J.sp(v_h_469, "out", true)
			var _t489 = J.gp(_s214["v"], "last")
			J.sp(_t489, "line", "三次侮辱我？給我滾！今晚別再來！")
			var _t490 = this_
			J.sp(_t490, "kick", 1.1)
			J.mc(this_, "say", [J.gp(J.gp(this_, "keepers"), "haggle"), "滾！", 2.0])
			var _t491 = J.gp(this_, "afu")
			J.sp(_t491, "pose", "hurt")
			J.mc(J.G.get("Sound"), "play", ["whoosh"])
		else:
			if J.cmp(v_tries_473, 3.0, ">="):
				var _t492 = J.gp(v_h_469, "done")
				var _t493 = J.gp(v_it_470, "id")
				J.sp(_t492, _t493, "shelved")
				var _t494 = J.gp(_s214["v"], "last")
				var _t495 = J.add(J.gp(_t494, "line"), "……三次都談不攏，這件我收起來了！")
				J.sp(_t494, "line", _t495)
				var _t496 = _s214["v"]
				J.sp(_t496, "closed", true)
		var _t499 = J.gp(J.gp(this_, "keepers"), "haggle")
		var _t498 = null
		if (J.len(J.gp(J.gp(_s214["v"], "last"), "line")) > 22.0):
			var _t497 = J.gp(J.gp(_s214["v"], "last"), "line")
			_t498 = J.add(J.mc(_t497, "slice", [0.0, 20.0]), "……")
		else:
			_t498 = J.gp(J.gp(_s214["v"], "last"), "line")
		J.mc(this_, "say", [_t499, _t498, 2.4])
	J.cl(J.G.get("save"), null, [])
	J.mc(this_, "renderPanel", [])

func _f115(this_, a: Array, env):
	var v_d_480 = null; var v_v_481 = null
	v_d_480 = J.arg(a, 0)
	var _t501 = ((1.0 + (0.16 * sin(J.num(J.mul(v_d_480, 0.5))))) + (0.05 * sin(J.num((J.mul(v_d_480, 1.9) + 1.3)))))
	var _t500 = J.G.get("gsRnd")
	v_v_481 = (100.0 * (_t501 + (0.06 * J.sub(J.cl(_t500, null, [(J.mul(v_d_480, 7.0) + 3.0)]), 0.5))))
	return J.max_([30.0, J.round(J.num(v_v_481))])

func _f116(this_, a: Array, env):
	var v_d_484 = null; var v_p_485 = null; var v_y_486 = null; var v_ch_487 = null; var v_up_488 = null; var v_st_489 = null; var v_news_490 = null; var v_val_491 = null; var v_pl_492 = null
	v_d_484 = J.cl(J.G.get("gsDay"), null, [])
	v_p_485 = J.mc(this_, "price", [v_d_484])
	v_y_486 = J.mc(this_, "price", [J.sub(v_d_484, 1.0)])
	v_ch_487 = (J.div(J.sub(v_p_485, v_y_486), v_y_486) * 100.0)
	v_up_488 = J.cmp(J.mc(this_, "price", [J.add(v_d_484, 1.0)]), v_p_485, ">=")
	v_st_489 = J.gp(J.mc(this_, "st", []), "stock")
	var _t503 = (J.G.get("GS_NEWS_UP") if J.t(v_up_488) else J.G.get("GS_NEWS_DN"))
	var _t502 = J.G.get("gsRnd")
	v_news_490 = J.gp(_t503, floor(J.num(J.mul(J.cl(_t502, null, [(J.mul(v_d_484, 5.0) + 1.0)]), 5.0))))
	v_val_491 = J.mul(J.gp(v_st_489, "n"), v_p_485)
	v_pl_492 = (J.sub(v_val_491, J.gp(v_st_489, "cost")) if J.t(J.gp(v_st_489, "n")) else 0.0)
	var _t505 = ("up" if J.cmp(v_ch_487, 0.0, ">=") else "dn")
	var _t506 = ("▲" if J.cmp(v_ch_487, 0.0, ">=") else "▼")
	var _t504 = absf(J.num(v_ch_487))
	var _t508 = J.mc(_t504, "toFixed", [1.0])
	var _t509 = J.gp(v_st_489, "n")
	var _t510 = J.G.get("GS_SHARE_CAP")
	var _t507 = J.G.get("fmt")
	var _t515 = J.cl(_t507, null, [v_val_491])
	var _t514 = null
	if J.t(J.gp(v_st_489, "n")):
		var _t512 = ("up" if J.cmp(v_pl_492, 0.0, ">=") else "dn")
		var _t513 = ("賺" if J.cmp(v_pl_492, 0.0, ">=") else "虧")
		var _t511 = J.G.get("fmt")
		_t514 = ("<span class=\"" + _t512 + "\">" + _t513 + " " + J.str(J.cl(_t511, null, [absf(J.num(v_pl_492))])) + "</span>")
	else:
		_t514 = ""
	return ("<p class=\"gs-line\"><b>白無常</b>一見生財！小道消息：「" + J.str(v_news_490) + "」</p>\n      <div class=\"gs-stock\"><div><small>地府科技（今日）</small><b class=\"gs-px\">" + J.str(v_p_485) + "</b><em class=\"" + _t505 + "\">" + _t506 + " " + J.str(_t508) + "%</em></div><canvas id=\"gs-chart\"></canvas></div>\n      <p class=\"gs-note\">持有 " + J.str(_t509) + " 股（上限 " + J.str(_t510) + "）　市值 " + J.str(_t515) + "　" + _t514 + "　手續費 " + J.str(J.mul(J.G.get("GS_FEE"), 100.0)) + "%（買賣都收）</p>\n      <div class=\"gs-trade\"><button class=\"btn sm gs-t\" data-q=\"1\">買 1</button><button class=\"btn sm gs-t\" data-q=\"10\">買 10</button><button class=\"btn sm gs-t\" data-q=\"-1\">賣 1</button><button class=\"btn sm gs-t\" data-q=\"-10\">賣 10</button><button class=\"btn sm gs-t\" data-q=\"-999\">全賣</button></div>\n      <p class=\"gs-note dim\">價格每天換一次。白無常的小道消息說的是「明天」，他從來沒說錯過——只是不保證漲多少。</p>")

func _f119(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "trade", [env["q"]])

func _f118(this_, a: Array, env):
	var v_b_496 = null; var v_px_498 = null; var v_st_499 = null
	var _s225 = {"__p": env, "q": null}
	v_b_496 = J.arg(a, 0)
	_s225["q"] = J.num(J.gp(J.gp(v_b_496, "dataset"), "q"))
	v_px_498 = J.mc(_s225["__p"]["this"], "price", [J.cl(J.G.get("gsDay"), null, [])])
	v_st_499 = J.gp(J.mc(_s225["__p"]["this"], "st", []), "stock")
	if J.cmp(_s225["q"], 0.0, ">"):
		var _t517 = J.cmp(J.gp(v_st_499, "n"), J.G.get("GS_SHARE_CAP"), ">=")
		var _t518 = (_t517 if _t517 else (not J.t(J.mc(_s225["__p"]["this"], "coinsOk", [ceil(J.num(J.mul(J.mul(v_px_498, J.min_([_s225["q"], J.sub(J.G.get("GS_SHARE_CAP"), J.gp(v_st_499, "n"))])), J.add(1.0, J.G.get("GS_FEE")))))]))))
		J.sp(v_b_496, "disabled", _t518)
	else:
		var _t519 = J.cmp(J.gp(v_st_499, "n"), 0.0, "<=")
		J.sp(v_b_496, "disabled", _t519)
	var _t520 = Callable(self, "_f119").bind(_s225)
	J.sp(v_b_496, "onclick", _t520)

func _f117(this_, a: Array, env):
	var v_p_495 = null
	var _s224 = {"__p": env, "this": null}
	_s224["this"] = this_
	v_p_495 = J.arg(a, 0)
	var _t516 = J.mc(v_p_495, "querySelectorAll", [".gs-t"])
	J.mc(_t516, "forEach", [Callable(self, "_f118").bind(_s224)])
	J.mc(_s224["this"], "drawChart", [])

func _f120(this_, a: Array, env):
	var v_q_502 = null; var v_s_503 = null; var v_st_504 = null; var v_px_505 = null; var v_cost_506 = null; var v_got_507 = null; var v_basis_508 = null
	v_q_502 = J.arg(a, 0)
	v_s_503 = J.mc(this_, "st", [])
	v_st_504 = J.gp(v_s_503, "stock")
	v_px_505 = J.mc(this_, "price", [J.cl(J.G.get("gsDay"), null, [])])
	if J.cmp(v_q_502, 0.0, ">"):
		var _t521 = J.min_([v_q_502, J.sub(J.G.get("GS_SHARE_CAP"), J.gp(v_st_504, "n"))])
		v_q_502 = _t521
		v_cost_506 = ceil(J.num(J.mul(J.mul(v_px_505, v_q_502), J.add(1.0, J.G.get("GS_FEE")))))
		var _t522 = J.cmp(v_q_502, 0.0, "<=")
		if (_t522 if _t522 else (not J.t(J.mc(this_, "coinsOk", [v_cost_506])))):
			return null
		J.mc(this_, "spend", [v_cost_506])
		var _t523 = J.add(J.gp(v_st_504, "n"), v_q_502)
		J.sp(v_st_504, "n", _t523)
		var _t524 = J.add(J.gp(v_st_504, "cost"), v_cost_506)
		J.sp(v_st_504, "cost", _t524)
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), ("買入 " + J.str(v_q_502) + " 股"), "#bfe8ff"])
		var _t526 = J.gp(J.gp(this_, "keepers"), "exch")
		var _t525 = J.G.get("pick")
		J.mc(this_, "say", [_t526, J.cl(_t525, null, [["一見生財！有眼光！", "買定離手～", "恭喜發財，虧了別找我。"]]), 2.4])
	else:
		var _t527 = J.min_([(-J.num(v_q_502)), J.gp(v_st_504, "n")])
		v_q_502 = _t527
		if J.cmp(v_q_502, 0.0, "<="):
			return null
		v_got_507 = floor(J.num((J.mul(v_px_505, v_q_502) * J.sub(1.0, J.G.get("GS_FEE")))))
		v_basis_508 = J.div(J.mul(J.gp(v_st_504, "cost"), v_q_502), J.gp(v_st_504, "n"))
		var _t528 = J.sub(J.gp(v_st_504, "cost"), v_basis_508)
		J.sp(v_st_504, "cost", _t528)
		var _t529 = J.sub(J.gp(v_st_504, "n"), v_q_502)
		J.sp(v_st_504, "n", _t529)
		var _t530 = J.gp(J.G.get("S"), "res")
		var _t531 = J.add(J.gp(_t530, "coins"), v_got_507)
		J.sp(_t530, "coins", _t531)
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), ("賣出 +" + J.str(v_got_507)), ("#ffe08a" if J.cmp(v_got_507, v_basis_508, ">=") else "#ff9a8a")])
		J.mc(this_, "say", [J.gp(J.gp(this_, "keepers"), "exch"), ("一見生財！賺到了吧～" if J.cmp(v_got_507, v_basis_508, ">=") else "虧了？陰間也有韭菜的。"), 2.4])
	if J.seq(J.gp(v_st_504, "n"), 0.0):
		J.sp(v_st_504, "cost", 0.0)
	J.mc(this_, "keeperPose", ["exch", "cast", 1.0])
	J.mc(J.G.get("Sound"), "play", ["coin"])
	J.cl(J.G.get("save"), null, [])
	J.mc(this_, "renderPanel", [])

func _f122(this_, a: Array, env):
	var v___523 = null; var v_i_524 = null
	v___523 = J.arg(a, 0)
	v_i_524 = J.arg(a, 1)
	return J.mc(env["this"], "price", [J.add(J.sub(env["d"], 6.0), v_i_524)])

func _f123(this_, a: Array, env):
	var v_i_525 = null
	v_i_525 = J.arg(a, 0)
	return (10.0 + J.div(J.mul(v_i_525, J.sub(env["w"], 20.0)), 6.0))

func _f124(this_, a: Array, env):
	var v_v_526 = null
	v_v_526 = J.arg(a, 0)
	return (J.sub(env["h"], 16.0) - (J.div(J.sub(v_v_526, env["lo"]), J.sub(env["hi"], env["lo"])) * J.sub(env["h"], 28.0)))

func _f125(this_, a: Array, env):
	var v_v_529 = null; var v_i_530 = null
	v_v_529 = J.arg(a, 0)
	v_i_530 = J.arg(a, 1)
	var _t549 = null
	if J.t(v_i_530):
		var _t543 = env["X"]
		var _t545 = J.cl(_t543, null, [v_i_530])
		var _t544 = env["Y"]
		_t549 = J.mc(env["ctx"], "lineTo", [_t545, J.cl(_t544, null, [v_v_529])])
	else:
		var _t546 = env["X"]
		var _t548 = J.cl(_t546, null, [v_i_530])
		var _t547 = env["Y"]
		_t549 = J.mc(env["ctx"], "moveTo", [_t548, J.cl(_t547, null, [v_v_529])])
	return _t549

func _f126(this_, a: Array, env):
	var v_v_531 = null; var v_i_532 = null
	v_v_531 = J.arg(a, 0)
	v_i_532 = J.arg(a, 1)
	var _t550 = env["ctx"]
	var _t551 = ("#ffcf6a" if J.seq(v_i_532, 6.0) else "#9be8b0")
	J.sp(_t550, "fillStyle", _t551)
	J.mc(env["ctx"], "beginPath", [])
	var _t552 = env["X"]
	var _t554 = J.cl(_t552, null, [v_i_532])
	var _t553 = env["Y"]
	J.mc(env["ctx"], "arc", [_t554, J.cl(_t553, null, [v_v_531]), (4.5 if J.seq(v_i_532, 6.0) else 2.6), 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])

func _f127(this_, a: Array, env):
	var v_l_533 = null; var v_i_534 = null
	v_l_533 = J.arg(a, 0)
	v_i_534 = J.arg(a, 1)
	if (not J.t(v_l_533)):
		return null
	var _t558 = env["ctx"]
	var _t559 = ("left" if J.seq(v_i_534, 0.0) else ("right" if J.seq(v_i_534, 6.0) else "center"))
	J.sp(_t558, "textAlign", _t559)
	var _t562 = null
	if J.seq(v_i_534, 0.0):
		_t562 = 2.0
	else:
		var _t561 = null
		if J.seq(v_i_534, 6.0):
			_t561 = J.sub(env["w"], 2.0)
		else:
			var _t560 = env["X"]
			_t561 = J.cl(_t560, null, [v_i_534])
		_t562 = _t561
	J.mc(env["ctx"], "fillText", [v_l_533, _t562, J.sub(env["h"], 2.0)])

func _f121(this_, a: Array, env):
	var v_c_511 = null; var v_r_512 = null; var v_dpr_513 = null; var v_ps_518 = null; var v_i_527 = null; var v_y_528 = null
	var _s230 = {"__p": env, "this": null, "w": null, "h": null, "ctx": null, "d": null, "lo": null, "hi": null, "X": null, "Y": null}
	_s230["this"] = this_
	var _t532 = J.G.get("$")
	v_c_511 = J.cl(_t532, null, ["#gs-chart"])
	if (not J.t(v_c_511)):
		return null
	v_r_512 = J.mc(v_c_511, "getBoundingClientRect", [])
	var _t533 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t534 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_513 = J.min_([2.0, (_t534 if J.t(_t534) else 1.0)])
	var _t535 = J.gp(v_r_512, "width")
	_s230["w"] = (_t535 if J.t(_t535) else 200.0)
	var _t536 = J.gp(v_r_512, "height")
	_s230["h"] = (_t536 if J.t(_t536) else 84.0)
	var _t537 = J.mul(_s230["w"], v_dpr_513)
	J.sp(v_c_511, "width", _t537)
	var _t538 = J.mul(_s230["h"], v_dpr_513)
	J.sp(v_c_511, "height", _t538)
	_s230["ctx"] = J.mc(v_c_511, "getContext", ["2d"])
	J.mc(_s230["ctx"], "scale", [v_dpr_513, v_dpr_513])
	_s230["d"] = J.cl(J.G.get("gsDay"), null, [])
	v_ps_518 = J.S_Array_("from", [{"length": 7.0}, Callable(self, "_f122").bind(_s230)])
	_s230["lo"] = (J.min_(J.spread([J.SP(v_ps_518)])) * 0.95)
	_s230["hi"] = (J.max_(J.spread([J.SP(v_ps_518)])) * 1.05)
	_s230["X"] = Callable(self, "_f123").bind(_s230)
	_s230["Y"] = Callable(self, "_f124").bind(_s230)
	var _t539 = _s230["ctx"]
	J.sp(_t539, "strokeStyle", "rgba(255,255,255,.12)")
	var _t540 = _s230["ctx"]
	J.sp(_t540, "lineWidth", 1.0)
	v_i_527 = 0.0
	while true:
		if not J.cmp(v_i_527, 3.0, "<"): break
		v_y_528 = (8.0 + J.div(J.mul(v_i_527, J.sub(_s230["h"], 24.0)), 2.0))
		J.mc(_s230["ctx"], "beginPath", [])
		J.mc(_s230["ctx"], "moveTo", [4.0, v_y_528])
		J.mc(_s230["ctx"], "lineTo", [J.sub(_s230["w"], 4.0), v_y_528])
		J.mc(_s230["ctx"], "stroke", [])
		v_i_527 = J.num(v_i_527) + 1.0
	var _t541 = _s230["ctx"]
	J.sp(_t541, "strokeStyle", "#9be8b0")
	var _t542 = _s230["ctx"]
	J.sp(_t542, "lineWidth", 2.2)
	J.mc(_s230["ctx"], "beginPath", [])
	J.mc(v_ps_518, "forEach", [Callable(self, "_f125").bind(_s230)])
	J.mc(_s230["ctx"], "stroke", [])
	J.mc(v_ps_518, "forEach", [Callable(self, "_f126").bind(_s230)])
	var _t555 = _s230["ctx"]
	J.sp(_t555, "fillStyle", "rgba(230,220,255,.7)")
	var _t556 = _s230["ctx"]
	J.sp(_t556, "font", "11px sans-serif")
	var _t557 = ["六天前", "", "", "", "", "昨天", "今天"]
	J.mc(_t557, "forEach", [Callable(self, "_f127").bind(_s230)])

func _f129(this_, a: Array, env):
	var v_k_538 = null; var v_m_539 = null
	v_k_538 = J.arg(a, 0)
	v_m_539 = J.gp(J.G.get("GS_MEALS"), v_k_538)
	var _t565 = ("own" if J.seq(J.gp(env["s"], "meal"), v_k_538) else "")
	var _t566 = J.gp(v_m_539, "name")
	var _t567 = J.gp(v_m_539, "eff")
	var _t568 = J.gp(v_m_539, "say")
	var _t564 = J.gp(env["this"], "ate")
	return ("<div class=\"gs-card " + _t565 + "\"><div class=\"gs-ci\"><b>" + J.str(_t566) + "</b><small class=\"gs-eff\">" + J.str(_t567) + "</small><small>" + J.str(_t568) + "</small></div>\n          <button class=\"btn gold sm gs-eat\" data-k=\"" + J.str(v_k_538) + "\" " + ("disabled" if J.t((_t564 if J.t(_t564) else (not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_m_539, "price")]))))) else "") + ">" + ("吃飽了" if J.t(J.gp(env["this"], "ate")) else ("吃 " + J.str(J.gp(v_m_539, "price")))) + "</button></div>")

func _f128(this_, a: Array, env):
	var _s239 = {"__p": env, "this": null, "s": null}
	_s239["this"] = this_
	_s239["s"] = J.mc(_s239["this"], "st", [])
	var _t570 = ("吃飽了就走！後面還有鬼在排隊！" if J.t(J.gp(_s239["this"], "ate")) else "一次只准點一碗！吃完下一場打架才有力！")
	var _t571 = (("<p class=\"gs-note\">肚子裡：<b>" + J.str(J.gp(J.gp(J.G.get("GS_MEALS"), J.gp(_s239["s"], "meal")), "name")) + "</b>（下一場出征生效，再點會換掉）</p>") if J.t(J.gp(_s239["s"], "meal")) else "")
	var _t563 = J.S_Object_("keys", [J.G.get("GS_MEALS")])
	var _t569 = J.mc(_t563, "map", [Callable(self, "_f129").bind(_s239)])
	return ("<p class=\"gs-line\"><b>餓鬼王</b>" + _t570 + "</p>\n      " + _t571 + "\n      <div class=\"gs-list\">" + J.str(J.mc(_t569, "join", [""])) + "</div>")

func _f132(this_, a: Array, env):
	var v_k_544 = null; var v_m_545 = null
	v_k_544 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_m_545 = J.gp(J.G.get("GS_MEALS"), v_k_544)
	var _t574 = J.gp(env["__p"]["this"], "ate")
	if J.t((_t574 if J.t(_t574) else (not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_m_545, "price")]))))):
		return null
	J.mc(env["__p"]["this"], "spend", [J.gp(v_m_545, "price")])
	var _t575 = J.mc(env["__p"]["this"], "st", [])
	J.sp(_t575, "meal", v_k_544)
	var _t576 = env["__p"]["this"]
	J.sp(_t576, "ate", true)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("Sound"), "play", ["harvest"])
	var _t578 = J.gp(J.gp(env["__p"]["this"], "keepers"), "food")
	var _t577 = J.G.get("pick")
	J.mc(env["__p"]["this"], "say", [_t578, J.cl(_t577, null, [["吃！吃完去打！", "好吃吧？我也想吃……我可以吃一口嗎？", "湯可以續，碗不能拿走！"]]), 2.6])
	J.mc(env["__p"]["this"], "keeperPose", ["food", "cast", 1.2])
	var _t579 = J.gp(env["__p"]["this"], "afu")
	J.sp(_t579, "pose", "cast")
	var _t580 = J.gp(env["__p"]["this"], "afu")
	J.sp(_t580, "poseT", 0.8)
	var _t582 = J.gp(J.gp(env["__p"]["this"], "afu"), "x")
	var _t583 = J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16)
	var _t581 = J.gp(v_m_545, "eff")
	J.mc(env["__p"]["this"], "float", [_t582, _t583, J.mc(_t581, "replace", ["下一場出征：", ""]), "#a8ffcf"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f131(this_, a: Array, env):
	var _s242 = {"__p": env, "b": null}
	_s242["b"] = J.arg(a, 0)
	var _t573 = _s242["b"]
	var _t584 = Callable(self, "_f132").bind(_s242)
	J.sp(_t573, "onclick", _t584)
	return _t584

func _f130(this_, a: Array, env):
	var v_p_542 = null
	var _s241 = {"__p": env, "this": null}
	_s241["this"] = this_
	v_p_542 = J.arg(a, 0)
	var _t572 = J.mc(v_p_542, "querySelectorAll", [".gs-eat"])
	J.mc(_t572, "forEach", [Callable(self, "_f131").bind(_s241)])

func _f134(this_, a: Array, env):
	var v_e_552 = null
	v_e_552 = J.arg(a, 0)
	return (not J.seq(J.gp(v_e_552, "id"), J.gp(env["s"], "alleyLast")))

func _f135(this_, a: Array, env):
	var v_o_553 = null; var v_k_554 = null
	v_o_553 = J.arg(a, 0)
	v_k_554 = J.arg(a, 1)
	var _t592 = ("gold" if J.seq(v_k_554, "a") else "")
	var _t591 = J.gp(v_o_553, "cost")
	return ("<button class=\"btn " + _t592 + " wide gs-al\" data-k=\"" + J.str(v_k_554) + "\" " + ("disabled" if J.t(((not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_o_553, "cost")]))) if J.t(_t591) else _t591)) else "") + ">" + J.str(J.gp(v_o_553, "label")) + (("（" + J.str(J.gp(v_o_553, "cost")) + " 冥幣）") if J.t(J.gp(v_o_553, "cost")) else "") + "</button>")

func _f133(this_, a: Array, env):
	var v_e_548 = null; var v_opt_549 = null; var v_pool_551 = null
	var _s244 = {"__p": env, "this": null}
	_s244["this"] = this_
	if J.t(J.gp(_s244["this"], "alleyDone")):
		return ("<p class=\"gs-line\">" + J.str(J.gp(J.gp(_s244["this"], "alleyDone"), "out")) + "</p><p class=\"gs-note\">" + (J.add("結果：", J.gp(J.gp(_s244["this"], "alleyDone"), "got")) if J.t(J.gp(J.gp(_s244["this"], "alleyDone"), "got")) else "") + "</p><p class=\"gs-note dim\">今晚巷子裡已經沒有別的事了。下次再來看看。</p>")
	if (not J.t(J.gp(_s244["this"], "alleyEv"))):
		var _s245 = {"__p": _s244, "s": null}
		_s245["s"] = J.mc(_s245["__p"]["this"], "st", [])
		v_pool_551 = J.mc(J.G.get("GS_ALLEY"), "filter", [Callable(self, "_f134").bind(_s245)])
		var _t585 = _s245["__p"]["this"]
		var _t586 = (not J.seq(J.typeof_(J.G.get("N30W")), "undefined"))
		var _t587 = (J.mc(J.G.get("N30W"), "alleyEvent", []) if _t586 else _t586)
		var _t588 = (_t587 if J.t(_t587) else J.gp(v_pool_551, floor(J.num((randf() * J.len(v_pool_551))))))
		J.sp(_t585, "alleyEv", _t588)
		var _t589 = _s245["s"]
		var _t590 = J.gp(J.gp(_s245["__p"]["this"], "alleyEv"), "id")
		J.sp(_t589, "alleyLast", _t590)
		J.cl(J.G.get("save"), null, [])
	v_e_548 = J.gp(_s244["this"], "alleyEv")
	v_opt_549 = Callable(self, "_f135").bind(_s244)
	return ("<p class=\"gs-line\">" + J.str(J.gp(v_e_548, "text")) + "</p>" + J.str(J.cl(v_opt_549, null, [J.gp(v_e_548, "a"), "a"])) + J.str(J.cl(v_opt_549, null, [J.gp(v_e_548, "b"), "b"])))

func _f138(this_, a: Array, env):
	var v_o_559 = null; var v_r_560 = null; var v_got_561 = null
	v_o_559 = J.gp(J.gp(env["__p"]["this"], "alleyEv"), J.gp(J.gp(env["b"], "dataset"), "k"))
	var _t595 = J.gp(v_o_559, "cost")
	if J.t(((not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_o_559, "cost")]))) if J.t(_t595) else _t595)):
		return null
	if J.t(J.gp(v_o_559, "cost")):
		J.mc(env["__p"]["this"], "spend", [J.gp(v_o_559, "cost")])
	var _t597 = {}
	var _t596 = J.gp(v_o_559, "give")
	v_r_560 = J.S_Object_("assign", [_t597, (_t596 if J.t(_t596) else {})])
	if J.t(J.gp(v_r_560, "troops")):
		var _t598 = J.max_([0.0, J.min_([J.gp(v_r_560, "troops"), J.sub(J.mc(J.G.get("F"), "troopCap", []), J.gp(J.gp(J.G.get("S"), "res"), "troops"))])])
		J.sp(v_r_560, "troops", _t598)
	if J.seq(J.gp(v_r_560, "troops"), 0.0):
		J.del(v_r_560, "troops")
	var _t600 = null
	if J.t(J.len(J.S_Object_("keys", [v_r_560]))):
		var _t599 = J.G.get("give")
		_t600 = J.cl(_t599, null, [v_r_560])
	else:
		_t600 = ""
	v_got_561 = _t600
	if J.t(J.gp(v_o_559, "cost")):
		var _t601 = (("冥幣 −" + J.str(J.gp(v_o_559, "cost"))) + (J.add("，", v_got_561) if J.t(v_got_561) else ""))
		v_got_561 = _t601
	if J.t(J.gp(v_o_559, "join")):
		var _t602 = J.G.get("joinGhost")
		J.cl(_t602, null, [J.gp(v_o_559, "join")])
		var _t603 = J.add(v_got_561, (("，" if J.t(v_got_561) else "") + (J.str(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_o_559, "join")), "name")) + "加入")))
		v_got_561 = _t603
	var _t604 = env["__p"]["this"]
	var _t605 = {"out": J.gp(v_o_559, "out"), "got": v_got_561}
	J.sp(_t604, "alleyDone", _t605)
	J.mc(J.G.get("Sound"), "play", [("chest" if J.t(J.gp(v_r_560, "chest")) else "paper")])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	var _t607 = J.gp(J.gp(env["__p"]["this"], "afu"), "x")
	var _t608 = J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16)
	var _t606 = J.gp(J.mc(v_got_561, "split", ["，"]), 0.0)
	J.mc(env["__p"]["this"], "float", [_t607, _t608, (_t606 if J.t(_t606) else "……"), "#e6dcff"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f137(this_, a: Array, env):
	var _s249 = {"__p": env, "b": null}
	_s249["b"] = J.arg(a, 0)
	var _t594 = _s249["b"]
	var _t609 = Callable(self, "_f138").bind(_s249)
	J.sp(_t594, "onclick", _t609)
	return _t609

func _f136(this_, a: Array, env):
	var v_p_557 = null
	var _s248 = {"__p": env, "this": null}
	_s248["this"] = this_
	v_p_557 = J.arg(a, 0)
	var _t593 = J.mc(v_p_557, "querySelectorAll", [".gs-al"])
	J.mc(_t593, "forEach", [Callable(self, "_f137").bind(_s248)])
