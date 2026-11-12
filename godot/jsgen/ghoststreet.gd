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
	J.G["GhostStreet"] = {"active": false, "st": Callable(self, "_f3").bind(env), "mul": Callable(self, "_f4").bind(env), "bonus": Callable(self, "_f5").bind(env), "battleBuffs": Callable(self, "_f6").bind(env), "open": Callable(self, "_f13").bind(env), "close": Callable(self, "_f25").bind(env), "resize": Callable(self, "_f26").bind(env), "targetVH": Callable(self, "_f27").bind(env), "geo": Callable(self, "_f28").bind(env), "X": Callable(self, "_f29").bind(env), "Y": Callable(self, "_f30").bind(env), "depth": Callable(self, "_f31").bind(env), "charScale": Callable(self, "_f32").bind(env), "toWorld": Callable(self, "_f33").bind(env), "down": Callable(self, "_f34").bind(env), "move": Callable(self, "_f35").bind(env), "up": Callable(self, "_f36").bind(env), "walkTo": Callable(self, "_f37").bind(env), "goStall": Callable(self, "_f38").bind(env), "arrive": Callable(self, "_f39").bind(env), "frame": Callable(self, "_f41").bind(env), "step": Callable(self, "_f44").bind(env), "mkJoss": Callable(self, "_f50").bind(env), "avoid": Callable(self, "_f51").bind(env), "chat": Callable(self, "_f52").bind(env), "say": Callable(self, "_f53").bind(env), "float": Callable(self, "_f54").bind(env), "draw": Callable(self, "_f56").bind(env), "glow": Callable(self, "_f63").bind(env), "drawFog": Callable(self, "_f64").bind(env), "drawParts": Callable(self, "_f66").bind(env), "drawLanternString": Callable(self, "_f67").bind(env), "drawSigns": Callable(self, "_f68").bind(env), "nearStall": Callable(self, "_f69").bind(env), "drawAfu": Callable(self, "_f70").bind(env), "drawKeeper": Callable(self, "_f71").bind(env), "drawWalker": Callable(self, "_f72").bind(env), "bubble": Callable(self, "_f73").bind(env), "renderPanel": Callable(self, "_f76").bind(env), "relax": Callable(self, "_f81").bind(env), "keeperPose": Callable(self, "_f82").bind(env), "coinsOk": Callable(self, "_f83").bind(env), "spend": Callable(self, "_f84").bind(env), "html_paper": Callable(self, "_f85").bind(env), "bind_paper": Callable(self, "_f87").bind(env), "burn": Callable(self, "_f90").bind(env), "todayItems": Callable(self, "_f91").bind(env), "floorOf": Callable(self, "_f95").bind(env), "askOf": Callable(self, "_f96").bind(env), "html_haggle": Callable(self, "_f97").bind(env), "bind_haggle": Callable(self, "_f101").bind(env), "offer": Callable(self, "_f111").bind(env), "price": Callable(self, "_f114").bind(env), "html_exch": Callable(self, "_f115").bind(env), "bind_exch": Callable(self, "_f116").bind(env), "trade": Callable(self, "_f119").bind(env), "drawChart": Callable(self, "_f120").bind(env), "html_food": Callable(self, "_f127").bind(env), "bind_food": Callable(self, "_f129").bind(env), "html_alley": Callable(self, "_f132").bind(env), "bind_alley": Callable(self, "_f135").bind(env)}

func _f1(this_, a: Array, env):
	var v_d_27 = null
	v_d_27 = J.new_("Date", [])
	return floor(J.num(J.div(J.sub(J.mc(v_d_27, "getTime", []), J.mul(J.mc(v_d_27, "getTimezoneOffset", []), 60000.0)), 86400000.0)))

func _f2(this_, a: Array, env):
	var v_n_30 = null
	v_n_30 = J.arg(a, 0)
	var _t1 = J.bxor(J.bor(v_n_30, 0.0), 1540483477.0)
	v_n_30 = _t1
	var _t2 = J.math("imul", [J.bxor(v_n_30, J.ushr(v_n_30, 15.0)), 739982445.0])
	v_n_30 = _t2
	var _t3 = J.math("imul", [J.bxor(v_n_30, J.ushr(v_n_30, 12.0)), 695872825.0])
	v_n_30 = _t3
	var _t4 = J.bxor(v_n_30, J.ushr(v_n_30, 15.0))
	v_n_30 = _t4
	return J.div(J.ushr(v_n_30, 0.0), 4294967296.0)

func _f3(this_, a: Array, env):
	var v_s_33 = null
	if (not J.t(J.G.get("S"))):
		return {"fx": {}}
	var _t5 = J.G.get("S")
	var _t6 = J.gp(J.G.get("S"), "street")
	var _t7 = (_t6 if J.t(_t6) else {})
	J.sp(_t5, "street", _t7)
	v_s_33 = _t7
	var _t8 = J.gp(v_s_33, "fx")
	var _t9 = (_t8 if J.t(_t8) else {})
	J.sp(v_s_33, "fx", _t9)
	var _t10 = J.gp(v_s_33, "meal")
	var _t11 = (_t10 if J.t(_t10) else null)
	J.sp(v_s_33, "meal", _t11)
	var _t12 = J.gp(v_s_33, "visits")
	var _t13 = (_t12 if J.t(_t12) else 0.0)
	J.sp(v_s_33, "visits", _t13)
	var _t14 = J.gp(v_s_33, "seen")
	var _t15 = (_t14 if J.t(_t14) else {})
	J.sp(v_s_33, "seen", _t15)
	var _t16 = J.gp(v_s_33, "stock")
	var _t17 = (_t16 if J.t(_t16) else {"n": 0.0, "cost": 0.0})
	J.sp(v_s_33, "stock", _t17)
	var _t18 = J.gp(v_s_33, "curios")
	var _t19 = (_t18 if J.t(_t18) else [])
	J.sp(v_s_33, "curios", _t19)
	var _t20 = (not J.t(J.gp(v_s_33, "hag")))
	if (_t20 if _t20 else (not J.seq(J.gp(J.gp(v_s_33, "hag"), "day"), J.cl(J.G.get("gsDay"), null, [])))):
		var _t21 = {"day": J.cl(J.G.get("gsDay"), null, []), "done": {}, "tries": {}, "strikes": 0.0, "out": false}
		J.sp(v_s_33, "hag", _t21)
	return v_s_33

func _f4(this_, a: Array, env):
	var v_kind_36 = null; var v_fx_37 = null
	v_kind_36 = J.arg(a, 0)
	var _t22 = (J.gp(J.G.get("S"), "street") if J.t(J.G.get("S")) else J.G.get("S"))
	var _t23 = (J.gp(J.gp(J.G.get("S"), "street"), "fx") if J.t(_t22) else _t22)
	v_fx_37 = (_t23 if J.t(_t23) else {})
	if J.seq(v_kind_36, "walk"):
		return (1.15 if J.t(J.gp(v_fx_37, "car")) else 1.0)
	if J.seq(v_kind_36, "work"):
		return (1.1 if J.t(J.gp(v_fx_37, "coffee")) else 1.0)
	if J.seq(v_kind_36, "hp"):
		return (1.05 if J.t(J.gp(v_fx_37, "chair")) else 1.0)
	return 1.0

func _f5(this_, a: Array, env):
	var v_kind_40 = null; var v_fx_41 = null
	v_kind_40 = J.arg(a, 0)
	var _t24 = (J.gp(J.G.get("S"), "street") if J.t(J.G.get("S")) else J.G.get("S"))
	var _t25 = (J.gp(J.gp(J.G.get("S"), "street"), "fx") if J.t(_t24) else _t24)
	v_fx_41 = (_t25 if J.t(_t25) else {})
	if J.seq(v_kind_40, "mana"):
		return (25.0 if J.t(J.gp(v_fx_41, "phone")) else 0.0)
	return 0.0

func _f7(this_, a: Array, env):
	var v_u_48 = null
	v_u_48 = J.arg(a, 0)
	return J.seq(J.gp(v_u_48, "side"), 0.0)

func _f8(this_, a: Array, env):
	var v_u_49 = null
	v_u_49 = J.arg(a, 0)
	var _t27 = J.mul(J.gp(v_u_49, "maxhp"), env["hpm"])
	J.sp(v_u_49, "maxhp", _t27)
	var _t28 = J.mul(J.gp(v_u_49, "hp"), env["hpm"])
	J.sp(v_u_49, "hp", _t28)

func _f9(this_, a: Array, env):
	var v_u_50 = null
	v_u_50 = J.arg(a, 0)
	var _t31 = J.mul(J.gp(v_u_50, "atk"), 1.15)
	J.sp(v_u_50, "atk", _t31)
	return _t31

func _f10(this_, a: Array, env):
	var v_u_51 = null
	v_u_51 = J.arg(a, 0)
	var _t32 = J.mul(J.gp(v_u_51, "maxhp"), 1.15)
	J.sp(v_u_51, "maxhp", _t32)
	var _t33 = J.mul(J.gp(v_u_51, "hp"), 1.15)
	J.sp(v_u_51, "hp", _t33)

func _f11(this_, a: Array, env):
	var v_u_52 = null
	v_u_52 = J.arg(a, 0)
	return (not J.t(J.gp(v_u_52, "minion")))

func _f12(this_, a: Array, env):
	var v_u_53 = null
	v_u_53 = J.arg(a, 0)
	var _t35 = J.gp(v_u_53, "energy")
	var _t36 = J.gp(v_u_53, "energy")
	var _t37 = J.min_([100.0, J.add((_t36 if J.t(_t36) else 0.0), 40.0)])
	J.sp(v_u_53, "energy", _t37)
	return _t37

func _f6(this_, a: Array, env):
	var v_units_44 = null; var v_own_45 = null; var v_m_47 = null; var v_e_54 = null
	var _s7 = {"__p": env, "hpm": null}
	v_units_44 = J.arg(a, 0)
	var _t26 = (not J.t(J.G.get("S")))
	if (_t26 if _t26 else (not J.t(v_units_44))):
		return ""
	v_own_45 = J.mc(v_units_44, "filter", [Callable(self, "_f7").bind(_s7)])
	_s7["hpm"] = J.mc(this_, "mul", ["hp"])
	if (not J.seq(_s7["hpm"], 1.0)):
		J.mc(v_own_45, "forEach", [Callable(self, "_f8").bind(_s7)])
	var _t29 = J.gp(J.G.get("S"), "street")
	v_m_47 = (J.gp(J.gp(J.G.get("S"), "street"), "meal") if J.t(_t29) else _t29)
	var _t30 = (not J.t(v_m_47))
	if (_t30 if _t30 else (not J.t(J.gp(J.G.get("GS_MEALS"), v_m_47)))):
		return ""
	if J.seq(v_m_47, "mala"):
		J.mc(v_own_45, "forEach", [Callable(self, "_f9").bind(_s7)])
	if J.seq(v_m_47, "bkt"):
		J.mc(v_own_45, "forEach", [Callable(self, "_f10").bind(_s7)])
	if J.seq(v_m_47, "teh"):
		var _t34 = J.mc(v_own_45, "filter", [Callable(self, "_f11").bind(_s7)])
		J.mc(_t34, "forEach", [Callable(self, "_f12").bind(_s7)])
	var _t38 = J.gp(J.G.get("S"), "street")
	J.sp(_t38, "meal", null)
	J.cl(J.G.get("save"), null, [])
	var _t40 = J.gp(J.gp(J.G.get("GS_MEALS"), v_m_47), "name")
	var _t39 = J.gp(J.gp(J.G.get("GS_MEALS"), v_m_47), "eff")
	J.mc(J.G.get("Fx"), "toast", [("宵夜生效：<b>" + J.str(_t40) + "</b>（" + J.str(J.mc(_t39, "replace", ["下一場出征：", ""])) + "）")])
	return J.gp(J.gp(J.G.get("GS_MEALS"), v_m_47), "name")

func _f14(this_, a: Array, env):
	var v_k_63 = null; var v_i_64 = null
	v_k_63 = J.arg(a, 0)
	v_i_64 = J.arg(a, 1)
	return {"k": v_k_63, "x": ((0.1 + J.mul(v_i_64, 0.19)) + (randf() * 0.05)), "y": (0.79 + (randf() * 0.13)), "tx": 0.0, "ty": 0.0, "wait": (1.0 + (randf() * 4.0)), "dir": (1.0 if (randf() < 0.5) else (-1.0)), "ph": (randf() * 6.0), "bub": null, "bubT": 0.0, "chatT": ((2.0 + J.mul(v_i_64, 2.6)) + (randf() * 2.0))}

func _f15(this_, a: Array, env):
	var v_w_65 = null
	v_w_65 = J.arg(a, 0)
	var _t51 = J.gp(v_w_65, "x")
	J.sp(v_w_65, "tx", _t51)
	var _t52 = J.gp(v_w_65, "y")
	J.sp(v_w_65, "ty", _t52)
	var _t53 = (J.S_Object_("assign", [{"seed": randf()}, J.gp(J.G.get("GS_PROPS"), J.gp(v_w_65, "k"))]) if J.t(J.gp(J.G.get("GS_PROPS"), J.gp(v_w_65, "k"))) else null)
	J.sp(v_w_65, "prop", _t53)
	J.sp(v_w_65, "look", 0.0)
	J.sp(v_w_65, "bump", 0.0)

func _f16(this_, a: Array, env):
	var v___66 = null; var v_i_67 = null
	v___66 = J.arg(a, 0)
	v_i_67 = J.arg(a, 1)
	return {"x": randf(), "y": (0.66 + (randf() * 0.3)), "r": (0.12 + (randf() * 0.12)), "v": ((0.004 + (randf() * 0.008)) * (1.0 if J.t(J.mod(v_i_67, 2.0)) else (-1.0))), "a": (0.05 + (randf() * 0.06))}

func _f17(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	J.mc(env["this"], "close", [])

func _f18(this_, a: Array, env):
	var v_e_69 = null
	v_e_69 = J.arg(a, 0)
	return J.mc(env["this"], "down", [v_e_69])

func _f19(this_, a: Array, env):
	var v_e_70 = null
	v_e_70 = J.arg(a, 0)
	return J.mc(env["this"], "move", [v_e_70])

func _f20(this_, a: Array, env):
	var v_e_71 = null
	v_e_71 = J.arg(a, 0)
	return J.mc(env["this"], "up", [v_e_71])

func _f21(this_, a: Array, env):
	var _t67 = env["this"]
	J.sp(_t67, "drag", null)

func _f22(this_, a: Array, env):
	if J.t(J.gp(env["this"], "active")):
		J.mc(env["this"], "resize", [])

func _f23(this_, a: Array, env):
	var v_n_72 = null
	v_n_72 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_72])

func _f24(this_, a: Array, env):
	return J.mc(env["this"], "say", [J.gp(J.gp(env["this"], "walkers"), 0.0), "新來的？這裡是下班後的陰間，慢慢逛。", 4.0])

func _f13(this_, a: Array, env):
	var v_s_57 = null; var v_used_58 = null; var v_el_59 = null; var v_cv_60 = null; var v_k_61 = null; var v_d_62 = null; var v_i_68 = null
	var _s17 = {"__p": env, "this": null}
	_s17["this"] = this_
	v_s_57 = J.mc(_s17["this"], "st", [])
	J.sp(v_s_57, "visits", J.num(J.gp(v_s_57, "visits")) + 1.0)
	J.S_Object_("assign", [_s17["this"], {"active": true, "t": 0.0, "view": {"k": "idle"}, "parts": [], "floats": [], "ate": false, "alleyDone": null, "alleyEv": null, "vh": 0.0, "cam": 0.0, "pend": null, "drag": null, "kick": 0.0}])
	var _t41 = _s17["this"]
	var _t42 = {"x": 0.06, "y": 0.84, "tx": 0.06, "ty": 0.84, "dir": 1.0, "walking": false, "dustT": 0.0, "pose": null, "poseT": 0.0}
	J.sp(_t41, "afu", _t42)
	var _t43 = _s17["this"]
	var _t44 = {}
	J.sp(_t43, "keepers", _t44)
	for _t45 in J.keys(J.G.get("GS_STALLS")):
		v_k_61 = _t45
		v_d_62 = J.gp(J.G.get("GS_STALLS"), v_k_61)
		if J.t(J.gp(v_d_62, "keeper")):
			var _t46 = J.gp(_s17["this"], "keepers")
			var _t47 = {"k": J.gp(v_d_62, "keeper"), "x": J.gp(v_d_62, "kx"), "y": J.gp(v_d_62, "ky"), "pose": null, "pt": 0.0, "poseT": 0.0, "bub": null, "bubT": 0.0, "ph": (randf() * 6.0)}
			J.sp(_t46, v_k_61, _t47)
	v_used_58 = J.new_("Set", [])
	var _t48 = _s17["this"]
	var _t49 = J.mc(J.G.get("GS_WANDER"), "map", [Callable(self, "_f14").bind(_s17)])
	J.sp(_t48, "walkers", _t49)
	var _t50 = J.gp(_s17["this"], "walkers")
	J.mc(_t50, "forEach", [Callable(self, "_f15").bind(_s17)])
	var _t54 = _s17["this"]
	var _t55 = (10.0 + (randf() * 8.0))
	J.sp(_t54, "bumpCD", _t55)
	var _t56 = _s17["this"]
	J.sp(_t56, "chatUsed", v_used_58)
	var _t57 = _s17["this"]
	var _t58 = J.S_Array_("from", [{"length": 9.0}, Callable(self, "_f16").bind(_s17)])
	J.sp(_t57, "fog", _t58)
	v_i_68 = 0.0
	while true:
		if not J.cmp(v_i_68, 14.0, "<"): break
		var _t59 = J.gp(_s17["this"], "parts")
		J.mc(_t59, "push", [J.mc(_s17["this"], "mkJoss", [true])])
		v_i_68 = J.num(v_i_68) + 1.0
	var _t60 = J.G.get("$")
	v_el_59 = J.cl(_t60, null, ["#gstreet"])
	var _t61 = J.gp(v_el_59, "classList")
	J.mc(_t61, "add", ["on"])
	var _t62 = ("<div id=\"gs-top\"><button class=\"btn sm\" id=\"gs-back\">回村</button><b>冥街夜市</b><span id=\"gs-coins\"><svg><use href=\"#i-coins\"/></svg><i></i></span></div>\n      <div id=\"gs-stage\"><canvas id=\"gs-cvs\"></canvas></div><div id=\"gs-panel\"></div>")
	J.sp(v_el_59, "innerHTML", _t62)
	var _t63 = J.G.get("$")
	var _t64 = J.cl(_t63, null, ["#gs-back"])
	var _t65 = Callable(self, "_f17").bind(_s17)
	J.sp(_t64, "onclick", _t65)
	var _t66 = J.G.get("$")
	v_cv_60 = J.cl(_t66, null, ["#gs-cvs"])
	J.mc(v_cv_60, "addEventListener", ["pointerdown", Callable(self, "_f18").bind(_s17)])
	J.mc(v_cv_60, "addEventListener", ["pointermove", Callable(self, "_f19").bind(_s17)])
	J.mc(v_cv_60, "addEventListener", ["pointerup", Callable(self, "_f20").bind(_s17)])
	J.mc(v_cv_60, "addEventListener", ["pointercancel", Callable(self, "_f21").bind(_s17)])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	J.mc(_s17["this"], "resize", [])
	if (not J.t(J.gp(_s17["this"], "_rs"))):
		var _t68 = _s17["this"]
		J.sp(_t68, "_rs", true)
		J.S_window_("addEventListener", ["resize", Callable(self, "_f22").bind(_s17)])
	J.mc(_s17["this"], "renderPanel", [])
	var _t69 = _s17["this"]
	var _t70 = J.mc(_s17["this"], "targetVH", [])
	J.sp(_t69, "vh", _t70)
	var _t71 = _s17["this"]
	var _t72 = J.S_performance_("now", [])
	J.sp(_t71, "last", _t72)
	J.F_requestAnimationFrame([Callable(self, "_f23").bind(_s17)])
	if (not J.t(J.gp(J.gp(v_s_57, "seen"), "street"))):
		var _t73 = J.gp(v_s_57, "seen")
		J.sp(_t73, "street", 1.0)
		J.F_setTimeout([Callable(self, "_f24").bind(_s17), 700.0])
	J.cl(J.G.get("save"), null, [])

func _f25(this_, a: Array, env):
	if (not J.t(J.gp(this_, "active"))):
		return null
	var _t74 = this_
	J.sp(_t74, "active", false)
	var _t75 = J.G.get("$")
	var _t76 = J.gp(J.cl(_t75, null, ["#gstreet"]), "classList")
	J.mc(_t76, "remove", ["on"])
	var _t77 = J.G.get("$")
	var _t78 = J.cl(_t77, null, ["#gstreet"])
	J.sp(_t78, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f26(this_, a: Array, env):
	var v_c_77 = null; var v_box_78 = null; var v_r_79 = null; var v_dpr_80 = null
	var _t79 = J.G.get("$")
	v_c_77 = J.cl(_t79, null, ["#gs-cvs"])
	var _t80 = J.G.get("$")
	v_box_78 = J.cl(_t80, null, ["#gs-stage"])
	var _t81 = (not J.t(v_c_77))
	if (_t81 if _t81 else (not J.t(v_box_78))):
		return null
	v_r_79 = J.mc(v_box_78, "getBoundingClientRect", [])
	var _t82 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t83 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_80 = J.min_([2.0, (_t83 if J.t(_t83) else 1.0)])
	var _t84 = J.mul(J.gp(v_r_79, "width"), v_dpr_80)
	J.sp(v_c_77, "width", _t84)
	var _t85 = J.mul(J.gp(v_r_79, "height"), v_dpr_80)
	J.sp(v_c_77, "height", _t85)
	var _t86 = J.gp(v_c_77, "style")
	var _t87 = J.add(J.gp(v_r_79, "width"), "px")
	J.sp(_t86, "width", _t87)
	var _t88 = J.gp(v_c_77, "style")
	var _t89 = J.add(J.gp(v_r_79, "height"), "px")
	J.sp(_t88, "height", _t89)
	var _t90 = this_
	var _t91 = J.gp(v_r_79, "width")
	J.sp(_t90, "W", _t91)
	var _t92 = this_
	var _t93 = J.gp(v_r_79, "height")
	J.sp(_t92, "H", _t93)
	var _t94 = this_
	J.sp(_t94, "dpr", v_dpr_80)

func _f27(this_, a: Array, env):
	var v_p_83 = null
	var _t95 = J.G.get("$")
	v_p_83 = J.cl(_t95, null, ["#gs-panel"])
	var _t96 = J.gp(this_, "H")
	var _t97 = J.gp(this_, "H")
	return J.max_([260.0, (J.sub((_t97 if J.t(_t97) else 700.0), (J.gp(v_p_83, "offsetHeight") if J.t(v_p_83) else 0.0)) + 6.0)])

func _f28(this_, a: Array, env):
	var v_img_86 = null; var v_iw_87 = null; var v_ih_88 = null; var v_IH_89 = null; var v_IW_90 = null
	v_img_86 = J.gp(J.G.get("SPR"), "bg_street")
	var _t98 = (J.gp(v_img_86, "naturalWidth") if J.t(v_img_86) else v_img_86)
	v_iw_87 = (_t98 if J.t(_t98) else 1536.0)
	var _t99 = (J.gp(v_img_86, "naturalHeight") if J.t(v_img_86) else v_img_86)
	v_ih_88 = (_t99 if J.t(_t99) else 1024.0)
	var _t100 = J.gp(this_, "vh")
	v_IH_89 = (_t100 if J.t(_t100) else 500.0)
	v_IW_90 = J.div(J.mul(v_IH_89, v_iw_87), v_ih_88)
	if J.cmp(v_IW_90, J.mul(J.gp(this_, "W"), 1.15), "<"):
		var _t101 = J.mul(J.gp(this_, "W"), 1.15)
		v_IW_90 = _t101
		var _t102 = J.div(J.mul(v_IW_90, v_ih_88), v_iw_87)
		v_IH_89 = _t102
	return {"IW": v_IW_90, "IH": v_IH_89}

func _f29(this_, a: Array, env):
	var v_fx_93 = null; var v_g_94 = null
	v_fx_93 = J.arg(a, 0)
	v_g_94 = J.mc(this_, "geo", [])
	return J.mul(J.sub(v_fx_93, J.gp(this_, "cam")), J.gp(v_g_94, "IW"))

func _f30(this_, a: Array, env):
	var v_fy_97 = null
	v_fy_97 = J.arg(a, 0)
	return J.mul(v_fy_97, J.gp(J.mc(this_, "geo", []), "IH"))

func _f31(this_, a: Array, env):
	var v_fy_100 = null
	v_fy_100 = J.arg(a, 0)
	return (0.84 + (0.36 * J.max_([0.0, J.min_([1.0, J.div(J.sub(v_fy_100, 0.72), 0.23)])])))

func _f32(this_, a: Array, env):
	var v_fy_103 = null
	v_fy_103 = J.arg(a, 0)
	return J.mul(J.div(J.mul(J.gp(J.mc(this_, "geo", []), "IH"), 0.25), 58.0), J.mc(this_, "depth", [v_fy_103]))

func _f33(this_, a: Array, env):
	var v_e_106 = null; var v_r_107 = null; var v_g_108 = null
	v_e_106 = J.arg(a, 0)
	var _t103 = J.G.get("$")
	v_r_107 = J.mc(J.cl(_t103, null, ["#gs-cvs"]), "getBoundingClientRect", [])
	v_g_108 = J.mc(this_, "geo", [])
	return {"fx": J.add(J.div(J.sub(J.gp(v_e_106, "clientX"), J.gp(v_r_107, "left")), J.gp(v_g_108, "IW")), J.gp(this_, "cam")), "fy": J.div(J.sub(J.gp(v_e_106, "clientY"), J.gp(v_r_107, "top")), J.gp(v_g_108, "IH")), "sx": J.sub(J.gp(v_e_106, "clientX"), J.gp(v_r_107, "left")), "sy": J.sub(J.gp(v_e_106, "clientY"), J.gp(v_r_107, "top"))}

func _f34(this_, a: Array, env):
	var v_e_111 = null; var v_p_112 = null; var v_er_113 = null
	v_e_111 = J.arg(a, 0)
	if J.cmp(J.gp(this_, "kick"), 0.0, ">"):
		return null
	v_p_112 = J.mc(this_, "toWorld", [v_e_111])
	var _t104 = this_
	var _t105 = {"x0": J.gp(v_p_112, "sx"), "y0": J.gp(v_p_112, "sy"), "moved": false, "p": v_p_112}
	J.sp(_t104, "drag", _t105)
	var _t106 = J.gp(v_e_111, "target")
	J.mc(_t106, "setPointerCapture", [J.gp(v_e_111, "pointerId")])

func _f35(this_, a: Array, env):
	var v_e_116 = null; var v_p_117 = null
	v_e_116 = J.arg(a, 0)
	var _t107 = (not J.t(J.gp(this_, "drag")))
	if (_t107 if _t107 else J.cmp(J.gp(this_, "kick"), 0.0, ">")):
		return null
	v_p_117 = J.mc(this_, "toWorld", [v_e_116])
	var _t108 = (not J.t(J.gp(J.gp(this_, "drag"), "moved")))
	if ((J.hypot_([J.sub(J.gp(v_p_117, "sx"), J.gp(J.gp(this_, "drag"), "x0")), J.sub(J.gp(v_p_117, "sy"), J.gp(J.gp(this_, "drag"), "y0"))]) > 10.0) if _t108 else _t108):
		var _t109 = J.gp(this_, "drag")
		J.sp(_t109, "moved", true)
	if J.t(J.gp(J.gp(this_, "drag"), "moved")):
		var _t110 = this_
		J.sp(_t110, "pend", null)
		J.mc(this_, "walkTo", [J.gp(v_p_117, "fx"), J.gp(v_p_117, "fy")])

func _f36(this_, a: Array, env):
	var v_e_120 = null; var v_d_121 = null; var v_p_122 = null; var v_w_123 = null; var v_sc_124 = null; var v_h_125 = null; var v_k_126 = null; var v_s_127 = null
	v_e_120 = J.arg(a, 0)
	v_d_121 = J.gp(this_, "drag")
	var _t111 = this_
	J.sp(_t111, "drag", null)
	var _t112 = (not J.t(v_d_121))
	var _t113 = (_t112 if _t112 else J.gp(v_d_121, "moved"))
	if J.t((_t113 if J.t(_t113) else J.cmp(J.gp(this_, "kick"), 0.0, ">"))):
		return null
	v_p_122 = J.gp(v_d_121, "p")
	for _t114 in J.iter(J.gp(this_, "walkers")):
		v_w_123 = _t114
		v_sc_124 = J.mc(this_, "charScale", [J.gp(v_w_123, "y")])
		v_h_125 = J.mul(58.0, v_sc_124)
		var _t115 = (J.mul(absf(J.num(J.sub(J.gp(v_p_122, "fx"), J.gp(v_w_123, "x")))), J.gp(J.mc(this_, "geo", []), "IW")) < J.mul(22.0, v_sc_124))
		var _t116 = (J.cmp(J.mul(J.gp(v_p_122, "fy"), J.gp(J.mc(this_, "geo", []), "IH")), J.add(J.mc(this_, "Y", [J.gp(v_w_123, "y")]), 6.0), "<") if _t115 else _t115)
		if ((J.mul(J.gp(v_p_122, "fy"), J.gp(J.mc(this_, "geo", []), "IH")) > J.sub(J.mc(this_, "Y", [J.gp(v_w_123, "y")]), v_h_125)) if _t116 else _t116):
			J.mc(this_, "chat", [v_w_123, true])
			J.mc(J.G.get("Sound"), "play", ["click"])
			return null
	if J.cmp(J.gp(v_p_122, "fy"), 0.74, "<"):
		for _t117 in J.iter(J.G.get("GS_ORDER")):
			v_k_126 = _t117
			v_s_127 = J.gp(J.G.get("GS_STALLS"), v_k_126)
			var _t118 = J.cmp(J.gp(v_p_122, "fx"), J.gp(v_s_127, "x0"), ">=")
			if (J.cmp(J.gp(v_p_122, "fx"), J.gp(v_s_127, "x1"), "<=") if _t118 else _t118):
				J.mc(this_, "goStall", [v_k_126])
				return null
	var _t119 = this_
	J.sp(_t119, "pend", null)
	J.mc(this_, "walkTo", [J.gp(v_p_122, "fx"), J.gp(v_p_122, "fy")])

func _f37(this_, a: Array, env):
	var v_fx_130 = null; var v_fy_131 = null; var v_A_132 = null
	v_fx_130 = J.arg(a, 0)
	v_fy_131 = J.arg(a, 1)
	v_A_132 = J.gp(this_, "afu")
	var _t120 = J.max_([0.03, J.min_([0.97, v_fx_130])])
	J.sp(v_A_132, "tx", _t120)
	var _t121 = J.max_([0.78, J.min_([0.93, v_fy_131])])
	J.sp(v_A_132, "ty", _t121)

func _f38(this_, a: Array, env):
	var v_k_135 = null; var v_s_136 = null
	v_k_135 = J.arg(a, 0)
	v_s_136 = J.gp(J.G.get("GS_STALLS"), v_k_135)
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t122 = this_
	J.sp(_t122, "pend", v_k_135)
	J.mc(this_, "walkTo", [J.gp(v_s_136, "sx"), 0.8])
	var _t123 = (not J.seq(J.gp(J.gp(this_, "view"), "k"), "idle"))
	if ((not J.seq(J.gp(J.gp(this_, "view"), "k"), v_k_135)) if _t123 else _t123):
		var _t124 = this_
		var _t125 = {"k": "idle"}
		J.sp(_t124, "view", _t125)
		J.mc(this_, "renderPanel", [])

func _f40(this_, a: Array, env):
	var v_w_141 = null
	v_w_141 = J.arg(a, 0)
	J.sp(v_w_141, "bubT", 0.0)
	if (absf(J.num(J.sub(J.gp(v_w_141, "x"), J.gp(J.gp(env["this"], "afu"), "x")))) < 0.16):
		var _t135 = J.mc(env["this"], "avoid", [J.add(J.gp(J.gp(env["this"], "afu"), "x"), ((-0.2) if J.cmp(J.gp(v_w_141, "x"), J.gp(J.gp(env["this"], "afu"), "x"), "<") else 0.2))])
		J.sp(v_w_141, "tx", _t135)
		var _t136 = (0.87 + (randf() * 0.06))
		J.sp(v_w_141, "ty", _t136)
		J.sp(v_w_141, "wait", 3.0)

func _f39(this_, a: Array, env):
	var v_k_139 = null; var v_kp_140 = null
	var _s61 = {"__p": env, "this": null}
	_s61["this"] = this_
	v_k_139 = J.arg(a, 0)
	var _t126 = _s61["this"]
	J.sp(_t126, "pend", null)
	var _t127 = J.gp(_s61["this"], "afu")
	var _t128 = J.gp(J.gp(J.G.get("GS_STALLS"), v_k_139), "face")
	J.sp(_t127, "dir", _t128)
	v_kp_140 = J.gp(J.gp(_s61["this"], "keepers"), v_k_139)
	if J.t(v_kp_140):
		var _t129 = J.G.get("pick")
		var _t130 = J.cl(_t129, null, [J.gp(J.G.get("GS_KEEPER_HI"), v_k_139)])
		J.mc(_s61["this"], "say", [v_kp_140, J.mc(_t130, "replace", [J.re("^[^：]+：", ""), ""]), 3.0])
		J.sp(v_kp_140, "pose", "cast")
		J.sp(v_kp_140, "poseT", 0.9)
	var _t131 = _s61["this"]
	var _t132 = {"k": v_k_139}
	J.sp(_t131, "view", _t132)
	if J.seq(v_k_139, "haggle"):
		var _t133 = J.gp(_s61["this"], "view")
		J.sp(_t133, "sub", null)
	var _t134 = J.gp(_s61["this"], "walkers")
	J.mc(_t134, "forEach", [Callable(self, "_f40").bind(_s61)])
	J.mc(_s61["this"], "renderPanel", [])
	J.mc(J.G.get("Sound"), "play", ["paper"])

func _f42(this_, a: Array, env):
	var v_n_146 = null
	v_n_146 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_146])

func _f43(this_, a: Array, env):
	var v_n_147 = null
	v_n_147 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_147])

func _f41(this_, a: Array, env):
	var v_now_144 = null; var v_dt_145 = null
	var _s65 = {"__p": env, "this": null}
	_s65["this"] = this_
	v_now_144 = J.arg(a, 0)
	if (not J.t(J.gp(_s65["this"], "active"))):
		return null
	if (J.sub(v_now_144, J.gp(_s65["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f42").bind(_s65)])
		return null
	v_dt_145 = J.min_([0.05, J.div(J.sub(v_now_144, J.gp(_s65["this"], "last")), 1000.0)])
	var _t137 = _s65["this"]
	J.sp(_t137, "last", v_now_144)
	J.mc(_s65["this"], "step", [v_dt_145])
	J.mc(_s65["this"], "draw", [J.div(v_now_144, 1000.0)])
	J.F_requestAnimationFrame([Callable(self, "_f43").bind(_s65)])

func _f45(this_, a: Array, env):
	var v_k_172 = null
	v_k_172 = J.arg(a, 0)
	return J.cmp(J.gp(v_k_172, "bubT"), 0.0, ">")

func _f46(this_, a: Array, env):
	var v_o_173 = null
	v_o_173 = J.arg(a, 0)
	var _t227 = (not J.seq(v_o_173, env["w"]))
	return (J.cmp(J.gp(v_o_173, "bubT"), 0.0, ">") if _t227 else _t227)

func _f47(this_, a: Array, env):
	var v_w_180 = null
	v_w_180 = J.arg(a, 0)
	var _t247 = J.gp(v_w_180, "prop")
	var _t248 = ((not J.t(J.gp(v_w_180, "bump"))) if J.t(_t247) else _t247)
	var _t249 = ((not J.t(J.gp(v_w_180, "look"))) if J.t(_t248) else _t248)
	var _t250 = (J.cmp(J.mc(env["this"], "X", [J.gp(v_w_180, "x")]), 40.0, ">") if J.t(_t249) else _t249)
	return (J.cmp(J.mc(env["this"], "X", [J.gp(v_w_180, "x")]), J.sub(J.gp(env["this"], "W"), 40.0), "<") if J.t(_t250) else _t250)

func _f48(this_, a: Array, env):
	var v_p_186 = null
	v_p_186 = J.arg(a, 0)
	var _t258 = J.sub(J.gp(v_p_186, "life"), env["dt"])
	J.sp(v_p_186, "life", _t258)
	var _t259 = J.add(J.gp(v_p_186, "x"), J.mul(J.gp(v_p_186, "vx"), env["dt"]))
	J.sp(v_p_186, "x", _t259)
	var _t260 = J.add(J.gp(v_p_186, "y"), J.mul(J.gp(v_p_186, "vy"), env["dt"]))
	J.sp(v_p_186, "y", _t260)
	if J.seq(J.gp(v_p_186, "kind"), "joss"):
		var _t261 = J.add(J.gp(v_p_186, "rot"), J.mul(J.gp(v_p_186, "vr"), env["dt"]))
		J.sp(v_p_186, "rot", _t261)
		var _t262 = J.add(J.gp(v_p_186, "flip"), J.mul(env["dt"], J.gp(v_p_186, "vf")))
		J.sp(v_p_186, "flip", _t262)
		var _t263 = J.add(J.gp(v_p_186, "bx"), (sin(J.num(J.add(J.mul(J.gp(env["this"], "t"), J.gp(v_p_186, "sw")), J.gp(v_p_186, "ph")))) * 0.012))
		J.sp(v_p_186, "vx", _t263)
		if J.cmp(J.gp(v_p_186, "y"), J.gp(v_p_186, "land"), ">"):
			J.sp(v_p_186, "vy", 0.0)
			J.sp(v_p_186, "vx", 0.0)
			J.sp(v_p_186, "vr", 0.0)
			J.sp(v_p_186, "vf", 0.0)
	return J.cmp(J.gp(v_p_186, "life"), 0.0, ">")

func _f49(this_, a: Array, env):
	var v_f_188 = null
	v_f_188 = J.arg(a, 0)
	var _t270 = J.sub(J.gp(v_f_188, "life"), env["dt"])
	J.sp(v_f_188, "life", _t270)
	return (_t270 > 0.0)

func _f44(this_, a: Array, env):
	var v_A_151 = null; var v_g_152 = null; var v_tv_153 = null; var v_vw_154 = null; var v_want_155 = null; var v_c_156 = null; var v_dx_157 = null; var v_dy_158 = null; var v_d_159 = null; var v_sp_160 = null; var v_k_161 = null; var v_kp_162 = null; var v_near_163 = null; var v_dx_165 = null; var v_dy_166 = null; var v_d_167 = null; var v_sp_168 = null; var v_st_169 = null; var v_vis_170 = null; var v_busy_171 = null; var v_i_174 = null; var v_j_175 = null; var v_P_176 = null; var v_Q_177 = null; var v_W_178 = null; var v_vis_179 = null; var v_P_181 = null; var v_Q_182 = null; var v_mid_183 = null; var v_yy_184 = null; var v_l_185 = null; var v_f_187 = null; var v_v_189 = null
	var _s69 = {"__p": env, "this": null, "dt": null}
	_s69["this"] = this_
	_s69["dt"] = J.arg(a, 0)
	var _t138 = _s69["this"]
	var _t139 = J.add(J.gp(_t138, "t"), _s69["dt"])
	J.sp(_t138, "t", _t139)
	v_A_151 = J.gp(_s69["this"], "afu")
	v_g_152 = J.mc(_s69["this"], "geo", [])
	v_tv_153 = J.mc(_s69["this"], "targetVH", [])
	var _t140 = _s69["this"]
	var _t141 = J.add(J.gp(_t140, "vh"), (J.sub(v_tv_153, J.gp(_s69["this"], "vh")) * J.min_([1.0, J.mul(_s69["dt"], 7.0)])))
	J.sp(_t140, "vh", _t141)
	if J.cmp(J.gp(_s69["this"], "kick"), 0.0, ">"):
		var _t142 = _s69["this"]
		var _t143 = J.sub(J.gp(_t142, "kick"), _s69["dt"])
		J.sp(_t142, "kick", _t143)
		var _t144 = J.max_([0.2, J.sub(J.gp(v_A_151, "x"), J.mul(_s69["dt"], 0.12))])
		J.sp(v_A_151, "x", _t144)
		var _t145 = J.gp(v_A_151, "x")
		J.sp(v_A_151, "tx", _t145)
		var _t146 = J.gp(v_A_151, "y")
		J.sp(v_A_151, "ty", _t146)
		J.sp(v_A_151, "dir", 1.0)
		J.sp(v_A_151, "walking", false)
		J.sp(v_A_151, "pose", "hurt")
		J.sp(v_A_151, "poseT", 0.2)
	else:
		v_dx_157 = J.mul(J.sub(J.gp(v_A_151, "tx"), J.gp(v_A_151, "x")), J.gp(v_g_152, "IW"))
		v_dy_158 = J.mul(J.sub(J.gp(v_A_151, "ty"), J.gp(v_A_151, "y")), J.gp(v_g_152, "IH"))
		v_d_159 = J.hypot_([v_dx_157, v_dy_158])
		v_sp_160 = J.mul(J.mul(150.0, J.mc(_s69["this"], "depth", [J.gp(v_A_151, "y")])), _s69["dt"])
		if J.cmp(v_d_159, 2.0, ">"):
			var _t147 = J.add(J.gp(v_A_151, "x"), J.div((J.div(v_dx_157, v_d_159) * J.min_([v_sp_160, v_d_159])), J.gp(v_g_152, "IW")))
			J.sp(v_A_151, "x", _t147)
			var _t148 = J.add(J.gp(v_A_151, "y"), J.div((J.div(v_dy_158, v_d_159) * J.min_([v_sp_160, v_d_159])), J.gp(v_g_152, "IH")))
			J.sp(v_A_151, "y", _t148)
			if (absf(J.num(v_dx_157)) > 1.0):
				var _t149 = (1.0 if J.cmp(v_dx_157, 0.0, ">") else (-1.0))
				J.sp(v_A_151, "dir", _t149)
			J.sp(v_A_151, "walking", true)
			var _t150 = J.sub(J.gp(v_A_151, "dustT"), _s69["dt"])
			J.sp(v_A_151, "dustT", _t150)
			if J.cmp(J.gp(v_A_151, "dustT"), 0.0, "<="):
				J.sp(v_A_151, "dustT", 0.16)
				var _t151 = J.gp(_s69["this"], "parts")
				J.mc(_t151, "push", [{"kind": "dust", "x": J.sub(J.gp(v_A_151, "x"), J.mul(J.gp(v_A_151, "dir"), 0.006)), "y": J.gp(v_A_151, "y"), "vx": ((-J.num(J.gp(v_A_151, "dir"))) * 0.01), "vy": (-0.02), "life": 0.55, "max": 0.55, "r": (3.0 + (randf() * 3.0))}])
		else:
			var _t152 = J.gp(v_A_151, "walking")
			if J.t((J.gp(_s69["this"], "pend") if J.t(_t152) else _t152)):
				J.mc(_s69["this"], "arrive", [J.gp(_s69["this"], "pend")])
			J.sp(v_A_151, "walking", false)
	if J.cmp(J.gp(v_A_151, "poseT"), 0.0, ">"):
		var _t153 = J.sub(J.gp(v_A_151, "poseT"), _s69["dt"])
		J.sp(v_A_151, "poseT", _t153)
		if J.cmp(J.gp(v_A_151, "poseT"), 0.0, "<="):
			J.sp(v_A_151, "pose", null)
	v_vw_154 = J.div(J.gp(_s69["this"], "W"), J.gp(v_g_152, "IW"))
	v_want_155 = J.max_([0.0, J.min_([J.sub(1.0, v_vw_154), J.sub(J.gp(v_A_151, "x"), J.div(v_vw_154, 2.0))])])
	var _t154 = _s69["this"]
	var _t155 = J.add(J.gp(_t154, "cam"), (J.sub(v_want_155, J.gp(_s69["this"], "cam")) * J.min_([1.0, J.mul(_s69["dt"], 4.0)])))
	J.sp(_t154, "cam", _t155)
	var _t156 = _s69["this"]
	var _t157 = J.max_([0.0, J.min_([J.sub(1.0, v_vw_154), J.gp(_s69["this"], "cam")])])
	J.sp(_t156, "cam", _t157)
	for _t158 in J.keys(J.gp(_s69["this"], "keepers")):
		v_k_161 = _t158
		v_kp_162 = J.gp(J.gp(_s69["this"], "keepers"), v_k_161)
		if J.cmp(J.gp(v_kp_162, "poseT"), 0.0, ">"):
			var _t159 = J.sub(J.gp(v_kp_162, "poseT"), _s69["dt"])
			J.sp(v_kp_162, "poseT", _t159)
			var _t160 = J.min_([1.0, J.add(J.gp(v_kp_162, "pt"), J.mul(_s69["dt"], 1.6))])
			J.sp(v_kp_162, "pt", _t160)
			var _t161 = J.cmp(J.gp(v_kp_162, "poseT"), 0.0, "<=")
			if ((not J.t(J.gp(v_kp_162, "hold"))) if _t161 else _t161):
				J.sp(v_kp_162, "pose", null)
		if J.cmp(J.gp(v_kp_162, "bubT"), 0.0, ">"):
			var _t162 = J.sub(J.gp(v_kp_162, "bubT"), _s69["dt"])
			J.sp(v_kp_162, "bubT", _t162)
		var _t163 = (not J.t(J.gp(v_A_151, "walking")))
		v_near_163 = ((absf(J.num(J.sub(J.gp(v_A_151, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_161), "x")))) < 0.09) if _t163 else _t163)
		var _t164 = ((not J.t(J.gp(v_kp_162, "greeted"))) if J.t(v_near_163) else v_near_163)
		if J.t(((not J.t(J.gp(v_kp_162, "pose"))) if J.t(_t164) else _t164)):
			J.sp(v_kp_162, "greeted", true)
			var _t165 = J.seq(J.gp(v_kp_162, "k"), "xiaozhi")
			var _t166 = (1.8 if (_t165 if _t165 else J.seq(J.gp(v_kp_162, "k"), "eguiking")) else 1.6)
			J.sp(v_kp_162, "greet", _t166)
			J.sp(v_kp_162, "gt", 0.0)
		if (absf(J.num(J.sub(J.gp(v_A_151, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_161), "x")))) > 0.14):
			J.sp(v_kp_162, "greeted", false)
		if J.cmp(J.gp(v_kp_162, "greet"), 0.0, ">"):
			var _t167 = J.sub(J.gp(v_kp_162, "greet"), _s69["dt"])
			J.sp(v_kp_162, "greet", _t167)
			var _t168 = J.add(J.gp(v_kp_162, "gt"), _s69["dt"])
			J.sp(v_kp_162, "gt", _t168)
			if J.t(J.gp(v_kp_162, "pose")):
				J.sp(v_kp_162, "greet", 0.0)
		if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
			var _t170 = J.gp(v_kp_162, "st")
			var _t171 = J.gp(v_kp_162, "k")
			var _t172 = _s69["dt"]
			var _t169 = (not J.t(J.gp(v_kp_162, "pose")))
			var _t173 = J.mc(J.G.get("TOWN"), "tick", [_t170, _t171, _t172, ((not J.cmp(J.gp(v_kp_162, "greet"), 0.0, ">")) if _t169 else _t169), false])
			J.sp(v_kp_162, "st", _t173)
	for _t174 in J.iter(J.gp(_s69["this"], "walkers")):
		var _s81 = {"__p": _s69, "w": null}
		_s81["w"] = _t174
		if J.cmp(J.gp(_s81["w"], "bubT"), 0.0, ">"):
			var _t175 = _s81["w"]
			var _t176 = J.sub(J.gp(_t175, "bubT"), _s81["__p"]["dt"])
			J.sp(_t175, "bubT", _t176)
		if J.cmp(J.gp(_s81["w"], "bump"), 0.0, ">"):
			var _t177 = _s81["w"]
			var _t178 = J.sub(J.gp(_t177, "bump"), _s81["__p"]["dt"])
			J.sp(_t177, "bump", _t178)
			var _t179 = _s81["w"]
			var _t180 = J.add(J.gp(_t179, "bt"), _s81["__p"]["dt"])
			J.sp(_t179, "bt", _t180)
			var _t181 = _s81["w"]
			J.sp(_t181, "walking", false)
			continue
		if J.cmp(J.gp(_s81["w"], "look"), 0.0, ">"):
			var _t182 = _s81["w"]
			var _t183 = J.sub(J.gp(_t182, "look"), _s81["__p"]["dt"])
			J.sp(_t182, "look", _t183)
			var _t184 = _s81["w"]
			var _t185 = J.add(J.gp(_t184, "lt"), _s81["__p"]["dt"])
			J.sp(_t184, "lt", _t185)
			var _t186 = _s81["w"]
			J.sp(_t186, "walking", false)
			continue
		v_dx_165 = J.mul(J.sub(J.gp(_s81["w"], "tx"), J.gp(_s81["w"], "x")), J.gp(v_g_152, "IW"))
		v_dy_166 = J.mul(J.sub(J.gp(_s81["w"], "ty"), J.gp(_s81["w"], "y")), J.gp(v_g_152, "IH"))
		v_d_167 = J.hypot_([v_dx_165, v_dy_166])
		if J.cmp(v_d_167, 2.0, ">"):
			v_sp_168 = J.mul(34.0, _s81["__p"]["dt"])
			var _t187 = _s81["w"]
			var _t188 = J.add(J.gp(_t187, "x"), J.div((J.div(v_dx_165, v_d_167) * J.min_([v_sp_168, v_d_167])), J.gp(v_g_152, "IW")))
			J.sp(_t187, "x", _t188)
			var _t189 = _s81["w"]
			var _t190 = J.add(J.gp(_t189, "y"), J.div((J.div(v_dy_166, v_d_167) * J.min_([v_sp_168, v_d_167])), J.gp(v_g_152, "IH")))
			J.sp(_t189, "y", _t190)
			if (absf(J.num(v_dx_165)) > 0.5):
				var _t191 = _s81["w"]
				var _t192 = (1.0 if J.cmp(v_dx_165, 0.0, ">") else (-1.0))
				J.sp(_t191, "dir", _t192)
			var _t193 = _s81["w"]
			J.sp(_t193, "walking", true)
		else:
			var _t194 = J.gp(_s81["w"], "walking")
			if J.t(((not J.leq(J.gp(_s81["w"], "toStall"), null)) if J.t(_t194) else _t194)):
				var _t195 = _s81["w"]
				var _t196 = (2.6 + (randf() * 1.5))
				J.sp(_t195, "look", _t196)
				var _t197 = _s81["w"]
				J.sp(_t197, "lt", 0.0)
				var _t198 = _s81["w"]
				var _t199 = (1.0 if J.cmp(J.gp(J.gp(J.G.get("GS_STALLS"), J.gp(_s81["w"], "toStall")), "x"), J.gp(_s81["w"], "x"), ">=") else (-1.0))
				J.sp(_t198, "dir", _t199)
				var _t200 = _s81["w"]
				J.sp(_t200, "toStall", null)
			var _t201 = _s81["w"]
			J.sp(_t201, "walking", false)
			var _t202 = _s81["w"]
			var _t203 = J.sub(J.gp(_t202, "wait"), _s81["__p"]["dt"])
			J.sp(_t202, "wait", _t203)
			if J.cmp(J.gp(_s81["w"], "wait"), 0.0, "<="):
				var _t204 = _s81["w"]
				var _t205 = (2.0 + (randf() * 5.0))
				J.sp(_t204, "wait", _t205)
				v_st_169 = J.gp(J.G.get("GS_ORDER"), floor(J.num((randf() * 4.0))))
				var _t206 = J.seq(J.gp(J.gp(_s81["__p"]["this"], "view"), "k"), "idle")
				var _t207 = ((randf() < 0.3) if _t206 else _t206)
				var _t208 = (J.gp(_s81["w"], "prop") if _t207 else _t207)
				if J.t(((absf(J.num(J.sub(J.gp(J.gp(J.G.get("GS_STALLS"), v_st_169), "x"), J.gp(_s81["w"], "x")))) < 0.4) if J.t(_t208) else _t208)):
					var _t209 = _s81["w"]
					var _t210 = J.mc(_s81["__p"]["this"], "avoid", [J.add(J.gp(J.gp(J.G.get("GS_STALLS"), v_st_169), "x"), ((randf() - 0.5) * 0.07))])
					J.sp(_t209, "tx", _t210)
					var _t211 = _s81["w"]
					var _t212 = (0.79 + (randf() * 0.03))
					J.sp(_t211, "ty", _t212)
					var _t213 = _s81["w"]
					J.sp(_t213, "toStall", v_st_169)
				else:
					var _t214 = _s81["w"]
					var _t215 = J.mc(_s81["__p"]["this"], "avoid", [J.add(J.gp(_s81["w"], "x"), ((randf() - 0.5) * 0.3))])
					J.sp(_t214, "tx", _t215)
					var _t216 = _s81["w"]
					var _t217 = ((0.86 + (randf() * 0.07)) if (not J.seq(J.gp(J.gp(_s81["__p"]["this"], "view"), "k"), "idle")) else (0.79 + (randf() * 0.13)))
					J.sp(_t216, "ty", _t217)
					var _t218 = _s81["w"]
					J.sp(_t218, "toStall", null)
		var _t219 = _s81["w"]
		var _t220 = J.sub(J.gp(_t219, "chatT"), _s81["__p"]["dt"])
		J.sp(_t219, "chatT", _t220)
		if J.cmp(J.gp(_s81["w"], "chatT"), 0.0, "<="):
			var _t221 = _s81["w"]
			var _t222 = (7.0 + (randf() * 8.0))
			J.sp(_t221, "chatT", _t222)
			var _t223 = J.cmp(J.mc(_s81["__p"]["this"], "X", [J.gp(_s81["w"], "x")]), 20.0, ">")
			v_vis_170 = (J.cmp(J.mc(_s81["__p"]["this"], "X", [J.gp(_s81["w"], "x")]), J.sub(J.gp(_s81["__p"]["this"], "W"), 20.0), "<") if _t223 else _t223)
			var _t225 = (not J.seq(J.gp(J.gp(_s81["__p"]["this"], "view"), "k"), "idle"))
			if not J.t(_t225):
				var _t224 = J.S_Object_("values", [J.gp(_s81["__p"]["this"], "keepers")])
				_t225 = J.mc(_t224, "some", [Callable(self, "_f45").bind(_s81)])
			v_busy_171 = _t225
			var _t228 = ((not J.t(v_busy_171)) if J.t(v_vis_170) else v_vis_170)
			if J.t(_t228):
				var _t226 = J.gp(_s81["__p"]["this"], "walkers")
				_t228 = (not J.t(J.mc(_t226, "some", [Callable(self, "_f46").bind(_s81)])))
			if J.t(_t228):
				J.mc(_s81["__p"]["this"], "chat", [_s81["w"]])
	var _t229 = _s69["this"]
	var _t230 = J.sub(J.gp(_t229, "bumpCD"), _s69["dt"])
	J.sp(_t229, "bumpCD", _t230)
	v_i_174 = 0.0
	while true:
		if not J.cmp(v_i_174, J.len(J.gp(_s69["this"], "walkers")), "<"): break
		v_j_175 = J.add(v_i_174, 1.0)
		while true:
			if not J.cmp(v_j_175, J.len(J.gp(_s69["this"], "walkers")), "<"): break
			v_P_176 = J.gp(J.gp(_s69["this"], "walkers"), v_i_174)
			v_Q_177 = J.gp(J.gp(_s69["this"], "walkers"), v_j_175)
			var _t231 = J.gp(v_P_176, "walking")
			var _t232 = (J.gp(v_Q_177, "walking") if J.t(_t231) else _t231)
			var _t233 = (J.gp(v_P_176, "prop") if J.t(_t232) else _t232)
			var _t234 = (J.gp(v_Q_177, "prop") if J.t(_t233) else _t233)
			var _t235 = ((not J.seq(J.gp(v_P_176, "dir"), J.gp(v_Q_177, "dir"))) if J.t(_t234) else _t234)
			var _t236 = ((absf(J.num(J.sub(J.gp(v_P_176, "x"), J.gp(v_Q_177, "x")))) < 0.03) if J.t(_t235) else _t235)
			var _t237 = ((absf(J.num(J.sub(J.gp(v_P_176, "y"), J.gp(v_Q_177, "y")))) < 0.03) if J.t(_t236) else _t236)
			if J.t(((J.mul(J.sub(J.gp(v_Q_177, "x"), J.gp(v_P_176, "x")), J.gp(v_P_176, "dir")) > 0.0) if J.t(_t237) else _t237)):
				for _t238 in J.iter([v_P_176, v_Q_177]):
					v_W_178 = _t238
					J.sp(v_W_178, "bump", 1.8)
					J.sp(v_W_178, "bt", 0.0)
					var _t239 = J.gp(v_W_178, "x")
					J.sp(v_W_178, "tx", _t239)
					var _t240 = J.gp(v_W_178, "y")
					J.sp(v_W_178, "ty", _t240)
					J.sp(v_W_178, "toStall", null)
					var _t241 = (0.5 + randf())
					J.sp(v_W_178, "wait", _t241)
					var _t242 = J.gp(J.G.get("GS_SORRY"), floor(J.num((randf() * J.len(J.G.get("GS_SORRY"))))))
					J.sp(v_W_178, "sorry", _t242)
			v_j_175 = J.num(v_j_175) + 1.0
		v_i_174 = J.num(v_i_174) + 1.0
	var _t243 = J.cmp(J.gp(_s69["this"], "bumpCD"), 0.0, "<=")
	if (J.seq(J.gp(J.gp(_s69["this"], "view"), "k"), "idle") if _t243 else _t243):
		var _t244 = _s69["this"]
		var _t245 = (16.0 + (randf() * 12.0))
		J.sp(_t244, "bumpCD", _t245)
		var _t246 = J.gp(_s69["this"], "walkers")
		v_vis_179 = J.mc(_t246, "filter", [Callable(self, "_f47").bind(_s69)])
		if (J.len(v_vis_179) >= 2.0):
			v_P_181 = J.gp(v_vis_179, 0.0)
			v_Q_182 = J.gp(v_vis_179, 1.0)
			v_mid_183 = J.div(J.add(J.gp(v_P_181, "x"), J.gp(v_Q_182, "x")), 2.0)
			v_yy_184 = (0.83 + (randf() * 0.06))
			v_l_185 = J.cmp(J.gp(v_P_181, "x"), J.gp(v_Q_182, "x"), "<")
			J.sp(v_Q_182, "ty", v_yy_184)
			J.sp(v_P_181, "ty", v_yy_184)
			var _t251 = J.mc(_s69["this"], "avoid", [J.add(v_mid_183, (0.07 if J.t(v_l_185) else (-0.07)))])
			J.sp(v_P_181, "tx", _t251)
			var _t252 = J.mc(_s69["this"], "avoid", [J.add(v_mid_183, ((-0.07) if J.t(v_l_185) else 0.07))])
			J.sp(v_Q_182, "tx", _t252)
			J.sp(v_Q_182, "wait", 8.0)
			J.sp(v_P_181, "wait", 8.0)
			J.sp(v_Q_182, "toStall", null)
			J.sp(v_P_181, "toStall", null)
	if (randf() < J.mul(_s69["dt"], 1.6)):
		var _t253 = J.gp(_s69["this"], "parts")
		J.mc(_t253, "push", [J.mc(_s69["this"], "mkJoss", [false])])
	if (randf() < J.mul(_s69["dt"], 5.0)):
		var _t254 = J.gp(_s69["this"], "parts")
		J.mc(_t254, "push", [{"kind": "steam", "x": (0.752 + ((randf() - 0.5) * 0.02)), "y": 0.515, "vx": ((randf() - 0.5) * 0.004), "vy": ((-0.035) - (randf() * 0.02)), "life": 2.2, "max": 2.2, "r": (4.0 + (randf() * 4.0))}])
	if (randf() < J.mul(_s69["dt"], 1.2)):
		var _t255 = J.gp(_s69["this"], "parts")
		J.mc(_t255, "push", [{"kind": "mist", "x": (0.9 + (randf() * 0.08)), "y": (0.6 + (randf() * 0.2)), "vx": ((-0.006) - (randf() * 0.01)), "vy": (-0.004), "life": 4.0, "max": 4.0, "r": (20.0 + (randf() * 30.0))}])
	var _t256 = _s69["this"]
	var _t257 = J.gp(_s69["this"], "parts")
	var _t264 = J.mc(_t257, "filter", [Callable(self, "_f48").bind(_s69)])
	J.sp(_t256, "parts", _t264)
	for _t265 in J.iter(J.gp(_s69["this"], "fog")):
		v_f_187 = _t265
		var _t266 = J.add(J.gp(v_f_187, "x"), J.mul(J.gp(v_f_187, "v"), _s69["dt"]))
		J.sp(v_f_187, "x", _t266)
		if J.cmp(J.gp(v_f_187, "x"), 1.2, ">"):
			var _t267 = (-0.2)
			J.sp(v_f_187, "x", _t267)
		if J.cmp(J.gp(v_f_187, "x"), (-0.2), "<"):
			J.sp(v_f_187, "x", 1.2)
	var _t268 = _s69["this"]
	var _t269 = J.gp(_s69["this"], "floats")
	var _t271 = J.mc(_t269, "filter", [Callable(self, "_f49").bind(_s69)])
	J.sp(_t268, "floats", _t271)
	var _t272 = J.G.get("$")
	v_c_156 = J.cl(_t272, null, ["#gs-coins i"])
	if J.t(v_c_156):
		var _t273 = J.G.get("fmt")
		v_v_189 = J.cl(_t273, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])
		if (not J.seq(J.gp(v_c_156, "textContent"), v_v_189)):
			J.sp(v_c_156, "textContent", v_v_189)

func _f50(this_, a: Array, env):
	var v_init_192 = null
	v_init_192 = J.arg(a, 0)
	return {"kind": "joss", "x": J.sub(J.add(J.gp(this_, "cam"), (randf() * 1.3)), 0.15), "y": ((randf() * 0.8) if J.t(v_init_192) else (-0.05)), "bx": ((randf() - 0.5) * 0.01), "vx": 0.0, "vy": (0.025 + (randf() * 0.025)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 2.0), "flip": (randf() * 6.0), "vf": (2.0 + (randf() * 3.0)), "sw": (0.8 + randf()), "ph": (randf() * 6.0), "land": (0.8 + (randf() * 0.17)), "life": ((10.0 + (randf() * 10.0)) if J.t(v_init_192) else 24.0), "max": 24.0}

func _f51(this_, a: Array, env):
	var v_nx_195 = null; var v_i_196 = null; var v_hit_197 = null; var v_k_198 = null; var v_kx_199 = null
	v_nx_195 = J.arg(a, 0)
	var _t274 = J.max_([0.03, J.min_([0.9, v_nx_195])])
	v_nx_195 = _t274
	v_i_196 = 0.0
	while true:
		if not J.cmp(v_i_196, 4.0, "<"): break
		v_hit_197 = false
		for _t275 in J.keys(J.gp(this_, "keepers")):
			v_k_198 = _t275
			v_kx_199 = J.gp(J.gp(J.gp(this_, "keepers"), v_k_198), "x")
			if (absf(J.num(J.sub(v_nx_195, v_kx_199))) < 0.05):
				var _t276 = J.add(v_kx_199, ((-0.06) if J.cmp(v_nx_195, v_kx_199, "<") else 0.06))
				v_nx_195 = _t276
				v_hit_197 = true
		var _t277 = (not J.seq(J.gp(J.gp(this_, "view"), "k"), "idle"))
		if ((absf(J.num(J.sub(v_nx_195, J.gp(J.gp(this_, "afu"), "x")))) < 0.15) if _t277 else _t277):
			var _t278 = J.add(J.gp(J.gp(this_, "afu"), "x"), ((-0.17) if J.cmp(v_nx_195, J.gp(J.gp(this_, "afu"), "x"), "<") else 0.17))
			v_nx_195 = _t278
			v_hit_197 = true
		var _t279 = J.max_([0.03, J.min_([0.9, v_nx_195])])
		v_nx_195 = _t279
		if (not J.t(v_hit_197)):
			break
		v_i_196 = J.num(v_i_196) + 1.0
	return v_nx_195

func _f52(this_, a: Array, env):
	var v_w_202 = null; var v_force_203 = null; var v_line_204 = null; var v_i_205 = null
	v_w_202 = J.arg(a, 0)
	v_force_203 = J.arg(a, 1)
	v_line_204 = null
	v_i_205 = 0.0
	var _t280 = true
	while true:
		if not _t280:
			var _t281 = J.gp(this_, "chatUsed")
			var _t282 = J.mc(_t281, "has", [v_line_204])
			if not J.t((J.cmp(v_i_205, 40.0, "<") if J.t(_t282) else _t282)): break
		_t280 = false
		var _t283 = J.G.get("pick")
		var _t284 = J.cl(_t283, null, [J.G.get("GS_CHATTER")])
		v_line_204 = _t284
		v_i_205 = J.num(v_i_205) + 1.0
	if J.cmp(J.gp(J.gp(this_, "chatUsed"), "size"), (J.len(J.G.get("GS_CHATTER")) - 6.0), ">"):
		J.mc(J.gp(this_, "chatUsed"), "clear", [])
	var _t285 = J.gp(this_, "chatUsed")
	J.mc(_t285, "add", [v_line_204])
	J.mc(this_, "say", [v_w_202, v_line_204, (3.6 if J.t(v_force_203) else 3.2)])

func _f53(this_, a: Array, env):
	var v_o_208 = null; var v_text_209 = null; var v_dur_210 = null
	v_o_208 = J.arg(a, 0)
	v_text_209 = J.arg(a, 1)
	v_dur_210 = J.arg(a, 2)
	if (not J.t(v_o_208)):
		return null
	J.sp(v_o_208, "bub", v_text_209)
	var _t286 = (v_dur_210 if J.t(v_dur_210) else 3.0)
	J.sp(v_o_208, "bubT", _t286)

func _f55(this_, a: Array, env):
	var v_f_218 = null
	v_f_218 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_218, "life"), 0.9, ">")

func _f54(this_, a: Array, env):
	var v_fx_213 = null; var v_fy_214 = null; var v_text_215 = null; var v_col_216 = null; var v_n_217 = null
	v_fx_213 = J.arg(a, 0)
	v_fy_214 = J.arg(a, 1)
	v_text_215 = J.arg(a, 2)
	v_col_216 = J.arg(a, 3)
	var _t287 = J.gp(this_, "floats")
	v_n_217 = J.len(J.mc(_t287, "filter", [Callable(self, "_f55").bind(env)]))
	var _t288 = J.gp(this_, "floats")
	J.mc(_t288, "push", [{"x": v_fx_213, "y": J.add(v_fy_214, J.mul(v_n_217, 0.05)), "text": v_text_215, "col": (v_col_216 if J.t(v_col_216) else "#ffe08a"), "life": 1.8, "max": 1.8}])

func _f57(this_, a: Array, env):
	var v_lx_230 = null; var v_ly_231 = null; var v_i_232 = null; var v_fl_233 = null
	var _t294 = J.gp(J.arg(a, 0), 0.0)
	v_lx_230 = _t294
	var _t295 = J.gp(J.arg(a, 0), 1.0)
	v_ly_231 = _t295
	v_i_232 = J.arg(a, 1)
	v_fl_233 = ((0.16 + (0.07 * sin(J.num((J.mul(env["t"], 3.1) + J.mul(v_i_232, 1.7)))))) + (0.04 * sin(J.num(J.add(J.mul(env["t"], 7.3), v_i_232)))))
	J.mc(env["this"], "glow", [env["ctx"], J.add(J.mc(env["this"], "X", [v_lx_230]), (sin(J.num(J.add(J.mul(env["t"], 1.3), v_i_232))) * 2.0)), J.mc(env["this"], "Y", [v_ly_231]), J.mul(J.gp(env["g"], "IH"), 0.06), ("rgba(255,120,60," + J.str(v_fl_233) + ")")])

func _f58(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "drawKeeper", [env["__p"]["ctx"], env["k"], env["__p"]["t"]])

func _f59(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "drawWalker", [env["__p"]["ctx"], env["w"], env["__p"]["t"]])

func _f60(this_, a: Array, env):
	return J.mc(env["this"], "drawAfu", [env["ctx"], env["t"]])

func _f61(this_, a: Array, env):
	var v_a_236 = null; var v_b_237 = null
	v_a_236 = J.arg(a, 0)
	v_b_237 = J.arg(a, 1)
	return J.sub(J.gp(v_a_236, "y"), J.gp(v_b_237, "y"))

func _f62(this_, a: Array, env):
	var v_o_238 = null
	v_o_238 = J.arg(a, 0)
	return J.mc(v_o_238, "f", [])

func _f56(this_, a: Array, env):
	var v_c_222 = null; var v_W_225 = null; var v_H_226 = null; var v_img_227 = null; var v_bot_228 = null; var v_list_229 = null; var v_k_239 = null; var v_kp_240 = null; var v_w_241 = null; var v_f_242 = null; var v_k_243 = null; var v_x_244 = null; var v_y_245 = null
	var _s123 = {"__p": env, "this": null, "t": null, "ctx": null, "g": null}
	_s123["this"] = this_
	_s123["t"] = J.arg(a, 0)
	var _t289 = J.G.get("$")
	v_c_222 = J.cl(_t289, null, ["#gs-cvs"])
	if (not J.t(v_c_222)):
		return null
	_s123["ctx"] = J.mc(v_c_222, "getContext", ["2d"])
	J.mc(_s123["ctx"], "setTransform", [J.gp(_s123["this"], "dpr"), 0.0, 0.0, J.gp(_s123["this"], "dpr"), 0.0, 0.0])
	_s123["g"] = J.mc(_s123["this"], "geo", [])
	v_W_225 = J.gp(_s123["this"], "W")
	v_H_226 = J.gp(_s123["this"], "H")
	v_img_227 = J.gp(J.G.get("SPR"), "bg_street")
	var _t290 = _s123["ctx"]
	J.sp(_t290, "fillStyle", "#0c0a12")
	J.mc(_s123["ctx"], "fillRect", [0.0, 0.0, v_W_225, v_H_226])
	var _t291 = (J.gp(v_img_227, "complete") if J.t(v_img_227) else v_img_227)
	if J.t((J.gp(v_img_227, "naturalWidth") if J.t(_t291) else _t291)):
		J.mc(_s123["ctx"], "drawImage", [v_img_227, J.mul((-J.num(J.gp(_s123["this"], "cam"))), J.gp(_s123["g"], "IW")), 0.0, J.gp(_s123["g"], "IW"), J.gp(_s123["g"], "IH")])
	v_bot_228 = J.mc(_s123["ctx"], "createLinearGradient", [0.0, J.sub(J.gp(_s123["g"], "IH"), 30.0), 0.0, J.add(J.gp(_s123["g"], "IH"), 40.0)])
	J.mc(v_bot_228, "addColorStop", [0.0, "rgba(12,10,18,0)"])
	J.mc(v_bot_228, "addColorStop", [1.0, "rgba(12,10,18,1)"])
	var _t292 = _s123["ctx"]
	J.sp(_t292, "fillStyle", v_bot_228)
	J.mc(_s123["ctx"], "fillRect", [0.0, J.sub(J.gp(_s123["g"], "IH"), 30.0), v_W_225, (J.sub(v_H_226, J.gp(_s123["g"], "IH")) + 30.0)])
	J.mc(_s123["ctx"], "save", [])
	var _t293 = _s123["ctx"]
	J.sp(_t293, "globalCompositeOperation", "lighter")
	J.mc(_s123["this"], "glow", [_s123["ctx"], J.mc(_s123["this"], "X", [0.785]), J.mc(_s123["this"], "Y", [0.085]), J.mul(J.gp(_s123["g"], "IH"), 0.16), ("rgba(140,255,170," + J.str((0.1 + (0.04 * sin(J.num(J.mul(_s123["t"], 0.8)))))) + ")")])
	J.mc(J.G.get("GS_LANTERNS"), "forEach", [Callable(self, "_f57").bind(_s123)])
	J.mc(_s123["this"], "glow", [_s123["ctx"], J.mc(_s123["this"], "X", [0.58]), J.mc(_s123["this"], "Y", [0.52]), J.mul(J.gp(_s123["g"], "IH"), 0.12), ("rgba(255,200,110," + J.str((0.08 + (0.03 * sin(J.num(J.mul(_s123["t"], 2.0)))))) + ")")])
	J.mc(_s123["ctx"], "restore", [])
	J.mc(_s123["this"], "drawFog", [_s123["ctx"], _s123["t"], false])
	J.mc(_s123["this"], "drawParts", [_s123["ctx"], "steam"])
	v_list_229 = []
	for _t296 in J.keys(J.gp(_s123["this"], "keepers")):
		var _s125 = {"__p": _s123, "k": null}
		_s125["k"] = _t296
		J.mc(v_list_229, "push", [{"y": J.gp(J.gp(J.gp(_s125["__p"]["this"], "keepers"), _s125["k"]), "y"), "f": Callable(self, "_f58").bind(_s125)}])
	for _t297 in J.iter(J.gp(_s123["this"], "walkers")):
		var _s127 = {"__p": _s123, "w": null}
		_s127["w"] = _t297
		J.mc(v_list_229, "push", [{"y": J.gp(_s127["w"], "y"), "f": Callable(self, "_f59").bind(_s127)}])
	J.mc(v_list_229, "push", [{"y": J.gp(J.gp(_s123["this"], "afu"), "y"), "f": Callable(self, "_f60").bind(_s123)}])
	J.mc(_s123["this"], "drawParts", [_s123["ctx"], "dust"])
	var _t298 = J.mc(v_list_229, "sort", [Callable(self, "_f61").bind(_s123)])
	J.mc(_t298, "forEach", [Callable(self, "_f62").bind(_s123)])
	J.mc(_s123["this"], "drawFog", [_s123["ctx"], _s123["t"], true])
	J.mc(_s123["this"], "drawParts", [_s123["ctx"], "mist"])
	J.mc(_s123["this"], "drawParts", [_s123["ctx"], "joss"])
	J.mc(_s123["this"], "drawLanternString", [_s123["ctx"], _s123["t"]])
	J.mc(_s123["this"], "drawSigns", [_s123["ctx"], _s123["t"]])
	for _t299 in J.keys(J.gp(_s123["this"], "keepers")):
		v_k_239 = _t299
		v_kp_240 = J.gp(J.gp(_s123["this"], "keepers"), v_k_239)
		if J.cmp(J.gp(v_kp_240, "bubT"), 0.0, ">"):
			J.mc(_s123["this"], "bubble", [_s123["ctx"], v_kp_240, J.gp(v_kp_240, "bub"), J.gp(v_kp_240, "bubT")])
	for _t300 in J.iter(J.gp(_s123["this"], "walkers")):
		v_w_241 = _t300
		if J.cmp(J.gp(v_w_241, "bubT"), 0.0, ">"):
			J.mc(_s123["this"], "bubble", [_s123["ctx"], v_w_241, J.gp(v_w_241, "bub"), J.gp(v_w_241, "bubT")])
	var _t301 = _s123["ctx"]
	J.sp(_t301, "textAlign", "center")
	var _t302 = _s123["ctx"]
	var _t303 = J.add("900 17px ", J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily"))
	J.sp(_t302, "font", _t303)
	for _t304 in J.iter(J.gp(_s123["this"], "floats")):
		v_f_242 = _t304
		v_k_243 = J.div(J.gp(v_f_242, "life"), J.gp(v_f_242, "max"))
		v_x_244 = J.mc(_s123["this"], "X", [J.gp(v_f_242, "x")])
		v_y_245 = J.sub(J.mc(_s123["this"], "Y", [J.gp(v_f_242, "y")]), (J.sub(1.0, v_k_243) * 40.0))
		var _t305 = _s123["ctx"]
		var _t306 = J.min_([1.0, J.mul(v_k_243, 2.0)])
		J.sp(_t305, "globalAlpha", _t306)
		var _t307 = _s123["ctx"]
		J.sp(_t307, "lineWidth", 4.0)
		var _t308 = _s123["ctx"]
		J.sp(_t308, "strokeStyle", "rgba(0,0,0,.8)")
		J.mc(_s123["ctx"], "strokeText", [J.gp(v_f_242, "text"), v_x_244, v_y_245])
		var _t309 = _s123["ctx"]
		var _t310 = J.gp(v_f_242, "col")
		J.sp(_t309, "fillStyle", _t310)
		J.mc(_s123["ctx"], "fillText", [J.gp(v_f_242, "text"), v_x_244, v_y_245])
	var _t311 = _s123["ctx"]
	J.sp(_t311, "globalAlpha", 1.0)

func _f63(this_, a: Array, env):
	var v_ctx_248 = null; var v_x_249 = null; var v_y_250 = null; var v_r_251 = null; var v_col_252 = null; var v_gr_253 = null
	v_ctx_248 = J.arg(a, 0)
	v_x_249 = J.arg(a, 1)
	v_y_250 = J.arg(a, 2)
	v_r_251 = J.arg(a, 3)
	v_col_252 = J.arg(a, 4)
	v_gr_253 = J.mc(v_ctx_248, "createRadialGradient", [v_x_249, v_y_250, 0.0, v_x_249, v_y_250, v_r_251])
	J.mc(v_gr_253, "addColorStop", [0.0, v_col_252])
	J.mc(v_gr_253, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_ctx_248, "fillStyle", v_gr_253)
	J.mc(v_ctx_248, "fillRect", [J.sub(v_x_249, v_r_251), J.sub(v_y_250, v_r_251), J.mul(v_r_251, 2.0), J.mul(v_r_251, 2.0)])

func _f65(this_, a: Array, env):
	var v_f_260 = null; var v_i_261 = null; var v_x_262 = null; var v_y_263 = null; var v_r_264 = null; var v_gr_265 = null; var v_a_266 = null
	v_f_260 = J.arg(a, 0)
	v_i_261 = J.arg(a, 1)
	if (not J.seq(J.cmp(J.gp(v_f_260, "y"), 0.84, ">"), env["front"])):
		return null
	v_x_262 = J.mc(env["this"], "X", [(J.mul(J.gp(v_f_260, "x"), 1.0) + J.mul(J.gp(env["this"], "cam"), ((-0.15) if J.t(env["front"]) else 0.0)))])
	v_y_263 = J.mc(env["this"], "Y", [J.gp(v_f_260, "y")])
	v_r_264 = (J.mul(J.gp(v_f_260, "r"), J.gp(env["g"], "IW")) * 0.5)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_262, v_y_263])
	J.mc(env["ctx"], "scale", [1.0, 0.32])
	v_gr_265 = J.mc(env["ctx"], "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, v_r_264])
	v_a_266 = J.mul(J.gp(v_f_260, "a"), (0.8 + (0.2 * sin(J.num(J.add(J.mul(env["t"], 0.7), v_i_261))))))
	J.mc(v_gr_265, "addColorStop", [0.0, ("rgba(200,190,230," + J.str(v_a_266) + ")")])
	J.mc(v_gr_265, "addColorStop", [1.0, "rgba(200,190,230,0)"])
	var _t313 = env["ctx"]
	J.sp(_t313, "fillStyle", v_gr_265)
	J.mc(env["ctx"], "fillRect", [(-J.num(v_r_264)), (-J.num(v_r_264)), J.mul(v_r_264, 2.0), J.mul(v_r_264, 2.0)])
	J.mc(env["ctx"], "restore", [])

func _f64(this_, a: Array, env):
	var _s138 = {"__p": env, "this": null, "ctx": null, "t": null, "front": null, "g": null}
	_s138["this"] = this_
	_s138["ctx"] = J.arg(a, 0)
	_s138["t"] = J.arg(a, 1)
	_s138["front"] = J.arg(a, 2)
	_s138["g"] = J.mc(_s138["this"], "geo", [])
	var _t312 = J.gp(_s138["this"], "fog")
	J.mc(_t312, "forEach", [Callable(self, "_f65").bind(_s138)])

func _f66(this_, a: Array, env):
	var v_ctx_269 = null; var v_kind_270 = null; var v_g_271 = null; var v_p_272 = null; var v_x_273 = null; var v_y_274 = null; var v_k_275 = null; var v_sz_276 = null; var v_r_277 = null; var v_r_278 = null; var v_gr_279 = null; var v_r_280 = null
	v_ctx_269 = J.arg(a, 0)
	v_kind_270 = J.arg(a, 1)
	v_g_271 = J.mc(this_, "geo", [])
	for _t314 in J.iter(J.gp(this_, "parts")):
		v_p_272 = _t314
		if (not J.seq(J.gp(v_p_272, "kind"), v_kind_270)):
			continue
		v_x_273 = J.mc(this_, "X", [J.gp(v_p_272, "x")])
		v_y_274 = J.mc(this_, "Y", [J.gp(v_p_272, "y")])
		v_k_275 = J.div(J.gp(v_p_272, "life"), J.gp(v_p_272, "max"))
		var _t315 = J.cmp(v_x_273, (-60.0), "<")
		if (_t315 if _t315 else J.cmp(v_x_273, J.add(J.gp(this_, "W"), 60.0), ">")):
			continue
		if J.seq(v_kind_270, "joss"):
			v_sz_276 = J.mul(J.gp(v_g_271, "IH"), 0.016)
			J.mc(v_ctx_269, "save", [])
			var _t316 = (J.min_([1.0, J.mul(J.gp(v_p_272, "life"), 0.6)]) * 0.92)
			J.sp(v_ctx_269, "globalAlpha", _t316)
			J.mc(v_ctx_269, "translate", [v_x_273, v_y_274])
			J.mc(v_ctx_269, "rotate", [J.gp(v_p_272, "rot")])
			J.mc(v_ctx_269, "scale", [1.0, cos(J.num(J.gp(v_p_272, "flip")))])
			J.sp(v_ctx_269, "fillStyle", "#e8c35a")
			J.sp(v_ctx_269, "strokeStyle", "#6a4a14")
			J.sp(v_ctx_269, "lineWidth", 0.8)
			J.mc(v_ctx_269, "fillRect", [(-J.num(v_sz_276)), ((-J.num(v_sz_276)) * 0.7), J.mul(v_sz_276, 2.0), J.mul(v_sz_276, 1.4)])
			J.mc(v_ctx_269, "strokeRect", [(-J.num(v_sz_276)), ((-J.num(v_sz_276)) * 0.7), J.mul(v_sz_276, 2.0), J.mul(v_sz_276, 1.4)])
			J.sp(v_ctx_269, "fillStyle", "#b8322a")
			J.mc(v_ctx_269, "fillRect", [((-J.num(v_sz_276)) * 0.35), ((-J.num(v_sz_276)) * 0.35), J.mul(v_sz_276, 0.7), J.mul(v_sz_276, 0.7)])
			J.mc(v_ctx_269, "restore", [])
		else:
			if J.seq(v_kind_270, "steam"):
				v_r_277 = J.div(J.mul(J.mul(J.gp(v_p_272, "r"), J.sub(2.0, v_k_275)), J.gp(v_g_271, "IH")), 500.0)
				var _t317 = ("rgba(240,235,255," + J.str(((J.mul(0.22, v_k_275) * J.sub(1.0, v_k_275)) * 3.0)) + ")")
				J.sp(v_ctx_269, "fillStyle", _t317)
				J.mc(v_ctx_269, "beginPath", [])
				J.mc(v_ctx_269, "arc", [J.add(v_x_273, (sin(J.num(J.add(J.mul(J.gp(v_p_272, "life"), 3.0), J.gp(v_p_272, "r")))) * 4.0)), v_y_274, v_r_277, 0.0, 7.0])
				J.mc(v_ctx_269, "fill", [])
			else:
				if J.seq(v_kind_270, "mist"):
					v_r_278 = (J.div(J.mul(J.gp(v_p_272, "r"), J.gp(v_g_271, "IH")), 500.0) * (1.6 - J.mul(v_k_275, 0.6)))
					v_gr_279 = J.mc(v_ctx_269, "createRadialGradient", [v_x_273, v_y_274, 0.0, v_x_273, v_y_274, v_r_278])
					J.mc(v_gr_279, "addColorStop", [0.0, ("rgba(210,220,240," + J.str((0.16 * sin(J.num(J.mul(v_k_275, PI))))) + ")")])
					J.mc(v_gr_279, "addColorStop", [1.0, "rgba(210,220,240,0)"])
					J.sp(v_ctx_269, "fillStyle", v_gr_279)
					J.mc(v_ctx_269, "fillRect", [J.sub(v_x_273, v_r_278), J.sub(v_y_274, v_r_278), J.mul(v_r_278, 2.0), J.mul(v_r_278, 2.0)])
				else:
					if J.seq(v_kind_270, "dust"):
						v_r_280 = J.div(J.mul(J.mul(J.gp(v_p_272, "r"), J.sub(1.6, v_k_275)), J.gp(v_g_271, "IH")), 600.0)
						var _t318 = ("rgba(190,170,200," + J.str(J.mul(0.4, v_k_275)) + ")")
						J.sp(v_ctx_269, "fillStyle", _t318)
						J.mc(v_ctx_269, "beginPath", [])
						J.mc(v_ctx_269, "ellipse", [v_x_273, v_y_274, J.mul(v_r_280, 1.4), J.mul(v_r_280, 0.8), 0.0, 0.0, 7.0])
						J.mc(v_ctx_269, "fill", [])

func _f67(this_, a: Array, env):
	var v_ctx_283 = null; var v_t_284 = null; var v_g_285 = null; var v_par_286 = null; var v_top_287 = null; var v_sag_288 = null; var v_gap_289 = null; var v_off_290 = null; var v_n0_291 = null; var v_i_292 = null; var v_x0_293 = null; var v_x1_294 = null; var v_mx_295 = null; var v_my_296 = null; var v_sw_297 = null; var v_L_298 = null; var v_r_299 = null
	v_ctx_283 = J.arg(a, 0)
	v_t_284 = J.arg(a, 1)
	v_g_285 = J.mc(this_, "geo", [])
	v_par_286 = 1.25
	v_top_287 = (-4.0)
	v_sag_288 = J.mul(J.gp(v_g_285, "IH"), 0.06)
	v_gap_289 = J.mul(J.gp(v_g_285, "IW"), 0.16)
	v_off_290 = J.mul(J.mul((-J.num(J.gp(this_, "cam"))), J.gp(v_g_285, "IW")), v_par_286)
	v_n0_291 = (floor(J.num(J.div((-J.num(v_off_290)), v_gap_289))) - 1.0)
	J.mc(v_ctx_283, "save", [])
	J.sp(v_ctx_283, "strokeStyle", "rgba(30,18,24,.9)")
	J.sp(v_ctx_283, "lineWidth", 1.6)
	v_i_292 = v_n0_291
	while true:
		if not J.cmp(v_i_292, J.add(J.add(v_n0_291, ceil(J.num(J.div(J.gp(this_, "W"), v_gap_289)))), 3.0), "<"): break
		v_x0_293 = J.add(v_off_290, J.mul(v_i_292, v_gap_289))
		v_x1_294 = J.add(v_x0_293, v_gap_289)
		J.mc(v_ctx_283, "beginPath", [])
		J.mc(v_ctx_283, "moveTo", [v_x0_293, v_top_287])
		J.mc(v_ctx_283, "quadraticCurveTo", [J.div(J.add(v_x0_293, v_x1_294), 2.0), J.add(v_top_287, J.mul(v_sag_288, 2.0)), v_x1_294, v_top_287])
		J.mc(v_ctx_283, "stroke", [])
		v_mx_295 = J.div(J.add(v_x0_293, v_x1_294), 2.0)
		v_my_296 = J.add(v_top_287, v_sag_288)
		v_sw_297 = (sin(J.num((J.mul(v_t_284, 1.6) + J.mul(v_i_292, 1.3)))) * 0.22)
		v_L_298 = J.mul(J.gp(v_g_285, "IH"), 0.035)
		v_r_299 = J.mul(J.gp(v_g_285, "IH"), 0.028)
		J.mc(v_ctx_283, "save", [])
		J.mc(v_ctx_283, "translate", [v_mx_295, v_my_296])
		J.mc(v_ctx_283, "rotate", [v_sw_297])
		J.mc(v_ctx_283, "beginPath", [])
		J.mc(v_ctx_283, "moveTo", [0.0, 0.0])
		J.mc(v_ctx_283, "lineTo", [0.0, v_L_298])
		J.mc(v_ctx_283, "stroke", [])
		J.sp(v_ctx_283, "globalCompositeOperation", "lighter")
		J.mc(this_, "glow", [v_ctx_283, 0.0, J.add(v_L_298, v_r_299), J.mul(v_r_299, 3.0), ("rgba(255,110,60," + J.str((0.22 + (0.06 * sin(J.num(J.add(J.mul(v_t_284, 4.0), v_i_292)))))) + ")")])
		J.sp(v_ctx_283, "globalCompositeOperation", "source-over")
		var _t319 = ("#f2e6c8" if J.seq(J.mod(v_i_292, 3.0), 1.0) else "#c8322a")
		J.sp(v_ctx_283, "fillStyle", _t319)
		J.sp(v_ctx_283, "strokeStyle", "#2a1010")
		J.sp(v_ctx_283, "lineWidth", 1.6)
		J.mc(v_ctx_283, "beginPath", [])
		J.mc(v_ctx_283, "ellipse", [0.0, J.add(v_L_298, v_r_299), J.mul(v_r_299, 0.85), v_r_299, 0.0, 0.0, 7.0])
		J.mc(v_ctx_283, "fill", [])
		J.mc(v_ctx_283, "stroke", [])
		J.sp(v_ctx_283, "strokeStyle", "rgba(40,10,10,.45)")
		J.sp(v_ctx_283, "lineWidth", 1.0)
		J.mc(v_ctx_283, "beginPath", [])
		J.mc(v_ctx_283, "ellipse", [0.0, J.add(v_L_298, v_r_299), J.mul(v_r_299, 0.4), v_r_299, 0.0, 0.0, 7.0])
		J.mc(v_ctx_283, "stroke", [])
		J.sp(v_ctx_283, "fillStyle", "#e2b04a")
		J.mc(v_ctx_283, "fillRect", [((-J.num(v_r_299)) * 0.45), J.sub(v_L_298, 2.0), J.mul(v_r_299, 0.9), 3.0])
		J.mc(v_ctx_283, "fillRect", [((-J.num(v_r_299)) * 0.45), J.sub(J.add(v_L_298, J.mul(v_r_299, 2.0)), 1.0), J.mul(v_r_299, 0.9), 3.0])
		J.sp(v_ctx_283, "strokeStyle", "#c8322a")
		J.sp(v_ctx_283, "lineWidth", 1.4)
		J.mc(v_ctx_283, "beginPath", [])
		J.mc(v_ctx_283, "moveTo", [0.0, J.add(J.add(v_L_298, J.mul(v_r_299, 2.0)), 2.0)])
		J.mc(v_ctx_283, "lineTo", [(sin(J.num(J.add(J.mul(v_t_284, 2.4), v_i_292))) * 2.0), J.add(J.add(v_L_298, J.mul(v_r_299, 2.0)), J.mul(v_r_299, 0.9))])
		J.mc(v_ctx_283, "stroke", [])
		J.mc(v_ctx_283, "restore", [])
		J.sp(v_ctx_283, "strokeStyle", "rgba(30,18,24,.9)")
		J.sp(v_ctx_283, "lineWidth", 1.6)
		v_i_292 = J.num(v_i_292) + 1.0
	J.mc(v_ctx_283, "restore", [])

func _f68(this_, a: Array, env):
	var v_ctx_302 = null; var v_t_303 = null; var v_near_304 = null; var v_fam_305 = null; var v_k_306 = null; var v_s_307 = null; var v_x_308 = null; var v_y_309 = null; var v_w_310 = null; var v_on_311 = null
	v_ctx_302 = J.arg(a, 0)
	v_t_303 = J.arg(a, 1)
	v_near_304 = J.mc(this_, "nearStall", [])
	v_fam_305 = J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily")
	J.mc(v_ctx_302, "save", [])
	var _t320 = J.add("800 14px ", v_fam_305)
	J.sp(v_ctx_302, "font", _t320)
	J.sp(v_ctx_302, "textAlign", "center")
	J.sp(v_ctx_302, "textBaseline", "middle")
	for _t321 in J.iter(J.G.get("GS_ORDER")):
		v_k_306 = _t321
		v_s_307 = J.gp(J.G.get("GS_STALLS"), v_k_306)
		v_x_308 = J.mc(this_, "X", [(0.945 if J.seq(v_k_306, "alley") else J.gp(v_s_307, "x"))])
		v_y_309 = J.add(J.mc(this_, "Y", [(0.3 if J.seq(v_k_306, "alley") else 0.39)]), (sin(J.num((J.mul(v_t_303, 1.5) + J.mul(J.gp(v_s_307, "x"), 9.0)))) * 1.5))
		var _t322 = J.cmp(v_x_308, (-60.0), "<")
		if (_t322 if _t322 else J.cmp(v_x_308, J.add(J.gp(this_, "W"), 60.0), ">")):
			continue
		v_w_310 = J.add(J.gp(J.mc(v_ctx_302, "measureText", [J.gp(v_s_307, "name")]), "width"), 16.0)
		v_on_311 = J.seq(v_near_304, v_k_306)
		var _t323 = ("rgba(194,54,43,.94)" if J.t(v_on_311) else "rgba(20,12,22,.72)")
		J.sp(v_ctx_302, "fillStyle", _t323)
		var _t324 = ("#f3d68a" if J.t(v_on_311) else "rgba(243,214,138,.55)")
		J.sp(v_ctx_302, "strokeStyle", _t324)
		J.sp(v_ctx_302, "lineWidth", 1.2)
		J.mc(J.G.get("ART"), "rr", [v_ctx_302, J.sub(v_x_308, J.div(v_w_310, 2.0)), J.sub(v_y_309, 12.0), v_w_310, 24.0, 4.0, J.gp(v_ctx_302, "fillStyle"), J.gp(v_ctx_302, "strokeStyle"), 1.2])
		var _t325 = ("#fff3e0" if J.t(v_on_311) else "#f3d68a")
		J.sp(v_ctx_302, "fillStyle", _t325)
		J.mc(v_ctx_302, "fillText", [J.gp(v_s_307, "name"), v_x_308, J.add(v_y_309, 1.0)])
	J.mc(v_ctx_302, "restore", [])

func _f69(this_, a: Array, env):
	var v_A_314 = null; var v_best_315 = null; var v_bd_316 = null; var v_k_317 = null; var v_d_318 = null
	v_A_314 = J.gp(this_, "afu")
	v_best_315 = null
	v_bd_316 = 0.09
	for _t326 in J.iter(J.G.get("GS_ORDER")):
		v_k_317 = _t326
		v_d_318 = absf(J.num(J.sub(J.gp(v_A_314, "x"), J.gp(J.gp(J.G.get("GS_STALLS"), v_k_317), "x"))))
		if J.cmp(v_d_318, v_bd_316, "<"):
			v_bd_316 = v_d_318
			v_best_315 = v_k_317
	return v_best_315

func _f70(this_, a: Array, env):
	var v_ctx_321 = null; var v_t_322 = null; var v_A_323 = null; var v_sc_324 = null; var v_x_325 = null; var v_y_326 = null
	v_ctx_321 = J.arg(a, 0)
	v_t_322 = J.arg(a, 1)
	v_A_323 = J.gp(this_, "afu")
	v_sc_324 = J.mc(this_, "charScale", [J.gp(v_A_323, "y")])
	v_x_325 = J.mc(this_, "X", [J.gp(v_A_323, "x")])
	v_y_326 = J.mc(this_, "Y", [J.gp(v_A_323, "y")])
	var _t329 = J.gp(v_A_323, "walking")
	var _t330 = J.cmp(J.gp(v_A_323, "dir"), 0.0, "<")
	var _t328 = null
	if J.t(J.gp(v_A_323, "walking")):
		_t328 = null
	else:
		var _t327 = J.gp(v_A_323, "pose")
		_t328 = (_t327 if J.t(_t327) else null)
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_321, "afu", v_x_325, v_y_326, v_sc_324, {"t": v_t_322, "walk": _t329, "flip": _t330, "pose": _t328, "pt": ((1.0 - J.max_([0.0, J.gp(v_A_323, "poseT")])) if J.t(J.gp(v_A_323, "pose")) else 0.0), "tamed": true, "untied": true}])

func _f71(this_, a: Array, env):
	var v_ctx_329 = null; var v_k_330 = null; var v_t_331 = null; var v_kp_332 = null; var v_sc_333 = null; var v_x_334 = null; var v_y_335 = null; var v_face_336 = null; var v_pt_337 = null; var v_da_338 = null
	v_ctx_329 = J.arg(a, 0)
	v_k_330 = J.arg(a, 1)
	v_t_331 = J.arg(a, 2)
	v_kp_332 = J.gp(J.gp(this_, "keepers"), v_k_330)
	v_sc_333 = J.mul(J.mc(this_, "charScale", [J.gp(v_kp_332, "y")]), (1.05 if J.seq(J.gp(v_kp_332, "k"), "xiaogui") else (0.9 if J.seq(J.gp(v_kp_332, "k"), "baiwu") else 1.0)))
	v_x_334 = J.mc(this_, "X", [J.gp(v_kp_332, "x")])
	v_y_335 = J.mc(this_, "Y", [J.gp(v_kp_332, "y")])
	var _t331 = J.cmp(v_x_334, (-80.0), "<")
	if (_t331 if _t331 else J.cmp(v_x_334, J.add(J.gp(this_, "W"), 80.0), ">")):
		return null
	v_face_336 = J.cmp(J.gp(J.gp(this_, "afu"), "x"), J.gp(v_kp_332, "x"), "<")
	v_pt_337 = J.gp(v_kp_332, "pt")
	if J.seq(J.gp(v_kp_332, "pose"), "strike"):
		var _t332 = J.mod(J.mul(v_t_331, 1.4), 1.0)
		v_pt_337 = _t332
	if J.seq(J.gp(v_kp_332, "pose"), "windup"):
		var _t333 = (0.35 + (sin(J.num(J.mul(v_t_331, 3.0))) * 0.1))
		v_pt_337 = _t333
	if J.seq(J.gp(v_kp_332, "pose"), "hurt"):
		var _t334 = (0.35 + (sin(J.num(J.mul(v_t_331, 9.0))) * 0.05))
		v_pt_337 = _t334
	v_da_338 = {}
	var _t335 = (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined"))
	if ((not J.t(J.gp(v_kp_332, "pose"))) if _t335 else _t335):
		if J.cmp(J.gp(v_kp_332, "greet"), 0.0, ">"):
			var _t336 = {"act": "town_greet", "at": J.gp(v_kp_332, "gt"), "adur": J.add(J.gp(v_kp_332, "gt"), J.gp(v_kp_332, "greet"))}
			v_da_338 = _t336
		else:
			var _t337 = J.mc(J.G.get("TOWN"), "opts", [J.gp(v_kp_332, "st")])
			v_da_338 = _t337
			if J.t(J.gp(v_da_338, "act")):
				var _t338 = J.cmp(J.gp(J.G.get("GS_WORKFACE"), v_k_330), 0.0, "<")
				v_face_336 = _t338
		if J.seq(J.gp(v_kp_332, "k"), "eguiking"):
			var _t339 = {"potDX": J.sub(J.mc(this_, "X", [J.gp(J.G.get("GS_POT"), 0.0)]), v_x_334), "potDY": J.sub(J.mc(this_, "Y", [J.gp(J.G.get("GS_POT"), 1.0)]), v_y_335)}
			J.sp(v_da_338, "prop", _t339)
	var _t342 = J.gp(v_kp_332, "k")
	var _t341 = J.add(v_t_331, J.gp(v_kp_332, "ph"))
	var _t340 = J.gp(v_kp_332, "pose")
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_329, _t342, v_x_334, v_y_335, v_sc_333, J.S_Object_("assign", [{"t": _t341, "flip": v_face_336, "pose": (_t340 if J.t(_t340) else null), "pt": v_pt_337, "tamed": true, "untied": true}, v_da_338])])

func _f72(this_, a: Array, env):
	var v_ctx_341 = null; var v_w_342 = null; var v_t_343 = null; var v_sc_344 = null; var v_x_345 = null; var v_y_346 = null; var v_da_347 = null
	v_ctx_341 = J.arg(a, 0)
	v_w_342 = J.arg(a, 1)
	v_t_343 = J.arg(a, 2)
	v_sc_344 = J.mul(J.mc(this_, "charScale", [J.gp(v_w_342, "y")]), 0.92)
	v_x_345 = J.mc(this_, "X", [J.gp(v_w_342, "x")])
	v_y_346 = J.mc(this_, "Y", [J.gp(v_w_342, "y")])
	var _t343 = J.cmp(v_x_345, (-80.0), "<")
	if (_t343 if _t343 else J.cmp(v_x_345, J.add(J.gp(this_, "W"), 80.0), ">")):
		return null
	v_da_347 = {}
	if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
		if J.cmp(J.gp(v_w_342, "bump"), 0.0, ">"):
			var _t344 = {"act": "town_bump", "at": J.gp(v_w_342, "bt"), "prop": J.S_Object_("assign", [{}, J.gp(v_w_342, "prop"), {"sorry": J.gp(v_w_342, "sorry")}])}
			v_da_347 = _t344
		else:
			if J.cmp(J.gp(v_w_342, "look"), 0.0, ">"):
				var _t345 = {"act": "town_look", "at": J.gp(v_w_342, "lt"), "adur": J.add(J.gp(v_w_342, "lt"), J.gp(v_w_342, "look")), "prop": J.gp(v_w_342, "prop")}
				v_da_347 = _t345
			else:
				if J.t(J.gp(v_w_342, "prop")):
					var _t346 = {"act": "town_walk", "at": 9.0, "prop": J.gp(v_w_342, "prop")}
					v_da_347 = _t346
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_341, J.gp(v_w_342, "k"), v_x_345, v_y_346, v_sc_344, J.S_Object_("assign", [{"t": J.add(v_t_343, J.gp(v_w_342, "ph")), "walk": J.gp(v_w_342, "walking"), "flip": J.cmp(J.gp(v_w_342, "dir"), 0.0, "<"), "tamed": true, "untied": true, "alpha": 0.9}, v_da_347])])

func _f74(this_, a: Array, env):
	var v_l_366 = null
	v_l_366 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_366]), "width")

func _f75(this_, a: Array, env):
	var v_l_367 = null; var v_i_368 = null
	v_l_367 = J.arg(a, 0)
	v_i_368 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_367, J.add(env["bx"], 9.0), J.add(J.add(env["by"], 20.0), J.mul(v_i_368, 19.0))])

func _f73(this_, a: Array, env):
	var v_o_351 = null; var v_text_352 = null; var v_life_353 = null; var v_sc_354 = null; var v_h_355 = null; var v_x_356 = null; var v_y_357 = null; var v_maxW_358 = null; var v_lines_359 = null; var v_cur_360 = null; var v_w_361 = null; var v_hh_362 = null; var v_ch_365 = null
	var _s163 = {"__p": env, "ctx": null, "bx": null, "by": null}
	_s163["ctx"] = J.arg(a, 0)
	v_o_351 = J.arg(a, 1)
	v_text_352 = J.arg(a, 2)
	v_life_353 = J.arg(a, 3)
	v_sc_354 = J.mc(this_, "charScale", [J.gp(v_o_351, "y")])
	v_h_355 = (J.mul(58.0, v_sc_354) * (1.25 if J.seq(J.gp(v_o_351, "k"), "baiwu") else (0.85 if J.seq(J.gp(v_o_351, "k"), "xiaogui") else 1.0)))
	v_x_356 = J.mc(this_, "X", [J.gp(v_o_351, "x")])
	v_y_357 = (J.sub(J.mc(this_, "Y", [J.gp(v_o_351, "y")]), v_h_355) - 10.0)
	var _t347 = J.cmp(v_x_356, (-40.0), "<")
	if (_t347 if _t347 else J.cmp(v_x_356, J.add(J.gp(this_, "W"), 40.0), ">")):
		return null
	J.mc(_s163["ctx"], "save", [])
	var _t348 = _s163["ctx"]
	var _t349 = J.add("700 14px ", J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily"))
	J.sp(_t348, "font", _t349)
	v_maxW_358 = 172.0
	v_lines_359 = []
	v_cur_360 = ""
	for _t350 in J.iter(v_text_352):
		v_ch_365 = _t350
		var _t351 = J.cmp(J.gp(J.mc(_s163["ctx"], "measureText", [J.add(v_cur_360, v_ch_365)]), "width"), v_maxW_358, ">")
		if ((not J.t(J.mc("。，、！？；：」）…—", "includes", [v_ch_365]))) if _t351 else _t351):
			J.mc(v_lines_359, "push", [v_cur_360])
			v_cur_360 = v_ch_365
		else:
			var _t352 = J.add(v_cur_360, v_ch_365)
			v_cur_360 = _t352
	if J.t(v_cur_360):
		J.mc(v_lines_359, "push", [v_cur_360])
	v_w_361 = (J.max_(J.spread([J.SP(J.mc(v_lines_359, "map", [Callable(self, "_f74").bind(_s163)]))])) + 18.0)
	v_hh_362 = ((J.len(v_lines_359) * 19.0) + 12.0)
	_s163["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), v_w_361) - 6.0), J.sub(v_x_356, J.div(v_w_361, 2.0))])])
	_s163["by"] = J.max_([6.0, J.sub(v_y_357, v_hh_362)])
	var _t353 = _s163["ctx"]
	var _t354 = J.min_([1.0, J.mul(v_life_353, 3.0)])
	J.sp(_t353, "globalAlpha", _t354)
	J.mc(J.G.get("ART"), "rr", [_s163["ctx"], _s163["bx"], _s163["by"], v_w_361, v_hh_362, 9.0, "rgba(244,236,214,.96)", "#3a2a1a", 1.5])
	var _t355 = _s163["ctx"]
	J.sp(_t355, "fillStyle", "rgba(244,236,214,.96)")
	J.mc(_s163["ctx"], "beginPath", [])
	J.mc(_s163["ctx"], "moveTo", [(J.max_([J.add(_s163["bx"], 10.0), J.min_([J.sub(J.add(_s163["bx"], v_w_361), 10.0), v_x_356])]) - 6.0), J.sub(J.add(_s163["by"], v_hh_362), 1.0)])
	J.mc(_s163["ctx"], "lineTo", [v_x_356, J.add(J.add(_s163["by"], v_hh_362), 8.0)])
	J.mc(_s163["ctx"], "lineTo", [(J.max_([J.add(_s163["bx"], 10.0), J.min_([J.sub(J.add(_s163["bx"], v_w_361), 10.0), v_x_356])]) + 6.0), J.sub(J.add(_s163["by"], v_hh_362), 1.0)])
	J.mc(_s163["ctx"], "fill", [])
	var _t356 = _s163["ctx"]
	J.sp(_t356, "fillStyle", "#2a1a10")
	var _t357 = _s163["ctx"]
	J.sp(_t357, "textAlign", "left")
	var _t358 = _s163["ctx"]
	J.sp(_t358, "textBaseline", "alphabetic")
	J.mc(v_lines_359, "forEach", [Callable(self, "_f75").bind(_s163)])
	J.mc(_s163["ctx"], "restore", [])

func _f77(this_, a: Array, env):
	var v_k_377 = null
	v_k_377 = J.arg(a, 0)
	return ("<button class=\"gs-chip\" data-k=\"" + J.str(v_k_377) + "\">" + J.str(J.gp(J.gp(J.G.get("GS_STALLS"), v_k_377), "name")) + "</button>")

func _f79(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "goStall", [J.gp(J.gp(env["b"], "dataset"), "k")])

func _f78(this_, a: Array, env):
	var _s173 = {"__p": env, "b": null}
	_s173["b"] = J.arg(a, 0)
	var _t369 = _s173["b"]
	var _t370 = Callable(self, "_f79").bind(_s173)
	J.sp(_t369, "onclick", _t370)
	return _t370

func _f80(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t372 = J.seq(J.gp(env["v"], "k"), "haggle")
	if J.t((J.gp(env["v"], "sub") if _t372 else _t372)):
		var _t373 = env["v"]
		J.sp(_t373, "sub", null)
		J.mc(env["this"], "renderPanel", [])
		return null
	var _t374 = env["this"]
	var _t375 = {"k": "idle"}
	J.sp(_t374, "view", _t375)
	J.mc(env["this"], "relax", [])
	J.mc(env["this"], "renderPanel", [])

func _f76(this_, a: Array, env):
	var v_p_371 = null; var v_s_373 = null; var v_h_374 = null; var v_x_375 = null; var v_first_376 = null
	var _s169 = {"__p": env, "this": null, "v": null}
	_s169["this"] = this_
	var _t359 = J.G.get("$")
	v_p_371 = J.cl(_t359, null, ["#gs-panel"])
	if (not J.t(v_p_371)):
		return null
	_s169["v"] = J.gp(_s169["this"], "view")
	v_s_373 = J.mc(_s169["this"], "st", [])
	v_h_374 = ""
	if J.seq(J.gp(_s169["v"], "k"), "idle"):
		var _t360 = J.gp(v_s_373, "visits")
		v_first_376 = J.cmp((_t360 if J.t(_t360) else 0.0), 1.0, "<=")
		var _t362 = ("點地面走路，按住拖著，阿福會跟著走。點攤位直接光顧。" if J.t(v_first_376) else "想去哪一攤？")
		var _t361 = J.mc(J.G.get("GS_ORDER"), "map", [Callable(self, "_f77").bind(_s169)])
		var _t363 = ("<p class=\"gs-hint\">" + _t362 + "</p>\n        <div class=\"gs-chips\">" + J.str(J.mc(_t361, "join", [""])) + "</div>\n        " + (("<p class=\"gs-note\">肚子裡：" + J.str(J.gp(J.gp(J.G.get("GS_MEALS"), J.gp(v_s_373, "meal")), "name")) + "（下一場出征生效）</p>") if J.t(J.gp(v_s_373, "meal")) else ""))
		v_h_374 = _t363
	else:
		var _t366 = J.gp(J.gp(J.G.get("GS_STALLS"), J.gp(_s169["v"], "k")), "name")
		var _t364 = _s169["this"]
		var _t365 = J.add("html_", J.gp(_s169["v"], "k"))
		var _t367 = ("<div class=\"gs-ph\"><b>" + J.str(_t366) + "</b><button class=\"gs-x\" id=\"gs-x\" aria-label=\"離開\">離開</button></div><div class=\"gs-body\">" + J.str(J.mc(_t364, _t365, [])) + "</div>")
		v_h_374 = _t367
	J.sp(v_p_371, "innerHTML", v_h_374)
	var _t368 = J.mc(v_p_371, "querySelectorAll", [".gs-chip"])
	J.mc(_t368, "forEach", [Callable(self, "_f78").bind(_s169)])
	var _t371 = J.G.get("$")
	v_x_375 = J.cl(_t371, null, ["#gs-x"])
	if J.t(v_x_375):
		var _t376 = Callable(self, "_f80").bind(_s169)
		J.sp(v_x_375, "onclick", _t376)
	if (not J.seq(J.gp(_s169["v"], "k"), "idle")):
		var _t377 = _s169["this"]
		var _t378 = J.add("bind_", J.gp(_s169["v"], "k"))
		J.mc(_t377, _t378, [v_p_371])

func _f81(this_, a: Array, env):
	var v_k_381 = null; var v_kp_382 = null
	for _t379 in J.keys(J.gp(this_, "keepers")):
		v_k_381 = _t379
		v_kp_382 = J.gp(J.gp(this_, "keepers"), v_k_381)
		J.sp(v_kp_382, "hold", false)
		J.sp(v_kp_382, "pose", null)
		J.sp(v_kp_382, "poseT", 0.0)

func _f82(this_, a: Array, env):
	var v_k_385 = null; var v_pose_386 = null; var v_dur_387 = null; var v_hold_388 = null; var v_kp_389 = null
	v_k_385 = J.arg(a, 0)
	v_pose_386 = J.arg(a, 1)
	v_dur_387 = J.arg(a, 2)
	v_hold_388 = J.arg(a, 3)
	v_kp_389 = J.gp(J.gp(this_, "keepers"), v_k_385)
	if (not J.t(v_kp_389)):
		return null
	J.sp(v_kp_389, "pose", v_pose_386)
	J.sp(v_kp_389, "pt", 0.0)
	var _t380 = (v_dur_387 if J.t(v_dur_387) else 1.2)
	J.sp(v_kp_389, "poseT", _t380)
	var _t381 = (not (not J.t(v_hold_388)))
	J.sp(v_kp_389, "hold", _t381)

func _f83(this_, a: Array, env):
	var v_n_392 = null
	v_n_392 = J.arg(a, 0)
	var _t382 = J.gp(J.gp(J.G.get("S"), "res"), "coins")
	return J.cmp((_t382 if J.t(_t382) else 0.0), v_n_392, ">=")

func _f84(this_, a: Array, env):
	var v_n_395 = null
	v_n_395 = J.arg(a, 0)
	var _t383 = J.gp(J.G.get("S"), "res")
	var _t384 = J.sub(J.gp(_t383, "coins"), v_n_395)
	J.sp(_t383, "coins", _t384)
	J.mc(J.G.get("UI"), "refresh", [])

func _f86(this_, a: Array, env):
	var v_k_399 = null; var v_e_400 = null; var v_own_401 = null
	v_k_399 = J.arg(a, 0)
	v_e_400 = J.gp(J.G.get("GS_EFFIGY"), v_k_399)
	v_own_401 = J.gp(env["fx"], v_k_399)
	return ("<div class=\"gs-card " + ("own" if J.t(v_own_401) else "") + "\"><div class=\"gs-ci\"><b>" + J.str(J.gp(v_e_400, "name")) + "</b><small class=\"gs-eff\">" + J.str(J.gp(v_e_400, "eff")) + "</small><small>" + J.str(J.gp(v_e_400, "say")) + "</small></div>\n        <button class=\"btn " + ("ghost" if J.t(v_own_401) else "gold") + " sm gs-buy\" data-k=\"" + J.str(v_k_399) + "\" " + ("disabled" if J.t((v_own_401 if J.t(v_own_401) else (not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_e_400, "price")]))))) else "") + ">" + ("已燒" if J.t(v_own_401) else ("燒 " + J.str(J.gp(v_e_400, "price")))) + "</button></div>")

func _f85(this_, a: Array, env):
	var _s183 = {"__p": env, "this": null, "fx": null}
	_s183["this"] = this_
	_s183["fx"] = J.gp(J.mc(_s183["this"], "st", []), "fx")
	var _t385 = J.S_Object_("keys", [J.G.get("GS_EFFIGY")])
	var _t386 = J.mc(_t385, "map", [Callable(self, "_f86").bind(_s183)])
	return ("<p class=\"gs-line\"><b>小紙</b>燒了就是你的，永久有效。不退貨，因為已經燒了。</p><div class=\"gs-list\">" + J.str(J.mc(_t386, "join", [""])) + "</div>")

func _f89(this_, a: Array, env):
	var v_k_406 = null; var v_e_407 = null; var v_s_408 = null
	v_k_406 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_e_407 = J.gp(J.G.get("GS_EFFIGY"), v_k_406)
	v_s_408 = J.mc(env["__p"]["this"], "st", [])
	var _t389 = J.gp(J.gp(v_s_408, "fx"), v_k_406)
	if J.t((_t389 if J.t(_t389) else (not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_e_407, "price")]))))):
		return null
	J.mc(env["__p"]["this"], "spend", [J.gp(v_e_407, "price")])
	var _t390 = J.gp(v_s_408, "fx")
	J.sp(_t390, v_k_406, true)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("Sound"), "play", ["chest"])
	J.mc(env["__p"]["this"], "burn", [J.gp(J.gp(J.G.get("GS_STALLS"), "paper"), "x")])
	J.mc(env["__p"]["this"], "say", [J.gp(J.gp(env["__p"]["this"], "keepers"), "paper"), (J.add("燒好了！", J.gp(v_e_407, "eff")) + "。"), 3.0])
	J.mc(env["__p"]["this"], "keeperPose", ["paper", "cast", 1.2])
	J.mc(env["__p"]["this"], "float", [J.gp(J.gp(env["__p"]["this"], "afu"), "x"), J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16), (J.str(J.gp(v_e_407, "name")) + "  到手"), "#ffe08a"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f88(this_, a: Array, env):
	var _s186 = {"__p": env, "b": null}
	_s186["b"] = J.arg(a, 0)
	var _t388 = _s186["b"]
	var _t391 = Callable(self, "_f89").bind(_s186)
	J.sp(_t388, "onclick", _t391)
	return _t391

func _f87(this_, a: Array, env):
	var v_p_404 = null
	var _s185 = {"__p": env, "this": null}
	_s185["this"] = this_
	v_p_404 = J.arg(a, 0)
	var _t387 = J.mc(v_p_404, "querySelectorAll", [".gs-buy"])
	J.mc(_t387, "forEach", [Callable(self, "_f88").bind(_s185)])

func _f90(this_, a: Array, env):
	var v_fx_411 = null; var v_i_412 = null
	v_fx_411 = J.arg(a, 0)
	v_i_412 = 0.0
	while true:
		if not J.cmp(v_i_412, 22.0, "<"): break
		var _t392 = J.gp(this_, "parts")
		J.mc(_t392, "push", [{"kind": "joss", "x": J.add(v_fx_411, ((randf() - 0.5) * 0.06)), "y": 0.62, "bx": ((randf() - 0.5) * 0.04), "vx": 0.0, "vy": ((-0.08) - (randf() * 0.06)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 8.0), "flip": 0.0, "vf": 6.0, "sw": 2.0, "ph": (randf() * 6.0), "land": 2.0, "life": (2.0 + randf()), "max": 3.0}])
		v_i_412 = J.num(v_i_412) + 1.0

func _f92(this_, a: Array, env):
	var v___417 = null; var v_i_418 = null
	v___417 = J.arg(a, 0)
	v_i_418 = J.arg(a, 1)
	return v_i_418

func _f93(this_, a: Array, env):
	var v_a_419 = null; var v_b_420 = null
	v_a_419 = J.arg(a, 0)
	v_b_420 = J.arg(a, 1)
	var _t394 = J.G.get("gsRnd")
	var _t396 = J.cl(_t394, null, [J.add(J.mul(env["d"], 31.0), v_a_419)])
	var _t395 = J.G.get("gsRnd")
	return J.sub(_t396, J.cl(_t395, null, [J.add(J.mul(env["d"], 31.0), v_b_420)]))

func _f94(this_, a: Array, env):
	var v_i_421 = null
	v_i_421 = J.arg(a, 0)
	return J.gp(J.G.get("GS_ITEMS"), v_i_421)

func _f91(this_, a: Array, env):
	var v_idx_416 = null
	var _s190 = {"__p": env, "d": null}
	_s190["d"] = J.cl(J.G.get("gsDay"), null, [])
	var _t393 = J.mc(J.G.get("GS_ITEMS"), "map", [Callable(self, "_f92").bind(_s190)])
	v_idx_416 = J.mc(_t393, "sort", [Callable(self, "_f93").bind(_s190)])
	var _t397 = J.mc(v_idx_416, "slice", [0.0, 3.0])
	return J.mc(_t397, "map", [Callable(self, "_f94").bind(_s190)])

func _f95(this_, a: Array, env):
	var v_it_424 = null
	v_it_424 = J.arg(a, 0)
	var _t399 = J.gp(v_it_424, "col")
	var _t398 = J.G.get("gsRnd")
	return J.round(J.num(J.mul(_t399, (0.5 + J.mul(0.35, J.cl(_t398, null, [((J.mul(J.cl(J.G.get("gsDay"), null, []), 977.0) + J.mul(J.gp(v_it_424, "col"), 13.0)) + J.len(J.gp(v_it_424, "id")))]))))))

func _f96(this_, a: Array, env):
	var v_it_427 = null
	v_it_427 = J.arg(a, 0)
	return J.round(J.num(J.mul(J.gp(v_it_427, "col"), 1.15)))

func _f98(this_, a: Array, env):
	var v_it_439 = null; var v_st_440 = null
	v_it_439 = J.arg(a, 0)
	v_st_440 = J.gp(J.gp(env["h"], "done"), J.gp(v_it_439, "id"))
	return ("<button class=\"gs-card gs-item " + ("own" if J.t(v_st_440) else "") + "\" data-id=\"" + J.str(J.gp(v_it_439, "id")) + "\" " + ("disabled" if J.t(v_st_440) else "") + "><div class=\"gs-ci\"><b>" + J.str(J.gp(v_it_439, "name")) + "</b><small>" + J.str(J.gp(v_it_439, "desc")) + "</small><small class=\"gs-eff\">標價 " + J.str(J.mc(env["this"], "askOf", [v_it_439])) + "　收藏家收購 " + J.str(J.gp(v_it_439, "col")) + "</small></div><em>" + ("已買" if J.seq(v_st_440, "bought") else ("收起來了" if J.seq(v_st_440, "shelved") else "講價")) + "</em></button>")

func _f99(this_, a: Array, env):
	var v_i_441 = null
	v_i_441 = J.arg(a, 0)
	return J.seq(J.gp(v_i_441, "id"), J.gp(env["v"], "sub"))

func _f100(this_, a: Array, env):
	var v_m_442 = null; var v_i_443 = null
	v_m_442 = J.arg(a, 0)
	v_i_443 = J.arg(a, 1)
	return ("<i class=\"" + ("on" if J.seq(v_i_443, env["lv"]) else "") + "\" style=\"--c:" + J.str(J.gp(["#e2483a", "#d07a3a", "#d8b84a", "#9ad05a", "#5ad0a0"], v_i_443)) + "\">" + J.str(v_m_442) + "</i>")

func _f97(this_, a: Array, env):
	var v_it_432 = null; var v_tries_433 = null; var v_ask_434 = null; var v_last_435 = null; var v_offer_436 = null; var v_mood_438 = null
	var _s196 = {"__p": env, "this": null, "h": null, "v": null, "lv": null}
	_s196["this"] = this_
	_s196["h"] = J.gp(J.mc(_s196["this"], "st", []), "hag")
	_s196["v"] = J.gp(_s196["this"], "view")
	if J.t(J.gp(_s196["h"], "out")):
		return ("<p class=\"gs-line bad\"><b>小鬼</b>還敢回來？今晚不做你生意！明天請早。</p><p class=\"gs-note\">你今晚侮辱了小鬼三次，被轟了出去。明天再來。</p>")
	if (not J.t(J.gp(_s196["v"], "sub"))):
		var _t402 = ("看中哪件就出價。開太低，我會翻臉。" if J.t(J.mod(J.gp(J.mc(_s196["this"], "st", []), "visits"), 2.0)) else "我的貨都是古董，你的出價最好也是。")
		var _t400 = J.mc(_s196["this"], "todayItems", [])
		var _t401 = J.mc(_t400, "map", [Callable(self, "_f98").bind(_s196)])
		return ("<p class=\"gs-line\"><b>小鬼</b>" + _t402 + "</p>\n        <p class=\"gs-note\">收藏家會照「收購價」收走你買到的東西。買得越便宜，賺得越多。小鬼心裡有底價，看他臉色推算。每件最多出價三次；侮辱他三次會被轟走。</p>\n        <div class=\"gs-list\">" + J.str(J.mc(_t401, "join", [""])) + "</div>\n        <p class=\"gs-note\">侮辱 " + J.str(J.gp(_s196["h"], "strikes")) + "/3</p>")
	v_it_432 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f99").bind(_s196)])
	var _t403 = J.gp(J.gp(_s196["h"], "tries"), J.gp(v_it_432, "id"))
	v_tries_433 = (_t403 if J.t(_t403) else 0.0)
	v_ask_434 = J.mc(_s196["this"], "askOf", [v_it_432])
	v_last_435 = J.gp(_s196["v"], "last")
	var _t404 = J.gp(_s196["v"], "offer")
	v_offer_436 = (_t404 if J.t(_t404) else J.round(J.num(J.mul(J.gp(v_it_432, "col"), 0.6))))
	_s196["lv"] = ((J.gp(J.gp(v_last_435, "band"), "lv") if J.t(J.gp(v_last_435, "band")) else 4.0) if J.t(v_last_435) else (-1.0))
	v_mood_438 = ((J.gp(J.gp(v_last_435, "band"), "mood") if J.t(J.gp(v_last_435, "band")) else "成交") if J.t(v_last_435) else "打量你")
	var _t407 = J.gp(v_it_432, "name")
	var _t408 = J.gp(v_it_432, "desc")
	var _t409 = J.gp(v_it_432, "col")
	var _t410 = ("bad" if J.seq(_s196["lv"], 0.0) else "")
	var _t411 = (J.gp(v_last_435, "line") if J.t(v_last_435) else "出個價來聽聽。")
	var _t405 = ["翻臉", "很臭", "猶豫", "肉痛", "成交"]
	var _t406 = J.mc(_t405, "map", [Callable(self, "_f100").bind(_s196)])
	return ("<div class=\"gs-hag\"><b class=\"gs-iname\">" + J.str(_t407) + "</b><small>" + J.str(_t408) + "</small>\n      <div class=\"gs-prices\"><span>標價 <b>" + J.str(v_ask_434) + "</b></span><span>收藏家收購 <b>" + J.str(_t409) + "</b></span></div>\n      <p class=\"gs-line " + _t410 + "\"><b>小鬼</b>" + J.str(_t411) + "</p>\n      <div class=\"gs-mood\"><span>臉色</span>" + J.str(J.mc(_t406, "join", [""])) + "<em>" + J.str(v_mood_438) + "</em></div>\n      " + ("" if J.t(J.gp(_s196["v"], "closed")) else ("<div class=\"gs-offer\"><button class=\"btn sm\" id=\"gs-m\">−5</button><input type=\"range\" id=\"gs-r\" min=\"5\" max=\"" + J.str(v_ask_434) + "\" step=\"1\" value=\"" + J.str(v_offer_436) + "\"><button class=\"btn sm\" id=\"gs-p\">+5</button></div>\n      <button class=\"btn gold wide\" id=\"gs-go\" " + ("" if J.t(J.mc(_s196["this"], "coinsOk", [v_offer_436])) else "disabled") + ">出價 <span id=\"gs-ov\">" + J.str(v_offer_436) + "</span> 冥幣</button>")) + "\n      <p class=\"gs-note\">第 " + J.str(J.min_([3.0, J.add(v_tries_433, (0.0 if J.t(J.gp(_s196["v"], "closed")) else 1.0))])) + "/3 次出價　侮辱 " + J.str(J.gp(_s196["h"], "strikes")) + "/3" + ("" if J.t(J.gp(_s196["v"], "closed")) else ("" if J.t(J.mc(_s196["this"], "coinsOk", [v_offer_436])) else "　（冥幣不夠）")) + "</p>\n      " + (("<button class=\"btn wide\" id=\"gs-back2\">看別的貨</button>") if J.t(J.gp(_s196["v"], "closed")) else "") + "</div>")

func _f103(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t414 = env["__p"]["v"]
	var _t415 = J.gp(J.gp(env["b"], "dataset"), "id")
	J.sp(_t414, "sub", _t415)
	var _t416 = env["__p"]["v"]
	J.sp(_t416, "last", null)
	var _t417 = env["__p"]["v"]
	J.sp(_t417, "closed", false)
	var _t418 = env["__p"]["v"]
	J.sp(_t418, "offer", null)
	J.mc(env["__p"]["this"], "renderPanel", [])
	J.mc(env["__p"]["this"], "keeperPose", ["haggle", null, 0.0])

func _f102(this_, a: Array, env):
	var _s202 = {"__p": env, "b": null}
	_s202["b"] = J.arg(a, 0)
	var _t413 = _s202["b"]
	var _t419 = Callable(self, "_f103").bind(_s202)
	J.sp(_t413, "onclick", _t419)
	return _t419

func _f104(this_, a: Array, env):
	var _t421 = env["v"]
	J.sp(_t421, "sub", null)
	var _t422 = env["v"]
	J.sp(_t422, "closed", false)
	var _t423 = env["v"]
	J.sp(_t423, "last", null)
	J.mc(env["this"], "renderPanel", [])

func _f106(this_, a: Array, env):
	var v_i_455 = null
	v_i_455 = J.arg(a, 0)
	return J.seq(J.gp(v_i_455, "id"), J.gp(env["v"], "sub"))

func _f105(this_, a: Array, env):
	var v_n_453 = null; var v_it_454 = null
	v_n_453 = J.arg(a, 0)
	v_it_454 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f106").bind(env)])
	var _t426 = J.max_([5.0, J.min_([J.mc(env["this"], "askOf", [v_it_454]), v_n_453])])
	v_n_453 = _t426
	var _t427 = env["v"]
	J.sp(_t427, "offer", v_n_453)
	var _t428 = env["r"]
	J.sp(_t428, "value", v_n_453)
	var _t429 = J.G.get("$")
	var _t430 = J.cl(_t429, null, ["#gs-ov"])
	J.sp(_t430, "textContent", v_n_453)
	var _t431 = J.G.get("$")
	var _t432 = J.cl(_t431, null, ["#gs-go"])
	var _t433 = (not J.t(J.mc(env["this"], "coinsOk", [v_n_453])))
	J.sp(_t432, "disabled", _t433)

func _f107(this_, a: Array, env):
	var _t435 = env["set"]
	return J.cl(_t435, null, [J.num(J.gp(env["r"], "value"))])

func _f108(this_, a: Array, env):
	var _t439 = env["set"]
	return J.cl(_t439, null, [(J.num(J.gp(env["r"], "value")) - 5.0)])

func _f109(this_, a: Array, env):
	var _t443 = env["set"]
	return J.cl(_t443, null, [(J.num(J.gp(env["r"], "value")) + 5.0)])

func _f110(this_, a: Array, env):
	return J.mc(env["this"], "offer", [J.num(J.gp(env["r"], "value"))])

func _f101(this_, a: Array, env):
	var v_p_446 = null; var v_h_448 = null; var v_b2_449 = null
	var _s201 = {"__p": env, "this": null, "v": null, "r": null, "set": null}
	_s201["this"] = this_
	v_p_446 = J.arg(a, 0)
	_s201["v"] = J.gp(_s201["this"], "view")
	v_h_448 = J.gp(J.mc(_s201["this"], "st", []), "hag")
	var _t412 = J.mc(v_p_446, "querySelectorAll", [".gs-item"])
	J.mc(_t412, "forEach", [Callable(self, "_f102").bind(_s201)])
	var _t420 = J.G.get("$")
	v_b2_449 = J.cl(_t420, null, ["#gs-back2"])
	if J.t(v_b2_449):
		var _t424 = Callable(self, "_f104").bind(_s201)
		J.sp(v_b2_449, "onclick", _t424)
	var _t425 = J.G.get("$")
	_s201["r"] = J.cl(_t425, null, ["#gs-r"])
	if (not J.t(_s201["r"])):
		return null
	_s201["set"] = Callable(self, "_f105").bind(_s201)
	var _t434 = _s201["r"]
	var _t436 = Callable(self, "_f107").bind(_s201)
	J.sp(_t434, "oninput", _t436)
	var _t437 = J.G.get("$")
	var _t438 = J.cl(_t437, null, ["#gs-m"])
	var _t440 = Callable(self, "_f108").bind(_s201)
	J.sp(_t438, "onclick", _t440)
	var _t441 = J.G.get("$")
	var _t442 = J.cl(_t441, null, ["#gs-p"])
	var _t444 = Callable(self, "_f109").bind(_s201)
	J.sp(_t442, "onclick", _t444)
	var _t445 = J.G.get("$")
	var _t446 = J.cl(_t445, null, ["#gs-go"])
	var _t447 = Callable(self, "_f110").bind(_s201)
	J.sp(_t446, "onclick", _t447)

func _f112(this_, a: Array, env):
	var v_i_466 = null
	v_i_466 = J.arg(a, 0)
	return J.seq(J.gp(v_i_466, "id"), J.gp(env["v"], "sub"))

func _f113(this_, a: Array, env):
	var v_b_469 = null
	v_b_469 = J.arg(a, 0)
	return J.cmp(env["r"], J.gp(v_b_469, "max"), "<")

func _f111(this_, a: Array, env):
	var v_n_458 = null; var v_s_460 = null; var v_h_461 = null; var v_it_462 = null; var v_floor_463 = null; var v_tries_465 = null; var v_fat_467 = null; var v_band_468 = null
	var _s211 = {"__p": env, "v": null, "r": null}
	v_n_458 = J.arg(a, 0)
	_s211["v"] = J.gp(this_, "view")
	v_s_460 = J.mc(this_, "st", [])
	v_h_461 = J.gp(v_s_460, "hag")
	v_it_462 = J.mc(J.G.get("GS_ITEMS"), "find", [Callable(self, "_f112").bind(_s211)])
	var _t448 = (not J.t(v_it_462))
	var _t449 = (_t448 if _t448 else J.gp(J.gp(v_h_461, "done"), J.gp(v_it_462, "id")))
	var _t450 = (_t449 if J.t(_t449) else J.gp(v_h_461, "out"))
	if J.t((_t450 if J.t(_t450) else (not J.t(J.mc(this_, "coinsOk", [v_n_458]))))):
		return null
	v_floor_463 = J.mc(this_, "floorOf", [v_it_462])
	_s211["r"] = J.div(v_n_458, v_floor_463)
	var _t451 = J.gp(v_h_461, "tries")
	var _t452 = J.gp(v_it_462, "id")
	var _t453 = J.gp(J.gp(v_h_461, "tries"), J.gp(v_it_462, "id"))
	var _t454 = J.add((_t453 if J.t(_t453) else 0.0), 1.0)
	J.sp(_t451, _t452, _t454)
	v_tries_465 = J.gp(J.gp(v_h_461, "tries"), J.gp(v_it_462, "id"))
	var _t455 = _s211["v"]
	J.sp(_t455, "offer", v_n_458)
	if J.cmp(_s211["r"], 1.0, ">="):
		J.mc(this_, "spend", [v_n_458])
		var _t456 = J.gp(J.G.get("S"), "res")
		var _t457 = J.add(J.gp(_t456, "coins"), J.gp(v_it_462, "col"))
		J.sp(_t456, "coins", _t457)
		var _t458 = J.gp(v_h_461, "done")
		var _t459 = J.gp(v_it_462, "id")
		J.sp(_t458, _t459, "bought")
		var _t460 = J.gp(v_s_460, "curios")
		J.mc(_t460, "push", [J.gp(v_it_462, "id")])
		if (J.len(J.gp(v_s_460, "curios")) > 40.0):
			J.mc(J.gp(v_s_460, "curios"), "shift", [])
		v_fat_467 = J.cmp(_s211["r"], 1.08, ">=")
		var _t461 = _s211["v"]
		var _t462 = J.G.get("pick")
		var _t463 = {"band": null, "line": J.add(J.cl(_t462, null, [(J.G.get("GS_DEAL_FAT") if J.t(v_fat_467) else J.G.get("GS_DEAL_TIGHT"))]), ("（收藏家用 " + J.str(J.gp(v_it_462, "col")) + " 收走了，你" + ("賺" if (J.sub(J.gp(v_it_462, "col"), v_n_458) >= 0.0) else "虧") + "了 " + J.str(absf(J.num(J.sub(J.gp(v_it_462, "col"), v_n_458)))) + "）"))}
		J.sp(_t461, "last", _t463)
		var _t464 = _s211["v"]
		J.sp(_t464, "closed", true)
		J.mc(this_, "keeperPose", ["haggle", "cast", 1.6])
		var _t465 = J.gp(this_, "afu")
		J.sp(_t465, "pose", "cast")
		var _t466 = J.gp(this_, "afu")
		J.sp(_t466, "poseT", 1.0)
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), (("+" if (J.sub(J.gp(v_it_462, "col"), v_n_458) >= 0.0) else "−") + J.str(absf(J.num(J.sub(J.gp(v_it_462, "col"), v_n_458)))) + " 冥幣"), ("#ffe08a" if (J.sub(J.gp(v_it_462, "col"), v_n_458) >= 0.0) else "#ff9a8a")])
		J.mc(J.G.get("Sound"), "play", ["coin"])
	else:
		v_band_468 = J.mc(J.G.get("GS_BANDS"), "find", [Callable(self, "_f113").bind(_s211)])
		var _t467 = _s211["v"]
		var _t468 = {"band": v_band_468, "line": J.gp(J.gp(v_band_468, "lines"), J.mod(J.sub(v_tries_465, 1.0), J.len(J.gp(v_band_468, "lines"))))}
		J.sp(_t467, "last", _t468)
		J.mc(this_, "keeperPose", ["haggle", (null if J.seq(J.gp(v_band_468, "pose"), "idle") else J.gp(v_band_468, "pose")), 2.4, true])
		if J.seq(J.gp(v_band_468, "lv"), 0.0):
			J.sp(v_h_461, "strikes", J.num(J.gp(v_h_461, "strikes")) + 1.0)
			J.mc(J.G.get("Sound"), "play", ["hit"])
		else:
			J.mc(J.G.get("Sound"), "play", ["paper"])
		if J.cmp(J.gp(v_h_461, "strikes"), 3.0, ">="):
			J.sp(v_h_461, "out", true)
			var _t469 = J.gp(_s211["v"], "last")
			J.sp(_t469, "line", "三次侮辱我？給我滾！今晚別再來！")
			var _t470 = this_
			J.sp(_t470, "kick", 1.1)
			J.mc(this_, "say", [J.gp(J.gp(this_, "keepers"), "haggle"), "滾！", 2.0])
			var _t471 = J.gp(this_, "afu")
			J.sp(_t471, "pose", "hurt")
			J.mc(J.G.get("Sound"), "play", ["whoosh"])
		else:
			if J.cmp(v_tries_465, 3.0, ">="):
				var _t472 = J.gp(v_h_461, "done")
				var _t473 = J.gp(v_it_462, "id")
				J.sp(_t472, _t473, "shelved")
				var _t474 = J.gp(_s211["v"], "last")
				var _t475 = J.add(J.gp(_t474, "line"), "……三次都談不攏，這件我收起來了！")
				J.sp(_t474, "line", _t475)
				var _t476 = _s211["v"]
				J.sp(_t476, "closed", true)
		var _t479 = J.gp(J.gp(this_, "keepers"), "haggle")
		var _t478 = null
		if (J.len(J.gp(J.gp(_s211["v"], "last"), "line")) > 22.0):
			var _t477 = J.gp(J.gp(_s211["v"], "last"), "line")
			_t478 = J.add(J.mc(_t477, "slice", [0.0, 20.0]), "……")
		else:
			_t478 = J.gp(J.gp(_s211["v"], "last"), "line")
		J.mc(this_, "say", [_t479, _t478, 2.4])
	J.cl(J.G.get("save"), null, [])
	J.mc(this_, "renderPanel", [])

func _f114(this_, a: Array, env):
	var v_d_472 = null; var v_v_473 = null
	v_d_472 = J.arg(a, 0)
	var _t481 = ((1.0 + (0.16 * sin(J.num(J.mul(v_d_472, 0.5))))) + (0.05 * sin(J.num((J.mul(v_d_472, 1.9) + 1.3)))))
	var _t480 = J.G.get("gsRnd")
	v_v_473 = (100.0 * (_t481 + (0.06 * J.sub(J.cl(_t480, null, [(J.mul(v_d_472, 7.0) + 3.0)]), 0.5))))
	return J.max_([30.0, J.round(J.num(v_v_473))])

func _f115(this_, a: Array, env):
	var v_d_476 = null; var v_p_477 = null; var v_y_478 = null; var v_ch_479 = null; var v_up_480 = null; var v_st_481 = null; var v_news_482 = null; var v_val_483 = null; var v_pl_484 = null
	v_d_476 = J.cl(J.G.get("gsDay"), null, [])
	v_p_477 = J.mc(this_, "price", [v_d_476])
	v_y_478 = J.mc(this_, "price", [J.sub(v_d_476, 1.0)])
	v_ch_479 = (J.div(J.sub(v_p_477, v_y_478), v_y_478) * 100.0)
	v_up_480 = J.cmp(J.mc(this_, "price", [J.add(v_d_476, 1.0)]), v_p_477, ">=")
	v_st_481 = J.gp(J.mc(this_, "st", []), "stock")
	var _t483 = (J.G.get("GS_NEWS_UP") if J.t(v_up_480) else J.G.get("GS_NEWS_DN"))
	var _t482 = J.G.get("gsRnd")
	v_news_482 = J.gp(_t483, floor(J.num(J.mul(J.cl(_t482, null, [(J.mul(v_d_476, 5.0) + 1.0)]), 5.0))))
	v_val_483 = J.mul(J.gp(v_st_481, "n"), v_p_477)
	v_pl_484 = (J.sub(v_val_483, J.gp(v_st_481, "cost")) if J.t(J.gp(v_st_481, "n")) else 0.0)
	var _t485 = ("up" if J.cmp(v_ch_479, 0.0, ">=") else "dn")
	var _t486 = ("▲" if J.cmp(v_ch_479, 0.0, ">=") else "▼")
	var _t484 = absf(J.num(v_ch_479))
	var _t488 = J.mc(_t484, "toFixed", [1.0])
	var _t489 = J.gp(v_st_481, "n")
	var _t490 = J.G.get("GS_SHARE_CAP")
	var _t487 = J.G.get("fmt")
	var _t495 = J.cl(_t487, null, [v_val_483])
	var _t494 = null
	if J.t(J.gp(v_st_481, "n")):
		var _t492 = ("up" if J.cmp(v_pl_484, 0.0, ">=") else "dn")
		var _t493 = ("賺" if J.cmp(v_pl_484, 0.0, ">=") else "虧")
		var _t491 = J.G.get("fmt")
		_t494 = ("<span class=\"" + _t492 + "\">" + _t493 + " " + J.str(J.cl(_t491, null, [absf(J.num(v_pl_484))])) + "</span>")
	else:
		_t494 = ""
	return ("<p class=\"gs-line\"><b>白無常</b>一見生財！小道消息：「" + J.str(v_news_482) + "」</p>\n      <div class=\"gs-stock\"><div><small>地府科技（今日）</small><b class=\"gs-px\">" + J.str(v_p_477) + "</b><em class=\"" + _t485 + "\">" + _t486 + " " + J.str(_t488) + "%</em></div><canvas id=\"gs-chart\"></canvas></div>\n      <p class=\"gs-note\">持有 " + J.str(_t489) + " 股（上限 " + J.str(_t490) + "）　市值 " + J.str(_t495) + "　" + _t494 + "　手續費 " + J.str(J.mul(J.G.get("GS_FEE"), 100.0)) + "%（買賣都收）</p>\n      <div class=\"gs-trade\"><button class=\"btn sm gs-t\" data-q=\"1\">買 1</button><button class=\"btn sm gs-t\" data-q=\"10\">買 10</button><button class=\"btn sm gs-t\" data-q=\"-1\">賣 1</button><button class=\"btn sm gs-t\" data-q=\"-10\">賣 10</button><button class=\"btn sm gs-t\" data-q=\"-999\">全賣</button></div>\n      <p class=\"gs-note dim\">價格每天換一次。白無常的小道消息說的是「明天」，他從來沒說錯過——只是不保證漲多少。</p>")

func _f118(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "trade", [env["q"]])

func _f117(this_, a: Array, env):
	var v_b_488 = null; var v_px_490 = null; var v_st_491 = null
	var _s222 = {"__p": env, "q": null}
	v_b_488 = J.arg(a, 0)
	_s222["q"] = J.num(J.gp(J.gp(v_b_488, "dataset"), "q"))
	v_px_490 = J.mc(_s222["__p"]["this"], "price", [J.cl(J.G.get("gsDay"), null, [])])
	v_st_491 = J.gp(J.mc(_s222["__p"]["this"], "st", []), "stock")
	if J.cmp(_s222["q"], 0.0, ">"):
		var _t497 = J.cmp(J.gp(v_st_491, "n"), J.G.get("GS_SHARE_CAP"), ">=")
		var _t498 = (_t497 if _t497 else (not J.t(J.mc(_s222["__p"]["this"], "coinsOk", [ceil(J.num(J.mul(J.mul(v_px_490, J.min_([_s222["q"], J.sub(J.G.get("GS_SHARE_CAP"), J.gp(v_st_491, "n"))])), J.add(1.0, J.G.get("GS_FEE")))))]))))
		J.sp(v_b_488, "disabled", _t498)
	else:
		var _t499 = J.cmp(J.gp(v_st_491, "n"), 0.0, "<=")
		J.sp(v_b_488, "disabled", _t499)
	var _t500 = Callable(self, "_f118").bind(_s222)
	J.sp(v_b_488, "onclick", _t500)

func _f116(this_, a: Array, env):
	var v_p_487 = null
	var _s221 = {"__p": env, "this": null}
	_s221["this"] = this_
	v_p_487 = J.arg(a, 0)
	var _t496 = J.mc(v_p_487, "querySelectorAll", [".gs-t"])
	J.mc(_t496, "forEach", [Callable(self, "_f117").bind(_s221)])
	J.mc(_s221["this"], "drawChart", [])

func _f119(this_, a: Array, env):
	var v_q_494 = null; var v_s_495 = null; var v_st_496 = null; var v_px_497 = null; var v_cost_498 = null; var v_got_499 = null; var v_basis_500 = null
	v_q_494 = J.arg(a, 0)
	v_s_495 = J.mc(this_, "st", [])
	v_st_496 = J.gp(v_s_495, "stock")
	v_px_497 = J.mc(this_, "price", [J.cl(J.G.get("gsDay"), null, [])])
	if J.cmp(v_q_494, 0.0, ">"):
		var _t501 = J.min_([v_q_494, J.sub(J.G.get("GS_SHARE_CAP"), J.gp(v_st_496, "n"))])
		v_q_494 = _t501
		v_cost_498 = ceil(J.num(J.mul(J.mul(v_px_497, v_q_494), J.add(1.0, J.G.get("GS_FEE")))))
		var _t502 = J.cmp(v_q_494, 0.0, "<=")
		if (_t502 if _t502 else (not J.t(J.mc(this_, "coinsOk", [v_cost_498])))):
			return null
		J.mc(this_, "spend", [v_cost_498])
		var _t503 = J.add(J.gp(v_st_496, "n"), v_q_494)
		J.sp(v_st_496, "n", _t503)
		var _t504 = J.add(J.gp(v_st_496, "cost"), v_cost_498)
		J.sp(v_st_496, "cost", _t504)
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), ("買入 " + J.str(v_q_494) + " 股"), "#bfe8ff"])
		var _t506 = J.gp(J.gp(this_, "keepers"), "exch")
		var _t505 = J.G.get("pick")
		J.mc(this_, "say", [_t506, J.cl(_t505, null, [["一見生財！有眼光！", "買定離手～", "恭喜發財，虧了別找我。"]]), 2.4])
	else:
		var _t507 = J.min_([(-J.num(v_q_494)), J.gp(v_st_496, "n")])
		v_q_494 = _t507
		if J.cmp(v_q_494, 0.0, "<="):
			return null
		v_got_499 = floor(J.num((J.mul(v_px_497, v_q_494) * J.sub(1.0, J.G.get("GS_FEE")))))
		v_basis_500 = J.div(J.mul(J.gp(v_st_496, "cost"), v_q_494), J.gp(v_st_496, "n"))
		var _t508 = J.sub(J.gp(v_st_496, "cost"), v_basis_500)
		J.sp(v_st_496, "cost", _t508)
		var _t509 = J.sub(J.gp(v_st_496, "n"), v_q_494)
		J.sp(v_st_496, "n", _t509)
		var _t510 = J.gp(J.G.get("S"), "res")
		var _t511 = J.add(J.gp(_t510, "coins"), v_got_499)
		J.sp(_t510, "coins", _t511)
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(this_, "float", [J.gp(J.gp(this_, "afu"), "x"), J.sub(J.gp(J.gp(this_, "afu"), "y"), 0.16), ("賣出 +" + J.str(v_got_499)), ("#ffe08a" if J.cmp(v_got_499, v_basis_500, ">=") else "#ff9a8a")])
		J.mc(this_, "say", [J.gp(J.gp(this_, "keepers"), "exch"), ("一見生財！賺到了吧～" if J.cmp(v_got_499, v_basis_500, ">=") else "虧了？陰間也有韭菜的。"), 2.4])
	if J.seq(J.gp(v_st_496, "n"), 0.0):
		J.sp(v_st_496, "cost", 0.0)
	J.mc(this_, "keeperPose", ["exch", "cast", 1.0])
	J.mc(J.G.get("Sound"), "play", ["coin"])
	J.cl(J.G.get("save"), null, [])
	J.mc(this_, "renderPanel", [])

func _f121(this_, a: Array, env):
	var v___515 = null; var v_i_516 = null
	v___515 = J.arg(a, 0)
	v_i_516 = J.arg(a, 1)
	return J.mc(env["this"], "price", [J.add(J.sub(env["d"], 6.0), v_i_516)])

func _f122(this_, a: Array, env):
	var v_i_517 = null
	v_i_517 = J.arg(a, 0)
	return (10.0 + J.div(J.mul(v_i_517, J.sub(env["w"], 20.0)), 6.0))

func _f123(this_, a: Array, env):
	var v_v_518 = null
	v_v_518 = J.arg(a, 0)
	return (J.sub(env["h"], 16.0) - (J.div(J.sub(v_v_518, env["lo"]), J.sub(env["hi"], env["lo"])) * J.sub(env["h"], 28.0)))

func _f124(this_, a: Array, env):
	var v_v_521 = null; var v_i_522 = null
	v_v_521 = J.arg(a, 0)
	v_i_522 = J.arg(a, 1)
	var _t529 = null
	if J.t(v_i_522):
		var _t523 = env["X"]
		var _t525 = J.cl(_t523, null, [v_i_522])
		var _t524 = env["Y"]
		_t529 = J.mc(env["ctx"], "lineTo", [_t525, J.cl(_t524, null, [v_v_521])])
	else:
		var _t526 = env["X"]
		var _t528 = J.cl(_t526, null, [v_i_522])
		var _t527 = env["Y"]
		_t529 = J.mc(env["ctx"], "moveTo", [_t528, J.cl(_t527, null, [v_v_521])])
	return _t529

func _f125(this_, a: Array, env):
	var v_v_523 = null; var v_i_524 = null
	v_v_523 = J.arg(a, 0)
	v_i_524 = J.arg(a, 1)
	var _t530 = env["ctx"]
	var _t531 = ("#ffcf6a" if J.seq(v_i_524, 6.0) else "#9be8b0")
	J.sp(_t530, "fillStyle", _t531)
	J.mc(env["ctx"], "beginPath", [])
	var _t532 = env["X"]
	var _t534 = J.cl(_t532, null, [v_i_524])
	var _t533 = env["Y"]
	J.mc(env["ctx"], "arc", [_t534, J.cl(_t533, null, [v_v_523]), (4.5 if J.seq(v_i_524, 6.0) else 2.6), 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])

func _f126(this_, a: Array, env):
	var v_l_525 = null; var v_i_526 = null
	v_l_525 = J.arg(a, 0)
	v_i_526 = J.arg(a, 1)
	if (not J.t(v_l_525)):
		return null
	var _t538 = env["ctx"]
	var _t539 = ("left" if J.seq(v_i_526, 0.0) else ("right" if J.seq(v_i_526, 6.0) else "center"))
	J.sp(_t538, "textAlign", _t539)
	var _t542 = null
	if J.seq(v_i_526, 0.0):
		_t542 = 2.0
	else:
		var _t541 = null
		if J.seq(v_i_526, 6.0):
			_t541 = J.sub(env["w"], 2.0)
		else:
			var _t540 = env["X"]
			_t541 = J.cl(_t540, null, [v_i_526])
		_t542 = _t541
	J.mc(env["ctx"], "fillText", [v_l_525, _t542, J.sub(env["h"], 2.0)])

func _f120(this_, a: Array, env):
	var v_c_503 = null; var v_r_504 = null; var v_dpr_505 = null; var v_ps_510 = null; var v_i_519 = null; var v_y_520 = null
	var _s227 = {"__p": env, "this": null, "w": null, "h": null, "ctx": null, "d": null, "lo": null, "hi": null, "X": null, "Y": null}
	_s227["this"] = this_
	var _t512 = J.G.get("$")
	v_c_503 = J.cl(_t512, null, ["#gs-chart"])
	if (not J.t(v_c_503)):
		return null
	v_r_504 = J.mc(v_c_503, "getBoundingClientRect", [])
	var _t513 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t514 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_505 = J.min_([2.0, (_t514 if J.t(_t514) else 1.0)])
	var _t515 = J.gp(v_r_504, "width")
	_s227["w"] = (_t515 if J.t(_t515) else 200.0)
	var _t516 = J.gp(v_r_504, "height")
	_s227["h"] = (_t516 if J.t(_t516) else 84.0)
	var _t517 = J.mul(_s227["w"], v_dpr_505)
	J.sp(v_c_503, "width", _t517)
	var _t518 = J.mul(_s227["h"], v_dpr_505)
	J.sp(v_c_503, "height", _t518)
	_s227["ctx"] = J.mc(v_c_503, "getContext", ["2d"])
	J.mc(_s227["ctx"], "scale", [v_dpr_505, v_dpr_505])
	_s227["d"] = J.cl(J.G.get("gsDay"), null, [])
	v_ps_510 = J.S_Array_("from", [{"length": 7.0}, Callable(self, "_f121").bind(_s227)])
	_s227["lo"] = (J.min_(J.spread([J.SP(v_ps_510)])) * 0.95)
	_s227["hi"] = (J.max_(J.spread([J.SP(v_ps_510)])) * 1.05)
	_s227["X"] = Callable(self, "_f122").bind(_s227)
	_s227["Y"] = Callable(self, "_f123").bind(_s227)
	var _t519 = _s227["ctx"]
	J.sp(_t519, "strokeStyle", "rgba(255,255,255,.12)")
	var _t520 = _s227["ctx"]
	J.sp(_t520, "lineWidth", 1.0)
	v_i_519 = 0.0
	while true:
		if not J.cmp(v_i_519, 3.0, "<"): break
		v_y_520 = (8.0 + J.div(J.mul(v_i_519, J.sub(_s227["h"], 24.0)), 2.0))
		J.mc(_s227["ctx"], "beginPath", [])
		J.mc(_s227["ctx"], "moveTo", [4.0, v_y_520])
		J.mc(_s227["ctx"], "lineTo", [J.sub(_s227["w"], 4.0), v_y_520])
		J.mc(_s227["ctx"], "stroke", [])
		v_i_519 = J.num(v_i_519) + 1.0
	var _t521 = _s227["ctx"]
	J.sp(_t521, "strokeStyle", "#9be8b0")
	var _t522 = _s227["ctx"]
	J.sp(_t522, "lineWidth", 2.2)
	J.mc(_s227["ctx"], "beginPath", [])
	J.mc(v_ps_510, "forEach", [Callable(self, "_f124").bind(_s227)])
	J.mc(_s227["ctx"], "stroke", [])
	J.mc(v_ps_510, "forEach", [Callable(self, "_f125").bind(_s227)])
	var _t535 = _s227["ctx"]
	J.sp(_t535, "fillStyle", "rgba(230,220,255,.7)")
	var _t536 = _s227["ctx"]
	J.sp(_t536, "font", "11px sans-serif")
	var _t537 = ["六天前", "", "", "", "", "昨天", "今天"]
	J.mc(_t537, "forEach", [Callable(self, "_f126").bind(_s227)])

func _f128(this_, a: Array, env):
	var v_k_530 = null; var v_m_531 = null
	v_k_530 = J.arg(a, 0)
	v_m_531 = J.gp(J.G.get("GS_MEALS"), v_k_530)
	var _t545 = ("own" if J.seq(J.gp(env["s"], "meal"), v_k_530) else "")
	var _t546 = J.gp(v_m_531, "name")
	var _t547 = J.gp(v_m_531, "eff")
	var _t548 = J.gp(v_m_531, "say")
	var _t544 = J.gp(env["this"], "ate")
	return ("<div class=\"gs-card " + _t545 + "\"><div class=\"gs-ci\"><b>" + J.str(_t546) + "</b><small class=\"gs-eff\">" + J.str(_t547) + "</small><small>" + J.str(_t548) + "</small></div>\n          <button class=\"btn gold sm gs-eat\" data-k=\"" + J.str(v_k_530) + "\" " + ("disabled" if J.t((_t544 if J.t(_t544) else (not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_m_531, "price")]))))) else "") + ">" + ("吃飽了" if J.t(J.gp(env["this"], "ate")) else ("吃 " + J.str(J.gp(v_m_531, "price")))) + "</button></div>")

func _f127(this_, a: Array, env):
	var _s236 = {"__p": env, "this": null, "s": null}
	_s236["this"] = this_
	_s236["s"] = J.mc(_s236["this"], "st", [])
	var _t550 = ("吃飽了就走！後面還有鬼在排隊！" if J.t(J.gp(_s236["this"], "ate")) else "一次只准點一碗！吃完下一場打架才有力！")
	var _t551 = (("<p class=\"gs-note\">肚子裡：<b>" + J.str(J.gp(J.gp(J.G.get("GS_MEALS"), J.gp(_s236["s"], "meal")), "name")) + "</b>（下一場出征生效，再點會換掉）</p>") if J.t(J.gp(_s236["s"], "meal")) else "")
	var _t543 = J.S_Object_("keys", [J.G.get("GS_MEALS")])
	var _t549 = J.mc(_t543, "map", [Callable(self, "_f128").bind(_s236)])
	return ("<p class=\"gs-line\"><b>餓鬼王</b>" + _t550 + "</p>\n      " + _t551 + "\n      <div class=\"gs-list\">" + J.str(J.mc(_t549, "join", [""])) + "</div>")

func _f131(this_, a: Array, env):
	var v_k_536 = null; var v_m_537 = null
	v_k_536 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_m_537 = J.gp(J.G.get("GS_MEALS"), v_k_536)
	var _t554 = J.gp(env["__p"]["this"], "ate")
	if J.t((_t554 if J.t(_t554) else (not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_m_537, "price")]))))):
		return null
	J.mc(env["__p"]["this"], "spend", [J.gp(v_m_537, "price")])
	var _t555 = J.mc(env["__p"]["this"], "st", [])
	J.sp(_t555, "meal", v_k_536)
	var _t556 = env["__p"]["this"]
	J.sp(_t556, "ate", true)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("Sound"), "play", ["harvest"])
	var _t558 = J.gp(J.gp(env["__p"]["this"], "keepers"), "food")
	var _t557 = J.G.get("pick")
	J.mc(env["__p"]["this"], "say", [_t558, J.cl(_t557, null, [["吃！吃完去打！", "好吃吧？我也想吃……我可以吃一口嗎？", "湯可以續，碗不能拿走！"]]), 2.6])
	J.mc(env["__p"]["this"], "keeperPose", ["food", "cast", 1.2])
	var _t559 = J.gp(env["__p"]["this"], "afu")
	J.sp(_t559, "pose", "cast")
	var _t560 = J.gp(env["__p"]["this"], "afu")
	J.sp(_t560, "poseT", 0.8)
	var _t562 = J.gp(J.gp(env["__p"]["this"], "afu"), "x")
	var _t563 = J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16)
	var _t561 = J.gp(v_m_537, "eff")
	J.mc(env["__p"]["this"], "float", [_t562, _t563, J.mc(_t561, "replace", ["下一場出征：", ""]), "#a8ffcf"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f130(this_, a: Array, env):
	var _s239 = {"__p": env, "b": null}
	_s239["b"] = J.arg(a, 0)
	var _t553 = _s239["b"]
	var _t564 = Callable(self, "_f131").bind(_s239)
	J.sp(_t553, "onclick", _t564)
	return _t564

func _f129(this_, a: Array, env):
	var v_p_534 = null
	var _s238 = {"__p": env, "this": null}
	_s238["this"] = this_
	v_p_534 = J.arg(a, 0)
	var _t552 = J.mc(v_p_534, "querySelectorAll", [".gs-eat"])
	J.mc(_t552, "forEach", [Callable(self, "_f130").bind(_s238)])

func _f133(this_, a: Array, env):
	var v_e_544 = null
	v_e_544 = J.arg(a, 0)
	return (not J.seq(J.gp(v_e_544, "id"), J.gp(env["s"], "alleyLast")))

func _f134(this_, a: Array, env):
	var v_o_545 = null; var v_k_546 = null
	v_o_545 = J.arg(a, 0)
	v_k_546 = J.arg(a, 1)
	var _t572 = ("gold" if J.seq(v_k_546, "a") else "")
	var _t571 = J.gp(v_o_545, "cost")
	return ("<button class=\"btn " + _t572 + " wide gs-al\" data-k=\"" + J.str(v_k_546) + "\" " + ("disabled" if J.t(((not J.t(J.mc(env["this"], "coinsOk", [J.gp(v_o_545, "cost")]))) if J.t(_t571) else _t571)) else "") + ">" + J.str(J.gp(v_o_545, "label")) + (("（" + J.str(J.gp(v_o_545, "cost")) + " 冥幣）") if J.t(J.gp(v_o_545, "cost")) else "") + "</button>")

func _f132(this_, a: Array, env):
	var v_e_540 = null; var v_opt_541 = null; var v_pool_543 = null
	var _s241 = {"__p": env, "this": null}
	_s241["this"] = this_
	if J.t(J.gp(_s241["this"], "alleyDone")):
		return ("<p class=\"gs-line\">" + J.str(J.gp(J.gp(_s241["this"], "alleyDone"), "out")) + "</p><p class=\"gs-note\">" + (J.add("結果：", J.gp(J.gp(_s241["this"], "alleyDone"), "got")) if J.t(J.gp(J.gp(_s241["this"], "alleyDone"), "got")) else "") + "</p><p class=\"gs-note dim\">今晚巷子裡已經沒有別的事了。下次再來看看。</p>")
	if (not J.t(J.gp(_s241["this"], "alleyEv"))):
		var _s242 = {"__p": _s241, "s": null}
		_s242["s"] = J.mc(_s242["__p"]["this"], "st", [])
		v_pool_543 = J.mc(J.G.get("GS_ALLEY"), "filter", [Callable(self, "_f133").bind(_s242)])
		var _t565 = _s242["__p"]["this"]
		var _t566 = (not J.seq(J.typeof_(J.G.get("N30W")), "undefined"))
		var _t567 = (J.mc(J.G.get("N30W"), "alleyEvent", []) if _t566 else _t566)
		var _t568 = (_t567 if J.t(_t567) else J.gp(v_pool_543, floor(J.num((randf() * J.len(v_pool_543))))))
		J.sp(_t565, "alleyEv", _t568)
		var _t569 = _s242["s"]
		var _t570 = J.gp(J.gp(_s242["__p"]["this"], "alleyEv"), "id")
		J.sp(_t569, "alleyLast", _t570)
		J.cl(J.G.get("save"), null, [])
	v_e_540 = J.gp(_s241["this"], "alleyEv")
	v_opt_541 = Callable(self, "_f134").bind(_s241)
	return ("<p class=\"gs-line\">" + J.str(J.gp(v_e_540, "text")) + "</p>" + J.str(J.cl(v_opt_541, null, [J.gp(v_e_540, "a"), "a"])) + J.str(J.cl(v_opt_541, null, [J.gp(v_e_540, "b"), "b"])))

func _f137(this_, a: Array, env):
	var v_o_551 = null; var v_r_552 = null; var v_got_553 = null
	v_o_551 = J.gp(J.gp(env["__p"]["this"], "alleyEv"), J.gp(J.gp(env["b"], "dataset"), "k"))
	var _t575 = J.gp(v_o_551, "cost")
	if J.t(((not J.t(J.mc(env["__p"]["this"], "coinsOk", [J.gp(v_o_551, "cost")]))) if J.t(_t575) else _t575)):
		return null
	if J.t(J.gp(v_o_551, "cost")):
		J.mc(env["__p"]["this"], "spend", [J.gp(v_o_551, "cost")])
	var _t577 = {}
	var _t576 = J.gp(v_o_551, "give")
	v_r_552 = J.S_Object_("assign", [_t577, (_t576 if J.t(_t576) else {})])
	if J.t(J.gp(v_r_552, "troops")):
		var _t578 = J.max_([0.0, J.min_([J.gp(v_r_552, "troops"), J.sub(J.mc(J.G.get("F"), "troopCap", []), J.gp(J.gp(J.G.get("S"), "res"), "troops"))])])
		J.sp(v_r_552, "troops", _t578)
	if J.seq(J.gp(v_r_552, "troops"), 0.0):
		J.del(v_r_552, "troops")
	var _t580 = null
	if J.t(J.len(J.S_Object_("keys", [v_r_552]))):
		var _t579 = J.G.get("give")
		_t580 = J.cl(_t579, null, [v_r_552])
	else:
		_t580 = ""
	v_got_553 = _t580
	if J.t(J.gp(v_o_551, "cost")):
		var _t581 = (("冥幣 −" + J.str(J.gp(v_o_551, "cost"))) + (J.add("，", v_got_553) if J.t(v_got_553) else ""))
		v_got_553 = _t581
	if J.t(J.gp(v_o_551, "join")):
		var _t582 = J.G.get("joinGhost")
		J.cl(_t582, null, [J.gp(v_o_551, "join")])
		var _t583 = J.add(v_got_553, (("，" if J.t(v_got_553) else "") + (J.str(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_o_551, "join")), "name")) + "加入")))
		v_got_553 = _t583
	var _t584 = env["__p"]["this"]
	var _t585 = {"out": J.gp(v_o_551, "out"), "got": v_got_553}
	J.sp(_t584, "alleyDone", _t585)
	J.mc(J.G.get("Sound"), "play", [("chest" if J.t(J.gp(v_r_552, "chest")) else "paper")])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	var _t587 = J.gp(J.gp(env["__p"]["this"], "afu"), "x")
	var _t588 = J.sub(J.gp(J.gp(env["__p"]["this"], "afu"), "y"), 0.16)
	var _t586 = J.gp(J.mc(v_got_553, "split", ["，"]), 0.0)
	J.mc(env["__p"]["this"], "float", [_t587, _t588, (_t586 if J.t(_t586) else "……"), "#e6dcff"])
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f136(this_, a: Array, env):
	var _s246 = {"__p": env, "b": null}
	_s246["b"] = J.arg(a, 0)
	var _t574 = _s246["b"]
	var _t589 = Callable(self, "_f137").bind(_s246)
	J.sp(_t574, "onclick", _t589)
	return _t589

func _f135(this_, a: Array, env):
	var v_p_549 = null
	var _s245 = {"__p": env, "this": null}
	_s245["this"] = this_
	v_p_549 = J.arg(a, 0)
	var _t573 = J.mc(v_p_549, "querySelectorAll", [".gs-al"])
	J.mc(_t573, "forEach", [Callable(self, "_f136").bind(_s245)])
