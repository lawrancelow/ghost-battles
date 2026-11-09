// ===================== 回陽間・夜班嚇人（即時版） =====================
// 一晚 00:00→06:00 壓縮成三分鐘。人會走動；嚇人要看位置、看時機。
// 核心：先鋪墊（小嚇讓他起疑），再抖包袱（大招）。一上來就出大招，他只會說「我太累了」。
const SCARE_TYPES = { breath:'氣', light:'燈', cold:'冷', sound:'聲', paper:'紙', phone:'訊息', face:'臉', shadow:'影' };
const NIGHT_SEC = 180;
const SEE_DIST = 0.7; // 視線距離（同一間房先計）：全景之後一間房大過舊辦公室，望得遠啲（舊 0.5）
// 結算獎勵倍率（只有這一個常數）：六個人＋恐懼手感改版後，同樣的表現分數約是舊（四個人）的 3.3 倍 → ×0.3 乘回舊的水平。改回 1 = 舊的發法
const SCARE_PAY = 0.3;
// 恐懼手感（玩家回饋：太難嚇、冷靜太快）。括號 = 舊值
const FEAR = {
  gain:1.4, weakSmall:1.6,        // 每一下小動靜的恐懼 ×1.4（×1）；戳中弱點的小動靜 ×1.6（×2）→ 合起來 ×2.24，兩下就「！」；大招不乘，爆點另外算
  spread:0.15,                    // 一招同時嚇到幾個人：每多一個人，每人 ÷(1+0.15)（全層樓的燈、冷氣不會比盯住一個人更好用）（沒有）
  decay:0.3, nearCalm:0.5,        // 冷靜：每秒 calm×0.3 ＋ 旁邊每人 0.5（calm×1 ＋ 每人 1.6）→ 阿Ken 每秒 0.66（2.2）
  shaken:24, shakenDecay:0.4, shakenFloor:32, // 嚇到「！」之後心有餘悸 24 秒：冷靜再慢六成、恐懼不會跌穿 32（還是「？」）（沒有）
  shakenMul:1.3, smallCap:58, plainCap:45, shakenCap:75, // 心有餘悸時再嚇：恐懼 ×1.3。小動靜上限：戳中弱點 58（剛過「！」）、普通 45（「？」）、心有餘悸 75（舊：一律 60）
  habMul:0.82, habMin:0.45, habForget:5,      // 同一招重複：每次 ×0.82、最低 ×0.45、每 5 秒忘掉一次（×0.75 一路跌、8 秒）
  combo:6, comboStep:0.15, comboMax:0.6,      // 連擊：6 秒內同一個人再中一下 +15%，最多 +60%（沒有）
  burstMul:2.4, burstBonus:30, comboPts:20, multiPts:50,    // 鋪墊好再出大招＝爆點：×2.4、額外 +30 分（×2.1、+30）；連擊 n 層（最多 4）接爆點再 +40×n 分；全場大招一次爆兩個以上，每多一個 +50（沒有）
  guardCalm:15,                               // 保安壯膽 −15（−22）
  // 細緻玩法：揀一個人嚇，其他人睇唔到鬼，只睇到佢發神經（舊：旁邊有人就一律打折）
  mockMul:0.12, mockFear:4, mockPts:6, noBelieve:25, // 每被人笑一次「冇人信」+1（最多 4）：之後嚇佢 +12%／層；被笑當下自己再驚 +4、+6 分；爆點時「無人信佢」+25×層
  alone:1.2,                                  // 佢身邊冇人（影印機、茶水間落單）：×1.2
  seenMul:0.5, seenPen:25, witFear:15,        // 怪事被旁人望到＝穿崩：效果減半、−25 分、冇人信清零、目擊者自己驚 +15、保安行過嚟
  groupMul:0.8, uneasy:20, uneasyMul:1.25,    // 全場燈／冷氣：×0.8；之後 20 秒大家心緒不寧，單嚇佢 ×1.25
  aoeMul:0.6,                                 // 全場大招：人人都見到 → ×0.6、冇爆點分、冇人信清零（亂槍打鳥唔抵）
};
// 怕／唔怕：中間地帶好細，揀啱招先好玩
const FEAR_MID = { small:0.6, big:0.75 };   // 唔係弱點又唔係免疫：小動靜 ×0.6、大招 ×0.75（舊：×1）
const FEAR_WORD = { breath:'背後吹氣', light:'燈', cold:'凍', sound:'怪聲', paper:'紙', phone:'電話', face:'鬼臉', shadow:'黑影' };
// 穿崩度（阿福）：俾人望到怪事、喺人面前重複同一招、太明目張膽 → 升；夠高就有人請道士
const EXPO = { seen:16, perWit:6, repeat:8, aoe:12, group:3, blatant:5, decay:0.5, lowDecay:1.5, sus:35, call:70, ritual:30, giveUp:15, expelMul:0.5 };
// 道士：做法專業人士。好笑在佢係人——講電話傾價錢、徒弟驚、自己都會嚇親；做法本身照足規矩（鈴、符紙、桃木劍）
const DAOSHI = { k:'daoshi', name:'林師傅', role:'道士・車馬費另計', spr:'npc_daoshi', speed:0.09, calm:3, weak:['phone', 'cold'], immune:['face', 'shadow'], karma:0, phone:true, daoshi:true, route:[[0.55, 0.78, 1, 'idle']],
  imm:{ face:'（眼都唔眨）呢啲我見得多。', shadow:'影啫，唔使驚。' }, lines:['（搖鈴）', '（講電話）係呀，車馬費另計㗎……', '阿徒，唔好震啦，拎穩張符。', '（揮桃木劍）'],
  say:{ immune:'（眼都唔眨）呢啲我見得多。', rational:['氣場亂咗少少啫。', '冇嘢，繼續。'], prime:['……嗯？', '（鈴聲停咗一停）'], hit:['哎呀！嚇親我！', '阿徒！支劍呢？！'], weak:'（電話震）唔……唔識嘅號碼？！', shout:'呢單唔收錢喇！',
    flee:'林師傅執起鈴就走：「呢單唔收錢喇！」徒弟跑得仲快。' },
  chat:[['美美','01:40','師傅，二十三樓好似有嘢，可唔可以上嚟睇睇？'],['林師傅','01:41','得。夜晚出車，車馬費另計。'],['徒弟','01:45','師傅，我今晚可唔可以喺樓下等？'],['林師傅','01:45','唔得。拎穩張符。']] };
// 旁人（冇見到鬼，只見到佢嚇親）：笑佢黐線（廣東話）
const MOCK_SAY = {
  ken:['（頭都唔抬）OT 做到傻咗呀？', '咪自己嚇自己啦。'], it:['應該係 cache 問題。', '你又發乜神經？'], mis:['（反白眼）', '黐線㗎佢……'],
  boss:['做唔切就話做唔切，唔好扮病！', '有時間驚，冇時間做嘢？'], auntie:['後生仔，飲多啲水啦。', '佢呢排怪怪哋……'], guard:['冇嘢㗎，我喺度三十年。'],
};
// 保安、安娣：全場燈／冷氣嚇唔到（夜晚呢棟樓成日係咁）
const GROUP_IMMUNE = { guard:{ light:'呢棟樓啲燈成日都係咁。', shadow:'呢棟樓啲燈成日都係咁。', cold:'冷氣又發神經，唔使理佢。' }, auntie:{ light:'又跳掣？唔關我事。', shadow:'又跳掣？唔關我事。', cold:'冷氣又壞，聽日報修。' } };
const PARA_SAY = ['你哋真係聽唔到？！', '我冇講大話㗎！', '頭先係咪有人叫我？', '點解得我一個見到……'];
const WIT_SAY = ['咩……咩嚟㗎？！', '你……你都見到？！', '頭先嗰個係咩嚟？！'];
// 心有餘悸時：回頭望、自言自語（廣東話）
const SHAKEN_SAY = ['……邊個喺度？', '（望一望後面）', '頭先係咪有人？', '唔好玩喇……', '（吞一啖口水）', '我……我好地地㗎……'];
const JUMPY_SAY = ['吓？！', '咩聲嚟㗎？！', '（成個彈起）'];
const NPC_UNIT = 64 * 1.08; // 木偶人 CHAR_H 64 × 1.08：讓人物高度和舊圖一樣（hh 像素）
// 可以附身的東西：pos = 背景上的位置（0~1），r = 影響半徑（0 = 全層樓）
const SCARE_PROPS = {
  // 全部只對「點中的那個人」：r = 要離那件家具多近先用得到（0 = 邊度都得）；vis = 會被旁人望到的怪事（望到就穿崩），手機、呼氣、冷風就只有他自己知
  lamp:   { name:'檯燈', type:'light', tier:1, base:15, cost:18, r:0.22, front:[0.66, 0.713], vis:true, rect:[0.435, 0.398, 0.065, 0.046], obj:'lamp', label:'up', say:'燈在閃' },
  // group = 全場一齊（燈、冷氣）：人人一齊經歷，冇人會覺得邊個黐線；只係令大家心緒不寧（之後單嚇加成）。有冷卻；保安、安娣慣咗唔怕
  ac:     { name:'冷氣', type:'cold', tier:1, base:12, cost:22, r:0, group:true, cdT:18, rect:[0.815, 0.148, 0.16, 0.097], say:'好冷' },
  water:  { name:'飲水機', type:'sound', tier:1, base:20, cost:15, r:0.2, vis:true, front:[0.80, 0.58], rect:[0.793, 0.406, 0.074, 0.105], obj:'water', label:'up', say:'咕嚕——' },
  printer:{ name:'影印機', type:'paper', tier:2, base:30, cost:25, r:0.2, vis:true, front:[0.66, 0.57], rect:[0.635, 0.42, 0.14, 0.098], obj:'copier', say:'自己在印' },
  // 新的：玩電燈（整層燈管一段一段熄掉＝影）、東西掉地上（櫃頂、桌上的東西接連掉＝聲）、辦公椅自己轉（空椅子轉、慢慢滑向人＝影）
  lights: { name:'玩電燈', type:'shadow', tier:2, base:14, cost:30, r:0, group:true, cdT:18, rect:[0.165, 0.142, 0.62, 0.036], say:'燈一段一段熄掉' },
  drop:   { name:'東西掉地上', type:'sound', tier:2, base:24, cost:25, r:0.3, vis:true, front:[0.15, 0.56], rect:[0.10, 0.40, 0.08, 0.11], obj:'cabinet', label:'up', say:'哐啷——' },
  chair:  { name:'辦公椅自己轉', type:'shadow', tier:1, base:16, cost:20, r:0.25, vis:true, front:[0.43, 0.58], rect:[0.64, 0.50, 0.06, 0.08], obj:'achair', say:'吱——' },
};
// 開放辦公區嘅家具：舊辦公室座標 → 全景世界座標（同 office.js 一樣搬法）
for (const k in SCARE_PROPS) { const p = SCARE_PROPS[k]; p.room = 'main'; if (p.group) continue; p.front = [OFFMAP.M(p.front[0]), OFFMAP.MY(p.front[1])]; p.rect = [OFFMAP.M(p.rect[0]), OFFMAP.MY(p.rect[1]), p.rect[2], p.rect[3] * 0.75]; }
{ const c = OFFMAP.SPOT.copier, p = SCARE_PROPS.printer; p.room = 'pantry'; p.front = [c[0] + 0.12, c[1] + 0.05]; p.r = 0.4; p.rect = [c[0] - 0.13, c[1] - 0.2, 0.26, 0.2]; } // 影印機搬咗去洗手間／影印房
// 其他房間嘅道具（rooms.js 量好嘅位置；效果喺 rooms.js 程式畫）。每招對應一種怕法
{ const O = OFFMAP, SP = O.SPOT, A = O.A, R = O.R, px = O.px;
  Object.assign(SCARE_PROPS, {
    micro:  { room:'pantry', name:'微波爐', type:'light', tier:1, base:16, cost:18, r:0.42, vis:true, front:SP.micro, rect:R(A.micro), label:'up', say:'自己叮' },
    fridge: { room:'pantry', name:'雪櫃門', type:'cold', tier:1, base:14, cost:16, r:0.42, vis:true, front:SP.fridge, rect:R(A.fridge), say:'自己打開' },
    kettle: { room:'pantry', name:'熱水壺', type:'breath', tier:1, base:18, cost:18, r:0.42, vis:true, front:SP.kettle, rect:R(A.kettle), label:'up', say:'嗚——' },
    vend:   { room:'pantry', name:'汽水機', type:'sound', tier:2, base:26, cost:24, r:0.42, vis:true, front:SP.vend, rect:R(A.vend), say:'哐咚' },
    tv:     { room:'meeting', name:'電視', type:'face', tier:2, base:26, cost:26, r:0.5, vis:true, front:[px(4920), 0.72], rect:R(A.tv), label:'up', say:'沙沙沙' },
    speaker:{ room:'meeting', name:'會議電話', type:'phone', tier:1, base:18, cost:18, r:0.45, vis:true, front:[px(5190), 0.72], rect:R(A.speaker), label:'up', say:'呼……' },
    chairs: { room:'meeting', name:'椅子自己行', type:'shadow', tier:2, base:22, cost:24, r:0.55, vis:true, front:[px(4800), 0.80], rect:R([4530, 640, 240, 270]), say:'吱——' },
    golf:   { room:'boss', name:'高爾夫球', type:'shadow', tier:1, base:16, cost:18, r:0.55, vis:true, front:[px(420), 0.76], rect:R(A.golfBag), say:'咕碌——' },
    bchair: { room:'boss', name:'皮椅自己轉', type:'face', tier:2, base:26, cost:24, r:0.45, vis:true, front:[px(770), 0.71], rect:R(A.chair), label:'up', say:'吱——' },
    trophy: { room:'boss', name:'獎盃', type:'sound', tier:2, base:24, cost:24, r:0.5, vis:true, front:[px(320), 0.72], rect:R(A.trophy), label:'up', say:'哐啷' },
  }); }
// 帶出門的鬼：大招（tier 3），每招冷卻 22 秒
const SCARE_GHOSTS = {
  afu:      { name:'阿福', skill:'坐回工位', type:'face', base:34, line:'（鍵盤自己在響。螢幕上打著：「好的老闆，收到。」）' },
  pontianak:{ name:'Pontianak', skill:'窗外笑聲', type:'sound', aoe:true, base:16, line:'嘻——嘻——嘻——' },
  tianhua:  { name:'天花姐', skill:'倒掛', type:'face', base:40, line:'哎喲……（頭髮垂到他面前）' },
  xiaozhi:  { name:'小紙', skill:'紙人', type:'shadow', base:32, line:'（角落多了一個紙人，對著他笑）' },
  eguiking: { name:'餓鬼王', skill:'叮叮叮', type:'sound', aoe:true, base:14, line:'叮叮叮叮！開飯了沒有？' },
  penanggal:{ name:'Penanggal', skill:'飛頭', type:'face', base:38, line:'（一個頭從他身邊飄過去）' },
  laojiang: { name:'老殭', skill:'跳過走廊', type:'shadow', base:32, line:'（玻璃門外，一跳、一跳、一跳）' },
};
const MIS_POST = OFFMAP.SPOT.reception; // 美美：大堂前台（背向左邊會議室門口、面向右邊），坐喺枱後面
const COPY_AT = [OFFMAP.SPOT.copier[0] + 0.16, OFFMAP.SPOT.copier[1] + 0.05]; // 影印機（洗手間／影印房）前面企嘅位
// 茶水間休息：坐低碌手機／飲嘢／瞌一陣（坐喺 Pantry 張枱後面，枱擋住腳）
const EMPTY_SAY = (() => { const T = (yue, zh) => { if (typeof LANG !== 'undefined' && LANG.add) LANG.add({ [yue]:zh }); return yue; };
  T('陳總～搵我呀？', '陳總～找我嗎？'); T('陳總，搵我？', '陳總，找我？');
  return { mis:T('陳總去咗邊呀？咁我出返去等先啦。', '陳總去哪了？那我先出去等吧。'), it:T('叫人入嚟自己又唔喺度……我返去做嘢先。', '叫人進來自己又不在……我先回去做事。') }; })(); // 被叫入房，陳總唔喺度
const BRK = (() => { const T = (yue, zh) => { if (typeof LANG !== 'undefined' && LANG.add) LANG.add({ [yue]:zh }); return yue; };
  return { it:T('抖陣先，個 server 自己頂住。', '休息一下，伺服器自己撐著。'), mis:T('坐低碌下手機先～', '坐下來滑一下手機～'), boss:T('（飲啖茶）唔好話我偷懶。', '（喝口茶）別說我偷懶。'),
    auntie:T('拖到腰都痛，坐陣先。', '拖到腰都痛，坐一會兒。'), ken:T('（打個呵欠）瞇五分鐘……', '（打個呵欠）瞇五分鐘……') }; })();
const _M = OFFMAP.M, _MY = OFFMAP.MY, _SP = OFFMAP.SPOT; // 開放辦公區：舊座標平移（阿Ken 路線距離、時間不變）；其他房間用 rooms.js 量好嘅站位
const SCARE_SITES = {
  office:{ name:'舊公司・二十三樓', bg:'office_pano', pano:true, layout:'office', persp:{ c:0.211, hz:-0.70 }, need:'ch1_end', shift:true, stars:[1100, 1300, 1480], oldStars:[250, 450, 760], exit:OFFMAP.SPOT.elev, /* 星星門檻（全景四間房改版後用 t21_v5 機械人重新量：人分散咗、落單多咗，整體分數高咗）（細緻玩法改版 t21_v4）：亂按、狂按、全場亂槍 < 1★；普通玩家 1~2★；3★ 要揀人、避開視線、連擊接爆點。oldStars = 舊算法的門檻，舊存檔的最高分照比例換過來 */
    intro:[['旁白','凌晨十二點。阿福回到他生前的公司。'],['阿福','門禁卡還能刷。公司也沒有人通知它。'],['系統','親～今晚的 KPI：嚇人。點場景裡發光的東西附身，點人可以偷看手機。'],['系統','先用小動靜讓他起疑，等他頭上冒「！」再出大招。小心巡邏的保安阿伯，被他的手電筒照到，就會被請去喝茶。']],
    npcs:[
      { k:'ken', name:'阿Ken', role:'加班仔', spr:'npc_ken', speed:0.05, calm:2.2, weak:['phone','face','paper'], immune:['light','cold'], hide:['paper'], imm:{ light:'（盯住手機）燈閃？我部手機光過佢。', cold:'凍？OT 慣咗。' }, karma:3, phone:true,
        route:[[_M(0.24), _MY(0.60), 14, 'work'], [_M(0.64), _MY(0.55), 4, 'idle'], [_M(0.24), _MY(0.60), 12, 'work'], [_M(0.79), _MY(0.57), 5, 'idle'], [_M(0.24), _MY(0.60), 12, 'work'], [_SP.restSeats[0][0], _SP.restSeats[0][1], 9, 'brk_nap']],
        say:{ immune:'（沒抬頭，在回老闆訊息）', rational:['我太累了……','眼花，一定是眼花。','加班加到出現幻覺了。'], prime:['……誰？','剛剛是不是有聲音？','（回頭看了一眼）'], hit:['哇！！','老……老闆？！','不、不是我做的！'], weak:'（手機一亮，整個人跳起來）在、在！我在！',
          flee:'阿Ken 看著空氣很久：「你也是……做到這麼晚？」第二天，他遞了辭職信，回老家吃媽媽煮的飯。' },
        chat:[['老闆','23:02','阿Ken，明早九點董事會，PPT 再改一版。'],['阿Ken','23:03','好的老闆，收到。'],['老闆','01:40','在嗎？'],['阿Ken','01:40','在！'],['媽','昨天','阿Ken，這個禮拜回來吃飯嗎？媽煲了湯。'],['阿Ken','昨天','下次吧，最近很忙']] },
      { k:'it', name:'小晴', role:'IT 工程師・今晚值班', spr:'npc_it', speed:0.08,
        post:[_M(0.66), 0.80, 'work'], work:[26, 40], trips:[['water', 2.6, _SP.water, [4, 6], '去茶水間斟杯水先。'], ['tea', 1.6, _SP.kettle, [4, 6], '沖杯茶頂下。'], ['copier', 1.2, COPY_AT, [3, 5], '印埋份 log。'], ['rest', 1.2, 'rest', [8, 12], BRK.it, null, ['brk_phone', 'brk_drink']], ['out', 1.4, 'out', [12, 18], '去個洗手間。', '返嚟喇。']],
        lines:{ cue:'（收拾筆電）差唔多喇……', bye:'終於收工！', back:'唔記得拎充電器……', work:['server 又 down……', '邊個又改咗個 config……', '（飲一啖珍奶）頂住先。'] }, calm:2.4, weak:['phone', 'sound', 'light'], immune:['cold', 'paper'], hide:['light'], imm:{ cold:'（拉緊帽T）我有帽，唔凍。', paper:'紙？我哋 paperless 㗎。' }, karma:-1, phone:true,
        route:[[_M(0.66), 0.80, 16, 'work']],
        say:{ immune:'（拉緊帽T：我有帽子，不冷。）', rational:['應該是網絡延遲。', '是 cache 的問題。', '伺服器又在搞我。', '一定是 Windows 在更新。'], prime:['……誰 ping 我？', '耳機裡怎麼有人在講話？', '（把耳機拿下來聽了一下）'], hit:['production 掛了嗎？！', '這不是 bug……這不是 bug……', '我只是來值班的！'], weak:'（手機和耳機一起響：「小晴……還在嗎……」）！！！',
          flee:'小晴把電腦一合：「這個 bug 明天再修！」衝進電梯。第二天她請了一星期假，去喝了七杯珍奶。' },
        chat:[['值班系統','01:12','【P1】23 樓伺服器溫度 4°C，請立即處理。'],['陳總','02:03','小晴，網站是不是慢了？我覺得慢了。'],['小晴','02:04','陳總，是你家的 Wi-Fi。'],['二十三樓八卦群','00:30','聽說 23 樓半夜影印機會自己印東西 👻'],['小晴','00:31','是驅動程式的問題，不要迷信。'],['媽','23:40','妹，又值夜班？記得吃飯。'],['小晴','23:41','有啦，珍奶算一餐。'],['珍奶店','22:58','您的訂單：全糖、多珍珠、去冰（第 3 杯）已送達。']] },
      { k:'mis', name:'美美', role:'陳總的秘書・心腹', spr:'npc_mis', speed:0.075,
        post:[MIS_POST[0], MIS_POST[1], 'idle', 1], work:[22, 34], trips:[['copier', 1.6, COPY_AT, [4, 6], '又要印多十份……'], ['rest', 1.0, 'rest', [8, 12], BRK.mis, null, ['brk_phone', 'brk_drink']], ['micro', 2.0, _SP.micro, [4, 6], '叮個宵夜先～'], ['boss', 2.2, 'boss', [4, 6], '陳總～份文件幫你印好喇～'], ['out', 1.6, 'out', [12, 20], '去補個妝先。', '補完妝喇～']],
        lines:{ cue:'（照鏡、拎手袋）', bye:'我走先喇～', back:'仲有嘢未搞掂……', late:'仲有嘢未搞掂……', work:['（接電話）陳總開緊會喎～', '又要印多十份……', '（釘文件）好煩呀～'] }, calm:2.6, weak:['phone', 'breath'], immune:['cold'], hide:['breath'], imm:{ cold:'冷氣凍啲先唔會甩妝。' }, karma:1, phone:true, fleeVia:'boss',
        route:[[MIS_POST[0], MIS_POST[1], 7, 'idle']],
        say:{ immune:'冷氣凍啲先唔會甩妝。', rational:['一定係阿Ken搞嘢。', '唔好嚇人啦，我粉底會裂㗎。', '呢啲嘢搵阿Ken做啦。'], prime:['……邊個喺度呀？', '（照一照鏡）我頭髮亂咗？', '咩聲嚟㗎？'], hit:['呀——我隻甲！', '陳總～有嘢呀～', '我部電話！'], weak:'（自拍鏡頭入面，佢後面多咗一塊臉）', shout:'陳總～救命呀～！',
          flee:'美美尖叫著衝去找陳總：「陳總～救命呀～！」第二天她請了「驚嚇假」，飛去日本購物壓驚，報告全部丟給阿Ken。' },
        chat:[['陳總','00:45','美美，聽日陪我去見客，記得著靚啲。'],['美美','00:46','陳總～人哋要放假啦～'],['陳總','00:46','放！做完呢季就放！'],['姊妹群','01:02','你仲喺公司？'],['美美','01:03','係呀，陳總話佢一個人驚 🙄'],['美美','01:20','阿Ken，份報告你幫我打埋佢啦，陳總要嘅。'],['阿Ken','01:21','……好。'],['網購','昨天','您訂購的「防甩妝噴霧 ×6」已出貨。']] },
      { k:'boss', name:'陳總', role:'新老闆', spr:'npc_boss', speed:0.075,
        post:[_SP.bossDesk[0], _SP.bossDesk[1], 'call', -1], work:[22, 32], trips:[['golf', 2.2, _SP.golf, [7, 10], '（練下推桿）'], ['ken', 1.4, [_M(0.40), _MY(0.665)], [4, 6], '阿Ken，份 PPT 呢？'], ['coffee', 1.2, _SP.coffee, [4, 6], '（自己沖咖啡）'], ['rest', 0.9, 'rest', [8, 12], BRK.boss, null, ['brk_drink', 'brk_phone']], ['out', 1, 'out', [12, 18], '出去食支煙。', '繼續做嘢！']],
        lines:{ cue:'（看錶）咁夜喇……', bye:'我走先，你哋繼續做。', late:'全部人留低開會！', golf:['（推桿）入！', '（推桿）……又偏咗。'], work:['喂？我唔理，聽朝九點前要見到！', '（對住電話）你講多次？預算爆咗？', '呢份計劃書邊個寫㗎？成份重做！', '（揭文件）專業啲好唔好呀……'] }, calm:3, weak:['paper','shadow'], immune:['sound', 'phone'], hide:['shadow'], imm:{ sound:'（戴住降噪耳機睇高爾夫）', phone:'（掛咗佢）唔識嘅號碼一律唔聽。' }, karma:2, phone:true,
        route:[[_SP.bossDesk[0], _SP.bossDesk[1], 9, 'call']],
        say:{ immune:'（戴著降噪耳機看高爾夫）', rational:['哼，風水問題。','明天叫 Master Lee 來看。','一定是實習生在搞鬼。'], prime:['……水晶球呢？','誰在那裡？','（把水晶球抱緊）'], hit:['誰印的？！虧損報表？！','誰批准你加班的？！','Master Lee！救命！'], weak:'（看到影印機自己在印）本、本季虧損報表？誰印的？！',
          flee:'陳總抱著水晶球衝進電梯：「明天開始，全公司……在家工作！」' },
        chat:[['Master Lee','昨天','陳總，你這層樓陰氣很重，水晶球記得對著窗口。'],['Master Lee','昨天','還有，千萬不要讓影印機半夜自己開。'],['秘書','22:10','陳總，阿Ken 已經連續加班第三晚了。'],['陳總','22:11','很好。叫他明晚繼續。']] },
      { k:'auntie', name:'清潔安娣', role:'今晚逐間房拖地', spr:'npc_auntie', speed:0.05,
        post:[OFFMAP.LANE[0][0], OFFMAP.LANE[0][1], 'mop'], lane:OFFMAP.LANE, laneWait:[3.5, 5.5], trips:[['out', 1, 'out', [10, 15], '換桶水先。', '拖埋呢邊就搞掂。']], tripEvery:2,
        lines:{ cue:'（收拾水桶）', bye:'聽日見。', late:'仲有一層未拖。', work:['拖完又踩污……', '呢度又有咖啡漬。'] }, calm:3, weak:['face','breath'], immune:['light','sound'], hide:['breath'], imm:{ light:'電線有問題，聽日叫人整。', sound:'哼，咩聲未聽過？' }, karma:-1, mop:true,
        route:[[OFFMAP.LANE[0][0], OFFMAP.LANE[0][1], 2, 'mop']],
        backfire:{ paper:'（拍照發到群組）誰亂印？！地上全是紙！' },
        say:{ immune:'電線有問題，明天叫人修。', rational:['哼。','加班費要算雙倍。','冷氣開這麼冷，電費誰付？'], prime:['誰？出來！','我剛拖完的地……','（握緊拖把）'], hit:['哎呀！我的地！','誰站在那裡？！','我不怕你！（揮拖把）'], weak:'誰的腳印？！天花板也有？！',
          flee:'安娣拖著水桶走了：「這間我不做了！隔壁大廈的鬼比較有禮貌！」' },
        chat:[['老闆娘','20:00','安娣，今晚地板要拖三次，陳總說要亮。'],['清潔安娣','20:01','好。'],['兒子','22:30','媽，又做到幾點？'],['清潔安娣','22:31','做完就回。你先吃，不用等。']] },
      { k:'guard', name:'保安阿伯', role:'夜班三十年・每間房都巡', spr:'npc_guard', speed:0.07,
        post:[OFFMAP.Ru(2.49), 0.79, 'doze', -1], work:[40, 55], lines:{ work:['（打瞌睡）Zzz……', '（醒一醒）……冇嘢，冇嘢。'] }, trips:[['patrol', 1, 'patrol', [3, 4], '巡一巡先。']], calm:99, weak:[], immune:['light','cold','sound','paper','phone','face','shadow'], karma:-1, guard:true, phone:true,
        route:[[OFFMAP.Ru(2.49), 0.79, 3, 'look']],
        say:{ immune:'又來？喝杯茶吧。', calmOther:'沒事啦，我在這裡三十年了。', catchG:'出來啦，不要躲。來，喝杯茶。' },
        chat:[['阿福','三個月前','阿伯，我又加班，今晚不用幫我留燈。'],['保安阿伯','三個月前','留咯。你走了我才關。'],['女兒','今天','爸，今晚幾點下班？'],['保安阿伯','今天','天亮。'],['保安阿伯','今天','那個阿Ken，跟阿福一樣，都不回家。']] },
    ] },
};

const PANO_ZOOM = 0.72; // 回陽間鏡頭遠近（1 = 背景剛好塞滿高度）
const Scare = {
  active:false,
  open(siteId) {
    if (typeof ScareX !== 'undefined' && ScareX.open) return ScareX.open(siteId); // 回陽間・帶邊幾隻鬼（scare_squad.js）
    this.migrate(); const site = SCARE_SITES[siteId];
    const ghosts = Object.keys(SCARE_GHOSTS).filter(k => k === 'afu' || S.ghosts.some(g => g.k === k));
    this.pick = { chosen:['afu'].concat(ghosts.filter(k => k !== 'afu').slice(0, 2)) };
    const render = () => {
      const best = (S.scare && S.scare.best[siteId]) || 0, st = this.starsOf(siteId, best);
      let h = `<p class="desc">${site.name}。天亮前三分鐘。<br>先用小動靜讓人起疑，等他頭上冒「！」再出大招。</p>`;
      h += `<p class="desc">最高紀錄：${best}　${'★'.repeat(st)}${'☆'.repeat(3 - st)}</p>`;
      h += `<div class="sc-pick">${ghosts.map(k => `<button class="sc-g ${this.pick.chosen.includes(k) ? 'on' : ''}" data-k="${k}" ${k === 'afu' ? 'disabled' : ''}><canvas data-por="${k}"></canvas><b>${SCARE_GHOSTS[k].name}</b><small>${SCARE_GHOSTS[k].skill}・${SCARE_TYPES[SCARE_GHOSTS[k].type]}</small></button>`).join('')}</div>`;
      h += `<p class="desc">阿福一定去。另外最多帶兩隻。</p><button class="btn gold wide" id="sc-go">出發，回陽間</button>`;
      return h;
    };
    const bind = () => {
      paintPortraits($('#sheet'));
      $('#sheet').querySelectorAll('.sc-g').forEach(b => b.onclick = () => {
        const k = b.dataset.k, c = this.pick.chosen;
        if (c.includes(k)) c.splice(c.indexOf(k), 1); else if (c.length < 3) c.push(k); else { Fx.toast('最多帶兩隻'); return; }
        $('#sheet .sh-body').innerHTML = render(); bind();
      });
      $('#sc-go').onclick = () => { UI.close(); this.start(siteId, this.pick.chosen.slice()); };
    };
    UI.sheet('回陽間・夜班', render()); bind();
  },
  // 舊存檔：最高分是舊算法（分數小很多）→ 照星星門檻按比例換成新分數，星星不會掉、寶箱不會重複拿
  migrate() {
    if (typeof S === 'undefined' || !S || !S.scare || S.scare.fv >= 3) return;
    if (S.scare.fv === 2) { S.scare.fv = 3; // 全景改版：星星門檻 [650,1200,1600] → [1100,1300,1480]，舊最高分照比例換，星星唔會變
      const a = [0, 650, 1200, 1600], b = [0, 1100, 1300, 1480]; for (const k in S.scare.best) { const v = S.scare.best[k]; if (!v || k !== 'office') continue; let i = 0; while (i < 2 && v >= a[i + 1]) i++; S.scare.best[k] = v >= a[3] ? Math.round(b[3] + (v - a[3]) * 0.75) : Math.round(b[i] + (v - a[i]) * (b[i + 1] - b[i]) / (a[i + 1] - a[i])); }
      if (typeof save === 'function') save(); return; }
    S.scare.fv = 3;
    for (const k in S.scare.best) { const st = SCARE_SITES[k], v = S.scare.best[k]; if (!st || !st.oldStars || !v) continue;
      const a = [0].concat(st.oldStars), b = [0].concat(st.stars); let i = 0; while (i < 2 && v >= a[i + 1]) i++;
      S.scare.best[k] = v >= a[3] ? Math.round(b[3] + (v - a[3]) * (b[3] - b[2]) / (a[3] - a[2])) : Math.round(b[i] + (v - a[i]) * (b[i + 1] - b[i]) / (a[i + 1] - a[i])); }
    if (typeof save === 'function') save();
  },
  starsOf(siteId, v) { this.migrate(); const s = SCARE_SITES[siteId].stars; return v >= s[2] ? 3 : v >= s[1] ? 2 : v >= s[0] ? 1 : 0; },

  // ---------- 開局 ----------
  start(siteId, team, headless, seed) {
    const site = SCARE_SITES[siteId];
    Object.assign(this, { endAt:0, expo:0, expoMax:0, expoT:-99, alert:false, daoCall:0, daoIn:false, expelled:false, kpiCut:false, known:{}, guardKarma:false, site, siteId, active:true, headless:!!headless, t:0, kpi:0, mana:60 + (typeof GhostStreet !== 'undefined' && !headless ? GhostStreet.bonus('mana') : 0), team, fx:[], parts:[], floats:[], fq:[], bq:[], karma:[], shake:0, vign:0, paused:!headless, sel:null });
    this.cd = {}; this.pcd = {}; this.caught = {}; team.forEach(k => this.cd[k] = 0);
    this.npcs = site.npcs.map((d, i) => ({ d, x:d.route[0][0], y:d.route[0][1], wi:0, wait:d.route[0][2] * (0.3 + i * 0.25), dir:1, fear:0, peak:0, gone:false, exitT:0, bounce:0, look:0, bub:null, bubT:0, act:d.route[0][3], ph:Math.random() * 6 }));
    this.seed = seed != null ? seed : (Date.now() % 100000); this.door = 0;
    if (site.shift) this.shiftInit();
    this.sel = this.npcs[0]; this.selAuto = false;
    if (typeof ScareX !== 'undefined') ScareX.night(this); // 傳說熱度嘅變化、靈探 KOL、Bryan（scare_squad.js）
    if (headless) return;
    const el = $('#scare'); el.classList.add('on');
    el.innerHTML = `<div id="sc-top"><button class="btn sm ghost" id="sc-quit">收工</button><span id="sc-clock"></span><div id="sc-mana"><i></i><b>陰氣</b></div><span id="sc-kpi"></span></div>
      <div id="sc-stage"><canvas id="sc-cvs"></canvas>${site.pano ? OFFMAP.mapHTML() : ''}</div>
      <div id="sc-panel"><div id="sc-target"></div><div id="sc-dock"></div></div><div id="sc-phone"></div>`;
    $('#sc-quit').onclick = () => { if (!confirmInline($('#sc-quit'), '確定收工？')) return; this.finish(true); };
    const cv = $('#sc-cvs'); this.camX = 0; this.camV = 0; this.follow = true; this.userPan = -99; this._dots = null;
    if (site.pano) this.bindPan(cv); else cv.addEventListener('pointerdown', (e) => this.tap(e));
    Sound.setMode('story');
    this.renderDock(); this.renderTarget(); this.resize();
    if (site.pano) { OFFMAP.init(this); this.camX = this.clampCam(this.npcs[0].x - this.viewW() * 0.5); }
    if (this.office()) { OFFICE.init(this); for (const k in SCARE_PROPS) { const r = SCARE_PROPS[k].obj && OFFICE.rectOf(SCARE_PROPS[k].obj); if (r) SCARE_PROPS[k].rect = r; } } if (!this._rs) { this._rs = true; window.addEventListener('resize', () => { if (this.active && !this.headless) this.resize(); }); }
    this.last = performance.now(); requestAnimationFrame((n) => this.frame(n));
    Story.queue({ style:'sys', lines:site.intro }, () => { this.paused = false; this.last = performance.now(); });
  },
  resize() {
    const c = $('#sc-cvs'), box = $('#sc-stage').getBoundingClientRect(), dpr = Math.min(2, window.devicePixelRatio || 1);
    c.width = box.width * dpr; c.height = box.height * dpr; c.style.width = box.width + 'px'; c.style.height = box.height + 'px';
    this.W = box.width; this.H = box.height; this.dpr = dpr;
  },
  // ---------- 全景鏡頭：手指左右拖（有慣性、到邊停）；點一下 = 揀人／附身；選中嘅人行出畫面，鏡頭慢慢跟過去 ----------
  viewW() { const b = this.bgScale(); return (this.W || 390) / (b.iw * b.s); },
  clampCam(x) { return Math.max(0, Math.min(OFFMAP.WW - this.viewW(), x)); },
  camRoom() { return OFFMAP.roomAt((this.camX || 0) + this.viewW() / 2); },
  roomOf(n) { return OFFMAP.roomAt(n.x).k; },
  sameRoom(a, b) { return !this.site.pano || OFFMAP.roomAt(a.x) === OFFMAP.roomAt(b.x); },
  onScreen(x, m) { m = m == null ? 0.25 : m; return x > (this.camX || 0) - m && x < (this.camX || 0) + this.viewW() + m; },
  bindPan(cv) {
    let d = null; const unit = () => { const b = this.bgScale(); return b.iw * b.s; };
    cv.addEventListener('pointerdown', (e) => { d = { x0:e.clientX, y0:e.clientY, c0:this.camX, moved:false, lx:e.clientX, lt:performance.now(), id:e.pointerId }; this.camV = 0; try { cv.setPointerCapture(e.pointerId); } catch (_) {} });
    cv.addEventListener('pointermove', (e) => { if (!d) return; const dx = e.clientX - d.x0; if (!d.moved && Math.abs(dx) > 9) d.moved = true;
      if (d.moved) { const now = performance.now(), dt = Math.max(16, now - d.lt); this.camX = this.clampCam(d.c0 - dx / unit()); this.camV = Math.max(-2.5, Math.min(2.5, 0.7 * this.camV + 0.3 * (-(e.clientX - d.lx) / unit()) / (dt / 1000))); d.lx = e.clientX; d.lt = now; this.userPan = this.t; } }); // dt 最少 16ms、速度有上限：手機兩個觸控事件同一刻到，唔會計出超大速度令畫面飛走
    const up = (e) => { if (!d) return; const was = d; d = null; if (!was.moved) { this.camV = 0; this.tap(e); } else { if (performance.now() - was.lt > 90 || Math.abs(e.clientX - was.x0) < 40) this.camV = 0; this.userPan = this.t; } }; // 拖得好短（其實係想點人）：唔留慣性
    cv.addEventListener('pointerup', up); cv.addEventListener('pointercancel', () => { d = null; });
    const m = $('#sc-map'); if (m) m.addEventListener('pointerdown', (e) => { const r = m.getBoundingClientRect(), x = (e.clientX - r.left) / r.width * OFFMAP.WW; this.camV = 0; this.camTo = this.clampCam(x - this.viewW() / 2); this.userPan = this.t; });
    const f = $('#sc-follow'); if (f) f.onclick = () => { this.follow = !this.follow; f.classList.toggle('on', this.follow); if (this.follow) this.userPan = -99; };
    this._panning = () => !!d;
  },
  camTick(rdt) {
    if (!this.site.pano) return; const vw = this.viewW();
    if (this.camTo != null) { this.camX += (this.camTo - this.camX) * Math.min(1, rdt * 9); if (Math.abs(this.camTo - this.camX) < 0.002) { this.camX = this.camTo; this.camTo = null; } }
    else if (!(this._panning && this._panning())) {
      if (Math.abs(this.camV) > 0.01) { this.camX += this.camV * rdt; this.camV *= Math.exp(-rdt * 4.5); }
      const n = this.sel; // 跟住點中嘅人：佢行近畫面邊（或者出咗畫面），鏡頭慢慢移過去
      if (this.follow && n && !n.gone && !n.out && !n.fleeing && !n.leaving && !this.selAuto && this.t - this.userPan > 2.5 && Math.abs(this.camV) < 0.05) { const vx = n.vX != null ? n.vX : n.x, l = this.camX + vw * 0.18, r = this.camX + vw * 0.82;
        if (vx < l || vx > r) this.camX += ((vx < l ? vx - vw * 0.18 : vx - vw * 0.82)) * Math.min(1, rdt * 2.2); }
    }
    const c = this.clampCam(this.camX); if (c !== this.camX) this.camV = 0; this.camX = c;
  },
  bgScale() { if (this.site && this.site.pano) { const W = this.W || 390, H = this.H || 580, iw = OFFMAP.PXU, ih = OFFMAP.SH, s = Math.max(H / ih * PANO_ZOOM, W / (OFFMAP.WW * iw)); return { s, iw, ih, ox:-(this.camX || 0) * iw * s, oy:H - ih * s }; } // 貼底；PANO_ZOOM < 1：鏡頭拉遠，上面露出嘅位由 rooms.js 用天花補
    const img = SPR['bg_' + this.site.bg]; const iw = img && img.naturalWidth || 768, ih = img && img.naturalHeight || 1152, W = this.W || 390, H = this.H || 580; const s = Math.max(W / iw, H / ih); return { s, iw, ih, ox:(W - iw * s) / 2, oy:H - ih * s }; },
  pt(fx, fy) { const b = this.bgScale(); return [fx * b.iw * b.s + b.ox, fy * b.ih * b.s + b.oy]; }, // 全景：x = 世界座標（減鏡頭）
  depth(y) { return this.site && this.site.persp ? this.hh(y) / ((this.H || 580) * 0.165) : 0.72 + 0.5 * Math.max(0, Math.min(1, (y - 0.55) / 0.42)); },
  // 人的高度（px）：有 persp = 透視一把尺（背景、家具、人同一個比例）：hh = 背景高 × c ×（y − hz）
  persp() { return this.site && this.site.persp; },
  bgAR() { const b = this.bgScale(); return b.ih / b.iw; },
  hhF(y) { const p = this.site.persp; return p.c * (y - p.hz); },
  hh(y) { if (!this.persp()) return (this.H || 580) * 0.165 * this.depth(y); const b = this.bgScale(); return b.ih * b.s * this.hhF(y); },
  office() { return !this.headless && this.site && this.site.layout === 'office' && typeof OFFICE !== 'undefined'; },

  // ---------- 每一幀 ----------
  frame(now) {
    if (!this.active) return;
    if (now - this.last < 1000 / 30 - 2) { requestAnimationFrame((n) => this.frame(n)); return; } // 上限每秒 30 格（手機發燙）
    const rdt = Math.min(0.05, (now - this.last) / 1000), dt = rdt * (this.timeScale || 1); this.last = now; this.camTick(rdt);
    if (!this.paused && !Story.busy()) this.step(dt);
    if (!this.active) return;
    this.floatTick(rdt); // 提示字用真實時間：暫停／開面板都會照樣淡走，唔會留低半透明嘅殘影
    this.draw(now / 1000);
    if (!this.paused) this.hud();
    requestAnimationFrame((n) => this.frame(n));
  },
  step(dt) {
    this.t += dt; this.mana = Math.min(100, this.mana + 7 * dt);
    for (const k in this.cd) this.cd[k] = Math.max(0, this.cd[k] - dt);
    if (this.pcd) for (const k in this.pcd) this.pcd[k] = Math.max(0, this.pcd[k] - dt);
    for (const n of this.npcs) { this.moveNpc(n, dt); if (!this.headless) this.animNpc(n, dt); }
    if (this.office()) { OFFICE.tick(dt); if (this.site.pano) OFFMAP.tick(dt); }
    this.expoTick(dt); if (typeof ScareX !== 'undefined') ScareX.tick(this, dt);
    // 保安的手電筒：照到正在出招的鬼，就請他喝茶
    const g = this.npcs.find(n => n.d.guard);
    for (const f of this.fx) if (f.ghost && !f.caught && g && this.inBeam(g, f.gx, f.gy)) { f.caught = true; this.caught[f.ghost] = true; this.cd[f.ghost] = 999; this.bubble(g, g.d.say.catchG, 2.6); this.react(g, 'catch'); f.busted = this.t; this.float(f.gx, f.gy - 0.08, `${SCARE_GHOSTS[f.ghost].name} 被請去喝茶`, '#9ad'); this.addKarma(g.d, 0, ''); if (!this.headless) this.renderDock(); }
    this.fx = this.fx.filter(f => (f.life -= dt) > 0);
    this.parts = this.parts.filter(p => { if (p.delay > 0) { p.delay -= dt; return true; } p.life -= dt; p.x += p.vx * dt; p.y += p.vy * dt; p.vy += (p.g || 0) * dt; p.rot = (p.rot || 0) + (p.vr || 0) * dt; return p.life > 0; });
    if (!this.headless) { // 排隊嘅對白、提示字
      if (this.bq && this.bq.length && this.npcs.filter(m => m.bub && m.bubT > 0 && !m.gone).length < 2) { while (this.bq.length) { const q = this.bq.shift(); if (this.t - q.at < 4 && !q.n.gone && !q.n.out) { this.bubble(q.n, q.text, q.dur, q.ghost); break; } } }
    }
    this.shake = Math.max(0, this.shake - dt * 2.2); this.vign = Math.max(0, this.vign - dt * 1.2);
    if (this.expelled) { if (!this.kpiCut) { this.kpiCut = true; this.kpi = Math.round(this.kpi * EXPO.expelMul); } if (this.headless) this.active = false; else if (this.t - this.endAt > 2.6) this.finish(false); return; }
    if (this.t >= NIGHT_SEC || this.npcs.every(n => n.gone || n.d.guard || (n.left && n.out))) { if (this.headless) this.active = false; else if (this.t >= NIGHT_SEC) this.finish(false); else { this.endAt = this.endAt || this.t; if (this.t - this.endAt > 2.2) this.finish(false); } } // 全跑光：讓最後一個衝出畫面再收工
  },
  moveNpc(n, dt) {
    n.bounce = Math.max(0, n.bounce - dt * 2.5); n.ph += dt;
    if (n.bubT > 0) { n.bubT -= dt; if (n.bubT <= 0) n.bub = null; }
    if (n.gone) return;
    if (n.out) { this.outTick(n, dt); return; } // 不在（回家了／去洗手間）
    // 冷靜：越多人在旁邊，冷靜得越快
    const near = this.npcs.filter(m => m !== n && !m.gone && !m.out && this.sameRoom(m, n) && Math.hypot(m.x - n.x, m.y - n.y) < 0.22).length;
    if (!n.d.guard) { n.lookCD = (n.lookCD == null ? 3 + 8 * this.rnd(n) : n.lookCD) - dt; if (n.lookUp > 0) n.lookUp -= dt; else if (n.lookCD <= 0) { n.lookUp = 2.5; n.lookCD = 7 + 7 * this.rnd(n); } } // 低頭做嘢的人，間唔中抬頭望一望
    if (n.fear >= 50 && !n.d.guard) n.shaken = FEAR.shaken; // 嚇到「！」：心有餘悸，之後好一陣子都定唔落
    n.shaken = Math.max(0, (n.shaken || 0) - dt); if (n.uneasy > 0) n.uneasy -= dt;
    const cr = (n.d.calm * FEAR.decay + near * FEAR.nearCalm) * (n.shaken > 0 ? FEAR.shakenDecay : 1);
    n.fear = Math.max(n.shaken > 0 ? Math.min(n.fear, FEAR.shakenFloor) : 0, n.fear - cr * dt);
    if (n.hab) for (const k in n.hab) n.hab[k] = Math.max(0, n.hab[k] - dt / FEAR.habForget);
    if (n.shaken > 0 && !n.fleeing) { n.glance = (n.glance == null ? 3 : n.glance) - dt; if (n.glance <= 0) { n.glance = 3.5 + Math.random() * 3; if (!this.headless && !n.rx && n.act !== 'walk') { this.react(n, 'chill', { dur:2.2 }); if (!n.bub && Math.random() < 0.45) this.bubble(n, pick(SHAKEN_SAY), 1.8); } } }
    if (n.fear >= 25) { n.look -= dt; if (n.look <= 0) { n.dir *= -1; n.look = 0.9 + Math.random() * 0.8; } }
    if (n.fleeing) { // 逃跑
      let [ex, ey] = this.site.exit;
      if (n.d.fleeVia && !n.viaDone) { const b = this.npcs.find(m => m.d.k === n.d.fleeVia && !m.gone); if (b) { ex = b.x; ey = b.y; if (Math.hypot(ex - n.x, ey - n.y) < 0.05) n.viaDone = true; } else n.viaDone = true; } // 先衝去找陳總，再一起逃
      const dx = ex - n.x, dy = ey - n.y, d = Math.hypot(dx, dy);
      n.dir = dx >= 0 ? 1 : -1; if (d < 0.02) { if (n.d.fleeVia && !n.viaDone) { n.viaDone = true; return; } n.gone = true; n.exitT = this.t; return; }
      const sp = 0.28 * dt; n.x += dx / d * sp; n.y += dy / d * sp; if (Math.random() < 0.5) this.dust(n); return;
    }
    if (n.d.daoshi) { this.daoTick(n, dt); return; } // 道士：行入嚟 → 做法 → 收工／放棄
    if (n.d.post && this.site.shift) { this.planMove(n, dt); return; } // 有崗位的人：留在崗位做事，有目的才走開
    if (n.wait > 0) { n.wait -= dt * (n.fear >= 50 ? 0.4 : 1); n.act = n.d.route[n.wi][3]; if (n.act === 'brk_nap' && n.fear < 25) n.dir = n.x <= _SP.restTable[0] + 0.01 ? 1 : -1; return; }
    let nxt = n.d.route[(n.wi + 1) % n.d.route.length];
    if (nxt[3] === 'brk_nap' && this.site.pano) { if (!n.napAt) n.napAt = this.freeSeat(n, nxt); nxt = [n.napAt[0], n.napAt[1], nxt[2], nxt[3]]; } else n.napAt = null; // 茶水間圓枱：有人坐咗就揀第二張櫈
    const dx = nxt[0] - n.x, dy = nxt[1] - n.y, d = Math.hypot(dx, dy);
    const sp = n.d.speed * (n.fear >= 50 ? 0.55 : 1) * dt; n.act = 'walk';
    if (n.fear < 25) n.dir = dx >= 0 ? 1 : -1;
    if (d <= sp) { n.x = nxt[0]; n.y = nxt[1]; n.wi = (n.wi + 1) % n.d.route.length; n.wait = nxt[2]; } else { n.x += dx / d * sp; n.y += dy / d * sp; }
  },
  // ---------- 夜班：崗位、有目的的走動、進出電梯（同一個種子 = 同一晚的班表，平衡測試可以重跑） ----------
  rng(n) { let a = n._seed = (n._seed + 0x6D2B79F5) | 0; let t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; },
  U(n, a, b) { return a + (b - a) * this.rng(n); },
  exitPt() { return this.site.exit || [0.905, 0.535]; },
  present(ex) { return this.npcs.filter(m => m !== ex && !m.d.guard && !m.d.daoshi && !m.gone && !m.out && !m.fleeing && !m.leaving).length; }, // leaving = 已經在收拾／走去電梯（先算不在，免得兩個人同時走）
  shiftInit() {
    const S0 = this.seed;
    for (const [i, n] of this.npcs.entries()) {
      n._seed = (S0 * 7919 + i * 104729) | 0; n.ev = [];
      const d = n.d, L = d.lines || {}, r = () => this.rng(n), U = (a, b) => this.U(n, a, b);
      if (d.post) { n.x = d.post[0]; n.y = d.post[1]; n.act = d.post[2]; n.wait = 0; n.step = { x:n.x, y:n.y, wait:U(6, d.work ? d.work[1] : 6), act:d.post[2], arrived:true }; n.wait = n.step.wait; n.li = 0; }
      // 班表：遲到（吃完飯回來／回來拿東西）、早走、去洗手間（走的時候先收拾東西，讓玩家看得到要趁他走之前嚇）
      if (d.k === 'boss') { n.ev.push({ t:U(18, 40), k:'in', say:L.late }); n.ev.push({ t:U(42, 56), k:'callin' }); n.ev.push({ t:U(70, 84), k:'meeting' }); if (r() < 0.6) n.ev.push({ t:U(122, 136), k:'callin' }); if (r() < 0.5) n.ev.push({ t:U(150, 165), k:'leave' }); } // 陳總：遲到、叫人入房、開會、早走
      if (d.k === 'it') { const t1 = U(100, 145); if (r() < 0.45) { n.ev.push({ t:t1, k:'leave', back:U(12, 20) }); } else n.ev.push({ t:t1 + 15, k:'leave' }); }
      if (d.k === 'mis') { if (r() < 0.35) n.ev.push({ t:U(25, 60), k:'in', say:L.late }); if (r() < 0.6) n.ev.push({ t:U(120, 160), k:'leave' }); }
      if (d.k === 'auntie') { if (r() < 0.5) n.ev.push({ t:U(20, 50), k:'in', say:L.late }); if (r() < 0.5) n.ev.push({ t:U(135, 168), k:'leave' }); }
      n.ev.sort((a, b) => a.t - b.t);
      if (n.ev[0] && n.ev[0].k === 'in') { const e = n.ev.shift(); this.goOut(n, e.t, false, e.say, true); }
    }
  },
  // 走進電梯：dur 秒之後回來（leave = 不回來了）
  goOut(n, dur, leave, backSay, silent) {
    const [ex, ey] = this.exitPt(); n.out = true; n.leaving = false; n.left = !!leave; n.outT = dur; n.outAt = silent ? -9 : this.t; n.inSay = backSay || null; n.x = ex; n.y = ey; n.step = null; n.act = 'idle';
    if (!silent) this.elevator(); if (this.office() && n.d.k === 'it') OFFICE.offline('it', !!leave);
  },
  outTick(n, dt) {
    if (n.left) return; n.outT -= dt; if (n.outT > 0) return;
    if (this.site.pano && (n.inWait = (n.inWait || 0) + dt) < 8 && this.npcs.filter(m => m !== n && !m.gone && !m.out && m.act === 'walk' && this.roomOf(m) === 'main').length >= 2) return; n.inWait = 0; // 辦公區已經有兩個人行緊：電梯遲啲先開
    n.out = false; n.inAt = this.t; this.elevator(); if (this.office() && n.d.k === 'it') OFFICE.offline('it', false);
    const [ex, ey] = this.exitPt(); n.x = ex; n.y = ey; n.dir = -1; if (n.inSay) this.bubble(n, n.inSay, 2.6); n.inSay = null; n.step = null; n.next = null;
  },
  elevator() { this.door = 1.8; this.jumpy(null, 'lobby'); if (!this.headless) { if (typeof Sound !== 'undefined') Sound.play('coin'); if (this.office()) OFFICE.elevator(); } },
  // 有崗位的人：一步一步走（path = 經過的點），到了就做那件事 wait 秒
  planMove(n, dt) {
    const d = n.d;
    // 班表上的事：要走了（先收拾、看錶 3.5 秒 → 走去電梯）
    while (n.ev.length && this.t >= n.ev[0].t) {
      const e = n.ev[0];
      if (e.k === 'leave') { if (this.present(n) < 2) { e.t += 3; break; } n.ev.shift(); n.leaving = true; n.step = { x:n.x, y:n.y, wait:3.5, act:'pack', arrived:true, cue:true }; n.wait = 3.5; this.bubble(n, d.lines && d.lines.cue, 3);
        n.next = { out:true, leave:!e.back, outDur:e.back || 0, backSay:d.lines && d.lines.back, sayStart:d.lines && d.lines.bye }; continue; }
      if (e.k === 'in') { n.ev.shift(); continue; }
      if (e.k === 'callin' || e.k === 'meeting') { if (n.leaving || n.fleeing || n.fear >= 50 || !this.bossCall(n, e.k)) { e.t += 5; break; } n.ev.shift(); continue; }
    }
    if (n.call && !n.leaving) { const c = n.call, cb = c.boss;
      if (cb && (cb.gone || cb.out || cb.fleeing)) { n.call = null; } // 陳總自己走咗／嚇走咗：唔使去
      else if (cb && this.roomOf(cb) !== 'boss' && (c.hold = (c.hold || 0) + dt) < 25) { /* 等陳總行返入房先出發 */ }
      else if (c.delay > 0) c.delay -= dt; else { n.call = null; n.next = null; n.step = { x:c.x, y:c.y, wait:c.wait, act:c.act, arrived:false, path:null, pi:0, say:c.say, called:true, boss:c.boss || null }; if (c.go) this.bubble(n, c.go, 2.2); } }
    if (!n.step) { n.step = n.next ? this.mkStep(n, n.next) : this.planNext(n); n.next = null; if (n.step.arrived) n.wait = n.step.wait; }
    const s = n.step;
    if (!s.arrived && !s.go) { // 出發前睇吓：沿途嘅房已經有兩個人行緊 → 企喺度等一陣（最多等 8 秒）
      s.hold = (s.hold || 0) + dt; // 已經行緊路（路線中途換咗目的地）或者企喺牆／門口：唔好停喺度，直接行
      if (n.act !== 'walk' && !this.inDoor(n.x) && !(s.called && n.d.k === 'boss') && this.walkBlocked(n, s.x) && s.hold < 6 && !n.fleeing) { n.act = 'idle'; return; } s.go = true; }
    if (!s.arrived) {
      const tgt = s.path && s.pi < s.path.length ? s.path[s.pi] : [s.x, s.y];
      const dx = tgt[0] - n.x, dy = tgt[1] - n.y, dd = Math.hypot(dx, dy), sp = d.speed * (n.fear >= 50 ? 0.55 : 1) * dt;
      n.act = s.mopWalk ? 'mop' : 'walk'; if (s.mopWalk) n.act = 'walk';
      if (n.fear < 25) n.dir = dx >= 0 ? 1 : -1;
      if (dd <= sp) { n.x = tgt[0]; n.y = tgt[1]; if (s.path && s.pi < s.path.length) { s.pi++; return; }
        s.arrived = true; n.wait = s.wait; if (s.say) this.bubble(n, s.say, 2.4);
        if (s.out) { this.goOut(n, s.outDur, s.leave, s.backSay); return; } }
      else { n.x += dx / dd * sp; n.y += dy / dd * sp; }
      return;
    }
    n.act = s.act; n.wait -= dt * (n.fear >= 50 ? 0.4 : 1);
    if (s.called && s.boss && n.fear < 50) { const b = s.boss; // 被叫入房：陳總唔喺房 → 等一陣，等唔到就返去
      if (b.gone || b.out || b.fleeing || this.roomOf(b) !== 'boss') { s.empty = (s.empty || 0) + dt; n.wait += dt; if (s.empty > 6) { this.bubble(n, EMPTY_SAY[n.d.k] || EMPTY_SAY.it, 2.6); n.step = null; return; } } else s.empty = 0; }
    const atPost = d.post && Math.hypot(n.x - d.post[0], n.y - d.post[1]) < 0.012;
    if (atPost && d.post[3] && n.fear < 25) n.dir = d.post[3]; // 崗位有方向：陳總對住白板、阿伯對住電梯口
    if (n.act === 'present' && n.fear < 25) n.dir = 1; // 開會：企喺白板右邊，手套手向後指住白板
    if (s.sit && s.act === 'brk_nap' && n.fear < 25) n.dir = n.x <= _SP.restTable[0] + 0.01 ? 1 : -1; // 伏喺枱：面向圓枱
    if (n.d.guard && n.act === 'doze' && n.fear > 0) n.act = 'look';
    if (atPost && d.lines && d.lines.work && n.fear < 25 && !s.cue) { n.wl = (n.wl == null ? 4 + this.rng(n) * 6 : n.wl) - dt; if (n.wl <= 0) { n.wl = 9 + this.rng(n) * 8; if (!n.bub && (this.headless || !this.npcs.some(m => m.bub && m.bubT > 0))) this.bubble(n, d.lines.work[Math.floor(this.rng(n) * d.lines.work.length)], 2.4); } }
    if (n.wait <= 0) { if (s.meet) { let i = 0; for (const m of this.npcs) if (m.step && m.step.act === 'notes' && m.step.arrived) { m.wait = Math.min(m.wait, 1.5 + 3 * i++); } else if (m.call && m.call.act === 'notes') m.call = null; this.bubble(n, '散會！聽朝九點前交。', 2.4); } n.step = null; }
  },
  // 走去電梯／從電梯出來：繞過影印機和飲水機（先到 (0.80, 0.60) 再轉）
  freeSeat(n, pref) { const S = _SP.restSeats, near = (a, p) => a && Math.hypot(a[0] - p[0], a[1] - p[1]) < 0.02;
    const busy = (p) => this.npcs.some(m => m !== n && !m.gone && !m.out && (near([m.x, m.y], p) || (m.step && near([m.step.x, m.step.y], p)) || near(m.napAt, p)));
    if (!busy(pref)) return [pref[0], pref[1]]; const f = S.find(p => !busy(p)); return f ? [f[0], f[1]] : [pref[0], pref[1]]; },
  restStep(n, wait, say, acts) { // 茶水間休息：揀一張冇人坐嘅櫈
    const S = _SP.restSeats, busy = (p) => this.npcs.some(m => m !== n && !m.gone && !m.out && ((m.step && Math.hypot(m.step.x - p[0], m.step.y - p[1]) < 0.01) || Math.hypot(m.x - p[0], m.y - p[1]) < 0.01 || (m.napAt && Math.hypot(m.napAt[0] - p[0], m.napAt[1] - p[1]) < 0.01))), free = S.filter(p => !busy(p));
    const [px, py, pact] = n.d.post; if (!free.length || this.busy(n, free[0][0])) return { x:px, y:py, wait:this.U(n, 4, 8), act:pact, arrived:true };
    const p = free[Math.floor(this.rng(n) * free.length)], a = acts || ['brk_phone', 'brk_drink', 'brk_nap']; if (say) this.bubble(n, say, 2.2);
    return { x:p[0], y:p[1], wait, act:a[Math.floor(this.rng(n) * a.length)], arrived:false, path:null, pi:0, sit:true };
  },
  sitting(n) { if (n.gone || n.out || n.fleeing || n.act === 'walk') return false; if (n.act && (n.act.startsWith('brk_') || n.act === 'notes')) return true;
    return this.site.pano && n.d.k === 'mis' && Math.hypot(n.x - MIS_POST[0], n.y - MIS_POST[1]) < 0.012; }, // 坐低：成個人降低、腳底以下唔畫（張枱擋住）
  viaElev(n, x, y) { const p = []; if (y < _MY(0.6) && x > _M(0.5) && x < _M(0.86)) p.push([_M(0.80), _MY(0.60)]); return p; },
  mkStep(n, o) {
    const [ex, ey] = this.exitPt();
    if (o.out) { n.leaving = true; if (o.sayStart) this.bubble(n, o.sayStart, 2.4); return { x:ex, y:ey, path:this.viaElev(n, n.x, n.y), pi:0, out:true, leave:o.leave, outDur:o.outDur, backSay:o.backSay }; }
    return o;
  },
  planNext(n) {
    const d = n.d, U = (a, b) => this.U(n, a, b), [px, py, pact] = d.post;
    const atPost = Math.hypot(n.x - px, n.y - py) < 0.012;
    if (d.lane) { // 清潔安娣：沿著拖地的路線一格一格拖（拖完一格才往下一格），偶爾去換水
      n.li = (n.li || 0) + 1; if (d.tripEvery && n.li % (d.tripEvery * d.lane.length) === 0 && this.present(n) >= 3) { const tr = d.trips[0]; return this.mkStep(n, { out:true, outDur:U(...tr[3]), backSay:tr[5], sayStart:tr[4] }); }
      if (n.li % d.lane.length === 4 && this.roomOf(n) === 'pantry' && this.rng(n) < 0.6) { const st = this.restStep(n, U(8, 12), BRK.auntie, ['brk_drink', 'brk_nap']); if (st.sit) return st; }
      const p0 = d.lane[n.li % d.lane.length], p = this.freeSpot(n, p0[0], p0[1]); return { x:p[0], y:p[1], wait:U(...d.laneWait), act:'mop', arrived:false, mopWalk:true };
    }
    if (d.guard && n.tour && n.tour.length) { const p = n.tour.shift(); return { x:p[0], y:p[1], wait:U(3, 4.5), act:'look', arrived:false, path:null, pi:0 }; } // 保安巡房：一間一間行
    if (!atPost) return { x:px, y:py, wait:U(...this.workOf(n)), act:pact, arrived:false, path:(n.y < _MY(0.56) && n.x > _M(0.85)) ? [[_M(0.80), _MY(0.60)]] : null, pi:0 };
    // 崗位做完一輪：挑一件有目的的事（斟水、影印、找人、洗手間／食煙），做完回崗位
    const tr = d.trips || []; let tot = 0; for (const e of tr) tot += e[1]; let r = this.rng(n) * tot, e = tr[0];
    for (const q of tr) { r -= q[1]; if (r <= 0) { e = q; break; } }
    if (!e) return { x:px, y:py, wait:U(...this.workOf(n)), act:pact, arrived:true };
    if (e[2] === 'out') { if (this.present(n) < 2 || this.busy(n, this.exitPt()[0])) return { x:px, y:py, wait:U(4, 8), act:pact, arrived:true }; return this.mkStep(n, { out:true, outDur:U(...e[3]), backSay:e[5], sayStart:e[4] }); }
    let to = e[2];
    if (to === 'patrol') { const P = OFFMAP.PATROL; n.pt = (n.pt || 0) + 1; n.tour = n.pt % 2 ? P.slice(3) : [P[2], P[1], P[0]]; const p = n.tour.shift(); if (e[4]) this.bubble(n, e[4], 2.2); return { x:p[0], y:p[1], wait:U(3, 4.5), act:'look', arrived:false, path:null, pi:0 }; } // 一次巡兩間：茶水間＋會議室／辦公區另一邊＋老闆房
    if (to === 'rest') return this.restStep(n, U(...e[3]), e[4], e[6]);
    if (to === 'boss') { const b = this.npcs.find(m => m.d.k === 'boss' && !m.out && !m.gone && !m.fleeing); if (!b || this.roomOf(b) !== 'boss') return { x:px, y:py, wait:U(4, 8), act:pact, arrived:true }; to = _SP.bossVisit; }
    if (this.busy(n, to[0])) return { x:px, y:py, wait:U(3, 6), act:pact, arrived:true }; // 嗰邊已經有兩個人行緊：遲啲先去（唔好成堆人一齊行）
    to = this.freeSpot(n, to[0], to[1]);
    if (e[4]) this.bubble(n, e[4], 2.2);
    return { x:to[0], y:to[1], wait:U(...e[3]), act:'idle', arrived:false, path:null, pi:0 };
  },
  // 一間房同一時間最多兩個人行緊路（出發嗰間、目的地嗰間都計）
  inDoor(x) { if (!this.site.pano) return false; const W = OFFMAP.WALLS, w = OFFMAP.WALLW; return W.some(v => x >= (v - 45) / 1165 && x <= (v + w + 45) / 1165); }, // 牆／門口嗰條（左右各多 45px）
  walkBlocked(n, tx) { if (!this.site.pano) return false; const a = Math.min(n.x, tx), b = Math.max(n.x, tx);
    return OFFMAP.ROOMS.some(r => r.x1 > a && r.x0 < b + 1e-6 && this.npcs.filter(m => m !== n && !m.gone && !m.out && !m.fleeing && (m.act === 'walk' || (!m.d.post && !m.d.daoshi && m.wait < 7)) && OFFMAP.roomAt(m.x) === r).length >= 2); }, // 阿Ken（固定路線）就快起身都當佢行緊，留位俾佢
  busy(n, tx) { if (!this.site.pano) return false; const rs = [OFFMAP.roomAt(n.x), OFFMAP.roomAt(tx)];
    return rs.some(r => this.npcs.filter(m => m !== n && !m.gone && !m.out && m.act === 'walk' && OFFMAP.roomAt(m.x) === r).length >= 2); },
  // 目的地有人企緊（或者行緊去）：企開少少，唔好疊埋
  freeSpot(n, x, y) { // 前面嘅人會遮住後面嘅人：橫向要隔 0.13（唔理前後）
    const taken = (m) => { if (m === n || m.gone || m.out || m.d.daoshi) return []; const p = [[m.x, m.y]]; if (m.step && !m.step.arrived) p.push([m.step.x, m.step.y]); if (m.d.post && !m.d.guard) p.push([m.d.post[0], m.d.post[1]]); return p; };
    const occ = this.npcs.flatMap(taken); let best = [x, y];
    for (const dx of [0, 0.14, -0.14]) { const xx = x + dx; if (!occ.some(p => Math.abs(p[0] - xx) < 0.13 && Math.abs(p[1] - y) < 0.3)) { best = [xx, y]; break; } }
    return best; },
  // 陳總：叫一個人入房（佢低頭睇報告，房入面冇其他人望 = 嚇人好時機）／叫一兩個人入會議室開會
  bossCall(b, kind) {
    const cand = this.npcs.filter(m => (m.d.k === 'it' || m.d.k === 'mis') && !m.gone && !m.out && !m.fleeing && !m.leaving && !m.call && !(m.step && m.step.called) && m.fear < 50);
    if (!cand.length) return false;
    if (kind === 'callin') { const c = cand[Math.floor(this.rng(b) * cand.length)];
      this.bubble(b, `${c.d.name}，入嚟我房！`, 2.6); b.next = null; b.step = { x:b.d.post[0], y:b.d.post[1], wait:24, act:'read', arrived:Math.hypot(b.x - b.d.post[0], b.y - b.d.post[1]) < 0.012, path:null, pi:0, say:'（睇報告）企喺度等我睇完先。', called:true }; if (b.step.arrived) { b.wait = 24; this.bubble(b, b.step.say, 2.4); }
      c.call = { x:_SP.bossFront[0], y:_SP.bossFront[1], wait:14, act:'idle', delay:1.2, go:c.d.k === 'mis' ? '嚟緊喇陳總～' : '……係。', say:c.d.k === 'mis' ? '陳總～搵我呀？' : '陳總，搵我？', boss:b }; this.callT = this.t; this.callWho = c; return true; }
    const k = cand.length > 1 && this.rng(b) < 0.6 ? 2 : 1, who = cand.sort(() => this.rng(b) - 0.5).slice(0, k);
    this.bubble(b, who.length > 1 ? `${who.map(m => m.d.name).join('、')}，入會議室開會！` : `${who[0].d.name}，入會議室！`, 2.8);
    b.next = null; b.step = { x:_SP.board[0], y:_SP.board[1], wait:22, act:'present', arrived:false, path:null, pi:0, say:'（指住白板）呢季嘅數……', called:true, meet:true };
    who.forEach((c, i) => { c.call = { x:[_SP.seat1, _SP.seat2, _SP.seat3][i % 3][0], y:[_SP.seat1, _SP.seat2, _SP.seat3][i % 3][1], wait:60, act:'notes', delay:1.5 + i * 3.5, go:i ? null : '又開會……' }; });
    this.meetT = this.t; return true;
  },
  // 要走了的提示：頭上一圈倒數（橘色），「走」字
  tagExt(n) { return n === this.sel || (n.mocked > 0 && !n.d.guard) ? 16 : 0; }, // 名牌上面有冇狀態膠囊（幾多人望緊、冇人信）
  drawCue(ctx, n, x, by, t) {
    const k = Math.max(0, Math.min(1, 1 - n.wait / 3.5)), cx = x + 46, cy = by + 1, r = 9; // 恐懼條右邊（唔撞眼、名、！）
    ctx.save(); ctx.fillStyle = 'rgba(0,0,0,.55)'; ctx.beginPath(); ctx.arc(cx, cy, r + 3, 0, Math.PI * 2); ctx.fill();
    ctx.strokeStyle = '#ffb34a'; ctx.lineWidth = 3; ctx.beginPath(); ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + k * Math.PI * 2); ctx.stroke();
    ctx.font = '900 11px sans-serif'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillStyle = '#ffe2b0'; ctx.fillText('走', cx, cy + 0.5); ctx.restore();
  },
  inBeam(g, x, y) { if (g.act === 'doze') return false; if (this.site.pano && OFFMAP.roomAt(g.x) !== OFFMAP.roomAt(x)) return false; const dx = x - g.x, dy = (y - (g.y - 0.08)); if (Math.sign(dx) !== g.dir) return false; const d = Math.abs(dx); return d < 0.4 && Math.abs(dy) < 0.06 + d * 0.35; },

  // ---------- 出招 ----------
  // 全場燈／冷氣：只係鏡頭對住嗰間房（機械人冇鏡頭：用佢點中嗰個人嗰間）
  groupRoom() { if (!this.site.pano) return null; if (this.headless) return this.sel ? this.roomOf(this.sel) : 'main'; return this.camRoom().k; },
  inGroup(m, room) { return !room || this.roomOf(m) === room; },
  propOK(k, n) { const p = SCARE_PROPS[k]; if (p.group) { const rm = this.groupRoom(); return !((this.pcd || {})[k] > 0) && this.npcs.some(m => !m.gone && !m.out && !m.fleeing && !m.d.guard && this.inGroup(m, rm)); } return !!(n && !n.gone && !n.out && !n.fleeing && !n.d.guard && (p.r === 0 || Math.hypot(n.x - p.front[0], (n.y - p.front[1]) * 1.4) < p.r)); },
  // 附身家具：只嚇點中的那個人（要佢喺附近）；vis 嘅怪事如果有人望住佢，就穿崩
  useProp(k, who) {
    const p = SCARE_PROPS[k], n = who || this.sel; this.pcd = this.pcd || {};
    if (p.group) { // 全場：唔使點人
      if (this.pcd[k] > 0) { this.toast(`${p.name}冷卻中`); return; } if (this.mana < p.cost) { this.toast('陰氣不夠，等一下'); return; }
      const rm = this.groupRoom(), RR = rm && OFFMAP.RM[rm];
      if (!this.npcs.some(m => !m.gone && !m.out && !m.fleeing && !m.d.guard && this.inGroup(m, rm))) { this.toast(`${RR ? RR.name : '呢度'}冇人`); return; }
      if (RR) p.rect = [OFFMAP.npx(RR.vent[0]) - 0.06, OFFMAP.py(RR.vent[1]), 0.12, 0.02];
      this.mana -= p.cost; this.pcd[k] = p.cdT; const cx = p.rect[0] + p.rect[2] / 2, cy = p.rect[1] + p.rect[3]; this.fx.push({ kind:k, life:2.2, x:cx, y:cy, room:rm });
      if (!this.headless) { Sound.play(k === 'lights' ? 'click' : 'whoosh'); this.propParts(k, p); if (this.site.pano) OFFMAP.onProp(k, null, rm); else if (this.office()) OFFICE.onProp(k); this.float(0.5, 0.36, `${RR ? RR.name + '入面' : '全場'}一齊經歷：冇人會話邊個黐線　之後單嚇 ×${FEAR.uneasyMul}`, '#bcd4ff', 2.2); }
      const tg = this.npcs.filter(m => !m.gone && !m.out && !m.fleeing && this.inGroup(m, rm)); this._src = cx; this._dl = 0; this._group = true;
      for (const m of tg) this.hit(m, p.type, p.base, p.tier); this._group = false; this._src = null; this.expose(EXPO.group); return;
    }
    if (!n || n.gone || n.out || n.fleeing || n.d.guard) { this.toast('先點一個人'); return; }
    if (!this.propOK(k, n)) { this.toast(`${n.d.name}離${p.name}太遠`); return; }
    if (this.mana < p.cost) { this.toast('陰氣不夠，等一下'); return; }
    this.mana -= p.cost;
    const cx = p.r ? p.rect[0] + p.rect[2] / 2 : n.x, cy = p.r ? p.rect[1] + p.rect[3] : n.y - 0.2;
    this.fx.push({ kind:k, life:2.2, x:cx, y:cy, n });
    if (!this.headless) { Sound.play(k === 'printer' || k === 'vend' ? 'paper' : k === 'lamp' || k === 'drop' || k === 'trophy' ? 'hit' : k === 'water' || k === 'kettle' ? 'crow' : 'whoosh'); this.propParts(k, p, n); if (this.office()) { if (p.room && p.room !== 'main' && k !== 'printer') OFFMAP.onProp(k, n); else OFFICE.onProp(k); } }
    this._src = cx; this._dl = 0; this._vis = !!p.vis; this.hit(n, p.type, p.base, p.tier); this._src = null; this._vis = false;
  },
  usePhone(n) {
    const cost = 22; if (!n || n.gone || !n.d.phone) return; if (n.out) { this.toast(`${n.d.name}不在`); return; } if (this.mana < cost) { this.toast('陰氣不夠，等一下'); return; }
    this.mana -= cost; this.fx.push({ kind:'phone', life:1.6, n }); if (!this.headless) Sound.play('click');
    this._src = null; this._dl = 0; this._vis = false; this.hit(n, 'phone', 22, 1, null, true);
  },
  // 在背後呼氣：對一個人（像傳訊息）。冷＝冷氣同一類；頸後一團白霧、頭髮豎起、打冷顫、慢慢回頭看——後面沒有人
  useBreath(n) {
    const cost = 20; if (!n || n.gone || n.fleeing) return; if (n.out) { this.toast(`${n.d.name}不在`); return; } if (this.mana < cost) { this.toast('陰氣不夠，等一下'); return; }
    this.mana -= cost; this.fx.push({ kind:'breath', life:2.4, max:2.4, n }); if (!this.headless) Sound.play('whoosh');
    this._src = null; this._dl = 0; this._vis = false; this.hit(n, n.d.weak.includes('breath') ? 'breath' : 'cold', 24, 1, null, true); // 美美：吹她的頭髮和蝴蝶結（她自己一類，不算冷）
    if (!this.headless && n.rx && n.rx.k !== 'burst' && !n.fleeing) this.react(n, 'chill', { dur:2.4 }); // 換成「發冷、回頭」
    if (!this.headless && n.rx && n.rx.k === 'chill') { n.hair = 1.2; n.goose = 2; }
  },
  useGhost(k, n) {
    const g = SCARE_GHOSTS[k]; if (!g || this.cd[k] > 0) return; const cost = g.cost || 35;
    if (this.mana < cost) { this.toast('陰氣不夠，等一下'); return; }
    if (!g.aoe && (!n || n.gone)) { this.toast('先點一個人'); return; } if (!g.aoe && n.out) { this.toast(`${n.d.name}不在`); return; }
    this.mana -= cost; this.cd[k] = 22;
    const gx = g.aoe ? (this.site.pano ? this.camX + this.viewW() / 2 : 0.5) : n.x + (this.site.pano ? (this.pt(n.x, 0)[0] > this.W / 2 ? -0.13 : 0.13) : (n.x > 0.5 ? -0.13 : 0.13)), gy = g.aoe ? 0.45 : n.y;
    this.fx.push({ kind:'ghost', ghost:k, life:2.4, max:2.4, gx, gy, n, sig:g.fx, sigText:g.fxText, col:g.col });
    if (!this.headless) { Sound.play('skill'); this.shake = 1; this.vign = 1; if (this.office()) setTimeout(() => this.active && OFFICE.onScare(gx, gy, g.aoe ? 0.75 : 1), (g.aoe ? 0.5 : 0.9) * 1000); }
    const tg = g.aoe ? this.npcs.filter(m => !m.gone && !m.out && !m.fleeing) : [n];
    if (g.aoe && !this.headless) this.float(0.5, 0.4, g.line, '#e8c8ff', 2.2);
    this._src = gx; this._dl = g.aoe ? 0.5 : 0.9; // 鬼「出手」那一刻（strike）才嚇到人
    this._ghost = k; this._vis = true; this._aoe = !!g.aoe; for (const m of tg) this.hit(m, this.ghostType(k, m), g.base, 3, g.aoe ? null : (typeof L === 'function' ? L(g.line) : g.line), !g.aoe); this._ghost = null; this._src = null; this._dl = 0; this._vis = false; this._aoe = false;
    if (g.aoe) { this.wakeGuard(null); this.expose(EXPO.aoe); if (!this.headless) this.float(0.5, 0.33, '全場都見到：冇人會話佢哋黐線', '#c9b8ff', 2.2); }
  },
  // 混合類型嘅招（例如 燈／電話）：對住呢個人揀佢最怕嗰種
  ghostType(k, n) { const g = SCARE_GHOSTS[k], ts = g.types || [g.type]; if (!n || ts.length < 2) return ts[0]; return ts.find(t => n.d.weak.includes(t)) || ts.find(t => !n.d.immune.includes(t)) || ts[0]; },
  hit(n, type, base, tier, ghostLine, direct) {
    const d = n.d, grp = !!this._group;
    if (grp && GROUP_IMMUNE[d.k]) { this.bubble(n, GROUP_IMMUNE[d.k][type] || GROUP_IMMUNE[d.k].light, 2.4); this.float(n.x, n.y - 0.2, '慣咗，唔怕', '#9ab'); if (!this.headless) this.react(n, d.guard ? 'sip' : 'numb'); return; }
    if (d.guard) { this.bubble(n, d.say.immune, 2); this.react(n, 'sip'); if (direct && !this.guardKarma) { this.guardKarma = true; this.addKarma(d, -1, '嚇保安阿伯：他倒了一杯茶給你。'); } return; }
    if (d.backfire && d.backfire[type]) { this.kpi = Math.max(0, this.kpi - 15); this.bubble(n, d.backfire[type], 2.4); this.float(n.x, n.y - 0.2, '好評 -15', '#ff8a7a'); return; }
    const w = d.weak.includes(type), im = d.immune.includes(type);
    n.hab = n.hab || {}; const hab = n.hab[type] || 0; n.hab[type] = hab + 1;
    const sh = (n.shaken || 0) > 0; // 心有餘悸：小事都嚇到、大招一定接得上
    if (im) { // 唔怕：完全冇效＋一句不屑
      this.known = this.known || {}; (this.known[d.k] = this.known[d.k] || new Set()).add(type);
      const L = (d.imm && d.imm[type]) || d.say.immune; this.bubble(n, L, 2.4); this.float(n.x, n.y - 0.2, `${FEAR_WORD[type] || type}？唔怕！`, '#9ab', 1.6); if (!this.headless) this.react(n, 'rational', { delay:this._dl || 0 });
      if (this._vis && !this._aoe && !grp && this.witnesses(n).length) this.expose(EXPO.seen / 2, n); return; }
    this.known = this.known || {}; const KS = (this.known[d.k] = this.known[d.k] || new Set()); if (!KS.has(type)) { KS.add(type); if (!this.headless && n === this.sel && w) { this.renderTarget(); this.float(n.x, n.y - 0.34, `發現：${d.name}怕${FEAR_WORD[type]}！`, '#ffb070', 1.8); } }
    let m = (w ? (tier < 3 ? FEAR.weakSmall : 2) : tier < 3 ? FEAR_MID.small : FEAR_MID.big) * Math.max(FEAR.habMin, Math.pow(FEAR.habMul, hab)) * (tier < 3 ? FEAR.gain : 1) * (sh ? FEAR.shakenMul : 1) / (1 + FEAR.spread * Math.max(0, (this._nt || 1) - 1)), rational = false, burst = false;
    const before = n.fear;
    if (tier === 3) { if (before < 25 && !sh) { m *= 0.45; rational = true; } else if (before < 50) m *= 1.35; else { m *= FEAR.burstMul; burst = true; } }
    const combo = this.t - (n.comboT == null ? -99 : n.comboT) < FEAR.combo ? Math.min(4, (n.combo || 0) + 1) : 0; // 連擊：上一下有嚇到（恐懼 +6 以上）才算接得上
    if (!im && !rational) m *= 1 + Math.min(FEAR.comboMax, combo * FEAR.comboStep);
    const g = this.npcs.find(x => x.d.guard && !x.gone && !x.out), aoe = !!this._aoe;
    const wits = aoe || grp ? [] : this.witnesses(n), seen = !aoe && !grp && this._vis && wits.length > 0, alone = !aoe && !this.hearers(n).some(x => !x.d.guard), mk = Math.min(4, n.mocked || 0);
    m *= (aoe ? FEAR.aoeMul : 1) * (grp ? FEAR.groupMul : (n.uneasy > 0 ? FEAR.uneasyMul : 1)) * (seen ? FEAR.seenMul : 1) * (alone && !grp ? FEAR.alone : 1) * (1 + (grp ? 0 : FEAR.mockMul * mk));
    if (grp) n.uneasy = FEAR.uneasy;
    let pts = Math.round(base * m);
    const cap = sh ? FEAR.shakenCap : w ? FEAR.smallCap : FEAR.plainCap;
    if (tier < 3) pts = Math.max(0, Math.round(Math.min(pts, cap - before))); // 小動靜最多嚇到「！」剛剛好（心有餘悸再高一點），大招才嚇得跑
    n.fear += pts; n.bounce = pts > 0 ? 1 : 0.3; n.barHit = pts > 0 ? 1 : 0;
    if (pts >= 6 && !rational) { n.combo = combo; n.comboT = this.t; } else n.combo = 0;
    const oldPeak = Math.min(100, n.peak); n.peak = Math.max(n.peak, n.fear); let gain = Math.round(Math.min(100, n.peak) - oldPeak);
    const clean = burst && pts >= 20 && !seen && !aoe && !grp; // 爆點分只俾「冇人望到」嘅單挑
    if (clean) gain += FEAR.burstBonus;
    if (clean && combo >= 1) gain += FEAR.comboPts * 2 * combo; // 連擊收尾：鋪墊接大招接得越密，爆點分越多
    if (clean && mk >= 2) { const b = FEAR.noBelieve * mk; gain += b; this.float(n.x, n.y - 0.34, `無人信佢！+${b}`, '#d08cff', 2); }
    this.kpi += gain; this._hab = hab;
    if (typeof ScareX !== 'undefined') ScareX.onHit(this, n, { type, pts, gain, clean, mk, alone, seen, burst, tier, ghost:this._ghost || 'afu' });
    if (rational && !this._aoe) this.expose(EXPO.blatant, n); // 未鋪墊就出大招：太明目張膽
    if (d.daoshi && pts > 0) { n.prog = Math.max(0, (n.prog || 0) - pts / 100 * 0.5); if (!this.headless) this.float(n.x, n.y - 0.34, '做法被打斷！', '#ffd36a', 1.4); }
    if (!grp) this.perceive(n, pts, rational, seen, wits, aoe, alone); // 全場一齊經歷：冇人笑佢，亦唔會穿崩
    const line = rational ? pick(d.say.rational) : w && (type === 'phone' || type === 'paper' || tier === 3) ? d.say.weak : n.fear >= 50 ? pick(d.say.hit) : pts > 0 ? pick(d.say.prime) : '（習慣了）';
    if (ghostLine && !rational) this.bubble(n, ghostLine, 1.2, true);
    if (this.headless) this.bubble(n, line, 2.2); else setTimeout(() => this.bubble(n, line, 2.2), (this._dl || 0) * 1000);
    const tag = seen ? '　穿崩！' : burst && pts >= 20 && aoe ? '　（全場都見到）' : burst && pts >= 20 ? '　爆點！' : rational ? '　還沒鋪墊' : tier < 3 && before >= cap ? '　小動靜不夠，出大招！' : hab >= 2 ? '　有點習慣了' : w ? '　怕！' : im ? '　不怕' : sh ? '　餘悸未消' : '';
    this.float(n.x, n.y - 0.2, `${pts > 0 ? '恐懼 +' + pts : '沒反應'}${tag}`, burst ? '#ff9a5a' : w ? '#ffb070' : gain > 0 ? '#ffe08a' : '#9ab');
    if (combo >= 1 && pts >= 6 && !rational) this.float(n.x, n.y - 0.27, `連擊 ×${combo + 1}`, '#ff7ad0', 1.4);
    if (!this.headless && pts >= 12) setTimeout(() => { this.shake = Math.max(this.shake, Math.min(0.7, pts / 60)); }, (this._dl || 0) * 1000);
    if (!this.headless && n.fear >= 25) for (let i = 0; i < 3; i++) this.parts.push({ kind:'sweat', x:n.x + (Math.random() - 0.5) * 0.05, y:n.y - 0.17, vx:(Math.random() - 0.5) * 0.08, vy:-0.1, g:0.5, life:0.8, delay:this._dl || 0 });
    if (g && this.sameRoom(g, n) && Math.hypot(g.x - n.x, g.y - n.y) < 0.24 && pts > 15) { n.fear = Math.max(0, n.fear - FEAR.guardCalm); const say = () => this.bubble(g, g.d.say.calmOther, 2); if (this.headless) say(); else { setTimeout(say, 600 + (this._dl || 0) * 1000); this.react(g, 'sip', { delay:0.6 + (this._dl || 0), dur:2.8 }); } this.float(g.x, g.y - 0.22, '阿伯在旁邊壯膽', '#9ad'); }
    // 表情、動作（只是畫面）
    if (!this.headless) {
      const k = n.fear >= 100 || (burst && pts >= 20) ? 'burst' : im || pts <= 0 ? 'numb' : rational ? 'rational' : tier === 3 ? 'startle' : w ? 'weakjump' : n.fear >= 50 ? 'startle' : 'flinch';
      if (w && pts > 0 && !rational) { setTimeout(() => { n.scream = Math.max(n.scream || 0, 1.1); this.shake = Math.max(this.shake, 0.5); }, (this._dl || 0) * 1000); } // 戳中弱點：彈起、尖叫、條恐懼條衝上去
      this.react(n, k, { delay:this._dl || 0, src:this._src, big:tier === 3 });
      if (k === 'burst') setTimeout(() => { this.shake = Math.max(this.shake, 0.9); }, (this._dl || 0) * 1000);
    }
    if (n.fear >= 100 && !n.fleeing) { n.fleeing = true; this.kpi += 120; this.float(n.x, n.y - 0.3, '嚇跑了！+120', '#ff6a5a', 2); this.addKarma(d, d.karma, d.say.flee); if (!this.headless) { Sound.play('heartbeat'); this.shake = 0.6; n.fleeT = this.t; n.fleeHold = (this._dl || 0) + 0.4; n.trail = [[this.t, n.x, n.y]]; setTimeout(() => this.bubble(n, d.say.shout || '哇啊啊啊——！', 2), 1200); } }
  },
  // ---------- 旁人：邊個望緊、邊個聽到 ----------
  rnd(n) { return n._seed != null ? this.rng(n) : Math.random(); },
  headsDown(m) { const a = m.act; if (a === 'work' || a === 'mop' || a === 'doze' || a === 'pack' || a === 'read' || a === 'notes' || a === 'present') return true; const p = m.d.post; return !!(p && a === p[2] && Math.hypot(m.x - p[0], m.y - p[1]) < 0.015); },
  watching(m) { if (m.gone || m.out || m.fleeing) return false; if (m.d.guard) return m.act !== 'doze'; if (m.d.influencer) return true; /* 靈探 KOL：一直舉住手機拍 */ return m.act === 'walk' || (m.lookUp || 0) > 0 || m.fear >= 25 || !this.headsDown(m); }, // 低頭做嘢＝睇唔到；行緊路、抬頭、驚緊＝四圍望
  sees(m, n) { if (m === n || !this.watching(m) || !this.sameRoom(m, n)) return false; const dx = n.x - m.x; if (Math.hypot(dx, (n.y - m.y) * 1.3) > SEE_DIST) return false; return (m.act === 'walk' || m.d.guard) ? dx * m.dir >= -0.03 : true; },
  witnesses(n) { return this.npcs.filter(m => this.sees(m, n)); },
  hearers(n) { return this.npcs.filter(m => m !== n && !m.gone && !m.out && !m.fleeing && this.sameRoom(m, n) && Math.hypot(m.x - n.x, m.y - n.y) < 0.75); }, // 隔咗間房就聽唔到
  wakeGuard(n) { const g = this.npcs.find(x => x.d.guard && !x.gone && !x.out); if (!g) return; if (g.act === 'doze') this.bubble(g, '（醒咗）咩事？', 2);
    if (n) { g.tour = null; g.step = { x:Math.max(0.1, Math.min((this.site.pano ? OFFMAP.WW : 1) - 0.1, n.x + (n.x > g.x ? -0.12 : 0.12))), y:Math.max(0.66, Math.min(0.93, n.y + 0.02)), wait:6, act:'look', arrived:false, path:null, pi:0 }; g.next = null; } else if (g.act === 'doze') { g.step = null; } },
  // 嚇完：有人望到怪事 → 穿崩；冇人望到 → 其他人只見到佢發神經，笑佢（佢更驚，冇人信佢）
  perceive(n, pts, rational, seen, wits, aoe, alone) {
    const later = (f, s) => { if (this.headless) f(); else setTimeout(() => this.active && f(), ((this._dl || 0) + (s || 0)) * 1000); };
    if (aoe) { n.mocked = 0; return; }
    if (seen) {
      n.mocked = 0; this.kpi = Math.max(0, this.kpi - FEAR.seenPen); const w0 = wits[0]; if (this.night) { this.night.seen++; if (wits.some(w => w.d.influencer)) this.night.filmed++; }
      this.expose(EXPO.seen + EXPO.perWit * (wits.length - 1) + ((this._hab || 0) >= 1 ? EXPO.repeat : 0), n);
      this.float(n.x, n.y - 0.3, `穿崩！${wits.map(w => w.d.name).join('、')}望到 −${FEAR.seenPen}`, '#ff8a7a', 2);
      for (const w of wits) { if (w.d.guard) continue; w.fear = Math.max(w.fear, Math.min(99, w.fear + FEAR.witFear)); w.peak = Math.max(w.peak, w.fear); later(() => this.bubble(w, pick(WIT_SAY), 2), 0.5); if (!this.headless) this.react(w, 'startle', { delay:(this._dl || 0) + 0.4, src:n.x }); }
      if (w0) this.wakeGuard(n);
      return;
    }
    if (pts < 8 || rational || n.fleeing || n.fear >= 100) return; // 嚇到要走嘅人唔使再笑
    const mk = this.hearers(n).filter(m => !m.d.guard && !(m.fear >= 50)).sort((a, b) => Math.hypot(a.x - n.x, a.y - n.y) - Math.hypot(b.x - n.x, b.y - n.y)).slice(0, 2);
    if (!mk.length) { if (alone) this.float(n.x, n.y - 0.27, '冇人喺度 ×1.2', '#9fe0c0', 1.4); return; }
    n.mocked = Math.min(5, (n.mocked || 0) + 1); n.fear = Math.max(n.fear, Math.min(99, n.fear + FEAR.mockFear)); n.peak = Math.max(n.peak, n.fear); this.kpi += FEAR.mockPts;
    mk.forEach((m, i) => later(() => { const L = MOCK_SAY[m.d.k]; this.bubble(m, L ? pick(L) : '你又發乜神經？', 2.4); if (m.mis && m.d.k === 'mis') Object.assign(m.mis, { act:'roll', at:0, dur:1.8 }); m.dir = n.x > m.x ? 1 : -1; }, 1 + i * 0.7));
    if (n.mocked >= 2) later(() => { if (!n.fleeing) this.bubble(n, pick(PARA_SAY), 2.2); }, 2.6);
  },
  // ---------- 穿崩度 → 有人起疑 → 請道士 ----------
  expose(v, n) {
    if (!v || this.expelled) return; if (n && this.site.pano) this.expoRoom = this.roomOf(n); this.expo = Math.min(100, (this.expo || 0) + v); this.expoT = this.t; this.expoMax = Math.max(this.expoMax || 0, this.expo);
    if (!this.headless && v >= 5) this.float(0.2, 0.06, `穿崩度 +${Math.round(v)}`, '#ff9a7a', 1.4);
    if (this.expo >= EXPO.sus && !this.alert) { this.alert = true; const m = this.npcs.find(x => !x.gone && !x.out && !x.fleeing && !x.d.guard && !x.d.daoshi); if (m) this.bubble(m, '呢度……係咪有嘢？', 2.4); const g = this.npcs.find(x => x.d.guard && !x.gone); if (g) { this.bubble(g, '我行多幾轉睇睇。', 2.2); this.wakeGuard(null); } }
    if (this.expo >= (this.daoAt || EXPO.call) && !this.daoCall) { const c = this.npcs.find(x => (x.d.k === 'mis' || x.d.k === 'boss') && !x.gone && !x.out && !x.fleeing) || this.npcs.find(x => !x.gone && !x.out && !x.fleeing && !x.d.guard);
      if (c) { this.daoCall = this.t; this.bubble(c, c.d.k === 'boss' ? '喂？林師傅？即刻上嚟二十三樓！' : '喂～林師傅呀？二十三樓好似有嘢……', 3); if (!this.headless) this.float(0.5, 0.3, `${c.d.name}打電話請咗道士！`, '#ffcf6a', 2.6); } }
  },
  workOf(n) { return n.d.guard && this.alert ? [12, 18] : n.d.work; }, // 起疑之後保安巡多啲
  expoTick(dt) {
    const dao = this.npcs.find(x => x.d.daoshi && !x.gone && !x.out && !x.fleeing), quiet = this.t - (this.expoT || -99) > 5;
    this.expo = Math.max(0, (this.expo || 0) - (dao && quiet ? EXPO.lowDecay : EXPO.decay) * dt);
    if (this.daoCall && !this.daoIn && this.t - this.daoCall > (this.daoDelay || 7)) { // 道士搭電梯上嚟
      this.daoIn = true; const [ex, ey] = this.exitPt(); const n = { d:DAOSHI, x:ex, y:ey, wi:0, wait:0, dir:-1, fear:0, peak:0, gone:false, exitT:0, bounce:0, look:0, bub:null, bubT:0, act:'walk', ph:0, prog:0, ds:'in', inAt:this.t };
      this.npcs.push(n); this.elevator(); this.bubble(n, '邊度有嘢？等我睇睇。', 2.6);
    }
  },
  daoTick(n, dt) {
    if (!n.spot) { const r = this.site.pano && this.expoRoom && this.expoRoom !== 'main' ? OFFMAP.RM[this.expoRoom] : null; n.spot = r ? [r.cx, 0.86] : this.site.pano ? [_M(0.66), _MY(0.90)] : [0.66, 0.90]; n.spotRoom = r ? r.name : null; if (r) this.bubble(n, `${r.name}？帶路。`, 2.4); } // 喺穿崩嗰間房做法（冇就喺辦公區）
    const spot = n.spot;
    if (n.ds === 'in') { const dx = spot[0] - n.x, dy = spot[1] - n.y, d = Math.hypot(dx, dy), sp = n.d.speed * dt; n.act = 'walk'; n.dir = dx >= 0 ? 1 : -1;
      if (d <= sp) { n.x = spot[0]; n.y = spot[1]; n.ds = 'ritual'; n.rT = 0; n.act = 'ritual'; this.bubble(n, '（搖鈴）各位，借個位。', 2.4); } else { n.x += dx / d * sp; n.y += dy / d * sp; } return; }
    if (n.ds === 'ritual') {
      n.act = 'ritual'; n.rT += dt; const startled = n.fear >= 50;
      if (!startled) n.prog = Math.min(1, (n.prog || 0) + dt / EXPO.ritual * (this.expo >= 25 ? 1 : 0.4));
      n.lt = (n.lt == null ? 5 : n.lt) - dt; if (n.lt <= 0 && !n.bub) { n.lt = 6 + Math.random() * 4; this.bubble(n, startled ? '（執返個鈴）冇嘢，冇嘢……' : pick(n.d.lines), 2.4); }
      if (n.prog >= 1) { this.expelled = true; this.bubble(n, '（符紙一貼）收工！', 2.6); if (!this.headless) this.float(0.5, 0.35, '阿福被請走了……', '#ffcf6a', 3); this.endAt = this.endAt || this.t; return; }
      if (this.expo < EXPO.giveUp && n.rT > 10) { n.ds = 'out'; this.bubble(n, '冇嘢喎……今晚收你半價。', 2.8); if (!this.headless) this.float(0.5, 0.35, '道士放棄了', '#9fe0c0', 2.2); }
      return; }
    if (n.ds === 'out') { const [ex, ey] = this.exitPt(), dx = ex - n.x, dy = ey - n.y, d = Math.hypot(dx, dy), sp = n.d.speed * 1.2 * dt; n.act = 'walk'; n.dir = dx >= 0 ? 1 : -1;
      if (d <= sp) { this.goOut(n, 0, true); n.left = true; } else { n.x += dx / d * sp; n.y += dy / d * sp; } }
  },
  // 心有餘悸的人：遠處一點聲（附身家具、電梯「叮」）都會彈起（不算習慣，只加一點點）
  jumpy(skip, room) {
    for (const n of this.npcs) { if (n.gone || n.out || n.fleeing || n.d.guard || !(n.shaken > 0) || (skip && skip.includes(n)) || (room && this.site.pano && this.roomOf(n) !== room)) continue;
      const before = Math.min(100, n.peak); n.fear = Math.min(99, n.fear + 5); n.peak = Math.max(n.peak, n.fear); this.kpi += Math.round(Math.min(100, n.peak) - before);
      if (!this.headless) { this.react(n, 'flinch'); n.barHit = 0.6; if (Math.random() < 0.5) this.bubble(n, pick(JUMPY_SAY), 1.4); } }
  },
  addKarma(d, v, why) { if (v) this.karma.push({ v, who:d.name, why }); },

  // ---------- 點擊 ----------
  tap(e) {
    if (this.paused || this.endAt) return;
    const r = $('#sc-cvs').getBoundingClientRect(), mx = e.clientX - r.left, my = e.clientY - r.top;
    if (this._edge && mx > this._edge[0] && mx < this._edge[0] + this._edge[2] && my > this._edge[1] && my < this._edge[1] + this._edge[3]) { const n = this._edge[4]; this.camTo = this.clampCam(n.x - this.viewW() / 2); this.userPan = -99; return; }
    // 先看有沒有點到人
    let best = null, bd = 1e9;
    for (const n of this.npcs) { if (n.gone || n.out) continue; const [x, y] = this.pt(n.x + (this.office() ? OFFICE.kenOff(n) : 0), n.y), hh = this.hh(n.y); if (mx > x - hh * 0.32 && mx < x + hh * 0.32 && my > y - hh && my < y + 6) { const dd = Math.abs(mx - x) + Math.abs(my - (y - hh / 2)) * 0.3; if (dd < bd) { bd = dd; best = n; } } }
    if (this.armed && best) { const k = this.armed; this.armed = null; this.useGhost(k, best); this.sel = best; this.selAuto = false; this.renderDock(); this.renderTarget(); return; }
    if (best) { this.sel = best; this.selAuto = false; this.renderTarget(); return; }
    // 再看有沒有點到物件
    for (const k in SCARE_PROPS) { if (SCARE_PROPS[k].group) continue; const p = SCARE_PROPS[k], [x1, y1] = this.pt(p.rect[0], p.rect[1]), [x2, y2] = this.pt(p.rect[0] + p.rect[2], p.rect[1] + p.rect[3]); if (mx > x1 - 10 && mx < x2 + 10 && my > y1 - 10 && my < y2 + 10) { this.useProp(k); return; } }
    if (this.armed) { const g = SCARE_GHOSTS[this.armed]; if (g.aoe) { const k = this.armed; this.armed = null; this.useGhost(k); this.renderDock(); } }
  },
  renderDock() {
    const room = `<div style="display:flex;flex-direction:column;gap:5px;flex:0 0 76px">${['lights', 'ac'].map(k => `<button class="btn sm sc-room" data-p="${k}" style="padding:5px 2px;font-size:12px;line-height:1.25;width:100%"><b>${SCARE_PROPS[k].name}</b><br><small>${this.site.pano ? '呢間房' : '全場'}・${SCARE_PROPS[k].cost}</small></button>`).join('')}</div>`;
    $('#sc-dock').innerHTML = room + this.team.map(k => { const g = SCARE_GHOSTS[k], c = this.caught[k]; return `<button class="sc-gb ${this.armed === k ? 'arm' : ''} ${c ? 'caught' : ''}" data-k="${k}"><canvas data-por="${k}"></canvas><i class="cd"></i><b>${g.skill}</b><small>${c ? '喝茶中' : g.name + '・' + (g.types || [g.type]).map(t => FEAR_WORD[t] ? FEAR_WORD[t].slice(-2) : t).join('／') + (g.aoe ? '・全場' : '')}</small></button>`; }).join('');
    paintPortraits($('#sc-dock'));
    $('#sc-dock').querySelectorAll('.sc-room').forEach(b => b.onclick = () => { if (this.paused || this.endAt) return; this.useProp(b.dataset.p); });
    $('#sc-dock').querySelectorAll('.sc-gb').forEach(b => b.onclick = () => {
      const k = b.dataset.k; if (this.caught[k] || this.cd[k] > 0 || this.paused || this.endAt) return;
      const g = SCARE_GHOSTS[k];
      if (g.aoe) { this.useGhost(k); this.armed = null; }
      else if (this.sel && !this.sel.gone && !this.sel.out && !this.sel.d.guard) { this.useGhost(k, this.sel); this.armed = null; }
      else { this.armed = this.armed === k ? null : k; this.toast('點一個人'); }
      this.renderDock();
    });
  },
  renderTarget() {
    const n = this.sel && !this.sel.gone && !this.sel.fleeing ? this.sel : null, off = n && n.out ? 'disabled' : ''; this._selOut = !!(n && n.out);
    $('#sc-target').innerHTML = n ? `<div class="sc-who"><b>${n.d.name}</b><small>${n.out ? (n.left ? '已經走了' : '暫時不在') : n.d.role}</small>${n.d.phone ? `<button class="btn sm" id="sc-peek">偷看手機</button><button class="btn sm gold" id="sc-wa" ${off}>傳訊息</button>` : ''}<button class="btn sm gold" id="sc-br" ${off}>背後呼氣</button></div><div class="sc-prof" style="font-size:13px;line-height:1.5;padding:4px 2px 2px;opacity:.95">${this.profile(n)}</div>` : '<div class="sc-who"><small>點場景裡的人，或發光的東西。</small></div>';
    if (n && n.d.phone) { $('#sc-peek').onclick = () => this.peek(n); $('#sc-wa').onclick = () => this.usePhone(n); }
    if (n) $('#sc-br').onclick = () => this.useBreath(n);
  },
  // 人物卡：怕／唔怕。hide 入面嘅弱點一開始係「？」，偷看手機或者試中咗先知
  profile(n) {
    const d = n.d; if (d.guard) return '怕：<b>乜都唔怕</b>（做咗三十年夜班）';
    const K = (this.known && this.known[d.k]) || new Set(), hid = d.hide || [], w = d.weak.map(t => (hid.includes(t) && !K.has(t)) ? '？' : FEAR_WORD[t]);
    return `怕：<b style="color:#ffb070">${w.join('、')}</b>　唔怕：<b style="color:#9ab">${d.immune.map(t => FEAR_WORD[t]).join('、') || '—'}</b>${GROUP_IMMUNE[d.k] ? '（全場燈／冷氣都唔怕）' : ''}`;
  },
  peek(n) {
    this.known = this.known || {}; const K = this.known[n.d.k] = this.known[n.d.k] || new Set(); (n.d.hide || []).forEach(t => K.add(t)); this.renderTarget(); // 睇佢手機：知道佢怕咩
    this.paused = true;
    const p = $('#sc-phone');
    p.innerHTML = `<div class="sc-ph"><div class="sc-ph-h">${n.d.name} 的手機<button id="sc-ph-x">✕</button></div><div class="sc-ph-b">${n.d.chat.map(m => `<div class="sc-m ${m[0] === n.d.name ? 'me' : ''}"><i>${m[0]}・${m[1]}</i>${m[2]}</div>`).join('')}</div><div class="sc-ph-f">偷看的時候，時間是停的。</div></div>`;
    p.classList.add('on'); $('#sc-ph-x').onclick = () => { p.classList.remove('on'); this.paused = false; this.last = performance.now(); };
  },
  hud() {
    if (this.sel && (this.sel.gone || this.sel.fleeing || (this.sel.left && this.sel.out))) { const vis = (n) => this.onScreen(n.vX != null ? n.vX : n.x, 0); const ok = this.npcs.filter(n => !n.gone && !n.out && !n.fleeing && !n.d.guard); this.sel = ok.find(vis) || ok[0] || null; this.selAuto = true; this.renderTarget(); } // 自動改選：優先揀畫面入面嘅人，而且鏡頭唔跟（等玩家自己點）
    else if (this.sel && !!this.sel.out !== !!this._selOut) this.renderTarget(); // 他剛走開／回來：按鈕變灰／恢復
    const mins = Math.min(360, Math.floor(this.t / NIGHT_SEC * 360)), hh = String(Math.floor(mins / 60)).padStart(2, '0'), mm = String(Math.floor(mins % 60 / 10) * 10).padStart(2, '0');
    $('#sc-clock').textContent = `${hh}:${mm}`; $('#sc-kpi').textContent = `驚嚇 ${this.kpi}`;
    $('#sc-mana i').style.width = this.mana + '%'; if (this.site.pano) OFFMAP.mapTick(this);
    $('#sc-dock').querySelectorAll('.sc-room').forEach(b => { const k = b.dataset.p, c = (this.pcd || {})[k] || 0; b.querySelector('small').textContent = c > 0 ? `冷卻 ${Math.ceil(c)} 秒` : `${this.site.pano ? this.camRoom().name : '全場'}・${SCARE_PROPS[k].cost}`; b.style.opacity = c > 0 || this.mana < SCARE_PROPS[k].cost ? 0.5 : 1; });
    $('#sc-dock').querySelectorAll('.sc-gb').forEach(b => { const k = b.dataset.k, c = this.cd[k]; b.classList.toggle('cool', c > 0 && !this.caught[k]); b.querySelector('.cd').style.height = (this.caught[k] ? 100 : c / 22 * 100) + '%'; b.classList.toggle('low', this.mana < ((SCARE_GHOSTS[k] || {}).cost || 35)); });
  },
  bubble(n, text, dur, ghost) { if (!n || !text) return;
    if (!this.headless && !(n.bub && n.bubT > 0)) { // 畫面最多兩個對白框，其餘排隊（同一個人講就直接換）
      const live = this.npcs.filter(m => m !== n && m.bub && m.bubT > 0 && !m.gone).length;
      if (live >= 2) { this.bq = (this.bq || []).filter(q => q.n !== n); this.bq.push({ n, text, dur, ghost, at:this.t }); if (this.bq.length > 3) this.bq.shift(); return; } }
    n.bub = text; n.bubT = dur || 2; n.bubG = !!ghost; n.bubAt = this.t; },
  // 提示字（恐懼 +N、連擊、發現…）：一次一條，排隊喺畫面上方中間嗰條固定位置出
  floatTick(dt) { this.floats = this.floats.filter(f => (f.life -= dt) > 0.02); // 淡到差唔多冇就即刻收走
    if (!this.floats.length && this.fq && this.fq.length) { const f = this.fq.shift(); f.life = f.max = this.fq.length ? 0.9 : f.max; this.floats.push(f); } },
  float(x, y, text, color, life) { if (this.headless) return; this.fq = this.fq || []; this.fq.push({ text, color, life:Math.min(1.6, life || 1.3), max:Math.min(1.6, life || 1.3) }); if (this.fq.length > 3) this.fq.shift(); },
  floatOld(x, y, text, color, life) { this.floats.push({ x, y, text, color, life:life || 1.6, max:life || 1.6 }); },
  toast(t) { if (!this.headless) this.float(0.5, 0.5, t, '#fff', 1.2); },
  dust(n) { if (n.fleeT && this.t - n.fleeT < n.fleeHold) return; const x = n.vX != null ? n.vX : n.x, y = n.vY != null ? n.vY : n.y; this.parts.push({ kind:'dust', x:x - n.dir * 0.03, y, vx:-n.dir * 0.05, vy:-0.03, life:0.6 }); },
  propParts(k, p, n) {
    const cx = p.rect[0] + p.rect[2] / 2, cy = p.rect[1] + p.rect[3] / 2;
    if (k === 'printer' && !this.office()) for (let i = 0; i < 14; i++) this.parts.push({ kind:'paper', x:cx, y:cy, vx:(Math.random() - 0.7) * 0.35, vy:-0.15 - Math.random() * 0.25, g:0.35, vr:(Math.random() - 0.5) * 9, life:1.6 + Math.random() });
    if (k === 'ac' && !n) for (let i = 0; i < 26; i++) this.parts.push({ kind:'frost', x:p.rect[0] + Math.random() * p.rect[2], y:p.rect[1] + p.rect[3], vx:(Math.random() - 0.5) * 0.06, vy:0.05 + Math.random() * 0.12, life:2 + Math.random() });
    if (k === 'ac' && n) for (let i = 0; i < 22; i++) { const hy = n ? n.y - this.hhF(n.y) * 1.05 : p.rect[1] + p.rect[3]; this.parts.push({ kind:'frost', x:(n ? n.x : cx) + (Math.random() - 0.5) * 0.09, y:hy - Math.random() * 0.03, vx:(Math.random() - 0.5) * 0.04, vy:0.03 + Math.random() * 0.06, life:1.6 + Math.random(), delay:Math.random() * 0.6 }); } // 冷風只吹佢一個：頭頂飄霜
    if (k === 'water') for (let i = 0; i < 10; i++) this.parts.push({ kind:'bubble', x:cx + (Math.random() - 0.5) * 0.04, y:cy + 0.05, vx:0, vy:-0.04 - Math.random() * 0.05, life:1.2 + Math.random() });
  },

  // ---------- 畫面 ----------
  draw(t) {
    const c = $('#sc-cvs'); if (!c) return; const ctx = c.getContext('2d'); ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
    const b = this.bgScale(), img = SPR['bg_' + this.site.bg], W = this.W, H = this.H;
    ctx.save();
    if (this.shake > 0) ctx.translate((Math.random() - 0.5) * 10 * this.shake, (Math.random() - 0.5) * 8 * this.shake);
    ctx.fillStyle = '#0d0b10'; ctx.fillRect(-20, -20, W + 40, H + 40);
    const OF = this.office();
    if (OF) OFFICE.drawBack(ctx, t); // 空辦公室＋牆上的鐘、燈管、冷氣
    else if (img && img.complete) ctx.drawImage(img, b.ox, b.oy, b.iw * b.s, b.ih * b.s);
    // 夜色
    ctx.fillStyle = `rgba(12,10,34,${(OF ? 0.12 : 0.22) + 0.1 * Math.sin(this.t / NIGHT_SEC * Math.PI)})`; ctx.fillRect(0, 0, W, H);
    // 窗外的鬼（Pontianak）：在家具和人後面，只在玻璃裡看得到
    if (OF) for (const f of this.fx) if (f.kind === 'ghost' && f.ghost === 'pontianak') { ctx.save(); OFFICE.clipWindow(ctx); this.drawGhost(ctx, f, t); ctx.restore(); }
    if (OF) OFFICE.drawFloor(ctx, t);
    // 可附身的東西：呼吸光圈（辦公室：家具是立體的，框和字要畫在家具上面，見下面 propMarks）
    if (!OF) this.propMarks(ctx, t);
    // 保安的手電筒光
    const g = this.npcs.find(n => n.d.guard && !n.gone && !n.out && n.act !== 'doze'); // 打瞌睡：手電筒關了
    if (g) { const [gx, gy0] = this.pt(g.x, g.y), gy = this.persp() ? gy0 - this.hh(g.y) * 0.5 : this.pt(g.x, g.y - 0.08)[1], [ex] = this.pt(g.x + g.dir * 0.4, 0), len = Math.abs(ex - gx);
      const grd = ctx.createLinearGradient(gx, 0, ex, 0); grd.addColorStop(0, 'rgba(255,240,170,.42)'); grd.addColorStop(1, 'rgba(255,240,170,0)');
      ctx.fillStyle = grd; ctx.beginPath(); ctx.moveTo(gx, gy); ctx.lineTo(ex, gy - len * 0.35 - 8); ctx.lineTo(ex, gy + len * 0.35 + 8); ctx.closePath(); ctx.fill(); }
    // 物件特效（在人後面的）
    for (const f of this.fx) {
      if (f.kind === 'ac' && !f.n && !this.site.pano) { ctx.fillStyle = `rgba(150,200,255,${0.16 * f.life / 2.2})`; ctx.fillRect(0, 0, W, H); } // 全場冷氣
      if ((f.kind === 'lamp' || f.kind === 'lights' || f.kind === 'ac') && f.n && !f.n.gone) { // 只係佢身邊：頭頂盞燈閃、檯燈閃、一陣冷風（其他人嗰邊照舊）
        const [x, y] = this.pt(f.n.x, f.n.y), hh = this.hh(f.n.y), r = hh * 0.9;
        if (f.kind === 'ac') { const g = ctx.createRadialGradient(x, y - hh * 0.6, 0, x, y - hh * 0.6, r); g.addColorStop(0, `rgba(170,215,255,${0.32 * f.life / 2.2})`); g.addColorStop(1, 'rgba(170,215,255,0)'); ctx.fillStyle = g; ctx.fillRect(x - r, y - hh * 0.6 - r, r * 2, r * 2); }
        else { const on = Math.sin(t * 38) + Math.sin(t * 17) > 0.4; const g = ctx.createRadialGradient(x, y - hh * 0.5, 0, x, y - hh * 0.5, r * 1.1); g.addColorStop(0, on ? 'rgba(255,245,200,.22)' : 'rgba(0,0,0,.55)'); g.addColorStop(1, 'rgba(0,0,0,0)'); ctx.fillStyle = g; ctx.fillRect(x - r * 1.1, y - hh * 0.5 - r * 1.1, r * 2.2, r * 2.2);
          if (f.kind === 'lights') { const [cx0, cy0] = this.pt(f.n.x, 0.17); ctx.strokeStyle = on ? 'rgba(255,250,215,.9)' : 'rgba(90,90,110,.6)'; ctx.lineWidth = 4; ctx.beginPath(); ctx.moveTo(cx0 - hh * 0.3, cy0); ctx.lineTo(cx0 + hh * 0.3, cy0); ctx.stroke();
            if (on) { const g2 = ctx.createLinearGradient(0, cy0, 0, y); g2.addColorStop(0, 'rgba(255,250,215,.18)'); g2.addColorStop(1, 'rgba(255,250,215,0)'); ctx.fillStyle = g2; ctx.beginPath(); ctx.moveTo(cx0 - hh * 0.3, cy0); ctx.lineTo(cx0 + hh * 0.3, cy0); ctx.lineTo(x + hh * 0.5, y); ctx.lineTo(x - hh * 0.5, y); ctx.closePath(); ctx.fill(); } } }
      }
    }
    // 沒出手的鬼：飄在天花板附近（很淡）；被抓的在保安旁邊喝茶
    this.drawTeam(ctx, t);
    // 人（後面的先畫）；剛跑出門的再畫一下，讓他衝出畫面
    const list = this.npcs.filter(n => ((!n.gone && !(n.out && this.t - (n.outAt || 0) > 0.6)) || (n.exitT > 0 && this.t - n.exitT < (OF ? 0.8 : 3) && this.visPos(n)[0] < 1.15)) && (!this.site.pano || this.onScreen(n.x, 0.3))), tags = []; // 全景：只畫畫面入面（同旁邊少少）嘅人
    const zs = list.map(n => [OF && OFFICE.seated(n) ? OFFICE.kenZ(n) - 1e-4 : n.vY != null && !n.gone ? n.vY : this.visPos(n)[1], (c) => { const r = this.drawNpc(c, n, t); if (!n.gone && r.x > -30 && r.x < this.W + 30) tags.push([n, r.x, r.top - 8]); }]); // 名牌：人喺畫面入面先畫
    if (OF) { zs.push(...OFFICE.drawables(t)); if (this.site.pano) zs.push(...OFFMAP.drawables()); } // 家具跟人一起排前後（同一個 y = 同一個深度）
    zs.sort((a, c) => a[0] - c[0]); for (const z of zs) z[1](ctx);
    if (OF) { OFFICE.drawDark(ctx, t); if (this.site.pano) OFFMAP.drawOver(ctx, t); this.propMarks(ctx, t); }
    if (typeof ScareX !== 'undefined') ScareX.draw(this, ctx, t); // Bryan、靈探 KOL 嘅手機燈
    // 鬼出場
    for (const f of this.fx) if (f.kind === 'ghost' && !(OF && f.ghost === 'pontianak')) this.drawGhost(ctx, f, t);
    // 粒子
    for (const p of this.parts) {
      if (p.delay > 0) continue; const [px, py] = this.pt(p.x, p.y);
      if (p.kind === 'paper') { ctx.save(); ctx.translate(px, py); ctx.rotate(p.rot); ctx.fillStyle = '#f4f0e6'; ctx.strokeStyle = '#555'; ctx.lineWidth = 0.8; ctx.fillRect(-7, -9, 14, 18); ctx.strokeRect(-7, -9, 14, 18); ctx.fillStyle = '#b44'; ctx.fillRect(-4, -5, 8, 1.5); ctx.restore(); }
      if (p.kind === 'frost') { ctx.fillStyle = `rgba(220,240,255,${Math.min(1, p.life)})`; ctx.beginPath(); ctx.arc(px, py, 2.2, 0, Math.PI * 2); ctx.fill(); }
      if (p.kind === 'bubble') { ctx.strokeStyle = `rgba(190,230,255,${Math.min(1, p.life)})`; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.arc(px, py, 3, 0, Math.PI * 2); ctx.stroke(); }
      if (p.kind === 'sweat') { ctx.fillStyle = 'rgba(150,210,255,.9)'; ctx.beginPath(); ctx.ellipse(px, py, 2.5, 4, 0, 0, Math.PI * 2); ctx.fill(); }
      if (p.kind === 'dust') { ctx.fillStyle = `rgba(200,190,170,${p.life})`; ctx.beginPath(); ctx.arc(px, py, 6 * (1.2 - p.life), 0, Math.PI * 2); ctx.fill(); }
      if (p.kind === 'drop') { ctx.fillStyle = `rgba(170,210,230,${p.life * 0.4})`; ctx.beginPath(); ctx.ellipse(px, py, 9, 3, 0, 0, Math.PI * 2); ctx.fill(); }
    }
    // 手機亮
    for (const f of this.fx) if (f.kind === 'breath' && !f.n.gone) this.drawBreath(ctx, f, t);
    for (const f of this.fx) if (f.kind === 'phone' && !f.n.gone) { const [x, y] = this.pt(f.n.vX != null ? f.n.vX : f.n.x, f.n.vY != null ? f.n.vY : f.n.y), hh = this.hh(f.n.y) * (this.office() && OFFICE.seated(f.n) ? 0.8 : 1); const a = 0.5 + 0.5 * Math.sin(t * 20); ctx.fillStyle = `rgba(120,255,170,${0.35 * a})`; ctx.beginPath(); ctx.arc(x + f.n.dir * hh * 0.05, y - hh * 0.62, hh * 0.18, 0, Math.PI * 2); ctx.fill(); }
    // 名字、恐懼條、心情符號
    // 邊個望緊點中嗰個人：紅色虛線（佢望到就會穿崩）
    { const placed = []; // 名牌（眼＋名＋恐懼條）：前面嘅人先放，撞到就往上推
      for (const q of tags.slice().sort((a, b) => b[2] - a[2])) { if (q[0].out) continue; q[1] = Math.max(56, Math.min((this.W || 390) - 58, q[1])); const ext = this.tagExt(q[0]); let y = q[2]; // 一個名牌 = [y-20-ext, y+9]
        for (let k = 0; k < 8; k++) { const o = placed.find(r => Math.abs(r[0] - q[1]) < 100 && y - 20 - ext < r[1] + 9 && y + 9 > r[1] - 20 - r[3]); if (!o) break; y = o[1] - 20 - o[3] - 9 - 2; }
        q[2] = y; placed.push([q[1], y, 8, ext]); } this._tagR = placed; }
    const sel = this.sel && !this.sel.gone && !this.sel.out && !this.sel.fleeing && !this.sel.d.guard ? this.sel : null, sp = sel && tags.find(q => q[0] === sel);
    if (sp) { ctx.save(); ctx.setLineDash([6, 5]); ctx.lineDashOffset = -t * 20; ctx.lineWidth = 2; ctx.strokeStyle = 'rgba(255,90,80,.75)';
      for (const [m, x, by] of tags) if (m !== sel && !m.out && this.sees(m, sel)) { ctx.beginPath(); ctx.moveTo(x, by + 6); ctx.lineTo(sp[1], sp[2] - 4); ctx.stroke(); } ctx.restore(); }
    this._bubLast = (this._bubR || []).slice(this._nTag || 0); // 上一格嘅對白框位置（家具標籤要避開）
    this._bubR = (this._tagR || []).map(r => [r[0] - 52, r[1] - 22 - r[3], 104, 32 + r[3]]); this._nTag = this._bubR.length; // 對白框連名牌都唔准蓋住
    { let nb = 0; const bs = tags.filter(q => q[0].bub && !q[0].out).sort((a, b) => (b[0] === this.sel) - (a[0] === this.sel) || (b[0].bubAt || 0) - (a[0].bubAt || 0)); this._bubOK = new Set(bs.slice(0, 2).map(q => q[0])); nb; } // 畫面最多兩個對白框
    for (const [n, x, by] of tags) {
      if (n.out) continue;
      { // 眼：開＝望緊四周（會見到怪事），合埋＝低頭做緊嘢；紅＝望緊你點中嗰個
        ctx.font = '700 11px sans-serif'; const nw2 = ctx.measureText(n.d.name).width / 2;
        const ex = x - nw2 - 12, ey = by - 10, op = this.watching(n), red = sel && n !== sel && this.sees(n, sel);
        ctx.save(); ctx.fillStyle = 'rgba(0,0,0,.6)'; ctx.beginPath(); ctx.arc(ex, ey, 7.5, 0, Math.PI * 2); ctx.fill(); ctx.lineWidth = 1.6;
        if (op) { ctx.fillStyle = red ? '#ff6a5a' : '#f2f2f2'; ctx.beginPath(); ctx.ellipse(ex, ey, 5.5, 3.5, 0, 0, Math.PI * 2); ctx.fill(); ctx.fillStyle = '#111'; ctx.beginPath(); ctx.arc(ex + (n.dir || 1) * 1.2, ey, 2, 0, Math.PI * 2); ctx.fill(); }
        else { ctx.strokeStyle = '#9aa'; ctx.beginPath(); ctx.arc(ex, ey - 2, 4.5, 0.25 * Math.PI, 0.75 * Math.PI); ctx.stroke(); }
        ctx.restore(); }
      if (n.step && n.step.cue) this.drawCue(ctx, n, x, by, t);
      const bw = 60, f = Math.min(1, n.fear / 100), hk = Math.max(0, n.barHit || 0), shk = n.shaken > 0, bh = 6 + hk * 3; // 恐懼條：中招時變粗、閃白；心有餘悸時紅框一閃一閃
      ctx.fillStyle = 'rgba(0,0,0,.65)'; ctx.fillRect(x - bw / 2 - 2, by - 3 - hk * 1.5, bw + 4, bh + 4);
      if (shk) { ctx.strokeStyle = `rgba(255,90,80,${0.45 + 0.4 * Math.sin(t * 7)})`; ctx.lineWidth = 1.6; ctx.strokeRect(x - bw / 2 - 2.5, by - 3.5 - hk * 1.5, bw + 5, bh + 5); }
      ctx.fillStyle = f >= 0.5 ? '#ff5a4a' : f >= 0.25 ? '#ffb84a' : '#9be8b0'; ctx.fillRect(x - bw / 2, by - 1 - hk * 1.5, bw * f, bh);
      if (hk > 0) { ctx.fillStyle = `rgba(255,255,255,${hk * 0.75})`; ctx.fillRect(x - bw / 2, by - 1 - hk * 1.5, bw * f, bh); }
      ctx.fillStyle = 'rgba(255,255,255,.4)'; ctx.fillRect(x - bw / 2 + bw * 0.25, by - 2, 1, bh + 2); ctx.fillRect(x - bw / 2 + bw * 0.5, by - 2, 1, bh + 2);
      ctx.font = '700 11px sans-serif'; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = 'rgba(0,0,0,.8)'; ctx.strokeText(n.d.name, x, by - 6); ctx.fillStyle = n === this.sel ? '#a8ffcf' : '#eee'; ctx.fillText(n.d.name, x, by - 6);
      if (n === sel || (n.mocked > 0 && !n.d.guard)) { const nw = n === sel ? this.witnesses(n).length : -1, a = nw < 0 ? '' : nw ? `${nw}人望緊` : '冇人望緊', b = n.mocked > 0 ? `冇人信×${Math.min(4, n.mocked)}` : '';
        ctx.font = '800 11px sans-serif'; const tx = [a, b].filter(Boolean).join('・'), tw = ctx.measureText(tx).width; // 名上面一粒細膠囊（唔再壓住個頭）
        ctx.fillStyle = 'rgba(10,8,18,.72)'; ctx.beginPath(); ctx.roundRect(x - tw / 2 - 6, by - 33, tw + 12, 15, 7.5); ctx.fill();
        ctx.fillStyle = nw > 0 ? '#ff8a7a' : b && nw < 0 ? '#d6a0ff' : '#8fe8b0'; ctx.fillText(tx, x, by - 21.5); }
      if (n.d.daoshi && n.ds === 'ritual') { const pw = 110, pr = Math.min(1, n.prog || 0), fy = this.pt(n.x, n.y)[1] + 10; ctx.save(); ctx.fillStyle = 'rgba(0,0,0,.72)'; ctx.fillRect(x - pw / 2 - 3, fy, pw + 6, 26); ctx.fillStyle = '#4a3a10'; ctx.fillRect(x - pw / 2, fy + 16, pw, 6); ctx.fillStyle = '#ffd36a'; ctx.fillRect(x - pw / 2, fy + 16, pw * pr, 6); // 做法進度：喺佢腳下，唔會撞對白
        ctx.font = '800 11px sans-serif'; ctx.textAlign = 'center'; ctx.fillStyle = '#ffe9a8'; ctx.fillText(`做法中 ${Math.round(pr * 100)}%${n.fear >= 50 ? '・嚇親停咗' : (this.expo || 0) < 25 ? '・冇動靜慢咗' : ''}`, x, fy + 12); ctx.restore(); }
      const mark = n.fleeing ? '!!!' : n.fear >= 50 ? '！' : n.fear >= 25 ? '？' : '';
      if (mark) { const pop = Math.max(0, n.markPop || 0), ms = 1 + pop * 0.8; ctx.font = '700 11px sans-serif'; ctx.save(); ctx.translate(x + ctx.measureText(n.d.name).width / 2 + (mark.length > 1 ? 16 : 10), by - 3 - Math.abs(Math.sin(t * 6)) * 2); // 名嘅右邊，同名一行 ctx.scale(ms, ms); ctx.rotate(Math.sin(t * 9) * 0.08 * (n.fear >= 50 ? 1 : 0.4));
        ctx.font = `900 ${n.fear >= 50 ? 19 : 16}px sans-serif`; ctx.textAlign = 'center'; ctx.fillStyle = n.fear >= 50 ? '#ff6a5a' : '#ffd36a'; ctx.strokeStyle = '#000'; ctx.lineWidth = 3; ctx.strokeText(mark, 0, 0); ctx.fillText(mark, 0, 0); ctx.restore(); }
      if (n.bub && this._bubOK.has(n)) this.drawBubble(ctx, n.bub, x, by - 20 - this.tagExt(n), n.bubG, this.t - (n.bubAt || 0)); // 對白框喺成個名牌上面
    }
    if (this.site.pano) this.drawEdge(ctx, t);
    // 漂浮字
    for (const f of this.floats) { const k = 1 - f.life / f.max, x = this.W / 2, y = 64 - Math.min(1, k * 6) * 4, al = Math.min(1, f.life * 3, k * 8 + 0.2); ctx.save(); ctx.globalAlpha = al; ctx.font = '800 15px sans-serif'; ctx.textAlign = 'center'; const w = Math.min(this.W - 20, ctx.measureText(f.text).width + 26);
      ctx.fillStyle = 'rgba(12,10,20,.82)'; ctx.beginPath(); ctx.roundRect(x - w / 2, y - 17, w, 26, 13); ctx.fill(); ctx.strokeStyle = f.color; ctx.globalAlpha = al * 0.6; ctx.lineWidth = 1.2; ctx.stroke(); ctx.globalAlpha = al; ctx.fillStyle = f.color; ctx.fillText(f.text, x, y + 1); ctx.restore(); }
    ctx.restore();
    // 暗角（大招時發紅）
    const vg = ctx.createRadialGradient(W / 2, H / 2, H * 0.3, W / 2, H / 2, H * 0.8); vg.addColorStop(0, 'rgba(0,0,0,0)'); vg.addColorStop(1, `rgba(${Math.round(90 * this.vign)},0,0,${0.45 + 0.3 * this.vign})`);
    ctx.fillStyle = vg; ctx.fillRect(0, 0, W, H);
    { // 穿崩度（阿福俾人發現嘅程度）：35 有人起疑、70 請道士
      const e = Math.min(100, this.expo || 0), bx = 10, by = this.site.pano ? this.H - 34 : 10, bw = 132, bh = 9; // 全景：頂有小地圖，穿崩度放左下角
      ctx.save(); ctx.fillStyle = 'rgba(0,0,0,.62)'; ctx.fillRect(bx - 4, by - 4, bw + 8, bh + 22);
      ctx.font = '700 11px sans-serif'; ctx.textAlign = 'left'; ctx.fillStyle = e >= EXPO.call ? '#ff8a6a' : e >= EXPO.sus ? '#ffcf6a' : '#cfe8d8';
      ctx.fillText(`穿崩度 ${Math.round(e)}${this.daoIn ? '　道士到！' : this.daoCall ? '　請咗道士' : this.alert ? '　有人起疑' : ''}`, bx, by + 8);
      ctx.fillStyle = 'rgba(255,255,255,.15)'; ctx.fillRect(bx, by + 12, bw, bh - 2); ctx.fillStyle = e >= EXPO.call ? '#ff6a4a' : e >= EXPO.sus ? '#ffb84a' : '#7fd6a0'; ctx.fillRect(bx, by + 12, bw * e / 100, bh - 2);
      ctx.fillStyle = 'rgba(255,255,255,.7)'; for (const q of [EXPO.sus, EXPO.call]) ctx.fillRect(bx + bw * q / 100, by + 10, 1.5, bh + 2); ctx.restore(); }
    // 天快亮
    if (this.t > NIGHT_SEC * 0.85) { ctx.fillStyle = `rgba(120,150,210,${(this.t / NIGHT_SEC - 0.85) * 1.2})`; ctx.fillRect(0, 0, W, H); }
  },
  // 點中嘅人喺畫面外：畫面邊一個箭咀＋名（點一下跳過去）
  drawEdge(ctx, t) {
    const n = this.sel; this._edge = null; if (!n || n.gone || n.out) return; const x = n.vX != null ? n.vX : n.x; if (this.onScreen(x, -0.04)) return;
    const right = x > this.camX + this.viewW() / 2, H = this.H, y = 58, ex = right ? this.W - 8 : 8, bob = Math.sin(t * 5) * 3;
    const lab = `${n.d.name}・${OFFMAP.roomAt(x).name}`; ctx.save(); ctx.font = '800 12px sans-serif'; const tw = ctx.measureText(lab).width + 34, bx = right ? ex - tw - bob : ex + bob;
    ctx.fillStyle = 'rgba(12,10,20,.85)'; ctx.strokeStyle = '#a8ffcf'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(bx, y - 14, tw, 28, 14); ctx.fill(); ctx.stroke();
    ctx.fillStyle = '#a8ffcf'; ctx.beginPath(); const ax = right ? bx + tw - 12 : bx + 12; ctx.moveTo(ax + (right ? 7 : -7), y); ctx.lineTo(ax - (right ? 5 : -5), y - 8); ctx.lineTo(ax - (right ? 5 : -5), y + 8); ctx.closePath(); ctx.fill();
    ctx.textAlign = 'center'; ctx.fillStyle = '#eafff2'; ctx.fillText(lab, bx + tw / 2 + (right ? -6 : 6), y + 4); ctx.restore(); this._edge = [bx, y - 14, tw, 28, n];
  },
  // 在背後呼氣：看不見的嘴在他頸後吹一口白霧（一團一團往前捲、散掉），旁邊幾顆霜
  drawBreath(ctx, f, t) {
    const n = f.n, k = 1 - f.life / f.max, seat = this.office() && OFFICE.seated(n);
    const [x, y] = this.pt(n.vX != null ? n.vX : n.x, n.vY != null ? n.vY : n.y), hh = this.hh(n.y) * (seat ? 0.8 : 1);
    const face = seat ? -1 : (n.dir || 1), back = -face, nx = x + back * hh * (seat ? 0.02 : 0.2), ny = y - hh * (seat ? 0.62 : 0.72);
    const a = Math.min(1, k * 6) * Math.max(0, 1 - Math.max(0, k - 0.45) / 0.4);
    if (a <= 0) return;
    ctx.save(); ctx.lineCap = 'round';
    for (let i = 0; i < 4; i++) { // 一口一口：從後面吹向頸子
      const q = Math.min(1, Math.max(0, k * 2.2 - i * 0.18)); if (q <= 0) continue;
      const px = nx + back * hh * (0.28 - 0.22 * q) + Math.sin(t * 3 + i) * 2, py = ny - hh * 0.04 * i + Math.sin(t * 2 + i) * 1.5, r = hh * (0.05 + 0.07 * q);
      const g = ctx.createRadialGradient(px, py, 0, px, py, r); g.addColorStop(0, `rgba(240,248,255,${0.8 * a})`); g.addColorStop(1, 'rgba(235,245,255,0)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, r, 0, Math.PI * 2); ctx.fill();
      ctx.strokeStyle = `rgba(245,250,255,${0.6 * a})`; ctx.lineWidth = 1.6; ctx.beginPath(); ctx.arc(px, py, r * 0.6, Math.PI * (0.2 + i * 0.3), Math.PI * (1.3 + i * 0.3)); ctx.stroke();
    }
    ctx.fillStyle = `rgba(220,240,255,${a})`;
    for (let i = 0; i < 6; i++) { const q = (k * 2 + i / 6) % 1, sx = nx + back * hh * (0.05 + 0.2 * Math.sin(i * 2.1)), sy = ny + hh * (q * 0.2 - 0.08); ctx.beginPath(); ctx.arc(sx, sy, 1.4, 0, Math.PI * 2); ctx.fill(); }
    ctx.restore();
  },
  propMarks(ctx, t) {
    for (const k in SCARE_PROPS) {
      if (SCARE_PROPS[k].group || !this.propOK(k, this.sel)) continue; // 只標點中嗰個人用得到嘅家具；全場燈、冷氣喺下面掣度
      if (this.site.pano && !this.onScreen(SCARE_PROPS[k].rect[0] + SCARE_PROPS[k].rect[2] / 2, 0)) continue;
      const p = SCARE_PROPS[k], [x1, y1] = this.pt(p.rect[0], p.rect[1]), [x2, y2] = this.pt(p.rect[0] + p.rect[2], p.rect[1] + p.rect[3]);
      const ok = this.mana >= p.cost && this.propOK(k, this.sel), a = ok ? 0.35 + 0.25 * Math.sin(t * 3 + x1) : 0.1; // 只對點中的人：佢唔喺附近就變暗
      ctx.strokeStyle = `rgba(150,255,200,${a})`; ctx.lineWidth = 2; ctx.setLineDash([5, 4]); ctx.strokeRect(x1, y1, x2 - x1, y2 - y1); ctx.setLineDash([]);
      const cdl = p.group && (this.pcd || {})[k] > 0 ? Math.ceil(this.pcd[k]) + '秒' : p.cost, lab = `${p.name}${p.group ? '（全場）' : ''}・${cdl}`;
      ctx.font = '600 11px sans-serif'; ctx.textAlign = 'center'; const tw = ctx.measureText(lab).width / 2 + 4, lx = Math.max(tw, Math.min(this.W - tw, (x1 + x2) / 2)), TR = this._tagR || [], BR = this._bubLast || [], hit = (yy) => TR.some(r => Math.abs(r[0] - lx) < tw + 44 && yy > r[1] - 22 && yy - 12 < r[1] + r[2]) || BR.some(r => lx + tw > r[0] && lx - tw < r[0] + r[2] && yy > r[1] && yy - 12 < r[1] + r[3]); // 標籤避開名牌：上、下、框入面揀一個冇撞到嘅位
      let ly = p.label === 'up' ? y1 - 5 : y2 + 13; for (const c of [y1 - 5, y2 + 13, y1 + 14]) if (!hit(ly)) break; else ly = c;
      if (hit(ly)) continue; // 冇位就唔寫字（虛線框照畫），唔好蓋住名牌
      if (this.office()) { ctx.lineWidth = 3; ctx.strokeStyle = 'rgba(10,8,20,.75)'; ctx.strokeText(lab, lx, ly); }
      ctx.fillStyle = p.group ? `rgba(190,215,255,${ok ? 0.9 : 0.4})` : `rgba(190,255,215,${ok ? 0.9 : 0.4})`; ctx.fillText(lab, lx, ly);
    }
  },
  // ---------- 人的動畫（只管畫面，不碰分數） ----------
  // 一次性反應：flinch 縮一下、startle 嚇一跳、weakjump 被戳中弱點跳起來、burst 尖叫抱頭、rational 自我安慰聳肩、numb 木訥、sip 保安喝茶、catch 保安抓鬼
  react(n, k, o) {
    if (this.headless || !n) return; o = o || {};
    const D = { flinch:0.5, startle:0.75, weakjump:0.95, burst:2.6, rational:1.6, numb:1.3, sip:2.6, catch:2.4, chill:2.4 };
    if (n.rx && n.rx.k === 'burst' && n.rx.t < n.rx.dur * 0.75 && k !== 'burst') return; // 正在尖叫，小事打不斷
    n.rx = { k, t:-(o.delay || 0), dur:o.dur || D[k] || 1, src:o.src, big:!!o.big };
  },
  animNpc(n, dt) {
    n.at = (n.at || 0) + dt * (n.spd || 1);
    if (typeof TOWN !== 'undefined') TOWN.npcTick(n, dt); // 平日動作（daily_town.js）：只管畫面
    if (this.office()) OFFICE.kenTick(n, dt); // 有工位的人（阿Ken、小晴）：坐、站、跳起來、椅子滑走（office.js）
    if (n.rx) { n.rx.t += dt; if (!n.rx.fired && n.rx.t >= 0) { n.rx.fired = true; this.onReact(n); } if (n.rx && n.rx.t >= n.rx.dur) n.rx = null; }
    const lv = n.fleeing ? 3 : n.fear >= 50 ? 2 : n.fear >= 25 ? 1 : 0;
    if (lv > (n.lv || 0)) { n.markPop = 0.5; if (lv >= 1) n.goose = Math.max(n.goose || 0, 1.2); }
    n.lv = lv; n.markPop = (n.markPop || 0) - dt * 2;
    for (const key of ['goose', 'hair', 'shock', 'scream']) if (n[key] > 0) n[key] = Math.max(0, n[key] - dt);
    if (n.barHit > 0) n.barHit = Math.max(0, n.barHit - dt * 2);
    if (n.shaken > 0 && !n.fleeing && Math.random() < dt * 0.9) this.parts.push({ kind:'sweat', x:(n.vX != null ? n.vX : n.x) + (Math.random() - 0.5) * 0.05, y:(n.vY != null ? n.vY : n.y) - 0.16, vx:(Math.random() - 0.5) * 0.05, vy:-0.05, g:0.45, life:0.7 }); // 心有餘悸：不時冒冷汗
    if (n.fleeing && !n.gone && n.trail) n.trail.push([this.t, n.x, n.y]);
    const vx = n.vX != null ? n.vX : n.x, vy = n.vY != null ? n.vY : n.y;
    if (!n.gone && n.fear >= 50 && Math.random() < dt * (n.fear >= 80 ? 5 : 2.2)) this.parts.push({ kind:'sweat', x:vx + (Math.random() - 0.5) * 0.06, y:vy - 0.16 - Math.random() * 0.03, vx:(Math.random() - 0.5) * 0.06, vy:-0.06, g:0.45, life:0.7 });
  },
  onReact(n) { // 反應「落地」的那一刻：毛髮豎起、雞皮疙瘩、冷汗噴出去
    const k = n.rx.k, vx = n.vX != null ? n.vX : n.x, vy = n.vY != null ? n.vY : n.y;
    if (k === 'startle' || k === 'weakjump' || k === 'burst') {
      n.hair = k === 'burst' ? 1.6 : 1; n.goose = 1.6; n.shock = 0.5;
      for (let i = 0; i < (k === 'burst' ? 7 : 4); i++) { const a = -Math.PI / 2 + (Math.random() - 0.5) * 2.2; this.parts.push({ kind:'sweat', x:vx + Math.cos(a) * 0.03, y:vy - 0.17, vx:Math.cos(a) * 0.16, vy:Math.sin(a) * 0.18, g:0.6, life:0.75 }); }
    }
    if (k === 'burst') n.scream = 1.8;
    if (k === 'flinch') { n.shock = 0.28; n.goose = Math.max(n.goose || 0, 0.8); }
  },
  rigOK(type) { return typeof ART !== 'undefined' && ((typeof Puppet !== 'undefined' && Puppet.has(type)) || !!(ART.hasRig && ART.hasRig(type))); },
  // 逃跑的人：等鬼「出手」那一刻嚇一跳，再衝出去（畫面位置跟著實際路線追上來）
  visPos(n) {
    if (!n.fleeT || !n.trail || !n.trail.length) return [n.x, n.y, null];
    const age = this.t - n.fleeT, hold = n.fleeHold || 0, tr = n.trail;
    const lag = age < hold ? age : hold * Math.max(0, 1 - (age - hold) / 0.7), ts = this.t - lag;
    let i = tr.length - 1; while (i > 0 && tr[i][0] > ts) i--;
    let x = tr[i][1], y = tr[i][2], dir = n.dir;
    if (i < tr.length - 1) { const b = tr[i + 1], k = Math.max(0, Math.min(1, (ts - tr[i][0]) / ((b[0] - tr[i][0]) || 1))); x += (b[1] - x) * k; y += (b[2] - y) * k; }
    else if (n.gone) { const e = ts - n.exitT; if (e > 0) { x += e * 0.45; dir = 1; } }
    return [x, y, dir];
  },
  npcPose(n) {
    const d = n.d, f = n.fear, rx = n.rx && n.rx.t >= 0 ? n.rx : null, walking = n.act === 'walk';
    const habit = n.hab && Object.keys(n.hab).some(k => n.hab[k] >= 1.5);
    const calm = d.k === 'ken' || d.k === 'auntie' ? 'b' : d.k === 'boss' ? (Math.sin((n.at || 0) * 0.9) > 0.55 ? 'q' : 'n') : 'n';
    const o = { pose:'idle', face:habit && f < 25 ? 'b' : calm, pt:0, walk:false, src:null, sx:1, sy:1, lift:0, jit:0, rot:0, spd:1 };
    if (n.fleeing) {
      const age = this.t - (n.fleeT || 0), hold = n.fleeHold || 0;
      if (age >= hold || n.gone) return Object.assign(o, { pose:'run', face:'t', walk:true, jit:0.35, spd:2.2, run:true });
      if (age >= hold - 0.4) { const p = (age - hold + 0.4) / 0.4; return Object.assign(o, { pose:'startle', pt:p, face:'t', lift:Math.sin(p * Math.PI) * 1.3, sy:1 + 0.14 * Math.sin(p * Math.PI), sx:1 / (1 + 0.14 * Math.sin(p * Math.PI)), src:n.rx && n.rx.src }); }
    }
    if (walking) { o.pose = 'move'; o.walk = true; if (f >= 50) Object.assign(o, { face:f >= 80 ? 't' : 'f', jit:0.45, spd:0.75 }); else if (f >= 25) o.face = 'q'; }
    else if (f >= 80) Object.assign(o, { pose:'cower', face:'t', jit:0.8 });
    else if (f >= 50) Object.assign(o, { pose:'tremble', face:'f', jit:0.3 });
    else if (f >= 25) Object.assign(o, { pose:'look', face:'q' });
    else if (n.act === 'brk_nap') Object.assign(o, { pose:'idle', face:'c', doze:true }); // 伏喺枱瞓：動作喺 daily_town.js（office_ken_nap）
    else if (n.act === 'brk_phone') Object.assign(o, { pose:'phone', face:'b' });
    else if (n.act === 'brk_drink') Object.assign(o, { pose:'sip', face:'c' });
    else if (d.k === 'ken') Object.assign(o, { pose:'phone', face:'b' }); // 盯著發光的手機，魂不在身上
    else if (n.act === 'mop') Object.assign(o, { pose:'mop', face:'b' });
    else if (d.daoshi && n.act === 'ritual') o.pose = 'ritual'; // 道士做法（自己的原畫）
    else if (d.guard && n.act === 'doze') Object.assign(o, { pose:'idle', face:'c', doze:true }); // 坐崗打瞌睡：動作喺 daily_town.js（town_guard_dozeL）
    else if (d.guard) Object.assign(o, { pose:'look', face:'n' });
    else if (d.k === 'boss') o.pose = 'hold'; // 抱著水晶球
    if (f < 25 && !walking && !n.fleeing && typeof TOWN !== 'undefined' && TOWN.actAnim(n)) o.pose = n.act; // 有專屬動作（daily_town.js office_*）：開會、講電話、瞓覺、收拾……
    if (rx) {
      const p = Math.min(1, rx.t / rx.dur); o.src = rx.src;
      const jump = (A, mul) => { // A 秒的預備（蹲一下），然後彈起來
        if (rx.t < A) { o.sx = 1.09; o.sy = 0.88; o.face = 's'; return; }
        const q = Math.min(1, (rx.t - A) / Math.max(0.2, (rx.k === 'burst' ? 0.55 : rx.dur) - A)), up = Math.sin(Math.min(1, q * 1.5) * Math.PI);
        Object.assign(o, { pose:'startle', pt:q, walk:false, face:rx.k === 'burst' || (q > 0.4 && f >= 75) ? 't' : 's', lift:up * mul, sy:1 + 0.13 * up, sx:1 / (1 + 0.13 * up), jit:0 });
      };
      switch (rx.k) {
        case 'flinch': Object.assign(o, { pose:o.walk ? 'move' : 'hurt', pt:p, face:'s', sx:1 + 0.06 * (1 - p), sy:1 - 0.06 * (1 - p) }); break;
        case 'startle': jump(0.08, rx.big ? 1.1 : 0.75); break;
        case 'weakjump': jump(0.09, 1.5); break;
        case 'burst': if (rx.t < 0.55) jump(0.07, 1.4); else Object.assign(o, o.walk ? { face:'t', jit:1, spd:1.6 } : { pose:'cower', face:'t', jit:1, pt:Math.min(1, (rx.t - 0.55) / 0.3) }); break;
        case 'rational': { const sh = Math.sin(Math.min(1, rx.t / 0.55) * Math.PI); Object.assign(o, { face:'q', sy:1 + 0.06 * sh, sx:1 - 0.02 * sh, lift:0.18 * sh, rot:-0.06 * sh, shrug:sh }); if (!o.walk) { o.pose = 'shrug'; o.pt = Math.min(1, rx.t / 0.9); } break; }
        case 'numb': o.face = 'b'; if (!o.walk) o.pose = d.k === 'ken' ? 'phone' : d.mop ? 'mop' : d.k === 'boss' ? 'hold' : 'idle'; break;
        case 'sip': if (!o.walk) o.pose = 'sip'; o.face = 'c'; break;
        case 'catch': o.pose = 'look'; o.face = 'q'; o.walk = false; break;
        case 'chill': { // 頸後一涼：縮脖子打冷顫 → 慢慢回頭看後面（翻面）→ 沒有人，轉回來
          const t2 = rx.t, sh = t2 < 0.7 ? 1 - t2 / 0.7 : 0;
          const sq = Math.min(1, Math.abs(t2 - 0.9) / 0.12, Math.abs(t2 - 1.9) / 0.12); // 轉身那一下：身體先壓扁再翻過去
          Object.assign(o, { face:t2 < 0.7 ? 's' : 'q', jit:0.5 * sh, sy:1 - 0.06 * sh, sx:(1 + 0.03 * sh) * (0.45 + 0.55 * sq) });
          if (!o.walk) o.pose = t2 < 0.7 ? 'tremble' : 'look';
          o.turn = t2 > 0.9 && t2 < 1.9; o.turnK = t2 < 0.9 ? 0 : t2 < 1.15 ? (t2 - 0.9) / 0.25 : t2 < 1.65 ? 1 : t2 < 1.9 ? 1 - (t2 - 1.65) / 0.25 : 0;
          break; }
      }
      o.rxk = rx.k;
    }
    return o;
  },
  drawNpc(ctx, n, t) {
    if (this.office() && OFFICE.seated(n) && !n.out) { // 坐在工位上：椅子＋坐著的原圖
      n.vX = n.x + OFFICE.kenOff(n); n.vY = n.y; const [sx, sy] = this.pt(n.vX, n.y), sh = this.hh(n.y);
      if (n === this.sel) { ctx.fillStyle = 'rgba(160,255,200,.28)'; ctx.beginPath(); ctx.ellipse(sx - sh * 0.12, sy, sh * 0.4, sh * 0.09, 0, 0, Math.PI * 2); ctx.fill(); }
      const r = OFFICE.drawKen(ctx, n, t), o = this.npcPose(n); o.pose = 'seat';
      this.npcFx(ctx, n, o, r.x, r.top + r.H, r.H, false, t);
      return { x:r.x, top:r.top };
    }
    if (this.office() && n.gone) ctx.globalAlpha = Math.max(0, 1 - (this.t - n.exitT) / 0.8); // 走進電梯：淡出
    else if (n.out) ctx.globalAlpha = Math.max(0, 1 - (this.t - (n.outAt || 0)) / 0.6); // 走進電梯
    else if (n.inAt != null && this.t - n.inAt < 0.6) ctx.globalAlpha = Math.min(1, (this.t - n.inAt) / 0.6); // 從電梯出來
    const vp = this.visPos(n); if (this.office()) vp[0] += OFFICE.kenOff(n);
    const [x, y] = this.pt(vp[0], vp[1]), hh = this.hh(vp[1]), d = n.d;
    n.vX = vp[0]; n.vY = vp[1];
    const o = this.npcPose(n); n.spd = o.spd;
    let right = vp[2] != null ? vp[2] > 0 : n.dir > 0;
    if (o.src != null && !d.guard && !o.walk && !o.run) right = o.src >= vp[0]; // 嚇到時，轉頭看著嚇他的東西
    if (o.turn) right = !right; // 回頭看後面
    const rig = this.rigOK(d.spr), jx = o.jit ? (Math.random() - 0.5) * 3.2 * o.jit : 0, jy = o.jit ? (Math.random() - 0.5) * 1.2 * o.jit : 0, lift = o.lift * hh * (rig ? 0.1 : 0.16); // 木偶本身也會跳，少加一點
    if (n === this.sel && !n.gone && !n.fleeing) { ctx.fillStyle = 'rgba(160,255,200,.28)'; ctx.beginPath(); ctx.ellipse(x, y, hh * 0.34, hh * 0.08, 0, 0, Math.PI * 2); ctx.fill(); }
    const shk = 1 - Math.min(0.5, o.lift * 0.35); ctx.fillStyle = 'rgba(0,0,0,.35)'; ctx.beginPath(); ctx.ellipse(x, y, hh * 0.22 * shk * (o.pose === 'cower' ? 1.2 : 1), hh * 0.05 * shk, 0, 0, Math.PI * 2); ctx.fill();
    const sit = this.sitting(n) ? hh * 0.22 : 0; if (sit && d.k === 'mis' && !o.src) right = true; // 美美坐前台：面向右
    ctx.save(); if (sit) { ctx.beginPath(); ctx.rect(x - hh, y - hh * 2, hh * 2, hh * 2 - hh * 0.02); ctx.clip(); }
    ctx.translate(x + jx, y + jy - lift + sit); if (o.rot) ctx.rotate(o.rot * (right ? 1 : -1)); ctx.scale(o.sx, o.sy);
    if (d.tint) ctx.filter = d.tint; // 靈探 KOL：借小晴套骨架換色
    if (d.k === 'mis' && this.office() && OFFICE.drawMis(ctx, n, o, hh, right, t)) { /* 美美：自己的幾張原圖（office.js） */ }
    else if (rig) ART.drawChar(ctx, d.spr, 0, 0, hh / NPC_UNIT, Object.assign({ t:n.at || 0, pose:o.pose, pt:o.pt, face:o.face, flip:!right, walk:o.walk, shadow:false }, typeof TOWN !== 'undefined' ? TOWN.npcOpts(n) : {}));
    else this.drawNpcSprite(ctx, n, o, hh, right);
    ctx.filter = 'none'; ctx.restore();
    if (d.mop && o.pose === 'mop' && Math.random() < 0.05) this.parts.push({ kind:'drop', x:vp[0] + (right ? 1 : -1) * 0.05, y:vp[1], vx:0, vy:0, life:1.4 });
    this.npcFx(ctx, n, o, x + jx, y - lift, hh, right, t); ctx.globalAlpha = 1;
    const nap = n.act === 'brk_nap' && n.daily && n.daily.forced && n.daily.w > 0.5 ? hh * 0.15 : 0; // 伏喺枱瞓：頭低咗，名牌跟住落
    return { x, top:y - lift + sit + nap - hh * (o.pose === 'cower' ? 0.8 : 1) * o.sy };
  },
  // 還沒有關節圖的人：用整張圖做出姿勢的感覺
  drawNpcSprite(ctx, n, o, hh, right) {
    const spr = SPR[n.d.spr]; if (!spr || !spr.complete || !spr.naturalWidth) return;
    const w = hh * spr.naturalWidth / spr.naturalHeight, a = n.at || 0; let bob = 0, tilt = 0, sx = 1, sy = 1 + Math.sin(a * 2.2) * 0.012;
    switch (o.pose) {
      case 'move': bob = Math.abs(Math.sin(a * 9)) * hh * 0.05; tilt = Math.sin(a * 9) * 0.04; break;
      case 'run': bob = Math.abs(Math.sin(a * 11)) * hh * 0.08; tilt = 0.22 + Math.sin(a * 11) * 0.06; sx = 1.04; break;
      case 'startle': tilt = -0.25 * Math.sin(Math.min(1, o.pt * 1.6) * Math.PI); break;
      case 'cower': sy = 0.8 + Math.sin(a * 30) * 0.015; sx = 1.1; tilt = 0.12; break;
      case 'tremble': tilt = Math.sin(a * 40) * 0.025; break;
      case 'phone': tilt = 0.06 + Math.sin(a * 1.3) * 0.01; break;
      case 'mop': tilt = Math.sin(a * 4) * 0.06; break;
      case 'look': tilt = Math.sin(a * 1.6) * 0.05; break;
      case 'hurt': tilt = -0.2 * (1 - o.pt); break;
      case 'sip': tilt = -0.05 + Math.sin(a * 1.2) * 0.03; break;
    }
    ctx.translate(0, -bob); ctx.rotate(tilt * (right ? 1 : -1)); ctx.scale((right ? 1 : -1) * sx, sy); ctx.drawImage(spr, -w / 2, -hh, w, hh);
  },
  // 表情符號式的小特效：手機光、雞皮疙瘩、頭髮豎起、驚嚇線、尖叫、黑線
  npcFx(ctx, n, o, x, y, hh, right, t) {
    const side = right ? 1 : -1, hy = y - hh * 0.86, hx = x + side * hh * 0.03;
    ctx.save(); ctx.lineCap = 'round';
    if (o.pose === 'phone' && !o.rxk) { // 手機螢幕的光打在臉上
      const gx = x + side * hh * 0.14, gy = y - hh * 0.66, r = hh * 0.3, fl = 0.3 + 0.06 * Math.sin(t * 3 + n.ph) + (Math.sin(t * 0.7 + n.ph) > 0.92 ? 0.15 : 0);
      const g = ctx.createRadialGradient(gx, gy, 0, gx, gy, r); g.addColorStop(0, `rgba(150,220,255,${fl})`); g.addColorStop(1, 'rgba(150,220,255,0)');
      ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(gx, gy, r, 0, Math.PI * 2); ctx.fill(); ctx.globalCompositeOperation = 'source-over';
    }
    const goose = Math.max(n.goose || 0, o.face === 'f' || o.face === 't' ? 0.6 : 0);
    if (goose > 0) { // 雞皮疙瘩：身體兩側的小鋸齒
      ctx.strokeStyle = `rgba(255,255,255,${Math.min(0.85, goose * 0.7)})`; ctx.lineWidth = 1.4;
      for (const s of [-1, 1]) for (let i = 0; i < 3; i++) {
        const bx = x + s * hh * (0.24 + 0.03 * Math.sin(t * 20 + i)), by = y - hh * (0.62 - i * 0.09);
        ctx.beginPath(); ctx.moveTo(bx, by); for (let j = 1; j <= 3; j++) ctx.lineTo(bx + s * j * 3, by + (j % 2 ? -3 : 3)); ctx.stroke();
      }
    }
    if (n.hair > 0) { // 頭髮豎起來
      const k = Math.min(1, n.hair); ctx.strokeStyle = `rgba(30,24,30,${k})`; ctx.lineWidth = 2;
      for (let i = -2; i <= 2; i++) { const bx = hx + i * hh * 0.045, by = hy - hh * 0.06; ctx.beginPath(); ctx.moveTo(bx, by); ctx.quadraticCurveTo(bx + Math.sin(t * 50 + i) * 2.5, by - hh * 0.07 * k, bx + i * 1.5, by - hh * 0.14 * k); ctx.stroke(); }
    }
    if (n.shock > 0) { // 驚嚇線（漫畫的放射線）
      const k = 1 - n.shock / 0.5; ctx.strokeStyle = `rgba(255,236,150,${Math.min(1, n.shock * 3)})`; ctx.lineWidth = 2.2;
      for (let i = 0; i < 9; i++) { const a = -Math.PI * 0.95 + i * Math.PI * 0.95 / 8 * 1.0 - 0.05, r0 = hh * (0.2 + k * 0.08), r1 = r0 + hh * 0.1; ctx.beginPath(); ctx.moveTo(hx + Math.cos(a) * r0, hy + Math.sin(a) * r0); ctx.lineTo(hx + Math.cos(a) * r1, hy + Math.sin(a) * r1); ctx.stroke(); }
    }
    if (o.rxk === 'rational' || o.rxk === 'numb') { // 黑線＋一滴汗
      ctx.strokeStyle = 'rgba(40,40,90,.75)'; ctx.lineWidth = 1.6;
      for (let i = 0; i < 3; i++) { const bx = hx - side * hh * 0.02 + (i - 1) * hh * 0.035; ctx.beginPath(); ctx.moveTo(bx, hy - hh * 0.02); ctx.lineTo(bx, hy + hh * (0.06 + (i === 1 ? 0.02 : 0))); ctx.stroke(); }
      const dx = hx - side * hh * 0.13, dy = hy + hh * 0.02 + (n.rx ? Math.min(1, n.rx.t) * hh * 0.05 : 0);
      ctx.fillStyle = 'rgba(160,215,255,.95)'; ctx.beginPath(); ctx.moveTo(dx, dy - 6); ctx.quadraticCurveTo(dx + 4.5, dy + 2, dx, dy + 3.5); ctx.quadraticCurveTo(dx - 4.5, dy + 2, dx, dy - 6); ctx.fill();
      if (o.shrug > 0.2) { ctx.strokeStyle = `rgba(255,255,255,${o.shrug * 0.7})`; ctx.lineWidth = 1.5; for (const s of [-1, 1]) { ctx.beginPath(); ctx.arc(x + s * hh * 0.26, y - hh * 0.62, 5, s > 0 ? -1.2 : Math.PI + 1.2 - 2.4, s > 0 ? 1.2 - 2.4 + 2.4 : Math.PI + 1.2); ctx.stroke(); } }
    }
    if (o.pose === 'tremble' || o.pose === 'cower' || (o.jit > 0.5 && !o.run)) { // 發抖的震動弧線
      ctx.strokeStyle = 'rgba(255,200,180,.55)'; ctx.lineWidth = 1.5;
      for (const s of [-1, 1]) for (let i = 0; i < 2; i++) { const r = hh * (0.3 + i * 0.06) + Math.sin(t * 30) * 1.5; ctx.beginPath(); ctx.arc(x, y - hh * 0.45, r, s > 0 ? -0.35 : Math.PI - 0.35, s > 0 ? 0.35 : Math.PI + 0.35); ctx.stroke(); }
    }
    if (o.doze && !o.rxk && !(n.daily && n.daily.forced && n.daily.w > 0)) { // 打瞌睡（有專屬動作嗰陣佢自己畫 Zzz）：Z 一個一個飄上去
      ctx.font = '800 13px sans-serif'; ctx.textAlign = 'center';
      for (let i = 0; i < 3; i++) { const q = (t * 0.45 + i / 3) % 1; ctx.fillStyle = `rgba(220,230,255,${0.85 * Math.sin(q * Math.PI)})`; ctx.fillText('Z', x + side * hh * (0.18 + q * 0.15), y - hh * (0.95 + q * 0.3)); }
    }
    if (o.run) { // 速度線
      ctx.strokeStyle = 'rgba(255,255,255,.45)'; ctx.lineWidth = 2;
      for (let i = 0; i < 4; i++) { const ly = y - hh * (0.25 + i * 0.17), lx = x - side * hh * (0.3 + ((t * 3 + i * 0.37) % 1) * 0.15); ctx.beginPath(); ctx.moveTo(lx, ly); ctx.lineTo(lx - side * hh * 0.25, ly); ctx.stroke(); }
    }
    if (o.run && !n.bub) { // 尖叫字只跟住逃跑嘅人（企喺度嘅尖叫交俾對白框，唔會蓋住名牌） // 尖叫：字在身體旁邊抖，不壓到名字、不出畫面
      const k = n.scream > 0 ? Math.min(1, n.scream * 2) : 0.75, chars = [...(n.d.k === 'auntie' ? '哎呀——！' : '啊——！')], fs = Math.round(14 + hh * 0.05), step = fs * 0.85, w = step * chars.length;
      let sd = side; let x0 = sd > 0 ? x + hh * 0.3 : x - hh * 0.3 - w; if (x0 + w > this.W - 6) x0 = x - hh * 0.3 - w; if (x0 < 6) x0 = x + hh * 0.3;
      ctx.font = `900 ${fs}px sans-serif`; ctx.textAlign = 'left'; ctx.lineWidth = 3.5; ctx.strokeStyle = `rgba(0,0,0,${k})`; ctx.fillStyle = `rgba(255,96,80,${k})`;
      chars.forEach((ch, i) => { const ox = x0 + i * step + (Math.random() - 0.5) * 3, oy = y - hh * 0.5 + Math.sin(t * 25 + i) * 2.5 - i * 1.5; ctx.strokeText(ch, ox, oy); ctx.fillText(ch, ox, oy); });
    }
    ctx.restore();
  },
  // 沒出手的鬼：淡淡地飄在天花板；被抓去喝茶的，坐在保安旁邊
  drawTeam(ctx, t) {
    const busy = new Set(this.fx.filter(f => f.kind === 'ghost').map(f => f.ghost)), g = this.npcs.find(n => n.d.guard && !n.gone);
    let ci = 0;
    this.team.forEach((k, i) => {
      if (busy.has(k)) return;
      if (this.caught[k] && g) {
        ci++; const gx = g.x - g.dir * 0.075 * ci, [x, y] = this.pt(gx, g.y + 0.004), s = this.hh(g.y) / 62;
        ART.drawChar(ctx, k, x, y, s, { t:t + i, pose:'idle', alpha:0.5, flip:g.x < gx, shadow:false });
        ctx.strokeStyle = 'rgba(255,255,255,.35)'; ctx.lineWidth = 1.5; for (let j = 0; j < 2; j++) { const sx = x + (j - 0.5) * 6, sy = y - s * 66; ctx.beginPath(); ctx.moveTo(sx, sy); ctx.bezierCurveTo(sx + 5, sy - 6 - Math.sin(t * 3 + j) * 3, sx - 5, sy - 12, sx + Math.sin(t * 2 + j) * 3, sy - 20); ctx.stroke(); }
        return;
      }
      const ready = !this.caught[k] && this.cd[k] <= 0 && this.mana >= 35, dx = Math.sin(t * 0.35 + i * 2.1);
      const x = this.W * (0.17 + 0.33 * i) + dx * this.W * 0.06, y = (this.site.pano ? this.pt(0, 0.36)[1] : this.H * 0.27) + Math.sin(t * 0.9 + i) * 6; // 喺房入面天花下面飄（鏡頭拉遠後唔好飄出去夜空）
      const a = (ready ? 0.34 : 0.13) + 0.06 * Math.sin(t * 1.7 + i);
      ART.drawChar(ctx, k, x, y, 0.8, { t:t + i * 1.3, pose:'idle', alpha:a, flip:Math.cos(t * 0.35 + i * 2.1) < 0, shadow:false });
    });
  },
  // 鬼出手：浮現 → 蓄力 → 出手（≈0.9 秒，人就在這一刻嚇到）→ 收招 → 散掉
  drawGhost(ctx, f, t) {
    const k = 1 - f.life / f.max, H = this.H, W = this.W, [gx, gy] = this.pt(f.gx, f.gy);
    let a = Math.min(1, k * 6, f.life * 2.2); if (k < 0.16) a *= 0.7 + 0.3 * Math.sin(t * 40);
    if (f.caught) a *= 0.55;
    const n = f.n, tx = n ? (n.vX != null ? n.vX : n.x) : 0.5, faceL = n ? tx < f.gx : f.gx > 0.5, side = faceL ? -1 : 1;
    const ph = k < 0.2 ? ['idle', 0] : k < 0.375 ? ['windup', (k - 0.2) / 0.175] : k < 0.55 ? ['strike', (k - 0.375) / 0.175] : k < 0.82 ? ['recover', (k - 0.55) / 0.27] : ['idle', 0];
    const hit = ph[0] === 'strike' ? Math.sin(Math.min(1, ph[1] * 1.4) * Math.PI / 2) : ph[0] === 'recover' ? 1 - ph[1] : 0, wind = ph[0] === 'windup' ? ph[1] : 0;
    const sc = 1.25 * this.depth(f.gy);
    ctx.save();
    if (f.ghost === 'tianhua' && SPR.tianhua_hang && SPR.tianhua_hang.complete) { // 從天花板垂下來：掉下來、彈一下、甩頭髮
      const img = SPR.tianhua_hang, hh = this.persp() ? this.hh(f.gy) * 1.9 : H * 0.32, w = hh * img.naturalWidth / img.naturalHeight;
      const e = Math.min(1, k / 0.375), back = 1 + 2.4 * Math.pow(e - 1, 3) + 1.4 * Math.pow(e - 1, 2), up = k > 0.82 ? (k - 0.82) / 0.18 : 0;
      const drop = (back - up * 1.2) * (gy - hh * 0.95);
      ctx.globalAlpha = a * 0.92; ctx.translate(gx, Math.max(-hh, drop - hh * 0.2) + Math.sin(t * 3) * 3); ctx.rotate(Math.sin(t * (2.4 + hit * 6)) * (0.05 + hit * 0.1)); ctx.scale(1 + hit * 0.08, 1 + hit * 0.08); ctx.drawImage(img, -w / 2, 0, w, hh);
    } else if (f.ghost === 'pontianak') { // 從窗外飄過，邊飄邊笑
      const wy = this.office() ? this.pt(0, OFFICE.WIN[1] + OFFICE.WIN[3] * 0.62)[1] : H * 0.25, x = -60 + (W + 120) * k, y = wy + Math.sin(k * 9) * 12;
      ART.drawChar(ctx, 'pontianak', x, y, 1.3, { t, pose:'cast', pt:Math.min(1, k * 2), alpha:a * 0.8, flip:false, shadow:false, rot:Math.sin(t * 4) * 0.08 });
      ctx.font = '900 18px serif'; ctx.fillStyle = `rgba(255,200,230,${a})`; ctx.textAlign = 'center'; ctx.fillText('嘻——嘻——', x + Math.sin(t * 20) * 2, y - 70);
    } else if (f.ghost === 'eguiking') { // 敲碗：一下一下
      const q = (k * f.max / 0.34) % 1, pose = q < 0.55 ? 'windup' : 'strike', pq = q < 0.55 ? q / 0.55 : (q - 0.55) / 0.45, bump = pose === 'strike' ? Math.sin(pq * Math.PI) : 0;
      ART.drawChar(ctx, 'eguiking', W * 0.86 - bump * 8, H * 0.55, 1.1 * (1 + bump * 0.05), { t, pose, pt:pq, atk:pose === 'strike', alpha:a * 0.8, flip:true, shadow:false, rot:-bump * 0.1 });
      ctx.font = '900 20px sans-serif'; ctx.fillStyle = `rgba(255,230,150,${a})`; ctx.textAlign = 'center'; ctx.fillText('叮叮叮叮！', W * 0.8, H * 0.4 - k * 20);
      if (bump > 0.6) { ctx.font = '900 15px sans-serif'; ctx.fillText('叮！', W * 0.72 + Math.sin(k * 40) * 20, H * 0.47 - bump * 10); }
    } else if (f.ghost === 'penanggal') { // 頭從他身邊飄過去
      const e = Math.min(1, k / 0.6), x = gx + (-side) * W * 0.2 + side * W * 0.38 * (e * e * (3 - 2 * e)), y = gy - H * 0.13 - Math.sin(e * Math.PI) * 20 + Math.sin(t * 6) * 4;
      for (let i = 1; i <= 5; i++) { ctx.fillStyle = `rgba(200,40,60,${a * 0.35 * (1 - i / 6)})`; ctx.beginPath(); ctx.arc(x - side * i * 9, y + 8 + Math.sin(t * 8 + i) * 3, 4 - i * 0.5, 0, Math.PI * 2); ctx.fill(); }
      ART.drawChar(ctx, 'penanggal', x, y + H * 0.05, sc, { t, pose:ph[0], pt:ph[1], alpha:a * 0.85, flip:faceL, shadow:false, rot:side * hit * 0.15 });
    } else if (f.ghost === 'laojiang') { // 一跳、一跳、一跳過走廊
      const x = gx + (-side) * W * 0.22 + side * W * 0.44 * Math.min(1, k * 1.15), hop = Math.abs(Math.sin(k * Math.PI * 5)), y = gy - hop * 26;
      ctx.fillStyle = 'rgba(0,0,0,.25)'; ctx.beginPath(); ctx.ellipse(x, gy + 2, 16 * (1 - hop * 0.4), 4, 0, 0, Math.PI * 2); ctx.fill();
      ART.drawChar(ctx, 'laojiang', x, y, sc, { t, walk:true, pose:'move', alpha:a * 0.88, flip:faceL, shadow:false });
    } else { // 阿福、小紙等：在他旁邊浮現，蓄力，撲過去
      const rise = (1 - Math.min(1, k * 4)) * 30, lunge = side * (hit * 16 - wind * 8);
      let pose = ph[0], pt = ph[1];
      if (f.ghost === 'afu' && k < 0.375) { pose = 'knead'; pt = (k * f.max * 1.6) % 1; } // 坐回工位：手指自己在敲鍵盤
      ART.drawChar(ctx, f.ghost, gx + lunge, gy + rise, sc * (1 + hit * 0.12), { t, pose, pt, atk:hit > 0.3, alpha:a * 0.85, flip:faceL, shadow:false, rot:side * (hit * 0.12 - wind * 0.1) });
      if (f.ghost === 'afu' && k > 0.08 && k < 0.4) { ctx.font = '800 12px sans-serif'; ctx.textAlign = 'center'; ctx.fillStyle = `rgba(190,255,215,${a * 0.9})`; ctx.fillText(['噠', '噠噠', '噠噠噠'][Math.floor(k * 30) % 3], gx + side * 18, gy - H * 0.13); }
    }
    ctx.restore();
    if (f.sig && typeof ScareX !== 'undefined') ScareX.sigFx(this, ctx, f, t, k); // 招牌小把戲（程式畫）
    // 嚇到人的那一刻：一圈衝擊波打在他頭上
    if (n && !n.gone && k > 0.37 && k < 0.6) {
      const q = (k - 0.37) / 0.23, [px, py] = this.pt(tx, n.vY != null ? n.vY : n.y), hh = this.hh(n.y);
      ctx.strokeStyle = `rgba(210,150,255,${(1 - q) * 0.8})`; ctx.lineWidth = 3 * (1 - q) + 1; ctx.beginPath(); ctx.arc(px, py - hh * 0.75, hh * (0.15 + q * 0.5), 0, Math.PI * 2); ctx.stroke();
    }
  },
  drawBubble(ctx, text, x, y, ghost, age) {
    const pk = age == null ? 1 : Math.min(1, age / 0.22), ps = pk >= 1 ? 1 : 1 + 2.70158 * Math.pow(pk - 1, 3) + 1.70158 * Math.pow(pk - 1, 2);
    ctx.save(); ctx.translate(x, y); ctx.scale(Math.max(0.05, ps), Math.max(0.05, ps)); ctx.translate(-x, -y); if (pk < 1) ctx.globalAlpha *= Math.min(1, pk * 3);
    ctx.font = '600 13px sans-serif'; const maxW = 200; const words = [...text]; const lines = []; let cur = '';
    for (const ch of words) { if (ctx.measureText(cur + ch).width > maxW) { lines.push(cur); cur = ch; } else cur += ch; } lines.push(cur);
    if (lines.length > 1 && [...lines[lines.length - 1]].length <= 2) { const pv = [...lines[lines.length - 2]]; lines[lines.length - 1] = pv.splice(-2).join('') + lines[lines.length - 1]; lines[lines.length - 2] = pv.join(''); } // 最後一行唔好得一兩個字
    const w = Math.min(maxW, Math.max(...lines.map(l => ctx.measureText(l).width))) + 16, h = lines.length * 17 + 10;
    let bx = Math.max(6, Math.min(this.W - w - 6, x - w / 2)), by = y - h - 10; const by0 = by;
    const R = this._bubR || (this._bubR = []); // 幾個人同時講嘢：對白框唔好疊埋，後面嗰個往上推
    for (let k = 0; k < 6; k++) { const o = R.find(r => bx < r[0] + r[2] + 3 && bx + w + 3 > r[0] && by < r[1] + r[3] + 3 && by + h + 3 > r[1]); if (!o) break; by = o[1] - h - 5; }
    if (by < 4) by = 4; R.push([bx, by, w, h]);
    if (by < by0 - 2) { ctx.strokeStyle = ghost ? 'rgba(180,138,216,.8)' : 'rgba(255,253,245,.8)'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(x, by + h); ctx.lineTo(x, y - 2); ctx.stroke(); }
    ctx.fillStyle = ghost ? 'rgba(60,30,80,.92)' : 'rgba(255,253,245,.95)'; ctx.strokeStyle = ghost ? '#b48ad8' : '#3a2a1a'; ctx.lineWidth = 1.5;
    ctx.beginPath(); ctx.roundRect(bx, by, w, h, 9); ctx.fill(); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(x - 6, by + h); ctx.lineTo(x, by + h + 8); ctx.lineTo(x + 6, by + h); ctx.fill();
    ctx.fillStyle = ghost ? '#f0e0ff' : '#2a1a10'; ctx.textAlign = 'left'; lines.forEach((l, i) => ctx.fillText(l, bx + 8, by + 18 + i * 17));
    ctx.restore();
  },

  // ---------- 天亮結算 ----------
  finish(quit) {
    if (!this.active) return; this.active = false;
    S.scare = S.scare || { best:{}, runs:0, fv:3 }; this.migrate(); S.scare.runs++;
    const best = S.scare.best[this.siteId] || 0, stars = this.starsOf(this.siteId, this.kpi), first = stars > this.starsOf(this.siteId, best);
    if (this.kpi > best) S.scare.best[this.siteId] = this.kpi;
    const kar = this.karma.reduce((s, k) => s + k.v, 0);
    const rw = { exp:Math.round(this.kpi / 5 * SCARE_PAY), coins:Math.round(this.kpi / 2 * SCARE_PAY) }; if (first) rw.chest = ['g', 'b', 'p'][stars - 1];
    this._legendHTML = typeof ScareX !== 'undefined' ? ScareX.finish(this, stars, quit) : ''; // 都市傳說熱度＋夜晚結算事件（gb:nightEnd）
    const got = give(rw); save();
    const rate = ['親，今晚的 KPI 沒達標哦～明晚加油！', '親，一星好評！離退休還有九百九十九顆星～', '親，二星好評！黃總說你很有潛力（並沒有加薪）。', '親，三星好評！全陰司本月最佳嚇人員工！'][stars];
    const kl = this.karma.length ? this.karma.map(k => `<li class="${k.v > 0 ? 'up' : 'dn'}">陰德 ${k.v > 0 ? '+' : ''}${k.v}　${k.why}</li>`).join('') : '<li>今晚沒有人因為你改變人生。</li>';
    const kword = kar >= 4 ? '你今晚救了人。系統不會算這個，但是有人會記得。' : kar > 0 ? '嚇對人了。' : kar < 0 ? '有些人，其實不用嚇。' : '';
    $('#scare').innerHTML = `<div class="sc-end"><h3>${this.expelled ? '阿福被道士請走了' : quit ? '提早收工' : '天亮了，收工'}</h3>${this.expelled ? `<p class="desc">做法完成，今晚 KPI 只計一半。下次低調啲：唔好俾人望到。</p>` : ''}<div class="sc-stars">${'★'.repeat(stars)}${'☆'.repeat(3 - stars)}</div>
      <p class="sc-big">驚嚇值 ${this.kpi}</p><p class="desc">【陰司 KPI 系統】${rate}</p><p class="desc">獎勵：${got}</p>
      ${this._legendHTML || ''}<h4>陰德（系統沒有算這一欄）</h4><ul class="sc-karma">${kl}</ul><p class="desc">${kword}</p><button class="btn gold wide" id="sc-back">回村子</button></div>`;
    $('#sc-back').onclick = () => { $('#scare').classList.remove('on'); $('#scare').innerHTML = ''; Sound.setMode('village'); UI.refresh(); };
  },
};
function pick(a) { return Array.isArray(a) ? a[Math.floor(Math.random() * a.length)] : a; }
// ===================== 道士（npc_daoshi）：四張原畫（企、行＋講電話、做法、嚇親）＋網格變形；原畫面朝左 =====================
// 好笑只在佢係人（講電話傾價錢、嚇親）；做法本身照足規矩畫：搖鈴、桃木劍、符紙
(() => {
  if (typeof MeshAnim === 'undefined' || typeof ART === 'undefined') return;
  const P = {
    stand: ['npc_daoshi', 1, { c:0.50, n:0.40, h:0.55, ht:0.10, hr:0.30, L:[0.30, 0.48, 0.12, 0.47], R:[0.70, 0.48, 0.75, 0.54], legs:[0.82, 0.38, 0.65] }],
    walk:  ['npc_daoshi_walk', 0.98, { c:0.45, n:0.42, h:0.40, ht:0.08, hr:0.26, L:[0.28, 0.45, 0.15, 0.25], R:[0.62, 0.48, 0.40, 0.55], legs:[0.80, 0.25, 0.55] }],
    ritual:['npc_daoshi_ritual', 1, { c:0.50, n:0.42, h:0.55, ht:0.06, hr:0.24, L:[0.40, 0.40, 0.32, 0.18], R:[0.70, 0.50, 0.62, 0.60], tail:0.50 }],
    jump:  ['npc_daoshi_jump', 1, { c:0.50, n:0.42, h:0.55, ht:0.06, hr:0.24, L:[0.38, 0.48, 0.20, 0.40], R:[0.72, 0.48, 0.88, 0.42], legs:[0.78, 0.30, 0.55] }],
  };
  for (const k in P) MeshAnim.RIG[P[k][0]] = MeshAnim.mk(P[k][2]);
  ART.CHAR_H.npc_daoshi = 64; if (ART.SOLID) ART.SOLID.npc_daoshi = 1;
  MeshAnim.RIG.npc_daoshi.custom = (ctx, a) => {
    const o = a.o, ps = o.pose, A = MeshAnim.ANIM;
    const k = ['scared', 'startle', 'tremble', 'cower', 'hurt'].includes(ps) ? 'jump' : (o.walk || ps === 'move' || ps === 'walk' || ps === 'run') ? 'walk' : ps === 'ritual' ? 'ritual' : 'stand';
    const [img, kk] = P[k]; if (typeof sprOk !== 'function' || !sprOk(img)) return false;
    let pz;
    if (k === 'walk') { pz = A.walk(o.t); for (const n in pz) if (typeof pz[n] === 'number' && !['y', 'sx', 'sy'].includes(n)) pz[n] = -pz[n]; pz.x = 0; pz.rot = 0; }
    else pz = A.idle(o.t);
    if (k === 'ritual') pz.armF = (pz.armF || 0) + Math.sin(o.t * 10) * 0.07; // 搖鈴
    a.shadow(a.x); MeshAnim.draw(ctx, img, a.x, a.y, a.H * kk, pz, a.faceRight); return true;
  };
})();
