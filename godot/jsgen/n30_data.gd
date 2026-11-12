# 自動轉譯自 n30_data.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["N30G"] = Callable(self, "_f1").bind(env)
	J.G["N30_SITES"] = {"field": {"name": "槐林荒村", "bg": "field", "gate": null, "fod": ["youhun", "egui"], "desc": "本地的老街坊：民間口中的「乜乜鬼」。"}, "road": {"name": "南下古道", "bg": "road", "gate": null, "fod": ["zombie", "xiaogui"], "desc": "從古書和傳說裡走出來的中國鬼怪。"}, "kampung": {"name": "甘榜夜路", "bg": "kampung", "gate": "2-3", "fod": ["xiaogui", "shuigui"], "desc": "馬來與爪哇的鄉野傳說。"}, "banana": {"name": "香蕉園外", "bg": "banana", "gate": "4-3", "fod": ["shuigui", "zhiren"], "desc": "泰國、印度、菲律賓、愛爾蘭漂來的「番鬼」。"}, "night": {"name": "冥街夜市・暗巷", "bg": "street", "gate": null, "fod": ["zhiren", "xiaogui"], "desc": "日本妖怪：在夜市暗巷碰到，請佢食宵夜就跟你走。"}, "death": {"name": "橫死路口", "bg": "road", "gate": null, "fod": ["youhun", "zhiren"], "desc": "各種死法的意外鬼（本作原創）：每日路口輪流有兩隻，亂葬崗也偶然碰到。"}}
	J.G["N30_TIER"] = {"1": {"gate": "1-3", "p": 6.0, "req": 7.0, "en": [1.7, 1.25], "k": 1.0}, "2": {"gate": "3-3", "p": 13.0, "req": 11.0, "en": [2.3, 1.35], "k": 1.25}, "3": {"gate": "5-3", "p": 19.0, "req": 14.0, "en": [2.9, 1.5], "k": 1.15}}
	J.G["N30_G"] = {}
	var _t8 = J.G.get("N30G")
	J.cl(_t8, null, ["qionggui", 1.0, "field", "窮鬼", "一身補丁", [30.0, 55.0, 55.0], {"name": "空袋飛蛾", "kind": "aoe", "mult": 0.7, "sap": 20.0, "desc": "翻出空口袋，飛蛾撲向全場，削掉敵人能量。"}, "去冥街買嘢永遠要講價。", "民間年初有「送窮」的習俗，韓愈寫過《送窮文》，要送走的就是窮鬼。", "借住先，有錢即刻還……應該。"])
	var _t9 = J.G.get("N30G")
	J.cl(_t9, null, ["danxiao", 1.0, "field", "膽小鬼", "自己是鬼都驚鬼", [35.0, 45.0, 60.0], {"name": "閉眼亂揮", "kind": "hit", "mult": 1.3, "hits": 3.0, "apply": "push", "desc": "閉著眼亂揮三下，誤打誤撞嚇退敵人。"}, "晚上唔肯一個人去廁所。", "「膽小鬼」本來是罵人無膽的俗語；本作把這句說話變成一隻真的鬼。", "你、你唔好嚇我呀……"])
	var _t10 = J.G.get("N30G")
	J.cl(_t10, null, ["maoshi", 1.0, "field", "冒失鬼", "永遠在跌倒", [55.0, 30.0, 60.0], {"name": "跌倒頭槌", "kind": "hit", "mult": 1.5, "apply": "down", "desc": "絆倒撲過去一頭撞中，敵人腳軟。"}, "派佢搬嘢，十件爛三件。", "「冒失鬼」是形容做事魯莽的人的俗語；本作把它變成一隻真的鬼。", "唔好意思！我唔係故意㗎！"])
	var _t11 = J.G.get("N30G")
	J.cl(_t11, null, ["yangui", 1.0, "field", "煙鬼", "咳不停", [35.0, 60.0, 50.0], {"name": "煙圈套頭", "kind": "hit", "mult": 1.4, "sap": 25.0, "desc": "吐出大煙圈套住敵人的頭，嗆到削掉能量。"}, "叫佢唔好喺倉庫食煙，佢話「最後一口」。", "「煙鬼」是對煙癮很大的人的俗稱；本作把這個說法變成一隻真的鬼。", "咳咳……冇事，食多口就好。"])
	var _t12 = J.G.get("N30G")
	J.cl(_t12, null, ["jiugui", 1.0, "field", "酒鬼", "臉紅紅", [60.0, 25.0, 60.0], {"name": "醉漢撲撞", "kind": "hit", "mult": 1.6, "apply": "push", "desc": "醉醺醺整個撲過去，撞開敵人。"}, "酒埕抱得比命還緊（雖然命已經冇咗）。", "「酒鬼」是對嗜酒的人的俗稱；本作把這個說法變成一隻真的鬼。", "嗝～飲多杯先講啦！"])
	var _t13 = J.G.get("N30G")
	J.cl(_t13, null, ["dugui", 2.0, "field", "賭鬼", "輸到只剩短褲", [55.0, 65.0, 80.0], {"name": "梭哈", "kind": "hit", "mult": 1.6, "hits": 3.0, "steal": 25.0, "desc": "骰子加飛牌連打三下，順手贏走冥幣。"}, "派佢管數？你夠膽就試吓。", "「賭鬼」是對嗜賭的人的俗稱；本作把這個說法變成一隻真的鬼。", "今鋪一定翻本！"])
	var _t14 = J.G.get("N30G")
	J.cl(_t14, null, ["guhangui", 2.0, "field", "孤寒鬼", "一毛不拔", [60.0, 75.0, 65.0], {"name": "算盤摑", "kind": "hit", "mult": 1.5, "steal": 40.0, "desc": "算盤一摑，算珠彈飛，還要你賠錢。"}, "一個銅錢都要咬一啖驗真假。", "粵語「孤寒」即吝嗇；本作把「孤寒鬼」這句罵人說話變成一隻真的鬼。", "計清楚先，一毫都唔可以少。"])
	var _t15 = J.G.get("N30G")
	J.cl(_t15, null, ["taozhai", 2.0, "field", "討債鬼", "拿欠單上門追數", [70.0, 40.0, 65.0], {"name": "紅油潑門", "kind": "hit", "mult": 1.7, "apply": "down", "sap": 20.0, "desc": "紅油一潑，敵人滑倒、氣到洩氣。"}, "欠單上面每個名都係真嘅。", "民間說法：前世被欠債的人投胎來討債，多用來講敗家的子女。", "還錢！今日唔還，聽日再嚟！"])
	var _t16 = J.G.get("N30G")
	J.cl(_t16, null, ["diaosi", 2.0, "field", "吊死鬼", "長舌垂到胸口", [50.0, 60.0, 80.0], {"name": "長舌鞭", "kind": "hit", "mult": 1.7, "apply": "air", "desc": "舌頭從頭頂抽下來，把敵人抽到嚇彈起。"}, "條脷長過我條命，講嘢成日咬親。", "民間傳說上吊而死的人化成的鬼，形象是吐出長舌、頸上掛著繩。", "條繩……唔好掂佢。"])
	var _t17 = J.G.get("N30G")
	J.cl(_t17, null, ["wutou", 1.0, "road", "無頭鬼", "手捧自己的頭", [60.0, 35.0, 55.0], {"name": "人頭保齡球", "kind": "aoe", "mult": 0.75, "apply": "down", "desc": "自己個頭當保齡球滾過去，全場腳軟。"}, "睇路靠手上個頭，所以成日撞牆。", "民間傳說被斬首而死的鬼，常常捧著自己的頭出現。", "你見唔見到我個頭？喺我手度。"])
	var _t18 = J.G.get("N30G")
	J.cl(_t18, null, ["changgui", 1.0, "road", "倀鬼", "為虎作倀", [40.0, 50.0, 65.0], {"name": "喚虎撲", "kind": "hit", "mult": 1.5, "follow": "down", "desc": "吹口哨，小老虎撲上去；對腳軟目標追擊。"}, "隻老虎唔肯打工，佢自己頂上。", "傳說被老虎吃掉的人化成倀鬼，反過來替老虎引路害人，就是成語「為虎作倀」。", "大佬，嗰邊有肉！"])
	var _t19 = J.G.get("N30G")
	J.cl(_t19, null, ["guixinniang", 2.0, "road", "鬼新娘", "冥婚的紅衣新娘", [40.0, 85.0, 70.0], {"name": "拋繡球", "kind": "aoe", "mult": 0.9, "apply": "air", "desc": "繡球拋過去，全場敵人嚇彈起。"}, "每晚都喺村口等，唔知等緊邊個。", "民間冥婚習俗裡的亡故新娘，穿紅嫁衣、蓋紅蓋頭。", "良辰吉時，你都嚟埋啦。"])
	var _t20 = J.G.get("N30G")
	J.cl(_t20, null, ["baigujing", 2.0, "road", "白骨精", "白骨化成的妖婦", [50.0, 85.0, 75.0], {"name": "飛吻骷髏", "kind": "hit", "mult": 1.6, "drain": 0.35, "desc": "送出飛吻變骷髏咬一口，吸回血量。"}, "每日照鏡三個鐘。", "《西遊記》裡由白骨化成的妖精，三次變化騙唐僧，被孫悟空三打。", "人哋只係想食少少唐僧肉啫。"])
	var _t21 = J.G.get("N30G")
	J.cl(_t21, null, ["shanxiao", 2.0, "road", "山魈", "獨腳山精", [80.0, 30.0, 80.0], {"name": "單腳長臂掃", "kind": "hit", "mult": 1.6, "hits": 2.0, "follow": "air", "desc": "單腳跳過去、長臂掃兩下；對嚇彈起目標追擊。"}, "最驚過年：一聽到爆竹就躲上樹。", "古籍裡的山中精怪，傳說只有一隻腳；《荊楚歲時記》說新年燒爆竹就是為了嚇走它。", "唔好燒爆竹呀！"])
	var _t22 = J.G.get("N30G")
	J.cl(_t22, null, ["yecha", 3.0, "road", "夜叉", "青面獠牙", [100.0, 25.0, 95.0], {"name": "鋼叉突刺", "kind": "hit", "mult": 1.8, "apply": "push", "follow": "down", "desc": "一步踏前直刺，嚇退敵人；對腳軟目標追擊。"}, "把鋼叉每晚都要擦三次。", "源自佛教的鬼神（梵語 yakṣa），民間形象青面獠牙，手持鋼叉。", "邊個夠膽過我條叉？"])
	var _t23 = J.G.get("N30G")
	J.cl(_t23, null, ["hanba", 3.0, "road", "旱魃", "所到之處大旱", [70.0, 60.0, 95.0], {"name": "熱浪", "kind": "aoe", "mult": 1.1, "sap": 15.0, "desc": "推出一波波熱浪烤全場，敵人熱到洩氣。"}, "佢一嚟，糯米田就乾晒。", "古代傳說中引起旱災的怪物，《詩經》有「旱魃為虐」；後世說是屍變而成。", "好熱……有冇凍檸茶？"])
	var _t24 = J.G.get("N30G")
	J.cl(_t24, null, ["pelesit", 1.0, "kampung", "Pelesit", "蟋蟀形的使魔", [30.0, 45.0, 70.0], {"name": "跳咬", "kind": "hit", "mult": 1.5, "follow": "air", "desc": "彈起一大跳撲上去咬；對嚇彈起目標追擊。"}, "叫起上嚟成晚唧唧聲，冇鬼瞓得著。", "馬來傳說中蟋蟀模樣的使魔，常和 Polong 一起被主人派出去。", "唧唧！唧唧唧！"])
	var _t25 = J.G.get("N30G")
	J.cl(_t25, null, ["polong", 1.0, "kampung", "Polong", "養在瓶子裡的鬼", [35.0, 60.0, 55.0], {"name": "出瓶竄咬", "kind": "hit", "mult": 1.4, "drain": 0.3, "desc": "從瓶口竄出去咬一口，吸血回來。"}, "要人捧住個瓶先肯郁。", "馬來傳說養在瓶子裡的使魔，主人用自己手指的血餵養，再派它去害人。", "捧穩個樽呀，唔好打爛！"])
	var _t26 = J.G.get("N30G")
	J.cl(_t26, null, ["jenglot", 1.0, "kampung", "Jenglot", "長髮長指甲的小乾屍", [40.0, 50.0, 60.0], {"name": "轉身甩髮", "kind": "aoe", "mult": 0.8, "apply": "push", "desc": "原地一轉，長髮掃開全場。"}, "頭髮比個身長三倍，洗頭要洗成晚。", "印尼和馬來世界傳說中的小乾屍，長髮長指甲，據說要用血供養。", "嘶……唔好掂我啲頭髮。"])
	var _t27 = J.G.get("N30G")
	J.cl(_t27, null, ["hantugalah", 2.0, "kampung", "Hantu Galah", "高得像竹竿", [55.0, 55.0, 75.0], {"name": "高處彈額頭", "kind": "hit", "mult": 1.6, "apply": "down", "desc": "一步跨過去，從高處彎腰彈額頭，彈到腳軟。"}, "倉庫最高嗰格佢一伸手就攞到。", "馬來傳說中高瘦得像竹竿的鬼，galah 在馬來語就是長竿。", "你望咩呀？望上啲。"])
	var _t28 = J.G.get("N30G")
	J.cl(_t28, null, ["jerangkung", 2.0, "kampung", "Hantu Jerangkung", "骷髏鬼", [65.0, 55.0, 80.0], {"name": "骨頭迴旋鏢", "kind": "hit", "mult": 1.6, "hits": 2.0, "desc": "拆下前臂丟出去，打中再飛回來，一共兩下。"}, "行路成日跌甩骨，要自己執返。", "馬來傳說中的骷髏鬼，jerangkung 在馬來語就是骷髏。", "喀喀……等我裝返隻手先。"])
	var _t29 = J.G.get("N30G")
	J.cl(_t29, null, ["bunian", 2.0, "kampung", "Orang Bunian", "隱身森林的精靈族", [45.0, 85.0, 75.0], {"name": "隱身繞後", "kind": "hit", "mult": 1.7, "sap": 30.0, "desc": "消失後在敵人背後出現，一拍削掉大量能量。"}, "派佢去伐木，砍完棵樹都冇人見過佢。", "馬來傳說中住在森林裡、凡人看不見的隱形族人。", "你睇唔到我，但我一直喺度。"])
	var _t30 = J.G.get("N30G")
	J.cl(_t30, null, ["hanturaya", 3.0, "kampung", "Hantu Raya", "主人的大黑影", [94.0, 40.0, 76.0], {"name": "黑影壓頂", "kind": "aoe", "mult": 1.1, "apply": "down", "desc": "黑影漲高罩落全場，敵人腳軟。"}, "佢會扮成主人去打工，所以打卡記錄好亂。", "馬來傳說中由主人供養的強大使魔，能化成主人的模樣做事，主人死前要把它傳給別人。", "主人叫我做咩，我就做咩。"])
	var _t31 = J.G.get("N30G")
	J.cl(_t31, null, ["genderuwo", 3.0, "kampung", "Genderuwo", "滿身毛的大猩猩鬼", [102.0, 25.0, 82.0], {"name": "跳起搥地", "kind": "hit", "mult": 1.9, "apply": "air", "desc": "跳起雙拳搥地，把敵人震到嚇彈起。"}, "鍾意捉弄人，成日收埋人隻拖鞋。", "爪哇傳說中渾身是毛、像大猩猩的鬼怪，喜歡捉弄人。", "吼！邊個收埋咗我隻蕉？"])
	var _t32 = J.G.get("N30G")
	J.cl(_t32, null, ["phiam", 1.0, "banana", "Phi Am", "坐在胸口的鬼", [70.0, 30.0, 50.0], {"name": "鬼壓床", "kind": "hit", "mult": 1.4, "apply": "down", "sap": 15.0, "desc": "一屁股坐下去，敵人腳軟動彈不得。"}, "派佢去顧倉，佢坐喺度瞓著咗。", "泰國傳說坐在睡著的人胸口的鬼，也就是「鬼壓床」。", "借個胸口坐吓啫，唔使咁驚。"])
	var _t33 = J.G.get("N30G")
	J.cl(_t33, null, ["churel", 2.0, "banana", "Churel", "雙腳是反的", [60.0, 60.0, 85.0], {"name": "反腳倒衝", "kind": "hit", "mult": 1.6, "apply": "push", "follow": "push", "desc": "倒著衝過去一頂，嚇退敵人；對被嚇退的目標追擊。"}, "佢行去邊，腳印就指住反方向。", "印度和南亞傳說中，難產或分娩時死去的女人化成的鬼，雙腳是反的。", "跟住我啲腳印行？你會行錯路喎。"])
	var _t34 = J.G.get("N30G")
	J.cl(_t34, null, ["tikbalang", 2.0, "banana", "Tikbalang", "馬頭長腿怪", [70.0, 35.0, 72.0], {"name": "轉身馬後踢", "kind": "hit", "mult": 1.7, "apply": "air", "desc": "轉身一記後踢，把敵人踢上半空。"}, "帶佢出門一定蕩失路。", "菲律賓傳說中馬頭長腿的山林精怪，會讓旅人迷路。", "條路？我帶你行……行到天光。"])
	var _t35 = J.G.get("N30G")
	J.cl(_t35, null, ["maenak", 2.0, "banana", "Mae Nak", "泰國的鬼妻", [55.0, 75.0, 80.0], {"name": "長臂抓", "kind": "hit", "mult": 1.5, "follow": "down", "drain": 0.25, "desc": "手臂一直伸長抓住敵人；對腳軟目標追擊，吸回血量。"}, "每晚都喺門口等老公收工。", "泰國最有名的鬼故事：Mae Nak 難產死後仍在家等丈夫 Mak，曾把手臂伸長去撿掉到屋下的檸檬。", "Mak 收工未呀？"])
	var _t36 = J.G.get("N30G")
	J.cl(_t36, null, ["aswang", 3.0, "banana", "Aswang", "菲律賓的變形食屍鬼", [65.0, 60.0, 95.0], {"name": "長舌吸血", "kind": "hit", "mult": 1.8, "drain": 0.45, "desc": "舌頭像吸管一樣插住，吸走大量血量。"}, "白天好正常，一入夜就變樣。", "菲律賓傳說中白天像普通人、晚上變形害人的鬼怪，用細長的舌頭吸食。", "日頭我係普通人嚟㗎。"])
	var _t37 = J.G.get("N30G")
	J.cl(_t37, null, ["vetala", 3.0, "banana", "Vetala", "倒掛的屍鬼", [70.0, 80.0, 85.0], {"name": "倒吊驚嚇", "kind": "hit", "mult": 1.7, "apply": "down", "sap": 30.0, "desc": "倒吊從天而降臉貼臉大叫，嚇到敵人腳軟、能量清走一截。"}, "鍾意出謎題，答錯就唔放你走。", "印度傳說附在屍體上的鬼，倒掛在樹上；故事集《僵屍鬼故事二十五則》裡它不停給國王出謎題。", "估吓先：乜嘢越洗越污糟？"])
	var _t38 = J.G.get("N30G")
	J.cl(_t38, null, ["banshee", 3.0, "banana", "Banshee", "愛爾蘭的報喪女妖", [55.0, 90.0, 90.0], {"name": "報喪尖叫", "kind": "aoe", "mult": 1.0, "apply": "push", "follow": "down", "desc": "一聲尖叫震開全場；對腳軟目標追擊。"}, "佢一開口，成條村都要掩住耳。", "愛爾蘭傳說中的報喪女妖，她一哭嚎，家裡就會有人死。", "啊——！……唔好意思，習慣咗。"])
	var _t39 = J.G.get("N30G")
	J.cl(_t39, null, ["kasaobake", 1.0, "night", "唐傘妖", "一隻眼一隻腳的舊雨傘", [35.0, 55.0, 55.0], {"name": "跳過去舔", "kind": "hit", "mult": 1.4, "apply": "push", "desc": "單腳跳過去，長舌一舔，敵人嚇到退開。"}, "落雨天特別興奮。", "日本「付喪神」的一種：舊雨傘用久了化成的妖怪，一隻眼、一隻腳、伸長舌頭。", "落雨喇！帶埋我出街啦！"])
	var _t40 = J.G.get("N30G")
	J.cl(_t40, null, ["chochin", 1.0, "night", "提燈妖", "破燈籠張開大嘴", [40.0, 60.0, 50.0], {"name": "噴火咬", "kind": "hit", "mult": 1.4, "hits": 2.0, "desc": "張開大嘴咬兩下，噴出一團火。"}, "夜市冇電，全靠佢照住。", "日本「付喪神」的一種：舊燈籠裂開變成大嘴、伸出舌頭的妖怪。", "要唔要我照你返屋企？"])
	var _t41 = J.G.get("N30G")
	J.cl(_t41, null, ["kappa", 1.0, "night", "河童", "頭頂盤子", [55.0, 40.0, 55.0], {"name": "鞠躬潑水", "kind": "hit", "mult": 1.4, "apply": "down", "desc": "禮貌地鞠躬，頭頂的水潑過去，敵人滑倒。"}, "收工要食三條青瓜。", "日本傳說住在河川的妖怪，頭頂的碟子乾了就會沒力，最愛吃青瓜。", "有冇青瓜呀？"])
	var _t42 = J.G.get("N30G")
	J.cl(_t42, null, ["nopperabo", 2.0, "night", "無臉鬼", "臉上什麼都沒有", [65.0, 65.0, 75.0], {"name": "公事包上勾", "kind": "hit", "mult": 1.6, "apply": "air", "desc": "公事包一記上勾，敵人飛上半空。"}, "朝九晚五，從來冇遲到過（除咗今日）。", "日本傳說中臉上什麼都沒有的妖怪（のっぺらぼう），專門嚇夜歸人。", "我個樣係咪好普通？"])
	var _t43 = J.G.get("N30G")
	J.cl(_t43, null, ["rokurokubi", 2.0, "night", "轆轤首", "脖子可以伸很長", [60.0, 70.0, 80.0], {"name": "伸頸頭槌", "kind": "hit", "mult": 1.6, "follow": "air", "desc": "脖子伸長一頭撞過去；對嚇彈起目標追擊。"}, "晚上瞓覺個頭會周圍去。", "日本傳說晚上脖子會伸得很長的妖怪，外表是普通女人。", "唔好意思，我條頸瞓覺唔聽話。"])
	var _t44 = J.G.get("N30G")
	J.cl(_t44, null, ["kuchisake", 2.0, "night", "裂口女", "戴口罩的女人", [45.0, 70.0, 80.0], {"name": "剪刀咔嚓", "kind": "hit", "mult": 1.7, "hits": 2.0, "desc": "「我靚唔靚？」剪刀咔嚓兩下。"}, "最怕人答「麻麻地」。", "1979 年在日本流行的都市傳說：戴口罩的女人問路人「我漂亮嗎？」", "我靚唔靚？"])
	var _t45 = J.G.get("N30G")
	J.cl(_t45, null, ["yukionna", 3.0, "night", "雪女", "吐出冰霜的白衣女", [55.0, 95.0, 85.0], {"name": "吐冰霜", "kind": "aoe", "mult": 1.0, "apply": "down", "sap": 20.0, "desc": "呼出冰霧凍住全場，敵人腳軟、能量凍結一截。"}, "佢一入倉庫，啲壽包即刻變急凍。", "日本雪國傳說中的白衣女妖，暴風雪夜出現，呼出的氣能把人凍死。", "凍唔凍呀？我覺得啱啱好。"])
	var _t46 = J.G.get("N30G")
	J.cl(_t46, null, ["hannya", 3.0, "night", "般若", "嫉妒化成的鬼女", [70.0, 55.0, 100.0], {"name": "妒火暴衝", "kind": "hit", "mult": 1.9, "hits": 2.0, "apply": "push", "desc": "帶著殘影暴衝過去，雙爪交叉抓兩下並嚇退。"}, "見到人哋有新衫就會冒煙。", "日本能劇的鬼女面具，表現女人因嫉妒而化成的鬼，頭生雙角。", "點解佢有我冇？！"])
	var _t47 = J.G.get("N30G")
	J.cl(_t47, null, ["gashadokuro", 3.0, "night", "餓者髑髏", "巨大骷髏", [102.0, 25.0, 80.0], {"name": "巨手一拍", "kind": "aoe", "mult": 1.1, "follow": "air", "desc": "巨大骨手拍落全場；對嚇彈起目標追擊。"}, "一餐要食晒成個包子鋪。", "日本妖怪，由許多無人安葬的骸骨聚成的巨大骷髏。", "餓……好餓……"])
	var _t48 = J.G.get("N30G")
	J.cl(_t48, null, ["zipai", 1.0, "death", "自拍跌死鬼", "踩到香蕉皮", [40.0, 55.0, 55.0], {"name": "閃光滑鏟", "kind": "hit", "mult": 1.4, "apply": "down", "desc": "閃光燈一閃，再踩香蕉皮滑過去，鏟到敵人腳軟。"}, "死咗都要打卡。", "本作原創：為咗影一張靚相，退後一步踩中香蕉皮。到今日都未刪嗰張相。", "等等，再影多張！"])
	var _t49 = J.G.get("N30G")
	J.cl(_t49, null, ["xiaosi", 1.0, "death", "笑死鬼", "笑到停不下來", [35.0, 65.0, 50.0], {"name": "傳染的笑", "kind": "aoe", "mult": 0.7, "sap": 30.0, "desc": "爆笑傳染全場，敵人笑到洩氣。"}, "佢一笑，成條村都跟住笑。", "本作原創：睇棟篤笑笑到斷氣，笑容從此卸唔落嚟。", "哈哈哈……唔好再講喇！"])
	var _t50 = J.G.get("N30G")
	J.cl(_t50, null, ["yesi", 1.0, "death", "噎死鬼", "喉嚨卡著湯圓", [55.0, 35.0, 55.0], {"name": "湯圓子彈", "kind": "hit", "mult": 1.5, "apply": "push", "desc": "把卡著的湯圓咳出去，正中額頭嚇退。"}, "冬至最危險。", "本作原創：冬至一啖食晒三粒湯圓，從此對湯圓又愛又恨。", "唔……（指住喉嚨）"])
	var _t51 = J.G.get("N30G")
	J.cl(_t51, null, ["shidu", 1.0, "death", "食物中毒鬼", "臉發青", [45.0, 45.0, 55.0], {"name": "綠色臭屁", "kind": "aoe", "mult": 0.75, "apply": "push", "desc": "轉身一團綠雲，全場燻開。"}, "永遠攬住卷廁紙。", "本作原創：食咗隔夜三日嘅外賣，最後一程係喺廁所行完。", "廁所喺邊呀！"])
	var _t52 = J.G.get("N30G")
	J.cl(_t52, null, ["daji", 1.0, "death", "打機猝死鬼", "網吧通宵", [35.0, 60.0, 60.0], {"name": "手掣連段", "kind": "hit", "mult": 1.4, "hits": 4.0, "desc": "狂按手掣，按鍵連打四下。"}, "派佢打工？佢會問有冇 Wi-Fi。", "本作原創：網吧通宵打機打到最後一關，連 Game Over 都未見到。", "GG，再嚟過！"])
	var _t53 = J.G.get("N30G")
	J.cl(_t53, null, ["xiasi", 1.0, "death", "嚇死鬼", "頭髮全豎起", [40.0, 50.0, 60.0], {"name": "突然嚇你", "kind": "aoe", "mult": 0.75, "apply": "push", "sap": 10.0, "desc": "突然暴漲大叫，全場敵人嚇到彈開。"}, "佢自己都成日畀自己嚇親。", "本作原創：睇鬼片睇到一半，被貓跳上膊頭嚇死。", "哇！！……咦，原來係你。"])
	var _t54 = J.G.get("N30G")
	J.cl(_t54, null, ["chehuo", 2.0, "death", "車禍鬼", "安全帽裂開", [70.0, 40.0, 75.0], {"name": "催油門撞", "kind": "hit", "mult": 1.7, "apply": "push", "desc": "催油門衝過去，碰一聲撞開敵人。"}, "過馬路一定望三次（死後先學識）。", "本作原創：揸電單車趕外賣，綠燈都未轉。安全帽係保住咗嘅。", "叭叭！借借！"])
	var _t55 = J.G.get("N30G")
	J.cl(_t55, null, ["yezi", 2.0, "death", "椰子砸死鬼", "頭頂一個大包", [65.0, 55.0, 65.0], {"name": "小心頭頂", "kind": "hit", "mult": 1.6, "apply": "down", "desc": "抬頭一指，天上掉個椰子砸中，敵人腳軟。"}, "永遠唔肯企喺椰樹下面。", "本作原創：喺沙灘椰樹下面瞓午覺，瞓到永遠。", "小心頭頂呀！"])
	var _t56 = J.G.get("N30G")
	J.cl(_t56, null, ["liulian", 2.0, "death", "榴槤砸死鬼", "滿臉刺孔", [75.0, 40.0, 70.0], {"name": "丟榴槤", "kind": "hit", "mult": 1.7, "follow": "down", "desc": "從背後掏出榴槤甩過去；對腳軟目標追擊。"}, "身上永遠有陣榴槤味。", "本作原創：榴槤季喺樹下等跌落嚟嗰個，結果等到。", "貓山王嚟㗎，好香㗎！"])
	var _t57 = J.G.get("N30G")
	J.cl(_t57, null, ["zhongshu", 2.0, "death", "中暑鬼", "曬到通紅", [55.0, 70.0, 60.0], {"name": "烈日曬", "kind": "aoe", "mult": 0.9, "sap": 20.0, "desc": "一道烈日照落全場，敵人曬到洩氣。"}, "手上支雪條永遠食唔切。", "本作原創：大熱天時排隊買限量波鞋，排到最後一個。", "熱到溶呀……"])
	var _t58 = J.G.get("N30G")
	J.cl(_t58, null, ["chengsi", 2.0, "death", "撐死鬼", "吃自助餐撐爆", [90.0, 30.0, 60.0], {"name": "大肚腩一頂", "kind": "hit", "mult": 1.6, "apply": "push", "drain": 0.2, "desc": "挺著大肚撞開敵人，順便吃回一點血。"}, "包子鋪佢一個人食咗一半。", "本作原創：自助餐「食夠本」食到最後一碟。", "仲有甜品未食！"])
	var _t59 = J.G.get("N30G")
	J.cl(_t59, null, ["shedu", 2.0, "death", "蛇咬鬼", "一條蛇還咬著他", [60.0, 45.0, 75.0], {"name": "蛇撲出去", "kind": "hit", "mult": 1.6, "drain": 0.3, "desc": "屁股上的蛇撲出去咬一口，吸回血量。"}, "條蛇同佢已經做咗朋友。", "本作原創：去行山想抄近路，坐低休息坐中咗條蛇。", "哎喲！佢又咬我！"])
	var _t60 = J.G.get("N30G")
	J.cl(_t60, null, ["diansi", 3.0, "death", "電死鬼", "觸電爆炸頭", [55.0, 75.0, 90.0], {"name": "插頭放電", "kind": "aoe", "mult": 1.05, "apply": "down", "desc": "插頭放電劈過全場，敵人電到腳軟。"}, "一行近插蘇就會郁身郁勢。", "本作原創：濕手去插插蘇。頭髮從此再冇跌落嚟過。", "插蘇喺邊？"])
	var _t61 = J.G.get("N30G")
	J.cl(_t61, null, ["dongsi", 3.0, "death", "凍死鬼", "全身結冰", [80.0, 60.0, 75.0], {"name": "噴嚏冰柱", "kind": "hit", "mult": 1.8, "apply": "down", "follow": "down", "desc": "一個噴嚏射出冰柱，凍住敵人腳軟；對腳軟目標追擊。"}, "永遠披住張毯。", "本作原創：去日本睇雪，著住拖鞋短褲。", "哈……哈啾！"])
	var _t62 = J.G.get("N30G")
	J.cl(_t62, null, ["leipi", 3.0, "death", "雷劈鬼", "全身焦黑冒煙", [60.0, 85.0, 70.0], {"name": "舉傘招雷", "kind": "aoe", "mult": 1.1, "apply": "air", "desc": "舉起破傘招雷，劈中全場嚇彈起。"}, "行雷嗰陣千祈唔好企佢隔籬。", "本作原創：打風落雨喺山頂舉起支鐵骨遮影相。", "又嚟！"])
	var _t63 = J.G.get("N30G")
	J.cl(_t63, null, ["xiangcai", 3.0, "death", "大象踩扁鬼", "扁得像一張紙", [60.0, 85.0, 95.0], {"name": "紙片刀", "kind": "hit", "mult": 1.8, "hits": 2.0, "follow": "air", "desc": "扁成紙片橫削兩下；對嚇彈起目標追擊。"}, "可以喺門縫下面入屋。", "本作原創：去泰國騎大象自拍，大象想同佢合照。", "我依家好薄，好難捉㗎！"])
	J.G["N30W"] = {"ids": Callable(self, "_f3").bind(env), "st": Callable(self, "_f4").bind(env), "owned": Callable(self, "_f5").bind(env), "open": Callable(self, "_f7").bind(env), "where": Callable(self, "_f8").bind(env), "roadToday": Callable(self, "_f10").bind(env), "selectHtml": Callable(self, "_f15").bind(env), "bindSelect": Callable(self, "_f18").bind(env), "stageOf": Callable(self, "_f21").bind(env), "fight": Callable(self, "_f22").bind(env), "onWin": Callable(self, "_f24").bind(env), "alleyEvent": Callable(self, "_f26").bind(env), "graveVisit": Callable(self, "_f28").bind(env), "openCodex": Callable(self, "_f30").bind(env)}

func _f2(this_, a: Array, env):
	var v_v_19 = null
	v_v_19 = J.arg(a, 0)
	return J.round(J.num(J.mul(v_v_19, J.gp(J.gp(J.G.get("N30_TIER"), env["t"]), "k"))))

func _f1(this_, a: Array, env):
	var v_id_8 = null; var v_at_10 = null; var v_name_11 = null; var v_title_12 = null; var v_base_13 = null; var v_sk_14 = null; var v_trait_15 = null; var v_lore_16 = null; var v_say_17 = null; var v_k_18 = null
	var _s2 = {"__p": env, "t": null}
	v_id_8 = J.arg(a, 0)
	_s2["t"] = J.arg(a, 1)
	v_at_10 = J.arg(a, 2)
	v_name_11 = J.arg(a, 3)
	v_title_12 = J.arg(a, 4)
	v_base_13 = J.arg(a, 5)
	v_sk_14 = J.arg(a, 6)
	v_trait_15 = J.arg(a, 7)
	v_lore_16 = J.arg(a, 8)
	v_say_17 = J.arg(a, 9)
	v_k_18 = J.add("n30_", v_id_8)
	var _t1 = J.G.get("N30_G")
	var _t2 = {"id": v_id_8, "t": _s2["t"], "at": v_at_10}
	J.sp(_t1, v_k_18, _t2)
	var _t3 = J.G.get("GHOSTS")
	var _t4 = {"name": v_name_11, "title": v_title_12, "q": "名", "base": J.mc(v_base_13, "map", [Callable(self, "_f2").bind(_s2)]), "range": "melee", "trait": v_trait_15, "lore": v_lore_16, "say": v_say_17, "n30": true}
	J.sp(_t3, v_k_18, _t4)
	var _t5 = J.G.get("SKILLS")
	J.sp(_t5, v_k_18, v_sk_14)
	var _t6 = J.G.get("ENEMY_T")
	var _t7 = [J.gp(J.gp(J.gp(J.G.get("N30_TIER"), _s2["t"]), "en"), 0.0), J.gp(J.gp(J.gp(J.G.get("N30_TIER"), _s2["t"]), "en"), 1.0), v_name_11]
	J.sp(_t6, v_k_18, _t7)

func _f3(this_, a: Array, env):
	return J.S_Object_("keys", [J.G.get("N30_G")])

func _f4(this_, a: Array, env):
	if (not J.t(J.gp(J.G.get("S"), "n30"))):
		var _t64 = J.G.get("S")
		var _t65 = {}
		J.sp(_t64, "n30", _t65)
	return J.gp(J.G.get("S"), "n30")

func _f6(this_, a: Array, env):
	var v_g_27 = null
	v_g_27 = J.arg(a, 0)
	return J.seq(J.gp(v_g_27, "k"), env["k"])

func _f5(this_, a: Array, env):
	var _s6 = {"__p": env, "k": null}
	_s6["k"] = J.arg(a, 0)
	var _t66 = J.gp(J.G.get("S"), "ghosts")
	return J.mc(_t66, "some", [Callable(self, "_f6").bind(_s6)])

func _f7(this_, a: Array, env):
	var v_k_30 = null; var v_g_31 = null; var v_site_32 = null
	v_k_30 = J.arg(a, 0)
	v_g_31 = J.gp(J.G.get("N30_G"), v_k_30)
	v_site_32 = J.gp(J.G.get("N30_SITES"), J.gp(v_g_31, "at"))
	var _t68 = (not (not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(J.gp(J.G.get("N30_TIER"), J.gp(v_g_31, "t")), "gate")))))
	if J.t(_t68):
		var _t67 = (not J.t(J.gp(v_site_32, "gate")))
		_t68 = (_t67 if _t67 else (not (not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(v_site_32, "gate"))))))
	return _t68

func _f9(this_, a: Array, env):
	var v_s_41 = null
	v_s_41 = J.arg(a, 0)
	return (("打完 " + J.str(v_s_41)) if J.t(v_s_41) else "")

func _f8(this_, a: Array, env):
	var v_k_35 = null; var v_g_36 = null; var v_site_37 = null; var v_T_38 = null; var v_tag_39 = null; var v_need_40 = null
	v_k_35 = J.arg(a, 0)
	v_g_36 = J.gp(J.G.get("N30_G"), v_k_35)
	v_site_37 = J.gp(J.G.get("N30_SITES"), J.gp(v_g_36, "at"))
	v_T_38 = J.gp(J.G.get("N30_TIER"), J.gp(v_g_36, "t"))
	v_tag_39 = Callable(self, "_f9").bind(env)
	var _t69 = [J.cl(v_tag_39, null, [J.gp(v_T_38, "gate")]), J.cl(v_tag_39, null, [J.gp(v_site_37, "gate")])]
	var _t70 = J.mc(_t69, "filter", [J.G.get("Boolean")])
	v_need_40 = J.mc(_t70, "join", ["、"])
	return (J.str(J.gp(v_site_37, "name")) + "　" + J.str(J.gp(["", "前期", "中期", "後期"], J.gp(v_g_36, "t"))) + ((J.add("（", v_need_40) + "後）") if J.t(v_need_40) else ""))

func _f11(this_, a: Array, env):
	var v_k_47 = null
	v_k_47 = J.arg(a, 0)
	var _t72 = J.seq(J.gp(J.gp(J.G.get("N30_G"), v_k_47), "at"), "death")
	return (J.mc(env["this"], "open", [v_k_47]) if _t72 else _t72)

func _f12(this_, a: Array, env):
	var v_k_48 = null
	v_k_48 = J.arg(a, 0)
	return (not J.t(J.mc(env["pool"], "includes", [v_k_48])))

func _f13(this_, a: Array, env):
	var v_k_55 = null
	v_k_55 = J.arg(a, 0)
	return (not J.t(J.mc(env["__p"]["this"], "owned", [v_k_55])))

func _f14(this_, a: Array, env):
	var _t76 = J.mod((J.mul(env["seed"], 9301.0) + 49297.0), 233280.0)
	env["seed"] = _t76
	return J.div(env["seed"], 233280.0)

func _f10(this_, a: Array, env):
	var v_s_44 = null; var v_day_45 = null; var v_un_49 = null; var v_src_50 = null; var v_list_51 = null; var v_rnd_53 = null; var v_a_54 = null
	var _s11 = {"__p": env, "this": null, "pool": null}
	_s11["this"] = this_
	v_s_44 = J.mc(_s11["this"], "st", [])
	v_day_45 = floor(J.num(J.div(J.S_Date_("now", []), 86400000.0)))
	var _t71 = J.mc(_s11["this"], "ids", [])
	_s11["pool"] = J.mc(_t71, "filter", [Callable(self, "_f11").bind(_s11)])
	var _t73 = (not J.t(J.gp(v_s_44, "road")))
	var _t75 = (_t73 if _t73 else (not J.seq(J.gp(J.gp(v_s_44, "road"), "day"), v_day_45)))
	if not J.t(_t75):
		var _t74 = J.gp(J.gp(v_s_44, "road"), "list")
		_t75 = J.mc(_t74, "some", [Callable(self, "_f12").bind(_s11)])
	if J.t(_t75):
		var _s14 = {"__p": _s11, "seed": null}
		v_un_49 = J.mc(_s14["__p"]["pool"], "filter", [Callable(self, "_f13").bind(_s14)])
		v_src_50 = (v_un_49 if (J.len(v_un_49) >= 2.0) else _s14["__p"]["pool"])
		v_list_51 = []
		_s14["seed"] = (J.mul(v_day_45, 9301.0) + 49297.0)
		v_rnd_53 = Callable(self, "_f14").bind(_s14)
		v_a_54 = J.mc(v_src_50, "slice", [])
		while true:
			var _t77 = (J.len(v_list_51) < 2.0)
			if not J.t((J.len(v_a_54) if _t77 else _t77)): break
			J.mc(v_list_51, "push", [J.gp(J.mc(v_a_54, "splice", [floor(J.num(J.mul(J.cl(v_rnd_53, null, []), J.len(v_a_54)))), 1.0]), 0.0)])
		var _t78 = {"day": v_day_45, "list": v_list_51}
		J.sp(v_s_44, "road", _t78)
	return J.gp(J.gp(v_s_44, "road"), "list")

func _f16(this_, a: Array, env):
	var v_k_64 = null
	v_k_64 = J.arg(a, 0)
	return J.seq(J.gp(J.gp(J.G.get("N30_G"), v_k_64), "at"), env["sid"])

func _f17(this_, a: Array, env):
	var v_k_65 = null
	v_k_65 = J.arg(a, 0)
	return J.mc(env["__p"]["this"], "open", [v_k_65])

func _f15(this_, a: Array, env):
	var v_h_58 = null; var v_site_60 = null; var v_ks_61 = null; var v_open_62 = null; var v_lockedN_63 = null; var v_k_66 = null; var v_g_67 = null; var v_T_68 = null; var v_own_69 = null; var v_lvOk_70 = null
	var _s17 = {"__p": env, "this": null}
	_s17["this"] = this_
	if (not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), "1-3"))):
		return ("<div class=\"chap\"><div class=\"ch-h\">野鬼出沒</div><p class=\"desc\">打完第一章，各處開始有野鬼出沒，打贏就可以收服。</p></div>")
	v_h_58 = ("<div class=\"chap\"><div class=\"ch-h\">野鬼出沒・打贏就收服</div><p class=\"desc\">每隻野鬼第一次打贏就會跟你返村。已收服的可以再戰，賺冥幣。日本妖怪喺冥街夜市暗巷出沒。</p>")
	for _t79 in J.iter(["field", "road", "kampung", "banana", "death"]):
		var _s18 = {"__p": _s17, "sid": null}
		_s18["sid"] = _t79
		v_site_60 = J.gp(J.G.get("N30_SITES"), _s18["sid"])
		var _t80 = J.mc(_s18["__p"]["this"], "ids", [])
		v_ks_61 = J.mc(_t80, "filter", [Callable(self, "_f16").bind(_s18)])
		if J.seq(_s18["sid"], "death"):
			var _t81 = J.mc(_s18["__p"]["this"], "roadToday", [])
			v_ks_61 = _t81
		v_open_62 = J.mc(v_ks_61, "filter", [Callable(self, "_f17").bind(_s18)])
		v_lockedN_63 = (J.len(v_ks_61) - J.len(v_open_62))
		var _t83 = J.gp(v_site_60, "name")
		var _t84 = J.gp(v_site_60, "desc")
		var _t82 = (not J.seq(_s18["sid"], "death"))
		var _t85 = J.add(v_h_58, ("<div class=\"stg n30-site\"><span class=\"st\"><b>" + J.str(_t83) + "</b><small>" + J.str(_t84) + (("　另有 " + J.str(v_lockedN_63) + " 隻未出沒") if J.t((v_lockedN_63 if _t82 else _t82)) else "") + "</small></span></div>"))
		v_h_58 = _t85
		for _t86 in J.iter(v_open_62):
			v_k_66 = _t86
			v_g_67 = J.gp(J.G.get("N30_G"), v_k_66)
			v_T_68 = J.gp(J.G.get("N30_TIER"), J.gp(v_g_67, "t"))
			v_own_69 = J.mc(_s18["__p"]["this"], "owned", [v_k_66])
			v_lvOk_70 = J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_T_68, "req"), ">=")
			var _t87 = J.add(v_h_58, ("<div class=\"stg boss\"><span class=\"sn\">" + J.str(J.gp(["", "前", "中", "後"], J.gp(v_g_67, "t"))) + "</span><span class=\"st\"><b>" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_66), "name")) + "</b><small>" + ("已收服　" if J.t(v_own_69) else "") + "需主公 Lv" + J.str(J.gp(v_T_68, "req")) + "　" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_66), "title")) + "</small></span><button class=\"btn sm " + ("" if J.t(v_own_69) else "gold") + "\" data-n30=\"" + J.str(v_k_66) + "\" " + ("" if J.t(v_lvOk_70) else "disabled") + ">" + ("再戰" if J.t(v_own_69) else ("收服" if J.t(v_lvOk_70) else J.add("Lv", J.gp(v_T_68, "req")))) + "</button>" + ("<i class=\"ok\">✓</i>" if J.t(v_own_69) else "") + "</div>"))
			v_h_58 = _t87
	return J.add(v_h_58, "</div>")

func _f20(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "fight", [J.gp(J.gp(env["b"], "dataset"), "n30")])

func _f19(this_, a: Array, env):
	var _s25 = {"__p": env, "b": null}
	_s25["b"] = J.arg(a, 0)
	var _t89 = _s25["b"]
	var _t90 = Callable(self, "_f20").bind(_s25)
	J.sp(_t89, "onclick", _t90)
	return _t90

func _f18(this_, a: Array, env):
	var v_root_73 = null
	var _s24 = {"__p": env, "this": null}
	_s24["this"] = this_
	v_root_73 = J.arg(a, 0)
	var _t88 = J.mc(v_root_73, "querySelectorAll", ["[data-n30]"])
	J.mc(_t88, "forEach", [Callable(self, "_f19").bind(_s24)])

func _f21(this_, a: Array, env):
	var v_k_77 = null; var v_g_78 = null; var v_T_79 = null; var v_site_80 = null
	v_k_77 = J.arg(a, 0)
	v_g_78 = J.gp(J.G.get("N30_G"), v_k_77)
	v_T_79 = J.gp(J.G.get("N30_TIER"), J.gp(v_g_78, "t"))
	v_site_80 = J.gp(J.G.get("N30_SITES"), J.gp(v_g_78, "at"))
	return {"name": J.gp(J.gp(J.G.get("GHOSTS"), v_k_77), "name"), "req": J.gp(v_T_79, "req"), "p": J.gp(v_T_79, "p"), "en": [J.gp(J.gp(v_site_80, "fod"), 0.0), v_k_77, J.gp(J.gp(v_site_80, "fod"), 1.0)], "boss": v_k_77, "wild": v_k_77}

func _f23(this_, a: Array, env):
	return J.mc(J.G.get("Battle"), "start", [(-1.0), J.sub(J.gp(env["g"], "t"), 1.0), {"stage": J.mc(env["this"], "stageOf", [env["k"]]), "bg": J.gp(J.gp(J.G.get("N30_SITES"), J.gp(env["g"], "at")), "bg"), "sid": J.add("w-", J.gp(env["g"], "id"))}])

func _f22(this_, a: Array, env):
	var v_first_85 = null; var v_go_86 = null
	var _s28 = {"__p": env, "this": null, "k": null, "g": null}
	_s28["this"] = this_
	_s28["k"] = J.arg(a, 0)
	var _t91 = J.gp(J.G.get("S"), "team")
	if (not J.t(J.mc(_t91, "some", [J.G.get("Boolean")]))):
		J.mc(J.G.get("Fx"), "toast", ["至少要派一位鬼怪出陣"])
		return null
	J.mc(J.G.get("UI"), "close", [])
	_s28["g"] = J.gp(J.G.get("N30_G"), _s28["k"])
	v_first_85 = (not J.t(J.mc(_s28["this"], "owned", [_s28["k"]])))
	v_go_86 = Callable(self, "_f23").bind(_s28)
	if J.t(v_first_85):
		J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [["旁白", (J.str(J.gp(J.gp(J.G.get("N30_SITES"), J.gp(_s28["g"], "at")), "name")) + "：" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), _s28["k"]), "name")) + "出沒！")], [J.gp(J.gp(J.G.get("GHOSTS"), _s28["k"]), "name"), J.gp(J.gp(J.G.get("GHOSTS"), _s28["k"]), "say")]]}, v_go_86])
	else:
		J.cl(v_go_86, null, [])

func _f25(this_, a: Array, env):
	var _t94 = J.G.get("joinGhost")
	return J.cl(_t94, null, [env["k"]])

func _f24(this_, a: Array, env):
	var v_st_89 = null
	var _s31 = {"__p": env, "k": null}
	v_st_89 = J.arg(a, 0)
	var _t92 = (not J.t(v_st_89))
	var _t93 = (_t92 if _t92 else (not J.t(J.gp(v_st_89, "wild"))))
	if J.t((_t93 if _t93 else J.mc(this_, "owned", [J.gp(v_st_89, "wild")]))):
		return false
	_s31["k"] = J.gp(v_st_89, "wild")
	J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [[J.gp(J.gp(J.G.get("GHOSTS"), _s31["k"]), "name"), J.gp(J.gp(J.G.get("GHOSTS"), _s31["k"]), "say")], ["旁白", (J.str(J.gp(J.gp(J.G.get("GHOSTS"), _s31["k"]), "name")) + "決定跟你返落魄村。")]]}, Callable(self, "_f25").bind(_s31)])
	return true

func _f27(this_, a: Array, env):
	var v_k_97 = null
	v_k_97 = J.arg(a, 0)
	var _t96 = J.seq(J.gp(J.gp(J.G.get("N30_G"), v_k_97), "at"), "night")
	var _t97 = (J.mc(env["this"], "open", [v_k_97]) if _t96 else _t96)
	return ((not J.t(J.mc(env["this"], "owned", [v_k_97]))) if J.t(_t97) else _t97)

func _f26(this_, a: Array, env):
	var v_pool_93 = null; var v_k_94 = null; var v_g_95 = null; var v_cost_96 = null
	var _s33 = {"__p": env, "this": null}
	_s33["this"] = this_
	var _t95 = J.mc(_s33["this"], "ids", [])
	v_pool_93 = J.mc(_t95, "filter", [Callable(self, "_f27").bind(_s33)])
	var _t98 = (not J.t(J.len(v_pool_93)))
	if (_t98 if _t98 else (randf() > 0.45)):
		return null
	v_k_94 = J.gp(v_pool_93, floor(J.num((randf() * J.len(v_pool_93)))))
	v_g_95 = J.gp(J.G.get("N30_G"), v_k_94)
	v_cost_96 = J.gp([0.0, 120.0, 300.0, 600.0], J.gp(v_g_95, "t"))
	return {"id": J.add("n30_", J.gp(v_g_95, "id")), "n30": v_k_94, "text": ("巷口有一隻" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_94), "name")) + "（" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_94), "title")) + "）盯住你：「" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_94), "say")) + "」"), "a": {"label": "請佢食宵夜", "cost": v_cost_96, "out": (J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_94), "name")) + "食飽之後話：「你呢個人都幾好人。」佢跟你返落魄村。"), "join": v_k_94}, "b": {"label": "點個頭就走", "out": (J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_94), "name")) + "望住你行遠咗。下次再嚟，可能仲見到佢。"), "give": {"exp": 15.0}}}

func _f29(this_, a: Array, env):
	var v_k_102 = null
	v_k_102 = J.arg(a, 0)
	var _t100 = J.seq(J.gp(J.gp(J.G.get("N30_G"), v_k_102), "at"), "death")
	var _t101 = (J.mc(env["this"], "open", [v_k_102]) if _t100 else _t100)
	return ((not J.t(J.mc(env["this"], "owned", [v_k_102]))) if J.t(_t101) else _t101)

func _f28(this_, a: Array, env):
	var v_pool_100 = null; var v_k_101 = null
	var _s35 = {"__p": env, "this": null}
	_s35["this"] = this_
	var _t99 = J.mc(_s35["this"], "ids", [])
	v_pool_100 = J.mc(_t99, "filter", [Callable(self, "_f29").bind(_s35)])
	var _t102 = (not J.t(J.len(v_pool_100)))
	if (_t102 if _t102 else (randf() > 0.15)):
		return null
	v_k_101 = J.gp(v_pool_100, floor(J.num((randf() * J.len(v_pool_100)))))
	return {"k": v_k_101, "text": ("墳後面行出一隻" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_101), "name")) + "：「" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), v_k_101), "say")) + "」佢話想跟你返村。")}

func _f31(this_, a: Array, env):
	var v_k_108 = null
	v_k_108 = J.arg(a, 0)
	return J.mc(env["this"], "owned", [v_k_108])

func _f32(this_, a: Array, env):
	var v_k_111 = null
	v_k_111 = J.arg(a, 0)
	return J.seq(J.gp(J.gp(J.G.get("N30_G"), v_k_111), "at"), env["sid"])

func _f33(this_, a: Array, env):
	return J.mc(J.G.get("UI"), "openRoster", [])

func _f30(this_, a: Array, env):
	var v_ids_105 = null; var v_got_106 = null; var v_h_107 = null; var v_k_110 = null; var v_own_112 = null; var v_d_113 = null
	var _s37 = {"__p": env, "this": null}
	_s37["this"] = this_
	v_ids_105 = J.mc(_s37["this"], "ids", [])
	v_got_106 = J.len(J.mc(v_ids_105, "filter", [Callable(self, "_f31").bind(_s37)]))
	v_h_107 = ("<p class=\"desc\">新鬼圖鑑：已收服 " + J.str(v_got_106) + "/" + J.str(J.len(v_ids_105)) + "。未收服的會寫低喺邊度出沒。</p>")
	for _t103 in J.iter(["field", "road", "kampung", "banana", "night", "death"]):
		var _s39 = {"__p": _s37, "sid": null}
		_s39["sid"] = _t103
		var _t104 = J.add(v_h_107, ("<div class=\"ch-h\">" + J.str(J.gp(J.gp(J.G.get("N30_SITES"), _s39["sid"]), "name")) + "</div><div class=\"glist\">"))
		v_h_107 = _t104
		for _t105 in J.iter(J.mc(v_ids_105, "filter", [Callable(self, "_f32").bind(_s39)])):
			v_k_110 = _t105
			v_own_112 = J.mc(_s39["__p"]["this"], "owned", [v_k_110])
			v_d_113 = J.gp(J.G.get("GHOSTS"), v_k_110)
			var _t106 = J.add(v_h_107, ("<div class=\"gi " + ("" if J.t(v_own_112) else "dis") + "\"><canvas data-por=\"" + J.str(v_k_110) + "\" style=\"" + ("" if J.t(v_own_112) else "filter:brightness(.15)") + "\"></canvas><div><b>" + J.str((J.gp(v_d_113, "name") if J.t(v_own_112) else J.add(J.gp(v_d_113, "name"), "（未收服）"))) + "</b> <small>" + J.str(J.gp(v_d_113, "title")) + "</small><small class=\"tr\">" + J.str(J.gp(v_d_113, "lore")) + "</small><small>" + (("【" + J.str(J.gp(J.gp(J.G.get("SKILLS"), v_k_110), "name")) + "】" + J.str(J.gp(J.gp(J.G.get("SKILLS"), v_k_110), "desc"))) if J.t(v_own_112) else J.add("出沒：", J.mc(_s39["__p"]["this"], "where", [v_k_110]))) + "</small></div></div>"))
			v_h_107 = _t106
		var _t107 = J.add(v_h_107, "</div>")
		v_h_107 = _t107
	var _t108 = J.add(v_h_107, ("<button class=\"btn wide\" id=\"cxback\">返回名冊</button>"))
	v_h_107 = _t108
	J.mc(J.G.get("UI"), "sheet", ["新鬼圖鑑", v_h_107])
	var _t109 = J.G.get("paintPortraits")
	var _t110 = J.G.get("$")
	J.cl(_t109, null, [J.cl(_t110, null, ["#sheet"])])
	var _t111 = J.G.get("$")
	var _t112 = J.cl(_t111, null, ["#cxback"])
	var _t113 = Callable(self, "_f33").bind(_s37)
	J.sp(_t112, "onclick", _t113)
