// ===================== 回陽間・近身操作 =====================
// 揀中一個人之後，按佢「而家做緊乜」出現唔同操作：
//   手機：多個 app 可以揭（訊息／相簿／搜尋紀錄／備忘錄）；揭到某啲內容會得到「情報」；傳訊息可以揀冒充邊個、傳咩內容，用情報針對佢最嚇人
//   電腦：佢喺座位做嘢時，睇到佢個螢幕；可以拔電線、改文件、自動寄電郵、開鏡頭……
//   茶水間：佢喺茶水間時，六種唔同嚇法
// 全部都經 Scare.hit() 計分（怕／唔怕、鋪墊→爆點、穿崩規則照舊），呢度只係揀「用咩方法、算邊一類怕」
// 開住手機／電腦畫面時時間停（同舊嘅偷看手機一樣）
const ScareOps = (() => {
  const D = (yue, zh) => { if (typeof LANG !== 'undefined') LANG.add({ [yue]:zh }); return yue; }; // 講出口嘅對白：粵語原句＋中文版
  const Lx = (s) => typeof L === 'function' ? L(s) : s;
  const CD = 25; // 同一個人同一招：冷卻秒數
  // 選項：{ id, who（冒充邊個）, text, type（算邊一類怕）, tier（1 鋪墊／3 大招）, base, cost, need（要邊個情報）, say（佢嘅反應，粵＋中）, trap（反效果）, warm（陰德） }
  const OPS = {
    ken: {
      apps: {
        msg: [
          { title:'老闆', items:[['老闆', '23:02', '阿Ken，明早九點董事會，PPT 再改一版。'], ['阿Ken', '23:03', '好的老闆，收到。'], ['老闆', '01:40', '在嗎？'], ['阿Ken', '01:40', '在！']] },
          { title:'阿福哥', intel:'afu', items:[['阿福哥', '三個月前', '今晚又 OT，你先走吧，我幫你頂。'], ['阿Ken', '三個月前', '阿福哥，你都早點走。'], ['阿福哥', '三個月前', '做完這份就走。'], ['', '', '（之後再沒有訊息）']] },
          { title:'家庭群組', intel:'mom', items:[['媽', '昨天', '阿Ken，這個禮拜回來吃飯嗎？媽煲了湯。'], ['阿Ken', '昨天', '下次吧，最近很忙'], ['爸', '昨天', '（貼圖：一碗湯）'], ['媽', '今天', '湯還在。']] },
        ],
        photo: ['董事會PPT_第23版（截圖）', '公司樓下的雲吞麵（第 31 次）', '阿福哥的生日蛋糕（三個月前，辦公室）', '媽煲的湯（媽傳來的）'],
        search: [['辭職信 範本 禮貌', 'quit'], ['老闆半夜發訊息 違法嗎', ''], ['PPT 字體 老闆說不夠專業', ''], ['回家 機票 便宜', 'mom']],
        note: ['PPT 改：', '1. logo 放大', '2. logo 縮回原本大小', '3. 改回第一版', '4. ？？？'],
      },
      msgs: [
        { id:'k1', who:'陌生號碼', text:'你後面那張椅子，是誰坐著？', type:'phone', tier:1, base:22, cost:18 },
        { id:'k2', who:'老闆', text:'在嗎？', type:'phone', tier:1, base:26, cost:16, say:D('（條件反射彈起身）在！我在！', '（條件反射彈起身）在！我在！') },
        { id:'k3', who:'阿Ken（他自己）', text:'（一張相：他現在的背影，從他身後拍的）', type:'phone', tier:3, base:34, cost:28 },
        { id:'k4', who:'阿福哥', need:'afu', text:'今晚又 OT？你都早點走。', type:'face', tier:3, base:40, cost:30, say:D('阿……阿福哥？你個號碼……仲用緊？', '阿……阿福哥？你的號碼……還在用？') },
        { id:'k5', who:'媽', need:'mom', text:'阿Ken，湯凍了。媽在你後面。', type:'phone', tier:3, base:38, cost:26, say:D('媽？你……你喺邊？', '媽？你……你在哪裡？') },
        { id:'k6', who:'人事部', need:'quit', text:'你的辭職信已收到，即日生效，不用再回來。', trap:true, cost:16, say:D('（偷偷笑咗出嚟）真係……真係得咗？', '（偷偷笑了出來）真的……真的可以？'), why:'他太開心，反而一點都不怕了' },
      ],
      pc: { title:'董事會簡報_最終版_v23_真最終.pptx', lines:['第 1 頁：本季業績（陳總要求：要好睇）', '第 2 頁：增長 3%（陳總要求：改成 30%）', '第 3 頁：謝謝（陳總要求：字大啲）', '自動儲存：關閉'],
        ops: [
          { id:'kp1', text:'拔電線（他還沒儲存）', type:'paper', tier:1, base:24, cost:20, say:D('我未 save 呀！！第 23 版呀！！', '我還沒存檔啊！！第 23 版啊！！') },
          { id:'kp2', text:'把每一頁的標題改成「救我」', type:'paper', tier:3, base:38, cost:30, say:D('邊……邊個改咗我啲 slide？！', '誰……誰改了我的投影片？！') },
          { id:'kp3', text:'用他的帳號寄電郵給陳總：「我不幹了」', type:'paper', tier:3, base:36, cost:28, say:D('唔係我寄㗎！撤回！點撤回呀？！', '不是我寄的！收回！怎麼收回？！') },
          { id:'kp4', text:'打開視像鏡頭：畫面裡他身後多了一個人', type:'face', tier:3, base:40, cost:32 },
          { id:'kp5', text:'桌布換成阿福哥的員工證', type:'face', tier:1, base:24, cost:20, say:D('……阿福哥張工作證，點解會喺度？', '……阿福哥的員工證，怎麼會在這裡？') },
        ] },
    },
    it: {
      apps: {
        msg: [
          { title:'值班系統', items:[['值班系統', '01:12', '【P1】23 樓伺服器溫度 4°C，請立即處理。'], ['值班系統', '01:13', '【P1】溫度 2°C。'], ['值班系統', '01:14', '【P1】溫度 -1°C。伺服器室有人呼吸。']] },
          { title:'二十三樓八卦群', intel:'gossip', items:[['阿Ken', '00:30', '聽說 23 樓半夜影印機會自己印東西'], ['小晴', '00:31', '是驅動程式的問題，不要迷信。'], ['美美', '00:32', '小晴你最膽小，上次停電你叫得最大聲'], ['小晴', '00:32', '那是 UPS 響！不是我！']] },
          { title:'珍奶店', intel:'boba', items:[['珍奶店', '22:58', '您的訂單：全糖、多珍珠、去冰（第 3 杯）已送達。'], ['珍奶店', '23:59', '感謝您本月第 41 杯！您已成為鑽石會員。']] },
          { title:'媽', items:[['媽', '23:40', '妹，又值夜班？記得吃飯。'], ['小晴', '23:41', '有啦，珍奶算一餐。']] },
        ],
        photo: ['珍奶 ×47', '伺服器機櫃（自拍）', '停電那晚的監控截圖（角落有一團白色）'],
        search: [['伺服器 溫度 突然 4度 原因', ''], ['23樓 影印機 半夜 自己印', 'gossip'], ['珍奶 一日 幾杯 太多', 'boba'], ['UPS 響 聲音 像人叫', 'gossip']],
        note: ['root 密碼：不要寫在這裡', '值班表：我、我、我、我'],
      },
      msgs: [
        { id:'i1', who:'值班系統', text:'【P0】伺服器室有人登入。用戶名：AFU', type:'phone', tier:1, base:24, cost:18, say:D('AFU？我哋公司冇呢個 user……', 'AFU？我們公司沒有這個帳號……') },
        { id:'i2', who:'陌生號碼', text:'（語音訊息，只有呼吸聲。她戴著耳機。）', type:'sound', tier:3, base:36, cost:28 },
        { id:'i3', who:'珍奶店', need:'boba', text:'您的第 4 杯已送達。送貨員說：放在您後面了。', type:'phone', tier:3, base:40, cost:28, say:D('我……我冇叫第四杯……', '我……我沒叫第四杯……') },
        { id:'i4', who:'美美', need:'gossip', text:'小晴你又在公司？UPS 又響了，你聽到嗎？', type:'sound', tier:1, base:26, cost:18, say:D('UPS……今晚冇響呀……', 'UPS……今晚沒響啊……') },
        { id:'i5', who:'陳總', text:'小晴，網站是不是慢了？', trap:true, cost:14, say:D('（反白眼）陳總，係你屋企 Wi-Fi。', '（翻白眼）陳總，是你家的 Wi-Fi。'), why:'她只覺得煩，完全清醒了' },
      ],
      pc: { title:'終端機 — server-23f.log', lines:['01:12  WARN  temp 4°C', '01:13  WARN  temp 2°C', '01:14  INFO  user login: ???', '01:14  INFO  door 23F-server opened'],
        ops: [
          { id:'ip1', text:'拔伺服器電源：全層警報大響', type:'sound', tier:1, base:24, cost:20, say:D('production 跌咗？！唔好呀！', 'production 掛了？！不要啊！') },
          { id:'ip2', text:'把 log 每一行改成「小晴你好」', type:'light', tier:3, base:38, cost:30, say:D('呢個唔係 bug……呢個唔係 bug……', '這不是 bug……這不是 bug……') },
          { id:'ip3', text:'遠端控制：游標自己動，慢慢打出「我好凍」', type:'light', tier:3, base:40, cost:32 },
          { id:'ip4', text:'在她耳機播：「小晴……還在嗎……」', type:'sound', tier:3, base:40, cost:32 },
          { id:'ip5', text:'把她電腦的冷氣控制調到 16°C', type:'cold', tier:1, base:20, cost:16 },
        ] },
    },
    mis: {
      apps: {
        msg: [
          { title:'陳總', intel:'boss', items:[['陳總', '00:45', '美美，明天陪我去見客，記得穿漂亮點。'], ['美美', '00:46', '陳總～人家要放假啦～'], ['陳總', '00:46', '放！做完這季就放！']] },
          { title:'姊妹群', items:[['姊妹', '01:02', '你還在公司？'], ['美美', '01:03', '是呀，陳總說他一個人怕 🙄'], ['姊妹', '01:04', '你們 23 樓不是有那個傳說嗎']] },
          { title:'阿Ken', items:[['美美', '01:20', '阿Ken，那份報告你幫我打完吧，陳總要的。'], ['阿Ken', '01:21', '……好。']] },
        ],
        photo: ['自拍 #382（今晚，辦公室）', '自拍 #383（今晚，辦公室，背景有點模糊）', '自拍 #384（她刪了）', '日本機票（已收藏）'],
        search: [['甩妝 急救 方法', ''], ['日本 購物 壓驚', ''], ['自拍 背景 多了一個人', 'selfie']],
        note: ['IG 文案：今晚又陪老闆加班～ #努力', '要阿Ken做：報告、PPT、陳總的生日卡'],
        intelPhoto:'selfie',
      },
      msgs: [
        { id:'m1', who:'Instagram', need:'selfie', text:'有人在你最新的自拍留言：「你後面那位是誰？」', type:'phone', tier:3, base:40, cost:28, say:D('我後面……冇人㗎……', '我後面……沒有人啊……') },
        { id:'m2', who:'陳總', need:'boss', text:'美美，進來我房。', type:'phone', tier:1, base:24, cost:16, say:D('嚟緊喇陳總～……咦，陳總唔係出咗去咩？', '來了陳總～……咦，陳總不是出去了嗎？') },
        { id:'m3', who:'姊妹群', text:'你還在公司？你後面那個……', type:'phone', tier:1, base:22, cost:16 },
        { id:'m4', who:'（前鏡頭自己打開）', text:'自拍畫面裡，她肩膀上多了一隻手', type:'breath', tier:3, base:38, cost:30 },
        { id:'m5', who:'網購', text:'您訂購的「防甩妝噴霧 ×6」已送達：二十三樓，阿福的座位。', type:'phone', tier:1, base:22, cost:16, say:D('阿福……係邊個？', '阿福……是誰？') },
      ],
    },
    boss: {
      apps: {
        msg: [
          { title:'Master Lee', intel:'master', items:[['Master Lee', '昨天', '陳總，你這層樓陰氣很重，水晶球記得對著窗口。'], ['Master Lee', '昨天', '還有，千萬不要讓影印機半夜自己開。'], ['陳總', '昨天', '收到大師！轉帳了。']] },
          { title:'美美', items:[['陳總', '00:45', '美美，明天陪我去見客，記得穿漂亮點。'], ['美美', '00:46', '陳總～人家要放假啦～']] },
          { title:'董事會', intel:'board', items:[['董事會秘書', '20:00', '提醒：明早九點董事會，請準備本季業績。'], ['陳總', '20:01', '沒問題，業績很好。']] },
        ],
        photo: ['水晶球（對著窗口）', '高爾夫一桿進洞（其實是別人的）', '本季虧損報表（截圖，標題：不要給董事會看）'],
        search: [['水晶球 擺放 位置 辦公室', 'master'], ['虧損 怎樣 不讓董事會知道', 'board'], ['Master Lee 電話', 'master']],
        note: ['明天：叫阿Ken 改 PPT', '後天：叫阿Ken 再改 PPT', '叫 Master Lee 來看風水（又）'],
      },
      msgs: [
        { id:'b1', who:'陌生號碼', text:'陳總，你後面有人。', type:'phone', tier:1, base:22, cost:14 },
        { id:'b2', who:'Master Lee', need:'master', text:'陳總，我看到你房裡有個黑影站在水晶球後面。', type:'shadow', tier:3, base:40, cost:30, say:D('大師！你點睇到㗎？！你喺邊呀？！', '大師！你怎麼看得到？！你在哪裡？！') },
        { id:'b3', who:'Master Lee', need:'master', text:'影印機開了沒有？開了就快走。', type:'paper', tier:1, base:26, cost:18, say:D('（望住影印機）……佢未開。佢未開，係咪？', '（盯著影印機）……它沒開。它沒開，對吧？') },
        { id:'b4', who:'董事會秘書', need:'board', text:'通知：董事會改為今晚三點，地點：二十三樓，陳總的房。', type:'paper', tier:3, base:36, cost:28, say:D('今晚？！我份數未整靚呀！', '今晚？！我的數字還沒整理好！') },
      ],
      pc: { title:'高爾夫教學影片（全螢幕）', lines:['（背景開著：本季虧損報表.xlsx）', '（另一個分頁：Master Lee 開運水晶網購）'],
        ops: [
          { id:'bp1', text:'把虧損報表切到全螢幕', type:'paper', tier:3, base:38, cost:30, say:D('邊個開咗呢份嘢出嚟？！', '誰把這份東西打開了？！') },
          { id:'bp2', text:'自動把虧損報表寄給董事會', type:'paper', tier:3, base:42, cost:34, say:D('唔好寄！唔好寄呀！！', '不要寄！不要寄啊！！') },
          { id:'bp3', text:'影片裡的球童慢慢轉頭，望著他', type:'shadow', tier:1, base:26, cost:20 },
          { id:'bp4', text:'拔電線：螢幕黑了，反光裡多了一個影', type:'shadow', tier:3, base:36, cost:28 },
        ] },
    },
    auntie: {
      apps: {
        msg: [
          { title:'兒子', intel:'son', items:[['兒子', '22:30', '媽，又做到幾點？'], ['清潔安娣', '22:31', '做完就回。你先吃，不用等。'], ['兒子', '22:32', '我買了你最愛的雞飯，放在桌上。']] },
          { title:'老闆娘', items:[['老闆娘', '20:00', '安娣，今晚地板要拖三次，陳總說要亮。'], ['清潔安娣', '20:01', '好。']] },
        ],
        photo: ['孫子的生日（去年）', '地板（拖完，很亮）'],
        search: [['雞飯 外賣', 'son'], ['膝蓋 痛 拖地', '']],
        note: ['23 樓：拖三次', '22 樓：不用拖（說那層有東西）'],
      },
      msgs: [
        { id:'a1', who:'陌生號碼', text:'剛拖完的地，又有腳印了。', type:'face', tier:1, base:22, cost:16, say:D('邊個踩我啲地？！', '誰踩我的地？！') },
        { id:'a2', who:'兒子', need:'son', text:'媽，早點回來，雞飯凍了。', warm:true, cost:10, say:D('（望住手機笑咗一笑）……好，拖埋呢間就走。', '（看著手機笑了笑）……好，拖完這間就走。'), why:'她沒有被嚇到，但今晚會早點回家' },
      ],
    },
    guard: {
      apps: {
        msg: [
          { title:'阿福', intel:'afu', items:[['阿福', '三個月前', '阿伯，我又加班，今晚不用幫我留燈。'], ['保安阿伯', '三個月前', '留咯。你走了我才關。']] },
          { title:'女兒', items:[['女兒', '今天', '爸，今晚幾點下班？'], ['保安阿伯', '今天', '天亮。'], ['保安阿伯', '今天', '那個阿Ken，跟阿福一樣，都不回家。']] },
        ],
        photo: ['23 樓的燈（三個月前，很晚，還亮著）'],
        search: [['怎樣叫年輕人早點回家', '']],
        note: ['23 樓的燈：等阿Ken 走了才關'],
      },
      msgs: [],
    },
  };
  // 茶水間：大家共用，揀佢怕嗰樣
  const PANTRY = [ // fx：茶水間邊部機郁（pantry.js 畫效果）
    { id:'p1', text:'販賣機自己「哐咚」掉出一罐汽水，滾到他腳邊', type:'sound', tier:1, base:24, cost:18, fx:'vend' },
    { id:'p2', text:'販賣機玻璃後面黑影一閃，一包零食自己掉了出來', type:'shadow', tier:2, base:30, cost:22, fx:'snack' },
    { id:'p3', text:'雪櫃門自己開了又關、關了又開，冷氣一陣一陣湧出來', type:'cold', tier:1, base:22, cost:16, fx:'fridgeloop' },
    { id:'p4', text:'水機自己漏水，一滴一滴，地上積了一灘冰水', type:'cold', tier:2, base:28, cost:20, fx:'water' },
    { id:'p5', text:'咖啡機自己沖了一杯咖啡，熱氣呼到他臉上', type:'breath', tier:2, base:30, cost:22, fx:'coffee' },
    { id:'p6', text:'微波爐自己轉起來「叮」一聲，門後貼著一張臉', type:'face', tier:3, base:38, cost:30, fx:'micro' },
    { id:'p7', text:'熱水壺咕嚕咕嚕，好像在說：「好凍……」', type:'sound', tier:1, base:20, cost:14, fx:'kettle' },
    { id:'p8', text:'茶水間的燈一閃一閃', type:'light', tier:1, base:22, cost:16, fx:'lights' },
  ];
  const TAB = { msg:'訊息', photo:'相簿', search:'搜尋紀錄', note:'備忘錄' };
  const INTEL_NAME = { afu:'阿福哥的舊訊息', mom:'媽媽的湯', quit:'他想辭職', gossip:'八卦群的傳聞', boba:'珍奶店訂單', selfie:'自拍裡的模糊人影', boss:'陳總的訊息', master:'Master Lee 的叮囑', board:'董事會', son:'兒子的雞飯' };

  // ---------- 狀態 ----------
  const intel = (Sc, k) => { Sc._intel = Sc._intel || {}; return (Sc._intel[k] = Sc._intel[k] || new Set()); };
  const cdOf = (Sc, n, id) => { Sc._opcd = Sc._opcd || {}; return Math.max(0, (Sc._opcd[n.d.k + id] || 0) - Sc.t); };
  function ctx(Sc, n) { // 佢而家喺邊、做緊乜
    const st = n.step || {}, room = Sc.site.pano ? Sc.roomOf(n) : '';
    const act = n.act || (st.arrived && st.act) || '';
    const atDesk = !!(OPS[n.d.k] && OPS[n.d.k].pc && ['work', 'call'].includes(act) && room !== 'pantry'); // 坐喺位做緊嘢（行緊路唔算）
    return { room, atDesk, pantry:room === 'pantry' };
  }
  function buttons(Sc, n) {
    const O = OPS[n.d.k]; if (!O || n.out) return '';
    const c = ctx(Sc, n); let h = '';
    if (O.apps) h += `<button class="btn sm" data-op="phone">手機</button>`;
    if (c.atDesk) h += `<button class="btn sm gold" data-op="pc">電腦</button>`;
    if (c.pantry && !n.d.guard) h += `<button class="btn sm gold" data-op="pantry">茶水間</button>`;
    return h;
  }
  // ---------- 視窗 ----------
  function modal(Sc, html, cls) {
    Sc.paused = true; const p = $('#sc-phone'); p.innerHTML = `<div class="${cls}">${html}</div>`; p.classList.add('on');
    p.querySelectorAll('[data-x]').forEach(b => b.onclick = () => close(Sc));
    return p;
  }
  function close(Sc) { const p = $('#sc-phone'); p.classList.remove('on'); p.innerHTML = ''; Sc.paused = false; Sc.last = performance.now(); Sc.renderTarget(); }
  function openPhone(Sc, n, tab) {
    const O = OPS[n.d.k], A = O.apps, I = intel(Sc, n.d.k); tab = tab || 'msg';
    Sc.known = Sc.known || {}; const K = Sc.known[n.d.k] = Sc.known[n.d.k] || new Set(); (n.d.hide || []).forEach(t => K.add(t)); // 舊規則：揭手機就知佢隱藏嘅弱點
    const got = [];
    const learn = (k) => { if (k && !I.has(k)) { I.add(k); got.push(INTEL_NAME[k] || k); } };
    let body = '';
    if (tab === 'msg') { body = A.msg.map(c => { learn(c.intel); return `<div class="so-chat"><div class="so-ct">${c.title}</div>${c.items.map(m => m[0] ? `<div class="sc-m ${m[0] === n.d.name ? 'me' : ''}"><i>${m[0]}・${m[1]}</i>${m[2]}</div>` : `<div class="so-sys">${m[2]}</div>`).join('')}</div>`; }).join(''); }
    if (tab === 'photo') { learn(A.intelPhoto); body = `<div class="so-photos">${A.photo.map((p, i) => `<div class="so-ph"><span>${i + 1}</span>${p}</div>`).join('')}</div>`; }
    if (tab === 'search') { body = A.search.map(s => { learn(s[1]); return `<div class="so-search">🔍 ${s[0]}</div>`; }).join(''); }
    if (tab === 'note') body = `<div class="so-note">${A.note.map(l => `<p>${l}</p>`).join('')}</div>`;
    const msgs = O.msgs || [];
    const p = modal(Sc, `<div class="sc-ph-h">${n.d.name} 的手機<button data-x>✕</button></div>
      <div class="so-tabs">${Object.keys(TAB).map(k => `<button class="${k === tab ? 'on' : ''}" data-tab="${k}">${TAB[k]}</button>`).join('')}</div>
      <div class="sc-ph-b">${body}</div>
      ${got.length ? `<div class="so-got">得到情報：${got.join('、')}</div>` : ''}
      <div class="sc-ph-f">${msgs.length ? `<button class="btn gold wide" data-send>傳訊息嚇他</button>` : ''}<small>看手機時，時間是停的。</small></div>`, 'sc-ph so-phone');
    p.querySelectorAll('[data-tab]').forEach(b => b.onclick = () => openPhone(Sc, n, b.dataset.tab));
    const s = p.querySelector('[data-send]'); if (s) s.onclick = () => compose(Sc, n);
    if (got.length && !Sc.headless) Sc.renderTarget();
  }
  function optRow(Sc, n, o, locked) {
    const cd = cdOf(Sc, n, o.id), poor = Sc.mana < o.cost;
    return `<button class="so-op ${locked ? 'lock' : ''} ${cd || poor ? 'dim' : ''}" data-o="${o.id}" ${locked || cd ? 'disabled' : ''}>
      ${o.who ? `<b>${o.who}</b>` : ''}<span>${o.text}</span><small>${locked ? `需要情報：${INTEL_NAME[o.need]}（先看他的手機）` : cd ? `冷卻 ${Math.ceil(cd)} 秒` : `陰氣 ${o.cost}${o.trap || o.warm ? '' : `・算「${FEAR_WORD[o.type]}」`}`}</small></button>`;
  }
  function compose(Sc, n) {
    const O = OPS[n.d.k], I = intel(Sc, n.d.k);
    const p = modal(Sc, `<div class="sc-ph-h">傳訊息給 ${n.d.name}<button data-x>✕</button></div><div class="sc-ph-b so-list"><p class="so-hint">選冒充誰、傳什麼。對準他怕的、用上情報，嚇得最狠；選錯了可能反效果。</p>${O.msgs.map(o => optRow(Sc, n, o, o.need && !I.has(o.need))).join('')}</div><div class="sc-ph-f"><button class="btn sm" data-back>返回手機</button></div>`, 'sc-ph so-phone');
    p.querySelector('[data-back]').onclick = () => openPhone(Sc, n);
    bindOps(Sc, n, p, O.msgs, 'msg');
  }
  function openPC(Sc, n) {
    const P = OPS[n.d.k].pc;
    const p = modal(Sc, `<div class="so-mon"><div class="so-mh">${n.d.name} 的電腦<button data-x>✕</button></div><div class="so-scr"><b>${P.title}</b>${P.lines.map(l => `<p>${l}</p>`).join('')}</div></div><div class="so-list">${P.ops.map(o => optRow(Sc, n, o)).join('')}</div>`, 'so-pc');
    bindOps(Sc, n, p, P.ops, 'pc');
  }
  function openPantry(Sc, n) {
    const p = modal(Sc, `<div class="so-mh">茶水間・${n.d.name}<button data-x>✕</button></div><div class="so-list"><p class="so-hint">他在茶水間。選一樣他怕的。</p>${PANTRY.map(o => optRow(Sc, n, o)).join('')}</div>`, 'so-pc');
    bindOps(Sc, n, p, PANTRY, 'pantry');
  }
  function bindOps(Sc, n, p, list, kind) { p.querySelectorAll('[data-o]').forEach(b => b.onclick = () => { const o = list.find(x => x.id === b.dataset.o); if (o) act(Sc, n, o, kind); }); }

  // ---------- 執行 ----------
  function act(Sc, n, o, kind) {
    if (Sc.mana < o.cost) { Sc.toast('陰氣不夠，等一下'); return; }
    if (cdOf(Sc, n, o.id) > 0) return;
    close(Sc);
    if (n.gone || n.out || n.fleeing) { Sc.toast(`${n.d.name}不在`); return; }
    Sc.mana -= o.cost; Sc._opcd = Sc._opcd || {}; Sc._opcd[n.d.k + o.id] = Sc.t + CD;
    if (!Sc.headless) { try { Sound.play(kind === 'msg' ? 'click' : kind === 'pc' ? 'paper' : 'whoosh'); } catch (e) {} Sc.fx.push({ kind:kind === 'msg' ? 'phone' : 'breath', life:1.6, max:1.6, n }); }
    const tag = kind === 'msg' ? `📱 ${o.who}：${o.text}` : o.text;
    Sc.float(n.x, n.y - 0.3, tag.length > 26 ? tag.slice(0, 25) + '…' : tag, '#e8d8ff', 2);
    if (o.fx && typeof Pantry !== 'undefined' && !Sc.headless) { try { Pantry.fx(o.fx, n); } catch (e) {} } // 茶水間：對應嗰部機真係郁
    if (o.trap) { n.fear = Math.max(0, n.fear - 20); n.combo = 0; Sc.bubble(n, Lx(o.say), 2.6); Sc.float(n.x, n.y - 0.34, `反效果：${o.why}`, '#ff9a8a', 2); return; }
    if (o.warm) { n.fear = Math.max(0, n.fear - 10); Sc.bubble(n, Lx(o.say), 2.8); Sc.addKarma(n.d, 1, `${n.d.name}：${o.why}`); Sc.float(n.x, n.y - 0.34, '陰德 +1', '#a8f0b0', 2); return; }
    const personal = !!o.need;
    Sc._src = null; Sc._dl = 0; Sc._vis = false; // 隔空出手：冇人望到阿福
    Sc.hit(n, o.type, Math.round(o.base * (personal ? 1.4 : 1)), o.tier, null, true);
    if (personal && !Sc.headless) Sc.float(n.x, n.y - 0.38, '用上情報：正中要害', '#ffd84a', 1.8);
    if (o.say && !n.d.immune.includes(o.type)) { const say = () => { if (Sc.active && !n.gone) { n.bubT = 0; Sc.bubble(n, Lx(o.say), 2.8); } }; say(); if (!Sc.headless) setTimeout(say, 1100); } // 引擎嘅反應會遲一啲出，之後再蓋返針對呢招嘅對白
  }

  // ---------- 接駁 ----------
  function init() {
    const ort = Scare.renderTarget;
    Scare.renderTarget = function () {
      const r = ort.apply(this, arguments);
      try {
        const n = this.sel && !this.sel.gone && !this.sel.fleeing ? this.sel : null; if (!n) return r;
        const who = $('#sc-target .sc-who'); if (!who) return r;
        who.querySelectorAll('#sc-peek,#sc-wa').forEach(b => b.remove()); // 舊嘅偷看／傳訊息由新手機取代
        const box = document.createElement('span'); box.className = 'so-btns'; box.innerHTML = buttons(this, n); who.insertBefore(box, who.querySelector('#sc-br'));
        box.querySelectorAll('[data-op]').forEach(b => b.onclick = () => { const k = b.dataset.op; if (k === 'phone') openPhone(this, n); else if (k === 'pc') openPC(this, n); else openPantry(this, n); });
        this._opCtx = JSON.stringify(ctx(this, n));
      } catch (e) { console.error(e); }
      return r;
    };
    // 佢行開／坐低時，按鈕跟住變
    const ohud = Scare.hud;
    Scare.hud = function () { const r = ohud.apply(this, arguments); try { const n = this.sel; if (n && !n.gone && !this.paused && JSON.stringify(ctx(this, n)) !== this._opCtx) this.renderTarget(); } catch (e) {} return r; };
  }
  (function boot() { if (typeof Scare === 'undefined' || !Scare.renderTarget) { setTimeout(boot, 200); return; } try { init(); } catch (e) { console.error(e); } })();
  return { OPS, PANTRY, ctx, openPhone, openPC, openPantry, compose, act, intel };
})();
