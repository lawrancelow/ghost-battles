// ===================== 回陽間・舊公司二十三樓：空辦公室背景＋會動的家具＋阿Ken 的工位 =====================
// 背景（office_empty）只有地毯、窗、天花板、牆上冷氣、電梯門；家具和小東西全部是原圖切出來的件，
// 跟人用「同一把尺」：同一個深度 y，一個阿Ken 站著有多高（U），家具就照 U 的倍數畫 —— 人和家具永遠成比例。
// 只管畫面，不碰分數：scare.js 的位置、路線、恐懼、KPI 都不在這裡改。
// 原圖：of_*（家具）、op_*（小東西）、npc_ken_sit*（阿Ken 坐著的四張）。
// of_desk_clean = of_desk 拿掉內建螢幕和杯子（之後用 op_mon_* / op_mug 單獨畫才能動）；op_clockface = op_clock 擦掉指針。
// 汗、熱氣、氣泡、風、亮光、指針、鍵盤亮點 = 程式畫的蠟筆小特效。
// 小晴（npc_it）站著的網格骨架（左手拿筆電、右手拿珍奶、馬尾）：給 scare.js 的走路／嚇到／發抖等通用動作用
if (typeof MeshAnim !== 'undefined' && !MeshAnim.RIG.npc_it) MeshAnim.RIG.npc_it = { legs:true, bones:[
  ['hips', null, 0.52, 0.70, 0.52, 0.52, 0.22], ['legF', 'hips', 0.43, 0.72, 0.42, 0.98, 0.10], ['legB', 'hips', 0.62, 0.72, 0.62, 0.98, 0.10],
  ['body', 'hips', 0.52, 0.65, 0.52, 0.37, 0.26], ['head', 'body', 0.52, 0.37, 0.50, 0.03, 0.30], ['hairR', 'head', 0.80, 0.18, 0.92, 0.48, 0.12],
  ['armF', 'body', 0.33, 0.44, 0.20, 0.52, 0.13], ['armB', 'body', 0.70, 0.44, 0.74, 0.52, 0.11]] };
// 美美（npc_mis，陳總的「心腹」秘書）：站著（看指甲）、走路（貓步、手袋）、自拍的網格骨架；三張原圖都面朝左
if (typeof MeshAnim !== 'undefined') {
  if (!MeshAnim.RIG.npc_mis) MeshAnim.RIG.npc_mis = { legs:true, bones:[
    ['hips', null, 0.45, 0.62, 0.45, 0.48, 0.22], ['legF', 'hips', 0.36, 0.66, 0.34, 0.98, 0.10], ['legB', 'hips', 0.50, 0.66, 0.52, 0.98, 0.10],
    ['body', 'hips', 0.45, 0.58, 0.45, 0.32, 0.25], ['head', 'body', 0.45, 0.32, 0.40, 0.03, 0.30], ['hairR', 'head', 0.72, 0.20, 0.86, 0.52, 0.13],
    ['armF', 'body', 0.30, 0.38, 0.12, 0.22, 0.12], ['armB', 'body', 0.62, 0.40, 0.70, 0.50, 0.10]] };
  if (!MeshAnim.RIG.npc_mis_walk) MeshAnim.RIG.npc_mis_walk = { legs:true, bones:[
    ['hips', null, 0.48, 0.62, 0.48, 0.48, 0.22], ['legF', 'hips', 0.40, 0.66, 0.14, 0.94, 0.11], ['legB', 'hips', 0.56, 0.66, 0.62, 0.95, 0.10],
    ['body', 'hips', 0.48, 0.58, 0.45, 0.30, 0.25], ['head', 'body', 0.45, 0.30, 0.42, 0.03, 0.30], ['hairR', 'head', 0.75, 0.20, 0.86, 0.55, 0.14],
    ['armF', 'body', 0.33, 0.40, 0.15, 0.45, 0.10], ['armB', 'body', 0.70, 0.42, 0.85, 0.62, 0.15]] };
  if (!MeshAnim.RIG.npc_mis_selfie) MeshAnim.RIG.npc_mis_selfie = { legs:true, bones:[
    ['hips', null, 0.48, 0.62, 0.48, 0.48, 0.22], ['legF', 'hips', 0.40, 0.66, 0.38, 0.98, 0.10], ['legB', 'hips', 0.55, 0.66, 0.56, 0.98, 0.10],
    ['body', 'hips', 0.48, 0.58, 0.48, 0.32, 0.25], ['head', 'body', 0.50, 0.32, 0.48, 0.03, 0.30], ['hairR', 'head', 0.76, 0.20, 0.88, 0.52, 0.13],
    ['armF', 'body', 0.30, 0.40, 0.12, 0.18, 0.11], ['armB', 'body', 0.68, 0.42, 0.72, 0.25, 0.10]] };
}
const OFFICE = (() => {
  const PI = Math.PI;
  const cl = (v, a = 0, b = 1) => v < a ? a : v > b ? b : v, lerp = (a, b, k) => a + (b - a) * k;
  const ss = (t) => { t = cl(t); return t * t * (3 - 2 * t); };
  const bump = (t, a, m, b) => t <= a || t >= b ? 0 : t < m ? ss((t - a) / (m - a)) : 1 - ss((t - m) / (b - m));
  const rnd = (s) => { const x = Math.sin(s * 127.1 + 311.7) * 43758.5453; return x - Math.floor(x); };
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const KEN_H = 64 / (64 * 1.08);   // npc_ken 原圖畫出來的高度 = 0.926 × hh（art.js CHAR_H 64 ÷ scare.js NPC_UNIT）
  const SIT_H = 0.876;              // 坐著那張（npc_ken_sit，598px）有多高：頭和站著的一樣大時 = 0.876 個站著的阿Ken
  let SC = null;                    // Scare
  const U = (y) => SC.hh(y) * KEN_H;                // 這個深度，一個阿Ken 站著幾 px
  const UW = (y) => SC.hhF(y) * KEN_H * SC.bgAR();  // 同上，換成背景寬度的比例
  const P = (x, y) => SC.pt(x, y);

  // ---------- 夜色：家具先壓一層跟背景一樣的夜（快取，不用每幀算濾鏡）----------
  const TC = {};
  function img(k, dark) {
    if (!ok(k)) return null; const key = k + (dark || '');
    if (TC[key]) return TC[key];
    const im = SPR[k], c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight;
    const x = c.getContext('2d'); x.drawImage(im, 0, 0); x.globalCompositeOperation = 'source-atop';
    x.fillStyle = dark === 'off' ? 'rgba(14,10,30,.62)' : 'rgba(26,18,58,.30)'; x.fillRect(0, 0, c.width, c.height);
    return TC[key] = c;
  }
  // 背景：原圖偏亮 → 乘一層夜色，窗外的燈保留亮度（快取）
  let BGC = null;
  function bgCanvas() {
    if (BGC) return BGC; if (!ok('bg_office_empty')) return null;
    const im = SPR.bg_office_empty, c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight;
    const x = c.getContext('2d'); x.drawImage(im, 0, 0);
    x.globalCompositeOperation = 'multiply'; x.fillStyle = 'rgb(150,140,196)'; x.fillRect(0, 0, c.width, c.height);
    // 地板越前面越暗（燈在天花板後面）
    const g = x.createLinearGradient(0, c.height * 0.45, 0, c.height); g.addColorStop(0, 'rgb(255,255,255)'); g.addColorStop(1, 'rgb(150,145,180)');
    x.fillStyle = g; x.fillRect(0, c.height * 0.45, c.width, c.height * 0.55);
    // 窗外的城市燈：從原圖疊回一點亮度
    x.globalCompositeOperation = 'screen'; x.globalAlpha = 0.35;
    const wx = c.width * 0.105, wy = c.height * 0.235, ww = c.width * 0.675, wh = c.height * 0.22;
    x.drawImage(im, wx, wy, ww, wh, wx, wy, ww, wh);
    return BGC = c;
  }

  // ---------- 佈景 ----------
  // x,y = 落地點（背景比例；畫面最前面那隻腳），h = 整張圖高幾個阿Ken，ax/ay = 落地點在圖上的位置
  // 子物件（on）：u,v = 底部中點在父圖上的位置（0~1），h 一樣用阿Ken 當單位
  // ---------- 工位（坐著的人）：阿Ken、小晴 —— 同一套：椅子→人→桌子→手→螢幕；坐著的平日動作；嚇到跳起來、椅子滑走 ----------
  // seat = 路線上 'work' 那一點（scare.js）；koff = 畫面上往右挪多少（路線點不動 = 分數不變；走開時跟著距離收掉）
  // hand = 打字的手在屁股左邊幾個阿Ken、離地多高；arms = 手和前臂那一段（原圖比例 [x, y, 寬, 高]），打字時疊在桌子上面
  // SIT = 每張坐姿：屁股最後面（靠椅背那一點）x、腳底 y
  const STATIONS = {
    ken:{ k:'ken', seat:{ x:OFFMAP.M(0.24), y:OFFMAP.MY(0.60) }, koff:0.065, desk:'kdesk', mon:'kmon', mug:'kmug', base:'npc_ken_sit', stretch:'npc_ken_sit_stretch', drink:'npc_ken_sit_coffee', jump:'npc_ken_sit_jump',
      hand:[0.39, 0.315], arms:[-0.05, 0.50, 0.67, 0.185], face:[0.30, 0.28], drinkSay:null, stretchSay:'哈～',
      acts:[['type', 5, [4, 8], 0], ['stretch', 1.2, [3.2, 3.2], 11], ['drink', 1.3, [3.8, 3.8], 12], ['roll', 1.0, [3, 3], 7], ['spin', 0.6, [2.6, 2.6], 14]],
      bones:[['thigh', null, 0.92, 0.74, 0.22, 0.70, 0.13], ['shin', null, 0.30, 0.72, 0.30, 0.99, 0.14], ['body', null, 0.85, 0.72, 0.68, 0.42, 0.20], ['head', 'body', 0.64, 0.40, 0.52, 0.06, 0.32], ['armF', 'body', 0.62, 0.55, 0.10, 0.63, 0.085]] },
    it:{ k:'it', seat:{ x:OFFMAP.M(0.66), y:0.80 }, koff:0, desk:'idesk', mon:'imon', mug:null, base:'npc_it_sit', stretch:null, drink:'npc_it_sit_tea', jump:'npc_it_sit_jump',
      hand:[0.385, 0.37], arms:[-0.03, 0.47, 0.62, 0.16], face:[0.32, 0.30], drinkSay:'啜——', stretchSay:null,
      acts:[['type', 5, [4, 8], 0], ['drink', 1.4, [3.8, 3.8], 11], ['neck', 1.1, [3.0, 3.0], 9], ['vibe', 1.2, [3.5, 5], 8], ['roll', 0.8, [3, 3], 8], ['spin', 0.5, [2.6, 2.6], 14]],
      bones:[['thigh', null, 0.80, 0.70, 0.20, 0.70, 0.13], ['shin', null, 0.25, 0.72, 0.22, 0.99, 0.14], ['body', null, 0.72, 0.68, 0.55, 0.45, 0.22], ['hair', 'body', 0.62, 0.30, 0.86, 0.55, 0.16], ['head', 'body', 0.48, 0.44, 0.42, 0.06, 0.34], ['armF', 'body', 0.52, 0.48, 0.06, 0.56, 0.09]] },
  };
  STATIONS.ken.SEATV = { x:STATIONS.ken.seat.x + STATIONS.ken.koff, y:STATIONS.ken.seat.y }; STATIONS.it.SEATV = { x:STATIONS.it.seat.x + STATIONS.it.koff, y:STATIONS.it.seat.y };
  // 目前在處理哪一個工位（use 切換）：下面的程式照原本的寫法用 K / SEAT / SEATV / STN
  let STN = STATIONS.ken, SEAT = STN.seat, SEATV = STN.SEATV, K = null;
  function use(s) { STN = s; SEAT = s.seat; SEATV = s.SEATV; K = s.K; return s; }
  const stnOf = (n) => n && n.d && STATIONS[n.d.k] || null;
  const kenOff = (n) => { const s = stnOf(n); return s ? s.koff * Math.max(0, 1 - Math.hypot(n.x - s.seat.x, n.y - s.seat.y) / 0.07) : 0; };
  const eachStn = (fn) => { const keep = STN; for (const k in STATIONS) if (STATIONS[k].K) { use(STATIONS[k]); fn(STATIONS[k]); } use(keep); };
  const DEF = [
    { id:'cabinet', spr:'of_cabinet', x:0.135, y:0.505, h:0.70, shadow:0.62,
      kids:[{ id:'binder1', spr:'op_binder', u:0.30, v:0.055, h:0.19, fall:1 }, { id:'binder2', spr:'op_binder', u:0.47, v:0.05, h:0.19, fall:1, flip:1 }, { id:'stack', spr:'op_stack', u:0.74, v:0.07, h:0.13, fall:1 }] },
    // 小晴的桌子（同一套背面的桌子）：檯燈、仙人掌、文件、背對我們的螢幕
    { id:'idesk', spr:'of_desk_back_empty', x:0, y:0, uy:0.515, z:0.515, h:0.90, ax:360 / 567, ay:52 / 435, shadow:1.25, shu:0.5, shv:0.9, floorV:0.966, stn:'it', back:1,
      kids:[{ id:'lamp', spr:'of_lamp', u:0.16, v:0.31, h:0.30, ax:0.78, lamp:1 } /* 檯燈：企喺枱面左後角（同螢幕底一樣高），唔好吊喺枱前面 */, { id:'icactus', spr:'op_cactus', u:0.86, v:0.30, h:0.11, fall:1 }, { id:'ipaper', spr:'op_paper', u:0.28, v:0.16, h:0.075, paper:1, rot:0.2 },
            { id:'imon', spr:'op_mon_back', u:0.45, v:0.33, h:0.50, ax:0.5, ay:0.96, mon:1, stn:'it', back:1 }] },
    { id:'achair', spr:'of_chair_back', x:0.45, y:0.59, h:0.66, shadow:0.5, chair:1 }, // 空的辦公椅（「辦公椅自己轉」）
    { id:'copier', spr:'of_copier', x:0.705, y:0.515, h:0.74, ay:0.97, shadow:0.9, copier:1 },
    { id:'water', spr:'of_water', x:0.83, y:0.51, h:0.80, ay:0.985, shadow:0.42, water:1 },
    { id:'fan', spr:'of_fan', x:0.03, y:0.56, wx:OFFMAP.npx(5180), wy:0.74, h:0.78, shadow:0.42, fan:1 },
    { id:'bin', spr:'op_bin', x:0.245, y:0.522, h:0.22, shadow:0.3 },
    // 前景：左下白板、右下盆栽（框住畫面，也讓前面的人有東西比大小）
    // 阿Ken 的桌子：位置由工位算（手放在鍵盤右半邊）
    // y 放在阿Ken 前面一點（桌子右邊的抽屜櫃比左腳後面），排前後時當作在他後面（z）
    // 阿Ken 的桌子（of_desk_back_empty，從桌子的左後方看）：桌子在他前面、擋住他的腿；鍵盤在桌子最遠那一邊，他的手放在上面；
    // 螢幕（op_mon_back）背對我們、對著他。錨點 = 鍵盤左半（他打字的手）；位置、大小、前後（z = 桌子最前面那隻腳）由工位算（layoutKen）
    { id:'kdesk', spr:'of_desk_back_empty', x:0, y:0, uy:0.60, z:0.60, h:0.90, ax:360 / 567, ay:52 / 435, shadow:1.25, shu:0.5, shv:0.9, floorV:0.966, stn:'ken', back:1,
      kids:[{ id:'kmug', spr:'op_mug_back', u:0.22, v:0.34, h:0.12, mug:1, fall:1 }, { id:'kpaper', spr:'op_paper', u:0.30, v:0.15, h:0.075, paper:1, rot:0.25 },
            { id:'kmon', spr:'op_mon_back', u:0.45, v:0.33, h:0.50, ax:0.5, ay:0.96, mon:1, stn:'ken', back:1 }] },
  ];
  // IT 公司：多啲工位（新全景 px，世界座標；glow = 螢幕亮緊、有人OT留低嘅位）
  const WS = [[5430, 0.715, 1], [5810, 0.715, 0], // 工程師區：沿窗一排（阿Ken、小晴右邊），前面留走道
    [8790, 0.715, 1], [9170, 0.715, 0], [9550, 0.715, 1], // 設計測試區：沿窗一排
    [10330, 0.885, 1]]; // 伺服器房：值班位喺機櫃前面
  WS.forEach(([px, y, on], i) => {
    DEF.push({ id:'wsch' + i, spr:'of_chair_front', wx:px / OFFMAP.PXU + (i % 2 ? -0.085 : 0.085), wy:y - 0.004, h:0.6, ay:0.98, shadow:0.45, flip:i % 2 }); // 椅子推開咗喺枱側（人走咗），睇得到
    DEF.push({ id:'ws' + i, spr:'of_desk_back_empty', wx:px / OFFMAP.PXU, wy:y, h:0.9, ay:0.97, shadow:1.1, glow:on,
      kids:[{ id:'wsm' + i, spr:'op_mon_back', u:0.47, v:0.33, h:0.5, ax:0.5, ay:0.96 }, { id:'wsk' + i, spr:'op_keyboard', u:0.5, v:0.2, h:0.06 }].concat(i % 3 === 1 ? [{ id:'wsg' + i, spr:'op_mug_back', u:0.2, v:0.34, h:0.12 }] : []) });
  });
  // 牆上的鐘（右牆窄牆，冷氣和電梯中間）、天花板燈管、冷氣、窗（背景比例）
  const CLOCK = { x:0.815, y:0.335, d:0.42, depth:0.48 };
  const TUBES = [[0.075, 0.042, 0.34, 0.034], [0.59, 0.042, 0.345, 0.038], [0.165, 0.148, 0.24, 0.022], [0.535, 0.148, 0.25, 0.022], [0.215, 0.204, 0.185, 0.012], [0.51, 0.204, 0.18, 0.012]];
  const AC = [0.815, 0.148, 0.16, 0.097], WIN = OFFMAP.WINMAIN;
  // 阿Ken 坐著的四張：屁股最後面（靠椅背那一點）的 x、腳底 y（原圖比例）
  const SIT = { npc_ken_sit:[0.982, 0.99, 598], npc_ken_sit_stretch:[0.603, 0.99, 606], npc_ken_sit_coffee:[0.87, 0.992, 621], npc_ken_sit_jump:[0.822, 0.992, 627],
    npc_it_sit:[0.80, 0.99, 598], npc_it_sit_tea:[0.71, 0.99, 606], npc_it_sit_jump:[0.64, 0.99, 618] };
  // 椅子（of_chair_front 左右翻：椅背在右、臉朝左前，跟阿Ken 一樣）：椅背前緣 0.64、座墊高 = 0.40 張圖
  const CHAIR = { spr:'of_chair_front', back:0.64, seat:0.40, h:0.60 };

  let this_mon = null, items = {}, list = [], kids = [], flying = [], floor = [], drops = [], st = null;
  function init(S) {
    SC = S; items = {}; list = []; kids = []; flying = []; floor = []; drops = [];
    for (const d of DEF) {
      const it = Object.assign({ ax:0.5, ay:1, dx:0, dy:0, rot:0, vr:0, sx:1, sy:1, ph:Math.random() * 6 }, d, { kids:[] });
      if (d.wx != null) { it.x = d.wx; it.y = d.wy; } // 新工位：直接用世界座標
      else if (!d.stn) { it.x = OFFMAP.M(d.x); it.y = OFFMAP.MY(d.y); } // 舊辦公室座標 → 全景世界座標（開放辦公區）
      if (d.water) { it.x = OFFMAP.npx(4050); } // 飲水機：大堂右邊吉位（唔再夾住前台同電梯）
      if (d.copier) { it.x = OFFMAP.SPOT.copier[0]; it.y = OFFMAP.SPOT.copier[1]; it.h = 0.62; } // 影印機：搬去洗手間／影印房，企喺後牆前面
      items[d.id] = it; list.push(it);
      for (const k of d.kids || []) { const c = Object.assign({ ax:0.5, ay:1, dx:0, dy:0, rot:k.rot || 0, base:k.rot || 0, vr:0, sx:1, sy:1, hide:0, ph:Math.random() * 6 }, k, { parent:it }); it.kids.push(c); items[k.id] = c; kids.push(c); }
    }
    st = { t:0, fan:{ osc:0, spin:0, boost:0 }, clock:{ spin:0, ang:0 }, lamp:{ flick:0, sway:0, vs:0 }, ac:{ blow:0 }, water:{ glug:0 }, copier:{ print:0, out:0 }, tubes:0, rustle:0, flutter:0, lights:null, dropQ:[], clockF:null, chairSpin:0, creak:0 };
    for (const k in STATIONS) { const s = use(STATIONS[k]); s.monSt = { seq:-1 }; s.offline = false; layoutKen(); resetKen(); }
    use(STATIONS.ken);
  }
  function layoutKen() { // 桌圖的錨點（鍵盤）＝ 他打字的手（屁股往左 0.36、離地 0.46 個阿Ken）；桌子最前面那隻腳 = 這個工位排前後的深度
    const d = items[STN.desk], pp = SC.persp(), uf = pp.c * (SEAT.y - pp.hz) * KEN_H;
    d.x = SEATV.x - STN.hand[0] * KEN_UW(SEAT.y); d.y = SEAT.y - STN.hand[1] * uf; // 打字的手的位置 = 桌圖的錨點（鍵盤）
    d.z = d.y + (d.floorV - d.ay) * d.h * uf; d.uy = SEAT.y;
  }
  const KEN_UW = (y) => (SC.persp().c * (y - SC.persp().hz)) * KEN_H * SC.bgAR();

  // ---------- 阿Ken ----------
  function resetKen() {
    K = STN.K = { mode:'sit', mt:0, act:'type', at:0, dur:6, cd:{}, w:1, pop:0, keys:[], ch:{ dx:0, dz:0, vx:0, vz:0, sw:0, vs:0, lean:0, occ:true }, kick:0, look:0 };
  }
  function pickAct() {
    const opts = STN.acts.filter(e => (K.cd[e[0]] || 0) <= 0 && e[0] !== K.act);
    let r = Math.random() * opts.reduce((s, e) => s + e[1], 0), e = opts[0];
    for (const o of opts) { r -= o[1]; if (r <= 0) { e = o; break; } }
    K.act = e[0]; K.at = 0; K.dur = e[2][0] + Math.random() * (e[2][1] - e[2][0]); K.cd[e[0]] = e[3] + K.dur;
    if (K.act !== 'type' || Math.random() < 0.5) K.pop = 0.18;
  }
  function atDesk(n) { return !n.fleeing && !n.gone && n.act === 'work' && Math.abs(n.x - SEAT.x) < 0.002 && Math.abs(n.y - SEAT.y) < 0.002; }
  function seated(n) { const s = stnOf(n); if (!s || !s.K) return false; const K = s.K; return (K.mode === 'sit' || K.mode === 'jump' || K.mode === 'rise' || K.mode === 'sitdown'); }
  // 每幀（只管畫面）：坐下、站起來、被嚇得跳起來、椅子滑走
  function kenTick(n, dt) {
    if (n.d && n.d.k === 'mis') { misTick(n, dt); return; }
    const s = stnOf(n); if (!s || !s.K) return; use(s); const rx = n.rx && n.rx.t >= 0 ? n.rx : null, ch = K.ch;
    const big = rx && (rx.k === 'startle' || rx.k === 'weakjump' || rx.k === 'burst');
    const calm = n.fear < 25 && (!rx || rx.k === 'numb' || rx.k === 'sip');
    K.mt += dt; K.pop = Math.max(0, K.pop - dt);
    for (const k in K.cd) K.cd[k] -= dt;
    switch (K.mode) {
      case 'sit':
        ch.occ = true;
        if (!atDesk(n)) { K.mode = 'rise'; K.mt = 0; ch.vx = 0.12; ch.vz = -0.03; break; } // 站起來：腿把椅子往右後推開
        if (big || n.fear >= 50) { // 嚇到跳起來：椅子往後滑、轉走
          K.mode = 'jump'; K.mt = 0; const s = rx && rx.src != null && rx.src > n.x ? -1 : 1;
          ch.vx = 0.16 * s + 0.1; ch.vz = -0.03 - Math.random() * 0.015; ch.vs = (Math.random() < 0.5 ? -1 : 1) * (6 + Math.random() * 4); K.kick = 1;
          if (STN.mug) spill(items[STN.mug], 0.8); onScare(SEATV.x - 0.06, SEAT.y, 0.7); break;
        }
        K.at += dt; if (K.at >= K.dur) pickAct();
        break;
      case 'jump': ch.occ = false; if (K.mt > 0.62) { K.mode = 'up'; K.mt = 0; } break;
      case 'rise': ch.occ = true; if (K.mt > 0.34) { K.mode = 'up'; K.mt = 0; ch.occ = false; } break;
      case 'up':
        ch.occ = false;
        if (atDesk(n) && calm && K.mt > 0.6) { K.mode = 'pull'; K.mt = 0; K.p0 = { dx:ch.dx, dz:ch.dz, sw:ch.sw }; ch.vx = ch.vz = ch.vs = 0; }
        break;
      case 'pull': { // 站在桌邊，把椅子拉回來
        ch.occ = false; const k = ss(K.mt / 0.7);
        if (!atDesk(n) || !calm) { K.mode = 'up'; K.mt = 0; break; }
        ch.dx = lerp(K.p0.dx, 0, k); ch.dz = lerp(K.p0.dz, 0, k); ch.sw = lerp(K.p0.sw, Math.round(K.p0.sw / (2 * PI)) * 2 * PI, k);
        if (K.mt >= 0.7) { ch.sw = 0; K.mode = 'sitdown'; K.mt = 0; }
        break; }
      case 'sitdown': ch.occ = true; if (K.mt > 0.32) { K.mode = 'sit'; K.mt = 0; K.act = 'type'; K.at = 0; K.dur = 3 + Math.random() * 3; } break;
    }
    // 椅子：沒人坐 → 有慣性地滑、慢慢停；轉圈越轉越慢
    if (!ch.occ && K.mode !== 'jump') selfSpin(ch, SEATV.x + ch.dx, SEAT.y + ch.dz, dt);
    if (!ch.occ || K.mode === 'jump') {
      ch.dx += ch.vx * dt; ch.dz += ch.vz * dt; ch.sw += ch.vs * dt;
      const f = Math.exp(-dt * (st && st.chairSpin > 0 ? 0.6 : 2.0)); ch.vx *= f; ch.vz *= f; ch.vs *= Math.exp(-dt * (st && st.chairSpin > 0 ? 0.2 : 1.4));
      if (ch.dx > 0.13) { ch.dx = 0.13; ch.vx = -Math.abs(ch.vx) * 0.3; } if (ch.dx < -0.01) { ch.dx = -0.01; ch.vx = Math.abs(ch.vx) * 0.3; }
      if (ch.dz > 0.05) { ch.dz = 0.05; ch.vz = -Math.abs(ch.vz) * 0.3; } if (ch.dz < -0.035) { ch.dz = -0.035; ch.vz = 0; }
      if (Math.abs(ch.vs) < 0.6) { ch.sw = lerp(ch.sw, Math.round(ch.sw / (2 * PI)) * 2 * PI, 1 - Math.exp(-dt * 2)); ch.vs *= 0.9; } // 轉慢了停在正面
    }
    // 坐著：滑來滑去、轉一轉、伸懶腰往後靠
    let wantDx = 0, wantSw = 0, wantLean = 0;
    if (K.mode === 'sit') {
      const a = K.at, e = ss(a / 0.4) * ss((K.dur - a) / 0.4);
      if (n.fear >= 25 && !big) { wantSw = Math.sin(K.mt * 1.6) * 0.28; } // 起疑：轉來轉去看
      else if (K.act === 'roll') wantDx = Math.sin(a * 2.1) * 0.016 * e;
      else if (K.act === 'spin') wantSw = Math.sin(a * 2.4) * 0.55 * e;
      else if (K.act === 'stretch' || K.act === 'neck') wantLean = -0.12 * bump(a, 0.2, 0.6, 2.8);
      else if (K.act === 'drink' && STN.k === 'it') wantLean = -0.08 * bump(a, 0.4, 0.9, 3.4); // 喝珍奶：往後靠
      ch.dx = lerp(ch.dx, wantDx, 1 - Math.exp(-dt * 8)); ch.sw = lerp(ch.sw, wantSw, 1 - Math.exp(-dt * 6)); ch.dz = lerp(ch.dz, 0, 1 - Math.exp(-dt * 6));
    }
    ch.lean = lerp(ch.lean, wantLean, 1 - Math.exp(-dt * 7));
    // 打字的鍵盤亮點
    if (K.mode === 'sit' && K.act === 'type' && n.fear < 25 && Math.random() < dt * 14) { const a = (Math.random() - 0.5) * 2, b = (Math.random() - 0.5) * 2; K.keys.push({ u:(375 + a * 80 - b * 5) / 567, v:(47 + a * 25 + b * 15) / 435, life:0.18 }); }
    K.keys = K.keys.filter(k => (k.life -= dt) > 0);
  }

  // ---------- 每幀：家具 ----------
  function tick(dt) {
    if (!st) return; st.t += dt; const t = st.t;
    const f = st.fan; f.boost = Math.max(0, f.boost - dt * 0.18); f.osc += dt * (0.55 + f.boost * 1.6); f.spin += dt * (9 + f.boost * 28);
    st.clock.spin = Math.max(0, st.clock.spin - dt); st.clock.ang += dt * st.clock.spin * 14;
    const L = st.lamp; L.flick = Math.max(0, L.flick - dt); L.vs += (-L.sway * 60 - L.vs * 4) * dt; L.sway += L.vs * dt;
    st.ac.blow = Math.max(0, st.ac.blow - dt); st.water.glug = Math.max(0, st.water.glug - dt); st.rustle = Math.max(0, st.rustle - dt * 0.8); st.flutter = Math.max(0, st.flutter - dt * 0.7);
    // 東西掉地上：排好的順序一個一個掉
    st.dropQ = st.dropQ.filter(q => { q.at -= dt; if (q.at > 0) return true; if (q.clock) { if (!st.clockF) st.clockF = { t:0, z:0.15, vz:0, rot:0, b:0, rest:0 }; } else startFall(items[q.id], q.dir, 0.15); return false; });
    if (st.clockF) { const F = st.clockF; F.t += dt; if (F.t > 0.3) { F.vz -= 1.3 * dt; F.z += F.vz * dt; F.rot += dt * 3 * (F.z > 0 ? 1 : 0); }
      if (F.z <= 0) { F.z = 0; if (F.land == null) F.land = F.t; if (Math.abs(F.vz) > 0.08 && F.b < 1) { F.vz = -F.vz * 0.3; F.b++; } else { F.vz = 0; F.rest += dt; F.rot = lerp(F.rot, 1.35, 1 - Math.exp(-dt * 8)); } }
      if (F.rest > 11) { st.clockF = null; st.clockBack = 0.6; } }
    st.clockBack = Math.max(0, (st.clockBack || 0) - dt);
    if (st.lights) { st.lights.t += dt; if (st.lights.t > 3.6) st.lights = null; }
    st.chairSpin = Math.max(0, st.chairSpin - dt); st.creak = Math.max(0, st.creak - dt);
    const C = st.copier; C.print = Math.max(0, C.print - dt); C.idle = Math.max(0, (C.idle || 0) - dt); st.door = Math.max(0, (st.door || 0) - dt);
    if (C.print > 0.2) { C.out -= dt; if (C.out <= 0) { C.out = 0.12 + Math.random() * 0.1; copierPaper(); } }
    for (const k in STATIONS) { const m = STATIONS[k].monSt; if (m && m.seq >= 0) { m.seq += dt; if (m.seq > 1.7) m.seq = -1; } }
    if (Math.random() < dt * 0.25) st.tubes = 0.25; st.tubes = Math.max(0, st.tubes - dt);
    // 杯子、文件、文件夾、植物：彈簧晃回原位
    for (const c of kids.concat(list)) {
      if (c.vr || c.rot !== (c.base || 0)) { c.vr += (-(c.rot - (c.base || 0)) * (c.mug ? 90 : 40) - c.vr * (c.mug ? 5 : 3)) * dt; c.rot += c.vr * dt; if (Math.abs(c.vr) < 0.001 && Math.abs(c.rot - (c.base || 0)) < 0.001) { c.vr = 0; c.rot = c.base || 0; } }
      if (c.hide > 0) c.hide = Math.max(0, c.hide - dt);
      if (c.falling) fallTick(c, dt);
      if (c.chair && c.parent == null) chairTick(c, dt);
    }
    for (const p of flying) paperTick(p, dt); flying = flying.filter(p => !p.landed);
    floor = floor.filter(p => (p.life -= dt) > 0); drops = drops.filter(p => (p.life -= dt) > 0);
    for (const d of drops) if (!d.land) { d.vz -= 2.2 * dt; d.z += d.vz * dt; d.ox += d.vx * dt; if (d.z <= 0) { d.z = 0; d.land = true; } } // 咖啡滴：桌面上方拋一下落回桌面（單位：阿Ken）
  }
  // 椅子自己轉：一直轉、慢慢滑向最近的人（不碰分數，只是畫面）
  function nearestTo(x, y) { let b = null, bd = 9; for (const n of (SC.npcs || [])) { if (n.gone) continue; const d = Math.hypot(n.x - x, n.y - y); if (d < bd) { bd = d; b = n; } } return b; }
  function selfSpin(ch, x, y, dt, maxOz) {
    if (st.chairSpin <= 0) return;
    const k = Math.min(1, st.chairSpin / 0.6), n = nearestTo(x, y); ch.vs = (ch.vs >= 0 ? 1 : -1) * Math.max(Math.abs(ch.vs), 7 * k + 1);
    if (n) { const dx = n.x - x, dy = n.y - y, d = Math.hypot(dx, dy) || 1; if (d > 0.08) { ch.vx += dx / d * 0.09 * k * dt; ch.vz = (ch.vz || 0) + dy / d * 0.05 * k * dt; } }
  }
  function chairTick(c, dt) {
    c.vx = c.vx || 0; c.vs = c.vs || 0; c.sw = c.sw || 0; c.ox = c.ox || 0; c.oz = c.oz || 0; c.vz = c.vz || 0;
    selfSpin(c, c.x + c.ox, c.y + c.oz, dt);
    c.ox += c.vx * dt; c.vx *= Math.exp(-dt * (st.chairSpin > 0 ? 0.6 : 2.2)); c.sw += c.vs * dt; c.vs *= Math.exp(-dt * (st.chairSpin > 0 ? 0.2 : 1.5));
    c.oz += c.vz * dt; c.vz *= Math.exp(-dt * 1.2); c.oz = cl(c.oz, -0.01, 0.1); c.ox = cl(c.ox, -0.12, 0.2);
    if (st.chairSpin <= 0) { c.ox += -c.ox * dt * 0.25; c.oz += -c.oz * dt * 0.25; } // 慢慢滑回桌子前面
    if (Math.abs(c.vs) < 0.6) c.sw = lerp(c.sw, Math.round(c.sw / (2 * PI)) * 2 * PI, 1 - Math.exp(-dt * 2));
  }
  // 東西掉下去：先晃一下（倒），離開桌面／櫃頂，翻著掉到地上，彈一下，躺著；過一陣子放回去（淡入）
  // z = 離地幾個阿Ken；x = 往旁邊飛了幾個阿Ken
  function startFall(c, dir, kick) {
    if (!c || c.falling || c.hide > 0) return; const p = c.parent, fv = p.floorV != null ? p.floorV : p.ay;
    c.falling = { t:0, z:Math.max(0.05, (fv - c.v) * p.h), vz:0.25 + (kick || 0), vx:dir * (0.18 + Math.random() * 0.15), x:0, dir, b:0, tip:c.spr === 'op_binder' ? 0.25 : 0.12, off:false, land:-1 };
  }
  function fallTick(c, dt) {
    const F = c.falling; F.t += dt;
    if (F.t < F.tip) { c.rot = c.base + F.dir * ss(F.t / F.tip) * 0.5; return; }
    F.off = true; F.vz -= 6 * dt; F.z += F.vz * dt; F.x += F.vx * dt; c.rot += F.dir * 7 * dt * (F.z > 0 ? 1 : 0);
    if (F.z <= 0) { F.z = 0; if (F.land < 0) F.land = F.t; if (Math.abs(F.vz) > 0.5 && F.b < 1) { F.vz = -F.vz * 0.3; F.b++; } else { F.vz = 0; F.vx *= Math.exp(-dt * 8); F.rest = (F.rest || 0) + dt; c.rot = lerp(c.rot, F.dir * (c.mug ? PI / 2 : c.spr === 'op_stack' ? 0.15 : PI / 2), 1 - Math.exp(-dt * 10)); } }
    if (F.rest > 11) { c.falling = null; c.rot = c.base; c.hide = 0.6; }
  }
  function paperTick(p, dt) { // 紙：往上一彈、飄、左右擺、慢慢落地，落地變平躺
    p.t += dt; p.vz -= 1.1 * dt; p.vz = Math.max(p.vz, -0.25); p.z += p.vz * dt;
    p.x += (p.vx + Math.sin(p.t * 4 + p.ph) * 0.05) * dt; p.y += p.vy * dt; p.vx *= Math.exp(-dt * 0.8);
    p.rot += p.vr * dt; p.vr *= Math.exp(-dt * 0.6);
    if (p.z <= 0) { p.landed = true; floor.push({ x:p.x, y:p.y, rot:p.rot * 0.3, life:14, max:14, w:p.w * 1.3 }); }
  }
  function copierPaper() { // 影印機自己印：從左邊出紙口噴出來
    const c = items.copier, [x0] = [c.x - 0.33 * 0.74 * UW(c.y)];
    flying.push({ x:x0, y:c.y + 0.004, z:0.42, vx:-0.05 - Math.random() * 0.1, vy:0.02 + Math.random() * 0.05, vz:0.25 + Math.random() * 0.3, rot:Math.random() * 6, vr:(Math.random() - 0.5) * 9, t:0, ph:Math.random() * 6, w:0.16 });
  }
  function paperFly(c, pow) { // 桌上的紙被吹走
    if (c.hide > 0 || c.flown > 0) return;
    const p = c.parent, [x, y] = [p.x + (c.u - p.ax) * p.h * UW(p.y) * img(p.spr).width / img(p.spr).height, p.y];
    flying.push({ x, y:y + 0.004, z:0.47, vx:(Math.random() - 0.5) * 0.25 * pow, vy:0.03 + Math.random() * 0.04, vz:0.3 + Math.random() * 0.4 * pow, rot:c.rot, vr:(Math.random() - 0.5) * 12, t:0, ph:Math.random() * 6, w:0.15 });
    c.hide = 16;
  }
  function spill(m, pow) { // 杯子晃；晃太大就潑出來
    if (!m || m.hide > 0) return; m.vr += (Math.random() < 0.5 ? -1 : 1) * (4 + pow * 8);
    if (pow < 0.7) return;
    const p = m.parent;
    for (let i = 0; i < 7; i++) drops.push({ u:m.u, v:m.v, ox:0, z:0.06, vx:(Math.random() - 0.5) * 0.25, vz:0.25 + Math.random() * 0.3, life:2.5, desk:p });
    m.puddle = 6;
  }

  // ---------- 有人嚇人：附近的東西跟著動 ----------
  // x,y = 動靜的位置（背景比例），pow 0~1
  function onScare(x, y, pow) {
    if (!st) return; pow = cl(pow, 0, 1.2);
    const near = (it, r) => Math.hypot(it.x - x, (it.y - y) * 1.6) < r;
    st.fan.boost = Math.min(1.5, st.fan.boost + pow * 0.8); st.clock.spin = Math.max(st.clock.spin, 1.2 + pow); st.flutter = Math.max(st.flutter, pow);
    for (const c of kids) {
      const p = c.parent; if (!near(p, 0.42)) continue;
      if (c.paper) { if (pow > 0.55) paperFly(c, pow); else c.vr += (Math.random() - 0.5) * 6 * pow; }
      if (c.mug) spill(c, pow);
      if (c.mon && pow > 0.3 && c.stn) STATIONS[c.stn].monSt.seq = 0;
      if (c.fall && pow > 0.5 && !c.falling && (c.id === 'binder1' || c.id === 'binder2') && Math.random() < 0.8) startFall(c, c.id === 'binder1' ? -1 : 1);
      if (c.lamp) st.lamp.vs += (Math.random() - 0.5) * 3 * pow;
    }
    const a = items.achair; if (near(a, 0.5)) { a.vx = (a.vx || 0) + Math.sign(a.x - x || 1) * 0.1 * pow; a.vs = (a.vs || 0) + (Math.random() - 0.5) * 9 * pow; }
    eachStn(() => { if (!K.ch.occ) { K.ch.vx += Math.sign(SEATV.x + K.ch.dx - x || 1) * 0.08 * pow; K.ch.vs += (Math.random() - 0.5) * 8 * pow; } });
    if (items.plant && near(items.plant, 0.5)) st.rustle = Math.max(st.rustle, pow);
    if (near(items.water, 0.4)) items.water.vr += (Math.random() - 0.5) * 2 * pow;
  }
  // 附身家具（scare.js useProp）
  function onProp(k) {
    if (!st) return;
    if (k === 'lamp') { st.lamp.flick = 2.2; st.lamp.vs += 3.5; st.tubes = 2.2; onScare(items.idesk.x, items.idesk.y, 0.35); }
    if (k === 'ac') { st.ac.blow = 2.6; for (const c of kids) if (c.paper) c.vr += (Math.random() - 0.5) * 5; st.flutter = 1.2; st.rustle = 1.2; }
    if (k === 'water') { st.water.glug = 2.4; items.water.vr += 1.6; }
    if (k === 'printer') { st.copier.print = 2.2; st.copier.out = 0; onScare(items.copier.x, items.copier.y, 0.6); }
    if (k === 'lights') { st.lights = { t:0 }; st.tubes = 0; } // 玩電燈：整層閃 → 一段一段熄 → 全黑 → 啪一聲全亮
    if (k === 'drop') { // 東西掉地上：文件夾、一疊紙、杯子、仙人掌、牆上的鐘，一個接一個
      const kk = STATIONS.ken.K, cofe = kk && kk.mode === 'sit' && kk.act === 'drink';
      st.dropQ = [['binder1', -1, 0], ['binder2', 1, 0.22], ['stack', 1, 0.45], ['kmug', -1, 0.75], ['icactus', 1, 1.0]].filter(e => !(e[0] === 'kmug' && cofe)).map(e => ({ id:e[0], dir:e[1], at:e[2] }));
      onScare(items.cabinet.x, items.cabinet.y, 0.3);
    }
    if (k === 'chair') { st.chairSpin = 2.8; st.creak = 2.8; const a = items.achair; a.vs = (a.vs || 0) + 6; eachStn(() => { if (!K.ch.occ) K.ch.vs += 6; }); }
  }
  // 玩電燈：黑幕一段一段蓋上來（人還看得到一點），亮著的螢幕、檯燈在黑裡發光；最後一下全亮（閃白）
  function lightsDark(t) {
    const L = st && st.lights; if (!L) return [0, 0, 0];
    const q = L.t, fl = Math.sin(q * 37) + Math.sin(q * 23) > 0.6 ? 0.55 : 0.08;
    if (q < 0.9) return [fl, fl, fl];
    if (q < 2.7) return [0, 1, 2].map(i => { const t0 = 0.9 + i * 0.3; return q < t0 ? fl : Math.min(0.74, 0.2 + (q - t0) * 3); });
    return [0, 0, 0];
  }
  function kidPos(c) { const p = c.parent, F = frameOf(p), sg = p.flip ? -1 : 1; return [F.x + sg * (c.u - p.ax) * F.w, F.y + (c.v - p.ay) * F.h, F.u]; }
  function drawDark(ctx, t) {
    if (!st) return; const W = SC.W, H = SC.H, D = lightsDark(t), L = st.lights;
    if (D.some(v => v > 0)) {
      ctx.save();
      for (let i = 0; i < 3; i++) if (D[i] > 0) { ctx.fillStyle = `rgba(4,3,14,${D[i]})`; ctx.fillRect(W * i / 3 - 1, 0, W / 3 + 2, H); }
      ctx.globalCompositeOperation = 'lighter';
      const glow = (c, col, r) => { const [x, y, u] = kidPos(c), R = u * r, g = ctx.createRadialGradient(x, y - u * 0.25, 0, x, y - u * 0.25, R); g.addColorStop(0, col); g.addColorStop(1, 'rgba(0,0,0,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y - u * 0.25, R, 0, PI * 2); ctx.fill(); };
      const dk = Math.max(...D);
      for (const k in STATIONS) { const m = items[STATIONS[k].mon]; if (m && monState(m) === 'on') glow(m, `rgba(110,180,255,${0.5 * dk})`, 0.7); }
      glow(items.lamp, `rgba(255,190,100,${0.45 * dk})`, 0.6);
      ctx.restore();
    }
    if (L && L.t >= 2.7 && L.t < 3.1) { ctx.fillStyle = `rgba(255,250,230,${0.35 * (1 - (L.t - 2.7) / 0.4)})`; ctx.fillRect(0, 0, W, H); }
    if (L && L.t > 0.95 && L.t < 2.6) text(ctx, W * (0.15 + 0.35 * Math.min(2, Math.floor((L.t - 0.9) / 0.3))), H * 0.12, '啪', H * 0.035, 1 - ((L.t - 0.9) % 0.3) / 0.3);
    if (st.creak > 0) { // 椅子：吱——
      const a = items.achair, [x, y] = P(a.x + (a.ox || 0), a.y + (a.oz || 0)), u = U(a.y), k = Math.min(1, st.creak) * (0.6 + 0.4 * Math.sin(t * 9));
      text(ctx, x + Math.sin(t * 13) * 2, y - u * 0.78, '吱——', u * 0.14, k);
      eachStn(() => { if (!K.ch.occ) { const [kx, ky] = P(SEATV.x + K.ch.dx, SEAT.y + K.ch.dz); text(ctx, kx, ky - u * 0.8, '吱——', u * 0.14, k * 0.9); } });
    }
  }

  // ---------- 畫 ----------
  function shadowAt(ctx, x, y, w, a) { ctx.save(); ctx.fillStyle = `rgba(6,4,18,${a == null ? 0.38 : a})`; ctx.beginPath(); ctx.ellipse(x, y, w / 2, w * 0.13, 0, 0, PI * 2); ctx.fill(); ctx.restore(); }
  // 背景＋牆上、天花板上的東西（在人和家具後面）
  function drawBack(ctx, t) {
    OFFMAP.drawBack(ctx, t); // 全景（老闆房｜開放辦公區｜茶水間｜會議室）＋各房間後牆嘅道具
    if (!st) return;
    drawDoor(ctx, t);
  }
  // 電梯：有人進出 → 門往兩邊滑開（門縫裡是電梯的暖光）、「叮」、按鈕亮
  const EV = OFFMAP.ELEV, ELEV = { x0:EV.x0, x1:EV.x1, seam:EV.seam, top:[EV.top, EV.top], bot:[EV.bot, EV.bot] };
  function drawDoor(ctx, t) {
    const k0 = st.door || 0; if (k0 <= 0) return; const tt = 1.8 - k0, open = tt < 0.35 ? ss(tt / 0.35) : tt > 1.4 ? 1 - ss((tt - 1.4) / 0.4) : 1;
    const yt = (x) => ELEV.top[0] + (x - ELEV.x0) / (ELEV.x1 - ELEV.x0) * (ELEV.top[1] - ELEV.top[0]), yb = (x) => ELEV.bot[0] + (x - ELEV.x0) / (ELEV.x1 - ELEV.x0) * (ELEV.bot[1] - ELEV.bot[0]);
    const a = ELEV.seam - open * (ELEV.seam - ELEV.x0 - 0.004), b = ELEV.seam + open * (ELEV.x1 - ELEV.seam - 0.004);
    if (open > 0.01) { const Q = [P(a, yt(a)), P(b, yt(b)), P(b, yb(b)), P(a, yb(a))];
      ctx.save(); ctx.beginPath(); Q.forEach((p, i) => i ? ctx.lineTo(p[0], p[1]) : ctx.moveTo(p[0], p[1])); ctx.closePath();
      const g = ctx.createLinearGradient(0, Q[0][1], 0, Q[3][1]); g.addColorStop(0, 'rgba(255,236,180,.95)'); g.addColorStop(1, 'rgba(190,160,110,.95)'); ctx.fillStyle = g; ctx.fill();
      ctx.strokeStyle = 'rgba(40,30,30,.8)'; ctx.lineWidth = 1.5; ctx.stroke(); ctx.restore(); }
    const [bx, by] = P(EV.btn[0], EV.btn[1]); ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = `rgba(255,220,120,${0.6 * Math.min(1, k0)})`; ctx.beginPath(); ctx.arc(bx, by, 4, 0, PI * 2); ctx.fill(); ctx.restore();
    if (tt < 0.8) { const [dx, dy] = P(EV.seam, EV.top - 0.04); text(ctx, dx, dy - tt * 14, '叮！', U(0.65) * 0.16, 1 - tt / 0.8); }
  }
  function drawClock(ctx, t) {
    const im = img('op_clockface'); if (!im) return;
    const [x, y] = P(CLOCK.x, CLOCK.y), d = CLOCK.d * U(CLOCK.depth) * 0.6;
    const F = st.clockF; let y2 = y, rot = 0, sq = 1, al = st.clockBack > 0 ? 1 - st.clockBack / 0.6 : 1;
    if (F) { y2 = P(CLOCK.x, 0.485 - F.z)[1]; rot = F.rot; if (F.z <= 0 && F.rest > 0) sq = 1 - 0.45 * Math.min(1, F.rest * 4); } // 掉下來：沿著牆掉到地上，倒下來躺著
    if (F && F.land != null && F.t - F.land < 0.5) text(ctx, x - d * 0.8, y2 - d * 0.9, '哐啷！', d * 0.9, 1 - (F.t - F.land) / 0.5);
    const hrs = SC.t / 180 * 6, sec = Math.floor(SC.t * 2) % 60; // 牆上的鐘就是今晚的時間（00:00→06:00）
    const ha = hrs / 12 * 2 * PI + st.clock.ang * 0.08, ma = (hrs % 1) * 2 * PI + st.clock.ang, sa = sec / 60 * 2 * PI + st.clock.ang * 2.5;
    ctx.save(); ctx.globalAlpha *= al; ctx.translate(x, y2); if (F) { ctx.translate(0, d * 0.5); ctx.rotate(rot); ctx.scale(1, sq); ctx.translate(0, -d * 0.5); } ctx.scale(0.58, 1); // 右牆：側面看，壓扁
    ctx.drawImage(im, -d / 2, -d / 2, d, d);
    ctx.lineCap = 'round'; ctx.strokeStyle = 'rgba(52,32,26,.92)';
    const hand = (a, l, w) => { ctx.lineWidth = w; ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(Math.sin(a) * l, -Math.cos(a) * l); ctx.stroke(); };
    hand(ha, d * 0.2, Math.max(1.6, d * 0.07)); hand(ma, d * 0.3, Math.max(1.2, d * 0.05));
    ctx.strokeStyle = 'rgba(170,40,40,.8)'; hand(sa, d * 0.32, 0.8);
    ctx.fillStyle = '#3a221a'; ctx.beginPath(); ctx.arc(0, 0, Math.max(1.2, d * 0.04), 0, PI * 2); ctx.fill();
    ctx.restore();
  }
  function drawAC(ctx, t) {
    const [x1, y1] = P(AC[0], AC[1]), [x2, y2] = P(AC[0] + AC[2], AC[1] + AC[3]), w = x2 - x1, h = y2 - y1;
    const k = st.ac.blow; if (k <= 0) return;
    const e = Math.min(1, k * 2, (2.6 - k) * 4);
    ctx.save(); // 出風口的葉片一開一合
    ctx.strokeStyle = `rgba(40,40,60,${0.7 * e})`; ctx.lineWidth = 2; const fl = Math.sin(t * 18) * 0.5 + 0.5;
    ctx.beginPath(); ctx.moveTo(x1 + w * 0.12, y1 + h * 0.78); ctx.lineTo(x2 - w * 0.1, y1 + h * (0.78 + 0.12 * fl)); ctx.stroke();
    // 冷風：白色的弧線往左下吹
    ctx.lineCap = 'round';
    for (let i = 0; i < 7; i++) {
      const q = (t * 0.9 + i / 7) % 1, sx = x1 + w * (0.15 + 0.7 * rnd(i)), sy = y2 - 2;
      const ex = sx - q * w * 1.6 - 10, ey = sy + q * h * 3.4;
      ctx.strokeStyle = `rgba(210,235,255,${0.55 * e * (1 - q)})`; ctx.lineWidth = 2.2 * (1 - q * 0.5);
      ctx.beginPath(); ctx.moveTo(sx, sy); ctx.quadraticCurveTo(sx - 4 + Math.sin(t * 6 + i) * 6, (sy + ey) / 2, ex, ey); ctx.stroke();
    }
    ctx.restore();
  }
  // Pontianak 在窗外：畫在家具和人後面，只露在玻璃裡
  function clipWindow(ctx) { const W0 = OFFMAP.WINMAIN, [x1, y1] = P(W0[0], W0[1]), [x2, y2] = P(W0[0] + W0[2], W0[1] + W0[3]); ctx.beginPath(); ctx.rect(x1, y1, x2 - x1, y2 - y1); ctx.clip(); return [x1, y1, x2, y2]; }

  // 要跟人一起排前後的東西：[z, 畫的函式]
  function drawables(t) {
    const out = [];
    for (const it of list) {
      if (it.chair) { out.push([it.y + (it.oz || 0), (ctx) => drawFreeChair(ctx, it, t)]); continue; }
      if (it.stn && kenAtDesk(STATIONS[it.stn])) continue; // 有人坐著：桌子跟人一起畫（椅子→人→桌子→手→螢幕、杯子）
      out.push([it.z != null ? it.z : it.y, (ctx) => drawItem(ctx, it, t)]);
    }
    eachStn((s) => { if (!K.ch.occ) out.push([SEAT.y + K.ch.dz - 0.03, (ctx) => { const keep = STN; use(s); drawKenChair(ctx, null, t); use(keep); }]); });
    for (const c of kids) if (c.falling && c.falling.off) out.push([(c.parent.z != null ? c.parent.z : c.parent.y) + 0.006, (ctx) => drawFallen(ctx, c)]);
    for (const p of flying) out.push([p.y, (ctx) => drawFlying(ctx, p, t)]);
    return out;
  }
  // 地上躺著的紙、潑出來的咖啡（在所有人後面、地板上）
  function drawFloor(ctx, t) {
    const im = img('op_paper'); if (!im) return;
    for (const p of floor) { const [x, y] = P(p.x, p.y), u = U(p.y), w = p.w * u * 1.4, a = Math.min(1, p.life / 1.5);
      ctx.save(); ctx.globalAlpha = a; ctx.translate(x, y); ctx.scale(1, 0.55); ctx.rotate(p.rot); ctx.drawImage(im, -w / 2, -w * im.height / im.width / 2, w, w * im.height / im.width); ctx.restore(); }
  }
  function frameOf(it) { // 家具在畫面上的框（給子物件、點擊框用）
    const im = img(it.spr) || { width:1, height:1 }, u = U(it.uy != null ? it.uy : it.y), h = it.h * u, w = h * im.width / im.height, [x, y] = P(it.x, it.y);
    return { x, y, u, w, h, im };
  }
  function drawItem(ctx, it, t, mode) { // mode：不給 = 全部；'base' = 只畫家具本身；'kids' = 只畫上面的東西
    const F = frameOf(it); if (!img(it.spr)) return;
    let { x, y, u, w, h } = F, im = img(it.spr);
    if (it.shadow && mode !== 'kids') { if (it.shu != null) shadowAt(ctx, x + (it.shu - it.ax) * w, y + (it.shv - it.ay) * h, it.shadow * u); else shadowAt(ctx, x, y - h * 0.01, it.shadow * u); }
    ctx.save(); ctx.translate(x, y);
    if (it.water) { const g = st.water.glug; it.rot = (it.rot || 0) + (g > 0 ? Math.sin(t * 22) * 0.012 * Math.min(1, g) : 0); }
    if (it.copier && st.copier.print > 0) ctx.translate(Math.sin(t * 60) * u * 0.006, Math.sin(t * 47) * u * 0.004);
    if (it.rot) ctx.rotate(it.rot);
    if (it.flip) ctx.scale(-1, 1);
    if (it.fan) { drawFan(ctx, it, F, t); ctx.restore(); return; }
    if (it.plant) { const k = st.rustle * Math.sin(t * 11) * 0.05 + Math.sin(t * 0.9 + it.ph) * 0.006 + st.flutter * Math.sin(t * 7) * 0.02; ctx.transform(1, 0, k, 1, 0, 0); }
    const L = -it.ax * w, T = -it.ay * h;
    if (mode !== 'kids') ctx.drawImage(im, L, T, w, h);
    if (it.back && mode !== 'base') { this_mon = it.stn && items[STATIONS[it.stn].mon]; deskSpill(ctx, L, T, w, h, u, t); }
    // 子物件（桌上的東西、櫃頂的文件夾）
    if (mode !== 'base') for (const c of it.kids) drawKid(ctx, c, L, T, w, h, u, t);
    if (mode === 'base') { ctx.restore(); return; }
    // 特效
    if (it.copier) copierFx(ctx, L, T, w, h, u, t);
    if (it.water) waterFx(ctx, L, T, w, h, u, t);
    if (it.stn) deskFx(ctx, it, L, T, w, h, u, t);
    if (it.glow) { ctx.save(); ctx.globalCompositeOperation = 'lighter'; const gx = L + w * 0.47, gy = T + h * 0.05, r = w * 0.55, g = ctx.createRadialGradient(gx, gy, 0, gx, gy, r); g.addColorStop(0, `rgba(120,170,255,${0.22 + 0.03 * Math.sin(t * 2 + it.ph)})`); g.addColorStop(1, 'rgba(120,170,255,0)'); ctx.fillStyle = g; ctx.fillRect(gx - r, gy - r, r * 2, r * 2); ctx.restore(); } // 有人OT：螢幕光照住枱面
    ctx.restore();
  }
  const kenAtDesk = (s) => { const K = (s || STN).K; return !!K && (K.mode === 'sit' || K.mode === 'jump' || K.mode === 'rise' || K.mode === 'sitdown'); };
  // 螢幕現在怎樣：'on' 亮、'static' 雪花、'off' 黑
  function monState(c) { const m = c.stn && STATIONS[c.stn].monSt, q = m ? m.seq : -1; if (!m || STATIONS[c.stn].offline) return 'off'; if (q < 0) return 'on'; if (q < 0.55) return 'static'; if (q < 1.4) return 'off'; return Math.sin(q * 60) > 0 ? 'static' : 'on'; }
  function kidImg(c) {
    if (c.back) return c.spr;
    if (c.mon) { const m = c.ken ? st.mon : st.amon, q = m.seq, sd = c.side ? 'op_mon_side_' : 'op_mon_';
      const S0 = c.side ? 'op_mon_side_off' : 'op_mon_static'; // 側面螢幕沒有雪花圖：關著的那張＋程式畫雪花（monScreen）
      if (q >= 0) return q < 0.55 ? S0 : q < 1.4 ? sd + 'off' : (Math.sin(q * 60) > 0 ? S0 : (c.ken ? sd + 'on' : sd + 'off'));
      return c.ken ? sd + 'on' : sd + 'off'; }
    return c.spr;
  }
  function drawKid(ctx, c, L, T, w, h, u, t) {
    if (c.falling && c.falling.off) return;
    { const sK = c.parent.stn && STATIONS[c.parent.stn].K; if (c.mug && sK && sK.mode === 'sit' && sK.act === 'drink' && sK.at > 0.45 && sK.at < sK.dur - 0.4) return; } // 杯子在他手上
    const key = kidImg(c), im = img(key); if (!im) return;
    let a = c.hide > 0 ? (c.hide < 0.6 ? 1 - c.hide / 0.6 : 0) : 1; if (a <= 0) return;
    const ch = c.h * u, cw = c.mon && !c.side ? 0.47 * u : ch * im.width / im.height, chh = c.mon && !c.side ? cw * im.height / im.width : ch;
    let x = L + c.u * w, y = T + c.v * h;
    if (c.on) { const m = c.parent.kids.find(k => k.id === c.on); if (m) { x = L + m.u * w + (c.u - 0.5) * 0.47 * u; y = T + m.v * h - (1 - c.v) * 0.47 * u * 0.98; } }
    ctx.save(); ctx.globalAlpha *= a; ctx.translate(x, y);
    let r = c.rot; if (c.paper) r += Math.sin(t * 9 + c.ph) * 0.06 * st.flutter;
    if (c.lamp) r += st.lamp.sway;
    ctx.rotate(r); if (c.flip) ctx.scale(-1, 1);
    if (c.paper) { ctx.scale(1, 0.62 - 0.12 * st.flutter * (0.5 + 0.5 * Math.sin(t * 13 + c.ph))); } // 平放在桌上：壓扁；被風吹就掀起來
    const kay = c.ay == null ? 1 : c.ay;
    if (c.back && c.mon) monHalo(ctx, monState(c), -(c.ax == null ? 0.5 : c.ax) * cw, -kay * chh, cw, chh, u, t);
    ctx.drawImage(im, -(c.ax == null ? 0.5 : c.ax) * cw, -kay * chh, cw, chh);
    if (c.side) monScreen(ctx, c, key, -(c.ax == null ? 0.5 : c.ax) * cw, -kay * chh, cw, chh, t);
    if (c.lamp) lampFx(ctx, cw, chh, u, t);
    if (c.mon && !c.side && key === 'op_mon_on') { const g = 0.12 + 0.04 * Math.sin(t * 5) + (Math.sin(t * 0.7) > 0.9 ? 0.08 : 0); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = `rgba(120,190,255,${g})`; ctx.fillRect(-cw * 0.44, -chh * 0.95, cw * 0.88, chh * 0.68); }
    if (c.mon && key === 'op_mon_static') { ctx.globalCompositeOperation = 'lighter'; for (let i = 0; i < 5; i++) { ctx.fillStyle = `rgba(255,255,255,${0.15 * Math.random()})`; ctx.fillRect(-cw * 0.42, -chh * (0.92 - Math.random() * 0.62), cw * 0.84, 1.5); } }
    ctx.restore();
    if (c.mug && c.puddle > 0) { c.puddle -= 1 / 60; ctx.save(); ctx.fillStyle = `rgba(70,40,20,${0.55 * Math.min(1, c.puddle / 2)})`; ctx.beginPath(); ctx.ellipse(x + u * 0.06, y + u * 0.01, u * 0.07, u * 0.016, 0, 0, PI * 2); ctx.fill(); ctx.restore(); }
  }
  // 側面螢幕：螢幕是一個斜的四邊形（原圖比例），亮的時候加一層藍光，雪花 = 關著的圖上畫亂跳的白線（只畫在螢幕裡）
  const QUAD = { op_mon_side_on:[[0.245, 0.218], [0.887, 0.065], [0.887, 0.632], [0.245, 0.719]], op_mon_side_off:[[0.23, 0.226], [0.897, 0.086], [0.897, 0.645], [0.23, 0.742]] };
  function monScreen(ctx, c, key, L, T, w, h, t) {
    const Q = QUAD[key]; if (!Q) return; const m = c.ken ? st.mon : st.amon, q = m.seq, isStatic = q >= 0 && key === 'op_mon_side_off' && (q < 0.55 || (q >= 1.4 && Math.sin(q * 60) > 0));
    const on = key === 'op_mon_side_on'; if (!on && !isStatic) return;
    ctx.save(); ctx.beginPath(); Q.forEach((p, i) => { const x = L + p[0] * w, y = T + p[1] * h; i ? ctx.lineTo(x, y) : ctx.moveTo(x, y); }); ctx.closePath(); ctx.clip();
    ctx.globalCompositeOperation = 'lighter';
    if (on) { const g = 0.10 + 0.04 * Math.sin(t * 5) + (Math.sin(t * 0.7) > 0.9 ? 0.08 : 0); ctx.fillStyle = `rgba(120,190,255,${g})`; ctx.fillRect(L, T, w, h); }
    else { ctx.fillStyle = 'rgba(120,120,150,.25)'; ctx.fillRect(L, T, w, h);
      for (let i = 0; i < 14; i++) { const yy = T + h * (0.05 + Math.random() * 0.7), a = 0.25 + Math.random() * 0.5; ctx.fillStyle = `rgba(${200 + Math.random() * 55 | 0},${200 + Math.random() * 55 | 0},255,${a})`; ctx.fillRect(L + w * 0.2, yy, w * 0.75, Math.max(1, h * 0.012)); }
      for (let i = 0; i < 40; i++) { ctx.fillStyle = `rgba(255,255,255,${Math.random() * 0.6})`; ctx.fillRect(L + w * (0.22 + Math.random() * 0.68), T + h * (0.08 + Math.random() * 0.62), 1.5, 1.5); } }
    ctx.restore();
  }
  // 背對我們的螢幕：螢幕的光從四邊漏出來（亮 = 藍、雪花 = 白光亂閃、黑 = 沒有）
  function monLight(s, t) { if (s === 'on') return [120, 185, 255, 0.5 + 0.08 * Math.sin(t * 5) + (Math.sin(t * 0.7) > 0.9 ? 0.15 : 0)]; if (s === 'static') return [235, 240, 255, 0.35 + 0.5 * Math.random()]; return null; }
  function monHalo(ctx, s, L, T, w, h, u, t) {
    const c = monLight(s, t); if (!c) return; const cx = L + w * 0.5, cy = T + h * 0.36, R = Math.max(w, h * 0.75) * 0.8;
    ctx.save(); ctx.globalCompositeOperation = 'lighter';
    const g = ctx.createRadialGradient(cx, cy, R * 0.4, cx, cy, R); g.addColorStop(0, `rgba(${c[0]},${c[1]},${c[2]},${0.9 * c[3]})`); g.addColorStop(1, `rgba(${c[0]},${c[1]},${c[2]},0)`);
    ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(cx, cy, R, R * 0.85, 0, 0, PI * 2); ctx.fill(); ctx.restore();
  }
  function deskSpill(ctx, L, T, w, h, u, t) { // 螢幕的光打在桌面上（一點點）
    const m = this_mon, c = m && monLight(monState(m), t); if (!c) return; const x = L + m.u * w, y = T + m.v * h;
    ctx.save(); ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(x + u * 0.12, y - u * 0.02, 0, x + u * 0.12, y - u * 0.02, u * 0.32);
    g.addColorStop(0, `rgba(${c[0]},${c[1]},${c[2]},${0.22 * c[3]})`); g.addColorStop(1, `rgba(${c[0]},${c[1]},${c[2]},0)`); ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(x + u * 0.12, y - u * 0.02, u * 0.32, u * 0.12, -0.3, 0, PI * 2); ctx.fill(); ctx.restore();
  }
  function lampFx(ctx, w, h, u, t) { // 檯燈：燈泡的光（被附身時一閃一閃）
    const L = st.lamp, on = STATIONS.it.offline ? false : L.flick > 0 ? (Math.sin(t * 31) + Math.sin(t * 13) > 0.3) : true; // 小晴回家了：檯燈關掉
    const bx = (0.88 - 0.78) * w, by = -h * (1 - 0.40);
    ctx.save(); ctx.globalCompositeOperation = 'lighter';
    if (on) { const g = ctx.createRadialGradient(bx, by + h * 0.25, 0, bx, by + h * 0.25, u * 0.55); g.addColorStop(0, 'rgba(255,200,110,.38)'); g.addColorStop(1, 'rgba(255,200,110,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(bx, by + h * 0.25, u * 0.55, 0, PI * 2); ctx.fill(); }
    ctx.restore();
    if (!on) { ctx.save(); ctx.fillStyle = 'rgba(20,14,30,.75)'; ctx.beginPath(); ctx.ellipse(bx + w * 0.02, by + h * 0.02, w * 0.12, h * 0.07, -0.5, 0, PI * 2); ctx.fill(); ctx.restore(); }
  }
  function copierFx(ctx, L, T, w, h, u, t) {
    const k = Math.max(st.copier.print, st.copier.idle || 0); if (k <= 0) return; // idle = 美美在影印（不噴紙）
    const q = (t * 1.6) % 1, x = L + w * (0.42 + 0.3 * q), e = Math.min(1, k * 3);
    ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = `rgba(150,255,190,${0.55 * e})`; ctx.fillRect(x, T + h * 0.27, w * 0.03, h * 0.06);
    const g = ctx.createRadialGradient(L + w * 0.55, T + h * 0.3, 0, L + w * 0.55, T + h * 0.3, w * 0.5); g.addColorStop(0, `rgba(150,255,190,${0.25 * e})`); g.addColorStop(1, 'rgba(150,255,190,0)'); ctx.fillStyle = g; ctx.fillRect(L, T, w, h * 0.7);
    ctx.restore();
  }
  function waterFx(ctx, L, T, w, h, u, t) { // 飲水機：瓶子裡咕嚕咕嚕冒大泡
    const k = st.water.glug; if (k <= 0) return;
    ctx.save(); ctx.beginPath(); ctx.ellipse(L + w * 0.48, T + h * 0.21, w * 0.33, h * 0.17, 0, 0, PI * 2); ctx.clip();
    for (let i = 0; i < 9; i++) { const q = (t * (0.7 + rnd(i) * 0.6) + rnd(i + 9)) % 1, bx = L + w * (0.3 + 0.36 * rnd(i + 3)) + Math.sin(t * 5 + i) * w * 0.03, by = T + h * (0.37 - q * 0.3), r = w * (0.03 + 0.05 * rnd(i + 5)) * (0.6 + q * 0.6);
      ctx.strokeStyle = `rgba(225,245,255,${0.85 * Math.min(1, k)})`; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.arc(bx, by, r, 0, PI * 2); ctx.stroke(); }
    ctx.restore();
  }
  function deskFx(ctx, it, L, T, w, h, u, t) { // 打字：鍵盤一下一下亮
    const K = it.stn && STATIONS[it.stn].K; if (!K) return; ctx.save(); ctx.globalCompositeOperation = 'lighter';
    for (const k of K.keys) { ctx.fillStyle = `rgba(200,240,255,${k.life * 3})`; ctx.fillRect(L + k.u * w, T + k.v * h, w * 0.022, h * 0.014); }
    ctx.restore();
    for (const d of drops) if (d.desk === it) { const x = L + d.u * w + d.ox * u, y = T + d.v * h - d.z * u; ctx.fillStyle = `rgba(80,46,22,${0.85 * Math.min(1, d.life)})`; ctx.beginPath(); ctx.ellipse(x, y, u * 0.009, d.land ? u * 0.005 : u * 0.012, 0, 0, PI * 2); ctx.fill(); }
  }
  function drawFan(ctx, it, F, t) { // 電風扇：頭左右擺、葉片轉（嚇人時越轉越快）；底座不動
    const im = img(it.spr), { w, h, u } = F, L = -0.5 * w, T = -h, osc = Math.sin(st.fan.osc) * (0.7 + st.fan.boost * 0.2), cut = 0.5;
    ctx.drawImage(im, 0, im.height * cut, im.width, im.height * (1 - cut), L, T + h * cut, w, h * (1 - cut));
    const cx = 0, cy = T + h * 0.237, sx = Math.cos(osc) * 0.85 + 0.15;
    ctx.save(); ctx.translate(cx, cy); ctx.scale(sx, 1); ctx.translate(-cx, -cy);
    ctx.drawImage(im, 0, 0, im.width, im.height * cut, L, T, w, h * cut);
    const r = w * 0.36, spd = 1 + st.fan.boost * 2.5; ctx.globalCompositeOperation = 'source-over';
    for (let i = 0; i < 3; i++) { const a = st.fan.spin + i * 2 * PI / 3; ctx.strokeStyle = `rgba(235,230,210,${0.18 + 0.1 * Math.min(1, spd / 3)})`; ctx.lineWidth = r * 0.28; ctx.beginPath(); ctx.arc(cx, cy, r * 0.62, a, a + 0.5 + 0.35 * Math.min(1, spd / 3)); ctx.stroke(); }
    ctx.restore();
    if (st.fan.boost > 0.2) { ctx.save(); ctx.strokeStyle = `rgba(230,240,255,${0.35 * Math.min(1, st.fan.boost)})`; ctx.lineWidth = 1.5; for (let i = 0; i < 3; i++) { const q = (t * 2 + i / 3) % 1, x = -w * 0.6 - q * w * 1.5, y = cy + (i - 1) * h * 0.08; ctx.beginPath(); ctx.moveTo(x, y); ctx.quadraticCurveTo(x - w * 0.3, y + Math.sin(t * 8 + i) * 4, x - w * 0.6, y); ctx.stroke(); } ctx.restore(); }
  }
  function drawFreeChair(ctx, it, t) { // 阿福以前的椅子（背對我們）：被嚇會滑、會轉
    const ox = it.ox || 0, oz = it.oz || 0, [x, y] = P(it.x + ox, it.y + oz), u = U(it.y + oz);
    chairSprite(ctx, x, y, u, it.sw || 0, 0, 'of_chair_back', it.h, false);
  }
  // 椅子正面／背面：sw = 轉了幾度（0 = 原本的方向）；轉到背面就換另一張圖，寬度跟著 cos 變
  function chairSprite(ctx, x, y, u, sw, lean, front, hU, flipFront, anchorU) {
    const c = Math.cos(sw), useBack = c < 0, key = useBack ? (front === 'of_chair_back' ? 'of_chair_front' : 'of_chair_back') : front, im = img(key); if (!im) return;
    const h = hU * u, w = h * im.width / im.height, sx = Math.max(0.35, Math.abs(c)) * (Math.sin(sw) > 0 !== useBack ? 1 : 1);
    shadowAt(ctx, x, y, w * 0.85, 0.34);
    ctx.save(); ctx.translate(x, y); if (lean) { ctx.translate(0, -h * 0.4); ctx.rotate(lean); ctx.translate(0, h * 0.4); }
    ctx.scale(sx * ((flipFront && !useBack) || (!flipFront && useBack && front !== 'of_chair_back') ? -1 : 1), 1);
    const ax = anchorU != null ? (useBack ? 1 - anchorU : anchorU) : 0.5;
    ctx.drawImage(im, -ax * w, -h, w, h); ctx.restore();
  }
  // 阿Ken 的椅子（沒坐人的時候）
  function drawKenChair(ctx, _, t) {
    const ch = K.ch, [x, y] = P(SEATV.x + ch.dx, SEAT.y + ch.dz), u = U(SEAT.y + ch.dz);
    const bx = x; chairSprite(ctx, bx, y, u, ch.sw, 0, CHAIR.spr, CHAIR.h, true, 1 - CHAIR.back);
  }
  function drawFallen(ctx, c) { // 掉下來的東西（地板上排前後）：落地那一下「哐！」＋一圈灰
    const p = c.parent, F = frameOf(p), im = img(c.spr); if (!im) return; const G = c.falling, fv = p.floorV != null ? p.floorV : p.ay;
    const ch = c.h * F.u, cw = ch * im.width / im.height, sg = p.flip ? -1 : 1;
    const fx = F.x + sg * (c.u - p.ax) * F.w + G.x * F.u, fy = F.y + (fv - p.ay) * F.h + F.u * 0.03;
    if (G.z < 0.3) shadowAt(ctx, fx, fy, cw * 0.9, 0.25 * (1 - G.z / 0.3));
    ctx.save(); ctx.translate(fx, fy - G.z * F.u); ctx.rotate(c.rot); if (c.flip) ctx.scale(-1, 1); ctx.drawImage(im, -cw / 2, -ch * (G.off && G.z <= 0 ? 0.6 : 1), cw, ch); ctx.restore();
    if (G.land >= 0) { const q = (G.t - G.land) / 0.5; if (q < 1) { ctx.save(); ctx.strokeStyle = `rgba(220,210,190,${0.6 * (1 - q)})`; ctx.lineWidth = 2; ctx.beginPath(); ctx.ellipse(fx, fy, F.u * (0.08 + q * 0.12), F.u * (0.02 + q * 0.03), 0, 0, PI * 2); ctx.stroke(); text(ctx, fx, fy - F.u * (0.2 + q * 0.08), c.mug ? '鏘！' : c.spr === 'op_stack' ? '啪！' : '哐！', F.u * 0.13, 1 - q); ctx.restore(); } }
  }
  function drawFlying(ctx, p, t) {
    const im = img('op_paper_fly'); if (!im) return;
    const [x, y] = P(p.x, p.y), u = U(p.y), w = p.w * u * 1.3, h = w * im.height / im.width;
    shadowAt(ctx, x, y, w * 0.6 * Math.max(0.3, 1 - p.z), 0.18);
    ctx.save(); ctx.translate(x, y - p.z * u); ctx.rotate(p.rot); ctx.scale(Math.cos(p.t * 5 + p.ph), 1); ctx.drawImage(im, -w / 2, -h / 2, w, h); ctx.restore();
  }

  // ---------- 阿Ken 坐著 ----------
  // MeshAnim 網格（只給打字那張用：手一下一下敲，頭跟著點）
  function rig() {
    if (typeof MeshAnim === 'undefined' || MeshAnim.RIG[STN.base]) return;
    MeshAnim.RIG[STN.base] = { bones:STN.bones };
  }
  function seatH(u) { return SIT_H * u; }
  function drawKen(ctx, n, t) {
    const s0 = stnOf(n); if (!s0 || !s0.K) return { x:0, top:0, H:0 }; use(s0); rig();
    const ch = K.ch, [x, y] = P(SEATV.x + ch.dx, SEAT.y + ch.dz), u = U(SEAT.y), sw = ch.sw;
    const rx = n.rx && n.rx.t >= 0 ? n.rx : null;
    // 這一幀用哪張、怎麼擺
    let key = STN.base, lift = 0, sq = 1, rot = ch.lean, jx = 0, mesh = true, pose = {};
    const a = K.at, sc = Math.max(0.35, Math.abs(Math.cos(sw)));
    if (K.mode === 'sit') {
      if (K.act === 'stretch' && n.fear < 25) { const on = a > 0.3 && a < K.dur - 0.35; if (on) { key = STN.stretch; mesh = false; } sq = 1 + 0.04 * bump(a, 0.3, 0.6, 1.2) - 0.05 * (bump(a, 0.15, 0.3, 0.45) + bump(a, K.dur - 0.5, K.dur - 0.35, K.dur - 0.2)); lift = 0.02 * bump(a, 0.5, 1.3, 2.6); }
      else if (K.act === 'drink' && n.fear < 25) { const on = a > 0.45 && a < K.dur - 0.4; if (on) { key = STN.drink; mesh = false; rot -= 0.06 * bump(a, 1.0, 1.6, 2.8); } sq = 1 - 0.04 * (bump(a, 0.3, 0.45, 0.6) + bump(a, K.dur - 0.55, K.dur - 0.4, K.dur - 0.25)); }
      const type = K.act === 'type' && n.fear < 25;
      const tap = (s) => (rnd(Math.floor(t * 9 + s)) - 0.5) * 2;
      pose = { armF:(type ? 0.035 * tap(0) + 0.02 * Math.sin(t * 18) : 0.01 * Math.sin(t * 1.6)), head:(type ? 0.012 * Math.sin(t * 3.1) : 0.025 * Math.sin(t * 1.2)) + (n.fear >= 25 ? Math.sin(K.mt * 1.6) * 0.06 : 0), body:0.012 * Math.sin(t * 1.8), sy:1 + 0.01 * Math.sin(t * 1.8) };
      if (K.act === 'neck' && n.fear < 25) { // 轉脖子：頭慢慢畫一圈，肩膀往後一挺（網格變形）
        const e = ss(a / 0.4) * ss((K.dur - a) / 0.4), q = cl((a - 0.3) / 2.2) * 2 * PI;
        pose.head = (Math.sin(q) * 0.16 - 0.04) * e; pose.body = -0.05 * e * Math.sin(q * 0.5); pose.hair = Math.sin(q - 0.6) * 0.12 * e; pose.armF = 0.06 * e; sq *= 1 + 0.02 * e;
      }
      if (K.act === 'vibe' && n.fear < 25) { // 戴著耳機聽歌：邊打字邊跟著節拍點頭，馬尾甩
        const e = ss(a / 0.4) * ss((K.dur - a) / 0.4), beat = Math.abs(Math.sin(a * PI * 2.2));
        pose.head = (-0.05 * beat + 0.02) * e; pose.hair = 0.1 * Math.sin(a * PI * 2.2 - 0.8) * e; pose.armF = 0.03 * (rnd(Math.floor(t * 9)) - 0.5) * 2;
      }
      if (rx) { // 坐著的小反應：縮一下、聳肩、發呆
        const p = rx.t / rx.dur;
        if (rx.k === 'flinch') { sq = 1 - 0.06 * (1 - p); jx = (Math.random() - 0.5) * 3 * (1 - p); pose.head = -0.08 * (1 - p); }
        if (rx.k === 'rational') { const s = Math.sin(Math.min(1, rx.t / 0.55) * PI); sq = 1 + 0.04 * s; lift = 0.02 * s; }
      }
      if (n.fear >= 25 && n.fear < 50) jx += (Math.random() - 0.5) * 1.2;
    } else if (K.mode === 'jump') { // 彈起來（屁股離開椅子），腳還沒踩穩
      key = STN.jump; mesh = false; const p = K.mt / 0.62;
      lift = Math.sin(Math.min(1, p * 1.3) * PI) * 0.16 + (p < 0.12 ? -0.02 : 0); sq = p < 0.12 ? 0.92 : 1 + 0.08 * Math.sin(Math.min(1, p * 1.3) * PI);
      jx = (Math.random() - 0.5) * 2;
    } else if (K.mode === 'rise') { const p = K.mt / 0.34; rot -= 0.18 * Math.sin(p * PI * 0.5); lift = 0.04 * p; sq = 1 - 0.05 * Math.sin(p * PI); mesh = false; }
    else if (K.mode === 'sitdown') { const p = K.mt / 0.32; lift = 0.07 * (1 - ss(p)); sq = p > 0.6 ? 1 - 0.06 * Math.sin((p - 0.6) / 0.4 * PI) : 1; }
    if (K.pop > 0) sq *= 1 - 0.05 * Math.sin(K.pop / 0.18 * PI);
    // 椅子（坐著時在他後面；跳起來的那一下椅子已經滑走，另外畫）
    if (K.mode !== 'jump') chairSprite(ctx, x, y, u, sw, ch.lean, CHAIR.spr, CHAIR.h, true, 1 - CHAIR.back);
    const im = SPR[key]; if (!ok(key)) return { x, top:y - u };
    // 四張是同一個縮放比例打包的（pack.py SIT），所以照像素高度比就對了
    const S = SIT[key], H = seatH(u) * im.naturalHeight / SPR.npc_ken_sit.naturalHeight, W = H * im.naturalWidth / im.naturalHeight;
    // 屁股貼著椅背（椅背在畫面右邊）
    const bx = x, by = y - lift * u;
    // 螢幕光打在臉上
    const ml = monLight(monState(items[STN.mon]), t);
    const body = (clipArms) => {
      ctx.save(); ctx.translate(bx + jx, by); if (rot) { ctx.translate(0, -u * 0.28); ctx.rotate(rot); ctx.translate(0, u * 0.28); }
      ctx.scale(sc, sq);
      if (clipArms) { const A = STN.arms; ctx.beginPath(); ctx.rect(-S[0] * W + A[0] * W, -S[1] * H + A[1] * H, A[2] * W, A[3] * H); ctx.clip(); } // 手和前臂（放在鍵盤上，畫在桌子上面）
      if (mesh && typeof MeshAnim !== 'undefined' && key === STN.base) MeshAnim.draw(ctx, key, -(S[0] - 0.5) * W, (1 - S[1]) * H, H, pose, false);
      else ctx.drawImage(im, -S[0] * W, -S[1] * H, W, H);
      if (!clipArms && key === 'npc_ken_sit_coffee') steam(ctx, -S[0] * W + W * 0.28, -S[1] * H + H * 0.27, u, t);
      if (ml && K.mode !== 'jump') { // 螢幕光打在臉上（藍；雪花時白光亂閃）
        const gx = -S[0] * W + W * STN.face[0], gy = -S[1] * H + H * STN.face[1], R = u * 0.42, g = ctx.createRadialGradient(gx, gy, 0, gx, gy, R), a0 = 0.42 * ml[3];
        g.addColorStop(0, `rgba(${ml[0]},${ml[1]},${ml[2]},${a0})`); g.addColorStop(1, `rgba(${ml[0]},${ml[1]},${ml[2]},0)`); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(gx, gy, R, 0, PI * 2); ctx.fill(); }
      ctx.restore();
    };
    body(false);
    drawItem(ctx, items[STN.desk], t, 'base');                      // 桌子在他前面（擋住腿）
    if (key === STN.base && K.mode !== 'jump') body(true); // 打字的手在鍵盤上
    drawItem(ctx, items[STN.desk], t, 'kids');                      // 螢幕、杯子在最前面
    if (K.mode === 'sit' && K.act === 'stretch' && STN.stretchSay && a > 0.6 && a < 2.4) text(ctx, x - u * 0.78, y - u * 0.72, STN.stretchSay, u * 0.15, bump(a, 0.7, 0.9, 2.3));
    if (K.mode === 'sit' && K.act === 'drink' && STN.drinkSay && a > 0.9 && a < 3.0 && n.fear < 25) text(ctx, x - u * 0.62, y - u * 0.86, STN.drinkSay, u * 0.12, bump(a, 1.0, 1.3, 2.8));
    if (K.mode === 'sit' && K.act === 'vibe' && n.fear < 25) for (let i = 0; i < 2; i++) { const q = (a * 0.6 + i * 0.5) % 1; text(ctx, x - u * (0.05 - 0.1 * q) + i * u * 0.08, y - u * (0.9 + 0.2 * q), i ? '♫' : '♪', u * 0.12, Math.sin(q * PI) * ss(a / 0.5)); }
    if (K.mode === 'sit' && K.act === 'neck' && n.fear < 25) text(ctx, x - u * 0.7, y - u * 0.8, '喀', u * 0.11, bump(a, 1.2, 1.35, 1.7));
    return { x:x - u * 0.22, top:y - lift * u - seatH(u) * (key === STN.stretch ? 1.0 : 0.98), H:seatH(u) };
  }
  function steam(ctx, x, y, u, t) { ctx.save(); ctx.lineCap = 'round'; for (let i = 0; i < 2; i++) { const q = (t * 0.6 + i * 0.5) % 1; ctx.strokeStyle = `rgba(240,240,240,${0.5 * (1 - q)})`; ctx.lineWidth = u * 0.012; ctx.beginPath(); const sx = x + (i - 0.5) * u * 0.03; ctx.moveTo(sx, y - q * u * 0.05); ctx.bezierCurveTo(sx + u * 0.02, y - u * 0.05 - q * u * 0.1, sx - u * 0.02, y - u * 0.09 - q * u * 0.1, sx + Math.sin(t * 2 + i) * u * 0.015, y - u * 0.14 - q * u * 0.1); ctx.stroke(); } ctx.restore(); }
  function text(ctx, x, y, s, sz, a) { if (a <= 0.01) return; ctx.save(); ctx.globalAlpha *= cl(a); ctx.font = `900 ${Math.round(sz)}px sans-serif`; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = '#1a1020'; ctx.strokeText(s, x, y); ctx.fillStyle = '#fff3d0'; ctx.fillText(s, x, y); ctx.restore(); }

  // ---------- 美美：看指甲、自拍、整理頭髮和蝴蝶結、看到阿Ken／小晴經過就反白眼；貓步；嚇到東西全部飛出去 ----------
  const MIS_ACTS = [['copy', 2.4, [3, 5], 3], ['nails', 2.2, [3, 5], 0], ['selfie', 1.6, [3.2, 3.2], 7], ['hair', 1.3, [2.6, 2.6], 6], ['stand', 1, [1.5, 3], 0]];
  const MIS_SAY = { selfie:'唔該你哋行開少少，阻住我影相。', sigh:'陳總～人哋要放假啦～', roll:'呢啲嘢搵阿Ken做啦。' };
  function copyIdle() { if (st) st.copier.idle = Math.max(st.copier.idle || 0, 0.4); }
  function misTick(n, dt) {
    const s = n.mis = n.mis || { act:'stand', at:0, dur:2, cd:{}, jumpT:-1, rollT:-9 };
    const rx = n.rx && n.rx.t >= 0 ? n.rx : null, calm = !n.fleeing && n.fear < 25 && (!rx || rx.k === 'numb') && n.act !== 'walk';
    for (const k in s.cd) s.cd[k] -= dt; s.at += dt;
    if (!calm) { if (s.act !== 'stand') { s.act = 'stand'; s.at = 0; s.dur = 1; } }
    else {
      // 阿Ken／小晴經過（走路）：反白眼，偶爾酸一句
      const pass = (SC.npcs || []).find(m => m !== n && !m.gone && (m.d.k === 'ken' || m.d.k === 'it') && m.act === 'walk' && Math.hypot(m.x - n.x, m.y - n.y) < 0.2);
      if (pass && s.act !== 'roll' && (s.cd.roll || 0) <= 0) { s.act = 'roll'; s.at = 0; s.dur = 1.8; s.cd.roll = 9; s.rollAt = pass.x; if (Math.random() < 0.5 && SC.bubble) SC.bubble(n, MIS_SAY.roll, 2); }
      else if (s.at >= s.dur) {
        const opts = MIS_ACTS.filter(e => (s.cd[e[0]] || 0) <= 0 && e[0] !== s.act && (e[0] !== 'copy' || Math.hypot(n.x - (OFFMAP.SPOT.copier[0] + 0.16), n.y - (OFFMAP.SPOT.copier[1] + 0.05)) < 0.06)); /* 影印：要企喺影印機前面先做 */ if (!opts.length) opts.push(MIS_ACTS.find(q => q[0] === 'stand') || MIS_ACTS[0]); /* 全部動作冷卻中（例如啱啱影印完行開咗）：企住等，唔好爆 */ let r = Math.random() * opts.reduce((q, e) => q + e[1], 0), e = opts[0];
        for (const q of opts) { r -= q[1]; if (r <= 0) { e = q; break; } }
        s.act = e[0]; s.at = 0; s.dur = e[2][0] + Math.random() * (e[2][1] - e[2][0]); s.cd[e[0]] = e[3] + s.dur;
        if (SC.bubble && Math.random() < 0.35) SC.bubble(n, s.act === 'selfie' ? MIS_SAY.selfie : MIS_SAY.sigh, 2.2);
      }
    }
    const big = rx && (rx.k === 'startle' || rx.k === 'weakjump' || rx.k === 'burst');
    if (big && s.jumpT < 0) s.jumpT = 0; if (s.jumpT >= 0) { s.jumpT += dt; if (s.jumpT > 1.5 && !big) s.jumpT = -1; }
  }
  // scare.js drawNpc 呼叫：原點 = 腳底，身體的縮放已經套上去。回傳 true = 畫好了
  function drawMis(ctx, n, o, hh, right, t) {
    const s = n.mis; if (!s || typeof MeshAnim === 'undefined') return false;
    const H = hh * 62 / (64 * 1.08), A = MeshAnim.ANIM, fx = right ? 1 : -1;
    const draw = (key, pose) => { if (!ok(key)) return false; const h = H * SPR[key].naturalHeight / SPR.npc_mis.naturalHeight; return MeshAnim.draw(ctx, key, 0, 0, h, pose, right); };
    const phoneFx = SC.fx && SC.fx.find(f => f.kind === 'phone' && f.n === n && f.life > 0.8); // 先看到自拍鏡頭裡多了一張臉（0.8 秒），才嚇到跳起來
    // 嚇到：尖叫，手機、手袋、粉盒全部飛出去（原圖）＋粉撲的粉、亮片（程式畫）
    if (phoneFx && !o.run) { // 鬼騷擾她的自拍：鏡頭雜訊＋畫面裡多了一張臉
      const k = 1 - phoneFx.life / 1.6; draw('npc_mis_selfie', A.idle(t));
      const px = -fx * H * 0.17, py = -H * 0.83; ctx.save(); ctx.globalAlpha *= 0.5 + 0.5 * Math.random();
      if (typeof ART !== 'undefined' && ART.portrait) { const pc = ART.portrait('afu', 64, { tamed:true }); ctx.globalCompositeOperation = 'lighter'; const sz = H * 0.16; ctx.drawImage(pc, px - sz / 2 + (Math.random() - 0.5) * 3, py - sz / 2, sz, sz); }
      ctx.globalCompositeOperation = 'source-over'; for (let i = 0; i < 5; i++) { ctx.fillStyle = `rgba(${Math.random() < 0.5 ? '255,60,120' : '80,220,255'},.6)`; ctx.fillRect(px - H * 0.08, py - H * 0.08 + Math.random() * H * 0.16, H * 0.16, 1.5); }
      ctx.restore(); return true;
    }
    const fAge = n.fleeing && n.fleeT != null ? SC.t - n.fleeT - ((n.fleeHold || 0) - 0.4) : -1; // 嚇跑的那一下（鬼出手 → 衝出去之前）
    if (!phoneFx && ((fAge >= 0 && fAge < 0.55) || (!n.fleeing && s.jumpT >= 0 && s.jumpT < 1.3 && (o.pose === 'startle' || o.rxk === 'startle' || o.rxk === 'weakjump' || o.rxk === 'burst')))) {
      const key = 'npc_mis_jump'; if (!ok(key)) return false; const q = fAge >= 0 ? fAge : s.jumpT, up = Math.sin(Math.min(1, q / 0.6) * PI) * 0.12 * H, sq = q < 0.08 ? 0.9 : 1 + 0.06 * Math.sin(Math.min(1, q / 0.6) * PI);
      const im = SPR[key], h = H * im.naturalHeight / SPR.npc_mis.naturalHeight, w = h * im.naturalWidth / im.naturalHeight;
      ctx.save(); ctx.translate((Math.random() - 0.5) * 2, -up); ctx.scale(1 / sq, sq); ctx.scale(-fx, 1); // 原圖面朝左
      // 飛出去的東西在原圖左邊：整張圖輕輕往後彈一下
      ctx.drawImage(im, -w * 0.58, -h, w, h);
      const k = Math.min(1.2, q * 1.3), cx = -w * 0.58 + w * 0.06, cy = -h + h * 0.56;
      for (let i = 0; i < 10; i++) { const a = PI * (0.75 + rnd(i) * 0.6), r = H * (0.05 + 0.3 * k * (0.5 + rnd(i + 4))); ctx.fillStyle = `rgba(250,225,205,${Math.max(0, 0.6 - q * 0.45)})`; ctx.beginPath(); ctx.arc(cx + Math.cos(a) * r, cy + Math.sin(a) * r + 0.3 * H * k * k * rnd(i + 7), H * (0.02 + 0.03 * k), 0, PI * 2); ctx.fill(); }
      for (let i = 0; i < 8; i++) { const vx = -(0.1 + rnd(i + 11) * 0.4) * H, vy = -(0.2 + rnd(i + 13) * 0.35) * H, px = -w * 0.2 + vx * k, py = -h * 0.75 + vy * k + 0.8 * H * k * k; ctx.fillStyle = `rgba(255,${180 + (i % 3) * 30},220,${Math.max(0, 1 - q / 1.3)})`; ctx.save(); ctx.translate(px, py); ctx.rotate(t * 8 + i); ctx.fillRect(-H * 0.01, -H * 0.01, H * 0.02, H * 0.02); ctx.restore(); }
      ctx.restore(); return true;
    }
    if (o.run || o.walk) { // 貓步：屁股左右擺（網格）、整個人左右晃、小小彈；逃跑時跑得東歪西倒
      const sp = o.run ? 13 : 7, ph = t * sp, bob = Math.abs(Math.sin(ph)) * H * (o.run ? 0.04 : 0.015), sway = Math.sin(ph) * H * (o.run ? 0.01 : 0.025);
      const pz = { hips:Math.sin(ph) * 0.09, body:-Math.sin(ph) * 0.06 + (o.run ? 0.12 : 0), head:Math.sin(ph) * 0.04, legF:Math.sin(ph) * 0.18, legB:-Math.sin(ph) * 0.18, armB:Math.sin(ph - 0.8) * 0.18, armF:-Math.sin(ph) * 0.08, hairR:Math.sin(ph - 1.2) * 0.12, y:0 };
      ctx.save(); ctx.translate(sway, -bob); const r2 = draw('npc_mis_walk', pz); ctx.restore(); return r2;
    }
    if (n.fear >= 25 || n.rx) return false; // 害怕、發抖……：交給一般的網格動作（ART.drawChar）
    const z = A.idle(t), at = s.at, dur = s.dur, e = ss(at / 0.35) * ss((dur - at) / 0.35), pz = Object.assign({}, z); pz.armF = 0; pz.armB = 0;
    if (s.act === 'selfie') { const k = e, pose2 = Object.assign({}, pz, { head:0.05 * Math.sin(at * 2) * k, body:-0.03 * k, armB:0.06 * Math.sin(at * 7) * k });
      draw('npc_mis_selfie', pose2);
      const fl = (at % 1.1) < 0.12 && at > 0.6; if (fl) { const px = -fx * H * 0.17, py = -H * 0.83; ctx.save(); ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(px, py, 0, px, py, H * 0.25); g.addColorStop(0, 'rgba(255,255,255,.9)'); g.addColorStop(1, 'rgba(255,255,255,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(px, py, H * 0.25, 0, PI * 2); ctx.fill(); ctx.restore(); text(ctx, px, py - H * 0.12, '咔嚓', H * 0.08, 1); }
      return true; }
    if (s.act === 'nails') { const k = e, wig = Math.sin(at * 9) * bump(at, 0.6, 1.0, dur - 0.6); pz.head = (0.06 + 0.02 * Math.sin(at * 1.5)) * k; pz.armF = (-0.06 + 0.05 * wig) * k; pz.hips = 0.03 * k; draw('npc_mis', pz);
      if (Math.sin(at * 2.5) > 0.6) { const sx = -fx * H * 0.35, sy = -H * 0.86; ctx.save(); ctx.strokeStyle = 'rgba(255,240,170,.9)'; ctx.lineWidth = 1.6; ctx.beginPath(); ctx.moveTo(sx - 5, sy); ctx.lineTo(sx + 5, sy); ctx.moveTo(sx, sy - 5); ctx.lineTo(sx, sy + 5); ctx.stroke(); ctx.restore(); }
      return true; }
    if (s.act === 'copy') { // 在崗位上影印：手伸去按影印機，影印機亮
      const k = e, tap = bump(at % 1.6, 0.2, 0.4, 0.7); pz.armF = (-0.12 - 0.06 * tap) * k; pz.body = 0.03 * k; pz.head = 0.06 * k; draw('npc_mis', pz); if (at > 0.5) copyIdle(); return true; }
    if (s.act === 'hair') { const k = e * bump(at, 0.1, 0.6, 2.2), sw = Math.sin(at * 8) * bump(at, 0.4, 0.8, 1.8); pz.head = (-0.12 * k + 0.04 * sw); pz.hairR = -0.3 * k + 0.12 * sw; pz.body = -0.03 * k; pz.armB = -0.1 * k; draw('npc_mis', pz); return true; }
    if (s.act === 'roll') { // 反白眼：頭往後一仰、轉開，「哼」
      const k = bump(at, 0.1, 0.4, 1.6); pz.head = -0.16 * k; pz.body = -0.04 * k; pz.hairR = -0.15 * k; draw('npc_mis', pz);
      text(ctx, -fx * H * 0.3, -H * 1.02, '哼', H * 0.11, bump(at, 0.2, 0.4, 1.4));
      ctx.save(); ctx.strokeStyle = `rgba(40,30,60,${0.8 * k})`; ctx.lineWidth = 1.5; for (let i = 0; i < 3; i++) { const bx = fx * H * 0.12 + i * 4; ctx.beginPath(); ctx.moveTo(bx, -H * 0.95); ctx.lineTo(bx, -H * 0.88); ctx.stroke(); } ctx.restore();
      return true; }
    draw('npc_mis', pz); return true;
  }
  // 附身家具的點擊框（背景比例）
  function rectOf(id) {
    const it = items[id]; if (!it || !img(it.parent ? it.parent.spr : it.spr)) return null;
    const p = it.parent || it, F = frameOf(p), b = SC.bgScale(), toF = (px, py) => [(px - b.ox) / (b.iw * b.s), (py - b.oy) / (b.ih * b.s)];
    if (!it.parent) { const [x1, y1] = toF(F.x - it.ax * F.w, F.y - it.ay * F.h), [x2, y2] = toF(F.x + (1 - it.ax) * F.w, F.y + (1 - it.ay) * F.h); return [x1, y1, x2 - x1, y2 - y1]; }
    const im = img(it.spr), ch = it.h * F.u, cw = ch * im.width / im.height, cx = F.x - p.ax * F.w + it.u * F.w, cy = F.y - p.ay * F.h + it.v * F.h;
    const [x1, y1] = toF(cx - (it.ax == null ? 0.5 : it.ax) * cw, cy - ch), [x2, y2] = toF(cx + (1 - (it.ax == null ? 0.5 : it.ax)) * cw, cy); return [x1, y1, x2 - x1, y2 - y1];
  }
  return { elevator:() => { if (st) st.door = 1.8; }, offline:(k, v) => { if (STATIONS[k]) STATIONS[k].offline = !!v; }, drawMis, kenOff, init, tick, kenTick, onScare, onProp, drawBack, drawFloor, drawables, drawKen, drawDark, kenZ:(n) => { const s = stnOf(n); return s && items[s.desk] ? items[s.desk].z : (n ? n.y : 0.6); }, STATIONS, seated, clipWindow, rectOf, SEAT:STATIONS.ken.seat, items:() => items, K:(k) => STATIONS[k || 'ken'].K, AC, WIN, CLOCK };
})();
