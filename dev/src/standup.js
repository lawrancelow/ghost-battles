// ===================== 冥街夜市・棟篤笑（standup.js）＋ 主線串場 =====================
// 1) SU_BITS：冥街夜市小舞台嘅棟篤笑。改編自死不正經 su／gh／KS 系列；一隻鬼企喺咪前面講，台下有觀眾笑、喝倒彩。
//    跟主線進度解鎖（need = 睇過邊段劇情）。睇完：第一次有冥幣；每次都有「笑到碌地」：村民做嘢快 10%，維持 10 分鐘。
//    入口：冥街夜市下面面板多咗個「棟篤笑」掣（包住 GhostStreet.renderPanel，唔改 ghoststreet.js）。
// 2) XO：主線串場。su／gh／KS 嘅角色喺主線章節前後亂入（包住 Story.queue：某段劇情之後自動接一段，只會出一次）。
// 存檔：S.su = { seen:{}, ann:{}, buff:時間戳 }（舊存檔自動補）。
// 台詞格式：[台詞, 觀眾反應, 動作?]；反應：'L' 大笑、'l' 細笑、'c' 拍手、'?' 冷場、{ h:喝倒彩嗰個, t:佢講咩, back:表演者點回, r:回完之後嘅反應 }
const SU_BITS = [
{ id:'su06', who:'阿福', k:'afu', title:'凶宅打七折', src:'su06 凶宅打七折', need:'prologue_sys', hint:'序章之後', lines:[
  ['大家好，我係阿福。今日想講件好傷心嘅事：我，俾人劈價。', 'l'],
  ['我係死喺公司會議室嘅，唔關間屋事。不過死咗之後，我成日返屋企搞吓嘢：開吓燈、跌吓碗，等阿媽知我仲掛住佢。結果佢同阿爸決定賣屋，放上網寫：雙層排屋，近學校，近巴剎，有少少故事。', 'l'],
  ['有少少故事。我係一個人嚟㗎，唔係一個故事。', 'L'],
  ['第一對買家嚟睇屋。太太一入門就細細聲問：「呢間屋……係咪有嗰啲？」中介好專業：「安娣放心，呢間好熱鬧㗎。」', 'l'],
  ['先生即刻撳計數機：「有嗰啲嘅話，再平五萬。」五萬！我幫你睇咗三年門、趕咗三年老鼠，我淨係值五萬？隔籬有白蟻嗰間，都平八萬。我連白蟻都爭唔過。', { h:'笑死鬼', t:'哈哈哈哈！白蟻贏你！', back:'係，白蟻起碼有隊友。', r:'L' }],
  ['我好嬲，嗰晚就去嚇佢哋：盞燈開開熄熄、開開熄熄。太太尖叫，先生好冷靜，攞部電話出嚟影：「你睇，燈閃成噉，電線有問題，再平兩萬。」', 'L', 'argue'],
  ['我越努力嚇人，間屋就越平。最後成交價：七折。原來我喺呢個屋企最大嘅貢獻，係幫佢打折。', 'L'],
  ['新屋主搬入嚟第一日，喺門口貼咗張紙：「屋內須知。一，夜晚十一點之後唔准開關燈。二，用完廁所要沖水。」', 'L'],
  ['我喺呢間屋大咗三十年，死咗三年都冇搬走，而家返屋企，第一次要睇人哋屋規。我變咗租客。', 'L', 'bow'],
 ], end:'台下馬上有一隻遊魂舉手：「嗰間仲有冇得租？」' },
{ id:'ks10', who:'倀鬼', k:'n30_changgui', title:'你信我', src:'KS10 為虎作倀', need:'xo_ch1', hint:'第一章之後', lines:[
  ['朋友，你信我，呢個係一個改變人生嘅機會。……我就係咁樣，俾老虎食咗。', 'L', 'n30:whistle'],
  ['我係倀鬼，為虎作倀嗰個倀。三百年前喺山上俾老虎咬死。規矩係：俾老虎食咗嘅人唔走得，要帶下一個嚟俾佢食，先可以收工。', 'l'],
  ['我梗係唔會講「嚟俾老虎食」啦，冇人嚟㗎嘛。我講：「兄弟，有冇興趣識個大佬？好有實力，好照顧自己人。」', 'L'],
  ['第一個係我表哥。佢問我危唔危險，我話：「我自己都喺入面，你睇我有冇事？」佢望一望我，塊面青晒——佢話好。', 'L'],
  ['表哥俾老虎食咗，變咗我嘅 downline。佢再搵佢同學、佢鄰居、佢前度。三百年落嚟，我哋團隊九百人。老虎年年開大會，頒個獎俾我：鑽石級倀鬼。', 'l', 'n30:pet'],
  ['台下九百隻鬼一齊拍手，全部都係我害死嘅，全部都好感激我。', { h:'遊魂阿強', t:'咁你哋有冇買保險㗎？', back:'有，受益人寫老虎。', r:'L' }],
  ['我最佩服你哋而家啲人。我哋以前要呃先有人嚟，你哋係自己報名。網上一個課程：「三個月財務自由」，四千九，大家排隊過數。老虎食咗三百年，都未試過食得咁飽。', 'L'],
  ['上個月，老虎老咗，啲牙跌晒，咬唔郁。我好驚，問佢：「噉我哋點算？」佢好慈祥噉望住我：「唔使咬喇，你哋繼續搵人就得。」', 'l'],
  ['我嗰陣先明白：三百年嚟食人嘅，從來都唔係隻老虎。', 'L'],
 ], end:'散場後，有三隻鬼在後台排隊問：「入會要幾錢？」' },
{ id:'ks09', who:'窮鬼', k:'n30_qionggui', title:'其實都 OK', src:'KS09 鬼也會窮死', need:'ch2_end', hint:'第二章之後', lines:[
  ['（執一執衫領）你哋驚鬼，咁鬼驚咩？鬼驚聻。人死咗變鬼，鬼死咗變聻。我下個月，就由鬼降級做聻。', 'L', 'n30:pockets'],
  ['其實都 OK。我生前係中產，有車、有樓、有張金卡。中產係咩？窮人覺得你有錢，有錢人覺得你窮，銀行覺得你啱啱好——啱啱好借得。', 'L'],
  ['我以為企喺中間好安全，上面有人，下面有人。後來公司一裁員我先知，中產唔係一層樓，係一部 lift，得一個向下嘅掣。', 'L'],
  ['死咗變鬼，以為到底喇。點知下面都要供樓：陰宅，三十五年分期。', 'l'],
  ['其實都 OK。我上個月去查 EPF，第三戶口淨返四十八蚊，最少五十先攞得。連我自己啲錢，都嫌我唔夠格。', { h:'孤寒鬼', t:'差兩蚊咋嘛！借俾你，利息三分！', back:'多謝。其實都 OK。', r:'L' }],
  ['我問下面啲聻：「下面仲有冇？」佢話有。我問叫咩，佢話：「你唔使知，你好快就會知。」', 'l', 'n30:coin'],
  ['上個禮拜，我撞到以前個老細。佢都落咗嚟，仲係鬼，坐喺我哋上面嗰層，飲住拉茶望落嚟。我忍唔住問：「老細，點解你一直都冇跌落嚟嘅？」', 'l'],
  ['佢笑一笑：「因為我下面，有你哋。」', 'L'],
 ], end:'台下很多鬼摸了摸自己的錢包，安靜了很久。' },
{ id:'gh228', who:'老殭', k:'laojiang', title:'三十六計', src:'gh228 諸葛亮做顧問', need:'ch3_end', hint:'第三章之後', lines:[
  ['本官讀咗一世兵書。死咗兩百年先發覺：啲兵法，全部去咗你哋嘅寫字樓。', 'l'],
  ['先講草船借箭。諸葛亮用草船擋箭，箭自己送上門。你哋開會，將實習生推去坐最前面——老細啲箭，全部射落佢度。', 'L'],
  ['散會之後，實習生成身插滿箭。你哋執返啲箭，拎去寫自己份報告。呢個，就叫「借」。', 'L'],
  ['再講空城計。城門大開，城入面冇兵，嚇退敵軍。你哋老細年年都用：「今年公司好困難，冇花紅。」', 'l'],
  ['城門口，泊住架新保時捷。', { h:'窮鬼', t:'咁點樣破佢條計？', back:'破唔到。城係佢嘅，架車都係佢嘅。', r:'L' }],
  ['最勁係諸葛亮嗰句：「鞠躬盡瘁，死而後已。」你哋老細最鍾意裱起佢，掛喺會議室。', 'l'],
  ['本官研究咗兩百年，終於明白：死而後已——要等老細死咗，你先可以「已」。', 'L'],
  ['所以本官一直企喺度等。等咗兩百年，老細未死，大清死咗。', 'L'],
 ], end:'老殭講完，台下的打工鬼紛紛低頭抄筆記。' },
{ id:'ks03', who:'裂口女', k:'n30_kuchisake', title:'我靚唔靚？', src:'KS03 裂口女醫美', need:'ch4_intro', hint:'第四章開始之後', lines:[
  ['（戴住口罩，眨眨眼）各位晚安～第一條問題：我靚唔靚？……唔好答住，我仲未除口罩。', 'l', 'n30:ask'],
  ['我係裂口女。以前我喺街口截住人問：「我靚唔靚？」你話靚，我就除口罩：「噉而家呢？」塊嘴裂到去耳仔。', 'l'],
  ['你話唔靚，我會嬲。你話「麻麻地」，我會企喺度諗成晚——因為劇本冇寫呢個答案。', 'L'],
  ['以前大家見到我好驚。而家？我除咗口罩，個後生女望一望：「姐姐，你係咪啱啱打完 filler？邊間做㗎？」', 'L'],
  ['我呆咗。做咗鬼四十幾年，第一次有人問我攞 referral。', 'L'],
  ['我諗通咗，唔嚇人喇，轉行。而家我喺 TikTok 開直播：「姐妹們～想要我咁嘅微笑線，今晚三折，送埋口罩。」', 'L', 'n30:snip'],
  ['生意好到爆。我問：「我靚唔靚？」佢哋答：「靚！幾錢？」以前呢條問題要人命，而家呢條問題要人錢。', { h:'笑死鬼', t:'哈哈哈哈我要一個！', back:'好呀，先畀訂金。裂咗唔退。', r:'L' }],
  ['而家輪到你哋排隊問我：「姐姐，我靚唔靚？」我望一望：「麻麻地。」', 'l'],
  ['佢哋企喺度，諗咗成晚。', 'L', 'n30:ask'],
 ], end:'散場時，後台排了一條長長的隊，全是來問價的。' },
{ id:'ks08', who:'Hantu Galah', k:'n30_hantugalah', title:'唔好岳高頭', src:'KS08 不要抬頭', need:'ch4_end', hint:'第四章之後', lines:[
  ['唔好岳高頭望。我叫你哋唔好岳高頭望——jangan tengok atas。……你睇，又高咗。', 'L', 'n30:peer'],
  ['我係 Hantu Galah，竹竿鬼。原理好簡單：你越岳高頭望我，我就越高；你唔望，我就矮返落嚟。好公平，只要你忍得住。', 'l'],
  ['我以前喺鄉下，一年俾人望一兩次，最高都係椰樹咁高。後來搬咗上 KL，就完蛋。因為喺 KL，個個每日都岳高頭望——望樓價。', 'L'],
  ['你哋一路望一路講：「嘩，又升咗。」佢就又升咗，同我一個原理。我勸過個後生：「兄弟，唔好再望喇。」佢話：「我唔望，我媽每日問我幾時買樓。」', 'l'],
  ['佢媽問一次，我高一層。過年啲親戚再嚟個三連問：幾時買樓？幾時結婚？幾時生仔？我即刻高過 Merdeka 118。', 'L', 'n30:stretch'],
  ['全國有三萬幾間屋起好咗冇人買，夜晚黑麻麻，你哋話嗰度猛鬼。我入去睇過，冇鬼。鬼都想住㗎，去問銀行，銀行要三個月 salary slip。', { h:'窮鬼', t:'冥幣出糧得唔得㗎？', back:'得。冥幣嘅話，首期一百億。', r:'L' }],
  ['琴晚有個 uncle 終於買到樓，供三十五年。佢好開心，岳高頭同我講：「我終於唔使再望喇！」', 'l'],
  ['佢講完，我又高咗一截。因為佢而家改咗望利率。國家銀行開一次會，我高一次，要高足三十五年。', 'L', 'n30:peer'],
 ], end:'散場後，全場觀眾低著頭走了出去。' },
{ id:'ks07', who:'嚇死鬼', k:'n30_xiasi', title:'俾 AI 炒咗', src:'KS07 被 AI 裁掉的鬼', need:'ch5_intro', hint:'第五章開始之後', lines:[
  ['冇事，我好好。我只係俾人炒咗。我係鬼，俾 AI 炒咗。', 'L', 'n30:look'],
  ['我喺一間屋鬧咗二十年，資歷最深。半夜開燈熄燈、冷氣自己開、電視自己轉台，全部都係我嘅 KPI。', 'l'],
  ['後來屋主裝咗 smart home。燈自己開，冷氣自己開，半夜個喇叭仲會自己笑。我生前就係俾人嚇死嘅，死咗二十年，又俾部喇叭嚇死多次。', 'L', 'n30:jump'],
  ['屋主都唔驚喇。盞燈一閃，佢唔叫師傅，佢叫 Google：「Hey Google，唔好玩。」佢就唔玩。我玩咗二十年，從來冇人好好聲叫我唔好玩——其實我都會停㗎。', 'L'],
  ['我去 PERKESO 排隊攞失業援助，前面排咗五萬幾個人，一半著恤衫打呔，面青青，冇人出聲。我仲以為行錯路，返咗落嚟。', 'L'],
  ['櫃枱小姐叫我去 upskill，學 AI。我好認真上咗三個月堂，學識寫 prompt。第一個 prompt 我打：「幫我嚇人。」佢畫咗隻好可愛嘅鬼喺度比心。屋主攞咗去做 WhatsApp 頭像。', { h:'笑死鬼', t:'哈哈哈你用免費版㗎嘛！', back:'付費版要月費，我死咗冇出糧。', r:'L' }],
  ['上個禮拜停電，成間屋嘅 smart home 死晒，淨返我。我用盡二十年功力：燈閃，門響，冷笑三聲。屋主喺黑暗入面一啲都唔驚，仲好開心：「嘩，仲有後備！」', 'L'],
  ['我俾人降職喇。由鬼，變咗 power bank。', 'L', 'n30:look'],
 ], end:'台下很多鬼掏出手機，悄悄關掉了 Wi-Fi。' },
{ id:'ks06', who:'車禍鬼', k:'n30_chehuo', title:'暫時', src:'KS06 我暫時死了四十年', need:'xo_ch5', hint:'第五章之後', lines:[
  ['（清清喉嚨）各位，關於我嘅死，我喺度作出澄清：我係暫時死咗。一暫時，就四十年。', 'L', 'n30:mirror'],
  ['一九八六年，我喺大道撞車。醫生望咗一眼：「暫時冇生命跡象。」我就一直等嗰個「暫時」過去，等到今日。', 'l'],
  ['喺我哋大馬，「暫時」係最長命嘅兩個字。路暫時封，水暫時停，收費站話暫時收幾年——收到今日，長命過我。', 'L'],
  ['我出事嗰條大道，官方話暫時唔擴闊，成本太高。我聽完好安慰：四十年嚟，原來我哋兩個一樣，塞喺度，冇人救。', 'L'],
  ['我落嚟報到，櫃枱話我嘅資料跟進緊。我問幾時有結果，佢話會盡快。我問盡快係幾時，佢話有關當局會通知你。', 'l'],
  ['我問有關當局係邊個。佢望咗我好耐：「就係你而家問緊嗰個。」', { h:'牛頭', t:'喂！我冇講過喎！', back:'你睇，佢跟進緊。', r:'L' }],
  ['上個月終於輪到我銷案。排咗四十年，我好興奮。點知電腦一撳，彈出一行字：「系統顯示，此人仍然在世，名下有一張一九八六年嘅 saman 未還。」', 'L'],
  ['我問點會咁㗎。佢話：技術錯誤，唔使擔心——暫時嘅。', 'L', 'n30:rev'],
 ], end:'散場後，車禍鬼在出口排隊，排了很久。據說是暫時的。' },
{ id:'su07', who:'鬼新娘', k:'n30_guixinniang', title:'冥婚要面試', src:'su07 冥婚要面試', need:'ch6_intro', hint:'第六章開始之後', lines:[
  ['（整一整紅蓋頭）各位，今晚我嚟澄清一個謠言：冥婚，唔係你想娶就娶得。要面試㗎。', 'l', 'n30:veil'],
  ['我屋企人喺路邊放咗封紅包，邊個執到，就係我老公。好多人以為係撞彩，其實紅包入面有份表格：學歷、身高、月薪、有冇樓。', 'L'],
  ['第一個執到嘅係個 IT 仔。我問佢：「你有冇樓？」佢話：「我租緊。」我話：「我有墳，永久業權。」佢即刻自卑。', 'L'],
  ['第二個係 Grab 司機，好有誠意，一執到就話：「我到咗。」結果三個鐘之後先到。', 'L'],
  ['第三個最慘，做 sales 嘅。一坐低就問：「咁你有冇考慮過買保險？」我話：「我死咗喇。」佢話：「噉你屋企人呢？」', { h:'遊魂阿強', t:'嗰個係我徒弟嚟㗎！', back:'睇得出。死咗都唔放過人。', r:'L' }],
  ['最後我屋企人話我太揀擇，叫我降低要求。我話：「我死咗三十年，等咗三十年，要求高啲都唔得？」', 'l', 'n30:wait'],
  ['我媽話：「你再揀落去，就嫁唔出喇。」我話：「媽，我已經死咗，最差都係咁。」佢話：「唔係呀，最差係你啲表姐全部都嫁晒。」', 'L', 'n30:twirl'],
 ], end:'鬼新娘講完，把繡球拋向台下。全場觀眾立刻一哄而散。' },
];

// ===================== 主線串場（su／gh／KS 角色亂入）=====================
// XO_AFTER[劇情] = 喺嗰段之後接嘅串場。只會插一次（睇過就唔再插）；劇情回顧照樣可以重溫。
const XO_SCENES = {
xo_origin: { style:'talk', bg:'road', title:'陰間入職處', lines:[
  ['旁白','陰間入職處。負責審核新鬼的，是馬面。'],
  ['馬面','姓名？'],
  ['阿福','陳大福。公司啲人叫我 Kelvin。'],
  ['馬面','死因？'],
  ['阿福','過勞。死喺會議室。個會題目叫《如何減少加班》，六點半開，已經係第三次開——專登討論點解頭兩次開到咁夜。'],
  ['阿福','開到兩點四十七分，我喺枱底覆咗老細一個「好」字，就趴喺手提電腦個鍵盤度，走咗。'],
  ['馬面','會議紀錄點寫？'],
  ['阿福','「與會者一名，提早離場。」'],
  ['阿福','第二朝老細經過，見我仲趴住，佢話：「好！呢個肯搏。」第三日佢先發覺唔對路——因為我冇覆佢 WhatsApp。入職以嚟，第一次冇覆。'],
  ['馬面','（翻開本簿）生前做咩㗎？'],
  ['阿福','打工嘅。'],
  ['馬面','（即刻合埋本簿）咁你唔使審喇。你喺上面，已經捱過地獄。'],
]},
xo_paper: { style:'talk', bg:'village', lines:[
  ['旁白','小紙的背上，還貼著一張小小的紙。'],
  ['阿福','呢張係乜嘢？'],
  ['小紙','少爺，係我嘅保用證。紙紮舖話保用七日。'],
  ['阿福','保啲咩？'],
  ['小紙','遇水唔保，遇火唔保，遇風唔保。'],
  ['阿福','咁即係咩都唔保。'],
  ['小紙','仲有一條：如有問題，請直接搵老闆。'],
  ['阿福','老闆喺邊？'],
  ['小紙','（反轉張紙）上年已經落咗嚟喇。'],
  ['系統','親，本系統已幫你查到：他在隔壁村第三排，可以上門投訴哦～'],
]},
xo_ch1: { style:'talk', bg:'village', lines:[
  ['旁白','招魂台剛蓋好，就有一隻鬼笑著走過來，手裡拿著一疊卡片。'],
  ['倀鬼','老闆！恭喜開張！你信我，呢個招魂台，係你人生嘅轉捩點。'],
  ['阿福','你係？'],
  ['倀鬼','我係倀鬼，為虎作倀嗰個倀。我有個 plan：你招一隻鬼，佢再招兩隻，兩隻再招四隻，唔使三個月，成個地府都係你嘅 downline。'],
  ['阿福','咁最頂嗰個係邊個？'],
  ['倀鬼','（指一指身後）佢囉。'],
  ['旁白','他身後的樹叢裡，一雙黃色的眼睛眨了一下。'],
  ['系統','叮！檢測到高效招聘模式！親，本系統強烈推薦——'],
  ['阿福','唔要。'],
  ['倀鬼','冇問題，我唔逼人㗎。（遞上卡片）諗清楚再搵我。今晚冥街夜市，我有個分享會。'],
  ['系統','親，他的卡片印著「鑽石級」，很有福報呢。'],
  ['阿福','背面印住隻老虎。'],
]},
xo_ch2: { style:'chat', title:'媽', av:['媽','#8a5a6a'], lines:[
  ['媽','20:01|阿福，部手機收到未？'],
  ['阿福','20:03|收到喇媽'],
  ['媽','20:03|好'],
  ['媽','20:03|你阿爸叫我問你，下期開咩字'],
  ['阿福','20:04|媽，我係死咗，唔係去咗萬字公司做經理'],
  ['媽','20:04|你喺下面識人多嘛'],
  ['阿福','20:05|……0247 啦'],
  ['旁白','0247，是阿福斷氣那一刻的時間'],
  ['媽','20:05|好'],
  ['媽','20:05|唔中唔怪你'],
]},
xo_ch3: { style:'talk', bg:'village', lines:[
  ['旁白','老殭入村第一天，一枚銅錢掉在地上。'],
  ['阿福','大人，你個錢跌咗。'],
  ['老殭','本官知道。本官同佢，已經對望咗一炷香。'],
  ['小紙','少爺，殭屍唔識彎腰㗎。'],
  ['老殭','非也。本官識彎，只係兩百年冇彎過，條腰唔記得點彎。'],
  ['餓鬼王','（衝埋嚟執起個銅錢）我幫你！'],
  ['老殭','多謝。'],
  ['餓鬼王','（擺咗入口）……唔係食嘅？'],
  ['老殭','本官兩百年嚟，第一次見有人執到錢咁失望。'],
]},
xo_ch3b: { style:'chat', title:'媽', av:['媽','#8a5a6a'], lines:[
  ['媽','21:10|阿福！！！'],
  ['媽','21:10|中咗！！！0247！！！'],
  ['阿福','21:12|……真係中？'],
  ['媽','21:12|你阿爸話，以後一個禮拜上山睇你三次'],
  ['阿福','21:13|我生前佢一個月都唔打一次電話俾我'],
  ['媽','21:13|佢而家好掛住你㗎'],
  ['媽','21:14|佢叫你下期再報'],
  ['媽','21:15|仲有，你封 PTPTN 信寄咗返屋企，我燒埋落去俾你喇'],
  ['阿福','21:15|媽，唔使咁孝順'],
]},
xo_ch4: { style:'talk', bg:'village', lines:[
  ['旁白','去香蕉園的路上，有一根很高很高的竹竿，立在路中間。'],
  ['Hantu Galah','喂，後生仔，唔好岳高頭望。'],
  ['阿福','點解？'],
  ['Hantu Galah','你越望我，我越高。你睇，又高咗。'],
  ['小紙','少爺，佢真係高咗！'],
  ['Hantu Galah','靚女，你都唔好望。我高到掂到天，又要俾人投訴阻住飛機。'],
  ['阿福','咁我唔望你，你會點？'],
  ['Hantu Galah','我會矮返落嚟。所以呢，條村啲樓價，你哋都唔好望。'],
  ['系統','親，本系統已幫你看過了：落魄村樓價本月上漲三成！'],
  ['Hantu Galah','（又高咗一截）……邊個叫佢望㗎！'],
]},
xo_ch5: { style:'talk', bg:'kampung', lines:[
  ['旁白','紙紮法拉利剛落地，就有一隻戴著破頭盔的鬼走過來，繞著車轉了三圈。'],
  ['車禍鬼','先生，關於呢架車，我作出幾點跟進。'],
  ['阿福','你係？'],
  ['車禍鬼','我係車禍鬼。一九八六年喺大道出事，暫時死咗。'],
  ['車禍鬼','第一，呢架車冇安全帶。第二，冇倒後鏡。第三，個軚盤係印上去嘅。'],
  ['阿福','紙紮嘅，梗係揸唔郁。'],
  ['車禍鬼','揸唔郁好。我呢世人最安全嘅一次揸車，就係揸一架唔郁嘅車。'],
  ['小紙','少爺，佢好似好鍾意呢架車。'],
  ['車禍鬼','唔係鍾意，係跟進。（坐入駕駛位）我暫時坐一陣。'],
  ['旁白','他一坐，就坐了一整晚。'],
]},
xo_ch6: { style:'talk', bg:'hq', lines:[
  ['旁白','地府集團總部大堂。排隊的鬼，從門口一直排到奈何橋。'],
  ['牛頭','攞籌！'],
  ['阿福','我係嚟見 KPI 轉型顧問嘅。'],
  ['牛頭','約咗未？'],
  ['白無常','我哋押佢嚟嘅，有公文。'],
  ['牛頭','公文要先蓋印。蓋印要排隊。排隊要攞籌。攞籌要有公文。'],
  ['阿福','……咁要點開始？'],
  ['牛頭','（好認真）我喺度做咗八百年，都未搵到個開始。'],
  ['黑無常','行樓梯。'],
  ['旁白','四隻鬼爬了四十四層樓梯。'],
]},
};
const XO_AFTER = { prologue_road:['xo_origin'], gift_xiaozhi2:['xo_paper'], ch1_end:['xo_ch1'], gift_phone:['xo_ch2'], ch3_end:['xo_ch3', 'xo_ch3b'], ch4_intro2:['xo_ch4'], gift_car:['xo_ch5'], ch6_intro2:['xo_ch6'] };
const XO_SPEAKERS = { '倀鬼':'n30_changgui', 'Hantu Galah':'n30_hantugalah', '車禍鬼':'n30_chehuo', '牛頭':'niutou', '馬面':'mamian' };
(function installXO() {
  if (typeof SCENES === 'undefined') return;
  for (const id in XO_SCENES) if (!SCENES[id]) SCENES[id] = XO_SCENES[id];
  if (typeof SPEAKER_ART !== 'undefined') for (const n in XO_SPEAKERS) if (!SPEAKER_ART[n]) SPEAKER_ART[n] = XO_SPEAKERS[n];
  if (typeof SCENE_ORDER !== 'undefined') for (const row of SCENE_ORDER) { // 劇情回顧：串場跟住原本嗰段
    const ids = row[1]; for (const after in XO_AFTER) { const i = ids.indexOf(after); if (i < 0) continue; let j = i + 1; for (const x of XO_AFTER[after]) { if (ids.indexOf(x) < 0) ids.splice(j, 0, x); j = ids.indexOf(x) + 1; } }
  }
  if (typeof Story !== 'undefined' && Story.queue) {
    const oq = Story.queue;
    Story.queue = function (sc, cb) {
      const r = oq.call(this, sc, cb);
      if (typeof sc === 'string' && XO_AFTER[sc] && typeof S !== 'undefined' && S) for (const x of XO_AFTER[sc]) if (!S.seen[x] && SCENES[x] && !this.q.some(it => it.sc === x)) oq.call(this, x);
      return r;
    };
  }
})();

// ===================== 棟篤笑：引擎 =====================
const Standup = (() => {
  const FILL = ['egui', 'youhun', 'zombie', 'shuigui', 'zhiren', 'xiaozhi'];
  const NAMES = { egui:'餓鬼', youhun:'遊魂阿強', zombie:'殭屍兵', shuigui:'水鬼', zhiren:'紙人偶', xiaozhi:'小紙', n30_xiaosi:'笑死鬼' };
  const KEY = { '笑死鬼':'n30_xiaosi', '遊魂阿強':'youhun', '孤寒鬼':'n30_guhangui', '天花姐':'tianhua', '窮鬼':'n30_qionggui', '牛頭':'niutou' };
  function st() {
    if (typeof S === 'undefined' || !S) return null;
    const s = S.su = S.su || {}; s.seen = s.seen || {}; s.ann = s.ann || {}; s.buff = s.buff || 0; return s;
  }
  const art = (k) => typeof sprOk !== 'function' || sprOk(k);
  const ok = (b) => !!(S && (!b.need || S.seen[b.need]) && art(b.k));
  function audience(b) {
    const list = [], used = new Set([b.k]);
    const add = (name, k) => { if (used.has(k) || !art(k) || list.length >= 5) return; used.add(k); list.push([name, k]); };
    for (const l of b.lines) if (l[1] && typeof l[1] === 'object') add(l[1].h, KEY[l[1].h] || 'youhun'); // 有喝倒彩嘅一定坐喺台下
    add('笑死鬼', 'n30_xiaosi');
    for (const k of FILL) add(NAMES[k], k);
    // 坐位：喝倒彩嗰個唔好坐最邊
    if (list.length >= 3) { const h = list[0]; list.splice(0, 1); list.splice(Math.floor(list.length / 2), 0, h); }
    return list;
  }
  function beats(b) {
    const out = [];
    for (const l of b.lines) {
      const [text, re, act] = l;
      if (re && typeof re === 'object') { out.push({ who:b.who, text, act:act || null, react:'l' }); out.push({ who:re.h, text:re.t, react:'h' }); out.push({ who:b.who, text:re.back, react:re.r || 'L' }); }
      else out.push({ who:b.who, text, act:act || null, react:re || null });
    }
    out.push({ who:'旁白', text:b.end, react:'E' });
    return out;
  }
  // 台下反應：大笑、細笑、拍手、冷場（得笑死鬼一個笑）
  function react(code) {
    const A = Theater.aud(), { W, H } = Theater.size(), L = Theater.layout(); if (!L) return;
    const top = H - L.ch * 0.78 * 0.95, xs = () => A.length ? A[Math.floor(Math.random() * A.length)].px : W / 2;
    const laugh = (a) => Theater.act(a, a.k === 'n30_xiaosi' ? 'n30:laugh' : 'laugh', a.k === 'n30_xiaosi' ? 2.4 : 0);
    if (code === 'L' || code === 'E') { // 大笑：全場笑（每隻鬼自己個笑法），中間飄一句
      A.forEach((a, i) => setTimeout(() => laugh(a), i * 90));
      const side = Math.random() < 0.5 ? 0.3 : 0.7;
      Theater.float(W * side, top - 34, code === 'E' ? '好嘢！再嚟！' : ['哈哈哈哈！', '笑死我！', '哈哈哈！'][Math.floor(Math.random() * 3)], code === 'E' ? '#ffcf6a' : '#ffe9a8', code === 'E' ? 30 : 24, 1.4);
      if (code === 'E') { Theater.joss(30); Sound.play && Sound.play('gong'); } else Sound.play && Sound.play('praise');
    } else if (code === 'l') { // 細笑：兩隻笑
      A.slice().sort(() => Math.random() - 0.5).slice(0, 2).forEach(laugh);
    } else if (code === 'c') {
      A.forEach(a => Theater.act(a, 'wave'));
      Theater.float(W / 2, top - 30, '啪啪啪啪', '#ffe9a8', 22);
    } else if (code === '?') { // 冷場：得笑死鬼一個笑
      Theater.float(W / 2, top - 30, '……', '#c8c0d8', 26);
      const x = A.find(a => a.k === 'n30_xiaosi'); if (x) { laugh(x); Theater.float(x.px, top - 60, '（只有他在笑）', '#ffe9a8', 16, 1.8); }
    }
  }
  function play(id, opt) {
    const b = typeof id === 'string' ? SU_BITS.find(x => x.id === id) : id; if (!b) return false;
    opt = opt || {}; const s = st(); const first = s && !s.seen[b.id];
    Theater.play({ mode:'standup', tag:'棟篤笑', title:`${b.who}《${L(b.title)}》`, bg:'street', banner:'棟篤笑・今晚開咪',
      cast:[[b.who, b.k, { face:false }]], aud:audience(b), lines:beats(b), react }, (res) => {
      if (!s || res.skipped) { try { save(); } catch (e) {} if (opt.after) opt.after(); return; }
      s.seen[b.id] = 1; s.buff = Date.now() + 10 * 60 * 1000;
      let msg = '笑到肚痛：村民工作速度 +10%（10 分鐘）';
      if (first && !opt.replay) { const r = give({ coins:rwd(40) }); msg = `${r}<br>${msg}`; }
      Fx.toast(`棟篤笑：<b>${msg}</b>`); try { save(); UI.refresh(); } catch (e) {}
      if (opt.after) opt.after();
    });
    return true;
  }
  // ---------- 揀邊段 ----------
  function openPicker(onClose) {
    let el = document.getElementById('su-pick'); if (!el) { el = document.createElement('section'); el.id = 'su-pick'; (document.getElementById('app') || document.body).appendChild(el); }
    const s = st() || { seen:{} };
    const n = SU_BITS.filter(b => ok(b) && !s.seen[b.id]).length;
    el.innerHTML = `<div class="sp-h"><b>冥街夜市・棟篤笑</b><button class="btn sm" id="sp-x">離開</button></div>
      <p class="sp-sub">夜市盡頭有個小舞台，村裡的鬼輪流上台。看完會「笑到肚痛」：村民工作速度 +10%，持續 10 分鐘。第一次看另有冥幣。${n ? `<br>今晚有 <b>${n}</b> 段還沒看。` : ''}</p>
      <div class="sp-list">${SU_BITS.map(b => { const o = ok(b); return `<button class="sp-it ${o ? '' : 'off'}" data-id="${b.id}" ${o ? '' : 'disabled'}><canvas data-k="${o ? b.k : ''}" width="112" height="112"></canvas><span><b>${o ? `${b.who}《${L(b.title)}》` : '？？？'}</b><small>${o ? '改編自 ' + b.src : '解鎖：' + b.hint}</small></span>${o && !s.seen[b.id] ? '<em>新</em>' : ''}</button>`; }).join('')}</div>`;
    el.classList.add('on');
    el.querySelectorAll('canvas[data-k]').forEach(c => { const k = c.dataset.k; if (!k) return; try { const p = ART.portrait(k, 56, { tamed:true, untied:true }); c.width = p.width; c.height = p.height; c.getContext('2d').drawImage(p, 0, 0); } catch (e) {} });
    const close = () => { el.classList.remove('on'); el.innerHTML = ''; if (onClose) onClose(); };
    el.querySelector('#sp-x').onclick = () => { Sound.play && Sound.play('click'); close(); };
    el.querySelectorAll('.sp-it').forEach(btn => btn.onclick = () => { if (btn.disabled) return; Sound.play && Sound.play('gong'); el.classList.remove('on'); el.innerHTML = ''; play(btn.dataset.id, { after:() => openPicker(onClose) }); });
  }
  // ---------- 掛鈎（全部用包住現有函數，唔改原檔）----------
  function install() {
    if (typeof GhostStreet !== 'undefined') {
      const om = GhostStreet.mul; // 笑到碌地：做嘢快 10%
      GhostStreet.mul = function (kind) { const v = om.apply(this, arguments); return kind === 'work' && S && S.su && S.su.buff > Date.now() ? v * 1.1 : v; };
      const orp = GhostStreet.renderPanel; // 面板多個「棟篤笑」掣
      GhostStreet.renderPanel = function () {
        const r = orp.apply(this, arguments);
        try {
          if (this.view && this.view.k === 'idle') {
            const chips = document.querySelector('#gs-panel .gs-chips'); if (chips && !document.querySelector('#gs-panel .su-wide')) {
              const s = st() || { seen:{} }, n = SU_BITS.filter(b => ok(b) && !s.seen[b.id]).length;
              const b = document.createElement('button'); b.className = 'btn gold wide su-wide'; b.innerHTML = `棟篤笑・今晚開咪${n ? `<small>（${n} 段新節目）</small>` : ''}`;
              b.onclick = () => { Sound.play && Sound.play('click'); openPicker(); };
              chips.parentNode.insertBefore(b, chips.nextSibling);
            }
          }
        } catch (e) {}
        return r;
      };
    }
    if (typeof UI !== 'undefined' && UI.openStory) { // 劇情頁：重溫棟篤笑
      const os = UI.openStory;
      UI.openStory = function () {
        const r = os.apply(this, arguments);
        try {
          const body = document.querySelector('#sheet .sh-body'), hr = body && body.querySelector('hr');
          if (hr) {
            const s = st() || { seen:{} }, div = document.createElement('div');
            div.innerHTML = `<h4 class="stand-h">冥街夜市・棟篤笑</h4><p class="desc">在冥街夜市看過的節目，可以在這裡重溫。</p><div class="slist">${SU_BITS.map(b => `<button class="btn wide ${s.seen[b.id] ? '' : 'ghost'}" data-su="${b.id}" ${s.seen[b.id] ? '' : 'disabled'}>${s.seen[b.id] ? `<small>${b.who}</small>　${L(b.title)}` : '？？？（' + (ok(b) ? '到冥街夜市觀看' : b.hint) + '）'}</button>`).join('')}</div>`;
            hr.parentNode.insertBefore(div, hr);
            div.querySelectorAll('[data-su]').forEach(x => x.onclick = () => { UI.close(); setTimeout(() => play(x.dataset.su, { replay:true }), 60); });
          }
          const snd = document.getElementById('sndbtn'); // 設定：對白語言（中文／粵語），即時生效
          if (snd && typeof LANG !== 'undefined' && !document.getElementById('langbtn')) {
            const lb = document.createElement('button'); lb.className = 'btn wide'; lb.id = 'langbtn';
            const lab = () => { lb.textContent = '對白：' + (LANG.cur === 'zh' ? '中文（點擊切換為粵語）' : '粵語（點擊切換為中文）'); };
            lab(); lb.onclick = () => { LANG.toggle(); lab(); Sound.play && Sound.play('click'); };
            snd.parentNode.insertBefore(lb, snd.nextSibling);
          }
        } catch (e) {}
        return r;
      };
    }
    // 新一段解鎖：喺村裡提一句（安靜嘅時候）
    setInterval(() => {
      const s = st(); if (!s || typeof Skits === 'undefined' || !Skits.quiet()) return;
      const b = SU_BITS.find(x => ok(x) && !s.ann[x.id] && !s.seen[x.id]); if (!b) return;
      s.ann[b.id] = 1; Fx.toast(`冥街夜市・棟篤笑：<b>${b.who}《${L(b.title)}》</b>今晚登台。<br><small>出村 → 冥街夜市 → 棟篤笑</small>`); try { save(); } catch (e) {}
    }, 4000);
  }
  install();
  return { play, openPicker, list:SU_BITS, ok, st, audience };
})();
