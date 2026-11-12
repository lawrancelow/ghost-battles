# 自動轉譯自 standup.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["SU_BITS"] = [{"id": "su06", "who": "阿福", "k": "afu", "title": "凶宅打七折", "src": "su06 凶宅打七折", "need": "prologue_sys", "hint": "序章之後", "lines": [["大家好，我係阿福。今日想講件好傷心嘅事：我，俾人劈價。", "l"], ["我係死喺公司會議室嘅，唔關間屋事。不過死咗之後，我成日返屋企搞吓嘢：開吓燈、跌吓碗，等阿媽知我仲掛住佢。結果佢同阿爸決定賣屋，放上網寫：雙層排屋，近學校，近巴剎，有少少故事。", "l"], ["有少少故事。我係一個人嚟㗎，唔係一個故事。", "L"], ["第一對買家嚟睇屋。太太一入門就細細聲問：「呢間屋……係咪有嗰啲？」中介好專業：「安娣放心，呢間好熱鬧㗎。」", "l"], ["先生即刻撳計數機：「有嗰啲嘅話，再平五萬。」五萬！我幫你睇咗三年門、趕咗三年老鼠，我淨係值五萬？隔籬有白蟻嗰間，都平八萬。我連白蟻都爭唔過。", {"h": "笑死鬼", "t": "哈哈哈哈！白蟻贏你！", "back": "係，白蟻起碼有隊友。", "r": "L"}], ["我好嬲，嗰晚就去嚇佢哋：盞燈開開熄熄、開開熄熄。太太尖叫，先生好冷靜，攞部電話出嚟影：「你睇，燈閃成噉，電線有問題，再平兩萬。」", "L", "argue"], ["我越努力嚇人，間屋就越平。最後成交價：七折。原來我喺呢個屋企最大嘅貢獻，係幫佢打折。", "L"], ["新屋主搬入嚟第一日，喺門口貼咗張紙：「屋內須知。一，夜晚十一點之後唔准開關燈。二，用完廁所要沖水。」", "L"], ["我喺呢間屋大咗三十年，死咗三年都冇搬走，而家返屋企，第一次要睇人哋屋規。我變咗租客。", "L", "bow"]], "end": "台下馬上有一隻遊魂舉手：「嗰間仲有冇得租？」"}, {"id": "ks10", "who": "倀鬼", "k": "n30_changgui", "title": "你信我", "src": "KS10 為虎作倀", "need": "xo_ch1", "hint": "第一章之後", "lines": [["朋友，你信我，呢個係一個改變人生嘅機會。……我就係咁樣，俾老虎食咗。", "L", "n30:whistle"], ["我係倀鬼，為虎作倀嗰個倀。三百年前喺山上俾老虎咬死。規矩係：俾老虎食咗嘅人唔走得，要帶下一個嚟俾佢食，先可以收工。", "l"], ["我梗係唔會講「嚟俾老虎食」啦，冇人嚟㗎嘛。我講：「兄弟，有冇興趣識個大佬？好有實力，好照顧自己人。」", "L"], ["第一個係我表哥。佢問我危唔危險，我話：「我自己都喺入面，你睇我有冇事？」佢望一望我，塊面青晒——佢話好。", "L"], ["表哥俾老虎食咗，變咗我嘅 downline。佢再搵佢同學、佢鄰居、佢前度。三百年落嚟，我哋團隊九百人。老虎年年開大會，頒個獎俾我：鑽石級倀鬼。", "l", "n30:pet"], ["台下九百隻鬼一齊拍手，全部都係我害死嘅，全部都好感激我。", {"h": "遊魂阿強", "t": "咁你哋有冇買保險㗎？", "back": "有，受益人寫老虎。", "r": "L"}], ["我最佩服你哋而家啲人。我哋以前要呃先有人嚟，你哋係自己報名。網上一個課程：「三個月財務自由」，四千九，大家排隊過數。老虎食咗三百年，都未試過食得咁飽。", "L"], ["上個月，老虎老咗，啲牙跌晒，咬唔郁。我好驚，問佢：「噉我哋點算？」佢好慈祥噉望住我：「唔使咬喇，你哋繼續搵人就得。」", "l"], ["我嗰陣先明白：三百年嚟食人嘅，從來都唔係隻老虎。", "L"]], "end": "散場後，有三隻鬼在後台排隊問：「入會要幾錢？」"}, {"id": "ks09", "who": "窮鬼", "k": "n30_qionggui", "title": "其實都 OK", "src": "KS09 鬼也會窮死", "need": "ch2_end", "hint": "第二章之後", "lines": [["（執一執衫領）你哋驚鬼，咁鬼驚咩？鬼驚聻。人死咗變鬼，鬼死咗變聻。我下個月，就由鬼降級做聻。", "L", "n30:pockets"], ["其實都 OK。我生前係中產，有車、有樓、有張金卡。中產係咩？窮人覺得你有錢，有錢人覺得你窮，銀行覺得你啱啱好——啱啱好借得。", "L"], ["我以為企喺中間好安全，上面有人，下面有人。後來公司一裁員我先知，中產唔係一層樓，係一部 lift，得一個向下嘅掣。", "L"], ["死咗變鬼，以為到底喇。點知下面都要供樓：陰宅，三十五年分期。", "l"], ["其實都 OK。我上個月去查 EPF，第三戶口淨返四十八蚊，最少五十先攞得。連我自己啲錢，都嫌我唔夠格。", {"h": "孤寒鬼", "t": "差兩蚊咋嘛！借俾你，利息三分！", "back": "多謝。其實都 OK。", "r": "L"}], ["我問下面啲聻：「下面仲有冇？」佢話有。我問叫咩，佢話：「你唔使知，你好快就會知。」", "l", "n30:coin"], ["上個禮拜，我撞到以前個老細。佢都落咗嚟，仲係鬼，坐喺我哋上面嗰層，飲住拉茶望落嚟。我忍唔住問：「老細，點解你一直都冇跌落嚟嘅？」", "l"], ["佢笑一笑：「因為我下面，有你哋。」", "L"]], "end": "台下很多鬼摸了摸自己的錢包，安靜了很久。"}, {"id": "gh228", "who": "老殭", "k": "laojiang", "title": "三十六計", "src": "gh228 諸葛亮做顧問", "need": "ch3_end", "hint": "第三章之後", "lines": [["本官讀咗一世兵書。死咗兩百年先發覺：啲兵法，全部去咗你哋嘅寫字樓。", "l"], ["先講草船借箭。諸葛亮用草船擋箭，箭自己送上門。你哋開會，將實習生推去坐最前面——老細啲箭，全部射落佢度。", "L"], ["散會之後，實習生成身插滿箭。你哋執返啲箭，拎去寫自己份報告。呢個，就叫「借」。", "L"], ["再講空城計。城門大開，城入面冇兵，嚇退敵軍。你哋老細年年都用：「今年公司好困難，冇花紅。」", "l"], ["城門口，泊住架新保時捷。", {"h": "窮鬼", "t": "咁點樣破佢條計？", "back": "破唔到。城係佢嘅，架車都係佢嘅。", "r": "L"}], ["最勁係諸葛亮嗰句：「鞠躬盡瘁，死而後已。」你哋老細最鍾意裱起佢，掛喺會議室。", "l"], ["本官研究咗兩百年，終於明白：死而後已——要等老細死咗，你先可以「已」。", "L"], ["所以本官一直企喺度等。等咗兩百年，老細未死，大清死咗。", "L"]], "end": "老殭講完，台下的打工鬼紛紛低頭抄筆記。"}, {"id": "ks03", "who": "裂口女", "k": "n30_kuchisake", "title": "我靚唔靚？", "src": "KS03 裂口女醫美", "need": "ch4_intro", "hint": "第四章開始之後", "lines": [["（戴住口罩，眨眨眼）各位晚安～第一條問題：我靚唔靚？……唔好答住，我仲未除口罩。", "l", "n30:ask"], ["我係裂口女。以前我喺街口截住人問：「我靚唔靚？」你話靚，我就除口罩：「噉而家呢？」塊嘴裂到去耳仔。", "l"], ["你話唔靚，我會嬲。你話「麻麻地」，我會企喺度諗成晚——因為劇本冇寫呢個答案。", "L"], ["以前大家見到我好驚。而家？我除咗口罩，個後生女望一望：「姐姐，你係咪啱啱打完 filler？邊間做㗎？」", "L"], ["我呆咗。做咗鬼四十幾年，第一次有人問我攞 referral。", "L"], ["我諗通咗，唔嚇人喇，轉行。而家我喺 TikTok 開直播：「姐妹們～想要我咁嘅微笑線，今晚三折，送埋口罩。」", "L", "n30:snip"], ["生意好到爆。我問：「我靚唔靚？」佢哋答：「靚！幾錢？」以前呢條問題要人命，而家呢條問題要人錢。", {"h": "笑死鬼", "t": "哈哈哈哈我要一個！", "back": "好呀，先畀訂金。裂咗唔退。", "r": "L"}], ["而家輪到你哋排隊問我：「姐姐，我靚唔靚？」我望一望：「麻麻地。」", "l"], ["佢哋企喺度，諗咗成晚。", "L", "n30:ask"]], "end": "散場時，後台排了一條長長的隊，全是來問價的。"}, {"id": "ks08", "who": "Hantu Galah", "k": "n30_hantugalah", "title": "唔好岳高頭", "src": "KS08 不要抬頭", "need": "ch4_end", "hint": "第四章之後", "lines": [["唔好岳高頭望。我叫你哋唔好岳高頭望——jangan tengok atas。……你睇，又高咗。", "L", "n30:peer"], ["我係 Hantu Galah，竹竿鬼。原理好簡單：你越岳高頭望我，我就越高；你唔望，我就矮返落嚟。好公平，只要你忍得住。", "l"], ["我以前喺鄉下，一年俾人望一兩次，最高都係椰樹咁高。後來搬咗上 KL，就完蛋。因為喺 KL，個個每日都岳高頭望——望樓價。", "L"], ["你哋一路望一路講：「嘩，又升咗。」佢就又升咗，同我一個原理。我勸過個後生：「兄弟，唔好再望喇。」佢話：「我唔望，我媽每日問我幾時買樓。」", "l"], ["佢媽問一次，我高一層。過年啲親戚再嚟個三連問：幾時買樓？幾時結婚？幾時生仔？我即刻高過 Merdeka 118。", "L", "n30:stretch"], ["全國有三萬幾間屋起好咗冇人買，夜晚黑麻麻，你哋話嗰度猛鬼。我入去睇過，冇鬼。鬼都想住㗎，去問銀行，銀行要三個月 salary slip。", {"h": "窮鬼", "t": "冥幣出糧得唔得㗎？", "back": "得。冥幣嘅話，首期一百億。", "r": "L"}], ["琴晚有個 uncle 終於買到樓，供三十五年。佢好開心，岳高頭同我講：「我終於唔使再望喇！」", "l"], ["佢講完，我又高咗一截。因為佢而家改咗望利率。國家銀行開一次會，我高一次，要高足三十五年。", "L", "n30:peer"]], "end": "散場後，全場觀眾低著頭走了出去。"}, {"id": "ks07", "who": "嚇死鬼", "k": "n30_xiasi", "title": "俾 AI 炒咗", "src": "KS07 被 AI 裁掉的鬼", "need": "ch5_intro", "hint": "第五章開始之後", "lines": [["冇事，我好好。我只係俾人炒咗。我係鬼，俾 AI 炒咗。", "L", "n30:look"], ["我喺一間屋鬧咗二十年，資歷最深。半夜開燈熄燈、冷氣自己開、電視自己轉台，全部都係我嘅 KPI。", "l"], ["後來屋主裝咗 smart home。燈自己開，冷氣自己開，半夜個喇叭仲會自己笑。我生前就係俾人嚇死嘅，死咗二十年，又俾部喇叭嚇死多次。", "L", "n30:jump"], ["屋主都唔驚喇。盞燈一閃，佢唔叫師傅，佢叫 Google：「Hey Google，唔好玩。」佢就唔玩。我玩咗二十年，從來冇人好好聲叫我唔好玩——其實我都會停㗎。", "L"], ["我去 PERKESO 排隊攞失業援助，前面排咗五萬幾個人，一半著恤衫打呔，面青青，冇人出聲。我仲以為行錯路，返咗落嚟。", "L"], ["櫃枱小姐叫我去 upskill，學 AI。我好認真上咗三個月堂，學識寫 prompt。第一個 prompt 我打：「幫我嚇人。」佢畫咗隻好可愛嘅鬼喺度比心。屋主攞咗去做 WhatsApp 頭像。", {"h": "笑死鬼", "t": "哈哈哈你用免費版㗎嘛！", "back": "付費版要月費，我死咗冇出糧。", "r": "L"}], ["上個禮拜停電，成間屋嘅 smart home 死晒，淨返我。我用盡二十年功力：燈閃，門響，冷笑三聲。屋主喺黑暗入面一啲都唔驚，仲好開心：「嘩，仲有後備！」", "L"], ["我俾人降職喇。由鬼，變咗 power bank。", "L", "n30:look"]], "end": "台下很多鬼掏出手機，悄悄關掉了 Wi-Fi。"}, {"id": "ks06", "who": "車禍鬼", "k": "n30_chehuo", "title": "暫時", "src": "KS06 我暫時死了四十年", "need": "xo_ch5", "hint": "第五章之後", "lines": [["（清清喉嚨）各位，關於我嘅死，我喺度作出澄清：我係暫時死咗。一暫時，就四十年。", "L", "n30:mirror"], ["一九八六年，我喺大道撞車。醫生望咗一眼：「暫時冇生命跡象。」我就一直等嗰個「暫時」過去，等到今日。", "l"], ["喺我哋大馬，「暫時」係最長命嘅兩個字。路暫時封，水暫時停，收費站話暫時收幾年——收到今日，長命過我。", "L"], ["我出事嗰條大道，官方話暫時唔擴闊，成本太高。我聽完好安慰：四十年嚟，原來我哋兩個一樣，塞喺度，冇人救。", "L"], ["我落嚟報到，櫃枱話我嘅資料跟進緊。我問幾時有結果，佢話會盡快。我問盡快係幾時，佢話有關當局會通知你。", "l"], ["我問有關當局係邊個。佢望咗我好耐：「就係你而家問緊嗰個。」", {"h": "牛頭", "t": "喂！我冇講過喎！", "back": "你睇，佢跟進緊。", "r": "L"}], ["上個月終於輪到我銷案。排咗四十年，我好興奮。點知電腦一撳，彈出一行字：「系統顯示，此人仍然在世，名下有一張一九八六年嘅 saman 未還。」", "L"], ["我問點會咁㗎。佢話：技術錯誤，唔使擔心——暫時嘅。", "L", "n30:rev"]], "end": "散場後，車禍鬼在出口排隊，排了很久。據說是暫時的。"}, {"id": "su07", "who": "鬼新娘", "k": "n30_guixinniang", "title": "冥婚要面試", "src": "su07 冥婚要面試", "need": "ch6_intro", "hint": "第六章開始之後", "lines": [["（整一整紅蓋頭）各位，今晚我嚟澄清一個謠言：冥婚，唔係你想娶就娶得。要面試㗎。", "l", "n30:veil"], ["我屋企人喺路邊放咗封紅包，邊個執到，就係我老公。好多人以為係撞彩，其實紅包入面有份表格：學歷、身高、月薪、有冇樓。", "L"], ["第一個執到嘅係個 IT 仔。我問佢：「你有冇樓？」佢話：「我租緊。」我話：「我有墳，永久業權。」佢即刻自卑。", "L"], ["第二個係 Grab 司機，好有誠意，一執到就話：「我到咗。」結果三個鐘之後先到。", "L"], ["第三個最慘，做 sales 嘅。一坐低就問：「咁你有冇考慮過買保險？」我話：「我死咗喇。」佢話：「噉你屋企人呢？」", {"h": "遊魂阿強", "t": "嗰個係我徒弟嚟㗎！", "back": "睇得出。死咗都唔放過人。", "r": "L"}], ["最後我屋企人話我太揀擇，叫我降低要求。我話：「我死咗三十年，等咗三十年，要求高啲都唔得？」", "l", "n30:wait"], ["我媽話：「你再揀落去，就嫁唔出喇。」我話：「媽，我已經死咗，最差都係咁。」佢話：「唔係呀，最差係你啲表姐全部都嫁晒。」", "L", "n30:twirl"]], "end": "鬼新娘講完，把繡球拋向台下。全場觀眾立刻一哄而散。"}]
	J.G["XO_SCENES"] = {"xo_origin": {"style": "talk", "bg": "road", "title": "陰間入職處", "lines": [["旁白", "陰間入職處。負責審核新鬼的，是馬面。"], ["馬面", "姓名？"], ["阿福", "陳大福。公司啲人叫我 Kelvin。"], ["馬面", "死因？"], ["阿福", "過勞。死喺會議室。個會題目叫《如何減少加班》，六點半開，已經係第三次開——專登討論點解頭兩次開到咁夜。"], ["阿福", "開到兩點四十七分，我喺枱底覆咗老細一個「好」字，就趴喺手提電腦個鍵盤度，走咗。"], ["馬面", "會議紀錄點寫？"], ["阿福", "「與會者一名，提早離場。」"], ["阿福", "第二朝老細經過，見我仲趴住，佢話：「好！呢個肯搏。」第三日佢先發覺唔對路——因為我冇覆佢 WhatsApp。入職以嚟，第一次冇覆。"], ["馬面", "（翻開本簿）生前做咩㗎？"], ["阿福", "打工嘅。"], ["馬面", "（即刻合埋本簿）咁你唔使審喇。你喺上面，已經捱過地獄。"]]}, "xo_paper": {"style": "talk", "bg": "village", "lines": [["旁白", "小紙的背上，還貼著一張小小的紙。"], ["阿福", "呢張係乜嘢？"], ["小紙", "少爺，係我嘅保用證。紙紮舖話保用七日。"], ["阿福", "保啲咩？"], ["小紙", "遇水唔保，遇火唔保，遇風唔保。"], ["阿福", "咁即係咩都唔保。"], ["小紙", "仲有一條：如有問題，請直接搵老闆。"], ["阿福", "老闆喺邊？"], ["小紙", "（反轉張紙）上年已經落咗嚟喇。"], ["系統", "親，本系統已幫你查到：他在隔壁村第三排，可以上門投訴哦～"]]}, "xo_ch1": {"style": "talk", "bg": "village", "lines": [["旁白", "招魂台剛蓋好，就有一隻鬼笑著走過來，手裡拿著一疊卡片。"], ["倀鬼", "老闆！恭喜開張！你信我，呢個招魂台，係你人生嘅轉捩點。"], ["阿福", "你係？"], ["倀鬼", "我係倀鬼，為虎作倀嗰個倀。我有個 plan：你招一隻鬼，佢再招兩隻，兩隻再招四隻，唔使三個月，成個地府都係你嘅 downline。"], ["阿福", "咁最頂嗰個係邊個？"], ["倀鬼", "（指一指身後）佢囉。"], ["旁白", "他身後的樹叢裡，一雙黃色的眼睛眨了一下。"], ["系統", "叮！檢測到高效招聘模式！親，本系統強烈推薦——"], ["阿福", "唔要。"], ["倀鬼", "冇問題，我唔逼人㗎。（遞上卡片）諗清楚再搵我。今晚冥街夜市，我有個分享會。"], ["系統", "親，他的卡片印著「鑽石級」，很有福報呢。"], ["阿福", "背面印住隻老虎。"]]}, "xo_ch2": {"style": "chat", "title": "媽", "av": ["媽", "#8a5a6a"], "lines": [["媽", "20:01|阿福，部手機收到未？"], ["阿福", "20:03|收到喇媽"], ["媽", "20:03|好"], ["媽", "20:03|你阿爸叫我問你，下期開咩字"], ["阿福", "20:04|媽，我係死咗，唔係去咗萬字公司做經理"], ["媽", "20:04|你喺下面識人多嘛"], ["阿福", "20:05|……0247 啦"], ["旁白", "0247，是阿福斷氣那一刻的時間"], ["媽", "20:05|好"], ["媽", "20:05|唔中唔怪你"]]}, "xo_ch3": {"style": "talk", "bg": "village", "lines": [["旁白", "老殭入村第一天，一枚銅錢掉在地上。"], ["阿福", "大人，你個錢跌咗。"], ["老殭", "本官知道。本官同佢，已經對望咗一炷香。"], ["小紙", "少爺，殭屍唔識彎腰㗎。"], ["老殭", "非也。本官識彎，只係兩百年冇彎過，條腰唔記得點彎。"], ["餓鬼王", "（衝埋嚟執起個銅錢）我幫你！"], ["老殭", "多謝。"], ["餓鬼王", "（擺咗入口）……唔係食嘅？"], ["老殭", "本官兩百年嚟，第一次見有人執到錢咁失望。"]]}, "xo_ch3b": {"style": "chat", "title": "媽", "av": ["媽", "#8a5a6a"], "lines": [["媽", "21:10|阿福！！！"], ["媽", "21:10|中咗！！！0247！！！"], ["阿福", "21:12|……真係中？"], ["媽", "21:12|你阿爸話，以後一個禮拜上山睇你三次"], ["阿福", "21:13|我生前佢一個月都唔打一次電話俾我"], ["媽", "21:13|佢而家好掛住你㗎"], ["媽", "21:14|佢叫你下期再報"], ["媽", "21:15|仲有，你封 PTPTN 信寄咗返屋企，我燒埋落去俾你喇"], ["阿福", "21:15|媽，唔使咁孝順"]]}, "xo_ch4": {"style": "talk", "bg": "village", "lines": [["旁白", "去香蕉園的路上，有一根很高很高的竹竿，立在路中間。"], ["Hantu Galah", "喂，後生仔，唔好岳高頭望。"], ["阿福", "點解？"], ["Hantu Galah", "你越望我，我越高。你睇，又高咗。"], ["小紙", "少爺，佢真係高咗！"], ["Hantu Galah", "靚女，你都唔好望。我高到掂到天，又要俾人投訴阻住飛機。"], ["阿福", "咁我唔望你，你會點？"], ["Hantu Galah", "我會矮返落嚟。所以呢，條村啲樓價，你哋都唔好望。"], ["系統", "親，本系統已幫你看過了：落魄村樓價本月上漲三成！"], ["Hantu Galah", "（又高咗一截）……邊個叫佢望㗎！"]]}, "xo_ch5": {"style": "talk", "bg": "kampung", "lines": [["旁白", "紙紮法拉利剛落地，就有一隻戴著破頭盔的鬼走過來，繞著車轉了三圈。"], ["車禍鬼", "先生，關於呢架車，我作出幾點跟進。"], ["阿福", "你係？"], ["車禍鬼", "我係車禍鬼。一九八六年喺大道出事，暫時死咗。"], ["車禍鬼", "第一，呢架車冇安全帶。第二，冇倒後鏡。第三，個軚盤係印上去嘅。"], ["阿福", "紙紮嘅，梗係揸唔郁。"], ["車禍鬼", "揸唔郁好。我呢世人最安全嘅一次揸車，就係揸一架唔郁嘅車。"], ["小紙", "少爺，佢好似好鍾意呢架車。"], ["車禍鬼", "唔係鍾意，係跟進。（坐入駕駛位）我暫時坐一陣。"], ["旁白", "他一坐，就坐了一整晚。"]]}, "xo_ch6": {"style": "talk", "bg": "hq", "lines": [["旁白", "地府集團總部大堂。排隊的鬼，從門口一直排到奈何橋。"], ["牛頭", "攞籌！"], ["阿福", "我係嚟見 KPI 轉型顧問嘅。"], ["牛頭", "約咗未？"], ["白無常", "我哋押佢嚟嘅，有公文。"], ["牛頭", "公文要先蓋印。蓋印要排隊。排隊要攞籌。攞籌要有公文。"], ["阿福", "……咁要點開始？"], ["牛頭", "（好認真）我喺度做咗八百年，都未搵到個開始。"], ["黑無常", "行樓梯。"], ["旁白", "四隻鬼爬了四十四層樓梯。"]]}}
	J.G["XO_AFTER"] = {"prologue_road": ["xo_origin"], "gift_xiaozhi2": ["xo_paper"], "ch1_end": ["xo_ch1"], "gift_phone": ["xo_ch2"], "ch3_end": ["xo_ch3", "xo_ch3b"], "ch4_intro2": ["xo_ch4"], "gift_car": ["xo_ch5"], "ch6_intro2": ["xo_ch6"]}
	J.G["XO_SPEAKERS"] = {"倀鬼": "n30_changgui", "Hantu Galah": "n30_hantugalah", "車禍鬼": "n30_chehuo", "牛頭": "niutou", "馬面": "mamian"}
	J.cl(Callable(self, "_f1").bind(env), null, [])
	J.G["Standup"] = J.cl(Callable(self, "_f4").bind(env), null, [])

func _f3(this_, a: Array, env):
	var v_it_24 = null
	v_it_24 = J.arg(a, 0)
	return J.seq(J.gp(v_it_24, "sc"), env["x"])

func _f2(this_, a: Array, env):
	var v_sc_20 = null; var v_cb_21 = null; var v_r_22 = null
	v_sc_20 = J.arg(a, 0)
	v_cb_21 = J.arg(a, 1)
	v_r_22 = J.mc(env["oq"], "call", [this_, v_sc_20, v_cb_21])
	var _t13 = J.seq(J.typeof_(v_sc_20), "string")
	var _t14 = (J.gp(J.G.get("XO_AFTER"), v_sc_20) if _t13 else _t13)
	var _t15 = ((not J.seq(J.typeof_(J.G.get("S")), "undefined")) if J.t(_t14) else _t14)
	if J.t((J.G.get("S") if J.t(_t15) else _t15)):
		for _t16 in J.iter(J.gp(J.G.get("XO_AFTER"), v_sc_20)):
			var _s13 = {"__p": env, "x": null}
			_s13["x"] = _t16
			var _t17 = (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), _s13["x"])))
			var _t19 = (J.gp(J.G.get("SCENES"), _s13["x"]) if _t17 else _t17)
			if J.t(_t19):
				var _t18 = J.gp(this_, "q")
				_t19 = (not J.t(J.mc(_t18, "some", [Callable(self, "_f3").bind(_s13)])))
			if J.t(_t19):
				J.mc(_s13["__p"]["oq"], "call", [this_, _s13["x"]])
	return v_r_22

func _f1(this_, a: Array, env):
	var v_installXO_8 = null; var v_id_9 = null; var v_n_10 = null; var v_row_11 = null; var v_ids_12 = null; var v_after_13 = null; var v_i_14 = null; var v_j_15 = null; var v_x_16 = null
	v_installXO_8 = Callable(self, "_f1").bind(env)
	if J.seq(J.typeof_(J.G.get("SCENES")), "undefined"):
		return null
	for _t1 in J.keys(J.G.get("XO_SCENES")):
		v_id_9 = _t1
		if (not J.t(J.gp(J.G.get("SCENES"), v_id_9))):
			var _t2 = J.G.get("SCENES")
			var _t3 = J.gp(J.G.get("XO_SCENES"), v_id_9)
			J.sp(_t2, v_id_9, _t3)
	if (not J.seq(J.typeof_(J.G.get("SPEAKER_ART")), "undefined")):
		for _t4 in J.keys(J.G.get("XO_SPEAKERS")):
			v_n_10 = _t4
			if (not J.t(J.gp(J.G.get("SPEAKER_ART"), v_n_10))):
				var _t5 = J.G.get("SPEAKER_ART")
				var _t6 = J.gp(J.G.get("XO_SPEAKERS"), v_n_10)
				J.sp(_t5, v_n_10, _t6)
	if (not J.seq(J.typeof_(J.G.get("SCENE_ORDER")), "undefined")):
		for _t7 in J.iter(J.G.get("SCENE_ORDER")):
			v_row_11 = _t7
			v_ids_12 = J.gp(v_row_11, 1.0)
			for _t8 in J.keys(J.G.get("XO_AFTER")):
				v_after_13 = _t8
				v_i_14 = J.mc(v_ids_12, "indexOf", [v_after_13])
				if J.cmp(v_i_14, 0.0, "<"):
					continue
				v_j_15 = J.add(v_i_14, 1.0)
				for _t9 in J.iter(J.gp(J.G.get("XO_AFTER"), v_after_13)):
					v_x_16 = _t9
					if J.cmp(J.mc(v_ids_12, "indexOf", [v_x_16]), 0.0, "<"):
						J.mc(v_ids_12, "splice", [v_j_15, 0.0, v_x_16])
					var _t10 = J.add(J.mc(v_ids_12, "indexOf", [v_x_16]), 1.0)
					v_j_15 = _t10
	var _t11 = (not J.seq(J.typeof_(J.G.get("Story")), "undefined"))
	if J.t((J.gp(J.G.get("Story"), "queue") if _t11 else _t11)):
		var _s11 = {"__p": env, "oq": null}
		_s11["oq"] = J.gp(J.G.get("Story"), "queue")
		var _t12 = J.G.get("Story")
		var _t20 = Callable(self, "_f2").bind(_s11)
		J.sp(_t12, "queue", _t20)

func _f5(this_, a: Array, env):
	var v_s_39 = null
	var _t21 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t21 if _t21 else (not J.t(J.G.get("S")))):
		return null
	var _t22 = J.G.get("S")
	var _t23 = J.gp(J.G.get("S"), "su")
	var _t24 = (_t23 if J.t(_t23) else {})
	J.sp(_t22, "su", _t24)
	v_s_39 = _t24
	var _t25 = J.gp(v_s_39, "seen")
	var _t26 = (_t25 if J.t(_t25) else {})
	J.sp(v_s_39, "seen", _t26)
	var _t27 = J.gp(v_s_39, "ann")
	var _t28 = (_t27 if J.t(_t27) else {})
	J.sp(v_s_39, "ann", _t28)
	var _t29 = J.gp(v_s_39, "buff")
	var _t30 = (_t29 if J.t(_t29) else 0.0)
	J.sp(v_s_39, "buff", _t30)
	return v_s_39

func _f9(this_, a: Array, env):
	var v_name_48 = null; var v_k_49 = null
	v_name_48 = J.arg(a, 0)
	v_k_49 = J.arg(a, 1)
	var _t32 = J.mc(env["used"], "has", [v_k_49])
	if not J.t(_t32):
		var _t31 = env["__p"]["art"]
		_t32 = (not J.t(J.cl(_t31, null, [v_k_49])))
	if J.t((_t32 if J.t(_t32) else (J.len(env["list"]) >= 5.0))):
		return null
	J.mc(env["used"], "add", [v_k_49])
	J.mc(env["list"], "push", [[v_name_48, v_k_49]])

func _f8(this_, a: Array, env):
	var v_b_44 = null; var v_add_47 = null; var v_l_50 = null; var v_k_51 = null; var v_h_52 = null
	var _s19 = {"__p": env, "list": null, "used": null}
	v_b_44 = J.arg(a, 0)
	_s19["list"] = []
	_s19["used"] = J.new_("Set", [[J.gp(v_b_44, "k")]])
	v_add_47 = Callable(self, "_f9").bind(_s19)
	for _t33 in J.iter(J.gp(v_b_44, "lines")):
		v_l_50 = _t33
		var _t34 = J.gp(v_l_50, 1.0)
		if J.t((J.seq(J.typeof_(J.gp(v_l_50, 1.0)), "object") if J.t(_t34) else _t34)):
			var _t36 = J.gp(J.gp(v_l_50, 1.0), "h")
			var _t35 = J.gp(_s19["__p"]["KEY"], J.gp(J.gp(v_l_50, 1.0), "h"))
			J.cl(v_add_47, null, [_t36, (_t35 if J.t(_t35) else "youhun")])
	J.cl(v_add_47, null, ["笑死鬼", "n30_xiaosi"])
	for _t37 in J.iter(_s19["__p"]["FILL"]):
		v_k_51 = _t37
		J.cl(v_add_47, null, [J.gp(_s19["__p"]["NAMES"], v_k_51), v_k_51])
	if (J.len(_s19["list"]) >= 3.0):
		v_h_52 = J.gp(_s19["list"], 0.0)
		J.mc(_s19["list"], "splice", [0.0, 1.0])
		J.mc(_s19["list"], "splice", [floor(J.num(J.div(J.len(_s19["list"]), 2.0))), 0.0, v_h_52])
	return _s19["list"]

func _f10(this_, a: Array, env):
	var v_b_55 = null; var v_out_56 = null; var v_l_57 = null; var v_text_58 = null; var v_re_59 = null; var v_act_60 = null
	v_b_55 = J.arg(a, 0)
	v_out_56 = []
	for _t38 in J.iter(J.gp(v_b_55, "lines")):
		v_l_57 = _t38
		var _t39 = J.gp(v_l_57, 0.0)
		v_text_58 = _t39
		var _t40 = J.gp(v_l_57, 1.0)
		v_re_59 = _t40
		var _t41 = J.gp(v_l_57, 2.0)
		v_act_60 = _t41
		if J.t((J.seq(J.typeof_(v_re_59), "object") if J.t(v_re_59) else v_re_59)):
			J.mc(v_out_56, "push", [{"who": J.gp(v_b_55, "who"), "text": v_text_58, "act": (v_act_60 if J.t(v_act_60) else null), "react": "l"}])
			J.mc(v_out_56, "push", [{"who": J.gp(v_re_59, "h"), "text": J.gp(v_re_59, "t"), "react": "h"}])
			var _t43 = J.gp(v_b_55, "who")
			var _t44 = J.gp(v_re_59, "back")
			var _t42 = J.gp(v_re_59, "r")
			J.mc(v_out_56, "push", [{"who": _t43, "text": _t44, "react": (_t42 if J.t(_t42) else "L")}])
		else:
			J.mc(v_out_56, "push", [{"who": J.gp(v_b_55, "who"), "text": v_text_58, "act": (v_act_60 if J.t(v_act_60) else null), "react": (v_re_59 if J.t(v_re_59) else null)}])
	J.mc(v_out_56, "push", [{"who": "旁白", "text": J.gp(v_b_55, "end"), "react": "E"}])
	return v_out_56

func _f12(this_, a: Array, env):
	return (J.gp(J.gp(env["A"], floor(J.num((randf() * J.len(env["A"]))))), "px") if J.t(J.len(env["A"])) else J.div(env["W"], 2.0))

func _f13(this_, a: Array, env):
	var v_a_71 = null
	v_a_71 = J.arg(a, 0)
	return J.mc(J.G.get("Theater"), "act", [v_a_71, ("n30:laugh" if J.seq(J.gp(v_a_71, "k"), "n30_xiaosi") else "laugh"), (2.4 if J.seq(J.gp(v_a_71, "k"), "n30_xiaosi") else 0.0)])

func _f15(this_, a: Array, env):
	var _t49 = env["__p"]["laugh"]
	return J.cl(_t49, null, [env["a"]])

func _f14(this_, a: Array, env):
	var v_i_74 = null
	var _s32 = {"__p": env, "a": null}
	_s32["a"] = J.arg(a, 0)
	v_i_74 = J.arg(a, 1)
	return J.F_setTimeout([Callable(self, "_f15").bind(_s32), J.mul(v_i_74, 90.0)])

func _f16(this_, a: Array, env):
	return (randf() - 0.5)

func _f17(this_, a: Array, env):
	var v_a_75 = null
	v_a_75 = J.arg(a, 0)
	return J.mc(J.G.get("Theater"), "act", [v_a_75, "wave"])

func _f18(this_, a: Array, env):
	var v_a_77 = null
	v_a_77 = J.arg(a, 0)
	return J.seq(J.gp(v_a_77, "k"), "n30_xiaosi")

func _f11(this_, a: Array, env):
	var v_code_63 = null; var v_H_66 = null; var v_L_67 = null; var v_top_68 = null; var v_xs_69 = null; var v_side_72 = null; var v_x_76 = null
	var _s28 = {"__p": env, "A": null, "W": null, "laugh": null}
	v_code_63 = J.arg(a, 0)
	_s28["A"] = J.mc(J.G.get("Theater"), "aud", [])
	var _t45 = J.mc(J.G.get("Theater"), "size", [])
	var _t46 = J.gp(_t45, "W")
	_s28["W"] = _t46
	var _t47 = J.gp(_t45, "H")
	v_H_66 = _t47
	v_L_67 = J.mc(J.G.get("Theater"), "layout", [])
	if (not J.t(v_L_67)):
		return null
	v_top_68 = J.sub(v_H_66, (J.mul(J.gp(v_L_67, "ch"), 0.78) * 0.95))
	v_xs_69 = Callable(self, "_f12").bind(_s28)
	_s28["laugh"] = Callable(self, "_f13").bind(_s28)
	var _t48 = J.seq(v_code_63, "L")
	if (_t48 if _t48 else J.seq(v_code_63, "E")):
		J.mc(_s28["A"], "forEach", [Callable(self, "_f14").bind(_s28)])
		v_side_72 = (0.3 if (randf() < 0.5) else 0.7)
		J.mc(J.G.get("Theater"), "float", [J.mul(_s28["W"], v_side_72), J.sub(v_top_68, 34.0), ("好嘢！再嚟！" if J.seq(v_code_63, "E") else J.gp(["哈哈哈哈！", "笑死我！", "哈哈哈！"], floor(J.num((randf() * 3.0))))), ("#ffcf6a" if J.seq(v_code_63, "E") else "#ffe9a8"), (30.0 if J.seq(v_code_63, "E") else 24.0), 1.4])
		if J.seq(v_code_63, "E"):
			J.mc(J.G.get("Theater"), "joss", [30.0])
			if J.t(J.gp(J.G.get("Sound"), "play")):
				J.mc(J.G.get("Sound"), "play", ["gong"])
		else:
			if J.t(J.gp(J.G.get("Sound"), "play")):
				J.mc(J.G.get("Sound"), "play", ["praise"])
	else:
		if J.seq(v_code_63, "l"):
			var _t50 = J.mc(_s28["A"], "slice", [])
			var _t51 = J.mc(_t50, "sort", [Callable(self, "_f16").bind(_s28)])
			var _t52 = J.mc(_t51, "slice", [0.0, 2.0])
			J.mc(_t52, "forEach", [_s28["laugh"]])
		else:
			if J.seq(v_code_63, "c"):
				J.mc(_s28["A"], "forEach", [Callable(self, "_f17").bind(_s28)])
				J.mc(J.G.get("Theater"), "float", [J.div(_s28["W"], 2.0), J.sub(v_top_68, 30.0), "啪啪啪啪", "#ffe9a8", 22.0])
			else:
				if J.seq(v_code_63, "?"):
					J.mc(J.G.get("Theater"), "float", [J.div(_s28["W"], 2.0), J.sub(v_top_68, 30.0), "……", "#c8c0d8", 26.0])
					v_x_76 = J.mc(_s28["A"], "find", [Callable(self, "_f18").bind(_s28)])
					if J.t(v_x_76):
						var _t53 = _s28["laugh"]
						J.cl(_t53, null, [v_x_76])
						J.mc(J.G.get("Theater"), "float", [J.gp(v_x_76, "px"), J.sub(v_top_68, 60.0), "（只有他在笑）", "#ffe9a8", 16.0, 1.8])

func _f20(this_, a: Array, env):
	var v_x_85 = null
	v_x_85 = J.arg(a, 0)
	return J.seq(J.gp(v_x_85, "id"), env["id"])

func _f21(this_, a: Array, env):
	var v_res_86 = null; var v_msg_87 = null; var v_e_88 = null; var v_r_89 = null; var v_e_90 = null
	v_res_86 = J.arg(a, 0)
	var _t62 = (not J.t(env["s"]))
	if J.t((_t62 if _t62 else J.gp(v_res_86, "skipped"))):
		J.cl(J.G.get("save"), null, [])
		if J.t(J.gp(env["opt"], "after")):
			J.mc(env["opt"], "after", [])
		return null
	var _t63 = J.gp(env["s"], "seen")
	var _t64 = J.gp(env["b"], "id")
	J.sp(_t63, _t64, 1.0)
	var _t65 = env["s"]
	var _t66 = J.add(J.S_Date_("now", []), ((10.0 * 60.0) * 1000.0))
	J.sp(_t65, "buff", _t66)
	v_msg_87 = "笑到肚痛：村民工作速度 +10%（10 分鐘）"
	if J.t(((not J.t(J.gp(env["opt"], "replay"))) if J.t(env["first"]) else env["first"])):
		var _t67 = J.G.get("give")
		var _t68 = J.G.get("rwd")
		v_r_89 = J.cl(_t67, null, [{"coins": J.cl(_t68, null, [40.0])}])
		v_msg_87 = (J.str(v_r_89) + "<br>" + J.str(v_msg_87))
	J.mc(J.G.get("Fx"), "toast", [("棟篤笑：<b>" + J.str(v_msg_87) + "</b>")])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	if J.t(J.gp(env["opt"], "after")):
		J.mc(env["opt"], "after", [])

func _f19(this_, a: Array, env):
	var _s42 = {"__p": env, "id": null, "opt": null, "b": null, "s": null, "first": null}
	_s42["id"] = J.arg(a, 0)
	_s42["opt"] = J.arg(a, 1)
	_s42["b"] = (J.mc(J.G.get("SU_BITS"), "find", [Callable(self, "_f20").bind(_s42)]) if J.seq(J.typeof_(_s42["id"]), "string") else _s42["id"])
	if (not J.t(_s42["b"])):
		return false
	var _t54 = (_s42["opt"] if J.t(_s42["opt"]) else {})
	_s42["opt"] = _t54
	_s42["s"] = J.cl(_s42["__p"]["st"], null, [])
	_s42["first"] = ((not J.t(J.gp(J.gp(_s42["s"], "seen"), J.gp(_s42["b"], "id")))) if J.t(_s42["s"]) else _s42["s"])
	var _t56 = J.gp(_s42["b"], "who")
	var _t55 = J.G.get("L")
	var _t58 = (J.str(_t56) + "《" + J.str(J.cl(_t55, null, [J.gp(_s42["b"], "title")])) + "》")
	var _t59 = [[J.gp(_s42["b"], "who"), J.gp(_s42["b"], "k"), {"face": false}]]
	var _t57 = _s42["__p"]["audience"]
	var _t61 = J.cl(_t57, null, [_s42["b"]])
	var _t60 = _s42["__p"]["beats"]
	J.mc(J.G.get("Theater"), "play", [{"mode": "standup", "tag": "棟篤笑", "title": _t58, "bg": "street", "banner": "棟篤笑・今晚開咪", "cast": _t59, "aud": _t61, "lines": J.cl(_t60, null, [_s42["b"]]), "react": _s42["__p"]["react"]}, Callable(self, "_f21").bind(_s42)])
	return true

func _f23(this_, a: Array, env):
	var v_b_98 = null
	v_b_98 = J.arg(a, 0)
	var _t74 = env["__p"]["ok"]
	var _t75 = J.cl(_t74, null, [v_b_98])
	return ((not J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_b_98, "id")))) if J.t(_t75) else _t75)

func _f24(this_, a: Array, env):
	var v_b_99 = null; var v_o_100 = null
	v_b_99 = J.arg(a, 0)
	var _t77 = env["__p"]["ok"]
	v_o_100 = J.cl(_t77, null, [v_b_99])
	var _t81 = ("" if J.t(v_o_100) else "off")
	var _t82 = J.gp(v_b_99, "id")
	var _t83 = ("" if J.t(v_o_100) else "disabled")
	var _t84 = (J.gp(v_b_99, "k") if J.t(v_o_100) else "")
	var _t80 = null
	if J.t(v_o_100):
		var _t79 = J.gp(v_b_99, "who")
		var _t78 = J.G.get("L")
		_t80 = (J.str(_t79) + "《" + J.str(J.cl(_t78, null, [J.gp(v_b_99, "title")])) + "》")
	else:
		_t80 = "？？？"
	return ("<button class=\"sp-it " + _t81 + "\" data-id=\"" + J.str(_t82) + "\" " + _t83 + "><canvas data-k=\"" + J.str(_t84) + "\" width=\"112\" height=\"112\"></canvas><span><b>" + _t80 + "</b><small>" + (J.add("改編自 ", J.gp(v_b_99, "src")) if J.t(v_o_100) else J.add("解鎖：", J.gp(v_b_99, "hint"))) + "</small></span>" + ("<em>新</em>" if J.t(((not J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_b_99, "id")))) if J.t(v_o_100) else v_o_100)) else "") + "</button>")

func _f25(this_, a: Array, env):
	var v_c_101 = null; var v_k_102 = null; var v_p_103 = null; var v_e_104 = null
	v_c_101 = J.arg(a, 0)
	v_k_102 = J.gp(J.gp(v_c_101, "dataset"), "k")
	if (not J.t(v_k_102)):
		return null
	v_p_103 = J.mc(J.G.get("ART"), "portrait", [v_k_102, 56.0, {"tamed": true, "untied": true}])
	var _t90 = J.gp(v_p_103, "width")
	J.sp(v_c_101, "width", _t90)
	var _t91 = J.gp(v_p_103, "height")
	J.sp(v_c_101, "height", _t91)
	var _t92 = J.mc(v_c_101, "getContext", ["2d"])
	J.mc(_t92, "drawImage", [v_p_103, 0.0, 0.0])

func _f26(this_, a: Array, env):
	var _t93 = J.gp(env["el"], "classList")
	J.mc(_t93, "remove", ["on"])
	var _t94 = env["el"]
	J.sp(_t94, "innerHTML", "")
	if J.t(env["onClose"]):
		J.cl(env["onClose"], null, [])

func _f27(this_, a: Array, env):
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	J.cl(env["close"], null, [])

func _f30(this_, a: Array, env):
	var _t102 = env["__p"]["__p"]["openPicker"]
	return J.cl(_t102, null, [env["__p"]["onClose"]])

func _f29(this_, a: Array, env):
	if J.t(J.gp(env["btn"], "disabled")):
		return null
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["gong"])
	var _t99 = J.gp(env["__p"]["el"], "classList")
	J.mc(_t99, "remove", ["on"])
	var _t100 = env["__p"]["el"]
	J.sp(_t100, "innerHTML", "")
	var _t101 = env["__p"]["__p"]["play"]
	J.cl(_t101, null, [J.gp(J.gp(env["btn"], "dataset"), "id"), {"after": Callable(self, "_f30").bind(env)}])

func _f28(this_, a: Array, env):
	var _s63 = {"__p": env, "btn": null}
	_s63["btn"] = J.arg(a, 0)
	var _t98 = _s63["btn"]
	var _t103 = Callable(self, "_f29").bind(_s63)
	J.sp(_t98, "onclick", _t103)
	return _t103

func _f22(this_, a: Array, env):
	var v_n_96 = null
	var _s53 = {"__p": env, "onClose": null, "el": null, "s": null, "close": null}
	_s53["onClose"] = J.arg(a, 0)
	_s53["el"] = J.S_document_("getElementById", ["su-pick"])
	if (not J.t(_s53["el"])):
		var _t69 = J.S_document_("createElement", ["section"])
		_s53["el"] = _t69
		var _t70 = _s53["el"]
		J.sp(_t70, "id", "su-pick")
		var _t71 = J.S_document_("getElementById", ["app"])
		var _t72 = (_t71 if J.t(_t71) else J.gp(J.G.get("document"), "body"))
		J.mc(_t72, "appendChild", [_s53["el"]])
	var _t73 = J.cl(_s53["__p"]["st"], null, [])
	_s53["s"] = (_t73 if J.t(_t73) else {"seen": {}})
	v_n_96 = J.len(J.mc(J.G.get("SU_BITS"), "filter", [Callable(self, "_f23").bind(_s53)]))
	var _t76 = _s53["el"]
	var _t86 = (("<br>今晚有 <b>" + J.str(v_n_96) + "</b> 段還沒看。") if J.t(v_n_96) else "")
	var _t85 = J.mc(J.G.get("SU_BITS"), "map", [Callable(self, "_f24").bind(_s53)])
	var _t87 = ("<div class=\"sp-h\"><b>冥街夜市・棟篤笑</b><button class=\"btn sm\" id=\"sp-x\">離開</button></div>\n      <p class=\"sp-sub\">夜市盡頭有個小舞台，村裡的鬼輪流上台。看完會「笑到肚痛」：村民工作速度 +10%，持續 10 分鐘。第一次看另有冥幣。" + _t86 + "</p>\n      <div class=\"sp-list\">" + J.str(J.mc(_t85, "join", [""])) + "</div>")
	J.sp(_t76, "innerHTML", _t87)
	var _t88 = J.gp(_s53["el"], "classList")
	J.mc(_t88, "add", ["on"])
	var _t89 = J.mc(_s53["el"], "querySelectorAll", ["canvas[data-k]"])
	J.mc(_t89, "forEach", [Callable(self, "_f25").bind(_s53)])
	_s53["close"] = Callable(self, "_f26").bind(_s53)
	var _t95 = J.mc(_s53["el"], "querySelector", ["#sp-x"])
	var _t96 = Callable(self, "_f27").bind(_s53)
	J.sp(_t95, "onclick", _t96)
	var _t97 = J.mc(_s53["el"], "querySelectorAll", [".sp-it"])
	J.mc(_t97, "forEach", [Callable(self, "_f28").bind(_s53)])

func _f32(this_, a: Array, env):
	var v_kind_112 = null; var v_v_113 = null
	v_kind_112 = J.arg(a, 0)
	v_v_113 = J.mc(env["om"], "apply", [this_, a])
	var _t105 = J.seq(v_kind_112, "work")
	var _t106 = (J.G.get("S") if _t105 else _t105)
	var _t107 = (J.gp(J.G.get("S"), "su") if J.t(_t106) else _t106)
	return (J.mul(v_v_113, 1.1) if J.t((J.cmp(J.gp(J.gp(J.G.get("S"), "su"), "buff"), J.S_Date_("now", []), ">") if J.t(_t107) else _t107)) else v_v_113)

func _f34(this_, a: Array, env):
	var v_b_121 = null
	v_b_121 = J.arg(a, 0)
	var _t112 = env["__p"]["__p"]["ok"]
	var _t113 = J.cl(_t112, null, [v_b_121])
	return ((not J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_b_121, "id")))) if J.t(_t113) else _t113)

func _f35(this_, a: Array, env):
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	J.cl(env["__p"]["__p"]["openPicker"], null, [])

func _f33(this_, a: Array, env):
	var v_r_116 = null; var v_chips_117 = null; var v_n_119 = null; var v_b_120 = null; var v_e_122 = null
	v_r_116 = J.mc(env["orp"], "apply", [this_, a])
	var _t110 = J.gp(this_, "view")
	if J.t((J.seq(J.gp(J.gp(this_, "view"), "k"), "idle") if J.t(_t110) else _t110)):
		v_chips_117 = J.S_document_("querySelector", ["#gs-panel .gs-chips"])
		if J.t(((not J.t(J.S_document_("querySelector", ["#gs-panel .su-wide"]))) if J.t(v_chips_117) else v_chips_117)):
			var _s72 = {"__p": env, "s": null}
			var _t111 = J.cl(_s72["__p"]["__p"]["st"], null, [])
			_s72["s"] = (_t111 if J.t(_t111) else {"seen": {}})
			v_n_119 = J.len(J.mc(J.G.get("SU_BITS"), "filter", [Callable(self, "_f34").bind(_s72)]))
			v_b_120 = J.S_document_("createElement", ["button"])
			J.sp(v_b_120, "className", "btn gold wide su-wide")
			var _t114 = ("棟篤笑・今晚開咪" + (("<small>（" + J.str(v_n_119) + " 段新節目）</small>") if J.t(v_n_119) else ""))
			J.sp(v_b_120, "innerHTML", _t114)
			var _t115 = Callable(self, "_f35").bind(_s72)
			J.sp(v_b_120, "onclick", _t115)
			var _t116 = J.gp(v_chips_117, "parentNode")
			J.mc(_t116, "insertBefore", [v_b_120, J.gp(v_chips_117, "nextSibling")])
	return v_r_116

func _f37(this_, a: Array, env):
	var v_b_132 = null
	v_b_132 = J.arg(a, 0)
	var _t125 = ("" if J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_b_132, "id"))) else "ghost")
	var _t126 = J.gp(v_b_132, "id")
	var _t127 = ("" if J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_b_132, "id"))) else "disabled")
	var _t124 = null
	if J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_b_132, "id"))):
		var _t122 = J.gp(v_b_132, "who")
		var _t121 = J.G.get("L")
		_t124 = ("<small>" + J.str(_t122) + "</small>　" + J.str(J.cl(_t121, null, [J.gp(v_b_132, "title")])))
	else:
		var _t123 = env["__p"]["__p"]["ok"]
		_t124 = (J.add("？？？（", ("到冥街夜市觀看" if J.t(J.cl(_t123, null, [v_b_132])) else J.gp(v_b_132, "hint"))) + "）")
	return ("<button class=\"btn wide " + _t125 + "\" data-su=\"" + J.str(_t126) + "\" " + _t127 + ">" + _t124 + "</button>")

func _f40(this_, a: Array, env):
	var _t133 = env["__p"]["__p"]["__p"]["play"]
	return J.cl(_t133, null, [J.gp(J.gp(env["x"], "dataset"), "su"), {"replay": true}])

func _f39(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.F_setTimeout([Callable(self, "_f40").bind(env), 60.0])

func _f38(this_, a: Array, env):
	var _s82 = {"__p": env, "x": null}
	_s82["x"] = J.arg(a, 0)
	var _t132 = _s82["x"]
	var _t134 = Callable(self, "_f39").bind(_s82)
	J.sp(_t132, "onclick", _t134)
	return _t134

func _f41(this_, a: Array, env):
	var _t138 = env["lb"]
	var _t139 = ("對白：" + ("中文（點擊切換為粵語）" if J.seq(J.gp(J.G.get("LANG"), "cur"), "zh") else "粵語（點擊切換為中文）"))
	J.sp(_t138, "textContent", _t139)

func _f42(this_, a: Array, env):
	J.mc(J.G.get("LANG"), "toggle", [])
	J.cl(env["lab"], null, [])
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])

func _f36(this_, a: Array, env):
	var v_r_126 = null; var v_body_127 = null; var v_hr_128 = null; var v_snd_129 = null; var v_div_131 = null; var v_e_136 = null
	v_r_126 = J.mc(env["os"], "apply", [this_, a])
	v_body_127 = J.S_document_("querySelector", ["#sheet .sh-body"])
	v_hr_128 = (J.mc(v_body_127, "querySelector", ["hr"]) if J.t(v_body_127) else v_body_127)
	if J.t(v_hr_128):
		var _s80 = {"__p": env, "s": null}
		var _t120 = J.cl(_s80["__p"]["__p"]["st"], null, [])
		_s80["s"] = (_t120 if J.t(_t120) else {"seen": {}})
		v_div_131 = J.S_document_("createElement", ["div"])
		var _t128 = J.mc(J.G.get("SU_BITS"), "map", [Callable(self, "_f37").bind(_s80)])
		var _t129 = ("<h4 class=\"stand-h\">冥街夜市・棟篤笑</h4><p class=\"desc\">在冥街夜市看過的節目，可以在這裡重溫。</p><div class=\"slist\">" + J.str(J.mc(_t128, "join", [""])) + "</div>")
		J.sp(v_div_131, "innerHTML", _t129)
		var _t130 = J.gp(v_hr_128, "parentNode")
		J.mc(_t130, "insertBefore", [v_div_131, v_hr_128])
		var _t131 = J.mc(v_div_131, "querySelectorAll", ["[data-su]"])
		J.mc(_t131, "forEach", [Callable(self, "_f38").bind(_s80)])
	v_snd_129 = J.S_document_("getElementById", ["sndbtn"])
	var _t135 = ((not J.seq(J.typeof_(J.G.get("LANG")), "undefined")) if J.t(v_snd_129) else v_snd_129)
	if J.t(((not J.t(J.S_document_("getElementById", ["langbtn"]))) if J.t(_t135) else _t135)):
		var _s85 = {"__p": env, "lb": null, "lab": null}
		_s85["lb"] = J.S_document_("createElement", ["button"])
		var _t136 = _s85["lb"]
		J.sp(_t136, "className", "btn wide")
		var _t137 = _s85["lb"]
		J.sp(_t137, "id", "langbtn")
		_s85["lab"] = Callable(self, "_f41").bind(_s85)
		J.cl(_s85["lab"], null, [])
		var _t140 = _s85["lb"]
		var _t141 = Callable(self, "_f42").bind(_s85)
		J.sp(_t140, "onclick", _t141)
		var _t142 = J.gp(v_snd_129, "parentNode")
		J.mc(_t142, "insertBefore", [_s85["lb"], J.gp(v_snd_129, "nextSibling")])
	return v_r_126

func _f44(this_, a: Array, env):
	var v_x_139 = null
	v_x_139 = J.arg(a, 0)
	var _t146 = env["__p"]["ok"]
	var _t147 = J.cl(_t146, null, [v_x_139])
	var _t148 = ((not J.t(J.gp(J.gp(env["s"], "ann"), J.gp(v_x_139, "id")))) if J.t(_t147) else _t147)
	return ((not J.t(J.gp(J.gp(env["s"], "seen"), J.gp(v_x_139, "id")))) if J.t(_t148) else _t148)

func _f43(this_, a: Array, env):
	var v_b_138 = null; var v_e_140 = null
	var _s90 = {"__p": env, "s": null}
	_s90["s"] = J.cl(_s90["__p"]["st"], null, [])
	var _t144 = (not J.t(_s90["s"]))
	var _t145 = (_t144 if _t144 else J.seq(J.typeof_(J.G.get("Skits")), "undefined"))
	if (_t145 if _t145 else (not J.t(J.mc(J.G.get("Skits"), "quiet", [])))):
		return null
	v_b_138 = J.mc(J.G.get("SU_BITS"), "find", [Callable(self, "_f44").bind(_s90)])
	if (not J.t(v_b_138)):
		return null
	var _t149 = J.gp(_s90["s"], "ann")
	var _t150 = J.gp(v_b_138, "id")
	J.sp(_t149, _t150, 1.0)
	var _t152 = J.gp(v_b_138, "who")
	var _t151 = J.G.get("L")
	J.mc(J.G.get("Fx"), "toast", [("冥街夜市・棟篤笑：<b>" + J.str(_t152) + "《" + J.str(J.cl(_t151, null, [J.gp(v_b_138, "title")])) + "》</b>今晚登台。<br><small>出村 → 冥街夜市 → 棟篤笑</small>")])
	J.cl(J.G.get("save"), null, [])

func _f31(this_, a: Array, env):
	if (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined")):
		var _s67 = {"__p": env, "om": null, "orp": null}
		_s67["om"] = J.gp(J.G.get("GhostStreet"), "mul")
		var _t104 = J.G.get("GhostStreet")
		var _t108 = Callable(self, "_f32").bind(_s67)
		J.sp(_t104, "mul", _t108)
		_s67["orp"] = J.gp(J.G.get("GhostStreet"), "renderPanel")
		var _t109 = J.G.get("GhostStreet")
		var _t117 = Callable(self, "_f33").bind(_s67)
		J.sp(_t109, "renderPanel", _t117)
	var _t118 = (not J.seq(J.typeof_(J.G.get("UI")), "undefined"))
	if J.t((J.gp(J.G.get("UI"), "openStory") if _t118 else _t118)):
		var _s77 = {"__p": env, "os": null}
		_s77["os"] = J.gp(J.G.get("UI"), "openStory")
		var _t119 = J.G.get("UI")
		var _t143 = Callable(self, "_f36").bind(_s77)
		J.sp(_t119, "openStory", _t143)
	J.F_setInterval([Callable(self, "_f43").bind(env), 4000.0])

func _f6(this_, a: Array, env):
	var v_k_40 = null
	v_k_40 = J.arg(a, 0)
	var _t154 = (not J.seq(J.typeof_(J.G.get("sprOk")), "function"))
	if not J.t(_t154):
		var _t153 = J.G.get("sprOk")
		_t154 = J.cl(_t153, null, [v_k_40])
	return _t154

func _f7(this_, a: Array, env):
	var v_b_41 = null
	v_b_41 = J.arg(a, 0)
	var _t156 = J.G.get("S")
	if J.t(_t156):
		var _t155 = (not J.t(J.gp(v_b_41, "need")))
		_t156 = (_t155 if _t155 else J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_b_41, "need")))
	var _t158 = _t156
	if J.t(_t158):
		var _t157 = env["art"]
		_t158 = J.cl(_t157, null, [J.gp(v_b_41, "k")])
	return (not (not J.t(_t158)))

func _f4(this_, a: Array, env):
	var v_install_36 = null
	var _s15 = {"__p": env, "FILL": null, "NAMES": null, "KEY": null, "st": null, "art": null, "ok": null, "audience": null, "beats": null, "react": null, "play": null, "openPicker": null}
	_s15["st"] = Callable(self, "_f5").bind(_s15)
	_s15["audience"] = Callable(self, "_f8").bind(_s15)
	_s15["beats"] = Callable(self, "_f10").bind(_s15)
	_s15["react"] = Callable(self, "_f11").bind(_s15)
	_s15["play"] = Callable(self, "_f19").bind(_s15)
	_s15["openPicker"] = Callable(self, "_f22").bind(_s15)
	v_install_36 = Callable(self, "_f31").bind(_s15)
	_s15["FILL"] = ["egui", "youhun", "zombie", "shuigui", "zhiren", "xiaozhi"]
	_s15["NAMES"] = {"egui": "餓鬼", "youhun": "遊魂阿強", "zombie": "殭屍兵", "shuigui": "水鬼", "zhiren": "紙人偶", "xiaozhi": "小紙", "n30_xiaosi": "笑死鬼"}
	_s15["KEY"] = {"笑死鬼": "n30_xiaosi", "遊魂阿強": "youhun", "孤寒鬼": "n30_guhangui", "天花姐": "tianhua", "窮鬼": "n30_qionggui", "牛頭": "niutou"}
	_s15["art"] = Callable(self, "_f6").bind(_s15)
	_s15["ok"] = Callable(self, "_f7").bind(_s15)
	J.cl(v_install_36, null, [])
	return {"play": _s15["play"], "openPicker": _s15["openPicker"], "list": J.G.get("SU_BITS"), "ok": _s15["ok"], "st": _s15["st"], "audience": _s15["audience"]}
