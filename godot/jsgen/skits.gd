# 自動轉譯自 skits.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Theater"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.G["rwd"] = Callable(self, "_f66").bind(env)
	J.G["SKITS"] = [{"id": "kpi", "title": "地府 KPI 會", "bg": "hq", "need": ["prologue_sys"], "src": "su05 打工人變打工鬼", "cast": [["白無常", "baiwu"], ["阿福", "afu"], ["黑無常", "heiwu"]], "lines": [["白無常", "各位，第三季勾魂 KPI 出咗嚟喇。上頭話，今年要增長兩成。"], ["黑無常", "人唔肯死。", "look"], ["白無常", "所以要搵合作夥伴。今季表現最好嘅，係陽間啲寫字樓——淨係吉隆坡，就幫我哋完成咗三千二百八十四個。"], ["阿福", "……等陣。我就係嗰三千二百八十四個其中一個。", "startle"], ["白無常", "係呀！你係我哋嘅成功案例，張相仲印咗喺季度報告封面。", "wave"], ["阿福", "你哋同我老細，係咪有分成㗎？"], ["黑無常", "佢哋出 OT 紙，我哋出死亡證。"], ["白無常", "下季目標已經定好：鼓勵陽間老細，多啲喺凌晨兩點 send WhatsApp。"], ["阿福", "我收到嗰個，係兩點十三分。"], ["黑無常", "準時。"]]}, {"id": "naicha", "title": "孟婆湯斷貨", "bg": "road", "need": ["ch6_mengpo"], "cast": [["白無常", "baiwu"], ["孟婆", "mengpo"], ["阿福", "afu"]], "lines": [["白無常", "唔得喇唔得喇！奈何橋塞到出返黃泉路喇！", "argue"], ["孟婆", "後生仔，唔關我事。今個月啲湯料冇貨，我老人家冇米點煮呀？", "soup"], ["阿福", "咁啲鬼過橋飲咩？"], ["孟婆", "珍珠奶茶。半糖少冰。"], ["白無常", "問題係，飲完佢哋唔記得前世，淨係記得打卡。個個企喺橋頭影相，影完仲要 post。"], ["孟婆", "今朝有個後生，飲完第一句唔係問「我係邊個」，係問「可唔可以加多份珍珠」。"], ["阿福", "咁都好啫，起碼佢唔記得自己點死。"], ["孟婆", "前世就唔記得，會員卡就記得好清楚。仲叫我幫佢儲印花。"], ["白無常", "飲夠十杯，送一次投胎。", "laugh"]], "choice": {"q": "孟婆遞來一杯珍珠奶茶。", "a": {"label": "喝（半糖）", "lines": [["孟婆", "乖。飲完記得做嘢，唔好淨係記得打卡。", "soup"]], "give": Callable(self, "_f67").bind(env)}, "b": {"label": "不喝，要湯", "lines": [["孟婆", "冇湯，得返個心意。你個心意，老身收咗。"], ["旁白", "孟婆在阿福的會員卡上，蓋了第一個印。"]], "give": Callable(self, "_f68").bind(env)}}}, {"id": "inflation", "form": "news", "title": "陰間新聞台", "need": ["ch1_end"], "lines": [["主播", "陰間新聞台，晚上好。地府銀行今日宣布：冥幣面額後面，再加三個零。"], ["主播", "原因是陽間家屬越燒越大張，最新一張面額一百億，附防偽水印。"], ["主播", "受此影響，一碗雲吞麵今日漲至三千億。記者在現場訪問了一位市民。"], ["主播", "孤寒鬼：「我生前慳咗一世，死咗啲仔女燒咗一百億落嚟。我好感動，攞去買嘢——淨係夠買半碗腸粉。」"], ["主播", "地府銀行呼籲陽間家屬：心意到就好，不必燒那麼大張。"], ["主播", "另外，明日起化寶爐手續費由一成調至一成半。地府銀行強調，這不是加價，是優化。"], ["主播", "以上。"]]}, {"id": "itdown", "title": "生死簿 down 機", "bg": "hq", "need": ["prologue_sys"], "cast": [["牛頭", "niutou"], ["馬面", "mamian"], ["阿福", "afu"]], "lines": [["牛頭", "唔掂喇！生死簿 down 咗！", "startle"], ["馬面", "冷靜。上個月先搬咗上雲端，IT 話好穩陣。"], ["牛頭", "穩陣到而家成個吉隆坡冇人死得！醫院啲醫生個個以為自己變咗神醫！", "argue"], ["阿福", "你哋試過熄咗佢再開未？"], ["馬面", "IT 都係咁講。問題係我哋點熄？我哋本身已經熄咗。"], ["牛頭", "仲有個視窗彈出嚟：「請輸入密碼」。密碼喺上一任 IT 度。"], ["阿福", "咁搵佢囉。"], ["馬面", "佢個名喺生死簿入面。要開到生死簿，先搵到佢。", "look"]], "choice": {"q": "阿福生前是公司的 IT 救火隊。要幫忙嗎？", "a": {"label": "按 Ctrl + Alt + Delete", "lines": [["牛頭", "好喇！上返線喇！", "laugh"], ["馬面", "……等陣。佢 Delete 咗邊個？", "startle"]], "give": Callable(self, "_f69").bind(env)}, "b": {"label": "叫他們等 IT 上班", "lines": [["牛頭", "IT 幾時返？"], ["阿福", "放完假囉。"], ["馬面", "佢放咗三百年假。"]], "give": Callable(self, "_f70").bind(env)}}}, {"id": "queue", "title": "投胎打尖", "bg": "road", "need": ["prologue_sys"], "cast": [["黑無常", "heiwu"], ["遊魂阿強", "youhun"], ["阿福", "afu"]], "lines": [["黑無常", "攞籌。"], ["阿福", "……一百零三萬四千號？", "startle"], ["黑無常", "今日叫到三百號。"], ["遊魂阿強", "兄弟，想快？我有計。投胎快線計劃，月供九十九，保證打尖。", "wave"], ["阿福", "你係咪生前賣保險嗰個阿強？"], ["遊魂阿強", "死咗咪轉行囉。生前賣你未來，死後賣你來世。", "spin"], ["黑無常", "打尖。罰返去尾。", "pose:strike", {"遊魂阿強": "eek"}], ["遊魂阿強", "大佬，我都有份計劃啱你：退休保障——"], ["黑無常", "我唔會退休。"], ["遊魂阿強", "咁……意外保障呢？"], ["黑無常", "我就係意外。"]]}, {"id": "fakephone", "title": "紙紮 iPhone", "bg": "village", "need": ["gift_xiaozhi2", "side_tianhua"], "src": "su16 紙紮店售後服務", "cast": [["天花姐", "tianhua"], ["小紙", "xiaozhi"]], "lines": [["天花姐", "小紙……我屋企人燒咗部 iPhone 落嚟，最新款。哎喲，幫我睇吓點開。", "backrub"], ["小紙", "（攞起嚟睇）天花姐，呢部唔係 iPhone，係 iPhome。"], ["天花姐", "有咩分別？"], ["小紙", "後面三個鏡頭係畫上去嘅。影出嚟，張張都係三個圈。"], ["天花姐", "咁 Face ID 呢？"], ["小紙", "開唔到。佢話認唔到你個樣——因為你個頭係倒轉嘅。"], ["天花姐", "（反轉部電話）……開咗喇！", "startle"], ["小紙", "背面仲有張保用證：「保用一年，遇火即失效。」"], ["天花姐", "佢係燒落嚟㗎喎……"], ["小紙", "係呀。所以燒嗰一刻，已經過咗保。"]]}, {"id": "dating", "title": "牛頭玩 dating app", "bg": "street", "need": ["prologue_sys"], "cast": [["馬面", "mamian"], ["牛頭", "niutou"]], "lines": [["馬面", "牛頭，你唔好再用我張相做 profile pic 喇。"], ["牛頭", "你張相靚啲嘛。"], ["馬面", "嗰張我開咗瘦面，塊面短咗三吋。人哋見到真人，會告我㗎。"], ["牛頭", "嘩！有人 like 咗我！", "startle"], ["馬面", "佢講咩？"], ["牛頭", "佢話佢喺外國做石油工程師，想同我認真發展。不過要先借五千蚊買機票嚟見我。"], ["馬面", "牛頭，你俾人劏豬喇。"], ["牛頭", "我係牛喎。"], ["馬面", "佢哋唔理你係咩。照劏。"]]}, {"id": "review", "title": "黑白無常年度考核", "bg": "village", "need": ["ch6_end"], "cast": [["白無常", "baiwu"], ["黃總", "huang"], ["黑無常", "heiwu"]], "lines": [["黃總", "好，年度考核。白無常先。你嘅問題係笑得太多，客戶以為你推銷。"], ["白無常", "一見生財嘛。", "wave"], ["黃總", "黑無常，你嘅問題係完全唔笑，客戶以為你收數。"], ["黑無常", "我係收命。"], ["黃總", "總括嚟講，兩位都係「符合期望」。加薪：零。"], ["白無常", "黃總，我哋做咗幾千年，從來冇遲過到。"], ["黃總", "就係呢個問題。你哋太準時放工。"], ["黑無常", "勾魂唔準時，就變咗醫生嘅 KPI。"]]}, {"id": "buffet", "title": "餓鬼食評", "bg": "village", "need": ["ch1_end"], "cast": [["撐死鬼", "n30_chengsi"], ["阿福", "afu"], ["餓鬼王", "eguiking"]], "lines": [["撐死鬼", "（打咗個飽嗝）阿福，盂蘭節嗰餐 buffet，我寫咗篇食評。", "n30:burp"], ["阿福", "你當年點死㗎？"], ["撐死鬼", "食 buffet 食死嘅。九十九蚊任食，我食咗三百蚊，賺咗。", "n30:eat"], ["餓鬼王", "我都有寫！環境：陰涼。服務：冇人理。味道：（停一停）……香。", "eat"], ["阿福", "得個香字？"], ["餓鬼王", "我條喉嚨細過針，食唔落，淨係聞得。聞咗五百年，全陰間最專業嘅鼻就係我。", "sniff"], ["撐死鬼", "我畀五粒星。食到我想再死多次。"], ["餓鬼王", "我畀一粒星。因為佢食晒。", "argue"]]}, {"id": "wagroup", "form": "chat", "title": "落魄村街坊群", "group": "孟婆、小紙、天花姐、黑無常、阿福…", "av": ["街", "#5a4a6a"], "need": ["ch6_mengpo", "side_tianhua"], "src": "gh03 安娣鬼群組", "lines": [["孟婆", "07:00|早晨 🌸"], ["孟婆", "07:00|一日之計在於晨，飲碗熱湯身體好"], ["天花姐", "07:02|風油買一送一，要嘅 PM 我"], ["孟婆", "07:15|早晨 🌸"], ["小紙", "07:16|溫馨提示：本群只講村務，唔該大家唔好再 send 早晨圖，多謝合作"], ["孟婆", "07:30|早晨 🌸"], ["阿福", "07:31|孟婆，你今朝 send 咗三次早晨"], ["孟婆", "07:33|咁你覆咗未？"], ["旁白", "小紙 已將 孟婆 移出群組"], ["旁白", "孟婆 已透過邀請連結加入"], ["孟婆", "07:40|早晨 🌸"], ["黑無常", "07:41|天下太平"], ["旁白", "黑無常 已退出群組"], ["旁白", "孟婆 已將群組名稱改為「早晨」"]]}, {"id": "noface", "title": "鬼門關人臉識別", "bg": "road", "need": ["ch1_end"], "cast": [["牛頭", "niutou"], ["無臉鬼", "n30_nopperabo"]], "lines": [["牛頭", "七月鬼門開！出關嘅排好隊，逐個望住部機，人臉識別！"], ["無臉鬼", "唔好意思，部機話「搵唔到面孔」。", "n30:tie"], ["牛頭", "你望正啲啦。"], ["無臉鬼", "我已經望得好正。我冇面。"], ["牛頭", "有冇其他證件？"], ["無臉鬼", "有，公司員工證。"], ["牛頭", "張相呢？"], ["無臉鬼", "都係冇面。HR 話冇所謂，反正開會都冇人望我。", "n30:watch"], ["牛頭", "……你返咗幾耐工？", "look"], ["無臉鬼", "二十年。老細到今日，仲以為我係新嚟嘅。"]]}, {"id": "fees", "title": "冥幣手續費", "bg": "street", "need": ["ch1_end"], "src": "su17 冥幣手續費", "cast": [["阿福", "afu"], ["白無常", "baiwu"]], "lines": [["阿福", "白無常，我媽燒咗一百億落嚟，我想攞。"], ["白無常", "歡迎光臨，一見生財！先扣火化手續費兩成。", "wave"], ["阿福", "……好。"], ["白無常", "跨界轉賬費一成半，陰陽兩界匯率差價三成，再加地府服務稅八個巴仙。"], ["阿福", "咁我仲剩幾多？"], ["白無常", "（撥一撥算盤）仲剩一份心意。"], ["阿福", "心意可以買嘢咩？"], ["白無常", "可以！心意可以換積分。積分下個月到期。", "laugh"]]}, {"id": "typo", "title": "延期申請", "bg": "road", "need": ["prologue_sys"], "cast": [["白無常", "baiwu"], ["阿福", "afu"], ["黑無常", "heiwu"]], "lines": [["白無常", "阿福，講件事你知。你嗰晚，生死簿上面有兩個名：陳大福，同埋陳大富。"], ["阿福", "陳大富係邊個？"], ["白無常", "一個老細，個心臟仲衰過你。"], ["黑無常", "我哋去到，佢喺遊艇飲緊香檳。"], ["白無常", "佢請咗律師，申請延期。有錢人嘅死期，係可以 reschedule 嘅。"], ["阿福", "咁我點解唔可以延期？", "argue"], ["黑無常", "你冇申請。"], ["阿福", "我連有得申請都唔知！"], ["白無常", "張表 send 咗去你個 inbox㗎。"], ["黑無常", "未讀。排喺第三千封。"]]}, {"id": "qingming", "title": "清明到貨", "bg": "village", "need": ["gift_xiaozhi2", "ch1_end"], "cast": [["小紙", "xiaozhi"], ["阿福", "afu"], ["餓鬼王", "eguiking"]], "lines": [["小紙", "少爺！清明到，上面燒落嚟嘅嘢塞爆個倉喇！", "wave"], ["阿福", "有啲咩？"], ["小紙", "一架 Tesla，紙紮嘅，冇得充電。仲有一個 Dyson 風筒，一開就吹走埋自己。"], ["餓鬼王", "有冇食嘅？有冇食嘅？", "sniff"], ["小紙", "有盒鮑魚，都係紙紮嘅。"], ["餓鬼王", "（咬咗一啖）……紙嘅都香。", "eat"], ["小紙", "仲有張 Netflix 年卡，同埋一個 Wi-Fi router。"], ["阿福", "咁都好，起碼有得上網。"], ["小紙", "冇條線。佢哋淨係燒咗個 router。"]], "choice": {"q": "小紙問：兩樣之中，少爺要哪一樣？", "a": {"label": "紙紮鮑魚（分給大家）", "lines": [["餓鬼王", "少爺萬歲！（聞咗成晚）", "sniff"]], "give": Callable(self, "_f71").bind(env)}, "b": {"label": "Netflix 年卡", "lines": [["小紙", "少爺，張卡寫住：「只限一部裝置。」你部手機係紙紮嘅，唔算裝置。"], ["阿福", "……咁攞去化寶爐燒返做冥幣。"]], "give": Callable(self, "_f72").bind(env)}}}, {"id": "grab", "title": "陰間 Grab", "bg": "street", "need": ["side_tianhua"], "cast": [["天花姐", "tianhua"], ["牛頭", "niutou"]], "lines": [["天花姐", "（扶住條腰）司機……我叫咗車半個鐘喇……", "backrub"], ["牛頭", "我到咗！我到咗！"], ["天花姐", "你喺邊？"], ["牛頭", "喺你後面三公里。"], ["天花姐", "咁點叫到咗？"], ["牛頭", "我個心已經到咗。"], ["天花姐", "哎喲……可唔可以畀我瞓喺車頂？我條腰坐唔落。"], ["牛頭", "得！不過車頂另外收錢，再加落雨 surge，車費三倍。"], ["天花姐", "陰間邊度有落雨？"], ["牛頭", "頭先水鬼行過。", "look"]]}, {"id": "subs", "title": "死咗都續費", "bg": "village", "need": ["ch1_end"], "src": "KS 自動續費鬼（前提）", "cast": [["孤寒鬼", "n30_guhangui"], ["遊魂阿強", "youhun"]], "lines": [["孤寒鬼", "（打緊算盤）唔對路。我死咗三年，張信用卡每個月仲有數扣。", "n30:abacus"], ["遊魂阿強", "扣咩？"], ["孤寒鬼", "Netflix、Spotify、雲端相簿，仲有一個我都唔記得係咩嘅 app。"], ["遊魂阿強", "取消咪得囉。"], ["孤寒鬼", "要 OTP。OTP send 去我部電話，部電話同我一齊火化咗。"], ["遊魂阿強", "打去客服啦。"], ["孤寒鬼", "客服話要本人親身去分行。我本人喺山頭，分行話要預約。", "n30:count"], ["遊魂阿強", "咁你點算？要唔要買份保障？", "wave"], ["孤寒鬼", "唔使。我一世人慳到盡，死咗先開始大使。"]]}, {"id": "haze", "title": "陰間空氣指數三百", "bg": "field", "need": ["prologue_sys"], "src": "su11 陰間空氣指數三百", "cast": [["白無常", "baiwu"], ["黑無常", "heiwu"]], "lines": [["白無常", "（咳咳）陽間啲煙霞飄咗落嚟，今日陰間空氣指數三百。"], ["黑無常", "睇唔到人。", "look"], ["白無常", "上頭話能見度太低，今日勾魂暫停。"], ["黑無常", "好。"], ["白無常", "不過我頭先已經勾錯咗兩個。個個戴住口罩，個樣一模一樣。"], ["黑無常", "放返。"], ["白無常", "放唔返。佢哋落到嚟，話唔想返上去——上面仲大煙。"]]}, {"id": "getai", "title": "歌台第一行", "bg": "street", "need": ["ch1_end"], "cast": [["阿福", "afu"], ["餓鬼王", "eguiking"], ["笑死鬼", "n30_xiaosi"]], "lines": [["阿福", "七月歌台，第一行點解冇人坐嘅？"], ["餓鬼王", "留俾我哋㗎！陽間啲人好有禮貌，年年都留第一行。"], ["笑死鬼", "哈哈哈哈！VIP 位呀！", "n30:laugh"], ["阿福", "咁點解你哋個樣咁痛苦？"], ["餓鬼王", "第一行最近個喇叭。佢哋唱到走晒音，我哋又唔走得——坐第一行中途走人，好冇禮貌。"], ["笑死鬼", "哈哈哈，又走音！又走音！", "n30:slap"], ["餓鬼王", "最慘係個主持每晚都多謝我哋：「多謝前排嘅朋友，年年都嚟捧場！」"], ["阿福", "佢睇唔到你哋喎。"], ["餓鬼王", "佢唔使睇到。佢知我哋唔敢走。"]]}, {"id": "scary", "title": "鬼故比賽", "bg": "village", "need": ["side_tianhua", "ch4_end"], "cast": [["水鬼", "shuigui"], ["天花姐", "tianhua"], ["阿福", "afu"]], "lines": [["水鬼", "今晚輪到我講鬼故。有一晚，有個人返到公司……老細同佢講：「今年冇花紅。」"], ["天花姐", "哎喲——好恐怖！", "startle"], ["水鬼", "仲未完。老細再講：「不過，我哋係一家人。」", "shake"], ["天花姐", "到我。有個女人，供樓供咗三十年……銀行打電話嚟：「加息。」"], ["水鬼", "（成身打冷震）……", "shake"], ["阿福", "我講個最恐怖嘅。"], ["天花姐", "講。"], ["阿福", "星期日夜晚十一點，部電話震咗一下。", null, {"水鬼": "eek", "天花姐": "eek"}, "shake"], ["旁白", "兩隻鬼當場嚇得躺平。"]]}, {"id": "hotline", "form": "sys", "title": "系統客服熱線", "need": ["ch1_end"], "pre": true, "lines": [["阿福", "我要投訴。"], ["系統", "叮！歡迎致電陰司 KPI 系統客服熱線～查詢 KPI 請按 1，申請加班請按 2，投訴請按 3。"], ["阿福", "3。"], ["系統", "親，投訴熱線暫時繁忙，您是第九千九百九十九位。等候期間，可以按 2 申請加班哦～"], ["阿福", "我等。"], ["系統", "親，預計等候時間：三百年。為了不浪費您寶貴的時間，系統已自動幫您按了 2。"], ["阿福", "……"], ["系統", "感謝您的來電！您的投訴對我們非常重要，所以我們會好好保存，永遠不處理呢親～"]]}, {"id": "parcel", "title": "11.11 包裹", "bg": "village", "need": ["gift_xiaozhi2"], "cast": [["牛頭", "niutou"], ["小紙", "xiaozhi"]], "lines": [["牛頭", "小紙！你個包裹！"], ["小紙", "多謝牛頭大哥！咦，App 話三日前已經派咗喎。"], ["牛頭", "係呀，我放咗喺你墳頭。"], ["小紙", "我冇墳㗎，我係紙紮嘅。"], ["牛頭", "……咁我放咗喺邊呢？", "look"], ["牛頭", "啊！記得喇，我見到個爐好似信箱，就塞咗入去。"], ["小紙", "嗰個係化寶爐嚟㗎！", "eek"], ["牛頭", "放心，佢會燒返俾你。"], ["小紙", "入面係我買嘅防火噴霧……"], ["牛頭", "咁而家你知佢有冇效喇。"]]}, {"id": "dream", "title": "托夢", "bg": "village", "need": ["gift_phone"], "src": "su01 清明問萬字・su49 我媽直播帶貨", "cast": [["小紙", "xiaozhi"], ["阿福", "afu"]], "lines": [["小紙", "少爺，今晚可以托夢，你可以入夫人個夢同佢講兩句。"], ["阿福", "好。我諗咗好耐要講咩——"], ["旁白", "阿福一走進夢裡，發現媽媽在夢中……也在看直播。"], ["媽", "等陣先，三、二、一，上鏈接！"], ["小紙", "少爺，托夢時間得返一分鐘，你揀一句講。"]], "choice": {"q": "只剩一分鐘。你對媽媽說：", "a": {"label": "「媽，記得食飯。」", "lines": [["旁白", "媽媽停下手，看著鏡頭，很久沒有說話。"], ["媽", "你先係。記得食飯。"]], "give": Callable(self, "_f73").bind(env)}, "b": {"label": "「媽，下期萬字開 0247。」", "lines": [["媽", "好！你阿爸會好開心！"], ["旁白", "第二天早上，阿爸買了一百塊 0247。開彩：7420。"], ["小紙", "少爺，倒轉咗。"]], "give": Callable(self, "_f74").bind(env)}}}, {"id": "luckydraw", "title": "地府年終晚宴", "bg": "hq", "need": ["ch6_end"], "cast": [["黃總", "huang"], ["白無常", "baiwu"], ["阿福", "afu"]], "lines": [["黃總", "各位同事！年終晚宴，lucky draw 時間！"], ["黃總", "三獎：有薪假一日。得主係……系統！"], ["白無常", "系統放唔到假喎。"], ["黃總", "所以話係心意。二獎：投胎優先證。得主……我外母。", "golf"], ["阿福", "你外母都喺下面？"], ["黃總", "佢喺上面。佢係贊助人。"], ["白無常", "咁頭獎呢？"], ["黃總", "頭獎由我自己抽中，呢個叫 synergy。最後，所有冇抽中嘅同事都有份紀念品——", "wave"], ["黃總", "明年嘅 KPI。"]]}, {"id": "hiring", "title": "河底招聘", "bg": "field", "need": ["ch4_end"], "cast": [["水鬼", "shuigui"], ["阿福", "afu"]], "lines": [["水鬼", "阿福，幫我睇吓份招聘廣告。三年都冇鬼 apply。", "shake"], ["阿福", "（讀出嚟）「誠聘河底巡邏員，限鬼。包食包住，永久合約，廿四小時候命。」"], ["水鬼", "條件好好喎。"], ["阿福", "你寫「廿四小時候命」，冇鬼敢嚟。"], ["水鬼", "咁點寫？"], ["阿福", "寫「work-life balance」、「彈性上班」、「年輕有活力嘅團隊」。"], ["旁白", "水鬼照著改了。第二天早上，收到三百份 CV。"], ["水鬼", "全部都係過勞死嘅……佢哋話，揀河底係因為部電話收唔到訊號。"]]}, {"id": "smile", "title": "黑無常學笑", "bg": "village", "need": ["gift_xiaozhi2"], "cast": [["白無常", "baiwu"], ["黑無常", "heiwu"], ["小紙", "xiaozhi"]], "lines": [["白無常", "師弟，上頭做咗客戶滿意度調查。你嘅分數：零點三。"], ["黑無常", "滿分呢？"], ["白無常", "十分。客戶話你太嚴肅，要多啲笑容。嚟，跟住我笑：一見——生財！", "wave"], ["黑無常", "……"], ["白無常", "嘴角向上。"], ["旁白", "黑無常慢慢咧開了嘴。"], ["小紙", "少爺——救命呀——！", "eek", null, "flash"], ["白無常", "好啲喇！以前啲客係悶死，而家起碼係嚇死。", "laugh"], ["黑無常", "天下太平。"]]}, {"id": "debt", "title": "討債鬼上門", "bg": "village", "need": ["ch1_end"], "cast": [["討債鬼", "n30_taozhai"], ["阿福", "afu"]], "lines": [["討債鬼", "陳大福！還錢！你張信用卡欠四千二！", "n30:knock"], ["阿福", "我死咗喇。"], ["討債鬼", "死咗都要還。利息照計，日日複息。", "n30:shake"], ["阿福", "我冇錢。"], ["討債鬼", "冇問題，我哋有分期：分一千年，月供一蚊。"], ["阿福", "……咁又幾抵。"], ["討債鬼", "仲有，你個 PTPTN。"], ["阿福", "我死咗都仲未還完？", "startle"], ["討債鬼", "PTPTN 係世上唯一一樣嘢，長命過我哋鬼。"]]}, {"id": "gambler", "title": "買字", "bg": "village", "need": ["ch1_end"], "cast": [["賭鬼", "n30_dugui"], ["阿福", "afu"]], "lines": [["賭鬼", "阿福！你死咗冇耐，同上面仲有感應。報個字嚟！", "n30:shuffle"], ["阿福", "我生前連自己幾時死都唔知，點知開咩字？"], ["賭鬼", "咁你幾點死㗎？"], ["阿福", "兩點四十七分。"], ["賭鬼", "0247！今鋪一定翻本！", "n30:dice"]], "choice": {"q": "賭鬼邀你合資買 0247。", "a": {"label": "合資", "lines": [["旁白", "開彩：7420。"], ["賭鬼", "又差少少！我呢世人，次次都係差少少！", "n30:shuffle"], ["阿福", "你呢世人已經完咗喇。"], ["賭鬼", "所以下世一定翻本！"]], "give": Callable(self, "_f75").bind(env)}, "b": {"label": "不合資", "lines": [["賭鬼", "你唔夾，咁你就錯過咗成個人生！"], ["阿福", "我冇人生喇。"], ["賭鬼", "……咁你錯過咗成個死後。"]], "give": Callable(self, "_f76").bind(env)}}}, {"id": "hotdesk", "title": "Hot desking", "bg": "hq", "need": ["ch3_end", "side_tianhua"], "cast": [["白無常", "baiwu"], ["老殭", "laojiang"], ["天花姐", "tianhua"]], "lines": [["白無常", "通告！地府集團實行 hot desking，以後冇固定座位，先到先得！"], ["老殭", "本官膝頭唔識彎，從來都冇座位。"], ["天花姐", "哎喲……我個位係天花板，冇人同我爭。", "backrub"], ["白無常", "天花板都要預約。（睇一睇平板）天花板 A 區，已經畀牛頭訂咗。"], ["天花姐", "佢上唔到去㗎！"], ["白無常", "佢訂嚟放雜物。"], ["老殭", "那本官呢？"], ["白無常", "大人你企喺度，即係 standing desk。全公司最健康嘅員工。", "laugh"]]}, {"id": "fengshui", "title": "陳總嘅風水位", "bg": "office", "need": ["ch1_end"], "cast": [["阿福", "afu"], ["小紙", "xiaozhi"], ["陳總", "npc_boss"]], "lines": [["旁白", "回陽間值夜班之前，阿福和小紙在二十三樓等人下班。陳總還沒走。"], ["陳總", "Master Lee 話呢層陰氣重，叫我多擺三個水晶球。"], ["阿福", "（細細聲）佢睇唔到我哋。"], ["小紙", "少爺，佢將個水晶球擺咗喺你以前個位。"], ["陳總", "Master Lee 仲話，以前有個員工喺呢度過咗身，佢個位風水最好——旺老細。"], ["阿福", "……我個位旺佢？", "startle"], ["陳總", "由聽日開始，我坐呢個位。不過張櫈要換，坐過死人嘅櫈，唔吉利。"], ["小紙", "少爺，佢要你嘅運，唔要你張櫈。"]]}, {"id": "radio", "form": "radio", "title": "午夜怪談熱線 FM 4.44", "need": ["ch5_end", "ch3_end"], "lines": [["DJ", "午夜怪談熱線 FM 4.44。今晚個題目：「你最近有咩煩惱？」第一位聽眾。"], ["Penanggal", "DJ，我個頭夜晚出去巡村，返到屋企，發現個身俾人移咗位。"], ["DJ", "有冇報警？"], ["Penanggal", "有。警察叫我出示身份證。張身份證喺個身度。"], ["DJ", "明白。下一位。"], ["老殭", "本官想問，世上有冇一種床，企住都瞓得著？"], ["DJ", "有，叫 LRT 繁忙時間。最後一位。"], ["阿福", "DJ，我死咗之後終於唔使返工，但係我瞓唔著。"], ["DJ", "點解？"], ["阿福", "我習慣咗每晚兩點四十七分醒一醒，睇吓老細有冇 WhatsApp。"], ["DJ", "……下一首歌，送俾陳先生。祝你早日失憶。"]]}, {"id": "hrmail", "form": "mail", "title": "收件匣", "need": ["ch6_intro"], "pre": true, "lines": [["寄件人", "地府集團人力資源部"], ["主旨", "七月出差安排（請勿回覆）"], ["內文", "各位同事：鬼門開放期間，全體員工須返回陽間出差三十日。交通津貼：零。膳食：自行尋找供奉。如家屬沒有燒東西，屬個人問題，公司概不負責。"], ["內文", "另外，今年起出差也須打卡。打卡機設於陽間各大十字路口，遲到三次視為自動離職，下輩子再見。"], ["附件", "七月 KPI.xlsx（三百 MB）"]]}, {"id": "insure", "title": "保障你條釘", "bg": "banana", "need": ["ch4_end"], "cast": [["遊魂阿強", "youhun"], ["Pontianak", "pontianak"]], "lines": [["遊魂阿強", "Pontianak 小姐，你一百年冇買過保險，好危險㗎！", "wave"], ["Pontianak", "嘻——我已經死咗喇，sayang。", "hair"], ["遊魂阿強", "所以先要買嘛，鬼壽保險！保你後頸枝釘。萬一甩咗，全數賠償，仲包上門釘返。"], ["Pontianak", "邊個上門？"], ["遊魂阿強", "我囉。"], ["Pontianak", "上一個話會嚟嘅男人，我等咗佢成晚。"], ["遊魂阿強", "放心！我寫明喺條款入面：上門時間，七至十四個工作天。"], ["Pontianak", "Alamak……你同佢一樣。", "hair"]]}, {"id": "jianshi_mrt", "title": "殭屍拍卡", "bg": "road", "need": ["ch3_end"], "src": "gh02 殭屍不能彎腰（前提）", "cast": [["殭屍兵", "zombie"], ["老殭", "laojiang"], ["馬面", "mamian"]], "lines": [["馬面", "（擋住閘口）兩位大人，過關要拍卡。"], ["老殭", "本官張卡在此。"], ["馬面", "拍卡位喺腰咁低，你要彎低身。"], ["殭屍兵", "……"], ["老殭", "本官與部下，膝頭腰骨，皆是直的。"], ["馬面", "咁你哋點樣過咗兩百年關？"], ["老殭", "跳過去。"], ["馬面", "我守咗咁多年閘口，第一次見有人逃票逃得咁理直氣壯。", "look"]]}, {"id": "attendance", "title": "全勤獎", "bg": "village", "need": ["ch2_end"], "src": "su36 我還在上班", "cast": [["阿福", "afu"], ["冼小姐", "npc_hr", {"base": "ag:clip", "talk": "ag:glasses"}]], "lines": [["冼小姐", "親愛嘅同事～好消息！陽間公司嘅 HR 系統同我哋對接咗。你上個月：全勤。"], ["阿福", "我死咗喎。"], ["冼小姐", "打卡機每朝八點五十九分都認到你個樣，仲同你講「早晨」。"], ["阿福", "可能我個樣同死之前冇分別：一樣白，一樣攰，一樣冇表情。"], ["冼小姐", "年底仲有全勤獎。老細喺台上講：「大家要向佢學習。」台下同事全部低晒頭。"], ["阿福", "咁人工呢？"], ["冼小姐", "你死咗第二日已經停咗。成間公司，得呢個部門效率最高。", "ag:stamp"], ["冼小姐", "系統仲幫你打咗今年績效：「符合期望」。"], ["阿福", "我生前拼死拼活，係「有待改進」。"], ["冼小姐", "所以你而家先係公司最理想嘅員工：準時出現，唔出聲，唔使出糧。"]]}, {"id": "ppt", "title": "年度報告 PPT", "bg": "village", "need": ["ch6_end"], "src": "su48 我的告別式 PPT", "cast": [["小紙", "xiaozhi"], ["阿福", "afu"], ["黃總", "huang"]], "lines": [["黃總", "阿福，幫我整份落魄村年度報告 PPT。用公司模板，第一頁標題：「回顧與展望」。"], ["阿福", "……我喪禮嗰份 PPT，都係用呢個模板。"], ["黃總", "係咪好有效果？"], ["阿福", "第三頁有個圖表，我每年 OT 時數，條線一路向上，最後一年斷咗。同事解釋：「呢條係佢嘅成長曲線。」台下有人抄筆記。"], ["小紙", "少爺，第四頁「主要成就」寫咩？"], ["阿福", "從不遲到，從不拒絕加班，喺會議上堅持到最後一刻。"], ["黃總", "好！今次照抄！第五頁「經驗教訓」呢？", "golf"], ["阿福", "上次留空：「呢一頁，留俾大家自己諗。」全場同事第一次真係喺度諗。"], ["黃總", "今次都留空，慳時間。最後一頁 Q&A。"], ["小紙", "少爺，上次 Q&A 有冇人問嘢？"], ["阿福", "有。我表姐舉手：「佢架車而家邊個揸緊？」"], ["黃總", "（認真咁記低）好問題。架車而家邊個揸緊？"]]}, {"id": "annual", "form": "sys", "title": "打工鬼年度報告", "need": ["ch1_end"], "pre": true, "src": "su28 打工人年度報告", "lines": [["系統", "叮！親的《打工鬼年度報告》已生成～"], ["系統", "本年度，親共回覆「收到」三千一百九十次。最後一次，未送達。"], ["阿福", "……因為嗰陣我已經走咗。"], ["系統", "親的加班時數，打敗了全公司 99% 的同事！"], ["阿福", "剩低嗰 1% 係邊個？"], ["系統", "是老闆養的魚呢親。牠也從沒下過班。"], ["系統", "年度關鍵字：「好」。年度歌曲：鍵盤聲。年度最長相處對象：會議室的冷氣。"], ["阿福", "可唔可以唔分享？"], ["系統", "已自動分享至全地府，獲得一則留言：「同款。」"]]}, {"id": "saturday", "form": "sys", "title": "系統：今日星期六", "need": ["ch6_reboot"], "lines": [["系統", "叮。陰司好好系統提醒你：今天是星期六。"], ["阿福", "咁又點？"], ["系統", "意思是你可以不用做事呀，親。"], ["阿福", "……我可以去砍兩棵樹先嗎？"], ["系統", "為什麼？"], ["阿福", "唔做嘢，我好驚。"], ["系統", "親，這叫工傷。陰司好好系統已幫你預約：天花姐，按摩，三點。"], ["阿福", "佢條腰仲衰過我。"], ["系統", "所以她最明白你呀，親。"]]}]
	J.G["Skits"] = J.cl(Callable(self, "_f77").bind(env), null, [])
	J.mc(J.G.get("Skits"), "init", [])

func _f2(this_, a: Array, env):
	var v_s_57 = null
	if J.t(J.S_document_("getElementById", ["th-css"])):
		return null
	v_s_57 = J.S_document_("createElement", ["style"])
	J.sp(v_s_57, "id", "th-css")
	var _t1 = ("\n#gtheater{position:absolute;inset:0;z-index:55;display:none;background:#0c0a12;overflow:hidden;touch-action:manipulation}\n#gtheater.on{display:block;animation:thIn .35s ease-out}\n@keyframes thIn{from{opacity:0}to{opacity:1}}\n#gtheater canvas{position:absolute;inset:0;width:100%;height:100%}\n#gtheater .th-top{position:absolute;left:0;right:0;top:0;display:flex;align-items:center;gap:8px;padding:calc(env(safe-area-inset-top) + 10px) 12px 10px;background:linear-gradient(rgba(12,10,18,.92),rgba(12,10,18,0));z-index:3}\n#gtheater .th-tag{flex:none;font-family:var(--serif);font-size:13px;font-weight:900;color:#fbe6d6;background:var(--cinnabar);padding:3px 7px;border-radius:2px;letter-spacing:1px}\n#gtheater .th-title{flex:1;font-family:var(--serif);font-size:19px;font-weight:900;color:#f3d68a;letter-spacing:1px;text-shadow:0 2px 0 #000;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}\n#gtheater .th-skip{flex:none;background:rgba(0,0,0,.5);box-shadow:inset 0 0 0 1px rgba(255,255,255,.35);border-radius:3px;padding:7px 13px;font-size:14px;color:#eee}\n#gtheater .th-bub{position:absolute;z-index:4;max-width:min(88vw,380px);padding:10px 14px 12px;background:#f6ecd2;color:#2a1a10;border-radius:14px;box-shadow:0 0 0 2px #3a2a1a,0 6px 16px rgba(0,0,0,.55);font-size:19px;line-height:1.5;font-weight:700;display:none}\n#gtheater .th-bub.on{display:block;animation:thPop .18s ease-out}\n@keyframes thPop{from{transform:scale(.9);opacity:.3}to{transform:none;opacity:1}}\n#gtheater .th-bub::after{content:\"\";position:absolute;left:var(--tx,50%);bottom:-11px;margin-left:-9px;border:9px solid transparent;border-top:12px solid #f6ecd2;border-bottom:0;filter:drop-shadow(0 2px 0 #3a2a1a)}\n#gtheater .th-bub.up::after{bottom:auto;top:-11px;border-top:0;border-bottom:12px solid #f6ecd2;filter:drop-shadow(0 -2px 0 #3a2a1a)}\n#gtheater .th-bub.sys{background:#0e2a2a;color:#c8fff0;box-shadow:0 0 0 2px #5fbfaa,0 0 18px rgba(95,191,170,.45)}\n#gtheater .th-bub.sys::after{display:none}\n#gtheater .th-bub.aud{font-size:17px;background:#e6dcff;box-shadow:0 0 0 2px #3a2a5a,0 6px 16px rgba(0,0,0,.55)}\n#gtheater .th-bub.aud::after{border-top-color:#e6dcff}\n#gtheater .th-nm{display:block;font-family:var(--serif);font-size:14px;font-weight:900;color:var(--cinnabar);margin-bottom:2px;letter-spacing:1px}\n#gtheater .th-bub.sys .th-nm{color:#7fffd4}\n#gtheater .th-cap{position:absolute;left:16px;right:16px;top:calc(env(safe-area-inset-top) + 58px);z-index:4;text-align:center;font-family:var(--serif);font-size:18px;line-height:1.55;color:#efe6ff;background:rgba(12,8,20,.78);border-radius:6px;padding:10px 14px;box-shadow:inset 0 0 0 1px rgba(200,180,255,.25);display:none}\n#gtheater .th-cap.on{display:block}\n#gtheater .th-choice{position:absolute;left:16px;right:16px;bottom:calc(env(safe-area-inset-bottom) + 18px);z-index:5;display:none;flex-direction:column;gap:10px}\n#gtheater .th-choice.on{display:flex}\n#gtheater .th-choice .btn{font-size:17px;padding:13px}\n#gtheater .th-tap{position:absolute;left:0;right:0;bottom:calc(env(safe-area-inset-bottom) + 10px);z-index:3;text-align:center;font-size:13px;color:rgba(255,255,255,.5);pointer-events:none}\n#su-pick{position:absolute;inset:0;z-index:56;display:none;flex-direction:column;background:rgba(10,8,14,.94)}\n#su-pick.on{display:flex}\n#su-pick .sp-h{display:flex;align-items:center;gap:10px;padding:calc(env(safe-area-inset-top) + 12px) 14px 10px;border-bottom:1px solid #3a2f2a}\n#su-pick .sp-h b{flex:1;font-family:var(--serif);font-size:22px;color:#f3d68a;letter-spacing:2px}\n#su-pick .sp-sub{padding:8px 16px 0;font-size:14.5px;color:#cbbfd8;line-height:1.5}\n#su-pick .sp-list{flex:1;overflow:auto;padding:8px 12px calc(env(safe-area-inset-bottom) + 16px)}\n#su-pick .sp-it{display:flex;align-items:center;gap:12px;width:100%;text-align:left;margin:8px 0;padding:10px 12px;border-radius:8px;background:#221d28;box-shadow:inset 0 0 0 1px #4a3a5a}\n#su-pick .sp-it canvas{flex:none;width:56px;height:56px;border-radius:50%;background:rgba(255,240,210,.12)}\n#su-pick .sp-it span{flex:1;min-width:0}\n#su-pick .sp-it b{display:block;font-family:var(--serif);font-size:18px;color:#f6e2b0}\n#su-pick .sp-it small{display:block;font-size:13.5px;color:#a99fb4;margin-top:2px}\n#su-pick .sp-it em{flex:none;font-style:normal;font-size:12px;font-weight:900;color:#fff3e0;background:var(--cinnabar);padding:2px 7px;border-radius:2px}\n#su-pick .sp-it.off{opacity:.45}\n#gs-panel .su-wide{margin:10px 0 2px;padding:10px;font-size:16px}\n")
	J.sp(v_s_57, "textContent", _t1)
	var _t2 = J.gp(J.G.get("document"), "head")
	J.mc(_t2, "appendChild", [v_s_57])

func _f4(this_, a: Array, env):
	var v_e_60 = null
	v_e_60 = J.arg(a, 0)
	var _t13 = J.gp(v_e_60, "target")
	if J.t(J.mc(_t13, "closest", [".th-skip"])):
		J.mc(v_e_60, "stopPropagation", [])
		var _t14 = env["close"]
		J.cl(_t14, null, [true])
		return null
	var _t15 = J.gp(v_e_60, "target")
	if J.t(J.mc(_t15, "closest", [".th-choice"])):
		return null
	J.cl(env["tap"], null, [])

func _f3(this_, a: Array, env):
	J.cl(env["css"], null, [])
	var _t3 = J.S_document_("getElementById", ["gtheater"])
	env["el"] = _t3
	if (not J.t(env["el"])):
		var _t4 = J.S_document_("createElement", ["section"])
		env["el"] = _t4
		var _t5 = env["el"]
		J.sp(_t5, "id", "gtheater")
		var _t6 = J.S_document_("getElementById", ["app"])
		var _t7 = (_t6 if J.t(_t6) else J.gp(J.G.get("document"), "body"))
		J.mc(_t7, "appendChild", [env["el"]])
	var _t8 = env["el"]
	var _t9 = ("<canvas></canvas><div class=\"th-top\"><span class=\"th-tag\"></span><b class=\"th-title\"></b><button class=\"th-skip\">跳過 ▸▸</button></div>\n      <div class=\"th-cap\"></div><div class=\"th-bub\"><b class=\"th-nm\"></b><span class=\"th-tx\"></span></div><div class=\"th-choice\"></div><div class=\"th-tap\"></div>")
	J.sp(_t8, "innerHTML", _t9)
	var _t10 = J.mc(env["el"], "querySelector", ["canvas"])
	env["cv"] = _t10
	var _t11 = J.mc(env["cv"], "getContext", ["2d"])
	env["ctx"] = _t11
	var _t12 = env["el"]
	var _t16 = Callable(self, "_f4").bind(env)
	J.sp(_t12, "onclick", _t16)

func _f5(this_, a: Array, env):
	var v_r_63 = null
	v_r_63 = J.mc(env["el"], "getBoundingClientRect", [])
	var _t17 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t18 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t19 = J.min_([2.0, (_t18 if J.t(_t18) else 1.0)])
	env["dpr"] = _t19
	var _t20 = J.gp(v_r_63, "width")
	var _t21 = (_t20 if J.t(_t20) else 390.0)
	env["W"] = _t21
	var _t22 = J.gp(v_r_63, "height")
	var _t23 = (_t22 if J.t(_t22) else 700.0)
	env["H"] = _t23
	var _t24 = env["cv"]
	var _t25 = J.mul(env["W"], env["dpr"])
	J.sp(_t24, "width", _t25)
	var _t26 = env["cv"]
	var _t27 = J.mul(env["H"], env["dpr"])
	J.sp(_t26, "height", _t27)

func _f8(this_, a: Array, env):
	var v_k_67 = null
	v_k_67 = J.arg(a, 0)
	var _t29 = null
	if J.seq(J.typeof_(J.G.get("sprOk")), "function"):
		var _t28 = J.G.get("sprOk")
		_t29 = J.cl(_t28, null, [v_k_67])
	else:
		_t29 = true
	return _t29

func _f9(this_, a: Array, env):
	var v_name_70 = null; var v_k_71 = null; var v_i_72 = null; var v_x_73 = null
	v_name_70 = J.arg(a, 0)
	v_k_71 = J.arg(a, 1)
	v_i_72 = J.arg(a, 2)
	v_x_73 = J.arg(a, 3)
	return {"name": v_name_70, "k": v_k_71, "id": J.add((J.add("th", v_i_72) + "_"), v_k_71), "px": v_x_73, "tx": v_x_73, "home": v_x_73, "face": true, "want": true, "turnT": 9.0, "w": 0.0, "wph": (randf() * 9.0), "hp": (-1.0), "seed": (randf() * 50.0), "act": null, "at": 0.0, "pl": {}, "style": {}, "eatT": 0.0, "icon": null, "iconT": 9.0, "one": 0.0, "base": null, "spk": false, "pose": null, "pt": 0.0, "sc": 1.0, "alpha": 1.0, "aud": false}

func _f10(this_, a: Array, env):
	var v_a_76 = null; var v_k_77 = null; var v_key_78 = null; var v_key_79 = null
	v_a_76 = J.arg(a, 0)
	v_k_77 = J.arg(a, 1)
	if (not J.t(v_a_76)):
		return null
	if J.seq(J.mc(v_a_76, "indexOf", ["n30:"]), 0.0):
		v_key_78 = J.add((J.add("n30_", J.mc(v_k_77, "slice", [4.0])) + "_"), J.mc(v_a_76, "slice", [4.0]))
		var _t30 = (not J.seq(J.typeof_(J.G.get("DAILY")), "undefined"))
		return (v_key_78 if J.t((J.gp(J.G.get("DAILY"), v_key_78) if _t30 else _t30)) else "plaza_talk")
	if J.seq(J.mc(v_a_76, "indexOf", ["pose:"]), 0.0):
		return v_a_76
	if J.seq(J.mc(v_a_76, "indexOf", ["ag:"]), 0.0):
		v_key_79 = J.add("ag_", J.mc(v_a_76, "slice", [3.0]))
		var _t31 = (not J.seq(J.typeof_(J.G.get("DAILY")), "undefined"))
		return (v_key_79 if J.t((J.gp(J.G.get("DAILY"), v_key_79) if _t31 else _t31)) else "plaza_talk")
	return J.add("plaza_", v_a_76)

func _f11(this_, a: Array, env):
	var v_k_82 = null; var v_st_83 = null; var v_e_84 = null
	v_k_82 = J.arg(a, 0)
	v_st_83 = J.arg(a, 1)
	var _t32 = J.mc(J.G.get("Antag"), "dur", [v_k_82, v_st_83])
	return (_t32 if J.t(_t32) else 2.0)

func _f12(this_, a: Array, env):
	var v_key_87 = null; var v_id_88 = null; var v_r_89 = null; var v_e_90 = null
	v_key_87 = J.arg(a, 0)
	for _t33 in J.keys(J.gp(J.G.get("N30D"), "ACTS")):
		v_id_88 = _t33
		for _t34 in J.iter(J.gp(J.gp(J.G.get("N30D"), "ACTS"), v_id_88)):
			v_r_89 = _t34
			if J.seq(J.gp(v_r_89, 0.0), v_key_87):
				return J.gp(v_r_89, 2.0)
	return 2.4

func _f13(this_, a: Array, env):
	var v_a_93 = null; var v_act_94 = null; var v_hold_95 = null; var v_key_96 = null; var v_nm_97 = null
	v_a_93 = J.arg(a, 0)
	v_act_94 = J.arg(a, 1)
	v_hold_95 = J.arg(a, 2)
	var _t35 = env["actKey"]
	v_key_96 = J.cl(_t35, null, [v_act_94, J.gp(v_a_93, "k")])
	if (not J.t(v_key_96)):
		var _t36 = ("plaza_talk" if J.t(J.gp(v_a_93, "spk")) else null)
		J.sp(v_a_93, "act", _t36)
		J.sp(v_a_93, "pose", null)
		return null
	J.sp(v_a_93, "at", 0.0)
	J.sp(v_a_93, "pose", null)
	if J.seq(J.mc(v_key_96, "indexOf", ["pose:"]), 0.0):
		var _t37 = J.mc(v_key_96, "slice", [5.0])
		J.sp(v_a_93, "pose", _t37)
		J.sp(v_a_93, "act", null)
		J.sp(v_a_93, "one", 1.2)
		J.sp(v_a_93, "pt", 0.0)
		return null
	v_nm_97 = J.mc(v_key_96, "replace", ["plaza_", ""])
	J.sp(v_a_93, "act", v_key_96)
	var _t38 = (v_hold_95 if J.t(v_hold_95) else J.gp(env["ONE"], v_nm_97))
	var _t39 = {"d": (_t38 if J.t(_t38) else 6.0), "spk": J.gp(v_a_93, "spk"), "deep": 0.7}
	J.sp(v_a_93, "pl", _t39)
	var _t44 = null
	if J.t(J.gp(env["ONE"], v_nm_97)):
		_t44 = J.gp(env["ONE"], v_nm_97)
	else:
		var _t43 = null
		if J.seq(J.mc(v_key_96, "indexOf", ["n30_"]), 0.0):
			var _t40 = env["n30Dur"]
			_t43 = J.mul(J.cl(_t40, null, [v_key_96]), (99.0 if J.t(v_hold_95) else 1.5))
		else:
			var _t42 = null
			if J.seq(J.mc(v_key_96, "indexOf", ["ag_"]), 0.0):
				var _t41 = env["agDur"]
				_t42 = J.mul(J.cl(_t41, null, [J.gp(v_a_93, "k"), J.mc(v_key_96, "slice", [3.0])]), (99.0 if J.t(v_hold_95) else 1.2))
			else:
				_t42 = 0.0
			_t43 = _t42
		_t44 = _t43
	J.sp(v_a_93, "one", _t44)

func _f14(this_, a: Array, env):
	var v_a_100 = null
	v_a_100 = J.arg(a, 0)
	J.sp(v_a_100, "pose", null)
	var _t49 = null
	if J.t(J.gp(v_a_100, "spk")):
		var _t46 = null
		if J.t(J.gp(v_a_100, "talk")):
			var _t45 = env["actKey"]
			_t46 = J.cl(_t45, null, [J.gp(v_a_100, "talk"), J.gp(v_a_100, "k")])
		else:
			_t46 = "plaza_talk"
		_t49 = _t46
	else:
		var _t48 = null
		if J.t(J.gp(v_a_100, "base")):
			var _t47 = env["actKey"]
			_t48 = J.cl(_t47, null, [J.gp(v_a_100, "base"), J.gp(v_a_100, "k")])
		else:
			_t48 = null
		_t49 = _t48
	J.sp(v_a_100, "act", _t49)
	var _t50 = {"d": 99.0, "spk": J.gp(v_a_100, "spk")}
	J.sp(v_a_100, "pl", _t50)
	J.sp(v_a_100, "at", 0.0)
	J.sp(v_a_100, "one", 0.0)

func _f15(this_, a: Array, env):
	var v_a_103 = null; var v_dt_104 = null; var v_dx_105 = null; var v_sp_106 = null
	v_a_103 = J.arg(a, 0)
	v_dt_104 = J.arg(a, 1)
	var _t51 = J.add(J.gp(v_a_103, "at"), v_dt_104)
	J.sp(v_a_103, "at", _t51)
	var _t52 = J.add(J.gp(v_a_103, "iconT"), v_dt_104)
	J.sp(v_a_103, "iconT", _t52)
	var _t53 = J.seq(J.gp(v_a_103, "act"), "plaza_eat")
	if J.t((_t53 if _t53 else J.gp(J.gp(v_a_103, "style"), "eat"))):
		var _t54 = J.add(J.gp(v_a_103, "eatT"), v_dt_104)
		J.sp(v_a_103, "eatT", _t54)
	v_dx_105 = J.sub(J.gp(v_a_103, "tx"), J.gp(v_a_103, "px"))
	v_sp_106 = J.mul(env["W"], 0.42)
	if (absf(J.num(v_dx_105)) > 1.5):
		var _t55 = J.add(J.gp(v_a_103, "px"), (signf(J.num(v_dx_105)) * J.min_([absf(J.num(v_dx_105)), J.mul(v_sp_106, v_dt_104)])))
		J.sp(v_a_103, "px", _t55)
		var _t56 = J.min_([1.0, J.add(J.gp(v_a_103, "w"), J.mul(v_dt_104, 6.0))])
		J.sp(v_a_103, "w", _t56)
		var _t57 = J.add(J.gp(v_a_103, "wph"), J.mul(v_dt_104, 1.7))
		J.sp(v_a_103, "wph", _t57)
		var _t58 = J.cmp(v_dx_105, 0.0, ">")
		J.sp(v_a_103, "want", _t58)
		var _t59 = J.seq(J.gp(v_a_103, "k"), "laojiang")
		if (_t59 if _t59 else J.seq(J.gp(v_a_103, "k"), "zombie")):
			var _t60 = (0.0 if J.cmp(J.gp(v_a_103, "hp"), 0.0, "<") else J.mod(J.add(J.gp(v_a_103, "hp"), J.div(v_dt_104, 0.5)), 1.0))
			J.sp(v_a_103, "hp", _t60)
	else:
		var _t61 = J.max_([0.0, J.sub(J.gp(v_a_103, "w"), J.mul(v_dt_104, 5.0))])
		J.sp(v_a_103, "w", _t61)
		var _t63 = J.cmp(J.gp(v_a_103, "hp"), 0.0, ">=")
		if J.t(_t63):
			var _t62 = J.seq(J.gp(v_a_103, "k"), "laojiang")
			_t63 = (_t62 if _t62 else J.seq(J.gp(v_a_103, "k"), "zombie"))
		if _t63:
			var _t64 = J.add(J.gp(v_a_103, "hp"), J.div(v_dt_104, 0.5))
			J.sp(v_a_103, "hp", _t64)
			if J.cmp(J.gp(v_a_103, "hp"), 1.0, ">="):
				var _t65 = (-1.0)
				J.sp(v_a_103, "hp", _t65)
	if J.t(J.gp(v_a_103, "pose")):
		var _t66 = J.min_([1.0, J.add(J.gp(v_a_103, "pt"), J.mul(v_dt_104, 1.4))])
		J.sp(v_a_103, "pt", _t66)
	if J.cmp(J.gp(v_a_103, "one"), 0.0, ">"):
		var _t67 = J.sub(J.gp(v_a_103, "one"), v_dt_104)
		J.sp(v_a_103, "one", _t67)
		if J.cmp(J.gp(v_a_103, "one"), 0.0, "<="):
			var _t68 = env["settle"]
			J.cl(_t68, null, [v_a_103])
	var _t69 = (not J.seq(J.gp(v_a_103, "want"), J.gp(v_a_103, "face")))
	if (J.cmp(J.gp(v_a_103, "turnT"), 0.22, ">=") if _t69 else _t69):
		J.sp(v_a_103, "turnT", 0.0)
	if J.cmp(J.gp(v_a_103, "turnT"), 0.22, "<"):
		var _t70 = J.add(J.gp(v_a_103, "turnT"), v_dt_104)
		J.sp(v_a_103, "turnT", _t70)
		var _t71 = J.cmp(J.gp(v_a_103, "turnT"), 0.11, ">=")
		if ((not J.t(J.gp(v_a_103, "_fl"))) if _t71 else _t71):
			var _t72 = J.gp(v_a_103, "want")
			J.sp(v_a_103, "face", _t72)
			J.sp(v_a_103, "_fl", 1.0)
		if J.cmp(J.gp(v_a_103, "turnT"), 0.22, ">="):
			J.sp(v_a_103, "_fl", 0.0)
	var _t73 = J.seq(J.gp(v_a_103, "act"), "plaza_talk")
	if (_t73 if _t73 else J.seq(J.gp(v_a_103, "act"), "plaza_argue")):
		var _t74 = J.gp(v_a_103, "pl")
		var _t75 = J.gp(v_a_103, "spk")
		J.sp(_t74, "spk", _t75)

func _f16(this_, a: Array, env):
	var v_a_109 = null; var v_K_110 = null; var v_gy_111 = null; var v_t_112 = null; var v_k_113 = null; var v_glide_114 = null; var v_h_115 = null
	v_a_109 = J.arg(a, 0)
	v_K_110 = J.arg(a, 1)
	v_gy_111 = J.arg(a, 2)
	v_t_112 = J.arg(a, 3)
	var _t76 = env["canDraw"]
	if (not J.t(J.cl(_t76, null, [J.gp(v_a_109, "k")]))):
		var _t77 = env["charH"]
		var _t79 = J.mul(J.cl(_t77, null, [J.gp(v_a_109, "k")]), v_K_110)
		var _t78 = J.gp(v_a_109, "sc")
		v_h_115 = J.mul(_t79, (_t78 if J.t(_t78) else 1.0))
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "setTransform", [env["dpr"], 0.0, 0.0, env["dpr"], 0.0, 0.0])
		var _t80 = env["ctx"]
		var _t81 = J.mul(0.55, J.gp(v_a_109, "alpha"))
		J.sp(_t80, "globalAlpha", _t81)
		var _t82 = env["ctx"]
		J.sp(_t82, "fillStyle", "rgba(0,0,0,.45)")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [J.gp(v_a_109, "px"), v_gy_111, J.mul(v_h_115, 0.22), J.mul(v_h_115, 0.05), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(env["ctx"], "fill", [])
		var _t83 = env["ctx"]
		J.sp(_t83, "fillStyle", "rgba(20,14,28,.85)")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [J.gp(v_a_109, "px"), J.sub(v_gy_111, J.mul(v_h_115, 0.82)), J.mul(v_h_115, 0.15), J.mul(v_h_115, 0.17), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_a_109, "px"), J.mul(v_h_115, 0.2)), v_gy_111])
		J.mc(env["ctx"], "quadraticCurveTo", [J.sub(J.gp(v_a_109, "px"), J.mul(v_h_115, 0.22)), J.sub(v_gy_111, J.mul(v_h_115, 0.62)), J.gp(v_a_109, "px"), J.sub(v_gy_111, J.mul(v_h_115, 0.66))])
		J.mc(env["ctx"], "quadraticCurveTo", [J.add(J.gp(v_a_109, "px"), J.mul(v_h_115, 0.22)), J.sub(v_gy_111, J.mul(v_h_115, 0.62)), J.add(J.gp(v_a_109, "px"), J.mul(v_h_115, 0.2)), v_gy_111])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "restore", [])
		return null
	var _t84 = J.gp(v_a_109, "sc")
	v_k_113 = J.mul(v_K_110, (_t84 if J.t(_t84) else 1.0))
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "setTransform", [J.mul(env["dpr"], v_k_113), 0.0, 0.0, J.mul(env["dpr"], v_k_113), 0.0, 0.0])
	var _t85 = env["ctx"]
	var _t86 = J.gp(v_a_109, "alpha")
	J.sp(_t85, "globalAlpha", _t86)
	var _t87 = J.div(J.gp(v_a_109, "px"), v_k_113)
	J.sp(v_a_109, "x", _t87)
	var _t88 = J.div(v_gy_111, v_k_113)
	J.sp(v_a_109, "y", _t88)
	var _t89 = J.cmp(J.gp(v_a_109, "w"), 0.3, ">")
	var _t90 = ((not J.seq(J.typeof_(J.G.get("Antag")), "undefined")) if _t89 else _t89)
	var _t91 = (J.gp(J.G.get("Antag"), "STATES") if _t90 else _t90)
	var _t92 = (J.gp(J.gp(J.G.get("Antag"), "STATES"), J.gp(v_a_109, "k")) if J.t(_t91) else _t91)
	var _t93 = ((not J.seq(J.typeof_(J.G.get("DAILY")), "undefined")) if J.t(_t92) else _t92)
	v_glide_114 = (J.gp(J.G.get("DAILY"), "ag_walk") if J.t(_t93) else _t93)
	if J.t(v_glide_114):
		J.mc(J.G.get("ART"), "drawChar", [env["ctx"], J.gp(v_a_109, "k"), J.gp(v_a_109, "x"), J.gp(v_a_109, "y"), J.cl(env["SC"], null, []), {"t": J.add(v_t_112, J.gp(v_a_109, "seed")), "act": "ag_walk", "at": v_t_112, "flip": (not J.t(J.gp(v_a_109, "face"))), "tamed": true, "untied": true}])
	else:
		if J.t(J.gp(v_a_109, "pose")):
			J.mc(J.G.get("ART"), "drawChar", [env["ctx"], J.gp(v_a_109, "k"), J.gp(v_a_109, "x"), J.gp(v_a_109, "y"), J.cl(env["SC"], null, []), {"t": J.add(v_t_112, J.gp(v_a_109, "seed")), "pose": J.gp(v_a_109, "pose"), "pt": J.gp(v_a_109, "pt"), "flip": (not J.t(J.gp(v_a_109, "face"))), "tamed": true, "untied": true, "tdx": (40.0 if J.t(J.gp(v_a_109, "face")) else (-40.0)), "tdy": 0.0}])
		else:
			if (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined")):
				var _t94 = J.gp(v_a_109, "style")
				var _t95 = J.seq(J.gp(v_a_109, "act"), "plaza_eat")
				J.sp(_t94, "eat", _t95)
				J.mc(J.G.get("PlazaLife"), "drawAgent", [env["ctx"], v_a_109, v_t_112, {"noIcon": true}])
				if J.seq(J.gp(v_a_109, "k"), "shuigui"):
					J.mc(J.G.get("PlazaLife"), "drawDrips", [env["ctx"], v_a_109, J.add(v_t_112, J.gp(v_a_109, "seed"))])
			else:
				J.mc(J.G.get("ART"), "drawChar", [env["ctx"], J.gp(v_a_109, "k"), J.gp(v_a_109, "x"), J.gp(v_a_109, "y"), J.cl(env["SC"], null, []), {"t": J.add(v_t_112, J.gp(v_a_109, "seed")), "walk": J.cmp(J.gp(v_a_109, "w"), 0.3, ">"), "flip": (not J.t(J.gp(v_a_109, "face"))), "tamed": true, "untied": true}])
	J.mc(env["ctx"], "restore", [])

func _f17(this_, a: Array, env):
	var v_x_118 = null; var v_y_119 = null; var v_s_120 = null; var v_col_121 = null; var v_size_122 = null; var v_life_123 = null
	v_x_118 = J.arg(a, 0)
	v_y_119 = J.arg(a, 1)
	v_s_120 = J.arg(a, 2)
	v_col_121 = J.arg(a, 3)
	v_size_122 = J.arg(a, 4)
	v_life_123 = J.arg(a, 5)
	var _t96 = J.gp(env["sc"], "floats")
	var _t97 = J.G.get("L")
	J.mc(_t96, "push", [{"x": v_x_118, "y": v_y_119, "s": J.cl(_t97, null, [v_s_120]), "col": (v_col_121 if J.t(v_col_121) else "#ffe9a8"), "size": (v_size_122 if J.t(v_size_122) else 22.0), "t": 0.0, "life": (v_life_123 if J.t(v_life_123) else 1.3), "vx": ((randf() - 0.5) * 20.0)}])

func _f18(this_, a: Array, env):
	var v_n_126 = null; var v_i_127 = null
	v_n_126 = J.arg(a, 0)
	v_i_127 = 0.0
	while true:
		if not J.cmp(v_i_127, v_n_126, "<"): break
		var _t98 = J.gp(env["sc"], "parts")
		J.mc(_t98, "push", [{"x": J.mul(randf(), env["W"]), "y": ((-20.0) - (J.mul(randf(), env["H"]) * 0.4)), "vy": (40.0 + (randf() * 50.0)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 3.0), "flip": (randf() * 6.0), "vf": (2.0 + (randf() * 3.0)), "ph": (randf() * 6.0)}])
		v_i_127 = J.num(v_i_127) + 1.0

func _f20(this_, a: Array, env):
	var v_p_131 = null
	v_p_131 = J.arg(a, 0)
	var _t101 = J.add(J.gp(v_p_131, "y"), J.mul(J.gp(v_p_131, "vy"), env["dt"]))
	J.sp(v_p_131, "y", _t101)
	var _t102 = J.add(J.gp(v_p_131, "rot"), J.mul(J.gp(v_p_131, "vr"), env["dt"]))
	J.sp(v_p_131, "rot", _t102)
	var _t103 = J.add(J.gp(v_p_131, "flip"), J.mul(J.gp(v_p_131, "vf"), env["dt"]))
	J.sp(v_p_131, "flip", _t103)
	return J.cmp(J.gp(v_p_131, "y"), J.add(env["__p"]["H"], 20.0), "<")

func _f21(this_, a: Array, env):
	var v_f_134 = null
	v_f_134 = J.arg(a, 0)
	var _t112 = J.add(J.gp(v_f_134, "t"), env["dt"])
	J.sp(v_f_134, "t", _t112)
	return J.cmp(_t112, J.gp(v_f_134, "life"), "<")

func _f19(this_, a: Array, env):
	var v_p_132 = null; var v_sz_133 = null; var v_f_135 = null; var v_k_136 = null; var v_a_137 = null; var v_s_138 = null; var v_x_139 = null; var v_y_140 = null
	var _s45 = {"__p": env, "dt": null}
	_s45["dt"] = J.arg(a, 0)
	var _t99 = _s45["__p"]["sc"]
	var _t100 = J.gp(_s45["__p"]["sc"], "parts")
	var _t104 = J.mc(_t100, "filter", [Callable(self, "_f20").bind(_s45)])
	J.sp(_t99, "parts", _t104)
	for _t105 in J.iter(J.gp(_s45["__p"]["sc"], "parts")):
		v_p_132 = _t105
		v_sz_133 = 7.0
		J.mc(_s45["__p"]["ctx"], "save", [])
		J.mc(_s45["__p"]["ctx"], "translate", [J.add(J.gp(v_p_132, "x"), (sin(J.num(J.add(J.mul(_s45["__p"]["T"], 1.3), J.gp(v_p_132, "ph")))) * 10.0)), J.gp(v_p_132, "y")])
		J.mc(_s45["__p"]["ctx"], "rotate", [J.gp(v_p_132, "rot")])
		J.mc(_s45["__p"]["ctx"], "scale", [1.0, cos(J.num(J.gp(v_p_132, "flip")))])
		var _t106 = _s45["__p"]["ctx"]
		J.sp(_t106, "fillStyle", "#e8c35a")
		var _t107 = _s45["__p"]["ctx"]
		J.sp(_t107, "strokeStyle", "#6a4a14")
		var _t108 = _s45["__p"]["ctx"]
		J.sp(_t108, "lineWidth", 1.0)
		J.mc(_s45["__p"]["ctx"], "fillRect", [(-J.num(v_sz_133)), ((-J.num(v_sz_133)) * 0.7), J.mul(v_sz_133, 2.0), J.mul(v_sz_133, 1.4)])
		J.mc(_s45["__p"]["ctx"], "strokeRect", [(-J.num(v_sz_133)), ((-J.num(v_sz_133)) * 0.7), J.mul(v_sz_133, 2.0), J.mul(v_sz_133, 1.4)])
		var _t109 = _s45["__p"]["ctx"]
		J.sp(_t109, "fillStyle", "#b8322a")
		J.mc(_s45["__p"]["ctx"], "fillRect", [((-J.num(v_sz_133)) * 0.35), ((-J.num(v_sz_133)) * 0.35), J.mul(v_sz_133, 0.7), J.mul(v_sz_133, 0.7)])
		J.mc(_s45["__p"]["ctx"], "restore", [])
	var _t110 = _s45["__p"]["sc"]
	var _t111 = J.gp(_s45["__p"]["sc"], "floats")
	var _t113 = J.mc(_t111, "filter", [Callable(self, "_f21").bind(_s45)])
	J.sp(_t110, "floats", _t113)
	for _t114 in J.iter(J.gp(_s45["__p"]["sc"], "floats")):
		v_f_135 = _t114
		v_k_136 = J.div(J.gp(v_f_135, "t"), J.gp(v_f_135, "life"))
		v_a_137 = J.min_([1.0, (J.sub(1.0, v_k_136) * 3.0), J.mul(J.gp(v_f_135, "t"), 8.0)])
		v_s_138 = J.mul(J.gp(v_f_135, "size"), (0.7 + (0.3 * J.min_([1.0, J.mul(J.gp(v_f_135, "t"), 6.0)]))))
		J.mc(_s45["__p"]["ctx"], "save", [])
		var _t115 = _s45["__p"]["ctx"]
		J.sp(_t115, "globalAlpha", v_a_137)
		var _t116 = _s45["__p"]["ctx"]
		var _t117 = ("900 " + J.str(v_s_138) + "px " + J.str(J.gp(J.F_getComputedStyle([J.gp(J.G.get("document"), "body")]), "fontFamily")))
		J.sp(_t116, "font", _t117)
		var _t118 = _s45["__p"]["ctx"]
		J.sp(_t118, "textAlign", "center")
		var _t119 = _s45["__p"]["ctx"]
		J.sp(_t119, "textBaseline", "middle")
		var _t120 = _s45["__p"]["ctx"]
		J.sp(_t120, "lineJoin", "round")
		var _t121 = _s45["__p"]["ctx"]
		var _t122 = J.mul(v_s_138, 0.25)
		J.sp(_t121, "lineWidth", _t122)
		var _t123 = _s45["__p"]["ctx"]
		J.sp(_t123, "strokeStyle", "rgba(20,12,24,.92)")
		v_x_139 = J.add(J.gp(v_f_135, "x"), J.mul(J.gp(v_f_135, "vx"), J.gp(v_f_135, "t")))
		v_y_140 = J.sub(J.gp(v_f_135, "y"), J.mul(v_k_136, 36.0))
		J.mc(_s45["__p"]["ctx"], "strokeText", [J.gp(v_f_135, "s"), v_x_139, v_y_140])
		var _t124 = _s45["__p"]["ctx"]
		var _t125 = J.gp(v_f_135, "col")
		J.sp(_t124, "fillStyle", _t125)
		J.mc(_s45["__p"]["ctx"], "fillText", [J.gp(v_f_135, "s"), v_x_139, v_y_140])
		J.mc(_s45["__p"]["ctx"], "restore", [])

func _f23(this_, a: Array, env):
	var v_x_147 = null; var v_y_148 = null; var v_i_149 = null; var v_j_150 = null
	var _t133 = J.gp(J.arg(a, 0), 0.0)
	v_x_147 = _t133
	var _t134 = J.gp(J.arg(a, 0), 1.0)
	v_y_148 = _t134
	v_i_149 = J.arg(a, 1)
	v_j_150 = (J.mul(env["__p"]["w"], 0.35) if J.t(env["p"]) else 0.0)
	if J.t(v_i_149):
		J.mc(env["__p"]["__p"]["ctx"], "lineTo", [J.add(v_x_147, v_j_150), J.sub(v_y_148, J.mul(v_j_150, 0.5))])
	else:
		J.mc(env["__p"]["__p"]["ctx"], "moveTo", [J.add(v_x_147, v_j_150), v_y_148])

func _f22(this_, a: Array, env):
	var v_pts_143 = null; var v_col_145 = null
	var _s52 = {"__p": env, "w": null}
	v_pts_143 = J.arg(a, 0)
	_s52["w"] = J.arg(a, 1)
	v_col_145 = J.arg(a, 2)
	J.mc(_s52["__p"]["ctx"], "save", [])
	var _t126 = _s52["__p"]["ctx"]
	J.sp(_t126, "lineCap", "round")
	var _t127 = _s52["__p"]["ctx"]
	J.sp(_t127, "lineJoin", "round")
	var _t128 = _s52["__p"]["ctx"]
	J.sp(_t128, "strokeStyle", v_col_145)
	var _s53 = {"__p": _s52, "p": null}
	_s53["p"] = 0.0
	while true:
		_s53 = _s53.duplicate()
		if not J.cmp(_s53["p"], 2.0, "<"): break
		var _t129 = _s53["__p"]["__p"]["ctx"]
		var _t130 = (0.5 if J.t(_s53["p"]) else 1.0)
		J.sp(_t129, "globalAlpha", _t130)
		var _t131 = _s53["__p"]["__p"]["ctx"]
		var _t132 = J.mul(_s53["__p"]["w"], (0.5 if J.t(_s53["p"]) else 1.0))
		J.sp(_t131, "lineWidth", _t132)
		J.mc(_s53["__p"]["__p"]["ctx"], "beginPath", [])
		J.mc(v_pts_143, "forEach", [Callable(self, "_f23").bind(_s53)])
		J.mc(_s53["__p"]["__p"]["ctx"], "stroke", [])
		_s53["p"] = J.num(_s53["p"]) + 1.0
	J.mc(_s52["__p"]["ctx"], "restore", [])

func _f24(this_, a: Array, env):
	var v_x_153 = null; var v_gy_154 = null; var v_h_155 = null; var v_dir_156 = null; var v_top_157 = null; var v_i_158 = null
	v_x_153 = J.arg(a, 0)
	v_gy_154 = J.arg(a, 1)
	v_h_155 = J.arg(a, 2)
	v_dir_156 = J.arg(a, 3)
	v_top_157 = J.sub(v_gy_154, J.mul(v_h_155, 0.66))
	J.mc(env["ctx"], "save", [])
	var _t135 = env["ctx"]
	J.sp(_t135, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [v_x_153, J.add(v_gy_154, 2.0), J.mul(v_h_155, 0.12), J.mul(v_h_155, 0.025), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "restore", [])
	var _t136 = env["crayon"]
	J.cl(_t136, null, [[[J.sub(v_x_153, J.mul(v_h_155, 0.09)), v_gy_154], [v_x_153, J.sub(v_gy_154, J.mul(v_h_155, 0.03))], [J.add(v_x_153, J.mul(v_h_155, 0.09)), v_gy_154]], J.mul(v_h_155, 0.018), "#1c1820"])
	var _t137 = env["crayon"]
	J.cl(_t137, null, [[[v_x_153, J.sub(v_gy_154, J.mul(v_h_155, 0.02))], [v_x_153, v_top_157]], J.mul(v_h_155, 0.02), "#2a2630"])
	var _t138 = env["crayon"]
	J.cl(_t138, null, [[[v_x_153, v_top_157], [J.add(v_x_153, (J.mul(v_dir_156, v_h_155) * 0.13)), J.sub(v_top_157, J.mul(v_h_155, 0.06))]], J.mul(v_h_155, 0.016), "#2a2630"])
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [J.add(v_x_153, (J.mul(v_dir_156, v_h_155) * 0.15)), J.sub(v_top_157, J.mul(v_h_155, 0.07))])
	J.mc(env["ctx"], "rotate", [((-J.num(v_dir_156)) * 0.45)])
	J.mc(J.G.get("ART"), "rr", [env["ctx"], ((-J.num(v_h_155)) * 0.022), ((-J.num(v_h_155)) * 0.05), J.mul(v_h_155, 0.044), J.mul(v_h_155, 0.09), J.mul(v_h_155, 0.02), "#3a3640", "#111", 1.5])
	var _t139 = env["ctx"]
	J.sp(_t139, "fillStyle", "#9a9aa8")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [0.0, ((-J.num(v_h_155)) * 0.05), J.mul(v_h_155, 0.03), J.mul(v_h_155, 0.034), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(env["ctx"], "fill", [])
	var _t140 = env["ctx"]
	J.sp(_t140, "strokeStyle", "#111")
	var _t141 = env["ctx"]
	J.sp(_t141, "lineWidth", 1.4)
	J.mc(env["ctx"], "stroke", [])
	var _t142 = env["ctx"]
	J.sp(_t142, "strokeStyle", "rgba(40,40,50,.6)")
	var _t143 = env["ctx"]
	J.sp(_t143, "lineWidth", 0.8)
	v_i_158 = (-2.0)
	while true:
		if not J.cmp(v_i_158, 2.0, "<="): break
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [((-J.num(v_h_155)) * 0.026), (((-J.num(v_h_155)) * 0.05) + (J.mul(v_i_158, v_h_155) * 0.01))])
		J.mc(env["ctx"], "lineTo", [J.mul(v_h_155, 0.026), (((-J.num(v_h_155)) * 0.05) + (J.mul(v_i_158, v_h_155) * 0.01))])
		J.mc(env["ctx"], "stroke", [])
		v_i_158 = J.num(v_i_158) + 1.0
	J.mc(env["ctx"], "restore", [])

func _f25(this_, a: Array, env):
	var v_gy_161 = null; var v_top_162 = null; var v_x0_163 = null; var v_x1_164 = null; var v_i_165 = null; var v_y_166 = null
	v_gy_161 = J.arg(a, 0)
	v_top_162 = J.sub(v_gy_161, 6.0)
	v_x0_163 = J.mul(env["W"], 0.08)
	v_x1_164 = J.mul(env["W"], 0.92)
	J.mc(env["ctx"], "save", [])
	var _t144 = env["ctx"]
	J.sp(_t144, "fillStyle", "#3a2418")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [v_x0_163, v_top_162])
	J.mc(env["ctx"], "lineTo", [v_x1_164, v_top_162])
	J.mc(env["ctx"], "lineTo", [J.add(v_x1_164, 14.0), J.add(v_gy_161, 26.0)])
	J.mc(env["ctx"], "lineTo", [J.sub(v_x0_163, 14.0), J.add(v_gy_161, 26.0)])
	J.mc(env["ctx"], "closePath", [])
	J.mc(env["ctx"], "fill", [])
	var _t145 = env["ctx"]
	J.sp(_t145, "strokeStyle", "rgba(255,210,150,.18)")
	var _t146 = env["ctx"]
	J.sp(_t146, "lineWidth", 1.2)
	v_i_165 = 1.0
	while true:
		if not J.cmp(v_i_165, 4.0, "<"): break
		v_y_166 = J.add(v_top_162, J.mul(v_i_165, 7.0))
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [J.sub(v_x0_163, J.mul(v_i_165, 3.0)), v_y_166])
		J.mc(env["ctx"], "lineTo", [J.add(v_x1_164, J.mul(v_i_165, 3.0)), v_y_166])
		J.mc(env["ctx"], "stroke", [])
		v_i_165 = J.num(v_i_165) + 1.0
	var _t147 = env["ctx"]
	J.sp(_t147, "fillStyle", "#1e120c")
	J.mc(env["ctx"], "fillRect", [J.sub(v_x0_163, 14.0), J.add(v_gy_161, 26.0), (J.sub(v_x1_164, v_x0_163) + 28.0), 40.0])
	J.mc(env["ctx"], "restore", [])
	var _t148 = env["crayon"]
	J.cl(_t148, null, [[[v_x0_163, v_top_162], [v_x1_164, v_top_162]], 2.4, "#7a5634"])

func _f26(this_, a: Array, env):
	var v_text_169 = null; var v_w_170 = null; var v_x_171 = null; var v_y_172 = null
	v_text_169 = J.arg(a, 0)
	v_w_170 = J.min_([J.mul(env["W"], 0.62), 260.0])
	v_x_171 = (J.div(env["W"], 2.0) - J.div(v_w_170, 2.0))
	v_y_172 = J.mul(env["H"], 0.17)
	J.mc(env["ctx"], "save", [])
	var _t149 = env["ctx"]
	J.sp(_t149, "fillStyle", "rgba(130,24,20,.92)")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [v_x_171, v_y_172])
	J.mc(env["ctx"], "lineTo", [J.add(v_x_171, v_w_170), v_y_172])
	J.mc(env["ctx"], "lineTo", [J.sub(J.add(v_x_171, v_w_170), 6.0), J.add(v_y_172, 44.0)])
	J.mc(env["ctx"], "lineTo", [J.add(v_x_171, J.div(v_w_170, 2.0)), J.add(v_y_172, 52.0)])
	J.mc(env["ctx"], "lineTo", [J.add(v_x_171, 6.0), J.add(v_y_172, 44.0)])
	J.mc(env["ctx"], "closePath", [])
	J.mc(env["ctx"], "fill", [])
	var _t150 = env["ctx"]
	J.sp(_t150, "strokeStyle", "#f3d68a")
	var _t151 = env["ctx"]
	J.sp(_t151, "lineWidth", 1.5)
	J.mc(env["ctx"], "stroke", [])
	var _t152 = env["ctx"]
	var _t153 = J.F_getComputedStyle([J.gp(J.G.get("document"), "documentElement")])
	var _t154 = J.mc(_t153, "getPropertyValue", ["--serif"])
	var _t155 = ("900 21px " + J.str((_t154 if J.t(_t154) else "serif")))
	J.sp(_t152, "font", _t155)
	var _t156 = env["ctx"]
	J.sp(_t156, "textAlign", "center")
	var _t157 = env["ctx"]
	J.sp(_t157, "textBaseline", "middle")
	var _t158 = env["ctx"]
	J.sp(_t158, "fillStyle", "#ffe9b8")
	J.mc(env["ctx"], "fillText", [v_text_169, J.div(env["W"], 2.0), J.add(v_y_172, 23.0)])
	var _t159 = env["crayon"]
	J.cl(_t159, null, [[[J.sub(v_x_171, 8.0), J.sub(v_y_172, 10.0)], [J.add(v_x_171, 2.0), J.add(v_y_172, 2.0)]], 2.0, "#2a1a10"])
	var _t160 = env["crayon"]
	J.cl(_t160, null, [[[J.add(J.add(v_x_171, v_w_170), 8.0), J.sub(v_y_172, 10.0)], [J.sub(J.add(v_x_171, v_w_170), 2.0), J.add(v_y_172, 2.0)]], 2.0, "#2a1a10"])
	J.mc(env["ctx"], "restore", [])

func _f28(this_, a: Array, env):
	var v_p_185 = null; var v_q_186 = null
	v_p_185 = J.arg(a, 0)
	v_q_186 = J.arg(a, 1)
	var _t183 = J.gp(v_p_185, "z")
	var _t185 = (_t183 if J.t(_t183) else 0.0)
	var _t184 = J.gp(v_q_186, "z")
	return J.sub(_t185, (_t184 if J.t(_t184) else 0.0))

func _f27(this_, a: Array, env):
	var v_now_175 = null; var v_dt_176 = null; var v_r_177 = null; var v_shk_178 = null; var v_L_179 = null; var v_order_180 = null; var v_g_181 = null; var v_g_182 = null; var v_a_183 = null; var v_a_184 = null; var v_a_187 = null; var v_p_188 = null; var v_g_189 = null; var v_a_190 = null
	v_now_175 = J.arg(a, 0)
	if (not J.t(env["sc"])):
		return null
	v_dt_176 = J.min_([0.05, J.div(J.sub(v_now_175, env["last"]), 1000.0)])
	env["last"] = v_now_175
	var _t161 = J.add(env["T"], v_dt_176)
	env["T"] = _t161
	v_r_177 = J.mc(env["el"], "getBoundingClientRect", [])
	var _t162 = (absf(J.num(J.sub(J.gp(v_r_177, "width"), env["W"]))) > 1.0)
	if (_t162 if _t162 else (absf(J.num(J.sub(J.gp(v_r_177, "height"), env["H"]))) > 1.0)):
		J.cl(env["resize"], null, [])
	J.mc(env["ctx"], "setTransform", [env["dpr"], 0.0, 0.0, env["dpr"], 0.0, 0.0])
	J.mc(env["ctx"], "clearRect", [0.0, 0.0, env["W"], env["H"]])
	var _t165 = null
	if J.cmp(J.gp(env["sc"], "shake"), 0.0, ">"):
		var _t163 = env["sc"]
		var _t164 = J.sub(J.gp(_t163, "shake"), v_dt_176)
		J.sp(_t163, "shake", _t164)
		_t165 = J.mul((sin(J.num(J.mul(env["T"], 70.0))) * 4.0), J.gp(env["sc"], "shake"))
	else:
		_t165 = 0.0
	v_shk_178 = _t165
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_shk_178, 0.0])
	if J.seq(J.typeof_(J.G.get("paintBg")), "function"):
		var _t166 = J.G.get("paintBg")
		var _t168 = env["ctx"]
		var _t169 = env["W"]
		var _t170 = env["H"]
		var _t167 = J.gp(env["sc"], "bg")
		J.cl(_t166, null, [_t168, _t169, _t170, (_t167 if J.t(_t167) else "village"), env["T"]])
	else:
		var _t171 = env["ctx"]
		J.sp(_t171, "fillStyle", "#16131b")
		J.mc(env["ctx"], "fillRect", [0.0, 0.0, env["W"], env["H"]])
	v_L_179 = J.cl(env["layout"], null, [])
	if J.seq(J.gp(env["sc"], "mode"), "standup"):
		var _t172 = env["ctx"]
		J.sp(_t172, "fillStyle", "rgba(8,6,14,.55)")
		J.mc(env["ctx"], "fillRect", [0.0, 0.0, env["W"], env["H"]])
		v_g_181 = J.mc(env["ctx"], "createRadialGradient", [J.div(env["W"], 2.0), J.sub(J.gp(v_L_179, "gy"), J.mul(J.gp(v_L_179, "ch"), 0.6)), 10.0, J.div(env["W"], 2.0), J.sub(J.gp(v_L_179, "gy"), J.mul(J.gp(v_L_179, "ch"), 0.4)), (J.max_([env["W"], env["H"]]) * 0.55)])
		J.mc(v_g_181, "addColorStop", [0.0, "rgba(255,236,190,.34)"])
		J.mc(v_g_181, "addColorStop", [0.45, "rgba(255,220,160,.08)"])
		J.mc(v_g_181, "addColorStop", [1.0, "rgba(0,0,0,.55)"])
		var _t173 = env["ctx"]
		J.sp(_t173, "fillStyle", v_g_181)
		J.mc(env["ctx"], "fillRect", [0.0, 0.0, env["W"], env["H"]])
		var _t174 = env["drawBanner"]
		var _t175 = J.gp(env["sc"], "banner")
		J.cl(_t174, null, [(_t175 if J.t(_t175) else "棟篤笑・今晚開咪")])
		var _t176 = env["drawStageFloor"]
		J.cl(_t176, null, [J.gp(v_L_179, "gy")])
	else:
		v_g_182 = J.mc(env["ctx"], "createLinearGradient", [0.0, J.sub(J.gp(v_L_179, "gy"), 40.0), 0.0, env["H"]])
		J.mc(v_g_182, "addColorStop", [0.0, "rgba(10,8,16,0)"])
		J.mc(v_g_182, "addColorStop", [1.0, "rgba(10,8,16,.6)"])
		var _t177 = env["ctx"]
		J.sp(_t177, "fillStyle", v_g_182)
		J.mc(env["ctx"], "fillRect", [0.0, J.sub(J.gp(v_L_179, "gy"), 40.0), env["W"], (J.sub(env["H"], J.gp(v_L_179, "gy")) + 40.0)])
	for _t178 in J.iter(J.gp(env["sc"], "cast")):
		v_a_183 = _t178
		var _t179 = env["stepActor"]
		J.cl(_t179, null, [v_a_183, v_dt_176])
	for _t180 in J.iter(J.gp(env["sc"], "aud")):
		v_a_184 = _t180
		var _t181 = env["stepActor"]
		J.cl(_t181, null, [v_a_184, v_dt_176])
	var _t182 = J.mc(J.gp(env["sc"], "cast"), "slice", [])
	v_order_180 = J.mc(_t182, "sort", [Callable(self, "_f28").bind(env)])
	for _t186 in J.iter(v_order_180):
		v_a_187 = _t186
		var _t187 = env["drawActor"]
		var _t190 = J.gp(v_L_179, "K")
		var _t189 = J.gp(v_L_179, "gy")
		var _t188 = J.gp(v_a_187, "dy")
		J.cl(_t187, null, [v_a_187, _t190, J.add(_t189, (_t188 if J.t(_t188) else 0.0)), env["T"]])
	var _t191 = J.seq(J.gp(env["sc"], "mode"), "standup")
	if J.t((J.gp(J.gp(env["sc"], "cast"), 0.0) if _t191 else _t191)):
		v_p_188 = J.gp(J.gp(env["sc"], "cast"), 0.0)
		var _t192 = env["drawMic"]
		J.cl(_t192, null, [J.add(J.gp(v_p_188, "px"), (J.mul((1.0 if J.t(J.gp(v_p_188, "face")) else (-1.0)), J.gp(v_L_179, "ch")) * 0.36)), J.add(J.gp(v_L_179, "gy"), 2.0), J.gp(v_L_179, "ch"), ((-1.0) if J.t(J.gp(v_p_188, "face")) else 1.0)])
	if J.t(J.len(J.gp(env["sc"], "aud"))):
		for _t193 in J.iter(J.gp(env["sc"], "aud")):
			v_a_190 = _t193
			var _t194 = env["drawActor"]
			var _t197 = J.mul(J.gp(v_L_179, "K"), 0.78)
			var _t196 = J.sub(env["H"], 8.0)
			var _t195 = J.gp(v_a_190, "dy")
			J.cl(_t194, null, [v_a_190, _t197, J.add(_t196, (_t195 if J.t(_t195) else 0.0)), env["T"]])
		v_g_189 = J.mc(env["ctx"], "createLinearGradient", [0.0, J.sub(env["H"], J.mul(J.gp(v_L_179, "ch"), 0.9)), 0.0, env["H"]])
		J.mc(v_g_189, "addColorStop", [0.0, "rgba(6,4,10,0)"])
		J.mc(v_g_189, "addColorStop", [0.5, "rgba(6,4,10,.38)"])
		J.mc(v_g_189, "addColorStop", [1.0, "rgba(6,4,10,.7)"])
		var _t198 = env["ctx"]
		J.sp(_t198, "fillStyle", v_g_189)
		J.mc(env["ctx"], "fillRect", [0.0, J.sub(env["H"], J.mul(J.gp(v_L_179, "ch"), 0.9)), env["W"], J.mul(J.gp(v_L_179, "ch"), 0.9)])
	var _t199 = env["drawParts"]
	J.cl(_t199, null, [v_dt_176])
	J.mc(env["ctx"], "restore", [])
	if J.cmp(J.gp(env["sc"], "flash"), 0.0, ">"):
		var _t200 = env["sc"]
		var _t201 = J.sub(J.gp(_t200, "flash"), v_dt_176)
		J.sp(_t200, "flash", _t201)
		var _t202 = env["ctx"]
		var _t203 = ("rgba(255,250,235," + J.str((J.max_([0.0, J.gp(env["sc"], "flash")]) * 1.4)) + ")")
		J.sp(_t202, "fillStyle", _t203)
		J.mc(env["ctx"], "fillRect", [0.0, 0.0, env["W"], env["H"]])
	var _t204 = env["tickFlow"]
	J.cl(_t204, null, [v_dt_176])
	J.cl(env["placeBubble"], null, [])
	var _t205 = J.F_requestAnimationFrame([env["frame"]])
	env["raf"] = _t205

func _f29(this_, a: Array, env):
	var v_stand_193 = null; var v_gy_194 = null; var v_ch_195 = null
	v_stand_193 = J.seq(J.gp(env["sc"], "mode"), "standup")
	v_gy_194 = (J.mul(env["H"], 0.7) if J.t(v_stand_193) else J.mul(env["H"], 0.77))
	v_ch_195 = (J.min_([J.mul(env["H"], 0.34), J.mul(env["W"], 0.52)]) if J.t(v_stand_193) else J.min_([J.mul(env["H"], 0.3), J.mul(env["W"], (0.31 if (J.len(J.gp(env["sc"], "cast")) > 3.0) else 0.4))]))
	return {"gy": v_gy_194, "ch": v_ch_195, "K": J.div(v_ch_195, J.mul(60.0, J.cl(env["SC"], null, [])))}

func _f31(this_, a: Array, env):
	var v_a_199 = null
	v_a_199 = J.arg(a, 0)
	return J.seq(J.gp(v_a_199, "name"), env["name"])

func _f32(this_, a: Array, env):
	var v_a_200 = null
	v_a_200 = J.arg(a, 0)
	return J.seq(J.gp(v_a_200, "name"), env["name"])

func _f30(this_, a: Array, env):
	var _s76 = {"__p": env, "name": null}
	_s76["name"] = J.arg(a, 0)
	var _t206 = J.gp(_s76["__p"]["sc"], "cast")
	var _t208 = J.mc(_t206, "find", [Callable(self, "_f31").bind(_s76)])
	if not J.t(_t208):
		var _t207 = J.gp(_s76["__p"]["sc"], "aud")
		_t208 = J.mc(_t207, "find", [Callable(self, "_f32").bind(_s76)])
	return (_t208 if J.t(_t208) else null)

func _f34(this_, a: Array, env):
	var v_x_210 = null
	v_x_210 = J.arg(a, 0)
	return (not J.seq(v_x_210, env["sp"]))

func _f35(this_, a: Array, env):
	var v_s_211 = null; var v_x_212 = null
	v_s_211 = J.arg(a, 0)
	v_x_212 = J.arg(a, 1)
	return J.add(v_s_211, J.gp(v_x_212, "px"))

func _f33(this_, a: Array, env):
	var v_name_203 = null; var v_a_205 = null; var v_on_206 = null; var v_a_207 = null; var v_o_208 = null; var v_c_209 = null
	var _s79 = {"__p": env, "sp": null}
	v_name_203 = J.arg(a, 0)
	for _t209 in J.iter(J.gp(_s79["__p"]["sc"], "cast")):
		v_a_205 = _t209
		v_on_206 = J.seq(J.gp(v_a_205, "name"), v_name_203)
		if (not J.seq(J.gp(v_a_205, "spk"), v_on_206)):
			J.sp(v_a_205, "spk", v_on_206)
			var _t210 = (not J.t(J.gp(v_a_205, "one")))
			if ((not J.t(J.gp(v_a_205, "pose"))) if _t210 else _t210):
				var _t211 = _s79["__p"]["settle"]
				J.cl(_t211, null, [v_a_205])
	var _t212 = _s79["__p"]["actorOf"]
	_s79["sp"] = J.cl(_t212, null, [v_name_203])
	if J.t(((not J.t(J.gp(_s79["sp"], "aud"))) if J.t(_s79["sp"]) else _s79["sp"])):
		for _t213 in J.iter(J.gp(_s79["__p"]["sc"], "cast")):
			v_a_207 = _t213
			var _t214 = (not J.seq(v_a_207, _s79["sp"]))
			if ((not J.t(J.gp(v_a_207, "lockFace"))) if _t214 else _t214):
				var _t215 = J.cmp(J.gp(_s79["sp"], "px"), J.gp(v_a_207, "px"), ">")
				J.sp(v_a_207, "want", _t215)
	var _t216 = ((not J.t(J.gp(_s79["sp"], "aud"))) if J.t(_s79["sp"]) else _s79["sp"])
	var _t217 = ((J.len(J.gp(_s79["__p"]["sc"], "cast")) > 1.0) if J.t(_t216) else _t216)
	if J.t(((not J.t(J.gp(_s79["sp"], "lockFace"))) if J.t(_t217) else _t217)):
		var _t218 = J.gp(_s79["__p"]["sc"], "cast")
		v_o_208 = J.mc(_t218, "filter", [Callable(self, "_f34").bind(_s79)])
		v_c_209 = J.div(J.mc(v_o_208, "reduce", [Callable(self, "_f35").bind(_s79), 0.0]), J.len(v_o_208))
		var _t219 = _s79["sp"]
		var _t220 = J.cmp(v_c_209, J.gp(_s79["sp"], "px"), ">")
		J.sp(_t219, "want", _t220)

func _f36(this_, a: Array, env):
	var v_b_215 = null; var v_cap_216 = null; var v_bub_217 = null; var v_tx_218 = null; var v_nm_219 = null; var v_sp_220 = null; var v_n_221 = null; var v_a_222 = null
	v_b_215 = J.arg(a, 0)
	v_cap_216 = J.mc(env["el"], "querySelector", [".th-cap"])
	v_bub_217 = J.mc(env["el"], "querySelector", [".th-bub"])
	v_tx_218 = J.mc(v_bub_217, "querySelector", [".th-tx"])
	v_nm_219 = J.mc(v_bub_217, "querySelector", [".th-nm"])
	var _t221 = env["sc"]
	J.sp(_t221, "beat", v_b_215)
	var _t222 = env["sc"]
	J.sp(_t222, "typing", true)
	var _t223 = env["sc"]
	J.sp(_t223, "shown", 0.0)
	var _t224 = env["sc"]
	var _t225 = J.G.get("L")
	var _t226 = J.cl(_t225, null, [J.gp(v_b_215, "text")])
	J.sp(_t224, "full", _t226)
	var _t227 = env["sc"]
	J.sp(_t227, "ty", 0.0)
	if J.t(J.gp(v_b_215, "fx")):
		var _t228 = env["runFx"]
		J.cl(_t228, null, [J.gp(v_b_215, "fx")])
	if J.seq(J.gp(v_b_215, "who"), "旁白"):
		var _t229 = env["setSpeaker"]
		J.cl(_t229, null, [null])
		J.sp(v_bub_217, "className", "th-bub")
		J.sp(v_cap_216, "className", "th-cap on")
		J.sp(v_cap_216, "textContent", "")
		var _t230 = env["sc"]
		J.sp(_t230, "target", v_cap_216)
	else:
		J.sp(v_cap_216, "className", "th-cap")
		var _t231 = env["setSpeaker"]
		J.cl(_t231, null, [J.gp(v_b_215, "who")])
		var _t232 = env["actorOf"]
		v_sp_220 = J.cl(_t232, null, [J.gp(v_b_215, "who")])
		var _t233 = ("th-bub on" + (" sys" if J.seq(J.gp(v_b_215, "who"), "系統") else (" aud" if J.t((J.gp(v_sp_220, "aud") if J.t(v_sp_220) else v_sp_220)) else "")))
		J.sp(v_bub_217, "className", _t233)
		var _t234 = J.gp(v_b_215, "who")
		J.sp(v_nm_219, "textContent", _t234)
		J.sp(v_tx_218, "textContent", "")
		var _t235 = env["sc"]
		J.sp(_t235, "target", v_tx_218)
		var _t236 = env["sc"]
		J.sp(_t236, "bubFor", v_sp_220)
		if J.t((J.gp(v_b_215, "act") if J.t(v_sp_220) else v_sp_220)):
			var _t237 = env["doAct"]
			J.cl(_t237, null, [v_sp_220, J.gp(v_b_215, "act"), J.gp(v_b_215, "hold")])
		else:
			if J.t(((not J.t(J.gp(v_sp_220, "aud"))) if J.t(v_sp_220) else v_sp_220)):
				var _t238 = env["settle"]
				J.cl(_t238, null, [v_sp_220])
		var _t239 = (J.gp(v_sp_220, "aud") if J.t(v_sp_220) else v_sp_220)
		if J.t(((not J.t(J.gp(v_b_215, "act"))) if J.t(_t239) else _t239)):
			var _t240 = env["doAct"]
			J.cl(_t240, null, [v_sp_220, "laugh"])
	if J.t(J.gp(v_b_215, "re")):
		for _t241 in J.keys(J.gp(v_b_215, "re")):
			v_n_221 = _t241
			var _t242 = env["actorOf"]
			v_a_222 = J.cl(_t242, null, [v_n_221])
			if J.t(v_a_222):
				var _t243 = env["doAct"]
				J.cl(_t243, null, [v_a_222, J.gp(J.gp(v_b_215, "re"), v_n_221), J.gp(v_b_215, "hold")])
	var _t244 = J.mc(env["el"], "querySelector", [".th-tap"])
	J.sp(_t244, "textContent", "")

func _f37(this_, a: Array, env):
	var v_bub_225 = null; var v_L_226 = null; var v_sp_227 = null; var v_w_228 = null; var v_h_229 = null; var v_x_230 = null; var v_y_231 = null; var v_left_232 = null; var v_k_233 = null; var v_top_234 = null; var v_head_235 = null
	v_bub_225 = J.mc(env["el"], "querySelector", [".th-bub"])
	var _t246 = (not J.t(v_bub_225))
	if not J.t(_t246):
		var _t245 = J.gp(v_bub_225, "classList")
		_t246 = (not J.t(J.mc(_t245, "contains", ["on"])))
	if _t246:
		return null
	var _t247 = J.gp(v_bub_225, "style")
	J.sp(_t247, "left", "0px")
	v_L_226 = J.cl(env["layout"], null, [])
	v_sp_227 = J.gp(env["sc"], "bubFor")
	v_w_228 = J.gp(v_bub_225, "offsetWidth")
	v_h_229 = J.gp(v_bub_225, "offsetHeight")
	v_x_230 = J.div(env["W"], 2.0)
	v_y_231 = null
	var _t248 = (not J.t(v_sp_227))
	if (_t248 if _t248 else J.seq(J.gp(J.gp(env["sc"], "beat"), "who"), "系統")):
		var _t249 = J.max_([64.0, J.mul(env["H"], 0.16)])
		v_y_231 = _t249
		var _t250 = J.gp(v_bub_225, "style")
		var _t251 = J.add(J.max_([10.0, J.div(J.sub(env["W"], v_w_228), 2.0)]), "px")
		J.sp(_t250, "left", _t251)
		var _t252 = J.gp(v_bub_225, "style")
		var _t253 = J.add(v_y_231, "px")
		J.sp(_t252, "top", _t253)
		return null
	if J.t(J.gp(v_sp_227, "aud")):
		v_k_233 = J.mul(J.gp(v_L_226, "K"), 0.78)
		v_x_230 = J.gp(v_sp_227, "px")
		var _t255 = J.sub(env["H"], 8.0)
		var _t254 = env["charH"]
		v_top_234 = (_t255 - J.mul(J.cl(_t254, null, [J.gp(v_sp_227, "k")]), v_k_233))
		var _t256 = (J.sub(v_top_234, v_h_229) - 14.0)
		v_y_231 = _t256
	else:
		v_x_230 = J.gp(v_sp_227, "px")
		var _t260 = J.gp(v_L_226, "gy")
		var _t257 = env["charH"]
		var _t259 = J.mul(J.cl(_t257, null, [J.gp(v_sp_227, "k")]), J.gp(v_L_226, "K"))
		var _t258 = J.gp(v_sp_227, "sc")
		v_head_235 = (J.sub(_t260, J.mul(_t259, (_t258 if J.t(_t258) else 1.0))) - 10.0)
		var _t261 = (J.sub(v_head_235, v_h_229) - 12.0)
		v_y_231 = _t261
	var _t262 = J.max_([((J.mul(env["H"], 0.17) + 58.0) if J.seq(J.gp(env["sc"], "mode"), "standup") else 60.0), v_y_231])
	v_y_231 = _t262
	v_left_232 = J.max_([10.0, J.min_([(J.sub(env["W"], v_w_228) - 10.0), J.sub(v_x_230, J.div(v_w_228, 2.0))])])
	var _t263 = J.gp(v_bub_225, "style")
	var _t264 = J.add(v_left_232, "px")
	J.sp(_t263, "left", _t264)
	var _t265 = J.gp(v_bub_225, "style")
	var _t266 = J.add(v_y_231, "px")
	J.sp(_t265, "top", _t266)
	var _t267 = J.gp(v_bub_225, "style")
	J.mc(_t267, "setProperty", ["--tx", J.add(J.max_([16.0, J.min_([J.sub(v_w_228, 16.0), J.sub(v_x_230, v_left_232)])]), "px")])

func _f39(this_, a: Array, env):
	var v_a_240 = null
	v_a_240 = J.arg(a, 0)
	return (absf(J.num(J.sub(J.gp(v_a_240, "tx"), J.gp(v_a_240, "px")))) < 2.0)

func _f40(this_, a: Array, env):
	var v_a_241 = null
	v_a_241 = J.arg(a, 0)
	return (absf(J.num(J.sub(J.gp(v_a_241, "tx"), J.gp(v_a_241, "px")))) < 2.0)

func _f38(this_, a: Array, env):
	var v_dt_238 = null; var v_n_239 = null
	v_dt_238 = J.arg(a, 0)
	if J.seq(J.gp(env["sc"], "phase"), "enter"):
		var _t268 = J.gp(env["sc"], "cast")
		if J.t(J.mc(_t268, "every", [Callable(self, "_f39").bind(env)])):
			var _t269 = env["sc"]
			J.sp(_t269, "phase", "run")
			J.cl(env["next"], null, [])
		return null
	if J.seq(J.gp(env["sc"], "phase"), "exit"):
		var _t270 = env["sc"]
		var _t271 = J.sub(J.gp(_t270, "exitT"), v_dt_238)
		J.sp(_t270, "exitT", _t271)
		var _t273 = J.cmp(J.gp(env["sc"], "exitT"), 0.0, "<=")
		if not J.t(_t273):
			var _t272 = J.gp(env["sc"], "cast")
			_t273 = J.mc(_t272, "every", [Callable(self, "_f40").bind(env)])
		if J.t(_t273):
			var _t274 = env["close"]
			J.cl(_t274, null, [false])
		return null
	var _t275 = (not J.seq(J.gp(env["sc"], "phase"), "run"))
	if (_t275 if _t275 else (not J.t(J.gp(env["sc"], "typing")))):
		if J.cmp(J.gp(env["sc"], "autoT"), 0.0, ">"):
			var _t276 = env["sc"]
			var _t277 = J.sub(J.gp(_t276, "autoT"), v_dt_238)
			J.sp(_t276, "autoT", _t277)
			if J.cmp(J.gp(env["sc"], "autoT"), 0.0, "<="):
				J.cl(env["next"], null, [])
		return null
	var _t278 = env["sc"]
	var _t279 = J.add(J.gp(_t278, "ty"), v_dt_238)
	J.sp(_t278, "ty", _t279)
	v_n_239 = J.min_([J.len(J.gp(env["sc"], "full")), floor(J.num(J.div(J.gp(env["sc"], "ty"), 0.026)))])
	if (not J.seq(v_n_239, J.gp(env["sc"], "shown"))):
		var _t280 = env["sc"]
		J.sp(_t280, "shown", v_n_239)
		var _t281 = J.gp(env["sc"], "target")
		var _t282 = J.gp(env["sc"], "full")
		var _t283 = J.mc(_t282, "slice", [0.0, v_n_239])
		J.sp(_t281, "textContent", _t283)
	if J.cmp(v_n_239, J.len(J.gp(env["sc"], "full")), ">="):
		J.cl(env["done"], null, [])

func _f41(this_, a: Array, env):
	var v_b_244 = null
	var _t284 = env["sc"]
	J.sp(_t284, "typing", false)
	var _t285 = J.gp(env["sc"], "target")
	var _t286 = J.gp(env["sc"], "full")
	J.sp(_t285, "textContent", _t286)
	v_b_244 = J.gp(env["sc"], "beat")
	var _t287 = (J.gp(v_b_244, "react") if J.t(v_b_244) else v_b_244)
	if J.t((J.gp(env["sc"], "react") if J.t(_t287) else _t287)):
		J.mc(env["sc"], "react", [J.gp(v_b_244, "react"), v_b_244])
	if J.t((J.gp(v_b_244, "auto") if J.t(v_b_244) else v_b_244)):
		var _t288 = env["sc"]
		var _t289 = J.gp(v_b_244, "auto")
		J.sp(_t288, "autoT", _t289)
	var _t290 = J.mc(env["el"], "querySelector", [".th-tap"])
	J.sp(_t290, "textContent", "點擊繼續")

func _f42(this_, a: Array, env):
	var _t291 = env["sc"]
	J.sp(_t291, "autoT", 0.0)
	if J.cmp(J.gp(env["sc"], "i"), J.len(J.gp(env["sc"], "beats")), ">="):
		if J.t(J.gp(env["sc"], "choice")):
			J.cl(env["askChoice"], null, [])
			return null
		J.cl(env["exit"], null, [])
		return null
	var _t292 = env["show"]
	var _t295 = J.gp(env["sc"], "beats")
	var _t293 = env["sc"]
	var _t294 = J.num(J.gp(_t293, "i"))
	J.sp(_t293, "i", _t294 + 1.0)
	J.cl(_t292, null, [J.gp(_t295, _t294)])

func _f43(this_, a: Array, env):
	var v_a_249 = null
	if (not J.t(env["sc"])):
		return null
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	if J.seq(J.gp(env["sc"], "phase"), "enter"):
		for _t296 in J.iter(J.gp(env["sc"], "cast")):
			v_a_249 = _t296
			var _t297 = J.gp(v_a_249, "tx")
			J.sp(v_a_249, "px", _t297)
		return null
	if J.seq(J.gp(env["sc"], "phase"), "exit"):
		var _t298 = env["close"]
		J.cl(_t298, null, [false])
		return null
	if J.seq(J.gp(env["sc"], "phase"), "choice"):
		return null
	if J.t(J.gp(env["sc"], "typing")):
		J.cl(env["done"], null, [])
		return null
	J.cl(env["next"], null, [])

func _f45(this_, a: Array, env):
	var v_k_255 = null
	v_k_255 = J.arg(a, 0)
	return J.gp(env["c"], v_k_255)

func _f46(this_, a: Array, env):
	var v_k_256 = null
	v_k_256 = J.arg(a, 0)
	var _t308 = J.seq(v_k_256, "a")
	var _t310 = ("gold" if ((not J.t(J.gp(env["c"], "plain"))) if _t308 else _t308) else "")
	var _t311 = ("disabled" if J.t(J.gp(J.gp(env["c"], v_k_256), "disabled")) else "")
	var _t309 = J.G.get("L")
	return ("<button class=\"btn " + _t310 + " wide\" data-k=\"" + J.str(v_k_256) + "\" " + _t311 + ">" + J.str(J.cl(_t309, null, [J.gp(J.gp(env["c"], v_k_256), "label")])) + "</button>")

func _f48(this_, a: Array, env):
	var v_e_258 = null; var v_o_259 = null; var v_more_260 = null; var v_r_261 = null
	v_e_258 = J.arg(a, 0)
	J.mc(v_e_258, "stopPropagation", [])
	if J.t(J.gp(env["b"], "disabled")):
		return null
	v_o_259 = J.gp(env["__p"]["c"], J.gp(J.gp(env["b"], "dataset"), "k"))
	var _t317 = env["__p"]["__p"]["sc"]
	var _t318 = J.gp(J.gp(env["b"], "dataset"), "k")
	J.sp(_t317, "chosen", _t318)
	var _t319 = J.gp(env["__p"]["__p"]["sc"], "picks")
	J.mc(_t319, "push", [J.gp(J.gp(env["b"], "dataset"), "k")])
	var _t320 = env["__p"]["box"]
	J.sp(_t320, "className", "th-choice")
	var _t321 = env["__p"]["box"]
	J.sp(_t321, "innerHTML", "")
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["paper"])
	var _t322 = J.gp(v_o_259, "lines")
	v_more_260 = (_t322 if J.t(_t322) else [])
	if J.t(J.gp(v_o_259, "on")):
		v_r_261 = J.mc(v_o_259, "on", [J.mc(J.gp(env["__p"]["__p"]["sc"], "picks"), "slice", [])])
		if J.t(J.S_Array_("isArray", [v_r_261])):
			var _t323 = J.mc(v_more_260, "concat", [v_r_261])
			v_more_260 = _t323
	var _t324 = env["__p"]["__p"]["sc"]
	var _t325 = J.gp(env["__p"]["__p"]["sc"], "beats")
	var _t326 = env["__p"]["__p"]["parse"]
	var _t327 = J.mc(_t325, "concat", [J.cl(_t326, null, [v_more_260])])
	J.sp(_t324, "beats", _t327)
	if J.t(J.gp(v_o_259, "next")):
		var _t328 = env["__p"]["__p"]["sc"]
		var _t329 = (J.mc(v_o_259, "next", [J.mc(J.gp(env["__p"]["__p"]["sc"], "picks"), "slice", [])]) if J.seq(J.typeof_(J.gp(v_o_259, "next")), "function") else J.gp(v_o_259, "next"))
		J.sp(_t328, "choice", _t329)
		var _t330 = env["__p"]["__p"]["sc"]
		J.sp(_t330, "chosen", null)
	else:
		var _t331 = env["__p"]["__p"]["sc"]
		J.sp(_t331, "choice", null)
	var _t332 = env["__p"]["__p"]["sc"]
	J.sp(_t332, "phase", "run")
	J.cl(env["__p"]["__p"]["next"], null, [])

func _f47(this_, a: Array, env):
	var _s118 = {"__p": env, "b": null}
	_s118["b"] = J.arg(a, 0)
	var _t316 = _s118["b"]
	var _t333 = Callable(self, "_f48").bind(_s118)
	J.sp(_t316, "onclick", _t333)
	return _t333

func _f44(this_, a: Array, env):
	var v_cap_254 = null
	var _s115 = {"__p": env, "c": null, "box": null}
	var _t299 = _s115["__p"]["sc"]
	J.sp(_t299, "phase", "choice")
	_s115["c"] = J.gp(_s115["__p"]["sc"], "choice")
	_s115["box"] = J.mc(_s115["__p"]["el"], "querySelector", [".th-choice"])
	v_cap_254 = J.mc(_s115["__p"]["el"], "querySelector", [".th-cap"])
	var _t300 = J.mc(_s115["__p"]["el"], "querySelector", [".th-bub"])
	J.sp(_t300, "className", "th-bub")
	J.sp(v_cap_254, "className", "th-cap on")
	var _t301 = J.G.get("L")
	var _t302 = J.cl(_t301, null, [J.gp(_s115["c"], "q")])
	J.sp(v_cap_254, "textContent", _t302)
	var _t303 = _s115["__p"]["setSpeaker"]
	J.cl(_t303, null, [null])
	var _t304 = J.mc(_s115["__p"]["el"], "querySelector", [".th-tap"])
	J.sp(_t304, "textContent", "")
	var _t305 = _s115["box"]
	var _t306 = ["a", "b", "c"]
	var _t307 = J.mc(_t306, "filter", [Callable(self, "_f45").bind(_s115)])
	var _t312 = J.mc(_t307, "map", [Callable(self, "_f46").bind(_s115)])
	var _t313 = J.mc(_t312, "join", [""])
	J.sp(_t305, "innerHTML", _t313)
	var _t314 = _s115["box"]
	J.sp(_t314, "className", "th-choice on")
	var _t315 = J.mc(_s115["box"], "querySelectorAll", ["button"])
	J.mc(_t315, "forEach", [Callable(self, "_f47").bind(_s115)])

func _f50(this_, a: Array, env):
	var v_a_264 = null; var v_i_265 = null
	v_a_264 = J.arg(a, 0)
	v_i_265 = J.arg(a, 1)
	J.sp(v_a_264, "spk", false)
	var _t341 = env["settle"]
	J.cl(_t341, null, [v_a_264])
	var _t342 = (((-J.num(env["W"])) * 0.25) if J.cmp(J.gp(v_a_264, "home"), J.div(env["W"], 2.0), "<") else J.mul(env["W"], 1.25))
	J.sp(v_a_264, "tx", _t342)

func _f49(this_, a: Array, env):
	var _t334 = env["sc"]
	J.sp(_t334, "phase", "exit")
	var _t335 = env["sc"]
	J.sp(_t335, "exitT", 1.3)
	var _t336 = J.mc(env["el"], "querySelector", [".th-bub"])
	J.sp(_t336, "className", "th-bub")
	var _t337 = J.mc(env["el"], "querySelector", [".th-cap"])
	J.sp(_t337, "className", "th-cap")
	var _t338 = J.mc(env["el"], "querySelector", [".th-tap"])
	J.sp(_t338, "textContent", "")
	if J.seq(J.gp(env["sc"], "mode"), "standup"):
		var _t339 = env["sc"]
		J.sp(_t339, "exitT", 0.9)
		return null
	var _t340 = J.gp(env["sc"], "cast")
	J.mc(_t340, "forEach", [Callable(self, "_f50").bind(env)])

func _f51(this_, a: Array, env):
	var v_fx_268 = null; var v_f_269 = null
	v_fx_268 = J.arg(a, 0)
	var _t344 = J.F_String([v_fx_268])
	for _t343 in J.iter(J.mc(_t344, "split", [","])):
		v_f_269 = _t343
		if J.seq(v_f_269, "joss"):
			var _t345 = env["joss"]
			J.cl(_t345, null, [26.0])
		else:
			if J.seq(v_f_269, "shake"):
				var _t346 = env["sc"]
				J.sp(_t346, "shake", 0.5)
			else:
				if J.seq(v_f_269, "flash"):
					var _t347 = env["sc"]
					J.sp(_t347, "flash", 0.35)
				else:
					if J.seq(J.mc(v_f_269, "indexOf", ["txt:"]), 0.0):
						var _t348 = env["floatTxt"]
						J.cl(_t348, null, [J.div(env["W"], 2.0), J.mul(env["H"], 0.42), J.mc(v_f_269, "slice", [4.0]), "#ffe9a8", 28.0, 1.6])

func _f53(this_, a: Array, env):
	var v_l_273 = null
	v_l_273 = J.arg(a, 0)
	var _t356 = null
	if J.t(J.S_Array_("isArray", [v_l_273])):
		var _t350 = J.gp(v_l_273, 0.0)
		var _t351 = J.gp(v_l_273, 1.0)
		var _t349 = J.gp(v_l_273, 2.0)
		var _t353 = (_t349 if J.t(_t349) else null)
		var _t352 = J.gp(v_l_273, 3.0)
		var _t355 = (_t352 if J.t(_t352) else null)
		var _t354 = J.gp(v_l_273, 4.0)
		_t356 = {"who": _t350, "text": _t351, "act": _t353, "re": _t355, "fx": (_t354 if J.t(_t354) else null)}
	else:
		_t356 = v_l_273
	return _t356

func _f52(this_, a: Array, env):
	var v_lines_272 = null
	v_lines_272 = J.arg(a, 0)
	return J.mc(v_lines_272, "map", [Callable(self, "_f53").bind(env)])

func _f55(this_, a: Array, env):
	var v_name_281 = null; var v_k_282 = null; var v_opt_283 = null; var v_i_284 = null; var v_a_285 = null; var v_fromL_286 = null
	var _t377 = J.gp(J.arg(a, 0), 0.0)
	v_name_281 = _t377
	var _t378 = J.gp(J.arg(a, 0), 1.0)
	v_k_282 = _t378
	var _t379 = J.gp(J.arg(a, 0), 2.0)
	v_opt_283 = _t379
	v_i_284 = J.arg(a, 1)
	var _t380 = env["__p"]["mkActor"]
	v_a_285 = J.cl(_t380, null, [v_name_281, v_k_282, v_i_284, J.mul(env["__p"]["W"], J.gp(env["xs"], v_i_284))])
	J.S_Object_("assign", [v_a_285, (v_opt_283 if J.t(v_opt_283) else {})])
	var _t381 = J.mul(env["__p"]["W"], J.gp(env["xs"], v_i_284))
	J.sp(v_a_285, "home", _t381)
	var _t382 = J.gp(v_a_285, "home")
	J.sp(v_a_285, "tx", _t382)
	var _t383 = (J.gp(v_opt_283, "base") if J.t(v_opt_283) else v_opt_283)
	var _t384 = (_t383 if J.t(_t383) else null)
	J.sp(v_a_285, "base", _t384)
	var _t385 = (J.gp(v_opt_283, "talk") if J.t(v_opt_283) else v_opt_283)
	var _t386 = (_t385 if J.t(_t385) else null)
	J.sp(v_a_285, "talk", _t386)
	var _t387 = J.seq(J.gp(env["scene"], "mode"), "standup")
	if J.t((_t387 if _t387 else (J.gp(v_opt_283, "onstage") if J.t(v_opt_283) else v_opt_283))):
		var _t388 = J.gp(v_a_285, "tx")
		J.sp(v_a_285, "px", _t388)
		var _t389 = (J.gp(v_opt_283, "face") if J.t(((not J.leq(J.gp(v_opt_283, "face"), null)) if J.t(v_opt_283) else v_opt_283)) else J.cmp(J.gp(v_a_285, "home"), J.div(env["__p"]["W"], 2.0), "<"))
		J.sp(v_a_285, "face", _t389)
		J.sp(v_a_285, "want", _t389)
	else:
		v_fromL_286 = J.cmp(J.gp(v_a_285, "home"), J.div(env["__p"]["W"], 2.0), "<")
		var _t390 = ((((-J.num(env["__p"]["W"])) * 0.18) - J.mul(v_i_284, 40.0)) if J.t(v_fromL_286) else (J.mul(env["__p"]["W"], 1.18) + (J.sub(env["n"], v_i_284) * 40.0)))
		J.sp(v_a_285, "px", _t390)
		J.sp(v_a_285, "want", v_fromL_286)
		J.sp(v_a_285, "face", v_fromL_286)
	if J.t(J.gp(v_a_285, "base")):
		var _t391 = env["__p"]["settle"]
		J.cl(_t391, null, [v_a_285])
	var _t392 = J.gp(env["__p"]["sc"], "cast")
	J.mc(_t392, "push", [v_a_285])

func _f56(this_, a: Array, env):
	var v_name_287 = null; var v_k_288 = null; var v_i_289 = null; var v_arr_290 = null; var v_x_291 = null; var v_a_292 = null
	var _t395 = J.gp(J.arg(a, 0), 0.0)
	v_name_287 = _t395
	var _t396 = J.gp(J.arg(a, 0), 1.0)
	v_k_288 = _t396
	v_i_289 = J.arg(a, 1)
	v_arr_290 = J.arg(a, 2)
	v_x_291 = J.mul(env["__p"]["W"], (0.1 + (0.8 * (0.5 if J.seq(J.len(v_arr_290), 1.0) else J.div(v_i_289, (J.len(v_arr_290) - 1.0))))))
	var _t397 = env["__p"]["mkActor"]
	v_a_292 = J.cl(_t397, null, [v_name_287, v_k_288, J.add(50.0, v_i_289), v_x_291])
	J.sp(v_a_292, "aud", true)
	var _t398 = J.cmp(v_x_291, J.div(env["__p"]["W"], 2.0), "<")
	J.sp(v_a_292, "want", _t398)
	J.sp(v_a_292, "face", _t398)
	var _t399 = (J.mod(v_i_289, 2.0) * 6.0)
	J.sp(v_a_292, "dy", _t399)
	var _t400 = J.gp(env["__p"]["sc"], "aud")
	J.mc(_t400, "push", [v_a_292])

func _f57(this_, a: Array, env):
	if J.t((J.seq(J.gp(env["__p"]["sc"], "i"), 0.0) if J.t(env["__p"]["sc"]) else env["__p"]["sc"])):
		J.cl(env["__p"]["next"], null, [])

func _f54(this_, a: Array, env):
	var v_cb_277 = null; var v_cast_278 = null
	var _s130 = {"__p": env, "scene": null, "n": null, "xs": null}
	_s130["scene"] = J.arg(a, 0)
	v_cb_277 = J.arg(a, 1)
	if J.t(_s130["__p"]["sc"]):
		var _t357 = _s130["__p"]["close"]
		J.cl(_t357, null, [true])
	J.cl(_s130["__p"]["ensure"], null, [])
	var _t358 = _s130["__p"]["el"]
	J.sp(_t358, "className", "on")
	J.cl(_s130["__p"]["resize"], null, [])
	var _t359 = J.gp(_s130["scene"], "cast")
	v_cast_278 = (_t359 if J.t(_t359) else [])
	_s130["n"] = J.len(v_cast_278)
	var _t360 = J.gp(_s130["scene"], "xs")
	_s130["xs"] = (_t360 if J.t(_t360) else ([0.5] if J.seq(_s130["n"], 1.0) else ([0.3, 0.7] if J.seq(_s130["n"], 2.0) else ([0.2, 0.5, 0.8] if J.seq(_s130["n"], 3.0) else [0.15, 0.38, 0.62, 0.85]))))
	var _t361 = J.gp(_s130["scene"], "mode")
	var _t364 = (_t361 if J.t(_t361) else "skit")
	var _t365 = J.gp(_s130["scene"], "bg")
	var _t366 = J.gp(_s130["scene"], "banner")
	var _t367 = []
	var _t368 = []
	var _t369 = []
	var _t370 = []
	var _t362 = _s130["__p"]["parse"]
	var _t363 = J.gp(_s130["scene"], "lines")
	var _t372 = J.cl(_t362, null, [(_t363 if J.t(_t363) else [])])
	var _t371 = J.gp(_s130["scene"], "choice")
	var _t374 = (_t371 if J.t(_t371) else null)
	var _t375 = []
	var _t373 = J.gp(_s130["scene"], "react")
	var _t376 = {"mode": _t364, "bg": _t365, "banner": _t366, "cb": v_cb_277, "cast": _t367, "aud": _t368, "parts": _t369, "floats": _t370, "beats": _t372, "i": 0.0, "phase": "enter", "choice": _t374, "chosen": null, "picks": _t375, "react": (_t373 if J.t(_t373) else null), "shake": 0.0, "flash": 0.0, "autoT": 0.0}
	_s130["__p"]["sc"] = _t376
	J.mc(v_cast_278, "forEach", [Callable(self, "_f55").bind(_s130)])
	var _t393 = J.gp(_s130["scene"], "aud")
	var _t394 = (_t393 if J.t(_t393) else [])
	J.mc(_t394, "forEach", [Callable(self, "_f56").bind(_s130)])
	var _t401 = J.mc(_s130["__p"]["el"], "querySelector", [".th-tag"])
	var _t402 = J.gp(_s130["scene"], "tag")
	var _t403 = (_t402 if J.t(_t402) else "陰間日常")
	J.sp(_t401, "textContent", _t403)
	var _t404 = J.mc(_s130["__p"]["el"], "querySelector", [".th-title"])
	var _t405 = J.G.get("L")
	var _t406 = J.gp(_s130["scene"], "title")
	var _t407 = J.cl(_t405, null, [(_t406 if J.t(_t406) else "")])
	J.sp(_t404, "textContent", _t407)
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		J.mc(J.G.get("Sound"), "setMode", ["story"])
	if J.t(J.gp(_s130["scene"], "fx")):
		var _t408 = _s130["__p"]["runFx"]
		J.cl(_t408, null, [J.gp(_s130["scene"], "fx")])
	var _t409 = J.S_performance_("now", [])
	_s130["__p"]["last"] = _t409
	J.F_cancelAnimationFrame([_s130["__p"]["raf"]])
	var _t410 = J.F_requestAnimationFrame([_s130["__p"]["frame"]])
	_s130["__p"]["raf"] = _t410
	if J.seq(J.gp(_s130["__p"]["sc"], "mode"), "standup"):
		var _t411 = _s130["__p"]["sc"]
		J.sp(_t411, "phase", "run")
		J.F_setTimeout([Callable(self, "_f57").bind(_s130), 450.0])

func _f58(this_, a: Array, env):
	var v_skipped_295 = null; var v_s_296 = null
	v_skipped_295 = J.arg(a, 0)
	if (not J.t(env["sc"])):
		return null
	v_s_296 = env["sc"]
	env["sc"] = null
	J.F_cancelAnimationFrame([env["raf"]])
	if J.t(env["el"]):
		var _t412 = env["el"]
		J.sp(_t412, "className", "")
		var _t413 = env["el"]
		J.sp(_t413, "innerHTML", "")
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		var _t414 = (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))
		J.mc(J.G.get("Sound"), "setMode", [("story" if J.t((J.gp(J.G.get("GhostStreet"), "active") if _t414 else _t414)) else "village")])
	if J.t(J.gp(v_s_296, "cb")):
		var _t417 = (not (not J.t(v_skipped_295)))
		var _t415 = J.gp(v_s_296, "chosen")
		var _t416 = (_t415 if J.t(_t415) else J.gp(J.gp(v_s_296, "picks"), (J.len(J.gp(v_s_296, "picks")) - 1.0)))
		J.mc(v_s_296, "cb", [{"skipped": _t417, "choice": (_t416 if J.t(_t416) else null), "picks": J.gp(v_s_296, "picks")}])

func _f6(this_, a: Array, env):
	return (J.gp(J.G.get("PlazaLife"), "SC") if (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined")) else 0.58)

func _f7(this_, a: Array, env):
	var v_k_64 = null
	v_k_64 = J.arg(a, 0)
	var _t418 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
	var _t419 = (J.gp(J.G.get("ART"), "CHAR_H") if _t418 else _t418)
	var _t420 = (J.gp(J.gp(J.G.get("ART"), "CHAR_H"), v_k_64) if J.t(_t419) else _t419)
	return J.mul((_t420 if J.t(_t420) else 56.0), J.cl(env["SC"], null, []))

func _f59(this_, a: Array, env):
	return (not (not J.t(env["sc"])))

func _f60(this_, a: Array, env):
	return (J.gp(env["sc"], "aud") if J.t(env["sc"]) else [])

func _f61(this_, a: Array, env):
	return (J.gp(env["sc"], "cast") if J.t(env["sc"]) else [])

func _f62(this_, a: Array, env):
	var v_a_306 = null; var v_act_307 = null; var v_hold_308 = null
	v_a_306 = J.arg(a, 0)
	v_act_307 = J.arg(a, 1)
	v_hold_308 = J.arg(a, 2)
	var _t421 = env["doAct"]
	J.cl(_t421, null, [v_a_306, v_act_307, v_hold_308])

func _f63(this_, a: Array, env):
	return {"W": env["W"], "H": env["H"]}

func _f64(this_, a: Array, env):
	return (J.cl(env["layout"], null, []) if J.t(env["sc"]) else null)

func _f65(this_, a: Array, env):
	var v_beats_315 = null
	v_beats_315 = J.arg(a, 0)
	if J.t(env["sc"]):
		var _t422 = J.gp(env["sc"], "beats")
		var _t424 = J.gp(env["sc"], "i")
		var _t423 = env["parse"]
		J.mc(_t422, "splice", J.spread([_t424, 0.0, J.SP(J.cl(_t423, null, [v_beats_315]))]))

func _f1(this_, a: Array, env):
	var v_play_52 = null; var v_API_54 = null; var v_e_297 = null
	var _s2 = {"__p": env, "PI": null, "ONE": null, "el": null, "cv": null, "ctx": null, "W": null, "H": null, "dpr": null, "raf": null, "last": null, "T": null, "sc": null, "css": null, "ensure": null, "resize": null, "SC": null, "charH": null, "canDraw": null, "mkActor": null, "actKey": null, "agDur": null, "n30Dur": null, "doAct": null, "settle": null, "stepActor": null, "drawActor": null, "floatTxt": null, "joss": null, "drawParts": null, "crayon": null, "drawMic": null, "drawStageFloor": null, "drawBanner": null, "frame": null, "layout": null, "actorOf": null, "setSpeaker": null, "show": null, "placeBubble": null, "tickFlow": null, "done": null, "next": null, "tap": null, "askChoice": null, "exit": null, "runFx": null, "parse": null, "close": null}
	_s2["css"] = Callable(self, "_f2").bind(_s2)
	_s2["ensure"] = Callable(self, "_f3").bind(_s2)
	_s2["resize"] = Callable(self, "_f5").bind(_s2)
	_s2["canDraw"] = Callable(self, "_f8").bind(_s2)
	_s2["mkActor"] = Callable(self, "_f9").bind(_s2)
	_s2["actKey"] = Callable(self, "_f10").bind(_s2)
	_s2["agDur"] = Callable(self, "_f11").bind(_s2)
	_s2["n30Dur"] = Callable(self, "_f12").bind(_s2)
	_s2["doAct"] = Callable(self, "_f13").bind(_s2)
	_s2["settle"] = Callable(self, "_f14").bind(_s2)
	_s2["stepActor"] = Callable(self, "_f15").bind(_s2)
	_s2["drawActor"] = Callable(self, "_f16").bind(_s2)
	_s2["floatTxt"] = Callable(self, "_f17").bind(_s2)
	_s2["joss"] = Callable(self, "_f18").bind(_s2)
	_s2["drawParts"] = Callable(self, "_f19").bind(_s2)
	_s2["crayon"] = Callable(self, "_f22").bind(_s2)
	_s2["drawMic"] = Callable(self, "_f24").bind(_s2)
	_s2["drawStageFloor"] = Callable(self, "_f25").bind(_s2)
	_s2["drawBanner"] = Callable(self, "_f26").bind(_s2)
	_s2["frame"] = Callable(self, "_f27").bind(_s2)
	_s2["layout"] = Callable(self, "_f29").bind(_s2)
	_s2["actorOf"] = Callable(self, "_f30").bind(_s2)
	_s2["setSpeaker"] = Callable(self, "_f33").bind(_s2)
	_s2["show"] = Callable(self, "_f36").bind(_s2)
	_s2["placeBubble"] = Callable(self, "_f37").bind(_s2)
	_s2["tickFlow"] = Callable(self, "_f38").bind(_s2)
	_s2["done"] = Callable(self, "_f41").bind(_s2)
	_s2["next"] = Callable(self, "_f42").bind(_s2)
	_s2["tap"] = Callable(self, "_f43").bind(_s2)
	_s2["askChoice"] = Callable(self, "_f44").bind(_s2)
	_s2["exit"] = Callable(self, "_f49").bind(_s2)
	_s2["runFx"] = Callable(self, "_f51").bind(_s2)
	_s2["parse"] = Callable(self, "_f52").bind(_s2)
	v_play_52 = Callable(self, "_f54").bind(_s2)
	_s2["close"] = Callable(self, "_f58").bind(_s2)
	_s2["PI"] = PI
	_s2["ONE"] = {"wave": 1.4, "bow": 1.2, "startle": 1.3, "eek": 0.8, "laugh": 1.7, "boo": 0.95, "reach": 0.6, "stretch": 2.0, "spin": 2.2, "shake": 1.8, "look": 2.0, "dizzy": 2.2, "backrub": 2.6, "bump": 0.8}
	_s2["el"] = null
	_s2["cv"] = null
	_s2["ctx"] = null
	_s2["W"] = 390.0
	_s2["H"] = 700.0
	_s2["dpr"] = 1.0
	_s2["raf"] = 0.0
	_s2["last"] = 0.0
	_s2["T"] = 0.0
	_s2["sc"] = null
	_s2["SC"] = Callable(self, "_f6").bind(_s2)
	_s2["charH"] = Callable(self, "_f7").bind(_s2)
	J.cl(_s2["css"], null, [])
	v_API_54 = {"play": v_play_52, "close": _s2["close"], "aud": Callable(self, "_f60").bind(_s2), "cast": Callable(self, "_f61").bind(_s2), "act": Callable(self, "_f62").bind(_s2), "float": _s2["floatTxt"], "joss": _s2["joss"], "fx": _s2["runFx"], "size": Callable(self, "_f63").bind(_s2), "layout": Callable(self, "_f64").bind(_s2), "insert": Callable(self, "_f65").bind(_s2), "charH": _s2["charH"], "__getters": {"on": Callable(self, "_f59").bind(_s2)}}
	return v_API_54

func _f66(this_, a: Array, env):
	var v_n_316 = null
	v_n_316 = J.arg(a, 0)
	var _t425 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	return J.round(J.num(J.mul(v_n_316, (1.0 + J.mul((J.gp(J.G.get("S"), "lv") if J.t((J.G.get("S") if _t425 else _t425)) else 1.0), 0.18)))))

func _f67(this_, a: Array, env):
	var _t426 = J.G.get("rwd")
	return {"buns": J.cl(_t426, null, [18.0])}

func _f68(this_, a: Array, env):
	var _t427 = J.G.get("rwd")
	return {"exp": J.cl(_t427, null, [6.0])}

func _f69(this_, a: Array, env):
	var _t428 = J.G.get("rwd")
	return {"coins": J.cl(_t428, null, [22.0])}

func _f70(this_, a: Array, env):
	var _t429 = J.G.get("rwd")
	return {"exp": J.cl(_t429, null, [6.0])}

func _f71(this_, a: Array, env):
	var _t430 = J.G.get("rwd")
	return {"buns": J.cl(_t430, null, [20.0])}

func _f72(this_, a: Array, env):
	var _t431 = J.G.get("rwd")
	return {"coins": J.cl(_t431, null, [20.0])}

func _f73(this_, a: Array, env):
	var _t432 = J.G.get("rwd")
	var _t434 = J.cl(_t432, null, [16.0])
	var _t433 = J.G.get("rwd")
	return {"buns": _t434, "exp": J.cl(_t433, null, [4.0])}

func _f74(this_, a: Array, env):
	var _t435 = J.G.get("rwd")
	return {"coins": J.cl(_t435, null, [18.0])}

func _f75(this_, a: Array, env):
	var _t436 = J.G.get("rwd")
	return {"exp": J.cl(_t436, null, [6.0])}

func _f76(this_, a: Array, env):
	var _t437 = J.G.get("rwd")
	return {"coins": J.cl(_t437, null, [14.0])}

func _f78(this_, a: Array, env):
	var v_s_336 = null
	var _t438 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t438 if _t438 else (not J.t(J.G.get("S")))):
		return null
	var _t439 = J.G.get("S")
	var _t440 = J.gp(J.G.get("S"), "skit")
	var _t441 = (_t440 if J.t(_t440) else {})
	J.sp(_t439, "skit", _t441)
	v_s_336 = _t441
	var _t442 = J.gp(v_s_336, "seen")
	var _t443 = (_t442 if J.t(_t442) else {})
	J.sp(v_s_336, "seen", _t443)
	var _t444 = J.gp(v_s_336, "cyc")
	var _t445 = (_t444 if J.t(_t444) else {})
	J.sp(v_s_336, "cyc", _t445)
	if (not J.seq(J.typeof_(J.gp(v_s_336, "act")), "number")):
		J.sp(v_s_336, "act", 0.0)
	if (not J.seq(J.typeof_(J.gp(v_s_336, "next")), "number")):
		J.sp(v_s_336, "next", 100.0)
	var _t446 = J.gp(v_s_336, "n")
	var _t447 = (_t446 if J.t(_t446) else 0.0)
	J.sp(v_s_336, "n", _t447)
	var _t448 = J.gp(v_s_336, "last")
	var _t449 = (_t448 if J.t(_t448) else "")
	J.sp(v_s_336, "last", _t449)
	return v_s_336

func _f81(this_, a: Array, env):
	var v_c_341 = null
	v_c_341 = J.arg(a, 0)
	var _t452 = (not J.seq(J.typeof_(J.G.get("sprOk")), "function"))
	if not J.t(_t452):
		var _t451 = J.G.get("sprOk")
		_t452 = J.cl(_t451, null, [J.gp(v_c_341, 1.0)])
	return _t452

func _f80(this_, a: Array, env):
	var v_sk_340 = null
	v_sk_340 = J.arg(a, 0)
	var _t453 = (not J.t(J.gp(v_sk_340, "cast")))
	if not J.t(_t453):
		var _t450 = J.gp(v_sk_340, "cast")
		_t453 = J.mc(_t450, "every", [Callable(self, "_f81").bind(env)])
	return _t453

func _f82(this_, a: Array, env):
	var v_sk_344 = null
	v_sk_344 = J.arg(a, 0)
	if (not J.t(J.G.get("S"))):
		return false
	var _t455 = J.gp(v_sk_344, "need")
	if J.t(_t455):
		var _t454 = J.gp(v_sk_344, "need")
		_t455 = (not J.t(J.mc(_t454, "every", [env["seen"]])))
	if J.t(_t455):
		return false
	var _t456 = J.gp(v_sk_344, "pre")
	if J.t((J.gp(J.G.get("S"), "ended") if J.t(_t456) else _t456)):
		return false
	var _t457 = env["artOk"]
	return J.cl(_t457, null, [v_sk_344])

func _f83(this_, a: Array, env):
	var v_q_347 = null; var v_e_348 = null
	var _t458 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t460 = (_t458 if _t458 else (not J.t(J.G.get("S"))))
	if not J.t(_t460):
		var _t459 = env["seen"]
		_t460 = (not J.t(J.cl(_t459, null, ["prologue_sys"])))
	if _t460:
		return false
	var _t461 = J.gp(J.G.get("document"), "hidden")
	if J.t((_t461 if J.t(_t461) else J.gp(J.G.get("Theater"), "on"))):
		return false
	var _t462 = (not J.seq(J.typeof_(J.G.get("Story")), "undefined"))
	if J.t((J.mc(J.G.get("Story"), "busy", []) if _t462 else _t462)):
		return false
	var _t463 = (not J.seq(J.typeof_(J.G.get("Battle")), "undefined"))
	if J.t((J.gp(J.G.get("Battle"), "active") if _t463 else _t463)):
		return false
	var _t464 = (not J.seq(J.typeof_(J.G.get("Phone")), "undefined"))
	if J.t((J.gp(J.G.get("Phone"), "on") if _t464 else _t464)):
		return false
	for _t465 in J.iter(env["OVERLAYS"]):
		v_q_347 = _t465
		v_e_348 = J.S_document_("querySelector", [v_q_347])
		var _t468 = v_e_348
		if J.t(_t468):
			var _t466 = J.gp(v_e_348, "classList")
			var _t467 = J.mc(_t466, "contains", ["on"])
			_t468 = (_t467 if J.t(_t467) else J.seq(J.gp(v_e_348, "className"), "on"))
		if J.t(_t468):
			return false
	return true

func _f85(this_, a: Array, env):
	var v_k_356 = null
	v_k_356 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(env["s"], "cyc"), J.gp(v_k_356, "id"))))

func _f86(this_, a: Array, env):
	var v_k_357 = null
	v_k_357 = J.arg(a, 0)
	return (not J.seq(J.gp(v_k_357, "id"), J.gp(env["s"], "last")))

func _f87(this_, a: Array, env):
	var v_k_358 = null
	v_k_358 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_k_358, "id"))))

func _f84(this_, a: Array, env):
	var v_pool_352 = null; var v_fresh_353 = null; var v_unseen_354 = null; var v_from_355 = null
	var _s169 = {"__p": env, "s": null}
	_s169["s"] = J.cl(_s169["__p"]["st"], null, [])
	v_pool_352 = J.mc(J.G.get("SKITS"), "filter", [_s169["__p"]["ok"]])
	if (not J.t(J.len(v_pool_352))):
		return null
	v_fresh_353 = J.mc(v_pool_352, "filter", [Callable(self, "_f85").bind(_s169)])
	if (not J.t(J.len(v_fresh_353))):
		var _t469 = _s169["s"]
		var _t470 = {}
		J.sp(_t469, "cyc", _t470)
		var _t471 = J.mc(v_pool_352, "filter", [Callable(self, "_f86").bind(_s169)])
		v_fresh_353 = _t471
		if (not J.t(J.len(v_fresh_353))):
			v_fresh_353 = v_pool_352
	v_unseen_354 = J.mc(v_fresh_353, "filter", [Callable(self, "_f87").bind(_s169)])
	v_from_355 = (v_unseen_354 if J.t(J.len(v_unseen_354)) else v_fresh_353)
	return J.gp(v_from_355, floor(J.num((randf() * J.len(v_from_355)))))

func _f88(this_, a: Array, env):
	var v_sk_361 = null; var v_base_362 = null
	v_sk_361 = J.arg(a, 0)
	v_base_362 = {"style": J.gp(v_sk_361, "form"), "title": J.gp(v_sk_361, "title"), "lines": J.gp(v_sk_361, "lines")}
	if J.seq(J.gp(v_sk_361, "form"), "chat"):
		J.S_Object_("assign", [v_base_362, {"group": J.gp(v_sk_361, "group"), "av": J.gp(v_sk_361, "av")}])
	return v_base_362

func _f89(this_, a: Array, env):
	var v_sk_365 = null; var v_ch_366 = null; var v_o_367 = null; var v_r_368 = null
	v_sk_365 = J.arg(a, 0)
	v_ch_366 = J.arg(a, 1)
	var _t472 = (J.gp(v_sk_365, "choice") if J.t(v_ch_366) else v_ch_366)
	v_o_367 = (J.gp(J.gp(v_sk_365, "choice"), v_ch_366) if J.t(_t472) else _t472)
	var _t473 = (not J.t(v_o_367))
	if (_t473 if _t473 else (not J.t(J.gp(v_o_367, "give")))):
		return ""
	v_r_368 = J.mc(v_o_367, "give", [])
	var _t475 = null
	if J.t(v_r_368):
		var _t474 = J.G.get("give")
		_t475 = J.cl(_t474, null, [v_r_368])
	else:
		_t475 = ""
	return _t475

func _f91(this_, a: Array, env):
	var v_k_376 = null
	v_k_376 = J.arg(a, 0)
	return J.seq(J.gp(v_k_376, "id"), env["sk"])

func _f92(this_, a: Array, env):
	var v_res_377 = null; var v_txt_378 = null; var v_e_379 = null
	v_res_377 = J.arg(a, 0)
	if J.t(env["s"]):
		var _t477 = J.gp(env["s"], "seen")
		var _t478 = J.gp(env["sk"], "id")
		J.sp(_t477, _t478, 1.0)
		var _t479 = J.gp(env["s"], "cyc")
		var _t480 = J.gp(env["sk"], "id")
		J.sp(_t479, _t480, 1.0)
		var _t481 = env["s"]
		var _t482 = J.gp(env["sk"], "id")
		J.sp(_t481, "last", _t482)
		var _t483 = env["s"]
		J.sp(_t483, "n", J.num(J.gp(_t483, "n")) + 1.0)
	var _t484 = (not J.t(env["replay"]))
	var _t485 = (env["first"] if _t484 else _t484)
	var _t486 = (v_res_377 if J.t(_t485) else _t485)
	var _t487 = ((not J.t(J.gp(v_res_377, "skipped"))) if J.t(_t486) else _t486)
	if J.t((J.gp(v_res_377, "choice") if J.t(_t487) else _t487)):
		var _t488 = env["__p"]["reward"]
		v_txt_378 = J.cl(_t488, null, [env["sk"], J.gp(v_res_377, "choice")])
		if J.t(v_txt_378):
			J.mc(J.G.get("Fx"), "toast", [("陰間日常：<b>" + J.str(v_txt_378) + "</b>")])
		if J.t(J.gp(J.G.get("UI"), "refresh")):
			J.mc(J.G.get("UI"), "refresh", [])
	J.cl(J.G.get("save"), null, [])

func _f93(this_, a: Array, env):
	var _t490 = env["finish"]
	return J.cl(_t490, null, [{"skipped": false}])

func _f90(this_, a: Array, env):
	var _s176 = {"__p": env, "sk": null, "replay": null, "s": null, "first": null, "finish": null}
	_s176["sk"] = J.arg(a, 0)
	_s176["replay"] = J.arg(a, 1)
	if J.seq(J.typeof_(_s176["sk"]), "string"):
		var _t476 = J.mc(J.G.get("SKITS"), "find", [Callable(self, "_f91").bind(_s176)])
		_s176["sk"] = _t476
	if (not J.t(_s176["sk"])):
		return false
	_s176["s"] = J.cl(_s176["__p"]["st"], null, [])
	_s176["first"] = ((not J.t(J.gp(J.gp(_s176["s"], "seen"), J.gp(_s176["sk"], "id")))) if J.t(_s176["s"]) else _s176["s"])
	_s176["finish"] = Callable(self, "_f92").bind(_s176)
	if J.t(J.gp(_s176["sk"], "form")):
		var _t489 = _s176["__p"]["storyScene"]
		J.mc(J.G.get("Story"), "queue", [J.cl(_t489, null, [_s176["sk"]]), Callable(self, "_f93").bind(_s176)])
		return true
	J.mc(J.G.get("Theater"), "play", [{"tag": "陰間日常", "title": J.gp(_s176["sk"], "title"), "bg": J.gp(_s176["sk"], "bg"), "cast": J.gp(_s176["sk"], "cast"), "lines": J.gp(_s176["sk"], "lines"), "choice": J.gp(_s176["sk"], "choice")}, _s176["finish"]])
	return true

func _f94(this_, a: Array, env):
	var v_s_382 = null; var v_bat_383 = null; var v_sk_384 = null
	v_s_382 = J.cl(env["st"], null, [])
	if (not J.t(v_s_382)):
		return null
	var _t491 = (not J.seq(J.typeof_(J.G.get("Battle")), "undefined"))
	v_bat_383 = (J.gp(J.G.get("Battle"), "active") if _t491 else _t491)
	if J.t(((not J.t(v_bat_383)) if J.t(env["wasBattle"]) else env["wasBattle"])):
		var _t492 = J.max_([J.gp(v_s_382, "act"), J.sub(J.gp(v_s_382, "next"), 25.0)])
		J.sp(v_s_382, "act", _t492)
	env["wasBattle"] = v_bat_383
	if (not J.t(J.cl(env["quiet"], null, []))):
		return null
	if (J.sub(J.S_Date_("now", []), env["lastInput"]) > 40000.0):
		return null
	var _t493 = J.add(J.gp(v_s_382, "act"), 1.0)
	J.sp(v_s_382, "act", _t493)
	var _t494 = (not J.seq(J.typeof_(J.G.get("Rivals")), "undefined"))
	if J.t((J.mc(J.G.get("Rivals"), "tick", []) if _t494 else _t494)):
		var _t495 = J.min_([J.gp(v_s_382, "act"), J.max_([0.0, J.sub(J.gp(v_s_382, "next"), 90.0)])])
		J.sp(v_s_382, "act", _t495)
		return null
	if J.cmp(J.gp(v_s_382, "act"), J.gp(v_s_382, "next"), ">="):
		v_sk_384 = J.cl(env["pickNext"], null, [])
		J.sp(v_s_382, "act", 0.0)
		var _t496 = (170.0 + floor(J.num((randf() * 110.0))))
		J.sp(v_s_382, "next", _t496)
		if J.t(v_sk_384):
			var _t497 = env["play"]
			J.cl(_t497, null, [v_sk_384])

func _f95(this_, a: Array, env):
	var v_sec_387 = null; var v_s_388 = null
	v_sec_387 = J.arg(a, 0)
	v_s_388 = J.cl(env["st"], null, [])
	if J.t(v_s_388):
		var _t498 = J.max_([J.gp(v_s_388, "act"), J.sub(J.gp(v_s_388, "next"), v_sec_387)])
		J.sp(v_s_388, "act", _t498)

func _f98(this_, a: Array, env):
	var v_raw_397 = null; var v_m_398 = null
	v_raw_397 = J.arg(a, 0)
	var _t503 = J.seq(J.typeof_(v_raw_397), "string")
	v_m_398 = (J.mc(v_raw_397, "match", [J.re("^(\\d\\d:\\d\\d)\\|(.*)$", "")]) if _t503 else _t503)
	var _t507 = null
	if J.t(v_m_398):
		var _t505 = J.add(J.gp(v_m_398, 1.0), "|")
		var _t504 = J.G.get("L")
		_t507 = J.add(_t505, J.cl(_t504, null, [J.gp(v_m_398, 2.0)]))
	else:
		var _t506 = J.G.get("L")
		_t507 = J.cl(_t506, null, [v_raw_397])
	return _t507

func _f99(this_, a: Array, env):
	var v_l_399 = null
	v_l_399 = J.arg(a, 0)
	var _t510 = J.gp(v_l_399, 0.0)
	var _t509 = env["tr"]
	var _t511 = [_t510, J.cl(_t509, null, [J.gp(v_l_399, 1.0)])]
	return J.mc(_t511, "concat", [J.mc(v_l_399, "slice", [2.0])])

func _f97(this_, a: Array, env):
	var v_c_395 = null
	v_c_395 = J.gp(this_, "cur")
	var _t501 = (J.gp(v_c_395, "sc") if J.t(v_c_395) else v_c_395)
	if J.t((J.gp(J.gp(v_c_395, "sc"), "lines") if J.t(_t501) else _t501)):
		var _s193 = {"__p": env, "tr": null}
		if (not J.t(J.gp(v_c_395, "orig"))):
			var _t502 = J.gp(v_c_395, "sc")
			J.sp(v_c_395, "orig", _t502)
		_s193["tr"] = Callable(self, "_f98").bind(_s193)
		var _t512 = {}
		var _t513 = J.gp(v_c_395, "orig")
		var _t508 = J.gp(J.gp(v_c_395, "orig"), "lines")
		var _t514 = J.S_Object_("assign", [_t512, _t513, {"lines": J.mc(_t508, "map", [Callable(self, "_f99").bind(_s193)])}])
		J.sp(v_c_395, "sc", _t514)
	return J.mc(env["osl"], "apply", [this_, a])

func _f100(this_, a: Array, env):
	var _t516 = J.S_Date_("now", [])
	env["__p"]["lastInput"] = _t516

func _f101(this_, a: Array, env):
	var v_ev_400 = null
	v_ev_400 = J.arg(a, 0)
	return J.S_document_("addEventListener", [v_ev_400, env["mark"], true])

func _f102(this_, a: Array, env):
	var v_r_404 = null
	v_r_404 = J.mc(env["oc"], "apply", [this_, a])
	var _t520 = env["__p"]["__p"]["nudge"]
	J.cl(_t520, null, [35.0])
	return v_r_404

func _f103(this_, a: Array, env):
	var v_r_408 = null; var v_e_409 = null
	v_r_408 = J.mc(env["os"], "apply", [this_, a])
	J.mc(J.G.get("Skits"), "storyHook", [])
	return v_r_408

func _f96(this_, a: Array, env):
	var _s190 = {"__p": env, "mark": null}
	if J.t(_s190["__p"]["started"]):
		return null
	_s190["__p"]["started"] = true
	var _t499 = (not J.seq(J.typeof_(J.G.get("Story")), "undefined"))
	if J.t((J.gp(J.G.get("Story"), "showLine") if _t499 else _t499)):
		var _s191 = {"__p": _s190, "osl": null}
		_s191["osl"] = J.gp(J.G.get("Story"), "showLine")
		var _t500 = J.G.get("Story")
		var _t515 = Callable(self, "_f97").bind(_s191)
		J.sp(_t500, "showLine", _t515)
	_s190["mark"] = Callable(self, "_f100").bind(_s190)
	var _t517 = ["pointerdown", "keydown", "wheel"]
	J.mc(_t517, "forEach", [Callable(self, "_f101").bind(_s190)])
	J.F_setInterval([_s190["__p"]["tick"], 1000.0])
	var _t518 = (not J.seq(J.typeof_(J.G.get("Quest")), "undefined"))
	if J.t((J.gp(J.G.get("Quest"), "complete") if _t518 else _t518)):
		var _s198 = {"__p": _s190, "oc": null}
		_s198["oc"] = J.gp(J.G.get("Quest"), "complete")
		var _t519 = J.G.get("Quest")
		var _t521 = Callable(self, "_f102").bind(_s198)
		J.sp(_t519, "complete", _t521)
	var _t522 = (not J.seq(J.typeof_(J.G.get("UI")), "undefined"))
	if J.t((J.gp(J.G.get("UI"), "openStory") if _t522 else _t522)):
		var _s200 = {"__p": _s190, "os": null}
		_s200["os"] = J.gp(J.G.get("UI"), "openStory")
		var _t523 = J.G.get("UI")
		var _t524 = Callable(self, "_f103").bind(_s200)
		J.sp(_t523, "openStory", _t524)

func _f105(this_, a: Array, env):
	var v_k_417 = null
	v_k_417 = J.arg(a, 0)
	return J.gp(J.gp(env["s"], "seen"), J.gp(v_k_417, "id"))

func _f106(this_, a: Array, env):
	var v_k_418 = null
	v_k_418 = J.arg(a, 0)
	var _t526 = J.gp(v_k_418, "id")
	var _t525 = J.G.get("L")
	return ("<button class=\"btn wide\" data-skit=\"" + J.str(_t526) + "\">" + J.str(J.cl(_t525, null, [J.gp(v_k_418, "title")])) + "</button>")

func _f109(this_, a: Array, env):
	var _t535 = env["__p"]["__p"]["play"]
	return J.cl(_t535, null, [J.gp(J.gp(env["b"], "dataset"), "skit"), true])

func _f108(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.F_setTimeout([Callable(self, "_f109").bind(env), 60.0])

func _f107(this_, a: Array, env):
	var _s208 = {"__p": env, "b": null}
	_s208["b"] = J.arg(a, 0)
	var _t534 = _s208["b"]
	var _t536 = Callable(self, "_f108").bind(_s208)
	J.sp(_t534, "onclick", _t536)
	return _t536

func _f104(this_, a: Array, env):
	var v_body_412 = null; var v_hr_413 = null; var v_list_415 = null; var v_div_416 = null
	var _s205 = {"__p": env, "s": null}
	v_body_412 = J.S_document_("querySelector", ["#sheet .sh-body"])
	v_hr_413 = (J.mc(v_body_412, "querySelector", ["hr"]) if J.t(v_body_412) else v_body_412)
	if (not J.t(v_hr_413)):
		return null
	_s205["s"] = J.cl(_s205["__p"]["st"], null, [])
	v_list_415 = J.mc(J.G.get("SKITS"), "filter", [Callable(self, "_f105").bind(_s205)])
	v_div_416 = J.S_document_("createElement", ["div"])
	var _t529 = J.len(v_list_415)
	var _t530 = J.len(J.G.get("SKITS"))
	var _t527 = J.mc(v_list_415, "map", [Callable(self, "_f106").bind(_s205)])
	var _t528 = J.mc(_t527, "join", [""])
	var _t531 = ("<h4 class=\"stand-h\">陰間日常</h4><p class=\"desc\">在村子裡玩，偶爾會上演一段。看過的可以在這裡重溫（" + J.str(_t529) + "/" + J.str(_t530) + "）。</p><div class=\"slist\">" + J.str((_t528 if J.t(_t528) else "<p class=\"desc\">還沒看過。在村子裡多玩一會兒。</p>")) + "</div>")
	J.sp(v_div_416, "innerHTML", _t531)
	var _t532 = J.gp(v_hr_413, "parentNode")
	J.mc(_t532, "insertBefore", [v_div_416, v_hr_413])
	var _t533 = J.mc(v_div_416, "querySelectorAll", ["[data-skit]"])
	J.mc(_t533, "forEach", [Callable(self, "_f107").bind(_s205)])

func _f79(this_, a: Array, env):
	var v_id_337 = null
	v_id_337 = J.arg(a, 0)
	var _t537 = (J.gp(J.G.get("S"), "seen") if J.t(J.G.get("S")) else J.G.get("S"))
	return (not (not J.t((J.gp(J.gp(J.G.get("S"), "seen"), v_id_337) if J.t(_t537) else _t537))))

func _f77(this_, a: Array, env):
	var v_init_332 = null; var v_storyHook_333 = null
	var _s160 = {"__p": env, "OVERLAYS": null, "lastInput": null, "wasBattle": null, "started": null, "st": null, "seen": null, "artOk": null, "ok": null, "quiet": null, "pickNext": null, "storyScene": null, "reward": null, "play": null, "tick": null, "nudge": null}
	_s160["st"] = Callable(self, "_f78").bind(_s160)
	_s160["artOk"] = Callable(self, "_f80").bind(_s160)
	_s160["ok"] = Callable(self, "_f82").bind(_s160)
	_s160["quiet"] = Callable(self, "_f83").bind(_s160)
	_s160["pickNext"] = Callable(self, "_f84").bind(_s160)
	_s160["storyScene"] = Callable(self, "_f88").bind(_s160)
	_s160["reward"] = Callable(self, "_f89").bind(_s160)
	_s160["play"] = Callable(self, "_f90").bind(_s160)
	_s160["tick"] = Callable(self, "_f94").bind(_s160)
	_s160["nudge"] = Callable(self, "_f95").bind(_s160)
	v_init_332 = Callable(self, "_f96").bind(_s160)
	v_storyHook_333 = Callable(self, "_f104").bind(_s160)
	_s160["OVERLAYS"] = ["#sheet", "#battle", "#scare", "#world", "#gyard", "#gstreet", "#dlg", "#phone", "#title", "#su-pick", "#webov"]
	_s160["lastInput"] = 0.0
	_s160["wasBattle"] = false
	_s160["started"] = false
	_s160["seen"] = Callable(self, "_f79").bind(_s160)
	return {"st": _s160["st"], "ok": _s160["ok"], "play": _s160["play"], "tick": _s160["tick"], "nudge": _s160["nudge"], "init": v_init_332, "storyHook": v_storyHook_333, "pickNext": _s160["pickNext"], "quiet": _s160["quiet"], "list": J.G.get("SKITS")}
