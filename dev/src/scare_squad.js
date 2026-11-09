// ===================== 回陽間・帶隊出更（鬼才之道：KPI 唔達標就魂飛魄散） =====================
// 1) 每隻收咗嘅鬼（舊名鬼＋56 隻新鬼＋雜鬼）都有一招辦公室招牌小把戲：對應一種怕法（或者兩種），有自己嘅陰氣、程式畫小特效、搞笑旁白
// 2) 都市傳說熱度（每個地點）：嚇得靚（落單、無人信佢、招式多、冇穿崩）→ 熱度 → 傳說等級 Lv1~5 → 之後嘅夜晚有變化（員工易驚、靈探 KOL、道士早到）
// 3) 死對頭 Bryan 都會嚟搶 KPI（Antag.draw 畫，npc_antag.js 唔改）
// 4) 對外：收工時 window 'gb:nightEnd' 事件；Scare.squad.get()/set(ids)、Scare.legend(loc)
// 文字：粵語原句，中文版用 LANG.add 登記（lang.js 嘅做法），顯示時 L()
const ScareX = (() => {
  const T = (yue, zh) => { if (typeof LANG !== 'undefined' && zh) LANG.add({ [yue]:zh }); return yue; };
  const Lx = (s) => typeof L === 'function' ? L(s) : s;
  const Lf = (s, v) => { let r = Lx(s); for (const k in v || {}) r = r.split('{' + k + '}').join(v[k]); return r; };
  // ---------- 招牌小把戲：[怕法, 特效, 顏色, 招名, 粵語旁白, 中文旁白, 全場?] ----------
  // 怕法：light 燈 / cold 凍 / sound 怪聲 / paper 紙 / phone 電話 / face 鬼臉 / shadow 黑影 / breath 吹氣；兩種用 'light|phone'
  const SIG = {
    // 舊名鬼（阿福、天花姐、Pontianak、小紙、餓鬼王、Penanggal、老殭 用返原本嘅大招）
    toyol:    ['sound', 'coins', '#f0d060', '偷散紙', '（櫃桶啲散紙自己跳出嚟，叮叮噹噹）', '（抽屜的零錢自己跳出來，叮叮噹噹）'],
    pocong:   ['shadow', 'shadow', '#e8e8f0', '布包跳', '（白布包喺佢後面一跳、一跳咁經過）', '（白布包在他身後一跳、一跳地經過）'],
    mengpo:   ['breath', 'smoke', '#cfe8d8', '孟婆湯', '（佢杯茶變咗一碗冒煙嘅湯：「飲啦，飲完乜都唔記得。」）', '（他的茶變成一碗冒煙的湯：「喝吧，喝完什麼都忘了。」）'],
    baiwu:    ['face', 'tongue', '#ffffff', '一見生財', '（長舌由天花垂落嚟：「一見生財～」）', '（長舌從天花板垂下：「一見生財～」）'],
    heiwu:    ['sound', 'bones', '#9aa0b8', '鐵鏈拖地', '（背後傳嚟鐵鏈拖地聲：噹啷——噹啷——）', '（背後傳來鐵鏈拖地聲：噹啷——噹啷——）'],
    // 槐林荒村
    n30_qionggui:   ['paper', 'coins', '#e8dcc0', '借錢單', '（一張張欠單飛埋嚟：「借我十蚊……」）', '（一張張欠單飛過來：「借我十塊……」）'],
    n30_danxiao:    ['sound', 'scream', '#ffd0d0', '自己先嚇親', '（隻鬼自己先嗌：「呀——！有人呀！」）', '（那隻鬼自己先尖叫：「啊——！有人啊！」）'],
    n30_maoshi:     ['sound', 'thump', '#d8c8a8', '跌爛嘢', '（成疊文件夾「乒乒乓乓」跌落地）', '（一疊文件夾「乒乒乓乓」掉到地上）'],
    n30_yangui:     ['breath', 'smoke', '#b0b0b0', '二手煙', '（無端端一陣煙味，耳邊有人咳：咳咳咳）', '（突然一陣煙味，耳邊有人咳：咳咳咳）'],
    n30_jiugui:     ['breath', 'smoke', '#e8a0a0', '一陣酒氣', '（耳邊一陣酒氣：「飲多杯啦……」）', '（耳邊一陣酒氣：「再喝一杯嘛……」）'],
    n30_dugui:      ['sound', 'coins', '#ffe080', '擲骰仔', '（枱面骰仔自己轉：「大！大！大！」）', '（桌上骰子自己轉：「大！大！大！」）'],
    n30_guhangui:   ['light', 'dark', '#202030', '熄燈慳電', '（「咁嘥電！」佢頭頂盞燈「啪」一聲熄咗）', '（「這麼浪費電！」他頭上的燈「啪」一聲熄了）'],
    n30_taozhai:    ['phone', 'phone', '#ff9a7a', '追數電話', '（電話響：「你仲欠我三萬蚊……」）', '（電話響：「你還欠我三萬塊……」）'],
    n30_diaosi:     ['face', 'tongue', '#ff6a7a', '長舌', '（一條長舌由天花垂到佢面前）', '（一條長舌從天花板垂到他面前）'],
    // 南下古道
    n30_wutou:      ['face', 'copier', '#e0f0ff', '影印個頭', '（影印機玻璃上面，印咗個頭出嚟）', '（影印機玻璃上，印出了一個頭）'],
    n30_changgui:   ['sound', 'whisper', '#c0d0ff', '叫你過去', '（有人輕輕叫佢個名：「過嚟呀……」）', '（有人輕輕叫他的名字：「過來呀……」）'],
    n30_guixinniang:['face', 'veil', '#ff4a5a', '紅蓋頭', '（一塊紅蓋頭飄落佢個頭度）', '（一塊紅蓋頭飄落在他頭上）'],
    n30_baigujing:  ['face', 'bones', '#f0ecd8', '杯中白骨', '（佢杯茶浮起一隻手指骨）', '（他的茶裡浮起一節指骨）'],
    n30_shanxiao:   ['sound', 'thump', '#a08060', '單腳跳', '（天花板：咚、咚、咚，有人單腳跳）', '（天花板：咚、咚、咚，有人單腳跳）'],
    n30_yecha:      ['face', 'flash', '#60e0a0', '青面獠牙', '（螢幕反光入面，多咗塊青面獠牙）', '（螢幕倒影裡，多了一張青面獠牙）'],
    n30_hanba:      ['light', 'heat', '#ff8040', '大旱', '（冷氣停咗，佢周圍熱到冒煙）', '（冷氣停了，他周圍熱得冒煙）'],
    // 甘榜夜路
    n30_pelesit:    ['sound', 'whisper', '#b0e070', '蟋蟀叫', '（耳邊「唧唧唧」，越嚟越近）', '（耳邊「唧唧唧」，越來越近）'],
    n30_polong:     ['shadow', 'smoke', '#a070d0', '樽入面有嘢', '（佢個水樽入面，有樣嘢郁咗一下）', '（他的水瓶裡，有東西動了一下）'],
    n30_jenglot:    ['face', 'hair', '#3a2a20', '長指甲', '（鍵盤罅隙伸出幾隻長指甲）', '（鍵盤縫裡伸出幾根長指甲）'],
    n30_hantugalah: ['shadow', 'shadow', '#101018', '竹竿影', '（佢後面一條好高好高嘅影）', '（他身後一條很高很高的影子）'],
    n30_jerangkung: ['sound', 'bones', '#e8e0c8', '骨頭聲', '（咔、咔、咔，好似有人喺度郁骨）', '（咔、咔、咔，像有人在活動骨頭）'],
    n30_bunian:     ['sound', 'whisper', '#a0f0c0', '隱形人傾偈', '（空嘅位傳出有人傾偈同笑聲）', '（空位置傳來有人聊天和笑聲）'],
    n30_hanturaya:  ['shadow', 'shadow', '#000000', '影大咗兩倍', '（佢個影突然大咗兩倍，仲識自己郁）', '（他的影子突然大了兩倍，還會自己動）'],
    n30_genderuwo:  ['breath', 'smoke', '#806048', '毛手', '（後頸俾一隻毛手掃咗一下）', '（後頸被一隻毛手掃了一下）'],
    // 香蕉園外
    n30_phiam:      ['breath', 'smoke', '#7080a0', '壓胸口', '（胸口突然好重，透唔到氣）', '（胸口突然好重，喘不過氣）'],
    n30_churel:     ['shadow', 'prints', '#c0a0ff', '倒轉腳印', '（地上一行濕腳印，腳趾向後）', '（地上一行濕腳印，腳趾朝後）'],
    n30_tikbalang:  ['sound', 'thump', '#c09060', '馬蹄聲', '（走廊傳嚟馬蹄聲：躂躂、躂躂）', '（走廊傳來馬蹄聲：噠噠、噠噠）'],
    n30_maenak:     ['phone', 'phone', '#ffb0d0', '鬼妻來電', '（電話：「老公，幾時返屋企呀……」）', '（電話：「老公，什麼時候回家呀……」）'],
    n30_aswang:     ['shadow', 'shadow', '#302040', '影變大鳥', '（佢個影變咗一隻大鳥，拍一拍翼）', '（他的影子變成一隻大鳥，拍了拍翅膀）'],
    n30_vetala:     ['face', 'hair', '#90a0b0', '倒吊', '（一個人倒吊喺佢面前，望住佢笑）', '（一個人倒吊在他面前，看著他笑）'],
    n30_banshee:    ['sound', 'scream', '#d0e0ff', '報喪', '（窗外一聲好長好長嘅尖叫）', '（窗外一聲好長好長的尖叫）', true],
    // 冥街夜市（日本妖怪）
    n30_kasaobake:  ['shadow', 'shadow', '#704030', '單腳傘', '（一把舊遮自己喺佢身邊跳過）', '（一把舊傘自己在他身邊跳過）'],
    n30_chochin:    ['light', 'flash', '#ffa040', '燈籠口', '（檯燈變咗個開大口嘅燈籠）', '（檯燈變成一個張大嘴的燈籠）'],
    n30_kappa:      ['cold', 'drip', '#80c0ff', '天花漏水', '（天花一滴一滴凍水滴落佢頭頂）', '（天花板一滴一滴冰水滴到他頭上）'],
    n30_nopperabo:  ['face', 'screen', '#ffffff', '冇面', '（佢手機自拍鏡頭入面，佢自己冇咗塊面）', '（他手機自拍鏡頭裡，他自己沒有臉）'],
    n30_rokurokubi: ['face', 'hair', '#2a2020', '長頸', '（屏風後面伸出一條好長好長嘅頸）', '（屏風後面伸出一條很長很長的脖子）'],
    n30_kuchisake:  ['paper', 'snip', '#e0e0e0', '較剪自己剪', '（枱上把較剪自己「咔嚓、咔嚓」）', '（桌上的剪刀自己「咔嚓、咔嚓」）'],
    n30_yukionna:   ['cold', 'frost', '#d0f0ff', '凍咖啡', '（佢杯咖啡一秒結冰）', '（他的咖啡一秒結冰）'],
    n30_hannya:     ['face', 'flash', '#ff6060', '般若面', '（玻璃反光：一塊長角嘅面）', '（玻璃反光：一張長角的臉）'],
    n30_gashadokuro:['shadow', 'shadow', '#e8e0d0', '巨型骷髏手', '（窗外一隻巨型骷髏手慢慢掃過）', '（窗外一隻巨大的骷髏手慢慢掃過）'],
    // 橫死路口（各種死法）
    n30_zipai:      ['phone', 'screen', '#80d0ff', '自拍多個人', '（佢部手機自己開咗自拍，背後多咗個人）', '（他的手機自己開了自拍，背後多了一個人）'],
    n30_xiaosi:     ['sound', 'laugh', '#ffe080', '罐頭笑聲', '（附近傳出罐頭笑聲：「哈哈哈哈哈」）', '（附近傳出罐頭笑聲：「哈哈哈哈哈」）'],
    n30_yesi:       ['sound', 'pop', '#ffffff', '彈湯圓', '（微波爐「噗」一聲，彈咗粒湯圓出嚟）', '（微波爐「噗」一聲，彈出一顆湯圓）'],
    n30_shidu:      ['breath', 'smoke', '#a0d070', '餿飯盒', '（雪櫃傳出一陣餿味）', '（冰箱傳出一陣餿味）'],
    n30_daji:       ['light|phone', 'screen', '#ff5050', 'GAME OVER', '（電腦突然彈出 GAME OVER：「再嚟一局？」）', '（電腦突然跳出 GAME OVER：「再來一局？」）'],
    n30_xiasi:      ['face', 'flash', '#ffffff', '突然大叫', '（一塊驚到變形嘅面彈出嚟：「哇！」）', '（一張嚇到變形的臉彈出來：「哇！」）'],
    n30_chehuo:     ['light', 'flash', '#fff8c0', '車頭燈', '（一對車頭燈喺走廊照過嚟）', '（一對車頭燈從走廊照過來）'],
    n30_yezi:       ['sound', 'thump', '#a07040', '跌椰子', '（「咚！」天花跌咗粒椰子落嚟）', '（「咚！」天花板掉下一顆椰子）'],
    n30_liulian:    ['breath', 'smoke', '#e0d060', '榴槤味', '（成間房突然一陣榴槤味）', '（整個房間突然一陣榴槤味）'],
    n30_zhongshu:   ['light', 'heat', '#ff6030', '熱浪', '（佢周圍熱到冒煙，燈都閃埋）', '（他周圍熱得冒煙，燈也在閃）'],
    n30_chengsi:    ['sound', 'pop', '#ffd0a0', '打嗝', '（一個好大嘅嗝喺佢耳邊：嗝——）', '（一個很大的嗝在他耳邊：嗝——）'],
    n30_shedu:      ['shadow', 'shadow', '#304020', '蛇影', '（地上條電線好似蛇咁郁咗一下）', '（地上的電線像蛇一樣動了一下）'],
    n30_diansi:     ['light', 'spark', '#80e0ff', '插蘇火花', '（拖板「啪」一聲噴火花）', '（插座「啪」一聲噴出火花）'],
    n30_dongsi:     ['cold', 'frost', '#c0e8ff', '螢幕結霜', '（佢個螢幕結晒霜）', '（他的螢幕結滿了霜）'],
    n30_leipi:      ['light', 'flash', '#ffffff', '閃電', '（窗外一下閃電，照到佢後面有人）', '（窗外一道閃電，照出他身後有人）'],
    n30_xiangcai:   ['paper', 'snip', '#f0e8d0', '扁人', '（一張扁扁嘅「人」由門罅滑咗入嚟）', '（一張扁扁的「人」從門縫滑了進來）'],
    // 雜鬼（同一種用同一招）
    youhun:  ['breath', 'smoke', '#c8d8ff', '飄過', '（一陣涼風由佢身邊飄過）', '（一陣涼風從他身邊飄過）'],
    zhiren:  ['paper', 'snip', '#f0e0c0', '紙人企起身', '（枱面張紙自己摺咗個紙人企起身）', '（桌上的紙自己摺成一個紙人站起來）'],
    egui:    ['sound', 'pop', '#ffd080', '偷食', '（佢個飯盒自己「咔嚓咔嚓」開咗）', '（他的飯盒自己「咔嚓咔嚓」打開了）'],
    xiaogui: ['sound', 'laugh', '#ffc0c0', '細路笑聲', '（枱底傳出細路仔笑聲：「嘻嘻」）', '（桌底傳出小孩笑聲：「嘻嘻」）'],
    zombie:  ['shadow', 'thump', '#80a080', '一跳一跳', '（玻璃門外：一跳、一跳、一跳）', '（玻璃門外：一跳、一跳、一跳）'],
    shuigui: ['cold', 'drip', '#60a0d0', '濕腳印', '（地上一行濕腳印，凍冰冰）', '（地上一行濕腳印，冰冰涼涼）'],
  };
  const TIERV = { 1:[30, 30], 2:[34, 35], 3:[38, 40] }; // [嚇人力, 陰氣]
  for (const k in SIG) {
    const [ty, fx, col, skill, yue, zh, aoe] = SIG[k];
    const tier = k.startsWith('n30_') && typeof N30_G !== 'undefined' && N30_G[k] ? N30_G[k].t : k in (typeof FODDER !== 'undefined' ? FODDER : {}) ? 0 : 2;
    const [base, cost] = tier ? TIERV[tier] : [26, 28], types = ty.split('|');
    const name = (typeof GHOSTS !== 'undefined' && GHOSTS[k] && GHOSTS[k].name) || (typeof FODDER !== 'undefined' && FODDER[k] && FODDER[k].name) || k;
    SCARE_GHOSTS[k] = { name, skill, type:types[0], types:types.length > 1 ? types : null, base:aoe ? 15 : base, cost:aoe ? 34 : cost, line:T(yue, zh), aoe:!!aoe, fx, col, fxText:skill };
  }
  // 舊嘅大招都加返小特效標記（畫法照舊）
  const ALL = () => Object.keys(SCARE_GHOSTS);

  // ---------- 帶邊幾隻鬼 ----------
  const CN = ['零', '一', '兩', '三', '四', '五', '六'];
  const MAXSQ_BASE = 3; // 升職加名額（presence.js perk('squad')）
  const maxSq = () => MAXSQ_BASE + (typeof Presence !== 'undefined' && Presence.perk ? Presence.perk('squad') : 0);
  const owned = () => { if (typeof S === 'undefined' || !S || !S.ghosts) return []; const ks = []; for (const g of S.ghosts) if (g.k !== 'afu' && SCARE_GHOSTS[g.k] && !ks.includes(g.k)) ks.push(g.k); return ks; };
  const squad = {
    options:owned,
    get() { const o = owned(); let s = (typeof S !== 'undefined' && S && S.scareSquad) || null; if (!s) s = ['tianhua', 'pontianak'].filter(k => o.includes(k)); s = s.filter(k => o.includes(k)).slice(0, maxSq()); if (!s.length) s = o.slice(0, 2); return s; },
    set(ids) { if (typeof S === 'undefined' || !S) return []; const o = owned(); S.scareSquad = (ids || []).filter((k, i, a) => k !== 'afu' && o.includes(k) && a.indexOf(k) === i).slice(0, maxSq()); if (typeof save === 'function') save(); return S.scareSquad.slice(); },
    team() { return ['afu'].concat(this.get()); },
  };

  // ---------- 都市傳說 ----------
  const LV = [0, 40, 110, 220, 380];
  const LVNAME = [T('二十三樓有鬼', '二十三樓有鬼'), T('公司群組傳開', '公司群組傳開'), T('網上瘋傳', '網上瘋傳'), T('上咗新聞', '上了新聞'), T('全城都市傳說', '全城都市傳說')];
  const LVTWIST = [null, T('員工一開工已經心緒不寧', '員工一上班就心神不寧'), T('靈探 KOL 上嚟直播捉鬼', '靈探 KOL 上來直播抓鬼'), T('道士早啲到', '道士會早點到'), T('全城注目：熱度加兩成', '全城注目：熱度加兩成')];
  function legend(loc) { loc = loc || 'office'; const d = (typeof S !== 'undefined' && S && S.legend && S.legend[loc]) || { heat:0, nights:0 }; let lv = 1; while (lv < 5 && d.heat >= LV[lv]) lv++; return { heat:d.heat || 0, lv, nights:d.nights || 0, name:Lx(LVNAME[lv - 1]), next:lv < 5 ? LV[lv] : null, prev:LV[lv - 1] }; }

  // 靈探 KOL：舊公仔（小晴嗰套骨架）換色＋手機環形燈；成晚舉住手機拍（一定望到），好難嚇，嚇到就熱度大增
  const KOL = (weak) => ({ k:'kol', name:T('靈探KOL・Kiki', '靈探KOL・Kiki'), role:T('追鬼直播主・二十萬訂閱', '追鬼直播主・二十萬訂閱'), spr:'npc_it', tint:'hue-rotate(155deg) saturate(1.25)', speed:0.07, influencer:true, phone:true,
    post:[OFFMAP.M(0.40), 0.88, 'film'], work:[7, 11], trips:[['pantry', 2, OFFMAP.SPOT.micro, [5, 8], T('呢度係茶水間，聽講微波爐會自己叮……', '這裡是茶水間，聽說微波爐會自己叮……')], ['meeting', 2, OFFMAP.SPOT.seat2, [5, 8], T('會議室冇人，我哋入去睇睇。', '會議室沒人，我們進去看看。')], ['boss', 1.5, OFFMAP.SPOT.bossVisit, [5, 8], T('老細房，噓……', '老闆房，噓……')]],
    lines:{ work:[T('大家記得 like 同 share！', '大家記得按讚分享！'), T('（對住手機）你哋聽唔聽到？', '（對著手機）你們聽到嗎？'), T('留言話見到嘢？邊度邊度？', '留言說看到東西？哪裡哪裡？')] },
    calm:4, weak:[weak], immune:['light', 'cold', 'breath'], karma:0,
    route:[[OFFMAP.M(0.40), 0.88, 6, 'film']],
    say:{ immune:T('（對住鏡頭）呢啲效果做得唔錯喎。', '（對著鏡頭）這效果做得不錯嘛。'), rational:[T('應該係光暗問題。', '應該是光線問題。'), T('呢條片一定爆！', '這條片一定爆！')], prime:[T('等陣……你哋見唔見到？！', '等等……你們看到了嗎？！')], hit:[T('有嘢！真係有嘢！', '有東西！真的有東西！'), T('（手機都跌埋）', '（手機都掉了）')], weak:T('（直播畫面突然雪花）', '（直播畫面突然雪花）'), shout:T('直播完——！走——！', '直播結束——！快走——！'), flee:T('Kiki 一路尖叫一路直播衝入電梯，條片一晚三百萬 view。', 'Kiki 一路尖叫一路直播衝進電梯，影片一晚三百萬觀看。') },
    chat:[['Kiki', '23:50', T('今晚探二十三樓！留言話見到咩就講！', '今晚探二十三樓！看到什麼就留言！')], ['觀眾', '00:12', T('後面！後面！', '後面！後面！')], ['Kiki', '00:13', T('邊度？！', '哪裡？！')]] });

  // ---------- 一晚開始 ----------
  function rng(seed) { let a = seed | 0; return () => { a = (a + 0x6D2B79F5) | 0; let t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; }
  function night(Sc) {
    const lg = legend(Sc.siteId), R = rng(Sc.seed * 7 + 991);
    Sc.night = { seen:0, nb:0, alone:0, types:new Set(), tricks:new Set(), inf:0, infFled:0, filmed:0, stole:0, foiled:0, bryanOut:0, per:{}, best:null, lv:lg.lv };
    Sc.daoAt = lg.lv >= 4 ? 55 : 0; Sc.daoDelay = lg.lv >= 4 ? 3 : 0;
    if (!Sc.site.pano) return;
    if (lg.lv >= 2) for (const n of Sc.npcs) if (!n.d.guard) { n.shaken = 15; n.fear = 8; } // 二十三樓有鬼嘅講法傳開咗：一開工已經心緒不寧
    if (lg.lv >= 3) { const d = KOL(['sound', 'shadow', 'face', 'phone'][Math.floor(R() * 4)]), n = { d, x:d.post[0], y:d.post[1], wi:0, wait:6, dir:1, fear:0, peak:0, gone:false, exitT:0, bounce:0, look:0, bub:null, bubT:0, act:'film', ph:0, ev:[], _seed:(Sc.seed * 131 + 77) | 0 };
      n.step = { x:n.x, y:n.y, wait:8, act:'film', arrived:true }; Sc.npcs.push(n); Sc.goOut(n, 12 + R() * 15, false, T('大家好！今晚帶大家探二十三樓！', '大家好！今晚帶大家探二十三樓！'), true); }
    const forced = Sc.forceBryan != null ? Sc.forceBryan : null, p = 0.25 + 0.08 * (lg.lv - 1);
    Sc.bryan = (forced != null ? forced : R() < p) ? { at:30 + R() * 30, st:'wait', x:0, y:0.8, cd:4, t:0, R, dir:1, alpha:0 } : null;
  }
  // ---------- 每次嚇到人 ----------
  function onHit(Sc, n, o) {
    const N = Sc.night; if (!N) return;
    if (o.pts > 0) { N.types.add(o.type); N.tricks.add(o.ghost); const P = N.per[o.ghost] = N.per[o.ghost] || { scares:0, fear:0 }; P.scares++; P.fear += o.pts; }
    if (o.clean && o.mk >= 2) N.nb++; if (o.clean && o.alone) N.alone++;
    if (o.pts > 0 && (!N.best || n.fear > N.best.fear)) N.best = { name:n.d.name, fear:n.fear, ghost:o.ghost, room:Sc.site.pano ? OFFMAP.roomAt(n.x).name : '' };
    if (n.d.influencer && o.pts > 0) { N.inf += 3; if (n.fear >= 100) N.infFled = 1; }
    const B = Sc.bryan; // Bryan：你搶先嚇咗佢個目標 → 佢冇得搶；同房嘅人望過嚟 → 可能見到佢
    if (B && B.st === 'stalk' && B.tgt === n && o.pts > 0) { B.st = 'roam'; B.cd = 8; B.tgt = null; N.foiled++; Sc.kpi += 10; Sc.float(n.x, n.y - 0.3, Lx(T('搶先一步！Bryan 冇得搶 +10', '搶先一步！Bryan 搶不到 +10')), '#c9a0ff', 1.6); Sc.bubble ? bryanSay(Sc, T('喂！搶我生意？！', '喂！搶我生意？！')) : 0; }
    if (B && (B.st === 'stalk' || B.st === 'roam') && Sc.sameRoom(n, B) && Math.hypot(n.x - B.x, n.y - B.y) < 0.7) for (const m of Sc.npcs) if (m !== n && !m.d.guard && Sc.sameRoom(m, B) && !m.out && !m.gone) m.lookUp = Math.max(m.lookUp || 0, 3);
  }
  function bryanSay(Sc, s) { const B = Sc.bryan; if (!B) return; B.say = Lx(s); B.sayT = 2.4; }
  // ---------- Bryan ----------
  function tick(Sc, dt) {
    const B = Sc.bryan; if (!B || B.st === 'gone') return; B.t += dt; B.sayT = Math.max(0, (B.sayT || 0) - dt);
    if (B.st === 'wait') { if (Sc.t < B.at) return; const rs = OFFMAP.ROOMS, r = rs[Math.floor(B.R() * rs.length)]; B.x = r.cx; B.y = 0.8; B.st = 'roam'; B.cd = 5; B.alpha = 0; Sc.float(0.5, 0.3, Lx(T('死對頭 Bryan 都嚟咗，佢要搶你嘅 KPI！', '死對頭 Bryan 也來了，他要搶你的 KPI！')), '#c9a0ff', 2.4); bryanSay(Sc, T('今晚呢層樓係我嘅！', '今晚這層樓是我的！')); return; }
    B.alpha = Math.min(0.85, B.alpha + dt * 1.5);
    const move = (tx, ty, sp) => { const dx = tx - B.x, dy = ty - B.y, d = Math.hypot(dx, dy); if (d < sp * dt) { B.x = tx; B.y = ty; return true; } B.x += dx / d * sp * dt; B.y += dy / d * sp * dt; B.dir = dx >= 0 ? 1 : -1; return false; };
    const ok = (n) => n && !n.gone && !n.out && !n.fleeing && !n.d.guard && !n.d.daoshi;
    if (B.st === 'roam') { B.cd -= dt; if (!B.wp || move(B.wp[0], B.wp[1], 0.08)) B.wp = [Math.max(0.15, Math.min(OFFMAP.WW - 0.15, B.x + (B.R() - 0.5) * 0.6)), 0.7 + B.R() * 0.2];
      if (B.cd <= 0) { const c = Sc.npcs.filter(ok); if (c.length) { const sc = (n) => n.fear + (n === Sc.sel ? 20 : 0) + (n.mocked || 0) * 6 + B.R() * 12; B.tgt = c.sort((a, b) => sc(b) - sc(a))[0]; B.st = 'stalk'; B.t = 0; B.side = B.R() < 0.5 ? -1 : 1; } else B.cd = 4; } return; }
    if (B.st === 'stalk') { const n = B.tgt; if (!ok(n)) { B.st = 'roam'; B.cd = 3; return; }
      const arrived = move(n.x + B.side * 0.15, n.y - 0.01, 0.16); if (arrived && B.t > 4) { B.st = 'strike'; B.t = 0; } return; }
    if (B.st === 'strike') { const n = B.tgt; if (B.t < 0.5) return; if (!B.done) { B.done = true; resolve(Sc, B, n); } if (B.t > 1.1) { B.done = false; if (B.st === 'strike') { B.st = 'roam'; B.cd = 14 + B.R() * 6; B.tgt = null; } } return; }
    if (B.st === 'flee') { B.alpha = Math.max(0, B.alpha - dt * 0.8); move(B.x + B.dir * 2, B.y, 0.4); if (B.alpha <= 0) B.st = 'gone'; }
  }
  function resolve(Sc, B, n) {
    if (!n || n.gone || n.out || n.fleeing) return;
    const wits = Sc.npcs.filter(m => m !== n && !m.d.daoshi && Sc.sees(m, { x:B.x, y:B.y }));
    if (wits.length) { // 佢俾人見到：穿崩嘅係佢，唔係你
      B.st = 'flee'; B.dir = B.x < OFFMAP.WW / 2 ? -1 : 1; Sc.night.bryanOut = 1; Sc.kpi += 40;
      Sc.float(B.x, B.y - 0.3, Lf(T('Bryan 穿崩！俾{n}望到，走佬 +40', 'Bryan 穿幫！被{n}看到，溜了 +40'), { n:wits.map(w => w.d.name).join('、') }), '#c9a0ff', 2.2);
      bryanSay(Sc, T('衰咗……走先！', '糟了……先走！'));
      for (const w of wits) if (!w.d.guard) { w.fear = Math.min(99, w.fear + 10); w.peak = Math.max(w.peak, w.fear); Sc.bubble(w, Lx(T('頭先……個著波衫嘅係邊個？！', '剛才……那個穿球衣的是誰？！')), 2.2); }
      return; }
    if (n.fear >= 40) { // 你鋪墊好嘅人：佢搶咗個爆點（分唔計你）
      n.fear += 45; n.peak = Math.max(n.peak, Math.min(100, n.fear)); n.mocked = 0; n.combo = 0; Sc.night.stole++;
      Sc.float(n.x, n.y - 0.3, Lx(T('Bryan 搶咗你嘅爆點！', 'Bryan 搶走了你的爆點！')), '#ff8ad0', 2.2); bryanSay(Sc, T('多謝晒你幫我鋪墊！', '多謝你幫我鋪墊！'));
      if (!Sc.headless) Sc.react(n, 'burst', { src:B.x }); Sc.bubble(n, Lx(T('呀——！', '啊——！')), 1.8);
      if (n.fear >= 100) { n.fleeing = true; if (!Sc.headless) { n.fleeT = Sc.t; n.fleeHold = 0.4; n.trail = [[Sc.t, n.x, n.y]]; } }
    } else { n.fear = Math.min(60, n.fear + 15); n.peak = Math.max(n.peak, n.fear); if (!Sc.headless) Sc.react(n, 'flinch', { src:B.x }); bryanSay(Sc, T('暖下身先。', '先熱熱身。')); }
  }
  // ---------- 畫 ----------
  function draw(Sc, ctx, t) {
    // 靈探 KOL：手機＋環形燈（一直拍緊）
    for (const n of Sc.npcs) if (n.d.influencer && !n.gone && !n.out && Sc.onScreen(n.x, 0.2)) { const [x, y] = Sc.pt(n.vX != null ? n.vX : n.x, n.y), hh = Sc.hh(n.y), s = n.dir || 1, px = x + s * hh * 0.2, py = y - hh * 0.72;
      ctx.save(); ctx.strokeStyle = 'rgba(40,40,50,.9)'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(x + s * hh * 0.08, y - hh * 0.5); ctx.lineTo(px, py); ctx.stroke();
      ctx.fillStyle = '#222'; ctx.fillRect(px - hh * 0.035, py - hh * 0.06, hh * 0.07, hh * 0.11); ctx.globalCompositeOperation = 'lighter'; ctx.strokeStyle = `rgba(255,250,230,${0.7 + 0.2 * Math.sin(t * 3)})`; ctx.lineWidth = 2.5; ctx.beginPath(); ctx.arc(px, py, hh * 0.085, 0, Math.PI * 2); ctx.stroke();
      const g = ctx.createRadialGradient(px, py, 0, px, py, hh * 0.5); g.addColorStop(0, 'rgba(255,250,230,.22)'); g.addColorStop(1, 'rgba(255,250,230,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, hh * 0.5, 0, Math.PI * 2); ctx.fill();
      if (Math.sin(t * 2) > 0) { ctx.globalCompositeOperation = 'source-over'; ctx.fillStyle = '#ff3a3a'; ctx.beginPath(); ctx.arc(px + s * hh * 0.05, py - hh * 0.09, 3, 0, Math.PI * 2); ctx.fill(); ctx.font = '800 9px sans-serif'; ctx.fillText('LIVE', px + s * hh * 0.07 - 4, py - hh * 0.07); }
      ctx.restore(); }
    // Bryan
    const B = Sc.bryan; if (!B || B.st === 'wait' || B.st === 'gone' || typeof Antag === 'undefined') return;
    if (B.st === 'stalk' && B.tgt && !B.tgt.gone && Sc.onScreen(B.tgt.x, 0.1)) { const [tx, ty] = Sc.pt(B.tgt.vX != null ? B.tgt.vX : B.tgt.x, B.tgt.y), hh = Sc.hh(B.tgt.y); ctx.save(); ctx.strokeStyle = `rgba(210,140,255,${0.5 + 0.3 * Math.sin(t * 6)})`; ctx.lineWidth = 2; ctx.setLineDash([5, 4]); ctx.beginPath(); ctx.ellipse(tx, ty, hh * 0.3, hh * 0.08, 0, 0, Math.PI * 2); ctx.stroke(); ctx.restore(); }
    if (!Sc.onScreen(B.x, 0.3)) return;
    const [x, y] = Sc.pt(B.x, B.y), hh = Sc.hh(B.y), fl = Math.sin(t * 2.2) * hh * 0.025 - hh * 0.04;
    const st = B.st === 'strike' ? (B.t < 0.6 ? 'attack' : 'jumpshot') : B.st === 'stalk' ? 'walk' : B.st === 'flee' ? 'scared' : (Math.floor(t / 4) % 2 ? 'spin' : 'dribble');
    ctx.save(); ctx.globalAlpha = B.alpha; ctx.fillStyle = 'rgba(120,60,180,.25)'; ctx.beginPath(); ctx.ellipse(x, y, hh * 0.2, hh * 0.05, 0, 0, Math.PI * 2); ctx.fill();
    try { Antag.draw(ctx, 'npc_rival', x, y + fl, hh * 0.93, st, B.st === 'strike' ? B.t : t, { faceRight:B.dir > 0, alpha:B.alpha, shadow:false, time:t }); } catch (e) {}
    ctx.restore();
    ctx.save(); ctx.font = '800 11px sans-serif'; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = 'rgba(0,0,0,.8)'; const lab = Lx(T('Bryan（死對頭）', 'Bryan（死對頭）')), ty = y - hh * 1.02 + fl; ctx.strokeText(lab, x, ty); ctx.fillStyle = '#d6a8ff'; ctx.fillText(lab, x, ty);
    if (B.sayT > 0 && B.say) { ctx.font = '700 12px sans-serif'; const w = ctx.measureText(B.say).width + 16, bx = Math.max(4, Math.min(Sc.W - w - 4, x - w / 2)); ctx.fillStyle = 'rgba(50,20,70,.92)'; ctx.strokeStyle = '#b48ad8'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(bx, ty - 38, w, 24, 9); ctx.fill(); ctx.stroke(); ctx.fillStyle = '#f0e0ff'; ctx.textAlign = 'left'; ctx.fillText(B.say, bx + 8, ty - 21); }
    ctx.restore();
  }
  // 招牌小把戲：喺目標身邊程式畫（f.sig 特效種類、k = 0~1 進度）
  function sigFx(Sc, ctx, f, t, k) {
    const n = f.n; if (!n || n.gone) return; const vx = n.vX != null ? n.vX : n.x; if (Sc.site.pano && !Sc.onScreen(vx, 0.2)) return;
    const [x, y] = Sc.pt(vx, n.y), hh = Sc.hh(n.y), hx = x, hy = y - hh * 0.8, col = f.col || '#fff', e = Math.min(1, k * 5, (1 - k) * 4), PI = Math.PI;
    const R = (i) => { const v = Math.sin(i * 127.1 + 311.7) * 43758.5; return v - Math.floor(v); };
    const txt = (s, xx, yy, sz, a, c) => { ctx.save(); ctx.globalAlpha *= a; ctx.font = `900 ${Math.round(sz)}px sans-serif`; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = '#1a1020'; ctx.strokeText(s, xx, yy); ctx.fillStyle = c || '#fff3d0'; ctx.fillText(s, xx, yy); ctx.restore(); };
    ctx.save(); ctx.globalAlpha = e; ctx.lineCap = 'round';
    switch (f.sig) {
      case 'frost': for (let i = 0; i < 14; i++) { const a = R(i) * PI * 2, r = hh * (0.1 + 0.35 * k * R(i + 3)); ctx.strokeStyle = 'rgba(220,245,255,.9)'; ctx.lineWidth = 1.6; const cx = hx + Math.cos(a) * r, cy = hy + hh * 0.2 + Math.sin(a) * r * 0.6; for (let j = 0; j < 3; j++) { const b = j * PI / 3; ctx.beginPath(); ctx.moveTo(cx - Math.cos(b) * 4, cy - Math.sin(b) * 4); ctx.lineTo(cx + Math.cos(b) * 4, cy + Math.sin(b) * 4); ctx.stroke(); } }
        ctx.fillStyle = 'rgba(200,235,255,.85)'; ctx.fillRect(hx + hh * 0.18, hy + hh * 0.25, hh * 0.08, hh * 0.1); ctx.strokeStyle = '#fff'; ctx.strokeRect(hx + hh * 0.18, hy + hh * 0.25, hh * 0.08, hh * 0.1); txt('冰', hx + hh * 0.22, hy + hh * 0.33, hh * 0.07, 1, '#2a6a9a'); break;
      case 'copier': { const w = hh * 0.55, h = hh * 0.32, bx = hx - w / 2, by = hy - hh * 0.45; ctx.fillStyle = 'rgba(180,255,210,.35)'; ctx.fillRect(bx, by, w, h); ctx.strokeStyle = 'rgba(200,255,220,.9)'; ctx.lineWidth = 2; ctx.strokeRect(bx, by, w, h);
        if (typeof ART !== 'undefined' && ART.portrait) { const pc = ART.portrait(f.ghost, 96, { tamed:true }); ctx.globalAlpha = e * 0.85; ctx.globalCompositeOperation = 'luminosity'; ctx.drawImage(pc, hx - h * 0.45, by + h * 0.05, h * 0.9, h * 0.9); } ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = 'rgba(150,255,190,.5)'; ctx.fillRect(bx, by + h * ((t * 1.5) % 1), w, 3); break; }
      case 'pop': for (let i = 0; i < 6; i++) { const q = Math.min(1, k * 2.2 - i * 0.12); if (q <= 0) continue; const px = hx + (R(i) - 0.5) * hh * 0.9 * q, py = hy - hh * 0.2 - Math.sin(q * PI) * hh * 0.5 + q * hh * 0.2; ctx.fillStyle = col; ctx.strokeStyle = '#776'; ctx.lineWidth = 1; ctx.beginPath(); ctx.arc(px, py, hh * 0.035, 0, PI * 2); ctx.fill(); ctx.stroke(); } txt('噗！', hx, hy - hh * 0.5, hh * 0.12, 1); break;
      case 'screen': { const w = hh * 0.6, h = hh * 0.38, bx = hx - w / 2, by = hy - hh * 0.55; ctx.fillStyle = '#101018'; ctx.fillRect(bx, by, w, h); ctx.strokeStyle = '#555'; ctx.lineWidth = 3; ctx.strokeRect(bx, by, w, h);
        const bl = Math.sin(t * 9) > 0; ctx.fillStyle = col; ctx.font = `900 ${Math.round(h * 0.26)}px monospace`; ctx.textAlign = 'center'; if (bl || f.ghost !== 'n30_daji') ctx.fillText(f.ghost === 'n30_daji' ? 'GAME OVER' : f.ghost === 'n30_nopperabo' ? '（冇面）' : '+1', hx, by + h * 0.58);
        ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(hx, by + h / 2, 0, hx, by + h / 2, w); g.addColorStop(0, 'rgba(255,90,90,.25)'); g.addColorStop(1, 'rgba(255,90,90,0)'); ctx.fillStyle = g; ctx.fillRect(bx - w / 2, by - h, w * 2, h * 3); break; }
      case 'spark': for (let i = 0; i < 7; i++) { if (Math.random() < 0.4) continue; const a = R(i + Math.floor(t * 20)) * PI * 2, L0 = hh * (0.15 + 0.2 * Math.random()); ctx.strokeStyle = i % 2 ? '#fff' : col; ctx.lineWidth = 2; ctx.beginPath(); let px = hx, py = y - hh * 0.15; ctx.moveTo(px, py); for (let j = 0; j < 4; j++) { px += Math.cos(a) * L0 / 4 + (Math.random() - 0.5) * 8; py += Math.sin(a) * L0 / 4 + (Math.random() - 0.5) * 8; ctx.lineTo(px, py); } ctx.stroke(); } txt('啪！', hx + hh * 0.25, y - hh * 0.35, hh * 0.1, 1); break;
      case 'snip': { const sx = hx + hh * 0.25, sy = hy - hh * 0.1, op = Math.abs(Math.sin(t * 12)) * 0.6; ctx.strokeStyle = '#ddd'; ctx.lineWidth = 3; for (const s of [-1, 1]) { ctx.beginPath(); ctx.moveTo(sx, sy); ctx.lineTo(sx + Math.cos(s * op) * hh * 0.18, sy + Math.sin(s * op) * hh * 0.18); ctx.stroke(); ctx.beginPath(); ctx.arc(sx - Math.cos(-s * op) * hh * 0.04, sy - Math.sin(-s * op) * hh * 0.04, 4, 0, PI * 2); ctx.stroke(); }
        for (let i = 0; i < 6; i++) { const q = (k * 1.5 + R(i)) % 1; ctx.fillStyle = col; ctx.save(); ctx.translate(sx + (R(i + 1) - 0.5) * hh * 0.5, sy + q * hh * 0.7); ctx.rotate(t * 3 + i); ctx.fillRect(-4, -1.5, 8, 3); ctx.restore(); } txt('咔嚓', sx, sy - hh * 0.15, hh * 0.08, 1); break; }
      case 'drip': for (let i = 0; i < 8; i++) { const q = (t * 1.3 + R(i)) % 1, dx = hx + (R(i + 2) - 0.5) * hh * 0.3; ctx.fillStyle = col; ctx.beginPath(); ctx.ellipse(dx, hy - hh * 0.9 + q * hh * 0.85, 2.5, 4, 0, 0, PI * 2); ctx.fill(); } ctx.fillStyle = 'rgba(120,180,230,.35)'; ctx.beginPath(); ctx.ellipse(hx, y, hh * 0.25 * Math.min(1, k * 3), hh * 0.05, 0, 0, PI * 2); ctx.fill(); txt('滴……滴……', hx, hy - hh * 0.6, hh * 0.08, 1); break;
      case 'laugh': for (let i = 0; i < 5; i++) { const q = (k * 1.6 + i / 5) % 1; txt('哈', hx + (R(i) - 0.5) * hh * 0.9, hy - q * hh * 0.6, hh * (0.08 + 0.05 * R(i + 3)), Math.sin(q * PI), col); } break;
      case 'smoke': for (let i = 0; i < 7; i++) { const q = (k * 1.2 + i / 7) % 1, px = hx + (R(i) - 0.5) * hh * 0.4 + Math.sin(t * 2 + i) * 6, py = hy + hh * 0.2 - q * hh * 0.5, r = hh * (0.06 + 0.12 * q); const g = ctx.createRadialGradient(px, py, 0, px, py, r); g.addColorStop(0, col); g.addColorStop(1, 'rgba(0,0,0,0)'); ctx.globalAlpha = e * 0.55 * (1 - q); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, r, 0, PI * 2); ctx.fill(); } break;
      case 'shadow': { ctx.globalAlpha = e * 0.55; const sx = hx - (n.dir || 1) * hh * 0.3, H = hh * (1.3 + 0.5 * k); ctx.fillStyle = col === '#e8e8f0' || col === '#e8e0d0' ? 'rgba(230,230,240,.5)' : 'rgba(5,3,12,.85)'; ctx.beginPath(); ctx.ellipse(sx, y - H * 0.5, hh * 0.22, H * 0.5, 0, 0, PI * 2); ctx.fill(); ctx.beginPath(); ctx.arc(sx, y - H * 0.98, hh * 0.13, 0, PI * 2); ctx.fill(); break; }
      case 'coins': for (let i = 0; i < 9; i++) { const q = Math.min(1, k * 2 - R(i) * 0.4); if (q <= 0) continue; const px = hx + (R(i) - 0.5) * hh * 0.8, py = hy - hh * 0.3 + q * hh * 0.9 - Math.sin(q * PI) * hh * 0.3; ctx.fillStyle = col; ctx.save(); ctx.translate(px, py); ctx.rotate(t * 5 + i); ctx.scale(Math.cos(t * 8 + i), 1); ctx.beginPath(); ctx.ellipse(0, 0, 5, 5, 0, 0, PI * 2); ctx.fill(); ctx.restore(); } txt('叮噹', hx, hy - hh * 0.4, hh * 0.08, 1); break;
      case 'hair': case 'veil': case 'tongue': { const L1 = hh * (0.2 + 0.8 * Math.min(1, k * 2.5)); if (f.sig === 'tongue') { ctx.fillStyle = col === '#ffffff' ? '#e04a5a' : col; ctx.beginPath(); ctx.moveTo(hx - 5, hy - hh * 1.2); ctx.quadraticCurveTo(hx - 8 + Math.sin(t * 3) * 4, hy - hh * 1.2 + L1 * 0.6, hx, hy - hh * 1.2 + L1); ctx.quadraticCurveTo(hx + 8, hy - hh * 1.2 + L1 * 0.6, hx + 5, hy - hh * 1.2); ctx.fill(); }
        else if (f.sig === 'veil') { const vy = hy - hh * 0.9 + Math.min(1, k * 2) * hh * 0.75; ctx.fillStyle = col; ctx.beginPath(); ctx.moveTo(hx - hh * 0.2, vy); ctx.quadraticCurveTo(hx, vy - hh * 0.15, hx + hh * 0.2, vy); ctx.lineTo(hx + hh * 0.17 + Math.sin(t * 4) * 3, vy + hh * 0.22); ctx.lineTo(hx - hh * 0.17, vy + hh * 0.22); ctx.fill(); ctx.fillStyle = '#ffd36a'; ctx.fillRect(hx - hh * 0.17, vy + hh * 0.2, hh * 0.34, 3); }
        else { ctx.strokeStyle = col; ctx.lineWidth = 2.5; for (let i = 0; i < 14; i++) { const sx = hx + (i - 7) * hh * 0.025; ctx.beginPath(); ctx.moveTo(sx, hy - hh * 1.1); ctx.quadraticCurveTo(sx + Math.sin(t * 2 + i) * 6, hy - hh * 1.1 + L1 * 0.5, sx + Math.sin(t * 1.5 + i) * 10, hy - hh * 1.1 + L1); ctx.stroke(); } } break; }
      case 'bones': for (let i = 0; i < 4; i++) { const px = hx + (i - 1.5) * hh * 0.16 + Math.sin(t * 20 + i) * 3, py = hy - hh * 0.25 + Math.cos(t * 17 + i) * 3; ctx.fillStyle = col; ctx.save(); ctx.translate(px, py); ctx.rotate(i + Math.sin(t * 10) * 0.4); ctx.fillRect(-hh * 0.05, -2, hh * 0.1, 4); ctx.beginPath(); ctx.arc(-hh * 0.05, 0, 3.5, 0, PI * 2); ctx.arc(hh * 0.05, 0, 3.5, 0, PI * 2); ctx.fill(); ctx.restore(); } txt('咔咔咔', hx, hy - hh * 0.45, hh * 0.08, 1); break;
      case 'thump': { const q = (k * 4) % 1; ctx.strokeStyle = 'rgba(255,240,200,.8)'; ctx.lineWidth = 2; ctx.beginPath(); ctx.ellipse(hx, hy - hh * 0.5, hh * (0.1 + q * 0.4), hh * (0.03 + q * 0.08), 0, 0, PI * 2); ctx.stroke(); txt('咚！', hx + (R(Math.floor(k * 4)) - 0.5) * hh * 0.4, hy - hh * 0.55, hh * 0.13, 1 - q * 0.5); break; }
      case 'flash': { const on = Math.sin(t * 30) > 0.2; if (on) { ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(hx, hy, 0, hx, hy, hh * 1.4); g.addColorStop(0, col + '88'); g.addColorStop(1, 'rgba(0,0,0,0)'); ctx.fillStyle = g; ctx.fillRect(hx - hh * 1.4, hy - hh * 1.4, hh * 2.8, hh * 2.8); }
        if (typeof ART !== 'undefined' && ART.portrait && k > 0.3 && k < 0.7) { const pc = ART.portrait(f.ghost, 96, { tamed:true }), sz = hh * 0.45; ctx.globalCompositeOperation = 'source-over'; ctx.globalAlpha = e * 0.6; ctx.drawImage(pc, hx - (n.dir || 1) * hh * 0.45 - sz / 2, hy - hh * 0.45, sz, sz); } break; }
      case 'heat': for (let i = 0; i < 8; i++) { const q = (t * 0.9 + i / 8) % 1, px = hx + (i - 4) * hh * 0.07; ctx.strokeStyle = `rgba(255,${120 + i * 10},60,${0.6 * (1 - q)})`; ctx.lineWidth = 2; ctx.beginPath(); ctx.moveTo(px, y - q * hh * 1.1); ctx.quadraticCurveTo(px + Math.sin(t * 6 + i) * 6, y - q * hh * 1.1 - 10, px, y - q * hh * 1.1 - 20); ctx.stroke(); } txt('熱……', hx, hy - hh * 0.45, hh * 0.08, 1); break;
      case 'phone': { const px = hx + (n.dir || 1) * hh * 0.25, py = hy - hh * 0.15, sh = Math.sin(t * 40) * 2; ctx.fillStyle = '#222'; ctx.fillRect(px - 6 + sh, py - 10, 12, 20); ctx.fillStyle = col; ctx.fillRect(px - 4 + sh, py - 8, 8, 13); for (let i = 1; i <= 3; i++) { ctx.strokeStyle = `rgba(255,255,255,${0.7 - i * 0.18})`; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.arc(px, py, 8 + i * 6, -0.8, 0.8); ctx.stroke(); ctx.beginPath(); ctx.arc(px, py, 8 + i * 6, PI - 0.8, PI + 0.8); ctx.stroke(); } txt('鈴鈴鈴', px, py - 24, hh * 0.07, 1); break; }
      case 'whisper': for (let i = 0; i < 3; i++) { const q = (k * 1.3 + i / 3) % 1; txt(f.ghost === 'n30_pelesit' ? '唧' : '……', hx - (n.dir || 1) * hh * (0.2 + q * 0.3), hy - hh * 0.1 - q * hh * 0.2, hh * 0.07, Math.sin(q * PI) * 0.8, col); } break;
      case 'scream': { const s = 1 + Math.sin(t * 25) * 0.05; txt('呀——！', hx + Math.sin(t * 30) * 3, hy - hh * 0.5, hh * 0.13 * s, 1, col); break; }
      case 'prints': for (let i = 0; i < 5; i++) { const q = Math.min(1, k * 3 - i * 0.3); if (q <= 0) continue; const px = hx + (i - 2.5) * hh * 0.14 * -(n.dir || 1), py = y + (i % 2 ? 4 : -4); ctx.globalAlpha = e * q * 0.8; ctx.fillStyle = col; ctx.beginPath(); ctx.ellipse(px, py, 5, 2.5, 0, 0, PI * 2); ctx.fill(); for (let j = 0; j < 3; j++) { ctx.beginPath(); ctx.arc(px + (n.dir || 1) * 6, py - 2 + j * 2, 1.2, 0, PI * 2); ctx.fill(); } } break;
      case 'dark': { const g = ctx.createRadialGradient(hx, hy, hh * 0.2, hx, hy, hh * 1.3); g.addColorStop(0, 'rgba(0,0,0,0)'); g.addColorStop(1, 'rgba(0,0,10,.75)'); ctx.fillStyle = g; ctx.fillRect(hx - hh * 1.5, hy - hh * 1.5, hh * 3, hh * 3); txt('啪', hx, hy - hh * 0.6, hh * 0.1, 1); break; }
    }
    ctx.restore();
    if (k > 0.1 && k < 0.8 && f.sigText) txt(Lx(f.sigText), hx, y + hh * 0.12, Math.max(12, hh * 0.075), Math.min(1, (k - 0.1) * 6, (0.8 - k) * 6), '#e8c8ff');
  }

  // ---------- 收工：傳說熱度、假帖文／新聞標題、事件 ----------
  function finish(Sc, stars, quit) {
    const N = Sc.night || { per:{}, types:new Set(), seen:0, nb:0, alone:0, inf:0, infFled:0, filmed:0, stole:0, bryanOut:0, foiled:0 }, loc = Sc.siteId;
    const before = legend(loc);
    let heat = Sc.kpi / 120 + 8 * N.nb + 4 * N.alone + 2 * N.types.size + (N.seen ? -3 * N.seen : 6) + N.inf + 20 * N.infFled + 4 * N.filmed + 5 * N.bryanOut - (Sc.expelled ? 10 : 0) - (quit ? 5 : 0);
    heat = Math.max(0, Math.round(heat * (before.lv >= 5 ? 1.2 : 1)));
    if (typeof S !== 'undefined' && S) { S.legend = S.legend || {}; const d = S.legend[loc] = S.legend[loc] || { heat:0, nights:0 }; d.heat += heat; d.nights++; }
    const after = legend(loc), up = after.lv > before.lv;
    const ghosts = Sc.team ? Sc.team.slice() : [], perGhost = {}; for (const k in N.per) perGhost[k] = { scares:N.per[k].scares, fear:Math.round(N.per[k].fear) };
    try { window.dispatchEvent(new CustomEvent('gb:nightEnd', { detail:{ loc, score:Sc.kpi, stars, heat, legendLv:after.lv, ghosts, perGhost, exposed:N.seen > 0, exorcised:!!Sc.expelled, bryanStole:N.stole } })); } catch (e) {}
    // 假帖文：按傳說等級揀平台，內容用今晚最勁嗰一幕
    const b = N.best, who = b ? b.name : Lx(T('一個 OT 員工', '一個加班員工')), room = b && b.room ? b.room : Lx(T('二十三樓', '二十三樓')), trick = b && SCARE_GHOSTS[b.ghost] ? SCARE_GHOSTS[b.ghost].skill : '';
    const views = Math.round((after.heat + 20) * (3 + after.lv * 4)) / 10;
    const P = [
      [T('WhatsApp・公司 OT 群', 'WhatsApp・公司加班群'), T('{who}話喺{room}見到嘢，冇人信佢（笑）', '{who}說在{room}看到東西，沒人信他（笑）'), T('三個人已讀', '三人已讀')],
      [T('連登・靈異台', '論壇・靈異版'), T('【真人真事】我公司二十三樓半夜{trick}', '【真人真事】我公司二十三樓半夜{trick}'), T('{v} 千人睇過', '{v} 千人看過')],
      [T('Threads・熱門', 'Threads・熱門'), T('#二十三樓有鬼　{who}嘅反應笑死，但係……後面嗰個係咩？', '#二十三樓有鬼　{who}的反應笑死，但是……後面那個是什麼？'), T('{v} 萬瀏覽', '{v} 萬瀏覽')],
      [T('晚間新聞', '晚間新聞'), T('【獨家】商廈二十三樓夜半怪事頻生　員工：「{trick}，唔係講笑」', '【獨家】商廈二十三樓夜半怪事頻生　員工：「{trick}，不是開玩笑」'), T('記者現場直擊', '記者現場直擊')],
      [T('全城熱話', '全城熱話'), T('旅行團排隊參觀「二十三樓」，陳總：「門票收一百蚊」', '旅行團排隊參觀「二十三樓」，陳總：「門票收一百塊」'), T('{v} 萬人討論', '{v} 萬人討論')],
    ][after.lv - 1];
    const fill = (s) => Lf(s, { who, room, trick:trick || Lx(T('有怪聲', '有怪聲')), v:views });
    const extra = [N.nb ? Lf(T('無人信佢 ×{n}', '沒人信他 ×{n}'), { n:N.nb }) : '', N.alone ? Lf(T('落單爆點 ×{n}', '落單爆點 ×{n}'), { n:N.alone }) : '', N.types.size ? Lf(T('招式 {n} 種', '招式 {n} 種'), { n:N.types.size }) : '', N.seen ? Lf(T('穿崩 ×{n}', '穿幫 ×{n}'), { n:N.seen }) : Lx(T('冇穿崩', '沒穿幫')), N.inf ? Lx(T('嚇到靈探 KOL', '嚇到靈探 KOL')) : '', N.filmed ? Lx(T('俾 KOL 拍到', '被 KOL 拍到')) : '', N.stole ? Lf(T('Bryan 搶咗 {n} 次', 'Bryan 搶了 {n} 次'), { n:N.stole }) : '', N.bryanOut ? Lx(T('Bryan 穿崩走佬', 'Bryan 穿幫溜走')) : ''].filter(Boolean).join('・');
    const pct = after.next ? Math.round((after.heat - after.prev) / (after.next - after.prev) * 100) : 100;
    return `<div class="sc-legend"><div class="scl-h"><b>${Lx(T('都市傳說', '都市傳說'))}　Lv${after.lv}「${after.name}」</b><span>${Lx(T('熱度', '熱度'))} +${heat}</span></div>
      <div class="scl-bar"><i style="width:${pct}%"></i></div>${up ? `<p class="scl-up">${Lx(T('傳說升級！', '傳說升級！'))}${LVTWIST[after.lv - 1] ? Lx(LVTWIST[after.lv - 1]) : ''}</p>` : ''}
      <div class="scl-post"><small>${Lx(P[0])}</small><p>${fill(P[1])}</p><small>${fill(P[2])}</small></div><p class="scl-x">${extra}</p></div>`;
  }

  // ---------- 揀隊（取代舊嘅三揀二） ----------
  function open(siteId) {
    Scare.migrate(); const site = SCARE_SITES[siteId], opts = owned(); let chosen = squad.get().slice();
    const npcs = site.npcs.filter(d => !d.guard);
    const weakCount = (t) => npcs.filter(d => d.weak.includes(t)).length, immCount = (t) => npcs.filter(d => d.immune.includes(t)).length;
    const render = () => {
      const best = (S.scare && S.scare.best[siteId]) || 0, st = Scare.starsOf(siteId, best), lg = legend(siteId);
      let h = `<p class="desc">${site.name}。${Lf(T('揀今晚帶邊幾隻鬼：招式啱佢哋怕嘅嘢，先嚇得到人。阿福一定去，另外最多帶{n}隻。', '選今晚帶哪幾隻鬼：招式對上他們怕的東西，才嚇得到人。阿福一定去，另外最多帶{n}隻。'), { n:CN[maxSq()] })}</p>`;
      h += `<p class="desc">最高紀錄：${best}　${'★'.repeat(st)}${'☆'.repeat(3 - st)}　｜　${Lx(T('都市傳說', '都市傳說'))} Lv${lg.lv}「${lg.name}」</p>`;
      h += `<div class="sq-who">${npcs.map(d => `<span><b>${d.name}</b> 怕 ${d.weak.map(t => (d.hide || []).includes(t) && !((Scare.known || {})[d.k] || new Set()).has(t) ? '？' : FEAR_WORD[t]).join('、')}</span>`).join('')}</div>`;
      const card = (k, fixed) => { const g = SCARE_GHOSTS[k], ts = g.types || [g.type], w = ts.reduce((s, t) => s + weakCount(t), 0), im = ts.every(t => immCount(t) > 0) && w === 0;
        return `<button class="sq-g ${fixed || chosen.includes(k) ? 'on' : ''} ${w >= 2 ? 'good' : im ? 'bad' : ''}" data-k="${k}" ${fixed ? 'disabled' : ''}><canvas data-por="${k}"></canvas><b>${g.name}</b><small>${g.skill}</small><i>${ts.map(t => FEAR_WORD[t]).join('／')}${g.aoe ? '・全場' : ''}・${g.cost || 35}</i>${w ? `<em>${w}人怕</em>` : ''}</button>`; };
      h += `<div class="sq-grid">${card('afu', true)}${opts.map(k => card(k)).join('')}</div>`;
      h += `<p class="desc">${Lx(T('已揀', '已選'))} ${chosen.length}/${maxSq()}：${chosen.map(k => SCARE_GHOSTS[k].name).join('、') || '—'}</p>${typeof Rework !== 'undefined' ? Rework.kitHTML() : ''}<button class="btn gold wide" id="sc-go">出發，回陽間</button>`;
      return h;
    };
    const bind = () => {
      paintPortraits($('#sheet'));
      if (typeof Rework !== 'undefined') Rework.bindKit($('#sheet'));
      $('#sheet').querySelectorAll('.sq-g:not([disabled])').forEach(b => b.onclick = () => { const k = b.dataset.k; if (chosen.includes(k)) chosen.splice(chosen.indexOf(k), 1); else if (chosen.length < maxSq()) chosen.push(k); else { Fx.toast(Lf(T('最多帶{n}隻', '最多帶{n}隻'), { n:CN[maxSq()] })); return; } const sc = $('#sheet .sh-body').scrollTop; $('#sheet .sh-body').innerHTML = render(); $('#sheet .sh-body').scrollTop = sc; bind(); });
      $('#sc-go').onclick = () => { squad.set(chosen); UI.close(); Scare.start(siteId, ['afu'].concat(squad.get())); };
    };
    UI.sheet('回陽間・帶隊出更', render()); bind();
  }
  Scare.squad = squad; Scare.legend = legend;
  return { SIG, open, night, tick, onHit, draw, sigFx, finish, legend, squad, KOL };
})();
