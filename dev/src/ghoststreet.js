// ===================== 冥街夜市：下班後的陰間 =====================
// 一條比螢幕寬的老街。阿福在石板路上走（點地面／按住拖），鏡頭跟著。
// 攤位：紙紮鋪（永久小加成）、講價攤（看臉色講價）、冥幣兌換（地府科技股）、宵夜檔（下一場戰鬥的加成）、暗巷（隨機事件）。
// 存檔：S.street（見 GhostStreet.st()）。其他檔案要接的加成，用 GhostStreet.mul() / bonus() / battleBuffs()。

const GS_STALLS = {
  paper: { name:'紙紮鋪', x:0.13, sx:0.15, face:1, x0:0.015, x1:0.255, keeper:'xiaozhi', kx:0.232, ky:0.745 },
  haggle:{ name:'講價攤', x:0.37, sx:0.385, face:-1, x0:0.275, x1:0.47, keeper:'xiaogui', kx:0.300, ky:0.742 },
  exch:  { name:'冥幣兌換', x:0.58, sx:0.605, face:-1, x0:0.49, x1:0.665, keeper:'baiwu', kx:0.525, ky:0.738 },
  food:  { name:'宵夜檔', x:0.78, sx:0.78, face:1, x0:0.675, x1:0.875, keeper:'eguiking', kx:0.805, ky:0.745 },
  alley: { name:'暗巷', x:0.945, sx:0.93, face:1, x0:0.885, x1:1.0 },
};
const GS_ORDER = ['paper', 'haggle', 'exch', 'food', 'alley'];

// 紙紮鋪：燒一次，永久生效
const GS_EFFIGY = {
  phone: { name:'紙紮手機', price:400, eff:'回陽間夜班：開局陰氣 +25', say:'最新款，五個鏡頭——全部拍不到你。訊號直通陽間，夜班開工前先充好陰氣。' },
  car:   { name:'紙紮跑車', price:600, eff:'村子裡走路速度 +15%', say:'油門是畫上去的，開不動。不過背著它跑步，不知道為什麼就是快了。' },
  coffee:{ name:'紙紮咖啡機', price:700, eff:'砍樹、割稻、做板、包包子快 10%', say:'一杯下去，死人也能加班。副作用：凌晨三點會想回覆電郵。' },
  chair: { name:'紙紮按摩椅', price:900, eff:'出征時我方血量 +5%', say:'按完腰不痛了。雖然你本來就沒有腰，但是心理上舒服。' },
};

// 講價攤的貨：col = 收藏家收購價（公開）。小鬼的底價藏起來，每天不一樣。
const GS_ITEMS = [
  { id:'soup',   name:'二手孟婆湯（只喝了一半）', col:120, desc:'前主人喝到一半想起前任，不喝了。保證只忘一半。' },
  { id:'gramo',  name:'只會播《夜上海》的留聲機', col:200, desc:'斷了一根弦，所以《夜上海》聽起來像《夜加班》。' },
  { id:'clock',  name:'永遠慢五分鐘的掛鐘', col:90,  desc:'從舊公司牆上拆下來的。專門讓員工以為還沒到下班時間。' },
  { id:'cage',   name:'空鳥籠', col:70, desc:'鳥已經投胎了，籠子還在等牠回來辦交接。' },
  { id:'vase',   name:'青花瓷花瓶', col:160, desc:'底部印著「陰間製造」。品質有保障，保到下輩子。' },
  { id:'chest',  name:'打不開的寶箱', col:240, desc:'鑰匙在陽間某個抽屜裡。搖起來有聲音，可能是金子，可能是遙控器電池。' },
  { id:'promise',name:'黃總親筆加薪承諾書', col:60, desc:'白紙黑字：「明年一定加。」日期是四十年前。' },
  { id:'punch',  name:'會自己打卡的打卡機', col:150, desc:'半夜三點自己「咔嚓」一聲，嚇跑了三任保安。' },
  { id:'malt',   name:'過期三十年的麥芽沖劑', col:50, desc:'結成一塊磚。敲下來可以當武器，也可以當早餐。' },
  { id:'bell',   name:'牛頭大哥的退休牛鈴', col:110, desc:'一搖，整條街的鬼都以為收工了。' },
  { id:'nails',  name:'Pontianak 美甲店清倉假指甲', col:80, desc:'長度可以自己剪，顏色只有一種：血紅。' },
  { id:'bigbro', name:'紙紮大哥大', col:130, desc:'上世紀燒下來的，訊號只有一格，但是永遠打得通老闆。' },
];
// 小鬼的反應：r = 出價 ÷ 底價。一格一格分得很清楚，看臉色就能推算。
const GS_BANDS = [
  { max:0.6,  mood:'翻臉', col:'#e2483a', lv:0, pose:'strike', lines:['你當我這裡是陽間的二手群組？出這種價！', '這個價，連一炷香都買不到！再這樣我叫牛頭來收你！', '侮辱我？我做這行三百年，沒見過這麼厚的臉皮！'] },
  { max:0.8,  mood:'很臭', col:'#d07a3a', lv:1, pose:'idle',   lines:['哼，差得遠。我進貨都不止這個價。', '你在跟我講價，還是在講笑話？', '加！多加一點！我也要交租的好嗎！'] },
  { max:0.93, mood:'猶豫', col:'#d8b84a', lv:2, pose:'windup', lines:['嗯……開始像話了。再加一點。', '看你黑眼圈這麼重，再加一點我就考慮。', '這個價嘛……我老婆知道會罵我的。再一點。'] },
  { max:1,    mood:'肉痛', col:'#9ad05a', lv:3, pose:'hurt',   lines:['哎喲，肉痛……就差一口氣了！', '再加一點點，就當交個朋友。', '我的手在發抖了……再一點點就好！'] },
];
const GS_DEAL_TIGHT = ['……成交。你這隻鬼精，下次別來了。', '好啦好啦，算我今晚倒楣。拿去！', '你這種客人，我做三百年只見過兩個。成交。'];
const GS_DEAL_FAT = ['成交！！（小鬼笑到假牙都掉了出來）', '爽快！你是我今晚最喜歡的客人！', '成交成交！慢走，下次再來啊～（他在偷笑）'];

// 宵夜：只管下一場戰鬥
const GS_MEALS = {
  mala:{ name:'加班麻辣燙', price:30, eff:'下一場出征：攻擊 +15%', say:'辣到你忘記自己已經死了。湯底熬了九百年，比你的工齡還長。' },
  bkt: { name:'通宵肉骨茶', price:30, eff:'下一場出征：血量 +15%', say:'藥材是陽間孝子燒下來的，喝完可以再撐一個通宵。' },
  teh: { name:'忘憂拉茶（少甜）', price:30, eff:'下一場出征：技能符開局 +40', say:'孟婆監製。拉得越高，忘得越多——先忘記老闆的電話號碼。' },
};

// 冥幣兌換：地府科技股。價格只看日期；白無常的小道消息會說明「明天」漲還是跌。
const GS_NEWS_UP = ['地府科技宣布：「來世訂閱制」下個月上線，首月免費。', '閻羅殿採購地府科技全套考勤系統，打卡從此不用手。', '地府科技新品「免排隊投胎」預購爆滿，伺服器排隊九百年。', '牛頭馬面代言地府科技，粉絲排隊排了三條街。', '地府科技財報：陽間清明節燒來的訂單創新高。'];
const GS_NEWS_DN = ['地府科技 CEO 被拍到回陽間兼職送外賣。', '地府科技伺服器當機，全陰間打不了卡，老闆們很不爽。', '地府科技被揭發用紙紮人當員工，紙紮人工會要求加薪。', '地府科技財報：盈利是燒來的，燒完就沒了。', '用戶投訴：用了地府科技的投胎 App，投胎後才發現是試用版。'];
const GS_FEE = 0.03, GS_SHARE_CAP = 100;

// 街上的閒鬼碎碎念
const GS_CHATTER = [
  '冥幣又通脹了，一碗粥要三億。', '我死了還在等那份 KPI 審批。', '房東說棺材位下個月起加租兩成。',
  '投胎排隊要等九百年，先打份工吧。', '老闆說加班費可以用功德抵。', '我生前過勞死，死後被派去整理過勞死的檔案。',
  '燒來的跑車被開罰單了——沒有紙紮車牌。', '年終獎金？上次發的是一張紙紮的「謝謝你」。', '女兒燒了一部手機給我，忘記燒充電器。',
  '孟婆湯漲價了，現在忘一個前任要加錢。', '開會開到雞叫，會議記錄：下次再議。', '我當了三百年實習生，還沒轉正。',
  '老闆說我們是一家人——所以不用發薪水。', '冥股又跌了，我的退休金只夠買一根香。', '陽間有四天工作週，我們連週末都沒有，只有週七。',
  '我兼職送宵夜，評分四點九，扣分是因為我太冷。', '打卡機壞了，全部當曠工——死了還要被扣錢。', '我陽間的同事，還在用我的帳號登入系統。',
  '黃總說今年不加薪，每人送一張勵志海報。', '冥幣面額太大，找零要推一輛手推車。', '七月出差回陽間，酒店全滿，只好睡停車場。',
  '我的 MC 被退回：「你已經死了，不算生病。」', '下班了還在群組回「收到」，這是職業病，也是死因。', '隔壁的榴槤是陽間空運的，貴到我的心又死了一次。',
  '投訴信寄去閻羅殿，自動回覆：「請排隊三百年。」', '這條街的租金，貴到連鬼都住不起。', '聽說今年的 OT 費用「心意」計算。',
  '我死後終於有時間睡覺，結果被排了夜班。', 'Mamak 檔的師傅說，拉茶要拉到陽間那麼長才夠味。',
];
const GS_WANDER = ['youhun', 'egui', 'zombie', 'shuigui', 'pocong'];
// 平日動作（daily_town.js）：閒鬼手上拿的東西、店主做生意時面向哪邊（+1 = 右）、宵夜檔的鍋口（背景圖比例）
const GS_PROPS = { youhun:{ kind:'lanternW' }, egui:{ kind:'lanternR' }, shuigui:{ kind:'bag' }, zombie:{ kind:'phone', lines:['喂？喂？', '聽到嗎？', '我跳緊過嚟'] } };
const GS_WORKFACE = { paper:-1, haggle:1, exch:1, food:-1 };
const GS_POT = [0.752, 0.588];
const GS_SORRY = ['不好意思', '對不起對不起', '借過借過', '撞到你，抱歉'];
const GS_KEEPER_HI = {
  paper:['小紙：歡迎光臨！燒什麼都可以，就是不能燒加班單。', '小紙：今天新到的貨，摺到我手指都快斷了——紙做的手指。'],
  haggle:['小鬼：看什麼看？要買就出價，不買別擋著。', '小鬼：我這裡不二價。……好啦，可以講。'],
  exch:['白無常：一見生財！今天要換冥幣，還是換人生？', '白無常：一見生財～小道消息免費，虧錢自負。'],
  food:['餓鬼王：坐！吃！吃飽才有力氣被老闆罵！', '餓鬼王：一人一碗，不准偷吃隔壁的！（他在偷吃隔壁的）'],
  alley:['（巷子裡的霧好像在看你。）'],
};

// 暗巷：每次來只會遇到一件事
const GS_ALLEY = [
  { id:'mlm', text:'一隻穿西裝的鬼塞給你一張傳單：「地府直銷，三個月月入一億冥幣！講座只收 60。」',
    a:{ label:'聽講座', cost:60, out:'講了三個鐘，重點是：請你也去拉三個人來聽講座。你學到了寶貴的一課。', give:{ exp:50 } },
    b:{ label:'說「我在趕投胎」', out:'他在你背後喊：「你會後悔的！」你沒有。', give:{ exp:10 } } },
  { id:'lost', text:'一隻剛來報到的新鬼抱著公文袋發抖：「請問……投胎報到處怎麼走？今天是我第一天。」',
    a:{ label:'親自帶他去', out:'他一路跟你講他的簡報。報到處說他表格填錯了要重排——至少他少走了冤枉路。', give:{ exp:70 } },
    b:{ label:'收 20 冥幣畫地圖', out:'地圖畫得很漂亮。你良心痛了一下，也只痛了一下。', give:{ coins:20 } } },
  { id:'cash', text:'地上有一疊整整齊齊的冥幣，旁邊有張字條：「誰撿誰加班」。',
    a:{ label:'撿起來', out:'冥幣到手。遠處有人喊：「好，明天早上七點開會。」……應該是巧合。', give:{ coins:90 } },
    b:{ label:'交給巡夜的黑無常', out:'黑無常說：「難得。」塞給你一個綠箱，然後把冥幣收進自己口袋。', give:{ chest:'g' } } },
  { id:'cry', text:'一隻加班鬼蹲在牆角哭：「簡報存檔失敗了，明早就要交……」',
    a:{ label:'幫他重做一份', out:'你們做到雞叫。老闆看了一眼說：「換回第一版吧。」至少他不哭了，改成笑。', give:{ exp:80 } },
    b:{ label:'遞一包紙巾', out:'他擤了鼻涕，說謝謝，繼續哭。有時候陪著就夠了。', give:{ exp:15 } } },
  { id:'fortune', text:'巷口擺著一個算命攤：「鐵口直斷，一次 50 冥幣。」',
    a:{ label:'算一下', cost:50, out:'「你下輩子……還是打工仔。」不過他說你今晚有偏財，送你一個藍箱。', give:{ chest:'b' } },
    b:{ label:'不信這一套', out:'他在你背後點點頭：「這個也算準了。」', give:{ exp:10 } } },
  { id:'troops', text:'一個戴墨鏡的鬼掀開大衣：「水貨陰兵，80 冥幣三十個，不問來歷。」',
    a:{ label:'買一批', cost:80, out:'三十個陰兵排好隊跟你回家。其中一個問：「有勞工保險嗎？」', give:{ troops:30 } },
    b:{ label:'向巡夜的牛頭舉報', out:'牛頭把他帶走了。他臨走前說：「兄弟，我也只是打工的。」', give:{ exp:40 } } },
  { id:'mahjong', text:'巷尾的麻將桌三缺一：「來啦，打一圈就好！」',
    a:{ label:'坐下打一圈', cost:40, out:'你被三家清一色，輸了 40 冥幣。散場時他們拍拍你：「你人很好，下次還找你。」', give:{ exp:30 } },
    b:{ label:'「我老婆在等我」', out:'三隻鬼齊聲說：「怕老婆好，怕老婆會發達。」', give:{ exp:5 } } },
  { id:'wifi', text:'霧裡有個小攤在賣「陽間 WiFi 密碼」，一張 30 冥幣。',
    a:{ label:'買一張', cost:30, out:'密碼是 12345678。你連上了，看到舊同事在群組問：「阿福走了，他的工作誰接？」……沒人回。', give:{ exp:40 } },
    b:{ label:'算了', out:'你決定今晚不看群組。這是你死後最健康的決定。', give:{ exp:20 } } },
];

// 畫面上的燈籠（背景圖上的位置，給它們加光暈）
const GS_LANTERNS = [[0.029, 0.322], [0.286, 0.352], [0.496, 0.332], [0.557, 0.355], [0.72, 0.36], [0.872, 0.352], [0.97, 0.322], [0.018, 0.468], [0.228, 0.468], [0.475, 0.46], [0.684, 0.488], [0.866, 0.51], [0.92, 0.44], [0.955, 0.44]];

function gsDay() { const d = new Date(); return Math.floor((d.getTime() - d.getTimezoneOffset() * 60000) / 86400000); }
function gsRnd(n) { n = (n | 0) ^ 0x5bd1e995; n = Math.imul(n ^ (n >>> 15), 0x2c1b3c6d); n = Math.imul(n ^ (n >>> 12), 0x297a2d39); n ^= n >>> 15; return (n >>> 0) / 4294967296; }

const GhostStreet = {
  active:false,
  // ---------- 存檔 ----------
  st() {
    if (!S) return { fx:{} };
    const s = S.street = S.street || {};
    s.fx = s.fx || {}; s.meal = s.meal || null; s.visits = s.visits || 0; s.seen = s.seen || {};
    s.stock = s.stock || { n:0, cost:0 }; s.curios = s.curios || [];
    if (!s.hag || s.hag.day !== gsDay()) s.hag = { day:gsDay(), done:{}, tries:{}, strikes:0, out:false };
    return s;
  },
  // 給其他檔案用的加成
  mul(kind) {
    const fx = (S && S.street && S.street.fx) || {};
    if (kind === 'walk') return fx.car ? 1.15 : 1;
    if (kind === 'work') return fx.coffee ? 1.1 : 1;
    if (kind === 'hp') return fx.chair ? 1.05 : 1;
    return 1;
  },
  bonus(kind) { const fx = (S && S.street && S.street.fx) || {}; if (kind === 'mana') return fx.phone ? 25 : 0; return 0; },
  // 出征開打時呼叫一次：按摩椅（永久）＋宵夜（用掉）
  battleBuffs(units) {
    if (!S || !units) return '';
    const own = units.filter(u => u.side === 0), hpm = this.mul('hp');
    if (hpm !== 1) own.forEach(u => { u.maxhp *= hpm; u.hp *= hpm; });
    const m = S.street && S.street.meal; if (!m || !GS_MEALS[m]) return '';
    if (m === 'mala') own.forEach(u => u.atk *= 1.15);
    if (m === 'bkt') own.forEach(u => { u.maxhp *= 1.15; u.hp *= 1.15; });
    if (m === 'teh') own.filter(u => !u.minion).forEach(u => u.energy = Math.min(100, (u.energy || 0) + 40));
    S.street.meal = null; save();
    try { Fx.toast(`宵夜生效：<b>${GS_MEALS[m].name}</b>（${GS_MEALS[m].eff.replace('下一場出征：', '')}）`); } catch (e) {}
    return GS_MEALS[m].name;
  },

  // ---------- 開 / 關 ----------
  open() {
    const s = this.st(); s.visits++;
    Object.assign(this, { active:true, t:0, view:{ k:'idle' }, parts:[], floats:[], ate:false, alleyDone:null, alleyEv:null, vh:0, cam:0, pend:null, drag:null, kick:0 });
    this.afu = { x:0.06, y:0.84, tx:0.06, ty:0.84, dir:1, walking:false, dustT:0, pose:null, poseT:0 };
    this.keepers = {}; for (const k in GS_STALLS) { const d = GS_STALLS[k]; if (d.keeper) this.keepers[k] = { k:d.keeper, x:d.kx, y:d.ky, pose:null, pt:0, poseT:0, bub:null, bubT:0, ph:Math.random() * 6 }; }
    const used = new Set();
    this.walkers = GS_WANDER.map((k, i) => ({ k, x:0.1 + i * 0.19 + Math.random() * 0.05, y:0.79 + Math.random() * 0.13, tx:0, ty:0, wait:1 + Math.random() * 4, dir:Math.random() < 0.5 ? 1 : -1, ph:Math.random() * 6, bub:null, bubT:0, chatT:2 + i * 2.6 + Math.random() * 2 }));
    this.walkers.forEach(w => { w.tx = w.x; w.ty = w.y; w.prop = GS_PROPS[w.k] ? Object.assign({ seed:Math.random() }, GS_PROPS[w.k]) : null; w.look = 0; w.bump = 0; });
    this.bumpCD = 10 + Math.random() * 8;
    this.chatUsed = used;
    this.fog = Array.from({ length:9 }, (_, i) => ({ x:Math.random(), y:0.66 + Math.random() * 0.3, r:0.12 + Math.random() * 0.12, v:(0.004 + Math.random() * 0.008) * (i % 2 ? 1 : -1), a:0.05 + Math.random() * 0.06 }));
    for (let i = 0; i < 14; i++) this.parts.push(this.mkJoss(true));
    const el = $('#gstreet'); el.classList.add('on');
    el.innerHTML = `<div id="gs-top"><button class="btn sm" id="gs-back">回村</button><b>冥街夜市</b><span id="gs-coins"><svg><use href="#i-coins"/></svg><i></i></span></div>
      <div id="gs-stage"><canvas id="gs-cvs"></canvas></div><div id="gs-panel"></div>`;
    $('#gs-back').onclick = () => { Sound.play('click'); this.close(); };
    const cv = $('#gs-cvs');
    cv.addEventListener('pointerdown', (e) => this.down(e)); cv.addEventListener('pointermove', (e) => this.move(e)); cv.addEventListener('pointerup', (e) => this.up(e)); cv.addEventListener('pointercancel', () => { this.drag = null; });
    Sound.setMode('story');
    this.resize(); if (!this._rs) { this._rs = true; window.addEventListener('resize', () => { if (this.active) this.resize(); }); }
    this.renderPanel(); this.vh = this.targetVH();
    this.last = performance.now(); requestAnimationFrame((n) => this.frame(n));
    if (!s.seen.street) { s.seen.street = 1; setTimeout(() => this.say(this.walkers[0], '新來的？這裡是下班後的陰間，慢慢逛。', 4), 700); }
    save();
  },
  close() {
    if (!this.active) return; this.active = false;
    $('#gstreet').classList.remove('on'); $('#gstreet').innerHTML = '';
    Sound.setMode('village'); save(); UI.refresh();
  },
  resize() {
    const c = $('#gs-cvs'), box = $('#gs-stage'); if (!c || !box) return; const r = box.getBoundingClientRect(), dpr = Math.min(2, window.devicePixelRatio || 1);
    c.width = r.width * dpr; c.height = r.height * dpr; c.style.width = r.width + 'px'; c.style.height = r.height + 'px';
    this.W = r.width; this.H = r.height; this.dpr = dpr;
  },
  targetVH() { const p = $('#gs-panel'); return Math.max(260, (this.H || 700) - (p ? p.offsetHeight : 0) + 6); },
  // 背景尺寸：圖片高度 = 面板上方可見的高度
  geo() {
    const img = SPR.bg_street, iw = img && img.naturalWidth || 1536, ih = img && img.naturalHeight || 1024;
    let IH = this.vh || 500, IW = IH * iw / ih; if (IW < this.W * 1.15) { IW = this.W * 1.15; IH = IW * ih / iw; }
    return { IW, IH };
  },
  X(fx) { const g = this.geo(); return (fx - this.cam) * g.IW; },
  Y(fy) { return fy * this.geo().IH; },
  depth(fy) { return 0.84 + 0.36 * Math.max(0, Math.min(1, (fy - 0.72) / 0.23)); },
  charScale(fy) { return this.geo().IH * 0.25 / 58 * this.depth(fy); },
  toWorld(e) { const r = $('#gs-cvs').getBoundingClientRect(), g = this.geo(); return { fx:(e.clientX - r.left) / g.IW + this.cam, fy:(e.clientY - r.top) / g.IH, sx:e.clientX - r.left, sy:e.clientY - r.top }; },

  // ---------- 操作 ----------
  down(e) {
    if (this.kick > 0) return; const p = this.toWorld(e); this.drag = { x0:p.sx, y0:p.sy, moved:false, p };
    try { e.target.setPointerCapture(e.pointerId); } catch (er) {}
  },
  move(e) {
    if (!this.drag || this.kick > 0) return; const p = this.toWorld(e);
    if (!this.drag.moved && Math.hypot(p.sx - this.drag.x0, p.sy - this.drag.y0) > 10) this.drag.moved = true;
    if (this.drag.moved) { this.pend = null; this.walkTo(p.fx, p.fy); }
  },
  up(e) {
    const d = this.drag; this.drag = null; if (!d || d.moved || this.kick > 0) return;
    const p = d.p;
    // 點到閒鬼：他說一句
    for (const w of this.walkers) { const sc = this.charScale(w.y), h = 58 * sc; if (Math.abs(p.fx - w.x) * this.geo().IW < 22 * sc && p.fy * this.geo().IH < this.Y(w.y) + 6 && p.fy * this.geo().IH > this.Y(w.y) - h) { this.chat(w, true); Sound.play('click'); return; } }
    // 點到攤位：走過去，到了就開
    if (p.fy < 0.74) { for (const k of GS_ORDER) { const s = GS_STALLS[k]; if (p.fx >= s.x0 && p.fx <= s.x1) { this.goStall(k); return; } } }
    this.pend = null; this.walkTo(p.fx, p.fy);
  },
  walkTo(fx, fy) { const A = this.afu; A.tx = Math.max(0.03, Math.min(0.97, fx)); A.ty = Math.max(0.78, Math.min(0.93, fy)); },
  goStall(k) {
    const s = GS_STALLS[k]; Sound.play('click');
    this.pend = k; this.walkTo(s.sx, 0.8);
    if (this.view.k !== 'idle' && this.view.k !== k) { this.view = { k:'idle' }; this.renderPanel(); }
  },
  arrive(k) {
    this.pend = null; this.afu.dir = GS_STALLS[k].face;
    const kp = this.keepers[k]; if (kp) { this.say(kp, pick(GS_KEEPER_HI[k]).replace(/^[^：]+：/, ''), 3); kp.pose = 'cast'; kp.poseT = 0.9; }
    this.view = { k }; if (k === 'haggle') this.view.sub = null;
    this.walkers.forEach(w => { w.bubT = 0; if (Math.abs(w.x - this.afu.x) < 0.16) { w.tx = this.avoid(this.afu.x + (w.x < this.afu.x ? -0.2 : 0.2)); w.ty = 0.87 + Math.random() * 0.06; w.wait = 3; } }); this.renderPanel(); Sound.play('paper');
  },

  // ---------- 每一幀 ----------
  frame(now) {
    if (!this.active) return;
    if (now - this.last < 1000 / 30 - 2) { requestAnimationFrame((n) => this.frame(n)); return; } // 上限 30 格（手機發燙）
    const dt = Math.min(0.05, (now - this.last) / 1000); this.last = now;
    this.step(dt); this.draw(now / 1000);
    requestAnimationFrame((n) => this.frame(n));
  },
  step(dt) {
    this.t += dt; const A = this.afu, g = this.geo();
    // 面板高度變了：畫面平滑縮放
    const tv = this.targetVH(); this.vh += (tv - this.vh) * Math.min(1, dt * 7);
    // 阿福走路（被轟出去時往左滑）
    if (this.kick > 0) { this.kick -= dt; A.x = Math.max(0.2, A.x - dt * 0.12); A.tx = A.x; A.ty = A.y; A.dir = 1; A.walking = false; A.pose = 'hurt'; A.poseT = 0.2; }
    else {
      const dx = (A.tx - A.x) * g.IW, dy = (A.ty - A.y) * g.IH, d = Math.hypot(dx, dy), sp = 150 * this.depth(A.y) * dt;
      if (d > 2) { A.x += dx / d * Math.min(sp, d) / g.IW; A.y += dy / d * Math.min(sp, d) / g.IH; if (Math.abs(dx) > 1) A.dir = dx > 0 ? 1 : -1; A.walking = true;
        A.dustT -= dt; if (A.dustT <= 0) { A.dustT = 0.16; this.parts.push({ kind:'dust', x:A.x - A.dir * 0.006, y:A.y, vx:-A.dir * 0.01, vy:-0.02, life:0.55, max:0.55, r:3 + Math.random() * 3 }); } }
      else { if (A.walking && this.pend) this.arrive(this.pend); A.walking = false; }
    }
    if (A.poseT > 0) { A.poseT -= dt; if (A.poseT <= 0) A.pose = null; }
    // 鏡頭
    const vw = this.W / g.IW, want = Math.max(0, Math.min(1 - vw, A.x - vw / 2)); this.cam += (want - this.cam) * Math.min(1, dt * 4);
    this.cam = Math.max(0, Math.min(1 - vw, this.cam));
    // 店主
    for (const k in this.keepers) { const kp = this.keepers[k]; if (kp.poseT > 0) { kp.poseT -= dt; kp.pt = Math.min(1, kp.pt + dt * 1.6); if (kp.poseT <= 0 && !kp.hold) kp.pose = null; } if (kp.bubT > 0) kp.bubT -= dt;
      // 平日動作：阿福停在攤前 → 打招呼一次；平常做自己的生意
      const near = !A.walking && Math.abs(A.x - GS_STALLS[k].x) < 0.09;
      if (near && !kp.greeted && !kp.pose) { kp.greeted = true; kp.greet = kp.k === 'xiaozhi' || kp.k === 'eguiking' ? 1.8 : 1.6; kp.gt = 0; }
      if (Math.abs(A.x - GS_STALLS[k].x) > 0.14) kp.greeted = false;
      if (kp.greet > 0) { kp.greet -= dt; kp.gt += dt; if (kp.pose) kp.greet = 0; }
      if (typeof TOWN !== 'undefined') kp.st = TOWN.tick(kp.st, kp.k, dt, !kp.pose && !(kp.greet > 0), false); }
    // 閒鬼
    for (const w of this.walkers) {
      if (w.bubT > 0) w.bubT -= dt;
      if (w.bump > 0) { w.bump -= dt; w.bt += dt; w.walking = false; continue; }   // 撞到人：停下來道歉
      if (w.look > 0) { w.look -= dt; w.lt += dt; w.walking = false; continue; }  // 停在攤前看
      const dx = (w.tx - w.x) * g.IW, dy = (w.ty - w.y) * g.IH, d = Math.hypot(dx, dy);
      if (d > 2) { const sp = 34 * dt; w.x += dx / d * Math.min(sp, d) / g.IW; w.y += dy / d * Math.min(sp, d) / g.IH; if (Math.abs(dx) > 0.5) w.dir = dx > 0 ? 1 : -1; w.walking = true; }
      else {
        if (w.walking && w.toStall != null) { w.look = 2.6 + Math.random() * 1.5; w.lt = 0; w.dir = GS_STALLS[w.toStall].x >= w.x ? 1 : -1; w.toStall = null; }
        w.walking = false; w.wait -= dt;
        if (w.wait <= 0) { w.wait = 2 + Math.random() * 5;
          const st = GS_ORDER[Math.floor(Math.random() * 4)];
          if (this.view.k === 'idle' && Math.random() < 0.3 && w.prop && Math.abs(GS_STALLS[st].x - w.x) < 0.4) { w.tx = this.avoid(GS_STALLS[st].x + (Math.random() - 0.5) * 0.07); w.ty = 0.79 + Math.random() * 0.03; w.toStall = st; }
          else { w.tx = this.avoid(w.x + (Math.random() - 0.5) * 0.3); w.ty = this.view.k !== 'idle' ? 0.86 + Math.random() * 0.07 : 0.79 + Math.random() * 0.13; w.toStall = null; } } }
      w.chatT -= dt; if (w.chatT <= 0) { w.chatT = 7 + Math.random() * 8; const vis = this.X(w.x) > 20 && this.X(w.x) < this.W - 20; const busy = this.view.k !== 'idle' || Object.values(this.keepers).some(k => k.bubT > 0); if (vis && !busy && !this.walkers.some(o => o !== w && o.bubT > 0)) this.chat(w); }
    }
    // 閒鬼撞到：兩個面對面走、同一條線上 → 停下、互相道歉；隔一陣子安排兩個走同一條線
    this.bumpCD -= dt;
    for (let i = 0; i < this.walkers.length; i++) for (let j = i + 1; j < this.walkers.length; j++) { const P = this.walkers[i], Q = this.walkers[j];
      if (P.walking && Q.walking && P.prop && Q.prop && P.dir !== Q.dir && Math.abs(P.x - Q.x) < 0.03 && Math.abs(P.y - Q.y) < 0.03 && (Q.x - P.x) * P.dir > 0) {
        for (const W of [P, Q]) { W.bump = 1.8; W.bt = 0; W.tx = W.x; W.ty = W.y; W.toStall = null; W.wait = 0.5 + Math.random(); W.sorry = GS_SORRY[Math.floor(Math.random() * GS_SORRY.length)]; } } }
    if (this.bumpCD <= 0 && this.view.k === 'idle') { this.bumpCD = 16 + Math.random() * 12;
      const vis = this.walkers.filter(w => w.prop && !w.bump && !w.look && this.X(w.x) > 40 && this.X(w.x) < this.W - 40);
      if (vis.length >= 2) { const P = vis[0], Q = vis[1], mid = (P.x + Q.x) / 2, yy = 0.83 + Math.random() * 0.06, l = P.x < Q.x;
        P.ty = Q.ty = yy; P.tx = this.avoid(mid + (l ? 0.07 : -0.07)); Q.tx = this.avoid(mid + (l ? -0.07 : 0.07)); P.wait = Q.wait = 8; P.toStall = Q.toStall = null; } }
    // 粒子
    if (Math.random() < dt * 1.6) this.parts.push(this.mkJoss(false));
    if (Math.random() < dt * 5) this.parts.push({ kind:'steam', x:0.752 + (Math.random() - 0.5) * 0.02, y:0.515, vx:(Math.random() - 0.5) * 0.004, vy:-0.035 - Math.random() * 0.02, life:2.2, max:2.2, r:4 + Math.random() * 4 });
    if (Math.random() < dt * 1.2) this.parts.push({ kind:'mist', x:0.9 + Math.random() * 0.08, y:0.6 + Math.random() * 0.2, vx:-0.006 - Math.random() * 0.01, vy:-0.004, life:4, max:4, r:20 + Math.random() * 30 });
    this.parts = this.parts.filter(p => {
      p.life -= dt; p.x += p.vx * dt; p.y += p.vy * dt;
      if (p.kind === 'joss') { p.rot += p.vr * dt; p.flip += dt * p.vf; p.vx = p.bx + Math.sin(this.t * p.sw + p.ph) * 0.012; if (p.y > p.land) { p.vy = 0; p.vx = 0; p.vr = 0; p.vf = 0; } }
      return p.life > 0;
    });
    for (const f of this.fog) { f.x += f.v * dt; if (f.x > 1.2) f.x = -0.2; if (f.x < -0.2) f.x = 1.2; }
    this.floats = this.floats.filter(f => (f.life -= dt) > 0);
    // 頂欄冥幣
    const c = $('#gs-coins i'); if (c) { const v = fmt(S.res.coins); if (c.textContent !== v) c.textContent = v; }
  },
  mkJoss(init) { return { kind:'joss', x:this.cam + Math.random() * 1.3 - 0.15, y:init ? Math.random() * 0.8 : -0.05, bx:(Math.random() - 0.5) * 0.01, vx:0, vy:0.025 + Math.random() * 0.025, rot:Math.random() * 6, vr:(Math.random() - 0.5) * 2, flip:Math.random() * 6, vf:2 + Math.random() * 3, sw:0.8 + Math.random(), ph:Math.random() * 6, land:0.8 + Math.random() * 0.17, life:init ? 10 + Math.random() * 10 : 24, max:24 }; },
  // 閒鬼不要站在店主身上；有人在買東西時，也別擋在阿福前面
  avoid(nx) {
    nx = Math.max(0.03, Math.min(0.9, nx));
    for (let i = 0; i < 4; i++) { let hit = false;
      for (const k in this.keepers) { const kx = this.keepers[k].x; if (Math.abs(nx - kx) < 0.05) { nx = kx + (nx < kx ? -0.06 : 0.06); hit = true; } }
      if (this.view.k !== 'idle' && Math.abs(nx - this.afu.x) < 0.15) { nx = this.afu.x + (nx < this.afu.x ? -0.17 : 0.17); hit = true; }
      nx = Math.max(0.03, Math.min(0.9, nx)); if (!hit) break; }
    return nx;
  },
  chat(w, force) {
    let line, i = 0;
    do { line = pick(GS_CHATTER); i++; } while (this.chatUsed.has(line) && i < 40);
    if (this.chatUsed.size > GS_CHATTER.length - 6) this.chatUsed.clear();
    this.chatUsed.add(line); this.say(w, line, force ? 3.6 : 3.2);
  },
  say(o, text, dur) { if (!o) return; o.bub = text; o.bubT = dur || 3; },
  float(fx, fy, text, col) { const n = this.floats.filter(f => f.life > 0.9).length; this.floats.push({ x:fx, y:fy + n * 0.05, text, col:col || '#ffe08a', life:1.8, max:1.8 }); },

  // ---------- 畫面 ----------
  draw(t) {
    const c = $('#gs-cvs'); if (!c) return; const ctx = c.getContext('2d'); ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
    const g = this.geo(), W = this.W, H = this.H, img = SPR.bg_street;
    ctx.fillStyle = '#0c0a12'; ctx.fillRect(0, 0, W, H);
    if (img && img.complete && img.naturalWidth) ctx.drawImage(img, -this.cam * g.IW, 0, g.IW, g.IH);
    const bot = ctx.createLinearGradient(0, g.IH - 30, 0, g.IH + 40); bot.addColorStop(0, 'rgba(12,10,18,0)'); bot.addColorStop(1, 'rgba(12,10,18,1)'); ctx.fillStyle = bot; ctx.fillRect(0, g.IH - 30, W, H - g.IH + 30);
    // 月光、燈籠光暈（加亮）
    ctx.save(); ctx.globalCompositeOperation = 'lighter';
    this.glow(ctx, this.X(0.785), this.Y(0.085), g.IH * 0.16, `rgba(140,255,170,${0.10 + 0.04 * Math.sin(t * 0.8)})`);
    GS_LANTERNS.forEach(([lx, ly], i) => { const fl = 0.16 + 0.07 * Math.sin(t * 3.1 + i * 1.7) + 0.04 * Math.sin(t * 7.3 + i); this.glow(ctx, this.X(lx) + Math.sin(t * 1.3 + i) * 2, this.Y(ly), g.IH * 0.06, `rgba(255,120,60,${fl})`); });
    this.glow(ctx, this.X(0.58), this.Y(0.52), g.IH * 0.12, `rgba(255,200,110,${0.08 + 0.03 * Math.sin(t * 2)})`);
    ctx.restore();
    // 後面的霧
    this.drawFog(ctx, t, false);
    this.drawParts(ctx, 'steam');
    // 人物（後面的先畫）
    const list = [];
    for (const k in this.keepers) list.push({ y:this.keepers[k].y, f:() => this.drawKeeper(ctx, k, t) });
    for (const w of this.walkers) list.push({ y:w.y, f:() => this.drawWalker(ctx, w, t) });
    list.push({ y:this.afu.y, f:() => this.drawAfu(ctx, t) });
    this.drawParts(ctx, 'dust');
    list.sort((a, b) => a.y - b.y).forEach(o => o.f());
    this.drawFog(ctx, t, true);
    this.drawParts(ctx, 'mist'); this.drawParts(ctx, 'joss');
    this.drawLanternString(ctx, t);
    this.drawSigns(ctx, t);
    // 對白泡泡
    for (const k in this.keepers) { const kp = this.keepers[k]; if (kp.bubT > 0) this.bubble(ctx, kp, kp.bub, kp.bubT); }
    for (const w of this.walkers) if (w.bubT > 0) this.bubble(ctx, w, w.bub, w.bubT);
    // 飄字
    ctx.textAlign = 'center'; ctx.font = '900 17px ' + getComputedStyle(document.body).fontFamily;
    for (const f of this.floats) { const k = f.life / f.max, x = this.X(f.x), y = this.Y(f.y) - (1 - k) * 40; ctx.globalAlpha = Math.min(1, k * 2); ctx.lineWidth = 4; ctx.strokeStyle = 'rgba(0,0,0,.8)'; ctx.strokeText(f.text, x, y); ctx.fillStyle = f.col; ctx.fillText(f.text, x, y); }
    ctx.globalAlpha = 1;
  },
  glow(ctx, x, y, r, col) { const gr = ctx.createRadialGradient(x, y, 0, x, y, r); gr.addColorStop(0, col); gr.addColorStop(1, 'rgba(0,0,0,0)'); ctx.fillStyle = gr; ctx.fillRect(x - r, y - r, r * 2, r * 2); },
  drawFog(ctx, t, front) {
    const g = this.geo();
    this.fog.forEach((f, i) => {
      if ((f.y > 0.84) !== front) return;
      const x = this.X(f.x * 1.0 + this.cam * (front ? -0.15 : 0)), y = this.Y(f.y), r = f.r * g.IW * 0.5;
      ctx.save(); ctx.translate(x, y); ctx.scale(1, 0.32);
      const gr = ctx.createRadialGradient(0, 0, 0, 0, 0, r); const a = f.a * (0.8 + 0.2 * Math.sin(t * 0.7 + i));
      gr.addColorStop(0, `rgba(200,190,230,${a})`); gr.addColorStop(1, 'rgba(200,190,230,0)'); ctx.fillStyle = gr; ctx.fillRect(-r, -r, r * 2, r * 2); ctx.restore();
    });
  },
  drawParts(ctx, kind) {
    const g = this.geo();
    for (const p of this.parts) {
      if (p.kind !== kind) continue; const x = this.X(p.x), y = this.Y(p.y), k = p.life / p.max;
      if (x < -60 || x > this.W + 60) continue;
      if (kind === 'joss') {
        const sz = g.IH * 0.016; ctx.save(); ctx.globalAlpha = Math.min(1, p.life * 0.6) * 0.92; ctx.translate(x, y); ctx.rotate(p.rot); ctx.scale(1, Math.cos(p.flip));
        ctx.fillStyle = '#e8c35a'; ctx.strokeStyle = '#6a4a14'; ctx.lineWidth = 0.8; ctx.fillRect(-sz, -sz * 0.7, sz * 2, sz * 1.4); ctx.strokeRect(-sz, -sz * 0.7, sz * 2, sz * 1.4);
        ctx.fillStyle = '#b8322a'; ctx.fillRect(-sz * 0.35, -sz * 0.35, sz * 0.7, sz * 0.7); ctx.restore();
      } else if (kind === 'steam') {
        const r = p.r * (2 - k) * g.IH / 500; ctx.fillStyle = `rgba(240,235,255,${0.22 * k * (1 - k) * 3})`; ctx.beginPath(); ctx.arc(x + Math.sin(p.life * 3 + p.r) * 4, y, r, 0, 7); ctx.fill();
      } else if (kind === 'mist') {
        const r = p.r * g.IH / 500 * (1.6 - k * 0.6); const gr = ctx.createRadialGradient(x, y, 0, x, y, r); gr.addColorStop(0, `rgba(210,220,240,${0.16 * Math.sin(k * Math.PI)})`); gr.addColorStop(1, 'rgba(210,220,240,0)'); ctx.fillStyle = gr; ctx.fillRect(x - r, y - r, r * 2, r * 2);
      } else if (kind === 'dust') {
        const r = p.r * (1.6 - k) * g.IH / 600; ctx.fillStyle = `rgba(190,170,200,${0.4 * k})`; ctx.beginPath(); ctx.ellipse(x, y, r * 1.4, r * 0.8, 0, 0, 7); ctx.fill();
      }
    }
  },
  // 最前面一串會搖的燈籠（比背景移得快一點，有前後景的感覺）
  drawLanternString(ctx, t) {
    const g = this.geo(), par = 1.25, top = -4, sag = g.IH * 0.06, gap = g.IW * 0.16;
    const off = -this.cam * g.IW * par, n0 = Math.floor(-off / gap) - 1;
    ctx.save(); ctx.strokeStyle = 'rgba(30,18,24,.9)'; ctx.lineWidth = 1.6;
    for (let i = n0; i < n0 + Math.ceil(this.W / gap) + 3; i++) {
      const x0 = off + i * gap, x1 = x0 + gap; ctx.beginPath(); ctx.moveTo(x0, top); ctx.quadraticCurveTo((x0 + x1) / 2, top + sag * 2, x1, top); ctx.stroke();
      const mx = (x0 + x1) / 2, my = top + sag, sw = Math.sin(t * 1.6 + i * 1.3) * 0.22, L = g.IH * 0.035, r = g.IH * 0.028;
      ctx.save(); ctx.translate(mx, my); ctx.rotate(sw);
      ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, L); ctx.stroke();
      ctx.globalCompositeOperation = 'lighter'; this.glow(ctx, 0, L + r, r * 3, `rgba(255,110,60,${0.22 + 0.06 * Math.sin(t * 4 + i)})`); ctx.globalCompositeOperation = 'source-over';
      ctx.fillStyle = i % 3 === 1 ? '#f2e6c8' : '#c8322a'; ctx.strokeStyle = '#2a1010'; ctx.lineWidth = 1.6;
      ctx.beginPath(); ctx.ellipse(0, L + r, r * 0.85, r, 0, 0, 7); ctx.fill(); ctx.stroke();
      ctx.strokeStyle = 'rgba(40,10,10,.45)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.ellipse(0, L + r, r * 0.4, r, 0, 0, 7); ctx.stroke();
      ctx.fillStyle = '#e2b04a'; ctx.fillRect(-r * 0.45, L - 2, r * 0.9, 3); ctx.fillRect(-r * 0.45, L + r * 2 - 1, r * 0.9, 3);
      ctx.strokeStyle = '#c8322a'; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.moveTo(0, L + r * 2 + 2); ctx.lineTo(Math.sin(t * 2.4 + i) * 2, L + r * 2 + r * 0.9); ctx.stroke();
      ctx.restore(); ctx.strokeStyle = 'rgba(30,18,24,.9)'; ctx.lineWidth = 1.6;
    }
    ctx.restore();
  },
  // 攤位名牌（小小一塊，掛在雨棚上方）
  drawSigns(ctx, t) {
    const near = this.nearStall(), fam = getComputedStyle(document.body).fontFamily;
    ctx.save(); ctx.font = '800 14px ' + fam; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    for (const k of GS_ORDER) {
      const s = GS_STALLS[k], x = this.X(k === 'alley' ? 0.945 : s.x), y = this.Y(k === 'alley' ? 0.30 : 0.39) + Math.sin(t * 1.5 + s.x * 9) * 1.5;
      if (x < -60 || x > this.W + 60) continue;
      const w = ctx.measureText(s.name).width + 16, on = near === k;
      ctx.fillStyle = on ? 'rgba(194,54,43,.94)' : 'rgba(20,12,22,.72)'; ctx.strokeStyle = on ? '#f3d68a' : 'rgba(243,214,138,.55)'; ctx.lineWidth = 1.2;
      ART.rr(ctx, x - w / 2, y - 12, w, 24, 4, ctx.fillStyle, ctx.strokeStyle, 1.2);
      ctx.fillStyle = on ? '#fff3e0' : '#f3d68a'; ctx.fillText(s.name, x, y + 1);
    }
    ctx.restore();
  },
  nearStall() { const A = this.afu; let best = null, bd = 0.09; for (const k of GS_ORDER) { const d = Math.abs(A.x - GS_STALLS[k].x); if (d < bd) { bd = d; best = k; } } return best; },
  drawAfu(ctx, t) {
    const A = this.afu, sc = this.charScale(A.y), x = this.X(A.x), y = this.Y(A.y);
    ART.drawChar(ctx, 'afu', x, y, sc, { t, walk:A.walking, flip:A.dir < 0, pose:A.walking ? undefined : A.pose || undefined, pt:A.pose ? 1 - Math.max(0, A.poseT) : 0, tamed:true, untied:true });
  },
  drawKeeper(ctx, k, t) {
    const kp = this.keepers[k], sc = this.charScale(kp.y) * (kp.k === 'xiaogui' ? 1.05 : kp.k === 'baiwu' ? 0.9 : 1), x = this.X(kp.x), y = this.Y(kp.y);
    if (x < -80 || x > this.W + 80) return;
    let face = this.afu.x < kp.x;
    let pt = kp.pt; if (kp.pose === 'strike') pt = (t * 1.4) % 1; if (kp.pose === 'windup') pt = 0.35 + Math.sin(t * 3) * 0.1; if (kp.pose === 'hurt') pt = 0.35 + Math.sin(t * 9) * 0.05;
    // 平日動作：打招呼（看著阿福）／做生意（面向自己的攤子）
    let da = {};
    if (typeof TOWN !== 'undefined' && !kp.pose) {
      if (kp.greet > 0) da = { act:'town_greet', at:kp.gt, adur:kp.gt + kp.greet };
      else { da = TOWN.opts(kp.st); if (da.act) face = GS_WORKFACE[k] < 0; }
      if (kp.k === 'eguiking') da.prop = { potDX:this.X(GS_POT[0]) - x, potDY:this.Y(GS_POT[1]) - y };
    }
    ART.drawChar(ctx, kp.k, x, y, sc, Object.assign({ t:t + kp.ph, flip:face, pose:kp.pose || undefined, pt, tamed:true, untied:true }, da));
  },
  drawWalker(ctx, w, t) {
    const sc = this.charScale(w.y) * 0.92, x = this.X(w.x), y = this.Y(w.y);
    if (x < -80 || x > this.W + 80) return;
    let da = {};
    if (typeof TOWN !== 'undefined') {
      if (w.bump > 0) da = { act:'town_bump', at:w.bt, prop:Object.assign({}, w.prop, { sorry:w.sorry }) };
      else if (w.look > 0) da = { act:'town_look', at:w.lt, adur:w.lt + w.look, prop:w.prop };
      else if (w.prop) da = { act:'town_walk', at:9, prop:w.prop };
    }
    ART.drawChar(ctx, w.k, x, y, sc, Object.assign({ t:t + w.ph, walk:w.walking, flip:w.dir < 0, tamed:true, untied:true, alpha:0.9 }, da));
  },
  bubble(ctx, o, text, life) {
    const sc = this.charScale(o.y), h = 58 * sc * (o.k === 'baiwu' ? 1.25 : o.k === 'xiaogui' ? 0.85 : 1);
    let x = this.X(o.x), y = this.Y(o.y) - h - 10;
    if (x < -40 || x > this.W + 40) return;
    ctx.save(); ctx.font = '700 14px ' + getComputedStyle(document.body).fontFamily;
    const maxW = 172, lines = []; let cur = '';
    for (const ch of text) { if (ctx.measureText(cur + ch).width > maxW && !'。，、！？；：」）…—'.includes(ch)) { lines.push(cur); cur = ch; } else cur += ch; } if (cur) lines.push(cur);
    const w = Math.max(...lines.map(l => ctx.measureText(l).width)) + 18, hh = lines.length * 19 + 12;
    const bx = Math.max(6, Math.min(this.W - w - 6, x - w / 2)), by = Math.max(6, y - hh);
    ctx.globalAlpha = Math.min(1, life * 3);
    ART.rr(ctx, bx, by, w, hh, 9, 'rgba(244,236,214,.96)', '#3a2a1a', 1.5);
    ctx.fillStyle = 'rgba(244,236,214,.96)'; ctx.beginPath(); ctx.moveTo(Math.max(bx + 10, Math.min(bx + w - 10, x)) - 6, by + hh - 1); ctx.lineTo(x, by + hh + 8); ctx.lineTo(Math.max(bx + 10, Math.min(bx + w - 10, x)) + 6, by + hh - 1); ctx.fill();
    ctx.fillStyle = '#2a1a10'; ctx.textAlign = 'left'; ctx.textBaseline = 'alphabetic'; lines.forEach((l, i) => ctx.fillText(l, bx + 9, by + 20 + i * 19));
    ctx.restore();
  },

  // ---------- 下面的面板 ----------
  renderPanel() {
    const p = $('#gs-panel'); if (!p) return; const v = this.view, s = this.st();
    let h = '';
    if (v.k === 'idle') {
      const first = (s.visits || 0) <= 1;
      h = `<p class="gs-hint">${first ? '點地面走路，按住拖著，阿福會跟著走。點攤位直接光顧。' : '想去哪一攤？'}</p>
        <div class="gs-chips">${GS_ORDER.map(k => `<button class="gs-chip" data-k="${k}">${GS_STALLS[k].name}</button>`).join('')}</div>
        ${s.meal ? `<p class="gs-note">肚子裡：${GS_MEALS[s.meal].name}（下一場出征生效）</p>` : ''}`;
    } else {
      h = `<div class="gs-ph"><b>${GS_STALLS[v.k].name}</b><button class="gs-x" id="gs-x" aria-label="離開">離開</button></div><div class="gs-body">${this['html_' + v.k]()}</div>`;
    }
    p.innerHTML = h;
    p.querySelectorAll('.gs-chip').forEach(b => b.onclick = () => this.goStall(b.dataset.k));
    const x = $('#gs-x'); if (x) x.onclick = () => { Sound.play('click'); if (v.k === 'haggle' && v.sub) { v.sub = null; this.renderPanel(); return; } this.view = { k:'idle' }; this.relax(); this.renderPanel(); };
    if (v.k !== 'idle') this['bind_' + v.k](p);
  },
  relax() { for (const k in this.keepers) { const kp = this.keepers[k]; kp.hold = false; kp.pose = null; kp.poseT = 0; } },
  keeperPose(k, pose, dur, hold) { const kp = this.keepers[k]; if (!kp) return; kp.pose = pose; kp.pt = 0; kp.poseT = dur || 1.2; kp.hold = !!hold; },
  coinsOk(n) { return (S.res.coins || 0) >= n; },
  spend(n) { S.res.coins -= n; UI.refresh(); },

  // 1. 紙紮鋪
  html_paper() {
    const fx = this.st().fx;
    return `<p class="gs-line"><b>小紙</b>燒了就是你的，永久有效。不退貨，因為已經燒了。</p><div class="gs-list">${Object.keys(GS_EFFIGY).map(k => { const e = GS_EFFIGY[k], own = fx[k];
      return `<div class="gs-card ${own ? 'own' : ''}"><div class="gs-ci"><b>${e.name}</b><small class="gs-eff">${e.eff}</small><small>${e.say}</small></div>
        <button class="btn ${own ? 'ghost' : 'gold'} sm gs-buy" data-k="${k}" ${own || !this.coinsOk(e.price) ? 'disabled' : ''}>${own ? '已燒' : `燒 ${e.price}`}</button></div>`; }).join('')}</div>`;
  },
  bind_paper(p) {
    p.querySelectorAll('.gs-buy').forEach(b => b.onclick = () => {
      const k = b.dataset.k, e = GS_EFFIGY[k], s = this.st(); if (s.fx[k] || !this.coinsOk(e.price)) return;
      this.spend(e.price); s.fx[k] = true; save(); Sound.play('chest');
      this.burn(GS_STALLS.paper.x); this.say(this.keepers.paper, '燒好了！' + e.eff + '。', 3); this.keeperPose('paper', 'cast', 1.2);
      this.float(this.afu.x, this.afu.y - 0.16, `${e.name}  到手`, '#ffe08a'); this.renderPanel();
    });
  },
  burn(fx) { for (let i = 0; i < 22; i++) this.parts.push({ kind:'joss', x:fx + (Math.random() - 0.5) * 0.06, y:0.62, bx:(Math.random() - 0.5) * 0.04, vx:0, vy:-0.08 - Math.random() * 0.06, rot:Math.random() * 6, vr:(Math.random() - 0.5) * 8, flip:0, vf:6, sw:2, ph:Math.random() * 6, land:2, life:2 + Math.random(), max:3 }); },

  // 2. 講價攤
  todayItems() { const d = gsDay(), idx = GS_ITEMS.map((_, i) => i).sort((a, b) => gsRnd(d * 31 + a) - gsRnd(d * 31 + b)); return idx.slice(0, 3).map(i => GS_ITEMS[i]); },
  floorOf(it) { return Math.round(it.col * (0.5 + 0.35 * gsRnd(gsDay() * 977 + it.col * 13 + it.id.length))); },
  askOf(it) { return Math.round(it.col * 1.15); },
  html_haggle() {
    const h = this.st().hag, v = this.view;
    if (h.out) return `<p class="gs-line bad"><b>小鬼</b>還敢回來？今晚不做你生意！明天請早。</p><p class="gs-note">你今晚侮辱了小鬼三次，被轟了出去。明天再來。</p>`;
    if (!v.sub) {
      return `<p class="gs-line"><b>小鬼</b>${(this.st().visits % 2) ? '看中哪件就出價。開太低，我會翻臉。' : '我的貨都是古董，你的出價最好也是。'}</p>
        <p class="gs-note">收藏家會照「收購價」收走你買到的東西。買得越便宜，賺得越多。小鬼心裡有底價，看他臉色推算。每件最多出價三次；侮辱他三次會被轟走。</p>
        <div class="gs-list">${this.todayItems().map(it => { const st = h.done[it.id];
          return `<button class="gs-card gs-item ${st ? 'own' : ''}" data-id="${it.id}" ${st ? 'disabled' : ''}><div class="gs-ci"><b>${it.name}</b><small>${it.desc}</small><small class="gs-eff">標價 ${this.askOf(it)}　收藏家收購 ${it.col}</small></div><em>${st === 'bought' ? '已買' : st === 'shelved' ? '收起來了' : '講價'}</em></button>`; }).join('')}</div>
        <p class="gs-note">侮辱 ${h.strikes}/3</p>`;
    }
    const it = GS_ITEMS.find(i => i.id === v.sub), tries = h.tries[it.id] || 0, ask = this.askOf(it), last = v.last;
    const offer = v.offer || Math.round(it.col * 0.6);
    const lv = last ? (last.band ? last.band.lv : 4) : -1, mood = last ? (last.band ? last.band.mood : '成交') : '打量你';
    return `<div class="gs-hag"><b class="gs-iname">${it.name}</b><small>${it.desc}</small>
      <div class="gs-prices"><span>標價 <b>${ask}</b></span><span>收藏家收購 <b>${it.col}</b></span></div>
      <p class="gs-line ${lv === 0 ? 'bad' : ''}"><b>小鬼</b>${last ? last.line : '出個價來聽聽。'}</p>
      <div class="gs-mood"><span>臉色</span>${['翻臉', '很臭', '猶豫', '肉痛', '成交'].map((m, i) => `<i class="${i === lv ? 'on' : ''}" style="--c:${['#e2483a', '#d07a3a', '#d8b84a', '#9ad05a', '#5ad0a0'][i]}">${m}</i>`).join('')}<em>${mood}</em></div>
      ${v.closed ? '' : `<div class="gs-offer"><button class="btn sm" id="gs-m">−5</button><input type="range" id="gs-r" min="5" max="${ask}" step="1" value="${offer}"><button class="btn sm" id="gs-p">+5</button></div>
      <button class="btn gold wide" id="gs-go" ${this.coinsOk(offer) ? '' : 'disabled'}>出價 <span id="gs-ov">${offer}</span> 冥幣</button>`}
      <p class="gs-note">第 ${Math.min(3, tries + (v.closed ? 0 : 1))}/3 次出價　侮辱 ${h.strikes}/3${v.closed ? '' : this.coinsOk(offer) ? '' : '　（冥幣不夠）'}</p>
      ${v.closed ? `<button class="btn wide" id="gs-back2">看別的貨</button>` : ''}</div>`;
  },
  bind_haggle(p) {
    const v = this.view, h = this.st().hag;
    p.querySelectorAll('.gs-item').forEach(b => b.onclick = () => { Sound.play('click'); v.sub = b.dataset.id; v.last = null; v.closed = false; v.offer = null; this.renderPanel(); this.keeperPose('haggle', null, 0); });
    const b2 = $('#gs-back2'); if (b2) b2.onclick = () => { v.sub = null; v.closed = false; v.last = null; this.renderPanel(); };
    const r = $('#gs-r'); if (!r) return;
    const set = (n) => { const it = GS_ITEMS.find(i => i.id === v.sub); n = Math.max(5, Math.min(this.askOf(it), n)); v.offer = n; r.value = n; $('#gs-ov').textContent = n; $('#gs-go').disabled = !this.coinsOk(n); };
    r.oninput = () => set(+r.value);
    $('#gs-m').onclick = () => set(+r.value - 5); $('#gs-p').onclick = () => set(+r.value + 5);
    $('#gs-go').onclick = () => this.offer(+r.value);
  },
  offer(n) {
    const v = this.view, s = this.st(), h = s.hag, it = GS_ITEMS.find(i => i.id === v.sub); if (!it || h.done[it.id] || h.out || !this.coinsOk(n)) return;
    const floor = this.floorOf(it), r = n / floor; h.tries[it.id] = (h.tries[it.id] || 0) + 1; const tries = h.tries[it.id];
    v.offer = n;
    if (r >= 1) {
      this.spend(n); S.res.coins += it.col; h.done[it.id] = 'bought'; s.curios.push(it.id); if (s.curios.length > 40) s.curios.shift();
      const fat = r >= 1.08; v.last = { band:null, line:pick(fat ? GS_DEAL_FAT : GS_DEAL_TIGHT) + `（收藏家用 ${it.col} 收走了，你${it.col - n >= 0 ? '賺' : '虧'}了 ${Math.abs(it.col - n)}）` }; v.closed = true;
      this.keeperPose('haggle', 'cast', 1.6); this.afu.pose = 'cast'; this.afu.poseT = 1;
      this.float(this.afu.x, this.afu.y - 0.16, `${it.col - n >= 0 ? '+' : '−'}${Math.abs(it.col - n)} 冥幣`, it.col - n >= 0 ? '#ffe08a' : '#ff9a8a'); Sound.play('coin');
    } else {
      const band = GS_BANDS.find(b => r < b.max); v.last = { band, line:band.lines[(tries - 1) % band.lines.length] };
      this.keeperPose('haggle', band.pose === 'idle' ? null : band.pose, 2.4, true);
      if (band.lv === 0) { h.strikes++; Sound.play('hit'); }
      else Sound.play('paper');
      if (h.strikes >= 3) { h.out = true; v.last.line = '三次侮辱我？給我滾！今晚別再來！'; this.kick = 1.1; this.say(this.keepers.haggle, '滾！', 2); this.afu.pose = 'hurt'; Sound.play('whoosh'); }
      else if (tries >= 3) { h.done[it.id] = 'shelved'; v.last.line += '……三次都談不攏，這件我收起來了！'; v.closed = true; }
      this.say(this.keepers.haggle, v.last.line.length > 22 ? v.last.line.slice(0, 20) + '……' : v.last.line, 2.4);
    }
    save(); this.renderPanel();
  },

  // 3. 冥幣兌換
  price(d) { const v = 100 * (1 + 0.16 * Math.sin(d * 0.5) + 0.05 * Math.sin(d * 1.9 + 1.3) + 0.06 * (gsRnd(d * 7 + 3) - 0.5)); return Math.max(30, Math.round(v)); },
  html_exch() {
    const d = gsDay(), p = this.price(d), y = this.price(d - 1), ch = (p - y) / y * 100, up = this.price(d + 1) >= p, st = this.st().stock;
    const news = (up ? GS_NEWS_UP : GS_NEWS_DN)[Math.floor(gsRnd(d * 5 + 1) * 5)];
    const val = st.n * p, pl = st.n ? val - st.cost : 0;
    return `<p class="gs-line"><b>白無常</b>一見生財！小道消息：「${news}」</p>
      <div class="gs-stock"><div><small>地府科技（今日）</small><b class="gs-px">${p}</b><em class="${ch >= 0 ? 'up' : 'dn'}">${ch >= 0 ? '▲' : '▼'} ${Math.abs(ch).toFixed(1)}%</em></div><canvas id="gs-chart"></canvas></div>
      <p class="gs-note">持有 ${st.n} 股（上限 ${GS_SHARE_CAP}）　市值 ${fmt(val)}　${st.n ? `<span class="${pl >= 0 ? 'up' : 'dn'}">${pl >= 0 ? '賺' : '虧'} ${fmt(Math.abs(pl))}</span>` : ''}　手續費 ${GS_FEE * 100}%（買賣都收）</p>
      <div class="gs-trade"><button class="btn sm gs-t" data-q="1">買 1</button><button class="btn sm gs-t" data-q="10">買 10</button><button class="btn sm gs-t" data-q="-1">賣 1</button><button class="btn sm gs-t" data-q="-10">賣 10</button><button class="btn sm gs-t" data-q="-999">全賣</button></div>
      <p class="gs-note dim">價格每天換一次。白無常的小道消息說的是「明天」，他從來沒說錯過——只是不保證漲多少。</p>`;
  },
  bind_exch(p) {
    p.querySelectorAll('.gs-t').forEach(b => {
      const q = +b.dataset.q, px = this.price(gsDay()), st = this.st().stock;
      if (q > 0) b.disabled = st.n >= GS_SHARE_CAP || !this.coinsOk(Math.ceil(px * Math.min(q, GS_SHARE_CAP - st.n) * (1 + GS_FEE)));
      else b.disabled = st.n <= 0;
      b.onclick = () => this.trade(q);
    });
    this.drawChart();
  },
  trade(q) {
    const s = this.st(), st = s.stock, px = this.price(gsDay());
    if (q > 0) { q = Math.min(q, GS_SHARE_CAP - st.n); const cost = Math.ceil(px * q * (1 + GS_FEE)); if (q <= 0 || !this.coinsOk(cost)) return; this.spend(cost); st.n += q; st.cost += cost; this.float(this.afu.x, this.afu.y - 0.16, `買入 ${q} 股`, '#bfe8ff'); this.say(this.keepers.exch, pick(['一見生財！有眼光！', '買定離手～', '恭喜發財，虧了別找我。']), 2.4); }
    else { q = Math.min(-q, st.n); if (q <= 0) return; const got = Math.floor(px * q * (1 - GS_FEE)); const basis = st.cost * q / st.n; st.cost -= basis; st.n -= q; S.res.coins += got; UI.refresh(); this.float(this.afu.x, this.afu.y - 0.16, `賣出 +${got}`, got >= basis ? '#ffe08a' : '#ff9a8a'); this.say(this.keepers.exch, got >= basis ? '一見生財！賺到了吧～' : '虧了？陰間也有韭菜的。', 2.4); }
    if (st.n === 0) st.cost = 0;
    this.keeperPose('exch', 'cast', 1); Sound.play('coin'); save(); this.renderPanel();
  },
  drawChart() {
    const c = $('#gs-chart'); if (!c) return; const r = c.getBoundingClientRect(), dpr = Math.min(2, window.devicePixelRatio || 1), w = r.width || 200, h = r.height || 84;
    c.width = w * dpr; c.height = h * dpr; const ctx = c.getContext('2d'); ctx.scale(dpr, dpr);
    const d = gsDay(), ps = Array.from({ length:7 }, (_, i) => this.price(d - 6 + i)), lo = Math.min(...ps) * 0.95, hi = Math.max(...ps) * 1.05;
    const X = (i) => 10 + i * (w - 20) / 6, Y = (v) => h - 16 - (v - lo) / (hi - lo) * (h - 28);
    ctx.strokeStyle = 'rgba(255,255,255,.12)'; ctx.lineWidth = 1; for (let i = 0; i < 3; i++) { const y = 8 + i * (h - 24) / 2; ctx.beginPath(); ctx.moveTo(4, y); ctx.lineTo(w - 4, y); ctx.stroke(); }
    ctx.strokeStyle = '#9be8b0'; ctx.lineWidth = 2.2; ctx.beginPath(); ps.forEach((v, i) => i ? ctx.lineTo(X(i), Y(v)) : ctx.moveTo(X(i), Y(v))); ctx.stroke();
    ps.forEach((v, i) => { ctx.fillStyle = i === 6 ? '#ffcf6a' : '#9be8b0'; ctx.beginPath(); ctx.arc(X(i), Y(v), i === 6 ? 4.5 : 2.6, 0, 7); ctx.fill(); });
    ctx.fillStyle = 'rgba(230,220,255,.7)'; ctx.font = '11px sans-serif';
    ['六天前', '', '', '', '', '昨天', '今天'].forEach((l, i) => { if (!l) return; ctx.textAlign = i === 0 ? 'left' : i === 6 ? 'right' : 'center'; ctx.fillText(l, i === 0 ? 2 : i === 6 ? w - 2 : X(i), h - 2); });
  },

  // 4. 宵夜檔
  html_food() {
    const s = this.st();
    return `<p class="gs-line"><b>餓鬼王</b>${this.ate ? '吃飽了就走！後面還有鬼在排隊！' : '一次只准點一碗！吃完下一場打架才有力！'}</p>
      ${s.meal ? `<p class="gs-note">肚子裡：<b>${GS_MEALS[s.meal].name}</b>（下一場出征生效，再點會換掉）</p>` : ''}
      <div class="gs-list">${Object.keys(GS_MEALS).map(k => { const m = GS_MEALS[k];
        return `<div class="gs-card ${s.meal === k ? 'own' : ''}"><div class="gs-ci"><b>${m.name}</b><small class="gs-eff">${m.eff}</small><small>${m.say}</small></div>
          <button class="btn gold sm gs-eat" data-k="${k}" ${this.ate || !this.coinsOk(m.price) ? 'disabled' : ''}>${this.ate ? '吃飽了' : `吃 ${m.price}`}</button></div>`; }).join('')}</div>`;
  },
  bind_food(p) {
    p.querySelectorAll('.gs-eat').forEach(b => b.onclick = () => {
      const k = b.dataset.k, m = GS_MEALS[k]; if (this.ate || !this.coinsOk(m.price)) return;
      this.spend(m.price); this.st().meal = k; this.ate = true; save(); Sound.play('harvest');
      this.say(this.keepers.food, pick(['吃！吃完去打！', '好吃吧？我也想吃……我可以吃一口嗎？', '湯可以續，碗不能拿走！']), 2.6); this.keeperPose('food', 'cast', 1.2);
      this.afu.pose = 'cast'; this.afu.poseT = 0.8; this.float(this.afu.x, this.afu.y - 0.16, m.eff.replace('下一場出征：', ''), '#a8ffcf'); this.renderPanel();
    });
  },

  // 5. 暗巷
  html_alley() {
    if (this.alleyDone) return `<p class="gs-line">${this.alleyDone.out}</p><p class="gs-note">${this.alleyDone.got ? '結果：' + this.alleyDone.got : ''}</p><p class="gs-note dim">今晚巷子裡已經沒有別的事了。下次再來看看。</p>`;
    if (!this.alleyEv) { const s = this.st(), pool = GS_ALLEY.filter(e => e.id !== s.alleyLast); this.alleyEv = (typeof N30W !== 'undefined' && N30W.alleyEvent()) || pool[Math.floor(Math.random() * pool.length)]; s.alleyLast = this.alleyEv.id; save(); } // 日本妖怪偶爾喺暗巷出現（n30_data.js）
    const e = this.alleyEv, opt = (o, k) => `<button class="btn ${k === 'a' ? 'gold' : ''} wide gs-al" data-k="${k}" ${o.cost && !this.coinsOk(o.cost) ? 'disabled' : ''}>${o.label}${o.cost ? `（${o.cost} 冥幣）` : ''}</button>`;
    return `<p class="gs-line">${e.text}</p>${opt(e.a, 'a')}${opt(e.b, 'b')}`;
  },
  bind_alley(p) {
    p.querySelectorAll('.gs-al').forEach(b => b.onclick = () => {
      const o = this.alleyEv[b.dataset.k]; if (o.cost && !this.coinsOk(o.cost)) return;
      if (o.cost) this.spend(o.cost);
      const r = Object.assign({}, o.give || {}); if (r.troops) r.troops = Math.max(0, Math.min(r.troops, F.troopCap() - S.res.troops));
      if (r.troops === 0) delete r.troops;
      let got = Object.keys(r).length ? give(r) : ''; if (o.cost) got = `冥幣 −${o.cost}` + (got ? '，' + got : '');
      if (o.join) { joinGhost(o.join); got += (got ? '，' : '') + `${GHOSTS[o.join].name}加入`; }
      this.alleyDone = { out:o.out, got }; Sound.play(r.chest ? 'chest' : 'paper'); save(); UI.refresh();
      this.float(this.afu.x, this.afu.y - 0.16, got.split('，')[0] || '……', '#e6dcff'); this.renderPanel();
    });
  },
};
