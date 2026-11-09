// ===================== 新鬼 56 隻：數據（名冊、技能、敵方倍率、圖鑑、哪裡遇到）=====================
// 每隻一行 N30G(...)，刪一隻 = 刪這裡一行（再刪 n30_rigs.js 那一行、art/pack.py 的名字）。
// 技能只用戰鬥引擎本來就有的效果：hit 單體／aoe 全場、apply 浮空 air／倒地 down／擊退 push、follow 追擊、drain 吸血、sap 削能量、steal 偷冥幣；
//   hits = 多段（把同一招拆成幾下打，總倍率不變）。
// 階級 t：1 前期（打完第一章）、2 中期（打完第三章）、3 後期（打完第五章）。數值見下面 TIER，不會比同期的舊名鬼強。
// 出沒地 at：field 槐林荒村、road 南下古道、kampung 甘榜、banana 香蕉園外、night 冥街夜市（暗巷）、death 橫死路口（＋亂葬崗偶遇）
const N30_SITES = {
  field:  { name:'槐林荒村', bg:'field', gate:null, fod:['youhun', 'egui'], desc:'本地的老街坊：民間口中的「乜乜鬼」。' },
  road:   { name:'南下古道', bg:'road', gate:null, fod:['zombie', 'xiaogui'], desc:'從古書和傳說裡走出來的中國鬼怪。' },
  kampung:{ name:'甘榜夜路', bg:'kampung', gate:'2-3', fod:['xiaogui', 'shuigui'], desc:'馬來與爪哇的鄉野傳說。' },
  banana: { name:'香蕉園外', bg:'banana', gate:'4-3', fod:['shuigui', 'zhiren'], desc:'泰國、印度、菲律賓、愛爾蘭漂來的「番鬼」。' },
  night:  { name:'冥街夜市・暗巷', bg:'street', gate:null, fod:['zhiren', 'xiaogui'], desc:'日本妖怪：在夜市暗巷碰到，請佢食宵夜就跟你走。' },
  death:  { name:'橫死路口', bg:'road', gate:null, fod:['youhun', 'zhiren'], desc:'各種死法的意外鬼（本作原創）：每日路口輪流有兩隻，亂葬崗也偶然碰到。' },
};
// k = 底子倍率（模擬平衡後調的：tools 見 /tmp 的 sim.py，同期舊名鬼做基準）
const N30_TIER = { 1:{ gate:'1-3', p:6, req:7, en:[1.7, 1.25], k:1.0 }, 2:{ gate:'3-3', p:13, req:11, en:[2.3, 1.35], k:1.25 }, 3:{ gate:'5-3', p:19, req:14, en:[2.9, 1.5], k:1.15 } };
const N30_G = {};
function N30G(id, t, at, name, title, base, sk, trait, lore, say) {
  const k = 'n30_' + id;
  N30_G[k] = { id, t, at };
  GHOSTS[k] = { name, title, q:'名', base:base.map(v => Math.round(v * N30_TIER[t].k)), range:'melee', trait, lore, say, n30:true };
  SKILLS[k] = sk;
  ENEMY_T[k] = [N30_TIER[t].en[0], N30_TIER[t].en[1], name];
}
// ---------- 槐林荒村：民間口中的「乜乜鬼」 ----------
N30G('qionggui', 1, 'field', '窮鬼', '一身補丁', [30, 55, 55], { name:'空袋飛蛾', kind:'aoe', mult:0.7, sap:20, desc:'翻出空口袋，飛蛾撲向全場，削掉敵人能量。' }, '去冥街買嘢永遠要講價。', '民間年初有「送窮」的習俗，韓愈寫過《送窮文》，要送走的就是窮鬼。', '借住先，有錢即刻還……應該。');
N30G('danxiao', 1, 'field', '膽小鬼', '自己是鬼都驚鬼', [35, 45, 60], { name:'閉眼亂揮', kind:'hit', mult:1.3, hits:3, apply:'push', desc:'閉著眼亂揮三下，誤打誤撞嚇退敵人。' }, '晚上唔肯一個人去廁所。', '「膽小鬼」本來是罵人無膽的俗語；本作把這句說話變成一隻真的鬼。', '你、你唔好嚇我呀……');
N30G('maoshi', 1, 'field', '冒失鬼', '永遠在跌倒', [55, 30, 60], { name:'跌倒頭槌', kind:'hit', mult:1.5, apply:'down', desc:'絆倒撲過去一頭撞中，敵人腳軟。' }, '派佢搬嘢，十件爛三件。', '「冒失鬼」是形容做事魯莽的人的俗語；本作把它變成一隻真的鬼。', '唔好意思！我唔係故意㗎！');
N30G('yangui', 1, 'field', '煙鬼', '咳不停', [35, 60, 50], { name:'煙圈套頭', kind:'hit', mult:1.4, sap:25, desc:'吐出大煙圈套住敵人的頭，嗆到削掉能量。' }, '叫佢唔好喺倉庫食煙，佢話「最後一口」。', '「煙鬼」是對煙癮很大的人的俗稱；本作把這個說法變成一隻真的鬼。', '咳咳……冇事，食多口就好。');
N30G('jiugui', 1, 'field', '酒鬼', '臉紅紅', [60, 25, 60], { name:'醉漢撲撞', kind:'hit', mult:1.6, apply:'push', desc:'醉醺醺整個撲過去，撞開敵人。' }, '酒埕抱得比命還緊（雖然命已經冇咗）。', '「酒鬼」是對嗜酒的人的俗稱；本作把這個說法變成一隻真的鬼。', '嗝～飲多杯先講啦！');
N30G('dugui', 2, 'field', '賭鬼', '輸到只剩短褲', [55, 65, 80], { name:'梭哈', kind:'hit', mult:1.6, hits:3, steal:25, desc:'骰子加飛牌連打三下，順手贏走冥幣。' }, '派佢管數？你夠膽就試吓。', '「賭鬼」是對嗜賭的人的俗稱；本作把這個說法變成一隻真的鬼。', '今鋪一定翻本！');
N30G('guhangui', 2, 'field', '孤寒鬼', '一毛不拔', [60, 75, 65], { name:'算盤摑', kind:'hit', mult:1.5, steal:40, desc:'算盤一摑，算珠彈飛，還要你賠錢。' }, '一個銅錢都要咬一啖驗真假。', '粵語「孤寒」即吝嗇；本作把「孤寒鬼」這句罵人說話變成一隻真的鬼。', '計清楚先，一毫都唔可以少。');
N30G('taozhai', 2, 'field', '討債鬼', '拿欠單上門追數', [70, 40, 65], { name:'紅油潑門', kind:'hit', mult:1.7, apply:'down', sap:20, desc:'紅油一潑，敵人滑倒、氣到洩氣。' }, '欠單上面每個名都係真嘅。', '民間說法：前世被欠債的人投胎來討債，多用來講敗家的子女。', '還錢！今日唔還，聽日再嚟！');
N30G('diaosi', 2, 'field', '吊死鬼', '長舌垂到胸口', [50, 60, 80], { name:'長舌鞭', kind:'hit', mult:1.7, apply:'air', desc:'舌頭從頭頂抽下來，把敵人抽到嚇彈起。' }, '條脷長過我條命，講嘢成日咬親。', '民間傳說上吊而死的人化成的鬼，形象是吐出長舌、頸上掛著繩。', '條繩……唔好掂佢。');
// ---------- 南下古道：古書與傳說裡的中國鬼怪 ----------
N30G('wutou', 1, 'road', '無頭鬼', '手捧自己的頭', [60, 35, 55], { name:'人頭保齡球', kind:'aoe', mult:0.75, apply:'down', desc:'自己個頭當保齡球滾過去，全場腳軟。' }, '睇路靠手上個頭，所以成日撞牆。', '民間傳說被斬首而死的鬼，常常捧著自己的頭出現。', '你見唔見到我個頭？喺我手度。');
N30G('changgui', 1, 'road', '倀鬼', '為虎作倀', [40, 50, 65], { name:'喚虎撲', kind:'hit', mult:1.5, follow:'down', desc:'吹口哨，小老虎撲上去；對腳軟目標追擊。' }, '隻老虎唔肯打工，佢自己頂上。', '傳說被老虎吃掉的人化成倀鬼，反過來替老虎引路害人，就是成語「為虎作倀」。', '大佬，嗰邊有肉！');
N30G('guixinniang', 2, 'road', '鬼新娘', '冥婚的紅衣新娘', [40, 85, 70], { name:'拋繡球', kind:'aoe', mult:0.9, apply:'air', desc:'繡球拋過去，全場敵人嚇彈起。' }, '每晚都喺村口等，唔知等緊邊個。', '民間冥婚習俗裡的亡故新娘，穿紅嫁衣、蓋紅蓋頭。', '良辰吉時，你都嚟埋啦。');
N30G('baigujing', 2, 'road', '白骨精', '白骨化成的妖婦', [50, 85, 75], { name:'飛吻骷髏', kind:'hit', mult:1.6, drain:0.35, desc:'送出飛吻變骷髏咬一口，吸回血量。' }, '每日照鏡三個鐘。', '《西遊記》裡由白骨化成的妖精，三次變化騙唐僧，被孫悟空三打。', '人哋只係想食少少唐僧肉啫。');
N30G('shanxiao', 2, 'road', '山魈', '獨腳山精', [80, 30, 80], { name:'單腳長臂掃', kind:'hit', mult:1.6, hits:2, follow:'air', desc:'單腳跳過去、長臂掃兩下；對嚇彈起目標追擊。' }, '最驚過年：一聽到爆竹就躲上樹。', '古籍裡的山中精怪，傳說只有一隻腳；《荊楚歲時記》說新年燒爆竹就是為了嚇走它。', '唔好燒爆竹呀！');
N30G('yecha', 3, 'road', '夜叉', '青面獠牙', [100, 25, 95], { name:'鋼叉突刺', kind:'hit', mult:1.8, apply:'push', follow:'down', desc:'一步踏前直刺，嚇退敵人；對腳軟目標追擊。' }, '把鋼叉每晚都要擦三次。', '源自佛教的鬼神（梵語 yakṣa），民間形象青面獠牙，手持鋼叉。', '邊個夠膽過我條叉？');
N30G('hanba', 3, 'road', '旱魃', '所到之處大旱', [70, 60, 95], { name:'熱浪', kind:'aoe', mult:1.1, sap:15, desc:'推出一波波熱浪烤全場，敵人熱到洩氣。' }, '佢一嚟，糯米田就乾晒。', '古代傳說中引起旱災的怪物，《詩經》有「旱魃為虐」；後世說是屍變而成。', '好熱……有冇凍檸茶？');
// ---------- 甘榜夜路：馬來與爪哇的鄉野傳說 ----------
N30G('pelesit', 1, 'kampung', 'Pelesit', '蟋蟀形的使魔', [30, 45, 70], { name:'跳咬', kind:'hit', mult:1.5, follow:'air', desc:'彈起一大跳撲上去咬；對嚇彈起目標追擊。' }, '叫起上嚟成晚唧唧聲，冇鬼瞓得著。', '馬來傳說中蟋蟀模樣的使魔，常和 Polong 一起被主人派出去。', '唧唧！唧唧唧！');
N30G('polong', 1, 'kampung', 'Polong', '養在瓶子裡的鬼', [35, 60, 55], { name:'出瓶竄咬', kind:'hit', mult:1.4, drain:0.3, desc:'從瓶口竄出去咬一口，吸血回來。' }, '要人捧住個瓶先肯郁。', '馬來傳說養在瓶子裡的使魔，主人用自己手指的血餵養，再派它去害人。', '捧穩個樽呀，唔好打爛！');
N30G('jenglot', 1, 'kampung', 'Jenglot', '長髮長指甲的小乾屍', [40, 50, 60], { name:'轉身甩髮', kind:'aoe', mult:0.8, apply:'push', desc:'原地一轉，長髮掃開全場。' }, '頭髮比個身長三倍，洗頭要洗成晚。', '印尼和馬來世界傳說中的小乾屍，長髮長指甲，據說要用血供養。', '嘶……唔好掂我啲頭髮。');
N30G('hantugalah', 2, 'kampung', 'Hantu Galah', '高得像竹竿', [55, 55, 75], { name:'高處彈額頭', kind:'hit', mult:1.6, apply:'down', desc:'一步跨過去，從高處彎腰彈額頭，彈到腳軟。' }, '倉庫最高嗰格佢一伸手就攞到。', '馬來傳說中高瘦得像竹竿的鬼，galah 在馬來語就是長竿。', '你望咩呀？望上啲。');
N30G('jerangkung', 2, 'kampung', 'Hantu Jerangkung', '骷髏鬼', [65, 55, 80], { name:'骨頭迴旋鏢', kind:'hit', mult:1.6, hits:2, desc:'拆下前臂丟出去，打中再飛回來，一共兩下。' }, '行路成日跌甩骨，要自己執返。', '馬來傳說中的骷髏鬼，jerangkung 在馬來語就是骷髏。', '喀喀……等我裝返隻手先。');
N30G('bunian', 2, 'kampung', 'Orang Bunian', '隱身森林的精靈族', [45, 85, 75], { name:'隱身繞後', kind:'hit', mult:1.7, sap:30, desc:'消失後在敵人背後出現，一拍削掉大量能量。' }, '派佢去伐木，砍完棵樹都冇人見過佢。', '馬來傳說中住在森林裡、凡人看不見的隱形族人。', '你睇唔到我，但我一直喺度。');
N30G('hanturaya', 3, 'kampung', 'Hantu Raya', '主人的大黑影', [94, 40, 76], { name:'黑影壓頂', kind:'aoe', mult:1.1, apply:'down', desc:'黑影漲高罩落全場，敵人腳軟。' }, '佢會扮成主人去打工，所以打卡記錄好亂。', '馬來傳說中由主人供養的強大使魔，能化成主人的模樣做事，主人死前要把它傳給別人。', '主人叫我做咩，我就做咩。');
N30G('genderuwo', 3, 'kampung', 'Genderuwo', '滿身毛的大猩猩鬼', [102, 25, 82], { name:'跳起搥地', kind:'hit', mult:1.9, apply:'air', desc:'跳起雙拳搥地，把敵人震到嚇彈起。' }, '鍾意捉弄人，成日收埋人隻拖鞋。', '爪哇傳說中渾身是毛、像大猩猩的鬼怪，喜歡捉弄人。', '吼！邊個收埋咗我隻蕉？');
// ---------- 香蕉園外：泰國、印度、菲律賓、愛爾蘭 ----------
N30G('phiam', 1, 'banana', 'Phi Am', '坐在胸口的鬼', [70, 30, 50], { name:'鬼壓床', kind:'hit', mult:1.4, apply:'down', sap:15, desc:'一屁股坐下去，敵人腳軟動彈不得。' }, '派佢去顧倉，佢坐喺度瞓著咗。', '泰國傳說坐在睡著的人胸口的鬼，也就是「鬼壓床」。', '借個胸口坐吓啫，唔使咁驚。');
N30G('churel', 2, 'banana', 'Churel', '雙腳是反的', [60, 60, 85], { name:'反腳倒衝', kind:'hit', mult:1.6, apply:'push', follow:'push', desc:'倒著衝過去一頂，嚇退敵人；對被嚇退的目標追擊。' }, '佢行去邊，腳印就指住反方向。', '印度和南亞傳說中，難產或分娩時死去的女人化成的鬼，雙腳是反的。', '跟住我啲腳印行？你會行錯路喎。');
N30G('tikbalang', 2, 'banana', 'Tikbalang', '馬頭長腿怪', [70, 35, 72], { name:'轉身馬後踢', kind:'hit', mult:1.7, apply:'air', desc:'轉身一記後踢，把敵人踢上半空。' }, '帶佢出門一定蕩失路。', '菲律賓傳說中馬頭長腿的山林精怪，會讓旅人迷路。', '條路？我帶你行……行到天光。');
N30G('maenak', 2, 'banana', 'Mae Nak', '泰國的鬼妻', [55, 75, 80], { name:'長臂抓', kind:'hit', mult:1.5, follow:'down', drain:0.25, desc:'手臂一直伸長抓住敵人；對腳軟目標追擊，吸回血量。' }, '每晚都喺門口等老公收工。', '泰國最有名的鬼故事：Mae Nak 難產死後仍在家等丈夫 Mak，曾把手臂伸長去撿掉到屋下的檸檬。', 'Mak 收工未呀？');
N30G('aswang', 3, 'banana', 'Aswang', '菲律賓的變形食屍鬼', [65, 60, 95], { name:'長舌吸血', kind:'hit', mult:1.8, drain:0.45, desc:'舌頭像吸管一樣插住，吸走大量血量。' }, '白天好正常，一入夜就變樣。', '菲律賓傳說中白天像普通人、晚上變形害人的鬼怪，用細長的舌頭吸食。', '日頭我係普通人嚟㗎。');
N30G('vetala', 3, 'banana', 'Vetala', '倒掛的屍鬼', [70, 80, 85], { name:'倒吊驚嚇', kind:'hit', mult:1.7, apply:'down', sap:30, desc:'倒吊從天而降臉貼臉大叫，嚇到敵人腳軟、能量清走一截。' }, '鍾意出謎題，答錯就唔放你走。', '印度傳說附在屍體上的鬼，倒掛在樹上；故事集《僵屍鬼故事二十五則》裡它不停給國王出謎題。', '估吓先：乜嘢越洗越污糟？');
N30G('banshee', 3, 'banana', 'Banshee', '愛爾蘭的報喪女妖', [55, 90, 90], { name:'報喪尖叫', kind:'aoe', mult:1.0, apply:'push', follow:'down', desc:'一聲尖叫震開全場；對腳軟目標追擊。' }, '佢一開口，成條村都要掩住耳。', '愛爾蘭傳說中的報喪女妖，她一哭嚎，家裡就會有人死。', '啊——！……唔好意思，習慣咗。');
// ---------- 冥街夜市・暗巷：日本妖怪 ----------
N30G('kasaobake', 1, 'night', '唐傘妖', '一隻眼一隻腳的舊雨傘', [35, 55, 55], { name:'跳過去舔', kind:'hit', mult:1.4, apply:'push', desc:'單腳跳過去，長舌一舔，敵人嚇到退開。' }, '落雨天特別興奮。', '日本「付喪神」的一種：舊雨傘用久了化成的妖怪，一隻眼、一隻腳、伸長舌頭。', '落雨喇！帶埋我出街啦！');
N30G('chochin', 1, 'night', '提燈妖', '破燈籠張開大嘴', [40, 60, 50], { name:'噴火咬', kind:'hit', mult:1.4, hits:2, desc:'張開大嘴咬兩下，噴出一團火。' }, '夜市冇電，全靠佢照住。', '日本「付喪神」的一種：舊燈籠裂開變成大嘴、伸出舌頭的妖怪。', '要唔要我照你返屋企？');
N30G('kappa', 1, 'night', '河童', '頭頂盤子', [55, 40, 55], { name:'鞠躬潑水', kind:'hit', mult:1.4, apply:'down', desc:'禮貌地鞠躬，頭頂的水潑過去，敵人滑倒。' }, '收工要食三條青瓜。', '日本傳說住在河川的妖怪，頭頂的碟子乾了就會沒力，最愛吃青瓜。', '有冇青瓜呀？');
N30G('nopperabo', 2, 'night', '無臉鬼', '臉上什麼都沒有', [65, 65, 75], { name:'公事包上勾', kind:'hit', mult:1.6, apply:'air', desc:'公事包一記上勾，敵人飛上半空。' }, '朝九晚五，從來冇遲到過（除咗今日）。', '日本傳說中臉上什麼都沒有的妖怪（のっぺらぼう），專門嚇夜歸人。', '我個樣係咪好普通？');
N30G('rokurokubi', 2, 'night', '轆轤首', '脖子可以伸很長', [60, 70, 80], { name:'伸頸頭槌', kind:'hit', mult:1.6, follow:'air', desc:'脖子伸長一頭撞過去；對嚇彈起目標追擊。' }, '晚上瞓覺個頭會周圍去。', '日本傳說晚上脖子會伸得很長的妖怪，外表是普通女人。', '唔好意思，我條頸瞓覺唔聽話。');
N30G('kuchisake', 2, 'night', '裂口女', '戴口罩的女人', [45, 70, 80], { name:'剪刀咔嚓', kind:'hit', mult:1.7, hits:2, desc:'「我靚唔靚？」剪刀咔嚓兩下。' }, '最怕人答「麻麻地」。', '1979 年在日本流行的都市傳說：戴口罩的女人問路人「我漂亮嗎？」', '我靚唔靚？');
N30G('yukionna', 3, 'night', '雪女', '吐出冰霜的白衣女', [55, 95, 85], { name:'吐冰霜', kind:'aoe', mult:1.0, apply:'down', sap:20, desc:'呼出冰霧凍住全場，敵人腳軟、能量凍結一截。' }, '佢一入倉庫，啲壽包即刻變急凍。', '日本雪國傳說中的白衣女妖，暴風雪夜出現，呼出的氣能把人凍死。', '凍唔凍呀？我覺得啱啱好。');
N30G('hannya', 3, 'night', '般若', '嫉妒化成的鬼女', [70, 55, 100], { name:'妒火暴衝', kind:'hit', mult:1.9, hits:2, apply:'push', desc:'帶著殘影暴衝過去，雙爪交叉抓兩下並嚇退。' }, '見到人哋有新衫就會冒煙。', '日本能劇的鬼女面具，表現女人因嫉妒而化成的鬼，頭生雙角。', '點解佢有我冇？！');
N30G('gashadokuro', 3, 'night', '餓者髑髏', '巨大骷髏', [102, 25, 80], { name:'巨手一拍', kind:'aoe', mult:1.1, follow:'air', desc:'巨大骨手拍落全場；對嚇彈起目標追擊。' }, '一餐要食晒成個包子鋪。', '日本妖怪，由許多無人安葬的骸骨聚成的巨大骷髏。', '餓……好餓……');
// ---------- 橫死路口：各種死法的意外鬼（本作原創，搞笑無血腥）----------
N30G('zipai', 1, 'death', '自拍跌死鬼', '踩到香蕉皮', [40, 55, 55], { name:'閃光滑鏟', kind:'hit', mult:1.4, apply:'down', desc:'閃光燈一閃，再踩香蕉皮滑過去，鏟到敵人腳軟。' }, '死咗都要打卡。', '本作原創：為咗影一張靚相，退後一步踩中香蕉皮。到今日都未刪嗰張相。', '等等，再影多張！');
N30G('xiaosi', 1, 'death', '笑死鬼', '笑到停不下來', [35, 65, 50], { name:'傳染的笑', kind:'aoe', mult:0.7, sap:30, desc:'爆笑傳染全場，敵人笑到洩氣。' }, '佢一笑，成條村都跟住笑。', '本作原創：睇棟篤笑笑到斷氣，笑容從此卸唔落嚟。', '哈哈哈……唔好再講喇！');
N30G('yesi', 1, 'death', '噎死鬼', '喉嚨卡著湯圓', [55, 35, 55], { name:'湯圓子彈', kind:'hit', mult:1.5, apply:'push', desc:'把卡著的湯圓咳出去，正中額頭嚇退。' }, '冬至最危險。', '本作原創：冬至一啖食晒三粒湯圓，從此對湯圓又愛又恨。', '唔……（指住喉嚨）');
N30G('shidu', 1, 'death', '食物中毒鬼', '臉發青', [45, 45, 55], { name:'綠色臭屁', kind:'aoe', mult:0.75, apply:'push', desc:'轉身一團綠雲，全場燻開。' }, '永遠攬住卷廁紙。', '本作原創：食咗隔夜三日嘅外賣，最後一程係喺廁所行完。', '廁所喺邊呀！');
N30G('daji', 1, 'death', '打機猝死鬼', '網吧通宵', [35, 60, 60], { name:'手掣連段', kind:'hit', mult:1.4, hits:4, desc:'狂按手掣，按鍵連打四下。' }, '派佢打工？佢會問有冇 Wi-Fi。', '本作原創：網吧通宵打機打到最後一關，連 Game Over 都未見到。', 'GG，再嚟過！');
N30G('xiasi', 1, 'death', '嚇死鬼', '頭髮全豎起', [40, 50, 60], { name:'突然嚇你', kind:'aoe', mult:0.75, apply:'push', sap:10, desc:'突然暴漲大叫，全場敵人嚇到彈開。' }, '佢自己都成日畀自己嚇親。', '本作原創：睇鬼片睇到一半，被貓跳上膊頭嚇死。', '哇！！……咦，原來係你。');
N30G('chehuo', 2, 'death', '車禍鬼', '安全帽裂開', [70, 40, 75], { name:'催油門撞', kind:'hit', mult:1.7, apply:'push', desc:'催油門衝過去，碰一聲撞開敵人。' }, '過馬路一定望三次（死後先學識）。', '本作原創：揸電單車趕外賣，綠燈都未轉。安全帽係保住咗嘅。', '叭叭！借借！');
N30G('yezi', 2, 'death', '椰子砸死鬼', '頭頂一個大包', [65, 55, 65], { name:'小心頭頂', kind:'hit', mult:1.6, apply:'down', desc:'抬頭一指，天上掉個椰子砸中，敵人腳軟。' }, '永遠唔肯企喺椰樹下面。', '本作原創：喺沙灘椰樹下面瞓午覺，瞓到永遠。', '小心頭頂呀！');
N30G('liulian', 2, 'death', '榴槤砸死鬼', '滿臉刺孔', [75, 40, 70], { name:'丟榴槤', kind:'hit', mult:1.7, follow:'down', desc:'從背後掏出榴槤甩過去；對腳軟目標追擊。' }, '身上永遠有陣榴槤味。', '本作原創：榴槤季喺樹下等跌落嚟嗰個，結果等到。', '貓山王嚟㗎，好香㗎！');
N30G('zhongshu', 2, 'death', '中暑鬼', '曬到通紅', [55, 70, 60], { name:'烈日曬', kind:'aoe', mult:0.9, sap:20, desc:'一道烈日照落全場，敵人曬到洩氣。' }, '手上支雪條永遠食唔切。', '本作原創：大熱天時排隊買限量波鞋，排到最後一個。', '熱到溶呀……');
N30G('chengsi', 2, 'death', '撐死鬼', '吃自助餐撐爆', [90, 30, 60], { name:'大肚腩一頂', kind:'hit', mult:1.6, apply:'push', drain:0.2, desc:'挺著大肚撞開敵人，順便吃回一點血。' }, '包子鋪佢一個人食咗一半。', '本作原創：自助餐「食夠本」食到最後一碟。', '仲有甜品未食！');
N30G('shedu', 2, 'death', '蛇咬鬼', '一條蛇還咬著他', [60, 45, 75], { name:'蛇撲出去', kind:'hit', mult:1.6, drain:0.3, desc:'屁股上的蛇撲出去咬一口，吸回血量。' }, '條蛇同佢已經做咗朋友。', '本作原創：去行山想抄近路，坐低休息坐中咗條蛇。', '哎喲！佢又咬我！');
N30G('diansi', 3, 'death', '電死鬼', '觸電爆炸頭', [55, 75, 90], { name:'插頭放電', kind:'aoe', mult:1.05, apply:'down', desc:'插頭放電劈過全場，敵人電到腳軟。' }, '一行近插蘇就會郁身郁勢。', '本作原創：濕手去插插蘇。頭髮從此再冇跌落嚟過。', '插蘇喺邊？');
N30G('dongsi', 3, 'death', '凍死鬼', '全身結冰', [80, 60, 75], { name:'噴嚏冰柱', kind:'hit', mult:1.8, apply:'down', follow:'down', desc:'一個噴嚏射出冰柱，凍住敵人腳軟；對腳軟目標追擊。' }, '永遠披住張毯。', '本作原創：去日本睇雪，著住拖鞋短褲。', '哈……哈啾！');
N30G('leipi', 3, 'death', '雷劈鬼', '全身焦黑冒煙', [60, 85, 70], { name:'舉傘招雷', kind:'aoe', mult:1.1, apply:'air', desc:'舉起破傘招雷，劈中全場嚇彈起。' }, '行雷嗰陣千祈唔好企佢隔籬。', '本作原創：打風落雨喺山頂舉起支鐵骨遮影相。', '又嚟！');
N30G('xiangcai', 3, 'death', '大象踩扁鬼', '扁得像一張紙', [60, 85, 95], { name:'紙片刀', kind:'hit', mult:1.8, hits:2, follow:'air', desc:'扁成紙片橫削兩下；對嚇彈起目標追擊。' }, '可以喺門縫下面入屋。', '本作原創：去泰國騎大象自拍，大象想同佢合照。', '我依家好薄，好難捉㗎！');

// ======================= 遇到與收服 =======================
const N30W = {
  ids() { return Object.keys(N30_G); },
  st() { if (!S.n30) S.n30 = {}; return S.n30; },
  owned(k) { return S.ghosts.some(g => g.k === k); },
  open(k) { const g = N30_G[k], site = N30_SITES[g.at]; return !!S.cleared[N30_TIER[g.t].gate] && (!site.gate || !!S.cleared[site.gate]); },
  where(k) { const g = N30_G[k], site = N30_SITES[g.at], T = N30_TIER[g.t]; const tag = (s) => s ? `打完 ${s}` : ''; const need = [tag(T.gate), tag(site.gate)].filter(Boolean).join('、'); return `${site.name}　${['', '前期', '中期', '後期'][g.t]}${need ? '（' + need + '後）' : ''}`; },
  // 今日橫死路口那兩隻（每日換）
  roadToday() {
    const s = this.st(), day = Math.floor(Date.now() / 864e5);
    const pool = this.ids().filter(k => N30_G[k].at === 'death' && this.open(k));
    if (!s.road || s.road.day !== day || s.road.list.some(k => !pool.includes(k))) {
      const un = pool.filter(k => !this.owned(k)), src = un.length >= 2 ? un : pool, list = [];
      let seed = day * 9301 + 49297; const rnd = () => (seed = (seed * 9301 + 49297) % 233280) / 233280;
      const a = src.slice(); while (list.length < 2 && a.length) list.push(a.splice(Math.floor(rnd() * a.length), 1)[0]);
      s.road = { day, list };
    }
    return s.road.list;
  },
  // 出征選單裡的「野鬼出沒」
  selectHtml() {
    if (!S.cleared['1-3']) return `<div class="chap"><div class="ch-h">野鬼出沒</div><p class="desc">打完第一章，各處開始有野鬼出沒，打贏就可以收服。</p></div>`;
    let h = `<div class="chap"><div class="ch-h">野鬼出沒・打贏就收服</div><p class="desc">每隻野鬼第一次打贏就會跟你返村。已收服的可以再戰，賺冥幣。日本妖怪喺冥街夜市暗巷出沒。</p>`;
    for (const sid of ['field', 'road', 'kampung', 'banana', 'death']) {
      const site = N30_SITES[sid];
      let ks = this.ids().filter(k => N30_G[k].at === sid);
      if (sid === 'death') ks = this.roadToday();
      const open = ks.filter(k => this.open(k)), lockedN = ks.length - open.length;
      h += `<div class="stg n30-site"><span class="st"><b>${site.name}</b><small>${site.desc}${sid !== 'death' && lockedN ? `　另有 ${lockedN} 隻未出沒` : ''}</small></span></div>`;
      for (const k of open) {
        const g = N30_G[k], T = N30_TIER[g.t], own = this.owned(k), lvOk = S.lv >= T.req;
        h += `<div class="stg boss"><span class="sn">${['', '前', '中', '後'][g.t]}</span><span class="st"><b>${GHOSTS[k].name}</b><small>${own ? '已收服　' : ''}需主公 Lv${T.req}　${GHOSTS[k].title}</small></span><button class="btn sm ${own ? '' : 'gold'}" data-n30="${k}" ${lvOk ? '' : 'disabled'}>${own ? '再戰' : lvOk ? '收服' : 'Lv' + T.req}</button>${own ? '<i class="ok">✓</i>' : ''}</div>`;
      }
    }
    return h + '</div>';
  },
  bindSelect(root) { root.querySelectorAll('[data-n30]').forEach(b => b.onclick = () => this.fight(b.dataset.n30)); },
  stageOf(k) {
    const g = N30_G[k], T = N30_TIER[g.t], site = N30_SITES[g.at];
    return { name:GHOSTS[k].name, req:T.req, p:T.p, en:[site.fod[0], k, site.fod[1]], boss:k, wild:k };
  },
  fight(k) {
    if (!S.team.some(Boolean)) { Fx.toast('至少要派一位鬼怪出陣'); return; }
    UI.close();
    const g = N30_G[k], first = !this.owned(k);
    const go = () => Battle.start(-1, g.t - 1, { stage:this.stageOf(k), bg:N30_SITES[g.at].bg, sid:'w-' + g.id });
    if (first) Story.queue({ style:'narr', lines:[['旁白', `${N30_SITES[g.at].name}：${GHOSTS[k].name}出沒！`], [GHOSTS[k].name, GHOSTS[k].say]] }, go); else go();
  },
  // 戰鬥贏了：收服
  onWin(st) {
    if (!st || !st.wild || this.owned(st.wild)) return false;
    const k = st.wild; Story.queue({ style:'narr', lines:[[GHOSTS[k].name, GHOSTS[k].say], ['旁白', `${GHOSTS[k].name}決定跟你返落魄村。`]] }, () => joinGhost(k));
    return true;
  },
  // 冥街夜市暗巷：日本妖怪（請佢食宵夜就跟你走）
  alleyEvent() {
    const pool = this.ids().filter(k => N30_G[k].at === 'night' && this.open(k) && !this.owned(k));
    if (!pool.length || Math.random() > 0.45) return null;
    const k = pool[Math.floor(Math.random() * pool.length)], g = N30_G[k], cost = [0, 120, 300, 600][g.t];
    return { id:'n30_' + g.id, n30:k, text:`巷口有一隻${GHOSTS[k].name}（${GHOSTS[k].title}）盯住你：「${GHOSTS[k].say}」`,
      a:{ label:'請佢食宵夜', cost, out:`${GHOSTS[k].name}食飽之後話：「你呢個人都幾好人。」佢跟你返落魄村。`, join:k },
      b:{ label:'點個頭就走', out:`${GHOSTS[k].name}望住你行遠咗。下次再嚟，可能仲見到佢。`, give:{ exp:15 } } };
  },
  // 亂葬崗：解開一晚之後，偶然有隻意外鬼（本作原創）跟住你
  graveVisit() {
    const pool = this.ids().filter(k => N30_G[k].at === 'death' && this.open(k) && !this.owned(k));
    if (!pool.length || Math.random() > 0.15) return null;
    const k = pool[Math.floor(Math.random() * pool.length)];
    return { k, text:`墳後面行出一隻${GHOSTS[k].name}：「${GHOSTS[k].say}」佢話想跟你返村。` };
  },
  // 圖鑑
  openCodex() {
    const ids = this.ids(), got = ids.filter(k => this.owned(k)).length;
    let h = `<p class="desc">新鬼圖鑑：已收服 ${got}/${ids.length}。未收服的會寫低喺邊度出沒。</p>`;
    for (const sid of ['field', 'road', 'kampung', 'banana', 'night', 'death']) {
      h += `<div class="ch-h">${N30_SITES[sid].name}</div><div class="glist">`;
      for (const k of ids.filter(k => N30_G[k].at === sid)) {
        const own = this.owned(k), d = GHOSTS[k];
        h += `<div class="gi ${own ? '' : 'dis'}"><canvas data-por="${k}" style="${own ? '' : 'filter:brightness(.15)'}"></canvas><div><b>${own ? d.name : d.name + '（未收服）'}</b> <small>${d.title}</small><small class="tr">${d.lore}</small><small>${own ? `【${SKILLS[k].name}】${SKILLS[k].desc}` : '出沒：' + this.where(k)}</small></div></div>`;
      }
      h += '</div>';
    }
    h += `<button class="btn wide" id="cxback">返回名冊</button>`;
    UI.sheet('新鬼圖鑑', h); paintPortraits($('#sheet'));
    $('#cxback').onclick = () => UI.openRoster();
  },
};
